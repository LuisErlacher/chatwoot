class Enterprise::Api::V1::AccountsController < Api::BaseController
  include BillingHelper
  before_action :fetch_account
  before_action :check_authorization
  before_action :check_cloud_env, only: [:limits, :toggle_deletion]

  def subscription
    if stripe_customer_id.blank? && @account.custom_attributes['is_creating_customer'].blank?
      @account.update(custom_attributes: { is_creating_customer: true })
      Enterprise::CreateStripeCustomerJob.perform_later(@account)
    end
    head :no_content
  end

  def limits
    plan_limits = get_account_plan_limits
    
    limits = {
      'conversation' => {
        'allowed' => plan_limits['max_conversations_per_month'] || 0,
        'consumed' => conversations_this_month(@account)
      },
      'non_web_inboxes' => {
        'allowed' => calculate_allowed_inboxes(plan_limits),
        'consumed' => non_web_inboxes(@account)
      },
      'agents' => {
        'allowed' => plan_limits['max_agents'] || 0,
        'consumed' => agents(@account)
      },
      'inboxes' => {
        'allowed' => plan_limits['max_inboxes'] || 0,
        'consumed' => total_inboxes(@account)
      },
      'captain' => @account.usage_limits[:captain]
    }

    # include id in response to ensure that the store can be updated on the frontend
    render json: { id: @account.id, limits: limits }, status: :ok
  end

  def checkout
    return create_stripe_billing_session(stripe_customer_id) if stripe_customer_id.present?

    render_invalid_billing_details
  end

  def toggle_deletion
    action_type = params[:action_type]

    case action_type
    when 'delete'
      mark_for_deletion
    when 'undelete'
      unmark_for_deletion
    else
      render json: { error: 'Invalid action_type. Must be either "delete" or "undelete"' }, status: :unprocessable_entity
    end
  end

  private

  def check_cloud_env
    render json: { error: 'Not found' }, status: :not_found unless ChatwootApp.chatwoot_cloud?
  end

  def get_account_plan_limits
    cloud_plans = InstallationConfig.find_by(name: 'CHATWOOT_CLOUD_PLANS')&.value || []
    plan_name = @account.custom_attributes['plan_name']
    
    # Default to Hacker plan if no plan is set
    if plan_name.blank?
      default_plan = cloud_plans.first || {}
      return {
        'max_agents' => default_plan['max_agents'] || 2,
        'max_conversations_per_month' => default_plan['max_conversations_per_month'] || 500,
        'max_inboxes' => default_plan['max_inboxes'] || 1,
        'inbox_types_allowed' => default_plan['inbox_types_allowed'] || ['Channel::Api']
      }
    end
    
    # Find the specific plan
    current_plan = cloud_plans.find { |plan| plan['name'] == plan_name }
    
    if current_plan
      {
        'max_agents' => current_plan['max_agents'] || 999,
        'max_conversations_per_month' => current_plan['max_conversations_per_month'] || 999999,
        'max_inboxes' => current_plan['max_inboxes'] || 999,
        'inbox_types_allowed' => current_plan['inbox_types_allowed'] || []
      }
    else
      # Fallback to default limits
      {
        'max_agents' => 2,
        'max_conversations_per_month' => 500,
        'max_inboxes' => 1,
        'inbox_types_allowed' => ['Channel::Api']
      }
    end
  end

  def calculate_allowed_inboxes(plan_limits)
    # For Hacker plan, only API channels are allowed
    allowed_types = plan_limits['inbox_types_allowed'] || []
    
    if allowed_types == ['Channel::Api']
      # Count only non-web inboxes for Hacker plan
      return [plan_limits['max_inboxes'] || 1, 0].max - web_inboxes(@account)
    else
      # For other plans, allow all non-web inboxes
      return plan_limits['max_inboxes'] || 999
    end
  end

  def total_inboxes(account)
    account.inboxes.count
  end

  def web_inboxes(account)
    account.inboxes.where(channel_type: 'Channel::WebWidget').count
  end

  def default_limits
    {
      'conversation' => {},
      'non_web_inboxes' => {},
      'agents' => {},
      'captain' => @account.usage_limits[:captain]
    }
  end

  def fetch_account
    @account = current_user.accounts.find(params[:id])
    @current_account_user = @account.account_users.find_by(user_id: current_user.id)
  end

  def stripe_customer_id
    @account.custom_attributes['stripe_customer_id']
  end

  def mark_for_deletion
    reason = 'manual_deletion'

    if @account.mark_for_deletion(reason)
      render json: { message: 'Account marked for deletion' }, status: :ok
    else
      render json: { message: @account.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def unmark_for_deletion
    if @account.unmark_for_deletion
      render json: { message: 'Account unmarked for deletion' }, status: :ok
    else
      render json: { message: @account.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def render_invalid_billing_details
    render_could_not_create_error('Please subscribe to a plan before viewing the billing details')
  end

  def create_stripe_billing_session(customer_id)
    session = Enterprise::Billing::CreateSessionService.new.create_session(customer_id)
    render_redirect_url(session.url)
  end

  def render_redirect_url(redirect_url)
    render json: { redirect_url: redirect_url }
  end

  def pundit_user
    {
      user: current_user,
      account: @account,
      account_user: @current_account_user
    }
  end
end

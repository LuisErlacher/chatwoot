class Enterprise::Billing::HandleStripeEventService
  CLOUD_PLANS_CONFIG = 'CHATWOOT_CLOUD_PLANS'.freeze

  # Plan hierarchy: Hacker (default) -> Startups -> Business -> Enterprise
  # Features are now dynamically loaded from the plan configuration

  def perform(event:)
    @event = event

    case @event.type
    when 'customer.subscription.updated'
      process_subscription_updated
    when 'customer.subscription.deleted'
      process_subscription_deleted
    else
      Rails.logger.debug { "Unhandled event type: #{event.type}" }
    end
  end

  private

  def process_subscription_updated
    plan = find_plan(subscription['plan']['product']) if subscription['plan'].present?

    # skipping self hosted plan events
    return if plan.blank? || account.blank?

    update_account_attributes(subscription, plan)
    update_plan_features
    reset_captain_usage
  end

  def update_account_attributes(subscription, plan)
    # https://stripe.com/docs/api/subscriptions/object
    account.update(
      custom_attributes: {
        stripe_customer_id: subscription.customer,
        stripe_price_id: subscription['plan']['id'],
        stripe_product_id: subscription['plan']['product'],
        plan_name: plan['name'],
        subscribed_quantity: subscription['quantity'],
        subscription_status: subscription['status'],
        subscription_ends_on: Time.zone.at(subscription['current_period_end'])
      }
    )
  end

  def process_subscription_deleted
    # skipping self hosted plan events
    return if account.blank?

    Enterprise::Billing::CreateStripeCustomerService.new(account: account).perform
  end

  def update_plan_features
    # Disable all features first
    disable_all_premium_features

    # Enable features for current plan (unless it's the default Hacker plan)
    unless default_plan?
      enable_features_for_current_plan
    end

    # Enable any manually managed features configured in internal_attributes
    enable_account_manually_managed_features

    account.save!
  end

  def disable_all_premium_features
    # Get all available features from all plans
    all_features = all_plan_features
    account.disable_features(*all_features) if all_features.any?
  end

  def enable_features_for_current_plan
    current_plan = find_current_account_plan
    return if current_plan.blank?

    # Enable features specific to this plan
    plan_features = current_plan['features'] || []
    account.enable_features(*plan_features) if plan_features.any?
  end

  def reset_captain_usage
    account.reset_response_usage
  end

  def subscription
    @subscription ||= @event.data.object
  end

  def account
    @account ||= Account.where("custom_attributes->>'stripe_customer_id' = ?", subscription.customer).first
  end

  def find_plan(plan_id)
    cloud_plans = InstallationConfig.find_by(name: CLOUD_PLANS_CONFIG)&.value || []
    cloud_plans.find { |config| config['product_id'].include?(plan_id) }
  end

  def find_current_account_plan
    plan_name = account.custom_attributes['plan_name']
    return nil if plan_name.blank?

    cloud_plans = InstallationConfig.find_by(name: CLOUD_PLANS_CONFIG)&.value || []
    cloud_plans.find { |plan| plan['name'] == plan_name }
  end

  def default_plan?
    cloud_plans = InstallationConfig.find_by(name: CLOUD_PLANS_CONFIG)&.value || []
    default_plan = cloud_plans.first || {}
    account.custom_attributes['plan_name'] == default_plan['name']
  end

  def all_plan_features
    cloud_plans = InstallationConfig.find_by(name: CLOUD_PLANS_CONFIG)&.value || []
    features = []
    
    cloud_plans.each do |plan|
      plan_features = plan['features'] || []
      features.concat(plan_features)
    end
    
    features.uniq
  end

  def enable_account_manually_managed_features
    # Get manually managed features from internal attributes using the service
    service = Internal::Accounts::InternalAttributesService.new(account)
    features = service.manually_managed_features

    # Enable each feature
    account.enable_features(*features) if features.present?
  end
end

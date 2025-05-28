# chore: improve plan-based feature handling with plan hierarchy (#11335)

#- Refactor HandleStripeEventService to better manage features by plan
#- Add constants for features available in each plan tier (Startup,
# Business, Enterprise)
#- Add channel_instagram to Startup plan features
#- Improve downgrade handling to properly disable higher-tier features
#- Clean up and optimize tests for maintainability
#- Add comprehensive test coverage for plan upgrades and downgrades

require 'administrate/field/base'

class ManuallyManagedFeaturesField < Administrate::Field::Base
  def data
    Internal::Accounts::InternalAttributesService.new(resource).manually_managed_features
  end

  def to_s
    data.is_a?(Array) ? data.join(', ') : '[]'
  end

  def all_features
    # Business and Enterprise plan features only
    Enterprise::Billing::HandleStripeEventService::BUSINESS_PLAN_FEATURES +
      Enterprise::Billing::HandleStripeEventService::ENTERPRISE_PLAN_FEATURES
  end

  def selected_features
    # If we have direct array data, use it (for rendering after form submission)
    return data if data.is_a?(Array)

    # Otherwise, use the service to retrieve the data from internal_attributes
    if resource.respond_to?(:internal_attributes)
      service = Internal::Accounts::InternalAttributesService.new(resource)
      return service.manually_managed_features
    end

    # Fallback to empty array if no data available
    []
  end
end

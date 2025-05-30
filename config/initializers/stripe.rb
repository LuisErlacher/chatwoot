require 'stripe'

# Use GlobalConfig for self-hosted environments, fallback to ENV for backward compatibility
# Only try to use GlobalConfig if it's available (after Rails has loaded)
if defined?(GlobalConfig)
  Stripe.api_key = GlobalConfig.get_value('STRIPE_SECRET_KEY') || ENV.fetch('STRIPE_SECRET_KEY', nil)
else
  Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY', nil)
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

Rails.logger.debug "ENV['STRIPE_SECRET_KEY'] = #{ENV['STRIPE_SECRET_KEY']}"

Rails.logger.debug "Rails.env = #{Rails.env}"

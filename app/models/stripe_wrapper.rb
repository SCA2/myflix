module StripeWrapper

  class Charge
    
    attr_reader :response, :error_message

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount:       options[:amount],
          currency:     options[:currency] || 'usd',
          source:       options[:source],
          description:  options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
        new(error_message: e.message)
      end      
    end
  
    def successful?
      @response && @response.status == 'succeeded'
    end
  end

  class Customer
    
    attr_reader :response, :error_message

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          email:        options[:email],
          plan:         options[:plan_id] || '1',
          source:       options[:source],
          description:  options[:description] || 'MyFlix Basic'
        )
        new(response: response)
      rescue Stripe::CardError => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
        new(error_message: e.message)
      end      
    end
  
    def successful?
      @response.present?
    end

    def customer_token
      @response.id
    end
  end

  class Event
    
    attr_reader :response, :error_message

    def initialize(response: nil, error_message: nil, id: nil)
      @id = id
      @response = response
      @error_message = error_message
    end

    def self.retrieve(options={})
      begin
        response = Stripe::Event.retrieve(
          options[:id]
        )
        new(response: response, id: options[:id])
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
        new(error_message: e.message)
      end      
    end
  
    def valid?
      @response && @response.id == @id
    end

    def object
      @response.data.object
    end

  end
end
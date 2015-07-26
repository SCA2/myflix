module Mailable

  extend  ActiveSupport::Concern
  
  include Tokenable

  def method_missing(method_sym, *arguments, &block)
    if method_match?(method_sym)
      send_mail(@method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_sym, include_private = false)
    method_match?(method_sym) || super
  end

  private

  def send_mail(column)
    generate_token("#{column}_token")
    eval "self.#{column}_sent_at = Time.zone.now"
    save!
    eval "UserMailer.delay.#{column}(self)"
  end

  def method_match?(symbol)
    if symbol.to_s =~ /^send_(.*)$/
      @method_name = $1
    end
  end

end

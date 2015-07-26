module Tokenable

  extend ActiveSupport::Concern

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
    eval "UserMailer.#{column}(self).deliver"
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end until unique_token?(column)
  end

  def method_match?(symbol)
    if symbol.to_s =~ /^send_(.*)$/
      @method_name = $1
    end
  end

  def unique_token?(column)
    !self.class.exists?(column => self[column])
  end

end

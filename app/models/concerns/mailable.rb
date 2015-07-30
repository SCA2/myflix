module Mailable

  extend  ActiveSupport::Concern
  
  include Tokenable

  def send_mail(mailer)
    token_column = "#{mailer}_token"
    sent_at_column = "#{mailer}_sent_at"
    if self.has_attribute?(token_column) && self.has_attribute?(sent_at_column)
      generate_token(token_column)
      self[sent_at_column] = Time.zone.now
      save!
      eval "UserMailer.#{mailer}(self).deliver"
    end
  end

end

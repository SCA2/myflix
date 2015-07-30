module Tokenable

  extend ActiveSupport::Concern

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end until unique_token?(column)
  end

  private 

  def unique_token?(column)
    !self.class.exists?(column => self[column])
  end

end

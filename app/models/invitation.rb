class Invitation < ActiveRecord::Base

  include Mailable

  belongs_to :user

  validates :email, uniqueness: true
  validates :email, :name, :message, presence: true

  def send_invitation
    send_mail('invitation')
  end

end

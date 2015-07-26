class Invitation < ActiveRecord::Base

  include Tokenable

  belongs_to :user

  validates :email, uniqueness: true
  validates :email, :name, :message, presence: true

end

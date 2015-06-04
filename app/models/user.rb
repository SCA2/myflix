class User < ActiveRecord::Base
  has_many  :reviews
  has_many  :queue_items
  validates_uniqueness_of :email
  validates_presence_of :email, :name
  has_secure_password
end
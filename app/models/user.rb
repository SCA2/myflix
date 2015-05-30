class User < ActiveRecord::Base
  validates_uniqueness_of :email
  has_secure_password validations: false
end
class Influence < ActiveRecord::Base
  belongs_to :user
  belongs_to :leader, class_name: 'User'

  validates :user, :leader, presence: true
  validates :leader, uniqueness: { scope: :user }
end

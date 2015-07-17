class Influence < ActiveRecord::Base
  belongs_to :leader, class_name: 'User', foreign_key: :leader_id
  belongs_to :follower, class_name: 'User', foreign_key: :follower_id

  validates :leader, :follower, presence: true
  validates :leader, uniqueness: { scope: :follower }

  validate  { errors.add(:base, "can't follow yourself") if leader == follower }

end

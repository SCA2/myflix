class Influence < ActiveRecord::Base
  belongs_to :leader, class_name: 'User', foreign_key: :leader_id
  belongs_to :follower, class_name: 'User', foreign_key: :follower_id

  validates :leader, :follower, presence: true
  validates :leader, uniqueness: { scope: :follower }

  validate  :leader_neq_follower

  def leader_neq_follower
    if leader == follower
      errors.add(:base, "can't follow yourself")
    end
  end

end

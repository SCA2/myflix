class User < ActiveRecord::Base
  has_many :reviews, -> { order created_at: :desc }
  has_many :queue_items, -> { order(order: :asc) }
  has_many :leader_influences, foreign_key: :follower_id, class_name: "Influence", dependent: :destroy
  has_many :follower_influences, foreign_key: :leader_id, class_name: "Influence", dependent: :destroy
  has_many :leaders, through: :leader_influences, source: :leader
  has_many :followers, through: :follower_influences, source: :follower
  
  validates_uniqueness_of :email
  validates_presence_of :email, :name
  
  has_secure_password

  def normalize_order
    queue_items.each_with_index do |item, index|
      item.update(order: index + 1)
    end
  end

  def next_item_order
    queue_items.count + 1
  end

  def update_queue(params)
    params.each do |param|
      queue_item = queue_items.find(param[:id])
      queue_item.user == self
      queue_item.update!(order: param[:order])
      queue_item.rating = param[:rating]
    end
  end

  def in_queue?(video)
    queue_items.any? { |i| i.video == video }
  end

  def gravatar
    url = "http://www.gravatar.com/avatar/"
    url += Digest::MD5.hexdigest(email.downcase)
    url += "?s=40"  #size = 40px?
  end

  def can_follow?(user)
    user != self && !leaders.include?(user)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end until unique?(column)
  end

  def unique?(column)
    !User.exists?(column => self[column])
  end

  def cleanup_password_reset
    update!(password_reset_token: nil, password_reset_sent_at: nil)
  end

end
class User < ActiveRecord::Base
  has_many  :reviews
  has_many  :queue_items, -> { order(order: :asc) }
  
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

end
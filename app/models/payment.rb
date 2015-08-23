class Payment < ActiveRecord::Base
  belongs_to :user

  def in_dollars
    amount / 100.0
  end
end
class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :video, touch: true

  attr_accessor :skip_rating_validation, :skip_body_validation

  validates_presence_of :rating, unless: :skip_rating_validation
  validates_presence_of :body, unless: :skip_body_validation

  delegate :title, to: :video, prefix: :video

end
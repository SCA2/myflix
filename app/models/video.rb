class Video < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to  :category
  has_many    :reviews, -> { order(created_at: :desc) }

  scope :sorted, -> { order(:title) }
  validates :title, :description, :category, presence: true

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(query)
    return [] if query.blank?
    where("title ILIKE ?", "%#{query}%").all.sorted
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }

    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << "reviews.body"
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
      search_definition[:sort] = { rating: 'desc' }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    self.as_json(
      methods: [:rating],
      only: [:title, :description],
      include: {
        reviews: { only: [:body] }
      }
    )
  end
end
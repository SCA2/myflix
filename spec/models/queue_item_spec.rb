require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:order).only_integer }
  it { should validate_numericality_of(:order).is_greater_than(0) }

  describe '#video_title' do
    it 'returns title of the associated video' do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe '#rating' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    it 'returns rating if review present' do
      review = Fabricate(:review, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq review.rating
    end
    it 'returns nil if no review present' do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq nil
    end
  end

  describe '#category_name' do
    it 'returns video category name' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq video.category.name
    end
  end

  describe '#category' do
    it 'returns video category' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq video.category
    end
  end
end
require 'spec_helper'

describe Category do

  it { should validate_presence_of(:name) }
  it { should have_many(:videos).order(:title) }

  it "retrieves categories in name order" do
    c = Category.create(name: 'Name c')
    b = Category.create(name: 'Name b')
    a = Category.create(name: 'Name a')
    expect(Category.all.sorted).to eq [a, b, c]
  end

  describe "#recent_videos" do
    
    let!(:category) { Fabricate(:category) }
    
    it "retrieves most recent 6 videos" do
      7.times { |n| Fabricate(:video, category: category, created_at: Time.now + n.seconds) }
      expect(category.recent_videos).not_to include(Video.first)
    end

    it "retrieves all videos if fewer than 6" do
      5.times { |n| Fabricate(:video, category: category, created_at: Time.now + n.days) }
      expect(category.recent_videos).to match_array(category.videos.all)
    end

    it "retrieves videos in reverse chronological order" do
      7.times { |n| Fabricate(:video, category: category, created_at: Time.now + n.days) }
      expect(category.recent_videos).to eq category.videos.reorder(created_at: :desc).first(6)
    end
  
    it "returns empty array if category is empty" do
      expect(category.recent_videos).to eq []
    end
  
  end

end
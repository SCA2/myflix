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
    it "retrieves most recent 6 videos" do
      t = Time.now
      c = Category.create!(name: "Test Category")
      7.times { |n| c.videos << Video.create!(title: "V#{n}", description: "D#{n}", created_at: t + n.days) }
      expect(c.recent_videos).not_to include(c.videos[0])
    end

    it "retrieves all videos if fewer than 6" do
      t = Time.now
      c = Category.create!(name: "Test Category")
      5.times { |n| c.videos << Video.create!(title: "V#{n}", description: "D#{n}", created_at: t + n.days) }
      expect(c.recent_videos).to match_array(c.videos.all)
    end

    it "retrieves videos in reverse chron order" do
      t = Time.now
      c = Category.create!(name: "Test Category")
      7.times { |n| c.videos << Video.create!(title: "V#{n}", description: "D#{n}", created_at: t + n.days) }
      expect(c.recent_videos).to eq c.videos.reorder(created_at: :desc).first(6)
    end
  
    it "returns empty array if category is empty" do
      c = Category.create!(name: "Test Category")
      expect(c.recent_videos).to eq []
    end
  
  end

end
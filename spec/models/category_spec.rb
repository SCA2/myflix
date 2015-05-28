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

  describe "recent_videos" do
    it "retrieves most recent 6 videos" do
      tc = Category.create!(name: "Test Category")
      7.times { |n| tc.videos << Video.create!(title: "Video #{n}", description: "Description #{n}") }
      expect(tc.recent_videos).to eq tc.videos.order(created_at: :desc)[0..5]
    end

    it "retrieves videos in reverse chron order" do
      tc = Category.create!(name: "Test Category")
      7.times { |n| tc.videos << Video.create!(title: "Video #{n}", description: "Description #{n}") }
      expect(tc.recent_videos).to eq tc.videos.order(created_at: :desc)[0..5].reverse
    end
  end

end
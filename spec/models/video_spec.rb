require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category) }

  let!(:category) { Fabricate(:category) }

  it "retrieves videos in title order" do
    c = Video.create(title: 'Title c', description: 'Description c', category: category)
    b = Video.create(title: 'Title b', description: 'Description b', category: category)
    a = Video.create(title: 'Title a', description: 'Description a', category: category)
    expect(Video.all.sorted).to eq [a, b, c]
  end

  describe "search_by_title" do
    it "returns empty array on no match" do
      expect(Video.search_by_title("non-existent title")).to eq []
    end
    
    it "returns one Video for exact match" do
      video = Video.create(title: 'Title', description: 'Description', category: category)
      expect(Video.search_by_title("Title")).to eq [video]
    end

    it "returns array of Videos for partial matches" do
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      expect(Video.search_by_title('Title')).to eq [a, b, c]
    end

    it "ignores case" do
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end

    it "returns array of Videos in title order" do
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end

    it "returns empty array for empty search string" do
      c = Video.create(title: 'Title c', description: 'Description c', category: category)
      b = Video.create(title: 'Title b', description: 'Description b', category: category)
      a = Video.create(title: 'Title a', description: 'Description a', category: category)
      expect(Video.search_by_title('')).to eq []
    end
  end
end
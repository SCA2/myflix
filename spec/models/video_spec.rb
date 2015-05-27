require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it "retrieves videos in title order" do
    c = Video.create(title: 'Title c', description: 'Description c')
    b = Video.create(title: 'Title b', description: 'Description b')
    a = Video.create(title: 'Title a', description: 'Description a')
    expect(Video.all.sorted).to eq [a, b, c]
  end

  describe "search_by_title" do
    it "returns empty array" do
      expect(Video.search_by_title("non-existent title")).to eq []
    end
    
    it "returns one Video" do
      video = Video.create(title: 'Title', description: 'Description')
      expect(Video.search_by_title("Title")).to eq [video]
    end

    it "ignores case" do
      video = Video.create(title: 'Title', description: 'Description')
      expect(Video.search_by_title("title")).to eq [video]
    end

    it "returns array of Videos" do
      a = Video.create(title: 'Title a', description: 'Description a')
      b = Video.create(title: 'Title b', description: 'Description b')
      c = Video.create(title: 'Title c', description: 'Description c')
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end

    it "returns array of Videos in order" do
      c = Video.create(title: 'Title c', description: 'Description c')
      b = Video.create(title: 'Title b', description: 'Description b')
      a = Video.create(title: 'Title a', description: 'Description a')
      expect(Video.search_by_title('title')).to eq [a, b, c]
    end
  end
end
require 'spec_helper'

describe Video do

  it "saves a video" do
    video = Video.create( title: 'Title',
                          description: 'Description',
                          small_cover_url: 'small_url',
                          large_cover_url: 'large_url',
                          category_id: 0 )
    expect(video).to eq(Video.first)
  end

  it "belongs to no category" do
    video = Video.create(title: 'Title')
    expect(video.category).to be_nil
  end

  it "belongs to one category" do
    video = Video.create(title: 'Title')
    video.category = Category.create(name: 'Name')
    expect(video.category).to be_nil
  end

end
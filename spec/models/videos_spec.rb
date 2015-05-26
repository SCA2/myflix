require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it "retrieves videos in title order" do
    c = Video.create(title: 'Title c', description: 'Description c')
    b = Video.create(title: 'Title b', description: 'Description b')
    a = Video.create(title: 'Title a', description: 'Description a')
    expect(Video.all).to eq [a, b, c]
  end

end
require 'spec_helper'

describe Category do

  it "saves a category" do
    category = Category.create(name: 'Name')
    expect(category).to eq(Category.first)
  end

  it "has no videos" do
    category = Category.create(name: 'Name')
    expect(category.videos).to eq(0)
  end

  it "has many videos" do
    category = Category.create(name: 'Name')
    category.videos << Video.create(title: 'Video 1')
    category.videos << Video.create(title: 'Video 2')
    expect(category.videos.count).to eq(2)
  end

end
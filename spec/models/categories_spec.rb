require 'spec_helper'

describe Category do

  it "saves a category" do
    category = Category.create(name: 'Name')
    expect(category).to eq(Category.first)
  end

end
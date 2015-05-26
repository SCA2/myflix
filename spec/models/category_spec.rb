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

end
require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }
  it { should have_many(:queue_items).order(:order) }

  describe '#in_queue?' do
    let(:user)        { Fabricate(:user) }
    let(:video)       { Fabricate(:video) }
    let(:queue_item)  { Fabricate(:queue_item, video: video) }

    it 'returns false if video not in queue_items' do
      expect(user.in_queue?(video)).to be false
    end

    it 'returns true if video in queue_items' do
      user.queue_items << queue_item
      expect(user.in_queue?(video)).to be true
    end
  end
end
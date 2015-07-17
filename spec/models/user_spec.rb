require 'spec_helper'

describe User do

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }
  it { should have_many(:queue_items).order(:order) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:leader_influences) }
  it { should have_many(:follower_influences) }
  it { should have_many(:leaders).class_name('User') }
  it { should have_many(:followers).class_name('User') }

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

  describe '#gravatar' do
    let(:user) { Fabricate(:user) }
    it 'generates a gravitar url' do
      expect(user.gravatar).to include("http://www.gravatar.com/avatar/")
    end
    it 'generates encoded email' do
      expect(user.gravatar).to include(Digest::MD5.hexdigest(user.email.downcase))
    end
  end
end
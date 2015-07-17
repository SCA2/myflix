require 'spec_helper'

describe Influence do

  it { should belong_to(:leader).class_name('User') }
  it { should belong_to(:follower).class_name('User') }
  it { should validate_presence_of(:leader) }
  it { should validate_presence_of(:follower) }

end

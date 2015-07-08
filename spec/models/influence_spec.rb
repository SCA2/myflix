require 'spec_helper'

describe Influence do

  it { should belong_to(:user) }
  it { should belong_to(:leader).class_name('User') }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:leader) }

end

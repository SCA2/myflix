require 'spec_helper'

describe Payment do

  it { should belong_to(:user) }

  describe "#in_dollars" do
    it "returns amount as dollars" do
      Payment.create(amount: 123)
      expect(Payment.last.in_dollars).to eq 1.23
    end
  end
end
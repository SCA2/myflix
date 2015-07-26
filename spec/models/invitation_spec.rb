require 'spec_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  describe '#send_invitation' do

    let(:user)        { Fabricate(:user) }
    let(:invitation)  { Fabricate(:invitation, user: user) }

    it 'generates a unique token each time' do
      invitation.send_invitation
      last_token = invitation.invitation_token
      invitation.send_invitation
      expect(invitation.invitation_token).to_not eq(last_token)
    end

    it 'saves the time the invitation reset was sent' do
      invitation.send_invitation
      expect(invitation.reload.invitation_sent_at).to be_present
    end

    it 'delivers email to invitee' do
      invitation.send_invitation
      expect(last_email.to).to include(invitation.email)
    end
  end



end
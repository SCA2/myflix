require 'spec_helper'

describe Invitation do
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it_behaves_like 'tokenable' do
    let(:object)  { Fabricate(:invitation) }
    let(:column)  { 'invitation_token' }
  end

  describe '#send_invitation' do

    let(:user)        { Fabricate(:user) }
    let(:invitation)  { Fabricate(:invitation, user: user) }

    it 'saves the time the invitation was sent' do
      invitation.send_invitation
      expect(invitation.reload.invitation_sent_at).to be_present
    end

    it 'delivers email to invitee' do
      invitation.send_invitation
      expect(last_email.to).to include(invitation.email)
    end
  end



end
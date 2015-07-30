class InvitationsController < ApplicationController

  before_action :authorize

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = current_user.invitations.build(invitation_params)
    if @invitation.save
      @invitation.send_invitation
      flash[:success] = "Invitation sent to #{@invitation.name}!"
      redirect_to new_invitation_path
    else
      flash[:error] = "Couldn't send invitation!"
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end

end
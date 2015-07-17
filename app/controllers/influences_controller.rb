class InfluencesController < ApplicationController

  before_action :authorize, only: [:index, :create, :destroy]

  def index
    @influences = current_user.leader_influences
  end

  def create
    @influence = current_user.leader_influences.build(leader_id: params.require(:id))
    if @influence.save
      flash[:notice] = "Following #{@influence.leader.name}"
    else
      flash[:notice] = "Can't follow that user!"
    end
    redirect_to people_path
  end

  def destroy
    @influence = current_user.leader_influences.find(params[:id])
    flash[:notice] = "No longer following #{@influence.leader.name}"
    @influence.destroy
    redirect_to people_path
  end

end
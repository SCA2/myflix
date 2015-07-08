class InfluencesController < ApplicationController

  before_action :authorize, only: [:index, :create, :destroy]

  def index
    @influences = current_user.influences
  end

  def create
    @influence = current_user.influences.build(leader_id: params[:id])
    if @influence.save
      flash[:notice] = "Following #{@influence.leader.name}"
    else
      flash[:notice] = "Can't follow that user!"
    end
    redirect_to current_user
  end

  def destroy
    @influence = current_user.influences.find(params[:id])
    flash[:notice] = "No longer following #{@influence.leader.name}"
    @influence.destroy
    redirect_to current_user
  end

  private

  def leader_params
    params.require(:id).merge!()
  end
end
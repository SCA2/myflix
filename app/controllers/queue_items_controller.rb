class QueueItemsController < ApplicationController

  before_action :authorize

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_item = QueueItem.new(queue_items_params)
    if queue_item.save
      flash[:notice] = "Video added to your queue!"
    else
      flash[:alert] = "Can't add that video to your queue!"
    end
    redirect_to queue_items_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user.queue_items.include?(queue_item)
      queue_item.destroy
      redirect_to queue_items_path
    else
      flash[:alert] = "Please sign in!"
      redirect_to sign_in_path
    end
  end

  private

  def queue_order
    current_user.queue_items.count + 1
  end

  def queue_items_params
    params.require(:queue_item).permit(:user_id, :video_id).merge(order: queue_order)
  end
end
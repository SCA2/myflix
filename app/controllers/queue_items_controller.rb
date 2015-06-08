class QueueItemsController < ApplicationController

  before_action :authorize

  def index
    @queue_items = current_user.queue_items
  end

  def create
    queue_item = QueueItem.new(item_params)
    if queue_item.save
      flash[:notice] = "Video added to your queue!"
    else
      flash[:alert] = "Can't add that video to your queue!"
    end
    redirect_to queue_items_path
  end

  def update_queue
    begin
      ActiveRecord::Base.transaction do
        current_user.update_queue(queue_params)
        current_user.normalize_order
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
      flash[:error] = "Invalid input"
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user.queue_items.include?(queue_item)
      queue_item.destroy
      current_user.normalize_order
      redirect_to queue_items_path
    else
      flash[:alert] = "Please sign in!"
      redirect_to sign_in_path
    end
  end

  private

  def item_params
    p = params.require(:queue_item).permit(:user_id, :video_id)
    p.merge(order: current_user.next_item_order)
  end

  def queue_params
    params.permit(queue_items: [:id, :order, :rating]).require(:queue_items)
  end

end
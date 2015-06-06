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
    ActiveRecord::Base.transaction do
      if errors? QueueItem.update(queue_params.keys, queue_params.values)
        flash[:error] = "Invalid list order"
        raise ActiveRecord::Rollback
      else
        current_user.normalize_order
      end
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

  def errors?(items)
    items.any? { |i| i.errors.any? || i.user != current_user }
  end

  def item_params
    p = params.require(:queue_item).permit(:user_id, :video_id)
    p.merge(order: current_user.next_item_order)
  end

  def queue_params
    params.require(:queue_item)
  end

end
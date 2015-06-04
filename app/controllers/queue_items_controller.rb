class QueueItemsController < ApplicationController

  before_action :authorize
  
  def index
    @queue_items = current_user.queue_items
  end
end
class ChatBansController < ApplicationController
  def index
    @connections = Chat.all_connections
  end

  def create
    Chat.ban params[:socket_id]
  end

  def destroy
    Chat.unban params[:socket_id]
  end
end

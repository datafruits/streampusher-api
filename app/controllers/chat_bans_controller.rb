class ChatBansController < ApplicationController
  def index
    authorize! :admin, :chats
    @connections = Chat.all_connections
  end

  def create
    authorize! :admin, :chats
    Chat.ban params[:socket_id]
  end

  def destroy
    authorize! :admin, :chats
    Chat.unban params[:socket_id]
  end
end

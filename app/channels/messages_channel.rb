class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # binding.pry
    user = User.find(params[:user])
    stream_for user

    # group = 1
    # stream_for group
    # stream_from "messages_channel"
  end

  def unsubscribed
  end
end

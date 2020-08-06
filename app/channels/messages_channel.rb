class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # binding.pry
  	puts " \n\n #{params[:user]} \n\n"
    user = User.find(params[:user])
    stream_for user

    # group = 1
    # stream_for group
    # stream_from "messages_channel"
  end

  def unsubscribed
  end
end

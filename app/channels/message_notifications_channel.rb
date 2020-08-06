class MessageNotificationsChannel < ApplicationCable::Channel
  def subscribed
  	puts " \n\n #{params[:user]} \n\n"
    user = User.find(params[:user])
    stream_for user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

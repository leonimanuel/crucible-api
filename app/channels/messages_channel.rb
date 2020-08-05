class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # puts "HIHIHIHIHIHIIHIHIHHIHIHIIHIHIHIHIHIHIH"
    # puts params[:discussion]
    user = User.find(params[:user])
    stream_for user
  end

  def unsubscribed
  end
end

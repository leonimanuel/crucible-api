class MessagesChannel < ApplicationCable::Channel
  def subscribed
    puts "HIHIHIHIHIHIIHIHIHHIHIHIIHIHIHIHIHIHIH"
    # puts params[:discussion]
    # discussion = Discussion.find(params[:discussion])
    # stream_for discussion
    stream_from "messages_channel"
  end

  def unsubscribed
  end
end

class MessagesChannel < ApplicationCable::Channel
  def subscribed
    discussion = Discussion.find(params[:discussion])
    stream_for discussion
  end

  def unsubscribed
  end
end

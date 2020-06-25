class MessagesController < ApplicationController
  def create
    # message = Message.new(message_params)
    # discussion = Discussion.find(message_params[:discussion_id])
    binding.pry
    user = @current_user
    message = Message.new(text: params[:text], discussion: params[:discussion_id], user: user)
    discussion = Discussion.find(params[:discussion_id])
    if message.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        MessageSerializer.new(message)
      ).serializable_hash
      MessagesChannel.broadcast_to discussion, serialized_data
      head :ok
    end
  end
  
  private
  
  # def message_params
  #   params.require(:message).permit(:text, :discussion_id, :user_id)
  # end
end

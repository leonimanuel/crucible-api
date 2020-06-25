class MessagesController < ApplicationController
  def create
    # message = Message.new(message_params)
    # discussion = Discussion.find(message_params[:discussion_id])
    # binding.pry
    user = @current_user

    discussion = Discussion.find(params[:discussion_id])    
    message = Message.new(text: params[:text], discussion: discussion, user: user)
    if message.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        MessageSerializer.new(message)
      ).serializable_hash
      puts "JUST SERIALIZED THAT DATA BIG BOI"
      MessagesChannel.broadcast_to discussion, serialized_data
      head :ok
    end
  end
  
  private
  
  # def message_params
  #   params.require(:message).permit(:text, :discussion_id, :user_id)
  # end
end

class MessagesController < ApplicationController
  skip_before_action :authenticate_request

  def create
    # message = Message.new(message_params)
    # discussion = Discussion.find(message_params[:discussion_id])
    # binding.pry
    # user = @current_user
    user = User.find(params[:userId])
    discussion = Discussion.find(params[:discussion_id])    
    message = Message.new(text: params[:text], discussion: discussion, user: user)
    # binding.pry
    if message.save
      recipients = message.discussion.users.select do |user|
        user.id != message.user_id
      end

      recipients.each do |recipient|
        MessagesUsersRead.create(message: message, discussion: discussion, user: recipient, read: false)
      end

      recipients.each do |recipient|
        DiscussionUnreadMessage.with_discussion_id(discussion.id).find_by(user_id: recipient.id).update(unread_messages: MessagesUsersRead.unread.with_user_id(recipient.id).with_discussion_id(discussion.id).count)
      end
      # binding.pry

      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        MessageSerializer.new(message)).serializable_hash
      # binding.pry
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

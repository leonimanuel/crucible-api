class MessagesController < ApplicationController
  # skip_before_action :authenticate_request

  def create
    user = User.find(params[:userId])
    discussion = Discussion.find(params[:discussion_id])    
    message = Message.new(text: params[:text], discussion: discussion, user: user)

    if message.save
      recipients = message.discussion.users_and_guests.select do |user|
        user.id != message.user_id
      end

      recipients.each do |recipient|
        MessagesUsersRead.create(message: message, discussion: discussion, user: recipient, read: false)
      end

      recipients.each do |recipient|
        DiscussionUnreadMessage.with_discussion_id(discussion.id).find_by(user_id: recipient.id).update(unread_messages: MessagesUsersRead.unread.with_user_id(recipient.id).with_discussion_id(discussion.id).count)
      end

      serialized_data = ActiveModelSerializers::Adapter::Json.new(MessageSerializer.new(message)).serializable_hash
      MessagesChannel.broadcast_to user, serialized_data
      head :ok

      serialized_notification_data = {
        discussion_id: discussion.id, 
        unread_messages: 1, 
        sender_id: user.id
      }
      discussion.users_and_guests.each do |user|
        MessageNotificationsChannel.broadcast_to user, serialized_notification_data
        head :ok
      end
      
      # ActionCable.server.broadcast "message_notifications_channel", serialized_notification_data
      # head :ok




      # serialized_data = {
      #   discussion_id: params[:discussion_id], 
      #   total_unreads: MessagesUsersRead.where(user: user, read: false).count,
      #   unread_messages: 0,
      #   user_id: user.id
      # }
      # ReadDiscussionChannel.broadcast_to user, serialized_data
      # head :ok

    end
  end
  
  def index
    user = @current_user
    @messages = Message.where(discussion_id: params[:discussion_id]).all

    MessagesUsersRead.unread.with_discussion_id(params[:discussion_id]).with_user_id(user.id).all.each do |entry|
      entry.update(read: true)
    end

    DiscussionUnreadMessage.with_discussion_id(params[:discussion_id]).with_user_id(user.id).first.update(unread_messages: 0)

    render json: @messages
  end
  private
  
  # def message_params
  #   params.require(:message).permit(:text, :discussion_id, :user_id)
  # end
end

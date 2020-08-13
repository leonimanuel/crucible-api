class CommentsController < ApplicationController
	def create
		# binding.pry
		user = @current_user
		discussion = Discussion.find(params[:discussion_id])

		comment = Comment.create(content: params[:comment_text], span_id: params[:span_id], 
			selection: params[:selection], startPoint: params[:start_offset], 
			endPoint: params[:end_offset], 
			previous_el_id: params[:previous_el_id],
			discussion: discussion,
			user: user
		)

		params[:factIds].each do |factId|
			fact = Fact.find(factId)
			comment.facts << fact
		end


    serialized_data = ActiveModelSerializers::Adapter::Json.new(
      CommentSerializer.new(comment)).serializable_hash
      ActionCable.server.broadcast "comments_channel", serialized_data
    head :ok
		# render json: CommentSerializer.new(comment).to_serialized_json

    message = Message.new(text: params[:comment_text], discussion: discussion, user: user, message_type: "comment", previous_el_id: params[:previous_el_id])
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

      serialized_data = ActiveModelSerializers::Adapter::Json.new(MessageSerializer.new(message)).serializable_hash
      discussion.users_and_guests.each do |user|
        MessagesChannel.broadcast_to user, serialized_data
        head :ok
      end        

      serialized_notification_data = {
        discussion_id: discussion.id, 
        unread_messages: 1, 
        sender_id: user.id
      }
      discussion.users_and_guests.each do |user|
        MessageNotificationsChannel.broadcast_to user, serialized_notification_data
        head :ok
      end
    end
	end

	def show
		# binding.pry
		if Group.find(params[:group_id]).users.include?(@current_user)
			discussion = Discussion.find(params[:id]) 
			render json: DiscussionSerializer.new(discussion).to_serialized_json			
		else
			render json: {error: "You must be a part of this group to view this discussion"}
		end

	end
end







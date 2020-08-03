class DiscussionUnreadMessagesController < ApplicationController
	def update
		# binding.pry
		user = @current_user
		# binding.pry

		MessagesUsersRead.unread.with_discussion_id(params[:discussion_id]).with_user_id(user.id).all.each do |entry|
			entry.update(read: true)
		end

		# PREVIOUS LINE HAS NO BEARING ON THIS NEXT ONE, BUT WILL WHEN MESSAGES ARE ADDED AGAIN
		# binding.pry
		DiscussionUnreadMessage.with_discussion_id(params[:discussion_id]).with_user_id(user.id).first.update(unread_messages: 0)

		# serialized_data = {discussion_id: params[:discussion_id], unread_messages: 0, sender_id: user.id}
		# ActionCable.server.broadcast "message_notifications_channel", serialized_data
		# head :ok

    serialized_data = {
    	discussion_id: params[:discussion_id], 
    	total_unreads: MessagesUsersRead.where(user: user, read: false).count,
    	unread_messages: 0,
    	user_id: user.id
    }
    ReadDiscussionChannel.broadcast_to user, serialized_data
    head :ok

		# render json: {discussion_id: params[:discussion_id], unread_messages: 0, sender_id: user.id}
	end
end

class DiscussionUnreadMessagesController < ApplicationController
	def update
		user = @current_user
		# binding.pry

		MessagesUsersRead.unread.with_discussion_id(params[:discussion_id]).with_user_id(params[:userId]).all.each do |entry|
			entry.update(read: true)
		end

		DiscussionUnreadMessage.with_discussion_id(params[:discussion_id]).with_user_id(params[:userId]).first.update(unread_messages: 0)
	end
end

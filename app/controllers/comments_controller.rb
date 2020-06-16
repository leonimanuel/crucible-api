class CommentsController < ApplicationController
	def create
		# binding.pry
		user = @current_user

		comment = Comment.create(content: params[:comment_text], discussion: Discussion.find(params[:discussion_id]))
		render json: CommentSerializer.new(comment).to_serialized_json
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

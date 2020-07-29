class GroupsController < ApplicationController
	def index
		user = @current_user
		@groups = user.groups
		render json: @groups, current_user_id: user.id	
	end

	def create
		user = @current_user
		@group = Group.new(name: params[:groupName], admin: user)
		if @group.valid?
			@group.save
			
			@group.users << user

			params[:memberIds].each do |memberId|
				user = User.find(memberId)
				@group.users << user
			end
		end

		render json: @group, current_user_id: user.id	
		# render json: GroupSerializer.new(group).to_serialized_json
	end

	def update
		# binding.pry
		user = @current_user
		@group = Group.find(params[:id])
		@group.update(name: params[:groupName])

		params[:removedMemberIds].each do |memberId| 
			user = User.find(memberId)
			@group.users.delete(user)
			# binding.pry
			DiscussionUnreadMessage.destroy(
				DiscussionUnreadMessage.where(user: user, discussion: @group.discussions).map {|dum| dum.id }
			)
		end
		
		params[:addedMemberIds].each do |memberId| 
			user = User.find(memberId) 
			@group.users << user
			@group.discussions.each do |discussion|
				DiscussionUnreadMessage.create(user: user, discussion: discussion, unread_messages: 0)
			end
	 	end

	
		render json: @group, current_user_id: user.id	
	end
end
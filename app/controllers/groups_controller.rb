class GroupsController < ApplicationController
	def index
		user = @current_user
		@groups = user.groups
		render json: @groups, current_user_id: user.id	
	end

	def create
		user = @current_user
		binding.pry
		@group = Group.new(name: params[:groupName], admin: user)
		# binding.pry
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
end
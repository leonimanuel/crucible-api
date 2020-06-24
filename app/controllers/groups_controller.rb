class GroupsController < ApplicationController
	def index
		user = @current_user
		groups = user.groups
		render json: GroupSerializer.new(groups).to_serialized_json
	end

	def create
		user = @current_user
		group = Group.new(name: params[:groupName])
		
		if group.valid?
			group.save
			params[:memberIds].each do |memberId|
				user = User.find(memberId)
				group.users << user
			end
		end

		render json: GroupSerializer.new(group).to_serialized_json
	end
end
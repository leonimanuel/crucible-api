class GroupsController < ApplicationController
	def index
		user = @current_user
		groups = user.groups
		render json: GroupSerializer.new(groups).to_serialized_json
	end
end
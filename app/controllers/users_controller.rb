class UsersController < ApplicationController
	def index
		users = User.all
		render json: {good?: "yea, good"}
	end

	def show
		# binding.pry
		user = @current_user # || User.find(1)
		render json: UserSerializer.new(user).to_serialized_json
		# render json: Topic.find(3).subtree.arrange_serializable
	end
end

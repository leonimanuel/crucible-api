class UsersController < ApplicationController
	def index
		users = User.all
		# binding.pry
		render json: UserSerializer.new(users).to_serialized_json
	end

	def show
		# binding.pry
		user = @current_user # || User.find(1)
		render json: UserSerializer.new(user).to_serialized_json
		# render json: Topic.find(3).subtree.arrange_serializable
	end

	def create
		# upon creation, automatically gets "NEW" folder
	end
end

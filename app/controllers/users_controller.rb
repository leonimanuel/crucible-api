class UsersController < ApplicationController
	def index
		binding.pry
		if request.headers["searchVal"]
			search_val = request.headers["searchVal"]
			users = User.where("name like ?", "%#{search_val}%").all 
		
		else
			users = User.all
		end

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

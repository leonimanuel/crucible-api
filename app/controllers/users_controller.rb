class UsersController < ApplicationController
	def index
		users = User.all
		render json: {good?: "yea, good"}
	end

	def show
		# binding.pry
		user = User.find(params[:id]) || @current_user
		render json: UserSerializer.new(user).to_serialized_json
	end
end

class UsersController < ApplicationController
	def index
		users = User.all
		render json: {good?: "yea, good"}
	end

	def show
		binding.pry
		user = User.find_by(email: params[:email])
		render json: UserSerializer.new(user).to_serialized_json
	end
end

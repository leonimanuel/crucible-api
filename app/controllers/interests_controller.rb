class InterestsController < ApplicationController
	def index
		user = @current_user
		@interests = Interest.all
		render json: @interests, current_user_id: user.id
	end

	# def create
	# 	user = @current_user
	# 	interest = user.interests.sample
		
	# end

	def update
		user = @current_user
		# binding.pry
		@interest = Interest.find(params[:id])
		if user.interests.include?(@interest)
			user.interests.delete(@interest)
		else
			user.interests << @interest
		end
		# binding.pry
		@interests = Interest.all
		render json: @interests, current_user_id: user.id
	end
end

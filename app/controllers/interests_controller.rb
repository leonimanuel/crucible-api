class InterestsController < ApplicationController
	def index
		user = @current_user
		@interests = Interest.all
		render json: @interests, current_user_id: user.id
	end

	def update
		user = @current_user
		# binding.pry
		@interest = Interest.find(params[:id])
		if user.interests.include?(@interest)
			user.interests.delete(@interest)
		else
			user.interests << @interest
		end

		@interests = Interest.all
		render json: @interests, current_user_id: user.id
	end
end

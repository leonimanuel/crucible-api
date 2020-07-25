class InterestsController < ApplicationController
	def index
		user = @current_user
		@interests = Interest.all
		render json: @interests, current_user_id: user.id
	end
end

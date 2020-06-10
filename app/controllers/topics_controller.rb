class TopicsController < ApplicationController
	def index
		# binding.pry
		user = @current_user # || User.find(1)
		render json: user.topics.arrange_serializable
	end
end

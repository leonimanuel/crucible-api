class TopicsController < ApplicationController
	def index
		user = @current_user
		render json: TopicSerializer.new(user.topics, user).to_serialized_json_tree
		# render json: 
	end

	def show
		# binding.pry
		topic = Topic.find(params[:id])
		render json: TopicSerializer.new(topic).to_serialized_json
	end
end

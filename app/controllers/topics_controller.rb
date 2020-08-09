class TopicsController < ApplicationController
	def index
		user = @current_user
		render json: TopicSerializer.new(user.topics, user).to_serialized_json_tree
	end

	def show
		topic = Topic.find(params[:id])
		render json: TopicSerializer.new(topic).to_serialized_json
	end

	def create
		topic = Topic.new(name: params[:topicName], user: @current_user)
		if topic.valid?
			if params[:parentId]
				parent_topic = Topic.find(params[:parentId])
				topic.parent = parent_topic
			end
			topic.save
			render json: TopicSerializer.new(topic, @current_user).to_serialized_json
		else
			render json: {error: "You already have a topic with this name"}
		end
	end
end

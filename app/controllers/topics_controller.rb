class TopicsController < ApplicationController
	def index
		user = @current_user || User.find(1)
		# binding.pry
		serialized_topic_tree = user.topics.arrange_serializable do |parent, children|
		  {
		    id: parent.id,
		    name: parent.name,
		    facts: parent.facts,
				created_at: parent.created_at,
				updated_at: parent.updated_at,
				user_id: 1,
				ancestry: parent.ancestry,
		    children: children
		  }
		end
		# binding.pry
		# render json: serialized_topic_tree
		# binding.pry
		render json: TopicSerializer.new(user.topics).to_serialized_json_tree
		# render json: 
	end

	def show
		# binding.pry
		topic = Topic.find(params[:id])
		render json: TopicSerializer.new(topic).to_serialized_json
	end
end

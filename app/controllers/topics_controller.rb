class TopicsController < ApplicationController
	def index
		user = @current_user || User.find(1)
		# binding.pry
		thing = user.topics.arrange_serializable do |parent, children|
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
		binding.pry
		render json: thing 
		# render json: TopicSerializer.new(user.topics.arrange_serializable).to_serialized_json
		# render json: 
	end

	def show
		# binding.pry
		topic = Topic.find(params[:id])
		render json: TopicSerializer.new(topic).to_serialized_json
	end
end

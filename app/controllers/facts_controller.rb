class FactsController < ApplicationController
	@@foribidden_domains = []

	def create
		user = @current_user
		# binding.pry
		if params[:origin_topic_name] && params[:destination_topic_name]
			@fact = Fact.find(params[:fact_id])
			origin_topic = user.topics.find_by(name: params[:origin_topic_name])
			destination_topic = user.topics.find_by(name: params[:destination_topic_name])

			origin_topic.facts.delete(@fact)
			destination_topic.facts << @fact

			render json: @fact, current_user_id: user.id
			# render json: TopicSerializer.new(user.topics).to_serialized_json_tree
			# render json: TopicSerializer.new(origin_topic.subtree).to_serialized_json_tree
			# render json: FactSerializer.new(fact).to_serialized_json
		elsif params[:factId]
			@fact = Fact.find(params[:factId])
			
			comment_author = User.find(params[:authorId]) 
			fact_grab = FactGrab.create(fact: @fact, grabber: user, giver: comment_author)

			current_giver = comment_author
			until current_giver == @fact.collector
				current_giver.increment!("reach_score", by = 50)
				current_giver = current_giver.fact_grabs.find_by(fact: @fact).giver
			end

			if current_giver == @fact.collector
				current_giver.increment!("reach_score", by = 100)
			end


			if user.facts.include?(@fact)
				render json: {error: "you've already collected this fact"}
			else
				topic = user.topics.find_by(name: "New Facts")
				topic.facts << @fact

				render json: @fact, topic_id: topic.id				
			end
		else
			# If adding manually through the app, which hasn't been implemented yet.
			# binding.pry
			user = @current_user
			# render json: {status: "success"}
			@fact = Fact.new(content: params[:selected_text], url: params[:selection_url], review_status: "pending", collector: user)
			if @fact.save
				if params[:rephrase] != ""
					FactRephrase.create(content: params[:rephrase], fact: @fact)
				end
				topic = user.topics.find_by(name: "New Facts")
				topic.facts << @fact

				# binding.pry				
				render json: @fact, topic_id: topic.id
      end
		end
	end

	def add_from_extension
		user = @current_user
		# render json: {status: "success"}
		fact = Fact.new(content: params[:selected_text], url: params[:selection_url], review_status: "pending", collector: user)
		if fact.save
			if params[:rephrase] != ""
				FactRephrase.create(content: params[:rephrase], fact: fact)
			end
			topic = user.topics.find_by(name: "New Facts")
			topic.facts << fact
			serialized_data = ActiveModelSerializers::Adapter::Json.new(FactSerializer.new(fact, {topic_id: topic.id})).serializable_hash
      MiscChannel.broadcast_to user, serialized_data
      head :ok

			# render json: {status: "success"}
		end
	end
end

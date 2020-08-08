class FactsController < ApplicationController
	@@foribidden_domains = []

	def create
		user = @current_user

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
			fact = Fact.find(params[:factId])
			
			if user.facts.include?(fact)
				render json: {error: "you've already collected this fact"}
			else
				topic = user.topics.find_by(name: "New Facts")
				topic.facts << fact
				render json: @fact, topic_id: topic.id				
			end
		else
			@fact = Fact.new(content: params[:selected_text], url: params[:selection_url], review_status: "pending", collector: user)
			if @fact.valid?
				@fact.save
				
				topic = user.topics.find_by(name: "New Facts")
				topic.facts << @fact 
				
				render json: @fact, topic_id: topic.id
			else				
				render json: {error: "could not save fact"}
			end			
		end
	end

	def add_from_extension
		user = @current_user
		# render json: {status: "success"}
		fact = Fact.new(content: params[:selected_text], url: params[:selection_url], review_status: "pending")
		if fact.save
			if params[:rephrase] != ""
				FactRephrase.create(content: params[:rephrase], fact: fact, user: user)
			end
			topic = user.topics.find_by(name: "New Facts")
			topic.facts << fact
			render json: {status: "success"}
		end
	end
end

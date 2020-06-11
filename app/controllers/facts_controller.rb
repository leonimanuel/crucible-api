class FactsController < ApplicationController
	def create
		user = @current_user

		if params[:origin_topic_name]
			fact = Fact.find(params[:fact_id])
			user.topics.find_by(name: params[:origin_topic_name]).facts.delete(fact)
			user.topics.find_by(name: params[:destination_topic_name]).facts << fact
			binding.pry
		else
			fact = Fact.new(content: params[:selected_text], url: params[:selection_url])
			if fact.valid?
				# binding.pry
				fact.save
				user.topics.find_by(name: "New Facts").facts << fact 
				render json: FactSerializer.new(fact).to_serialized_json
			else				
				render json: {error: "could not save fact"}
			end			
		end
	end
end

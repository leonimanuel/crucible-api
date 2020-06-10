class FactsController < ApplicationController
	def create
		# binding.pry
		fact = Fact.new(content: params[:selected_text], url: params[:selection_url])
		if fact.valid?
			# binding.pry
			fact.save
			user = @current_user
			user.topics.find_by(name: "New Facts").facts << fact 
			render json: FactSerializer.new(fact).to_serialized_json
		else				
			render json: {error: "could not save fact"}
		end
	end
end

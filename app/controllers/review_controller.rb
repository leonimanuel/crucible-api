class ReviewController < ApplicationController
	def index
		facts = Fact.pending_review.all

		# binding.pry
		render json: ReviewSerializer.new(facts).to_json
	end

	def create
		user = @current_user
		fact = Fact.find(params[:factId])

		if params[:reviewType] == "logic"
			# binding.pry
			if params[:decision] == "valid"
				fact.logic_upvotes += 1
				fact.save
			elsif params[:decision] == "invalid"
				fact.logic_downvotes += 1
				fact.save				
			end			
		end
	end
end

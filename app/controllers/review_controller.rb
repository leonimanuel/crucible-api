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

		fact_review = FactsReview.new(fact: fact, user: user, 
			review_type: params[:reviewType], decision: params[:decision])	

		if params[:decision] == "invalid"
			fact_review.decision_reason = params[:decision_reason]
			if params[:decision_reason == "other"]
				fact_review.decision_comment = params[:decision_comment]
			end
		end

		if fact_review.save
			render json: ReviewSerializer.new(fact).to_json			
		end
	end
end

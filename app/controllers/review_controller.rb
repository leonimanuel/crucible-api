class ReviewController < ApplicationController
	def index
		facts = Fact.pending_review.all

		# binding.pry
		render json: ReviewSerializer.new(facts).to_json
	end

	def create
		user = @current_user
		fact = Fact.find(params[:factId])

		# binding.pry
		if params[:decision] == "valid"
			fact["#{params[:reviewType]}_upvotes"] += 1
		elsif params[:decision] == "invalid"
			fact["#{params[:reviewType]}_downvotes"] += 1
		end
		# binding.pry		
		fact.save	

		fact_review = FactsReview.new(fact: fact, user: user, 
			review_type: params[:reviewType], review_result: params[:decision])	

		# if params[:decision] == "invalid"
		# 	fact_review.decision_reason = params[:decision_reason]
		# 	if params[:decision_reason == "other"]
		# 		fact_review.decision_comment = params[:decision_comment]
		# 	end
		# end

		if fact_review.save
			# binding.pry
			render json: ReviewSerializer.new([fact]).to_json			
		end
	end
end

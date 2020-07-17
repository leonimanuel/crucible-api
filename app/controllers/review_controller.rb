class ReviewController < ApplicationController
	def index
		facts = Fact.pending_review.all

		# binding.pry
		render json: ReviewSerializer.new(facts).to_json
	end

	def create
		user = @current_user

		# case params[:itemType]
		# when "fact"
		# 	item = Fact.find(params[:selectedItemId])
		# 	FactsReview.new(fact: fact, user: user, review_type: params[:reviewType], review_result: params[:decision])	
		# when "comment"
		# 	item = Comment.find(params[:selectedItemId])
		# when "facts_comment"
		# 	item = FactsComment.find(params[:selectedItemId])
		# end
		# binding.pry
		item = params[:itemType].constantize.find(params[:itemId])
		# binding.pry
		
		if params[:decision] == "valid"
			item["#{params[:reviewType]}_upvotes"] += 1
		elsif params[:decision] == "invalid"
			item["#{params[:reviewType]}_downvotes"] += 1
		end
		item.save	

		user_review = UsersReview.new(
			user: @current_user, 
			review_object: params[:itemType], 
			object_id: params[:itemId],
			review_type: params[:reviewType],
			decision: params[:decision]
		)
		# if params[:decision] == "invalid"
		# 	fact_review.decision_reason = params[:decision_reason]
		# 	if params[:decision_reason == "other"]
		# 		fact_review.decision_comment = params[:decision_comment]
		# 	end
		# end

		if user_review.save
			# binding.pry
			# render json: ReviewSerializer.new([item]).to_json	
			render json: {status: "success"}	
		end
	end
end

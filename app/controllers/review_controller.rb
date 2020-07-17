class ReviewController < ApplicationController
	def index
		facts = Fact.pending_review.all

		# binding.pry
		render json: ReviewSerializer.new(facts).to_json
	end

	def create
		user = @current_user

		item = params[:itemType].constantize.find(params[:itemId])

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

		if user_review.save
			render json: {status: "success"}	
		end
	end
end

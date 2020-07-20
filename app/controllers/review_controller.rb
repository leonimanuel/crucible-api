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

		keys = item.attributes.map do |key, value| 
			key if key.include?("votes")
		end
		keys = keys.compact

		score_reviews = keys.each_with_index.map do |attr, index| 
			if index.even?
				upvotes = item[keys[index]]
				downvotes = item[keys[index+1]]
				if upvotes > downvotes
					{total: upvotes + downvotes, status: "pass"}
				else
					{total: upvotes + downvotes, status: "fail"}
				end
			end
		end
		score_reviews = score_reviews.compact

		if score_reviews.all? { |review| review[:total] >= 10 }
			if score.reviews.all? { |review| review[:status] == "pass" }
				item.update(review_status: "pass")
			else
				item.update(review_status: "fail")
			end
		end
		
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
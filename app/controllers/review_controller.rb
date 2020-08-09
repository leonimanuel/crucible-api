class ReviewController < ApplicationController
	def index
		fact = Fact.pending_review.first

		# binding.pry
		render json: ReviewSerializer.new(fact).to_json, current_user_id: user.id	
	end

	def create
		user = @current_user
		item = params[:itemType].constantize.find(params[:itemId])
		# binding.pry
		user.increment!("daily_reviews", by = 1)
		if user.daily_reviews == 10
			user.increment!("daily_streaks", by = 1)
		end


		if params[:decision] == "valid"
			item["#{params[:reviewType]}_upvotes"] += 1
			user.total_upvotes += 1
			user.save
		elsif params[:decision] == "invalid"
			item["#{params[:reviewType]}_downvotes"] += 1
			user.total_downvotes += 1
			user.save			
		end
		item.save
		# binding.pry

		keys = item.attributes.map do |key, value| 
			key if key.include?("votes")
		end
		keys = keys.compact.sort

		item_upvotes = 0
		item_downvotes = 0
		score_reviews = keys.each_with_index.map do |attr, index| 
			if index.even?
				upvotes = item[keys[index + 1]]
				downvotes = item[keys[index]]

				item_upvotes += upvotes
				item_downvotes += downvotes
				if upvotes > downvotes
					{total: upvotes + downvotes, status: "pass"}
				else
					{total: upvotes + downvotes, status: "fail"}
				end
			end
		end
		score_reviews = score_reviews.compact

		# binding.pry
		if score_reviews.all? { |review| review[:total] >= 10 }
			if score_reviews.all? { |review| review[:status] == "pass" }
				item.update(review_status: "pass", grade: item_upvotes.to_f / (item_upvotes + item_downvotes))
			else
				item.update(review_status: "fail", grade: item_upvotes.to_f / (item_upvotes + item_downvotes))
			end
		end
		# binding.pry
		user_review = UsersReview.new(
			user: @current_user, 
			review_object: params[:itemType], 
			object_id: params[:itemId],
			review_type: params[:reviewType],
			decision: params[:decision]
		)



		if user_review.save
			# render json: {status: "success", daily_reviews: user.daily_reviews}	
			subject = User.find(params[:subjectId])
			serialized_data = {total_votes: subject.total_votes }
	    ReviewsChannel.broadcast_to subject, serialized_data
	    head :ok

	    reviewer_data = { daily_reviews: user.daily_reviews }
	    ReviewsChannel.broadcast_to user, reviewer_data
		end
	end
end

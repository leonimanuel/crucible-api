class ReviewController < ApplicationController
	def index
		facts = Fact.pending_review.all

		# binding.pry
		render json: ReviewSerializer.new(facts).to_json
	end
end

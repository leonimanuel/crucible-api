class RephrasesController < ApplicationController
	def create
		user = @current_user
		FactRephrase.create(content: params[:text], fact_id: params[:fact_id], user: user)
		
		@fact = Fact.find(params[:fact_id])

		render json: @fact, current_user_id: user.id
	end
end

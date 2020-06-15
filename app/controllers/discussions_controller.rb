class DiscussionsController < ApplicationController
	def create
		user = @current_user
		article_url = params[:article_url]

		response = Faraday.get "https://extractorapi.com/api/v1/extractor/?apikey=#{ENV["EXTRACTOR_KEY"]}&url=#{article_url}"
		binding.pry
		render json: response.body

	end
end

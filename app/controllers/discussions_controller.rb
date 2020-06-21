require 'aylien_text_api'
require "curb"

require 'net/http'
require 'uri'
require 'json'

class DiscussionsController < ApplicationController
	def create
		user = @current_user
		article_url = params[:article_url]

		# response = Faraday.get "https://extractorapi.com/api/v1/extractor/?apikey=#{ENV["EXTRACTOR_KEY"]}&url=#{article_url}&fields=clean_html"
		# json_response = JSON.parse(response.body)

# curl --verbose \
#        --user '35f5808325ea48adb080ab0f82a5c431':'' \
#        --header 'Content-Type: application/json' \
#        --data '[{"url": "http://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html", "pageType": "product"}]' \
#        --max-time 605 \
#        --compressed \
#        https://autoextract.scrapinghub.com/v1/extract

# 		c = Curl::Easy.perform("https://autoextract.scrapinghub.com/v1/extract") do |curl|
# 		  curl.verbose = true
# 		  curl.userpwd = "35f5808325ea48adb080ab0f82a5c431"
# 		  curl.headers["Content-Type"] = "application/json"
# 		  curl.data = '[{"url": "http://books.toscrape.com/catalogue/a-light-in-the-attic_1000/index.html", "pageType": "product"}]'
# 		end

# 		c.perform

		uri = URI.parse("https://autoextract.scrapinghub.com/v1/extract")
		request = Net::HTTP::Post.new(uri)
		request.basic_auth("35f5808325ea48adb080ab0f82a5c431", "")
		request.content_type = "application/json"
		request.body = JSON.dump([
		  {
		    "url" => "https://www.nytimes.com/2020/06/20/nyregion/trump-geoffrey-berman-fired-sdny.html",
		    "pageType" => "article",
		    "articleBodyRaw" => false
		  }
		])

		req_options = {
		  use_ssl: uri.scheme == "https",
		}

		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		  http.request(request)
		end

		boi = JSON.parse(response.body)
		json_response = boi[0]["article"]
		# binding.pry


		discussion = Discussion.create(name: json_response["headline"].split(" ").join("_"), group: Group.find(params[:group_id]), article_url: params[:article_url])
		article = Article.create(title: json_response["headline"], content: json_response["articleBodyHtml"], discussion: discussion)
		# # if article.valid?
		
		# # binding.pry
		render json: DiscussionSerializer.new(discussion).to_serialized_json
	end

	def show
		# binding.pry
		if Group.find(params[:group_id]).users.include?(@current_user)
			discussion = Discussion.find(params[:id]) 
			render json: DiscussionSerializer.new(discussion).to_serialized_json			
		else
			render json: {error: "You must be a part of this group to view this discussion"}
		end

	end
end

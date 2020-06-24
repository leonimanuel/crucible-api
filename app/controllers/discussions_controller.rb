require 'aylien_text_api'
require "curb"

require 'net/http'
require 'uri'
require 'json'

class DiscussionsController < ApplicationController
	def create
		user = @current_user
		article_url = params[:articleURL]
		binding.pry

		uri = URI.parse("https://autoextract.scrapinghub.com/v1/extract")
		request = Net::HTTP::Post.new(uri)
		request.basic_auth("35f5808325ea48adb080ab0f82a5c431", "")
		request.content_type = "application/json"
		request.body = JSON.dump([
		  {
		    "url" => article_url,
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
		binding.pry

		if json_response
			discussion = Discussion.create(name: json_response["headline"].split(" ").join("_"), group: Group.find(params[:group_id]), article_url: params[:article_url])
			article = Article.create(title: json_response["headline"], content: json_response["articleBodyHtml"], discussion: discussion)
			render json: DiscussionSerializer.new(discussion).to_serialized_json			
		end
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

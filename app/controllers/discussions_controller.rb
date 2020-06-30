require 'aylien_text_api'
require "curb"

require 'net/http'
require 'uri'
require 'json'

class DiscussionsController < ApplicationController
	def create
		user = @current_user
		article_url = params[:articleURL]

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

		if json_response
			discussion = Discussion.create(name: json_response["headline"].split(" ").join("_"), group: Group.find(params[:group_id]), article_url: params[:article_url])
			article = Article.create(
				title: json_response["headline"], 
				author: json_response["author"],
				date_published: json_response["datePublishedRaw"],
				content: json_response["articleBodyHtml"], 
				discussion: discussion
			)

			discussion.users.each do |d_user|
				DiscussionUnreadMessage.create(user: d_user, discussion: discussion, unread_messages: 0)
			end

			# binding.pry
			render json: DiscussionSerializer.new(discussion).to_serialized_json			
		end
	end

	def show
		group_name = params[:group_id].split("-").join(" ")
		discussion_name = params[:id]
		# binding.pry

		group = @current_user.groups.find_by(name: group_name)
		if group
			# binding.pry
			discussion = group.discussions.find_by(name: discussion_name) 
			render json: DiscussionSerializer.new(discussion).to_serialized_json			
		else
			render json: {error: "You must be a part of this group to view this discussion"}
		end

	end
end

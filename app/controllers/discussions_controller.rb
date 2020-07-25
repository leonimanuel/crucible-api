require 'aylien_text_api'
require "curb"

require 'net/http'
require 'uri'
require 'json'

class DiscussionsController < ApplicationController
	def create
		#GNEWS
		uri = URI('https://gnews.io/api/v3/search?q=uighur detention camps?&token=a3cbbbace66491b895eb064379755ca7')
		thing = Net::HTTP.get(uri) # => String
		suggestions = JSON.parse(thing)
		binding.pry


		#LATERAL
		# url = URI("https://news-api.lateral.io/documents/similar-to-text")

		# http = Net::HTTP.new(url.host, url.port)
		# http.use_ssl = true
		# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		# request = Net::HTTP::Post.new(url)
		# request["subscription-key"] = '8ea85e3047f340e51c58d0461c80e585'
		# request["content-type"] = 'application/json'
		# request.body = "{\"text\":\"politics\"}"

		# response = http.request(request)
		# binding.pry
		# puts response.read_body

		#SCRAPING HUB
		# user = @current_user
		# article_url = params[:articleURL]

		# uri = URI.parse("https://autoextract.scrapinghub.com/v1/extract")
		# request = Net::HTTP::Post.new(uri)
		# request.basic_auth("35f5808325ea48adb080ab0f82a5c431", "")
		# request.content_type = "application/json"
		# request.body = JSON.dump([
		#   {
		#     "url" => article_url,
		#     "pageType" => "article",
		#     "articleBodyRaw" => false
		#   }
		# ])

		# req_options = {
		#   use_ssl: uri.scheme == "https",
		# }

		# response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
		#   http.request(request)
		# end

		# boi = JSON.parse(response.body)
		# json_response = boi[0]["article"]

		# if json_response
		# 	@discussion = Discussion.create(name: json_response["headline"].split(" ").join("_"), group: Group.find(params[:group_id]), article_url: params[:article_url])
		# 	article = Article.create(
		# 		title: json_response["headline"], 
		# 		author: json_response["author"],
		# 		date_published: json_response["datePublishedRaw"],
		# 		content: json_response["articleBodyHtml"], 
		# 		discussion: @discussion
		# 	)

		# 	@discussion.users.each do |member|
		# 		DiscussionUnreadMessage.create(user: member, discussion: @discussion, unread_messages: 0)
		# 	end

		# 	render json: @discussion, current_user_id: user.id		
		# end
	end

	def show
		user = @current_user
		group_name = params[:group_id].split("-").join(" ")
		discussion_name = params[:id]

		group = @current_user.groups.find_by(name: group_name)
		if group
			@discussion = group.discussions.find_by(name: discussion_name) 
			# binding.pry
			# render json: @discussion, serializer(DiscussionSerializer)
			# binding.pry
			render json: @discussion, current_user_id: user.id		
			# render json: DiscussionSerializer.new(discussion).to_serialized_json			
		else
			render json: {error: "You must be a part of this group to view this discussion"}
		end

	end
end

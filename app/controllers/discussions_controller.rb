require 'aylien_news_api'
require "curb"

require 'net/http'
require 'uri'
require 'json'
require "rest-client"

class DiscussionsController < ApplicationController
	def createBOI
		AylienNewsApi.configure do |config|
		  # Configure API key authorization: app_id
		  config.api_key['X-AYLIEN-NewsAPI-Application-ID'] = '0d507a71'

		  # Configure API key authorization: app_key
		  config.api_key['X-AYLIEN-NewsAPI-Application-Key'] = '1357374853ea0c2ec00409cd29899ee5'
		end

		api_instance = AylienNewsApi::DefaultApi.new
		opts = {
	    # 'title': '"covid"',
	    # 'body': 'election',
	    'language': ['en'],
	    'published_at_start': 'NOW-7DAYS',
	    'published_at_end': 'NOW',
	    # "links_permalink": "http://www.washingtonpost.com/politics/trump-floats-idea-of-delaying-the-november-election-as-he-ramps-up-attacks-on-voting-by-mail/2020/07/30/15fe7ac6-d264-11ea-9038-af089b63ac21_story.html",
	    "source_domain": %w(csis.org brookings.edu rand.org),
	    'per_page': 5,
	    'sort_by': 'hotness'
		}

		begin
		  #List Clusters
		  result = api_instance.list_stories(opts)
		rescue AylienNewsApi::ApiError => e
		  puts "Exception when calling DefaultApi->list_clusters: #{e}"
		end
	end

	def create
		#GNEWS
		# uri = URI('https://gnews.io/api/v3/search?q=uighur detention camps?&token=a3cbbbace66491b895eb064379755ca7')
		# thing = Net::HTTP.get(uri) # => String
		# suggestions = JSON.parse(thing)
		user = @current_user
		
		if params[:extension]
			group = user.groups.find_by(name: params[:group_id])
		else
			group = Group.find(params[:group_id])
		end

		if group.name === "Feed"
			if user.interests.empty?
				return render json: { error: "please select at least one interest for article recommendations" }, status: :failed_dependency
			else
				interest = user.interests.sample
			end

			all_sites = %w(nytimes.com wsj.com washingtonpost.com bbc.com economist.com newyorker.com cfr.org theatlantic.com politico.com)
			sites = %w(nytimes.com wsj.com bbc.com economist.com newyorker.com cfr.org theatlantic.com usatoday.com slate.com salon.com cnn.com foxnews.com theintercept.com bloomberg.com thedailybeast.com)
			sites = %w(brookings.edu) # brookings.edu csis.org rand.org
			sites_query = sites.map { |domain| "site:#{domain}" }.join(" OR ")

			# uri = URI("https://gnews.io/api/v3/search?q=#{interest.query}&max=100&token=a3cbbbace66491b895eb064379755ca7")
			# thing = Net::HTTP.get(uri) # => String
			# suggestions = JSON.parse(thing)
			# sources = suggestions["articles"].map {|ar| ar["source"]["name"]}
			# article_url = suggestions["articles"].sample["url"]
			# textapi = AylienTextApi::Client.new(app_id: "0d507a71", app_key: "1357374853ea0c2ec00409cd29899ee5")
			# url = "http://techcrunch.com/2015/04/06/john-oliver-just-changed-the-surveillance-reform-debate"

			# extract = textapi.extract(url: url, best_image: true)

			res = RestClient.get("https://api.cognitive.microsoft.com/bing/v7.0/search?freshness=Day&q=#{interest.query} (#{sites_query})", headers={
				"Ocp-Apim-Subscription-Key": "b802d49bc8e247acac1a1fe236710554"
			})
			articles = JSON.parse(res)["webPages"]["value"]
			article_names = articles.map {|a| a["name"]}
			article_url = articles.map {|a| a["url"]}.sample
			# puts article_url
		else
			article_url = params[:articleURL]
		end
		# binding.pry

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
			@discussion = Discussion.create(
				name: json_response["headline"], 
				slug: json_response["headline"].slugify,
				group: group, 
				article_url: article_url,
				admin: user
			)
			
			article = Article.create(
				title: json_response["headline"], 
				author: json_response["author"],
				date_published: json_response["datePublishedRaw"],
				content: json_response["articleBodyHtml"], 
				discussion: @discussion
			)

			@discussion.users.each do |member|
				UsersGroupsUnreadDiscussion.create(user: member, group: @discussion.group, discussion: @discussion)				
			end

			if group.name == "Feed"
				guest = User.where.not(id: user.id).sample
				@discussion.guests << guest
				UsersGroupsUnreadDiscussion.create(user: guest, group: guest.groups.find_by(name: "Guest"), discussion: @discussion)
				# guest.groups.find_by(name: "Guest") << @discussion
			end

			@discussion.users_and_guests.each do |receiver|
				DiscussionUnreadMessage.create(user: receiver, discussion: @discussion, unread_messages: 0)
				if receiver != user && @discussion.group.name != "Feed"
					# ApplicationMailer.new_discussion(user, receiver, @discussion).deliver_now
				end
			end

			# @discussion.guests.each do |guest|
			# 	DiscussionUnreadMessage.create(user: guest, discussion: @discussion, unread_messages: 0)
			# end			
			if params[:extension]
				return render json: {slug: @discussion.slug}
			end			

			render json: @discussion, current_user_id: user.id		
		end
	end

	def show
		user = @current_user
		group_name = params[:group_id].split("-").join(" ")
		group = Group.find_by(name: group_name)
		# discussion_name = params[:id]
		# group = @current_user.groups.find_by(name: group_name)
		@discussion =  group.discussions.find_by(slug: params[:id])
		# binding.pry
		if user.groups.include?(@discussion.group) || @discussion.guests.include?(user)
			# render json: @discussion, serializer(DiscussionSerializer)
			ugud = UsersGroupsUnreadDiscussion.find_by(user: user, discussion: @discussion)
			# binding.pry
			if ugud.read == false
				ugud.update(read: true)	
			end
			
			render json: @discussion, current_user_id: user.id				
			# render json: DiscussionSerializer.new(discussion).to_serialized_json			
		else
			render json: {error: "You must be a part of this group to view this discussion"}
		end
	end

	def update
		user = @current_user		
		@discussion = Discussion.find(params[:id])
		guestIds = params[:memberIds]
		guestIds.each do |guestId|
			user = User.find(guestId)
			@discussion.guests << user
			DiscussionUnreadMessage.create(user: user, discussion: @discussion, unread_messages: 0)
			UsersGroupsUnreadDiscussion.create(user: user, group: user.groups.find_by(name: "Guest"), discussion: @discussion)			
		end
		# binding.pry
		render json: @discussion, current_user_id: user.id
	end
end









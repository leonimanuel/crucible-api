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

	def createGURL
		require 'uri'
		require 'net/http'
		require 'openssl'

		url = URI("https://full-text-rss.p.rapidapi.com/extract.php")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(url)
		request["x-rapidapi-host"] = 'full-text-rss.p.rapidapi.com'
		request["x-rapidapi-key"] = 'e95db40937mshaa3bb0066f2c48ap190307jsn62d857e3b282'
		request["content-type"] = 'application/x-www-form-urlencoded'
		request["url"] = "https://www.cnn.com/interactive/2019/02/business/starbucks-cup-problem/index.html"
		request.body = "parser=html5php&url=https://www.wired.com/story/why-wikipedia-decided-to-stop-calling-fox-a-reliable-source/"

		response = http.request(request)
		# puts response.read_body		
	end

	def create
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
			# sites = %w(brookasdfings.edu) # brookings.edu csis.org rand.org
			sites_query = sites.map { |domain| "site:#{domain}" }.join(" OR ")

			res = RestClient.get("https://api.cognitive.microsoft.com/bing/v7.0/search?freshness=Day&q=#{interest.query} (#{sites_query})", headers={
				"Ocp-Apim-Subscription-Key": "b802d49bc8e247acac1a1fe236710554"
			})
			articles = JSON.parse(res)["webPages"]["value"]
			article_names = articles.map {|a| a["name"]}
			article_url = articles.map {|a| a["url"]}.sample
		else
			article_url = params[:articleURL]
		end

		article = Article.find_by(url: article_url)
		if !article
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

			if json_response && json_response["articleBodyHtml"]
				article = Article.create(
					title: json_response["headline"], 
					author: json_response["author"],
					date_published: json_response["datePublishedRaw"],
					content: json_response["articleBodyHtml"],
					url: article_url 
					# discussion: @discussion
				)
			end			
		end

		if article
			@discussion = Discussion.create(
				name: article.title, 
				slug: article.title.slugify,
				group: group, 
				article_url: article_url,
				admin: user,
				article: article
			)
			
			# how come not guests too?
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
					ApplicationMailer.new_discussion(user, receiver, @discussion).deliver_now
				end
			
				serialized_data = ActiveModelSerializers::Adapter::Json.new(DiscussionSerializer.new(@discussion, {current_user_id: receiver.id})).serializable_hash
	      MiscChannel.broadcast_to receiver, serialized_data
	      head :ok	
			end

			# OLD
			# @discussion.guests.each do |guest|
			# 	DiscussionUnreadMessage.create(user: guest, discussion: @discussion, unread_messages: 0)
			# end			


			# if params[:extension]	
			# 	render json: {slug: @discussion.slug, discussion_id: @discussion.id}
			# else
			# 	render json: @discussion, current_user_id: user.id		
			# end		
		else
			serialized_data = {discussion: { error: "could not create discussion from this source"} }
      MiscChannel.broadcast_to user, serialized_data
      head :ok					
		end
	end

	def show
		user = @current_user
		discussion_id = params[:id].split("-").last.to_i

		@discussion =  Discussion.find(discussion_id)
		if user.groups.include?(@discussion.group) || @discussion.guests.include?(user)
			ugud = UsersGroupsUnreadDiscussion.find_by(user: user, discussion: @discussion)
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
			# MAILER GOES HERE !!!!
			DiscussionUnreadMessage.create(user: user, discussion: @discussion, unread_messages: 0)
			UsersGroupsUnreadDiscussion.create(user: user, group: user.groups.find_by(name: "Guest"), discussion: @discussion)			
		end

		render json: @discussion, current_user_id: user.id
	end
end









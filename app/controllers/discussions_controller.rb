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
		  config.api_key['X-AYLIEN-NewsAPI-Application-ID'] = ENV["AYLIEN_ID"]

		  # Configure API key authorization: app_key
		  config.api_key['X-AYLIEN-NewsAPI-Application-Key'] = ENV["AYLIEN_KEY"]
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
			article_urls = Article.get_article_rec_urls(interest.query)
			article_url = article_urls.sample
		else
			article_url = params[:articleURL]
		end

		article = Article.find_by(url: article_url)
		if !article
			article = Article.new_article_from_url(article_url, false, "misc")
		end

		if article && article.content
			article.save
			@discussion = Discussion.new_discussion(article, user, group)

			@discussion.users_and_guests.each do |receiver|
				serialized_data = ActiveModelSerializers::Adapter::Json.new(DiscussionSerializer.new(@discussion, {current_user_id: receiver.id})).serializable_hash
	      MiscChannel.broadcast_to receiver, serialized_data
	      head :ok	
			end
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









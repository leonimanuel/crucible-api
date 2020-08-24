desc "This task is called by the Heroku scheduler add-on"
task :reset_daily_reviews => :environment do
  puts "Resetting daily reviews..."
  User.reset_daily_reviews

  User.all.each do |user|
	  reviewer_data = { daily_reviews: user.daily_reviews }
	  ReviewsChannel.broadcast_to user, reviewer_data
	  head :ok    	
  end
  puts "done."
end



task :daily_news_discussion => :environment do
	rec_articles = Article.where(vetted: true)
	User.all.each do |user|
		group = user.groups.find_by(name: "Feed")
		if user.interests
			article = rec_articles.find {|a| a.interests.find {|i| user.interests.include?(i)}}    
			if article
				# create discussion from that article
				@discussion = Discussion.new_discussion(article, user, group)

				@discussion.users_and_guests.each do |receiver|
					serialized_data = ActiveModelSerializers::Adapter::Json.new(DiscussionSerializer.new(@discussion, {current_user_id: receiver.id})).serializable_hash
		      MiscChannel.broadcast_to receiver, serialized_data
		      head :ok	
				end
			else
				#create discussion from bing recommendation
			end
		end
	end
end



task :new_feed_discussion => :environment do
  User.all.each do |user|
  	if !user.interests.empty?
			interest = user.interests.sample
		else
			interest = Interest.all.sample
  	end

  	group = user.groups.find_by(name: "Feed")	
		
		sites = %w(nytimes.com wsj.com bbc.com economist.com newyorker.com cfr.org theatlantic.com usatoday.com slate.com salon.com cnn.com foxnews.com theintercept.com bloomberg.com thedailybeast.com)
		sites_query = sites.map { |domain| "site:#{domain}" }.join(" OR ")

		res = RestClient.get("https://api.cognitive.microsoft.com/bing/v7.0/search?freshness=Day&q=#{interest.query} (#{sites_query})", headers={
			"Ocp-Apim-Subscription-Key": "b802d49bc8e247acac1a1fe236710554"
		})
		articles = JSON.parse(res)["webPages"]["value"]
		article_names = articles.map {|a| a["name"]}
		article_url = articles.map {|a| a["url"]}.sample

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
			# binding.pry
			@discussion.users_and_guests.each do |receiver|
				DiscussionUnreadMessage.create(user: receiver, discussion: @discussion, unread_messages: 0)
				# if receiver != user && @discussion.group.name != "Feed"
				# 	ApplicationMailer.new_discussion(user, receiver, @discussion).deliver_now
				# end
			end
		end
  end
end
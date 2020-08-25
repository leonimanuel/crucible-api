class Article < ApplicationRecord
	# belongs_to :discussion
	has_many :discussions

	has_many :article_interests
	has_many :interests, through: :article_interests



	def self.new_article_from_url(article_url, vetted_bool, article_type)
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
			self.new(
				title: json_response["headline"], 
				author: json_response["author"],
				date_published: json_response["datePublishedRaw"],
				content: json_response["articleBodyHtml"],
				url: article_url ,
				vetted: vetted_bool,
				article_type: article_type
				# discussion: @discussion
			)
		end					
	end

	def self.get_article_rec_urls(interest_query)
		sites = %w(nytimes.com wsj.com bbc.com economist.com newyorker.com cfr.org theatlantic.com usatoday.com slate.com salon.com cnn.com foxnews.com theintercept.com bloomberg.com thedailybeast.com)
		# sites = %w(brookasdfings.edu) # brookings.edu csis.org rand.org
		sites_query = sites.map { |domain| "site:#{domain}" }.join(" OR ")

		res = RestClient.get("https://api.cognitive.microsoft.com/bing/v7.0/search?freshness=Day&count=3&q=#{interest_query} (#{sites_query})", headers={
			"Ocp-Apim-Subscription-Key": "b802d49bc8e247acac1a1fe236710554"
		})
		articles = JSON.parse(res)["webPages"]["value"]
		article_names = articles.map {|a| a["name"]}
		article_urls = articles.map {|a| a["url"]}
		# article_url = articles.map {|a| a["url"]}.sample

		return article_urls
	end
end

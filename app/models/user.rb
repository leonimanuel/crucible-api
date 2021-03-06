class User < ApplicationRecord
	validates :email, :uniqueness => {:case_sensitive => false}
	validates :handle, :uniqueness => {:case_sensitive => false}

	has_secure_password

	has_many :topics
	has_many :facts, through: :topics
	has_many :collected_facts, foreign_key: "collector_id", class_name: "Fact"

	has_many :users_groups
	has_many :groups, through: :users_groups
	has_many :admin_groups, foreign_key: "admin_id", class_name: "Group"	

	has_many :discussions, through: :groups

	has_many :admin_discussions, foreign_key: "admin_id", class_name: "Discussion"

	has_many :guests_guest_discussions
	has_many :guest_discussions, through: :guests_guest_discussions, source: :discussion

	has_many :comments
	has_many :messages

	has_many :topics_facts

	# has_many :fact_rephrases

	has_many :users_interests
	has_many :interests, through: :users_interests

	has_many :users_groups_unread_discussions

	has_many :fact_grabs, foreign_key: "grabber_id"
	has_many :fact_gives, class_name: "FactGrab", foreign_key: "giver_id"

	def name_with_last_initial
		"#{self.name} #{self.last_name[0]}."
	end

	def total_votes
		all_upvotes = self.total_upvotes
		all_downvotes = self.total_downvotes
		{
			tallies: {
				total_upvotes: all_upvotes,
				total_downvotes: all_downvotes
			},
			accuracy: (((all_upvotes + 0.0) / (all_upvotes + all_downvotes)) * 100).round(2)
		}
	end

	def self.reset_daily_streaks
		self.update_all(daily_reviews: 0, daily_facts_comments: 0)
	end

	def all_discussion_urls
		discussion_urls = self.discussions.map {|d| d.article.url}.compact.uniq
		guest_discussion_urls = self.guest_discussions.map {|d| d.article.url}.compact.uniq
		
		discussion_urls.concat(guest_discussion_urls).compact.uniq
	end
	# def total_votes
 #    items = [Fact.all, FactRephrase.all, Comment.all, FactsComment.all]
 #    obj_tallys = items.map do |item_array| 
 #      item_tallys = item_array.map do |item|
	# 			keys = item.attributes.map do |key, value| 
	# 				key if key.include?("votes")
	# 			end
	# 			keys = keys.compact.sort

	# 			item_upvotes = 0
	# 			item_downvotes = 0
	# 			score_reviews = keys.each_with_index.map do |attr, index| 
	# 				if index.even?
	# 					upvotes = item[keys[index + 1]]
	# 					downvotes = item[keys[index]]

	# 					item_upvotes += upvotes
	# 					item_downvotes += downvotes
	# 				end
	# 			end
	# 			{ item_upvotes: item_upvotes, item_downvotes: item_downvotes }    	
 #      end

 #      total_obj_upvotes = 0
 #      total_obj_downvotes = 0
 #      item_tallys.each do |item_tally|
 #      	total_obj_upvotes += item_tally[:item_upvotes]
 #      	total_obj_downvotes += item_tally[:item_downvotes]
 #      end
      
 #      {obj_upvotes: total_obj_upvotes, obj_downvotes: total_obj_downvotes}
 #    end	
    
 #    all_upvotes = 0
 #    all_downvotes = 0
 #    obj_tallys.each do |obj_tally|
 #    	all_upvotes += obj_tally[:obj_upvotes]
 #    	all_downvotes += obj_tally[:obj_downvotes]    	
 #    end

 #    {
 #    	tallies: { 
	#     	total_upvotes: all_upvotes, total_downvotes: all_downvotes 
	#     	}, 
	#     accuracy: (((all_upvotes + 0.0) / (all_upvotes + all_downvotes)) * 100).round(2)
 #    }
	# end
end

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

	def name_with_last_initial
		"#{self.name} #{self.last_name[0]}."
	end

	def total_votes
    items = [Fact.all, FactRephrase.all, Comment.all, FactsComment.all]
    obj_tallys = items.map do |item_array| 
      item_tallys = item_array.map do |item|
				keys = item.attributes.map do |key, value| 
					key if key.include?("votes")
				end
				keys = keys.compact.sort

				item_upvotes = 0
				item_downvotes = 0
				score_reviews = keys.each_with_index.map do |attr, index| 
					if index.even?
						upvotes = item[keys[index + 1]]
						downvotes = item[keys[index]]

						item_upvotes += upvotes
						item_downvotes += downvotes
					end
				end
				{ item_upvotes: item_upvotes, item_downvotes: item_downvotes }    	
      end

      total_obj_upvotes = 0
      total_obj_downvotes = 0
      item_tallys.each do |item_tally|
      	total_obj_upvotes += item_tally[:item_upvotes]
      	total_obj_downvotes += item_tally[:item_downvotes]
      end
      
      {obj_upvotes: total_obj_upvotes, obj_downvotes: total_obj_downvotes}
    end	
    
    all_upvotes = 0
    all_downvotes = 0
    obj_tallys.each do |obj_tally|
    	all_upvotes += obj_tally[:obj_upvotes]
    	all_downvotes += obj_tally[:obj_downvotes]    	
    end

    {
    	tallies: { 
	    	total_upvotes: all_upvotes, total_downvotes: all_downvotes 
	    	}, 
	    accuracy: (((all_upvotes + 0.0) / (all_upvotes + all_downvotes)) * 100).round(2)
    }
	end
end

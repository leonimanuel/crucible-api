class User < ApplicationRecord
	has_secure_password

	# has_many :facts_users
	# has_many :facts, through: :facts_users
	# has_many :fact_rephrases
	
	has_many :topics
	has_many :facts, through: :topics

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

	has_many :fact_rephrases

	has_many :users_interests
	has_many :interests, through: :users_interests

	has_many :users_groups_unread_discussions

	def name_with_last_initial
		"#{self.name} #{self.last_name[0]}."
	end
end

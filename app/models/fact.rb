class Fact < ApplicationRecord
	has_many :facts_users
	has_many :users, through: :facts_users

	has_many :topics_facts
	has_many :topics, through: :topics_facts
end

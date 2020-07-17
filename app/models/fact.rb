class Fact < ApplicationRecord
	has_many :fact_rephrases

	has_many :facts_users
	has_many :users, through: :facts_users

	has_many :topics_facts
	has_many :topics, through: :topics_facts

	has_many :facts_comments
	has_many :comments, through: :facts_comments



  scope :pending_review, -> { where(review_status: "pending") }
end

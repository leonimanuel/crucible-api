class Topic < ApplicationRecord
	has_ancestry

	belongs_to :user

	has_many :topics_facts
	has_many :facts, through: :topics_facts

	# has_many :topics_subtopics
	# has_many :subtopics, through: :topics_subtopics
end

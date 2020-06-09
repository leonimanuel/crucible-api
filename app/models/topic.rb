class Topic < ApplicationRecord
	belongs_to :user

	has_many :topics_facts
	has_many :facts, through: :topics_facts
end

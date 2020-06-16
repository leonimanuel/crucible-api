class Comment < ApplicationRecord
  belongs_to :discussion

	has_many :facts_comments
	has_many :facts, through: :facts_comments
end

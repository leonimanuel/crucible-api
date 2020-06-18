class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

	has_many :facts_comments
	has_many :facts, through: :facts_comments
end

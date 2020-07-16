class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

	has_many :facts_comments
	has_many :facts, through: :facts_comments


  scope :pending_review, -> { where(review_status: "pending") }
end

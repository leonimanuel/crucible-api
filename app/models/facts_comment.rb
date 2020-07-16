class FactsComment < ApplicationRecord
  belongs_to :fact
  belongs_to :comment

  scope :pending_review, -> { where(review_status: "pending") }
end

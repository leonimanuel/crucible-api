class FactRephrase < ApplicationRecord
  belongs_to :fact
  belongs_to :user
  
  scope :pending_review, -> { where(review_status: "pending") }
end

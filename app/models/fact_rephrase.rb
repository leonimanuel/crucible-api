class FactRephrase < ApplicationRecord
  belongs_to :fact  
  scope :pending_review, -> { where(review_status: "pending") }
end

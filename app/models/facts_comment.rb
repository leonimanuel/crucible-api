class FactsComment < ApplicationRecord
  belongs_to :fact
  belongs_to :comment
end

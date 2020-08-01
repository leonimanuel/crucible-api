class Briefing < ApplicationRecord
  has_many :interests_briefings
  has_many :interests, through: :interests_briefings
end

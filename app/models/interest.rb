class Interest < ApplicationRecord
	has_many :users_interests
	has_many :users, through: :users_interests

	has_many :interests_briefings
  has_many :briefings, through: :interests_briefings	
end

class FactGrab < ApplicationRecord
	belongs_to :fact
	belongs_to :user, foreign_key: "grabber_id"
	belongs_to :user, foreign_key: "giver_id"	
end

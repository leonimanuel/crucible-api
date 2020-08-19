class FactGrab < ApplicationRecord
	belongs_to :fact
	belongs_to :grabber, class_name: "User", foreign_key: "grabber_id"
	belongs_to :giver, class_name: "User", foreign_key: "giver_id"	
end

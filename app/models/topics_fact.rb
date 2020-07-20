class TopicsFact < ApplicationRecord
	belongs_to :topic
	belongs_to :fact
	# belongs_to :user
end

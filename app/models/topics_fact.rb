class TopicsFact < ApplicationRecord
	belongs_to :topic
	belongs_to :fact
end

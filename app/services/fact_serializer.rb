class FactSerializer
	def initialize(topic_object)
		@topic = topic_object
	end

	def to_serialized_json
		options = {
			include: {
				topics: {
					except: [:user_id]
				}
			}
		}
		# binding.pry
		@topic.to_json(options)
	end
end
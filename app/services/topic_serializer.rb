class TopicSerializer
	def initialize(topic_object)
		@topic = topic_object
	end

	def to_serialized_json
		options = {
			include: {
				facts: {
					except: [:user_id]
				}
			}
		}
		# binding.pry
		@topic.to_json(options)
	end

	def to_serialized_json_tree
		serialized_topic = @topic.arrange_serializable do |parent, children|
		  {
		    id: parent.id,
		    name: parent.name,
		    facts: parent.facts,
				created_at: parent.created_at,
				updated_at: parent.updated_at,
				user_id: 1,
				ancestry: parent.ancestry,
		    root: parent.root,
		    children: children
		  }
		end
		# binding.pry
		return serialized_topic
	end
end




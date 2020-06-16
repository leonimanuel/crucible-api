class DiscussionSerializer
	def initialize(discussion_object)
		@discussion = discussion_object
	end

	def to_serialized_json
		options = {
			include: {
				article: {
					except: [:updated_at]
				},
				comments: {
					except: [:updated_at]
				}
			}
		}
		@discussion.to_json(options)
	end
end
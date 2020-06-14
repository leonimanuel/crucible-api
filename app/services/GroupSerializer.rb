class GroupSerializer
	def initialize(group_object)
		@group = group_object
	end

	def to_serialized_json
		options = {
			include: {
				discussions: {
					except: [:updated_at]
				},
				users: {
					except: [:password]
				}
			}
		}
		# binding.pry
		@group.to_json(options)
	end
end
class UserSerializer
	def initialize(user_object)
		@user = user_object
	end

	def to_serialized_json
		options = {
			include: {
				topics: {
					include: {
						facts: {
							except: [:updated_at, :user_id]
						}
					},
					except: [:user_id]
				}
			},
			except: [:updated_at, :created_at, :password_digest]
		}
		# binding.pry
		@user.to_json(options)
	end

	def to_serialized_json_lite
		options = {
			except: [:updated_at, :created_at, :password_digest]
		}
		# binding.pry
		@user.to_json(options)
	end
end
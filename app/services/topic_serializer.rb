class TopicSerializer
	def initialize(topic_object, user)
		@topic = topic_object
		@user = user
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
		    # facts: parent.facts.collect do |fact|
		    # 	{
		    # 		id: fact.id,
		    # 		content: fact.content,
		    # 		rephrase: fact.fact_rephrases.where(user: @user).last,
		    # 		logic_upvotes: fact.logic_upvotes,
		    # 		logic_downvotes: fact.logic_downvotes,
		    # 		context_upvotes: fact.context_upvotes,
		    # 		context_downvotes: fact.context_downvotes,
		    # 		credibility_upvotes: fact.credibility_upvotes,
		    # 		credibility_downvotes: fact.credibility_downvotes,
		    # 		review_status: fact.review_status
		    # 	}
		    # end,
				created_at: parent.created_at,
				updated_at: parent.updated_at,
				user_id: 1,
				ancestry: parent.ancestry,
		    root: parent.root,
		    path: parent.path,
		    children: children
		  }
		end
		# binding.pry
		return serialized_topic
	end
end




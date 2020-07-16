class ReviewSerializer < ActiveModel::Serializer
	# attributes :id, :content, :url
	has_many :facts

	def facts
		# binding.pry
		object.collect do |fact|
			{	
				id: fact.id,
				content: fact.content,
				url: fact.url,
				logic_upvotes: fact.logic_upvotes,
				logic_downvotes: fact.logic_downvotes,
				context_upvotes: fact.context_upvotes,
				context_downvotes: fact.context_downvotes,
				credibility_upvotes: fact.credibility_upvotes,
				credibility_downvotes: fact.credibility_downvotes			
			}
		end
	end
end
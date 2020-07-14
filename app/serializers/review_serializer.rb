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
				logic_downvotes: fact.logic_downvotes
			}
		end
	end
end
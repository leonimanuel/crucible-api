class ReviewSerializer < ActiveModel::Serializer
	# attributes :id, :content, :url
	has_many :facts
	has_many :comments
	has_many :facts_comments

	def facts
		# binding.pry
		object.collect do |fact|
			{	
				type: "fact",
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

	def comments
		Comment.pending_review.all.collect do |comment|
			{	
				type: "comment",
				id: comment.id,
				selection: comment.selection,
				content: comment.content,
				selection_comment_upvotes: comment.selection_comment_upvotes,
				selection_comment_downvotes: comment.selection_comment_downvotes		
			}		
		end
	end

	def facts_comments
		FactsComment.pending_review.all.collect do |facts_comment|
			{	
				type: "facts_comment",
				id: facts_comment.id,
				comment_content: Comment.find(facts_comment.comment_id).content,
				fact_content: Fact.find(facts_comment.fact_id).content,
				comment_fact_upvotes: facts_comment.comment_fact_upvotes,
				comment_fact_downvotes: facts_comment.comment_fact_downvotes		
			}		
		end
	end
end





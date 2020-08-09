class ReviewSerializer < ActiveModel::Serializer
	# attributes :id, :content, :url

	has_many :facts
	has_many :comments
	has_many :facts_comments
	# has_many :fact_rephrases

	def facts
		# binding.pry
		facts = Fact.pending_review.all.collect do |fact|
			if fact.fact_rephrase && fact.fact_rephrase.review_status === "pending"
				# binding.pry
				{
					type: "FactRephrase",
					id: fact.fact_rephrase.id,
					fact_content: fact.content,
					rephrase_content: fact.fact_rephrase.content,
					phrasing_upvotes: fact.fact_rephrase.phrasing_upvotes,
					phrasing_downvotes: fact.fact_rephrase.phrasing_downvotes,
					subject_id: fact.collector_id				
				}

			elsif fact.review_status === "pending"
				{	
					type: "Fact",
					id: fact.id,
					content: fact.content,
					url: fact.url,
					logic_upvotes: fact.logic_upvotes,
					logic_downvotes: fact.logic_downvotes,
					context_upvotes: fact.context_upvotes,
					context_downvotes: fact.context_downvotes,
					credibility_upvotes: fact.credibility_upvotes,
					credibility_downvotes: fact.credibility_downvotes,
					score: 0,
					subject_id: fact.collector_id										
				}
			end
		end				
		facts.compact
	end

	def comments
		comments = Comment.pending_review.all.collect do |comment|
			if comment.review_status === "pending"
				{	
					type: "Comment",
					id: comment.id,
					selection: comment.selection,
					content: comment.content,
					selection_comment_upvotes: comment.selection_comment_upvotes,
					selection_comment_downvotes: comment.selection_comment_downvotes,
					subject_id: comment.user_id		
				}		
			end
		end
		comments.compact
	end

	def facts_comments
		facts_comments = FactsComment.pending_review.all.collect do |facts_comment|
			if facts_comment.review_status === "pending"
				{	
					type: "FactsComment",
					id: facts_comment.id,
					comment_content: Comment.find(facts_comment.comment_id).content,
					fact_content: Fact.find(facts_comment.fact_id).content,
					comment_fact_upvotes: facts_comment.comment_fact_upvotes,
					comment_fact_downvotes: facts_comment.comment_fact_downvotes,
					subject_id: facts_comment.comment.user_id		
				}						
			end
		end
		facts_comments.compact
	end

	# def fact_rephrases
	# 	fact_rephrases = FactRephrase.pending_review.all.collect do |fact_rephrase|
	# 		if fact_rephrase.review_status === "pending"
	# 			{
	# 				type: "FactRephrase",
	# 				id: fact_rephrase.id,
	# 				fact_content: Fact.find(fact_rephrase.fact_id).content,
	# 				rephrase_content: fact_rephrase.content,
	# 				phrasing_upvotes: fact_rephrase.phrasing_upvotes,
	# 				phrasing_downvotes: fact_rephrase.phrasing_downvotes,				
	# 			}				
	# 		end
	# 	end
	# 	fact_rephrases.compact
	# end
end





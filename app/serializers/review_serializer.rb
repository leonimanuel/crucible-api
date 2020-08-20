class ReviewSerializer < ActiveModel::Serializer
	has_many :facts
	has_many :comments
	has_many :facts_comments

	def facts
		done_reviews = UsersReview.where(user: object, review_object: "Fact")
		
		facts = Fact.pending_review.where.not(collector_id: object.id).first(10).collect do |fact|
			if fact.fact_rephrase && fact.fact_rephrase.review_status === "pending"
				if !UsersReview.where(user: object, review_object: "FactRephrase").map {|record| record.object_id}.include?(fact.fact_rephrase.id)
					{
						type: "FactRephrase",
						id: fact.fact_rephrase.id,
						fact_content: fact.content,
						rephrase_content: fact.fact_rephrase.content,
						phrasing_upvotes: fact.fact_rephrase.phrasing_upvotes,
						phrasing_downvotes: fact.fact_rephrase.phrasing_downvotes,
						subject_id: fact.collector_id				
					}
				end
			
			elsif fact.review_status === "pending"
				review_types = done_reviews.where(object_id: fact.id).map {|record| record.review_type}
				if review_types.count < 3
					{	
						type: "Fact",
						id: fact.id,
						content: fact.content,
						review_types: review_types,
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
		end				
		facts.compact
	end

	def comments
		comments = Comment.pending_review.where.not(user_id: object.id).first(10).collect do |comment|
			if !UsersReview.where(user: object, review_object: "Comment").map {|record| record.object_id}.include?(comment.id)
				if comment.review_status === "pending" && comment.discussion.name != "Getting Started with Crucible"
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
		end
		comments.compact
	end

	def facts_comments
		facts_comments = FactsComment.pending_review.where.not(user_id: object.id).first(10).collect do |facts_comment|
			if !UsersReview.where(user: object, review_object: "FactsComment").map {|record| record.object_id}.include?(facts_comment.id)
				if facts_comment.review_status === "pending" && facts_comment.comment.discussion.name != "Getting Started with Crucible"
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
		end
		facts_comments.compact
	end
end





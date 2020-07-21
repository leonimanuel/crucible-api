class CommentSerializer < ActiveModel::Serializer
	attributes :content, :span_id, :selection, :startPoint, :endPoint, :previous_el_id, :discussion_id, :user_id, :selection_comment_upvotes, :selection_comment_downvotes, :review_status
	belongs_to :user
	has_many :facts
	has_many :facts_comments_reviews

	def user
		{ name: object.user.name }
	end

	def facts
		object.facts.collect do |fact|
			{
				content: fact.content,
				comment_id: object.id
			}
		end
	end

	def facts_comments_reviews
		FactsComment.where(comment: object).collect do |fact_comment|
			{	
				comment_fact_upvotes: fact_comment.comment_fact_upvotes,
				comment_fact_downvotes: fact_comment.comment_fact_downvotes,
				review_status: fact_comment.review_status
			}
		end
	end
end


# class CommentSerializer
# 	def initialize(comment_object)
# 		@comment = comment_object
# 	end

# 	def to_serialized_json
# 		options = {
# 			include: {
# 				facts: {
# 					except: [:updated_at]
# 				},
# 				user: {
# 					only: [:name]
# 				}
# 			}
# 		}
# 		@comment.to_json(options)
# 	end
# end
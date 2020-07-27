class DiscussionSerializer < ActiveModel::Serializer
	attributes :id, :name, :access, :group_id, :unread_messages_count, :created_at, :article_url, :admin
	has_one :article
	has_many :comments
	# has_many :unread_messages
	# has_many :messages
	belongs_to :group 
	has_many :guests
	
	# def unread_messages
	# 	{
	# 		discussion_id: object.id
	# 		unread_messages: object.discussion_unread_messages.with_discussion_id(object.id).with_user_id(@instance_options[:current_user_id]).first.unread_messages
	# 	}
	# end

	def access
		if object.guests.include?(User.find(@instance_options[:current_user_id]))
			"guest"
		else
			"member"
		end
	end

	def admin
		object.admin_id == @instance_options[:current_user_id]
	end

	def unread_messages_count
		object.discussion_unread_messages.with_discussion_id(object.id).with_user_id(@instance_options[:current_user_id]).first.unread_messages
	end

	def article
		{
			title: object.article.title,
			content: object.article.content,
			discussion_id: object.id,
			author: object.article.author,
			date_published: object.article.date_published
		}
	end

	def comments
		object.comments.collect do |comment|
			{
				content: comment.content,
				span_id: comment.span_id,
				selection: comment.selection,
				startPoint: comment.startPoint,
				endPoint: comment.endPoint,
				previous_el_id: comment.previous_el_id,
				discussion_id: object.id,
				user_id: comment.user_id,
				user: { name: comment.user.name },
				facts: comment.facts.collect do |fact|
					{
						content: fact.content,
						comment_id: comment.id
					}
				end,
				selection_comment_upvotes: comment.selection_comment_upvotes,
				selection_comment_downvotes: comment.selection_comment_downvotes,
				review_status: comment.review_status,
				
				facts_comments_reviews: FactsComment.where(comment: comment).collect do |fact_comment|
					{	
						comment_fact_upvotes: fact_comment.comment_fact_upvotes,
						comment_fact_downvotes: fact_comment.comment_fact_downvotes,
						review_status: fact_comment.review_status
					}
				end
			}
		end
	end

	def messages
		object.messages.collect do |message|
			{
				text: message.text,
				discussion_id: object.id,
				user_id: message.user_id,
				created_at: message.created_at,
				user: { 
					name: message.user.name, 
					id: message.user.id
				}		
			}
		end
	end

	def group
		{name: object.group.name}
	end

	def guests
		object.guests.collect do |guest|
			{
				id: guest.id,
				name: guest.name
			}
		end
	end
end










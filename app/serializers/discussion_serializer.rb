class DiscussionSerializer < ActiveModel::Serializer
	attributes :id, :type, :name, :slug, :access, :group_id, :unread_messages_count, :created_at, :article_url, :admin, :read
	has_one :article
	has_many :comments
	# has_many :unread_messages
	# has_many :messages
	belongs_to :group 
	has_many :guests
	has_many :members
	
	@@colors = %w(#abf0e9 #f9b384 #84a9ac #5c2a9d #abc2e8 #cfe5cf #e8505b)
	def type
		"discussion"
	end

	def access
		if object.guests.include?(User.find(@instance_options[:current_user_id]))
			"guest"
		else
			"member"
		end
	end

	def read
		UsersGroupsUnreadDiscussion.find_by(user: @instance_options[:current_user_id], discussion: object).read
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
			date_published: DateTime.parse(object.article.date_published).to_date.strftime("%B %e, %Y"),
			article_type: object.article.article_type
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
				user: { name: comment.user.name_with_last_initial },
				facts: comment.facts.collect do |fact|
					{
						id: fact.id,
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
					name: message.user.name_with_last_initial, 
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
			if guest == User.find(@instance_options[:current_user_id])
				# binding.pry
				color = "cadetblue"
			else
				color = @@colors.sample
			end
			{
				id: guest.id,
				name: guest.name,
				color: color
			}
		end
	end

	def members
		current_user = User.find(@instance_options[:current_user_id])
		if object.guests.include?(current_user)
			array = object.users.collect do |user|
				if user != object.admin
					{
						id: user.id,
						name: user.name_with_last_initial,
						group_id: object.group_id,
						color: @@colors.sample
					}
				end
			end			
			array.compact
		else
			[]
		end
	end
end










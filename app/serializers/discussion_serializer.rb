class DiscussionSerializer < ActiveModel::Serializer
	attributes :id, :name, :group_id, :unread_messages_count, :created_at
	has_one :article
	has_many :comments
	# has_many :unread_messages
	# has_many :messages
	belongs_to :group 
	
	# def unread_messages
	# 	{
	# 		discussion_id: object.id
	# 		unread_messages: object.discussion_unread_messages.with_discussion_id(object.id).with_user_id(@instance_options[:current_user_id]).first.unread_messages
	# 	}
	# end

	def unread_messages_count
		# binding.pry
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
end










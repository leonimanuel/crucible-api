class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :users
  has_many :discussions

  def discussions
  	object.discussions.collect do |discussion|
  		{ 
  			id: discussion.id, 
  			group_id: object.id,
  			created_at: object.created_at,
  			name: discussion.name,
  			unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(@instance_options[:current_user_id]).first.unread_messages
  		}
  	end	
  end

  def users
  	users = object.users.collect do |user|
  		if user.id != @instance_options[:current_user_id]
		  	{name: user.name, id: user.id}
  		end
  	end

  	users = users.compact
  end
end
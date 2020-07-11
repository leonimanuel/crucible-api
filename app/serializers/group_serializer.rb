class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :members
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

  def members
  	users = object.users.collect do |user|
  		if user.id != @instance_options[:current_user_id]
		  	binding.pry
        {name: user.name, id: user.id}
  		end
  	end

  	binding.pry
    users = users.compact
  end
end
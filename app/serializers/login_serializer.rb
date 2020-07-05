class LoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :groups
  has_many :group_members
  has_many :discussions

  def discussions
  	object.discussions.collect do |discussion|
  		{ 
  			id: discussion.id, 
  			name: discussion.name,
  			group_id: discussion.group_id,
        unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages,
  		  created_at: discussion.created_at
      }
  	end	
  end

  def groups
    object.groups.collect do |group|
      {
        id: group.id,
        name: group.name,
      }
    end
  end

  def group_members
    memberArray = object.groups.collect do |group|
      group.users.collect do |user|
        {
          id: user.id,
          name: user.name,
          group_id: group.id
        }
      end
    end
    return memberArray[0]
  end

end






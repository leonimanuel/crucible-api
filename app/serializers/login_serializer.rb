class LoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :groups
  has_many :discussions

  def discussions
  	object.discussions.collect do |discussion|
  		{ 
  			id: discussion.id, 
  			name: discussion.name,
  			unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages
  		}
  	end	
  end
end
class LoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :groups
  has_many :group_members
  has_many :discussions
  has_many :facts

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
    # binding.pry
    return memberArray.flatten
  end

  def facts
    object.facts.collect do |fact|
      {
        id: fact.id,
        content: fact.content,
        rephrase: fact.fact_rephrases.where(user: object).last,
        logic_upvotes: fact.logic_upvotes,
        logic_downvotes: fact.logic_downvotes,
        context_upvotes: fact.context_upvotes,
        context_downvotes: fact.context_downvotes,
        credibility_upvotes: fact.credibility_upvotes,
        credibility_downvotes: fact.credibility_downvotes,
        review_status: fact.review_status
      }
    end
  end
end






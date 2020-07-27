class LoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :review_score, :reputability_score
  has_many :groups
  has_many :group_members
  has_many :discussions
  has_many :facts

  def discussions
    # allDiscussions = object.discussions.push(object.guest_discussions)
    member_discussions = object.discussions.collect do |discussion|
      { 
        access: "member",
        id: discussion.id, 
        name: discussion.name,
        group_id: discussion.group_id,
        # unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages,
        created_at: discussion.created_at
      }      
    end

    guest_discussions = object.guest_discussions.collect do |discussion|
      # binding.pry
      { 
        access: "guest",
        id: discussion.id, 
        name: discussion.name,
        group_id: discussion.group_id,
        # unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages,
        created_at: discussion.created_at
      }      
    end
    allDiscussions = member_discussions.concat(guest_discussions)
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
    member_array = object.groups.collect do |group|
      group.users.collect do |user|
        {
          id: user.id,
          name: user.name,
          group_id: group.id
        }
      end
    end
    # object.groups.find_by(name: "Guest").discussions.collect

    feed_owner_array = object.guest_discussions.map do |discussion|
      # binding.pry
      {
        id: discussion.users.first.id,
        name: discussion.users.first.name, 
        group_id: discussion.group_id
      }
    end
    binding.pry
    return member_array.concat(feed_owner_array).flatten.uniq
  end

  def facts
    object.facts.collect do |fact|
      {
        id: fact.id,
        content: fact.content,
        rephrase: fact.fact_rephrase,
        logic_upvotes: fact.logic_upvotes,
        logic_downvotes: fact.logic_downvotes,
        context_upvotes: fact.context_upvotes,
        context_downvotes: fact.context_downvotes,
        credibility_upvotes: fact.credibility_upvotes,
        credibility_downvotes: fact.credibility_downvotes,
        review_status: fact.review_status,
        topic_id: TopicsFact.where(topic: Topic.where(user: object).map {|t| t.id }).where(fact_id: fact.id).first.topic_id
      }
    end
  end

  def review_score
    UsersReview.where(user: object).count * 10
  end

  def reputability_score
    items = [Fact.where.not(grade: nil), FactRephrase.where.not(grade: nil), Comment.where.not(grade: nil), FactsComment.where.not(grade: nil)]
    array = items.map do |item_array| 
      item_array.average(:grade).to_f if !item_array.empty?
    end
    # binding.pry
    array = array.compact
    # array = [Fact.average(:grade), FactRephrase.average(:grade), Comment.average(:grade), FactsComment.average(:grade)]
    # binding.pry
    if array.empty? #{ |item| item == nil }
      "No score yet"
    else
      numerator = array.reduce(0) { |a, v| a + v }
      denominator = array.count
      mean = numerator.to_f / denominator.to_f 
      # binding.pry
      mean      
    end
  end
end


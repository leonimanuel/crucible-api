class LoginSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :review_score, :reputability_score, :daily_reviews, :daily_streaks
  has_many :groups
  has_many :group_members
  has_many :discussions
  has_many :facts
  has_many :briefings


  
  def discussions
    member_discussions = object.discussions.collect do |discussion|
      admin_bool = (discussion.admin == object)
      { 
        access: "member",
        id: discussion.id, 
        name: discussion.name,
        slug: discussion.slug,
        group_id: discussion.group_id,
        group_name: Group.find(discussion.group_id).name,
        unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages,
        created_at: discussion.created_at,
        read: UsersGroupsUnreadDiscussion.find_by(user: object, discussion: discussion).read,
        admin: admin_bool
      }      
    end

    guest_discussions = object.guest_discussions.collect do |discussion|
      admin_bool = (discussion.admin == object)
      # UsersGroupsUnreadDiscussion.where(user: object, discussion: discussion).first
      { 
        access: "guest",
        id: discussion.id, 
        name: discussion.name,
        slug: discussion.slug,
        group_id: discussion.group_id,
        unread_messages_count: discussion.discussion_unread_messages.with_discussion_id(discussion.id).with_user_id(object.id).first.unread_messages,
        created_at: discussion.created_at,
        read: UsersGroupsUnreadDiscussion.find_by(user: object, discussion: discussion).read,
        admin: admin_bool
      }      
    end
    allDiscussions = member_discussions.concat(guest_discussions)
  end

  def groups
    object.groups.collect do |group|
      admin_bool = (group.admin == object)
      {
        id: group.id,
        name: group.name,
        admin: admin_bool
      }
    end
  end

  def group_members
    # binding.pry
    all_colors = %w(#abf0e9 #f9b384 #84a9ac #5c2a9d #abc2e8 #cfe5cf #e8505b)
    available_colors = all_colors
    member_array = object.groups.collect do |group|
      group.users.collect do |user|
        # binding.pry
        if user === object
          color = "cadetblue"
        else
          color = available_colors.sample
          available_colors.delete(color)
          if available_colors.empty?
            available_colors = all_colors
          end
        end
        {
          id: user.id,
          name: user.name,
          group_id: group.id,
          color: color
        }
      end
    end
    # object.groups.find_by(name: "Guest").discussions.collect

    feed_owner_array = object.guest_discussions.map do |discussion|
      # binding.pry
      {
        id: discussion.users.first.id,
        name: discussion.users.first.name, 
        group_id: discussion.group_id,
        color: available_colors.sample
      }
    end
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

  def briefings
    Briefing.all.collect do |briefing|
      {
        id: briefing.id,
        name: briefing.name,
        url: briefing.url,
        description: briefing.description,
        organization: briefing.organization
      }
    end
  end
end


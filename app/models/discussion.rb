class Discussion < ApplicationRecord
	# belongs_to :admin, class_name: "User"
	belongs_to :admin, foreign_key: "admin_id", class_name: "User"

	belongs_to :group
	belongs_to :article

	has_many :users, through: :group
	# has_one :article, dependent: :destroy

	has_many :comments, dependent: :destroy
	has_many :messages, dependent: :destroy

	has_many :messages_users_reads, dependent: :destroy
	has_many :discussion_unread_messages, dependent: :destroy

	has_many :guests_guest_discussions, dependent: :destroy
	has_many :guests, through: :guests_guest_discussions, source: :user

	has_many :users_groups_unread_discussions, dependent: :destroy

  def users_and_guests
  	users = self.users.map {|user| user}
  	guests = self.guests.map {|guest| guest}
  	users_and_guests = users.concat(guests)
  end

	def unread_messages
		return DiscussionUnreadMessage.all.where(user_id: 3)
	end

	def unread_messages_by_user
		return DiscussionSerializer.unread_messages_by_user
	end

	def self.new_discussion(article, user, group)
		puts "creating Feed discussion for #{user.name}"
		@discussion = self.create(
			name: article.title, 
			slug: article.title.slugify,
			group: group, 
			article_url: article.url,
			admin: user,
			article: article
		)
		
		# how come not guests too?
		@discussion.users.each do |member|
			UsersGroupsUnreadDiscussion.create(user: member, group: @discussion.group, discussion: @discussion)				
		end

		if group.name == "Feed"
			guest = User.where.not(id: user.id).sample
			i = 0
			until !guest.all_discussion_urls.include?(article.url) || i >= 10
				i ++
				guest = User.where.not(id: user.id).sample
			end
			
			@discussion.guests << guest
			UsersGroupsUnreadDiscussion.create(user: guest, group: guest.groups.find_by(name: "Guest"), discussion: @discussion)
			# guest.groups.find_by(name: "Guest") << @discussion
		end

		@discussion.users_and_guests.each do |receiver|
			DiscussionUnreadMessage.create(user: receiver, discussion: @discussion, unread_messages: 0)
			if receiver != user && @discussion.group.name != "Feed"
				ApplicationMailer.new_discussion(user, receiver, @discussion).deliver_now
			end
		end
	
		return @discussion
	end

	def self.new_game_discussion(article, user)
		@discussion = self.create(
			name: article.title, 
			slug: article.title.slugify,
			group: user.groups.find_by(name: "Feed"), 
			article_url: article.url,
			admin: user,
			article: article,
			game: true
		)					

		UsersGroupsUnreadDiscussion.create(user: user, group: user.groups.find_by(name: "Feed"), discussion: @discussion)
		DiscussionUnreadMessage.create(user: user, discussion: @discussion, unread_messages: 0)			
	end
end

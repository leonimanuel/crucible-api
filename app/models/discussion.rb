class Discussion < ApplicationRecord
	# belongs_to :admin, class_name: "User"
	belongs_to :admin, foreign_key: "admin_id", class_name: "User"

	belongs_to :group
	has_many :users, through: :group
	has_one :article, dependent: :destroy

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


end

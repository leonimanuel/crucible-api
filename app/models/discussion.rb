class Discussion < ApplicationRecord
	belongs_to :group
	has_many :users, through: :group
	has_one :article
	# has_one :from
	has_many :comments
	has_many :messages

	has_many :messages_users_reads
	has_many :discussion_unread_messages

	has_many :guests_guest_discussions
	has_many :guests, through: :guests_guest_discussions, source: :user

	def unread_messages
		return DiscussionUnreadMessage.all.where(user_id: 3)
	end

	def unread_messages_by_user
		return DiscussionSerializer.unread_messages_by_user
	end
end

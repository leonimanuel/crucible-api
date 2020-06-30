class Discussion < ApplicationRecord
	belongs_to :group
	has_many :users, through: :group
	has_one :article
	# has_one :from
	has_many :comments
	has_many :messages

	has_many :discussion_unread_messages
end

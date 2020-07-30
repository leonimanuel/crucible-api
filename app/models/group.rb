class Group < ApplicationRecord
	has_many :users_groups
	has_many :users, through: :users_groups
	has_many :discussions

	belongs_to :admin, foreign_key: "admin_id", class_name: "User"

	has_many :users_groups_unread_discussions
end

class MessagesUsersRead < ApplicationRecord
  belongs_to :message
  belongs_to :discussion
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :with_user, -> (user_id) { where("user_id = ?", user_id) }
  scope :with_discussion, -> (discussion_id) { where("discussion_id = ?", discussion_id) }
end

class DiscussionUnreadMessage < ApplicationRecord
  belongs_to :user
  belongs_to :discussion

  scope :with_discussion_id, -> (discussion_id) { where("discussion_id = ?", discussion_id) }
  scope :with_user_id, -> (user_id) { where("user_id = ?", user_id) }
end

class DiscussionUnreadMessage < ApplicationRecord
  belongs_to :user
  belongs_to :discussion

  scope :with_discussion_id, -> (discussion_id) { where("discussion_id = ?", discussion_id) }
end

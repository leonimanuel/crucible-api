class UsersGroupsUnreadDiscussion < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :discussion
end

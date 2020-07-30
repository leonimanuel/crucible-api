class AddReadToUsersGroupsUnreadDiscussion < ActiveRecord::Migration[6.0]
  def change
  	add_column :users_groups_unread_discussions, :read, :boolean, default: false
  end
end

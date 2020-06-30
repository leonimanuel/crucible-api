class ChangeUsersDiscussionsUnreadMessagesCountName < ActiveRecord::Migration[6.0]
  def change
  	rename_table :users_discussions_unread_messages_counts, :unread_messages
  end
end

class ChangeUsersDiscussionsUnreadMessagesCountNameAgain < ActiveRecord::Migration[6.0]
  def change
  	rename_table :unread_messages, :discussion_unread_messages
  end
end

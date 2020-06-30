class AddDiscussionIdToMessagesUsersRead < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages_users_reads, :discussion_id, :integer
  end
end

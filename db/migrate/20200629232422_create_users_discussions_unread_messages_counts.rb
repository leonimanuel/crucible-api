class CreateUsersDiscussionsUnreadMessagesCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :users_discussions_unread_messages_counts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :discussion, null: false, foreign_key: true
      t.integer :unread_messages, default: 0

      t.timestamps
    end
  end
end

class CreateUsersGroupsUnreadDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :users_groups_unread_discussions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :discussion, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateMessagesUsersReads < ActiveRecord::Migration[6.0]
  def change
    create_table :messages_users_reads do |t|
      t.references :message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end

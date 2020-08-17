class AddUserIdToFactsComments < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts_comments, :user_id, :integer, null: false
  end
end

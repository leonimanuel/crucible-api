class AddUserIdToTopics < ActiveRecord::Migration[6.0]
  def change
  	add_column :topics, :user_id, :integer
  end
end

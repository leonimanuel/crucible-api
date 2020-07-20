class RemoveUserIdFromTopicsFacts < ActiveRecord::Migration[6.0]
  def change
  	remove_column :topics_facts, :user_id
  end
end

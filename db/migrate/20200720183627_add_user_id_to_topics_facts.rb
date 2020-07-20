class AddUserIdToTopicsFacts < ActiveRecord::Migration[6.0]
  def change
  	add_column :topics_facts, :user_id, :integer
  end
end

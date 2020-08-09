class AddVotesToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :total_upvotes, :integer, default: 0
  	add_column :users, :total_downvotes, :integer, default: 0
  end
end

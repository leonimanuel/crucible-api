class AddReachScoreToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :reach_score, :integer, default: 0
  end
end

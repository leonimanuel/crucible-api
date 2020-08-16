class AddDailyFactsCommentsToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :daily_facts_comments, :integer, default: 0
  end
end

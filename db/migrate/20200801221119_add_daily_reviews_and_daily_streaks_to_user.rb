class AddDailyReviewsAndDailyStreaksToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :daily_reviews, :integer, default: 0
  	add_column :users, :daily_streaks, :integer, default: 0
  end
end

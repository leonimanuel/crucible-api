class AddFeedEmailsToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :feed_email, :boolean, default: true
  end
end

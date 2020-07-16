class AddPendingReviewToCommentsAndFactsComments < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :review_status, :string, default: "pending"
  	add_column :facts_comments, :review_status, :string, default: "pending"
  end
end

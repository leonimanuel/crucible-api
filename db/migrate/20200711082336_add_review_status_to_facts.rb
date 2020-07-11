class AddReviewStatusToFacts < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :review_status, :string
  end
end

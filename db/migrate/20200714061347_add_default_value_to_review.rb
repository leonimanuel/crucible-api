class AddDefaultValueToReview < ActiveRecord::Migration[6.0]
  def change
  	change_column :facts, :review_status, :string, default: "pending"
  end
end

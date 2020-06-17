class AddSelectionAndOffsetsToComment < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :selection, :string
  	add_column :comments, :startPoint, :integer
  	add_column :comments, :endPoint, :integer
  end
end

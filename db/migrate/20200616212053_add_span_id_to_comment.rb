class AddSpanIdToComment < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :span_id, :string
  end
end

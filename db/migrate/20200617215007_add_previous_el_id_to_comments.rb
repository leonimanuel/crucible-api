class AddPreviousElIdToComments < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :previous_el_id, :string
  end
end

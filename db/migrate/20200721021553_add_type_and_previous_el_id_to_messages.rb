class AddTypeAndPreviousElIdToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :type, :string, default: "message"
  	add_column :messages, :previous_el_id, :string
  end
end

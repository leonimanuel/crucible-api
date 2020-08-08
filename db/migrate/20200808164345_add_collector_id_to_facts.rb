class AddCollectorIdToFacts < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :collector_id, :integer
  end
end

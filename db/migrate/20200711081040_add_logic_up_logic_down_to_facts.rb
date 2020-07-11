class AddLogicUpLogicDownToFacts < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :logic_upvotes, :integer
  	add_column :facts, :logic_downvotes, :integer  	
  end
end

class AddDefaultValueToLogicScoreInFacts < ActiveRecord::Migration[6.0]
  def change
  	change_column :facts, :logic_upvotes, :integer, default: 0
  	change_column :facts, :logic_downvotes, :integer, default: 0
  end
end

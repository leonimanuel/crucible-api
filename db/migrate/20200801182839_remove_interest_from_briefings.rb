class RemoveInterestFromBriefings < ActiveRecord::Migration[6.0]
  def change
  	remove_column :briefings, :interest_id
  end
end

class RemoveRephraseColumnsFromFact < ActiveRecord::Migration[6.0]
  def change
  	remove_column :facts, :rephrase
  	remove_column :facts, :rephrase_upvotes
  	remove_column :facts, :rephrase_downvotes
  end
end

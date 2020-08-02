class AddRephraseToFact < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :rephrase, :string
  	add_column :facts, :rephrase_upvotes, :integer, default: 0
  	add_column :facts, :rephrase_downvotes, :integer, default: 0
  end
end

class AddContextUpvotesAndDownvotesToFacts < ActiveRecord::Migration[6.0]
  def change
  	add_column :facts, :context_upvotes, :integer, default: 0
  	add_column :facts, :context_downvotes, :integer, default: 0
  	
  	add_column :facts, :legitimacy_upvotes, :integer, default: 0
  	add_column :facts, :legitimacy_downvotes, :integer, default: 0
  end
end

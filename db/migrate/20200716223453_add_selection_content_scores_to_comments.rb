class AddSelectionContentScoresToComments < ActiveRecord::Migration[6.0]
  def change
  	add_column :comments, :selection_comment_upvotes, :integer, default: 0
  	add_column :comments, :selection_comment_downvotes, :integer, default: 0  

  	add_column :facts_comments, :comment_fact_upvotes, :integer, default: 0
  	add_column :facts_comments, :comment_fact_downvotes, :integer, default: 0 
  end
end

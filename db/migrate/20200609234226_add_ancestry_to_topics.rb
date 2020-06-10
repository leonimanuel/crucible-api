class AddAncestryToTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :ancestry, :string
    add_index :topics, :ancestry
  end
end

class AddUserIdToFactRephrase < ActiveRecord::Migration[6.0]
  def change
  	add_column :fact_rephrases, :user_id, :integer, null: false
  end
end

class RemoveUserFromFactRephrase < ActiveRecord::Migration[6.0]
  def change
  	remove_column :fact_rephrases, :user_id
  end
end

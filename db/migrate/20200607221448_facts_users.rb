class FactsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :facts_users do |t|
      t.integer :fact_id
      t.integer :user_id

      t.timestamps
    end
  end
end

class CreateFactGrabs < ActiveRecord::Migration[6.0]
  def change
    create_table :fact_grabs do |t|
      t.references :fact, null: false, foreign_key: true
      t.integer :grabber_id, null: false
      t.integer :giver_id, null: false

      t.timestamps
    end
  end
end

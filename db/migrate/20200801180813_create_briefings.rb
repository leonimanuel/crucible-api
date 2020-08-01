class CreateBriefings < ActiveRecord::Migration[6.0]
  def change
    create_table :briefings do |t|
      t.string :name
      t.string :url
      t.string :description
      t.references :interest, null: false, foreign_key: true

      t.timestamps
    end
  end
end

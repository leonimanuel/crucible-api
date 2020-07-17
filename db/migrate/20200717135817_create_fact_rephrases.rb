class CreateFactRephrases < ActiveRecord::Migration[6.0]
  def change
    create_table :fact_rephrases do |t|
      t.references :fact, null: false, foreign_key: true
      t.string :content
      t.integer :phrasing_upvotes, default: 0
      t.integer :phrasing_downvotes, default: 0
      t.string :review_status, default: "pending"
      t.timestamps
    end
  end
end

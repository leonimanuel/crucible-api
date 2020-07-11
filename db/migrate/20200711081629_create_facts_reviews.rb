class CreateFactsReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :facts_reviews do |t|
      t.references :fact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :review_type
      t.string :review_result
      t.string :review_reason
      t.string :review_comment

      t.timestamps
    end
  end
end

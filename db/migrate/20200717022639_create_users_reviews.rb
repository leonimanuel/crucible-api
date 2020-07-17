class CreateUsersReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :users_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.string :review_object
      t.integer :object_id
      t.string :review_type
      t.string :decision

      t.timestamps
    end
  end
end

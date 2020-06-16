class CreateFactsComments < ActiveRecord::Migration[6.0]
  def change
    create_table :facts_comments do |t|
      t.references :fact, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end

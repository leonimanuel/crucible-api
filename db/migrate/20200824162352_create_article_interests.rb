class CreateArticleInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :article_interests do |t|
      t.references :article, null: false, foreign_key: true
      t.references :interest, null: false, foreign_key: true

      t.timestamps
    end
  end
end

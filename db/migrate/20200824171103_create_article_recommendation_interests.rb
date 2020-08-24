class CreateArticleRecommendationInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :article_rec_interests do |t|
      t.references :article_recommendation, null: false, foreign_key: true
      t.references :interest, null: false, foreign_key: true

      t.timestamps
    end
  end
end

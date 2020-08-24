class CreateArticleRecommendations < ActiveRecord::Migration[6.0]
  def change
    create_table :article_recommendations do |t|
      t.string :url
      t.string :article_type
      t.boolean :live

      t.timestamps
    end
  end
end

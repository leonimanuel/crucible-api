class RenameArticleUrlInArticles < ActiveRecord::Migration[6.0]
  def change
  	rename_column :articles, :article_url, :url
  end
end

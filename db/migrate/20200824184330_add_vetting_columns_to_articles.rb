class AddVettingColumnsToArticles < ActiveRecord::Migration[6.0]
  def change
  	add_column :articles, :article_type, :string
  	add_column :articles, :vetted, :boolean, default: false
  end
end

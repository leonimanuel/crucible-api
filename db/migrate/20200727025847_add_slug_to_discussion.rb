class AddSlugToDiscussion < ActiveRecord::Migration[6.0]
  def change
  	add_column :discussions, :slug, :string
  end
end

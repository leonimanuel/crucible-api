class AddGameBoolToDiscussions < ActiveRecord::Migration[6.0]
  def change
  	add_column :discussions, :game, :boolean, default: false
  end
end

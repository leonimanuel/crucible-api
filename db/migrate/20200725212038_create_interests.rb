class CreateInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :interests do |t|
      t.string :section
      t.string :title
      t.string :query

      t.timestamps
    end
  end
end

class CreateDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions do |t|
      t.string :name

      t.timestamps
    end
  end
end

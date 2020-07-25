class CreateGuestsGuestDiscussions < ActiveRecord::Migration[6.0]
  def change
    create_table :guests_guest_discussions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :discussion, null: false, foreign_key: true

      t.timestamps
    end
  end
end

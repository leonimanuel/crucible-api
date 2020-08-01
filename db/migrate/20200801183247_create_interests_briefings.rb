class CreateInterestsBriefings < ActiveRecord::Migration[6.0]
  def change
    create_table :interests_briefings do |t|
      t.references :interest, null: false, foreign_key: true
      t.references :briefing, null: false, foreign_key: true

      t.timestamps
    end
  end
end

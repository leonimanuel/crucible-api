class CreateTopicsSubtopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics_subtopics do |t|
    	t.integer :topic_id
    	t.integer :subtopic_id
    end
  end
end

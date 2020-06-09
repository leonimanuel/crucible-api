class CreateTopicsFacts < ActiveRecord::Migration[6.0]
  def change
    create_table :topics_facts do |t|
    	t.integer :topic_id
    	t.integer :fact_id
    end
  end
end

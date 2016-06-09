class CreateSavedStories < ActiveRecord::Migration
  def change
    create_table :saved_stories do |t|
      t.integer :story_id, null: false
      t.string :author, null: false
      t.string :headline, null: false
      t.boolean :embargoed
      t.datetime :story_created, null: false
      t.datetime :story_updated, null: false
      t.datetime :story_published, null: false

      t.timestamps
    end
    add_index :saved_stories, :story_id, unique: true
  end
end

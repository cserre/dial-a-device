class CreateProjectReactions < ActiveRecord::Migration
  def change
    create_table :project_reactions do |t|
      t.integer :project_id
      t.integer :reaction_id

      t.timestamps
    end
  end
end

class CreateSampleReactions < ActiveRecord::Migration
  def change
    create_table :sample_reactions do |t|
      t.integer :reaction_id
      t.integer :sample_id

      t.timestamps
    end
  end
end

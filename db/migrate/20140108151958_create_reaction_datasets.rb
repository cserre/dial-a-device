class CreateReactionDatasets < ActiveRecord::Migration
  def change
    create_table :reaction_datasets do |t|
      t.integer :reaction_id
      t.integer :dataset_id

      t.timestamps
    end
  end
end

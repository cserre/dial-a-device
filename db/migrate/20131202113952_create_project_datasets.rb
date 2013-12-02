class CreateProjectDatasets < ActiveRecord::Migration
  def change
    create_table :project_datasets do |t|
      t.integer :project_id
      t.integer :dataset_id

      t.timestamps
    end
  end
end

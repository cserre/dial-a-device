class CreateDatasetgroupDatasets < ActiveRecord::Migration
  def change
    create_table :datasetgroup_datasets do |t|
      t.integer :datasetgroup_id
      t.integer :dataset_id

      t.timestamps
    end
  end
end

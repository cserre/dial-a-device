class CreateDatasetgroups < ActiveRecord::Migration
  def change
    create_table :datasetgroups do |t|

      t.timestamps
    end
  end
end

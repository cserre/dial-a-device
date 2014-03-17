class AddSampleToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :sample_id, :integer
  end
end

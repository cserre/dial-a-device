class AddRecordedAtToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :recorded_at, :datetime
  end
end

class AddJdxFileToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :jdx_file, :string
  end
end

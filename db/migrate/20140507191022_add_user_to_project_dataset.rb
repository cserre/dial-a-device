class AddUserToProjectDataset < ActiveRecord::Migration
  def change
    add_column :project_datasets, :user_id, :integer
  end
end

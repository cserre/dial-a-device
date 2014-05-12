class AddUserToProjectSample < ActiveRecord::Migration
  def change
    add_column :project_samples, :user_id, :integer
  end
end

class AddRootprojectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rootproject_id, :integer
  end
end

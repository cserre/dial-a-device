class AddRootlibraryToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :rootlibrary_id, :integer
  end
end

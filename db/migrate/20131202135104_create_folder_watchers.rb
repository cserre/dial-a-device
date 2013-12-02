class CreateFolderWatchers < ActiveRecord::Migration
  def change
    create_table :folder_watchers do |t|
      t.integer :device_id
      t.string :pattern
      t.string :rootfolder
      t.string :scanfilter
      t.string :serialnumber

      t.timestamps
    end
  end
end

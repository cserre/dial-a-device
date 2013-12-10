class CreateLibraryEntries < ActiveRecord::Migration
  def change
    create_table :library_entries do |t|
      t.integer :library_id
      t.integer :position
      t.integer :molecule_id

      t.timestamps
    end
  end
end

class AddSampleToLibraryEntry < ActiveRecord::Migration
  def change
    add_column :library_entries, :sample_id, :integer
  end
end

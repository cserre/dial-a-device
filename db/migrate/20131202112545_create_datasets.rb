class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.integer :molecule_id
      t.string :title
      t.text :description
      t.string :method
      t.text :details
      t.string :version
      t.integer :preview_id
      t.string :uniqueid
      t.integer :method_rank

      t.timestamps
    end
  end
end

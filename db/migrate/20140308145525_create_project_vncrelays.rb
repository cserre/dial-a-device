class CreateProjectVncrelays < ActiveRecord::Migration
  def change
    create_table :project_vncrelays do |t|
      t.integer :project_id
      t.integer :vncrelay_id

      t.timestamps
    end
  end
end

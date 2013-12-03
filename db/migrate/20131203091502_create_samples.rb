class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.integer :molecule_id
      t.string :guid
      t.float :target_amount, :default => 0.0
      t.float :actual_amount, :default => 0.0
      t.string :unit
      t.boolean :is_virtual, :default => false
      t.float :equivalent, :default => 1.0
      t.float :mol
      t.float :yield

      t.timestamps
    end
  end
end

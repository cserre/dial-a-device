class CreateMoleculeSamples < ActiveRecord::Migration
  def change
    create_table :molecule_samples do |t|
      t.integer :molecule_id
      t.integer :sample_id

      t.timestamps
    end
  end
end

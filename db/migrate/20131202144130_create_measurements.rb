class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :dataset_id
      t.integer :device_id

      t.datetime :recorded_at

      t.timestamps
    end
  end
end

class AddDetailsToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :user_id, :integer
    add_column :measurements, :confirmed, :boolean, :default => false
    add_column :measurements, :molecule_id, :integer
    add_column :measurements, :samplename, :string
    add_column :measurements, :reaction_id, :integer
  end
end

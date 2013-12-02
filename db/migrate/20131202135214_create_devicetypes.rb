class CreateDevicetypes < ActiveRecord::Migration
  def change
    create_table :devicetypes do |t|
      t.string :name
      t.string :displayname
      t.string :porttype
      t.string :portname
      t.string :portbaud
      t.string :portdetails
      t.boolean :showcase, :default => false
      t.integer :deviceclass_id

      t.timestamps
    end
  end
end

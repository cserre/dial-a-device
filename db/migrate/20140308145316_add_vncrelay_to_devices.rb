class AddVncrelayToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :vncrelay_id, :integer
  end
end

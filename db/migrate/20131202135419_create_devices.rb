class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :connectiontype
      t.string :portbaud
      t.string :portdetails
      t.string :portname
      t.string :porttype
      t.integer :devicetype_id
      t.integer :beaglebone_id
      t.datetime :lastseen
      t.string :websockifygateway
      t.string :websockifygatewayport
      t.string :vnchost
      t.string :vncport
      t.string :token
      t.string :vncpassword

      t.timestamps
    end
  end
end

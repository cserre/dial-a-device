class CreateVncrelays < ActiveRecord::Migration
  def change
    create_table :vncrelays do |t|
      t.string :host
      t.string :port
      t.datetime :lastseen
      t.string :serialnumber
      t.string :internal_ip
      t.string :external_ip

      t.timestamps
    end
  end
end

class CreateBeaglebones < ActiveRecord::Migration
  def change
    create_table :beaglebones do |t|
      t.string :serialnumber
      t.string :internal_ip
      t.datetime :last_seen
      t.string :external_ip
      t.string :version

      t.timestamps
    end
  end
end

class AddDetailsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :sign, :string
  end

  def down
    drop_table :users
  end
end

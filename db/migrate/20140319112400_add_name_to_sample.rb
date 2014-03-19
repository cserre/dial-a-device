class AddNameToSample < ActiveRecord::Migration
  def change
    add_column :samples, :name, :string
  end
end

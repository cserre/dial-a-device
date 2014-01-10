class AddDefaultToMolSample < ActiveRecord::Migration
  def up
  	change_column :samples, :mol, :float, :default => 0.0
  end

  def down
  	change_column :samples, :mol, :float, :default => nil
  end
end

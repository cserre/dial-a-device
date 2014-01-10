class AddStartingmaterialToSample < ActiveRecord::Migration
  def change
    add_column :samples, :is_startingmaterial, :boolean, :default => false
  end
end

class AddFpToMolecule < ActiveRecord::Migration
  def change
    add_column :molecules, :fp, "BIT VARYING"
  end
end

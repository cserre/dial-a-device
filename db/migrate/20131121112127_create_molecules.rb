class CreateMolecules < ActiveRecord::Migration
  def change
    create_table :molecules do |t|
      t.string :smiles
      t.string :inchi
      t.string :inchikey
      t.text :molfile
      t.float :mass
      t.string :formula
      t.float :charge
      t.float :spin
      t.string :title
      t.datetime :published_at

      t.timestamps
    end
  end
end

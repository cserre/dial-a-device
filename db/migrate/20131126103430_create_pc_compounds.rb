class CreatePcCompounds < ActiveRecord::Migration
  def change
    create_table :pc_compounds do |t|
      t.integer :cid
      t.string :inchikey
      t.float :logp
      t.string :iupacname

      t.timestamps
    end
  end
end

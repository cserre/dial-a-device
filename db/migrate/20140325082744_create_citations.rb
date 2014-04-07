class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.string :doi
      t.string :fullcitation
      t.string :title

      t.timestamps
    end
  end
end

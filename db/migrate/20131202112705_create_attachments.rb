class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :folder
      t.integer :dataset_id

      t.timestamps
    end
  end
end

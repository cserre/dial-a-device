class AddFilecreationToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :filecreation, :datetime
  end
end

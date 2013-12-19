class AddFilecreationToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :filecreation, :datetime
    add_column :attachments, :filechange, :datetime
  end
end

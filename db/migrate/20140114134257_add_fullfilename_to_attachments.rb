class AddFullfilenameToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :fullfilename, :string
  end
end

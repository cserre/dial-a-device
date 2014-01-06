class AddDescriptionToReaction < ActiveRecord::Migration
  def change
    add_column :reactions, :description, :text
  end
end

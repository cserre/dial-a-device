class AddUserToProjectReaction < ActiveRecord::Migration
  def change
    add_column :project_reactions, :user_id, :integer
  end
end

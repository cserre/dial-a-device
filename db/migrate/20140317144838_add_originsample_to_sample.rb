class AddOriginsampleToSample < ActiveRecord::Migration
  def change
    add_column :samples, :originsample_id, :integer
  end
end

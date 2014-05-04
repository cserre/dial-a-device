class AddTareAmountToSample < ActiveRecord::Migration
  def change
    add_column :samples, :tare_amount, :float, :default => 0.0
  end
end

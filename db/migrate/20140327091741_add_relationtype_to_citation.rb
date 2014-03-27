class AddRelationtypeToCitation < ActiveRecord::Migration
  def change
    add_column :citations, :relationtype, :string
  end
end

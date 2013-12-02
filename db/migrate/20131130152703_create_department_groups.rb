class CreateDepartmentGroups < ActiveRecord::Migration
  def change
    create_table :department_groups do |t|
      t.integer :department_id
      t.integer :group_id

      t.timestamps
    end
  end
end

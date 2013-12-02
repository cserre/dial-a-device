class CreateOrganizationDepartments < ActiveRecord::Migration
  def change
    create_table :organization_departments do |t|
      t.integer :organization_id
      t.integer :department_id

      t.timestamps
    end
  end
end

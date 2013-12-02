class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.boolean :company

      t.integer :country_id
      t.integer :organization_id
      t.integer :department_id
      t.integer :group_id

      t.timestamps
    end
  end
end

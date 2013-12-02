class CreateCountryOrganizations < ActiveRecord::Migration
  def change
    create_table :country_organizations do |t|
      t.integer :country_id
      t.integer :organization_id

      t.timestamps
    end
  end
end

class CreateProjectSamples < ActiveRecord::Migration
  def change
    create_table :project_samples do |t|
      t.integer :project_id
      t.integer :sample_id

      t.timestamps
    end
  end
end

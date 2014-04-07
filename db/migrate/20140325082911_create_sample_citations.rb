class CreateSampleCitations < ActiveRecord::Migration
  def change
    create_table :sample_citations do |t|
      t.integer :sample_id
      t.integer :citation_id

      t.timestamps
    end
  end
end

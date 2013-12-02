class Measurement < ActiveRecord::Base
  attr_accessible :dataset_id, :device_id, :recorded_at

  belongs_to :dataset
  belongs_to :device
end

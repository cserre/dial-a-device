class Measurement < ActiveRecord::Base
  attr_accessible :dataset_id, :device_id, :recorded_at

  belongs_to :dataset
  belongs_to :device

  def update_creationdate
  	cd = DateTime.new(1982, 11, 10)

        if @dataset.recorded_at.nil? then        

          @dataset.attachments.each do |a|

            if a.filechange > cd then

              cd = a.filechange

            end
          end

        else
          cd = @dataset.recorded_at
        end

        self.update_attribute(:recorded_at, cd)


    end
end

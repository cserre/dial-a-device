class Measurement < ActiveRecord::Base
  attr_accessible :dataset_id, :device_id, :recorded_at

  attr_accessible :user_id, :reaction_id, :molecule_id, :confirmed, :samplename

  belongs_to :dataset
  belongs_to :device


  def complete?

    res = false
    if !(self.reaction_id.nil?) && !(self.molecule_id.nil?) then res = true end

    res
  end

  def confirmed?
    self.confirmed
  end

  def assign_to_user

    ui = self.dataset.title.scan(/[A-Z]{3}|[A-Z]{2}/).first

    user = User.where(["sign = ?", ui]).first

    if !user.nil? then

      self.update_attribute(user_id, user.id)

    end


  end
  

  def update_creationdate
  	cd = DateTime.new(1982, 11, 10)

        if dataset.recorded_at.nil? then        

          dataset.attachments.each do |a|

            if a.filechange > cd then

              cd = a.filechange

            end
          end

        else
          cd = dataset.recorded_at
        end

        self.update_attribute(:recorded_at, cd)


    end
end

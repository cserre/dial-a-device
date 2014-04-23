class MessageController < WebsocketRails::BaseController
	def initialize_session
		@message_count = 0
	end

	def client_connected
		Rails.logger.info ("Client connected")
		Rails.logger.info (message)
	end

	def mymessage
		Rails.logger.info ("mymessage")
		Rails.logger.info (message)
		WebsocketRails["channel_dev_2"].trigger :mymessage, "hey back"
	end

	def client_disconnected
	  	Rails.logger.info ("Client disconnected")
	end

	def devicereply
		Rails.logger.info ("Reply: ")
		Rails.logger.info (message[1])
	end

	def devicecommand
		Rails.logger.info ("Command: ")
    	Rails.logger.info (message)
	end

	def devicestatus
		Rails.logger.info ("Status: ")
    	Rails.logger.info (message)
	end

	def devicelog

		Rails.logger.info ("Snapshot: ")
    	Rails.logger.info (message)

		msg = message[0]

	    mi = msg[:metainfo]
	    data = msg[:data]

	    

	    @locations = Device.find(mi[:deviceid]).locations

	    @locations.each do |location|

	    	if (mi[:devicetype] == "kern") then

	    		s = Sample.find(location.sample_id)

	    		Rails.logger.info ("Weight: ")
    			Rails.logger.info (data[:weight])

    			Rails.logger.info ("Sample: ")
    			Rails.logger.info (s.id)

	    		s.actual_amount = data[:weight]
	    		s.save

    		end
	    	
	    end
	end

end

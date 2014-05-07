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

	    	puts "location "+location.id.to_s

	    	if (mi[:devicetype] == "kern") then

	    		begin

	    		if data[:weight].nil? then data = data[0] end

	    		Rails.logger.info ("Its a kern")

	    		Rails.logger.info (data)

	    		Rails.logger.info (data[:weight])

	    		weightstring = data[:weight][0].split(" ").first

	    		Rails.logger.info (weightstring)

	    		myvalue = weightstring.gsub(/[\[,\],g,m]/, '')

	    		Rails.logger.info (myvalue)

	    		myunit = weightstring.gsub(/[0-9,\[,\],\.]/, '')

	    		Rails.logger.info (myunit)

	    		if myunit == "g" then

	    			myvalue = (myvalue.to_d * 1000).to_s

	    			myunit = "mg"

	    			# convert into mg

	    		end

	    		Rails.logger.info ("Conversion done")


	    		s = Sample.find(location.sample_id)

	    		Rails.logger.info ("location.sample_id "+location.sample_id.to_s)

	    		Rails.logger.info ("Weight: ")
    			Rails.logger.info (data[:weight])

    			Rails.logger.info ("Sample: ")
    			Rails.logger.info (s.id)

	    		s.actual_amount = myvalue

	    		if !(s.unit == myunit) then 

	    			if myunit == "g" then

	    				s.target_amount = (s.target_amount.to_d * 1000).to_s
	    			end

	    		end

	    		s.unit = myunit

	    		s.save

	    		rescue

	    			Rails.logger.info ("Error occured")

	    		ensure

	    			Rails.logger.info ("Message processed")

	    		end

    		end
	    	
	    end
	end

end

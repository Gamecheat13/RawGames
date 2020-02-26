-- object colosseum_megalazer_control


--## SERVER

function colosseum_megalazer_control:init()

	print ("initialize megalazer");

	SleepUntil ([| device_get_position(self) > 0], 1);
		
		RunClientScript ("triggerawesomness");
	
		print ("trigger testing pewpew");
	
	
end
				

--## CLIENT


function remoteClient.triggerawesomness()

	print ("Begin Countdown");

 end


-- object arc_vista_rocket
--## SERVER

function arc_vista_rocket:init()
	arc_vista_rocket:launchrockets (self);
	--print ("kicking off rocket stuff");
end

function arc_vista_rocket:launchrockets(self:object)
	RunClientScript ("arc_vista_rocket");
	--print ("client script fired");
end


--## CLIENT

function remoteClient.arc_vista_rocket() 
	--local obj:object = self;

	-- Attacker Home Base Rocket - 2:00
	--if self == OBJECTS.rocket03 then
	sleep_s(120);
	--print ("firing rocket 3");
	play_animation_on_object(OBJECTS.rocket03,"any:launch");
	object_set_function_variable (OBJECTS.rocket03, "rocket_launch", 1, 2)
	--end
	
	--if self == OBJECTS.rocket02 then
	print ("firing rocket 2");
	-- Rocket to left of Crane Pit - 4:00
	sleep_s(120);
	play_animation_on_object(OBJECTS.rocket02,"any:launch");
	object_set_function_variable (OBJECTS.rocket02, "rocket_launch", 1, 2)
	--print ("firing rocket 4");
	--end
	
	--if self == OBJECTS.rocket04 then
	-- Rocket on water in-between Home Bases - 9:00
	sleep_s(300);
	play_animation_on_object(OBJECTS.rocket04,"any:launch");	
	object_set_function_variable (OBJECTS.rocket04, "rocket_launch", 1, 2)
	--end
	
	--if self == OBJECTS.rocket01 then
	--print ("firing rocket 1");
	-- Crane Pit Rocket - 12:15
	sleep_s(195);
	play_animation_on_object(OBJECTS.rocket01,"any:launch");
	object_set_function_variable (OBJECTS.rocket01, "rocket_launch", 1, 2)
	--end
	
	--if self == OBJECTS.rocket05 then
	--print ("firing rocket 5");
	-- Crane Pit Rocket - 14:30
	sleep_s(135);
	play_animation_on_object(OBJECTS.rocket05,"any:launch");
	object_set_function_variable (OBJECTS.rocket05, "rocket_launch", 1, 2)
	--end
end

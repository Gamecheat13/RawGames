-- object dest_towers_platform

--## SERVER


function dest_towers_platform:init()
	
 	local obj:object = self;

	device_set_power( self, 1 );
	
	RunClientScript ("dest_towers_platform_flare");
	object_wake_physics(obj);
	SleepUntil ([| object_get_health(obj) < .85], 1);
	PlayAnimation(obj,1,"device:position",30);
	--fx scripts
		print ("turning off laser");
		object_set_function_variable (self, "laser_shutdown", 1.0, 5.0 );
		--object_set_function_variable (self, "audio_laser_shutdown", 1.0, 5.0 );
		SoundImpulseStartServer(TAG('sound\031_states\031_st_osiris_multiplayer_towers\031_st_osiris_multiplayer_towers_laserdeactive.sound'), nil, 1);
		sleep_s (5);
		print ("killing laser flare");
		effect_kill_object_marker(TAG('levels\assets\osiris\props\mp_towers\mp_towers_drill_platform\fx\drill_flare.effect'), self, "fx_laser");
		--effect_kill_object_marker(TAG('levels\assets\osiris\props\mp_towers\mp_towers_drill_platform\fx\drill_flare.effect'), FLAGS.fx_dest_laser_flare);
	device_set_position(OBJECTS.capsule1,1);
	device_set_position(OBJECTS.capsule2,1);
    object_wake_physics(OBJECTS.reactor1);
	object_wake_physics(OBJECTS.reactor2);
	repeat
		object_set_health(obj,1);
		SleepUntil ([| object_get_health(obj) < .9], 1);
		PlayAnimation(obj,1,"any:damage",30);			
	until false
			
end

--## CLIENT

function remoteClient.dest_towers_platform_flare()

	effect_new_on_object_marker(TAG('levels\assets\osiris\props\mp_towers\mp_towers_drill_platform\fx\drill_flare.effect'), OBJECTS.drill_platform, "fx_laser");
	print ("activate laser");
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_multiplayer_towers\031_st_osiris_multiplayer_towers_laseractive.sound'), nil, 1)
	
end

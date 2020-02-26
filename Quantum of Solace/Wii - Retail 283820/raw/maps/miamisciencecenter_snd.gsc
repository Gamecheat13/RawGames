#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;

main()
{




level.air_vent_zone_emitter = getent( "air_vent_zone_emitter", "targetname" ); 
level.air_vent_zone_emitter playloopsound("amb_Sci_Center_Roof_AirVent_ze");

level.ac_01_zone_emitter = getent( "ac_01_zone_emitter", "targetname" ); 
level.ac_01_zone_emitter playloopsound("amb_Sci_Center_Roof_AirCond01_ze");

level.ac_02_zone_emitter = getent( "ac_02_zone_emitter", "targetname" ); 
level.ac_02_zone_emitter playloopsound("amb_Sci_Center_Roof_AirCond02_ze");

level.gen_01_zone_emitter = getent( "gen_01_zone_emitter", "targetname" ); 
level.gen_01_zone_emitter playloopsound("amb_Sci_Center_Roof_Generator01_ze");

level.gen_02_zone_emitter = getent( "gen_02_zone_emitter", "targetname" ); 
level.gen_02_zone_emitter playloopsound("amb_Sci_Center_Roof_Generator02_ze");

level.rain_01_zone_emitter = getent( "rain_01_zone_emitter", "targetname" ); 
level.rain_01_zone_emitter playloopsound("Spot_Rain_Metal_01_ze");

level.rain_02_zone_emitter = getent( "rain_02_zone_emitter", "targetname" ); 
level.rain_02_zone_emitter playloopsound("Spot_Rain_Metal_02_ze");

level.rain_03_zone_emitter = getent( "rain_03_zone_emitter", "targetname" ); 
level.rain_03_zone_emitter playloopsound("Spot_Rain_Metal_03_ze");

level.rain_04_zone_emitter = getent( "rain_04_zone_emitter", "targetname" ); 
level.rain_04_zone_emitter playloopsound("Spot_Rain_Glass_01_ze");

level.dump_rain_zone_emitter = getent( "dump_rain_zone_emitter", "targetname" ); 
	if ( IsDefined(level.dump_rain_zone_emitter) )
	{
		level.dump_rain_zone_emitter playloopsound("Spot_Rain_Plastic_ze");
	}




	bond = level.player; 

	
	


















































	loopSound("amb_water_drips_concrete", (2946, -1093, -84), 8.445);
	loopSound("amb_water_drips_concrete", (1604, -1073, -36), 8.445);
	loopSound("amb_water_drips_concrete", (2726, -1113, -37), 8.445);
	loopSound("amb_water_drips_with_metal", (2911, -1120, -84), 7.409);


	loopSound("amb_truck_idle_far", (3076, 1874, -40), 5.613);
	loopSound("amb_truck_idle_far", (3112, 2099, -49), 5.613);
	loopsound("amb_truck_idle_int_rumble", (3076, 1874, -40), 5.571);
	loopsound("amb_truck_idle_int_rumble", (3112, 2099, -49), 5.571);


	



	
	
	loopSound("amb_flies01", (2954, -614, -72), 8.362);	
	loopSound("amb_flies01", (2982, -432, -58), 8.362);		
	loopSound("amb_flies01", (2955.9, -904.1, -104.5), 8.362);
	loopSound("amb_flies02", (3222.4, -868.8, -104), 7.812);
	loopSound("amb_flies01", (2934.5, -612.5, -104), 8.362);
	loopSound("amb_flies02", (2932.1, -327.2, -104), 7.812);
	loopSound("amb_flies01", (3215.7, 145.4, -70), 8.362);
	loopSound("amb_flies02", (3212.5, 617.7, -104), 7.812);
	loopSound("amb_flies01", (3179.6, 645.2, -111.5), 8.362);
	loopSound("amb_flies01", (3353, 2027, -63), 8.362);
	loopSound("hum_laptop", (3138, 1101, -63), 23.327);	
	
	

	loopSound("soda_machine", (3495, 1559, -43), 1.385);
	loopSound("ice_machine", (3537, 1565, -55), 2.428);
	loopSound("hot_water_heater", (3516, 1687, -67), 6.868);



	loopSound("amb_Sci_Center_Roof_AirCond01", (1760, 960, -96), 8.563);
	loopSound("amb_Sci_Center_Roof_AirCond02", (1952, 960, -96), 3.835);


	loopSound("amb_elec_hum01", (2352, 1296, -104), 1.633);
	loopSound("amb_elec_hum02", (2512, 1296, -104), 3.249);
	loopSound("amb_elec_hum01", (2304, 960, -104), 1.633);


	loopsound("Searchlight_generator_02", (2371, 2208, -41), 3.829);


	loopSound("amb_Sci_Center_Roof_AirCond01", (1376, 976, 176), 8.563);
	loopSound("amb_Sci_Center_Roof_AirCond02", (1376, 832, 176), 3.835);


	
	
	
	
	loopSound("amb_Sci_Center_Roof_AirCond01", (3538, -3219, 434), 8.563);	
	loopSound("amb_Sci_Center_Roof_AirCond02", (3479, -3217, 434), 3.835);		
	
	loopSound("amb_Sci_Center_Roof_Pump_Mach", (3191, -3233, 438), 7.082);	
	loopSound("amb_elec_hum02", (3006, -3069, 459), 3.249);	
	loopSound("amb_elec_hum02", (3670, -3092, 439), 3.249);	
	
	


	
	
	
	

	
	
	
	

	
	
	
	

	
	
	
	

	
	



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	



	package = "front_pkg";
	declareAmbientPackage( package );

	package = "alley_pkg";
	declareAmbientPackage( package );

	package = "truck_pkg";
	declareAmbientPackage( package );

	package = "back_pkg";
	declareAmbientPackage( package );

	package = "truckback_pkg";
	declareAmbientPackage( package );

	package = "roof_pkg";
	declareAmbientPackage( package );

	package = "side_pkg";
	declareAmbientPackage( package );

	package = "catwalk_pkg";
	declareAmbientPackage( package );

	package = "stair_pkg";
	declareAmbientPackage( package );

	package = "halls_pkg";
	declareAmbientPackage( package );

	package = "elev_pkg";
	declareAmbientPackage( package );

	package = "main_pkg";
	declareAmbientPackage( package );

	room = "front_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_front",.5, .5  );
	setAmbientRoomReverb( room, "city", 1, .8 );

	room = "alley_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_Sci_Center_street_level",.5, .5  );
	setAmbientRoomReverb( room, "alley", 1, .6 );
	
	room = "street_level_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_Sci_Center_street_level",.5, .5  );
	setAmbientRoomReverb( room, "city", 1, .8 );	

	room = "truck_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_truck_int",.5, .5  );
	setAmbientRoomReverb( room, "room", 1, .7 );

	room = "back_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_Sci_Center_back_room",.5, .5  );
	setAmbientRoomReverb( room, "stoneroom", 1, .4 );

	room = "truckback_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_parkinglot",.5, .5  );
	setAmbientRoomReverb( room, "room", 1, .7 );

	room = "roof_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_roof",.5, .5  );
	setAmbientRoomReverb( room, "stoneroom", 1, .2 );

	room = "side_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_Sci_Center_side_room",.5, .5  );
	setAmbientRoomReverb( room,  "stoneroom", 1, .4 );

	room = "catwalk_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_catwalk_int",.5, .5  );
	setAmbientRoomReverb( room, "auditorium", 1, .5 );

	room = "stair_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_stairwell_int",.5, .5  );
	setAmbientRoomReverb( room, "stonecorridor", 1, .5 );

	room = "halls_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_bright_hallways_int",.5, .5  );
	setAmbientRoomReverb( room, "hallway", 1, .5 );

	room = "elev_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_elevator_shaft",.5, .5  );
	setAmbientRoomReverb( room, "room", 1, .7 );

	room = "main_room";
	declareAmbientRoom( room );
	setAmbientRoomTone( room, "amb_bg_sci_center_main_hall",.5, .5  );
	setAmbientRoomReverb( room, "auditorium", 1, .5 );

	setBaseAmbientPackageAndRoom( "front_pkg", "front_room" );

	signalAmbientPackageDeclarationComplete();
	








	    level thread pipe_creak_play();	
	
	    array_thread(GetEntArray("dumpster_trigger", "targetname"), ::dumpster);
	    array_thread(GetEntArray("can_trigger", "targetname"), ::can);
	    array_thread(GetEntArray("bag_trigger", "targetname"), ::bag);
	    array_thread(GetEntArray("box_trigger", "targetname"), ::box);
	    array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);
}






 



 




pipe_creak_play()
{
	pipe_creak_trigger_var = GetEnt("pipe_creak_trigger", "targetname");
	pipe_creak_org_var = GetEnt("pipe_creak_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(pipe_creak_trigger_var) && IsDefined(pipe_creak_org_var) )
	{
		pipe_creak_trigger_var waittill ("trigger");
		pipe_creak_org_var playsound ("pipe_creak");
	}
	
}


dumpster()
{
	
	dumpster_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(dumpster_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			
			
				dumpster_org_var playsound ("dump_bump");
				
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			
			
			
			
				
				
				
				
				
			
		}
		

	
}


can()
{
	
	can_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(can_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				can_org_var playsound ("can_bump");
				
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}


bag()
{
	
	bag_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(bag_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				bag_org_var playsound ("bag_bump");
				
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}


box()
{
	
	box_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(box_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				box_org_var playsound ("box_bump");
				
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}


fence()
{
	
	fence_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(fence_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				fence_org_var playsound ("fence_bump");
				
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}
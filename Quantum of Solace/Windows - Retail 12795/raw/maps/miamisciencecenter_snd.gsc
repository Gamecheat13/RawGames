#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;

main()
{


//Zone Emitters

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


//Quick Kills

	bond = level.player; 

	// example: the "wpn_p99_fire_plyr" soundalias is played when the "action_1" notetrack is sent by bond
	// interaction_add_repeating_notetrack_sound( "action_1", "wpn_p99_fire_plyr", bond );


//QKGrbPnch Input
//FRAME 209 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_gp_input", "snd_gp_input", bond );

//QKGrbPnch Lead
//FRAME 195 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_gp_lead", "snd_gp_lead", bond );

//QKGrbPnch Success
//FRAME 230 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_gp_sucsess", "snd_gp_success", bond );

//QKGrbPnch Fail
//FRAME 230 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_gp_fail", "snd_gp_fail", bond );

//QKNeckSnap Input
//FRAME 112 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_ns_input", "snd_ns_input", bond );

//QKNeckSnap Lead
//FRAME 97 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_ns_lead", "snd_ns_lead", bond );

//QKNeckSnap Success
//FRAME 132 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_ns_sucsess", "snd_ns_success", bond );

//QKNeckSnap Fail
//FRAME 170 First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_ns_fail", "snd_ns_fail", bond );

//QKRoofThrow Lead
// First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_tr_lead", "snd_tr_lead", bond );

//QKRoofThrow Success
// First Frame Of Anim
//	interaction_add_repeating_notetrack_sound( "notesound_tr_sucsess", "snd_tr_success", bond );


// Ambient Emitters





//Water Dripping
	loopSound("amb_water_drips_concrete", (2946, -1093, -84), 8.445);
	loopSound("amb_water_drips_concrete", (1604, -1073, -36), 8.445);
	loopSound("amb_water_drips_concrete", (2726, -1113, -37), 8.445);
	loopSound("amb_water_drips_with_metal", (2911, -1120, -84), 7.409);

//semi trucks in alley
	loopSound("amb_truck_idle_far", (3076, 1874, -40), 5.613);
	loopSound("amb_truck_idle_far", (3112, 2099, -49), 5.613);
	loopsound("amb_truck_idle_int_rumble", (3076, 1874, -40), 5.571);
	loopsound("amb_truck_idle_int_rumble", (3112, 2099, -49), 5.571);

//flies on trash
	//out front
//	loopSound("amb_flies01", (-256, -1280, -96), 8.362);
//	loopSound("amb_flies02", (1280, -1280, -96), 7.812);

	//in the alley
	loopSound("amb_flies01", (2932, -1060, -57), 8.362);	
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
	
	
// Corner room after lockpick - amb stuff
	loopSound("soda_machine", (3495, 1559, -43), 1.385);
	loopSound("ice_machine", (3537, 1565, -55), 2.428);
	loopSound("hot_water_heater", (3516, 1687, -67), 6.868);


//ac units in back parking lot
	loopSound("amb_Sci_Center_Roof_AirCond01", (1760, 960, -96), 8.563);
	loopSound("amb_Sci_Center_Roof_AirCond02", (1952, 960, -96), 3.835);

//generators in back parking lot
	loopSound("amb_elec_hum01", (2352, 1296, -104), 1.633);
	loopSound("amb_elec_hum02", (2512, 1296, -104), 3.249);
	loopSound("amb_elec_hum01", (2304, 960, -104), 1.633);

//spotlight in back parking lot
	loopsound("Searchlight_generator_02", (2371, 2208, -41), 3.829);

//mid ac units
	loopSound("amb_Sci_Center_Roof_AirCond01", (1376, 976, 176), 8.563);
	loopSound("amb_Sci_Center_Roof_AirCond02", (1376, 832, 176), 3.835);

//roof top sounds - billboard roof
	//loopSound("amb_Sci_Center_Roof_AirVent", (3585, -3006, 415), 28.786);
	//loopSound("amb_Sci_Center_Roof_AirVent", (3073, -2816, 419), 28.786);
	
	//loopSound("amb_Sci_Center_Roof_AirCond03", (3596, -3236, 437), 9.666);	
	loopSound("amb_Sci_Center_Roof_AirCond01", (3538, -3219, 434), 8.563);	
	loopSound("amb_Sci_Center_Roof_AirCond02", (3479, -3217, 434), 3.835);		
	
	loopSound("amb_Sci_Center_Roof_Pump_Mach", (3191, -3233, 438), 7.082);	
	loopSound("amb_elec_hum02", (3006, -3069, 459), 3.249);	
	loopSound("amb_elec_hum02", (3670, -3092, 439), 3.249);	
	
	

//roof top sounds
	//loopSound("amb_Sci_Center_Roof_AirCond01", (368, 3024, 928), 8.563);
	//loopSound("amb_Sci_Center_Roof_AirCond02", (520, 3024, 928), 3.835);
	//loopSound("amb_Sci_Center_Roof_Generator01", (0, 2368, 928), 6.12);
	//loopSound("amb_Sci_Center_Roof_Generator02", (-528, 2560, 928), 4.214);

	//loopSound("amb_Sci_Center_Roof_AirCond01", (-24, 816, 928), 8.563);
	//loopSound("amb_Sci_Center_Roof_AirCond02", (152, 608, 928), 3.835);
	//loopSound("amb_Sci_Center_Roof_Generator01", (2280, 0, 928), 6.12);
	//loopSound("amb_Sci_Center_Roof_Generator02", (-2272, 0, 928), 4.214);

	//loopSound("amb_Sci_Center_Roof_AirCond01", (652, -100, 928), 8.563);
	//loopSound("amb_Sci_Center_Roof_AirCond02", (-1536, 192, 928), 3.835);
	//loopSound("amb_Sci_Center_Roof_Generator01", (-400, 2240, 928), 6.12);
	//loopSound("amb_Sci_Center_Roof_Generator02", (-400, 2048, 928), 4.214);

	//loopSound("amb_Sci_Center_Roof_AirCond01", (400, 1664, 928), 8.563);
	//loopSound("amb_Sci_Center_Roof_AirCond02", (400, 1472, 928), 3.835);
	//loopSound("amb_Sci_Center_Roof_Generator01", (-256, 800, 928), 6.12);
	//loopSound("amb_Sci_Center_Roof_Generator02", (-504, 992, 928), 4.214);

	//loopSound("amb_sci_center_roof_rumble", (-400, 2046, 928), 6.104);
	//loopSound("amb_sci_center_roof_rumble", (400, 1668, 928), 6.104);


//Spot Rain
	//loopSound("Rain_Metal_Grate", (33, 3221, 1042), 6.826);
	//loopSound("Spot_Rain_Metal_01", (582, 3075, 1021), 4.800);
	//loopSound("Spot_Rain_Metal_01", (1987, 1403, -3), 6.826);
	//loopSound("Spot_Rain_Glass_01", (-3, 1969, 1000), 5.072);
	//loopSound("Spot_Rain_Glass_01", (-1, 1673, 1008), 5.072);
	//loopSound("Spot_Rain_Glass_01", (-3, 1395, 1015), 5.072);
	//loopSound("Spot_Rain_Glass_01", (0, 1074, 996), 5.072);
	//loopSound("Spot_Rain_Glass_01", (-1, 36, 1014), 5.072);
	//loopSound("Spot_Rain_Metal_04", (2462, 1330, 6), 6.826);
	//loopSound("Spot_Rain_Metal_04", (1778, 993, 31), 6.826);
	//loopSound("Spot_Rain_Metal_02", (1916, 1663, 12), 7.346);
	//loopSound("Spot_Rain_Metal_03", (2767, 1806, 13), 6.826);
	//loopSound("Spot_Rain_Metal_03", (1761, 1966, 16), 6.826);
	//loopSound("Spot_Rain_Metal_03", (1479, 1416, 18), 6.826);
	
//Cab Radios
	//loopSound("Radio_Dispatches", (508, -1390, -59), 63.829);
	//loopSound("Van_Radio", (1035, -1428, -38), 326.632);
	//loopSound("Distant_Car_Alarm", (-2899, -3225, -46), 160.893);	

//ambients

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
	


//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************

	    level thread pipe_creak_play();	
	
	    array_thread(GetEntArray("dumpster_trigger", "targetname"), ::dumpster);
	    array_thread(GetEntArray("can_trigger", "targetname"), ::can);
	    array_thread(GetEntArray("bag_trigger", "targetname"), ::bag);
	    array_thread(GetEntArray("box_trigger", "targetname"), ::box);
	    array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);
}




//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************	    


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
	
	//level endon ("insert_notify");
	
	if ( IsDefined(dumpster_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 50 < lengthsquared( level.player getplayervelocity() ) )
			//{
				dumpster_org_var playsound ("dump_bump");
				//iprintlnbold ("SOUND: dump_bump");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


can()
{
	
	can_org_var = GetEnt(self.target, "targetname");
	
	//level endon ("insert_notify");
	
	if ( IsDefined(can_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				can_org_var playsound ("can_bump");
				//iprintlnbold ("SOUND: can_bump");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
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
	
	//level endon ("insert_notify");
	
	if ( IsDefined(bag_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				bag_org_var playsound ("bag_bump");
				//iprintlnbold ("SOUND: bag_bump");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
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
	
	//level endon ("insert_notify");
	
	if ( IsDefined(box_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				box_org_var playsound ("box_bump");
				//iprintlnbold ("SOUND: box_bump");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
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
	
	//level endon ("insert_notify");
	
	if ( IsDefined(fence_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				fence_org_var playsound ("fence_bump");
				//iprintlnbold ("SOUND: fence_bump");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}
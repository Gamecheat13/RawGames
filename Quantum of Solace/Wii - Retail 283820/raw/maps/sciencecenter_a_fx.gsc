#include maps\_utility;


main()
{
	precacheFX();
	
	
	registerFXTargetName("fx_debug");			
	registerFXTargetName("fx_OK");
	
	
	registerFXTargetName("street_car_mist1");			
	registerFXTargetName("street_car_mist2");			
	
	registerFXTargetName("gate_lock_break");
	
	registerFXTargetName("transformer_distraction");
	registerFXTargetName("trailer_lift_hydro_cut");
	registerFXTargetName("fire_escape_ladder_fall");
	
	registerFXTargetName("facade_ledge_crumble");
	registerFXTargetName("facade_ledge_crumble2");
	
	registerFXTargetName("roof_trap_steam_leak");
	registerFXTargetName("roof_trap_steam_burst");
	registerFXTargetName("ledge_pigeons");
	
	registerFXTargetName("roof_fan_loop");
	registerFXTargetName("roof_fan_wobble");
	registerFXTargetName("roof_fan_explode");
	registerFXTargetName("chopper_smoldering"); 
	
	
	registerFXTargetName("catwalk_light_fall");	
		
	
	initFXModelAnims();
	
	
	maps\createfx\sciencecenter_a_fx::main();
	
	setExpFog(0,3700,.075,.125,.125,0);
		
	
	level notify("fx_OK");
	
	
	
}






initFXModelAnims()
{
	
	ent1 = getent( "fxanim_trash_intro_looping", "targetname" );	
	ent2 = getent( "fxanim_trash_intro_01", "targetname" );
	ent3 = getent( "fxanim_telephoneWires_looping", "targetname" );
	ent5 = getent( "fxanim_roaches3", "targetname" );
	ent6 = getent( "fxanim_roaches2", "targetname" );
	ent7 = getent( "fxanim_trash_intro_02", "targetname" );
	ent8 = getent( "fxanim_trash_alley_looping", "targetname" );	
	ent9 = getent( "fxanim_trash_lot_looping", "targetname" );
	ent10 = getent( "fxanim_trash_intro_looping_02", "targetname" );
	ent11 = getent( "fxanim_trash_alley_nonlooping", "targetname" );	
	ent12 = getent( "fxanim_trash_alley_looping_02", "targetname" );
	ent_wires = getent( "fxanim_heli_wire", "targetname" );	
	
	
	ent13 = getentarray( "fxanim_trashswirl", "targetname" );	
	for ( i = 0; i < ent13.size; i++ )
	{
		if (IsDefined(ent13[i])) { ent13[i] thread anim13event(); println("************* trash swirl ****************"); }	
	}
		
	ent16 = getent( "fxanim_wire_snap", "targetname" );	
	
	
	ent17 = getentarray( "fxanim_streamer", "targetname" );	
	for ( i = 0; i < ent17.size; i++ )
	{
		if (IsDefined(ent17[i])) { ent17[i] thread anim17event(); println("************* streamer ****************"); }	
	}
	
	
	if (IsDefined(ent1)) { ent1 thread anim1event();   println("************* 1 ****************"); }
	if (IsDefined(ent2)) { ent2 thread anim2event();   println("************* 2 ****************"); }
	if (IsDefined(ent3)) { ent3 thread anim3event();   println("************* telwires looping ****************"); }
	if (IsDefined(ent5)) { ent5 thread anim5event();   println("************* 5 ****************"); }
	if (IsDefined(ent6)) { ent6 thread anim6event();   println("************* 6 ****************"); }
	if (IsDefined(ent7)) { ent7 thread anim7event();   println("************* 7 ****************"); }
	if (IsDefined(ent8)) { ent8 thread anim8event();   println("************* 8 ****************"); }
	if (IsDefined(ent9)) { ent9 thread anim9event();   println("************* 9 ****************"); }
	if (IsDefined(ent10)) { ent10 thread anim10event(); println("************* 10 ****************"); }
	if (IsDefined(ent11)) { ent11 thread anim11event(); println("************* 11 ****************"); }
	if (IsDefined(ent12)) { ent12 thread anim12event(); println("************* 12 ****************"); }
	if (IsDefined(ent_wires)) { ent_wires thread anim_heli_wire(); println("************* heli_wire ****************"); }
	if (IsDefined(ent16)) { ent16 thread anim16event(); println("************* wire snap ****************"); }
	
	
}

#using_animtree("fxanim_trash_intro_looping");
anim1event()
{	
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("tes1", self.origin, self.angles, %fxanim_trash_intro_looping);
}

#using_animtree("fxanim_trash_intro_01");
anim2event()
{
	wait(1.0);   
	self UseAnimTree(#animtree);
	self animscripted("test2", self.origin, self.angles, %fxanim_trash_intro_01);
}

#using_animtree("fxanim_telephoneWires_looping");
anim3event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test3", self.origin, self.angles, %fxanim_telephoneWires_looping);
}

#using_animtree("fxanim_roaches3");
anim5event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test5", self.origin, self.angles, %fxanim_roaches3);
}

#using_animtree("fxanim_roaches2");
anim6event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test6", self.origin, self.angles, %fxanim_roaches2);
}

#using_animtree("fxanim_trash_intro_02");
anim7event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test7", self.origin, self.angles, %fxanim_trash_intro_02);
}

#using_animtree("fxanim_trash_alley_looping");
anim8event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test8", self.origin, self.angles, %fxanim_trash_alley_looping);
}

#using_animtree("fxanim_trash_lot_looping");
anim9event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test9", self.origin, self.angles, %fxanim_trash_lot_looping);
}

#using_animtree("fxanim_trash_intro_looping_02");
anim10event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test10", self.origin, self.angles, %fxanim_trash_intro_looping_02);
}


#using_animtree("fxanim_trash_alley_nonlooping");
anim11event()
{
	level waittill("alley_trash_nonlooping_start");
	self UseAnimTree(#animtree);
	self animscripted("test11", self.origin, self.angles, %fxanim_trash_alley_nonlooping);
}


#using_animtree("fxanim_trash_alley_looping_02");
anim12event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test12", self.origin, self.angles, %fxanim_trash_alley_looping_02);
}

#using_animtree("fxanim_trashSwirl");
anim13event()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("test13", self.origin, self.angles, %fxanim_trashSwirl);
}

#using_animtree("fxanim_wire_snap");
anim16event()
{
	level waittill("transformer_distraction");
	self UseAnimTree(#animtree);
	self animscripted("wiresnap", self.origin, self.angles, %fxanim_wire_snap);
}

#using_animtree("fxanim_streamer");
anim17event()
{	
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("streamer", self.origin, self.angles, %fxanim_streamer);
}

#using_animtree("fxanim_heli_wire_loop");
anim_heli_wire()
{
	
	self UseAnimTree(#animtree);
	self animscripted("a_heli_wire_loop", self.origin, self.angles, %fxanim_heli_wire_loop);
	
	
	level waittill("heli_wire_cut_start");
	self stopanimscripted();
	self stopuseanimtree();
	heli_wire_cut();
}

#using_animtree("fxanim_heli_wire_cut");
heli_wire_cut(){

	
	level notify("powers_line_pop");
	
	playfxontag( level._effect["science_powerline_pop"], self, "wire_1a_7_jnt" );
	playfxontag( level._effect["science_powerline_pop"], self, "wire_1b_6_jnt" );
	
	playfxontag( level._effect["science_powerline_pop"], self, "wire_2a_7_jnt" );
	playfxontag( level._effect["science_powerline_pop"], self, "wire_2b_6_jnt" );
	
	playfxontag( level._effect["science_powerline_pop"], self, "wire_3a_7_jnt" );
	playfxontag( level._effect["science_powerline_pop"], self, "wire_3b_6_jnt" );
	
	self UseAnimTree(#animtree);
	self animscripted("a_heli_wire_cut", self.origin, self.angles, %fxanim_heli_wire_cut);
}








precacheFX()
{
	level._effect["default_explosion"]				= loadfx ("explosions/default_explosion");
	level._effect["fireExtinguisherBreaking"]	= loadfx ("explosions/pipe_explosion128");		
	level._effect["fireExtinguisherSteam"] 		= loadfx ("impacts/pipe_steam");
	level._effect["glassBreakSmall"] 				  = loadfx ("impacts/large_glass");

	
	level._effect["science_lightbeam01"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam01");
	level._effect["science_lightbeam02"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam02");
	level._effect["science_lightbeam03"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam03");
	level._effect["science_lightbeam04"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam04");
	level._effect["science_lightbeam05"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam05");
	level._effect["science_lightbeam06"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam06");
	level._effect["science_lightbeam07"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam07");

	level._effect["science_lightbeam09"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam09");

	level._effect["science_flashlight_beam"] 	= loadfx ("maps/miamisciencecenter/science_flashlight_beam");
	
	level._effect["science_car_headlight01"] 	= loadfx ("maps/miamisciencecenter/science_car_headlight01");
	
	





	level._effect["science_truck_exhaust"] 				= loadfx ("maps/miamisciencecenter/science_truck_exhaust");



	level._effect["science_moonlight01"] 					= loadfx ("maps/miamisciencecenter/science_moonlight01");
	
	
	
	
	
	
	
	
	
	level._effect["science_dripping_water01"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water01");
	level._effect["science_dripping_water02"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water02");
	level._effect["science_dripping_water03"]		 	= loadfx ("maps/miamisciencecenter/science_dripping_water03");
	level._effect["science_dripping_water04"] 		= loadfx ("maps/miamisciencecenter/science_dripping_water04");
	level._effect["science_dripping_water05"]		 	= loadfx ("maps/miamisciencecenter/science_dripping_water05");
	level._effect["science_startled_birds"] 			= loadfx ("maps/miamisciencecenter/science_startled_birds");
	
	level._effect["science_water_sprinkler01"] 		= loadfx ("maps/miamisciencecenter/science_water_sprinkler01");
	level._effect["science_water_walls01"] 				= loadfx ("maps/miamisciencecenter/science_water_walls01");
	level._effect["science_water_floor"] 					= loadfx ("maps/miamisciencecenter/science_water_floor01");
	level._effect["science_pipe_steam01"] 				= loadfx ("maps/miamisciencecenter/science_pipe_steam01");
	

	level._effect["science_streetlamp01"]		 			= loadfx ("maps/miamisciencecenter/science_streetlamp01");
	level._effect["science_streetlamp01_BX"]		 			= loadfx ("maps/miamisciencecenter/science_streetlamp01_BX");


        level._effect["science_truck_heat"] 					= loadfx ("maps/miamisciencecenter/science_truck_heat");
	level._effect["science_cockroaches"] 					= loadfx ("maps/miamisciencecenter/science_cockroaches");
	level._effect["science_truck_interior_light"] = loadfx ("maps/miamisciencecenter/science_truck_interior_light");
	


	level._effect["science_outdoor_light01"] 				= loadfx ("maps/miamisciencecenter/science_outdoor_light01");
	level._effect["science_falling_debris"] 				= loadfx ("maps/miamisciencecenter/science_falling_debris");
	level._effect["science_security_light"] 				= loadfx ("maps/miamisciencecenter/science_security_light");
	level._effect["science_billboard_sparks1"] 				= loadfx ("maps/miamisciencecenter/science_billboard_sparks1");
	level._effect["science_billboard_sparks2"] 				= loadfx ("maps/miamisciencecenter/science_billboard_sparks2");
	
	
	level._effect["science_copter_searchlite"]			= loadfx ("maps/miamisciencecenter/science_copter_searchlite");
	level._effect["science_steam_shot"] 						= loadfx ("maps/miamisciencecenter/science_steam_shot");
	level._effect["science_lock_break"] 						= loadfx ("maps/miamisciencecenter/science_lock_break");
	level._effect["science_hydraulic_leak"] 				= loadfx ("maps/miamisciencecenter/science_hydraulic_leak");
	level._effect["science_transfrmr_shortcirc01"] 	= loadfx ("maps/miamisciencecenter/science_transfrmr_shortcirc01");
	level._effect["science_transfrmr_shortcirc02"] 	= loadfx ("maps/miamisciencecenter/science_transfrmr_shortcirc02");
	level._effect["science_roof_steam_leak_s"] 			= loadfx ("maps/miamisciencecenter/science_roof_steam_leak_s");
	level._effect["science_roof_steam_leak_l"] 			= loadfx ("maps/miamisciencecenter/science_roof_steam_leak_l");
	level._effect["science_sparks_smoke"] 					= loadfx ("maps/miamisciencecenter/science_sparks_smoke");
	level._effect["science_camera_fov"] 						= loadfx ("maps/miamisciencecenter/science_camera_fov");


	level._effect["heli_explosion"]				= loadfx ("explosions/large_vehicle_explosion");

	











	level._effect["rain_runner"] = loadfx("weather/rain_runner");
    
	
	level._effect["rain_9"] = loadfx("weather/rain_9");
	

	
	level._effect["rain_9_oneshot"] = loadfx("weather/rain_9_oneshot");
	

	
	

	level._effect["science_chopper_fire"] 				= loadfx ("maps/miamisciencecenter/science_chopper_fire");
	level._effect["science_chopper_boom"] 				= loadfx ("maps/miamisciencecenter/science_chopper_boom");
	level._effect["science_chopper_death"] 				= loadfx ("maps/miamisciencecenter/science_chopper_death");
	level._effect["science_chopper_smolder"] 			= loadfx ("maps/miamisciencecenter/science_chopper_smolder");
	level._effect["science_powerline_sparks"] 			= loadfx ("maps/miamisciencecenter/science_powerline_sparks_r");
	level._effect["science_powerline_sparks1"] 			= loadfx ("maps/miamisciencecenter/science_powerline_sparks1");
	level._effect["science_powerline_sparks2"] 			= loadfx ("maps/miamisciencecenter/science_powerline_sparks2");
	level._effect["science_powerline_pop"] 				= loadfx ("maps/miamisciencecenter/science_powerline_pop_r");
	
	level._effect["science_end_door_light"] 			= loadfx ("maps/miamisciencecenter/science_end_door_light");
	level._effect["science_roof_vent"] 					= loadfx ("maps/miamisciencecenter/science_roof_vent");
}

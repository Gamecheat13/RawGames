#include maps\_utility;


main()
{
	
	
	

	precacheFX();
	
	
	registerFXTargetName("fx_debug");							
	registerFXTargetName("fx_OK");
	registerFXTargetName("fx_mainhall_smoke");
	registerFXTargetName("cowbell_particles_start");
	registerFXTargetName("fx_elevator_exp");
	registerFXTargetName("gas_exp_start");
	registerFXTargetName("outside_elevator_exp");
	
	
	registerFXTargetName("davinchi_swing");				
			
	

	
	maps\createfx\sciencecenter_b_fx::main();

	
	
	level thread placeVert_effect();
	
	
	level thread initFXModelAnims();
	
	
	level notify("fx_OK");
	
	


	
	level thread maps\_fx::quick_kill_fx_on();
}






start_fxfunc( targetname, func, param )
{
	ent = getent( targetname, "targetname" );
	if ( IsDefined( ent ) )
	{
		if ( IsDefined( param ) )
		{
			ent thread [[func]]( param );
		}
		else
		{
			ent thread [[func]]();
		}
	}
}

initFXModelAnims()
{
	dav_swing = getent( "fxanim_davinchi_swing", "targetname" );
	
	dav_futureheli = getent( "fxanim_future_heli", "targetname" );
	ent_array1 = getentarray( "fxanim_streamer_2", "targetname" );
	ent_array2 = getentarray( "fxanim_streamer_3", "targetname" );
	
	ent2 = getent( "fxanim_truss_fall", "targetname" );
	ent3 = getent( "fxanim_rotor_fall", "targetname" );
	ent4 = getent( "fxanim_elevator_hatch", "targetname" );
	
	if (IsDefined(ent_array1)) { ent_array1 thread streamer_2();   println("************* FX: streamer_2 *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread streamer_3();   println("************* FX: streamer_3 *************"); }
	
	
	if (IsDefined(ent2)) { ent2 thread truss_fall();   println("************* FX: truss_fall *************"); }
	if (IsDefined(ent3)) { ent3 thread rotor_fall();   println("************* FX: rotor_fall *************"); }
	if (IsDefined(ent4)) { ent4 thread elevator_hatch();   println("************* FX: elevator_hatch *************"); }

	
	
	
	
	
	
	
	
	
	
	if (IsDefined(dav_swing)) 
	{ 
		
		
		
		
		
		
		playfxontag ( level._effect["science_fire_blob02"], dav_swing, "davinchi_fan_joint" );
		
		dav_swing thread davinchi_swing();
		
		println("************* davinchi swing ****************");
		
	}	
	
	
	
	if (IsDefined(dav_futureheli)) 
	{
		dav_futureheli thread davinchi_future_heli();
		println("************* davinchi future heli ****************"); 
	}
	
}

placeVert_effect()
{
	wait(5.0);
	println("************* FX: creating vent effect ****************");
	ent_tag = undefined;	
	ent_tag = Spawn( "script_model", (-330.095, 2870.98, 818.881) );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = (339.399,182.287,-92.68);
	
	PlayFxOnTag( level._effect["science_vent_light_vol"], ent_tag, "tag_origin" );
	
	level waittill("remove_vent_fx");
	
	ent_tag moveto( (-136.5, 5735.7, 816.205), 0.1 ); 
}

igcFXknifefight()
{
	level waittill ("start_main_hall_boss_fight");
	dimitrios = getent( "dimi_ent", "targetname" );
	
	level thread maps\_fx::play_igcEffect(dimitrios, level.player, "damage", "combat_punch1", "R_Mid_3", 3);
	level thread maps\_fx::play_igcEffect(level.player, level.player, "damage", "combat_punch1", "R_Mid_3", 3);	
	level thread maps\_fx::play_igcEffect(level.player, level.player, "punch", "combat_punch1", "L_Mid_3", 2);
	
	
	maps\_fx::play_igcEffect(level.player, dimitrios, "wall", "combat_wall_dust1", "SpineUpper_Back", 1);
	wait(0.5);
	maps\_fx::play_igcEffect(level.player, level.player, "wall", "combat_wall_dust1", "SpineUpper_Back", 1);	
}

davinchi_rope01()
{
	dav_swing = getent( "fxanim_davinchi_swing", "targetname" );
	if (IsDefined(dav_swing))
	{
		playfxontag ( level._effect["science_fire_blob01"], dav_swing, "davinchi_wire1_3_joint" );
	}
}

davinchi_rope02()
{
	dav_swing = getent( "fxanim_davinchi_swing", "targetname" );
	if (IsDefined(dav_swing))
	{
		playfxontag ( level._effect["science_fire_blob01"], dav_swing, "davinchi_wire2_3_joint" );
	}
}

davinchi_rope03()
{
	dav_swing = getent( "fxanim_davinchi_swing", "targetname" );
	if (IsDefined(dav_swing))
	{
		playfxontag ( level._effect["science_fire_blob01"], dav_swing, "davinchi_wire3_3_joint" );
	}
}

davinchi_rope04()
{
	dav_swing = getent( "fxanim_davinchi_swing", "targetname" );
	if (IsDefined(dav_swing))
	{		
		playfxontag ( level._effect["science_fire_blob01"], dav_swing, "davinchi_wire4_3_joint" );
	}
}

#using_animtree("fxanim_davinchi_swing");
davinchi_swing()
{
		level waittill("davinchi_start");
		self UseAnimTree(#animtree);
		self animscripted("d_swing", self.origin, self.angles, %fxanim_davinchi_swing);	
		
		
		level notify ("cowbell_particles_start");
}



#using_animtree("fxanim_future_heli");
davinchi_future_heli()
{
		level waittill("heli_start");
		self UseAnimTree(#animtree);
		self animscripted("d_future_heli", self.origin, self.angles, %fxanim_future_heli);
}

#using_animtree("fxanim_streamer_2");
streamer_2()
{
	level waittill("streamer_2_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_streamer_2", self[i].origin, self[i].angles, %fxanim_streamer_2);
	}
}

#using_animtree("fxanim_streamer_3");
streamer_3()
{
	level waittill("streamer_3_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_streamer_3", self[i].origin, self[i].angles, %fxanim_streamer_3);
	}
}



#using_animtree("fxanim_truss_fall");
truss_fall()
{
		level waittill("truss_fall_start");
		self UseAnimTree(#animtree);
		self animscripted("a_truss_fall", self.origin, self.angles, %fxanim_truss_fall);
}

#using_animtree("fxanim_rotor_fall");
rotor_fall()
{
		level waittill("rotor_fall_start");
		self UseAnimTree(#animtree);
		self animscripted("a_rotor_fall", self.origin, self.angles, %fxanim_rotor_fall);
}

#using_animtree("fxanim_elevator_hatch");
elevator_hatch()
{
		level waittill("elevator_hatch_start");
		self UseAnimTree(#animtree);
		self animscripted("a_elevator_hatch", self.origin, self.angles, %fxanim_elevator_hatch);
}







precacheFX()
{
	level._effect["science_elevator_shortcircuit"] 		= loadfx ("maps/miamisciencecenter/science_elevator_shortcircuit");
	level._effect["science_elevator_light"] 			= loadfx ("maps/miamisciencecenter/science_elevator_light");
	level._effect["ele_dust1"]							= loadfx ("impacts/large_dirt_1");
	level._effect["ele_dust2a"]							= loadfx ("impacts/large_dirt_2");
	level._effect["ele_dust3"]							= loadfx ("impacts/large_dirt_a");
	level._effect["ele_dust4"]							= loadfx ("impacts/large_dirt_b");
	level._effect["ele_dust5"]							= loadfx ("impacts/large_dirt_d");
	level._effect["ele_dust2"]							= loadfx ("impacts/generic_dust_accum");
	
	
	level._effect["science_lightbeam05"] 				= loadfx ("maps/miamisciencecenter/science_lightbeam05");
	level._effect["science_lightbeam06"] 				= loadfx ("maps/miamisciencecenter/science_lightbeam06");
	level._effect["science_moonlight01"] 				= loadfx ("maps/miamisciencecenter/science_moonlight01");
	level._effect["science_moonlight02"] 				= loadfx ("maps/miamisciencecenter/science_moonlight02");
	level._effect["science_interior_light01"] 			= loadfx ("maps/miamisciencecenter/science_interior_light01");
	level._effect["science_interior_light02"] 			= loadfx ("maps/miamisciencecenter/science_interior_light02");
	level._effect["science_interior_light03"] 			= loadfx ("maps/miamisciencecenter/science_interior_light03");
	level._effect["science_interior_light04"] 			= loadfx ("maps/miamisciencecenter/science_interior_light04");
	level._effect["science_exhibit_case_light"] 		= loadfx ("maps/miamisciencecenter/science_exhibit_case_light");
	
	level._effect["science_davinchi_impact"] 			= loadfx ("maps/MiamiScienceCenter/science_davinchi_impact");
	level._effect["science_davinchi_impact_runner"] 	= loadfx ("maps/MiamiScienceCenter/science_davinchi_impact_runner");
	level._effect["science_exhibit_exp01"] 				= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp01");
	level._effect["science_exhibit_exp01_runner"] 		= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp01_runner");
	level._effect["science_exhibit_exp02"] 				= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp02");
	level._effect["science_exhibit_exp02_runner"] 		= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp02_runner");
	level._effect["science_exhibit_exp03"] 				= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp03");
	level._effect["science_exhibit_exp03_runner"] 		= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp03_runner");
	level._effect["science_exhibit_exp04"] 				= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp04");
	level._effect["science_exhibit_exp04_runner"] 		= loadfx ("maps/MiamiScienceCenter/science_exhibit_exp04_runner");
	level._effect["science_exhibit_spark01"] 			= loadfx ("maps/MiamiScienceCenter/science_exhibit_spark01");
	level._effect["science_fire_blob01"]			 	= loadfx ("maps/MiamiScienceCenter/science_fire_blob01");
	level._effect["science_fire_blob02"] 				= loadfx ("maps/MiamiScienceCenter/science_fire_blob02");
	level._effect["science_floor_fire_davinchi"] 		= loadfx ("maps/MiamiScienceCenter/science_floor_fire_davinchi");
	level._effect["science_f_fire_davinchi_runner"] 	= loadfx ("maps/MiamiScienceCenter/science_f_fire_davinchi_runner");
	level._effect["science_lamp_burst"] 				= loadfx ("maps/MiamiScienceCenter/science_lamp_burst");
	level._effect["science_wire_burn_end"] 				= loadfx ("maps/MiamiScienceCenter/science_wire_burn_end");
	level._effect["science_wire_burn_end_runner01"] 	= loadfx ("maps/MiamiScienceCenter/science_wire_burn_end_runner01");
	level._effect["science_wire_burn_end_runner02"] 	= loadfx ("maps/MiamiScienceCenter/science_wire_burn_end_runner02");
	level._effect["science_wire_burn_end_runner03"] 	= loadfx ("maps/MiamiScienceCenter/science_wire_burn_end_runner03");
	level._effect["science_wire_burn_end_runner04"] 	= loadfx ("maps/MiamiScienceCenter/science_wire_burn_end_runner04");
	










	level._effect["science_dripping_rain01"] 			= loadfx("maps/miamisciencecenter/science_dripping_rain01");
		
	


	
	
	
	level._effect["fireball_01"] 						= loadfx("maps/eco_hotel/fireball_runner_1");
	level._effect["elev_expl"] 							= loadfx("explosions/large_vehicle_explosion");
	level._effect["rocket_hotness"] 					= loadfx("smoke/smoke_trail_rocket"); 
	
	

	
	level._effect["science_lightbeam01"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam01");
	level._effect["science_lightbeam02"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam02");
	level._effect["science_lightbeam03"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam03");
	level._effect["science_lightbeam04"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam04");
	level._effect["science_lightbeam05"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam05");
	level._effect["science_lightbeam06"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam06");
	level._effect["science_lightbeam07"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam07");
	level._effect["science_lightbeam08"] 			= loadfx ("maps/miamisciencecenter/science_lightbeam08");
	
	
	level._effect["science_lamp_sparks"]    		= loadfx ("maps/miamisciencecenter/science_lamp_sparks");
	level._effect["science_lamp_sparks_runner"]    	= loadfx ("maps/miamisciencecenter/science_lamp_sparks_runner");
	
	
	level._effect["science_mainhall_smoke"]   		= loadfx ("maps/miamisciencecenter/science_mainhall_smoke");
	level._effect["light_blinking_red"] 			= loadfx("misc/light_blinking_red");
	level._effect["light_blinking_green"] 			= loadfx("misc/light_blinking_green");
	level._effect["light_blinking_blue"] 			= loadfx("misc/light_blinking_blue");
	level._effect["light_green_sm"] 				= loadfx("misc/light_green_sm");
	
	
	
	
	level._effect["science_elevator_exp"]   	= loadfx ("maps/miamisciencecenter/science_elevator_exp");
	
	level._effect["rpg_trail"]   				= loadfx ("maps/miamisciencecenter/science_rpg");
	
	
	level._effect["steam_large"]   			= loadfx ("maps/miamisciencecenter/science_steam");
	level._effect["steam_small"]   			= loadfx ("maps/miamisciencecenter/science_steam_shot");	

	level._effect["elevator_sparks"]   		= loadfx ("maps/miamisciencecenter/science_elevator_sparks01");
	level._effect["science_lamp_truss_hit"]   = loadfx ("maps/miamisciencecenter/science_lamp_truss_hit");
	level._effect["outside_elevator_exp"]   = loadfx ("maps/miamisciencecenter/science_ouside_elevator_exp02");
	
	
	level._effect[ "rpg_fire" ] 			= loadfx( "maps/miamisciencecenter/science_rpg_fire" );
	
	
	
	
	level._effect[ "floor_fire" ] 			= loadfx( "maps/Whites_Estate/whites_med_fire5" );
	
	
	
	level._effect[ "combat_punch1" ] 		= loadfx( "impacts/combat_punch1" );
	level._effect[ "combat_wall_dust1" ] 	= loadfx( "impacts/combat_wall_dust1" );
	
	
	level._effect[ "light_pulsing_yellow" ] 	= loadfx( "misc/light_pulsing_yellow" );
}

























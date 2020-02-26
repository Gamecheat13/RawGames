#include maps\_utility;

main()
{
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	PARTICLE EFFECTS
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	level._effect[ "water_stand" ]						 = loadfx( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]					 = loadfx( "misc/parabolic_water_movement" );
	
	level._effect[ "knife_stab" ]						 = loadfx( "misc/parabolic_knife_stab" );
	
	//Ambient
	level._effect[ "firelp_med_pm" ]					 = loadfx( "fire/firelp_med_pm" );
	level._effect[ "fog_river_02" ]						 = loadfx( "weather/fog_bog_b" );	

	//Fire House
	level._effect["lava"]								= loadfx ("misc/lava");	
	level._effect["lava_large"]							= loadfx ("misc/lava_large");	
	level._effect["lava_a"]								= loadfx ("misc/lava_a");
	level._effect["lava_a_large"]						= loadfx ("misc/lava_a_large");	
	level._effect["lava_b"]								= loadfx ("misc/lava_b");	
	level._effect["lava_c"]								= loadfx ("misc/lava_c");
	level._effect["lava_d"]								= loadfx ("misc/lava_d");
	level._effect["lava_ash_runner"]					= loadfx ("misc/lava_ash_runner");		
	level._effect["village_smolder_alt"]				= loadfx ("smoke/village_smolder_alt");	
	level._effect["firelp_small_streak_pm_v"]			= loadfx ("fire/firelp_small_streak_pm_v");
	level._effect["firelp_small_streak_pm_h"]			= loadfx ("fire/firelp_small_streak_pm_h");

	
	level._effect[ "mortar" ]							 = loadfx( "explosions/grenadeExp_dirt_1" );


	/* -- -- -- -- -- -- -- -- -- -- -- - 
	SOUND EFFECTS
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	level.scr_sound[ "fortress_artillery_intro_01" ]	 = "parabolic_artillery_intro_01";
	level.scr_sound[ "fortress_artillery_intro_02" ]	 = "parabolic_artillery_intro_02";
	level.scr_sound[ "truck_engine_start" ]			 = "technical_start";
	level.scr_sound[ "parabolic_guardrail_scrape" ]	 = "parabolic_guardrail_scrape";
	level.scr_sound[ "parabolic_truck_fenderbender" ]	 = "parabolic_truck_fenderbender";
	level.scr_sound[ "parabolic_truck_peelout" ]		 = "parabolic_truck_peelout";
	level.scr_sound[ "spotlight_on" ]					 = "parabolic_spotlight_on";
	level.scr_sound[ "snd_breach_balcony_door" ] 		 = "detpack_explo_concrete";
	level.scr_sound[ "snd_breach_wooden_door" ] 		 = "detpack_explo_main";
	level.scr_sound[ "snd_wood_door_kick" ] 			 = "wood_door_kick";
	level.scr_sound[ "window_shutters_open" ] 		 = "wood_door_kick";
	
	level.scr_sound[ "knife_sequence" ] 				 = "parabolic_knife_sequence";
	level.scr_sound[ "muffled_voices" ] 				 = "parabolic_muffled_voices";
	// level.scr_sound[ "water_move_loop" ] 			 = "parabolic_water_move_loop";
	// level.scr_sound[ "gate_open" ] 					 = "parabolic_gate_open";			// \Doors\gate_iron_open.wav
	
	
	
	maps\createfx\blackout_fx::main();
	
}

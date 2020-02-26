#include maps\_utility;

main()
{
	/*-----------------------
	PARTICLE EFFECTS
	-------------------------*/	
	level._effect["water_stand"]					= loadfx ("misc/parabolic_water_stand");
	level._effect["water_movement"]					= loadfx ("misc/parabolic_water_movement");
	
	
	level._effect["knife_stab"]						= loadfx ("misc/parabolic_knife_stab");
	
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["ground_fire_med_nosmoke"]		= loadfx ("fire/ground_fire_med_nosmoke"); 
	level._effect["barrel_fire"]					= loadfx ("props/barrel_fire"); 
	level._effect["exp_pack_doorbreach"]			= loadfx ("explosions/exp_pack_doorbreach");  																																																																																																																																	
	level._effect["exp_pack_hallway"]	 			= loadfx ("explosions/exp_pack_hallway");
	level._effect["wallExp_concrete"]				= loadfx ("props/wallExp_concrete");
	level._effect["tank_fire_engine"]				= loadfx ("fire/tank_fire_engine");  
	level._effect["tank_fire_turret_small"]			= loadfx ("fire/tank_fire_turret_small"); 
	level._effect["lights_flr"]						= loadfx ("misc/cgoshp_lights_flr");
	level._effect["headlight_truck"]				= loadfx ("misc/spotlight_small");
	level._effect["spotlight"]						= loadfx ("misc/spotlight_medium");
	level._effect["guardrail_sparks"]				= loadfx ("misc/rescuesaw_sparks");
	level._effect["truck_reverse_fenderbender"]	 	= loadfx ("explosions/grenadeExp_dirt");
	level._effect["night_dynlight"]	 				= loadfx ("misc/night_dlight");	
	level._effect["fortress_explosion"]				= [];
	level._effect["fortress_explosion"][0] 			= loadfx ("explosions/helicopter_explosion");
	level._effect["fortress_explosion"][1] 			= loadfx ("explosions/helicopter_explosion");
	level._effect["fortress_explosion"][2]	 		= loadfx ("explosions/helicopter_explosion");
	level._effect["fortress_smoke"]					= [];
	level._effect["fortress_smoke"][0] 				= loadfx ("smoke/thin_black_smoke_M");
	level._effect["fortress_smoke"][1] 				= loadfx ("smoke/smoke_large");
	level._effect["fortress_smoke"][2]	 			= loadfx ("smoke/tunnel_smoke_bog_a");
	level._effect["door_kicked_dust01"]	 			= loadfx ("explosions/grenadeExp_wood");
	level._effect["fog_river_01"]					= loadfx ("weather/fog_bog_a");
	level._effect["fog_river_02"]					= loadfx ("weather/fog_bog_b");	
	level._effect["fog_hunted_a"]					= loadfx ("weather/fog_hunted_a");
	level._effect["bird_pm"]						= loadfx ("misc/bird_pm");
	level._effect["bird_takeoff_pm"]				= loadfx ("misc/bird_takeoff_pm");
	level._effect["leaves"]							= loadfx ("misc/leaves");
	level._effect["leaves_a"]						= loadfx ("misc/leaves_a");
	level._effect["leaves_b"]						= loadfx ("misc/leaves_b");
	level._effect["leaves_c"]						= loadfx ("misc/leaves_c");
	level._effect["leaves_runner"]					= loadfx ("misc/leaves_runner");
	level._effect["leaves_runner_1"]				= loadfx ("misc/leaves_runner_1");
	level._effect["leaves_lp"]						= loadfx ("misc/leaves_lp");
	level._effect["leaves_gl"]						= loadfx ("misc/leaves_gl");
	level._effect["leaves_gl_a"]					= loadfx ("misc/leaves_gl_a");
	level._effect["leaves_gl_b"]					= loadfx ("misc/leaves_gl_b");	
	
	//Light flashes in sky
	level._effect["lightning"]						= loadfx ("weather/horizon_flash_runner");	
	level._effect["lightning_bolt_lrg"]				= loadfx ("weather/horizon_flash_runner");
	level._effect["lightning_bolt"]					= loadfx ("weather/horizon_flash_runner");

	/*-----------------------
	SOUND EFFECTS
	-------------------------*/		
	level.scr_sound["fortress_artillery_intro_01"]	= "parabolic_artillery_intro_01";
	level.scr_sound["fortress_artillery_intro_02"]	= "parabolic_artillery_intro_02";
	level.scr_sound["truck_engine_start"]			= "technical_start";
	level.scr_sound["parabolic_guardrail_scrape"]	= "parabolic_guardrail_scrape";
	level.scr_sound["parabolic_truck_fenderbender"]	= "parabolic_truck_fenderbender";
	level.scr_sound["parabolic_truck_peelout"]		= "parabolic_truck_peelout";
	level.scr_sound["spotlight_on"]					= "parabolic_spotlight_on";
	level.scr_sound["snd_breach_balcony_door"] 		= "detpack_explo_concrete";
	level.scr_sound["snd_breach_wooden_door"] 		= "detpack_explo_main";
	level.scr_sound["snd_wood_door_kick"] 			= "wood_door_kick";
	level.scr_sound["window_shutters_open"] 		= "wood_door_kick";
	
	level.scr_sound["knife_sequence"] 				= "parabolic_knife_sequence";
	level.scr_sound["muffled_voices"] 				= "parabolic_muffled_voices";
	//level.scr_sound["water_move_loop"] 			= "parabolic_water_move_loop";
	//level.scr_sound["gate_open"] 					= "parabolic_gate_open";			// \Doors\gate_iron_open.wav
	
	
	
	maps\createfx\zipline_fx::main();
	
}

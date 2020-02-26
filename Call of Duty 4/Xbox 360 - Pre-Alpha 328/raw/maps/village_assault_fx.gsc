#include maps\_utility;

main()
{
	level._effect["fog_villassault"]				= loadfx ("weather/fog_villassault");
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["fire_med_nosmoke"]				= loadfx("fire/ground_fire_med_nosmoke"); 
	level._effect["fire_sm_trail"]					= loadfx ("props/barrel_fire"); 
	level._effect["headlights"]						= loadfx ("misc/lighthaze");
	level._effect["lighthaze_villassault"]			= loadfx ("misc/lighthaze_villassault");
	level._effect["firelp_small_streak_pm_v"]		= loadfx ("fire/firelp_small_streak_pm_v");
	level._effect["firelp_small_streak_pm_h"]		= loadfx ("fire/firelp_small_streak_pm_h");
	level._effect["firelp_small_streak_pm1_h"]		= loadfx ("fire/firelp_small_streak_pm1_h");
	level._effect["firelp_med_streak_pm_h"]			= loadfx ("fire/firelp_med_streak_pm_h");
	level._effect["firelp_large_pm"]				= loadfx ("fire/firelp_large_pm");
	level._effect["embers_burst_runner"]			= loadfx ("fire/embers_burst_runner");
	level._effect["emb_burst_a"]					= loadfx ("fire/emb_burst_a");
	level._effect["emb_burst_b"]					= loadfx ("fire/emb_burst_b");
	level._effect["emb_burst_c"]					= loadfx ("fire/emb_burst_c");	
	level._effect["fire_fallingdebris"]				= loadfx ("fire/fire_fallingdebris");
	level._effect["fire_fallingdebris_a"]			= loadfx ("fire/fire_fallingdebris_a");
	level._effect["fire_debris_child"]				= loadfx ("fire/fire_debris_child");
	level._effect["fire_debris_child_a"]			= loadfx ("fire/fire_debris_child_a");
	level._effect["leaves_va"]						= loadfx ("misc/leaves_va");
	level._effect["moth_runner"]					= loadfx ("misc/moth_runner");
	level._effect["moth_a"]							= loadfx ("misc/moth_a");
	level._effect["moth"]							= loadfx ("misc/moth");
	level._effect["insect_trail_a"]					= loadfx ("misc/insect_trail_a");
	level._effect["insect_trail_b"]					= loadfx ("misc/insect_trail_b");
	level._effect["insect_trail_runner"]			= loadfx ("misc/insect_trail_runner");
	level._effect["village_ash"]					= loadfx ("smoke/village_ash");
	
	level.flare_fx["mi28"] 							= loadfx( "misc/flares_cobra" );
	
	// Rain
	level._effect["rain_heavy_cloudtype"]	= loadfx ("weather/rain_heavy_cloudtype");
	level._effect["rain_10"]	= loadfx ("weather/rain_heavy_mist");
	level._effect["rain_9"]		= loadfx ("weather/rain_9");
	level._effect["rain_8"]		= loadfx ("weather/rain_9");
	level._effect["rain_7"]		= loadfx ("weather/rain_9");
	level._effect["rain_6"]		= loadfx ("weather/rain_9");
	level._effect["rain_5"]		= loadfx ("weather/rain_9");
	level._effect["rain_4"]		= loadfx ("weather/rain_9");
	level._effect["rain_3"]		= loadfx ("weather/rain_9");
	level._effect["rain_2"]		= loadfx ("weather/rain_9");
	level._effect["rain_1"]		= loadfx ("weather/rain_9");	
	level._effect["rain_0"]		= loadfx ("weather/rain_0");
	
	thread maps\_weather::rainInit( "light" ); // "none" "light" or "hard"
	//thread maps\_weather::rainInit( "hard" ); // "none" "light" or "hard"
	thread maps\_weather::playerWeather(); // make the actual rain effect generate around the player
	
	maps\createfx\village_assault_fx::main();
}
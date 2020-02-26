#include maps\_utility;

main()
{
	level thread precacheFX();
	maps\createfx\ambush_fx::main();

}

precacheFX()
{
	/*
	//footstep fx
	animscripts\utility::setFootstepEffect ("snow",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("gravel",		loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("impacts/footstep_snow"));
	*/
	
	level._effect["ambush_vl"]				= loadfx ("misc/ambush_vl");
	level._effect["ambush_vl_far"]			= loadfx ("misc/ambush_vl_far");
	level._effect["ambush_vl_1"]			= loadfx ("misc/ambush_vl_1");
	level._effect["ambush_vl_1_ls"]			= loadfx ("misc/ambush_vl_1_ls");
	level._effect["ambush_vl_2"]			= loadfx ("misc/ambush_vl_2");
	level._effect["ambush_vl_2_ls"]			= loadfx ("misc/ambush_vl_2_ls");
	level._effect["amb_dust"]				= loadfx ("smoke/amb_dust");
	level._effect["amb_ash"]				= loadfx ("smoke/amb_ash");
	level._effect["amb_smoke_add"]			= loadfx ("smoke/amb_smoke_add");
	level._effect["amb_smoke_add_1"]		= loadfx ("smoke/amb_smoke_add_1");
	level._effect["amb_smoke_add_1_far"]	= loadfx ("smoke/amb_smoke_add_1_far");
	level._effect["amb_smoke_blend"]		= loadfx ("smoke/amb_smoke_blend");
	level._effect["firelp_small_pm"]		= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]		= loadfx ("fire/firelp_small_pm_a");
	level._effect["firelp_small_streak_pm_h"]		= loadfx ("fire/firelp_small_streak_pm_h");
	level._effect["firelp_small_streak_pm_v"]		= loadfx ("fire/firelp_small_streak_pm_v");
	level._effect["smoke_large"]			= loadfx ("smoke/smoke_large");

	// gameplay
	level._effect["mg_nest_expl"]			= loadfx ("explosions/small_vehicle_explosion");

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

	thread maps\_weather::rainInit( "hard" ); // "none" "light" or "hard"
	thread maps\_weather::playerWeather(); // make the actual rain effect generate around the player

}

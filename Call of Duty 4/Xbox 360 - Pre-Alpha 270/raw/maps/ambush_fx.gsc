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

	
	

	
		

}

#include maps\_utility;


main()

{
	level._effect["fog_icbm"]					= loadfx ("weather/fog_icbm");
	level._effect["fog_icbm_a"]					= loadfx ("weather/fog_icbm_a");
	level._effect["fog_icbm_b"]					= loadfx ("weather/fog_icbm_b");
	level._effect["fog_icbm_c"]					= loadfx ("weather/fog_icbm_c");	
	level._effect["leaves_runner_lghtr"]		= loadfx ("misc/leaves_runner_lghtr");
	level._effect["leaves_runner_lghtr_1"]		= loadfx ("misc/leaves_runner_lghtr_1");
	level._effect["insect_trail_runner_icbm"]	= loadfx ("misc/insect_trail_runner_icbm");
	level._effect["cloud_bank"]					= loadfx ("weather/cloud_bank");
	level._effect["cloud_bank_a"]				= loadfx ("weather/cloud_bank_a");
	level._effect["cloud_bank_far"]				= loadfx ("weather/cloud_bank_far");
	level._effect["moth_runner"]				= loadfx ("misc/moth_runner");
	level._effect["hawks"]						= loadfx ("misc/hawks");
	level._effect["mist_icbm"]					= loadfx ("weather/mist_icbm");	
	level._effect["icbm_vl_int"]				= loadfx ("misc/icbm_vl_int");
	level._effect["icbm_vl_od"]					= loadfx ("misc/icbm_vl_od");
	level._effect["icbm_vl_od_a"]				= loadfx ("misc/icbm_vl_od_a");
	level._effect["icbm_vl_int_wide"]			= loadfx ("misc/icbm_vl_int_wide");
	level._effect["icbm_vl"]					= loadfx ("misc/icbm_vl");
	level._effect["icbm_vl_a"]					= loadfx ("misc/icbm_vl_a");
	level._effect["icbm_vl_b"]					= loadfx ("misc/icbm_vl_b");	
	level._effect["icbm_vl_int_ls"]				= loadfx ("misc/icbm_vl_int_ls");
	level._effect["icbm_dust_int"]				= loadfx ("smoke/icbm_dust_int");	
	level._effect["icbm_smoke_add"]				= loadfx ("smoke/icbm_smoke_add");
	level._effect["icbm_smoke_add_clr"]			= loadfx ("smoke/icbm_smoke_add_clr");
	level._effect["icbm_smoke_add_clr_a"]		= loadfx ("smoke/icbm_smoke_add_clr_a");	
	level._effect["birds_icbm_runner"]			= loadfx ("misc/birds_icbm_runner");
	level._effect["grenade_smoke"]				= loadfx ("props/american_smoke_grenade");	
	level._effect["vehicle_explosion"]			= loadfx ("explosions/large_vehicle_explosion");
	level._effect["snow_light"]					= loadfx ("weather/snow_light");
	
	maps\createfx\icbm_fx::main();
	
	level thread playerEffect();

}

playerEffect()
{
	level endon( "stop_snow" );
	player = getent("player","classname");
	for (;;)
	{
		playfx ( level._effect["snow_light"], player.origin + (0,0,300), player.origin + (0,0,350) );
		wait (0.075);
	}
}
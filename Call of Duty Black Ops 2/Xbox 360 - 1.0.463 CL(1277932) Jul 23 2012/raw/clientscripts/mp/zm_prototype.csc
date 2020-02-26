// Test clientside script for mp_zombie_temp

#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	//Common zombie stuff
	clientscripts\mp\zm_prototype_fx::main();	// FX have to be declared before the FX system is initied in start_zombie_stuff.  DSL 11/28/11

	start_zombie_stuff();

	//Level specific zombie stuff
	thread clientscripts\mp\zm_prototype_amb::main();
	
	//This needs to be called after all systems have been registered.
	waitforclient(0);
	println("*** Client : zm_prototype running...");
}

start_zombie_stuff()
{
	level._uses_crossbow = true;
	
	// define the on and off vision set priorities
	//level._visionset_map_nopower = "zombie_theater";
	//level._visionset_priority_map_nopower = 1;
	
	//level._visionset_map_poweron = "zombie_pentagon";
	//level._visionset_priority_map_poweron = 2;
	
	//level._visionset_zombie_transition_time = 0.3; // how much time it take for the vision set to apply
	
	// ww: thundergun init happens in _zombiemode.csc so the weapons need to be setup before _zombiemode::main is
	include_weapons();

//T6todo	init_clientflag_variables();
	
	// _load!
	clientscripts\mp\zombies\_zm::init();

//T6todo	register_clientflag_callbacks();
	
//T6todo	clientscripts\zombie_integration_test_fx::main();
//T6todo	thread clientscripts\zombie_integration_test_amb::main();
	
	clientscripts\mp\zombies\_zm_weap_thundergun::init();
	clientscripts\mp\zombies\_zm_weap_riotshield::init();

//T6todo	clientscripts\mp\zombies\_zm_deathcard::init();
	
	// This needs to be called after all systems have been registered.
//T6todo	thread waitforclient(0);
	
	// on player connect run this function
//T6todo	OnPlayerConnect_Callback( ::integration_on_player_connect );
	
	// changes the vision set when the power is hit
//T6todo	level thread integration_power_vision_set_swap();

//T6todo	level thread monkey_start_monitor();
//T6todo	level thread monkey_stop_monitor();
}

init_clientflag_variables()
{
}

register_clientflag_callbacks()
{
}

include_weapons()
{
	include_weapon( "knife_zm", false );
	include_weapon( "frag_grenade_zm", false );
	include_weapon( "claymore_zm", false );


	//	Weapons - Pistols
	include_weapon( "m1911_zm", false );
	include_weapon( "m1911_upgraded_zm", false );
	include_weapon( "python_zm" );
	include_weapon( "python_upgraded_zm", false );
  	include_weapon( "cz75_zm" );
  	include_weapon( "cz75_upgraded_zm", false );

	//	Weapons - Semi-Auto Rifles
	include_weapon( "m14_zm", false );
	include_weapon( "m14_upgraded_zm", false );

	//	Weapons - Burst Rifles
	include_weapon( "m16_zm", false );						
	include_weapon( "m16_gl_upgraded_zm", false );
	include_weapon( "g11_lps_zm" );
	include_weapon( "g11_lps_upgraded_zm", false );
	include_weapon( "famas_zm" );
	include_weapon( "famas_upgraded_zm", false );

	//	Weapons - SMGs
	include_weapon( "ak74u_zm", false );
	include_weapon( "ak74u_upgraded_zm", false );
	include_weapon( "mp5k_zm", false );
	include_weapon( "mp5k_upgraded_zm", false );
	include_weapon( "mp40_zm", false );						
	include_weapon( "mp40_upgraded_zm", false );			
	include_weapon( "mpl_zm", false );
	include_weapon( "mpl_upgraded_zm", false );
	include_weapon( "pm63_zm", false );
	include_weapon( "pm63_upgraded_zm", false );
	include_weapon( "spectre_zm" );
	include_weapon( "spectre_upgraded_zm", false );

	//	Weapons - Dual Wield
  	include_weapon( "cz75dw_zm" );
  	include_weapon( "cz75dw_upgraded_zm", false );

	//	Weapons - Shotguns
	include_weapon( "ithaca_zm", false );
	include_weapon( "ithaca_upgraded_zm", false );
	include_weapon( "rottweil72_zm", false );
	include_weapon( "rottweil72_upgraded_zm", false );
	include_weapon( "spas_zm" );
	include_weapon( "spas_upgraded_zm", false );
	include_weapon( "hs10_zm" );
	include_weapon( "hs10_upgraded_zm", false );

	//	Weapons - Assault Rifles
	include_weapon( "aug_acog_zm" );
	include_weapon( "aug_acog_mk_upgraded_zm", false );
	include_weapon( "galil_zm" );
	include_weapon( "galil_upgraded_zm", false );
	include_weapon( "commando_zm" );
	include_weapon( "commando_upgraded_zm", false );
	include_weapon( "fnfal_zm" );
	include_weapon( "fnfal_upgraded_zm", false );

	//	Weapons - Sniper Rifles
	include_weapon( "dragunov_zm" );
	include_weapon( "dragunov_upgraded_zm", false );
	include_weapon( "l96a1_zm" );
	include_weapon( "l96a1_upgraded_zm", false );

	//	Weapons - Machineguns
	include_weapon( "rpk_zm" );
	include_weapon( "rpk_upgraded_zm", false );
	include_weapon( "hk21_zm" );
	include_weapon( "hk21_upgraded_zm", false );

	//	Weapons - Misc
	include_weapon( "m72_law_zm" );
	include_weapon( "m72_law_upgraded_zm", false );
	include_weapon( "china_lake_zm" );
	include_weapon( "china_lake_upgraded_zm", false );

	////////////////////
	//Special grenades//
	////////////////////
	include_weapon( "zombie_cymbal_monkey" );

	///////////////////
	//Special weapons//
	///////////////////
	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", false );
	include_weapon( "crossbow_explosive_zm" );
	include_weapon( "crossbow_explosive_upgraded_zm", false );
	include_weapon( "thundergun_zm" );
	include_weapon( "thundergun_upgraded_zm", false );

	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
}
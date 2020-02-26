// Test clientside script for mak
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;

main()
{
	//Common zombie stuff
	clientscripts\mp\_teamset_junglemarines::level_init();		//team nationality
	
	clientscripts\mp\zm_factory_fx::main();	// FX have to be declared before the FX system is initied in start_zombie_stuff.  DSL 11/28/11
	
	start_zombie_stuff();

	//Level specific zombie stuff

	thread clientscripts\mp\zm_factory_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	level thread factory_ZPO_listener();

	println("*** Client : zm_factory running...");

}

start_zombie_stuff()
{
	level._uses_crossbow = true;
	
	include_weapons();

	
	// _load!
	clientscripts\mp\zombies\_zm::init();

	level thread clientscripts\mp\_explosive_bolt::main();

	clientscripts\mp\zombies\_zm_weap_tesla::init();
}



factory_ZPO_listener()
{
	while(1)
	{
		level waittill("ZPO");	// Zombie Power On!
		
		level notify( "revive_on" );
		level notify( "fast_reload_on" );
		level notify( "doubletap_on" );
		level notify( "jugger_on" );
		level notify( "pl1" );
	}
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
	include_weapon( "tesla_gun_zm" );
	include_weapon( "tesla_gun_upgraded_zm", false );

	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	include_weapon( "knife_ballistic_bowie_zm", false );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", false );
}

/*
triggered_lights_think(light_struct)
{		
	level waittill( "pl1" );	// power lights on

	// Turn the lights on
	if ( IsDefined( self.script_float ) )
	{
		clientscripts\_lights::set_light_intensity( light_struct, self.script_float );
	}
	else
	{
		clientscripts\_lights::set_light_intensity( light_struct, 1.5 );
	}	
}
*/


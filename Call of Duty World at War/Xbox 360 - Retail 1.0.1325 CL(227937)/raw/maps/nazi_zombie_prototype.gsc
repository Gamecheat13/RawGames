#include common_scripts\utility; 
#include maps\_utility;


main()
{
	maps\_destructible_opel_blitz::init();

	include_weapons();
	include_powerups();
	
	maps\nazi_zombie_prototype_fx::main();
	maps\_zombiemode::main();
	
	init_sounds();

	// If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
	// I recommend putting it in it's own function...
	// If not a MOD, you may need to provide new localized strings to reflect the proper cost.
}

init_sounds()
{
	maps\_zombiemode_utility::add_sound( "break_stone", "break_stone" );
}

// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// Pistols
	//include_weapon( "colt" );
	//include_weapon( "colt_dirty_harry" );
	//include_weapon( "walther" );
	include_weapon( "sw_357" );
	
	// Semi Auto
	include_weapon( "m1carbine" );
	include_weapon( "m1garand" );
	include_weapon( "gewehr43" );

	// Full Auto
	include_weapon( "stg44" );
	include_weapon( "thompson" );
	include_weapon( "mp40" );
	
	// Bolt Action

	include_weapon( "kar98k" );
	include_weapon( "springfield" );

	// Scoped
	include_weapon( "ptrs41_zombie" );
	include_weapon( "kar98k_scoped_zombie" );
		
	// Grenade
	include_weapon( "molotov" );
	// JESSE: lets go all german grenades for consistency and to reduce annoyance factor
	//	include_weapon( "fraggrenade" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher
	include_weapon( "m1garand_gl" );
	include_weapon( "m7_launcher" );
	
	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	
	// Shotgun
	include_weapon( "doublebarrel" );
	include_weapon( "doublebarrel_sawed_grip" );
	include_weapon( "shotgun" );
	
	// Bipod
	include_weapon( "fg42_bipod" );
	include_weapon( "mg42_bipod" );
	include_weapon( "30cal_bipod" );

	// Heavy MG
	include_weapon( "bar" );

	// Rocket Launcher
	include_weapon( "panzerschrek" );

	// Special
	include_weapon( "ray_gun" );
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
}

include_weapon( weapon_name )
{
	maps\_zombiemode_weapons::include_zombie_weapon( weapon_name );
}

include_powerup( powerup_name )
{
	maps\_zombiemode_powerups::include_zombie_powerup( powerup_name );
}
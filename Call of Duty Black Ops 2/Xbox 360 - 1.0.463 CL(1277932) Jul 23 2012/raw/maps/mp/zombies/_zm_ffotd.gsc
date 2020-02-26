#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 


main_start()
{
	//This will turn off the new path method if added
	//level.calc_closest_player_using_paths = false;
	
	
	//Disable friends list and dev list from spaceman name if we want
	//setsaveddvar( "r_zombieNameAllowFriendsList", "1" );
	//setsaveddvar( "r_zombieNameAllowDevList", "1" );
	
	//We can disable additional primary machines here on a per map basis
	//just set level.zombie_additionalprimaryweapon_machine_origin to undefined and it will ignore it
	
	//Turn off 3 weapon perk machines for all maps except moon
	if( GetDvar( "mapname" ) != "zombie_moon" )
	{
		level.zombie_additionalprimaryweapon_machine_origin = undefined;
	}
}


main_end()
{
}

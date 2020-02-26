/*

Objectives:	1. Secure the village. (7 buildings remaining)
			2. Locate Khaled Al-Asad.

Progression:
		
		- The SAS approach from the bottom of the hill, equipped with suppressed weapons.
		- Player may engage the enemy freely
		- The town behaves as a normal enemy occupied town
		- Loyalist soldiers are seen getting executed in the moonlight
		- There are off-screen sounds of Loyalist soldiers being executed by machine gun fire in the distance
		- Loyalist soldier corpses lining walls covered in blood sprays
		
		======
		- In the last building searched by the player (buildings in any order) we find Al-Asad badly mutilated, dead
		- nasty torture is apparent from the blood everywhere in the room
		
		- Price: "You. Search the body."
		- recovers Al-Asad's cell phone from Al-Asad's corpse
		- Zakhaev's name comes up on the cell phone
		=======
		OR
		=======
		- In the last building searched by the player (buildings in any order) we find Al-Asad badly mutilated, alive
		- Price gets Al-Asad to talk before Al-Asad dies of his wounds, revealing Zakhaev's name
		
		Dialogue to introduce Price going into flashback.

*/

/*

-doesnt seem like a silenced weapon level, there are so many enemies immediately

-no one is coming into the building where I am (friendlies or enemies)

-bush to the right of the first building on the right doesnt block enemy sight (seems true of many of the bushes)

-I've cleared buildings in a counter clock wise direction (1 building left) and I dont feel like I've seen any friendlies
since the beginning other than one guy

-seems like a good level for weapon caches and sniper rifles

needs some gameplay variety besides just shooting lots and lots of enemies
- maybe a harassing enemy chopper with a spot light that you can shoot down if you find a stinger

*/

//roaming_bmp

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\village_assault_code;
main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	
	precacheLevelStuff();
	setLevelDVars();
	
	add_start( "town", 	::start_town );
	default_start( ::start_start );
	
	thread scriptCalls();
	
	thread add_objective_building( "1" );
	thread add_objective_building( "2" );
	thread add_objective_building( "3" );
	thread add_objective_building( "4" );
	thread add_objective_building( "5" );
}

start_start()
{
	spawn_starting_friendlies( "friendly_start" );
	thread gameplay_start();
}

start_town()
{
	spawn_starting_friendlies( "friendly_town" );
	
	start = getent( "player_start_town", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
}

gameplay_start()
{	
	thread battlechatter_trigger_on();
	friendly_stance( "crouch" );
	wait 2.5;
	friendly_stance( "stand", "crouch", "prone" );
	getent( "first_trigger_after_gas_station", "script_noteworthy" ) notify( "trigger" );
}

gameplay_town()
{
	
}

battlechatter_trigger_on()
{
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	getent( "battlechatter_on_trigger", "targetname" ) waittill( "trigger" );
	
	// Autosave the game at this point
	thread maps\_utility::autosave_by_name( "entered_town" );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	wait 25;
	if ( !played_called_air_support() )
		flag_set( "air_support_hint" );
}
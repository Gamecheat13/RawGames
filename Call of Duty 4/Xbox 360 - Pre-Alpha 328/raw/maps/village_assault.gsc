/*

Whenever you clear a building, it would be sweet if some “magic” guys came from behind and set up one or two turrets in
some windows and laid down some mad cover fire from that building… and maybe some kind of functionality to make sure
enemies don’t enter that area again once the building is cleared if it isn’t there already. 

I think it would feel a lot more rewarding to clear a building if it became this big asset in helping you win the battle.
Maybe if it’s possible to limit their range they wouldn’t take everybody in the map out. (maybe only shoot enemies that
enter a volume?)

But for instance, if that first building got cleared and they set up, they could kill any enemies passing by the burning
building.  So by the time you get to the last building all the remaining terrorists would feel like they’re pretty much
fucked, and they’re running to that building for a last stand

-doesnt seem like a silenced weapon level, there are so many enemies immediately

*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\village_assault_code;
main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	
	if ( getdvar( "village_assault_disable_gameplay") == "" )
		setdvar( "village_assault_disable_gameplay", "0" );
	
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
	thread add_objective_building( "6" );
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

battlechatter_trigger_on()
{
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	getent( "battlechatter_on_trigger", "targetname" ) waittill( "trigger" );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	// Autosave the game at this point
	thread doAutoSave( "entered_town" );
	
	wait 60;
	thread air_support_hint_print_activate();
}
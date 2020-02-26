#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "riotshield_zm" ) )
	{
		return;
	}

	//level thread clientscripts\mp\_riotshield::init();

	level thread player_init();
}

player_init()
{
	waitforclient( 0 );

	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
	}
}
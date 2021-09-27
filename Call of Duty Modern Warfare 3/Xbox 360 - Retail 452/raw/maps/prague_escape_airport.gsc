#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;

init_airport()
{
}

start_airport()
{
}

airport_flashback()
{
	thread set_fog();
	flashback_teleport( "airport_player_spot", "prague_escape_airport", 3, 3 );
	wait( 10 );
}

set_fog()
{
	wait( 3 );
	SetExpFog( 619.914, 2540.24, 0.356863, 0.372549, 0.313726, 0.75818, 0 );
}
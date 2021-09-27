#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;

init_airlift()
{
	flag_init( "nuke_explosion_done" );
}

start_airlift()
{
}

nuke_flashback()
{
	flashback_teleport( "airlift_player_spot", "prague_escape_airlift" );
	wait( 5 );

	nuke_explosion();
}

nuke_explosion()
{
	thread nuke_sunlight();
	level.player set_vision_set_player( "prague_escape_nuke_flash", 3 );
	wait( 0.5 );
	exploder( 666 );
	SetExpFog( 0, 17000, 0.678352, 0.498765, 0.372533, 1, 0.5 );

	thread nuke_shockwave_blur();
	thread nuke_earthquake();

	level.player delaythread( 1, ::set_vision_set_player, "aftermath", 4 );
//	level.player delaythread( 8, ::set_vision_set_player, "prague_escape_nuke_end", 8 );

	wait( 10 );
	flag_set( "nuke_explosion_done" );
}

nuke_sunlight()
{
	level.defaultSun = GetMapSunLight();
	level.nukeSun = ( 3.11, 2.05, 1.67 );
	sun_light_fade( level.defaultSun, level.nukeSun, 2 );
	wait( 1 );
	thread sun_light_fade( level.nukeSun, level.defaultSun, 2 );
}

nuke_shockwave_blur()
{
	Earthquake( 0.3, .5, level.player.origin, 80000 );
	SetBlur( 3, .1 );
	wait( 1 );
	SetBlur( 0, .5 );
}

nuke_earthquake()
{
	wait( 1 );
	time = GetTime() + ( 5 * 1000 );
	while ( GetTime() < time )
	{
		Earthquake( .08, .05, level.player.origin, 80000 );
		wait( .05 );
	}

	Earthquake( .5, 1, level.player.origin, 80000 );

	while ( !flag( "nuke_explosion_done" ) )
	{
		Earthquake( .25, .05, level.player.origin, 80000 );
		wait( .05 );
	}
}
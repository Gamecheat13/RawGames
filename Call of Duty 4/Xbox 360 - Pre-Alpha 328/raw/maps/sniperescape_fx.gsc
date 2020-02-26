#include maps\_utility;

main()
{
	level._effect[ "gilli_leaves" ]				= loadfx ( "misc/gilli_leaves" );
	level._effect[ "bird_pm" ]					= loadfx ( "misc/bird_pm" );
	level._effect[ "bird_takeoff_pm" ]			= loadfx ( "misc/bird_takeoff_pm" );


	level._effect[ "heli_explosion" ]			= loadfx ( "explosions/helicopter_explosion" );
	level._effect[ "aerial_explosion_large" ]	= loadfx ( "explosions/aerial_explosion_large" );
	level._effect[ "detpack_explosion" ]		= loadfx ( "explosions/exp_pack_hallway" );

	//main building fx
	level._effect[ "aerial_explosion" ]			= loadfx ( "explosions/aerial_explosion" );
	level._effect[ "window_explosion" ]			= loadfx ( "explosions/window_explosion" );
	level._effect[ "window_fire_large" ]		= loadfx ( "fire/window_fire_large" );
	level._effect[ "dust_ceiling_ash_large" ]	= loadfx ( "dust/dust_ceiling_ash_large" );
	level._effect[ "light_shaft_dust_med" ]		= loadfx ( "dust/light_shaft_dust_med" );	
	level._effect[ "light_shaft_dust_large" ]	= loadfx ( "dust/light_shaft_dust_large" );	
	level._effect[ "room_dust_200" ]			= loadfx ( "dust/room_dust_200" );	
}


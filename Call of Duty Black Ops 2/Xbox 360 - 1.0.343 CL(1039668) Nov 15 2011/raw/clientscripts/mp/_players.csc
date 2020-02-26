#include clientscripts\mp\_utility;
#include clientscripts\_filter;

on_connect( localclientnum )
{
	if( !SessionModeIsZombiesGame() )
	{
		thread clientscripts\mp\_acousticsensor::init( localclientnum );
	}
	WaitForClient( localclientnum );

	ui3dsetwindow( 0, 0, 0, 1, 1 );	
	player = GetLocalPlayer(localClientNum);
	assert( IsDefined( player ) );

	if( !SessionModeIsZombiesGame() )
	{
		thread clientscripts\mp\_fx::fx_init( localclientnum );
		thread clientscripts\mp\_fxanim::fxanim_init( localclientnum );

		thread clientscripts\mp\_ambient::ceiling_fans_init( localclientnum );
		thread clientscripts\mp\_ambient::clocks_init( localclientnum );
		thread clientscripts\mp\_ambient::spin_anemometers( localclientnum );
		thread clientscripts\mp\_rotating_object::init( localclientnum );

		thread clientscripts\mp\_missile_swarm::swarm_init( localClientNum );
		
		init_filter_infrared( player );
		init_filter_scope( player );
		init_filter_tvguided( player );
		
		if ( isDefined( level.infraredVisionset ) )
			player SetInfraredVisionset( level.infraredVisionset );
	}

	if( IsDefined( level.onPlayerConnect ) )
	{
		level thread [[level.onPlayerConnect]]( localclientnum );
	}
}

dtp_effects()
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		self waittill( "dtp_land", localClientNum );
		localPlayer = GetLocalPlayer( localClientNum );
		if ( !IsSplitscreen() && isDefined( localPlayer ) && localPlayer == self )
		{
			if ( IsDefined( level.isWinter ) && level.isWinter )
				AnimateUI( localClientNum, "fullscreen_snow", "dirt", "in", 0 );
			else
				AnimateUI( localClientNum, "fullscreen_dirt", "dirt", "in", 0 );
		}
	}
}
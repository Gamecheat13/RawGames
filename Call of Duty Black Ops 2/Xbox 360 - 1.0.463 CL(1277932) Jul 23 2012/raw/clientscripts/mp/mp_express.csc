#include clientscripts\mp\_utility;

#define RUMBLE_TYPE		"grenade_rumble"
#define RUMBLE_SCALE	0.2
#define RUMBLE_DURATION 0.25
#define RUMBLE_RADIUS	512
#define RUMBLE_TIME		0.05

main()
{
	// team nationality
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_express_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_express_amb::main();

	RegisterClientField( "vehicle", "train_moving", 1, "int", ::train_move, false );
	RegisterClientField( "scriptmover", "train_moving", 1, "int", ::train_move, false );

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/#
		println("*** Client : mp_express running...");
	#/
}

train_move( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName )
{
	if ( newVal )
	{
		self notify( "train_stop" );
		self thread train_move_think( localClientNum );
	}
	else
	{
		self notify( "train_stop" );
	}
}

train_move_think( localClientNum )
{
	self endon( "train_stop" );
	self endon( "death" );
	self endon( "entityshutdown" );

	for ( ;; )
	{
		player = GetLocalPlayer( localClientNum );

		if ( !IsDefined( player ) )
		{
			serverwait( localClientNum, 0.05 );
			continue;
		}
		else if ( player GetInKillcam( localClientNum ) )
		{
			serverwait( localClientNum, 0.05 );
			continue;
		}

		if ( DistanceSquared( self.origin, player.origin ) < RUMBLE_RADIUS * RUMBLE_RADIUS )
		{
			PlayRumbleOnPosition( localClientNum, RUMBLE_TYPE, self.origin ); 
			player Earthquake( RUMBLE_SCALE, RUMBLE_DURATION, self.origin, RUMBLE_RADIUS );

			wait( RUMBLE_TIME ); 
		}
		else
		{
			serverwait( localClientNum, 0.05 );
		}
	}
}

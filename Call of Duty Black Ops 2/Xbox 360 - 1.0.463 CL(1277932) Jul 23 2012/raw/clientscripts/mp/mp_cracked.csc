// Test clientside script for mp_cracked

#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

main()
{
	// If the team nationalites change in this level's gsc file,
	// you must update the team nationality here!
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_cracked_fx::main();

//	thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_cracked_amb::main();

	// This needs to be called after all systems have been registered.
	thread waitforclient(0);

/#	println("*** Client : mp_cracked running..."); #/

	thread ambient_river_boats_init(0);
	//ambient_helicopter_flyby_init();
	//ambient_helicopter_patrol_init();
}

ambient_helicopter_spawn( origin )
{
	helicopter = Spawn( 0, origin, "script_model" );
	helicopter SetModel( "t5_veh_helo_huey_lowres" );

	// TODO: need a wait here to play fx oriented correctly?
	wait( 1 );

	playfxontag( 0, level._effect["fx_rotor_main"], helicopter, "main_rotor_jnt" );
	playfxontag( 0, level._effect["fx_rotor_tail"], helicopter, "tail_rotor_jnt" );

	return helicopter;
}

ambient_helicopter_patrol_init()
{
	for ( group_index = 0; ; group_index++ )
	{
		helicopter_group = getstructarray( "ambient_helicopter_patrol_" + group_index, "targetname" );

		if ( IsDefined( helicopter_group ) && IsDefined( helicopter_group[0] ) )
		{
			helicopter = ambient_helicopter_spawn( helicopter_group[0].origin );

			helicopter.nodes = helicopter_group;
			helicopter.current_node = helicopter_group[0];
			helicopter thread ambient_helicopter_patrol_think();
		}
		else
		{
			break;			
		}
	}
}

ambient_helicopter_patrol_think()
{
	for ( ;; )
	{
		next_node = self.current_node;

		while( self.current_node == next_node )
		{
			next_node = Random( self.nodes );
		}

		direction = next_node.origin - self.current_node.origin;
		self RotateTo( vectortoangles( direction ), 3 );
		self waittill( "rotatedone" );

		self MoveTo( next_node.origin, 3 );
		self waittill( "movedone" );
		self.current_node = next_node;
	}
}

ambient_helicopter_flyby_init()
{
	for ( group_index = 0; ; group_index++ )
	{
		helicopter_group = getstructarray( "ambient_helicopter_flyby_" + group_index, "script_noteworthy" );

		if ( IsDefined( helicopter_group ) && IsDefined( helicopter_group[0] ) )
		{
			helicopter = ambient_helicopter_spawn( helicopter_group[0].origin );

			helicopter.current_node = helicopter_group[0];
			helicopter thread ambient_helicopter_flyby_think();
		}
		else
		{
			break;			
		}

		wait( RandomIntRange( 4, 7 ) );
	}
}

ambient_helicopter_flyby_think()
{
	for ( ;; )
	{
		next_node = getstruct( self.current_node.target, "targetname" );

		if ( !IsDefined( next_node ) )
		{
			self delete();
			return;
		}

		direction = next_node.origin - self.current_node.origin;
		angles = vectortoangles( direction );
		angles = angles + ( 15, 0, 0 );
		self RotateTo( angles, 3 );
		self waittill( "rotatedone" );

		self MoveTo( next_node.origin, 100 );
		self waittill( "movedone" );
		self.current_node = next_node;
	}
}


ambient_river_boats_init( clientNum )
{
	WaitForClient( clientNum );
	level.boatSwayTime = GetDvarFloatDefault( "cscr_boatswaytime", 4.0 );
	level.boatSwaySlowDownTime = GetDvarFloatDefault( "cscr_boatswayslowdowntime", 2.0 );	
	level.boatRoll = GetDvarFloatDefault( "cscr_boatroll", 4.0 ); // degrees
	
	nearBoat = GetEnt( clientNum, "cracked_near_boat", "targetname" );
	assert( IsDefined( nearBoat ), "Unable to find entity with targetname: 'cracked_near_boat'" );
	nearBoat thread floatMyBoat( clientNum, false, false );	
	
	//nearCanoe = GetEnt( clientNum, "cracked_near_canoe", "targetname" );
	//assert( IsDefined( nearCanoe ), "Unable to find entity with targetname: 'cracked_near_canoe'" );
	//nearCanoe thread floatMyBoat( clientNum, true, false );
	
	farBoats = GetEntArray( clientNum, "cracked_far_boats", "targetname" );
	assert( IsDefined( farBoats ), "Unable to find entitys with targetnames: 'cracked_far_boats'" );
	assert( farBoats.size != 0, "Unable to find entitys with targetnames: 'cracked_far_boats'" );
	
	for( boatCount = 0; boatCount < farBoats.size; boatCount++ )
	{
		farBoats[boatCount] thread floatMyBoat( clientNum, false, true );
	}
}

floatMyBoat( clientNum, startLeft, randomize )
{
	originalAngles = self.angles;
	if ( startLeft )
	{
		rollSign = -1;
	}
	else
	{
		rollSign = 1;
	}
	
	roll = ( GetDvarFloatDefault( "cscr_boatroll", level.boatRoll) * rollSign );
	
	for (;;)
	{
/#
		roll = ( GetDvarFloatDefault( "cscr_boatroll", level.boatRoll) * rollSign );
#/
		time = GetDvarFloatDefault( "cscr_boatswaytime", level.boatSwayTime);
		if ( randomize )
		{
			time += randomfloat(3);
		}
		
		slowDownTime = GetDvarFloatDefault( "cscr_boatswayslowdowntime", level.boatSwaySlowDownTime );
		
		newAngles = ( originalAngles[0], originalAngles[1], originalAngles[0] + roll );
		self serverTimedRotateTo( clientNum, newAngles, level.serverTime, time );
		self waittill( "rotatedone" );
		newAngles = ( originalAngles[0], originalAngles[1], originalAngles[0] - roll );
		self serverTimedRotateTo( clientNum, newAngles, level.serverTime, time );
		self waittill( "rotatedone" );
	}
}

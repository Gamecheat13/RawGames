#include maps\mp\_utility;
#include common_scripts\utility; 
#include maps\mp\_events;

#define MAX_CARS 20

init()
{
	PrecacheVehicle( "express_train_engine_mp" );
	PrecacheModel( "p6_bullet_train_car_phys" );
	PrecacheModel( "p6_bullet_train_engine_rev" );

	gates = GetEntArray( "train_gate_rail", "targetname" );
	brushes = GetEntArray( "train_gate_rail_brush", "targetname" );

	foreach( brush in brushes )
	{
		brush DisconnectPaths();
	}

	foreach( gate in gates )
	{
		gate.og_origin = gate.origin;
		brush = GetClosest( gate.origin, brushes );
		brush LinkTo( gate );
	}

	doors = GetEntArray( "train_gate_main", "targetname" );

	start = GetVehicleNode( "train_start", "targetname" );
	cars = [];

	cars[0] = SpawnVehicle( "p6_bullet_train_engine_phys", "train", "express_train_engine_mp", start.origin, (0, 0, 0) );
	cars[0] Ghost();

	for ( i = 1; i < MAX_CARS; i++ )
	{
		cars[i] = Spawn( "script_model", start.origin );
		cars[i] SetModel( "p6_bullet_train_car_phys" );
		cars[i] Ghost();
	}

	cars[ MAX_CARS ] = Spawn( "script_model", start.origin );
	cars[ MAX_CARS ] SetModel( "p6_bullet_train_engine_rev" );
	cars[ MAX_CARS ] Ghost();

	if ( level.timelimit )
	{
		seconds = level.timelimit * 60;
		add_timed_event( Int( seconds * 0.25 ), "train_start" );
		add_timed_event( Int( seconds * 0.75 ), "train_start" );

	}
	else if ( level.scorelimit )
	{
		add_score_event( Int( level.scorelimit * 0.25 ), "train_start" );
		add_score_event( Int( level.scorelimit * 0.75 ), "train_start" );
	}

	level thread train_think( gates, doors, cars, start );
}

train_think( gates, doors, cars, start )
{
	level endon ( "game_ended" );

	for ( ;; )
	{
		level waittill( "train_start" );

		array_func( doors, ::gate_rotate, 90 );
		array_func( gates, ::gate_move, -172 );

		foreach( gate in gates )
		{
			gate PlayLoopSound ( "amb_train_incomming_beep" );
		}
		wait( 4 );

		foreach( gate in gates )
		{
			gate StopLoopSound ( 2 );
		}

		wait( 2 );

		cars[0] AttachPath( start );
		cars[0] StartPath();
		cars[0] Show();
		cars[0] thread record_positions();
		cars[0] thread watch_end();
		cars[0] PlayLoopSound ( "amb_train_lp" );
		cars[0] SetClientField( "train_moving", 1 );

		next = "_b";

		for ( i = 1; i < cars.size; i++ )
		{
			if ( i == 1 )
			{
				wait( 0.40 );
			}
			else
			{
				wait( 0.35 );
			}
			
			if ( i >= 3 && i % 3 == 0 )
			{
				cars[i] PlayLoopSound ( "amb_train_lp" + next );

				switch( next )
				{
					case "_b":
						next = "_c";
					break;

					case "_c":
						next = "_d";
					break;

					case "_d":
						next = "";
					break;

					default:
						next = "_b";
					break;
				}
			}

			cars[i] Show();

			if ( i == cars.size - 1 )
			{
				cars[i] car_move();
			}
			else
			{
				cars[i] thread car_move();
			}
		}

		array_func( doors, ::gate_rotate, -90 );
		array_func( gates, ::gate_move );
		wait( 6 );
	}
}

record_positions()
{
	self endon( "reached_end_node" );

	if ( IsDefined( level.train_positions ) )
	{
		return;
	}

	level.train_positions = [];
	level.train_angles = [];

	for ( ;; )
	{
		level.train_positions[ level.train_positions.size ] = self.origin;
		level.train_angles[ level.train_angles.size ] = self.angles;

		wait( 0.05 );
	}
}

watch_end()
{
	self waittill( "reached_end_node" );
	self Ghost();
	self SetClientField( "train_moving", 0 );

	self StopLoopSound( 0.2 );
	self PlaySound( "amb_train_end" );
}

car_move()
{
	self SetClientField( "train_moving", 1 );

	for( i = 0; i < level.train_positions.size; i++ )
	{
		self.origin = level.train_positions[ i ];
		self.angles = level.train_angles[ i ];

		wait( 0.05 );
	}

	self Ghost();
	self SetClientField( "train_moving", 0 );

	self StopLoopSound( 0.2 );
	self PlaySound( "amb_train_end" );
}

gate_rotate( yaw )
{
	self RotateYaw( yaw, 5 );
}

gate_move( z_dist )
{
	if ( !IsDefined( z_dist ) )
	{
		self MoveTo( self.og_origin, 5 );
	}
	else
	{
		self.og_origin = self.origin;
		self MoveZ( z_dist, 5 );
	}
}

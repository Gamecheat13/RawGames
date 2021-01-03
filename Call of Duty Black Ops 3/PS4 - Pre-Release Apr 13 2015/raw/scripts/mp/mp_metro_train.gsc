#using scripts\mp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared; 

#precache( "fx", "light/fx_light_red_train_track_warning" );









function init()
{
	level.train_positions = [];
	level.train_angles = [];
	
	start1 = GetVehicleNode( "train_start_1", "targetname" );
	start2 = GetVehicleNode( "train_start_2", "targetname" );
		
	cars1 = [];
	cars2 = [];

	spawn_start_train( cars1, start1, "train1" );
	spawn_start_train( cars2, start2, "train2" );
	
	gate_1a = getent("gate_1a", "targetname"); 
	gate_1b = getent("gate_1b", "targetname"); 
	gate_2a = getent("gate_2a", "targetname"); 
	gate_2b = getent("gate_2b", "targetname");
	
	gate_kill_1a = getent("gate_kill_1a", "targetname"); 
	gate_kill_1b = getent("gate_kill_1b", "targetname"); 
	gate_kill_2a = getent("gate_kill_2a", "targetname"); 
	gate_kill_2b = getent("gate_kill_2b", "targetname"); 
	
	warning_light_1 = getent( "mp_metro_warning_light_1", "targetname"); 
	warning_light_2 = getent( "mp_metro_warning_light_2", "targetname"); 

	level._effect[ "fx_light_red_train_track_warning" ] = "light/fx_light_red_train_track_warning";
	
	setup_gate( gate_1a, gate_kill_1a );
	setup_gate( gate_1b, gate_kill_1b );
	setup_gate( gate_2a, gate_kill_2a );
	setup_gate( gate_2b, gate_kill_2b );
	
	waittillframeend;
	
	if ( train_setup_clock() ) 
	{
		level thread train_timer();
	}
	else
	{
		level thread train_timer_backup();
	}

	level thread train_think( cars1, "train_start_1", start1, gate_1a, gate_1b, warning_light_1, "right" );
	level thread train_think( cars2, "train_start_2", start2, gate_2a, gate_2b, warning_light_2, "left" );
}

function setup_gate( gate, gate_kill )
{
	gate SetMovingPlatformEnabled(true);
	gate.gate_kill = gate_kill;
	gate.gate_kill EnableLinkTo();
	gate.gate_kill LinkTo( gate );
}

function spawn_start_train( &cars, start, name )
{
	cars[0] = SpawnVehicle( "train_test_mp", (0,-2000,-200), (0, 0, 0), name );
	cars[0] Ghost();
	cars[0].isMagicBullet = true;
	
	max_cars = getdvarint( "train_length", 14 );
	for( i = 1; i < max_cars; i++ )
	{
		cars[i] = Spawn( "script_model", (0,-2000,-200) );
		cars[i] SetModel( "veh_t7_civ_train_car" );
		cars[i] Ghost();
	}
}

function train_timer()
{
	waitTime = getdvarint( "train_interval", 220 );
	if ( waitTime > 40 ) 
	{
		waitTime -= 40;
	}
	
	level endon ( "game_ended" );
	

	level.clockModel1.angles = (level.clockModel1.angles[0], level.clockModel1.angles[1], waitTime / 2 ) ;
	level.clockModel1 RotateRoll( -waitTime / 2, waitTime / 2 );

	for ( ;; )
	{
		level.clockModel2.angles = (level.clockModel2.angles[0], level.clockModel2.angles[1], waitTime ) ;
		level.clockModel2 RotateRoll( -waitTime, waitTime );
		
		level.clockModel1 waittill( "rotatedone" );	
		self notify( "train_start_1" );

		level.clockModel1.angles = (level.clockModel1.angles[0], level.clockModel1.angles[1], 0 ) ;	
		wait( 20 );
		
		level.clockModel1.angles = (level.clockModel1.angles[0], level.clockModel1.angles[1], waitTime  ) ;	
		level.clockModel1 RotateRoll( -waitTime, waitTime );
		
		level.clockModel2 waittill( "rotatedone" );
		self notify( "train_start_2" );
		
		
		level.clockModel2.angles = (level.clockModel2.angles[0], level.clockModel2.angles[1], 0 ) ;
		wait( 20 );
	}
}

function train_timer_backup()
{
	waitTime = getdvarint( "train_interval", 110 );
	level endon ( "game_ended" );
	for ( ;; )
	{
		self notify( "train_start_1" );
		
		wait waitTime;
		
		self notify( "train_start_2" );
		wait waitTime;
	}
}

function showAfterTime( time ) 
{
	wait ( time ) ;
	self Show();
}

function gate_think()
{
	self endon( "stop_kill" );
	
	for( ;; )
	{
		wait ( .4 );
		entities = GetDamageableEntArray( self.origin, 100 );
		foreach( entity in entities )
		{
			if( IsPlayer( entity ) )
			{
				if ( !entity IsTouching( self.gate_kill ) )
				{
					continue;
				}
				
				if ( !IsAlive( entity ) )
				{
					continue;
				}
				
				entity DoDamage( entity.health * 2, self.origin + ( 0, 0, 1 ), self, self, 0, "MOD_CRUSH" );
			}
		}
	}
}


function train_think( cars, notifier, start, gate_a, gate_b, warning_light, trackside )
{
	level endon ( "game_ended" );
	
	rotatingLight = spawn( "script_model", warning_light.origin );
	rotatingLight SetModel( "tag_origin" );

	for ( ;; )
	{
		level waittill( notifier );
		
		gate_move_time = getdvarfloat( "gate_move_time", 2.0 );
		gate_a MoveTo( gate_a getorigin() + ( 0, 0, 200 ), gate_move_time );
		gate_b MoveTo( gate_b getorigin() + ( 0, 0, 200 ), gate_move_time );
		gate_a.gate_kill notify ( "stop_kill" );
		gate_b.gate_kill notify ( "stop_kill" );
		
		gate_a PlayLoopSound ( "amb_train_alarm" );
		gate_b PlayLoopSound ( "amb_train_alarm" );
		exploder::exploder( "fx_train_" + trackside );

		rotatingLight rotatePitch( 360 * 20, 20 );
		playFxOnTag( level._effect[ "fx_light_red_train_track_warning" ], rotatingLight, "tag_origin" );
		rotatingLight show();

		gate_wait_train_time = getdvarfloat( "gate_wait_train_time", 5.0 );
		wait( gate_wait_train_time );
		cars[0] AttachPath( start );
		cars[0] StartPath();
		cars[0] showAfterTime( 0.1 );
		cars[0] thread record_positions(trackside);
		cars[0] PlayLoopSound ( "amb_train_by" );
		
		max_cars = getdvarint( "train_length", 14 );
		for( i = 1; i < max_cars; i++ )
		{
			wait( .60 );
			cars[i] thread car_move(trackside);
			cars[i] thread car_think();
			cars[i] PlayLoopSound ( "amb_train_by" );
		}
		wait( gate_wait_train_time );
		gate_a MoveTo( gate_a getorigin() + ( 0, 0, -200 ), gate_move_time );
		gate_b MoveTo( gate_b getorigin() + ( 0, 0, -200 ), gate_move_time );
		
		gate_a StopLoopSound ( 2 );
		gate_b StopLoopSound ( 2 );
		exploder::kill_exploder( "fx_train_" + trackside );
		rotatingLight hide();
		
		gate_a thread gate_think();
		gate_b thread gate_think();
		
		cars[0] waittill( "reached_end_node" );
		cars[0] StopLoopSound ( 2 );
		for( i = 1; i < max_cars; i++ )
		{
			cars[i] ghost();
			cars[i] notify( "stop_kill" );
			cars[i] StopLoopSound ( 2 );
		}
		cars[0] notify( "stop_kill" );
		cars[0] ghost();
	}
}

function record_positions( tracknum )
{
	self endon( "reached_end_node" );
	
	level.train_positions[tracknum] = [];
	level.train_angles[tracknum] = [];

	for ( ;; )
	{
		level.train_positions[tracknum][ level.train_positions[tracknum].size ] = self.origin;
		level.train_angles[tracknum][ level.train_angles[tracknum].size ] = self.angles;

		wait( 0.05 );
	}
}

function car_move( tracknum )
{
	self endon( "stop_kill" );
	
	for( i = 0; i < level.train_positions[tracknum].size; i++ )
	{
		self.origin = level.train_positions[tracknum][ i ];
		self.angles = level.train_angles[tracknum][ i ];

		wait( 0.05 );
		if ( i == 4 ) 
		{
			self Show();
		}
	}
}


function car_think()
{
	self endon( "stop_kill" );
	
	for( ;; )
	{
		wait ( .05 );
		entities = GetDamageableEntArray( self.origin, 200 );
		foreach( entity in entities )
		{
			if( IsPlayer( entity ) )
			{
				if ( !entity IsTouching( self ) )
				{
					continue;
				}
				
				if ( !IsAlive( entity ) )
				{
					continue;
				}
				
				entity DoDamage( entity.health * 2, self.origin + ( 0, 0, 1 ), self, self, 0, "MOD_CRUSH" );
			}
		}
	}
}


function train_setup_clock()
{
	metro_clock_1 = getent("MP_Metro_clock_1", "targetname"); 
	metro_clock_2 = getent("MP_Metro_clock_2", "targetname"); 

	if ( !isdefined( metro_clock_1 ) || !isdefined( metro_clock_2 ) )
	{ 
		return false;
	}
	
	level.clockModel1 = util::spawn_model( "tag_origin", metro_clock_1.origin, metro_clock_1.angles );
	level.clockModel1 clientfield::set( "mp_metro_train_timer", 1 );	
	
	level.clockModel2 = util::spawn_model( "tag_origin", metro_clock_2.origin, metro_clock_2.angles );
	level.clockModel2 clientfield::set( "mp_metro_train_timer", 1 );	
	
	return true;
}


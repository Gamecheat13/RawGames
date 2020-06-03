// _planeweapons.gsc: used to handle non-turret weapons on planes (bombs, rockets, etc.)
// last edit: SRS (05/03/07)
// TODO: add functionality that will let scripters temporarily change explosion params for a given vehicletype, then reset them to defaults

#include maps\_utility;
#include common_scripts\utility;

main()
{
}

/*
=============
///ScriptDocBegin
"Name: build_bomb_explosions( <type>, <quakepower>, <quaketime>, <quakeradius>, <range>, <min_damage>, <max_damage> )"
"Summary: Sets up bomb explosion parameters for when a given type of plane drops bombs. "
"Module: _planeweapons.gsc"
"CallOn: "
"MandatoryArg: <type> : the vehicletype. "
"MandatoryArg: <quakepower> : intensity of the earthquake when a bomb explodes. "
"MandatoryArg: <quaketime> : duration of the bomb's earthquake. "
"MandatoryArg: <quakeradius> : earthquake range from the epicenter of a bomb explosion. "
"MandatoryArg: <range> : damage range from the epicenter of a bomb explosion. "
"MandatoryArg: <min_damage> : minimum damage that players will take from the bomb. "
"MandatoryArg: <max_damage> : maximum damage that players will take from the bomb. "
"Example: build_bomb_explosions( "stuka", 0.5, 2.0, 1024, 768, 400, 25 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_bomb_explosions( type, quakepower, quaketime, quakeradius, range, min_damage, max_damage )
{	
	if( !IsDefined( level.plane_bomb_explosion ) )
	{
		level.plane_bomb_explosion = [];
	}
	
	AssertEx( IsDefined( quakepower ), "_planeweapons::build_bomb_explosions(): no quakepower specified!" );
	AssertEx( IsDefined( quaketime ), "_planeweapons::build_bomb_explosions(): no quaketime specified!" );
	AssertEx( IsDefined( quakeradius ), "_planeweapons::build_bomb_explosions(): no quakeradius specified!" );
	AssertEx( IsDefined( range ), "_planeweapons::build_bomb_explosions(): no range specified!" );
	AssertEx( IsDefined( min_damage ), "_planeweapons::build_bomb_explosions(): no min_damage specified!" );
	AssertEx( IsDefined( max_damage ), "_planeweapons::build_bomb_explosions(): no max_damage specified!" );
	
	struct = spawnstruct();
	struct.quakepower = quakepower;
	struct.quaketime = quaketime;
	struct.quakeradius = quakeradius;
	struct.range = range;
	struct.mindamage = min_damage;
	struct.maxdamage = max_damage;
	level.plane_bomb_explosion[ type ] = struct; 
}

/*
=============
///ScriptDocBegin
"Name: build_bombs( <type>, <bombmodel>, <bombfx>, <bomb_sound> )"
"Summary: Sets up a given type of plane to drop bombs. "
"Module: _planeweapons.gsc"
"CallOn: "
"MandatoryArg: <type> : the vehicletype. "
"MandatoryArg: <bombmodel> : the model to use for the bombs that will be attached to the plane. "
"MandatoryArg: <bombfx> : the filename of the particle to play when the bomb explodes. "
"MandatoryArg: <bomb_sound> : the sound to play when the bomb explodes. "
"Example: build_bombs( "stuka", "stuka_bomb_model", LoadFx( "explosions/artilleryExp_dirt_brown" ), "artillery_explosion" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
build_bombs( type, bombmodel, bombfx, bomb_sound )
{
	AssertEx( IsDefined( type ), "_planeweapons::build_bombs(): no vehicletype specified!" );
	AssertEx( IsDefined( bombmodel ), "_planeweapons::build_bombs(): no bomb model specified!" );
	AssertEx( IsDefined( bombfx ), "_planeweapons::build_bombs(): no bomb explosion FX specified!" );
	AssertEx( IsDefined( bomb_sound ), "_planeweapons::build_bombs(): no bomb explosion sound specified!" );
	
	// MODEL SETUP
	// build the array if we need to
	if( !IsDefined( level.plane_bomb_model ) )
	{
		level.plane_bomb_model = [];
	}
	// populate for this vehicle if we need to
	if( !IsDefined( level.plane_bomb_model[ type ] ) )
	{
		level.plane_bomb_model[ type ] = bombmodel;	
		PrecacheModel( level.plane_bomb_model[ type ] );
	}		
	
	// FX SETUP
	if( !IsDefined( level.plane_bomb_fx ) )
	{
		level.plane_bomb_fx = [];
	}
	if( !IsDefined( level.plane_bomb_fx[ type ] ) )
	{
		fx = LoadFx( bombfx );
		level.plane_bomb_fx[ type ] = fx;
	}
	
	// SOUND SETUP
	if( !IsDefined( level.plane_bomb_sound ) )
	{
		level.plane_bomb_sound = [];
	}
	if( !IsDefined( level.plane_bomb_sound[ type ] ) )
	{
		level.plane_bomb_sound[ type ] = bomb_sound;
	}
}

/*
=============
///ScriptDocBegin
"Name: bomb_init( <bomb_count> )"
"Summary: Sets up a given type of plane to drop bombs.  Usually you won't have to run this manually unless you're doing something special. "
"Module: _planeweapons.gsc"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(). "
"MandatoryArg: <bomb_count> : the total number of bombs you want to give the vehicle. "
"Example: thePlane bomb_init( 2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
// self = the vehicle
bomb_init( bomb_count )
{
	errormsg = "Can't find the bomb model for this vehicletype. Try running _planeweapons::build_bombs() to fix this!";
	AssertEx( IsDefined( level.plane_bomb_model[ self.vehicletype ] ), errormsg );
	
	errormsg = "Can't find the bomb explosion fx for this vehicletype. Try running _planeweapons::build_bombs() to fix this!";
	AssertEx( IsDefined( level.plane_bomb_fx[ self.vehicletype ] ), errormsg );
	
	errormsg = "Can't find the bomb explosion sound for this vehicletype. Try running _planeweapons::build_bombs() to fix this!";
	AssertEx( IsDefined( level.plane_bomb_sound[ self.vehicletype ] ), errormsg );
	
	self.bomb_count = bomb_count;

	if( bomb_count > 0 )
	{
		self thread attach_bombs();
		self thread drop_bombs_waittill();
		self thread bomb_drop_end();
	}
}

/*
=============
///ScriptDocBegin
"Name: drop_bombs_waittill()"
"Summary: waits for a "drop_bomb" notify, then calls drop_bombs().  Usually you won't have to run this manually unless you're doing something special. "
"Module: _planeweapons.gsc"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(), and that you have run bomb_init() on after it's spawned. "
"Example: thePlane drop_bombs_waittill();"
"Example: this demonstrates how the notify can send the optional params: thePlane notify( "drop_bomb", 2, 0.2, 0.5 ); "
"Notes: The "drop_bomb" notify has optional params: amount (of bombs to drop), delay (how long between bombs), and delay_trace (do you want to wait before starting ground traces from the falling bomb?). "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
// self = the vehicle
drop_bombs_waittill()
{
	self endon( "death" );
	self endon( "reached_end_node" );

	while( 1 )
	{
		self waittill( "drop_bombs", amount, delay, delay_trace );
		drop_bombs( amount, delay, delay_trace );
	}
}

// Wait until end or path or death, if bombs are present, delete them
// self = the vehicle
bomb_drop_end()
{
	self waittill( "reached_end_node" );

	if( IsDefined( self.bomb ) )
	{
		for( i = 0; i < self.bomb.size; i++ )
		{
			if( IsDefined( self.bomb[i] ) && !self.bomb[i].dropped )
			{
				self.bomb[i] Delete();
			}
		}
	}
}

// Attach the bombs to the plane
// self = the vehicle
attach_bombs()
{
	self.bomb = [];
	
	tag_l1 = "tag_smallbomb01left";
	tag_l2 = "tag_smallbomb02left";
	tag_r1 = "tag_smallbomb01right";
	tag_r2 = "tag_smallbomb02right";
	tag_c = "tag_BIGbomb";
	
	if (self.model == "vehicle_usa_aircraft_f4ucorsair_dist")
	{
		tag_l1 = "tag_bomb_left";
		tag_l2 = "tag_bomb_left";
		tag_r1 = "tag_bomb_right";
		tag_r2 = "tag_bomb_right";
		tag_c = "tag_bomb_right";
	}
	
	for( i = 0; i < self.bomb_count; i++ )
	{
		self.bomb[i] = Spawn( "script_model", ( self.origin ) );
		self.bomb[i] SetModel( level.plane_bomb_model[ self.vehicletype ] );
		self.bomb[i].dropped = false;

		
		if( i == 0 )
		{
			self.bomb[i] LinkTo( self, tag_l1, ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else if( i == 1 )
		{
			self.bomb[i] LinkTo( self, tag_r1, ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else if( i == 2 )
		{
			self.bomb[i] LinkTo( self, tag_l2, ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else if( i == 3 )
		{
			self.bomb[i] LinkTo( self, tag_r2, ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else
		{
			self.bomb[i] LinkTo( self, tag_c, ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
	}
}
/*
=============
///ScriptDocBegin
"Name: drop_bombs( [amount], [delay], [delay_trace], [trace_dist] )"
"Summary: drops bombs from a plane that's been set up appropriately.  Usually you won't have to run this manually unless you're doing something special. "
"Module: _planeweapons.gsc"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(), and that you have run bomb_init() on after it's spawned. "
"OptionalArg: [amount] : the number of bombs you want to drop in this sequence. default = all bombs "
"OptionalArg: [delay] : the number of seconds between bombs being dropped in this sequence. default = random float between 0.1 and 0.5. "
"OptionalArg: [delay_trace] : the number of seconds to delay ground traces from the falling bomb (for example, if it needs to pass through a collidable surface first). default = 0. "
"OptionalArg: [trace_dist] : how far toward the ground (in Radiant units) the bomb will trace when looking for a collidable surface to explode against. default = 64 "
"Example: thePlane drop_bombs( 2, 0.2, 0.5, 64 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
// SRS 05/02/07: removed damage params as they're now pre-set in build_bomb_explosions().
// TODO: clean up duplicate scripting in this function.
// self = the vehicle
drop_bombs( amount, delay, delay_trace, trace_dist )
{
	self endon( "reached_end_node" );
	self endon ("death");
	total_bomb_count = self.bomb.size;

	user_delay = undefined;

	if( !IsDefined( self.bomb.size ) )
	{
		return;
	}

	if( self.bomb.size == 0 || total_bomb_count == 0 )
	{
		println( "^3_planeweapons::drop_bombs(): Plane at " + self.origin + " with targetname " + self.targetname + " has no bombs to drop!" );
		return;
	}

	if( IsDefined( delay ) )
	{
		user_delay = delay;
		//println( "user_delay ", user_delay );
	}

	if( IsDefined( amount ) )
	{
		if( amount == 0 )
		{
			return;
		}

		if( amount > self.bomb_count )
		{
			amount = self.bomb_count;
		}

		for( i = 0; i < amount; i++ )
		{
			if( total_bomb_count <= 0 )
			{
				println( "^3_planeweapons::drop_bombs(): Plane at " + self.origin + " with targetname " + self.targetname + " has no more bombs to drop!" );
				return;
			}

			if( IsDefined( self.bomb[i] ) && self.bomb[i].dropped )
			{
				for( q = 0; q < self.bomb_count; q++ )
				{
					if( IsDefined( self.bomb[q] ) && !self.bomb[q].dropped )
					{
						i = q;
						q = ( self.bomb_count + 1 );
					}
				}
			}
			else if( !IsDefined( self.bomb[i] ) )
			{
				for( q = 0; q < self.bomb_count; q++ )
				{
					if( IsDefined( self.bomb[q] ) && !self.bomb[q].dropped )
					{
						i = q;
						q = ( self.bomb_count + 1 );
					}
				}
			}

			// There's a bug in here... If you call more than total_amount to drop, like drop
			// 1, drop 1, drop 1 drop 1, drop 1, it will either error out or have the 1st bomb
			// get carried over.

			total_bomb_count--;
			self.bomb_count--;
			self.bomb[i].dropped = true;

			forward = AnglesToForward( self.angles );
			vec = vectorScale( forward, self GetSpeed() );

			// Compensates for the frame delay when "unlinked."
			vec_predict = self.bomb[i].origin + vectorScale( forward, ( self GetSpeed() * 0.06 ) );

			self.bomb[i] UnLink();
			self.bomb[i].origin = vec_predict; // Compensates for the frame delay when "unlink" is called.
			self.bomb[i] MoveGravity( ( ( vec ) ), 10 );
			self.bomb[i] thread bomb_wiggle();

			self.bomb[i] thread bomb_trace( self.vehicletype, delay_trace, trace_dist );

			if( IsDefined( user_delay ) )
			{
				delay = user_delay;
			}
			else
			{
				delay = 0.1 + RandomFloat( 0.5 );
			}
			wait( delay );
		}
	}
	else
	{
		for( i = 0; i < self.bomb.size; i++ )
		{
			if( !IsDefined( self.bomb[i] ) || self.bomb[i].dropped )
			{
				continue;
			}

			if( total_bomb_count <= 0 )
			{
				println( "^3_planeweapons::drop_bombs(): Plane at " + self.origin + " with targetname " + self.targetname + " has no bombs to drop!" );
				return;
			}

			total_bomb_count--;
			self.bomb_count--;
			forward = AnglesToForward( self.angles );
			vec = vectorScale( forward, self GetSpeed() );

			// Compensates for the frame delay when "unlinked."
			vec_predict = self.bomb[i].origin + vectorScale( forward, ( self GetSpeed() * 0.06 ) );

			vec = ( ( vec[0] +( -20 + RandomFloat( 40 ) ) ), ( vec[1] +( -20 + RandomFloat( 40 ) ) ), vec[2] );

			self.bomb[i] UnLink();
			self.bomb[i].origin = vec_predict; // Compensates for the frame delay when "unlink" is called.
			self.bomb[i] MoveGravity( ( vec ), 10 );
			self.bomb[i] thread bomb_wiggle();

			self.bomb[i] thread bomb_trace( self.vehicletype, delay_trace, trace_dist );

			if( IsDefined( user_delay ) )
			{
				delay = user_delay;
			}
			else
			{
				delay = 0.1 + RandomFloat( 0.5 );
			}
			wait( delay );
		}
	}
}

// self = da bomb
bomb_wiggle()
{
	self endon( "death" );

	original_angles = self.angles;
	while( 1 )
	{
		roll = 10 + RandomFloat( 20 );
		yaw = 4 + RandomFloat( 3 );
//		angles = ( 0, ( original_angles[1] + RandomFloat( 1 ) ), ( 0.5 + RandomFloat( 1 ) ) );
		time = 0.25 + RandomFloat( 0.25 );
		time_in_half = time/3;

		self bomb_pitch( time );
		self RotateTo( ( self.pitch, ( original_angles[1] +( yaw * -2 ) ), ( roll * -2 ) ), ( time * 2 ), ( time_in_half * 2 ), ( time_in_half * 2 ) );
		self waittill( "rotatedone" );

		self bomb_pitch( time );
		self RotateTo( ( self.pitch, ( original_angles[1] +( yaw * 2 ) ), ( roll * 2 ) ), ( time * 2 ), ( time_in_half * 2 ), ( time_in_half * 2 ) );
		self waittill( "rotatedone" );
	}
}

// self = da bomb
bomb_pitch( time_of_rotation )
{
	self endon( "death" );

	if( !IsDefined( self.pitch ) )
	{
		original_pitch = self.angles;
		self.pitch = original_pitch[0];
		time = 15 + RandomFloat( 5 );
	}

	if( self.pitch < 80 )
	{
		self.pitch = ( self.pitch +( 40 * time_of_rotation ) );
		if( self.pitch > 80 )
		{
			self.pitch = 80;
		}
	}
	return;
}

// self = da bomb
bomb_trace( type, delay_trace, trace_dist )
{
	//old_dist = undefined;

	self endon( "death" );
	if( IsDefined( delay_trace ) )
	{
		wait( delay_trace );
	}

	if( !IsDefined( trace_dist ) )
	{
		trace_dist = 64;
	}

	while( 1 )
	{
		vec1 = self.origin;
		direction = AnglesToForward( ( 90, 0, 0 ) );
		vec2 = vec1 + vectorScale( direction, 10000 );
		trace_result = BulletTrace( vec1, vec2, false, undefined );

		dist = Distance( self.origin, trace_result["position"] );
//		println( "Dist ", dist );

		//if( !IsDefined( old_dist ) )
		// Check the distance, in order to blow up... Failsafe, if the bomb happened to go through the ground
		// the >= 10000 should pickup and blowup.
		if( dist < trace_dist || dist >= 10000 )
		{
				self thread bomb_explosion( type );
		}

//		if( IsDefined( self.origin ) )
//		{
//			print3d( ( self.origin +( 0, 0, 16 ) ), self.origin, ( 1, 1, 1 ), 1, 1 );
//			print3d( ( self.origin +( 0, 0, 32 ) ), dist, ( 1, 1, 1 ), 1, 1 );
//			print3d( ( self.origin +( 0, 0, 48 ) ), trace_result["surfacetype"], ( 1, 1, 1 ), 1, 1 );
//		}
//		line( vec1, trace_result["position"] );

		wait( 0.05 );
	}
}

// self = da bomb
bomb_explosion( type )
{
	Assert( IsDefined( level.plane_bomb_explosion[ type ] ), "_planeweapons::bomb_explosion(): No plane_bomb_explosion info set up for vehicletype " + type + ". Make sure to run _planeweapons::build_bomb_explosions() first." );
	
	struct = level.plane_bomb_explosion[ type ];
	
	quake_power = struct.quakepower;
	quake_time = struct.quaketime;
	quake_radius = struct.quakeradius;
	damage_range = struct.range;
	max_damage = struct.mindamage;
	min_damage = struct.maxdamage;

	sound_org = Spawn( "script_origin", self.origin );
	sound_org PlaySound( level.plane_bomb_sound[ type ] );
	sound_org thread bomb_sound_delete();

	/#
	println( "^1plane bomb goes BOOM!!! ^7( Dmg Radius: ", damage_range, " | Max Dmg: ", max_damage, " | Min Dmg: ", min_damage, " )" );
	#/
	
	PlayFx( level.plane_bomb_fx[ type ], self.origin );	
	Earthquake( quake_power, quake_time, self.origin, quake_radius );
	RadiusDamage( self.origin, damage_range, max_damage, min_damage );

	self Delete();
}

// self = the spawned script_origin that plays the bomb sound
bomb_sound_delete()
{
	wait( 5 );
	self Delete();
}

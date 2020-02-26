// __plane_weapons.gsc: used to handle non-turret weapons on planes (bombs, rockets, etc.)
// last edit: SRS (05/03/07)
// TODO: add functionality that will let scripters temporarily change explosion params for a given vehicletype, then reset them to defaults

#include maps\_utility;
#include common_scripts\utility;

main()
{
}

/@
"Name: build_bomb_explosions( <type>, <quakepower>, <quaketime>, <quakeradius>, <range>, <min_damage>, <max_damage> )"
"Summary: Sets up bomb explosion parameters for when a given type of plane drops bombs. "
"Module: Vehicle"
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
@/
build_bomb_explosions( type, quakepower, quaketime, quakeradius, range, min_damage, max_damage )
{	
	if( !IsDefined( level.plane_bomb_explosion ) )
	{
		level.plane_bomb_explosion = [];
	}
	
	assert( IsDefined( quakepower ), "_plane_weapons::build_bomb_explosions(): no quakepower specified!" );
	assert( IsDefined( quaketime ), "_plane_weapons::build_bomb_explosions(): no quaketime specified!" );
	assert( IsDefined( quakeradius ), "_plane_weapons::build_bomb_explosions(): no quakeradius specified!" );
	assert( IsDefined( range ), "_plane_weapons::build_bomb_explosions(): no range specified!" );
	assert( IsDefined( min_damage ), "_plane_weapons::build_bomb_explosions(): no min_damage specified!" );
	assert( IsDefined( max_damage ), "_plane_weapons::build_bomb_explosions(): no max_damage specified!" );
	
	struct = spawnstruct();
	struct.quakepower = quakepower;
	struct.quaketime = quaketime;
	struct.quakeradius = quakeradius;
	struct.range = range;
	struct.mindamage = min_damage;
	struct.maxdamage = max_damage;
	level.plane_bomb_explosion[ type ] = struct; 
}

/@
"Name: build_bombs( <type>, <bombmodel>, <bombfx>, <bomb_sound> )"
"Summary: Sets up a given type of plane to drop bombs. "
"Module: Vehicle"
"CallOn: "
"MandatoryArg: <type> : the vehicletype. "
"MandatoryArg: <bombmodel> : the model to use for the bombs that will be attached to the plane. "
"MandatoryArg: <bombfx> : the filename of the particle to play when the bomb explodes. "
"MandatoryArg: <bomb_sound> : the sound to play when the bomb explodes. "
"Example: build_bombs( "stuka", "stuka_bomb_model", LoadFx( "explosions/artilleryExp_dirt_brown" ), "artillery_explosion" );"
"SPMP: singleplayer"
@/
build_bombs( type, bombmodel, bombfx, bomb_sound )
{
	assert( IsDefined( type ), "_plane_weapons::build_bombs(): no vehicletype specified!" );
	assert( IsDefined( bombmodel ), "_plane_weapons::build_bombs(): no bomb model specified!" );
	assert( IsDefined( bombfx ), "_plane_weapons::build_bombs(): no bomb explosion FX specified!" );
	assert( IsDefined( bomb_sound ), "_plane_weapons::build_bombs(): no bomb explosion sound specified!" );
	
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
		// SCRIPTER_MOD: dguzzo: 3-9-09 : vehicle system has changed to be gdt-based. need to precache this in the level script before an wait statements.
//		PrecacheModel( level.plane_bomb_model[ type ] );
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
"Name: bomb_init( <bomb_count> )"
"Summary: Sets up a given type of plane to drop bombs.  Usually you won't have to run this manually unless you're doing something special. "
"Module: Vehicle"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(). "
"MandatoryArg: <bomb_count> : the total number of bombs you want to give the vehicle. "
"Example: thePlane bomb_init( 2 );"
"SPMP: singleplayer"
=============
*/
// self = the vehicle
bomb_init( bomb_count )
{
	errormsg = "Can't find the bomb model for this vehicletype. Check your vehicle's script file; you may need to call its setup_bombs function.";
	assert( IsDefined( level.plane_bomb_model[ self.vehicletype ] ), errormsg );
	
	errormsg = "Can't find the bomb explosion fx for this vehicletype. Check your vehicle's script file; you may need to call its setup_bombs function.";
	assert( IsDefined( level.plane_bomb_fx[ self.vehicletype ] ), errormsg );
	
	errormsg = "Can't find the bomb explosion sound for this vehicletype. Check your vehicle's script file; you may need to call its setup_bombs function.";
	assert( IsDefined( level.plane_bomb_sound[ self.vehicletype ] ), errormsg );
	
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
"Name: drop_bombs_waittill()"
"Summary: waits for a "drop_bomb" notify, then calls drop_bombs().  Usually you won't have to run this manually unless you're doing something special. "
"Module: Vehicle"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(), and that you have run bomb_init() on after it's spawned. "
"Example: thePlane drop_bombs_waittill();"
"Example: this demonstrates how the notify can send the optional params: thePlane notify( "drop_bomb", 2, 0.2, 0.5 ); "
"Notes: The "drop_bomb" notify has optional params: amount (of bombs to drop), delay (how long between bombs), and delay_trace (do you want to wait before starting ground traces from the falling bomb?). "
"SPMP: singleplayer"
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

	// AE 7-28-09: took out the older planes put in this switch statement for easier additions
	bomb_tag = [];	
	switch(self.model)
	{
	case "t5_veh_jet_mig17":
	case "t5_veh_jet_mig17_gear":
		bomb_tag[0] = "tag_left_wingtip";
		bomb_tag[1] = "tag_right_wingtip";
		break;

	default:
		bomb_tag[0] = "tag_smallbomb01left";
		bomb_tag[1] = "tag_smallbomb02left";
		bomb_tag[2] = "tag_smallbomb01right";
		bomb_tag[3] = "tag_smallbomb02right";
		bomb_tag[4] = "tag_BIGbomb";
		break;
	}
	
	for( i = 0; i < self.bomb_count; i++ )
	{
		self.bomb[i] = Spawn( "script_model", ( self.origin ) );
		self.bomb[i] SetModel( level.plane_bomb_model[ self.vehicletype ] );
		self.bomb[i].dropped = false;

		if(IsDefined(bomb_tag[i]))
		{
			self.bomb[i] LinkTo( self, bomb_tag[i], ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
	}
}
/*
=============
"Name: drop_bombs( [amount], [delay], [delay_trace], [trace_dist] )"
"Summary: drops bombs from a plane that's been set up appropriately.  Usually you won't have to run this manually unless you're doing something special. "
"Module: Vehicle"
"CallOn: a vehicle of a type that you've already set up with build_bombs() and build_bomb_explosions(), and that you have run bomb_init() on after it's spawned. "
"OptionalArg: [amount] : the number of bombs you want to drop in this sequence. default = all bombs "
"OptionalArg: [delay] : the number of seconds between bombs being dropped in this sequence. default = random float between 0.1 and 0.5. "
"OptionalArg: [delay_trace] : the number of seconds to delay ground traces from the falling bomb (for example, if it needs to pass through a collidable surface first). default = 0. "
"OptionalArg: [trace_dist] : how far toward the ground (in Radiant units) the bomb will trace when looking for a collidable surface to explode against. default = 64 "
"Example: thePlane drop_bombs( 2, 0.2, 0.5, 64 );"
"SPMP: singleplayer"
=============
*/
// SRS 05/02/07: removed damage params as they're now pre-set in build_bomb_explosions().
// SCRIPTER_MOD: dguzzo: 3-9-09 : cleaned this up a bit, fixed an indexing bug
// self = the vehicle
drop_bombs( amount, delay, delay_trace, trace_dist )
{
	self endon( "reached_end_node" );
	self endon ("death");
	
	// remove any dropped bombs from the list of candidate bombs
	total_bomb_count = array_removeUndefined( self.bomb ).size;

	user_delay = undefined;
	new_bomb_index = undefined;

	if( !IsDefined( self.bomb.size ) )
	{
		return;
	}

	// user specified no bombs, just return
	if( amount == 0 )
	{
		return;
	}

	if( total_bomb_count <= 0 )
	{
		println( "^3_plane_weapons::drop_bombs(): Plane at " + self.origin + " with targetname " + self.targetname + " has no bombs to drop!" );
		return;
	}

	if( IsDefined( delay ) )
	{
		user_delay = delay;
		//println( "user_delay ", user_delay );
	}

	// if not defined, drop as many as possible. if too many, cap the amount
	if( !IsDefined( amount ) || ( amount > total_bomb_count ) )
	{
		amount = total_bomb_count;
	}
	
	for( i = 0; i < amount; i++ )
	{
		
		if( total_bomb_count <= 0 )
		{
			println( "^3_plane_weapons::drop_bombs(): Plane at " + self.origin + " with targetname " + self.targetname + " has no more bombs to drop!" );
			return;
		}

		// if the bomb we want to drop has already been dropped (or doesn't exist for some other reason), find the next candidate
		if( ( IsDefined( self.bomb[i] ) && self.bomb[i].dropped ) || !IsDefined( self.bomb[i] ) )
		{
			for( q = 0; q < self.bomb.size; q++ )
			{
				if( IsDefined( self.bomb[i+q] ) && !self.bomb[i+q].dropped )
				{
					new_bomb_index = i+q;
					break;
				}
			}
		}
		// no bombs have been dropped yet, just use the usual indexing
		else
		{
			new_bomb_index = i;	
		}

		total_bomb_count--;
		self.bomb_count--;
		self.bomb[new_bomb_index].dropped = true;

		forward = AnglesToForward( self.angles );
		vec = VectorScale( forward, self GetSpeed() );

		// Compensates for the frame delay when "unlinked."
		vec_predict = self.bomb[new_bomb_index].origin + VectorScale( forward, ( self GetSpeed() * 0.06 ) );

		self.bomb[new_bomb_index] UnLink();
		self.bomb[new_bomb_index].origin = vec_predict; // Compensates for the frame delay when "unlink" is called.
		self.bomb[new_bomb_index] MoveGravity( ( ( vec ) ), 10 );
		self.bomb[new_bomb_index] thread bomb_wiggle();

		self.bomb[new_bomb_index] thread bomb_trace( self.vehicletype, delay_trace, trace_dist );

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
		vec2 = vec1 + VectorScale( direction, 10000 );
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
	assert( IsDefined( level.plane_bomb_explosion[ type ] ), "_plane_weapons::bomb_explosion(): No plane_bomb_explosion info set up for vehicletype " + type + ". Make sure to run _plane_weapons::build_bomb_explosions() first." );
	
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

#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;

#using_animtree ("generic_human");

///////////////////////////////////////////////////////////////////////////
// AI


// Kill a group of enemies
kill_enemies( value, key )
{
	enemies = getentarray( value, key );
	for( i = 0; i < enemies.size; i++ )
	{
		enemies[i] thread maps\pel1b::bloody_death();
		wait( 0.3 );
	}
}

// Typical spawn function. Makes AI to ignore everything until goal
force_to_goal_exact()
{
	self endon( "death" );

	self.goalradius = 32;
	self.pacifist = 1;
	self.ignoreall = 1;

	self waittill( "goal" );

	self.pacifist = 0;
	self.ignoreall = 0;
}

// TEMP
force_to_goal_ignore_player()
{
	self endon( "death" );
	
	self setthreatbiasgroup( "oblivious_enemies" );	
	self thread force_to_goal_exact();
}

force_spawn_guy( spawner )
{
	guy = spawner StalingradSpawn();
	spawn_failed ( guy );
	return( guy );
}

// spawn an AI, catch him on flame, Run him near his goal node. Then kill him
spawn_flame_runner( value, key )
{
	spawner = getent( value, key );
	runner = force_spawn_guy( spawner );

	runner.goalradius = 16;
	runner.ignoreall = 1;
	runner.pacifist = 1;
	runner.health = 1;
	runner.animname = "runner";
	runner endon( "death" );

	//self putGunAway();

	index = randomint( 100 );
	if( index < 50 )
	{
		runner set_run_anim( "panick_run_1" );
	}
	else
	{
		runner set_run_anim( "panick_run_2" );
	}

	runner thread animscripts\death::flame_death_fx();
	
	while( distance( runner.origin, runner.goalpos ) > 200 )
	{
		wait( 0.1 );
		if( !isalive( runner ) )
		{
			break;
		}
	}

	if( isalive( runner ) )
	{
		runner thread maps\pel1b::bloody_death();
	}
}


///////////////////////////////////////////////////////////////////////////
// VEHICLE


// kill a vehicle with shreck
fire_shrecks_with_damage( tank, damage )
{
	radiusdamage(tank.origin + ( 0, 0, 200 ), 300, damage, 35);
	
	earthquake( 0.3, 1.5, tank.origin, 512 );

	playfx( level._effect["tank_blowup"], tank.origin );
	//playfx( level._effect["smoke_destroyed_tank"], tank.origin );
}

// wait till vehicle reaches a node
// (Need this because node waittill( "trigger" ) refuses to work in a prefab
waittill_vehiclenode( node )
{
	self setwaitnode( node );
	self waittill( "reached_wait_node" );
}

// Another version waiting for node
waittill_vehiclenode_noteworthy( node_noteworthy )
{
	node = getvehiclenode( node_noteworthy, "script_noteworthy" );
	self setwaitnode( node );
	self waittill( "reached_wait_node" );
	wait( 0.1 );
}

create_new_origin_ent( origin )
{
	level.temp_spawned_origins[level.temp_spawned_origins.size] = spawn( "script_origin", origin );
	level.temp_spawned_origins[level.temp_spawned_origins.size-1].health = 1000000;
}

// target a struct
set_turret_target_by_name( point_name )
{
	point = getstruct( point_name, "targetname" );
	self SetTurretTargetVecSafe( point.origin );
}

SetTurretTargetVecSafe( target_vector )
{
	self SetTurretTargetVec( target_vector );
/*
	// ensure that the target is no more than X units away
	max_dist = 300;

	dist = distance( target_vector, self.origin );
	if( dist <= max_dist )
	{
		create_new_origin_ent( target_vector );
		self SetTurretTargetEnt( level.temp_spawned_origins[level.temp_spawned_origins.size-1] ); // good to go
	}
	else
	{
		vector_towards_target = VectorNormalize( target_vector - self.origin );
		new_target = self.origin + vector_towards_target * max_dist;
		dist = distance( new_target, self.origin );
		iprintlnbold( dist );
		create_new_origin_ent( new_target );
		self SetTurretTargetEnt( level.temp_spawned_origins[level.temp_spawned_origins.size-1] );
	}
*/
}

// target a struct, then target the struct's target, then its target, etc. Until
// the chain is finished. Pauses 1 second between each target
// - Can be stopped prematurely with an end message
trace_turret_target_by_name( point_name, end_msg )
{
	level endon( end_msg );

	point_line = [];
	point_line[0] = getstruct( point_name, "targetname" );
	next_point_name = point_line[0].target;
	done = false;

	while( 1 )
	{
		point_line[point_line.size] = getstruct( next_point_name, "targetname" );
		if( isdefined( point_line[point_line.size-1].target ) )
		{
			next_point_name = point_line[point_line.size-1].target;
		}
		else
		{
			break;
		}
	}

	for( i = 0; i < point_line.size; i++ )
	{
		self SetTurretTargetVecSafe( point_line[i].origin );
		self waittill( "turret_on_target" );

		if( isdefined( point_line[i].script_noteworthy ) )
		{
			level notify( point_line[i].script_noteworthy );
		}
		wait( 0.5 );
	}
}

///////////////////////////////////////////////////////////////////////////
// PLANE and BOMBS

load_bombs( bomb_num )
{
	self.bomb_count = bomb_num;

	self.bomb = [];
	for( i = 0; i < self.bomb_count; i++ )
	{
		self.bomb[i] = Spawn( "script_model", ( self.origin ) );
		self.bomb[i] SetModel( level.plane_bomb_model[ self.vehicletype ] );
		self.bomb[i].dropped = false;
		wait(.1);
		if( i % 2 == 0 )
		{
			self.bomb[i] LinkTo( self, "tag_gunLeft", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else
		{
			self.bomb[i] LinkTo( self, "tag_gunRight", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		
	}
}

// drop bombs when the node is reached
drop_bombs( node_name, fire_fx, num )
{
	self endon( "death" );

	if( !isdefined( num ) )
	{
		num = 2;
	}

	node = getvehiclenode( node_name, "script_noteworthy" );
	node waittill("trigger");

	self thread	maps\_planeweapons::drop_bombs( num, 0, 2, 500 );

	// estimate the time when the bomb blows up
	wait( 1 );
	level notify( node_name );

	if( fire_fx )
	{
		// play a fire effect somewhere
		fire_fx_origin = getstruct( node_name, "targetname" );
		playfx( level._effect["fire_foliage_large"], fire_fx_origin.origin );	
		playfx( level._effect["smoke_column"], fire_fx_origin.origin );	
	}

	// delete self at the end of path
	self waittill( "reached_end_node" );
	self delete();
}


// Modified this to support the network traffic
drop_bombs_rumble()
{
		// play rumbles on players
	players = get_players();
	for( p = 0; p < players.size; p++ )
	{	
		earthquake( 1, 0.5, players[p].origin , 50 );
		wait_network_frame();
		PlayRumbleOnPosition( "explosion_generic", players[p].origin );
		wait_network_frame();
	}	
}



///////////////////////////////////////////////////////////////////////////
// MISC


// fake a bomb drop
additional_bomb( struct_name, start_msg )
{
	struct_target = getstruct( struct_name, "targetname" );
	level waittill( start_msg );
	wait( 0.3 );
	playfx( level._effect["napalm_explosion"], struct_target.origin );
	playfx( level._effect["fire_foliage_large"], struct_target.origin );	
	playsoundatposition( "mortar_dirt", struct_target.origin );
}

napalm_chain( start_struct_name )
{
	point_line = [];
	point_line[0] = getstruct( start_struct_name, "targetname" );
	next_point_name = point_line[0].target;
	done = false;

	while( 1 )
	{
		point_line[point_line.size] = getstruct( next_point_name, "targetname" );
		if( isdefined( point_line[point_line.size-1].target ) )
		{
			next_point_name = point_line[point_line.size-1].target;
		}
		else
		{
			break;
		}
	}

	for( i = 0; i < point_line.size; i++ )
	{
		PlayFx( level._effect["napalm_explosion"], point_line[i].origin );	
		playsoundatposition( "mortar_dirt", point_line[i].origin );
		if( isdefined( point_line[i].script_noteworthy ) )
		{
			level notify( point_line[i].script_noteworthy );
		}
		RadiusDamage( point_line[i].origin, 700, 100, 50 );
		Earthquake( 0.7, 2, point_line[i].origin, 3500 );
		wait( randomfloat( 0.2 ) + 0.2 );
	}
}

trigger_wait_with_notify( value, key, msg )
{
	trigger = getent( value, key );
	trigger waittill( "trigger" );
	level notify( msg );
}


///////////////////////////////////////////////////////////////////////////
// ANIM RELATED

play_explosion_death_anim( struct_value, struct_key )
{
	struct_org = getstruct( struct_value, struct_key );

	guy = spawn_fake_guy( struct_org.origin, struct_org.angles, "axis", "generic" );

	level thread anim_single_solo( guy, "death_explosion_forward", undefined, guy );
	 
	wait( 1 );
	guy startragdoll();	
}

// Spawn a drone model
#using_animtree ("generic_human");
spawn_fake_guy( startpoint, startangles, side, animname )
{
	guy = spawn( "script_model", startpoint );
	guy.angles = startangles;
	
	if( side == "allies" )
	{
		guy character\char_usa_marine_r_rifle::main();
		guy maps\_drones::drone_allies_assignWeapon_american();
		guy.team = "allies";
	}
	else
	{
		guy character\char_jap_makpel_rifle::main();		
		guy maps\_drones::drone_axis_assignWeapon_japanese();
		guy.team = "axis";
	}
	
	guy UseAnimTree( #animtree );
	guy.animname = animname;
	guy makeFakeAI();			// allow it to be animated

	return guy;
}


jog_waittill_stop()
{
	stop_trigger = getent( "ev2_initial_plane_spawn", "targetname" );
	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] istouching( stop_trigger ) )
			{
				return;
			}
		}
	
		if( level.sarge istouching( stop_trigger ) || level.walker istouching( stop_trigger ) )
		{
			return;
		}	
		wait( 0.05 );
	}
}

jog_look_alternate()
{
	// begin at start of event 2

	// AI look around for a few seconds
	flag_set( "jog_look_around" );
/*
	wait( 3 );

	flag_clear( "jog_look_around" );

	wait( 4 );

	flag_set( "jog_look_around" );

	wait( 3 );

	flag_clear( "jog_look_around" );
*/
}

jog_start()
{
	flag_set( "jog_enabled" );

	level thread jog_look_alternate();

	level.sarge thread jog_internal();
	wait( 0.2 );
	level.walker thread jog_internal();
}



jog_internal()
{
	self endon( "death" );

	self.animname = "generic";

	jogs_left = [];
	jogs_left[jogs_left.size] = "jog1";
	jogs_left[jogs_left.size] = "jog2";
	jogs_left[jogs_left.size] = "jog4";

	jogs_right = [];
	jogs_right[jogs_right.size] = "jog1";
	jogs_right[jogs_right.size] = "jog2";
	jogs_right[jogs_right.size] = "jog3";
	
	jogs_forward = [];
	jogs_forward[jogs_forward.size] = "jog1";
	jogs_forward[jogs_forward.size] = "jog2";

	while( flag( "jog_enabled" ) )  
	{
		// once we're past all the ambushes, no need to look left/right anymore
		if( flag( "jog_look_around" ) )
		{
			if( self.script_forceColor == "y" )   
			{
				jog = jogs_left[RandomInt(jogs_left.size)];
			}
			else
			{
				jog = jogs_right[RandomInt(jogs_right.size)];
			}	
		}
		else
		{
			jog = jogs_forward[RandomInt(jogs_forward.size)];
		}
			
		self.moveplaybackrate = 0.8;
		self set_generic_run_anim( jog );
		delay = GetAnimLength( level.scr_anim["generic"][jog] );
		wait( delay - 0.2 );
	}

	self.moveplaybackrate = 1.0;
	self clear_run_anim();
}

tree_fall()
{
	tree = getent( "ev2_tree_fall", "targetname" );
	//playfxontag( level._effect["fire_foliage_large"], tree, "J_Tip1_Tall1" );
	tree RotatePitch( 80, 2, 1.5, 0.1 );
}


///////////////////////////////////////////////////////////////////////////
// FX RELATED
play_dust_fx_near_players()
{
	struct_pos = getstructarray( "ev2_cave_dust", "targetname" );

	// get structs within 
	org_closest = [];
	players = get_players();

	for( i = 0; i < struct_pos.size; i++ )
	{
		for( p = 0; p < players.size; p++ )
		{
			if( Distance2D( struct_pos[i].origin, players[p].origin ) < 500 )
			{
				org_closest[org_closest.size] = struct_pos[i].origin;
			}
		}
	}

	for( p = 0; p < players.size; p++ )
	{	
		earthquake( 1, 0.5, players[p].origin , 60 );
		PlayRumbleOnPosition( "explosion_generic", players[p].origin );
	}

	org_closest = array_randomize( org_closest );

	for( i = 0; i < org_closest.size; i++ )
	{
		if( i < 3 )
		{
			playfx( level._effect["dirt_fall_huge"], org_closest[i] );
			playsoundatposition( "ceiling_dust", org_closest[i] );
			wait( 0.05 );
		}
		else if( i < 8 )
		{
			playfx( level._effect["dirt_fall_md"], org_closest[i] );
			playsoundatposition( "ceiling_dust", org_closest[i] );
			wait( 0.05 );
		}
		else 
		{
			playfx( level._effect["dirt_fall_sm"], org_closest[i] );
			playsoundatposition( "ceiling_dust", org_closest[i] );
			wait( 0.1 );
		}
	}
}
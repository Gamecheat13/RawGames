#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\london_code;

start_dump( )
{
	startname = self.script_startname;
	if ( IsDefined( level.start_arrays[ startname ] ) )
		return;
	self waittill ( "trigger" );
	
	if( level.start_point != "train_start_ride" )
		return;
		
	Assert ( IsDefined( startname ) );
	
	spawned_vehicles = [];
 /#
	freezeframed_vehicles = get_vehicles_with_spawners();

	// freezeframe the vehicles because fileprint requires some frames.
	foreach( vehicle in freezeframed_vehicles )
	{
		struct = SpawnStruct();
		struct.vehicletype = vehicle.vehicletype;
		struct.origin = vehicle.origin;
		struct.angles = vehicle.angles;
		struct.model = vehicle.model;
		struct.vehicle_spawner = vehicle.vehicle_spawner;
		struct.currentnode = vehicle.currentnode;
		struct.detouringpath = vehicle.detouringpath;
		struct.target = vehicle.target;
		struct.targetname = vehicle.targetname;
		struct.speedmph = vehicle Vehicle_GetSpeed();
		struct.script_angles = vehicle.script_angles;
		spawned_vehicles[spawned_vehicles.size] = struct;
	}

	// break if detouring oddlike
	foreach( vehicle in freezeframed_vehicles )
	{
		if ( ! IsDefined( vehicle.currentnode.target ) && ! IsDefined( vehicle.detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		targetnode = GetVehicleNode( vehicle.currentnode.target, "targetname" );
		if ( !IsDefined( targetnode ) )
			continue;
		if ( IsDefined( targetnode.detoured ) )
			return false;
	}

	// starts a map with a header and a blank worldspawn
	fileprint_launcher_start_file();
	
	fileprint_map_start();

	if ( !IsDefined( level.start_dump_index ) )
		level.start_dump_index = 0;
		
	foreach ( vehicle in spawned_vehicles )
	{
		if ( vehicle ishelicopter() )
			continue;// no helicopters in quickstarts yet.  I'm too scared of them. I should be able to use some sort of Vehicle_SetSpeed immediate but they won't be as close to accurate I don't think.

		if ( ! IsDefined( vehicle.currentnode.target ) && ! IsDefined( vehicle.detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.

		level.start_dump_index++;
		target = "dumpstart_node_target_" + level.start_dump_index;

		// vectors print as( 0, 0, 0 ) where they need to be converted to "0 0 0" for radiant to know what's up
		origin = fileprint_radiant_vec( vehicle.origin + ( 0, 0, 64 ) );
		

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "spawnflags", "1" );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", "dumpstart_node" );
			fileprint_map_keypairprint( "_color", "0.686275 0.847059 0.847059" );
			fileprint_map_keypairprint( "target", target );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			fileprint_map_keypairprint( "model", vehicle.model );
			if( IsDefined( vehicle.angles ) )
				fileprint_map_keypairprint( "angles", fileprint_radiant_vec( vehicle.angles ) );
			if ( IsDefined( vehicle.ghettotags ) )
				fileprint_map_keypairprint( "script_ghettotag", "1" );
			// other origin here is the origin of the spawner this vehicle came vrom.
			fileprint_map_keypairprint( "script_origin_other",fileprint_radiant_vec( vehicle.vehicle_spawner.origin ) );
			fileprint_map_keypairprint( "lookahead", ".2" );
			fileprint_map_keypairprint( "speed", vehicle.speedmph );
			fileprint_map_keypairprint( "script_noteworthy", startname );
		fileprint_map_entity_end();

		// project a node towards the next node in the chain for an onramp
		if ( IsDefined( vehicle.detouringpath ) )
			nextnode = vehicle.detouringpath;
		else
			nextnode = GetVehicleNode( vehicle.currentnode.target, "targetname" );
		origin = vehicle.origin;
		vect = VectorNormalize( nextnode.origin - origin );
		nextorigin = origin + ( vect * ( Distance( origin, nextnode.origin ) / 5 ) );

		origin = fileprint_radiant_vec( nextorigin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", target );
			fileprint_map_keypairprint( "_color", "0.686275 0.847059 0.847059" );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			
			// other origin here is the origin of the node we're targeting.
			fileprint_map_keypairprint( "script_origin_other", fileprint_radiant_vec( nextnode.origin ));
			
			fileprint_map_keypairprint( "script_noteworthy", nextnode.targetname );
		fileprint_map_entity_end();

	}
	fileprint_launcher_end_file( "/map_source/prefabs/westminster/_dumpstart_" + startname + ".map", true );
#/
	IPrintLnBold( "start: " + startname + " dumped!" );
	return true;
}

get_vehicles_with_spawners()
{
	vehicles = Vehicle_GetArray();
	spawned_vehicles = [];
	foreach ( vehicle in vehicles )
		spawned_vehicles = vehicle get_vehicles_with_spawners_single( spawned_vehicles );
	return spawned_vehicles;
}

get_vehicles_with_spawners_single( spawned_vehicles )
{
	if ( IsSpawner( self ) )
		return spawned_vehicles;
	if ( !IsDefined( self.currentnode ) )
		return spawned_vehicles;
	if ( !IsDefined( self.vehicle_spawner ) )
		return spawned_vehicles;
	spawned_vehicles[ spawned_vehicles.size ]  = self;
	return spawned_vehicles;
}

get_closest_exploder( org, array, maxdist )
{
	if ( !IsDefined( maxdist ) )
		maxdist = 500000; // twice the size of the grid

	ent = undefined;
	foreach ( item in array )
	{
		newdist = Distance( item.v["origin"], org );
		if ( newdist >= maxdist )
			continue;
		maxdist = newdist;
		ent = item;
	}
	return ent;
}

train_get_targeting_train_node()
{
	if ( !IsDefined( self.targetname ) )
		return undefined;
		
	targeting_objects = GetVehicleNodeArray( self.targetname, "target" );
	foreach ( object in targeting_objects )
	{
		if ( object.script_noteworthy == "train_section" )
			return object;
	}
	return undefined;
}

train_engine_thread()
{
	self endon ( "death" );
	last_speed = self Vehicle_GetSpeed();
	while ( true )
	{
		wait 0.05;
		this_speed = self Vehicle_GetSpeed();
		
		
		if ( this_speed == last_speed )
			continue;
			
		last_speed = this_speed;
		train_re_stack();
	}
}

train_re_stack()
{
	lead_train = self;
	foreach ( train in self.trains )
	{
		train.stacked = false;
		train thread train_stackup_thread( lead_train );
		lead_train = train;
	}
}

MAX_TRAIN_DIST_SQRD = 799236; //894*894
MIN_TRAIN_DIST_SQRD = 788544; //888*888
OFFSET_TRAIN_SPEED = 22;
ACCELL_DECELL = 40;
POLL_TIME = 0.05;

train_stackup_thread( lead_train )
{
	if( flag( "riding_train_already" ) )
	{
		if( self Vehicle_GetSpeed() == lead_train Vehicle_GetSpeed() )
		{
			self.stacked = true;
			return;
		}
	}
		
	lead_train endon ( "death" );
	lead_train endon ( "reached_end_node" );
	self endon ( "death" );
	self notify ( "train_stackup_thread" );
	self endon ( "train_stackup_thread" );
	
	this_speed = lead_train Vehicle_GetSpeed();
	
	self Vehicle_SetSpeedImmediate( this_speed, ACCELL_DECELL, ACCELL_DECELL );
	
	while ( true )
	{
		dstsqrd = DistanceSquared( self.origin, lead_train.origin );
		while ( this_speed > 5 && dstsqrd < MIN_TRAIN_DIST_SQRD )
		{
			if( this_speed < OFFSET_TRAIN_SPEED )
				this_speed = OFFSET_TRAIN_SPEED;
				
			self Vehicle_SetSpeed( this_speed - OFFSET_TRAIN_SPEED, ACCELL_DECELL, ACCELL_DECELL );
			wait POLL_TIME;
			dstsqrd = DistanceSquared( self.origin, lead_train.origin );
			this_speed = lead_train Vehicle_GetSpeed();
		}
		
		if ( train_section_in_range( dstsqrd, lead_train ) )
			break;
		

		while ( dstsqrd > MAX_TRAIN_DIST_SQRD )
		{
			self Vehicle_SetSpeed( this_speed + OFFSET_TRAIN_SPEED, ACCELL_DECELL, ACCELL_DECELL );
			wait POLL_TIME;
			dstsqrd = DistanceSquared( self.origin, lead_train.origin );
			this_speed = lead_train Vehicle_GetSpeed();
		}

		if ( train_section_in_range( dstsqrd, lead_train ) )
			break;
		
		wait POLL_TIME;
				
		if ( train_section_in_range( dstsqrd, lead_train ) )
			break;
	}

	this_speed = lead_train Vehicle_GetSpeed();
	self Vehicle_SetSpeedImmediate( this_speed, ACCELL_DECELL, ACCELL_DECELL );
	
	if( !lead_train.stacked )
	{
		wait 0.05;
		thread train_stackup_thread( lead_train );
		return;
		
	}
	self.stacked = true;
}

train_section_in_range( dstsqrd, lead_train )
{
	return ( dstsqrd > MIN_TRAIN_DIST_SQRD && dstsqrd < MAX_TRAIN_DIST_SQRD && lead_train.stacked );
}

CATCHUP_SPEED_MAX = 40;
CATCHUP_SPEED_BLENDINTIME = 9000;
CATCHUP_SPEED_MIN = 1;
FALL_BACK_SPEED_MAX = 3;
FALL_BACK_SPEED_MIN = 1;
CATCHUP_MIN_DIST = 140;
CATCHUP_MAX_DIST = 600;
FALL_BACK_MIN_DIST = 10;
FALL_BACK_MAX_DIST = 100;

get_catchup_speed( dist )
{
	range = CATCHUP_MAX_DIST - CATCHUP_MIN_DIST;
	dist_fraction = ( dist - CATCHUP_MIN_DIST ) / range;
	dist_fraction = clamp( dist_fraction, 0.01, 1 );
	speed_range = CATCHUP_SPEED_MAX - CATCHUP_SPEED_MIN;
	
	catchup_time_fraction = ( gettime() - self.start_match_position_of_target_vehicle_time ) / CATCHUP_SPEED_BLENDINTIME;
	catchup_time_fraction = clamp( catchup_time_fraction, 0.01, 1 );
	
	speed_range *= catchup_time_fraction;
	
	catchup_speed = CATCHUP_SPEED_MIN + ( speed_range * dist_fraction );
	return catchup_speed;
}

match_position_of_target_vehicle( target_car, offset_distance, in_range_func )
{
	if( !isdefined( offset_distance ) )
		offset_distance = 0;
	
	self notify ( "match_position_of_target_vehicle" );
	self endon ( "match_position_of_target_vehicle" );
	self endon ( "death" );

	speed_to_go = 45;
	fall_back_speed = FALL_BACK_SPEED_MAX;
	
	last_out_of_range_time = GetTime();
	self.start_match_position_of_target_vehicle_time = gettime();
	
	while ( 1 )
	{
		wait 0.05;
		origin = target_car GetTagOrigin( "tag_body" );
		angles = target_car GetTagAngles( "tag_body" );
		
		target_car_speed = target_car Vehicle_GetSpeed();
		
		origin2 = self GetTagOrigin( "tag_body" );
		
		dot = get_dot( origin, angles, origin2 );

		dist = Distance( origin, origin2 );
		
		if ( dist > 50 )
			last_out_of_range_time = GetTime();
		
		// consider it out of range at low speed. can get way out of sync
		if( target_car_speed < 30 )
			last_out_of_range_time = GetTime();
			
			
		self.needs_to_take_detours = undefined;

		
		if ( dot > 0 )
		{
			speed_to_go = target_car_speed;
			
			if ( dist > 30 )
			{
				speed_to_go = target_car_speed - 5;
			}
		}
		else if ( dot < 0 )
		{
			//wait a bit for things to really line up
			if ( dist < 10 )
			{
				self ResumeSpeed( 550 );
			}
			else if ( dist < 86  )
			{
				self ResumeSpeed( 11 );
			}
			else
			{
				speed_to_go = target_car_speed + get_catchup_speed( dist );
				if( dist > 1900 )
				{
					self.needs_to_take_detours = true;
				}
			}
		}
		
		if ( GetTime() - last_out_of_range_time > 6000 )
		{
			self ResumeSpeed( 550 );
			return;
		}
		
		speed_to_go = clamp( speed_to_go, 5, 95 );
		self Vehicle_SetSpeed( speed_to_go, 25, 25 );
		
	}
}


pillar_think()
{
	endmsg = "pillar_flag" + self.pillar_flag ;
	level endon ( endmsg );
	waittillframeend;
	flag_wait( self.pillar_flag );
	exploder( self.script_exploder );
	level notify ( endmsg );
}

setup_pillar_exploders()
{
	collumn_explosion = getfxarraybyid( "collumn_explosion" );
	collumn_explosion_dense = getfxarraybyid( "collumn_explosion_dense" );
	
	collumn_explosion = array_combine( collumn_explosion, collumn_explosion_dense );
	
	tunnel_crash_pillars = GetEntArray( "tunnel_crash_pillar" , "script_noteworthy" );
	
	level.pillar_exploders = [];
	foreach( pillar in tunnel_crash_pillars )
	{
		xPloder = get_closest_exploder( pillar.origin, collumn_explosion, 100 );
		if( !isdefined( xPloder ) )
			continue;
		struct = SpawnStruct();
		struct.pillar_flag = xPloder.v[ "flag" ];
		struct.script_exploder = pillar.script_exploder;
		level.pillar_exploders = array_add( level.pillar_exploders, struct );
	}
}

guy_runs_into_train( current_spot )
{
	level endon ( "stop_guys_trickle_into_train" );
	self.ignoreSuppression = true;
	self.dontavoidplayer = true;
	self.takedamage = false;
	self.suppressionwait = 0;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.maxfaceenemydist = 32;
	self.ignoreExplosionEvents = true;
	self disable_surprise();
	self.grenadeawareness = 0;
	self.IgnoreRandomBulletDamage = true;
	self.disablebulletwhizbyreaction = true;
	self.fixednode = true;
	self set_goal_node( current_spot );
	self set_goal_radius( 32 );
	self enable_sprint();
	//thread draw_line_from_ent_to_ent_until_notify( self, current_spot, 0, 0, 1, self, "goal" );
	self endon ( "death" );
	self waittill ( "goal" );
	self linkto_nearest_train();
}

linkto_nearest_train()
{
	script_vehicle_subway_cart_destructibles = GetEntArray( "script_vehicle_subway_cart_destructible", "classname" );
	
	live_carts = [];
	foreach ( cart in script_vehicle_subway_cart_destructibles )
	{
		if ( IsSpawner( cart ) )
			continue;
		live_carts = array_add( live_carts, cart );
	}
	
	the_cart = getClosest( self.origin, live_carts );
	
	self LinkTo( the_cart );
	self.onTrain = true;
	guy_get_on_train( self, the_cart );
}
   
setup_subway_cart_enemy()
{
	self StartUsingHeroOnlyLighting();
	self AllowedStances( "stand", "crouch" );
}


get_player_spot( player_truck )
{
	foreach ( junk in player_truck.truckjunk )
		if ( IsDefined( junk.script_noteworthy ) && junk.script_noteworthy == "player_spot" )
		{
			junk HidePart( "TAG_RAIL" );
			junk NotSolid();
			return junk;
		}
			
	AssertMsg( "no player spot!" );
}


get_friend_spot( player_truck )
{
	foreach ( junk in player_truck.truckjunk )
		if ( IsDefined( junk.script_noteworthy ) && junk.script_noteworthy == "animate_truck" )
			return junk;
			
	AssertMsg( "no friend spot!" );
}

get_vehicle_headlight( player_truck )
{
	if( !isdefined( player_truck.truckjunk ) )
		return;
	foreach ( junk in player_truck.truckjunk )
	{
		if ( IsDefined( junk.script_noteworthy ) && junk.script_noteworthy == "headlight" )
		{
			junk Hide();
			junk SetModel( "tag_origin" );
			return junk;
		}
	}
}

get_the_bastard_off_the_vehicle()
{
	self.ridingvehicle = undefined;
	self.vehicle_idle = undefined;
	self notify ( "newanim" );
	self Unlink();
	self StopAnimScripted();
	
}

reset_old_values()
{
	guy = self;   
	if( isdefined( guy.old_pathenemyfightdist ) )
		guy.pathenemyfightdist =	guy.old_pathenemyfightdist;
	if( isdefined( guy.old_pathenemylookahead ) )
		guy.pathenemylookahead =	guy.old_pathenemylookahead;
	if( isdefined( guy.old_maxfaceenemydist ) )
		guy.maxfaceenemydist =	  guy.old_maxfaceenemydist;
		
}

cleanup_post_ride()
{
	if ( IsDefined( level.sas_leader ) )
	   level.sas_leader reset_old_values();
	level.sas_leader.dontmelee = undefined;
}

fix_up_guys_left_behind()
{
	level notify ( "stop_guys_trickle_into_train" );
	guys = get_living_ai_array( "subway_enemy", "script_noteworthy" );

	if ( IsDefined( level.docks_enemy_ai ) )
	{
		guys = array_combine( guys, level.docks_enemy_ai );
	}

	touching_trigger = GetEnt( "on_train_trigger", "targetname" );
	runaway_nodes = GetNodeArray( "runaway_nodes", "targetname" );
	
	foreach ( guy in guys )
	{
		if ( isdefined( guy.onTrain ) && guy.onTrain )
			continue;
		guy.baseaccuracy = 0.1;
		guy.accuracy = 0.1;
		guy enable_sprint();
		if ( guy IsTouching( touching_trigger ) )
			guy linkto_nearest_train();
		else
		{
			guy.badplaceawareness = 0;
			guy.attackeraccuracy = 1;
			guy.health = int( min( 75, guy.health ) );
			guy set_ignoreall( true );
			guy.fixednode = false;
			guy set_ignoreme( true );
			guy set_goal_radius( 32 );
			
			guy thread restore_when_get_to_goal();
			select_node = runaway_nodes[ RandomInt( runaway_nodes.size ) ];
			guy set_goal_node( select_node );
		}
	}
}

restore_when_get_to_goal()
{
	self waittill ( "goal" );
	self Delete();
}

aggressively_load_ai( vehicle_load_ai )
{
	foreach( guy in vehicle_load_ai )
	{
		guy.attackeraccuracy = 0;
		guy.fixednode = true;
		guy.accuracy = 1;
		guy set_ignoresuppression( true );
		guy enable_sprint();
		guy.grenadeawareness = 0;
		guy.disablebulletwhizbyreaction = true;
		guy.takedamage = false;
		guy.suppressionwait = 0;
		guy.ignoreExplosionEvents = true;
		guy.ignoreSuppression = true;
		guy PushPlayer( true );
		guy disable_pain();
		guy disable_surprise();
		guy.a.disableLongDeath = true;
		guy.disablefriendlyfirereaction = true;
		guy.dontmelee = true;
		guy.old_pathenemyfightdist = guy.pathenemyfightdist;
		guy.old_pathenemylookahead = guy.pathenemylookahead;
		guy.old_maxfaceenemydist = guy.maxfaceenemydist;
		guy.pathenemyfightdist = 0;
		guy.pathenemylookahead = 0;
		guy.maxfaceenemydist = 32;
		guy.disableReactionAnims = true;
		
	}
	
	self thread vehicle_load_ai( vehicle_load_ai );
}

friendly_gunner_behavior_on_enter()
{
	self waittill ( "enteredvehicle" );
	self reset_old_values();
	thread friendly_gunner_behavior();
}

friendly_gunner_behavior()
{
	self AllowedStances( "crouch" );
	self.fixednode = true;
	self.attackeraccuracy = 0;
	self.IgnoreRandomBulletDamage = true;
	self.ignoreExplosionEvents = false;
	self.ignoreSuppression = true;
	self set_ignoreall( false );
	
	self forceUseWeapon( "mp5", "primary" );
	//self thread orient_to_player();
	
	
	
}


get_vehicle_spawner_by_origin( origin )
{
	vehicles = GetEntArray( "script_vehicle", "code_classname" );
	foreach ( vehicle in vehicles )
		if ( IsSpawner( vehicle ) )
			if ( vehicle.origin == origin )
				return vehicle;
	
	AssertMsg( "Tried to get a vehicle by an origin that doesn't exist there, " + origin );
	return;
}

get_vehicle_node_by_origin( origin )
{
	vehicle_nodes = GetAllVehicleNodes();
	foreach ( node in vehicle_nodes )
		if ( node.origin == origin )
			return node;
	AssertMsg( "Tried to get a vehicle node by an origin that doesn't exist there, " + origin );
	return;
}

get_triggerer_from_ghost( other )
{
	if( isdefined( level.friend_truck_ghost ) )
		if( other == level.friend_truck_ghost )
			other = level.friend_truck;
	
	if( isdefined( level.friend_truck ) )	 
		if( other == level.player_truck_ghost )
			other = level.player_truck;

	return other;
}

veh_node_player_truck_spot_onthink( other )
{
	if( Distance( other.origin , self.origin ) > 1000 )
	{
		add_trigger_function( ::veh_node_player_truck_spot_onthink );
		return;
	}

	other = get_triggerer_from_ghost( other );
	other turn_on_my_spotlight();
}

turn_on_my_spotlight()
{
	head_light = get_vehicle_headlight( self );
	if ( !IsDefined( head_light ) )
		return;
		
	if( self.classname == "script_vehicle_subway_engine_destructible" ) 
		head_light spot_light( "spotlight_train", "spotlight_train_cheap", "tag_origin", self );
	else
		head_light spot_light( "spotlight_truck_player", "spotlight_truck_player_cheap", "tag_origin", self );
}

// only ever used in a start point 
start_train_mid()
{
	veh_nodes = GetVehicleNodeArray( "dumpstart_node", "targetname" );
	
	start_up_vehicles = [];
	node_array = [];
	foreach ( node in veh_nodes )
	{
		if ( !IsDefined( node.script_noteworthy ) )
			continue;
		if ( node.script_noteworthy != level.start_point )
			continue;
			
		vehicle_spawner = get_vehicle_spawner_by_origin( node.script_origin_other );
		vehicle_spawner.origin = node.origin;
		vehicle_spawner.angles = node.angles;
		
		//ghost cars go first, that way I can use their positions for the player and the friendly truck.
		if ( IsSubStr( vehicle_spawner.targetname, "_ghost" ) )
		{
			start_up_vehicles = array_insert( start_up_vehicles, vehicle_spawner, 0 );
			node_array = array_insert( node_array, node, 0 );
		}
		else
		{
			start_up_vehicles = array_add( start_up_vehicles, vehicle_spawner );
			node_array = array_add( node_array, node );
		}
	}
	for ( i = 0; i < node_array.size; i++ )
		do_start_setup( start_up_vehicles[ i ] , node_array[ i ] );
		
	set_ambient( "london_tube" );
}


do_start_setup( vehicle_spawner, node )
{
	vehicle_spawner.dontgetonpath = true;

	//retargets the original spawner to the new nodes.. For player car and friendly car this is set to be exactly where the ghost car is.. 
	//Ghost trucks are meant to be the perfect Ideal alignment though I may never line that up %100
	target = node.targetname;
	if ( IsDefined( vehicle_spawner.targetname ) )
	{
		switch( vehicle_spawner.targetname )
		{
			case "friend_truck":
				if ( IsDefined( level.friend_truck_ghost ) )
					node = level.friend_truck_ghost.vehicle_spawner.target_node;
				break;
			case "player_truck":
				if ( IsDefined( level.player_truck_ghost ) )
					node = level.player_truck_ghost.vehicle_spawner.target_node;
				break;
			default:
				break;
		}
	}
	
	vehicle_spawner.target_node = node;
	vehicle = vehicle_spawn( vehicle_spawner );
	
	//TODO: Ghost car position should be the players car position. maybe make exporter lie or fix here.
	if ( IsDefined( vehicle_spawner.targetname ) )
	{
		switch( vehicle_spawner.targetname )
		{
			case "friend_truck":
				//hides it.
				head_light = get_vehicle_headlight( vehicle );
				level.friend_truck = vehicle;
				break;
			case "friend_truck_ghost":
				vehicle Hide();
				level.friend_truck_ghost = vehicle;
				
				break;
			case "player_truck":
				level.player_truck = vehicle;
				vehicle delaythread ( 0.05, ::turn_on_my_spotlight );
				break;
			case "player_truck_ghost":
				vehicle Hide();
				level.player_truck_ghost = vehicle;
				break;
			default:
				break;
		}
	}
	
	next_node = GetVehicleNode( node.target, "targetname" );
	target_node = get_vehicle_node_by_origin( next_node.script_origin_other );
  
	vehicle.attachedpath = node;
	vehicle AttachPath( node );
	vehicle thread gopath();
	
	vehicle vehicle_switch_paths( next_node, target_node );
}

script_vehicle_subway_engine_destructible_think()
{
	//hides it.
	head_light = get_vehicle_headlight( self );
	handle_junk_paramters();
}

handle_junk_paramters()
{
	if( !isdefined( self.truckjunk ) )
		return;
		
	foreach( junk in self.truckjunk )
	{
		if( junk.model == "axis" )
			junk Hide();
		 junk_handle_junk_paramaters( junk );
	}
}

fast_truck_load( flag, driver_window, truck )
{
	flag_count_increment( flag );
	
	self waittillmatch( "animontagdone", "window_break" );
	

	if( driver_window )
		truck break_window( "tag_glass_right_front" );
	else
	   truck break_window( "tag_glass_left_front" );

	self waittillmatch( "animontagdone", "door_open" );
	if( driver_window )
		truck thread play_sound_on_tag( "uk_utility_door_open", "tag_glass_right_front" );
	else
		truck thread play_sound_on_tag( "uk_utility_door_open", "tag_glass_left_front" );

	self waittillmatch( "animontagdone", "door_close" );
	
	if( self == level.sas_leader )
	{
		truck delaythread( 0.5 , ::play_sound_on_tag, "scn_london_utility_truck_startup", "TAG_DRIVER" );
		truck delaycall( 1, ::Vehicle_TurnEngineOn );
	}
	
	if( driver_window )
		truck thread play_sound_on_tag( "uk_utility_door_close", "tag_glass_right_front" );
	else
		truck thread play_sound_on_tag( "uk_utility_door_close", "tag_glass_left_front" );
			   
	flag_count_decrement( flag );
}

manage_players_attacker_accuracy()
{
	level.last_subway_shotat_time = gettime();
	
	level endon ( "stop_manage_players_attacker_accuracy" );
	while( 1 )
	{
		time_since_last_player_participated = gettime() - level.last_subway_shotat_time;
		player_target_accuracy = level.player.attackeraccuracy;
		do_favorite_enemy_thing = false;
		if( time_since_last_player_participated > 6000 )
		{
			player_target_accuracy = 1;
			do_favorite_enemy_thing = true;
		}
		else if( time_since_last_player_participated > 4000 )
		{
			player_target_accuracy = 0.6;
			do_favorite_enemy_thing = true;			
		}
		else if( time_since_last_player_participated > 2500 )
		{
			player_target_accuracy = 0.4;
			do_favorite_enemy_thing = true;			
		}
		else if( time_since_last_player_participated > 1000 )
		{
			player_target_accuracy = 0.3;
		}
		
		if ( level.player.IsReloading )
		{
			player_target_accuracy *= 0.5;
			player_target_accuracy = clamp( player_target_accuracy, 0.1, 1 );
		}
		
		level.player.attackeraccuracy = player_target_accuracy;
		if( do_favorite_enemy_thing )
			array_thread( getaiarray( "axis" ), ::set_favoriteenemy, level.player );

		
		wait 0.05;
	}
}

init_damage_trigger_pool()
{
	level.train_guy_damagers = GetEntArray( "train_guy_damager" , "targetname" );
	foreach ( trigger in level.train_guy_damagers )
	{
		trigger.org_org = trigger.origin;
		trigger thread tunnel_damager_think();
	}
}

ai_gets_damage_trigger()
{
	trigger = level.train_guy_damagers[0];
	level.train_guy_damagers = array_remove( level.train_guy_damagers, trigger );
	
	trigger.origin = self.origin;
	trigger.assigned_guy = self;
	
	trigger thread manual_linkto( self );

	self waittill ( "death" );

	level.train_guy_damagers = array_add( level.train_guy_damagers, trigger );
	trigger.origin = trigger.org_org;
}

train_event_node()
{
	self waittill( "trigger" );

	train = level.lead_engine_train;

	// 0 is the 2nd to lead car, 2 is the rear car
	if ( IsDefined( self.script_index ) )
	{
		train = train.trains[ self.script_index ];
	}

	switch ( self.script_noteworthy )
	{
		case "switch_door_guys":
			train train_switch_door_guys();
			break;
	}
}

train_switch_door_guys()
{
	foreach ( guy in self.riding_guys )
	{
		if ( IsDefined( guy.is_door_guy ) )
		{
			if ( guy.side == "left" )
			{
				guy.side = "right";
			}
			else
			{
				guy.side = "left";
			}

			train_door_guy( guy, self, guy.side, guy.tag_num );
		}
	}
}

train_spawn_group()
{
	self waittill ( "trigger" );
	
	train = level.lead_engine_train;
	guys_count = 4;
	delete_guys = true;
	train_guys_at_end = false;
	door_guy = false;
	side = undefined;
	delete_door_guys = false;
	
	if ( self.script_noteworthy == "spawn_train_door_guys" )
	{
		if ( !IsDefined( self.script_count ) )
		{
			guys_count = 1;
		}

		door_guy = true;
		side = self.script_side;
	}

	if ( IsDefined( self.script_count ) )
	{
		guys_count = self.script_count;
	}

	if ( IsDefined( self.script_delete ) )
	{
		delete_guys = self.script_delete;
	}

	// 0 is the 2nd to lead car, 2 is the rear car
	if ( IsDefined( self.script_index ) )
	{
		train = train.trains[ self.script_index ];
	}

	if ( IsDefined( self.script_parameters ) )
	{
		switch ( self.script_parameters )
		{
			case "end":
				train_guys_at_end = true;
				break;
			case "delete_door_guys":
				delete_door_guys = true;
				break;
		}
	}
	
	spawner_array = [];
	foreach( junk in train.truckjunk )
	{
		if( !IsDefined( junk.spawner ) )
			continue;
			
		if( !door_guy && IsDefined( junk.script_parameters ) ) 
		{
			if( junk.script_parameters == "door_opener" )
			{
				continue;
			}
		}
		
		spawner_array[ spawner_array.size ] = junk;
	}	
	
	spawner_array = array_randomize( spawner_array );
	
	if ( !IsDefined( train.riding_guys ) )
	{
		train.riding_guys = [];
	}
	
	if( delete_guys )
	{
		if ( IsDefined( train.riding_guys ) )
		{
			array_delete( train.riding_guys );
		}

		train.riding_guys = [];
	}

	if ( delete_door_guys )
	{
		foreach ( guy in train.riding_guys )
		{
			if ( IsDefined( guy.is_door_guy ) )
			{
				guy Delete();
			}
		}

		if ( !IsDefined( train.riding_guys ) )
		{
			train.riding_guys = [];
		}
	}

	if( train_guys_at_end )
	{
		new_array = [];
		
		foreach( junk in spawner_array )
		{
			if( !isdefined( junk.script_parameters ) )
			{
				continue;
			}

			if( junk.script_parameters != "front_guy_for_end" )
			{
				continue;
			}
			new_array[ new_array.size ] = junk;	
		}

		spawner_array = new_array;

	}

	if( door_guy )
	{
		foreach( junk in spawner_array )
		{
			if( !isdefined( junk.script_parameters ) )
			{
				continue;
			}

			if( junk.script_parameters != "door_opener" )
			{
				continue;
			}

			tags = [];
			count = undefined;

			// Sets the front or back tag to use.
			if ( IsDefined( self.script_startingposition ) )
			{
				tags[ tags.size ] = self.script_startingposition;
				count = 1;
			}
			else
			{
				tags[ tags.size ] = 1;
				tags[ tags.size ] = 2;

				tags = array_randomize( tags );
				count = Clamp( guys_count, 1, 2 );
			}

			guys_count -= count;

			for( i = 0; i < count; i++ )
			{
				junk.spawner.origin = junk.origin;
				junk.spawner.count = 1;
				guy = junk.spawner StalingradSpawn();
				
				//spawn failed takes care of guys spawning inside of eachother.
				if( spawn_failed( guy ) )
				{
					continue;
				}
		
				train_door_guy( guy, train, side, tags[ i ] );
				guy_on_train_init( guy, train );

				if ( count - i > 1 )
				{
					wait( 0.05 );
				}
			}
		}
	}


	foreach( junk in spawner_array )
	{
		if( train.riding_guys.size >= guys_count )
		{
			return;
		}
			
		junk.spawner.origin = junk.origin;
		junk.spawner.count = 1;
		guy = junk.spawner StalingradSpawn();
		
		//spawn failed takes care of guys spawning inside of eachother.
		if( spawn_failed( guy ) )
		{
			continue;
		}
		
		thread train_spawn_guy_intro( train, guy, junk ,train_guys_at_end );
	}	   
}

train_door_guy( guy, train, side, tag_num )
{
	guy.side = side;
	guy.is_door_guy = true;
	guy.tag_num = tag_num;

	if ( side == "right" )
	{
		side_abv = "RI";
	}
	else
	{
		side_abv = "LE";
	}

	tag = "TAG_DOOR_" + tag_num + "_" + side_abv;

	train thread vehicle_scripts\_subway::do_door_guy( tag, guy );
}

train_spawn_guy_intro( train, guy, junk, train_guys_at_end )
{
	guy.train_intro = true;
	train relink_junk( junk );
	guy.junk_linked = junk;

	linktrain = train;
	if ( IsDefined( train.modeldummy ) )
		linktrain = train.modeldummy;
	newjunk = spawn_tag_origin();
	newjunk linkto( linktrain,  junk.script_ghettotag, junk.base_origin, combineangles( junk.base_angles, ( 0,180,0 ) ) );
	guy LinkTo( newjunk, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	thread guy_get_on_train( guy, train );
	if( isdefined( junk.script_parameters ) )
		train thread guy_handle_junk_paramaters( guy, junk );
		
	if( !train_guys_at_end )
		newjunk anim_generic( guy, "crouch2stand" );
	train relink_junk( junk );
	if ( IsAlive( guy ) )
		guy guy_junk_link( guy.junk_linked );
	guy.train_intro = undefined;
	wait 1;
	newjunk Delete();

}

relink_junk( junk )
{
	model = self;
	if ( IsDefined( self.modeldummy ) )
		model = self.modeldummy;
	junk linkto( model, junk.script_ghettotag, junk.base_origin, junk.base_angles );
}

#using_animtree( "vehicles" );

junk_handle_junk_paramaters( junk )
{
	if ( !IsDefined( junk.script_parameters ) )
		return;
	switch( junk.script_parameters  )
	{
		case "lights_off_version":
			
			self.mirror_destructible_model = junk;
			junk useanimtree( #animtree );
			junk hide();
			junk NotSolid();
			break;
		case "hero_light":
			junk StartUsingHeroOnlyLighting();
			break;
		case "blood":
			junk StartUsingHeroOnlyLighting();
			if ( !IsDefined( self.blood_models ) )
				self.blood_models = [ junk ];
			else
				self.blood_models = array_add( self.blood_models, junk );
				junk Hide();
			break;
		default:
			break;
			
	}  
}
	
guy_handle_junk_paramaters( guy,junk )
{
	switch( junk.script_parameters  )
	{
		case "runner":
			thread guy_runs_in_train( guy,junk );
			break;
		case "hero_light":
			guy StartUsingHeroOnlyLighting();
			break;
		default:
			break;
			
	}
}

guy_runs_in_train( guy, junk )
{
	guy endon ( "death" );
	wait RandomFloatRange( 3.0, 6.0 );
	while ( !guy_should_run( guy ) )
		wait 0.05;
	select_anim_name =  random( [ "run_lowready_reload", "run_n_gun_l_120", "run_n_gun_l", "heat_run_loop" ] );
	select_anim = getanim_generic( select_anim_name );
	time = GetAnimLength( select_anim );
	delta = GetMoveDelta( select_anim, 0, 1 );
	time = GetAnimLength( select_anim );
	angledelta = GetAngleDelta( select_anim, 0, 1 );
	guy delaythread( 0.1, ::set_allowdeath , true );
	junk anim_generic( guy, select_anim_name );
	junk linkto( self , junk.script_ghettotag, junk.base_origin + delta, (0,0,0));
}

guy_gets_on_new_node( guy )
{
	new_node = spawn_tag_origin();
	new_node.origin = guy.origin;
	new_node linkto( self );
	guy LinkTo( new_node, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	guy waittill ( "death" );
	new_node delete();	
}

guy_should_run( guy )
{
	if ( IsDefined( guy.train_intro ) )
		return false;
	if ( DistanceSquared( guy.origin, level.player.origin ) > 1000000 )
		return false;
	if( ( gettime() - guy.lastenemysighttime ) > 3000 )
		return false;
	return true;	
}

guy_get_on_train( guy, train )
{
	guy thread death_on_train();
	guy.deathanim = getanim_generic( "death_in_place" );
	guy.maxsightdistsqrd = 4000000; //2000*2000

	guy thread orient_to_player();
	guy_on_train_init( guy, train );
}

guy_on_train_init( guy, train )
{
	train thread train_spawned_guys_remove_on_death( guy );
	guy.riding_train = train;
	add_cleanup_ent( guy, "guys_on_train" );
	guy thread ai_gets_damage_trigger();
	guy add_damage_function( ::guy_takes_bloody_damage );
	guy.dropweapon = false;
}

guy_takes_bloody_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	tag = spawn_tag_origin();
	tag.origin = point;
	tag.angles = VectorToAngles( direction_vec );
	
	if( isdefined(  self.riding_train  ) )
		tag LinkTo( self.riding_train ) ;
	
	PlayFXOnTag( getfx( "subway_cart_guy_damage") , tag, "tag_origin" );
	
	if( cointoss() )
		do_blood_on_guys_train();
	
	wait 3;

	tag delete();
}


do_blood_on_guys_train()
{
	if ( !IsAlive( self ) )
		return;
	if( !isdefined( self.riding_train.blood_models ) )
		return;
	blood_object = getClosest( self.origin, self.riding_train.blood_models  , 330 );
	if( !IsDefined( blood_object ) )
		return;
	
	self.riding_train.blood_models = array_remove( self.riding_train.blood_models, blood_object );
	blood_object Show();
}
	
orient_to_enemy()
{
	self endon ( "death" );
	self endon ( "stop_orient_to_player" );
	
	while ( true )
	{
		if ( IsDefined( self.enemy ) )
			self OrientMode( "face point", self.enemy GetEye() );
		wait 0.05;
	}
}

orient_to_ent_point( ent )
{
	ent endon ( "death" );
	self endon ( "death" );
	self endon ( "stop_orient_to_player" );
	
	while ( true )
	{
		self OrientMode( "face point",ent.origin );
		wait 0.05;
	}
}

orient_to_player()
{
	self endon ( "death" );
	self endon ( "stop_orient_to_player" );
	while ( true )
	{
		self orientmode( "face point", level.player geteye() );
		wait 0.05;
	}
}

train_spawned_guys_remove_on_death( guy )
{
	self endon ("death");
	if ( !IsDefined( self.riding_guys ) )
		self.riding_guys = [];
	self.riding_guys = array_add( self.riding_guys, guy );
	guy waittill ( "death" );
	self.riding_guys = array_remove( self.riding_guys, guy );
}

vehicle_node_car_crash_think()
{
	self waittill ("trigger");
	node = getstruct( "train_car_crash_234","targetname" );
	crash_car = spawn_anim_model( "train_intersect_car" );
	node anim_teleport_solo( crash_car, "intersection_crash" );
	node anim_single_solo( crash_car, "intersection_crash");
}

train_civilians_go_think()
{
	self waittill( "trigger" );

	thread train_civilians_sound();
	
	london_station_civs_think_basic( "london_station_civ1", 7000 );
	london_station_civs_think_basic( "london_station_civ2", 6000 );
	london_station_civs_think_basic( "london_station_civ3", 10000 );
	london_station_civs_think_basic( "london_station_civ4", 3000 );
	london_station_civs_think_basic( "london_station_civ5", 4500 );
	london_station_civs_think_basic( "london_station_civ6", 5000 );
	london_station_civs_think_basic( "london_station_civ7", 3000 );

	//put 8 down farther, it's a long reaction.
	london_station_civs_think_basic( "london_station_civ8", 15000 );
}

train_civilians_sound()
{
	thread train_civilians_sound_internal( "scn_walla_london_subway_scream_l", -400 );
	thread train_civilians_sound_internal( "scn_walla_london_subway_scream_r", 400 );
}

train_civilians_sound_internal( sound, x_offset )
{
	x = level.player.origin[ 0 ] + x_offset;
	y = 34000;
	z = 216;
	ent = Spawn( "script_origin", ( x, y, z ) );
	ent endon( "sound_done" );

	ent thread train_civilians_sound_update( x_offset, y, z );

	ent PlaySound( sound, "sound_done" );
	ent waittill( "sound_done" );
	ent Delete();
}

train_civilians_sound_update( x_offset, y, z )
{
	self endon( "death" );

	while ( self.origin[ 0 ] > 49416 )
	{
		wait( 0.05 );
		if ( level.player.origin[ 0 ] > 55856 )
		{
			x = 55856;
		}
		else
		{
			x = level.player.origin[ 0 ] + -50 + x_offset;
		}

		self.origin = ( x, y, z );
	}
}

london_station_civs_think_basic( anime, reaction_range )
{
	london_station_civs_think( anime, anime, reaction_range );
}

london_station_civs_think( anime, targetname, reaction_range )
{
	civs = getstructarray( targetname, "targetname" );
	array_thread( civs, ::london_station_civ_think, anime, targetname, reaction_range );
}


getspawner_from_drone_pool( targetname )
{
	pool = GetEntArray( targetname, "targetname" );
	array = [];
	foreach ( test in pool )
	{
		if ( ! IsSpawner( test ) )
			continue;
		test.count = 1;
		array[ array.size ]  = test;
	}
	return random( array );
}


london_station_civ_think( anime, targetname, reaction_range )
{
	spawner = self; 
	if( !IsSpawner( self ) )
		spawner = getspawner_from_drone_pool( "dronepool_station_civs" );
		
	guy = dronespawn( spawner );
	
	guy endon ( "death" );
	
	add_cleanup_ent( guy, "station_civs" );
   
	guy.animname = anime;
	if ( guy hasanim( "idle" ) )
		self thread anim_loop_solo( guy, "idle", "stop_" + anime );
	else if ( guy hasanim( "reaction" ) )
		self anim_first_frame_solo( guy, "reaction" );
	
	if ( ! guy hasanim( "reaction" ) )
		return;
	
	level.player waittill_in_range( self.origin, reaction_range + RandomIntRange( -1000, 1000 ), 0.05 );

	self notify ( "stop_" + anime );
	
	self anim_single_solo( guy, "reaction" );
}

tunnel_damager_think()
{
	while( true )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
		
		if( ! tunnel_damager_valid_attacker( attacker ) )
			continue;

		array_thread( GetAIArray( "axis" ), ::set_favoriteenemy );
			
		level.player.attackeraccuracy = 0.01;
		level.last_subway_shotat_time = gettime();
		
		if( ! IsAlive( self.assigned_guy ) )
			continue;
			
		if( !IsDefined( level.last_tunnel_damager_guy_time ) )
			level.last_tunnel_damager_guy_time = gettime();
			
		// keep from magically killing multiple guys at once
		if( gettime() - level.last_tunnel_damager_guy_time < 500 )
			continue;
			
		if( !isdefined( self.assigned_guy.tunnel_damager_count ) )
			self.assigned_guy.tunnel_damager_count = 0;
		self.assigned_guy.tunnel_damager_count++;
			
		if ( !flag("rocky_road" ) && IsAlive( self.assigned_guy ) && IsDefined( attacker ) && Distance( attacker.origin,  self.assigned_guy.origin ) < 1500 && self.assigned_guy.tunnel_damager_count > 3 )
		{
			self.assigned_guy.tunnel_damager_count = 0;
			tag = random( [ "J_Spine4", "J_Elbow_LE", "J_Hip_LE", "J_Clavicle_RI" ] );
			org = self.assigned_guy GetTagOrigin( tag );
			MagicBullet( "nosound_magicbullet", org + ( direction_vec * -20 ), org );
			level.last_tunnel_damager_guy_time = gettime();
		}
	}
}

tunnel_damager_valid_attacker( attacker )
{
	if ( attacker == level.player )
		return true;
//	if ( IsAI( attacker ) && attacker.team == "allies" )
//		return true;	
	return false;
}

open_doors()
{
	waittillframeend; // let the mirror_destructible_model be defined.
	anim_root = getanim_generic( "subway_doors_root" );
	animation = getanim_generic( "subway_doors_open" );
	animation2 = getanim_generic( "subway_doors_open2" );
	self ClearAnim( anim_root, 0 );
	self SetAnim( animation );
	self SetAnim( animation2 );
	assert( IsDefined( self.mirror_destructible_model ) );
	self.mirror_destructible_model ClearAnim( anim_root, 0 );
	self.mirror_destructible_model SetAnim( animation );
	self.mirror_destructible_model SetAnim( animation2 );
}

close_doors()
{
	waittillframeend; // let the mirror_destructible_model be defined.
	if ( IsSpawner( self ) )
		return;
	
	anim_root = getanim_generic( "subway_doors_root" );
	animation = getanim_generic( "subway_doors_close" );
	animation2 = getanim_generic( "subway_doors_close2" );
	
	self ClearAnim( anim_root, 0 );
	self SetAnim( animation );
	self SetAnim( animation2 );
	
	assert( IsDefined( self.mirror_destructible_model ) );
	
	self.mirror_destructible_model ClearAnim( anim_root, 0 );
	self.mirror_destructible_model SetAnim( animation );
	self.mirror_destructible_model SetAnim( animation2 );
	
	time = GetAnimLength( animation );
	wait time;
	self ClearAnim( anim_root, 0 );
	self.mirror_destructible_model ClearAnim( anim_root, 0 );
}

hide_train_windows()
{
	self HidePart( "TAG_WINDOW_SMALL_02_LE" );
	self HidePart( "TAG_WINDOW_SMALL_02_LE_D" );
	self HidePart( "TAG_WINDOW_SMALL_03_LE" );
	self HidePart( "TAG_WINDOW_SMALL_03_LE_D" );
	self HidePart( "TAG_WINDOW_SMALL_04_LE" );
	self HidePart( "TAG_WINDOW_SMALL_04_LE_D" );
	self HidePart( "TAG_WINDOW_SMALL_05_LE" );
	self HidePart( "TAG_WINDOW_SMALL_05_LE_D" );
	self HidePart( "TAG_WINDOW_SMALL_02_RI" );
	self HidePart( "TAG_WINDOW_SMALL_02_RI_D" );
	self HidePart( "TAG_WINDOW_SMALL_03_RI" );
	self HidePart( "TAG_WINDOW_SMALL_03_RI_D" );
	self HidePart( "TAG_WINDOW_SMALL_04_RI" );
	self HidePart( "TAG_WINDOW_SMALL_04_RI_D" );
	self HidePart( "TAG_WINDOW_SMALL_05_RI" );
	self HidePart( "TAG_WINDOW_SMALL_05_RI_D" );
	self HidePart( "TAG_FRONT_LIGHT_LE" );
	self HidePart( "TAG_FRONT_LIGHT_RI" );
	self HidePart( "TAG_FRONT_WINDOW" );
	self HidePart( "TAG_FRONT_WINDOW_D" );
	self HidePart( "TAG_INT_WINDOW_03_RI" );
	self HidePart( "TAG_WINDOW_011_LE" );
	self HidePart( "TAG_WINDOW_011_LE_D" );
	self HidePart( "TAG_WINDOW_011_RI" );
	self HidePart( "TAG_WINDOW_011_RI_D" );
	self HidePart( "TAG_WINDOW_012_LE" );
	self HidePart( "TAG_WINDOW_012_LE_D" );
	self HidePart( "TAG_WINDOW_012_RI" );
	self HidePart( "TAG_WINDOW_012_RI_D" );
	self HidePart( "TAG_WINDOW_014_LE" );
	self HidePart( "TAG_WINDOW_014_LE_D" );
	self HidePart( "TAG_WINDOW_014_RI" );
	self HidePart( "TAG_WINDOW_014_RI_D" );
	self HidePart( "TAG_WINDOW_01_LE" );
	self HidePart( "TAG_WINDOW_01_LE_D" );
	self HidePart( "TAG_WINDOW_01_RI" );
	self HidePart( "TAG_WINDOW_01_RI_D" );
	self HidePart( "TAG_WINDOW_03_LE" );
	self HidePart( "TAG_WINDOW_03_LE_D" );
	self HidePart( "TAG_WINDOW_03_RI" );
	self HidePart( "TAG_WINDOW_03_RI_D" );
	self HidePart( "TAG_WINDOW_04_LE" );
	self HidePart( "TAG_WINDOW_04_LE_D" );
	self HidePart( "TAG_WINDOW_04_RI" );
	self HidePart( "TAG_WINDOW_04_RI_D" );
	self HidePart( "TAG_WINDOW_07_LE" );
	self HidePart( "TAG_WINDOW_07_LE_D" );
	self HidePart( "TAG_WINDOW_07_RI" );
	self HidePart( "TAG_WINDOW_07_RI_D" );
	self HidePart( "TAG_WINDOW_08_LE" );
	self HidePart( "TAG_WINDOW_08_LE_D" );
	self HidePart( "TAG_WINDOW_08_RI" );
	self HidePart( "TAG_WINDOW_08_RI_D" );
}

hide_truck_windows()
{
	self HidePart( "TAG_GLASS_LEFT_FRONT" );
	self HidePart( "TAG_GLASS_LEFT_FRONT_D" );
	self HidePart( "TAG_GLASS_BACK" );
	self HidePart( "TAG_GLASS_BACK_D" );
	self HidePart( "TAG_GLASS_FRONT" );
	self HidePart( "TAG_GLASS_FRONT_D" );
	self HidePart( "TAG_GLASS_RIGHT_FRONT" );
	self HidePart( "TAG_GLASS_RIGHT_FRONT_D" );
}


break_window( tag ) 
{
	type = "MOD_RIFLE_BULLET";
	tagname = "";
	point = self GetTagOrigin( tag );
	direction_vec = AnglesToForward( self GetTagAngles( tag ) ) * -1;
	self notify ( "damage", 200, level.player, direction_vec, point, type, "", tag, 0 );
}

death_on_train()
{
	self.a.nodeath = true;
	self.nodrop = true;
	self waittill ( "death" );

	if ( !IsDefined( self ) )
		return;
	
	timer = gettime();
	
	ragdolldeath = isdefined( self.train_ragdoll );

	deathanim = self.deathanim;
	riding_train = self.riding_train;
	
	if( isdefined( riding_train.modeldummy ) )
		riding_train = riding_train.modeldummy;
		
	junklinked = undefined;
	if ( IsDefined( self.junk_linked ) )
		junklinked = self.junk_linked;
	
	guy = maps\_vehicle_aianim::convert_guy_to_drone( self );
	
	if ( IsDefined( junklinked ) )
		guy guy_junk_link( junklinked );
	else
		guy LinkTo( riding_train );
	guy AnimScripted( "death_on_train_done", guy.origin, guy.angles, deathanim );
	animlength = GetAnimLength( deathanim );
	wait animlength - 0.05;
	
	if ( !ragdolldeath )
	{
		wait_for_buffer_time_to_pass( timer, 10.4 );
	}

	guy Delete();
}

guy_junk_link( junk )
{
	self LinkTo( junk, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

player_bail( guy )
{
	// "Ohh F--KING HELLLLLL!!!!!!!!!!"
	thread radio_dialogue( "london_ldr_finghell" );

	thread set_ambient( "london_tube_end", 2 );
	level.player AllowCrouch( false );
	viewmodel = level.player_rig_tunnel_crash;
	ground_ent_to_tag( viewmodel, "tag_player" );
	if( !flag( "train_crash_fast_forward" ) )
		thread player_lerplink_fov( 0.5, viewmodel, "tag_player", 180, 0 );
	level.player PlayerSetGroundReferenceEnt( level.groundent );
	level.viewmodel = viewmodel;
	viewmodel delaycall( 0.2, ::Show );
}

ground_ent_to_tag( viewmodel, tag, angleoffset )
{
	if ( !IsDefined( angleoffset ) )
		angleoffset = ( 0, 180, 0 );
	
	if ( !IsDefined( level.groundent ) )
		level.groundent = spawn_tag_origin();

	level.groundent teleport_to_ent_tag( viewmodel, tag );
	level.groundent DontInterpolate();
	level.groundent LinkTo( viewmodel, tag, ( 0, 0, 0 ), angleoffset );
}

player_teleports( viewmodel )
{
////	thread sandman_stumbles();
////
////	if( !flag( "train_crash_fast_forward" ) )
////		level.viewmodel Delete();
////	ground_ent_to_tag( viewmodel, "tag_player", ( 0, 0, 0 ) );
////	
////	level.player DontInterpolate();
////	
////	flag_set( "teleport_to_west" );
////
//	hud = get_black_overlay();
//	hud FadeOverTime( 0.5 );
//	hud.alpha = 1;
////	
////	level.player PlayerLinkToDelta( viewmodel, "tag_player", 0.5 , 0, 0, 0, 0, true );
////	level.player PlayerSetGroundReferenceEnt( level.groundent );
////	level.viewmodel = viewmodel;
////	
////	thread vision_set_fog_changes( "london_westminster_station", 3 );
////	fx_volume_pause_noteworthy( "westminster_tunnels_fx_volume" );
////	fx_volume_pause_noteworthy( "westminster_tunnels_crash_fx_volume" );
////	fx_volume_restart_noteworthy( "london_west_fx_volume" );
////	
////	wait( 1 );
////	SetNorthYaw( 0 );
////	wait( 1.2 );
////	hud FadeOverTime( 3 );
////	hud.alpha = 0;
//
//	maps\_loadout::SavePlayerWeaponStatePersistent( "london", true );
//	nextmission();
}

level_end( ent )
{
	wait( 0.5 );

	hud = get_black_overlay();
	hud FadeOverTime( 0.5 );
	hud.alpha = 1;

	wait( 0.5 );

	maps\_loadout::SavePlayerWeaponStatePersistent( "london", true );
	nextmission();
}


player_lerplink_fov( time, ent, tag, base_fov, dest_fov )
{
	level.player FreezeControls( true );
	// this is ghetto hack..
	Assert( time > 0.0 );
	timeincs = time * 20;
	current_fov = base_fov;
	fov_dif = dest_fov - base_fov;
	fov_inc = fov_dif / timeincs;
	timeincs = Int( timeincs );

	for ( i = 0; i < timeincs; i++ )
	{
		current_fov += fov_inc;
		level.player PlayerLinkToDelta( ent, tag, 1, current_fov, current_fov, current_fov, current_fov );
		wait 0.05;
	}
	level.player FreezeControls( false );
}

vehicle_node_civs_cleanup_think( triggerer )
{
	cleanup_ents( "station_civs" );
}

vehicle_node_player_fast_detour_start_think( triggerer )
{
	if( !IsDefined( triggerer.needs_to_take_detours ) )
	{
		add_trigger_function( ::vehicle_node_player_fast_detour_start_think );
		return;
	}   
	target_node = GetVehicleNode( self.target, "targetname" );
	
	vehicle_node_player_fast_detour_start = GetVehicleNode( "vehicle_node_player_fast_detour", "script_noteworthy" );
	
	triggerer vehicle_switch_paths( target_node, vehicle_node_player_fast_detour_start );
	
}

teleport_to_struct_if_not_in_radius( targetname )
{
	struct = getstruct( targetname, "targetname" );
	Assert( IsDefined( struct.radius ) );
	Assert( IsDefined( struct.origin ) );
	Assert( IsDefined( struct.angles ) );
	
	if( Distance( self.origin, struct.origin ) < struct.radius )
		return;
		
	self ForceTeleport( struct.origin, struct.angles );		   
}

vehicle_node_sound_think( other )
{
	if( !other_is_player_truck( other ) )
	{
		add_trigger_function( ::vehicle_node_sound_think );
		return;
	}

	self script_wait();
	
	Assert( IsDefined( self.script_sound ) );

	if ( IsArray( level.scr_radio[ self.script_sound ] ) )
	{
		for ( i = 0; i < level.scr_radio[ self.script_sound ].size; i++ )
		{
			sound = level.scr_radio[ self.script_sound ][ i ];
			radio_dialogue( sound );
		}
	}
	else
	{
		radio_dialogue( self.script_sound );
	}
}

vehice_node_rpg( other )
{
	self script_wait();

	if ( IsDefined( self.script_sound ) )
	{
		thread radio_dialogue( self.script_sound );
	}

	rpg = spawn_vehicle_from_targetname_and_drive( self.script_parameters );
}

vehicle_node_spawn_littlebird( other )
{
	self script_wait();
	chopper = spawn_vehicle_from_targetname( self.script_parameters );
}

vehicle_node_switch_minimap( other )
{
	parm = self.script_parameters;
	SetSavedDvar( "ui_hideMap", "1" );	// no minimaps during tunnel sequence
}

littlebird_shoot_train()
{
	self ent_flag_init( "spotlight_on" );
	self ent_flag_clear( "spotlight_on" );
	self ent_flag_init( "follow_path" );
	self mgOff();
	self thread chopper_follow_path( self.target );

	wait( 0.05 );
	foreach ( mg in self.mgturret )
	{
		mg.script_delay_min = 0.05;
		mg.script_delay_min = 0.1;
		mg.script_burst_min = 20;
		mg.script_burst_max = 30;
		mg.shell_fx = getfx( "minigun_shells" );
		mg.shell_sound = "scn_london_gattling_shells";
		mg notify( "stop_burst_fire_unmanned" );
		mg thread maps\_mgturret::burst_fire_unmanned();
	}

	self SetMaxPitchRoll( 30, 50 );

	self thread littlebird_target_think();
}

littlebird_target_think()
{
	self endon( "death" );

	target = GetEnt( "trainride_littlebird_target" , "targetname" );
	self SetLookAtEnt( target );

	foreach ( mg in self.mgturret )
	{
		mg SetTargetEntity( target );
	}

	y_diff = target.origin[ 1 ] - self.origin[ 1 ];

	while ( 1 )
	{
		y = self.origin[ 1 ] + y_diff;
		target.origin = ( target.origin[ 0 ], y, target.origin[ 2 ] );
		wait( 0.05 );
	}
}

other_is_player_truck( other )
{
	if ( !IsDefined( level.player_truck ) )
		return false;

	//AssertEX( Distance( self.origin , other.origin ) < 400 , "how is this possible?" );
	// I can't find anywhere in script where this is being notified "trigger" so code must be doing it? 
	if( Distance( self.origin , other.origin ) > 400 )
		return false;


	// in this case the trigger notify happens on the same frame.
	if( other == level.player_truck_ghost && distance( level.player_truck.origin, level.player_truck_ghost.origin ) < 32 )
		return true; 
		

	if( other != level.player_truck )
		return false;
	
	return true;
}

tunnels_save_point( other )
{
	 if( !other_is_player_truck( other ) )
	{
		add_trigger_function( ::tunnels_save_point );
		return;
	}
	
	autosave_by_name( "tunnel_save" );
}

train_one_flyby_1_spawn()
{
	self thread delete_on_end();
	if( isdefined( self.script_parameters ) && self.script_parameters == "last_cart" )
		return;
		
	self vehicle_turnengineoff();
	
	if( self.classname != "script_vehicle_subway_engine_destructible" )
		return;
	self play_sound_on_entity( "scn_london_subway_passby1" );
}


train_one_flyby_2_spawn()
{
	self thread delete_on_end();
	if( isdefined( self.script_parameters ) && self.script_parameters == "last_cart" )
		return;

	self vehicle_turnengineoff();
	if( self.classname != "script_vehicle_subway_engine_destructible" )
		return;
	self play_sound_on_entity( "scn_london_subway_passby2" );
}

delete_on_end()
{
	self waittill ( "reached_end_node" );
	self delete();
}

rocky_road_trigger( other )
{
	self endon ( "death" );

	flag_wait( "player_mounts_car" );
	
	player_link_bumpy();
	childthread rumbly_rocks_bumps();
	if( IsDefined( level.rumble_ent ) )
		rumble_ent = level.rumble_ent;
	else
	{
		rumble_ent = level.player get_rumble_ent();
		rumble_ent.intensity = 0.035;
		level.rumble_ent = rumble_ent;
	}
	
	flag_set( "rocky_road" );
	
	while( level.player IsTouching( self ) )
		wait 0.05;
		
	flag_clear( "rocky_road" );

	if ( !flag( "train_crashing" ) )
		player_link_default();
 
	if ( IsDefined( rumble_ent ) )
	{   
		rumble_ent.intensity = 0.025;
	}

	self delete();
}

rumbly_rocks_bumps()
{
	level.player_truck JoltBody( ( level.player_truck.origin + ( 0, 0, 64 ) + randomvector( 32 ) ), 0.7 );
	level.player PlayRumbleOnEntity( "damage_heavy" );

	while ( 1 )
	{
		wait RandomFloatRange( 0.15, 0.4 );

		if ( cointoss() )
		{
			jolt_tag = "TAG_DRIVER";
			level.player_truck JoltBody( level.player_truck GetTagOrigin( jolt_tag ) , 0.4 );
			level.player_truck thread play_sound_on_tag( "uk_utility_suspension_heavy", "TAG_DRIVER" );
			Earthquake( 0.2, 1.75, level.player.origin, 2800 );
			level.player PlayRumbleOnEntity( "damage_heavy" );
		}
		else
		{
			Earthquake( 0.1, 1.5, level.player.origin, 2000 );
			level.player PlayRumbleOnEntity( "damage_light" );
		}
		
	}
}

player_link_default()
{
	player_spot = get_player_spot(  level.player_truck );
	level.player PlayerLinkToDelta( player_spot, "tag_player", 0.1, 180, 180, 80, 80, true);
}

player_link_bumpy()
{
	player_spot = get_player_spot(  level.player_truck );
	level.player PlayerLinkToDelta( player_spot, "tag_player", 0.7, 180, 180, 80, 80, true);
}


special_subway_cart_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
	if( !IsDefined( attacker ) )
		return;
		
	if( IsDefined( attacker.team ) && attacker.team != "allies" )
		return;
		
	if ( IsDefined( point ) && cointoss() && IsDefined( self.isflickering ) )
		PlayFX( getfx( "vehicle_scrape_sparks" ), point + ( self vehicle_getvelocity() * (0.2) )  , direction_vec * -1 );
		
	if( !isdefined( self.last_damaged_time ) )
		self.last_damaged_time = gettime();
		
	if( !isdefined( self.recent_shot_count ) )
		self.recent_shot_count = 0;
		
	if( gettime() - self.last_damaged_time > 300 )
		self.recent_shot_count = 0;
		
	self.last_damaged_time = gettime();
	self.recent_shot_count++;
	
			
		
	if( cointoss() )
		return;
	
	if( IsDefined( self.isflickering ) )
		return;
	
	PlayFX( getfx( "vehicle_scrape_sparks" ), point + ( self vehicle_getvelocity() * (0.2) )  , direction_vec * -1 );
	
	if ( ! IsDefined( self.mirror_destructible_model ) )
		return;

	if( self.recent_shot_count < 5 )
		return;
		
	self.isflickering = true;
	
	if ( flag( "train_crash_explode" ) )
		return;
	
	random_flicker = RandomIntRange( 10, 15 );
	
	for ( i = 0; i < random_flicker; i++ )
	{
		self HidePart( "TAG_INTERIOR_UNLIT" );
		self.mirror_destructible_model Show();
		wait RandomFloatRange( 0.05, 0.2 );
		
		if ( flag( "train_crash_explode" ) )
			return;
			
		self ShowPart( "TAG_INTERIOR_UNLIT" );
		self.mirror_destructible_model Hide();
		wait RandomFloatRange( 0.05, 0.2 );
		if ( flag( "train_crash_explode" ) )
			return;
	}
	self.isflickering = undefined;
}

unlink_from_ground_ent( groundent )
{
	if(! IsDefined ( groundent ) )
		groundent = level.groundent;
	Assert( IsDefined( groundent ) );
	destangles = CombineAngles( groundent.angles, self GetPlayerAngles() );
	self unlink();
	self PlayerSetGroundReferenceEnt( undefined );
	self SetPlayerAngles( destangles );
}

player_pushes_stick_for_a_bit()
{
	a_bit = 300; // ms
	
	dist = Distance( ( 0, 0, 0 ), level.player GetNormalizedMovement() );
	if ( dist == 0 )
	{
		level.player_stick_starttime = GetTime();
		return false;
	}

	if ( !IsDefined( level.player_stick_starttime ) )
	{
		level.player_stick_starttime = GetTime();
		return false;
	}
	
	return ( GetTime() - level.player_stick_starttime ) > a_bit;
	
}


open_doors_of_enemy_train( triggerer )
{
	level.lead_engine_train thread open_doors();
	array_thread( level.lead_engine_train.trains, ::open_doors );
}

close_doors_of_enemy_train( triggerer )
{
	level.lead_engine_train thread close_doors();
	array_thread( level.lead_engine_train.trains, ::close_doors );
}

slide( guy )
{
	level.player DoDamage( level.player.health * 0.75, level.player GetEye()  );
	level.player_car_damage_mirrored thread play_sound_on_entity( "scn_london_player_truck_crash_impact" );
	level.player thread play_sound_on_entity( "hand_slide_plr_start" );
	level.player thread play_loop_sound_on_entity( "hand_slide_plr_loop" );
	level.player thread slide_rumble();
	level.player ShellShock( "westminster_truck_crash" , 6 );
	level.player delaythread( 1, ::play_sound_on_entity, "breathing_hurt" );
	level.player delaythread( 3, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 5, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 7, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 8, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 11, ::play_sound_on_entity, "breathing_heartbeat" );

	wait 3;
	level.player DoDamage( level.player.health * 0.75, level.player GetEye() );
	Earthquake( 0.25, 3.5, level.player.origin, 2000 );
	level.player notify ( "done_sliding" );
	level.player stop_loop_sound_on_entity( "hand_slide_plr_loop" );
	level.player play_sound_on_entity( "hand_slide_plr_end" );
}

slide_innocent( guy )
{
	level.player DoDamage( level.player.health * 0.75, level.player GetEye()  );
//	level.player_car_damage_mirrored thread play_sound_on_entity( "scn_london_player_truck_crash_impact" );
//	level.player thread play_sound_on_entity( "hand_slide_plr_start" );
//	level.player thread play_loop_sound_on_entity( "hand_slide_plr_loop" );
	level.player thread slide_rumble();
	level.player ShellShock( "westminster_truck_crash" , 6 );
	level.player delaythread( 1, ::play_sound_on_entity, "breathing_hurt" );
	level.player delaythread( 3, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 5, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 7, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 8, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 11, ::play_sound_on_entity, "breathing_heartbeat" );

	wait 3;
	level.player DoDamage( level.player.health * 0.75, level.player GetEye() );
	Earthquake( 0.25, 3.5, level.player.origin, 2000 );
	level.player notify ( "done_sliding" );
//	level.player stop_loop_sound_on_entity( "hand_slide_plr_loop" );
//	level.player play_sound_on_entity( "hand_slide_plr_end" );
}


slide_rumble()
{
	self endon ( "done_sliding" );
	self endon ( "death" );
	while ( 1 )
	{
		wait RandomFloatRange( 0.05, 0.1 );

		if ( cointoss() )
		{
			Earthquake( 0.3, 0.55, level.player.origin, 2800 );
		}
		else
		{
			Earthquake( 0.15, 1.5, level.player.origin, 2000 );
		}
		level.player PlayRumbleOnEntity( "damage_heavy" );

		
	}
}

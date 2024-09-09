#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_vehicle;
#include maps\_vehicle_code;
#include maps\_anim;

//TODO - get friendlies to drive with player

DODGE_EARLY_DISTANCE = 600;
DODGE_END_DISTANCE = 200;

PATH_MIN_PROGRESS_DIFF = -8000;
PATH_MAX_PROGRESS_DIFF = 8000;
PATH_INACTIVE_TIMEOUT = 4000; //4 seconds


//============================================================================================
//path set up - must be called before anything else is called (including vehicle spawning)
init_vehicle_free_path()
{
	create_dvar( "vehicle_free_path_debug", 0 );
	
	/#
		level thread debug_free_path();
	#/
		
	//set up constants in level variables
	level.DODGE_EARLY_DISTANCE = DODGE_EARLY_DISTANCE;
	level.DODGE_END_DISTANCE = DODGE_END_DISTANCE;
	
	level.PATH_MIN_PROGRESS_DIFF = PATH_MIN_PROGRESS_DIFF;
	level.PATH_MAX_PROGRESS_DIFF = PATH_MAX_PROGRESS_DIFF;
	level.PATH_INACTIVE_TIMEOUT = PATH_INACTIVE_TIMEOUT;
		
	level.enemy_free_vehicles_max = 8;
	level.enemy_free_vehicles = [];
	level.drive_free_path_fun = ::vehicle_drives_free_path;
	
	//create the path
	level.vehicle_free_path = make_road_path();
	
	//get all of the triggers to turn on free path and set them to wait for trigger
	enable_free_path_triggers = getentarray( "enable_free_path", "targetname" );
	array_thread( enable_free_path_triggers, ::enable_free_path_think );
}

enable_free_path_think()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		other notify( "enable_free_path" );
	}
}


//============================================================================================
//Vehicle Spawning - spawns a vehicle and sets it up to use the free path
spawn_vehicle_and_attach_to_free_path(default_speed, skip_go_path, riders_run_to_vehicle)
{
	if(!IsDefined(skip_go_path))
		skip_go_path = false;
	if(!IsDefined(riders_run_to_vehicle))
		riders_run_to_vehicle = false;
	
	//in case we didn't initalize the free paths first
	if(!IsDefined(level.enemy_free_vehicles))
		level.enemy_free_vehicles = [];
	
	//too many vehicles on the path, return
	if ( level.enemy_free_vehicles.size >= level.enemy_free_vehicles_max )
		return;
	
	//spawn the vehilce and make it go
	vehicle = self spawn_vehicle();
	vehicle.dontUnloadOnEnd = true;

	//if doing riders, take care of that
	if(riders_run_to_vehicle)
	{
		//get all the spawners this vehicle targets
		targets	 = GetEntArray( self.target, "targetname" );
		spawners = [];
		foreach ( target in targets )
		{
			if ( target.code_classname == "info_vehicle_node" )
				continue;
			spawners[ spawners.size ] = target;
		}
		
		// make the closest spawner the driver
		spawners = get_array_of_closest( self.origin, spawners );
	
		//set each guy to get in
		foreach ( index, spawner in spawners )
			spawner thread add_spawn_function( ::guy_spawns_and_gets_in_vehicle, self, index );
	
		//spawn them
		array_thread( spawners, ::spawn_ai );
		
		//wait for the first guy, then 3 seconds before doing more
		self waittill( "guy_entered" );
		wait( 3 );
		
		//if no riders made it to the vehicle, we're done - no driver
		if(!self.riders.size)
			return;
	}

	//set the up to track
	vehicle thread vehicle_becomes_crashable();
	if ( IsDefined( default_speed ) )
		vehicle VehPhys_SetSpeed( default_speed );

	//if skipping go path, go right to a free path
	if(skip_go_path)
	{
		vehicle leave_path_for_free_path(true);
	}
	else	//otherwise go run the vehicle path first
	{
		vehicle thread leave_path_for_free_path(false);
		vehicle _gopath( vehicle );
	}
}

leave_path_for_free_path(skip_wait)
{
	//if we crashed or died, we're done
	self endon("death");
	self endon("script_crash_vehicle");
	
	//wait if we're not skipping it
	if(!skip_wait)
		self waittill_either( "enable_free_path", "reached_end_node" );

	//get the starting point for the free path based on where you are currently
	node = self get_my_free_path_node( self.origin );
	
	//run the driving function (default is set during initialization, can be overwritten)
	if ( IsDefined( level.drive_free_path_fun ) )
		node thread [[ level.drive_free_path_fun ] ] ( self );
}

get_my_free_path_node( org )
{
	// finds the 3 closest nodes and puts you on the one that is earliest on the path.
	org			= ( org[ 0 ], org[ 1 ], 0 );
	close_nodes	= get_array_of_closest( org, level.vehicle_free_path, undefined, 3);
	
	//find the one with the lowest index
	first_node = close_nodes[0];
	index = first_node.index;
	
	//see if the 2nd node is sooner
	if(close_nodes[1].index < index)
	{
		first_node = close_nodes[1];
		index = first_node.index;
	}
	
	//see if the 3rd node is sooner
	if(close_nodes[2].index < index)
	{
		first_node = close_nodes[2];
	}
	
	//return the soonest node
	return first_node;
}

guy_spawns_and_gets_in_vehicle( vehicle, position )
{
	//TODO make this support other vehicles
	self _mount_snowmobile( vehicle, position );
}


//============================================================================================
//Path Construction
make_road_path()
{
	path = process_path();
	return path;
}

process_path()
{
	path = create_path();
	add_collision_to_path( path );

	return path;
}

create_path()
{
	//get the left side of the path
	targ = getstruct( "road_path_left", "targetname" );
	assert( isdefined( targ ) );

	//create the empty path array
	path = [];

	//process the left side of the path first
	count = 0;
	prev_targ = targ;	//end points always point to themselves if there is nothing new pas tthem
	for ( ;; )
	{
		//assume this is the last node, unless we get a new next
		next_targ = targ;
		if ( isdefined( targ.target ) )
			next_targ = getstruct( targ.target, "targetname" );
	
		//drop the origin to the ground
		targ.origin = drop_point_to_ground( targ.origin);

		//add the node to the path
		path[ path.size ] = targ;
		
		//set the next and previous for this node
		targ.next_node = next_targ;
		targ.prev_node = prev_targ;
		
		//obstacle data for the node
		targ.col_lines = [];
		targ.col_volumes = [];
		targ.origins = [];
		targ.dist_to_next_node_edges = [];
		targ.origins[ "left" ] = targ.origin;
		
		//get the right side and process it
		assertex(IsDefined(targ.script_linkto), "node " + targ.targetname + " has no script_linkto");
		right_targ = getstruct(targ.script_linkto, "script_linkname");
		assertex(IsDefined(right_targ), "right target not found");

		//drop the origin to the ground
		right_targ.origin = drop_point_to_ground( right_targ.origin);
		
		//save the right boundary and other data about the road section
		targ.origins[ "right" ] = right_targ.origin;
		targ.road_width = distance( targ.origins[ "right" ], targ.origins[ "left" ] );
		targ.midpoint = ( targ.origins[ "left" ] + targ.origins[ "right" ] ) * 0.5;
		

		//set the index for this node
		targ.index = count;
		count++ ;

		//if we had no new next for this node, we're done
		if ( targ == next_targ )
			break;
		
		//move one node up the chain
		prev_targ = targ;
		targ = next_targ;
	}
	
	//now reprocess the path - calc the new left/right, makes the gate perpendicular to the midpoint vector to the next node
	foreach ( node in path )
	{
		//skip the last node
		if(node.next_node == node)
			continue;
		
		//get the mid points of the 2 nodes
		midpoint1 = node.midpoint;
		midpoint2 = node.next_node.midpoint;

		//find the right perpendicular of the vector between the 2 nodes
		angles = vectortoangles( midpoint1 - midpoint2 );
		right = anglestoright( angles );
		
		//adjust the left/right so the gate is now perpendicular to the next gate
		road_half_width = node.road_width * 0.5;
		node.origins[ "left" ] = node.midpoint + right * road_half_width;
		node.origins[ "right" ] = node.midpoint + right * road_half_width * - 1;
	}

	//go through and get the distances between odes
	foreach ( node in path )
	{
		node.dist_to_next_node = distance( node.midpoint, node.next_node.midpoint );
		node.dist_to_next_node_edges[ "left" ] = distance( node.origins[ "left" ], node.next_node.origins[ "left" ] );
		node.dist_to_next_node_edges[ "right" ] = distance( node.origins[ "right" ], node.next_node.origins[ "right" ] );
	}
	
	assertex(path.size >=3, "free drive path needs at least 3 nodes");

	return path;
}


add_collision_to_path( path )
{
	collision_lines = getstructarray( "moto_line", "targetname" );
	foreach ( collision_start in collision_lines )
	{
		//drop the 2 end points to the ground
		collision_end = getstruct( collision_start.target, "targetname" );
		collision_start.origin = drop_point_to_ground(collision_start.origin);
		collision_end.origin =  drop_point_to_ground(collision_end.origin);
		
		// each collision line is made up of two points and each have a refence to the other
		collision_start.other_col_point = collision_end;
		collision_end.other_col_point = collision_start;
	}

	foreach ( node in path )
	{
		foreach ( collision_start in collision_lines )
		{
			add_collision_to_path_node( node, collision_start );
		}
	}
}

add_collision_to_path_node( node, col_start )
{
	//if this is the end node, we don't care about collision for it
	if ( node == node.next_node )
		return;

	//figure out which is bigger, the width of the path or the distance to the next node
	max_dist = node.road_width;
	if ( node.dist_to_next_node > max_dist )
		max_dist = node.dist_to_next_node;
	
	//if neither part of the collision is with in the 150% of the max distantce (from the this node)
	col_end = getstruct( col_start.target, "targetname" );
	if ( distance(col_start.origin, node.midpoint ) > max_dist * 1.5 )
	{
		if(distance(col_end.origin, node.midpoint) > max_dist * 1.5)
			return;
	}

	//get the progress along the mid point vector for each point
	prog1 = get_progression_between_points( col_start.origin, node.midpoint, node.next_node.midpoint );
	prog2 = get_progression_between_points( col_end.origin, node.midpoint, node.next_node.midpoint );

	//if either point is negative progress, we throw it away
	if ( prog1[ "progress" ] < 0 || prog2[ "progress" ] < 0 )
		return;
	
	//if both points are past the next node, we throw it away
	if ( prog1[ "progress" ] > node.dist_to_next_node && prog2[ "progress" ] > node.dist_to_next_node )
		return;

	assertex( prog1[ "progress" ] >= 0, "Negative progress" );
	assertex( prog2[ "progress" ] >= 0, "Negative progress" );

	//save off the progress data on each collision point and figure out the offest percent
	col_start.progress = prog1[ "progress" ];
	col_start.offset = prog1[ "offset" ];
	col_start.offset_percent = get_offset_percent( node, node.next_node, prog1[ "progress" ], prog1[ "offset" ] );

	col_end.progress = prog2[ "progress" ];
	col_end.offset = prog2[ "offset" ];
	col_end.offset_percent = get_offset_percent( node, node.next_node, prog2[ "progress" ], prog2[ "offset" ] );

	// add the collision ents in order of earliest progress then later progress
	if ( prog1[ "progress" ] < prog2[ "progress" ] )
	{
		add_collision_offsets_to_path_ent( node, col_start, col_end );
		node.col_lines[ node.col_lines.size ] = col_start;
	}
	else
	{
		add_collision_offsets_to_path_ent( node, col_end, col_start );
		node.col_lines[ node.col_lines.size ] = col_end;
	}
}

get_offset_percent( node, next_node, progress, offset )
{
	//get the percent of the progress down the midpoint vector
	progress_percent = progress / node.dist_to_next_node ;

	//figure out which side we're offset on (which side of the midpoint line)
	offset_side = "left";
	if ( offset > 0 )
		offset_side = "right";

	//get the progress along the closest edge
	bumper_start = node.origins[ offset_side ];
	bumper_end = next_node.origins[ offset_side ];
	bumper_org = bumper_start + ((bumper_end - bumper_start) *  progress_percent);

	//get the progress along the center line	
	center_start = node.midpoint;
	center_end = next_node.midpoint;
	center_org = center_start + ((center_end - center_start) * progress_percent);

	//find out how wide the track is between those 2 points
	track_width = distance( center_org, bumper_org );

	//return the offset divided by the width to get the offset percent
	return offset / track_width;
}

add_collision_offsets_to_path_ent( node, close_org, far_org )
{
	// go through the path ents and apply the collision info to each node
	max_progress = far_org.progress + level.DODGE_END_DISTANCE;
	min_progress = close_org.progress - level.DODGE_EARLY_DISTANCE;

	right_offset = undefined;
	left_offset = undefined;
	right_offset_percent = undefined;
	left_offset_percent = undefined;
	
	//get the left and right bounds - higher (+) offset is right most
	if ( far_org.offset > close_org.offset )
	{
		right_offset = far_org.offset;
		left_offset = close_org.offset;
		right_offset_percent = far_org.offset_percent;
		left_offset_percent = close_org.offset_percent;
	}
	else
	{
		right_offset = close_org.offset;
		left_offset = far_org.offset;
		right_offset_percent = close_org.offset_percent;
		left_offset_percent = far_org.offset_percent;
	}

	//save off the node we started on
	start_node = node;
	
	// create a volume and travel down the path and set collision on all later nodes
	start_max_progress = max_progress;
	start_min_progress = min_progress;
	for ( ;; )
	{
		//add the volume to this node
		add_vol_to_node( node, max_progress, min_progress, right_offset, left_offset, right_offset_percent, left_offset_percent );
		
		//if there is no next node, we're done
		if ( !isdefined( node.next_node ) || (node == node.next_node))
			break;
		
		//if the next node is past the end of the collision, we're done (this adds long collision to all nodes it over laps)
		if ( node.dist_to_next_node >= max_progress )
			break;

		//remove the covered portion of the progress
		max_progress -= node.dist_to_next_node;
		node = node.next_node;
		min_progress = 0; //progress was to the first node, all other nodes are instantly at collision if it stretched long enough
	}

	//start back at the current node
	node = start_node;
		
	//reset the volume and travel up (towards the front) of the path and set collision on all earlier nodes
	max_progress = start_max_progress;
	min_progress = start_min_progress;
	while(1)
	{
		//if we hit the end of the path, we're done
		if ( !isdefined( node.prev_node ) || (node == node.prev_node ))
			break;
		
		//if the min progress is above 0, we've registered the start of the collision with the earliest node already
		if ( min_progress > 0 )
			break;

		node = node.prev_node;
		max_progress = node.dist_to_next_node;					//we know it goes past the next node or we would have thrown it out by now
		min_progress = node.dist_to_next_node + min_progress;	//how far from this node to the start
		add_vol_to_node( node, max_progress, min_progress, right_offset, left_offset, right_offset_percent, left_offset_percent );
	}
}

add_vol_to_node( node, max_col_progress, min_col_progress, right_offset, left_offset, right_offset_percent, left_offset_percent )
{
	//collision volume hodler
	vol = SpawnStruct();
	vol.colvol = [];
	
	//set and clamp the min/max progess to be between this node and next
	vol.colvol[ "max" ] = max_col_progress;
	if ( vol.colvol[ "max" ] > node.dist_to_next_node )
		vol.colvol[ "max" ] = node.dist_to_next_node;

	vol.colvol[ "min" ] = min_col_progress;
	if ( vol.colvol[ "min" ] < 0 )
		vol.colvol[ "min" ] = 0;

	assertex( vol.colvol[ "min" ] < vol.colvol[ "max" ], "free drive collision volume has min progress > max progress" );

	//save off the side bounds
	vol.colvol[ "left_offset" ] = left_offset;
	vol.colvol[ "right_offset" ] = right_offset;
	
	vol.colvol[ "left_offset_percent" ] = left_offset_percent;
	vol.colvol[ "right_offset_percent" ] = right_offset_percent;
	
	//find the collision mid point
	vol.colvol[ "mid_offset" ] = ( right_offset + left_offset ) * 0.5;
	vol.colvol[ "mid_offset_percent" ] = ( right_offset_percent + left_offset_percent ) * 0.5;

	//save the volume off
	node.col_volumes[ node.col_volumes.size ] = vol;
}


//============================================================================================
//Path Driving Stuff
vehicle_drives_free_path( vehicle )
{
	// let other scripts know that track behavior has taken over
	vehicle notify( "enable_free_path" );
		
	//if this vehicle has no riders, just crash it before we bother with anything
	if ( !vehicle.riders.size )
	{
		vehicle VehPhys_Crash();
		return;
	}
	
	//get info about the vehicle and set it up with a goal entity (one that sits out as it's target)
	node = self;	//save off the node to make it easier to reference
	
	//set up vehicle data
	vehicle.starting_speed = vehicle Vehicle_GetSpeed();
	vehicle.wipeout = false;
	vehicle.progress_node = node;
	vehicle.progress = 0;
	vehicle.endpos = vehicle.origin;
	vehicle.extra_lookahead = 0;
	vehicle.move_fails = 0;
	
	//save the time when this vehicle started the path - used to time out for wiping out
	vehicle.path_timeout = GetTime();
	
	//set it up to monitor the riders
	array_thread( vehicle.riders, ::rider_death_detection, vehicle );
	
	//update the new vehicle - adds it to the tracked list
	update_vehicle_status( vehicle );
	
	//think until the vehicle dies
	while(1)
	{
		if ( !isalive( vehicle ) )
			break;
		
		//if the vehicle is wiping out, crash it
		if(vehicle.wipeout)
		{
			vehicle VehPhys_Crash();
			
			//kill off all the riders (if any)
			foreach ( rider in vehicle.riders )
			{
				if ( isalive( rider ) )
					rider kill();
			}
			
			//wait then delete the vehicle
			wait( 5 );
			if ( isdefined( vehicle ) )
				vehicle delete();

			//update the vehicles to remove it from the list
			update_vehicle_status();
			return;
		}
		
		//see if the vehicle stopped
		if ( (!vehicle.wipeout) && (vehicle vehicle_getspeed() < 2 ))
		{
			vehicle.fails++;
			if ( vehicle.fails > 5 )
				vehicle wipeout( "move fail!" );
		}
		else
			vehicle.fails = 0;
		
		//update the vehicles goal
		vehicle set_vehicle_goal_position();
		
		wait(0.05);
	}
	
	//update the bikes, since one died
	update_vehicle_status();
}

set_vehicle_goal_position()
{
	//get the important variables to make it easier to work with
	vehicle = self;
	node = vehicle.progress_node;
	
	//if we're at the end of the path, don't do anything
	if ( node == node.next_node )
		return;
	
	//get the current progress and offset
	prog = get_progression_between_points( vehicle.origin, node.midpoint, node.next_node.midpoint );
	
	//save off old values of position - in case we jump down the path
	old_offset = prog["offset"];
	old_road_width = node.road_width;
	
	//update which node we're at, incase we blew past a node (should only happen if we jumped past node during a frame or started mid path)
	ent = move_to_correct_node( node, prog["progress"] );
	progress = ent.progress;
	node = ent.node;
	
	//save off the new node that we're at
	vehicle.progress_node = node;
	vehicle.progress = progress;
	
	//AGAIN, if we're at the end of the path, don't do anything
	if ( node == node.next_node )
		return;

	//scale the offset to the new road width (keeps our relative offset)
	offset = old_offset * node.road_width / old_road_width;
	
	//calculate the road width
	road_half_width = node.road_width * 0.5;
	road_half_width -= 50; // bring the edge in a little TODO non-constant
	
	//look for obstacles to dodge - set a new offset
	obstacles = get_obstacle_dodge_amount(node, progress + vehicle.extra_lookahead, offset, true);
	if(IsDefined(obstacles["dodge1"]))
	{
		//set the dodge offset
	   	offset = obstacles["dodge1"];
	   		   	
		//if this will push us off the road, then use the other dodge
		if ( offset > road_half_width )
			offset = obstacles["dodge2"];
		else if ( offset < - 1 * road_half_width )
			offset = obstacles["dodge2"];
	}
	
	//cap the offset to keep the vehicle from falling off the road
	if ( offset > road_half_width )
		offset = road_half_width;
	else if ( offset < - 1 * road_half_width )
		offset = -1 * road_half_width;
	
	//move the vehicle - find it's place down the road (the clamp numbers are pulled from experimentation, want it as small as possible for quick turns but too small causes the physics to mess up)
	cur_lookahead_step = (vehicle Vehicle_GetSpeed() * 63360.0 / 60.0 / 60.0) * (0.05) * 2; //turn the speed in to units to look ahead, then double it
	cur_lookahead_step = clamp(cur_lookahead_step, 50, 150);
	
	//get the new end position for the vehicle - looking ahead to get a point
	vehicle.endpos = vehicle get_vehicle_pos_from_spline(node, progress + cur_lookahead_step, offset);
	
	//adjust the speed based on the angle of the turn
	dot = get_dot(vehicle.origin, vehicle.angles, vehicle.endpos);
	scalar = 1.0;
	if ( dot > 0.9659 )	 //15 degrees - heading straight
		scalar = 1.0;
	else if ( dot > 0.8660 ) //30 degrees - not too straight
		scalar = .85;
	else if (dot > .7071)	//45 degrees
		scalar = .65;
	else if (dot > .5)		//60 degrees
		scalar = .4;
	else
		scalar = .1;

	speed = vehicle.starting_speed * scalar;
	 
	vehicle vehicleDriveTo( vehicle.endpos, speed );
	if(IsDefined(level.player.vehicle))
	{
		vehicle match_player_speed(scalar);
	}
	
	/#
	if (getdebugdvarint( "vehicle_free_path_debug" ) == 1)
	{
		vehicle debug_bike_line();
	}
	#/
}

match_player_speed(turn_scalar)
{
	//get the players current node and his progress along it
	player_node = get_my_free_path_node( level.player.vehicle.origin );
	prog = get_progression_between_points( level.player.vehicle.origin, player_node.origin, player_node.next_node.origin );
	ent = move_to_correct_node( player_node, prog["progress"] );
	player_node = ent.node;
	progress = ent.progress;
	
	//find out how big of a difference there is between the vehicle and player
	diff = progress_dif(self.progress_node, self.progress + self.player_chase_offset, player_node, progress);
	
	//if we're too far ahead or behind for too long we wipe out - if we're in the engagement range we reset the time out
	if((diff < level.PATH_MIN_PROGRESS_DIFF) && (self.path_timeout + level.PATH_INACTIVE_TIMEOUT < GetTime()))
	{
		self wipeout("too far behind");
		return;
	}
	else if((diff > level.PATH_MAX_PROGRESS_DIFF) && (self.path_timeout + level.PATH_INACTIVE_TIMEOUT < GetTime()))
	{
		self wipeout("too far ahead");
		return;
	}
	else if((diff > level.PATH_MIN_PROGRESS_DIFF) && (diff < level.PATH_MAX_PROGRESS_DIFF))
	{
		self.path_timeout = GetTime();
	}
	
	//figure out how much we should adjust our speed to match the players
	if(turn_scalar < .6)
		return;	//if we're already at 60% speed for a turn we don't want to mess with the speed
	
	//figure out how much we should scale to the player's speed
	minDist = level.PATH_MIN_PROGRESS_DIFF / 2;
	maxDist = level.PATH_MAX_PROGRESS_DIFF / 2;
	
	//if we're more than the half way point to the cut off, we have a set speed
	multiplier = 1;
	if(diff < minDist)
		multiplier = 1.5;
	else if(diff > maxDist)
		multiplier = 0.6;
	else if(diff < -100)  //otherwise find out where in the range we fall
	{
		range = minDist - (-100);
		ratio = (diff - (-100)) / range;
		
		speed_range = 1.5 - 1;
		multiplier = ratio * speed_range + 1;
	}
	else if(diff > 100)
	{
		range = maxDist - (100);
		ratio = (diff - 100) / range;
		
		speed_range = 1 - .6;
		multiplier = ratio * speed_range + .6;
	}
	else
		mulitplier = 1.0;		
	
	//calculate the speed based off of the player speed - with minimum
	speed = level.player.vehicle.veh_speed * multiplier;
	if ( speed < 25 )
			speed = 25;	
	
	self Vehicle_SetSpeed(speed, 45, 30);
}

get_obstacle_dodge_amount( node, progress, offset, clear_collisions )
{
	if(IsDefined(clear_collisions) && (clear_collisions == true))
	{
		//clear all the nodes from being marked
		foreach( vol in node.col_volumes )
			vol.has_veh_collision = false;
	}
	
	//get the array ready
	array = [];
	  
	//go through each collision and see if we find one that makes us collide
	foreach ( vol in node.col_volumes )
	{
		//already had a collision with this one, skip it
		if(vol.has_veh_collision == true)
			continue;
		
		//skip if too early or late to worry about
		if ( progress < vol.colvol[ "min" ] )
			continue;
		if ( progress > vol.colvol[ "max" ] )
			continue;

		//otherwise we're near an obstacle - skip if already avoiding
		if ( offset < vol.colvol[ "left_offset" ] )
			continue;
		if ( offset > vol.colvol[ "right_offset" ] )
			continue;

		//save off the right and left points, and mark this point as checked
		right_side = vol.colvol[ "right_offset" ] + 50;
		left_side = vol.colvol[ "left_offset" ] - 50;
		vol.has_veh_collision = true;
		
		//run the new offsets through the collision and see if we have to adjust at all
		new_array1 = get_obstacle_dodge_amount(node, progress, right_side);
		new_array2 = get_obstacle_dodge_amount(node, progress, left_side);
		
		//expand the size if we need to
		if(new_array1.size > 0)
		{
			if(new_array1["dodge1"] > right_side)
				right_side = new_array1["dodge1"];
			if(new_array1["dodge2"] > right_side)
				right_side = new_array1["dodge2"];
			
			if(new_array1["dodge1"] < left_side)
				left_side = new_array1["dodge1"];
			if(new_array1["dodge2"] < left_side)
				left_side = new_array1["dodge2"];
		}
		
		if(new_array2.size > 0)
		{
			if(new_array2["dodge1"] > right_side)
				right_side = new_array2["dodge1"];
			if(new_array2["dodge2"] > right_side)
				right_side = new_array2["dodge2"];
			
			if(new_array2["dodge1"] < left_side)
				left_side = new_array2["dodge1"];
			if(new_array2["dodge2"] < left_side)
				left_side = new_array2["dodge2"];
		}
		   
		//get the new midpoint
		mid_offset = (right_side + left_side) * 0.5;
		   
		//find out which way is shortest to dodge
		if ( offset > mid_offset )
		{
			array[ "dodge1" ] = right_side;
			array[ "dodge2" ] = left_side;
		}
		else
		{
			array[ "dodge1" ] = left_side;
			array[ "dodge2" ] = right_side;
		}
				
		//break at the first dodge point found - recursion should take care of the rest
		break;
	}
	
	return array;
}

update_vehicle_status( new_vehicle )
{
	//get an array of all currently alive vehicles that are being tracked
	vehicles = [];
	foreach ( vehicle in level.enemy_free_vehicles )
	{
		if ( !isalive( vehicle ) )
			continue;
			
		if ( vehicle.wipeout )
			continue;

		vehicles[ vehicles.size ] = vehicle;		
	}
	
	//save off the alive ones
	level.enemy_free_vehicles = vehicles;

	//add the new vehicle to the tracked list, if it's not dead or already in the list
	if ( isalive( new_vehicle ) && !new_vehicle.wipeout )
	{
		found = false;
		foreach ( vehicle in level.enemy_free_vehicles )
		{
			if ( vehicle == new_vehicle )
			{
				found = true;
				continue;
			}
		}
		
		if ( !found )
			level.enemy_free_vehicles[ level.enemy_free_vehicles.size ] = new_vehicle;
	}

	//since the array might have been shuffled, reassign offset values to the vehicles (so they form a staggered group)
	offset = -150;
	extra_lookahead = 0;
	foreach ( vehicle in level.enemy_free_vehicles )
	{
		vehicle.player_chase_offset = offset;
		offset += 75;
		
		vehicle.extra_lookahead = extra_lookahead;
		extra_lookahead += 100;
	}
}

rider_death_detection( vehicle )
{
	self waittill( "death" );
	if ( isdefined( vehicle ) )
		vehicle wipeout( "driver died!" );
}

wipeout( msg )
{
	/#
	if ( !self.wipeout )
	{
		if ( getdebugdvarint( "vehicle_free_path_debug" ) )
			Print3d( self.origin, msg, (1,0.25,0), 1, 1.5, 400 );
	}
	#/
	self.wipeout = true;
}

//============================================================================================
//Helper Functions
get_progression_between_points( pos, start_point, end_point )
{
	prog = [];

	//get the normalized vector of the progression between start and end point
	forward = vectornormalize( end_point - start_point );

	//project on to forward to find the scalar along the forward vector 
	vec = pos - start_point;
	progress = vectorDot( vec, forward );

	//find new position, projected on to the forward vector
	offset_org = start_point + forward * progress;

	//save off the progress and offset values (progress along forward, offset from forward)
	prog[ "progress" ] = progress;
	prog[ "offset" ] = distance2D( offset_org, pos );	//don't let height distort the distance

	//find out which side of the forward it's on (assumes it's the right)
	right = anglestoright( VectorToAngles(forward) );
	difference = vectornormalize( offset_org - pos );
	dot = vectordot( right, difference );
	prog[ "dot" ] = dot;
	if ( dot > 0 )
		prog[ "offset" ] *= -1;

	return prog;
}

get_position_from_spline( node, progress, offset )
{
	angles = vectortoangles( node.next_node.midpoint - node.midpoint );
	forward = anglesToForward( angles );
	right = anglesToRight( angles );
	return node.midpoint + forward * progress + right * offset;
}

get_vehicle_pos_from_spline(node, progress, offset)
{
	vehicle_lookahead_pos = get_position_from_spline( node, progress, offset );
	return PhysicsTrace( vehicle_lookahead_pos + ( 0, 0, 200 ), vehicle_lookahead_pos + ( 0, 0, -200 ) );
}

drop_point_to_ground( origin )
{
	endpos = PhysicsTrace(origin + ( 0, 0, 50 ) , origin + ( 0, 0, -50 ));
	return endpos;
}

move_to_correct_node( node, progress )
{
	ent = spawnstruct();
	
	// convert progress to proper progress and targ	
	for ( ;; )
	{
		if ( progress > node.dist_to_next_node )
		{
			if ( node == node.next_node )
				break;
					
			progress -= node.dist_to_next_node;
			node = node.next_node;
			continue;
		}

		if ( progress < 0 )
		{
			if ( node == node.prev_node )
				break;
						
			progress += node.dist_to_next_node;
			node = node.prev_node;
			continue;
		}
		
		break;
	}
	
	ent.node = node;
	ent.progress = progress;
	return ent;
}

progress_dif( node1, progress1, node2, progress2 )
{
	while ( node1.index > node2.index )
	{
		node1 = node1.prev_node;
		progress1 += node1.dist_to_next_node;
	}
	while ( node2.index > node1.index )
	{
		node2 = node2.prev_node;
		progress2 += node2.dist_to_next_node;
	}
	
	return progress1 - progress2;
}



//============================================================================================
//Debug stuff
debug_free_path()
{
	/#
	is_debugging = 0;
	while(1)
	{
		if ( (is_debugging == 0) && (getdebugdvarint( "vehicle_free_path_debug" ) == 1))
		{
			thread debug_draw_path();
			is_debugging = 1;
		}
		else if ( (is_debugging == 1) && (getdebugdvarint( "vehicle_free_path_debug" ) == 0))
		{
			level notify("stop_free_path_debug");
			is_debugging = 0;
		}
		
		wait(0.05);
	}
	#/
}


debug_draw_path()
{
	level endon("stop_free_path_debug");
	
	IPrintLnBold("!!!!DEBUG PATH!!!!");
	
	//grab the path
	path = level.vehicle_free_path;
		
	old_left_node = undefined;
	old_right_node = undefined;

	for ( i = 0; i < path.size; i++ )
	{
		node = path[ i ];

		rawLine( node.origins["left"], node.next_node.origins["left"], ( 0, 0.5, 1 ), 1, 1, 50000 );
		rawLine( node.origins["right"], node.next_node.origins["right"], ( 0, 0.5, 1 ), 1, 1, 50000 );
		rawLine( node.origins["left"], node.origins["right"], ( 0, 0.5, 1 ), 1, 1, 50000 );

		foreach ( col_volume in node.col_volumes )
		{
			node draw_col_vol( 10000, col_volume.colvol );
		}

		foreach ( col_line in node.col_lines )
		{
			start = col_line.origin;
			end = col_line.other_col_point.origin;
			rawLine( start, end, ( 1, 0, 0 ), 1, 1, 50000 );
		}
	}
}

debug_bike_line()
{
	color = ( 0.2, 0.2, 1.0 );
	Line( self.endpos, self.origin, color, 1, 0, 5 );
	print3d(self.origin, self.extra_lookahead, (1,1,1), 1, 1, 1);
}


droppedLineZ( z, start, end, color, depth, cull, timer )
{
	start = ( start[ 0 ], start[ 1 ], z );
	start = drop_to_ground( start );

	end = ( end[ 0 ], end[ 1 ], z );
	end = drop_to_ground( end );
	thread maps\_debug::linedraw( start, end, color, depth, cull, timer );
}

rawLine( start, end, color, depth, cull, timer )
{
	thread maps\_debug::linedraw( start, end, color, depth, cull, timer );
}

draw_col_vol( z, vol )
{
	start = get_position_from_spline( self, vol[ "min" ], vol[ "left_offset" ] );
	end = get_position_from_spline( self, vol[ "max" ], vol[ "left_offset" ] );
	rawLine(start, end, ( 0.5, 0, 1 ), 1, 1, 50000 );

	start = get_position_from_spline( self, vol[ "min" ], vol[ "right_offset" ] );
	end = get_position_from_spline( self, vol[ "max" ], vol[ "right_offset" ] );
	rawLine(start, end, ( 0.5, 0, 1 ), 1, 1, 50000 );

	start = get_position_from_spline( self, vol[ "min" ], vol[ "right_offset" ] );
	end = get_position_from_spline( self, vol[ "min" ], vol[ "left_offset" ] );
	rawLine(start, end, ( 0.5, 0, 1 ), 1, 1, 50000 );

	start = get_position_from_spline( self, vol[ "max" ], vol[ "right_offset" ] );
	end = get_position_from_spline( self, vol[ "max" ], vol[ "left_offset" ] );
	rawLine(start, end, ( 0.5, 0, 1 ), 1, 1, 50000 );
}


// guzzo's peleliu 2 util file for various purposes

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;


/////////////
//
// sets up players for starts
//
///////////////////

start_teleport_players( start_name, coop )
{
	
	// grab all players
	players = get_players();

	// Grab the starting points
	if( isdefined( coop ) && coop )
	{
		starts  = get_sorted_starts( start_name );	
	}
	else
	{
		starts = getstructarray( start_name, "targetname" );		
	}
	
	// make sure there are enough points to start from
	assertex( starts.size >= players.size, "Need more start positions for players!" ); 
	
	// set up each player
	for (i = 0; i < players.size; i++)
	{
		// Set the players' origin to each start point
		players[i] setOrigin( starts[i].origin );
	
		
		if( isdefined( starts[i].angles ) )
		{
			// Set the players' angles to face the right way.
			players[i] setPlayerAngles( starts[i].angles );
		}	
		else
		{
			// in case the script struct doesn't have angles set
			players[i] setPlayerAngles( ( 0, 0, 0 ) );
		}

	}	
	
	// CODER_MOD : DSL
	// Initialise the breadcrumb positions to the positions provided.
	set_breadcrumbs(starts);
	
}



// Get the points to warp the starting AI and players to
get_sorted_starts( start_name )
{
	
	player_starts = []; 

	player_starts = getstructarray( start_name, "targetname" ); 

	for( i = 0; i < player_starts.size; i++ )
	{
		for( j = i; j < player_starts.size; j++ )
		{
			if( player_starts[j].script_int < player_starts[i].script_int )
			{
				temp = player_starts[i]; 
				player_starts[i] = player_starts[j]; 
				player_starts[j] = temp; 
			}
		}
	}

	return player_starts; 
	
}



///////////////////
//
// sets up ai for starts
//
///////////////////////////////

start_teleport_ai( start_name )
{
	
	// grab all friendly ai
	friendly_ai = getentarray( "friendly_squad_ai", "script_noteworthy" );
	
	// Grab the starting point, should be a script_struct
	ai_starts = getstructarray( start_name + "_ai", "targetname");
	
	
	assertex( ai_starts.size >= friendly_ai.size, "Need more start positions for ai!" ); 
	
	for (i = 0; i < friendly_ai.size; i++)
	{
		// Set the ai's origin to each start point
		friendly_ai[i] teleport( ai_starts[i].origin );
	
	}	
	
}



///////////////////
//
// Because force teleporting of ai isn't allowed, warp player where none are visible
//
///////////////////////////////

start_trick_teleport_player()
{
	
	// grab all players
	players = get_players();

	orig = getstruct( "orig_fake_test", "targetname" );

	// set up each player, make sure there are four points to start from
	for (i = 0; i < players.size; i++)
	{
		players[i] setOrigin( orig.origin );
	}		
	
}



///////////////////
//
// Wrapper for start teleporting
//
///////////////////////////////

start_teleport( start_name )
{
	
	start_trick_teleport_player();
	start_teleport_ai( start_name );	
	start_teleport_players( start_name );
	
}



///////////////////
//
// Wrapper for setting the current color chain
//
///////////////////////////////

set_color_chain( name )
{

	color_trigger = getent( name, "targetname" );
	assertex( isdefined( color_trigger ), "color_trigger: " + name + " isn't defined!" );
	
	color_trigger notify( "trigger" );
	
}



///////////////////
//
// doesn't assert if the trigger doesn't exist
//
///////////////////////////////

set_color_chain_safe( name )
{

	color_trigger = getent( name, "targetname" );
	color_trigger notify( "trigger" );
	
}



///////////////////
//
// A simple way to use the util func trigger_wait with a timeout condition attached
//
///////////////////////////////

trigger_wait_or_timeout( trig_name, time, key )
{

	assertex( isdefined( time ), "time needs to be defined!" );

	if( !isdefined( key ) )
	{
		key = "targetname";	
	}

	// dont want trigger_once types involved here...
	trig = getent( trig_name, key );
	assertex( ( trig.classname == "trigger_multiple" || trig.classname == "trigger_lookat" ), "trigger must be a trigger_multiple or trigger_lookat to use this function!" );

	// trigger it if timeout happens
	level thread trigger_wait_or_timeout_helper( trig_name, time, key );
	
	trigger_wait( trig_name, key );

}



trigger_wait_or_timeout_helper( trig_name, time, key)
{
	
	trig = getent( trig_name, key );

	// in case it's triggered normally, don't need this thread running anymore	
	trig endon( "trigger" );
	
	wait( time );
	trig notify( "trigger" );
	
}



///////////////////
//
// Manually triggers a lookat trig if its targetted trigger is hit first. a call to this function should be followed by a trigger_wait() for the same trigger
//
///////////////////////////////

trig_override( original_trig_name )
{
	
	// ends override behavior if original trig is hit
	original_trig = getent( original_trig_name, "targetname" );
	assertex( ( original_trig.classname == "trigger_multiple" || original_trig.classname == "trigger_lookat" ), "trigger must be a trigger_multiple or trigger_lookat to use this function!" );
	original_trig endon( "trigger" );
	
	// waittill override trig is hit
	override_trig = getent( original_trig.target, "targetname" );
	override_trig waittill( "trigger" );
	
	quick_text( original_trig.targetname + " overridden!", 3, true );
	
	// notify original trig and delete override trig
	original_trig notify( "trigger" );	
	override_trig delete();
	
}



///////////////////
//
// Set the force color of heroes
//
///////////////////////////////

set_color_heroes( color )
{

	for( i  = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i] set_force_color( color );
	}
	
}



///////////////////
//
// Set the force color of all allies
//
///////////////////////////////

set_color_allies( color )
{

	guys = getAIArray( "allies" );
	for(i = 0; i < guys.size; i++)
	{
		guys[i] set_force_color( color );
	}

}



disable_arrivals( arrivals, exits )
{
	self.disableArrivals = arrivals;
	self.disableexits = exits;
}



///////////////////
//
// Can the ent see any player?
//
///////////////////////////////

cant_see_any_player()
{

	players = get_players();
	
	for( i  = 0; i < players.size; i++ )
	{
		
		if( ( self cansee( players[i] ) ) )
		{
			return false;	
		}
		
	}
	
	return true;
	
}



///////////////////
//
// returns true if no players are within range of spot
//
///////////////////////////////

players_nearby( spot, range )
{

	players = get_players();
	
	for( i  = 0; i < players.size; i++ )
	{
		
		if( distance( players[i].origin, spot ) <= range )
		{
			return true;	
		}
		
	}
	
	return false;
	
}



///////////////////
//
// deletes all ents with a specified targetname
//
///////////////////////////////

delete_targetname_ents( name )
{

	ents = getentarray( name, "targetname" );

	for( i = 0; i < ents.size; i++ )
	{
		ents[i] delete();	
	}
	
}



///////////////////
//
// deletes all ents with a specified script_noteworthy
//
///////////////////////////////

delete_noteworthy_ents( name )
{

	ents = getentarray( name, "script_noteworthy" );

	for( i = 0; i < ents.size; i++ )
	{
		if( isdefined( ents[i] ) )
		{
			ents[i] delete();	
		}
	}
	
}








////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//
// AI
//
///////////////////////////////////////
//////////////////////////////////////




//////////////
//
// wrapper for using _spawner's flood_spawner_scripted(). equivalent to using a trigger w/ floodspawn set
//
////////////////////////
simple_floodspawn( name, spawn_func )
{
	
	spawners = getEntArray( name, "targetname" );

	assertex( spawners.size, "no spawners with targetname " + name + " found!" );	
	
	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}
	
	for( i=0; i< spawners.size; i++ )
	{
		
		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			wait_network_frame();
		}
		
		spawners[i] thread maps\_spawner::flood_spawner_init();
		spawners[i] thread maps\_spawner::flood_spawner_think();
		
	}		
	
}



//////////////
//
// simple way to spawn guys just once (no floodspawning!)
//
////////////////////////
simple_spawn( name, spawn_func )
{
	
	spawners = getEntArray( name, "targetname" );

	assertex( spawners.size, "no spawners with targetname " + name + " found!" );

	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}

	ai_array = [];

	for( i = 0; i < spawners.size; i++ )
	{

		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			wait_network_frame();
		}		
		
		// check if we want to forcespawn him
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			ai = spawners[i] StalingradSpawn(); 
		}
		else
		{
			ai = spawners[i] DoSpawn(); 
		}		
		
		spawn_failed( ai );
		
		// for debug purposes (so entinfo displays their name)
		if( isdefined( ai ) )
		{
			ai.targetname = name + "_alive";
		}
		
		ai_array = add_to_array( ai_array, ai );
	}
	
	return ai_array;
	
}



//////////////
//
// simple way to spawn just one guy one time only (no floodspawning!)
//
////////////////////////
simple_spawn_single( name, spawn_func )
{
	
	spawner = getEnt( name, "targetname" );

	assertex( isdefined( spawner ), "no spawner with targetname " + name + " found!" );

	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		spawner add_spawn_function( spawn_func );
	}

	// check if we want to forcespawn him
	if( IsDefined( spawner.script_forcespawn ) )
	{
		ai = spawner StalingradSpawn(); 
	}
	else
	{
		ai = spawner DoSpawn(); 
	}	
	
	spawn_failed( ai );
		
	// for debug purposes (so entinfo displays their name)
	// also check that he doesn't have a targetname set already (such as from a custom spawn func...)
	if( isdefined( ai ) && !isdefined( ai.targetname ) )
	{
		ai.targetname = name + "_alive";
	}		
		
	return ai;
	
}



///////////////////
//
// use with array_thread on ai to set their ignoreme value to 1
//
///////////////////////////////

set_ignoreme_on()
{
	if( isalive( self ) )
	{
		self.ignoreme = 1;
	}
}



///////////////////
//
// use with array_thread on ai to set their ignoreme value to 0
//
///////////////////////////////

set_ignoreme_off()
{
	if( isalive( self ) )
	{
		self.ignoreme = 0;
	}
}



///////////////////
//
// use with array_thread on ai to set their ignoresuppression value to 1
//
///////////////////////////////

set_ignoresuppression_on()
{
	if( isalive( self ) )
	{
		self.ignoresuppression = 1;
	}
}



///////////////////
//
// use with array_thread on ai to set their ignoresuppression value to 0
//
///////////////////////////////

set_ignoresuppression_off()
{
	if( isalive( self ) )
	{
		self.ignoresuppression = 0;
	}
}




///////////////////
//
// use with array_thread on ai to set their pacifist value to 1
//
///////////////////////////////

set_pacifist_on()
{

	if( isalive( self ) )
	{
		self.pacifist = 1;
		self.pacifistwait = 0.05;
	}
	
}



///////////////////
//
// use with array_thread on ai to set their pacifist value to 0
//
///////////////////////////////

set_pacifist_off()
{

	if( isalive( self ) )
	{
		self.pacifist = 0;
		self.pacifistwait = 20;
	}
	
}



set_players_ignoreme( ignore_val )
{

	players = get_players();
	
	for( i  = 0; i < players.size; i++ )
	{
		
		players[i].ignoreme = ignore_val;
		
	}
	
}




///////////////////
//
// changes the goal radius of a group of guys based on aigroup 
//
///////////////////////////////

change_ai_group_goalradii( name, new_radius )
{

	assertex( isdefined( name ), "ai_group name needs to be defined!" );

	guys = get_ai_group_ai( name );

	if( !guys.size )
	{
		return;	
	}

	for( i = 0; i < guys.size; i++ )
	{
		guys[i].goalradius = new_radius;
	}

}



///////////////////
//
// changes the goal radius of a group of guys based on script_noteworthy
//
///////////////////////////////

change_noteworthy_goalradii( name, new_radius )
{

	guys = get_specific_ai( name );

	for( i = 0; i < guys.size; i++ )
	{
	
		guys[i].goalradius = new_radius;
		
	}

}



///////////////////
//
// Kills all non-hero ai. may take up to 3 seconds if there are 32 ai alive
//
///////////////////////////////

kill_all_ai( allies_only )
{

	if( isdefined( allies_only ) && allies_only == "allies" )
	{
		ai = getaiarray( "allies" );	
	}
	else
	{
		ai = getaiarray();	
	}
	
	for( i = 0; i < ai.size; i++ )
	{

		// ignore if it's a hero
		if( isdefined( ai[i].targetname ) && ai[i].targetname == "friendly_squad" )
		{
			continue;
		}

		// ignore if it's an enemy we don't want killed
		if( isdefined( ai[i].script_noteworthy ) && ai[i].script_noteworthy == "dont_kill_me" )
		{
			continue;
		}

		// they shouldn't have magic bullet shield on at this point, so turn it off
		if( IsDefined( ai[i].magic_bullet_shield ) && ai[i].magic_bullet_shield )
		{
			println( "stopping magic bullet shield on guy at: " + ai[i].origin + " with export: " + ai[i].export );
			ai[i] stop_magic_bullet_shield();
			wait( 0.05 );
		} 

		ai[i] dodamage( ai[i].health + 10, ( 0, 0, 0 ) );
		wait( 0.1 );	
		
	}
	
}



///////////////////
//
// Kills all axis ai. may take up to 3 seconds if there are 32 ai alive
//
///////////////////////////////

kill_all_axis_ai( delay )
{

	if( !isdefined( delay ) )
	{
		delay = 0.15;	
	}

	ai = getaiarray( "axis" );
	
	for( i = 0; i < ai.size; i++ )
	{
	
		if( isalive( ai[i] ) )
		{
			ai[i] dodamage( ai[i].health + 10, ( 0, 0, 0 ) );
			wait( delay );
		}
		
	}
	
}



///////////////////
//
// Kills all axis ai using bloody death. may take up to 3 seconds if there are 32 ai alive
//
///////////////////////////////

kill_all_axis_ai_bloody( delay )
{

	if( !isdefined( delay ) )
	{
		delay = 0.15;	
	}

	ai = getaiarray( "axis" );
	
	for( i = 0; i < ai.size; i++ )
	{
	
		if( isalive( ai[i] ) )
		{
			self thread bloody_death( true );
			wait( delay );
		}
		
	}
	
}



///////////////////
//
// Kills specific ai with specified script_aigroup
//
///////////////////////////////

kill_aigroup( name )
{

	ai = get_ai_group_ai( name );

	for( i = 0; i < ai.size; i++ )
	{
		
		// stop magic bullet shield if it's on
		if ( isdefined( ai[i].magic_bullet_shield ) && ai[i].magic_bullet_shield )
		{
			ai[i] stop_magic_bullet_shield(); 
		}
		wait( 0.05 );
		
		if( isalive( ai[i] ) )
		{
			ai[i] dodamage( ai[i].health + 1, ( 0, 0, 0 ) );
		}
		
	}	
	
}



///////////////////
//
// Kills specific ai with specified script_noteworthy
//
///////////////////////////////

kill_noteworthy_group( name )
{

	ai = get_specific_ai( name );

	for( i = 0; i < ai.size; i++ )
	{
		ai[i] dodamage( ai[i].health + 10, ( 0, 0, 0 ) );
	}	
	
}



///////////////////
//
// delete all active drones
//
///////////////////////////////

delete_drones()
{

	drones = getentarray( "drone", "targetname" );
	
	for( i = 0; i < drones.size; i++ )
	{
		drones[i] maps\_drones::drone_delete();
	}	
	
}



///////////////////
//
//  return a single guy alive that has the given script_noteworthy (there should only be one)
//
///////////////////////////////

get_specific_single_ai( name )
{

	guys = getentarray( name, "script_noteworthy" );
	
	// should grab two, the spawner and the ai
	assertex( guys.size < 3, "shouldn't have more than 2 of these guys!" );
	
	for( i = 0; i < guys.size; i++ )
	{
	
		if( isalive( guys[i] ) )
		{
			return guys[i];
		}
		
	}	
	
	return undefined;

}



///////////////////
//
//  return an array of guys that are alive with the given script_noteworthy
//
///////////////////////////////

get_specific_ai( name )
{

	guys = getentarray( name, "script_noteworthy" );
	
	ai_array = [];
	
	for( i = 0; i < guys.size; i++ )
	{
	
		if( isalive( guys[i] ) )
		{
			ai_array = array_add ( ai_array, guys[i] );
		}
		
	}	
	
	return ai_array;

}



///////////////////
//
// Moves a script origin to its targetted script_struct and back, continually
//
///////////////////////////////

flame_move_target( orig, move_time )
{

	orig endon( "stop_fakefire_mover" );
	
	targ_1 = orig.origin;
	targ_2 = getstruct( orig.target, "targetname" ).origin;

	while( 1 )
	{
		orig MoveTo( targ_2, move_time );
		orig waittill( "movedone" );
		orig MoveTo( targ_1, move_time );
		orig waittill( "movedone" );
	}	
	
}




///////////////////
//
// take a script struct that targets another struct and create a script origin for the purposes of using moveto() and setentitytarget()
//
///////////////////////////////

convert_aiming_struct_to_origin( struct_name )
{

	aim_struct = getstruct( struct_name, "targetname" );
	
	orig = spawn( "script_origin", aim_struct.origin );
	orig.target = aim_struct.target;

	orig.health = 100000;

	orig.targetname = struct_name + "_converted";

	return orig;
	
}



///////////////////
//
// get all the vehicles that are alive with the specified script_noteworthy value
//
///////////////////////////////

get_alive_noteworthy_tanks( name )
{

	tanks = getentarray( name, "script_noteworthy" );
	
	alive_tanks = [];
	
	for( i  = 0; i < tanks.size; i++ )
	{
	
		if( tanks[i].classname == "script_vehicle" && tanks[i].health > 0 )
		{
			alive_tanks = array_add( alive_tanks, tanks[i] );
		}
		
	}
	
	return alive_tanks;
	
	
}



///////////////////
//
// magic bullet shield for tanks
//
///////////////////////////////

keep_tank_alive()
{
	assertex( self.classname == "script_vehicle", "keep_tank_alive() must be used with script_vehicles!" );
	self.keep_tank_alive = 1;
	self maps\_vehicle::godon();
}



stop_keep_tank_alive()
{
	self.keep_tank_alive = 0;
	self notify( "stop_friendlyfire_shield" );
	self maps\_vehicle::godoff();
}



///////////////////
//
// Handles friendly tank pathing
//
///////////////////////////////

tank_move( pathstart )
{

	level endon( "end_current_tank_paths" );

	pathpoint = pathstart;
	arraycount = 0;
	pathpoints = [];
	
	self setspeed( 16, 8, 6 );
	
	// set up pathpoints
	while( isdefined ( pathpoint ) )
	{
		
		pathpoints[arraycount] = pathpoint;
		arraycount++;
		
		if( isdefined ( pathpoint.target ) )
		{
			pathpoint = getent( pathpoint.target, "targetname" );
		}
		else
		{
			break;
		}
		
	}
	
	// actually send tank to point
	for( i = 0; i < pathpoints.size - 1; i++ )
	{
		
		self setVehGoalPos( pathpoints[i].origin + ( 0, 0, 0 ) , 0 );
		//self setGoalYaw ( pathpoints[i].angles[1] );
		
		self waittillmatch( "goal" );
		
	}	

	self setVehGoalPos( pathpoints[pathpoints.size - 1].origin + ( 0, 0, 0 ) , 1 );
	
		
}



///////////////////
//
// Have a tank fire its turret at a script_struct
//
///////////////////////////////

tank_fire_at_struct( struct_targ, timeout )
{
	
	self endon( "death" );
	self endon( "end_tank_fire_at" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	self SetTurretTargetVec( struct_targ.origin );
	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	wait ( 1 );
	self ClearTurretTarget(); 
	self fireweapon();
	
}



///////////////////
//
// Have a tank fire its turret at an entity
//
///////////////////////////////

tank_fire_at_ent( ent_name, timeout )
{
	
	self endon( "death" );
	self endon( "end_tank_fire_at" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	spot = getent( ent_name, "targetname" );

	self SetTurretTargetEnt( spot );
	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	wait ( 1 );
	self ClearTurretTarget(); 
	self fireweapon();
	
}



///////////////////
//
// Have a tank set its turret forward and not track any target
//
///////////////////////////////

tank_reset_turret( timeout )
{

	self endon( "death" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	// get its turret facing forward
	forward = AnglesToForward( self.angles );
	vec = vectorScale( forward, 1000 );

	// to see where its forward vec is
	//self thread draw_line_from_ent_to_vec( vec );

	self SetTurretTargetVec( self.origin + vec );

	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	
	// once it's facing forward, don't let it track any previously set turret target
	self ClearTurretTarget(); 

}



draw_line_from_ent_to_vec( vec, color )
{

	if( !isdefined( color ) )
	{
		color = (1,0,0);	
	}

	for( ;; )
	{
		line( self.origin, vec, color, 0.9 ); 
		wait( 0.05 ); 
	}
	
}



tank_can_see_ent( seen_ent, tank_ent )
{

	success = BulletTracePassed( seen_ent geteye(), tank_ent gettagorigin( "tag_flash" ), false, undefined );
	
	return success;
	
}


///////////////////
//
// Stops a vehicle once it reaches its goal node
//
///////////////////////////////

veh_stop_at_node( node_name, accel, decel, dont_stop_flag )
{

	if( !isdefined( accel ) )
	{
		accel = 15;	
	}

	if( !isdefined( decel ) )
	{
		decel = 15;	
	}
	
	vnode = getvehiclenode( node_name, "script_noteworthy" );
	vnode waittill( "trigger" );	
	
	if( !isdefined( dont_stop_flag ) || ( isdefined( dont_stop_flag ) && !flag( dont_stop_flag ) ) )
	{
		self setspeed( 0, accel, decel );
//		println( "*** debug tank stop node: node " + node_name + "... now stopping" );		
	}
	
	// extra time for wasp to come to complete stop before firing
	if( self.vehicletype == "wasp" )
	{
		wait( 0.5 );
	}
	
}



///////////////////
//
// For helping guys retreat in specific instances
//
///////////////////////////////

goto_retreat_nodes( guys )
{
	
	nodes = getnodearray( "node_" + guys[0].script_aigroup, "targetname" );

	// make sure we have enough nodes to retreat to	
	// (may want to allow having less nodes... so some guys stay behind)
//	if( guys.size > nodes.size )
//	{
//		assertmsg( "more ai than there are nodes to retreat to" );
//		return;	
//	}
	
	for( i = 0; i < guys.size && i < nodes.size; i++ )
	{
		
		guys[i].pacifist = 1;
		guys[i].goalradius = 30;
		guys[i] setgoalnode( nodes[i] );
		
		guys[i] thread pacifist_till_goal();
		
	}
	
	
}



///////////////////
//
// has a guy be pacifist until he reaches his goal
//
///////////////////////////////

pacifist_till_goal()
{
	
	self endon( "death" );
	
	self waittill( "goal" );
	
	self.pacifist = 0;
	
}



temp_vo_no_anim( guy, sound_alias )
{

	level thread temp_vo_no_anim_helper( guy, sound_alias );
	
}


temp_vo_no_anim_helper( guy, sound_alias )
{

	guy endon( "death" );

	guy playsound( sound_alias, sound_alias + "_sound_done" );
	
	//guy waittill( sound_alias + "_sound_done" );
	
}



///////////////////
//
// play vo on a guy (must not already be playing a special animation)
//
///////////////////////////////

play_vo( guy, vo_animname, vo_text )
{
	level thread play_vo_helper( guy, vo_animname, vo_text );
}



play_vo_helper( guy, vo_animname, vo_text )
{
	
	if( !isdefined( guy ) )
	{
		return;	
	}
	
//	guy.animname = vo_animname;
//	guy anim_single_solo( guy, vo_text );

	lookTarget = undefined;
	notifyString = "sound_done";
	
	guy thread anim_facialFiller( notifyString, lookTarget );
	guy animscripts\face::SaySpecificDialogue( undefined, level.scr_sound[vo_animname][vo_text], 1.0, notifyString );
	guy waittill( notifyString );	
	
}



// Fake death
// self = the guy getting worked
bloody_death( die, delay )
{
	self endon( "death" );

	if( !is_active_ai( self ) )
	{
		return;
	}

	if( !isdefined( die ) )
	{
		die = true;	
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	if( !IsDefined( self ) )
	{
		return;	
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	if( die && IsDefined( self ) && self.health )
	{
		self DoDamage( self.health + 150, self.origin );
	}
}	



// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}



///////////////////
//
// for use with bloody_death()
//
///////////////////////////////

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}



players_speed_set( speed, time )
{

	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		players[i] SetMoveSpeedScale( speed ); 
	}

	level.current_player_speed = speed;

}



///////////////////
//
// Returns a random vector within the offset range (doesn't use a 'Z' offset)
//
///////////////////////////////

random_vector( offset )
{
	new_vec = ( RandomIntRange( offset*-1, offset ), RandomIntRange( offset*-1, offset ), 0 );
	return new_vec;
}



///////////////////
//
// spawns pickup weapons based upon values in the passed-in array. this is done to save ents on load
//
///////////////////////////////

spawn_pickup_weapons( weapon_array )
{

	// actually spawn each weapon and set its angles/origin
	for( i  = 0; i < weapon_array.size; i++ )
	{
		
		while( !OkTospawn() )
		{
			wait( 0.05 ); 
		}

		pickup_weapon = spawn( weapon_array[i].weapon_name, weapon_array[i].origin, 1 );
		pickup_weapon.angles = weapon_array[i].angles;
		
		// ammo count
		if( isdefined( weapon_array[i].count ) )
		{
			pickup_weapon ItemWeaponSetAmmo( 1, 3 );
		}

		wait_network_frame();		// Lets not saturate our snapshots with weapons... DSL
		
	}
	
}



///////////////////
//
// Handles what happens when exploders go off and an mg is in the vicinity
//
///////////////////////////////

mg_sandbag_cleanup( mg_name, killspawner_num )
{
	
	if( isdefined( killspawner_num ) )
	{
		maps\_spawner::kill_spawnernum( killspawner_num );
	}
	
	mg = getent( mg_name, "targetname" );
	
	mg_owner = mg getturretowner();
	
	// if there is a guy on the turret
	if( isdefined( mg_owner ) )
	{	
		mg_owner dodamage( mg_owner.health + 10, (0,0,0) );
	}
	
	mg cleartargetentity();
	mg SetMode( "manual" );	
	mg notify( "death" );				
	mg delete();	
	
}



////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//
// DEBUG
//
//////////////////////////////////////
//////////////////////////////////////




guzzo_print_3d( message )
{
	
	self endon( "death" );
	
	self notify( "stop_guzzo_print_3d" );
	self endon( "stop_guzzo_print_3d" );
	
	while( 1 )
	{
		print3d( ( self.origin +( 0, 0, 65 ) ), message, ( 0.48, 9.4, 0.76 ), 1, 1 ); 
		wait( 0.05 ); 
	}
	
}




///////////
//
// show the amount of guys alive with the specified script_noteworthy
//
//////////////////////////

show_alive_ai_count( name )
{
/#
	// cancel any previous threads of this function
	level notify( "stop_show_alive_ai_count" );
	level endon( "stop_show_alive_ai_count" );

	while( 1 )
	{
	
		level.extra_info setText( get_specific_ai( name ).size + " " + name + " are alive"  );
		
		wait( 1 );
		
	}
#/	
}



///////////
//
// show the ai_group_count
//
//////////////////////////

show_alive_aigroup_count( name )
{
/#
	// cancel any previous threads of this function
	level notify( "stop_show_alive_ai_count" );
	level endon( "stop_show_alive_ai_count" );

	while( 1 )
	{
	
		level.extra_info setText( get_ai_group_sentient_count( name ) + " " + name  );
		
		wait( 1 );
	
		
	}
#/	
}



//////////////
//
// count all alive axis and show the # on the level.ai_info hud_elem
//
/////////////////////
debug_ai()
{
/#
	while( 1 )
	{
	
		axis_ai = GetAiArray( "axis" );
		allied_ai = GetAiArray( "allies" );
		
		if( axis_ai.size + allied_ai.size >= 30 )
		{
			level.ai_info.color = (1,0,0);
		}
		else
		{
			level.ai_info.color = (1,1,1);
		}
		
		level.ai_info settext( "axis: " + axis_ai.size + "  allies: " + allied_ai.size + "  total: " + ( axis_ai.size + allied_ai.size ) );
	
		wait 0.6;
	
	}
#/
}



//////////////
//
// make ai weak
//
/////////////////////
debug_ai_health()
{
/#

	if( GetDvar( "guzzo" ) == "1" )
	{

		spawners = getspawnerarray();
		
		for( i  = 0; i < spawners.size; i++ )
		{
			if( IsSubStr( spawners[i].classname, "actor_axis" ) )
			{
				spawners[i] add_spawn_function ( ::debug_ai_health_spawnfunc );		
			}	
		}
		
		
	}
#/
}



debug_ai_health_spawnfunc()
{

	self.health = 25;
	
}



debug_tank_health()
{
	
	while( 1 )
	{
	
		tanks = getentarray( "script_vehicle", "classname" );
		dead_tanks = getentarray( "script_vehicle_corpse", "classname" );
		tanks = array_combine( tanks, dead_tanks );
		
		for( i  = 0; i < tanks.size; i++ )
		{
//			if( tanks[i].vehicletype == "type97" || tanks[i].vehicletype == "sherman" || tanks[i].vehicletype == "model94" || tanks[i].vehicletype == "triple25" )
//			{
			
				if( isdefined( tanks[i].keep_tank_alive ) && tanks[i].keep_tank_alive == 1 )
				{
					print3d( tanks[i].origin + ( 0, 0, 70 ), tanks[i].health, ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
					if( isdefined( tanks[i].targetname ) )
					{
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
					}
				}
				else if( tanks[i].health > 0 )
				{
					print3d( tanks[i].origin + ( 0, 0, 70 ), tanks[i].health, ( 1.0, 1.0, 0.0 ), 1, 1, 1 );			
					if( isdefined( tanks[i].targetname ) )
					{					
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 1.0, 1.0, 0.0 ), 1, 1, 1 );			
					}
				}
				else
				{
					if( isdefined( tanks[i].targetname ) )
					{
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 1.0, 0.0, 0.0 ), 1, 1, 1 );	
					}
				}
			}
//		}
		
		wait( 0.05 );
		
	}
	
}



debug_num_vehicles()
{

	while( 1 )
	{
		vehicles = getentarray( "script_vehicle", "classname" );
		extra_text( "vehicles: " + vehicles.size );
		wait( 0.5 );
	}
	
}



debug_turret_count()
{

	while( 1 )
	{
		
		turrets = getentarray( "misc_turret", "classname" );
		level.extra_info setText( "turrets: " +turrets.size  );
		for( i  = 0; i < turrets.size; i++ )
		{
			println( "turret[" + i + "] at: " + turrets[i].origin );	
			print3d( turrets[i].origin + ( 0, 0, 30 ), "*****", ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
		}
		
		wait( 0.05 );
		
	}
	
}



///////////////////
//
// Prints the current goalradius of an ai above their head
//
///////////////////////////////

/#
draw_goal_radius()
{

	while( 1 )
	{
	
		if( GetDvar( "guzzo" ) == "1" )
		{
		
			guys = GetAiArray();
	
			for( i = 0; i < guys.size; i++ )
			{
				
				if( guys[i].team == "axis" )
				{
					print3d( guys[i].origin + ( 0, 0, 70 ), string( guys[i].goalradius ), ( 1.0, 0.0, 0.0 ), 1, 1, 1 );	
				}
				else
				{
					print3d( guys[i].origin + ( 0, 0, 70 ), string( guys[i].goalradius ), ( 0.0, 1.0, 0.0 ), 1, 1, 1 );	
				}
				
			}
				
			wait( 0.05 );
			continue;
			
		}

		wait( 0.4 );	
		

	}

}
#/




///////////////////
//
// Prints text above each ent
//
///////////////////////////////

/#
draw_ent_locations( ent_array, text, endon_string )
{

	if( isdefined( endon_string ) )
	{
		level endon( endon_string );	
	}

	while( 1 )
	{
	

		for( i = 0; i < ent_array.size; i++ )
		{
			
			// in case ent is deleted
			if( isdefined( ent_array[i].origin ) )
			{
				print3d( ent_array[i].origin + ( 0, 0, 150 ), text, ( 1.0, 0.0, 1.0 ), 1, 1, 1 );	
			}
			
		}
			
		wait( 0.1 );

	}

}
#/




// DEBUG
// when the dvar is set, prints out all the current existing ents that have "flag_set" as their targetname
//debug_script_flag_trigs()
//{
//
//	dvar_check_old = getdvarint( "debug_script_flag_trigs" );
//
//	while( 1 )
//	{
//		
//		dvar_check_new = getdvarint( "debug_script_flag_trigs" );
//		
//		if( dvar_check_old != dvar_check_new )
//		{
//		
//			trigs = getentarray( "flag_set", "targetname" );
//			for( i  = 0; i < trigs.size; i++ )
//			{
//				println( "" );
//				println( "flag_trig \"" + trigs[i].script_flag + "\"" );	
//				println( "" );
//			}		
//			
//			dvar_checK_old = dvar_check_new;			
//			
//		}
//		
//		wait( 0.05 );
//		
//	}
//	
//}



debug_script_flag_trigs_print()
{

	trigs_with_script_flag = getentarray( "flag_set", "targetname" );

	for( i  = 0; i < trigs_with_script_flag.size; i++ )
	{
		 level thread debug_script_flag_trigs_print_waittill( trigs_with_script_flag[i] );
	}

}



debug_script_flag_trigs_print_waittill( trigger )
{
	
	trigger waittill( "trigger" );
	println( "" );
	println( "*** trigger debug: trigger with flag: " + trigger.script_flag + " has just been triggered" );
	
	// TODO put this in if we give up trying to find the cause of the bug where triggers dont send their notifies
//	if( isdefined( trigger ) )
//	{
//		trigger delete();	
//	}
	
}



///////////////////
//
// DEBUG to test bug# 8490 - random triggers seem to be being deleted
//
///////////////////////////////

//debug_print_out_all_triggers()
//{
//
//	println( "***" );
//	
//	trigger_onces = getentarray( "trigger_once", "classname" );
//	for( i  = 0; i < trigger_onces.size; i++ )
//	{
//		println( "*** trigger debug: trigger once ent #: " + trigger_onces[i] getentitynumber() + " at origin: " + trigger_onces[i].origin );
//		if( isdefined( trigger_onces[i].script_flag ) )
//		{
//			println( "*** trigger debug: above trigger has script_flag set as: " + trigger_onces[i].script_flag );
//		}
//	}
//	
//	println( "***" );
//	
//	trigger_multiples = getentarray( "trigger_multiple", "classname" );
//	for( i  = 0; i < trigger_multiples.size; i++ )
//	{
//		println( "*** trigger debug: trigger multiple ent #: " + trigger_multiples[i] getentitynumber() + " at origin: " + trigger_multiples[i].origin );
//		if( isdefined( trigger_multiples[i].script_flag ) )
//		{
//			println( "*** trigger debug: above trigger has script_flag set as: " + trigger_multiples[i].script_flag );
//		}
//	}	
//	
//	println( "***" );
//	
//	trigger_radius = getentarray( "trigger_radius", "classname" );
//	for( i  = 0; i < trigger_radius.size; i++ )
//	{
//		println( "*** trigger debug: trigger radius ent #: " + trigger_radius[i] getentitynumber() + " at origin: " + trigger_radius[i].origin );
//		if( isdefined( trigger_radius[i].script_flag ) )
//		{
//			println( "*** trigger debug: above trigger has script_flag set as: " + trigger_radius[i].script_flag );
//		}
//	}		
//	
//	println( "***" );
//	
//}



///////////////////
//
// sets up hud elements
//
////////////////////////

setup_guzzo_hud()
{
/#
	level.event_info = NewHudElem(); 
	level.event_info.alignX = "right"; 
	level.event_info.x = 100; 
	level.event_info.y = 286;
	level.event_info.fontscale = 1.2;
	
	//
	level.extra_info = NewHudElem(); 
	level.extra_info.alignX = "right"; 
	level.extra_info.x = 100; 
	level.extra_info.y = 300;
	level.extra_info.sort = -12;
	
	// only for displaying total ai count
	level.ai_info = NewHudElem(); 
	level.ai_info.alignX = "right"; 
	level.ai_info.x = 100; 
	level.ai_info.y = 320;

	// for use with quick_text() only
	level.center_info = NewHudElem(); 
	level.center_info.alignX = "center"; 
	level.center_info.x = 330; 
	level.center_info.y = 90;
	level.center_info.fontscale = 2.0;
	level.center_info.color = ( 0.9, 0.2, 0.2 );
#/
}



/////////////////
//
// to display text quickly and easily. uses center_info hud_elem
//
//////////////////////////////

quick_text( text, how_long, event )
{
/#

	if( !isdefined( how_long ) )
	{
		how_long = 3;	
	}
	
	if( !isdefined( event ) )
	{
		event = true;	
	}

	level thread quick_text_thread( text, how_long, event );
#/	
}


///////////////////
//
// ***used internally
// sets text on center_info hud element, waits, then deletes it
//
///////////////////////////////

quick_text_thread( text, how_long, event )
{
/#
	// stop other quick_texts that might be going
	level notify( "stop_quick_text" );
	
	level endon( "stop_quick_text" );

	level.center_info setText( text );
	// print to output so we have a record of quick_text prints
	println( "quick_text print: " + text );
	
	wait ( how_long );
	
	level.center_info setText( "" );
	
	if( event )
	{
		level.event_info settext( text );
	}
	
#/
}



///////////////////
//
// flashes test on center_info hud element
//
///////////////////////////////

flash_center_text( text )
{
/#	
	level thread hud_fade( level.center_info, text );
#/	
}



///////////////////
//
// Sets text on event_info hudelem
//
///////////////////////////////

event_text( text )
{
/#
	level.event_info settext( text );
	// print to output so we have a record of quick_text prints
	println( "event_text print: " + text );	
#/	
}



///////////////////
//
// Sets text on extra_info hudelem
//
///////////////////////////////

extra_text( text )
{
/#
	level.extra_info settext( text );
	// print to output so we have a record of quick_text prints
	println( "extra_text print: " + text );	
#/
}



///////////////////
//
// ***used internally
// fades in hud_elem by setting its alpha increasingly higher
//
///////////////////////////////

hud_fade( hud_elem, text )
{
/#
	flash_count = 0;

	hud_elem.alpha = 0;
	hud_elem setText( text );

	// fade up the text
	while( 1 )
	{

		if( ( hud_elem.alpha + 0.05 ) >= 1 )
		{
			hud_elem.alpha = 0;
			
			flash_count++;
			
			// stop displaying text after a certain number of flashes
			if( ( flash_count ) > 5 )
			{
				break;	
			}
			
		}

		hud_elem.alpha = hud_elem.alpha + 0.05;
		maps\_spawner::waitframe();

	}

#/
}




// TEMP for testing
drawline_from_ent( ent )
{
	/#
	self endon( "kill_lines" );

	color = ( 0, 255, 0 );

	while( 1 )
	{
		if( IsDefined( ent ) )
		{
			line( self.origin, ent.origin, color );
			wait( 0.05 );
		}
		else
		{
			break;
		}
	}
	#/
}



///////////////////
//
// Does a print 3d with an asterisk showing the location of a specified tag
//
///////////////////////////////

show_tag( ent_name, tag_name, noteworthy )
{
	/#
	if( isdefined( noteworthy ) )
	{
		ent = getent( ent_name, "script_noteworthy" );
	}
	else
	{
		ent = getent( ent_name, "targetname" );
	}
	
	while( 1 )
	{

		orig = ent gettagorigin( tag_name );
		assertex( isdefined( orig ), "tag origin for " + tag_name + " doesn't exist!" );
		
		print3d( orig, "**", ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
				
		wait( 0.05 );
		
	}
	#/
	
}



///////////////////
//
// only for use with skiptos, to reduce the amount of entities
//
///////////////////////////////

start_delete_garbage( left_x, right_x, top_y, bottom_y )
{

	/#
	
	deleted_ents = 0;
	
	ents_to_delete = getentarray( "trigger_once", "classname" );
	ents_to_delete_2 = getentarray( "trigger_multiple", "classname" );
	
	ents_to_delete = array_combine( ents_to_delete, ents_to_delete_2 );
	
	println( "" );
	println( "garbage *** cleanup" );
	
	for( i  = 0; i < ents_to_delete.size; i++ )
	{

		if( (ents_to_delete[i].origin[0] > left_x) && (ents_to_delete[i].origin[0] < right_x) && (ents_to_delete[i].origin[1] < top_y) && (ents_to_delete[i].origin[1] > bottom_y ) )
		{
			println( "garbage : deleting ent at: " + ents_to_delete[i].origin );
			ents_to_delete[i] delete();
		}
		
		deleted_ents++;
		
	}
	
	println( "garbage: total deleted ents: " + deleted_ents );
	
	#/
	
}
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\zm_zod_train;
//#using scripts\zm\zm_zod_util;

#namespace zod_cleanup;





	// Minimum time in msec for cleanup checks
	// You must be this old (in msec) before considering for cleanup
	// If you are at least this old (in msec) then allow cleanup no matter what
	// Maximum number of AI to process per frame
	// cos(40) == 80 degree FOV
	
function autoexec __init__sytem__() {     system::register("zod_cleanup",&__init__,&__main__,undefined);    }
	
function __init__()
{
	level.zombie_respawned_health = [];	
	level.n_cleanups_processed_this_frame = 0;
}

function __main__()
{
	level thread cleanup_main();
}

function force_check_now()
{
	level notify( "pump_distance_check" );
}

// Periodically loop through the AI to see if they need cleanup
function private cleanup_main()
{
	n_next_eval = 0;
	
	while ( true )
	{
		util::wait_network_frame();

		n_time = GetTime();
		if ( n_time < n_next_eval )
		{
			continue;
		}
		
		n_next_eval += 3000;

		// Process all enemies alive at this point in time
		a_ai_enemies = GetAITeamArray( "axis" );
		foreach( ai_enemy in a_ai_enemies )
		{
			if ( level.n_cleanups_processed_this_frame >= 1 )
			{
				level.n_cleanups_processed_this_frame = 0;
				util::wait_network_frame();
			}

			ai_enemy do_cleanup_check();
		}		
	}
}


//	Check to see if we need to be cleaned up
//	self is an ai
function do_cleanup_check()
{
	if ( !IsAlive( self ) )
	{
		return;
	}
	
	// Exclude non-zombies for now
	if ( !( self.animname === "zombie" ) )
	{
		return;
	}
	
	if ( self.b_ignore_cleaup === true )
	{
		return;
	}
	
	n_time_alive = GetTime() - self.spawn_time;
	if ( n_time_alive < 5000 )
	{
		return;
	}
	
	// Try not to clean up guys who are just trying to break through boards before they get through.
	//   But we still have to do something in case they get stuck...
	if ( n_time_alive < 45000 &&
	     self.script_string !== "find_flesh" &&
	     self.completed_emerging_into_playable_area !== true )
	{
		return;
	}
	
	// If we're not in an Active zone, we should be cleaned up.
	b_in_active_zone = self zm_zonemgr::entity_in_active_zone();
	level.n_cleanups_processed_this_frame++;
	
	if ( !b_in_active_zone )
	{
		// process for cleanup
		self thread delete_zombie_noone_looking();
	}
}
	

//-------------------------------------------------------------------------------
//  Deletes the zombie and adds him back into the queue if unseen & out of range.
//
//	self = zombie
//-------------------------------------------------------------------------------
function private delete_zombie_noone_looking()
{
	self endon( "death" );
	
	// exclude rising zombies that haven't finished rising.
	if( ( isdefined( self.in_the_ground ) && self.in_the_ground ) )
	{
		return;
	}
	
	foreach ( player in level.players )
	{
		// pass through players in spectator mode.
		if( player.sessionstate == "spectator" )
		{
			continue;
		}		
		
		if( self player_can_see_me( player ) )
		{
			return;
		}
	}	

	// If someone's on a moving train, use this guy to attack him.
	if ( self.ai_state == "find_flesh" && zm_train::is_moving() && !zm_train::is_full() && zm_train::is_ready_for_jumper() )
	{
		a_on_train = zm_train::get_players_on_train( true );
		if ( a_on_train.size > 0 )
		{
			zm_train::zombie_jump_onto_moving_train( self );
			return;
		}
	}
	
	// If there are more than 24 zombies remaining in the round, or if this zombie is untouched,
	// put him back into the list to be respawned.
	zombies = GetAITeamArray( level.zombie_team );
	if( zombies.size + level.zombie_total > 24 || self.health >= self.maxhealth )
	{
		if ( !( isdefined( self.exclude_cleanup_adding_to_total ) && self.exclude_cleanup_adding_to_total ) )
		{
			level.zombie_total++;
			level.zombie_respawns++;	// Increment total of zombies needing to be respawned
			
			if(self.health < level.zombie_health)
			{
				if ( !isdefined( level.zombie_respawned_health ) ) level.zombie_respawned_health = []; else if ( !IsArray( level.zombie_respawned_health ) ) level.zombie_respawned_health = array( level.zombie_respawned_health ); level.zombie_respawned_health[level.zombie_respawned_health.size]=self.health;;
			}					
		}
	}
	
	self zombie_utility::reset_attack_spot();
	self notify("zombie_delete");
	
	self Delete();
}


//-------------------------------------------------------------------------------
// Utility for checking if the player can see the zombie (ai).
// Just does a simple FOV check.
//	self is the entity to check against
//-------------------------------------------------------------------------------
function private player_can_see_me( player )
{
	v_player_angles = player GetPlayerAngles();
	v_player_forward = AnglesToForward( v_player_angles );

	v_player_to_self = self.origin - player GetOrigin();
	v_player_to_self = VectorNormalize( v_player_to_self );

	n_dot = VectorDot( v_player_forward, v_player_to_self );
	if ( n_dot < 0.766 )
	{
		return false;
	}
	
	return true;
}

//-------------------------------------------------------------------------------
// Cleanup for when zombies have bad pathing.
//-------------------------------------------------------------------------------
//function private escaped_zombies_cleanup_init()
//{
//	self endon("death");
//	
//	self.zombie_path_bad = false;
//	
//	while(1)
//	{
//		if ( !self.zombie_path_bad )
//		{	
//			self waittill( "bad_path" );
//		}
//		
//		found_player = undefined;
//
//		//check for available player.
//		foreach( e_player in level.players )
//		{
//			if( zm_utility::is_player_valid( e_player ) && self MayMoveToPoint( e_player.origin, true ) )
//			{
//				self.favoriteenemy = e_player;
//				found_player = true;
//				continue;
//			}
//		}
//
//		//special case for risers who come up outside the playable area
//		if( !IsDefined( found_player ) && IsDefined( self.in_the_ground ) && !IsDefined( self.completed_emerging_into_playable_area ) )
//		{
//			//reduced distance for bad path zombies
//			self thread delete_zombie_noone_looking();
//			self.zombie_path_bad = true;
//
//			self escaped_zombies_cleanup();
//		}
//		else if ( !IsDefined( found_player ) && IS_TRUE( self.completed_emerging_into_playable_area ) )
//		{
//			//reduced distance for bad path zombies
//			self thread delete_zombie_noone_looking();
//			self.zombie_path_bad = true;
//
//			self escaped_zombies_cleanup();
//		}
//		
//		wait 0.1;
//	}	
//}
//
//function private escaped_zombies_cleanup()
//{
//	self endon("death");
//	
//	s_escape = self get_escape_position();
//	
//	self notify( "stop_find_flesh" );
//	self notify( "zombie_acquire_enemy" );	
//	
//	if ( IsDefined( s_escape ) )
//	{
//		self setgoalpos( s_escape.origin );
//			
//		self thread check_player_available();
//		
//		self util::waittill_any( "goal", "reaquire_player" );
//	}
//	
//	self.zombie_path_bad = !can_zombie_path_to_any_player(); 
//
//	wait 0.1;
//	
//	// only rerun find_flesh if zombies have a player to find, otherwise pathing is expensive 
//	if ( !self.zombie_path_bad )
//	{
//		self thread zm_ai_basic::find_flesh();						
//	}
//}
//
//function private get_escape_position()  // self = AI
//{
//	self endon( "death" );
//	
//	// get zombie's current zone
//	str_zone = zm_utility::get_current_zone();
//	
//	//if not in a zone use the zone they were spawned from
//	if( !IsDefined( str_zone ) )
//	{
//		str_zone = self.zone_name;
//	}
//	
//	// get adjacent zones to current zone
//	if ( IsDefined( str_zone ) )
//	{
//		a_zones = get_adjacencies_to_zone( str_zone );
//		
//		// get all dog locations in all zones + adjacencies
//		a_dog_locations = get_dog_locations_in_zones( a_zones );
//		
//		// find farthest point away
//		s_farthest = self get_farthest_dog_location( a_dog_locations );
//	}
//	
//	// return farthest
//	return s_farthest;
//}
//
//
//function private check_player_available()  // self = AI
//{
//	self notify( "_check_player_available" );  // only one copy of this thread per zombie
//	self endon( "_check_player_available" );
//	
//	self endon("death");
//	self endon("goal");
//
//	while ( self.zombie_path_bad )
//	{
//		wait RandomFloatRange( 0.2, 0.5 );
//		
//		if ( self can_zombie_see_any_player() )
//		{
//			self notify( "reaquire_player" );
//			return;
//		}
//	}
//	self notify( "reaquire_player" );
//}	
//
//function private can_zombie_path_to_any_player()  // self = AI
//{
//	foreach( e_player in level.players )
//	{
//		if( !zm_utility::is_player_valid( e_player ) )
//		{
//			continue;
//		}
//		
//		v_player_origin = e_player.origin;
//		
//		// TODO: account for the train.
//
//		if ( self FindPath( self.origin, v_player_origin ) )  // FindPath will create the red/yellow 'path box' in dev builds; expensive.
//		{
//			return true;
//		}
//	}
//	
//	return false;
//}
//
//function private can_zombie_see_any_player()  // self = AI
//{
//	for ( i = 0; i < level.players.size; i++ )
//	{
//		if( !zm_utility::is_player_valid( level.players[i] ) )
//		{
//			continue;
//		}
//		
//		// If we're not on the tank, and the player is
//		player_origin = level.players[i].origin;
//		
//		// TODO: account for the train.
//		
//		if ( self FindPath(self.origin, player_origin, true, false))
//		{
//			return true;
//		}
//	}	
//	
//	return false;
//}
//
//function private get_adjacencies_to_zone( str_zone )
//{
//	a_adjacencies = [];
//	a_adjacencies[ 0 ] = str_zone;  // the return value of this array will be referenced directly, so make sure initial zone is included
//	
//	a_adjacent_zones = GetArrayKeys( level.zones[ str_zone ].adjacent_zones );
//	for ( i = 0; i < a_adjacent_zones.size; i++ )
//	{
//		if ( level.zones[ str_zone ].adjacent_zones[ a_adjacent_zones[ i ] ].is_connected )
//		{
//			ARRAY_ADD( a_adjacencies, a_adjacent_zones[ i ] );
//		}
//	}
//	
//	return a_adjacencies;
//}
//
//
//function private get_dog_locations_in_zones( a_zones )
//{
//	a_dog_locations = [];
//	
//	foreach ( zone in a_zones )
//	{
//		a_dog_locations = ArrayCombine( a_dog_locations, level.zones[ zone ].dog_locations, false, false );
//	}
//	
//	return a_dog_locations;
//}
//
//// self == AI
////
//function private get_farthest_dog_location( a_dog_locations )
//{
//	n_farthest_index = 0;  // initialization
//	n_distance_farthest = 0;
//	
//	for ( i = 0; i < a_dog_locations.size; i++ )
//	{
//		n_distance_sq = DistanceSquared( self.origin, a_dog_locations[ i ].origin );
//		
//		if ( n_distance_sq > n_distance_farthest )
//		{
//			n_distance_farthest = n_distance_sq;
//			n_farthest_index = i;
//		}
//	}
//	
//	return a_dog_locations[ n_farthest_index ];
//}


                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_ai_basic;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\zm_zod_train;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_dist_tracking;

 // 100 * 100





function autoexec __init__sytem__() {     system::register("zod_distance_tracking",&__init__,&__main__,undefined);    }
	
function __init__()
{
	level.zombie_respawned_health = [];	
	level.zombie_tracking_dist_sq = 1420 * 1420;
	level.zombie_tracking_this_frame = 0;
	level flag::init( "zombie_distance_checking" );
}

function __main__()
{
	zm_zod_util::on_zombie_spawned( &zombie_tracking_think );
	level thread run_frame_limiter();
	level thread run_periodical_check();
}

function force_check_now()
{
	level notify( "pump_distance_check" );
}

// Periodically, run an un-forced check.
//
function private run_periodical_check()
{
	while ( true )
	{
		wait 3.0;
		
		// TODO: once we've got zones in all playable areas, this won't be necessary.
		/#
			a_on_train = zm_train::get_players_on_train( true );
			if ( a_on_train.size == 0 || !zm_train::is_moving() )
			{
				b_any_in_valid_zone = false;
				foreach ( e_player in level.players )
				{
					zone = e_player zm_zonemgr::get_player_zone();
					if ( isdefined( zone ) )
					{
						b_any_in_valid_zone = true;
					}
				}
				
				if ( !b_any_in_valid_zone )
				{
					continue;
				}
			}
		#/
			
		level notify( "pump_distance_check" );
	}
}

function private run_frame_limiter()
{	
	while(true)
	{		
		// Pump through the max per frame until everyone's been checked, then cycle back around.
		//
		level waittill( "pump_distance_check" );
		util::wait_network_frame();
		while ( level.zombie_tracking_this_frame > 0 )
		{
			level.zombie_tracking_this_frame = 0;
			util::wait_network_frame();
		}
	}	
}

// self == zombie
function private zombie_tracking_think()
{
	self endon( "death" );

	// Exclude non-zombies
	if ( !( self.animname === "zombie" ) )
	{
		return;
	}

	while ( true )
	{
		level waittill( "pump_distance_check" );
		
		while ( level.zombie_tracking_this_frame >= 5 )
		{
			util::wait_network_frame();
		}
		
		level.zombie_tracking_this_frame++;
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

	//	Don't check if it's disabled
	if ( ( isdefined( self.b_skip_distance_tracking ) && self.b_skip_distance_tracking ) )
	{
		return;
	}
	
	too_far_dist_sq = 1800 * 1800;
	if(isDefined(level.zombie_tracking_too_far_dist))
	{
		too_far_dist_sq = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}
	
	n_distance_squared = 0; 	// scope declaration for debugging purposes
	n_height_difference = 0;	// scope declaration for debugging purposes

	for ( i = 0; i < level.players.size; i++ )
	{
		// pass through players in spectator mode.
		if(level.players[i].sessionstate == "spectator")
		{
			continue;
		}		
		
		n_distance_squared = Distancesquared(self.origin, level.players[i].origin);
		n_height_difference = abs(self.origin[2] - level.players[i].origin[2]);
		if( n_distance_squared < level.zombie_tracking_dist_sq && n_height_difference < 800 )
		{
			return;
		}

		can_be_seen = self player_can_see_me(level.players[i]);
		if(can_be_seen && Distancesquared(self.origin, level.players[i].origin) < too_far_dist_sq )
		{
			return;
		}
	}	

	// If someone's on a moving train, use this guy to attack him.
	//
	if ( self.ai_state == "find_flesh" && zm_train::is_moving() && !zm_train::is_full() && zm_train::is_ready_for_jumper() )
	{
		a_on_train = zm_train::get_players_on_train( true );
		if ( a_on_train.size > 0 )
		{
			zm_train::zombie_jump_onto_moving_train( self );
			self.on_aether_island = false;
			return;
		}
	}
	
	zombies = GetAITeamArray( level.zombie_team );
	
	// If there are more than 24 zombies remaining in the round, or if this zombie is untouched,
	// put him back into the list to be respawned.
	//
	if( zombies.size + level.zombie_total > 24 || self.health >= self.maxhealth )
	{
		if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) )
		{
			level.zombie_total++;
			
			if(self.health < level.zombie_health)
			{
				if ( !isdefined( level.zombie_respawned_health ) ) level.zombie_respawned_health = []; else if ( !IsArray( level.zombie_respawned_health ) ) level.zombie_respawned_health = array( level.zombie_respawned_health ); level.zombie_respawned_health[level.zombie_respawned_health.size]=self.health;;
			}					
		}
	}
	
	self zombie_utility::reset_attack_spot();
	self notify("zombie_delete");
	
	self Delete();
	zm_utility::recalc_zombie_array();
}

//-------------------------------------------------------------------------------
// Utility for checking if the player can see the zombie (ai).
// Can the player see me?
//-------------------------------------------------------------------------------
function private player_can_see_me( player )
{
	playerAngles = player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );

	banzaiPos = self.origin;
	playerPos = player GetOrigin();
	playerToBanzaiVec = banzaiPos - playerPos;
	playerToBanzaiUnitVec = VectorNormalize( playerToBanzaiVec );

	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToBanzaiUnitVec );

	if ( forwardDotBanzai >= 1 )
	{
		angleFromCenter = 0;
	}
	else if ( forwardDotBanzai <= -1 )
	{
		angleFromCenter = 180;
	}
	else
	{
		angleFromCenter = ACos( forwardDotBanzai ); 
	}

	playerFOV = GetDvarFloat( "cg_fov" );
	banzaiVsPlayerFOVBuffer = GetDvarFloat( "g_banzai_player_fov_buffer" );	
	if ( banzaiVsPlayerFOVBuffer <= 0 )
	{
		banzaiVsPlayerFOVBuffer = 0.2;
	}
	
	playerCanSeeMe = ( angleFromCenter <= ( playerFOV * 0.5 * ( 1 - banzaiVsPlayerFOVBuffer ) ) );

	return playerCanSeeMe;
}

//-------------------------------------------------------------------------------
// Cleanup for when zombies have bad pathing.
//-------------------------------------------------------------------------------
function private escaped_zombies_cleanup_init()
{
	self endon("death");
	
	self.zombie_path_bad = false;
	
	while(1)
	{
		if ( !self.zombie_path_bad )
		{	
			self waittill( "bad_path" );
		}
		
		found_player = undefined;

		//check for available player.
		foreach( e_player in level.players )
		{
			if( zm_utility::is_player_valid( e_player ) && self MayMoveToPoint( e_player.origin, true ) )
			{
				self.favoriteenemy = e_player;
				found_player = true;
				continue;
			}
		}

		//special case for risers who come up outside the playable area
		if( !IsDefined( found_player ) && IsDefined( self.in_the_ground ) && !IsDefined( self.completed_emerging_into_playable_area ) )
		{
			//reduced distance for bad path zombies
			self thread delete_zombie_noone_looking();
			self.zombie_path_bad = true;

			self escaped_zombies_cleanup();
		}
		else if ( !IsDefined( found_player ) && ( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) )
		{
			//reduced distance for bad path zombies
			self thread delete_zombie_noone_looking();
			self.zombie_path_bad = true;

			self escaped_zombies_cleanup();
		}
		
		wait 0.1;
	}	
}

function private escaped_zombies_cleanup()
{
	self endon("death");
	
	s_escape = self get_escape_position();
	
	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );	
	
	if ( IsDefined( s_escape ) )
	{
		self setgoalpos( s_escape.origin );
			
		self thread check_player_available();
		
		self util::waittill_any( "goal", "reaquire_player" );
	}
	
	self.zombie_path_bad = !can_zombie_path_to_any_player(); 

	wait 0.1;
	
	// only rerun find_flesh if zombies have a player to find, otherwise pathing is expensive 
	if ( !self.zombie_path_bad )
	{
		self thread zm_ai_basic::find_flesh();						
	}
}

function private get_escape_position()  // self = AI
{
	self endon( "death" );
	
	// get zombie's current zone
	str_zone = zm_utility::get_current_zone();
	
	//if not in a zone use the zone they were spawned from
	if( !IsDefined( str_zone ) )
	{
		str_zone = self.zone_name;
	}
	
	// get adjacent zones to current zone
	if ( IsDefined( str_zone ) )
	{
		a_zones = get_adjacencies_to_zone( str_zone );
		
		// get all dog locations in all zones + adjacencies
		a_dog_locations = get_dog_locations_in_zones( a_zones );
		
		// find farthest point away
		s_farthest = self get_farthest_dog_location( a_dog_locations );
	}
	
	// return farthest
	return s_farthest;
}


function private check_player_available()  // self = AI
{
	self notify( "_check_player_available" );  // only one copy of this thread per zombie
	self endon( "_check_player_available" );
	
	self endon("death");
	self endon("goal");

	while ( self.zombie_path_bad )
	{
		wait RandomFloatRange( 0.2, 0.5 );
		
		if ( self can_zombie_see_any_player() )
		{
			self notify( "reaquire_player" );
			return;
		}
	}
	self notify( "reaquire_player" );
}	

function private can_zombie_path_to_any_player()  // self = AI
{
	foreach( e_player in level.players )
	{
		if( !zm_utility::is_player_valid( e_player ) )
		{
			continue;
		}
		
		v_player_origin = e_player.origin;
		
		// TODO: account for the train.

		if ( self FindPath( self.origin, v_player_origin ) )  // FindPath will create the red/yellow 'path box' in dev builds; expensive.
		{
			return true;
		}
	}
	
	return false;
}

function private can_zombie_see_any_player()  // self = AI
{
	zombie_on_island = zm_zod_util::is_point_in_aether_island( self.origin );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		if( !zm_utility::is_player_valid( level.players[i] ) )
		{
			continue;
		}
		
		// If we're not on the tank, and the player is
		player_origin = level.players[i].origin;
		
		// TODO: account for the train.
		
		// if we're on the island and the player is not, or vice versa, we can't see them.
		player_on_island = zm_zod_util::is_point_in_aether_island( level.players[i].origin );
		if ( player_on_island != zombie_on_island )
		{
			continue;
		}

		if ( self FindPath(self.origin, player_origin, true, false))
		{
			return true;
		}
	}	
	
	return false;
}

function private get_adjacencies_to_zone( str_zone )
{
	a_adjacencies = [];
	a_adjacencies[ 0 ] = str_zone;  // the return value of this array will be referenced directly, so make sure initial zone is included
	
	a_adjacent_zones = GetArrayKeys( level.zones[ str_zone ].adjacent_zones );
	for ( i = 0; i < a_adjacent_zones.size; i++ )
	{
		if ( level.zones[ str_zone ].adjacent_zones[ a_adjacent_zones[ i ] ].is_connected )
		{
			if ( !isdefined( a_adjacencies ) ) a_adjacencies = []; else if ( !IsArray( a_adjacencies ) ) a_adjacencies = array( a_adjacencies ); a_adjacencies[a_adjacencies.size]=a_adjacent_zones[ i ];;
		}
	}
	
	return a_adjacencies;
}


function private get_dog_locations_in_zones( a_zones )
{
	a_dog_locations = [];
	
	foreach ( zone in a_zones )
	{
		a_dog_locations = ArrayCombine( a_dog_locations, level.zones[ zone ].dog_locations, false, false );
	}
	
	return a_dog_locations;
}

// self == AI
//
function private get_farthest_dog_location( a_dog_locations )
{
	n_farthest_index = 0;  // initialization
	n_distance_farthest = 0;
	
	for ( i = 0; i < a_dog_locations.size; i++ )
	{
		n_distance_sq = DistanceSquared( self.origin, a_dog_locations[ i ].origin );
		
		if ( n_distance_sq > n_distance_farthest )
		{
			n_distance_farthest = n_distance_sq;
			n_farthest_index = i;
		}
	}
	
	return a_dog_locations[ n_farthest_index ];
}


                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

                                                                                                            	   	

#namespace zm_factory_dist_tracking;

 // 100 * 100





function autoexec __init__sytem__() {     system::register("factory_distance_tracking",&__init__,&__main__,undefined);    }
	
function __init__()
{
	level.zombie_respawned_health = [];	
	level.zombie_tracking_dist_sq = 1520 * 1520;
	level.zombie_tracking_this_frame = 0;
	level flag::init( "zombie_distance_checking" );
}

function __main__()
{
	spawner::add_archetype_spawn_function( "zombie", &zombie_tracking_think );
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

	if ( ( isdefined( self.is_rat_test ) && self.is_rat_test ) )
	{
		return;
	}
	
	too_far_dist_sq = 2600 * 2600;
	
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
		
		can_be_seen = self player_can_see_me(level.players[i]);
		if(can_be_seen && Distancesquared(self.origin, level.players[i].origin) < too_far_dist_sq )
		{
			return;
		}
			
		n_distance_squared = Distancesquared(self.origin, level.players[i].origin);
		n_height_difference = abs(self.origin[2] - level.players[i].origin[2]);
		if( n_distance_squared < level.zombie_tracking_dist_sq && n_height_difference < 1000 )
		{
			return;
		}					
	}	
	
	if ( !( self.animname === "zombie" ) )
	{
		return;
	}

	// exclude rising zombies that haven't finished rising.
	if( ( isdefined( self.in_the_ground ) && self.in_the_ground ) )
	{
		return;
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


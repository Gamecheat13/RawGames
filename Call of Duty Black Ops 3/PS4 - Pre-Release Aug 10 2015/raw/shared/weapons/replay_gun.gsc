#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

                                              	  	                                                                                  	        
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace replay_gun;

function autoexec __init__sytem__() {     system::register("replay_gun",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &watch_for_replay_gun );
}

function watch_for_replay_gun()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );
	self endon("killReplayGunMonitor");
	
	while( 1 )
	{
		self waittill( "weapon_change_complete", weapon );
		
		self WeaponLockFree();
		if ( ( isdefined( weapon.usesPivotTargeting ) && weapon.usesPivotTargeting ) )
		{
			self thread watch_lockon(weapon);
		}
	}
}

function watch_lockon(weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );
	self endon( "weapon_change_complete" );
	while(1)
	{
		{wait(.05);};
		if ( !IsDefined(self.lockonentity) )
		{
			ads = ( self PlayerAds() == 1.0 );
			if ( ads )
			{
				target = self get_a_target(weapon);
				
				// start to lock on
				if ( is_valid_target( target ) )
				{
					self WeaponLockFree();
					self.lockonentity = target;
					//self WeaponLockStart( target );
				}
			}
		}
	}
	
}

function get_a_target(weapon)
{
	origin = self GetWeaponMuzzlePoint();
	forward = self GetWeaponForwardDir();

	targets = self get_potential_targets();

	if ( !IsDefined( targets ) )
		return undefined;

	if ( !IsDefined(weapon.lockOnScreenRadius) || weapon.lockOnScreenRadius< 1 )
		return undefined;

	validTargets = [];
	should_wait = false;

	for ( i = 0; i < targets.size; i++ )
	{
		if ( should_wait )
		{
			{wait(.05);}; 
			origin = self GetWeaponMuzzlePoint();
			forward = self GetWeaponForwardDir();
			should_wait = false;
		}
		
		testTarget = targets[i];

		if ( !is_valid_target( testTarget ) )
		{
			continue;
		}

		testOrigin = get_target_lock_on_origin( testTarget );
		//test_range_squared = DistanceSquared( origin, testOrigin );
		test_range = Distance( origin, testOrigin );
		//gun_range = self get_replay_range(weapon);

		if ( test_range > weapon.lockOnMaxRange ||
			 test_range < weapon.lockOnMinRange )
		{
			continue;
		}

		normal = VectorNormalize( testOrigin - origin );
		dot = VectorDot( forward, normal );

		if ( 0 > dot )
		{
			// guy's behind us
			continue;
		}

		if ( !self inside_screen_crosshair_radius( testOrigin, weapon ) )
		{
			continue;
		}
		
		canSee = self can_see_projected_crosshair( testTarget, testOrigin, origin, forward, test_range );
		should_wait = true; // ^^ that's expensive

		if ( canSee )
		{
			validTargets[ validTargets.size ] = testTarget;
		}
	}

	return pick_a_target_from( validTargets );
}

function get_potential_targets()
{
	str_opposite_team = "axis";
	if ( self.team == "axis" )
	{
		str_opposite_team = "allies";
	}

	potentialTargets = [];
	aiTargets = GetAITeamArray( str_opposite_team );

	if ( aiTargets.size > 0 )
		potentialTargets = ArrayCombine( potentialTargets, aiTargets, true, false );
	
	playerTargets = self GetEnemies();

	if ( playerTargets.size > 0 )
		potentialTargets = ArrayCombine( potentialTargets, playerTargets, true, false );

	if ( potentialTargets.size == 0 )
		return undefined;

	return potentialTargets;
}

function pick_a_target_from( targets )
{
	if ( !IsDefined( targets ) )
		return undefined;

	bestTarget = undefined;
	bestTargetDistanceSquared = undefined;

	for ( i = 0; i < targets.size; i++ )
	{
		target = targets[i];
		
		if ( is_valid_target( target ) )
		{
			targetDistanceSquared =  DistanceSquared( self.origin, target.origin );

			if ( !IsDefined( bestTarget ) || !IsDefined( bestTargetDistanceSquared ) )
			{
				bestTarget = target;
				bestTargetDistanceSquared = targetDistanceSquared;
			}
			else
			{				
				if ( targetDistanceSquared < bestTargetDistanceSquared )
				{
					bestTarget = target;
					bestTargetDistanceSquared = targetDistanceSquared;
				}
			}					
		}
	}

	return bestTarget;
}

function trace( from, to )
{
	return bullettrace(from,to, 0, self )[ "position" ];
}



function can_see_projected_crosshair( target, target_origin, player_origin, player_forward, distance )
{
	crosshair = player_origin + player_forward * distance; 
	
	collided = target trace( target_origin, crosshair );
		
	if ( Distance2DSquared(crosshair,collided) > 3 * 3 )
	{
		return false;
	}

	collided = self trace( player_origin, crosshair );
		
	if ( Distance2DSquared(crosshair,collided) > 3 * 3 )
	{
		return false;
	}
	return true;
}

function is_valid_target( ent )
{
	return IsDefined( ent ) && IsAlive( ent );
}

function inside_screen_crosshair_radius( testOrigin, weapon )
{
	radius = weapon.lockOnScreenRadius;

	return self inside_screen_radius( testOrigin, radius );
}

function inside_screen_lockon_radius( targetOrigin )
{
	radius = self getLockOnRadius();
	
	return self inside_screen_radius( targetOrigin, radius );
}

function inside_screen_radius( targetOrigin, radius )
{
	const useFov = 65;

	return Target_OriginIsInCircle( targetOrigin, self, useFov, radius );
}

/*
function get_pivot_tether_distance()
{
	distance = SETTING_LOCKING_TETHER_DISTANCE; 
	return distance;	
}

function get_replay_range(weapon)
{
	range = weapon.lockOnMaxRange;
	return range;
}

function get_crosshair_radius(weapon)
{
	crosshairRadius = weapon.lockOnScreenRadius; //25

	return crosshairRadius;
}
*/

function get_target_lock_on_origin( target )
{
	return self GetReplayGunLockOnOrigin( target );	
}

/*
function get_Lock_on_time()
{
	lockOnTime = self getlockOnSpeed();

	return lockOnTime;
}

function replay_sticky_aim()
{
	self notify ("replay_sticky_aim_thread");
	self endon ("replay_sticky_aim_thread");
	replay_sticky_aim_think();
	SetDvar("aim_slowdown_pitch_scale_ads", "0.5");
	SetDvar("aim_slowdown_yaw_scale_ads", "0.5");
}

function replay_sticky_aim_think()
{
	self endon ("death");
	self endon ("disconnect");
	self endon ("replay_sticky_aim_thread");
	
	SetDvar("aim_slowdown_pitch_scale_ads", "0.25");
	SetDvar("aim_slowdown_yaw_scale_ads", "0.25");
	
	self waittill ("replay_target_lost");
}

*/






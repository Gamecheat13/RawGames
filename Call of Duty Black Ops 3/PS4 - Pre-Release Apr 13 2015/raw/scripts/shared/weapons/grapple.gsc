#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

     
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace grapple;

function autoexec __init__sytem__() {     system::register("grapple",&__init__,&__main__,undefined);    }





	





	
function __init__()
{
	callback::on_spawned( &watch_for_grapple );
}

function __main__()
{
	grapple_targets = GetEntArray( "grapple_target", "targetname" );
	foreach( target in grapple_targets ) 
	{
		target SetGrapplableType( 1 );
	}
}

function translate_notify_1( from_notify, to_notify )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );

	while (IsDefined(self))
	{
		self waittill( from_notify, param1, param2, param3 );
		self notify( to_notify, from_notify, param1, param2, param3 );
	}
}


function watch_for_grapple()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );
	self endon("killReplayGunMonitor");

	self thread translate_notify_1( "weapon_switch_started", "grapple_weapon_change" );
	self thread translate_notify_1( "weapon_change_complete", "grapple_weapon_change" );
	
	while( 1 )
	{
		self waittill( "grapple_weapon_change", event, weapon );
		
		if ( ( isdefined( weapon.grappleWeapon ) && weapon.grappleWeapon ) )
		{
			self thread watch_lockon(weapon);
		}
		else
		{
			self notify( "watch_lockon" );
		}
	}
}

function watch_lockon(weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );
	self notify( "watch_lockon" );
	self endon( "watch_lockon" );

	self thread watch_lockon_angles(weapon);

	while(1)
	{
		{wait(.05);};
		if ( !(self IsGrappling()) )
		{
			target = self get_a_target(weapon);
			if ( !(self IsGrappling()) && !( target === self.lockonentity ) )
			{
				self WeaponLockNoClearance( !( target === self.grapple_dummy_target ) );
				self.lockonentity = target;
				wait 0.1;
			}
		}
	}
}

function watch_lockon_angles(weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawned_player" );
	self notify( "watch_lockon_angles" );
	self endon( "watch_lockon_angles" );
	
	while(1)
	{
		{wait(.05);};
		if ( !(self IsGrappling()) )
		{
			if ( IsDefined( self.lockonentity ) )
			{
				if ( ( self.lockonentity === self.grapple_dummy_target ) )
				{
					self weaponlocktargettooclose( false );
				}
				else
				{
					testOrigin = get_target_lock_on_origin( self.lockonentity );
					if ( !self inside_screen_angles( testOrigin, weapon, false ) )
					{
						self weaponlocktargettooclose( true );
					}
					else
					{
						self weaponlocktargettooclose( false );
					}
				}
			}
			
		}
	}
}

function place_dummy_target( origin, forward, weapon )
{
	if ( !IsDefined(self.grapple_dummy_target) )
	{
		self.grapple_dummy_target = Spawn( "script_origin", origin );
		self.grapple_dummy_target SetGrapplableType( 3 );
	}

	start = origin; 
	end = origin + forward * ( weapon.lockOnMaxRange * 0.9 );
	
	if ( !(self IsGrappling()) )
	{
		self.grapple_dummy_target.origin = self trace( start, end, self.grapple_dummy_target );
	}
	
	return self.grapple_dummy_target;
}
	
function get_a_target(weapon)
{
	origin = self GetWeaponMuzzlePoint();
	forward = self GetWeaponForwardDir();

	targets = GetGrappleTargetArray();

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
		//gun_range = self get_grapple_range(weapon);

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

		if ( !self inside_screen_angles( testOrigin, weapon, !( testTarget === self.lockonentity ) ) )
		{
			continue;
		}
		
		canSee = self can_see( testTarget, testOrigin, origin, forward, 30 );
		should_wait = true; // ^^ that's expensive

		if ( canSee )
		{
			validTargets[ validTargets.size ] = testTarget;
		}
	}

	best = pick_a_target_from( validTargets, origin, forward, weapon.lockOnMinRange, weapon.lockOnMaxRange );
	
	if (!IsDefined(best))
	{
		best = place_dummy_target( origin, forward, weapon ); 
	}
	
	return best; 
}

// target selection tuning
//   0 = only consider distance
//   1 = only consider dot product
//   anything in the middle is some mixture of the two


function get_target_score( target, origin, forward, min_range, max_range )
{
	if ( !IsDefined( target ) )
		return -1;
	
	if ( is_valid_target( target ) )
	{
		testOrigin = get_target_lock_on_origin( target );
		normal = VectorNormalize( testOrigin - origin );
		dot = VectorDot( forward, normal );
		targetDistance =  Distance( self.origin, testOrigin );
		distance_score = 1-((targetDistance - min_range) / (max_range - min_range));
		
		
		return pow(dot,0.5) * pow(distance_score,1-0.5);
	}
	
	return -1;
}



function pick_a_target_from( targets, origin, forward, min_range, max_range )
{
	if ( !IsDefined( targets ) )
		return undefined;

	bestTarget = undefined;
	bestScore = undefined;
	
	for ( i = 0; i < targets.size; i++ )
	{
		target = targets[i];
		
		if ( is_valid_target( target ) )
		{
			score = get_target_score( target, origin, forward, min_range, max_range );
			
			if ( !IsDefined( bestTarget ) || !IsDefined( bestScore ) )
			{
				bestTarget = target;
				bestScore = score;
			}
			else if ( score > bestScore )
			{
				bestTarget = target;
				bestScore = score;
			}
		}
	}
	return bestTarget;
}

function trace( from, to, target )
{
	return bullettrace(from,to, false, self, true, false, target )[ "position" ];
	//return PlayerPhysicsTrace( start, end );
}



function can_see( target, target_origin, player_origin, player_forward, distance )
{
	start = player_origin + player_forward * distance; 
	end = target_origin - player_forward * distance; 
	
	collided = self trace( start, end, target );
	
	if ( Distance2DSquared(end,collided) > 3 * 3 )
	{
		/#
			//Line(start,collided,(0,0,1),1,0,50);
			//Line(collided,end,(1,0,0),1,0,50);
		#/
		return false;
	}

	/# 
		//Line(start,end,(0,1,0),1,0,30); 
	#/
	return true;
}

function is_valid_target( ent )
{
	if ( IsDefined( ent ) && IsDefined( level.grapple_valid_target_check ) )
	{
		if ( ![[level.grapple_valid_target_check]](ent) )
			return false;
	}
	return IsDefined( ent ) && ( IsAlive( ent ) || !IsSentient(ent) );
}

function inside_screen_angles( testOrigin, weapon, newtarget )
{
	hang = weapon.lockonlossanglehorizontal; 
	if ( newtarget )
		hang = weapon.lockonanglehorizontal; 
	vang = weapon.lockonlossanglevertical; 
	if ( newtarget )
		vang = weapon.lockonanglevertical; 

	angles = self GetTargetScreenAngles( testOrigin );	

	return abs(angles[0]) < hang && abs(angles[1]) < vang; 
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

function get_target_lock_on_origin( target )
{
	return self GetLockOnOrigin( target );	
}

	



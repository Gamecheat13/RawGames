#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;

MeleeCombat()
{
	self endon( "end_melee" );
 	self endon("killanimscript");

	assert( CanMeleeAnyRange() );

	self OrientMode("face enemy");
	
	self AnimMode( "zonly_physics" );
	
    for ( ;; )
    {
		// Don't attack if you're supposed to die but can't because of the network
		if ( IsDefined(self.marked_for_death) )
		{
			return;
		}

		// we should now be close enough to melee.
		
		if( IsDefined( self.enemy ) )
		{
			angles = VectorToAngles( self.enemy.origin - self.origin );
			self OrientMode( "face angle", angles[1] );
		}

		if ( isdefined( self.zmb_vocals_attack ) )
		{
			self PlaySound( self.zmb_vocals_attack );
		}
		
		if ( is_true( self.noChangeDuringMelee ) )
		{
			self.safeToChangeScript = false;
		}

		if ( is_true( self.is_inert ) )
		{
			return;
		}

		set_zombie_melee_anim_state( self );

		if ( isDefined( self.melee_anim_func ) )
		{
			self thread [[ self.melee_anim_func ]]();
		}
		
		while ( 1 )
		{
			self waittill( "melee_anim", note );
			if ( note == "end" )
			{
				break;
			}
			else if ( note == "fire" )
			{
				if ( !IsDefined( self.enemy ) )
				{
					break;
				}
					
				oldhealth = self.enemy.health;
				self melee();

				if ( !IsDefined( self.enemy ) )
				{
					break;
				}

				if ( self.enemy.health >= oldhealth )
				{
					if ( isDefined( self.melee_miss_func ) )
					{
						self [[ self.melee_miss_func ]]();
					}
					else if ( isDefined( level.melee_miss_func ) )
					{
						self [[ level.melee_miss_func ]]();
					}
				}
			}
			else if ( note == "stop" )
			{
				// check if it's worth continuing with another melee.
				if ( !CanContinueToMelee() ) // "if we can't melee without charging"
				{
					break;
				}
			}
		}
		
		self OrientMode("face default");

		if ( is_true( self.noChangeDuringMelee ) )
		{
			if ( isDefined( self.enemy ) )
			{
				dist_sq = DistanceSquared( self.origin, self.enemy.origin );
				if ( dist_sq > self.meleeAttackDist * self.meleeAttackDist )
				{
					self.safeToChangeScript = true;
					wait_network_frame();
					break;
				}
			}
			else
			{
				self.safeToChangeScript = true;
				wait_network_frame();
				break;
			}
		}
    }
	
	self AnimMode("none");
	
	self thread maps\mp\animscripts\zm_combat::main();
}

CanContinueToMelee()
{
	return CanMeleeInternal( "already started" );
}

CanMeleeAnyRange()
{
	return CanMeleeInternal( "any range" );
}

CanMeleeDesperate()
{
	return CanMeleeInternal( "long range" );
}

CanMelee()
{
	return CanMeleeInternal( "normal" );
}

CanMeleeInternal( state )
{
	// no meleeing virtual targets
	if ( !IsSentient( self.enemy ) )
	{
		return false;
	}

	// or dead ones
	if (!IsAlive(self.enemy))
	{
		return false;
	}
	
	if ( IsDefined( self.disableMelee ) )
	{
		assert( self.disableMelee ); // must be true or undefined
		return false;
	}
	
	// if we're not at least partially facing the guy, wait until we are
	yaw = abs(getYawToEnemy());
	if ( (yaw > 60 && state != "already started") || yaw > 110 )
	{
		return false;
	}
	
	enemyPoint = self.enemy GetOrigin();
	vecToEnemy = enemyPoint - self.origin;
	self.enemyDistanceSq = lengthSquared( vecToEnemy );

	if (self.enemyDistanceSq <= anim.meleeRangeSq)
	{
		if ( !isMeleePathClear( vecToEnemy, enemyPoint ) )
		{
			return false;
		}

		// Enemy is already close enough to melee.
		return true;
	}

	if ( state != "any range" )
	{
		chargeRangeSq = anim.chargeRangeSq;
		if ( state == "long range" )
		{
			chargeRangeSq = anim.chargeLongRangeSq;
		}

		if (self.enemyDistanceSq > chargeRangeSq)
		{
			// Enemy isn't even close enough to charge.
			return false;
		}
	}

	if ( state == "already started" ) // if we already started, we're checking to see if we can melee *without* charging.
	{
		return false;
	}

	// at this point, we can melee iff we can charge.

	if ( is_true( self.check_melee_path ) )
	{
		if( !isMeleePathClear( vecToEnemy, enemyPoint ) )
		{
			self notify("melee_path_blocked");
			return false;
		}
	}
	
	return true;
}

isMeleePathClear( vecToEnemy, enemyPoint )
{
	dirToEnemy = VectorNormalize( (vecToEnemy[0], vecToEnemy[1], 0 ) );
	meleePoint = enemyPoint - ( dirToEnemy[0]*28, dirToEnemy[1]*28, 0 );

	if ( !self IsInGoal( meleePoint ) )
	{
		return false;
	}

	if ( self maymovetopoint(meleePoint) )
	{
		return true;
	}

	// we're within melee distance and the melee point is within our goalradius
	// BUT we cannot move to the point with a capsule trace
	// what if we do a sight trace from the knees/eye position.  
	trace1 = bullettrace( self.origin + (0,0,20), meleePoint + (0,0,20), true, self );
	trace2 = bullettrace( self.origin + (0,0,72), meleePoint + (0,0,72), true, self );

	//see if we hit anything at all?
	if ( isDefined(trace1["fraction"]) && trace1["fraction"] == 1  &&
			 isDefined(trace2["fraction"]) && trace2["fraction"] == 1 	)
	{	//clear traces (value == 1), room to move?
		return true;
	}
	//trace contacted something, was it the player?
	if ( isDefined(trace1["entity"]) && trace1["entity"] == self.enemy  &&
			 isDefined(trace2["entity"]) && trace2["entity"] == self.enemy 	)
	{
		return true;
	}

	// knees in water / eyes clear
	if ( is_true( level.zombie_melee_in_water ) )
	{
		if ( isDefined( trace1["surfacetype"] ) && trace1["surfacetype"] == "water" &&
			 isDefined( trace2["fraction"] ) && trace2["fraction"] == 1 )
		{
			return true;
		}
	}

	return false;
}

set_zombie_melee_anim_state( zombie )
{
	if ( !zombie.has_legs && zombie.a.gib_ref == "no_legs" )
	{
		// if zombie have no legs whatsoever.
		melee_anim_state = "zm_stumpy_melee";
	}
	else
	{
		switch ( zombie.zombie_move_speed )
		{
		case "walk":
			melee_anim_state = append_missing_legs_suffix( "zm_walk_melee" );
			break;

		case "run":			
		case "sprint":
		default:
			melee_anim_state = append_missing_legs_suffix( "zm_run_melee" );
			break;			
		}
	}

	zombie SetAnimStateFromASD( melee_anim_state );
}

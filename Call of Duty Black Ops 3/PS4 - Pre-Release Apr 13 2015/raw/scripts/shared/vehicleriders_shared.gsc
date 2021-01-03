#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
       

                                                              	   	                             	  	                                      















	
#using_animtree( "generic" );

#namespace amws;

function autoexec __init__sytem__() {     system::register("amws",&__init__,undefined,undefined);    }

function __init__()
{	
	vehicle::add_main_callback( "amws", &amws_initialize );
}

function amws_initialize()
{
	self UseAnimTree( #animtree );
	
	Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 40 );
	
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0.574;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	assert( isdefined( self.scriptbundlesettings ) );

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	self.goalRadius = 999999;
	self.goalHeight = 512;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );

	//self.waittime_before_delete = 40;
	self.delete_on_death = false;
	
	self.overrideVehicleDamage = &drone_callback_damage;

	self thread vehicle_ai::nudge_collision();

	self.variant = "light_weight";
	if( IsSubStr( self.vehicleType, "pamws" ) )
	{
		self.variant = "armored";
	}

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    
    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;

	self vehicle_ai::StartInitialState( "combat" );
}

function state_death_update( params )
{
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	
	bad_place_name = self.archetype + self GetEntityNumber();
	
	BadPlace_Box( bad_place_name, 0, self.origin, 30, "neutral" );
	self NotSolid();
	
	self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	if(isDefined(self))
	{
		owner = self GetVehicleOwner();
		if(isDefined(owner))
		{
			wait 4; //let player see some destruction
			if(isDefined(self))
			{
				sanity = self GetVehicleOwner();
				if (isDefined(sanity) && isDefined(owner) && sanity == owner)
				{
					owner unlink();
					wait 1;
				}
			}
		}
	}
	if(isDefined(self))
	{
		self FreeVehicle();
	}
	
	// let the corpse sit around a while
	wait 50;
	
	if( isdefined( self ) )
		self Delete();
	
	BadPlace_Delete( bad_place_name );
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_enter( params )
{
	self thread turretFireUpdate();
}

function turretFireUpdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	while( 1 )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.engagementDistMax * 3) * (self.settings.engagementDistMax * 3) ) ) 
			{
				self SetGunnerTargetEnt( self.enemy, (0,0,0), 2 );
				self vehicle_ai::fire_for_time( RandomFloatRange( 0.6, 1.2 ), 1, self.enemy );
			}
			
			if( isdefined( self.enemy ) && IsAI( self.enemy ) )
			{
				wait( RandomFloatRange( 2, 2.5 ) );
			}
			else
			{
				wait( RandomFloatRange( 0.5, 1.5 ) );
			}
		}
		else
		{
			wait 0.4;
		}
	}
}

function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	lastTimeChangePosition = 0;
	self.shouldGotoNewPosition = false;
	self.lastTimeTargetInSight = 0;

	for( ;; )
	{
		self SetSpeed( self.settings.defaultMoveSpeed );
		
		if ( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait 0.1;
		}
		else if ( !IsDefined( self.enemy ) )
		{
			self.current_pathto_pos = GetNextMovePosition_wander();

			if ( IsDefined( self.current_pathto_pos ) )
			{
				if ( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
				{
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					self playsound ("veh_amws_scan");
				}
			}
			wait 0.5;
		}
		else
		{
			self SetTurretTargetEnt( self.enemy );

			if ( GetTime() > lastTimeChangePosition + 1000 * 1.0 )
			{
				self.shouldGotoNewPosition = true;
			}
			else if ( self vehCanSee( self.enemy ) )
			{
				self.lastTimeTargetInSight = GetTime();
			}
			else if ( GetTime() > self.lastTimeTargetInSight + 1000 * 0.5 )
			{
				self.shouldGotoNewPosition = true;
			}

			if ( self.shouldGotoNewPosition )
			{
				self.current_pathto_pos = GetNextMovePosition_tactical( self.enemy );

				if ( IsDefined( self.current_pathto_pos ) )
				{
					if ( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
					{
						self thread path_update_interrupt();
						self vehicle_ai::waittill_pathing_done();
					}

					if ( isdefined( self.enemy ) && vehicle_ai::IsCooldownReady( "rocket_launcher", 0.5 ) && self VehCanSee( self.enemy ) )
					{
						wait 0.4;
						if ( isdefined( self.enemy ) && Distance2DSquared( self.origin, self.enemy.origin ) > ( (350) * (350) ) )
						{
							self FireRocketLauncher( self.enemy );
							vehicle_ai::Cooldown( "rocket_launcher", 5 );
						}
					}

					lastTimeChangePosition = GetTime();
					self.shouldGotoNewPosition = false;
				}
			}

			wait 0.5;
		}
	}
}

function FireRocketLauncher( enemy, fireEvenCannotSee )
{
	target = undefined;
	offset = (0,0,0);

	if ( isEntity( enemy ) )
	{
		if( ( isdefined( fireEvenCannotSee ) && fireEvenCannotSee ) || self VehCanSee( enemy ) )
		{
			target = enemy;
		}
		else if( isdefined( self.enemylastseenpos ) && ( !isdefined( self.enemy ) || enemy == self.enemy ) )
		{
			target = self.enemylastseenpos;
		}
		else
		{
			target = enemy;
		}
	}
	else if ( isVec( enemy ) )
	{
		target = enemy;
	}

	if ( isdefined( target ) )
	{
		vehicle_ai::SetTurretTarget( target, 1, offset );
		wait 0.1;
		if ( self.variant == "armored" )
		{
			vehicle_ai::fire_for_rounds( 1, 0, target );
		}
		else
		{
			vehicle_ai::fire_for_rounds( 4, 0, target );
		}
	}
}

function GetNextMovePosition_wander() // no self.enemy
{
	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	queryMultiplier = 3;

	queryResult = PositionQuery_Source_Navigation( self.origin, 80, 500 * queryMultiplier, 0.5 * 500, 4 * 20 * queryMultiplier, self, 2 * 20 * queryMultiplier );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );

	best_point = undefined;
	best_score = -999999;

	foreach ( point in queryResult.data )
	{
		randomScore = randomFloatRange( 0, 100 );
		distToOriginScore = point.distToOrigin2D * 0.2;

		if( point.inClaimedLocation )
		{
			point.score -= 500;
		}

		point.score += randomScore + distToOriginScore;
		
		if ( point.score > best_score )
		{
			best_score = point.score;
			best_point = point;
		}
	}

	if( !isdefined( best_point ) )
	{
		return undefined;
	}
	
	return best_point.origin;
}

function GetNextMovePosition_tactical( enemy )
{
	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	// distance based multipliers
	selfDistToTarget = Distance2D( self.origin, enemy.origin );

	goodDist = 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax );

	tooCloseDist = ( 0.8 * 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) );
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;

	queryMultiplier = MapFloat( closeDist, farDist, 1, 3, selfDistToTarget );
	preferedDirectness = 0;
	if ( selfDistToTarget > goodDist )
	{
		preferedDirectness = MapFloat( closeDist, farDist, 0, 1, selfDistToTarget );
	}
	else
	{
		preferedDirectness = MapFloat( tooCloseDist * 0.4, tooCloseDist, -1, -0.6, selfDistToTarget );
	}

	preferedDistAwayFromOrigin = 300;
	randomness = 30;

	// query
	queryResult = PositionQuery_Source_Navigation( self.origin, 80, 500 * queryMultiplier, 0.5 * 500, 3 * 20 * queryMultiplier, self, 1 * 20 * queryMultiplier );

	// filter
	PositionQuery_Filter_Directness( queryResult, self.origin, enemy.origin );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );
	vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );

	if ( isdefined( self.avoidEntities ) && isdefined( self.avoidEntitiesDistance ) )
	{
		vehicle_ai::PositionQuery_Filter_DistAwayFromTarget( queryResult, self.avoidEntities, self.avoidEntitiesDistance, -500 );
	}

	// score points
	best_point = undefined;
	best_score = -999999;

	foreach ( point in queryResult.data )
	{
		// directness
		diffToPreferedDirectness = abs( point.directness - preferedDirectness );
		directnessScore = MapFloat( 0, 1, 100, 0, diffToPreferedDirectness );
		if ( diffToPreferedDirectness > 0.2 )
		{
			directnessScore -= 200;
		}
		point vehicle_ai::AddScore( "directnessRaw", point.directness );
		point vehicle_ai::AddScore( "directness", directnessScore );

		// distance from origin
		point vehicle_ai::AddScore( "distToOrigin", MapFloat( 0, preferedDistAwayFromOrigin, 0, 100, point.distToOrigin2D ) );

		// distance to target
		targetDistScore = 0;
		if ( point.targetDist < tooCloseDist )
		{
			targetDistScore -= 200;
		}

		if( point.inClaimedLocation )
		{
			point vehicle_ai::AddScore( "inClaimedLocation", -500 );
		}

		point vehicle_ai::AddScore( "distToTarget", targetDistScore );

		point vehicle_ai::AddScore( "random", randomFloatRange( 0, randomness ) );

		if ( point.score > best_score )
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	if( !isdefined( best_point ) )
	{
		return undefined;
	}

	/#
	if ( ( isdefined( GetDvarInt("hkai_debugPositionQuery") ) && GetDvarInt("hkai_debugPositionQuery") ) )
	{
		recordLine( self.origin, best_point.origin, (0.3,1,0) );
		recordLine( self.origin, enemy.origin, (1,0,0.4) );
	}
#/

	return best_point.origin;
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait 1;
	
	while( 1 )
	{
		if( isdefined( self.current_pathto_pos ) )
		{
			if( distance2dSquared( self.current_pathto_pos, self.goalpos ) > ( (self.goalradius) * (self.goalradius) ) )
			{
				wait 0.2;
				self notify( "near_goal" );
			}
		}

		if ( isdefined( self.enemy ) )
		{
			if( self VehCanSee( self.enemy ) && distance2dSquared( self.origin, self.enemy.origin ) < ( (( 0.8 * 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) )) * (( 0.8 * 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) )) ) )
			{
				self notify( "near_goal" );
			}

			if ( vehicle_ai::IsCooldownReady( "rocket_launcher" ) && vehicle_ai::IsCooldownReady( "rocket_launcher_check" ) )
			{
				vehicle_ai::Cooldown( "rocket_launcher_check", 2.5 );
				self notify( "near_goal" );
			}
		}
		
		wait 0.2;
	}
}

function drone_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}

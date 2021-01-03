#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
       
                                                                                                             	   	

                                                              	   	                             	  	                                      















	
 //tolerance around swap angle to prevent jittering between cameras
 //angle at which camera vehicle should swap between above and below (pos is pointing down)

#using_animtree( "generic" );
	
#namespace wasp;

function autoexec __init__sytem__() {     system::register("wasp",&__init__,undefined,undefined);    }

function __init__()
{	
	vehicle::add_main_callback( "wasp", &wasp_initialize );
}

function wasp_initialize()
{
	self UseAnimTree( #animtree );
	
	Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 40 );
	
	//self SetVehicleAvoidance( true ); // this is ORCA avoidance

	self SetHoverParams( 50.0, 100.0, 100.0 );
	
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	assert( isdefined( self.scriptbundlesettings ) );

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	
	self.overrideVehicleDamage = &drone_callback_damage;
	self.allowFriendlyFireDamageOverride = &drone_AllowFriendlyFireDamage;

	self thread vehicle_ai::nudge_collision();

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    //self vehicle_ai::get_state_callbacks( "death" ).update_func = &vehicle_death::flipping_shooting_death;
    
    self vehicle_ai::get_state_callbacks( "scripted" ).update_func = &wasp_scripted;
    self vehicle_ai::get_state_callbacks( "driving" ).update_func = &wasp_scripted;

	vehicle_ai::StartInitialState( "combat" );
}

// ----------------------------------------------
// State: death
// ----------------------------------------------
function state_death_update( params )
{
	self endon( "death" );

	doGibbedDeath = false;
	
	if( isdefined( self.death_info ) )
	{
		if( isdefined( self.death_info.weapon ) )
		{
			if( self.death_info.weapon.doannihilate )
			{
				doGibbedDeath = true;
			}
			else if( self.death_info.weapon.dogibbing && isdefined( self.death_info.attacker ) )
			{
				dist = Distance( self.origin, self.death_info.attacker.origin );
				if( dist < self.death_info.weapon.maxgibdistance )
				{
					gib_chance = 1.0 - ( dist / self.death_info.weapon.maxgibdistance );
					//if( RandomFloatRange( 0.0, 1.0 ) < gib_chance )
					if( RandomFloatRange( 0.0, 2.0 ) < gib_chance )	// less chance for now, weapons are tuned to gib too much
					{
						doGibbedDeath = true;
					}
				}
			}
		}
		if( isdefined( self.death_info.meansOfDeath ) )
		{
			meansOfDeath = self.death_info.meansOfDeath;
			if( meansOfDeath == "MOD_EXPLOSIVE" || meansOfDeath == "MOD_GRENADE_SPLASH" || meansOfDeath == "MOD_PROJECTILE_SPLASH" || meansOfDeath == "MOD_PROJECTILE" )
			{
				doGibbedDeath = true;
			}
		}
	}
	
	if( doGibbedDeath )
	{
		if ( isdefined( self.settings.gibbedexplosionfx ) )
		{
			if( self.vehicletype != "spawner_bo3_cybercom_firefly" )
			{
				self playsound ("veh_wasp_gibbed");
			}
			PlayFxOnTag( self.settings.gibbedexplosionfx, self, "tag_origin" );
			self Ghost();
			self NotSolid();
		}
		wait 0.3;	// wait for the fx to finish, once we delete the fx will go away
		if( isdefined( self ) )
		{
			self Delete();
		}
	}
	else
	{
		self vehicle_death::flipping_shooting_death( params.attacker, params.dir );
	}
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_enter( params )
{
	if ( IsDefined( self.owner ) && IsDefined( self.owner.enemy ) )
	{
		self.favoriteEnemy = self.owner.enemy;
	}

	self thread turretFireUpdate();
}

function turretFireUpdate()
{
	self endon( "death" );
	self endon( "change_state" );

	isRocketType = IsSubStr( self.vehicleType, "_rocket_" );
	
	while( 1 )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) * 3) * (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) * 3) ) ) 
			{
				self SetTurretTargetEnt( self.enemy );
				
				if( isRocketType )
				{
					for( i = 0; i < 4 && isdefined( self.enemy ); i++ )
					{
						self FireWeapon( 0, self.enemy );
						fired = true;
						wait 0.25;
					}
				}
				else
				{
					self vehicle_ai::fire_for_time( RandomFloatRange( 0.3, 0.6 ) );
				}
			}

			if( isRocketType )
			{
				if( isdefined( self.enemy ) && IsAI( self.enemy ) )
				{
					wait( RandomFloatRange( 4, 7 ) );
				}
				else
				{
					wait( RandomFloatRange( 3, 5 ) );
				}
			}
			else
			{
				if( isdefined( self.enemy ) && IsAI( self.enemy ) )
				{
					wait( RandomFloatRange( 2, 2.5 ) );
				}
				else
				{
					wait( RandomFloatRange( 0.5, 1.5 ) );
				}
			}
		}
		else
		{
			wait 0.4;
		}
	}
}


function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	old_enemy = self.enemy;
	
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
			if( !isdefined( old_enemy ) )
			{
				self notify( "near_goal" );		// new enemy
			}
			else if( self.enemy != old_enemy )
			{
				self notify( "near_goal" );		// new enemy
			}
			
			if( self VehCanSee( self.enemy ) && distance2dSquared( self.origin, self.enemy.origin ) < ( (250) * (250) ) )
			{
				self notify( "near_goal" );
			}
		}
		
		wait 0.2;
	}
}

function wait_till_something_happens( timeout )
{
	self endon( "change_state" );
	self endon( "death" );
	
	wait 0.1;
	
	time = timeout;
	cant_see_count = 0;
	
	while( time > 0 ) 
	{	
		if( isdefined( self.current_pathto_pos ) )
		{
			if( distanceSquared( self.current_pathto_pos, self.goalpos ) > ( (self.goalradius) * (self.goalradius) ) )
			{
				break;
			}
		}
		
		if( isdefined( self.enemy ) )
		{
			if ( !self vehCanSee( self.enemy ) )
			{
				cant_see_count++;
				if( cant_see_count >= 3 )
				{
					break;
				}
			}
			else
			{
				cant_see_count = 0;
			}
			
			if( distance2dSquared( self.origin, self.enemy.origin ) < ( (250) * (250) ) )
			{
				break;
			}
		
			// height check
			goalHeight = self.enemy.origin[2] + 0.5 * ( self.settings.engagementHeightMin + self.settings.engagementHeightMax );
			distFromPreferredHeight = abs( self.origin[2] - goalHeight );
			if ( distFromPreferredHeight > 100 )
			{
				break;
			}
		
			if( isplayer( self.enemy ) && self.enemy islookingat( self ) )
			{
				if ( math::cointoss() )
				{
					wait RandomFloatRange( 0.1, 0.5 );
				}

				self drop_leader();	// gotta move away fast, we'll pick him up again in a bit
				break;
			}
		}
		
		if( isdefined( self.leader ) && isdefined( self.leader.current_pathto_pos ) )
		{
			if( distanceSquared( self.origin, self.leader.current_pathto_pos ) > ( (140 + 25) * (140 + 25) ) )
			{
				//wait RandomFloatRange( 0.1, 0.3 );
				break;
			}
		}
		
		wait 0.3;
		time -= 0.3;
	}
}

function drop_leader()
{
	if( isdefined( self.leader ) )
	{
		ArrayRemoveValue( self.leader.followers, self );
		self.leader = undefined;
	}
}

function update_leader()
{
	if( isdefined( self.leader ) )
	{
		return;	// already have a leader
	}
	
	if( isdefined( self.followers ) )
	{
		self.followers = array::remove_dead( self.followers, false );
		if( self.followers.size > 0 )	// we are a leader
		{
			return;
		}
	}
	
	team_mates = GetAITeamArray( self.team );
	
	foreach( guy in team_mates )
	{
		if( isdefined( guy.archetype ) && guy.archetype == "wasp" )
		{
			if( isdefined( guy.leader ) )
			{
				continue;	// guy is already a follower
			}
			
			if( guy == self )
			{
				continue;
			}
			
			if( distanceSquared( self.origin, guy.origin ) > ( (700) * (700) ) )
			{
				continue;	// guy too far
			}
			
			if( !isdefined( guy.followers ) )
			{
				guy.followers = [];
			}
			
			if( guy.followers.size >= 3-1 )
			{
				continue; 	// already full group
			}
			
			// found a leader
			guy.followers[ guy.followers.size ] = self;
			self.leader = guy;
			break;
		}
	}
}

function should_fly_forward( distanceToGoalSq )
{
	if( distanceToGoalSq < ( (250) * (250) ) )
	{
		return false;
	}
	
	// always face enemy when backing away
	if( isdefined( self.enemy ) )
	{
		to_goal = VectorNormalize( self.current_pathto_pos - self.origin );
		to_enemy = VectorNormalize( self.enemy.origin - self.origin );
		
		dot = VectorDot( to_goal, to_enemy );
		if( abs( dot ) > 0.7 )
		{
			return false;
		}
	}
	
	if( distanceToGoalSq > ( (400) * (400) ) )
	{
		return RandomInt( 100 ) > 25;
	}
	
	return RandomInt( 100 ) > 50;
}

function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	// allow script to set goalpos and whatever else before moving
	wait .1;
	
	for( ;; )
	{
		self SetSpeed( self.settings.defaultMoveSpeed );
		
		self update_leader();

		if ( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait 0.1;
		}
		else if ( !IsDefined( self.enemy ) )
		{
			self ClearLookAtEnt();
			self.current_pathto_pos = GetNextMovePosition_wander();

			if ( IsDefined( self.current_pathto_pos ) )
			{
				if ( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
				{
					if( self.vehicletype != "spawner_bo3_cybercom_firefly" )
					{
						self playsound ("veh_wasp_vox");
					}
					//self playsound ("veh_wasp_direction");
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					
				}
			}
			wait 0.5;
		}
		else
		{
			self SetTurretTargetEnt( self.enemy );
			self SetLookAtEnt( self.enemy );

			self wait_till_something_happens( RandomFloatRange( 2, 5 ) );

			// make sure we still have an enemy after waiting for a bit
			if( IsDefined( self.enemy ) )
			{			
				self.current_pathto_pos = GetNextMovePosition_tactical();
	
				if ( IsDefined( self.current_pathto_pos ) )
				{
					distanceToGoalSq = DistanceSquared( self.current_pathto_pos, self.origin );
					
					if ( distanceToGoalSq > ( (15) * (15) ) )
					{
						if( distanceToGoalSq > ( (2000) * (2000) ) )
						{
							self SetSpeed( self.settings.defaultMoveSpeed * 2 );
						}
					
						if ( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
						{
							if( self.vehicletype != "spawner_bo3_cybercom_firefly" )
							{
								self playsound ("veh_wasp_direction");
							}
						
							if( should_fly_forward( distanceToGoalSq ) )
							{
								// fly foward if flying far
								self ClearLookAtEnt();
							}
							self thread path_update_interrupt();
							self vehicle_ai::waittill_pathing_done();
						}
					}
				}
			}
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

	queryResult = PositionQuery_Source_Navigation( self.origin, 80, 500 * queryMultiplier, 500, 2 * 20 * queryMultiplier, self, 20 * queryMultiplier );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );

	best_point = undefined;
	best_score = -999999;

	foreach ( point in queryResult.data )
	{
		randomScore = randomFloatRange( 0, 100 );
		distToOriginScore = point.distToOrigin2D * 0.2;

		point.score += randomScore + distToOriginScore;
		point vehicle_ai::AddScore( "distToOrigin", distToOriginScore );
		
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

	return best_point.origin;
}

function GetNextMovePosition_tactical() // has self.enemy
{
	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	if( !isdefined( self.enemy ) ) 
	{
		return self GetNextMovePosition_wander();
	}
	
	// distance based multipliers
	selfDistToTarget = Distance2D( self.origin, self.enemy.origin );

	goodDist = 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax );

	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;

	queryMultiplier = MapFloat( closeDist, farDist, 1, 3, selfDistToTarget );
	
	preferedHeightRange = 35;
	randomness = 30;

	avoid_locations = [];
	avoid_radius = 50;
	
	// query
	if( isdefined( self.leader ) && isdefined( self.leader.current_pathto_pos ) )
	{
		query_position = self.leader.current_pathto_pos;
		
		queryResult = PositionQuery_Source_Navigation( query_position, 0, 140, 100, 35, self, 25 );
		
		/*foreach( guy in self.leader.followers )
		{
			if( isdefined( guy ) && guy != self )
			{
				if( isdefined( guy.current_pathto_pos ) )
				{
					avoid_locations[ avoid_locations.size ] = guy.current_pathto_pos;
				}
			}
		}*/
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation( self.origin, 0, 500 * queryMultiplier, 130, 2 * 20 * queryMultiplier, self, 2.2 * 20 * queryMultiplier );
		
		team_mates = GetAITeamArray( self.team );
		
		avoid_radius = 140;
	
		foreach( guy in team_mates )
		{
			if( isdefined( guy.archetype ) && guy.archetype == "wasp" )
			{
				// avoid other leaders if we are a leader
				if( isdefined( guy.followers ) &&  guy.followers.size > 0 && guy != self )
				{
					if( isdefined( guy.current_pathto_pos ) )
					{
						avoid_locations[ avoid_locations.size ] = guy.current_pathto_pos;
					}
				}
			}
		}
	}

	//If there are no data points to query for points to path to, then just return out undefined
	if(queryResult.data.size == 0)
	{
		return undefined;
	}
	
	// filter
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
	self vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );
	self vehicle_ai::PositionQuery_Filter_EngagementHeight( queryResult, self.enemy, self.settings.engagementHeightMin, self.settings.engagementHeightMax );
	
	// score points
	best_point = undefined;
	best_score = -999999;

	foreach ( point in queryResult.data )
	{
		point vehicle_ai::AddScore( "random", randomFloatRange( 0, randomness ) );
		
		point vehicle_ai::AddScore( "engagementDist", -point.distAwayFromEngagementArea );
		point vehicle_ai::AddScore( "height", -point.distEngagementHeight );

		if( point.disttoorigin2d < 120 )
		{
			point vehicle_ai::AddScore( "tooCloseToSelf", (120 - point.disttoorigin2d) * -1.5 );
		}
		
		foreach( location in avoid_locations )
		{
			if( distanceSquared( point.origin, location ) < ( (avoid_radius) * (avoid_radius) ) )
			{
				point vehicle_ai::AddScore( "tooCloseToOthers", -avoid_radius );
			}
		}

		if( point.inClaimedLocation )
		{
			point vehicle_ai::AddScore( "inClaimedLocation", -500 );
		}

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
		recordLine( self.origin, self.enemy.origin, (1,0,0.4) );
	}
#/
	
	return best_point.origin;
}



// ----------------------------------------------
// pain/hit reaction
// ----------------------------------------------
function drone_pain_for_time( time, stablizeParam, restoreLookPoint )
{
	self endon( "death" );
	
	self.painStartTime = GetTime();

	if ( !( isdefined( self.inpain ) && self.inpain ) )
	{
		self.inpain = true;

		while ( GetTime() < self.painStartTime + time * 1000 )
		{
			self SetVehVelocity( self.velocity * stablizeParam );
			self SetAngularVelocity( self GetAngularVelocity() * stablizeParam );
			wait 0.1;
		}

		if ( isdefined( restoreLookPoint ) )
		{
			restoreLookEnt = Spawn( "script_model", restoreLookPoint );
			restoreLookEnt SetModel( "tag_origin" );

			self ClearLookAtEnt();
			self SetLookAtEnt( restoreLookEnt );
			self setTurretTargetEnt( restoreLookEnt );
			wait 1.5;

			self ClearLookAtEnt();
			self ClearTurretTarget();
			restoreLookEnt delete();
		}

		self.inpain = false;
	}
}

function drone_pain( eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName )
{
	if ( !( isdefined( self.inpain ) && self.inpain ) )
	{
		yaw_vel = math::randomSign() * RandomFloatRange( 280, 320 );

		ang_vel = self GetAngularVelocity();
		ang_vel += ( RandomFloatRange( -120, -100 ), yaw_vel, RandomFloatRange( -200, 200 ) );
		self SetAngularVelocity( ang_vel );

		self thread drone_pain_for_time( 0.8, 0.7 );
	}
}

function drone_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( eAttacker ) && isdefined( eAttacker.team ) && eAttacker.team != self.team )
	{
		drone_pain( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );
	}

	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}

function drone_AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if ( isdefined( eAttacker ) && isdefined( eAttacker.archetype ) && isdefined( sMeansOfDeath )
		 && eAttacker.archetype == "wasp" && sMeansOfDeath == "MOD_EXPLOSIVE" )
	{
		return true;
	}

	return false;
}

// ----------------------------------------------
// State: scripted
// ----------------------------------------------

function wasp_scripted( params )
{
	self endon( "change_state" );
	
	driver = self GetSeatOccupant( 0 );
	
	if( isPlayer( driver ) && isDefined( self.playerDrivenVersion) )
	{
		self thread wasp_manage_camera_swaps();
	}
	
}

function wasp_manage_camera_swaps()
{
	self endon ( "death" );
	self endon ( "change_state" );
	
	driver = self GetSeatOccupant( 0 );
	
	driver endon( "disconnect" );
	
	cam_low_type = self.vehicletype;
	cam_high_type = self.playerDrivenVersion;
	
// TODO - commenting out camera swap functionality while we test first person camera	
	
//	while( isdefined( driver ) )
//	{
//		WAIT_SERVER_FRAME;
//		if( IS_TRUE(self.blockTween))
//			continue;
//		
//		driver_angles = driver getPlayerAngles();
//		driver_pitch = driver_angles[0];
//		wasp_height = self wasp_get_height();
//		
//		// pitch goes from 0 to 360, this converts it from -180 to pos 180
//		if( driver_pitch > 180 )
//		{
//			driver_pitch = driver_pitch - 360;
//		}
//		
//		if( self.vehicletype == cam_low_type )
//		{
//			if( driver_pitch < WASP_SWAP_CAM_ANGLE - WASP_SWAP_CAM_THRESHOLD || wasp_height < 70 )
//			{
//				//swap from camera below vehicle to camera above vehicle
//				driver StartCameraTween( 0.65 );
//				wait 0.05;
//				self setvehicletype( cam_high_type );
//			}
//		}
//		
//		if( self.vehicletype == cam_high_type && driver_pitch > WASP_SWAP_CAM_ANGLE + WASP_SWAP_CAM_THRESHOLD && wasp_height > 90 )
//		{
//			//swap from camera above vehicle to camera below vehicle
//			driver StartCameraTween( 0.65 );
//			wait 0.05;
//			self setvehicletype( cam_low_type );
//		}
//	}
	
}
function wasp_get_height()
{
	start_origin = self.origin + self GetVelocity() * 0.2;
	//gets distance from wasp origin to the nearest geo below it
	trace = BulletTrace( start_origin + (0,0,50), start_origin + ( 0, 0, -200 ), false, self, true );
	return Distance( start_origin, trace[ "position" ] );
}
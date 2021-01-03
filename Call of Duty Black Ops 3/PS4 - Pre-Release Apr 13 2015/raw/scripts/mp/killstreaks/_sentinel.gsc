#using scripts\codescripts\struct;

#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
       
                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                            


#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\_util;
#using scripts\mp\teams\_teams;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\mp\killstreaks\_helicopter;
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#precache( "fx", "explosions/fx_vexp_wasp_gibb_death" );

#namespace sentinel;

	
function init()
{
	killstreaks::register( "sentinel", "sentinel", "killstreak_" + "sentinel", "sentinel" + "_used", &ActivateSentinel, true );
	killstreaks::register_strings( "sentinel", &"KILLSTREAK_SENTINEL_EARNED", &"KILLSTREAK_SENTINEL_NOT_AVAILABLE", &"KILLSTREAK_SENTINEL_INBOUND" );
	killstreaks::register_dialog( "sentinel", "mpl_killstreak_sentinel_strt", 6, undefined, 97, 115, 97 );
	killstreaks::register_alt_weapon( "sentinel", "killstreak_remote" );
	killstreaks::register_alt_weapon( "sentinel", "sentinel_turret" );
	remote_weapons::RegisterRemoteWeapon( "sentinel", &"KILLSTREAK_SENTINEL_USE_REMOTE", &StartSentinelRemoteControl, &EndSentinelRemoteControl );
	
	level.active_sentinels = [];
	callback::on_connect( &OnPlayerConnect );

	vehicle::add_main_callback( "veh_sentinel_mp", &InitSentinel );
}

function InitSentinel()
{
	Target_Set( self, ( 0, 0, 0 ) );
	self.health = self.healthdefault;
	self.numFlares = 1;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist( ( 40 ) );
	self SetHoverParams( ( 50.0 ), ( 100.0 ), ( 100.0 ) );
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0;	//+/- 55 degrees = 110 fov
	self.vehAirCraftCollisionEnabled = true;
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	self thread vehicle_ai::nudge_collision();
	self thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("explode", "death");			// fires chaff if needed
	self thread helicopter::create_flare_ent( (0,0,-20) );
	self thread audio::vehicleSpawnContext();
	
	self.overrideVehicleDamage = &SentinelDamageOverride;
	self.selfDestruct = false;
	
	self vehicle_ai::init_state_machine_for_role( "default" );
    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
   	self vehicle_ai::get_state_callbacks( "off" ).enter_func = &state_off_enter;
   	self vehicle_ai::get_state_callbacks( "off" ).update_func = &state_off_update;
    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    self vehicle_ai::get_state_callbacks( "scripted" ).enter_func = &state_scripted_enter;
    self vehicle_ai::get_state_callbacks( "scripted" ).can_exit_func = &state_scripted_can_exit;
    
	self vehicle_ai::StartInitialState( "off" );
}
	
function state_off_enter( params )
{
}

function state_off_update( params )
{
	self endon( "change_state" );
	self endon( "death" );
	
	// allow script to set goalpos and whatever else before moving
	wait( 0.1 );
	
	while( true )
	{
		self SetSpeed( ( 20 ) );
		
		if( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait( ( 0.1 ) );
		}
		
		if( IsDefined( self.enemy ) && 
		    self VehCanSee( self.enemy ) && 
		    ( Distance2D( self.origin, self.enemy.origin ) < ( 1500 ) ) && 
		    ( Distance2D( self.origin, self.owner.origin ) < ( 750 ) ) &&
		    ( !IsPlayer(self.enemy) || !self.enemy hasPerk( "specialty_nottargetedbyairsupport" ) ) )
		{
			self vehicle_ai::set_state( "combat" );
		}
		else
		{
			self ClearLookAtEnt();
			
			self.current_pathto_pos = undefined;
			
			queryOrigin = self.owner.origin + ( 0, 0, ( 50 ) );
			queryResult = PositionQuery_Source_Navigation( queryOrigin, 
			                                               ( 50 ), 
			                                               ( 300 ), 
			                                               ( 40 ), 
			                                               ( 40 ), 
			                                               self );
			
			if( isdefined( queryResult ) )
			{
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
			
				if( isdefined( best_point ) )
				{
					self.current_pathto_pos = best_point.origin;	
				}
			}
			
			if( IsDefined( self.current_pathto_pos ) )
			{
				if( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
				{
					self playsound ("veh_wasp_vox");
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
				}
				else
				{
					self SetSpeed( ( 20 ) * 3 );
					self.current_pathto_pos = self GetClosestPointOnNavVolume( self.origin, 999999 );
					self SetVehGoalPos( self.current_pathto_pos, true, false );
					self vehicle_ai::waittill_pathing_done();
				}
			}
			
			if( !( isdefined( self.entered_playspace ) && self.entered_playspace ) )
			{
				closetNavVolPoint = self GetClosestPointOnNavVolume( self.origin, 1 );
				if( isdefined( closetNavVolPoint ) )
				{
					self notify( "sentinel_entered_playspace" );
					self.entered_playspace = true;
				}
			}
			
			wait( RandomFloatRange( ( 0.1 ), ( 0.2 ) ) );
		}
	}
}

function state_combat_enter( params )
{
	self thread TurretFireUpdate();
}

function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	// allow script to set goalpos and whatever else before moving
	wait( 0.1 );
	
	while( true )
	{
		self SetSpeed( ( 20 ) );
		
		if( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait( ( 0.1 ) );
		}
		else if( isdefined( self.enemy ) )
		{
			if( Distance2D( self.origin, self.owner.origin ) > ( 750 ) )
			{
				self ClearTargetEntity();
				self vehicle_ai::set_state( "off" );
			}
			
			self SetTurretTargetEnt( self.enemy );
			self SetLookAtEnt( self.enemy );

			self wait_till_something_happens( RandomFloatRange( 2, 5 ) );

			// make sure we still have an enemy after waiting for a bit
			if( IsDefined( self.enemy ) )
			{			
				self.current_pathto_pos = GetNextMovePosition_tactical();
				
				if( IsDefined( self.current_pathto_pos ) )
				{
					distanceToGoalSq = DistanceSquared( self.current_pathto_pos, self.origin );
					
					if( distanceToGoalSq > ( (15) * (15) ) )
					{
						if( distanceToGoalSq > ( (2000) * (2000) ) )
						{
							self SetSpeed( ( 20 ) * 2 );
						}
					
						if ( self SetVehGoalPos( self.current_pathto_pos, true, true ) )
						{
							self playsound ("veh_wasp_direction");
						
							if( should_fly_forward( distanceToGoalSq ) )
							{
								// fly foward if flying far
								self ClearLookAtEnt();
							}
							self thread path_update_interrupt();
							self vehicle_ai::waittill_pathing_done();
							continue;
						}
					}
				}
				else
				{
					self ClearTargetEntity();
					self vehicle_ai::set_state( "off" );
				}
			}
		}
		else
		{
			self vehicle_ai::set_state( "off" );
		}
	}
}

function TurretFireUpdate()
{
	self endon( "death" );
	self endon( "change_state" );

	while( true )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (0.5 * ( ( 50 ) + ( 1000 ) ) * 3) * (0.5 * ( ( 50 ) + ( 1000 ) ) * 3) ) ) 
			{
				self SetTurretTargetEnt( self.enemy );
				self vehicle_ai::fire_for_time( RandomFloatRange( ( 0.5 ), ( 3 ) ) );
			}

			wait( RandomFloatRange( ( 0.1 ), ( 0.3 ) ) );
		}
		else
		{
			wait ( 0.2 );
		}
	}
}
	
function state_death_update( params )
{
	self endon( "death" );
	doGibbedDeath = false;
	
	if( isdefined( self.death_info ) )
	{
		if( isdefined( self.death_info.weapon ) )
		{
			if( self.death_info.weapon.dogibbing || self.death_info.weapon.doannihilate )
			{
				doGibbedDeath = true;
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
		self playsound ("veh_wasp_gibbed");
		PlayFxOnTag( "explosions/fx_vexp_wasp_gibb_death", self, "tag_origin" );
		self Ghost();
		self NotSolid();
		
		wait( 5 );
		if( isdefined( self ) )
		{
			self Delete();
		}
	}
	else
	{
		self vehicle_death::flipping_shooting_death();
	}
}

function state_scripted_enter( params )
{
	self DisableAimAssist();
	self SetHeliHeightLock( true );
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	self ClearLookAtEnt();
}

function state_scripted_can_exit( params )
{
	//Allow exiting "scripted" state set the state back to combat for AI control.
	return true;
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	old_enemy = self.enemy;
	
	wait 1;
	
	while( true )
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
			
			if( self VehCanSee( self.enemy ) && Distance2dSquared( self.origin, self.enemy.origin ) < ( (( 1500 )) * (( 1500 )) ) )
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
			if( !self vehCanSee( self.enemy ) )
			{
				cant_see_count++;
				if( cant_see_count >= 3 )
				{
					self ClearTargetEntity();
					self vehicle_ai::set_state( "off" );
					break;
				}
			}
			else
			{
				cant_see_count = 0;
			}
			
			if( distance2dSquared( self.origin, self.enemy.origin ) < ( (( 1500 )) * (( 1500 )) ) )
			{
				break;
			}
		
			// height check
			goalHeight = self.enemy.origin[2] + 0.5 * ( ( 10 ) + ( 100 ) );
			distFromPreferredHeight = abs( self.origin[2] - goalHeight );
			if( distFromPreferredHeight > 100 )
			{
				break;
			}
		
			if( isplayer( self.enemy ) && self.enemy islookingat( self ) )
			{
				if( math::cointoss() )
				{
					wait RandomFloatRange( 0.1, 0.5 );
				}

				break;
			}
		}
		
		wait 0.3;
		time -= 0.3;
	}
}

function should_fly_forward( distanceToGoalSq )
{
	if( distanceToGoalSq < ( (250) * (250) ) )
	{
		return false;
	}
	
	if( isdefined( self.enemy ) )	// always face enemy when backing away
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

function GetNextMovePosition_tactical()
{
	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	// distance based multipliers
	selfDistToTarget = Distance2D( self.origin, self.enemy.origin );
	goodDist = 0.5 * ( ( 50 ) + ( 1000 ) );
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;

	queryMultiplier = MapFloat( closeDist, farDist, 1, 3, selfDistToTarget );
	
	preferedHeightRange = 35;
	randomness = 30;
	avoid_locations = [];
	avoid_radius = 50;
	
	queryResult = PositionQuery_Source_Navigation( self.origin, 
	                                               0, 
	                                               ( 300 ) * queryMultiplier, 
	                                               130, 
	                                               2 * ( 20 ) * queryMultiplier, 
	                                               self, 
	                                               2.2 * ( 20 ) * queryMultiplier );

	//If there are no data points to query for points to path to, then just return out undefined
	if(queryResult.data.size == 0)
	{
		return undefined;
	}
	
	// filter
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
	self vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, self.enemy, ( 50 ), ( 1000 ) );
	self vehicle_ai::PositionQuery_Filter_EngagementHeight( queryResult, self.enemy, ( 10 ), ( 100 ) );
	
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

function SentinelDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( eAttacker ) && isdefined( eAttacker.team ) && eAttacker.team != self.team )
	{
		if( weapon.isEmp )
		{
			iDamage += int( ( self.healthdefault * ( 0.5 ) ) + 0.5 );
		}
		
		drone_pain( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );
	}

	// handle rocket damage
	if ( isdefined( self.rocketDamage ) && !(self.selfDestruct) && (sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_EXPLOSIVE"))
	{
		iDamage = self.rocketDamage;
	}
	
	return iDamage;
}

function OnPlayerConnect()
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !isdefined( player.entNum ) )
	{
		player.entNum = self getEntityNumber();
	}
	
	assert( IsDefined( level.active_sentinels ) );
	level.active_sentinels[ player.entNum ] = undefined;
}

function ActivateSentinel( killstreakType )
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !IsNavVolumeLoaded() )
	{
		/# IPrintLnBold( "Error: NavVolume Not Loaded" ); #/
		self iPrintLnBold( &"KILLSTREAK_SENTINEL_NOT_AVAILABLE" );
		return false;
	}
	
	spawnPos = rcbomb::calculateSpawnOrigin( player.origin, player.angles );
	if( !isdefined( spawnPos ) )
	{
		self iPrintLnBold( &"KILLSTREAK_SENTINEL_NOT_PLACEABLE" );
		return false;
	}
	
	killstreak_id = player killstreakrules::killstreakStart( "sentinel", player.team, undefined, false );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	player AddWeaponStat( GetWeapon( "sentinel" ), "used", 1 );
	self killstreaks::play_killstreak_start_dialog( "sentinel", self.team );
	
	assert( isdefined( level.active_sentinels ) );	
	level.active_sentinels[ player.entNum ] = SpawnStruct();
	
	sentinel = player SpawnSentinel( killstreak_id, spawnPos );
	sentinel thread WatchEnableRemoteWeapon();
	
	return true;
}

function WatchEnableRemoteWeapon( player )
{
	sentinel = self;
	sentinel endon( "sentinel_shutdown" );
	
	sentinel.vehicle waittill( "sentinel_entered_playspace" );
	
	if( isdefined( sentinel.owner ) )
	{
		sentinel.owner remote_weapons::UseRemoteWeapon( sentinel, "sentinel", false );
	}
}

function SpawnSentinel( killstreak_id, spawnPos )
{
	player = self;
	assert( IsPlayer( player ) );
	playerEntNum = player.entNum;
	
	level.active_sentinels[ playerEntNum ].killstreak_id = killstreak_id;
	level.active_sentinels[ playerEntNum ].team = player.team;
	level.active_sentinels[ playerEntNum ].owner = player;
	
	level.active_sentinels[ playerEntNum ].vehicle = SpawnVehicle( "veh_sentinel_mp", spawnPos.origin + ( 0, 0, ( 50 ) ), spawnPos.angles, "dynamic_spawn_ai" );
	level.active_sentinels[ playerEntNum ].vehicle.team = player.team;
	level.active_sentinels[ playerEntNum ].vehicle SetTeam( player.team );
	level.active_sentinels[ playerEntNum ].vehicle clientfield::set( "enemyvehicle", 1 );
	level.active_sentinels[ playerEntNum ].vehicle.team = player.team;
	level.active_sentinels[ playerEntNum ].vehicle.hardpointType = "sentinel";
	level.active_sentinels[ playerEntNum ].vehicle.owner = player;
	level.active_sentinels[ playerEntNum ].vehicle SetOwner( player );
	level.active_sentinels[ playerEntNum ].vehicle.ownerEntNum = playerEntNum;
	level.active_sentinels[ playerEntNum ].vehicle.maxhealth = ( 500 );
	level.active_sentinels[ playerEntNum ].vehicle.health = ( 500 );
	level.active_sentinels[ playerEntNum ].vehicle.rocketDamage = ( ( 500 ) / ( 1 ) ) + 1;	
		
	level.active_sentinels[ playerEntNum ] thread killstreaks::WaitForTimeout( "sentinel", ( 90000 ), &OnTimeout, "sentinel_shutdown" );
	level.active_sentinels[ playerEntNum ] thread WatchDeath();
	level.active_sentinels[ playerEntNum ] thread WatchTeamChange();
	level.active_sentinels[ playerEntNum ] thread WatchShutdown();
	
	return level.active_sentinels[ playerEntNum ];
}

function StartSentinelRemoteControl( sentinel )
{
	player = self;
	assert( IsPlayer( player ) );
	
	sentinel.vehicle UseVehicle( player, 0 );
	player.killstreak_waitamount = ( 90000 );
	sentinel.vehicle thread audio::sndUpdateVehicleContext(true);
	
	sentinel.vehicle.inHeliProximity = false;
	sentinel.vehicle.parentStruct = sentinel;
	sentinel.vehicle.maxHeight = int( airsupport::getMinimumFlyHeight() ) + ( 0 );
	sentinel.vehicle thread qrdrone::QRDrone_watch_distance();
	sentinel.vehicle.distance_shutdown_override = &SentinelDistanceFailure;
}

function OnTimeout()
{
	sentinel = self;
	sentinel notify( "sentinel_shutdown" );
}

function SentinelDistanceFailure()
{
	sentinelVehicle = self;
	
	sentinel = sentinelVehicle.parentStruct;
	sentinel notify( "sentinel_shutdown" );
}

function EndSentinelRemoteControl( sentinel, exitRequestedByOwner )
{
	if( exitRequestedByOwner )
	{
		sentinel.vehicle.owner qrdrone::destroyHud();
		sentinel.vehicle.owner unlink();
		sentinel.vehicle vehicle_ai::set_state( "off" );
		sentinel.vehicle thread audio::sndUpdateVehicleContext(false);
	}
}

function WatchDeath()
{
	sentinel = self;
	
	sentinel endon( "sentinel_shutdown" );
	sentinel.vehicle waittill( "death" );
	sentinel notify( "sentinel_shutdown" );
}

function WatchTeamChange()
{
	sentinel = self;
	
	sentinel endon( "sentinel_shutdown" );
	sentinel.vehicle.owner util::waittill_any( "joined_team", "disconnect", "joined_spectators", "emp_jammed" );
	sentinel notify( "sentinel_shutdown" );
}

function WatchShutdown()
{
	sentinel = self;
	
	sentinel waittill( "sentinel_shutdown" );
	sentinel notify( "remote_weapon_shutdown" );
	
	if( isdefined( sentinel.owner ) )
	{
		sentinel.owner qrdrone::destroyHud();
		
		if( isPlayer(sentinel.owner))
		{
			level.active_sentinels[ sentinel.owner.entNum ] = undefined;
		}
	}
	
	killstreakrules::killstreakStop( "sentinel", sentinel.team, sentinel.killstreak_id );
	
	if( isdefined( sentinel.vehicle ) )
	{
		sentinel.vehicle thread audio::sndUpdateVehicleContext(false);
		sentinel.vehicle.selfDestruct = true;
		sentinel.vehicle DoDamage( sentinel.vehicle.health + 1000, sentinel.vehicle.origin, sentinel.vehicle, sentinel.vehicle, "none", "MOD_EXPLOSIVE" );	
	}
}

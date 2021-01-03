#using scripts\codescripts\struct;

#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\turret_shared;
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
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\_util;
#using scripts\mp\teams\_teams;
#using scripts\shared\weapons\_heatseekingmissile;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "fx", "explosions/fx_vexp_wasp_gibb_death" );

#namespace flak_drone;
	

	
function init()
{
	clientfield::register( "vehicle", "flak_drone_camo", 1, 3, "int" );
	
	vehicle::add_main_callback( "veh_flak_drone_mp", &InitFlakDrone );
}

function InitFlakDrone()
{
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist( ( 40 ) );
	self SetHoverParams( ( 50.0 ), ( 75.0 ), ( 100.0 ) );
	self SetVehicleAvoidance( true );
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0;	//+/- 55 degrees = 110 fov
	self.vehAirCraftCollisionEnabled = true;
	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	self thread vehicle_ai::nudge_collision();
	
	self.overrideVehicleDamage = &FlakDroneDamageOverride;
	
	self vehicle_ai::init_state_machine_for_role( "default" );
    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
   	self vehicle_ai::get_state_callbacks( "off" ).enter_func = &state_off_enter;
   	self vehicle_ai::get_state_callbacks( "off" ).update_func = &state_off_update;
    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    
	self vehicle_ai::StartInitialState( "off" );
}
	
function state_off_enter( params )
{
}

function state_off_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	while( !isdefined( self.parent ) )
	{
		wait( 0.1 ); //Wait for parent to be setup
	}
	
	self.parent endon( "death" );
	
	while( true )
	{
		self SetSpeed( ( 400 ) );
		
		if( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait( ( 0.1 ) );
		}
		
		self ClearLookAtEnt();
		
		self.current_pathto_pos = undefined;
		
		queryOrigin = self.parent.origin + ( 0, 0, ( -75 ) );
		queryResult = PositionQuery_Source_Navigation( queryOrigin, 
		                                               ( 25 ), 
		                                               ( 75 ), 
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
			if( self SetVehGoalPos( self.current_pathto_pos, true, false ) )
			{
				self playsound ("veh_wasp_vox");
			}
			else
			{
				self SetSpeed( ( 400 ) * 3 );
				self.current_pathto_pos = self GetClosestPointOnNavVolume( self.origin, 999999 );
				self SetVehGoalPos( self.current_pathto_pos, true, false );
			}
		}
		else
		{
			self SetSpeed( ( 400 ) * 3 );
			if( isDefined( self.parent.heliGoalPos ) )
			{
				self.current_pathto_pos = self.parent.heliGoalPos;
			}
			else
			{
				self.current_pathto_pos = queryOrigin;
			}
			self SetVehGoalPos( self.current_pathto_pos, true, false );
		}
			
		wait RandomFloatRange( ( .2 ), ( .3 ) );
	}
}

function state_combat_enter( params )
{
}

function state_combat_update( params )
{
	drone = self;
	drone endon( "change_state" );
	drone endon( "death" );
	
	drone thread SpawnFlakRocket( drone.incoming_missile, drone.origin, drone.parent );
	drone delete();
}

function SpawnFlakRocket( missile, spawnPos, parent )
{
	missile endon("death");
	missile Missile_SetTarget( parent );
	
	rocket = MagicBullet( GetWeapon( "flak_drone_rocket" ), spawnPos, missile.origin, parent, missile );
	rocket.team = parent.team;
	rocket setTeam( parent.team );
	rocket clientfield::set( "enemyvehicle", 1 );
	rocket Missile_SetTarget( missile );
	
	prevDist = DistanceSquared( missile.origin, rocket.origin );
	distDelta = 0;
	
	iterCount = 1;
	deltaCounter = distDelta;
	
	while( true )
	{
		{wait(.05);};
		
		curDist = DistanceSquared( missile.origin, rocket.origin );
		distDelta = prevDist - curDist;
		deltaCounter += distDelta;
		
		if( curDist < prevDist )
		{
			prevDist = curDist;
		}
		
		averageDelta = deltaCounter / iterCount;
		predictedDist = curDist - averageDelta;
		
		if( ( predictedDist < averageDelta ) || ( curDist > prevDist ) )
		{
			rocket detonate();
			missile thread heatseekingmissile::_missileDetonate( missile.target_attacker, missile.target_weapon, 500, 10, 200 );			
			return;
		}
		
		iterCount++;		
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

function FlakDroneDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( eAttacker ) && isdefined( eAttacker.team ) && eAttacker.team != self.team )
	{
		drone_pain( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );
	}

	return iDamage;
}

function Spawn( parent, onDeathCallback )
{
	if( !IsNavVolumeLoaded() )
	{
		/# IPrintLnBold( "Error: NavVolume Not Loaded" ); #/
		return undefined;
	}
	
	spawnPoint = parent.origin + ( 0, 0, -50 );
	
	drone = SpawnVehicle( "veh_flak_drone_mp", spawnPoint, parent.angles, "dynamic_spawn_ai" );
	drone.team = parent.team;
	drone SetTeam( parent.team );
	drone clientfield::set( "enemyvehicle", 1 );
	drone.parent = parent;
	drone.death_callback = onDeathCallback;
	
	drone thread WatchGameEvents();
	drone thread WatchDeath();
	drone thread WatchParentDeath();
	drone thread WatchParentMissiles();
	return drone;
}

function WatchGameEvents()
{
	drone = self;
	drone endon( "death" );
	
	drone.parent.owner util::waittill_any( "game_ended", "emp_jammed", "disconnect", "joined_team" );
	drone Shutdown( true );
}

function WatchDeath()
{
	drone = self;
	drone.parent endon( "death" );
	
	drone waittill( "death" );
	drone Shutdown( true );
}

function WatchParentDeath()
{
	drone = self;
	drone endon( "death" );
	
	drone.parent waittill( "death" );
	drone Shutdown( true );
}

function WatchParentMissiles()
{
	drone = self;
	drone endon( "death" );
	drone.parent endon( "death" );
	
	drone.parent waittill( "stinger_fired_at_me", missile, weapon, attacker );

	drone.incoming_missile = missile;
	drone.incoming_missile.target_weapon = weapon;
	drone.incoming_missile.target_attacker = attacker;
	drone vehicle_ai::set_state( "combat" );
}

function SetCamoState( state )
{
	self clientfield::set( "flak_drone_camo", state );
}

function Shutdown( explode )
{
	drone = self;
	
	if( isdefined( drone.death_callback ) )
	{
		drone.parent thread [[ drone.death_callback ]]();
	}
	
	if( isdefined( drone ) && !isdefined( drone.parent ) )
	{
		drone Ghost();
		drone NotSolid();
		wait( 5 );
		if( isdefined( drone ) )
			drone Delete();
	}
		
	if( isdefined( drone ) )
	{
		if( explode )
		{
			drone DoDamage( drone.health + 1000, drone.origin, drone, drone, "none", "MOD_EXPLOSIVE" );	
		}
		else
		{
			drone Delete();
		}
	}
}

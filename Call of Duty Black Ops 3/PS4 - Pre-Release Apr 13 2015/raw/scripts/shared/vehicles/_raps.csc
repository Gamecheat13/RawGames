#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
       
                                                                                                             	   	

                                                              	   	                             	  	                                      

#namespace raps;

#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("raps",&__init__,undefined,undefined);    }

function __init__()
{	
	clientfield::register( "vehicle", "raps_side_deathfx", 1, 1, "int" );
	
	vehicle::add_main_callback( "raps", &raps_initialize );
	
	slow_triggers = GetEntArray( "raps_slow", "targetname" );
	array::thread_all( slow_triggers, &slow_raps_trigger );
	
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	array::thread_all( hurt_triggers, &hurt_trigger );
}

function raps_initialize()
{
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.delete_on_death = true;
	self.health = self.healthdefault;
	
	self UseAnimTree( #animtree );
	
	self vehicle::friendly_fire_shield();

	assert( isdefined( self.scriptbundlesettings ) );
	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	
	if( self.settings.aim_assist )
	{
		self EnableAimAssist();
	}
	
	self SetNearGoalNotifyDist( self.settings.near_goal_notify_dist );
	//self SetVehicleAvoidance( self.settings.vehicle_avoidance );
	self.goalRadius = self.settings.goal_radius;
	self.goalHeight = self.settings.goal_height;
	self SetGoal( self.origin, false, self.settings.goal_radius, self.settings.goal_height );
	
	self.overrideVehicleDamage = &raps_callback_damage;
	self.allowFriendlyFireDamageOverride = &raps_AllowFriendlyFireDamage;
	self.do_death_fx = &do_death_fx;
	
	self thread vehicle_ai::nudge_collision();
	
	self thread sndFunctions();

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    
    self vehicle_ai::get_state_callbacks( "driving" ).update_func = &state_scripted_update;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    
  	self vehicle_ai::call_custom_add_state_callbacks();	
    
	vehicle_ai::StartInitialState( "combat" );
}

function state_scripted_update( params )
{
	self endon( "change_state" );
	self endon("death");
	
	driver = self GetSeatOccupant( 0 );
	
	if( isPlayer( driver ) )
	{
		driver endon( "disconnect" );
		
		driver util::waittill_attack_button_pressed();
		
		self Kill( self.origin, driver );
	}
}

function state_death_update( params )
{
	attacker = params.inflictor;
	if( !isdefined( attacker ) )
	{
		attacker = params.attacker;
	}
	
	if( attacker !== self && ( !isdefined( self.owner ) || ( self.owner !== attacker ) ) && ( IsAI( attacker) || IsPlayer( attacker ) ) )
	{
		self.damage_on_death = false;
		{wait(.05);};

		// need to retest for attacker validity because of the wait
		attacker = params.inflictor;
		if( !isdefined( attacker ) )
		{
			attacker = params.attacker;
		}
		if ( isdefined( attacker ) )
		{
			self detonate_sides( attacker );
		}
		else
		{
			self.damage_on_death = true;
		}
	}

	self vehicle_ai::defaultstate_death_update();
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	pathfailcount = 0;

	self thread prevent_stuck();

	for( ;; )
	{
		if ( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait 0.1;
		}
		else if ( !IsDefined( self.enemy ) )
		{
			if( isdefined( self.settings.all_knowing ) )
			{
				self force_get_enemies();
			}
			
			// go slower when you don't have an enemy, patrolling
			self SetSpeed( self.settings.defaultMoveSpeed * 0.35 );
			
			queryResult = PositionQuery_Source_Navigation( self.origin, 0, self.settings.max_move_dist * 1.5, self.settings.max_move_dist, self.radius, self );

			PositionQuery_Filter_InClaimedLocation( queryResult, self );
			PositionQuery_Filter_DistanceToGoal( queryResult, self );
			vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );	// This already adds score
			
			best_point = undefined;
			best_score = -999999;
			
			foreach ( point in queryResult.data )
			{
				// distance from origin
				point vehicle_ai::AddScore( "distToOrigin", MapFloat( 0, 200, 0, 100, point.distToOrigin2D ) );
		
				if( point.inClaimedLocation )
				{
					point vehicle_ai::AddScore( "inClaimedLocation", -500 );
				}
		
				point vehicle_ai::AddScore( "random", randomFloatRange( 0, 50 ) );
		
				// Wander in a somewhat continuous direction
				if( isdefined( self.prevMoveDir ) )
				{
					moveDir = VectorNormalize( point.origin - self.origin );
					if( VectorDot( moveDir, self.prevMoveDir ) > 0.34 )		// 70'
					{
						point vehicle_ai::AddScore( "currentMoveDir", randomFloatRange( 50, 150 ) );
					}
				}
				
				if ( point.score > best_score )
				{
					best_score = point.score;
					best_point = point;
				}
			}
			
			self vehicle_ai::PositionQuery_DebugScores( queryResult );
			
			foundpath = false;
			
			if( isdefined( best_point ) )
			{
				foundpath = self SetVehGoalPos( best_point.origin, false, true );
			}
			else
			{
				wait 1;
			}
			
			if ( foundpath )
			{
				self.prevMoveDir = VectorNormalize( best_point.origin - self.origin );
				self.current_pathto_pos = undefined;
				self thread path_update_interrupt();

				pathfailcount = 0;

				self vehicle_ai::waittill_pathing_done();
				
				raps::try_detonate();
			}
			else
			{
				// avoid infinite loop when failinig to find path
				wait 1;
			}
		}
		else if ( !self.enemy.allowdeath && self GetPersonalThreatBias( self.enemy ) == 0 ) // avoid magic bullet shielded enemy
		{
			self SetPersonalThreatBias( self.enemy, -2000, 10.0 );
			{wait(.05);};
		}
		else
		{
			foundpath = false;
			targetPos = raps_get_target_position();

			self SetSpeed( self.settings.defaultMoveSpeed );
			
			if ( isdefined( targetPos ) )
			{
				queryResult = PositionQuery_Source_Navigation( targetPos, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self );

				// Prevent training by not sending every raps to the same location
				if( DistanceSquared( self.origin, targetPos ) > ( (300) * (300) ) )
				{
					PositionQuery_Filter_InClaimedLocation( queryResult, self.enemy );
				}
				
				best_point = undefined;
				best_score = -999999;
				foreach ( point in queryResult.data )
				{
					point vehicle_ai::AddScore( "distToOrigin", MapFloat( 0, 200, 0, -200, Distance( point.origin, queryResult.origin ) ) );
					point vehicle_ai::AddScore( "heightToOrigin", MapFloat( 50, 200, 0, -200, Abs( point.origin[2] - queryResult.origin[2] ) ) );

					if( point.inClaimedLocation === true )
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

				if( isdefined( best_point ) )
				{
					foundpath = self SetVehGoalPos( best_point.origin, false, true );
				}

				if ( foundpath )
				{	
					self.current_pathto_pos = targetPos;
					self thread path_update_interrupt();

					pathfailcount = 0;

					self vehicle_ai::waittill_pathing_done();

					raps::try_detonate();
				}
				else
				{
					{wait(.05);};
				}
			}

			if ( !foundpath )
			{
				pathfailcount++;

				if ( pathfailcount > 2 )
				{
					/#
					// recordLine( self.origin, self.origin + (0,0,3000), (0.3,1,0) );
					// RecordSphere( self.origin, 30, (1,1,0) );
					#/
						
					// Try to change enemies
					if( IsDefined( self.enemy ) )
					{
						self SetPersonalThreatBias( self.enemy, -2000, 5.0 );
					}
						
					if ( pathfailcount > self.settings.max_path_fail_count )
					{
						detonate();
					}
				}
				
				wait .2;
				
				// just try to path strait to a nearby position on the path
				queryResult = PositionQuery_Source_Navigation( self.origin, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self );

				if( queryResult.data.size )
				{
					point = queryResult.data[ randomint( queryResult.data.size ) ];
					
					self SetVehGoalPos( point.origin, false, false );
					self.current_pathto_pos = undefined;
					self thread path_update_interrupt();	// keep trying to detonate
					wait 2;
					self notify( "near_goal" );				// kill the path_update_interrupt just in case
				}
			}

			wait 0.2;
		}
	}
}

function prevent_stuck()
{
	self endon( "change_state" );
	self endon( "death" );
	self notify( "end_prevent_stuck" );
	self endon( "end_prevent_stuck" );

	wait 2;

	count = 0;
	previous_origin = self.origin;

	// detonate if position hasn't change for N counts
	while( true )
	{
		if ( previous_origin === self.origin )
		{
			count++;
		}
		else
		{
			count = 0;
		}

		if ( count > 10 )
		{
			detonate();
		}

		wait 1;
	}
}

function detonate( attacker )
{
	if( !isdefined( attacker ) )
		attacker = self;
	
	self DoDamage( self.health + 1000, self.origin, attacker, self, "none", "MOD_EXPLOSIVE", 0, self.turretWeapon );
}

function detonate_damage_monitored( enemy )
{
	self.selfDestruct = true;
	self DoDamage( 1000, self.origin, enemy, self, "none", "MOD_EXPLOSIVE", 0, self.turretWeapon );
}

function try_detonate()
{
	if( isdefined( level.raps_try_detonate ) )
	{
		return self [[level.raps_try_detonate]]();
	}
	
	if ( isdefined( self.enemy ) && IsAlive( self.enemy ) )
	{
		/#
			recordLine( self.enemy.origin, self.origin, ( 1, .5, 0 ), "Animscript", self );
			Record3dText( "" + distance( self.enemy.origin, self.origin ), self.enemy.origin + ( 0, 0, 20 ), ( 0, 1, 0 ), "Animscript" );
		#/	
		
		if( distanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.detonation_distance) * (self.settings.detonation_distance) ) )
		{
			trace = BulletTrace( self.origin + (0,0,self.radius), self.enemy.origin + (0,0,self.radius), true, self );
			if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
			{
				self detonate();
				return true;
			}
		}
	}
	
	return false;
}

function raps_get_target_position()
{
	if( isdefined( level.raps_get_target_position ) )
	{
		return self [[ level.raps_get_target_position ]]();
	}
	
	if( isdefined( self.settings.all_knowing ) )
	{
		if( isdefined( self.enemy ) )
		{
			return self.enemy.origin;
		}
	}
	else
	{
		return vehicle_ai::GetTargetPos( vehicle_ai::GetEnemyTarget() );
	}
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait .1; 	// sometimes endons may get fired off so wait a bit for the goal to get updated
	
	while( !self try_detonate() )
	{
		if( isdefined( self.current_pathto_pos ) )
		{
			if( distance2dSquared( self.current_pathto_pos, self.goalpos ) > ( (self.settings.goal_radius) * (self.settings.goal_radius) ) )
			{
				wait 0.5;
				
				self notify( "near_goal" );
			}

			targetPos = raps_get_target_position();
			if ( isdefined( targetPos ) )
			{
				if( distance2dSquared( self.current_pathto_pos, targetPos ) > ( (self.settings.repath_range) * (self.settings.repath_range) ) )
				{
					if( isdefined( self.sndAlias ) && isdefined( self.sndAlias["direction"] ) )
					{
						self playsound (self.sndAlias["direction"]);
					}
					
					self notify( "near_goal" );
				}
			}
			wait 0.2;
		}
		else
		{
			wait 0.4;
		}
	}
}

function raps_AllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if( isdefined( self.owner ) && ( eAttacker == self.owner ) && isdefined( self.settings.friendly_fire ) && int( self.settings.friendly_fire ) && !weapon.isEmp )
	{
		return true;
	}
	
	if ( isdefined( eAttacker ) && isdefined( eAttacker.archetype ) && isdefined( sMeansOfDeath )
		 && eAttacker.archetype == "raps" && sMeansOfDeath == "MOD_EXPLOSIVE" )
	{
		return true;
	}

	return false;
}

function detonate_sides(eInflictor)
{
	forward_direction = AnglesToForward( self.angles );
	up_direction = AnglesToUp( self.angles );
	
	origin = self.origin + VectorScale(up_direction, 15);
	
	right_direction = VectorCross(forward_direction, up_direction);
	right_direction = VectorNormalize(right_direction);
	
	left_direction = VectorScale(right_direction, -1);
	
	eInflictor CylinderDamage(VectorScale(right_direction, 140), origin, 15, 50, self.radiusdamageradius, self.radiusdamageradius / 5, self, "MOD_EXPLOSIVE", self.turretWeapon);
	eInflictor CylinderDamage(VectorScale(left_direction, 140), origin, 15, 50, self.radiusdamageradius, self.radiusdamageradius / 5, self, "MOD_EXPLOSIVE", self.turretWeapon);
	
	self.bSideDetonation = true;
}

function raps_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if ( isdefined( eAttacker ) && isdefined( eAttacker.archetype ) && isdefined( sMeansOfDeath )
		 && eAttacker.archetype == "raps" && sMeansOfDeath == "MOD_EXPLOSIVE" )
	{
		if ( eAttacker != self && isdefined( vDir ) && lengthSquared( vDir ) > 0.1 && ( !isdefined( eAttacker ) || eAttacker.team === self.team ) && ( !isdefined( eInflictor ) || eInflictor.team === self.team ) )
		{
			self SetVehVelocity( self.velocity + VectorNormalize( vDir ) * 300 );
			return 1;
		}
	}

	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
	
	return iDamage;
}

function hurt_trigger()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill ( "trigger", ent );
		if( IsVehicle( ent ) && isdefined( ent.archetype ) && ent.archetype == "raps" )
		{
			ent.owner = undefined;
			ent detonate();		
		}
	}
}

function slow_raps_trigger()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsVehicle( other ) && IsDefined( other.archetype ) && other.archetype == "raps" )
		{
			other thread slow_raps();
		}
	}
}

function slow_raps()
{
	self notify( "slow_raps" );
	self endon( "slow_raps" );
	self endon( "death" );
	
	self SetSpeed( 3 );	
		
	wait 1;
	
	self ResumeSpeed( self.settings.defaultMoveSpeed );
}

function force_get_enemies()
{
	if( isdefined( level.raps_force_get_enemies ) )
	{
		return self [[level.raps_force_get_enemies]]();
	}
	
	foreach( player in level.players )
	{
		if( self util::IsEnemyPlayer( player ) && !player.ignoreme )
		{
			self GetPerfectInfo( player );
			return;
		}
	}
}

function sndFunctions()
{
	self.sndAlias = [];
	self.sndAlias["inAir"] = "veh_raps_in_air";
	self.sndAlias["land"] = "veh_raps_land";
	self.sndAlias["spawn"] = "veh_raps_spawn";
	self.sndAlias["direction"] = "veh_raps_direction";
	
	if( isdefined( self.targetname ) && self.targetname == "zombie_raps" )
	{
		self.sndAlias["inAir"] = "zmb_meatball_in_air";
		self.sndAlias["land"] = "zmb_meatball_land";
		self.sndAlias["spawn"] = "zmb_meatball_spawn";
		self.sndAlias["direction"] = "zmb_meatball_direction";
	}
	
	if( self isDrivablePlayerVehicle() )
	{
		self thread drivableRapsInAir();
	}
	else
	{
		self thread raps_in_air_audio();
		
		if( SessionModeIsCampaignGame() || SessionModeIsZombiesGame() )
			self thread raps_spawn_audio();
	}
}
function drivableRapsInAir()
{
	self endon ("death");
	
	while(1)
	{
		self waittill ("veh_landed");
		self playsound (self.sndAlias["land"]);
	}
}
function raps_in_air_audio() //need to move to client at some point
{
	self endon ("death");
	
	if( !SessionModeIsCampaignGame() && !SessionModeIsZombiesGame() )
		self waittill( "veh_landed" );
	
	while(1)
	{
		self waittill ("veh_inair");  //notify sent from the vehicle system when all four 'tires' are off the ground
		self playsound (self.sndAlias["inAir"]);
		self waittill ("veh_landed");
		self playsound (self.sndAlias["land"]);
	}
	
}
function raps_spawn_audio() //need to move to client at some point
{
	self endon( "death" );
	wait randomfloatrange (0.25, 1.5);
	self playsound (self.sndAlias["spawn"]);	
}
function isDrivablePlayerVehicle()
{
	str_vehicletype = self.vehicletype;
	if (isdefined( str_vehicletype ) && StrEndsWith( str_vehicletype, "_player" ) )
	{
		return true;
	}
	return false;
}

function do_death_fx()
{
	if(isdefined(self.bSideDetonation ))
		self clientfield::set( "raps_side_deathfx", 1 );
	else
		self clientfield::set( "deathfx", 1 );
}
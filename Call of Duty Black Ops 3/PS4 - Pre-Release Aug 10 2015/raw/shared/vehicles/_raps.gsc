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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       
                                                                                                             	     	                                                                                                                                                                

                                                                  	                             	  	                                      

// Distance at which raps repath range is doubled and they check for others claimed locations.  Needs to match.


#namespace raps;

#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("raps",&__init__,undefined,undefined);    }

function __init__()
{	
	clientfield::register( "vehicle", "raps_side_deathfx", 1, 1, "int" );
	
	vehicle::add_main_callback( "raps", &raps_initialize );
	
	slow_triggers = GetEntArray( "raps_slow", "targetname" );
	array::thread_all( slow_triggers, &slow_raps_trigger );
}

function raps_initialize()
{
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.delete_on_death = true;
	self.health = self.healthdefault;
	self.last_jump_chance_time = 0;
	
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
	
//	self thread play_rumble_on_raps();

	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}
	
	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    
    self vehicle_ai::get_state_callbacks( "driving" ).update_func = &state_scripted_update;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    
    self vehicle_ai::get_state_callbacks( "emped" ).update_func = &state_emped_update;

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

// ----------------------------------------------
// State: death
// ----------------------------------------------
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
		if ( isdefined( attacker ) && !isdefined( self.detonate_sides_disabled ) )
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
// State: emped
// ----------------------------------------------
function state_emped_update( params )
{
	self endon ( "death" );
	self endon ( "change_state" );

	wait 1;

	if ( isdefined( self.abnormal_status ) )
	{
		self Kill( self.origin, self.abnormal_status.attacker, self.abnormal_status.inflictor, GetWeapon( "emp" ) );
	}
	else
	{
		self Kill();
	}
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
	self thread detonation_monitor();
	self thread nudge_collision();

	for( ;; )
	{
		if ( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait 0.1;
		}
		else if ( !IsDefined( self.enemy ) || ( isdefined( self.raps_force_patrol_behavior ) && self.raps_force_patrol_behavior ) )
		{
			if( isdefined( self.settings.all_knowing ) )
			{
				self force_get_enemies();
			}
			
			// go slower when you don't have an enemy, patrolling
			self SetSpeed( self.settings.defaultMoveSpeed * 0.35 );
			
			PixBeginEvent( "_raps::state_combat_update 1" );
			queryResult = PositionQuery_Source_Navigation( self.origin, 0, self.settings.max_move_dist * 1.5, self.settings.max_move_dist, self.radius, self );
			PixEndEvent();

			PositionQuery_Filter_InClaimedLocation( queryResult, self );
			PositionQuery_Filter_DistanceToGoal( queryResult, self );
			vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );	// This already adds score
			
			best_point = undefined;
			best_score = -999999;
			
			foreach ( point in queryResult.data )
			{
				// distance from origin
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distToOrigin" ] = MapFloat( 0, 200, 0, 100, point.distToOrigin2D );    #/    point.score += MapFloat( 0, 200, 0, 100, point.distToOrigin2D );;
		
				if( point.inClaimedLocation )
				{
					/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "inClaimedLocation" ] = -500;    #/    point.score += -500;;
				}
		
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "random" ] = randomFloatRange( 0, 50 );    #/    point.score += randomFloatRange( 0, 50 );;
		
				// Wander in a somewhat continuous direction
				if( isdefined( self.prevMoveDir ) )
				{
					moveDir = VectorNormalize( point.origin - self.origin );
					if( VectorDot( moveDir, self.prevMoveDir ) > 0.64 )		// cos 50'
					{
						/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "currentMoveDir" ] = randomFloatRange( 50, 150 );    #/    point.score += randomFloatRange( 50, 150 );;
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

			if ( isdefined( targetPos ) )
			{
				// Prevent training by not sending every raps to the same location unless they are getting close
				if( DistanceSquared( self.origin, targetPos ) > ( (400) * (400) ) && self IsPosInClaimedLocation( targetPos ) )
				{	
					PixBeginEvent( "_raps::state_combat_update 2" );
					queryResult = PositionQuery_Source_Navigation( targetPos, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self );
					PixEndEvent();
	
					PositionQuery_Filter_InClaimedLocation( queryResult, self.enemy );
					
					best_point = undefined;
					best_score = -999999;
					foreach ( point in queryResult.data )
					{
						/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distToOrigin" ] = MapFloat( 0, 200, 0, -200, Distance( point.origin, queryResult.origin ) );    #/    point.score += MapFloat( 0, 200, 0, -200, Distance( point.origin, queryResult.origin ) );;
						/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "heightToOrigin" ] = MapFloat( 50, 200, 0, -200, Abs( point.origin[2] - queryResult.origin[2] ) );    #/    point.score += MapFloat( 50, 200, 0, -200, Abs( point.origin[2] - queryResult.origin[2] ) );;
	
						if( point.inClaimedLocation === true )
						{
							/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "inClaimedLocation" ] = -500;    #/    point.score += -500;;
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
						targetPos = best_point.origin;
					}
				}

				foundpath = self SetVehGoalPos( targetPos, false, true );
				
				if ( foundpath )
				{	
					self.current_pathto_pos = targetPos;
					self thread path_update_interrupt();

					pathfailcount = 0;

					self vehicle_ai::waittill_pathing_done();
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
				PixBeginEvent( "_raps::state_combat_update 3" );
				queryResult = PositionQuery_Source_Navigation( self.origin, 0, self.settings.max_move_dist, self.settings.max_move_dist, self.radius, self );
				PixBeginEvent( "_raps::state_combat_update 3" );

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
	previous_origin = undefined;

	// detonate if position hasn't change for N counts
	while( true )
	{
		if ( isdefined( previous_origin ) && DistanceSquared( previous_origin, self.origin ) < ( (0.1) * (0.1) ) )
		{
			count++;
		}
		else
		{
			previous_origin = self.origin;
			count = 0;
		}

		if ( count > 10 )
		{
			detonate();
		}

		wait 1;
	}
}

function check_detonation_dist( origin, enemy )
{
	if ( isdefined( enemy ) && IsAlive( enemy ) )
	{
		// try to detonate when more in front of the enemy, frustrating to get killed from behind
		enemy_look_dir_offst = AnglesToForward( enemy.angles ) * 30;

		if( distanceSquared( enemy.origin + enemy_look_dir_offst, origin ) < ( (self.settings.detonation_distance) * (self.settings.detonation_distance) ) )
		{
			return true;
		}
	}
	
	return false;
}

function jump_detonate()
{
	self PlaySound( self.sndAlias["jump_up"] );
	self LaunchVehicle( (0,0,1) * self.jumpforce, (0,0,0), true );
	
	// Spin the Raps too
	/*
	if( math::cointoss() )
	{
		side_dir = (0,-1,0);
	}
	else
	{
		side_dir = (0,1,0);
	}
	self LaunchVehicle( side_dir * 5, (400,0,0), true, 1 );
	*/
	wait 0.4;
	
	time_to_land = 0.6;
	while( time_to_land > 0 )
	{
		if( check_detonation_dist( self.origin, self.enemy ) )
		{
			self detonate();
		}
		wait 0.05;
		time_to_land -= 0.05;
	}
	
	// re-enable stabilizers
	//self LaunchVehicle( (0,0,1), (0,0,0), true, 2 );
}

function detonate( attacker )
{
	if( !isdefined( attacker ) )
		attacker = self;
	
	self stopsounds();
	
	self DoDamage( self.health + 1000, self.origin, attacker, self, "none", "MOD_EXPLOSIVE", 0, self.turretWeapon );
}

function detonate_damage_monitored( enemy, weapon )
{
	self.selfDestruct = true;
	self DoDamage( 1000, self.origin, enemy, self, "none", "MOD_EXPLOSIVE", 0, self.turretWeapon );
}

function detonation_monitor()
{
	self endon( "death" );
	self endon( "change_state" );
	
	lastEnemy = undefined;

	while( 1 )
	{
		try_detonate();
		
		wait 0.2;
		
		// targeting audio
		if( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
		{
			// enemy change
			if( lastEnemy !== self.enemy )
			{
				lastDistToEnemySquared = 10000.0 * 10000.0;
				lastEnemy = self.enemy;
			}

			if( !IsDefined( self.looping_targeting_sound ) )
			{
				self.looping_targeting_sound = spawn( "script_origin", self.origin );
				self.looping_targeting_sound linkto(self);
				
				//set the client mask on the looping targeting sound to play only on the enemy
				self.looping_targeting_sound SetInvisibleToAll();
				self.looping_targeting_sound SetVisibleToPlayer( self.enemy );
				self.looping_targeting_sound playloopsound (self.sndAlias["vehRapsAlarm"]);
				
				self thread raps_audio_cleanup();
			}
			
			distToEnemySquared = distanceSquared( self.origin, self.enemy.origin );
			
			if( distToEnemySquared < ( (250) * (250) ) )
	        {
				if( lastDistToEnemySquared > ( (250) * (250) ) && !( isdefined( self.serverShortout ) && self.serverShortout ) )
					self PlaySoundToPlayer( self.sndAlias["vehRapsClose250"], self.enemy );
	        }
			else if( distToEnemySquared < ( (750) * (750) ) )
	        {
				if( lastDistToEnemySquared > ( (750) * (750) ) && !( isdefined( self.serverShortout ) && self.serverShortout ) )
					self PlaySoundToPlayer( self.sndAlias["vehRapsTargeting"], self.enemy );
	        }
			else if( distToEnemySquared < ( (1500) * (1500) ) )
			{
				if( lastDistToEnemySquared > ( (1500) * (1500) ) && !( isdefined( self.serverShortout ) && self.serverShortout ) )
					self PlaySoundToPlayer( self.sndAlias["vehRapsClose1500"], self.enemy );
			}
			
			if( distToEnemySquared < lastDistToEnemySquared )
			{
				lastDistToEnemySquared = distToEnemySquared;
			}
			// let it slowly grow so we can play the sounds again if the player gets away
			lastDistToEnemySquared += ( (50 * 0.2) * (50 * 0.2) ); 

		}
	}
}
function raps_audio_cleanup()
{
	self waittill( "death" );

	if ( isdefined( self ) )
	{
		self stopsounds();
		if ( isdefined( self.looping_targeting_sound ) )
		{
			self.looping_targeting_sound StopLoopSound();
			self.looping_targeting_sound Delete();
		}
	}
}

function try_detonate()
{
	if( ( isdefined( self.disableAutoDetonation ) && self.disableAutoDetonation ) )
		return;
	
	jump_time = 0.5;
	
	cur_time = GetTime();
	
	can_jump = (cur_time - self.last_jump_chance_time > 1500);
	
	if( can_jump )
	{
		predicted_origin = self.origin + self GetVelocity() * jump_time;
	}
	
	if( isdefined( predicted_origin ) && check_detonation_dist( predicted_origin, self.enemy ) )
	{
		trace = BulletTrace( predicted_origin + (0,0,self.radius), self.enemy.origin + (0,0,self.radius), true, self );
		if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
		{
			self.last_jump_chance_time = cur_time;
			if( RandomFloat( 1 ) < self.settings.jump_chance )
			{
				self jump_detonate();
			}
		}
	}
	else if( check_detonation_dist( self.origin, self.enemy ) )
	{
		trace = BulletTrace( self.origin + (0,0,self.radius), self.enemy.origin + (0,0,self.radius), true, self );
		if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
		{
			self detonate();
		}
	}
	
	// just blow up if close to other enemies
	if( isdefined( self.owner ) )
	{
		foreach( player in level.players )
		{
			if( self.owner util::IsEnemyPlayer( player ) && ( !isdefined( self.enemy ) || player != self.enemy ) )
			{
				if( player IsNoTarget() || !IsAlive( player ) )
				{
					continue;
				}
				
				if( !SessionModeIsCampaignGame() && !SessionModeIsZombiesGame() && player hasPerk( "specialty_nottargetedbyraps" ) )
				{
					continue;
				}
				
				if( distanceSquared( player.origin, self.origin ) < ( (self.settings.detonation_distance) * (self.settings.detonation_distance) ) )
				{
					trace = BulletTrace( self.origin + (0,0,self.radius), player.origin + (0,0,self.radius), true, self );
					if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
					{
						self raps::detonate();
					}
				}
			}
		}
	}
}

function raps_get_target_position()
{
	if( isdefined( self.settings.all_knowing ) )
	{
		if( isdefined( self.enemy ) )
		{
			target_pos = self.enemy.origin;
		}
	}
	else
	{
		target_pos = vehicle_ai::GetTargetPos( vehicle_ai::GetEnemyTarget() );
	}
	
	enemy = self.enemy;
	
	if( isdefined( target_pos ) )
	{
		target_pos_onnavmesh = GetClosestPointOnNavMesh( target_pos, 700, self.radius );
	}
	
	if( !isdefined( target_pos_onnavmesh ) )
	{
		// if we can't find a position on the navmesh then just keep going to the current position
		return self.current_pathto_pos;
	}
	
	if( isdefined( enemy ) && IsPlayer( enemy ) )
	{
		enemy_vel_offset = enemy GetVelocity() * 0.5;
		
		enemy_look_dir_offset = AnglesToForward( enemy.angles );
		if( distance2dSquared( self.origin, enemy.origin ) > ( (500) * (500) ) )
		{
			enemy_look_dir_offset *= 110;
		}
		else
		{
			enemy_look_dir_offset *= 35;
		}
		
		offset = enemy_vel_offset + enemy_look_dir_offset;
		offset = ( offset[0], offset[1], 0 );	// just 2d
		
		if( TracePassedOnNavMesh( target_pos_onnavmesh, target_pos + offset ) )
		{
			target_pos += offset;
		}
		else
		{
			target_pos = target_pos_onnavmesh;
		}
	}
	else
	{
		target_pos = target_pos_onnavmesh;
	}
	
	return target_pos;
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );
	
	//ensure only one path_update_interrupt is running
	self notify( "clear_interrupt_threads" );
	self endon( "clear_interrupt_threads" );

	wait .1; 	// sometimes endons may get fired off so wait a bit for the goal to get updated
	
	while( 1 )
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
				// optimization, don't keep repathing as often when far away
				if( DistanceSquared( self.origin, targetPos ) > ( (400) * (400) ) )
				{
					repath_range = self.settings.repath_range * 2;
					wait 0.1;
				}
				else
				{
					repath_range = self.settings.repath_range;
				}
				   
				if( distance2dSquared( self.current_pathto_pos, targetPos ) > ( (repath_range) * (repath_range) ) )
				{
					if( isdefined( self.sndAlias ) && isdefined( self.sndAlias["direction"] ) )
					{
						self playsound( self.sndAlias["direction"] );
					}
					
					self notify( "near_goal" );
				}
			}
			
			if( isdefined( self.enemy ) && IsPlayer( self.enemy ) && !isdefined(self.slow_trigger) )
			{
				forward = AnglesToForward( self.enemy GetPlayerAngles() );
				dir_to_raps = self.origin - self.enemy.origin;
				
				speedToUse = self.settings.defaultMoveSpeed;
				if( IsDefined( self._override_raps_combat_speed ) )
				{
					speedToUse = self._override_raps_combat_speed;
				}
				if( VectorDot( forward, dir_to_raps ) > 0 )
				{
					self SetSpeed( speedToUse );
				}
				else
				{
					self SetSpeed( speedToUse * 0.75 );
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

function collision_fx( normal )
{
	tilted = ( normal[2] < 0.6 );
	fx_origin = self.origin - normal * ( tilted ? 28 : 10 );

	self PlaySound( self.sndAlias["vehRapsCollision"] );
	//PlayFX( level._effect[ "drone_nudge" ], fx_origin, normal );
}

function nudge_collision()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_nudge_collision" );
	self endon( "end_nudge_collision" );

	while ( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		ang_vel = self GetAngularVelocity() * 0.8;
		self SetAngularVelocity( ang_vel );
		
		// bounce off walls
		if ( IsAlive( self ) && VectorDot( normal, (0,0,1) ) < 0.5 ) // angle is more than 60 degree away from up direction
		{
			self SetVehVelocity( self.velocity + normal * 400 );
			self collision_fx( normal );
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
	if ( self.drop_deploying === true && sMeansOfDeath == "MOD_TRIGGER_HURT" && ( !isdefined( self.hurt_trigger_immune_end_time ) || ( GetTime() < self.hurt_trigger_immune_end_time ) ) )
		return 0;

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

function slow_raps_trigger()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsVehicle( other ) && IsDefined( other.archetype ) && other.archetype == "raps" )
		{
			other thread slow_raps( self );
		}
		
		wait(0.1);
	}
}

function slow_raps( trigger )
{
	self notify( "slow_raps" );
	self endon( "slow_raps" );
	self endon( "death" );
	
	self.slow_trigger = true;
	if( IsDefined( trigger.script_int ) )
	{
		if( IsDefined( self._override_raps_combat_speed ) && self._override_raps_combat_speed < trigger.script_int )
		{
			self SetSpeedImmediate( self._override_raps_combat_speed );
		}
		else
		{
			self SetSpeedImmediate( trigger.script_int, 200, 200 );
		}
	}
	else
	{
		if( IsDefined( self._override_raps_combat_speed ) && self._override_raps_combat_speed < 0.5 * self.settings.defaultMoveSpeed )
		{
			self SetSpeed( self._override_raps_combat_speed );
		}
		else
		{
			self SetSpeed( 0.5 * self.settings.defaultMoveSpeed );
		}
	}
		
	wait 1;
	
	self ResumeSpeed();
	self.slow_trigger = undefined;
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
	self.sndAlias["jump_up"] = "veh_raps_jump_up";
	self.sndAlias["vehRapsClose250"] = "veh_raps_close_250";
	self.sndAlias["vehRapsClose1500"] = "veh_raps_close_1500";
	self.sndAlias["vehRapsTargeting"] = "veh_raps_targeting";
	self.sndAlias["vehRapsAlarm"] = "evt_raps_alarm";
	self.sndAlias["vehRapsCollision"] = "veh_wasp_wall_imp";
	
	if( isdefined( self.vehicletype ) && self.vehicletype == "spawner_enemy_zombie_vehicle_raps_suicide" )
	{
		self.sndAlias["inAir"] = "zmb_meatball_in_air";
		self.sndAlias["land"] = "zmb_meatball_land";
		self.sndAlias["spawn"] = "zmb_meatball_spawn";
		self.sndAlias["direction"] = "zmb_meatball_direction";
		self.sndAlias["jump_up"] = "zmb_meatball_jump_up";
		self.sndAlias["vehRapsClose250"] = "zmb_meatball_close_250";
		self.sndAlias["vehRapsClose1500"] = "zmb_meatball_close_1500";
		self.sndAlias["vehRapsTargeting"] = "zmb_meatball_targeting";
		self.sndAlias["vehRapsAlarm"] = "zmb_meatball_alarm";
		self.sndAlias["vehRapsCollision"] = "zmb_meatball_collision";
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


//function play_rumble_on_raps()
//{
//	self endon( "death" );
//	
//	while( 1 )
//	{
//		vr = Abs( self GetSpeed() / self GetMaxSpeed() );
//		
//		if( vr >= 0.1 )
//		{
//			self PlayRumbleOnEntity( "damage_heavy" );
//		}
//		
//		Wait 0.1;
//	}
//	
//}

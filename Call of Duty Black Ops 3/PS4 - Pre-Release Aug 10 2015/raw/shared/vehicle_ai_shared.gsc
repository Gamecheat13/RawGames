#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\array_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\ai\systems\ai_interface;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       
                                                                                                             	     	                                                                                                                                                                






#namespace vehicle_ai;

function autoexec __init__sytem__() {     system::register("vehicle_ai",&__init__,undefined,undefined);    }

// _vehicle_ai.gsc - all things related to vehicles ai

#using_animtree( "generic" );

function __init__()
{
}

function RegisterSharedInterfaceAttributes( archetype )
{
	/*
	 * Name: force_high_speed
	 * Summary: Always uses max speed instead of default speed when moving
	 * Example: ai::SetAiAttribute( vehicle, "sprint", true );"
	 */
	ai::RegisterMatchedInterface(
		archetype,
		"force_high_speed",
		false,
		array( true, false ) );
}

//*****************************************************************************
//
// 	Vehicle AI Commands
// 
//	- These are used in conjunction with the vehicle ai system
//	- If the vehicle is not setup to use the ai system they might do nothing
//	- Please see James Snider or Ruoyao Ma if you have questions
//
//*****************************************************************************

// self == AI vehicle
function GetEnemyTarget()
{
	if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
	{
		return self.enemy;
	}
	else if( isdefined( self.enemylastseenpos ) )
	{
		return self.enemylastseenpos;
	}

	return undefined;
}

function GetTargetPos( target, geteye )
{
	pos = undefined;

	if ( isdefined( target ) )
	{
		if ( IsVec( target ) )
		{
			pos = target;
		}
		else if ( ( isdefined( geteye ) && geteye ) && IsSentient( target ) )
		{
			pos = target GetEye();
		}
		else if ( IsEntity( target ) )
		{
			pos = target.origin;
		}
		else if ( isdefined( target.origin ) && IsVec( target.origin ) )
		{
			pos = target.origin;
		}
	}

	return pos;
}

function GetTargetEyeOffset( target )
{
	offset = (0,0,0);

	if ( isdefined( target ) && IsSentient( target ) )
	{
		offset = target GetEye() - target.origin;
	}

	return offset;
}

/@
"Name: fire_for_time( <totalFireTime>, [turretIdx], [target] )"
"Summary: fire a weapon for a set of period"
"CallOn: a vehicle"
"MandatoryArg: <totalFireTime> : how long should the weapon fire"
"OptionalArg: [turretIdx] : which weapon to use. use number to get turret on vehicle. if undefined the vehicle will try to use it's main weapon."
"OptionalArg: [target] : what target it is shooting at. this will affect hit chance."
"Example: vehicle vehicle_ai::fire_for_time( RandomFloatRange( 0.3, 0.6 ) ); "
@/
function fire_for_time( totalFireTime, turretIdx, target, intervalScale = 1.0 )
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "fire_stop" );
	self endon( "fire_stop" );

	if ( !isdefined( turretIdx ) )
	{
		turretIdx = 0;
	}

	weapon = self SeatGetWeapon( turretIdx );

	assert( isdefined( weapon ) && weapon.name!="none" && weapon.fireTime>0 );

	firetime = weapon.firetime * intervalScale;

	fireCount = int( floor( totalFireTime / fireTime ) ) + 1;

	__fire_for_rounds_internal( fireCount, fireTime, turretIdx, target );
}

/@
"Name: fire_for_rounds( <fireCount>, [turretIdx], [target] )"
"Summary: fire a weapon for a set of period"
"CallOn: a vehicle"
"MandatoryArg: <fireCount> : how many rounds should the weapon fire"
"OptionalArg: [turretIdx] : which weapon to use. use number to get turret on vehicle. if undefined the vehicle will try to use it's main weapon."
"OptionalArg: [target] : what target it is shooting at. this will affect hit chance."
"Example: vehicle vehicle_ai::fire_for_rounds( 5 ); "
@/
function fire_for_rounds( fireCount, turretIdx, target )
{
	self endon( "death" );
	self endon( "fire_stop" );
	self endon( "change_state" );

	if ( !isdefined( turretIdx ) )
	{
		turretIdx = 0;
	}

	weapon = self SeatGetWeapon( turretIdx );

	assert( isdefined( weapon ) && weapon.name!="none" && weapon.fireTime>0 );

	__fire_for_rounds_internal( fireCount, weapon.fireTime, turretIdx, target );
}

function __fire_for_rounds_internal( fireCount, fireInterval, turretIdx, target )
{
	self endon( "death" );
	self endon( "fire_stop" );
	self endon( "change_state" );

	if( isdefined( target ) && IsSentient( target ) )
	{
		target endon( "death" );
	}
	
	assert( isdefined( turretIdx ) );

	aiFireChance = 1;

	// fire less, unless shooting player or a bigdog or mentioned specifically from level script
	if ( ( isdefined( target ) && !IsPlayer( target ) && isAI( target ) ) || isdefined( self.fire_half_blanks )  )
	{
		// 1 in 2 bullets will be real
		aiFireChance = 2;
	}

	counter = 0;
	while ( counter < fireCount )
	{
		if ( isdefined( target ) && !isVec( target ) && isdefined( target.attackerAccuracy ) && target.attackerAccuracy == 0 )
		{
			self FireTurret( turretIdx, true );
		}
		else if ( aiFireChance > 1 )
		{
			self FireTurret( turretIdx, counter % aiFireChance );
		}
		else
		{
			self FireTurret( turretIdx );
		}

		counter++;
		wait fireInterval;
	}
}

function SetTurretTarget( target, turretIdx = 0, offset = (0,0,0) )
{
	if ( isEntity( target ) )
	{
		if ( turretIdx == 0 )
		{
			self SetTurretTargetEnt( target, offset );
		}
		else
		{
			self SetGunnerTargetEnt( target, offset, turretIdx - 1 );
		}
	}
	else if ( isVec( target ) )
	{
		origin = target + offset;

		if ( turretIdx == 0 )
		{
			self SetTurretTargetVec( target );
		}
		else
		{
			self SetGunnerTargetVec( target, turretIdx - 1 );
		}
	}
	else
	{
		AssertMsg( "Turret target must be an entity or a vector." );
	}
}

function FireTurret( turretIdx, isFake )
{
	self FireWeapon( turretIdx, undefined, undefined, self );
}

function Javelin_LoseTargetAtRightTime( target )
{
	self endon( "death" );
	
	self waittill( "weapon_fired", proj );
	
	if( !isdefined( proj ) )
	{
		return;
	}
	
	proj endon( "death" );
	
	wait 2;
	
	while( isdefined( target ) )
	{
		if( proj GetVelocity()[2] < -150 && DistanceSquared( proj.origin, target.origin ) < ( (1200) * (1200) ) )
		{
			proj Missile_SetTarget( undefined );
			break;
		}
		wait 0.1;
	}
}

function waittill_pathing_done( maxtime = 15 )
{
	self endon( "change_state" );

	self util::waittill_any_timeout( maxtime, "near_goal", "force_goal", "reached_end_node", "goal", "pathfind_failed" );
}

function waittill_pathresult( maxtime = 0.5 )
{
	self endon( "change_state" );

	result = self util::waittill_any_timeout( maxtime, "pathfind_failed", "pathfind_succeeded" );
	succeeded = ( result === "pathfind_succeeded" );
	return succeeded;
}

function waittill_asm_terminated( timeout )
{
	self endon( "death" );
	self notify( "end_asm_terminated_thread" );
	self endon( "end_asm_terminated_thread" );
	self util::waittill_any_timeout( timeout, "asm_terminated" );
	self notify( "asm_complete", "__terminated__" );
}

function waittill_asm_complete( substate_to_wait, timeout = 10 )
{
	self endon( "death" );

	self thread waittill_asm_terminated( timeout );

	substate = undefined;
	while ( !isdefined( substate ) || ( substate != substate_to_wait && substate != "__terminated__" ) )
	{
		self waittill( "asm_complete", substate );
	}
	self notify( "end_asm_terminated_thread" );
}

// self == vehicle
function throw_off_balance( damageType, hitPoint, hitDirection, hitLocationInfo )
{
	if ( damageType == "MOD_EXPLOSIVE" || damageType == "MOD_GRENADE_SPLASH" || damageType == "MOD_PROJECTILE_SPLASH" )
	{
		self SetVehVelocity( self.velocity + VectorNormalize( hitDirection ) * 300 );
		ang_vel = self GetAngularVelocity();
		ang_vel += ( RandomFloatRange( -300, 300 ), RandomFloatRange( -300, 300 ), RandomFloatRange( -300, 300 ) );
		self SetAngularVelocity( ang_vel );
	}
	else
	{
		ang_vel = self GetAngularVelocity();
		yaw_vel = RandomFloatRange( -320, 320 );
		yaw_vel += math::sign( yaw_vel ) * 150;

		ang_vel += ( RandomFloatRange( -150, 150 ), yaw_vel, RandomFloatRange( -150, 150 ) );
		self SetAngularVelocity( ang_vel );
	}
}

function predicted_collision()
{
	self endon( "crash_done" );
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "veh_predictedcollision", velocity, normal );
		if ( normal[2] >= 0.6 )
		{
			self notify( "veh_collision", velocity, normal );
		}
	}
}

// self == vehicle
function collision_fx( normal )
{
	tilted = ( normal[2] < 0.6 );
	fx_origin = self.origin - normal * ( tilted ? 28 : 10 );

	self PlaySound( "veh_wasp_wall_imp" );
	//PlayFX( level._effect[ "drone_nudge" ], fx_origin, normal );
}

// self == vehicle
function nudge_collision()
{
	self endon( "crash_done" );
	self endon( "power_off_done" );
	self endon( "death" );
	self notify( "end_nudge_collision" );
	self endon( "end_nudge_collision" );

	if ( self.notsolid === true )
	{
		return;
	}

	while ( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );
		
		empedOrOff = ( self get_current_state() === "emped" || self get_current_state() === "off" );
		
		// bounce off walls
		if ( IsAlive( self ) && ( normal[2] < 0.6 || !empedOrOff ) ) // stable or active
		{
			self SetVehVelocity( self.velocity + normal * 90 );
			self collision_fx( normal );
		}
		else if ( empedOrOff )
		{
			if ( isdefined( self.bounced ) )
			{
				self playsound( "veh_wasp_wall_imp" );
				self SetVehVelocity( ( 0, 0, 0 ) );
				self SetAngularVelocity( ( 0, 0, 0 ) );

				pitch = self.angles[0];
				pitch = math::sign( pitch ) * math::clamp( abs( pitch ), 10, 15 );
				self.angles = ( pitch, self.angles[1], self.angles[2] );

				self.bounced = undefined;
				self notify( "landed" );
				return;
			}
			else
			{
				self.bounced = true;
				self SetVehVelocity( self.velocity + normal * 30 );
				self collision_fx( normal );
			}
		}
		else // tilted
		{
			impact_vel = abs( VectorDot( velocity, normal ) );
			
			if(  normal[2] < 0.6 && impact_vel < 100 )
			{
				self SetVehVelocity( self.velocity + normal * 90 );
				self collision_fx( normal );
			}
			else
			{
				self playsound( "veh_wasp_ground_death" );
				self thread vehicle_death::death_fire_loop_audio();
				self notify( "crash_done" );
			}
		}
	}
}

//self is vehicle
function level_out_for_landing()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "landed" );
	
	while( 1 )
	{
		velocity = self.velocity;	// setting the angles clears the velocity so we save it off and set it back
		self.angles = ( self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85 );
		ang_vel = self GetAngularVelocity() * 0.85;
		self SetAngularVelocity( ang_vel );
		self SetVehVelocity( velocity + (0,0,-60) );
		{wait(.05);};
	}
}


//self is vehicle
function immolate( attacker )
{
	self endon( "death" );

	self playsound( "gdt_immolation_robot_countdown" );
	self thread burning_thread( attacker, attacker );
}

function burning_thread( attacker, inflictor )
{
	self endon( "death" );
	self notify( "end_immolating_thread" );
	self endon( "end_immolating_thread" );

	damagePerSecond = self.settings.burn_damagepersecond;
	if ( !isdefined( damagePerSecond ) || damagePerSecond <= 0 )
	{
		return;
	}

	secondsPerOneDamage = 1.0 / Float( damagePerSecond );

	if ( !isdefined( self.abnormal_status ) )
	{
		self.abnormal_status = spawnStruct();
	}

	if ( self.abnormal_status.burning !== true )
	{
		self vehicle::toggle_burn_fx( true );
	}

	self.abnormal_status.burning = true;
	self.abnormal_status.attacker = attacker;
	self.abnormal_status.inflictor = inflictor;

	lastingTime = self.settings.burn_lastingtime;
	if ( !isdefined( lastingTime ) )
	{
		lastingTime = 999999;
	}

	startTime = GetTime();
	interval = max( secondsPerOneDamage, 0.5 );
	damage = 0.0;
	
	while ( TimeSince( startTime ) < lastingTime )
	{
		previousTime = GetTime();
		wait interval;
		damage += TimeSince( previousTime ) * damagePerSecond;
		damageInt = Int( damage );
		self DoDamage( damageInt, self.origin, attacker, self, "none", "MOD_BURNED" );
		damage -= damageInt;
	}

	self.abnormal_status.burning = false;
	self vehicle::toggle_burn_fx( false );
}

//self is vehicle
function iff_notifyMeInNSec(time,note)
{
	self endon("death");
	wait time;
	self notify(note);
}
function iff_override( owner,time = 60 )
{
	self endon( "death" );
	
	//save off the old team
	self._iffoverride_oldTeam = self.team;
	
	self iff_override_team_switch_behavior( owner.team );
	if(isDefined(self.iff_override_cb))
		self [[self.iff_override_cb]](true);
	
	if(isDefined(self.settings) && !( isdefined( self.settings.iffshouldrevertteam ) && self.settings.iffshouldrevertteam ) )
	{
		//do not revert team
		return;
	}
	timeout = (isDefined(self.settings)?self.settings.ifftimetillrevert:time);
	assert(timeout>10);
	self thread iff_notifyMeInNSec(timeout-10,"iff_override_revert_warn");//5 defined in _cybercom.gsh; 
	msg = self util::waittill_any_timeout( timeout,"iff_override_reverted" );
	if (msg == "timeout" )
	{
		self notify ("iff_override_reverted");
	}

	self playsound ("gdt_iff_deactivate");
	
	self iff_override_team_switch_behavior( self._iffoverride_oldTeam );
	if(isDefined(self.iff_override_cb))
		self [[self.iff_override_cb]](false);
	
}

function iff_override_team_switch_behavior( team )
{
	self endon( "death" );
	
	old_ignoreme = self.ignoreme;
	self.ignoreme = true;

	self start_scripted();
	self vehicle::lights_off();
	wait 0.1;

	wait( 1 );
	
	self SetTeam( team );

	self blink_lights_for_time( 1 );
	
	self stop_scripted();

	wait 1;
	self.ignoreme = old_ignoreme;
}

function blink_lights_for_time( time )
{
	self endon( "death" );

	startTime = GetTime();
	
	self vehicle::lights_off();
	wait 0.1;
	
	while ( GetTime() < startTime + time * 1000 )
	{
		self vehicle::lights_off();
		wait 0.1;
		self vehicle::lights_on();
		wait 0.1;
	}

	self vehicle::lights_on();
}

function TurnOff()
{
	self notify( "shut_off" );
}

function TurnOn()
{
	self notify( "start_up" );
}

function TurnOffAllLightsAndLaser()
{
	self LaserOff();
	self vehicle::lights_off();
	self vehicle::toggle_lights_group( 1, false );
	self vehicle::toggle_lights_group( 2, false );
	self vehicle::toggle_lights_group( 3, false );
	self vehicle::toggle_lights_group( 4, false );
	self vehicle::toggle_burn_fx( false );
	self vehicle::toggle_emp_fx( false );
}

function TurnOffAllAmbientAnims()
{
	self vehicle::toggle_ambient_anim_group( 1, false );
	self vehicle::toggle_ambient_anim_group( 2, false );
	self vehicle::toggle_ambient_anim_group( 3, false );
}

function ClearAllLookingAndTargeting()
{
	self ClearTargetEntity();
	self ClearGunnerTarget(0);
	self ClearGunnerTarget(1);
	self ClearGunnerTarget(2);
	self ClearGunnerTarget(3);
	self ClearLookAtEnt();
}

function ClearAllMovement()
{
	if( !IsAirborne( self ) )
	{
		self CancelAIMove();
	}
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
}

function shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if ( should_emp( self, weapon, sMeansOfDeath, eInflictor, eAttacker ) )
	{
		minEmpDownTime = 0.8 * self.settings.empdowntime;
		maxEmpDownTime = 1.2 * self.settings.empdowntime;
		self notify ( "emped", RandomFloatRange( minEmpDownTime, maxEmpDownTime ), eAttacker, eInflictor );
	}

	if ( should_burn( self, weapon, sMeansOfDeath, eInflictor, eAttacker ) )
	{
		self thread burning_thread( eAttacker, eInflictor );
	}

	if ( !isdefined( self.damageLevel ) )
	{
		self.damageLevel = 0;
		self.newDamageLevel = self.damageLevel;
	}

	newDamageLevel = vehicle::should_update_damage_fx_level( self.health, iDamage, self.healthdefault );
	if ( newDamageLevel > self.damageLevel )
	{
		self.newDamageLevel = newDamageLevel;
	}

	if ( self.newDamageLevel > self.damageLevel )
	{
		self.damageLevel = self.newDamageLevel;
		if ( self.pain_when_damagelevel_change === true )
		{
			self notify( "pain" );
		}
		vehicle::set_damage_fx_level( self.damageLevel );
	}

	return iDamage;
}

function should_emp( vehicle, weapon, meansOfDeath, eInflictor, eAttacker )
{
	if( !isdefined( vehicle ) || meansOfDeath === "MOD_IMPACT" || vehicle.disableElectroDamage === true  )
	{
		return false;
	}

	if ( !( ( isdefined( weapon ) && weapon.isEmp ) || meansOfDeath === "MOD_ELECTROCUTED" ) )
	{
		return false;
	}

	causer = ( isdefined( eAttacker ) ? eAttacker : eInflictor );
	if ( !isdefined( causer ) )
	{
		return true;
	}
         
	if ( IsAI( causer ) && IsVehicle( causer ) ) // don't make electro contagious between AI vehicles
	{
		return false;
	}

	if ( level.teamBased )
	{		
		return ( vehicle.team != causer.team );
	}
	else
	{
		if ( isdefined( vehicle.owner ) )
		{
			return ( vehicle.owner != causer );
		}	
		
		return ( vehicle != causer );
	}
}

function should_burn( vehicle, weapon, meansOfDeath, eInflictor, eAttacker )
{
	if ( level.disableVehicleBurnDamage === true || vehicle.disableBurnDamage === true )
	{
		return false;
	}
	
	if( !isdefined( vehicle ) )
	{
		return false;
	}

	if ( meansOfDeath !== "MOD_BURNED" )
	{
		return false;
	}

	if ( vehicle === eInflictor ) // this is how we do continuesly burning damage 
	{
		return false;
	}

	causer = ( isdefined( eAttacker ) ? eAttacker : eInflictor );
	if ( !isdefined( causer ) )
	{
		return true;
	}

	if ( IsAI( causer ) && IsVehicle( causer ) ) // don't make burning contagious between AI vehicles
	{
		return false;
	}
         
	if ( level.teamBased )
	{		
		return ( vehicle.team != causer.team );
	}
	else
	{
		if ( isdefined( vehicle.owner ) )
		{
			return ( vehicle.owner != causer );
		}	
		
		return ( vehicle != causer );
	}
}

//*****************************************************************************
//
// 	Vehicle AI states
// 
//	- These are the default states if the vehicle type don't change the callback
//	- To change a specific callback:
//	    self get_state_callbacks("combat").update_func = custom_update_func;
//	- update_func will be called on a thread, generally have a loop inside and endon( "change_state" )
//		* update_func can have wait, or set state in it
//	- enter_func and exit_func are guaranteed to be called on state transition, so it's good for init and clean up for a state
//		* enter_func and exit_func should not have wait, or set state in it
//
//*****************************************************************************

// self == vehicle
function StartInitialState( defaultState = "combat" )
{
	// we expect script_startstate to be only changed from Radiant, not in script, so we don't wait here

	// Set the first state
	if ( isdefined( self.script_startstate ) )
	{
		self set_state( self.script_startstate );
	}
	else
	{
		// Set the first state
		self set_state( defaultState );
	}	
}

// self == vehicle
function start_scripted( disable_death_state, no_clear_movement )
{
	params = spawnStruct();
	params.no_clear_movement = no_clear_movement;
	self set_state( "scripted", params );
	self._no_death_state = disable_death_state;
}

function stop_scripted( statename )
{
	if ( isAlive( self ) && is_instate( "scripted" ) )
	{
		if ( isdefined( statename ) )
		{
			self set_state( statename );
		}
		else 
		{
			self set_state( "combat" );
		}
	}
}

// self == vehicle
function set_role( rolename )
{
	self.current_role = rolename;
}

// self == vehicle
function set_state( name, params )
{
	self.state_machines[ self.current_role ] thread statemachine::set_state( name, params );
}

function evaluate_connections( eval_func, params )
{
	self.state_machines[ self.current_role ] statemachine::evaluate_connections( eval_func, params );
}

// self == vehicle
function get_state_callbacks( statename )
{
	rolename = "default";
	if ( isdefined( self.current_role ) )
	{
		rolename = self.current_role;
	}
	
	if ( IsDefined( self.state_machines[ rolename ] ) )
	{
		return self.state_machines[ rolename ].states[ statename ];
	}

	return undefined;
}

// self == vehicle
function get_state_callbacks_for_role( rolename, statename )
{
	if ( !isdefined( rolename ) )
	{
		rolename = "default";
	}

	if ( IsDefined( self.state_machines[ rolename ] ) )
	{
		return self.state_machines[ rolename ].states[ statename ];
	}

	return undefined;
}

// self == vehicle
function get_current_state()
{
	if ( IsDefined( self.current_role ) && IsDefined( self.state_machines[ self.current_role ].current_state ) )
	{
		return self.state_machines[ self.current_role ].current_state.name;
	}

	return undefined;
}

// self == vehicle
function get_previous_state()
{
	if ( IsDefined( self.current_role ) && IsDefined( self.state_machines[ self.current_role ].previous_state ) )
	{
		return self.state_machines[ self.current_role ].previous_state.name;
	}

	return undefined;
}

// self == vehicle
function get_next_state()
{
	if ( IsDefined( self.current_role ) && IsDefined( self.state_machines[ self.current_role ].next_state ) )
	{
		return self.state_machines[ self.current_role ].next_state.name;
	}

	return undefined;
}


// self == vehicle
function is_instate( statename )
{
	if ( IsDefined( self.current_role ) && IsDefined( self.state_machines[ self.current_role ].current_state ) )
	{
		return self.state_machines[ self.current_role ].current_state.name === statename;
	}

	return false;
}

// self == vehicle
function add_state( name, enter_func, update_func, exit_func )
{
	if ( IsDefined( self.current_role ) )
	{
		statemachine = self.state_machines[ self.current_role ];

		if ( IsDefined( statemachine ) )
		{
			state = statemachine statemachine::add_state( name, enter_func, update_func, exit_func );
			return state;
		}
	}

	return undefined;
}

// self == vehicle
function add_interrupt_connection( from_state_name, to_state_name, on_notify, checkfunc )
{
	self.state_machines[ self.current_role ] statemachine::add_interrupt_connection( from_state_name, to_state_name, on_notify, checkfunc );
}

// self == vehicle
function add_utility_connection( from_state_name, to_state_name, checkfunc, defaultScore )
{
	self.state_machines[ self.current_role ] statemachine::add_utility_connection( from_state_name, to_state_name, checkfunc, defaultScore );
}

// self == vehicle
function init_state_machine_for_role( rolename )
{
	if ( !isdefined( rolename ) )
	{
		rolename = "default";
	}

	statemachine = statemachine::create( rolename, self );
	statemachine.isRole = true;

	if ( !IsDefined( self.current_role ) )
	{
		set_role( rolename );
	}
	
	// special states
	statemachine statemachine::add_state( "suspend", // empty state used to "suspend" the state machine, not to be confused with "off" state
						  undefined,
						  undefined,
						  undefined );

	statemachine statemachine::add_state( "death",
						  &defaultstate_death_enter,
						  &defaultstate_death_update,
						  undefined );
	
	statemachine statemachine::add_state( "scripted",
						  &defaultstate_scripted_enter,
						  undefined, // no update (scripter taking manual control or player controlling)
						  &defaultstate_scripted_exit );

	// general states
	statemachine statemachine::add_state( "combat",
						  &defaultstate_combat_enter,
						  undefined,
						  &defaultstate_combat_exit );

	statemachine statemachine::add_state( "emped",
						  &defaultstate_emped_enter,
						  &defaultstate_emped_update,
						  &defaultstate_emped_exit,
						  &defaultstate_emped_reenter );
	
	statemachine statemachine::add_state( "surge",
						  &defaultstate_surge_enter,
						  &defaultstate_surge_update,
						  &defaultstate_surge_exit );

	statemachine statemachine::add_state( "off",
						  &defaultstate_off_enter,
						  undefined,
						  &defaultstate_off_exit );

	statemachine statemachine::add_state( "driving",
						  &defaultstate_driving_enter,
						  undefined,
						  &defaultstate_driving_exit );

	statemachine statemachine::add_state( "pain",
						  &defaultstate_pain_enter,
						  undefined,
						  &defaultstate_pain_exit );


	statemachine statemachine::add_interrupt_connection( "off",		"combat",	"start_up" );
	statemachine statemachine::add_interrupt_connection( "driving",	"combat",	"exit_vehicle" );
	statemachine statemachine::add_utility_connection( "emped",	"combat" );
	statemachine statemachine::add_utility_connection( "pain",	"combat" );

	statemachine statemachine::add_interrupt_connection( "combat",	"emped",	"emped" );
	statemachine statemachine::add_interrupt_connection( "pain",	"emped",	"emped" );
	statemachine statemachine::add_interrupt_connection( "emped",	"emped",	"emped" );// emped vehicle can be emped again, it will delay the recover

	statemachine statemachine::add_interrupt_connection( "combat",	"surge",	"surge" );
	statemachine statemachine::add_interrupt_connection( "off",		"surge",	"surge" );
	statemachine statemachine::add_interrupt_connection( "pain",	"surge",	"surge" );
	statemachine statemachine::add_interrupt_connection( "emped",	"surge",	"surge" );
	
	statemachine statemachine::add_interrupt_connection( "combat",	"off",		"shut_off" );
	statemachine statemachine::add_interrupt_connection( "emped",	"off",		"shut_off" );
	statemachine statemachine::add_interrupt_connection( "pain",	"off",		"shut_off" );
	// no "driving" to "off". the player will need to be kicked out first.

	statemachine statemachine::add_interrupt_connection( "combat",	"driving",	"enter_vehicle" );
	statemachine statemachine::add_interrupt_connection( "emped",	"driving",	"enter_vehicle" );
	statemachine statemachine::add_interrupt_connection( "off",		"driving",	"enter_vehicle" );
	statemachine statemachine::add_interrupt_connection( "pain",	"driving",	"enter_vehicle" );

	statemachine statemachine::add_interrupt_connection( "combat",	"pain",		"pain" );
	statemachine statemachine::add_interrupt_connection( "emped",	"pain",		"pain" );
	statemachine statemachine::add_interrupt_connection( "off",		"pain",		"pain" );
	statemachine statemachine::add_interrupt_connection( "driving",	"pain",		"pain" );

	// no connection to "death". "death" state is handled in this callback as a special case
	self.overrideVehicleKilled = &Callback_VehicleKilled;

	// no connection to "scripted". start_scripted and stop_scripted are used to control the transition in and out of "scripted" state.

	statemachine thread statemachine::set_state("suspend");

	self thread on_death_cleanup();
	
	return statemachine;
}

//if levels or gamemodes want to add custom vehicle states, they can register them to this list

function register_custom_add_state_callback( func )
{
	if( !IsDefined( level.level_specific_add_state_callbacks ) )
	{
		level.level_specific_add_state_callbacks = [];
	}
	
	level.level_specific_add_state_callbacks[level.level_specific_add_state_callbacks.size] = func;
}

function call_custom_add_state_callbacks()
{
	if( IsDefined( level.level_specific_add_state_callbacks ) )
    {
    	for( i = 0; i < level.level_specific_add_state_callbacks.size; i++ )
    	{
    		self [[ level.level_specific_add_state_callbacks[i] ]]();
    	}
    }
}

// ----------------------------------------------
// State: death
// ----------------------------------------------
// self == vehicle
function Callback_VehicleKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	if ( ( isdefined( self._no_death_state ) && self._no_death_state ) )
	{
		return;
	}

	death_info = SpawnStruct();
	death_info.inflictor = eInflictor;
	death_info.attacker = eAttacker;
	death_info.damage = iDamage;
	death_info.meansOfDeath = sMeansOfDeath;
	death_info.weapon = weapon;
	death_info.dir = vDir;
	death_info.hitLoc = sHitLoc;
	death_info.timeOffset = psOffsetTime;

	self set_state( "death", death_info );
}

function on_death_cleanup()
{
	state_machines = self.state_machines;
	
	self waittill("free_vehicle");
	
	//Clear State Machine or we will have a script leak caused by cross reference
	foreach(stateMachine in state_machines)
	{
		stateMachine statemachine::clear();
	}
}

function defaultstate_death_enter( params )
{
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
	self DisableAimAssist();

	TurnOffAllLightsAndLaser();
	TurnOffAllAmbientAnims();
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	self CancelAIMove();

	//self SetBrake( 1 );
	self.takedamage = 0;
	self vehicle_death::death_cleanup_level_variables();
}

function burning_death_fx()
{
	if ( isdefined( self.settings.burn_death_fx_1 ) && isdefined( self.settings.burn_death_tag_1 ) )
	{
		PlayFxOnTag( self.settings.burn_death_fx_1, self, self.settings.burn_death_tag_1 );
	}
	
	if ( isdefined( self.settings.burn_death_sound_1 ) )
	{
		self PlaySound( self.settings.burn_death_sound_1 );
	}
}

function emp_death_fx()
{
	if ( isdefined( self.settings.emp_death_fx_1 ) && isdefined( self.settings.emp_death_tag_1 ) )
	{
		PlayFxOnTag( self.settings.emp_death_fx_1, self, self.settings.emp_death_tag_1 );
	}
	
	if ( isdefined( self.settings.emp_death_sound_1 ) )
	{
		self PlaySound( self.settings.emp_death_sound_1 );
	}
}

function death_radius_damage_special( radiusScale, meansOfDamage )
{
	self endon( "death" );

	if ( !isdefined( self ) || self.abandoned === true || self.damage_on_death === false || self.radiusdamageradius <= 0 )
	{
		return;
	}

	position = self.origin + ( 0,0,15 );
	radius = self.radiusdamageradius * radiusScale;
	damageMax = self.radiusdamagemax;
	damageMin = self.radiusdamagemin;

	{wait(.05);};

	if ( isdefined( self ) )
	{
		self RadiusDamage( position, radius, damageMax, damageMin, undefined, meansOfDamage );
	}
}

function burning_death( params )
{
	self endon( "death" );
	self burning_death_fx();
	self.skipFriendlyFireCheck = true; // burning explosion damage friendlies
	self thread death_radius_damage_special( 2, "MOD_BURNED" );
	self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	self vehicle::do_death_dynents( 3 );
	self vehicle_death::DeleteWhenSafe( 10 );
}

function emped_death( params )
{
	self endon( "death" );
	self emp_death_fx();
	self.skipFriendlyFireCheck = true; // emp explosion damage friendlies
	self thread death_radius_damage_special( 2, "MOD_ELECTROCUTED");
	self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	self vehicle::do_death_dynents( 2 );
	self vehicle_death::DeleteWhenSafe();
}

function gibbed_death( params )
{
	self endon( "death" );
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	self vehicle::do_death_dynents();
	self vehicle_death::DeleteWhenSafe();
}

function default_death( params )
{
	self endon( "death" );
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );

	if( isdefined( level.disable_thermal ) )
	{
		[[level.disable_thermal]]();
	}

	waittime = (isdefined(self.waittime_before_delete)?self.waittime_before_delete:0);

	owner = self GetVehicleOwner();
	if ( isDefined( owner ) && self isRemoteControl() )
	{
		// make sure player see some destruction
		waittime = min( waittime, 4 );
	}
	
	util::waitForTime( waittime );
	vehicle_death::FreeWhenSafe();
}

function get_death_type( params )
{
	if ( self.delete_on_death === true )
	{
		death_type = "default";
	}
	else
	{
		death_type = self.death_type;
	}

	if ( !isdefined( death_type ) )
	{
		death_type = params.death_type;
	}

	// burning
	if( !isdefined( death_type ) && isdefined( self.abnormal_status ) && self.abnormal_status.burning === true )
	{
		death_type = "burning";
	}

	// emped
	if ( !isdefined( death_type ) && ( isdefined( self.abnormal_status ) && self.abnormal_status.emped === true ) ||
		( isdefined( params.weapon ) && params.weapon.isEmp ) )
	{
		death_type = "emped";
	}

	return death_type;
}

function defaultstate_death_update( params )
{
	self endon( "death" );

	if ( self.delete_on_death === true )
	{
		default_death( params );
		vehicle_death::DeleteWhenSafe( 0.25 );
	}
	else
	{
		death_type = (isdefined(get_death_type( params ))?get_death_type( params ):"default");

		switch( death_type )
		{
		case "burning": burning_death( params ); break;
		case "emped": emped_death( params ); break;
		case "gibbed": gibbed_death( params ); break;
		default: default_death( params ); break;
		}
	}
}

// ----------------------------------------------

// ----------------------------------------------
// State: scripted
// ----------------------------------------------
function defaultstate_scripted_enter( params )
{
	if ( params.no_clear_movement !== true )
	{
		ClearAllLookingAndTargeting();
		ClearAllMovement();
		if ( HasASM( self ) )
		{
			self ASMRequestSubstate( "locomotion@movement" );
		}
		self ResumeSpeed();
	}
}

// no defaultstate_scripted_update() function

function defaultstate_scripted_exit( params )
{
	if ( params.no_clear_movement !== true )
	{
		ClearAllLookingAndTargeting();
		ClearAllMovement();
	}
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function defaultstate_combat_enter( params )
{
}

function defaultstate_combat_exit( params )
{
}

// ----------------------------------------------
// State: emped
// ----------------------------------------------
function defaultstate_emped_enter( params )
{
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );

	params.laserOn = IsLaserOn( self );

	self LaserOff();
	self vehicle::lights_off();
	ClearAllLookingAndTargeting();
	ClearAllMovement();

	if( IsAirborne( self ) )
	{
		self SetRotorSpeed( 0 );
	}

	if ( !isdefined( self.abnormal_status ) )
	{
		self.abnormal_status = spawnStruct();
	}

	self.abnormal_status.emped = true;
	self.abnormal_status.attacker = params.notify_param[1];
	self.abnormal_status.inflictor = params.notify_param[2];

	self vehicle::toggle_emp_fx( true );
}

function emp_startup_fx()
{
	if ( isdefined( self.settings.emp_startup_fx_1 ) && isdefined( self.settings.emp_startup_tag_1 ) )
	{
		PlayFxOnTag( self.settings.emp_startup_fx_1, self, self.settings.emp_startup_tag_1 );
	}
}

function defaultstate_emped_update( params )
{
	self endon ("death");
	self endon ("change_state");
	
	time = params.notify_param[0];
	assert( isdefined( time ) );
	Cooldown( "emped_timer", time );

	while( !IsCooldownReady( "emped_timer" ) )
	{
		timeLeft = max( GetCooldownLeft( "emped_timer" ), 0.5 );
		wait timeLeft;
	}

	self.abnormal_status.emped = false;
	self vehicle::toggle_emp_fx( false );
	self emp_startup_fx();
	wait 1;

	self evaluate_connections();
}

function defaultstate_emped_exit( params )
{
	self vehicle::toggle_tread_fx( true );
	self vehicle::toggle_exhaust_fx( true );
	self vehicle::toggle_sounds( true );

	if ( params.laserOn === true )
	{
		self LaserOn();
	}
	self vehicle::lights_on();
	if( IsAirborne( self ) )
	{
		self SetPhysAcceleration( ( 0, 0, 0 ) );
		self thread nudge_collision();
		self SetRotorSpeed( 1 );
	}
}

function defaultstate_emped_reenter( params )
{
	return true;
}

// ----------------------------------------------
// State: surge
// ----------------------------------------------

function defaultstate_surge_enter( params )
{
}

function defaultstate_surge_exit( params )
{
}

function defaultstate_surge_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	if ( !isdefined( self.abnormal_status ) )
	{
		self.abnormal_status = spawnStruct();
	}

	self.abnormal_status.emped = true;
	//self.abnormal_status.attacker = params.notify_param[1];
	//self.abnormal_status.inflictor = params.notify_param[2];

	pathfailcount = 0;
	//blink the lights to make the vehicle look crazy
	self thread flash_team_switching_lights();
	
	targets = GetAITeamArray( "axis", "team3" );
	ArrayRemoveValue( targets, self );
	closest = ArrayGetClosest( self.origin, targets );
	
	self SetSpeed( self.settings.surgespeedmultiplier * self.settings.defaultMoveSpeed );
	
	startTime = GetTime();
	self thread swap_team_after_time( params.notify_param[0] );
	while( GetTime() - startTime < self.settings.surgetimetolive * 1000  )
	{
		if ( !IsDefined( closest ) )
		{
			self detonate( params.notify_param[0] );
		}
		else
		{
			foundpath = false;
			targetPos = closest.origin + ( 0, 0, 32 );

			if ( IsDefined( targetPos ) )
			{
				queryResult = PositionQuery_Source_Navigation( targetPos, 0, 64, 35, 5, self );

				foreach ( point in queryResult.data )
				{
					self.current_pathto_pos = point.origin;

					foundpath = self SetVehGoalPos( self.current_pathto_pos, false, true );
					if ( foundpath )
					{
						self thread path_update_interrupt( closest, params.notify_param[0] );
						
						pathfailcount = 0;

						self vehicle_ai::waittill_pathing_done( self.settings.surgetimetolive );
						
						try_detonate( closest, params.notify_param[0] );

						break;
					}
					waittillframeend;
				}
			}

			if ( !foundpath )
			{
				pathfailcount++;
				if ( pathfailcount > 10 )
				{
					self detonate( params.notify_param[0] );
				}
			}
			wait 0.2;
		}
	}
	if( IsAlive( self ) )
	{
		self detonate( params.notify_param[0] );
	}
}

function path_update_interrupt( closest, attacker )
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait .1; 	// sometimes endons may get fired off so wait a bit for the goal to get updated
	
	while( !self try_detonate( closest, attacker ) )
	{
		if( isdefined( self.current_pathto_pos ) )
		{
			if( distance2dSquared( self.current_pathto_pos, self.goalpos ) > ( (self.goalradius) * (self.goalradius) ) )
			{
				wait 0.5;
				
				self notify( "near_goal" );
			}
		}
		wait 0.1;
	}
}

function swap_team_after_time( attacker )
{
	self endon( "death" );
	self endon( "change_state" );
	
	wait( 0.25 * self.settings.surgetimetolive );
	self SetTeam( attacker.team );
}

function try_detonate( closest, attacker )
{
	if ( IsDefined( closest ) && IsAlive( closest ) )
	{
		if( distanceSquared( closest.origin, self.origin ) < ( (80) * (80) ) )
		{
			self detonate( attacker );
			return true;
		}
	}
	
	return false;
}

function detonate( attacker )
{
	self SetTeam( attacker.team );
	self RadiusDamage( self.origin + ( 0, 0, 5 ), self.settings.surgedamageradius, 1500, 1000, attacker, "MOD_EXPLOSIVE" );
	if( IsAlive( self ) )
	{
		self kill();
	}
}

function flash_team_switching_lights()
{
	self endon( "death" );
	self endon( "change_state" );
	
	while( 1 )
	{
		self vehicle::lights_off();
		wait( 0.1 );
		self vehicle::lights_on( "allies" );
		wait( 0.1 );
		self vehicle::lights_off();
		wait( 0.1 );
		self vehicle::lights_on( "axis" );
		wait( 0.1 );
	}
}

// ----------------------------------------------
// State: off
// ----------------------------------------------
function defaultstate_off_enter( params )
{
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
	self DisableAimAssist();

	params.laserOn = IsLaserOn( self );

	TurnOffAllLightsAndLaser();
	TurnOffAllAmbientAnims();
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	
	if( isdefined( level.disable_thermal ) )
	{
		[[level.disable_thermal]]();
	}
	
	if( IsAirborne( self ) )
	{
		self SetPhysAcceleration( ( 0, 0, -300 ) );
		self thread level_out_for_landing();
		self SetRotorSpeed( 0 );
	}
}

function defaultstate_off_exit( params )
{
	self vehicle::toggle_tread_fx( true );
	self vehicle::toggle_exhaust_fx( true );
	self vehicle::toggle_sounds( true );
	self EnableAimAssist();
	if( IsAirborne( self ) )
	{
		self SetPhysAcceleration( ( 0, 0, 0 ) );
		self thread nudge_collision();
		self SetRotorSpeed( 1 );
	}
	if ( params.laserOn === true )
	{
		self LaserOn();
	}
	
	if( isdefined( level.enable_thermal ) )
	{
		if( self get_next_state() !== "death" )
		{
			[[level.enable_thermal]]();
		}
	}
	
	self vehicle::lights_on();
}

// ----------------------------------------------
// State: driving
// ----------------------------------------------
function defaultstate_driving_enter( params )
{
	params.driver = self GetSeatOccupant( 0 );
	assert ( isdefined(params.driver) );

	self DisableAimAssist();
	
	if ( level.playersDrivingVehiclesBecomeInvulnerable )
	{
		params.driver EnableInvulnerability();
		params.driver.ignoreme = true;
	}

	self.turretRotScale = 1;
	self.team = params.driver.team;
	if ( HasASM( self ) )
	{
		self ASMRequestSubstate( "locomotion@movement" );
	}
	
	self SetHeliHeightCap( true );

	ClearAllLookingAndTargeting();
	ClearAllMovement();
	self CancelAIMove();
	
	if( isdefined( params.driver ) && !isdefined( self.customDamageMonitor ) )
	{
		self thread vehicle::monitor_damage_as_occupant( params.driver );
	}
}

function defaultstate_driving_exit( params )
{
	self EnableAimAssist();
	if( isdefined( params.driver ) )
	{
		params.driver DisableInvulnerability();
		params.driver.ignoreme = false;
	}
	self.turretRotScale = 1;

	self SetHeliHeightCap( false );
	
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	
	if( isdefined( params.driver ) )
	{
		params.driver vehicle::stop_monitor_damage_as_occupant();
	}
}

// ----------------------------------------------
// State: pain
// ----------------------------------------------
function defaultstate_pain_enter( params )
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
}

function defaultstate_pain_exit( params )
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
}

// ----------------------------------------------
// Vehicle AI position finding



function CanSeeEnemyFromPosition( position, enemy, sight_check_height )
{
	sightCheckOrigin = position + (0,0,sight_check_height);
	return sighttracepassed( sightCheckOrigin, enemy.origin + (0,0,30), false, self );
}

function FindNewPosition( sight_check_height )
{
	if( self.goalforced )
	{
		goalpos = GetClosestPointOnNavMesh( self.goalpos, self.radius * 2, self.radius );
		///#sphere(self.goalpos,15,(0,1,0),1,true,10,100000 ) ;#/
		return goalpos;
	}
	
	point_spacing = 90;

	PixBeginEvent( "vehicle_ai_shared::FindNewPosition" );
	queryResult = PositionQuery_Source_Navigation( self.origin, 0, 2000, 300/*half height*/, point_spacing, self, point_spacing * 2 );
	PixEndEvent();

	// filter
	PositionQuery_filter_Random( queryResult, 0, 50 );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult, 50 );
	
	origin = self.goalpos;
		
	best_point = undefined;
	best_score = -999999;
	
	if ( isdefined( self.enemy ) )
	{
		PositionQuery_Filter_Sight( queryResult, self.enemy.origin, self GetEye() - self.origin, self, 0, self.enemy );
		self vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );
		
		if( turret::has_turret( 1 ) )
		{
			side_turret_enemy = turret::get_target( 1 );
			if( isdefined( side_turret_enemy ) && side_turret_enemy != self.enemy )
			{
				PositionQuery_Filter_Sight( queryResult, side_turret_enemy.origin, (0,0,sight_check_height), self, 20, self, "sight2" );
			}
		}
		
		if( turret::has_turret( 2 ) )
		{
			side_turret_enemy = turret::get_target( 2 );
			if( isdefined( side_turret_enemy ) && side_turret_enemy != self.enemy )
			{
				PositionQuery_Filter_Sight( queryResult, side_turret_enemy.origin, (0,0,sight_check_height), self, 20, self, "sight3" );
			}
		}
		
		foreach ( point in queryResult.data )
		{	
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "engagementDist" ] = -point.distAwayFromEngagementArea;    #/    point.score += -point.distAwayFromEngagementArea;;
			
			if( distance2dSquared( self.origin, point.origin ) < 170 * 170 )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "tooCloseToSelf" ] = -170;    #/    point.score += -170;;
			}
			
			if( isdefined( point.sight ) && point.sight )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "sight" ] = 250;    #/    point.score += 250;;
			}
			if( isdefined( point.sight2 ) && point.sight2 )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "sight2" ] = 150;    #/    point.score += 150;;
			}
			if( isdefined( point.sight3 ) && point.sight3 )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "sight3" ] = 150;    #/    point.score += 150;;
			}
			
			if ( point.score > best_score )
			{
				best_score = point.score;
				best_point = point;
			}
		}
	}
	else
	{
		foreach ( point in queryResult.data )
		{
			if( distance2dSquared( self.origin, point.origin ) < 170 * 170 )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "tooCloseToSelf" ] = -100;    #/    point.score += -100;;
			}
			
			if( point.score > best_score )
			{
				best_score = point.score;
				best_point = point;
			}		
		}
	}
		
	self vehicle_ai::PositionQuery_DebugScores( queryResult );
	
	if( isdefined( best_point ) )
	{
		/#
			//line( best_point, best_point + (0,0,100), (.3,1,.3), 1.0, true, 100 );
		#/
		origin = best_point.origin;
	}
	
	return origin + (0,0,10);
}

// ----------------------------------------------
// time handling
// ----------------------------------------------

// in seconds
// usage: attackStart = GetTime(); if( TimeSince( attackStart ) > 5 ) ...
function TimeSince( startTimeInMilliseconds )
{
	return ( GetTime() - startTimeInMilliseconds ) * 0.001;
}

function CooldownInit()
{
	if( !isdefined( self._cooldown ) )
	{
		self._cooldown = [];
	}
}

function Cooldown( name, time_seconds )
{
	CooldownInit();

	self._cooldown[ name ] = GetTime() + time_seconds * 1000;
}

function GetCooldownTimeRaw( name )
{
	CooldownInit();

	if ( !isdefined( self._cooldown[ name ] ) )
	{
		self._cooldown[ name ] = GetTime() - 1;
	}
	return self._cooldown[ name ];
}

function GetCooldownLeft( name )
{
	CooldownInit();

	return ( GetCooldownTimeRaw( name ) - GetTime() ) * 0.001;
}

function IsCooldownReady( name, timeForward_seconds )
{
	CooldownInit();

	if ( !isdefined( timeForward_seconds ) )
	{
		timeForward_seconds = 0;
	}

	cooldownReadyTime = self._cooldown[ name ];
	return !isdefined( cooldownReadyTime ) || GetTime() + timeForward_seconds * 1000 > cooldownReadyTime;
}

function ClearCooldown( name )
{
	CooldownInit();

	self._cooldown[ name ] = GetTime() - 1;
}

function AddCooldownTime( name, time_seconds )
{
	CooldownInit();

	self._cooldown[ name ] = GetCooldownTimeRaw( name ) + time_seconds * 1000;
}

function ClearAllCooldowns()
{
	if( isdefined( self._cooldown ) )
	{
		foreach ( str_name, cooldown in self._cooldown )
		{
			self._cooldown[ str_name ] = GetTime() - 1;
		}
	}
}

// ----------------------------------------------
// debug helpers for position query
// ----------------------------------------------

function PositionQuery_DebugScores( queryResult )
{
	if ( !( isdefined( GetDvarInt("hkai_debugPositionQuery") ) && GetDvarInt("hkai_debugPositionQuery") ) )
	{
		return;
	}
	
	foreach( point in queryResult.data )
	{
		point DebugScore( self );
	}
}

// self == pointStruct
function DebugScore( entity )
{
	/#
	if ( !isdefined( self._scoreDebug ) )
	{
		return;
	}
	
	if ( !( isdefined( GetDvarInt("hkai_debugPositionQuery") ) && GetDvarInt("hkai_debugPositionQuery") ) )
	{
		return;
	}

	step = 10;
	count = 1;
	
	color = (1,0,0);
	if ( self.score >= 0 )
	{
		color = (0,1,0);
	}

	RecordStar( self.origin, color );
	record3DText( "" + self.score + ":", self.origin - (0,0,step * count), color );
	foreach( name, score in self._scoreDebug )
	{
		count++;
		record3DText( name + " " + score, self.origin - (0,0,step * count), color );
	}
	#/
}


function _less_than_val( left, right )
{
	if ( !isdefined( left ) )
	{
		return false;
	}
	else if ( !isdefined( right ) )
	{
		return true;
	}

	return left < right;
}

function _cmp_val( left, right, descending )
{
	if ( descending )
	{
		return _less_than_val( right, left );
	}
	else
	{
		return _less_than_val( left, right );
	}
}

function _sort_by_score( left, right, descending )
{
	return _cmp_val( left.score, right.score, descending );
}

function PositionQuery_Filter_Random( queryResult, min, max )
{
	foreach( point in queryResult.data )
	{
		score = RandomFloatRange( min, max );
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "random" ] = score;    #/    point.score += score;;
	}
}

function PositionQuery_PostProcess_SortScore( queryResult, descending = true )
{
	sorted = array::merge_sort( queryResult.data, &_sort_by_score, descending );

	queryResult.data = sorted;
}

function PositionQuery_Filter_OutOfGoalAnchor( queryResult, tolerance = 1 )
{
	foreach( point in queryResult.data )
	{
		if ( point.distToGoal > tolerance )
		{
			score = -10000 - point.distToGoal * 10;
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "outOfGoalAnchor" ] = score;    #/    point.score += score;;
		}
	}
}

function PositionQuery_Filter_EngagementDist( queryResult, enemy, engagementDistanceMin, engagementDistanceMax )
{
	if( !isdefined( enemy ) )
		return;

	engagementDistance = ( engagementDistanceMin + engagementDistanceMax ) * 0.5;
	half_engagement_width = Abs( engagementDistanceMax - engagementDistance );
	
	enemy_origin = ( enemy.origin[0], enemy.origin[1], 0 );
	
	vec_enemy_to_self = VectorNormalize( ( self.origin[0], self.origin[1], 0 ) - enemy_origin );
		
	foreach( point in queryResult.data )
	{
		point.distAwayFromEngagementArea = 0;	// <-------  result value initialization
	
		vec_enemy_to_point = ( point.origin[0], point.origin[1], 0 ) - enemy_origin;
			
		dist_in_front_of_enemy = VectorDot( vec_enemy_to_point, vec_enemy_to_self );
		dist_away_from_sweet_line = Abs( dist_in_front_of_enemy - engagementDistance );

		if( dist_away_from_sweet_line > half_engagement_width )
		{
			point.distAwayFromEngagementArea = dist_away_from_sweet_line - half_engagement_width;
		}
		
		too_far_dist = engagementDistanceMax * 1.1;
		too_far_dist_sq = ( (too_far_dist) * (too_far_dist) );
		
		dist_from_enemy_sq = distance2dSquared( point.origin, enemy_origin );
		
		if( dist_from_enemy_sq > too_far_dist_sq )
		{
			ratioSq = dist_from_enemy_sq / too_far_dist_sq;
			dist = ratioSq * too_far_dist;
			dist_outside = dist - too_far_dist;
			
			if( dist_outside > point.distAwayFromEngagementArea )
			{
				point.distAwayFromEngagementArea = dist_outside;
			}
		}
	}
}

function PositionQuery_Filter_DistAwayFromTarget( queryResult, targetArray, distance, tooClosePenalty )
{
	if ( !isdefined( targetArray ) || !isArray( targetArray ) )
	{
		return;
	}

	foreach( point in queryResult.data )
	{
		tooClose = false;
		foreach( target in targetArray )
		{
			origin = undefined;
			if ( IsVec( target ) )
			{
				origin = target;
			}
			else if ( IsSentient( target ) && IsAlive( target ) )
			{
				origin = target.origin;
			}
			else if ( IsEntity( target ) )
			{
				origin = target.origin;
			}

			if ( isdefined( origin ) && distance2dSquared( point.origin, origin ) < ( (distance) * (distance) ) )
			{
				tooClose = true;
				break;
			}
		}

		if ( tooClose )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "TooCloseToOthers" ] = tooClosePenalty;    #/    point.score += tooClosePenalty;;
		}
	}
}

function DistancePointToEngagementHeight( origin, enemy, engagementHeightMin, engagementHeightMax )
{
	if( !isdefined( enemy ) )
		return undefined;

	result = 0;

	engagementHeight = 0.5 * ( self.settings.engagementHeightMin + self.settings.engagementHeightMax );
	half_height = Abs( engagementHeightMax - engagementHeight );

	targetHeight = enemy.origin[2] + engagementHeight;
	distFromEngagementHeight = Abs( origin[2] - targetHeight );

	if ( distFromEngagementHeight > half_height )
	{
		result = distFromEngagementHeight - half_height;
	}

	return result;
}

function PositionQuery_Filter_EngagementHeight( queryResult, enemy, engagementHeightMin, engagementHeightMax )
{
	if( !isdefined( enemy ) )
		return;

	engagementHeight = 0.5 * ( engagementHeightMin + engagementHeightMax );
	half_height = Abs( engagementHeightMax - engagementHeight );

	foreach( point in queryResult.data )
	{
		point.distEngagementHeight = 0;	// <-------  result value initialization

		targetHeight = enemy.origin[2] + engagementHeight;
		distFromEngagementHeight = Abs( point.origin[2] - targetHeight );

		if ( distFromEngagementHeight > half_height )
		{
			point.distEngagementHeight = distFromEngagementHeight - half_height;
		}
	}
}

function PositionQuery_PostProcess_RemoveOutOfGoalRadius( queryResult, tolerance = 1 )
{
	for( i = 0; i < queryResult.data.size; i++ )
	{
		point = queryResult.data[i];
		if ( point.distToGoal > tolerance )
		{
			ArrayRemoveIndex( queryResult.data, i );
			i--;
		}
	}
}

function UpdatePersonalThreatBias_AttackerLockedOnToMe( threat_bias, bias_duration, get_perfect_info, update_last_seen ) // self == sentient
{
	UpdatePersonalThreatBias_ViaClientFlags( self.locked_on, threat_bias, bias_duration, get_perfect_info, update_last_seen );
}

function UpdatePersonalThreatBias_AttackerLockingOnToMe( threat_bias, bias_duration, get_perfect_info, update_last_seen ) // self == sentient
{
	UpdatePersonalThreatBias_ViaClientFlags( self.locking_on, threat_bias, bias_duration, get_perfect_info, update_last_seen );
}

function UpdatePersonalThreatBias_ViaClientFlags( client_flags, threat_bias, bias_duration, get_perfect_info = true, update_last_seen = true ) // self == sentient
{
	assert( isdefined( client_flags ) );
	
	remaining_flags_to_process = client_flags;
	for ( i = 0; remaining_flags_to_process && i < level.players.size; i++ )
	{
		attacker = level.players[ i ];
		if ( isdefined( attacker ) )
		{
			client_flag = ( 1 << attacker getEntityNumber() );
			if ( client_flag & remaining_flags_to_process )
			{
				self SetPersonalThreatBias( attacker, Int( threat_bias ), bias_duration );
				
				if ( get_perfect_info )
					self GetPerfectInfo( attacker, update_last_seen );
				
				remaining_flags_to_process &= ~client_flag;
			}
		}
	}
}

/#
function UpdatePersonalThreatBias_Bots( threat_bias, bias_duration ) // self == sentient
{
	foreach( player in level.players )
	{
		if (player util::is_bot())
		{
			self SetPersonalThreatBias( player, Int( threat_bias ), bias_duration );
		}
	}
}
#/
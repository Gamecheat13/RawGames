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
function fire_for_time( totalFireTime, turretIdx, target )
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

	fireCount = int( floor( totalFireTime / weapon.fireTime ) ) + 1;

	__fire_for_rounds_internal( fireCount, weapon.fireTime, turretIdx, target );
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

	self util::waittill_any_timeout( maxtime, "near_goal", "force_goal", "reached_end_node", "goal", "set_new_goal" );
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

	if ( !IsAlive( self ) )
	{
		self thread predicted_collision();
	}

	while ( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );
		
		empedOrOff = ( self get_current_state() === "emped" || self get_current_state() === "off" );
		
		// bounce off walls
		if ( normal[2] < 0.6 || ( IsAlive( self ) && !empedOrOff ) ) // stable or active
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
			if ( isdefined( self.settings ) && isdefined( self.settings.secondarycrashfx ) )
			{
				CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, (0,0,0), self.velocity, self.settings.secondarycrashfx );
			}
			else
			{
				CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, (0,0,0), self.velocity );
			}

			//self playsound( "veh_qrdrone_explo" );
			self thread vehicle_death::death_fire_loop_audio();
			self notify( "crash_done" );
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
		self SetVehVelocity( velocity );
		{wait(.05);};
	}
}


//self is vehicle
function immolate( attacker )
{
	self endon( "death" );
	self kill();
}


//self is vehicle
function iff_override( owner,time = 10 )
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
	
	wait( (isDefined(self.settings)?self.settings.ifftimetillrevert:time) );
	
	self iff_override_team_switch_behavior( self._iffoverride_oldTeam );
	if(isDefined(self.iff_override_cb))
		self [[self.iff_override_cb]](false);
	
}

function iff_override_team_switch_behavior( team )
{
	self endon( "death" );
	
	self TurnOff();

	wait( 2 );
	
	self SetTeam( team );
	
	self TurnOn();
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
	self CancelAIMove();
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
}

function shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( self ) && isdefined( weapon ) && weapon.isEmp && sMeansOfDeath != "MOD_IMPACT" )
	{
		if ( self should_emp( eInflictor, eAttacker ) )
		{
			minEmpDownTime = 0.8 * self.settings.empdowntime;
			maxEmpDownTime = 1.2 * self.settings.empdowntime;
			self notify ( "emped", RandomFloatRange( minEmpDownTime, maxEmpDownTime ) );
		}
	}

	return iDamage;
}

function should_emp( eInflictor, eAttacker )
{
	empCauser = ( isdefined( eAttacker ) ? eAttacker : eInflictor );
	if ( !isdefined( empCauser ) )
		return false;
         
	if ( level.teamBased )
	{		
		return ( self.team != empCauser.team );
	}
	else
	{
		if ( isdefined( self.owner ) )
		{
			return ( self.owner != empCauser );
		}	
		
		return ( self != empCauser );
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
function start_scripted( disable_death_state )
{
	self set_state( "scripted" );
	self._no_death_state = disable_death_state;
}

function stop_scripted( statename )
{
	if ( is_instate( "scripted" ) )
	{
		if ( isdefined( statename ) )
		{
			self set_state( statename );
		}
		else 
		{
			previous_state = self get_previous_state();

			if ( isdefined( previous_state ) )
			{
				self set_state( previous_state );
			}
			else
			{
				self set_state( "combat" );
			}
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
						  &defaultstate_emped_exit );
	
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
	ClearAllLookingAndTargeting();
	ClearAllMovement();

	//self SetBrake( 1 );
	self.takedamage = 0;
	self vehicle_death::death_cleanup_level_variables();
}

function defaultstate_death_update( params )
{
	self endon( "death" );	

	self vehicle_death::death_fx();

	waittime = self.waittime_before_delete;
	shouldDelete = self.delete_on_death;

	if ( !isdefined( self.damage_on_death ) || self.damage_on_death == true )
	{
		self thread vehicle_death::death_radius_damage();
	}
	
	if ( ( isdefined( shouldDelete ) && shouldDelete ) )
	{
		util::deleteAfterTimeAndNetworkFrame( waittime );
	}
	else
	{
		util::waitForTime( waittime );
		
		self vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
		owner = self GetVehicleOwner();
		if ( isDefined( owner ) && self isRemoteControl() )
		{
			wait 4; //let player see some destruction
			if ( isDefined( self ) )
			{
				sanity = self GetVehicleOwner();
				if ( isDefined( sanity ) && isDefined( owner ) && sanity == owner )
				{
					owner unlink();
					wait 1;
				}
			}
		}
		if ( isDefined( self ) )
		{
			self FreeVehicle();
		}
	}
}
// ----------------------------------------------

// ----------------------------------------------
// State: scripted
// ----------------------------------------------
function defaultstate_scripted_enter( params )
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	if ( HasASM( self ) )
	{
		self ASMRequestSubstate( "locomotion@movement" );
	}
}

// no defaultstate_scripted_update() function

function defaultstate_scripted_exit( params )
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
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
		self SetPhysAcceleration( ( 0, 0, -100 ) );
		self thread level_out_for_landing();
		self SetRotorSpeed( 0 );
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
		//the previous call to nudge_collision might have returned, make sure it has terminated though
		self notify( "power_off_done" );
		self thread nudge_collision();
		self SetRotorSpeed( 1 );
	}
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

	pathfailcount = 0;
	//blink the lights to make the vehicle look crazy
	self thread flash_team_switching_lights();
	
	targets = GetAITeamArray( "axis", "team3" );
	ArrayRemoveValue( targets, self );
	closest = array::get_closest( self.origin, targets );
	
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
	self RadiusDamage( self.origin + ( 0, 0, 5 ), self.settings.surgedamageradius, 1000, 1500, attacker, "MOD_EXPLOSIVE" );
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
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	
	if( IsAirborne( self ) )
	{
		self SetPhysAcceleration( ( 0, 0, -100 ) );
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
		//the previous call to nudge_collision might have returned, make sure it has terminated though
		self notify( "power_off_done" );
		self thread nudge_collision();
		self SetRotorSpeed( 1 );
	}
	if ( params.laserOn === true )
	{
		self LaserOn();
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
	params.driver EnableInvulnerability();
	
	params.driver.ignoreme = true;
	self.turretRotScale = 1;
	self.team = params.driver.team;
	if ( HasASM( self ) )
	{
		self ASMRequestSubstate( "locomotion@movement" );
	}

	ClearAllLookingAndTargeting();
	ClearAllMovement();
}

function defaultstate_driving_exit( params )
{
	self EnableAimAssist();
	params.driver DisableInvulnerability();
	params.driver.ignoreme = false;
	self.turretRotScale = 1;

	ClearAllLookingAndTargeting();
	ClearAllMovement();
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
		return self.goalpos;
	}
	
	point_spacing = 90;

	queryResult = PositionQuery_Source_Navigation( self.origin, 0, 2000, 300/*half height*/, point_spacing, self, point_spacing * 2 );

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
			point vehicle_ai::AddScore( "engagementDist", -point.distAwayFromEngagementArea );
			
			if( distance2dSquared( self.origin, point.origin ) < 170 * 170 )
			{
				point vehicle_ai::AddScore( "tooCloseToSelf", -170 );
			}
			
			if( isdefined( point.sight ) && point.sight )
			{
				point vehicle_ai::AddScore( "sight", 250 );
			}
			if( isdefined( point.sight2 ) && point.sight2 )
			{
				point vehicle_ai::AddScore( "sight2", 150 );
			}
			if( isdefined( point.sight3 ) && point.sight3 )
			{
				point vehicle_ai::AddScore( "sight3", 150 );
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
				point vehicle_ai::AddScore( "tooCloseToSelf", -100 );
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

// self == pointStruct
function AddScore( name, score )
{
	/#
	if ( !isdefined( self._scoreDebug ) )
	{
		self._scoreDebug = [];
	}
	self._scoreDebug[ name ] = score;
#/
	self.score += score;
}

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
		point AddScore( "random", score );
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
			point AddScore( "outOfGoalAnchor", score );
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
			point vehicle_ai::AddScore( "TooCloseToOthers", tooClosePenalty );
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
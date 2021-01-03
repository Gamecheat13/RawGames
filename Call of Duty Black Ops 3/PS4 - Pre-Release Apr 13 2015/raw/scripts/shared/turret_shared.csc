#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace turret;

function autoexec __init__sytem__() {     system::register("turret",&__init__,undefined,undefined);    }

/*-----------------------------------------------------------------------------------------------------

****************************************************************** 
Turret Overview
******************************************************************

	This script handles all turret functionality.
	
	Below are a list of script command available.
	
	See the module:-	t6\game\share\devraw\scripts\module_turret.gsc for a group simple examples that shows the 
						scripter in-game MG Turrent and Helicopter Turret examples.
						
	Note:				An MG Turret typicaly only has 1 turret.
						Helicopter can have upto 5 turrets, the main turret and 4 gunner turrets.
						
	Setting up an MG Turret in Radient:-
	 - See the file module_turret.gsc for a description of how to setup a manned MG Turret in Radiant.
						

******************************************************************
Using, Activating and Pausing a Turret
******************************************************************

	is_turret_enabled( n_index )
		- Checks to see if the turret is enabled.

	enable( n_index )
		- Enables the given turret.
		
	disable( [n_index] )
		- Disables the given turret, but it keeps its targetted information.

	pause( [n_index], <time, 0=infinite> )
		- Pause turret for X time.
		
	unpause( [n_index] )
		- remove the pause restriction from the turret.

	stop( <n_index> )
		- Stops the turrets current action and puts it back in search for enemy mode.


******************************************************************
Turret "User" Functios - Turrets that need Users to Operate
******************************************************************

	does_need_user( <n_index> )
		- Does the turret need a used (node) to oprerate.

	does_have_user( <n_index> )
		- Does the turret currently have a user?

	get_user( <index> )
		- Gets the user of this turret.

	is_current_user( <ai_user>, [n_index] )
		-  Checks to see if an AI is the current user.

	SetOnTargetAngle( <angle> )
		- The turret has to be aiming within this number of degrees at the target to get the 
		  "turret_on_target" notify.


******************************************************************
Turret Targetting Functions
******************************************************************
		
	set_target( <e_target>, [v_offset], [n_index] )
		- Sets the target of this turret.

	get_target( [n_index] )
		- Returns turret target data for this turret.
		
	clear_target( [n_index] )
		- Clears turret target data for this turret.

	set_target_flags( <n_flags>, [n_index] )
		 - Sets a sub-set of targets for the turret.

	set_target_ent_array( [a_ents] )
		- Passes an array of targets to the turret to kill.
		
	clear_target_ent_array()
		- Scripters ability to clear the turrets ent target array.

	set_ignore_ent_array( [a_ents] )
		- Passes an array of ents to the turret to ignore.

	clear_ignore_ent_array()
		- Scripters ability to clear the turrets ent ignore array.

	set_best_target_func( <::function>, [n_index] )
		 - Custom override function, scripter can use to custermise their choice from potential targets;

	is_target_in_view( e_target, n_index )
		 - Lets script know if the turret can aim for a target within its GDT movement constraints.

	can_turret_shoot_target( e_target, n_index ) 
		- Basically is there anythinhg blocking the turrets shot (geo etc..)

	can_hit_target( e_target, turret_index )
		- Basically combines the two functions above ( is_target_in_view() and can_turret_shoot_target() )

	set_turret_max_target_distance( n_dist )
		- Can be used to limit the maximum distance of a turret's target



******************************************************************
Turret Firing Functions
******************************************************************

	fire( [n_index] )
	 - Fires a turret.
			 
	fire_for_time( <n_time> , [n_index] )
		- Fires a turret for a time, blocks for n_time.
		
	shoot_at_target( <ent>, <time> );
		- Gets a turret to go into manual mode and fire at a specific target, ignoring all other threats.

	set_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index )
	 - Sets the burst parameters for a turret.


******************************************************************
Useful Misc Turret Functions
******************************************************************

	set_turret_occupy_no_target_time( n_index )
		- How long an AI will stay inside a turret if there is no target, default is 2.0 seconds.
		
	set_turret_ignore_line_of_sight( b_ignore, n_index )
		- set this turret to ignore line of sight

	get_weapon( n_index )
		 - Gets the turrets weapon.
	
	get_parent( n_index )
		 - Gets the turrets parent entity.
		 
	enable_laser( n_index, b_enable )
		 - Turns on the laser.
		 
	enable_emp( n_index, b_enable )
		 - Allows this turret to be emped which shuts it down and turns of the laser if enabled.

	NOTIFY: "terminate_all_turrets_firing"  Use this notify on a vehicle to immediately stop any burst firing loops it may have running.
	 
		 
******************************************************************
Script NOTIFIES
******************************************************************

TURRET
	"turret_enabled"				- When the turret has been enabled.
	"turret_disabled"				- When the durret has been disabled
	"user_using_turret"				- Sent out when the ai_user first gets on the turret.
	"_stop_turret"					- Sent out when a turret is stops firint at its latest target.
	"turret_target_out_of_range"	- Sent when the target of a turret moves out of range.
	"target_array_destroyed"		- Send out when a target array has bee cleared
	"shooting"						- Sent out bu turret when it starts shooting
	"turret_on_target"				- Sent out when the turret has a target in its sights
	"gunner_turret_on_target"		- Sent out when a turrets gunner has a target in its sights
	"idle"							- Sent out when the turret has no targets in sight 
			
----------------------------------------------------------------------------------------------------- */
	
/*-----------------------------------------------------------------------------------------------------
	Turret Struct Data
	
	is_enabled
	w_weapon
	str_team
	e_parent
	e_target
	ai_user
	e_next_target
	n_target_flags
	n_burst_fire_min
	n_burst_fire_max
	n_burst_wait_min
	n_burst_wait_max
	
-----------------------------------------------------------------------------------------------------*/

// The amount of time a turret will wait with no target before calling _drop_turret()
//    dropping the turret causes the user to exit the turret


function __init__()
{
	clientfield::register( "vehicle", "toggle_lensflare", 1, 1, "int" );
	
	level._turrets = SpawnStruct();
}

/@
"Name: get_weapon( n_index )"
"Summary: Gets a turret's weapon"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: turret get_weapon();"
@/
function get_weapon( n_index = 0 )
{
	w_weapon = self SeatGetWeapon( n_index );
	return w_weapon;
}

/@
"Name: get_parent( n_index )"
"Summary: Gets a turret's parent"
	
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: turret get_parent( n_index );"
@/
function get_parent( n_index )
{
	return _get_turret_data( n_index ).e_parent;
}

function laser_death_watcher()
{
	self notify( "laser_death_thread_stop" );
	self endon( "laser_death_thread_stop" );
	self waittill( "death" );
	if(isDefined(self))
	{
		self LaserOff();
	}
}

function enable_laser( b_enable, n_index )
{	
	if ( b_enable )
	{
		_get_turret_data( n_index ).has_laser = true;		
		self LaserOn();
		self thread laser_death_watcher();
	}
	else
	{
		_get_turret_data( n_index ).has_laser = undefined;
		self LaserOff();
		self notify( "laser_death_thread_stop" );
	}
}

function watch_for_flash()
{
	self endon( "watch_for_flash_and_stun" );
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "flashbang", pct_dist, pct_angle, attacker, team );
		self notify( "damage", 1, attacker, undefined, undefined, undefined, undefined, undefined, undefined, "flash_grenade" );
	}
}

function watch_for_flash_and_stun( n_index )
{
	self notify( "watch_for_flash_and_stun_end" );
	self endon( "watch_for_flash_and_stun" );
	self endon( "death" );
	
	self thread watch_for_flash();
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon );

		if ( weapon.doStun )
		{
			if ( isdefined( self.stunned ) )
			{
				continue;
			}
			
			self.stunned = true;
			
			stop( n_index, true );
			
			wait RandomFloatRange( 5, 7 );
			
			self.stunned = undefined;			
		}
	}
}

function emp_watcher( n_index )
{
	self notify( "emp_thread_stop" );
	self endon( "emp_thread_stop" );
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon );

		if ( weapon.isEmp )
		{
			if ( isdefined( self.emped ) )
			{
				continue;
			}
			
			self.emped = true;
			
			if ( isdefined( _get_turret_data( n_index ).has_laser ) )
			{
				self LaserOff();
			}
			
			stop( n_index, true );
			
			wait RandomFloatRange( 5, 7 );
			
			self.emped = undefined;
			
			if ( isdefined( _get_turret_data( n_index ).has_laser ) )
			{
				self LaserOn();
			}
		}
	}
}

function enable_emp( b_enable, n_index )
{
	if ( b_enable )
	{
		_get_turret_data( n_index ).can_emp = true;
		self thread emp_watcher( n_index );
		self.takedamage = true;
	}
	else
	{
		_get_turret_data( n_index ).can_emp = undefined;
		self notify( "emp_thread_stop" );
	}
}

function set_team( str_team, n_index )
{
	_get_turret_data( n_index ).str_team = str_team;

	// set the internal code team
	self.team = str_team;
}

function get_team( n_index )
{
	str_team = undefined;
	
	s_turret = _get_turret_data( n_index );
	
	str_team = self.team;
		
	if ( !isdefined( s_turret.str_team ) )
	{
		s_turret.str_team = str_team;
	}
	
	return str_team;
}
 
/@
"Name: is_turret_enabled( n_index )"
"Summary: Checks to see if a turret is enabled"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: if ( is_turret_enabled( n_index ) );"
@/
function is_turret_enabled( n_index )
{
	return _get_turret_data( n_index ).is_enabled;
}

/@
"Name: does_need_user( [n_index] )"
"Summary: Checks to see if a turret needs a user"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: if ( does_need_user( n_index ) );"
"SPMP: singleplayer"
@/
function does_need_user( n_index )
{
	return ( isdefined( _get_turret_data( n_index ).b_needs_user ) && _get_turret_data( n_index ).b_needs_user );
}

/@
"Name: does_have_user( n_index )"
"Summary: Checks to see if a turret has a user"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: if ( turret turret::does_have_user( n_index ) );"
@/
function does_have_user( n_index )
{
	return IsAlive( get_user( n_index ) );
}

/@
"Name: get_user( n_index )"
"Summary: Gets the user of this turret"

"OptionalArg: [n_index]: Index of the turret for a vehicle turret"

"Example: ai_user = turret::get_user( n_index );"
@/

function get_user( n_index )
{
	return ( self GetSeatOccupant( n_index ) );
}

function _set_turret_needs_user( n_index, b_needs_user )
{
	s_turret = _get_turret_data( n_index );
	
	if ( b_needs_user )
	{
		s_turret.b_needs_user = true;
		self thread watch_for_flash_and_stun( n_index );
	}
	else
	{
		self notify( "watch_for_flash_and_stun_end" );
		s_turret.b_needs_user = false;
	}
}

/@
"Name: set_target_ent_array( a_entities, n_index )"
"Summary: Sends a list of targets for the turret.  NOTE - Sends notify when targets are all dead"

"MandatoryArg: <a_targets> The Array of Targets you want the turret to destroy"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: set_target_ent_array( a_ents );"
@/

// self = turret or vehicle
function set_target_ent_array( a_ents, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.priority_target_array = a_ents;
}

/@
"Name: add_priority_target( ent_or_ent_array, n_index )"
"Summary: Adds a single ent or array of ents to be a priority target of a turret"

"MandatoryArg: <ent_or_ent_array> The ent or array of entity targets the turret should attack"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: claw_turret add_priority_target( a_balcony_guys )"
@/
function add_priority_target( ent_or_ent_array, n_index )
{
	s_turret = _get_turret_data( n_index );
	
	// priority_target_array should always take an array
	if ( !IsArray( ent_or_ent_array ) )  // single ent
	{
		a_new_targets = [];
		a_new_targets[ 0 ] = ent_or_ent_array;
	}
	else // array
	{
		a_new_targets = ent_or_ent_array;
	}
	
	// add new targets to existing priority_target_array
	if ( isdefined( s_turret.priority_target_array ) )
	{
		a_new_targets = ArrayCombine( s_turret.priority_target_array, a_new_targets, true, false );
	}
	
	s_turret.priority_target_array = a_new_targets;	
}

/@
"Name: clear_target_ent_array( n_index )"
"Summary: Clears the turrets target array"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: clear_target_ent_array();"
@/

function clear_target_ent_array( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.priority_target_array = undefined;
}

/@
"Name: set_ignore_ent_array( a_ents, n_index )"
"Summary: Sends a list of targets for the turret to ignore."

"MandatoryArg: <a_ents> The Array of Targets you want the turret to IGNORE"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: set_ignore_ent_array( a_ents );"
@/

// self = turret or vehicle
function set_ignore_ent_array( a_ents, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.a_ignore_target_array = a_ents;
}

/@
"Name: clear_ignore_ent_array( n_index )"
"Summary: Clears the turrets target array"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: clear_ignore_ent_array();"
@/

function clear_ignore_ent_array( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.a_ignore_target_array = undefined;
}

function _wait_for_current_user_to_finish( n_index )
{
	self endon( "death" );
	
	while ( IsAlive( get_user( n_index ) ) )
	{
		wait .05;
	}
}

/@
"Name: is_current_user( ai_user, n_index )"
"Summary: Checks to see if an AI is the current user"

"MandatoryArg: <ai_user> The user of this turret"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: if ( is_current_user( ai_user, n_index ) );"
@/
function is_current_user( ai_user, n_index )
{
	ai_current_user = get_user( n_index );
	return ( IsAlive( ai_current_user ) && ( ai_user == ai_current_user ) );
}

/@
"Name: set_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index )"
"Summary: Sets the burst parameters for a turret"

"MandatoryArg: <n_fire_min> The minimum time to fire the turret for"
"MandatoryArg: <n_fire_max> The maximum time to fire the turret for"
"MandatoryArg: <n_wait_min> The minimum time to wait between firing"
"MandatoryArg: <n_wait_max> The maximum time to wait between firing"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: turret set_burst_parameters( 1, 2, 3, 4 ); // slow burst firing"
@/
function set_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.n_burst_fire_min = n_fire_min;
	s_turret.n_burst_fire_max = n_fire_max;
	s_turret.n_burst_wait_min = n_wait_min;
	s_turret.n_burst_wait_max = n_wait_max;
}

/@
"Name: set_on_target_angle( n_angle, n_index )"
"Summary: Sets the angle at which the turret will be on target"

"MandatoryArg: <n_angle> angle at which the turret will be on target"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: turret set_on_target_angle( 1, 5 ); // on target at 5 degrees from target position"
@/
function set_on_target_angle( n_angle, n_index )
{
	s_turret = _get_turret_data( n_index );
	
	if ( !isdefined( n_angle ) )
	{	
		if ( s_turret.str_guidance_type != "none" )
		{
			n_angle = 10;
		}
		else
		{
			n_angle = 2;
		}
	}
	
	if ( n_index > 0 )
	{
		self SetOnTargetAngle( n_angle, n_index - 1 );
	}
	else
	{
		self SetOnTargetAngle( n_angle );
	}
}

/@
"Name: set_target( e_target, v_offset, n_index )"
"Summary: Sets the target of this turret"

"MandatoryArg: <e_target> The target of this turret"
"OptionalArg: [v_offset] Offset from the turret target"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret set_target( e_target, v_offset, n_index );"
@/
function set_target( e_target, v_offset, n_index )
{
	s_turret = _get_turret_data( n_index );

	if ( !isdefined( v_offset ) )
	{
		v_offset = _get_default_target_offset( e_target, n_index );	
	}
		
	if ( !isdefined( n_index ) || n_index == 0 )
	{
		self SetTargetEntity( e_target, v_offset );
	}
	else
	{
		self SetTargetEntity( e_target, v_offset, n_index - 1 );
	}
	
	s_turret.e_target = e_target;
	s_turret.e_last_target = e_target;
	s_turret.v_offset = v_offset;
}

function _get_default_target_offset( e_target, n_index )
{
	s_turret = _get_turret_data( n_index );
	if ( s_turret.str_weapon_type == "bullet" )
	{
		if ( isdefined( e_target ) )
		{
			if ( IsPlayer( e_target ) )
			{
				z_offset = RandomIntRange( 40, 50 );
			}
			else if ( ( e_target.type === "human" ) )
			{
				z_offset = RandomIntRange( 20, 60 );
			}

			if ( isdefined(e_target.z_target_offset_override) )
			{
				if( !isdefined(z_offset) )
				{
					z_offset = 0;
				}
				z_offset += e_target.z_target_offset_override;
			}
		}
	}
	
	if(!isdefined(z_offset))z_offset=0;		
	v_offset = ( 0, 0, z_offset );
	
	return v_offset;
}

/@
"Name: get_target( n_index )"
"Summary: Returns turret target data for this turret"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: has_target = isdefined( get_target( n_index ) );"
@/
function get_target( n_index )
{
	return _get_turret_data( n_index ).e_target;
}

function is_target( e_target, n_index )
{
	e_current_target = get_target( n_index );
	
	if ( isdefined( e_current_target ) )
	{
		return ( e_current_target == e_target );
	}
	
	return false;
	
}

/@
"Name: clear_target( n_index )"
"Summary: Clears turret target data for this turret"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret clear_target( n_index );"
@/
function clear_target( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret flag::clear( "turret manual" );
	
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
		
	if ( !isdefined( n_index ) || ( n_index == 0 ) )
	{
		self ClearTurretTarget();
	}
	else
	{
		self ClearGunnerTarget( n_index - 1 );
	}
}

/@
"Name: set_target_flags( n_flags, n_index )"
"Summary: Sets the flags for the types of targets the turret should pick"

"MandatoryArg: <n_flags> The types of targets - currently supports TURRET_TARGET_AI, TURRET_TARGET_PLAYERS, TURRET_TARGET_DRONES, TURRET_TARGET_VEHICLES"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_bunker_turret set_target_flags( TURRET_TARGET_AI | TURRET_TARGET_PLAYERS, n_index );"
@/
function set_target_flags( n_flags, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.n_target_flags = n_flags;
}

function _has_target_flags( n_flags, n_index )
{
	n_current_flags = _get_turret_data( n_index ).n_target_flags;
	return ( ( n_current_flags & n_flags ) == n_flags);
}


/@
"Name: set_max_target_distance( n_distance )"
"Summary: Sets the maximum distance a target can be, ( NOTE: 0 or undefined == unlimited distance)"

"MandatoryArg: <n_distance> The maximum distacne a target can be, ( NOTE: 0 or undefined == unlimited distance)"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_vehicle set_max_target_distance( 2048, 1 );"
@/
function set_max_target_distance( n_distance, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.n_max_target_distance = n_distance;
}

/@
"Name: fire( n_index )"
"Summary: Fires a turret"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret fire();"
@/
function fire( n_index )
{
	s_turret = _get_turret_data( n_index );
	
	assert( isdefined( n_index ) && ( n_index >= 0 ), "Invalid index specified to fire vehicle turret." );
		
	if ( n_index == 0 )
	{
		self FireWeapon( 0, s_turret.e_target );
	}
	else
	{
		ai_current_user = get_user( n_index );
		if(isdefined(ai_current_user) && ( isdefined( ai_current_user.is_disabled ) && ai_current_user.is_disabled ))
			return;
	
		if ( isdefined( s_turret.e_target ) )
		{
			self SetGunnerTargetEnt( s_turret.e_target, s_turret.v_offset, n_index - 1 );
		}
		
		self FireWeapon( n_index, s_turret.e_target, s_turret.v_offset, s_turret.e_parent );
	}

	s_turret.n_last_fire_time = GetTime();
}

/@
"Name: stop( n_index, b_clear_target )"
"Summary: Stops a turret"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"
"OptionalArg: [b_clear_target] Clears the turret target. default true."

"Example: e_turret stop();"
@/
function stop( n_index, b_clear_target = false )
{
	s_turret = _get_turret_data( n_index );
	
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
	
	s_turret flag::clear( "turret manual" );
	
	if ( b_clear_target )
	{
		clear_target( n_index );
	}
	
	self notify( "_stop_turret" + _index( n_index ) );
}

/@
"Name: fire_for_time( n_time , n_index )"
"Summary: Fires a turret for a time, blocks for n_time"

"MandatoryArg: <n_time> The time to fire the turret for"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret fire_for_time( 3 );"
@/
function fire_for_time( n_time, n_index = 0 )
{
	Assert( isdefined( n_time ), "n_time is a required parameter for _turet::fire_for_time." );
	
	self endon( "death" );
	self endon( "drone_death" );
	
	self endon( "_stop_turret" + _index( n_index ) );
	// MikeA: 4/18/11	
	self endon( "turret_disabled" + _index( n_index ) );
	
	/* only one of these threads at a time */

	self notify( "_fire_turret_for_time" + _index( n_index ) );
	self endon( "_fire_turret_for_time" + _index( n_index ) );
	
	b_fire_forever = false;
	if ( n_time < 0)
	{
		b_fire_forever = true;
	}
	else
	{
		/#
		w_weapon = get_weapon( n_index );
		assert( n_time >= w_weapon.fireTime, "Fire time (" + n_time + ") must be greater than the weapon's fire time. weapon fire time = " + w_weapon.fireTime );
		#/
	}
	
	while ( ( n_time > 0 ) || b_fire_forever )
	{
		//IPrintLnBold( "BURST FIRE START LOOP" );
	
		n_burst_time = _burst_fire( n_time, n_index );
		
		if ( !b_fire_forever )
		{
			n_time -= n_burst_time;
		}
	}
}

/@
"Name: shoot_at_target( e_target, n_time, v_offset, n_index )"
"Summary: Fires turret at given target"

"MandatoryArg: <e_target> The target of this turret"
"MandatoryArg: <n_time> The time to fire the turret for"
"OptionalArg: [v_offset] Offset from the turret target"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"
"OptionalArg: [b_just_once] Ignore the time parameter and just fire once"

"Example: self thread shoot_at_target( e_best_target, -1, undefined, n_index );"
@/

// self = turret or vehicle
function shoot_at_target( e_target, n_time, v_offset, n_index, b_just_once )
{
	Assert( isdefined( e_target ), "Undefined target passed to shoot_at_target()." );
	
	self endon( "drone_death" );
	self endon( "death" );
	
	// Manual mode will stop the turret searching for new targets
	s_turret = _get_turret_data( n_index );
	s_turret flag::set( "turret manual" );
	
	_shoot_turret_at_target( e_target, n_time, v_offset, n_index, b_just_once );
	
	s_turret flag::clear( "turret manual" );
}

function _shoot_turret_at_target( e_target, n_time, v_offset, n_index, b_just_once )
{
	self endon( "drone_death" );
	self endon( "death" );
	self endon( "_stop_turret" + _index( n_index ) );
	self endon( "turret_disabled" + _index( n_index ) );
	
	// only one of these threads at a time
	self notify( "_shoot_turret_at_target" + _index( n_index ) );
	self endon( "_shoot_turret_at_target" + _index( n_index ) );
	
	if ( n_time == -1 )
	{
		e_target endon( "death" );
	}
	
	if ( !isdefined( b_just_once ) )
	{
		b_just_once = false;
	}

	set_target( e_target, v_offset, n_index );
	
	_waittill_turret_on_target( e_target, n_index );
	
	if ( b_just_once )
	{
		turret::fire( n_index );
	}
	else
	{
		fire_for_time( n_time, n_index );
	}
}

function _waittill_turret_on_target( e_target, n_index )
{
	do
	{
		wait .5;
		if ( !isdefined( n_index ) || ( n_index == 0 ) )
		{
			self waittill( "turret_on_target" );
		}
		else
		{
			self waittill( "gunner_turret_on_target" );
		}
	}
	while ( isdefined( e_target ) && !can_hit_target( e_target, n_index ) );
}

/@
"Name: shoot_at_target_once( e_target, v_offset, n_index )"
"Summary: Fires turret at given target once"

"MandatoryArg: <e_target> The target of this turret"
"OptionalArg: [v_offset] Offset from the turret target"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: self thread shoot_at_target_once( e_best_target, undefined, n_index );"
@/
function shoot_at_target_once( e_target, v_offset, n_index )
{
	shoot_at_target( e_target, 0, v_offset, n_index, true );
}

/@
"Name: enable( n_index, b_user_required, v_offset )"
"Summary: Enables the given turret"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"
"OptionalArg: [b_user_required] Determines if the turret require a user to fire"
"OptionalArg: [v_offset] Offset from the turret target"

"Example: e_turret turret::enable( 1 ); // enable gunner1"
@/
function enable( n_index, b_user_required, v_offset )
{
	if ( isAlive(self) && !is_turret_enabled( n_index ) )
	{
		_get_turret_data( n_index ).is_enabled = true;
		self thread _turret_think( n_index, v_offset );
		self notify( "turret_enabled" + _index( n_index ) );
		
		if ( isdefined( b_user_required ) && ( !b_user_required ) )
		{
			_set_turret_needs_user( n_index, false );
		}
	}
}

/@
"Name: enable_auto_use( b_enable = true )"
"Summary: Enables a vehicle to automatically get AI turret users"

"CallOn: vehicle/turret"
"OptionalArg: [b_enable] Set to 'false' to turn off, 'true' to turn on (default)."

"Example: vh_truck turret::enable_auto_use( true )"
@/
function enable_auto_use( b_enable = true )
{
	self.script_auto_use = b_enable;
}

/@
"Name: disable( n_index )"
"Summary: Disables the given turret, But it keeps its targetted information"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret turret::disable();"
@/
function disable( n_index )
{
	if ( is_turret_enabled( n_index ) )
	{
		_drop_turret( n_index );

		// MikeA: 4/18/11		
		clear_target( n_index );
		
		_get_turret_data( n_index ).is_enabled = false;

		self notify( "turret_disabled" + _index( n_index ) );
	}
}

/@
"Name: pause( time, n_index )"
"Summary: Disables the given turret, But it keeps its targetted information"

"MandatoryArg: <time> Time to pause turret for, 0 for infinite"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret turret::pause( 0 );"
@/

function pause( time, n_index )
{
	s_turret = _get_turret_data( n_index );

	// Convert time to Milli Seconds
	if ( time > 0 )
	{
		time = time * 1000;
	}

	// If already paused, just add on the extra time
	if ( isdefined( s_turret.pause ) )
	{
		s_turret.pause_time = s_turret.pause_time + time;
	}
	else
	{
		s_turret.pause = 1;
		s_turret.pause_time = time;
		stop( n_index );
	}
}

/@
"Name: unpause( n_index )"
"Summary: Disables the given turret, But it keeps its targetted information"

"OptionalArg: [n_index] Index of the turret for a vehicle turret"
"Example: e_turret turret::unpause();"
@/

function unpause( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.pause = undefined;
}



// self = vehicle or turret
function _turret_think( n_index, v_offset )
{
	TURRET_THINK_TIME = Max( 1.5, get_weapon( n_index ).fireTime );
	
	no_target_start_time = 0;	// Time when turret last had a target
	
	self endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	
	/* only one think thread at a time */

	self notify( "_turret_think" + _index( n_index ) );
	self endon( "_turret_think" + _index( n_index ) );
	
	/# self thread _debug_turret_think( n_index ); #/
		
	self thread _turret_user_think( n_index );
		
	self thread _turret_new_user_think( n_index );
	
	s_turret = _get_turret_data( n_index );

	if ( isdefined( s_turret.has_laser ) )
	{
		self LaserOn();
	}
	
	while ( true )
	{
		s_turret flag::wait_till_clear( "turret manual" );
		
		n_time_now = GetTime();
		
		// Do we want to pause the turret?
		if ( self _check_for_paused( n_index ) || isdefined( self.emped ) || isdefined( self.stunned ) )
		{
			wait TURRET_THINK_TIME;
			continue;
		}
		
		a_potential_targets = _get_potential_targets( n_index );
		
		if ( !isdefined( s_turret.e_target )
		    || ( s_turret.e_target.health < 0 )
		    || !IsInArray( a_potential_targets, s_turret.e_target )
			|| s_turret _did_turret_lose_target( n_time_now ) )
		{
			stop( n_index );
		}
		
		// The turret picks the best candidate from the target array
		s_turret.e_next_target = _get_best_target_from_potential( a_potential_targets, n_index );

		/* If we have a new target, shoot at it */
		if ( isdefined( s_turret.e_next_target ) )
		{
			s_turret.b_target_out_of_range = undefined;
			s_turret.n_time_lose_sight = undefined;
			no_target_start_time = 0;
			
			if ( _user_check( n_index ) )
			{
				self thread _shoot_turret_at_target( s_turret.e_next_target, TURRET_THINK_TIME, v_offset, n_index );
			}
		}
		else
		{		
			// If we've been waiting for as target for too long, drop the turret (user AI exits)
			
			if ( no_target_start_time == 0 )
			{
				no_target_start_time = n_time_now;
			}
			
			// How long have we been waiting
			target_wait_time = ( n_time_now - no_target_start_time );
			
			// If we've been waitng for a target for too long, drop the turret
			if ( isdefined(s_turret.occupy_no_target_time) )
			{
				occupy_time = s_turret.occupy_no_target_time;
			}
			else
			{
				occupy_time = 3600;
			}
			
			//Only leave the turret if it is automated or if the target is a player and we lost sight
			bWasPlayerTarget = isdefined( s_turret.e_last_target ) && ( s_turret.e_last_target.health > 0 ) && IsPlayer(s_turret.e_last_target);
			
			if(bWasPlayerTarget)
				occupy_time = occupy_time / 4;
			
			if ( target_wait_time >= occupy_time )
			{
				_drop_turret( n_index, !bWasPlayerTarget );
			}
		}

		wait TURRET_THINK_TIME;
	}
}

// self = turret struct
function _did_turret_lose_target( n_time_now )
{
	if ( ( isdefined( self.b_target_out_of_range ) && self.b_target_out_of_range ) )
	{
		return true;
	}
	else if ( isdefined( self.n_time_lose_sight ) )
	{
		return ( ( n_time_now - self.n_time_lose_sight ) > 3000 );
	}
	
	return false;
}

function _turret_user_think( n_index )
{
	self endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	self endon( "_turret_think" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
	
	ai_user = self GetSeatOccupant( n_index );
			
	if ( IsActor( ai_user ) )
	{
		self thread _listen_for_damage_on_actor(ai_user, n_index);
	}
	
	while ( true )
	{
		_waittill_user_change( n_index );
		if ( !_user_check( n_index ) )
		{
			stop( n_index, true );
		}
		else
		{
			ai_user = self GetSeatOccupant( n_index );
			
			if ( IsActor( ai_user ) )
			{
				self thread _listen_for_damage_on_actor(ai_user, n_index);
			}
		}
	}
}

function _listen_for_damage_on_actor(ai_user, n_index)
{
	self endon( "death" );
	ai_user endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	self endon( "_turret_think" + _index( n_index ) );
	self endon( "exit_vehicle" );
	
	while(true)
	{
		ai_user waittill( "damage", n_amount, e_attacker, v_org, v_dir, str_mod );
		
		s_turret = _get_turret_data( n_index );
		
		if(isdefined(s_turret))
		{
			if(!isdefined(s_turret.e_next_target) && !isdefined(s_turret.e_target))
			{
				s_turret.e_last_target = e_attacker;
			}
		}
	}
}

function _waittill_user_change( n_index )
{
	ai_user = self GetSeatOccupant( n_index );
	
	if ( IsAlive( ai_user ) )
	{
		if ( IsActor( ai_user ) )
		{
			ai_user endon( "death" );
		}
		else if ( IsPlayer( ai_user ) )
		{
			self notify( "turret_disabled" + _index( n_index ) );  //turret was continuing to fire on its own
		}
	}
	
	self util::waittill_either( "exit_vehicle", "enter_vehicle" );
}

// self = turret or vehicle
function _check_for_paused( n_index )
{
	s_turret = _get_turret_data( n_index );
	
	s_turret.pause_start_time = GetTime();
	
	while ( isdefined( s_turret.pause ) )
	{
		if ( s_turret.pause_time > 0 )
		{
			time = GetTime();
			paused_time = time - s_turret.pause_start_time;
			if( paused_time > s_turret.pause_time )
			{
				s_turret.pause = undefined;
				return true;
			}
		}
		
		{wait(.05);};
	}
	
	return false;
}

// self = vehicle or turret
function _drop_turret( n_index, bExitIfAutomatedOnly )
{
	ai_user = get_user( n_index );
	
	if ( IsAlive( ai_user ) && (( isdefined( ai_user.turret_auto_use ) && ai_user.turret_auto_use ) || (isdefined(bExitIfAutomatedOnly) && !bExitIfAutomatedOnly)) )
	{	// only drop turret if auto use, not when scripter puts the AI in the vehicle
		ai_user vehicle::get_out();
	}
}

function _turret_new_user_think( n_index )
{
	const NEW_USER_THINK_TIME = 3;
	
	self endon( "death" );
	self endon( "_turret_think" + _index( n_index ) );
	self endon( "turret_disabled" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
	
	str_gunner_pos = "gunner" + n_index;
	
	while ( true )
	{
		wait NEW_USER_THINK_TIME;
		
		if ( does_have_target( n_index ) && !_user_check( n_index ) && ( isdefined( self.script_auto_use ) && self.script_auto_use ) )
		{
			str_team = get_team( n_index );
			a_users = GetAIArchetypeArray( "human" , str_team );
			a_ai_by_vehicle = ArraySortClosest( GetAIArray(), self.origin, 99999, 0, 300 );
				
			if ( a_users.size > 0 )
			{
				a_potential_users = [];
				if ( isdefined( self.script_auto_use_radius ) )
				{
					a_potential_users = ArraySort( a_users, self.origin, true, a_potential_users.size, self.script_auto_use_radius );
				}
				else
				{
					a_potential_users = ArraySort( a_users, self.origin, true );
				}
				
				ai_user = undefined;
				foreach ( ai in a_potential_users )
				{
					b_enemy_close = false;
					foreach ( ai_enemy in a_ai_by_vehicle )
					{
						if ( ai_enemy.team != ai.team )
						{
							b_enemy_close = true;
							break;
						}
					}
					
					if ( b_enemy_close )
					{
						continue;
					}
					
					if ( ai flagsys::get( "vehiclerider" ) )
					{
						continue;
					}
					
					if ( !ai vehicle::can_get_in( self, str_gunner_pos ) )
					{
						continue;
					}
					
					ai_user = ai;
					break;
				}
				
				if ( IsAlive( ai_user ) )
				{
					ai_user.turret_auto_use = true;
					ai_user vehicle::get_in( self, str_gunner_pos );
				}
			}
		}
	}
}

function does_have_target( n_index )
{
	return isdefined( _get_turret_data( n_index ).e_next_target );
}

function _user_check( n_index )
{
	s_turret = _get_turret_data( n_index );
	
	if ( does_need_user( n_index ) )
	{	
		b_has_user = does_have_user( n_index );
		return b_has_user;
	}
	else
	{
		return true;
	}
}

/#

function _debug_turret_think( n_index )
{
	self endon( "death" );
	self endon( "_turret_think" + _index( n_index ) );
	self endon( "turret_disabled" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
	v_color = ( 0, 0, 1 );
	
	while ( true )
	{
		if ( !GetDvarint( "g_debugTurrets") )
		{
			wait(0.2);
			continue;
		}

		has_target = isdefined( get_target( n_index ) );
		
		if ( ( does_need_user( n_index ) && !does_have_user( n_index ) )
			|| !has_target )
		{
			v_color = ( 1, 1, 0 );
		}
		else
		{
			v_color = ( 0, 1, 0 );
		}
		
		str_team = get_team( n_index );
		if ( !isdefined( str_team ) )
		{
			str_team = "no team";
		}
		
		str_target = "target > ";
		
		e_target = s_turret.e_next_target;		
		if ( isdefined( e_target ) )
		{
			if ( IsActor( e_target ) )
			{
				str_target += "ai";
			}
			else if ( IsPlayer( e_target ) )
			{
				str_target += "player";
			}
			else if ( IsVehicle( e_target ) )
			{
				str_target += "vehicle";
			}
			else if ( isdefined( e_target.targetname ) && ( e_target.targetname == "drone" ) )
			{
				str_target += "drone";
			}
			else if ( isdefined( e_target.classname ) )
			{
				str_target += e_target.classname;
			}
		}
		else
		{
			str_target += "none";
		}
		
		str_debug = self GetEntNum() + ":" + str_team + ":" + str_target;
		Record3DText( str_debug, self.origin, v_color, "Script", self );
		
		wait .05;
	}
}

#/

/*===================================================================================================
	SYSTEM FUNCTIONS
===================================================================================================*/

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	Get the data structure holding the turret info
RETURNS:	The turret data struct
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
function _get_turret_data( n_index )
{
	s_turret = undefined;
	
	if ( IsVehicle( self ) )
	{
		if ( isdefined( self.a_turrets ) && isdefined( self.a_turrets[ n_index ] ) )
		{
			s_turret = self.a_turrets[ n_index ];
		}
	}
	else
	{
		s_turret = self._turret;
	}
	
	if ( !isdefined( s_turret ) )
	{
		s_turret = _init_turret( n_index );
	}
	
	return s_turret;
}


/*===================================================================
SELF:		turret or vehicle
PURPOSE:	Get the data structure holding the turret info
RETURNS:	The turret data struct
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
function has_turret( n_index )
{
	if ( isdefined( self.a_turrets ) && isdefined( self.a_turrets[ n_index ] ) )
	{
		return true;
	}
	
	return false;
}

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	Initialize a turret for use in this system
RETURNS:	The turret data struct
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/

function _init_turret( n_index = 0 )
{
	self endon( "death" );
	
	w_weapon = get_weapon( n_index );
	
	if ( w_weapon == level.weaponNone )
	{
		AssertMsg( "Cannot initialize turret. No weapon info." );
		return;
	}
	
	util::waittill_asset_loaded( "xmodel", self.model );
	
	if ( IsVehicle( self ) )
	{
		s_turret = _init_vehicle_turret( n_index );
	}
	else
	{
		AssertMsg( "Misc turrets are no longer supported, please use a supported script_vehicle turret" );
	}
	
	s_turret.w_weapon = w_weapon;
	_update_turret_arcs( n_index );
	
	s_turret.is_enabled = false;
	s_turret.e_parent = self;
	s_turret.e_target = undefined;
	s_turret.b_ignore_line_of_sight = false;
	s_turret.v_offset = (0, 0, 0);
	s_turret.n_burst_fire_time = 0;
	s_turret.n_max_target_distance = undefined;

	// Defaults
	s_turret.str_weapon_type = "bullet";
	s_turret.str_guidance_type = "none";
	
	s_turret.str_weapon_type = w_weapon.type;
	s_turret.str_guidance_type = w_weapon.guidedMissileType;
	
	set_on_target_angle( undefined, n_index );
	
	s_turret.n_target_flags = 1 | 2;
	
	set_best_target_func_from_weapon_type( n_index );

	s_turret flag::init( "turret manual" );

	return s_turret;
}

function _update_turret_arcs( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.rightarc = s_turret.w_weapon.rightArc;
	s_turret.leftarc = s_turret.w_weapon.leftArc;
	s_turret.toparc = s_turret.w_weapon.topArc;
	s_turret.bottomarc = s_turret.w_weapon.bottomArc;
}

function set_best_target_func_from_weapon_type( n_index )
{
	switch ( _get_turret_data( n_index ).str_weapon_type )
	{
		case "bullet":
			set_best_target_func(&_get_best_target_bullet, n_index );
			break;
			
		case "gas":
			set_best_target_func(&_get_best_target_gas, n_index );
			break;
		
		case "grenade":
			set_best_target_func(&_get_best_target_grenade, n_index );
			break;
		
		case "projectile":
			set_best_target_func(&_get_best_target_projectile, n_index );
			break;
		
		default:
			AssertMsg( "unsupported turret weapon type." );
	}
}

/@
"Name: set_best_target_func( function, n_index )"
"Summary: Custom override function, scripter can use to custermise their choice from potential targets"

"MandatoryArg: <function> Override target selection function"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: set_best_target_func(&_get_best_target_bullet, n_index );"
@/

function set_best_target_func( func_get_best_target, n_index )
{
	_get_turret_data( n_index ).func_get_best_target = func_get_best_target;
}

/*===================================================================
SELF:		vehicle
PURPOSE:	Initialize a vehicle turret for use in this system
RETURNS:	The turret data struct
<n_index>:	index of vehicle turret
===================================================================*/
function _init_vehicle_turret( n_index )
{
	Assert( isdefined( n_index ) && ( n_index >= 0 ), "Invalid index specified to initialize vehicle turret." );
	
	s_turret = SpawnStruct();
	
	v_angles = self GetSeatFiringAngles( n_index );
	if ( isdefined( v_angles ) )
	{
		s_turret.n_rest_angle_pitch = AngleClamp180( v_angles[0] - self.angles[0] );
		s_turret.n_rest_angle_yaw = AngleClamp180( v_angles[1] - self.angles[1] );
	}
	
	switch ( n_index )
	{
		case 0:
			s_turret.str_tag_flash = "tag_flash";
			s_turret.str_tag_pivot = "tag_barrel";
			break;
			
		case 1:
			s_turret.str_tag_flash = "tag_gunner_flash1";
			s_turret.str_tag_pivot = "tag_gunner_barrel1";
			break;
		
		case 2:
			s_turret.str_tag_flash = "tag_gunner_flash2";
			s_turret.str_tag_pivot = "tag_gunner_barrel2";
			break;
	
		case 3:
			s_turret.str_tag_flash = "tag_gunner_flash3";
			s_turret.str_tag_pivot = "tag_gunner_barrel3";
			break;
		
		case 4:
			s_turret.str_tag_flash = "tag_gunner_flash4";
			s_turret.str_tag_pivot = "tag_gunner_barrel4";
			break;
	}
	
	if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
	{
		// helicopters are not likely to shoot themselves, but can also cause problems tracing
		// don't ignore ground vehicle like trucks because they are likely to shoot themselves
		s_turret.e_trace_ignore = self;
	}
	
	if ( !isdefined( self.a_turrets ) )
	{
		self.a_turrets = [];
	}
	
	self.a_turrets[n_index] = s_turret;
	
	if ( n_index > 0 )
	{
		// If vehicle has a gunner tag, assume it needs a user
		tag_origin = self GetTagOrigin( _get_gunner_tag_for_turret_index( n_index ) );
		if ( isdefined( tag_origin ) )
		{
			_set_turret_needs_user( n_index, true );
		}
	}
	
	return s_turret;
}

/*===================================================================
SELF:			turret or vehicle
PURPOSE:		fires a turret for one burst based on min and max burst
values
RETURNS:		the total time of the burst plus wait time
[n_max_time]:	the max time that the burst will take
[n_index]:		optional index of vehicle turret if self is a vehicle
===================================================================*/
function _burst_fire( n_max_time, n_index )
{
	self endon( "terminate_all_turrets_firing" );

	if ( n_max_time < 0 )
	{
		n_max_time = 9999;
	}
	
	s_turret = _get_turret_data( n_index );
	
	n_burst_time = _get_burst_fire_time( n_index );
	n_burst_wait = _get_burst_wait_time( n_index );
	
	if ( !isdefined( n_burst_time ) || ( n_burst_time > n_max_time ) )
	{
		n_burst_time = n_max_time;
	}
	
	if ( s_turret.n_burst_fire_time >= n_burst_time )
	{
		s_turret.n_burst_fire_time = 0;
		
		n_time_since_last_shot = ( GetTime() - s_turret.n_last_fire_time ) / 1000;
		if ( n_time_since_last_shot < n_burst_wait )
		{
			wait ( n_burst_wait - n_time_since_last_shot );
		}
	}
	else
	{
		n_burst_time = n_burst_time - s_turret.n_burst_fire_time;
	}
			
	w_weapon = get_weapon( n_index );
	n_fire_time = w_weapon.fireTime;
	n_total_time = 0;
	
	while ( n_total_time < n_burst_time )
	{
		turret::fire( n_index );
		
		n_total_time += n_fire_time; // keep track of time for this instance of burst fire
		s_turret.n_burst_fire_time += n_fire_time;	// keep track of totall burst time between multiple calls to burst fire
		
		wait n_fire_time;
	}
	
	if ( n_burst_wait > 0 )
	{
		wait n_burst_wait;
	}
	
	return n_burst_time + n_burst_wait;
}

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	get the random burst time for a turret based on min
and max values
RETURNS:	number between burst_min and burst_max, or 0
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
function _get_burst_fire_time( n_index)
{
	s_turret = _get_turret_data( n_index );
	n_time = undefined;
	
	if ( isdefined( s_turret.n_burst_fire_min ) && isdefined( s_turret.n_burst_fire_max ) )
	{
		if ( s_turret.n_burst_fire_min == s_turret.n_burst_fire_max )
		{
			n_time = s_turret.n_burst_fire_min;
		}
		else
		{
			n_time = RandomFloatRange( s_turret.n_burst_fire_min, s_turret.n_burst_fire_max );
		}
	}
	else if ( isdefined( s_turret.n_burst_fire_max ) )
	{
		n_time = RandomFloatRange( 0, s_turret.n_burst_fire_max );
	}
	
	return n_time;
}

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	get the random burst wait time for a turret struct based
on min and max values
RETURNS:	number between wait_min and wait_max, or 0 by default
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
function _get_burst_wait_time( n_index )
{
	s_turret = _get_turret_data( n_index );
	n_time = 0;
	
	if ( isdefined( s_turret.n_burst_wait_min ) && isdefined( s_turret.n_burst_wait_max ) )
	{
		if ( s_turret.n_burst_wait_min == s_turret.n_burst_wait_max )
		{
			n_time = s_turret.n_burst_wait_min;
		}
		else
		{
			n_time = RandomFloatRange( s_turret.n_burst_wait_min, s_turret.n_burst_wait_max );
		}
	}
	else if ( isdefined( s_turret.n_burst_wait_max ) )
	{
		n_time = RandomFloatRange( 0, s_turret.n_burst_wait_max );
	}
	
	return n_time;
}

/*===================================================================
PURPOSE:	convert a turret index to a string value. used for
unique endons, etc.
RETURNS:	string value of index if defined. empty string if not
defined.
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
function _index( n_index )
{
	return (isdefined(n_index)?""+n_index:"");
}

/*------------------------------------------------------------------------------------------------------
	Targeting Functions
------------------------------------------------------------------------------------------------------*/

// self = turret or vehicle
function _get_potential_targets( n_index )
{
	s_turret = self _get_turret_data( n_index );

	//************************************************************************************************
	// MikeA: For now if we have a target array the only targets we are interested is the target array
	//************************************************************************************************
	
	a_priority_targets = self _get_any_priority_targets( n_index );
	
	if ( isdefined( a_priority_targets ) && ( a_priority_targets.size > 0 ) )
	{
		//return arrayCopy( a_priority_targets );
		return( a_priority_targets );
	}	
	
	//****************************
	// Search for a regular target
	//****************************

	a_potential_targets = [];

	if ( isdefined( s_turret.e_target ) )
	{
		a_potential_targets[ a_potential_targets.size ] = s_turret.e_target;
	}

	str_team = get_team( n_index );
	if ( isdefined( str_team ) )
	{
		str_opposite_team = "allies";
		if ( str_team == "allies" )
		{
			str_opposite_team = "axis";
		}
		
		if ( _has_target_flags( 1, n_index ) )
		{
			a_ai_targets = GetAITeamArray( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_ai_targets, true, false );
		}
			
		if ( _has_target_flags( 2, n_index ) )
		{
			a_player_targets = GetPlayers( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_player_targets, true, false );
		}

		if ( _has_target_flags( 4, n_index ) )
		{
//			a_drone_targets = _drones::drones_get_array( str_opposite_team ); TODO: _drones has been removed
//			a_potential_targets = ArrayCombine( a_potential_targets, a_drone_targets, true, false );
		}
		
		if ( _has_target_flags( 8, n_index ) )
		{
			a_vehicle_targets = GetVehicleTeamArray( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_vehicle_targets, true, false );
		}
		
		//**************************************		
		// Remove targets that should be ignored
		//**************************************

		a_valid_targets = [];

		for ( i = 0; i < a_potential_targets.size; i++ )
		{
			e_target = a_potential_targets[i];
			ignore_target = false;
			
			assert( isdefined( e_target ), "Undefined potential turret target." );
		
			// Should we remove the target?	
			if ( ( isdefined( e_target.ignoreme ) && e_target.ignoreme ) || ( e_target.health <= 0 ) )
			{
				ignore_target = true;
			}
			
			// Removal checks for Sentients Only
			else if ( IsSentient( e_target ) && ( ( e_target IsNoTarget() ) || ( e_target ai::is_dead_sentient() ) ) )
			{
				ignore_target = true;
			}

			// Remove target if we have a target limit distance set
			else if ( _is_target_within_range( e_target, s_turret ) == 0 )
			{
				ignore_target = true;
			}

			if ( !ignore_target )
			{
				a_valid_targets[ a_valid_targets.size ] = e_target;
			}
		}

		// Save the new valid targets
		a_potential_targets = a_valid_targets;
	}

	a_targets = a_potential_targets;

	if ( isdefined( s_turret ) && isdefined( s_turret.a_ignore_target_array ) )
	{
		while ( true )
		{
			found_bad_target = 0;
			a_targets = a_potential_targets;
	
			for ( i = 0; i < a_targets.size; i++ )
			{
				e_target = a_targets[i];
				found_bad_target = 0;

				for ( j = 0; j < s_turret.a_ignore_target_array.size; j++ )
				{
					if ( e_target == s_turret.a_ignore_target_array[ j ] )
					{
						ArrayRemoveValue( a_potential_targets, e_target );
						found_bad_target = 1;
						break;
					}
				}
			}
			
			if ( !found_bad_target )
			{
				break;
			}
		}
	}
	
	return a_potential_targets;
}

// self = Vehicle/MG
function _is_target_within_range( e_target, s_turret )
{
	if ( isdefined( s_turret.n_max_target_distance ) && ( s_turret.n_max_target_distance > 0 ) )
	{
		n_dist = Distance( e_target.origin, self.origin );
		if ( n_dist > s_turret.n_max_target_distance )
		{
			return false;
		}
	}
	return true;
}

function _get_any_priority_targets( n_index )
{
	a_targets = undefined;

	s_turret = _get_turret_data( n_index );

	// Do we have a set of priority targets?
	if ( isdefined( s_turret.priority_target_array ) )
	{
		while ( true )
		{
			found_bad_target = 0;
			a_targets = s_turret.priority_target_array;

			// Make sure all the priority tagets are still alive
			for ( i = 0; i < a_targets.size; i++ )
			{
				e_target = a_targets[ i ];
				bad_index = undefined;
				
				// Should we remove the target?
				if ( !isdefined( e_target ) )
				{
					bad_index = i;
				}
				else if ( !IsAlive( e_target ) )
				{
					bad_index = i;
				}
				else if ( e_target.health <= 0 )
				{
					bad_index = i;
				}
				else if ( IsSentient( e_target ) && ( e_target ai::is_dead_sentient() ) )
				{
					bad_index = i;
				}
				
				if ( isdefined( bad_index ) )
				{
					s_turret.priority_target_array = a_targets;
					ArrayRemoveValue( s_turret.priority_target_array, e_target );
					found_bad_target = 1;
					break;
				}
			}
	
			// Did we removee any bad targets?
			if ( !found_bad_target )
			{
				return ( s_turret.priority_target_array );
				break;
			}		
			else
			{
				if ( s_turret.priority_target_array.size <= 0 )
				{
					s_turret.priority_target_array = undefined;
					self notify( "target_array_destroyed" );
					break;
				}
			}	
		}
	}
	
	return( a_targets );
}

function _get_best_target_from_potential( a_potential_targets, n_index )
{
	s_turret = _get_turret_data( n_index );
	return [[ s_turret.func_get_best_target ]]( a_potential_targets, n_index );
}

function _get_best_target_bullet( a_potential_targets, n_index )
{
	e_best_target = undefined;
	
	while ( !isdefined( e_best_target ) && ( a_potential_targets.size > 0 ) )
	{
		e_closest_target = array::get_closest( self.origin, a_potential_targets );

		if( self can_hit_target( e_closest_target, n_index ) )
		{
			e_best_target = e_closest_target;
		}
		else
		{
			ArrayRemoveValue( a_potential_targets, e_closest_target );
		}
	}
	
	return e_best_target;
}

function _get_best_target_gas( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

function _get_best_target_grenade( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

function _get_best_target_projectile( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

/@
"Name: can_hit_target( e_target, n_index )"
"Summary: Check bothif the target is within the turrets constaraints and theres is nothing blocking a LOS"

"MandatoryArg: <e_target> Target the Turret wants to fire at"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret can_hit_target( e_guy, 1 );"
@/
// self = vehicle or turret
function can_hit_target( e_target, n_index )
{
	s_turret = _get_turret_data( n_index );
	v_offset = _get_default_target_offset( e_target, n_index );
	
	b_current_target = is_target( e_target, n_index );
	
	b_target_in_view = is_target_in_view( e_target.origin + v_offset, n_index );
	b_trace_passed = true;
	
	if ( b_target_in_view )
	{
		if ( !s_turret.b_ignore_line_of_sight )
		{
			b_trace_passed = trace_test( e_target, v_offset, n_index );
		}
		
		if ( b_current_target && !b_trace_passed && !isdefined( s_turret.n_time_lose_sight ) )
		{
			s_turret.n_time_lose_sight = GetTime();
		}
	}
	else if ( b_current_target )
	{	
		s_turret.b_target_out_of_range = true;
	}
	
	return ( b_target_in_view && b_trace_passed );
}

/@
"Name: is_target_in_view( v_target, n_index )"
"Summary: Gets whether a turret's target is in view"

"MandatoryArg: <e_target> Target the Turret wants to fire at"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret is_target_in_view( v_position, 1 );"
@/
//self = turret/vehicle
function is_target_in_view( v_target, n_index )
{
	/#
		_update_turret_arcs( n_index );
	#/
		
	s_turret = _get_turret_data( n_index );
	
	v_pivot_pos = self GetTagOrigin( s_turret.str_tag_pivot );
	v_angles_to_target = VectorToAngles( v_target - v_pivot_pos );
	
	n_rest_angle_pitch = s_turret.n_rest_angle_pitch + self.angles[0];
	n_rest_angle_yaw = s_turret.n_rest_angle_yaw + self.angles[1];
	
	n_ang_pitch = AngleClamp180( v_angles_to_target[0] - n_rest_angle_pitch );
	n_ang_yaw = AngleClamp180( v_angles_to_target[1] - n_rest_angle_yaw );
	
	b_out_of_range = false;

	if ( n_ang_pitch > 0 )
	{
		if ( n_ang_pitch > s_turret.bottomarc )
		{
			b_out_of_range =  true;
		}
	}
	else
	{
		if ( Abs( n_ang_pitch ) > s_turret.toparc )
		{
			b_out_of_range =  true;
		}
	}
	
	if ( n_ang_yaw > 0 )
	{
		if ( n_ang_yaw > s_turret.leftarc )
		{
			b_out_of_range =  true;
		}
	}
	else
	{
		if ( Abs( n_ang_yaw ) > s_turret.rightarc )
		{
			b_out_of_range =  true;
		}
	}

	return !b_out_of_range;
}

/@
"Name: can_turret_shoot_target( e_target, n_index )"
"Summary: Basically is there anythinhg blocking the turrets shot (geo etc..)"

"MandatoryArg: <e_target> Target the Turret wats to fire at"
"OptionalArg: [v_offset] Optional offset"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: vh_heli can_turret_shoot_target( e_guy, 1 );"
@/


//self = turret/vehicle
function trace_test( e_target, v_offset = (0,0,0), n_index )
{
	//********************************************************************************
	// Old style tracing, reviving to restore functionality in pak3 at this late stage
	//********************************************************************************

	if ( isdefined( self.good_old_style_turret_tracing ) )
	{
		s_turret = _get_turret_data( n_index );
	
		v_start_org = self GetTagOrigin( s_turret.str_tag_pivot );
		if ( e_target SightConeTrace( v_start_org, self ) > .2 )
		{
			// If we can see the target, make sure we can bullet trace over half way to hit the target
			v_target = e_target.origin + v_offset;
			v_start_org += VectorNormalize( v_target - v_start_org ) * 50;
			a_trace = BulletTrace( v_start_org, v_target, true, s_turret.e_trace_ignore, true, true );
			if ( a_trace["fraction"] > .6 )
			{
				return true;
			}
		}
	
		return false;
	}


	//*************************************************************************************************
	// MikeA: I think there is a bug where when we have two people in a vehicle
	// If the driver is in the LOS of the gunner and the target, the trace will hit the driver and fail
	//*************************************************************************************************

	s_turret = _get_turret_data( n_index );
	
	v_start_org = self GetTagOrigin( s_turret.str_tag_pivot );
	v_target = e_target.origin + v_offset;
	
	if ( DistanceSquared( v_start_org, v_target ) < 100*100 )
		return true;
	
	v_dir_to_target = VectorNormalize( v_target - v_start_org );
	
	v_start_org += v_dir_to_target * 50;
	v_target -= v_dir_to_target * 75;	// don't have to see all the way there
	
	if ( SightTracePassed( v_start_org, v_target, false, self ) )
	{
		v_start_org = self GetTagOrigin( s_turret.str_tag_flash );
		v_start_org += v_dir_to_target * 50;
		
		// If we can see the target, make sure we can bullet trace over half way to hit the target
		a_trace = BulletTrace( v_start_org, v_target, true, s_turret.e_trace_ignore, true, true );
		if ( a_trace["fraction"] > .6 )
		{
			return true;
		}
	}
	
	return false;
}

/@
"Name: set_ignore_line_of_sight( b_ignore, n_index )"
"Summary: Set whether a turret will ignore line of sight or not"

"MandatoryArg: <b_ignore> bool to ignore line of sight or not"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret set_ignore_line_of_sight( true, 0 );"
@/

function set_ignore_line_of_sight( b_ignore, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.b_ignore_line_of_sight = b_ignore;
}

/@
"Name: set_occupy_no_target_time( time, n_index )"
"Summary: How long an AI will stay inside a turret if there is no target, default = 2.0"

"MandatoryArg: <time> time to occupy turret without a target"
"OptionalArg: [n_index] Index of the turret for a vehicle turret"

"Example: e_turret turret::set_occupy_no_target_time( 4 );"
@/

function set_occupy_no_target_time( time, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.occupy_no_target_time = time;
}

//self = turret
function toggle_lensflare( bool )
{
	self clientfield::set( "toggle_lensflare", bool );	
}

function track_lens_flare()
{
	self endon( "death" );
	
	while ( true )
	{
		e_target = self GetTargetEntity();
		if ( self.turretontarget && ( isdefined( e_target ) &&  IsPlayer( e_target ) ) )
		{
			if ( IsDefined( self GetTagOrigin( "TAG_LASER" ) ) )
			{
				e_target util::waittill_player_looking_at( self GetTagOrigin( "TAG_LASER" ), 90 );
				self turret::toggle_lensflare( true );
				e_target util::waittill_player_not_looking_at( self GetTagOrigin( "TAG_LASER" ) );
				self turret::toggle_lensflare( false );
			}
			else
			{
/#				iPrintLn( "TAG_LASER not found on " + self.targetname );	#/
			}
		}
		
		wait 0.5;//We don't need to check too often, helps keep resources down if we have a lot of turrets
	}	
}

//*****************************************************************************
// If the AI or Drone is manning a Turret, init the vehicles turret
// self  = AI User or Drone User
//*****************************************************************************

function _get_gunner_tag_for_turret_index( n_index )
{
	switch ( n_index )
	{
	case 1:	return "tag_gunner1";
	case 2:	return "tag_gunner2";
	case 3:	return "tag_gunner3";
	case 4:	return "tag_gunner4";
	default: AssertMsg( "unsupported turret index for getting gunner tag." );
	}
}

function _get_turret_index_for_tag( str_tag )
{
	switch ( str_tag )
	{
	case "tag_gunner1":	return 1;
	case "tag_gunner2":	return 2;
	case "tag_gunner3":	return 3;
	case "tag_gunner4":	return 4;
	}
}

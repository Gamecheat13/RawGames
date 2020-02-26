#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree( "turret" );

/*-----------------------------------------------------------------------------------------------------

****************************************************************** 
Turret Overview
******************************************************************

	This script handles all turret functionality.
	
	BOTH misc_turrets and vehicle turrets use the same high level script commands to control them.
	
	Below are a list of script command available.
	
	See the module:-	t6\game\share\devraw\maps\module_turret.gsc for a group simple examples that shows the 
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

	enable_turret( n_index )
		- Enables the given turret.
		
	disable_turret( [n_index] )
		- Disables the given turret, but it keeps its targetted information.

	use_turret( <e_turret>, <b_stay_on>, [n_index] )
		- Tells this actor path towards this turret and use it.

	use_turret_teleport( <e_turret>, <b_stay_on>, [n_index] )
		- Teleports an actor to a given turret and uses it.

	pause_turret( [n_index], <time, 0=infinite> )
		- Pause turret for X time.
		
	unpause_turret( [n_index] )
		- remove the pause restriction from the turret.

	stop_turret( <n_index> )
		- Stops the turrets current action and puts it back in search for enemy mode.


******************************************************************
Creating a Turret During the level.

	Turrets can be created at anytime during the level callinf the followinf function:-
	create_turret( <position>, <angles>, <team>, <weaponinfo>, <model>, [offset] );
******************************************************************



******************************************************************
Turret "User" Functios - Turrets that need Users to Operate
******************************************************************

	does_turret_need_user( <n_index> )
		- Does the turret need a used (node) to oprerate.

	does_turret_have_user( <n_index> )
		- Does the turret currently have a user?

	get_turret_user( <index> )
		- Gets the user of this turret.

	is_current_user( <ai_user>, [n_index] )
		-  Checks to see if an AI is the current user.

	stop_use_turret()
		- Tells actor to stop using the turret.

	SetOnTargetAngle( <angle> )
		- The turret has to be aiming within this number of degrees at the target to get the 
		  "turret_on_target" notify.


******************************************************************
Turret Targetting Functions
******************************************************************
		
	set_turret_target( <e_target>, [v_offset], [n_index] )
		- Sets the target of this turret.

	get_turret_target( [n_index] )
		- Returns turret target data for this turret.
		
	clear_turret_target( [n_index] )
		- Clears turret target data for this turret.

	set_turret_target_flags( <n_flags>, [n_index] )
		 - Sets a sub-set of targets for the turret.

	set_turret_target_ent_array( [a_ents] )
		- Passes an array of targets to the turret to kill.
		
	clear_turret_target_ent_array()
		- Scripters ability to clear the turrets ent target array.

	set_turret_ignore_ent_array( [a_ents] )
		- Passes an array of ents to the turret to ignore.

	clear_turret_ignore_ent_array()
		- Scripters ability to clear the turrets ent ignore array.

	set_turret_best_target_func( <::function>, [n_index] )
		 - Custom override function, scripter can use to custermise their choice from potential targets;

	is_target_in_turret_view( e_target, n_index )
		 - Lets script know if the turret can aim for a target within its GDT movement constraints.

	can_turret_shoot_target( e_target, n_index ) 
		- Basically is there anythinhg blocking the turrets shot (geo etc..)

	can_turret_hit_target( e_target, turret_index )
		- Basically combines the two functions above ( is_target_in_turret_view() and can_turret_shoot_target() )



******************************************************************
Turret Firing Functions
******************************************************************

	fire_turret( [n_index] )
	 - Fires a turret.
			 
	fire_turret_for_time( <n_time> , [n_index] )
		- Fires a turret for a time, blocks for n_time.
		
	shoot_turret_at_target( <ent>, <time> );
		- Gets a turret to go into manual mode and fire at a specific target, ignoring all other threats.

	set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index )
	 - Sets the burst parameters for a turret.


******************************************************************
Useful Misc Turret Functions
******************************************************************

	set_turret_occupy_no_target_time( n_index )
		- How long an AI will stay inside a turret if there is no target, default is 2.0 seconds.
		
	set_turret_ignore_line_of_sight( b_ignore, n_index )
		- set this turret to ignore line of sight

	get_turret_weapon_name( n_index )
		 - Gets the turrets weapon name.
	
	get_turret_parent( n_index )
		 - Gets the turrets parent entity.
		 
	enable_turret_laser( n_index, b_enable )
		 - Turns on the laser.
		 
	enable_turret_emp( n_index, b_enable )
		 - Allows this turret to be emped which shuts it down and turns of the laser if enabled.
	 
		 
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
	str_weapon
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
#define MAX_OCCUPY_NO_TARGET_TIME 3600

/@
"Name: init_turrets()"
"Summary: Called from animscripts first load to initialized turret cover nodes"
"Module: Turret"
"Example: init_turret_nodes();"
"SPMP: singleplayer"
@/
autoexec _init_turrets()
{
	level._turrets = SpawnStruct();
	
	a_turrets = GetEntArray( "misc_turret", "classname" );
	foreach ( e_turret in a_turrets )
	{
		e_turret thread _auto_init_misc_turret();
	}
}

_auto_init_misc_turret()
{
	waittill_asset_loaded( "xmodel", self.model );
	
	if ( IsDefined( self.targetname ) )
	{
		nd_turret = GetNode( self.targetname, "target" );
		if ( IsDefined( nd_turret ) )
		{
			nd_turret.turret = self;
			self.node = nd_turret;
			
			self thread _turret_node_think();
		}
		
		if ( self has_spawnflag( SPAWNFLAG_TURRET_ENABLED ) )
		{
			self enable_turret();
		}
	}
}

/@
"Name: get_turret_weapon_name( [n_index] )"
"Summary: Gets a turret's weapon"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: turret get_turret_weapon_name_name();"
"SPMP: singleplayer"
@/
get_turret_weapon_name( n_index )
{
	if ( IS_VEHICLE( self ) )
	{
		str_weapon = self SeatGetWeapon( n_index );
	}
	else
	{
		str_weapon = self.weaponinfo;
	}
	
	return str_weapon;
}

/@
"Name: get_turret_parent( [n_index] )"
"Summary: Gets a turret's parent"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: turret get_turret_parent( n_index );"
"SPMP: singleplayer"
@/
get_turret_parent( n_index )
{
	return _get_turret_data( n_index ).e_parent;
}

laser_death_watcher()
{
	self notify( "laser_death_thread_stop" );
	self endon( "laser_death_thread_stop" );
	self waittill( "death" );
	self LaserOff();
}

enable_turret_laser( b_enable, n_index )
{	
	if( b_enable )
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

emp_watcher( n_index )
{
	self notify( "emp_thread_stop" );
	self endon( "emp_thread_stop" );
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );

//they don't like the bouncy emp grenade
//		if( IsDefined(weaponName) && weaponName == "emp_grenade_stage2_sp" )
		if( IsDefined(weaponName) && weaponName == "emp_grenade_sp" )
		{
			if( IsDefined( self.emped ) )
			{
				continue;
			}
			
			self.emped = true;
			
			if( IsDefined( _get_turret_data( n_index ).has_laser ) )
			{
				self LaserOff();
			}
			
			clear_turret_target( n_index );
			
			self notify( "_stop_turret" + _index( n_index ) );
			
			wait RandomFloatRange( 5, 7 );
			
			self.emped = undefined;
			
			if( IsDefined( _get_turret_data( n_index ).has_laser ) )
			{
				self LaserOn();
			}
		}
	}
}

enable_turret_emp( b_enable, n_index )
{
	if( b_enable )
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

set_turret_team( str_team, n_index )
{
	_get_turret_data( n_index ).str_team = str_team;

	// set the internal code team
	self SetTurretTeam( str_team );
}

get_turret_team( n_index )
{
	str_team = undefined;
	
	s_turret = _get_turret_data( n_index );
	
	if ( IS_VEHICLE( self ) )
	{
	//	str_team = self GetTeam();
		str_team = self.vteam;
		
		if ( !IsDefined( s_turret.str_team ) )
		{
			s_turret.str_team = str_team;
		}
	}
	else
	{
		//ai_user = self GetTurretOwner();
		ai_user = get_turret_user( n_index );
		if ( IsDefined( ai_user ) )
		{
			str_team = ai_user GetTeam();
			
			if ( !IsDefined( s_turret.str_team ) )
			{
				s_turret.str_team = str_team;
			}
		}
		else
		{
			str_team = s_turret.str_team;
		}
	}
	
	return str_team;
}
 
/@
"Name: is_turret_enabled( [n_index] )"
"Summary: Checks to see if a turret is enabled"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: if ( is_turret_enabled( n_index ) );"
"SPMP: singleplayer"
@/
is_turret_enabled( n_index )
{
	return _get_turret_data( n_index ).is_enabled;
}

/@
"Name: does_turret_need_user( [n_index] )"
"Summary: Checks to see if a turret needs a user"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: if ( does_turret_need_user( n_index ) );"
"SPMP: singleplayer"
@/
does_turret_need_user( n_index )
{
	if ( IS_VEHICLE( self ) )
	{
		return IS_TRUE( _get_turret_data( n_index ).b_needs_user );
	}
	else
	{
		return IsDefined( self.node );
	}
}

/@
"Name: does_turret_have_user( [n_index] )"
"Summary: Checks to see if a turret has a user"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: if ( turret does_turret_have_user( n_index ) );"
"SPMP: singleplayer"
@/
does_turret_have_user( n_index )
{
	return IsDefined( get_turret_user( n_index ) );
}

/@
"Name: get_turret_user( [n_index] )"
"Summary: Gets the user of this turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: ai_user = get_turret_user( n_index );"
"SPMP: singleplayer"
@/

get_turret_user( n_index )
{
	ai_current_user = undefined;

	// VEHICLE Turret
	if ( IS_VEHICLE( self ) )
	{
		// MikeA: 5/12/11
		s_turret = _get_turret_data( n_index );
		if( IsDefined(s_turret) )
		{
			if( IsDefined(s_turret.ai_user) )
			{
				if ( IsAlive( s_turret.ai_user ) )
				{
					ai_current_user = _get_turret_data( n_index ).ai_user;
				}
			}
		}
	}
	
	// MG Turret
	else
	{
		if ( does_turret_need_user() )
		{
			e_user = self GetTurretOwner();
			if ( IsPlayer(e_user) )
			{
				ai_current_user = e_user;
			}
			else
			{
				e_user = _get_turret_data(n_index).ai_user;
				if ( IsAlive(e_user) )
				{
					ai_current_user = e_user;
				}
			}
		}
	}	

	return( ai_current_user );
}

_set_turret_user( ai_user, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.ai_user = ai_user;
	
	if ( IS_VEHICLE( self ) )
	{
		s_turret notify( "turretownerchange" );
	}
}

/@
"Name: set_turret_target_ent_array( [a_entities], <n_index> )"
"Summary: Sends a list of targets for the turret.  NOTE - Sends notify when targets are all dead"
"Module: Turret"
"MandatoryArg: <a_targets>: The Array of Targets you want the turret to destroy"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: set_turret_target_ent_array( a_ents );"
"SPMP: singleplayer"
@/

// self = turret or vehicle
set_turret_target_ent_array( a_ents, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.priority_target_array = a_ents;
}

/@
"Name: add_turret_priority_target( <ent_or_ent_array>, [n_index] )"
"Summary: Adds a single ent or array of ents to be a priority target of a turret"
"Module: Turret"
"MandatoryArg: <ent_or_ent_array>: The ent or array of entity targets the turret should attack"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: claw_turret add_turret_priority_target( a_balcony_guys )"
"SPMP: singleplayer"
@/
add_turret_priority_target( ent_or_ent_array, n_index )
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
	if ( IsDefined( s_turret.priority_target_array ) )
	{
		a_new_targets = ArrayCombine( s_turret.priority_target_array, a_new_targets, true, false );
	}
	
	s_turret.priority_target_array = a_new_targets;	
}

/@
"Name: clear_turret_target_ent_array()"
"Summary: Clears the turrets target array"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: clear_turret_target_ent_array();"
"SPMP: singleplayer"
@/

clear_turret_target_ent_array( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.priority_target_array = undefined;
}

/@
"Name: set_turret_ignore_ent_array( [a_entities], <n_index> )"
"Summary: Sends a list of targets for the turret to ignore."
"Module: Turret"
"MandatoryArg: [a_targets]: The Array of Targets you want the turret to IGNORE"
"OptionalArg: <n_index>: Index of the turret for a vehicle turret"
"Example: set_turret_ignore_ent_array( a_ents );"
"SPMP: singleplayer"
@/

// self = turret or vehicle
set_turret_ignore_ent_array( a_ents, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.a_ignore_target_array = a_ents;
}

/@
"Name: clear_turret_ignore_ent_array()"
"Summary: Clears the turrets target array"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: clear_turret_ignore_ent_array();"
"SPMP: singleplayer"
@/

clear_turret_ignore_ent_array( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.a_ignore_target_array = undefined;
}

/@
"Name: use_turret( <e_turret>, <b_stay_on>, [n_index] )"
"Summary: Tells this actor to use the given turret"
"Module: Turret"
"MandatoryArg: <e_turret>: The turret you want the actor to use"
"OptionalArg: [b_stay_on]: Option to keep user to stay and remain on turret. Defaults to false."
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: ai_user use_turret( e_courtyard_turret, true, n_index );"
"SPMP: singleplayer"
@/
use_turret( e_turret, b_stay_on, n_index )
{
	assert( IsAlive( self ), "Dead user passed into use_turret." );
	e_turret _use_turret( self, b_stay_on, n_index, false );
}

/@
"Name: use_turret_teleport( <e_turret>, <b_stay_on>, [n_index] )"
"Summary: Teleports an actor to the given turret and uses it"
"Module: Turret"
"MandatoryArg: <e_turret>: The turret you want the actor to use"
"OptionalArg: [b_stay_on]: Option to keep user to stay and remain on turret. Defaults to false."
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: ai_user use_turret_teleport( e_courtyard_turret, true, n_index );"
"SPMP: singleplayer"
@/
use_turret_teleport( e_turret, b_stay_on, n_index )
{
	assert( IsAlive( self ), "Dead user passed into use_turret_teleport." );
	e_turret _use_turret( self, b_stay_on, n_index, true );
}

// self: turret or vehicle
_use_turret( ai_user, b_stay_on, n_index, b_teleport )
{
	ai_user endon( "death" );
	ai_user endon( "stop_use_turret" );

	self endon( "turret_disabled" + _index( n_index ) );
	
	if ( IS_VEHICLE( self ) )
	{
		return false;
	}
	else
	{
		assert( IsDefined( self.node ), "Turret does not have node at " + self.origin );
		
		ai_user._turret_stay_on = is_true( b_stay_on );
		self SetTurretIgnoreGoals( ai_user._turret_stay_on );
		
		ai_current_user = self GetTurretOwner();
		if ( !IsDefined( ai_current_user ) || ( ai_current_user != ai_user ) )
		{		
			const USE_RADIUS = 16;
			
			if ( !is_turret_current_user( ai_user, n_index ) )
			{
				_wait_for_current_user_to_finish( n_index );
			}
			
			if ( is_true( b_stay_on ) )
			{
				SetEnableNode( self.node, true );
			}
			
			_set_turret_user( ai_user, n_index );
			
			if ( !is_turret_enabled( n_index ) )
			{
				// enabling only for this user, disable when done
				self thread _disable_turret_when_user_is_done( ai_user );
			}
			
			enable_turret( n_index );
			
			if ( b_teleport )
			{
				ai_user ForceTeleport( self.node.origin, self.node.angles );
			}
			else
			{
				ai_user force_goal( self.node, USE_RADIUS );
			}
			
			// Give the turret the users team - MikeA 5/4/11
			set_turret_team( ai_user GetTeam(), n_index );
			
			self SetMode( "manual_ai" );
			
			ai_user.a.disableLongDeath = true;

			// Send out a notify that the AI has reached the turret			
			self notify( "user_using_turret" + _index( n_index ) );

			// Only actually use the turret if the turret has something to shoot at
			// or we're told to stay on the turret
			if ( ai_user._turret_stay_on || does_turret_have_target() )
			{
				ai_user UseTurret( self );
				self waittill( "turretownerchange" );
			}
		}
	}
}

_disable_turret_when_user_is_done( ai_user, n_index )
{
	self endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	ai_user waittill_any( "death", "stop_use_turret" );
	disable_turret( n_index );
}

_wait_for_current_user_to_finish( n_index )
{
	self endon( "death" );
	
	while ( IsAlive( get_turret_user( n_index ) ) )
	{
		wait .05;
	}
}

is_turret_current_user( e_user, n_index )
{
	e_current_user = get_turret_user( n_index );
	if ( IsAlive( e_current_user ) && ( e_current_user == e_user ) )
	{
		return true;
	}
	
	return false;
}

/@
"Name: is_current_user( <ai_user>, [n_index] )"
"Summary: Checks to see if an AI is the current user"
"Module: Turret"
"MandatoryArg: <ai_user>: The user of this turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: if ( is_current_user( ai_user, n_index ) );"
"SPMP: singleplayer"
@/
is_current_user( ai_user, n_index )
{
	ai_current_user = get_turret_user( n_index );
	return ( IsAlive( ai_current_user ) && ( ai_user == ai_current_user ) );
}

_animscripts_init( ai_user )
{
	// This should only be called from the turret animscripts

	self Show(); // for hidden/portable turrets
	_init_animations( ai_user );
	
	enable_turret();
}	

/@
"Name: stop_use_turret()"
"Summary: Tells actor to stop using the turret"
"Module: Turret"
"Example: stop_use_turret();"
"SPMP: singleplayer"
@/
stop_use_turret()
{
	if ( IS_VEHICLE( self ) )
	{
	}
	else
	{
		e_turret = self GetTurret();
		
		if ( IsDefined( e_turret ) )
		{
			if ( IsPlayer( self ) )
			{
				self StopUsingTurret();
			}
			else if ( IsAlive( self ) )
			{
				self StopUseTurret();
			}
			
			e_turret _set_turret_user( undefined );
		}
		self._turret_stay_on = undefined;
	}
	
	self notify( "stop_use_turret" );
}

/@
"Name: set_burst_parameters( <n_fire_min>, <n_fire_max>, <n_wait_min>, <n_wait_max>, [n_index] )"
"Summary: Sets the burst parameters for a turret"
"Module: Turret"
"MandatoryArg: <n_fire_min>: The minimum time to fire the turret for"
"MandatoryArg: <n_fire_max>: The maximum time to fire the turret for"
"MandatoryArg: <n_wait_min>: The minimum time to wait between firing"
"MandatoryArg: <n_wait_max>: The maximum time to wait between firing"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: turret set_burst_parameters( 1, 2, 3, 4 ); // slow burst firing"
"SPMP: singleplayer"
@/
set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.n_burst_fire_min = n_fire_min;
	s_turret.n_burst_fire_max = n_fire_max;
	s_turret.n_burst_wait_min = n_wait_min;
	s_turret.n_burst_wait_max = n_wait_max;
}

/@
"Name: set_turret_on_target_angle( <n_angle>, [n_index] )"
"Summary: Sets the angle at which the turret will be on target"
"Module: Turret"
"MandatoryArg: <n_angle>: angle at which the turret will be on target"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: turret set_turret_on_target_angle( 1, 5 ); // on target at 5 degrees from target position"
"SPMP: singleplayer"
@/
set_turret_on_target_angle( n_angle, n_index )
{
	s_turret = _get_turret_data( n_index );
	
	if ( !IsDefined( n_angle ) )
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
"Name: set_turret_target( <e_target>, [v_offset], [n_index] )"
"Summary: Sets the target of this turret"
"Module: Turret"
"MandatoryArg: <e_target>: The target of this turret"
"OptionalArg: [v_offset]: Offset from the turret target"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret set_turret_target( e_target, v_offset, n_index );"
"SPMP: singleplayer"
@/
set_turret_target( e_target, v_offset, n_index )
{
	s_turret = _get_turret_data( n_index );

	if ( !IsDefined( v_offset ) )
	{
		v_offset = _get_default_target_offset( e_target, n_index );	
	}
	
	// Set turret to manual mode
	if ( !IS_VEHICLE( self ) )
	{	
		// MikeA: 5/16/11 - If AI using the turret manual_ai mode is needed so the turret goes back to a rest position.
		if ( IsDefined( s_turret.ai_user ) )
		{
			self SetMode( "manual_ai" );
		}
		else
		{
			self SetMode( "manual" );
		}
	}
	
	if ( !IsDefined( n_index ) || n_index == 0 )
	{
		self SetTargetEntity( e_target, v_offset );
	}
	else
	{
		self SetTargetEntity( e_target, v_offset, n_index - 1 );
	}
	
	s_turret.e_target = e_target;
	s_turret.v_offset = v_offset;
}

_get_default_target_offset( e_target, n_index )
{
	s_turret = _get_turret_data( n_index );
	if ( s_turret.str_weapon_type == "bullet" )
	{
		if ( IsDefined( e_target ) )
		{
			if ( IsPlayer( e_target ) )
			{
				z_offset = RandomIntRange( 40, 50 );
			}
			else if ( IS_EQUAL( e_target.type, "human" ) )
			{
				z_offset = RandomIntRange( 20, 60 );
			}
		}
	}
	
	DEFAULT( z_offset, 0 );		
	v_offset = ( 0, 0, z_offset );
	
	return v_offset;
}

/@
"Name: get_turret_target( [n_index] )"
"Summary: Returns turret target data for this turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: has_target = IsDefined( get_turret_target( n_index ) );"
"SPMP: singleplayer"
@/
get_turret_target( n_index )
{
	return _get_turret_data( n_index ).e_target;
}

is_turret_target( e_target, n_index )
{
	e_current_target = get_turret_target( n_index );
	
	if ( IsDefined( e_current_target ) )
	{
		return ( e_current_target == e_target );
	}
	
	return false;
	
}

/@
"Name: clear_turret_target( [n_index] )"
"Summary: Clears turret target data for this turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret clear_turret_target( n_index );"
"SPMP: singleplayer"
@/
clear_turret_target( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret ent_flag_clear( "turret manual" );
	
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
		
	if ( IS_VEHICLE( self ) )
	{
		if( !IsDefined(n_index) || ( n_index == 0 ) )
		{
			self ClearTurretTarget();
		}
		else
		{
			self ClearGunnerTarget( n_index - 1 );
		}
	}
	else
	{
		self ClearTargetEntity();
	}
}

/@
"Name: set_turret_target_flags( <n_flags>, [n_index] )"
"Summary: Sets the flags for the types of targets the turret should pick"
"Module: Turret"
"MandatoryArg: <n_flags>: The types of targets - currently supports TURRET_TARGET_AI, TURRET_TARGET_PLAYERS, TURRET_TARGET_DRONES, TURRET_TARGET_VEHICLES"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_bunker_turret set_turret_target_flags( TURRET_TARGET_AI | TURRET_TARGET_PLAYERS, n_index );"
"SPMP: singleplayer"
@/
set_turret_target_flags( n_flags, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.n_target_flags = n_flags;
}

_has_target_flags( n_flags, n_index )
{
	n_current_flags = _get_turret_data( n_index ).n_target_flags;
	return (( n_current_flags & n_flags) == n_flags);
}

/@
"Name: fire_turret( [n_index] )"
"Summary: Fires a turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret fire_turret();"
"SPMP: singleplayer"
@/
fire_turret( n_index )
{
	s_turret = _get_turret_data( n_index );
	
	if ( IS_VEHICLE( self ) )
	{
		assert( IsDefined( n_index ) && ( n_index >= 0 ), "Invalid index specified to fire vehicle turret." );
		
		if ( n_index == 0 )
		{
			if ( IsDefined( s_turret.e_target ) )
			{
				self FireWeapon( s_turret.e_target );
			}
			else
			{
				self FireWeapon();
			}
		}
		else
		{
			if ( IsDefined( s_turret.e_target ) )
			{
				self SetGunnerTargetEnt( s_turret.e_target, s_turret.v_offset, n_index - 1 );
			}
			
			self FireGunnerWeapon( n_index - 1 );
		}
	}
	else
	{
		self ShootTurret();
	}
	
	s_turret.n_last_fire_time = GetTime();
}

/@
"Name: stop_turret( [n_index], [b_clear_target] )"
"Summary: Stops a turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"OptionalArg: [b_clear_target]: Clears the turret target. default true."
"Example: e_turret stop_turret();"
"SPMP: singleplayer"
@/
stop_turret( n_index, b_clear_target = false )
{
	s_turret = _get_turret_data( n_index );
	
	s_turret.e_next_target = undefined;
	s_turret.e_target = undefined;
	
	s_turret ent_flag_clear( "turret manual" );
	
	if ( b_clear_target )
	{
		clear_turret_target( n_index );
	}
	
	self notify( "_stop_turret" + _index( n_index ) );
}

/@
"Name: fire_turret_for_time( <n_time> , [n_index] )"
"Summary: Fires a turret for a time, blocks for n_time"
"Module: Turret"
"MandatoryArg: <n_time>: The time to fire the turret for"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret fire_turret_for_time( 3 );"
"SPMP: singleplayer"
@/
fire_turret_for_time( n_time, n_index )
{
	Assert( IsDefined( n_time ), "n_time is a required parameter for _turet::fire_turret_for_time." );
	
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
		n_fire_time = WeaponFireTime( get_turret_weapon_name( n_index ) );
		assert( n_time >= n_fire_time, "Fire time (" + n_time + ") must be greater than the weapon's fire time. weapon fire time = " + n_fire_time );
		#/
	}
	
	while ( ( n_time > 0 ) || b_fire_forever)
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
"Name: shoot_turret_at_target( <e_target>, <n_time>, [v_offset], [n_index] )"
"Summary: Fires turret at given target"
"Module: Turret"
"MandatoryArg: <e_target>: The target of this turret"
"MandatoryArg: <n_time>: The time to fire the turret for"
"OptionalArg: [v_offset]: Offset from the turret target"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"OptionalArg: [b_just_once]: Ignore the time parameter and just fire once"
"Example: self thread shoot_turret_at_target( e_best_target, -1, undefined, n_index );"
"SPMP: singleplayer"
@/

// self = turret or vehicle
shoot_turret_at_target( e_target, n_time, v_offset, n_index, b_just_once )
{
	Assert( IsDefined( e_target ), "Undefined target passed to shoot_turret_at_target()." );
	
	self endon( "drone_death" );
	self endon( "death" );
	
	// Manual mode will stop the turret searching for new targets
	s_turret = _get_turret_data( n_index );
	s_turret ent_flag_set( "turret manual" );
	
	_shoot_turret_at_target( e_target, n_time, v_offset, n_index, b_just_once );
	
	s_turret ent_flag_clear( "turret manual" );
}

_shoot_turret_at_target( e_target, n_time, v_offset, n_index, b_just_once )
{
	self endon( "drone_death" );
	self endon( "death" );
	self endon( "_stop_turret" + _index( n_index ) );
	
	// only one of these threads at a time
	self notify( "_shoot_turret_at_target" + _index( n_index ) );
	self endon( "_shoot_turret_at_target" + _index( n_index ) );
	
	if ( n_time == -1 )
	{
		e_target endon( "death" );
	}
	
	if ( !IsDefined( b_just_once ) )
	{
		b_just_once = false;
	}

	set_turret_target( e_target, v_offset, n_index );
	
	_waittill_turret_on_target( e_target, n_index );
	
	if ( b_just_once )
	{
		fire_turret( n_index );
	}
	else
	{
		fire_turret_for_time( n_time, n_index );
	}
}

_waittill_turret_on_target( e_target, n_index )
{
	do
	{
		wait .5;
		if ( !IsDefined( n_index ) || ( n_index == 0 ) )
		{
			self waittill( "turret_on_target" );
		}
		else
		{
			self waittill( "gunner_turret_on_target" );
		}
	}
	while ( IsDefined( e_target ) && !can_turret_hit_target( e_target, n_index ) );
}

/@
"Name: shoot_turret_at_target_once( <e_target>, [v_offset], [n_index] )"
"Summary: Fires turret at given target once"
"Module: Turret"
"MandatoryArg: <e_target>: The target of this turret"
"OptionalArg: [v_offset]: Offset from the turret target"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: self thread shoot_turret_at_target_once( e_best_target, undefined, n_index );"
"SPMP: singleplayer"
@/
shoot_turret_at_target_once( e_target, v_offset, n_index )
{
	shoot_turret_at_target( e_target, 0, v_offset, n_index, true );
}

/@
"Name: enable_turret( [n_index] )"
"Summary: Enables the given turret"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"OptionalArg: [b_user_required]: Determines if the turret require a user to fire"
"OptionalArg: [v_offset]: Offset from the turret target"
"Example: e_turret maps\_turret::enable_turret();"
"SPMP: singleplayer"
@/
enable_turret( n_index, b_user_required, v_offset )
{
	if ( !is_turret_enabled( n_index ) )
	{
		if ( IsDefined( self.ai_node_user ) )
		{
			// someone is already on the node, set as user
			_set_turret_user( self.ai_node_user );
		}
		
		_get_turret_data( n_index ).is_enabled = true;
		self thread _turret_think( n_index, v_offset );
		self notify( "turret_enabled" + _index( n_index ) );
		
		if ( IsDefined( b_user_required ) && ( !b_user_required ) )
		{
			_get_turret_data( n_index ).b_needs_user = false;
		}
	}
}

/@
"Name: disable_turret( [n_index] )"
"Summary: Disables the given turret, But it keeps its targetted information"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret maps\_turret::disable_turret();"
"SPMP: singleplayer"
@/
disable_turret( n_index )
{
	if ( is_turret_enabled( n_index ) )
	{
		_drop_turret( n_index );

		// MikeA: 4/18/11		
		clear_turret_target( n_index );
		
		_get_turret_data( n_index ).is_enabled = false;

		self notify( "turret_disabled" + _index( n_index ) );
	}
}

/@
"Name: pause_turret( <time, 0=infinite>, [n_index] )"
"Summary: Disables the given turret, But it keeps its targetted information"
"Module: Turret"
"MandatoryArg: <time>: Time to pause turret for"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret maps\_turret::disable_turret( 0 );"
"SPMP: singleplayer"
@/

pause_turret( time, n_index )
{
	s_turret = _get_turret_data( n_index );

	// Convert time to Milli Seconds
	if( time > 0 )
	{
		time = time * 1000;
	}

	// If already paused, just add on the extra time
	if( IsDefined(s_turret.pause) )
	{
		s_turret.pause_time = s_turret.pause_time + time;
	}
	else
	{
		s_turret.pause = 1;
		s_turret.pause_time = time;
		stop_turret( n_index );
	}
}

/@
"Name: unpause_turret( [n_index] )"
"Summary: Disables the given turret, But it keeps its targetted information"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret maps\_turret::disable_turret();"
"SPMP: singleplayer"
@/

unpause_turret( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.pause = undefined;
}

#define TURRET_THINK_TIME 1.5
#define TURRET_LOSE_SIGHT_TIME 3000

// self = vehicle or turret
_turret_think( n_index, v_offset )
{
	no_target_start_time = 0;	// Time when turret last had a target
	
	self endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	
	/* only one think thread at a time */

	self notify( "_turret_think" + _index( n_index ) );
	self endon( "_turret_think" + _index( n_index ) );
	
	/# self thread _debug_turret_think( n_index ); #/
		
	self thread _turret_user_think( n_index );
		
	if ( !IS_VEHICLE( self ) )
	{
		self thread _turret_new_user_think( n_index );
	}
	
	s_turret = _get_turret_data( n_index );

	if( IsDefined( s_turret.has_laser ) )
	{
		self LaserOn();
	}
	
	while ( true )
	{
		s_turret ent_flag_waitopen( "turret manual" );
		
		n_time_now = GetTime();
		
		// Do we want to pause the turret?
		if ( self _check_for_paused( n_index ) || IsDefined( self.emped ) )
		{
			wait TURRET_THINK_TIME;
			continue;
		}
		
		a_potential_targets = _get_potential_targets( n_index );
		
		if ( !IsDefined( s_turret.e_target )
		    || ( s_turret.e_target.health < 0 )
		    || !IsInArray( a_potential_targets, s_turret.e_target )
			|| s_turret _did_turret_lose_target( n_time_now ) )
		{
			stop_turret( n_index );
		}
		
		// The turret picks the best candidate from the target array
		s_turret.e_next_target = _get_best_target_from_potential( a_potential_targets, n_index );

		/* If we have a new target, shoot at it */
		if ( IsDefined( s_turret.e_next_target ) )
		{
			s_turret.b_target_out_of_range = undefined;
			s_turret.n_time_lose_sight = undefined;
			no_target_start_time = 0;
			
			if ( !is_turret_target( s_turret.e_next_target, n_index ) && _user_check( n_index ) )
			{
				self thread _shoot_turret_at_target( s_turret.e_next_target, -2, v_offset, n_index );
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
			target_wait_time = ( n_time_now - no_target_start_time ) / 1000.0;
			
			// If we've been waitng for a target for too long, drop the turret
			if ( IsDefined(s_turret.occupy_no_target_time) )
			{
				occupy_time = s_turret.occupy_no_target_time;
			}
			else
			{
				occupy_time = MAX_OCCUPY_NO_TARGET_TIME;
			}
			
			if ( target_wait_time >= occupy_time )
			{
				_drop_turret( n_index );
			}
		}

		wait TURRET_THINK_TIME;
	}
}

// self = turret struct
_did_turret_lose_target( n_time_now )
{
	if ( IS_TRUE( self.b_target_out_of_range ) )
	{
		return true;
	}
	else if ( IsDefined( self.n_time_lose_sight ) )
	{
		return ( ( n_time_now - self.n_time_lose_sight ) > TURRET_LOSE_SIGHT_TIME );
	}
	
	return false;
}

_turret_user_think( n_index )
{
	self endon( "death" );
	self endon( "turret_disabled" + _index( n_index ) );
	self endon( "_turret_think" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
	
	while ( true )
	{
		waittill_any_ents( self, "turretownerchange", s_turret, "turretownerchange", s_turret.ai_user, "death" );
		
		if ( !_user_check( n_index ) )
		{
			stop_turret( n_index, true );
			_clear_animations( n_index );
		}
	}
}

// self = turret or vehicle
_check_for_paused( n_index )
{
	s_turret = _get_turret_data( n_index );
	
	s_turret.pause_start_time = GetTime();
	
	while ( IsDefined( s_turret.pause ) )
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
		
		WAIT_FRAME;
	}
	
	return false;
}

// self = vehicle or turret
_drop_turret( n_index )
{
	ai_user = get_turret_user( n_index );
	
	if ( IsAlive( ai_user ) && !is_true( ai_user._turret_stay_on ) )
	{	
		// MikeA: 4/19/11 - Player can continue to use the turret
		player = get_players()[0]; 
		if( ai_user == player )
		{
			return;
		}
			
		if ( !IS_VEHICLE( self ) )
		{
			ai_user StopUseTurret();
		}
	}
}

_turret_new_user_think( n_index )
{
	const NEW_USER_THINK_TIME = 3;
	
	self endon( "death" );
	self endon( "_turret_think" + _index( n_index ) );
	self endon( "turret_disabled" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
		
	while ( does_turret_need_user( n_index ) )
	{
		wait NEW_USER_THINK_TIME;
		
		if ( does_turret_have_target( n_index ) )
		{
			ai_user = get_turret_user( n_index );
			if ( IsDefined( ai_user ) )
			{
				// already have a user, make sure he's using the turret
				ai_user thread use_turret( self, n_index );
			}
			else if ( has_spawnflag( SPAWNFLAG_TURRET_GET_USERS ) )
			{
				str_team = get_turret_team( n_index );
		
				if ( IS_VEHICLE( self ) )
				{
				}
				else
				{
					a_users = GetAIArray( str_team );
					
					if ( a_users.size > 0 )
					{
						a_users = array_removeDead( a_users );					
						ai_closest = getClosest( self.origin, a_users );
						
						if ( IsDefined( self.radius ) )
						{
							if ( distancesquared( ai_closest.origin, self.origin ) < self.radius * self.radius )
							{
								ai_user = ai_closest;
							}
						}
						else
						{
							ai_user = ai_closest;
						}
						
						//TODO: make sure new user can path to turret
					}
				}
				
				if ( IsAlive( ai_user ) )
				{
					ai_user thread use_turret( self, n_index );
				}
			}
		}
	}
}

does_turret_have_target( n_index )
{
	return IsDefined( _get_turret_data( n_index ).e_next_target );
}

// self = ?
_turret_node_think( n_index )
{
	const NODE_THINK_TIME = .05;
	
	self endon( "death" );
	
	while( true )
	{
		wait NODE_THINK_TIME;
		
		if ( IsDefined( self.node ) )
		{
			b_enable_node = is_turret_enabled( n_index ) && does_turret_have_target( n_index );
			SetEnableNode( self.node, b_enable_node );
		}
	}
}

_stop_turret_when_user_changes( n_index )
{
	self endon( "death" );
	s_turret = _get_turret_data( n_index );
	waittill_any_ents( self, "turretownerchange", s_turret, "turretownerchange", s_turret.ai_user, "death" );
	stop_turret( n_index, true );
	_clear_animations( n_index );
}

_user_check( n_index )
{
	s_turret = _get_turret_data( n_index );
	ai_user = s_turret.ai_user;

	b_needs_user = does_turret_need_user( n_index );
	
	b_has_user = false;
	
	if ( IS_VEHICLE( self ) )
	{
		b_has_user = IsAlive( s_turret.ai_user );
	}
	else
	{
		e_user = self GetTurretOwner();
		b_has_user = IsDefined( e_user );
		
		// MikeA - 4/22/11 - Ok the turret may have an owner but its possible he's dead and not registered yet
		if( b_has_user )
		{
			if( !IsDefined(ai_user) || (ai_user.health <= 0) )
			{
				b_has_user = 0;
			}
		}
	}
	
	return ( !b_needs_user || b_has_user );
}

_get_user_target( n_index )
{
	if ( !IS_VEHICLE( self ) )
	{
		ai_user = self GetTurretOwner();
		if ( IsDefined( ai_user ) )
		{
			return ai_user.enemy;
		}
	}
}

/#

_debug_turret_think( n_index )
{
	self endon( "death" );
	self endon( "_turret_think" + _index( n_index ) );
	self endon( "turret_disabled" + _index( n_index ) );
	
	s_turret = _get_turret_data( n_index );
	v_color = ( 0, 0, 1 );
	
	while ( true )
	{
		if( !GetDvarint( "g_debugTurrets") )
		{
			wait(0.2);
			continue;
		}

		has_target = IsDefined( get_turret_target( n_index ) );
		
		if ( ( does_turret_need_user( n_index )	&& !does_turret_have_user( n_index ) )
			|| !has_target )
		{
			v_color = ( 1, 1, 0 );
		}
		else
		{
			v_color = ( 0, 1, 0 );
		}
		
		str_team = get_turret_team( n_index );
		if ( !IsDefined( str_team ) )
		{
			str_team = "no team";
		}
		
		str_target = "target > ";
		
		e_target = s_turret.e_next_target;		
		if ( IsDefined( e_target ) )
		{
			if ( IsAI( e_target ) )
			{
				str_target += "ai";
			}
			else if ( IsPlayer( e_target ) )
			{
				str_target += "player";
			}
			else if ( IS_VEHICLE( e_target ) )
			{
				str_target += "vehicle";
			}
			else if ( IsDefined( e_target.targetname ) && ( e_target.targetname == "drone" ) )
			{
				str_target += "drone";
			}
			else if ( IsDefined( e_target.classname ) )
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

//*******************************************************************************************************
//*******************************************************************************************************

/@
"Name: create_turret( <position>, <angles>, <team>, <weaponinfo>, <model>, [offset] )"
"Summary: Create a turret at runtime at a given position"
"Module: _turret"
"MandatoryArg: <position>	Position of the turret"
"MandatoryArg: <angles>		Default turret angles"
"MandatoryArg: <team>		Team of the Turret"
"MandatoryArg: <weaponinfo>	GDT weapon info of the turret, eg. 'saw_bipod_crouch' "
"MandatoryArg: <model>		Turret model"
"OptionalArg: [offset]		Optional positional offset for the turrets position"
"Example: e_turret = maps\_turret::create_turret( (0,0,0), (0,0,0), "axis", "saw_bipod_crouch", "weapon_rpd_mg_setup" );"
"SPMP: singleplayer"
@/

create_turret( position, angles = (0,0,0), team, weaponinfo, turret_model, offset )
{
	origin = position;
	if( IsDefined(offset) )
	{
		origin = origin + offset;
	}
	
	e_turret = spawnTurret( "misc_turret", origin, weaponinfo );
	e_turret setModel( turret_model );
	e_turret.angles = angles;
	
	e_turret.weaponinfo = weaponinfo;
	
	e_turret SetDefaultDropPitch( 0 );
	
	e_turret set_turret_team( team );
	
	e_turret enable_turret();

	return e_turret;
}

/*===================================================================================================
	SYSTEM FUNCTIONS
===================================================================================================*/

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	Get the data structure holding the turret info
RETURNS:	The turret data struct
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
_get_turret_data( n_index )
{
	s_turret = undefined;
	
	if ( IS_VEHICLE( self ) )
	{
		if ( IsDefined( self.a_turrets ) && IsDefined( self.a_turrets[ n_index ] ) )
		{
			s_turret = self.a_turrets[ n_index ];
		}
	}
	else
	{
		s_turret = self._turret;		
	}
	
	if ( !IsDefined( s_turret ) )
	{
		s_turret = _init_turret( n_index );
	}
	
	return s_turret;
}

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	Initialize a turret for use in this system
RETURNS:	The turret data struct
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/

_init_turret( n_index = 0 )
{
	self endon( "death" );
	
	str_weapon = get_turret_weapon_name( n_index );
	
	if ( !IsDefined( str_weapon ) )
	{
		AssertMsg( "Cannot initialize turret. No weapon info." );
		return;
	}
	
	waittill_asset_loaded( "xmodel", self.model );
	
	if ( IS_VEHICLE( self ) )
	{
		s_turret = _init_vehicle_turret( n_index );
	}
	else
	{
		n_index = 0;
		s_turret = _init_misc_turret();
	}
	
	s_turret.str_weapon = str_weapon;
	_update_turret_arcs( n_index );
	
	s_turret.is_enabled = false;
	s_turret.e_parent = self;
	s_turret.e_target = undefined;
	s_turret.b_ignore_line_of_sight = false;
	s_turret.v_offset = (0, 0, 0);
	s_turret.n_burst_fire_time = 0;

	// Defaults
	s_turret.str_weapon_type = "bullet";
	s_turret.str_guidance_type = "none";
	
	str_weapon = self get_turret_weapon_name( n_index );
	if ( IsDefined( str_weapon ) )
	{
		weapon_type = WeaponType( str_weapon );
		if( IsDefined( weapon_type) )
		{
			s_turret.str_weapon_type = weapon_type;
		}
	
		s_turret.str_guidance_type = WeaponGuidedMissileType( str_weapon );
	}
	
	set_turret_on_target_angle( undefined, n_index );
	
	s_turret.n_target_flags = TURRET_TARGET_AI | TURRET_TARGET_PLAYERS;
	
	set_turret_best_target_func_from_weapon_type( n_index );

	s_turret ent_flag_init( "turret manual" );

	return s_turret;
}

_update_turret_arcs( n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.rightarc = WeaponRightArc( s_turret.str_weapon );
	s_turret.leftarc = WeaponLeftArc( s_turret.str_weapon );
	s_turret.toparc = WeaponTopArc( s_turret.str_weapon );
	s_turret.bottomarc = WeaponBottomArc( s_turret.str_weapon );
}

/@
"Name: set_turret_best_target_func_from_weapon_type( [n_index] )"
"Summary: Sets the best target for this turret.  Default is the based on the turrets weapon type"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: set_turret_best_target_func_from_weapon_type( n_index );"
"SPMP: singleplayer"
@/
set_turret_best_target_func_from_weapon_type( n_index )
{
	switch ( _get_turret_data( n_index ).str_weapon_type )
	{
		case "bullet":
			set_turret_best_target_func( ::_get_best_target_bullet, n_index );
			break;
			
		case "gas":
			set_turret_best_target_func( ::_get_best_target_gas, n_index );
			break;
		
		case "grenade":
			set_turret_best_target_func( ::_get_best_target_grenade, n_index );
			break;
		
		case "projectile":
			set_turret_best_target_func( ::_get_best_target_projectile, n_index );
			break;
		
		default:
			AssertMsg( "unsupported turret weapon type." );
	}
}

/@
"Name: set_turret_best_target_func( <::function>, [n_index] )"
"Summary: Custom override function, scripter can use to custermise their choice from potential targets"
"Module: Turret"
"MandatoryArg: <function>: Override target selection function"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: set_turret_best_target_func( ::_get_best_target_bullet, n_index );"
"SPMP: singleplayer"
@/

set_turret_best_target_func( func_get_best_target, n_index )
{
	_get_turret_data( n_index ).func_get_best_target = func_get_best_target;
}

/*===================================================================
SELF:		turret
PURPOSE:	Initialize a misc turret for use in this system -
helper function for _init_turret
RETURNS:	The turret data struct
===================================================================*/
_init_misc_turret()
{
	self UseAnimTree( #animtree );
	_init_animations();
	
	s_turret = SpawnStruct();
		
	if ( IsDefined( self.script_team ) )
	{
		s_turret.str_team = self.script_team;
	}
	
	s_turret.n_rest_angle_pitch = 0;
	s_turret.n_rest_angle_yaw = 0;
	s_turret.str_tag_flash = "tag_flash";
	
	if ( IsDefined( self GetTagOrigin( "tag_barrel" ) ) )
	{
		s_turret.str_tag_pivot = "tag_barrel";
	}
	else if ( IsDefined( self GetTagOrigin( "mg01" ) ) )
	{
		s_turret.str_tag_pivot = "mg01";
	}
	else if ( IsDefined( self GetTagOrigin( "tag_dummy" ) ) )
	{
		s_turret.str_tag_pivot = "tag_dummy";
	}
	else
	{
		AssertMsg( "No pivot tag found for turret." );
	}
	
	self._turret = s_turret;
	
	return s_turret;
}

/*===================================================================
SELF:		vehicle
PURPOSE:	Initialize a vehicle turret for use in this system
RETURNS:	The turret data struct
<n_index>:	index of vehicle turret
===================================================================*/
_init_vehicle_turret( n_index )
{
	Assert( IsDefined( n_index ) && ( n_index >= 0 ), "Invalid index specified to initialize vehicle turret." );
	
	s_turret = SpawnStruct();
	
	v_angles = self GetSeatFiringAngles( n_index );
	if ( IsDefined( v_angles ) )
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
			s_turret.str_tag_flash = "tag_flash_gunner1";
			s_turret.str_tag_pivot = "tag_gunner_barrel1";
			break;
		
		case 2:
			s_turret.str_tag_flash = "tag_flash_gunner2";
			s_turret.str_tag_pivot = "tag_gunner_barrel2";
			break;
	
		case 3:
			s_turret.str_tag_flash = "tag_flash_gunner3";
			s_turret.str_tag_pivot = "tag_gunner_barrel3";
			break;
		
		case 4:
			s_turret.str_tag_flash = "tag_flash_gunner4";
			s_turret.str_tag_pivot = "tag_gunner_barrel4";
			break;
	}
	
	if ( IS_HELICOPTER( self ) )
	{
		// helicopters are not likely to shoot themselves, but can also cause problems tracing
		// don't ignore ground vehicle like trucks because they are likely to shoot themselves
		s_turret.e_trace_ignore = self;
	}

	if ( n_index > 0 )
	{
		// If vehicle has a gunner tag, assume it needs a user
		tag_origin = self GetTagOrigin( _get_gunner_tag_for_turret_index( n_index ) );
		if ( IsDefined( tag_origin ) )
		{
			s_turret.b_needs_user = true;
		}
	}
	
	if ( !IsDefined( self.a_turrets ) )
	{
		self.a_turrets = [];
	}
	
	self.a_turrets[n_index] = s_turret;
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
_burst_fire( n_max_time, n_index )
{
	if ( n_max_time < 0 )
	{
		n_max_time = 9999;
	}
	
	s_turret = _get_turret_data( n_index );
	
	n_burst_time = _get_burst_fire_time( n_index );
	n_burst_wait = _get_burst_wait_time( n_index );
	
	if ( !IsDefined( n_burst_time ) || ( n_burst_time > n_max_time ) )
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
			
	self thread _animate_fire_for_time( n_burst_time, n_index );
	
	n_fire_time = WeaponFireTime( get_turret_weapon_name( n_index ) );
	n_total_time = 0;
	
	while ( n_total_time < n_burst_time )
	{
		fire_turret( n_index );
		
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

_animate_fire_for_time( n_time, n_index )
{
	_animate_fire( n_index );
	self waittill_any_or_timeout( n_time, "death", "drone_death", "_stop_turret" + _index( n_index ), "turret_disabled" + _index( n_index ) );
	if ( IsDefined( self ) )
	{
		_animate_idle( n_index );
	}
}

/*===================================================================
SELF:		turret or vehicle
PURPOSE:	get the random burst time for a turret based on min
and max values
RETURNS:	number between burst_min and burst_max, or 0
[n_index]:	optional index of vehicle turret if self is a vehicle
===================================================================*/
_get_burst_fire_time( n_index)
{
	s_turret = _get_turret_data( n_index );
	n_time = undefined;
	
	if ( IsDefined( s_turret.n_burst_fire_min ) && IsDefined( s_turret.n_burst_fire_max ) )
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
	else if ( IsDefined( s_turret.n_burst_fire_max ) )
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
_get_burst_wait_time( n_index )
{
	s_turret = _get_turret_data( n_index );
	n_time = 0;
	
	if ( IsDefined( s_turret.n_burst_wait_min ) && IsDefined( s_turret.n_burst_wait_max ) )
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
	else if ( IsDefined( s_turret.n_burst_wait_max ) )
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
_index( n_index )
{
	if ( IsDefined( n_index ) )
	{
		return string( n_index );
	}
	else
	{
		return "";
	}
}

/*------------------------------------------------------------------------------------------------------
	Targeting Functions
------------------------------------------------------------------------------------------------------*/

// self = turret or vehicle
_get_potential_targets( n_index )
{
	s_turret = self _get_turret_data( n_index );

	//************************************************************************************************
	// MikeA: For now if we have a target array the only targets we are interested is the target array
	//************************************************************************************************
	
	a_priority_targets = self _get_any_priority_targets( n_index );
	
	if( IsDefined(a_priority_targets) )
	{
		//return arrayCopy( a_priority_targets );
		return( a_priority_targets );
	}	
	
	//****************************
	// Search for a regular target
	//****************************

	a_potential_targets = [];

// sb42 todo - if e_target is still a valid target add it to the potential target list
	if( IsDefined(s_turret.e_target) )
	{
		a_potential_targets[ a_potential_targets.size ] = s_turret.e_target;
	}

	str_team = get_turret_team( n_index );
	if ( IsDefined( str_team ) )
	{
		str_opposite_team = "allies";
		if ( str_team == "allies" )
		{
			str_opposite_team = "axis";
		}
		
		if ( _has_target_flags( TURRET_TARGET_AI, n_index ) )
		{
			a_ai_targets = GetAIArray( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_ai_targets, true, false );
		}
			
		if ( _has_target_flags( TURRET_TARGET_PLAYERS, n_index ) )
		{
			a_player_targets = get_players( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_player_targets, true, false );
		}

		if ( _has_target_flags( TURRET_TARGET_DRONES, n_index ) )
		{
			a_drone_targets = maps\_drones::drones_get_array( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_drone_targets, true, false );
		}
		
		if ( _has_target_flags( TURRET_TARGET_VEHICLES, n_index ) )
		{
			a_vehicle_targets = GetVehicleArray( str_opposite_team );
			a_potential_targets = ArrayCombine( a_potential_targets, a_vehicle_targets, true, false );
		}
		
		// remove targets that should be ignored
		for ( i=0; i < a_potential_targets.size; i++ )
		{
			e_target = a_potential_targets[i];
			
			assert( IsDefined( e_target ), "Undefined potential turret target." );
		
			// Should we remove the target?	
			if ( is_true(e_target.ignoreme) || (e_target.health <= 0) )
			{
				ArrayRemoveValue( a_potential_targets, e_target );
			}
			
			// Removal checks for Sentients Only
			else if( IsSentient(e_target) )
			{
				if ( (e_target IsNoTarget()) || (e_target is_dead_sentient()) )
				{
					ArrayRemoveValue( a_potential_targets, e_target );
				}
			}
		}
	}
	
	a_targets = a_potential_targets;
	
	if( IsDefined(s_turret) && IsDefined(s_turret.a_ignore_target_array) )
	{
		while( 1 )
		{
			found_bad_target = 0;
			a_targets = a_potential_targets;
	
			for( i=0; i<a_targets.size; i++ )
			{
				e_target = a_targets[i];
				found_bad_target = 0;

				for( j=0; j<s_turret.a_ignore_target_array.size; j++ )
				{
					if( e_target == s_turret.a_ignore_target_array[j] )
					{
						ArrayRemoveValue( a_potential_targets, e_target );
						found_bad_target = 1;
						break;
					}
				}
			}
			
			if( !found_bad_target )
			{
				break;
			}
		}
	}
	
	return a_potential_targets;
}

_get_any_priority_targets( n_index )
{
	a_targets = undefined;

	s_turret = _get_turret_data( n_index );

	// Do we have a set of priority targets?
	if( IsDefined(s_turret.priority_target_array) )
	{
		while( 1 )
		{
			found_bad_target = 0;
			a_targets = s_turret.priority_target_array;

			// Make sure all the priority tagets are still alive
			for( i=0; i<a_targets.size; i++ )
			{
				e_target = a_targets[i];
				bad_index = undefined;
				
				// Should we remove the target?
				if( !IsDefined(e_target) )
				{
					bad_index = i;
				}
				else if ( !IsAlive(e_target) )
				{
					bad_index = i;
				}
				else if( e_target.health <= 0 )
				{
					bad_index = i;
				}
				else if( IsSentient(e_target) && (e_target is_dead_sentient()) )
				{
					bad_index = i;
				}
					
				if( IsDefined(bad_index) )
				{
					s_turret.priority_target_array = a_targets;
					ArrayRemoveValue( s_turret.priority_target_array, e_target );
					found_bad_target = 1;
					break;
				}
			}
	
			// Did we removee any bad targets?
			if( !found_bad_target )
			{
				return( s_turret.priority_target_array );
				break;
			}		
			else
			{
				if(	s_turret.priority_target_array.size <= 0 )
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

_get_best_target_from_potential( a_potential_targets, n_index )
{
	s_turret = _get_turret_data( n_index );
	return [[ s_turret.func_get_best_target ]]( a_potential_targets, n_index );
}

_get_best_target_bullet( a_potential_targets, n_index )
{
	e_best_target = undefined;
	
	while ( !IsDefined( e_best_target ) && ( a_potential_targets.size > 0 ) )
	{
		e_closest_target = getClosest( self.origin, a_potential_targets );

		if( self can_turret_hit_target( e_closest_target, n_index ) )
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

_get_best_target_gas( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

_get_best_target_grenade( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

_get_best_target_projectile( a_potential_targets, n_index )
{
	// TODO: TEMP: use bullet function
	return _get_best_target_bullet( a_potential_targets, n_index );
}

/@
"Name: can_turret_hit_target( <e_target>, [n_index] )"
"Summary: Check bothif the target is within the turrets constaraints and theres is nothing blocking a LOS"
"Module: Turret"
"MandatoryArg: <e_target> Target the Turret wants to fire at"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret can_turret_hit_target( e_guy, 1 );"
"SPMP: singleplayer"
@/

// self = vehicle or turret
can_turret_hit_target( e_target, n_index )
{
	s_turret = _get_turret_data( n_index );
	v_offset = _get_default_target_offset( e_target, n_index );
	
	b_current_target = is_turret_target( e_target, n_index );
	
	b_target_in_view = is_target_in_turret_view( e_target, v_offset, n_index );
	b_trace_passed = true;
	
	if ( b_target_in_view )
	{
		if ( !s_turret.b_ignore_line_of_sight )
		{
			b_trace_passed = turret_trace_test( e_target, v_offset, n_index );
		}
		
		if ( b_current_target && !b_trace_passed && !IsDefined( s_turret.n_time_lose_sight ) )
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
"Name: is_target_in_turret_view( <e_target>, [n_index] )"
"Summary: Gets a turret's weapon"
"Module: Turret"
"MandatoryArg: <e_target> Target the Turret wants to fire at"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret is_target_in_turret_view( e_guy, 1 );"
"SPMP: singleplayer"
@/

//self = turret/vehicle
is_target_in_turret_view( e_target, v_offset, n_index )
{
	/#
		_update_turret_arcs( n_index );
	#/
		
	s_turret = _get_turret_data( n_index );
	
	v_pivot_pos = self GetTagOrigin( s_turret.str_tag_pivot );
	v_angles_to_target = VectorToAngles( ( e_target.origin + v_offset ) - v_pivot_pos );
	
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
"Name: can_turret_shoot_target( <e_target>, [n_index] )"
"Summary: Basically is there anythinhg blocking the turrets shot (geo etc..)"
"Module: Turret"
"MandatoryArg: <e_target> Target the Turret wats to fire at"
"OptionalArg: [v_offset]: Optional offset"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: vh_heli can_turret_shoot_target( e_guy, 1 );"
"SPMP: singleplayer"
@/

#define TURRET_TRACE_OFFSET 15
//self = turret/vehicle
turret_trace_test( e_target, v_offset = (0,0,0), n_index )
{
	s_turret = _get_turret_data( n_index );
	
	v_start_org = self GetTagOrigin( s_turret.str_tag_pivot );
	if ( e_target SightConeTrace( v_start_org, self ) > .2 )
	{
		// If we can see the target, make sure we can bullet trace over half way to hit the target
		v_target = e_target.origin + v_offset;
		v_start_org += VectorNormalize( v_target - v_start_org ) * TURRET_TRACE_OFFSET;
		a_trace = BulletTrace( v_start_org, v_target, true, s_turret.e_trace_ignore, true, true, e_target );
		if ( a_trace["fraction"] > .6 )
		{
			return true;
		}
	}
	
	return false;
}

/@
"Name: set_turret_ignore_line_of_sight( <b_ignore>, [n_index] )"
"Summary: Set whether a turret will ignore line of sight or not"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret set_turret_ignore_line_of_sight( true, 0 );"
"SPMP: singleplayer"
@/

set_turret_ignore_line_of_sight( b_ignore, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.b_ignore_line_of_sight = b_ignore;
}

/@
"Name: set_turret_occupy_no_target_time( <time>, [n_index] )"
"Summary: How long an AI will stay inside a turret if there is no target, default = 2.0"
"Module: Turret"
"OptionalArg: [n_index]: Index of the turret for a vehicle turret"
"Example: e_turret set_turret_occupy_no_target_time( 4 );"
"SPMP: singleplayer"
@/

set_turret_occupy_no_target_time( time, n_index )
{
	s_turret = _get_turret_data( n_index );
	s_turret.occupy_no_target_time = time;
}

//*****************************************************************************
// If the AI or Drone is manning a Turret, init the vehicles turret
// self  = AI User or Drone User
//*****************************************************************************

_vehicle_turret_set_user( ai_user, str_tag )
{
	turret_id = _get_turret_index_for_tag( str_tag );
	
	if ( IsDefined( turret_id ) )
	{
		self _set_turret_user( ai_user, turret_id );
	}
}

_vehicle_turret_clear_user( ai_user, str_tag )
{
	turret_id = _get_turret_index_for_tag( str_tag );
	
	if ( IsDefined( turret_id ) )
	{
		self _set_turret_user( undefined, turret_id );
	}
}

_get_gunner_tag_for_turret_index( n_index )
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

_get_turret_index_for_tag( str_tag )
{
	switch ( str_tag )
	{
	case "tag_gunner1":	return 1;
	case "tag_gunner2":	return 2;
	case "tag_gunner3":	return 3;
	case "tag_gunner4":	return 4;
	}
}

/*------------------------------------------------------------------------------------------------------
	Animation
------------------------------------------------------------------------------------------------------*/
	
// stand idle = %saw_gunner_idle_mg
// stand fire = %saw_gunner_firing_mg_add
	
// crouch idle = %saw_gunner_lowwall_idle_mg
// crouch fire = %saw_gunner_lowwall_firing_mg
	
_init_animations( ai_user, n_index )
{
	// TODO: structure the animations in a way that can be accessed by weapon name
	
	if ( IS_VEHICLE( self ) )
	{
	}
	else
	{		
		if ( IsDefined( ai_user ) && ( ai_user.desired_anim_pose == "stand" ) )
		{
			self SetAnimKnobLimitedRestart(%saw_gunner_idle_mg);
			self SetAnimKnobLimitedRestart(%saw_gunner_firing_mg_add);
		}
		else
		{
			self SetAnimKnobLimitedRestart(%saw_gunner_lowwall_idle_mg);
			self SetAnimKnobLimitedRestart(%saw_gunner_lowwall_firing_mg);
		}
	}
}

_animate_idle( n_index )
{
	if ( IS_VEHICLE( self ) )
	{
	}
	else
	{
		if ( _user_check( n_index ) )
		{
			self SetAnim( %additive_idle, 1, .1 );
			self SetAnim( %additive_fire, 0, .1 );
		}
	}
}

_animate_fire( n_index )
{
	if ( IS_VEHICLE( self ) )
	{
	}
	else
	{
		if ( _user_check( n_index ) )
		{
			self SetAnim( %additive_idle, 0, .1 );
			self SetAnim( %additive_fire, 1, .1 );
		}
	}
}

_clear_animations( n_index )
{
	if ( IS_VEHICLE( self ) )
	{
	}
	else
	{
		self SetAnim( %additive_idle, 0, .1 );
		self SetAnim( %additive_fire, 0, .1 );
	}
}

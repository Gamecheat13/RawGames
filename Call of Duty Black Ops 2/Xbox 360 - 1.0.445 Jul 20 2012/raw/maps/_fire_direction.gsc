/*-----------------------------------------------------------------------------
_fire_direction.gsc

This script handles everything about redirecting and ent to fire at stuff in 
the environment. 

To use this feature:
- call precache before _load::main
- call init_fire_direction after _load::main
- call add_fire_direction_shooter to specify the ent that will fire
- press up on the D-pad to bring up fire direction
- call _fire_direction_kill to stop using this feature
-----------------------------------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_quadrotor;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#include maps\_vehicle;

#define FIRE_DIRECTION_WEAPON "data_glove_sp"
#define CLAW_FLAMETHROWER_MAX_DIST 500
#define COOLDOWN_TIME 4
#define HINT_COOLDOWN_MS 15000;
#define ENEMY_WITHIN_SHOOT_RADIUS 196
#define AIM_RANGE 4000
#define CLIENT_FLAG_OVERLAY 10

// call before _load::main
precache()
{
	PrecacheItem( FIRE_DIRECTION_WEAPON ); 
	PrecacheString( &"hud_update_visor_text" );	
	PrecacheString( &"SCRIPT_FIRE_DIRECTION" );	
	PrecacheString( &"SCRIPT_FIRE_DIRECTION_CONFIRM" );	
	PrecacheString( &"SCRIPT_FIRE_DIRECTION_WIIU" );		
}

// call after _load::main
init_fire_direction()  // self = player
{
	const DPAD_UP = 1;
	
	flag_init( "_fire_direction_kill" );
	flag_init( "fire_direction_shader_on" );
	flag_init( "fire_direction_target_confirmed" );
	
	Assert( IsPlayer( self ), "fire_direction feature can only be enabled on players!" );
	
	// set up shooters array
	if ( !IsDefined( level._fire_direction ) )
	{
		level._fire_direction = SpawnStruct();  // everything gets stored on this struct for fire direction
		level._fire_direction.active = true;  // active = can use feature or not. killing feature will make this false, and nothing else
		level._fire_direction.a_shooters = [];  // array of entities that can fire using this feature
		level._fire_direction.fire_func = ::quadrotors_find_player_target;  // default targeting func is for quadrotor. override with add_fire_direction_func
		level._fire_direction.valid_target_func = ::_is_target_area_valid; // default valid area check is for quadrotor. override with add_fire_direction_valid_area_check
		level._fire_direction.time_last_used = 0;  // use to check last time since fire direction used. compares against HINT_COOLDOWN_MS value
		level._fire_direction.hint_active = false;  // check to see if hint is on screen or not
		level._fire_direction.can_hint = true;  // toggles ability to show hint text
	}	
	
	// give player weapon and bind it to D-Pad UP
	get_players()[0] GiveWeapon( FIRE_DIRECTION_WEAPON );
	get_players()[0] SetActionSlot( DPAD_UP, "weapon", FIRE_DIRECTION_WEAPON );

	_get_aim_model(); // create model for shader - gets deleted when feature stops
		
	// thread watcher functions
	self thread _switch_to_weapon();
	self thread _handle_shader();
	self thread _hint_text();
}

add_fire_direction_shooter( e_shooter )
{
	Assert( IsDefined( e_shooter ), "e_shooter is a required parameter for add_fire_direction_shooter function" );

	// clear any dead from array 
	if ( level._fire_direction.a_shooters.size > 0 )
	{
		level._a_fire_direction_shooters = array_removeDead( level._a_fire_direction_shooters );
	}
	
	// add new ent into array
	level._fire_direction.a_shooters[ level._fire_direction.a_shooters.size ] = e_shooter;
}

// adds function to tell a shooter ent where to fire in environment. self = shooter
add_fire_direction_func( fire_direction_func )
{
	Assert( IsDefined( level._fire_direction ), "fire_direction is not set up. Run maps\_fire_direction::init before add_fire_direction_func!" );
	
	level._fire_direction.fire_func = fire_direction_func;
}

//check to see if any shooters remain
check_for_valid_shooters()
{
	// clear any dead from array 
	if ( level._fire_direction.a_shooters.size > 0 )
	{
		level._fire_direction.a_shooters = array_removeDead( level._fire_direction.a_shooters );
	}	
	return level._fire_direction.a_shooters.size;	
}

_fire_direction_enable()
{
	Assert( IsPlayer( self ), "_fire_direction_enable can only be called on players!" );
	
	// allow use of feature
	level._fire_direction.can_hint = true;
	self GiveWeapon( FIRE_DIRECTION_WEAPON );
}

_fire_direction_disable()
{
	Assert( IsPlayer( self ), "_fire_direction_disable can only be called on players!" );
	
	// disable use of feature
	if ( level._fire_direction.hint_active )
	{
		screen_message_delete();
	}	
	
	level._fire_direction.can_hint = false;
	
	self TakeWeapon( FIRE_DIRECTION_WEAPON );
	
	level notify( "fire_direction_stop_hint" );
}

_fire_direction_remove_hint()
{
	level._fire_direction.can_hint = false;
	
	if ( level._fire_direction.hint_active )
	{
		screen_message_delete();
	}
	
	level notify( "fire_direction_stop_hint" );
}

is_fire_direction_active()
{	
	return ( IsDefined( level._fire_direction ) && level._fire_direction.active );
}

_fire_direction_allow_hint()
{
	level._fire_direction.can_hint = true;
}

_fire_direction_kill()
{
	Assert( IsPlayer( self ), "_fire_direction_kill can only be called on players!" );
	
	flag_clear( "fire_direction_shader_on" );
	ClientNotify( "grid_shader_off" );
	level notify( "_fire_direction_kill" );
	
	self GiveWeapon( level.str_weapon_last );
	self SwitchToWeapon( level.str_weapon_last );
	self TakeWeapon( FIRE_DIRECTION_WEAPON );
	screen_message_delete();
}

// delete shader model
_fire_direction_shader_cleanup()
{
	m_aim = GetEnt( "m_fire_direction_aim_shader", "targetname" );
	
	if( IsDefined( m_aim ) )
	{
		m_aim Delete();
	}
}

_fire_direction_remove() // self = player
{
	Assert( IsPlayer( self ), "_fire_direction_kill can only be called on players!" );
	
	// stop/clear settings for feature
	level notify( "_fire_direction_kill" );
	
	self TakeWeapon( FIRE_DIRECTION_WEAPON );
	
}

_switch_to_weapon()  // self = player
{
	level endon( "_fire_direction_kill" );
	
	level.str_weapon_last = self GetCurrentWeapon();
	
	m_shader_model = GetEnt( "m_fire_direction_aim_shader", "targetname" ); // this gets spawned when feature enables

	while ( IsAlive( self ) )
	{
		self waittill_has_a_weapon(); // wait until player has a weapon
		str_weapon_current = self GetCurrentWeapon();
					
		if ( str_weapon_current == FIRE_DIRECTION_WEAPON )
		{
			flag_set( "fire_direction_shader_on" ); 
			
			m_shader_model.origin = _get_aim_postion(); // update shader position
			
			// run whatever function is set for checking valid targets. default = _is_target_area_valid
			b_using_valid_area = [[ level._fire_direction.valid_target_func ]](); 
			b_pressed_attack = self AttackButtonPressed();
	
			b_should_fire = ( b_pressed_attack && b_using_valid_area );
			
			if ( b_should_fire )
			{
				if( !flag( "fire_direction_target_confirmed" ) )
				{
			   		flag_set( "fire_direction_target_confirmed" );
				}
							
				// run whatever function is set for fire direction. default = quadrotor_attack_player_target
				self thread [[ level._fire_direction.fire_func ]]();  
				
				level notify( "fire_direction_stop_weapon" );	
				// set last used time
				level._fire_direction.time_last_used = GetTime();
				
				// remove fire direction weapon
				flag_clear( "fire_direction_shader_on" );	
								
				self thread _disable_weapon( level.str_weapon_last );
				
				screen_message_delete();
				
				wait COOLDOWN_TIME;
				
				// give weapon back
				self GiveWeapon( FIRE_DIRECTION_WEAPON );
			}
		}
		else 
		{
			flag_clear( "fire_direction_shader_on" );
			
			level.str_weapon_last = str_weapon_current;
						
			level notify( "fire_direction_stop_weapon" );
		}
		
		wait 0.05;
	}
}

// waits till player has a weapon (for grenade throws, interacts, ect)
waittill_has_a_weapon() // self = player
{
	while( self GetCurrentWeapon() == "none" )
	{
		wait 1;
	}
}

_disable_weapon( str_weapon_last )
{
	self SwitchToWeapon( str_weapon_last );	

	// wait until fire/putdown anims are done, then remove weapon
	while ( self GetCurrentWeapon() == FIRE_DIRECTION_WEAPON )
	{
		wait 0.05;
	}
	
	self TakeWeapon( FIRE_DIRECTION_WEAPON );
}

//create model and display shader on it
_get_aim_model()
{
	m_aim = Spawn( "script_model", (0, 0, 0) );
	m_aim SetModel( "tag_origin" );
	m_aim.targetname = "m_fire_direction_aim_shader"; // set targetname so other functions can access it
	m_aim SetClientFlag( CLIENT_FLAG_OVERLAY ); // turn on shader
	
	return m_aim;
}

//get target area
_get_aim_postion()
{
	v_eye_pos = level.player geteye();	
	v_player_eye = level.player getPlayerAngles();
	v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
			
	v_trace_to_point = v_eye_pos + ( v_player_eye * AIM_RANGE );
	a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
			
	return a_trace["position"];
}

quadrotors_find_player_target()
{
	v_shoot_pos = _get_aim_postion();
	
	if( IsDefined( v_shoot_pos ) )
	{
		a_enemies = get_within_range( v_shoot_pos, GetAIArray( "axis" ), ENEMY_WITHIN_SHOOT_RADIUS );
		
		/#
			iprintln( "enemies within range = " + a_enemies.size );
		#/
		
		foreach ( e_shooter in level._fire_direction.a_shooters )
		{
			if ( IsDefined( e_shooter ) && IsAlive( e_shooter ) )
			{
				e_shooter thread _quadrotor_attacks_player_target( v_shoot_pos, a_enemies );
			}
		}
	}
}

_quadrotor_attacks_player_target( v_shoot_pos, a_enemies ) // self = quadrotor
{
	self endon( "death" );
	
	const FIRETIME = 7;
	
	self.radius = 16;
	self.goalpos = v_shoot_pos;

	v_shoot_pos = _get_aim_postion();
	
	if( a_enemies.size > 0 )
	{
		e_enemy = undefined;
		e_enemy = random( a_enemies );
	}
	
	self ClearTurretTarget();
	
	if( IsDefined( e_enemy ) )
	{	
		self VehSetEntityTarget( e_enemy );
		
		if( self VehCanSee( e_enemy ) )
		{
			self SetTurretTargetEnt( e_enemy, ( 0, 0, 0 ) );
			self.goalpos = e_enemy.origin;
		}
		else
		{
			self SetTurretTargetVec( v_shoot_pos );
		}
	}
	else
	{
		self SetTurretTargetVec( v_shoot_pos );	
	}
	
	self maps\_quadrotor::quadrotor_fire_for_time( FIRETIME );
	
	self VehClearEntityTarget( 1 );
	self ClearTurretTarget();
}
	
_get_units_to_fire( v_position )
{
	Assert( IsDefined( v_position ), "v_position missing for _get_closest_unit_to_fire" );
	Assert( IsDefined( level._fire_direction.a_shooters.size > 0 ), "no valid shooters found to use in _get_closest_unit_to_fire. Add these with add_fire_direction_shooter( <ent_that_can_shoot> ) first." );
	
	
	e_closest_shooter = GetClosest( v_position, level._fire_direction.a_shooters );
	
	return e_closest_shooter;
}

_is_target_area_valid()
{
	// TODO: logic for what's a valid target area and what isn't
	b_is_valid_area = true; 
	
	return b_is_valid_area;
}

_handle_shader()
{
	level endon( "_fire_direction_kill" );
	
	while ( true )
	{
		flag_wait( "fire_direction_shader_on" );
		// turn grid on
		ClientNotify( "grid_shader_on" );
		
		flag_waitopen( "fire_direction_shader_on" );
		// turn grid off
		ClientNotify( "grid_shader_off" );
	}
}

_hint_text()
{
	level endon( "_fire_direction_kill" );
	
	n_hints = 0;

	while( 1 )
	{
		level._fire_direction.hint_active = true;
			
		if( n_hints == 0 )
		{
			if ( level.wiiu )
			{
				LUINotifyEvent( &"hud_update_visor_text", 1, istring( "SCRIPT_FIRE_DIRECTION_WIIU" ) );
				//screen_message_create( &"SCRIPT_FIRE_DIRECTION_WIIU" );
			}
			else
			{
				LUINotifyEvent( &"hud_update_visor_text", 1, istring( "SCRIPT_FIRE_DIRECTION" ) );
				//screen_message_create( &"SCRIPT_FIRE_DIRECTION" );
			}
			n_hints++;
			level thread _hint_text_timeout();
		}
			
		flag_wait( "fire_direction_shader_on" );
		
		if( n_hints == 1 )
		{		
			LUINotifyEvent( &"hud_update_visor_text", 1, istring( "SCRIPT_FIRE_DIRECTION_CONFIRM" ) );
			//screen_message_create( &"SCRIPT_FIRE_DIRECTION_CONFIRM" );
		}
			
		level waittill_either( "fire_direction_stop_weapon", "fire_direction_stop_hint" );
		
		if( flag( "fire_direction_target_confirmed" ) )
		{
			screen_message_delete();
			break;
		}
		
		level._fire_direction.hint_active = false;
		screen_message_delete();
		
		if( n_hints < 1 )
		{
			wait COOLDOWN_TIME;
		}
		else
		{
			wait 1;
		}	
	}

}

//Have the text go away after a certain amount of time if the player does nothing - PRESS DEMO, but we probably want to keep this anyway - CP 4/9/12
_hint_text_timeout()
{
	level endon( "fire_direction_shader_on" );
	
	wait 6;
	
	screen_message_delete();
}
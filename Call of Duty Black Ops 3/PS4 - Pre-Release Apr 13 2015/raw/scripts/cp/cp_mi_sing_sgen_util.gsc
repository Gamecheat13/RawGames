#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\clientfield_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace sgen_util;

#precache( "rumble", "cp_sgen_flood_earthquake_rumble" );

//
//	self is a trigger.
//	The trigger should target a script object that will move.
//	Parameters for trigger:
//		script_wait - amount of time in seconds to wait before acting.
//	Parameters for mover:
//		script_wait - amount of time in seconds to wait before acting.
function trig_mover()
{
	self endon( "death" );

	assert( isdefined( self.target ), "The trigger mover @ " + self.origin + " must target an entity to move" );
	a_mdl_movers = GetEntArray( self.target, "targetname" );

	self waittill( "trigger" );

	self util::script_wait();

	array::thread_all( a_mdl_movers, &start_mover );
}


//
//	self is a script mover that will move based on its parameters
//	Parameters for mover:
//		script_string - what will I do?  [ "move" OR "rotate" ]
//		script_wait - amount of time in seconds to wait before acting.

function start_mover()
{
	self util::script_wait();

	time = 0.5;
	if ( isdefined( self.script_float ) )
	{
		time = self.script_float;
	}

	if ( !isdefined( self.script_string ) )
	{
		self.script_string = "move";
	}


	switch( self.script_string )
	{
		case "rotate":
		if(isDefined(self.script_angles))
		{
			self RotateTo( self.script_angles, time, 0, 0 );
		}
		else if ( isdefined( self.script_int ) )
		{
			self RotateYaw( self.script_int, time, 0, 0 );
		}
		break;
		case "move":
		default:
		self SetMovingPlatformEnabled( true );
		if(isDefined(self.script_vector))
		{
			vector = self.script_vector;
			if ( time >= 0.5 )
			{
				self MoveTo( self.origin + self.script_vector, time, time * 0.25, time * 0.25 );
			}
			else
			{
				self MoveTo( self.origin + self.script_vector, time );
			}
		}
		else if ( isdefined( self.script_int ) )
		{
			self MoveZ( self.script_int, time, 0, 0 );
		}
		wait( time );

		self SetMovingPlatformEnabled( false );
		break;
	}
}

//
//	Track the nearest player
//	self is the robot head
function fake_head_track_player( n_range = 256 )
{
	self endon( "death" );
	self endon( "stop_head_track_player" );

	v_home_angles = self.angles;
	V_BASE_OFFSET = (270,90,180);	// This is the offset we need to get the model to face "forward"

	while ( IsDefined( self ) )
	{
		e_player = array::get_closest( self.origin, level.players, n_range );

		if ( !IsDefined( e_player ) )
		{
			//TODO Don't rotate unless you have to.
			if ( self.angles != v_home_angles )
			{
				self RotateTo( v_home_angles, 1.0 );
			}
			wait ( 1.0 );
			continue;
		}

		v_to_player = VectorToAngles( e_player.origin - self.origin );
		v_face_angles = (0, v_to_player[1], 0) + V_BASE_OFFSET;

		self RotateTo( v_face_angles, 0.5 );
		self waittill( "rotatedone" );
	}
}



//
//	Track the nearest player using head look
//	self is the ai
function head_track_closest_player( n_range = 512 )
{
	self endon( "death" );
	self endon( "stop_head_track_player" );

	while ( true )
	{
		e_player = array::get_closest( self.origin, level.players, n_range );

		if ( !IsDefined( e_player ) )
		{
			if ( isdefined( self.e_look_at ) )
			{
				self.e_look_at = undefined;
				self LookAtEntity();
			}
		}
		else
		{
			if ( !isdefined( self.e_look_at ) || self.e_look_at != e_player )
			{
				self.e_look_at = e_player;
				self LookAtEntity( self.e_look_at );
			}
		}
		wait( 1.0 );
	}
}


function do_in_order( func1, param1, func2, param2 )
{
	if ( IsDefined( param1 ) )
	{
		[[ func1 ]]( param1 );
	}
	else
	{
		[[ func1 ]]();
	}

	if ( IsDefined( param2 ) )
	{
		[[ func2 ]]( param2 );
	}
	else
	{
		[[ func2 ]]();
	}
}


//grab all the dead bodies and delete them.
//making sure there isn't multiple function running.
function delete_corpse()
{
	self notify( "deleting_corpse");
	self endon( "deleting_corpse");

	while(1)
	{
		a_bodies = GetCorpseArray();
		foreach( corpse in a_bodies )
		{
			if(isdefined( corpse ) )
			{
				corpse delete();
			}
		}

		wait(10);
	}
}

// self == trigger
function gather_point_wait( should_delete, a_ai )
{
	if ( !IsDefined( a_ai ) )
	{
		a_ai = [];
	}

	while ( true )
	{
		n_player_ready = 0;
		n_ai_ready = 0;

		foreach ( player in level.players )
		{
			if ( player IsTouching( self ) )
			{
				n_player_ready++;
			}
		}

		foreach ( ai in a_ai )
		{
			if ( ai IsTouching( self ) )
			{
				n_ai_ready++;
			}
		}

		if ( n_player_ready == level.players.size && n_ai_ready == a_ai.size )
		{
			if ( ( isdefined( should_delete ) && should_delete ) )
			{
				self util::self_delete();
			}

			break;
		}

		wait ( 0.1 );
	}
}

// Util
function print3ddraw( org, text, color, str_notify ) // Throwaway temp function for testing since _debug.gsc didn't have one
{
	/#

	if ( IsDefined( str_notify ) )
	{
		self endon( str_notify );
	}

	while ( true )
	{
		if ( IsDefined( self ) && IsDefined( self.origin ) )
		{
			org = self.origin;
		}

		Print3D( org, text, color );

		wait ( 0.05 );
	}

	#/
}

// self == ai
function robot_init_mind_control( n_level )
{
	switch ( n_level )
	{
		case 1:
		{
			self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
		} break;
		case 2:
		{
			self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
		} break;
		case 3:
		{
			self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
		} break;
	}

	n_rand = RandomInt( 5 );

	if ( n_rand == 0 )
	{
		self ai::set_behavior_attribute( "rogue_control_speed", "walk" );
	}
	else if ( n_rand == 1 )
	{
		self ai::set_behavior_attribute( "rogue_control_speed", "run" );
	}
	else
	{
		self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
	}
}

//
//	Make Hendricks play an idle scene.	Wait for him to reach and then wait for the end flag
//	Function blocks until Hendricks reaches the start pos.
//	set b_pause_at_end to false if you want to play another scene immediately
function hendricks_play_idle( str_scene_struct, str_end_flag, b_pause_at_end = TRUE )
{
	s_scene = struct::get( str_scene_struct );
	s_scene thread scene::play( level.ai_hendricks ); //do reach must be initted now

	level.ai_hendricks waittill( "goal" );

	level flag::wait_till( str_end_flag );

	s_scene scene::stop();
}

// self == ScriptBundle "doors"
function set_door_state( str_name, str_state )
{
	a_s_doors = struct::get_array( str_name, "targetname" );

	if ( IsDefined( a_s_doors ) && a_s_doors.size > 0 )
	{
		foreach ( s_door in a_s_doors )
		{
			if ( ( str_state === "open" ) )
			{
				[[ s_door.c_door ]]->unlock();
				[[ s_door.c_door ]]->open();
			}
			else
			{
				[[ s_door.c_door ]]->close();
				[[ s_door.c_door ]]->lock();
			}
		}
	}
}

// self == script_brushmodel / script_model
function door_move( v_units, n_time )
{
	self PlaySound( "evt_door_close_start" );
	self PlayLoopSound( "evt_door_close_loop", 0.5 );

	self MoveTo( self.origin + v_units, n_time, n_time * 0.1, n_time * 0.25 );

	self waittill( "movedone" );

	self PlaySound( "evt_door_close_stop" );
	self StopLoopSound( 0.4 );
}

// self == trigger
function stumble_trigger_think()
{
	level endon( "skip_stumble_trigger_think" );

	self waittill( "trigger", e_player );

	level quake( 0.2, 2, self.origin, 5000 );
}

function quake( n_mag, n_duration, v_org, n_range = 5000, n_shock_min = 1, n_shock_max = ( n_shock_min + 2 ), str_rumble = "cp_sgen_flood_earthquake_rumble" )
{
	e_player = array::random( level.players );

	v_pos = math::random_vector( 1700 );
	PlayRumbleOnPosition( str_rumble, e_player.origin + v_pos );

	Earthquake( n_mag, n_duration, v_org, n_range );

	if ( n_mag >= 3 )
	{
		foreach ( player in level.players )
		{
			player notify( "new_quake" );

			visionset_mgr::activate( "overlay", "earthquake_blur", player, 0.25 );
			player util::delay( n_duration + 3, "new_quake", &visionset_mgr::deactivate, "overlay", "earthquake_blur", player );

			// TODO: Different strength shocks
			player ShellShock( "tankblast_mp", RandomFloatRange( n_shock_min, n_shock_max ) );
		}
	}

	v_angles = ( RandomInt( 360 ), RandomInt( 360 ), RandomInt( 360 ) );
	v_forward = AnglesToForward( v_angles );
	n_range = RandomFloatRange( 500, 1000 );
	v_location = e_player.origin + v_forward * n_range;
	PlaySoundAtPosition( "evt_base_explo_deep", v_location );
}

function get_players_center()
{
	v_origin = ( 0, 0, 0 );

	foreach( player in level.players )
	{
		v_origin += player.origin;
	}

	return ( v_origin / level.players.size );
}


//
//	Slows down movement to make robots appear to be moving underwater
//	self is a robot
function robot_underwater_callback()
{
	e_volume = GetEnt( "under_water_fan_volume", "targetname" );

	self.skipdeath = true;
	self asmsetanimationrate( 0.7 );

	self waittill( "death" );

	if( isdefined( self ) && !self IsTouching( e_volume ) )
	{
		self StartRagdoll();
	}
}

function rename_coop_spawn_points( str_name, str_new_name )
{
	a_s_spawnpoints = struct::get_array( "cp_coop_spawn", "targetname" );
	
	foreach ( s_spawnpoint in a_s_spawnpoints )
	{
		if ( ( s_spawnpoint.script_objective === str_name ) )
		{
			s_spawnpoint.script_objective = str_new_name;
		}
	}
}

// Move an entity to the underwater section of the map so things are seamless
function teleport_to_underwater()
{	
	if ( IsAI( self ) )
	{
		self ForceTeleport( self.origin + level.v_underwater_offset, self.angles );
	}
	else
	{
		self.origin = self.origin + level.v_underwater_offset;
	}
}


//	stop a scene if it's active
function scene_stop_if_active( str_scene )
{
	if ( scene::is_active( str_scene ) )
	{
		scene::stop( str_scene );
	}
}

function robot_eye_fx_on()
{	
	self clientfield::set( "robot_eye_fx", 1 );
}


function player_stick( b_look = false, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )
{
    self.m_link = Spawn( "script_model", self.origin );
    self.m_link.angles = self.angles;
    self.m_link SetModel( "tag_origin" );
    
    self AllowSprint( false );
    
    if ( b_look )
    {
        self PlayerLinkToDelta( self.m_link, "tag_origin", 1, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom, true );
    }
    else
    {
        self PlayerLinkToAbsolute( self.m_link, "tag_origin" );
    }
}

//
//    Allow the player to move freely after a player_stick
//    self is the player
function player_unstick()
{
    if ( IsDefined( self.m_link ) )
    {
        self.m_link Delete();
        self AllowSprint( true );
    }
}

function round_up_to_ten( n_value )
{
	n_new_value = n_value - n_value % 10;

	if( n_new_value < n_value )
	{
		n_new_value += 10;
	}

	return n_new_value;
}

function add_notetrack_custom_function( str_anim, str_notetrack, func_callback, is_loop )
{	
	if ( self != level )
	{
		self endon( "death" );
	}

	level flagsys::wait_till( str_anim + "_playing" );

	do
	{
		str_notify = self util::waittill_any_return( str_notetrack, str_anim + "_playing" );

		if ( str_notify == str_notetrack )
		{
			self thread [[ func_callback ]]();
		}

	} while ( ( isdefined( is_loop ) && is_loop ) && level flagsys::get( str_anim + "_playing" ) );
}

function fade_in()
{
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.0, 0.5 );
}

function fade_out()
{
	array::thread_all( level.players, &util::screen_fade_to_alpha, 1.0, 0.5 );
}

function coop_teleport_on_igc_end( str_scene, str_teleport_name )
{
	Assert( IsDefined( str_scene ), "str_scene is undefined" );
	Assert( IsDefined( str_teleport_name ), "str_teleport_name is undefined" );

	scene::add_scene_func( str_scene, &teleport_coop_players_on_scene_done, "play" );

	level thread wait_for_scene_done( str_scene, str_teleport_name );
}

function teleport_coop_players_on_scene_done( a_ents )
{
	a_keys = GetArrayKeys( a_ents );
	str_scene = a_ents[ a_keys[ 0 ] ]._o_scene._str_name;

	self waittill( "scene_done" );

	level notify( str_scene + "_done" );
}

function wait_for_scene_done( str_scene, str_teleport_name )
{
	level waittill( str_scene + "_done" );

	util::teleport_players_igc( str_teleport_name );		
}

function setup_mappy_path( n_enable = 1 )
{
	a_e_path = GetEntArray( "mappy_trail_geo", "targetname" );
	foreach( e_path in a_e_path )
	{
		e_path clientfield::set( "mappy_path", n_enable );
	}
}

function ammo_crates_toggle( str_state = "on" )
{
	a_e_crates = GetEntArray( "ammo_cache", "script_noteworthy" );

	foreach ( e_crate in a_e_crates )
	{
		if ( str_state == "on" )
		{
			Objective_OnEntity( e_crate.gameobject.objectiveid, e_crate.gameobject );
		}
		else
		{
			Objective_ClearEntity( e_crate.gameobject.objectiveid );
		}
	}
}

function get_num_scaled_by_player_count( n_base, n_add_per_player )
{
	n_num = n_base - n_add_per_player;
	foreach( e_player in level.players )
	{
		n_num += n_add_per_player;
	}
	
	return n_num;
}

function hotjoin_disable()
{
	level.gametypeSpawnWaiter_old = level.gametypeSpawnWaiter;
	level.gametypeSpawnWaiter = &wait_to_spawn;
}

function hotjoin_enable()
{
	Assert( IsDefined( level.gametypeSpawnWaiter_old ) );
	level.gametypeSpawnWaiter = level.gametypeSpawnWaiter_old;

	level notify( "hotjoin_enabled" );
}

function wait_to_spawn()
{
	level util::waittill_either( "objective_changed", "hotjoin_enabled" );

	return true;
}

function igc_begin()
{
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( true );
		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
		e_player DisableWeapons();
	}
}

function igc_end()
{
	foreach ( e_player in level.players )
	{
		e_player Freezecontrols( false );
		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
		e_player EnableWeapons();
	}
}

function refill_ammo()
{
	a_w_weapons = self GetWeaponsList();

	foreach ( w_weapon in a_w_weapons )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}
}
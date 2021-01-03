                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_zod_util;

 // 100 * 100
	


function autoexec __init__sytem__() {     system::register("zm_zod_util",&__init__,&__main__,undefined);    }
	
function __init__()
{
	// Create a pool of tag_origin models to prevent network traffic when creating fx.
	level.tag_origin_pool = [];
}

function __main__()
{
	// Set up any callbacks that were requested before the spawners were initialized.
	//
	assert( isdefined(level.zombie_spawners) );
	if ( isdefined( level.zombie_spawn_callbacks ) )
	{
		foreach( fn in level.zombie_spawn_callbacks )
		{
			add_zod_zombie_spawn_func( fn );
		}
	}
	level.zombie_spawn_callbacks = undefined;
	add_zod_zombie_spawn_func( &watch_zombie_death );
	callback::on_connect( &on_player_connect );
	level.teleport_positions = struct::get_array( "teleport_position" );
}

// Allocate a tag origin from the unified pool.
//
// -- increases likelihood of reusing an existing tag origin instead of spawning more.
// -- should not be deleted directly.  Use tag_origin_free.
//
function tag_origin_allocate( v_pos, v_angles )
{
	if ( level.tag_origin_pool.size == 0 )
	{
		e_model = util::spawn_model( "tag_origin", v_pos, v_angles );
		return e_model;
	}
	else
	{
		n_index = level.tag_origin_pool.size-1;
		e_model = level.tag_origin_pool[ n_index ];
		ArrayRemoveIndex( level.tag_origin_pool, n_index );
		e_model.angles = v_angles;
		e_model.origin = v_pos;
		e_model notify( "reallocated_from_pool" );
		return e_model;
	}
}

// Free a tag origin back into the unified pool to be reused.
//
function tag_origin_free()
{
	if ( !isdefined( level.tag_origin_pool ) ) level.tag_origin_pool = []; else if ( !IsArray( level.tag_origin_pool ) ) level.tag_origin_pool = array( level.tag_origin_pool ); level.tag_origin_pool[level.tag_origin_pool.size]=self;;
	self thread tag_origin_expire();
}

function private tag_origin_expire()
{
	self endon( "reallocated_from_pool" );
	wait 20.0;
	ArrayRemoveValue( level.tag_origin_pool, self );
	self Delete();
}

//  Make sure this is a solo game (no hot join)
//	Returns true if we start solo and no one can ever join this game
function check_solo_status()
{
	//  ( Not Online game || Not Private ) 
	if ( GetNumExpectedPlayers() == 1 && ( !SessionModeIsOnlineGame() || !SessionModeIsPrivate() ) )
	{
		level.is_forever_solo_game = true;
	}
	else
	{
		level.is_forever_solo_game = false;
	}
}

function private watch_zombie_death()
{
	self waittill( "death" );
	if ( isdefined( self ) )
	{
		if ( isdefined( level.zombie_death_callbacks ) )
		{
			foreach( fn_callback in level.zombie_death_callbacks )
			{
				self thread [[fn_callback]]();
			}
		}
	}
}

function vec_to_string( v )
{
	return "<" + v[0] + ", " + v[1] + ", " + v[2] + ">";
}

function zod_unitrigger_assess_visibility( player )
{
	b_visible = true;
	if ( ( isdefined( player.beastmode ) && player.beastmode ) && !( isdefined( self.allow_beastmode ) && self.allow_beastmode ) )
	{
		b_visible = false;
	}
	else if ( isdefined( self.stub.func_unitrigger_visible ) )
	{
		b_visible = self [[self.stub.func_unitrigger_visible]]( player );
	}
	
	str_msg = &"";
	param1 = undefined;
	if ( b_visible )
	{
		if ( isdefined( self.stub.func_unitrigger_message ) )
		{
			str_msg = self [[self.stub.func_unitrigger_message]]( player );
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	
	if ( isdefined( param1 ) )
	{
		self SetHintString( str_msg, param1 );
	}
	else
	{
		self SetHintString( str_msg );
	}
	
	return b_visible;
}

// self == unitrigger stub.
//
function unitrigger_refresh_message()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

function unitrigger_allow_beastmode()
{
	self.allow_beastmode = true;
}

function private unitrigger_think()
{
	self endon("kill_trigger");

	self.stub thread unitrigger_refresh_message();

	while ( 1 )
	{
		self waittill( "trigger", player );
	
		// pass the notify along to the stub.
		if ( ( isdefined( self.allow_beastmode ) && self.allow_beastmode ) || !( isdefined( player.beastmode ) && player.beastmode ) )
		{
			self.stub notify( "trigger", player );
		}
	}
}

function teleport_player( struct_targetname )
{
	assert(isdefined( struct_targetname ) );
	
	a_dest = struct::get_array( struct_targetname, "targetname" );
	if ( a_dest.size == 0 )
	{
		/#
			AssertMsg( "zm_zod_util::teleport sent bad teleport node name, \"" + struct_targetname + "\"." );
		#/
		return;
	}
	
	v_dest_origin = a_dest[0].origin;
	v_dest_angles = a_dest[0].angles;
	b_valid_found = false;
	
	e_teleport = zm_zod_util::tag_origin_allocate( self.origin, self.angles );
	self PlayerLinkToAbsolute( e_teleport, "tag_origin" );
	e_teleport.origin = level.teleport_positions[ self.characterIndex ].origin;
	e_teleport.angles = level.teleport_positions[ self.characterIndex ].angles;
	self FreezeControls( true );
	self DisableWeapons();
	self DisableOffhandWeapons();
	wait 2.0;
	
	// Find a position that doesn't conflict with another player's location.
	foreach ( s_dest in a_dest )
	{
		foreach( e_player in level.players )
		{
			if ( Distance2DSquared( e_player.origin, s_dest.origin ) > 10000 )
			{
				b_valid_found = true;
				v_dest_origin = s_dest.origin;
				v_dest_angles = s_dest.angles;
				break;
			}
		}
		
		if ( b_valid_found )
		{
			break;
		}
	}
	
	e_teleport.origin = v_dest_origin;
	e_teleport.angles = v_dest_angles;
	wait 0.5;
	self Unlink();
	e_teleport zm_zod_util::tag_origin_free();
	self FreezeControls( false );
	self EnableWeapons();
	self EnableOffhandWeapons();
}

function set_unitrigger_hint_string( str_message, param1 )
{
	self.hint_string = str_message;
	self.hint_parm1 = param1;
	
	// Re-register the unitrigger so the message updates.
	//
	zm_unitrigger::unregister_unitrigger( self );
	zm_unitrigger::register_unitrigger( self, &unitrigger_think );
}

function private spawn_unitrigger( origin, angles, radius_or_dims, use_trigger = false, func_per_player_msg )
{	
	trigger_stub = SpawnStruct();
	trigger_stub.origin = origin;
	
	str_type = "unitrigger_radius";
	if ( IsVec( radius_or_dims ) )
	{
		trigger_stub.script_length = radius_or_dims[0];
		trigger_stub.script_width = radius_or_dims[1];
		trigger_stub.script_height = radius_or_dims[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))angles=(0,0,0);
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = radius_or_dims;
	}
	
	if ( use_trigger )
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = str_type + "_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = str_type;
	}
	
	if ( isdefined( func_per_player_msg ) )
	{
		trigger_stub.func_unitrigger_message = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers( trigger_stub, true );
	}
	
	trigger_stub.prompt_and_visibility_func = &zod_unitrigger_assess_visibility;

	zm_unitrigger::register_unitrigger( trigger_stub, &unitrigger_think );
	
	return trigger_stub;
}

function spawn_trigger_radius( origin, radius, use_trigger = false, func_per_player_msg )
{
	return spawn_unitrigger( origin, undefined, radius, use_trigger, func_per_player_msg );
}

function spawn_trigger_box( origin, angles, dims, use_trigger = false, func_per_player_msg )
{
	return spawn_unitrigger( origin, angles, dims, use_trigger, func_per_player_msg );
}

function add_zod_zombie_spawn_func( fn_zombie_spawned )
{
	if ( !isdefined( level.zombie_spawners ) )
	{
		if ( !isdefined( level.zombie_spawn_callbacks ) )
		{
			level.zombie_spawn_callbacks = [];
		}
		if ( !isdefined( level.zombie_spawn_callbacks ) ) level.zombie_spawn_callbacks = []; else if ( !IsArray( level.zombie_spawn_callbacks ) ) level.zombie_spawn_callbacks = array( level.zombie_spawn_callbacks ); level.zombie_spawn_callbacks[level.zombie_spawn_callbacks.size]=fn_zombie_spawned;;
	}
	else
	{
		array::thread_all(level.zombie_spawners, &spawner::add_spawn_function,  fn_zombie_spawned );
		
		// Handle the ritual spawners.
		//
		a_ritual_spawners = GetEntArray( "ritual_zombie_spawner", "targetname" ); // get the special ritual spawner
		array::thread_all(a_ritual_spawners, &spawner::add_spawn_function,  fn_zombie_spawned );
	}
}

function on_player_connect()	
{
	self endon( "disconnect" );
	while ( true )
	{
		self waittill( "bled_out" );
		if ( isdefined( level.bled_out_callbacks ) )
		{
			foreach( fn in level.bled_out_callbacks )
			{
				self thread [[fn]]();
			}
		}
	}
}

function on_zombie_killed( fn_zombie_killed )
{
	if ( !isdefined( level.zombie_death_callbacks ) )
	{
		level.zombie_death_callbacks = [];
	}
	
	if ( !isdefined( level.zombie_death_callbacks ) ) level.zombie_death_callbacks = []; else if ( !IsArray( level.zombie_death_callbacks ) ) level.zombie_death_callbacks = array( level.zombie_death_callbacks ); level.zombie_death_callbacks[level.zombie_death_callbacks.size]=fn_zombie_killed;;
}

function on_player_bled_out( fn_callback )
{
	if ( !isdefined( level.bled_out_callbacks ) )
	{
		level.bled_out_callbacks = [];
	}
	
	if ( !isdefined( level.bled_out_callbacks ) ) level.bled_out_callbacks = []; else if ( !IsArray( level.bled_out_callbacks ) ) level.bled_out_callbacks = array( level.bled_out_callbacks ); level.bled_out_callbacks[level.bled_out_callbacks.size]=fn_callback;;
}

//
// RUMBLE
//

// self = player to play the rumble on
// n_rumbletype = the DEFINE from zm_zod.gsh with the desired rumble setting
function set_rumble_to_player( n_rumbletype )
{
	// stop ritual rumble
	self thread clientfield::set_to_player( "player_rumble_and_shake", n_rumbletype );
}

//
// DEVGUI
//

// associates a function with a given devgui string, dvar, and value
// calls the function when that dvar is set, then resets the dvar to its base value
// the value input is passed through to the target function
// (base value can optionally be set, but is -1 by default)
function setup_devgui_func( str_devgui_path, str_dvar, n_value, func, n_base_value )
{
	if( !isdefined( n_base_value ) )
	{
		n_base_value = -1;
	}
	
	SetDvar( str_dvar, n_base_value );

	AddDebugCommand( "devgui_cmd \"" + str_devgui_path + "\" \"" + str_dvar + " " + n_value + "\"\n" );
	
	// now watch the dvar
	while ( true )
	{
		n_dvar = GetDvarInt( str_dvar );
		if ( n_dvar > n_base_value )
		{
			// call the target func, then reset the dvar
			[[ func ]]( n_dvar );
			SetDvar( str_dvar, n_base_value );
		}
		
		util::wait_network_frame();
	}
}

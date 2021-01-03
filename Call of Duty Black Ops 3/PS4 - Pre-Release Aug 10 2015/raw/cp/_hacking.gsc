#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\load_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\gameobjects_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\cybercom\_cybercom_util;
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#namespace hacking;

#precache( "lui_menu", "HackingHUD" );
#precache( "lui_menu_data", "HackingProgress" );
#precache( "lui_menu_data", "HackingVisibleFPP" );
#precache( "lui_menu_data", "HackingVisibleTPP" );
#precache( "objective", "cp_hacking" );

function autoexec __init__sytem__() {     system::register("hacking",&__init__,undefined,undefined);    }

function __init__()
{
	level.hacking = SpawnStruct();
	level.hacking flag::init( "in_progress" );
}

// DEPRECATED: this is only here for sgen's script hack. we should really remove it and make it consistant with other levels by using init_hack_trigger.
function hack( n_hacking_time, e_hacking_player )
{
	onBeginUse( e_hacking_player );
	wait( n_hacking_time );
	onEndUse( undefined, e_hacking_player, true );
}

// Sets up a player-usable hacking trigger which upon completion will trigger a notify.
// Parameters:
// 		- [ n_hacking_time ]: time in seconds that the hack should last.
//		- [ str_objective ]: objective type.
//		- [ str_hint_text ]: Hint text to appear when you're close.
//		- [ func_after_use ]: The function to call after player hacks, if given.
// upon completion the notify "trigger_hack" will be sent.
//
// self == trigger
function init_hack_trigger( n_hacking_time = 0.5, str_objective = &"cp_hacking", str_hint_text, func_when_used, a_keyline_objects )
{
	if (isdefined ( str_hint_text ))
	{
		self SetHintString( str_hint_text );
	}
	self SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
	
	if( !isdefined( a_keyline_objects ) )
	{
		a_keyline_objects = [];
	}
	else
	{
		if ( !isdefined( a_keyline_objects ) ) a_keyline_objects = []; else if ( !IsArray( a_keyline_objects ) ) a_keyline_objects = array( a_keyline_objects );;
		
		foreach( mdl in a_keyline_objects )
		{
			mdl oed::enable_keyline( true );
		}
	}
		
	visuals = [];
	game_object = gameobjects::create_use_object( "any", self, visuals, ( 0, 0, 0 ), &"cp_hacking" );
	game_object gameobjects::allow_use( "any" );
	game_object gameobjects::set_use_time( n_hacking_time );
	game_object gameobjects::set_owner_team( "allies" );
	game_object gameobjects::set_visible_team( "any" );
	game_object.onUse = &onUse;
	game_object.onBeginUse = &onBeginUse;
	game_object.onEndUse = &onEndUse;
	game_object.func_when_used = func_when_used;
	game_object.keepWeapon = true;
	
	return game_object;
}

// Wait for a hacking trigger to finish its hacking
//
// self == trigger
// returns the player who performed the hack.
//
function trigger_wait()
{
	self waittill( "trigger_hack", e_who );
	return e_who;
}

function onBeginUse( player )
{
	if ( isdefined( player ) )
	{
		level.hacking flag::set( "in_progress" );
		player cybercom::cyberCom_armPulse(1);
		player clientfield::increment_to_player( "active_dni_fx" );
		player thread scene::play( "cin_gen_player_hack_start", player );
		player clientfield::set_to_player( "sndCCHacking", 1 );
	}
}

function onEndUse( team, player, result )
{
	if ( isdefined( player ) )
	{
		level.hacking flag::clear( "in_progress" );
		player clientfield::set_to_player( "sndCCHacking", 0 );
		player scene::play( "cin_gen_player_hack_finish", player );
	}
}

function onUse( player )
{
	if ( isdefined( player ) )
	{
		level notify( "hacking_complete", true, player );
		self.trigger notify( "trigger_hack", player );
	}

	if ( isdefined( self.func_when_used ))
	{
		[[ self.func_when_used ]](); 
	}

	// single use
	Objective_ClearEntity( self.objectiveID );
	self gameobjects::destroy_object( true, undefined, true );
}
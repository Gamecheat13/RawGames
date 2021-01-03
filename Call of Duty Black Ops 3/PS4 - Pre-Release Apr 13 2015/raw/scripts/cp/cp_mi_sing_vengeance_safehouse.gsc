#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\math_shared;
#using scripts\shared\turret_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;

#using scripts\cp\_debug;
#using scripts\cp\sidemissions\_sm_ui;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_safehouse;

/*****************************************
 * -- Safehouse Interior --
 * ***************************************/

function skipto_safe_int_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::init_hero( "hendricks", str_objective );
		
		level flag::wait_till( "all_players_spawned" );
	}	
	
	if ( isdefined( level.stealth ))
	{
		level stealth::stop();
	}
	
	spawner::add_spawn_function_group( "rambo" , "script_noteworthy" , &rambo_robots );
	spawner::add_spawn_function_group( "sniper" , "script_noteworthy" , &sniper_robots );
	
	safehouse_int_main();
}

function skipto_safe_int_done( str_objective, b_starting, b_direct, player )
{
	a_enemies = GetAITeamArray( "axis" );
	
	if ( isdefined( a_enemies ) )
	{
		foreach ( e_enemy in a_enemies ) 
		{
			if ( isdefined( e_enemy ) )
				e_enemy Delete();
		}
	}	
}

function safehouse_int_main()
{
	obj_trigger = getent( "obj_enter_tunnel", "targetname" );
	obj_struct = struct::get( obj_trigger.target, "targetname" );
	objectives::set( "cp_level_vengeance_enter_safehouse", obj_struct );
	
	trigger::wait_till( "players_near_safehouse", "targetname" );

//	level thread safehouse_ext_vo();
	
	s_anim_struct = struct::get( "safehouse_entrance_script_node", "targetname" );
	s_anim_struct scene::play( "cin_ven_08_10_reachsafehouse_3rd_sh010" );               
	
//	a_players = GetPlayers();
//	foreach( e_player in a_players )
//	{
//		e_player Freezecontrols( true );
//		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
//	}	
//	
//	text_array = [];
//	text_array[ 0 ] = "As the players near the safehouse, a large";
//	text_array[ 1 ] = "explosion shakes the building.  This leads";
//	text_array[ 2 ] = "to an IGC where Hendricks refuses to go in,";
//	text_array[ 3 ] = "believing Kayne to be dead.";
//	
//	level debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined );
//
//	foreach( e_player in a_players )
//	{
//		e_player Freezecontrols( false );
//		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
//	}	
	
	a_safehouse_doors = GetEntArray( "safehouse_ext_door", "targetname" );
	a_safehouse_door_clip = getent( "safehouse_ext_door_clip", "targetname" );
	
	array::delete_all( a_safehouse_doors );
	a_safehouse_door_clip delete();
	
	trigger::wait_till( "players_at_safehouse", "targetname" );
	objectives::complete( "cp_level_vengeance_enter_safehouse" );
	
	level thread safehouse_int_enemies();
		
	trig = getent( "obj_safehouse_int", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	objectives::set( "cp_level_vengeance_locate_kayne", trig.objective_target );
	
	trigger::wait_till( "obj_safehouse_int", "targetname" );
	
	if ( isdefined( trig ) )
	{
		objectives::complete( "cp_level_vengeance_locate_kayne", trig.objective_target );
	}
	
	skipto::objective_completed( "safehouse_interior" );
}

function safehouse_ext_vo()
{
	// Shit...
	level.ai_hendricks dialog::say( "Hendricks: Shit..." );
	//Kayne, do you read me?
	level.players[ 0 ] dialog::say( "Player: Kayne, do you read me?" );
	
	wait 2;
	//Kayne, come in!
	level.players[ 0 ] dialog::say( "Player: Kayne, come in!" );

	wait 2;
	//There’s no way anyone survived that blast.  Let’s go.
	level.ai_hendricks dialog::say( "Hendricks: There’s no way anyone survived that blast.  Let’s go." );
	//She could still be alive...
	level.players[ 0 ] dialog::say( "Player: She could still be alive..." );
	//Kayne is dead!  I'm not risking my neck for CIA!
	level.ai_hendricks dialog::say( "Hendricks: Kayne is dead!  I'm not risking my neck for CIA!" );
	//Just give me 5 minutes.
	level.players[ 0 ] dialog::say( "Player: Just give me 5 minutes!" );
	//5 minutes that’s it.  I’ll find us transport.
	level.ai_hendricks dialog::say( "Hendricks: 5 minutes that’s it.  I’ll find us transport." );
}

function safehouse_int_vo()
{
	trigger::wait_till( "spawn_safehouse_wave_2" );
	//Hendricks (radio) – Hurry it up, you don't have much time!
	level dialog::remote( "Hendricks: – Hurry it up, you don't have much time!" );
	
	trigger::wait_till( "spawn_safehouse_wave_3" );	
	//Hendricks (radio) – Come on, time is short!
	level dialog::remote( "Hendricks: – Come on, time is short!" );
	
	trigger::wait_till( "obj_safehouse_int" );
	//Hendricks (radio) – We need to go, meet me out front.
	level dialog::remote( "Hendricks: – We need to go, meet me out front." );
	//Player (radio) – I'm at the panic room.  Give me a sec...
	level dialog::remote( "Player: I'm at the panic room.  Give me a sec..." );

}

function safehouse_int_enemies()
{
	spawn_manager::enable( "safehouse_wave1_normal" );
	spawn_manager::enable( "safehouse_wave1_rambo" );
	
	trigger::wait_till( "spawn_safehouse_wave_1a", "targetname" );
	spawn_manager::enable( "safehouse_wave1a_normal" );
	spawn_manager::enable( "safehouse_wave1a_rambo" );
	
	trigger::wait_till( "spawn_safehouse_wave_2", "targetname" );
	spawner::simple_spawn( "safehouse_robots_wave_2" );
	
	trigger::wait_till( "spawn_safehouse_wave_2a", "targetname" );
	spawner::simple_spawn( "safehouse_robots_wave_2a" );
	
	level dialog::remote( "Hendricks: Have you found Kayne yet?  We can't stay here much longer.", 0 );
	
	trigger::wait_till( "spawn_safehouse_wave_3", "targetname" );
	spawn_manager::enable( "safehouse_robots_wave_3" );
	
	trigger::wait_till( "spawn_panic_room", "targetname" );
	spawner::simple_spawn( "panic_room_robots" );
}

function rambo_robots()
{
	self ai::set_behavior_attribute( "sprint", true );
	
	self waittill( "goal" );
	
	a_players = GetPlayers();
	closest_player = array::get_closest( self.origin, a_players );
	
	self setgoal( closest_player.origin );
	
	self ai::set_behavior_attribute( "move_mode", "rambo" );
}

function sniper_robots()
{
	self.goalradius = 8;
}

/*****************************************
 * -- Panic Room Scene --
 * ***************************************/

function skipto_panic_init( str_objective, b_starting )
{
	if( b_starting )
	{
		if ( isdefined( level.stealth ))
		{
			level stealth::stop();
		}	
	}	
	
	level flag::wait_till( "all_players_spawned" );
	
	panic_main( str_objective );
}

function skipto_panic_done( str_objective, b_starting, b_direct, player )
{

}

function panic_main( str_objective )
{
	trig = getent( "obj_panic", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	objectives::set( "cp_level_vengeance_open_panic_room", trig.objective_target );
	
	trigger::wait_till( "obj_panic", "targetname" );
	
	if ( isdefined( trig ) )
	{
		objectives::complete( "cp_level_vengeance_open_panic_room", trig.objective_target );
	}
	
	a_playerlist = GetPlayers();
	foreach( e_player in a_playerlist )
	{
		e_player FreezeControls( true );
		e_player setclientuivisibilityflag( "hud_visible", 0 );
	}
	
	text_array = [];
	text_array[ 0 ] = "Kayne and Xiulan safehouse IGC";
	text_array[ 1 ] = "to be handled by Treyarch.";
	text_array[ 2 ] = "Kayne horrified by how player kills Xiulan.";
				
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, undefined );
	
	a_playerlist = GetPlayers();
	foreach( e_player in a_playerlist )
	{
		e_player FreezeControls( false );
		e_player setclientuivisibilityflag( "hud_visible", 1 );
	}
	
	skipto::objective_completed( "panic_room" );
}

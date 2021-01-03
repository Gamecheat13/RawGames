#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_ammo_cache;
#using scripts\shared\callbacks_shared;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\voice\voice_prologue;

#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\array_shared;
#using scripts\shared\turret_shared;
#using scripts\cp\_spawn_manager;

#using scripts\cp\_skipto;

#using scripts\cp\cp_prologue_intro;
#using scripts\cp\cp_prologue_enter_base;
#using scripts\cp\cp_prologue_security_camera;
#using scripts\cp\cp_prologue_hostage_rescue;
#using scripts\cp\cp_prologue_cyber_soldiers;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_robot_reveal;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_player_sacrifice;
#using scripts\cp\cp_prologue_ending;
#using scripts\cp\cp_prologue_util;

#namespace cp_mi_eth_prologue;

#precache( "lui_menu", "CACWaitMenu" );
#precache( "lui_menu", "APCTurretHUD" );

//***************************************************************************************
//***************************************************************************************

function main()
{
	init_clientfields();

	precache();

	SetDvar( "bullet_ricochetBaseChance", 0 );

	cp_mi_eth_prologue_fx::main();
	cp_mi_eth_prologue_sound::main();
	voice_prologue::init_voice();

	level.b_tactical_mode_enabled = false; 
	
	// Set lagacy mantles
	SetGameTypeSetting( "trm_maxHeight", 50.0 );
	
	level.disableClassSelection = 1;
	    
	level flag::init( "is_base_alerted" );
	level flag::init( "is_hendricks_at_bottom_of_tower" );
	level flag::init( "is_players_gathered_at_bottom_of_tower" );
	level flag::init( "player_setlowready" );
	level flag::init( "player_weapons_overridden" );
	level flag::init( "start_tower_collapse" );
	level flag::init("vtol_has_crashed");
	level flag::init( "players_are_in_apc" );	
	level flag::init( "pallas_at_window" );
	level.b_loadout_silenced = true;

	

	// Event 5
	level flag::init( "is_security_camera_alerted" );
	
	// Event 10
	level flag::init( "is_guy_alerted" );

	//defend event - TODO: clean up these flag inits, they should live in an prologue_global_init_flag func
	level flag::init( "robots_suppressed" );

	skipto::set_skip_safehouse();
	
	level thread setup_skiptos();
	
	callback::on_spawned( &on_player_spawned );
	callback::on_loadout( &on_player_loadout );

	load::main();

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass
}

function on_player_spawned()
{
	// self = player
	
	a_skiptos = skipto::get_current_skiptos();
	
	if ( IsDefined( a_skiptos ) )
	{		
		if ( a_skiptos[0] == "skipto_air_traffic_controller" )
		{
			self DisableWeapons();
			self SetClientUIVisibilityFlag( "hud_visible", 0 );
					
			if ( level.players.size > 1 )
			{	
				wait 0.5;  //need to wait a bit after player has spawned before opening menu, don't know why, this is temp anyway				
				self.wait_menu = self OpenLUIMenu( "CACWaitMenu" );  //TODO - temp until we have real CAC functionality for campaign
			}
			else
			{
				util::screen_fade_out( 0 );
				wait 0.5;
				util::screen_fade_in( 1 );
			}
		}
		else if ( a_skiptos[0] == "skipto_apc_rail" || a_skiptos[0] == "skipto_apc_rail_stall" )
		{
			v_apc = GetEnt("apc", "animname");
			for (i = 1; i < v_apc.player_turret_slots.size; i++) //skip the driver slot
			{
				//TODO: oh good lord fix this (workaround for the wonky loading APC loading script)
				switch( i )
				{
					case 1:
						i = 3;
					break;
					
					case 2:
						i = 1;		
					break;
			
					case 3:
						i = 4;
					break;
			
					case 4:
					default:
						i = 2;
					break;
				}	
				if (v_apc.player_turret_slots[i] == 0)
				{
					//TODO: check for and kick out AI
					self thread apc_shared::player_attach_to_apc(v_apc, i);
					break;
				}
			}
		}
		
	}
}

function on_player_loadout()
{
    self cybercom_gadget::takeAllAbilities();

    // Rigs
    self cybercom_tacrig::takeAllRigAbilities();
    
	self cp_prologue_util::give_player_weapons();
    
}


//***************************************************************************************
//***************************************************************************************

function init_clientfields()
{
	// Set the active extra cam
	clientfield::register( "world", "set_active_cam_index", 1, 3, "int" );


	// 0 = off, (1 to 7) = the seven cell feeds
	clientfield::register( "world", "set_cam_lookat_object", 1, 3, "int" );

	// 0 = off, 1 = on
	clientfield::register( "actor", "robot_eye_fx", 1, 1, "int" );

	// 1 = trigger the scene
	clientfield::register( "world", "apc_rail_tower_collapse",	1, 1, "int" );

	// Turn on/off multicam
	clientfield::register( "toplayer", "turn_on_multicam", 1, 3, "int" );
	
	// 0 = off, 1 = on
//	clientfield::register( "world", "light_lift_panel_red_on", VERSION_SHIP, 1, "int" );
//	clientfield::register( "world", "light_lift_panel_green_on", VERSION_SHIP, 1, "int" );
}


//***************************************************************************************
//***************************************************************************************

function precache()
{
	// DO ALL PRECACHING HERE
}


//***************************************************************************************
//***************************************************************************************

function setup_skiptos()
{
	skipto::add( "skipto_air_traffic_controller", &skipto_air_traffic_controller_init, "Air Traffic Controller", &skipto_air_traffic_controller_complete );
	skipto::add( "skipto_nrc_knocking", &skipto_nrc_knocking_init, "NRC Knocking", &skipto_nrc_knocking_complete );
	skipto::add( "skipto_blend_in", &skipto_blend_in_init, "Blend In", &skipto_blend_in_complete );
	skipto::add( "skipto_take_out_guards", &skipto_take_out_guards_init, "Take Out Guards", &skipto_take_out_guards_complete );

	skipto::add( "skipto_security_camera", &skipto_security_camera_init, "Security Camera", &skipto_security_camera_complete );
	skipto::add( "skipto_hostage_1", &skipto_hostage_1_init, "Fuel Depot", &skipto_hostage_1_complete );
	skipto::add( "skipto_prison", &skipto_prison_init, "Prison", &skipto_prison_complete );
	skipto::add( "skipto_security_desk", &skipto_security_desk_init, "Security Desk", &skipto_security_desk_complete );
	skipto::add( "skipto_lift_escape", &skipto_lift_escape_init, "Lift Escape", &skipto_lift_escape_complete );
	skipto::add( "skipto_intro_cyber_soldiers", &skipto_intro_cyber_soldiers_init, "Intro Cyber Soldiers", &skipto_intro_cyber_soldiers_complete );
		
	skipto::add( "skipto_hangar", &skipto_hangar_init, "Hangar", &skipto_hangar_complete );
	skipto::add( "skipto_vtol_collapse", &skipto_vtol_collapse_init, "VTOL Collapse", &skipto_vtol_collapse_complete );
	skipto::add( "skipto_jeep_alley", &skipto_jeep_alley_init, "Jeep Alley", &skipto_jeep_alley_complete );
	skipto::add( "skipto_bridge_battle", &skipto_bridge_battle_init, "Bridge Battle", &skipto_bridge_battle_complete );
	skipto::add( "skipto_dark_battle", &skipto_dark_battle_init, "Dark Battle", &skipto_dark_battle_complete );
	skipto::add( "skipto_vtol_tackle", &skipto_vtol_tackle_init, "Vtol Tackle", &skipto_vtol_tackle_complete );
	skipto::add( "skipto_robot_horde", &skipto_robot_horde_init, "Robot Horde", &skipto_robot_horde_complete );

	skipto::add( "skipto_apc", &skipto_apc_init, "APC", &skipto_apc_complete );
	skipto::add( "skipto_apc_rail", &skipto_apc_rail_init, "APC Rail", &skipto_apc_rail_complete );
	skipto::add( "skipto_apc_rail_stall", &skipto_apc_rail_stall_init, "APC Rail Stall", &skipto_apc_rail_stall_complete );
	skipto::add( "skipto_robot_defend", &skipto_robot_defend_init, "Robot Defend", &skipto_robot_defend_complete );
	skipto::add( "skipto_sky_hook", &skipto_sky_hook_init, "Sky Hook", &skipto_sky_hook_complete );
	skipto::add( "skipto_prologue_ending", &skipto_prologue_ending_init, "Player Prologue Ending", &skipto_prologue_ending_complete );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// Objectives:
//
// NOTE: In the init functions 
//			- restarting = 0 when called through progression
//			- restarting = 1 when called from a checkpoint restart
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
// skipto air_traffic_controller
// Event 1
//*****************************************************************************

function skipto_air_traffic_controller_init( objective, restarting )
{
	skipto_message( "objective_air_traffic_controller_init" );
	air_traffic_controller::air_traffic_controller_start();
}

function skipto_air_traffic_controller_complete( name, b_starting, b_direct, player )
{
	skipto_message( "objective_air_traffic_controller_done" );
}


//*****************************************************************************
// skipto nrc_knocking
// Event 2
//*****************************************************************************

function skipto_nrc_knocking_init( objective, restarting )
{
	skipto_message( "objective_nrc_knocking_init" );
	nrc_knocking::nrc_knocking_start();
}

function skipto_nrc_knocking_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "objective_nrc_knocking_done" );
}


//*****************************************************************************
// skipto blend_in
// Event 3
//*****************************************************************************

function skipto_blend_in_init( objective, restarting )
{
	skipto_message( "objective_blend_in_init" );
	blend_in::blend_in_start();
}

function skipto_blend_in_complete( name, b_starting, b_direct,  player )
{
	level thread scene::init( "cin_pro_05_01_securitycam_1st_stealth_kill" );
	level thread scene::init( "cin_pro_05_01_securitycam_1st_stealth_kill_exit" );
	skipto_message( "objective_blend_in_done" );
	
	
	level notify( "objective_blend_in_done" );
}


//*****************************************************************************
// skipto take_out_guards
// Event 4
//*****************************************************************************

function skipto_take_out_guards_init( objective, restarting )
{
	skipto_message( "objective_take_out_guards_init" );
	//completed via "objective" trigger in tunnel
	take_out_guards::take_out_guards_start();
}

function skipto_take_out_guards_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "objective_take_out_guards_done" );
	level notify( "objective_take_out_guards_done" );
}


//*****************************************************************************
// skipto security_camera
// Event 5
//*****************************************************************************

function skipto_security_camera_init( objective, restarting )
{
	skipto_message( "objective_security_camera_init" );
	security_camera::security_camera_start( objective );
}

function skipto_security_camera_complete( name, b_starting, b_direct,  player )
{
	//these animations have doors which need to show up before the player gets to them
	level thread scene::init("cin_pro_06_03_hostage_1st_khalil_intro_rescue");
	level thread scene::init( "cin_pro_07_01_securitydesk_vign_weapons_main");	
	level thread scene::skipto_end_noai( "cin_pro_05_01_securitycam_1st_stealth_kill" );
	
	level.b_loadout_silenced = false;
		
	array::run_all(level.players, &SetLowReady, false);
	
	skipto_message( "objective_security_camera_done" );
}


//*****************************************************************************
// skipto hostage_1
// Event 6
//*****************************************************************************

function skipto_hostage_1_init( objective, restarting )
{
	skipto_message( "objective_hostage_1_init" );
	hostage_1::hostage_1_start( objective );
}

function skipto_hostage_1_complete( name, b_starting, b_direct,  player )
{
	//set up triggers to not be available til later
	trig_weapon_room_door = GetEnt( "trig_open_weapons_room", "targetname" );
	trig_weapon_room_door TriggerEnable(false);
	skipto_message( "hostage_1_done" );
	level notify( "hostage_1_done" );
}

//*****************************************************************************
// skipto prison
// Event 7
//*****************************************************************************

function skipto_prison_init( objective, b_restarting )
{

	skipto_message( "objective_prison_init" );
	prison::prison_start( objective );
}

function skipto_prison_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "prison" );
	level notify( "prison" );
}



//*****************************************************************************
// skipto security_desk
// Event 8
//*****************************************************************************

function skipto_security_desk_init( objective, restarting )
{
	skipto_message( "objective_security_desk_init" );
	security_desk::security_desk_start( objective );
}

function skipto_security_desk_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "security_desk_done" );
}


//*****************************************************************************
// skipto lift_escape
// Event 9
//*****************************************************************************

function skipto_lift_escape_init( objective, restarting )
{
	skipto_message( "objective_lift_escape_init" );
	lift_escape::lift_escape_start( objective );
}

function skipto_lift_escape_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "lift_escape_done" );
}


//*****************************************************************************
// skipto intro_cyber_soldiers
// Event 10
//*****************************************************************************

function skipto_intro_cyber_soldiers_init( objective, restarting )
{
	skipto_message( "objective_intro_cyber_soldiers_init" );
	intro_cyber_soldiers::intro_cyber_soldiers_start();
}

function skipto_intro_cyber_soldiers_complete( name, b_starting, b_direct,  player )
{
	//init cinematic that has doors at the end of the vtol hangar 
	level thread scene::init("cin_pro_11_01_jeepalley_vign_engage_new_start");
	
	skipto_message( "intro_cyber_soldiers_done" );
}


//*****************************************************************************
// skipto hangar
// Event 11
//*****************************************************************************

function skipto_hangar_init( objective, restarting )
{
	

	
	level.ai_theia 		= util::get_hero( "theia" );
	level.ai_prometheus = util::get_hero( "prometheus" );
	level.ai_hyperion 	= util::get_hero( "hyperion" );
	
	if( restarting )
	{
		level.ai_hendricks 	= util::get_hero( "hendricks" );
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );		
		level.ai_pallas 	= util::get_hero( "pallas" );	
		
		level flag::set ("pallas_at_window");
			
		skipto::teleport_ai( objective, level.heroes );	

		level thread intro_cyber_soldiers::move_lift();		
	}
	
	skipto_message( "objective_hangar_init" );
	hangar::hangar_start();
}

function skipto_hangar_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "hangar_done" );
}

//*****************************************************************************
// skipto vtol_collapse
// Event 12
//*****************************************************************************

function skipto_vtol_collapse_init( objective, restarting )
{
	
	level.ai_prometheus = util::get_hero( "prometheus" );
	
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks 	= util::get_hero( "hendricks" );
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );		
		level.ai_pallas 	= util::get_hero( "pallas" );	
			
		skipto::teleport_ai( objective, level.heroes );	

		level thread intro_cyber_soldiers::move_lift();		
	}
	
	skipto_message( "objective_vtol_collapse_init" );
	vtol_collapse::vtol_collapse_start();
}

function skipto_vtol_collapse_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "vtol_collapse_done" );
}


//*****************************************************************************
// skipto jeep alley
// Event 13
//*****************************************************************************

function skipto_jeep_alley_init( objective, restarting )
{	
	level.ai_theia 		= util::get_hero( "theia" );
	
	//make sure the doors are set up properly when this section starts	
	hangar_gate_r = GetEnt( "hangar_gate_r", "targetname" );
	hangar_gate_r_pos = struct::get( "hangar_gate_r_pos", "targetname" );
	hangar_gate_r Moveto( hangar_gate_r_pos.origin, 0.1 );

	hangar_gate_l = GetEnt( "hangar_gate_l", "targetname" );
	hangar_gate_l_pos = struct::get( "hangar_gate_l_pos", "targetname" );
	hangar_gate_l Moveto( hangar_gate_l_pos.origin, 0.1 );
	

	
	if ( restarting )
	{	
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );
		level.ai_hendricks 	= util::get_hero( "hendricks" );
	
		skipto::teleport_ai( objective, level.heroes );		
	}	
	
	
	skipto_message( "objective_jeep_alley_init" );
	jeep_alley::jeep_alley_start();
}

function skipto_jeep_alley_complete( name, b_starting, b_direct,  player )
{
	level thread scene::skipto_end( "cin_pro_11_01_jeepalley_vign_engage_new_attack", undefined, undefined, .98 );
	
	skipto_message( "jeep_alley_done" );
}


//*****************************************************************************
// skipto bridge battle
// Event 14
//*****************************************************************************

function skipto_bridge_battle_init( objective, restarting )
{	
	level.ai_hyperion 	= util::get_hero( "hyperion" );
	level.ai_theia 		= util::get_hero( "theia" );

	
	if ( restarting )
	{	
		level.ai_theia 		= util::get_hero( "theia" );
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );
		level.ai_hendricks 	= util::get_hero( "hendricks" );
	
		skipto::teleport_ai( objective, level.heroes );		
		
		hangar_gate_r = GetEnt( "hangar_gate_r", "targetname" );
		hangar_gate_r_pos = struct::get( "hangar_gate_r_pos", "targetname" );
		hangar_gate_r Moveto( hangar_gate_r_pos.origin, 0.1 );
	
		hangar_gate_l = GetEnt( "hangar_gate_l", "targetname" );
		hangar_gate_l_pos = struct::get( "hangar_gate_l_pos", "targetname" );
		hangar_gate_l Moveto( hangar_gate_l_pos.origin, 0.1 );
		
	}	
	
	
	skipto_message( "objective_bridge_battle_init" );
	bridge_battle::bridge_battle_start();
}

function skipto_bridge_battle_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "bridge_battle_done" );
}


//*****************************************************************************
// skipto dark battle
// Event 15
//*****************************************************************************

function skipto_dark_battle_init( objective, restarting )
{	
	if ( restarting )
	{	
		level.ai_hyperion 	= util::get_hero( "hyperion" );
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );
		level.ai_hendricks 	= util::get_hero( "hendricks" );
	
		skipto::teleport_ai( objective, level.heroes );			
	}	
	
	skipto_message( "objective_dark_battle_init" );
	dark_battle::dark_battle_start();
}

function skipto_dark_battle_complete( name, b_starting, b_direct,  player )
{
	//make sure doors are there in robot defend
	level thread scene::init( "cin_pro_15_01_opendoor_vign_getinside_new_prometheus_doorhold");
	skipto_message( "dark_battle_done" );
	if (scene::is_playing("cin_pro_11_01_jeepalley_vign_engage_new_attack"))
	{
		level thread scene::stop( "cin_pro_11_01_jeepalley_vign_engage_new_attack" );
	}
}


//*****************************************************************************
// skipto vtol tackle
// Event 16
//*****************************************************************************

function skipto_vtol_tackle_init( objective, restarting )
{	
	
	level.ai_prometheus = util::get_hero( "prometheus" );
	
	if ( restarting )
	{	
		level.ai_hendricks 	= util::get_hero( "hendricks" );		
		level.ai_hyperion 	= util::get_hero( "hyperion" );
		level.ai_khalil 	= util::get_hero( "khalil" );	
		level.ai_minister 	= util::get_hero( "minister" );	
	
		//sets up guards for vtol section
		spawner::add_spawn_function_group( "initial_vtol_guys" , "targetname", &cp_prologue_util::ai_idle_then_alert,"vtol_has_crashed" );
		spawn_manager::enable( "vtol_tackle_spwn_mgr2" );
	
		skipto::teleport_ai( objective, level.heroes );			
	}	
	
	skipto_message( "objective_vtol_tackle_init" );
	vtol_tackle::vtol_tackle_start();
}

function skipto_vtol_tackle_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "vtol_tackle_done" );
}


//*****************************************************************************
// skipto robot horde
// Event 17
//*****************************************************************************

function skipto_robot_horde_init( objective, restarting )
{
	level.ai_pallas = util::get_hero( "pallas" );
	level.ai_theia = util::get_hero( "theia" );

	if ( restarting )
	{	
		level.ai_theia = util::get_hero( "theia" );
		level.ai_hyperion = util::get_hero( "hyperion" );
		level.ai_khalil = util::get_hero( "khalil" );	
		level.ai_minister = util::get_hero( "minister" );
		level.ai_hendricks = util::get_hero( "hendricks" );		
		level.ai_prometheus = util::get_hero( "prometheus" );
					
		skipto::teleport_ai( objective, level.heroes );			
	}	
	
	skipto_message( "objective_robot_horde_init" );
	
	//disable triggers on APC
	a_trigger = GetEntArray( "t_enter_apc", "targetname" );
	array::run_all( a_trigger, &TriggerEnable, false );
	
	robot_horde::robot_horde_start();
}

function skipto_robot_horde_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "robot_horde_done" );
}

//*****************************************************************************
// skipto apc
// Event 18
//*****************************************************************************

function skipto_apc_init( objective, restarting )
{
	skipto_message( "objective_apc_init" );
	
	
	
	if( restarting )
	{
		level.ai_prometheus = util::get_hero( "prometheus" );
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( objective, level.heroes );
		
		level thread scene::init("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		
		//play end of apc animation
		level thread scene::skipto_end("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		level thread scene::skipto_end("cin_pro_15_01_opendoor_vign_getinside_new_hendricks");
		level thread scene::skipto_end("cin_pro_15_01_opendoor_vign_mount_new_prometheus_move2apc");
		
	}

	apc::apc_main();
}

function skipto_apc_complete( name, b_starting, b_direct,  player )
{
	//spawner::add_spawn_function_group( "rail_robot", "script_noteworthy", &cp_prologue_util::set_robot_unarmed);
	spawner::add_spawn_function_group( "robot_crawling_on_apc", "targetname", &cp_prologue_util::set_robot_unarmed);
	
	skipto_message( "apc_done" );
}


//*****************************************************************************
// skipto apc_rail
// Event 19
//*****************************************************************************

function skipto_apc_rail_init( objective, restarting )
{
	skipto_message( "objective_apc_rail_init" );
	
	
	
	if (restarting)
	{
		
		level.ai_prometheus = util::get_hero( "prometheus" );
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		//level cp_prologue_util::spawn_coop_player_replacement( "skipto_apc_ai_rail" );
		
		//set up APC via cinematic
		level thread scene::init("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		level thread scene::skipto_end("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		//get hendricks in position
		level thread scene::skipto_end("cin_pro_15_01_opendoor_vign_mount_new_prometheus_hendricks_end");	
		
		wait 0.05;//wait for scene to run a frame and spawn them
		
		level.ai_prometheus = GetEnt("prometheus", "animname");
		level.ai_hendricks = GetEnt("hendricks", "animname");
		
		level.ai_prometheus SetGoal(level.ai_prometheus.origin, true);
		level.ai_hendricks SetGoal(level.ai_hendricks.origin, true);
		
			
		v_apc = GetEnt("apc", "animname");

		//TODO attach AI to position in APC
		//attach hendricks to the APC driver seat
		//v_apc UseVehicle(level.ai_hendricks, 0);
		
		//set up apc to be used for the rail 
		//NOTE: Players are connected to APC via on_spawn callback to player_attach_to_apc	
		level thread apc_shared::setup_apc_on_rail( "vehicle_apc_hijack_node", 1 );
	}
	

	
		
	apc_rail::apc_rail_main();
}


function skipto_apc_rail_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "apc_rail_done" );
}



//*****************************************************************************
// skipto apc_rail_stall
// Event 19-2
//*****************************************************************************

function skipto_apc_rail_stall_init( objective, restarting )
{
	skipto_message( "objective_apc_rail_stall_init" );
	
	
	
	if (restarting)
	{
		
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		//level cp_prologue_util::spawn_coop_player_replacement( "skipto_apc_ai_rail_stall" );
		
		//set up APC via cinematic
		level thread scene::init("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		level thread scene::skipto_end("cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
		wait 0.05;//wait for scene to run a frame and spawn them
		
		//get hendricks in position
		v_apc = GetEnt("apc", "animname");
		v_apc thread scene::skipto_end( "cin_pro_15_01_opendoor_vign_mount_hendricks_enter_apc" );
		
	    level thread apc_shared::setup_apc_on_rail( "nd_stall_start", 1 );

		
		level.ai_hendricks SetGoal(level.ai_hendricks.origin, true);
			
		a_fences = GetEntArray("crash_into_fence", "targetname");
		array::run_all(a_fences, &Delete);
	}
	

	
		
	apc_rail::apc_rail_stall_main();
}

function skipto_apc_rail_stall_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "apc_rail_stall_done" );
}



//*****************************************************************************
// skipto robot defend
// Event 20
//*****************************************************************************

function skipto_robot_defend_init( objective, restarting )
{
	skipto_message( "objective_robot_defend_init" );

	// Get Hendricks, Minister and Khalil
	if( restarting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_minister = util::get_hero( "minister" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		//show vtol model after tunnel
		m_tunnel_vtol_death = GetEnt( "m_tunnel_vtol_death", "targetname" );
		m_tunnel_vtol_death Show();
		exploder::exploder( "fx_exploder_vtol_crash_rail" );
	}
	else
	{
		level.apc turret::disable( 1 );
		level.apc turret::disable( 2 );
		level.apc turret::disable( 3 );
		level.apc turret::disable( 4 );
		//temp to keep APC in the correct position on a normal playthrough
		scene::stop("cin_pro_15_01_opendoor_vign_mount_hendricks_enter_apc");
		            
	}	

	cp_mi_eth_prologue::init_khalil( "skipto_robot_defend_khalil" );
	cp_mi_eth_prologue::init_minister( "skipto_robot_defend_minister" );
	cp_mi_eth_prologue::init_hendricks( "skipto_robot_defend_hendricks" );


	//if skipto, setup players in truck
	if( restarting )
	{		
		//level.apc MakeVehicleUnusable();

	}	
	
	robot_defend::robot_defend_main();
}

function skipto_robot_defend_complete( name, b_starting, b_direct, player )
{
	skipto_message( "robot_defend_done" );
}


//*****************************************************************************
// skipto sky hook
// Event 21
//*****************************************************************************

function skipto_sky_hook_init( objective, restarting )
{
	skipto_message( "objective_sky_hook_init" );
	
	// Get Hendricks, Minister and Khalil
	if ( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
	}
	
	//cp_mi_eth_prologue::init_hendricks( "skipto_sky_hook_hendricks" );

	// Get Vehicle
	//level thread apc_shared::setup_apc_for_turret_use( "cleanup_apc", 0 );
	
	sky_hook::sky_hook_main();
}

function skipto_sky_hook_complete( name, b_starting, b_direct,  player )
{
	skipto_message( "sky_hook_done" );
}

//*****************************************************************************
// skipto prologue ending
// Event 23
//*****************************************************************************

function skipto_prologue_ending_init( objective, restarting )
{
	skipto_message( "objective_prologue_ending_init" );
	prologue_ending::prologue_ending_main();
}

function skipto_prologue_ending_complete( name, b_starting, b_direct, player )
{
	skipto_message( "prologue_ending_done" );
}

//*****************************************************************************
//*****************************************************************************

function skipto_message( msg )
{
/#
	//IPrintLnBold( msg );
	PrintLn( "SKIPTO: "+ msg );
#/
}

//*****************************************************************************
// Hendricks uses "r" on the color chain
//*****************************************************************************

function init_hendricks( str_teleport_struct_targetname )
{
	level.ai_hendricks = util::get_hero( "hendricks" );

	primary_weapon = GetWeapon( "ar_standard" );
	level.ai_hendricks ai::gun_switchto( primary_weapon, "right" );

	if( IsDefined(str_teleport_struct_targetname) )
	{
		s_struct = struct::get( str_teleport_struct_targetname, "targetname" );
		level.ai_hendricks forceteleport( s_struct.origin, s_struct.angles );
	}
}


//*****************************************************************************
// Hendricks uses "r" on the color chain
//*****************************************************************************

function init_minister( str_teleport_struct_targetname )
{
	level.ai_minister = util::get_hero( "minister" );
//	level.ai_minister colors::set_force_color( "g" );

	if( IsDefined(str_teleport_struct_targetname) )
	{
		s_struct = struct::get( str_teleport_struct_targetname, "targetname" );
		level.ai_minister forceteleport( s_struct.origin, s_struct.angles );
	}
}


//*****************************************************************************
// Hendricks uses "r" on the color chain
//*****************************************************************************

function init_khalil( str_teleport_struct_targetname )
{
	level.ai_khalil = util::get_hero( "khalil" );
//	level.ai_khalil colors::set_force_color( "b" );

	if( IsDefined(str_teleport_struct_targetname) )
	{
		s_struct = struct::get( str_teleport_struct_targetname, "targetname" );
		level.ai_khalil forceteleport( s_struct.origin, s_struct.angles );
	}
}



//*****************************************************************************
//*****************************************************************************

function DeleteGroupAddSpawners( str_spawner_name )
{
	a_spawners = GetEntArray( str_spawner_name, "targetname" );
	for( i=0; i<a_spawners.size; i++ )
	{
		a_spawners[i] spawner::add_spawn_function( &assign_kill_group, str_spawner_name );
	}
}

// self = ai
function DeleteGroupAdd( str_group )
{
	self.delete_group = str_group;
}

function DeleteGroupDelete( str_group )
{
	a_ai = GetAiArray();

	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			e_ent = a_ai[i];

			if( IsAlive(e_ent) && IsDefined(e_ent.delete_group) && (e_ent.delete_group == str_group) )
			{
				e_ent.delete_group = undefined;
				//e_ent kill();
				e_ent delete();
			}
		}
	}
}

// self = ai
function assign_kill_group( str_group )
{
	DeleteGroupAdd( str_group );
}

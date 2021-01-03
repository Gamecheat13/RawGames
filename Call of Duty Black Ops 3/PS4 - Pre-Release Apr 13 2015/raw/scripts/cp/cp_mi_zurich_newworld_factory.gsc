#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\cp\_cic_turret;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_objectives; 
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#using scripts\cp\cybercom\_cybercom_gadget_security_breach;	

#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_util;
	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_factory;































#precache( "objective", "cp_level_newworld_factory_uncover_plan" );
#precache( "objective", "cp_level_newworld_factory_waypoint" );
#precache( "objective", "cp_level_newworld_foundry_destroy_generator" );
#precache( "objective", "cp_level_newworld_vat_room_hack" );
#precache( "string", "CP_MI_ZURICH_NEWWORLD_USE_CYBERCORE" );
#precache( "string", "CP_MI_ZURICH_NEWWORLD_USE_TACTICAL_VISION" );
#precache( "string", "CP_MI_ZURICH_NEWWORLD_USE_COMPUTER_INTERFACE" );

//----------------------------------------------------------------------------
// SKIPTO - PALLAS IGC
//
function skipto_pallas_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
	}

	skipto::teleport( str_objective );

	level intro_area_threatgroups_setup(); //threat groups must be defined before allies spawn.
		
	// spawn real AI allies
	spawn_allies( "intro", false );	// 2 of these allies are named soldier01 & 02 and are used in the IGC
	
	level thread util::screen_fade_in( 2.0, "white" );
	
	level util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_TIME_FACTORY", undefined, undefined, 150, 5 );

	pallas_intro_igc();

	objectives::set( "cp_level_newworld_factory_uncover_plan" );
	skipto::objective_completed( str_objective );
}

function skipto_pallas_igc_done( str_objective, b_starting, b_direct, player )
{
}


//
//	NOTE: Diaz is the character formerly known as Pallas, represented by a symbol that cannot be typed.
function pallas_intro_igc()
{
	level.ai_diaz = util::get_hero( "diaz" );
	level.ai_diaz SetIgnorePauseWorld( true );	// Keep on acting normal, even if the world is frozen

	level.ai_taylor = util::get_hero( "taylor" );
	level.ai_taylor SetIgnorePauseWorld( true );	// Keep on acting normal, even if the world is frozen
	
	foreach( player in level.players )
	{
		player SetIgnorePauseWorld( true );	// Keep on acting normal, even if the world is frozen	
	}
	
	// spawn allies to be killed in Pallas Intro IGC (soldier03 ~ 05)
	a_pallas_intro_igc_soldier_spawners = GetEntArray( "pallas_intro_igc_soldier", "script_noteworthy" );
	spawner::simple_spawn( a_pallas_intro_igc_soldier_spawners );

	lock_players_during_igc( true );

	pallas_intro_scene();

	// TODO - replace this with the correct method
	flagsys::wait_till_clear( "cin_new_02_01_pallasintro_vign_appear_taylordiaz_playing" );
}


//
//	NOTE:  Some FX notetracks have been manually added to the GDT entries of several XANIMS, 
function pallas_intro_scene()
{
	scene::add_scene_func( "cin_new_02_01_pallasintro_vign_appear_player", &teleport_players_out_of_igc, "done" );
	
	level thread scene::play( "cin_new_02_01_pallasintro_vign_appear" );
	level thread scene::play( "cin_new_02_01_pallasintro_vign_appear_player" );
	wait 1.0;	//	wait a bit for the scene to start so we can grab a special actor

	level waittill( "car_explode" );	//NOTETRACK added to GDT.  ch_new_02_01_pallasintro_vign_appear_swatguy01.xanim

//------------------------
	//TEMP commented out because the truck origin is not where it should be
//	mdl_truck = GetEnt( "truck01", "targetname" );
//	fx::play( "truck_explosion", mdl_truck.origin, mdl_truck.angles );
	//TEMP Play explosion effect based on temp struct 
	s_truck = struct::get( "temp_truck_explosion", "targetname" );
	fx::play( "truck_explosion", s_truck.origin, s_truck.angles );
//------------------------
	                   
	// Next we wait for a "freeze" notetrack from the appear scene
	ai_soldier = GetEnt( "soldier01_ai", "targetname" );
	ai_soldier waittill( "freeze" );	// NOTETRACK from exported XANIM.  ch_new_02_01_pallasintro_vign_appear_swatguy01.xanim

	SetPauseWorld( true );

	level thread scene::play( "cin_new_02_01_pallasintro_vign_appear_taylordiaz" );

	level.ai_taylor thread taylor_pallas_intro_notetracks();

	// now wait for a notetrack on diaz to unfreeze
	level.ai_diaz waittill( "unfreeze" );	// NOTETRACK from expoerted XANIM.  ch_new_02_01_pallasintro_vign_appear_diaz
	
	SetPauseWorld( false );

	// TODO - replace this with the correct method
	flagsys::wait_till_clear( "cin_new_02_01_pallasintro_vign_appear_taylordiaz_playing" );
	
	lock_players_during_igc( false );
}

function teleport_players_out_of_igc( a_ents )
{
	level util::teleport_players_igc( "s_intro_startpositions" );
}

function lock_players_during_igc( igc_starting )
{
	foreach( player in level.players )
	{
		if( igc_starting )
		{
			player player_stick( true, 10, 30, 5, 5 );
			player SetLowReady( true );
		}
		else
		{
			player player_unstick();
			player SetLowReady( false );
		}
		player ai::set_ignoreme( igc_starting );
	}
}

//	self is Taylor
// 	run his notetracks separately so we don't hit any timing issues.
function taylor_pallas_intro_notetracks()
{
	self waittill( "rez_in" );	// NOTETRACK added to GDT.  ch_new_02_01_pallasintro_vign_appear_taylor.xanim
	self fx::play( "rez_in", undefined, undefined, undefined, true, "j_spine4", undefined, true );
	
	self waittill( "rez_out" );	// NOTETRACK added to GDT.  ch_new_02_01_pallasintro_vign_appear_taylor.xanim
	self fx::play( "rez_out", undefined, undefined, undefined, true, "j_spine4", undefined, true );
}
	

//----------------------------------------------------------------------------
// SKIPTO - FACTORY AREA
//
function skipto_factory_exterior_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		
		common_startup_tasks( str_objective );
		
		level intro_area_threatgroups_setup();
		spawn_allies( "intro" );
		
		// skip Pallas Intro IGC to the end
		level thread scene::skipto_end_noai( "cin_new_02_01_pallasintro_vign_appear" );
		//level thread scene::skipto_end( "cin_new_02_01_pallasintro_vign_appear_taylordiaz" );
	}
		
	skipto::teleport( str_objective );
	
	level thread intro_area();
	
	trigger::wait_till( "alley_start", undefined, undefined, false );
	skipto::objective_completed( str_objective );
}

function skipto_factory_exterior_done( str_objective, b_starting, b_direct, player )
{
}


//----------------------------------------------------------------------------
// SKIPTO - ALLEY AREA
//
function skipto_alley_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		
		common_startup_tasks( str_objective );
		
		spawn_allies( "alley" );
	}

	level thread alley_area();
	
	trigger::wait_till( "warehouse_start", undefined, undefined, false );
	skipto::objective_completed( str_objective );
}

function skipto_alley_done( str_objective, b_starting, b_direct, player )
{
}


// SKIPTO - WAREHOUSE AREA
//
function skipto_warehouse_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		objectives::set( "cp_level_newworld_factory_uncover_plan" );
		common_startup_tasks( str_objective );
	}

	level thread warehouse_area();
	
	trigger::wait_till( "foundry_start", undefined, undefined, false );
	skipto::objective_completed( str_objective );
}

function skipto_warehouse_done( str_objective, b_starting, b_direct, player )
{
}


//----------------------------------------------------------------------------
// SKIPTO - FOUNDRY AREA
//
function skipto_foundry_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		objectives::set( "cp_level_newworld_factory_uncover_plan" );
		common_startup_tasks( str_objective );
		spawn_hijack_vehicles();
		
		close_heavy_doors( true );
	}

	level thread foundry_area();
	
	trigger::wait_till( "vat_room_start" );
	skipto::objective_completed( str_objective );
	
	level notify( "foundry_complete" );
}

function skipto_foundry_done( str_objective, b_starting, b_direct, player )
{
}


//----------------------------------------------------------------------------
// SKIPTO - VAT ROOM AREA
//
function skipto_vat_room_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		objectives::set( "cp_level_newworld_factory_uncover_plan" );
		common_startup_tasks( str_objective );
		
		foreach( player in level.players )
		{
			player cybercom_gadget::giveAbility( "cybercom_hijack", false );
			player cybercom_gadget::equipAbility( "cybercom_hijack" );
		}
	}

	vat_room();
	
	all_players_force_exit_all_vehicles();
	skipto::objective_completed( str_objective );
}

function skipto_vat_room_done( str_objective, b_starting, b_direct, player )
{
}


//----------------------------------------------------------------------------
// SKIPTO - INSIDE MAN IGC
//
function skipto_inside_man_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		objectives::set( "cp_level_newworld_factory_uncover_plan" );
		common_startup_tasks( str_objective );
		open_vat_room_door( true );		
	}
		
	trigger::use( "vat_room_last_moveup_trigger" );
	level thread watch_ptsd_trigger();	// start PTSD screen fades individually on any players that touch the do_ptsd_trigger
	level thread ptsd_status();	// check if each player is PTSD screen fading. Set "ptsd_active" flag that turns event ending trigger on/off
	
	objectives::set( "cp_level_newworld_vat_room_hack", struct::get( "vat_room_hacking_console", "targetname" ) );
	
	// computer console that player "hacks" after the Vat Room
	t_vat_room_end_use_trigger = GetEnt( "inside_man_igc_start", "targetname" );
	t_vat_room_end_use_trigger SetHintString( &"CP_MI_ZURICH_NEWWORLD_USE_COMPUTER_INTERFACE" );
	t_vat_room_end_use_trigger SetCursorHint( "HINT_NOICON" );	
	t_vat_room_end_use_trigger hacking::init_hack_trigger( 2.4 );
	t_vat_room_end_use_trigger hacking::trigger_wait();
	t_vat_room_end_use_trigger TriggerEnable( false );	// TODO: trying to get the button icon & hint string to disappear after hacking is finished
	
	objectives::complete( "cp_level_newworld_vat_room_hack" );

	level notify( "start_inside_man_igc" );
	
	util::screen_fade_out( 2.0, "white" );
	wait 1;	// wait a little extra so the change isn't so jarring
	
	skipto::objective_completed( str_objective );
}

function skipto_inside_man_igc_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_newworld_factory_uncover_plan" );
}


//----------------------------------------------------------------------------
// INTRO AREA pka FACTORY EXTERIOR
//
function intro_area()
{
	// intro area spawn funcs
//	spawner::add_spawn_function_group( "intro_area_enemy", "script_noteworthy", &adjust_goal_radius, 512 );	// initial spawns
//	spawner::add_spawn_function_group( "highlow_area_enemy", "script_noteworthy", &adjust_goal_radius, 256 );	// right path enemies
//	spawner::add_spawn_function_group( "pillar_area_enemy", "script_noteworthy", &adjust_goal_radius, 192 );	// leftpath enemies
//	spawner::add_spawn_function_group( "intro_last_stand_enemy", "script_noteworthy", &adjust_goal_radius, 512 );	// enemies at the end, before the Silo
	spawner::add_spawn_function_group( "left_flank", "script_string" , &set_threat_bias ); // threat groups defined in the SKIPTO
	spawner::add_spawn_function_group( "right_flank", "script_string" , &set_threat_bias ); 
		
	spawn_manager::enable( "sm_intro_area_initial_enemies_left" );
	spawn_manager::enable( "sm_intro_area_initial_enemies_right" );	
	spawn_manager::enable( "sm_pillar_area_enemies" );
	spawn_manager::enable( "sm_center_path_enemies" );
	spawn_manager::enable( "sm_hi_lo_area_enemies" );
	spawn_manager::enable( "sm_intro_initial_enemies_center" );
	
	s_objective_1 = struct::get( "objective_factory_exterior_end", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_1 );	
	
	trigger::use( "intro_color_trigger_start" );
	
	level thread intro_area_allies_lower_health();
	
	level waittill( "enemy_cleanup" );
	a_ai_enemies_for_cleanup = GetEntArray( "intro_area_enemy", "script_noteworthy" );
	a_ai_enemies_for_cleanup = ArrayCombine( a_ai_enemies_for_cleanup, GetEntArray( "pillar_area_enemy", "script_noteworthy" ), false, false );
	a_ai_enemies_for_cleanup = ArrayCombine( a_ai_enemies_for_cleanup, GetEntArray( "highlow_area_enemy", "script_noteworthy" ), false, false );
	a_t_fallback_volume = GetEntArray( "check_for_fallback_volume", "targetname" );
	nd_goto = GetNode( "intro_area_fallback_node_01", "targetname" );
	// get rid of stray enemies as players move up near Silo area
	array::thread_all( a_ai_enemies_for_cleanup, &intro_area_selective_fallback, a_t_fallback_volume, nd_goto );
	//remove bullet shield most allies now that the left/right battle is resolved
	remove_ally_bullet_shield( 5 ); 
	
	// turn off unused color triggers once player reaches smokestack room entrance to prevent allies from moveing backwards to 
	level waittill( "warehouse_entrance" );
	a_t_colors = GetEntArray( "intro_area_color_trigger", "script_noteworthy" );
	array::run_all( a_t_colors, &Delete );	
}

function intro_area_allies_lower_health()
{
	trigger::wait_till( "factory_exterior_allies_lower_health" );
	
	a_allies = spawner::get_ai_group_ai( "factory_intro_allies" );
	
	if( a_allies.size > 2 )
	{
		for( i = 0; i < (a_allies.size - 2 ); i++ )
		{
			a_allies[i] thread wait_and_lower_health();
		}
	}
}

function intro_area_selective_fallback( a_t_fallback_volume, nd_goto )	// self == an enemy
{
	if( IsSpawner( self ) )
	{
		return;
	}
	
	self endon( "death" );
	
	foreach( t_fallback_volume in a_t_fallback_volume )
	{
		if( self IsTouching( t_fallback_volume ) )
		{
			foreach( player in level.players )
			{
				if( player IsTouching( t_fallback_volume ) )	// if I'm touching a trigger that contains a player...
				{
					self setgoal_ignore_enemies( nd_goto );	// fallback instead of killing myself because players seeing me die for no reason is weird
					return;
				}
			}
		}
	}
	
}

function intro_area_objective()
{
	s_objective_1 = struct::get( "objective_factory_exterior_end", "targetname" );
	objectives::set( "cp_level_newworld_factory_uncover_plan" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_1 );
	level waittill( "player_has_reached_silo" );
	objectives::complete( "cp_level_newworld_factory_waypoint" );	
}

function intro_area_threatgroups_setup()
{
	// this sets up the left side and right side fights so that there isn't too much crossfire. This should only be called once in the area init.
	// order of operations is create groups, set values.  Group is populated in a seperate spawnfunction

	CreateThreatBiasGroup( "factory_intro_threatbias_friendly_left" );
	CreateThreatBiasGroup( "factory_intro_threatbias_enemy_left" );
	
	CreateThreatBiasGroup( "factory_intro_threatbias_friendly_right" );
	CreateThreatBiasGroup( "factory_intro_threatbias_enemy_right" );
	
	// set values
	//attack 
	SetThreatBias( "factory_intro_threatbias_friendly_left", "factory_intro_threatbias_enemy_left", 2500 );
	SetThreatBias( "factory_intro_threatbias_enemy_left", "factory_intro_threatbias_friendly_left", 2500 );
	SetThreatBias( "factory_intro_threatbias_friendly_right", "factory_intro_threatbias_enemy_right", 2500 );
	SetThreatBias( "factory_intro_threatbias_enemy_right", "factory_intro_threatbias_enemy_right", 2500 );
	
	//hopefully leave alone
	SetThreatBias( "factory_intro_threatbias_friendly_left", "factory_intro_threatbias_enemy_right", -5000 );
	SetThreatBias( "factory_intro_threatbias_enemy_left", "factory_intro_threatbias_enemy_right", -5000 );
	SetThreatBias( "factory_intro_threatbias_friendly_right", "factory_intro_threatbias_enemy_left", -5000 );
	SetThreatBias( "factory_intro_threatbias_enemy_right", "factory_intro_threatbias_enemy_left", -5000 );
}

function set_threat_bias()
{
	// self is a spawner
	str_flank = self.script_string;
	
	switch ( str_flank )
	{
		case "right_flank":
			self SetThreatBiasGroup( "factory_intro_threatbias_enemy_right" );
			break;
		
		case "left_flank":
			self SetThreatBiasGroup( "factory_intro_threatbias_enemy_left" );
			break; 
		
		case "friendly_left":
			self SetThreatBiasGroup( "factory_intro_threatbias_friendly_left" );
			break;
		
		case "friendly_right":
			self SetThreatBiasGroup( "factory_intro_threatbias_friendly_right" );
			break; 
		
		default:
			break;
	}
}


//----------------------------------------------------------------------------
// ALLEY AREA
//
function alley_area()
{
	level flag::init( "tac_mode_tutorial_complete" );
	
	// alley area spawn funcs
	spawner::add_spawn_function_group( "alley_enemy_left", "script_noteworthy", &adjust_goal_radius, 512 );
	spawner::add_spawn_function_group( "alley_enemy_right", "script_noteworthy", &adjust_goal_radius, 512 );
	spawner::add_spawn_function_group( "alley_reinforcement_enemy_left", "script_noteworthy", &alley_reinforcement_enemy_spawn_func, 512, true );
	spawner::add_spawn_function_group( "alley_reinforcement_enemy_right", "script_noteworthy", &alley_reinforcement_enemy_spawn_func, 512, false );
	spawner::add_spawn_function_group( "alley_final_enemy", "script_noteworthy", &adjust_goal_radius, 512 );
	
	foreach( player in level.players )
	{
		player thread player_tac_mode_watcher();
	}
	callback::on_spawned( &player_tac_mode_watcher ); 
	
	level thread tutorial_wallrun();
	
	s_objective_1 = struct::get( "objective_factory_exterior_end", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_1 );	
	objectives::complete( "cp_level_newworld_factory_waypoint" );
	s_objective_2 = struct::get( "objective_alley_end", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_2 );
	
	level.nd_alley_enemy_goto_left = GetNode( "alley_enemy_initial_goto_left", "targetname" );
	level.nd_alley_enemy_goto_right = GetNode( "alley_enemy_initial_goto_right", "targetname" );
	
	level thread tutorial_tac_mode();
	
	alley_fallbacks( 1 );
	spawn_manager::enable( "sm_alley_reinforcements" );
	
	remove_ally_bullet_shield( 6 ); // make sure all of the allies have shield removed
	
	alley_fallbacks( 2 );
}

// TODO: still very rough implementation
function tutorial_wallrun()
{
	thread scene::play( "cin_new_03_03_factoryraid_vign_wallrunright_diaz", level.ai_diaz ); //TODO: This scene should be integrated as the init loop for the scene below. and we need a transition anim betweel.
	
	flag::wait_till("tutorial_message_wallrun" ); //flag set on trigger in front of silo
	
	level.ai_diaz thread dialog::say( "To run along walls, jump while running slightly towards a smooth wall." );
	wait 0.8;	// slight pause before Diaz starts wallrunning
	
	// HACK - this scene::stop call is needed to prevent Diaz from being stuck looping cin_new_03_03_factoryraid_vign_wallrunright_diaz
	// This only happens if the player rushes through before cin_new_03_03_factoryraid_vign_wallrunright_diaz begins playing
	// TODO - this should be authored as one scene
	scene::stop( "cin_new_03_03_factoryraid_vign_wallrunright_diaz" );
	
	scene::play( "cin_new_03_03_factoryraid_vign_wallrunright", level.ai_diaz );	// TODO: remove the split.  Let anim was cut.
	
	//wall run is done, now go to your next color node
	trigger::use( "set_diaz_color_post_wallrun", "targetname" );
}

function tutorial_tac_mode()
{
	level waittill( "alley_tac_mode_tutorial_kickoff" );
	
	level.ai_diaz thread dialog::say( "Pull up your tactical view - you’ve got access to a wide range of battlefield intel." );
	wait 0.5; // delay UI so player can focus on the words.
	
	foreach( player in level.players )
	{
		player thread show_tac_mode_hint();	
	}
	
	spawn_manager::enable( "sm_alley_skipto_enemies" ); //move here so that the enemies will spawn on the time out as well. Otherwise player can just run.
	level thread alley_allies_lower_health();		
	
	level flag::wait_till( "tac_mode_tutorial_complete" );
		
	wait 2.3; //pause for effect
	
	//TODO: Make sure the player can't see the origin of the rocket.
	s_rpg_shooter_origin = struct::get( "tac_mode_tutorial_rocket_start" , "targetname" );
	s_rpg_shooter_target = struct::get( "tac_mode_tutorial_rocket_target" , "targetname" );
	v_rpg_target = s_rpg_shooter_origin.origin; 
	v_rpg_origin = s_rpg_shooter_target.origin;
	MagicBullet( GetWeapon( "launcher_standard" ), v_rpg_target, v_rpg_origin );
	wait 2;
	
	s_rpg_shooter_origin = struct::get( "alley_dummyrocket_2_fire" , "targetname" );
	s_rpg_shooter_target = struct::get( "alley_dummyrocket_2_target" , "targetname" );
	v_rpg_target = s_rpg_shooter_origin.origin; 
	v_rpg_origin = s_rpg_shooter_target.origin;
	MagicBullet( GetWeapon( "launcher_standard" ), v_rpg_target, v_rpg_origin );
	wait 1;
	
	s_rpg_shooter_origin = struct::get( "alley_dummyrocket_3_fire" , "targetname" );
	s_rpg_shooter_target = struct::get( "alley_dummyrocket_3_target" , "targetname" );
	v_rpg_target = s_rpg_shooter_origin.origin; 
	v_rpg_origin = s_rpg_shooter_target.origin;
	MagicBullet( GetWeapon( "launcher_standard" ), v_rpg_target, v_rpg_origin );
}

function show_tac_mode_hint() // self = player
{
	self thread util::screen_message_create_client( &"CP_MI_ZURICH_NEWWORLD_USE_TACTICAL_VISION", undefined, undefined, 0, 4 );
	self util::waittill_any_timeout( 4, "tactical_mode_used" );
	self util::screen_message_delete_client();
	
	self notify( "tac_mode_tutorial_complete" );
}

function alley_allies_lower_health()
{
	a_allies = spawner::get_ai_group_ai( "factory_intro_allies" );
	
	foreach( ai in a_allies )
	{
		ai thread wait_and_lower_health();
	}
}

function wait_and_lower_health() // self = AI
{
	self endon( "death" );
	
	// random wait so all the AI don't die off at the same time
	wait( RandomFloatRange( 1.0, 5.0 ) );
	
	self.health = 1;
}

function player_tac_mode_watcher() //self is a player
{
	self endon( "disconnect" );
	self endon( "tac_mode_tutorial_complete" );
	
	self flag::init( "tactical_mode_used" );
	
	while( !( isdefined( self.tmode_activated ) && self.tmode_activated ) ) //this comes from a function in cp_mi_zurich_newworld.gsc
	{
		wait 0.05;
	}
	
	self flag::set( "tactical_mode_used" );
	level flag::set( "tac_mode_tutorial_complete" );
}

function alley_fallbacks( n_count )
{
	level waittill( "alley_fallback_trigger_0" + n_count );
	level.nd_alley_enemy_goto_left = GetNode( "alley_enemy_fallback_goto_0" + n_count + "_left", "targetname" );
	level.nd_alley_enemy_goto_right = GetNode( "alley_enemy_fallback_goto_0" + n_count + "_right", "targetname" );
	a_ai_alley_enemies = GetEntArray( "alley_enemy_left", "script_noteworthy" );
	a_ai_alley_enemies = ArrayCombine( a_ai_alley_enemies, GetEntArray( "alley_enemy_right", "script_noteworthy" ), false, false );
	a_ai_alley_reinforcements = GetEntArray( "alley_reinforcement_enemy_left", "script_noteworthy" );
	a_ai_alley_reinforcements = ArrayCombine( a_ai_alley_reinforcements, GetEntArray( "alley_reinforcement_enemy_right", "script_noteworthy" ), false, false );
	a_ai_alley_enemies = ArrayCombine( a_ai_alley_enemies, a_ai_alley_reinforcements, false, false );
	array::thread_all( a_ai_alley_enemies, &enemy_alley_fallback );
	
	wait 1.6;	// small pause between enemies falling back & allies moving up
	trigger::use( "alley_ally_moveup_trigger_0" + n_count );
}

function enemy_alley_fallback()	// self == alley enemy
{
	if( IsAI( self ) && isdefined( self.script_noteworthy ) )
	{
		switch( self.script_noteworthy )
		{
			case "alley_enemy_left":
			case "alley_reinforcement_enemy_left":
				self setgoal_ignore_enemies( level.nd_alley_enemy_goto_left );
			break;
			case "alley_enemy_right":
			case "alley_reinforcement_enemy_right":
				self setgoal_ignore_enemies( level.nd_alley_enemy_goto_right );
			break;
			default:			
			break;
		}
	}
}

//----------------------------------------------------------------------------
// WAREHOUSE AREA
//
function warehouse_area()
{
	spawner::add_spawn_function_group( "warehouse_1F_enemy", "script_noteworthy", &warehouse_enemy_spawn_func, 512, true );	//384 );
	spawner::add_spawn_function_group( "warehouse_2F_enemy", "script_noteworthy", &warehouse_enemy_spawn_func, 512, false );	//384 );
	spawner::add_spawn_function_group( "warehouse_last_stand_enemy", "script_noteworthy", &adjust_goal_radius, 256 );
	
	level.a_nd_warehouse_1f_goto_front = GetNodeArray( "warehouse_1f_goto_front", "targetname" );
	level.a_nd_warehouse_1f_goto_back = GetNodeArray( "warehouse_1f_goto_back", "targetname" );
	level.a_nd_warehouse_2f_goto_front = GetNodeArray( "warehouse_2f_goto_front", "targetname" );
	level.a_nd_warehouse_2f_goto_back = GetNodeArray( "warehouse_2f_goto_back", "targetname" );
		
	s_objective_2 = struct::get( "objective_alley_end", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_2 );
	objectives::complete( "cp_level_newworld_factory_waypoint" );
	s_objective_3 = struct::get( "objective_foundry_waypoint", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_3 );	
	
	level waittill( "warehouse_fallback" );
	spawn_hijack_vehicles();
	warehouse_fallback();
	
	level waittill( "warehouse_last_stand" );
	warehouse_last_stand();
	// only care if the last stand enemies are cleared because players could easily miss kiling some of the ealier enemies, and that's OK
	level thread spawn_manager::run_func_when_cleared( "sm_warehouse_last_enemies", &warehouse_last_enemies_cleared );
	
	trigger::wait_till( "close_heavy_doors" );
	close_heavy_doors();
}

function warehouse_fallback( n_count )
{
	level.a_nd_warehouse_1f_goto_front = level.a_nd_warehouse_1f_goto_back;
	level.a_nd_warehouse_2f_goto_front = level.a_nd_warehouse_2f_goto_back;
	level.a_nd_warehouse_1f_goto_back = GetNodeArray( "warehouse_last_stand", "targetname" );
	level.a_nd_warehouse_2f_goto_back = GetNodeArray( "warehouse_last_stand", "targetname" );
	
	warehouse_enemy_movement();
}

function warehouse_last_stand()
{
	level.a_nd_warehouse_1f_goto_front = GetNodeArray( "warehouse_last_stand", "targetname" );
	level.a_nd_warehouse_2f_goto_front = GetNodeArray( "warehouse_last_stand", "targetname" );
	level.a_nd_warehouse_1f_goto_back = GetNodeArray( "warehouse_last_stand", "targetname" );
	level.a_nd_warehouse_2f_goto_back = GetNodeArray( "warehouse_last_stand", "targetname" );

	warehouse_enemy_movement();
}

function warehouse_enemy_movement()
{
	a_ai_warehouse_enemies = GetEntArray( "warehouse_1F_enemy", "script_noteworthy" );
	a_ai_warehouse_enemies = array::remove_dead( a_ai_warehouse_enemies, false );
	array::thread_all( a_ai_warehouse_enemies, &warehouse_enemy_goto, true );
	
	a_ai_warehouse_enemies = GetEntArray( "warehouse_2F_enemy", "script_noteworthy" );
	a_ai_warehouse_enemies = array::remove_dead( a_ai_warehouse_enemies, false );
	array::thread_all( a_ai_warehouse_enemies, &warehouse_enemy_goto, false );
}

function warehouse_enemy_goto( on_ground_floor )	// self == a warehouse enemy
{
	if( math::cointoss() && math::cointoss() )	// 25% chance
	{
		if( on_ground_floor )
		{
			self setgoal_ignore_enemies( level.a_nd_warehouse_1F_goto_back );
		}
		else
		{
			self setgoal_ignore_enemies( level.a_nd_warehouse_2F_goto_back );
		}
	}
	else		// 75% chance
	{
		if( on_ground_floor )
		{
			self setgoal_ignore_enemies( level.a_nd_warehouse_1F_goto_front );
		}
		else
		{
			self setgoal_ignore_enemies( level.a_nd_warehouse_2F_goto_front );
		}
	}
}

function warehouse_last_enemies_cleared()
{
	level flag::set( "foundry_remote_hijack_enabled" );	// this flag enabled the "foundry_start" trigger
	nd_diaz_explaindrones_goto = GetNode( "diaz_explaindrones_goto", "targetname" );
	level.ai_diaz SetGoal( nd_diaz_explaindrones_goto );
}

function close_heavy_doors( is_for_skipto = false )
{
	e_foundry_door = GetEnt( "warehouse_exit_heavy_door", "targetname" );
	e_vat_room_door = GetEnt( "foundry_exit_heavy_door", "targetname" );
	
	n_closing_time = ( is_for_skipto ? 0.1 : 8 / 2 );
	
	e_foundry_door MoveZ( -192, n_closing_time );
	e_vat_room_door MoveZ( -192, n_closing_time );
}

//----------------------------------------------------------------------------
// FOUNDRY AREA
//
function foundry_area()
{
	level flag::init( "flag_hijack_complete" );
	
	// foundry area spawn funcs
	spawner::add_spawn_function_group( "foundry_enemy_area01", "script_noteworthy", &adjust_goal_radius, 640 );
	spawner::add_spawn_function_group( "foundry_enemy_catwalk01", "script_noteworthy", &adjust_goal_radius, 640 );
	spawner::add_spawn_function_group( "foundry_enemy_catwalk02", "script_noteworthy", &adjust_goal_radius, 640 );
	spawner::add_spawn_function_group( "foundry_enemy_bunker01", "script_noteworthy", &adjust_goal_radius, 640 );
	spawner::add_spawn_function_group( "foundry_enemy_bunker02", "script_noteworthy", &adjust_goal_radius, 640 );
	spawner::add_spawn_function_group( "foundry_enemy_bunker03", "script_noteworthy", &adjust_goal_radius, 640 );
	
	foreach( player in level.players )
	{
		player thread player_hijack_watcher();
		player cybercom_gadget::giveAbility( "cybercom_hijack", false );
		player cybercom_gadget::equipAbility( "cybercom_hijack" );
	}
	callback::on_spawned( &player_hijack_watcher );
		
	level.a_hijacked_vehicle_owner = [];
	level.a_str_force_exited_vehicle_names = [];
	level.a_veh_hijacked = [];
	
	
	level thread diaz_tutorial_and_talking();
		
	setup_red_barrels();
	setup_destroyable_vats( "foundry" );
	setup_destroyable_conveyor_belt_vats( "foundry" );

	// Warehouse doors
	setup_heavy_door( "warehouse_exit_heavy_door" );
	setup_heavy_door( "foundry_exit_heavy_door" );
	level thread open_door_to_junkyard_after_hijack();
	level thread foundry_heavy_door_and_generator();	// open heavy doors when generator is "destroyed"
	// since vehicle triggers in Foundry respond to Diaz's wasp, we need to check that triggers were entered by player hijacked vehicle and NOT Diaz's wasp
	level thread foundry_player_only_triggers( "diaz_message_junkyard" );
	level thread foundry_player_only_triggers( "foundry_entered" );
	level thread foundry_player_only_triggers( "foundry_area_1_moveup" );
	level thread foundry_player_only_triggers( "foundry_area_2_moveup" );
	level thread foundry_player_only_triggers( "foundry_area_3_moveup" );
	level thread foundry_player_only_triggers( "foundry_area_4_moveup" );
	level thread foundry_player_only_triggers( "foundry_last_stand" );
	// enemy movements are controlled by players moving through triggers in Foundry
	level thread foundry_enemy_movements();
	level thread foundry_force_vehicle_exit_trigger();
	
	spawn_manager::enable( "sm_foundry_enemies" );
	scene::init( "cin_new_03_02_factoryraid_vign_explaindrones" );
	
	level thread spawn_manager::run_func_when_cleared( "sm_foundry_enemies", &foundry_enemies_cleared );
}

function diaz_tutorial_and_talking()
{
	s_objective_3 = struct::get( "objective_foundry_waypoint", "targetname" );
	objectives::set( "cp_level_newworld_factory_waypoint", s_objective_3 );	
	objectives::complete( "cp_level_newworld_factory_waypoint" );
	s_objective_4 = struct::get( "objective_hijack_drone", "targetname" );
	objectives::set( "cp_level_newworld_factory_hijack", s_objective_4 );	
			
	nd_diaz_explaindrones_goto = GetNode( "diaz_explaindrones_goto", "targetname" );
	level.ai_diaz SetGoal( nd_diaz_explaindrones_goto );
	level.ai_diaz waittill( "goal" );
	scene::add_scene_func("cin_new_03_02_factoryraid_vign_explaindrones", &diaz_wasp_spawner, "done" );
	thread scene::play( "cin_new_03_02_factoryraid_vign_explaindrones" );
	level.ai_diaz dialog::say( "Use Remote Hijack to take control of enemy drones from a distance." );
	level thread show_hijacking_hint();
	
	level notify( "open_junkyard_door" );
		
	level waittill( "diaz_wasp_spawned" );// the notify fires in the diaz wasp spawner function
	level thread diaz_wasp_controller();
	
	flag::wait_till( "flag_hijack_complete" );
	objectives::complete( "cp_level_newworld_factory_hijack" );
	s_objective_5 = struct::get( "objective_generator_destroy", "targetname" );
	objectives::set( "objective_generator_destroy", s_objective_5 );
	
	level waittill( "diaz_message_junkyard_by_player" );
	level.ai_diaz dialog::say( "Thin out the enemy presence in the Foundry." );
}
	
function show_hijacking_hint()
{
	level thread util::screen_message_create( &"CP_MI_ZURICH_NEWWORLD_USE_CYBERCORE", undefined, undefined, 0, 6 );
	util::waittill_any_timeout( 6, "player_hijacked_vehicle" );
	util::screen_message_delete();
}

function player_hijack_watcher() 	// self == a player
{
	self endon( "disconnect" );
	level endon( "foundry_complete" );
	
	while( true )
	{
		self waittill( "ClonedEntity", e_clone );
		
		if( isdefined( e_clone.targetname ) && IsSubStr( e_clone.targetname, "hijack_" ) )	// if it's a Foundry hijackable vehicle 
		{
			level.a_hijacked_vehicle_owner[ e_clone.targetname ] = self;	// unused for now but seems like handy info
			self cybercom_gadget_security_breach::setAnchorVolume( GetEnt( "hijacked_vehicle_range", "targetname" ) );	// TODO: anchor volume settings need adjusting
			e_clone.overrideVehicleDamage = &callback_foundry_vehicle_damage;
			array::add( level.a_veh_hijacked, e_clone );
			e_clone thread hijacked_vehicle_death_watch();
			level flag::set( "flag_hijack_complete" ); //for the objective
			level notify( "player_hijacked_vehicle" );	// stop showing hijacking hint message
			
			// Makes sure the player has no cooldown when using Remote Hijack on these vehicles
			self waittill( "return_to_body" );
			self waittill( "transition_done" );
			wait 0.1;
			self GadgetPowerChange( 0, 100 );
		}
	}
}

//todo: get a function to mark each drone and track it.
function objective_hijack_drone_markers()
{
	level.a_drone_hijack_markers = GetEntArray( "foundry_hackable_vehicle", "script_noteworthy");
		foreach (e_drone in level.a_drone_hijack_markers)
		{
			objectives::set( "cp_level_newworld_factory_hijack", e_drone );
		}
	
	level waittill( "player_hijacked_vehicle" );
	
	objectives::complete( "cp_level_newworld_factory_hijack" );
}
	

// used when vehicles are spawned so players can't destroy them accidentally
function callback_foundry_no_vehicle_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal ) 
{
	iDamage = 0;
	return iDamage;
}
// used when vehicles are being driven by players because otherwise they die too easily
function callback_foundry_vehicle_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal ) 
{
	iDamage *= 0.1;
	return iDamage;
}

function hijacked_vehicle_death_watch()	// self == a hijacked vehicle
{
	self waittill( "death" );
	if( isdefined( level.a_hijacked_vehicle_owner[ self.targetname ] ) )
	{
		level.a_hijacked_vehicle_owner[ self.targetname ] GadgetPowerChange (0, 100); 
		level.a_hijacked_vehicle_owner[ self.targetname ] GadgetPowerChange (1, 80);
		level.a_hijacked_vehicle_owner = array::remove_index( level.a_hijacked_vehicle_owner, self.targetname, true );
	}
}


function diaz_wasp_controller()
{
	vh_wasp = level.vh_diaz_wasp; //this guy is spawned in the scene played from diaz_tutorial_and_talking function
	
	//first navigate the junkyard
	vh_wasp vehicle::get_on_and_go_path( GetVehicleNode( "junkyard_diaz_wasp_path_1", "targetname" ) );

	//then interior
	vh_wasp vehicle_ai::stop_scripted( "combat" );
	vh_wasp SetGoal( GetEnt( "foundry_diaz_wasp_area_1", "targetname" ) );
	level waittill( "foundry_area_1_moveup_by_player" );
	
	vh_wasp SetGoal( GetEnt( "foundry_diaz_wasp_area_2", "targetname" ) );
	level waittill( "foundry_area_2_moveup_by_player" );

	vh_wasp SetGoal( GetEnt( "foundry_diaz_wasp_area_3", "targetname" ) );
	level waittill( "foundry_area_3_moveup_by_player" );
	
	vh_wasp SetGoal( GetEnt( "foundry_diaz_wasp_area_4", "targetname" ) );
	level waittill( "foundry_area_4_moveup_by_player" );
	
	util::waittill_any( "foundry_enemies_cleared", "foundry_door_opened" );
	vh_wasp.overrideVehicleDamage = undefined;
	vh_wasp Kill();
}

function open_door_to_junkyard_after_hijack()
{
	util::waittill_either( "player_hijacked_vehicle", "open_junkyard_door" );
	level thread foundry_entrance_objective();
	
	e_foundry_door = GetEnt( "fake_foundry_door", "targetname" );
	e_foundry_door MoveZ( 192, 8 );
	e_foundry_door waittill( "movedone" );
	e_foundry_door Delete();
}

function foundry_entrance_objective()
{
	objectives::set( "cp_level_newworld_factory_waypoint", struct::get( "objective_foundry_entrance", "targetname" ) );
	level waittill( "foundry_entered_by_player" );
	objectives::complete( "cp_level_newworld_factory_waypoint" );
}

function foundry_player_only_triggers( str_t_name_and_notify )
{
	t_to_check = GetEnt( str_t_name_and_notify, "targetname" );
	is_player = false;
	is_player_vehicle = false;
	while( !is_player && !is_player_vehicle )
	{
		t_to_check waittill( "trigger", e_triggerer );
		str_index = e_triggerer.targetname;
		is_player = IsPlayer( e_triggerer );
		if( level.a_hijacked_vehicle_owner.size )
		{
			is_player_vehicle = ( isdefined( level.a_hijacked_vehicle_owner[ str_index ] ) && IsPlayer( level.a_hijacked_vehicle_owner[ str_index ] ) );
		}
		else
		{
			is_player_vehicle = false;
		}
	}
	level notify( str_t_name_and_notify + "_by_player" );	// adding "_by_player" to the notify to make it explicit that player triggered it
}

function foundry_enemy_movements()
{
	level endon( "foundry_enemies_cleared" );
	level endon( "start_inside_man_igc" );
	
	level waittill( "foundry_area_2_moveup_by_player" );
	a_foundry_enemies = get_all_foundry_enemies();
	nd_move_up = GetNode( "foundry_turn01_move_up", "targetname" );
	array::thread_all( a_foundry_enemies, &setgoal_ignore_enemies, nd_move_up );

	level waittill( "foundry_area_4_moveup_by_player" );
	a_foundry_enemies = get_all_foundry_enemies();
	nd_move_up = GetNode( "foundry_turn02_move_up", "targetname" );
	array::thread_all( a_foundry_enemies, &setgoal_ignore_enemies, nd_move_up );
	
	level waittill( "foundry_last_stand_by_player" );
	a_foundry_enemies = get_all_foundry_enemies();
	nd_move_up = GetNode( "foundry_last_stand_move_up", "targetname" );
	array::thread_all( a_foundry_enemies, &setgoal_ignore_enemies, nd_move_up );
	
	level waittill( "foundry_door_opened" );
	a_foundry_enemies = get_all_foundry_enemies();
	nd_move_up = GetNode( "foundry_enemies_post_generator_retreat", "targetname" );
	array::thread_all( a_foundry_enemies, &setgoal_ignore_enemies, nd_move_up );		
}

function get_all_foundry_enemies()
{
	a_foundry_enemies = GetEntArray( "foundry_enemy_area01", "script_noteworthy" );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_area03", "script_noteworthy" ), false, false );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_bunker01", "script_noteworthy" ), false, false );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_bunker02", "script_noteworthy" ), false, false );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_bunker03", "script_noteworthy" ), false, false );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_catwalk01", "script_noteworthy" ), false, false );
	a_foundry_enemies = ArrayCombine( a_foundry_enemies, GetEntArray( "foundry_enemy_catwalk02", "script_noteworthy" ), false, false );
	return a_foundry_enemies;
}

function foundry_enemies_cleared()
{
	level notify( "foundry_enemies_cleared" );
}

function warp_players_for_good_view_through_warehouse_door()
{
	a_s_warp_pos = struct::get_array( "post_hijack_player_warpto" );

	n_count = 0;
	foreach( player in level.a_hijacked_vehicle_owner )
	{
		player thread delay_and_warp( a_s_warp_pos[ n_count ], 4.2 );	// TODO: would be better if there was a notify when players are returned to their bodies
		n_count++;
	}
}

function delay_and_warp( s_warp_pos, n_delay )	// self == a player
{
	wait n_delay;	// this delay covers the time it takes for the screen to fuzz out after exiting a vehicle
	self SetOrigin( s_warp_pos.origin );
	self SetPlayerAngles( s_warp_pos.angles );
}

// TODO: this whole thing won't be necessary once anchor volumes are working correctly & we can rely on that to force players out of vehicles
function foundry_force_vehicle_exit_trigger()
{
	level endon( "start_inside_man_igc" );
	t_foundry_exit = GetEnt( "foundry_force_vehicle_exit_trigger", "targetname" );
	
	while( true )
{
		b_continue_to_kill = true;
		t_foundry_exit waittill( "trigger", veh_hijacked );
		
		// trigger responds every frame to a vehicle touching it, even after Kill() has been called, so keep track of who we've "processed" already
		if( IsVehicle( veh_hijacked ) )
		{		
			foreach( force_exited_vehicle_names in level.a_str_force_exited_vehicle_names )
			{
				// using vehicle's targetname because that stays unique. entity #s seemed to be getting recylced for cloned entities, like vehicles
				if( force_exited_vehicle_names == veh_hijacked.targetname )
				{
					b_continue_to_kill = false;
				}
			}
			if( b_continue_to_kill )
			{
				array::add( level.a_str_force_exited_vehicle_names , veh_hijacked.targetname ); //add the name of the vehicle to be killed to the array so we know not to kill it next loop.
				veh_hijacked Kill();
			}
		}
	}
}

function foundry_heavy_door_and_generator()
{
	level waittill( "foundry_area_4_moveup_by_player" );
	t_damage = GetEnt( "foundry_heavy_door_generator", "targetname" );
	a_s_explosions = struct::get_array( "foundry_generator_explosion_pos", "targetname" );
	
	objectives::set( "cp_level_newworld_foundry_destroy_generator", struct::get( "foundry_generator_objective_struct", "targetname" ) );
	t_damage generator_damage_watch();	// blocking call
	
	array::thread_all( a_s_explosions, &generator_explosion );
	RadiusDamage( t_damage.origin, 500, 200, 60, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( t_damage.origin, 500, 500, 1, 200, 60 );
	PlayRumbleOnPosition( "grenade_rumble", t_damage.origin );
	Earthquake( 0.5, 0.5, t_damage.origin, 512 );
	
	objectives::complete( "cp_level_newworld_foundry_destroy_generator" );
	
	level notify( "foundry_door_opened" );
	level thread open_foundry_heavy_door( "foundry_exit_heavy_door" );
	wait 4;	// slight pause so door opening isn't synchronized
	level thread open_foundry_heavy_door( "warehouse_exit_heavy_door" );
	wait 2;	// slight pause before allies start moving up

	t_moveup = GetEnt( "vat_room_color_trigger_start", "targetname" );

	if( isdefined( t_moveup ) )
	{
		trigger::use( "vat_room_color_trigger_start" );
	}
	
	wait 2; //ensure all explosions are done before kicking the player out of the vehicle.
	
	// TODO: Teleporting players' bodies while players were controlling hijacked vehicles did not work.  The players' bodies would remain where they were.
	// Might need code support to get this working properly?  Instead I'm waiting for players to exit their vehicles and return to their bodies,
	//  then teleporting the players to a good position.  This is not smooth and is obviously pretty hacky
	warp_players_for_good_view_through_warehouse_door();
	
	foreach ( veh_jacked in level.a_veh_hijacked )
	{
		if( isdefined( veh_jacked))
		{
			veh_jacked	Kill();
		}
	}
	
	
}

function generator_explosion()	// self == a struct
{
	wait RandomFloatRange( 0, 1.0 );
	PlayFX( level._effect[ "large_explosion" ], self.origin, ( 0, 0, 1 ) );
}

function generator_damage_watch()
{
	n_damage = 0;
	
	while( n_damage < 2100 )
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint );
		n_damage += iDamage;
		/#iPrintLn( " DMG: " + iDamage + " | TOTAL DMG: " + n_damage );#/
		{wait(.05);};
	}
}

function open_foundry_heavy_door( str_name )
{
	mdl_heavy_door = GetEnt( str_name, "targetname" );
	if( isdefined( mdl_heavy_door ) && !mdl_heavy_door.is_moving )
	{
		mdl_heavy_door ConnectPaths();
		mdl_heavy_door.is_moving = true;
		mdl_heavy_door MoveZ( 192, 8 );
		mdl_heavy_door waittill( "movedone" );
	}
}

//----------------------------------------------------------------------------
// VAT ROOM AREA
//
function vat_room()
{
	spawner::add_spawn_function_group( "vat_room_enemy", "script_noteworthy", &adjust_goal_radius, 256 );
	spawner::add_spawn_function_group( "vat_room_auto_turret", "targetname", &vat_room_auto_turret_spawn_func );

	level thread spawn_manager::run_func_when_cleared( "sm_vat_room_enemies", &vat_room_enemies_cleared );
	level thread spawn_manager::run_func_when_cleared( "sm_vat_room_final_suppressors", &vat_room_final_suppressors_cleared );

	remove_ally_bullet_shield( 6 );	
	
	setup_destroyable_conveyor_belt_vats( "vat_room" );	
	vat_room_auto_turrets();
	level thread vat_room_enemy_movement();

	open_vat_room_door( false );	// blocking call
}

function vat_room_enemy_movement()
{
	level endon( "vat_room_enemies_all_dead" );
	trigger::wait_till( "vat_room_advance_trigger_01" );
	vat_room_enemy_goto( 1 );
	trigger::wait_till( "vat_room_advance_trigger_02" );
	vat_room_enemy_goto( 2 );
}

function vat_room_enemy_goto( n_loop_count )
{
	a_ai_enemies = GetEntArray( "vat_room_enemy", "script_noteworthy" );
	foreach( ai_enemy in a_ai_enemies )
	{
		if( IsAI( ai_enemy ) && isdefined( ai_enemy.target ) )
		{
			e_goal = vat_room_enemy_goto_get_goal( ai_enemy.target );
			for( i = 1; i <= n_loop_count; i++ )
			{
				if( isdefined( e_goal.target ) )
				{
					e_goal = vat_room_enemy_goto_get_goal( e_goal.target );
				}
			}
			ai_enemy SetGoal( e_goal );
		}
	}
}

function vat_room_enemy_goto_get_goal( str_goal_name )
{
	if( IsSubStr( str_goal_name, "goal_vol" ) )
	{
		return GetEnt( str_goal_name, "targetname" );
	}
	if( IsSubStr( str_goal_name, "goal_node" ) )
	{
		return GetNode( str_goal_name, "targetname" );
	}
	return undefined;	
}

function open_vat_room_door( b_from_skip_to )
{
	e_vat_room_door = GetEnt( "vat_room_exit_door", "targetname" );
	
	if( !b_from_skip_to )
	{
		objectives::set( "cp_level_newworld_factory_waypoint", e_vat_room_door );
		level util::waittill_multiple( "vat_room_enemies_all_dead", "vat_room_final_suppressors_all_dead", "vat_room_turrets_all_dead" );
		
		// check to see if all closet spawner enemies are dead (closet spawner enemies are irregularly spawned)
		a_ai_remaining = GetEntArray( "vat_room_enemy", "script_noteworthy" );
		a_ai_remaining = array::remove_dead( a_ai_remaining, false );	// filter out spawners
		while( a_ai_remaining.size )
		{
			wait 1;	// slow loop is ok
			a_ai_remaining = GetEntArray( "vat_room_enemy", "script_noteworthy" );
			a_ai_remaining = array::remove_dead( a_ai_remaining, false );
		}
		
		objectives::complete( "cp_level_newworld_factory_waypoint" );
	}
	
	e_vat_room_door MoveZ( 192, 8 );
	e_vat_room_door ConnectPaths();
}

function vat_room_auto_turrets()
{
	level.a_vat_room_turrets = spawner::simple_spawn( "vat_room_auto_turret" );
	array::thread_all( level.a_vat_room_turrets, &track_vat_room_turret_deaths );
}

function track_vat_room_turret_deaths()	// self == vat room turret
{
	self waittill( "death" );
	ArrayRemoveValue( level.a_vat_room_turrets, self );
	
	if( !level.a_vat_room_turrets.size )
	{
		level notify( "vat_room_turrets_all_dead" );	
	}
}

function vat_room_enemies_cleared()
{
	level notify( "vat_room_enemies_all_dead" );
}

function vat_room_final_suppressors_cleared()
{
	level notify( "vat_room_final_suppressors_all_dead" );
}


//----------------------------------------------------------------------------
// INSIDE MAN IGC
//
function watch_ptsd_trigger()	// monitor the PTSD trigger
{
	level endon( "start_inside_man_igc" );
	
	t_do_ptsd = GetEnt( "do_ptsd_trigger", "targetname" );
	
	while( isdefined( t_do_ptsd ) )
	{
		t_do_ptsd waittill( "trigger", e_toucher );
		if( IsPlayer( e_toucher ) )
		{
			if( !isdefined( e_toucher.doing_ptsd ) || !e_toucher.doing_ptsd )
			{
				e_toucher thread ptsd_screen_fades( t_do_ptsd );
			}
		}
		
		wait 0.2;
	}
}

function ptsd_screen_fades( t_do_ptsd )	// self == a player
{
	level endon( "start_inside_man_igc" );	// this shouldn't be necessary, but just in case
	self endon( "death" );

	self.doing_ptsd = true;
	level flag::set_val( "ptsd_active", true );
	
	while( self IsTouching( t_do_ptsd ) )
	{
		self clientfield::set_to_player( "hijack_static_effect", 27 );
	
		self Shellshock( "default", 1 );
		wait RandomFloatRange( 0.1, 0.4 );  // Hold to give player a scene to absorb what is going on.
		
		self clientfield::set_to_player( "hijack_static_effect", 0 );

		wait RandomFloatRange( 0.6, 3.0 );
	}

	self.doing_ptsd = false;
}

function ptsd_status()
{
	level endon( "start_inside_man_igc" );

	while( true )
	{
		if( level flag::get( "ptsd_area_clear" ) )	// only do checks if no players are inside the PTSD trigger
		{
			cur_ptsd_status = false;
			foreach( player in level.players )
			{
				if( isdefined( player.doing_ptsd ) && player.doing_ptsd )
				{
					cur_ptsd_status = true;
				}
			}
			
			level flag::set_val( "ptsd_active", cur_ptsd_status );
		}
		wait 0.2;
	}
}


//----------------------------------------------------------------------------
// UTIL
//
function common_startup_tasks( str_objective )
{	
	level.ai_diaz = util::get_hero( "diaz" );
	skipto::teleport_ai( str_objective );
	objectives::set( "cp_level_newworld_factory_uncover_plan" );
}

function spawn_allies( str_area, b_do_color_chain = true )
{
	a_ally_spawners = GetEntArray( str_area + "_area_ally_spawner", "script_noteworthy" );
	switch( str_area )
	{
		case "intro":
			spawner::add_spawn_function_group( "friendly_left", "script_string" , &set_threat_bias );
			spawner::add_spawn_function_group( "friendly_right", "script_string" , &set_threat_bias );		
		break;
		case "alley":
		break;
	}
	
	level.a_ai_allies = spawner::simple_spawn( a_ally_spawners, &ally_setup );
	
	if( b_do_color_chain )
	{
		trigger::use( str_area + "_color_trigger_start" );
	}
}

function remove_ally_bullet_shield( n_count )
{
	level.a_ai_allies = array::remove_dead( level.a_ai_allies );
	if( level.a_ai_allies.size > n_count )
	{
		for( i = 0; i < n_count; i++ )
		{
			ai_ally = array::random( level.a_ai_allies );
			ai_ally util::stop_magic_bullet_shield();
		}
	}
	else
	{
		foreach( ai_ally in level.a_ai_allies )
		{
			ai_ally util::stop_magic_bullet_shield();
		}
	}
}

function ally_setup()
{
	self util::magic_bullet_shield();
}

//    Link the player to a tag_origin, then you can keep the player there or move it around
//    b_look - allow the player to look around (default: false)
//    n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom - angle clamp values to use (b_look must be TRUE)
function player_stick( b_look = false, n_clamp_right, n_clamp_left, n_clamp_top, n_clamp_bottom )	//    self is the player
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
function player_unstick()	//    self is the player
{
    if ( isdefined( self.m_link ) )
    {
        self.m_link Delete();
        self AllowSprint( true );
    }
}

function adjust_goal_radius( n_new_rad )	// self == an AI
{
	self.goalradius = n_new_rad;
}

function setgoal_ignore_enemies( nd_goto )	// self == an AI
{
	self endon( "death" );	// endon, just in case something goes wrong with the timeout below
	if( !IsAI( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	// random pause so enemies won't simultaneously do the same thing
	wait( RandomFloatRange( 0.0, 10.0 ) );

	// force AI to ignore players & move, until they're damaged or too close to a player
	self ai::set_ignoreall( true );
	if( !IsArray( nd_goto ) )
	{
		self SetGoal( nd_goto );
	}
	else
	{
		self SetGoal( array::random( nd_goto ) );
	}
	
	self thread enemy_prox_check( 8 );
	self util::waittill_any_timeout( 8, "enemy_prox_enter_combat", "damage" );
	self ai::set_ignoreall( false );
}

function enemy_prox_check( n_check_time )	// self == an enemy
{
	self endon( "death" );
	n_timer = 0;
	while( n_timer < n_check_time )
	{
		foreach( player in level.players )
		{
			if( DistanceSquared( self.origin, player.origin ) < 90000 )
			{
				self notify( "enemy_prox_enter_combat" );
				return;
			}
		}
		wait 0.2;	// loop delay
		n_timer += 0.2;
	}
}

function spawn_hijack_vehicles()
{
	a_hijack_vehicle_spawners = GetEntArray( "foundry_hackable_vehicle", "script_noteworthy" );
	a_vh_hijack = spawner::simple_spawn( a_hijack_vehicle_spawners, &usable_vehicle_spawn_func );
}

function all_players_force_exit_all_vehicles()
{
	foreach ( player in level.players )
	{
		player force_exit_vehicle();
	}
}

function force_exit_vehicle()	// self == a player
{
	if ( self IsInVehicle() )
	{
		vh_occupied = self GetVehicleOccupied();
		//vh_occupied FreeVehicle();	// TODO: use this for real hijacked vehicles
		
		n_seat = vh_occupied GetOccupantSeat( self );
				
		vh_occupied UseVehicle( self, n_seat );  // make player exit vehicle
	}
}

function setup_heavy_door( str_door_name )
{
	mdl_heavy_door = GetEnt( str_door_name, "targetname" );
	mdl_heavy_door.is_moving = false;
	mdl_heavy_door DisconnectPaths();
}

//----------------------------------------------------------------------------
// RED BARRELS
//
function setup_red_barrels()
{
	a_red_barrels = GetEntArray( "red_barrel", "script_noteworthy" );
	foreach( e_red_barrel in a_red_barrels )
	{
		e_red_barrel SetCanDamage( true );
		e_red_barrel.health = 120;
		e_red_barrel thread red_barrel_explode();
	}
}

function red_barrel_explode()	// self == a "red barrel"
{
	self waittill( "death" );
		
	v_origin = self.origin + ( 0, 0, 10 );

	self RadiusDamage( v_origin, 180, 100, 30, undefined, "MOD_EXPLOSIVE" );
	PhysicsExplosionSphere( v_origin, 180, 180, 1, 100, 30 );
	PlayRumbleOnPosition( "grenade_rumble", v_origin );
	Earthquake( 0.5, 0.5, self.origin, 512 );
	PlayFX( level._effect[ "large_explosion" ], v_origin, ( 0, 0, 1 ) );
	self Delete();
}

//----------------------------------------------------------------------------
// DESTROYABLE VATS
//
function setup_destroyable_vats( str_location )
{
	a_e_vats = GetEntArray( str_location + "_destroyable_vat", "targetname" );
	array::thread_all( a_e_vats, &destroyable_vat );
}

function setup_destroyable_conveyor_belt_vats( str_location )
{
	a_e_vats = GetEntArray( str_location + "_destroyable_conveyor_belt_vat", "targetname" );
	array::thread_all( a_e_vats, &conveyor_belt_vat_spawner );
}

function conveyor_belt_vat_spawner()	// self == vat
{
	while( isdefined( self ) )
	{
		e_vat = spawn( "script_model", self.origin );
		e_vat.angles = self.angles;
		e_vat SetModel( "p7_industrial_bucket_large" );
		e_vat SetScale( 0.82 );
		e_vat.target = self.target;
		e_vat.script_objective = self.script_objective;
		
		e_vat thread destroyable_vat();
		
		wait self.script_float;
	}
}

function destroyable_vat()	// self == vat
{
	self endon( "death" );
	self SetCanDamage( true );
	self.health = 10000;
	self thread vat_mover();
	
	self.n_hit_count = 0;
	self.n_damage_tracker = 0;
	
	self thread destroyable_vat_sway();
	
	while( true )
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint );
		self.health = 10000;
		self.n_damage_tracker += iDamage;
		self.n_hit_count++;
		self thread reset_damage_after_pause();	// require players to damage vats all at once to make the "lava" "spill"
		if( self.n_damage_tracker > 350 )
		{
			self.n_damage_tracker = 350;	// limit this value since it's used in destroyable_vat_sway() for rotating the vat
			n_lava_drops = RandomIntRange( 2, 5 );
			// TODO: figure out why these magic grenades do no damage to enemies
			for( i = 0; i < n_lava_drops; i++ )
			{
				n_fuse_time = RandomFloatRange( 0.6, 2.0 );
				e_grenade = level.players[ 0 ] MagicGrenadeType( 	GetWeapon( "molotov_grenade" ), self.origin - ( 0, 0, 50 ),
																( 	RandomFloatRange( -200, 200 ), 
																	RandomFloatRange( -200, 200 ), -1 ), n_fuse_time );
				e_grenade thread vat_molten_metal_damage( n_fuse_time );
			}
			wait 3.0;
			self.n_damage_tracker = 0;
		}
	}	
}

function destroyable_vat_sway()	// self == vat
{
	while( isdefined( self ) )
	{
		self RotateTo( ( 0, 0, self.n_damage_tracker * 0.2 ), 0.1 );

		wait 0.1;
	}
}

function vat_molten_metal_damage( n_fuse_time )	// self == molotov grenade used as placeholder for molten metal
{
	// TODO: investigate why self waittill( "explode" ) doesn't work here
	while( isdefined( self ) )	// continuously track grenade's position before it explodes
	{
		v_gren_pos = self.origin;
		{wait(.05);};
	}
	// initial damage when grenade explodes
	RadiusDamage( v_gren_pos, 150, 100, 200, undefined, "MOD_EXPLOSIVE" );
	t_damage = spawn( "trigger_radius", v_gren_pos, 1 + 2 
												+ 	8 + 16, 
													150, 150 );
	// damage for the fire created by grenade explosion
	t_damage thread molten_metal_damage_trigger();
	wait 7;
	t_damage util::self_delete();
}

function molten_metal_damage_trigger()	// self == damage trigger for "molten metal"
{
	self endon( "death" );
	while( isdefined( self ) )
	{
		self waittill( "trigger", guy );
		guy DoDamage( 10, guy.origin, self, self, "none", "MOD_EXPLOSIVE" );
	}
}

function reset_damage_after_pause()
{
	self endon( "death" );
	n_saved_hit_count = self.n_hit_count;
	wait 0.4;	// if vat isn't damaged for this delay's period of time, reset the damage
	if( n_saved_hit_count == self.n_hit_count )
	{
		self.n_damage_tracker = 0;
	}
}

function vat_mover()	// self == vat
{
	self endon( "death" );
	
	a_move_path = [];
	n_move_path_index = 0;
	reverse_path = false;
	if( isdefined( self.target ) )
	{
		s_move_to = struct::get( self.target );
		array::add( a_move_path, s_move_to );
		self.origin = s_move_to.origin;
		self.angles = s_move_to.angles;
		while( isdefined( s_move_to ) && isdefined( s_move_to.target ) )
		{
			s_move_to = struct::get( s_move_to.target );		
			array::add( a_move_path, s_move_to );
		}
		while( true )
		{
			n_move_time = Distance( self.origin, a_move_path[ n_move_path_index ].origin ) / 80;
			n_move_time = ( n_move_time > 0 ? n_move_time : 0.1 );
			self MoveTo( a_move_path[ n_move_path_index ].origin, n_move_time );
			self waittill( "movedone" );
			
			n_move_path_index = ( reverse_path ? n_move_path_index - 1 : n_move_path_index + 1 );
			if( n_move_path_index >= a_move_path.size )
			{
				if( isdefined( self.script_noteworthy ) )
				{
					if( self.script_noteworthy == "reverse_path" )
					{
						reverse_path = true;
						n_move_path_index = n_move_path_index - 2;
					}
					else if( self.script_noteworthy == "loop_path" )
					{
						n_move_path_index = 0;
					}
				}
				else
				{
					self util::self_delete();
				}
			}
			else if( n_move_path_index < 0 )
			{
				reverse_path = !reverse_path;
				n_move_path_index = 1;
			}
		}
	}
}

/#
function debug_damage_watcher( str_name )	// self == damageable object
{
	self endon( "death" );
	while( true )
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint );
		/#iPrintLn( str_name + " DMG: " + iDamage + " | HP: " + self.health );#/
		{wait(.05);};
	}
}
#/


//----------------------------------------------------------------------------
// SPAWN FUNCTIONS
//
function alley_enemy_spawn_func( n_new_rad, left_side_enemy )	// self == enemy spawned inside warehouse area to fall back into alley
{
	self adjust_goal_radius( n_new_rad );
	
	if( left_side_enemy )
	{
		self SetGoal( level.nd_alley_enemy_goto_left );
	}
	else
	{
		self SetGoal( level.nd_alley_enemy_goto_right );
	}	
}

function alley_reinforcement_enemy_spawn_func( n_new_rad, left_side_enemy )	// self == enemy spawned in factory that moves up into alley
{
	self adjust_goal_radius( n_new_rad );
	
	if( left_side_enemy )
	{
		self SetGoal( GetNode( "alley_reinforcement_enemy_left_initial_goto", "targetname" ) );	//level.nd_alley_enemy_goto_left );
	}
	else
	{
		self SetGoal( GetNode( "alley_reinforcement_enemy_right_initial_goto", "targetname" ) );	//level.nd_alley_enemy_goto_right );
	}	
}

function warehouse_enemy_spawn_func( n_new_rad, on_ground_floor )	// self == enemy spawned in warehouse
{
	self adjust_goal_radius( n_new_rad );
	if( !isdefined( self.target ) )
	{
		self warehouse_enemy_goto( on_ground_floor );
		
		// TODO - make sure this is necessary
		self.script_accuracy = .5;
	}
}

function usable_vehicle_spawn_func()	// self == spawned vehicle
{
	self.goalradius = 64;
	self DisableAimAssist();
	self SetGoal( self.origin, true );
	v_original_pos = self.origin;
	v_original_angles = self.angles;
	
	self vehicle_ai::start_scripted( true );
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.overrideVehicleDamage = &callback_foundry_no_vehicle_damage;	
	
	self thread warp_back_to_start_pos( v_original_pos, v_original_angles );
}

function diaz_wasp_spawner( a_ents)
{
	level.vh_diaz_wasp = a_ents[ "hijack_diaz_wasp_spawnpoint" ];
	level.vh_diaz_wasp vehicle_ai::start_scripted( true );
	level.vh_diaz_wasp.team = "allies";
	level.vh_diaz_wasp.script_objective = "vat_room";
	level.vh_diaz_wasp.overrideVehicleDamage = &callback_foundry_no_vehicle_damage;
	level notify( "diaz_wasp_spawned" );
}


// TODO: remove this when I don't have to hack around to prevent AMWS from wandering around randomly
function warp_back_to_start_pos( v_original_pos, v_original_angles )
{
	self waittill( "goal" );
	self.origin = v_original_pos;
	self.angles = v_original_angles;
}

function vat_room_auto_turret_spawn_func()
{
	
}






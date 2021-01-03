#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_dialog;

#using scripts\cp\cp_mi_cairo_infection_church;
#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cybercom\_cybercom_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           

#namespace village_surreal;

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------

	
// ----------------------------------------------------------------------------
// #precache
// ----------------------------------------------------------------------------
#precache( "model", "p6_wine_bottle" );
#precache( "model", "p7_light_hurricane_lamp" );
#precache( "model", "p7_fxp_debris_newspaper_01" );
#precache( "model", "p7_fxp_debris_newspaper_02" );
#precache( "model", "p7_fxp_debris_newspaper_03" );
#precache( "model", "p7_book_vintage_01" );
#precache( "model", "p7_book_vintage_02" );
#precache( "model", "p7_book_vintage_01_burn" );
#precache( "model", "p7_book_vintage_02_burn " );
#precache( "model", "p7_binoculars" );
#precache( "model", "p7_gas_mask_can" );
#precache( "model", "p7_shovel_trench_kit" );
#precache( "model", "p7_hat_officer_nazi" );
#precache( "model", "p7_breadbag_flat" );
	
// ----------------------------------------------------------------------------
// init_client_field_callback_funcs
// ----------------------------------------------------------------------------
function init_client_field_callback_funcs()
{	
	clientfield::register( "world", "infection_fold_debris_1", 	1, 1, "int" );
	clientfield::register( "world", "infection_fold_debris_2", 	1, 1, "int" );
	clientfield::register( "world", "infection_fold_debris_3", 	1, 1, "int" );
	clientfield::register( "world", "infection_fold_debris_4", 	1, 1, "int" );
	clientfield::register( "world", "light_church_ext_window", 	1, 1, "int" );
	clientfield::register( "world", "light_church_int_all", 	1, 1, "int" );
	clientfield::register( "world", "dynent_catcher",			1, 1, "int" );
}

// ----------------------------------------------------------------------------
// cleanup
// ----------------------------------------------------------------------------
function cleanup( str_objective, b_starting, b_direct, player )
{
	//setup previous objectives as complete	
	objectives::complete( "cp_level_infection_gather_church" );	
}

// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main( str_objective, b_starting )
{
	spawner::add_spawn_function_group( "sp_tiger_tank_fold", "targetname", &spawn_func_tiger_tank );
	spawn_tank();	// Spawn tank first before any other AI because the rider is an expcetion to the global spawn function for axis.
	setup_spawners();
	setup_scene_callbacks();
	
	//teleport coop players to points after shared scene	
	scene::add_scene_func( "cin_inf_11_02_fold_1st_airlock_c", &infection_util::teleport_coop_players_after_shared_cinematic, "done" );

	level.tank_activated = false;
	level.church_mg_support_activated = false;
	
	level thread monitor_t_bank_retreat();
	level thread monitor_t_foy_guys_0_and_1_retreat_2();
	level thread monitor_t_tank();
	level thread monitor_t_sm_fold_guys_4();
	level thread monitor_s_tank_lookat();
	level thread monitor_s_church_lookat();
	level thread monitor_t_church_lookat();
	level thread monitor_t_tank_retreat_1();
	level thread monitor_t_tank_retreat_2();
	level thread monitor_t_tank_retreat_3();
	level thread monitor_t_tank_retreat_4();
	level thread monitor_t_infection_fold_debris_2();
	level thread monitor_t_infection_fold_debris_3();
	level thread monitor_t_infection_fold_debris_4();
	level thread monitor_t_foy_guys_0_and_1_retreat();
	level thread monitor_t_cemetery_retreat();
	level thread infection_util::monitor_spawner_and_trigger_reinforcement( "sm_fold_guys_1", "sm_fold_guys_tank", "t_sm_fold_guys_1_reinforce", 5, 2);
	
	altered_gravity_enable( true );

	init_time_rewind_destruction();
	church::init_church();
	
	level flag::wait_till( "all_players_spawned" );
	spawn_fold_turret_01();
	level thread monitor_t_fold_turret_01_enable();
	
	level clientfield::set( "dynent_catcher", 1 );
	level clientfield::set( "infection_fold_debris_1", 1 );
	
	// Player goes up the wall.
	level scene::play( "cin_inf_11_02_fold_1st_airlock_b" );
	// shared player arrival scene into fold.
	level scene::play( "cin_inf_11_02_fold_1st_airlock_c" );
	level thread infection_util::sarah_objective_move( "t_sarah_fold_objective_", 0,  &sarah_appears_at_church_and_waits_for_players );
	
	util::teleport_players_igc( str_objective );

	level thread spawn_first_attack_wave();

	infection_util::turn_on_snow_fx_for_all_players( 3 );	
	
	wait_for_players_to_enter_church();
}

// ----------------------------------------------------------------------------
//	spawn_fold_turret_01
// ----------------------------------------------------------------------------
function spawn_fold_turret_01()
{
	level.ai_fold_turret_01 = new cFoyTurret();
	
	vh_turret_01 = vehicle::simple_spawn_single( "sp_fold_turret_01" );
	[[level.ai_fold_turret_01]]->turret_setup( vh_turret_01, "sp_fold_turret_01_gunner", "t_fold_turret_01_gunner" );
}

// ----------------------------------------------------------------------------
//	monitor_t_fold_turret_01_enable
// ----------------------------------------------------------------------------
function monitor_t_fold_turret_01_enable()
{
	trigger::wait_till( "t_fold_turret_01_enable" );
	[[level.ai_fold_turret_01]]->gunner_start_think();
}

// ----------------------------------------------------------------------------
//	init_time_rewind_destruction
// ----------------------------------------------------------------------------
function init_time_rewind_destruction()
{
	level.a_m_bank_explode = GetEntArray( "m_bank_explode", "targetname" );	
	infection_util::models_ghost( level.a_m_bank_explode );
	
	level.a_m_fountain_explode = GetEntArray( "m_fountain_explode", "targetname" );	
	infection_util::models_ghost( level.a_m_fountain_explode );
	
	scene::add_scene_func( "p7_fxanim_cp_infection_bank_explode_bundle", 				&callback_show_m_bank_explode, "done" );
	scene::add_scene_func( "p7_fxanim_cp_infection_fountain_explode_bundle", 			&callback_show_m_fountain_explode, "done" );
	
	infection_util::play_scene_on_trigger( "p7_fxanim_cp_infection_bank_explode_bundle", 				"t_infection_bank_explode_bundle" );
	
	// p7_fxanim_cp_infection_fountain_explode_bundle. 111 unsafe frames. 3.7 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_fountain_explode_bundle", "s_infection_fountain_explode_bundle", "t_infection_fountain_explode_bundle_inner", "t_infection_fountain_explode_bundle_outter" );
	
	// p7_fxanim_cp_infection_reverse_wall_02_bundle. 107 unsafe frames. 3.6 sec buffer
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_wall_02_bundle", "s_infection_reverse_wall_02_bundle", "t_infection_reverse_wall_02_bundle_inner", "t_infection_reverse_wall_02_bundle_outter");
	
	// p7_fxanim_cp_infection_reverse_sniper_building_01_bundle. 100 unsafe frames. 3.3 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_sniper_building_01_bundle", 	"s_infection_reverse_sniper_building_01_bundle", "t_infection_reverse_sniper_building_01_bundle_inner", "t_infection_reverse_sniper_building_01_bundle_outter");
	
	// p7_fxanim_cp_infection_reverse_boarding_house_bundle. 171 unsafe frames. 5.7 sec buffer
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_boarding_house_bundle", 	"s_infection_reverse_boarding_house_bundle", "t_infection_reverse_boarding_house_bundle_inner", "t_infection_reverse_boarding_house_bundle_outter");
	
	level scene::init( "p7_fxanim_cp_infection_tank_wall_break_bundle" );
}

// ----------------------------------------------------------------------------
//	callback_show_m_bank_explode
// ----------------------------------------------------------------------------
function callback_show_m_bank_explode( a_ents )
{
	infection_util::models_show( level.a_m_bank_explode );
}

// ----------------------------------------------------------------------------
//	callback_show_m_fountain_explode
// ----------------------------------------------------------------------------
function callback_show_m_fountain_explode( a_ents )
{
	infection_util::models_show( level.a_m_fountain_explode );
}

// ----------------------------------------------------------------------------
//	setup_scene_callbacks
// ----------------------------------------------------------------------------
function setup_scene_callbacks()
{
	scene::add_scene_func( "cin_inf_10_02_bastogne_vign_reversefall2floor_suppressor", 	&callback_reversefall2floor_suppressor, "play" );	
	scene::add_scene_func( "cin_inf_10_02_bastogne_vign_reversemortar2floor_sniper", 	&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_10_02_foy_aie_reverseshot_1_suppressor", 			&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_10_02_foy_aie_reverseshot_5_sniper", 				&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_11_03_fold_vign_reverse_sniper", 					&infection_util::scene_callback_reverse_time_play_foy, "play" );	
}

// ----------------------------------------------------------------------------
//	setup_scene_callbacks
// ----------------------------------------------------------------------------
function callback_reversefall2floor_suppressor( a_ents )
{
	e_volume = GetEnt( "t_sp_fold_guys_2_ai", "targetname" );
	
	foreach ( ent in a_ents )
	{		
		if ( IsActor( ent ) )
		{
			ent infection_util::reverse_time_set_on_ai( false );
			
			ent thread infection_util::set_ai_goto_volume( e_volume );
		}
	}	
}

// ----------------------------------------------------------------------------
//	spawn_first_attack_wave
// ----------------------------------------------------------------------------
function spawn_first_attack_wave()
{
	spawn_manager::enable( "sm_fold_guys_0" );
	
	wait 5.5;
	
	spawn_manager::enable( "sm_fold_guys_1" );
}

// ----------------------------------------------------------------------------
//	altered_gravity_enable
// ----------------------------------------------------------------------------
function altered_gravity_enable( b_enable )
{
	if ( b_enable )
	{
		SetDvar( "phys_gravity_dir", ( 0, 1, 0.1 ) );  // make ragdoll AI and physics objects fall towards players
	}
	else 
	{
		SetDvar( "phys_gravity_dir", ( 0, 0, 1 ) );  // default
	}
}

// ----------------------------------------------------------------------------
//	setup_spawners
// ----------------------------------------------------------------------------
function setup_spawners()
{
	spawner::add_global_spawn_function( "axis", &infection_util::set_goal_on_spawn_foy );
	
	infection_util::enable_exploding_deaths( true, 5 );
	
	infection_util::setup_reverse_time_arrivals( "fold_reverse_anims" );
}

// ----------------------------------------------------------------------------
//	spawn_func_tiger_tank
// ----------------------------------------------------------------------------
function spawn_func_tiger_tank()
{
	level.ai_tiger_tank = new cTigerTank();
	[[level.ai_tiger_tank]]->tiger_tank_setup( self, "sp_tank_gunner", "" );
	[[level.ai_tiger_tank]]->disable_sfx( 1 );
	
	self cybercom::cybercom_AIOptOut("cybercom_hijack");
    self cybercom::cybercom_AIOptOut("cybercom_surge");
}

// ----------------------------------------------------------------------------
//	wait_for_players_to_enter_church
// ----------------------------------------------------------------------------
function wait_for_players_to_enter_church()
{
	level waittill ( "cin_inf_11_04_fold_vign_walk_end_start" );
	
	// Set the objective marker
	s_foy_gather_point_church = struct::get( "s_foy_gather_point_church", "targetname" );
	objectives::set( "cp_level_infection_gather_church", s_foy_gather_point_church );
		
	t_church = GetEnt( "church_interior", "targetname" );
	Assert( IsDefined( t_church ), "church_interior trigger not found!" );

	// wait for all players to be inside church
	t_church waittill( "trigger" );	
	
	objectives::complete( "cp_level_infection_gather_church", s_foy_gather_point_church );
	
	if ( IsDefined( level.ai_tiger_tank ) )
	{
		[[level.ai_tiger_tank]]->delete_ai();
	}
	
	t_church Delete();
	
	altered_gravity_enable( false );
	infection_util::turn_off_snow_fx_for_all_players();	
	infection_util::enable_exploding_deaths( true, 0 );
	spawner::remove_global_spawn_function( "axis", &infection_util::set_goal_on_spawn_foy );
	
	level clientfield::set( "dynent_catcher", 0 );
	level thread skipto::objective_completed( "village_inception" );
}

// ----------------------------------------------------------------------------
// DIALOG: vo tiger tank
// ----------------------------------------------------------------------------
function vo_intro_tiger_tank()
{
	wait 1;
	level.players[0] dialog::say( "hall_the_german_tiger_tan_0", 1.0 ); //The German Tiger Tank. ‘King Tiger’, they called it. Immune to most Munitions. Are you strong enough - to defeat it?
}

// ----------------------------------------------------------------------------
//	spawn_tank
// ----------------------------------------------------------------------------
function spawn_tank()
{	
	spawner::simple_spawn_single( "sp_tiger_tank_fold" );
}

// ----------------------------------------------------------------------------
//	activate_tank
// ----------------------------------------------------------------------------
function activate_tank()
{	
	if ( !level.tank_activated )
	{
		level.tank_activated = true;
		
		t_sarah = GetEnt( "t_sarah_fold_objective_1", "targetname" );
		if ( IsDefined( t_sarah ) )
		{	
			trigger::use( "t_sarah_fold_objective_1" );
		}
		
		level thread vo_intro_tiger_tank();
			
		nd_start = GetVehicleNode( "nd_tank_path", "targetname" );
		
		level thread scene::play( "p7_fxanim_cp_infection_tank_wall_break_bundle" );
		
		[[level.ai_tiger_tank]]->disable_sfx( 0 );
		level.ai_tiger_tank.m_vehicle thread vehicle::get_on_and_go_path( nd_start );
				
		wait 3.5; // Tank doesn't become aggressive right away.
		
		[[level.ai_tiger_tank]]->start_think();
		
		level thread monitor_t_tank_destory();
	}
}

// ----------------------------------------------------------------------------
//	monitor_t_light_church_ext_window_off
// ----------------------------------------------------------------------------
function monitor_t_light_church_ext_window_off()
{
	trigger::wait_till( "t_light_church_ext_window_off" );
	
	level clientfield::set( "light_church_ext_window", 0 );
}
	
// ----------------------------------------------------------------------------
//	monitor_t_tank_destory
// ----------------------------------------------------------------------------
function monitor_t_tank_destory()
{
	while( IsAlive( level.ai_tiger_tank.m_vehicle ) )
	{
		wait 0.1;
	}
	
	wait 3;	// wait a little before spawning guys in the graveyard.
	
	activate_sm_fold_guys_4();
}

// ----------------------------------------------------------------------------
//	monitor_t_tank_retreat_1
// ----------------------------------------------------------------------------
function monitor_t_tank_retreat_1()
{
	level endon ( "tiger_tank_first_retreat" );
	
	trigger::wait_till( "t_tank_retreat_1" );
		
	[[level.ai_tiger_tank]]->retreat_override();
}

// ----------------------------------------------------------------------------
//	monitor_t_tank_retreat_2
// ----------------------------------------------------------------------------
function monitor_t_tank_retreat_2()
{
	trigger::wait_till( "t_tank_retreat_2" );
		
	[[level.ai_tiger_tank]]->retreat_override();
}

// ----------------------------------------------------------------------------
//	monitor_t_tank_retreat_3
// ----------------------------------------------------------------------------
function monitor_t_tank_retreat_3()
{
	level endon ( "tiger_tank_first_retreat" );
	
	trigger::wait_till( "t_tank_retreat_3" );
		
	[[level.ai_tiger_tank]]->retreat_override();
}

// ----------------------------------------------------------------------------
//	monitor_t_tank_retreat_4
// ----------------------------------------------------------------------------
function monitor_t_tank_retreat_4()
{
	trigger::wait_till( "t_tank_retreat_4" );
		
	[[level.ai_tiger_tank]]->retreat_override();
}

// ----------------------------------------------------------------------------
//	monitor_s_tank_lookat
// ----------------------------------------------------------------------------
function monitor_s_tank_lookat()
{
	self endon( "monitor_t_tank" );
	
	array::spread_all( level.players, &infection_util::LookingAtStructDurationCheck, "s_tank_lookat", 2, "lookat_tank" );
	
	level waittill( "lookat_tank" );
	
	level notify( "monitor_s_tank_lookat" );
	
	activate_tank();
}

// ----------------------------------------------------------------------------
//	monitor_s_church_lookat
// ----------------------------------------------------------------------------
function monitor_s_church_lookat()
{
	array::spread_all( level.players, &infection_util::LookingAtStructDurationCheck, "s_church_lookat", 2, "lookat_church", 2600 );
	
	level waittill( "lookat_church" );
	
	activate_church_mg_support();
}

// ----------------------------------------------------------------------------
//	monitor_t_church_lookat
// ----------------------------------------------------------------------------
function monitor_t_church_lookat()
{	
	trigger::wait_till( "t_church_lookat" );
	
	activate_church_mg_support();
}

// ----------------------------------------------------------------------------
//	activate_church_mg_support
// ----------------------------------------------------------------------------
function activate_church_mg_support()
{
	if ( !level.church_mg_support_activated )
	{
		level.church_mg_support_activated = true;
		
		spawner::simple_spawn_single( "sp_chruch_mg_01" );
		spawner::simple_spawn_single( "sp_chruch_mg_02" );
	}
}

// ----------------------------------------------------------------------------
//	monitor_t_tank
// ----------------------------------------------------------------------------
function monitor_t_tank()
{
	self endon( "monitor_s_tank_lookat" );
	
	trigger::wait_till( "t_tank" );
	
	level notify( "monitor_t_tank" );
	
	activate_tank();
}

// ----------------------------------------------------------------------------
//	monitor_t_cemetery_retreat
// ----------------------------------------------------------------------------
function monitor_t_cemetery_retreat()
{
	trigger::wait_till( "t_cemetery_retreat" );
	
	level thread infection_util::set_ai_goal_volume( "sp_fold_guys_tank_ai", "t_sp_fold_guys_3_ai" );
	level thread infection_util::set_ai_goal_volume( "sp_fold_guys_2_ai", "t_sp_fold_guys_3_ai" );	
	
	level thread infection_util::retreat_if_in_volume( "t_foy_guys_0_and_1_retreat_goal_2", "t_sp_fold_guys_3_ai" );
	level thread infection_util::retreat_if_in_volume( "t_sp_fold_guys_2_ai", "t_sp_fold_guys_3_ai" );
}

// ----------------------------------------------------------------------------
//	monitor_t_infection_fold_debris_2
// ----------------------------------------------------------------------------
function monitor_t_infection_fold_debris_2()
{
	trigger::wait_till( "t_infection_fold_debris_2" );
	
	level clientfield::set( "infection_fold_debris_2", 1 );
}

// ----------------------------------------------------------------------------
//	monitor_t_infection_fold_debris_3
// ----------------------------------------------------------------------------
function monitor_t_infection_fold_debris_3()
{
	trigger::wait_till( "t_infection_fold_debris_3" );
	
	level clientfield::set( "infection_fold_debris_3", 1 );
}

// ----------------------------------------------------------------------------
//	monitor_t_infection_fold_debris_4
// ----------------------------------------------------------------------------
function monitor_t_infection_fold_debris_4()
{
	trigger::wait_till( "t_infection_fold_debris_4" );
	
	level clientfield::set( "infection_fold_debris_4", 1 );
}

// ----------------------------------------------------------------------------
//	monitor_t_bank_retreat
// ----------------------------------------------------------------------------
function monitor_t_bank_retreat()
{
	trigger::wait_till( "t_bank_retreat" );
	
	level thread infection_util::retreat_if_in_volume( "t_bank", "t_foy_guys_0_and_1_retreat_goal" );
}

// ----------------------------------------------------------------------------
//	monitor_t_foy_guys_0_and_1_retreat
// ----------------------------------------------------------------------------
function monitor_t_foy_guys_0_and_1_retreat()
{
	trigger::wait_till( "t_foy_guys_0_and_1_retreat" );
	
	level thread infection_util::set_ai_goal_volume( "sp_fold_guys_0_ai", "t_foy_guys_0_and_1_retreat_goal" );
	level thread infection_util::set_ai_goal_volume( "sp_fold_guys_1_ai", "t_foy_guys_0_and_1_retreat_goal" );
	
	wait 5.5;	// Wait for a little and try to force retreat again in case the player trigger the retreat trigger before sp_fold_guys_1_ai were spawned.
	
	level thread infection_util::set_ai_goal_volume( "sp_fold_guys_1_ai", "t_foy_guys_0_and_1_retreat_goal" );
}

// ----------------------------------------------------------------------------
//	monitor_t_foy_guys_0_and_1_retreat_2
// ----------------------------------------------------------------------------
function monitor_t_foy_guys_0_and_1_retreat_2()
{
	trigger::wait_till( "t_foy_guys_0_and_1_retreat_2" );
	
	level thread infection_util::retreat_if_in_volume( "t_foy_guys_0_and_1_retreat_goal", "t_foy_guys_0_and_1_retreat_goal_2" );
}

// ----------------------------------------------------------------------------
//	monitor_t_sm_fold_guys_4
// ----------------------------------------------------------------------------
function monitor_t_sm_fold_guys_4()
{
	trigger::wait_till( "t_sm_fold_guys_4" );
	
	activate_sm_fold_guys_4();
}

// ----------------------------------------------------------------------------
//	activate_sm_fold_guys_4
// ----------------------------------------------------------------------------
function activate_sm_fold_guys_4()
{
	if ( !spawn_manager::is_enabled( "sm_fold_guys_4" ) )
	{
		spawn_manager::enable( "sm_fold_guys_4" );
	}
}
		
// ----------------------------------------------------------------------------
//	scene_callback_foy_sarah_init
// ----------------------------------------------------------------------------
function scene_callback_foy_sarah_init( a_ents )
{
	foreach ( ent in a_ents )
	{
		ent ai::set_ignoreme( true );
	}
}

// ----------------------------------------------------------------------------
//	sarah_appears_at_church_and_waits_for_players
// ----------------------------------------------------------------------------
function sarah_appears_at_church_and_waits_for_players()
{
	// Turn on exploder in church
	level clientfield::set( "light_church_ext_window", 1 );
	level clientfield::set( "light_church_int_all",    1 );

//  Use the exploder light in the church for guidence for now. If that doesnt work, we will re-enable to light pillar on Sarah.
//	scene::add_scene_func( "cin_inf_11_04_fold_vign_walk", &infection_util::callback_scene_objective_light_enable, "init" );
//	scene::add_scene_func( "cin_inf_11_04_fold_vign_walk", &infection_util::callback_scene_objective_light_disable_no_delete, "play" );
		
	s_church_exterior = struct::get( "fold_sarah_objective_church_exterior", "targetname" );
	
	self scene::init( "cin_inf_11_04_fold_vign_walk", self );

	// wait for players to get close
	v_offset = ( 0, 0, -500 );  // offset trigger into the ground since origin of trigger radius is at base
	
	const TRIGGER_RADIUS = 800;
	const TRIGGER_HEIGHT = 1024;
	
	t_radius = infection_util::create_trigger_radius( s_church_exterior.origin + v_offset, TRIGGER_RADIUS, TRIGGER_HEIGHT );
	
	t_radius waittill( "trigger" );
	t_radius Delete();
	
	self sarah_moves_into_church();
}

// ----------------------------------------------------------------------------
//	sarah_moves_into_church
// ----------------------------------------------------------------------------
function sarah_moves_into_church()
{
	self scene::play( "cin_inf_11_04_fold_vign_walk", self );
	self thread scene::play( "cin_inf_11_04_fold_vign_walk_end", self );
	
	wait 0.1; // wait till cin_inf_11_04_fold_vign_walk_end has started.
	
	level notify ( "cin_inf_11_04_fold_vign_walk_end_start" );
}

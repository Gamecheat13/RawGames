#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_infection_village_surreal;
#using scripts\cp\cp_mi_cairo_infection_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           
	
#namespace village;

function autoexec __init__sytem__() {     system::register("infection_village",&__init__,undefined,undefined);    }

// ----------------------------------------------------------------------------
//	__init__
// ----------------------------------------------------------------------------
function __init__()
{
	
}

// ----------------------------------------------------------------------------
// init_client_field_callback_funcs
// ----------------------------------------------------------------------------
function init_client_field_callback_funcs()
{	
	clientfield::register( "world", "fold_earthquake", 1, 1, "int" );
	clientfield::register( "world", "village_mortar_index", 1, 3, "int" );
	clientfield::register( "world", "village_intro_mortar", 1, 1, "int" );
}

// ----------------------------------------------------------------------------
//	cleanup
// ----------------------------------------------------------------------------
function cleanup( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_infection_gather_airlock" );
}

// ----------------------------------------------------------------------------
//	cleanup_house
// ----------------------------------------------------------------------------
function cleanup_house( str_objective, b_starting, b_direct, player )
{
	
}

// ----------------------------------------------------------------------------
//	main
// ----------------------------------------------------------------------------
function main( str_objective, b_starting )
{
	if ( b_starting )
	{
		util::screen_fade_out( 0, "white" );
	}
	
	spawner_setup();
	scene_setup();
	
	level.allies_disadvantage = false;
	level.alert_german = false;

	spawner::add_spawn_function_group( "sp_foy_friendlies_rocket", "targetname", &spawn_func_ally_rocket );
	spawner::add_spawn_function_group( "sp_foy_friendlies", "targetname", &spawn_func_ally );
	spawner::add_spawn_function_group( "sp_foy_friendlies_respawn_1", "targetname", &respawn_func_ally );
	spawner::add_spawn_function_group( "sp_foy_friendlies_respawn_2", "targetname", &respawn_func_ally );
	spawner::add_spawn_function_group( "sp_foy_friendlies_respawn_3", "targetname", &respawn_func_ally );
	
	init_time_rewind_destruction();
	
	skipto::teleport_players( "village" );
	
	level flag::wait_till( "all_players_spawned" );
	
	spawn_foy_turret_01();
	spawn_foy_turret_02();
	spawn_foy_turret_03();
		
	infection_util::turn_on_snow_fx_for_all_players();

	//Hide fold house blocker
	a_blockers = GetEntArray( "foy_gather_point_debris_blocker", "targetname" );
	level thread hide_blocker( a_blockers );
	
	level thread monitor_t_allies_disadvantage();
	level thread foy_intro();
	level thread monitor_t_sm_barn_house_1();
	level thread monitor_t_battlechatter_company_move_1();
	level thread monitor_t_battlechatter_company_move_2();
	level thread monitor_t_battlechatter_company_move_3();
	level thread monitor_t_battlechatter_reclaim_foy();
	level thread monitor_t_foy_turret_01_enable();
	level thread monitor_t_foy_turret_02_spawn();
	level thread monitor_t_foy_turret_03_spawn();
	level thread monitor_t_retreat_sp_wall_fx_german();
	level thread monitor_t_sm_foy_town_waves();
	
	level thread monitor_t_retreat_sp_foy_post_intro_formation_1_ai();
	level thread monitor_t_retreat_sp_barn_house_1_ai();
	level thread monitor_t_retreat_sp_foy_guys_right_ai();
	level thread monitor_t_retreat_sp_foy_town_wave_ai();
	
	level thread foy_folds();
	
	level thread random_battle_effects();
}

// ----------------------------------------------------------------------------
//	main_house
// ----------------------------------------------------------------------------
function main_house( str_objective, b_starting )
{
	level flag::wait_till( "all_players_spawned" );
	
	if ( b_starting )
	{
		objectives::complete( "cp_level_infection_gather_airlock" );
		
		//block player from going back
		a_blockers = GetEntArray( "foy_gather_point_debris_blocker", "targetname" );
		level thread show_blocker( a_blockers );

		level thread house_blocker_activation_from_checkpoint();
		level scene::play( "cin_inf_10_01_foy_vign_walk" );
		level scene::init( "cin_inf_11_02_fold_1st_airlock_a" );	
	
		players_get_on_folded_section();
	}
}

function house_blocker_activation_from_checkpoint()
{
	wait 1.5;	// wait for Sarah to enter the house before trigger the wall to rebuild (for starting from checkpoint ONLY ).
	
	level scene::play( "p7_fxanim_cp_infection_reverse_transition_wall_bundle" );
}

// ----------------------------------------------------------------------------
//	foy_battle_chatter
// ----------------------------------------------------------------------------
function foy_battle_chatter( vo_spoken )
{
	a_ai_array = GetAiTeamArray( "allies" );
	a_speaker = array::get_closest ( level.players[0].origin, a_ai_array );
	
	if ( IsDefined( a_speaker ) )
	{
		a_speaker Notify( "scriptedBC", vo_spoken );
	}
}

// ----------------------------------------------------------------------------
//	monitor_t_allies_disadvantage
// ----------------------------------------------------------------------------
function monitor_t_allies_disadvantage()
{
	trigger::wait_till( "t_allies_disadvantage" );
	
	level.allies_disadvantage = true;
	
	a_ai_array = GetAiTeamArray( "allies" );
	
	foreach ( ai in a_ai_array )
	{
		if ( IsDefined( ai.targetname ) )
		{
			if ( ai.targetname == "sp_foy_friendlies_ai" )
			{
				ai.takedamage = true;
			}
		}
	}
}

// ----------------------------------------------------------------------------
//	monitor_t_battlechatter_reclaim_foy
// ----------------------------------------------------------------------------
function monitor_t_battlechatter_reclaim_foy()
{
	trigger::wait_till( "t_battlechatter_reclaim_foy" );
	
	foy_battle_chatter( "reclaim_foy" );
}

// ----------------------------------------------------------------------------
//	monitor_t_battlechatter_company_move_1
// ----------------------------------------------------------------------------
function monitor_t_battlechatter_company_move_1()
{
	trigger::wait_till( "t_battlechatter_company_move_1" );
	
	foy_battle_chatter( "company_move" );
}

// ----------------------------------------------------------------------------
//	monitor_t_battlechatter_company_move_2
// ----------------------------------------------------------------------------
function monitor_t_battlechatter_company_move_2()
{
	trigger::wait_till( "t_battlechatter_company_move_2" );
	
	foy_battle_chatter( "company_move" );
}

// ----------------------------------------------------------------------------
//	monitor_t_battlechatter_company_move_3
// ----------------------------------------------------------------------------
function monitor_t_battlechatter_company_move_3()
{
	trigger::wait_till( "t_battlechatter_company_move_3" );
	
	foy_battle_chatter( "company_move" );
}

// ----------------------------------------------------------------------------
//	spawn_foy_turret_01
// ----------------------------------------------------------------------------
function spawn_foy_turret_01()
{
	level.ai_foy_turret_01 = new cFoyTurret();
	
	vh_turret_01 = vehicle::simple_spawn_single( "sp_foy_turret_01" );
	[[level.ai_foy_turret_01]]->turret_setup( vh_turret_01, "sp_foy_turret_01_gunner", "t_foy_turret_01_gunner" );
}

// ----------------------------------------------------------------------------
//	spawn_foy_turret_02
// ----------------------------------------------------------------------------
function spawn_foy_turret_02()
{
	level.ai_foy_turret_02 = new cFoyTurret();
	
	vh_turret_02 = vehicle::simple_spawn_single( "sp_foy_turret_02" );
	[[level.ai_foy_turret_02]]->turret_setup( vh_turret_02, "sp_foy_turret_02_gunner", undefined );
}

// ----------------------------------------------------------------------------
//	spawn_foy_turret_03
// ----------------------------------------------------------------------------
function spawn_foy_turret_03()
{
	level.ai_foy_turret_03 = new cFoyTurret();
	
	vh_turret_03 = vehicle::simple_spawn_single( "sp_foy_turret_03" );
	vh_turret_03 SetCanDamage( true );
	vh_turret_03.health = 2000;
	
	[[level.ai_foy_turret_03]]->turret_setup( vh_turret_03, "sp_foy_turret_03_gunner", undefined );
}

// ----------------------------------------------------------------------------
//	monitor_t_foy_turret_01_enable
// ----------------------------------------------------------------------------
function monitor_t_foy_turret_01_enable()
{
	trigger::wait_till( "t_foy_turret_01_enable" );
	[[level.ai_foy_turret_01]]->gunner_start_think();
}

// ----------------------------------------------------------------------------
//	monitor_t_foy_turret_02_spawn
// ----------------------------------------------------------------------------
function monitor_t_foy_turret_02_spawn()
{
	trigger::wait_till( "t_foy_turret_02_spawn" );
	
	level thread foy_turret_doors_open( "turret_door" );
	exploder::exploder( "fx_expl_barn_window_open" );
	
	wait 0.5; // start turret a split second after the door is open.
	
	[[level.ai_foy_turret_02]]->gunner_start_think();
	
	
	wait 1; // wait a little before spawning AIs after the MG turret is already activated.
	
	spawn_manager::enable( "sm_turret_barn_door" );
	
	level thread foy_turret_doors_open( "turret_barn_door" );
	exploder::exploder( "fx_expl_barn_door_open" );
}

// ----------------------------------------------------------------------------
//	monitor_t_foy_turret_03_spawn
// ----------------------------------------------------------------------------
function monitor_t_foy_turret_03_spawn()
{	
	trigger::wait_till( "t_foy_turret_03_spawn" );
	
	spawner::simple_spawn_single( "sp_foy_friendlies_rocket" );
	
	level thread foy_turret_doors_open( "barn_door" );
	
	wait 0.5;
	
	[[level.ai_foy_turret_03]]->gunner_start_think();
	
	exploder::exploder( "fx_expl_mg_bullet_impacts_village01" );
	
	wait 1.5;
	
	exploder::exploder( "fx_expl_mg_bullet_impacts_village02" );

	wait 1.5;
	
	exploder::exploder( "fx_expl_mg_bullet_impacts_village03" );
}

// ----------------------------------------------------------------------------
//	monitor_t_sm_barn_house_1
// ----------------------------------------------------------------------------
function monitor_t_sm_barn_house_1()
{
	trigger::wait_till( "t_sm_barn_house_1" );
	
	foy_turret_doors_open( "barn_lower_door" );
	
	wait 0.25;
	
	spawn_manager::enable( "sm_barn_house_1");
}

function formation_retreat( str_start_nd, n_wait )
{
	//self = ai
	self endon( "death" );
	
	if ( IsDefined( str_start_nd ) )
	{
		e_target = GetNode( str_start_nd, "targetname" );
	}
	
	while ( IsDefined( e_target ) )
	{	
		self SetGoal( e_target );
		self waittill( "goal" );
		self.goalradius = 64;
		
		if ( IsDefined( e_target.target ) )
		{
			wait n_wait;
			e_target = GetNode( e_target.target, "targetname" );
		}
		else
		{
			e_target = undefined;
		}
	}
}

// ----------------------------------------------------------------------------
//	monitor_t_sm_foy_town_waves
// ----------------------------------------------------------------------------
function monitor_t_sm_foy_town_waves()
{
	trigger::wait_till( "t_sm_foy_town_waves" );
	
	spawn_manager::enable( "sm_foy_town_wave_1");
	spawn_manager::enable( "sm_foy_town_wave_2");
	spawn_manager::enable( "sm_foy_town_wave_3");
}

// ----------------------------------------------------------------------------
//	monitor_t_retreat_sp_wall_fx_german
// ----------------------------------------------------------------------------
function monitor_t_retreat_sp_wall_fx_german()
{
	trigger::wait_till( "t_retreat_sp_wall_fx_german" );
	
	level thread infection_util::set_ai_goal_volume( "foy_wall_fx_german_01_ai", "foy_goal_volume_2" );
	level thread infection_util::set_ai_goal_volume( "foy_wall_fx_german_02_ai", "foy_goal_volume_2" );
	level thread infection_util::set_ai_goal_volume( "foy_wall_fx_german_03_ai", "foy_goal_volume_2" );
	level thread infection_util::set_ai_goal_volume( "foy_wall_fx_german_04_ai", "foy_goal_volume_2" );
	
	// Spawn retreat formation guys.
	sp_retreat_01 = spawner::simple_spawn_single( "sp_retreat_01" );
	sp_retreat_01 thread formation_retreat( "nd_retreat_01", 12 );
	
	sp_retreat_02 = spawner::simple_spawn_single( "sp_retreat_02" );
	sp_retreat_02 thread formation_retreat( "nd_retreat_02", 10 );
	
	sp_retreat_03 = spawner::simple_spawn_single( "sp_retreat_03" );
	sp_retreat_03 thread formation_retreat( "nd_retreat_03", 8 );
}
	
// ----------------------------------------------------------------------------
//	monitor_t_retreat_sp_foy_post_intro_formation_1_ai
// ----------------------------------------------------------------------------
function monitor_t_retreat_sp_foy_post_intro_formation_1_ai()
{
	trigger::wait_till( "t_retreat_sp_foy_post_intro_formation_1_ai" );
	
	level thread infection_util::retreat_if_in_volume( "t_sp_foy_post_intro_formation_1_ai", "foy_goal_volume_2" );
}
	
// ----------------------------------------------------------------------------
//	monitor_t_retreat_sp_barn_house_1_ai
// ----------------------------------------------------------------------------
function monitor_t_retreat_sp_barn_house_1_ai()
{
	trigger::wait_till( "t_retreat_sp_barn_house_1_ai" );
	
	level thread infection_util::retreat_if_in_volume( "t_sp_barn_house_1_ai", "t_sp_foy_town_wave_ai" );
	level thread infection_util::retreat_if_in_volume( "foy_goal_volume_2", "t_sp_foy_town_wave_ai" );
}
	
// ----------------------------------------------------------------------------
//	monitor_t_retreat_sp_foy_guys_right_ai
// ----------------------------------------------------------------------------
function monitor_t_retreat_sp_foy_guys_right_ai()
{
	trigger::wait_till( "t_retreat_sp_foy_guys_right_ai" );
	
	level thread infection_util::retreat_if_in_volume( "t_sp_foy_guys_right_ai", "foy_goal_volume_3" );
}

// ----------------------------------------------------------------------------
//	monitor_t_retreat_sp_foy_town_wave_ai
// ----------------------------------------------------------------------------
function monitor_t_retreat_sp_foy_town_wave_ai()
{
	trigger::wait_till( "t_retreat_sp_foy_town_wave_ai" );
	
	level thread infection_util::retreat_if_in_volume( "t_sp_foy_town_wave_ai", "foy_goal_volume_3" );
}
		
// ----------------------------------------------------------------------------
//	village_complete_fold
// ----------------------------------------------------------------------------
function village_complete_fold( )
{
	array::thread_all(level.players, &infection_util::player_leave_cinematic );
	
	infection_util::turn_off_snow_fx_for_all_players();
	infection_util::enable_exploding_deaths( false );
	
	level thread skipto::objective_completed( "village_house" );
}	

// ----------------------------------------------------------------------------
//	spawner_setup
// ----------------------------------------------------------------------------
function spawner_setup()
{
	infection_util::enable_exploding_deaths( true );
	
	spawner::add_global_spawn_function( "axis", &infection_util::set_goal_on_spawn_foy );
}

// ----------------------------------------------------------------------------
//	scene_setup
// ----------------------------------------------------------------------------
function scene_setup()
{
	scene::add_scene_func( "cin_inf_10_01_foy_vign_walk", &infection_util::callback_scene_objective_light_enable, "init" );
	scene::add_scene_func( "cin_inf_10_01_foy_vign_walk", &infection_util::callback_scene_objective_light_disable_no_delete, "play" );	
	
	scene::add_scene_func( "cin_inf_10_01_foy_vign_intro", &foy_vign_intro_play, "play" );
	scene::add_scene_func( "cin_inf_10_01_foy_vign_intro", &village_messages, "play" );
	scene::add_scene_func( "cin_inf_10_01_foy_vign_intro", &callback_scene_warp_players_after_foy_intro, "done" );
		
	// fxanims
	infection_util::play_scene_on_trigger( "p7_fxanim_cp_infection_reverse_wall_01_bundle", "fxanim_reverse_wall_explosion_trigger" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_wall_01_bundle", &callback_scene_reverse_time_wall_explosion, "play" );
	
	level thread infection_util::setup_reverse_time_arrivals( "foy_reverse_anim" );
	
	// Setup goal volume for AI after IGC finish
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reverse_soldier01hipshot_suppressor", 	&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reverse_soldier02headshot_suppressor", 	&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_10_02_foy_aie_reversetankshell_soldier01_sniper", 			&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_10_01_foy_aie_reversemortar_react", 						&infection_util::scene_callback_reverse_time_play_foy, "play" );	
	scene::add_scene_func( "cin_inf_10_02_foy_aie_reversewallexplosion_suppressor", 			&infection_util::scene_callback_reverse_time_play_foy, "play" );	

	level thread scene::init( "p7_fxanim_cp_infection_fold_bundle" );
}

// ----------------------------------------------------------------------------
//	spawn_func_ally
// ----------------------------------------------------------------------------
function spawn_func_ally()	
{
	// self = AI
	self endon( "death" );
	self Hide();
	self.takedamage = false;
	self ai::set_ignoreall( true );
	self.goalradius = 256;
	self.script_accuracy = 0.25;
	self.overrideActorDamage = &callback_ally_damage;
	
	self thread infection_util::actor_camo( 0 );
	util::wait_network_frame();
	
	self Show();
	
	n_spawn_anim = RandomInt( 2 );
	str_spawn_anim = undefined;
	
	switch( n_spawn_anim )
	{
		case 0:
			str_spawn_anim = "cin_inf_10_02_foy_vign_teleport_spawn";
			break;
		case 1:
			str_spawn_anim = "cin_inf_10_02_foy_vign_teleport_spawn02";
			break;
		case 2:
			str_spawn_anim = "cin_inf_10_02_foy_vign_teleport_spawn03";
			break;
	}
	
	self scene::play( str_spawn_anim, self );
	
	self ai::set_ignoreall( false );
}

// ----------------------------------------------------------------------------
//	respawn_func_ally
// ----------------------------------------------------------------------------
function respawn_func_ally()	
{
	// self = AI
	self endon( "death" );

	self.goalradius = 256;
	self.script_accuracy = 0.25;
	self.overrideActorDamage = &callback_ally_damage;
}

// ----------------------------------------------------------------------------
//	spawn_func_ally_rocket
// ----------------------------------------------------------------------------
function spawn_func_ally_rocket()	
{
	// self = AI
	self endon( "death" );
	self Hide();
	self.takedamage = false;
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.script_accuracy = 1;
	
	self thread infection_util::actor_camo( 0 );
	util::wait_network_frame();
	
	self Show();
	
	self scene::play( "cin_inf_10_02_foy_vign_teleport_spawn", self );
	self waittill( "goal" );
	
	// Send ai to the predetermined location
	e_target = GetNode( self.target, "targetname" );
	
	self.goalradius = 32;
	self SetGoal( e_target );
	self waittill( "goal" );
	self.goalradius = 64;
	
	self ai::shoot_at_target( "shoot_until_target_dead", [[level.ai_foy_turret_03]]->get_vehicle() );

	wait 0.1;
	
	self.takedamage = true;
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	self.script_accuracy = 0.1;
	self.goalradius = 2048;
}

// ----------------------------------------------------------------------------
//	callback_ally_damage
// ----------------------------------------------------------------------------
function callback_ally_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	// Don't allow players to kill friendlies
	if( IsDefined(eAttacker) && isplayer(eAttacker) )
	{
		iDamage = 0;
	}
	
	return( iDamage );
}

// ----------------------------------------------------------------------------
//	callback_scene_reverse_time_wall_explosion
// ----------------------------------------------------------------------------
function callback_scene_reverse_time_wall_explosion( a_ents )
{
	level clientfield::set( "village_mortar_index", 1 );
	
	level thread scene::play( "cin_inf_10_02_foy_aie_reversewallexplosion_suppressor" );
	
	wait 1; // Give eneimes a slight advantage to stage the battle.
	
	spawn_manager::enable( "sm_foy_friendlies");
	spawn_manager::wait_till_complete( "sm_foy_friendlies" );
	spawn_manager::kill( "sm_foy_friendlies" );
}

// ----------------------------------------------------------------------------
//	callback_scene_warp_players_after_foy_intro
// ----------------------------------------------------------------------------
// HACK: workaround for players not appearing in correct location when 1st person animations are done
function callback_scene_warp_players_after_foy_intro( a_ents )
{
	level thread infection_util::teleport_coop_players_after_shared_cinematic( a_ents );

	//hack fix when player are teleported after a scene
	infection_util::turn_off_snow_fx_for_all_players();
	util::wait_network_frame();
	infection_util::turn_on_snow_fx_for_all_players();		
}

// ----------------------------------------------------------------------------
//	init_time_rewind_destruction
// ----------------------------------------------------------------------------
function init_time_rewind_destruction()
{
	level.a_m_reverse_barn_01 = GetEntArray( "m_reverse_barn_01", "targetname" );	
	infection_util::models_ghost( level.a_m_reverse_barn_01 );
	
	level.a_m_reverse_fence_01 = GetEntArray( "m_reverse_fence_01", "targetname" );	
	infection_util::models_ghost( level.a_m_reverse_fence_01 );
	
	level.a_m_reverse_fence_02 = GetEntArray( "m_reverse_fence_02", "targetname" );	
	infection_util::models_ghost( level.a_m_reverse_fence_02 );
	
	level.a_m_reverse_chciken_coop_01 = GetEntArray( "m_reverse_chciken_coop_01", "targetname" );	
	infection_util::models_ghost( level.a_m_reverse_chciken_coop_01 );
	
	level.a_m_reverse_chciken_coop_02 = GetEntArray( "m_reverse_chciken_coop_02", "targetname" );	
	infection_util::models_ghost( level.a_m_reverse_chciken_coop_02 );
	
	level.a_m_reverse_house_01_bundle = GetEntArray( "m_reverse_house_01", "targetname" );
	infection_util::models_ghost( level.a_m_reverse_house_01_bundle );

	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_barn_01_bundle", 		&callback_show_m_reverse_barn_01, "done" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_fence_01_bundle", 		&callback_show_m_reverse_fence_01, "done" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_fence_02_bundle", 		&callback_show_m_reverse_fence_02, "done" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_chciken_coop_01_bundle", &callback_show_m_reverse_chciken_coop_01, "done" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_chciken_coop_02_bundle", &callback_show_m_reverse_chciken_coop_02, "done" );
	
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_house_01_bundle", 		&callback_reverse_house_01_bundle_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_infection_reverse_house_01_bundle", 		&callback_show_m_reverse_house_01_bundle, "done" );
	
	// p7_fxanim_cp_infection_reverse_barn_01_bundle. 125 unsafe frames. 4.2 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_barn_01_bundle", "s_infection_reverse_barn_01_bundle", "t_infection_reverse_barn_01_bundle_inner", "t_infection_reverse_barn_01_bundle_outter" );
	
	// p7_fxanim_cp_infection_reverse_fence_01_bundle. 75 unsafe frames. 2.5 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_fence_01_bundle", "s_infection_reverse_fence_01_bundle", "t_infection_reverse_fence_01_bundle_inner", "t_infection_reverse_fence_01_bundle_outter" );
	
	// p7_fxanim_cp_infection_reverse_fence_02_bundle. 95 unsafe frames. 3.2 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_fence_02_bundle", "s_infection_reverse_fence_02_bundle", "t_infection_reverse_fence_02_bundle_inner", "t_infection_reverse_fence_02_bundle_outter" );
	
	// p7_fxanim_cp_infection_reverse_chciken_coop_01_bundle. 106 unsafe frames. 3.5 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_chciken_coop_01_bundle", "s_infection_reverse_chciken_coop_01_bundle", "t_infection_reverse_chciken_coop_01_bundle_inner", "t_infection_reverse_chciken_coop_01_bundle_outter");
	
	// p7_fxanim_cp_infection_reverse_chciken_coop_02_bundle. 108 unsafe frames. 3.6 sec buffer.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_chciken_coop_02_bundle", "s_infection_reverse_chciken_coop_02_bundle", "t_infection_reverse_chciken_coop_02_bundle_inner", "t_infection_reverse_chciken_coop_02_bundle_outter");	
	
	// Totally safe, outside of play space.
	infection_util::play_scene_on_view_and_radius( "p7_fxanim_cp_infection_reverse_telephone_pole_bundle", "s_infection_reverse_telephone_pole_bundle", "t_infection_reverse_telephone_pole_bundle_inner", "t_infection_reverse_telephone_pole_bundle_outter");	
	
	level scene::init( "p7_fxanim_cp_infection_reverse_transition_wall_bundle" );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_barn_01
// ----------------------------------------------------------------------------
function callback_show_m_reverse_barn_01( a_ents )
{
	infection_util::models_show( level.a_m_reverse_barn_01 );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_fence_01
// ----------------------------------------------------------------------------
function callback_show_m_reverse_fence_01( a_ents )
{
	infection_util::models_show( level.a_m_reverse_fence_01 );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_fence_02
// ----------------------------------------------------------------------------
function callback_show_m_reverse_fence_02( a_ents )
{
	infection_util::models_show( level.a_m_reverse_fence_02 );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_chciken_coop_01
// ----------------------------------------------------------------------------
function callback_show_m_reverse_chciken_coop_01( a_ents )
{
	infection_util::models_show( level.a_m_reverse_chciken_coop_01 );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_chciken_coop_02
// ----------------------------------------------------------------------------
function callback_show_m_reverse_chciken_coop_02( a_ents )
{
	infection_util::models_show( level.a_m_reverse_chciken_coop_02 );
}


// ----------------------------------------------------------------------------
//	callback_reverse_house_01_bundle_play
// ----------------------------------------------------------------------------
function callback_reverse_house_01_bundle_play( a_ents )
{
	level waittill ( "revive_german" );
	level thread scene::play( "cin_inf_10_01_foy_aie_reversemortar" );
}

// ----------------------------------------------------------------------------
//	callback_show_m_reverse_house_01_bundle
// ----------------------------------------------------------------------------
function callback_show_m_reverse_house_01_bundle( a_ents )
{
	infection_util::models_show( level.a_m_reverse_house_01_bundle );
	level notify( "reverse_house_01_done" );
}
	
// ----------------------------------------------------------------------------
//	foy_intro
// ----------------------------------------------------------------------------
function foy_intro()
{
	level scene::init( "cin_inf_10_01_foy_aie_reversemortar" );
	level scene::init( "cin_inf_10_02_foy_aie_reversewallexplosion_suppressor" );
	
	level thread sndRecordPlayer();

	level thread util::screen_fade_in( 1.5, "white" );
	level scene::play( "cin_inf_10_01_foy_vign_intro" );
	array::run_all( level.players, &FreezeControlsAllowLook, true );
	
	level thread infection_util::sarah_objective_move( "t_sarah_foy_objective_", 0,  &sarah_appears_airlock_exterior_and_waits_for_players );
	
	// Play Sarah vo line when Sarah is starting to take off. This line works better by originate from the player in term of timing and it was like sarah speaking to his mind directly.
	level.players[0] thread dialog::say( "hall_this_is_the_path_i_0", 1.0 ); //This - is the path I must take. The path we both must take.
	
	level clientfield::set( "village_intro_mortar", 1 );
	
	//Start the rumble for house building
	foreach ( player in level.players )
	{
		player thread play_fold_house_rumble();
	}
	
	level scene::play( "p7_fxanim_cp_infection_reverse_house_01_bundle" );
	
	array::run_all( level.players, &FreezeControlsAllowLook, false );

	level thread monitor_player_attack();
	level thread monitor_t_alert_german();
}

// ----------------------------------------------------------------------------
//	foy_vign_intro_play
// ----------------------------------------------------------------------------
function foy_vign_intro_play( a_ents )
{	
//	This is comment out because they dont want the rez in fx on Sarah anymore 
//	but this could change again.
	
//	a_ents["sarah"] thread infection_util::actor_camo( CAMO_SHADER_ON, false );
//	
//	a_ents["sarah"] waittill ( "show_theia" );
// 	
//	a_ents["sarah"] thread infection_util::actor_camo( CAMO_SHADER_OFF );
}
	
// ----------------------------------------------------------------------------
//	monitor_t_alert_german
// ----------------------------------------------------------------------------
function monitor_t_alert_german()
{
	self endon( "alert_german_fire" );
	
	trigger::wait_till( "t_alert_german" );
	
	if ( level.alert_german == false )
	{
		alert_german = true;
		
		level notify( "alert_german_trigger" );
		
		alert_german();
	}
}

// ----------------------------------------------------------------------------
//	waittill_action_alert
// ----------------------------------------------------------------------------
function waittill_action_alert()
{
	self endon("disconnect");
	
	while ( ( !self AttackButtonPressed() ) && ( !self ThrowButtonPressed() ) && ( !self FragButtonPressed() ) )
	{
		wait .05; // Keep checking.
	}
	
	wait 0.20; // Give the AI a little bit of reaction time.
}

// ----------------------------------------------------------------------------
//	wait_till_attack
// ----------------------------------------------------------------------------
function wait_till_attack()
{
	self endon("disconnect");
	
	self waittill_action_alert();
	level notify( "alert_german" );
}

// ----------------------------------------------------------------------------
//	monitor_player_attack
// ----------------------------------------------------------------------------
function monitor_player_attack()
{
	self endon( "alert_german_trigger" );
	
	Array::spread_all( level.players, &wait_till_attack );
	
	level waittill( "alert_german" );
	
	if ( level.alert_german == false )
	{
		alert_german = true;
		
		level notify( "alert_german_fire" );
		
		alert_german();
	}
}

// ----------------------------------------------------------------------------
//	alert_german
// ----------------------------------------------------------------------------
function alert_german()
{
	e_german_01 = GetEnt( "foy_intro_german_01_ai", "targetname" );
	e_german_02 = GetEnt( "foy_intro_german_02_ai", "targetname" );
	e_german_03 = GetEnt( "foy_intro_german_03_ai", "targetname" );
	
	if ( !IsDefined(e_german_01) || !IsDefined(e_german_02) || !IsDefined(e_german_03) )
	{
		AssertMsg( "Missing German AI for cin_inf_10_01_foy_aie_reversemortar_react" );
	}
	
	a_e_actors = Array( e_german_01, e_german_02, e_german_03);
	
	level scene::stop( "cin_inf_10_01_foy_aie_reversemortar" );
	level thread scene::play( "cin_inf_10_01_foy_aie_reversemortar_react", a_e_actors );
}

// ----------------------------------------------------------------------------
//	sarah_appears_airlock_exterior_and_waits_for_players
// ----------------------------------------------------------------------------
//self = ai_objective_sarah
function sarah_appears_airlock_exterior_and_waits_for_players()
{	
	self scene::init( "cin_inf_10_01_foy_vign_walk", self );
	
	s_struct_pos = struct::get( "fold_sarah_objective_airlock_exterior", "targetname" );
	
	// wait for players to get close
	v_offset = ( 0, 0, -500 );  // offset trigger into the ground since origin of trigger radius is at base
	
	t_radius = infection_util::create_trigger_radius( s_struct_pos.origin + v_offset, 300, 1024 );
	
	t_radius waittill( "trigger" );
	
	t_radius Delete();
	
	self scene::play( "cin_inf_10_01_foy_vign_walk", self );
	
	self scene::init( "cin_inf_11_02_fold_1st_airlock_a", self );
	
	// BLOCKING - Wait for the players to gather and push the blocker
	players_gather_in_fold_house();
	
	players_get_on_folded_section();
}

// ----------------------------------------------------------------------------
//	sndRecordPlayer
// ----------------------------------------------------------------------------
function sndRecordPlayer()
{
	wait(1);
	sndEnt = spawn( "script_origin", (-66734,-9538,491) );
	sndEnt playsound( "evt_infection_record_oneshot" );
	
	playbackTime = soundgetplaybacktime( "evt_infection_record_oneshot" );
	playbackTime = playbackTime * .001;
	playbackTime = playbackTime - .25;
	wait(playbackTime);
	sndEnt playloopsound( "evt_infection_record_looper" );
	level util::clientnotify( "sndREC" );
}

// ----------------------------------------------------------------------------
//	foy_folds
// ----------------------------------------------------------------------------
function foy_folds()
{
	trigger::wait_till( "fold_start" );
	
	fold_start();
}

// ----------------------------------------------------------------------------
//	_display_origin
// ----------------------------------------------------------------------------
function _display_origin()
{
	self endon( "death" );
	
	while ( true )
	{
		/# DebugStar( self.origin, 2, ( 1, 0, 0 ) ); #/
		
		wait 0.1;
	}
}

// ----------------------------------------------------------------------------
//	sarah_waits_airlock_interior
// ----------------------------------------------------------------------------
function sarah_waits_airlock_interior( str_breadcrumb )
{	
	s_struct_pos = struct::get( str_breadcrumb, "targetname" );

	// wait for players to get close
	v_offset = ( 0, 0, -500 );  // offset trigger into the ground since origin of trigger radius is at base
	t_radius = infection_util::create_trigger_radius( s_struct_pos.origin + v_offset, 128, 1024 );
	t_radius waittill( "trigger" );
	
	t_radius Delete();
}

// ----------------------------------------------------------------------------
//	players_get_on_folded_section
// ----------------------------------------------------------------------------
function players_get_on_folded_section()
{
	sarah_waits_airlock_interior( "s_foy_gather_point_blocker" );	
	
	//sarah walks up wall.
	scene::play( "cin_inf_11_02_fold_1st_airlock_a" );
	
	sarah_waits_airlock_interior( "fold_perspective_change_struct" );
	
	village_complete_fold();	
}

function cleanup_ai_foldhouse()
{
	// Stop the friendly respawner trigger system from respawning friendly ai.
	colors::kill_color_replacements();
	
	//kill off all ally ai except Sarah
	a_foy_allies = GetAITeamArray( "allies" );
	for( i=0; i < a_foy_allies.size; i++ )
	{
		// HACK fix: Allies respawn by friedly respawn trigger system dosent always have a targetname.
		// Need further investigation but this will fix the non-fatal SRE.
		if ( IsDefined( a_foy_allies[i].targetname ) )
		{
			if(!IsSubStr(a_foy_allies[i].targetname, "sarah"))
			{
				a_foy_allies[i] dodamage( a_foy_allies[i].health + 100, a_foy_allies[i].origin );
				wait 0.1; //so they all don't explode at once.
			}
		}
		else
		{
			a_foy_allies[i] dodamage( a_foy_allies[i].health + 100, a_foy_allies[i].origin );
			wait 0.1; //so they all don't explode at once.
		}
	}

	//kill off all enemy ai.
	spawner::remove_global_spawn_function( "axis", &infection_util::set_goal_on_spawn_foy );

	a_foy_enemies = GetAITeamArray( "axis" );
	for( i=0; i < a_foy_enemies.size; i++ )
	{
		if ( IsAlive ( a_foy_enemies[i] ) )
		{
			a_foy_enemies[i] dodamage( a_foy_enemies[i].health + 100, a_foy_enemies[i].origin );
		}
		
		wait 0.1; //so they all don't explode at once.
	}
}	

// ----------------------------------------------------------------------------
//	players_gather_in_fold_house
// ----------------------------------------------------------------------------
function players_gather_in_fold_house()
{
	// Set the objective marker
	s_use_pos = struct::get( "s_foy_gather_point_blocker", "targetname" );
	objectives::set( "cp_level_infection_gather_airlock", s_use_pos );

	t_blocker = GetEnt( "t_foy_gather_point_blocker", "targetname" );
	Assert( IsDefined( t_blocker ), "t_foy_gather_point_blocker trigger not found!" );

	// wait for all players to be inside church
	t_blocker waittill( "trigger" );	

	//block player from going back
	a_blockers = GetEntArray( "foy_gather_point_debris_blocker", "targetname" );
	level thread show_blocker( a_blockers );
	level notify( "gather_point_debris_blocker" );
	level thread scene::play( "p7_fxanim_cp_infection_reverse_transition_wall_bundle" );
	
	array::thread_all(level.players, &infection_util::player_enter_cinematic );
	
	//all players in fold house, cleanup left behind ai.
	level thread cleanup_ai_foldhouse();
	objectives::complete( "cp_level_infection_gather_airlock" );

	// Cleanup
	level.barrier_moved = true;

	t_blocker delete();
	
	level thread skipto::objective_completed( "village" );
}

// ----------------------------------------------------------------------------
//	hide_blocker
// ----------------------------------------------------------------------------
function hide_blocker( a_blockers )
{
	foreach( blocker in a_blockers )
	{
		blocker Hide();
		blocker NotSolid();
	}
}

// ----------------------------------------------------------------------------
//	show_blocker
// ----------------------------------------------------------------------------
function show_blocker( a_blockers )
{
	foreach( blocker in a_blockers )
	{
		blocker Show();
		blocker Solid();
	}
}

// ----------------------------------------------------------------------------
//	player_gather_message
// ----------------------------------------------------------------------------
// self = player
function player_gather_message( gather_trig )
{
	self endon( "disconnect" );

	while( !( isdefined( level.barrier_moved ) && level.barrier_moved ) )
	{
		a_players = GetPlayers();

		// display message
		if( self IsTouching( gather_trig ) )
		{
			if( !IsDefined(self.barrier_message) )
			{
				self.barrier_message = infection_util::CreateClientHudText( self, "All players must meet in house", 0, 250, 1.5 );
			}
		}
		// don't display message
		else
		{
			if( IsDefined(self.barrier_message) )
			{
				self.barrier_message Destroy();
				self.barrier_message = undefined;
			}
		}
		wait( 0.05 );
	}

	// Cleanup
	if( IsDefined(self.barrier_message) )
	{
		self.barrier_message Destroy();
		self.barrier_message = undefined;
	}
}

// ----------------------------------------------------------------------------
//	random_battle_effects();
// ----------------------------------------------------------------------------
function random_battle_effects()
{
	trigger::wait_till( "t_village_mortar_2" );
	clientfield::set( "village_mortar_index", 2 );

	trigger::wait_till( "t_village_mortar_3" );
	clientfield::set( "village_mortar_index", 3 );
	
	trigger::wait_till( "t_village_mortar_4" );
	clientfield::set( "village_mortar_index", 0 );
}

// ----------------------------------------------------------------------------
//	play_fold_start_rumble
// ----------------------------------------------------------------------------
function play_fold_start_rumble( n_loops, n_wait )
{
	// Self is a player
	self endon( "death" );
	
	for( i = 0; i < n_loops; i++ )
	{
		 self PlayRumbleOnEntity( "cp_infection_fold_start" );
		 
		 wait n_wait;
	}
}

// ----------------------------------------------------------------------------
//	play_fold_house_rumble
// ----------------------------------------------------------------------------
function play_fold_house_rumble()
{
	// Self is a player
	self endon( "death" );
	level endon( "reverse_house_01_done" );
	
	while( true )
	{
		 self PlayRumbleOnEntity( "cp_infection_fold_house" );
		 
		 wait 0.5;
	}
}

// ----------------------------------------------------------------------------
//	fold_start
// ----------------------------------------------------------------------------
function fold_start( n_fold_time = 56, n_accel_time = 12, n_decel_time = 12 )
{			
	e_earthquake_origin = GetEnt( "fold_earthquake_origin", "targetname" );
	Assert( IsDefined( e_earthquake_origin ), "fold_earthquake_origin is missing!" );	
	
	level thread scene::play( "p7_fxanim_cp_infection_fold_bundle" );
	level thread scene::play( "p7_fxanim_cp_infection_fold_debris_rise_bundle" );
	
	//shake a bit
	foreach ( player in level.players )
	{
		player thread play_fold_start_rumble( 3, 0.5 );
	}
	
	wait 3;
	
	level thread fold_camera_shake( n_fold_time, e_earthquake_origin.origin );
	
	e_earthquake_origin thread infection_util::slow_nearby_players_for_time( 3500, n_fold_time );
	
	level clientfield::set( "fold_earthquake", 1 );
	
	level waittill ( "fold_fx_anim_done" );		// level notify from p7_fxanim_cp_infection_fold_skinned_anim
	
	level clientfield::set( "fold_earthquake", 0 );
	
	if ( IsDefined( GetEnt( "t_fold_debris_fall", "targetname" ) ) )
	{
		level thread monitor_t_fold_debris_fall();
	}
}


// ----------------------------------------------------------------------------
//	monitor_t_fold_debris_fall
// ----------------------------------------------------------------------------
function monitor_t_fold_debris_fall()
{
	trigger::wait_till( "t_fold_debris_fall" );
	level thread scene::play( "p7_fxanim_cp_infection_fold_debris_fall_bundle" );
}

// ----------------------------------------------------------------------------
//	fold_camera_shake
// ----------------------------------------------------------------------------
function fold_camera_shake( n_duration, e_origin )
{
	Earthquake( 0.1, n_duration, e_origin, 10000 );
	
	n_strong_shake_pause = 6;
	n_strong_shake_iteration = Int( n_duration / n_strong_shake_pause ) - 1;
	n_strong_shake_duration_min = 1.4;
	n_strong_shake_duration_max = 1.6;
	n_strong_shake_scale_min = 0.25;
	n_strong_shake_scale_max = 0.28;
	
	for ( i = 0; i <= n_strong_shake_iteration; i++ )
	{
		wait RandomFloatRange( n_strong_shake_pause - 1, n_strong_shake_pause );
		
		n_strong_shake_duration = RandomFloatRange( n_strong_shake_duration_min, n_strong_shake_duration_max );
		n_strong_shake_scale = RandomFloatRange( n_strong_shake_scale_min, n_strong_shake_scale_max );
		
		Earthquake( n_strong_shake_scale, n_strong_shake_duration, e_origin, 10000 );
	}
}

// ----------------------------------------------------------------------------
//  foy_turret_doors_open
// ----------------------------------------------------------------------------
function foy_turret_doors_open( str_door_name )
{
	a_doors = GetEntArray( str_door_name, "targetname" );
	Assert( a_doors.size, "foy_turret_doors_open: couldn't find turret door entities!" );
	
	const DOOR_OPEN_TIME = 0.75;
	const DOOR_OPEN_ACCEL_TIME = 0.2;
	const DOOR_OPEN_DECEL_TIME = 0;
	
	a_temp_ents = [];
	
	foreach ( m_door in a_doors )
	{
		Assert( IsDefined( m_door.script_int ), "foy_turret_doors_open: found door at " + m_door.origin + " without script_int KVP! This is used to rotate doors to the correct angle" );
		Assert( IsDefined( m_door.target ), "foy_turret_doors_open: found door at " + m_door.origin + " without struct target!" );
		
		// TEMP: door model origin isn't at hinge, so spawn in a script origin to rotate at the correct location 
		s_rotate = struct::get( m_door.target, "targetname" );
		e_temp = Spawn( "script_origin", s_rotate.origin );
		
		m_door LinkTo( e_temp );
		
		e_temp RotateYaw( m_door.script_int, DOOR_OPEN_TIME, DOOR_OPEN_ACCEL_TIME, DOOR_OPEN_DECEL_TIME );
		
		if ( !isdefined( a_temp_ents ) ) a_temp_ents = []; else if ( !IsArray( a_temp_ents ) ) a_temp_ents = array( a_temp_ents ); a_temp_ents[a_temp_ents.size]=e_temp;;
	}
	
	wait DOOR_OPEN_TIME;
}

// ----------------------------------------------------------------------------
// DIALOG IGC: village_messages
// TODO: much of this will be handled in cinematic
// ----------------------------------------------------------------------------
function village_messages( a_ents )
{
	e_sarah = a_ents["sarah"];
	if(IsDefined(e_sarah))
	{	
		e_sarah SetTeam( "allies" );
	}
	else
	{
		e_sarah = level.players[ 0 ];
	}

	level waittill( "sarah_dialog_starts" );  // sent from player animation in scene 'cin_inf_10_01_foy_vign_intro'
/*
	level.players[0] dialog::say( "plyr_sarah_why_do_you_t_0", 0.0 );
	e_sarah dialog::say( "hall_i_played_the_details_0", 1.0 );
	level.players[0] dialog::say( "hall_i_knew_i_couldn_t_ha_0", 1.0 );
	level.players[0] dialog::say( "plyr_sometimes_you_have_t_0", 0.0 );
	level.players[0] dialog::say( "hall_sometimes_you_have_t_0", 0.0 );
*/
}

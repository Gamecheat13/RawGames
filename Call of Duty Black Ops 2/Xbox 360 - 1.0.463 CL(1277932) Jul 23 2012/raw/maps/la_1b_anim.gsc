#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");
main()
{
	event_5_anims();
	event_6_anims();
	event_7_anims();
	fxanim_test();

	precache_assets();	
	maps\voice\voice_la_1b::init_voice();
}

event_5_anims()
{	
	//****************************************
	// cougar exit anims
	add_scene( "cougar_exit_player", "anim_align_cougar_crash" );
	add_player_anim( "player_body", %player::ch_la_05_01_cougar_exit_player, SCENE_DELETE, PLAYER_1, undefined, SCENE_DELTA, 1, 20, 20, 20, 20 );
	add_notetrack_custom_function( "player_body", "sndTurnOffIntroSnapshot", ::sndTurnOffIntroSnapshot );
	
	add_notetrack_custom_function( "player_body", "dof steering_wheel", maps\createart\la_1b_art::cougar_exit_dof1 );
	add_notetrack_custom_function( "player_body", "dof harper", maps\createart\la_1b_art::cougar_exit_dof2 );
	add_notetrack_custom_function( "player_body", "dof hatch", maps\createart\la_1b_art::cougar_exit_dof3 );
	add_notetrack_custom_function( "player_body", "dof f35", maps\createart\la_1b_art::cougar_exit_dof4 );
	add_notetrack_custom_function( "player_body", "dof convoy", maps\createart\la_1b_art::cougar_exit_dof5 );
	add_notetrack_custom_function( "player_body", "dof claw", maps\createart\la_1b_art::cougar_exit_dof6 );
	
	add_scene( "cougar_exit", "anim_align_cougar_crash" );
	add_actor_anim( "ce_bike_cop_1", %generic_human::ch_la_05_01_cougar_exit_bike_cop1, false, false, true );
	add_actor_anim( "ce_bike_cop_2", %generic_human::ch_la_05_01_cougar_exit_bike_cop2, false, false, true );
	add_actor_anim( "ce_bike_cop_3", %generic_human::ch_la_05_01_cougar_exit_bike_cop3, false, false, true );
	add_actor_anim( "ce_cop_1", %generic_human::ch_la_05_01_cougar_exit_cop1 );
	add_actor_anim( "ce_cop_2", %generic_human::ch_la_05_01_cougar_exit_cop2, false, false, false, true );
	add_actor_anim( "ter_cougar_exit", %generic_human::ch_la_05_01_cougar_exit_ter1 );
	//add_prop_anim( "bdog_cougar_exit", %animated_props::v_la_05_01_cougar_exit_big_dog, "veh_t6_drone_claw_mk2" );
	add_prop_anim( "ce_bike_1", %animated_props::v_la_05_01_cougar_exit_bike1, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_bike_2", %animated_props::v_la_05_01_cougar_exit_bike2, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_bike_3", %animated_props::v_la_05_01_cougar_exit_bike3, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_car_1", %animated_props::v_la_05_01_cougar_exit_cop_car1, "veh_t6_police_car", true );
	add_prop_anim( "ce_car_2", %animated_props::v_la_05_01_cougar_exit_cop_car2, "veh_t6_police_car", true );
	add_prop_anim( "president_cougar_exit", %animated_props::v_la_05_01_cougar_exit_cougar02, "veh_t6_mil_cougar", true );
	add_prop_anim( "wheeler_cougar_exit", %animated_props::v_la_05_01_cougar_exit_18wheeler );
	add_vehicle_anim( "f35_cougar_exit", %vehicles::v_la_05_01_cougar_exit_f35, true, "tag_gear" );
	
	add_notetrack_fx_on_tag( "ce_bike_1", "shot", "ce_dest_cop_motorcycle", "tag_body_animate_jnt" );
	add_notetrack_fx_on_tag( "ce_bike_3", "shot", "ce_dest_cop_motorcycle", "tag_body_animate_jnt" );
	add_notetrack_fx_on_tag( "ce_bike_cop_2", "shot", "ce_motocop_blood_fx_single", "j_spine4" );
	add_notetrack_fx_on_tag( "ce_bike_cop_3", "shot", "ce_motocop_blood_fx_single", "j_spine4" );
	add_notetrack_custom_function( "f35_cougar_exit", "fire1", ::fire_turret_2 );
	add_notetrack_custom_function( "f35_cougar_exit", "hit", ::ce_f35_hit );
	add_notetrack_custom_function( "f35_cougar_exit", "AB_off", ::ce_f35_hover );
	add_notetrack_custom_function( "f35_cougar_exit", "AB_on", ::ce_f35_fly);	
	add_notetrack_custom_function( "ter_cougar_exit", "fire_at_f35", ::fire_at_f35 );
	add_notetrack_custom_function( "ce_cop_1", "shot", ::ce_blood_fx );
	add_notetrack_custom_function( "ce_cop_2", "shot", ::ce_blood_fx );
	
	add_scene( "cougar_exit_interior", "anim_align_cougar_crash" );
	add_prop_anim( "interior_cougar_exit", %animated_props::v_la_05_01_cougar_exit_cougar );
	
	add_scene( "cougar_exit_interior_noharper", "anim_align_cougar_crash" );
	add_prop_anim( "interior_cougar_exit", %animated_props::v_la_05_01_cougar_exit_harperdead_cougar );
	
	add_scene( "cougar_exit_harper", "anim_align_cougar_crash" );
	add_actor_anim( "harper", %generic_human::ch_la_05_01_cougar_exit_harper1 );
	add_notetrack_custom_function( "harper", "fire_sniper", maps\la_street::harper_fire_sniperstorm, false );
	add_notetrack_custom_function( "harper", "fire_sniper2", maps\la_street::harper_fire_sniperstorm, false );
	add_notetrack_custom_function( "harper", "grenade_right", ::ce_harper_grenade );
	add_notetrack_custom_function( "harper", "stab", ::ce_melee_fx );	// These notetracks no longer exist. Does this do anything?
	
	add_scene( "cougar_exit_claw", "anim_align_cougar_crash" );
	add_prop_anim( "ce_bdog_turret", %animated_props::v_la_05_01_cougar_exit_claw_turret, "veh_t6_drone_claw_turret" );
	add_prop_anim( "bdog_cougar_exit", %animated_props::v_la_05_01_cougar_exit_big_dog, "veh_t6_drone_claw_mk2" );
	add_notetrack_custom_function( "bdog_cougar_exit", "fire", ::bdog_muzzle_flash );
	add_notetrack_fx_on_tag( "bdog_cougar_exit", "sniper_hit", "ce_bdog_killshot", "tag_neck" );
	add_notetrack_exploder( "bdog_cougar_exit", "grenade_hit", 505 );
	add_notetrack_exploder( "bdog_cougar_exit", "grenade_hit", 506 );
	add_notetrack_fx_on_tag( "bdog_cougar_exit", "sniper_killshot_hit", "ce_bdog_killshot", "tag_neck" );
	add_notetrack_fx_on_tag( "bdog_cougar_exit", "claw disabled", "ce_bdog_stun", "tag_body_animate" );
	add_notetrack_custom_function( "bdog_cougar_exit", "claw_explode", ::bdog_die_explosion );
	add_notetrack_custom_function( "bdog_cougar_exit", "start_fire", ::snd_bdog_fire );	// These notetracks no longer exist. Does this do anything?
	add_notetrack_custom_function( "bdog_cougar_exit", "stop_fire", ::snd_bdog_stop_fire );	// These notetracks no longer exist. Does this do anything?
	
	add_scene( "cougar_exit_cop_car", "anim_align_cougar_crash" );
	add_prop_anim( "cop_car_cougar_exit", %animated_props::v_la_05_01_cougar_exit_cop_car3 );
	add_notetrack_custom_function( "cop_car_cougar_exit", "tire_skid", ::ce_tire_fx );
	add_notetrack_custom_function( "cop_car_cougar_exit", "car_explode", ::ce_explode );
	
	add_scene( "ce_fxanim_cop_car", undefined, false, false, false, true );
	add_prop_anim( "cop_car_cougar_exit", %animated_props::fxanim_la_cop_car_shootup_anim );
	add_notetrack_fx_on_tag( "cop_car_cougar_exit", undefined, "ce_dest_cop_car_fx", "tag_body" );
	
	add_scene( "ce_fxanim_cop_car_explode", undefined, false, false, false, true );
	add_prop_anim( "cop_car_cougar_exit", %animated_props::fxanim_la_cop_car_shootup_explode_anim );
	
	//****************************************
	// clear the street anims
	add_scene( "clear_the_street", "anim_align_semi_arrival" );
	add_prop_anim( "wheeler_clear_the_street", %animated_props::v_la_05_02_clearthestreet_18whlr, "veh_t6_civ_18wheeler" );
	add_prop_anim( "policecar_clear_the_street", %animated_props::v_la_05_02_clearthestreet_policecar );
	add_notetrack_attach( "wheeler_clear_the_street", undefined, "veh_t6_civ_18wheeler_trailer_props", "tag_trailer_props" );
	add_notetrack_custom_function( "policecar_clear_the_street", "hits_bus", ::clear_street_lapd_car_explode );
	
	add_scene( "clear_the_street_ter", "anim_align_semi_arrival" );
	add_actor_anim( "ter_clear_the_street", %generic_human::ch_la_05_02_clearthestreet_ter1 );
	
	add_scene( "clear_street_ter_semi", "anim_align_semi_arrival" );
	add_actor_anim( "clearthestreet_ter2", %generic_human::ch_la_05_02_clearthestreet_ter2 );
	add_actor_anim( "clearthestreet_ter3", %generic_human::ch_la_05_02_clearthestreet_ter3 );
	add_actor_anim( "clearthestreet_ter4", %generic_human::ch_la_05_02_clearthestreet_ter4 );
	add_actor_anim( "clearthestreet_ter5", %generic_human::ch_la_05_02_clearthestreet_ter5 );//Driver
	
	add_scene( "street_bodies", "anim_align_cougar_crash" );
	//add_actor_model_anim( "street_body01", %generic_human::ch_la_05_03_deathposesforLA_streets_guy01, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "street_body02", %generic_human::ch_la_05_03_deathposesforLA_streets_guy02, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body03", %generic_human::ch_la_05_03_deathposesforLA_streets_guy03, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body04", %generic_human::ch_la_05_03_deathposesforLA_streets_guy04, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body05", %generic_human::ch_la_05_03_deathposesforLA_streets_guy05, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "street_body06", %generic_human::ch_la_05_03_deathposesforLA_streets_guy06, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body07", %generic_human::ch_la_05_03_deathposesforLA_streets_guy07, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "street_body08", %generic_human::ch_la_05_03_deathposesforLA_streets_guy08, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body09", %generic_human::ch_la_05_03_deathposesforLA_streets_guy09, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body10", %generic_human::ch_la_05_03_deathposesforLA_streets_guy10, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body11", %generic_human::ch_la_05_03_deathposesforLA_streets_guy11, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body12", %generic_human::ch_la_05_03_deathposesforLA_streets_guy12, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body13", %generic_human::ch_la_05_03_deathposesforLA_streets_guy13, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "street_body14", %generic_human::ch_la_05_03_deathposesforLA_streets_guy14, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "street_body15", %generic_human::ch_la_05_03_deathposesforLA_streets_guy15, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "streetbody_01", "align_streetbody_01" );
	add_actor_model_anim( "street_body01", %generic_human::ch_gen_m_floor_armup_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "streetbody_02", "align_streetbody_02" );
	add_actor_model_anim( "street_body02", %generic_human::ch_gen_m_floor_armup_legaskew_onfront_faceleft_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "streetbody_06", "align_streetbody_06" );
	add_actor_model_anim( "street_body06", %generic_human::ch_gen_m_wall_armcraddle_leanleft_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "streetbody_08", "align_streetbody_08" );
	add_actor_model_anim( "street_body08", %generic_human::ch_gen_m_ledge_armhanging_facedown_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "streetbody_14", "align_streetbody_14" );
	add_actor_model_anim( "street_body14", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	//****************************************
	// brute force anims

	add_scene( "brute_force_player", "anim_align_bruteforce" );
	add_player_anim( "player_body", %player::ch_la_05_03_bruteforce_player, true );
	add_prop_anim( "bruteforce_jaws", %animated_props::o_la_05_03_bruteforce_jaws, "t6_wpn_jaws_of_life_prop", SCENE_DELETE );
	add_notetrack_custom_function( "player_body", "start_ssa_anim", ::start_ssa_anim );
	
	add_scene( "brute_force_ssa_1", "anim_align_bruteforce" );
	add_actor_anim( "ssa_1_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa1, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined, "ssa_brute_force" );
	
	add_scene( "brute_force_ssa_2", "anim_align_bruteforce" );
	add_actor_anim( "ssa_2_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa2, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined, "ssa_brute_force" );
	
	add_scene( "brute_force_ssa_3", "anim_align_bruteforce" );
	add_actor_anim( "ssa_3_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa3, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, undefined, "ssa_brute_force" );
	
	add_scene( "brute_force_cougar", "anim_align_bruteforce" );
	add_prop_anim( "bruteforce_cougar_interior", %animated_props::v_la_05_03_bruteforce_cougar );
	
	//****************************************
	// event 5 custom AI anims
	add_scene( "train_surprise_attack", "align_train_surprise", false, true );
	add_actor_anim( "street_train_surprise", %generic_human::ai_mantle_on_56 );
	
	add_scene( "cart_push", "anim_align_cougar_crash" );
	add_actor_anim( "guy_push_cart_1", %generic_human::ch_la_05_02_entries_cartpush_guy01 );
	add_actor_anim( "guy_push_cart_2", %generic_human::ch_la_05_02_entries_cartpush_guy02 );
	add_prop_anim( "hotdog_cart_push", %animated_props::o_la_05_02_entries_cartpush_cart );
	
	add_scene( "ladder_entry_1", "anim_align_cougar_crash", false, true );
	add_actor_anim( "generic", %generic_human::ch_la_05_02_entries_ladder_guy01 );
	
	add_scene( "ladder_entry_2", "anim_align_cougar_crash" );
	add_actor_anim( "guy_ladder_2", %generic_human::ch_la_05_02_entries_ladder_guy02 );
	
	add_scene( "pipe_entry_1", "anim_align_cougar_crash" );
	add_actor_anim( "guy_pipe_1", %generic_human::ch_la_05_02_entries_pipe_guy01 );
	
	add_scene( "pipe_entry_2", "anim_align_cougar_crash", false, true );
	add_actor_anim( "generic", %generic_human::ch_la_05_02_entries_pipe_guy02 );
	
	add_scene( "skylight_leader", "node_skylight_leader", true, false, false, true );
	add_actor_anim( "skylight_leader", %generic_human::CQB_stand_wave_on_me );
}

ce_f35_hover( vh_f35 )
{
	vh_f35 notify( "hover" );
}

ce_f35_fly( vh_f35 )
{
	vh_f35 notify( "fly" );
}

fire_at_f35( ai_ter )
{
	vh_f35 = get_model_or_models_from_scene( "cougar_exit", "f35_cougar_exit" );
	v_rpg_pos = ai_ter GetTagOrigin( "tag_weapon" );
	v_canopy_pos = vh_f35 GetTagOrigin( "tag_driver" );
	v_f35_pos = v_canopy_pos;
	MagicBullet( "usrpg_magic_bullet_sp", v_rpg_pos, v_canopy_pos );
	
	wait 3;
	
	level thread autosave_by_name( "street_start" );
}

fire_turret_2( vh_f35 )
{
	vh_f35 fire_turret_for_time( 0.4, 2 );
}

ce_f35_hit( vh_f35 )
{
	PlayFXOnTag( level._effect[ "ce_f35_fx" ], vh_f35, "tag_origin" );
}

bdog_muzzle_flash( m_bdog )
{
	m_turret = get_model_or_models_from_scene( "cougar_exit_claw", "ce_bdog_turret" );
	PlayFXOnTag( level._effect[ "ce_bdog_tracer" ], m_turret, "tag_flash" );
}

ce_blood_fx( ai_cop )
{
	PlayFXOnTag( level._effect[ "ce_cop_blood_fx_single" ], ai_cop, "j_spineupper" );
}

clear_street_lapd_car_explode( vh_lapd_car )
{
	vh_lapd_car DoDamage( 10000, vh_lapd_car.origin );
}

ce_tire_fx( m_cop_car )
{
	v_left_tire_org = m_cop_car GetTagOrigin( "tag_wheel_back_left" );
	v_left_tire_angle = ( -m_cop_car.angles[1], m_cop_car.angles[2], m_cop_car.angles[0] );
	m_fx_left = spawn_model( "tag_origin", v_left_tire_org, v_left_tire_angle );
	m_fx_left LinkTo( m_cop_car );
	PlayFXOnTag( getfx( "ce_cop_car_marks_left" ), m_fx_left, "tag_origin" );
	
	v_right_tire_org = m_cop_car GetTagOrigin( "tag_wheel_back_right" );
	v_right_tire_angle = ( -m_cop_car.angles[1], m_cop_car.angles[2], m_cop_car.angles[0] );
	m_fx_right = spawn_model( "tag_origin", v_right_tire_org, v_right_tire_angle );
	m_fx_right LinkTo( m_cop_car );
	PlayFXOnTag( getfx( "ce_cop_car_marks_right" ), m_fx_right, "tag_origin" );
	
	level notify( "cop_car_skid_done" );
	
	scene_wait( "ce_fxanim_cop_car" );
	
	m_fx_left Delete();
	m_fx_right Delete();
}

ce_explode( m_cop_car )
{
	m_cop_car DoDamage( m_cop_car.health, m_cop_car.origin, undefined, undefined, "riflebullet" );
	
	/*level.player.overridePlayerDamage = ::cop_car_damage_override;
	
	wait 3;
	
	level.player.overridePlayerDamage = ::claw_vo_player_damage_override;*/
}

ce_melee_fx( ai_harper )
{
	ai_bdog = get_model_or_models_from_scene( "cougar_exit", "bdog_cougar_exit" );
	PlayFXOnTag( level._effect[ "ce_melee_bdog_fx" ], ai_bdog, "tag_panel_rear_r" );
}

ce_harper_grenade( ai_harper )
{
	ai_bdog = get_model_or_models_from_scene( "cougar_exit_claw", "bdog_cougar_exit" );
	
	v_start_pos = ai_harper GetTagOrigin( "J_Wrist_RI" );
	v_end_pos = ai_bdog.origin;
	v_grenade_velocity = VectorNormalize( v_end_pos - v_start_pos ) * 1000;	

	ai_harper MagicGrenadeManual(  ai_harper GetTagOrigin( "J_Wrist_RI" ), v_grenade_velocity, 0.5 );
}

bdog_die_explosion( m_bdog )
{
	fxOrigin = m_bdog GetTagOrigin( "tag_body_animate" );
	//m_bdog SetModel( "veh_t6_drone_claw_dead" );
	PlayFX( level._effect["ce_bdog_death"], fxOrigin );
	playsoundatposition( "wpn_bigdog_explode" , fxOrigin ); //explosion audio
	
	m_turret = get_model_or_models_from_scene( "cougar_exit_claw", "ce_bdog_turret" );
	m_turret Delete();
	
	level thread power_pole_fxanim();
}

power_pole_fxanim()
{
	// These exploders are being driven by notetracks in the fxanim
	//wait 0.5;
	//exploder( 10520 );//pole base break
	level notify( "fxanim_alley_power_pole_start" );//fire off fxanim
	
	//wait .1;
	//exploder( 10521 );//pole hits ground
}

start_ssa_anim( e_player )
{
	level thread run_scene( "brute_force_ssa_1" );
	level thread run_scene( "brute_force_ssa_2" );
	level thread run_scene( "brute_force_ssa_3" );
}

event_6_anims()
{
	add_scene( "plaza_bodies", "align_plaza" );
	add_actor_model_anim( "plaza_body01", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy01, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body02", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy02, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body03", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy03, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body04", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy04, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body05", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy05, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body06", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy06, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body07", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy07, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body08", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy08, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body09", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy09, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body10", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy10, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body11", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy11, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body12", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy12, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body13", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy13, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body14", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy14, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body15", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy15, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "plaza_body16", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy16, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "plaza_body17", %generic_human::ch_la_05_03_deathposesforLA_plaza_guy17, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_02", "align_plazabody_02" );
	add_actor_model_anim( "plaza_body02", %generic_human::ch_gen_m_wall_legspread_armonleg_leanright_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_03", "align_plazabody_03" );
	add_actor_model_anim( "plaza_body03", %generic_human::ch_gen_m_floor_armsopen_onback_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_04", "align_plazabody_04" );
	add_actor_model_anim( "plaza_body04", %generic_human::ch_gen_m_wall_low_armstomach_leanleft_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_08", "align_plazabody_08" );
	add_actor_model_anim( "plaza_body08", %generic_human::ch_gen_m_wall_legspread_armdown_leanleft_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_10", "align_plazabody_10" );
	add_actor_model_anim( "plaza_body10", %generic_human::ch_gen_m_ledge_armhanging_faceright_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_11", "align_plazabody_11" );
	add_actor_model_anim( "plaza_body11", %generic_human::ch_gen_m_wall_armcraddle_leanleft_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_13", "align_plazabody_13" );
	add_actor_model_anim( "plaza_body13", %generic_human::ch_gen_m_floor_armstretched_onrightside_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "plazabody_16", "align_plazabody_16" );
	add_actor_model_anim( "plaza_body16", %generic_human::ch_gen_m_ledge_armhanging_facedown_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	//****************************************
	// F35 crash anims
	add_scene( "f35_crash_pilot", "fxanim_f35_dead" );
	add_actor_model_anim( "crash_pilot", %generic_human::ch_la_06_03_f35crash_deadpilot, undefined, !SCENE_DELETE, "tag_origin" );
	
	//****************************************
	// intersection animations
	
	//****************************************
	// event 6 custom AI anims
	add_scene( "plaza_counter_filp", "align_plaza", true );
	add_actor_anim( "plaza_foodguy01",  %generic_human::ch_la_06_02_plaza_foodguy01 );
	
	add_scene( "plaza_lapd_store", "align_plaza", true );
	add_actor_anim( "plaza_lapd02",  %generic_human::ch_la_06_02_plaza_police02 );
	add_actor_anim( "plaza_lapd03",  %generic_human::ch_la_06_02_plaza_police03 );
	
	add_scene( "plaza_shopguy01", "align_plaza" );
	add_actor_anim( "plaza_shopguy01",  %generic_human::ch_la_06_02_plaza_shopguy01 );
	add_prop_anim( "plaza_cart_1", %animated_props::o_la_06_02_plaza_cart01 );
	
	add_scene( "plaza_shopguy02", "align_plaza" );
	add_actor_anim( "plaza_shopguy02",  %generic_human::ch_la_06_02_plaza_shopguy02 );
	add_prop_anim( "plaza_cart_2", %animated_props::o_la_06_02_plaza_cart02 );
		
	add_scene( "climb_plaza_building", "anim_climb_plaza_building" );
	add_actor_anim( "plaza_building",  %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_on_cylinder_0", "anim_plaza_right_rpg_0" );
	add_actor_anim( "plaza_right_rpg_0", %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_on_cylinder_1", "anim_plaza_right_rpg_1" );
	add_actor_anim( "plaza_right_rpg_1", %generic_human::ai_mantle_on_56 );
	
	add_scene( "plaza_grate1", "align_plaza" );
	add_actor_anim( "plaza_grate_01", %generic_human::ch_la_06_02_plaza_grate01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_grate2", "align_plaza" );
	add_actor_anim( "plaza_grate_02", %generic_human::ch_la_06_02_plaza_grate02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_grate1_loop", "align_plaza", false, false, true );
	add_actor_anim( "plaza_grate_01", %generic_human::ch_la_06_02_plaza_grate01_loop, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_grate2_loop", "align_plaza", false, false, true );
	add_actor_anim( "plaza_grate_02", %generic_human::ch_la_06_02_plaza_grate02_loop, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_ledge1", "plaza_ledge_01_node" );
	add_actor_anim( "plaza_ledge_01", %generic_human::ch_la_06_02_plaza_ledge01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_ledge2", "plaza_ledge_02_node" );
	add_actor_anim( "plaza_ledge_02", %generic_human::ch_la_06_02_plaza_ledge02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "plaza_planter", "plaza_planter_node" );
	add_actor_anim( "plaza_planter_01", %generic_human::ch_la_06_02_plaza_planter_enemy1, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "plaza_stairs_planter", %animated_props::o_la_06_02_plaza_planter01 );
	
	add_scene( "plaza_table_flip_01", "plaza_table_flip_01_node", SCENE_REACH );
	add_prop_anim( "plaza_table_flip_table_01", %animated_props::o_la_06_02_plaza_table_flip_table_01, "p6_plaza_table", false, true );
	add_prop_anim( "plaza_table_flip_chair_01", %animated_props::o_la_06_02_plaza_table_flip_chair_01, "p6_plaza_chair", false, true );
	add_prop_anim( "plaza_table_flip_chair_02", %animated_props::o_la_06_02_plaza_table_flip_chair_02, "p6_plaza_chair", false, true );
	add_prop_anim( "plaza_table_flip_chair_03", %animated_props::o_la_06_02_plaza_table_flip_chair_03, "p6_plaza_chair", false, true );
	add_actor_anim( "plaza_table_flip_guy_01", %generic_human::ch_la_06_02_plaza_table_flip_guy_01 );
	
	add_scene( "plaza_table_flip_02", "plaza_table_flip_02_node", SCENE_REACH );
	add_prop_anim( "plaza_table_flip_table_02", %animated_props::o_la_06_02_plaza_table_flip_table_02, "p6_plaza_table", false, true );
	add_prop_anim( "plaza_table_flip_chair_04", %animated_props::o_la_06_02_plaza_table_flip_chair_02, "p6_plaza_chair", false, true );
	add_prop_anim( "plaza_table_flip_chair_05", %animated_props::o_la_06_02_plaza_table_flip_chair_05, "p6_plaza_chair", false, true );
	add_actor_anim( "plaza_table_flip_guy_02", %generic_human::ch_la_06_02_plaza_table_flip_guy_02 );
}

event_7_anims()
{
	add_scene( "intersection_bodies", "anim_align_stadium_intersection" );
	add_actor_model_anim( "intersection_body01", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy01, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body02", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy02, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body03", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy03, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body04", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy04, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body05", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy05, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body06", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy06, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body07", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy07, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body08", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy08, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body09", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy09, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body10", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy10, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body11", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy11, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body12", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy12, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body13", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy13, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body14", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy14, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body15", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy15, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body16", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy16, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body17", %generic_human::ch_la_05_03_deathposesforLA_intersection_guy17, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_actor_model_anim( "intersection_body18", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy01, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body19", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy02, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body20", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy03, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body21", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy04, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body22", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy05, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body23", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy06, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body24", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy07, undefined, false, undefined, undefined, "dead_body_spawner" );
	//add_actor_model_anim( "intersection_body25", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy08, undefined, false, undefined, undefined, "dead_body_spawner" );
	add_actor_model_anim( "intersection_body26", %generic_human::ch_la_05_03_deathposesforLA_intersectionB_guy09, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_02", "align_intersectbody_02" );
	add_actor_model_anim( "intersection_body02", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_09", "align_intersectbody_09" );
	add_actor_model_anim( "intersection_body09", %generic_human::ch_gen_m_floor_armdown_onback_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_12", "align_intersectbody_12" );
	add_actor_model_anim( "intersection_body12", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_13", "align_intersectbody_13" );
	add_actor_model_anim( "intersection_body13", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_17", "align_intersectbody_17" );
	add_actor_model_anim( "intersection_body17", %generic_human::ch_gen_m_floor_armdown_legspread_onback_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	add_scene( "intersectbody_25", "align_intersectbody_25" );
	add_actor_model_anim( "intersection_body25", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "dead_body_spawner" );
	
	//****************************************
	// lockbreaker
	add_scene( "lockbreaker", "anim_align_intruder" );
	add_prop_anim( "lockbreaker_lock", %animated_props::o_specialty_la_lockbreaker_dongle, "t6_wpn_hacking_dongle_prop" );
	add_player_anim( "player_body", %player::int_specialty_la_lockbreaker, SCENE_DELETE/*, PLAYER_1, undefined, SCENE_DELTA, 1, 10, 10, 10, 10, true, true */);
	add_notetrack_custom_function( "player_body", undefined, ::data_glove_on );
	
	add_notetrack_custom_function( "player_body", "planted", maps\la_plaza::lockbreaker_planted );
	add_notetrack_custom_function( "player_body", "door_open", maps\la_plaza::lockbreaker_door_open );
	
	//****************************************
	// Intruder
	add_scene( "intruder", "18wheeler_cage" );
	add_prop_anim( "intruder_cutter", %animated_props::o_specialty_la_intruder_cutter, "t6_wpn_laser_cutter_prop", SCENE_DELETE, !SCENE_SIMPLE_PROP, undefined, "tag_trailer" );
	add_prop_anim( "18wheeler_cage", %animated_props::o_specialty_la_intruder_gate, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, undefined, "tag_trailer" );
	add_player_anim( "player_body", %player::int_specialty_la_intruder, SCENE_DELETE, PLAYER_1, "tag_trailer"/*, SCENE_DELTA, 1, 10, 10, 10, 10, true, true */);
	
	add_notetrack_custom_function( "player_body", "zap", maps\la_street::intruder_zap );
	add_notetrack_custom_function( "player_body", "gatecrash", maps\la_street::intruder_gatecrash );
	
	add_notetrack_custom_function( "18wheeler_cage", "hide_bolts", maps\la_street::intruder_hide_bolts );
	
	add_notetrack_custom_function( "intruder_cutter", "zap_start", maps\la_street::intruder_zap_start );
	add_notetrack_custom_function( "intruder_cutter", "zap_end", maps\la_street::intruder_zap_end );
	add_notetrack_custom_function( "intruder_cutter", "start", maps\la_street::intruder_cutter_on );
	
	//****************************************
	// sam anims
	add_scene( "sam_in", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_in, true );
	
	add_scene( "sam_out", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_out, true );
	
	add_scene( "sam_thrown_out", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_thrown_out, true );
	
	add_scene( "fa38_landing", "anim_align_stadium_intersection" );
	add_vehicle_anim( "f35_vtol", %vehicles::v_la_07_02_f35staples_f35 );
	add_notetrack_custom_function( "f35_vtol", undefined, maps\la_intersection::f35_land_fx );
	
	add_scene( "ssathanks_ssa_idle", "anim_align_stadium_intersection", false, false, true );
	add_actor_anim( "thank_guy", %generic_human::ch_la_07_02_SSAThanks_guy01_idle1 );
	
	add_scene( "ssathanks_ssa", "anim_align_stadium_intersection" );
	add_actor_anim( "thank_guy", %generic_human::ch_la_07_02_SSAThanks_guy01 );
	
	add_scene( "ssathanks_harper", "anim_align_stadium_intersection", true );
	add_actor_anim( "harper", %generic_human::ch_la_07_02_SSAThanks_guy02 );
	
	//****************************************
	// collapse building
	
	add_scene( "ending_drone", "anim_align_arena_exit" );
	add_prop_anim( "crash_drone_ending", %animated_props::fxanim_la_drone_crash_tower_anim, "veh_t6_drone_avenger" );
}

#using_animtree( "animated_props" );
fxanim_test()
{
	level.scr_animtree[ "fxanim_ambient_drone_1" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_1" ] = "veh_t6_drone_avenger";
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_drone_2" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_2" ] = "veh_t6_drone_pegasus";
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_f35" ] = #animtree;
	level.scr_model[ "fxanim_ambient_f35" ] = "veh_t6_air_fa38";
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
}

snd_bdog_fire(bigdog)
{
	bigdog PlayLoopSound ( "wpn_bigdog_turret_fire_loop_npc");
}

snd_bdog_stop_fire(bigdog)
{
	bigdog StopLoopSound ( .2 );
}

sndTurnOffIntroSnapshot( guy )
{
	level clientnotify( "stop_intro_snp" );
}

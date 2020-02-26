#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include common_scripts\utility;
#include maps\_utility;
#include maps\pakistan_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;
#insert raw\maps\pakistan.gsh;

main()
{
	// section 1 anims
	intro();
	unlock_flamethrower();
	claw_freezer_kill();
	claw_grenade_launch();
	car_corner_crash();
	car_smash();
	car_smash_pain_guy1();
	car_smash_death_guy1();
	car_smash_dead_pose_guy1();
	car_smash_dead_pose_not_guy1();
	bus_smash();
	bus_smash_collateral_damage();
	flooded_streets();
	brute_force_arrive();
	brute_force_idle();
	brute_force_exit();
	brute_force_unlock();
	street_exit();	
	harper_frogger_anims();
	frogger_debris();
	frogger_ai_entries();
	bus_dam_anims();
	slum_alley_initial();
	slum_alley_corner();
	slum_alley_dog();
	alley_civilians();
	corpse_alley();
	fallen_building();
	sewer_entry();
	intruder_perk();
	sewer_slide();
	sewer_exit();
	
	fxanim_misc();
	
	precache_assets();
	
	// VO SECTION
	add_temp_vo_lines();
	maps\voice\voice_pakistan::init_voice();
}

intro()
{
	// loop plays while Mason fixes claw
	add_scene( "intro_anim_loop", "pakistan_intro_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_1_1_market_intro_loop_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_1_market_intro_loop_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_player_anim( "player_body", %player::p_pakistan_1_1_market_intro_loop_player_1stperson, SCENE_DELETE );
	add_actor_anim( "mason_fullbody", %generic_human::p_pakistan_1_1_market_intro_loop_player_3rdperson, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	
	// actual intro anim
	add_scene( "intro_anim", "pakistan_intro_2", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_1_1_market_intro_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_1_market_intro_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_actor_anim( "claw_1", %bigdog::v_pakistan_1_1_market_intro_claw, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_notetrack_custom_function( "claw_1", "start_fire", maps\pakistan_market::_intro_claw_turret_fire );
	add_notetrack_custom_function( "claw_1", "end_fire", maps\pakistan_market::_intro_claw_turret_fire_stop );
	
	add_player_anim( "player_body", %player::p_pakistan_1_1_market_intro_player_1stperson, SCENE_DELETE );
	add_notetrack_custom_function( "player_body", "persp_switch", maps\pakistan_market::_intro_extra_cam );
	add_notetrack_custom_function( "player_body", undefined, ::hide_player_body_in_intro, false );
	add_actor_anim( "mason_fullbody", %generic_human::p_pakistan_1_1_market_intro_player_3rdperson, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH );
}

hide_player_body_in_intro( e_body )
{
	e_body Hide();
}

unlock_flamethrower()
{
	add_scene( "unlock_flamethrower", "claw_1_ai", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "claw_1", %bigdog::v_pakistan_1_2_lockbreaker_claw, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_player_anim( "player_body", %player::p_pakistan_1_2_lockbreaker_player, SCENE_DELETE, 0, "tag_origin" );
	add_prop_anim( "claw_flamethrower_dongle", %animated_props::o_specialty_pakistan_lockbreaker_dongle, CLAW_FLAMETHROWER_ATTACHMENT, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	
	add_notetrack_custom_function( "player_body", "planted", ::_plant_flamethrower_dongle, false );
}

_plant_flamethrower_dongle( e_player_body )
{
	e_dongle = get_ent( "claw_flamethrower_dongle", "targetname", true );
	ai_claw = get_ent( "claw_1_ai", "targetname", true );
	e_dongle LinkTo( ai_claw );
}

claw_freezer_kill()
{
	add_scene( "claw_freezer_kill", "pakistan_intro_2", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "claw_freezer_kill_guy_1", %generic_human::ch_pakistan_1_1_intro_freezer_guy01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "claw_freezer_kill_guy_2", %generic_human::ch_pakistan_1_1_intro_freezer_guy02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "claw_freezer_kill_freezer", %animated_props::o_pakistan_1_1_intro_freezer, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
}

claw_grenade_launch()
{
	add_scene( "claw_grenade_launch", "pakistan_market", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "claw_grenade_guy", %generic_human::ch_pakistan_1_5_grenade_launch_guy_01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	add_notetrack_custom_function( "claw_grenade_guy", "hit_pillar", ::claw_grenade_launch_pillar_hit );
	add_actor_anim( "claw_2", %bigdog::v_pakistan_1_5_grenade_launch_claw, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	add_notetrack_custom_function( "claw_2", "grenade_launch", maps\pakistan_market::_claw_launches_grenade_at_guy );
}

claw_grenade_launch_pillar_hit( e_guy )
{
	// placeholder for destruction
	debug_print_line( "claw_grenade_launch: hit_pillar" );
}

fxanim_misc()
{
	add_notetrack_custom_function( "fxanim_props", "shelves_destroy", ::shelving_physics_explosion, true );
}

// this function will clear out all the dyn ents off shelves
shelving_physics_explosion( e_shelf )
{
	debug_print_line( "shelf collapse" );
	v_origin = e_shelf.origin;
	
	const n_explosion_magnitude = 1.0; // 1 = grenade magnitude
	const n_physis_pulse_radius = 80; 
	const n_shelves = 4;
	n_z_offset_base = 14;
	n_z_offset = 28;
	for ( i = 0; i < n_shelves; i++ )
	{
		v_explosion_origin = ( v_origin + ( 0, 0, ( i * n_z_offset ) + n_z_offset_base ) );
		PhysicsExplosionSphere( v_explosion_origin, n_physis_pulse_radius, 0, n_explosion_magnitude );
		wait 0.05;
	}
}

car_corner_crash()
{
	// loop prior to crash
	add_scene( "car_corner_crash_loop", "car_corner_crash_vehicle", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "car_corner_crash_vehicle", %animated_props::fxanim_pak_car_corner_veh_loop_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );		
		
	// crash into corner
	add_scene( "car_corner_crash", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim( "car_corner_crash_vehicle", %animated_props::fxanim_pak_car_corner_veh_crash_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );
}

car_smash()
{
	// car for this scene was through fxanim department; plays aligned to itself
	add_scene( "car_smash", "car_smash_car", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "car_smash_car", %animated_props::fxanim_pak_market_car_crash_car_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_custom_function( "car_smash_car", "exploder 10150 #car_smash", ::_car_smashes_into_market, false );
	
	// the guys that are hit by the car came from animation, play aligned to node in street simultaneously
	add_scene( "car_smash_guys", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	add_actor_anim( "car_smash_guy_1", %generic_human::ch_pakistan_1_5_car_smash_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "car_smash_guy_2", %generic_human::ch_pakistan_1_5_car_smash_guy02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

car_smash_pain_guy1()
{
	add_scene( "car_smash_pain_guy1", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "car_smash_guy_1", %generic_human::ch_pakistan_1_5_car_smash_dying_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

car_smash_death_guy1()
{
	add_scene( "car_smash_death_guy1", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "car_smash_guy_1", %generic_human::ch_pakistan_1_5_car_smash_death_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
}

car_smash_dead_pose_guy1()
{
	add_scene( "car_smash_dead_pose_guy1", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "car_smash_guy_1", %generic_human::ch_pakistan_1_5_car_smash_deadpose_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

car_smash_dead_pose_not_guy1()
{
	add_scene( "car_smash_dead_pose_not_guy1", "car_smash_car", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	
	add_prop_anim( "car_smash_car", %animated_props::fxanim_pak_market_car_crash_idle_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_actor_anim( "car_smash_guy_2", %generic_human::ch_pakistan_1_5_car_smash_deadpose_guy02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

bus_smash()
{
	add_scene( "bus_smash", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	
	add_prop_anim( "car_smash_bus", %animated_props::fxanim_pak_market_bus_crash_bus_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_custom_function( "car_smash_bus", "bus_impact", ::bus_smash_bus_impact, false );
	add_notetrack_custom_function( "car_smash_bus", "car_hit", ::bus_smash_car_hit, false );  // remove when anim updated; currently timed off of bus_smash start, which causes alignment/timing issues
	add_notetrack_custom_function( "car_smash_bus", "shelf_01_destroy", ::bus_smash_shelf_fall_1, false );
	add_notetrack_custom_function( "car_smash_bus", "shelf_02_destroy", ::bus_smash_shelf_fall_2, false );
	add_notetrack_custom_function( "car_smash_bus", "shelf_03_destroy", ::bus_smash_shelf_fall_3, false );
	add_notetrack_custom_function( "car_smash_bus", "shelf_04_destroy", ::bus_smash_shelf_fall_4, false );
}

bus_smash_shelf_fall_1( e_bus )
{
	level notify( "fxanim_market_bus_shelf_01_start" );
}

bus_smash_shelf_fall_2( e_bus )
{
	level notify( "fxanim_market_bus_shelf_02_start" );
}

bus_smash_shelf_fall_3( e_bus )
{
	level notify( "fxanim_market_bus_shelf_03_start" );
}

bus_smash_shelf_fall_4( e_bus )
{
	level notify( "fxanim_market_bus_shelf_04_start" );
}

bus_smash_bus_impact( e_bus )  // runs off of 'bus_impact' notify: when bus hits pillar
{
	level notify( "fxanim_market_bus_crash_start" ); // start fxanim of pillar -> market wall destruction
}

bus_smash_car_hit( e_bus )  // runs off of 'car_hit' notify: when bus collides with car
{
	ai_car_smash_redshirt = get_ent( "car_smash_guy_1_ai", "targetname", true );
	ai_car_smash_redshirt stop_dialog();
	
	e_bus thread _shatter_market_window();
	level thread maps\_scene::run_scene( "bus_smash_collateral_damage_guys" );
	flag_wait( "car_smash_done" );
	level thread maps\_scene::run_scene( "bus_smash_collateral_damage" );	
}

bus_smash_collateral_damage()
{
	add_scene( "bus_smash_collateral_damage", "car_smash_car", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "car_smash_car", %animated_props::fxanim_pak_market_bus_crash_car_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	
	add_scene( "bus_smash_collateral_damage_guys", "pakistan_market", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "car_smash_guy_1", %generic_human::ch_pakistan_1_5_bus_smash_guy01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "car_smash_guy_2", %generic_human::ch_pakistan_1_5_bus_smash_guy02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

stop_dialog()  // to be replaced with _dialog update
{
	self StopSounds(); 
}

_car_smashes_into_market( e_car )
{
	level notify( "fxanim_market_car_crash_start" );  // start fxanim
	
	ai_car_smash_redshirt = get_ent( "car_smash_guy_1_ai", "targetname", true );
    ai_car_smash_redshirt say_dialog( "isi_arrrrgh_0" );//Arrrrgh!	
	
	s_start = get_struct( "car_smash_window_shatter_struct", "targetname", true );
	s_target = get_struct( s_start.target, "targetname", true );
	
	// single bullet will crack glass but not shatter it, 3 will shatter from pristine
	const n_shots = 1;
	for ( i = 0; i < n_shots; i++ )
	{
		MagicBullet( "defaultweapon_invisible_sp", s_start.origin, s_target.origin, e_car );
		wait 0.05;
	}	
}

_shatter_market_window()
{
	const n_damage_radius = 96;
	const n_damage = 500;
	s_target = get_struct( "bus_smash_window_shatter_struct", "targetname", true );
	v_start = self.origin;
	
	RadiusDamage( s_target.origin, n_damage_radius, n_damage, n_damage );
	PhysicsExplosionSphere( s_target.origin, n_damage_radius, 0, 2 );
}

flooded_streets()
{
	add_scene( "flooded_streets", "pakistan_market_exit", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_1_6_flooded_streets_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_flooded_streets_salazar_exit, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
//	add_actor_anim( "claw_1", %bigdog::v_pakistan_1_6_flooded_streets_claw1, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
//	add_actor_anim( "claw_2", %bigdog::v_pakistan_1_6_flooded_streets_claw2, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "flooded_streets_salazar_loop", "pakistan_market_exit", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_flooded_streets_salazar_loop, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	add_notetrack_custom_function( "salazar", undefined, ::set_flooded_streets_flag, false );
	
	add_scene( "flooded_streets_salazar_arrive", "pakistan_market_exit", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_flooded_streets_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
}

set_flooded_streets_flag( ai_salazar )
{
	if ( !ai_salazar ent_flag_exist( "playing_flooded_streets_idle" ) )
	{
		ai_salazar ent_flag_init( "playing_flooded_streets_idle" );
	}
	
	ai_salazar ent_flag_set( "playing_flooded_streets_idle" );
}

brute_force_arrive()
{
	add_scene( "brute_force_arrive", "brute_force", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_brute_force_arrive_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

brute_force_idle()
{
	add_scene( "brute_force_idle", "brute_force", SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_brute_force_idle_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

brute_force_exit()
{
	add_scene( "brute_force_exit", "brute_force", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_brute_force_exit_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

brute_force_unlock()
{
	add_scene( "brute_force_unlock", "brute_force", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_brute_force_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "claw_1", %bigdog::v_pakistan_1_6_brute_force_claw01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "claw_2", %bigdog::v_pakistan_1_6_brute_force_claw02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "brute_force_door", %animated_props::o_pakistan_1_6_brute_force_gate, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );
	
	// player's anim has different frame range, so it's a separate scene
	add_scene( "brute_force_unlock_player", "brute_force", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_player_anim( "player_body", %player::p_pakistan_1_6_brute_force_player, SCENE_DELETE );
	add_prop_anim( "brute_force_prop", %animated_props::o_specialty_pakistan_brute_force_jaws, PERK_BRUTE_FORCE_PROP, SCENE_DELETE, !SCENE_SIMPLE_PROP );
}

street_exit()
{
	add_scene( "street_exit", "brute_force", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "salazar", %generic_human::ch_pakistan_1_6_brute_force_separate_ways_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "claw_1", %bigdog::v_pakistan_1_6_brute_force_separate_ways_claw01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "claw_2", %bigdog::v_pakistan_1_6_brute_force_separate_ways_claw02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
}

#using_animtree( "animated_props" );
frogger_debris()
{
	level.scr_animtree[ "frogger_debris" ] 	= #animtree;
	level.scr_model["frogger_debris"] = "tag_origin_animate";
	level.scr_anim[ "frogger_debris" ][ "frogger_debris_bob" ] = %animated_props::o_pakistan_3_1_floating_debris;
}

harper_frogger_anims()
{
	// harper melees some guy in the street who was hiding behind a corner
	add_scene( "frogger_melee", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_1_frogger_melee_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "frogger_melee_guy", %generic_human::ch_pakistan_2_1_frogger_melee_enemy, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	// harper arrives at sign and pulls it down to use as cover
	add_scene( "frogger_sign_only", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "frogger_sign", %animated_props::o_pakistan_2_1_frogger_sign_approach_sign, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	
	add_scene( "frogger_sign", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_1_frogger_sign_approach_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "frogger_sign", %animated_props::o_pakistan_2_1_frogger_sign_approach_sign, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	
	// harper exits cover from behind the sign
	add_scene( "frogger_sign_exit", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_1_frogger_sign_exit_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	// harper uses fridge as cover
	add_scene( "frogger_fridge_cover", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_1_frogger_refrigerator_approach_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "frogger_fridge", %animated_props::o_pakistan_2_1_frogger_refrigerator_approach_fridge, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );
	
	// harper exits fridge cover
	add_scene( "frogger_fridge_cover_exit", "pakistan_frogger_street", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_1_frogger_refrigerator_exit_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
}

frogger_ai_entries()
{
	// setup doors for lighting
	bm_door_1 = get_ent( "frogger_door_kick_1_door", "targetname", true );
	bm_door_2 = get_ent( "frogger_door_kick_2_door", "targetname", true );
	bm_door_1 RotateYaw( -90, 1 );
	bm_door_2 RotateYaw( 90, 1 );
	
	add_scene( "frogger_door_kick_1", "frogger_door_kick_1", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "frogger_door_kick_1_guy", %generic_human::ai_doorbreach_kick, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_notetrack_custom_function( "frogger_door_kick_1_guy", "door_open", ::frogger_door_kick_1_func, false );
	
	add_scene( "frogger_door_kick_2", "frogger_door_kick_2", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "frogger_door_kick_2_guy", %generic_human::ai_doorbreach_kick, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_notetrack_custom_function( "frogger_door_kick_2_guy", "door_open", ::frogger_door_kick_2_func, false );	
}

frogger_door_kick_1_func( ai_guy )
{
	bm_door = get_ent( "frogger_door_kick_1_door", "targetname", true );
	const n_rotate_angle = 90;
	const n_rotate_time = 0.15;
	const n_acceleration_time = 0.05;
	
	bm_door RotateYaw( n_rotate_angle, n_rotate_time, n_acceleration_time );
	maps\_scene::run_scene( "frogger_door_kick_2" );
}

frogger_door_kick_2_func( ai_guy )
{
	bm_door = get_ent( "frogger_door_kick_2_door", "targetname", true );
	const n_rotate_angle = -120;
	const n_rotate_time = 0.25;
	const n_acceleration_time = 0.10;
	
	bm_door RotateYaw( n_rotate_angle, n_rotate_time, n_acceleration_time );
}

bus_dam_anims()
{
	// bus comes around corner, destroying everything it hits
	add_scene( "bus_dam_start", "bus_dam_bus", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	
	add_prop_anim( "dam_bus", %animated_props::fxanim_pak_bus_dam_enter_bus_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_custom_function( "dam_bus", undefined, maps\pakistan_street::bus_dam_anim_sequence, false );	
	add_notetrack_custom_function( "dam_bus", "1st_hit_start", ::bus_first_impact, false );
	add_notetrack_custom_function( "dam_bus", "2nd_hit_start", ::bus_second_impact, false );
	add_notetrack_custom_function( "dam_bus", "wedge_balc_start", ::bus_wedge_balcony, false );
	add_notetrack_custom_function( "dam_bus", "wedge_wall_start", ::bus_wedge_wall, false );
	
	// guys that run away from bus
	add_scene( "bus_dam_runners", "bus_dam", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	
	add_actor_anim( "bus_runner_1", %generic_human::ch_pakistan_2_3_bus_dam_enemy01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_notetrack_custom_function( "bus_runner_1", "start_bus", maps\pakistan_street::start_bus, false );
	add_notetrack_custom_function( "bus_runner_1", "start_ragdoll", ::start_bus_runner_ragdoll, false );
	
	add_actor_anim( "bus_runner_2", %generic_human::ch_pakistan_2_3_bus_dam_enemy02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_3", %generic_human::ch_pakistan_2_3_bus_dam_enemy03, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_4", %generic_human::ch_pakistan_2_3_bus_dam_enemy04, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_5", %generic_human::ch_pakistan_2_3_bus_dam_enemy05, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_6", %generic_human::ch_pakistan_2_3_bus_dam_enemy06, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_7", %generic_human::ch_pakistan_2_3_bus_dam_enemy07, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "bus_runner_8", %generic_human::ch_pakistan_2_3_bus_dam_enemy08, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );

	// generic anims to play when wave/bus hits a normal AI on its way down the street
	level.scr_anim[ "generic" ][ "bus_wave_death_1" ] = %generic_human::ch_pakistan_2_3_bus_dam_enemy09;
	level.scr_anim[ "generic" ][ "bus_wave_death_2" ] = %generic_human::ch_pakistan_2_3_bus_dam_enemy10;

	// bus wedged in geo; player has to push door open during this anim
	add_scene( "bus_dam_idle", "bus_dam_bus", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "dam_bus", %animated_props::fxanim_pak_bus_dam_idle_bus_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );

	// bus is unstuck from environment and rolls down the street, destroying more stuff. plays on success and failure conditions for bus dam event
	add_scene( "bus_dam_exit", "bus_dam_bus", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "dam_bus", %animated_props::fxanim_pak_bus_dam_exit_bus_anim, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG );
	add_notetrack_custom_function( "dam_bus", "break_balc_start", ::bus_break_balcony, false );
	add_notetrack_custom_function( "dam_bus", "break_wall_start", ::bus_break_wall, false );		

/*-----------------------------------------------
BUS DAM ANIM FLOW

1) wave hits player
	- play harper push scene 
	- play player push scene, follow with idle (second scene)
2) player arrives at gate
	- play setup anim (harper, player)
3) strength test
4a) success condition
	- play scene with harper, player, left door, right door, bus
4b) failure condition
	- play scene with harper, player, bus
-----------------------------------------------*/	

	// STEP 1 - wave hits player and harper
	// bus wave hits harper. different framecount than player hit, so different scene	
	add_scene( "bus_dam_wave_push", "bus_dam_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_bus_dam_pushed_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	// harper idles at gate before player arrives
	add_scene( "bus_dam_harper_gate_idle", "bus_dam_temp", SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_bus_dam_pushed_idle_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	add_notetrack_custom_function( "harper", undefined, ::bus_dam_harper_at_gate, false );
	
	// bus wave hits player
	add_scene( "bus_dam_wave_push_player", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );	
	add_player_anim( "player_body", %player::p_pakistan_2_3_bus_dam_pushed_player, SCENE_DELETE );

	// STEP 2 - push anim setup - player is now at gate
	add_scene( "bus_dam_gate_push_setup", "bus_dam_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_gate_push_setup_harper, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_player_anim( "player_body", %player::p_pakistan_2_3_gate_push_setup_player, !SCENE_DELETE );
	
	// STEP 3 - strength test
	add_scene( "bus_dam_gate_push_test", "bus_dam_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_player_anim( "player_body", %player::p_pakistan_2_3_gate_push_player, !SCENE_DELETE );
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_gate_push_harper, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "bus_dam_door_left", %animated_props::o_pakistan_2_3_gate_push_left_door, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "bus_dam_door_right", %animated_props::o_pakistan_2_3_gate_push_right_door, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	
	// STEP 4A - SUCCESS!
	add_scene( "bus_dam_gate_success", "bus_dam_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_player_anim( "player_body", %player::p_pakistan_2_3_gate_push_success_player, SCENE_DELETE );
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_gate_push_success_harper, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "bus_dam_door_left", %animated_props::o_pakistan_2_3_gate_push_success_left_door, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_prop_anim( "bus_dam_door_right", %animated_props::o_pakistan_2_3_gate_push_success_right_door, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );

	// STEP 4B - FAILURE!
	add_scene( "bus_dam_gate_failure", "bus_dam_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_player_anim( "player_body", %player::p_pakistan_2_3_gate_push_failure_player, SCENE_DELETE );
	add_actor_anim( "harper", %generic_human::ch_pakistan_2_3_gate_push_failure_harper, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
}

bus_dam_harper_at_gate( e_bus )
{
	flag_set( "bus_dam_harper_at_gate" );
}

start_bus_runner_ragdoll( e_guy )
{
	
}

bus_first_impact( e_bus )
{
	debug_print_line( "1st_hit_start" );
	level notify( "fxanim_bus_dam_1st_hit_start" );
}

bus_second_impact( e_bus )
{
	debug_print_line( "2nd_hit_start" );
	level notify( "fxanim_bus_dam_2nd_hit_start" );
}

bus_wedge_balcony( e_bus )
{
	debug_print_line( "bus_wedge_balcony" );
	level notify( "fxanim_bus_dam_wedge_balc_start" );
}

bus_wedge_wall( e_bus )
{
	debug_print_line( "wedge_wall_start" );
	level notify( "fxanim_bus_dam_wedge_wall_start" );
}

bus_break_balcony( e_bus )
{
	debug_print_line( "break_balc_start" );
	level notify( "fxanim_bus_dam_break_balc_start" );
}

bus_break_wall( e_bus )
{
	debug_print_line( "break_wall_start" );
	level notify( "fxanim_bus_dam_break_wall_start" );
}

slum_alley_initial()
{
	add_scene( "slum_alley_initial", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_prop_anim( "alley_rat_1", %animated_props::ch_pakistan_3_1_slum_alley_rat01, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
	add_prop_anim( "alley_rat_2", %animated_props::ch_pakistan_3_1_slum_alley_rat02, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
	add_prop_anim( "alley_dog_1", %animated_props::ch_pakistan_3_1_slum_alley_dog01, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
}

slum_alley_corner()
{
	add_scene( "slum_alley_corner", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_prop_anim( "alley_rat_3", %animated_props::ch_pakistan_3_1_slum_alley_rat03, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
	add_prop_anim( "alley_rat_4", %animated_props::ch_pakistan_3_1_slum_alley_rat04, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );	
}

slum_alley_dog()
{
	// dog2 flow: rummage_loop (with slum_alley_corner) -> transition -> growl_loop -> run_away
	
	add_scene( "slum_alley_dog_rummage", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "alley_dog_2", %animated_props::ch_pakistan_3_1_slum_alley_dog02_rummage_loop, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );

	add_scene( "slum_alley_dog_transition", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "alley_dog_2", %animated_props::ch_pakistan_3_1_slum_alley_dog02_transition, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );

	add_scene( "slum_alley_dog_growl", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "alley_dog_2", %animated_props::ch_pakistan_3_1_slum_alley_dog02_growl_loop, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );

	add_scene( "slum_alley_dog_exit", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_prop_anim( "alley_dog_2", %animated_props::ch_pakistan_3_1_slum_alley_dog02_run_away, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
}

alley_civilians()
{
	// civilian 1 and 2 - _loop = starting state -> react -> _loop
	add_scene( "alley_civilian_1", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_1", %generic_human::ch_pakistan_3_1_ambient_civilians_civ01_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "alley_civilian_2", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_2", %generic_human::ch_pakistan_3_1_ambient_civilians_civ02_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );

	// civilian 1 and 2 reaction anims
	add_scene( "alley_civilian_1_react", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_1", %generic_human::ch_pakistan_3_1_ambient_civilians_civ01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );

	add_scene( "alley_civilian_2_react", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_2", %generic_human::ch_pakistan_3_1_ambient_civilians_civ02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );

	add_scene( "alley_civilian_3", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_3", %generic_human::ch_pakistan_3_1_ambient_civilians_civ03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	
	add_scene( "alley_civilian_door_react", "pakistan_alley", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "alley_civilian_4", %generic_human::ch_pakistan_3_1_ambient_civilians_civ04, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "alley_civilian_5", %generic_human::ch_pakistan_3_1_ambient_civilians_civ05, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "alley_civilian_door", %animated_props::o_pakistan_3_1_ambient_civilians_door, undefined, SCENE_DELETE, SCENE_SIMPLE_PROP );
}

corpse_alley()
{
	// broken into multiple anims due to different frame ranges
	add_scene( "corpse_alley_drone_and_civ", "pakistan_alley_exit", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
//	add_vehicle_anim( "drone_helicopter", %vehicles::v_pakistan_3_1_corpse_alley_drone, !SCENE_DELETE );
//	add_notetrack_custom_function( "drone_helicopter", "spot_civ", maps\pakistan_street::corpse_alley_drone_finds_civ, false );
	add_notetrack_custom_function( "drone_helicopter", "drone_fire", maps\pakistan_street::corpse_alley_drone_fires_at_civ, false );
	
	add_actor_anim( "corpse_alley_runner", %generic_human::ch_pakistan_3_1_corpse_alley_civilian, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
//	add_notetrack_custom_function( "corpse_alley_runner", "get_detected", maps\pakistan_street::corpse_alley_civ_detected_by_drone, false );
//	add_notetrack_custom_function( "corpse_alley_runner", "get_launched", maps\pakistan_street::corpse_alley_civ_launched_by_drone, false );

	add_scene( "corpse_alley_player_jump", "pakistan_alley_exit", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_player_anim( "player_body", %player::p_pakistan_3_1_corpse_alley_player_jump, SCENE_DELETE );
	
	// corpse_alley_harper includes harper and the body he hides under
	add_scene( "corpse_alley_harper", "pakistan_alley_exit", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "corpse_hat_1", %generic_human::ch_pakistan_3_1_corpse_alley_corpse_hat01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_1_corpse_alley_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	add_notetrack_custom_function( "harper", "start_hide", maps\pakistan_street::corpse_alley_helicopter_scans_bodies, false );	
	add_notetrack_custom_function( "harper", "stand_up", maps\pakistan_street::corpse_alley_helicopter_scan_done, false );	

	// player and body anim  [ note trigger_radius would work on unaligned animation with height = 50, radius = 40 ]
	add_scene( "corpse_alley_player", "pakistan_alley_exit", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	add_player_anim( "player_body", %player::p_pakistan_3_1_corpse_alley_player, SCENE_DELETE );		
	add_notetrack_custom_function( "player_body", undefined, maps\pakistan_street::corpse_alley_helicopter_scan_done, false );	
	add_actor_anim( "corpse_hat_2", %generic_human::ch_pakistan_3_1_corpse_alley_corpse_hat02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
		
}

fallen_building()
{
	// flow = climb -> idle1 -> move -> idle2 -> exit
	add_scene( "sideways_building_harper_climb", "pakistan_bank", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_2_fallen_building_harper_climb, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "sideways_building_harper_idle_1", "pakistan_bank", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_2_fallen_building_harper_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	
	add_scene( "sideways_building_harper_move", "pakistan_bank", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_2_fallen_building_harper_move, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
	
	add_scene( "sideways_building_harper_idle_2", "pakistan_bank", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_2_fallen_building_harper_idle02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );

	add_scene( "sideways_building_harper_exit", "pakistan_bank", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_2_fallen_building_harper_exit, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );	
}

sewer_entry()
{
	add_scene( "sewer_entry", "pakistan_sewer_exterior_2", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_5_sewer_entry_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, SCENE_NO_TAG );
	add_prop_anim( "sewer_entry_device", %animated_props::o_pakistan_3_5_sewer_entry_lockbreaker, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP );
	add_prop_anim( "sewer_entry_gate", %animated_props::o_pakistan_3_5_sewer_entry_sewer_gate, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP );
}

intruder_perk()
{
	add_scene( "perk_intruder_unlock", "intruder_perk_door", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	
	add_player_anim( "player_body", %player::int_specialty_pakistan_intruder, SCENE_DELETE, 0, "tag_origin" );
	add_prop_anim( "intruder_device", %animated_props::o_specialty_pakistan_intruder_cutter, undefined, SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_TAG, "tag_origin" );
	add_notetrack_fx_on_tag( "intruder_device", "zap_start", "cutter_spark", "tag_fx");
	add_notetrack_fx_on_tag( "intruder_device", "zap_end", "cutter_on", "tag_fx");
	add_prop_anim( "intruder_perk_door", %animated_props::o_specialty_pakistan_intruder_door, undefined, !SCENE_DELETE, !SCENE_SIMPLE_PROP, SCENE_NO_TAG, "tag_origin" );
}

sewer_slide()
{
	add_scene( "sewer_slide", "sewer_slide", SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "harper", %generic_human::ch_pakistan_3_5_sewer_slide_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
}

sewer_exit()
{
	add_scene( "sewer_exit", "pakistan_sewer_exit_temp", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );	
	
	add_player_anim( "player_body", %player::p_pakistan_3_5_manhole_cover_player, !SCENE_DELETE );	
	add_prop_anim( "sewer_exit_cover", %animated_props::o_pakistan_3_5_manhole_cover_manhole, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );
}

/*=============================================================================
 VO SECTION
=============================================================================*/

add_temp_vo_lines()
{
}

avoid_spotlights_moveup_nag_setup()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	add_vo_to_nag_group( "avoid_spotlight_moveup", ai_harper, "harp_don_t_fall_behind_0" );  // Don't fall behind.
	add_vo_to_nag_group( "avoid_spotlight_moveup", ai_harper, "harp_hurry_up_0" );  // Hurry up!
}

vo_intro()  // cinematic
{
	wait 1.5; // wait for static a bit
	
	e_mason = level.player;
	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_dammit_isi_troops_g_0" );  //Dammit! ISI troops got us pinned down!
	e_mason say_dialog( "harp_we_need_that_thing_u_0" );  //We need that thing up and running, now!
}

vo_market()
{
	level endon( "market_done" );
	
	e_mason = level.player;
	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_salazar = get_ent( "salazar_ai", "targetname", true );	
	
    ai_harper say_dialog( "harp_start_marking_target_0" );  // Start marking targets - Let's see what these bad-boys can do!
    
    wait 3;
    
    ai_salazar say_dialog( "sala_more_hostiles_coming_0" );  // More hostiles coming in from the street!
    
    wait 3;
    
    ai_harper say_dialog( "harp_let_the_claws_take_p_0" );  //Let the CLAWS take point - stay behind the heavy guns!
   
    wait 4;
    
    start_vo_nag_group_flag( "claw_target_nag", "frogger_done", 8, 1, true, 1.8,::claw_nag_filter );
}

vo_market_done()
{
	if ( !flag( "car_smash_started" ) )  // don't play if car_smash has started
	{
		ai_harper = get_ent( "harper_ai", "targetname", true );
	
		ai_harper say_dialog( "harp_all_right_0" );//All Right		
	}
}

vo_car_smash()
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_salazar say_dialog( "sala_flood_water_s_rising_0" ); //Flood water's rising!
	
	flag_wait( "car_smash_pain_guy1_started" );
    
    wait 2;
    
    ai_harper say_dialog("harp_damn_0" );//Damn...
    
}

vo_bus_smash()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	wait 3;
	
	ai_harper say_dialog( "harp_get_back_section_0" );// Get back, Section!	
}

vo_market_exit()
{
	e_mason = level.player;
	
	flag_wait( "flooded_streets_started" );
	
	wait 8;
	
    e_mason say_dialog( "sect_salazar_take_the_c_0" );  // Salazar! Take the claws and scout potential evac routes while Harper and I push through to Anthem.
}

vo_brute_force_usable()
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	
	ai_salazar say_dialog("sala_section_over_here_0" );//Section - over here!
}

vo_brute_force_used()
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	e_mason = level.player;
	
	wait 6;
	
	ai_salazar say_dialog("sala_this_door_leads_to_t_0" ); // This door leads to the roof.
	e_mason say_dialog( "sect_take_the_claws_up_to_0" );  //Take the claws up top - provide cover fire while Harper and I push through to Anthem.
}

vo_brute_force_not_used()
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	
	ai_salazar say_dialog( "sala_looks_like_we_have_t_0" ); //Looks like we have to take the long way around. You're on your own until Anthem. Out.
}

vo_frogger()
{
	level endon( "frogger_done" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper waittill_not_speaking();
	ai_harper say_dialog("harp_we_got_isi_troops_po_0" );//We got ISI troops posted across the whole damn street!
	ai_harper say_dialog( "harp_you_getting_the_feel_0" );  // You getting the feeling these bastards know we were coming?
	
	wait 2;
	
	ai_harper say_dialog( "harp_watch_it_section_u_0" );//Watch it Section!  Use whatever you can for cover!
	
	wait 3;
	
	// TODO: base logic off spawns, not sequentially the same each time
	ai_harper say_dialog( "harp_isi_left_side_balco_0" ); //ISI! Left side balcony!
	
	wait 3;
	
	ai_harper say_dialog( "harp_right_side_right_si_0" ); // Right side. Right side!
	
	wait 3;
	
	ai_harper say_dialog( "harp_shop_front_right_si_0" ); // Shop front. Right side!
	
	if ( flag( "frogger_perk_active" ) )
	{
		if ( !maps\_fire_direction::is_fire_direction_active() )
		{
			level.player maps\pakistan_market::enable_claw_fire_direction_feature();
		}
		
		while ( !level._fire_direction.hint_active )  // TODO: update when _fire_direction scripts are in use
		{
			wait 1;
		}
		
		start_vo_nag_group_flag( "claw_target_nag", "frogger_done", 8, 1, true, 1.8,::claw_nag_filter );
	}
}

claw_nag_vo_setup()
{
	e_harper = get_ent( "harper_ai", "targetname", true );
	add_vo_to_nag_group( "claw_target_nag", e_harper, "harp_call_em_in_section_0" );  // Call 'em in, Section!
	add_vo_to_nag_group( "claw_target_nag", e_harper, "harp_mark_the_target_for_0" ); // Mark the target for the claws!
	add_vo_to_nag_group( "claw_target_nag", e_harper, "harp_hit_em_section_1" );  // Hit 'em, Section.
}

claw_nag_filter()  // self = speaker (all Harper)
{
	// is claw cooldown up?
	b_is_available = level._fire_direction.hint_active;
	b_harper_speaking = IsDefined( self.is_talking );
	
	b_should_nag = ( b_is_available && !b_harper_speaking );
	return false;  // TEMP: removed since lines aren't in, and this looks spammy otherwise
}

waittill_not_speaking( b_hold_for_priority_dialog )
{
	DEFAULT( b_hold_for_priority_dialog, false );
	
	b_should_wait = true;
	
	while ( b_should_wait )
	{
		b_is_talking = IsDefined( self.is_talking );
		b_has_priority_dialog = ( b_hold_for_priority_dialog && IsDefined( self.has_priority_dialog ) );
		b_should_wait = ( b_is_talking || b_has_priority_dialog );
		wait 0.05;
	}
}

say_priority_dialog( str_line )
{
	self.has_priority_dialog = true;
	waittill_not_speaking();
	
	self say_dialog( str_line );
	self.has_priority_dialog = undefined;
}

vo_frogger_debris_hit()
{
	if ( !flag_exists( "frogger_vo_hit" ) )
	{
		flag_init( "frogger_vo_hit" );
	}
	
	if ( !flag( "frogger_vo_hit" ) )
	{
		flag_set( "frogger_vo_hit" );
		ai_harper = get_ent( "harper_ai", "targetname", true );
		
		ai_harper waittill_not_speaking();
    	ai_harper say_dialog( "harp_watch_yourself_sect_0" );// Watch yourself, Section!
   		ai_harper say_dialog( "harp_all_this_shit_in_the_0" ); // All this shit in the water's gonna leave a mark if it hits you!" );		
	}
}

vo_frogger_support()
{
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_salazar say_dialog( "sala_section_i_m_in_pos_0" ); //Section - I'm in position on the roof.  Call in CLAW support if you need it.
}

vo_frogger_support_ends()
{
	if ( flag( "frogger_perk_active" ) )
	{
		ai_salazar = get_ent( "salazar_ai", "targetname", true );
		e_mason = level.player;
		
		ai_salazar say_dialog( "sala_section_you_re_mov_0" );//Section.  You're moving out of the CLAWS' LOS. (beat) You're on your own.
		e_mason say_dialog( "sect_copy_that_salazar_0" ); //Copy that. Salazar.   (beat) Take the claws and scout potential evac routes while Harper and I push through to Anthem.
	}
}

vo_bus_street()
{
	ai_salazar = get_ent( "salazar_ai", "targetname" );
	ai_harper = get_ent( "harper_ai", "targetname" );
	
	if ( IsDefined( ai_salazar ) )
	{
		ai_salazar waittill_not_speaking();
	}
	
    ai_harper say_dialog( "harp_why_s_the_water_slow_0", 1 );// Why's the water slowing down?
}

vo_bus_street_combat()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_more_isi_headed_ri_0" );// More ISI - headed right for us!
}

vo_bus_dam()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_what_s_the_hell_is_t_0" ); // What the hell is that noise?!
	wait 2;
	
    ai_harper thread say_dialog( "harp_holy_shit_section_0" );//Holy shit, Section!
    ai_harper thread say_dialog( "harp_into_the_alley_get_0" );  // Into the alley - get off the street!
    
    level waittill( "bus_dam_wave_at_player" );
    
    wait 1;
    
    ai_harper say_dialog( "harp_move_now_0" );// Move - NOW!
    
    setmusicstate ("PAK_RIVER_BUS");
    
    flag_wait( "bus_dam_gate_push_setup_started" );
    
    ai_harper say_dialog ( "harp_come_on_push_0", 1 ); // Come on - PUSH!
}

vo_bus_dam_escape()  // will be in cinematic
{
	wait 4;
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_too_close_way_too_0" );// Too close... Way too close.
}

vo_alley()
{
	level endon( "corpse_alley_started" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	e_mason = level.player;
	
    ai_harper say_dialog( "harp_anthem_s_just_ahead_0" );  // Anthem's just ahead - Come on, Brother.
    ai_harper say_dialog( "harp_what_a_fucking_mess_0" ); // What a fucking mess...
    e_mason say_dialog( "sect_they_ve_pretty_much_0" ); // They've pretty much left the civilians to fend for themselves.
    ai_harper say_dialog( "harp_poor_bastards_weren_0", 1 );//Poor bastards weren't prepared for the flooding.
    e_mason say_dialog( "sect_neither_was_their_go_0" ); // Neither was their government
}

vo_corpse_alley()  // cinematic
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_shit_look_must_0", 1 );//Shit... look. Must be hundreds of them.
	
	
	level waittill( "corpse_alley_spotlight_on_player" );
	ai_harper say_dialog( "harp_get_down_0" );//Get down!
}

vo_avoid_spotlight()
{
	level endon( "drone_detects_player" );
	level endon( "avoid_spotlights_done" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	flag_wait( "corpse_alley_harper_done" );
	
	ai_harper say_dialog( "harp_fucking_drones_0" );//Fucking drones.
	
	ai_harper say_dialog( "harp_stay_out_the_spotlig_0", 1 );//Stay out of the spotlight - It'll tear us to shreds if it gets a bead on us.
	
	level waittill( "drone_scanning_store" );
	
	ai_harper thread say_dialog( "avoid_spotlights_down" );  // Down, down!
	
	flag_wait( "drone_at_bank" );
	
	flag_wait( "avoid_spotlight_midpoint" );
	ai_harper thread say_dialog( "harp_entry_point_s_beyond_0" );  // Entry point's beyond the building at the end of the street. (beat) You ready?

	level waittill( "drone_exiting_bank_street" );
	ai_harper say_dialog( "harp_it_s_comin_around_0" );  //It's comin' around!  (beat) This way - into the building.
	ai_harper say_dialog( "harp_on_me_0", 1 );  // On me.
}

vo_avoid_spotlight_detected()
{
	ai_harper = get_ent( "harper_ai" );
	
	ai_harper stop_dialog();
	ai_harper thread say_dialog( "harp_dammit_its_seen_you_0" ); //DAMMIT! Its seen you!
	
	wait 1;
	
	vh_drone = get_ent( "drone_helicopter", "targetname" );
	if ( IsDefined( vh_drone ) )
	{
		ai_harper thread shoot_at_target_untill_dead( vh_drone, "tag_body" );
	}
	
	flag_wait( "helicopter_dead" );
	ai_harper say_dialog( "harp_by_now_that_bastard_0" );  //By now that bastard may be relaying our position to every ISI soldier in the city.
}

vo_sideways_building()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	if ( !flag( "helicopter_dead" ) )
	{
		ai_harper say_dialog( "harp_i_think_we_lost_him_0" );// I think we lost him.	
	}
	
	ai_harper say_dialog( "harp_watch_your_step_0", 2 );  //Watch your step.
}

vo_sideways_building_stealth()
{
	level endon( "_stealth_spotted" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_hear_that_patrol_u_0" );  //Hear that?  Patrol up ahead.
	
	ai_harper thread vo_sideways_building_stealth_broken();
	
	if ( !flag( "_stealth_spotted" ) )
	{
		ai_harper say_dialog( "harp_keep_your_head_down_0" ); // Keep your head down and they'll pass us.
		
		flag_wait( "player_leaving_bank" );
		
		ai_harper say_dialog( "harp_dammit_i_hate_being_0" );  //Dammit, I hate being right... The sewer entrance is swarming with ISI.
		ai_harper say_dialog( "harp_stick_to_the_shadows_0" );  // Stick to the shadows.
	}
}

vo_sideways_building_stealth_broken()
{
	level endon( "sewer_entry_done" );
	
	level waittill( "_stealth_spotted" );
	
	ai_harper = get_ent( "harper_ai", "targetname", true );
	ai_harper say_dialog( "harp_we_ve_been_spotted_0" );  // We've been spotted. Put 'em down.
}

vo_sewer_perk_dialog_exchange()
{
	a_guards = get_ent_array( "intruder_guys_ai", "targetname", true );
	
	ai_guard_1 = a_guards[ 0 ]; 
	ai_guard_2 = a_guards[ 1 ];
	
	ai_guard_1 endon( "death" );
	ai_guard_2 endon( "death" );
	
	ai_guard_1 say_dialog( "isi1_the_major_has_two_ne_0" );  // The major has two new Super SOC-Ts. You see them yet?
	ai_guard_2 say_dialog( "isi2_yes_yes_over_by_th_0" );  // Yes, yes, over by the train station. They look like the old ones.
	ai_guard_1 say_dialog( "isi1_looks_are_deceiving_0" );  // Looks are deceiving - these have thicker armor plating and can take more hits. Much stronger than the earlier model.
	ai_guard_2 say_dialog( "isi2_so_they_sacrifice_sp_0" );  // So they sacrifice speed for all that increased protection.
	ai_guard_1 say_dialog( "isi1_no_not_these_they_0" );  // No, not these. They are equipped with bigger, more powerful engines. They are faster than the other model, hence the name; "Super"
	
	vo_sewer_perk_success();
}

vo_sewer_interior()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	
	ai_harper say_dialog( "harp_nothing_worse_than_s_0" );  //Nothing worse than spending an Op soaking wet...
	ai_harper say_dialog( "harp_these_sewers_run_rig_0" );  //These sewers run right under Anthem.  (beat) Ready to get dirty?
}

vo_sewer_perk_success()
{
	e_mason = level.player;
		
	e_mason say_dialog( "sect_salazar_i_m_sending_0" );//Salazar, I'm sending you some information on the SOC-Ts. See if you can use it.
}

vo_change_level()
{
	ai_harper = get_ent( "harper_ai", "targetname", true );
	  
    ai_harper say_dialog( "harp_salazar_we_re_in_w_0" );//Salazar, we're in. What's your status?
    ai_harper say_dialog( "sala_in_position_patchin_0" );//In position. Patching you a video feed of the defenses.	
}

unused_vo()
{
/*

    add_dialog("harp_get_in_cover_0","vox_pak_2_01_009a_harp");//Get in cover!
 
    add_dialog("harp_nice_0","vox_pak_2_01_015a_harp");//Nice!

    add_dialog("harp_alright_0","vox_pak_2_01_018a_harp");//Alright!


    add_dialog("harp_fuck_it_we_gotta_go_0","vox_pak_2_03_012a_harp");//Fuck it! We gotta go!

    add_dialog("harp_get_down_fucking_d_0","vox_pak_2_04_002a_harp");//Get down - Fucking drone's comin' back!
    add_dialog("harp_stay_low_let_it_p_0","vox_pak_2_04_003a_harp");//Stay low... Let it pass.
    add_dialog("harp_go_0","vox_pak_2_04_004a_harp");//GO!


*/	
}
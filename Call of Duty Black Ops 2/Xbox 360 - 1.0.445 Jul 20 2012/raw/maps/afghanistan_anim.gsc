#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;
#include maps\_turret;

#insert raw\maps\_scene.gsh;

main()
{
	maps\voice\voice_afghanistan::init_voice();
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	/// These Scenes always need to be inited because of where they are perks or are precaching items
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	e1_s1_pulwar_scene();
	e1_s1_pulwar_single_scene();
	e2_s1_base_props();
	lockbreaker_perk_scene();
	intruder_perk_scene();
	e4_s6_player_grabs_on_tank_scene();
	e4_s6_tank_fight_scene();
	
	e1_s1_player_wood_scene();
	e1_s1_player_wood_idle_scene();

	e1_s2_horse_approach();
	e1_s2_lotr_horse_scene();
	e1_s2_lotr_woods_horse_scene();
	e1_s2_ride_vignettes();
	
	patroller_anims();
	setup_brainwash_anims();
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	precache_assets();
}

init_afghan_anims_part1()
{
	//e1_s5_vulture_shoot_scene();
	e2_s1_ride_scenes();
	e2_s1_base_activity();
	//e2_s1_map_loop_scene();
	
	walkto_cave_entrance_scene();
	cave_entrance_wait_scene();
	cave_enter_scene();
	map_room_wait_scene();
	map_room_scene();
	
	precache_assets( true );
}

init_afghan_anims_part1b()
{
	e3_s1_leave_map_room_scene();
	e3_s1_map_room_idle_scene();
	e3_s1_ride_out_scene();
	e3_s1_chopper_crash_scene();
	e3_s1_arena_rocks_scene();
	plant_explosive_dome_scene();
	plant_explosive_dome_stairs_scene();
	
	precache_assets( true );
}

init_afghan_anims_part2()
{
	e4_s1_return_base_lineup_scene();
	e4_s1_return_base_lineup_single_scene();
	e4_s1_binoc_scene();
	e4_s1_return_base_charge_scene();
	e4_s1_return_base_charge_scene_no_player();
	e4_s5_player_and_horse_fall();
	e4_s5_tank_fall();
	//e4_s6_tank_fight_tank_scene();
	e4_s6_strangle_scene();

	//e5_s1_celebration_scene();
	//e5_s1_celebration_riders_scene();
	e5_s1_walk_in_scene();
	e5_s2_interrogation();
//	e5_s2_interrogation_loop_scene();
//	e5_s2_interrogation_punch_scene();
//	e5_s2_interrogation_shoot_v1_scene();
//	e5_s2_interrogation_shoot_v2_scene();
//	e5_s2_interrogation_move2shoot_scene();
	e5_s4_beatdown_scene();
	
	e6_s2_deserted_bush_anim_scene();
	
	//e6_s2_deserted_single_scene();
	
	e6_s2_ontruck_1_scene();
	//e6_s2_ontruck_2_scene();
	e6_s2_ontruck_trucks_scene();
	e6_s2_offtruck_scene();
	e6_s2_deserted_part1_scene();
	e6_s2_deserted_part2_scene();
	e6_s2_deserted_part3_scene();
	
	precache_assets( true );
}

intruder_perk_scene()
{	
	add_scene( "intruder", "intruder_strongbox" );
	add_prop_anim( "intruder_box_cutter", %animated_props::o_specialty_afghanistan_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true );
	add_player_anim( "player_hands",	 %player::int_specialty_afghanistan_intruder, true );
	
	add_scene( "intruder_box_and_mine", "intruder_strongbox" );
	add_prop_anim( "intruder_grabbed_mine", %animated_props::o_specialty_afghanistan_intruder_grabbed_mine, "t6_wpn_mine_tc6_world", true );
	add_prop_anim( "intruder_box", %animated_props::o_specialty_afghanistan_intruder_strongbox );
}

lockbreaker_perk_scene()
{
	add_scene( "lockbreaker", "afghan_lockbreaker_door");
	add_player_anim("player_hands",	 %player::int_specialty_afghanistan_lockbreaker, true);
	add_prop_anim("cutter", %animated_props::o_specialty_afghanistan_lockbreaker_device, "t6_wpn_lock_pick_view", true);
}

e1_s1_pulwar_scene()
{
	add_scene( "e1_s1_pulwar", "dead_guy_node");
	//*add_actor_anim("dead_guy", %generic_human::ch_af_01_03_pulwar_deadguy, true, false);
	add_player_anim( "player_body", %player::p_af_01_03_pulwar_player, true );
	add_prop_anim( "crowbar", %animated_props::o_af_01_03_pulwar_crowbar, "t6_wpn_crowbar_prop", true );
	add_prop_anim( "sword", %animated_props::o_af_01_03_pulwar_pulwar, "t6_wpn_pulwar_sword_prop", true );
	
	add_notetrack_custom_function( "player_body", "spark_fx", ::pulwar_fx );
}


pulwar_fx( guy )
{
	exploder( 110 );
}


e1_s1_pulwar_single_scene()
{
	add_scene( "e1_s1_pulwar_single", "dead_guy_node");
	//*add_actor_anim("dead_guy", %generic_human::ch_af_01_03_pulwar_deadguy, true, false, false, true);
	add_prop_anim("sword", %animated_props::o_af_01_03_pulwar_pulwar, "t6_wpn_pulwar_sword_prop");
	
}

e1_s1_player_wood_scene()
{
	add_scene( "e1_player_wood_greeting", "special_delivery_start");
	add_actor_anim( "woods", %generic_human::ch_af_01_01_intro_woods_start ); //-- 422 frames before detach mask
	
	add_player_anim( "player_body", %player::p_af_01_01_intro_player_start, false, 0 );
	add_notetrack_flag( "player_body", "start_horses", "start_horses" );

	add_notetrack_custom_function( "player_body", "dof_lookout", maps\createart\afghanistan_art::dof_lookout );
	add_notetrack_custom_function( "player_body", "dof_rappell", maps\createart\afghanistan_art::dof_rappell );
	add_notetrack_custom_function( "player_body", "dof_landed", maps\createart\afghanistan_art::dof_landed );
	add_notetrack_custom_function( "player_body", "dof_run2wall", maps\createart\afghanistan_art::dof_run2wall );
	add_notetrack_custom_function( "player_body", "dof_hit_wall", maps\createart\afghanistan_art::dof_hit_wall );
	
	////add_prop_anim( "ammo_box", %animated_props::o_af_01_01_gunbox, "p6_anim_ammo_box" );////
	//add_prop_anim( "photo", %animated_props::o_af_01_01_photo, "p6_photograph_01_anim", true, true );
	////add_horse_anim( "woods_horse", %horse::ch_af_01_01_intro_horse_woods_start);
	////set_vehicle_unusable_in_scene("woods_horse");
	
	add_notetrack_fx_on_tag( "woods", "jump", "fx_afgh_sand_body_impact", "J_Ankle_LE" );
	add_notetrack_fx_on_tag( "woods", "impact", "fx_afgh_rappel_impact", "J_Ankle_RI" );
	add_notetrack_fx_on_tag( "woods", "land", "fx_afgh_sand_body_impact", "J_Ankle_RI" );
}


e1_s1_player_wood_idle_scene()
{
	add_scene_loop( "e1_player_wood_idle", "special_delivery_start");
	add_actor_anim("woods", %generic_human::ch_af_01_01_intro_woods_waitidle);
	add_horse_anim( "woods_horse", %horse::ch_af_01_01_intro_horse_woods_waitidle);
	set_vehicle_unusable_in_scene("woods_horse");
}

e1_s2_horse_approach()
{
	/*
	add_scene_loop("e1_zhao_horse_approach_far_loop", "special_delivery_start");
	add_actor_model_anim( "zhao_approach", %generic_human::ch_af_01_05_zhaoapproach_farloop_zhao, undefined, undefined, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_1", %generic_human::ch_af_01_05_zhaoapproach_farloop_muj01, undefined, undefined, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_2", %generic_human::ch_af_01_05_zhaoapproach_farloop_muj02, undefined, undefined, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_3", %generic_human::ch_af_01_05_zhaoapproach_farloop_muj03, undefined, undefined, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_4", %generic_human::ch_af_01_05_zhaoapproach_farloop_muj04, undefined, undefined, undefined, undefined, "zhao_approach");	
	add_horse_anim( "zhao_approach_horse", %horse::ch_af_01_05_zhaoapproach_farloop_zhao_horse);
	add_horse_anim( "muj_horse_approach_1", %horse::ch_af_01_05_zhaoapproach_farloop_muj01_horse);
	add_horse_anim( "muj_horse_approach_2", %horse::ch_af_01_05_zhaoapproach_farloop_muj02_horse);
	add_horse_anim( "muj_horse_approach_3", %horse::ch_af_01_05_zhaoapproach_farloop_muj03_horse);
	add_horse_anim( "muj_horse_approach_4", %horse::ch_af_01_05_zhaoapproach_farloop_muj04_horse);
	*/
	add_scene("e1_zhao_horse_approach_spread", "special_delivery_start");
	add_actor_model_anim( "zhao_approach", %generic_human::ch_af_01_05_zhaoapproach_spread_zhao, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_1", %generic_human::ch_af_01_05_zhaoapproach_spread_muj01, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_2", %generic_human::ch_af_01_05_zhaoapproach_spread_muj02, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_3", %generic_human::ch_af_01_05_zhaoapproach_spread_muj03, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_4", %generic_human::ch_af_01_05_zhaoapproach_spread_muj04, undefined, true, undefined, undefined, "zhao_approach");	
	add_horse_anim( "zhao_spread_horse", %horse::ch_af_01_05_zhaoapproach_spread_zhao_horse, true);
	add_horse_anim( "muj_horse_approach_1", %horse::ch_af_01_05_zhaoapproach_spread_muj01_horse, true);
	add_horse_anim( "muj_horse_approach_2", %horse::ch_af_01_05_zhaoapproach_spread_muj02_horse, true);
	add_horse_anim( "muj_horse_approach_3", %horse::ch_af_01_05_zhaoapproach_spread_muj03_horse, true);
	add_horse_anim( "muj_horse_approach_4", %horse::ch_af_01_05_zhaoapproach_spread_muj04_horse, true);
	/*
	add_scene_loop("e1_zhao_horse_approach_spread_loop", "special_delivery_start");
	add_actor_model_anim( "zhao_approach", %generic_human::ch_af_01_05_zhaoapproach_spreadloop_zhao, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_1", %generic_human::ch_af_01_05_zhaoapproach_spreadloop_muj01, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_2", %generic_human::ch_af_01_05_zhaoapproach_spreadloop_muj02, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_3", %generic_human::ch_af_01_05_zhaoapproach_spreadloop_muj03, undefined, true, undefined, undefined, "zhao_approach");
	add_actor_model_anim( "horse_approach_4", %generic_human::ch_af_01_05_zhaoapproach_spreadloop_muj04, undefined, true, undefined, undefined, "zhao_approach");	
	add_horse_anim( "zhao_approach_horse", %horse::ch_af_01_05_zhaoapproach_spreadloop_zhao_horse, true);
	add_horse_anim( "muj_horse_approach_1", %horse::ch_af_01_05_zhaoapproach_spreadloop_muj01_horse, true);
	add_horse_anim( "muj_horse_approach_2", %horse::ch_af_01_05_zhaoapproach_spreadloop_muj02_horse, true);
	add_horse_anim( "muj_horse_approach_3", %horse::ch_af_01_05_zhaoapproach_spreadloop_muj03_horse, true);
	add_horse_anim( "muj_horse_approach_4", %horse::ch_af_01_05_zhaoapproach_spreadloop_muj04_horse, true);	
	 */
}

e1_s2_lotr_horse_scene()
{
	add_scene("e1_zhao_horse_charge_woods_intro", "special_delivery_start");
	add_actor_anim( "woods", %generic_human::ch_af_01_05_zhaointro_woods);
	//add_horse_anim( "woods_horse", %horse::ch_af_01_05_zhaointro_horse_woods);
	add_notetrack_flag("woods", "start_woods_horse", "start_woods_horse");	
	
	add_scene("e1_zhao_horse_charge_woods_horse_intro", "special_delivery_start");
	add_horse_anim( "woods_horse", %horse::ch_af_01_05_zhaointro_horse_woods);
	
	add_scene("e1_zhao_horse_charge_woods_intro_idle", "special_delivery_start", false, false, true);
	add_actor_anim( "woods", %generic_human::ch_af_01_05_zhaointro_woods_endidl);
	add_horse_anim( "woods_horse", %horse::ch_af_01_05_zhaointro_horse_woods_endidl);	
	
	add_scene("e1_zhao_horse_charge_player", "special_delivery_start");
	//add_notetrack_flag("player_body", "start_timescale", "time_scale_horse");
	//add_notetrack_flag("player_body", "stop_timescale", "time_scale_horse_end");
	add_notetrack_flag("player_body", "start_rocks", "time_scale_horse");
	add_notetrack_flag("player_body", "unhide_riders", "unhide_riders");	
	add_player_anim( "player_body",	 %player::p_af_01_05_zhaointro_player, true, 0, undefined, true, 1, 10, 10, 10, 10);

	add_notetrack_custom_function( "player_body", "raise_weapon", ::raise_weapon );
	add_notetrack_custom_function( "player_body", "lower_weapon", ::lower_weapon );
	
	add_notetrack_custom_function( "player_body", "dof_woods", maps\createart\afghanistan_art::dof_woods );
	add_notetrack_custom_function( "player_body", "dof_horses", maps\createart\afghanistan_art::dof_horses );
	add_notetrack_custom_function( "player_body", "dof_jumped", maps\createart\afghanistan_art::dof_jumped );
	add_notetrack_custom_function( "player_body", "dof_woods_up", maps\createart\afghanistan_art::dof_woods_up );
	add_notetrack_custom_function( "player_body", "dof_zhao", maps\createart\afghanistan_art::dof_zhao );
	add_notetrack_custom_function( "player_body", "dof_woods_end", maps\createart\afghanistan_art::dof_woods_end );
	
	add_scene( "e1_zhao_horse_charge", "special_delivery_start");
	add_actor_anim( "zhao", %generic_human::ch_af_01_05_zhaointro_zhao);
	add_horse_anim( "zhao_approach_horse", %horse::ch_af_01_05_zhaointro_horse_zhao);
	set_vehicle_unusable_in_scene("zhao_approach_horse");
	
	add_scene( "e1_zhao_horse_charge_idle", "special_delivery_start", false, false, true );	
	add_actor_anim( "zhao", %generic_human::ch_af_01_05_zhaointro_zhao_endidl);
	add_horse_anim( "zhao_approach_horse", %horse::ch_af_01_05_zhaointro_horse_zhao_endidl);	
	
	add_scene( "e1_horse_charge_muj1", "special_delivery_start" );
	add_actor_anim( "horse_muj_1", %generic_human::ch_af_01_05_henchman1, false, false, false, true );
	add_horse_anim( "muj_horse_1", %horse::ch_af_01_05_horse1);
	set_vehicle_unusable_in_scene("muj_horse_1");
	add_notetrack_fx_on_tag( "muj_horse_1", "Start_spin", "fx_afgh_sand_body_impact", "tag_origin" );
	
	add_scene( "e1_horse_charge_muj2", "special_delivery_start" );	
	add_actor_anim( "horse_muj_2", %generic_human::ch_af_01_05_henchman2, false, false, false, true );
	add_horse_anim( "muj_horse_2", %horse::ch_af_01_05_horse2);
	set_vehicle_unusable_in_scene("muj_horse_2");
	
	add_scene( "e1_horse_charge_muj3", "special_delivery_start" );
	add_actor_anim( "horse_muj_3", %generic_human::ch_af_01_05_henchman3, false, false, false, true );
	add_horse_anim( "muj_horse_3", %horse::ch_af_01_05_horse3);
	set_vehicle_unusable_in_scene("muj_horse_3");
	add_notetrack_fx_on_tag( "muj_horse_3", "Start_spin", "fx_afgh_sand_body_impact", "tag_origin" );
	
	add_scene( "e1_horse_charge_muj4", "special_delivery_start" );
	add_actor_anim( "horse_muj_4", %generic_human::ch_af_01_05_henchman4, false, false, false, true );
	add_horse_anim( "muj_horse_4", %horse::ch_af_01_05_horse4);
	set_vehicle_unusable_in_scene("muj_horse_4");
	add_prop_anim( "ammo_box", %animated_props::o_af_01_05_gunbox, "p6_anim_ammo_box" );
	
	add_scene( "e1_horse_charge_muj1_endloop", "special_delivery_start", false, false, true );
	add_horse_anim( "muj_horse_1", %horse::ch_af_01_05_horse1_endloop);
	add_actor_anim( "horse_muj_1", %generic_human::ch_af_01_05_henchman1_endloop, false, false, false, true );
	
	add_scene( "e1_horse_charge_muj2_endloop", "special_delivery_start", false, false, true );
	add_horse_anim( "muj_horse_2", %horse::ch_af_01_05_horse2_endloop);
	add_actor_anim( "horse_muj_2", %generic_human::ch_af_01_05_henchman2_endloop, false, false, false, true );
	
	add_scene( "e1_horse_charge_muj3_endloop", "special_delivery_start", false, false, true );
	add_horse_anim( "muj_horse_3", %horse::ch_af_01_05_horse3_endloop);
	add_actor_anim( "horse_muj_3", %generic_human::ch_af_01_05_henchman3_endloop, false, false, false, true );
	
	add_scene( "e1_horse_charge_muj4_endloop", "special_delivery_start", false, false, true );
	add_horse_anim( "muj_horse_4", %horse::ch_af_01_05_horse4_endloop);
	add_actor_anim( "horse_muj_4", %generic_human::ch_af_01_05_henchman4_endloop, false, false, false, true );
}


raise_weapon( player )
{
	level.player ShowViewModel();
	level.player EnableWeapons();
	level.player DisableWeaponFire();
}


lower_weapon( player )
{
	level.player EnableWeaponFire();
	level.player DisableWeapons();
}


ready_weapon( player )
{
	level.player ShowViewModel();
	level.player EnableWeapons();
	level.player DisableWeaponFire();
	level.player SetLowReady( true );
}


e1_s2_ride_vignettes()
{
	add_scene("e1_truck_offload", "jeep_unloading_weaponcache");
	add_actor_anim( "truck_muj_1", %generic_human::ch_af_02_02_truck_offload_muj1, false, false, false, true );
	add_actor_anim( "truck_muj_2", %generic_human::ch_af_02_02_truck_offload_muj2, true, false, false, true );
	add_vehicle_anim( "truck_offload", %vehicles::v_af_02_02_truck_offload_truck, undefined, undefined, undefined, undefined, undefined, undefined, undefined, true  );
	
	add_scene("e1_truck_offload_idle", "jeep_unloading_weaponcache");
	add_actor_anim( "truck_muj_1", %generic_human::ch_af_02_02_truck_offload_muj1_idle, false, false, false, true );
	
	add_scene("e1_truck_hold_truck_idle", "truck_vig_offload", false, false, false, false);
	add_actor_anim( "truck_muj_2", %generic_human::ch_af_02_02_truck_offload_muj2_idle, false, false, false, true, "tag_origin" );		
	
	add_scene( "e1_ride_lookout", undefined, undefined, undefined, true, true );
	add_actor_anim( "e1_ride_vig_lookout1", %generic_human::ch_af_02_01_ridge_lookout_guy1, false, false, false, true );
	add_actor_anim( "e1_ride_vig_lookout2", %generic_human::ch_af_02_01_ridge_lookout_guy2, false, false, false, true );	
}
/*
e1_s5_vulture_shoot_scene()
{
	add_scene("e1_s5_vulture_shoot_woods", "woods_horse");
	
	add_actor_anim( "woods", %generic_human::ch_af_01_05_vulture_shoot_woods, false, true, false, true, "tag_origin");
	add_horse_anim( "woods_horse", %horse::v_af_01_05_vulture_shoot_woods_horse);
	
	add_scene("e1_s5_vulture_shoot_zhao", "zhao_horse");
	
	add_actor_anim( "zhao", %generic_human::ch_af_01_05_vulture_shoot_zhao, false , true, false, true, "tag_origin");
	add_horse_anim( "zhao_horse", %horse::v_af_01_05_vulture_shoot_zhao_horse);
}
*/
e1_s2_lotr_woods_horse_scene()
{
	add_scene("e1_zhao_horse_charge_woods", "special_delivery_start");
	
	add_horse_anim( "woods_horse", %horse::ch_af_01_05_horse_woods);
}


/* ------------------------------------------------------------------------------------------
	Enter base camp
-------------------------------------------------------------------------------------------*/

walkto_cave_entrance_scene()
{
	add_scene( "walkto_cave_entrance", "rats_nest_struct" );
	
	add_actor_anim( "woods", %generic_human::ch_af_02_01_map_room_woods_walktocave, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_02_01_map_room_zhao_walktocave, false, true, false, true );
}


cave_entrance_wait_scene()
{
	add_scene( "cave_entrance_wait", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "woods", %generic_human::ch_af_02_01_enter_cave_woods_entrance_idle, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_02_01_enter_cave_zhao_entrance_idle, false, true, false, true );
}


cave_enter_scene()
{
	add_scene( "cave_enter", "rats_nest_struct" );
	
	add_actor_anim( "woods", %generic_human::ch_af_02_01_enter_cave_woods, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_02_01_enter_cave_zhao, false, true, false, true );
	add_actor_anim( "hudson", %generic_human::ch_af_02_01_enter_cave_hudson, false, true, false, true );
	add_actor_anim( "rebel_leader", %generic_human::ch_af_02_01_enter_cave_leader, false, true, false, true );	
}


map_room_wait_scene()
{
	add_scene( "map_room_wait", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "woods", %generic_human::ch_af_02_01_map_room_woods_idle, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_02_01_map_room_zhao_idle, false, true, false, true );
	//add_actor_anim( "hudson", %generic_human::ch_af_02_01_enter_cave_hudson_idle, false, true, false, true );
	add_actor_anim( "rebel_leader", %generic_human::ch_af_02_01_map_room_leader_idle, false, true, false, true );		
	
	add_scene( "map_room_wait_hudson", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "hudson", %generic_human::ch_af_02_01_enter_cave_hudson_idle, false, true, false, true );
	
	add_notetrack_custom_function( "player_body", "dof_woods", maps\createart\afghanistan_art::dof_omar );
}


map_room_scene()
{
	add_scene( "map_room", "rats_nest_struct" );
	
	add_actor_anim( "woods", %generic_human::ch_af_02_01_map_room_conversation_woods, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_02_01_map_room_conversation_zhao, false, true, false, true );
	add_actor_anim( "rebel_leader", %generic_human::ch_af_02_01_map_room_conversation_omar, false, true, false, true );
	add_player_anim( "player_body", %player::p_af_02_01_map_room_conversation_player, false, 0, undefined, true, 1, 45, 25, 10, 10 );
	
	add_notetrack_custom_function( "player_body", "dof_woods", maps\createart\afghanistan_art::dof_omar );
}


/* ------------------------------------------------------------------------------------------
	Exit base camp begin
-------------------------------------------------------------------------------------------*/
//Exit Map Room
e3_s1_leave_map_room_scene()
{
	add_scene( "e3_exit_map_room", "rats_nest_struct" );
	
	add_actor_anim( "woods", %generic_human::ch_af_03_01_base_leave_woods_exit, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_exit, false, true, false, true );
	//add_actor_anim( "rebel_leader", %generic_human::ch_af_03_01_base_leave_leader_exit, false, true, true, true );
	
	add_horse_anim( "zhao_horse", %horse::ch_af_03_01_base_leave_horse_zhao_exit );
	add_horse_anim( "woods_horse", %horse::ch_af_03_01_base_leave_horse_woods_exit );
	
	add_scene( "e3_exit_map_room_player", "rats_nest_struct" );
	add_player_anim("player_body", %player::p_af_03_01_base_leave_player_intro, true, 0, undefined, true, 1, 45, 25, 10, 10);
	add_actor_anim( "rebel_leader", %generic_human::ch_af_03_01_base_leave_leader_exit, false, true, true, true );	
	
	add_notetrack_custom_function( "player_body", "start_rifle_load", ::ready_weapon );
	add_notetrack_custom_function( "player_body", "dof_woods", maps\createart\afghanistan_art::dof_woods_end );	
}


//Wait at Cave Exit
e3_s1_map_room_idle_scene()
{
	add_scene( "e3_map_room_idle", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "woods", %generic_human::ch_af_03_01_base_leave_woods_idl, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_idl, true, false, false, true );
	//add_actor_anim( "rebel_leader", %generic_human::ch_af_03_01_base_leave_leader_idl, false, true, false, true );
	
	add_horse_anim( "zhao_horse", %horse::ch_af_03_01_base_leave_horse_zhao_idl );
	add_horse_anim( "woods_horse", %horse::ch_af_03_01_base_leave_horse_woods_idl );
}


//Ride Out
e3_s1_ride_out_scene()
{
	add_scene( "e3_ride_out", "rats_nest_struct" );
	
	add_actor_anim( "woods", %generic_human::ch_af_03_01_base_leave_woods_ride, false, true, false, true );
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_ride, false, true, false, true );
	
	add_horse_anim( "woods_horse", %horse::ch_af_03_01_base_leave_horse_woods_ride );
	add_horse_anim( "zhao_horse", %horse::ch_af_03_01_base_leave_horse_zhao_ride );
	
	add_scene( "fire_horse", "rats_nest_struct" );
	add_horse_anim( "flaming_horse", %horse::ch_af_03_01_base_leave_horse_onfire, true );
}


e3_s1_chopper_crash_scene()
{
	add_scene( "chopper_crash_overlooking_arena", undefined, false, false, false, true );
	add_vehicle_anim( "arena_chopper_crash", %vehicles::fxanim_afghan_chopper_crash_anim );
		
	add_notetrack_custom_function( "arena_chopper_crash", "exploder 10316 #cliff_impact", maps\afghanistan_firehorse::arena_chopper_crash );
	add_notetrack_custom_function( "arena_chopper_crash", "exploder 10317 #ground_impact", maps\afghanistan_firehorse::arena_rock_crash );
	add_notetrack_custom_function( "arena_chopper_crash", "exploder 10315 #chopper_hit", maps\afghanistan_firehorse::arena_chopper_trail );
}


e3_s1_arena_rocks_scene()
{
	add_scene( "chopper_crash_rocks", undefined, false, false, false, true );
	add_prop_anim( "chopper_crash_rockfall", %animated_props::fxanim_afghan_chopper_crash_rocks_anim );
	add_prop_anim( "chopper_crash_blades", %fxanim_props::fxanim_afghan_chopper_crash_blades_anim );
}


plant_explosive_dome_scene()
{
	add_scene( "plant_explosive_dome", "explosion_struct");
	add_player_anim( "player_hands", %player::int_afghan_cratercharge_plant, true );
	add_prop_anim( "crater_charge", %animated_props::o_afghan_cratercharge_plant );
	
	add_notetrack_custom_function( "player_hands", "plant", maps\afghanistan_wave_1::crater_charge_fx1 );
	add_notetrack_custom_function( "player_hands", "twist1", maps\afghanistan_wave_1::crater_charge_fx2 );
	add_notetrack_custom_function( "player_hands", "twist2", maps\afghanistan_wave_1::crater_charge_fx3 );
	add_notetrack_custom_function( "player_hands", "twist3", maps\afghanistan_wave_1::crater_charge_fx4 );
	add_notetrack_custom_function( "player_hands", "finalpush", maps\afghanistan_wave_1::crater_charge_fx5 );
}


plant_explosive_dome_stairs_scene()
{
	add_scene( "plant_explosive_dome_stairs", "explosion_struct");
	add_player_anim( "player_hands", %player::int_afghan_cratercharge_plant_from_stairs, true );
	add_prop_anim( "crater_charge", %animated_props::o_afghan_cratercharge_plant_from_stairs );
	
	add_notetrack_custom_function( "player_hands", "plant", maps\afghanistan_wave_1::crater_charge_fx1 );
	add_notetrack_custom_function( "player_hands", "twist1", maps\afghanistan_wave_1::crater_charge_fx2 );
	add_notetrack_custom_function( "player_hands", "twist2", maps\afghanistan_wave_1::crater_charge_fx3 );
	add_notetrack_custom_function( "player_hands", "twist3", maps\afghanistan_wave_1::crater_charge_fx4 );
	add_notetrack_custom_function( "player_hands", "finalpush", maps\afghanistan_wave_1::crater_charge_fx5 );
}


/* ------------------------------------------------------------------------------------------
	Exit base camp end
-------------------------------------------------------------------------------------------*/

// add_actor_anim( <str_animname>, <animation>, [do_hide_weapon], [do_give_back_weapon], [do_delete], [do_not_allow_death], [str_tag] )
e2_s1_base_activity()
{
	add_scene( "e2_walk_in", "by_numbers_struct", true );
	add_actor_anim("woods", %generic_human::ch_af_02_02_woods, true, true, false, true );
	add_actor_anim("zhao", %generic_human::ch_af_02_02_zhao, true, true, false, true );
//	
	add_scene( "e2_leader_hudson_waiting", "by_numbers_struct");
	add_actor_anim("rebel_leader", %generic_human::ch_af_02_02_leader, true, true, false, true );
	add_actor_anim("hudson", %generic_human::ch_af_02_02_hudson, true, true, false, true );
	//add_horse_anim( "zhao_horse", %horse::ch_af_02_02_horse_zhao);
	//add_horse_anim( "woods_horse", %horse::ch_af_02_02_horse_woods);
	
	add_scene( "e2_tower_lookout_startidl", "rats_nest_struct", false, false, true );
	add_actor_model_anim("muj_lookout_1",%generic_human::ch_af_02_01_tower_lookout_1_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_lookout_2",%generic_human::ch_af_02_01_tower_lookout_2_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	
//	add_actor_model_anim("muj_lookout_1", %generic_human::ch_af_02_01_tower_lookout_1_startidl);
//	add_actor_model_anim("muj_lookout_2", %generic_human::ch_af_02_01_tower_lookout_2_startidl);
	
	add_scene( "e2_tower_lookout_follow", "rats_nest_struct" );
	add_actor_model_anim("muj_lookout_1",%generic_human::ch_af_02_01_tower_lookout_1_follow, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_lookout_2",%generic_human::ch_af_02_01_tower_lookout_2_follow, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	
//	add_actor_model_anim("muj_lookout_1", %generic_human::ch_af_02_01_tower_lookout_1_follow);
//	add_actor_model_anim("muj_lookout_2", %generic_human::ch_af_02_01_tower_lookout_2_follow);

	add_scene( "e2_tower_lookout_endidl", "rats_nest_struct", false, false, true );
	add_actor_model_anim("muj_lookout_1",%generic_human::ch_af_02_01_tower_lookout_1_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_lookout_2",%generic_human::ch_af_02_01_tower_lookout_2_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	
	//add_actor_model_anim("muj_lookout_1", %generic_human::ch_af_02_01_tower_lookout_1_endidl, undefined, true);
	//add_actor_model_anim("muj_lookout_2", %generic_human::ch_af_02_01_tower_lookout_2_endidl, undefined, true);
	
	add_scene( "e2_window_startidl", "rats_nest_struct", false, false, true );
	add_actor_model_anim("muj_window",%generic_human::ch_af_02_01_window_lookout_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	//add_actor_model_anim("muj_window", %generic_human::ch_af_02_01_window_lookout_startidl);
	
	add_scene( "e2_window_follow", "rats_nest_struct" );
	add_actor_model_anim("muj_window",%generic_human::ch_af_02_01_window_lookout_follow, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	//add_actor_model_anim("muj_window", %generic_human::ch_af_02_01_window_lookout_follow, undefined, true);
	
	add_scene( "e2_drum_burner", "rats_nest_struct", false, false, true);
	add_actor_model_anim( "muj_drum_burner", %generic_human::ch_af_02_01_fire_drum_burner, undefined, false, undefined, undefined, "muj_assault" );
	
	//add_scene( "e2_ridge_lookout", "rats_nest_struct", false, false, true);
	//add_actor_anim("muj_ridge_lookout_1", %generic_human::ch_af_02_01_ridge_lookout_guy1, false, false, true, true);
	//add_actor_anim("muj_ridge_lookout_2", %generic_human::ch_af_02_01_ridge_lookout_guy2, false, false, true, true);
	
	add_scene( "e2_stacker_carry_1", "rats_nest_struct");
	add_actor_anim( "muj_stacker_1", %generic_human::ch_af_02_01_gun_stackers_muj1_carry, false, false, false, true );
	add_prop_anim("muj_stacker_gun1", %animated_props::o_af_02_01_gun_stackers_ak1_carry, "t6_wpn_ar_ak47_prop");//t6_wpn_pulwar_sword_prop
	add_notetrack_level_notify( "muj_stacker_1", "start_muj2_mainanim", "stacker_2_carry" );
	
	add_scene( "e2_stacker_carry_2", "rats_nest_struct", false, false, true);
	add_actor_anim("muj_stacker_2", %generic_human::ch_af_02_01_gun_stackers_muj2_carry, false, false, false, true);
	add_prop_anim("muj_stacker_gun2", %animated_props::o_af_02_01_gun_stackers_ak2_carry, "t6_wpn_ar_ak47_prop");
	
	add_scene( "e2_stacker_3", "rats_nest_struct", false, false, true);
	add_actor_anim("muj_stacker_3", %generic_human::ch_af_02_01_gun_stackers_muj3, false, false, true, true);
	add_prop_anim("muj_stacker_gun3", %animated_props::o_af_02_01_gun_stackers_ak3, "t6_wpn_ar_ak47_prop");
	
	add_scene( "e2_stacker_main_2", "rats_nest_struct");
	add_actor_anim("muj_stacker_2", %generic_human::ch_af_02_01_gun_stackers_muj2_main, false, false, false, true);
	
	add_scene( "e2_stacker_endidl", "rats_nest_struct", false, false, true);
	add_actor_anim("muj_stacker_1", %generic_human::ch_af_02_01_gun_stackers_muj1_endidl, false, false, true, true);
	add_actor_anim("muj_stacker_2", %generic_human::ch_af_02_01_gun_stackers_muj2_endidl, false, false, true, true);
	add_prop_anim("muj_stacker_gun1", %animated_props::o_af_02_01_gun_stackers_ak1_endidl, "t6_wpn_ar_ak47_prop");
	add_prop_anim("muj_stacker_gun2", %animated_props::o_af_02_01_gun_stackers_ak2_endidl, "t6_wpn_ar_ak47_prop");
	
	add_scene( "e2_generator", "rats_nest_struct", false, false, true );
	add_actor_anim( "muj_generator", %generic_human::ch_af_02_01_generatorguy, true, false, false, true );
	
	add_scene( "e2_walltop_start", "base_wall_struct", false, false, true);
	add_actor_model_anim("muj_walltop1",%generic_human::ch_af_02_01_walltop1_muj1_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop2",%generic_human::ch_af_02_01_walltop1_muj2_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop3",%generic_human::ch_af_02_01_walltop2_muj1_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop4",%generic_human::ch_af_02_01_walltop2_muj2_startidl, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	
	add_scene( "e2_walltop_lookout", "base_wall_struct");
	add_actor_model_anim("muj_walltop1",%generic_human::ch_af_02_01_walltop1_muj1_lookout, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop2",%generic_human::ch_af_02_01_walltop1_muj2_lookout, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop3",%generic_human::ch_af_02_01_walltop2_muj1_lookout, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop4",%generic_human::ch_af_02_01_walltop2_muj2_lookout, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");

	add_scene( "e2_walltop_end", "base_wall_struct", false, false, true);
	add_actor_model_anim("muj_walltop1",%generic_human::ch_af_02_01_walltop1_muj1_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop2",%generic_human::ch_af_02_01_walltop1_muj2_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop3",%generic_human::ch_af_02_01_walltop2_muj1_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_walltop4",%generic_human::ch_af_02_01_walltop2_muj2_endidl, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");		
	
	add_scene( "e2_runout_startidl_1", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_1",%generic_human::ch_af_02_01_runout_muj1_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_startidl_2", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_2",%generic_human::ch_af_02_01_runout_muj2_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_startidl_3", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_3",%generic_human::ch_af_02_01_runout_muj3_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_startidl_4", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_4",%generic_human::ch_af_02_01_runout_muj4_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_startidl_5", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_5",%generic_human::ch_af_02_01_runout_muj5_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_startidl_6", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_runout_6",%generic_human::ch_af_02_01_runout_muj6_startidl, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_1", "rats_nest_struct" );
	add_actor_anim("muj_runout_1",%generic_human::ch_af_02_01_runout_muj1_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_2", "rats_nest_struct" );
	add_actor_anim("muj_runout_2",%generic_human::ch_af_02_01_runout_muj2_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_3", "rats_nest_struct" );
	add_actor_anim("muj_runout_3",%generic_human::ch_af_02_01_runout_muj3_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_4", "rats_nest_struct" );
	add_actor_anim("muj_runout_4",%generic_human::ch_af_02_01_runout_muj4_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_5", "rats_nest_struct" );
	add_actor_anim("muj_runout_5",%generic_human::ch_af_02_01_runout_muj5_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_runout_run_6", "rats_nest_struct" );
	add_actor_anim("muj_runout_6",%generic_human::ch_af_02_01_runout_muj6_run, undefined, undefined, undefined, true);
	
	add_scene( "e2_tank_guy", "rats_nest_struct" );
	add_actor_anim("muj_tank_guy",%generic_human::ch_af_02_01_tankguy_gesture, undefined, undefined, undefined, true);	
	
	add_scene( "e2_rooftop_guys", "rats_nest_struct", false, false, true );
	add_actor_model_anim("muj_rooftop1",%generic_human::ch_af_02_01_rooftops_muj1, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_rooftop2",%generic_human::ch_af_02_01_rooftops_muj2, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_rooftop3",%generic_human::ch_af_02_01_rooftops_muj3, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_rooftop4",%generic_human::ch_af_02_01_rooftops_muj4, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	//add_actor_model_anim("muj_rooftop5",%generic_human::ch_af_02_01_rooftops_muj5, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_rooftop6",%generic_human::ch_af_02_01_rooftops_muj6, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");	
}

e2_s1_ride_scenes()
{
	add_scene( "e2_tank_ride_idle_start", "tank_intro_node", false, false, true );
	//add_actor_anim("muj_tank_ride1",%generic_human::ch_af_02_01_tank_ruin_muj1_startidl, undefined, undefined, undefined, true);
	//add_actor_anim("muj_tank_ride2",%generic_human::ch_af_02_01_tank_ruin_muj2_startidl, undefined, undefined, undefined, true);
	add_actor_model_anim( "muj_tank_ride1", %generic_human::ch_af_02_01_tank_ruin_muj1_startidl, undefined, false, undefined, undefined, "muj_assault" );
	add_actor_model_anim( "muj_tank_ride2", %generic_human::ch_af_02_01_tank_ruin_muj2_startidl, undefined, false, undefined, undefined, "muj_assault" );

	add_scene( "e2_tank_ride_idle", "tank_intro_node" );
	//add_actor_anim("muj_tank_ride1",%generic_human::ch_af_02_01_tank_ruin_muj1_tracking, undefined, undefined, undefined, true);
	//add_actor_anim("muj_tank_ride2",%generic_human::ch_af_02_01_tank_ruin_muj2_tracking, undefined, undefined, undefined, true);
	add_actor_model_anim( "muj_tank_ride1", %generic_human::ch_af_02_01_tank_ruin_muj1_tracking, undefined, true, undefined, undefined, "muj_assault" );
	add_actor_model_anim( "muj_tank_ride2", %generic_human::ch_af_02_01_tank_ruin_muj2_tracking, undefined, true, undefined, undefined, "muj_assault" );

	add_scene( "e2_tank_ride_idle_end", "tank_intro_node", false, false, true );
	//add_actor_anim("muj_tank_ride1",%generic_human::ch_af_02_01_tank_ruin_muj1_endidl, undefined, undefined, undefined, true);
	//add_actor_anim("muj_tank_ride2",%generic_human::ch_af_02_01_tank_ruin_muj2_endidl, undefined, undefined, undefined, true);	
	add_actor_model_anim( "muj_tank_ride1", %generic_human::ch_af_02_01_tank_ruin_muj1_endidl, undefined, true, undefined, undefined, "muj_assault" );
	add_actor_model_anim( "muj_tank_ride2", %generic_human::ch_af_02_01_tank_ruin_muj2_endidl, undefined, true, undefined, undefined, "muj_assault" );
}

e2_s1_base_props()
{
	/*
	add_scene( "e2_herder_startidl", "rats_nest_struct", false, false, true);
	add_actor_anim("muj_herder", %generic_human::ch_af_02_01_goatherder_startidl, true, false, false, true);
	add_prop_anim("muj_goat1", %animated_props::ch_af_02_01_goat_01_startidl, "p6_anim_goat");
	add_prop_anim("muj_goat2", %animated_props::ch_af_02_01_goat_02_startidl, "p6_anim_goat");
	add_prop_anim("muj_goat3", %animated_props::ch_af_02_01_goat_03_startidl, "p6_anim_goat");
	add_prop_anim("muj_goat4", %animated_props::ch_af_02_01_goat_04_startidl, "p6_anim_goat");
	add_prop_anim("muj_goat5", %animated_props::ch_af_02_01_goat_05_startidl, "p6_anim_goat");
	
	add_scene( "e2_herder_move", "rats_nest_struct");
	add_actor_anim("muj_herder", %generic_human::ch_af_02_01_goatherder_move, false, false, false, true);
	add_prop_anim("muj_goat1", %animated_props::ch_af_02_01_goat_01_move, "p6_anim_goat");
	add_prop_anim("muj_goat2", %animated_props::ch_af_02_01_goat_02_move, "p6_anim_goat");
	add_prop_anim("muj_goat3", %animated_props::ch_af_02_01_goat_03_move, "p6_anim_goat");
	add_prop_anim("muj_goat4", %animated_props::ch_af_02_01_goat_04_move, "p6_anim_goat");
	add_prop_anim("muj_goat5", %animated_props::ch_af_02_01_goat_05_move, "p6_anim_goat");	
	
	add_scene( "e2_herder_endidl", "rats_nest_struct", false, false, true);
	add_actor_anim("muj_herder", %generic_human::ch_af_02_01_goatherder_endidl, false, false, true, true);
	add_prop_anim("muj_goat1", %animated_props::ch_af_02_01_goat_01_endidl, "p6_anim_goat");
	add_prop_anim("muj_goat2", %animated_props::ch_af_02_01_goat_02_endidl, "p6_anim_goat");
	add_prop_anim("muj_goat3", %animated_props::ch_af_02_01_goat_03_endidl, "p6_anim_goat");
	add_prop_anim("muj_goat4", %animated_props::ch_af_02_01_goat_04_endidl, "p6_anim_goat");
	add_prop_anim("muj_goat5", %animated_props::ch_af_02_01_goat_05_endidl, "p6_anim_goat");
	*/
//	add_scene( "e2_gas_guys", "rats_nest_struct", false, false, true);
//	add_actor_anim("muj_gas_1", %generic_human::ch_af_02_01_gasguys_muj1, false, false, true, true);
//	add_actor_anim("muj_gas_2", %generic_human::ch_af_02_01_gasguys_muj2, false, false, true, true);
//	add_prop_anim("muj_gas_bucket", %animated_props::ch_af_02_01_gasguys_bucket, "p6_empty_bucket_anim" );
//	add_prop_anim("muj_gas_can1", %animated_props::ch_af_02_01_gasguys_can1, "anim_rus_gascan" );
//	add_prop_anim("muj_gas_can2", %animated_props::ch_af_02_01_gasguys_can2, "anim_rus_gascan" );
//	add_prop_anim("muj_gas_can3", %animated_props::ch_af_02_01_gasguys_can3, "anim_rus_gascan" );
	
	add_scene( "e2_cooking_muj", "rats_nest_struct", false, false, true);
	add_actor_model_anim("muj_cooking_1", %generic_human::ch_af_02_01_cooking_muj1, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cooking_2", %generic_human::ch_af_02_01_cooking_muj2, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cooking_3", %generic_human::ch_af_02_01_cooking_muj3, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_prop_anim("muj_cooking_pipe", %animated_props::o_af_02_01_cooking_muj_pipe, "p6_anim_smoking_pipe");	
	
	add_scene( "e2_smokers", "rats_nest_struct", false, false, true);
	add_actor_model_anim("muj_smoker_1",%generic_human::ch_af_02_01_smoker1, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_smoker_2",%generic_human::ch_af_02_01_smoker2, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	
	//add_actor_model_anim("muj_smoker_1", %generic_human::ch_af_02_01_smoker1, undefined, true);
	//add_actor_model_anim("muj_smoker_2", %generic_human::ch_af_02_01_smoker2, undefined, true);	
	add_prop_anim("muj_smoker_pipe", %animated_props::o_af_02_01_smoker_hookah, "com_hookah_pipe_anim");
	
	add_scene( "e2_stinger_move", "rats_nest_struct" );
	add_actor_anim("muj_stingers_1", %generic_human::ch_af_02_01_stingers_muj1_move, false, false, false, true);
	add_actor_anim("muj_stingers_2", %generic_human::ch_af_02_01_stingers_muj2_move, false, false, false, true);
	add_prop_anim("muj_stingers_crate", %animated_props::o_af_02_01_stingers_crate_move, "jun_ammo_crate_anim");
	add_prop_anim("muj_stingers_barrow", %animated_props::ch_af_02_01_stingers_cart_move, "p6_street_vendor_wheel_barrow_anim");
	
	add_scene( "e2_stinger_endidl", "rats_nest_struct", false, false, true );
	add_actor_anim("muj_stingers_1", %generic_human::ch_af_02_01_stingers_muj1_endidl, false, false, true, true);
	add_actor_anim("muj_stingers_2", %generic_human::ch_af_02_01_stingers_muj2_endidl, false, false, true, true);	
	add_prop_anim("muj_stingers_crate", %animated_props::o_af_02_01_stingers_crate_endidl, "jun_ammo_crate_anim");	
	add_prop_anim("muj_stingers_barrow", %animated_props::ch_af_02_01_stingers_cart_endidl, "p6_street_vendor_wheel_barrow_anim");
	
	add_scene( "e2_gunsmith", "rats_nest_struct", false, false, true);
	add_actor_model_anim("muj_hammer",%generic_human::ch_af_02_01_gunsmith_hammerguy, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_grinder",%generic_human::ch_af_02_01_gunsmith_polishguy_no_grinder, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	//add_actor_model_anim("muj_hammer", %generic_human::ch_af_02_01_gunsmith_hammerguy, undefined, true);
	//add_actor_model_anim("muj_grinder", %generic_human::ch_af_02_01_gunsmith_polishguy_no_grinder, undefined, true);	
	add_prop_anim("muj_hammer_pile1", %animated_props::o_af_02_01_gunsmith_pile1, "p6_bullet_shell_pile_large_anim");	
	add_prop_anim("muj_hammer_pile2", %animated_props::o_af_02_01_gunsmith_pile2, "p6_bullet_shell_pile_small_anim");
	add_prop_anim("muj_hammer_pile3", %animated_props::o_af_02_01_gunsmith_pile3, "p6_bullet_shell_pile_large_anim");
	
	add_scene( "e2_ammo", "rats_nest_struct" );
	add_actor_anim("muj_ammo", %generic_human::ch_af_02_01_ammoguy, true, false, false, true );
	add_prop_anim("muj_ammo1", %animated_props::ch_af_02_01_ammoguy_ammo1, "mil_ammo_case_anim_1");
	add_prop_anim("muj_ammo2", %animated_props::ch_af_02_01_ammoguy_ammo2, "mil_ammo_case_anim_1");
	add_prop_anim("muj_ammo3", %animated_props::ch_af_02_01_ammoguy_ammo3, "mil_ammo_case_anim_1");
	
	add_scene( "e2_ammo02", "rats_nest_struct" );
	add_actor_anim( "muj_ammo", %generic_human::ch_af_02_01_ammoguy02, true, false, false, true );
	
	add_scene( "e2_ammo03", "rats_nest_struct" );
	add_actor_anim( "muj_ammo", %generic_human::ch_af_02_01_ammoguy03, true, false, false, true );
	
	add_scene( "e2_ammo04", "rats_nest_struct" );
	add_actor_anim( "muj_ammo", %generic_human::ch_af_02_01_ammoguy04, true, false, false, true );
	
	add_scene( "e2_horse_eat", "base_horse_pos2", false, false, true);
	add_prop_anim("muj_horse_eat", %horse::a_horse_eat_idle, "anim_horse1_fb");	
}


//e2_s1_map_loop_scene()
//{
//	add_scene( "e2_s1_map_loop", "by_numbers_struct", false, false, true );
//	add_actor_anim("woods", %generic_human::ch_af_02_02_map_room_ambient_woods, true, true, false, true );
//	add_actor_anim("rebel_leader", %generic_human::ch_af_02_02_map_room_ambient_leader, true, true, false, true );
//	add_actor_anim("hudson", %generic_human::ch_af_02_02_map_room_ambient_hudson, true, true, false, true );
//	add_actor_anim("zhao", %generic_human::ch_af_02_02_map_room_ambient_zhao, true, true, false, true );
//}


e4_s1_return_base_lineup_scene()
{
	add_scene("e4_s1_return_base_lineup", "skipto_horse_charge");
	
	add_player_anim("player_body", %player::p_af_04_01_return_base_player_lineup, true, 0, undefined, true, 1, 10, 10, 10, 10);
	
	add_horse_anim("mason_horse", %horse::ch_af_04_01_return_base_player_horse_lineup);
	set_vehicle_unusable_in_scene("mason_horse");
	
	add_horse_anim("zhao_horse", %horse::ch_af_04_01_return_base_zhao_horse_lineup);
	set_vehicle_unusable_in_scene("zhao_horse");
	
	add_horse_anim("woods_horse", %horse::ch_af_04_01_return_base_woods_horse_lineup);
	set_vehicle_unusable_in_scene("woods_horse");
	
//	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_lineup);
//	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_lineup);
//	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_lineup);
//	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_lineup);
//	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_lineup);
//	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_lineup);
	
	add_actor_anim("woods", %generic_human::ch_af_04_01_return_base_woods_lineup, false, true, false, true);
	add_actor_anim("zhao", %generic_human::ch_af_04_01_return_base_zhao_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_0", %generic_human::ch_af_04_01_return_base_left1_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_1", %generic_human::ch_af_04_01_return_base_left2_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_2", %generic_human::ch_af_04_01_return_base_left3_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_3", %generic_human::ch_af_04_01_return_base_right1_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_4", %generic_human::ch_af_04_01_return_base_right2_lineup, false, true, false, true);
//	add_actor_anim("muj_rider_5", %generic_human::ch_af_04_01_return_base_right3_lineup, false, true, false, true);
	
	//-------	extras to add
	//add_actor_anim("muj_rider_0", %horse::ch_af_04_01_return_base_right4_lineup);
	//add_actor_anim("muj_rider_0", %horse::ch_af_04_01_return_base_right5_lineup);
	//add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_right4_horse_lineup);
	//add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_right5_horse_lineup);
	//------------------------
}

e4_s1_return_base_lineup_single_scene()
{
	add_scene("e4_s1_return_base_lineup_single", "skipto_horse_charge");
	
	add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_lineup);
	add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_lineup);
	add_horse_anim("woods_horse", %horse::ch_af_04_01_return_base_woods_horse_lineup);
	
	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_lineup);
	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_lineup);
	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_lineup);
	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_lineup);
	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_lineup);
	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_lineup);
	
	//add_actor_anim("woods", %generic_human::ch_af_04_01_return_base_woods_lineup);
	add_actor_anim("zhao", %generic_human::ch_af_04_01_return_base_zhao_lineup, false, true, false, true);
	add_actor_anim("muj_rider_0", %generic_human::ch_af_04_01_return_base_left1_lineup, false, true, false, true);
	add_actor_anim("muj_rider_1", %generic_human::ch_af_04_01_return_base_left2_lineup, false, true, false, true);
	add_actor_anim("muj_rider_2", %generic_human::ch_af_04_01_return_base_left3_lineup, false, true, false, true);
	add_actor_anim("muj_rider_3", %generic_human::ch_af_04_01_return_base_right1_lineup, false, true, false, true);
	add_actor_anim("muj_rider_4", %generic_human::ch_af_04_01_return_base_right2_lineup, false, true, false, true);
	add_actor_anim("muj_rider_5", %generic_human::ch_af_04_01_return_base_right3_lineup, false, true, false, true);
	
	//-------	extras to add
	//add_actor_anim("muj_rider_0", %horse::ch_af_04_01_return_base_right4_lineup);
	//add_actor_anim("muj_rider_0", %horse::ch_af_04_01_return_base_right5_lineup);
	//add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_right4_horse_lineup);
	//add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_right5_horse_lineup);
	//------------------------
}


e4_s1_binoc_scene()
{
	add_scene( "e4_s1_binoc", "arena_struct" );
	
	add_vehicle_anim( "krav_tank", %vehicles::v_af_04_03_through_binoculars_tank );
	add_player_anim( "player_body", %player::p_af_04_03_through_binoculars_player );
	add_actor_anim( "battle_muj1", %generic_human::ch_af_04_03_through_binoculars_helper, false, false, true, true );
	add_actor_anim( "battle_muj2", %generic_human::ch_af_04_03_through_binoculars_wounded, false, false, true, true );
	
	add_notetrack_custom_function( "krav_tank", "shoot_machinegun", ::krav_tank_machinegun );
	add_notetrack_custom_function( "krav_tank", "shoot_canon", ::krav_tank_cannon );
}


krav_tank_machinegun( krav_tank )
{
	ai_muj = get_ais_from_scene( "e4_s1_binoc", "battle_muj2" );
	
	for ( i = 0; i < 20; i++ )
	{
		MagicBullet( "btr60_heavy_machinegun", krav_tank GetTagOrigin( "tag_flash_gunner1" ), ai_muj.origin + ( RandomIntRange( -100, 100 ), 0, 0 ) );
		
		if ( i == 5 )
		{
			PlayFXOnTag( level._effect[ "sniper_impact" ], ai_muj, "J_Head" );	
		}
		
		wait 0.05;
	}
}


krav_tank_cannon( krav_tank )
{
	ai_muj = get_ais_from_scene( "e4_s1_binoc", "battle_muj1" );
	
	PlayFX( level._effect[ "explode_grenade_sand" ], ai_muj.origin );
}



e4_s1_return_base_charge_scene()
{
	add_scene("e4_s1_return_base_charge", "skipto_horse_charge");

	add_player_anim("player_body", %player::p_af_04_01_return_base_player_charge, true, 0, undefined, true, 1, 10, 10, 10, 10);
	add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_charge);
	set_vehicle_unusable_in_scene("players_horse_for_charge");
	
	add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_charge);
	add_horse_anim("woods_horse", %horse::ch_af_04_01_return_base_woods_horse_charge);
	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_charge);
	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_charge);
	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_charge);
	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_charge);
	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_charge);
	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_charge);
	
	set_vehicle_unusable_in_scene("horse_for_charge_zhao");
	set_vehicle_unusable_in_scene("woods_horse");
	set_vehicle_unusable_in_scene("horse_for_charge_0");
	set_vehicle_unusable_in_scene("horse_for_charge_1");
	set_vehicle_unusable_in_scene("horse_for_charge_2");
	set_vehicle_unusable_in_scene("horse_for_charge_3");
	set_vehicle_unusable_in_scene("horse_for_charge_4");
	set_vehicle_unusable_in_scene("horse_for_charge_5");
	
	add_actor_anim("woods", %generic_human::ch_af_04_01_return_base_woods_charge, false, true, false, true);
	add_actor_anim("zhao", %generic_human::ch_af_04_01_return_base_zhao_charge, false, true, false, true);
	add_actor_anim("muj_rider_0", %generic_human::ch_af_04_01_return_base_left1_charge, false, true, false, true);
	add_actor_anim("muj_rider_1", %generic_human::ch_af_04_01_return_base_left2_charge, false, true, false, true);
	add_actor_anim("muj_rider_2", %generic_human::ch_af_04_01_return_base_left3_charge, false, true, false, true);
	add_actor_anim("muj_rider_3", %generic_human::ch_af_04_01_return_base_right1_charge, false, true, false, true);
	add_actor_anim("muj_rider_4", %generic_human::ch_af_04_01_return_base_right2_charge, false, true, false, true);
	add_actor_anim("muj_rider_5", %generic_human::ch_af_04_01_return_base_right3_charge, false, true, false, true);
}

//-- used for first frame hold
e4_s1_return_base_charge_scene_no_player()
{
	add_scene("e4_s1_return_base_charge_freeze", "skipto_horse_charge");

	add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_charge);
	add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_charge);
	add_horse_anim("woods_horse", %horse::ch_af_04_01_return_base_woods_horse_charge);
	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_charge);
	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_charge);
	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_charge);
	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_charge);
	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_charge);
	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_charge);
	
	add_actor_anim("woods", %generic_human::ch_af_04_01_return_base_woods_charge);
	add_actor_anim("zhao", %generic_human::ch_af_04_01_return_base_zhao_charge);
	add_actor_anim("muj_rider_0", %generic_human::ch_af_04_01_return_base_left1_charge, false, true, false, true);
	add_actor_anim("muj_rider_1", %generic_human::ch_af_04_01_return_base_left2_charge, false, true, false, true);
	add_actor_anim("muj_rider_2", %generic_human::ch_af_04_01_return_base_left3_charge, false, true, false, true);
	add_actor_anim("muj_rider_3", %generic_human::ch_af_04_01_return_base_right1_charge, false, true, false, true);
	add_actor_anim("muj_rider_4", %generic_human::ch_af_04_01_return_base_right2_charge, false, true, false, true);
	add_actor_anim("muj_rider_5", %generic_human::ch_af_04_01_return_base_right3_charge, false, true, false, true);
}


e4_s5_player_and_horse_fall()
{
	add_scene( "e4_s5_player_horse_fall", "arena_struct");
	add_player_anim("player_body", %player::p_af_04_05_thrown_player_fall);
	add_prop_anim("prop_horse", %animated_props::ch_af_04_05_thown_horse_fall, "anim_horse1_fb");
	
	add_scene( "e4_s5_player_horse_pushloop", "arena_struct", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim("player_body", %player::p_af_04_05_thrown_player_pushloop );
	add_prop_anim("prop_horse", %animated_props::ch_af_04_05_thown_horse_pushloop, "anim_horse1_fb");
	
	// horse push success
	add_scene( "e4_s5_player_horse_push_success", "arena_struct" );
	add_player_anim( "player_body", %player::p_af_04_05_thrown_player_push_success );
	add_prop_anim( "prop_horse", %animated_props::ch_af_04_05_thrown_horse_success, "anim_horse1_fb" );
	
	// idle and push use anim code calls, so declare the old way
	// horse push loop
	level.scr_anim[ "player_body" ][ "e4_s5_player_horse_push_loop" ] = %player::p_af_04_05_thrown_player_pushloop;
	level.scr_anim[ "prop_horse" ][ "e4_s5_horse_horse_push_loop" ] = %animated_props::ch_af_04_05_thown_horse_pushloop;
	
	// horse push 
	level.scr_anim[ "player_body" ][ "e4_s5_player_horse_push" ] = %player::p_af_04_05_thrown_player_push;
	level.scr_anim[ "prop_horse" ][ "e4_s5_horse_horse_push" ] = %animated_props::ch_af_04_05_thrown_horse_push;
}


e4_s5_tank_fall()
{
	//add_scene( "e4_s5_tank_path", "arena_struct" );
	//add_vehicle_anim( "krav_tank", %vehicles::v_af_04_06_reunion_tank_whole_path );
	
	add_scene( "e4_s5_tank_path_horsepush", "arena_struct" );
	add_vehicle_anim( "krav_tank", %vehicles::v_af_04_06_reunion_tank_horsepush );
	
	add_scene( "e4_s5_tank_path_runtowoods", "arena_struct" );
	add_vehicle_anim( "krav_tank", %vehicles::v_af_04_06_reunion_tank_runtowoods );
	
	add_scene( "e4_s5_tank_path_tankbattle", "arena_struct" );
	add_vehicle_anim( "krav_tank", %vehicles::v_af_04_06_reunion_tank_tankbattle );
}


e4_s6_player_grabs_on_tank_scene()
{
	add_scene( "e4_s6_player_grabs_on_tank", "arena_struct" );
	add_player_anim( "player_body", %player::p_af_04_06_reunion_player_run2tank );
	add_notetrack_flag( "player_body", "runtowoods", "start_runtowoods_tank");
	add_notetrack_flag( "player_body", "tankbattle", "start_tankbattle_tank");
//	add_prop_anim( "prop_horse", %animated_props::ch_af_04_06_reunion_horse_run2tank, "anim_horse1_black_fb", true );
	
	//add_horse_anim("players_horse_for_fall_anim", %horse::ch_af_04_06_reunion_horse_run2tank);
	//add_vehicle_anim("krav_tank", %vehicles::v_af_04_06_reunion_tank_run2tank);
	//add_prop_anim("mortar", %animated_props::o_af_04_06_reunion_mortar_run2tank, "t6_wpn_mortar_shell_prop_view");
	
	add_actor_anim( "woods", %generic_human::ch_af_04_06_reunion_woods_run2tank );
	add_horse_anim( "woods_horse", %horse::ch_af_04_06_reunion_horse_woods_run2tank );
	
	add_notetrack_flag( "player_body", "start_shake", "start_kravchenko_tank_earthquake" );
}


//e4_s6_tank_fight_tank_scene()
//{
//	add_scene("e4_s6_tank_fight_tank", "horse_death_loc");
//	add_vehicle_anim("krav_tank", %vehicles::v_af_04_06_reunion_tank_tankfight);
//}


e4_s6_tank_fight_scene()
{
	add_scene( "e4_s6_tank_fight", "krav_tank" );
	
	add_player_anim("player_body", %player::p_af_04_06_reunion_player_tankfight, true, 0, "origin_animate_jnt");
	add_prop_anim("mortar", %animated_props::o_af_04_06_reunion_mortar_tankfight, "t6_wpn_mortar_shell_prop_view", true, false, undefined, "origin_animate_jnt");
	
	add_actor_anim("kravchenko", %generic_human::ch_af_04_06_reunion_krav_tankfight, true, false, false, true, "origin_animate_jnt" );
	
	add_actor_anim( "woods", %generic_human::ch_af_04_06_reunion_woods_tankfight, false, false, false, true, "origin_animate_jnt" );
	add_horse_anim( "woods_horse", %horse::ch_af_04_06_reunion_horse_woods_tankfight, false, undefined, "origin_animate_jnt" );
	
	add_actor_anim( "soviet_guard", %generic_human::ch_af_04_06_reunion_guard_tankfight, false, false, true, true, "origin_animate_jnt" );
	
	add_notetrack_custom_function( "player_body", "DOF_tank_on", maps\createart\afghanistan_art::DOF_tank_on );
	add_notetrack_custom_function( "player_body", "DOF_tank_off", maps\createart\afghanistan_art::DOF_tank_off );
	add_notetrack_custom_function( "player_body", "numbers", maps\afghanistan_horse_charge::handle_numbers );
	add_notetrack_custom_function( "player_body", "tank_explosion", maps\afghanistan_horse_charge::handle_tank_explosion );
	add_notetrack_custom_function( "player_body", "audioCutSound", maps\afghanistan_horse_charge::audioCutSound );
		
//	add_notetrack_flag("player_body", "start_timescale", "kravchenko_time_scale_punch");
//	add_notetrack_flag("player_body", "stop_timescale", "time_scale_punch_end");
}


e4_s6_strangle_scene()
{
	add_scene("e4_s6_strangle", "arena_struct");
	add_player_anim("player_body", %player::p_af_04_09_reunion_player_strangle);
	add_actor_anim("kravchenko", %generic_human::ch_af_04_09_reunion_krav_strangle, true);
	add_actor_anim( "woods", %generic_human::ch_af_04_09_reunion_woods_strangle );
	add_horse_anim("woods_horse", %horse::ch_af_04_09_reunion_horse_strangle);
	add_vehicle_anim("krav_tank", %vehicles::v_af_04_09_reunion_tank_strangle, true);
	
	add_notetrack_custom_function( "player_body", "DOF_strangle", maps\createart\afghanistan_art::DOF_strangle );
}

e5_s1_celebration_scene()
{
	add_scene("e5_s1_celebrating_muj", undefined, false, true, true, true);
	add_multiple_generic_actors("celebrating_muj_sec3", %generic_human::ch_af_05_01_victory_muhaj_cheering);
}

e5_s1_celebration_riders_scene()
{
	add_scene("e5_s1_celebrating_riders", undefined, false, false, true, true);
	add_horse_anim("victory_horse_sec3_1", %horse::ch_af_05_01_victory_horse_cheering);
	add_horse_anim("victory_horse_sec3_2", %horse::ch_af_05_01_victory_horse_cheering);
	add_actor_anim("muj_cel_rider_1", %generic_human::ch_af_05_01_victory_rider_cheering);
	add_actor_anim("muj_cel_rider_2", %generic_human::ch_af_05_01_victory_rider_cheering);
}

e5_s1_walk_in_scene()
{
	add_scene("e5_s1_walk_in", "by_numbers_struct");
	add_player_anim("player_body", %player::p_af_05_01_victory_player_walk, true, 0, undefined, true, 1, 45, 45, 10, 10);
	add_actor_anim("hudson",%generic_human::ch_af_05_01_victory_hudson_walk);
	add_actor_anim("kravchenko",%generic_human::ch_af_05_01_victory_krav_walk);
	add_actor_anim("woods",%generic_human::ch_af_05_01_victory_woods_walk, true);
	
	add_scene("e5_s1_walk_in_zhao", "by_numbers_struct");
	add_actor_anim("zhao",%generic_human::ch_af_05_01_victory_zhao_walk);
	
	add_scene("e5_s1_celebrate", "by_numbers_struct");
	add_actor_model_anim("muj_cel_walk_1",%generic_human::ch_af_05_01_victory_crowd_follow_1, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_walk_2",%generic_human::ch_af_05_01_victory_crowd_follow_3, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_walk_3",%generic_human::ch_af_05_01_victory_crowd_follow_4, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_walk_4",%generic_human::ch_af_05_01_victory_crowd_follow_5, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_walk_5",%generic_human::ch_af_05_01_victory_crowd_follow_6, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	
	add_scene("e5_s1_celebrate_crowd", "by_numbers_struct", false, false, true);
	add_actor_model_anim("muj_cel_1",%generic_human::ch_af_05_01_victory_crowd_1, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_2",%generic_human::ch_af_05_01_victory_crowd_2, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_3",%generic_human::ch_af_05_01_victory_crowd_3, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_4",%generic_human::ch_af_05_01_victory_crowd_4, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_5",%generic_human::ch_af_05_01_victory_crowd_5, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_6",%generic_human::ch_af_05_01_victory_crowd_6, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_7",%generic_human::ch_af_05_01_victory_crowd_7, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_8",%generic_human::ch_af_05_01_victory_crowd_8, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_9",%generic_human::ch_af_05_01_victory_crowd_9, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_10",%generic_human::ch_af_05_01_victory_crowd_10, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_11",%generic_human::ch_af_05_01_victory_crowd_11, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("muj_cel_12",%generic_human::ch_af_05_01_victory_crowd_12, undefined, true, undefined, undefined, "celebrating_muj_sec3_1");

}

e5_s2_interrogation()
{
	add_scene("e5_s2_interrogation_start", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_start_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_start_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_start_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_start_omar, true, false);
	
	add_notetrack_fx_on_tag( "kravchenko", "punched", "head_punch", "J_Mouth_LE" );
		
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_start_zhao);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_start_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_start_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_start_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_start_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");		
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_start_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_start_chair, "p6_wooden_chair_anim");
	
	add_notetrack_fx_on_tag( "woods_knife", "flick", "knife_tip", "tag_origin" );
	
	add_scene("e5_s2_interrogation_threat", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_threat_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_threat_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_threat_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_threat_omar, true, false);
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_threat_zhao);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_threat_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_threat_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_threat_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_threat_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");		
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_threat_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_threat_chair, "p6_wooden_chair_anim");
	
	add_notetrack_fx_on_tag( "kravchenko", "spit", "krav_spit", "J_Mouth_LE" );
	add_notetrack_fx_on_tag( "kravchenko", "stab", "hand_stab", "J_Ring_RI_2" );
	add_notetrack_fx_on_tag( "kravchenko", "stab_done", "hand_stab", "J_Ring_RI_2" );
	
	add_scene("e5_s2_interrogation_first_intel", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_first_intel_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_first_intel_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_first_intel_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_first_intel_omar, true, false);
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_first_intel_zhao);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_first_intel_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_first_intel_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_first_intel_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_first_intel_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");	
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_first_intel_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_first_intel_chair, "p6_wooden_chair_anim");
	
	add_scene("e5_s2_interrogation_second_intel", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_second_intel_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_second_intel_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_second_intel_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_second_intel_omar, true, false);
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_second_intel_zhao);	
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_second_intel_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_second_intel_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_second_intel_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_second_intel_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");	
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_second_intel_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_second_intel_chair, "p6_wooden_chair_anim");
	
	add_scene("e5_s2_interrogation_third_intel", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_third_intel_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_third_intel_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_third_intel_krav);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_third_intel_omar, true, false);
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_third_intel_zhao);	
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_third_intel_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_third_intel_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_third_intel_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_third_intel_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");	
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_third_intel_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_third_intel_chair, "p6_wooden_chair_anim");
	
	add_scene("e5_s2_interrogation_succeed", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_succeed_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_succeed_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_succeed_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_succeed_omar, true, false);
	//add_actor_anim("zhao", %generic_human::ch_af_05_02_interrog_succeed_zhao);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_succeed_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_succeed_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_02_interrog_succeed_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_02_interrog_succeed_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");	
	add_prop_anim("woods_gun", %animated_props::o_af_05_02_interrog_succeed_woods_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_succeed_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_succeed_chair, "p6_wooden_chair_anim");
	
	add_notetrack_fx_on_tag( "woods_gun", "shoot", "pistol_flash", "tag_fx" );
	add_notetrack_fx_on_tag( "kravchenko", "headshot", "head_shot", "J_Head" );
	
		
	add_scene("e5_s2_interrogation_fail", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_fail_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_fail_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_fail_krav, true, false);
	
	add_scene("e5_s2_interrogation_start_player", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_start_player, false, 0, undefined, true, 1, 10, 10, 10, 10);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_start_pistol, "t6_wpn_pistol_m1911_prop_view");
	
	add_notetrack_custom_function( "player_body", "dof_chair", maps\createart\afghanistan_art::dof_omar);
	
	add_scene("e5_s2_interrogation_threat_player", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_threat_player, false, 0, undefined, true, 1, 10, 10, 10, 10);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_threat_pistol, "t6_wpn_pistol_m1911_prop_view");	
	
	add_scene("e5_s2_interrogation_test1", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test1_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test1_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_notetrack_custom_function( "player_body", "decision", maps\afghanistan_krav_captured::end_hands_animator );
	
	add_scene("e5_s2_interrogation_test1_succeed", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test1_player_succeed);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test1_pistol_succeed, "t6_wpn_pistol_m1911_prop_view");
	
	add_scene("e5_s2_interrogation_test2", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test2_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test2_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_notetrack_custom_function( "player_body", "decision", maps\afghanistan_krav_captured::end_hands_animator );
	
	add_scene("e5_s2_interrogation_test2_succeed", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test2_player_succeed);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test2_pistol_succeed, "t6_wpn_pistol_m1911_prop_view");
	
	add_scene("e5_s2_interrogation_test3", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test3_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test3_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_notetrack_custom_function( "player_body", "decision", maps\afghanistan_krav_captured::end_hands_animator );
	
	add_scene("e5_s2_interrogation_test3_succeed", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test3_player_succeed);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test3_pistol_succeed, "t6_wpn_pistol_m1911_prop_view");
	
	add_scene("e5_s2_interrogation_all_succeed", "by_numbers_struct_mason");
	add_player_anim("player_body", %player::p_af_05_02_interrog_all_tests_succeed_player);
	
	add_notetrack_custom_function( "player_body", "dof_pair", maps\createart\afghanistan_art::dof_omar);
	add_notetrack_custom_function( "player_body", "dof_ambush", maps\createart\afghanistan_art::dof_omar);
	
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_all_tests_succeed_pistol, "t6_wpn_pistol_m1911_prop_view");
	
	add_scene("e5_s2_interrogation_test1_fail", "by_numbers_struct");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test1_fail_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test1_fail_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_test1_fail_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_test1_fail_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_test1_fail_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_test1_fail_omar, true, false);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_test1_fail_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_test1_fail_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_test1_fail_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_test1_fail_chair, "p6_wooden_chair_anim");
	
	add_notetrack_fx_on_tag( "gun", "shoot", "pistol_flash", "tag_fx" );
	add_notetrack_fx_on_tag( "kravchenko", "headshot", "head_shot", "J_Head" );
	
	add_scene("e5_s2_interrogation_test2_fail", "by_numbers_struct");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test2_fail_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test2_fail_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_test2_fail_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_test2_fail_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_test2_fail_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_test2_fail_omar, true, false);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_test2_fail_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_test2_fail_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_test2_fail_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_test2_fail_chair, "p6_wooden_chair_anim");	
	
	add_notetrack_fx_on_tag( "gun", "shoot", "pistol_flash", "tag_fx" );
	add_notetrack_fx_on_tag( "kravchenko", "headshot", "head_shot", "J_Head" );
	
	add_scene("e5_s2_interrogation_test3_fail", "by_numbers_struct");
	add_player_anim("player_body", %player::p_af_05_02_interrog_test3_fail_player);
	add_prop_anim("gun", %animated_props::o_af_05_02_interrog_test3_fail_pistol, "t6_wpn_pistol_m1911_prop_view");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrog_test3_fail_woods, true, false);
	add_actor_anim("hudson", %generic_human::ch_af_05_02_interrog_test3_fail_hudson);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrog_test3_fail_krav, true, false);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrog_test3_fail_omar, true, false);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_02_interrog_test3_fail_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_02_interrog_test3_fail_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_prop_anim("woods_knife", %animated_props::o_af_05_02_interrog_test3_fail_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_02_interrog_test3_fail_chair, "p6_wooden_chair_anim");
	
	add_notetrack_fx_on_tag( "gun", "shoot", "pistol_flash", "tag_fx" );
	add_notetrack_fx_on_tag( "kravchenko", "headshot", "head_shot", "J_Head" );
}


//e5_s2_interrogation_loop_scene()
//{
//	add_scene("e5_s2_interrogation_loop", "by_numbers_struct", false, false, true);
//	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_interrogationloop);
//	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_interrogationloop);
//	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_interrogationloop);
//	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_interrogationloop);
//	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_interrogationloop);
//	add_player_anim("player_body", %player::p_af_05_02_interrogation_player_interrogationloop);
//}
//e5_s2_interrogation_move2shoot_scene()
//{
//	add_scene("e5_s2_interrogation_move2shoot", "by_numbers_struct");
//	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_move2shoot);
//	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_move2shoot);
//	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_move2shoot);
//	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_move2shoot);
//	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_move2shoot);
//}
//e5_s2_interrogation_punch_scene()
//{
//	add_scene("e5_s2_interrogation_punch", "by_numbers_struct");
//	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_punch);
//	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_punch);
//	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_punch);
//	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_punch);
//	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_punch);
//}
//e5_s2_interrogation_shoot_v1_scene()
//{
//	add_scene("e5_s2_interrogation_shoot_v1", "by_numbers_struct");
//	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_shoot_v1);
//	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_shoot_v1);
//	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_shoot_v1);
//	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_shoot_v1);
//	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_shoot_v1);
//}
//
//e5_s2_interrogation_shoot_v2_scene()
//{
//	add_scene("e5_s2_interrogation_shoot_v2", "by_numbers_struct");
//	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_shoot_v2);
//	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_shoot_v1);
//	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_shoot_v1);
//	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_shoot_v1);
//	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_shoot_v1);
//}
//
e5_s4_beatdown_scene()
{
	add_scene("e5_s4_beatdown", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_04_betrayal_woods);
	add_actor_anim("hudson", %generic_human::ch_af_05_04_betrayal_hudson);
	//add_actor_anim("m01_guard", %generic_human::ch_af_05_04_betrayal_muj1);
	//add_actor_anim("m02_guard", %generic_human::ch_af_05_04_betrayal_muj2);
	//add_actor_anim("m03_guard", %generic_human::ch_af_05_04_betrayal_muj3);
	//add_actor_anim("m04_guard", %generic_human::ch_af_05_04_betrayal_muj4);
	add_actor_model_anim("beatdown_guard1",%generic_human::ch_af_05_04_betrayal_muj1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard2",%generic_human::ch_af_05_04_betrayal_muj2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard3",%generic_human::ch_af_05_04_betrayal_muj3, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("beatdown_guard4",%generic_human::ch_af_05_04_betrayal_muj4, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_04_betrayal_omar);
	add_actor_model_anim("interrogation_guard1",%generic_human::ch_af_05_04_betrayal_guard1, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_actor_model_anim("interrogation_guard2",%generic_human::ch_af_05_04_betrayal_guard2, undefined, false, undefined, undefined, "celebrating_muj_sec3_1");
	add_prop_anim("woods_knife", %animated_props::o_af_05_04_betrayal_woods_karambit, "p6_knife_karambit");
	add_prop_anim("chair", %animated_props::o_af_05_04_betrayal_chair, "p6_wooden_chair_anim");
	
	add_player_anim("player_body", %player::p_af_05_04_betrayal_player);
	add_notetrack_fx_on_tag( "player_body", "spit", "choke_spit", "tag_camera" );
	add_notetrack_fx_on_tag( "player_body", "hit_ground", "sand_body_impact_sm", "tag_origin" );
	
	add_notetrack_custom_function( "player_body", "dof_omar", maps\createart\afghanistan_art::dof_omar);
	add_notetrack_custom_function( "player_body", "dof_ambush", maps\createart\afghanistan_art::dof_omar);
	add_notetrack_custom_function( "player_body", "dof_kicking", maps\createart\afghanistan_art::dof_beatdown);
	
	add_notetrack_custom_function("player_body", "spit", maps\afghanistan_krav_captured::choke_spit_fx);
}

e6_s2_ontruck_1_scene()
{
	add_scene("e6_s2_ontruck_1", "deserted_pickup1");
	add_actor_anim("rebel_leader", %generic_human::ch_af_06_01_deserted_leader_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("woods", %generic_human::ch_af_06_01_deserted_woods_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("hudson", %generic_human::ch_af_06_01_deserted_hudson_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("zhao", %generic_human::ch_af_06_01_deserted_zhao_ontruck, true, false, false, true, "tag_origin");
	
	add_actor_anim("m01_guard", %generic_human::ch_af_06_01_deserted_muj1_ontruck, false, false, false, true, "tag_origin");
	
	add_player_anim("player_body", %player::p_af_06_01_deserted_player_ontruck,true, 0, "tag_origin", true, 1, 5, 5, 5, 5);	
}

e6_s2_ontruck_trucks_scene()
{
	add_scene("e6_s2_ontruck_trucks", "truck_struct");
	a_hide_tags = [];
	a_hide_tags[ 0 ] = "tag_gunner_barrel1";
	a_hide_tags[ 1 ] = "tag_gun_mount";
	a_hide_tags[ 2 ] = "tag_gunner_turret1";
	//a_hide_tags[ 3 ] = "tag_flash_gunner1";
	add_vehicle_anim( "deserted_pickup1", %vehicles::v_af_06_01_deserted_maintruck_ontruck, false, a_hide_tags, undefined, true, "civ_pickup_wturret_afghan" );
}

e6_s2_offtruck_scene()
{
	add_scene("e6_s2_offtruck", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_01_deserted_woods_offtruck);
	add_notetrack_custom_function( "woods", "hit_ground", maps\afghanistan_deserted::deserted_truck_kickout_impact );
	add_actor_anim("hudson", %generic_human::ch_af_06_01_deserted_hudson_offtruck);
	add_notetrack_custom_function( "hudson", "hit_ground", maps\afghanistan_deserted::deserted_truck_kickout_impact );
	add_actor_anim("zhao", %generic_human::ch_af_06_01_deserted_zhao_offtruck);
	add_notetrack_custom_function( "zhao", "hit_ground", maps\afghanistan_deserted::deserted_truck_kickout_impact );
	
	add_actor_anim("rebel_leader", %generic_human::ch_af_06_01_deserted_leader_offtruck);
	add_actor_anim("m01_guard", %generic_human::ch_af_06_01_deserted_muj1_offtruck);
	
	add_vehicle_anim("deserted_pickup1", %vehicles::v_af_06_01_deserted_maintruck_offtruck);
	add_notetrack_custom_function( "deserted_pickup1", "start_moving", maps\afghanistan_deserted::deserted_truck_kickup_dust );
	
	add_player_anim("player_body", %player::p_af_06_01_deserted_player_offtruck);	
	add_notetrack_custom_function( "player_body", "hit_ground", maps\afghanistan_deserted::deserted_truck_kickout_impact_player );
	add_notetrack_custom_function( "player_body", "player_flip_over", maps\afghanistan_deserted::deserted_flip_over );	
	add_notetrack_custom_function( "player_body", "start_fade_out", maps\afghanistan_deserted::deserted_start_fade_out );
}

/*e6_s2_deserted_single_scene()
{
	add_scene("e6_s2_deserted_single", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view01);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view01);
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view01);
	//add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view01);
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view01, false, 0, undefined, true, 1, 5, 5, 5, 5);	
	
	add_notetrack_custom_function( "player_body", "dof_01", maps\createart\afghanistan_art::dof_time_lapse);
}*/

e6_s2_deserted_part1_scene()
{
	add_scene("e6_s2_deserted_part1", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view01);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view01);
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view01);
	add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view01);
	add_actor_model_anim("nomad", %generic_human::ch_af_06_02_deserted_nomad_view01);
	
	add_horse_anim("reznov_horse", %horse::ch_af_06_02_deserted_reznov_horse_view01);
	add_horse_anim("nomad_horse", %horse::ch_af_06_02_deserted_nomad_horse_view01);
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view01, false, 0, undefined, true, 1, 5, 5, 5, 5);
}
e6_s2_deserted_part2_scene()
{
	add_scene("e6_s2_deserted_part2", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view02);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view02);
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view01);
	add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view02);
	add_actor_model_anim("nomad", %generic_human::ch_af_06_02_deserted_nomad_view02);
	
	add_horse_anim("reznov_horse", %horse::ch_af_06_02_deserted_reznov_horse_view02);
	add_horse_anim("nomad_horse", %horse::ch_af_06_02_deserted_nomad_horse_view02);
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view02, false, 0, undefined, true, 1, 5, 5, 5, 5);
}
e6_s2_deserted_part3_scene()
{
	add_scene("e6_s2_deserted_part3", "truck_struct");
	//add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view03);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view03);
	//add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view03);
	add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view03);
	add_actor_model_anim("nomad", %generic_human::ch_af_06_02_deserted_nomad_view03);

	add_horse_anim("reznov_horse", %horse::ch_af_06_02_deserted_reznov_horse_view03);	
	add_horse_anim("nomad_horse", %horse::ch_af_06_02_deserted_nomad_horse_view03);	
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view03, false, 0, undefined, true, 1, 5, 5, 5, 5);
	//add_prop_anim("prop_vulture", %animated_props::ch_af_06_02_deserted_vulture_view03, "p6_anim_vulture");
	
	add_notetrack_custom_function( "player_body", "dof_03", maps\createart\afghanistan_art::dof_03);

	add_scene("e6_s2_deserted_part3_extras", "truck_struct");	
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view03);
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view03);
}

e6_s2_deserted_bush_anim_scene()
{
	add_scene("e6_s2_deserted_bush_normal", undefined, false, false, true, true);
	add_prop_anim("fxanim_shrub_01", %animated_props::fxanim_afghan_shrubs_time_lapse_norm_anim);
	
	add_scene("e6_s2_deserted_bush_ramp", undefined, false, false, false, true);
	add_prop_anim("fxanim_shrub_01", %animated_props::fxanim_afghan_shrubs_time_lapse_ramp_anim);
	
	add_scene("e6_s2_deserted_bush_fast", undefined, false, false, true, true);
	add_prop_anim("fxanim_shrub_01", %animated_props::fxanim_afghan_shrubs_time_lapse_fast_anim);
}

#using_animtree( "player" );
setup_brainwash_anims()
{
	level.scr_animtree[ "player_hands_brainwash" ] 	= #animtree;
	level.scr_model[ "player_hands_brainwash" ] 	= level.player_interactive_model;	
}

#using_animtree( "generic_human" );
patroller_anims()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ] = %patrol_bored_patrolwalk;
	level.scr_anim[ "zhao" ][ "patrol_walk" ] = %patrol_bored_patrolwalk;
	level.scr_anim[ "woods" ][ "patrol_walk" ] = %patrol_bored_patrolwalk;
}

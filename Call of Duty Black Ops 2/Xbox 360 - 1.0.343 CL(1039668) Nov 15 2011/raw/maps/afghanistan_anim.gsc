#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;

main()
{
	e1_s1_player_wood_scene();
	
	e1_s1_pulwar_scene();
	e1_s1_pulwar_single_scene();
	
	e1_s2_lotr_horse_scene();
	e1_s2_lotr_woods_horse_scene();
	e1_s5_vulture_shoot_scene();
	e2_s1_base_activity();

	e3_s1_horses_outside_scene();
	e3_s1_leave_map_room_scene();
	e3_s1_map_room_idle_scene();
	e3_s1_leave_map_room_zhao_scene();
	e3_s1_zhao_idle_scene();
	e3_s1_leave_cave_zhao_scene();
	e3_s1_player_base_explosion_scene();
	e3_s1_zhao_pickup_scene();
	e3_s1_horses_explosion_scene();
	e3_s1_firehorse_scene();
	e3_s1_calm_horses_scene();
	e3_s1_zhaohorses_idle_scene();
	
	e4_s1_return_base_lineup_scene();
	e4_s1_return_base_lineup_single_scene();
	e4_s1_binoc_scene();
	e4_s1_return_base_charge_scene();
	e4_s1_return_base_charge_scene_no_player();
	//e4_s3_tank_squash();
	e4_s5_player_and_horse_fall();
	e4_s6_player_grabs_on_tank_scene();
	e4_s6_tank_fight_scene();
	e4_s6_tank_fight_tank_scene();
	e4_s6_strangle_scene();

	e5_s1_celebration_scene();
	e5_s1_celebration_riders_scene();
	e5_s1_walk_in_scene();
	e5_s2_interrogation_loop_scene();
	e5_s2_interrogation_punch_scene();
	e5_s2_interrogation_shoot_v1_scene();
	e5_s2_interrogation_shoot_v2_scene();
	e5_s2_interrogation_move2shoot_scene();
	e5_s4_beatdown_scene();
	
	e6_s2_deserted_single_scene();
	
	e6_s2_ontruck_1_scene();
	e6_s2_ontruck_2_scene();
	e6_s2_ontruck_trucks_scene();
	e6_s2_offtruck_scene();
	e6_s2_deserted_part1_scene();
	e6_s2_deserted_part2_scene();
	e6_s2_deserted_part3_scene();
	
	lockbreaker_perk_scene();
	intruder_perk_scene();
	
	// setup the horse to animate
	//horse = getent( "player_horse", "targetname" );
	//horse MakeVehicleUnusable();
	
	precache_assets();
}


intruder_perk_scene()
{
	add_scene( "intruder", "intruder_strongbox");
	add_player_anim("player_body",	 %player::int_specialty_afghanistan_intruder, true, 0, "tag_origin");
	add_prop_anim("intruder_box", %animated_props::o_specialty_afghanistan_intruder_strongbox);
	add_prop_anim("intruder_box_lock", %animated_props::o_specialty_afghanistan_intruder_padlock, "p6_anim_strongbox_lock", false, false, undefined, "tag_origin");
	add_prop_anim("intruder_box_cutter", %animated_props::o_specialty_afghanistan_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true, false, undefined, "tag_origin");
}

lockbreaker_perk_scene()
{
	add_scene( "lockbreaker", "afghan_lockbreaker_door");
	add_player_anim("player_body",	 %player::int_specialty_afghanistan_lockbreaker, true);
	add_prop_anim("cutter", %animated_props::o_specialty_afghanistan_lockbreaker_device, "t6_wpn_lock_pick_view", true);
}

e1_s1_pulwar_scene()
{
	add_scene( "e1_s1_pulwar", "special_delivery_start");
	add_actor_anim("dead_guy", %generic_human::ch_af_01_03_pulwar_deadguy, false, false, true);
	add_player_anim("player_body",	 %player::p_af_01_03_pulwar_player, true);
	add_prop_anim("sword", %animated_props::o_af_01_03_pulwar_pulwar, "t6_wpn_pulwar_sword_prop", true);
	
}

e1_s1_pulwar_single_scene()
{
	add_scene( "e1_s1_pulwar_single", "special_delivery_start");
	add_actor_anim("dead_guy", %generic_human::ch_af_01_03_pulwar_deadguy);
	add_prop_anim("sword", %animated_props::o_af_01_03_pulwar_pulwar, "t6_wpn_pulwar_sword_prop");
	
}
	
e1_s1_player_wood_scene()
{
	add_scene( "e1_player_wood_greeting", "special_delivery_start");
	add_actor_anim("woods", %generic_human::ch_af_01_01_woods);
	add_player_anim("player_body",	 %player::p_af_01_01_player, true, 0, undefined, true, 1, 10, 10, 10, 10);
	add_prop_anim( "ammo_box", %animated_props::o_af_01_01_gunbox, "p6_anim_ammo_box" );
	add_prop_anim( "photo", %animated_props::o_af_01_01_photo, "p6_photograph_01", true, true );
	add_horse_anim( "player_horse", %horse::ch_af_01_01_horse1, true);
	add_horse_anim( "woods_horse", %horse::ch_af_01_01_horse2);
}


e1_s2_lotr_horse_scene()
{
	add_scene("e1_zhao_horse_charge_player", "special_delivery_start");
	add_notetrack_flag("player_body", "start_timescale", "time_scale_horse");
	add_notetrack_flag("player_body", "stop_timescale", "time_scale_horse_end");
	
	add_player_anim( "player_body",	 %player::p_af_01_05_player, true, 0, undefined, false);
	add_actor_anim( "woods", %generic_human::ch_af_01_05_woods);
	
    add_scene( "e1_zhao_horse_charge", "special_delivery_start");
	
	add_actor_anim( "zhao", %generic_human::ch_af_01_05_zhao);
	add_horse_anim( "zhao_horse", %horse::ch_af_01_05_horse_zhao);
	set_vehicle_unusable_in_scene("zhao_horse");
	
	add_scene( "e1_horse_charge_muj", "special_delivery_start" );
	add_horse_anim( "muj_horse_1", %horse::ch_af_01_05_horse1);
	add_horse_anim( "muj_horse_2", %horse::ch_af_01_05_horse2);
	add_horse_anim( "muj_horse_3", %horse::ch_af_01_05_horse3);
	add_horse_anim( "muj_horse_4", %horse::ch_af_01_05_horse4);
	set_vehicle_unusable_in_scene("muj_horse_1");
	set_vehicle_unusable_in_scene("muj_horse_2");
	set_vehicle_unusable_in_scene("muj_horse_3");
	set_vehicle_unusable_in_scene("muj_horse_4");
	
	add_actor_anim( "horse_muj_1", %generic_human::ch_af_01_05_henchman1, true);
	add_actor_anim( "horse_muj_2", %generic_human::ch_af_01_05_henchman2, true);
	add_actor_anim( "horse_muj_3", %generic_human::ch_af_01_05_henchman3, true);
	add_actor_anim( "horse_muj_4", %generic_human::ch_af_01_05_henchman4, true);
	add_prop_anim( "ammo_box", %animated_props::o_af_01_05_gunbox, "p6_anim_ammo_box" );
	
	add_scene( "e1_horse_charge_muj_endloop", "special_delivery_start", false, false, true );
	add_horse_anim( "muj_horse_1", %horse::ch_af_01_05_horse1_endloop);
	add_horse_anim( "muj_horse_2", %horse::ch_af_01_05_horse2_endloop);
	add_horse_anim( "muj_horse_3", %horse::ch_af_01_05_horse3_endloop);
	add_horse_anim( "muj_horse_4", %horse::ch_af_01_05_horse4_endloop);
	add_actor_anim( "horse_muj_1", %generic_human::ch_af_01_05_henchman1_endloop, true);
	add_actor_anim( "horse_muj_2", %generic_human::ch_af_01_05_henchman2_endloop, true);
	add_actor_anim( "horse_muj_3", %generic_human::ch_af_01_05_henchman3_endloop, true);
	add_actor_anim( "horse_muj_4", %generic_human::ch_af_01_05_henchman4_endloop, true);
}
//e1_woods_horse
//e1_zhao_horse
e1_s5_vulture_shoot_scene()
{
	add_scene("e1_s5_vulture_shoot_woods", "e1_woods_horse");
	
	add_actor_anim( "woods", %generic_human::ch_af_01_05_vulture_shoot_woods, false, true, false, true, "tag_origin");
	add_horse_anim( "e1_woods_horse", %horse::v_af_01_05_vulture_shoot_woods_horse);
	
	add_scene("e1_s5_vulture_shoot_zhao", "e1_zhao_horse");
	
	add_actor_anim( "zhao", %generic_human::ch_af_01_05_vulture_shoot_zhao, false , true, false, true, "tag_origin");
	add_horse_anim( "e1_zhao_horse", %horse::v_af_01_05_vulture_shoot_zhao_horse);
}

e1_s2_lotr_woods_horse_scene()
{
	add_scene("e1_zhao_horse_charge_woods", "special_delivery_start");
	
	add_horse_anim( "woods_horse", %horse::ch_af_01_05_horse_woods);
}

/* ------------------------------------------------------------------------------------------
	Exit base camp begin
-------------------------------------------------------------------------------------------*/
e3_s1_horses_outside_scene()
{
	add_scene( "e3_horses_waiting", "rats_nest_struct", false, false, true );
	
	add_horse_anim( "playerhorse", %horse::ch_af_03_01_base_leave_horse_woods );
	add_horse_anim( "zhaohorse", %horse::ch_af_03_01_base_leave_horse_zhao );
}


e3_s1_leave_map_room_scene()
{
	//add_scene( str_scene_name, str_align_targetname, do_reach, do_generic, do_loop, do_not_align )
	add_scene( "e3_exit_map_room", "rats_nest_struct" );
	
	add_actor_anim( "hudson", %generic_human::ch_af_03_01_base_leave_hudson_exit );
	add_actor_anim( "rebel_leader", %generic_human::ch_af_03_01_base_leave_leader_exit );
	add_actor_anim( "woods", %generic_human::ch_af_03_01_base_leave_woods_exit );
}


e3_s1_map_room_idle_scene()
{
	add_scene( "e3_map_room_idle", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "hudson", %generic_human::ch_af_03_01_base_leave_hudson_idl );
	add_actor_anim( "rebel_leader", %generic_human::ch_af_03_01_base_leave_leader_idl );
	add_actor_anim( "woods", %generic_human::ch_af_03_01_base_leave_woods_idl );
}


e3_s1_leave_map_room_zhao_scene()
{
	add_scene( "e3_exit_map_room_zhao", "rats_nest_struct" );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_exit );
}


e3_s1_zhao_idle_scene()
{
	add_scene( "e3_zhao_exit_idle", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_wait_idl );
}


e3_s1_leave_cave_zhao_scene()
{
	add_scene( "e3_exit_cave_zhao", "rats_nest_struct" );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_run_outside );
}


e3_s1_player_base_explosion_scene()
{
	add_scene( "e3_player_base_explosion", "rats_nest_struct" );
	
	add_player_anim( "player_body", %player::p_af_03_01_base_leave_player_explosion, true );
	
	add_notetrack_flag( "player_body", "start_fire_horse", "start_firehorse" );
	add_notetrack_flag( "player_body", "start_zhao_pickup", "player_pickup" );
}


e3_s1_zhao_pickup_scene()
{
	add_scene( "e3_zhao_pickup", "rats_nest_struct" );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_explosion_pickup );
}


e3_s1_horses_explosion_scene()
{
	add_scene( "e3_horses_explosion", "rats_nest_struct" );
	
	add_horse_anim( "playerhorse", %horse::ch_af_03_01_base_leave_horse_woods_explosion );
	add_horse_anim( "zhaohorse", %horse::ch_af_03_01_base_leave_horse_zhao_explosion );
}


e3_s1_firehorse_scene()
{
	add_scene( "e3_firehorse", "rats_nest_struct" );
	
	add_horse_anim( "firehorse", %horse::ch_af_03_01_base_leave_fire_horse_explosion );
}


e3_s1_calm_horses_scene()
{
	add_scene( "e3_calm_horses", "rats_nest_struct" );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_calm_horses );
	//add_horse_anim( "playerhorse", %horse::ch_af_03_01_base_leave_horse_woods_calm_horses );
	//add_horse_anim( "zhaohorse", %horse::ch_af_03_01_base_leave_horse_zhao_calm_horses );
}


e3_s1_zhaohorses_idle_scene()
{
	add_scene( "e3_zhao_horses_idle", "rats_nest_struct", false, false, true );
	
	add_actor_anim( "zhao", %generic_human::ch_af_03_01_base_leave_zhao_mountable );
	//add_horse_anim( "playerhorse", %horse::ch_af_03_01_base_leave_horse_woods_mountable );
	//add_horse_anim( "zhaohorse", %horse::ch_af_03_01_base_leave_horse_zhao_mountable );
}


/* ------------------------------------------------------------------------------------------
	Exit base camp end
-------------------------------------------------------------------------------------------*/

// add_actor_anim( <str_animname>, <animation>, [do_hide_weapon], [do_give_back_weapon], [do_delete], [do_not_allow_death], [str_tag] )
e2_s1_base_activity()
{
	add_scene( "e2_base_activity", "rats_nest_struct" );
	add_actor_anim("woods", %generic_human::ch_af_02_02_woods);
	add_actor_anim("zhao", %generic_human::ch_af_02_02_zhao);
	add_actor_anim("rebel_leader", %generic_human::ch_af_02_02_leader);
	add_actor_anim("hudson", %generic_human::ch_af_02_02_hudson);
	add_horse_anim( "e1_zhao_horse", %horse::ch_af_02_02_horse_zhao);
	add_horse_anim( "e1_woods_horse", %horse::ch_af_02_02_horse_woods);
	
	add_scene( "e2_base_activity_generic", "rats_nest_struct", false, false, true);
	add_actor_anim("base_muj_1", %generic_human::ch_af_02_01_muj1, false, false, true, true);
	add_actor_anim("base_muj_2", %generic_human::ch_af_02_01_muj2, false, false, true, true);
	add_actor_anim("base_muj_3", %generic_human::ch_af_02_01_muj3, false, false, true, true);
	add_actor_anim("base_muj_4", %generic_human::ch_af_02_01_muj4, false, false, true, true);
	add_actor_anim("base_muj_5", %generic_human::ch_af_02_01_muj5, false, false, true, true);
	add_actor_anim("base_muj_6", %generic_human::ch_af_02_01_muj6, false, false, true, true);
	add_actor_anim("base_muj_7", %generic_human::ch_af_02_01_muj7, false, false, true, true);
	add_actor_anim("base_muj_8", %generic_human::ch_af_02_01_muj8, false, false, true, true);
	add_actor_anim("base_muj_9", %generic_human::ch_af_02_01_mu9, false, false, true, true);
	add_actor_anim("base_muj_10", %generic_human::ch_af_02_01_muj10, false, false, true, true);
	add_actor_anim("base_muj_11", %generic_human::ch_af_02_01_muj11, false, false, true, true);
	add_actor_anim("base_muj_12", %generic_human::ch_af_02_01_muj12, false, false, true, true);
//	add_horse_anim( "e2_muj_anim_horse_1", %horse::ch_af_02_01_horse1, true);
//	add_horse_anim( "e2_muj_anim_horse_2", %horse::ch_af_02_01_horse2, true);
//	add_horse_anim( "e2_muj_anim_horse_3", %horse::ch_af_02_01_horse3, true);
//	add_horse_anim( "e2_muj_anim_horse_4", %horse::ch_af_02_01_horse4, true);
}

e4_s1_return_base_lineup_scene()
{
	add_scene("e4_s1_return_base_lineup", "skipto_horse_charge");
	
	add_player_anim("player_body", %player::p_af_04_01_return_base_player_lineup, true, 0, undefined, true, 1, 10, 10, 10, 10);
	
	add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_lineup);
	add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_lineup);
	add_horse_anim("horse_for_charge_woods", %horse::ch_af_04_01_return_base_woods_horse_lineup);
	
	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_lineup);
	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_lineup);
	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_lineup);
	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_lineup);
	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_lineup);
	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_lineup);
	
	add_actor_anim("woods", %generic_human::ch_af_04_01_return_base_woods_lineup, false, true, false, true);
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

e4_s1_return_base_lineup_single_scene()
{
	add_scene("e4_s1_return_base_lineup_single", "skipto_horse_charge");
	
	//add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_lineup);
	add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_lineup);
	//add_horse_anim("horse_for_charge_woods", %horse::ch_af_04_01_return_base_woods_horse_lineup);
	
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
	add_scene("e4_s1_binoc", "arena_struct");
	add_horse_anim("battle_horse1", %horse::ch_af_03_02_horse_combat_horse1);
	add_horse_anim("battle_horse2", %horse::ch_af_03_02_horse_combat_horse2);
	add_horse_anim("battle_horse3", %horse::ch_af_03_02_horse_combat_horse3);
	add_horse_anim("battle_horse4", %horse::ch_af_03_02_horse_combat_horse4);
	add_horse_anim("battle_horse5", %horse::ch_af_03_02_horse_combat_horse5);
	
	add_actor_anim("battle_russian", %generic_human::ch_af_03_02_horse_combat_russian);
	add_actor_anim("battle_muj1", %generic_human::ch_af_03_02_horse_combat_muj1);
	add_actor_anim("battle_muj2", %generic_human::ch_af_03_02_horse_combat_muj2);
	add_actor_anim("battle_muj3", %generic_human::ch_af_03_02_horse_combat_muj3);
	add_actor_anim("battle_muj4", %generic_human::ch_af_03_02_horse_combat_muj4);
	add_actor_anim("battle_muj5", %generic_human::ch_af_03_02_horse_combat_muj5);

}
	
e4_s1_return_base_charge_scene()
{
	add_scene("e4_s1_return_base_charge", "skipto_horse_charge");

	add_player_anim("player_body", %player::p_af_04_01_return_base_player_charge, true, 0, undefined, true, 1, 10, 10, 10, 10);
    add_horse_anim("players_horse_for_charge", %horse::ch_af_04_01_return_base_player_horse_charge);
    add_horse_anim("horse_for_charge_zhao", %horse::ch_af_04_01_return_base_zhao_horse_charge);
	add_horse_anim("horse_for_charge_woods", %horse::ch_af_04_01_return_base_woods_horse_charge);
	add_horse_anim("horse_for_charge_0", %horse::ch_af_04_01_return_base_left1_horse_charge);
	add_horse_anim("horse_for_charge_1", %horse::ch_af_04_01_return_base_left2_horse_charge);
	add_horse_anim("horse_for_charge_2", %horse::ch_af_04_01_return_base_left3_horse_charge);
	add_horse_anim("horse_for_charge_3", %horse::ch_af_04_01_return_base_right1_horse_charge);
	add_horse_anim("horse_for_charge_4", %horse::ch_af_04_01_return_base_right2_horse_charge);
	add_horse_anim("horse_for_charge_5", %horse::ch_af_04_01_return_base_right3_horse_charge);
	
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
	add_horse_anim("horse_for_charge_woods", %horse::ch_af_04_01_return_base_woods_horse_charge);
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

e4_s3_tank_squash()
{
	add_scene( "e4_s3_tank_squash", "krav_tank" );
	add_vehicle_anim("krav_tank", %vehicles::v_af_04_03_tank_squash_tank );
	add_actor_anim( "squash_guy_0", %generic_human::ch_af_04_03_tank_squash_helper, undefined, undefined, true, false, "tag_gunner1" );
	add_actor_anim( "squash_guy_1", %generic_human::ch_af_04_03_tank_squash_wounded, undefined, undefined, true, false, "tag_driver" );
}

e4_s5_player_and_horse_fall()
{
	add_scene( "e4_s5_player_horse_fall", "horse_death_loc");
	add_player_anim("player_body", %player::p_af_04_05_thrown_player_fall);
	//add_horse_anim("players_horse_for_fall_anim", %horse::ch_af_04_05_thown_horse_fall );
	add_prop_anim("prop_horse", %animated_props::ch_af_04_05_thown_horse_fall, "neversoft_horse_body");
	
	add_scene( "e4_s5_player_horse_pushloop", "horse_death_loc", false, false, true );
	add_player_anim("player_body", %player::p_af_04_05_thrown_player_pushloop );
	//add_horse_anim("players_horse_for_fall_anim", %horse::ch_af_04_05_thown_horse_pushloop );
	add_prop_anim("prop_horse", %animated_props::ch_af_04_05_thown_horse_pushloop, "neversoft_horse_body");
}

e4_s6_player_grabs_on_tank_scene()
{
	add_scene("e4_s6_player_grabs_on_tank", "horse_death_loc");
	add_player_anim("player_body", %player::p_af_04_06_reunion_player_run2tank);
	//add_horse_anim("players_horse_for_fall_anim", %horse::ch_af_04_06_reunion_horse_run2tank);
	add_prop_anim("prop_horse", %animated_props::ch_af_04_06_reunion_horse_run2tank, "neversoft_horse_body");
	add_vehicle_anim("krav_tank", %vehicles::v_af_04_06_reunion_tank_run2tank);
	add_prop_anim("mortar", %animated_props::o_af_04_06_reunion_mortar_run2tank, "t6_wpn_mortar_shell_prop_view");
	
	add_notetrack_flag("player_body", "start_shake", "start_tank_shake");
}

e4_s6_tank_fight_tank_scene()
{
	add_scene("e4_s6_tank_fight_tank", "horse_death_loc");
	add_vehicle_anim("krav_tank", %vehicles::v_af_04_06_reunion_tank_tankfight);
}

e4_s6_tank_fight_scene()
{
	add_scene("e4_s6_tank_fight", "krav_tank");
	add_player_anim("player_body", %player::p_af_04_06_reunion_player_tankfight, true, 0, "origin_animate_jnt");

	add_prop_anim("mortar", %animated_props::o_af_04_06_reunion_mortar_tankfight, "t6_wpn_mortar_shell_prop_view", true, false, undefined, "origin_animate_jnt");
	
	add_actor_anim("kravchenko", %generic_human::ch_af_04_06_reunion_krav_tankfight, true, false, false, true, "origin_animate_jnt");
	
	add_notetrack_flag("player_body", "start_timescale", "time_scale_punch");
	add_notetrack_flag("player_body", "stop_timescale", "time_scale_punch_end");
	
}

e4_s6_strangle_scene()
{
	add_scene("e4_s6_strangle", "mortar_drop6_sec3");
	add_player_anim("player_body", %player::p_af_04_09_reunion_player_strangle);
	add_actor_anim("kravchenko", %generic_human::ch_af_04_09_reunion_krav_strangle, true);
	add_actor_anim("woods", %generic_human::ch_af_04_09_reunion_woods_strangle, false);
	add_horse_anim("horse_for_charge_woods", %horse::ch_af_04_09_reunion_horse_strangle);
	add_vehicle_anim("krav_tank", %vehicles::v_af_04_09_reunion_tank_strangle);
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
	add_scene("e5_s1_walk_in", "rats_nest_struct");
	add_player_anim("player_body", %player::p_af_05_01_victory_player_walk, true, 0, undefined, true, 1, 45, 45, 10, 10);
	add_actor_anim("hudson",%generic_human::ch_af_05_01_victory_hudson_walk);
	add_actor_anim("kravchenko",%generic_human::ch_af_05_01_victory_krav_walk);
	add_actor_anim("zhao",%generic_human::ch_af_05_01_victory_zhao_walk);
	add_actor_anim("woods",%generic_human::ch_af_05_01_victory_woods_walk, true);
}

e5_s2_interrogation_loop_scene()
{
	add_scene("e5_s2_interrogation_loop", "by_numbers_struct", false, false, true);
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_interrogationloop);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_interrogationloop);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_interrogationloop);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_interrogationloop);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_interrogationloop);
	add_player_anim("player_body", %player::p_af_05_02_interrogation_player_interrogationloop);
}
e5_s2_interrogation_move2shoot_scene()
{
	add_scene("e5_s2_interrogation_move2shoot", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_move2shoot);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_move2shoot);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_move2shoot);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_move2shoot);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_move2shoot);
}
e5_s2_interrogation_punch_scene()
{
	add_scene("e5_s2_interrogation_punch", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_punch);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_punch);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_punch);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_punch);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_punch);
}
e5_s2_interrogation_shoot_v1_scene()
{
	add_scene("e5_s2_interrogation_shoot_v1", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_shoot_v1);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_shoot_v1);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_shoot_v1);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_shoot_v1);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_shoot_v1);
}

e5_s2_interrogation_shoot_v2_scene()
{
	add_scene("e5_s2_interrogation_shoot_v2", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_02_interrogation_woods_shoot_v2);
	add_actor_anim("kravchenko", %generic_human::ch_af_05_02_interrogation_krav_shoot_v1);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_02_interrogation_leader_shoot_v1);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_02_interrogation_m01_shoot_v1);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_02_interrogation_m02_shoot_v1);
}

e5_s4_beatdown_scene()
{
	add_scene("e5_s4_beatdown", "by_numbers_struct");
	add_actor_anim("woods", %generic_human::ch_af_05_04_betrayal_woods);
	add_actor_anim("m01_guard", %generic_human::ch_af_05_04_betrayal_m01);
	add_actor_anim("m02_guard", %generic_human::ch_af_05_04_betrayal_m02);
	add_actor_anim("m03_guard", %generic_human::ch_af_05_04_betrayal_m03);
	add_actor_anim("rebel_leader", %generic_human::ch_af_05_04_betrayal_leader);
	add_player_anim("player_body", %player::p_af_05_04_betrayal_player, true);
}

e6_s2_ontruck_1_scene()
{
	add_scene("e6_s2_ontruck_1", "deserted_pickup1");
	add_actor_anim("rebel_leader", %generic_human::ch_af_06_01_deserted_leader_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("woods", %generic_human::ch_af_06_01_deserted_woods_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("m01_guard", %generic_human::ch_af_06_01_deserted_muj1_ontruck, true, false, false, true, "tag_origin");
	
	add_player_anim("player_body", %player::p_af_06_01_deserted_player_ontruck,true, 0, "tag_origin");	
}

e6_s2_ontruck_2_scene()
{
	add_scene("e6_s2_ontruck_2", "deserted_pickup2");
	add_actor_anim("m02_guard", %generic_human::ch_af_06_01_deserted_muj2_ontruck, true, false, false, true, "tag_origin");
	add_actor_anim("m03_guard", %generic_human::ch_af_06_01_deserted_muj3_ontruck, true, false, false, true, "tag_origin");
}

e6_s2_ontruck_trucks_scene()
{
	add_scene("e6_s2_ontruck_trucks", "truck_struct");
	
	add_vehicle_anim("deserted_pickup1", %vehicles::v_af_06_01_deserted_maintruck_ontruck);
	add_vehicle_anim("deserted_pickup2", %vehicles::v_af_06_01_deserted_othertruck_ontruck);
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
	add_actor_anim("m02_guard", %generic_human::ch_af_06_01_deserted_muj2_offtruck);
	add_actor_anim("m03_guard", %generic_human::ch_af_06_01_deserted_muj3_offtruck);
	
	add_vehicle_anim("deserted_pickup1", %vehicles::v_af_06_01_deserted_maintruck_offtruck);
	add_notetrack_custom_function( "deserted_pickup1", "start_moving", maps\afghanistan_deserted::deserted_truck_kickup_dust );
	add_vehicle_anim("deserted_pickup2", %vehicles::v_af_06_01_deserted_othertruck_offtruck);
	add_notetrack_custom_function( "deserted_pickup2", "start_moving", maps\afghanistan_deserted::deserted_truck_kickup_dust );
	
	add_player_anim("player_body", %player::p_af_06_01_deserted_player_offtruck);	
	add_notetrack_custom_function( "player_body", "hit_ground", maps\afghanistan_deserted::deserted_truck_kickout_impact );
}

e6_s2_deserted_single_scene()
{
	add_scene("e6_s2_deserted_single", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view01);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view01);
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view01);
	add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view01);
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view01);	
}

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
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view01);	
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
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view02);	
}
e6_s2_deserted_part3_scene()
{
	add_scene("e6_s2_deserted_part3", "truck_struct");
	add_actor_anim("woods", %generic_human::ch_af_06_02_deserted_woods_view03);
	add_actor_anim("hudson", %generic_human::ch_af_06_02_deserted_hudson_view03);
	add_actor_anim("zhao", %generic_human::ch_af_06_02_deserted_zhao_view03);
	add_actor_model_anim("reznov", %generic_human::ch_af_06_02_deserted_reznov_view03);
	add_actor_model_anim("nomad", %generic_human::ch_af_06_02_deserted_nomad_view03);

	add_horse_anim("reznov_horse", %horse::ch_af_06_02_deserted_reznov_horse_view03);	
	add_horse_anim("nomad_horse", %horse::ch_af_06_02_deserted_nomad_horse_view03);	
	
	add_player_anim("player_body", %player::p_af_06_02_deserted_player_view03);	
}

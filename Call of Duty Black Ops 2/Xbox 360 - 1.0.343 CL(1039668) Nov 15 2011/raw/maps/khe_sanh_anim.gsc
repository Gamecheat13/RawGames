#include maps\_utility;
#include maps\_anim;
#include maps\_scene;
#include common_scripts\utility;

main()
{
	precache_player_anims();
	precache_scripted_anims();
	precache_drone_anims();
	precache_vehicle_anims();
	precache_prop_anims();
	precache_scripted_vo();


	precache_e1_medic();
	precache_e1_civ();
	precache_e1_topless_soldier1();
	precache_e1_topless_soldier2();
	precache_e1_chopper_setup();
	precache_help_soldier();
	precache_e1_bodybag_soldier();
	precache_e1_ready_soldier();
	precache_tower_1_align();
	precache_tower_2_align();
	precache_e1_trench_run();
	precache_e1_jeep_drive();
	precache_e1_jeep_crash();
	precache_e1_wood_think();

	precache_e2_heroic_nva();
	precache_e2_heroic_nva_fail();
	precache_e2_heroic_nva_save();
	//precache_e1_huey_pilots();
	//precache_e1_trench_run_hudson();


	precache_e2_nva_ladder();
	precache_e2_wood_ladder();
	precache_e2_nva_leap();
	precache_e2_top_fight();
	precache_e2_apc_crush();
	precache_e2_nva_leaper_jump();
	precache_e2_nva_leaper_land();
	precache_e2_nva_leaper_death();
	precache_e2_h2h_hudson();
	precache_e3_fourgas_crawl();
	precache_e3_deadmg();
	precache_e3_detonate_drum();

	precache_e4_woods_improvise();
	precache_e4_medic_dead();
	precache_e4_briefing();
	precache_e4_yell_huey();

	precache_e4_gun_jam();
	precache_e5_reveal_loop();


	precache_assets();
}

precache_e5_reveal_loop()
{


}

precache_e4_gun_jam()
{

	add_scene("e4_gun_jam_npc", "align_woods_jam");

	add_actor_anim("gun_jam_marine", %generic_human::ch_khe_E4B_woods_gun_jam_redshirt);

	add_actor_anim("gun_jam_nva", %generic_human::ch_khe_E4B_woods_gun_jam_start_nva);


	add_scene("e4_gun_jam_woods", "align_woods_jam");

	add_actor_anim("woods", %generic_human::ch_khe_E4B_woods_gun_jam_start_woods);

	add_scene("e4_gun_jam_success", "align_woods_jam");

	add_actor_anim("woods", %generic_human::ch_khe_E4B_woods_gun_jam_success_woods);

	add_scene("e4_gun_jam_fail", "align_woods_jam");

	add_actor_anim("gun_jam_nva", %generic_human::ch_khe_E4B_woods_gun_jam_success_nva);



}

precache_e4_yell_huey()
{
	add_scene("e4_yell_huey", "align_friendly_fire_yell");

	add_actor_anim("marine_yell", %generic_human::ch_khe_e4_friendly_wave_guy01);


}

precache_e4_briefing()
{

	add_scene("e4_briefing", "align_sgt_and_woods");

	add_actor_anim("e4_redshirt", %generic_human::ch_khe_e4_sgt_reports_guy01);
	add_actor_anim("woods", %generic_human::ch_khe_e4_sgt_reports_woods);


}

precache_e4_medic_dead()
{
	add_scene("dead_medic", "e4_medic_death_align");
	
	add_actor_anim("hill_medic", %generic_human::ch_khe_E4_redshirt_deathB_medic);
	add_actor_anim("hill_deadguy", %generic_human::ch_khe_E4_redshirt_deathB_guy01);

}

precache_e4_woods_improvise()
{

	add_scene("wood_improves", "kick_the_barrel_woods");

	add_actor_anim("woods", %generic_human::ch_khe_E4_timetoimprovise_woods);
	add_notetrack_custom_function( "woods", "kick", ::woods_detonates);
}


precache_e3_detonate_drum()
{
	add_scene("wood_kick_drum", "align_woods_drum");

	add_actor_anim("woods", %generic_human::ch_khe_E3_woodsDetonates_woods);
//	add_notetrack_custom_function( "woods", "boom", ::woods_detonates );


}

precache_e3_deadmg()
{
		
	//add_scene("dead_mg", "align_e3_mg_diver");
	//add_actor_model_anim("dead_mg", %generic_human::ch_khe_e3_redshirt_turret_death_guy01, "c_usa_jungmar_barechest_fb");

	//addNotetrack_customFunction("dead_mg", "head_shot", ::headshot_guy);

	
}

precache_e3_fourgas_crawl()
{

//	add_scene("e3_fourgass_crawl", "align_e3_crawl_nva");

//	add_actor_model_anim("fougasse_vic_0", %generic_human::ch_khe_E3_nvablowup_close_nva01, "c_vtn_nva1_char");


}

precache_e2_h2h_hudson()
{
	add_scene("e2_h2h_hudson", "e2_woods_h2h");

	add_actor_anim("h2h_hudson_nva", %generic_human::ch_khe_e2_hudson_melee_nva );
	add_actor_anim("hudson", %generic_human::ch_khe_e2_hudson_melee_hudson );


}

precache_e2_nva_leaper_jump()
{

	add_scene("e2_nva_leaper", "align_nva_leaper");

	add_actor_anim("e2_nva_leaper", %generic_human::ch_khe_E2_nvaenergetic_jump );

}

precache_e2_nva_leaper_land()
{

	add_scene("e2_nva_leap_land", "align_nva_leaper");

	add_actor_anim("e2_nva_leaper", %generic_human::ch_khe_E2_nvaenergetic_land );

}

precache_e2_nva_leaper_death()
{

	add_scene("e2_nva_leap_death", "align_nva_leaper");

	add_actor_anim("e2_nva_leaper", %generic_human::ch_khe_E2_nvaenergetic_death );

}

precache_e2_apc_crush()
{
	add_scene("e2_apc_crush", "align_apc_crush");

	add_actor_anim("woods", %generic_human::ch_khe_E2_tank_crush_guy01 );
	add_actor_anim("hudson", %generic_human::ch_khe_E2_tank_crush_guy02 );

}

precache_e2_top_fight()
{

	add_scene("e2_top_fight_1", "e2_top_fight_aligned_marine");

	add_actor_anim("nva", %generic_human::ai_2_ai_melee_fail_front_01_attack );
	add_actor_anim("marine", %generic_human::ai_2_ai_melee_fail_front_01_defend );


	add_scene("e2_top_fight_2", "e2_top_fight_aligned_marine_2");

	add_actor_anim("fight_2", %generic_human::ai_2_ai_melee_fail_back_01_attack );
	add_actor_anim("fight_2_marine", %generic_human::ai_2_ai_melee_fail_back_01_defend );

}


precache_e2_nva_leap()
{
	add_scene("e2_nva_leap", "align_nva_jump_down");

	add_actor_anim("leapdown_nva_0", %generic_human::ch_khe_E2_nva_into_trenches_b_nva01 );
	add_actor_anim("leapdown_nva_1", %generic_human::ch_khe_E2_nva_into_trenches_b_nva02 );
	add_actor_anim("leapdown_nva_2", %generic_human::ch_khe_E2_nva_into_trenches_b_nva04 );

}


precache_e2_wood_ladder()
{

	add_scene( "e2_wood_ladder", "align_woods_blindfire" );
	
	add_actor_anim( "woods", %generic_human::ch_khe_E2_woods_blindfire_woods );
}


precache_e2_nva_ladder()
{
	add_scene( "e2_nva_ladder", "align_woods_blindfire_nva" );
	add_actor_anim( "ladder_nva_0", %generic_human::ch_khe_E2_nva_ladders_nva01 );
	add_actor_anim( "ladder_nva_1", %generic_human::ch_khe_E2_nva_ladders_nva02 );
	add_actor_anim( "ladder_nva_2", %generic_human::ch_khe_E2_nva_ladders_nva03 );
	add_actor_anim( "ladder_nva_3", %generic_human::ch_khe_E2_nva_ladders_nva04 );
	add_actor_anim( "ladder_nva_4", %generic_human::ch_khe_E2_nva_ladders_death_nva01 );


}

precache_e2_heroic_nva_fail()
{
	add_scene("e2_heroic_nva_fail", "e1c_bunker_align");

	add_actor_anim("heroic_nva", %generic_human::ch_khe_E1C_nvatackle_fail_nva01, true);
	add_actor_anim("heroic_soldier01", %generic_human::ch_khe_E1C_nvatackle_fail_guy01);

}

precache_e2_heroic_nva_save()
{
	add_scene("e2_heroic_nva_save", "e1c_bunker_align");

	add_actor_anim("heroic_soldier01", %generic_human::ch_khe_E1C_nvatackle_save_guy01);


}

precache_e2_heroic_nva()
{
	add_scene("e2_heroic_nva", "e1c_bunker_align");

	add_actor_anim("heroic_nva", %generic_human::ch_khe_E1C_nvatackle_nva01, true);
	add_actor_anim("heroic_soldier01", %generic_human::ch_khe_E1C_nvatackle_guy01);
}

precache_e1_wood_think()
{

	add_scene("e1_wood_bunk_think", "e1c_bunker_align");

	add_actor_anim( "woods", %generic_human::ch_khe_E1C_heroicsoldier_woods );

}


precache_e1_jeep_crash()
{

	add_scene("e1_jeep_crash", "e1_anim_align");

	add_actor_anim( "hudson", %generic_human::ch_khe_E1C_c130crash_hudson );
	add_actor_anim( "woods", %generic_human::ch_khe_E1C_c130crash_woods );

}

precache_e1_jeep_drive()
{
	add_scene("e1_jeep_passenger", "e1_anim_align");

	//add_actor_anim( "driver", %generic_human::ch_khe_opening_intro_driver );
	add_actor_anim( "hudson", %generic_human::ch_khe_opening_intro_hudson );
	add_actor_anim( "woods", %generic_human::ch_khe_opening_intro_woods );
	//add_player_anim( "player_hands", %player::ch_khe_opening_intro_player, true );

}

precache_e1_huey_pilots()
{
	add_scene("e1_huey_pilot", "hero_huey", false, false, true);

	add_actor_anim( "huey_pilot", %generic_human::ai_huey_pilot1_idle_loop1, false, false, false, "tag_driver" );
	add_actor_anim( "huey_copilot", %generic_human::ai_huey_pilot2_idle_loop1, false, false, false, "tag_passenger" );

}
precache_e1_trench_run()
{
	add_scene("e1_trenchrun", "e1_player_trench_align");
	add_actor_anim( "hudson", %generic_human::ai_carry_hudson_idle, false, false );
	//add_player_anim( "player_body", %player::int_carry_hudson_idle);
}

precache_e1_trench_run_hudson()
{
	add_scene("e1_trenchrun_hudson", "e1_player_trench_align");
	add_actor_anim( "hudson", %generic_human::ai_carry_hudson_walk, false, false );

	add_scene("e1_trenchrun_hudson_idle", "e1_player_trench_align");
	add_actor_anim( "hudson", %generic_human::ai_carry_hudson_idle, false, false );

}


precache_e1_medic()
{

	add_scene("e1_medic", "e1_medic_soldiers_align");

	add_actor_anim( "medic_soldier_01", %generic_human::ch_khe_opening_stretcher2huey_guy01, true, true );
	add_actor_anim( "medic_soldier_02", %generic_human::ch_khe_opening_stretcher2huey_guy02, true, true );
	add_actor_anim( "medic_soldier_03", %generic_human::ch_khe_opening_stretcher2huey_guy03, true, true );


}
precache_e1_civ()
{

	add_scene("e1_civ", "e1_civilians_align");

	add_actor_anim( "civilian_male_01", %generic_human::ch_khe_E1B_civswatchtanks_guy01 );
	add_actor_anim( "civilian_male_02", %generic_human::ch_khe_E1B_civswatchtanks_guy02 );
	add_actor_anim( "civilian_male_03", %generic_human::ch_khe_E1B_civswatchtanks_guy03 );


}

precache_e1_topless_soldier1()
{

	add_scene("e1_topless", "e1_barechest_align");
	add_actor_model_anim( "barechest_guy", %generic_human::ch_khe_opening_barechested_soldier, "c_usa_jungmar_barechest_fb");


}

precache_e1_topless_soldier2()
{

	add_scene("e1_topless2", "e1_barechest_align_2");

	add_actor_model_anim( "barechest_guy2", %generic_human::ch_khe_opening_barechested_soldier, "c_usa_jungmar_barechest_fb" );
}

precache_e1_chopper_setup()
{

	add_scene("e1_chopper1", "support_chopper_01", false, false, true);

	add_actor_anim( "support_troop_01", %generic_human::ch_khe_E1B_chinookdropoff_guy01);
	add_actor_anim( "support_troop_02", %generic_human::ch_khe_E1B_chinookdropoff_guy02);
	add_actor_anim( "support_troop_03", %generic_human::ch_khe_E1B_chinookdropoff_guy03);
	add_actor_anim( "support_troop_04", %generic_human::ch_khe_E1B_chinookdropoff_guy04);
	add_actor_anim( "support_troop_05", %generic_human::ch_khe_E1B_chinookdropoff_guy05);
	add_actor_anim( "support_troop_sgt", %generic_human::ch_khe_E1B_chinookdropoff_sgt);

	//add_prop_anim( "support_chopper", %);

}
precache_help_soldier()
{

	add_scene("e1_help_soldier", "e1_helping_soldiers_align");

	add_actor_anim("helping_soldier_01", %generic_human::ch_khe_E1B_soldiershelpwounded_guy01);
	add_actor_anim("helping_soldier_02", %generic_human::ch_khe_E1B_soldiershelpwounded_guy02);

}

precache_e1_bodybag_soldier()
{

	add_scene("e1_bodybag_soldier", "e1_bodybags_align");
	add_actor_model_anim( "bodybags_chaplan", %generic_human::ch_khe_E1B_bodybags_chap);
	add_actor_model_anim( "bodybags_guy01", %generic_human::ch_khe_E1B_bodybags_guy01, "c_usa_jungmar_barechest_fb");
	add_actor_model_anim( "bodybags_guy02", %generic_human::ch_khe_E1B_bodybags_guy02, "c_usa_jungmar_barechest_fb");


}
precache_e1_ready_soldier()
{

	add_scene("e1_ready_soldier", "e1_ready_soldiers_align");

	add_actor_anim("ready_soldier_01", %generic_human::ch_khe_E1B_readyweapons_guy01);
	add_actor_anim("ready_soldier_02", %generic_human::ch_khe_E1B_readyweapons_guy02);

}

precache_tower_1_align()
{
	add_scene("e1_tower_1_soldier", "e1_tower01_align");

	add_actor_anim("tower01_guy01", %generic_human::ch_khe_E1B_twointower_guy01);
	add_actor_anim("tower01_guy02", %generic_human::ch_khe_E1B_twointower_guy02);

}

precache_tower_2_align()
{
	add_scene("e1_tower_2_soldier", "e1_tower02_align");

	add_actor_anim("tower02_guy01", %generic_human::ch_khe_E1B_lookoutcheer_guy01);
	add_actor_anim("tower02_guy02", %generic_human::ch_khe_E1B_lookoutcheer_guy02);

}


#using_animtree("khesanh");
precache_player_anims()
{
	// Setup marine full body
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;

	// Setup marine interactive hands
	level.scr_model["player_hands"] = level.player_interactive_hands;
	level.scr_animtree["player_hands"] = #animtree;

	// Setup Anims
	level.scr_anim["player_body"]["intro"] = %ch_khe_opening_intro_player;
	level.scr_anim["player_body"]["jeep_ride"][0] = %ch_khe_E1B_driveidle_player;

	level.scr_anim["player_body"]["crash_idle"][0] = %ch_khe_E1B_driveidle_player;

	level.scr_anim["player_body"]["crash"] = %ch_khe_E1C_c130crash_player;
	addNotetrack_customFunction("player_body", "player_jump", ::player_jump, "crash");	

	//level.scr_anim["player_body"]["crash_fail"] = %ch_khe_E1C_c130crash_player_fail;
	level.scr_anim["player_body"]["crash_jump"] = %ch_khe_E1C_c130crash_jump_player;
	level.scr_anim["player_body"]["trench_walk"][0] =  %int_carry_hudson_walk; 
	level.scr_anim["player_body"]["trench_idle"][0] =  %int_carry_hudson_idle;
	level.scr_anim["player_body"]["trench_done"] = %ch_khe_E1C_hudson_ok_player_part1;
	level.scr_anim["player_body"]["trench_done_2"] = %ch_khe_E1C_hudson_ok_player_part2;
	addNotetrack_customFunction("player_body", "gravel", ::jeep_jump_gravel, "crash_jump");	
	addNotetrack_customFunction("player_body", "drag_end", ::drag_end, "crash_jump");	

	// e3 nva turret dive
	level.scr_anim["player_body"]["strength_test_start"] = %ch_khe_E3_nvaturretDive_player;
	level.scr_anim["player_body"]["strength_test_loop"][0] = %ch_khe_E3_nvaturretDive_choke_player;
	level.scr_anim["player_body"]["strength_test_success"] = %ch_khe_E3_nvaturretDive_success_player;

	level.scr_anim["player_body"]["kick_barrel"] = %ch_khe_E3_kickbarrel_player;
	addNotetrack_customFunction("player_body", "kick", ::player_kick, "kick_barrel");	

	level.scr_anim["player_body"]["kick_barrel_spark"] = %ch_khe_E3_kickbarrel_spark_player;
	addNotetrack_customFunction("player_body", "start_sparks", ::start_sparks, "kick_barrel_spark");	
	addNotetrack_customFunction("player_body", "stop_sparks", ::stop_sparks, "kick_barrel_spark");	
	addNotetrack_customFunction("player_body", "kick", ::player_kick, "kick_barrel_spark");	

	//e3 pickup china lake
	//level.scr_anim["player_hands"]["pickup_china_lake"] = %ch_khe_E3_pickuplauncher_player;
	
	//mount/exit tow
	level.scr_anim["player_hands"]["mount_tow"] = %int_tow_mount;
	level.scr_anim["player_hands"]["dismount_tow"] = %int_tow_dismount;

	level.scr_anim["player_hands"]["enter_jeep"] = %int_jeep_tow_climb_in;
	level.scr_anim["player_hands"]["exit_jeep"] = %int_jeep_tow_climb_out;
	
	//e4 gun jam player
	level.scr_anim["player_body"]["player_gun_jam"] = %ch_khe_E4B_woods_gun_jam_player;
	addNotetrack_customFunction("player_body", "start_melee", ::start_hilltop_melee, "player_gun_jam");	
	addNotetrack_customFunction("player_body", "player_shoot", ::hilltop_shoot_window, "player_gun_jam");	
	level.player_body_jam = GetAnimLength(level.scr_anim["player_body"]["player_gun_jam"]);
	//level.scr_anim["player_body"]["gun_jam_loop"][0] = %ch_khe_E4B_woods_gun_jam_player_loop;	

	//bowman reveal
	level.scr_anim["player_body"]["reveal_loop"][0] = %ch_khe_e5_bowman_reveal_loop_player;
	level.scr_anim["player_body"]["reveal"] = %ch_khe_e5_bowman_reveal_player;		
}

//#using_animtree("vehicles");
precache_vehicle_anims()
{
	// Setup hero huey
	level.scr_model["hero_huey"] = "t5_veh_helo_huey_usmc";
	level.scr_animtree["hero_huey"] = #animtree;

	// Setup huey anims
	level.scr_anim["hero_huey"]["intro"] = %v_khe_opening_intro_helo;

	// Setup jeep anims
	level.scr_model["hero_jeep"] = "t5_veh_jeep";
	level.scr_animtree["hero_jeep"] = #animtree;
	level.scr_anim["hero_jeep"]["intro"] = %v_khe_opening_intro_jeep;
	level.scr_anim["hero_jeep"]["crash"] = %v_khe_E1C_c130crash_jeep01;
	//addNotetrack_customFunction("hero_jeep", "crash_fail", ::crash_fail, "crash");	

	//level.scr_anim["hero_jeep"]["crash_fail"] = %v_khe_E1C_c130crash_jeep01_fail;

	level.scr_model["hero_jeep_2"] = "t5_veh_jeep";
	level.scr_animtree["hero_jeep_2"] = #animtree;
	level.scr_anim["hero_jeep_2"]["crash"] = %v_khe_E1C_c130crash_jeep02;

	// Setup Chinook
	level.scr_model["support_chopper"] = "vehicle_ch46e";
	level.scr_animtree["support_chopper"] = #animtree;
	level.scr_anim["support_chopper"]["intro"][0] = %v_khe_E1B_chinookdropoff_helo;

	// Setup C130 Crash
	level.scr_model["c130_crash"] = "t5_veh_air_c130";
	level.scr_animtree["c130_crash"] = #animtree;
	level.scr_anim["c130_crash"]["crash"] = %v_khe_E1C_c130crash_c130;
	addNotetrack_customFunction("c130_crash", "c130_light", ::c130_dlight, "crash");	

	level.scr_model["c130_crash_parts"] = "t5_veh_air_c130_damaged_parts";
	level.scr_animtree["c130_crash_parts"] = #animtree;
	level.scr_anim["c130_crash_parts"]["crash"] = %v_khe_E1C_c130crash_c130;

	// Crash Note Tracks
	addNotetrack_customFunction("c130_crash", "wing_hit", ::c130_wing_impact, "crash");	
	addNotetrack_customFunction("c130_crash", "propeller_hit", ::c130_propeller_impact, "crash");	

	//event 3 huey crash
	level.scr_model["huey_guard"] = "t5_veh_helo_huey_usmc";
	level.scr_animtree["huey_guard"] = #animtree;
	level.scr_anim["huey_guard"]["huey_guard_crash"] = %v_khe_e2_hueycrash_huey;
	level.scr_anim["huey_guard"]["reveal_loop"] = %v_khe_e5_bowman_reveal_loop_huey;
	level.scr_anim["huey_guard"]["reveal"] = %v_khe_e5_bowman_reveal_huey;
}

precache_prop_anims()
{
	//e2 ladders
	level.scr_model["ladder_0"] = "p_rus_ladder_metal_256";
	level.scr_animtree["ladder_0"] = #animtree;
	level.scr_anim["ladder_0"]["ladder_blind_fire"] = %p_khe_E2_nva_ladders_ladder01;
	addNotetrack_customFunction("ladder_0", "ladder_land", ::ladder_land_dust_one, "ladder_blind_fire");	

	level.scr_model["ladder_1"] = "p_rus_ladder_metal_256";
	level.scr_animtree["ladder_1"] = #animtree;
	level.scr_anim["ladder_1"]["ladder_blind_fire"] = %p_khe_E2_nva_ladders_ladder02;
	addNotetrack_customFunction("ladder_1", "ladder_land", ::ladder_land_dust_two, "ladder_blind_fire");	

	//e2 apc crush
	level.scr_model["apc_to_crush"] = "t5_veh_m113_khesanh";
	level.scr_animtree["apc_to_crush"] = #animtree;
	level.scr_anim["apc_to_crush"]["apc_crush"] = %fxanim_khesanh_apc_fall_01_anim;
	level.scr_anim["apc_to_crush"]["apc_crush_end"] = %fxanim_khesanh_apc_fall_02_anim;
	level.scr_anim["apc_to_crush"]["turret_fighter"][0] = %v_khe_E2_turret_fighter_m113;
	//addNotetrack_customFunction("apc_to_crush", "fire", ::fire_apc_gun, "turret_fighter");
	
	//e2 apc gun
	level.scr_model["apc_turret_fighter"] = "t5_veh_m113_khesanh";
	level.scr_animtree["apc_turret_fighter"] = #animtree;
	level.scr_anim["apc_turret_fighter"]["turret_fighter"][0] = %v_khe_E2_turret_fighter_m113;
	addNotetrack_customFunction("apc_turret_fighter", "fire", ::fire_apc_gun, "turret_fighter");	

	// body bags
	level.scr_anim["body_bag01"]["intro"][0] = %ch_khe_E1B_bodybags_bod01;
	level.scr_anim["body_bag02"]["intro"][0] = %ch_khe_E1B_bodybags_bod02;
	level.scr_anim["body_bag03"]["intro"][0] = %ch_khe_E1B_bodybags_bod03;
	level.scr_anim["tarp"]["intro"][0] = %ch_khe_E1B_bodybags_tarp;

	level.scr_animtree["body_bags"] = #animtree;

	//event 3 - 4 trap door
	//TODO: USE THIS WHEN WE HAVE SCRIPT MODEL
	level.scr_model["e3_trap_door"] = "p_jun_khe_sahn_hatch";
	level.scr_animtree["e3_trap_door"] = #animtree;
	level.scr_anim["e3_trap_door"]["open_trap_door"] = %o_khe_e3_woods_trap_door_door ;

	//bandana prop
	//level.scr_model["woods_bandana"] = "c_usa_jungmar_barnes_bandana";
	//level.scr_animtree["woods_bandana"] = #animtree;
	//level.scr_anim["woods_bandana"]["bandana_off"] = %v_khe_E2_turret_fighter_m113;


	level.scr_model["wood_plank_large_0"] = "p_jun_wood_plank_large01";
	level.scr_animtree["wood_plank_large_0"] = #animtree;
	level.scr_anim["wood_plank_large_0"]["rubble_dude_loop"][0] = %ch_khe_e4_free_from_rubble_b_loop_plank01;
	level.scr_anim["wood_plank_large_0"]["rubble_dude"] = %ch_khe_e4_free_from_rubble_b_start_plank01;

	level.scr_model["wood_plank_large_1"] = "p_jun_wood_plank_large01";
	level.scr_animtree["wood_plank_large_1"] = #animtree;
	level.scr_anim["wood_plank_large_1"]["rubble_dude_loop"][0] = %ch_khe_e4_free_from_rubble_b_loop_plank03;
	level.scr_anim["wood_plank_large_1"]["rubble_dude"] = %ch_khe_e4_free_from_rubble_b_start_plank03;

	level.scr_model["wood_plank_small_0"] = "p_jun_wood_plank_small01";
	level.scr_animtree["wood_plank_small_0"] = #animtree;
	level.scr_anim["wood_plank_small_0"]["rubble_dude_loop"][0] = %ch_khe_e4_free_from_rubble_b_loop_plank02;
	level.scr_anim["wood_plank_small_0"]["rubble_dude"] = %ch_khe_e4_free_from_rubble_b_start_plank02;

	level.scr_model["wood_plank_small_1"] = "p_jun_wood_plank_small01";
	level.scr_animtree["wood_plank_small_1"] = #animtree;
	level.scr_anim["wood_plank_small_1"]["rubble_dude_loop"][0] = %ch_khe_e4_free_from_rubble_b_loop_plank04;
	level.scr_anim["wood_plank_small_1"]["rubble_dude"] = %ch_khe_e4_free_from_rubble_b_start_plank04;

	//rubble with 2 dudes
	level.scr_model["plank_01"] = "p_jun_wood_plank_small01";
	level.scr_animtree["plank_01"] = #animtree;
	level.scr_anim["plank_01"]["e5_rubble_start"] = %o_khe_e4_free_from_rubble_a_start_plank01;
	level.scr_anim["plank_01"]["e5_rubble_loop"][0] = %o_khe_e4_free_from_rubble_a_loop_plank01;

	level.scr_model["plank_02"] = "p_jun_wood_plank_small01";
	level.scr_animtree["plank_02"] = #animtree;
	level.scr_anim["plank_02"]["e5_rubble_start"] = %o_khe_e4_free_from_rubble_a_start_plank02;
	level.scr_anim["plank_02"]["e5_rubble_loop"][0] = %o_khe_e4_free_from_rubble_a_loop_plank02;

	level.scr_model["crate"] = "p_glo_crate01";
	level.scr_animtree["crate"] = #animtree;
	level.scr_anim["crate"]["e5_rubble_start"] = %o_khe_e4_free_from_rubble_a_start_crate;
	level.scr_anim["crate"]["e5_rubble_loop"][0] = %o_khe_e4_free_from_rubble_a_loop_crate;

	level.scr_model["mg_prop"] = "t5_weapon_m60e3_MG";
	level.scr_animtree["mg_prop"] = #animtree;
	level.scr_anim["mg_prop"]["crazy_mg"][0] = %o_khe_E3_woodsMG_MG;
	level.scr_anim["mg_prop"]["mg_assist"] = %o_khe_E3_woodsassist_MG;

	level.scr_model["woods_knife"] = "t5_knife_sog";
	level.scr_animtree["woods_knife"] = #animtree;
	level.scr_anim["woods_knife"]["improvise"] = %o_khe_E4_timetoimprovise_knife;

}


#using_animtree( "fakeShooters" );
// Seup Drone animations
precache_drone_anims()
{
	// Special Drone Anims
	level.drones.anims[ "jump" ]	= %ai_jump_across_120;
}


#using_animtree("generic_human");
precache_scripted_anims()
{
	//vehicle ai anim does not handle stop idle just drive idle THIS IS STOP IDLE
	level.scr_anim["woods"]["jeep_ride_stop"][0] = %crew_jeep1_driver_stop_idle;
	level.scr_anim["hudson"]["jeep_ride_stop"][0] = %crew_jeep1_passenger1_stop_idle;	

	//vehicle ai anim does not handle stop idle just drive idle: THIS IS DRIVE IDLE
	level.scr_anim["woods"]["jeep_ride_drive"][0] = %crew_jeep1_driver_drive_idle;
	level.scr_anim["hudson"]["jeep_ride_drive"][0] = %crew_jeep1_passenger1_drive_idle;	
	
	// Setup intro anims
	level.scr_anim["woods"]["intro"] = %ch_khe_opening_intro_woods;
	level.scr_anim["hudson"]["intro"] = %ch_khe_opening_intro_hudson;
	level.scr_anim["driver"]["intro"] = %ch_khe_opening_intro_driver;

	// Jeep ride anims: note that these are also the generic jeep drive idles
	level.scr_anim["woods"]["jeep_ride"][0] = %crew_jeep1_passenger1_drive_idle;
	level.scr_anim["hudson"]["jeep_ride"][0] = %crew_jeep1_passenger2_drive_idle;
	level.scr_anim["driver"]["jeep_ride"][0] = %crew_jeep1_driver_drive_idle;

	// Jeep crash anims
	level.scr_anim["woods"]["crash"] = %ch_khe_E1C_c130crash_woods;
	level.scr_anim["hudson"]["crash"] = %ch_khe_E1C_c130crash_hudson;
	level.scr_anim["driver"]["crash"] = %ch_khe_E1C_c130crash_driver;

	// Jeep crash fail anims
	//level.scr_anim["woods"]["crash_fail"] = %ch_khe_E1C_c130crash_woods_fail;
	//level.scr_anim["hudson"]["crash_fail"] = %ch_khe_E1C_c130crash_hudson_fail;
	//level.scr_anim["driver"]["crash_fail"] = %ch_khe_E1C_c130crash_driver_fail;

	// Jeep crash jump anims
	level.scr_anim["hudson"]["crash_jump"] = %ch_khe_E1C_c130crash_jump_hudson;
	level.scr_anim["woods"]["crash_jump"] = %ch_khe_E1C_c130crash_jump_woods;

	// Trench walk anims
	level.scr_anim["hudson"]["trench_idle"][0] = %ai_carry_hudson_idle;
	level.scr_anim["hudson"]["trench_walk"][0] = %ai_carry_hudson_walk;
	level.scr_anim["hudson"]["trench_done"] = %ch_khe_E1C_hudson_ok_hudson_part1;
	level.scr_anim["hudson"]["trench_done_2"] = %ch_khe_E1C_hudson_ok_hudson_part2;

	//death anims
	level.scr_anim["dead_guy_0"]["death_0"][0] = %ch_khe_e2_death_pose_b;
	level.scr_anim["dead_guy_1"]["death_1"][0] = %ch_khe_e2_death_pose_a;


	// Hero Huey Pilot/Copilot
	level.scr_anim["huey_pilot"]["idle"][0] = %ai_huey_pilot1_idle_loop1;
	level.scr_anim["huey_copilot"]["idle"][0] = %ai_huey_pilot2_idle_loop1;

	// Event 1 vignettes
	level.scr_anim["barechest_guy"]["intro"][0] = %ch_khe_opening_barechested_soldier;
	level.scr_anim["barechest_guy_2"]["intro"][0] = %ch_khe_opening_barechested_soldier;
	level.scr_anim["ready_soldier_01"]["intro"][0] = %ch_khe_E1B_readyweapons_guy01;
	level.scr_anim["ready_soldier_02"]["intro"][0] = %ch_khe_E1B_readyweapons_guy02;

	// Helping wounded
	level.scr_anim["helping_soldier_01"]["intro"][0] = %ch_khe_E1B_soldiershelpwounded_guy01;
	level.scr_anim["helping_soldier_02"]["intro"][0] = %ch_khe_E1B_soldiershelpwounded_guy02;

	// Medic Guys
	//level.scr_anim["medic_soldier_01"]["intro"][0] = %ch_khe_opening_stretcher2huey_guy01;
	//level.scr_anim["medic_soldier_02"]["intro"][0] = %ch_khe_opening_stretcher2huey_guy02;
	//level.scr_anim["medic_soldier_03"]["intro"][0] = %ch_khe_opening_stretcher2huey_guy03;

	// Helicopter Support Troops
	level.scr_anim["support_troop_01"]["intro"][0] = %ch_khe_E1B_chinookdropoff_guy01;
	level.scr_anim["support_troop_02"]["intro"][0] = %ch_khe_E1B_chinookdropoff_guy02;
	level.scr_anim["support_troop_03"]["intro"][0] = %ch_khe_E1B_chinookdropoff_guy03;
	level.scr_anim["support_troop_04"]["intro"][0] = %ch_khe_E1B_chinookdropoff_guy04;
	level.scr_anim["support_troop_05"]["intro"][0] = %ch_khe_E1B_chinookdropoff_guy05;
	level.scr_anim["support_troop_sgt"]["intro"][0] = %ch_khe_E1B_chinookdropoff_sgt;

	// Troop Sprints
	level.scr_anim["generic"]["sprint_1"] = %ch_wmd_b01_avalanche_sprint_weaver;
	level.scr_anim["generic"]["sprint_2"] = %ch_khe_E1B_troopssprint_1;
	level.scr_anim["generic"]["sprint_3"] = %ch_khe_E1B_troopssprint_2;
	level.scr_anim["generic"]["sprint_4"] = %ch_khe_E1B_troopssprint_3;
	level.scr_anim["generic"]["sprint_5"] = %ch_khe_E1B_troopssprint_4;
	level.scr_anim["generic"]["sprint_6"] = %ch_khe_E1B_troopssprint_5;
	level.scr_anim["generic"]["sprint_7"] = %ch_khe_E1B_troopssprint_6;
	level.scr_anim["generic"]["sprint_8"] = %ch_khe_E1B_troopssprint_7;
	level.scr_anim["generic"]["sprint_9"] = %ch_khe_E1B_troopssprint_8;

	// Traversal
	level.scr_anim["generic"]["trench_stairs"] = %ai_traverse_down_stair_khesahn;

	// Body Bag Guys
	level.scr_anim["bodybags_chaplan"]["intro"][0] = %ch_khe_E1B_bodybags_chap;
	level.scr_anim["bodybags_guy01"]["intro"][0] = %ch_khe_E1B_bodybags_guy01;
	level.scr_anim["bodybags_guy02"]["intro"][0] = %ch_khe_E1B_bodybags_guy02;

	// Tower 1 Guys
	level.scr_anim["tower01_guy01"]["intro"][0] = %ch_khe_E1B_twointower_guy01;
	level.scr_anim["tower01_guy02"]["intro"][0] = %ch_khe_E1B_twointower_guy02;

	// Tower 2 Guys
	level.scr_anim["tower02_guy01"]["intro"][0] = %ch_khe_E1B_lookoutcheer_guy01;
	level.scr_anim["tower02_guy02"]["intro"][0] = %ch_khe_E1B_lookoutcheer_guy02;

	// Civilians
	//level.scr_anim["civilian_male_01"]["intro"][0] = %ch_khe_E1B_civswatchtanks_guy01;
	//level.scr_anim["civilian_male_02"]["intro"][0] = %ch_khe_E1B_civswatchtanks_guy02;
	//level.scr_anim["civilian_male_03"]["intro"][0] = %ch_khe_E1B_civswatchtanks_guy03;

	// Crash guys
	level.scr_anim["crash_guy01"]["crash"] = %ch_khe_E1C_c130crash_guy01;
	level.scr_anim["crash_guy02"]["crash"] = %ch_khe_E1C_c130crash_guy02;
	level.scr_anim["crash_guy03"]["crash"] = %ch_khe_E1C_c130crash_guy03;
	level.scr_anim["crash_guy04"]["crash"] = %ch_khe_E1C_c130crash_guy04;
	level.scr_anim["crash_guy05"]["crash"] = %ch_khe_E1C_c130crash_guy05;

	// E1C Vignettes
	level.scr_anim["trench_mortarsgt"]["idle"][0] = %ch_khe_E1C_mortarsgt_idle_sgt;
	level.scr_anim["trench_mortarsgt"]["death"] = %ch_khe_E1C_mortarsgt_death_sgt;
	addNotetrack_customFunction("trench_mortarsgt", "ragdoll", ::death_ragdoll, "death");	

	level.scr_anim["trench_mortarexp"]["death"] = %ch_khe_E1C_mortarexplosion_guy01;
	addNotetrack_customFunction("trench_mortarexp", "ragdoll", ::death_ragdoll, "death");	

	// E1C Bunker
	level.scr_anim["radioguy_sgt"]["idle"][0] = %ch_khe_E1C_sgtradiohelp_sgt;
	level.scr_anim["radioguy_sgt"]["go"] = %ch_khe_E1C_sgtradiohelp_letsgo_sgt;
	level.scr_anim["sobbing_guy"]["idle"][0] = %ch_khe_E1C_sobbingsoldier_guy01;

	level.scr_anim["heroic_soldier01"]["bunker"] = %ch_khe_E1C_heroicsoldier_guy01;
	level.scr_anim["heroic_soldier02"]["bunker"] = %ch_khe_E1C_heroicsoldier_guy02;
	level.scr_anim["heroic_nva"]["bunker"] = %ch_khe_E1C_heroicsoldier_nva01;
	level.scr_anim["woods"]["bunker"] = %ch_khe_E1C_heroicsoldier_woods;
	level.scr_anim["hudson"]["bunker"] = %ch_khe_E1C_heroicsoldier_hudson;
	addNotetrack_customFunction("heroic_soldier02", "fire", ::heroic_nva_fire_gun, "bunker");
	addNotetrack_customFunction("heroic_soldier02", "drop_weapon", ::heroic_nva_drop_wep, "bunker");	

	addNotetrack_customFunction("heroic_nva", "start_ragdoll", ::heroic_death_nva, "bunker");	
//	addNotetrack_customFunction("heroic_soldier02", "start_ragdoll", ::death_ragdoll, "bunker");	

	level.scr_anim["bunker_guy01"]["bunker_idle"][0] = %ch_khe_E1C_bunker_ambient_guy01;
	level.scr_anim["bunker_guy02"]["bunker_idle"][0] = %ch_khe_E1C_bunker_ambient_guy02;
	level.scr_anim["bunker_guy03"]["bunker_idle"][0] = %ch_khe_E1C_bunker_ambient_guy03;
	level.scr_anim["bunker_guy04"]["bunker_idle"][0] = %ch_khe_E1C_bunker_ambient_guy04;
	
	//E2 tackle
	//level.scr_anim["tackle_atkr"]["tackle"] = %ch_khe_E1C_nvatackle_nva01;
	//level.scr_anim["tackle_vic"]["tackle"] = %ch_khe_E1C_nvatackle_guy01;
	//level.scr_anim["tackle_atkr"]["tackle_fail"] = %ch_khe_E1C_nvatackle_fail_nva01;
	//level.scr_anim["tackle_vic"]["tackle_fail"] = %ch_khe_E1C_nvatackle_fail_guy01;
	//level.scr_anim["tackle_vic"]["tackle_save"] = %ch_khe_E1C_nvatackle_save_guy01;
	addNotetrack_customFunction("tackle_atkr", "start_window", ::tackle_start_window, "tackle");	
	addNotetrack_customFunction("tackle_atkr", "end_window", ::tackle_end_window, "tackle");
	addNotetrack_customFunction("tackle_atkr", "dirt_edge", ::dirt_edge_fx, "tackle");

	//e2 woods ladder blindfire
	level.scr_anim["woods"]["ladder_blind_fire"] = %ch_khe_E2_woods_blindfire_woods;
	level.scr_anim["ladder_nva_0"]["ladder_blind_fire"] = %ch_khe_E2_nva_ladders_nva01;
	level.scr_anim["ladder_nva_1"]["ladder_blind_fire"] = %ch_khe_E2_nva_ladders_nva02;
	level.scr_anim["ladder_nva_2"]["ladder_blind_fire"] = %ch_khe_E2_nva_ladders_nva03;
	level.scr_anim["ladder_nva_3"]["ladder_blind_fire"] = %ch_khe_E2_nva_ladders_nva04;
	level.scr_anim["ladder_nva_4"]["ladder_blind_fire"] = %ch_khe_E2_nva_ladders_death_nva01;
	addNotetrack_customFunction("ladder_nva_0", "kill_ready", ::set_allow_death, "ladder_blind_fire");
	addNotetrack_customFunction("ladder_nva_2", "kill_ready", ::set_allow_death, "ladder_blind_fire");

	//e2 turret fighter
	level.scr_anim["apc_turret_guy"]["turret_fighter"][0] = %ch_khe_E2_turret_fighter_guy01;
	level.scr_anim["apc_turret_guy_crush"]["turret_fighter"][0] = %ch_khe_E2_turret_fighter_guy01;
	addNotetrack_customFunction("apc_turret_guy_crush", "fire", ::fire_apc_gun_for_crush, "turret_fighter");

	//e2 ladder leap downs
	level.scr_anim["leapdown_nva_0"]["leapdown_blindfire"] = %ch_khe_E2_nva_into_trenches_b_nva01;
	level.scr_anim["leapdown_nva_1"]["leapdown_blindfire"] = %ch_khe_E2_nva_into_trenches_b_nva02;
	level.scr_anim["leapdown_nva_2"]["leapdown_blindfire"] = %ch_khe_E2_nva_into_trenches_b_nva04;
	addNotetrack_customFunction("leapdown_nva_0", "dirt_edge", ::dirt_edge_fx, "leapdown_blindfire");
	addNotetrack_customFunction("leapdown_nva_1", "dirt_edge", ::dirt_edge_fx, "leapdown_blindfire");
	addNotetrack_customFunction("leapdown_nva_2", "dirt_edge", ::dirt_edge_fx, "leapdown_blindfire");

	//e2 melee vignettes on the top
	level.scr_anim["nva"]["melee_front"] = %ai_2_ai_melee_fail_front_01_attack;
	level.scr_anim["marine"]["melee_front"] = %ai_2_ai_melee_fail_front_01_defend;
	level.scr_anim["nva"]["melee_back"] = %ai_2_ai_melee_fail_back_01_attack;
	level.scr_anim["marine"]["melee_back"] = %ai_2_ai_melee_fail_back_01_defend;
	addNotetrack_customFunction("marine", "bodyfall large", ::set_takedamage, "melee_front");
	addNotetrack_customFunction("marine", "footstep_left_large", ::set_takedamage, "melee_back");

	//e2 flame vignette
	level.scr_anim["e2_spawner_flame_nva"]["flame_trench"] = %ch_khe_E2_nva_flame_trench_nva;
	level.scr_anim["e2_spawner_flame_marine"]["flame_trench"] = %ch_khe_E2_nva_flame_trench_guy01;		

	//e2 nva leaper
	level.scr_anim["e2_nva_leaper"]["leaper_jump"] = %ch_khe_E2_nvaenergetic_jump;		
	level.scr_anim["e2_nva_leaper"]["leaper_land"] = %ch_khe_E2_nvaenergetic_land;		
	level.scr_anim["e2_nva_leaper"]["leaper_death"] = %ch_khe_E2_nvaenergetic_death;	
	addNotetrack_customFunction("e2_nva_leaper", "dirt_edge", ::dirt_edge_fx, "leaper_jump");
	addNotetrack_customFunction("e2_nva_leaper", "dirt_edge", ::dirt_edge_fx, "leaper_land");

	//e2 apc crush
	level.scr_anim["woods"]["apc_crush"] = %ch_khe_E2_tank_crush_guy01;
	level.scr_anim["hudson"]["apc_crush"] = %ch_khe_E2_tank_crush_guy02;		

	//e3 dead gunner
	level.scr_anim["dead_mg"]["shirtless_dead_mg"] = %ch_khe_e3_redshirt_turret_death_guy01;
	addNotetrack_customFunction("dead_mg", "head_shot", ::headshot_guy, "shirtless_dead_mg");


	//e3 nva crawling and burning
	level.scr_anim["fougasse_vic_0"]["fougasse_crawl"] = %ch_khe_E3_nvablowup_close_nva01;

	//e3 woods detonates mines
	level.scr_anim["woods"]["detonate_drum"] = %ch_khe_E3_woodsDetonates_woods;
	addNotetrack_customFunction("woods", "boom", ::woods_detonates, "detonate_drum");	

	//e3 pickup china lake
	level.scr_anim["woods"]["crazy_mg"][0] = %ch_khe_E3_woodsMG_woods;
	level.scr_anim["woods"]["mg_assist"] = %ch_khe_E3_woodsassist_woods;
	addNotetrack_customFunction("woods", "fire", ::woods_fires_mg, "crazy_mg");
	addNotetrack_customFunction("woods", "fire", ::woods_fires_mg, "mg_assist");	
	//audio
	addNotetrack_customFunction("woods", "fire_audio_on", ::m60_audio_start, "crazy_mg");
	addNotetrack_customFunction("woods", "fire_audio_off", ::m60_audio_stop, "crazy_mg");
	addNotetrack_customFunction("woods", "fire_audio_on", ::m60_audio_start, "mg_assist");	
	addNotetrack_customFunction("woods", "fire_audio_off", ::m60_audio_stop, "mg_assist");
	
	//level.scr_anim["china_lake"]["china_lake_loop"][0] = %ch_khe_E3_pickuplauncher_dead_guy01;
	//level.scr_anim["china_lake"]["pickup_china_lake"] = %ch_khe_E3_pickuplauncher_guy01;

	// e3 nva turret dive
	level.scr_anim["e_strength_enemy"]["strength_test_start"] = %ch_khe_E3_nvaturretDive_nva01;
	level.scr_anim["e_strength_enemy"]["strength_test_loop"][0] = %ch_khe_E3_nvaturretDive_choke_nva01;
	level.scr_anim["e_strength_enemy"]["strength_test_success"] = %ch_khe_E3_nvaturretDive_success_nva01;
	addNotetrack_customFunction("e_strength_enemy", "boom", ::nva_boom, "strength_test_success");	

	// event 4
	level.scr_anim["woods"]["improvise"] = %ch_khe_E4_timetoimprovise_woods;
	addNotetrack_customFunction("woods", "kick", ::woods_kick, "improvise");	

	level.scr_anim["generic"]["mental"][0] = %ch_khe_E4_redshirt_mental_guy01;

	level.scr_anim["hill_medic"]["death_b"] = %ch_khe_E4_redshirt_deathB_medic;
	level.scr_anim["hill_deadguy"]["death_b"] = %ch_khe_E4_redshirt_deathB_guy01;
	addNotetrack_customFunction("hill_medic", "death", ::headshot_guy, "death_b");	

	// Burning guys
	level.scr_anim["napalm_victim_1"]["burning_fate"] = %ai_flame_death_a;
	//level.scr_anim["napalm_victim_2"]["burning_fate"] = %ai_flame_death_b;
	//level.scr_anim["napalm_victim_3"]["burning_fate"] = %ai_flame_death_c;
	//level.scr_anim["napalm_victim_4"]["burning_fate"] = %ai_flame_death_d;

	// Hand to Hand
	level.scr_anim["h2h_guy_01"]["hand2hand_a"][0] = %ch_khe_e4_nva_us_hand2hand_a_guy01;
	level.scr_anim["h2h_guy_02"]["hand2hand_a"][0] = %ch_khe_e4_nva_us_hand2hand_a_guy02;
/*
	level.scr_anim["h2h_guy_01"]["hand2hand_b"][0] = %ch_khe_e4_nva_us_hand2hand_b_guy01;
	addNotetrack_customFunction("h2h_guy_01", "kill_shot", ::hand_2_hand_kill_shot, "hand2hand_b");

	level.scr_anim["h2h_guy_02"]["hand2hand_b"][0] = %ch_khe_e4_nva_us_hand2hand_b_guy02;
	level.scr_anim["hudson"]["hand2hand_b"][0] = %ch_khe_e4_nva_us_hand2hand_b_guy02;
	addNotetrack_customFunction("h2h_guy_02", "kill_shot", ::hand_2_hand_done, "hand2hand_b");
	addNotetrack_customFunction("hudson", "kill_shot", ::hand_2_hand_done, "hand2hand_b");
*/

	level.scr_anim["h2h_hudson_nva"]["h2h_hudson"] = %ch_khe_e2_hudson_melee_nva;
	level.scr_anim["hudson"]["h2h_hudson"] = %ch_khe_e2_hudson_melee_hudson;
	addNotetrack_customFunction("hudson", "kill_window_end", ::check_nva_alive, "h2h_hudson");	

	level.scr_anim["h2h_guy_01"]["hand2hand_c"][0] = %ch_khe_e4_nva_us_hand2hand_c_guy01;
	level.scr_anim["h2h_guy_02"]["hand2hand_c"][0] = %ch_khe_e4_nva_us_hand2hand_c_guy02;

	//helicopter passenger anims for scripted models
	level.scr_anim["huey_pilot_1"]["huey_idle"][0] = %ai_huey_pilot1_idle_loop1;
	level.scr_anim["huey_pilot_2"]["huey_idle"][0] = %ai_huey_pilot2_idle_loop1;
	level.scr_anim["gunner_pilot_1"]["huey_idle"][0] = %ai_huey_gunner1;
	level.scr_anim["gunner_pilot_2"]["huey_idle"][0] = %ai_huey_gunner2;

	//e3 trap door
	level.scr_anim["marine_trap_door"]["open_trap_door"] = %ch_khe_e3_woods_trap_door_guy01;
	addNotetrack_customFunction("marine_trap_door", "door_ready", ::hatch_notify_heroes, "open_trap_door");

	//e4 marine death arm
	level.scr_anim["marine_death"]["marine_missing_arm"] = %ch_khe_e4_redshirt_death_a_guy01;

	//e4 woods gun jam
	//level.scr_anim["gun_jam_nva"]["gun_jam"] = %ch_khe_E4B_woods_gun_jam_nva;
	level.scr_anim["gun_jam_marine"]["gun_jam_start"] = %ch_khe_E4B_woods_gun_jam_redshirt;
	//level.scr_anim["woods"]["gun_jam"] = %ch_khe_E4B_woods_gun_jam_woods;

	level.scr_anim["gun_jam_nva"]["gun_jam_start"] = %ch_khe_E4B_woods_gun_jam_start_nva;
	level.scr_anim["woods"]["gun_jam_start"] = %ch_khe_E4B_woods_gun_jam_start_woods;

	level.scr_anim["gun_jam_nva"]["gun_jam_success"] = %ch_khe_E4B_woods_gun_jam_success_nva;
	level.scr_anim["woods"]["gun_jam_success"] = %ch_khe_E4B_woods_gun_jam_success_woods;

	level.scr_anim["gun_jam_nva"]["gun_jam_fail"] = %ch_khe_E4B_woods_gun_jam_fail_nva;
	level.scr_anim["woods"]["gun_jam_fail"] = %ch_khe_E4B_woods_gun_jam_fail_woods;

	//e4 hilltop briefing
	level.scr_anim["e4_redshirt"]["briefing_loop"][0] = %ch_khe_e4_sgt_reports_loop_guy01;
	level.scr_anim["e4_redshirt"]["briefing"] = %ch_khe_e4_sgt_reports_guy01;
	level.scr_anim["woods"]["briefing"] = %ch_khe_e4_sgt_reports_woods;

	//e4 friendly fire
	level.scr_anim["marine_yell"]["yell_at_huey"] = %ch_khe_e4_friendly_wave_guy01;

	//e4b hilltop melee
	level.scr_anim["h2h_guy_01"]["hilltop_h2h_a"] = %ch_khe_e4_marine_clash_guy01;
	level.scr_anim["h2h_guy_02"]["hilltop_h2h_a"] = %ch_khe_e4_marine_clash_nva01;		

	level.scr_anim["h2h_guy_01"]["hilltop_h2h_b"] = %ch_khe_e4_marine_clash_guy02;
	level.scr_anim["h2h_guy_02"]["hilltop_h2h_b"] = %ch_khe_e4_marine_clash_nva02;		

	level.scr_anim["hudson"]["hilltop_h2h_c"] = %ch_khe_e4_marine_clash_guy03;
	level.scr_anim["h2h_guy_02"]["hilltop_h2h_c"] = %ch_khe_e4_marine_clash_nva03;		

	//e5 woods tired
	level.scr_anim["woods"]["bandana_remove"] = %ch_khe_e5_woods_ruffled_woods;

	//e5 bunker rubble
	level.scr_anim["buddy_rubble_0"]["e5_rubble_start"] = %ch_khe_e4_free_from_rubble_a_start_guy01;
	level.scr_anim["buddy_rubble_1"]["e5_rubble_start"] = %ch_khe_e4_free_from_rubble_a_start_guy02;
	level.scr_anim["buddy_rubble_0"]["e5_rubble_loop"][0] = %ch_khe_e4_free_from_rubble_a_loop_guy01;
	level.scr_anim["buddy_rubble_1"]["e5_rubble_loop"][0] = %ch_khe_e4_free_from_rubble_a_loop_guy02;
	level.scr_anim["solo_rubble"]["rubble_dude"] = %ch_khe_e4_free_from_rubble_b_start_guy01;
	level.scr_anim["solo_rubble"]["rubble_dude_loop"][0] = %ch_khe_e4_free_from_rubble_b_loop_guy01;

	//coughing
	level.scr_anim["marine_cough"]["coughing"][0] = %ch_khe_E4_heavy_coughing_loop;
	
	//bowman reveal

	level.scr_anim["bowman"]["reveal_loop"][0] = %ch_khe_e5_bowman_reveal_loop_bowman;
	level.scr_anim["bowman"]["reveal"] = %ch_khe_e5_bowman_reveal_bowman;
	
	level.scr_anim["hudson"]["reveal_loop"][0] = %ch_khe_e5_bowman_reveal_loop_hudson;
	level.scr_anim["hudson"]["reveal"] = %ch_khe_e5_bowman_reveal_hudson;
	addNotetrack_customFunction("hudson", "start_fade", ::level_fade_to_black, "reveal");	
	
	level.scr_anim["woods"]["reveal_loop"][0] = %ch_khe_e5_bowman_reveal_loop_woods;
	level.scr_anim["woods"]["reveal"] = %ch_khe_e5_bowman_reveal_woods;
}


precache_scripted_vo()
{
	//flashback lines
	level.scr_sound["mason"]["flashback_01"] = "vox_khe1_s01_700A_inte";//Hudson was down and Khe Sanh was under siege. But like with Weaver, you risked your life to save him.
	level.scr_sound["mason"]["flashback_02"] = "vox_khe1_s01_701A_maso";//Hudson was a fucking ice cube, but that's why I liked the bastard.
	level.scr_sound["mason"]["flashback_03"] = "vox_khe1_s01_702A_inte"; //Your mission priority was to get to Hue City, but you all stayed behind to defend Khe Sanh. That wasn't your objective.
	level.scr_sound["mason"]["flashback_04"] = "vox_khe1_s01_703A_maso"; //You obviously didn't know Woods. He knew they needed our help. No decision to make.

	// event 1 c trench walk
    level.scr_sound["trench_mortarsgt"]["fortify"] = "vox_khe1_s03_023A_mar1"; //Get that line fortified!
    level.scr_sound["trench_mortarsgt"]["fire_team"] = "vox_khe1_s03_024A_mar1"; //I want fire teams positioned at five yard intervals!
    level.scr_sound["trench_mortarsgt"]["move"] = "vox_khe1_s03_025A_mar1"; //Move! Move! Move!
    level.scr_sound["trench_mortarsgt"]["take_cover"] = "vox_khe1_s03_025B_mar1"; //Take cover move move

	level.scr_sound["mason"]["post_carry"] = "vox_khe1_s03_026A_maso"; //We gotta move, Hudson!
	level.scr_sound["hudson"]["post_carry"] = "vox_khe1_s03_027A_huds"; //I'm with you!

	//event 1 runway crash TOO LOW
	level.scr_sound["runway_redshirt"]["runway_0"] = "vox_khe1_s02_015A_red1"; //Clear the runway! Clear the runway!
	level.scr_sound["runway_redshirt"]["runway_1"] = "vox_khe1_s02_016A_red1"; //INCOMING!!!

	// EVENT 4 DOWNHILL
    level.scr_sound["woods"]["e4_bastards"] = "VOX_KHE1_S04_112A_WOOD"; //"Shit...Bastards ain't lettin' up!"
    level.scr_sound["woods"]["e4_move"] = "VOX_KHE1_S04_113A_WOOD"; //"Move!"
	level.scr_sound["woods"]["e4_perimeter"] = "vox_khe1_s04_061A_wood"; //They're breaching the perimeter!

	level.scr_sound["woods"]["e4_move_up"] = "VOX_KHE1_S04_121A_WOOD"; //"Move up!"
	level.scr_sound["woods"]["e4_flank"] = "VOX_KHE1_S04_122A_WOOD"; //"Grab what you need, we'll hit their left flank."
	level.scr_sound["woods"]["e4_ready"] = "VOX_KHE1_S04_123A_WOOD"; //"Marines - be ready to move up."

	level.scr_sound["woods"]["e4_rip_em"] = "VOX_KHE1_S04_124A_WOOD"; //"Rip 'em up!!"
    level.scr_sound["woods"]["e4_fugassi"] = "vox_khe1_s04_062A_wood"; //No fugassi line to hold 'em back this time.

    level.scr_sound["woods"]["e4_light_up"] = "vox_khe1_s04_065A_wood"; //Let's light these bastards up!
    level.scr_sound["woods"]["e4_do_it"] = "vox_khe1_s04_066A_wood"; //Now  MASON! Do it!

	//e4 transition to e4b
	level.scr_sound["e4_redshirt_trans"]["4b_push_line"] = "vox_khe1_s04_126A_mar1"; //They're making another push - South East side!
	level.scr_sound["woods"]["e4_hold_em"] = "VOX_KHE1_S04_125A_WOOD"; //"That should hold 'em"

	//e2 apc crush encouragement
	level.scr_sound["woods"]["apc_encourage"] = "VOX_KHE1_S03_035A_WOOD";//"Come on, Mason!"
	level.scr_sound["woods"]["apc_encourage_b"] = "VOX_KHE1_S03_033A_WOOD";//"Come on!"

	//e3 cover me
	level.scr_sound["woods"]["cover_me"] = "VOX_KHE1_S01_507_WOOD";//"Give me cover!"

	//e3 trans to detonator 2
	level.scr_sound["woods"]["burn_em"] = "vox_khe1_s04_148A_wood"; //Burn 'em, Mason!

	//fougasse event player one
	//wait lines
	level.scr_sound["woods"]["fougasse_one_start"] = "VOX_KHE1_S04_044A_WOOD";//"Here they come, Mason."
	
	level.scr_sound["woods"]["fougasse_one_wait"] = "VOX_KHE1_S04_045A_WOOD";//"Wait for it..."
	level.scr_sound["woods"]["fougasse_two_wait"] = "VOX_KHE1_S04_046A_WOOD";//"Not yet."

	level.scr_sound["woods"]["fougasse_one_blow"] = "VOX_KHE1_S04_047A_WOOD";//"NOW!"
	level.scr_sound["woods"]["fougasse_two_blow"] = "VOX_KHE1_S04_048A_WOOD";//"Blow it Mason!"

	level.scr_sound["woods"]["fougasse_one_fail"] = "VOX_KHE1_S04_050A_WOOD";//"Shit, too early! They're still coming!"
	level.scr_sound["woods"]["fougasse_two_fail"] = "VOX_KHE1_S04_051A_WOOD";//"Too late, Mason! They're almost on us!"

	level.scr_sound["woods"]["drum_one_recover"] = "vox_khe1_s04_037A_wood"; //This shit ain't over yet... Let's go!
	level.scr_sound["woods"]["drum_two_recover"] = "vox_khe1_s02_103A_wood"; //Pull back! Pull back!

	level.scr_sound["woods"]["fougasse_stragglers"] = "VOX_KHE1_S04_049A_WOOD";//"Pick off the stragglers!"
	level.scr_sound["woods"]["fougasse_good"] = "vox_khe1_s04_158A_wood"; //Good kill!

	//hold the line
	level.scr_sound["woods"]["hold_the_line"] = "VOX_KHE1_S99_904A_WOOD";//"Hold this position!"
	
	//e3 woods trans to tank
	level.scr_sound["woods"]["tank_start"] = "dds_woo_thrt_lm_tanks_00";//"Tanks on the way!"
	level.scr_sound["woods"]["tank_intro"] = "VOX_KHE1_S04_104A_WOOD";//"Shit... We got armor moving up - Russian T-55s!"
	level.scr_sound["woods"]["tank_intro_china"] = "VOX_KHE1_S04_105A_WOOD";//"That China lake ain't gonna cut it!"
	level.scr_sound["woods"]["tank_intro_china_b"] = "VOX_KHE1_S04_106A_WOOD";//"WOODS: ^7We need something bigger."
	level.scr_sound["woods"]["tank_intro_follow"] = "VOX_KHE1_S04_107A_WOOD";//"On me..."

	level.scr_sound["woods"]["get_on_tow"] = "VOX_KHE1_S04_157A_WOOD";//"Get on that TOW."

	level.scr_sound["woods"]["nva_bold"] = "VOX_KHE1_S04_108A_WOOD";//"Soviet Armor... No wonder the NVA's gettin' bold."
	level.scr_sound["woods"]["get_on_law"] = "VOX_KHE1_S04_109A_WOOD";//"Here - this LAW rocket will burst 'em wide open."
	level.scr_sound["woods"]["law_nag"] = "VOX_KHE1_S99_905A_WOOD";//"Grab that LAW, Mason!"
	
	//finale VO
	level.scr_sound["phantom"]["red_rider_intro"] = "VOX_KHE1_S99_367A_F4P1_f";//"Roger that, Big 6. Red Rider is inbound. 2 minutes. Please stand by."
	level.scr_sound["woods"]["out_of_time"] = "VOX_KHE1_S04_160A_WOOD";//"We're out of time."
	
	level.scr_sound["phantom"]["red_rider_headdown"] = "VOX_KHE1_S99_368A_F4P1_f";//"Be advised, Red Rider on station. Keep your head down."
	
	level.scr_sound["phantom"]["red_rider_ontarget"] = "VOX_KHE1_S99_369A_F4P1_f";//"High explosive ordinance on target. Have a nice day. Red Rider out."
	
	level.scr_sound["woods"]["woods_hell_yes"] = "VOX_KHE1_S04_161A_WOOD";//"Hell yes!"
	level.scr_sound["woods"]["woods_fuckin_nam"] = "VOX_KHE1_S04_162A_WOOD";//"The fuckin' Nam, baby."

	//e4 downhill vo
	level.scr_sound["woods"]["gear_up"] = "VOX_KHE1_S99_908A_WOOD";//"Alright gear up!"

	//e4b start and mid
	//start
	level.scr_sound["hudson"]["HQ_rush"] = "vox_khe1_s04_127A_huds"; //Toward the HQ!
	level.scr_sound["woods"]["up_hill"] = "vox_khe1_s04_128A_wood"; //Get up the hill!

	//e4b middle lines
	level.scr_sound["woods"]["head_down"] = "vox_khe1_s04_130A_wood"; //Keep your heads down!
	level.scr_sound["hudson"]["move_up"] = "vox_khe1_s04_131A_huds"; //Move up!

	level.scr_sound["woods"]["incoming_yell"] = "vox_khe1_s04_132A_wood"; //INCOMING!!!
	level.scr_sound["hudson"]["own_mortar"] = "vox_khe1_s04_133A_huds"; //That's our own mortars! Do they even know were here?

	//e4b line 3
	level.scr_sound["woods"]["foxhole"] = "vox_khe1_s04_129A_wood"; //Use the foxholes for cover!

	//friendly fire vo
	level.scr_sound["marine_yell"]["yell_at_huey"] = "vox_khe1_s04_404A_red1"; //Shovel! Two Five actual! Cease fire! Cease fire!

	//e4b hilltop
	level.scr_sound["woods"]["keep_pushin"] = "vox_khe1_s04_135A_wood"; //Keep pushin'!

	//E5 Lines:
	//redshirt jeep guy getting into jeep
	level.scr_sound["e5_start_radio"]["repeat"] = "vox_khe1_s99_358A_red3"; //Repeat your last please.
	level.scr_sound["e5_start_radio"]["e5_radio_more_nva"] = "vox_khe1_s05_405A_red3_f"; //More NVA moving in!... Inafantry and armor!
	level.scr_sound["e5_start_radio"]["e5_radio_division"] = "vox_khe1_s99_363A_red4"; //They must have a fucking division hid out there.
	level.scr_sound["e5_b52_status"]["grid_0"] = "vox_khe1_s99_387A_b52r"; //Grid pattern - Delta-five-seven and Delta-five-nine.
	level.scr_sound["e5_b52_status"]["grid_clear"] = "vox_khe1_s99_379A_b52r"; //Clear out from those attack sectors please.
	level.scr_sound["e5_b52_status"]["grid_pattern"] = "vox_khe1_s99_388A_b52r"; //Grid pattern - Bravo-four-one - Check that - Bravo-four-eight and ten.
	level.scr_sound["e5_b52_status"]["grid_complete"] = "vox_khe1_s99_380A_b52r"; //Arc Light sector selection complete.

	//woods and hudson run forward
	level.scr_sound["hudson"]["hudson_bravado"] = "vox_khe1_s04_145A_huds"; //I'll draw their fire!
	level.scr_sound["woods"]["hudson_bravado"] = "vox_khe1_s04_146A_wood"; //And I thought he was a pussy...

	//activate radio vo phantoms
	level.scr_sound["woods"]["radio_phantoms"] = "vox_khe1_s99_916A_wood"; //Mason! Call in the Phantoms!
	level.scr_sound["woods"]["radio_napalm_strike"] = "vox_khe1_s99_907A_wood"; //Get on that Radio mason, and call in a napalm strike!
	level.scr_sound["mason"]["mason_call_napalm"] = "vox_khe1_s99_917A_maso"; //VF 143! Authorization Sierra Oscar Golf X-ray. Priority one ordinance on my command!

	//ambient napalm VO
	level.scr_sound["amb_phantom_vo"]["strike_0"] = "vox_khe1_s99_918A_b52r_f"; //Roger that, X-ray. VF 143 Standing by.
	level.scr_sound["amb_phantom_vo"]["strike_1"] = "vox_khe1_s99_919A_b52r_f"; //Affirmative X-ray. Engaging.
	level.scr_sound["amb_phantom_vo"]["strike_2"] = "vox_khe1_s99_920A_b52r_f"; //Coordinates received.  Keep your heads down, X-ray.
	level.scr_sound["amb_phantom_vo"]["strike_3"] = "vox_khe1_s99_921A_b52r_f"; //Understood X-ray. Commencing run.
	level.scr_sound["amb_phantom_vo"]["strike_4"] = "vox_khe1_s99_922A_b52r_f"; //VF 143. Beginning bomb run.
	level.scr_sound["amb_phantom_vo"]["strike_5"] = "vox_khe1_s99_923A_b52r_f"; //Roger X-ray. Coming in for a strafing run.
	level.scr_sound["amb_phantom_vo"]["strike_6"] = "vox_khe1_s99_924A_b52r_f"; //Understood. Stand by, X-ray.
	level.scr_sound["amb_phantom_vo"]["strike_7"] = "vox_khe1_s99_925A_b52r_f"; //VF 143 inbound.
	level.scr_sound["amb_phantom_vo"]["strike_8"] = "vox_khe1_s99_926A_b52r_f"; //Roger X-ray - Targetting Sector.

	//approach to tow jeep
	level.scr_sound["woods"]["jeep_go"] = "vox_khe1_s99_937A_wood";//On me.
	level.scr_sound["woods"]["jeep_approach"] = "vox_khe1_s99_940A_wood"; //Now that's what I'm talkin' about!
	level.scr_sound["woods"]["jeep_approach_tow"] = "vox_khe1_s04_407A_wood"; //Jump in back - get on the TOW.

	//enter tow jeep
	level.scr_sound["mason"]["enter_tow"] = "vox_khe1_s04_408A_maso"; //This thing's built like a tank!
	level.scr_sound["woods"]["enter_tow_reply"] = "vox_khe1_s04_409A_wood"; //Yeah... But a damn sight more maneuverable!

	//end tow jeep event
	level.scr_sound["hudson"]["tow_jeep_ended"] = "vox_khe1_s04_151A_huds"; //It's over...
	level.scr_sound["woods"]["tow_jeep_ended"] = "vox_khe1_s04_152A_wood"; //No... This is the start of somethin' else...
	level.scr_sound["woods"]["tow_jeep_ended_b"] = "vox_khe1_s04_153A_wood"; //...They'll be back.

	//e5 
	level.scr_sound["woods"]["e5_go_bunker"] = "vox_khe1_s99_927A_wood"; //Get to that bunker!
	level.scr_sound["woods"]["e5_tanks_start"] = "vox_khe1_s99_928A_wood"; //Gotta take out the tanks!
	level.scr_sound["woods"]["air_strike_react"] = "vox_khe1_s99_909A_wood"; //Nice!
	
	//go to law
	level.scr_sound["woods"]["e5_go_law"] = "vox_khe1_s01_503_wood"; //Heads UP!

	//tank nag lines
	level.scr_sound["woods"]["tank_nag_0"] = "vox_khe1_s99_929A_wood"; //Focus on the tanks!
	level.scr_sound["woods"]["tank_nag_1"] = "vox_khe1_s99_930A_wood"; //Deal with the tanks!
	level.scr_sound["woods"]["tank_nag_2"] = "vox_khe1_s99_931A_wood"; //The tanks, Mason!
	level.scr_sound["woods"]["tank_nag_3"] = "vox_khe1_s99_932A_wood"; //The tanks - You gotta hit 'em, Mason!
	level.scr_sound["woods"]["tank_nag_4"] = "vox_khe1_s99_933A_wood"; //Take out those fucking tanks!
	level.scr_sound["woods"]["tank_nag_5"] = "vox_khe1_s99_934A_wood"; //Those tanks ain't going anywhere!

	//tank hit lines
	level.scr_sound["woods"]["tank_hit_0"] = "vox_khe1_s99_910A_wood"; //Good hit!
	level.scr_sound["woods"]["tank_hit_1"] = "vox_khe1_s99_911A_wood"; //You nailed 'em!
	level.scr_sound["woods"]["tank_hit_2"] = "vox_khe1_s99_912A_wood"; //Keep it up!
	level.scr_sound["woods"]["tank_hit_3"] = "vox_khe1_s99_913A_wood"; //They felt that one!
	level.scr_sound["woods"]["tank_hit_4"] = "vox_khe1_s99_914A_wood"; //Direct hit!
	level.scr_sound["woods"]["tank_hit_5"] = "vox_khe1_s99_915A_wood"; //You got him!
	

	//e5 announce second to last wave
	level.scr_sound["woods"]["shit_tanks"] = "vox_khe1_s99_935A_wood"; //Shit! More tanks...

	//e5 transition to final tank wave
	level.scr_sound["woods"]["trans_final_wave"] = "vox_khe1_s99_936A_wood"; //It ain't over yet.

	//e5 steer tow
	level.scr_sound["woods"]["steer_tow"] = "vox_khe1_s99_906A_wood"; //Use the controls to steer the TOW missle!


	//AMBIENT RADIOS************************************************************
	//e1c runners when picking up hudson (TOO LOW) 
	level.scr_sound["e1c_amb_vo"]["go_go"] = "vox_khe1_s01_500_us0"; //Go Go!
	level.scr_sound["e1c_amb_vo"]["quick"] = "vox_khe1_s01_501_us0"; //Quick, do it!
	level.scr_sound["e1c_pretrench_vo"]["status_0"] = "vox_khe1_s99_342A_red3"; //Jesus - lots of mortars left side of the runway.
	level.scr_sound["e1c_pretrench_vo"]["status_1"] = "vox_khe1_s99_343A_red4"; //Jeeps and trucks to the North.
	level.scr_sound["e1c_pretrench_vo"]["status_2"] = "vox_khe1_s99_344A_red3"; //He said they spotted some enemy tanks. Couple clicks NorthEast.
	level.scr_sound["e1c_pretrench_vo"]["status_3"] = "vox_khe1_s99_348A_red3"; //Fuckin' bastards.
	
	//E4 Tunnel radio from e3 NEED TO RADIO FUTZ
	level.scr_sound["b52_radio"]["radio_line_0"] = "vox_khe1_s99_385A_b52r"; //Grid pattern - Alpha-one-two and Alpha-one-six.
	level.scr_sound["b52_radio"]["radio_line_1"] = "vox_khe1_s99_371A_b52r_f"; //Arc Light, 10 minutes out.
	level.scr_sound["e4_radio"]["radio_line_0"] = "vox_khe1_s99_307A_red4"; //One-seven, this is Red Rider. Over.
	level.scr_sound["e4_radio"]["radio_line_1"] = "vox_khe1_s99_311A_red4"; //What's your status please?
	level.scr_sound["e4_radio"]["radio_line_2"] = "vox_khe1_s99_361A_red4"; //Low on fuel. Inbound 2 minutes.
	level.scr_sound["e4_radio"]["radio_line_3"] = "vox_khe1_s99_312A_red3"; //Stand fast, two-nine. You're covered. //cut "two-nine"
	level.scr_sound["e4_radio"]["radio_line_4"] = "vox_khe1_s99_308A_red3"; //Negative, I'm on final right now.

	//HERO HUEY event 2-3 huey  NEED TO RADIO FUTZ
	level.scr_sound["hero_huey"]["line_0"] = "vox_khe1_s99_336A_red3"; //We're on it, six.
	level.scr_sound["hero_huey"]["line_1"] = "vox_khe1_s99_366A_red3"; //On station, six. Standing by.
	level.scr_sound["hero_huey"]["line_2"] = "vox_khe1_s99_332A_red3"; //Adjust your fire!
	level.scr_sound["hero_huey"]["line_3"] = "vox_khe1_s99_359A_red4"; //Incoming!
	level.scr_sound["hero_huey"]["line_4"] = "vox_khe1_s99_304A_red3"; //Jesus Christ!
	level.scr_sound["hero_huey"]["line_5"] = "vox_khe1_s99_370A_red3"; //God damn it.
	level.scr_sound["hero_huey"]["line_6"] = "vox_khe1_s99_309A_red4"; //May day, may day.
	
	//E4 Radio inside weapon cache //e4_weapon_cache_radio NEED TO RADIO FUTZ
	level.scr_sound["b52_radio"]["wep_cache_radio_0"] = "vox_khe1_s99_386A_b52r"; //Grid pattern - Charlie-three-three and Charlie-three-one.
	level.scr_sound["b52_radio"]["wep_cache_radio_1"] = "vox_khe1_s99_377A_b52r"; //Roger that, Arc Light copies.
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_2"] = "vox_khe1_s99_306A_red3"; //Artillery fire targetting the runway, six.
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_3"] = "vox_khe1_s99_346A_red3"; //Hercules on fire. Far side of the runway.
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_4"] = "vox_khe1_s99_347A_red4"; //Six, you copy my last?	
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_5"] = "vox_khe1_s99_368A_red3"; //Say again.
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_6"] = "vox_khe1_s99_330A_red3"; //Need you to move about a click West. Meet you there.
	level.scr_sound["e4_radio_weps"]["wep_cache_radio_7"] = "vox_khe1_s99_302A_red3"; //I'm not receiving your signal.

	//e4 phantom lines
	//E4 phantom drop  NEED TO RADIO FUTZ
	level.scr_sound["red_rider"]["line_drop_0"] = "vox_khe1_s99_300A_red3"; //Six. Red Rider.
	level.scr_sound["red_rider"]["line_drop_1"] = "vox_khe1_s99_301A_red4"; //What's your position?
	level.scr_sound["red_rider"]["line_drop_2"] = "vox_khe1_s99_345A_red4"; //Just hang tight.
	level.scr_sound["red_rider"]["line_drop_3"] = "vox_khe1_s99_357A_red4"; //OK, standing by.
	level.scr_sound["red_rider"]["line_drop_4"] = "vox_khe1_s99_335A_red4"; //Go, go, go.

	//E4B Up Hill Chatter
	level.scr_sound["woods"]["rpg_line_woods"] = "vox_khe1_s04_147A_wood"; //RPG!
	level.scr_sound["redshirt_rpg"]["rpg_line_0"] = "vox_khe1_s99_315A_red4"; //Anybody see that RPG?
	level.scr_sound["redshirt_rpg"]["rpg_line_1"] = "vox_khe1_s99_316A_red3"; //No, check the other side.
	level.scr_sound["redshirt_rpg"]["rpg_line_2"] = "vox_khe1_s99_317A_red4"; //Negative. Negative.

	//e4c first enter bunker
	level.scr_sound["post_jam_radio"]["line_0"] = "vox_khe1_s99_349A_red4"; //Do not. Repeat. Do not engage.
	level.scr_sound["post_jam_radio"]["line_1"] = "vox_khe1_s99_353A_red4"; //Fire. Put it right there.
	level.scr_sound["post_jam_radio"]["line_2"] = "vox_khe1_s99_338A_red3"; //I'm comin' around again, stay with me.
	level.scr_sound["post_jam_radio"]["line_3"] = "vox_khe1_s99_327A_red4"; //Belay that order. Get your ass out of there.
	level.scr_sound["post_jam_radio"]["line_4"] = "vox_khe1_s99_375A_b52r"; //Arc Light establishing orbit, please stand by.


	//E5 ARCLIGHT //lines played on player
	//first stop
	level.scr_sound["mason"]["stop_1_a"] = "vox_khe1_s99_392A_b52r"; //Roger that, six. Arc Light inbound per your mission.
	level.scr_sound["mason"]["stop_1_b"] = "vox_khe1_s99_372A_b52r_f"; //Arc Light, 5 minutes out.

	//second stop
	level.scr_sound["mason"]["stop_2_a"] = "vox_khe1_s99_373A_b52r_f"; //Arc Light, 2 minutes out.
	level.scr_sound["mason"]["stop_2_b"] = "vox_khe1_s99_376A_b52r"; //Say again, this is Arc Light.

	//final stop
	level.scr_sound["mason"]["stop_3_a"] = "vox_khe1_s99_374A_b52r_f"; //Arc Light, 1 minute out.
	level.scr_sound["mason"]["stop_3_b"] = "vox_khe1_s99_391A_b52r"; //Arc Light has established orbit.
	level.scr_sound["mason"]["stop_3_c"] = "vox_khe1_s99_382A_b52r"; //Arc Light is locked in and starting our bomb run.

	//finale
	level.scr_sound["arclight"]["radar"] = "vox_khe1_s99_390A_b52r"; //Roger that we are inbound
	level.scr_sound["arclight"]["whammo"] = "vox_khe1_s99_384A_b52r"; //Arc Light coordinates confirmed engaging

/*
	UNUSED SO FAR
	level.scr_sound["e4_radio"]["radio_line_3"] = "vox_khe1_s99_310A_red3"; //You're on final, three-seven.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_303A_red4"; //Not yet. How about you guys?
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_305A_red4"; //Five-five-oh-two. No, that's a negative.
	//in field
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_313A_red4"; //I can't see anything from back here.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_314A_red3"; //Ah, roger that.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_318A_red3"; //I'm talking to Arc Light right now. Wait one.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_319A_red4"; //I'm left. You're right. On your go.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_320A_red3"; //They're right behind you guys. South side.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_321A_red4"; //Move out!
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_322A_red3"; //Tracers. Tree line West of the runway.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_323A_red4"; //No, where? Say again please.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_324A_red3"; //Phantom took a couple of hits. He's OK I think.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_325A_red4"; //Roger. No we're OK.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_326A_red3"; //Three-one - can you see him from your position?
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_328A_red3"; //Negative, no one's there, six.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_329A_red4"; //That's a negative.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_331A_red4"; //Negative, no signal yet.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_333A_red4"; //Roger, seven-three.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_334A_red3"; //Where's the fucking Arc Light?
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_337A_red4"; //Ah, negative. 3 minutes out.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_339A_red4"; //Stand by, one-four. Who's that?
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_340A_red3"; //I think he's hit. Do you see him?
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_341A_red4"; //He's hit!
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_350A_red3"; //OK, roger that.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_351A_red4"; //Fire!
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_352A_red3"; //Gimme some smoke.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_354A_red3"; //Right there on that tree line. Burn 'em out.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_355A_red4"; //Negative.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_356A_red3"; //Ranger-three-seven, report in please.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_362A_red3"; //Clear the runway!
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_364A_red3"; //Three-oh-six. Say again please.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_365A_red4"; //RPG other side of the trench.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_367A_red4"; //Repeat your last please.
	level.scr_sound["US Soldier"]["anime"] = "vox_khe1_s99_369A_red4"; //I'm ready for you. OK, roger.
	//level.scr_sound["arclight"]["intor_0"] = "vox_khe1_s99_393A_b52r"; //All ships inbound. Arc Light out.
	level.scr_sound["B-52 Pilot"]["anime"] = "vox_khe1_s99_378A_b52r"; //Arc Light on station.
	level.scr_sound["B-52 Pilot"]["anime"] = "vox_khe1_s99_381A_b52r"; //Arc Light confirmed - starting our run.
	level.scr_sound["B-52 Pilot"]["anime"] = "vox_khe1_s99_383A_b52r"; //Arc Light is on the bomb run.

	////end and or phantom drops
	level.scr_sound["B-52 Pilot"]["anime"] = "vox_khe1_s99_389A_b52r"; //Arc Light confirmed. 30 seconds.
	level.scr_sound["B-52 Pilot"]["anime"] = "vox_khe1_s99_394A_b52r"; //All ships outbound. Arc Light out.
*/
}

ladder_land_dust_one(guy)
{
	//Exploder(230);
}

ladder_land_dust_two(guy)
{
	//Exploder(235);
}

tackle_end_window(guy)
{
	flag_set("tackle_end_window");
}

tackle_start_window(guy)
{
	flag_set("tackle_start_window");
}

// For when the player jumps out
player_jump(guy)
{
	level notify("player_jumped_out");
}

death_ragdoll(guy)
{
	guy notify("killanimscript");
	self stopanimscripted();
	self dodamage(self.health*10, self.origin);
}

player_kick(guy)
{
	level.player notify("player_kick_barrel");
}

woods_kick(guy)
{
	level notify("woods_kick_barrel");
	level notify("khesanh_barrel_01");
	ent = GetEnt("barrel_01_brush", "targetname");
	ent Delete();
}

nva_boom(guy)
{
	guy.noExplosiveDeathAnim = true;
	guy playsound ("wpn_grenade_explode");
	
	if( is_mature() && !is_gib_restricted_build() )
	{
		guy.force_gib = true; 
		guy.custom_gib_refs = [];
		guy.custom_gib_refs[0] = "no_legs";
	}

	guy StopAnimScripted();
	wait(0.05);
	guy MagicGrenadeManual(guy.origin + (0,0,25), (0, 0, 0), 0.0);
	
	if( is_mature() )
	{
		guy bloody_death();
	}
	
	guy StartRagdoll(1);
	guy LaunchRagdoll( (-50, 50, 25), "J_Spine4" );
}

woods_detonates(guy)
{
	//flag_init("woods_triggers_drums");
	flag_set("woods_triggers_drums");
}

heroic_death_nva(guy)
{
//	guy stop_magic_bullet_shield();
	if(is_mature())
	{
		//Exploder(140);
	}
//	guy playsound ("wpn_grenade_explode");	
	guy playsound ("exp_tow_missle");	
//	guy death_ragdoll(guy);
	level notify("heroic_death_nva");
}

start_sparks(guy)
{
	flag_set("e4_sparks");
}

stop_sparks(guy)
{
	flag_clear("e4_sparks");
}

c130_propeller_impact(guy)
{
	PlayFXOnTag(level._effect["fx_ks_c130_crash_propeller"], level.c130_crash, "tag_passenger");
}

c130_wing_impact(guy)
{
	PlayFXOnTag(level._effect["fx_ks_c130_crash_wing"], level.c130_crash, "tag_guy0");
}

/*
crash_fail(guy)
{
	if (!flag("jeep_crash_swerve"))
	{
		flag_set("jeep_crash_fail");
	}
}
*/

/*
hand_2_hand_kill_shot(guy)
{
	if (IsDefined(guy.lost_hand_2_hand) && guy.lost_hand_2_hand == true)
	{
		//guy death_ragdoll(guy);
		guy ragdoll_death();
	}
}

hand_2_hand_done(guy)
{
	if (IsDefined(guy.won_hand_2_hand) && guy.won_hand_2_hand == true)
	{
		guy notify("killanimscript");
	}
}
*/

start_hilltop_melee(guy)
{
	flag_set("hilltop_melee_start");
}

level_fade_to_black(guy)
{
	level thread maps\khe_sanh_util::custom_fade_screen_out("black", 0.25);
}

set_allow_death(guy)
{
	guy stop_magic_bullet_shield();
	guy.allowdeath = true;
}

fire_apc_gun(guy)
{
	//tag_flash_gunner1
	turret_org = guy GetTagOrigin("tag_flash_gunner4");
	turret_ang = guy GetTagAngles("tag_flash_gunner4");
	end_pt = turret_org + AnglesToForward(turret_ang) * 200;

	MagicBullet("apc_m113_maingun", turret_org, end_pt);
	PlayFXOnTag(level._effect["fx_ks_m113_m2_eject"], guy, "tag_origin");
}

//had to make this custom because playing anims on apc will make the crush anims not align properly
fire_apc_gun_for_crush(guy)
{
	//tag_flash_gunner1
	turret_org = level.apc_actor GetTagOrigin("tag_flash_gunner4");
	turret_ang = level.apc_actor GetTagAngles("tag_flash_gunner4");
	end_pt = turret_org + AnglesToForward(turret_ang) * 200;

	MagicBullet("apc_m113_maingun", turret_org, end_pt);
	PlayFXOnTag(level._effect["fx_ks_m113_m2_eject"], level.apc_actor, "tag_origin");
}

heroic_nva_fire_gun(guy)
{
	gun_org = guy GetTagOrigin("tag_flash");
	gun_ang = guy GetTagAngles("tag_flash");
	end_pt = gun_org + AnglesToForward(gun_ang) * 200;

	MagicBullet("m16_sp", gun_org, end_pt);
}

heroic_nva_drop_wep(guy)
{
	level notify("hack_hudson_react");
	guy Detach(guy.my_weapon, "tag_weapon_right");
	//clear the name
	guy setlookattext("", &"");
}

hatch_notify_heroes(guy)
{
	level notify("hatch_move_heroes");
}

woods_fires_mg(guy)
{
	gun_org = level.mg_prop GetTagOrigin("tag_flash");
	gun_ang = level.mg_prop GetTagAngles("tag_flash");
	end_pt = gun_org + AnglesToForward(gun_ang) * 200;

	PlayFXOnTag(level._effect["fx_heavy_flash_base"], level.mg_prop, "tag_flash");
	MagicBullet("m60_bipod_stand_khesanh", gun_org, end_pt);
}

m60_audio_start(guy)
{
	guy playloopsound( "wpn_m60_turret_fire_loop_npc" );
}
m60_audio_stop(guy)
{
	guy stoploopsound();
	guy playsound( "wpn_m60_turret_fire_loop_ring_npc" );
}

drag_end(guy)
{
	level notify("drag_end_stop");
}


hilltop_shoot_window(guy)
{
	flag_set("hilltop_window_start");
}

dirt_edge_fx(guy)
{
	PlayFXOnTag(level._effect["fx_ks_trench_dirt_edge"], guy, "tag_origin");
}

c130_dlight(guy)
{
	PlayFXOnTag(level._effect["fx_ks_jeep_ride_glow"], level.player.body, "tag_camera");
	//set sun direction to something cheaper. 0.25
	maps\createart\khe_sanh_art::set_level_sun_default();
}

jeep_jump_gravel(guy)
{
	//gravel in face as you land after jeep crash
	//Exploder(110);
}

headshot_guy(guy)
{
	if(is_mature())
	{
		//guy thread maps\khe_sanh_util::bloody_death_fx("J_head", undefined);
		guy thread bloody_death( "head" );
	}
}

set_takedamage(guy)
{
	self.takedamage = true;
}

check_nva_alive(guy)
{
	if(!IsAlive(level.hudson_vic))
	{
		guy anim_stopanimscripted();
	}
	else
	{
		level.hudson_vic.health = 10000;
	}
}
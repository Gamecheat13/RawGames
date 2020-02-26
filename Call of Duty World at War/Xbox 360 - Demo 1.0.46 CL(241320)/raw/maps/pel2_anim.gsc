// peleliu 2 anim file

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\pel2_util;

#using_animtree ("generic_human");
main()
{
	
	mangroves();
	bunkers();
	dunes();
	admin();
	airfield();

	setup_geo_anims();
	
}


mangroves()
{
	
	// NOTETRACKS
	
	// corsair trap
	level thread addNotetrack_customFunction( "trap_react_redshirt_1", "ragdoll", ::mangrove_corsair_trap, "mangrove_trap" );	
	level thread addNotetrack_customFunction( "trap_react_redshirt_2", "ragdoll", ::mangrove_corsair_trap, "mangrove_trap" );	
	level thread addNotetrack_customFunction( "trap_react_redshirt_1", "detach", ::mangrove_drop_gun, "mangrove_trap" );
	// doing this on his ragdoll notetrack should be fine
	level thread addNotetrack_customFunction( "trap_react_redshirt_2", "ragdoll", ::mangrove_drop_gun, "mangrove_trap" );
	
	// mangrove grenades
	level thread addNotetrack_customFunction( "gren_throw_1_out", "gren_throw_1", ::mangrove_throw_grenade, "mangrove_grenades_out" );
	level thread addNotetrack_customFunction( "gren_throw_2_out", "gren_throw_2", ::mangrove_throw_grenade, "mangrove_grenades_out" );
	level thread addNotetrack_customFunction( "gren_throw_3_out", "gren_throw_3", ::mangrove_throw_grenade, "mangrove_grenades_out" );	
	
	level thread addNotetrack_attach( "gren_throw_1_out", "attach", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );
	level thread addNotetrack_attach( "gren_throw_2_out", "attach", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );
	level thread addNotetrack_attach( "gren_throw_3_out", "attach", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );		

	level thread addNotetrack_detach( "gren_throw_1_out", "gren_throw_1", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );
	level thread addNotetrack_detach( "gren_throw_2_out", "gren_throw_2", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );
	level thread addNotetrack_detach( "gren_throw_3_out", "gren_throw_3", "projectile_usa_mk2_grenade", "tag_weapon_left", "mangrove_grenades_out" );		

	addnotetrack_dialogue( "gren_throw_2_in", "dialog", "mangrove_grenades_in", "US_1_order_attack_infantry_05" );
	addnotetrack_dialogue( "gren_throw_2_out", "dialog", "mangrove_grenades_out", "US_1_order_move_follow_00" );
	addnotetrack_dialogue( "gren_throw_2_out", "dialog", "mangrove_grenades_out", "US_1_order_attack_infantry_04" );


	// ANIMS
	
	level.scr_anim["gren_throw_1_in"]["mangrove_grenades_in"] 			= %ch_peleliu2_grenadethrow_guy1_in;
	level.scr_anim["gren_throw_1_wait"]["mangrove_grenades_wait"][0]	= %ch_peleliu2_grenadethrow_guy1_wait;
	level.scr_anim["gren_throw_1_out"]["mangrove_grenades_out"] 		= %ch_peleliu2_grenadethrow_guy1_out;
	level.scr_anim["gren_throw_2_in"]["mangrove_grenades_in"] 			= %ch_peleliu2_grenadethrow_guy2_in;
	level.scr_anim["gren_throw_2_wait"]["mangrove_grenades_wait"][0]	= %ch_peleliu2_grenadethrow_guy2_wait;
	level.scr_anim["gren_throw_2_out"]["mangrove_grenades_out"] 		= %ch_peleliu2_grenadethrow_guy2_out;
	level.scr_anim["gren_throw_3_in"]["mangrove_grenades_in"] 			= %ch_peleliu2_grenadethrow_guy3_in;
	level.scr_anim["gren_throw_3_wait"]["mangrove_grenades_wait"][0]	= %ch_peleliu2_grenadethrow_guy3_wait;
	level.scr_anim["gren_throw_3_out"]["mangrove_grenades_out"] 		= %ch_peleliu2_grenadethrow_guy3_out;
	
	level.scr_anim["mangrove_trap"]["trap_idle_pilot"][0]				= %ch_peleliu2_mangrove_ambush_pilot_dead;	
	level.scr_anim["mangrove_trap"]["trap_death_pilot"]					= %ch_peleliu2_mangrove_ambush_pilot;	
	
	level.scr_anim["trap_react_redshirt_1"]["mangrove_trap"] 			= %ch_peleliu2_mangrove_ambush_redshirt;	
	level.scr_anim["trap_react_redshirt_2"]["mangrove_trap"] 			= %ch_peleliu2_mangrove_ambush_redshirt_1;	
	level.scr_anim["trap_react_redshirt_1_idle"]["mangrove_trap"][0]	= %ch_peleliu2_mangrove_ambush_redshirt_idle;	
	level.scr_anim["trap_react_redshirt_2_idle"]["mangrove_trap"][0]	= %ch_peleliu2_mangrove_ambush_redshirt_1_idle;	
	level.scr_anim["mangrove_trap"]["trap_react_redshirt_fall_down"] 	= %ch_peleliu2_mangrove_ambush_reaction_guy1;	
	level.scr_anim["mangrove_trap"]["trap_react_redshirt_kneel"] 		= %ch_peleliu2_mangrove_ambush_reaction_guy2;	

	level.scr_anim["generic"]["roebuck_run"] 							 = %ai_roebuck_run; 
				
	level.scr_anim["generic"]["run_CQB_F_search_v1"]					= %run_CQB_F_search_v1;
	level.scr_anim["generic"]["run_CQB_F_search_v2"]					= %run_CQB_F_search_v2;
	
	level.scr_anim["generic"]["CQB_run_2_crouch"]						= %run_2_crouch_F;
	level.scr_anim["generic"]["CQB_crouch_2_run"]						= %crouch_2run_F;

	level.scr_anim["generic"]["walk_CQB_F"]								= %walk_CQB_F;
	level.scr_anim["generic"]["walk_CQB_F_search_v1"]					= %walk_CQB_F_search_v1;
	level.scr_anim["generic"]["walk_CQB_F_search_v2"]					= %walk_CQB_F_search_v2;
	level.scr_anim["generic"]["walk_CQB_F_turn_L"]						= %walk_CQB_F_turn_L;
	level.scr_anim["generic"]["walk_CQB_F_turn_R"]						= %walk_CQB_F_turn_R;


	addnotetrack_dialogue( "trap_react_redshirt_1", "dialog", "mangrove_trap", "Pel2_IGD_008A_PGRI" );
	addnotetrack_dialogue( "trap_react_redshirt_1", "dialog", "mangrove_trap", "Pel2_IGD_009A_PGRI" );

	
	// VO
	
	level.scr_sound["vo"]["arrangements"] 								= "Pel2_IGD_500A_ROEB";
	level.scr_sound["vo"]["i_though_sullivan"] 							= "Pel2_IGD_501A_POLO";
	level.scr_sound["vo"]["we_let_our_guard"] 							= "Pel2_IGD_502A_ROEB";
	level.scr_sound["vo"]["so_what_now"] 								= "Pel2_IGD_000A_POLO";
	level.scr_sound["vo"]["tojos_gotta_tight"] 							= "Pel2_IGD_503A_ROEB";
	level.scr_sound["vo"]["5th_and_7th"] 								= "Pel2_IGD_504A_ROEB";
	level.scr_sound["vo"]["direct_route"] 								= "Pel2_IGD_001A_ROEB";
	level.scr_sound["vo"]["we_take_the_flank"] 							= "Pel2_IGD_003A_ROEB";
	level.scr_sound["vo"]["stay_sharp"] 								= "Pel2_IGD_004A_ROEB";


	level.scr_sound["vo"]["sarge!!!"] 									= "Pel2_IGD_005A_PGRI";
	level.scr_sound["vo"]["poor_bastard"] 								= "Pel2_IGD_006A_POLO";
	level.scr_sound["vo"]["fuselage_smoking"] 							= "Pel2_IGD_007B_ROEB";
	level.scr_sound["vo"]["shit!!!"] 									= "Pel2_IGD_010A_POLO";
	level.scr_sound["vo"]["booby_trap!!!"] 								= "Pel2_IGD_401A_ROEB";
	level.scr_sound["vo"]["ambush!!!"] 									= "Pel2_IGD_011A_ROEB";
	level.scr_sound["vo"]["were_surrounded"] 							= "Pel2_IGD_505A_ROEB";
	level.scr_sound["vo"]["it_was_a_trap"] 								= "Pel2_IGD_506A_POLO";
	level.scr_sound["vo"]["theyre_all_around"] 							= "Pel2_IGD_507A_POLO";
	level.scr_sound["vo"]["keep_em_back"] 								= "Pel2_IGD_508A_ROEB";
	level.scr_sound["vo"]["keep_it_tight"] 								= "Pel2_IGD_037A_ROEB";


	level.scr_sound["vo"]["everyone_ok"] 								= "Pel2_IGD_012A_ROEB";
	level.scr_sound["vo"]["only_just"] 									= "Pel2_IGD_013A_POLO";
	level.scr_sound["vo"]["cant_believe_theyd"] 						= "Pel2_IGD_014A_POLO";
	level.scr_sound["vo"]["fight_at_makin"] 							= "Pel2_IGD_015A_ROEB";
	level.scr_sound["vo"]["eyes_and_ears"] 								= "Pel2_IGD_016A_ROEB";
	
	level.scr_sound["vo"]["were_kinda_late"] 							= "Pel2_IGD_017A_POLO";
	level.scr_sound["vo"]["mgs_in_the_bunkers"] 						= "Pel2_IGD_018A_ROEB";
	level.scr_sound["vo"]["get_a_grenade_up"] 							= "Pel2_IGD_019A_ROEB";

}



bunkers()
{
	
	level thread addNotetrack_customFunction( "flamebunker", "fire_flames", ::flamebunker_death_shoot, "flamebunker_death" );
	level thread addNotetrack_customFunction( "flamebunker", "gunned_down", ::flamebunker_death_fx, "flamebunker_death" );
	
	level thread addNotetrack_customFunction( "bunkers", "ragdoll", ::mangrove_corsair_trap, "dazed_table" );	
	
	// ANIMS
	
	
	level.scr_anim["bunkers"]["dazed_table"] 							= %ch_pelelui2_dazed_table;
	
	level.scr_anim["bunkers"]["prone_anim_fast_a"] 						= %ch_grass_prone2run_fast;
	level.scr_anim["bunkers"]["prone_anim_fast_b"] 						= %ch_grass_prone2run_fast_b;
	level.scr_anim["bunkers"]["prone_anim_fast_c"] 						= %ch_grass_prone2run_fast_c;
	
	level.scr_anim["carry_box_host"]["carry_box"] 						= %ch_carrybox_tandem1_guy1;
	level.scr_anim["carry_box_helper"]["carry_box"] 					= %ch_carrybox_tandem1_guy2;
	level.scr_anim["carry_box_host"]["carry_box_host_death"] 			= %ch_carrybox_tandem1_guy1death;
	level.scr_anim["carry_box_helper"]["carry_box_helper_death"] 		= %ch_carrybox_tandem1_guy2death;
	
	level.scr_anim["flamebunker"]["flamebunker_a"] 						= %ch_peleliu2_flamebunker_a;
	level.scr_anim["flamebunker"]["flamebunker_b"] 						= %ch_peleliu2_flamebunker_b;
	level.scr_anim["flamebunker"]["flamebunker_death"] 					= %ch_peleliu2_flamedeath_a;
	level.scr_anim["flamebunker"]["flamebunker_death_loop"][0]			= %ch_peleliu2_flamedeath_a_loop;
	level.scr_anim["flamebunker"]["flamebunker_cover"][0]				= %ch_peleliu2_flamebunker_cover;
	
	// VO
		
	level.scr_sound["vo"]["everyone_move"] 								= "Pel2_IGD_020A_ROEB";
	level.scr_sound["vo"]["go_go"] 										= "Pel2_IGD_021A_ROEB";
	level.scr_sound["vo"]["take_out_those_mgs"] 						= "Pel2_IGD_022A_ROEB";
	level.scr_sound["vo"]["down_both_flanks"] 							= "Pel2_IGD_023A_ROEB";
	level.scr_sound["vo"]["carve_a_path"] 								= "Pel2_IGD_024A_ROEB";
	level.scr_sound["vo"]["flame_moving_up"] 							= "Pel2_IGD_025A_POLO";
	level.scr_sound["vo"]["give_em_covering"] 							= "Pel2_IGD_026A_ROEB";
	level.scr_sound["vo"]["stay_on_them"] 								= "Pel2_IGD_027A_ROEB";	

	level.scr_sound["vo"]["everyone_on_me"] 							= "Pel2_IGD_028A_ROEB";
	level.scr_sound["vo"]["suppressing_fire_on_mgs"] 					= "Pel2_IGD_029A_ROEB";
	level.scr_sound["vo"]["get_the_flamethrower"] 						= "Pel2_IGD_200A_ROEB";
	level.scr_sound["vo"]["use_that_flamethrower"]			 			= "Pel2_IGD_510A_ROEB";
	
	level.scr_sound["vo"]["burn_those_mgs"]			 					= "Pel2_IGD_201A_ROEB";
	level.scr_sound["vo"]["get_that_flamethrower_on"]			 		= "Pel2_IGD_509A_ROEB";
	level.scr_sound["vo"]["burn_em_out"]			 					= "Pel2_IGD_511A_ROEB";
	
	level.scr_sound["vo"]["hell_yeah_burn"] 							= "Pel2_IGD_030A_POLO";
	level.scr_sound["vo"]["its_gonna_blow"] 							= "Pel2_IGD_512A_ROEB";
	level.scr_sound["vo"]["get_outta_here"] 							= "Pel2_IGD_513A_ROEB";
	level.scr_sound["vo"]["okay_move_up"] 								= "Pel2_IGD_031A_ROEB";
	level.scr_sound["vo"]["good_work_marines"] 							= "Pel2_IGD_032A_ROEB";
	level.scr_sound["vo"]["half_a_mile_north"] 							= "Pel2_IGD_033A_ROEB";	
	
}



dunes()
{
	
	// VO
 
	level.scr_sound["vo"]["bastards_just_took"] 						= "Pel2_IGD_301A_PFOR";
	level.scr_sound["vo"]["every_plane_we_lose"] 						= "Pel2_IGD_302A_ROEB";
	level.scr_sound["vo"]["lets_pick_it_up"] 							= "Pel2_IGD_303A_ROEB";

	// tree guy & more grass guys
	level.scr_sound["vo"]["shit!"] 										= "Pel2_IGD_100A_POLO";
	level.scr_sound["vo"]["more_of_them"] 								= "Pel2_IGD_101A_POLO";
	level.scr_sound["vo"]["another_ambush"] 							= "Pel2_IGD_104A_POLO";
	level.scr_sound["vo"]["roebuck_theyre_in"] 							= "Pel2_IGD_105A_PFOR";
	level.scr_sound["vo"]["up_there_in_tree"] 							= "Pel2_IGD_106A_POLO";
	level.scr_sound["vo"]["over_there_mumble"] 							= "Pel2_IGD_108A_ROEB";
	level.scr_sound["vo"]["just_waiting_for_us"] 						= "Pel2_IGD_112A_PHIL";
	
}



admin()
{

	addnotetrack_dialogue( "berm", "dialogue", "berm_guy_1", "Pel2_IGD_041A_PLOG" );
	addnotetrack_dialogue( "berm", "dialogue", "berm_guy_2", "Pel2_IGD_042A_PGAS" );
	addnotetrack_dialogue( "berm", "dialogue", "berm_guy_1", "Pel2_IGD_043A_PLOG" );
	addnotetrack_dialogue( "berm", "dialogue", "berm_guy_2", "Pel2_IGD_044A_PGAS" );

	// ANIMS

	level.scr_anim["collectible"]["collectible_loop"][0]				= %ch_pel2_collectible;

	level.scr_anim["stairs"]["run_up_stairs"] 							= %ai_staircase_run_up_v1;
	
	level.scr_anim["stand"]["explode_back13"]							= %death_explosion_back13;
	level.scr_anim["stand"]["explode_stand_2"]							= %death_explosion_stand_b_v2;
	level.scr_anim["stand"]["explosion_forward"] 						= %death_explosion_stand_F_v2;
	level.scr_anim["stand"]["explosion_left"] 							= %death_explosion_stand_L_v3;
	level.scr_anim["stand"]["explosion_right"] 							= %death_explosion_stand_R_v2;
	
	level.scr_anim["berm"]["berm_guy_1"]								= %ch_peleliu2_berm_guy1;
	level.scr_anim["berm"]["berm_guy_1_idle"][0]						= %ch_peleliu2_berm_guy1_idle;
	level.scr_anim["berm"]["berm_guy_2"]								= %ch_peleliu2_berm_guy2;
	level.scr_anim["berm"]["berm_guy_2_idle"][0]						= %ch_peleliu2_berm_guy2_idle;

	level.scr_anim["berm"]["helmet_shot"] 								= %ch_peleliu2_helmet_shot;
	level.scr_anim["berm"]["helmet_loop_reach"] 						= %ch_peleliu2_helmet_loop;
	level.scr_anim["berm"]["helmet_loop"][0] 							= %ch_peleliu2_helmet_loop;

	level.scr_anim["berm"]["flamer_death"]	 							= %ai_flamethrower_death_b;
	level.scr_anim["berm"]["flamer_death_2"]	 						= %death_explosion_up10;
	

	// VO
	
	level.scr_sound["vo"]["holed_up"] 									= "Pel2_IGD_039A_ROEB";
	level.scr_sound["vo"]["whats_the_skinny"] 							= "Pel2_IGD_040A_ROEB";
	level.scr_sound["vo"]["roebuck_yeah"] 								= "Pel2_IGD_045A_ROEB";
	level.scr_sound["vo"]["supply_truck"] 								= "Pel2_IGD_046A_ROEB";
	level.scr_sound["vo"]["follow_me"] 									= "Pel2_IGD_047A_ROEB";
	level.scr_sound["vo"]["load_up_rifle_gren"] 						= "Pel2_IGD_048A_ROEB";
	level.scr_sound["vo"]["hell_yeah"] 									= "Pel2_IGD_049A_POLO";
	level.scr_sound["vo"]["move_into_building"] 						= "Pel2_IGD_050A_ROEB";
	level.scr_sound["vo"]["dont_give_em"] 								= "Pel2_IGD_051A_ROEB";
	level.scr_sound["vo"]["clear_em"] 									= "Pel2_IGD_052A_ROEB";
	level.scr_sound["vo"]["nearly_there"] 								= "Pel2_IGD_053A_ROEB";
	level.scr_sound["vo"]["one_last_push"] 								= "Pel2_IGD_054A_ROEB";	
	
}



airfield()
{
	
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_IGD_082A_ROEB" );
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_IGD_083A_ROEB" ); //Glocke: changed audio reference from Pel2_IGD_083B_ROEB to Pel2_IGD_083A_ROEB
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_IGD_015A_ROEB" );
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_OUT_002A_ROEB" );	
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_OUT_003A_ROEB" );
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_OUT_004A_ROEB" );
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_OUT_005A_ROEB" );
	addnotetrack_dialogue( "end_vignette_roebuck", "dialogue", "end_vignette", "Pel2_OUT_006A_ROEB" );
	
	addnotetrack_dialogue( "end_vignette_radio", "dialogue", "end_vignette", "Pel2_OUT_008A_ROOK" );
	
	addnotetrack_dialogue( "end_vignette_polonsky", "dialogue", "end_vignette", "Pel2_IGD_013A_POLO" );
	addnotetrack_dialogue( "end_vignette_polonsky", "dialogue", "end_vignette", "Pel2_OUT_001A_POLO" );
	
	addnotetrack_dialogue( "end_vignette", "dialog", "end_vignette_polonsky_reaction", "Pel2_OUT_007A_POLO" );
	addnotetrack_dialogue( "end_vignette", "dialog", "end_vignette_radio_reaction", "Pel2_OUT_008A_ROOK" );
	
	// NOTETRACKS
	
	level thread addNotetrack_customFunction( "airfield", "spark_fx_1", ::telepole_spark_fx_1, "telepole" );
	
	level thread addNotetrack_customFunction( "airfield", "attach_gun", ::truck_guy_drop_gun, "truck_eject_2" );
	
	
	
	// end vignette smoke
	level thread addNotetrack_attach( "end_vignette_polonsky", "attach", "projectile_us_smoke_grenade", "tag_weapon_left", "end_vignette" );
	level thread addNotetrack_detach( "end_vignette_polonsky", "detach", "projectile_us_smoke_grenade", "tag_weapon_left", "end_vignette" );	
	
	level thread addNotetrack_customFunction( "end_vignette_polonsky", "detach", ::smoke_grenade_fake_model, "end_vignette" );
	
	level thread addNotetrack_customFunction( "end_vignette_polonsky", "attach", ::pacing_throw_smoke,  "end_vignette" );	
	level thread addNotetrack_customFunction( "end_vignette_radio", "attach_radio", ::pacing_attach_radio,  "end_vignette" );	
	
	
	
	// ANIMS
	
	level.scr_anim["airfield"]["truck_eject_1"]							= %ch_peleliu2_truck_crash_guy_1;
	level.scr_anim["airfield"]["truck_eject_2"]							= %ch_peleliu2_truck_crash_guy_2;
	level.scr_anim["airfield"]["truck_eject_3"]							= %ch_peleliu2_truck_crash_guy_3;
	level.scr_anim["airfield"]["truck_eject_4"]							= %ch_peleliu2_truck_crash_guy_4;	
	
	level.scr_anim["airfield"]["truck_idle_driver"][0] 					= %crew_truck_driver_drive_idle;
	level.scr_anim["airfield"]["truck_idle_passenger"][0] 				= %crew_truck_passenger_drive_idle;

	level.scr_anim["end_vignette_polonsky"]["end_vignette"]				= %ch_peleliu2_outro_polonski;
	level.scr_anim["end_vignette_roebuck"]["end_vignette"]				= %ch_peleliu2_outro_roebuck;
	level.scr_anim["end_vignette_radio"]["end_vignette"]				= %ch_peleliu2_outro_radio;

	level.scr_anim["end_vignette"]["end_vignette_guy1_reaction"]		= %ch_peleliu2_outro_guy1_reaction;
	level.scr_anim["end_vignette"]["end_vignette_guy2_reaction"]		= %ch_peleliu2_outro_guy2_reaction;
	level.scr_anim["end_vignette"]["end_vignette_polonsky_reaction"]	= %ch_peleliu2_outro_polonski_reaction;
	level.scr_anim["end_vignette"]["end_vignette_roebuck_reaction"]		= %ch_peleliu2_outro_roebuck_reaction;
	level.scr_anim["end_vignette"]["end_vignette_radio_reaction"]		= %ch_peleliu2_outro_radio_reaction;	
	

	// VO
	
	// initial read & cinch point
	level.scr_sound["vo"]["aint_easy"] 									= "Pel2_IGD_055A_POLO";
	level.scr_sound["vo"]["it_never_is"] 								= "Pel2_IGD_056A_ROEB";
	level.scr_sound["vo"]["move!"] 										= "Pel2_IGD_057A_ROEB";
	level.scr_sound["vo"]["stay_with_tanks"] 							= "Pel2_IGD_058A_ROEB";
	level.scr_sound["vo"]["help_them_move"] 							= "Pel2_IGD_059A_ROEB";
	level.scr_sound["vo"]["jap_aa_guns"] 								= "Pel2_IGD_060A_POLO";
	level.scr_sound["vo"]["deal_with_tanks"] 							= "Pel2_IGD_061A_ROEB";
	level.scr_sound["vo"]["scavenge_supplies"] 							= "Pel2_IGD_062A_ROEB";
	level.scr_sound["vo"]["hit_em_with"] 								= "Pel2_IGD_063A_ROEB";

	level.scr_sound["vo"]["find_a_bazooka"] 							= "Pel2_IGD_800A_USR1";
	level.scr_sound["vo"]["bazooka_from_the_trenches"] 					= "Pel2_IGD_801A_USR1";
	level.scr_sound["vo"]["bazooka_those_tanks"] 						= "Pel2_IGD_802A_USR1";
	level.scr_sound["vo"]["cmon_bazooka_tanks"] 						= "Pel2_IGD_803A_USR1";

	// tank killing
	level.scr_sound["vo"]["one_tank_down"] 								= "Pel2_IGD_065A_ROEB";
	level.scr_sound["vo"]["yeah!!!"] 									= "Pel2_IGD_066A_POLO";
	level.scr_sound["vo"]["keep_doing"] 								= "Pel2_IGD_067A_ROEB";
	level.scr_sound["vo"]["stay_on_it"] 								= "Pel2_IGD_068A_ROEB";
	level.scr_sound["vo"]["damn_good_work"] 							= "Pel2_IGD_069A_ROEB";
	level.scr_sound["vo"]["clear_out_trenches"] 						= "Pel2_IGD_070A_ROEB";
	level.scr_sound["vo"]["take_out_aa_guns"] 							= "Pel2_IGD_071A_ROEB";
	level.scr_sound["vo"]["taking_airfield_today"] 						= "Pel2_IGD_072A_ROEB";
	level.scr_sound["vo"]["first_gun_crew"] 							= "Pel2_IGD_073A_ROEB";
	level.scr_sound["vo"]["taken_out"] 									= "Pel2_IGD_074A_POLO";
	level.scr_sound["vo"]["three_more"] 								= "Pel2_IGD_075A_ROEB";
	level.scr_sound["vo"]["second_crew_down"] 							= "Pel2_IGD_076A_POLO";
	level.scr_sound["vo"]["stay_strong"] 								= "Pel2_IGD_077A_ROEB";
	level.scr_sound["vo"]["two_more"] 									= "Pel2_IGD_078A_ROEB";
	level.scr_sound["vo"]["outta_commission"] 							= "Pel2_IGD_079A_POLO";
	level.scr_sound["vo"]["get_the_last_one"] 							= "Pel2_IGD_080A_ROEB";
	
	// pacing vignette and napalm
	level.scr_sound["vo"]["goodnight"] 									= "Pel2_IGD_081A_POLO";

	level.scr_sound["vo"]["get_on_triple25"] 							= "Pel1B_IGD_021A_ROEB";
	level.scr_sound["vo"]["more_reinforcements"] 						= "Pel2_OUT_200A_POLO";
	level.scr_sound["vo"]["positions_on_that_tower"] 					= "Pel2_OUT_201A_ROEB";
	level.scr_sound["vo"]["get_some_fire_on_that_tower"] 				= "Pel2_OUT_202A_ROEB";
	level.scr_sound["vo"]["bringing_up_tanks"] 							= "Pel2_OUT_203A_POLO";
	level.scr_sound["vo"]["infantry_on_their_trucks"] 					= "Pel2_OUT_204A_ROEB";
	level.scr_sound["vo"]["where_the_hell_did"] 						= "Pel2_OUT_205A_POLO";
	level.scr_sound["vo"]["keep_fire_on_them"] 							= "Pel2_OUT_206A_ROEB";
	level.scr_sound["vo"]["whole_damn_convoy"] 							= "Pel2_OUT_207A_POLO";
	level.scr_sound["vo"]["stay_strong_we_are_holding"] 				= "Pel2_OUT_006A_ROEB";
	
	

	
	level.scr_sound["vo"]["holy_shit"] 									= "Pel2_OUT_007A_POLO";
	level.scr_sound["vo"]["airfield_held"] 								= "Pel2_OUT_008A_ROOK";	
	
}



truck_guy_drop_gun( guy )
{
	guy gun_recall();
}



flamebunker_death_shoot( guy )
{

	guy shoot();
	wait( 3 );
	guy stopshoot();
	
}



flamebunker_death_fx( guy )
{
	
	if( is_mature() )
	{
		playfxontag( level._effect["flamer_gunned_down"], guy, "J_SpineUpper" );
	}
	
}



mangrove_drop_gun( guy )
{
	weaponModel = GetWeaponModel( guy.weapon ); 
	guy Detach( weaponModel, "tag_weapon_right" ); 
	
	guy.a.weaponPos[guy.weaponInfo[guy.weapon].position] = "none";
	guy.weaponInfo[guy.weapon].position = "none";
	
}



///////////////////
//
// ragdoll & kill the guy that is thrown off the plane by the explosion
//
///////////////////////////////

mangrove_corsair_trap( guy )
{
	guy startRagdoll();
	guy DoDamage( guy.health + 1, (0,0,0) );
}



mangrove_throw_grenade( guy )
{
	gren_orig = getstruct( "orig_bunker_gun_4_blowup", "targetname" );
	guy MagicGrenade( guy gettagorigin( "tag_weapon_left" ) + (0,0,20), gren_orig.origin + ( RandomIntRange( -50, 50 ), 0, 30 ), 1.75 );
	
	flag_set( "mangrove_grenades_thrown" );
}




#using_animtree( "pel2_truck_crash" );
pacing_attach_radio( guy )
{
	
	goal_node = getent( "node_end_vigenette", "targetname" );
	
	radio_model = spawn( "script_model", guy.origin );
	radio_model setmodel( "char_usa_marine_radiohandset" );
	radio_model linkto( guy, "tag_weapon_left", (0,0,0), (0,0,0) );
	
	radio_model UseAnimTree( #animtree );
	radio_model.animname = "airfield";
	
	anim_single_solo( radio_model, "outro_handset", undefined, goal_node );
	
	radio_model delete();
	
}	



smoke_grenade_fake_model( guy )
{
	
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );
	
	smoke_grenade = spawn( "script_model" , orig );
	smoke_grenade.angles = angles;
	smoke_grenade setmodel( "projectile_us_smoke_grenade" );	
	
	wait( 3 );
	
	smoke_grenade delete();
	
}

	


pacing_throw_smoke( guy )
{

	wait( 2.25 );
	
	count = 0;
	
	max_loop = 30;
	
	if(NumRemoteClients())
	{
		max_loop = 6;
	}
	
	target_pos = getstruct( "orig_pacing_smoke", "targetname" ).origin;
	
	temp_loop_orig = spawn( "script_origin", target_pos );
	temp_loop_orig playloopsound( "flare_loop" );
	playsoundatposition( "flare_ignite", temp_loop_orig.origin );
	
	while( 1 )
	{
		playfxontag( level._effect["target_smoke"], level.polonsky, "tag_weapon_left" );
		if(NumRemoteClients())
		{
			wait_network_frame();
		}
		else
		{
			wait( 0.05 );
		}
		count++;
		
		if( count > max_loop )
		{
			break;	
		}
		
	}

	count = 0;

	if(NumRemoteClients())	// much reduced version for coop.
	{
		while(1)
		{
			if(count < 30)
			{
				playfx( level._effect["target_smoke"], target_pos );		
				wait(0.1);		
				playfx( level._effect["target_smoke"], target_pos );		
				wait(0.1);
				playfx( level._effect["target_smoke"], target_pos );		
				wait_network_frame();
			}
			else
			{
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.25 );
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.4 );
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.15 );			
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.7 );			
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.4 );			
				playfx( level._effect["target_smoke"], target_pos );						
				break;				
			}
			
			count++;
		}
	}
	else
	{
		while( 1 )
		{
			
			playfx( level._effect["target_smoke"], target_pos );		
			
			count++;
			
			if( count < 500 )
			{
				wait( 0.05 );
			}
			else if( count < 600 )
			{
				wait( 0.1 );
			}
			else if( count < 630 )
			{
				wait( 0.2 );
			}		
			// have it sputter out
			else
			{
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.25 );
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.4 );
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.15 );			
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.7 );			
				playfx( level._effect["target_smoke"], target_pos );
				wait( 0.4 );			
				playfx( level._effect["target_smoke"], target_pos );						
				break;
			}
	
		}
	}

	temp_loop_orig stoploopsound();
	temp_loop_orig delete();
	
}



telepole_spark_fx_1( plane )
{
	orig = getstruct( "orig_pole_fx_1", "targetname" );
	playfx( level._effect["telepole_spark"], orig.origin );		
}



#using_animtree( "pel2_truck_crash" );
setup_geo_anims()
{
	level.scr_anim["forest"]["bomber_clip_trees"]							= %o_peleliu2_palm_crash;
	level.scr_anim["airfield"]["truck_crash"]								= %v_peleliu2_truck_explosion;
	level.scr_anim["airfield"]["telepole"]									= %o_peleliu2_telephone_poles;
	level.scr_anim["airfield"]["outro_handset"]								= %o_peleliu2_outro_handset;
	
}


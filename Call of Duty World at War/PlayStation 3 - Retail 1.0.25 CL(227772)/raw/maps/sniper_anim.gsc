#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree ("generic_human");
main()
{
			////////////////            THESE ARE... YOU GUESSED IT... NOTETRACK CUSTOM FUNCTIONS!
	
	level thread addNotetrack_customFunction( "hero", "bash",								 ::hero_opendoor_3, "door_open3" );
	level thread addNotetrack_customFunction( "gunner", "fire",							 ::gun_flash, "gun_dudes" );
	level thread addNotetrack_customFunction( "gunner", "fire",							 ::gunner_fired_notify, "gun_dudes" );
	level thread addNotetrack_customFunction( "gunner", "fire",							 ::shot_effects, "gun_dudes" );
	level thread addNotetrack_customFunction( "ftn_walker_cross", "fire",		 ::gun_flash, "walk" );
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",::notify_sniperfire, "shoot_left_hi" );
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",::notify_sniperfire, "shoot_left_low" );
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",::notify_sniperfire, "shoot_pass" );
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",::notify_sniperfire, "shoot_right_low" );
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",::notify_sniperfire, "shoot_right_hi" );	
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",::notify_sniperfire, "shoot_pass" );
	level thread addNotetrack_customFunction( "allies", 	   "grenade_throw",::molotov_throw, "molotov_toss" );
	level thread addNotetrack_customFunction( "horchguy2", 			"chair"		,	 ::horchguy2_chairanim, "intro" );
	
	level thread addNotetrack_customFunction( "facecrow", 		"peck_player",			 ::crow_rumble_pecks, "loop");
	level thread addNotetrack_customFunction( "crow1_tree", 		"feathers",	 			 ::play_feather_fx, "outtro");
	level thread addNotetrack_customFunction( "crow2_tree", 		"feathers",				 ::play_feather_fx, "outtro");
	level thread addNotetrack_customFunction( "crow3_tree", 		"feathers",	 			 ::play_feather_fx, "outtro");
	level thread addNotetrack_customFunction( "crow4_tree", 		"feathers",				 ::play_feather_fx, "outtro");
	level thread addNotetrack_customFunction( "ftn_walker_cross", "fire",					 ::send_fire_notify, "walk");
	level thread addNotetrack_customFunction( "hero", 					"gun_pickup",			 ::take_fake_ppsh, "resnov_jump");
	level thread addNotetrack_customFunction( "hero", 					"gun_drop",				 ::place_rifle, "resnov_gun");
	level thread addNotetrack_customFunction( "hero", 			"mannequin_push",			 ::move_mannequin, "mannequin_push");		
	level thread addNotetrack_customFunction( "hero", 			"bullet",							 ::mannequin_fall, "mannequin_push");
	level thread addNotetrack_customFunction( "hero", 			"attach_bar_door",		 ::bardoor_open, "bar_lift");	
	level thread addNotetrack_customFunction( "hero", 			"detach_bar_door",		 ::bardoor_stop, "bar_lift");	
	level thread addNotetrack_customFunction( "hero", 			"attach_bar_door",		 ::bardoor_open, "bar_lift_only");	
	level thread addNotetrack_customFunction( "hero", 			"detach_bar_door",		 ::bardoor_stop, "bar_lift_only");	
	

	level thread addNotetrack_customFunction( "horchguy2", "attach", 			 			 		::chair_delete, "intro");
	level thread addNotetrack_customFunction( "horchguy2", "detach", 			 			 		::chair_replace, "intro");
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_left_hi");
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_left_low");
	level thread addNotetrack_customFunction( "sniperL_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_pass");
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_right_hi");
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_right_low");
	level thread addNotetrack_customFunction( "sniperR_shoot", "sniper_fire",			  ::play_glint_fx, "shoot_pass" );
	level thread addNotetrack_customFunction( "hero", "dialog",			 			 			 		::test_time, "resnov_jump" );
	level thread addNotetrack_customFunction( "hero", "beam",				 			 			    ::beam_lift, "resnov_beam_up" );
	level thread addNotetrack_customFunction( "beams", "beam",			 			 			 		::player_beam_anims, "fall" );
	level thread addNotetrack_customFunction( "player_hands", "smack",				 			::shake_player_effect, "fall" );
	level thread addNotetrack_customFunction( "player_hands", "resnov",				 			::call_resnov, "move" );
	level thread addNotetrack_customFunction( "chandelier", "start_collapse",				::chandolier_fall_notify, "loop" );
	level thread addNotetrack_customFunction( "hero", "door_open",				 			 		::open_slow_door, "building_spin_door" );
	level thread addNotetrack_customFunction( "bookshelf", "bookshelf_hits",			 	::bookcase_fx, "fall" );
	level thread addNotetrack_customFunction( "burner", "fire",					 			 			::end_burst, "g_ally_vig" );
	level thread addNotetrack_customFunction( "burner", "flame",				 			 			::alley_flamer_fire_control, "g_ally_vig" );
	
	level thread addNotetrack_customFunction( "kicker", "leader",				 			 			::spawn_alley_leader, "g_ally_vig" );
	level thread addNotetrack_customFunction( "kicker", "flamer",			 			 			 	::spawn_alley_flamer, "g_ally_vig" );
	level thread addNotetrack_customFunction( "kicker", "shot",								 			::killme, "g_ally_vig" );	
	level thread addNotetrack_customFunction( "kickers_friend", "shot",				 			::killme, "g_ally_vig" );	
	level thread addNotetrack_customFunction( "burner", "shot",								 			::killme, "g_ally_vig" );
	
	//level thread addNotetrack_customFunction( "hero", "detach",				 			 			  ::switch_weapon_out, "bb_jumproll" );
	//level thread addNotetrack_customFunction( "hero", "attach",			 			 			  	::switch_weapon_in, "kicked_vignette" );
	level thread addNotetrack_customFunction( "hero", "detach",			 			 			  	::switch_weapon_out, "kicked_vignette" );
	level thread addNotetrack_customFunction( "redshirt", "attach",			 			 			::redshirt_pickup_gun,	 "postbb_redshirt2" );
	level thread addNotetrack_customFunction( "redshirt", "detach",			 			 			::redshirt_putdownup_gun,	 "postbb_redshirt2" );
	level thread addNotetrack_customFunction( "hero", "attach",			 			 			  	::switch_weapon_in, "postbb_hero" );
	level thread addNotetrack_customFunction( "hero", "Sni1_IGD_000A_REZN",			 		::shoo_crow, "resnov_crawl" );
	level thread addNotetrack_customFunction( "hero", "dialog",			 								::horchhide_cutoff, "e1_street_horchhide" );
	level thread addNotetrack_customFunction( "hero", "dialog", 										::mark_my_words, "bar_lift_only" );

	level thread addNotetrack_customFunction( "fountain_woundedguy1", "tick", 			::wounded_counter, "wounded" );	
	
			///  TEMP UNTIL NEW VO IS RECORDED FOR FACIALS
	//level thread addNotetrack_customFunction( "hero", "Sni1_IGD_051A_REZN_A",	::do_temp_dialogue, "mannequin_entrance" );			
		
				
	level thread addNotetrack_attach( "horchguy2", "attach", "anim_berlin_wood_chair_2", "tag_weapon_left", "intro" );
	level thread addNotetrack_detach( "horchguy2", "detach", "anim_berlin_wood_chair_2", "tag_weapon_left", "intro" );	
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_000A_REZN", "resnov_crawl", "Sni1_IGD_000A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_001A_REZN", "resnov_crawl", "Sni1_IGD_001A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_100A_REZN", "resnov_crawl", "Sni1_IGD_100A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_101A_REZN", "resnov_crawl", "Sni1_IGD_101A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_lift_a", "Sni1_IGD_035A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_lift_a", "Sni1_IGD_037A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_lift_a", "Sni1_IGD_038A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_lift_c", "Sni1_IGD_040A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_lift_c", "Sni1_IGD_041A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "bar_wave", "Sni1_IGD_042A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "building_spin", "Sni1_IGD_043A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "building_spin_door", "Sni1_IGD_044A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "e1_street_horchhide", "Sni1_IGD_031A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "e1_street_horchhide", "Sni1_IGD_032A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "e1_street_horchhide", "Sni1_IGD_002A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "e1_street_horchhide", "Sni1_IGD_033A_REZN" );
	//level thread addnotetrack_dialogue( "hero", "dialog", "resnov_jump", "Sni1_IGD_028A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "resnov_jump", "Sni1_IGD_030A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "resnov_jump", "Sni1_IGD_042A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_045A_REZN", "pacing_car_truck", "Sni1_IGD_045A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_046A_REZN", "pacing_truck_window", "Sni1_IGD_046A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_049A_REZN", "stair_wait", "Sni1_IGD_049A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_050A_REZN_A", "stair_out", "Sni1_IGD_050A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_047A_REZN", "pacing_window_roll", "Sni1_IGD_047A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_048A_REZN", "pacing_window_roll", "Sni1_IGD_048A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_051A_REZN_A", "mannequin_entrance", "Sni1_IGD_051A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_700A_REZN", 	"mannequin_entrance", "Sni1_IGD_700A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_052A_REZN_B", "mannequin_entrance", "Sni1_IGD_052A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_053A_REZN_B", "mannequin_entrance_dialog", "Sni1_IGD_053A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_054A_REZN_A", "mannequin_in", "Sni1_IGD_054A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_055A_REZN_A", "mannequin_in", "Sni1_IGD_055A_REZN" );	
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_056A_REZN_A", "mannequin_loop1_dialog2", "Sni1_IGD_056A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_057A_REZN_A", "mannequin_loop1_dialog1", "Sni1_IGD_057A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_058A_REZN", "mannequin_loop1_dialog3", "Sni1_IGD_058A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_059A_REZN", "mannequin_loop1_dialog4", "Sni1_IGD_059A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_060A_REZN", "mannequin_push", "Sni1_IGD_060A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_061A_REZN", "mannequin_back", "Sni1_IGD_061A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_058A_REZN", "mannequin_loop1_dialog3", "Sni1_IGD_058A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_059A_REZN", "mannequin_loop1_dialog4", "Sni1_IGD_059A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_062A_REZN_A", "mannequin_loop3_dialog1", "Sni1_IGD_062A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_063A_REZN_B", "mannequin_loop3_dialog1", "Sni1_IGD_063A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_064A_REZN_A", "mannequin_loop3_dialog1", "Sni1_IGD_064A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_065A_REZN_A", "mannequin_loop3_dialog1", "Sni1_IGD_065A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_003B_REZN", "resnov_gun", "Sni1_IGD_003B_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_004A_REZN", "resnov_info2", "Sni1_IGD_004A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_005A_REZN", "resnov_info2", "Sni1_IGD_005A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_006A_REZN", "resnov_info2", "Sni1_IGD_006A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_008A_REZN", "resnov_talk", "Sni1_IGD_008A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_009A_REZN", "resnov_talk", "Sni1_IGD_009A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_010A_REZN", "resnov_talk", "Sni1_IGD_010A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_011A_REZN", "resnov_talk", "Sni1_IGD_011A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_012A_REZN", "resnov_talk", "Sni1_IGD_012A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_013A_REZN", "resnov_talk", "Sni1_IGD_013A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_102A_REZN", "resnov_talk", "Sni1_IGD_102A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_054A_REZN", "ftn_ready", "Sni1_IGD_054A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_015A_REZN", "ftn_shootnow", "Sni1_IGD_015A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_016A_REZN", "ftn_again", "Sni1_IGD_016A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_020A_REZN", "ftn_aimright", "Sni1_IGD_020A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_024A_REZN", "ftn_ha", "Sni1_IGD_024A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_023A_REZN", "ftn_hurry", "Sni1_IGD_023A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_018A_REZN", "ftn_moreleft", "Sni1_IGD_018A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_017A_REZN", "ftn_moreright", "Sni1_IGD_017A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_021A_REZN", "ftn_straight", "Sni1_IGD_021A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_026A_REZN", "ftn_dog", "Sni1_IGD_026A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_029A_REZN", "ftn_excellent_aim", "Sni1_IGD_029A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_028A_REZN", "ftn_aim_good", "Sni1_IGD_028A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_027A_REZN", "ftn_could_b_quicker", "Sni1_IGD_027A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_200A_REZN", "ftn_burning_car", "Sni1_IGD_200A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_201A_REZN", "ftn_bystairs", "Sni1_IGD_201A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_215A_REZN", "resnov_beam_up", "Sni1_IGD_215A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_216A_REZN", "resnov_beam_up", "Sni1_IGD_216A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_074A_REZN", "bb_intro_dive", "Sni1_IGD_074A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_075A_REZN", "bb_intro_dive", "Sni1_IGD_075A_REZN" );
	level thread addnotetrack_dialogue( "hero", "Sni1_IGD_076A_REZN", "bb_intro_dive", "Sni1_IGD_076A_REZN" );
	level thread addnotetrack_dialogue( "redshirt", "dialog", "postbb_redshirt1", "Sni1_IGD_300A_DALE" );
	level thread addnotetrack_dialogue( "redshirt", "dialog", "postbb_redshirt1", "Sni1_IGD_301A_DALE" );
	level thread addnotetrack_dialogue( "hero", "dialog", "postbb_hero", "Sni1_IGD_302A_REZN" );
	level thread addnotetrack_dialogue( "redshirt", "dialog", "postbb_redshirt1", "Sni1_IGD_303A_DALE" );
	level thread addnotetrack_dialogue( "hero", "dialog", "postbb_hero", "Sni1_IGD_304A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "postbb_hero", "Sni1_IGD_305A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "postbb_hero", "Sni1_IGD_306A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "resnov_splain", "Sni1_IGD_307A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "resnov_splain", "Sni1_IGD_308A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "resnov_splain", "Sni1_IGD_309A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "reznov_cheer", "Sni1_IGD_315A_REZN" );
	level thread addnotetrack_dialogue( "hero", "dialog", "reznov_cheer", "Sni1_IGD_400A_REZN" );
	level thread addnotetrack_dialogue( "kickers_friend", "dialog", "g_ally_vig", "Sni1_IGD_701A_GER1" );
	level thread addnotetrack_dialogue( "kickers_friend", "dialog", "g_ally_vig", "Sni1_IGD_702A_GER1" );


	addnotetrack_fxontag( "streetdude1", "idle", "cig_light", "cigarette_glow_puff", "tag_fx" );
	addnotetrack_fxontag( "streetdude1", "idle", "cig_puff", "cigarette_exhale", "TAG_EYE" );

	///////////////   EVENT 1 ANIMS
 

				// 			PATROL ANIMS	
	level.scr_anim[ "generic" ][ "patrol_walk" ]			 	  = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			 	  = %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			 	  = %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %patrol_bored_2_walk_180turn;
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]				= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]				= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]				= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]				= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]				= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]				= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone"]= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_1_loop" ][0]		    	= %patrol_bored_idle;

			//       STEALTH ANIMS  - sOME OF these dont work!  YAY!
	
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %patrol_bored_2_walk_180turn;
	level.scr_anim[ "generic" ][ "_stealth_patrol_jog" ]				= %combat_jog;				
	level.scr_anim[ "generic" ][ "_stealth_patrol_walk" ]				= %patrol_bored_patrolwalk;	
	level.scr_anim[ "generic" ][ "_stealth_combat_jog" ]				= %combat_jog;
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_a" ]			= %patrol_boredwalk_lookcycle_A;
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_b" ]			= %patrol_boredwalk_lookcycle_B;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]	= %exposed_idle_twitch_v4;		
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]		= %patrol_bored_react_walkstop_short;
	level.scr_anim[ "generic" ][ "_stealth_look_around1" ]			= %patrol_bored_react_look_v1;		// feet planted, guy looking from side to side
	level.scr_anim[ "generic" ][ "_stealth_look_around2" ]			= %patrol_bored_react_look_v2;			// feet planted, guy looking from side to side
	level.scr_anim[ "generic" ][ "_stealth_behavior_saw_corpse" ]		= %exposed_idle_twitch_v4;

	//1 is the animation that looks the best at the closest range (fast reaction )...and slower
	//reactions get added down the line		
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic1" ]			= %patrol_bored_react_look_advance;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic2" ]			= %patrol_bored_react_look_retreat;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic3" ]			= %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic4" ]			= %patrol_bored_react_walkstop_short;
	
	
	level.scr_anim[ "generic" ][ "_stealth_find_jog" ]					= %patrol_boredjog_find;
		
	level.scr_anim["generic"]["lookaround1"]     = %patrol_bored_react_look_v1;
	level.scr_anim["generic"]["lookaround2"]     = %patrol_bored_react_look_v2;
	level.scr_anim["generic"]["lookaround1_loop"][0]     = %patrol_bored_react_look_v1;
	level.scr_anim["generic"]["lookaround2_loop"][0]     = %patrol_bored_react_look_v2;
	level.scr_anim["generic"]["street_patrol1"]    = %patrol_bored_patrolwalk;
	level.scr_anim["generic"]["street_patrol2"]    = %patrol_bored_patrolwalk;
	level.scr_anim["generic"]["street_patrol3"]    = %patrol_bored_patrolwalk;
	


	//// FOUNTAIN DUDES!
	level.scr_anim["fountain_woundedguy1"]["wounded"]						 = %ch_sniper_fountain_rus1;
	level.scr_anim["fountain_woundedguy1"]["wounded_loop"]			 = %ch_sniper_fountain_rus1_loop;
	level.scr_anim["fountain_woundedguy1"]["wounded_loop_timed"] = %ch_sniper_fountain_rus1_loop;
	level.scr_anim["fountain_woundedguy1"]["dead_loop"][0] 			 = %ch_sniper_fountain_rus1_dead;
	level.scr_anim["fountain_woundedguy1"]["stay_dead"]					 = %ch_sniper_fountain_rus1_dead;
	level.scr_anim["fountain_woundedguy2"]["wounded"] 					 = %ch_sniper_fountain_rus2;
	level.scr_anim["fountain_woundedguy2"]["wounded_loop"][0]	   = %ch_sniper_fountain_rus2_loop;
	level.scr_anim["fountain_woundedguy2"]["dead_loop"][0] 	 		 = %ch_sniper_fountain_rus2_dead;
	level.scr_anim["fountain_woundedguy2"]["stay_dead"] 		  	 = %ch_sniper_fountain_rus2_dead;
	level.scr_anim["fountain_woundedguy3"]["wounded"] 					 = %ch_sniper_fountain_rus3;
	level.scr_anim["fountain_woundedguy3"]["dead_loop"][0] 			 = %ch_sniper_fountain_rus3_dead;
	level.scr_anim["fountain_woundedguy3"]["stay_dead"]			 		 = %ch_sniper_fountain_rus3_dead;
	level.scr_anim["gunner"]["gun_dudes"] 								     	 = %ch_sniper_fountain_german;
	level.scr_anim[ "tankriders" ][ "rider1" ][0]				   			 = %ch_sniper_panzer4_passenger10_idle; 
	level.scr_anim[ "tankriders" ][ "rider2" ][0]					 		   = %ch_sniper_panzer4_passenger8_idle;  
	level.scr_anim[ "tankriders" ][ "rider3" ][0]					 			 = %ch_sniper_panzer4_passenger4_idle;  
	level.scr_anim[ "tankriders" ][ "lookaround1" ]					 	   = %ch_sniper_panzer4_passenger10_lookaround;
  level.scr_anim[ "tankriders" ][ "lookaround2" ]						 	 = %ch_sniper_panzer4_passenger8_lookaround;
  level.scr_anim[ "tankriders" ][ "lookaround3" ]							 = %ch_sniper_panzer4_passenger4_lookaround;
	level.scr_anim[ "ftn_walker_cross" ][ "walk" ]							 = %ch_sniper_poking_dead_guy1;	// look down, shoot
	level.scr_anim[ "ftn_walker_side" ][ "walk" ]								 = %ch_sniper_poking_dead_guy2;	// looking down alot, casual
	level.scr_anim[ "ftn_walker_last" ][ "walk" ]								 = %ch_sniper_poking_dead_guy3;	//just walking and looking
	level.scr_anim[ "ftn_walker_last" ][ "patrolwalk" ]				 	 = %patrol_bored_patrolwalk;  
	level.scr_anim[ "ftn_walker" ][ "dude4" ]								 		 = %ch_sniper_poking_dead_guy4;  //mehzors
	level.scr_anim[ "ftn_walker" ][ "patrolwalk" ]					 		 = %patrol_bored_patrolwalk;  
	
	
	///// GUYS IN STREET
	
	
	level.scr_anim[ "officer" ][ "officer_ride" ]					= %ch_sniper_intro_passenger;
	level.scr_anim[ "assistant" ][ "assistant_ride" ]			= %ch_sniper_intro_driver;
	//level.scr_anim[ "book_h8r" ][ "book_hatin" ]					= %ch_sniper_book_guy;
	level.scr_anim[ "streetdude1" ][ "idle" ][0]						= %ch_sniper_ambient2_guy1_idle;
	level.scr_anim[ "streetdude1" ][ "intro" ]					= %ch_sniper_ambient2_guy1_intro;
	level.scr_anim[ "streetdude1" ][ "loop" ][0]				= %ch_sniper_ambient2_guy1_loop;
	level.scr_anim[ "streetdude1" ][ "react" ]					= %ch_sniper_ambient2_guy1_react;
	level.scr_anim[ "streetdude1" ][ "shot" ]						= %ch_sniper_ambient2_guy1_shot;
	level.scr_anim[ "streetdude2" ][ "intro" ]					= %ch_sniper_ambient2_guy2_intro;
	level.scr_anim[ "streetdude2" ][ "loop" ][0]				= %ch_sniper_ambient2_guy2_loop;
	level.scr_anim[ "streetdude2" ][ "react" ]					= %ch_sniper_ambient2_guy2_react;
	level.scr_anim[ "streetdude2" ][ "shot" ]						= %ch_sniper_ambient2_guy2_shot;
	level.scr_anim[ "streetdude3" ][ "intro" ]					= %ch_sniper_ambient1_guy1_intro;
	level.scr_anim[ "streetdude3" ][ "loop" ][0]				= %ch_sniper_ambient1_guy1_loop;
	level.scr_anim[ "streetdude3" ][ "react" ]					= %ch_sniper_ambient1_guy1_react;
	level.scr_anim[ "streetdude3" ][ "shot" ]						= %ch_sniper_ambient1_guy1_shot;
	level.scr_anim[ "streetdude4" ][ "intro" ]					= %ch_sniper_ambient1_guy2_intro;
	level.scr_anim[ "streetdude4" ][ "loop" ][0]				= %ch_sniper_ambient1_guy2_loop;
	level.scr_anim[ "streetdude4" ][ "react" ]					= %ch_sniper_ambient1_guy2_react;
	level.scr_anim[ "streetdude4" ][ "shot" ]						= %ch_sniper_ambient1_guy2_shot;
	level.scr_anim["dog_handler"]["find_body"]					= %ch_sniper_street_react;
	level.scr_anim[ "horchguy1" ][ "intro" ]						= %ch_sniper_horch_guy1_intro;
	level.scr_anim[ "horchguy1" ][ "loop" ][0]					= %ch_sniper_horch_guy1_loop;
	level.scr_anim[ "horchguy1" ][ "react" ]						= %ch_sniper_horch_guy1_react;
	level.scr_anim[ "horchguy1" ][ "shot" ]							= %ch_sniper_horch_guy1_shot;
	level.scr_anim[ "horchguy1" ][ "dead" ][0]					= %ch_sniper_horch_guy1_dead;
	level.scr_anim[ "horchguy2" ][ "intro" ]						= %ch_sniper_horch_guy2_intro;
	level.scr_anim[ "horchguy2" ][ "loop" ][0]					= %ch_sniper_horch_guy2_loop;
	level.scr_anim[ "horchguy2" ][ "react" ]						= %ch_sniper_horch_guy2_react;
	level.scr_anim[ "horchguy2" ][ "shot" ]							= %ch_sniper_horch_guy2_shot;
	level.scr_anim[ "hunters" ][ "door_kick" ]					= %door_bash_and_block;

	///////  EVENT 2 SNIPER!
	level.scr_anim[ "sniperL" ][ "idle_L" ][0] 											= %ch_sniper_window_idle_L;
	level.scr_anim[ "sniperR" ][ "idle_R" ][0] 											= %ch_sniper_window_idle_R;
	level.scr_anim[ "sniperL_shoot" ][ "shoot_left_hi" ] 						= %ch_sniper_shootL_hi;				//good
	level.scr_anim[ "sniperL_shoot" ][ "shoot_left_low" ] 					= %ch_sniper_shootL_lo;				//good
	level.scr_anim[ "sniperR_shoot" ][ "shoot_right_low" ] 					= %ch_sniper_shootR_lo;				//exposed too long
	level.scr_anim[ "sniperR_shoot" ][ "shoot_right_hi" ] 					= %ch_sniper_shootR_hi;				//exposed too long
	level.scr_anim[ "sniperL_shoot" ][ "shoot_pass" ] 							= %ch_sniper_window_pass2_L;	// passing with gun pointed
	level.scr_anim[ "sniperR_shoot" ][ "shoot_pass" ] 							= %ch_sniper_window_pass2_R;	// passing with gun pointed
	level.scr_anim[ "sniperL_pass" ][ "pass1L" ] 										= %ch_sniper_window_pass1_L;	// spin and look pass
	level.scr_anim[ "sniperR_pass" ][ "pass1R" ] 										= %ch_sniper_window_pass1_R;	// spin and look pass
	level.scr_anim[ "sniperL_pass" ][ "pass2L" ] 										= %ch_sniper_window_pass3_L;	// running across pass
	level.scr_anim[ "sniperR_pass" ][ "pass2R" ] 										= %ch_sniper_window_pass3_R;	// running across pass
	level.scr_anim[ "sniperL_scan" ][ "scanL_hi" ] 									= %ch_sniper_scanL_hi;		// a bit long.. good for using as the battle lasts too long
	level.scr_anim[ "sniperL_scan" ][ "scanL_lo" ] 									= %ch_sniper_scanL_lo;		// good
	level.scr_anim[ "sniperR_scan" ][ "scanR_hi" ] 									= %ch_sniper_scanR_hi;		// a bit long.. good for using as the battle lasts too long
	level.scr_anim[ "sniperR_scan" ][ "scanR_lo" ] 									= %ch_sniper_scanR_lo;		// good
	level.scr_anim["sniper1"]["sneaky_walk1"]												= %ai_sneaking_a_walk;
	level.scr_anim["sniper1"]["sniper_death"]												= %corner_standR_deathA;


	////////////// EVENT 2 BURNING BUILDING ENEMIES!
	level.scr_anim[ "street_runners" ][ "_stealth_combat_jog" ]	= %combat_jog;
	level.scr_anim[ "street_runners" ][ "run1" ]							 	= %ch_sniper_german_motioning1;
	level.scr_anim[ "street_runners" ][ "run2" ]							 	= %ch_sniper_german_motioning2;
	level.scr_anim[ "street_runners" ][ "run3" ]							 	= %ch_sniper_german_motioning3;
	level.scr_anim[ "dog_handler2" ][ "walk_withdog" ]				 	= %ch_sniper_dog_handler;
	level.scr_anim[ "dog_handler2" ][ "walk_tospot" ]					 	= %patrol_bored_patrolwalk;
	level.scr_anim[ "e2_flamer" ][ "stand_aim_reach" ]					= %ai_flamethrower_aim_5;
	level.scr_anim[ "e2_flamer" ][ "stand_aim" ][0]							= %ai_flamethrower_aim_5;




	level.scr_anim[ "kicker" ][ "g_ally_vig" ]						 						= %ch_sniper_Resnov_kicked_kicker;
	level.scr_anim[ "kickers_friend" ][ "g_ally_vig" ]								= %ch_sniper_Resnov_kicked_leader;
	level.scr_anim[ "burner" ][ "g_ally_vig" ]								 				= %ch_sniper_Resnov_kicked_flamer;
	
	//////////////// EVENT 3 SNIPER COVER

	
	level.scr_anim["officer_guard1"]["talking_loop"][0]		= %ch_makinraid_e2_arguing1_loop;
	level.scr_anim["officer_guard2"]["talking_loop"][0]		= %ch_makinraid_e2_arguing2_loop;

	level.scr_anim[ "allies" ][ "molotov_toss" ]					= %coverstand_grenadeA;
	level.scr_anim[ "flamer" ][ "idle" ][0]								= %patrol_bored_idle;
	//level.scr_anim[ "truck_vin_fuel" ][ "refueling" ]			= %ch_holland2_truck_sequence_refueling;
	//level.scr_anim[ "truck_vin_fuel" ][ "transition" ]		= %ch_holland2_truck_sequence_trans;
	//level.scr_anim[ "truck_vin_fuel" ][ "talk_loop" ][0]	= %ch_holland2_truck_sequence_talk_1;
	//level.scr_anim[ "truck_vin_back" ][ "backdoor" ]			= %ch_holland2_truck_sequence_door;
	//level.scr_anim[ "truck_vin_back" ][ "talk_loop2" ][0]	= %ch_holland2_truck_sequence_talk_2;
	level.scr_anim[ "e3_smoker1" ][ "smoke_it" ][0]				= %ch_holland2_smoking_guy1;
	level.scr_anim[ "e3_smoker2" ][ "smoke_it" ][0]				= %ch_holland2_smoking_guy2;


	////////////  EVENT 4 GENERAL KILL!
	level.scr_anim[ "driver" ][ "driver_under_fire" ][0]							= %crew_jeep1_driver_drive_under_fire;
	level.scr_anim[ "driver" ][ "driver_death" ]											= %crew_jeep1_driver_death_shot;
	level.scr_anim[ "driver" ][ "driver_death_loop" ][0]							= %crew_jeep1_driver_death_shot_loop;	
	
	level.scr_anim[ "officer" ][ "oficer_ride_back" ][0]							= %ch_sniper_amsel_horch_loop;
	level.scr_anim[ "officer" ][ "low_walk" ]													= %ai_sneaking_a_walk;
	
	level.scr_anim[ "officer" ][ "crouchhide" ][0]										= %ch_sniper_amsel_cover_idle;
	level.scr_anim[ "officer" ][ "cover_run" ]												= %ch_sniper_amsel_cover_run;
	level.scr_anim[ "officer" ][ "run_cover" ]												= %ch_sniper_amsel_run_cover;
	level.scr_anim[ "officer" ][ "amsel_shot" ]												= %ch_sniper_amsel_death;
	level.scr_anim[ "officer" ][ "run_cautious" ]											= %ch_sniper_amsel_run_cautious;
	level.scr_anim[ "officer" ][ "last_run" ]													= %ch_sniper_amsel_run_hurry;
	level.scr_anim[ "officer" ][ "run_away" ]													= %ch_sniper_amsel_run_away;
	level.scr_anim[ "officer" ][ "run_quickly" ]											= %ch_sniper_amsel_run_quickly;
	
	
	level.scr_anim[ "officer" ][ "bodyguard_exit" ]										= %ch_sniper_amsel_exit;
	level.scr_anim[ "officers_sniper" ][ "bodyguard_exit" ]						= %ch_sniper_bodyguard_exit;
	level.scr_anim[ "officers_sniper" ][ "loop_l" ][0]								= %ch_sniper_crouch_loop_l;
	level.scr_anim[ "officers_sniper" ][ "loop_r" ][0]								= %ch_sniper_crouch_loop_r;	
	level.scr_anim[ "officers_sniper" ][ "shoot_l" ]									= %ch_sniper_crouch_shoot_l;
	level.scr_anim[ "officers_sniper" ][ "shoot_r" ]									= %ch_sniper_crouch_shoot_r;	
	level.scr_anim[ "generic" ][ "motioning" ][0]											= %ch_sniper_entourage_motioning;
	level.scr_anim[ "generic" ][ "motioning_reach" ]									= %ch_sniper_entourage_motioning;
	level.scr_anim[ "generic" ][ "point" ]														= %ch_sniper_entourage_point;	
	level.scr_anim[ "generic" ][ "scan" ]															= %ch_sniper_entourage_scan;		
	level.scr_anim[ "generic" ][ "wave_ansel" ]												= %ch_sniper_entourage_waving;
	level.scr_anim["officer"][ "horch_getin" ]												= %ch_sniper_amsel_getin;
	level.scr_anim["officer"][ "horch_getout" ]												= %ch_sniper_amsel_getout;
	level.scr_anim["driver"][ "horch_getin" ]													= %ch_sniper_amsel_getin_driver;	
	level.scr_anim["officer"][ "horch_death" ]												= %ch_sniper_amsel_horch_die;
	level.scr_anim["officer"][ "horch_deathloop" ]										= %ch_sniper_amsel_horch_die_loop;
	level.scr_anim["officer"][ "horch_lookback" ]											= %ch_sniper_amsel_horch_lookback;
	level.scr_anim["officer"][ "horch_wave1" ]												= %ch_sniper_amsel_horch_wave1;
	level.scr_anim["officer"][ "horch_wave2" ]												= %ch_sniper_amsel_horch_wave2;



			
	
		
			
				

	////////////////////				REZNOV ANIMS!		\\\\\\\\\\\\\\\\\\\\\\\\\\
	
				// EVENT 1
							// FOUNTAIN
	level.scr_anim[ "hero" ][ "resnov_gun" ]						= %ch_sniper_fountain_resnov_gun;
	level.scr_anim[ "hero" ][ "resnov_crawl" ]					= %ch_sniper_fountain_resnov_crawl;
	level.scr_anim[ "hero" ][ "resnov_info" ]						= %ch_sniper_fountain_resnov_info;
	level.scr_anim[ "hero" ][ "resnov_talk" ]						= %ch_sniper_Resnov_fountain_talk;
	level.scr_anim[ "hero" ][ "resnov_info2" ]					= %ch_sniper_fountain_resnov_info2;
	level.scr_anim[ "hero" ][ "resnov_intro_loop" ][0]	= %ch_sniper_fountain_resnov_intro_loop;
	level.scr_anim[ "hero" ][ "resnov_jump" ]						= %ch_sniper_fountain_resnov_jump;
	level.scr_anim[ "hero" ][ "resnov_wait_loop" ][0]		= %ch_sniper_fountain_resnov_wait_loop;
	level.scr_anim[ "hero" ][ "resnov_gun_loop" ][0]		= %ch_sniper_fountain_resnov_gun_loop;
	

	level.scr_anim[ "hero" ][ "ftn_ready" ]						= %ch_sniper_Resnov_fountain_ready;
	level.scr_anim[ "hero" ][ "ftn_shootnow" ]				= %ch_sniper_Resnov_fountain_shootnow;
	level.scr_anim[ "hero" ][ "ftn_again" ]						= %ch_sniper_Resnov_fountain_again;
	level.scr_anim[ "hero" ][ "ftn_again_loop" ][0]		= %ch_sniper_Resnov_fountain_peekloop;
	level.scr_anim[ "hero" ][ "ftn_aimright" ]				= %ch_sniper_Resnov_fountain_aimright;
	level.scr_anim[ "hero" ][ "ftn_ha" ]							= %ch_sniper_Resnov_fountain_ha;
	level.scr_anim[ "hero" ][ "ftn_hurry" ]						= %ch_sniper_Resnov_fountain_hurry;
	level.scr_anim[ "hero" ][ "ftn_moreleft" ]				= %ch_sniper_Resnov_fountain_moreleft;
	level.scr_anim[ "hero" ][ "ftn_moreright" ]				= %ch_sniper_Resnov_fountain_moreright;
	level.scr_anim[ "hero" ][ "ftn_straight" ]				= %ch_sniper_Resnov_fountain_straightahead;
	level.scr_anim[ "hero" ][ "ftn_dog" ]							= %ch_sniper_Resnov_fountain_dog;
	level.scr_anim[ "hero" ][ "ftn_excellent_aim" ]		= %ch_sniper_Resnov_fountain_aimexcellent;
	level.scr_anim[ "hero" ][ "ftn_aim_good" ]				= %ch_sniper_Resnov_fountain_aimgood;
	level.scr_anim[ "hero" ][ "ftn_could_b_quicker" ] = %ch_sniper_Resnov_fountain_aimpoor;
	
	level.scr_anim[ "hero" ][ "ftn_burning_car" ]			= %ch_sniper_Resnov_fountain_byburningcar;
	level.scr_anim[ "hero" ][ "ftn_bystairs" ]				= %ch_sniper_Resnov_fountain_bystairs;
	
	
	
	
						// FOUNTAIN TO SPEECH
	level.scr_anim["hero"]["e1_street_horchhide"]			= %ch_sniper_Resnov_horch_hide;
	level.scr_anim["hero"]["e1_street_run"]						= %ch_reznov_run_d;
	//level.scr_anim["hero"]["e1_street_run"]					= %ch_sniper_Resnov_run;
	level.scr_anim["hero"]["e1_street_followme"]			= %ch_sniper_Resnov_followme;
	level.scr_anim["hero"]["e1_street_windowhop"]			= %ch_sniper_Resnov_window;
	level.scr_anim["hero"]["sneaky_walk1"]						= %ai_sneaking_a_walk;
	
						// SPEECH BUILDING
	level.scr_anim["hero"]["building_spin"]				  	= %ch_sniper_Resnov_clearing;
	level.scr_anim["hero"]["building_spin_door"]		 	= %ch_sniper_Resnov_clearing_door;
	level.scr_anim["hero"]["bar_lift_only"]  		  	 	= %ch_sniper_Resnov_bar_b;
	level.scr_anim["hero"]["bar_lift_a"]  		  	   	= %ch_sniper_Resnov_bar_a;
	level.scr_anim["hero"]["bar_lift_c"]  		  	   	= %ch_sniper_Resnov_bar_c;
	level.scr_anim["hero"]["bar_wait"][0]  			 		  = %ch_sniper_Resnov_bar_wait;
	level.scr_anim["hero"]["bar_wave"]  		  	  		= %ch_sniper_Resnov_bar_wave;
	level.scr_anim["hero"]["door_wait"][0]  		  	  = %ch_sniper_Resnov_door_wait;
	
	
						// FROM SPEECH BUILDING TO SNIPER BUILDING
	level.scr_anim[ "hero" ][ "pacing_car_in" ]										= %ch_sniper_Resnov_car_in;
	level.scr_anim[ "hero" ][ "pacing_car_idle1" ][0]							= %ch_sniper_Resnov_car_idle1;
	level.scr_anim[ "hero" ][ "pacing_car_idle1_reach" ]					= %ch_sniper_Resnov_car_idle1;
	level.scr_anim[ "hero" ][ "pacing_car_truck" ]								= %ch_sniper_Resnov_car_truck;
	level.scr_anim[ "hero" ][ "pacing_truck_idle" ][0]						= %ch_sniper_Resnov_truck_idle;
	level.scr_anim[ "hero" ][ "pacing_truck_idle_reach" ]					= %ch_sniper_Resnov_truck_idle;
	level.scr_anim[ "hero" ][ "pacing_truck_window" ]							= %ch_sniper_Resnov_truck_window;
	level.scr_anim[ "hero" ][ "pacing_window_loop" ][0]						= %ch_sniper_Resnov_window_loop;
	level.scr_anim[ "hero" ][ "pacing_window_loop_reach" ]				= %ch_sniper_Resnov_window_loop;
	level.scr_anim[ "hero" ][ "pacing_window_roll" ]							= %ch_sniper_Resnov_window_roll;
	level.scr_anim[ "hero" ][ "pacing_window_roll_stand" ]				= %prone_2_stand;	

			// EVENT 2
	
						// IN SNIPER BUILDING
	level.scr_anim["hero"][ "stair_run" ]							= %ai_staircase_run_up_v1;
	level.scr_anim["hero"][ "stairs_down" ]						= %ai_staircase_run_down_v1;
	level.scr_anim["hero"][ "stair_wait_loop" ][0]		= %ch_sniper_store_stair_wait_loop;
	level.scr_anim["hero"][ "stair_wait" ]						= %ch_sniper_store_stair_wait;
	level.scr_anim["hero"][ "stair_in" ]							= %ch_sniper_store_stair_in;
	level.scr_anim["hero"][ "stair_out" ]							= %ch_sniper_store_stair_out;
	level.scr_anim["hero"][ "mannequin_entrance" ]		= %ch_sniper_mannequin_entrance;
	level.scr_anim["hero"][ "mannequin_entrance_dialog" ]		= %ch_sniper_mannequin_entrance_dialog;
	level.scr_anim["hero"][ "mannequin_wait" ][0]			= %ch_sniper_mannequin_wait;
	level.scr_anim["hero"][ "mannequin_in" ]					= %ch_sniper_mannequin_in;
	level.scr_anim["hero"][ "mannequin_out" ]					= %ch_sniper_mannequin_out;
	level.scr_anim["hero"][ "mannequin_slide_in" ]		= %ch_sniper_resnov_mannequin_in;
						// IN SNIPER BATTLE
	level.scr_anim[ "hero" ][ "mannequin_loop1" ][0]							= %ch_sniper_Resnov_mannequin_loop1;
	level.scr_anim[ "hero" ][ "mannequin_loop1_reach" ]						= %ch_sniper_Resnov_mannequin_loop1;
	
	level.scr_anim[ "hero" ][ "mannequin_loop1_dialog1" ]						= %ch_sniper_Resnov_mannequin_loop1_dialog1;
	level.scr_anim[ "hero" ][ "mannequin_loop1_dialog2" ]						= %ch_sniper_Resnov_mannequin_loop1_dialog2;
	level.scr_anim[ "hero" ][ "mannequin_loop1_dialog3" ]						= %ch_sniper_Resnov_mannequin_loop1_dialog3;
	level.scr_anim[ "hero" ][ "mannequin_loop1_dialog4" ]						= %ch_sniper_Resnov_mannequin_loop1_dialog4;
	level.scr_anim[ "hero" ][ "mannequin_loop3_dialog1" ]						= %ch_sniper_Resnov_mannequin_loop3_dialog1;
	level.scr_anim[ "hero" ][ "mannequin_loop3_dialog2" ]						= %ch_sniper_Resnov_mannequin_loop3_dialog2;
	level.scr_anim[ "hero" ][ "mannequin_loop3_dialog3" ]						= %ch_sniper_Resnov_mannequin_loop3_dialog3;
	
	//level.scr_anim[ "hero" ][ "mannequin_loop2" ][0]							= %ch_sniper_Resnov_mannequin_loop2;
	level.scr_anim[ "hero" ][ "mannequin_loop3" ][0]							= %ch_sniper_Resnov_mannequin_loop3;
	level.scr_anim[ "hero" ][ "mannequin_push" ]				 					= %ch_sniper_Resnov_mannequin_push;
	level.scr_anim[ "hero" ][ "mannequin_endpush_loop" ][0]				= %ch_sniper_Resnov_mannequin_wait;
	level.scr_anim[ "hero" ][ "mannequin_back" ]					 				= %ch_sniper_Resnov_mannequin_back;


	// EVENT 2 BURNING BUILDING
	
	
	level.scr_anim[ "hero"][ "bb_intro_dive" ]						= %ch_sniper_Resnov_clock_dive;
	level.scr_anim[ "hero"][ "bb_intro_staylow" ]					= %ch_sniper_Resnov_clock_keeplow;
	level.scr_anim[ "hero"][ "bb_intro_loop" ][0]					= %ch_sniper_Resnov_clock_loop;
	level.scr_anim[ "hero"][ "bb_intro_loop_reach" ]			= %ch_sniper_Resnov_clock_loop;
	
	level.scr_anim[ "hero"][ "bb_intro_hop_down" ]				= %ch_sniper_resnov_hop;
	level.scr_anim[ "hero"][ "bb_intro_hop" ]							= %ch_sniper_Resnov_table;
	level.scr_anim[ "hero"][ "bb_intro_hop_loop" ][0]			= %ch_sniper_Resnov_table_loop;	
	level.scr_anim[ "hero"][ "bb_crawl_getup" ]						= %ch_sniper_Resnov_crawl_getup;
	level.scr_anim[ "hero"][ "bb_jumpout" ]								= %ch_sniper_Resnov_explosion; 	
	level.scr_anim[ "hero"][ "bb_jumproll" ]							= %ch_sniper_Resnov_landing; 		
	level.scr_anim[ "hero"][ "bb_proneloop" ][0]					= %ch_sniper_Resnov_land_loop;
	level.scr_anim[ "hero"][ "bb_getup" ]									= %ch_sniper_Resnov_land_getup;

	level.scr_anim[ "hero"][ "bb_stairs_in" ]							= %ch_sniper_Resnov_stairs_in;
	level.scr_anim[ "hero"][ "bb_stairs_loop" ][0]				= %ch_sniper_Resnov_stairs_loop;
	level.scr_anim[ "hero"][ "bb_stairs_loop_reach" ]			= %ch_sniper_Resnov_stairs_loop;
	level.scr_anim[ "hero"][ "bb_stairs_out" ]						= %ch_sniper_Resnov_stairs_out;
		
	level.scr_anim["hero"][ "runcough1" ]									= %ch_resnov_runandcough1;
	level.scr_anim["hero"][ "bb_stumble4" ]								= %ch_sniper_resnov_stumble4;
	level.scr_anim["hero"][ "bb_stumble3" ]								= %ch_sniper_resnov_stumble2;
	level.scr_anim["hero"][ "bb_stumble1" ]								= %ch_sniper_resnov_stumble1;
	level.scr_anim[ "hero"][ "resnov_beam_up" ]						= %ch_sniper_Resnov_beam;

	level.scr_anim[ "hero"][ "resnov_hole_wait" ][0]			= %ch_sniper_Resnov_wait_loop1;
	level.scr_anim[ "hero"][ "resnov_hole_wait_reach" ]		= %ch_sniper_Resnov_wait_loop1;
	level.scr_anim[ "hero"][ "resnov_hole_talk" ]					= %ch_sniper_Resnov_wait;
	
	// EVENT 3
		
	level.scr_anim[ "hero" ][ "patrol_walk" ]			 	  = %patrol_bored_patrolwalk;
	
	level.scr_anim["redshirt"]["postbb_redshirt1"]		= %ch_sniper_ladder_redshirt1;
	level.scr_anim["redshirt"]["postbb_redshirt2"]		= %ch_sniper_ladder_redshirt2;
	level.scr_anim["redshirt"]["postbb_redshirt3"]		= %ch_sniper_ladder_redshirt3;
	
	level.scr_anim["hero"]["postbb_hero"]							= %ch_sniper_ladder_resnov;
	level.scr_anim[ "hero" ][ "kicked_vignette" ]			= %ch_sniper_Resnov_kicked;
	level.scr_anim[ "hero" ][ "kicked_loop" ][0]			= %ch_sniper_Resnov_kicked_loop;
	
	level.scr_anim["hero"]["resnov_splain"]						= %ch_sniper_resnov_explain;
	level.scr_anim["hero"]["resnov_splain_loop"][0]		= %ch_sniper_resnov_explain_loop;	


	// EVENT 4

	level.scr_anim[ "hero"][ "tankblast_dive" ]												= %ch_sniper_Resnov_clock_dive;
	level.scr_anim["hero"][ "door_open3" ]														= %ch_holland3_door_bash;
	level.scr_anim["hero"][ "swimming" ][0]														= %ch_pby_float1;

	level.scr_anim[ "hero"]["reznov_cheer_dive"]											= %ch_sniper_resnov_cheer_dive;
	level.scr_anim[ "hero"]["reznov_cheer"]														= %ch_sniper_resnov_cheer;
	level.scr_anim["hero"]["reznov_fall_towater"]											= %ch_sniper_resnov_last_fall;
	level.scr_anim[ "hero"]["reznov_jump_towater"]										= %ch_sniper_resnov_last_jump;
	level.scr_anim["hero"]["rambov" ]																	= %ch_sniper_resnov_runandshoot;
	level.scr_anim["hero"]["reznov_jump_towater_loop" ][0]						= %ch_sniper_resnov_last_jump_loop;			
	level.scr_anim["hero"]["reznov_jump_towater_loop_reach" ]					= %ch_sniper_resnov_last_jump_loop;			
			
	//level.scr_anim["hero"]["reznov_talk_more" ]					= %generic_talker_allies;			
					

	////////////////////////////////////////DIALOGUE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	

	level.scr_sound["hero"]["shh"]									= "Sni1_IGD_000A_REZN";
	level.scr_sound["hero"]["need_help"]						= "Sni1_IGD_001A_REZN";
	level.scr_sound["hero"]["stay_low"]							= "Sni1_IGD_002A_REZN";
	level.scr_sound["hero"]["take_rifle"]						= "Sni1_IGD_003B_REZN";
	level.scr_sound["hero"]["mudak"]								= "Sni1_IGD_004A_REZN";
	level.scr_sound["hero"]["city_fallen"]					= "Sni1_IGD_005A_REZN";
	level.scr_sound["hero"]["hes_lucky"]						= "Sni1_IGD_006A_REZN";
	level.scr_sound["hero"]["fingers_torn"]					= "Sni1_IGD_007A_REZN";
	level.scr_sound["hero"]["load_rifle"]						= "Sni1_IGD_008A_REZN";
	level.scr_sound["hero"]["wait_overhead"]				= "Sni1_IGD_009A_REZN";
	level.scr_sound["hero"]["engines_drown"]				= "Sni1_IGD_010A_REZN";
	level.scr_sound["hero"]["like_hunting"]					= "Sni1_IGD_011A_REZN";
	level.scr_sound["hero"]["wrong_time"]						= "Sni1_IGD_012A_REZN";
	level.scr_sound["hero"]["not_time"]							= "Sni1_IGD_013A_REZN";
	level.scr_sound["hero"]["not_yet"]							= "Sni1_IGD_014A_REZN";
	level.scr_sound["hero"]["shootnow"]								= "Sni1_IGD_015A_REZN";
	level.scr_sound["hero"]["again"]								= "Sni1_IGD_016A_REZN";
	level.scr_sound["hero"]["moreright"]						= "Sni1_IGD_017A_REZN";
	level.scr_sound["hero"]["moreleft"]						= "Sni1_IGD_018A_REZN";
	level.scr_sound["hero"]["aimleft"]							= "Sni1_IGD_019A_REZN";
	level.scr_sound["hero"]["aimright"]							= "Sni1_IGD_020A_REZN";
	level.scr_sound["hero"]["straight"]							= "Sni1_IGD_021A_REZN";
	level.scr_sound["hero"]["4stillstand"]					= "Sni1_IGD_022A_REZN";
	level.scr_sound["hero"]["hurry"]								= "Sni1_IGD_023A_REZN";
	level.scr_sound["hero"]["ha"]									= "Sni1_IGD_024A_REZN";
	level.scr_sound["hero"]["3_remain"]							= "Sni1_IGD_025A_REZN";
	level.scr_sound["hero"]["dog"]									= "Sni1_IGD_026A_REZN";
	level.scr_sound["hero"]["could_b_quicker"]			= "Sni1_IGD_027A_REZN";
	level.scr_sound["hero"]["aim_good"]							= "Sni1_IGD_028A_REZN";
	level.scr_sound["hero"]["excellent_aim"]				= "Sni1_IGD_029A_REZN";
	level.scr_sound["hero"]["close_in"]							= "Sni1_IGD_030A_REZN";
	level.scr_sound["hero"]["chyort"]								= "Sni1_IGD_031A_REZN";
	level.scr_sound["hero"]["armor_patrol"]					= "Sni1_IGD_032A_REZN";
	level.scr_sound["hero"]["b4_discover_dead"]			= "Sni1_IGD_033A_REZN";
	level.scr_sound["hero"]["real_hunt_begin"]			= "Sni1_IGD_034A_REZN";
	level.scr_sound["hero"]["like_rat"]							= "Sni1_IGD_035A_REZN";
	level.scr_sound["hero"]["get_chance"]						= "Sni1_IGD_036A_REZN";
	level.scr_sound["hero"]["friends_lovers"]				= "Sni1_IGD_037A_REZN";
	level.scr_sound["hero"]["no_longer"]						= "Sni1_IGD_038A_REZN";
	level.scr_sound["hero"]["mark_mywords"]					= "Sni1_IGD_039A_REZN";
	level.scr_sound["hero"]["things_change"]				= "Sni1_IGD_040A_REZN";
	level.scr_sound["hero"]["their_blood"]					= "Sni1_IGD_041A_REZN";
	level.scr_sound["hero"]["this_way2"]						= "Sni1_IGD_042A_REZN";
	level.scr_sound["hero"]["know_routines"]				= "Sni1_IGD_043A_REZN";
	level.scr_sound["hero"]["creature_of_habit"]		= "Sni1_IGD_044A_REZN";
	level.scr_sound["hero"]["inspects_each"]				= "Sni1_IGD_045A_REZN";
	level.scr_sound["hero"]["use_building"]					= "Sni1_IGD_046A_REZN";
	level.scr_sound["hero"]["sniper"]								= "Sni1_IGD_047A_REZN";
	level.scr_sound["hero"]["inside"]								= "Sni1_IGD_048A_REZN";
	level.scr_sound["hero"]["almost_got"]						= "Sni1_IGD_049A_REZN";
	level.scr_sound["hero"]["follow_me"]						= "Sni1_IGD_050A_REZN";
	level.scr_sound["hero"]["cross_river"]					= "Sni1_IGD_051A_REZN";
	level.scr_sound["hero"]["cat_mouse"]						= "Sni1_IGD_052A_REZN";
	level.scr_sound["hero"]["draw_fire"]						= "Sni1_IGD_053A_REZN";
	level.scr_sound["hero"]["ready"]								= "Sni1_IGD_054A_REZN";
	level.scr_sound["hero"]["now"]									= "Sni1_IGD_055A_REZN";
	level.scr_sound["hero"]["4_floor_r"]						= "Sni1_IGD_056A_REZN";
	level.scr_sound["hero"]["3_floor_r"]						= "Sni1_IGD_057A_REZN";
	level.scr_sound["hero"]["4_floor_l"]						= "Sni1_IGD_058A_REZN";
	level.scr_sound["hero"]["3_floor_l"]						= "Sni1_IGD_059A_REZN";
	level.scr_sound["hero"]["draw_fire_again"]			= "Sni1_IGD_060A_REZN";
	level.scr_sound["hero"]["chyort2"]							= "Sni1_IGD_061A_REZN";
	level.scr_sound["hero"]["see_him"]							= "Sni1_IGD_062A_REZN";
	level.scr_sound["hero"]["he_knows"]							= "Sni1_IGD_063A_REZN";
	level.scr_sound["hero"]["cant_risk_it"]					= "Sni1_IGD_064A_REZN";
	level.scr_sound["hero"]["stay_out_light"]				= "Sni1_IGD_065A_REZN";
	level.scr_sound["hero"]["get_to_window"]				= "Sni1_IGD_066A_REZN";
	level.scr_sound["hero"]["find_cover"]						= "Sni1_IGD_067A_REZN";
	level.scr_sound["hero"]["u_pinned"]							= "Sni1_IGD_068A_REZN";
	level.scr_sound["hero"]["move"]									= "Sni1_IGD_069A_REZN";
	level.scr_sound["hero"]["good_hunting"]					= "Sni1_IGD_070A_REZN";
	level.scr_sound["hero"]["patrols_heard"]				= "Sni1_IGD_071A_REZN";
	level.scr_sound["hero"]["need_tomove"]					= "Sni1_IGD_072A_REZN";
	level.scr_sound["hero"]["shh_patrol"]						= "Sni1_IGD_073A_REZN";
	level.scr_sound["hero"]["found_us"]							= "Sni1_IGD_074A_REZN";
	level.scr_sound["hero"]["we_need_toleave"]			= "Sni1_IGD_075A_REZN";
	level.scr_sound["hero"]["hit_floor"]						= "Sni1_IGD_076A_REZN";
	level.scr_sound["hero"]["burn_us_out"]					= "Sni1_IGD_077A_REZN";
	level.scr_sound["hero"]["stay_low_dontbreathe"]	= "Sni1_IGD_078A_REZN";
	level.scr_sound["hero"]["jump"]									= "Sni1_IGD_079A_REZN";
	level.scr_sound["hero"]["do_wut_i_say"]					= "Sni1_IGD_100A_REZN";
	level.scr_sound["hero"]["injured_hand"]					= "Sni1_IGD_101A_REZN";
	level.scr_sound["hero"]["if_we_reveal"]					= "Sni1_IGD_102A_REZN";
	level.scr_sound["hero"]["amsel_is_inside"]			= "Sni1_IGD_103A_REZN";
	level.scr_sound["hero"]["u_gave_away"]					= "Sni1_IGD_104A_REZN";
	level.scr_sound["hero"]["our_chance_is_lost"]		= "Sni1_IGD_105A_REZN";
	level.scr_sound["hero"]["get_over_here"]				= "Sni1_IGD_106A_REZN";
	level.scr_sound["hero"]["stay_down"]						= "Sni1_IGD_107A_REZN";
	level.scr_sound["hero"]["u_gave_away_ur"]				= "Sni1_IGD_108A_REZN";
	level.scr_sound["hero"]["shots_tell_him"]				= "Sni1_IGD_109A_REZN";

		
	level.scr_sound["hero"]["burning_car"]									= "Sni1_IGD_200A_REZN";
	level.scr_sound["hero"]["bystairs"]											= "Sni1_IGD_201A_REZN";
	level.scr_sound["hero"]["its_too_late"]									= "Sni1_IGD_203A_REZN";
	level.scr_sound["hero"]["u_should_take_chance"]					= "Sni1_IGD_204A_REZN";
	level.scr_sound["hero"]["u_let_chance_slip"]						= "Sni1_IGD_205A_REZN";
	level.scr_sound["hero"]["let_them_pass"]						= "Sni1_IGD_207A_REZN";	
	level.scr_sound["hero"]["b4_burned_alive"]							= "Sni1_IGD_208A_REZN";		
	level.scr_sound["hero"]["they_r_surround"]							= "Sni1_IGD_209A_REZN";	
	level.scr_sound["hero"]["we_must_hurry"]								= "Sni1_IGD_212A_REZN";	
	level.scr_sound["hero"]["move_upstairs"]								= "Sni1_IGD_213A_REZN";	
	level.scr_sound["hero"]["need_find_way_out"]						= "Sni1_IGD_214A_REZN";	
	level.scr_sound["hero"]["take_my_hand"]									= "Sni1_IGD_215A_REZN";	
	level.scr_sound["hero"]["need_u_alive"]									= "Sni1_IGD_216A_REZN";	

	level.scr_sound["hero"]["Dimitri"]											= "Sni1_IGD_300A_DALE";	
	level.scr_sound["hero"]["thought_u_dead"]								= "Sni1_IGD_301A_DALE";
	level.scr_sound["hero"]["among_but_not1"]								= "Sni1_IGD_302A_REZN";		
	level.scr_sound["hero"]["assault_com_post"]							= "Sni1_IGD_303A_DALE";		
	level.scr_sound["hero"]["prevent_calling"]							= "Sni1_IGD_304A_REZN";
	
	level.scr_sound["hero"]["wait_for_screams"]							= "Sni1_IGD_305A_REZN";
	level.scr_sound["hero"]["dimitri_this_way"]							= "Sni1_IGD_306A_REZN";	
	level.scr_sound["hero"]["do_u_see_flame"]								= "Sni1_IGD_307A_REZN";	
	
	
	level.scr_sound["hero"]["choose_moment"]								= "Sni1_IGD_308A_REZN";	
	level.scr_sound["hero"]["incinerate_anyone"]						= "Sni1_IGD_309A_REZN";	
	level.scr_sound["hero"]["no_time_to_waste"]							= "Sni1_IGD_310A_REZN";	
	level.scr_sound["hero"]["take_the_shot"]								= "Sni1_IGD_311A_REZN";	
	level.scr_sound["hero"]["shoot_fuel_tank"]							= "Sni1_IGD_312A_REZN";	
	level.scr_sound["hero"]["belly_laugh1"]									= "Sni1_IGD_315A_REZN";		
	level.scr_sound["hero"]["another_flamer"]								= "Sni1_IGD_316A_REZN";	
	level.scr_sound["hero"]["give_covering_fire"]						= "Sni1_IGD_317A_REZN";	
	level.scr_sound["hero"]["keep_firing"]									= "Sni1_IGD_321A_REZN";	
	level.scr_sound["hero"]["more_infantry"]								= "Sni1_IGD_322A_REZN";	
	level.scr_sound["hero"]["mg_2nd_floor"]									= "Sni1_IGD_323A_REZN";		
	level.scr_sound["hero"]["left_balcony"]									= "Sni1_IGD_324A_REZN";	
	level.scr_sound["hero"]["more_high_balcony"]						= "Sni1_IGD_325A_REZN";	
	level.scr_sound["hero"]["friends_moving_up"]						= "Sni1_IGD_326A_REZN";
	level.scr_sound["hero"]["up_stairs_quickly"]						= "Sni1_IGD_327A_REZN";	
	level.scr_sound["hero"]["over_here_lipsmack"]						= "Sni1_IGD_328A_REZN";	
	
	
	level.scr_sound["hero"]["heart_beat_faster"]						= "Sni1_IGD_329A_REZN";	
	level.scr_sound["hero"]["amsel_soon_insights"]					= "Sni1_IGD_330A_REZN";	
	level.scr_sound["hero"]["rrrip_vermin"]									= "Sni1_IGD_332A_REZN";			
	level.scr_sound["hero"]["take_out_ht_mg"]								= "Sni1_IGD_333A_REZN";			
	level.scr_sound["hero"]["when_our_comrades"]						= "Sni1_IGD_334A_REZN";			
	level.scr_sound["hero"]["cut_off"]											= "Sni1_IGD_335A_REZN";		
	level.scr_sound["hero"]["building_wit_flags"]						= "Sni1_IGD_336A_REZN";			
	level.scr_sound["hero"]["he_will_be_inside"]						= "Sni1_IGD_337A_REZN";	
	level.scr_sound["hero"]["mudaks_appetite"]							= "Sni1_IGD_338A_REZN";	
	level.scr_sound["hero"]["vermin_has_no_right"]					= "Sni1_IGD_339A_REZN";
	level.scr_sound["hero"]["battle_will_flush"]						= "Sni1_IGD_340A_REZN";	
	level.scr_sound["hero"]["try_to_call"]									= "Sni1_IGD_341A_REZN";	
	level.scr_sound["hero"]["he_will_run"]									= "Sni1_IGD_342A_REZN";		
	level.scr_sound["hero"]["coward_there"]									= "Sni1_IGD_343A_REZN";	
	level.scr_sound["hero"]["do_not_let"]										= "Sni1_IGD_344A_REZN";			
	level.scr_sound["hero"]["he_is_behind_truck"]						= "Sni1_IGD_345A_REZN";									
	level.scr_sound["hero"]["shoot!"]												= "Sni1_IGD_347A_REZN";	
	level.scr_sound["hero"]["kill_him"]											= "Sni1_IGD_348A_REZN";
	level.scr_sound["hero"]["sins_not_go"]									= "Sni1_IGD_349A_REZN";	
	level.scr_sound["hero"]["quickly!"]											= "Sni1_IGD_350A_REZN";	
	level.scr_sound["hero"]["good"]													= "Sni1_IGD_351A_REZN";
	level.scr_sound["hero"]["very_good"]										= "Sni1_IGD_352A_REZN";	
	level.scr_sound["hero"]["struck_a_great_blow"]					= "Sni1_IGD_353A_REZN";	
	level.scr_sound["hero"]["cut_head_from_snake"]					= "Sni1_IGD_354A_REZN";	
	//level.scr_sound["hero"]["into_river"]										= "Sni1_IGD_359A_REZN";				
	level.scr_sound["hero"]["run!"]													= "Sni1_IGD_357A_REZN";	
	level.scr_sound["hero"]["this_way!"]										= "Sni1_IGD_358A_REZN";						
								
	level.scr_sound["hero"]["true_marksman"]								= "Sni1_IGD_400A_REZN";				
	level.scr_sound["hero"]["excel_aim_D"]									= "Sni1_IGD_401A_REZN";
	level.scr_sound["hero"]["theyre_retreating"]						= "Sni1_IGD_402A_DALE";
	level.scr_sound["hero"]["forward"]											= "Sni1_IGD_403A_DALE";
	level.scr_sound["hero"]["charge"]												= "Sni1_IGD_404A_DALE";		
	level.scr_sound["hero"]["ura"]													= "Sni1_IGD_405A_DALE";				
	level.scr_sound["hero"]["cover_comrades"]								= "Sni1_IGD_406A_REZN";
	level.scr_sound["hero"]["friends_need_cover"]						= "Sni1_IGD_407A_REZN";
	level.scr_sound["hero"]["we_not_let"]										= "Sni1_IGD_408A_REZN";
	level.scr_sound["hero"]["nothing_wecando"]							= "Sni1_IGD_409A_REZN";		
	level.scr_sound["hero"]["too_close_to_amsel"]						= "Sni1_IGD_410A_REZN";				
	level.scr_sound["hero"]["hes_not_alone"]								= "Sni1_IGD_411A_REZN";
	level.scr_sound["hero"]["put_bullet_in_bodyguard"]			= "Sni1_IGD_412A_REZN";
	level.scr_sound["hero"]["behind_tank"]									= "Sni1_IGD_413A_REZN";
	level.scr_sound["hero"]["behind_artillery"]							= "Sni1_IGD_414A_REZN";		
	level.scr_sound["hero"]["behind_car"]										= "Sni1_IGD_415A_REZN";				
	level.scr_sound["hero"]["getting_into_car"]							= "Sni1_IGD_416A_REZN";
	level.scr_sound["hero"]["shoot_driver"]									= "Sni1_IGD_417A_REZN";
	level.scr_sound["hero"]["we_must_go"]										= "Sni1_IGD_419A_REZN";	
	level.scr_sound["hero"]["before_tank_fires_again"]			= "Sni1_IGD_420A_REZN";	
	level.scr_sound["hero"]["into_river"]										= "Sni1_IGD_421A_REZN";
	level.scr_sound["hero"]["go"]														= "Sni1_IGD_422A_REZN";	
								
							
	level.scr_sound["hero"]["over_here"]						= "Sni1_IGD_500A_REZN";
	level.scr_sound["hero"]["they_will_see_you"]		= "Sni1_IGD_501A_REZN";
	level.scr_sound["hero"]["stay_close"]						= "Sni1_IGD_502A_REZN";
	level.scr_sound["hero"]["try_get_killed"]				= "Sni1_IGD_503A_REZN";
	level.scr_sound["hero"]["stay_near"]						= "Sni1_IGD_504A_REZN";
	level.scr_sound["hero"]["u_fool"]								= "Sni1_IGD_505A_REZN";
	level.scr_sound["hero"]["cant_afford"]					= "Sni1_IGD_506A_REZN";
	level.scr_sound["hero"]["nearly_ruined"]				= "Sni1_IGD_507A_REZN";
	level.scr_sound["hero"]["sniper_stay_hidden"]		= "Sni1_IGD_508A_REZN";
	level.scr_sound["hero"]["dont_draw_attention"]	= "Sni1_IGD_509A_REZN";
	level.scr_sound["hero"]["kill_amsel"]						= "Sni1_IGD_510A_REZN";
	level.scr_sound["hero"]["move_quietly"]					= "Sni1_IGD_511A_REZN";
	
	
	
	// "There - The building with the banners! "
	level.scr_sound["hero"]["build_with_banners"] 				= "Sni1_IGD_700A_REZN";
		// "Bring up the flamethrower."
	level.scr_sound["german_redshirt"]["bring_flamer"] 			= "Sni1_IGD_701A_GER1";
	// "Burn these Russian pigs."
	level.scr_sound["german_redshirt"]["burn_them"] 			= "Sni1_IGD_702A_GER1";
	// "Our comrades are clearing the building! Watch your fire!"
	level.scr_sound["hero"]["comrades_clearing"]				  = "Sni1_IGD_703A_REZN";
	// "Follow me... I know a perfect sniping position overlooking the command post."
	level.scr_sound["hero"]["perfect_spot"]								= "Sni1_IGD_704A_REZN";
	// "Hold fire!"
	level.scr_sound["hero"]["hold_fire"]				 					= "Sni1_IGD_705A_REZN";
	// "Their sacrifice will not go unavenged…"
	level.scr_sound["hero"]["sacrafice"] 				 				  = "Sni1_IGD_706A_REZN";
	// "The death of General Amsel will be just the beginning…"
	level.scr_sound["hero"]["amsels_death"]				 				= "Sni1_IGD_707A_REZN";
	// "He's hiding behind the destroyed tank!"
	level.scr_sound["hero"]["hide_tank"]				 				  = "Sni1_IGD_708A_REZN";
	// "He's using the destroyed tank for cover!"
	level.scr_sound["hero"]["hide_tank2"] 				 				= "Sni1_IGD_709A_REZN";
	// "There! At the burning truck!"
	level.scr_sound["hero"]["hide_truck"]				 				  = "Sni1_IGD_710A_REZN";
	// "He's using the burning truck for cover!"
	level.scr_sound["hero"]["hide_truck2"]				 				= "Sni1_IGD_711A_REZN";
	// "He's cowering behind the artillery piece!"
	level.scr_sound["hero"]["hide_flak"]				 				  = "Sni1_IGD_712A_REZN";
	// "His bodyguard has a sniper rifle!"
	level.scr_sound["hero"]["bodyguard_sniper"]				    = "Sni1_IGD_715A_REZN";
	// "He is firing on us!"
	level.scr_sound["hero"]["bodyguard_firing"]				    = "Sni1_IGD_716A_REZN";
	// "Kill him!"
	level.scr_sound["hero"]["kill_him2"]				    	 	  = "Sni1_IGD_717A_REZN";
	// "You must first kill his sniper to get a clear shot!"
	level.scr_sound["hero"]["kill_bodyguard"]				 		  = "Sni1_IGD_718A_REZN";
	// "He is running!"
	level.scr_sound["hero"]["hes_running"]				 			  = "Sni1_IGD_719A_REZN";
	// "He is on the move!"
	level.scr_sound["hero"]["hes_on_move"] 				 				= "Sni1_IGD_720A_REZN";
	// "Amsel is running!"
	level.scr_sound["hero"]["amsel_running"]				 		  = "Sni1_IGD_721A_REZN";
	// "No... You have failed, Dimitri."
	level.scr_sound["hero"]["failed1"]				 				 	  = "Sni1_IGD_722A_REZN";
	// "Amsel still lives."
	level.scr_sound["hero"]["failed2"]				 				 	  = "Sni1_IGD_723A_REZN";
	// "Our chance is lost..."
	level.scr_sound["hero"]["failed3"]				 				 	  = "Sni1_IGD_724A_REZN";
	// "Armored car outside!  "
	level.scr_sound["hero"]["armored_car"]				 			  = "Sni1_IGD_725A_REZN";
	// "Keep moving before is tears us apart!"
	level.scr_sound["hero"]["keep_moving"]				 			  = "Sni1_IGD_726A_REZN";
	// "DIE! You scum sucking animals!!!  RRAAAAGH!!!"
	level.scr_sound["hero"]["rambov_yell"]				 			  = "Sni1_IGD_512A_REZN";

	// "It was just a decoy!"
	level.scr_sound["hero"]["just_decoy"]								  = "Sni1_IGD_800A_REZN";
	// "Stay focussed, Dimitri!"
	level.scr_sound["hero"]["stay_focused"]							  = "Sni1_IGD_801A_REZN";
	// "You winged him!"
	level.scr_sound["hero"]["winged_him"] 								= "Sni1_IGD_802A_REZN";
	// "You just grazed him!"
	level.scr_sound["hero"]["grazed_him"] 								= "Sni1_IGD_803A_REZN";
	// "He still lives - hit him again!"
	level.scr_sound["hero"]["he_still_lives"]						  = "Sni1_IGD_804A_REZN";
	// "This way, Comrades…"
	level.scr_sound["hero"]["this_way_coms"]				  = "Sni1_IGD_805A_DALE";
	// "Take positions and wait for the signal…"
	level.scr_sound["hero"]["take_positions"]				  = "Sni1_IGD_806A_DALE";
	// "You see?!! They will still die and now you have given away our position!"
	level.scr_sound["hero"]["still_die"] 								  = "Sni1_IGD_807A_REZN";
	// "No scope?!! Nice!"
	level.scr_sound["hero"]["noscope"] 									 	= "Sni1_IGD_808A_REZN";
	// "Only a marksman nails his target with no scope!"
	level.scr_sound["hero"]["only_marksman"]						  = "Sni1_IGD_809A_REZN";








	
	
/*
	level.scr_sound["nazi_talk"]["moveit"]					= "Sni1_IGD_600A_GER1";
	level.scr_sound["nazi_talk"]["you_think"]				= "Sni1_IGD_601A_GER1";
	level.scr_sound["nazi_talk"]["stay_still"]			= "Sni1_IGD_602A_GER1";
	level.scr_sound["nazi_talk"]["too_stupid"]			= "Sni1_IGD_603A_GER3";
*/
		//************************ UNUSED ********************\\
	level.scr_sound["hero"]["have_to_jump"]					= "Sni1_IGD_217A_REZN";	
	level.scr_sound["hero"]["cannot_stay_here"]			= "Sni1_IGD_218A_REZN";
	level.scr_sound["hero"]["more_flamers"]					= "Sni1_IGD_318A_REZN";
	level.scr_sound["hero"]["another_one"]					= "Sni1_IGD_319A_REZN";	
	level.scr_sound["hero"]["make_him_burn"]				= "Sni1_IGD_320A_REZN";




	lookat_notetracks();
	corpse_anims();
	level thread corpse_setup();
	level thread execution_corpse_setup();
	level thread do_collectible_corpse();
	crow_anims();
	chair_anim();
	dog_anims();
	vehicle_anims();
	drone_custom_run_cycles();
	bb_doors();
	level.gunnershots = 0;
	bardoor();
	beam_anims();
	viewmodel_anims();
	bookshelf_fall_anim();
	ceiling1_anim_setup();
	ceiling2_anim_setup();
	chandolier_anims_setup();
	chandolier_anims2_setup();
	chandolier2_anims_setup();
	downstairs_furnace_setup();
	curtain_anims();
	hat_anim();
	bar_exit();

}

#using_animtree ("fakeshooters");
drone_custom_run_cycles()
{	 
	level.drone_run_cycle["weary_walka"] 					= %Ai_walk_weary_a; 
	level.drone_run_cycle["weary_walkb"] 					= %Ai_walk_weary_a; 
	level.drone_run_cycle["weary_walkc"] 					= %Ai_walk_weary_a; 
	level.drone_run_cycle["weary_walkd"] 					= %Ai_walk_weary_a;
	level.drone_run_cycle["sneaking_walk"] 				= %ai_sneaking_a_walk; 
} 


#using_animtree("vehicles");
vehicle_anims()
{
	level.scr_anim[ "horch"]["horch_drive"]							= %v_horch1a_sniper_intro;
	level.scr_anim[ "horch"]["flat_back"]								= %v_horch1a_flattire_rb;
	level.scr_anim[ "horch"]["flat_front"]							= %v_horch1a_flattire_rf;
	level.scr_anim[ "horch"]["amsel_death"]							= %v_horch1a_amsel_die;	
	level.scr_anim[ "horch"]["amsel_in"]								= %v_horch1a_amsel_getin;
	level.scr_anim[ "horch"]["amsel_out"]								= %v_horch1a_amsel_getout;
}

#using_animtree( "dog" );
dog_anims()
{

	level.scr_anim[ "dog" ][ "fence_attack" ] 					= %sniper_escape_dog_fence;
	addNotetrack_sound( "dog", "sound_dog_attack_fence", "fence_attack", "brutie_woof" );

//	addNotetrack_sound( "dog", "sound_dog_attack_fence", "fence_attack", "anml_dog_attack_jump" );
}


hero_opendoor_3(guy)
{
	door = getent("factory_door", "targetname");
	door rotateyaw( -120, 0.4, 0.3, .1 );
	door connectpaths();
}

gun_flash(guy)
{
	gunspot = guy gettagorigin("tag_flash");
	ang = guy gettagangles("tag_flash");
	playfx(level._effect["fake_rifleflash"] , gunspot, anglestoforward(ang) );
}

notify_sniperfire(guy)
{
	guy notify ("sniperfire");
	if (flag("officers_sniper_onu"))
	{
		level thread officers_sniper_shoot_atyou();
	}
}


molotov_throw(guy)
{
	if (!isdefined(guy.enemy))
		return;
	target_pos = guy.enemy.origin;
		
		///////// Math
		gravity = GetDvarInt( "g_gravity" );
		gravity = gravity * -1;
		start_pos = self geteye()+ (0,0,20);
		dist = Distance(start_pos, target_pos );
		time = 1;
	
		delta = target_pos - start_pos;
		drop = 0.5 * gravity * ( time * time );
		velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
		/////////
		self MagicGrenadeType( "molotov", start_pos, velocity, 3 );
}

#using_animtree( "sniper_crows" );
chair_anim()
{
	PrecacheModel( "anim_berlin_wood_chair_2" );
	level.scr_animtree["chair"] = #animtree;	
	level.scr_model["chair"] = "anim_berlin_wood_chair_2";
	level.scr_anim["chair"]["grabbed"] = %o_sniper_horch_chair;
}

#using_animtree( "sniper_crows" );
crow_anims()
{	


	PrecacheModel( "anim_berlin_crow" );
	level.scr_model["crow"] = "anim_berlin_crow";
	level.scr_animtree["crow1_tree"] = #animtree;	
	level.scr_animtree["crow2_tree"] = #animtree;	
	level.scr_animtree["crow3_tree"] = #animtree;	
	level.scr_animtree["crow4_tree"] = #animtree;	
	level.scr_animtree["facecrow"] = #animtree;	

	level.scr_anim["crow1_tree"]["intro"] 		= %o_sniper_fountain_crow1_intro;
	level.scr_anim["crow1_tree"]["loop"] 			= %o_sniper_fountain_crow1_loop;
	level.scr_anim["crow1_tree"]["outtro"]	  = %o_sniper_fountain_crow1_outtro;
	level.scr_anim["crow2_tree"]["intro"] 	  = %o_sniper_fountain_crow2_intro;
	level.scr_anim["crow2_tree"]["loop"]  	  = %o_sniper_fountain_crow2_loop;
	level.scr_anim["crow2_tree"]["outtro"]	  = %o_sniper_fountain_crow2_outtro;
	level.scr_anim["crow3_tree"]["loop"] 			= %o_sniper_fountain_crow3_loop;
	level.scr_anim["crow3_tree"]["outtro"]	  = %o_sniper_fountain_crow3_outtro;
	level.scr_anim["crow4_tree"]["intro"] 		= %o_sniper_fountain_crow4_intro;
	level.scr_anim["crow4_tree"]["loop"] 			= %o_sniper_fountain_crow4_loop;
	level.scr_anim["crow4_tree"]["outtro"] 		= %o_sniper_fountain_crow4_outtro;
	level.scr_anim["facecrow"]["loop"] 				= %o_sniper_fountain_facecrow_loop;
	level.scr_anim["facecrow"]["outtro"] 			= %o_sniper_fountain_facecrow_outtro;	
}

play_glint_fx(guy)
{
	if (level.difficulty > 2)
	{
		return;
	}
	tag = "tag_flash";
	ang = guy gettagangles(tag);
	playfxontag(level._effect["scope_glint"], guy, tag);
}

horchguy2_chairanim(guy)
{
	existingchair = getent("anim_chair", "targetname");
	existingchair.script_linkto = "origin_animate_jnt";
	spot = maps\sniper::getstructent("anim_chair_spot", "targetname");
	anim_ents_solo( existingchair, "grabbed", undefined, undefined, spot, "chair" );
	spot delete();
}

chair_delete( guy )
{
	getent("anim_chair", "targetname") delete();
}

chair_replace( guy )
{
	orig = guy gettagorigin( "tag_weapon_left" );
	angles = guy gettagangles( "tag_weapon_left" );
	furniture = spawn( "script_model" , orig );
	furniture.angles = angles;
	furniture setmodel( "anim_berlin_wood_chair_2" );
}


play_feather_fx(crow)
{
	pos = crow gettagorigin("J_Head");
	playfx (level._effect["crow_feathers"], pos);
			//**TEMP playin on first crow because he couldnt be exported
	if (crow !=level.facecrow)
	{
		pos2 = level.crow1 gettagorigin("J_Head");
		playfx (level._effect["crow_feathers"], pos2);
	}
	
}

#using_animtree( "sniper_crows" );
corpse_setup()
{	
	wait_for_first_player();
	spot = getent("fountain_anim_spot", "targetname");
	corpses = [];
	for (i=1; i < 26; i++)
	{
		corpse = spawn( "script_model" , spot.origin );
		corpse character\char_rus_r_ppsh_forsniper::main();
		corpse UseAnimTree(#animtree);
		corpse.angles = spot.angles;
		corpse.animname = "deadguy";
		corpses = array_add(corpses, corpse);
		if (i==5 || i==6 || i==7 || i==8 || i==5 || i==1 || i==2 || i==4 || i==23 || i==24 || i==25)
		{
			corpse thread maps\sniper_event1::delete_at_gun_pickup();
		}

		//corpse.script_linkto = "tag_origin";
		spot thread anim_single_solo( corpse, "body"+i+"_death");
	}
	level waittill ("event2_started");
	for (i=0; i < corpses.size; i++)
	{
		if (isdefined(corpses[i]))
		{
			corpses[i] delete();
		}
	}

}

#using_animtree( "sniper_crows" );
execution_corpse_setup()
{	
	//wait_for_first_player();
	level waittill ("e2_sniper_dead");
	spot = getstruct("e3_bodypile_node", "targetname");
	for (i=1; i < 6; i++)
	{
		corpse = spawn( "script_model" , spot.origin );
		corpse character\char_rus_r_ppsh_forsniper::main();
		corpse UseAnimTree(#animtree);
		//corpse.angles = spot.angles;
		corpse.animname = "deadguy";
		//corpse.script_linkto = "tag_origin";
		spot thread anim_single_solo( corpse, "execution_death"+i);
	}
}


delete_in_e2()
{
	self endon ("death");
	flag_wait("outof_event1");
	self delete();
}


send_fire_notify(guy)
{
	flag_set("guy_fired");
}

gunner_fired_notify(guy)
{
	level notify ("gunner_fired");
}

#using_animtree( "sniper_crows" );
corpse_anims()
{
	level.scr_anim[ "deadguy_loop" ][ "body1" ][0]				= %ch_sniper_fountain_corpse1;
	level.scr_anim[ "deadguy" ][ "body1_death" ]					= %ch_sniper_fountain_corpse1;
	level.scr_anim[ "deadguy_loop" ][ "body2" ][0]				= %ch_sniper_fountain_corpse2;
	level.scr_anim[ "deadguy" ][ "body2_death" ]					= %ch_sniper_fountain_corpse2;
	level.scr_anim[ "deadguy_loop" ][ "body3" ][0]				= %ch_sniper_fountain_corpse3;
	level.scr_anim[ "deadguy" ][ "body3_death" ]					= %ch_sniper_fountain_corpse3;
	level.scr_anim[ "deadguy_loop" ][ "body4" ][0]				= %ch_sniper_fountain_corpse4;
	level.scr_anim[ "deadguy" ][ "body4_death" ]					= %ch_sniper_fountain_corpse4;
	level.scr_anim[ "deadguy_loop" ][ "body5" ][0]				= %ch_sniper_fountain_corpse5;
	level.scr_anim[ "deadguy" ][ "body5_death" ]					= %ch_sniper_fountain_corpse5;
	level.scr_anim[ "deadguy_loop" ][ "body6" ][0]				= %ch_sniper_fountain_corpse6;
	level.scr_anim[ "deadguy" ][ "body6_death" ]					= %ch_sniper_fountain_corpse6;
	level.scr_anim[ "deadguy_loop" ][ "body7" ][0]				= %ch_sniper_fountain_corpse7;
	level.scr_anim[ "deadguy" ][ "body7_death" ]					= %ch_sniper_fountain_corpse7;
	level.scr_anim[ "deadguy_loop" ][ "body8" ][0]				= %ch_sniper_fountain_corpse8;
	level.scr_anim[ "deadguy" ][ "body8_death" ]					= %ch_sniper_fountain_corpse8;
	level.scr_anim[ "deadguy_loop" ][ "body9" ][0]				= %ch_sniper_fountain_corpse9;
	level.scr_anim[ "deadguy" ][ "body9_death" ]					= %ch_sniper_fountain_corpse9;
	level.scr_anim[ "deadguy_loop" ][ "body10" ][0]				= %ch_sniper_fountain_corpse10;
	level.scr_anim[ "deadguy" ][ "body10_death" ]					= %ch_sniper_fountain_corpse10;
	level.scr_anim[ "deadguy_loop" ][ "body11" ][0]				= %ch_sniper_fountain_corpse11;
	level.scr_anim[ "deadguy" ][ "body11_death" ]					= %ch_sniper_fountain_corpse11;
	level.scr_anim[ "deadguy_loop" ][ "body12" ][0]				= %ch_sniper_fountain_corpse12;
	level.scr_anim[ "deadguy" ][ "body12_death" ]					= %ch_sniper_fountain_corpse12;
	level.scr_anim[ "deadguy_loop" ][ "body13" ][0]				= %ch_sniper_fountain_corpse13;
	level.scr_anim[ "deadguy" ][ "body13_death" ]					= %ch_sniper_fountain_corpse13;
	level.scr_anim[ "deadguy_loop" ][ "body14" ][0]				= %ch_sniper_fountain_corpse14;
	level.scr_anim[ "deadguy" ][ "body14_death" ]					= %ch_sniper_fountain_corpse14;
	level.scr_anim[ "deadguy_loop" ][ "body15" ][0]				= %ch_sniper_fountain_corpse15;
	level.scr_anim[ "deadguy" ][ "body15_death" ]					= %ch_sniper_fountain_corpse15;
	level.scr_anim[ "deadguy_loop" ][ "body16" ][0]				= %ch_sniper_fountain_corpse16;
	level.scr_anim[ "deadguy" ][ "body16_death" ]					= %ch_sniper_fountain_corpse16;
	level.scr_anim[ "deadguy_loop" ][ "body17" ][0]				= %ch_sniper_fountain_corpse17;
	level.scr_anim[ "deadguy" ][ "body17_death" ]					= %ch_sniper_fountain_corpse17;
	level.scr_anim[ "deadguy_loop" ][ "body18" ][0]				= %ch_sniper_fountain_corpse18;
	level.scr_anim[ "deadguy" ][ "body18_death" ]					= %ch_sniper_fountain_corpse18;
	level.scr_anim[ "deadguy_loop" ][ "body19" ][0]				= %ch_sniper_fountain_corpse19;
	level.scr_anim[ "deadguy" ][ "body19_death" ]					= %ch_sniper_fountain_corpse19;
	level.scr_anim[ "deadguy_loop" ][ "body20" ][0]				= %ch_sniper_fountain_corpse20;
	level.scr_anim[ "deadguy" ][ "body20_death" ]					= %ch_sniper_fountain_corpse20;
	level.scr_anim[ "deadguy_loop" ][ "body21" ][0]				= %ch_sniper_fountain_corpse21;
	level.scr_anim[ "deadguy" ][ "body21_death" ]					= %ch_sniper_fountain_corpse21;
	level.scr_anim[ "deadguy_loop" ][ "body22" ][0]				= %ch_sniper_fountain_corpse22;
	level.scr_anim[ "deadguy" ][ "body22_death" ]					= %ch_sniper_fountain_corpse22;
	level.scr_anim[ "deadguy_loop" ][ "body23" ][0]				= %ch_sniper_fountain_corpse23;
	level.scr_anim[ "deadguy" ][ "body23_death" ]					= %ch_sniper_fountain_corpse23;
	level.scr_anim[ "deadguy_loop" ][ "body24" ][0]				= %ch_sniper_fountain_corpse24;
	level.scr_anim[ "deadguy" ][ "body24_death" ]					= %ch_sniper_fountain_corpse24;
	level.scr_anim[ "deadguy_loop" ][ "body25" ][0]				= %ch_sniper_fountain_corpse25;
	level.scr_anim[ "deadguy" ][ "body25_death" ]					= %ch_sniper_fountain_corpse25;
	
	level.scr_anim[ "deadguy" ][ "execution_death1" ]			= %ch_sniper_executionwall_corpse1;
	level.scr_anim[ "deadguy" ][ "execution_death2" ]			= %ch_sniper_executionwall_corpse2;
	level.scr_anim[ "deadguy" ][ "execution_death3" ]			= %ch_sniper_executionwall_corpse3;
	level.scr_anim[ "deadguy" ][ "execution_death4" ]			= %ch_sniper_executionwall_corpse4;
	level.scr_anim[ "deadguy" ][ "execution_death5" ]			= %ch_sniper_executionwall_corpse5;
	
	level.scr_anim[ "collectible_dude" ][ "hes_dead" ]			= %ch_sniper_collectible;


}

#using_animtree( "sniper_crows" );
bb_doors()
{
	level.scr_animtree["leftdoor"]													= #animtree;
	level.scr_model["leftdoor"] 														= "tag_origin_animate"; 
	level.scr_anim["leftdoor"]["open"]											= %o_sniper_leftdoor_mannequin_out;	
	level.scr_animtree["rightdoor"]													= #animtree;
	level.scr_model["rightdoor"] 														= "tag_origin_animate"; 
	level.scr_anim["rightdoor"]["open"]	 										= %o_sniper_rightdoor_mannequin_out;	
	level.scr_anim[ "the_mannequin" ][ "pushfall" ]					= %o_sniper_mannequin;
}


	
place_rifle(guy)
{
	org = guy gettagorigin ("TAG_INHAND");
	ang = guy gettagangles ("TAG_INHAND");
	
	level.fakerifle = spawn("script_model", ( 102.523,736.641,24.301) );
	level.fakerifle.angles = (300.446,96.2887,69.3671);
	level.fakerifle setmodel("weapon_rus_mosinnagant_scoped_rifle");
	
	rifle = spawn("weapon_mosin_rifle_scoped", ( 102.523,736.641,24.301) );
	rifle hide();
	rifle.angles = (300.446,96.2887,69.3671);
	wait 0.01;
	level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");

}	

take_fake_ppsh(guy)
{
	org = guy gettagorigin ("TAG_INHAND");
	ang = guy gettagangles ("TAG_INHAND");
	level.hero animscripts\shared::placeweaponOn("ppsh", "right");
	level.fake_ppsh delete();
}

book_toss_r(guy)
{
	spot = getstruct("temp_book_spot", "targetname");
	org = guy gettagorigin("TAG_EYE");
	ang = spot.angles;

	playfx(level._effect["books_tossed"], org, anglestoforward(ang) );
}

book_toss_l(guy)
{
	spot = getstruct("temp_book_spot", "targetname");
	org = guy gettagorigin("tag_weapon_left");
	ang = spot.angles;

	playfx(level._effect["books_tossed"], org, anglestoforward(ang) );
}

mannequin_fall(guy)
{
	level.e2sniper endon ("death");
	level notify ("mannequin_fall");
	level waittill ("sniper_shot");
	flag_set ("mannequin_hit");
	playfx(level._effect["mannequin_shot"], level.mannequin_headspot);
	guy detach ("anim_berlin_mannequin", "tag_inhand");
	flag_clear("pushing_mannequin");
	flag_set("pushing_mannequin_d");
	guy attach ("anim_berlin_mannequin_d", "tag_inhand");
	wait 1.5;
	org = guy gettagorigin("tag_inhand");
	ang = guy gettagangles("tag_inhand");
	
	guy detach ("anim_berlin_mannequin_d", "tag_inhand");
	flag_clear("pushing_mannequin_d");
	mannequin = spawn ("script_model", org);
	mannequin.angles = ang;
	mannequin setmodel("anim_berlin_mannequin_d");
}

move_mannequin(guy)
{
	org = guy gettagorigin("tag_inhand");
	ang = guy gettagangles("tag_inhand");
	level.mannequin delete();
	flag_set("pushing_mannequin");
	guy attach ("anim_berlin_mannequin", "tag_inhand");
	
}




shot_effects(guy)
{
	struct1 = getstruct("blood_spurt_spot1", "targetname");
	struct2 = getstruct("blood_spurt_spot2", "targetname");
	if (level.gunnershots == 0 && !is_german_build() )
	{
		dude = getent("fountain_wounded_1", "targetname");
		org = dude gettagorigin("TAG_STOWED_BACK");
		//playfx(level._effect["bloodspurt_5shot"], struct1.origin);
		playfx(level._effect["bloodspurt_5shot"], org+(-15,0,-5));
	}
	if (level.gunnershots == 5 && !is_german_build())
	{
		dude = getent("fountain_wounded_2", "targetname");
		org = dude gettagorigin("TAG_STOWED_BACK");
		playfx(level._effect["bloodspurt_6shot"], org+(-15,20,0)); 
	}
	level.gunnershots++;
}
	


#using_animtree( "sniper_crows" );
bardoor()
{
	level.scr_animtree["bar_anim"]		= #animtree;
	level.scr_model["bar_anim"] 		= "tag_origin_animate"; 
	level.scr_anim["bar_anim"]["open"]	= %o_sniper_bar_door_open;	
	level.scr_anim["bar_anim"]["close"]	= %o_sniper_bar_door_closed;
}

bardoor_open(guy)
{
	flag_set("opening_bar_door");
	door = GetEnt( "bar_top", "targetname" );
	door ConnectPaths();
	door linkto (guy, "tag_weapon_left");
}

bardoor_stop(guy)
{
	
	door = GetEnt( "bar_top", "targetname" );
	door unlink();
	clips = getentarray("inside_bar_player_clips", "targetname");
	for (i=0; i < clips.size; i++)
	{
		clips[i] delete();
	}
	flag_clear("opening_bar_still");
	flag_clear("opening_bar_door");
	
}

#using_animtree( "sniper_crows" );
beam_anims()
{
	level.scr_animtree["beams"]			= #animtree;
	level.scr_model["beams"] 				= "anim_sniper_beam_fall"; 
	level.scr_anim["beams"]["fall"]	= %o_sniper_beam_fall;
	level.scr_anim["beams"]["move"]	= %o_sniper_beam_move;
	
}

test_time(guy)
{
	wait 1;
	wait 1;
}


#using_animtree( "player" );
viewmodel_anims()
{
	// Set the animtree
	level.scr_animtree[ "player_hands" ] 				= #animtree;	

	// Set the player hands
	level.scr_model[ "player_hands" ] 					= "viewmodel_rus_guardsinged_player";

	level.scr_anim[ "player_hands" ][ "fall" ]	= %int_sniper_beam_fall;
	level.scr_anim[ "player_hands" ][ "move" ]	= %int_sniper_beam_move;
	
}



beam_lift(guy)
{
	level notify ("beam_lift_time");
	beams = getentarray("beam_fall", "targetname");
	for (i=0; i < beams.size; i++)
	{
		beams[i].script_linkto = beams[i].script_noteworthy;
		beams[i].origin = beams[i].originalspot;
		beams[i].angles = beams[i].anglesspot;
	}
	
	newspot = getnode("bb_debris_align_node", "targetname");
	spot = spawn("script_model", newspot.origin);
	spot.angles = newspot.angles;
	spot setmodel("anim_sniper_beam_fall");
		
	level thread maps\_anim::anim_ents( beams, "move", undefined, undefined, spot, "beams" );
}

#using_animtree( "sniper_crows" );
bookshelf_fall_anim()
{
	level.scr_animtree["bookshelf"]			= #animtree;
	level.scr_model["bookshelf"] 				= "tag_origin_animate"; 
	level.scr_anim["bookshelf"]["fall"]	= %o_sniper_bookshelf_fall;
}

#using_animtree( "sniper_crows" );
ceiling1_anim_setup()
{
	level.scr_animtree["celing1_fall"]						= #animtree;
	level.scr_model["celing1_fall"] 							= "anim_sniper_ceiling_fall3"; 
	level.scr_anim[ "celing1_fall" ][ "fall" ]		= %o_sniper_ceiling_fall3;
}

#using_animtree( "sniper_crows" );
ceiling2_anim_setup()
{
	level.scr_animtree["celing2_fall"]						= #animtree;
	level.scr_model["celing2_fall"] 							= "anim_sniper_ceiling_fall2"; 
	level.scr_anim[ "celing2_fall" ][ "fall" ]		= %o_sniper_ceiling_fall2;
}


#using_animtree( "player" );
player_beam_anims(guy)
{
	level.player SetViewModel( "viewmodel_rus_guardsinged_arms" );
	flag_set("boards_onu");
	players = get_players();
	player = get_players()[0];
	
		// Spawn in the player hands
	player_hands = spawn_anim_model( "player_hands" );
	player_hands hide();
	player_hands.animname= "player_hands";
		
	node = getnode("bb_debris_align_node", "targetname");
	player_hands.origin = node.origin;
	player_hands.angles = node.angles;
	
	//player PlayerLinkTo( player_hands, "tag_player", 1.75, 0, 0, 0, 0 );
	
		// put the player_hands in the first frame so the tags are in the right place
	node maps\_anim::anim_first_frame_solo( player_hands, "fall" );

	
		// this smoothly hooks the player up to the animating tag
	players[0] lerp_player_view_to_tag( player_hands, "tag_player", 0.1, 1, 20, 20, 10, 10 );
	//players[0] playerlinktoabsolute(player_hands, "tag_player");
	//players[0] playerlinktoabsolute( player_hands);
	players[0] DisableWeapons();
	// now animate the tag and then unlink the player when the animation ends
	player_hands show();
	
	
	node anim_single_solo( player_hands, "fall" );

	//players[0] unlink();
	//node maps\_anim::anim_first_frame_solo( player_hands, "move" );
	//players = get_players();
	
		// this smoothly hooks the player up to the animating tag
	//players[0] lerp_player_view_to_tag( player_hands, "tag_player", 0.1, 1, 35, 35, 45, 0 );
	//players[0] playerlinktoabsolute( player_hands);
	// now animate the tag and then unlink the player when the animation ends

	
	animtime = getanimlength(level.scr_anim["player_hands"]["move"]);	
	node maps\_anim::anim_single_solo( player_hands, "move" );

	player_hands delete();
	players[0] unlink();
	
	level notify ("player_up");
	flag_set("player_up_after_fall");
	flag_clear("boards_onu");
	wait 1;
	level thread maps\sniper::say_dialogue("need_find_way_out");
	level thread maps\sniper_event2::larry_the_limper();
}

shake_player_effect(guy)
{
	player = level.player;
	earthquake(0.5,0.3, level.player.origin, 300);
	level.player playrumbleonentity("explosion_generic");
	player shellshock( "tankblast", 2 );
	player setburn(0.5);
	//get_players()[0] setblur( 1, 0.5 );
	player dodamage(1,player.origin+(0,0,20));
	wait 0.5;
	//get_players()[0] setblur( 0, 0.5 );
	player dodamage(1,player.origin+(0,0,20));
	wait 1;
	player dodamage(1,player.origin+(0,0,20));
	player setburn(0.1);
	wait 2.7;
	player setburn(0.1);
	player dodamage(1,player.origin+(0,0,20));
	//get_players()[0] setblur( 0, 0.5 );
	wait 2;
	//player setburn(1.5);
	//player dodamage(1,player.origin+(0,0,20));
	//player dodamage(1,player.origin+(0,0,20));
	wait 3;
	//player setburn(1.5);
}

call_resnov(guy)
{
	level notify ("resnov_save_u_go");
}

chandolier_fall_notify(guy)
{
	level notify ("chand_fall_check");
}

#using_animtree( "sniper_crows" );
chandolier_anims_setup()
{
	
	level.scr_animtree["chandelier"]						= #animtree;
	level.scr_model["chandelier"] 							= "anim_berlin_chandelier01"; 
	level.scr_anim[ "chandelier" ][ "loop" ]		= %o_sniper_chandelier_loop;
	level.scr_anim[ "chandelier" ][ "fall" ]		= %o_sniper_chandelier_fall;
}
	
#using_animtree( "sniper_crows" );
chandolier_anims2_setup()
{
	level.scr_animtree["chandelier_frame"]						= #animtree;
	level.scr_model["chandelier_frame"] 							= "anim_sniper_chandelier_fall"; 
	level.scr_anim[ "chandelier_frame" ][ "fall" ]		= %o_sniper_chandelierframe_fall;
}

#using_animtree( "sniper_crows" );
chandolier2_anims_setup()
{
	level.scr_animtree["chandelier_2"]						= #animtree;
	level.scr_model["chandelier_2"] 							= "anim_berlin_chandelier01"; 
	level.scr_anim["chandelier_2"]["shake"] 			= %o_berlin3_chandelier;
}

#using_animtree( "sniper_crows" );
downstairs_furnace_setup()
{
	level.scr_animtree["dstairs_pipe"]						= #animtree;
	level.scr_model["dstairs_pipe"] 							= "anim_sniper_pipe_bust"; 
	level.scr_anim[ "dstairs_pipe" ][ "shoot" ]		= %o_sniper_pipe_bust;
}

open_slow_door(guy)
{
	level thread maps\sniper::delete_spots();
	spot = maps\sniper::getstructent("door1_node", "targetname");
	door = getent("door1", "targetname");
	door UseAnimTree(#animtree);
	door.script_linkto = "origin_animate_jnt";
	level notify ("door_out_opened");
	flag_clear("player_in_shop");
	anim_ents_solo( door, "open", undefined, undefined, door, "bardoor" );
	door connectpaths();
	spot delete();
}

#using_animtree( "sniper_crows" );
curtain_anims()
{
	level.scr_animtree["curtain"]						= #animtree;
	level.scr_model["curtain"] 							= "anim_berlin_curtain_beige_d"; 

	level.scr_anim["curtain"][ "calm_loop1" ][0]							= %o_sniper_curtain_calm_loop;
	level.scr_anim["curtain"][ "calm_loop2" ][0]							= %o_sniper_curtain_calm_loop2;
	level.scr_anim["curtain"][ "calm_loop3" ][0]							= %o_sniper_curtain_calm_loop3;
	level.scr_anim["curtain"][ "calm_loop4" ][0]							= %o_sniper_curtain_calm_loop4;
	level.scr_anim["curtain"][ "flaming_intro1" ]									= %o_sniper_curtain_flaming_intro;
	level.scr_anim["curtain"][ "flaming_intro2" ]									= %o_sniper_curtain_flaming_intro2;
	level.scr_anim["curtain"][ "flaming_intro3" ]									= %o_sniper_curtain_flaming_intro3;
	level.scr_anim["curtain"][ "flaming_intro4" ]									= %o_sniper_curtain_flaming_intro4;
	level.scr_anim["curtain"][ "flaming_loop1" ]									= %o_sniper_curtain_flaming_loop;
	level.scr_anim["curtain"][ "flaming_loop2" ]									= %o_sniper_curtain_flaming_loop2;
	level.scr_anim["curtain"][ "flaming_loop3" ]									= %o_sniper_curtain_flaming_loop3;
	level.scr_anim["curtain"][ "flaming_loop4" ]									= %o_sniper_curtain_flaming_loop4;
	level.scr_anim["curtain"][ "flaming_outtro1" ]									= %o_sniper_curtain_flaming_outtro;
	level.scr_anim["curtain"][ "flaming_outtro2" ]									= %o_sniper_curtain_flaming_outtro2;
	level.scr_anim["curtain"][ "flaming_outtro3" ]									= %o_sniper_curtain_flaming_outtro3;
	level.scr_anim["curtain"][ "flaming_outtro4" ]									= %o_sniper_curtain_flaming_outtro4;

}


bookcase_fx(guy)
{
	spot = getstruct("bookcase_fall_fx", "targetname");
	playfx(level._effect["bookcase_bounce"], spot.origin);
	earthquake(0.5,0.5, level.player.origin, 300);
}

spawn_alley_leader(guy)
{
	flag_set("alley_leader_animate");
}

spawn_alley_flamer(guy)
{
	spawner = getent("e3_alley_findu_guys2", "targetname");
	spawner stalingradspawn();
}

end_burst(guy)
{
	wait 0.2;
		
	guy notify( "flame stop shoot" );
	guy StopShoot();
}

killme(guy)
{
	guy.health = 5;
	guy stopanimscripted();
	spot = maps\sniper::getstructent(guy.script_noteworthy+"_shotspot", "script_noteworthy");
	shots = 7;
	for (i=0; i < shots; i++)
	{
		offset = randomintrange(3,9);
		bheight = randomintrange(1,25);
		endpoint = self.origin+(offset,offset, bheight);
		vec = spot.origin - endpoint;
		nvec = vectornormalize(vec);
		endpoint = endpoint + (nvec * -1000);
		magicbullet("ppsh", spot.origin,endpoint );
		bullettracer(spot.origin, endpoint, 1);
		guy dodamage(1,spot.origin);
		wait 0.11;
	}	
}



switch_weapon_out(guy)
{
	org = guy gettagorigin("tag_weapon_right");
	ang = guy gettagangles("tag_weapon_right");
	
	level.fake_ppsh2 = spawn("script_model", org );
	level.fake_ppsh2.angles = ang;
	level.fake_ppsh2 setmodel("weapon_rus_ppsh_smg");
	
	level.hero animscripts\shared::placeweaponOn(level.hero.weapon, "none");
}

redshirt_pickup_gun(guy)
{
	guy attach ("weapon_rus_ppsh_smg", "tag_inhand");
	if (isdefined(level.fake_ppsh2) )
	{
		level.fake_ppsh2 hide();
	}
}

redshirt_putdownup_gun(guy)
{
	org = guy gettagorigin("tag_weapon_right");
	ang = guy gettagangles("tag_weapon_right");
	//level.fake_ppsh2.origin = org;
	//level.fake_ppsh2.angles = ang;
	//level.fake_ppsh2 show();
	guy detach ("weapon_rus_ppsh_smg", "tag_inhand");  
	
	if (isdefined(level.fake_ppsh2) )
	{
		level.fake_ppsh2 delete();	
	}
	level.hero animscripts\shared::placeweaponOn("ppsh", "right");
	
}

switch_weapon_in(guy)
{
	//org = guy gettagorigin("tag_weapon");
	//ang = guy gettagangles("tag_weapon");
	/*
	if (isdefined(level.fake_ppsh2) )
	{
		level.fake_ppsh2 delete();	
	}
	level.hero animscripts\shared::placeweaponOn("ppsh", "right");
	*/
}	

officers_sniper_shoot_atyou()
{

	if (!flag("player_fired_in_e4")  )
	{
		return;
	}
	
	if ( (flag("officer_last_run") || flag("officer_isincar")) && level.difficulty < 3)
	{
		return;
	}
	
	shotspot = get_players()[0] geteye();
	firespot = level.officers_sniper gettagorigin("tag_flash");
	chance = 25*level.difficulty;
	perc = randomint(100);
	if (chance < perc)
	{
		shotspot = (get_players()[0] geteye()) + (randomint(15),randomint(15),randomint(15)) ;
	}
	vec = firespot- shotspot;
	nvec = vectornormalize(vec);
	playfx(level._effect["fake_rifleflash"] , firespot);
	trace = bullettrace(firespot+(nvec*5), shotspot, false, undefined);
	//bullettracer(firespot+(nvec*5), trace["position"], true);
	bullettracer(firespot+(nvec*5), shotspot, true);
	wait 0.45;
	//magicbullet ("kar98k_scoped", firespot+(nvec*10), shotspot);
	magicbullet ("mosin_rifle_scoped", firespot+(nvec*10), shotspot);
}

lookat_notetracks()
{
	keys = getarraykeys(level.scr_anim["hero"]);
	for (i=0; i < keys.size; i++)
	{
		level thread addNotetrack_customFunction( "hero", 			"look_at",			::lookat_player, keys[i]);	
		level thread addNotetrack_customFunction( "hero", 			"look_away",		::lookaway_player, keys[i]);
	}
}

lookat_player(guy)
{
	level notify ("lookat_safety");
	level endon ("lookat_safety");
	level.hero lookatentity(level.player);
	wait 6;
	level thread lookaway_player(guy);
	
}

lookaway_player(guy)
{
	level notify ("lookat_safety");
	level.hero lookatentity();
}

#using_animtree( "sniper_crows" );
hat_anim()
{
	level.scr_animtree["hat"]			= #animtree;
	level.scr_model["hat"] 				= "tag_origin_animate"; 
	level.scr_anim["hat"]["float"]	= %o_sniper_ushanka_float;
}

#using_animtree( "sniper_crows" );
bar_exit()
{
	level.scr_animtree["bardoor"]			= #animtree;
	level.scr_model["bardoor"] 				= "tag_origin_animate"; 
	level.scr_anim["bardoor"]["open"]	= %o_sniper_bardoor_open;
}

alley_flamer_fire_control(guy)
{
	if (!flag("alley_flamer_flaming"))
	{
		guy shoot();
		flag_set("alley_flamer_flaming");
	}
	else
	{
		guy notify( "flame stop shoot" );
		guy StopShoot();
		flag_clear("alley_flamer_flaming");
	}
}
	
crow_rumble_pecks(guy)
{
	level.player playrumbleonentity("damage_light");
}

shoo_crow(guy)
{
	wait 0.5;
	level notify ("player_near_crow");
}

horchhide_cutoff(guy)
{
	if (!isdefined(level.horchhide_talk_count) )
	{
		level.horchhide_talk_count = 0;
	}
	level.horchhide_talk_count++;
	trig = getent("wave_player_fromhorch", "targetname");
	if (!level.player istouching(trig) && level.horchhide_talk_count > 2)
	{
		level.hero stopanimscripted();
		level notify ("horchhide_done");
	}
}

mark_my_words(guy)
{
	
	if (!flag("barfight_ison") )
	{
		level.hero anim_single_solo(level.hero, "mark_mywords");
	}
}

#using_animtree( "sniper_crows" );
do_collectible_corpse()
{
	wait_for_first_player();
	spot = getstruct("collectible_body_align", "targetname");
	corpse = spawn( "script_model" , spot.origin );
	corpse character\char_rus_r_ppsh_forsniper::main();
	corpse UseAnimTree(#animtree);
	corpse.angles = spot.angles;
	corpse.animname = "collectible_dude";
	spot anim_single_solo(corpse, "hes_dead");
}

wounded_counter(guy)
{
	if (!isdefined(level.woundedcounter))
	{
		level.woundedcounter = 520;
	}
	level.woundedcounter = level.woundedcounter + 20;
}
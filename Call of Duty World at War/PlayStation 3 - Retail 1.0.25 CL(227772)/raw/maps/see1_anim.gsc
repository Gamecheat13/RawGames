#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\see1_code;

// Animation Level File
#using_animtree ("generic_human");

main()
{
	anim_loader();
	setup_player_interactive_anims();
}


#using_animtree ("generic_human");
anim_loader()
{

// Opening ----------------------------------------------------------------------------------

	level.scr_anim["reznov"]["intro"] = %ch_seelow1_intro_zeitzev;
	addNotetrack_customFunction( "reznov", "fire", maps\see1_opening::opening_zeitzev_gunshotFX, "intro" );  // gunshot fx
	addNotetrack_customFunction( "reznov", "explosion", maps\see1_opening::opening_zeitzev_explosion, "intro" );  // explosion
	addNotetrack_customFunction( "reznov", "player_straight", maps\see1_opening::opening_player_straight, "intro" );  
	addNotetrack_customFunction( "reznov", "kick_face", maps\see1_opening::opening_kick_face, "intro" );  
	addNotetrack_customFunction( "reznov", "punch_face", maps\see1_opening::opening_punch_face, "intro" );  
	addNotetrack_customFunction( "reznov", "outside_reaction", maps\see1_opening::opening_outside_reaction, "intro" );  
	addNotetrack_customFunction( "reznov", "detach_player", maps\see1_opening::opening_detach_player, "intro" );  
	level.scr_anim["chernov"]["intro"] = %ch_seelow1_intro_chernov;
	level.scr_anim["dead_guy"]["intro"] = %ch_seelow1_intro_deadguy;
	level.scr_anim["dead_guy"]["intro_death"][0] = %ch_seelow1_intro_deadguy_dead;
	level.scr_anim["german1"]["intro"] = %ch_seelow1_intro_german1;
	level.scr_anim["german2"]["intro"] = %ch_seelow1_intro_german2;
	level.scr_anim["german3"]["intro"] = %ch_seelow1_intro_german3;
	addNotetrack_customFunction( "chernov", "attach", maps\see1_opening::opening_attach_watch, "intro" );  
	addNotetrack_customFunction( "chernov", "detach", maps\see1_opening::opening_detach_watch, "intro" );  
	addNotetrack_customFunction( "chernov", "attach_book", maps\see1_opening::opening_attach_book, "intro" );  
	addNotetrack_customFunction( "chernov", "detach_book", maps\see1_opening::opening_detach_book, "intro" );  
	level.scr_anim["german2"]["intro_loop"] = %ch_seelow1_intro_german2_loop;
	level.scr_anim["german3"]["intro_loop"] = %ch_seelow1_intro_german3_loop;
	level.scr_anim["dead_guy2"]["intro"] = %ch_seelow1_intro_deadguy2_dead;
	level.scr_anim["dead_guy2"]["intro_death"][0] = %ch_seelow1_intro_deadguy2_dead;

	addnotetrack_dialogue( "german1", "dialog", "intro", "See1_INT_000A_GMS1" );
	addnotetrack_dialogue( "german1", "dialog", "intro", "See1_INT_001A_GMS1" );
	addnotetrack_dialogue( "german3", "dialog", "intro", "See1_INT_002A_GMS3" );
	addnotetrack_dialogue( "german2", "dialog", "intro", "See1_INT_003A_GMS2" );
	addnotetrack_dialogue( "german3", "dialog", "intro", "See1_INT_004A_GMS3" );
	addnotetrack_dialogue( "german1", "dialog", "intro", "See1_INT_005A_GMS1" );
	addnotetrack_dialogue( "german1", "dialog", "intro", "See1_INT_007A_GMS1" );
	addnotetrack_dialogue( "german3", "dialog", "intro", "See1_INT_009A_GMS3" );

	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_011A_REZN" );
	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_012A_REZN" );
	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_013A_REZN" );
	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_014A_REZN" );
	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_015A_REZN" );
	addnotetrack_dialogue( "chernov", "dialog", "intro", "See1_INT_016A_CHER" );
	addnotetrack_dialogue( "reznov", "dialog", "intro", "See1_INT_017A_REZN" );

	// Russian melee and kill a German
	level.scr_anim["german"]["melee_combat_1"] = %ch_berlin1_E3vignette3_german;	// German dies
	level.scr_anim["russian"]["melee_combat_1"] = %ch_berlin1_E3vignette3_russian;
	level.scr_anim["german"]["melee_combat_1_death"] = %ch_berlin1_E3vignette3_german_death;
	addNotetrack_customFunction( "german", "kill_german", ::kill_vig_guy_1, "melee_combat_1" );
	
	// Russian melee and kill a German version 2
	level.scr_anim["german"]["melee_combat_2"] = %ch_berlin1_E3vignette3_german;	// German dies
	level.scr_anim["russian"]["melee_combat_2"] = %ch_berlin1_E3vignette3_russian;
	level.scr_anim["german"]["melee_combat_2_death"] = %ch_berlin1_E3vignette3_german_death;
	addNotetrack_customFunction( "german", "kill_german", ::kill_vig_guy_2, "melee_combat_2" );

	// tossing molotov
	//level.scr_anim["russian"]["toss_molotov"] = %ch_seelow1_molotov_guy2;		
	//level.scr_anim["reznov"]["toss_molotov"] = %ch_seelow1_molotov_guy2;		
	//level.scr_anim["chernov"]["toss_molotov"] = %ch_seelow1_molotov_guy2;		
	level.scr_anim["russian"]["toss_molotov"] = %ch_seelow1_pickup_molotov_a;		
	level.scr_anim["reznov"]["toss_molotov"] = %ch_seelow1_pickup_molotov_a;		
	level.scr_anim["chernov"]["toss_molotov"] = %ch_seelow1_pickup_molotov_a;		

	// German running out on fire
	level.scr_anim["german"]["running_on_fire_1"] = %ch_peleliu1_outbunker_guy1;		// German dies
	level.scr_anim["german"]["running_on_fire_2"] = %ch_peleliu1_outbunker_guy2;		// German dies
	level.scr_anim["german"]["dazed_fire_run_1"] = %ch_dazed_b; // walk middle
	level.scr_anim["german"]["dazed_fire_run_2"] = %ch_dazed_c; // covering face

	level.scr_anim["generic"]["flame_run"] = %ai_flame_death_run; 

	// generic run animations
	level.scr_anim["generic"]["panick_run_1"] = %unarmed_panickedrun_loop_V1;	
	level.scr_anim["generic"]["panick_run_2"] = %unarmed_panickedrun_loop_V2;	
	//level.scr_anim["generic"]["panick_turn_1"] = %ai_retreating_a;	
	//level.scr_anim["generic"]["panick_turn_2"] = %ai_retreating_c;	
	//level.scr_anim["generic"]["panick_turn_3"] = %exposed_crouch_turn_180_left;	
	//level.scr_anim["generic"]["panick_turn_4"] = %exposed_crouch_turn_180_right;	
	//level.scr_anim["generic"]["panick_turn_5"] = %exposed_turn180;	
	//level.scr_anim["generic"]["panick_turn_6"] = %pistol_stand_turn180r;	
	//level.scr_anim["generic"]["panick_turn_7"] = %stand_2_run_180_short;	

	level.scr_anim["generic"]["return_fire_1"] = %run_2_crouch_180R;	
	level.scr_anim["generic"]["return_fire_2"] = %run_2_stand_180R;

	// flinching
	level.scr_anim["generic"]["flinching_run_1"] = %ch_seelow1_flinch_run;
	level.scr_anim["generic"]["flinching_run_2"] = %ch_seelow1_knockdown_run_b;

	level.scr_anim["chernov"]["flinching_run_1"] = %ch_seelow1_flinch_run;
	level.scr_anim["chernov"]["flinching_run_2"] = %ch_seelow1_knockdown_run_b;

	level.scr_anim["reznov"]["flinching_run_1"] = %ch_seelow1_flinch_run;
	level.scr_anim["reznov"]["flinching_run_2"] = %ch_seelow1_knockdown_run_b;

	// dialogs
	//level.scr_sound["chernov"]["retreating"] 	= "See1_IGD_002A_CHER";
	//level.scr_sound["reznov"]["not_save"] 		= "See1_IGD_003A_REZN";
	level.scr_sound["reznov"]["burn_wheat"] 	= "See1_IGD_005A_REZN";
	level.scr_sound["reznov"]["no_escape"] 		= "See1_IGD_004A_REZN";
	level.scr_sound["reznov"]["things_changed"] 	= "See1_IGD_000A_REZN";
	level.scr_sound["reznov"]["their_blood"] 		= "See1_IGD_001A_REZN";

	level.scr_sound["reznov"]["shoot"] 			= "See1_IGD_006A_REZN";
	level.scr_sound["chernov"]["in_the_back"] 	= "See1_IGD_007A_CHER";
	level.scr_sound["reznov"]["wherever"] 		= "See1_IGD_008A_REZN";

	level.scr_sound["chernov"]["stay_out"] 		= "See1_IGD_100A_CHER";
	level.scr_sound["chernov"]["soon_ashes"] 	= "See1_IGD_101A_CHER";
	//level.scr_sound["reznov"]["let_them_burn"] 	= "See1_IGD_102A_REZN";
	level.scr_sound["reznov"]["fireproof"] 		= "See1_IGD_103A_REZN";

	level.scr_anim["chernov"]["molotov_generic_toss"] 	= %ch_seelow1_pickup_molotov_a;
	level.scr_anim["reznov"]["molotov_generic_toss"] 	= %ch_seelow1_pickup_molotov_a;
	addNotetrack_customFunction( "chernov", "attach_molotov", maps\see1_code::see1_molotov_attach, "molotov_generic_toss" );  
	addNotetrack_customFunction( "chernov", "detach_molotov", maps\see1_code::see1_molotov_detach, "molotov_generic_toss" );  
	addNotetrack_customFunction( "reznov", "attach_molotov", maps\see1_code::see1_molotov_attach, "molotov_generic_toss" );  
	addNotetrack_customFunction( "reznov", "detach_molotov", maps\see1_code::see1_molotov_detach, "molotov_generic_toss" );  

// Event 1 ----------------------------------------------------------------------------------

	// bodies floating in river
	//level.scr_anim["generic"]["floating_body1"] = %ch_seelow1_river_corpse1;
	//level.scr_anim["generic"]["floating_body2"] = %ch_seelow1_river_corpse2;
	//level.scr_anim["generic"]["floating_body1_loop"] = %ch_seelow1_river_corpse1_loop;
	//level.scr_anim["generic"]["floating_body2_loop"] = %ch_seelow1_river_corpse2_loop;

	//  tripping over while running
	level.scr_anim["generic"]["tripping"] = %ch_training_trips_guy_1;

	// explosion death
	level.scr_anim["generic"]["death_explosion_forward"] = %death_explosion_forward13;
	level.scr_anim["generic"]["death_explosion_right"] = %death_explosion_right13;
	level.scr_anim["generic"]["death_explosion_left"] = %death_explosion_left11;
	level.scr_anim["generic"]["death_explosion_back"] = %death_explosion_back13;
	level.scr_anim["generic"]["death_explosion_far"] = %ch_makinraid_blown_into_shed;

	// tank across river
	level.scr_anim["t34_man"]["flame_death_climb_out"] = %crew_tank1_commander_death_fire;

	// truck blowing up
	level.scr_anim["fake_truck_guys_0"]["idel_truck_ride"][0] = %crew_truck_guy1_drive_sit_idle;
	level.scr_anim["fake_truck_guys_1"]["idel_truck_ride"][0] = %crew_truck_guy2_drive_sit_idle;
	level.scr_anim["fake_truck_guys_2"]["idel_truck_ride"][0] = %crew_truck_guy3_drive_sit_idle;
	level.scr_anim["fake_truck_guys_3"]["idel_truck_ride"][0] = %crew_truck_guy4_drive_sit_idle;
	level.scr_anim["fake_truck_guys_4"]["idel_truck_ride"][0] = %crew_truck_guy5_drive_sit_idle;
	level.scr_anim["fake_truck_guys_5"]["idel_truck_ride"][0] = %crew_truck_guy6_drive_sit_idle;
	level.scr_anim["fake_truck_guys_6"]["idel_truck_ride"][0] = %crew_truck_guy7_drive_sit_idle;
	level.scr_anim["fake_truck_guys_7"]["idel_truck_ride"][0] = %crew_truck_guy8_drive_sit_idle;

	level.scr_anim["fake_truck_guys_0"]["explosion_thrown"] = %death_explosion_forward13;
	level.scr_anim["fake_truck_guys_1"]["explosion_thrown"] = %death_explosion_left11;
	level.scr_anim["fake_truck_guys_2"]["explosion_thrown"] = %death_explosion_left11;
	level.scr_anim["fake_truck_guys_3"]["explosion_thrown"] = %death_explosion_back13;
	level.scr_anim["fake_truck_guys_4"]["explosion_thrown"] = %death_explosion_forward13;
	level.scr_anim["fake_truck_guys_5"]["explosion_thrown"] = %death_explosion_right13;
	level.scr_anim["fake_truck_guys_6"]["explosion_thrown"] = %death_explosion_right13;
	level.scr_anim["fake_truck_guys_7"]["explosion_thrown"] = %death_explosion_back13;

	level.scr_anim["reznov"]["cough_run"] = %ch_resnov_runandcough1;
	level.scr_anim["chernov"]["cough_run"] = %ch_resnov_runandcough1;
	level.scr_anim["generic"]["cough_run"] = %ch_resnov_runandcough1;

	// dialog
	level.scr_sound["reznov"]["into_river"] 	= "See1_IGD_011A_REZN"; 
	level.scr_sound["reznov"]["like_rats"] 		= "See1_IGD_009A_REZN"; 
	level.scr_sound["reznov"]["kill_them_all"] 	= "See1_IGD_010A_REZN"; 

	level.scr_sound["reznov"]["kill_them_all2"] 	= "See1_IGD_016A_REZN"; 

	level.scr_sound["reznov"]["instinct"] 		= "See1_IGD_012A_REZN"; // trust instinct
	level.scr_sound["reznov"]["left_or_right"] 	= "See1_IGD_013A_REZN"; // left or right

	level.scr_sound["reznov"]["drive_forest"] 	= "See1_IGD_014A_REZN"; 
	level.scr_sound["reznov"]["burn_country"] 	= "See1_IGD_015A_REZN";
	//level.scr_sound["reznov"]["plane_waste"] 	= "See1_IGD_104A_REZN";
	level.scr_sound["reznov"]["flank_mg"] 		= "See1_IGD_105A_REZN";

	level.scr_sound["reznov"]["mg_below"] 			= "See1_IGD_018A_REZN"; 
	level.scr_sound["reznov"]["throw_molotov_post"] = "See1_IGD_019A_REZN";
	level.scr_sound["reznov"]["drive_back"] 		= "See1_IGD_020A_REZN";
	level.scr_sound["reznov"]["trench_grave"] 		= "See1_IGD_021A_REZN";

	//level.scr_sound["chernov"]["truck_bridge"] 	= "See1_IGD_106A_CHER";
	//level.scr_sound["reznov"]["i_told"] 		= "See1_IGD_107A_REZN";

	//level.scr_sound["reznov"]["tank_straight"] 		= "See1_IGD_108A_REZN"; 
	//level.scr_sound["chernov"]["how_armor"] 		= "See1_IGD_109A_CHER";
	//level.scr_sound["reznov"]["show_chernov"] 		= "See1_IGD_110A_REZN"; 
	//level.scr_sound["reznov"]["climb_drop"] 		= "See1_IGD_111A_REZN";
	//level.scr_sound["reznov"]["hurry_deal"] 		= "See1_IGD_112A_REZN"; 

// Event 2 ----------------------------------------------------------------------------------

	// AIs at the barn door
	level.scr_anim["generic"]["death_explosion_back"] = %death_explosion_back13;
	level.scr_anim["generic"]["death_explosion_left"] = %death_explosion_left11;

	// generic walk anims
	level.scr_anim["reznov"]["walk_barn"] = %patrol_bored_walk_2_bored;	
	level.scr_anim["chernov"]["walk_barn"] = %patrol_bored_walk_2_bored;	

	// opening door
	level.scr_anim["reznov"]["open_barn_door"] = %ch_seelow1_melee4_doorkick_guy1;
	level.scr_anim["chernov"]["open_barn_door"] = %ch_seelow1_melee4_doorkick_guy2;
	addNotetrack_customFunction( "reznov", "fire", ::anim_barn_door_rattle, "open_barn_door" );
	addNotetrack_customFunction( "reznov", "kick", ::anim_barn_door_kick_open, "open_barn_door" );

	addnotetrack_dialogue( "reznov", "dialog", "open_barn_door", "See1_IGD_053A_REZN" );

	// dialog
	//level.scr_sound["reznov"]["tank_field"] 	= "See1_IGD_022A_REZN"; 

	level.scr_sound["reznov"]["panzershrecks"] 	= "See1_IGD_024A_REZN";
	level.scr_sound["reznov"]["over_balcony"] 	= "See1_IGD_025A_REZN";
	level.scr_sound["reznov"]["lead_charge"] 	= "See1_IGD_027A_REZN";
	level.scr_sound["reznov"]["protect_armor"] 	= "See1_IGD_028A_REZN";

	level.scr_sound["chernov"]["tanks_approach"] 	= "See1_IGD_030A_CHER";
	level.scr_sound["reznov"]["turn_weapons"] 		= "See1_IGD_031A_REZN";
	level.scr_sound["reznov"]["boil_steel"] 		= "See1_IGD_032A_REZN";

	//level.scr_sound["reznov"]["infantry_wheat"] 	= "See1_IGD_035A_REZN";
	//level.scr_sound["reznov"]["torch_them"] 		= "See1_IGD_036A_REZN";

	level.scr_sound["reznov"]["time_weaken_aim"] 		= "See1_IGD_037A_REZN";

	level.scr_sound["reznov"]["hero_of_staling"] 	= "See1_IGD_039A_REZN";
	//level.scr_sound["reznov"]["assure_victory"] 	= "See1_IGD_038A_REZN";

	level.scr_sound["reznov"]["more_tanks"] 	= "See1_IGD_033A_REZN";
	level.scr_sound["reznov"]["fire"] 			= "See1_IGD_034A_REZN";
	level.scr_sound["reznov"]["last_one_burns"] 			= "See1_IGD_117A_REZN";

	level.scr_sound["reznov"]["armor_no_match"] 	= "See1_IGD_041A_REZN";


	//level.scr_sound["reznov"]["more_panzershreck"] 	= "See1_IGD_029A_REZN";

	level.scr_sound["chernov"]["panzer_window"] 	= "See1_IGD_042A_CHER";
	level.scr_sound["reznov"]["let_armor_deal"] 	= "See1_IGD_043A_REZN";
	level.scr_sound["reznov"]["ha"] 				= "See1_IGD_044A_REZN";

	level.scr_sound["reznov"]["regroup_barn"] 	= "See1_IGD_045A_REZN";
	//level.scr_sound["reznov"]["prepare_push"] 	= "See1_IGD_046A_REZN";

	level.scr_sound["reznov"]["another_tank"] 	= "See1_IGD_048A_REZN";
	level.scr_sound["reznov"]["take_it_down"] 	= "See1_IGD_049A_REZN";

	level.scr_sound["reznov"]["learn_much"] 	= "See1_IGD_050A_REZN";
	level.scr_sound["reznov"]["relish"] 		= "See1_IGD_051A_CHER";
	level.scr_sound["reznov"]["die_vermin"] 	= "See1_IGD_052A_REZN";
	level.scr_sound["reznov"]["deserve_more"] 	= "See1_IGD_053A_REZN";
	//level.scr_sound["reznov"]["enough_talk"] 	= "See1_IGD_054A_REZN";

	level.scr_sound["reznov"]["stall_advance"] 	= "See1_IGD_113A_REZN";
	level.scr_sound["reznov"]["use_rockets"] 	= "See1_IGD_114A_REZN";
	level.scr_sound["reznov"]["fire_shreck"] 	= "See1_IGD_115A_REZN";
	level.scr_sound["reznov"]["again"] 			= "See1_IGD_116A_REZN";
	//level.scr_sound["reznov"]["drop_grenade"] 	= "See1_IGD_118A_REZN";
	//level.scr_sound["reznov"]["sniper_barn"] 	= "See1_IGD_119A_REZN";
	//level.scr_sound["reznov"]["forward_clear"] 	= "See1_IGD_120A_REZN";
	//level.scr_sound["reznov"]["hide_cowards"] 	= "See1_IGD_123A_REZN";

	level.scr_sound["reznov"]["break_door"] 	= "See1_IGD_121A_REZN";
	level.scr_sound["reznov"]["cowards_shadows"] 	= "See1_IGD_123A_REZN";

	level.scr_sound["reznov"]["ride_tanks"] 	= "See1_IGD_124A_REZN";
	level.scr_sound["reznov"]["you_walk"] 		= "See1_IGD_125A_REZN";
	level.scr_sound["generic"]["no_room1"] 	= "See1_IGD_126A_RUR1";
	level.scr_sound["generic"]["no_room2"] 	= "See1_IGD_127A_RUR1";

	//level.scr_sound["chernov"]["germans_field"] 	= "See1_IGD_128A_CHER";
	level.scr_sound["reznov"]["cockroaches"] 		= "See1_IGD_129A_REZN";
	//level.scr_sound["reznov"]["pick_them_off"] 		= "See1_IGD_130A_REZN";

 

 
// Event 3 ----------------------------------------------------------------------------------

	// outro
	level.scr_anim["guyl1"]["outro"] = %ch_seelow1_outro_left_russian_guy1;
	level.scr_anim["guyl2"]["outro"] = %ch_seelow1_outro_left_russian_guy2;
	level.scr_anim["guyl3"]["outro"] = %ch_seelow1_outro_left_russian_guy3;
	level.scr_anim["guyl4"]["outro"] = %ch_seelow1_outro_left_russian_guy4;
	level.scr_anim["guyl5"]["outro"] = %ch_seelow1_outro_left_russian_guy5;
	level.scr_anim["guyl6"]["outro"] = %ch_seelow1_outro_left_russian_guy6;

	level.scr_anim["guyc1"]["outro"] = %ch_seelow1_outro_middle_russian_guy1;
	level.scr_anim["guyc2"]["outro"] = %ch_seelow1_outro_middle_russian_guy2;
	level.scr_anim["guyc3"]["outro"] = %ch_seelow1_outro_middle_russian_guy3;
	level.scr_anim["guyc4"]["outro"] = %ch_seelow1_outro_middle_russian_guy4;
	level.scr_anim["guyc5"]["outro"] = %ch_seelow1_outro_middle_russian_guy5;
	level.scr_anim["guyc6"]["outro"] = %ch_seelow1_outro_middle_russian_guy6;

	// center guy 3 is reznov
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See1_OUT_000A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See1_OUT_009A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See1_OUT_010A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See1_OUT_011A_REZN" );
	addnotetrack_dialogue( "guyc3", "dialog", "outro", "See1_OUT_012A_REZN" );

	level.scr_anim["guyr1"]["outro"] = %ch_seelow1_outro_right_russian_guy1;
	level.scr_anim["guyr2"]["outro"] = %ch_seelow1_outro_right_russian_guy2;

	// dialog
	level.scr_sound["reznov"]["this_is_it"] 	= "See1_IGD_055A_REZN";
	//level.scr_sound["reznov"]["final_push"] 	= "See1_IGD_056A_REZN";
	level.scr_sound["reznov"]["revel_victory"] 	= "See1_IGD_057A_REZN";
	level.scr_sound["reznov"]["charge"] 		= "See1_IGD_058A_REZN";

	level.scr_sound["reznov"]["down_towers"] 	= "See1_IGD_059A_REZN";
	level.scr_sound["reznov"]["use_panzer"] 	= "See1_IGD_060A_REZN";

	level.scr_sound["reznov"]["halftrack"] 	= "See1_IGD_061A_REZN";

	level.scr_sound["reznov"]["weakening"] 		= "See1_IGD_062A_REZN";
	level.scr_sound["reznov"]["finish_them"] 	= "See1_IGD_063A_REZN";

	level.scr_sound["chernov"]["path_blocked"] 	= "See1_IGD_131A_CHER";
	level.scr_sound["reznov"]["find_around"] 	= "See1_IGD_132A_REZN";

	level.scr_sound["reznov"]["find_rockets"] 		= "See1_IGD_133A_REZN";
	level.scr_sound["reznov"]["bring_down_towers"] 	= "See1_IGD_134A_REZN";
	level.scr_sound["reznov"]["follow_example"] 	= "See1_IGD_135A_REZN";
	level.scr_sound["reznov"]["destroy_towers"] 	= "See1_IGD_136A_REZN";

	level.scr_sound["chernov"]["reinforcements"] 		= "See1_IGD_137A_CHER";
	level.scr_sound["chernov"]["trucks_approaching"] 	= "See1_IGD_138A_CHER";
	level.scr_sound["reznov"]["blow_pieces"] 		= "See1_IGD_139A_REZN";
	level.scr_sound["reznov"]["greatest_asset"] 	= "See1_IGD_140A_REZN";

	//level.scr_sound["reznov"]["strongest_weapon"] 	= "See1_IGD_141A_REZN";
	//level.scr_sound["reznov"]["mg_halftrack"] 		= "See1_IGD_142A_REZN";
	//level.scr_sound["reznov"]["bullet_head"] 		= "See1_IGD_143A_REZN";


 	level.scr_sound["chernov"]["pulling_back"] 	= "See1_IGD_144A_CHER";
	level.scr_sound["reznov"]["matters_die"] 	= "See1_IGD_145A_REZN";
	level.scr_sound["reznov"]["hunt_down"] 		= "See1_IGD_146A_REZN";

	//level.scr_sound["chernov"]["ready_surrender"] 	= "See1_IGD_147A_CHER";
	//level.scr_sound["reznov"]["not_ready_let"] 		= "See1_IGD_148A_REZN";
	level.scr_sound["reznov"]["no_mercy_shown"] 	= "See1_IGD_149A_REZN";
	level.scr_sound["reznov"]["no_mercy_here"] 		= "See1_IGD_150A_REZN";
 	level.scr_sound["reznov"]["eye_for_eye"] 		= "See1_IGD_151A_REZN";

	level.scr_sound["reznov"]["victory_at_hand"] 		= "See1_IGD_200B_REZN";
	level.scr_sound["reznov"]["from_this_moment_on"] 	= "See1_IGD_200C_REZN";

	level.scr_anim["reznov"]["rejoice"][0] = %ch_rejoicing_a;
	level.scr_anim["reznov"]["rejoice"][1] = %ch_rejoicing_b;
	level.scr_anim["reznov"]["rejoice"][2] = %ch_rejoicing_c;
	level.scr_anim["reznov"]["rejoice"][3] = %ch_rejoicing_d;
	level.scr_anim["reznov"]["rejoice"][4] = %ch_rejoicing_e;
	level.scr_anim["reznov"]["rejoice"][5] = %ch_rejoicing_f;

	level.scr_anim["chernov"]["rejoice"][0] = %ch_rejoicing_c;
	level.scr_anim["chernov"]["rejoice"][1] = %ch_rejoicing_b;
	level.scr_anim["chernov"]["rejoice"][2] = %ch_rejoicing_a;
	level.scr_anim["chernov"]["rejoice"][3] = %ch_rejoicing_d;
	level.scr_anim["chernov"]["rejoice"][4] = %ch_rejoicing_e;
	level.scr_anim["chernov"]["rejoice"][5] = %ch_rejoicing_f;

	level.scr_anim["generic"]["rejoice"][0] = %ch_rejoicing_f;
	level.scr_anim["generic"]["rejoice"][1] = %ch_rejoicing_b;
	level.scr_anim["generic"]["rejoice"][2] = %ch_rejoicing_c;
	level.scr_anim["generic"]["rejoice"][3] = %ch_rejoicing_d;
	level.scr_anim["generic"]["rejoice"][4] = %ch_rejoicing_e;
	level.scr_anim["generic"]["rejoice"][5] = %ch_rejoicing_a;


	//level.scr_anim["reznov"]["charge"] = %ch_seelow1_zeitsev_charge;
	//level.scr_anim["chernov"]["charge"] = %ch_seelow1_zeitsev_charge;
	//level.scr_anim["generic"]["charge"] = %ch_seelow1_zeitsev_charge;

	level.scr_anim["reznov"]["cheer_tank"] = %ch_seelow1_tank_cheer;	
	//addNotetrack_customFunction( "reznov", "dialog", ::test_dia, "cheer_tank" );  
	//addnotetrack_dialogue( "reznov", "dialog", "cheer_tank", "See1_IGD_200C_REZN" );
	level.scr_anim["reznov"]["cheer_tank_idle"][0] = %ch_seelow1_tank_cheer_idle;	

	level.scr_anim["collectible"]["collectible_loop"][0] = %ch_see1_collectible;	


	anim_barn_door_kick_setup();
	anim_barn_door_tank_setup();

	anim_explosion_truck_setup();
	anim_explosion_tree_setup();
	truck_door_open_setup();
}

test_dia( guy )
{
	iprintlnbold( "dialog" );
}

// setup default properties on vignette AI
setup_vig_ai( ai_team )
{
	self.targetname = ai_team;
	self.animname = ai_team;
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 32;
	self.allowdeath = true;
}

// Used to break animations if the target has been killed prematurely 
monitor_other_guys_death( otherguy, cover_node )
{
	self endon( "anim_complete" );
	self endon( "death" );

	otherguy waittill( "death" );

	self StopAnimScripted();
			
	if( isdefined( cover_node ) )
	{
		self setgoalnode( cover_node );
	}
}

// Kill the guy who dies in this vignette
kill_vig_guy_1( guy )
{
	//level thread russian_fire_kill_1( guy.killer );

	guy.dropweapon = false;
	guy.grenadeammo = 0;
	guy.nodeathragdoll = true;
	guy.deathanim = level.scr_anim["german"]["melee_combat_1_death"];
	guy doDamage(guy.health + 25, (0,180,48));
}

kill_vig_guy_2( guy )
{
	//level thread russian_fire_kill_2( guy.killer );

	guy.dropweapon = false;
	guy.grenadeammo = 0;
	guy.nodeathragdoll = true;
	guy.deathanim = level.scr_anim["german"]["melee_combat_2_death"];
	guy doDamage(guy.health + 25, (0,180,48));
}

russian_fire_kill_1( killer )
{
	PlayFxOnTag( level._effect["rifleflash"], killer, "tag_flash" );  // muzzleflash	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], killer, "tag_brass" );  // shell eject
}

russian_fire_kill_2( killer )
{
	PlayFxOnTag( level._effect["rifleflash"], killer, "tag_flash" );  // muzzleflash	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], killer, "tag_brass" );  // shell eject
}


#using_animtree( "player" );

setup_player_interactive_anims()
{
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_model["player_hands"] = "viewmodel_rus_guard_player";
	level.scr_anim["player_hands"]["intro"] = %int_seelow1_intro_player;
	level.scr_anim["player_hands"]["outro"] = %int_seelow1_outro_player;

	addNotetrack_customFunction( "player_hands", "hands_in1", ::opening_show_hands, "intro" );  
	addNotetrack_customFunction( "player_hands", "hands_out1", ::opening_hide_hands, "intro" );  
	addNotetrack_customFunction( "player_hands", "hands_in2", ::opening_show_hands, "intro" );  
	addNotetrack_customFunction( "player_hands", "hands_out2", ::opening_hide_hands, "intro" );  
	//level.scr_anim["player_hands"]["intro"] = %int_makinraid_intro;
}

#using_animtree ("player");

play_player_anim_intro( index, player, anim_node, lerp_node )
{
	hands = spawn_anim_model( "player_hands" );
	hands.animname = "player_hands";
	//hands Hide();
	hands.origin = anim_node.origin;
	hands.angles = anim_node.angles;
	//hands.attachedplayer = player;
	
	//player thread lerp_player_view_to_tag( hands, "tag_player", 1.75, 1, 0, 0, 0, 0  );
	//player PlayerLinkTo( hands, "tag_player", 1, 20, 20, 20, 20 );
	player PlayerLinkTo( hands, "tag_player", 1.75, 0, 0, 0, 0 );

	player hide();

	anim_node anim_single_solo( hands, "intro" ); 
	level notify( "intro_hands_end" );

	//level waittill( "intro_release_player" );
	if( index != 0 )
	{
		player Unlink();
		//iprintlnbold( "unlink bad" );
	}
	hands Delete();

	player play_player_lerp_to_pos( index, lerp_node );
}

play_player_lerp_to_pos( index, lerp_node )
{
	level notify( "intro_restore_share_screen" );

	if( index != 0 )
	{
		org = Spawn( "script_origin", self.origin );
		org.angles = self.angles;
	
		self PlayerLinkTo( org, "", 1, 5, 5, 5, 5 );
	
		org MoveTo( lerp_node.origin + ( 0, 0, 5 ), 3, 0, 1.5 );
		org RotateTo( lerp_node.angles, 3, 0, 1.5 );

		wait( 3 );
	
		self Unlink();
	
		self show();
	
		org Delete();
	}
	else
	{
		level notify( "player_exits_house" );

		wait( 1.5 );
		self Unlink();
		//iprintlnbold( "unlink" );
		self show();
	}

	self AllowStand( true );
	self Allowcrouch( true );
	self allowprone( true );
	self setstance( "stand" );
	self enableWeapons();
	self SetClientDvar( "hud_showStance", "1" ); 
	self SetClientDvar( "compass", "1" ); 
	self SetClientDvar( "ammoCounterHide", "0" );
	self setClientDvar( "miniscoreboardhide", "0" );
}

restore_share_screen( msg )
{
	level waittill( msg );
	share_screen( get_host(), false );
}

play_player_anim_outro( i, player, anim_node )
{
	//wait( 2 );
	hands = spawn_anim_model( "player_hands" );
	hands.animname = "player_hands";
	if( i != 0 )
	{
		hands Hide();
	}

	hands.origin = anim_node.origin;
	hands.angles = anim_node.angles;
	//hands.attachedplayer = player;
	
	//player thread lerp_player_view_to_tag( hands, "tag_player", 1.75, 1, 0, 0, 0, 0  );
	//player PlayerLinkTo( hands, "tag_player", 1.75, 30, 30, 30, 30 );
	player PlayerLinkTo( hands, "tag_player", 1.75, 0, 0, 0, 0 );

	anim_node anim_single_solo( hands, "outro" ); 

	//player Unlink();
	hands Delete();
}

opening_show_hands( hand )
{
	//hand show();
}

opening_hide_hands( hand )
{
	//hand hide();
}

fire_bullet( guy )
{
	PlayFxOnTag( level._effect["rifleflash"], guy, "tag_flash" );  // muzzleflash	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], guy, "tag_brass" );  // shell eject
}


///-----------------------------------------------------------------------------

barn_door_kick_spawn()
{
	//struct1 = getstruct( "ev2_barn_door_kick_origin", "targetname" );
	//level.barn_door_kick = spawn("script_model", struct1.origin );
	//level.barn_door_kick.angles = struct1.angles;
	//level.barn_door_kick setmodel( "anim_seelow_barndoorkick" );

	level.barn_door_kick = getent( "wii_barn_door_back", "targetname" );

	level.barn_door_kick.animname = "barn_door_kick";
}

barn_door_tank_spawn()
{
	//struct1 = getstruct( "ev2_barn_door_tank_origin", "targetname" );
	//level.barn_door_tank = spawn("script_model", struct1.origin );
	//level.barn_door_tank.angles = struct1.angles;
	//level.barn_door_tank setmodel( "anim_seelow_barndoortank" );

	level.barn_door_tank = getent( "wii_barn_door_front", "targetname" );

	level.barn_door_tank.animname = "barn_door_tank";
}


#using_animtree ("see1_barn_door_kick");

anim_barn_door_kick_setup()
{
	level.scr_anim["barn_door_kick"]["open_barn_door"] = %o_seelow1_melee4_door_open;
	level.scr_anim["barn_door_kick"]["shake"] = %o_seelow1_melee4_door_fire;
}

anim_barn_door_rattle( guy )
{
	PlayFxOnTag( level._effect["rifleflash"], guy, "tag_flash" );  // muzzleflash	
	wait( 0.2 );
	PlayFxOnTag( level._effect["rifle_shelleject"], guy, "tag_brass" );  // shell eject

	level.barn_door_kick UseAnimTree( #animtree );
	level.barn_door_kick stopanimscripted();
	level.barn_door_kick anim_single_solo( level.barn_door_kick, "shake" );
}

anim_barn_door_kick_open( guy )
{
	blocker = getent( "ev2_barn_door_out", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	blocker delete();

	level.barn_door_kick UseAnimTree( #animtree );
	level.barn_door_kick stopanimscripted();

	colors_barn = getent( "ev2_barn_fc", "targetname" );
	colors_barn trigger_on();

	level.barn_door_kick anim_single_solo( level.barn_door_kick, "open_barn_door" );

	level notify( "barn_door_opened" );

	//level.hero1 reset_run_anim();
	//level.hero2 reset_run_anim();
}


#using_animtree ("see1_barn_door_tank");
anim_barn_door_tank_setup()
{
	level.scr_anim["barn_door_tank"]["break_barn_door"] = %o_seelow1_barndoortank;
}

tank_open_door()
{
	blocker = getent( "ev2_barn_door_in_2", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	blocker delete();

	blocker = getent( "ev2_barn_door_in_21", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	blocker delete();

	blocker = getent( "ev2_barn_door_in_22", "targetname" );
	blocker notsolid();
	blocker connectpaths();
	blocker delete();

	level notify( "ev2_regroup_tank_appears" );

	level.barn_door_tank UseAnimTree( #animtree );
	level.barn_door_tank anim_single_solo( level.barn_door_tank, "break_barn_door" );
}


#using_animtree ("see1_explosion_truck");
anim_explosion_truck_setup()
{
	level.scr_anim["truck"]["truck_explosion"] = %o_seelow1_truck_explosion_truck;
	addNotetrack_customFunction( "truck", "hit_tree", ::see1_truck_hits_tree, "truck_explosion" );  
}

play_truck_crash_anim( truck )
{
	origin = getstruct( "ev2_truck_crash_origin4", "targetname" );

	// spawn fake truck
	truck_new = spawn( "script_model", truck.origin );
	//truck_new SetModel("vehicle_ger_wheeled_opel_blitz");
	truck_new.animname = "truck";
	truck_new.angles = truck.angles;
	
	anim_temp_hide( truck_new, truck );
	
	//truck hide();

	playfx( level._effect["tank_blow_up"], truck_new.origin );

	playfxontag( level._effect["truck_fire_med"], truck_new, "tag_driver" );
	truck_new UseAnimTree( #animtree );
	origin anim_single_solo( truck_new, "truck_explosion" );

	playfx( level._effect["truck_explosion_phys"], truck_new gettagorigin( "tag_driver" ) );
	playfx( level._effect["tank_smoke_column"], truck_new gettagorigin( "tag_driver" ) );

	// play more fx on ground

	fire_targets = getstructarray( "truck_fall_flame", "targetname" );
	for( i = 0; i < fire_targets.size; i++ )
	{
		playfx( level._effect["tree_brush_fire"], fire_targets[i].origin );
	}
}

anim_temp_hide( truck, truck_old )
{
	wait( 0.1 );
	truck SetModel("vehicle_ger_wheeled_opel_blitz");
	truck_old hide();
}

see1_truck_hits_tree( guy )
{
	level notify( "truck_hits_tree" );
}


#using_animtree ("see1_explosion_tree");
anim_explosion_tree_setup()
{
	level.scr_anim["tree"]["truck_explosion"] = %o_seelow1_truck_explosion_tree;
	level.scr_anim["tree"]["truck_explosion_idle"][0] = %o_seelow1_truck_explosion_tree_idle;
}

play_tree_crash_anim( tree )
{
	tree.animname = "tree";
	origin = getstruct( "ev2_truck_crash_origin", "targetname" );
	tree UseAnimTree( #animtree );

	tree thread tree_loop_idle_anim( origin );	

	level waittill( "truck_hits_tree" );
	tree notify(  "stop_loop_anim" );
	origin anim_single_solo( tree, "truck_explosion" );

	level waittill( "all_tanks_destroyed" );

	if( isdefined( tree ) )
	{
		tree delete();
	}
}

tree_loop_idle_anim( origin )
{
	origin anim_loop_solo( self, "truck_explosion_idle", undefined, "stop_loop_anim" );
}

#using_animtree ("vehicles");
truck_door_open_setup()
{
	level.scr_anim["opel"]["truck_door_open"] = %v_opelblitz_driverdoor_climbout;
}
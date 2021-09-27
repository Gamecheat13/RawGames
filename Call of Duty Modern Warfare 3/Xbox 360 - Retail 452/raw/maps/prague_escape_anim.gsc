#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;

main()
{
	pigeons();
	generic_anims();
	player_anims();
	vehicle_anims();
	script_model_anims();
	animated_prop_setup();
	prague_escape_vo();
}

#using_animtree( "chicken" );
pigeons()
{
	level.scr_animtree[ "pigeon" ] 					= #animtree;
	level.scr_anim[ "pigeon" ][ "idle" ][ 0 ] = %pigeon_idle;
	level.scr_anim[ "pigeon" ][ "idleweight" ][ 0 ] = 1;
	level.scr_anim[ "pigeon" ][ "idle" ][ 1 ] = %pigeon_idle_twitch_1;
	level.scr_anim[ "pigeon" ][ "idleweight" ][ 1 ] = 0.3;

	level.scr_anim[ "pigeon" ][ "flying" ] = %pigeon_flying_cycle;
}

#using_animtree( "generic_human" );
generic_anims()
{
	level.scr_animtree[ "generic_human" ] 		= #animtree;
	
	// section 1  ////////////////////////////////////////////////////////////////////////////////////////
	// Bell Tower Opening Scene
	level.scr_anim[ "soap" ][ "belltower_intro_idle" ][0]	= %ch_pragueb_1_1_idle_soap;
	level.scr_anim[ "soap" ][ "belltower_intro" ]	= %ch_pragueb_1_1_intro_soap;
	addNotetrack_customFunction( "soap", "dialog_01", maps\prague_escape_sniper::belltower_intro_dialogue, "belltower_intro" );
	addNotetrack_flag( "soap", "dialog_02", "belltower_intro_dialogue_02", "belltower_intro" );
	
	// Convoy entrance
	level.scr_anim[ "convoy_guard_1" ][ "convoy_arrives_idle" ][0]	=%ch_pragueb_1_2_convoy_arrives_idle_grd_01;
	level.scr_anim[ "convoy_guard_2" ][ "convoy_arrives_idle" ][0]	=%ch_pragueb_1_2_convoy_arrives_idle_grd_02;
	level.scr_anim[ "convoy_guard_3" ][ "convoy_arrives_idle" ][0]	=%ch_pragueb_1_2_convoy_arrives_idle_grd_03;
	
	level.scr_anim[ "convoy_guard_1" ][ "convoy_setup" ]	=%ch_pragueb_1_2_convoy_arrives_setup_grd_01;
	level.scr_anim[ "convoy_guard_2" ][ "convoy_setup" ]	=%ch_pragueb_1_2_convoy_arrives_setup_grd_02;
	level.scr_anim[ "convoy_guard_3" ][ "convoy_setup" ]	=%ch_pragueb_1_2_convoy_arrives_setup_grd_03;
	
	level.scr_anim[ "convoy_guard_1" ][ "convoy_arrives_wait" ][0]	=%ch_pragueb_1_2_convoy_arrives_wait_grd_01;
	level.scr_anim[ "convoy_guard_2" ][ "convoy_arrives_wait" ][0]	=%ch_pragueb_1_2_convoy_arrives_wait_grd_02;
	level.scr_anim[ "convoy_guard_3" ][ "convoy_arrives_wait" ][0]	=%ch_pragueb_1_2_convoy_arrives_wait_grd_03;
	
	level.scr_anim[ "convoy_guard_1" ][ "convoy_arrives" ]	=%ch_pragueb_1_2_convoy_arrives_grd_01;
	addNotetrack_flag( "convoy_guard_1", "open_door", "door_guards_start", "convoy_arrives" );
	addNotetrack_flag( "convoy_guard_1", "start_makarov", "convoy_arrives_start_makarov", "convoy_arrives" );
	addNotetrack_flag( "convoy_guard_1", "close_door", "door_guards_close_door", "convoy_arrives" );
	level.scr_anim[ "convoy_guard_2" ][ "convoy_arrives" ]	=%ch_pragueb_1_2_convoy_arrives_grd_02;
	level.scr_anim[ "convoy_guard_3" ][ "convoy_arrives" ]	=%ch_pragueb_1_2_convoy_arrives_grd_03;
	
	level.scr_anim[ "makarov" ][ "convoy_arrives_idle" ][0]	=%ch_pragueb_1_2_makarov_idle_maka;
	level.scr_anim[ "makarov" ][ "convoy_arrives_signals" ]	=%ch_pragueb_1_2_makarov_signals_maka;
	
	level.scr_anim[ "door_guard_1" ][ "hotel_door_close" ]	= %ch_pragueb_1_2_door_guards_close_grd_01;
	level.scr_anim[ "door_guard_2" ][ "hotel_door_close" ]	= %ch_pragueb_1_2_door_guards_close_grd_02;
	level.scr_anim[ "door_guard_1" ][ "hotel_door_enter" ]	= %ch_pragueb_1_2_door_guards_enter_grd_01;
	level.scr_anim[ "door_guard_2" ][ "hotel_door_enter" ]	= %ch_pragueb_1_2_door_guards_enter_grd_02;
	level.scr_anim[ "door_guard_1" ][ "hotel_door_open" ]	= %ch_pragueb_1_2_door_guards_open_grd_01;
	level.scr_anim[ "door_guard_2" ][ "hotel_door_open" ]	= %ch_pragueb_1_2_door_guards_open_grd_02;
	level.scr_anim[ "door_guard_1" ][ "hotel_door_open_wait" ][0]	= %ch_pragueb_1_2_door_guards_open_wait_grd_01;
	level.scr_anim[ "door_guard_2" ][ "hotel_door_open_wait" ][0]	= %ch_pragueb_1_2_door_guards_open_wait_grd_02;
	level.scr_anim[ "door_guard_1" ][ "hotel_door_wait" ][0]	= %ch_pragueb_1_2_door_guards_wait_grd_01;
	level.scr_anim[ "door_guard_2" ][ "hotel_door_wait" ][0]	= %ch_pragueb_1_2_door_guards_wait_grd_02;

	// Price rappel
	level.scr_anim[ "price" ][ "rappel_hook_up_reveal" ]	= %ch_pragueb_1_3_hook_up_reveal_price;
	level.scr_anim[ "price" ][ "rappel_hook_up_idle" ][0]	= %ch_pragueb_1_3_hook_up_idle_price;
	level.scr_anim[ "price" ][ "rappel_hook_up" ]	= %ch_pragueb_1_3_hook_up_price;
	//addNotetrack_sound( "price", "dialogue01", "rappel_hook_up", "presc_pri_makarovsmeeting" );
	//addNotetrack_sound( "price", "dialogue02", "rappel_hook_up", "presc_pri_preparingtobreach" );
	addNotetrack_sound( "price", "dialogue03", "rappel_hook_up", "presc_mct_sentrysbalcony" );
	//addNotetrack_sound( "price", "dialogue04", "rappel_hook_up", "presc_pri_atleastweknow" );
	level.scr_anim[ "price" ][ "rappel_mid_idle" ][0]	= %ch_pragueb_1_3_idle_price;
	// addNotetrack_customFunction( "price", "balcony_patrol", maps\prague_escape_sniper::spawn_balcony_ai, "rappel_hook_up" );
		
	// Price window breach
	level.scr_anim[ "price" ][ "price_window_breach" ]	= %ch_pragueb_1_4_window_breach_price;
	addNotetrack_customFunction( "price", "ambush_guards", maps\prague_escape_sniper::spawn_breach_ai, "price_window_breach" );
	addNotetrack_sound( "price", "dialogue01", "price_window_breach", "presc_pri_breachingnow" );
	level.scr_anim[ "window_breach_grd_1" ][ "window_breach" ]	= %ch_pragueb_1_4_window_breach_grd_01;
	level.scr_anim[ "window_breach_grd_2" ][ "window_breach" ]	= %ch_pragueb_1_4_window_breach_grd_02;
	level.scr_anim[ "window_breach_grd_3" ][ "window_breach" ]	= %ch_pragueb_1_4_window_breach_grd_03;
	level.scr_anim[ "window_breach_grd_4" ][ "window_breach" ]	= %ch_pragueb_1_4_window_breach_grd_04;
	
	level.scr_anim[ "price" ][ "price_discover_kamarov" ] 	= %ch_pragueb_1_4_discover_kamarov_price;
	//addNotetrack_sound( "price", "dialogue02", "price_discover_kamarov", "presc_pri_allclear" );//Kamarov
	//addNotetrack_customFunction( "price", "dialogue02", maps\prague_escape_sniper::new_breach_vo_timing, "price_discover_kamarov" );
	//addNotetrack_sound( "price", "dialogue03", "price_discover_kamarov", "presc_mct_makarov" );//Im sorry price Im sorry
	//addnotetrack_sound( "price", "dialogue04", "price_discover_kamarov", "presc_pri_nosign" );//Kamarov what did you tell him
	//addnotetrack_flag( "price", "dialogue04", "price_discover_kamarov_open_doors", "price_discover_kamarov" );
	//addNotetrack_sound( "price", "dialogue05", "price_window_breach", "presc_mct_price" );//everything
	//addNotetrack_customFunction( "price", "dialogue06", maps\prague_escape_sniper::hotel_flashing_bomb_vo, "price_discover_kamarov" );
	//addNotetrack_sound( "price", "dialogue06", "price_discover_kamarov", "presc_pri_damnit" ); //Dammit
	addNotetrack_customFunction( "price", "dialogue06", maps\prague_escape_sniper::start_hotel_flashing_bomb, "price_discover_kamarov" );
	//addNotetrack_sound( "price", "dialogue07", "price_discover_kamarov", "presc_pri_itsasetup" );//its a setup
	//addNotetrack_sound( "price", "dialogue08", "price_discover_kamarov", "presc_mkv_welcometohell" );//Captian prive ["Welcome to hell"]
	//addnotetrack_sound( "price", "dialogue09", "price_discover_kamarov", "presc_mct_getouttathere" );	//Price get out of there!
	level.scr_anim[ "kamarov" ][ "kamarov_dead" ][0]	= %ch_pragueb_1_4_kamarov_dead_kama;
	
	level.scr_anim[ "balcony_guard_1" ][ "balcony_enter" ]	= %ch_pragueb_1_3_patrol_grd_01;
	level.scr_anim[ "balcony_guard_2" ][ "balcony_enter" ]	= %ch_pragueb_1_3_patrol_grd_02;
	level.scr_anim[ "balcony_guard_3" ][ "balcony_enter" ]	= %ch_pragueb_1_3_patrol_grd_03;
	level.scr_anim[ "balcony_guard_4" ][ "balcony_enter" ]	= %ch_pragueb_1_3_patrol_grd_04;
	
	// Scaffold Fall
	level.scr_anim[ "soap" ][ "scaffolding_fall" ]	= %ch_pragueb_2_2_scaffolding_fall_soap;
	addNotetrack_customFunction( "soap", "dialogue02", maps\prague_escape_scaffold::scaffolding_fall_dialogue, "scaffolding_fall" );
	addNotetrack_customFunction( "soap", "soap_hit_board_1", maps\prague_escape_scaffold::scaffold_soap_hit_board_1, "scaffolding_fall" );
	addNotetrack_flag( "soap", "dialogue03", "scaffolding_fall_dialogue_3", "scaffolding_fall" );
	
	level.scr_anim[ "soap" ][ "fade_in_a" ]	= %ch_pragueb_2_3_fade_in_a_soap;
	level.scr_anim[ "soap" ][ "fade_in_b" ]	= %ch_pragueb_2_3_fade_in_b_soap;
	level.scr_anim[ "soap" ][ "scaffold_soap_injured" ]	= %ch_pragueb_2_3_soap_injured_soap;
	
	level.scr_anim[ "price" ][ "limp_a" ]	= %ch_pragueb_2_3_limp_a_price;
	level.scr_anim[ "price" ][ "limp_b" ]	= %ch_pragueb_2_3_limp_b_price;
	level.scr_anim[ "price" ][ "scaffold_soap_injured" ]	= %ch_pragueb_2_3_soap_injured_price;
	addNotetrack_customFunction( "price", "dialogue01", maps\prague_escape_scaffold::soap_injured_dialogue, "scaffold_soap_injured" );
	addNotetrack_customFunction( "price", "fire_grenade", maps\prague_escape_scaffold::scaffold_m203_fire, "scaffold_soap_injured" );
	addNotetrack_customFunction( "price", "explosion", maps\prague_escape_scaffold::soap_injured_explosion, "scaffold_soap_injured" );
	addNotetrack_flag( "price", "dialogue02", "soap_injured_dialogue_2", "scaffold_soap_injured" );
	addNotetrack_flag( "price", "dialogue03", "soap_injured_dialogue_3", "scaffold_soap_injured" );
	addNotetrack_customFunction( "price", "rumble", maps\prague_escape_code::play_light_rumble, "scaffold_soap_injured" );
	addNotetrack_flag( "price", "dialogue04", "soap_injured_dialogue_4", "scaffold_soap_injured" );
		
	// Soap Carry
	level.scr_anim[ "soap" ][ "soap_carry_prone_soap" ][0] = %ch_pragueb_3_1_prone_soap;
	level.scr_anim[ "soap" ][ "soap_carry_pickup" ]	= %ch_pragueb_3_1_pickup_soap;
	// addNotetrack_customFunction( "soap", "dialogue01", maps\prague_escape_soap_carry::soap_carry_pickup_dialogue, "soap_carry_pickup" );
	// addNotetrack_flag( "soap", "dialogue02", "soap_carry_pickup_dialogue_2", "soap_carry_pickup" );
	level.scr_anim[ "soap" ][ "soap_carry_idle" ][0]	= %ch_pragueb_3_1_idle_soap;
	level.scr_anim[ "soap" ][ "soap_carry_run" ][0]	= %ch_pragueb_3_1_run_soap;
	
	level.scr_anim[ "price" ][ "grenade_fire_a" ]	= %ch_pragueb_3_1_grenade_fire_a_price;
	level.scr_anim[ "price" ][ "grenade_fire_b" ]	= %ch_pragueb_3_1_grenade_fire_b_price;
	addNotetrack_customFunction( "price", "fire_grenade", maps\prague_escape_soap_carry::fire_m203_a, "grenade_fire_a" );
	addNotetrack_customFunction( "price", "fire_grenade", maps\prague_escape_soap_carry::fire_m203_b, "grenade_fire_b" );	
	addNotetrack_customFunction( "price", "dialogue01", maps\prague_escape_soap_carry::fire_m203_b_dialogue, "grenade_fire_b" );
	
	// Blood cough/smoke grenade toss
	level.scr_anim[ "soap" ][ "soap_carry_cough" ]	= %ch_pragueb_3_2_cough_soap;
	level.scr_anim[ "price" ][ "soap_carry_cough_stop" ]	= %ch_pragueb_3_2_throw_smoke_price;
	addNotetrack_flag( "price", "pull_pin", "soap_carry_cough_throw_smoke", "soap_carry_cough_stop" );
	addNotetrack_customfunction( "price", "dialogue02", maps\prague_escape_soap_carry::price_cough_stop_dialogue, "soap_carry_cough_stop" );
	addNotetrack_flag( "price", "dialogue03", "soap_carry_cough_stop_dialogue_3", "soap_carry_cough_stop" );
	addNotetrack_flag( "price", "dialogue04", "soap_carry_cough_stop_dialogue_4", "soap_carry_cough_stop" );
	level.scr_anim[ "soap" ][ "soap_carry_cough_stop" ]	= %ch_pragueb_3_1_cough_stop_soap;
	addNotetrack_customFunction( "soap", "dialogue01", maps\prague_escape_soap_carry::soap_cough_stop_dialogue, "soap_carry_cough_stop" );
	
	// Shoot launcher at wall
	level.scr_anim[ "price" ][ "clear_path_in" ]	= %ch_pragueb_3_3_clear_path_in_price;
	level.scr_anim[ "price" ][ "clear_path_loop" ][0]	= %ch_pragueb_3_3_clear_path_loop_price;
	level.scr_anim[ "price" ][ "clear_path_out" ]	= %ch_pragueb_3_3_clear_path_out_price;
	addNotetrack_customFunction( "price", "fire_grenade", maps\prague_escape_soap_carry::fire_m203_at_wall, "clear_path_out" );
	addNotetrack_customFunction( "price", "dialogue01", maps\prague_escape_soap_carry::clear_path_dialogue, "clear_path_in" );
	addNotetrack_flag( "price", "dialogue02", "clear_path_dialogue_2", "clear_path_out" );
	
	// Place soap down, get gun
	level.scr_anim[ "price" ][ "toss_gun_idle" ][0]	= %ch_pragueb_3_5_toss_m203_idle_price;
	level.scr_anim[ "price" ][ "toss_gun_in" ]	= %ch_pragueb_3_5_toss_m203_in_price;
	level.scr_anim[ "price" ][ "toss_gun" ]	= %ch_pragueb_3_5_toss_m203_price;
	//addNotetrack_customFunction( "price", "dialog_01", maps\prague_escape_soap_carry::toss_gun_dialogue, "toss_gun" );
	addNotetrack_customFunction( "price", "handoff_rumble", maps\prague_escape_code::play_light_rumble, "toss_gun" );	
	level.scr_anim[ "soap" ][ "toss_gun" ]	= %ch_pragueb_3_5_toss_m203_soap;
		
	// section 2  ////////////////////////////////////////////////////////////////////////////////////////
	// Dumpster to Room Clear
	level.scr_anim[ "price" ][ "soap_lift_dumpster" ] 	= %ch_pragueb_4_1_priceliftsoap_price;
	level.scr_anim[ "soap" ][ "soap_lift_dumpster" ] 	= %ch_pragueb_4_1_priceliftsoap_soap;
	level.scr_anim[ "price" ][ "kickdoor_dumpster" ] 	= %ch_pragueb_4_2_kickdoor_price;
	level.scr_anim[ "soap" ][ "kickdoor_dumpster" ] 	= %ch_pragueb_4_2_kickdoor_soap;
	level.scr_anim[ "price" ][ "idle_roomclear" ][0] 	= %ch_pragueb_4_3_idle_price;
	level.scr_anim[ "soap" ][ "idle_roomclear" ][0] 	= %ch_pragueb_4_3_idle_soap;
	level.scr_anim[ "price" ][ "reachroom" ] 	= %ch_pragueb_4_3_reachroom_price;
	level.scr_anim[ "soap" ][ "reachroom" ] 	= %ch_pragueb_4_3_reachroom_soap;
	level.scr_anim[ "price" ][ "reachdoor" ] 	= %ch_pragueb_4_4_reachdoor_price;
	addNotetrack_customFunction( "price", "bang", maps\prague_escape_dumpster::enter_china_shop, "reachdoor" );
	level.scr_anim[ "soap" ][ "reachdoor" ] 	= %ch_pragueb_4_4_reachdoor_soap;
	level.scr_anim[ "price" ][ "clearroom" ][0] 	= %ch_pragueb_4_4_clearroom_price;
	addNotetrack_customFunction( "price", "bang", maps\prague_escape_dumpster::enter_china_shop, "clearroom" );
	level.scr_anim[ "soap" ][ "clearroom" ][0] 	= %ch_pragueb_4_4_clearroom_soap;
	addNotetrack_customFunction( "soap", "bang", maps\prague_escape_dumpster::enter_china_shop, "clearroom" );
	level.scr_anim[ "price" ][ "idle_clearroom" ][0] 	= %ch_pragueb_4_4_clearroomidle_price;
	level.scr_anim[ "soap" ][ "idle_clearroom" ][0] 	= %ch_pragueb_4_4_clearroomidle_soap;
	level.scr_anim[ "price" ][ "doorbreach" ] 	= %ch_pragueb_4_4_doorbreach_price;
	level.scr_anim[ "soap" ][ "doorbreach" ] 	= %ch_pragueb_4_4_doorbreach_soap;
	addNotetrack_customFunction( "soap", "magic_shot", maps\prague_escape_dumpster::soap_shoots_breacher, "doorbreach" );
	
	level.scr_animtree[ "dead_guy" ] = #animtree;
	level.scr_anim[ "dead_guy" ][ "resist_death01"] = %dying_crawl_death_v1;
	level.scr_anim[ "dead_guy" ][ "resist_death02"] = %dying_back_death_v1;
	level.scr_anim[ "dead_guy" ][ "resist_death03"] = %crawl_death_front;
		
	// Room Clear to Statue
	level.scr_anim[ "price" ][ "to_courtyard" ] 	= %ch_pragueb_5_1_courtyard_price;
	level.scr_anim[ "soap" ][ "to_courtyard" ] 	= %ch_pragueb_5_1_courtyard_soap;
	level.scr_anim[ "soap" ][ "idle_statue" ][0] 	= %ch_pragueb_5_2_statue_idleloop_soap;
	level.scr_anim[ "price" ][ "statue" ] 	= %ch_pragueb_5_2_statue_price;
	addNotetrack_customFunction( "price", "fire", maps\prague_escape_store::price_shoots_someone, "statue" );
	level.scr_anim[ "soap" ][ "statue" ] 	= %ch_pragueb_5_2_statue_soap;
	level.scr_anim[ "price" ][ "statue_leave" ] 	= %ch_pragueb_5_2_statueleave_price;
	addNotetrack_customFunction( "price", "drop_gunground", maps\prague_escape_store::price_statue_gundrop, "statue_leave" );
	addNotetrack_customFunction( "price", "attach_pistol", maps\prague_escape_store::price_statue_drawpistol, "statue_leave" );
	level.scr_anim[ "soap" ][ "statue_leave" ] 	= %ch_pragueb_5_2_statueleave_soap;
		
	// Statue to Tunnel
	level.scr_anim[ "price" ][ "thru_building" ] 	= %ch_pragueb_6_1_throughbuilding_price;
	addNotetrack_customFunction( "price", "kick_door", maps\prague_escape_store::courtyard_doors, "thru_building" );
	level.scr_anim[ "soap" ][ "thru_building" ] 	= %ch_pragueb_6_1_throughbuilding_soap;
	level.scr_anim[ "price" ][ "advance_building" ] 	= %ch_pragueb_6_1_throughbuilding_advance_price;
	level.scr_anim[ "soap" ][ "advance_building" ] 	= %ch_pragueb_6_1_throughbuilding_advance_soap;
	level.scr_anim[ "price" ][ "take_cover" ] 	= %ch_pragueb_6_1_throughbuilding_takecover_price;
	level.scr_anim[ "soap" ][ "take_cover" ] 	= %ch_pragueb_6_1_throughbuilding_takecover_soap;
	level.scr_anim[ "price" ][ "idle_building" ][0] 	= %ch_pragueb_6_1_throughbuilding_loop_price;
	level.scr_anim[ "soap" ][ "idle_building" ][0] 	= %ch_pragueb_6_1_throughbuilding_loop_soap;
	level.scr_anim[ "price" ][ "cover_exit" ] 	= %ch_pragueb_6_1_throughbuilding_takecover_exit_price;
	level.scr_anim[ "soap" ][ "cover_exit" ] 	= %ch_pragueb_6_1_throughbuilding_takecover_exit_soap;
	level.scr_anim[ "price" ][ "to_street" ] 	= %ch_pragueb_6_2_street_price;
	level.scr_anim[ "soap" ][ "to_street" ] 	= %ch_pragueb_6_2_street_soap ;
	level.scr_anim[ "price" ][ "idle_street" ][0] 	= %ch_pragueb_6_2_street_idleloop_price;
	level.scr_anim[ "soap" ][ "idle_street" ][0] 	= %ch_pragueb_6_2_street_idleloop_soap;
	
	// Tunnel to Bank
	level.scr_anim[ "price" ][ "to_tunnel" ] 	= %ch_pragueb_7_1_alleytunnel_price;
	level.scr_anim[ "soap" ][ "to_tunnel" ] 	= %ch_pragueb_7_1_alleytunnel_soap;
	level.scr_anim[ "price" ][ "bank_divert" ] 	= %ch_pragueb_7_2_enemyarrive_price;
	addNotetrack_customFunction( "price", "fire", maps\prague_escape_bank::price_shootat_enemy, "bank_divert" );
	level.scr_anim[ "soap" ][ "bank_divert" ] 	= %ch_pragueb_7_2_enemyarrive_soap;
	level.scr_anim[ "price" ][ "enter_bank" ] 	= %ch_pragueb_7_3_enterbank_price;
	addNotetrack_customFunction( "price", "fire", maps\prague_escape_bank::price_shootat_enemy, "enter_bank" );
	level.scr_anim[ "soap" ][ "enter_bank" ] 	= %ch_pragueb_7_3_enterbank_soap;
	level.scr_anim[ "price" ][ "idle_bank_battle" ][0] 	= %ch_pragueb_7_4_bankbattle_loop__price;
	addNotetrack_customFunction( "price", "fire", maps\prague_escape_bank::price_kill_enemy, "idle_bank_battle" );
	level.scr_anim[ "soap" ][ "idle_bank_battle" ][0] 	= %ch_pragueb_7_4_bankbattle_loop__soap;
	addNotetrack_customFunction( "soap", "fire", maps\prague_escape_bank::soap_kill_enemy, "idle_bank_battle" );
	level.scr_anim[ "price" ][ "exit_bank" ] 	= %ch_pragueb_7_4_bankexit_price;
	level.scr_anim[ "soap" ][ "exit_bank" ] 	= %ch_pragueb_7_4_bankexit_soap;
		
	// Bank to Defend
	level.scr_anim[ "price" ][ "crosscourt" ] 	= %ch_pragueb_7_5_crosscourt_price;
	addNotetrack_customFunction( "price", "hide_gun", maps\prague_escape_defend::price_holster_weapon, "crosscourt" );
	addNotetrack_customFunction( "price", "bang", maps\prague_escape_defend::price_shoots_weapon, "crosscourt" );
	level.scr_anim[ "soap" ][ "crosscourt" ] 	= %ch_pragueb_7_5_crosscourt_soap;
	level.scr_anim[ "price" ][ "crossplaza" ] 	= %ch_pragueb_7_5_crossplaza_price;
	addNotetrack_customFunction( "price", "show_m16", maps\prague_escape_defend::price_retrieve_weapon, "crossplaza" );
	level.scr_anim[ "soap" ][ "crossplaza" ] 	= %ch_pragueb_7_5_crossplaza_soap;
	level.scr_anim[ "soap" ][ "idle_fire_soap" ][0] 	= %ch_pragueb_8_1_plazadefend_fire_soap;
	level.scr_anim[ "soap" ][ "idle_soap" ][0] 	= %ch_pragueb_8_1_plazadefend_idle_soap;
	
	// Resistance Carry
	level.scr_anim[ "resistance1" ][ "resistancearrive2" ] 	= %ch_pragueb_9_1_resistancearrive_guy01;
	level.scr_anim[ "resistance2" ][ "resistancearrive2" ] 	= %ch_pragueb_9_1_resistancearrive_guy02;
	level.scr_anim[ "resistance3" ][ "resistancearrive2" ] 	= %ch_pragueb_9_1_resistancearrive_guy03;
	level.scr_anim[ "resistance4" ][ "resistancearrive1" ] 	= %ch_pragueb_9_1_resistancearrive_guy04;
	level.scr_anim[ "resistance_leader" ][ "resistancearrive1" ] 	= %ch_pragueb_9_1_resistancearrive_leader;
	level.scr_anim[ "price" ][ "resistancearrive1" ] 	= %ch_pragueb_9_1_resistancearrive_price;
	level.scr_anim[ "soap" ][ "resistancearrive1" ] 	= %ch_pragueb_9_1_resistancearrive_soap;
	
	level.scr_anim[ "resistance4" ][ "idle_carry" ][0] 	= %ch_pragueb_9_2_resistancecarry_loop_guy04;
	level.scr_anim[ "resistance_leader" ][ "idle_carry" ][0] 	= %ch_pragueb_9_2_resistancecarry_loop_leader;
	level.scr_anim[ "price" ][ "idle_carry" ][0] 	= %ch_pragueb_9_2_resistancecarry_loop_price;
	level.scr_anim[ "soap" ][ "idle_carry" ][0] 	= %ch_pragueb_9_2_resistancecarry_loop_soap;
	
	level.scr_anim[ "resistance4" ][ "resistancecarry" ] 	= %ch_pragueb_9_2_resistancecarry_guy04;
	level.scr_anim[ "resistance_leader" ][ "resistancecarry" ] 	= %ch_pragueb_9_2_resistancecarry_leader;
	level.scr_anim[ "price" ][ "resistancecarry" ] 	= %ch_pragueb_9_2_resistancecarry_price;
	level.scr_anim[ "soap" ][ "resistancecarry" ] 	= %ch_pragueb_9_2_resistancecarry_soap;
	
	level.scr_anim[ "resistance4" ][ "idle_table" ][0] 	= %ch_pragueb_9_2_resistancecarry_tableloop_guy04;
	level.scr_anim[ "resistance_leader" ][ "idle_table" ][0] 	= %ch_pragueb_9_2_resistancecarry_tableloop_leader;
	level.scr_anim[ "price" ][ "idle_table" ][0] 	= %ch_pragueb_9_2_resistancecarry_tableloop_price;
	level.scr_anim[ "soap" ][ "idle_table" ][0] 	= %ch_pragueb_9_2_resistancecarry_tableloop_soap;
	
	level.scr_anim[ "resistance_leader" ][ "idle_clear_table" ][0] = %ch_pragueb_10_1_clear_table_idle_guy1;
	level.scr_anim[ "resistance_leader" ][ "clear_table" ]	= %ch_pragueb_10_1_clear_table_guy1;
		
	// Generic
	level.scr_anim[ "enemy" ][ "balcony_death" ] 	= %ch_pragueb_5_2_statue_balconydeath01;
	level.scr_anim[ "enemy" ][ "idle_balcony_death" ][0] 	= %ch_pragueb_5_2_statue_balconydeath01_loop;
	
	level.scr_anim[ "enemy" ][ "bank_entry_dive" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_diveover;
	addNotetrack_customFunction( "enemy", "window_break", maps\prague_escape_bank::window_break_dive, "bank_entry_dive" );
	level.scr_anim[ "enemy" ][ "bank_entry_jump" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_jumpover;
	addNotetrack_customFunction( "enemy", "window_break", maps\prague_escape_bank::window_break_jump, "bank_entry_jump" );
	level.scr_anim[ "enemy" ][ "bank_entry_left" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_windowleft;
	level.scr_anim[ "enemy" ][ "bank_entry_right" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_windowright;
	
	level.scr_anim[ "enemy" ][ "bank_entry_door1" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_guycover01;
	level.scr_anim[ "enemy" ][ "bank_entry_door2" ] 	= %ch_pragueb_7_4_bankbattle_enemyentry_guycover02;
	level.scr_anim[ "enemy" ][ "court_mantle_A" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_A;
	level.scr_anim[ "enemy" ][ "court_mantle_B" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_B;
	level.scr_anim[ "enemy" ][ "court_mantle_C" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_C;
	level.scr_anim[ "enemy" ][ "court_mantle_D" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_D;
	level.scr_anim[ "enemy" ][ "court_mantle_E" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_E;
	level.scr_anim[ "enemy" ][ "court_mantle_F" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_F;
	level.scr_anim[ "enemy" ][ "court_mantle_G" ] 	= %ch_pragueb_7_5_crosscourt_aimantle_G;
	level.scr_anim[ "enemy" ][ "court_jumpdown_A" ] 	= %ch_pragueb_7_5_crosscourt_aitmantle_off_A;
	level.scr_anim[ "enemy" ][ "court_jumpdown_B" ] 	= %ch_pragueb_7_5_crosscourt_aitmantle_off_B;
	level.scr_anim[ "enemy" ][ "court_jumpdown_C" ] 	= %ch_pragueb_7_5_crosscourt_aitmantle_off_C;
	level.scr_anim[ "enemy" ][ "sprint" ]		 = %sprint1_loop;
	level.scr_anim[ "enemy" ][ "box_traverse_A" ] 	= %ch_pragueb_8_1_plazadefend_boxtraverseA;
	level.scr_anim[ "enemy" ][ "box_traverse_B" ] 	= %ch_pragueb_8_1_plazadefend_boxtraverseB;
	level.scr_anim[ "enemy" ][ "box_traverse_C" ] 	= %ch_pragueb_8_1_plazadefend_boxtraverseC;
	level.scr_anim[ "enemy" ][ "box_traverse_D" ] 	= %ch_pragueb_8_1_plazadefend_boxtraverseD;
	level.scr_anim[ "enemy" ][ "fence_traverse" ] 	= %ch_pragueb_8_1_plazadefend_fencetraverse;
	
	level.scr_anim[ "door_breacher" ][ "doorbreach" ] 	= %ch_pragueb_4_4_doorbreach_doorkicker;
		
	level.scr_anim[ "btr_victim" ][ "death_window" ] 	= %ch_pragueb_9_1_resistancewindow_death;
	addNotetrack_customFunction( "btr_victim", "start_ragdoll", maps\prague_escape_defend::kill_btr_victim, "death_window" );
	
	level.scr_anim[ "generic" ][ "death_forward" ] 	= %stand_death_stumbleforward;
	
	
	// section 3  ////////////////////////////////////////////////////////////////////////////////////////
	
	//SOAP DEATH
	level.scr_anim[ "price" ][ "gesture" ] 					   = %ch_pragueb_10_1_savingsoap_callingplayer_price;
	addNotetrack_customFunction( "price", "dialogue01", maps\prague_escape_medic::price_gesture_dialogue, "gesture" );	
	
//	level.scr_anim[ "price" ][ "soap_convulsion" ] 						 = %ch_pragueb_10_1_savingsoap_convulsion_price;	
//	addNotetrack_customFunction( "price", "presc_pri_helpdamnit", maps\prague_escape_medic::price_convulsion_dialogue, "soap_convulsion" );	
//	addNotetrack_flag( "price", "presc_pri_waitingfor", "price_convulsion_waitingfor", "soap_convulsion" );
////	addNotetrack_flag( "price", "dialogue10", "price_convulsion_dialogue10", "soap_convulsion" );
//	addNotetrack_flag( "price", "presc_pri_soap2", "price_convulsion_soap2", "soap_convulsion" );

// 	level.scr_anim[ "soap" ][ "soap_convulsion" ] 						 = %ch_pragueb_10_1_savingsoap_convulsion_soap;	
//	addNotetrack_customFunction( "soap", "presc_mct_price2", maps\prague_escape_medic::soap_convulsion_dialogue, "soap_convulsion" );
//	addNotetrack_flag( "soap", "presc_mct_needtoknow", "soap_convulsion_needtoknow", "soap_convulsion" );	
//	addNotetrack_flag( "soap", "presc_mct_knowsyuri", "soap_convulsion_knowsyuri", "soap_convulsion" );	

//	level.scr_anim[ "resistance_guy1" ][ "soap_convulsion" ]   = %ch_pragueb_10_1_savingsoap_convulsion_soldier1;	
//	level.scr_anim[ "resistance_guy2" ][ "soap_convulsion" ]   = %ch_pragueb_10_1_savingsoap_convulsion_soldier2;	

//	level.scr_anim[ "price" ][ "gasp_in" ] 						  = %ch_pragueb_10_1_savingsoap_gasp_in_price;	
// 	level.scr_anim[ "soap" ][ "gasp_in" ] 						  = %ch_pragueb_10_1_savingsoap_gasp_in_soap;	
//	level.scr_anim[ "resistance_guy1" ][ "gasp_in" ]    = %ch_pragueb_10_1_savingsoap_gasp_in_soldier1;	
//	level.scr_anim[ "resistance_guy2" ][ "gasp_in" ]    = %ch_pragueb_10_1_savingsoap_gasp_in_soldier2;	
//
//	level.scr_anim[ "price" ][ "gasp_out" ] 						= %ch_pragueb_10_1_savingsoap_gasp_out_price;	
// 	level.scr_anim[ "soap" ][ "gasp_out" ] 						  = %ch_pragueb_10_1_savingsoap_gasp_out_soap;	
//	level.scr_anim[ "resistance_guy1" ][ "gasp_out" ]   = %ch_pragueb_10_1_savingsoap_gasp_out_soldier1;	
//	level.scr_anim[ "resistance_guy2" ][ "gasp_out" ]   = %ch_pragueb_10_1_savingsoap_gasp_out_soldier2;

	level.scr_anim[ "price" ][ "no_pressure" ][0] = %ch_pragueb_10_1_savingsoap_nopressure_price;
	addNotetrack_flag( "price", "dialogue02", "price_put_pressure_dialogue02", "no_pressure" );	
	
 	level.scr_anim[ "soap" ][ "no_pressure" ][0] 			  = %ch_pragueb_10_1_savingsoap_nopressure_soap;	
	level.scr_anim[ "resistance_guy1" ][ "no_pressure" ][0]   = %ch_pragueb_10_1_savingsoap_nopressure_soldier1;	
	level.scr_anim[ "resistance_guy2" ][ "no_pressure" ][0]   = %ch_pragueb_10_1_savingsoap_nopressure_soldier2;	

	//level.scr_anim[ "price" ][ "pressure" ] 						= %ch_pragueb_10_1_savingsoap_pressure_price;	
 	//level.scr_anim[ "soap" ][ "pressure" ] 						  = %ch_pragueb_10_1_savingsoap_pressure_soap;	
	//level.scr_anim[ "resistance_guy1" ][ "pressure" ]   = %ch_pragueb_10_1_savingsoap_pressure_soldier1;	
	//level.scr_anim[ "resistance_guy2" ][ "pressure" ]   = %ch_pragueb_10_1_savingsoap_pressure_soldier2;	
	
	level.scr_anim[ "price" ][ "slow_death" ] 						= %ch_pragueb_10_1_savingsoap_slowdeath_price;
	addNotetrack_customFunction( "price", "presc_pri_donttrytospeak", maps\prague_escape_medic::price_slowdeath_dialogue, "slow_death" );	
	addNotetrack_flag( "price", "presc_pri_tellmelater", "price_slowdeath_tellmelater", "slow_death" );
	addNotetrack_flag( "price", "presc_pri_soap2", "price_slowdeath_soap2", "slow_death" );

 	level.scr_anim[ "soap" ][ "slow_death" ] 						  = %ch_pragueb_10_1_savingsoap_slowdeath_soap;	
	addNotetrack_customFunction( "soap", "presc_mct_price2", maps\prague_escape_medic::soap_slowdeath_dialogue, "slow_death" );
	addNotetrack_flag( "soap", "presc_mct_needtoknow", "soap_slowdeath_needtoknow", "slow_death" );	
 	addNotetrack_flag( "soap", "presc_mct_knowsyuri", "soap_slowdeath_knowsyuri", "slow_death" );	
 	
	level.scr_anim[ "resistance_guy1" ][ "slow_death" ]   = %ch_pragueb_10_1_savingsoap_slowdeath_soldier1;	
	level.scr_anim[ "resistance_guy2" ][ "slow_death" ]   = %ch_pragueb_10_1_savingsoap_slowdeath_soldier2;	
	
	/* -=-=-=-=-=-=-=-=
	NEW SOAP DEATH
	-=-=-=-=-=-=-=-=-=*/
	
	level.scr_anim[ "price" ][ "soap_death" ]   						= %prague_escape_soap_death_price;
	level.scr_anim[ "price" ][ "soap_death_idle" ][0]  					= %prague_escape_soap_death_price_idle;
	level.scr_anim[ "soap" ][ "soap_death" ]   							= %prague_escape_soap_death_soap;
	level.scr_anim[ "soap" ][ "soap_dead" ][0]   							= %prague_escape_soap_death_soap_idle_noloop;
	level.scr_anim[ "soap" ][ "soap_death_idle" ][0]   					= %prague_escape_soap_death_soap_idle;
	level.scr_anim[ "resistance_leader" ][ "soap_death" ]  				= %prague_escape_soap_death_resistance;
	level.scr_anim[ "resistance_leader" ][ "soap_death_idle" ][0] 		 	= %prague_escape_soap_death_resistance_idle;
	level.scr_anim[ "resistance_leader" ][ "soap_death_window_run" ]   	= %prague_escape_soap_death_resistance_runtowindow;
	addNotetrack_customFunction( "price", "attach_pistol", maps\prague_escape_medic::price_attach_pistol, "soap_death" );
	addNotetrack_customFunction( "price", "detach_pistol", maps\prague_escape_medic::price_detach_pistol, "soap_death" );
	addNotetrack_customFunction( "price", "attach_journal", maps\prague_escape_medic::price_attach_journal, "soap_death" );
	addNotetrack_customFunction( "price", "detach_journal", maps\prague_escape_medic::price_detach_journal, "soap_death" );
	
	
	//ESCAPE TO CELLAR
	level.scr_anim[ "price" ][ "escape_loop" ][0] 						 						= %ch_pragueb_11_1_escape_price_loop;
	level.scr_anim[ "price" ][ "escape" ] 								 		 						= %ch_pragueb_11_1_escape_price;
	
	level.scr_anim[ "soap" ][ "escape_loop" ][0] 							 						= %ch_pragueb_11_1_escape_soap_loop;
	
	level.scr_anim[ "resistance_guy1" ][ "escape_loop" ][0]	   						= %ch_pragueb_11_1_escape_res_guy_1_loop;
	level.scr_anim[ "resistance_guy1" ][ "escape" ] 				 	 						= %ch_pragueb_11_1_escape_res_guy_1;

	level.scr_anim[ "resistance_guy2" ][ "escape_loop" ][0]	   						= %ch_pragueb_11_1_escape_res_guy_2_loop;
	level.scr_anim[ "resistance_guy2" ][ "escape" ] 				 	 						= %ch_pragueb_11_1_escape_res_guy_2;
	addNotetrack_flag( "resistance_guy1", "blood_fx", "start_blood_fx", "escape" );
	addNotetrack_customFunction( "resistance_guy1", "start_ragdoll", maps\prague_escape_medic::kill_resistance_guy, "escape" );	
	addNotetrack_customFunction( "resistance_guy2", "kill_me", maps\prague_escape_medic::kill_resistance_guy, "escape" );
	
	level.scr_anim[ "resistance_leader" ][ "escape" ] 				 						= %ch_pragueb_11_1_escape_res_leader;
	addNotetrack_customFunction( "resistance_leader", "dialogue01", maps\prague_escape_to_cellar::resistance_leader_escape_dialogue, "escape" );
	addNotetrack_flag( "resistance_leader", "dialogue02", "leader_escape_dialogue02", "escape" );
	addNotetrack_flag( "resistance_leader", "dialogue03", "leader_escape_dialogue03", "escape" );
	
	level.scr_anim[ "resistance_leader" ][ "escape_loop" ][0]	 						= %ch_pragueb_11_1_escape_res_leader_loop;
	level.scr_anim[ "resistance_leader" ][ "escape_shoot_loop" ][0] 			= %ch_pragueb_11_1_escape_res_leader_wave_loop;
	level.scr_anim[ "resistance_leader" ][ "escape_wave" ]							 	= %ch_pragueb_11_1_escape_res_leader_wave;
	addNotetrack_flag( "resistance_leader", "leader_wave_start", "leader_wave_set", "escape_shoot_loop" );
	addNotetrack_flag_clear( "resistance_leader", "leader_wave_clear", "leader_wave_set", "escape_shoot_loop" );

	//CELLAR PRICE PUNCH
	level.scr_anim[ "price" ][ "price_punch_loop" ][0] 				 = %ch_pragueb_12_1_punch_price_loop;
	level.scr_anim[ "price" ][ "price_punch" ]								 = %ch_pragueb_11_1_punch_price;
	addNotetrack_customFunction( "price", "dialog_01", maps\prague_escape_to_cellar::price_punch_dialogue, "price_punch" );
	addNotetrack_flag( "price", "dialog_02", "price_punch_dialog_02", "price_punch" );
	addNotetrack_flag( "price", "dialog_03", "price_punch_dialog_03", "price_punch" );
	addNotetrack_customFunction( "price", "open_door", maps\prague_escape_code::play_light_rumble, "price_punch" );

	//ONE SHOT ONE KILL FLASHBACK
	level.scr_anim[ "makarov" ][ "no_time" ]				 					 = %ch_pragueb_13_1_no_time_maka;
	//addNotetrack_customFunction( "makarov", "dialogue02", maps\prague_escape_flashback_sniper::makarov_no_time_dialogue, "no_time" );
	//addNotetrack_flag( "makarov", "dialogue03", "makarov_no_time_dialogue03", "no_time" );
	//addNotetrack_flag( "makarov", "dialogue04", "makarov_no_time_dialogue04", "no_time" );
	//addNotetrack_flag( "makarov", "dialogue05", "makarov_no_time_dialogue05", "no_time" );
	
	level.scr_anim[ "guard_1" ][ "bullet_strikes" ]				 					 = %ch_pragueb_13_3_bullet_strikes_grd_01;
	level.scr_anim[ "guard_2" ][ "bullet_strikes" ]				 					 = %ch_pragueb_13_3_bullet_strikes_grd_02;
	
	level.scr_anim[ "makarov" ][ "bullet_strikes" ]				 					 = %ch_pragueb_13_3_bullet_strikes_maka;
	addNotetrack_flag( "makarov", "dialogue06", "makarov_bullet_strike_dialogue03", "bullet_strikes" );
	
	level.scr_anim[ "zakhaev" ][ "bullet_strikes" ]				 					 = %ch_pragueb_13_3_bullet_strikes_zakh;
	addNotetrack_flag( "zakhaev", "dialogue07", "zakhaev_bullet_strike_dialogue04", "bullet_strikes" );

	level.scr_anim[ "generic" ][ "cqb_stop" ]			 			 = %CQB_stop_2_signal;
	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			 = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			 = %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "exchange_surprise_2" ]			 = %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			 = %exposed_idle_twitch_v4;
 	level.surprise_anims = 4;

	level.scr_anim[ "zakhaev" ][ "exchange_short" ]					 = %ch_pragueb_13_1_meeting_zakhaev;
	addNotetrack_customFunction( "zakhaev", "presc_zkv_whatdoyou", maps\prague_escape_flashback_sniper::zakhaev_deal_dialogue, "exchange_short" );
	addNotetrack_flag( "zakhaev", "presc_zkv_hadadeal", "zakhaev_exchange_hadadeal", "exchange_short" );
	addNotetrack_flag( "zakhaev", "presc_zkv_argueover", "zakhaev_exchange_argueover", "exchange_short" );
	addNotetrack_flag( "zakhaev", "presc_zkv_knownbetter", "zakhaev_exchange_knownbetter", "exchange_short" );	
	addNotetrack_flag( "zakhaev", "flag_drop_1", "drop_the_flag", "exchange_short" );	
	
	level.scr_anim[ "guard" ][ "exchange_short" ]						 = %ch_pragueb_13_1_meeting_guard;
	level.scr_anim[ "dealer" ][ "exchange_short" ]					 = %ch_pragueb_13_1_meeting_dealer;
	
	level.scr_animtree[ "zakhaev" ] 							 = #animtree;
	level.scr_model[ "zakhaev" ] 							 	 	 = "body_complete_onearm_sp_zakhaev";

	level.scr_anim[ "zakhaev" ][ "zak_pain" ]			 = %sniper_escape_meeting_zakhaev_hit_front;// exposed_pain_2_crouch;
	
	level.scr_anim[ "generic" ][ "stealth_jog" ]	 = %patrol_jog;
	level.scr_anim[ "generic" ][ "stealth_walk" ]	 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "combat_jog" ]		 = %combat_jog;

	level.scr_anim[ "generic" ][ "bored_cell_loop" ][ 0 ]		 = %patrol_bored_idle_cellphone;
	
	level.scr_anim[ "generic" ][ "smoking_lean_idle" ][ 0 ]			 = %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking_lean_twitch" ][ 0 ]		 = %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_lean_react" ]					 = %parabolic_leaning_guy_react;
	
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			 	 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 1 ]				 = %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 2 ]			 	 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]			 	 = %patrol_bored_idle_smoke;
 	
	//SHOCK AND AWE
	level.scr_animtree[ "makarov" ]								= #animtree;
	level.scr_anim[ "makarov" ][ "shock_and_awe" ]				= %ch_pragueb_14_1_shockandawe_makarov;
	level.scr_anim[ "makarov" ][ "phonecall" ]					= %ch_pragueb_14_1_shockandawe_makarov_phonecall;
	addNotetrack_flag( "makarov", "take_phone", "FLAG_nuke_makarov_take_phone", "phonecall" );
	level.scr_anim[ "makarov" ][ "blast" ]						= %ch_pragueb_14_1_shockandawe_makarov_blast;
	level.scr_anim[ "makarov" ][ "idle" ][ 0 ]					= %ch_pragueb_14_1_shockandawe_makarov_idle;
	level.scr_anim[ "poor_bastard" ][ "crewchief_sucked_out" ]	= %airlift_crewchief_sucked_out;

	//AIRPORT
	level.scr_anim[ "kiril" ][ "betray_me" ]	= %ch_pragueb_15_1_betray_me_guy_1;
	level.scr_anim[ "lev" ][ "betray_me" ]		= %ch_pragueb_15_1_betray_me_guy_2;
	level.scr_anim[ "makarov" ][ "betray_me" ]	= %ch_pragueb_15_1_betray_me_makarov;
	addNotetrack_flag( "makarov", "fire", "makarov_shoots_yuri", "betray_me" );
	
	level.scr_animtree[ "hurt_officer_1" ] 						= #animtree;		
	level.scr_model["hurt_officer_1"] 							= "body_secret_service_assault_a";
	level.scr_anim[ "hurt_officer_1" ][ "wounded_civ" ]			= %ch_pragueb_15_6_wounded_civ_01;
	level.scr_anim[ "hurt_officer_1" ][ "wounded_civ_loop" ][0]	= %ch_pragueb_15_6_wounded_civ_01_loop;
	
	level.scr_animtree[ "hurt_officer_2" ] 						= #animtree;		
	level.scr_model["hurt_officer_2"] 							= "body_secret_service_assault_a";	
	level.scr_anim[ "hurt_officer_2" ][ "wounded_civ" ]			= %ch_pragueb_15_6_wounded_civ_02;
	level.scr_anim[ "hurt_officer_2" ][ "wounded_civ_loop" ][0]	= %ch_pragueb_15_6_wounded_civ_02_loop;

	level.scr_animtree[ "wounded_officer" ] 							= #animtree;		
	level.scr_model["wounded_officer"] 									= "body_secret_service_assault_a";
	level.scr_anim[ "wounded_officer" ][ "wounded_officer" ]  			= %ch_pragueb_15_6_wounded_officer;
	level.scr_anim[ "wounded_officer" ][ "wounded_officer_loop" ][0]	= %ch_pragueb_15_6_wounded_officer_loop;

	level.scr_animtree[ "neck_wound_civ" ] 					= #animtree;	
	level.scr_anim[ "neck_wound_civ" ][ "wounded_civ" ]		= %ch_pragueb_15_6_wounded_civ_03; //neck sitting
	level.scr_anim[ "neck_wound_civ" ][ "death" ]			= %civilian_leaning_death;
	level.scr_model["neck_wound_civ"] 						= "body_urban_civ_male_ba";	

	level.scr_animtree[ "crying_civ" ] 					= #animtree;		
	level.scr_anim[ "crying_civ" ][ "wounded_civ" ]		= %ch_pragueb_15_6_wounded_civ_04; //crying sitting
	level.scr_anim[ "crying_civ" ][ "death" ]			= %civilian_leaning_death_shot;
	level.scr_model["crying_civ"] 						= "body_slum_civ_female_ba";	

	level.scr_animtree[ "wounded_shoulder" ] 					= #animtree;		
	level.scr_anim[ "wounded_shoulder" ][ "wounded_civ" ]		= %ch_pragueb_15_6_wounded_civ_05; //Wounded shoulder 
	level.scr_model["wounded_shoulder"] 						= "body_complete_civilian_suit_male_1";	

	level.scr_animtree[ "headwound_civ" ] 					= #animtree;		
	level.scr_anim[ "headwound_civ" ][ "wounded_civ" ]		= %ch_pragueb_15_6_wounded_civ_06; //head wound
	level.scr_model["headwound_civ"] 						= "body_slum_civ_female_ba";
	
	level.scr_animtree[ "falling_civ" ] 		= #animtree;	
	level.scr_model["falling_civ"] 				= "body_slum_civ_female_ba";		
	level.scr_anim[ "falling_civ" ][ "death" ]	= %airport_civ_dying_groupA_kneel_death;
	
	level.scr_animtree[ "crawling_civ" ] 		= #animtree;	
	level.scr_model["crawling_civ"] 			= "body_urban_civ_male_bc";		
	level.scr_anim[ "crawling_civ" ][ "crawl" ]	= %civilian_crawl_2;
	level.scr_anim[ "crawling_civ" ][ "death" ]	= %civilian_crawl_2_death_A;
	
	//Lobby Bodies
	level.scr_animtree[ "male_red_stripes" ] 							= #animtree;	
	level.scr_model["male_red_stripes"] 								= "body_urban_civ_male_ba";	
	level.scr_anim[ "male_red_stripes" ][ "lobby_death_pose_12a" ][0]	= %ch_pragueb_civ_in_line_12_a_death_pose; //male red/white stripe / gray jeans

	level.scr_animtree[ "security" ] 							= #animtree;	
	level.scr_model["security"] 								= "body_secret_service_assault_a";	
	level.scr_anim[ "security" ][ "lobby_death_pose_13i" ][0] 	= %ch_pragueb_civ_in_line_13_i_death_pose; //male red/white stripe / khakis
	level.scr_anim[ "security" ][ "lobby_death_pose_9c" ][0] 	= %ch_pragueb_civ_in_line_9_c_death_pose; //female gray top/blue jeans

	level.scr_animtree[ "male_green_blue" ] = #animtree;	
	level.scr_model["male_green_blue"] = "body_urban_civ_male_bb";			
	level.scr_anim[ "male_green_blue" ][ "lobby_death_pose_12b" ][0] 			 = %ch_pragueb_civ_in_line_12_b_death_pose; //male green tee / blue jeans (escalator?)
	level.scr_anim[ "male_green_blue" ][ "lobby_death_pose_13h" ][0] 			 = %ch_pragueb_civ_in_line_13_h_death_pose; //male green tee
		
	level.scr_animtree[ "male_blue_khaki" ] = #animtree;	
	level.scr_model["male_blue_khaki"] = "body_urban_civ_male_aa";		
	level.scr_anim[ "male_blue_khaki" ][ "lobby_death_pose_12c" ][0] 			 = %ch_pragueb_civ_in_line_12_c_death_pose; //male blue tee / gray khakis (escalator?)
	level.scr_anim[ "male_blue_khaki" ][ "lobby_death_pose_13c" ][0] 			 = %ch_pragueb_civ_in_line_13_c_death_pose; //male blue tee / gray jeans
	level.scr_anim[ "male_blue_khaki" ][ "lobby_death_pose_15c" ][0] 			 = %ch_pragueb_civ_in_line_15_c_death_pose; //male blue tee / khakis (escalator?)
	level.scr_anim[ "male_blue_khaki" ][ "lobby_death_pose_13d" ][0] 			 = %ch_pragueb_civ_in_line_13_d_death_pose; //male blue tee / gray khakis
	level.scr_anim[ "male_blue_khaki" ][ "lobby_death_pose_10a" ][0] 			 = %ch_pragueb_civ_in_line_10_a_death_pose; //male green shirt/gray jeans (escalator?)

	level.scr_animtree[ "male_red_blue" ] = #animtree;	
	level.scr_model["male_red_blue"] = "body_urban_civ_male_bc";	
	level.scr_anim[ "male_red_blue" ][ "lobby_death_pose_15a" ][0] 			 = %ch_pragueb_civ_in_line_15_a_death_pose; //male red shirt / blue jeans
	level.scr_anim[ "male_red_blue" ][ "lobby_death_pose_10c" ][0] 			 = %ch_pragueb_civ_in_line_10_c_death_pose; //male red shirt/blue jeans
	level.scr_anim[ "male_red_blue" ][ "lobby_death_pose_13j" ][0] 			 = %ch_pragueb_civ_in_line_13_j_death_pose; //male red shirt /blue jeans
	
	level.scr_animtree[ "airport_male_suit" ] = #animtree;	
	level.scr_model["airport_male_suit"] = "body_complete_civilian_suit_male_1";	
	level.scr_anim[ "airport_male_suit" ][ "lobby_death_pose_6a" ][0] 			 = %ch_pragueb_civ_in_line_6_a_death_pose; //male suit
	level.scr_anim[ "airport_male_suit" ][ "lobby_death_pose_6b" ][0] 			 = %ch_pragueb_civ_in_line_6_b_death_pose; //male suit
	level.scr_anim[ "airport_male_suit" ][ "lobby_death_pose_9a" ][0] 			 = %ch_pragueb_civ_in_line_9_a_death_pose; //male suit (escalator?) 
	level.scr_anim[ "airport_male_suit" ][ "lobby_death_pose_13e" ][0] 			 = %ch_pragueb_civ_in_line_13_e_death_pose; //male suit
	level.scr_anim[ "airport_male_suit" ][ "lobby_death_pose_13g" ][0] 			 = %ch_pragueb_civ_in_line_13_g_death_pose; //male green tee / grey jeans
		
	//Escalator Bodies
	level.scr_animtree[ "escalator_male_suit" ] = #animtree;	
	level.scr_model["escalator_male_suit"] = "body_complete_civilian_suit_male_1";		
//	level.scr_anim[ "escalator_male_suit" ][ "lobby_death_pose_12a" ][0] 			 = %ch_pragueb_civ_escalator_12_a_death_pose; //male suit
	level.scr_anim[ "escalator_male_suit" ][ "lobby_death_pose_12b" ][0] 			 = %ch_pragueb_civ_escalator_12_b_death_pose; //male suit
	level.scr_anim[ "escalator_male_suit" ][ "lobby_death_pose_12c" ][0] 			 = %ch_pragueb_civ_escalator_12_c_death_pose; //male suit
	level.scr_anim[ "escalator_male_suit" ][ "lobby_death_pose_12h" ][0] 			 = %ch_pragueb_civ_escalator_12_h_death_pose; //male suit
//	level.scr_anim[ "escalator_male_suit" ][ "lobby_death_pose_12k" ][0] 			 = %ch_pragueb_civ_escalator_12_k_death_pose; //male suit

	level.scr_animtree[ "escalator_female_green" ] = #animtree;	
	level.scr_model["escalator_female_green"] = "body_slum_civ_female_ba";			
	level.scr_anim[ "escalator_female_green" ][ "lobby_death_pose_12d" ][0] 			 = %ch_pragueb_civ_escalator_12_d_death_pose; //green top black pants
	
	level.scr_animtree[ "escalator_male_red" ] = #animtree;	
	level.scr_model["escalator_male_red"] = "body_urban_civ_male_bc";				
//	level.scr_anim[ "escalator_male_red" ][ "lobby_death_pose_12l" ][0] 			 = %ch_pragueb_civ_escalator_12_l_death_pose; //male red shirt jeans
	level.scr_anim[ "escalator_male_red" ][ "lobby_death_pose_12f" ][0] 			 = %ch_pragueb_civ_escalator_12_f_death_pose; //male red shirt
	level.scr_anim[ "escalator_male_red" ][ "lobby_death_pose_12g" ][0] 			 = %ch_pragueb_civ_escalator_12_g_death_pose; //male red shirt
	
	level.scr_animtree[ "escalator_male_blue" ] = #animtree;	
	level.scr_model["escalator_male_blue"] = "body_urban_civ_male_aa";				
//	level.scr_anim[ "escalator_male_blue" ][ "lobby_death_pose_12i" ][0] 			 = %ch_pragueb_civ_escalator_12_i_death_pose; //male blue shirt and jeans
//	level.scr_anim[ "escalator_male_blue" ][ "lobby_death_pose_12j" ][0] 			 = %ch_pragueb_civ_escalator_12_j_death_pose; //male blue shirt khakis
	level.scr_anim[ "escalator_male_blue" ][ "lobby_death_pose_12e" ][0] 			 = %ch_pragueb_civ_escalator_12_e_death_pose; //male blue shirt khakis

	//FEMALE GRAY TOP and BLUE JEANS
	level.scr_animtree[ "female_gray_blue" ] = #animtree;	
	level.scr_model["female_gray_blue"] = "body_slum_civ_female_ba";		
	level.scr_anim[ "female_gray_blue" ][ "lobby_death_pose_10b" ][0] 			 = %ch_pragueb_civ_in_line_10_b_death_pose; //female gray top/blue jeans	
	level.scr_anim[ "female_gray_blue" ][ "lobby_death_pose_9b" ][0] 			 	 = %ch_pragueb_civ_in_line_9_b_death_pose; //female gray top/blue jeans
	level.scr_anim[ "female_gray_blue" ][ "lobby_death_pose_13a" ][0] 			 = %ch_pragueb_civ_in_line_13_a_death_pose; //female gray top/blue jeans "belly"
	level.scr_anim[ "female_gray_blue" ][ "lobby_death_pose_13f" ][0] 			 = %ch_pragueb_civ_in_line_13_f_death_pose; //female gray or brown top/blue jeans "belly"
	level.scr_anim[ "female_gray_blue" ][ "lobby_death_pose_13k" ][0] 			 = %ch_pragueb_civ_in_line_13_k_death_pose; //male green tee / blue jeans 

	//to help with price's model stream for next scene
	level.scr_animtree[ "price_stream_model" ] = #animtree;		
	level.scr_model["price_stream_model"] = "body_tf141_assault_a";			
	level.scr_anim[ "price_stream_model" ][ "lobby_death_pose_12e" ][0] 			 = %ch_pragueb_civ_escalator_12_e_death_pose; 

	level.scr_animtree[ "emt" ] = #animtree;	
	level.scr_model["emt"] = "body_secret_service_assault_a";				
	level.scr_anim[ "emt" ][ "emt_assist" ]			 				 	 		 = %ch_pragueb_16_1_emt_assist_guy_01;
//	addNotetrack_customFunction( "emt", "slow_mo", maps\prague_escape_flashback_airport::slow_down_emt_anim, "emt_assist" );
	
	level.scr_anim[ "price" ][ "gun_to_head" ] 								 = %ch_pragueb_16_1_gun_to_head_price;	
	addNotetrack_sound( "price", "sfx", "gun_to_head", "scn_prague_price_last_lines_foley" );
	
	// Generic  ////////////////////////////////////////////////////////////////////////////////////////
	// Patrol
	level.scr_animtree[ "generic" ]							 	 	 = #animtree;
	level.scr_anim[ "generic" ][ "patrol_walk" ]					 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]				 = %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]					 = %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]					 = %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]					 = %patrol_bored_2_walk_180turn;
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]					 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]					 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]					 = %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]					 = %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]					 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]					 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]				 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]			 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]			 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]				 = %patrol_bored_idle_cellphone;	
}

#using_animtree( "player" );
player_anims()
{
	//Rig setup
	level.scr_animtree[ "player_rig" ] 	= #animtree;
	level.scr_model[ "player_rig" ] 	= level.player_viewhand_model;	

	//Flashback Sniper Rig setup
	level.scr_animtree[ "player_rig_oneshot" ] 	= #animtree;
	level.scr_model[ "player_rig_oneshot" ] 	= "viewhands_player_russian_c";	

	//Flashback Nuke Rig setup
	level.scr_animtree[ "player_rig_nuke" ] = #animtree;
	level.scr_model[ "player_rig_nuke" ] 	= "viewhands_player_russian_b";	

	//Flashback Airport Rig setup
	level.scr_animtree[ "player_rig_airport" ] 	= #animtree;
	level.scr_model[ "player_rig_airport" ] 	= "viewhands_player_yuri_airport";
	
	level.scr_animtree[ "player_rig_airport_alt" ] 	= #animtree;
	level.scr_model[ "player_rig_airport_alt" ] 	= "viewhands_player_yuri_airport";//"viewhands_player_airport";
	
	// section 1  ////////////////////////////////////////////////////////////////////////////////////////
	level.scr_anim[ "player_rig" ][ "belltower_intro_idle" ][0]	= %p_pragueb_1_1_idle_player;
	addNotetrack_customFunction( "player_rig", "rumble_01", maps\prague_escape_code::play_light_rumble, "belltower_intro" );
	level.scr_anim[ "player_rig" ][ "belltower_intro" ]	= %p_pragueb_1_1_setup_player; // = %p_pragueb_1_1_intro_player;
	
	level.scr_anim[ "player_rifle" ][ "belltower_intro" ]	= %p_pragueb_1_1_setup_player_gun; // = %p_pragueb_1_1_intro_player;
	level.scr_animtree[ "player_rifle" ] 	= #animtree;
	level.scr_model[ "player_rifle" ] 	= "viewmodel_rsass_sp_iw5";	
	
	addNotetrack_customFunction( "player_rig", "dof_change_01", maps\prague_escape_code::notify_dof_change, "belltower_intro" );
	addNotetrack_customFunction( "player_rig", "dof_change_02", maps\prague_escape_code::notify_dof_change, "belltower_intro" );
	addNotetrack_customFunction( "player_rig", "dof_change_03", maps\prague_escape_code::notify_dof_change, "belltower_intro" );
	addNotetrack_customFunction( "player_rig", "dof_change_04", maps\prague_escape_code::notify_dof_change, "belltower_intro" );
	
	
		
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "belltower_intro" );
	addNotetrack_customFunction( "player_rig", "rumble_03", maps\prague_escape_code::play_light_rumble, "belltower_intro" );
	addNotetrack_customFunction( "player_rig", "rumble_04", maps\prague_escape_code::play_light_rumble, "belltower_intro" );
	addNotetrack_flag( "player_rig", "fade_out", "belltower_intro_fade_out", "belltower_intro" );
	level.scr_anim[ "player_rig" ][ "belltower_intro_setup" ]	= %p_pragueb_1_1_setup_player;
	
	level.scr_anim[ "player_rig" ][ "scaffolding_fall" ]	= %p_pragueb_2_2_scaffolding_fall_player;
	addNotetrack_customFunction( "player_rig", "hide_tower", maps\prague_escape_scaffold::swap_tower_model, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "explosion_1", maps\prague_escape_scaffold::scaffold_fall_timescale_start, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "explosion_1", maps\prague_escape_scaffold::tower_explosion_anim, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "player_hit_by_soap", maps\prague_escape_scaffold::scaffold_fall_timescale_stop, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "start_scaffolding_anim", maps\prague_escape_scaffold::scaffolding_anim, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "player_hit_by_soap", maps\prague_escape_code::play_heavy_rumble_and_earthquake, "scaffolding_fall" );	
	addNotetrack_customFunction( "player_rig", "player_hit_by_soap", maps\prague_escape_scaffold::coutyard_amb_zone, "scaffolding_fall" );	
		
	addNotetrack_customFunction( "player_rig", "rumble", maps\prague_escape_code::play_heavy_rumble_and_earthquake, "scaffolding_fall" );	
	addNotetrack_customFunction( "player_rig", "player_hit_board_1", maps\prague_escape_code::play_extreme_rumble_and_earthquake, "scaffolding_fall" );	
	addNotetrack_customFunction( "player_rig", "player_hit_board_2", maps\prague_escape_scaffold::scaffold_player_hit_board_2, "scaffolding_fall" );
	addNotetrack_customFunction( "player_rig", "player_hit_board_3", maps\prague_escape_code::play_extreme_rumble_and_earthquake, "scaffolding_fall" );	
	addNotetrack_customFunction( "player_rig", "player_hit_floor", maps\prague_escape_scaffold::scaffold_player_hit_ground, "scaffolding_fall" );
	
	level.scr_anim[ "player_rig" ][ "fade_in_a" ]	= %p_pragueb_2_3_fade_in_a_player;
	level.scr_anim[ "player_rig" ][ "fade_in_b" ]	= %p_pragueb_2_3_fade_in_b_player;
	level.scr_anim[ "player_rig" ][ "scaffold_soap_injured" ]	= %p_pragueb_2_3_soap_injured_player;	
	
	level.scr_anim[ "player_rig" ][ "soap_carry_pickup" ]	= %p_pragueb_3_1_pickup_player;
	level.scr_anim[ "player_rig" ][ "soap_carry_idle" ][0]	= %p_pragueb_3_1_idle_player;
	level.scr_anim[ "player_rig" ][ "soap_carry_run" ][0]	= %p_pragueb_3_1_run_player;
	level.scr_anim[ "player_rig" ][ "soap_carry_cough_stop" ]	= %p_pragueb_3_1_cough_stop_player;
	addNotetrack_customFunction( "player_rig", "start_price", maps\prague_escape_soap_carry::smoke_grenade_toss, "soap_carry_cough_stop" );
	
	level.scr_anim[ "player_rig" ][ "soap_carry_cough" ]	= %p_pragueb_3_2_cough_player;
	
	level.scr_anim[ "player_rig" ][ "toss_gun" ]	= %p_pragueb_3_5_toss_m203_player;
	
	// section 2  ////////////////////////////////////////////////////////////////////////////////////////
	
	// section 3  ////////////////////////////////////////////////////////////////////////////////////////

	//SOAP DEATH
	level.scr_anim[ "player_rig" ][ "no_pressure" ][0]				= %p_pragueb_10_1_savingsoap_nopressure_player;
	level.scr_anim[ "player_rig" ][ "no_pressure_single" ]		= %p_pragueb_10_1_savingsoap_nopressure_player;
	
	//level.scr_anim[ "player_rig" ][ "slow_death" ]						= %p_pragueb_10_1_savingsoap_slowdeath_player;
	level.scr_anim[ "player_rig" ][ "soap_death" ]						= %prague_escape_soap_death_player;
	
	//ESCAPE TO CELLAR
	level.scr_anim[ "player_rig" ][ "escape" ]					= %p_pragueb_11_1_escape_player;
	addNotetrack_customFunction( "player_rig", "slowmo_intro", maps\prague_escape_medic::slowmo_pistol_moment, "escape" );	
	addNotetrack_flag( "player_rig", "slowmo_gun", "stop_pistol_slowmo", "escape" );
	
	level.scr_anim[ "player_rig" ][ "price_punch" ]			= %p_pragueb_12_1_punch_player;

	addNotetrack_customFunction( "player_rig", "punch_rumble", maps\prague_escape_to_cellar::punch_blink_blur, "price_punch" );	
	addNotetrack_customFunction( "player_rig", "flip_rumble", maps\prague_escape_code::play_heavy_rumble, "price_punch" );	

	addNotetrack_customFunction( "player_rig", "stairs_rumble_start", maps\prague_escape_to_cellar::stair_fall_rumble, "price_punch" );	
	addNotetrack_flag( "player_rig", "stairs_rumble_stop", "stop_stair_rumble", "price_punch" );

	addNotetrack_customFunction( "player_rig", "floor_hit", maps\prague_escape_code::play_heavy_rumble, "price_punch" );	
	addNotetrack_flag( "player_rig", "floor_hit", "give_punch_headlook", "price_punch" );

	//ONE SHOT ONE KILL FLASHBACK
	level.scr_anim[ "player_rig" ][ "no_time" ]			= %p_pragueb_13_1_no_time_player;

	level.scr_anim[ "player_rig" ][ "bullet_strikes" ]			= %p_pragueb_13_3_bullet_strikes_player;
	addNotetrack_customFunction( "player_rig", "headlook", maps\prague_escape_flashback_sniper::bullet_strikes_headlook, "bullet_strikes" );	
	addNotetrack_customFunction( "player_rig", "glass_shatter", maps\prague_escape_flashback_sniper::uaz_backwindow_smash, "bullet_strikes" );	
	addNotetrack_customFunction( "player_rig", "rumble_lt", maps\prague_escape_code::play_light_rumble, "bullet_strikes" );	
	addNotetrack_customFunction( "player_rig", "rumble_hv", maps\prague_escape_code::play_heavy_rumble, "bullet_strikes" );	
	addNotetrack_customFunction( "player_rig", "hit_1", maps\prague_escape_flashback_sniper::hit_1_rumble_fx, "bullet_strikes" );	
	addNotetrack_customFunction( "player_rig", "hit_2", maps\prague_escape_flashback_sniper::hit_2_rumble_fx, "bullet_strikes" );	
	
	addNotetrack_customFunction( "player_rig", "start_rumble", maps\prague_escape_code::play_uaz_rumble, "bullet_strikes" );	
//	addNotetrack_customFunction( "player_rig", "stop_rumble", maps\prague_escape_code::stop_uaz_rumble, "bullet_strikes" );	
	addNotetrack_flag( "player_rig", "hit_2", "stop_uaz_rumble", "bullet_strikes" );

	addNotetrack_flag( "player_rig", "start_zakhaev", "spawn_onearm_zakhaev", "bullet_strikes" );
	
	addNotetrack_flag( "player_rig", "poor_bastards", "spawn_escape_victims", "bullet_strikes" );
	//addNotetrack_flag( "player_rig", "hit_2", "start_nuke_transition", "bullet_strikes" );	
	
	//SHOCK AND AWE
	level.scr_anim[ "player_rig" ][ "shock_and_awe" ]			= %p_pragueb_14_1_shockandawe_player_relative;	
	addNotetrack_flag( "player_rig", "helicopter_1", "spawn_helicopter_1", "shock_and_awe" );
	addNotetrack_flag( "player_rig", "explosion", "nuke_explosion_start", "shock_and_awe" );

	//BETRAY ME SCENE
	level.scr_anim[ "player_rig" ][ "betray_me" ]				= %p_pragueb_15_1_betray_me_player;
	addNotetrack_customFunction( "player_rig", "rumble_01", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_03", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_04", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_05", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_06", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_07", maps\prague_escape_code::play_light_rumble, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_08", maps\prague_escape_code::play_light_rumble, "betray_me" );
	
	addNotetrack_customFunction( "player_rig", "rumble_06", maps\prague_escape_flashback_airport::betray_me_struggle_exert, "betray_me" );
	addNotetrack_customFunction( "player_rig", "rumble_07", maps\prague_escape_flashback_airport::betray_me_struggle_exert, "betray_me" );
	//addNotetrack_customFunction( "player_rig", "rumble_08", maps\prague_escape_flashback_airport::betray_me_struggle_pain, "betray_me" );
	
	addNotetrack_flag( "player_rig", "hit_ground", "start_gunshot_blackout", "betray_me" );
	
	//AIRPORT
	level.scr_anim[ "player_rig" ][ "elevator_hand" ]		= %p_pragueb_15_4_elevator_crawl_in_hand_player;
	level.scr_anim[ "player_rig" ][ "elevator_idle" ][0]	= %p_pragueb_15_4_elevator_crawl_in_idle_player;
	level.scr_anim[ "player_rig" ][ "elevator_crawl_in" ]	= %p_pragueb_15_4_elevator_crawl_in_player;
	level.scr_anim[ "player_rig" ][ "elevator_crawl_out" ]	= %p_pragueb_15_4_elevator_crawl_out_player;
	
	level.scr_anim[ "player_rig" ][ "gun_crawl_00" ] 			= %player_afchase_ending_gun_crawl_00;
	level.scr_anim[ "player_rig" ][ "gun_crawl_01" ] 			= %player_afchase_ending_gun_crawl_01;
	level.scr_anim[ "player_rig" ][ "gun_crawl_02" ] 			= %player_afchase_ending_gun_crawl_02;
	level.scr_anim[ "player_rig" ][ "gun_crawl_03" ] 			= %player_afchase_ending_gun_crawl_03;
	level.scr_anim[ "player_rig" ][ "gun_crawl_04" ] 			= %player_afchase_ending_gun_crawl_04;
	level.scr_anim[ "player_rig" ][ "gun_crawl_05" ] 			= %player_afchase_ending_gun_crawl_05;
	level.scr_anim[ "player_rig" ][ "gun_crawl_06" ] 			= %player_afchase_ending_gun_crawl_06;
	level.scr_anim[ "player_rig" ][ "gun_crawl_00_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_00;
	level.scr_anim[ "player_rig" ][ "gun_crawl_01_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_01;
	level.scr_anim[ "player_rig" ][ "gun_crawl_02_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_02;
	level.scr_anim[ "player_rig" ][ "gun_crawl_03_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_03;
	level.scr_anim[ "player_rig" ][ "gun_crawl_04_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_04;
	level.scr_anim[ "player_rig" ][ "gun_crawl_05_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_05;
	level.scr_anim[ "player_rig" ][ "gun_crawl_06_idle" ][ 0 ] 	= %player_afchase_ending_gun_crawl_idle_06;
	
	level.scr_anim[ "player_rig" ][ "wakeup" ] 				 	= %player_afchase_ending_wakeup_no_node;
	
	addNotetrack_flag( "player_rig", "hit_button", "player_hits_button", "elevator_crawl_in" );
	addNotetrack_flag( "player_rig", "player_fallback", "close_elevator_doors", "elevator_crawl_in" );
	
	addNotetrack_customFunction( "player_rig", "button_slam_rumble", maps\prague_escape_code::play_heavy_rumble, "elevator_crawl_in" );
	addNotetrack_customFunction( "player_rig", "button_slam_rumble", maps\prague_escape_code::elevator_rumble_blood, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "right_hand_blood", maps\prague_escape_code::elevator_rumble_blood, "elevator_crawl_in" );
	addNotetrack_customFunction( "player_rig", "left_hand_blood", maps\prague_escape_code::elevator_rumble_blood, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "button_rumble", maps\prague_escape_code::play_heavy_rumble, "elevator_crawl_in" );
	addNotetrack_customFunction( "player_rig", "railing_grab", maps\prague_escape_code::play_heavy_rumble, "elevator_crawl_in" );
	addNotetrack_customFunction( "player_rig", "door_lean", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "player_fallout", maps\prague_escape_code::elevator_rumble_blood, "elevator_crawl_out" );	
	addNotetrack_customFunction( "player_rig", "pistol_grab", maps\prague_escape_code::play_light_rumble, "elevator_crawl_out" );	
	addNotetrack_customFunction( "player_rig", "crawl_rumble_1", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "crawl_rumble_2", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "crawl_rumble_3", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "wall_grab_rumble_1", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "wall_grab_rumble_2", maps\prague_escape_code::play_light_rumble, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "blink", maps\prague_escape_flashback_airport::crawl_in_player_blink, "elevator_crawl_in" );	
	addNotetrack_customFunction( "player_rig", "player_fallout", maps\prague_escape_flashback_airport::player_blink, "elevator_crawl_out" );	

	//PLAYER BLACKOUTS
	level.scr_anim[ "player_rig" ][ "player_force_blackout" ]									= %p_pragueb_15_6_dying_inplace_player;	
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "player_force_blackout" );	
	addNotetrack_customFunction( "player_rig", "rumble_03", maps\prague_escape_code::play_light_rumble, "player_force_blackout" );	
	
	
	
	level.scr_anim[ "player_rig" ][ "left_detector_passout" ]						= %p_pragueb_15_6_dying_detector_l_player;	
	addNotetrack_customFunction( "player_rig", "blood_smear_left", maps\prague_escape_code::left_hand_blood_on_rig, "left_detector_passout" );
	addNotetrack_flag( "player_rig", "blood_smear_left", "play_left_hand_blood", "left_detector_passout" );	
	addNotetrack_flag_clear( "player_rig", "blood_smear_left_stop", "play_left_hand_blood", "left_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_01", maps\prague_escape_code::play_light_rumble, "left_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "left_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_03", maps\prague_escape_code::play_light_rumble, "left_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_04", maps\prague_escape_code::play_light_rumble, "left_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_05", maps\prague_escape_code::play_extreme_rumble, "left_detector_passout" );	

	level.scr_anim[ "player_rig" ][ "right_detector_passout" ]					= %p_pragueb_15_6_dying_detector_r_player;	
	addNotetrack_customFunction( "player_rig", "drop_gun", maps\prague_escape_code::play_light_rumble, "right_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "blood_smear_right", maps\prague_escape_code::right_hand_blood_on_rig, "right_detector_passout" );
	addNotetrack_flag_clear( "player_rig", "blood_smear_right_stop", "play_right_hand_blood", "right_detector_passout" );
	addNotetrack_customFunction( "player_rig", "rumble_01", maps\prague_escape_code::play_light_rumble, "right_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "right_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_03", maps\prague_escape_code::play_light_rumble, "right_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_04", maps\prague_escape_code::play_light_rumble, "right_detector_passout" );	
	addNotetrack_customFunction( "player_rig", "rumble_05", maps\prague_escape_code::play_extreme_rumble, "right_detector_passout" );

	//EMT
	level.scr_anim[ "player_rig" ][ "emt_assist" ]								= %p_pragueb_16_1_emt_assist_player;	
	
	//OUTRO
	level.scr_anim[ "player_rig" ][ "gun_to_head" ]								= %p_pragueb_16_1_gun_to_head_player;		
	addNotetrack_customFunction( "player_rig", "rumble_01", maps\prague_escape_code::play_light_rumble, "gun_to_head" );	
	addNotetrack_customFunction( "player_rig", "rumble_02", maps\prague_escape_code::play_light_rumble, "gun_to_head" );	
	addNotetrack_customFunction( "player_rig", "wall_rumble", maps\prague_escape_code::play_heavy_rumble, "gun_to_head" );	
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	// section 1  ////////////////////////////////////////////////////////////////////////////////////////
	level.scr_animtree[ "convoy_vehicle" ] 		= #animtree;
	
	level.scr_anim[ "soap_carry_suv" ][ "suv_flip" ] 	=%v_pragueb_3_1_suburban_flip_suburban;
	
	// section 2  ////////////////////////////////////////////////////////////////////////////////////////
	
	// section 3  ////////////////////////////////////////////////////////////////////////////////////////
	level.scr_animtree[ "player_uaz" ] = #animtree;	
	level.scr_model["player_uaz"] = "vehicle_uaz_covered_destructible";	
	level.scr_anim[ "player_uaz" ][ "no_time" ]	= %v_pragueb_13_1_no_time_uaz;
	level.scr_anim[ "player_uaz" ][ "bullet_strikes" ]	= %v_pragueb_13_3_bullet_strikes_uaz;
}

#using_animtree( "script_model" );
script_model_anims()
{
	level.scr_animtree[ "script_model" ]	= #animtree;
	// section 1  ////////////////////////////////////////////////////////////////////////////////////////
	level.scr_anim[ "hotel_door_1" ][ "close_door" ]	= %o_pragueb_1_2_door_guards_close_door_01;
	level.scr_anim[ "hotel_door_2" ][ "close_door" ]	= %o_pragueb_1_2_door_guards_close_door_02;
	level.scr_anim[ "hotel_door_1" ][ "enter_door" ]	= %o_pragueb_1_2_door_guards_enter_door_01;
	level.scr_anim[ "hotel_door_2" ][ "enter_door" ]	= %o_pragueb_1_2_door_guards_enter_door_02;
	
	level.scr_anim[ "rpg_wall" ][ "rpg_wall_explode" ]	= %fxanim_prague2_rpg_wall_anim;
	level.scr_anim[ "exit_wall" ][ "exit_wall_explode" ]	= %fxanim_prague2_exit_wall_anim;
	level.scr_anim[ "curtain" ][ "window_breach_curtain_fall" ]	= %fxanim_prague2_curtain_fall_anim;
//	level.scr_anim[ "curtain" ][ "window_breach_curtain_break" ]	= %fxanim_prague2_curtain_break_anim;
	level.scr_anim[ "curtain" ][ "curtain_idle" ][0]	= %fxanim_prague2_curtain_win_long_anim;
	
	level.scr_anim[ "hotel_columns" ][ "hotel_explode" ]	= %fxanim_prague2_hotel_anim;
		
	level.scr_anim[ "bell_tower" ][ "bell_tower_explode" ]	= %fxanim_prague2_bell_tower_anim;
	level.scr_anim[ "scaffold" ][ "scaffold_break" ]	= %fxanim_prague2_bell_tower_scaf_anim;
	addNotetrack_customFunction( "scaffold", "bell_impact_ground", maps\prague_escape_scaffold::scaffold_bell_impact, "scaffold_break" );
	
	level.scr_animtree[ "debris01" ]	= #animtree;
	level.scr_model[ "debris01" ] = "tag_origin_animate";
	level.scr_anim[ "debris01" ][ "scaffolding_fall" ] = %o_pragueb_2_2_scaffolding_fall_debris1;
	level.scr_anim[ "debris01" ][ "scaffold_soap_injured" ] = %o_pragueb_2_3_soap_injured_debris01;
	addNotetrack_customFunction( "debris01", "debris_lift", maps\prague_escape_scaffold::debris_lift, "scaffold_soap_injured" );
	addNotetrack_customFunction( "debris01", "debris_fall", maps\prague_escape_scaffold::debris_fall, "scaffold_soap_injured" );
	
	level.scr_animtree[ "debris02" ]	= #animtree;
	level.scr_model[ "debris02" ] = "tag_origin_animate";
	level.scr_anim[ "debris02" ][ "scaffolding_fall" ] = %o_pragueb_2_2_scaffolding_fall_debris2;
	level.scr_anim[ "debris02" ][ "scaffold_soap_injured" ] = %o_pragueb_2_3_soap_injured_debris02;
	
	level.scr_animtree[ "debris03" ]	= #animtree;
	level.scr_model[ "debris03" ] = "tag_origin_animate";
	level.scr_anim[ "debris03" ][ "scaffolding_fall" ] = %o_pragueb_2_2_scaffolding_fall_debris3;
	level.scr_anim[ "debris03" ][ "scaffold_soap_injured" ] = %o_pragueb_2_3_soap_injured_debris03;
	
	level.scr_animtree[ "debris04" ]	= #animtree;
	level.scr_model[ "debris04" ] = "tag_origin_animate";
	level.scr_anim[ "debris04" ][ "scaffolding_fall" ] = %o_pragueb_2_2_scaffolding_fall_debris4;
	level.scr_anim[ "debris04" ][ "scaffold_soap_injured" ] = %o_pragueb_2_3_soap_injured_debris04;
	
	level.scr_animtree[ "debris05" ]	= #animtree;
	level.scr_model[ "debris05" ] = "tag_origin_animate";
	level.scr_anim[ "debris05" ][ "scaffolding_fall" ] = %o_pragueb_2_2_scaffolding_fall_debris5;
	level.scr_anim[ "debris05" ][ "scaffold_soap_injured" ] = %o_pragueb_2_3_soap_injured_debris05;	
		
	// section 2  ////////////////////////////////////////////////////////////////////////////////////////
	level.scr_animtree[ "lamp" ] = #animtree;
	level.scr_model["lamp"] = "tag_origin_animate";
	level.scr_anim[ "lamp" ][ "take_cover" ] = %o_pragueb_6_1_throughbuilding_lamp;
	level.scr_anim[ "lamp" ][ "idle_cover" ][0] = %o_pragueb_6_1_throughbuilding_lamp_loop;
	
	level.scr_animtree[ "table" ] = #animtree;
	level.scr_model["table"] = "tag_origin_animate";
	level.scr_anim[ "table" ][ "take_cover" ] = %o_pragueb_6_1_throughbuilding_table;
	level.scr_anim[ "table" ][ "idle_cover" ][0] = %o_pragueb_6_1_throughbuilding_table_loop;
	
	level.scr_animtree[ "box1" ] = #animtree;
	level.scr_model["box1"] = "tag_origin_animate";
	level.scr_anim[ "box1" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box01;
	level.scr_anim[ "box1" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box01;
	
	level.scr_animtree[ "box2" ] = #animtree;
	level.scr_model["box2"] = "tag_origin_animate";
	level.scr_anim[ "box2" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box02;
	level.scr_anim[ "box2" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box02;
	
	level.scr_animtree[ "box3" ] = #animtree;
	level.scr_model["box3"] = "tag_origin_animate";
	level.scr_anim[ "box3" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box03;
	level.scr_anim[ "box3" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box03;
		
	level.scr_animtree[ "box4" ] = #animtree;
	level.scr_model["box4"] = "tag_origin_animate";
	level.scr_anim[ "box4" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box04;
	level.scr_anim[ "box4" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box04;
		
	level.scr_animtree[ "box5" ] = #animtree;
	level.scr_model["box5"] = "tag_origin_animate";
	level.scr_anim[ "box5" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box05;
	level.scr_anim[ "box5" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box05;
	
	level.scr_animtree[ "box6" ] = #animtree;
	level.scr_model["box6"] = "tag_origin_animate";
	level.scr_anim[ "box6" ][ "reachroom" ] = %o_pragueb_4_3_reachroom_box06;
	level.scr_anim[ "box6" ][ "idle_room" ][0] = %o_pragueb_4_3_reachroom_idle_box06;
	
	level.scr_animtree[ "resistance_door" ] = #animtree;
	level.scr_model["resistance_door"] = "tag_origin_animate";
	level.scr_anim[ "resistance_door" ][ "resistancearrive2" ] = %o_pragueb_9_1_resistancecarry_door;
	level.scr_anim[ "resistance_door" ][ "resistancecarry_idle" ][0] = %o_pragueb_9_1_resistancecarry_door_loop;
	
	level.scr_animtree[ "resistance_gate" ] = #animtree;
	level.scr_model["resistance_gate"] = "tag_origin_animate";
	level.scr_anim[ "resistance_gate" ][ "resistancearrive2" ] = %o_pragueb_9_1_resistancecarry_gate;
	level.scr_anim[ "resistance_gate" ][ "resistancecarry_idle" ][0] = %o_pragueb_9_1_resistancecarry_gate_loop;
	
	level.scr_animtree[ "script_model" ]	= #animtree;
	level.scr_anim[ "btr_fence" ][ "btr_entrance" ]	= %fxanim_prague2_basketball_court_anim;
	
	level.scr_animtree[ "script_model" ]	= #animtree;
	level.scr_anim[ "lion" ][ "lion_statue_destroy" ]	= %fxanim_prague2_lion_statue_anim;
	
	level.scr_animtree[ "beer1" ] = #animtree;
	level.scr_model["beer1"] = "tag_origin_animate";
	level.scr_anim[ "beer1" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_beer1;
	
	level.scr_animtree[ "beer2" ] = #animtree;
	level.scr_model["beer2"] = "tag_origin_animate";
	level.scr_anim[ "beer2" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_beer2;
	
	level.scr_animtree[ "beer3" ] = #animtree;
	level.scr_model["beer3"] = "tag_origin_animate";
	level.scr_anim[ "beer3" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_beer3;
	
	level.scr_animtree[ "beer4" ] = #animtree;
	level.scr_model["beer4"] = "tag_origin_animate";
	level.scr_anim[ "beer4" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_beer4;
	
	level.scr_animtree[ "cup1" ] = #animtree;
	level.scr_model["cup1"] = "tag_origin_animate";
	level.scr_anim[ "cup1" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_cup1;
	
	level.scr_animtree[ "cup2" ] = #animtree;
	level.scr_model["cup2"] = "tag_origin_animate";
	level.scr_anim[ "cup2" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_cup2;
	
	level.scr_animtree[ "cup3" ] = #animtree;
	level.scr_model["cup3"] = "tag_origin_animate";
	level.scr_anim[ "cup3" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_cup3;
	
	level.scr_animtree[ "wine" ] = #animtree;
	level.scr_model["wine"] = "tag_origin_animate";
	level.scr_anim[ "wine" ][ "clear_table" ] = %o_pragueb_10_1_clear_table_wine;

	
	// section 3  ////////////////////////////////////////////////////////////////////////////////////////
	
	//SOAP DEATH
//	level.scr_animtree[ "price_pistol" ] 					= #animtree;
//	level.scr_model["price_pistol"] 							= "tag_origin_animate";
//	level.scr_anim[ "price_pistol" ][ "escape" ] 	= %o_pragueb_11_1_escape_gun;
	
	level.scr_animtree[ "price_journal" ] 					= #animtree;
	level.scr_model["price_journal"] 							= "tag_origin_animate";
	level.scr_anim[ "price_journal" ][ "escape" ] 	= %o_pragueb_11_1_escape_journal;
	
	
	
	level.scr_animtree[ "soap_table" ] 							= #animtree;
	level.scr_model["soap_table"] 									= "tag_origin_animate";
	level.scr_anim[ "soap_table" ][ "escape" ][0] 	= %o_pragueb_11_1_escape_table;	
	
	level.scr_animtree[ "punch_door" ] 							= #animtree;
	level.scr_model["punch_door"] 									= "tag_origin_animate";
	level.scr_anim[ "punch_door" ][ "price_punch" ] = %o_pragueb_12_1_punch_door;
	
	level.scr_anim[ "blind_01" ][ "cellar_blinds" ] = %fxanim_prague2_blind01_anim;
	addNotetrack_customFunction("blind_01", "blind1_chunks", ::play_blind_chunk_exploder, "cellar_blinds");
	
	level.scr_anim[ "blind_02" ][ "cellar_blinds" ] = %fxanim_prague2_blind02_anim;
	addNotetrack_customFunction("blind_02", "blind2_chunks", ::play_blind_chunk_exploder, "cellar_blinds");	
	
	level.scr_anim[ "blind_03" ][ "cellar_blinds" ] = %fxanim_prague2_blind03_anim;
	addNotetrack_customFunction("blind_03", "blind3_chunks", ::play_blind_chunk_exploder, "cellar_blinds");
	
	level.scr_anim[ "blind_01" ][ "cellar_blinds_idle" ][0] = %fxanim_prague2_blind01_idle_anim;
	addNotetrack_customFunction("blind_01", "blind1_chunks", ::play_blind_chunk_exploder, "cellar_blinds_idle");
	addNotetrack_customFunction("blind_01", "blind1_impact", ::play_blind_impact_exploder, "cellar_blinds_idle");
	
	level.scr_anim[ "blind_02" ][ "cellar_blinds_idle" ][0] = %fxanim_prague2_blind02_idle_anim;
	addNotetrack_customFunction("blind_02", "blind2_chunks", ::play_blind_chunk_exploder, "cellar_blinds_idle");
	addNotetrack_customFunction("blind_02", "blind2_impact", ::play_blind_impact_exploder, "cellar_blinds_idle");
	
	level.scr_anim[ "blind_03" ][ "cellar_blinds_idle" ][0] = %fxanim_prague2_blind03_idle_anim;
	addNotetrack_customFunction("blind_03", "blind3_chunks", ::play_blind_chunk_exploder, "cellar_blinds_idle");
	addNotetrack_customFunction("blind_03", "blind3_impact", ::play_blind_impact_exploder, "cellar_blinds_idle");
	
	//FLASHBACK SNIPER
	level.scr_animtree[ "zak_left_arm" ] 							 = #animtree;
	level.scr_model[ "zak_left_arm" ] 							 	 = "zakhaev_left_arm";
	level.scr_anim[ "zak_left_arm" ][ "zak_pain" ] 		 = %sniper_escape_meeting_zakhaev_hit_arm_front;

	level.scr_animtree[ "flag" ] 								 = #animtree;		
	level.scr_anim[ "flag" ][ "up" ]						 = %sniper_escape_flag_wave_up;
	level.scr_anim[ "flag" ][ "down" ]					 = %sniper_escape_flag_wave_down;
	level.scr_model[ "flag" ] 									 = "prop_car_flag";
	
	level.scr_animtree[ "briefcase" ] 							 			 = #animtree;	
	level.scr_anim[ "briefcase" ][ "exchange_short" ]			 = %o_pragueb_13_1_meeting_briefcase;
	level.scr_model[ "briefcase" ] 								 	 			 = "com_gold_brick_case";
			
	level.scr_animtree[ "cell_phone" ] 							 		= #animtree;	
	level.scr_anim[ "cell_phone" ][ "shock_and_awe" ]		= %o_pragueb_14_1_shockandawe_phone;
	level.scr_model[ "cell_phone" ] 								 	  = "hjk_cell_phone_on";

	level.scr_animtree[ "oxygen_mask" ] 							 		= #animtree;	
	level.scr_anim[ "oxygen_mask" ][ "emt_assist" ]				= %o_pragueb_16_1_emt_assist_mask;
	level.scr_model[ "oxygen_mask" ] 								 	 	 	= "prague_oxygen_mask_animated";
	
	level.scr_anim[ "falling_tiles" ][ "airport_tiles" ] = %fxanim_prague2_airport_tiles_anim;	
	//addNotetrack_customFunction( "falling_tiles", "lrg_tile_impact", maps\prague_escape_code::play_light_rumble, "airport_tiles" );	

	level.scr_animtree[ "slow_grass" ] 							 		= #animtree;	
	level.scr_anim[ "slow_grass" ][ "slow_anim_grass" ][0] = %fxanim_prague2_grass_lrg_slow_anim;	
	
	level.scr_animtree[ "fast_grass" ] 							 		= #animtree;		
	level.scr_anim[ "fast_grass" ][ "fast_anim_grass" ][0] = %fxanim_prague2_grass_lrg_fast_anim;	

	level.scr_animtree[ "fast_grass" ] 							 		= #animtree;		
	level.scr_anim[ "fast_grass" ][ "fast_anim_grass" ][0] = %fxanim_prague2_grass_lrg_fast_anim;	
	
	level.scr_animtree[ "tall_palm_tree" ] 							 				= #animtree;		
	level.scr_anim[ "tall_palm_tree" ][ "tall_palm_tree_sway" ] = %fxanim_gp_tree_palm_tall_nuke_anim;		
	
	level.scr_animtree[ "bushy_palm_tree" ] 							 				= #animtree;		
	level.scr_anim[ "bushy_palm_tree" ][ "bushy_palm_tree_sway" ] = %fxanim_gp_tree_palm_bushy_nuke_anim;	

	level.scr_anim[ "swinging_light" ][ "airport_light" ] = %fxanim_prague2_airport_light_anim;	
}

play_blind_chunk_exploder(guy)
{
	if(guy.animname == "blind_01")
	{
		exploder(1101);
		exploder(1121);
		
	}
	else if(guy.animname == "blind_02")
	{
		exploder(1102);
		exploder(1122);
		
	}
	else
	{
		exploder(1103);
		exploder(1123);	
	}

}

play_blind_impact_exploder(guy)
{
	if(guy.animname == "blind_01")
	{
		exploder(1111);
		exploder(1121);
		
	}
	else if(guy.animname == "blind_02")
	{
		exploder(1112);
		exploder(1122);
		
	}
	else
	{
		exploder(1113);
		exploder(1123);	
	
	}

}

#using_animtree( "animated_props" );
animated_prop_setup()
{
	//sniper 
	level.scr_animtree["prague_bullet_animated"] = #animtree;
	level.scr_model[ "prague_bullet_animated" ] 		= "prague_bullet_animated";	
	level.scr_anim["prague_bullet_animated"]["prague_bullet"] = %o_pragueb_1_1_bullet;
	
	level.scr_animtree["prague_rsass_clip_animated"] = #animtree;
	level.scr_model[ "prague_rsass_clip_animated" ] 		= "prague_rsass_clip_animated";	
	level.scr_anim["prague_rsass_clip_animated"]["prague_mag"] = %o_pragueb_1_1_mag;
	
	level.scr_animtree["prague_rappel_rope"] = #animtree;
	level.scr_model["prague_rappel_rope"] = "prague_rope_rappel_building_animated";
	level.scr_anim["prague_rappel_rope"]["rappel_hook_up"] = %o_pragueb_1_3_hook_up_rope;
	level.scr_anim["prague_rappel_rope"]["rappel_mid_idle"][0] = %o_pragueb_1_3_idle_rope;
	level.scr_anim["prague_rappel_rope"]["price_window_breach"] = %o_pragueb_1_4_window_breach_rope;
}

prague_escape_vo()
{
	// It's almost time, Yuri?		
	level.scr_sound[ "soap" ][ "presc_mct_almosttime" ] = "presc_mct_almosttime";
	// Makarov's convoy should be here any minute...			
	level.scr_sound[ "soap" ][ "presc_mct_makarovconvoy" ] = "presc_mct_makarovconvoy";
	// Get in position.			
	level.scr_sound[ "soap" ][ "presc_mct_getinposition" ] = "presc_mct_getinposition";
	// Soap - you in position?			
	level.scr_sound[ "price" ][ "presc_mct_almosttime" ] = "presc_mct_almosttime";
	// Ready.			
	level.scr_sound[ "soap" ][ "presc_mct_ready" ] = "presc_mct_ready";
	// Heads up. Makarovs convoy is arriving now		
	level.scr_sound[ "price" ][ "presc_pri_eyesonconvoy" ] = "presc_pri_eyesonconvoy";
	// I see it... Four armored vehicles. Escort on foot... I think they may expect a hit.			
	level.scr_sound[ "soap" ][ "presc_mct_iseeit" ] = "presc_mct_iseeit";
	
	// "Alright, Kamarov.  You're up…"
	level.scr_sound[ "price" ][ "presc_pri_alrightkamarov" ] = "presc_pri_alrightkamarov";
	
	// "Kamarov, do you read me?"
	level.scr_sound[ "price" ][ "presc_pri_doyouread" ] = "presc_pri_doyouread";
	
	// "Probably forgot to switch it on."
	level.scr_sound[ "soap" ][ "presc_mct_switchiton" ] = "presc_mct_switchiton";
	
	// "Doesn't matter.  Makarov's here.  We move forward with the plan."
	level.scr_sound[ "price" ][ "presc_pri_doesntmatter" ] = "presc_pri_doesntmatter";
	
	// "I'm in position.  Ready?"
	level.scr_sound[ "price" ][ "presc_pri_inposition" ] = "presc_pri_inposition";
	
	// Sit tight... Do not engage.			
	level.scr_sound[ "price" ][ "presc_pri_sittight" ] = "presc_pri_sittight";
	// They're stopping in front of the hotel.			
	level.scr_sound[ "soap" ][ "presc_mct_stoppinghotel" ] = "presc_mct_stoppinghotel";
	// Do you see the target?			
	level.scr_sound[ "price" ][ "presc_pri_doyouseetarget" ] = "presc_pri_doyouseetarget";
	// Aye, theres the bastard. Thirs vehicle. 		
	level.scr_sound[ "soap" ][ "presc_mct_makarovcar" ] = "presc_mct_makarovcar";
	// Shit... I think he's looking right at us, Price.			
	level.scr_sound[ "soap" ][ "presc_mct_rightatusprice" ] = "presc_mct_rightatusprice";
	// Don't get skittish now, Soap.			
	level.scr_sound[ "price" ][ "presc_pri_dontgetskiddish" ] = "presc_pri_dontgetskiddish";
	
	// They're pulling in to the garage now.		
	level.scr_sound[ "soap" ][ "presc_mct_frontdoorhotelnow" ] = "presc_mct_frontdoorhotelnow";

	// We got you.			
	level.scr_sound[ "soap" ][ "presc_mct_wegotyou" ] = "presc_mct_wegotyou";
	// Makarov's meeting in the room directly below.			
	level.scr_sound[ "price" ][ "presc_pri_makarovsmeeting" ] = "presc_pri_makarovsmeeting";
	// Preparing to breach.			
	level.scr_sound[ "price" ][ "presc_pri_preparingtobreach" ] = "presc_pri_preparingtobreach";
	// Wait! We've got sentries moving onto the balcony below.			
	level.scr_sound[ "soap" ][ "presc_mct_sentrysbalcony" ] = "presc_mct_sentrysbalcony";
	// Yuri - four targets. Put 'em down, fast.			
	level.scr_sound[ "soap" ][ "presc_mct_fourtargets" ] = "presc_mct_fourtargets";
	level.scr_radio["presc_mct_fourtargets"] = "presc_mct_fourtargets";	
	
		// Yuri take em out lets go		
	level.scr_sound[ "soap" ][ "presc_mct_takethemout" ] = "presc_mct_takethemout";
	level.scr_radio["presc_mct_takethemout"] = "presc_mct_takethemout";	
	
	
	
	// Least we know we've come to the right place.			
	level.scr_sound[ "price" ][ "presc_pri_atleastweknow" ] = "presc_pri_atleastweknow";
	// Breaching now!			
	level.scr_sound[ "price" ][ "presc_pri_breachingnow" ] = "presc_pri_breachingnow";
		
	// "What the hell?  Price - who is that?"		
	level.scr_sound[ "soap" ][ "presc_mct_zoominyuri" ] = "presc_mct_zoominyuri";
	// Kamarov.			
	level.scr_sound[ "price" ][ "presc_pri_allclear" ] = "presc_pri_allclear";
	// I'm sorry Price, I'm sorry...?			
	level.scr_sound[ "kamarov" ][ "presc_mct_makarov" ] = "presc_mct_makarov";
	//Kamarov…what did you tell him?		
	level.scr_sound[ "price" ][ "presc_pri_nosign" ] = "presc_pri_nosign";
	// Everything...		
	level.scr_sound[ "kamarov" ][ "presc_mct_price" ] = "presc_mct_price";
	// Dammit!			
	level.scr_sound[ "price" ][ "presc_pri_damnit" ] = "presc_pri_damnit";
	// Captain, price..[Welcome to Hell]
	level.scr_sound[ "makarov" ][ "presc_mkv_welcometohell" ] = "presc_mkv_welcometohell";
	// It's a setup!!!			
	level.scr_sound[ "price" ][ "presc_pri_itsasetup" ] = "presc_pri_itsasetup";
	// GET OUT OF THERE, PRICE!!!			
	level.scr_sound[ "soap" ][ "presc_mct_getouttathere" ] = "presc_mct_getouttathere";
	
	// these  are in _scaffold.gsc
	// Yuri, my friend... your sacrifice will be remembered.			
	level.scr_sound[ "price" ][ "presc_mkv_yurimyfriend" ] = "presc_mkv_yurimyfriend";
	// What the hell's he talking about, Yuri?!!			
	level.scr_sound[ "soap" ][ "presc_mct_hellshetalkinabout" ] = "presc_mct_hellshetalkinabout";
	
	
	// Yuri - use your scope.			
	level.scr_sound[ "soap" ][ "presc_mct_useyourscope" ] = "presc_mct_useyourscope";
	// Keep watch on the blockade to the right of the hotel.			
	level.scr_sound[ "soap" ][ "presc_mct_keepwatch" ] = "presc_mct_keepwatch";
	// Okay.			
	level.scr_sound[ "soap" ][ "presc_mct_ok" ] = "presc_mct_ok";
	// I see it... Four armored vehicles.			
	level.scr_sound[ "soap" ][ "presc_mct_iseeit" ] = "presc_mct_iseeit";
	// Escort on foot... I think they may expect a hit.			
	level.scr_sound[ "soap" ][ "presc_mct_escortonfoot" ] = "presc_mct_escortonfoot";
	// Bring it up a little.			
	level.scr_sound[ "soap" ][ "presc_mct_upalittle" ] = "presc_mct_upalittle";
	// Down a bit, Yuri.			
	level.scr_sound[ "soap" ][ "presc_mct_downabit" ] = "presc_mct_downabit";
	// A little more to the right.			
	level.scr_sound[ "soap" ][ "presc_mct_pullitmore" ] = "presc_mct_pullitmore";
	// To the left.			
	level.scr_sound[ "soap" ][ "presc_mct_totheleft" ] = "presc_mct_totheleft";
	// Move up and to the left.			
	level.scr_sound[ "soap" ][ "presc_mct_upandleft" ] = "presc_mct_upandleft";
	// Bring it up and right.			
	level.scr_sound[ "soap" ][ "presc_mct_upandright" ] = "presc_mct_upandright";
	// Lower left, Yuri.			
	level.scr_sound[ "soap" ][ "presc_mct_lowerleft" ] = "presc_mct_lowerleft";
	// Down and right.			
	level.scr_sound[ "soap" ][ "presc_mct_downandright" ] = "presc_mct_downandright";
	// Keep your eyes on the convoy, Yuri			
	level.scr_sound[ "soap" ][ "presc_mct_eyesonconvoy" ] = "presc_mct_eyesonconvoy";
	// Don't let the convoy out of your sights.			
	level.scr_sound[ "soap" ][ "presc_mct_outofyoursights" ] = "presc_mct_outofyoursights";
	// Focus on the convoy, Yuri.			
	level.scr_sound[ "soap" ][ "presc_mct_focus" ] = "presc_mct_focus";
	// You see Makarov?			
	level.scr_sound[ "soap" ][ "presc_pri_doyouseemak" ] = "presc_pri_doyouseemak";
	// Can you confirm the target?			
	level.scr_sound[ "soap" ][ "presc_pri_confirmtarget" ] = "presc_pri_confirmtarget";
	// Do you see him?		
	level.scr_sound[ "price" ][ "presc_pri_doyouseetarget" ] = "presc_pri_doyouseetarget";
	// He looks edgy, Price.  Could he know we're here?			
	level.scr_sound[ "soap" ][ "presc_mct_looksedgy" ] = "presc_mct_looksedgy";
	// Find Price in your scope...			
	level.scr_sound[ "soap" ][ "presc_mct_findprice" ] = "presc_mct_findprice";
	// He should be on top of the Hotel.			
	level.scr_sound[ "soap" ][ "presc_mct_ontopofhotel" ] = "presc_mct_ontopofhotel";
	// Come on, Yuri.  What's taking so long?			
	level.scr_sound[ "soap" ][ "presc_pri_whatstaking" ] = "presc_pri_whatstaking";
	// Activity on the Balcony... 			
	level.scr_sound[ "price" ][ "presc_mct_sentrysbalcony" ] = "presc_mct_sentrysbalcony";

	// He's down.			
	level.scr_sound[ "soap" ][ "presc_mct_hesdown" ] = "presc_mct_hesdown";

	// That's a kill.			
	level.scr_sound[ "soap" ][ "presc_mct_thatsakill" ] = "presc_mct_thatsakill";

	// That's a miss.			
	level.scr_sound[ "soap" ][ "presc_mct_thatsamiss" ] = "presc_mct_thatsamiss";

	// GET OUT!!!  NOW!!		
	level.scr_sound[ "soap" ][ "presc_mct_shite" ] = "presc_mct_shite";
	// SOAP!!!			
	level.scr_sound[ "price" ][ "presc_pri_soap" ] = "presc_pri_soap";
	// I got you son, hang in there.			
	level.scr_sound[ "price" ][ "presc_pri_igotyouson" ] = "presc_pri_igotyouson";
	// Yuri!			
	level.scr_sound[ "price" ][ "presc_pri_yuri" ] = "presc_pri_yuri";
	// Grab Soap! We're leaving!			
	level.scr_sound[ "price" ][ "presc_pri_grabsoap" ] = "presc_pri_grabsoap";

	// Keep moving!			
	level.scr_sound[ "price" ][ "presc_pri_keepmoving" ] = "presc_pri_keepmoving";
	// (coughing and spluttering blood)			
	level.scr_sound[ "soap" ][ "presc_mct_coughing" ] = "presc_mct_coughing";
	// We need some cover!			
	level.scr_sound[ "price" ][ "presc_pri_clearthestore" ] = "presc_pri_clearthestore";
	// Through here, lets go!	
	level.scr_sound[ "price" ][ "presc_pri_cmonnow" ] = "presc_pri_cmonnow";
	// We have to get off the streets!			
	level.scr_sound[ "price" ][ "presc_pri_wehavetogetoff" ] = "presc_pri_wehavetogetoff";
	// This way!			
	level.scr_sound[ "price" ][ "presc_pri_thisway" ] = "presc_pri_thisway";
	// Put me down...			
	level.scr_sound[ "soap" ][ "presc_mct_putmedown" ] = "presc_mct_putmedown";
	// Price... Get the hell out of here... Just give me a rifle...			
	level.scr_sound[ "soap" ][ "presc_mct_givemearifle" ] = "presc_mct_givemearifle";
	// Don't you even dare think about it, Yuri...			
	level.scr_sound[ "price" ][ "presc_pri_dontyoudare" ] = "presc_pri_dontyoudare";
	// Come on, Son.			
	level.scr_sound[ "price" ][ "presc_pri_cmonsoap" ] = "presc_pri_cmonsoap";
	// Yuri... Makarov... He said -			
	level.scr_sound[ "soap" ][ "presc_mct_makarovsaid" ] = "presc_mct_makarovsaid";
	
	// *cough* grunt* pain*		
	level.scr_sound[ "soap" ][ "presc_mct_fallpains" ] = "presc_mct_fallpains";
	
	// Thats choppers circling back around we have to move!	
	level.scr_sound[ "price" ][ "presc_pri_chopperscircling" ] = "presc_pri_chopperscircling";

	// Enemy bird! Get off the road!
	level.scr_sound[ "price" ][ "presc_pri_getoffroad" ] = "presc_pri_getoffroad";
	
	//Yuri! Move!
	level.scr_sound[ "price" ][ "presc_pri_yurimove" ] = "presc_pri_yurimove";
	
	//Lets go lets go!
	level.scr_sound[ "price" ][ "presc_pri_letsgoletsgo" ] = "presc_pri_letsgoletsgo";
	
	//Pick up the pace Yuri!
	level.scr_sound[ "price" ][ "presc_pri_pickupthepace" ] = "presc_pri_pickupthepace";
	
	//Dammit Yuri move yer ass!
	level.scr_sound[ "price" ][ "presc_pri_yurimoveyour" ] = "presc_pri_yurimoveyour";
	
	//We need..Nikoli..get us..out..
	level.scr_sound[ "soap" ][ "presc_mct_needto" ] = "presc_mct_needto";
	
	// Pick him up!			
	level.scr_sound[ "price" ][ "presc_pri_pickhimup" ] = "presc_pri_pickhimup";
	// Come on, son... You can make it...			
	level.scr_sound[ "price" ][ "presc_pri_cmonson" ] = "presc_pri_cmonson";
	// Yuri! Take point.			
	level.scr_sound[ "price" ][ "presc_pri_takepoint" ] = "presc_pri_takepoint";
	// They're here!!!			
	level.scr_sound[ "price" ][ "presc_pri_theyrehere" ] = "presc_pri_theyrehere";
	// Nice one son	
	level.scr_sound[ "price" ][ "presc_pri_niceone" ] = "presc_pri_niceone";
	
	// I can still teach you a thing or two old man..	
	level.scr_sound[ "soap" ][ "presc_mct_teachyou" ] = "presc_mct_teachyou";
	
		
	// Get behind the statue!			
	level.scr_sound[ "price" ][ "presc_pri_getbehindstatue" ] = "presc_pri_getbehindstatue";
	// Stay on them, Yuri!			
	level.scr_sound[ "price" ][ "presc_pri_stayonemyuri" ] = "presc_pri_stayonemyuri";
	// On the roof! Right side...			
	level.scr_sound[ "soap" ][ "presc_pri_ontheroof" ] = "presc_pri_ontheroof";
	// We cant stay here, cmon, this way!			
	level.scr_sound[ "price" ][ "presc_pri_reinforcementsright" ] = "presc_pri_reinforcementsright";

	//There's more..on the street..	
	level.scr_sound[ "soap" ][ "presc_mct_damnright" ] = "presc_mct_damnright";
	
	// Yuri take care of em!		
	level.scr_sound[ "price" ][ "presc_pri_findsomewhere" ] = "presc_pri_findsomewhere";

	// Come on, Yuri!			
	level.scr_sound[ "price" ][ "presc_pri_cmonyuri" ] = "presc_pri_cmonyuri";
	// We can't wait!			
	level.scr_sound[ "price" ][ "presc_pri_cantwait" ] = "presc_pri_cantwait";
	// Keep up!			
	level.scr_sound[ "price" ][ "presc_pri_keepup" ] = "presc_pri_keepup";
	// Keep moving!!			
	level.scr_sound[ "price" ][ "presc_pri_keepmoving3" ] = "presc_pri_keepmoving3";
	//Keep moving!		
	level.scr_sound[ "price" ][ "presc_pri_dontslowdown" ] = "presc_pri_dontslowdown";
	// Easy Soap we're almost there, just a little further!			
	level.scr_sound[ "price" ][ "presc_pri_alrightson" ] = "presc_pri_alrightson";
	// Theres more of em!		
	level.scr_sound[ "soap" ][ "presc_pri_enemyvehicleahead" ] = "presc_pri_enemyvehicleahead";
	
	//Just leave me Price	
	level.scr_sound[ "soap" ][ "presc_mct_justleaveme" ] = "presc_mct_justleaveme";
	
	//No! Im getting you out of this!
	level.scr_sound[ "price" ][ "presc_pri_gettingyouout" ] = "presc_pri_gettingyouout";
	
	
	// There's too many!!! We have to make a stand!			
	level.scr_sound[ "price" ][ "presc_pri_therestoomany" ] = "presc_pri_therestoomany";
	// This way - GO!			
	level.scr_sound[ "price" ][ "presc_pri_thisway2" ] = "presc_pri_thisway2";
	// There will be more on the way.			
	level.scr_sound[ "price" ][ "presc_pri_moreontheway" ] = "presc_pri_moreontheway";
	// Head for that building - Northwest corner!			
	level.scr_sound[ "price" ][ "presc_pri_headforthat" ] = "presc_pri_headforthat";
	// Behind us!!!			
	level.scr_sound[ "price" ][ "presc_pri_behindus" ] = "presc_pri_behindus";
	// Yuri - Cover our six!!!			
	level.scr_sound[ "price" ][ "presc_pri_coveroursix" ] = "presc_pri_coveroursix";
	// Keep on them!			
	level.scr_sound[ "price" ][ "presc_pri_keeponem2" ] = "presc_pri_keeponem2";
	// Hold them back!			
	level.scr_sound[ "price" ][ "presc_pri_holdemback" ] = "presc_pri_holdemback";
	// UAZs bringing in reinforcements!			
	level.scr_sound[ "price" ][ "presc_pri_uazreinforce" ] = "presc_pri_uazreinforce";
	// Don't let them get in the fight!			
	level.scr_sound[ "price" ][ "presc_pri_dontletthem" ] = "presc_pri_dontletthem";
	// More reinforcements!			
	level.scr_sound[ "price" ][ "presc_pri_morereinforcements" ] = "presc_pri_morereinforcements";
	// They're trying to rush us!			
	level.scr_sound[ "price" ][ "presc_pri_tryingtorush" ] = "presc_pri_tryingtorush";
	// Right flank, Yuri!.. I'll cover the left!			
	level.scr_sound[ "price" ][ "presc_pri_illcoverleft" ] = "presc_pri_illcoverleft";
	// Right flank!!!			
	level.scr_sound[ "price" ][ "presc_pri_rightflank" ] = "presc_pri_rightflank";
	// Yuri! Cover our left flank!			
	level.scr_sound[ "price" ][ "presc_pri_coverleft" ] = "presc_pri_coverleft";
	// Left flank!			
	level.scr_sound[ "price" ][ "presc_pri_leftflank" ] = "presc_pri_leftflank";
	// Dammit!			
	level.scr_sound[ "price" ][ "presc_pri_damnit" ] = "presc_pri_damnit";
	// They're all around us!			
	level.scr_sound[ "price" ][ "presc_pri_allaroundus" ] = "presc_pri_allaroundus";
	// Yuri!  Get back here!			
	level.scr_sound[ "price" ][ "presc_pri_yurigetbackhere" ] = "presc_pri_yurigetbackhere";
	// Where are you going?!			
	level.scr_sound[ "price" ][ "presc_pri_whereareyougoing" ] = "presc_pri_whereareyougoing";
	// They're bringing in a BTR!			
	level.scr_sound[ "soap" ][ "presc_mct_bringingbtr" ] = "presc_mct_bringingbtr";
	// Dammit!			
	level.scr_sound[ "soap" ][ "presc_mct_damnit" ] = "presc_mct_damnit";
	// You have to go, Price!  Leave me! GO!			
	level.scr_sound[ "soap" ][ "presc_mct_leaveme" ] = "presc_mct_leaveme";
	// Not an option, son.			
	level.scr_sound[ "price" ][ "presc_pri_notanoption" ] = "presc_pri_notanoption";
	// Hold em back!		
	level.scr_sound[ "price" ][ "presc_pri_holdemback" ] = "presc_pri_holdemback";
	// Yuri we need to move Soap, get over here and cover us!	
	level.scr_sound[ "price" ][ "presc_pri_movesoap" ] = "presc_pri_movesoap";	
	// Yuri!  Get over here!!			
	level.scr_sound[ "price" ][ "presc_pri_yurigetoverhere2" ] = "presc_pri_yurigetoverhere2";
	// It's the resistance!			
	level.scr_sound[ "price" ][ "presc_pri_itstheresistance2" ] = "presc_pri_itstheresistance2";	
	// We've got wounded... Help him!			
	level.scr_sound[ "price" ][ "presc_pri_helphim" ] = "presc_pri_helphim";
	// Okay! We're leaving!			
	level.scr_sound[ "price" ][ "presc_pri_wereleaving" ] = "presc_pri_wereleaving";
	// Get him on the table!			
	level.scr_sound[ "price" ][ "presc_pri_gethimontable" ] = "presc_pri_gethimontable";
	// Soap!  SOAP!			
	level.scr_sound[ "price" ][ "presc_pri_soapsoap" ] = "presc_pri_soapsoap";
	// We have to stabilize you before we can extract... Do you understand me, Soap?			
	level.scr_sound[ "price" ][ "presc_pri_havetostabalize" ] = "presc_pri_havetostabalize";
	// Give me some room!			
	level.scr_sound[ "price" ][ "presc_pri_givemeroom" ] = "presc_pri_givemeroom";
	// SHIT!  Yuri! GET OVER HERE!			
	level.scr_sound[ "price" ][ "presc_pri_yurigetoverhere" ] = "presc_pri_yurigetoverhere";
	// Put pressure on the wound!			
	level.scr_sound[ "price" ][ "presc_pri_putpressure" ] = "presc_pri_putpressure";
	// You... need.. to know..			
	level.scr_sound[ "soap" ][ "presc_mct_needtoknow" ] = "presc_mct_needtoknow";
	// Don't try to speak, son!			
	level.scr_sound[ "price" ][ "presc_pri_donttrytospeak" ] = "presc_pri_donttrytospeak";
	// You can tell me later... We've been through much worse..			
	level.scr_sound[ "price" ][ "presc_pri_tellmelater" ] = "presc_pri_tellmelater";
	// Makarov... knows... Yuri...			
	level.scr_sound[ "soap" ][ "presc_mct_knowsyuri" ] = "presc_mct_knowsyuri";
	// Yuri - over here, now!			
	level.scr_sound[ "price" ][ "presc_pri_overherenow" ] = "presc_pri_overherenow";
	// What the Hell are you doing, Yuri!  I need your help!			
	level.scr_sound[ "price" ][ "presc_pri_needyourhelp" ] = "presc_pri_needyourhelp";
	// You... need.. to know..			
	level.scr_sound[ "soap" ][ "presc_mct_youneedtoknow" ] = "presc_mct_youneedtoknow";
	// PRICE...			
	level.scr_sound[ "soap" ][ "presc_mct_price2" ] = "presc_mct_price2";
	// Yuri! Help, dammit!!!!			
	level.scr_sound[ "price" ][ "presc_pri_helpdamnit" ] = "presc_pri_helpdamnit";
	// What the hell are you waiting for?!!			
	level.scr_sound[ "price" ][ "presc_pri_waitingfor" ] = "presc_pri_waitingfor";
	// Stupid.  Russian.  Bastard.			
	level.scr_sound[ "price" ][ "presc_pri_rusianbastard" ] = "presc_pri_rusianbastard";
	// Soap?			
	level.scr_sound[ "price" ][ "presc_pri_soap2" ] = "presc_pri_soap2";
	// PRICE!			
	level.scr_sound[ "resistance_leader" ][ "presc_rl_price" ] = "presc_rl_price";
	// Come on!  We have to go!			
	level.scr_sound[ "resistance_leader" ][ "presc_rl_havetogo" ] = "presc_rl_havetogo";
	// PRICE!  This way.			
	level.scr_sound[ "resistance_leader" ][ "presc_rl_thisway" ] = "presc_rl_thisway";
	// Yuri! Open it!			
	level.scr_sound[ "price" ][ "presc_pri_yuriopenit" ] = "presc_pri_yuriopenit";
	// Get out of here - GO!			
	level.scr_sound[ "resistance_leader" ][ "presc_rl_getout" ] = "presc_rl_getout";
	// You have to go - NOW!			
	level.scr_sound[ "resistance_leader" ][ "presc_rl_now" ] = "presc_rl_havetogo";
	// Soap trusted you...			
	level.scr_sound[ "price" ][ "presc_pri_soaptrustedyou" ] = "presc_pri_soaptrustedyou";
	// I thought I could too...			
	level.scr_sound[ "price" ][ "presc_pri_thoughticouldtoo" ] = "presc_pri_thoughticouldtoo";
	// So why... In bloody hell, does Makarov know you?			
	level.scr_sound[ "price" ][ "presc_pri_makarovknowyou" ] = "presc_pri_makarovknowyou";
	// Yuri, wake up.			
	level.scr_sound[ "makarov" ][ "presc_mkv_yuriwakeup" ] = "presc_mkv_yuriwakeup";
	// ... We are lucky to bear witness to such a moment as this.			
	level.scr_sound[ "makarov" ][ "presc_mkv_wearelucky" ] = "presc_mkv_wearelucky";
	// Zakhaev's deal will generate tens of millions for our cause...			
	level.scr_sound[ "makarov" ][ "presc_mkv_tensofmillions" ] = "presc_mkv_tensofmillions";
	// The road to our future begins here, my friend...			
	level.scr_sound[ "makarov" ][ "presc_mkv_roadtothefuture" ] = "presc_mkv_roadtothefuture";
	
	level.scr_sound[ "zakhaev" ][ "presc_zkv_whatdoyou" ] 	= "presc_zkv_whatdoyou";
	level.scr_sound[ "zakhaev" ][ "presc_zkv_hadadeal" ] 		= "presc_zkv_hadadeal";
	level.scr_sound[ "zakhaev" ][ "presc_zkv_argueover" ] 	= "presc_zkv_argueover";
	level.scr_sound[ "zakhaev" ][ "presc_zkv_knownbetter" ] = "presc_zkv_knownbetter";
	
	// It's an attack!			
	level.scr_sound[ "makarov" ][ "presc_mkv_itsanattack" ] = "presc_mkv_itsanattack";
	// Get us out of here!			
	level.scr_sound[ "zakhaev" ][ "presc_rl_getusout" ] = "presc_rl_getusout";
	// Money can buy many things... even power...			
	level.scr_sound[ "makarov" ][ "presc_mkv_moneycan" ] = "presc_mkv_moneycan";
	// Yuri - Telephone.			
	level.scr_sound[ "makarov" ][ "presc_mkv_telephone" ] = "presc_mkv_telephone";
	// Is everything ready?			
	level.scr_sound[ "makarov" ][ "presc_mkv_everythingready" ] = "presc_mkv_everythingready";
	// Do it.			
	level.scr_sound[ "makarov" ][ "presc_mkv_doit" ] = "presc_mkv_doit";
	// Today, the Americans will learn the strength of our conviction.			
	level.scr_sound[ "makarov" ][ "presc_mkv_americanslearn" ] = "presc_mkv_americanslearn";
	// This is only the beginning.			
	level.scr_sound[ "makarov" ][ "presc_mkv_onlybeginning" ] = "presc_mkv_onlybeginning";
	// I know what you have done, Yuri.  I know what you have told them.			
	level.scr_sound[ "makarov" ][ "presc_mkv_iknowwhat" ] = "presc_mkv_iknowwhat";
	// My friend... My ally... My betrayer.			
	level.scr_sound[ "makarov" ][ "presc_mkv_myfriend" ] = "presc_mkv_myfriend";
	// What happens here today, will change the world forever.			
	level.scr_sound[ "makarov" ][ "presc_mkv_changeforever" ] = "presc_mkv_changeforever";
	// Nothing can stop this...			
	level.scr_sound[ "makarov" ][ "presc_mkv_nothingcanstop" ] = "presc_mkv_nothingcanstop";
	// Not even you.			
	level.scr_sound[ "makarov" ][ "presc_mkv_notevenyou" ] = "presc_mkv_notevenyou";
	// We've got a live one, here!	NEEDS RUSSIAN TRANSLATION		
	level.scr_sound[ "emt" ][ "presc_med_liveone" ] = "presc_med_liveone";
	// Okay, Yuri...			
	level.scr_sound[ "price" ][ "presc_pri_okyuri" ] = "presc_pri_okyuri";
	// You've bought yourself some time...			
	level.scr_sound[ "price" ][ "presc_pri_boughtyourself" ] = "presc_pri_boughtyourself";
	// ...But I'm watching you.			
	level.scr_sound[ "price" ][ "presc_pri_watchingyou" ] = "presc_pri_watchingyou";
	// Vanya!  Get to cover!	Vanyo! Kryj se!		
	level.scr_sound[ "rebel" ][ "presc_reb1_gettogether" ] = "presc_reb1_gettogether";
	// ARGH!!!!  My fucking leg!  Fuck!  It fucking hurts!	AUVAJS! Zasran?noha! To kurevsky bol?		
	level.scr_sound[ "rebel" ][ "presc_reb1_myleg" ] = "presc_reb1_myleg";
	// Makarov can go fuck himself!	Makarov at si jde hodit mašli		
	level.scr_sound[ "rebel" ][ "presc_reb1_makarovcan" ] = "presc_reb1_makarovcan";
	// Mother!!!!  ARRGGHHH!!  I want my mother!!!	Mámo!!!!! AAAAACH! Maminko!!!		
	level.scr_sound[ "rebel" ][ "presc_reb1_mother" ] = "presc_reb1_mother";
	// Help me!  Please!  Arggh!!!	Pomozte mi! Prosím! Aaach!!!		
	level.scr_sound[ "rebel" ][ "presc_reb1_helpme" ] = "presc_reb1_helpme";
	// For Prague!  For Prague!  For Prague!	Za Prahu! Za Prahu! Za Prahu!		
	level.scr_sound[ "rebel" ][ "presc_reb1_forpresc" ] = "presc_reb1_forpresc";
	// Never give up, brothers!	Kamarádi, nikdy se nevzdávejte!		
	level.scr_sound[ "rebel" ][ "presc_reb1_nevergiveup" ] = "presc_reb1_nevergiveup";
	// Quick!  In here!	Rychle, sem!		
	level.scr_sound[ "rebel" ][ "presc_reb1_quick" ] = "presc_reb1_quick";
	// Are they going to stop Makarov?	Zastav?Makarova?		
	level.scr_sound[ "rebel" ][ "presc_reb1_stopmakarov" ] = "presc_reb1_stopmakarov";
	// Who the fuck are these assholes?	Kde ty bastardi sakra jsou?		
	level.scr_sound[ "rebel" ][ "presc_reb1_whothe" ] = "presc_reb1_whothe";
	// Keep your voices down.	Mluvte potichu.		
	level.scr_sound[ "rebel" ][ "presc_reb1_voicesdown" ] = "presc_reb1_voicesdown";
	// We didn't do anything either.	My jsme neudelali taky nic.		
	level.scr_sound[ "rebel" ][ "presc_reb1_doanything" ] = "presc_reb1_doanything";
	// Some birthday.  How old are you?	No a co, narozeniny. Kolik ti je?		
	level.scr_sound[ "rebel" ][ "presc_reb1_howold" ] = "presc_reb1_howold";
	// He's drunk.  	Je namol.		
	level.scr_sound[ "rebel" ][ "presc_reb1_drunk" ] = "presc_reb1_drunk";
	// Kill all of them!  Don't stop shooting, brothers!	Sejmete je všechny! Kamarádi, neprestávejte strílet!		
	level.scr_sound[ "rebel" ][ "presc_reb2_killallofthem" ] = "presc_reb2_killallofthem";
	// We'll fix you!  I won't let you die!	To se sprav? Nenecháme te umrít!		
	level.scr_sound[ "rebel" ][ "presc_reb2_wellfixyou" ] = "presc_reb2_wellfixyou";
	// You can't kill me you fucking assholes!  You will not destroy me tonight!	Vy mizern?bastardi, dneska mne nedostanete! Dneska mne nikdo neznic?		
	level.scr_sound[ "rebel" ][ "presc_reb2_cantkillme" ] = "presc_reb2_cantkillme";
	// Get someone to help treat the wounded!	Sežente nekoho, at ošetr?zranen?		
	level.scr_sound[ "rebel" ][ "presc_reb2_treatwounded" ] = "presc_reb2_treatwounded";
	// We're all going to die!  This is hopeless!	Všichni tu chcípnem! Je po všem!		
	level.scr_sound[ "rebel" ][ "presc_reb2_hopeless" ] = "presc_reb2_hopeless";
	// Destroy the invaders!	Znicte okupanty!		
	level.scr_sound[ "rebel" ][ "presc_reb2_destroy" ] = "presc_reb2_destroy";
	// You must be here to save us!	Urcite jste nás prišli zachránit!		
	level.scr_sound[ "rebel" ][ "presc_reb2_mustbehere" ] = "presc_reb2_mustbehere";
	// I hope they kill that son of a bitch Makarov.	Doufám, že dostanou toho šmejda Makarova.		
	level.scr_sound[ "rebel" ][ "presc_reb2_ihope" ] = "presc_reb2_ihope";
	// They're going to help us win the war, brother.	Pomužou nám vyhrát válku, kamaráde.		
	level.scr_sound[ "rebel" ][ "presc_reb2_helpuswin" ] = "presc_reb2_helpuswin";
	// They just watched as our people were gunned down on the docks.	Jen se dívali, jak tam naše v docích postríleli.		
	level.scr_sound[ "rebel" ][ "presc_reb2_theyjustwatched" ] = "presc_reb2_theyjustwatched";
	// Did you know it was my birthday today?	Vedeli jste, že mám dneska narozeniny?		
	level.scr_sound[ "rebel" ][ "presc_reb2_didyouknow" ] = "presc_reb2_didyouknow";
	// Four.	Ctyri.		
	level.scr_sound[ "rebel" ][ "presc_reb2_four" ] = "presc_reb2_four";
	// Get an RPG over here!  I need more ammo!	Hod sem RPG! Potrebuju strelivo!		
	level.scr_sound[ "rebel" ][ "presc_reb3_getanrpg" ] = "presc_reb3_getanrpg";
	// Give them hell, brothers!  They will never take us alive!	Dejte jim co proto, kamarádi! Nikdy nás nedostanou živ?		
	level.scr_sound[ "rebel" ][ "presc_reb3_givethemhell" ] = "presc_reb3_givethemhell";
	// I need a medic!  I'm wounded!  	Potrebuju lékare! Poranili mne!		
	level.scr_sound[ "rebel" ][ "presc_reb3_ineedamedic" ] = "presc_reb3_ineedamedic";
	// I can't find my son!  Please help!  I can't find my son!	Nemužu najít svého syna. Pomožte mi, nemužu najít syna!		
	level.scr_sound[ "rebel" ][ "presc_reb3_cantfindson" ] = "presc_reb3_cantfindson";
	// Shut up!  Shoot your fucking weapon! 	Zmlkni a strílej!		
	level.scr_sound[ "rebel" ][ "presc_reb3_shutup" ] = "presc_reb3_shutup";
	// For great justice!	Za spravedlnost!		
	level.scr_sound[ "rebel" ][ "presc_reb3_forgreat" ] = "presc_reb3_forgreat";
	// Who are these men?	Co jsou ti chlápci zac?		
	level.scr_sound[ "rebel" ][ "presc_reb3_whoarethesemen" ] = "presc_reb3_whoarethesemen";
	// Quiet!  I hear something.	Ticho, neco slyším.		
	level.scr_sound[ "rebel" ][ "presc_reb3_quiet" ] = "presc_reb3_quiet";
	// They don't look so tough to me.	Nevypadaj?nijak drsne.		
	level.scr_sound[ "rebel" ][ "presc_reb3_dontlooktough" ] = "presc_reb3_dontlooktough";
	// There was nothing they could do.	Nemohli s tím nic delat.		
	level.scr_sound[ "rebel" ][ "presc_reb3_nothing" ] = "presc_reb3_nothing";
	// What the fuck?	Si deláš srandu?		
	level.scr_sound[ "rebel" ][ "presc_reb3_whatthe" ] = "presc_reb3_whatthe";
	
	//Russian Chopper
	// "I see the intruder! He's armed!"
	level.scr_sound[ "russian_chopper_pilot" ][ "presc_rcp_intruder" ] = "presc_rcp_intruder";
	// "Drop your weapon! Drop it now!"
	level.scr_sound[ "russian_chopper_pilot" ][ "presc_rcp_dropweapon" ] = "presc_rcp_dropweapon";
	// "Get your hands up! Do it now!"
	level.scr_sound[ "russian_chopper_pilot" ][ "presc_rcp_handsup" ] = "presc_rcp_handsup";
}

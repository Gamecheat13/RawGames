#include maps\_anim;
#using_animtree("generic_human");

main()
{
	level.scr_anim["hostile"]["patrol_twitch"]			= %patrolstand_twitch;
	
	level.scr_anim["hostile"]["phoneguy_idle_start"]			= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_idle"][0]				= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_alerted"]				= %parabolic_phoneguy_reaction;
	level.scr_anim["hostile"][ "phoneguy_death" ]			= %parabolic_knifekill_phoneguy;

	level.scr_anim[ "generic" ][ "rappel_end" ]					= %sniper_escape_rappel_finish;
	level.scr_anim[ "generic" ][ "rappel_start" ]					= %sniper_escape_rappel_start;
	level.scr_anim[ "generic" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle;

	/*-----------------------
	KNIFE KILL SEQUENCE
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "knifekill_mark" ]			= %parabolic_knifekill_mark;
	level.scr_anim[ "frnd" ][ "knifekill_altending_mark" ]	= %parabolic_knifekill_altending_mark;
	
	level.scr_anim["hostile"]["shack_idle_01"][0]				= %patrolstand_twitch;
	
	level.scr_anim[ "frnd" ][ "signal_assault_coverstand" ]		= %coverstand_hide_idle_wave02;
	level.scr_anim[ "frnd" ][ "signal_forward_coverstand" ]		= %coverstand_hide_idle_wave01;

	level.scr_anim[ "chess_guy1" ][ "surprise" ]				= %parabolic_chessgame_surprise_a;
	level.scr_anim[ "chess_guy2" ][ "surprise" ]				= %parabolic_chessgame_surprise_b;
	level.scr_anim[ "chess_guy1" ][ "idle" ][ 0 ]				= %parabolic_chessgame_idle_a;
	level.scr_anim[ "chess_guy2" ][ "idle" ][ 0 ]				= %parabolic_chessgame_idle_b;
	level.scr_anim[ "chess_guy1" ][ "death" ]					= %parabolic_chessgame_death_a;
	level.scr_anim[ "chess_guy2" ][ "death" ]					= %parabolic_chessgame_death_b;

	/*
	level.scr_anim[ "flashlight_guy" ][ "death" ]				= %blackout_flashlightguy_death_only;
	level.scr_anim[ "flashlight_guy" ][ "death" ]				= %blackout_flashlightguy_moment2death;
	level.scr_anim[ "flashlight_guy" ][ "death" ]				= %blackout_flashlightguy_moment2death_flashlight;

	level.scr_anim[ "price" ][ "death" ]						= %blackout_rescue_price;
	level.scr_anim[ "price" ][ "death" ]						= %blackout_rescue_price_flashlight;
	level.scr_anim[ "vip" ][ "death" ]							= %blackout_rescue_vip;
	level.scr_anim[ "vip" ][ "death" ]							= %blackout_vip_cower_idle;
	*/


	level.scr_anim[ "generic" ][ "casual_patrol_jog" ]	= %patrol_jog;
	level.scr_anim[ "generic" ][ "casual_patrol_walk" ]	= %patrolwalk_tired; // patrolwalk_swagger;
	level.scr_anim[ "generic" ][ "combat_jog" ]			= %combat_jog;
	level.scr_anim[ "generic" ][ "smoke" ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]	= %patrol_bored_idle_smoke;

	level.scr_anim[ "generic" ][ "moveout_cqb" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "moveup_cqb" ]					= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "stop_cqb" ]					= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "onme_cqb" ]					= %CQB_stand_wave_on_me;
	
	level.scr_anim[ "generic" ][ "signal_moveup" ]				= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_onme" ]				= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop" ]				= %CQB_stand_signal_stop;

	level.scr_anim[ "generic" ][ "bored_idle_reach" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 1 ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 2 ]			= %patrol_bored_twitch_stretch;
	
	
	
	level.scr_anim[ "generic" ][ "bored_alert" ]				= %exposed_idle_twitch_v4; // %patrol_bored_2_combat_alarm;
	level.scr_anim[ "generic" ][ "bored_smoke" ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "bored_cell" ]					= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "bored_salute" ]				= %patrol_bored_twitch_salute;
	level.scr_anim[ "generic" ][ "bored_checkphone" ]			= %patrol_bored_twitch_checkphone;

	level.scr_anim[ "generic" ][ "bored_cell_loop" ][ 0 ]		= %patrol_bored_idle_cellphone;

	level.scr_anim[ "generic" ][ "sleep_idle" ][ 0 ]			= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "sleep_react" ]				= %parabolic_guard_sleeper_react;
	
	level.scr_anim[ "generic" ][ "stealth_jog" ]				= %patrol_jog;
	level.scr_anim[ "generic" ][ "stealth_walk" ]				= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "combat_jog" ]					= %combat_jog;

	level.scr_anim[ "generic" ][ "prone_to_stand_1" ]			= %hunted_pronehide_2_stand_v1;
	level.scr_anim[ "generic" ][ "prone_to_stand_2" ]			= %hunted_pronehide_2_stand_v2;
	level.scr_anim[ "generic" ][ "prone_to_stand_3" ]			= %hunted_pronehide_2_stand_v3;

	level.scr_anim[ "generic" ][ "smoking_reach" ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				= %parabolic_leaning_guy_react;
	

	

	level.scr_anim[ "generic" ][ "prone_dive" ] 				= %hunted_dive_2_pronehide_v1;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]		= %exposed_idle_twitch_v4;//patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_heard_scream" ]			= %exposed_idle_twitch_v4;

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;


	level.scr_anim[ "generic" ][ "blind_fire_pistol" ][ 0 ]		= %blackout_blind_fire_pistol;
	level.scr_anim[ "generic" ][ "blind_fire_pistol_death" ]	= %blackout_blind_fire_pistol_death;
	level.scr_anim[ "generic" ][ "blind_hide_fire" ]			= %blackout_blind_hide_fire;
	level.scr_anim[ "generic" ][ "blind_hide_fire_death" ]		= %blackout_blind_hide_fire_death;
	level.scr_anim[ "generic" ][ "blind_lightswitch" ]			= %blackout_blind_lightswitch;
	level.scr_anim[ "generic" ][ "blind_lightswitch_death" ]	= %blackout_blind_lightswitch_death;
	level.scr_anim[ "generic" ][ "blind_wall_feel" ]			= %blackout_blind_wall_feel;
	level.scr_anim[ "generic" ][ "blind_wall_feel_death" ]		= %blackout_blind_wall_feel_death;

	level.scr_anim[ "doorguy" ][ "close" ]						= %doorpeek_close;
	level.scr_anim[ "doorguy" ][ "death_1" ]					= %doorpeek_deathA;
	level.scr_anim[ "doorguy" ][ "death_2" ]					= %doorpeek_deathB;

	level.scr_anim[ "doorguy" ][ "fire_1" ]						= %doorpeek_fireA;
	level.scr_anim[ "doorguy" ][ "fire_2" ]						= %doorpeek_fireB;
	level.scr_anim[ "doorguy" ][ "fire_3" ]						= %doorpeek_fireC;
	
	level.scr_anim[ "doorguy" ][ "grenade" ]					= %doorpeek_grenade;

	level.scr_anim[ "doorguy" ][ "idle" ][ 0 ]					= %doorpeek_idle;
	level.scr_anim[ "doorguy" ][ "jump" ]						= %doorpeek_jump;
	level.scr_anim[ "doorguy" ][ "kick" ]						= %doorpeek_kick;
	level.scr_anim[ "doorguy" ][ "open" ]						= %doorpeek_open;

	
	level.scr_anim[ "price" ][ "smooth_door_open" ]				= %hunted_open_barndoor;




	//* The Loyalists are expecting us half a klick to the north. Move out.
	level.scr_sound[ "price" ][ "expecting_us" ]							= "blackout_pri_halfaclick";
	
	//* Well, they won't shoot at us on sight, if that's what you're asking.                               
	level.scr_sound[ "price" ][ "wont_shoot_us" ]						= "blackout_pri_shootatus";
	
	//* What's the target Kamarov? We've got an informant to recover.                                     
	level.scr_sound[ "price" ][ "whats_the_target" ]						= "blackout_pri_whattarget";
	
	//* Then let's get to it.                                                                                
	level.scr_sound[ "price" ][ "lets_get_to_it" ]						= "blackout_pri_gettoit";
	
	//* Soap, over here.                                                                                    
	level.scr_sound[ "price" ][ "over_here" ]							= "blackout_pri_overhere";
	
	//* Sniper team in position. Gaz, cover the left flank.                                                
	level.scr_sound[ "price" ][ "in_position" ]							= "blackout_pri_leftflank";
	
	// Soap! Hit those machine gunners in the windows!                         
	//* Soap, take out the machine gunners in the windows so Kamarov's men can storm the building!          
	level.scr_sound[ "price" ][ "machine_gunners_in_windows" ]			= "blackout_pri_takeoutmgs";
	
	//* Not a problem. We'll take care of it. Soap, Gaz, let's go!                                        
	level.scr_sound[ "price" ][ "not_a_problem" ]						= "blackout_pri_takecare";
	
	// Soap, watch the BMP and take out any hostiles you see.                                              
	level.scr_sound[ "price" ][ "watch_bmp" ]							= "blackout_pri_watchbmp";
	
	// Go - go - go!                                                                                         
	level.scr_sound[ "price" ][ "go_go_go" ]								= "blackout_pri_gogogo";
	
	//* Soap, get to the edge of the cliff and cover Kamarov's men! Move!                                
	level.scr_sound[ "price" ][ "cover_cliff" ]							= "blackout_pri_edgeofcliff";
	
	// Nice work Soap.                                                                                     
	level.scr_sound[ "price" ][ "nice_work" ]							= "blackout_pri_nicework";
	
	//* Kamarov, we've completed our end of the bargain. Now where is the informant?                      
	level.scr_sound[ "price" ][ "where_is_informant" ]					= "blackout_pri_ourbargain";
	
	//* Bloody hell let's move. He may still be alive.                                                  
	level.scr_sound[ "price" ][ "lets_move" ]							= "blackout_pri_stillbealive";
	
	//* Gaz, go around the back and cut the power. Everyone else, get ready!                                
	level.scr_sound[ "price" ][ "cut_the_power" ]						= "blackout_pri_cutpower";
	
	// It's him.                                                                                             
	level.scr_sound[ "price" ][ "its_him" ]								= "blackout_pri_itshim";
	
	// Big Bird this Bravo Six. We have the package. Meet us at LZ one. Over.                              
	level.scr_sound[ "price" ][ "have_the_package" ]						= "blackout_pri_meetatlz";
	
	// Let's go! Let's go!                                                                                   
	level.scr_sound[ "price" ][ "lets_go_lets_go" ]						= "blackout_pri_letsgo";
	
	// No, their invasion begins in a few hours! Why?                                                      
	level.scr_sound[ "price" ][ "invasion_begins" ]						= "blackout_pri_invasion";
	
	//* Loyalists eh? Are those are the good Russians or the bad Russians?                              
	level.scr_sound[ "gaz" ][ "loyalists_eh" ]							= "blackout_gaz_loyalistseh";
	
	//* That's good enough for me sir.                                                                   
	level.scr_sound[ "gaz" ][ "good_enough" ]							= "blackout_gaz_goodenough";
	
	//* Roger. Covering left flank.                                                                       
	level.scr_sound[ "gaz" ][ "cover_left_flank" ]						= "blackout_gaz_leftflank";
	
	// Target of opportunity sir. We got a BMP down there.                                             
	level.scr_sound[ "gaz" ][ "got_a_bmp" ]								= "blackout_gaz_opportunity";
	
	//* Sir, we've got company! Helicopter troops closing in fast!                                       
	level.scr_sound[ "gaz" ][ "helicopter_troops" ]						= "blackout_gaz_helitroops";
	
	//* Tangos neutralized! All clear!                                                                     
	level.scr_sound[ "gaz" ][ "tangos_neutralized" ]						= "blackout_gaz_allclear";
	
	//* May be alive?? I hate bargaining with Kamarov. There's always a bloody catch.                    
	level.scr_sound[ "gaz" ][ "hate_bargaining" ]						= "blackout_gaz_maybealive";
	
	// Soap! Regroup with Captain Price! You can storm the building when I cut the power. Go!         
	level.scr_sound[ "gaz" ][ "regroup_with_price" ]						= "blackout_gaz_regroupprice";
	
	// Nikolai - are you all right? Can you walk?														    
	level.scr_sound[ "gaz" ][ "are_you_all_right" ]						= "blackout_gaz_allright";
	

	
	maps\_breach_explosive_left::main(); 

//  patrol_bored_patrolwalk // loping, slow look left and right
//	walk_lowready_F  // aiming
//	patrolwalk_swagger // walks with gun held low
//	patrolwalk_bounce
//	patrolwalk_tired
//  stand_walk_combat_loop
//	sniper_escape_price_walk

	//level.scr_anim[ "frnd" ][ "signal_cqb_rally_on_me" ]		= %cqb_stand_wave_go_v1;
/*
guard_sleeper_idle
guard_sleeper_react
leaning_guy_idle
leaning_guy_smoking_idle
leaning_guy_smoking_twitch
leaning_guy_talk
leaning_guy_trans2idle
leaning_guy_trans2smoke
leaning_guy_twitch
*/   
	script_models();
	player_rappel();
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_anim[ "chair" ][ "chair_react" ]					= %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "chair" ] 								= #animtree;	
	level.scr_model[ "chair" ] 									= "com_folding_chair";

	level.scr_animtree[ "door" ] 								= #animtree;	
	level.scr_model[ "door" ] 									= "com_door_01_handleleft";

	level.scr_anim[ "door" ][ "close" ]							= %doorpeek_close_door;
	level.scr_anim[ "door" ][ "death_1" ]						= %doorpeek_deathA_door;
	level.scr_anim[ "door" ][ "death_2" ]						= %doorpeek_deathB_door;

	level.scr_anim[ "door" ][ "fire_1" ]						= %doorpeek_fireA_door;
	level.scr_anim[ "door" ][ "fire_2" ]						= %doorpeek_fireB_door;
	level.scr_anim[ "door" ][ "fire_3" ]						= %doorpeek_fireC_door;
	
	level.scr_anim[ "door" ][ "grenade" ]						= %doorpeek_grenade_door;

	level.scr_anim[ "door" ][ "idle" ][ 0 ]						= %doorpeek_idle_door;
	level.scr_anim[ "door" ][ "jump" ]							= %doorpeek_jump_door;
	level.scr_anim[ "door" ][ "kick" ]							= %doorpeek_kick_door;
	level.scr_anim[ "door" ][ "open" ]							= %doorpeek_open_door;
	precachemodel( level.scr_model[ "door" ] );

	precacheModel( "rappelrope100_ri" );
	level.scr_animtree[ "rope" ] 								= #animtree;
	level.scr_model[ "rope" ] 									= "rappelrope100_ri";

	precacheModel( "rappelrope100_le" );
	level.scr_anim[ "player_rope" ][ "rappel_for_player" ]		= %sniper_escape_player_start_rappelrope100;
	level.scr_animtree[ "player_rope" ] 						= #animtree;
	level.scr_model[ "player_rope" ] 							= "rappelrope100_le";

	level.scr_anim[ "rope" ][ "rappel_end" ]					= %sniper_escape_rappel_finish_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_start" ]					= %sniper_escape_rappel_start_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle_rappelrope100;
}

#using_animtree( "player" );
player_rappel()
{
	level.scr_anim[ "player_rappel" ][ "rappel" ]						= %sniper_escape_player_rappel;
	level.scr_animtree[ "player_rappel" ] 								= #animtree;	
	level.scr_model[ "player_rappel" ] 									= "viewhands_player_marines";
}

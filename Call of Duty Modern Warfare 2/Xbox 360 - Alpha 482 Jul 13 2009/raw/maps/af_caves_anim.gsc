#include maps\_anim;
#include maps\_props;
#include maps\_utility;
#include maps\af_caves_code;

main()
{
	anims();
	dialog();
	dog();
	script_models();
	player_animations();
	animated_model_setup();
}

#using_animtree( "generic_human" );
anims()
{
//GENERIC
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_reach" ]					= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke" ]							= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_react" ]					= %patrol_bored_react_look_advance;
	
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][ 0 ]			= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][ 1 ]			= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "lean_smoke_react" ]			  	= %parabolic_leaning_guy_react;
	
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_idle" ][ 0 ]		= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_idle" ][ 1 ]		= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "lean_smoker" ][ "lean_smoke_react" ]			= %parabolic_leaning_guy_react;

	add_sit_load_ak_notetracks( "generic" );
	level.scr_anim[ "generic" ][ "sit_load_ak_idle" ][ 0 ]			= %sitting_guard_loadAK_idle;
	level.scr_anim[ "generic" ][ "sit_load_ak_react" ]				= %sitting_guard_loadAK_react1;

	level.scr_anim[ "generic" ][ "patrol_walk" ]				  	= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]				= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]				  	= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]				  	= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				 	= %patrol_bored_2_walk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]				 	= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]				 	= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]				 	= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]				 	= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]				 	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]				 	= %patrol_bored_twitch_stretch;

	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]			  	= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	  		= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]		  	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]			  	= %patrol_bored_idle_cellphone;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]		= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]		= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]		= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]		= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]		= %run_pain_stumble;

	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]= %exposed_idle_twitch_v4;// patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]	= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_heard_scream" ]	= %exposed_idle_twitch_v4;

	level.scr_anim[ "generic" ][ "combat_jog" ]					= %combat_jog;

	level.scr_anim[ "generic" ][ "smoking_reach" ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				= %parabolic_leaning_guy_react;

	level.scr_anim[ "generic" ][ "sit_idle" ][ 0 ]				= %breach_chair_idle_v2;
	level.scr_anim[ "generic" ][ "sit_react" ]					= %breach_chair_reaction_v2;

// Guys sleeping on a cot
	level.scr_anim[ "generic" ][ "sleep_idle1" ][ 0 ]			= %afgan_caves_sleeping_guard_idle;
	level.scr_anim[ "generic" ][ "sleep_death1" ]				= %cargoship_sleeping_guy_death_1;
	level.scr_anim[ "generic" ][ "sleep_alert1" ]				= %afgan_caves_sleeping_guard_scramble;
	
// Chess Players
	level.scr_anim[ "generic" ][ "surprise_1" ]					= %parabolic_chessgame_surprise_a;
	level.scr_anim[ "generic" ][ "surprise_2" ]					= %parabolic_chessgame_surprise_b;
	level.scr_anim[ "generic" ][ "idle_1" ][ 0 ]				= %parabolic_chessgame_idle_a;
	level.scr_anim[ "generic" ][ "idle_2" ][ 0 ]				= %parabolic_chessgame_idle_b;
	level.scr_anim[ "chess_guy1" ][ "death" ]					= %parabolic_chessgame_death_a;
	level.scr_anim[ "chess_guy2" ][ "death" ]					= %parabolic_chessgame_death_b;
	
//CQB Hand signals
	level.scr_anim[ "generic" ][ "moveout_cqb" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "moveup_cqb" ]					= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_go" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "stop_cqb" ]					= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "onme_cqb" ]					= %CQB_stand_wave_on_me;	
	
	level.scr_anim[ "price" ][ "intro_stop" ]					= %afgan_caves_intro_stop;	
	
	level.scr_anim[ "generic" ][ "run_2_crouch_f" ]				= %run_2_crouch_f;
	level.scr_anim[ "generic" ][ "crouch_fastwalk_f" ]			= %crouch_fastwalk_F;
	level.scr_anim[ "generic" ][ "crouch_talk" ]				= %casual_crouch_V2_talk;
	level.scr_anim[ "generic" ][ "crouch_idle" ]				= %casual_crouch_idle;
	
	level.scr_anim[ "generic" ][ "look_up_stand" ]				= %coverstand_look_moveup;
	level.scr_anim[ "generic" ][ "look_idle_stand" ][ 0 ]		= %coverstand_look_idle;
	level.scr_anim[ "generic" ][ "look_down_stand" ]			= %coverstand_look_movedown;
	
//INTRO
	level.scr_anim[ "price" ][ "rise_up" ]	 					= %scout_sniper_price_prone_opening;	
	level.scr_anim[ "price" ][ "price_slide" ]	 				= %afgan_caves_price_slide;	

//RAPPEL
	level.scr_anim[ "price" ][ "rappel" ]						= %afgan_caves_price_rappel_animatic;
	level.scr_anim[ "price" ][ "pri_rappel_setup" ]				= %afgan_caves_price_rappel_setup;
	level.scr_anim[ "price" ][ "pri_rappel_idle" ][ 0 ]			= %afgan_caves_price_rappel_idle;
	addNotetrack_customFunction( "price", "rope", maps\af_caves::price_rope_hookup, "pri_rappel_setup" );
			
	level.scr_anim[ "price" ][ "pri_rappel_jump" ]				= %afgan_caves_price_rappel_jump;
	addNotetrack_attach(  "price", "knife", "weapon_parabolic_knife", "TAG_INHAND", "pri_rappel_jump" );
	
	level.scr_anim[ "price" ][ "pri_hanging_idle" ][ 0 ]		= %afgan_caves_Price_hanging_idle;	
	
	level.scr_anim[ "price" ][ "pri_rappel_kill" ]				= %afgan_caves_Price_rappel_kill;
	addNotetrack_detach( "price", "knife", "weapon_parabolic_knife", "TAG_INHAND", "pri_rappel_kill" );

	level.scr_anim[ "guard_2" ][ "flick" ] 						= %cliff_guardA_flick;
	level.scr_anim[ "guard_2" ][ "guardB_idle" ][ 0 ]			= %cliff_guardB_idle;	
	level.scr_anim[ "guard_2" ][ "guardB_react" ] 				= %cliff_guardB_react;
	level.scr_anim[ "guard_2" ][ "guard_2_death" ] 				= %afgan_caves_guard_2_death;
	
	level.scr_anim[ "guard_1" ][ "rappel_kill" ] 				= %afgan_caves_guard_1_death;
	level.scr_anim[ "guard_1" ][ "guardA_idle" ][ 0 ]			= %cliff_guardA_idle;
	level.scr_anim[ "guard_1" ][ "guardA_react" ] 				= %cliff_guardA_react;

	addNotetrack_customFunction( "guard_1", "kill", ::kill_me );

//	addNotetrack_flag( "price", "dialogue", "price_hooksup", "pri_rappel_setup" );

	level.scr_anim[ "guard_2" ][ "rappel" ]						= %afgan_caves_guard_2_animatic;

// PLAYER RAPPEL SHADOW
//	level.scr_anim[ "rappel_shadow" ][ "shadow_stop" ] 			= %afgan_caves_player_shadow_stop;
//	level.scr_anim[ "rappel_shadow" ][ "shadow_jump" ] 			= %afgan_caves_player_shadow_jump;
	
	level.scr_anim[ "rappel_shadow" ][ "rappel_frame" ] 		= %covercrouch_run_in_M;
	level.scr_animtree[ "rappel_shadow" ] = #animtree;
	

//LEDGE
//	level.scr_anim[ "price" ][ "pri_dive" ]						= %exposed_dive_grenade_B;
//	level.scr_anim[ "price" ][ "pri_prone_stand" ]				= %prone_2_stand;

	level.scr_anim[ "price" ][ "pri_dive" ]						= %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "price" ][ "pri_prone_stand" ]				= %hunted_pronehide_2_stand_v1;

	level.scr_anim[ "price" ][ "pri_bridge_jump" ]				= %jump_across_100_stumble;
	addNotetrack_flag( "price", "footstep_right_large", "price_jumping", "pri_bridge_jump" );	
	addNotetrack_flag( "price", "footstep_left_large", "price_jumped", "pri_bridge_jump" );	
	
	level.scr_anim[ "destroyer" ][ "shoot_bridge" ]				= %corner_standL_trans_A_2_B;

//CONTROL ROOM
	level.scr_anim[ "generic" ][ "look_idle_cornerR" ][ 0 ]		= %corner_standr_look_idle;
	level.scr_anim[ "generic" ][ "alert2look_cornerR" ]			= %corner_standr_alert_2_look;

	level.scr_anim[ "generic" ][ "breach_react_desk_v3" ]		= %breach_react_desk_v3;
	level.scr_anim[ "generic" ][ "breach_react_desk_v4" ]		= %breach_react_desk_v4;
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ]		= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ]= %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v1" ]	= %breach_react_blowback_v1;	


//AIRSTRIP
	level.scr_anim[ "nade_tosser" ][ "cqb_nade_throw" ]			= %CQB_stand_grenade_throw;
	addNotetrack_flag( "nade_tosser", "grenade_throw", "nade_tossed", "cqb_nade_throw" ); //grenade_throw //grenade_right
}

#using_animtree( "animated_props" );
animated_model_setup()
{
	level.anim_prop_models[ "foliage_desertbrush_1_animated" ][ "sway" ] = %foliage_desertbrush_1_sway;
}

#using_animtree( "dog" );
dog()
{
	level.scr_anim[ "generic" ][ "dog_idle" ][0]					= %german_shepherd_attackidle;		
	level.scr_anim[ "generic" ][ "dog_eating" ][0]					= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_eating_single" ]				= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_growling" ][0]				= %german_shepherd_attackidle_growl;	
	
	level.scr_anim[ "generic" ][ "dog_barking" ][0]					= %german_shepherd_attackidle_growl;
	level.scr_anim[ "generic" ][ "dog_barking" ][1]					= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][2]					= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][3]					= %german_shepherd_attackidle_bark;	
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_model[ "knife" ] 										= "weapon_parabolic_knife";
	
	level.scr_anim[ "chair" ][ "sleep_react" ]						= %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "chair" ] 									= #animtree;
	level.scr_model[ "chair" ] 										= "com_folding_chair";
	
	level.scr_anim[ "chair_ak" ][ "sit_load_ak_react" ]	 			= %sitting_guard_loadAK_idle_chair;
	level.scr_animtree[ "chair_ak" ] 								= #animtree;
	level.scr_model[ "chair_ak" ] 									= "com_folding_chair";
	
	level.scr_anim[ "flashlight" ][ "fl_death" ]					= %blackout_flashlightguy_death_flashlight;
	level.scr_sound[ "flashlight" ][ "fl_death" ]					= "scn_blackout_drop_flashlight";

	level.scr_anim[ "flashlight" ][ "search" ]						= %blackout_flashlightguy_moment2death_flashlight;
	level.scr_sound[ "flashlight" ][ "search" ]						= "scn_blackout_drop_flashlight_draw";
	
	level.scr_anim[ "rope" ][ "rappel_hookup" ]						= %afgan_caves_player_hookup_rope;
	level.scr_model[ "rope" ] 										= "weapon_carabiner_thin_rope";
	level.scr_animtree[ "rope" ] 									= #animtree;
	
	level.scr_anim[ "rope_price" ][ "rope_hookup" ]					= %afgan_caves_price_hookup_rope;
	level.scr_model[ "rope_price" ] 								= "weapon_carabiner_thin_rope";
	level.scr_animtree[ "rope_price" ] 								= #animtree;
	
	level.scr_anim[ "rappel_rope_price" ][ "pri_rappel_jump" ]		= %afgan_caves_Price_rappel_jump_rappelRope;
	level.scr_anim[ "rappel_rope_price" ][ "pri_hanging_idle" ][ 0 ]= %afgan_caves_Price_hanging_idle_rappelRope;
	level.scr_anim[ "rappel_rope_price" ][ "pri_rappel_idle" ][ 0 ] = %afgan_caves_Price_rappel_idle_rappelRope;
	level.scr_model[ "rappel_rope_price" ] 						 	= "afgan_caves_rappel_rope";
	level.scr_animtree[ "rappel_rope_price" ] 						= #animtree;

	level.scr_anim[ "tarp" ][ "rise_up" ]							= %scout_sniper_sand_ghillie_tarp_emerge;
	level.scr_animtree[ "tarp" ] 									= #animtree;
	level.scr_model[ "tarp" ] 										= "scout_sniper_sand_ghillie_tarp";	

// Breach door
	level.scr_anim[ "breach_door_model_caves" ][ "breach" ]	 		= %breach_player_door_v2;
	level.scr_animtree[ "breach_door_model_caves" ]					= #animtree;
	level.scr_model[ "breach_door_model_caves" ]					= "com_door_03_handleright";
	
	level.scr_anim[ "breach_door_hinge_caves" ][ "breach" ]			= %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_hinge_caves" ] 				= #animtree;
	level.scr_model[ "breach_door_hinge_caves" ] 					= "com_door_piece_hinge3";
	
// Swinging lamp
	level.scr_animtree[ "lamp" ] 									= #animtree;
	level.scr_model[ "lamp" ] 										= "ch_industrial_light_animated_01_on";
	level.scr_anim[ "lamp" ][ "swing" ] 							= %swinging_industrial_light_01_mild;
	level.scr_anim[ "lamp" ][ "swing_dup" ] 						= %swinging_industrial_light_01_mild_dup;
	
//	level.scr_animtree[ "lamp_off" ] 								= #animtree;
//	level.scr_model[ "lamp_off" ] 									= "ch_industrial_light_animated_01_off";

}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 								= #animtree;
	level.scr_model[ "player_rig" ] 								= "viewhands_player_tf141"; //viewhands_player_us_army
	level.scr_anim[ "player_rig" ][ "rappel_close" ] 				= %afgan_caves_player_rappel_close;
	level.scr_anim[ "player_rig" ][ "rappel_far" ] 					= %afgan_caves_player_rappel_far;

	level.scr_anim[ "player_rig" ][ "rappel_close_node" ] 			= %cave_rappel_close;
	level.scr_anim[ "player_rig" ][ "rappel_far_node" ] 			= %cave_rappel_far;
	level.scr_anim[ "player_rig" ][ "rappel_hookup" ] 				= %afgan_caves_player_rappel_hookup;
	
	level.scr_anim[ "player_rig" ][ "rappel_root" ] 				= %cave_rappel;	
	level.scr_anim[ "player_rig" ][ "rappel_kill" ] 				= %afgan_caves_player_rappel_end_kill;
	
	addNotetrack_customFunction( "player_rig", "start_guard", ::start_guard_anim );
}

start_guard_anim( guy )
{
	self anim_single_solo( self.guard, "rappel_kill" );
}

kill_me( guy )
{
	guy.a.nodeath = true;
	guy.allowdeath = true;
	guy.diequietly = true;
	guy kill();
}


dialog()
{
//INTRO	
	//* Price: "The sandstorm's clearing, Let's go."                                                                                    
	level.scr_radio[ "pri_stormclearing" ]				= "afcaves_pri_stormclearing";

	//* Price: "Let's see if these headsets still work."                                                                                    
	level.scr_radio[ "pri_headsetswork" ]				= "afcaves_pri_headsetswork";
	
	//* Shepherd: "Lieutenant, are your men in position?"                                                                                    
	level.scr_radio[ "shp_inposition" ]					= "afcaves_shp_inposition";

	//* Lieutenant: "Yes sir, I have eyes patroling the caynon now."                                                                                    
	level.scr_radio[ "lnt_canyon" ]						= "afcaves_lnt_canyon";



//HILLSIDE
	//* Price: "Soap, hold up."                                                                                    
	level.scr_radio[ "pri_holdup" ]						= "afcaves_pri_holdup";

	//* Price: "Enemy patrol."                                                                                    
	level.scr_radio[ "pri_enemypatrol" ]				= "afcaves_pri_enemypatrol";

	//* Price: "Take'em out."                                                                                    
	level.scr_radio[ "pri_takeemout" ]					= "afcaves_pri_takeemout";

	/*-----------------------
	HILLSIDE NAGS
	-------------------------*/

	//* Price: "Soap, over here."                                                                                    
	level.scr_radio[ "pri_overhere" ]					= "afcaves_pri_overhere";


//ROADSIDE
	//* Price: "Clear. Move."                                                                                    
	level.scr_radio[ "pri_clearmove" ]					= "afcaves_pri_clearmove";
	
	//* Price: "Sniper on the ridge!"                                                                                    
	level.scr_radio[ "pri_sniperonridge2" ]				= "afcaves_pri_sniperonridge2";

	//* Price: "Got a sniper, on the ridge to the east."                                                                                    
	level.scr_radio[ "pri_sniperridgeeast" ]			= "afcaves_pri_sniperridgeeast";

	//* Price: "Take him out."                                                                                    
	level.scr_radio[ "pri_takehimout" ]					= "afcaves_pri_takehimout";

	//* Price: "Good kill."                                                                                    
	level.scr_radio[ "pri_goodkill" ]					= "afcaves_pri_goodkill";

	//* Price: "Soap, I'm picking up a thermal spike up ahead. The cave must be somewhere over the edge"                                                                                    
	level.scr_radio[ "pri_thermalspike" ]				= "afcaves_pri_thermalspike";


//RAPPEL SETUP
	//* Price: "Here we go - hook up here."                                                                                    
	level.scr_radio[ "pri_hookup" ]						= "afcaves_pri_hookup";
	
	/*-----------------------
	RAPPEL NAGS
	-------------------------*/

	//* Price: "Soap, hook up."                                                                                    
	level.scr_radio[ "pri_soaphookup" ]					= "afcaves_pri_soaphookup";
	
	//* Price: "Soap, what's the problem? Hook up to the railing."                                                                                    
	level.scr_radio[ "pri_whatstheproblem" ]			= "afcaves_pri_whatstheproblem";
	
	//* Price: "Soap, hook up, let's go."
	level.scr_radio[ "pri_hookupletsgo" ]				= "afcaves_pri_hookupletsgo";


//RAPPEL
	//* Price: "Go."                                                                                    
	level.scr_radio[ "pri_go" ]							= "afcaves_pri_go";	
	
	//* Price: "Got two tangos down below."                                                                                    
	level.scr_radio[ "pri_2inthechest" ]				= "afcaves_pri_2inthechest";		


//BACKDOOR
	//* Price: "Soap, take point."                                                                                    
	level.scr_radio[ "pri_takepoint" ]					= "afcaves_pri_takepoint";
	
	//* Price: "Let's go."                                                                                    
	level.scr_radio[ "pri_letsgo" ]						= "afcaves_pri_letsgo";


//BACKDOOR BARRACKS
//	//* Price: "Soap let's borrow this fellows headset, it may come in usefull in locating Shepherd."                                                                                    
//	level.scr_radio[ "pri_borrowheadset" ]				= "afcaves_pri_borrowheadset";

	//* Price: "Easy now..."                                                                                    
	level.scr_radio[ "pri_easynow" ]					= "afcaves_pri_easynow";
	
	//* Price: "These guys are unaware of us and stealth is on our side for now, move slowly."                                                                                   
	level.scr_radio[ "pri_unawareofus" ]				= "afcaves_pri_unawareofus";

	//* Shadow Company 1: "What the hell are you doin'?"                                                                                    
	level.scr_radio[ "sc1_whatthe" ]					= "afcaves_sc1_whatthe";

	//* Shadow Company 2: "What?"                                                                                    
	level.scr_radio[ "sc2_what" ]						= "afcaves_sc2_what";

	//* Shadow Company 1: "I saw that. You took your hand off the piece."                                                                                    
	level.scr_radio[ "sc1_sawthat" ]					= "afcaves_sc1_sawthat";

	//* Shadow Company 2: "So?"                                                                                    
	level.scr_radio[ "sc2_so" ]							= "afcaves_sc2_so";

	//* Shadow Company 1: "So? So you can't move it again."                                                                                    
	level.scr_radio[ "sc1_cantmove" ]					= "afcaves_sc1_cantmove";

	//* Shadow Company 1: "Try to rip me off again and I'll cut your throat."                                                                                    
	level.scr_radio[ "sc1_cutyourthroat" ]				= "afcaves_sc1_cutyourthroat";

	//* Shadow Company 2: "Whatever man."                                                                                    
	level.scr_radio[ "sc2_whatever" ]					= "afcaves_sc2_whatever";

	//* Price: "Might I suggest we leave the Chess Masters be?"                                                                                  
	level.scr_radio[ "pri_leavechess" ]					= "afcaves_pri_leavechess";

	//* Price: "I suggest we quietly pass by this fellow."                                                                                 
	level.scr_radio[ "pri_quietlypassby" ]				= "afcaves_pri_quietlypassby";

	//* Price: "Stay to the left"                                                                                  
	level.scr_radio[ "pri_staytoleft" ]					= "afcaves_pri_staytoleft";

	//* Price: "Move"                                                                                  
	level.scr_radio[ "pri_move2" ]						= "afcaves_pri_move2";


//STAIRS LEADING UP TO STEAM ROOM
	//* Shadow Company 1: "Sir, we've lost contact with Alpha Team at the back door."                                                                                    
	level.scr_radio[ "sc1_lostcontact" ]				= "afcaves_sc1_lostcontact";

	//* Shadow Company 1: "We may have a problem."                                                                                    
	level.scr_radio[ "sc1_haveaprob" ]					= "afcaves_sc1_haveaprob";

//	//* Shadow Company 2: "Check out the rear entrance. Stay frosty."                                                                                    
//	level.scr_radio[ "sc2_stayfrosty" ]					= "afcaves_sc2_stayfrosty";

	//* Lieutenant: "Steam room,be advised, we're going dark."                                                                                    
	level.scr_radio[ "lnt_goingdark" ]					= "afcaves_lnt_goingdark";

	//* Shadow Company 3: "Roger, going dark."                                                                                    
	level.scr_radio[ "sc3_goingdark" ]					= "afcaves_sc3_goingdark";



//STEAM ROOM

	//* Shadow Company 1: "Careful now."                                                                                  
	level.scr_radio[ "pri_carefulnow" ]					= "afcaves_pri_carefulnow";

//	//* Shadow Company 1: "It's reeks of an ambush in here"                                                                                 
//	level.scr_radio[ "pri_reeksofambush" ]				= "afcaves_pri_reeksofambush";

	//* Price: "Soap, go to night vision. "                                                                                    
	level.scr_radio[ "pri_nightvision" ]				= "afcaves_pri_nightvision";

	//* Shadow Company Leader: "Heh heh. All too easy. Take 'em!"                                                                                    
	level.scr_radio[ "scl_alltooeasy" ]					= "afcaves_scl_alltooeasy";

	//* Shadow Company 2: "Roger engaging!"                                                                                    
	level.scr_radio[ "sc2_engaging" ]					= "afcaves_sc2_engaging";

//	//* Shadow Company Leader: "L - T - move - in!"                                                                                    
//	level.scr_radio[ "scl_ltmovein" ]					= "afcaves_scl_ltmovein";

//	//* Shadow Company 2: "Mo-ving in!!!"                                                                                    
//	level.scr_radio[ "sc2_movingin" ]					= "afcaves_sc2_movingin";

	//* Shadow Company Leader: "Gunner! Move - in!"                                                                                    
	level.scr_radio[ "scl_gunnermovein" ]				= "afcaves_scl_gunnermovein";

	//* Shadow Company 3: "Roger, gonna kick some ass."                                                                                    
	level.scr_radio[ "sc3_kicksome" ]					= "afcaves_sc3_kicksome";

	//* Shadow Company Leader: "Move in."                                                                                    
	level.scr_radio[ "scl_movein" ]						= "afcaves_scl_movein";

	//* Shadow Company 3: "Heh heh…let's show these SAS punks how it's really done."                                                                                    
	level.scr_radio[ "sc3_saspunks" ]					= "afcaves_sc3_saspunks";

	//* Lieutenant: "Sir, I believe MacTavish has infiltrated our base and is making his way through the steam room."                                                                                    
	level.scr_radio[ "lnt_infiltratedbase" ]			= "afcaves_lnt_infiltratedbase";

	//* Shepherd: "Blow the cave."                                                                                    
	level.scr_radio[ "shp_blowthecaves" ]				= "afcaves_shp_blowthecaves";

	//* Lieutenant: "Sir, we still have men in there…"                                                                                    
	level.scr_radio[ "lnt_meninthere" ]					= "afcaves_lnt_meninthere";

	//* Shepherd: "Blow the cave Lieutenant!"                                                                                    
	level.scr_radio[ "shp_blowcavelt" ]					= "afcaves_shp_blowcavelt";

	//* Lieutenant: "Yes sir."                                                                                    
	level.scr_radio[ "lnt_yessir1" ]					= "afcaves_lnt_yessir1";

	//* Price: "We gotta move Soap, RUN!"                                                                                    
	level.scr_radio[ "pri_gottamoverun" ]				= "afcaves_pri_gottamoverun";



//LEDGE
	//* Lieutenant: "Sir, MacTavish is headed for the bridge."                                                                                    
	level.scr_radio[ "lnt_headedforbridge" ]			= "afcaves_lnt_headedforbridge";

	//* Shepherd: "Do not let him make it across the bridge."                                                                                    
	level.scr_radio[ "shp_acrossthebridge" ]			= "afcaves_shp_acrossthebridge";

	//* Price: "Get Down!"                                                                                    
	level.scr_radio[ "pri_getdown" ]					= "afcaves_pri_getdown";

	//* Shepherd: "Take out that bridge if you have to!"                                                                                    
	level.scr_radio[ "shp_takeoutbridge" ]				= "afcaves_shp_takeoutbridge";

//	//* Price: "RPGs, take'em out!."                                                                                    
//	level.scr_radio[ "pri_rpgs" ]						= "afcaves_pri_rpgs";

//	//* Price: "Bloody bastards! I don’t know which I hate more, dogs or those RPGs…"                                                                                    
//	level.scr_radio[ "pri_sniper12" ]					= "afcaves_pri_sniper12";


//OVERLOOK
	//* Shadow Company 3: "Enemy sighted in sector six! Moving in!"                                                                                    
	level.scr_radio[ "sc3_sectorsix" ]					= "afcaves_sc3_sectorsix";

	//* Shadow Company 2: "Flank 'em! Go go go!."                                                                                    
	level.scr_radio[ "sc2_flankem" ]					= "afcaves_sc2_flankem";

	//* Lieutenant: "Sir, MacTavish is getting too close."                                                                                    
	level.scr_radio[ "lnt_tooclose" ]					= "afcaves_lnt_tooclose";

	//* Lieutenant: "Recommend you move to the safety of the command center, sir."                                                                                    
	level.scr_radio[ "lnt_commandcenter" ]				= "afcaves_lnt_commandcenter";

	//* Shepherd: "On my way."                                                                                    
	level.scr_radio[ "shp_onmyway" ]					= "afcaves_shp_onmyway";



//CAVERN
	//* Price: "We gotta take out those sentry guns!"                                                                                    
	level.scr_radio[ "pri_takeoutsentry" ]				= "afcaves_pri_takeoutsentry";

	//* Price: "I got a visual on Shepherd! He's getting away! Head for that door to the northwest! Go! Go!"                                                                                    
	level.scr_radio[ "pri_gettingaway" ]				= "afcaves_pri_gettingaway";
	
	//* Shadow Company 2: "We're gonna tear you a new one MacTavish…"                                                                                    
	level.scr_radio[ "sc2_tearyou" ]					= "afcaves_sc2_tearyou";

	//* Price: "Soap, get in position to breach!"                                                                                    
	level.scr_radio[ "pri_positiontobreach" ]			= "afcaves_pri_positiontobreach";

	//* Price: "Do it."                                                                                    
	level.scr_radio[ "pri_doit" ]						= "afcaves_pri_doit";


//CONTROL ROOM
	//* Shepherd: "Lieutenant, have your men rendezvous with me at the airstrip."                                                                                    
	level.scr_radio[ "shp_rendevous" ]					= "afcaves_shp_rendevous";

	//* Lieutenant: "Yes sir."                                                                                    
	level.scr_radio[ "lnt_yessir2" ]					= "afcaves_lnt_yessir2";

	//* Shadow Company 3: "You guys just don't know when to quit do ya!"                                                                                    
	level.scr_radio[ "sc3_whentoquit" ]					= "afcaves_sc3_whentoquit";


//AIRSTRIP
	//* Shepherd: "Have your men stay with me."                                                                                    
	level.scr_radio[ "shp_menstaywithme" ]				= "afcaves_shp_menstaywithme";

	//* Shepherd: "Leave two squads to cover the entrance."                                                                                    
	level.scr_radio[ "shp_twosquads" ]					= "afcaves_shp_twosquads";

	//* Lieutenant: "Yes sir!."                                                                                    
	level.scr_radio[ "lnt_yessir3" ]					= "afcaves_lnt_yessir3";

	//* Price: "There he is! He's gone into the tunnel to the southwest!"                                                                                    
	level.scr_radio[ "pri_intothetunnel" ]				= "afcaves_pri_intothetunnel";
	
	//* Shepherd: "Call in some air support!"                                                                                    
	level.scr_radio[ "shp_airsupport" ]					= "afcaves_shp_airsupport";

	//* Lieutenant: "Little Bird inbound now."                                                                                    
	level.scr_radio[ "lnt_littlebirdinbound" ]			= "afcaves_lnt_littlebirdinbound";
	
	//* Price: 	Heads up Soap! Helicopter coming in fast from the west!                                                                                   
	level.scr_radio[ "pri_gonnagetaway" ]				= "afcaves_pri_gonnagetaway";
	
	//* Price: "Take out that helicopter!!"                                                                                    
	level.scr_radio[ "pri_takeoutheli" ]				= "afcaves_pri_takeoutheli";

	//* Price: "Soap, regroup on me! He went through this tunnel, let's go!"                                                                                    
	level.scr_radio[ "pri_regrouponme" ]				= "afcaves_pri_regrouponme";
	
//	//* Price: "Remember - we're not here to take Sheppard alive. Two in the chest, one in the head"                                                                                    
//	level.scr_radio[ "pri_nothereto" ]					= "afcaves_pri_nothereto";

	/*-----------------------
	AIRSTRIP NAGS
	-------------------------*/
	
	//* Price: "Keep moving!"                                                                                    
	level.scr_radio[ "pri_keepmoving" ]					= "afcaves_pri_keepmoving";

	//* Price: "Move up!"                                                                                    
	level.scr_radio[ "pri_moveup1" ]					= "afcaves_pri_moveup1";


//MISC DIALOGUE
	//* Price: "Bloody hell this place is unstable!"                                                                                    
	level.scr_radio[ "pri_unstable" ]					= "afcaves_pri_unstable";
	
	//* Price: "Soap, pick your shots carefully - we don't want this cave to come down on us!"                                                                                    
	level.scr_radio[ "pri_pickcarefully" ]				= "afcaves_pri_pickcarefully";

	//* Shadow Company 2: Site Hotel Bravo has been compromised! Go to full alert, I repeat go to full alert!"                                                                                    
	level.scr_radio[ "sc2_fullalert" ]					= "afcaves_sc2_fullalert";
	
	//* Shadow Company 2: "So much for stealth"                                                                                  
	level.scr_radio[ "pri_somuch" ]						= "afcaves_pri_somuch";

//	//* Shadow Company 1: "We have a security breach! Go go go!."                                                                                    
//	level.scr_radio[ "sc1_securitybreach" ]				= "afcaves_sc1_securitybreach";

	//* Price: "Move!"                                                                                  
	level.scr_radio[ "pri_move" ]						= "afcaves_pri_move";
	
	//* Price: "Good kill"                                                                                    
	level.scr_radio[ "pri_goodkill" ]					= "afcaves_pri_goodkill";
	
	//* Price: "Watch our flanks."                                                                                    
	level.scr_radio[ "pri_watchourflanks" ]				= "afcaves_pri_watchourflanks";

//	//* Price: "Tango down."                                                                                    
//	level.scr_radio[ "pri_tangodown" ]					= "afcaves_pri_tangodown";

//	//* Price: "Got one"                                                                                    
//	level.scr_radio[ "pri_gotone" ]						= "afcaves_pri_gotone";

//	//* Price: "Tango neutralized."                                                                                    
//	level.scr_radio[ "pri_tangoneutralized" ]			= "afcaves_pri_tangoneutralized";

//	//* Price: "He's down."                                                                                    
//	level.scr_radio[ "pri_hesdown" ]					= "afcaves_pri_hesdown";

//	//* Price: "Good night."                                                                                    
//	level.scr_radio[ "pri_goodnight" ]					= "afcaves_pri_goodnight";

}
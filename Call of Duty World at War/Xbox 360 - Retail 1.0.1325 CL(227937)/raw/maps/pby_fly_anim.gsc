// Animation Level File
#include maps\_anim;

main()
{
	anim_loader();
	player_anim_loader();
	dialogue_loader();
	vehicle_anims();
}

#using_animtree("generic_human");

anim_loader()
{
	
	//-- Shark
	level.scr_anim[ "shark" ][ "idle" ][0] = %ch_pby_shark_swim;
	
	//-- SETUP ANIMS AND ANIM/DIALOGUE COMBOS
	level.scr_anim[ "survivor" ][ "rescue_fall_left" ] 		= %ch_pby_Lsaved_soldier5_fall;
	level.scr_anim[ "survivor" ][ "rescue_in_left" ] 			= %ch_pby_Lsaved_soldier5_in;
	level.scr_anim[ "survivor" ][ "rescue_loop_left" ] 		= %ch_pby_Lsaved_soldier5_loop;
	level.scr_anim[ "survivor" ][ "rescue_over_left" ] 		= %ch_pby_Lsaved_soldier5_over;
	
	level.scr_anim[ "survivor" ][ "rescue_fall_right" ] 	= %ch_pby_Rsaved_soldier5_fall;
	level.scr_anim[ "survivor" ][ "rescue_in_right" ] 		= %ch_pby_Rsaved_soldier5_in;
	level.scr_anim[ "survivor" ][ "rescue_loop_right" ] 	= %ch_pby_Rsaved_soldier5_loop;
	level.scr_anim[ "survivor" ][ "rescue_over_right" ] 	= %ch_pby_Rsaved_soldier5_over;
	
	//level.scr_anim["survivor"]["float"] = %ch_pby_floating_soldier;
	level.scr_anim["survivor"]["dead"] = %ch_pby_float_dead;
	level.scr_anim["survivor"]["float_0"] = %ch_pby_float1;
	level.scr_anim["survivor"]["float_1"] = %ch_pby_float2;
	level.scr_anim["survivor"]["float_2"] = %ch_pby_float3;
	level.scr_anim["survivor"]["float_3"] = %ch_pby_float4;
	level.scr_anim["survivor"]["wave_0"] = %ch_pby_wave;
	level.scr_anim["survivor"]["wave_1"] = %ch_pby_wave2;
	level.scr_anim["survivor"]["wave_2"] = %ch_pby_wave3;
	level.scr_anim["survivor"]["wave_3"] = %ch_pby_wave4;
	
	
	//level.scr_anim["survivor"]["swim"] = %ch_pby_swimming_soldier;
	level.scr_anim["survivor"]["swim_med"][0] = %ch_pby_swim_breaststroke;
	level.scr_anim["survivor"]["swim_med"][1] = %ch_pby_swim_side1;
	level.scr_anim["survivor"]["swim_med"][2] = %ch_pby_swim_side2;
	level.scr_anim["survivor"]["swim_far"][0] = %ch_pby_swim_freestyle_hi; //%ch_pby_swim_freestyle_flail;
	level.scr_anim["survivor"]["swim_far"][1] = %ch_pby_swim_freestyle_hi;
	level.scr_anim["survivor"]["swim_far"][2] = %ch_pby_swim_freestyle_hi; //%ch_pby_swim_freestyle_lo;
	level.scr_anim["survivor"]["swim_far"][3] = %ch_pby_swim_freestyle_hi; //%ch_pby_swim_freestyle_mid;
	
	level.scr_anim["survivor"]["shark"] = %ch_pby_shark;
	level.scr_anim["survivor"]["duck"] = %ch_pby_duck;
		
	level.scr_anim["copilot"]["my_idle"][0] 	= %ch_pby_copilot;
	level.scr_anim["engineer"]["my_idle"][0] = %ch_pby_engineer;
	level.scr_anim["pilot"]["my_idle"][0] 		= %ch_pby_pilot;
	
	
	level.scr_anim["rescue_a_1"]["my_idle"][0] = %ch_pby_rescueR_1;
	level.scr_anim["rescue_a_1"]["my_idle"][1] = %ch_pby_rescueR_2;
	level.scr_anim["rescue_a_1"]["my_idle"][2] = %ch_pby_rescueR_3;
	
	level.scr_anim["rescue_a_2"]["my_idle"][0] = %ch_pby_rescueR_4;
	level.scr_anim["rescue_a_2"]["my_idle"][1] = %ch_pby_rescueR_5;
	level.scr_anim["rescue_a_2"]["my_idle"][2] = %ch_pby_rescueR_6;
	
	level.scr_anim["rescue_a_3"]["my_idle"][0] = %ch_pby_rescueL_1;
	level.scr_anim["rescue_a_3"]["my_idle"][1] = %ch_pby_rescueL_2;
	level.scr_anim["rescue_a_3"]["my_idle"][2] = %ch_pby_rescueL_3;
	
	level.scr_anim["rescue_a_4"]["my_idle"][0] = %ch_pby_rescueL_4;
	level.scr_anim["rescue_a_4"]["my_idle"][1] = %ch_pby_rescueL_5;
	level.scr_anim["rescue_a_4"]["my_idle"][2] = %ch_pby_rescueL_6;
	
	level.scr_anim["rescue_a_1"]["whoops"] = %ch_pby_crash_man;
	
	//-- ALL OF THE RADIO OPS ANIMS
	level.scr_anim["radio_op"]["my_idle_nav"][0] = %ch_pby_nav_idle;
	level.scr_anim["radio_op"]["my_idle_rad"][0] = %ch_pby_radio_lo_idle3;
	
	level.scr_anim["radio_op"]["player_f_nav"] = %ch_pby_nav_playerF;
	level.scr_anim["radio_op"]["player_r_nav"] = %ch_pby_nav_playerR;
	level.scr_anim["radio_op"]["player_f_rad"] = %ch_pby_radio_playerF;
	
	level.scr_anim["radio_op"]["nav_to_rad"] = %ch_pby_nav_to_radio;
	level.scr_anim["radio_op"]["rad_to_nav"] = %ch_pby_radio_to_nav;
	
	level.scr_anim["radio_op"]["scripted"]	 = %ch_pby_radio_scripted;
	
	//-- ALL OF THE ENGINEER ANIMS
	//level.scr_anim["engineer"]["cook"][0]			= %ch_pby_engineer_cook;
	//level.scr_anim["engineer"]["legs1"] 		= %ch_pby_engineer_legs1;
	//level.scr_anim["engineer"]["legs2"] 		= %ch_pby_engineer_legs2;
	//level.scr_anim["engineer"]["legs3"] 		= %ch_pby_engineer_legs3;
	//level.scr_anim["engineer"]["player_f"]	= %ch_pby_engineer_playerF;
	//level.scr_anim["engineer"]["player_r"] 	= %ch_pby_engineer_PlayerR;
	
	//-- PTBoat Driver
	level.scr_anim["ptboatdriver"]["idle"] = %ch_pby_ptboat_gunner;
	
	//-- so that drones can be mounted on the triple 25s
	level.scr_anim[ "triple25_gunner1" ][ "fire_loop" ][ 0 ]	= %crew_flak1_tag2_fire_1;
	level.scr_anim[ "triple25_gunner2" ][ "fire_loop" ][ 0 ]	= %crew_flak1_tag2_fire_1;
	
	//-- Right to Front transition during Merchant Ship Sec3tion
	level.scr_anim["copilot"]["RtoF"] 	=	%ch_pby_RtoF_copilot;
	level.scr_anim["pilot"]["RtoF"]			= %ch_pby_RtoF_pilot;
	level.scr_anim["radio_op"]["RtoF"]	= %ch_pby_RtoF_radio;
	//level.scr_anim["engineer"]["RtoF"]  = %ch_pby_RtoF_eng;
	
	//-- Front to Ventral transition during Merchant Ship Sec3tion
	level.scr_anim["copilot"]["FtoV"] 	=	%ch_pby_FtoV_copilot;
	level.scr_anim["pilot"]["FtoV"]			= %ch_pby_FtoV_pilot;
	level.scr_anim["radio_op"]["FtoV"]	= %ch_pby_FtoV_radio;
	//level.scr_anim["engineer"]["FtoV"]  = %ch_pby_FtoV_eng;
	
	//-- Front to Left transition during Merchant Ship Section
	level.scr_anim["copilot"]["FtoL"] 	=	%ch_pby_FtoL_copilot;
	level.scr_anim["pilot"]["FtoL"]			= %ch_pby_FtoL_pilot;
	level.scr_anim["radio_op"]["FtoL"]	= %ch_pby_FtoL_radio;
	//level.scr_anim["engineer"]["FtoL"]  = %ch_pby_FtoL_eng;
	
	//-- Distress call incoming
	level.scr_anim["copilot"]["distress"] 	=	%ch_pby_distress_copilot;
	level.scr_anim["pilot"]["distress"]			= %ch_pby_distress_pilot;
	level.scr_anim["radio_op"]["distress"]	= %ch_pby_distress_radio;
	//level.scr_anim["engineer"]["distress"]  = %ch_pby_distress_eng;
	
	//-- More distress call
	level.scr_anim["radio_op"]["distress2"] = %ch_pby_distress_radio2;
	
	//-- Gunner animations
	level.scr_anim["engineer"]["firel"] =			%ch_pby_gunner_firel;
	level.scr_anim["engineer"]["firelloop"][0] = %ch_pby_gunner_firel;
	level.scr_anim["engineer"]["firev"][0] =  %ch_pby_gunner_firev;
	level.scr_anim["engineer"]["ftol"] 	=			%ch_pby_gunner_ftol;
	level.scr_anim["engineer"]["ftor"] 	=			%ch_pby_gunner_ftor;
	level.scr_anim["engineer"]["look"] 	=			%ch_pby_gunner_look;
	level.scr_anim["engineer"]["look_loop"][0] = %ch_pby_gunner_look;
	level.scr_anim["engineer"]["ltof"] 	=			%ch_pby_gunner_ltof;
	level.scr_anim["engineer"]["ltor"] 	=			%ch_pby_gunner_ltor;
	level.scr_anim["engineer"]["ltov"] 	=			%ch_pby_gunner_ltov;
	level.scr_anim["engineer"]["nod"] 	=			%ch_pby_gunner_nod;
	level.scr_anim["engineer"]["pass"] 	=			%ch_pby_gunner_pass;
	level.scr_anim["engineer"]["pass2"] =			%ch_pby_gunner_pass2;
	level.scr_anim["engineer"]["vtof"] 	=			%ch_pby_gunner_vtof;
	
	
	//-- Intro Scene ----------------------------------------------------------------------------------------------------------
	level.scr_anim["copilot"]["intro_vig"]	= %ch_pby_intro_copilot;
	addNotetrack_dialogue( "copilot", "co_pilot", "intro_vig", "Pby1_INT_103A_PLT1"); // "don't think that will be an issue today"
	addNotetrack_customFunction( "copilot", "second_pilot", maps\pby_fly::second_pilot_reply_intro, "intro_vig"); // (plane_b pilot_reply)
	addNotetrack_dialogue( "copilot", "co_pilot", "intro_vig", "Pby1_INT_005A_PLT1"); // "well, engagement doesn't seem likely..."
		
	level.scr_anim["radio_op"]["intro_vig"] = %ch_pby_intro_radio;
	addNotetrack_dialogue( "radio_op", "radio_op", "intro_vig", "Pby1_INT_100A_RADO"); // "what do you think..."
	addNotetrack_dialogue( "radio_op", "radio_op", "intro_vig", "Pby1_INT_101A_RADO"); // "pretty sweet, huh?"
	addNotetrack_dialogue( "radio_op", "radio_op", "intro_vig", "Pby1_INT_102A_RADO"); // "paint this sweetheart on our bird..."
	addNoteTrack_customFunction( "radio_op", "second_gunner", maps\pby_fly::second_gunner_reply_intro, "intro_vig");  // (gunner reply)
	addNoteTrack_dialogue( "radio_op", "radio_op", "intro_vig", "Pby1_INT_003A_RADO"); // "pay no heed..."
	addNoteTrack_dialogue( "radio_op", "radio_op", "intro_vig", "Pby1_INT_004A_RADO"); // "that was a joke" beat "..."
	//addNoteTrack_customFunction( "radio_op", "engineer", maps\pby_fly::intro_move_engineer_climb, "intro_vig");
	addNoteTrack_customFunction( "radio_op", "player", maps\pby_fly::intro_move_player_to_rear, "intro_vig");
	addNoteTrack_attach( "radio_op", "attach", "prop_pby_pinup", "tag_weapon_right", "intro_vig");
	addNoteTrack_detach( "radio_op", "detach", "prop_pby_pinup", "tag_weapon_right", "intro_vig");
			
	//level.scr_anim["engineer"]["intro_vig_loop"][0] = %ch_pby_intro_engineer_loop;
	//level.scr_anim["engineer"]["intro_vig_up"] = %ch_pby_intro_engineer_up;
}

dialogue_loader()
{
	//-- SETUP DIALOG ONLY!!!
	
	//level.scr_sound["char animname"]["animname"] = "print:dialogue";
	
	//-- INTRO ------------------------------------------------------------------
	//level.scr_sound["pilot"]["intro_b"] 			= "PBY1_INT_000A_PLT2";
	//level.scr_sound["pilot"]["intro_a"]				= "PBY1_INT_001A_PLT1";
	//level.scr_sound["radio_op"]["intro_b"] 		= "PBY1_INT_002A_GUN2";
	//level.scr_sound["radio_op"]["intro_a"] 		= "PBY1_INT_003A_RADO"; //fire shots
	//level.scr_sound["radio_op"]["intro_a2"]		= "PBY1_INT_004A_RADO"; //joke
	//level.scr_sound["pilot"]["intro_a2"]			= "PBY1_INT_005A_PLT1";
	//level.scr_sound["radio_op"]["intro_a3"]		= "PBY1_INT_006A_RADO";
	
	//-- Half Intro
	//-- HARRINGTON: Booth Comin' up over them now
	level.scr_sound["pilot"]["booth_yeah_i_see_em"] 							= "PBY1_INT_001A_BOOT";
	level.scr_sound["pilot"]["booth_major_gordon_vessels_now"] 		= "PBY1_INT_002A_BOOT";
	level.scr_sound["pilot"]["booth_unmarked_japanese_merchant"] 	= "PBY1_INT_003A_BOOT";
	//-- MAJG LINE: "probably resupplying enemy"
	level.scr_sound["pilot"]["booth_legitimate_targets"] 					= "PBY1_INT_005A_BOOT";
	//-- MAJG LINE: "affirmative"
	//-- MAJG LINE: "Permission to engage"
	level.scr_sound["pilot"]["booth_roger_that"] 									= "PBY1_INT_008A_BOOT";
	level.scr_sound["pilot"]["booth_laughlin_locke_get_to"] 			= "PBY1_INT_009A_BOOT";
	level.scr_sound["pilot"]["booth_open_fire"]										= "PBY1_IGD_000A_BOOT";
	
	level.scr_sound["pilot"]["booth_locke_get_your_thumb"]				= "PBY1_INT_010A_BOOT";
	
	level.scr_sound["pilot"]["booth_coming_over_them_get_rear"]		= "PBY1_IGD_536A_BOOT";
	
	//-- HARRINGTON: We got infantry on deck...
	//-- LAUGHLIN: Take 'em out!
		
	level.scr_sound["pilot"]["booth_going_in_for_another_run"]		= "PBY1_IGD_023A_BOOT";
	//-- HARRINGTON: Echo That
	
	//-- HARRINGTON: DAMMIT!!! Taking Fire!!!
	//-- LAUGHLIN: What the fuck are merchantships doing with that much firepower?!
	level.scr_sound["pilot"]["booth_taking_evasive_action_hold"]  = "PBY1_IGD_028A_BOOT";
	
	level.scr_sound["pilot"]["booth_damn_that_was_close"]     		= "PBY1_IGD_040A_BOOT";
	level.scr_sound["pilot"]["booth_shit_tell_me_weve_not_lost"]  = "PBY1_IGD_041A_BOOT";
	level.scr_sound["radio_op"]["landry_hes_okay"]								= "PBY1_IGD_042A_LAND";
	//-- LAUGHLIN: SHIT!!! ANYONE SEE FUCKING FLAK GUNS ON THAT FIRST PASS? PBY1_IGD_043A_LAUG
	level.scr_sound["pilot"]["booth_that_must_be_some_important"]	= "PBY1_IGD_044A_BOOT";
	
	//-- LAUGHLIN: We need to get below the flak
	level.scr_sound["pilot"]["booth_i_hear_you"]									= "PBY1_IGD_046A_BOOT";
	//-- LAUGHLIN: I can't line up a decent shot
	
	
	// PTBOAT STUFF
	level.scr_sound["pilot"]["booth_mg_fire_all_around"]					= "PBY1_IGD_031A_BOOT";
	level.scr_sound["pilot"]["booth_keep_firing_on_those"] 				= "PBY1_IGD_032A_BOOT";
	level.scr_sound["pilot"]["booth_theyre_our_biggest_threat"] 	= "PBY1_IGD_033A_BOOT";
	//-- HARRINGTON: This is getting too risky!!
	//-- HARRINGTON: Should we Abort"
	level.scr_sound["pilot"]["booth_negative_we_can_do_this"]			= "PBY1_IGD_036A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_taking_her_down_low"]					= "PBY1_IGD_048A_BOOT";
	level.scr_sound["pilot"]["booth_locke_laughlin_keep_on_them"]	= "PBY1_IGD_006A_BOOT";
	level.scr_sound["pilot"]["booth_shoot_out_those_damn_spot"]		= "PBY1_IGD_013A_BOOT";
	
	level.scr_sound["pilot"]["booth_japanese_pt_boats"]						= "PBY1_IGD_500A_BOOT";
	level.scr_sound["pilot"]["booth_get_on_left_turret"]					= "PBY1_IGD_525A_BOOT";
	
	//-- HARRINGTON: Come here you little, shit!
	
	level.scr_sound["pilot"]["booth_pick_your_targets_locke"]			= "PBY1_IGD_008A_BOOT";
	
	//-- HARRINGTON: Shit.  I think we disabled them, but they're still afloat
	
	level.scr_sound["pilot"]["booth_ill_take_us_as_close"]				= "PBY1_IGD_049A_BOOT";
	
	
	
	//-- HARRINGTON: I think we got'em all.
	//-- LAUGHLIN: Oh yeah....  They're going down
	level.scr_sound["pilot"]["booth_good_work_locke_youve_saved"]	= "PBY1_IGD_055A_BOOT";
	level.scr_sound["pilot"]["booth_were_done_here"]							= "PBY1_IGD_058A_BOOT";
	level.scr_sound["pilot"]["booth_get_some_altitude"]						= "PBY1_IGD_059A_BOOT";
	//-- HARRINGTON: Echo that
	
	
	//-- HARRINGTON: We got pretty roughed up on that last run, Booth.
	level.scr_sound["radio_op"]["landry_confirmed_harrington"] 					= "PBY1_IGD_062B_LAND"; //-- ALT Line
	//-- HARRINGTON: Guages ain't hitting red... We should be able to hold her...
	level.scr_sound["radio_op"]["landry_oh_hell"] 													= "PBY1_IGD_064A_LAND";
	level.scr_sound["radio_op"]["landry_captain_harrington_distress_call"] 	= "PBY1_IGD_065B_LAND"; //-- ALT Line
	level.scr_sound["radio_op"]["landry_theyve_called_for_air_support"] 		= "PBY1_IGD_066A_LAND";
	level.scr_sound["radio_op"]["landry_atleast_one_infantry"]							= "PBY1_IGD_406A_LAND"; //-- ALT line
	level.scr_face["radio_op"]["landry_atleast_one_infantry_TEMP"]								= 	%ch_pby_distress_radio_face1;
	level.scr_sound["radio_op"]["landry_they_have_men_in_the_water"]				= "PBY1_IGD_067A_LAND";
	level.scr_face["radio_op"]["landry_they_have_men_in_the_water_TEMP"]				= 	%ch_pby_distress_radio_face2;
	level.scr_sound["pilot"]["booth_okay_locke_seal"]												= "PBY1_IGD_068A_BOOT";
	level.scr_sound["pilot"]["booth_lets_go_get_our_men"]										= "PBY1_IGD_069A_BOOT";
	//-- HARRINGTON: Shit! You hear that?
	level.scr_sound["pilot"]["booth_zeroes_right_below"]										= "PBY1_IGD_071A_BOOT";
	level.scr_sound["pilot"]["booth_shit_take_down_as_many"]								= "PBY1_IGD_073A_BOOT";
	level.scr_sound["pilot"]["booth_get_firing_locke"]											= "PBY1_IGD_072A_BOOT";
	level.scr_sound["pilot"]["booth_radio_the_fleet"]												= "PBY1_IGD_074A_BOOT";

	level.scr_sound["pilot"]["booth_weve_got_zeros_coming_in_fast"]					= "PBY1_IGD_508A_BOOT";
	level.scr_sound["pilot"]["booth_more_damn_zeroes"]											= "PBY1_IGD_509A_BOOT";
	
	level.scr_sound["pilot"]["booth_12_oclock"]															= "PBY1_IGD_510A_BOOT";
	level.scr_sound["pilot"]["booth_1_oclock"]															= "PBY1_IGD_511A_BOOT";
	level.scr_sound["pilot"]["booth_2_oclock"]															= "PBY1_IGD_512A_BOOT";
	level.scr_sound["pilot"]["booth_3_oclock"]															= "PBY1_IGD_513A_BOOT";
	level.scr_sound["pilot"]["booth_4_oclock"]															= "PBY1_IGD_514A_BOOT";
	level.scr_sound["pilot"]["booth_5_oclock"]															= "PBY1_IGD_515A_BOOT";
	level.scr_sound["pilot"]["booth_6_oclock"]															= "PBY1_IGD_516A_BOOT";
	level.scr_sound["pilot"]["booth_7_oclock"]															= "PBY1_IGD_517A_BOOT";
	level.scr_sound["pilot"]["booth_8_oclock"]															= "PBY1_IGD_518A_BOOT";
	level.scr_sound["pilot"]["booth_9_oclock"]															= "PBY1_IGD_519A_BOOT";
	level.scr_sound["pilot"]["booth_10_oclock"]															= "PBY1_IGD_520A_BOOT";
	level.scr_sound["pilot"]["booth_11_oclock"]															= "PBY1_IGD_521A_BOOT";
	level.scr_sound["pilot"]["booth_high"]																	= "PBY1_IGD_550A_BOOT";
	level.scr_sound["pilot"]["booth_low"]																		= "PBY1_IGD_551A_BOOT";

	level.scr_sound["laughlin"]["12_oclock"]														= "PBY1_IGD_552A_LAUG";
	level.scr_sound["laughlin"]["1_oclock"]															= "PBY1_IGD_553A_LAUG";
	level.scr_sound["laughlin"]["2_oclock"]															= "PBY1_IGD_554A_LAUG";
	level.scr_sound["laughlin"]["3_oclock"]															= "PBY1_IGD_555A_LAUG";
	level.scr_sound["laughlin"]["4_oclock"]															= "PBY1_IGD_556A_LAUG";
	level.scr_sound["laughlin"]["5_oclock"]															= "PBY1_IGD_557A_LAUG";
	level.scr_sound["laughlin"]["6_oclock"]															= "PBY1_IGD_558A_LAUG";
	level.scr_sound["laughlin"]["7_oclock"]															= "PBY1_IGD_559A_LAUG";
	level.scr_sound["laughlin"]["8_oclock"]															= "PBY1_IGD_560A_LAUG";
	level.scr_sound["laughlin"]["9_oclock"]															= "PBY1_IGD_561A_LAUG";
	level.scr_sound["laughlin"]["10_oclock"]														= "PBY1_IGD_562A_LAUG";
	level.scr_sound["laughlin"]["11_oclock"]														= "PBY1_IGD_563A_LAUG";
	level.scr_sound["laughlin"]["high"]																	= "PBY1_IGD_564A_LAUG";
	level.scr_sound["laughlin"]["low"]																	= "PBY1_IGD_565A_LAUG";
	level.scr_sound["laughlin"]["sons_of_bitches"]											= "PBY1_IGD_504A_LAUG";
	

	//-- HARRINGTON: We're hit!
	level.scr_sound["pilot"]["booth_your_number_two_engine_is"]							= "PBY1_IGD_076A_BOOT";
	//-- HARRINGTON: I am trying!... The controls are shot to Hell
	level.scr_sound["pilot"]["booth_hold_it_together"]											= "PBY1_IGD_078A_BOOT";
	//-- HARRINGTON: Mayday! Mayday! We are going down...
	level.scr_sound["pilot"]["booth_HARRINGTON"]														= "PBY1_IGD_080A_BOOT";
	level.scr_sound["pilot"]["booth_damnit_we_lost_cheshire"]								= "PBY1_IGD_310A_BOOT";
	level.scr_sound["pilot"]["were_on_our_own"]															= "PBY1_IGD_311A_BOOT";
	
	level.scr_sound["pilot"]["booth_okay_people_the_fleet_needs"]						= "PBY1_IGD_081A_BOOT";
	level.scr_sound["pilot"]["booth_anyone_want_to_back_out"]								= "PBY1_IGD_082A_BOOT";
	level.scr_sound["pilot"]["booth_didnt_think_so"]												= "PBY1_IGD_083A_BOOT";
	level.scr_sound["pilot"]["booth_were_going_into_a_hotzone"]							= "PBY1_IGD_084A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_bastards_wiped_out_most"]								= "PBY1_IGD_085A_BOOT";
	//-- LAUGHLIN: Holy shit... Do you think anyone's gonna be alive down there?
	level.scr_sound["pilot"]["booth_i_see_multiple_casualties"]							= "PBY1_IGD_087A_BOOT";
	//-- LAUGHLIN: Shit... Poor Bastards...
	level.scr_sound["radio_op"]["landry_we_better_not_be_the_only"]					= "PBY1_IGD_089A_LAND";
	level.scr_sound["pilot"]["booth_well_do_what_we_can"]										= "PBY1_IGD_090A_BOOT";
	level.scr_sound["pilot"]["booth_locke_be_ready_to"]											= "PBY1_IGD_091A_BOOT";
	level.scr_sound["pilot"]["booth_well_bring_em_home"]										= "PBY1_IGD_092A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_incoming_right_side"]										= "PBY1_IGD_096A_BOOT";
	level.scr_sound["radio_op"]["landry_sink_thos_damn_ptboats"]						= "PBY1_IGD_095A_LAND";
	
	
	level.scr_sound["radio_op"]["landry_this_is_blackcat"]										= "PBY1_IGD_132D_LAND"; //ALT LINE
	level.scr_sound["radio_op"]["landry_the_fleet_is_down"]										= "PBY1_IGD_133A_LAND";
	level.scr_sound["radio_op"]["landry_we_have_multiple"]										= "PBY1_IGD_134A_LAND";
	level.scr_sound["radio_op"]["landry_taking_heavy_fire"]										= "PBY1_IGD_135A_LAND";
	level.scr_sound["radio_op"]["landry_requesting_immediate"]								= "PBY1_IGD_136A_LAND";
	level.scr_sound["pilot"]["booth_landry_any_word_on_that"]									= "PBY1_IGD_137A_BOOT";
	level.scr_sound["radio_op"]["landry_im_getting_nothing_on"]								= "PBY1_IGD_138A_LAND";
	level.scr_sound["pilot"]["booth_keep_trying_we_better_pray"]							= "PBY1_IGD_139A_BOOT";
	
	
	level.scr_sound["laughlin"]["where_the_hells_that_support"]								= "PBY1_IGD_140A_LAUG";
	level.scr_sound["radio_op"]["landry_please_respond"]											= "PBY1_IGD_141A_LAND";
	level.scr_sound["radio_op"]["landry_theres_no_response"]									= "PBY1_IGD_142A_LAND";
	level.scr_sound["laughlin"]["shit_we_gotta_go"]														= "PBY1_IGD_143A_LAUG";
	level.scr_sound["pilot"]["booth_not_yet_laughlin"]												= "PBY1_IGD_144A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_shit_more_ptboats"]											= "PBY1_IGD_505A_BOOT";
		
	
	level.scr_sound["pilot"]["booth_incoming_left_side"]										= "PBY1_IGD_097A_BOOT";
	
	level.scr_sound["pilot"]["booth_damn_were_hit"]													= "PBY1_IGD_122A_BOOT";
	level.scr_sound["pilot"]["booth_laughlin_make_sure_were"]								= "PBY1_IGD_123A_BOOT";
	//-- LAUGHLIN: I'm on it!
	level.scr_sound["pilot"]["booth_locke_take_his"]												= "PBY1_IGD_125A_BOOT";
	//-- LAUGHLIN: Port side's pretty torn up, but we're holding
	level.scr_sound["pilot"]["booth_damn_period"]														= "PBY1_IGD_126A_BOOT";
	level.scr_sound["pilot"]["booth_zeroes_exclamation"]										= "PBY1_IGD_127A_BOOT";
	level.scr_sound["radio_op"]["landry_theyre_all_around"]									= "PBY1_IGD_128A_LAND";
	level.scr_sound["pilot"]["booth_keep_em_off_whats_left"]								= "PBY1_IGD_129A_BOOT";
	level.scr_sound["pilot"]["booth_locke_you_need_to_take"]								= "PBY1_IGD_130A_BOOT";
	level.scr_sound["pilot"]["booth_stay_on_that_trigger"]									= "PBY1_IGD_131A_BOOT";
	
	
	//-- A couple out of ammo dialogues for the player (you know, plot type stuff)
	//-- out of ammo scenario 1
	level.scr_sound["laughlin"]["shit_ammos_running_low"]                   = "PBY1_IGD_615A_LAUG";
	level.scr_sound["laughlin"]["right_50_cals_almost_out"]									= "PBY1_IGD_616A_LAUG";
	level.scr_sound["radio_op"]["landry_that_aint_good"]										= "PBY1_IGD_627A_LAND";
	
	//-- out of ammo scenario 2
	level.scr_sound["laughlin"]["dammit_im_out"]                   					= "PBY1_IGD_622A_LAUG";
	level.scr_sound["laughlin"]["right_turrets_out_of_ammo"]								= "PBY1_IGD_625A_LAUG";
	level.scr_sound["laughlin"]["left_50s_almost_out"]											= "PBY1_IGD_619A_LAUG";
	
	//-- out of ammo scenario 3
	level.scr_sound["laughlin"]["shit_were_out"]                   					= "PBY1_IGD_626A_LAUG";
	level.scr_sound["laughlin"]["left_turrets_out_of_ammo"]									= "PBY1_IGD_624A_LAUG";
	level.scr_sound["radio_op"]["landry_booth_we_gotta_get_out"]						= "PBY1_IGD_628A_LAND";
	level.scr_sound["pilot"]["booth_theres_too_many_zeros"]									= "PBY1_IGD_629A_BOOT";
	level.scr_sound["pilot"]["booth_lets_hope_theres_enough"]								= "PBY1_IGD_631A_BOOT";
	level.scr_sound["pilot"]["booth_locke_make_those_shots_count"]					= "PBY1_IGD_630A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_good_work_locke_landry_how"]						= "PBY1_IGD_155A_BOOT";
	level.scr_sound["radio_op"]["landry_hulls_intact"]											= "PBY1_IGD_156A_LAND";
	level.scr_sound["pilot"]["booth_okay_taking_her_up"]										= "PBY1_IGD_157A_BOOT";
	level.scr_sound["pilot"]["booth_how_did_we_do"]													= "PBY1_IGD_158A_BOOT";
	level.scr_sound["radio_op"]["landry_bunks_are_full"]										= "PBY1_IGD_159A_LAND";
	level.scr_sound["radio_op"]["landry_we_pulled_five"]										= "PBY1_IGD_160A_LAND";
	level.scr_sound["radio_op"]["landry_we_got_four"]												= "PBY1_IGD_161A_LAND";
	level.scr_sound["radio_op"]["landry_we_only_got_three"]									= "PBY1_IGD_162A_LAND";
	level.scr_sound["radio_op"]["landry_we_just_got_two"]										= "PBY1_IGD_163A_LAND";
	level.scr_sound["radio_op"]["landry_we_only_got_one"]										= "PBY1_IGD_164A_LAND";
	level.scr_sound["radio_op"]["landry_we_struck_out"]											= "PBY1_IGD_165A_LAND";
	
	level.scr_sound["pilot"]["booth_landry_secure_the_wounded"]							= "PBY1_IGD_312A_BOOT";
	level.scr_sound["pilot"]["booth_landry_prep_for_takeoff"]								= "PBY1_IGD_313A_BOOT";
	level.scr_sound["pilot"]["booth_laughlin_patch_us_up_as_best"]					= "PBY1_IGD_314A_BOOT";
	level.scr_sound["pilot"]["booth_locke_sit_tight_and_keepem_peeled"]			= "PBY1_IGD_315A_BOOT";
	
	
	level.scr_sound["pilot"]["booth_comin_around"]													= "PBY1_IGD_166A_BOOT";
	//-- LAUGHLIN: Halle-fucking-lujah
	level.scr_sound["pilot"]["booth_oh_no_no_landry"]												= "PBY1_IGD_167A_BOOT";
	level.scr_sound["pilot"]["booth_its_the_enemy"]													= "PBY1_IGD_168A_BOOT";
	level.scr_sound["pilot"]["booth_lets_hope_they"]												= "PBY1_IGD_169A_BOOT";
	level.scr_sound["pilot"]["booth_evasive_maneuvers"]											= "PBY1_IGD_170A_BOOT";
	level.scr_sound["pilot"]["booth_locke_get_on_the_50"]										= "PBY1_IGD_171A_BOOT";
	
	level.scr_sound["radio_op"]["landry_theres_too_many_of_them"]						= "PBY1_OUT_000A_LAND";	
	level.scr_sound["radio_op"]["landry_were_almost_out_of_ammo"]						= "PBY1_OUT_001A_LAND";	
	level.scr_sound["radio_op"]["landry_were_sitting_ducks"]								= "PBY1_OUT_003A_LAND";	
	level.scr_sound["pilot"]["booth_shit"]																	= "PBY1_OUT_004A_BOOT";	
	level.scr_sound["pilot"]["booth_smoke_them_if_you"]											= "PBY1_OUT_005A_BOOT";	
	
	level.scr_sound["corsair"]["vpb_54_havok_26_coming_in_on_your_9"]				= "PBY1_OUT_006A_CAIR";
	level.scr_sound["corsair"]["well_take_it_from_here"]										= "PBY1_OUT_007A_CAIR";
	level.scr_sound["corsair"]["get_yourselves_back_to_base"]								= "PBY1_OUT_008A_CAIR";

	
	//-- Good Kill Dialogue
	level.scr_sound["pilot"]["booth_keep_it_up"]					= "PBY1_IGD_020A_BOOT";
	level.scr_sound["pilot"]["booth_nice_shooting"] 			= "PBY1_IGD_018A_BOOT";
	level.scr_sound["radio_op"]["landry_good_job_locke"] 	= "PBY1_IGD_300A_LAND";
	//-- LAUGHLIN: "Fuck, Yeah!"
	level.scr_sound["radio_op"]["landry_you_got_it"]		 	= "PBY1_IGD_302A_LAND";
	level.scr_sound["radio_op"]["landry_thats_a_hit"]			= "PBY1_IGD_303A_LAND";
	//-- LAUGHLIN: "Direct Hit!"
	level.scr_sound["radio_op"]["landry_dont_stop_now"]		= "PBY1_IGD_305A_LAND";
	level.scr_sound["pilot"]["booth_thats_the_way"]				= "PBY1_IGD_306A_BOOT";
	
	//-- Good Kill Plane
	level.scr_sound["pilot"]["booth_zero_goin_down"] 					= "PBY1_IGD_606A_BOOT";
	level.scr_sound["pilot"]["booth_you_nailed_that_plane"] 	= "PBY1_IGD_607A_BOOT";
	level.scr_sound["pilot"]["booth_zero_dash_down"] 					= "PBY1_IGD_608A_BOOT";
	level.scr_sound["laughlin"]["his_flyin_days_are_over"]		= "PBY1_IGD_609A_LAUG";
	level.scr_sound["laughlin"]["you_clipped_that_bastards"]	= "PBY1_IGD_610A_LAUG";
	level.scr_sound["laughlin"]["another_zero_knocked_down"]	= "PBY1_IGD_611A_LAUG";
	level.scr_sound["laughlin"]["zero_taken_down"]						= "PBY1_IGD_612A_LAUG";
			
	//-- Good Kill Boat
	level.scr_sound["pilot"]["booth_ptboat_sunk"] 					= "PBY1_IGD_600A_BOOT";
	level.scr_sound["pilot"]["booth_ptboat_disables"] 			= "PBY1_IGD_601A_BOOT";
	level.scr_sound["pilot"]["booth_ptboat_lots_of_holes"] 	= "PBY1_IGD_602A_BOOT";
	level.scr_sound["laughlin"]["ptboat_going_down"] 				= "PBY1_IGD_603A_LAUG";
	level.scr_sound["laughlin"]["ptboat_outta_commision"]   = "PBY1_IGD_604A_LAUG";
	level.scr_sound["laughlin"]["you_tore_that_ptboat"]			= "PBY1_IGD_605A_LAUG";
	
	
	//-- THAT WAS CLOSE DIALOG
	level.scr_sound["pilot"]["booth_that_was_close"]			= "PBY1_IGD_566A_BOOT";
	level.scr_sound["pilot"]["booth_close_one"]						= "PBY1_IGD_567A_BOOT";
	level.scr_sound["laughlin"]["whooooahh"]							= "PBY1_IGD_568A_LAUG";
	level.scr_sound["laughlin"]["too_fucking_close"]			= "PBY1_IGD_569A_LAUG";
	
	
	
	//-- DAMAGE VO
	level.scr_sound["laughlin"]["right_wing_damage"]	= "PBY1_IGD_540A_LAUG";
	level.scr_sound["laughlin"]["left_wing_damage"]	=	"PBY1_IGD_541A_LAUG";
	level.scr_sound["laughlin"]["number_two_engine"]	= "PBY1_IGD_542A_LAUG";
	level.scr_sound["laughlin"]["number_one_engine"]	= "PBY1_IGD_543A_LAUG";
	level.scr_sound["laughlin"]["engine_fire"]				= "PBY1_IGD_544A_LAUG";
	level.scr_sound["radio_op"]["landry_right_wing_damage"]	= "PBY1_IGD_546A_LAND";
	level.scr_sound["radio_op"]["landry_left_wing_damage"]	= "PBY1_IGD_547A_LAND";
	level.scr_sound["radio_op"]["landry_number_two_engine"]	= "PBY1_IGD_548A_LAND";
	level.scr_sound["radio_op"]["landry_number_one_engine"]	= "PBY1_IGD_549A_LAND";
	
	
	
	//-- INTRO part 2 ------------------------------------------------------------
	//level.scr_sound["pilot"]["intro2_a_close"]					= "PBY1_INT_007A_PLT1";
	//level.scr_sound["pilot"]["intro2_b_killcount"] 			= "PBY1_INT_008A_PLT2";
	
	//level.scr_sound["radio_op"]["intro2_a_command"]			= "PBY1_INT_009A_RADO";
	//level.scr_sound["radio_op"]["intro2_a_check"]				= "PBY1_INT_010A_RADO";
	//level.scr_sound["radio_op"]["intro2_b_newkid"]			= "PBY1_INT_011A_GUN2";
	//level.scr_sound["pilot"]["intro2_a_maintain"]				= "PBY1_INT_012A_PLT1";
	
	/*
	level.scr_sound["pilot"]["intro2_b_echo"]						= "PBY1_INT_013A_PLT2";
	level.scr_sound["pilot"]["intro2_a_peeled"]					= "PBY1_INT_014A_PLT1";
	level.scr_sound["pilot"]["intro2_b_visual"]					= "PBY1_INT_015A_PLT2";
	level.scr_sound["pilot"]["intro2_a_comms"]					= "PBY1_INT_016A_PLT1";
	level.scr_sound["pilot"]["intro2_a_eyeson"]					= "PBY1_INT_017A_PLT1";
	level.scr_sound["radio_op"]["intro2_c_affirmative"]	= "PBY1_INT_018A_COMM";
	level.scr_sound["radio_op"]["intro2_c_permission"]	= "PBY1_INT_019A_COMM";
	level.scr_sound["pilot"]["intro2_a_rogerthat"]			= "PBY1_INT_020A_PLT1";
	level.scr_sound["pilot"]["intro2_a_getonrear"]			= "PBY1_IGD_028A_PLT1";
	level.scr_sound["radio_op"]["intro2_a_battlestation"]  = "PBY1_INT_105A_RADO";
	level.scr_sound["pilot"]["intro2_a_takingus"]				= "PBY1_INT_021A_PLT1";
	level.scr_sound["pilot"]["intro2_a_gettoturret"]		= "PBY1_INT_022A_PLT1";
	level.scr_sound["pilot"]["intro2_a_silent"]					= "PBY1_INT_023A_PLT1";
	level.scr_sound["pilot"]["intro2_a_overthem"]				= "PBY1_IGD_109A_PLT1";
	level.scr_sound["pilot"]["intro2_a_shootmoves"]			= "PBY1_IGD_110A_PLT1";
	*/
	
	//-- EVENT 2 - Flak event
	//level.scr_sound["pilot"]["event2_a_another"]					= "PBY1_MID_006A_PLT1";
	//lvel.scr_sound[""][""]															= "PBY1_MID_007A_PLT2";
	//level.scr_sound["pilot"]["event2_a_whatthe"]					= "PBY1_MID_008A_PLT1";
	//level.scr_sound["pilot"]["event2_b_toomuch"]					= "PBY1_MID_009A_PLT2";
	//level.scr_sound["pilot"]["event2_a_evasive"]					= "PBY1_MID_010A_PLT1";
	//level.scr_sound["radio_op"]["event2_a_damn"]					= "PBY1_MID_011A_RADO";
	
	//-- Event 2 - Is Player Ok?
	//level.scr_sound["pilot"]["event2_a_playerok"] 			= "PBY1_MID_017A_GUN2";
	//level.scr_sound["radio_op"]["event2_a_playerfine"] 	= "PBY1_MID_018A_RADO";

	//-- Event 2 - Lead into 3rd pass (not in yet)
	//level.scr_sound["radio_op"]["event2_b_needclose"] 	= "PBY1_MID_019A_GUN2";
	//level.scr_sound["pilot"]["event2_a_takeusclose"] 		= "PBY1_MID_020A_PLT1";
	
	//-- Event 2 - Last Pass (multiple versions based on evaluation not in yet)
	//level.scr_sound["pilot"]["event2_a_lastpass_a"] 		= "PBY1_MID_024A_PLT1";
	//level.scr_sound["pilot"]["event2_a_humblepie"] 			= "PBY1_MID_025A_PLT1";
			//or
	//level.scr_sound["pilot"]["event2_a_lastpass_b"] 		= "PBY1_MID_027A_PLT1";
	
	//-- Event 2 - Evaluation (not in yet)
			// job well done
	//level.scr_sound["pilot"]["event2_a_nicejob"] = "PBY1_MID_026A_PLT1";
	//level.scr_sound["pilot"]["event2_b_thinkwegot"] = "PBY1_MID_028A_PLT2";
	//level.scr_sound["radio_op"]["event2_b_goingdown"] = "PBY1_MID_029A_GUN2";
	//level.scr_sound["pilot"]["event2_a_goodwork"] = "PBY1_MID_030A_PLT1";
			// or not so well done
	//level.scr_sound["radio_op"]["event2_b_stillfloat"] 	= "PBY1_MID_031A_GUN2";
	//level.scr_sound["radio_op"]["event2_b_rookiesucks"] = "PBY1_MID_032A_GUN2";
	//level.scr_sound["pilot"]["event2_a_didwhatcould"] 	= "PBY1_MID_033A_PLT1";
	
	//-- Event 3 - Intro (REVISED)
	//level.scr_sound["pilot"]["event3_b_headingback"] 	= "PBY1_MID_034A_PLT2";
	//level.scr_sound["pilot"]["event3_a_echo"] 				= "PBY1_MID_035A_PLT1";
	//level.scr_sound["pilot"]["event3_b_roughed"] 			= "PBY1_MID_200A_PLT2";
	//level.scr_sound["pilot"]["event3_b_takealook"] 		= "PBY1_MID_201A_PLT2";
	//level.scr_sound["radio_op"]["event3_a_rogerthat"]	= "PBY1_MID_201A_RADO";
	//level.scr_sound["pilot"]["event3_a_takingusup"]   = "PBY1_MID_203A_PLT1";
	
	//level.scr_sound["radio_op"]["event3_a_distress"] 	= "PBY1_MID_036A_RADO";
	//level.scr_sound["pilot"]["event3_a_shit"] 				= "PBY1_MID_037A_PLT1";
	//level.scr_sound["pilot"]["event3_a_hotzone"] 			= "PBY1_MID_038A_PLT1";
	//level.scr_sound["pilot"]["event3_b_newheading"]   = "PBY1_MID_123A_PLT2";
		
	//level.scr_sound["pilot"]["event3_b_hearthat"]     = "PBY1_MID_204A_PLT2";
	//level.scr_sound["pilot"]["event3_a_shitzeroes"]		= "PBY1_MID_205A_PLT1";
	//level.scr_sound["pilot"]["event3_a_tojo"]					= "PBY1_MID_206A_PLT1";
	
	//level.scr_sound["radio_op"]["event3_b_suicide"]		= "PBY1_MID_124A_GUN2";
	//level.scr_sound["pilot"]["event3_b_aintleaving"]	= "PBY1_MID_125A_PLT2";
	//level.scr_sound["pilot"]["event3_a_walkinpark"]		= "PBY1_MID_126A_PLT1";
	
	//-- Event 2
	//level.scr_sound["pilot"]["doing_strafing_pass"] = "print: Heading in for a strafing run, get ready!";
	//level.scr_sound["pilot"]["get_to_front_turret"] = "print: Get to the Front Turret!";
	//level.scr_sound["pilot"]["get_to_ventral_turret"] = "print: Get to the Ventral Turret!";
	//level.scr_sound["pilot"]["get_to_right_turret"] =   "print: Get to the Right Turret!";
	//level.scr_sound["pilot"]["get_to_left_turret"] = "print: Get to the Left Turret!";
	
	//-- Event 3
	//level.scr_sound["radio_op"]["recieved_distress"] =		"print: We just received a distress call from that naval fleet.";
	//level.scr_sound["radio_op"]["kamikaze_attack"] = 			"print: Sounds like they were victim of a jap kamikaze ambush.";
	//level.scr_sound["radio_op"]["requesting_help"] =      "print: They are requesting help from anyone in the area.  Do we have enough fuel to go help out?";
	//level.scr_sound["pilot"]["save_and_fuel"] = 					"print: It doesnt matter if we have enough fuel! Tell them we are on the way!";
	
	//-- Event 4
	
	//pilot
	//level.scr_sound["pilot"]["zeroes"] 			= "PBY1_IGD_004A_PLT1";
	//level.scr_sound["pilot"]["fast_zeroes"] = "PBY1_IGD_005A_PLT1";
	//level.scr_sound["pilot"]["more_zeroes"] = "PBY1_IGD_006A_PLT1";
	
	//level.scr_sound["pilot"]["12oclock"] 	= "PBY1_IGD_007A_PLT1";
	//level.scr_sound["pilot"]["1oclock"] 	= "PBY1_IGD_008A_PLT1";
	//level.scr_sound["pilot"]["2oclock"] 	= "PBY1_IGD_009A_PLT1";
	//level.scr_sound["pilot"]["3oclock"] 	= "PBY1_IGD_010A_PLT1";
	//level.scr_sound["pilot"]["4oclock"] 	= "PBY1_IGD_011A_PLT1";
	//level.scr_sound["pilot"]["5oclock"] 	= "PBY1_IGD_012A_PLT1";
	//level.scr_sound["pilot"]["6oclock"] 	= "PBY1_IGD_013A_PLT1";
	//level.scr_sound["pilot"]["7oclock"] 	= "PBY1_IGD_014A_PLT1";
	//level.scr_sound["pilot"]["8oclock"] 	= "PBY1_IGD_015A_PLT1";
	//level.scr_sound["pilot"]["9oclock"] 	= "PBY1_IGD_016A_PLT1";
	//level.scr_sound["pilot"]["10oclock"] 	= "PBY1_IGD_017A_PLT1";
	//level.scr_sound["pilot"]["11oclock"] 	= "PBY1_IGD_018A_PLT1";
	
	//level.scr_sound["pilot"]["right_turret"] 			= "PBY1_IGD_019A_PLT1";
	//level.scr_sound["pilot"]["right_turret_now"] 	= "PBY1_IGD_020A_PLT1";
	//level.scr_sound["pilot"]["right_turret_need"] = "PBY1_IGD_021A_PLT1";
	//level.scr_sound["pilot"]["left_turret"] 			= "PBY1_IGD_022A_PLT1";
	//level.scr_sound["pilot"]["left_turret_now"] 	= "PBY1_IGD_023A_PLT1";
	//level.scr_sound["pilot"]["left_turret_need"] 	= "PBY1_IGD_024A_PLT1";
	//level.scr_sound["pilot"]["front_turret"] 			= "PBY1_IGD_025A_PLT1";
	//level.scr_sound["pilot"]["front_turret_now"] 	= "PBY1_IGD_026A_PLT1";
	//level.scr_sound["pilot"]["front_turret_need"] = "PBY1_IGD_027A_PLT1";
	
	//-- PTBOAT CHATTER TYPE STUFF
	//level.scr_sound["pilot"]["ptboat_0"] = "PBY1_MID_013A_PLT1";
	//level.scr_sound["pilot"]["ptboat_1"] = "PBY1_IGD_104A_PLT1";
	//level.scr_sound["pilot"]["ptboat_2"] = "PBY1_IGD_200A_PLT1";
	//level.scr_sound["pilot"]["ptboat_3"] = "PBY1_IGD_002A_PLT1";
	
	//-- GENERAL CHATTER MERCHANT EVENT -- all played off of the first player pilot
	//level.scr_sound["pilot"]["gc_merchant_0"]  = "PBY1_IGD_106A_PLT2";
	//level.scr_sound["pilot"]["gc_merchant_1"]	 = "PBY1_MID_108A_GUN2";
	//level.scr_sound["pilot"]["gc_merchant_2"]	 = "PBY1_MID_102A_GUN2";
	//level.scr_sound["pilot"]["gc_merchant_3"]  = "PBY1_MID_112A_GUN2";
	
	//VO - SAILORS IN WATER
	//level.scr_sound["sailor"]["help"] 							= "PBY1_IGD_000A_PBR1";
	//level.scr_sound["sailor"]["over_here"] 					= "PBY1_IGD_001A_PBR1";
	//level.scr_sound["sailor"]["need_help"] 					= "PBY1_IGD_002A_PBR1";
	
	level.scr_sound["sailor"]["get_me_out_of_here"]			= "PBY1_IGD_570A_USR3";
	level.scr_sound["sailor"]["help_please_over_here"] 	= "PBY1_IGD_571A_USR1";
	level.scr_sound["sailor"]["oh_god_god"] 						= "PBY1_IGD_572A_USR2";
	level.scr_sound["sailor"]["oh_god_please"]					= "PBY1_IGD_582A_USR3";
	
	//-- hanging on
	level.scr_sound["sailor"]["give_me_your_hand"] 			= "PBY1_IGD_003A_PBR1";
	level.scr_sound["sailor"]["im_slipping"] 						= "PBY1_IGD_004A_PBR1";
	level.scr_sound["sailor"]["cant_hold_on"] 					= "PBY1_IGD_005A_PBR1";
	level.scr_sound["sailor"]["there_are_more_coming"]	= "PBY1_IGD_577A_USR1";
	level.scr_sound["sailor"]["oh_god_oh_my_god"]				= "PBY1_IGD_580A_USR1";
	level.scr_sound["sailor"]["oh_god_breathing"]				= "PBY1_IGD_581A_USR3";
	
	//-- saved
	level.scr_sound["sailor"]["throw_up_0"] 			= "PBY1_IGD_573A_USR3";
	level.scr_sound["sailor"]["throw_up_1"] 			= "PBY1_IGD_574A_USR1";
	level.scr_sound["sailor"]["throw_up_2"] 			= "PBY1_IGD_575A_USR2";
	level.scr_sound["sailor"]["throw_up_3"] 			= "PBY1_IGD_576A_USR3";
	level.scr_sound["sailor"]["shivering"]				= "PBY1_IGD_578A_USR2";
	
	//-- not in
	level.scr_sound["sailor"]["please"] 						= "PBY1_IGD_129A_PBR1";
	level.scr_sound["sailor"]["dont_leave_me"] 			= "PBY1_IGD_130A_PBR1";
	
}


#using_animtree("player");

player_anim_loader()
{
	// Set the animtree
	level.scr_animtree[ "player_hands" ] = #animtree;
	
	level.scr_anim[ "player_hands" ][ "pby_front_to_death" ] 	= %int_pby_fgun_to_die;
	level.scr_anim[ "player_hands" ][ "pby_left_to_death" ] 	= %int_pby_lgun_to_die;
	level.scr_anim[ "player_hands" ][ "pby_right_to_death" ] 	= %int_pby_rgun_to_die;
	level.scr_anim[ "player_hands" ][ "pby_back_to_death" ] 	= %int_pby_vgun_to_die;
	
	//-- PBY TRANSITION ANIMS
	level.scr_anim[ "player_hands" ][ "pby_front_to_rear" ]  = 	%int_pby_Front_to_Rear;
	addNotetrack_customFunction( "player_hands", "acknowledge", maps\pby_fly::play_acknowledge_anim, "pby_front_to_rear");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_front_to_rear");
	
	
	level.scr_anim[ "player_hands" ][ "pby_front_to_right" ] = 	%int_pby_Front_to_Rgun;
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_front_to_right");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_AI_FtoR, "pby_front_to_right");
	
	
	level.scr_anim[ "player_hands" ][ "pby_front_to_left" ]  = 	%int_pby_Front_to_Lgun;
	addNoteTrack_customFunction( "player_hands", "ftol", maps\pby_fly::play_trans_AI_FtoL, "pby_front_to_left");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_front_to_left");
	
	
	//level.scr_anim[ "player_hands" ][ "pby_right_to_front" ] =	%int_pby_Rgun_to_Front;
	level.scr_anim[ "player_hands"]["pby_right_to_front"] = %int_pby_Rgun_to_Front;
	addNoteTrack_customFunction( "player_hands", "rtof", maps\pby_fly::play_trans_AI_RtoF, "pby_right_to_front");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_right_to_front");
	
	
	level.scr_anim[ "player_hands" ][ "pby_right_to_left" ]  =	%int_pby_Rgun_to_Lgun;
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_right_to_left");
	
	level.scr_anim[ "player_hands" ][ "pby_right_to_rear" ]  =	%int_pby_Rgun_to_Rear;
	level.scr_anim[ "player_hands" ][ "pby_left_to_front" ]  = 	%int_pby_Lgun_to_Front;
	
	addNoteTrack_customFunction( "player_hands", "extinguisher", maps\pby_fly::fire_extinguisher, "pby_left_to_front");
	addNoteTrack_customFunction( "player_hands", "ltof", maps\pby_fly::play_trans_AI_LtoF, "pby_left_to_front");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_left_to_front");
		
	level.scr_anim[ "player_hands" ][ "pby_right_to_end" ]  	=	%int_pby_rgun_to_end;
	level.scr_anim[ "player_hands" ][ "pby_right_to_flak" ]  	=	%int_pby_rgun_to_flak;
	addNoteTrack_customFunction( "player_hands", "rtof", maps\pby_fly::play_trans_AI_RtoF, "pby_right_to_flak");
	addNoteTrack_customFunction( "player_hands", "flak", maps\pby_fly::event2_flak_front_of_plane, "pby_right_to_flak");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_right_to_flak");
	
	level.scr_anim[ "player_hands" ][ "pby_right_to_pistol" ]	= %int_pby_rgun_to_pistol;
	level.scr_anim[ "player_hands" ][ "pby_right_to_left_pistol" ]	= %int_pby_rgun_to_lpistol;
	
	
	level.scr_anim[ "player_hands" ][ "pby_left_to_right" ]  = 	%int_pby_Lgun_to_Rgun;
	level.scr_anim[ "player_hands" ][ "pby_left_to_rear" ]   =	%int_pby_Lgun_to_Rear;
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "pby_left_to_right");
	
	level.scr_anim[ "player_hands" ][ "pby_rear_to_front" ]  = 	%int_pby_Rear_to_Front;
	level.scr_anim[ "player_hands" ][ "pby_rear_to_right" ]  =  %int_pby_Rear_to_Rgun;
	level.scr_anim[ "player_hands" ][ "pby_rear_to_left" ]   = 	%int_pby_Rear_to_Lgun;
	
	
	level.scr_anim[ "player_hands" ][ "pby_right_rescue" ]   =	%int_pby_rescue_right;
  level.scr_anim[ "player_hands" ][ "pby_left_rescue" ]    = 	%int_pby_rescue_left;
	
  level.scr_anim[ "player_hands" ][ "crash" ] 						 =  %int_pby_player1_crash;
  
  level.scr_anim[ "player_hands" ][ "bank_loop" ][0]					 = 	%int_pby_bank_loop;
	level.scr_anim[ "player_hands" ][ "bank_fall" ]					 = 	%int_pby_bank_thrown;
	level.scr_anim[ "player_hands" ][ "bank_to_right" ]			 = 	%int_pby_bank_to_Rgun;
	
	level.scr_anim[ "player_hands" ][ "close_hatch" ]				 =  %int_pby_close_hatch;
	addNoteTrack_customFunction( "player_hands", "hatch", maps\pby_fly::play_hatch_anim, "close_hatch");
	addNoteTrack_customFunction( "player_hands", "distress", maps\pby_fly::play_chair_distress_anim, "close_hatch");
	addNoteTrack_customFunction( "player_hands", "distress", maps\pby_fly::play_trans_AI_Distress, "close_hatch");
	addNoteTrack_customFunction( "player_hands", "distress2", maps\pby_fly::play_trans_AI_Distress2, "close_hatch");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "close_hatch");
	
	level.scr_anim[ "player_hands" ][ "open_hatch" ] 				 = %int_pby_open_hatch;
	addNoteTrack_customFunction( "player_hands", "hatch", maps\pby_fly::play_hatch_anim_open, "open_hatch");
	addNoteTrack_customFunction( "player_hands", "ftov", maps\pby_fly::play_trans_AI_FtoV, "open_hatch");
	addNoteTrack_customFunction( "player_hands", "gunner", maps\pby_fly::play_trans_gunner, "open_hatch");
	
	level.scr_anim[ "player_hands" ][ "pby_right_to_seat" ]  = %int_pby_Rgun_to_Rseat;
	
	level.scr_anim[ "player_hands" ][ "intro_move" ]				 = %int_pby_intro_traverse;
	level.scr_anim[ "player_hands" ][ "intro_loop" ]				 = %int_pby_intro_loop;
	
}

#using_animtree ("vehicles");
vehicle_anims()
{
	level.scr_anim["pby"]["crash"] 										= %v_pby1_crash;
	level.scr_anim["pby"]["player_crash"]							= %v_pby_player_pbycrash;
	level.scr_anim["pby"]["player_crash2"]						= %v_pby_player_pbycrash2;
	level.scr_anim["pby"]["pontoons_up"] 							= %v_pby_pontoon_up;
	level.scr_anim["pby"]["pontoons_down"] 						= %v_pby_pontoon_down;
	level.scr_anim["pby"]["pontoons_snap_up"] 				= %v_pby_pontoon_snap_up;
	level.scr_anim["pby"]["pontoons_snap_down"]			  = %v_pby_pontoon_snap_down;
	level.scr_anim["pby"]["ventral_close"] 						= %v_pby_rear_gun_up;
	level.scr_anim["pby"]["ventral_open"] 						= %v_pby_rear_gun_down;
	level.scr_anim["pby"]["ventral_snap_close"]			  = %v_pby_rear_gun_snap_up;
	level.scr_anim["pby"]["ventral_snap_open"] 				= %v_pby_rear_gun_snap_down;
	level.scr_anim["pby"]["flying_loop"][0]						= %v_pby_fly;
	level.scr_anim["pby"]["flying_loop_up"][0] 			  = %v_pby_fly_up;
	level.scr_anim["pby"]["flying_loop_up_open"][0]	  = %v_pby_fly_up_open;
	level.scr_anim["pby"]["flying_loop_down"][0]			= %v_pby_fly_down;
	level.scr_anim["pby"]["radio_distress_call"]			= %v_pby_distress_radio;
	//level.scr_anim["pby"]["floating_loop"][0]				= %v_pby_float;
	level.scr_anim["pby"]["floating_loop_blister"][0] = %v_pby_float_blisters;
	level.scr_anim["pby"]["floating_loop_static"][0]  = %v_pby_staticpose;
	level.scr_anim["pby"]["floating_loop"][0]					= %v_pby_taxi_rough;
	level.scr_anim["pby"]["floating_loop_ai"][0]			= %v_pby_taxi_ai;
	level.scr_anim["pby"]["shinyou_blast"]      			= %v_pby_explosion;
	level.scr_anim["pby"]["hatch"]										= %v_pby_close_hatch;
	level.scr_anim["pby"]["hatch_open"]								= %v_pby_open_hatch;
	level.scr_anim["pby"]["intro_vig"]								= %v_pby_intro;
	level.scr_anim["pby"]["pby_landing"]							= %v_pby_land_water;
	addNoteTrack_customFunction( "pby", "earthquake", maps\pby_fly::play_landing_shake, "pby_landing");
	addNoteTrack_customFunction( "pby", "mini_quake", maps\pby_fly::play_landing_shake_only, "pby_landing");
	
	level.scr_anim["pby"]["crash1"] 									= %v_pby_crash1;
	level.scr_anim["pby"]["crash2"] 									= %v_pby_crash2;
	addNoteTrack_customFunction( "pby", "explosion", maps\pby_fly::pby_b_explosion, "crash2");
	
	level.scr_anim["pby"]["ammo_start_right"] = %v_pby_blisterammo_right_start;
	level.scr_anim["pby"]["ammo_stop_right"]	= %v_pby_blisterammo_right_stop;
	level.scr_anim["pby"]["ammo_fire_right"]	= %v_pby_blisterammo_right_fire;
	level.scr_anim["pby"]["ammo_start_left"] = %v_pby_blisterammo_left_start;
	level.scr_anim["pby"]["ammo_stop_left"]	= %v_pby_blisterammo_left_stop;
	level.scr_anim["pby"]["ammo_fire_left"]	= %v_pby_blisterammo_left_fire;
	
	level.scr_anim["pby"]["ammo_right_7"] = %v_pby_blisterammo_right_empty7;
	level.scr_anim["pby"]["ammo_right_6"] = %v_pby_blisterammo_right_empty6;
	level.scr_anim["pby"]["ammo_right_5"] = %v_pby_blisterammo_right_empty5;
	level.scr_anim["pby"]["ammo_right_4"] = %v_pby_blisterammo_right_empty4;
	level.scr_anim["pby"]["ammo_right_3"] = %v_pby_blisterammo_right_empty3;
	level.scr_anim["pby"]["ammo_right_2"] = %v_pby_blisterammo_right_empty2;
	level.scr_anim["pby"]["ammo_right_1"] = %v_pby_blisterammo_right_empty1;
		
	level.scr_anim["pt_boat"]["idle"][0] = %v_ptboat_idle;
	//level.scr_anim["pt_boat"]["sink1"] = %v_ptboat_sink;
	//level.scr_anim["pt_boat"]["sink2"] = %v_ptboat_sink2;
	//level.scr_anim["pt_boat"]["sink3"] = %v_ptboat_sink3;
	//level.scr_anim["pt_boat"]["sink4"] = %v_ptboat_sink4;
	level.scr_anim["pt_boat"]["sink1"] = %v_ptboat_death1;
	level.scr_anim["pt_boat"]["sink2"] = %v_ptboat_death_fronthit;
	level.scr_anim["pt_boat"]["sink3"] = %v_ptboat_death_righthit;
	level.scr_anim["pt_boat"]["sink4"] = %v_ptboat_death_lefthit;
	level.scr_anim["pt_boat"]["sink5"] = %v_ptboat_death_alt_a;
	level.scr_anim["pt_boat"]["sink6"] = %v_ptboat_death_alt_b;
	level.scr_anim["pt_boat"]["sink7"] = %v_ptboat_death_alt_c;
	level.scr_anim["pt_boat"]["sink8"] = %v_ptboat_death_alt_d;
	
	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink1");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink1");
	
	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink2");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink2");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink3");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink3");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink4");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink4");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink5");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink5");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink6");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink6");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink7");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink7");

	addNoteTrack_customFunction( "pt_boat", "note_vent2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent2_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_vent1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent1_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_vent3_jnt", maps\pby_fly_fx::play_waterfx_ptboat_vent3_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_box2_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box2_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_tower_jnt", maps\pby_fly_fx::play_waterfx_ptboat_tower_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_radar_jnt", maps\pby_fly_fx::play_waterfx_ptboat_radar_jnt, "sink8");
	addNoteTrack_customFunction( "pt_boat", "note_box1_jnt", maps\pby_fly_fx::play_waterfx_ptboat_box1_jnt, "sink8");

	level.scr_anim["pt_boat"]["ptboat_skim"][0] = %v_ptboat_skim;
	level.scr_anim["pt_boat"]["ptboat_skim4"][0] = %v_ptboat_skim4;
	level.scr_anim["pt_boat"]["ptboat_skim5"][0] = %v_ptboat_skim5;
	
	level.scr_anim["merchant_ship"]["sink_big"] = %v_merchant_ship_sink5;
	addNoteTrack_customFunction( "merchant_ship", "shp_break", maps\pby_fly_fx::sink_big_fx, "sink_big");
	level.scr_anim["merchant_ship"]["sink0"] = %v_merchant_ship_sink2;
	level.scr_anim["merchant_ship"]["sink1"] = %v_merchant_ship_sink3;
	addNoteTrack_customFunction( "merchant_ship", "shp_break", maps\pby_fly_fx::sink_big_fx, "sink1");
	level.scr_anim["merchant_ship"]["sink2"] = %v_merchant_ship_sink4;
	addNoteTrack_customFunction( "merchant_ship", "shp_break", maps\pby_fly_fx::sink_big_fx, "sink2");
	
	level.scr_anim["shinyou"]["skim"]  = %v_shinyou_skim;
	level.scr_anim["shinyou"]["sink"]	 = %v_shinyou_sink;
	
	level.scr_anim["fletcher"]["plane_impact"] = %v_fletcher_impact;
	
	level.scr_anim["zero"]["water_skip"] = %o_pby_zero_miss_waterskip;
	addNoteTrack_customFunction( "zero", "fuselage_hit_0", maps\pby_fly_fx::play_fuselage_water_hit_0, "water_skip");
	addNoteTrack_customFunction( "zero", "right_wing_splash_0", maps\pby_fly_fx::play_rwing_water_hit_0, "water_skip");
	addNoteTrack_customFunction( "zero", "left_wing_splash_0", maps\pby_fly_fx::play_lwing_water_hit_0, "water_skip");
	addNoteTrack_customFunction( "zero", "left_wing_splash_1", maps\pby_fly_fx::play_lwing_water_hit_1, "water_skip");
	addNoteTrack_customFunction( "zero", "tail_splash_0", maps\pby_fly_fx::play_tail_water_hit_0, "water_skip");
	addNoteTrack_customFunction( "zero", "fuselage_hit_1", maps\pby_fly_fx::play_fuselage_water_hit_1, "water_skip");
	addNoteTrack_customFunction( "zero", "left_wing_splash_2", maps\pby_fly_fx::play_lwing_water_hit_2, "water_skip");
	addNoteTrack_customFunction( "zero", "fuselage_hit_2", maps\pby_fly_fx::play_fuselage_water_hit_2, "water_skip");
	
	level.scr_anim["zero"]["idle"][0] = %o_pby_zero_flying_idle1;
	level.scr_anim["zero"]["idle"][1] = %o_pby_zero_flying_idle2;
	level.scr_anim["zero"]["idle"][2] = %o_pby_zero_flying_idle3;
	
	level.scr_anim["zero"]["fletcher_hit_front"] = %o_pby_zero_fletcherhit_front;
	addNoteTrack_customFunction( "zero", "tail_collide_0", maps\pby_fly::front_hit_fletcher_kamikaze_gun_1, "fletcher_hit_front");
	addNoteTrack_customFunction( "zero", "fuselage_collide_1", maps\pby_fly::front_hit_fletcher_kamikaze_gun_2, "fletcher_hit_front");
	addNoteTrack_customFunction( "zero", "fuselage_collide_2", maps\pby_fly::front_hit_fletcher_kamikaze_chunk_1, "fletcher_hit_front");
	
	level.scr_anim["fletcher"]["fletcherhit_front_chunk1"] = %o_pby_chunks1_fletcherhit_front;
	level.scr_anim["fletcher"]["fletcherhit_front_gun1barrel"] = %o_pby_gun1barrel_fletcherhit_front;
	level.scr_anim["fletcher"]["fletcherhit_front_gun1base"] = %o_pby_gun1base_fletcherhit_front;
	level.scr_anim["fletcher"]["fletcherhit_front_gun2barrel"] = %o_pby_gun2barrel_fletcherhit_front;
	level.scr_anim["fletcher"]["fletcherhit_front_gun2base"] = %o_pby_gun2base_fletcherhit_front;
	
	level.scr_anim["fletcher"]["fletcherhit_right_chunk3"] 					= %o_pby_chunk3_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk4tower"] 		= %o_pby_chunk4tower_fletcherhit_right;
	//level.scr_anim["fletcher"]["fletcherhit_right_chunk5"] 					= %o_pby_chunk5_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk5plate"]				= %o_pby_chunk5plate_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk5tower"]				= %o_pby_chunk5tower_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk5"] 					= %o_pby_chunk5tower_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk2"] 					= %o_pby_chunk2_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right"] 								= %o_pby_fletcher_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_oerlikon"] 			 	= %o_pby_oerlikon_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_oerlikonshield"] 	= %o_pby_oerlikonshield_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_turret"] 					= %o_pby_turret_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_turretbarrel"] 		= %o_pby_turretbarrel_fletcherhit_right;
}
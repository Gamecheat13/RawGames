#include maps\_anim;


main()
{
	anim_gen_human();
	anim_door();
	dialogue();
}

#using_animtree("generic_human");
dialogue()
{

//RIDE IN
	//base plate this is hammer two four, we have visual on the target, eta 60 seconds
	level.scr_radio[ "cargoship_hp1_baseplatehammertwo" ]			= "cargoship_hp1_baseplatehammertwo";
	//copy two four
	level.scr_radio[ "cargoship_hqr_copytwofour" ]					= "cargoship_hqr_copytwofour";
	//30 seconds, going dark
	level.scr_radio[ "cargoship_hp1_thirtysecdark" ]				= "cargoship_hp1_thirtysecdark";
	//crew expenable, lock and load
	level.scr_radio[ "cargoship_pri_crewexpend" ]					= "cargoship_pri_crewexpend";
	//ten seounds
	level.scr_radio[ "cargoship_hp1_tensecondsradio" ]				= "cargoship_hp1_tensecondsradio";
	//radio check, going to secure channel
	level.scr_radio[ "cargoship_hp1_radiocheck" ]					= "cargoship_hp1_radiocheck";
	//green light, go go go
	level.scr_radio[ "cargoship_hp1_greenlightgoradio" ]			= "cargoship_hp1_greenlightgoradio";
		
//BRIDGE
	//take em out
	level.scr_radio[ "cargoship_pri_weaponsfree" ]					= "cargoship_pri_weaponsfree";
	//griggs, stay in the bird till we secure the deck, over
	level.scr_radio[ "cargoship_pri_holdyourfire" ]					= "cargoship_pri_holdyourfire";
	//roger that
	level.scr_radio[ "cargoship_grg_rogerthatradio" ]				= "cargoship_grg_rogerthatradio";
	//squad on me
	level.scr_radio[ "cargoship_pri_squadonme" ]					= "cargoship_pri_squadonme";

//QUARTERS
	//stairs clear
	level.scr_radio[ "cargoship_pri_stairsclear" ]					= "cargoship_pri_stairsclear";
	//hallway clear
	level.scr_radio[ "cargoship_pri_hallwayclear" ]					= "cargoship_pri_hallwayclear";
	//Crew quarters clear. Move up.
	level.scr_radio[ "cargoship_pri_crewquarters" ]					= "cargoship_pri_crewquarters";
	//move up
	level.scr_radio[ "cargoship_pri_moveup" ]						= "cargoship_pri_moveup";
	
//DECK
	//forward deck is clear, green light on alpha, go
	level.scr_radio[ "cargoship_hp1_forwarddeckradio" ]				= "cargoship_hp1_forwarddeckradio";
	//Ready sir.
	level.scr_radio[ "cargoship_grg_readysir" ]						= "cargoship_grg_readysir";
	//Fan out. Three metre spread.
	level.scr_radio[ "cargoship_pri_fanout" ]						= "cargoship_pri_fanout";
}

#using_animtree("generic_human");
anim_gen_human()
{
	level.scr_anim["patrol"]["idle"][0]							= %patrolstand_idle;
	
	//BRIDGE SEQUENCE	
	
	level.scr_anim["bridge_capt"]["idle"][0]		= %cargoship_stunned_coffee_react_idle;
	level.scr_anim["bridge_capt"]["react"]			= %cargoship_stunned_coffee_react;
	level.scr_anim["bridge_capt"]["death"]			= %cargoship_stunned_coffee_death;
	
	level.scr_anim["bridge_tv"]["idle"][0]			= %cargoship_stunned_tv_react_idle;
	level.scr_anim["bridge_tv"]["react"]			= %cargoship_stunned_tv_react;
	level.scr_anim["bridge_tv"]["death"]			= %cargoship_stunned_tv_death;
	
	level.scr_anim["bridge_clipboard"]["idle"][0]	= %cargoship_stunned_clipboard_react_idle;
	level.scr_anim["bridge_clipboard"]["react"]		= %cargoship_stunned_clipboard_react;
	level.scr_anim["bridge_clipboard"]["death"]		= %cargoship_stunned_clipboard_death;
	
	level.scr_anim["bridge_stand1"]["idle"][0]		= %cargoship_stunned_react_v2_idle;
	level.scr_anim["bridge_stand1"]["react"]		= %cargoship_stunned_react_v2;
	level.scr_anim["bridge_stand1"]["death"]		= %cargoship_stunned_react_v2_death;
	
	//QUARTERS SEQUENCE
	
	level.scr_anim["sleeper_0"]["sleep"][0]						= %melee_test_guy0_death_pose;
	level.scr_anim["sleeper_0"]["death"]						= %melee_test_guy0_death_pose;
	level.scr_anim["sleeper_1"]["sleep"][0]						= %melee_test_guy0_death_pose;
	level.scr_anim["sleeper_1"]["death"]						= %melee_test_guy0_death_pose;
	
	level.scr_anim["drunk"]["walk"]								= %cargoship_drunk_sequence;
	level.scr_anim["drunk"]["death"]							= %cargoship_drunk_sequence_death;
	
	level.scr_anim[ "price" ][ "door_breach_setup" ]			= %shotgunbreach_v1_shoot_hinge;
	level.scr_anim[ "price" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "price" ][ "door_breach_idle" ]				= %shotgunbreach_v1_shoot_hinge_ready_idle;
	level.scr_anim[ "price" ][ "door_breach" ]					= %shotgunbreach_v1_shoot_hinge_runin;

	level.scr_anim[ "alavi" ][ "door_breach_setup" ]			= %shotgunbreach_v1_stackB;
	level.scr_anim[ "alavi" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "alavi" ][ "door_breach_idle" ]				= %shotgunbreach_v1_stackB_ready_idle;
	level.scr_anim[ "alavi" ][ "door_breach" ]					= %shotgunbreach_v1_stackB_runin;
	
	//DECK
	
	level.scr_anim["smoker"]["idle"][0]							= %parabolic_leaning_guy_idle; 
	level.scr_anim["smoker"]["idle"][1]							= %parabolic_leaning_guy_twitch;  
	level.scr_anim["smoker"]["smoke"]							= %parabolic_leaning_guy_smoking_idle; 
	level.scr_anim["smoker"]["smoke2"]							= %parabolic_leaning_guy_smoking_twitch;							
	level.scr_anim["smoker"]["idle_to_smoke"]					= %parabolic_leaning_guy_trans2smoke;				
	level.scr_anim["smoker"]["smoke_to_idle"]					= %parabolic_leaning_guy_trans2idle;
	
	level.scr_anim[ "platform_center" ][ "talk" ] 				= %bog_a_tank_dialogue;
	level.scr_anim[ "platform_left" ][ "talk" ] 				= %bog_a_tank_dialogue_guyL;
	level.scr_anim[ "platform_right" ][ "talk" ] 				= %bog_a_tank_dialogue_guyR;

	level.scr_anim[ "platform_center" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_idle;
	level.scr_anim[ "platform_left" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_guyL_idle;
	level.scr_anim[ "platform_right" ][ "talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_guyR_idle;
	
	level.scr_anim[ "escape" ][ "blowback" ] 					= %backdraft;//death_run_onfront
	level.scr_anim[ "escape" ][ "path_slow" ] 					= %huntedrun_2;
	level.scr_anim[ "escape" ][ "sprint" ] 						= %sprint1_loop;
	
	level.scr_anim[ "escape" ][ "stumble1" ]					= %run_pain_fallonknee;
	level.scr_anim[ "escape" ][ "stumble2" ]					= %run_pain_stomach;
	level.scr_anim[ "escape" ][ "stumble3" ]					= %run_pain_fallonknee_02;
}

#using_animtree( "door" );
anim_door()
{
	level.scr_anim[ "door" ][ "door_breach" ] = 	%shotgunbreach_v1_shoot_hinge_door;
	level.scr_animtree[ "door" ] = #animtree;	
	level.scr_model[ "door" ] = "cs_cargoship_door_PUSH";
	precachemodel( level.scr_model[ "door" ] );
}
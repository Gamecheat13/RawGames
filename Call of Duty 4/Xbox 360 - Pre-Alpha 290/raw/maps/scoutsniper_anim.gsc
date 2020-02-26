#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialog();
	patrol();
}

anims()
{
	//GENERIC
	level.scr_anim[ "price" ][ "pronehide_dive" ]				= %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "price" ][ "pronehide_idle" ]				= %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "prone_2_run_roll" ]			= %hunted_pronehide_2_stand_v1;
		
	level.scr_anim[ "generic" ][ "moveout_cqb" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "moveup_cqb" ]					= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "stop_cqb" ]					= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "onme_cqb" ]					= %CQB_stand_wave_on_me;
	
	level.scr_anim[ "generic" ][ "moveout_exposed" ]			= %stand_exposed_wave_move_out;
	level.scr_anim[ "generic" ][ "moveup_exposed" ]				= %stand_exposed_wave_move_up;
	level.scr_anim[ "generic" ][ "stop_exposed" ]				= %stand_exposed_wave_halt;
	level.scr_anim[ "generic" ][ "stop2_exposed" ]				= %stand_exposed_wave_halt_v2;
	level.scr_anim[ "generic" ][ "onme_exposed" ]				= %stand_exposed_wave_on_me;
	level.scr_anim[ "generic" ][ "onme2_exposed" ]				= %stand_exposed_wave_on_me_v2;
	level.scr_anim[ "generic" ][ "enemy_exposed" ]				= %stand_exposed_wave_target_spotted;
	level.scr_anim[ "generic" ][ "down_exposed" ]				= %stand_exposed_wave_down;
	level.scr_anim[ "generic" ][ "go_exposed" ]					= %stand_exposed_wave_go;
	
	level.scr_anim[ "generic" ][ "moveout_cornerR" ]			= %CornerStndR_alert_signal_move_out;
	level.scr_anim[ "generic" ][ "stop_cornerR" ]				= %CornerStndR_alert_signal_stopStay_down;
	level.scr_anim[ "generic" ][ "onme_cornerR" ]				= %CornerStndR_alert_signal_on_me;
	level.scr_anim[ "generic" ][ "enemy_cornerR" ]				= %CornerStndR_alert_signal_enemy_spotted;
	
	level.scr_anim[ "generic" ][ "flash_cornerL" ]				= %corner_standL_grenade_B;
	level.scr_anim[ "generic" ][ "flash_cornerR" ]				= %corner_standR_grenade_B;
		
	level.scr_anim[ "generic" ][ "sprint" ]						= %sprint1_loop;		
	level.scr_anim[ "generic" ][ "run_2_stop" ]					= %run_2_stand_F_6;		
	level.scr_anim[ "generic" ][ "combat_idle" ][0]				= %stand_aim_straight;	//casual_stand_idle
	
	
	//INTRO 
	level.scr_anim[ "price" ][ "scoutsniper_opening_price" ]	= %scout_sniper_price_prone_opening;
//	level.scr_anim[ "price" ][ "wave" ] 						= %scout_sniper_price_wave;
//	level.scr_anim[ "price" ][ "wave_idle" ]					= %scout_sniper_price_wave_idle;
	
	level.scr_anim[ "generic" ][ "cellphone_idle" ][0]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "smoke_idle" ][0]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "coffee_idle" ][0]				= %cargoship_stunned_coffee_react_idle;
	
	level.scr_anim[ "generic" ][ "cellphone_reach" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "smoke_reach" ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "coffee_reach" ]				= %cargoship_stunned_coffee_react_idle;
	
	level.scr_anim[ "generic" ][ "coffee_react" ]				= %cargoship_stunned_coffee_react;
	level.scr_anim[ "generic" ][ "coffee_death" ]				= %cargoship_stunned_coffee_death;
	
	//CHURCH
	level.scr_anim[ "generic" ][ "open_door_slow" ]				= %hunted_open_barndoor;
	level.scr_anim[ "generic" ][ "open_door_slow_stop" ]		= %hunted_open_barndoor_stop;
	level.scr_anim[ "generic" ][ "open_door_kick" ]				= %doorkick_2_cqbwalk;	
	level.scr_anim[ "generic" ][ "cqb_look_around" ]			= %combatwalk_f_spin;
}

dialog()
{
	level.scr_radio[ "macmillan_standby" ]						= "scoutsniper_macmillan_standby";
	level.scr_radio[ "macmillan_moveup" ]						= "scoutsniper_macmillan_moveup";
	level.scr_radio[ "macmillan_go" ]							= "scoutsniper_macmillan_go";
	level.scr_radio[ "macmillan_move" ]							= "scoutsniper_macmillan_move";
	level.scr_radio[ "macmillan_onmymark" ]						= "scoutsniper_macmillan_onmymark";
	level.scr_radio[ "macmillan_onmygo" ]						= "scoutsniper_macmillan_onmygo";
	level.scr_radio[ "macmillan_iseeem" ]						= "scoutsniper_macmillan_iseeem";
	level.scr_radio[ "macmillan_watchmovement" ]				= "scoutsniper_macmillan_watchmovement";
	level.scr_radio[ "macmillan_getdown" ]						= "scoutsniper_macmillan_getdown";

//INTRO
	//theres too much radiation, we'll have to go around
	level.scr_radio[ "scoutsniper_mcm_radiation" ]				= "scoutsniper_mcm_radiation";
	//Follow me, and keep low.
	level.scr_radio[ "scoutsniper_mcm_followme" ]				= "scoutsniper_mcm_followme";
	//keep an eye on your dosimeter, if you're exposed too long you're dead
	level.scr_radio[ "scoutsniper_mcm_dosimeter" ]				= "scoutsniper_mcm_dosimeter";
	//standby
	level.scr_radio[ "scoutsniper_mcm_standby" ]				= "scoutsniper_mcm_standby";
	//Contact.
	level.scr_radio[ "scoutsniper_mcm_contact" ]				= "scoutsniper_mcm_contact";
	//wait here!
	level.scr_radio[ "scoutsniper_mcm_waithere" ]				= "scoutsniper_mcm_waithere";
	
	
	//Target approaching from the north.
	level.scr_radio[ "scoutsniper_mcm_targetnorth" ]			= "scoutsniper_mcm_targetnorth";
	//Target approaching from the south.
	level.scr_radio[ "scoutsniper_mcm_targetsouth" ]			= "scoutsniper_mcm_targetsouth";
	//Target approaching from the east.
	level.scr_radio[ "scoutsniper_mcm_targeteast" ]				= "scoutsniper_mcm_targeteast";
	//Target approaching from the west.
	level.scr_radio[ "scoutsniper_mcm_targetwest" ]				= "scoutsniper_mcm_targetwest";	
	
	//He's down.
	level.scr_radio[ "scoutsniper_mcm_hesdown" ]				= "scoutsniper_mcm_hesdown";
	//got him
	level.scr_radio[ "scoutsniper_mcm_gothim" ]					= "scoutsniper_mcm_gothim";
	//Good night.
	level.scr_radio[ "scoutsniper_mcm_goodnight" ]				= "scoutsniper_mcm_goodnight";
	
	//Move.
	level.scr_radio[ "scoutsniper_mcm_move" ]					= "scoutsniper_mcm_move";
	//ok go
	level.scr_radio[ "scoutsniper_mcm_okgo" ]					= "scoutsniper_mcm_okgo";
	//this way lets go
	level.scr_radio[ "scoutsniper_mcm_letsgo" ]					= "scoutsniper_mcm_letsgo";	
	//target eliminated
	level.scr_radio[ "scoutsniper_mcm_targetelim" ]				= "scoutsniper_mcm_targetelim";	
	//tango down
	level.scr_radio[ "scoutsniper_mcm_tangodown" ]				= "scoutsniper_mcm_tangodown";		
}

patrol()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;	
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	
	level.scr_anim[ "generic" ][ "patrol_jog" ]				= %patrol_jog;				
	level.scr_anim[ "generic" ][ "combat_jog" ]				= %combat_jog;		
	level.scr_anim[ "generic" ][ "patrol_jog_turn180" ]		= %patrol_jog_360;	
}

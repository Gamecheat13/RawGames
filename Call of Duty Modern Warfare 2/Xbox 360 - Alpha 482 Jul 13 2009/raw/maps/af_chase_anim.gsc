#using_animtree( "generic_human" );

main_anim()
{
	af_chase_vo();
}

af_chase_vo()
{
	level.scr_sound[ "generic" ][ "afchase_pri_zodiacnine" ] = "afchase_pri_zodiacnine";
	
	level.scr_radio[ "afchase_shp_stillalive" ] = "afchase_shp_stillalive";
	level.scr_radio[ "afchase_shp_doesntmatter" ] = "afchase_shp_doesntmatter";
	level.scr_radio[ "afchase_shp_tooambitious" ] = "afchase_shp_tooambitious";
	level.scr_radio[ "afchase_shp_winawar" ] = "afchase_shp_winawar";
	level.scr_radio[ "afchase_shp_weakerthanever" ] = "afchase_shp_weakerthanever";
	level.scr_radio[ "afchase_shp_likeisaid" ] = "afchase_shp_likeisaid";
	level.scr_radio[ "afchase_shp_sealthedeal" ] = "afchase_shp_sealthedeal";
	level.scr_radio[ "afchase_shp_dealinreality" ] = "afchase_shp_dealinreality";
	level.scr_radio[ "afchase_shp_tellthetruth" ] = "afchase_shp_tellthetruth";
	level.scr_radio[ "afchase_shp_wargoeson" ] = "afchase_shp_wargoeson";
	level.scr_radio[ "afchase_shp_tellaboutme" ] = "afchase_shp_tellaboutme";

	level.scr_sound[ "generic" ][ "afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "afchase_pri_cantlet" ] = "afchase_pri_cantlet";
	level.scr_sound[ "generic" ][ "afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "afchase_pri_aroundcorner" ] = "afchase_pri_aroundcorner";
	level.scr_sound[ "generic" ][ "afchase_pri_getonboat" ] = "afchase_pri_getonboat";
	level.scr_sound[ "generic" ][ "afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
	level.scr_sound[ "generic" ][ "afchase_pri_anotherchance" ] = "afchase_pri_anotherchance";
	level.scr_sound[ "generic" ][ "afchase_pri_wrongway" ] = "afchase_pri_wrongway";
	level.scr_sound[ "generic" ][ "afchase_pri_turntoobjective" ] = "afchase_pri_turntoobjective";
	level.scr_sound[ "generic" ][ "afchase_pri_wheregoing" ] = "afchase_pri_wheregoing";
	level.scr_sound[ "generic" ][ "afchase_pri_enemysix" ] = "afchase_pri_enemysix";
	level.scr_sound[ "generic" ][ "afchase_pri_zodiacsix" ] = "afchase_pri_zodiacsix";
	level.scr_sound[ "generic" ][ "afchase_pri_evasive" ] = "afchase_pri_evasive";
	level.scr_sound[ "generic" ][ "afchase_pri_enginesdead" ] = "afchase_pri_enginesdead";
	
	level.scr_sound[ "generic" ][ "afchase_pri_behindrocks" ] = "afchase_pri_behindrocks";
	level.scr_sound[ "generic" ][ "afchase_pri_miniguns" ] = "afchase_pri_miniguns";
	level.scr_sound[ "generic" ][ "afchase_pri_shakeemoff" ] = "afchase_pri_shakeemoff";
	level.scr_sound[ "generic" ][ "afchase_pri_threadtheneedle" ] = "afchase_pri_threadtheneedle";
	level.scr_sound[ "generic" ][ "afchase_pri_enemyboats" ] = "afchase_pri_enemyboats";
	level.scr_sound[ "generic" ][ "afchase_pri_openareas" ] = "afchase_pri_openareas";
	level.scr_sound[ "generic" ][ "afchase_pri_dodgedodge" ] = "afchase_pri_dodgedodge";
	level.scr_sound[ "generic" ][ "afchase_pri_leftleft" ] = "afchase_pri_leftleft";
	level.scr_sound[ "generic" ][ "afchase_pri_rightright" ] = "afchase_pri_rightright";
	level.scr_sound[ "generic" ][ "afchase_pri_left" ] = "afchase_pri_left";
	level.scr_sound[ "generic" ][ "afchase_pri_right" ] = "afchase_pri_right";
	level.scr_sound[ "generic" ][ "afchase_pri_rpgsonbridge" ] = "afchase_pri_rpgsonbridge";
	level.scr_sound[ "generic" ][ "afchase_pri_otherside" ] = "afchase_pri_otherside";
	level.scr_sound[ "generic" ][ "afchase_pri_technical" ] = "afchase_pri_technical";

	level.scr_sound[ "generic" ][ "dialog_helicopter_six2" ] = "dialog_helicopter_six2";
	level.scr_sound[ "generic" ][ "afchase_pri_dodgeheli" ] = "afchase_pri_dodgeheli";
	level.scr_sound[ "generic" ][ "afchase_pri_gunsspinup" ] = "afchase_pri_gunsspinup";
	level.scr_sound[ "generic" ][ "afchase_pri_steerclear" ] = "afchase_pri_steerclear";
	level.scr_sound[ "generic" ][ "afchase_pri_rapidsahead" ] = "afchase_pri_rapidsahead";
	level.scr_sound[ "generic" ][ "afchase_pri_fullpower" ] = "afchase_pri_fullpower";
	level.scr_sound[ "generic" ][ "afchase_pri_thrucave" ] = "afchase_pri_thrucave";

	level.scr_anim[ "generic" ][ "rapids_in" ] = %zodiac_rightside_rapids_trans_in;
	level.scr_anim[ "generic" ][ "rapids_loop" ][ 0 ] = %zodiac_rightside_rapids_loopB;
	level.scr_sound[ "generic" ][ "rapids_in" ] = "afchase_pri_rapidsahead";

	level.scr_anim[ "generic" ][ "left_afchase_pri_gettingaway" ] = %zodiac_rightside_wave_short;
	level.scr_anim[ "generic" ][ "left_afchase_pri_gogogo" ] = %zodiac_rightside_wave_short;
	level.scr_anim[ "generic" ][ "left_afchase_pri_cantlet" ] = %zodiac_rightside_wave;
	level.scr_anim[ "generic" ][ "left_afchase_pri_losinghim" ] = %zodiac_rightside_wave;
	level.scr_anim[ "generic" ][ "left_afchase_pri_drivingtheboat" ] = %zodiac_rightside_wave;
	level.scr_anim[ "generic" ][ "left_afchase_pri_fullpower" ] = %zodiac_rightside_wave;

	level.scr_anim[ "generic" ][ "right_afchase_pri_gettingaway" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_gogogo" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_cantlet" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_losinghim" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_drivingtheboat" ] = %zodiac_leftside_wave;
	level.scr_anim[ "generic" ][ "right_afchase_pri_fullpower" ] = %zodiac_leftside_wave;
	
	level.scr_sound[ "generic" ][ "right_afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "right_afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "right_afchase_pri_cantlet" ] = "afchase_pri_cantlet";
	level.scr_sound[ "generic" ][ "right_afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "right_afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
	level.scr_sound[ "generic" ][ "right_afchase_pri_fullpower" ] = "afchase_pri_fullpower";

	level.scr_sound[ "generic" ][ "left_afchase_pri_gettingaway" ] = "afchase_pri_gettingaway";
	level.scr_sound[ "generic" ][ "left_afchase_pri_gogogo" ] = "afchase_pri_gogogo";
	level.scr_sound[ "generic" ][ "left_afchase_pri_cantlet" ] = "afchase_pri_cantlet";
	level.scr_sound[ "generic" ][ "left_afchase_pri_losinghim" ] = "afchase_pri_losinghim";
	level.scr_sound[ "generic" ][ "left_afchase_pri_drivingtheboat" ] = "afchase_pri_drivingtheboat";
	level.scr_sound[ "generic" ][ "left_afchase_pri_fullpower" ] = "afchase_pri_fullpower";

	level.scr_anim[ "generic" ][ "shepherd_vanish_walk" ][0] = %afgan_chase_ending_search;
	level.scr_anim[ "generic" ][ "shepherd_vanish_sprint" ][0] = %afgan_chase_ending_search_spin;

	level.scr_anim[ "generic" ][ "price_into_boat" ] = %zodiac_jumpin;


//afgan_chase_ending_search – basic forward search loop
//afgan_chase_ending_search_spin – searching twitch where he spins to keep player from being able to sneak up on him as easily
//afgan_chase_ending_charge_back  -  for when player comes up from behind
//afgan_chase_ending_charge_front – if the player is to the front of the enemy

	level.scr_anim[ "generic" ][ "shepherd_search" ] = %afgan_chase_ending_search;
	level.scr_anim[ "generic" ][ "shepherd_search_spin" ] = %afgan_chase_ending_search_spin;
	level.scr_anim[ "generic" ][ "shepherd_charge_back" ] = %afgan_chase_ending_charge_back;
	level.scr_anim[ "generic" ][ "shepherd_charge_front" ] = %afgan_chase_ending_charge_front;

//	level.scr_anim[ "generic" ][ "run_2_melee_charge" ] = %run_2_melee_charge	;
	level.scr_anim[ "generic" ][ "run_2_melee_charge" ] = %freerunnerb_loop;


	level.scr_anim[ "shepherd" ][ "shepherd_search" ] = %afgan_chase_ending_search;
	level.scr_anim[ "shepherd" ][ "shepherd_search_spin" ] = %afgan_chase_ending_search_spin;
	level.scr_anim[ "shepherd" ][ "shepherd_charge_back" ] = %afgan_chase_ending_charge_back;
	level.scr_anim[ "shepherd" ][ "shepherd_charge_front" ] = %afgan_chase_ending_charge_front;
	
	level.scr_anim[ "generic" ][ "signal_onme" ]				= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop" ]				= %CQB_stand_signal_stop;	
	level.scr_anim[ "generic" ][ "signal_onme_cqb" ]				= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go_cqb" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop_cqb" ]				= %CQB_stand_signal_stop;	

	level.scr_anim[ "generic" ][ "walk_CQB_F" ]				= %walk_CQB_F;	
	
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_12" ] = "TF_pri_callout_targetclock_12";        
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_1" ] = "TF_pri_callout_targetclock_1";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_2" ] = "TF_pri_callout_targetclock_2";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_3" ] = "TF_pri_callout_targetclock_3";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_4" ] = "TF_pri_callout_targetclock_4";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_5" ] = "TF_pri_callout_targetclock_5";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_6" ] = "TF_pri_callout_targetclock_6";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_7" ] = "TF_pri_callout_targetclock_7";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_8" ] = "TF_pri_callout_targetclock_8";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_9" ] = "TF_pri_callout_targetclock_9";         
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_10" ] = "TF_pri_callout_targetclock_10";        
	level.scr_sound[ "generic" ][ "TF_pri_callout_targetclock_11" ] = "TF_pri_callout_targetclock_11";        
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_12" ] = "TF_pri_callout_yourclock_12";          
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_1" ] = "TF_pri_callout_yourclock_1";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_2" ] = "TF_pri_callout_yourclock_2";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_3" ] = "TF_pri_callout_yourclock_3";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_4" ] = "TF_pri_callout_yourclock_4";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_5" ] = "TF_pri_callout_yourclock_5";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_6" ] = "TF_pri_callout_yourclock_6";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_7" ] = "TF_pri_callout_yourclock_7";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_8" ] = "TF_pri_callout_yourclock_8";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_9" ] = "TF_pri_callout_yourclock_9";           
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_10" ] = "TF_pri_callout_yourclock_10";          
	level.scr_sound[ "generic" ][ "TF_pri_callout_yourclock_11" ] = "TF_pri_callout_yourclock_11";          

}
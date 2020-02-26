#include maps\_anim;
#using_animtree("generic_human");

main()
{
	level.scr_anim["hostile"]["patrol_twitch"]			= %patrolstand_twitch;
	
	level.scr_anim["hostile"]["phoneguy_idle_start"]			= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_idle"][0]				= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_alerted"]				= %parabolic_phoneguy_reaction;
	level.scr_anim["hostile"][ "phoneguy_death" ]			= %parabolic_knifekill_phoneguy;

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
}

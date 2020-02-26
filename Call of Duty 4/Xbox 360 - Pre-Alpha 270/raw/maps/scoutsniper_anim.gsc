#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	run_anims();
	dialogue();
}

anims()
{
	level.scr_anim[ "price" ][ "scoutsniper_opening_price" ]	= %scout_sniper_price_prone_opening;
	level.scr_anim[ "price" ][ "wave" ] 						= %scout_sniper_price_wave;
	level.scr_anim[ "price" ][ "wave_idle" ]					= %scout_sniper_price_wave_idle;
	
	level.scr_generic_anim[ "patrolwalk_pause" ] = %active_patrolwalk_pause;
	level.scr_generic_anim[ "patrolwalk_turn_180" ] = %active_patrolwalk_turn_180;
}

run_anims()
{
	/*level.scr_anim[ "axis" ][ "patrolwalk_1" ] = %active_patrolwalk_v1;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] = %active_patrolwalk_v2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] = %active_patrolwalk_v3;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] = %active_patrolwalk_v4;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] = %active_patrolwalk_v5;
	level.scr_anim[ "axis" ][ "patrolwalk_pause" ] = %active_patrolwalk_pause;
	level.scr_anim[ "axis" ][ "patrolwalk_turn" ] = %active_patrolwalk_turn_180;*/
}

dialogue()
{
}
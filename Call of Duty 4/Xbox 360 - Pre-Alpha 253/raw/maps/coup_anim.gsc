#include maps\_anim;


main()
{
	anim_gen_human();
	anim_player_rig();
}

#using_animtree("player");
anim_player_rig()
{
	level.scr_anim["player_rig"]["drag_loop"][0]= %coup_opening_playerview;
}

#using_animtree("generic_human");
anim_gen_human()
{
	
	
	level.scr_anim["driver"]["car_idle"][0]		= %bh_Pilot_idle;
	level.scr_anim["shotgun"]["car_idle"][0]	= %bh_Pilot_idle;
	level.scr_anim["left"]["car_idle"][0]		= %bh_Pilot_idle;
	level.scr_anim["right"]["car_idle"][0]		= %bh_Pilot_idle;
	
	level.scr_anim["shotgun"]["drag_loop"][0]	= %coup_opening_thug01;
	level.scr_anim["right"]["drag_loop"][0]		= %coup_opening_thug02;
}
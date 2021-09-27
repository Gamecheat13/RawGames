#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;


main()
{
	script_models();
	player_animations();

}

#using_animtree( "script_model" );
script_models()
{
	//tower collapse
	level.scr_animtree[ "tower" ]								= #animtree;
	level.scr_anim["tower"]["collapse"] 	= %ny_manhattan_radio_tower_fall;
	level.scr_anim["tower"]["idle"] 	= %ny_manhattan_radio_tower_pre_idle;
	
	
	
}

#using_animtree( "player" );
player_animations()
{
	level.scr_animtree[ "player_rig" ] 												= #animtree;
	level.scr_model[ "player_rig" ] 												= "viewhands_player_delta";
	level.scr_model[ "player_rig" ] 						= level.player_viewhand_model;
}

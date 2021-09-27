
main()
{
	models();
	vehicles();	
	props();
	generic_human();
	destructibles();
}

#using_animtree( "generic_human" );
generic_human()
{
	/*
	level.scr_anim[ "friendlytank_gunner" ][ "firing" ] =			%hamburg_tank_ambush_gunner;
	level.scr_anim[ "friendlytank_gunner" ][ "back_up" ] =			%hamburg_tank_ambush_gunner_backup;
	level.scr_anim[ "ambush_gunner1" ][ "jumpdown" ] =			%hamburg_tank_ambush_ambusher1_jumpdown;
	level.scr_anim[ "ambush_gunner2" ][ "jumpdown" ] =			%hamburg_tank_ambush_ambusher2_jumpdown;
	level.scr_anim[ "ambush_gunner2" ][ "death" ] =				%hamburg_tank_ambush_ambusher2_death;
	level.scr_anim[ "ambush_gunner3" ][ "jumpdown" ] =			%hamburg_tank_ambush_ambusher3_jumpdown;
	level.scr_anim[ "ambush_gunner3" ][ "death" ] =				%hamburg_tank_ambush_ambusher3_death;
	*/
}

#using_animtree( "script_model" );
models()
{
	// Swinging lamp
	level.scr_animtree[ "lamp" ] 									= #animtree;
	level.scr_model[ "lamp" ] 										= "ch_industrial_light_animated_01_on";
	level.scr_anim[ "lamp" ][ "swing" ] 							= %swinging_industrial_light_01_mild;
	level.scr_anim[ "lamp" ][ "swing_dup" ] 						= %swinging_industrial_light_01_mild_dup;
	level.scr_anim[ "lamp" ][ "swing_aggro" ] 						= %swinging_industrial_light_01_severe;
	level.scr_anim[ "lamp" ][ "swing_root" ] 							= %root;
	
}

#using_animtree( "vehicles" );
vehicles()
{
//	level.scr_anim[ "friendlytank_gunner_gun" ][ "firing" ] =			%hamburg_tank_ambush_gunner_minigun;
//	level.scr_anim[ "friendlytank_gunner_gun" ][ "back_up" ] =			%hamburg_tank_ambush_gunner_backup_minigun;
}

#using_animtree( "animated_props" );
props()
{
}


#using_animtree( "player" );
player_anims()
{
}

#using_animtree( "destructibles" );
destructibles()
{
	level.scr_animtree[ "tank_move_car" ] 		= #animtree;
	level.scr_anim[ "tank_move_car" ][ "rock" ] = %vehicle_80s_sedan1_destroy;
	level.scr_anim[ "tank_move_car" ][ "flat_tire" ] = %vehicle_80s_sedan1_flattire_RB;

	level.scr_anim[ "tank_move_car" ][ "root" ] = %root;
}


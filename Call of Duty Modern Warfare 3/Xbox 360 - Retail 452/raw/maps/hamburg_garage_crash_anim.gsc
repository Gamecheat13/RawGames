#include maps\_anim;

main()
{
	vehicles();
	props();
	player_anims();
	generic_human();
}

#using_animtree( "vehicles" );
vehicles()
{
	level.scr_animtree[ "post_crash_tank" ] 									= #animtree;
	level.scr_model[ "post_crash_tank" ] 										= "vehicle_m1a1_abrams_viewmodel_tread_stop";
	level.scr_anim[ "post_crash_tank" ][ "hamburg_tank_crash" ] = %hamburg_tank_crash;
	addNotetrack_customFunction( "post_crash_tank", "Tank_hit", ::big_quake , "hamburg_tank_crash" );
	addNotetrack_customFunction( "post_crash_tank", "car_hit", ::big_quake , "hamburg_tank_crash" );
}

#using_animtree( "animated_props" );
props()
{
	level.scr_animtree[ "garage_floor" ] 									= #animtree;
	level.scr_model[ "garage_floor" ] 										= "hamburg_garage_floor_01";
	level.scr_anim[ "garage_floor" ][ "collapse" ] 							= %hamburg_tank_crash_floor;
	
	level.scr_animtree[ "player_rig_gun" ] 					 		= #animtree;
	level.scr_model[ "player_rig_gun" ] 							= "weapon_m4_iw5";
	level.scr_anim[ "player_rig_gun" ][ "garage_crash_exit" ] 							= %hamburg_tank_crash_exit_gun;
	
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ] 					 		= #animtree;
	level.scr_model[ "player_rig" ] 						 = "viewhands_player_delta";
	level.scr_anim[ "player_rig" ][ "garage_crash_exit" ] 							= %hamburg_tank_crash_exit_upperbody;
	
	level.scr_animtree[ "player_rig_legs" ] 					 		= #animtree;
	level.scr_model[ "player_rig_legs" ] 							= "viewlegs_generic";
	level.scr_anim[ "player_rig_legs" ][ "garage_crash_exit" ] 							= %hamburg_tank_crash_exit_lowerbody;
}


#using_animtree( "generic_human" );
generic_human()
{
	level.scr_anim[ "generic" ][ "driver_after_fall" ]  = 									%hamburg_tank_driver_afterfall;
	level.scr_anim[ "generic" ][ "driver_after_fall_loop" ][0]  = 								%hamburg_tank_driver_afterfall_loop;
	//level.scr_anim[ "generic" ][ "hamburg_tank_driver_idle" ]  = 					%hamburg_tank_driver_idle;
	//level.scr_anim[ "generic" ][ "hamburg_tank_driver_take" ]  =					%hamburg_tank_driver_take;
	level.scr_anim[ "generic" ][ "loader_after_fall" ]  = 				%hamburg_tank_loader_afterfall;
	level.scr_anim[ "generic" ][ "loader_after_fall_loop" ][0]  = 			%hamburg_tank_loader_afterfall_loop;
	
	level.scr_anim[ "generic" ][ "loader_after_fall_exit" ]  = 				%hamburg_tank_loader_climbout;
	level.scr_anim[ "generic" ][ "driver_after_fall_exit" ]  = 				%hamburg_tank_driver_climbout;
	
}


big_quake( tank )
{
	Earthquake( 0.4, 0.85, tank.origin, 1500 );
}
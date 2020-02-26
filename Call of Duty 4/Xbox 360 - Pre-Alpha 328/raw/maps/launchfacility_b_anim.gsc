#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree( "generic_human" );


main()
{
	anims();
	blast_door();
	dialogue();
}

anims()
{

// Elevator
	level.scr_anim[ "grigsby" ][ "elevator_runin" ] =			%hunted_tunnel_guy1_runin;
	level.scr_anim[ "grigsby" ][ "elevator_idle" ][0] =			%hunted_tunnel_guy1_idle;

	level.scr_anim[ "price" ][ "elevator_runin" ] =				%hunted_tunnel_guy2_runin;
	level.scr_anim[ "price" ][ "elevator_idle" ][0] =			%hunted_tunnel_guy2_idle;
	
	level.scr_anim[ "price" ][ "elevator_runout" ] =			%hunted_tunnel_guy2_runout;
	level.scr_anim[ "grigsby" ][ "elevator_runout" ] =			%hunted_tunnel_guy1_runout;
	
	// blast door
	level.scr_anim[ "price" ][ "blast_door_runto" ]				= %launchfacility_b_blast_door_seq_approch;
	level.scr_anim[ "price" ][ "blast_door_wave" ][0]			= %launchfacility_b_blast_door_seq_waveidle;
	level.scr_anim[ "price" ][ "blast_door_close" ]				= %launchfacility_b_blast_door_seq_close;
}

#using_animtree("script_model");
blast_door()
{
	level.scr_animtree[ "door" ] 								= #animtree;
	level.scr_anim[ "door" ][ "blast_door_close" ]				= %launchfacility_b_blast_door_seq_close_door;
}

dialogue()
{
// Air duct at the beginning of the level.
	// Vent01
	level.scr_radio[ "letsmove" ]				 	= "launchfacility_b_pri_letsmove";
	level.scr_radio[ "basesecurity" ] 				= "launchfacility_b_gm1_basesecurity";
	level.scr_radio[ "invents" ] 					= "launchfacility_b_pri_invents";
	level.scr_radio[ "gm1_copythat" ] 				= "launchfacility_b_gm1_copythat";
	
	
	// Vent02
	level.scr_radio[ "heavyresistance" ]		 	= "launchfacility_b_gm2_heavyresistance";	
	level.scr_radio[ "gaincontrol" ] 				= "launchfacility_b_pri_gaincontrol";
	level.scr_radio[ "regroup" ] 					= "launchfacility_b_gm2_regroup";
	
	
// Locker Room/Showers
	level.scr_radio[ "15mins" ] 					= "launchfacility_b_hqr_15mins";
	level.scr_radio[ "11mins" ] 					= "launchfacility_b_hqr_11mins";
	level.scr_radio[ "9mins" ] 						= "launchfacility_b_hqr_9mins";
	level.scr_radio[ "pri_copythat" ] 				= "launchfacility_b_pri_copythat";


// Barracks and kitchen area
//	level.scr_sound[ "xxxxxxxxxxxxxxx" ] 			= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";


// Storage Area
	level.scr_radio[ "grg_gottamove" ] 				= "launchfacility_b_grg_gottamove"; 


// Hallway between stoage area and launch tubes

	
// Launch Tubes
	level.scr_radio[ "grg_5" ] 						= "launchfacility_b_grg_5";
	level.scr_radio[ "startedcountdown" ] 			= "launchfacility_b_pri_startedcountdown";
	level.scr_radio[ "pri_movemove" ] 				= "launchfacility_b_pri_movemove";
	level.scr_radio[ "pri_gogogo1" ] 				= "launchfacility_b_pri_gogogo1";
	
	
// Vault Doors
	// Trapped at the vault doors
	level.scr_radio[ "controlbasesec" ] 			= "launchfacility_b_gm1_controlbasesec";
	level.scr_sound[ "price" ][ "pri_atdoor" ]		= "launchfacility_b_pri_atdoor";
	level.scr_radio[ "workinonit" ] 				= "launchfacility_b_gm1_workinonit";
	level.scr_radio[ "almostthere" ] 				= "launchfacility_b_gm1_almostthere";
	level.scr_radio[ "gotit" ] 						= "launchfacility_b_gm1_gotit";
	
	// Vault doors are opening.
	level.scr_sound[ "grigsby" ][ "grg_shittinme" ]	= "launchfacility_b_grg_shittinme";
	

// Utility Area
//	level.scr_sound[ "xxxxxxxxxxxxxxx" ] 			= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";


// Maintance room
	//Planting the C4
	level.scr_radio[ "status" ]						= "launchfacility_b_pri_status";
	level.scr_radio[ "gm2_inposition" ] 			= "launchfacility_b_gm2_inposition";
	level.scr_radio[ "prepbreach" ] 				= "launchfacility_b_pri_prepbreach";
	level.scr_radio[ "grg_inposition" ] 			= "launchfacility_b_grg_inposition";
	level.scr_radio[ "pri_plantexplos" ] 			= "launchfacility_b_pri_plantexplos";

	
	// Wall blown
	level.scr_radio[ "movingin" ] 					= "launchfacility_b_gm2_movingin";
	level.scr_radio[ "pri_gogogo2" ] 				= "launchfacility_b_pri_gogogo2";		
	
	
// Control Room
	level.scr_radio[ "grg_clearR" ] 				= "launchfacility_b_grg_clearR";
	level.scr_radio[ "entercodes" ] 				= "launchfacility_b_pri_entercodes";
	level.scr_radio[ "destroyed" ] 					= "launchfacility_b_hqr_destroyed";	
	level.scr_radio[ "checkfeed" ] 					= "launchfacility_b_gm2_checkfeed";
	level.scr_sound[ "grigsby" ][ "grg_company" ] 	= "launchfacility_b_grg_company";
	level.scr_radio[ "extractionpoint" ] 			= "launchfacility_b_pri_extractionpoint";
	level.scr_radio[ "sendcoordinates" ] 			= "launchfacility_b_gm1_sendcoordinates";
	level.scr_radio[ "vehicledepot" ] 				= "launchfacility_b_pri_vehicledepot";


// Escape hallway
	level.scr_radio[ "exfilfromarea" ] 				= "launchfacility_b_hqr_exfilfromarea";

// Elevator
	level.scr_sound[ "price" ][ "pri_movemove" ] 	= "launchfacility_b_pri_movemove";
	level.scr_radio[ "pri_movemove" ] 				= "launchfacility_b_pri_movemove";
	level.scr_radio[ "takinfire" ] 					= "launchfacility_b_gm1_takinfire";
	level.scr_radio[ "upthelift" ] 					= "launchfacility_b_pri_upthelift";


// Vehicle Depot
 	level.scr_radio[ "takinfire" ] 					= "launchfacility_b_gm1_takinfire"; 
	level.scr_radio[ "letsgo" ] 					= "launchfacility_b_pri_letsgo";
	level.scr_radio[ "grg_move" ] 					= "launchfacility_b_grg_move";


// Grigsby Countdown spam
	level.scr_radio[ "grg_10" ] 					= "launchfacility_b_grg_10";
	level.scr_radio[ "grg_8" ] 						= "launchfacility_b_grg_8";
	level.scr_radio[ "grg_6" ] 						= "launchfacility_b_grg_6";
	level.scr_radio[ "grg_5" ] 						= "launchfacility_b_grg_5";
	level.scr_radio[ "grg_4" ] 						= "launchfacility_b_grg_4";
	level.scr_radio[ "grg_3" ] 						= "launchfacility_b_grg_3";
}


// 	Examples:
//	level.scr_radio[ "xxxxxxxxxx" ] 				= "launchfacility_b_xxx_xxxxxxxxxx";
//	level.scr_sound[ "xxxxxx" ][ "xxxxxx" ]			= "launchfacility_b_xxx_xxxxxxxxxx";
//	level.scr_sound[ "xxxxxxxxxxxxxxx" ] 			= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

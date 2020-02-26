#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialogue();
}

anims()
{

	// Tunnel
	level.scr_anim[ "grigsby" ][ "elevator_runin" ] =			%hunted_tunnel_guy1_runin;
	level.scr_anim[ "grigsby" ][ "elevator_idle" ][0] =			%hunted_tunnel_guy1_idle;


	level.scr_anim[ "price" ][ "elevator_runin" ] =				%hunted_tunnel_guy2_runin;
	level.scr_anim[ "price" ][ "elevator_idle" ][0] =			%hunted_tunnel_guy2_idle;
	
	level.scr_anim[ "price" ][ "elevator_runout" ] =			%hunted_tunnel_guy2_runout;
	level.scr_anim[ "grigsby" ][ "elevator_runout" ] =			%hunted_tunnel_guy1_runout;
}

dialogue()
{
// Air duct at the beginning of the level.
	
	// Vent01
	level.scr_radio[ "letsmove" ] =				"launchfacility_b_pri_letsmove";
	level.scr_radio[ "basesecurity" ] =			"launchfacility_b_gm1_basesecurity";
	level.scr_radio[ "invents" ] =				"launchfacility_b_pri_invents";
	level.scr_radio[ "copythat" ] =				"launchfacility_b_gm1_copythat";
	
	// Vent02
	level.scr_radio[ "heavyresistance" ] =		"launchfacility_b_gm2_heavyresistance";	
	level.scr_radio[ "gaincontrol" ] =			"launchfacility_b_pri_gaincontrol";
	level.scr_radio[ "regroup" ] =				"launchfacility_b_gm2_regroup";
	
// Locker Room/Showers

	level.scr_radio[ "15mins" ] =				"launchfacility_b_hqr_15mins";
	level.scr_radio[ "11mins" ] =				"launchfacility_b_hqr_11mins";
	level.scr_radio[ "9mins" ] =				"launchfacility_b_hqr_9mins";
//	level.scr_radio[ "copythat" ] =				"launchfacility_b_hqr_copythat";


// Storage Area


// Launch Tubes


// Vault Doors: Team is trapped in the hallway waiting for Team 2 to get the vault doors open.

	// Trapped at the vault doors
	level.scr_radio[ "controlbasesec" ] =		"launchfacility_b_gm1_controlbasesec";
	level.scr_radio[ "atdoor" ] =				"launchfacility_b_pri_atdoor";
	level.scr_radio[ "workinonit" ] =			"launchfacility_b_gm1_workinonit";
	level.scr_radio[ "almostthere" ] =			"launchfacility_b_gm1_almostthere";
	level.scr_radio[ "gotit" ] =				"launchfacility_b_gm1_gotit";
	
	// Vault doors are opening.


// Utility Area

	// Maintance room
	
	
// Control Room


// Elevator


// Vehicle Depot


}
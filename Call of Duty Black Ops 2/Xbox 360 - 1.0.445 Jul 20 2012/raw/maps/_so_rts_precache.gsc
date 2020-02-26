#include common_scripts\utility;
#include maps\_utility;
#insert raw\maps\_so_rts.gsh;

main()
{
	// fx

	// textures
	precacheshader("compassping_enemydirectional");

	// weapons
	PrecacheItem( "metalstorm_mms_rts" );
	PrecacheItem("frag_grenade_future_sp");
	
	
	// LUI Notifies
	PrecacheString( &"rts_add_friendly_ai" );
	PrecacheString( &"rts_add_friendly_human" );
	PrecacheString( &"rts_add_poi" );
	PrecacheString( &"rts_del_poi");
	PrecacheString( &"rts_add_squad" );
	PrecacheString( &"rts_remove_squad" );
	PrecacheString( &"rts_captured_poi" );
	PrecacheString( &"rts_deselect" );
	PrecacheString( &"rts_deselect_enemy" );
	PrecacheString( &"rts_deselect_poi" );
	PrecacheString( &"rts_deselect_squad" );
	PrecacheString( &"rts_highlight" );
	PrecacheString( &"rts_hud_visibility" );
	PrecacheString( &"rts_move_squad_marker" );
	PrecacheString( &"rts_protect_poi" );
	PrecacheString( &"rts_update_pos_poi" );
	PrecacheString( &"rts_remove_ai" );
	PrecacheString( &"rts_secure_poi" );
	PrecacheString( &"rts_select_squad" );
	PrecacheString( &"rts_squad_start_attack" );
	PrecacheString( &"rts_squad_start_attack_poi" );
	PrecacheString( &"rts_squad_stop_attack" );
	PrecacheString( &"rts_target" );
	PrecacheString( &"rts_target_enemy" );
	PrecacheString( &"rts_target_poi" );
	PrecacheString( &"rts_time_left" );
	PrecacheString( &"rts_update_health" );
	PrecacheString( &"rts_poi_prog" );
	PrecacheString( &"rts_airstrike_avail_in" );
	PrecacheString( &"rts_predator_hud");
	
	// Countdown Headers
	PrecacheString( &"SO_RTS_MISSION_TIME_REMAINING_CAPS" );
}


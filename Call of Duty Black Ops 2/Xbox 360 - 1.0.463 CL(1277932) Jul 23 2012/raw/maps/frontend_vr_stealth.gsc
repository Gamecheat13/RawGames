/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 6/13/2012
 * Time: 3:52 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;

main()
{
	trigger_on( "vr_start_trigger" );
	
	trigger_wait( "vr_start_trigger" );
	
	load_gump( "frontend_gump_vr" );
	
	skipto_teleport_players( "vr_horde_start" );
	
	toggle_vr_combat( true );
}
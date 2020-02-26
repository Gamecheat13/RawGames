/*
 * Created by ScriptDevelop.
 * User: glocke
 * Date: 5/24/2012
 * Time: 2:36 PM
 * 
 * HANDLES THE DIALOG IN THE SLUMS
 */
																																																	
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\panama_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\panama_2_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/*
 * 
 *  VERY SCRIPTED EVENT DIALOG (AKA NOT BATTLE DIALOG)
 * 
 * 
 */

//-- first read of the slums
dialog_intro_to_slums()
{
	level.player queue_dialog( 	"wood_us_forces_are_pushin_0" );
	level.mason queue_dialog( "maso_we_push_north_watc_0" );
}

//-- building collapses
dialog_building_collapse()
{
	level.mason queue_dialog( "maso_building_s_coming_do_0" );
	level.mason queue_dialog( "maso_move_0" );
}



/*
 * 
 *  BATTLE DIALOG
 * 
 * 
 */
/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 7/13/2012
 * Time: 3:53 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
 
#include maps\_utility;
#include maps\_scene;
#include maps\_endmission;

#include maps\frontend_util;
#include maps\war_room_util;

#insert raw\maps\level_progression.gsh;

#define HOLO_TABLE_EXPLODER		(111)

run_briefing()
{
	level endon( "frontend_reset_scene" );
	skip_intro = true;
	load_gump( "frontend_gump_sf_a" );
	
	skip_intro = level.player get_story_stat( "SO_WAR_HUB_TWO_INTRO" ) != 0;
	
	level thread scene_player( ::scene_pre_briefing, skip_intro, skip_intro );
}

scene_pre_briefing()
{
	level thread scene_pre_briefing_audience();
	run_scene( "sf_player_intro" );
	level.player set_story_stat( "SO_WAR_HUB_TWO_INTRO", true );
}

scene_pre_briefing_audience()
{
	run_scene( "sf_audience_intro" );
	level thread run_scene( "sf_audience_loop" );
}
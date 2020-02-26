/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 5/31/2012
 * Time: 9:18 PM
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

// SO_WAR_HUB_ONE_INTRO,
// SO_WAR_HUB_TWO_INTRO,
// SO_WAR_HUB_THREE_INTRO,
run_briefing()
{
	level endon( "frontend_reset_scene" );
	skip_intro = true;
	load_gump( "frontend_gump_sf_a" );
	
	skip_intro = level.player get_story_stat( "SO_WAR_HUB_ONE_INTRO" ) != 0;
	
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

// SO_WAR_SINGAPORE_INTRO,
// SO_WAR_CARRIER_INTRO,
// SO_WAR_AFGHANISTAN_INTRO,
// SO_WAR_DRONE_INTRO,
// SO_WAR_SOCOTRA_INTRO,
// SO_WAR_PAKISTAN_INTRO,
scene_dockside_briefing()
{
	const briefing_scene_name = "so_rts_mp_dockside_briefing";
	const briefing_stat_name = "SO_WAR_SINGAPORE_INTRO";
	
	skip_briefing = level.player get_story_stat( briefing_stat_name ) != 0;

	if ( !skip_briefing )
	{
		run_scene( briefing_scene_name );
		level.player set_story_stat( briefing_stat_name, true );
	}
}


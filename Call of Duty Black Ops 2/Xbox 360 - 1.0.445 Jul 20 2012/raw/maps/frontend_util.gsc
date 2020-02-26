/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 4/10/2012
 * Time: 6:11 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;
#include maps\_endmission;
#include common_scripts\utility;
#include maps\war_room_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\level_progression.gsh;

#define HOLO_TABLE_EXPLODER		(111)
	
#define Default_Near_Start 0
#define Default_Near_End 1
#define Default_Far_Start 8000
#define Default_Far_End 10000
#define Default_Near_Blur 6
#define Default_Far_Blur 0

#define MENUSTATE_DISABLED		-1
#define MENUSTATE_NONE			0
#define MENUSTATE_MAIN			1
#define MENUSTATE_SECRET		2
#define MENUSTATE_STRIKEFORCE	3

attach_drone_collision()
{
	if ( level.m_drone_collision.size == 0 )
	{
		AssertMsg( "Frontend: Out of drone collision brushmodels.  Please make more or be more conservative." );
		return;
	}
	
	// grab the last one off the list and remove it from the list.
	collision = level.m_drone_collision[level.m_drone_collision.size-1];
	ArrayRemoveIndex( level.m_drone_collision, level.m_drone_collision.size-1, false );
	
	collision.origin = self GetTagOrigin( "tag_origin" );
	collision LinkTo( self, "tag_origin" );
	self.m_collision = collision;
}

detach_drone_collision()
{
	if ( !isdefined(self.m_collision) )
		return;
	
	ArrayInsert( level.m_drone_collision, self.m_collision, level.m_drone_collision.size );
	self.m_collision = undefined;
}

get_previous_map()
{
	if ( !isdefined( level.m_prev_map ) )
	{
		level.m_prevmap = GetDvar( "ui_aarmapname" );
	}
	
	return level.m_prevmap;
}

frontend_do_save()
{
	do_save = GetDvarInt( "ui_dofrontendsave" );
	if ( IsDefined( do_save ) && do_save == 1 )
	{
		SaveGame( "auto" );
		SetDvarInt( "ui_dofrontendsave", 0 );
	}
}

frontend_just_finished_rts()
{
	str_prev_level = get_previous_map();
	if ( !isdefined( str_prev_level ) )
	{
		return false;
	}
	
	return IsSubStr( str_prev_level, "so_rts" );
}

on_player_connect()
{
	// Have to delay to disable weapons.	
	wait_network_frame();
	
	level.player TakeAllWeapons();
	level.player DisableWeapons();
	level.player AllowPickupWeapons( false );
	level.player AllowSprint( false );
	level.player AllowJump( false );
	
	level.player init_viewarm();
	
	level.m_rts_stats = [];
	level.m_rts_stats["so_rts_mp_dockside"]		= "SO_WAR_SINGAPORE_SUCCESS";
	level.m_rts_stats["so_rts_mp_carrier"]		= "SO_WAR_CARRIER_SUCCESS";
	level.m_rts_stats["so_rts_afghanistan"]		= "SO_WAR_AFGHANISTAN_SUCCESS";
	level.m_rts_stats["so_rts_mp_drone"]		= "SO_WAR_DRONE_SUCCESS";
	level.m_rts_stats["so_rts_mp_socotra"]		= "SO_WAR_SOCOTRA_SUCCESS";
	level.m_rts_stats["so_rts_mp_overflow"]		= "SO_WAR_PAKISTAN_SUCCESS";
	
	flag_set( "strikeforce_stats_loaded" );
}

rts_map_completed( str_map_name )
{
	str_stat_name = level.m_rts_stats[ str_map_name ];
	assert( isdefined( str_stat_name ) );
	stat_val = level.player get_story_stat( str_stat_name );
	return stat_val != 0;
}

no_grenade_bag_drop()
{
	// every axis resets this value when spawned, am forcing this here
	level.nextGrenadeDrop	= 100000;	// no grenade bag drop!	
}

warp_to_random_player_start()
{
	start_list = array( "player_start_01", "player_start_02", "player_start_03", "player_start_04" );
	s_warp = GetStruct( random( start_list ) );
	skipto_teleport_players( s_warp.targetname );
	
	level.e_player_align.origin = s_warp.origin;
	level.e_player_align.angles = FLAT_ANGLES( s_warp.angles );
}

warp_to_default_player_start()
{
	s_warp = GetStruct( "default_player_start" );
	skipto_teleport_players( s_warp.targetname );
	
	level.e_player_align.origin = s_warp.origin;
	level.e_player_align.angles = FLAT_ANGLES( s_warp.angles );
}

get_level_number_completed()
{
	return level.player GetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue" );
}

get_level_completed()
{
	highest_level = level.player GetDStat( "PlayerStatsList", "HIGHESTLEVELCOMPLETED", "statValue" );

	return TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,highest_level,LEVEL_PROGRESSION_LEVEL_NAME);
}

get_level_name(cur_level)
{
	return TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_LEVEL_NAME);
}

start_patrollers()
{
	patrollers = simple_spawn( "idle_patroller" );
	foreach ( ai in patrollers )
	{
		ai.disable_melee = true;
		ai thread maps\_patrol::patrol( ai.target );
	}
}

init_viewarm()
{	
	self.is_glove_shown = false;
	//toggle_viewarm( true );
}
	
lerp_dof_over_time( time, FOV_On_Near_Start=Default_Near_Start, FOV_On_Near_End=Default_Near_End, FOV_On_Far_Start=Default_Far_Start, FOV_On_Far_End=Default_Far_End, FOV_On_Near_Blur=Default_Near_Blur, FOV_On_Far_Blur=Default_Far_Blur )
{
	current_Near_Start = self GetDepthOfField_NearStart();
	current_Near_End = self GetDepthOfField_NearEnd();
	current_Far_Start = self GetDepthOfField_FarStart();
	current_Far_End = self GetDepthOfField_FarEnd();
	current_Near_Blur = self GetDepthOfField_NearBlur();
	current_Far_Blur = self GetDepthOfField_FarBlur();
	
	New_Near_Start = FOV_On_Near_Start;
	New_Near_End = FOV_On_Near_End;
	New_Far_Start = FOV_On_Far_Start;
	New_Far_End = FOV_On_Far_End;
	New_Near_Blur = FOV_On_Near_Blur;
	New_Far_Blur = FOV_On_Far_Blur;
	
	incs = int( time/.05 );
	
	incNearStart = ( New_Near_Start - current_Near_Start ) / incs;
	incNearEnd = ( New_Near_End - current_Near_End ) / incs;
	incFarStart = ( New_Far_Start - current_Far_Start ) / incs;
	incFarEnd = ( New_Far_End - current_Far_End ) / incs;
	incNearBlur = ( New_Near_Blur - current_Near_Blur ) / incs;
	incFarBlur = ( New_Far_Blur - current_Far_Blur ) / incs;
	
	for ( i = 0; i < incs; i++ )
	{
		self SetDepthOfField( current_Near_Start, current_Near_End, current_Far_Start, current_Far_End, current_Near_Blur, current_Far_Blur );	
		
		current_Near_Start += incNearStart;
		current_Near_End += incNearEnd;
		current_Far_Start += incFarStart;
		current_Far_End += incFarEnd;
		current_Near_Blur += incNearBlur;
		current_Far_Blur += incFarBlur;
		
		wait .05;
	}
}

data_glove_input()
{
	self endon( "menu_closed" );
	while ( true )
	{
		if (level.player ButtonPressed("BUTTON_A") || level.player ButtonPressed("BUTTON_B") || level.player ButtonPressed("BUTTON_X") || level.player ButtonPressed("BUTTON_Y"))
		{
			level thread run_scene( "data_glove_input" );
			scene_wait( "data_glove_input" );
			
			while ( level.player ButtonPressed("BUTTON_A") || level.player ButtonPressed("BUTTON_B") || level.player ButtonPressed("BUTTON_X") || level.player ButtonPressed("BUTTON_Y") )
			{
				wait_network_frame();
			}
		}
		wait_network_frame();
	}
}

frontend_rts_level_respond()
{
	const num_responses = 1;
	scene_num = 1; //RandomIntRange( 1, num_responses );
	
	scene_name = "";
	end_anim_name = "";
	
	flag_wait( "strikeforce_stats_loaded" );

	//hide the free roam menu
	start_strikeforce_sequence();
	
	last_map = get_previous_map();
	success = rts_map_completed( last_map );
	if ( success )
	{
		scene_name = "briggs_rts_positive_" + scene_num;
		end_anim_name = "briggs_rts_positive_exit";
	}
	else
	{
		scene_name = "briggs_rts_negative_" + scene_num;
		end_anim_name = "briggs_rts_negative_exit";
	}
	
	// Scene of briggs telling you're either awesome or lame.
	run_scene( scene_name );
	run_scene( end_anim_name );
	
	level thread scene_player( undefined, true, false,true );
}

// 1 means this is our last chance.
// 0 means our chance has passed.
//
strikeforce_get_num_levels_till_gone( campaign_level_num, rts_level_name )
{
	end_level = int ( TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_NAME,rts_level_name,LEVEL_PROGRESSION_RTSEND) );
	if ( campaign_level_num >= end_level )
		return 0;
	
	cur_level_type = "";
	chances_remaining = 0;
	for ( cur_level = campaign_level_num; cur_level < end_level; cur_level++ )
	{
		cur_level_type = TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_INDEX,cur_level,LEVEL_PROGRESSION_MAPTYPE);
		if ( cur_level_type == "CMP" )
			chances_remaining++;
		else if ( cur_level_type == "RTS" )
			break;
	}
	
	return chances_remaining;
}

show_table_objective( t_table, do_show )
{
//	set_objective( level.OBJ_WAR_ROOM, t_table, "breadcrumb" );
	if ( do_show )
		level.player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", 64 );
	else
		level.player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", 2048 );
}

// player_scene_name: name of the briefing scene for the player.
// skip_intro: skips the intro animation
// use_trigger_start: skips the intro animation AND requires the player to approach and use the table trigger.
//
scene_player( pre_briefing_func, skip_intro = false, use_trigger_start = false, start_attached=false )
{
	level endon( "frontend_reset_scene" );

//	t_doorway = GetEnt( "war_room_trigger", "targetname" );
	t_table = GetEnt( "table_interact_trigger", "targetname" );
	
	//only show the interaction when there are available levels - always at least show something on the table
	last_level = get_level_number_completed();
	map_list = get_strikeforce_available_level_list(last_level + 1);
	
	if (map_list.size<=0 || get_strikeforce_tokens_remaining()<=0 || GetDvarInt( "ui_campaignstate")==0 )
	{
		trigger_off( "table_interact_trigger" );
		show_table_objective( t_table, false );
		return ;
	}
	
	show_table_objective( t_table, true );
	trigger_on( "table_interact_trigger" );
	
	if ( use_trigger_start )
	{
		set_objective( level.OBJ_WAR_ROOM, t_table, "breadcrumb" );
		
		trigger_wait( "table_interact_trigger" );

		start_strikeforce_sequence();
		
		trigger_off( "table_interact_trigger" );
		show_table_objective( t_table, false );
		
	} 
	else if ( !skip_intro ) 
	{
		set_objective( level.OBJ_WAR_ROOM, t_table, "breadcrumb" );
		
		trigger_wait( "war_room_trigger" );
		
		start_strikeforce_sequence();
		
		flag_clear( "glasses_toggling_enabled" );
		
		trigger_off( "table_interact_trigger" );
		show_table_objective( t_table, false );
		
		// Play the pre-breifing.
		if ( isdefined( pre_briefing_func ) )
			[[pre_briefing_func]]();
	}
	else if (start_attached)
	{
		trigger_off( "table_interact_trigger" );
		show_table_objective( t_table, false );
	}
	
	exploder( HOLO_TABLE_EXPLODER );
	show_globe( true );
	
	can_reenter = true;
	while ( can_reenter )
	{
		flag_clear( "glasses_toggling_enabled" );
		
		can_reenter = scene_level_select(map_list);
		
		flag_set( "glasses_toggling_enabled" );
		
		stop_exploder( HOLO_TABLE_EXPLODER );
		show_globe( false, true );
		
		if ( can_reenter )
		{
			trigger_on( "table_interact_trigger" );
			show_table_objective( t_table, true );
			trigger_wait( "table_interact_trigger" );
			start_strikeforce_sequence();
			show_table_objective( t_table, false );
			trigger_off( "table_interact_trigger" );
			
			exploder( HOLO_TABLE_EXPLODER );
			show_globe( true );
		}
	}
}

start_strikeforce_sequence()
{
	LUINotifyEvent(&"hide_freeroammenu");
	level.menuState=MENUSTATE_STRIKEFORCE;
}

// Returns true if you can re-enter.  False if not.
//
scene_level_select(map_list)
{
	level thread run_scene( "sf_player_choice" );
	level thread run_scene( "sf_briggs_idle" );
	
	selection = rts_hologram_on( map_list );
	
	if ( selection == "nomaps" )
	{
		level thread run_scene( "sf_audience_exit" );
		wait 3.0;
		run_scene( "sf_table_to_corner" );
		return false;
	}
	else if ( selection == "cancel" )
	{
		run_scene( "sf_table_to_corner" );
	}
	else
	{
		SetDvar("ui_aarmapname",selection);
		ChangeLevel( selection );
	}
	
	return true;
}

get_glasses_toggle_buttonPressed()
{
	toggleButton = "BUTTON_RTRIG";

	// check the button name every time rather than querying it once at the top of
	// the while loop because the user can switch controllers while the menu is open

	if( !level.console && !self GamepadUsedLast() )
	{
		toggleButton = "SPACE";
	}
	else if ( level.wiiu && self getcontrollertype() == "remote" )
	{
		toggleButton = "BUTTON_Y";	// y == 1 on wiiu remote
	}

	return self ButtonPressed( toggleButton );
}


get_secret_menu_buttonPressed()
{
	toggleButton = "BUTTON_LTRIG";
	
	// check the button name every time rather than querying it once at the top of
	// the while loop because the user can switch controllers while the menu is open

	if( !level.console && !self GamepadUsedLast() )
	{
		toggleButton = "BACKSPACE";
	}

	return self ButtonPressed( toggleButton );
}

//polling for the right trigger input
//
run_glasses_input()
{
	level endon( "disconnect" );

	while( 1 )
	{
		switch (level.menuState)
		{
		case MENUSTATE_NONE:
			if (level.player get_secret_menu_buttonPressed())
			{
				//blocking call - really no need to ever set menustate_secret, it's just included for completeness
				do_secret_menu();
			}
			else if (level.player get_glasses_toggle_buttonPressed())
			{
				toggle_main_menu();
				level.menuState=MENUSTATE_MAIN;
			}
			break;
		case MENUSTATE_MAIN:
			if (level.player get_glasses_toggle_buttonPressed())
			{
				toggle_main_menu();
				level.menuState=MENUSTATE_NONE;
			}
			break;
		case MENUSTATE_SECRET:
			//do_secret_menu() is a blocking call - really no need to ever set menustate_secret, it's just included for completeness
			break;
		case MENUSTATE_STRIKEFORCE:
			//strikeforce state is set and cleared elsewhere
			break;
		}
		wait(0.05);
	}
}

scene_glasses_on()
{
	level run_scene_first_frame("glasses_on");
	
	flag_wait_any( "lockout_screen_passed", "lockout_screen_skipped", "lockout_screen_skipped_freeroam" );
	
	level thread run_scene("glasses_on");
	
	wait_network_frame();
	
	//-- help the glasses clip the screen closer to the camera
	glasses = get_model_or_models_from_scene("glasses_on", "glasses");
	glasses setviewmodelrenderflag( true );
}

turn_on_glasses( glasses_on = true )
{
	level endon( "disconnect" );
	
	flag_wait( "frontend_scene_ready" );
	
	level.e_player_align.origin = level.player.origin;
	level.e_player_align.angles = FLAT_ANGLES( level.player.angles );
	
	if ( !flag( "lockout_screen_skipped" ) && !flag(  "lockout_screen_skipped_freeroam"  ))
	{
		level thread scene_glasses_on();
	}
		
	level thread control_vision_set_glasses();
		
	//-- play the put on glasses animation after the lockout screen is passed
	flag_wait_any( "lockout_screen_passed", "lockout_screen_skipped",  "lockout_screen_skipped_freeroam" );
	
	if ( !flag( "lockout_screen_skipped" ) && !flag( "lockout_screen_skipped_freeroam" ))
	{
		wait(1.0);
		//-- play bootup
		flag_wait("headsupdisplay");
		wait(0.5);
		level.player SetBlur( 1.6, 2.5 );
		maps\_glasses::play_bootup();
    }
	
	skipanim = get_previous_map() != "";
	
	if ( !flag(  "lockout_screen_skipped_freeroam"  ))
		level.player toggle_viewarm( true, skipanim );
	
	maps\createart\frontend_art::dof_frontend();

	level thread run_glasses_input();
}

toggle_viewarm( do_show, skipanim = false )
{
	// If the glove hasn't been inited yet, don't try to toggle it.
	if ( !isdefined( self.is_glove_shown ) )
	{
		return;
	}
	
	if ( !IsDefined( do_show ) )
	{
		do_show = !self.is_glove_shown;
	}
	
	if ( self.is_glove_shown == do_show )
	{
		return;
	}
	
	// self SetLowReady( !do_show );
	if ( do_show )
	{
		// Move the align node to the player's feet so the view is flat.
		level.e_player_align.origin = level.player.origin;
		level.e_player_align.angles = FLAT_ANGLES( level.player.angles );
		
		level.player SetBlur( 1.6, 2.5 );
		
		// When game is first loaded.
		if ( !skipanim )
		{
			level thread run_scene( "data_glove_start" );
		
			wait_network_frame();
			player_body = get_model_or_models_from_scene( "data_glove_start", "player_body" );
			player_body Attach( "c_usa_cia_frnd_viewbody_vson", "J_WristTwist_LE" );
			
			scene_wait( "data_glove_start" );
			
			level thread run_scene( "data_glove_idle" );
			
		// Returning from a played level.
		} else {
			level thread run_scene( "data_glove_idle" );
			
			wait_network_frame();
			player_body = get_model_or_models_from_scene( "data_glove_idle", "player_body" );
			player_body Attach( "c_usa_cia_frnd_viewbody_vson", "J_WristTwist_LE" );
		}
		
		level.player thread data_glove_input();
	} 
	else
	{
		level.player notify( "menu_closed" );
		run_scene( "data_glove_finish" );
		level.player SetBlur( 0, 0.5 );
	}
	
	self.is_glove_shown = do_show;
}

toggle_secret_viewarm( do_show )
{
	// self SetLowReady( !do_show );
	if ( do_show )
	{
		level.player thread lerp_dof_over_time(1,0,0);
		// Move the align node to the player's feet so the view is flat.
		level.e_player_align.origin = level.player.origin;
		level.e_player_align.angles = FLAT_ANGLES( level.player.angles );
		
//		level.player SetBlur( 1.6, 2.5 );
		level thread run_scene( "data_glove_start" );
		
		wait_network_frame();
		player_body = get_model_or_models_from_scene( "data_glove_start", "player_body" );
		player_body Attach( "c_usa_cia_masonjr_viewbody_vson_ui3d", "J_WristTwist_LE" );
		
		scene_wait( "data_glove_start" );
		
		level thread run_scene( "data_glove_idle" );
		
		level.player thread data_glove_input();
	} 
	else
	{
		level.player thread lerp_dof_over_time(1);
		level.player notify( "menu_closed" );
		run_scene( "data_glove_finish" );
//		level.player SetBlur( 0, 0.5 );
	}
}

toggle_main_menu()
{
	//show/hide the main menu
	LUINotifyEvent( &"toggle_glasses" );
	wait_network_frame();
	level.player toggle_viewarm();

	while( level.player get_glasses_toggle_buttonPressed() )
		wait( 0.05 );
}

do_secret_menu()
{
	level.player toggle_secret_viewarm(true);
	LUINotifyEvent( &"toggle_secret" );
	
	while ( true )
	{
		level.player waittill( "menuresponse", str_menu_action, str_action_arg );
		if ( str_menu_action == "vcs_action")
		{
			switch(str_action_arg)
			{
			case "shutdown":
				SetCullDist( 10000 );
				level.player toggle_secret_viewarm(false);
				LUINotifyEvent( &"toggle_secret" );
				return;
			case "fullscreen":
				SetCullDist( 0.1 );
				break;
			case "windowed":
				SetCullDist( 10000 );
				break;
			case "disable_tap_anim"://this is the initial message given just before the vcs system starts
				level.player notify( "menu_closed" );
				break;
			case "enable_tap_anim"://final message when vcs is shutting down
				level.player thread data_glove_input();
				break;
			}
		}
	}
}

do_strikeforce_menu(e_center, map_info_list)
{
	if ( !isdefined( e_center.fwd ) )
	{
		e_center.fwd = AnglesToForward( e_center.angles );
	}
	
	selected_element=0;
	
	globe_show_map( map_info_list[selected_element].name );

	LUINotifyEvent(&"toggle_strikeforce",1,get_strikeforce_tokens_remaining());

	//send the available mission list
	for (i=0;i<map_info_list.size;i++)
	{
		level_index = int(TableLookup(LEVEL_PROGRESSION_CSV,LEVEL_PROGRESSION_LEVEL_NAME,map_info_list[i].name,LEVEL_PROGRESSION_LEVEL_INDEX));
		LUINotifyEvent(&"add_strikeforcemission",1,level_index);
	}
	
	while ( true )
	{
		level.player waittill( "menuresponse", str_menu_action, str_action_arg );
		if ( str_menu_action == "strikeforce_action")
		{
			switch(str_action_arg)
			{
			case "next_target":
				selected_element++;
				if (selected_element>=map_info_list.size)
					selected_element=0;
				break;
			case "prev_target":
				selected_element--;
				if (selected_element<0)
					selected_element=map_info_list.size-1;
				break;
			case "launch":
				scene_func = level.m_rts_scene[map_info_list[selected_element].name];
				if ( isdefined( scene_func ) )
				{
					[[scene_func]]();
				}
				return map_info_list[selected_element].name;
			case "shutdown":
				level.menuState=MENUSTATE_NONE;
				LUINotifyEvent(&"toggle_strikeforce");
				return "cancel";
			}
			globe_show_map( map_info_list[selected_element].name );
		}
	}
}

show_track_info(cur_music_track,music_tracks_names)
{
	LUINotifyEvent( &"show_track_info",1,music_tracks_names[cur_music_track] );
	level waittill_notify_or_timeout("track_info_change",6);
	LUINotifyEvent( &"hide_track_info" );
}

control_vision_set_glasses()
{
	flag_wait("glasses_tint");

	level.player VisionSetNaked( "sp_front_end_glasses_up", 0.05);
	wait(0.15);
	level.player VisionSetNaked( "sp_blackout_bridge", 2.0);
}

watch_for_lockout_screen()
{
	flag_wait( "level.player" );
	
	while( true )
	{
		level.player waittill("menuresponse", str_menu_action, str_action_arg);
		
		if(str_menu_action == "lockout")
		{
			switch(str_action_arg)
			{
			case "activated":
				//fade out and fade back in so we can reset the scene
				screen_fade_out(0);
				flag_clear( "glasses_toggling_enabled" );
				level.menuState=MENUSTATE_DISABLED;
				break;
			case "deactivated":
				flag_set( "glasses_toggling_enabled" );
				flag_set( "bootup_sequence_done_first_time");
				level notify( "frontend_refresh_scene" );
				level.menuState=MENUSTATE_MAIN;
				break;
			case "skipped":
				flag_set( "glasses_toggling_enabled" );
				flag_set( "lockout_screen_skipped" );
				level notify( "frontend_refresh_scene" );
				level.menuState=MENUSTATE_MAIN;
				break;
			case "skipped_freeroam":
				flag_set( "glasses_toggling_enabled" );
				flag_set( "lockout_screen_skipped_freeroam" );
				level notify( "frontend_refresh_scene" );
				level.menuState=MENUSTATE_NONE;
				break;
			case "need_glasses":
				flag_set( "lockout_screen_passed");
				level notify( "frontend_refresh_scene" );
				level.menuState=MENUSTATE_DISABLED;
				break;
			case "glasses_boot_complete":
				flag_set( "glasses_toggling_enabled" );
				level.menuState=MENUSTATE_MAIN;
				break;
			case "start_credits":
				//TODO set up sound and background states to manage the movies and other things we want to do while the credits are rolling
				flag_set( "glasses_toggling_enabled" );
				flag_set( "lockout_screen_skipped_freeroam" );
				LUINotifyEvent( &"start_credits" );
				level notify( "frontend_refresh_scene" );
				level.menuState=MENUSTATE_DISABLED;
				break;
			}
		}
	}
}

listen_for_campaign_state_change()
{
	while ( true )
	{
		self waittill( "menuresponse", str_menu_action, str_action_arg );
		if ( str_menu_action == "campaign_state")
		{
			switch(str_action_arg)
			{
			case "start":
				level notify( "frontend_refresh_scene" );
				//if we have some strike force missions available at this point, then don't let it go straight to the mission briefing menu
				if (level.menuState==MENUSTATE_MAIN)
				{
					toggle_main_menu();
					level.menuState=MENUSTATE_NONE;
				}
				break;
			case "stop":
				level notify( "frontend_refresh_scene" );
				break;
			}
		}
	}
}

listen_for_music_track_change()
{
	cur_music_track=0;
	
	//TODO AUDIO: modify these as desired to create the playlist that the front end is capable of playing
	music_tracks=array("FRONT_END_MAIN");
	music_tracks_names=array(&"FRONT_END_MAIN_INFO");
	//if you edit these, make sure to edit the qrcode array on the client side too!
	
	while ( true )
	{
		self waittill( "menuresponse", str_menu_action, str_action_arg );
		if ( str_menu_action == "music_action")
		{
			switch(str_action_arg)
			{
			case "prev_track":
				cur_music_track--;
				if (cur_music_track<0)
					cur_music_track=music_tracks.size-1;
				break;
			case "next_track":
				cur_music_track++;
				if (cur_music_track>music_tracks.size-1)
					cur_music_track=0;
				break;
			}
			Rpc("clientscripts/frontend","SetTrackInfoQRCode",cur_music_track);
			setmusicstate(music_tracks[cur_music_track]);
			level notify("track_info_change" );
			wait(0.05);
			level thread show_track_info(cur_music_track,music_tracks_names);
		}
	}
}

rts_hologram_on( map_list )
{
	// No maps available.  Forget it.
	if ( map_list.size == 0 )
	{
		return "nomaps";
	}
	
	map_info_list = [];
	
	e_center = GetEnt( "holo_table_surface", "targetname" );
	degrees_per_element = 360 / map_list.size;
	
	foreach ( map in map_list )
	{
		map_info = SpawnStruct();
		map_info.name = map;		
		ArrayInsert( map_info_list, map_info, map_info_list.size );
	}
	
	wait_network_frame();
	
	return do_strikeforce_menu(e_center, map_info_list);
}

// Attaches all the countries to the globe, then hides them.
//
build_globe()
{
	globe = GetEnt( "world_globe", "targetname" );
	countries = GetEntArray( globe.target, "targetname" );
	foreach ( country in countries )
	{
		country LinkTo( globe );
		country Hide();
	}
	
	// Bogus numbers for now.
	level.m_rts_map_angle["so_rts_mp_dockside"]	= (0, 195, 35);
	level.m_rts_map_angle["so_rts_mp_carrier"]	= (0, 170, 30);
	level.m_rts_map_angle["so_rts_afghanistan"]	= (0, 180, 40);
	level.m_rts_map_angle["so_rts_mp_drone"]	= (0, 150, 55);
	level.m_rts_map_angle["so_rts_mp_socotra"]	= (0, 185, 40);
	level.m_rts_map_angle["so_rts_mp_overflow"]	= (0, 210, 35);
	
	return globe;
}

// Toggles visibility of the globe model.
//
// Optionally toggles visibility of special countries on the globe.
//
show_globe( do_show = true, toggle_countries = false )
{
	globe = GetEnt( "world_globe", "targetname" );
	
	if ( do_show )
	{
		globe Show();
	}
	else
	{
		globe notify( "kill_globe_fx" );
		globe Hide();
	}
	
	if ( toggle_countries )
	{
		countries = GetEntArray( globe.target, "targetname" );
		foreach ( country in countries )
		{
			if ( do_show )
				country Show();
			else
				country Hide();
		}
	}
}

rotate_indefinitely( rotate_time = 45 )
{
	self endon( "stop_spinning" );
	while ( true )
	{
		self RotateYaw( 360, rotate_time, 0, 0 );
		wait rotate_time - 0.1;
	}
}

globe_show_map( map_name )
{
	angles = level.m_rts_map_angle[map_name];
	if ( !isdefined( angles ) )
		angles = (0, 0, 0);
	globe = GetEnt( "world_globe", "targetname" );
	globe RotateTo( angles, 0.5, 0, 0 );
	
	disputed_territory = level.m_rts_territory[map_name];
	city_marker = level.m_rts_city_tag[map_name];
	
	globe notify( "kill_globe_fx" );
	wait_network_frame();
	
	territories = GetEntArray( globe.target, "targetname" );
	foreach( territory in territories )
	{
		hide = true;
		if ( isdefined( disputed_territory ) )
		{
			if ( territory.script_noteworthy == disputed_territory )
				hide = false;
		}
		
		if ( hide )
			territory Hide();
		else
			territory Show();
		
		globe play_fx( "globe_city_marker", globe.origin, globe.angles, "kill_globe_fx", true, city_marker );
	}
	
	wait 0.5;
}

setup_frontend_scene()
{
	// Set up the ambient scene and attach collision to the actors.
	if ( !isdefined( level.m_bridge_workers ) )
	{
		ambient_scene = "ambient_0" + RandomIntRange( 1, 5 );
	
		level thread run_scene( ambient_scene );
		level.m_bridge_workers = get_model_or_models_from_scene( ambient_scene );
		foreach ( drone in level.m_bridge_workers )
		{
			drone attach_drone_collision();
		}
	}
	
	level_num = get_level_number_completed();
	// Set up the mission team in the briefing room.
	level_list = get_strikeforce_available_level_list(level_num + 1);
	if ( level_list.size != 0 || frontend_just_finished_rts() )
	{
		level thread run_scene( "sf_audience_loop" );
		level.m_mission_team = get_model_or_models_from_scene( "sf_audience_loop" );
		
		foreach ( member in level.m_mission_team )
		{
			member attach_drone_collision();
		}
		
		// Put Briggs in the mission briefing room.
		level thread run_scene( "sf_briggs_idle" );
	}
	
	// hide the globe.
	show_globe( false, true );
	
	// Grab level progression.
	/# PrintLn( "Choosing War Maps based on highest level number complete: " + level_num ); #/
		
	if ( level_num != 0 )
	{
		warp_to_random_player_start();
	} else {
		warp_to_default_player_start();
	}
	
	// if the glove was already up, run the scene again to update the positioning.
	if ( is_true( level.player.is_glove_shown ) )
	{
		player_body = GetEnt( "player_body", "targetname" );
		old_blend_time = 0.1;
		if ( isdefined( player_body ) )
		{
			old_blend_time = player_body._anim_blend_in_time;
			player_body maps\_anim::anim_set_blend_in_time( 0.1 );
		}
		
		level thread run_scene( "data_glove_idle" );
		
		wait 0.1;
		
		if ( isdefined( player_body ) )
		{
			player_body maps\_anim::anim_set_blend_in_time( old_blend_time );
		}
	}
	
	wait_network_frame();
	
	//set up the info display to communicate the levels and timelines available for available sf missions
	
	// No levels complete.  Give em the big read.
	if ( level_num == 0 )
	{
		// Bring in the city!
		holo_table_city = GetEnt( "P6_hologram_city_buildings", "targetname" );
		holo_table_surface_pos = GetEnt( "holo_table_surface", "targetname" );
		holo_table_city.origin = holo_table_surface_pos.origin;
		holo_table_city thread rotate_indefinitely();
	}
	else if ( frontend_just_finished_rts() )
	{
		level thread frontend_rts_level_respond();
	}
	else if ( level_list.size > 0 )
	{
		hub_num = frontend_get_hub_number( level_num + 1 );
		switch( hub_num )
		{
			case 1:
				level thread maps\frontend_sf_a::run_briefing();
				break;
			case 2:
				level thread maps\frontend_sf_b::run_briefing();
				break;
			case 3:
				level thread maps\frontend_sf_c::run_briefing();
				break;
			default:
				if ( !isdefined( hub_num ) )
					hub_num = "undefined";
				/#iprintlnbold( "Unknown StrikeForce hub number: " + hub_num ); #/
				level thread maps\frontend_sf_a::run_briefing();
				break;
		}
	}
}

// Get the highest hub number associated with a currently-available level.
//
frontend_get_hub_number( current_level )
{
	if ( !isdefined( level.m_hub_number ) )
	{
		level.m_hub_number = [];
		level.m_hub_number["so_rts_mp_dockside"]	= 1;
		level.m_hub_number["so_rts_mp_carrier"]		= 1;
		level.m_hub_number["so_rts_afghanistan"]	= 2;
		level.m_hub_number["so_rts_mp_drone"]		= 3;
		level.m_hub_number["so_rts_mp_socotra"]		= 3;
		level.m_hub_number["so_rts_mp_overflow"]	= 3;
	}
	
	level_list = get_strikeforce_available_level_list( current_level );
	hub_number = -1;
	foreach( iter_level in level_list )
	{
		iter_hub = level.m_hub_number[iter_level];
		if ( iter_hub > 0 && iter_hub > hub_number )
		{
			hub_number = iter_hub;
		}
	}
	
	if ( hub_number > 0 )
		return hub_number;
	else
		return 1;
}

frontend_tear_down_scene()
{
	level notify( "frontend_reset_scene" );
	
	briggs = GetEnt( "briggs_ai", "targetname" );
	if ( isdefined( briggs ) )
		briggs Delete();
	
	// re-set the count so we can re-spawn him next time.
	briggs_spawner = GetEnt( "briggs", "targetname" );
	briggs_spawner.count = 1;
	
	if ( isdefined( level.m_mission_team ) )
	{
		foreach ( member in level.m_mission_team )
		{
			member detach_drone_collision();
		}
		
		array_delete( level.m_mission_team );
		level.m_mission_team = undefined;
	}
	
	show_globe( false, true );
}

frontend_run_scene()
{
	level waittill( "frontend_refresh_scene" );
	while ( true )
	{
		setup_frontend_scene();
		
		wait 0.5;
		
		screen_fade_in( 0.5,undefined,true );
		
		flag_set( "frontend_scene_ready" );
		
		level waittill( "frontend_refresh_scene" );
		
		flag_clear( "frontend_scene_ready" );
		
		wait 0.1;
		
		frontend_tear_down_scene();
	}
}

frontend_watch_resume()
{
	while(1)
	{
		level waittill("frontend_resume");
		//fade out and fade back in so we can reset the scene
		screen_fade_out(0,undefined,true);
		wait(.5);
		
		LUINotifyEvent( &"frontend_restore" );

		wait(.5);
		screen_fade_in(2,undefined,true);
	}
}

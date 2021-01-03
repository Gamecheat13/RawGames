// TODO: cleanup pass from split for entire Ramses 1

#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_save;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\vehicles\_quadtank;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;

#using scripts\cp\cp_mi_cairo_ramses_level_start;
#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_nasser_interview;
#using scripts\cp\cp_mi_cairo_ramses_station_fight;
#using scripts\cp\cp_mi_cairo_ramses_vtol_ride;
#using scripts\cp\cp_mi_cairo_ramses_utility;

                    

#precache( "material", "waypoint_circle_arrow" );
#precache( "material", "waypoint_circle_arrow_yellow" );

#precache( "lui_menu", "PiPMenu" );
#precache( "string", "cp_ramses1_fs_chyron" );
#precache( "string", "cp_ramses1_fs_connectioninterrupted" );
#precache( "eventstring", "finished_movie_playback" );

#precache( "model", "p7_crate_lab_plastic_locking_crate" );
#precache( "model", "p7_medical_divider_folding_three_panels_trans" );
#precache( "model", "p7_medical_divider_folding_dmg_three_panels_trans" );
#precache( "model", "p7_medical_divider_folding_dmg_four_panels_trans" );
#precache( "model", "p7_medical_divider_folding_four_panels_trans" );
#precache( "model", "p7_crate_plastic_tech_01" );

function main()
{
	savegame::set_mission_name( "ramses" );
	
	precache();
	init_clientfields();
	init_flags();
	setup_skiptos();
	
	util::init_streamer_hints( 2 );
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	vehicle::add_spawn_function( "station_fight_turret", &station_turret_spawnfunc );
	
	cp_mi_cairo_ramses_fx::main();
	cp_mi_cairo_ramses_sound::main();

	compass::setupMiniMap( "compass_map_cp_mi_cairo_ramses" );
	
	skipto::set_skip_safehouse();
	
	level.b_tactical_mode_enabled = false;
	
	load::main();

	SetDvar( "compassmaxrange", "12000" );	// Set up the default range of the compass
//	SetDvar( "is_demo_build", true ); // TODO: Remove after demo
	
	if ( ramses_util::is_demo() )
	{
		SetDvar( "livestats_giveCPXP", 0 );
	}
	
	level clientfield::set( "ramses_station_lamps", 1 );
		
	/# 	// set up devgui
		ExecDevgui( "devgui/cp/cp_devgui_ramses" );
	#/
		
	level thread set_sound_igc();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_clientfields()
{
	// Intro IGC
	clientfield::register( "toplayer", "intro_reflection_extracam", 1, 1, "int" );
	clientfield::register( "scriptmover", "attach_cam_to_train", 1, 1, "int" );
	
	// Station Walkthrough
	clientfield::register( "world", "hide_station_miscmodels", 1, 1, "int" );
	clientfield::register( "world", "turn_on_rotating_fxanim_fans", 1, 1, "int" );
	clientfield::register( "world", "turn_on_rotating_fxanim_lights", 1, 1, "int" );
	clientfield::register( "world", "delete_fxanim_fans", 1, 1, "int" );
	
	// Nasser Interview
	clientfield::register( "toplayer", "nasser_interview_extra_cam", 1, 1, "int" );
	
	// Station Battle
	clientfield::register( "toplayer", "rap_blood_on_player", 1, 1, "counter" );
	clientfield::register( "world", "ramses_station_lamps", 1, 1, "int" );
		
	// Staging Area
	clientfield::register( "world", "staging_area_intro", 1, 1, "int" );
	clientfield::register( "toplayer", "filter_ev_interference_toggle", 1, 1, "int" );
}

function init_flags()
{
	level flag::init( "dead_turret_stop_station_ambients" );
	level flag::init( "station_walk_cleanup" );
	level flag::init( "ceiling_collapse_complete" );
	level flag::init( "mobile_wall_fxanim_start" ); //-- added this back so that the level ends correctly
	level flag::init( "vtol_ride_started" );
	level flag::init( "vtol_ride_done" );
	level flag::init( "weak_points_objective_active" );
	level flag::init( "sinkhole_charges_detonated" );
	level flag::init( "arena_defend_sinkhole_outro" );
	
	// flak exploders
	level flag::init( "flak_vtol_ride_stop" );
	level flag::init( "flak_arena_defend_stop" );
}

// Self is Vehicle
function station_turret_spawnfunc()
{
	self.team = "allies";
}

function setup_skiptos()
{
	skipto::add( "level_start", &skipto_level_start_init, "level_start", &skipto_level_start_done );
	
	skipto::add( "rs_walk_through", &skipto_rs_walk_through_init, "rs_walk_through", &skipto_rs_walk_through_done );
	
	skipto::add( "interview_dr_nasser", &skipto_interview_dr_nasser_init, "interview_dr_nasser", &skipto_interview_dr_nasser_done );
	
	skipto::add( "defend_ramses_station", &station_fight::init, "defend_ramses_station", &station_fight::done );
	
	skipto::add( "vtol_ride", &vtol_ride::init, "vtol_ride", &vtol_ride::done );

	skipto::add_dev( "dev_defend_station_test", &station_fight::defend_station_test, "Defend Station Test", &station_fight::defend_station_done, "", "" );
}

/**********************************************
 * CALLBACKS
 * ********************************************/
 
function on_player_connect()
{
	self flag::init( "linked_to_truck" );
}

function on_player_spawned()
{
	self ramses_util::set_lighting_state_on_spawn();
}

/**********************************************
 * SKIP-TO's
 * ********************************************/

function skipto_level_start_init( str_objective, b_starting )
{
	callback::on_spawned( &level_start::setup_players_for_station_walk );
	
	if( b_starting )
	{
		skipto::set_level_start_flag( "start_level" );
		util::set_streamer_hint( 1 );
	
		level_start::init_heroes( str_objective );		
		ramses_util::set_lighting_state_start();
		ramses_util::init_dead_turrets();
	}
	
	level.ai_hendricks SetDedicatedShadow( true );
	
	station_fight::intermediate_prop_state_hide();
	station_fight::hide_props( "_combat" );
	
	cp_mi_cairo_ramses_station_walk::pre_skipto_anims();
	level_start::main();
}

function skipto_level_start_done( str_objective, b_starting, b_direct, player )
{
	station_fight::intermediate_prop_state_hide();
	station_fight::hide_props( "_combat" );
	
	ramses_util::set_lighting_state_start();
	
	level scene::init( "cin_ram_04_02_easterncheck_vign_jumpdirect" ); //  Spawn door
}

function skipto_rs_walk_through_init( str_objective, b_starting )
{
	level.ai_khalil = util::get_hero( "khalil" );
	
	if ( b_starting )
    {
		cp_mi_cairo_ramses_station_walk::init_heroes( str_objective );
        cp_mi_cairo_ramses_station_walk::pre_skipto_anims();
        ramses_util::init_dead_turrets();
       
        callback::on_spawned( &level_start::setup_players_for_station_walk );
    }
	
	cp_mi_cairo_ramses_station_walk::main();
	cp_mi_cairo_ramses_nasser_interview::pre_skipto_anims();
}

function skipto_rs_walk_through_done( str_objective, b_starting, b_direct, player )
{
}

function skipto_interview_dr_nasser_init( str_objective, b_starting )
{
	//nasser_interview::main();
	if( b_starting )
	{
		level thread station_fight::intermediate_prop_state_show();
		cp_mi_cairo_ramses_nasser_interview::init_heroes( str_objective );
		cp_mi_cairo_ramses_nasser_interview::pre_skipto_anims( b_starting );
		ramses_util::init_dead_turrets();
		
		callback::on_spawned( &level_start::setup_players_for_station_walk );
	}
	
	//TODO Remove this after demo, none of the below scripts will be needed
	////////////////////////////////////////////////////////////////////////
	if ( ramses_util::is_demo() ) //there is no interview on demo path, so just go straight to the video
	{	
		if( b_starting )
		{
			level flag::wait_till( "all_players_spawned" ); //dont jump ahead until everyone is spawned in
		}
		else
		{
			level flag::wait_till( "rs_walkthrough_safehouse_enter" ); //dont jump ahead until players are in interview room
		}
		
		wait 2; //brief delay so the screen doesn't go black right away
		
		level thread cp_mi_cairo_ramses_nasser_interview::connection_interrupted();
		level util::clientNotify( "inv" );
		util::screen_fade_out();
		skipto::objective_completed( "interview_dr_nasser" );
	}
	////////////////////////////////////////////////////////////////////////
	else
	{
		cp_mi_cairo_ramses_nasser_interview::main();
	}
}

function skipto_interview_dr_nasser_done( str_objective, b_starting, b_direct, player )
{
	//TODO: DELETE LATER - moved these to match up with the ceiling collapse
//	station_fight::delete_props();
//	station_fight::show_props( "_combat" );
	
	level cp_mi_cairo_ramses_station_walk::scene_cleanup( false );
	
	//sound - turning off walla
	level util::clientnotify ("walla_off");
	
	level.b_tactical_mode_enabled = true;
}


fUnction set_sound_igc()
{
	level waittill("cin_ram_01_01_enterstation_1st_ride_complete");
	
	level util::clientnotify ("sndIGC");
	
	
}

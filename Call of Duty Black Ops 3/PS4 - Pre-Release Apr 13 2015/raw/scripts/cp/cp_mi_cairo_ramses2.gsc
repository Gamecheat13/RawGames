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
#using scripts\shared\exploder_shared;
#using scripts\shared\array_shared;

#using scripts\shared\vehicles\_quadtank;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;

#using scripts\cp\cp_mi_cairo_ramses_arena_defend;
#using scripts\cp\cp_mi_cairo_ramses_alley;
#using scripts\cp\cp_mi_cairo_ramses_vtol_igc;
#using scripts\cp\cp_mi_cairo_ramses_quad_tank_plaza;
#using scripts\cp\cp_mi_cairo_ramses_utility;

                      

#precache( "material", "waypoint_circle_arrow" );
#precache( "material", "waypoint_circle_arrow_yellow" );

function main()
{
//	SetDvar( "is_demo_build", true ); // TODO: Remove after demo
	
	savegame::set_mission_name( "ramses" );
	
	util::init_streamer_hints( 4 );
	
	init_clientfields();
	init_flags();
	setup_skiptos();
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	callback::on_loadout( &on_player_loadout );
	
	cp_mi_cairo_ramses2_fx::main();
	cp_mi_cairo_ramses2_sound::main();

	compass::setupMiniMap( "compass_map_cp_mi_cairo_ramses" );
	
	if( !ramses_util::is_demo() ) //TODO: delete after demo, for the demo we need to go to the safehouse
	{
		skipto::set_skip_safehouse(); //Need to go direct to Ramses 3
	}
	
	load::main();
	
	SetDvar( "compassmaxrange", "12000" );	// Set up the default range of the compass
	
	SetDvar ( "scr_security_breach_lose_contact_distance", 36000 );
	SetDvar ( "scr_security_breach_lost_contact_distance", 72000 );
	
	if ( ramses_util::is_demo() )
	{
		SetDvar( "livestats_giveCPXP", 0 );
	}
	
	/# 	// set up devgui
		ExecDevgui( "devgui/cp/cp_devgui_ramses" );
	#/
}

function init_clientfields()
{
	//postfx for planting spike launchers
	clientfield::register( "toplayer", "player_spike_plant_postfx", 1, 1, "counter" );
	
	// Arena Defend
	clientfield::register( "world", "arena_defend_fxanim_hunters", 1, 1, "int" );
	clientfield::register( "world", "arena_defend_mobile_wall_damage", 1, 1, "int" );
	
	// Alley
	clientfield::register( "world", "alley_fxanim_hunters", 1, 1, "int" );
	
	// VTOL IGC
	clientfield::register( "world", "vtol_igc_fxanim_hunter", 1, 1, "int" );
	
	// Quadtank Plaza
	clientfield::register( "world", "qt_plaza_fxanim_hunters", 1, 1, "int" );
	clientfield::register( "world", "theater_fxanim_swap", 1, 1, "int" );
	clientfield::register( "world", "qt_plaza_outro_exposure", 1, 1, "int" );
}

function init_flags()
{
	level flag::init( "dead_turret_stop_station_ambients" );
	level flag::init( "station_walk_cleanup" );
	level flag::init( "weak_points_objective_active" );
	level flag::init( "sinkhole_charges_detonated" );
	level flag::init( "arena_defend_sinkhole_outro" );
	level flag::init( "player_has_dead_control" );

	//shabs section for dialog
	level flag::init( "start_vtol_robot_drop_1" );
	level flag::init( "start_vtol_robot_drop_2" );
	level flag::init( "vtol_igc_done" );
	level flag::init( "freeway_battle_cleared" );	
	
	// flak exploders
	level flag::init( "flak_vtol_ride_stop" );
	level flag::init( "flak_arena_defend_stop" );
	level flag::init( "flak_alley_stop" );
}

function setup_skiptos()
{	
	skipto::add( "arena_defend_intro", &arena_defend::intro, "Arena Defend", &arena_defend::intro_done );
	skipto::add( "arena_defend", &arena_defend::main, "Arena Defend", &arena_defend::done );
	
	skipto::add_dev( "dev_weak_point_test", &arena_defend::dev_weak_point_test, "Weak Point Test", &arena_defend::dev_weak_point_test, "", "" );	
	
	skipto::add_dev( "dev_sinkhole_test", &arena_defend::dev_sinkhole_test, "Sinkhole Test", &arena_defend::dev_sinkhole_test_done, "", "" );		
	
	if( !ramses_util::is_demo() ) //TODO: remove after demo
	{
		skipto::add( "alley", &skipto_alley_init, "Alley", &skipto_alley_done );
			
		skipto::add( "vtol_igc", &skipto_vtol_igc_init, "VTOL IGC", &skipto_vtol_igc_done );
			
		skipto::add( "quad_tank_plaza", &skipto_quadtank_plaza_init, "Quad Tank Plaza", &skipto_quadtank_plaza_done );
	}
	
	skipto::add_dev( "dev_wall_test", &arena_defend::wall_test_init, "Wall Test", &arena_defend::wall_test_done );	
		
	skipto::add_dev( "dev_statue_fall", &skipto_statue_fall_init, "Statue Fall Test", &skipto_statue_fall_done );
	
	skipto::add_dev( "dev_hacked_quadtank", &dev_hacked_quadtank_init, "Test Hacked Quadtank", &dev_hacked_quadtank_done );
	
	skipto::add_dev( "dev_qt_plaza_outro", &dev_qt_plaza_outro_init, "QT PLAZA OUTRO", &dev_qt_plaza_outro_done );
}

/**********************************************
 * CALLBACKS
 * ********************************************/
 
function on_player_connect()
{
	self flag::init( "linked_to_truck" );
	self flag::init( "spike_launcher_tutorial_complete" );
}

function on_player_spawned()
{
	self ramses_util::set_lighting_state_on_spawn();  // TODO: do we still need this, post-split? -TJanssen 12/18/2014
}

// note: this will run every time the player loads out with a new class, regardless of whether or not he just spawned
function on_player_loadout()  // self = player
{
	//have player equip weapon immediately after picking a loadout at the beginning of the level
	if ( level.skipto_point === "arena_defend_intro" || level.skipto_point === "arena_defend" )
	{
		self ramses_util::give_spike_launcher( true, false );
	}
	else
	{
		self ramses_util::give_spike_launcher( false, false );
	}
}

/**********************************************
 * SKIP-TO's
 * ********************************************/

//////////////////////////////////////
//				ALLEY
//////////////////////////////////////

function skipto_alley_init( str_objective, b_starting )
{
	//HACK don't need to run any functions here for demo, but there are a lot of "alley" script_objective stuff to get cleaned up
//	if ( !ramses_util::is_demo() )
//	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );

		//TODO: temporary deletion of doors until everything is fully animated
		a_doors = GetEntArray( "alley_doors", "targetname" );
		array::delete_all(a_doors);
		
		if( b_starting )
		{
			//technicals
			//level thread scene::skipto_end( "p7_fxanim_cp_ramses_vtol_ride_bundle" );	TODO: delete this if it's not needed
			
			//TODO: hack to retain skipto start structs, they get nuked in _skipto when ArrayRemoveValue is called on them
			level.a_temp = struct::get_array( "alley_ai", "targetname" );
			
		    skipto::teleport_ai( str_objective );	
		}	
		
		level thread arena_defend::outro( b_starting );
		
		level.ai_hendricks colors::disable();
		level.ai_hendricks.goalradius = 64;
		
		level.ai_khalil colors::disable();
		level.ai_khalil.goalradius = 64;
		
		vtol_igc::hide_skipto_items();
		alley::alley_main();
//	}
//	else
//	{
//		if( b_starting )
//		{
//			level.ai_hendricks = util::get_hero( "hendricks" );
//			level.ai_khalil = util::get_hero( "khalil" );
//		}
//	
//		//immediately complete for demo	
//		skipto::objective_completed( "alley" );
//	}
}

function skipto_alley_done( str_objective, b_starting, b_direct, player )
{
	//HACK don't need to run any functions here for demo, but there are a lot of "alley" script_objective stuff to get cleaned up
	if ( !ramses_util::is_demo() )
	{
		if ( b_starting )
		{
			alley::temp_delete_hunter_crash_ents();
			arena_defend::weak_points_fxanim_scenes_cleanup();
		}
		
		objectives::complete( "cp_level_ramses_reinforce_safiya" );	
		
		ramses_util::set_lighting_state_time_shift_1();
	}
}

//////////////////////////////////////
//				VTOL IGC
//////////////////////////////////////

function skipto_vtol_igc_init( str_objective, b_starting )
{
	if ( ramses_util::is_demo() )
	{
		// HACK - this is here only for the demo path
		if( !b_starting )
		{
			util::unmake_hero( "hendricks" );
			util::unmake_hero( "khalil" );
			
			level.ai_hendricks = util::get_hero( "hendricks" );
			level.ai_hendricks colors::set_force_color( "o" );
		}
		
		// CLEANUP
		// HACK - this is here only for the demo path, because the DONE function for the Alley is not in the Demo Path
		alley::temp_delete_hunter_crash_ents();
		objectives::complete( "cp_level_ramses_reinforce_safiya" );	
		//
		
		skipto::teleport( str_objective );
		util::screen_fade_in( 2 );
	}
	
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_hendricks colors::set_force_color( "o" );
		
	    skipto::teleport_ai( str_objective );
	   
		//objectives
		objectives::set( "cp_level_ramses_vtol_igc" );
	}
	
	if( IsDefined( level.streamer_vtol_igc ) )
	{
		level.streamer_vtol_igc Delete();
	}
	
	// TAKE SPIKE LAUNCHER FROM PLAYERS
	callback::remove_on_loadout( &cp_mi_cairo_ramses2::on_player_loadout );
	level.players ramses_util::take_spike_launcher();
	
	// HACK - for the demo, this happens during the VTOL IGC
	ramses_util::set_lighting_state_time_shift_2();	
		
	// Init QT Plaza FX ANIMS
	init_qt_plaza_fx_anims();
	
	// Init QT Plaza FX
	init_qt_plaza_fx();

	level flag::set( "flak_alley_stop" );
	level thread alley::stop_hunter_crash_fx_anims();
	level thread quad_tank_plaza::dead_system_fx_anim();
	
	vtol_igc::hide_skipto_items();
	vtol_igc::vtol_igc_main();
}	

function skipto_vtol_igc_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_ramses_vtol_igc" );
}

//////////////////////////////////////
//				QUAD TANK PLAZA
//////////////////////////////////////

function skipto_quadtank_plaza_init( str_objective, b_starting )
{
	if( b_starting )
	{
		if ( ramses_util::is_demo() )
		{
			// CLEANUP
			// HACK - this is here only for the demo path, because the DONE function for the Alley is not in the Demo Path
			alley::temp_delete_hunter_crash_ents();
			arena_defend::weak_points_fxanim_scenes_cleanup();
			objectives::complete( "cp_level_ramses_reinforce_safiya" );	
			//
		}
		level.ai_hendricks = util::get_hero( "hendricks" );
	    skipto::teleport_ai( str_objective );
		
		//objectives
		objectives::complete( "cp_level_ramses_vtol_igc" );
		
		// TAKE SPIKE LAUNCHER FROM PLAYERS
		callback::remove_on_loadout( &cp_mi_cairo_ramses2::on_player_loadout );
		
		// HACK - for the demo, this happens during the VTOL IGC
		ramses_util::set_lighting_state_time_shift_2();	
		
		level flag::wait_till( "all_players_spawned" );
		level thread vtol_igc_skipto();
		
		level thread quad_tank_plaza::dead_system_fx_anim();
		
		quad_tank_plaza::pre_skipto();
		
		// Init QT Plaza FX ANIMS
		init_qt_plaza_fx_anims();
		
		// Init QT Plaza FX
		init_qt_plaza_fx();
	}		
	
	level.ai_hendricks colors::set_force_color( "o" );
	
	vtol_igc::hide_skipto_items();
	quad_tank_plaza::quad_tank_plaza_main();
}

function vtol_igc_skipto()
{
	level thread util::set_streamer_hint( 3 );
	
	level thread quad_tank_plaza::ignore_players();
	level thread vtol_igc::hide_vtol_wings();
	
	level thread vtol_igc::vtol_igc_notetracks( false );
	
	level thread scene::skipto_end( "cin_ram_06_05_safiya_1st_friendlydown", undefined, undefined, 0.75, true );
	
	//HACK - this waittill is needed because scene::skipto_end isn't falling through
	// notetrack on p_ram_06_05_safiya_1st_friendlydown_player
	level waittill( "cin_ram_06_05_safiya_1st_friendlydown_done" );
	
	level flag::set( "vtol_igc_done" ); //removes god mode on skipto on qt 1
	exploder::exploder_stop( "fx_expl_qtplaza_hotel" );
	array::run_all( GetEntArray( "lgt_vtol_block", "targetname" ), &Hide);
	util::clear_streamer_hint();
}

function init_qt_plaza_fx_anims()
{
	level scene::init( "p7_fxanim_cp_ramses_quadtank_statue_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_qt_plaza_palace_wall_collapse_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_quadtank_plaza_building_rocket_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_cinema_collapse_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_mobile_wall_explode_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_quadtank_plaza_glass_building_bundle" );
}

function init_qt_plaza_fx()
{
	exploder::exploder( "fx_expl_qtplaza_hotel" );
	exploder::exploder( "fx_expl_qtplaza_main" );
	exploder::exploder( "fx_expl_qtplaza_tracers" );
	exploder::exploder( "fx_expl_qtplaza_vista" );
	
	// Lights and FX for the Theater - turned off when theater gets destroyed
	exploder::exploder( "LGT_theater" );
}

function skipto_quadtank_plaza_done( str_objective, b_starting, b_direct, player )
{
}

//////////////////////////////////////
//				DEV SKIPTOS
//////////////////////////////////////

function skipto_statue_fall_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vtol_igc::hide_skipto_items();
	
		quad_tank_plaza::statue_fall_test();
	}
}

function skipto_statue_fall_done( str_objective, b_starting, b_direct, player )
{
}

function dev_hacked_quadtank_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		quad_tank_plaza::dev_hacked_quadtank_skipto();
	}
}

function dev_hacked_quadtank_done( str_objective, b_starting, b_direct, player )
{
}

function dev_qt_plaza_outro_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		// HACK - for the demo, this happens during the VTOL IGC
		ramses_util::set_lighting_state_time_shift_2();	
		
		level flag::init( "qt_plaza_outro_igc_started" );
		quad_tank_plaza::init_outro_igc_shadow_cards();
		
		level flag::wait_till( "all_players_spawned" );
		quad_tank_plaza::qt_plaza_outro( true );
	}
}

function dev_qt_plaza_outro_done( str_objective, b_starting, b_direct, player )
{
}

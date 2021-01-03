//---------------------------------------------------------------------------------------------------
// Notes
//---------------------------------------------
// Light probe gets linked to truck:
//	- lgt_test_probe
//---------------------------------------------
// DEAD System is driven by fxanims but is controlled in script
//---------------------------------------------
// HACK: added arena_defend_sinkhole_death_volume since register system expects this trigger to exist
//-----------------------------------------------------------------------------------------------------
#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\turret_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;

#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_station_fight;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "model", "p7_fxanim_cp_ramses_mobile_wall_mod" );
#precache( "model", "p7_fxanim_cp_ramses_mobile_wall_extended_mod" );
#precache( "objective", "cp_level_ramses_board" );
#precache( "objective", "cp_level_ramses_board_trucks" );
#precache( "objective", "cp_level_ramses_defend_checkpoint" );
#precache( "string", "cp_ramses2_pip_cairotroops" ); // Movie
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_BOARD_TRUCK" );
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_REMOVE_RUBBLE" );

// DEAD System


	// Base delay

	// Added delay for hunters

	// Added delay for dropships




	
// Fxanim





// Vehicles




	
// Fake Vehicles




	
#namespace vtol_ride;

function init( str_objective, b_starting )
{
	init_event_flags();
	
	spawner::add_spawn_function_group( "staging_area_allies", "script_string", &staging_area_allies_spawnfunc );
	
	event_setup( str_objective, b_starting );
	
	main();

	skipto::objective_completed( "vtol_ride" );
}

function init_event_flags()
{
	// "script_flag_set"/"mobile_wall_fxanim_start"
	// "script_flag_set"/"vtol_ride_reached"
	// "script_flag_set"/"vtol_ride_truck_01_reached_pick_up"
	// "script_flag_set"/"vtol_ride_truck_02_reached_pick_up"
	// "script_flag_true"/"vtol_ride_event_started"
	// "script_flag_true"/"vtol_ride_trucks_ready"
	// "script_flag_true"/"player_trucks_started"
	
	level flag::init( "jumpdirect_scene_done" );
	level flag::init( "khalil_reached_truck" );
	level flag::init( "staging_area_enter_started" );
	level flag::init( "trucks_ready" );
	level flag::init( "player_enter_hero_truck_started" );
	level flag::init( "players_ready" );
	level flag::init( "vtol_ride_players_in_position" );
	level flag::init( "vtol_ride_temp_probe_linked" ); // TODO: this is for a lighting test
}

function event_setup( str_objective, b_starting )
{
	if( b_starting )
	{
		exploder::exploder( "fx_exploder_vtol_crash" ); 
		ramses_util::init_dead_turrets();
		level thread dead_system_fx_anim();
		station_fight::cleanup_scene_turret();
	}
	
	exploder::exploder( "fx_exploder_staging_area_mortars" );
	
	init_heroes( str_objective, b_starting );
	init_scenes( b_starting );
}

function done( str_objective, b_starting, b_direct, player )
{
	level flag::set( "vtol_ride_done" );
	
	station_fight::delete_props( "_combat" );
	
	ramses_util::delete_ent_array( "station_clutter", "targetname" );
	
	objectives::set( "cp_level_ramses_defend_checkpoint" );
	if( b_starting )
	{
		objectives::complete( "cp_level_ramses_board_trucks" );
	}
	else
	{
		station_fight::cleanup_scenes(); // Only clean up if not starting from this skipto
	}
}

function main()
{	
	level flag::set( "vtol_ride_event_started" ); // Used to enable triggers in area
	
	level.n_players_in_trucks = 0;
	level.n_current_background_vehicles = 0;
	
	level thread objectives();
	level thread scenes();
	level thread VO();
	
	staging_area();
	
	// TODO: need to hang on to this until after demo before getting rid of anything
//	if( !ramses_util::is_demo() )
//	{
//		vtol_ride();
//	}
	
	level notify( "vtol_ride_event_done" );
	
	level.n_players_in_trucks = undefined;
	level.n_current_background_vehicles = undefined;
	
	//TODO: DELETE
//	level scene::stop( "p7_fxanim_cp_ramses_freeway_collapse_bundle", true ); // Delete freeway
}

// Inits
////////////////////////////////////////////////////////////////////

function init_heroes( str_objective, b_starting )
{
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		skipto::teleport_ai( str_objective, level.heroes );
	}
	
	level.ai_hendricks colors::disable();
	level.ai_khalil colors::disable();
	
	level.ai_hendricks.goalradius = 64;
	level.ai_khalil.goalradius = 64;
}

function init_scenes( b_starting )
{
	if( b_starting )
	{
		level scene::skipto_end( "p7_fxanim_cp_ramses_station_ceiling_vtol_bundle" );
		level scene::skipto_end( "p7_fxanim_cp_ramses_station_ceiling_vtol_crashed_bundle" );
		level scene::init( "p_ramses_lift_wing_blockage" );
		
		level notify( "reached_ceiling_collapse" );
		level notify( "swap_station_interior" );
		
		exploder::exploder( "vtol_crash" ); 
		exploder::exploder( "fx_exploder_station_ambient_post_collapse" );
		exploder::exploder( "fx_exploder_dropship_hits_floor" );
		exploder::exploder( "fx_exploder_dropship_through_ceiling" );
		exploder::exploder( "fx_exploder_dropship_hits_column" );
		exploder::exploder( "fx_exploder_dropship_through_ceiling_02" );
		exploder::exploder( "fx_exploder_dropship_through_ceiling_03" );
		
		level thread station_fight::ceiling_lighting_swap();
		
		a_ceiling_piece_geo = GetEntArray( "station_ceiling_pristine", "targetname" );
		foreach( piece in a_ceiling_piece_geo )
		{
			piece Delete();
		}
		
		//change station floor states
		station_fight::delete_props();
		station_fight::show_props( "_combat" );
		station_fight::phys_pulse_on_structs();
		
		level flag::set( "ceiling_collapse_complete" );
			
		level notify( "vtol_crash_complete" );
		level notify( "killed_by_ceiling" );
		
		station_fight::end_fight_dialog();
		level thread station_fight::end_fight_ambient_dialog();
	}
}

// Spawn Functions
////////////////////////////////////////////////////////////////////

function staging_area_allies_spawnfunc()
{
	self.goalradius = 64;
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	self ai::set_behavior_attribute( "disablearrivals", true );
	
	if( self.script_noteworthy === "does_walk" )
	{
		self ai::set_behavior_attribute( "patrol", true );
	}
}

// Staging area
////////////////////////////////////////////////////////////////////
function staging_area()
{
	level thread start_ambient_background_vtols( "staging_area_background_vtol", 6 );
	
	spawn_staging_area_props();
	
	remove_exit_blocker();
	
	level.players tether_players_to_khalil( .17 );
	level.players ramses_util::set_low_ready();
	
	level thread lui::play_movie( "cp_ramses2_pip_cairotroops", "pip" );
	
	level thread ambient_runners_logic();
	level thread ai_cleanup_boundary();
	
	level flag::wait_till( "trucks_ready" );
	
	trigger::wait_till( "staging_area_enter_trig" );
		
	level thread start_ambient_background_vtols( "staging_area_overhead_vtol", 5 ); // Ramp up to fill in for now more empty area
	
	level flag::wait_till( "players_ready" );
	
	level.players stop_tether_players();
	
	level notify( "staging_area_ambient_stop" );
	level util::clientnotify( "sndLevelEnd" );
	
	util::screen_fade_out( 2 );
	
	delete_out_of_bounds_trigger();
}

// Self is a player or and array of players
function tether_players_to_khalil( n_min_speed )
{
	if( IsArray( self ) )
	{
		a_e_players = self;
	}
	else
	{
		a_e_players = Array( self );
	}
	
	foreach( e_player in a_e_players )
	{
		e_player thread ramses_util::player_walk_speed_adjustment( level.ai_khalil, "stop_tether", 128, 256, n_min_speed, 1 );
	}
}

// Self is a player or and array of players
function stop_tether_players()
{
	if( IsArray( self ) )
	{
		a_e_players = self;
	}
	else
	{
		a_e_players = Array( self );
	}
	
	foreach( e_player in a_e_players )
	{
		e_player notify( "stop_tether" );
	}
}

// All the ambient AI's running around on patrol paths use this logic
function ambient_wave_think( numAIsPerWave, spawners, minwait = 2, maxwait = 3 )
{
	numAIsSpawned = 0;
			
	minGoalRadius = 64;
	maxGoalRadius = 96;
	
	while( numAIsSpawned < numAIsPerWave )
	{
		ais = spawner::simple_spawn( array::random( spawners ) );
		numAIsSpawned++;
		
		// radius and speed randomization
		foreach( ai in ais )
		{
			ai.goalradius = RandomIntRange( minGoalRadius, maxGoalRadius );
			
			if( RandomInt( 100 ) < 30 )
				ai ai::set_behavior_attribute( "sprint", true );
			
			if(randomInt(100)<25)
			{
				sndEnt = spawn( "script_origin", ai.origin );
				sndEnt linkto(ai);
				sndEnt playloopsound( "amb_walla_battlechatter", 1 );
				ai thread sndDeleteSndEnt(sndEnt);
			}
		}
				
		if( numAIsSpawned == 1 )
		{
			ai_talk = array::random(ais);
			
			if( isdefined( ai_talk ) )
			{
				ai_talk thread say_runners_vo();
			}
		}
		
		wait RandomIntRange( minwait, maxwait );
	}
}
function sndDeleteSndEnt(sndEnt)
{
	self waittill( "death" );
	sndEnt delete();
}

function handle_staging_area_front_runners()
{	
	a_sidewalk_runners_left = GetEntArray( "staging_area_sidewwalk_guys_left", "targetname" );
	a_sidewalk_runners_right = GetEntArray( "staging_area_sidewwalk_guys_right", "targetname" );
	
	numAIsPerWave = 4;
	waitBetweenWaves = 6;
	
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_left, 3, 6 );
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right, 3, 6 );
	
	wait waitBetweenWaves;
	
	level flag::wait_till( "trucks_ready" );
	trigger::wait_till( "staging_area_enter_trig" );
		
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_left );
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right );
}

function handle_staging_area_left_2_right_runners()
{	
	a_sidewalk_runners_left = GetEntArray( "staging_area_background_runners_left", "targetname" );
	a_sidewalk_runners_right = GetEntArray( "staging_area_background_runners_right", "targetname" );
	
	numAIsPerWave = 3;
	waitBetweenWaves = 10;
	
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_left, 3, 6 );
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right, 3, 6 );
	
	wait waitBetweenWaves;
		
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_left, 3, 6 );
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right, 3, 6 );
}

function handle_staging_area_right_2_left_runners()
{	
	a_sidewalk_runners_right = GetEntArray( "staging_area_background_runners2", "targetname" );
	
	numAIsPerWave = 3;
	waitBetweenWaves = 10;
	
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right, 3, 6 );
		
	wait waitBetweenWaves;
		
	level thread ambient_wave_think( numAIsPerWave, a_sidewalk_runners_right, 3, 6 );	
}

function ambient_runners_logic()
{
	n_front_wave_limit = 36;
	
	while(1)
	{
		if( GetAIArray().size < n_front_wave_limit )
		{
			// front wave across
			level thread handle_staging_area_front_runners();
		}
		
		level flag::wait_till( "trucks_ready" );
		
		// front left to right
		minWaitTime = 7;
		maxWaitTime = 11;
		wait RandomIntRange( minWaitTime, maxWaitTime );
		
		if( GetAIArray().size < n_front_wave_limit )
		{
			level thread handle_staging_area_left_2_right_runners();	
		}
		
		// front left to right
		minWaitTime = 11;
		maxWaitTime = 13;
		wait RandomIntRange( minWaitTime, maxWaitTime );
		
		if( GetAIArray().size < n_front_wave_limit )
		{
			level thread handle_staging_area_right_2_left_runners();	
		}
		
		// front right to left
		minWaitTime = 10;
		maxWaitTime = 14;
		wait RandomIntRange( minWaitTime, maxWaitTime );		
	}
}

function remove_exit_blocker()
{
	const N_RADIUS = 64;
	const N_HEIGHT = 96;
	
	s_exit = struct::get( "ramses_station_exit_obj", "targetname" );
	t_exit = Spawn( "trigger_radius", s_exit.origin, 0, N_RADIUS, N_HEIGHT );
	mdl_blocker = GetEnt( s_exit.target, "targetname" );
	
	t_exit SetHintString( &"CP_MI_CAIRO_RAMSES_REMOVE_RUBBLE" );
	t_exit SetCursorHint( "HINT_NOICON");
	t_exit TriggerIgnoreTeam();
	
	t_exit waittill( "trigger", e_player );
	
	t_exit Delete();
	
	e_player play_station_exit_scene();
	
	mdl_blocker Delete();
}
 
function ai_cleanup_boundary()
{
	level endon( "staging_area_ambient_stop" );
	
	t_cleanup = GetEnt( "staging_area_ai_cleanup_aitrig", "targetname" );
	
	while( true )
	{
		t_cleanup waittill( "trigger", ai_cleanup );
		
		if( IsAI( ai_cleanup ) )
		{
			ai_cleanup Delete();
		}
	}
}

// Self is array of spawners
function get_runner_group_count()
{
	n_runner_groups = 0;
	str_name = "";
	
	foreach( sp_runner in self )
	{
		if( str_name != sp_runner.targetname )
		{
			n_runner_groups++;
		}
		
		str_name = sp_runner.targetname;
	}
	
	return n_runner_groups;
}

// Self is array of spawners
function get_runner_groups( n_groups )
{
	a_runner_groups = [];
	
	for( i = 1; i < n_groups + 1; i++ )
	{
		a_sp_runners = GetSpawnerArray( "staging_area_background_runners" + i, "targetname" );
		
		if ( !isdefined( a_runner_groups ) ) a_runner_groups = []; else if ( !IsArray( a_runner_groups ) ) a_runner_groups = array( a_runner_groups ); a_runner_groups[a_runner_groups.size]=a_sp_runners;;
	}
	
	return a_runner_groups;
}

function delete_out_of_bounds_trigger()
{
	t_boundary = GetEnt( "boundary_trigger", "targetname" );
	t_boundary Delete();
}

// Self is hero AI
function ai_move_to_node( str_node )
{
	nd_goal = GetNode( str_node, "targetname" );
	
	self SetGoal( nd_goal, true );
	
	self waittill( "goal" );
	
	self ClearForcedGoal();
}

function spawn_staging_area_props()
{
	a_s_prop_spots = struct::get_array( "vtol_ride_staging_area_prop_spots", "script_noteworthy" );
	
	foreach( s in a_s_prop_spots )
	{
		m_prop = util::spawn_model( s.model, s.origin, s.angles );
		
		m_prop.targetname = s.targetname;
		m_prop.script_objective = "vtol_ride";
	}
}

// VTOL Ride
////////////////////////////////////////////////////////////////////

function vtol_ride()
{
	a_t_ride = GetEntArray( "vtol_ride_trig", "script_noteworthy" );
		
	level waittill( "trucks_start_drive_in" );
	
	a_t_ride init_flags( "_ready" );
	a_t_ride wait_till_flags( "_ready" );
	level flag::set( "vtol_ride_started" );
	
	delete_out_of_bounds_trigger();
		
	level thread enemy_vtol_ambience();
	
	level flag::wait_till( "mobile_wall_fxanim_start" );
	
	level flag::set( "dead_turret_stop_station_ambients" );
}

function enemy_vtol_ambience()
{
	//TODO: clean this up after demo
	level thread left_side_vtols_shot_down();
	level thread right_side_vtols_shot_down();
	
	level thread ambient_egyptian_reinforcements();
}

function left_side_vtols_shot_down()
{
	a_e_dead_turrets = [];
	
	foreach( e_turret in level.a_e_all_dead_turrets )
	{
		if( IsDefined( e_turret.script_int ) && (e_turret.script_int == 1 ) )
		{
			a_e_dead_turrets[ a_e_dead_turrets.size ] = e_turret;
		}
	}
	
	//spawn VTOLS
	nd_spawn_amb_vtol_1 = GetVehicleNode( "spawn_amb_vtol_1", "script_noteworthy" );
	nd_spawn_amb_vtol_1 waittill( "trigger" );	
	
	a_vtol_ride_quads = GetEntArray( "amb_vtol_quads", "targetname" );
		
	//FIRST SHOT - vtol 1 - first vtol down from liftoff
	nd_crash_vtol_quad_1 = GetVehicleNode( "vtol_1_crash_node", "script_noteworthy" );
		
	e_dead_target = util::spawn_model( "script_origin", nd_crash_vtol_quad_1.origin, nd_crash_vtol_quad_1.angles );
	e_dead_target SetInvisibleToAll();
	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret turret::set_target( e_dead_target, undefined, 0 );	
	}

	nd_crash_vtol_quad_1 waittill( "trigger" );	
	
	//play dead fx here and default explosion on the vtol origin
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret thread turret::fire_for_time( 4, 0 );
	}
	
	//SECOND SHOT - vtol 2 - first vtol down from liftoff
	nd_crash_vtol_quad_2 = GetVehicleNode( "vtol_2_crash_node", "script_noteworthy" );
	
	e_dead_target = util::spawn_model( "script_origin", nd_crash_vtol_quad_2.origin, nd_crash_vtol_quad_2.angles );
	e_dead_target SetInvisibleToAll();
	
	//vh_left_side_turret turret::set_target( e_dead_target, undefined, 0 );
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret turret::set_target( e_dead_target, undefined, 0 );
	}

	nd_crash_vtol_quad_2 waittill( "trigger" );	
	
	//play dead fx here and default explosion on the vtol origin	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret thread turret::fire_for_time( 4, 0 );
	}
	
	e_dead_target Delete();
}

function right_side_vtols_shot_down()
{	
	a_e_dead_turrets = [];
	
	foreach( e_turret in level.a_e_all_dead_turrets )
	{
		if( IsDefined( e_turret.script_int ) && (e_turret.script_int == 0 ) )
		{
			a_e_dead_turrets[ a_e_dead_turrets.size ] = e_turret;
		}
	}
	
	//First right side VTOL
	nd_amb_vtol_quad_3 = GetVehicleNode( "vtol_3_crash_node", "script_noteworthy" );
	
	e_dead_target = util::spawn_model( "script_origin", nd_amb_vtol_quad_3.origin, nd_amb_vtol_quad_3.angles );
	e_dead_target SetInvisibleToAll();	
	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret turret::set_target( e_dead_target, undefined, 0 );
	}
	
	nd_amb_vtol_quad_3 waittill( "trigger" );	

	//play dead fx here and default explosion on the vtol origin	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret thread turret::fire_for_time( 4, 0 );
	}
	
	//Second right side VTOL
	nd_amb_vtol_quad_4 = GetVehicleNode( "vtol_4_crash_node", "script_noteworthy" );
	
	e_dead_target = util::spawn_model( "script_origin", nd_amb_vtol_quad_4.origin, nd_amb_vtol_quad_4.angles );
	e_dead_target SetInvisibleToAll();	
	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret turret::set_target( e_dead_target, undefined, 0 );
	}
	
	nd_amb_vtol_quad_4 waittill( "trigger" );	

	//play dead fx here and default explosion on the vtol origin	
	foreach( e_turret in a_e_dead_turrets )
	{
		e_turret thread turret::fire_for_time( 4, 0 );
	}

	e_dead_target Delete();
}

function ambient_egyptian_reinforcements()
{
	//runners 1
	nd_start_egypt_runners_1 = GetVehicleNode( "start_egypt_runners_1", "script_noteworthy" );
	nd_start_egypt_runners_1 waittill( "trigger" );
	
	nd_vtol_egyptian_runners = GetEntArray( "vtol_egyptian_runners_1", "targetname" );
	foreach( sp_runner in nd_vtol_egyptian_runners )
	{	
		ai_runner = sp_runner spawner::spawn();
		ai_runner thread run_and_delete();
	}
	
	//runners 2
	nd_start_egypt_runners_2 = GetVehicleNode( "start_egypt_runners_2", "script_noteworthy" );
	nd_start_egypt_runners_2 waittill( "trigger" );
	
	nd_vtol_egyptian_runners = GetEntArray( "vtol_egyptian_runners_2", "targetname" );
	foreach( sp_runner in nd_vtol_egyptian_runners )
	{	
		ai_runner = sp_runner spawner::spawn();
		ai_runner thread run_and_delete();
	}	
	
	nd_vtol_egyptian_runners = GetEntArray( "vtol_egyptian_runners_3", "targetname" );
	foreach( sp_runner in nd_vtol_egyptian_runners )
	{	
		ai_runner = sp_runner spawner::spawn();
		ai_runner thread run_and_delete();
	}		
}

function run_and_delete()
{
	self endon( "death" );
	
	nd_goal = GetNode( self.target, "targetname" );
	
	self thread ai::force_goal( nd_goal, 32, false );
	self waittill( "goal" );
	self Delete();
}

// Objectives
////////////////////////////////////////////////////////////////////

function objectives()
{	
	a_s_obj = struct::get_array( "vtol_ride_truck_links", "script_noteworthy" );
	
	level waittill( "vtol_ride_board_objective_start" );
	
	objectives::set( "cp_level_ramses_board_trucks" );

	level waittill( "all_players_boarded" ); // UNDONE
	
	objectives::complete( "cp_level_ramses_board_trucks" );
}
// Self is array of structs
function _get_board_marker_spots()
{
	a_s_obj = [];
	foreach( s in self )
	{
		s.s_obj = struct::get( s.target, "targetname" );
		if ( !isdefined( a_s_obj ) ) a_s_obj = []; else if ( !IsArray( a_s_obj ) ) a_s_obj = array( a_s_obj ); a_s_obj[a_s_obj.size]=s.s_obj;;
	}
	return a_s_obj;
}

// Self is array of tag origins
function add_board_markers()
{
	objectives::set( "cp_level_ramses_board", self );
}

// Self is tag origin
function remove_board_marker()
{
	objectives::complete( "cp_level_ramses_board", self );
}

// Scenes
////////////////////////////////////////////////////////////////////

function scenes()
{
	const N_WALL_LIFTOFF_TIMEOUT = 20;
	
	level.ai_khalil flag::init( "khalil_ready" );
	
	level clientfield::set( "staging_area_intro", 1 ); // Init
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_carry_bundle", &wall_carry_fxanim_scene_init, "init" );
	level scene::init( "p7_fxanim_cp_ramses_wall_carry_bundle" );
	
	level scene::init( "cin_ram_04_01_staging_vign_help" );
	level scene::init( "cin_ram_04_01_staging_vign_help_alt" );
	level scene::init( "cin_ram_04_01_staging_vign_logistics" );
	level scene::init( "cin_ram_04_01_staging_vign_trafficcop" );
	
	// Play looping scenes
	level thread scene::play( "cin_ram_04_02_easterncheck_vign_jumpdirect_hendricks" );
//	level thread scene::play( "cin_ram_04_02_easterncheck_vign_jumpdirect_khalil" ); TODO: look into what we are supposed to do here
	level thread scene::play( "staging_area_ambient_egyptians", "targetname" ); // staging_area_worker_guy, staging_area_casual_guy, 
	
	play_dead_robots_looping_thread();
	
	level thread helipad_ambient_vtol_scenes();

	level waittill( "staging_area_enter_ready" );
		
	level thread play_jumpdirect_scene();
	
	level flag::wait_till( "staging_area_enter_started" );
		
	level thread robot_execution_scene( N_WALL_LIFTOFF_TIMEOUT );
	
	level flag::wait_till_timeout( N_WALL_LIFTOFF_TIMEOUT, "staging_area_ambient_start" ); // Set on trigger
		
	level thread scene::play( "p7_fxanim_cp_ramses_wall_carry_bundle" );
	
	level waittill( "trucks_start_drive_in" ); // Sent via notetrack - p7_fxanim_cp_ramses_wall_carry_bundle
	
	level thread scene::play( "cin_ram_04_01_staging_vign_help_alt" ); // Have to get them out of the way sooner than the others
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_vtol_ride_bundle", &vtol_ride_fxanim_scene_init, "init" );
	level scene::init( "p7_fxanim_cp_ramses_vtol_ride_bundle" ); // Drive up scene is initial animation
	
	level waittill( "wall_lift_off" ); // Sent via notetrack - p7_fxanim_cp_ramses_wall_carry_bundle
	
	level thread scene::play( "cin_ram_04_01_staging_vign_help" );
	level thread scene::play( "cin_ram_04_01_staging_vign_logistics" );
	level thread scene::play( "cin_ram_04_01_staging_vign_trafficcop" );
	
	level clientfield::set( "staging_area_intro", 0 ); // Play
}

function wall_carry_fxanim_scene_init()
{
	level.a_wall_parts = Array( GetEnt( "wall_carry_wall" , "targetname" ) , GetEnt( "wall_carry_doors" , "targetname" ) , GetEnt( "wall_carry_harness" , "targetname" ) );
	
	foreach ( part in level.a_wall_parts )
	{
		part SetDedicatedShadow( true );
	}	
}

function play_dead_robots_looping_thread()
{
	a_str_scenes = Array(	"cin_sgen_12_02_corvus_vign_deadpose_robot01_ontummy",
	                     	"cin_sgen_12_02_corvus_vign_deadpose_robot02_onback01",
							"cin_sgen_12_02_corvus_vign_deadpose_robot03_onback02",
							"cin_sgen_12_02_corvus_vign_deadpose_robot04_onside",
							"cin_sgen_12_02_corvus_vign_deadpose_robot05_onwallsitting" );
	
	foreach( str_scene in a_str_scenes )
	{
		mdl_robot = get_dead_robot_model();
		
		level thread scene::play( str_scene, mdl_robot );
	}
}

function get_dead_robot_model()
{
	n_head_exists_chance = 80;
	
	str_robot_head = 				"c_54i_robot_dps_head";
	
	a_str_robot_torsoes = Array( 	"c_54i_robot_dam_dps_g_upclean",
	                            	"c_54i_robot_dam_dps_g_rarmoff",
									"c_54i_robot_dam_dps_g_larmoff" );
	
	a_str_robot_legs = Array(		"c_54i_robot_dam_dps_g_lowclean", 		
	                         		"c_54i_robot_dam_dps_g_legsoff",
	                         		"c_54i_robot_dam_dps_g_rlegoff" );
	
	mdl_robot = util::spawn_model( array::random( a_str_robot_torsoes ) , (0, 0, 0), (0, 0, 0) );
	str_legs = array::random( a_str_robot_legs );
	
	mdl_robot Attach( str_legs );

	if( str_legs == "c_54i_robot_dam_dps_g_legsoff" )
	{
		mdl_robot HidePart( "j_knee_ri_dam" );
	}
	else
	{
		mdl_robot Attach( "c_54i_robot_dam_dps_g_llegspawn" );
	}
	
	mdl_robot Attach( "c_54i_robot_dam_dps_g_rlegspawn" );
	
	if( RandomInt( 100 ) < n_head_exists_chance )
	{
		mdl_robot Attach( str_robot_head );
	}
	
	return mdl_robot;
}

function play_jumpdirect_scene()
{
	n_min = .1;
	n_max = .3;
	
	level thread scene::play( "cin_ram_04_02_easterncheck_vign_jumpdirect" );
	
	array::wait_till( level.heroes, "ready_to_move" ); // Sent by notetracks
	
	wait RandomFloatRange( n_min, n_max );
	
	level flag::set( "jumpdirect_scene_done" );
}

function robot_execution_scene( n_timeout )
{
	str_scene_name = "cin_ram_04_01_staging_vign_finisher";
	
	a_str_robot_crawler_parts = Array( 	"c_54i_robot_dam_dps_g_legsoff", 
	                         			"c_54i_robot_dps_head" );
	
	a_str_robot_crawler_parts_hide = Array( "j_hip_le_dam", 
	                                       	"j_knee_ri_dam" );
	
	a_str_robot_parts = Array( 	"c_54i_robot_dam_dps_g_rlegoff", 
	                         	"c_54i_robot_dps_head" );
	
	mdl_robot_crawler_base = util::spawn_model( "c_54i_robot_dam_dps_g_upclean", (0, 0, 0), (0, 0, 0) );
	mdl_robot_base = util::spawn_model( "c_54i_robot_dam_dps_g_rarmoff", (0, 0, 0), (0, 0, 0) );
	
	mdl_robot_base construct_model_from_parts( a_str_robot_parts );
	mdl_robot_crawler_base construct_model_from_parts( a_str_robot_crawler_parts, a_str_robot_crawler_parts_hide );
	
	a_mdl_robots[ "robot_crawler_01" ] = mdl_robot_base;
	a_mdl_robots[ "robot_crawler_02" ] = mdl_robot_crawler_base;
	
	level scene::init( str_scene_name, a_mdl_robots );
	
	level flag::wait_till_any_timeout( n_timeout, Array( "staging_area_kills_start", "staging_area_ambient_start" ) ); // Set on triggers
	
	level scene::play( str_scene_name, a_mdl_robots );
}

// Self is script model
function construct_model_from_parts( a_str_parts, a_str_hide_tags = [] )
{
	foreach( str_part in a_str_parts )
	{
		self Attach( str_part );
	}
	
	foreach( str_tag in a_str_hide_tags )
	{
		self HidePart( str_tag );
	}
}

// Self is a player
function play_station_exit_scene()
{
	str_name = "p_ramses_lift_wing_blockage"; 
	
	scene::add_scene_func( str_name, &station_exit_scene_start, "play" );
	level scene::play( str_name, self ); // tag_align_wing_debris_exit
}

function station_exit_scene_start( a_ents )
{
	level notify( "staging_area_enter_ready" );
	
	level waittill( "staging_area_exit_started" ); // Sent via notetrack - TODO: need one exported once animation is further along
	
	level flag::set( "staging_area_enter_started" );
}

// Heroes reach
// TODO: redo after demo
function init_heroes_board_scene()
{
	n_hendricks_leave_timeout = 1.1;
	
	level.ai_khalil ai::set_behavior_attribute( "disablearrivals", true );
	level.ai_hendricks ai::set_behavior_attribute( "disablearrivals", true );
	
	level flag::wait_till( "jumpdirect_scene_done" );
	
	level thread khalil_move_to_truck();
	
	wait n_hendricks_leave_timeout;
	
	hendricks_move_to_truck();
	
	level flag::wait_till( "khalil_reached_truck" );
	
	level notify ("board_jeep");  //kill ambient music
}

function hendricks_move_to_truck()
{
	// send hendricks closer to the truck
	level.ai_hendricks.goalradius = 64;
	n_min = .15;
	n_max = .23;
	
	wait RandomFloatRange( n_min, n_max );
	
	level.ai_hendricks SetGoal( GetNode( "vtol_ride_temp_hendricks_goal", "targetname" ) );
	
	level.ai_hendricks waittill( "goal" );
	
	level thread scene::play( "cin_ram_04_02_easterncheck_1st_entertruck_hendricks_demo" );
	
	level waittill( "hendricks_in_truck" ); // Sent via notetrack
}

function khalil_move_to_truck()
{
	// send khalil closer to the truck
	level.ai_khalil.goalradius = 64;
	n_min = .1;
	n_max = .23;
	
	scene::add_scene_func( "cin_ram_04_02_easterncheck_1st_entertruck_demo_khalil", &khalil_arrives_at_truck, "init" );
	
	level.ai_khalil SetGoal( GetNode( "vtol_ride_temp_khalil_goal", "targetname" ) );
	
	wait RandomFloatRange( n_min, n_max );
	
	level.ai_khalil waittill( "goal" );
	
	level scene::init( "cin_ram_04_02_easterncheck_1st_entertruck_demo_khalil" );
}

function khalil_arrives_at_truck( a_ents )
{
	level.ai_khalil waittill( "reached_truck" );
	
	level flag::set( "khalil_reached_truck" );
}

function play_khalil_board_scene()
{
	level thread scene::play( "cin_ram_04_02_easterncheck_1st_entertruck_demo_khalil" );
	
	level.ai_khalil waittill( "khalil_ready" ); // Sent via notetrack
	
	level.ai_khalil flag::set( "khalil_ready" );
}

// TODO: redo after demo
function play_player_board_scene( e_player )
{
	level thread scene::play( "cin_ram_04_02_easterncheck_1st_entertruck_demo", e_player ); 
	
	level flag::set( "player_enter_hero_truck_started" );
	
	e_player thread truck_camera_tween();
	
	e_player waittill( "fade_to_black" ); // Sent via notetrack
}

// Self is a player
// HACK: hide pop
function truck_camera_tween()
{	
	self endon( "disconnect" );
	
	n_tween = .85;
	
	self waittill( "tween_camera" ); // Sent via notetrack at 178
	
	self StartCameraTween( n_tween );
}

function vtol_ride_fxanim_scene_init( a_ents )
{
	a_vh_technicals = Array( a_ents[ "technical_left" ], a_ents[ "technical_right" ] );
	a_str_enter_tags = Array( "tag_antenna1", "tag_antenna2" );
	a_mdl_obj_ents = a_vh_technicals get_board_objective_ents( a_str_enter_tags );
	
	foreach( vh_technical in a_vh_technicals )
	{
		vh_technical thread set_up_player_technical( a_str_enter_tags );
	}

	array::wait_till( a_vh_technicals, "ready_to_board" );
	
	level flag::set( "trucks_ready" );
	
	a_mdl_obj_ents add_board_markers();
	
	array::wait_till( a_vh_technicals, "seats_full" );
	
	level flag::set( "players_ready" );
}

// Self is array of script vehicles
function get_board_objective_ents( a_str_enter_tags )
{
	a_mdl_obj_ents = [];
	
	foreach( vh_technical in self )
	{
		foreach( str_tag in a_str_enter_tags )
		{
			vh_technical.a_mdl_obj[ str_tag ] = util::spawn_model( "tag_origin", vh_technical GetTagOrigin( str_tag ), vh_technical GetTagAngles( str_tag ) );
			
			vh_technical.a_mdl_obj[ str_tag ] LinkTo( vh_technical, str_tag, (0, 0, 0) );
			if ( !isdefined( a_mdl_obj_ents ) ) a_mdl_obj_ents = []; else if ( !IsArray( a_mdl_obj_ents ) ) a_mdl_obj_ents = array( a_mdl_obj_ents ); a_mdl_obj_ents[a_mdl_obj_ents.size]=vh_technical.a_mdl_obj[ str_tag ];;
		}
	}
	
	return a_mdl_obj_ents;
}

// Self is script vehicle
function set_up_player_technical( a_str_enter_tags )
{
	const N_RADIUS = 16;
	const N_HEIGHT = 48;
	const N_DELAY_OBJ_SHOW = 1;
	
	self give_riders();
	
	self waittill( "stopped" ); // Sent via notetrack
	
	wait N_DELAY_OBJ_SHOW;
	
	self notify( "ready_to_board" );
	
	if( self.targetname == "technical_left" )
	{
		const N_READY_RADIUS = 512;
		const N_READY_HEIGHT = 256;
		
		init_heroes_board_scene();
		
		t_ready_khalil = Spawn( "trigger_radius", self.origin, 0, N_READY_RADIUS, N_READY_HEIGHT );
		
		t_ready_khalil waittill( "trigger" );
		
		t_ready_khalil Delete();
		
		play_khalil_board_scene();
	}

	level.ai_khalil flag::wait_till( "khalil_ready" );
	
	foreach( str_tag in a_str_enter_tags )
	{
		t_enter = Spawn( "trigger_radius_use", self GetTagOrigin( str_tag ), 0, N_RADIUS, N_HEIGHT );
		t_enter.targetname = str_tag;
		
		t_enter thread enter_truck_think( self, a_str_enter_tags );
	}
}

// Self is vehicle
function give_riders()
{
	a_ai_riders = [];
	a_str_rider_positions = Array( "driver", "passenger1" );
	a_str_rider_spawners = Array( "staging_area_rider_1", "staging_area_rider_2", "staging_area_rider_3" );
	a_str_rider_spawners = array::randomize( a_str_rider_spawners );
	
	for( i = 0; i < a_str_rider_positions.size; i++ )
	{
		a_ai_riders[i] = spawner::simple_spawn_single( a_str_rider_spawners[i] );
		
		a_ai_riders[i] vehicle::get_in( self, a_str_rider_positions[i], true );
	}
}

// Self is vehicle
// TODO: need lighting to rename thier probe and use script noteworthy
function link_light_probe()
{
	e_probe = GetEnt( "lgt_test_probe", "targetname" );
	level flag::set( "vtol_ride_temp_probe_linked" );
	e_probe LinkTo( self );
//	/#self thread ramses_util::debug_link_probe( e_probe );#/
}

// Self is trigger
function enter_truck_think( vh_technical, a_str_tags )
{
	level notify( "vtol_ride_board_objective_start" );
	
	self SetHintString( &"CP_MI_CAIRO_RAMSES_BOARD_TRUCK" );
	self SetCursorHint( "HINT_NOICON");
	self TriggerIgnoreTeam();
	
	self fill_truck_seats( vh_technical, a_str_tags );
}

// Self is trigger
function fill_truck_seats( vh_technical, a_str_tags )
{
	n_linked = 0;
	
	while( n_linked < a_str_tags.size && level.n_players_in_trucks < level.players.size )
	{	
		e_player = self wait_till_enter();
		
		if( isdefined( e_player ) && !e_player flag::get( "linked_to_truck" ) )
		{
			self link_player_to_truck( vh_technical, e_player );
			level.n_players_in_trucks ++;
			n_linked ++;
			level notify( "player_enters_a_truck" );
		}
		
		{wait(.05);};
	}
	
	vh_technical notify( "seats_full" );
	
	self Delete(); //remove the use trigger for boarding the truck
}

// Self is trigger radius use
function wait_till_enter()
{
	level endon( "player_enters_a_truck" );
	
	self waittill( "trigger", e_player );
	
	return e_player;
}

// Self is trigger radius use
function link_player_to_truck( vh_technical, e_player )
{
	str_tag = self.targetname;
	
	e_player flag::set( "linked_to_truck" );
	e_player EnableInvulnerability();
	e_player.ignoreme = true;
	
	if( vh_technical.targetname == "technical_left" && !level scene::is_playing( "cin_ram_04_02_easterncheck_1st_entertruck_demo" ) )
	{
		self SetInvisibleToAll();
		
		vh_technical play_player_board_scene( e_player );
		
		self set_visible_to_other( e_player );
	}
	else // TODO: Both trucks will have a boarding scene for both positions
	{
		self SetInvisibleToPlayer( e_player );
		
		e_player PlayerLinkTo( vh_technical, str_tag, 1 );
	}
			
	vh_technical.a_mdl_obj[ str_tag ] remove_board_marker();
}

// Self is trigger radius use
function set_visible_to_other( e_other )
{
	foreach( e_player in level.players )
	{
		if( e_player != e_other )
		{
			self SetVisibleToPlayer( e_player );
		}
	}
}

function play_freeway_runners_vignettes()
{
	level thread spawn_and_move_model( "staging_area_background_freeway_guy", undefined, 3 ); 
	
	wait 2; // Stagger next group
	
	level thread spawn_and_move_model( "staging_area_background_freeway_guy", undefined, 3 ); 
	
	wait 4; // Stagger next group
	
	spawn_and_move_model( "staging_area_background_freeway_guy", undefined, 3 ); 
}

function play_ambient_runner_vignettes()
{
	level endon( "staging_area_ambient_stop" );
	
	while( true )
	{
		play_right_side_runners_vignettes();
	}
}

function play_right_side_runners_vignettes()
{
	level endon( "staging_area_ambient_stop" );
		
	a_s_runners = struct::get_array( "staging_area_right_side_runner_spot1", "targetname" );
	a_s_runners_back = struct::get_array( "staging_area_right_side_runner_spot2", "targetname" );
	
	while( true )
	{
		foreach( s_start in a_s_runners )
		{
			s_start thread spawn_and_move_model( undefined, s_start.model, 2, "staging_area_ambient_stop", "staging_area_right_side_runner" );
		}
		
		wait RandomFloatRange( 1, 4 );
		
		foreach( s_start2 in a_s_runners_back )
		{
			s_start2 thread spawn_and_move_model( undefined, s_start2.model, 2, "staging_area_ambient_stop", "staging_area_right_side_runner" );
		}
			
		a_m_runners = GetEntArray( "staging_area_right_side_runner", "targetname" );
		
		array::wait_till( a_m_runners, "death" );
		
		wait RandomInt( 2 );
	}
}

function staging_area_ambient_technicals()
{
	level endon( "staging_area_ambient_stop" );
	
	vh_vtol_crash_technical = spawner::simple_spawn_single( "staging_area_vtol_crash_technical_01" );
	
	nd_vtol_crash_techncial_start = GetVehicleNode( vh_vtol_crash_technical.target, "targetname" );
	e_vtol_crash_techncial_target = GetEnt( "staging_area_vtol_crash_technical_01_target", "targetname" );
	
	vh_vtol_crash_technical thread attach_gunner(); // TODO: use actual system
	vh_vtol_crash_technical SetTurretTargetEnt( e_vtol_crash_techncial_target );
	
	vh_vtol_crash_technical thread vehicle::get_on_and_go_path( nd_vtol_crash_techncial_start );
	
	level flag::wait_till( "staging_area_vtol_crash_technical_01_reached_turn" ); // Set on vehicle node
	
	vh_vtol_crash_technical ClearTurretTarget();
	
	level thread play_command_tent_technical_vignette();
}

function play_command_tent_technical_vignette()
{
	vh_command_tent_technical = spawner::simple_spawn_single( "staging_area_command_tent_technical" );
	nd_command_tent_technical_start = GetVehicleNode( vh_command_tent_technical.target, "targetname" );
	
	vh_command_tent_technical vehicle::get_on_and_go_path( nd_command_tent_technical_start );
	
//	level thread spawn_and_move_model( "staging_area_command_tent_technical_guy" );
//	spawn_and_move_model( "staging_area_command_tent_technical_guy2" );
}

function start_ambient_background_vtols( str_targetname, n_max )
{
	level endon( "staging_area_ambient_stop" );
	
	a_sp_vtols = GetVehicleSpawnerArray( str_targetname, "targetname" );
	
//	level thread start_fake_background_vtols();
		
	while( true )
	{
		a_sp_vtols = array::randomize( a_sp_vtols );
		
		foreach( sp_vtol in a_sp_vtols )
		{
			if( level.n_current_background_vehicles < n_max )
			{
				if( isdefined( sp_vtol ) )
				{
					if( !( isdefined( sp_vtol.b_active ) && sp_vtol.b_active ) )
					{
						sp_vtol.b_active = true;
						vh_vtol = spawner::simple_spawn_single( sp_vtol );
						vnd_start = GetVehicleNode( sp_vtol.target, "targetname" );
						
						sp_vtol.count++;
						level.n_current_background_vehicles++;
						
						vh_vtol thread count_background_vehicle_death( sp_vtol );
						vh_vtol thread vehicle::get_on_and_go_path( vnd_start );
						
						wait RandomFloatRange( 0.4, 0.75 );
					}
				}
			}
			else
			{
				level waittill( "background_vtol_death" );
			}
		}
		
		{wait(.05);};
	}
}

function start_fake_background_vtols()
{
	level endon( "staging_area_ambient_stop" );
	level endon( "ambient_background_vtols_stop" );
	
	a_s_fake_vtol_spots = struct::get_array( "staging_area_distant_fake_vehicle_spots", "targetname" );
	
	while( true )
	{
		s_vtol = array::random( a_s_fake_vtol_spots );
		
	 	s_vtol thread spawn_and_move_model( undefined, undefined, RandomFloatRange( 35, 50 ) );
	 	
	 	wait RandomFloatRange( 1.75, 2.5 );
	}
}

// Self is vehicle
function count_background_vehicle_death( sp )
{
	level endon( "staging_area_ambient_stop" );
	
	self waittill( "death" );
	
	if( isdefined( sp ) )
	{
		sp.b_active = false;
	}
	
	level.n_current_background_vehicles--;
	level notify( "background_vtol_death" );
}

function play_first_troop_vtol_vignette()
{
	a_ai_runners = [];
	a_sp_runners = GetSpawnerArray( "staging_area_troop_pickup_vtol_01_guys_alt", "targetname" );
	
	level thread play_vehicle_load_vignette( "staging_area_troop_pickup_vtol_01" );
	
	foreach( sp in a_sp_runners )
	{
		ai_runner = sp spawner::simple_spawn_single();
		
		if ( !isdefined( a_ai_runners ) ) a_ai_runners = []; else if ( !IsArray( a_ai_runners ) ) a_ai_runners = array( a_ai_runners ); a_ai_runners[a_ai_runners.size]=ai_runner;;
	}
	
	array::wait_till( a_ai_runners, "goal" );
	
	array::delete_all( a_ai_runners );
}

function inbound_medivac_vtols()
{
	level endon( "staging_area_ambient_stop" );
	
	while( true )
	{
		play_vehicle_load_vignette( "staging_area_medivac_dropoff_vtol_01" );
		
		wait RandomInt( 3 );
	}
}

// Self is vehicle
function delete_intro_wall( mdl_wall_01 )
{
	self waittill( "death" );
	
	if( isdefined( mdl_wall_01 ) )
	{
		mdl_wall_01 Delete();
	}
}

/* 
 * NOTES:
 * VTOL loading scenes are multiple instances of same server/client seige scenes
 * Each VTOL has a unique takeoff scene
 * 
 * cin_ram_04_01_staging_vign_crowd_vtol positions by targetname: 
 * 
 * helipads_vtol_crowd_load_1
 * origin (10212.4, -6747.51, 12.3734)
 * angles (0, 301.198, 0)
 * 
 * helipads_vtol_crowd_load_2
 * origin (11805.4, -7506.51, 12.3734)
 * angles (0, 312.38, 0)
 * 
 * helipads_vtol_crowd_load_3
 * origin (13950.4, -7217.89, 22.2191)
 * angles (0, 342.93, 0)
 * 
 * helipads_vtol_crowd_load_4
 * origin (13588.4, -8535.68, 24.2192)
 * angles (0, 344.802, 0)
 * 
 * helipads_vtol_crowd_load_5
 * origin (12199.9, -9011.81, 18.2192)
 * angles (0, 340.308, 0)
 * 
 * helipads_vtol_crowd_load_6
 * origin (10627, -9026.38, 18.2192)
 * angles (0, 262.566, 0)
 * 
 * helipads_vtol_crowd_load_7
 * origin (9282.04, -8109.63, 18.2192)
 * angles (0, 251.97, 0)
 *  
 */
function helipad_ambient_vtol_scenes()
{
	level endon( "staging_area_ambient_stop" );
	
	// Change the order to change liftoff order
	a_str_vtols = Array( "helipad_liftoff_vtol_1", 
	                    "helipad_liftoff_vtol_2", 
	                    "helipad_liftoff_vtol_3",
						"helipad_liftoff_vtol_4", 
						"helipad_liftoff_vtol_5", 
						"helipad_liftoff_vtol_6",
						"helipad_liftoff_vtol_7", 
						"helipad_liftoff_vtol_8", 
						"helipad_liftoff_vtol_9",
						"helipad_liftoff_vtol_10" );
	
	scene::add_scene_func( "cin_ram_04_01_staging_vign_crowd_vtol", &vtol_load_scene_init, "init" );
	scene::add_scene_func( "cin_ram_04_01_staging_vign_crowd_vtol", &vtol_load_scene_done, "done" );
	
	a_vh_vtols = get_helipads_vtols( a_str_vtols );
	a_vh_crowd_vtols = a_vh_vtols get_crowd_scene_vtols();
	
	a_vh_vtols init_helipad_vtols();
	a_vh_crowd_vtols init_helipad_crowd_vtols();
	
	a_vh_crowd_vtols thread start_vtol_crowd_load_scenes();
	
	level flag::wait_till( "player_enter_hero_truck_started" );
	
	a_vh_vtols start_helipad_vtols();
}

// Self is script struct
function vtol_load_scene_init( a_ents )
{
	vh_vtol = a_ents[ "crowd_vtol" ];
	
	vh_vtol flag::init( "loaded" );
}

// Self is script struct
function vtol_load_scene_done( a_ents )
{
	vh_vtol = a_ents[ "crowd_vtol" ];
	
	vh_vtol flag::set( "loaded" );
}

function get_helipads_vtols( a_str_names )
{
	a_vh_vtols = [];
	
	foreach( str_name in a_str_names )
	{
		vh_vtol = spawner::simple_spawn_single( str_name );
		
		if ( !isdefined( a_vh_vtols ) ) a_vh_vtols = []; else if ( !IsArray( a_vh_vtols ) ) a_vh_vtols = array( a_vh_vtols ); a_vh_vtols[a_vh_vtols.size]=vh_vtol;;
	}
	
	return a_vh_vtols;
}

// Self is array of vehicles
function get_crowd_scene_vtols()
{
	a_vh_vtols = [];
	
	foreach( vh_vtol in self )
	{
		if( isdefined( vh_vtol.script_noteworthy ) )
		{
			if ( !isdefined( a_vh_vtols ) ) a_vh_vtols = []; else if ( !IsArray( a_vh_vtols ) ) a_vh_vtols = array( a_vh_vtols ); a_vh_vtols[a_vh_vtols.size]=vh_vtol;;
		}
	}
	
	return a_vh_vtols;
}

// Self is array of vehicles
function init_helipad_vtols()
{
	foreach( vh_vtol in self )
	{
		level scene::init( vh_vtol.script_string, vh_vtol );
	}
}

// Self is array of vehicles
function init_helipad_crowd_vtols()
{
	foreach( vh_vtol in self )
	{
		level scene::init( vh_vtol.script_noteworthy, "targetname", vh_vtol );
	}
}

// Self is array of vehicles
function start_helipad_vtols()
{
	level endon( "staging_area_ambient_stop" );
	
	const N_WAIT_MIN = .51;
	const N_WAIT_MAX = 1.25;
	
	s_goal = struct::get( "helipads_vtol_goal", "targetname" );
	
	foreach( vh_vtol in self )
	{
		vh_vtol thread play_vtol_liftoff( s_goal.origin );
		
		wait RandomFloatRange( N_WAIT_MIN, N_WAIT_MAX );
	}
}

// Self is array of vehicles
function start_vtol_crowd_load_scenes()
{
	level endon( "staging_area_ambient_stop" );
	
	const N_WAIT_MIN = 0.56;
	const N_WAIT_MAX = 1.25;
	
	n_timeout = 35;
	
	trigger::wait_or_timeout( n_timeout, "staging_area_helipads_liftoff_trig" );
	
	foreach( vh_vtol in self )
	{
		level thread scene::play( vh_vtol.script_noteworthy, "targetname", vh_vtol );
		
		wait RandomFloatRange( N_WAIT_MIN, N_WAIT_MAX );
	}
}

// Self is script vehicle
function play_vtol_liftoff( v_goal )
{
	self endon( "death" );
	
	if( isdefined( self.script_noteworthy ) )
	{
		self flag::wait_till( "loaded" );	
	}
	
	level scene::play( self.script_string, self );
		
	self SetVehGoalPos( v_goal );
	
	self waittill( "goal" );
	
	self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
}

function midground_vtol_wall_pickup_scenes()
{
	level endon( "staging_area_ambient_stop" );

	// TODO: play scenes here
}

function play_vtol_pickup_technical_vignette( str_flag_wait, str_technical, str_vtol )
{
	level endon( "staging_area_ambient_stop" );
	
	level flag::wait_till( str_flag_wait );
	
	vh_load_technical_01 = spawn_from_targetname_and_move( str_technical );

	vh_load_technical_01 endon( "death" );
	
	vh_load_technical_01 waittill( "reached_end_node" );
	
	play_vehicle_load_vignette( str_vtol, undefined, vh_load_technical_01 );
	
	vh_load_technical_01.delete_on_death = true;           vh_load_technical_01 notify( "death" );           if( !IsAlive( vh_load_technical_01 ) )           vh_load_technical_01 Delete();;
}
	
function play_vehicle_load_vignette( str_vehicle, str_flag_true, props )
{	
	level endon( "staging_area_ambient_stop" );
	
	a_sp_cargo = GetEntArray( str_vehicle + "_guys", "targetname" );
	a_ai_cargo = spawner::simple_spawn( a_sp_cargo );
	
	if( isdefined( props ) && IsString( props ) )
	{
		props = GetEntArray( props, "targetname" );
	}
	else if( isdefined( props ) && !IsArray( props ) )
	{
		props = Array( props );
	}
	
	if( isdefined( str_flag_true ) )
	{
		level flag::wait_till( str_flag_true );
	}
	
	vh_vehicle = spawner::simple_spawn_single( str_vehicle );
	vnd_start = GetVehicleNode( vh_vehicle.target, "targetname" );
	
	vh_vehicle endon( "death" );
	
	vh_vehicle thread vehicle::get_on_and_go_path( vnd_start );
	
	level flag::wait_till( str_vehicle + "_arriving" ); // Set on vehicle node - Ex: script_flag_set/staging_area_troop_pickup_vtol_01_arriving
	 
	foreach( ai in a_ai_cargo )
	{
		nd_goal = GetNode( ai.target, "targetname" );
		ai SetGoal( nd_goal, true );
	}
	
	array::wait_till( a_ai_cargo, "goal" );
	
	level flag::wait_till( str_vehicle + "_arrived" ); // Set on vehicle node - Ex: script_flag_set/staging_area_troop_pickup_vtol_01_arrived
	
	wait 2;
	
	if( isdefined( props ) )
	{
		Assert( props.size > 0, "No props found for props found for vehicle" );
		
		foreach( e in props )
		{
			e LinkTo( vh_vehicle );
		}
	}
	else
	{
		array::delete_all( a_ai_cargo ); // TODO: animation 
	}
	
	level flag::set( str_vehicle + "_loaded" ); // Vehicle waits for this flag on vehicle node - Ex: script_flag_wait/staging_area_troop_pickup_vtol_01_guys_loaded
	
	vh_vehicle waittill( "reached_end_node" );
	
	if( isdefined( props ) )
	{
		array::delete_all( props );
	}
}

function attach_gunner()
{
	const STR_GUNNER_TAG = "tag_gunner_turret1";
	m_gunner = util::spawn_model( "c_gen_soldier_1_fb", self GetTagOrigin( STR_GUNNER_TAG ), self GetTagAngles( STR_GUNNER_TAG ) );
	
	m_gunner LinkTo( self, STR_GUNNER_TAG, (0, 0, -32) );
	
	self waittill( "death");
	
	m_gunner Delete();
}

function spawn_from_targetname_and_move( str_targetname )
{
	vh_spawned = spawner::simple_spawn_single( str_targetname );
	nd_start = GetVehicleNode( vh_spawned.target, "targetname" );
	
	vh_spawned thread vehicle::get_on_and_go_path( nd_start );	
	return vh_spawned;
}

// all the models it spawns are temp soldiers
// Self is script struct or level
function spawn_and_move_model( str_struct, str_model = "c_gen_soldier_1_fb", speed_multiplier = 1, str_endon = "staging_area_ambient_stop", str_give_name )
{
	level endon( str_endon );
	
	s_start = undefined;
	
	if( isdefined( self.model ) )
	{
		s_start = self;
		str_model = self.model;
	}
	else if( isdefined( str_struct ) )
	{
		s_start = struct::get( str_struct, "targetname");
	}

	mdl_target = util::spawn_model( str_model , s_start.origin, s_start.angles );
	mdl_target.script_objective = "vtol_ride";
	if( isdefined( str_give_name ) )
	{
		mdl_target.targetname = str_give_name;
	}
	
	//move the model from struct to struct
	do
	{
		next_struct = struct::get( s_start.target, "targetname" );
	
		//Calculate generic move time for someone who is... walking?
		move_time = Distance( next_struct.origin, s_start.origin ) / (36*2) / speed_multiplier ; // distance / (1 yd + 1ft steps at 2 steps per second)
		mdl_target Moveto( next_struct.origin, move_time );
		
		//Snap the guy to face his next node
		new_angles = next_struct.origin - s_start.origin;
		mdl_target.angles = ( 0, VectorToAngles(new_angles)[1], 0 );
		
		
		wait( move_time );
		
		s_start = next_struct;
	} 
	while( isdefined( s_start.target ) );
	
	mdl_target Delete();
}

/***********************************
 * Ambient DEAD System Activity
 * ********************************/
 
function dead_system_fx_anim()
{
	level.a_batteries = [];
	level.a_vh_active_battery = [];
	a_s_fxanim_hunters = struct::get_array( "ramses_station_hunters", "targetname" );
	a_s_fxanim_dropships = struct::get_array( "ramses_station_vtols", "targetname" ); // Keep this seperate in case we need it to be in the future
	a_s_fxanim_hunters_turnaround = struct::get_array( "ramses_station_hunters_turnaround", "targetname" );

	a_s_fxanim = ArrayCombine( a_s_fxanim_hunters, a_s_fxanim_dropships, false, false );
	
	for( i = 1; i < 4 + 1; i++ )
	{
		a_vh_battery = GetVehicleArray( "station_battery_" + i, "script_noteworthy" );
		
		Assert( a_vh_battery.size == 3, "Battery with script_noteworthy " +  "station_battery_" + i + " has " + a_vh_battery.size + " turrets but needs " + 3 + " turrets." );
			
		level.a_batteries[ i ] = a_vh_battery;
	}
	
	level thread debug_increase_bullet_range();
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_09_bundle_server", &hunter_fxanim_scene_start, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_hunters_10_bundle_server", &hunter_fxanim_scene_start, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_lotus_towers_vtols_01_bundle_server", &hunter_fxanim_scene_start, "play" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_lotus_towers_hunters_swarm_bundle" );
	
	a_s_fxanim_hunters_turnaround thread play_hunter_turn_back_fxanim_scenes();
	a_s_fxanim play_hunter_fxanim_scenes();
	
	foreach( s_fxanim in a_s_fxanim )
	{
		s_fxanim scene::stop( true );
	}
	
	level.a_batteries = undefined;
	level.a_vh_active_battery = undefined;
}

// Self is a turret
// TODO: finish - will want to ramp filter fx up as we are closer
function turret_futz_think()
{
	level endon( "staging_area_ambient_stop" );	
	
//	/#self thread debug_draw_futz_sphere( N_TURRET_FUTZ_DISTANCE );#/
			
	while( self.b_firing )
	{
		foreach( e_player in level.players )
		{
			if( Distance2D( e_player GetOrigin(), self.origin ) <= 894 )
			{
				e_player turret_futz_enable();
			}
			else
			{
				e_player turret_futz_enable( false );
			}
		}
		
		{wait(.05);};
	}
	
	foreach( e_player in level.players )
	{
		e_player turret_futz_enable( false );
	}
}

// Self is a player
function turret_futz_enable( b_on = true )
{
	self clientfield::set_to_player( "filter_ev_interference_toggle", b_on );
}

/#
// Self is turret
function debug_draw_futz_sphere( n_distance )
{
	self endon( "_stop_turret" );
	
	while( true )
	{
		debug::debug_sphere( self.origin, n_distance, ( 1, 0, 0 ), .5, 1 );
		
		{wait(.05);};
	}
}
#/
	
// Self is array of batteries
function reset_dead_turrets_target_pos()
{
	level endon( "staging_area_ambient_stop" );
	
	a_e_turret_fake_targets = GetEntArray( "battery_fake_target", "targetname" );
	
	foreach( vh_turret in self )
	{
		vh_turret SetTurretTargetEnt( array::random( a_e_turret_fake_targets ) );
	}
}

// Self is array of structs
function play_hunter_fxanim_scenes()
{
	level endon( "staging_area_ambient_stop" );
	
	level.a_vh_active_battery = array::random( level.a_batteries );
	
	while( true )
	{	
		spawn_dead_system_targets();
		
		array::wait_till( level.a_vh_active_battery, "_stop_turret" );
		
		activate_new_battery();
	}
}

// Self is array of structs
function play_hunter_turn_back_fxanim_scenes()
{
	level endon( "staging_area_ambient_stop" );
	
	while( true )
	{
		s_fxanim = array::random( self );
		
		if( !s_fxanim scene::is_playing() )
		{
			s_fxanim thread scene::play();
		}
		
		wait RandomFloatRange( 2, 4 );
	}
}

// Self is array of structs
function spawn_dead_system_targets()
{
	level endon( "staging_area_ambient_stop" );
	
	for( i = 0; i < 3; i++ )
	{
		s_fxanim = get_dead_system_target_fxanim();
		
		s_fxanim thread scene::play();
		
		wait RandomFloatRange( 0.59, 1.2 );
	}
}

// Self is array of structs
function get_dead_system_target_fxanim()
{
	level endon( "staging_area_ambient_stop" );
	
	s_fxanim = undefined;
	
	while( true )
	{
		s_fxanim = array::random( self );
		
		if( !s_fxanim scene::is_playing() )
		{
			break;				
		}
		
		{wait(.05);};
	}
	
	return s_fxanim;
}

// Self is array of vehicles
function activate_new_battery()
{
	level endon( "staging_area_ambient_stop" );
	
	vh_last_active = level.a_vh_active_battery[ 0 ];
	
	level.a_vh_active_battery reset_dead_turrets_target_pos();
		
	do		
	{
		level.a_vh_active_battery = array::random( level.a_batteries );
		
		{wait(.05);};
	}
	while( level.a_vh_active_battery[ 0 ] == vh_last_active );
}

function hunter_fxanim_scene_start( a_ents )
{
	level endon( "staging_area_ambient_stop" );
	
	foreach( mdl_target in a_ents )
	{
		mdl_target thread dead_system_assign_target();
	}
}

// Self is script model
function dead_system_assign_target()
{
	level endon( "staging_area_ambient_stop" );

	foreach( vh_turret in level.a_vh_active_battery )
	{
		if( !( isdefined( vh_turret.b_firing ) && vh_turret.b_firing ) )
		{
			vh_turret dead_turret_fire_at_target( self );
			break;
		}
	}
}

// Self is turret
function dead_turret_fire_at_target( mdl_target )
{
	level endon( "staging_area_ambient_stop" );
	
	self.b_firing = true;
	
//	/#
//		if( level flag::get( "vtol_ride_event_started" ) )
//		{
//			self thread ramses_util::draw_line_to_target( mdl_target, 2, "tag_flash" );
//		}
//	#/
	
	self SetTurretTargetEnt( mdl_target );
			
	self thread fire_dead_turret( mdl_target );
	
	mdl_target util::waittill_either( "hunter_explodes", "vtol_01_explodes" );
	
	wait RandomFloatRange( 0.15, 0.45 );
	
	self notify( "_stop_turret" );
	self ClearTurretTarget();
 	self LaserOff();
	self.b_firing = false;
}

// Self is turret
function can_dead_turret_see( mdl_target )
{
	return SightTracePassed( self GetTagOrigin( "tag_flash" ), mdl_target.origin, false, self );
}

// Self is turret
function fire_dead_turret( mdl_target )
{
	self endon( "death" );
	self endon( "_stop_turret" );
	mdl_target endon( "death" );
	
	self waittill( "turret_on_target" );
	
	wait RandomFloatRange( 2, 4 ); // Delay fire - TODO: investigate using notetracks if this doesn't look right
	
	// Additional delay based target type
	if( mdl_target.targetname == "lotus_dropships" )
	{
		wait RandomFloatRange( 0.05, 0.25 );
	}
	else
	{
		wait RandomFloatRange( 1, 2 );
	}
	
	while( !self can_dead_turret_see( mdl_target ) )
	{
		{wait(.05);};
	}

	self LaserOn();
	 
	if( self.script_string === "do_futz" )
	{
		self thread turret_futz_think();
	}
	
	self turret::fire_for_time( 100 ); // Fire for longer than will ever be needed - "_stop_turret" stops it
}

// HACK - increased bullet range to get the DEAD Turrets firing far enough
function debug_increase_bullet_range()
{
	n_bullet_range = GetDvarInt( "bulletrange" );
	SetDvar( "bulletrange", 65000 );
	
	level flag::wait_till( "dead_turret_stop_station_ambients" );
	
	SetDvar( "bulletrange", n_bullet_range );
}

// VO
////////////////////////////////////////////////////////////////////

function VO()
{
	level flag::wait_till( "staging_area_enter_started" ); // TODO: leaving this in case we need it for some other timing
	
	level waittill( "wall_lift_off" );
	
	level.players[0] dialog::say( "plyr_kane_patch_us_into_0", RandomFloatRange( .1, .20 ) ); 	// Player - Kane, patch us into Egyptian Army command!
	level dialog::remote( "ecmd_request_all_emergenc_0", RandomFloatRange( .1, .25 ) ); 		// egyptian army command - Request all emergency defense units move to reinforce position.
	
	level dialog::remote( "ecmd_ramses_1_1_priority_0", RandomFloatRange( .1, .25 ) ); 			// egyptian army command - Ramses 1-1, priority target is NRC Convoy moving on Eastern Checkpoint!! ETA one minute.
	level.ai_khalil dialog::say( "khal_copy_that_but_we_l_0", RandomFloatRange( .1, .25 ) ); 	// Khalil - Copy that - but we’ll need VTOL transport if we’re going to get the trucks to the Checkpoint in time!
	level dialog::remote( "ecmd_confirmed_vtol_sup_0", RandomFloatRange( .1, .25 ) ); 			// egyptian army command - Confirmed - VTOL support inbound.
	
	level flag::wait_till( "jumpdirect_scene_done" );
		
	level.ai_khalil dialog::say( "khal_we_have_to_hurry_0", RandomFloatRange( .1, .25 ) ); 		// Khalil - We have to hurry.
	
	level.ai_khalil flag::wait_till( "khalil_ready" );
	
	wait 1; //pause for pacing
	
	level.ai_khalil thread do_nag( "khal_get_in_0", 6, 9, "players_ready" , "cin_ram_04_02_easterncheck_1st_entertruck_demo" , 2 ); // Khalil - Get in.
}

// Self is an AI
function do_nag( str_nag, n_time_min, n_time_max, str_ender , str_scene , n_count_max = 1 ) //str_scene can be used to not play nag if the scene is playing
{
	level endon( str_ender );
	
	n_count = 0;
	
	while( n_count_max >= n_count )
	{
		if ( !isdefined( str_scene) || !level scene::is_playing( str_scene ) )
		{
			self dialog::say( str_nag );
			
			n_count++;
		}
		
		wait RandomFloatRange( n_time_min, n_time_max );
	}
}

// Self is an AI
function say_runners_vo()
{
	self dialog::say( "esl1_let_s_move_let_s_mo_0", RandomFloatRange( 4, 6 ) ); // Let’s move, let’s move!!
}

// Util
////////////////////////////////////////////////////////////////////

// Self is array of script structs
function init_flags( str )
{
	for( i = 0; i < self.size; i++ )
	{
		level flag::init( self[ i ].targetname + str );
	}
}

// Self is array of script structs
function wait_till_flags( str )
{
	for( i = 0; i < self.size; i++ )
	{
		level flag::wait_till( self[ i ].targetname + str );
	}
}

	/*
	 * s_grenade_amb
	 * 	s_tank_grenade_spot = struct::get( "tank_grenade_spot", "targetname" );		
	
	//play explosion fx
	s_tank_grenade_spot thread fx::play( "large_explosion", s_tank_grenade_spot.origin, s_tank_grenade_spot.angles );
	
	
	*/

function egg()
{
	a_t_pylons = GetEntArray( "temp_egg_trig", "targetname" );
	t_cancel = GetEntArray( "temp_egg_cancel_trig", "targetname" );
	
//	callbacks::on_connect( &track_pylon_jumps );
	
	array::thread_all( a_t_pylons, &track_pylon_jumps, t_cancel );
}

// Self is a player
function track_pylon_jumps( a_t_pylons, t_cancel )
{
	while( !level flag::get( "players_ready" ) )
	{
		
	}
}

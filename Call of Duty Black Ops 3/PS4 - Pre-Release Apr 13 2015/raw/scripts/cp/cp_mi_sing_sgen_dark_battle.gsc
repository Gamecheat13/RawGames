#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_pallas;
#using scripts\cp\cp_mi_sing_sgen_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       




#precache( "model", "c_54i_robot_4_body" );
#precache( "model", "c_54i_robot_4_head" );
#precache( "model", "p7_fxanim_cp_sgen_charging_station_doors_mod" );
#precache( "model", "p7_fxanim_cp_sgen_charging_station_doors_break_mod" );
#precache( "fx", "_t6/bio/player/fx_player_water_splash_mp" );

function skipto_dark_battle_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );

		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::complete( "cp_level_sgen_investigate_sgen" );
		objectives::set( "cp_level_sgen_enter_corvus" );

		sgen::wait_for_all_players_to_spawn();

		skipto::teleport_players( "post_testing_lab_igc" ); // We want to teleport even a solo player
		level thread scene::skipto_end( "cin_sgen_14_humanlab_3rd_sh200" );
	}

	// Allow things to float
	level clientfield::set( "w_underwater_state", 1 );
	spawner::add_spawn_function_group( "dark_battle_jumpdown_bot", "script_noteworthy", &jump_down_bot_mind_control );
	array::thread_all( GetEntArray( "surgical_facility_interior_door_trigger", "targetname" ), &surgical_facility_interior_door );

	level thread sgen_util::set_door_state( "surgical_catwalk_top_door", "open" );

	level._effect[ "water_rise" ] = "_t6/bio/player/fx_player_water_splash_mp";

	level thread surgical_facility();
	level thread electromagnetic_room_vo();

	nd_post_dni = GetNode( "hendricks_post_dni_lab", "targetname" );
	level.ai_hendricks SetGoal( nd_post_dni, true, 16);
}

function electromagnetic_room_vo()
{
	trigger::wait_till( "pre_electromagnetic_room_trigger", undefined, undefined, false );
	level dialog::player_say( "kane_power_s_out_ahead_s_0" );
	level.ai_hendricks dialog::say( "hend_copy_that_1" );

	trigger::wait_till( "electromagnetic_room_trigger", undefined, undefined, false );
	level dialog::player_say( "kane_picking_up_radiation_0" );

	level flag::wait_till( "optics_out" );
	level.ai_hendricks dialog::say( "hend_copy_that_optics_ju_0" );
	level.ai_hendricks dialog::say( "hend_help_me_get_up_here_0", 1 );

	level thread electromagnetic_room_vo_nag();

	level flag::wait_till( "hendricks_door_open" );
	level dialog::player_say( "plrf_good_job_hendricks_0" );
	level.ai_hendricks dialog::say( "hend_uh_i_didn_t_do_th_0" );

	trigger::wait_till( "plyr_shit_2", undefined, undefined, false );
	level dialog::player_say( "plyr_shit_2" );
	level.ai_hendricks dialog::say( "hend_what_you_got_0" );
	level dialog::player_say( "plyr_more_test_subjects_0" );

	level flag::wait_till( "water_robot_spawned" );
	wait 4; // Random time for Robot to fully emerge
	level.ai_hendricks dialog::say( "hend_they_re_in_the_water_0" );

	trigger::wait_till( "enhanced_vision_on" );
	level dialog::player_say( "plrf_kane_optics_back_on_0", 3 );
	level dialog::say( "kane_copy_that_i_m_pic_0" );
}

function electromagnetic_room_vo_nag()
{
	n_counter = 0;

	wait 8; // Give some time for players to raise Hendricks

	while ( !level flag::get( "player_raise_hendricks_hendricks" ) )
	{
		str_nag = ( n_counter % 2 == 0 ? "hend_need_a_hand_i_ain_t_0" : "hend_gimme_boost_we_need_0" );
		level.ai_hendricks dialog::say( str_nag );
		n_counter++;
		
		wait 30; // Nag wait
	}
}

function jump_down_bot_mind_control()
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
}

function skipto_dark_battle_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_sgen_enter_corvus" );
}

function handle_player_raise_animation()
{
	e_player_trigger = GetEnt( "player_raise_hendricks_trigger", "targetname" );
	e_player_trigger TriggerEnable( false );

	level flag::wait_till( "player_raise_hendricks_hendricks_ready" );
	e_player_trigger TriggerEnable( true );

	temp_obj_model = util::spawn_model( "tag_origin", e_player_trigger.origin, (0, 0, 0) );
	objectives::set( "cp_level_sgen_lift_hendricks" ,  temp_obj_model);

	e_player_trigger waittill( "trigger", triggered_player );
	objectives::complete( "cp_level_sgen_lift_hendricks" ,  temp_obj_model);

	level flag::set( "player_raise_hendricks_hendricks" );

	temp_obj_model util::self_delete();

	level thread scene::init( "cin_sgen_15_01_darkbattle_vign_new_flare_player_climb", triggered_player );
	level flag::set( "player_raise_hendricks_player_ready" );
	level thread scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_player_climb", triggered_player );
}

function surgical_facility()
{
	level thread surgical_facility_objective();
	level thread surgical_facility_robots();
	level thread surgical_facility_hendricks();
	level thread surgical_facility_door();
}

function surgical_facility_objective()
{
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "dark_battle_breadcrumb" );
	objectives::complete( "cp_level_sgen_breadcrumb" );
}

function surgical_facility_door()
{
	sgen_util::ammo_crates_toggle( "off" );

	e_door = GetEnt( "hendricks_dark_battle_top_door", "targetname" );

	level flag::wait_till( "dark_battle_hendricks_above" );

	wait 2;
	e_door RotateYaw( -90, 2 );
	wait 2; // Give Hendricks some time above to move forward first

	level thread scene::play( "door_dark_battle", "targetname" );

	e_door_clip = GetEnt( "dark_room_entrance_door_clip", "targetname" );
	e_door_clip movez( -144, 1);
	e_door_clip playsound("evt_dark_door_open");
	wait 3; // Time for doors to open
	level flag::set( "hendricks_door_open" );
	sgen_util::ammo_crates_toggle( "on" );

	level thread charging_station_objective();

	level waittill( "close_door" );

	level thread sgen_util::set_door_state( "surgical_catwalk_top_door", "close" );
}

function surgical_facility_hendricks()
{
	trigger::wait_till( "dark_battle_down_stairs", "script_noteworthy", undefined, false );

	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );

	level.ai_hendricks.goalradius = 8;

	level thread handle_player_raise_animation();

	level thread scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_arrive" );
	level.ai_hendricks waittill( "goal" );
	
	level flag::set( "player_raise_hendricks_hendricks_ready" );

	level flag::wait_till_all( Array( "player_raise_hendricks_hendricks_ready", "player_raise_hendricks_player_ready") );
	
	level scene::stop( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_arrive" );

	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_a", &surgical_facility_hendricks_a, "play" );
	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idlea", &surgical_facility_hendricks_b, "play" );
	level scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_climb" );
}

function surgical_facility_hendricks_a( a_ents )
{
	level flag::set( "dark_battle_hendricks_above" );
	playsoundatposition ("evt_hend_door_beep", (4141, -3845, -5073));
}

function surgical_facility_hendricks_b( a_ents )
{
	trigger::wait_till( "dark_battle_hendricks_flarecarry_b_trigger", undefined, undefined, false );

	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idleb", &surgical_facility_hendricks_c, "play" );
	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_b", &turn_off_flare, "play" );
	level scene::stop( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idlea" );
	level scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_b" );
}

function turn_off_flare( a_ents )
{
	level waittill( "kill_flare" );
	
	foreach( e_ent in a_ents )
	{
		if ( e_ent.targetname == "flare01" )
		{
			e_ent Delete();
		}
	}
}

function second_flare_on( a_ents )
{
	level waittill( "flare01_off" );
	
	level notify ( "kill_flare" );
}

function surgical_facility_hendricks_c( a_ents )
{
	trigger::wait_till( "dark_battle_hendricks_flarecarry_c_trigger", undefined, undefined, false );

	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idlec", &surgical_facility_hendricks_d, "play" );
	level scene::add_scene_func( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_c", &second_flare_on, "play" );
	level scene::stop( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idleb" );
	level scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_c" );
}

function surgical_facility_hendricks_d( a_ents )
{
	s_robot_carryflare_d_01	= struct::get( "dark_battle_robot_carryflare_01" );
	s_robot_carryflare_d_02 = struct::get( "dark_battle_robot_carryflare_02" );

	trigger::wait_till( "dark_battle_hendricks_flarecarry_end_trigger", undefined, undefined, false );

	s_robot_carryflare_d_01 thread scene::play();
	s_robot_carryflare_d_02 thread scene::play();
	level scene::stop( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_idlec" );
	level scene::play( "cin_sgen_15_01_darkbattle_vign_new_flare_hendricks_d" );

	level.ai_hendricks util::unmake_hero( "hendricks" );
	level.ai_hendricks util::self_delete();
}

function surgical_facility_hendricks_stop( a_ents )
{
	level.ai_hendricks scene::stop();
}

function surgical_facility_robots()
{
	a_t_robot_spawn = GetEntArray( "surgical_facility_spawn_trigger", "targetname" );
	array::thread_all( a_t_robot_spawn, &surgical_facility_spawn_trigger );
}

// self == t_robot_spawn
function surgical_facility_spawn_trigger()
{
	e_volume = undefined;
	a_e_volumes = GetEntArray( "surgical_facility_dark_battle_volume", "targetname" );
	a_s_spawn_points = struct::get_array( self.target );
	v_origin = self.origin;
	n_radius = self.radius;

	e_temp = Spawn( "script_origin", self.origin + ( 0, 0, 10 ) );
	foreach ( e_volume_lane in a_e_volumes )
	{
		if ( e_temp IsTouching( e_volume_lane ) )
		{
			e_volume = e_volume_lane;
		}
	}
	e_temp util::self_delete();

	a_s_spawn_points = array::randomize( a_s_spawn_points );

	self waittill( "trigger" );

	n_robots_to_spawn = 2;
	n_robots_max_alive = 3;

	n_players_in_lane = 0;
	n_robots_in_lane = 0;

	foreach ( player in level.players )
	{
		if ( player IsTouching( e_volume ) )
		{
			n_players_in_lane++;
		}
	}

	switch ( n_players_in_lane )
	{
		case 2:
		{
			n_robots_to_spawn = 3;
			n_robots_max_alive = 4;
		} break;
		case 3:
		{
			n_robots_to_spawn = 5;
			n_robots_max_alive = 6;
		} break;
		case 4:
		{
			n_robots_to_spawn = 7;
			n_robots_max_alive = 7;
		} break;
	}

	a_ai_robots = GetAISpeciesArray( "all", "robot" );
	foreach ( ai_robot in a_ai_robots )
	{
		if ( ai_robot IsTouching( e_volume_lane ) )
		{
			n_robots_in_lane++;
		}
	}

	foreach ( n_index, s_spawn_point in a_s_spawn_points )
	{
		if ( n_index < n_robots_to_spawn && n_robots_in_lane < n_robots_max_alive )
		{
			level thread surgical_facility_robot( s_spawn_point, n_index );
		}
	}

	level flag::set( "water_robot_spawned" );
}

function surgical_facility_robot( s_spawn_point, n_index )
{
	sp_robot = GetEnt( "surgical_facility_spawner", "targetname" );

	if ( n_index > 0 )
	{
		wait ( n_index + RandomFloatRange( 0.5, 1.5 ) );
	}

	PlayFX( level._effect[ "water_rise" ], s_spawn_point.origin );

	ai_robot = sp_robot spawner::spawn( true );
	ai_robot ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	s_spawn_point scene::play( "cin_sgen_15_04_robot_ambush_aie_arise_robot0" + RandomIntRange( 1, 3 ), ai_robot );

	ai_robot thread sgen_util::robot_init_mind_control( 2 );
	ai_robot clientfield::set( "sndStepSet", 1 );
}

function surgical_facility_interior_door()
{
	str_targetname = self.target;

	level thread sgen_util::set_door_state( str_targetname, "open" );

	self waittill( "trigger", ent );

	if ( !isdefined( level.n_surgical_facility_interior_door ) )
	{
		level.n_surgical_facility_interior_door = 1;
	}
	else
	{
		level.n_surgical_facility_interior_door++;
	}

	if ( level.n_surgical_facility_interior_door < 3 )
	{
		level thread sgen_util::set_door_state( str_targetname, "close" );
	}
}

//----------------------------------------------------------------------------
//
//

function skipto_charging_station_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::complete( "cp_level_sgen_investigate_sgen" );
		objectives::complete( "cp_level_sgen_enter_corvus" );

		sgen::wait_for_all_players_to_spawn();

		level thread charging_station_objective();
	}
	
	// Calculate the max number of enemies we'll spawn
	level.n_charging_station_spawns = 11 + ( level.players.size * 4 );

	// Allow things to float
	level clientfield::set( "w_underwater_state", 1 );
	level util::clientnotify( "sndRHStart" );

	level thread charging_station();
	level thread charging_station_power_on();
	level thread charging_station_player_vo();

	// Attach Monitors To Elevator Because Players Can See It From This Event
	cp_mi_sing_sgen_pallas::elevator_setup();

	level dialog::remote( "hend_kane_i_got_separate_0" );
}


function skipto_charging_station_done( str_objective, b_starting, b_direct, player )
{
}

function charging_station()
{
	array::run_all( GetEntArray( "charging_station_flood_trigger", "script_noteworthy" ), &SetInvisibleToAll );
	array::thread_all( GetSpawnerArray( "charging_station_corner_spawner", "script_noteworthy" ), &spawner::add_spawn_function, &charging_station_corner_robot_init );

	a_s_spawn_point = struct::get_array( "charging_station_spawn_point" );
	a_t_awaken = GetEntArray( "charging_station_trigger", "targetname" );

	foreach ( n_index, s_spawn_point in a_s_spawn_point )
	{
		s_spawn_point charging_station_spawner();

		if ( n_index % 5 == 0 )
		{
			util::wait_network_frame();
		}
	}

	mdl_test = util::spawn_model( "tag_origin" );

	foreach ( t_awaken in a_t_awaken )
	{
		t_awaken.e_volume = GetEnt( t_awaken.target, "targetname" );
		t_awaken.a_s_spawn_point = [];

		foreach ( s_spawn_point in a_s_spawn_point )
		{
			mdl_test.origin = s_spawn_point.origin;

			if ( mdl_test IsTouching( t_awaken.e_volume ) )
			{
				if ( !isdefined( t_awaken.a_s_spawn_point ) ) t_awaken.a_s_spawn_point = []; else if ( !IsArray( t_awaken.a_s_spawn_point ) ) t_awaken.a_s_spawn_point = array( t_awaken.a_s_spawn_point ); t_awaken.a_s_spawn_point[t_awaken.a_s_spawn_point.size]=s_spawn_point;;
			}
		}
		t_awaken.a_s_spawn_point = array::randomize( t_awaken.a_s_spawn_point );
	}

	mdl_test util::self_delete();

	array::thread_all( a_t_awaken, &charging_station_trigger );
}

function charging_station_objective()
{
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "charging_station_breadcrumb" );
	objectives::complete( "cp_level_sgen_breadcrumb" );
}

function charging_station_power_on()
{
	s_start_point = struct::get( "charging_station_power_on" );
	s_end_point = struct::get( s_start_point.target );

	trigger::wait_till( "enter_charging_station", undefined, undefined, false );
	
	playsoundatposition( "mus_coalescence_theme_robothall", (142,-2935,-4980) );

	level util::clientnotify( "sndRHStop" );

	a_ai_robots = GetEntArray( "charging_station_ai", "targetname" );
	a_mdl_robots = GetEntArray( "charging_station_mdl", "targetname" );
	a_e_robots = ArrayCombine( a_ai_robots, a_mdl_robots, false, false );
	a_e_robots_sorted = [];

	foreach ( e_robot in a_e_robots )
	{
		// Use X vector to turn on Robots across from each other at the same time
		n_index = sgen_util::round_up_to_ten( int( e_robot.origin[ 0 ] ) );

		if ( !isdefined( a_e_robots_sorted[ n_index ] ) )
		{
			a_e_robots_sorted[ n_index ] = [];
		}

		if ( !isdefined( a_e_robots_sorted[ n_index ] ) ) a_e_robots_sorted[ n_index ] = []; else if ( !IsArray( a_e_robots_sorted[ n_index ] ) ) a_e_robots_sorted[ n_index ] = array( a_e_robots_sorted[ n_index ] ); a_e_robots_sorted[ n_index ][a_e_robots_sorted[ n_index ].size]=e_robot;;
	}

	a_n_keys = GetArrayKeys( a_e_robots_sorted );
	a_n_keys_sorted = array::sort_by_value( a_n_keys );

	foreach ( n_index, n_key in a_n_keys_sorted )
	{
		foreach ( e_robot in a_e_robots_sorted[ n_key ] )
		{
			if ( IsAI( e_robot ) )
			{
				e_robot util::delay( n_index / 5, undefined, &ai::set_behavior_attribute, "rogue_control", "forced_level_1" );
			}
			else
			{
				e_robot util::delay( n_index / 5, undefined, &clientfield::set, "turn_fake_robot_eye", 1 );
			}
		}
	}
}

function charging_station_corner_robot_init()
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
}


//
//	This will wait for someone to enter the trigger, or wait for a flag to be set.
function wait_till_trigger_or_flag( str_flag )
{
	self endon( "trigger" );

	if ( !level flag::exists( str_flag ) )
	{
		level flag::init( str_flag );
	}
	level flag::wait_till( str_flag );
}


function charging_station_trigger()
{
	level endon( "flood_combat_terminate" );

	e_volume = self.e_volume;
	a_s_spawn_point = self.a_s_spawn_point;

	if ( isdefined( self.script_string ) )
	{
		self wait_till_trigger_or_flag( self.script_string );
	}
	else
	{
		self waittill( "trigger" );
	}

	if ( isdefined( self.script_flag ) )
	{
		level util::delay( 15, undefined, &flag::set, self.script_flag );	// Set this flag after some time delay so the battle will continue even if the player doesn't advance.
	}
	
	while ( level.n_charging_station_spawns > 0 && isdefined( a_s_spawn_point ) && a_s_spawn_point.size > 0 )
	{
		s_spawn_point = undefined;

		// Give preference to ground floor Robots
		foreach ( s_potential_spawn_point in a_s_spawn_point )
		{
			if ( !( isdefined( s_potential_spawn_point.is_second_floor ) && s_potential_spawn_point.is_second_floor ) )
			{
				s_spawn_point = s_potential_spawn_point;
			}
		}

		if ( !isdefined( s_spawn_point ) )
		{
			s_spawn_point = array::random( a_s_spawn_point );
		}

		if ( !( isdefined( s_spawn_point.activated ) && s_spawn_point.activated ) )
		{
			ArrayRemoveValue( a_s_spawn_point, s_spawn_point );

			s_spawn_point notify( "awaken" );
			
			wait ( 1.5 / level.players.size );
		}
		
		wait 0.05;	// no infinite loops
	}
}

// self == s_spawn_point
function charging_station_spawn_robot( is_real = true )
{
	sp_robot = GetEnt( "charging_station_spawner", "targetname" );

	if ( ( isdefined( is_real ) && is_real ) )
	{
		self.ai_robot = sp_robot spawner::spawn( true );
		self.ai_robot.targetname = "charging_station_ai";
		self.ai_robot ForceTeleport( self.origin, self.angles );

		self thread charging_station_spawner_think();
	}
	else
	{
		self.e_robot = util::spawn_model( "c_54i_robot_1", self.origin, self.angles );
		self.e_robot.targetname = "charging_station_mdl";

		self thread charging_station_fake_spawner_think();
	}
}

// self == s_spawn_point
function charging_station_spawner()
{
	self.angles *= -1;
	self.origin += ( 0, 0, -5.5 );
	self.is_second_floor = self.origin[ 2 ] > -5025;

	if ( ( self.script_noteworthy === "fail" ) )
	{
		self charging_station_spawn_robot( false );
		self.e_robot thread scene::play( "cin_sgen_16_01_charging_station_aie_idle_robot01", self.e_robot );
	}
	else if ( ( self.script_noteworthy === "real" ) )
	{
		self charging_station_spawn_robot();

		s_chamber = struct::get( self.target );

		self.mdl_chamber = util::spawn_model( "p7_fxanim_cp_sgen_charging_station_doors_mod", s_chamber.origin, s_chamber.angles );
		self.mdl_chamber.script_objective = "flood_combat";
		self.mdl_chamber.targetname = "pod_track_model";

		self.ai_robot thread scene::play( "cin_sgen_16_01_charging_station_aie_idle_robot01", self.ai_robot );
		self.ai_robot thread sgen_util::head_track_closest_player();
	}
	else if ( ( self.script_noteworthy === "static" ) )
	{
		self.e_eye = util::spawn_model( "tag_origin", self.origin, self.angles );
		self.e_eye.script_objective = "flood_combat";
		self.e_eye.targetname = "charging_station_mdl";
	}
}

// self == s_spawn_point
function charging_station_fake_spawner_think()
{
	level endon( "charging_station_terminate" );

	v_origin = self.origin - VectorScale( AnglesToForward( self.angles ), 80 );
	n_width = ( math::cointoss() ? 128 : ( math::cointoss() ? 64 : 256 ) ); // Random width for Robots waking up locked up inside chamber. 50% chance for 128 and 25% for 64 or 256

	e_trigger = Spawn( "trigger_box", v_origin, 0, n_width, 128, 128 );
	e_trigger.script_objective = "charging_station";
	e_trigger trigger::wait_till();

	e_trigger util::self_delete();

	self.e_robot thread scene::play( "cin_sgen_16_01_charging_station_aie_fail_robot01", self.e_robot );
}

// self == s_spawn_point
function charging_station_spawner_think()
{
	level endon( "pallas_elevator_starting" );

	str_event = self util::waittill_any_return( "awaken", "post_pallas" );

	self.activated = true;

	if ( ( str_event === "awaken" ) )
	{
		level.n_charging_station_spawns--;
		self.mdl_chamber SetModel( "p7_fxanim_cp_sgen_charging_station_doors_break_mod" );

		str_robot_anim = "cin_sgen_16_01_charging_station_aie_awaken_robot0";
		str_robot_anim += ( self.angles[ 1 ] == -90 ? RandomIntRange( 1, 4 ) : RandomIntRange( 4, 7 ) );
		str_chamber_anim = ( math::cointoss() ? "p7_fxanim_cp_sgen_charging_station_break_02_bundle" : "p7_fxanim_cp_sgen_charging_station_break_03_bundle" );

		str_robot_anim = ( ( isdefined( self.is_second_floor ) && self.is_second_floor ) ? "cin_sgen_16_01_charging_station_aie_awaken_robot05_jumpdown" : str_robot_anim );
		str_chamber_anim = ( ( isdefined( self.is_second_floor ) && self.is_second_floor ) ? "p7_fxanim_cp_sgen_charging_station_break_01_bundle" : str_chamber_anim );

		self thread charging_station_spawner_break_glass( str_chamber_anim );
		self.ai_robot thread scene::play( str_robot_anim, self.ai_robot );

		self.ai_robot thread sgen_util::robot_init_mind_control( 2 );

		level flag::set( "pod_robot_spawned" );
	}
}

// self == s_spawn_point
function charging_station_spawner_break_glass( str_chamber_anim )
{
	self.ai_robot endon( "death" );

	self.ai_robot waittill( "breakglass" );
	self.mdl_chamber thread scene::play( str_chamber_anim, self.mdl_chamber );
}

function charging_station_player_vo()
{
	trigger::wait_till( "enter_charging_station", undefined, undefined, false );

	level dialog::player_say( "plyr_robot_charging_stora_0" );
	level dialog::say( "kane_easy_take_your_ti_0" );

	level flag::wait_till( "pod_robot_spawned" );

	level dialog::player_say( "plyr_contact_0" );
	level dialog::say( "kane_get_outta_there_i_g_0", 2 );
}

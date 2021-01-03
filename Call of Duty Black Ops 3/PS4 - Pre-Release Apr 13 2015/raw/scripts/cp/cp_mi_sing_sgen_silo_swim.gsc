#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_endmission;
#using scripts\cp\_hazard;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\cp\_skipto;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\cp_mi_sing_sgen_util;
#using scripts\cp\cp_mi_sing_sgen_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                       

// Depth Charges Notes
//
// script_models are static or drop straight down.
// script_vehicles are spawned / swapped with script_models and then go directly for the Player.
//
// Both use the same function with some specific type checks and logic, but essentially are setup to behave the same and transition from one to the other smoothly.

function skipto_silo_swim_init( tr_objective, b_starting )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );

	setdvar( "player_swimTime", 5000 );

	level thread main();
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "water_exit" );

	exploder::exploder( "lights_sgen_swimup" );

	if ( b_starting )
	{
		level clientfield::set( "w_underwater_state", 1 );

		spawner::add_global_spawn_function( "axis", &sgen_util::robot_underwater_callback );

		objectives::set( "cp_level_sgen_escape_sgen" );
	}

	spawner::add_global_spawn_function("axis", &silo_swim_accuracy );
}

function skipto_silo_swim_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_sgen_escape_sgen" );
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "water_exit", true );
}

function main()
{
	level thread trigger_depth_charges();
	level thread handle_hendricks_path();
	level thread depth_vtol_setup();
	level thread rock_falling();
	level thread do_depth_swarm_event();
	level thread silo_swim_vo();
	level thread sticky_player_in_place_depth_charge();
	level thread room_drowning();
	level thread silo_debris_fx_anim();
	level thread silo_swim_objective();

	a_static_charge = struct::get_array( "static_depth_charge", "targetname" );
	array::thread_all( a_static_charge, &static_depth_charge_setup );

	array::thread_all( GetEntArray( "drowning_trigger", "targetname" ), &drowning_54i );

	array::thread_all( GetEntArray( "floating_hallway_a", "targetname" ), &sway, 12, 1, 3 );
	wait 3; // Don't want them moving in exactly the same manner
	array::thread_all( GetEntArray( "floating_hallway_b", "targetname" ), &sway, 9, 2, 5 );
}

function silo_swim_objective()
{
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "silo_swim_breadcrumb" );
	objectives::complete( "cp_level_sgen_breadcrumb" );
}

function silo_swim_accuracy()
{
	util::wait_network_frame();
	self.accuracy = 0.1;
}

function sticky_player_in_place_depth_charge()
{
	level endon( "hendricks_move_up_3" );

	n_player_seat = 1;

	while ( true )
	{
		e_trig = trigger::wait_till( "depth_charge_swarm_trigger", "targetname" );

		if ( IsDefined( e_trig.who ) && !( isdefined( e_trig.who.is_sticky ) && e_trig.who.is_sticky ) && IsAlive( e_trig.who ) )
		{
			e_trig.who.is_sticky = true;

			e_trig.who thread sticky_player_in_place_depth_charge_start( n_player_seat );
			e_trig.who thread sticky_player_in_place_depth_charge_done();

			n_player_seat++;
		}
	}
}

function sticky_player_in_place_depth_charge_start( n_player_seat )
{
	self util::magic_bullet_shield();//We don't want the player to die during this sequence
	self WalkUnderwater( true );
	level scene::play( "p_rifle_sgen_silo_swimming_bridge_p" + n_player_seat, self );

	e_player_link = util::spawn_model( "tag_origin", self.origin, self.angles ); //HACK - link player while we wait for anim fixes
	self PlayerLinkToDelta( e_player_link, undefined, 0, 180, 180, 180, 0, 0, 0 );
}

function sticky_player_in_place_depth_charge_done()
{
	self endon( "disconnect" );

	level flag::wait_till( "hendricks_move_up_3" );

	//TODO - when anims come online, we need to time the player release after Hendricks so he leads us up
	wait .2;
	self Unlink();
	self WalkUnderwater( false );
	self util::stop_magic_bullet_shield();
}

function silo_swim_vo()
{
	level endon( "silo_complete" );

	level.ai_hendricks dialog::remote( "hend_alright_stay_on_my_0" ); // Intro event nag line to follow Hendricks

	level flag::wait_till( "hendricks_move_up_2" );
	level dialog::remote( "kane_heads_up_spotted_a_0", 1 );

	level flag::wait_till( "silo_swim_take_out" );
	level.ai_hendricks dialog::remote( "hend_take_out_those_charg_0", .1 );

	level flag::wait_till( "silo_swim_bridge_collapse" );
	level.ai_hendricks dialog::remote( "hend_bridge_coming_down_0" );

	trigger::wait_till( "kane_careful_charges_are_0", undefined, undefined, false );
	level dialog::remote( "kane_careful_charges_are_0" );

	trigger::wait_till( "kane_that_hallway_should_0", undefined, undefined, false );
	level dialog::remote( "kane_that_hallway_should_0" );
	level dialog::remote( "kane_hang_on_something_s_0" );
	level dialog::remote( "kane_futz_we_hav_0" );

	level flag::wait_till( "hendricks_move_up_4" );
	level.ai_hendricks dialog::remote( "hend_we_gotta_get_up_ther_0" );
	level.ai_hendricks dialog::remote( "hend_your_o2_levels_are_d_0", 3 );

	trigger::wait_till( "hend_your_o2_level_s_crit_0", undefined, undefined, false );
	level.ai_hendricks dialog::remote( "hend_your_o2_level_s_crit_0", 3 );
	level.ai_hendricks dialog::remote( "hend_go_go_go_1" );
}

function depth_vtol_setup()
{
	trigger::wait_till( "depth_charge_swarm_trigger" );//TODO time this better with the enter anim instead

	v_spawner = GetEnt( "depth_charge_carrier", "targetname" );
	v_carrier = vehicle::simple_spawn_single( "depth_charge_carrier" );
	v_carrier util::magic_bullet_shield();
	v_carrier vehicle::get_on_and_go_path( "dc_node" );

	v_carrier waittill( "reached_end_node" );
	v_carrier SetHoverParams( 10, 10, 10 );

	v_carrier thread spawn_depth_charge_on_pass();

	level waittill( "silo_complete" );

	v_carrier util::stop_magic_bullet_shield();
	v_carrier util::self_delete();
}

function handle_hendricks_path()
{
	level endon( "kill_hendricks_movement" );

	trigger::wait_till( "silo_hendricks_start_trigger", undefined, undefined, false );
	level thread player_out_of_air_sequence();
	// level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_start" );

	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_1st_point" );
	level.ai_hendricks waittill( "idle_start" );

	// level flag::wait_till( "hendricks_move_up_2" );
	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_shaft" );
	level.ai_hendricks waittill( "idle_start" );

	level flag::wait_till( "hendricks_move_up_3" ); // via script
	level scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_thru_shaft" );
	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_upper_tunnel" );

	level flag::wait_till( "hendricks_move_up_4" );
	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_balconies" );
	level.ai_hendricks waittill( "idle_start" );

	level flag::wait_till ( "hendricks_move_up_5" );
	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_rocks" );
	level.ai_hendricks waittill( "idle_start" );

	level notify( "start_rock_sliding" );
	level thread scene::play( "cin_sgen_25_01_siloswim_vign_coverswim_hendricks_surface" );
}

function spawn_depth_charge_on_pass()
{
	level endon( "silo_complete");

	dp_charge_volume = GetEnt( "depth_charge_carrier_volume", "targetname" );
	a_moving_charge = struct::get_array( "moving_depth_charge", "targetname" );
	a_moving_charge = array::get_all_closest( self.origin, a_moving_charge);
	spawn_index = 0;

	while ( true )
	{
		spawn_index = ( spawn_index < a_moving_charge.size ? spawn_index + 1 : 0 );

		if ( IsDefined( a_moving_charge[ spawn_index ] ) )
		{
			self thread create_depth_charge( "script_model", a_moving_charge[ spawn_index ] );
		}

		wait 0.5;
	}
}

function spawn_intro_depth_charge()
{
	a_s_start = struct::get_array( "intro_start_node", "targetname" );
	a_s_target = struct::get_array( "intro_mid_node", "targetname" );

	s_start = array::random( a_s_start );
	s_target = array::random( a_s_target );

	vh_depth_charge = s_start create_depth_charge( "script_vehicle", s_target );
	vh_depth_charge thread track_intro_depth_charge();
}

function track_intro_depth_charge()
{
	self waittill( "death" );

	if(!isdefined(level.n_depth_charges_killed))level.n_depth_charges_killed=0;
	level.n_depth_charges_killed++;

	if ( level.n_depth_charges_killed == level.n_total_charges )
	{
		level flag::set( "depth_charges_cleared" );
	}
}

function static_depth_charge_setup()
{
	e_depth_charge = self create_depth_charge( "script_model", undefined );

	e_depth_charge endon( "death" );
}

function create_depth_charge( str_type = "script_model", s_start, should_ignore_player = false )
{
	if ( level flag::get( "silo_complete" ) )
	{
		return;
	}

	e_depth_charge = undefined;

	if ( ( str_type === "script_model" ) )
	{
		e_depth_charge = self create_depth_charge_model();

		if ( IsDefined( s_start ) )
		{
			e_depth_charge.targetname = "depth_charger_dive";
			e_depth_charge thread handle_movement( s_start );
		}
		else
		{
			e_depth_charge.targetname = "depth_charger_static";
			e_depth_charge thread util::delay( RandomFloatRange( 0.5, 5.0 ), undefined, &sway, 5, 8, 18 );
		}

		e_depth_charge thread detect_nearby_player( 512 );
	}
	else // Vehicle
	{
		e_depth_charge = self create_depth_charge_vehicle();

		e_depth_charge.origin = self.origin;
		e_depth_charge.angles = self.angles;

		e_depth_charge thread track_completion_cleanup();
		e_depth_charge thread handle_movement( s_start, should_ignore_player );

		if ( ( self.classname === "script_model" ) )
		{
			self util::self_delete();
		}
	}

	return e_depth_charge;
}

function create_depth_charge_vehicle( v_origin )
{
	vh_depth_charge = undefined;

	while ( !IsDefined( vh_depth_charge ) )
	{
		vh_depth_charge = vehicle::simple_spawn_single( "depth_charge_spawner", true );

		util::wait_network_frame();
	}

	vh_depth_charge thread init_depth_charge();
	vh_depth_charge SetNearGoalNotifyDist( ( 200 * 0.60 ) / 2 );
	// vh_depth_charge thread pursuit_sound();

	return vh_depth_charge;
}

function create_depth_charge_model()
{
	e_depth_charge = util::spawn_model( "veh_t7_drone_depth_charge", self.origin, ( RandomInt( 360 ), RandomInt( 360 ), RandomInt( 360 ) ) );

	if ( IsDefined( e_depth_charge ) )
	{
		e_depth_charge.script_noteworthy = "depth_charge_model";
		e_depth_charge SetCanDamage( true );
		e_depth_charge.health = 999999; // Not relevant because they blow on the first shot but bug fix for chained explosions
		e_depth_charge clientfield::set( "sm_depth_charge_fx", 1 );

		e_depth_charge thread create_depth_charge_model_aim_assist();
		e_depth_charge thread handle_damage();
	}

	return e_depth_charge;
}

function create_depth_charge_model_aim_assist()
{
	self endon( "death" );

	level flag::wait_till( "depth_charges_cleared" );

	self EnableAimAssist();
}

function handle_movement( s_target, should_ignore_player )
{
	self endon( "death" );
	self endon( "enemy_close" );

	if ( !IsVehicle( self ) )
	{
		self thread early_explosion();
	}
	else
	{
		if ( !IsDefined( s_target ) )
		{
			s_target = ( IsDefined( self._activated_player ) ? self._activated_player : array::random( level.players ) );
		}
	}

	while ( IsDefined( s_target ) )
	{
		n_distance = Distance( self.origin, s_target.origin );
		n_time = ( n_distance / 200 );

		if ( IsVehicle( self ) )
		{
			if ( IsPlayer( s_target ) )
			{
				self SetVehGoalPos( self GetClosestPointOnNavVolume( s_target GetEye(), 512 ), true, 1 );
			}
			else
			{
				self SetVehGoalPos( s_target.origin, true, 1 );
			}

			self util::waittill_either( "goal", "at_anchor" );
		}
		else
		{
			self MoveTo( s_target.origin, n_time );
			self waittill( "movedone" );
		}

		if ( IsVehicle( self ) )
		{
			if ( !IsDefined( s_target ) || !IsPlayer( s_target ) && !( isdefined( should_ignore_player ) && should_ignore_player ) )
			{
				s_target = ( IsDefined( self._activated_player ) ? self._activated_player : array::random( level.players ) );
			}
			else
			{
				s_target = undefined;
			}
		}
		else
		{
			s_target = ( IsDefined( s_target.target ) ? struct::get( s_target.target, "targetname" ) : undefined );
		}
	}

	self detonate_depth_charge();
}

function handle_damage()
{
	self endon( "death" );

	self waittill( "damage", damage, e_attacker );

	self detonate_depth_charge( IsDefined( e_attacker ) && IsPlayer( e_attacker ) );
}

function early_explosion()
{
	self endon( "death" );
	self endon( "enemy_close" );

	n_fuse_time = RandomFloatRange( 4, 22 );
	wait n_fuse_time;

	self detonate_depth_charge();
}

function detect_nearby_player( n_update_range = 512 )
{
	level endon( "silo_complete" );

	self endon( "enemy_close" );
	self endon( "death" );

	self thread chase_nearby_player();

	e_safe = GetEnt( "silo_swim_safe_area", "targetname" );

	while ( true )
	{
		foreach ( player in level.players)
		{
			if ( !player IsTouching( e_safe ) && !player IsInMoveMode( "ufo", "noclip" ) )
			{
				if ( DistanceSquared( player.origin, self.origin ) < ( (n_update_range) * (n_update_range) ) )
				{
					self._activated_player = player;
					self notify( "enemy_close" );
				}
			}

			if ( ( self.classname === "script_model" ) )
			{
				if ( DistanceSquared( self.origin, player.origin ) < ( (n_update_range * 1.8) * (n_update_range * 1.8) ) )
				{
					self clientfield::set( "sm_depth_charge_fx", 0 );
				}
				else
				{
					self clientfield::set( "sm_depth_charge_fx", 1 );
				}
			}
		}

		wait .1;
	}
}

function chase_nearby_player()
{
	self endon( "death" );

	self waittill( "enemy_close" );

	if ( !level flag::get( "silo_complete" ) )
	{
		self thread create_depth_charge( "script_vehicle" );
	}
	else
	{
		self detonate_depth_charge();
	}
}

function trigger_depth_charges()
{
	level flag::wait_till( "hendricks_move_up_3" );

	scene::add_scene_func( "p7_fxanim_cp_sgen_bridge_silo_collapse_bundle", &bridge_scene, "play" );
	a_s_targets = struct::get_array( "bridge_collapse_dp_target", "targetname");

	foreach ( s_target in a_s_targets )
	{
		depth_charge = s_target create_depth_charge( "script_vehicle", s_target, true );
	}

	level flag::wait_till( "silo_swim_take_out" );

	level thread scene::play( "bridge_collapse", "targetname");
}

function bridge_scene( a_ents )
{
	t_hurt1 = GetEnt( "bridge_side1", "targetname" );
	t_hurt1 EnableLinkTo();
	t_hurt1 LinkTo( a_ents[ "bridge_silo_collapse" ], "bridge_main_fall_01_jnt" );

	t_hurt2 = GetEnt( "bridge_side2", "targetname" );
	t_hurt2 EnableLinkTo();
	t_hurt2 LinkTo( a_ents[ "bridge_silo_collapse" ], "bridge_main_fall_02_jnt" );

	while ( level scene::is_playing( "p7_fxanim_cp_sgen_bridge_silo_collapse_bundle" ) )
	{
		a_e_depth_charge = GetEntArray( "depth_charger_static", "targetname" );

		foreach ( e_depth_charge in a_e_depth_charge )
		{
			if ( e_depth_charge IsTouching( t_hurt1 ) || e_depth_charge IsTouching( t_hurt2 ) )
			{
				e_depth_charge thread detonate_depth_charge();
			}
		}
		
		{wait(.05);};
	}

	t_hurt1 Delete();
	t_hurt2 Delete();
}

function pursuit_sound()
{
	self PlayLoopSound ( "veh_depth_charge_chase", .5);
	self waittill( "death");
	self StopLoopSound ( .2);
}

function detonate_depth_charge( should_chain = false )
{
	if ( !IsDefined( self ) )
	{
		return; // This shouldn't really happen if at all
	}
	
	v_origin = self.origin;

	RadiusDamage( v_origin, 200, 40, 80 );
	PlayRumbleOnPosition( "grenade_rumble", v_origin );
	Earthquake( 0.5, 0.5, v_origin, 150 );

	if ( ( self.classname === "script_model" ) )
	{
		PlayFx( level._effect[ "depth_charge_explosion" ], v_origin );
		PlaySoundAtPosition( "exp_drone_underwater", v_origin );

		self util::self_delete();
	}
	else // Vehicle
	{
		self DoDamage( self.health + 1000, self.origin, array::random( level.players ), self, "none", "MOD_EXPLOSIVE" );
	}

	wait 0.1;

	if ( ( isdefined( should_chain ) && should_chain ) )
	{
		a_e_depth_charges = ArrayCombine( GetEntArray( "depth_charge_model", "script_noteworthy" ), GetEntArray( "dept_charge_spawner_vh", "targetname" ), false, false );
		a_e_depth_charges = ArraySortClosest( a_e_depth_charges, v_origin, undefined, 0, ( 200 * 0.60 ) );

		foreach ( e_depth_charge in a_e_depth_charges )
		{
			e_depth_charge detonate_depth_charge();
		}
	}
}

function rock_falling()
{
	t_damage = GetEnt( "rock_slide_trigger", "targetname" );
	t_damage TriggerEnable( false );

	level waittill( "start_rock_sliding" );

	v_depth_charger = vehicle::simple_spawn_single( "rock_suicide_drone" );
	v_depth_charger SetVehGoalPos( v_depth_charger.origin + ( 0, 0, -350 ) );

	wait 2.5;//Give time to get into position //TODO switch this over to use node info

	v_depth_charger detonate_depth_charge();
	level thread scene::play( "p7_fxanim_cp_sgen_boulder_silo_depth_charge_bundle" );

	//time when the rock is on top of the robot to enable to damage trigger
	level waittill( "rocks_crush_robots" );//notetrack

	t_damage TriggerEnable( true );
	level waittill( "rocks_impact_01" );//notetrack
	t_damage Delete();
}

function do_depth_swarm_event()
{
	trigger::wait_till( "depth_charge_swarm_trigger");

	level.n_total_charges = ( level.players.size * 4 ) + 4;

	for ( i = 0; i < level.n_total_charges; i++ )//TODO - base amount of depth charges on players, let's play with this number
	{
		level thread spawn_intro_depth_charge();

		if ( i == 3 )
		{
			level flag::set( "silo_swim_take_out" );
		}

		wait RandomFloatRange( 1, 1.2 );
	}

	//time the hendricks moving up after all depth charge passed.
	level flag::wait_till( "depth_charges_cleared" );

	level flag::set( "hendricks_move_up_3" );
}

//TODO - change the timing of the initial fade, it's currently too soon
function player_out_of_air_sequence()
{
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.9, 1 );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );

	wait 1;
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.0, 1 );

	level flag::wait_till( "hendricks_move_up_3" );

	wait .2;//TODO tie this to the scene once we get it
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.8, 0.5 );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );

	wait 1;
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.0, 1 );

	level flag::wait_till( "hendricks_move_up_4" );

	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.8, 0.5 );
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );

	wait 1;
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.0, 1 );

	trigger::wait_till( "mission_complete_trigger" );

	level thread util::set_streamer_hint( 5 );

	array::thread_all( level.players, &util::screen_fade_to_alpha, 1, 0.5 );

	wait 0.5;
	array::run_all( level.players, &PlayRumbleOnEntity, "damage_heavy" );
	level notify( "kill_hendricks_movement" );

	level notify( "player_reach_top" );
	level util::clientnotify( "tuwco"); //trigger normal water context

	wait 0.2;
	array::thread_all( level.players, &util::screen_fade_to_alpha, 0.0, 1 );
	array::run_all( level.players, &EnableInvulnerability );

	level thread sgen_end_igc();
}

function room_drowning()
{
	level flag::wait_till_any( Array( "ai_drowning", "hendricks_move_up_5" ) );//trigger based flags

	util::delay( RandomFloatRange( .5, 1 ), undefined, &scene::play, "cin_sgen_25_02_siloswim_vign_windowbang_54i02_drowning" );
	util::delay( RandomFloatRange( 2, 3 ), undefined, &scene::play, "cin_sgen_25_02_siloswim_vign_windowbang_54i03_drowning" );
}

function sgen_end_igc()
{
	level scene::add_scene_func( "cin_sgen_26_01_lobbyexit_1st_escape_outro", &escape_outro, "done" );

	level sgen_util::fade_out();
	level thread sgen_end_igc_exploder_swap();
	array::thread_all( GetAITeamArray( "axis" ), &util::self_delete );
	wait 1; // Time for the swap
	level thread sgen_util::fade_in();

	level thread scene::play( "cin_sgen_26_01_lobbyexit_1st_escape_outro" );
	level thread scene::play( "p7_fxanim_cp_sgen_end_building_collapse_debris_bundle" );
}

function sgen_end_igc_exploder_swap()
{
	exploder::kill_exploder( "lights_sgen_swimup" );
	exploder::exploder( "lights_sgen_afterswim" );
}

function escape_outro( a_ents )
{
	util::clear_streamer_hint();
	skipto::objective_completed( "silo_swim" );
}

//self = depth charge vehicle
function init_depth_charge()
{
	level endon( "silo_complete" );

	self waittill( "death" );
	self Ghost();//Hide the death model since we dont care about it

	wait 0.3;	// wait for the fx to finish, once we delete the fx will go away

	if ( IsDefined( self ) )
	{
		self Delete();
	}
}

//self = depth charge vehicle
function track_completion_cleanup()
{
	self endon( "death" );

	level flag::wait_till( "silo_complete" );

	self Delete();
}

function silo_debris_fx_anim()
{
	level thread silo_debris_tunnel_fx_anim();

	trigger::wait_till( "silo_swim_vo_1" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );

	trigger::wait_till( "silo_debris" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );

	level flag::wait_till( "hendricks_move_up_4" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );

	level flag::wait_till( "hendricks_move_up_5" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );

	level flag::wait_till( "silo_complete" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );
}

function silo_debris_tunnel_fx_anim()
{
	level flag::wait_till( "ai_drowning" );
	array::thread_all( level.players, &clientfield::increment_to_player, "silo_debris" );
}

function sway( n_time = 10, n_min = 1, n_max = 3 )
{
	level endon( "silo_complete" );
	self endon( "death" );

	v_home_origin = self.origin;
	v_home_angles = self.angles;

	while ( true )
	{
		v_movement = ( RandomIntRange( n_min, n_max ), RandomIntRange( n_min, n_max ), RandomIntRange( n_min, n_max ) ) * .75;
		v_rotation = ( RandomIntRange( n_min, n_max ), RandomIntRange( n_min, n_max ), RandomIntRange( n_min, n_max ) );

		self MoveTo( v_home_origin + v_movement, n_time, .5, .5 );
		self RotateTo( v_home_angles + v_rotation, n_time, .5, .5 );
		wait n_time;

		self MoveTo( v_home_origin - v_movement, n_time, .5, .5 );
		self RotateTo( v_home_angles - v_rotation, n_time, .5, .5 );
		wait n_time;
	}
}

function drowning_54i()
{
	a_s_bundles = struct::get_array( self.target );

	array::thread_all( a_s_bundles, &scene::init );

	self trigger::wait_till();

	foreach ( n_index, s_bundle in a_s_bundles )
	{
		s_bundle thread util::delay( ( n_index + 1 ) / 5, undefined, &scene::play );
	}
}

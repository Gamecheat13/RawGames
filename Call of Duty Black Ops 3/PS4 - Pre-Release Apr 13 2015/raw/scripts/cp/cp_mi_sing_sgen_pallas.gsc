#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_sing_sgen_util;

#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\damagefeedback_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_oed;
#using scripts\cp\_dialog;
#using scripts\cp\cybercom\_cybercom_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;
#using scripts\cp\cp_mi_sing_sgen_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                       
                                                                                                      	                       	     	                                                                     

#precache( "model", "p7_monitor_server_room_extra_cam_01" );


#precache( "eventstring", "weakpoint_update" );
#precache( "string", "tag_weakpoint" );
#precache( "string", "CP_MI_SING_SGEN_HENDRICKS_KILLED" );
#precache( "triggerstring", "CP_MI_SING_SGEN_DESTROY_PILLAR" );



function skipto_pallas_start_init( str_objective, b_starting )
{
	spawner::add_spawn_function_group( "pallas_bot", "script_noteworthy", &robot_mindcontrol );
	spawner::add_spawn_function_group( "intro_bot", "script_noteworthy", &intro_mindcontrol );
	spawner::add_spawn_function_group( "pallas_core_guard", "script_noteworthy", &robot_mindcontrol_core_guard );
	spawner::add_spawn_function_group( "pallas_center_guard", "script_noteworthy", &robot_mindcontrol_center_guard );
	spawner::add_spawn_function_group( "pallas_shooter", "script_noteworthy", &robot_mindcontrol_shoot_glass );
	
	level flag::set( "pallas_start" );
	level.pallas_tower_down = 0;
	
	level thread init_fxanim_hoses();
	
	if ( b_starting )
	{
		objectives::complete( "cp_level_sgen_enter_sgen" );
		objectives::complete( "cp_level_sgen_investigate_sgen" );
		objectives::complete( "cp_level_sgen_enter_corvus" );
		
		elevator_setup();
		elevator_set_door_state( "back", "open" );

		e_lift = GetEnt( "boss_fight_lift", "targetname" );
		e_lift MoveZ( 1750 * -1, 0.1 );		
	
		sgen::wait_for_all_players_to_spawn();
	}
	
	level.robot_climb_starts = struct::get_array( "assault_robot_struct", "targetname" );
	level thread zombie_bot_manager();
	level thread pallas_center_guard_mode();
	level thread pallas_greeting_event( b_starting );
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "pallas" );
	
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );
	
	if( b_starting )
	{
		level thread handle_pallas_animation();
	}
	
	level thread do_hendricks_hacking();
	level thread sgen_util::delete_corpse();
	level thread handle_pallas_pillar_weakspot();	
	
	//skipto wait in case pallas isn't init yet.
	while( !isdefined( level.pallas ) )
	{
		{wait(.05);};
	}

	if( !b_starting )
	{	
		objectives::set( "cp_level_sgen_confront_pallas", level.pallas );
	}
}

function skipto_pallas_start_done( str_objective, b_starting, b_direct, player )
{
	a_pallas_bot = GetAITeamArray( "team3" );
	
	foreach( bot in a_pallas_bot)
	{
		bot Delete();
	}
	
	level flag::set( "pallas_end" );
	level thread cp_mi_sing_sgen_sound::sndMusicSet( "pallas", true );
}

function skipto_pallas_end_init( str_objective, b_starting )
{	
	e_lift = GetEnt( "boss_fight_lift", "targetname" );
	//e_lift clientfield::set( "sm_elevator_extracam", 2 );
	level thread hide_cracked_glass();

	if( b_starting )
	{
		sgen::init_hendricks( str_objective );

		elevator_setup();
		elevator_set_door_state( "back", "open" );

		e_lift MoveZ( 1750 * -1, 0.05 );

		sgen::wait_for_all_players_to_spawn();
	}
	
	level thread util::set_streamer_hint( 3 );
	level thread util::set_streamer_hint( 4 );

	level thread all_hoses_break();
	level scene::add_scene_func( "cin_sgen_19_ghost_3rd_sh110", &ghost_3rd_sh110, "play" );
	level scene::add_scene_func( "cin_sgen_19_ghost_3rd_sh190", &pallas_end_igc_complete, "done" );
	level thread scene::play( "p7_fxanim_cp_sgen_pallas_ai_tower_collapse_bundle" );
	level thread delete_geo_tower();
	level scene::play( "cin_sgen_19_ghost_3rd_sh010" );
}

function ghost_3rd_sh110( a_ents )
{	
	foreach ( e_in_scene in a_ents )
	{
		if ( e_in_scene == level.ai_hendricks )
		{
			e_in_scene cybercom::cyberCom_armPulse(1);
		}
	}
}

function delete_geo_tower()
{
	wait .05;//Give time for scene to setup
	a_e_core = GetEntArray( "pallas_core_destruct", "targetname" );
	array::run_all( a_e_core, &Delete );
	
	a_e_rail = GetEntArray( "pallas_rail_destruct", "targetname" );
	array::run_all( a_e_rail, &Delete );
}

function skipto_pallas_end_done( str_objective, b_starting, b_direct, player )
{
}

function pallas_end_igc_complete( a_ents )
{
	util::clear_streamer_hint();
	skipto::objective_completed( "pallas_end" );
}

function skipto_descent_init( str_objective, b_starting )
{	
	if ( b_starting )
	{
		objectives::set( "cp_level_sgen_find_pallas" );
		objectives::set( "cp_level_sgen_pallas_elevator" , struct::get( "pallas_elevator_descent_objective" ) );
		elevator_setup();
	}

	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );
	level thread handle_pallas_animation();
	level thread elevator_lift_intro();
	level thread descent_vo();	
}

function descent_vo()
{
	level waittill( "elevator_vo" );
	level dialog::player_say( "diaz_listen_do_you_hea_0" );
	level dialog::player_say( "plyr_you_say_something_0" );
	level dialog::player_say( "diaz_there_is_blood_on_ou_0" );
	level dialog::player_say( "plyr_who_is_this_0" );
	level dialog::player_say( "diaz_you_know_who_i_am_i_0" );
	level dialog::player_say( "plyr_kane_i_ve_got_diaz_0" );
	level dialog::player_say( "diaz_taylor_is_right_0" );
	level dialog::player_say( "hend_diaz_how_the_fuck_0" );
	level dialog::player_say( "plyr_he_s_right_here_0" );
	level dialog::player_say( "hend_what_the_fuck_is_hap_0" );
	level dialog::player_say( "kane_oh_my_god_he_s_wi_0" );
	level dialog::player_say( "plyr_kane_is_diaz_the_on_0" );
	level dialog::player_say( "kane_he_s_directly_contro_0" );
	level dialog::player_say( "hend_he_s_frying_his_god_0" );
	level dialog::player_say( "kane_listen_to_me_we_0", 1 );
	level dialog::player_say( "kane_we_know_they_re_comp_0", 1 );
	level dialog::player_say( "kane_right_now_he_s_uploa_0", 1 );
	level dialog::player_say( "plyr_diaz_you_have_to_s_0", 1 );
	level dialog::player_say( "kane_take_him_out_you_ha_0", 1 );
}

function skipto_descent_done( str_objective, b_starting, b_direct, player )
{

}

function link_elevator_light_probe()
{
	a_probes = GetEntArray( "pallas_elevator_probe", "targetname" );
	a_lights = GetEntArray( "pallas_elevator_light", "script_noteworthy" );
	
	e_lift = GetEnt( "boss_fight_lift", "targetname" );
	
	array::run_all( a_lights, &LinkTo, e_lift );
	array::run_all( a_probes, &LinkTo, e_lift );	
}

function handle_pallas_animation()
{
	scene::add_scene_func( "cin_sgen_18_01_pallasfight_vign_crucifix_pallas_loop", &scene_callback_pallas_loop, "play" );
	scene::add_scene_func( "cin_sgen_18_01_pallasfight_vign_crucifix_pallas_pip_loop", &scene_callback_pallas2_loop, "play" );
	
	e_pallas_spawner = GetEnt( "pallas", "targetname");
	e_pallas_spawner2 = GetEnt( "pallas2", "targetname");
	e_pallas_spawner spawner::add_spawn_function( &pallas_init );
	e_pallas_spawner2 spawner::add_spawn_function( &pallas_init, true );

	level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_loop");
	level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_pip_loop");
	level waittill( "pallas_attacked" );
	//level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_stage2");//TODO - need updated version from animation
	//level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_pip_stage2");
	level waittill( "pallas_attacked" );
	//level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_stage3");
	//level thread scene::play("cin_sgen_18_01_pallasfight_vign_crucifix_pallas_pip_stage3");
	level waittill( "pallas_death" );
	//level thread scene::stop( "cin_sgen_18_01_pallasfight_vign_crucifix_pallas_stage3" );
	//level thread scene::stop( "cin_sgen_18_01_pallasfight_vign_crucifix_pallas_pip_stage3" );
	level.pallas2 Delete();
}

function scene_callback_pallas_loop( a_ents )
{
	level.pallas = a_ents[ "pallas_model" ];
}

function scene_callback_pallas2_loop( a_ents )
{
	level.pallas2 = a_ents[ "pallas2_model" ];
}

function pallas_init( b_doppelganger = false )
{
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self SetForceNoCull();
	if( b_doppelganger )
	{
		level.pallas2 = self;
		self.propername = "Diaz";
	}
	else
	{
		level.pallas = self;	
	}
	self DisableAimAssist();
	self util::magic_bullet_shield( );
}

function do_hendricks_hacking()
{
	level.ai_hendricks.ignoreme = true;
	st_align = struct::get("hendrick_console_hack", "targetname");
	level thread scene::play("cin_sgen_18_01_pallasfight_vign_controls_hendricks_active", level.ai_hendricks);

	level waittill( "pallas_start_terminate" ); // Wait for objective to be completed

	st_align thread scene::stop("cin_sgen_18_01_pallasfight_vign_controls_hendricks_active" );
}

function main()
{
}

function pallas_center_guard_mode()
{
	level endon( "pallas_death" );
	
	trigger::use( "guard_bots_begin" );
	e_robot_spawners = GetEntArray( "pallas_center_guard_spawner", "targetname" );
	n_total_guard_bot = 8;
	level.pallas_center_guards = [];
	level.pallas_tier_two_guards = [];
	level.pallas_bottom_tier_guards = [];
	
	nd_pallas_greet_node = GetNodeArray( "pallas_greet_bot_nodes", "targetname" );
	
	level waittill( "finished_front_guards" );
	foreach( node in nd_pallas_greet_node )
	{
		guard = spawner::simple_spawn_single( e_robot_spawners[ randomint( e_robot_spawners.size ) ] );
		guard thread track_intro_death();
		guard ai::set_ignoreall( true );
		guard SetGoal( node, true, 16 );

		wait .2;//Spread out the spawns a bit
	}
	level flag::wait_till( "pallas_ambush_over" );
	
	trigger::use( "guard_bots_round1" );
	objectives::complete( "cp_level_sgen_confront_pallas" );
}

function cleanup_area_arrays()
{
	level.pallas_center_guards = array::remove_dead( level.pallas_center_guards );
	level.pallas_tier_two_guards = array::remove_dead( level.pallas_tier_two_guards );
	level.pallas_bottom_tier_guards = array::remove_dead( level.pallas_bottom_tier_guards );	
}

function handle_robot_sm( str_triggername, str_sm )
{
	level endon( "pallas_death" );

	trigger = GetEnt( str_triggername, "targetname");

	while( true )
	{
		n_player = 0;
		foreach( player in level.players )
		{
			if( player IsTouching( trigger ) )
			{
				n_player += 1;
			}
		}

		if( n_player > 0 )
		{
			spawn_manager::enable( str_sm );
		}
		else if( spawn_manager::is_enabled( str_sm ) )
		{
			spawn_manager::disable( str_sm );
		}

		wait 0.5;
	}
}

function robot_mindcontrol()
{
	self endon("death");
	
	level.zombie_bots = array::remove_dead( level.zombie_bots );
	array::add( level.zombie_bots, self );

	self ai::set_ignoreme( true );
	
	switch( level.pallas_tower_down )
	{
		case 0:
			self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
			break;
			
		case 1:
		case 2:
			self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
			break;
	}
	self.accuracy = 0.25;
	
	if( !level flag::get( "tower_three_destroyed" ) )
	{
		self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
	}
	self.script_string = "potential_hendricks_bot";
	
	level flag::wait_till( "tower_three_destroyed" );
		
	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	self ai::set_behavior_attribute( "rogue_control_speed", "run" );
}

function intro_mindcontrol()
{
	self endon("death");

	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	self ai::set_behavior_attribute( "rogue_control_speed", "sprint" );
	self.accuracy = 0.25;
}

function robot_mindcontrol_center_guard()
{
	self endon("death");
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	self ai::set_behavior_attribute( "force_cover", true );
	self ai::set_behavior_attribute( "can_become_rusher", false );
	self.accuracy = 0.25;
	level flag::wait_till( "pallas_ambush_over" );
	
	if( level.pallas_center_guards.size < 2 )
	{
		level.pallas_center_guards[ level.pallas_center_guards.size ] =  self;
		v_goal_volume = GetEnt( "pallas_center_volume", "targetname");
	}
	else if( level.pallas_tier_two_guards.size < 2 )
	{
		level.pallas_tier_two_guards[ level.pallas_tier_two_guards.size ] =  self;
		v_goal_volume = GetEnt( "pallas_tier_two_volume", "targetname");
	}
	else
	{
		level.pallas_bottom_tier_guards[ level.pallas_bottom_tier_guards.size ] =  self;
		v_goal_volume = GetEnt( "pallas_bottom_tier", "targetname");
	}
	
	self SetGoal( v_goal_volume, true, 32, 32);
	self ai::set_ignoreall( false );
	
	level flag::wait_till( "tower_three_destroyed" );

	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	self ai::set_behavior_attribute( "rogue_control_speed", "run" );
}

function robot_mindcontrol_shoot_glass()
{
	self endon("death");
	
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "can_become_rusher", false );
	self.script_string = "potential_hendricks_shooter";
	self.accuracy = 0.25;
	
	level flag::wait_till( "tower_three_destroyed" );

	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	self ai::set_behavior_attribute( "rogue_control_speed", "run" );
}

function delete_model_on_death( robot )
{
	robot waittill( "death" );
	self Delete();	
}

function robot_mindcontrol_core_guard()
{
	self endon("death");

	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	self ai::set_behavior_attribute( "force_cover", true );
	self ai::set_behavior_attribute( "can_become_rusher", false );
	self.accuracy = 0.25;
	
	//v_goal_volume = GetEnt( "pallas_center_volume", "targetname");//TODO fix where we are sending these guys
	if(!isdefined(level.n_core_guard_count))level.n_core_guard_count=0;
	level.n_core_guard_count++;
	nd_guard = GetNode( "core_guard" + level.n_core_guard_count, "script_noteworthy" );
	v_goal_volume = GetEnt( "pallas_center_volume", "targetname");
	
	if( IsNodeOccupied( nd_guard ) )
	{
		self SetGoal( v_goal_volume, true, 16, 16);
	}
	else
	{
		self SetGoal( nd_guard, true, 16, 16);
	}
	
	level flag::wait_till( "tower_three_destroyed" );

	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	self ai::set_behavior_attribute( "rogue_control_speed", "run" );
}

function check_for_nearby_players()
{
	self endon( "death" );
	while( true )
	{
		foreach( player in level.players )
		{
			if( DistanceSquared( self.origin, player.origin ) < 500 * 500 )
			{
				self notify( "nearby_enemy" );
			}
		}
		
		wait 0.1;
	}
}

function pallas_body_guard_setup()
{
	self endon("death");

	self.ignoreme = true;
	self ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	level waittill("pallas_death");

	self Delete();
}

function elevator_setup()
{
	e_lift = GetEnt( "boss_fight_lift", "targetname" );
	e_lift SetMovingPlatformEnabled( true );
	
	// Doors
	e_lift.a_e_doors = [];
	
	e_lift.a_e_doors[ "front" ] = GetEnt( "pallas_lift_front", "targetname" );
	e_lift.a_e_doors[ "front" ].str_state = "close";
	e_lift.a_e_doors[ "back" ] = GetEnt( "pallas_lift_back", "targetname" );
	e_lift.a_e_doors[ "back" ].str_state = "close";
	
	array::run_all( e_lift.a_e_doors, &LinkTo, e_lift );
	
	// ClientSide Doors
	e_lift.a_e_doors[ "front" ] clientfield::set( "sm_elevator_door_state", 1 );
	e_lift.a_e_doors[ "back" ] clientfield::set( "sm_elevator_door_state", 2 );
	
	// Shaft	
	// e_lift.a_e_shaft_doors[ "left" ] = GetEnt( "boss_fight_door_left", "targetname" );
	// e_lift.a_e_shaft_doors[ "left" ].str_state = "close";
	// e_lift.a_e_shaft_doors[ "right" ] = GetEnt( "boss_fight_door_right", "targetname" );
	// e_lift.a_e_shaft_doors[ "right" ].str_state = "close";
}

function elevator_set_door_state( str_side, str_state )
{
	e_lift = GetEnt( "boss_fight_lift", "targetname" );

	if ( !( e_lift.a_e_doors[ str_side ].str_state === str_state ) )
	{
		e_lift.a_e_doors[ str_side ].str_state = str_state;
		e_lift.a_e_doors[ str_side ] UnLink();

		n_zvalue = 150;
		
		if ( ( str_state === "open" ) )
		{
			n_zvalue *= -1;
		}

		e_lift.a_e_doors[ str_side ] MoveZ( n_zvalue, ( 150 / 38 ), ( 150 / 38 ) * 0.1, ( 150 / 38 ) * 0.25 );
		e_lift playsound ("veh_lift_doors_move");
		e_lift.a_e_doors[ str_side ] waittill( "movedone" );

		e_lift.a_e_doors[ str_side ] LinkTo( e_lift );
		
		if ( str_state == "open" )
		{
			level flag::set( "pallas_lift_" + str_side + "_open" );
		}
		else
		{
			level flag::clear( "pallas_lift_" + str_side + "_open" );
		}
	}
}

function elevator_set_shaft_state( str_state )
{
	e_lift = GetEnt( "boss_fight_lift", "targetname" );

	if ( !( e_lift.a_e_shaft_doors[ "left" ].str_state === str_state ) )
	{
		foreach ( e_shaft_door in e_lift.a_e_shaft_doors )
		{
			v_move_value = e_shaft_door.script_vector;

			if ( str_state == "close" )
			{
				v_move_value *= -1;
			}
			
			e_shaft_door.str_state = str_state;
			e_shaft_door MoveTo( e_shaft_door.origin + v_move_value, ( 150 / 38 ), ( 150 / 38 ) * 0.1, ( 150 / 38 ) * 0.25 );
		}
	}
}

function elevator_set_move_direction( str_direction )
{
	array::run_all( level.players, &SetLowReady, true );
	array::run_all( level.players, &AllowJump, false );
	
	e_lift = GetEnt( "boss_fight_lift", "targetname" );
	e_lift.str_direction = str_direction;

	e_decon_fx_origin = GetEnt( "decon_fx_origin", "targetname" );
	e_decon_fx_origin LinkTo( e_lift );
	PlayFXOnTag( level._effect[ "decon_mist" ], e_decon_fx_origin, "tag_origin" );
	e_decon_fx_origin playsound ("veh_lift_mist");
	
	n_zvalue = 1750;

	if ( str_direction == "down" )
	{
		n_zvalue *= -1;
	}
	
	e_lift MoveZ( n_zvalue, ( 1750 / 23 ), ( 1750 / 23 ) * 0.1, ( 1750 / 23 ) * 0.25 );
	
	e_lift PlaySound( "veh_lift_start" );

	loop_snd_ent = Spawn( "script_origin", e_lift.origin );
	loop_snd_ent LinkTo( e_lift );
	loop_snd_ent PlayLoopSound( "veh_lift_loop", .5 );

	e_lift waittill( "movedone" );
	loop_snd_ent StopLoopSound( .5 );
	e_lift PlaySound( "veh_lift_stop" );
	loop_snd_ent Delete();

	array::run_all( level.players, &AllowJump, true );
	array::run_all( level.players, &SetLowReady, false );
}

function elevator_set_opaque( n_state )
{
	e_lift = GetEnt( "boss_fight_lift", "targetname" );
	e_lift clientfield::set( "sm_elevator_shader", n_state );
}

function elevator_lift_intro()
{
	//elevator_set_opaque( 2 ); // Hide
	
	a_ai = GetAITeamArray( "team3" );
	a_ai_awaken = [];
	
	foreach ( ai in a_ai )
	{
		if ( ( isdefined( ai.activated ) && ai.activated ) )
		{
			if ( !isdefined( a_ai_awaken ) ) a_ai_awaken = []; else if ( !IsArray( a_ai_awaken ) ) a_ai_awaken = array( a_ai_awaken ); a_ai_awaken[a_ai_awaken.size]=ai;;
		}
	}
	
//	if ( a_ai_awaken.size )
//	{
//		array::run_all( a_ai_awaken, &ai::set_behavior_attribute, "rogue_control_speed", "sprint" );
//		array::wait_till( a_ai_awaken, "death" );
//	}
//	
	
//	elevator_set_shaft_state( "open" );
	elevator_set_door_state( "front", "open" );

	t_lift = GetEnt( "pallas_lift_trigger", "targetname" );
	t_lift sgen_util::gather_point_wait();
	
	level clientfield::set( "elevator_light_probe", 1);
	
	array::thread_all( GetEntArray( "head_track_model", "targetname" ), &util::delay_notify, 0.05, "stop_head_track_player" );
	array::run_all( GetEntArray( "pallas_lift_front_clip", "targetname" ), &MoveZ, 112, 0.05 );

	e_lift = GetEnt( "boss_fight_lift", "targetname" );
//	elevator_set_shaft_state( "close" );
	elevator_set_door_state( "front", "close" );
	elevator_set_opaque( 3 ); // Show
	e_lift clientfield::set( "sm_elevator_extracam", 1 );
	level notify( "elevator_vo" );
	
	playsoundatposition ("mus_frozen_serverroom", (0,0,0));  //TODO remove this when the music system is online
	
	
	// util::delay( 1, undefined, &elevator_set_opaque, 1 ); // TODO: Temp until new model gets support

	level notify( "pallas_elevator_starting" );
	foreach( ai in a_ai )
	{
		if(  IsAlive(ai) )
		{
			ai Delete();
		}
	}
	
	// Stop floating
	level clientfield::set( "w_underwater_state", 0 );

	objectives::complete( "cp_level_sgen_pallas_elevator", struct::get( "pallas_elevator_descent_objective" ) );
	util::delay( 3, undefined, &skipto::objective_completed, "descent" );	
	
	e_lift util::delay( 8, undefined, &clientfield::set, "sm_elevator_extracam", 2 );
	// util::delay( 6, undefined, &elevator_set_opaque, 0 );// TODO: Temp until new model gets support
	util::delay( 6, undefined, &objectives::complete, "cp_level_sgen_find_pallas" );

	elevator_set_move_direction( "down" );
	elevator_set_door_state( "back", "open" );
	
	level notify ("enter_server"); //kicks off some ambient audio
	
	a_nd_traverse = GetNodeArray( "pallas_elevator_start", "script_noteworthy" );
	foreach( node in a_nd_traverse )
	{
		LinkTraversal( node );
	}
}

function elevator_lift_outro( b_starting )
{
	elevator_set_door_state( "back", "close" );

	if ( !b_starting )
	{
		e_lift = GetEnt( "boss_fight_lift", "targetname" );
		e_lift.origin += ( 0, 0, 1750 );
	}

//TODO We'll need this again if we come back to a moving elevator
//	elevator_set_move_direction( "up" );
//	elevator_set_shaft_state( "open" );
	elevator_set_door_state( "front", "open" );	
}

function zombie_bot_manager()
{
	level.zombie_bots = [];
	
	nd_guards = GetNodeArray( "zombie_robot_guard_spot", "targetname" );
	e_robot_spawners = GetEntArray( "pallas_running_robot", "targetname" );
	
	e_robot_spawners = ArraySort( e_robot_spawners, level.players[0].origin );
	
	for(i = 0; i < nd_guards.size; i ++ )
	{
		zombie_bots = spawner::simple_spawn_single(e_robot_spawners[i]);
		zombie_bots thread track_intro_death();
		level.zombie_bots[ level.zombie_bots.size ] = zombie_bots;
		zombie_bots ai::set_ignoreall( true );
		zombie_bots SetGoal( nd_guards[i], true );
	}
	level notify( "finished_front_guards" );
	flag::wait_till( "pallas_ambush_over" );
	
	level.zombie_bots = array::remove_dead( level.zombie_bots );
	
	array::thread_all( level.zombie_bots, &ai::set_ignoreall, false );
	
	level thread do_attack_on_hendricks();
	
	while( true )
	{
	
		if( level.pallas_tower_down == 3 )
		{
			break;
		}
		
		e_robot_spawners = GetEntArray( "pallas_running_robot", "targetname" );
		
		foreach( player in level.players )
		{
			if( !isdefined( player.revivetrigger ) )
			{
				e_target_player = player;
				break;
			}
		}

		if( !isdefined( e_target_player) )
		{
			e_target_player = level.players[0];
		}
		
		e_robot_spawners = ArraySort( e_robot_spawners, e_target_player.origin );
		
		level.zombie_bots = array::remove_dead( level.zombie_bots );
		
		n_total_zombie_bot = 4 + level.players.size + level.pallas_tower_down * 2;
		
		n_zombie_bot_count = n_total_zombie_bot - level.zombie_bots.size;
		
		if( level.zombie_bots.size < n_total_zombie_bot  )
		{	
			//level.zombie_bots[ level.zombie_bots.size ] = spawner::simple_spawn_single(e_robot_spawners[ int( e_robot_spawners.size / 2 ) ]);//TODO let's gut more of this stuff that we no longer need in the redo
		//	level.zombie_bots[ level.zombie_bots.size ].ignoreall = true;
		}		
		
		if( level.pallas_tower_down == 2 )
		{
			wait( 9 - level.players.size );
		}
		else
		{
			wait( 12 - level.players.size );
		}		
	}
}

function pallas_greeting_event( b_starting )
{	
	if( b_starting )
	{
		level dialog::remote( "kane_take_him_out_you_ha_0" );	
	}
	else
	{
		trigger::wait_till( "pallas_turret_enable_trigger");	
	}

	//handle pallas monitor interaction.	
	level thread pallas_control_monitors();
	level.pallas dialog::say( "diaz_i_am_willing_to_d_0" );
	level flag::set( "pallas_ambush_over" );
	
	level dialog::remote( "kane_the_only_way_to_disc_0", 5 );
	level.ai_hendricks dialog::remote( "hend_kane_i_m_currently_0" );
	level dialog::remote( "kane_access_the_primary_s_0" );
	level.ai_hendricks dialog::remote( "hend_you_re_the_boss_lad_0" );
	
	level notify( "pallas_objective_start" );
	
	level dialog::remote( "kane_got_it_focus_fire_o_0", 2 );
	level.ai_hendricks dialog::remote( "hend_your_grenades_should_0" );
	level dialog::remote( "kane_i_ll_need_a_minute_t_0" );
	wait .5;//Give a beat in case players have already killed enough AI
	level flag::set( "pallas_intro_completed" );
}

function pallas_control_monitors()
{	
	array::thread_all( level.players, &clientfield::set_to_player, "activate_pallas_monitoring", 1 );
}

function handle_pallas_pillar_weakspot()
{
	level endon( "pallas_start" );
	
	level.pallas_phase_two = undefined;
	
	level waittill( "pallas_objective_start" );	
	
	e_pillars = GetEntArray( "diaz_tower_1", "targetname" );
	
	a_t_coolants = GetEntArray( "pallas_coolant_control", "targetname" );
	
	foreach( trigger in a_t_coolants )
	{
		trigger SetHintString( &"CP_MI_SING_SGEN_DESTROY_PILLAR" );
		trigger TriggerEnable( false ) ;
	}

	//Don't enable first weakpoint until player clears out some enemies and has heard the dialog
	level flag::wait_till( "pallas_intro_completed" );
	spawn_manager::wait_till_ai_remaining( "sm_stage1", 6 );
	level thread activate_flood_spawn();
	
	while( true )
	{		
		//handling random picking weakspot and moving them in place.		
		if( level.pallas_tower_down == 1)
		{		
			e_pillars = ArraySortClosest( e_pillars, level.ai_hendricks.origin );
			e_pallas_pillar = e_pillars[0];
			e_pillars = array::remove_index( e_pillars, 0 );
		}
		else
		{
			n_random_int = RandomInt( e_pillars.size );
			e_pallas_pillar = e_pillars[ n_random_int ];
			e_pillars = array::remove_index( e_pillars, n_random_int );
		}		
	
		e_pallas_pillar MoveZ( -80, 4);
		level thread weakspot_damage( e_pallas_pillar.script_float );
		PlayFx( level._effect[ "coolant_tower_unleash" ], e_pallas_pillar.origin + (0, 0, -250) );//TODO look into moving this to client
		e_pallas_pillar PlaySound("evt_pillar_move");
		
		switch( level.pallas_tower_down )
		{
			case 0:				
				level dialog::remote( "kane_cooling_tower_one_ex_0", 1 );			
				break;
				
			case 1:
				level dialog::remote( "kane_cooling_tower_two_ex_0", 1 );			
				break;
				
			case 2:
				level dialog::remote( "kane_cooling_tower_three_0", 1 );
				break;
		}		
		level thread cooling_tower_nag();
		a_t_coolant = GetEntArray( "pallas_coolant_control", "targetname" );
		a_t_coolant = ArraySortClosest( a_t_coolant, e_pallas_pillar.origin );
		t_coolant = a_t_coolant[0];
		level waittill( "pillar_destroyed" );
		objectives::complete( "cp_level_sgen_destroy_tower" );
		level.pallas_tower_down++;
		e_pallas_pillar PlaySound("evt_pillar_dest");
		
		switch( level.pallas_tower_down )
		{
			case 1:
				level dialog::remote( "kane_cooling_tower_one_of_0" );
				break;
				
			case 2:
				level dialog::remote( "kane_cooling_tower_two_of_0" );
				break;
				
			case 3:
				level flag::set( "tower_three_destroyed" );
				level dialog::remote( "kane_cooling_tower_three_1" );
				level.ai_hendricks dialog::remote( "hend_this_better_not_kill_0" );
				level dialog::remote( "kane_not_the_time_comman_0" );
				level thread level_three_warning_vo();
				exploder::exploder_stop( "light_sgen_palas_em" );
				break;
		}
		
		level thread core_nag();
		level.pallas_phase_two = true;
		wait 2;//TODO what is this for?
		
		//turn on trigger that will play the animation of the player tossing a grenade down a coolant vent
		t_coolant TriggerEnable( true );
		s_temp = SpawnStruct();
		s_temp.origin = t_coolant.origin + ( 0, 0, 16 );
		s_temp.angles = t_coolant.angles;
		objectives::set( "cp_level_sgen_release_coolant", s_temp.origin );
		
		b_player_valid = false;
		while( !b_player_valid )
		{
			t_coolant waittill( "trigger", player );//Player triggers grenade anim
			if( !player laststand::player_is_in_laststand() )
			{
				b_player_valid = true;
			}
		}
		
		level notify( "stage_completed" );//Kill flood spawner
		switch( level.pallas_tower_down )
		{
			case 1:
				spawn_manager::kill( "sm_stage1_flood", false );
				break;
				
			case 2:
				level flag::set( "core_two_destroyed" );
				spawn_manager::kill( "sm_stage2_flood", false );
				break;
				
			case 3:
				spawn_manager::kill( "sm_stage3", false );
				break;
		}
		
		objectives::complete( "cp_level_sgen_release_coolant", s_temp.origin );
		fx_struct = struct::get( t_coolant.target, "targetname" );
		player.ignoreme = true;
		player EnableInvulnerability();
		str_anim_base = t_coolant.script_noteworthy + t_coolant.script_string;
		level scene::play( str_anim_base + "_a", player );
		switch( level.pallas_tower_down )
		{
			case 1:
			case 2:
				level thread scene::play( str_anim_base + "_b", player );
				break;
				
			case 3:
				level thread detonate_robots();
				level thread scene::init( "p7_fxanim_cp_sgen_pallas_ai_tower_collapse_bundle" );
				level notify("pallas_death");
				array::thread_all( level.players, &clientfield::set_to_player, "activate_pallas_monitoring", 2 );	
				level thread skipto::objective_completed( "pallas_start" );				
				break;
		}
		t_coolant Delete();
		
		//perfect timing for awesome explosions
		level waittill( "boom" );
		
		fx_model = util::spawn_model( "tag_origin", fx_struct.origin, fx_struct.angles );
		PlayFxOnTag( level._effect[ "central_tower_damage_minor" ], fx_model, "tag_origin" );
		PlayFxOnTag( level._effect[ "central_tower_damage_major" ], fx_model, "tag_origin" );
		level sgen_util::quake( 0.5, 1, fx_model.origin, 5000, 4, 7 );
		level thread show_cracked_glass( e_pallas_pillar.script_float );

		switch( level.pallas_tower_down )
		{
			case 1:
				level notify( "pallas_attacked" );
				if( level.players.size == 1 )
				{
					util::delay( 2, undefined, &spawn_manager::enable, "sm_stage2" );//Give player time to react
				}
				else
				{
					util::delay( 1, undefined, &spawn_manager::enable, "sm_stage2" );//Give coop player less time, teamates should provide cover
				}				
				break;
				
			case 2:
				level notify( "pallas_attacked" );
				level thread detonate_robots();
				level.n_core_guard_count = 0;
				spawn_manager::enable( "sm_stage3" );				
				break;
		}
		
		level waittill( "tower_attack_complete" );
		
		player.ignoreme = false;
		player DisableInvulnerability();
		fx_model Delete();
		
		switch( level.pallas_tower_down )
		{
			case 1:
				level dialog::player_say( "plyr_grenade_detonated_0" );
				level dialog::remote( "kane_it_worked_central_0" );
				break;
				
			case 2:
				level dialog::player_say( "plyr_successful_detonatio_0" );
				level dialog::remote( "kane_central_core_down_to_0" );
				level thread check_wall_climb_vo();
				exploder::exploder( "light_sgen_palas_em" );
				s_protect = struct::get( "hendrick_console_hack" );
				objectives::set( "cp_level_sgen_protect_hendricks", s_protect.origin );
				break;
		}
	
		wait 4;//TODO what is this for?
		level.pallas_phase_two = undefined;
		
		if(  level.pallas_tower_down == 2 )
		{			
			while( level.bot_attack_hendricks )
			{
				wait 1;
			}
			
			wait 10;//Give a set min time for the round to make sure Hendricks is under attack for a bit
			level dialog::remote( "kane_working_on_tower_thr_0" );
			wait 10;//Remaining time
			switch( level.players.size )
			{
				case 2:
					n_spawn_count = 25;
					break;
					
				case 3:
					n_spawn_count = 30;
					break;
					
				case 4:
					n_spawn_count = 35;
					break;
					
				default:
					n_spawn_count = 20;
					break;
			}
			spawn_manager::wait_till_spawned_count( "sm_stage3", n_spawn_count );
			level notify( "third_pillar_unlocked" );
			objectives::complete( "cp_level_sgen_protect_hendricks" );		
		}
		else
		{
			level dialog::remote( "kane_working_on_opening_c_0" );
			level dialog::player_say( "plyr_hurry_up_kane_i_m_0" );
			spawn_manager::wait_till_ai_remaining( "sm_stage2", 6 );
			level thread activate_flood_spawn();
		}		
	}
}

function activate_flood_spawn()
{
	level endon( "stage_completed" );
	
	switch( level.pallas_tower_down )
	{
		case 0:
			spawn_manager::wait_till_ai_remaining( "sm_stage1", 3 );
			spawn_manager::enable( "sm_stage1_flood" );			
			break;
			
		case 1:
			spawn_manager::wait_till_ai_remaining( "sm_stage2", 3 );
			spawn_manager::enable( "sm_stage2_flood" );			
			break;			
	}
}

function weakspot_damage( n_tower )
{
	n_tower = Int( n_tower );
	e_core = GetEnt( "diaz_ball_" + n_tower, "targetname" );
	//e_core oed::enable_thermal();//TODO - we need to figure out what we actually need here to highlight this
	e_core clientfield::set( "weakpoint", 1 );
	LUINotifyEvent( &"weakpoint_update", 3, 1, e_core getEntityNumber(), &"tag_weakpoint" );
	n_total_health = 300 * level.players.size;
	e_core.health = n_total_health;
	e_core thread do_damage_react();
	
	while( 	e_core.health >= ( n_total_health / 2)  )
	{
		{wait(.05);};
	}
	
	mdl_fx = util::spawn_model( "tag_origin", e_core.origin, e_core.angles );
	
	PlayFxOnTag( level._effect[ "coolant_tower_damage_minor" ], mdl_fx, "tag_origin" );
	
	e_core waittill("death");
	
	e_core DisableAimAssist();
	e_core clientfield::set( "weakpoint", 0 );
	LUINotifyEvent( &"weakpoint_update", 3, 0, e_core getEntityNumber(), &"tag_weakpoint" );
	switch( n_tower )
	{
		case 1:
			level thread scene::play( "coolant_hose_03", "targetname" );//Center tower
			level clientfield::set( "tower_chunks2", 1 );
			//level thread activate_frost_trigger( 2 );TODO - hook up triggers now that the effect is in
			break;
			
		case 2:
			level thread scene::play( "coolant_hose_01", "targetname" );//Right tower
			level clientfield::set( "tower_chunks1", 1 );
			break;
			
		case 3:
			level thread scene::play( "coolant_hose_05", "targetname" );//Left tower
			level clientfield::set( "tower_chunks3", 1 );
			break;
	}
	level sgen_util::quake( 0.5, 1, e_core.origin, 5000, 4, 7 );
	mdl_fx Delete();
	level notify( "pillar_destroyed" );
	mdl_fx = util::spawn_model( "tag_origin", e_core.origin, e_core.angles );
	
	PlayFxOnTag( level._effect[ "coolant_tower_damage_major" ], mdl_fx, "tag_origin" );
}

function do_damage_react()
{
	self endon( "death" );

	wait 2;//Give time for the shield to lower

	self SetCanDamage( true );
	self EnableAimAssist();
	objectives::set( "cp_level_sgen_destroy_tower", self.origin + (0,0,70) );
	
	while( true )
	{
		self waittill( "damage", damage, attacker );
		attacker damagefeedback::update();
	}	
}

//function activate_frost_trigger( n_tower )//TODO - this needs to get tested and worked on if we want it
//{
//	switch( n_tower )
//	{
//		case 2:
//			t_frost = GetEnt( "frost_trigger" + n_tower, "targetname" );
//			t_frost thread wait_to_frost_player();
//			break;
//	}
//}
//
////self = trigger
//function wait_to_frost_player()
//{
//	self endon( "death" );
//	
//	while( true )
//	{
//		self waittill( "trigger", e_who );
//		
//		while( e_who IsTouching( self ) )
//		{
//			e_who clientfield::increment_to_player( "pstfx_frost_up" );
//		}
//		e_who clientfield::increment_to_player( "pstfx_frost_down" );		
//	}
//}

function do_attack_on_hendricks()
{	
	level endon( "pallas_death" );
	level endon( "third_pillar_unlocked" );	
		
	level.a_assault_bot = [];
	level.a_shooter_bot = [];
	
	level flag::wait_till( "core_two_destroyed" );
	
	level thread interrupt_hendricks_hacking();
	
	while( true )
	{	
		if( !IsAlive( level.a_assault_bot[0] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[0] = bot;
				bot ai::set_ignoreall( true );
				level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_hendricks_robot01", bot );
				bot thread track_drop_down( 1 );
			}
		}
		
		if( !IsAlive(level.a_assault_bot[1] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[1] = bot;
				bot ai::set_ignoreall( true );
				level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_hendricks_robot02", bot );
				bot thread track_drop_down( 2 );
			}
		}
		
		if( !IsAlive(level.a_assault_bot[2] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[2] = bot;
				bot ai::set_ignoreall( true );
				level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_hendricks_robot03", bot );
				bot thread track_drop_down( 3 );
			}
		}
		
		if( !IsAlive(level.a_assault_bot[3] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[3] = bot;
				bot ai::set_ignoreall( true );
				level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_hendricks_robot04", bot );
				bot thread track_drop_down( 4 );
			}
		}
		
		if( !IsAlive(level.a_assault_bot[4] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[4] = bot;
				bot ai::set_ignoreall( true );
				bot thread explode_robot( 1 );
			}
		}

		if( !IsAlive(level.a_assault_bot[5] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_bot", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_assault_bot[5] = bot;
				bot ai::set_ignoreall( true );
				bot thread explode_robot( 2 );
			}
		}

		if( !IsAlive( level.a_shooter_bot[0] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_shooter", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_shooter_bot[0] = bot;
				bot thread shoot_at_glass(1);
			}
		}

		if( !IsAlive( level.a_shooter_bot[1] ) )
		{
			potential_hendricks_bots = GetEntArray( "potential_hendricks_shooter", "script_string" );
			bot = array::get_closest( level.ai_hendricks.origin, potential_hendricks_bots );
			
			if( IsAlive( bot ) )
			{
				bot.script_string = undefined;
				level.a_shooter_bot[1] = bot;
				bot thread shoot_at_glass(2);
			}
		}		
		wait .5;
	}	
}

//self = AI robot
function track_drop_down( n_index )
{
	self endon( "death" );
	
	level flag::wait_till( "tower_three_destroyed" );
	
	self ai::set_ignoreall( false );
	level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_hendricks_destroy_robot0" + n_index, self );
}

function explode_robot( n_scene )
{
	self endon( "death" );
	
	if(!isdefined(level.n_observation_deck_stage))level.n_observation_deck_stage=0;
	
	level thread scene::play( "cin_sgen_18_01_pallasfight_vign_takedown_explode0" + n_scene, self );
	self waittill( "start_timer" );
	wait RandomFloatRange( .5, 1 );//Wait a bit before activating level 3
	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	//Give a bit more time for the player to react
	switch( level.players.size )
	{
		case 2:
			wait RandomFloatRange( 2.5, 3 );
			break;
			
		case 3:
		case 4:
			wait RandomFloatRange( 2, 2.5 );
			break;
			
		default:
			wait RandomFloatRange( 3, 3.5 );
			break;
	}
	level thread scene::stop( "cin_sgen_18_01_pallasfight_vign_takedown_explode0" + n_scene );
	self ai::set_behavior_attribute( "rogue_force_explosion", true );
	level thread hendricks_attacked();
}

function hendricks_attacked()
{
	level.n_observation_deck_stage++;
	
	switch( level.n_observation_deck_stage )
	{
		case 1:
			level clientfield::increment( "observation_deck_destroy" ); // Play fxanim for breaking glass
			level.ai_hendricks dialog::remote( "hend_shit_kane_hurry_t_0" );
			break;
			
		case 3:
			level clientfield::increment( "observation_deck_destroy" ); // Play fxanim for breaking glass
			//level.ai_hendricks dialog::remote( "hend_gimme_a_hand_i_got_0" );//TODO - keep this around in case we want to add a 'life'
			level.ai_hendricks dialog::remote( "hend_i_m_getting_torn_up_0" );
			break;
			
//		case 4://TODO - keep this around just in case we want to add in a 'life'
//			level.ai_hendricks dialog::remote( "hend_i_m_getting_torn_up_0" );
//			break;
			
		case 4:
			level clientfield::increment( "observation_deck_destroy" ); // Play fxanim for breaking glass
			util::screen_message_create( "TEMP - Hendricks was killed", undefined, undefined, 1.5 );
			wait 3.5;//Give time for fail fxanim to play
			util::missionfailedwrapper_nodeath( &"CP_MI_SING_SGEN_HENDRICKS_KILLED" );			
			break;
	}
}

//self = robot
function shoot_at_glass( n_target )
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	nd_goto = GetNode( "shoot_hendricks" + n_target, "targetname" );
	e_target = GetEnt( "glass_attack" + n_target, "targetname" );
	mdl_target = util::spawn_model( "tag_origin", e_target.origin );
	self.goalradius = 16;
	self ai::force_goal( nd_goto );
	self ai::set_ignoreall( false );
	self SetEntityTarget( mdl_target );
	self ai::shoot_at_target( "shoot_until_target_dead", mdl_target );
	self.forceFire = true;
	level flag::wait_till( "tower_three_destroyed" );
	self ai::stop_shoot_at_target();
	self.forceFire = false;
	self ClearEntityTarget();
	self ai::set_behavior_attribute( "rogue_control", "forced_level_3" );
	self ai::set_behavior_attribute( "rogue_control_speed", "run" );	
}

function interrupt_hendricks_hacking()
{	
	level endon( "pallas_death" );
	level endon( "third_pillar_unlocked" );
	level.bot_attack_hendricks = false;
	count = 0;
	
	while( true )
	{
		a_bot = array::remove_dead(level.a_assault_bot);
		bot = array::get_closest( level.ai_hendricks.origin, a_bot );
		
		if( IsAlive( bot ) && DistanceSquared( level.ai_hendricks.origin, bot.origin ) < 300 * 300 )
		{
			//count += a_bot.size;
			count++;
			n_seconds = 100 - count;
			
			if( n_seconds < 0 )
			{
				n_seconds = 0;	
			}
			
			for( i = 0; i < level.players.size; i ++ )
			{
				//level.players[i] thread send_hendricks_warning_to_player( "Hendricks under attack. " + n_seconds + " until structure failure." );//TODO update with proper VO
			}
			
			level.bot_attack_hendricks = true;
		}
		else
		{
			count  = 0;
			level.bot_attack_hendricks = false;			
		}
		
		if( count >= 100 )
		{
			util::missionfailedwrapper_nodeath( "Hendricks was Killed." ); 	
		}
		
		wait 1;
	}	
}

//TODO how do we want to show damage to Hendricks?
function send_hendricks_warning_to_player( warning_text )
{
	menu = self OpenLUIMenu( "HudElementText" );
	self SetLUIMenuData( menu, "text", warning_text ); 
	self SetLUIMenuData( menu, "x", 550 );
	self SetLUIMenuData( menu, "y", 200 );
	self SetLUIMenuData( menu, "width", 700 );
	self SetLUIMenuData( menu, "alpha", 1 );
	self SetLUIMenuData( menu, "height", 25 );
	wait(1);
	self CloseLUIMenu( menu );
}

function track_intro_death()
{
	self waittill( "death" );
	
	if(!isdefined(level.intro_death_count))level.intro_death_count=0;
	
	level.intro_death_count++;
	
	if( level.intro_death_count == 8 )
	{
		//Kick off Stage 1 SM
		spawn_manager::enable( "sm_stage1" );
	}
}

function cooling_tower_nag()
{
	level endon( "pillar_destroyed" );
	
	wait RandomFloatRange( 15, 20 );
	switch( level.pallas_tower_down )
	{
		case 1:
			level.ai_hendricks dialog::remote( "hend_focus_fire_take_ou_0" );
			wait RandomFloatRange( 15, 20 );
			level.ai_hendricks dialog::remote( "hend_disable_that_tower_t_0" );
			break;
			
		case 2:
			level.ai_hendricks dialog::remote( "hend_grunts_are_moving_in_0" );
			wait RandomFloatRange( 15, 20 );
			level.ai_hendricks dialog::remote( "hend_we_can_t_stop_diaz_w_0" );
			break;
			
		case 3:		
			level dialog::remote( "kane_take_the_tower_offli_0" );
			wait RandomFloatRange( 15, 20 );
			level dialog::remote( "kane_we_need_to_bring_dow_0" );
			break;
	}
}

function core_nag()
{
	level endon( "stage_completed" );
	
	wait RandomFloatRange( 15, 20 );
	switch( level.pallas_tower_down )
	{
		case 1:
			level.ai_hendricks dialog::remote( "hend_throw_your_grenade_i_0" );
			wait RandomFloatRange( 10, 15 );
			level.ai_hendricks dialog::remote( "hend_we_gotta_stop_that_u_0" );
			break;
			
		case 2:
			level.ai_hendricks dialog::remote( "hend_what_are_you_waiting_0" );
			wait RandomFloatRange( 15, 20 );
			level.ai_hendricks dialog::remote( "hend_we_re_running_out_of_1" );
			break;
			
		case 3:	
			level dialog::remote( "kane_blow_the_damn_core_0" );
			wait RandomFloatRange( 15, 20 );
			level dialog::remote( "kane_get_a_grenade_in_the_0" );
			break;
	}
}

function check_wall_climb_vo()
{
	if(!isdefined(level.b_wall_climb_vo_played))level.b_wall_climb_vo_played=false;
	
	if( !level.b_wall_climb_vo_played )
	{
		level.b_wall_climb_vo_played = true;
		level.ai_hendricks dialog::remote( "hend_hey_i_got_grunts_c_0" );
	}
}

function level_three_warning_vo()
{
	level endon( "stage_completed" );
	
	switch( RandomIntRange( 0, 3 ) )
	{
		case 0:
			level.ai_hendricks dialog::remote( "hend_look_out_they_re_tr_0" );
			break;
			
		case 1:
			level.ai_hendricks dialog::remote( "hend_kamikaze_grunts_movi_0" );
			break;

		default:
			level.ai_hendricks dialog::remote( "hend_robots_self_destruct_0" );
			break;			
	}
}

function detonate_robots( b_immediate = false )
{
	a_e_enemies = GetAITeamArray( "team3" );
	foreach( e_enemy in a_e_enemies )
	{
		if( IsAlive( e_enemy ) )
		{
			//TODO force level 3
			e_enemy DoDamage( 1000, e_enemy.origin );
			if( !b_immediate )
			{
				wait RandomFloatRange( .1, .4 );
			}
		}
	}
}

function init_fxanim_hoses()
{
	level thread hide_cracked_glass();
	for( x = 1; x <= 8; x++ )
	{
		level scene::init( "coolant_hose_0" + x, "targetname" );
	}
}

function all_hoses_break()//play remaining hose anims
{
	level waittill( "all_hoses_break" );
	level thread scene::play( "coolant_hose_02", "targetname" );
	level thread scene::play( "coolant_hose_04", "targetname" );
	level thread scene::play( "coolant_hose_06", "targetname" );
	level thread scene::play( "coolant_hose_07", "targetname" );
	level thread scene::play( "coolant_hose_08", "targetname" );
}

function hide_cracked_glass()
{
	a_e_glass = GetEntArray( "pallas_glass_break_whole", "script_noteworthy" );
	array::run_all( a_e_glass, &Hide );
}

function show_cracked_glass( n_crack )
{
	n_crack = Int( n_crack );
	switch( n_crack )
	{
		case 1:
			e_glass = GetEnt( "pallas_glass_break_1", "targetname" );
			break;
			
		case 2:
			e_glass = GetEnt( "pallas_glass_break_3", "targetname" );
			break;

		default:
			e_glass = GetEnt( "pallas_glass_break_2", "targetname" );
			break;			
	}
	e_glass Show();
}

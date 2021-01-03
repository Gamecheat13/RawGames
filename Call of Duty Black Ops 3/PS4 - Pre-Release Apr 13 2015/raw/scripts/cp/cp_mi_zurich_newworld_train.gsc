#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;

#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_train;



//----------------------------------------------------------------------------
//
//
function skipto_white_infinite_igc_init( str_objective, b_starting )
{
	init_train_flags();
	
	level thread start_forest_environment( true );

	newworld_util::wait_for_all_players_to_spawn();
	
	foreach( player in level.players )
	{
		player SetLowReady( true );
	}

	level thread util::screen_fade_in( 2.0, "white" );

	level util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_TIME_TRAIN1", undefined, undefined, 150, 5 );
	
	wait 5;	// This will eventually be replaced by an actual IGC

	util::screen_fade_out( 2.0, "white" );
	wait 1;	// wait a little extra so the change isn't so jarring
	
	skipto::objective_completed( str_objective );
}

function skipto_white_infinite_igc_done( str_objective, b_starting, b_direct, player )
{
	// HIDE ALL TRAIN ENVIRONMENTS
	e_forest_1 = GetEnt( "train_terrain_forest_set_01", "targetname" );
	e_forest_2 = GetEnt( "train_terrain_forest_set_02", "targetname" );
	e_forest_3 = GetEnt( "train_terrain_forest_set_03", "targetname" );
	
	e_tunnel_1 = GetEnt( "train_terrain_tunnel_set_01", "targetname" );
	e_tunnel_2 = GetEnt( "train_terrain_tunnel_set_02", "targetname" );
	e_tunnel_3 = GetEnt( "train_terrain_tunnel_set_03", "targetname" );
	
	a_env = array( e_forest_1, e_forest_2, e_forest_3, e_tunnel_1, e_tunnel_2, e_tunnel_3 );
	foreach( e_environment in a_env )
	{
		e_environment Hide();
	}
	
	// HIDE DYNAMIC SHADOW CARDS
	a_e_shadows = GetEntArray( "train_dyanmic_shadow", "targetname" );
	foreach( e_shadow in a_e_shadows )
	{
		e_shadow Hide();
	}
}


//----------------------------------------------------------------------------
//
//
function skipto_inbound_igc_init( str_objective, b_starting )
{	
	if ( b_starting )
	{
		newworld_util::wait_for_all_players_to_spawn();
	}
	else
	{
		foreach( player in level.players )
		{
			player newworld_util::replace_weapons();
		}
	}

	foreach( player in level.players )
	{
		player cybercom_gadget::takeAllAbilities();	// remove all abilities
		player cybercom_gadget::giveAbility( "cybercom_concussive", false );
		player cybercom_gadget::giveAbility( "cybercom_takedown", false );
		player cybercom_gadget::equipAbility( "cybercom_takedown" );
	}
	
	init_train_flags();
	train_brake_flaps_init();
	level thread start_forest_environment();
	level thread train_civilians();

	skipto::teleport( str_objective );

	level thread util::screen_fade_in( 2.0, "white" );

	level util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_TIME_TRAIN2", undefined, undefined, 150, 5 );

	inbound_igc();
	
	util::teleport_players_igc( "inbound_igc_teleport" );

	skipto::objective_completed( str_objective );
}

function inbound_igc()
{
	// TODO - Remove, no timestop on train
	//level thread inbound_igc_notetracks();
	scene::add_scene_func( "cin_new_14_01_inbound_1st_preptalk", &taylor_inbound_igc, "play" );
	scene::add_scene_func( "cin_new_14_01_inbound_1st_preptalk", &ignore_pause_world, "play" );
	scene::add_scene_func( "cin_new_14_01_inbound_1st_preptalk", &inbound_igc_done, "done" );
	
	scene::play( "cin_new_14_01_inbound_1st_preptalk" );
}

// TODO - Remove, no timestop on train
function inbound_igc_notetracks()
{
	array::wait_any( level.players, "start_timefreeze" );
	
	SetPauseWorld( true );
	level flag::set( "train_terrain_pause" );
	
	// notetrack on v_new_14_01_inbound_1st_preptalk_vtol
	level waittill( "resume_time" );
	
	SetPauseWorld( false );
	level flag::set( "train_terrain_resume" );
	level flag::clear( "train_terrain_pause" );
}

function ignore_pause_world( a_ents )
{
	foreach( ent in a_ents )
	{
		ent SetIgnorePauseWorld( true );	
	}
}

function taylor_inbound_igc( a_ents )
{
	e_taylor = a_ents[ "taylor" ];
	e_taylor Hide();
	
	e_taylor waittill( "rez_taylor" );
	e_taylor fx::play( "rez_in", undefined, undefined, undefined, true, "j_spine4", undefined, true );
	e_taylor Show();
	
	e_taylor waittill( "derez_taylor" );
	v_origin = e_taylor GetTagOrigin( "j_spine4" );
	e_origin = util::spawn_model( "tag_origin", v_origin, self.angles );
	e_origin fx::play( "rez_out", undefined, undefined, undefined, true, "tag_origin", undefined, true );
	e_taylor Hide();
	
	level waittill( "inbound_igc_complete" );
	
	e_origin Delete();
}

function inbound_igc_done( a_ents )
{
	level notify( "inbound_igc_complete" );
}

function skipto_inbound_igc_done( str_objective, b_starting, b_direct, player )
{
}

//----------------------------------------------------------------------------
//
//
function skipto_train_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		init_train_flags();
		train_brake_flaps_init();
		level thread start_forest_environment();
		level thread train_civilians();
		
		newworld_util::wait_for_all_players_to_spawn();

		skipto::teleport( str_objective );
	}
	
	objectives::set( "cp_level_newworld_train_disarm" );

	level thread setup_robot_spawn_scenes();
	level thread train_terrain_handler();
	level thread train_lockdown();
	level thread train_climbers();
	level thread train_wind_resistance();
	level thread train_takedown_tutorial();
	level thread train_player_checkpoints();
	level thread train_spawn_functions();

	newworld_util::event_trigger_toggle( "train", "on" );
}

function skipto_train_done( str_objective, b_starting, b_direct, player )
{
}

function init_train_flags()
{
	if( !level flag::exists( "train_terrain_pause" ) )
	{
		level flag::init( "train_terrain_pause" );	
	}
	
	if( !level flag::exists( "train_terrain_resume" ) )
	{
		level flag::init( "train_terrain_resume" );	
	}
	
	if( !level flag::exists( "train_terrain_transition" ) )
	{
		level flag::init( "train_terrain_transition" );	
	}
	
	if( !level flag::exists( "train_terrain_move_complete" ) )
	{
		level flag::init( "train_terrain_move_complete" );	
	}
	
	if( !level flag::exists( "switch_to_forest" ) )
	{
		level flag::init( "switch_to_forest" );
	}
	
	if( !level flag::exists( "player_on_top_of_train" ) )
	{
		level flag::init( "player_on_top_of_train" );	
	}
}

function setup_robot_spawn_scenes()
{
	// TODO - cleanup the charging stations when the train car they're in locks down
	scene::add_scene_func( "p7_fxanim_cp_sgen_charging_station_open_01_bundle", &charging_station_open, "done" );
	
	scene::add_scene_func( "cin_new_scr_temp_robot_turnl", &init_train_wakeup_robot, "init" );
	scene::add_scene_func( "cin_new_scr_temp_robot_turnr", &init_train_wakeup_robot, "init" );
	scene::add_scene_func( "cin_new_scr_temp_robot_fwd", &init_train_wakeup_robot, "init" );
	
	scene::add_scene_func( "cin_new_scr_temp_robot_turnl", &play_train_wakeup_robot, "play" );
	scene::add_scene_func( "cin_new_scr_temp_robot_turnr", &play_train_wakeup_robot, "play" );
	scene::add_scene_func( "cin_new_scr_temp_robot_fwd", &play_train_wakeup_robot, "play" );
	
	scene::add_scene_func( "cin_new_scr_temp_robot_turnl", &done_train_wakeup_robot, "done" );
	scene::add_scene_func( "cin_new_scr_temp_robot_turnr", &done_train_wakeup_robot, "done" );
	scene::add_scene_func( "cin_new_scr_temp_robot_fwd", &done_train_wakeup_robot, "done" );
}

function charging_station_open( a_ents )
{
	if( isdefined( self.target ) )
	{
		s_scene = struct::get( self.target, "targetname" );
		s_scene scene::play();
	}
}

function init_train_wakeup_robot( a_ents )
{
	a_ents[ "train_wakeup_robot" ] util::magic_bullet_shield();
}

function play_train_wakeup_robot( a_ents )
{
	a_ents[ "train_wakeup_robot" ] util::stop_magic_bullet_shield();
}

function done_train_wakeup_robot( a_ents )
{
	if( isdefined( self.target ) )
	{
		e_goalvolume = GetEnt( self.target, "targetname" );
		
		a_ents[ "train_wakeup_robot" ] SetGoal( e_goalvolume, true );
	}
}

function train_takedown_tutorial()
{
	trigger::wait_till( "train_tutorial_takedown", undefined, undefined, false );

	level.players[ 0 ] dialog::say( "Use Takedown to quickly leap towards an enemy and bring it down." );
}

function train_second_tutorial()
{
	trigger::wait_till( "train_overdrive_tutorial", undefined, undefined, false );

	level.players[ 0 ] dialog::say( "Concussive Wave knocks down nearby enemies with a concussive blast." );
	level thread util::screen_message_create( &"CP_MI_ZURICH_NEWWORLD_SELECT_CYBERCORE", undefined, undefined, 0, 12 );	
}

function train_civilians()
{
	scene::add_scene_func( "cin_new_scr_temp_civilian_sit", &train_civilian_logic, "play" );
	//trigger::use( "train_play_civilian_scenes" );
	
	scene::play( "cin_new_scr_temp_civilian_sit" );
}

function train_civilian_logic( a_ents )
{
	e_civ = a_ents[ "train_civilian_model" ];
	
	e_civ SetCanDamage( true );

	while( 1 )
	{
		e_civ waittill( "damage", n_damage );
	
		if( n_damage > 1)
		{
			break;	
		}
	}

	e_civ clientfield::set( "derez_model_deaths", 1 );

	e_civ util::delay( 0.05, "death", &util::self_delete );
}

function train_lockdown()
{
	array::run_all( GetEntArray( "train_lockdown_glass_broken", "targetname" ), &Hide );
	array::run_all( GetEntArray( "train_lockdown_glass_broken_left", "targetname" ), &Hide );
	
	trigger::wait_till( "train_lockdown", undefined, undefined, false );

	array::run_all( GetEntArray( "train_lockdown_windows", "targetname" ), &MoveZ, 64, 0.5 );
	array::run_all( GetEntArray( "train_lockdown_door", "targetname" ), &MoveY, -64, 0.5 );
	
	level thread start_sequential_train_door_lockdown();

	wait 1.5; // Let windows close and some time to realize what happened

	level thread scene::play( "cin_new_15_02_train_aie_smash" );
	
	// notetrack on ch_new_15_02_train_aie_smash_robot1
	level waittill( "train_lockdown_glass_break_right" );
	
	array::run_all( GetEntArray( "train_lockdown_glass", "targetname" ), &Delete );
	array::run_all( GetEntArray( "train_lockdown_glass_broken", "targetname" ), &Show );
	
	// notetrack on ch_new_15_02_train_aie_smash_robot1
	level waittill( "train_lockdown_glass_break_left" );
	
	array::run_all( GetEntArray( "train_lockdown_glass_left", "targetname" ), &Delete );
	array::run_all( GetEntArray( "train_lockdown_glass_broken_left", "targetname" ), &Show );
}

function start_sequential_train_door_lockdown()
{
	e_trigger = GetEnt( "train_car_lockdown_04", "targetname" );
	e_trigger wait_for_train_car_to_be_empty();
	e_trigger Delete();
	
	e_trigger = GetEnt( "train_car_lockdown_03", "targetname" );
	e_trigger wait_for_train_car_to_be_empty();
	e_trigger Delete();
	
	e_trigger = GetEnt( "train_car_lockdown_02", "targetname" );
	e_trigger wait_for_train_car_to_be_empty();
	e_trigger Delete();
	
	e_trigger = GetEnt( "train_car_lockdown_01", "targetname" );
	e_trigger wait_for_train_car_to_be_empty();
	e_trigger Delete();
}

function wait_for_train_car_to_be_empty() // self = trigger
{
	b_empty_trigger = true;
	while( 1 )
	{
		foreach( player in level.players )
		{
			if( player IsTouching( self ) )
			{
				b_empty_trigger = false;
				break;				
			}
		}
		
		a_ai = GetAITeamArray( "axis" );
		foreach( ai in a_ai )
		{
			if( ai IsTouching( self ) )
			{
				b_empty_trigger = false;
				break;				
			}	
		}
		
		if( b_empty_trigger == true )
		{
			train_car_door_lock( self.script_noteworthy );
			
			break;
		}
		else
		{
			wait 0.1;
		}
	}	
}


function train_car_door_lock( str_targetname )
{
	e_door = GetEnt( str_targetname, "targetname" );
	e_door MoveY( -128, 0.5 );	
}

function train_car_1_lockdown()
{
	e_door = GetEnt( "train_lockdown_door_01", "targetname" );
	e_door MoveY( -128, 0.5 );
}

function train_climbers()
{
	trigger::wait_till( "train_climb_robot_scene" );

	for( i = 1; i < 4; i++ )
	{
		ai_robot = spawner::simple_spawn_single( "train_climb_robot" );
		
		s_scene = struct::get( "train_aie_climbtrain_0" + i, "targetname" );
		s_scene thread scene::play( ai_robot );
		
		wait 0.25;
	}
}

function train_wind_resistance()
{
	level endon( "train_terminate" );

	level thread player_on_top_of_train_watcher();
	
	e_volume = GetEnt( "train_rooftop_volume", "targetname" );

	while ( IsDefined( e_volume ) )
	{
		foreach ( player in level.players )
		{
			if ( !( isdefined( player.is_on_train_roof ) && player.is_on_train_roof ) && player IsTouching( e_volume ) )
			{
				e_volume thread train_wind_resistance_player( player );
			}
		}

		wait 1;
	}
}

function player_on_top_of_train_watcher() 
{
	e_trigger = GetEnt( "player_enters_train_rooftop", "targetname" );
	
	e_trigger waittill( "trigger" );
	
	altered_gravity_enable();
	level.player_on_top_of_train = true;
	level flag::set( "player_on_top_of_train" );
	
	level thread player_inside_train_watcher();	
}

function player_inside_train_watcher()
{
	e_trigger = GetEnt( "player_exits_train_rooftop", "targetname" );
	
	e_trigger waittill( "trigger" );
	
	altered_gravity_enable( false );
	level.player_on_top_of_train = undefined;
}

function train_wind_resistance_player( e_player )
{
	e_player endon( "death" );

	e_player.is_on_train_roof = true;
	e_player clientfield::set_to_player( "rumble_loop", 1 );
	
	n_last_push = GetTime();

	v_dir = AnglesToForward( ( 0, 180, 0 ) );
	n_push_strength = -50;
	
	e_player clientfield::set_to_player( "player_snow_fx", true );
	
	e_player thread player_is_ignored_when_climbing_to_roof();
	
	while ( e_player IsTouching( self ) )
	{
		if ( e_player.angles[ 1 ] >= -90 && e_player.angles[ 1 ] <= 90 )
		{
			e_player SetMoveSpeedScale( 1.2 );
		}
		else
		{
			e_player SetMoveSpeedScale( 0.7 );
		}

		// TODO - commented out until we can figure out a better implementation of this
//		if ( !IS_TRUE( e_player.is_reviving_any ) && !e_player laststand::player_is_in_laststand() && e_player GetVelocity() == 0 )
//		{
//			e_player SetVelocity( v_dir * n_push_strength );
//		}

		if ( GetTime() - n_last_push > 1000 )
		{
			Earthquake( 0.15, 0.4, e_player.origin, 128.0 ); // TODO: TEMP, may want to do ground reference ent for small sway
			n_last_push = GetTime();
		}

		wait 0.05;
	}

	e_player clientfield::set_to_player( "rumble_loop", 0 );
	e_player SetMoveSpeedScale( 1.0 );
	e_player.is_on_train_roof = false;
	e_player clientfield::set_to_player( "player_snow_fx", false );
}

// Lowers accuracy of all attackers against the player to a very small amount
// Prevents player from getting hit while they are first climbing up to the train rooftop
function player_is_ignored_when_climbing_to_roof() // self = player
{
	self endon( "death" );
	
	if( !( isdefined( self.climbed_to_roof ) && self.climbed_to_roof ) )
	{
		self.climbed_to_roof = true;	
		
		n_attackerAccuracy = self.attackerAccuracy;
		self.attackerAccuracy = 0.05;

		wait 5.0;

		self.attackerAccuracy = n_attackerAccuracy;		
	}
}

function train_brake_flaps_init()
{
	a_nd_cover = GetNodeArray( "train_rooftop_cover", "script_noteworthy" );
	foreach( node in a_nd_cover )
	{
		SetEnableNode( node, false );	
	}
	
	// Init the flaps (drop them down so they're flat)
	clientfield::set( "train_brake_flaps", 1 );
}

function train_brake_flaps_pop_up()
{
	level flag::wait_till( "player_on_top_of_train" );

	// Activate the flaps
	clientfield::set( "train_brake_flaps", 0 );
	
	// Small wait to allow brake flaps to raise up
	wait 2.5;
	
	a_nd_cover = GetNodeArray( "train_rooftop_cover", "script_noteworthy" );
	foreach( node in a_nd_cover )
	{
		SetEnableNode( node, true );	
	}
}

//function wait_for_robot_corpse()
//{
//	// TODO - add an endon
//
//	while( 1 )
//	{
//		a_e_corpses = GetCorpseArray();
//		
//		foreach( e_corpse in a_e_corpses )
//		{
//			a_s_breakflap = struct::get_array( "train_brake_flap", "targetname" );
//			foreach( s_breakflap in a_s_breakflap )
//			{
//				if( Distance2DSquared( e_corpse.origin, s_breakflap.origin ) < 150*150 )
//				{
//					PhysicsExplosionSphere( e_corpse.origin, 150, 149, 10.0, 0, 0 );
//					break;
//				}
//			}
//		}
//		
//		wait 0.1;
//	}	
//}

//----------------------------------------------------------------------------
//
//

function skipto_train_rooftop_init( str_objective, b_starting )
{	
	if ( b_starting )
	{
		init_train_flags();
		train_brake_flaps_init();
		level thread start_forest_environment();
		level thread train_car_1_lockdown();
		level thread train_spawn_functions();
		
		// SET UP LOCKDOWN
		level thread array::run_all( GetEntArray( "train_lockdown_windows", "targetname" ), &MoveZ, 64, 0.5 );
		level thread array::run_all( GetEntArray( "train_lockdown_door", "targetname" ), &MoveY, -64, 0.5 );

		level thread array::run_all( GetEntArray( "train_lockdown_glass", "targetname" ), &Delete );
		level thread array::run_all( GetEntArray( "train_lockdown_glass_left", "targetname" ), &Delete );
		level thread array::run_all( GetEntArray( "train_lockdown_glass_broken", "targetname" ), &Show );
		level thread array::run_all( GetEntArray( "train_lockdown_glass_broken_left", "targetname" ), &Show );
		
		level thread setup_robot_spawn_scenes();
		level thread train_civilians();
		level thread train_climbers();
		level thread train_wind_resistance();
		level thread train_player_checkpoints();
		
		newworld_util::wait_for_all_players_to_spawn();

		skipto::teleport( str_objective );
				
		newworld_util::event_trigger_toggle( "train", "on" );
		objectives::set( "cp_level_newworld_train_disarm" );
	}

	level thread train_brake_flaps_pop_up();
	level thread train_second_tutorial();
	level thread train_quadtank_scenes();
	
	e_door = GetEnt( "train_bomb_push_door", "targetname" );
	e_door Hide();
}

function skipto_train_rooftop_done( str_objective, b_starting, b_direct, player )
{
}

function train_spawn_functions()
{
	spawner::add_spawn_function_group( "train_robot_rushers", "script_noteworthy", &train_robot_rushers );
}

function train_robot_rushers() // self = AI
{
	self endon( "death" );
	
	if( self.classname === "actor_spawner_enemy_sec_robot_cqb_shotgun" )
	{
		self ai::set_behavior_attribute( "move_mode", "rusher" );
		self ai::set_behavior_attribute( "sprint", true );
	}
}

function train_quadtank_scenes()
{
	scene::play( "cin_gen_ambient_quadtank_inactive" );
}

// ----------------------------------------------------------------------------
//	altered_gravity_enable
// ----------------------------------------------------------------------------
function altered_gravity_enable( b_enable = true )
{
	if ( b_enable )
	{
		SetDvar( "phys_gravity_dir", ( -1, 0, 0.9 ) );  // make ragdoll AI and physics objects fall towards rear of train
	}
	else 
	{
		SetDvar( "phys_gravity_dir", ( 0, 0, 1 ) );  // default
	}
}

//----------------------------------------------------------------------------
//
//
function skipto_detach_bomb_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		init_train_flags();
		level thread start_forest_environment();
		
		e_door = GetEnt( "train_bomb_push_door", "targetname" );
		e_door Hide();
		
		newworld_util::wait_for_all_players_to_spawn();
		objectives::set( "cp_level_newworld_train_disarm" );
	}

	s_taylor = struct::get( "detach_bomb_taylor" );

	level.ai_taylor = util::get_hero( "taylor" );
	level.ai_taylor fx::play( "rez_in", undefined, undefined, undefined, true, "j_spine4", undefined, true );
	level.ai_taylor ForceTeleport( s_taylor.origin, s_taylor.angles );
	level.ai_taylor ai::set_ignoreme( true );
	
	s_gather = struct::get( "taylor_gather", "targetname" );
	e_gather = util::spawn_model( "tag_origin", s_gather.origin );
	
	objectives::set( "cp_level_newworld_train_waypoint", e_gather );
	
	e_trigger = GetEnt( "train_gather_taylor", "targetname" );
	trigger::wait_till( "train_gather_taylor" );
	
	objectives::complete( "cp_level_newworld_train_waypoint" );
	e_trigger Delete();
	e_gather Delete();
	
	level scene::play( "cin_new_15_03_train_vign_notime" );
	
	level.ai_taylor thread derez_taylor();

	e_trigger = GetEnt( "detach_bomb_trigger", "targetname" );
	e_trigger TriggerEnable( true );
	e_trigger SetCursorHint( "HINT_NOICON" );
	e_trigger SetHintString( &"CP_MI_ZURICH_NEWWORLD_ACTIVATE_DETACH_TRAIN" );

	s_use_trigger = struct::get( "detach_igc_use_trigger", "targetname" );
	e_use_trigger = util::spawn_model( "tag_origin", s_use_trigger.origin );
	objectives::set( "cp_level_newworld_train_detach", e_use_trigger );

	trigger::wait_till( "detach_bomb_trigger", undefined, undefined, false );

	objectives::complete( "cp_level_newworld_train_detach" );
	e_trigger Delete();
	e_use_trigger Delete();
	
	detach_bomb_igc();
	
	util::screen_fade_out( 2.0, "white" );
	wait 1;	// wait a little extra so the change isn't so jarring
	
	util::clientnotify( "newworld_train_complete" );
	objectives::complete( "cp_level_newworld_train_disarm" );
	skipto::objective_completed( str_objective );
}

function skipto_detach_bomb_igc_done( str_objective, b_starting, b_direct, player )
{
	foreach ( player in level.players )
	{
		player clientfield::set_to_player( "player_snow_fx", false );
	}
}

function detach_bomb_igc()
{
	scene::add_scene_func( "cin_new_16_01_detachbombcar_1st_detach", &temp_freeze_players, "done" );
	level thread scene::play( "cin_new_16_01_detachbombcar_1st_detach" );
	
	e_door = GetEnt( "train_bomb_push_door", "targetname" );
	e_door Show();
	
	// notetrack on pb_new_16_01_detachbombcar_1st_detach_player
	level waittill( "train_push" );

	a_e_train = GetEntArray( "train_bomb_push", "targetname" );
	a_e_train[ a_e_train.size ] = e_door;
	array::run_all( a_e_train, &MoveX, 8192, 5 );

	wait 4;

	PlayFX( level._effect[ "train_explosion" ], a_e_train[ 0 ] GetCentroid() );
}

function temp_freeze_players( a_ents )
{
	util::teleport_players_igc( "detach_bomb_igc_teleport" );
	
	// HACK - player anim isn't long enough to account for train blowing up
	// Prevents player from re-gaining control when scene ends
	foreach( player in level.players )
	{
		player SetLowReady( true );
		player util::freeze_player_controls( true );
	}
}	

function derez_taylor() // self = level.ai_taylor
{
	if ( IsDefined( self ) )
	{
		self clientfield::set( "derez_ai_deaths", 1 );
	}

	util::wait_network_frame();

	if ( IsDefined( self ) )
	{
		level.ai_taylor util::self_delete();
		
	}
}

//----------------------------------------------------------------------------
// Common
//




// TODO - refactor so everything runs on arrays
function start_forest_environment( b_intro = false )
{
	//level thread dynamic_shadows();
	
	e_1 = GetEnt( "train_terrain_forest_set_01", "targetname" );
	e_2 = GetEnt( "train_terrain_forest_set_02", "targetname" );
	e_3 = GetEnt( "train_terrain_forest_set_03", "targetname" );
	
	level thread environment_init( e_1, e_2, e_3, b_intro );
}

function start_tunnel_environment()
{
	e_1 = GetEnt( "train_terrain_tunnel_set_01", "targetname" );
	e_2 = GetEnt( "train_terrain_tunnel_set_02", "targetname" );
	e_3 = GetEnt( "train_terrain_tunnel_set_03", "targetname" );
	
	level thread environment_init( e_1, e_2, e_3 );
}

function train_terrain_handler()
{
	e_forest_1 = GetEnt( "train_terrain_forest_set_01", "targetname" );
	e_forest_2 = GetEnt( "train_terrain_forest_set_02", "targetname" );
	e_forest_3 = GetEnt( "train_terrain_forest_set_03", "targetname" );
	
	e_tunnel_1 = GetEnt( "train_terrain_tunnel_set_01", "targetname" );
	e_tunnel_2 = GetEnt( "train_terrain_tunnel_set_02", "targetname" );
	e_tunnel_3 = GetEnt( "train_terrain_tunnel_set_03", "targetname" );
	
	// on trigger "train_switch_to_tunnel_environment"
	level flag::wait_till( "train_switch_to_tunnel_environment" );
	
	level flag::set( "train_terrain_transition" );
	
	level flag::wait_till( "train_terrain_move_complete" );
	level flag::clear( "train_terrain_move_complete" );
	
	level environment_transition( e_forest_1, e_forest_2, e_forest_3, e_tunnel_1, e_tunnel_2, e_tunnel_3 );
	
	// on trigger "train_switch_to_forest_environment"
	level flag::wait_till( "train_switch_to_forest_environment" );
	
	level flag::set( "train_terrain_transition" );
	
	level flag::wait_till( "train_terrain_move_complete" );
	level flag::clear( "train_terrain_move_complete" );
	
	level thread environment_transition( e_tunnel_1, e_tunnel_2, e_tunnel_3, e_forest_1, e_forest_2, e_forest_3 );
}
	
function environment_init( e_environment_1, e_environment_2, e_environment_3, b_intro = false )
{
	if( b_intro == true )
	{
		s_origin = struct::get( "train_terrain_origin_intro", "targetname" );
	}
	else
	{
		s_origin = struct::get( "train_terrain_origin", "targetname" );	
	}
	
	// The train always sits in the middle of the three pieces of environment
	e_environment_1.origin = s_origin.origin - ( 36736, 0, 0 );
	e_environment_2.origin = s_origin.origin;
	if( isdefined( e_environment_3) )
	{
		e_environment_3.origin = s_origin.origin + ( 36736, 0, 0 );
	}		
	
	level.v_train_terrain_origin = e_environment_1.origin;
	
	e_environment_1 Show();
	e_environment_2 Show();
	e_environment_3 Show();
	
	level thread environment_move( e_environment_1, e_environment_2, e_environment_3 );
}
	
function environment_move( e_environment_1, e_environment_2, e_environment_3 )
{
	level endon( "white_infinite_igc_terminate" );
	level endon( "detach_bomb_igc_terminate" );
	
	while( !level flag::get( "train_terrain_transition" ) )
	{
		e_environment_1.origin = level.v_train_terrain_origin;
		e_environment_1 MoveX( 36736, 4 );
		e_environment_2 MoveX( 36736, 4 );
		if( isdefined( e_environment_3) )
		{
			e_environment_3 MoveX( 36736, 4 );	
		}
		
		wait 4;
		
		environment_pause();

		if( isdefined( e_environment_3) )
		{
			e_environment_3.origin = level.v_train_terrain_origin;
			e_environment_1 MoveX( 36736, 4 );
			e_environment_2 MoveX( 36736, 4 );
			e_environment_3 MoveX( 36736, 4 );
		
			wait 4;
			
			environment_pause();
		}

		e_environment_2.origin = level.v_train_terrain_origin;
		e_environment_1 MoveX( 36736, 4 );
		e_environment_2 MoveX( 36736, 4 );
		if( isdefined( e_environment_3) )
		{
			e_environment_3 MoveX( 36736, 4 );
		}
	
		wait 4;
		
		environment_pause();
	}
	
	level flag::set( "train_terrain_move_complete" );
}

function environment_pause()
{
	if( level flag::get( "train_terrain_pause" ) )
	{
		level flag::wait_till( "train_terrain_resume" );
	}
}

function environment_transition( e_old_environment_1, e_old_environment_2, e_old_environment_3, e_new_environment_1, e_new_environment_2, e_new_environment_3 )
{	
	// Make an array of the new track pieces
	a_new = [];
	if( isdefined( e_new_environment_3 ) )
	{
		a_new[ 0 ] = e_new_environment_3;
	}
	
	a_new[ a_new.size ] = e_new_environment_2;
	a_new[ a_new.size ] = e_new_environment_1;
	
	n_new_terrain_size = a_new.size;
	
	// Make an array of the old track pieces
	a_old = [];
	if( isdefined( e_old_environment_3 ) )
	{
		a_old[ 0 ] = e_old_environment_3;
	}
	
	a_old[ a_old.size ] = e_old_environment_2;
	a_old[ a_old.size ] = e_old_environment_1;
	
	// Rearrange the old track pieces in order from front of the train to back of the train
	s_pos = struct::get( "back_of_the_train", "targetname" );
	a_old = ArraySort( a_old, s_pos.origin, false );
	
	while( a_new.size > 0 )
	{
		// Remove and Hide the farthest away piece of the Old Track
		e_old_end = a_old[ a_old.size - 1 ];
		if( e_old_end === e_old_environment_1 || e_old_end === e_old_environment_2 || e_old_end === e_old_environment_3 )
		{
			a_old[ a_old.size - 1 ] Hide();
			array::pop( a_old, a_old.size - 1 );	
		}
		
		// Show a new piece of track and add it to the beginning of the track array
		a_new[0] Show();
		a_new[0].origin = level.v_train_terrain_origin;
		array::push_front( a_old, a_new[0] );
		array::pop_front( a_new, false );
		
		// Move every piece down the track
		foreach( e_track_model in a_old )
		{
			e_track_model MoveX( 36736, 4 );	
		}
		
		wait 4;
	}
	
	// Make sure the newly rearranged track has the correct number of pieces
	// This is here in case we have an environment set less than 3 pieces
	while( a_old.size > n_new_terrain_size )
	{
		a_old[ a_old.size - 1 ] Hide();
		array::pop( a_old, a_old.size - 1 );	
	}
	
	level flag::clear( "train_terrain_transition" );
	
	// Throw this environment set back in the move cycle
	if( isdefined( a_old[2] ) )
	{
		level thread environment_move( a_old[2], a_old[0], a_old[1] );
	}
	else
	{
		level thread environment_move( a_old[0], a_old[1], a_old[2] );	
	}	
}

// HACK - this is a test to see how we can simulate dynamic shadows for the train
function dynamic_shadows()
{
	level endon( "white_infinite_igc_terminate" );
	level endon( "detach_bomb_igc_terminate" );

	s_start = struct::get( "train_dynamic_shadow_start" );
	s_end = struct::get( "train_dynamic_shadow_end" );

	a_e_shadows = GetEntArray( "train_dyanmic_shadow", "targetname" );

	foreach ( n_index, e_shadow in a_e_shadows )
	{
		e_shadow.origin = ( s_start.origin[ 0 ], e_shadow.origin[ 1 ], e_shadow.origin[ 2 ] );
		e_shadow util::delay( n_index * 2, undefined, &dynamic_shadows_loop, s_start, s_end );
	}
}

function dynamic_shadows_loop( s_start, s_end )
{
	level endon( "white_infinite_igc_terminate" );
	level endon( "detach_bomb_igc_terminate" );

	n_length = Distance( s_start.origin, s_end.origin );
	n_time = 3.8;

	while ( true )
	{
		self MoveX( n_length, n_time );

		self waittill( "movedone" );

		self.origin = ( s_start.origin[ 0 ], self.origin[ 1 ], self.origin[ 2 ] );
	}
}

function train_player_checkpoints()
{
	level endon( "detach_bomb_igc_terminate" );
	
	level thread train_robot_fell_off();
	
	a_e_triggers = GetEntArray( "train_bad_area", "targetname" );
	foreach( e_trigger in a_e_triggers )
	{
		e_trigger thread train_player_fell_off();
	}
}

function train_player_fell_off() // self = trigger
{
	while( 1 )
	{
		self waittill( "trigger", e_who );

		if ( IsPlayer( e_who ) )
		{
			a_s_teleports = struct::get_array( self.target, "targetname" );
		
			while( 1 )
			{
				s_spot = array::random( a_s_teleports );
				
				if( !PositionWouldTelefrag( s_spot.origin ) )
				{
					e_who clientfield::set( "player_spawn_fx", true );
					e_who util::delay( 0.1, "death", &clientfield::set, "player_spawn_fx", false ); // Give some time for FX to play before turning off
					e_who SetOrigin( s_spot.origin );
					e_who SetPlayerAngles( s_spot.angles );
					break;
				}
			}
		}
	}
}

function train_robot_fell_off()
{
	level endon( "detach_bomb_igc_terminate" );

	e_trigger = GetEnt( "train_bad_area_robots", "targetname" );

	while ( true )
	{
		e_trigger waittill( "trigger", e_who );

		if ( !IsPlayer( e_who ) )
		{
			e_who Kill();
		}
	}	
}

//----------------------------------------------------------------------------
// Debug
//

function train_spawn_trigger_debug()
{
	array::run_all( GetEntArray( "train_spawn_triggers", "script_noteworthy" ), &train_spawn_triggers );
}

function train_spawn_triggers() // self = trigger
{
	self waittill( "trigger" );
	
	if( IsDefined( self.targetname ) )
	{
		IPrintLnBold( self.targetname );	
	}
	else if( IsDefined( self.scriptgroup_playscenes ) )
	{
		IPrintLnBold( "Spawned scriptgroup_playscenes " + self.scriptgroup_playscenes );
	}
	else if( IsDefined( self.target ) )
	{
		IPrintLnBold( "Spawned target " + self.scriptgroup_playscenes );	
	}
}
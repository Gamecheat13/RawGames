#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives; 
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\_hacking;

#using scripts\cp\cp_mi_zurich_newworld;
#using scripts\cp\cp_mi_zurich_newworld_util;
	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
           	    

#namespace newworld_underground;

#precache( "string", "CP_MI_ZURICH_NEWWORLD_ENHANCED_VISION" );
#precache( "string", "CP_MI_ZURICH_NEWWORLD_SELECT_CYBERCORE" );
#precache( "string", "CP_MI_ZURICH_NEWWORLD_USE_COMPUTER_INTERFACE" );

//
//	common underground start items
function startup_underground( str_objective )
{
	a_e_icicles = GetEntArray( "dest_ice", "targetname" );
	array::thread_all( a_e_icicles, &newworld_util::icicle );

	//detect hits on steam pipes
	a_t_steam = GetEntArray( "steam_pipe", "targetname" );
	array::thread_all( a_t_steam, &newworld_util::steam_pipe );

	level.ai_maretti = util::get_hero( "maretti" );
	skipto::teleport_ai( str_objective );

	//	get a struct based on the skipto
	str_obj_struct = "";
	switch( str_objective )
	{
		case "crossroads":
			str_obj_struct = "obj_crossroads";
			break;
		case "construction":
		case "maintenance":
			str_obj_struct = "obj_maintenance";
			break;
		case "water_plant":
			str_obj_struct = "obj_wt_exit";
			break;
	}
	
	if ( str_obj_struct != "" )
	{
		s_start = struct::get( str_obj_struct, "targetname" );
		mdl_temp = util::spawn_model( "tag_origin", s_start.origin, (0, 0, 0) );
		objectives::set( "cp_level_newworld_underground_waypoint", mdl_temp );
		objectives::set( "cp_level_newworld_underground_locate_terrorist" );
	}
}


//----------------------------------------------------------------------------
//
//
function skipto_pinned_down_igc_init( str_objective, b_starting )
{
	level thread startup_underground( str_objective );
		
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

	skipto::teleport( str_objective );

	level thread util::screen_fade_in( 2.0, "white" );
	
	level util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_TIME_FACTORY", undefined, undefined, 150, 5 );

	trigger::use( "underground_subway_start_color_trigger" );
	pinned_down_igc();

	skipto::objective_completed( str_objective );
}

function skipto_pinned_down_igc_done( str_objective, b_starting, b_direct, player )
{
}

function pinned_down_igc()
{
	level thread scene::add_scene_func( "cin_new_10_01_pinneddown_1st_explanation", &pinneddown_notetracks, "play" );
	level thread scene::add_scene_func( "cin_new_10_01_pinneddown_1st_explanation", &pinneddown_end, "done" );
	
	scene::play( "cin_new_10_01_pinneddown_1st_explanation" );
	util::teleport_players_igc( "pinned_down_igc" );
}

function pinneddown_notetracks( a_ents )
{
	a_ents[ "maretti" ] SetIgnorePauseWorld( true );
	a_ents[ "taylor" ] SetIgnorePauseWorld( true );
	a_ents[ "player 1" ] SetIgnorePauseWorld( true );
	
	level thread pinneddown_timefreeze();
	a_ents[ "maretti" ] thread maretti_pinneddown_notetracks();
	a_ents[ "taylor" ] thread taylor_pinneddown_notetracks();
	a_ents[ "pinneddown_grenade" ] thread pinneddown_grenade_notetracks();
}

function maretti_pinneddown_notetracks()
{
	self Hide();
	
	self waittill( "rez_maretti" );
	
	self Show();
	self fx::play( "rez_in", undefined, undefined, undefined, true, "j_spine4", undefined, true );
}

function taylor_pinneddown_notetracks()
{
	self Hide();
	
	self waittill( "rez_taylor" );
	
	self Show();
	self fx::play( "rez_in", undefined, undefined, undefined, true, "j_spine4", undefined, true );
	
	self waittill( "derez_taylor" );
	
	self Hide();
	v_origin = self GetTagOrigin( "j_spine4" );
	e_origin = util::spawn_model( "tag_origin", v_origin, self.angles );
	e_origin fx::play( "rez_out", undefined, undefined, undefined, true, "tag_origin", undefined, true );
	
	level waittill( "pinneddown_complete" );
	
	e_origin Delete();
}

function pinneddown_timefreeze()
{
	array::wait_any( level.players, "timefreeze_start" );
	
	SetPauseWorld( true );
	
	// notetrack on ch_new_10_01_pinneddown_1st_explanation_maretti
	level waittill( "timefreeze_end" );
	
	SetPauseWorld( false );
}

function pinneddown_grenade_notetracks()
{
	self waittill( "explosion_start" );
	
	e_origin = util::spawn_model( "tag_origin", self.origin, self.angles );
	e_origin fx::play( "frag_grenade", undefined, undefined, undefined, true, "tag_origin", undefined, false );
	self Hide();
	
	level waittill( "pinneddown_complete" );
	
	e_origin Delete();
}

function pinneddown_end( a_ents )
{
	a_ents[ "pinneddown_sec_soldier" ].health = 1;
	
	level notify( "pinneddown_complete" );
}

//----------------------------------------------------------------------------
//
//
function skipto_subway_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread startup_underground( str_objective );

		newworld_util::wait_for_all_players_to_spawn();
		
		a_sec_ai = spawner::simple_spawn( "pinneddown_sec_soldier" );
		foreach( ai in a_sec_ai )
		{
			ai thread delay_and_lower_health();
		}
	}

	s_start = struct::get( "obj_subway_station", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint", s_start  );
	objectives::set( "cp_level_newworld_underground_locate_terrorist" );

	//detect hits on steam pipes
	a_t_steam = GetEntArray( "steam_pipe", "targetname" );
	array::thread_all( a_t_steam, &newworld_util::steam_pipe );

	thread subway_hints();
	
	// Station
	
	//spawner::add_spawn_function_group( "subway_station_enemies", "targetname", &underground_robot_rushers );
	spawner::add_spawn_function_group( "subway_station_enemies2", "targetname", &underground_robot_rushers );
	spawner::add_spawn_function_group( "subway_station_coop", "targetname", &underground_robot_rushers );
	
	spawner::simple_spawn( "subway_station_enemies" );
	a_sec_ai = spawner::simple_spawn( "pinneddown_sec_soldier_extra" );
	foreach( ai in a_sec_ai )
	{
		ai thread delay_and_lower_health();
	}
	
	newworld_util::wait_till_flag_or_ai_group_ai_count( "subway_station_wave2", "aig_subway_station1", (2 + (level.players.size * 1.5)) );

	spawner::simple_spawn( "subway_station_enemies2" );
	spawn_manager::enable( "subway_station_coop_sm" );

	trigger::wait_till( "trig_obj_subway" );
	
	objectives::complete( "cp_level_newworld_underground_waypoint" );
	s_start = struct::get( "obj_crossroads", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint", s_start );
	
	trigger::wait_till( "trig_subway_tunnel_mid" );

	spawner::simple_spawn( "subway_tunnel_mid_enemies" );

	trigger::wait_till( "trig_subway_tunnel_mid2" );

	spawner::simple_spawn( "subway_tunnel_mid_enemies2" );

	skipto::objective_completed( str_objective );
}

function skipto_subway_done( str_objective, b_starting, b_direct, player )
{
}

function delay_and_lower_health() // self = AI
{
	self endon( "death" );
	
	// random wait so all the AI don't die off at the same time
	wait( RandomFloatRange( 1.0, 5.0 ) );
	
	self.health = 1;
}

function underground_robot_rushers() // self = AI
{
	self endon( "death" );
	
	if( self.classname === "actor_spawner_enemy_sec_robot_cqb_shotgun" )
	{
		
		if( isdefined( self.target ) )
		{
			self waittill( "goal" );
		}
		
		self ai::set_behavior_attribute( "move_mode", "rusher" );
		self ai::set_behavior_attribute( "sprint", true );
		
		self SetIgnoreEnt( level.ai_maretti, true );
	}
}

//
//	Various hint text for the subway
function subway_hints()
{
	//	Assign new abilities
	foreach( player in level.players )
	{
		player cybercom_gadget::takeAllAbilities();	// remove all abilities
		player cybercom_gadget::giveAbility( "cybercom_immolation", false );
		player cybercom_gadget::equipAbility( "cybercom_immolation" );
	}
	
	//TEMP	add a delay so it doesn't interfere with the Chyron text.  Eventually there will be an IGC to space these out.
	wait 5 + 0.1;
	
	level.players[0] dialog::say( "Immolation causes robotic power sources to burst into flames." );

	trigger::wait_till( "trig_choose_abilities" );
	
	//	Assign new abilities
	foreach( player in level.players )
	{
		player cybercom_gadget::giveAbility( "cybercom_sensoryoverload", false );
	}
	
	level.players[0] dialog::say( "Sensory Overload temporarily disables human targets." );
	
	thread util::screen_message_create( &"CP_MI_ZURICH_NEWWORLD_SELECT_CYBERCORE", undefined, undefined, undefined, 5.0 );
}


//----------------------------------------------------------------------------
//
function skipto_crossroads_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread startup_underground( str_objective );

		newworld_util::wait_for_all_players_to_spawn();
	}
	
	level thread trigger_steam_pipes();

	//	Crossroads
	trigger::wait_till( "trig_subway_crossroads" );
	
	spawner::simple_spawn( "subway_crossroads_enemies" );
	spawn_manager::enable( "subway_crossroads_coop_sm" );

	trigger::wait_till( "trig_smokescreen" );

	objectives::complete( "cp_level_newworld_underground_waypoint" );
	s_start = struct::get( "obj_maintenance", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint", s_start );

	skipto::objective_completed( str_objective );
}


function skipto_crossroads_done( str_objective, b_starting, b_direct, player )
{
}

function trigger_steam_pipes()
{
	w_ar = GetWeapon( "ar_standard" );
	
	a_s_start = struct::get_array( "underground_fake_steam", "targetname" );
	foreach( s_start in a_s_start )
	{
		s_end = struct::get( s_start.target, "targetname" );
		
		for( i = 0; i < 5; i++ )
		{
			MagicBullet( w_ar, s_start.origin, s_end.origin );
		}
		
		wait 0.5;
	}
	
	trigger::wait_till( "trigger_steam_pipes2" );
	
	a_s_start = struct::get_array( "underground_fake_steam2", "targetname" );
	foreach( s_start in a_s_start )
	{
		s_end = struct::get( s_start.target, "targetname" );
		
		for( i = 0; i < 5; i++ )
		{
			MagicBullet( w_ar, s_start.origin, s_end.origin );
		}
		
		wait 0.5;
	}
}


//----------------------------------------------------------------------------
//
function skipto_construction_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread startup_underground( str_objective );

		newworld_util::wait_for_all_players_to_spawn();
	}
	
	a_nd_cover = GetNodeArray( "underground_construction_cover", "script_noteworthy" );
	foreach( nd_cover in a_nd_cover )
	{
		SetEnableNode( nd_cover, false );
	}
	
	spawner::add_spawn_function_group( "wall_breaker_enemy", "targetname", &underground_robot_rushers );
	spawner::add_spawn_function_group( "construction_coop_enemies", "targetname", &underground_robot_rushers );

	//	Smokescreen segment
	a_ai_smokers = spawner::simple_spawn( "smokescreen_enemies" );
	level thread smoke_grenade_scenes();

	util::delay( 2.0, undefined, &util::screen_message_create, &"CP_MI_ZURICH_NEWWORLD_ENHANCED_VISION", undefined, undefined, undefined, 5.0 );

	trigger::wait_till( "trig_smokescreen_retreat" );

	spawner::simple_spawn( "smokescreen_retreat_enemies" );
	
	//	Construction segment
	trigger::wait_till( "trig_wall_break" );

	spawner::simple_spawn( "construction_enemies" );
	
	level thread maretti_wrestles_robot_scene();
	
	// TODO - temp - give space b/w Maretti wrestles a robot scene and other robot bust through's
	wait 2.0;
	
	a_s_wall_breaker = struct::get_array ( "wall_breaker_enemies_1", "targetname");
	for (i = 0; i < level.players.size + 2; i++ )
	{
		a_s_wall_breaker[i] thread wall_break_func();
	}
	
	if( level.players.size > 1 )
	{
		spawn_manager::enable( "construction_coop_sm" );	
	}
				
	//	end of segment
	trigger::wait_till( "trig_maintenance" );

	skipto::objective_completed( str_objective );
}

function skipto_construction_done( str_objective, b_starting, b_direct, player )
{
}

function smoke_grenade_scenes()
{
	scene::add_scene_func( "cin_new_11_01_subway_rollgrenade_single", &play_smoke_grenade_fx, "done" );
	scene::add_scene_func( "cin_new_11_01_subway_rollgrenade_group", &play_smoke_grenade_fx_group, "done" );
	
	scene::play( "cin_new_11_01_subway_rollgrenade_single" );
	scene::play( "cin_new_11_01_subway_rollgrenade_group" );
}

function play_smoke_grenade_fx( a_ents )
{
	e_grenade = a_ents[0];
	
	fx::play( "smoke_grenade", e_grenade.origin, e_grenade.angles );
	e_grenade Delete();
}

function play_smoke_grenade_fx_group( a_ents )
{
	foreach( e_grenade in a_ents )
	{
		fx::play( "smoke_grenade", e_grenade.origin, e_grenade.angles );
		e_grenade Delete();		
		
		wait 0.1;
	}
}

function maretti_wrestles_robot_scene()
{	
	mdl_wall = GetEnt( "drywall_burst_02", "targetname" );
	mdl_wall DisconnectPaths();
	
	scene::add_scene_func( "cin_new_11_01_subway_vign_bustout", &maretti_wrestles_robot_end, "done" );
	level thread scene::play( "cin_new_11_01_subway_vign_bustout" );
	
	fx::play( "wall_break", mdl_wall.origin, mdl_wall.angles );
	mdl_wall ConnectPaths();
	mdl_wall Delete();
	
	if( isdefined( self.target ) )
	{
		a_nd_cover = GetNodeArray( self.target, "targetname" );
		foreach( nd_cover in a_nd_cover )
		{
			SetEnableNode( nd_cover, true );
		}	
	}
}

function maretti_wrestles_robot_end( a_ents )
{
	a_ents[ "robot_wrestles_maretti" ] Kill();
}	
	
//	self is the script bundle placed in the level
function wall_break_func()
{
	ai_robot = spawner::simple_spawn_single( "wall_breaker_enemy" );
	ai_robot endon( "death" );
	
	// first init the scene so the bot spawns. delay "script_float" then play scene then destroy the wall.
	self scene::init( "cin_new_11_03_subway_aie_smash", ai_robot );
	
	mdl_wall = GetEnt( self.script_noteworthy, "targetname" );
	mdl_wall DisconnectPaths();
	
	if (isdefined ( self.script_float) )
	{
		//delay playing of the scene for pacing
		wait self.script_float;
	}
	
	//play the scene
	self thread scene::play( "cin_new_11_03_subway_aie_smash", ai_robot );
	
	//kill the wall
	fx::play( "wall_break", mdl_wall.origin, mdl_wall.angles );
	mdl_wall ConnectPaths();
	mdl_wall Delete();
	
	if( isdefined( self.target ) )
	{
		a_nd_cover = GetNodeArray( self.target, "targetname" );
		foreach( nd_cover in a_nd_cover )
		{
			SetEnableNode( nd_cover, true );
		}	
	}
}

//----------------------------------------------------------------------------
//
//
function skipto_maintenance_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread startup_underground( str_objective );

		newworld_util::wait_for_all_players_to_spawn();

		skipto::teleport( str_objective );
	}
	
	spawner::add_spawn_function_group( "underground_maintenance_shotgun", "script_noteworthy", &underground_robot_rushers );

	trigger::wait_till( "trig_maintenance" );
	
	level flag::init( "maintenance_subway_move_done" );

	level thread move_subway_car();

	spawn_manager::enable( "sm_maintenance_near" );
	spawn_manager::enable( "sm_maintenance" );
	level thread stop_maintenance_spawn_manager();
	
	level flag::wait_till( "maintenance_subway_move_done" );
	
	spawner::simple_spawn( "maintenance_enemies" );

	// objective trigger will complete
}

function skipto_maintenance_done( str_objective, b_starting, b_direct, player )
{
}

function stop_maintenance_spawn_manager()
{
	trigger::wait_till( "trig_stop_sm_maintenance" );

	spawn_manager::disable( "sm_maintenance" );
}

//	
//	Robots "push" the subway car out of place
function move_subway_car()
{
	mdl_subway_car = GetEnt( "subway_car_push", "targetname" );
	
	a_ai_riders = spawner::simple_spawn( "train_rider_robots" );
	foreach( ai_rider in a_ai_riders )
	{
		ai_rider LinkTo( mdl_subway_car );
	}
	
	level thread scene::play( "cin_new_11_01_subway_vign_pushsubway" );
	
	// Move to the starting position
	n_move_x = 752;
	mdl_subway_car.origin += ( n_move_x, 0, 0 );
	util::wait_network_frame();

	//	Move subway car into place
	mdl_subway_car MoveX( -1*n_move_x, 6 );
	util::wait_network_frame();
	
	// Space out spawning
	spawner::simple_spawn( "train_push_robots" );

	mdl_subway_car waittill( "movedone" );
	
	level flag::set( "maintenance_subway_move_done" );
	
	mdl_subway_car ConnectPaths();
	
	foreach( ai_rider in a_ai_riders )
	{
		if ( IsAlive( ai_rider ) )
		{
			ai_rider Unlink();
		}
	}
}


//----------------------------------------------------------------------------
//
//
//	wt == Water Treatment Plant

function skipto_water_plant_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread startup_underground( str_objective );

		newworld_util::wait_for_all_players_to_spawn();

		skipto::teleport( str_objective );
	}
	
	t_water_treatment_end_use_trigger = GetEnt( "water_treatment_exit_use_trigger", "targetname" );
	t_water_treatment_end_use_trigger Hide();

	objectives::complete( "cp_level_newworld_underground_waypoint" );
	s_start = struct::get( "obj_wt_exit", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint", s_start );

	//spawner::add_spawn_function_group( "plant_drone", "targetname", &drone_patrol );
	
	level thread water_plant_intro();
	
	trigger::wait_till( "trig_plant_drones" );
	
	spawner::simple_spawn( "plant_drone" );
		
	trigger::wait_till( "trig_wp_humans" );

	a_ai_wt_humans = spawner::simple_spawn( "wp_humans" );

	//TEMP HACK - wp_humans aren't moving after spawning now.  Need to figure out why later
//	e_vol_fallback = GetEnt( "vol_water_plant_exit", "targetname" );
//	foreach( ai_enemy in a_ai_wt_humans )
//	{
//		ai_enemy SetGoal( e_vol_fallback );
//	}
	//TEMP HACK

	trigger::wait_till( "trig_plant_wave2" );

	spawner::simple_spawn( "plant_drone2" );
	
	flag::wait_till( "water_exit_fallback" );

	// Enemies fallback to protect the exit (and also easier to spot)
	e_vol_fallback = GetEnt( "vol_water_plant_exit", "targetname" );
	a_ai_enemies = GetAITeamArray( "axis" );
	foreach( ai_enemy in a_ai_enemies )
	{
		ai_enemy SetGoal( e_vol_fallback, true );
	}
	
	level thread water_treatment_fallback();

	// Wait for enemies to die
	spawner::waittill_ai_group_cleared( "aig_water_treatment" );
	
	objectives::complete( "cp_level_newworld_underground_waypoint" );
	
	s_start = struct::get( "water_treatment_hack_waypoint", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint_hack", s_start );
	
	// Now send Maretti to the exit.
	nd_exit = GetNode( "nd_wt_exit_door", "targetname" );
	level.ai_maretti SetGoal( nd_exit, true, 16 );
	
		// TODO - player hacks door open
	// door  that player "hacks" after the Water Treatment
	t_water_treatment_end_use_trigger SetHintString( &"CP_MI_ZURICH_NEWWORLD_WATER_TREATMENT_EXIT" );
	t_water_treatment_end_use_trigger SetCursorHint( "HINT_NOICON" );	
	t_water_treatment_end_use_trigger Show();
	t_water_treatment_end_use_trigger hacking::init_hack_trigger( 2.4 );
	t_water_treatment_end_use_trigger hacking::trigger_wait();
	t_water_treatment_end_use_trigger TriggerEnable( false );
	
	objectives::complete( "cp_level_newworld_underground_waypoint_hack" );

	//TEMP Move door out of the way until I add the kill/gather scripting
	mdl_exit_door = GetEnt( "wt_gather_door", "targetname" );
	mdl_exit_door MoveZ( 96, 1.0 );
	
	util::delay( 1.0, undefined, &trigger::use, "water_treatment_exit_color_trigger" );
	
	s_start = struct::get( "obj_staging_room", "targetname" );
	objectives::set( "cp_level_newworld_underground_waypoint", s_start );

	//	Now head to the computer
	trigger::wait_till( "trig_staging_area" );
	
	objectives::complete( "cp_level_newworld_underground_waypoint" );

	skipto::objective_completed( str_objective );
}

function skipto_water_plant_done( str_objective, b_starting, b_direct, player )
{
}

//self is level
function water_plant_intro()
{
	//this flag is set on the trigger with targetname "trig_water_plant_drone_intro_start"
	level flag::wait_till( "b_water_plant_intro_go" );
	
	//spawn in the drones
	spawner::simple_spawn( "plant_intro_drone_a", &drone_patrol );
	spawner::simple_spawn( "plant_intro_drone_b", &drone_patrol );
		
	//Maretti points out drones
	level thread scene::play ("cin_new_12_01_watertreatment_vign_point");	
}

//
//	self is a vehicle
function drone_patrol()
{
	self endon( "death" );
	
	self thread wt_intro_amws_awareness();

	if ( !isdefined( self.target ) )
	{
		return;
	}
	self.goalradius = 128;
	self ai::set_ignoreall( true );

	s_goal = struct::get( self.target, "targetname" );
		
	while( isdefined( s_goal ) )
	{			
		self SetGoal( s_goal.origin, true );
		self waittill( "at_anchor" );
		
		if ( isdefined( s_goal.target ) )
		{
			s_goal = struct::get( s_goal.target, "targetname" );
		}
		else
		{
			s_goal = undefined;
		}
	}
	
	self ai::set_ignoreall( false );
	
	e_goalvolume = GetEnt( "wt_amws_forward_goalvolume", "targetname" );
	self SetGoal( e_goalvolume, true );
}

function wt_intro_amws_awareness() // self = amws
{
	self endon( "death" );
	
	self util::waittill_any( "damage", "bulletwhizby", "pain", "proximity" );
	
	self ai::set_ignoreall( false );
}

function water_treatment_fallback()
{
	spawner::waittill_ai_group_ai_count( "aig_water_treatment", 2 );
	
	// Enemies fallback to protect the exit (and also easier to spot)
	e_vol_fallback = GetEnt( "vol_water_plant_fallback", "targetname" );
	a_ai_enemies = GetAITeamArray( "axis" );
	foreach( ai_enemy in a_ai_enemies )
	{
		ai_enemy SetGoal( e_vol_fallback, true );
	}	
}

//----------------------------------------------------------------------------
//
//
function skipto_staging_room_igc_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		newworld_util::wait_for_all_players_to_spawn();
		
		level.ai_maretti = util::get_hero( "maretti" );
		
		skipto::teleport( str_objective );
		
		objectives::set( "cp_level_newworld_underground_locate_terrorist" );
	}

	level staging_room_igc();

	util::screen_fade_out( 2.0, "white" );
	wait 1;	// wait a little extra so the change isn't so jarring

	util::unmake_hero( "maretti" );
	level.ai_maretti Delete();
	
	objectives::complete( "cp_level_newworld_underground_locate_terrorist" );
	skipto::objective_completed( str_objective );
}


function skipto_staging_room_igc_done( str_objective, b_starting, b_direct, player )
{
}

function staging_room_igc()
{
	s_obj = struct::get( "staging_room_igc_obj", "targetname" );
	
	// TODO - use new hack waypoint
	//objectives::set( "cp_level_newworld_subway_hack" );
	objectives::set( "cp_level_newworld_underground_waypoint_hack", s_obj );

	//	use trigger will end water plant skipto
	t_use_comp = GetEnt( "trig_use_staging_comp", "targetname" );
	t_use_comp SetHintString( &"CP_MI_ZURICH_NEWWORLD_USE_COMPUTER_INTERFACE" );
	t_use_comp SetCursorHint( "HINT_NOICON" );

	t_use_comp waittill( "trigger" );
	
	t_use_comp Delete();
	objectives::complete( "cp_level_newworld_underground_waypoint_hack" );
	
	scene::play( "cin_new_13_01_stagingroom_1st_guidance" );

	//objectives::complete( "cp_level_newworld_subway_hack" );
	level notify( "staging_room_igc_complete" );
}

//-------------------------------------------------------------------
//	DEV
//-------------------------------------------------------------------

//
//TEMP 	Test to see the issues with timescaling to very low amounts.
function dev_timescale_test( str_objective, b_starting )
{
	if ( b_starting )
	{
		if ( !IsDefined( level.ai_taylor ) )
		{
			level.ai_taylor = util::get_hero( "taylor" );
		}
	
		newworld_util::wait_for_all_players_to_spawn();
	}

	str_test_scene_slow = "cin_der_01_intro_3rd_sh120_test";	// this scene will slow down with the rest of the world
	str_test_scene_normal = "cin_der_01_intro_3rd_sh120_test_takeo";	// this scene should play at normal time, no matter what.

	n_test_scale_slow = 0.05;	// slowdown scale
	n_test_scale_normalized = 1 / n_test_scale_slow;	// speed up scale to compensate for slowdown

	// Setup the stand-in actor 
	level.ai_taylor.targetname = "takeo_ai";
	level.ai_taylor.animname = "takeo";
	level.ai_taylor SetModel( "c_zom_der_takeo_cin_nowire_fb" );	// Need to change the model so the facial animation works
	level.ai_taylor SetIgnorePauseWorld( true );	// Keep on acting normal, even if the world is frozen
	
	//temp exclude players - should be done by default
	foreach( player in level.players )
	{
		player SetIgnorePauseWorld( true );	// Keep on acting normal, even if the world is frozen
	}
	
	s_fx_align = struct::get( "fx_align", "targetname" );
	wait 2.0;

	i = 0;
	b_pause_takeo = false;
	
	while ( 1 )
	{
		// Alternate slow and normal speed playbacks for comparison
		if ( i % 2 == 0 )
		{
			b_pause_takeo = false;
		}
		else
		{
			b_pause_takeo = true;
		}

		iprintlnbold( "PAUSE WORLD = " + b_pause_takeo );
		
		fx::play( "large_explosion", s_fx_align.origin, s_fx_align.angles );
		wait 0.1;

		level thread scene::play( str_test_scene_slow );
		level thread scene::play( str_test_scene_normal );

		if ( b_pause_takeo )
		{
			SetPauseWorld( true );
		}
		
		while( scene::is_playing( str_test_scene_normal ) )
		{
			wait 0.05 ;
		}
		
//		setSlowMotion( n_scale_slow, 1.0, 0.016 ); // start timescale, end timescale, lerp duration
		SetPauseWorld( false );

		wait 3;

		if ( scene::is_playing( str_test_scene_slow ) )
		{
			level thread scene::stop( str_test_scene_slow );
		}
		
		i++;
	}
}
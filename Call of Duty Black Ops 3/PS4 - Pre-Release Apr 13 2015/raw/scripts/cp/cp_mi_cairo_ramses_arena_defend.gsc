//----------------------------------------------------------
// Notes:
//		tag_align:
//			- tag_align_easterncheckpoint
//			- tag_align_walldefend
//----------------------------------------------------------
// Sinkhole Notes
/* ********************************************************************************************
 * The entire street is an fxanim and the collision is a brushmodel group.
 * The street collision generates navmesh by checking "static_navmesh" on it.
 * All props and cover items are script models and thier clips are brushmodels. Scriptmodels are linked to the street model so they animate with it.
 * When detonating the street, the fxanim plays, the props and street brushmodels delete, and traversals unlink.
 * 
 * KvPs:
 * 		Props and cover: "targetname"/"arena_defend_models"
 * 		Props that don't get DisconnectPaths(): "script_noteworthy"/"ignore_paths" 
 * 		Sinkhole brushmodels: "targetname"/"arena_defend_sinkhole"
 * 		Street collision brushmodel group: "targetname"/"arena_defend_street_col"
 * 		Street collision brushmodel group: "static_navmesh"/[checked]
 * 
 * How this works:
 * 		The model for the fxanim spawns when it is needed.
 * 		The props and cover items get linked to the fxanim model.
 * 			- This is done partly through fxanim and partly through script.
 * 			- Script models that get navmesh do not get DisconnectPaths() via "script_noteworthy"/"ignore_paths." Their bounding box is defined via the street collision brushmodel so that navmesh will generate on them.
 * 		Traverslals get unlinked when the sinkhole is created.
 * 
 * *******************************************************************************************/
#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#using scripts\shared\vehicles\_quadtank;

#using scripts\shared\ai\robot_phalanx;

#using scripts\shared\weapons\_weaponobjects;

#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\_laststand;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_vehicle;


#using scripts\cp\cp_mi_cairo_ramses2_fx;
#using scripts\cp\cp_mi_cairo_ramses2_sound;

#using scripts\cp\cp_mi_cairo_ramses_alley;
#using scripts\cp\cp_mi_cairo_ramses_vtol_igc;
#using scripts\cp\cp_mi_cairo_ramses_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             
                      

#precache( "objective", "cp_level_ramses_defend_checkpoint" );
#precache( "objective", "cp_level_ramses_destroy" );
#precache( "objective", "cp_level_ramses_destroy_weakpoints" );
#precache( "objective", "cp_level_ramses_detonate_street_charges" );
#precache( "objective", "cp_level_ramses_reinforce_safiya" );
#precache( "objective", "cp_level_ramses_reinforce_safiya_breadcrumb" );
#precache( "string", "CP_MI_CAIRO_RAMSES_SPIKE_AMMO_MISSING" );
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_DETONATE_CHARGES" );
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_PICK_UP_SPIKE_LAUNCHER" );
#precache( "triggerstring", "CP_MI_CAIRO_RAMSES_PLANT_SPIKE" );
#precache( "model", "p7_cai_subway_frame_side_post" );  // weak point visualization

#precache( "string", "cp_ramses2_fs_intheinterestoftimeshort" ); //movie plays after the arena defend is completed
#precache( "string", "cp_ramses2_pip_unstableground" ); //pip movie during arena defend







	



#namespace arena_defend;

function autoexec __init__sytem__() {     system::register("arena_defend",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "arena_defend_weak_point_keyline", 1, 1, "int" );		
	
	clientfield::register( "world", "arena_defend_hide_sinkhole_models", 1, 1, "int" );
	
	clientfield::register( "world", "arena_defend_mobile_wall_destroyed_swap", 1, 1, "int" );
	
	clientfield::register( "world", "clear_all_dyn_ents", 1, 1, "counter" );
	
	level thread scene::play( "cin_ram_05_01_quadtank_flatbed_pose" );
	
	ramses_util::enable_nodes( "arena_defend_car4cover_node", "targetname", false );
	
	//don't turn these on until hendricks/khalil run back at the end of the sequence
	ramses_util::enable_nodes( "hendricks_mobile_wall_start_node", "targetname", false );
	ramses_util::enable_nodes( "arena_defend_demostreet_intro_khalil", "targetname", false );
	
	ramses_util::enable_nodes( "mobile_wall_door_traversals", "targetname", false );
	
	m_collision = GetEnt( "mobile_wall_doors_clip", "targetname" );
	m_collision DisconnectPaths(); //make sure guys don't try to run through doorway at beginning
	
	//this gets turned on once weak point 04 is destroyed
	t_damage_fire = GetEnt( "trig_wp_04_damage", "targetname" );
	t_damage_fire TriggerEnable( false );
	
	//light stuff that will get reenabled in demostreet_3rd_sh020 cutscene
	a_shadow_blockers = GetEntArray( "lgt_shadow_block", "targetname" );

	foreach ( blocker in a_shadow_blockers )
	{
		blocker Hide();
	}
	
	//don't try to use traversal underneath weak points 01-05 initially
	for ( i = 1; i < 6; i++ )
	{
		ramses_util::enable_nodes( "wp_0" + i + "_traversal_jump", "script_noteworthy", false ); 
	}
	
	init_flags();
	
	SetDvar( "ui_newHud", 1 );  // TEMP: enable comms UI visualization. Remove when this is set by default
}

function intro( str_objective, b_starting )
{
	util::set_streamer_hint( 1 );
	
	init_common_scripted_elements( str_objective, b_starting );
	
	level flag::wait_till( "first_player_spawned" );
	
	level util::screen_fade_out( 0 );
	
	// make it look like there's already a fight going on here
	level thread vignette_intro_technical();
	enable_initial_wave_spawn_managers();
	
	wait 0.25; //wait a bit before starting the fade-in
	
	level thread util::screen_fade_in( 2 );
	
	level.allowbattlechatter["bc"] = false;
	
	level notify ("drive_music");
	
	level flag::set( "arena_defend_spawn" );
	
	level thread open_door_for_intro();
	level thread ramses_util::play_scene_on_notify( "cin_ram_05_01_defend_vign_rescueinjured_r_group", "arena_defend_intro_player_exits_technical" );  // notify comes from xanim 'pb_ram_05_01_block_1st_rip_player' notetrack
	
	level wall_fxanim_scene( true );  // play full mobile wall drop anim
	
	level thread khalil_talks_to_area_commander();
	
	skipto::objective_completed( str_objective );
}

function open_door_for_intro()
{
	level util::waittill_notify_or_timeout( "arena_defend_intro_open_door", 30 ); // notify comes from xanim 'pb_ram_05_01_block_1st_rip_player' notetrack
	
	level.allowbattlechatter["bc"] = true;
	
	mobile_wall_deploy_skipto( true );  // mobile wall fully deployed, doors open
}

function intro_done( str_objective, b_starting, b_direct, player )
{
	if ( b_direct )
	{
		level scene::skipto_end( "cin_ram_05_01_block_1st_rip_skipto" );
	}
}

function main( str_objective, b_starting )
{
	init_common_scripted_elements( str_objective, b_starting );
	
	ambient_spawns_start();	
	set_up_gameplay_borders();	
	setup_sinkhole_weak_points();
	ramses_util::enable_nodes( "arena_defend_dynamic_covernodes", "script_noteworthy", false );	
	
	level flag::set( "arena_defend_spawn" );
	
	level thread objectives();
	level thread vo_spike_launched_enemy_tracker();
	level thread hunter_crash_fx_anims();
	level thread wait_for_door_close();
	
	if ( ramses_util::is_demo() )
	{
		level thread demo_rocket_wasp_spawning();
	}
	
	if ( b_starting )
	{
		level thread setup_intro_scenes_for_skipto();
		
		mobile_wall_deploy_skipto();
		
		level clientfield::set( "arena_defend_mobile_wall_destroyed_swap", 1 );
		level thread show_mobile_wall_building_impact( true );
		level thread show_mobile_wall_sidewalk_impact( true );
		
		level flag::wait_till( "arena_defend_mobile_wall_deployed" );
		
		playsoundatposition( "mus_ramses_jeep_drive_in_short", (0,0,0) );
	}
	
	friendlies_take_cover_behind_mobile_wall();
	
	enemies_spawn_in_checkpoint_area();
	
	players_destroy_weak_points_in_arena(); 
	
	enemies_overrun_checkpoint_area();
	
	friendlies_fall_back_behind_mobile_wall( false );
	
	wait_till_players_are_behind_mobile_wall();
	
	scene_friendly_detonation_guy_killed();
	
	players_detonate_charges_from_mobile_wall();
	
	friendly_soldiers_celebrate_sinkhole_destruction();
	
	kill_spawn_manager_group( "arena_defend_spawn_manager_friendly" );
	
	if ( ramses_util::is_demo() )
	{
		wait 0.25; //wait a little bit for previous scene to cleanup now that fadeout blocker isn't here
		
		ramses_util::delete_all_non_hero_ai();
		
		ramses_util::prepare_players_for_demo_warp();
	}
	
	level.a_e_veh_targets = undefined;
	skipto::objective_completed( "arena_defend" );
}

function demo_rocket_wasp_spawning() 
{
	//demo only secret for spawning a rocket wasp on demand
	//just shoot at the top part of the disabled quadtank on the flatbed
	//a rocket wasp will spawn, fly over the wall, and hover above the disabled quad tank 
	
	level endon( "sinkhole_charges_detonated" );
	
	while ( true )
	{
		trigger::wait_till( "trig_demo_rocket_wasp" );
		
		ai_wasp = spawner::simple_spawn_single( "demo_rocket_wasp" , &demo_rocket_wasp_behavior );
		
		ai_wasp waittill( "death" );
		
		wait 1; //wait before allowing further spawns
	}
}

function demo_rocket_wasp_behavior() 
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	nd_wasp_path = GetVehicleNode( "demo_rocket_wasp_path" , "targetname" );
	
	self vehicle_ai::start_scripted();
	self vehicle::get_on_and_go_path( nd_wasp_path );
	
	self util::waittill_any_timeout( 6, "reached_end_node" );
	
	self SetGoal( self.origin - (0,0,100) , false , 50 , 150 );
	
	self vehicle_ai::stop_scripted( "combat" );
}

function init_common_scripted_elements( str_objectives, b_starting )
{
	if ( !level flag::get( "arena_defend_common_elements_initialized" ) )
	{
		add_spawn_functions();
		setup_ambient_elements();
		vtol_igc::hide_skipto_items();	
		
		setup_scenes();
		init_scenes();
		
		setup_heroes( str_objectives, b_starting );
		
		level flag::set( "arena_defend_common_elements_initialized" );
		
		// add hero redshirts to make solo games a bit easier
		spawner::add_global_spawn_function( "allies", &hero_redshirt_think );
		
		callback::on_spawned( &remove_redshirt_hero_on_player_count_change );
		
		util::array_func( GetEntArray( "weak_point_trigger" , "script_noteworthy" ) , &Hide );
	}
}

function done( str_objective, b_starting, b_direct, player )
{
	if( b_starting )
	{
		level flag::set( "sinkhole_charges_detonated" );
		objectives::complete( "cp_level_ramses_destroy_weakpoints" );
		objectives::complete( "cp_level_ramses_detonate_street_charges" );
		
		arena_defend::cleanup_wall();	
		
		level thread arena_defend::sinkhole_fxanim_hide_everything_in_street( true );  // delete street collision also
	}
	
	objectives::complete( "cp_level_ramses_defend_checkpoint" );
	objectives::set( "cp_level_ramses_reinforce_safiya" );
	
	if ( b_direct && !ramses_util::is_demo() )
	{
		wall_fxanim_scene( false, false );  // put up mobile wall, doors closed
	}
	
	remove_out_of_bounds_trigger_in_alley_building();
	
	if ( level flag::get( "arena_defend_common_elements_initialized" ) ) 
	{
		spawner::remove_global_spawn_function( "allies", &hero_redshirt_think );
		callback::remove_on_spawned( &remove_redshirt_hero_on_player_count_change );
	}
}

function setup_heroes( str_objective, b_starting )
{
	init_heroes( str_objective, b_starting );
	
	level.ai_khalil colors::set_force_color( "y" );
	level.ai_khalil.goalradius = 1024;  // reduce Khalil's tendency to run all over the place
	
	level.ai_hendricks colors::set_force_color( "b" );
}

function init_flags()
{
	// Init flags
	// "script_flag_set"/"arena_defend_detonation_zone_reached"
	// "script_flag_set"/"arena_defend_enemy_fallback"
	// "script_flag_set"/"arena_defend_start_waves"
	// "script_flag_set"/"arena_defend_wall_open"
	// "script_flag_set"/"arena_defend_wall_first_open"
	// "script_flag_set"/"arena_defend_start_battle"
	// "script_flag_set"/"arena_defend_wasp_shoot_vign_play"
	// "script_flag_set_on_cleared"/"arena_defend_cleanup"
	// "script_flag_set_on_cleared"/"arena_defend_wall_close"
	// "script_flag_true"/"all_weak_points_destroyed"
	// "script_flag_true"/"arena_defend_detonator_ready"
	// "script_flag_true"/"arena_defend_spawn"
	level flag::init( "all_spike_launchers_picked_up" );
	level flag::init( "billboard1_crashed" );
	level flag::init( "sinkhole_explosion_started" );
	level flag::init( "sinkhole_collapse_complete" );
	level flag::init( "intro_technical_dropped_from_vtol" );
	level flag::init( "arena_defend_mobile_wall_deployed" );
	level flag::init( "arena_defend_mobile_wall_doors_open" );
	level flag::init( "arena_defend_intro_technical_disabled" );
	level flag::init( "arena_defend_second_wave_weak_points_discovered" );
	level flag::init( "arena_defend_third_wave_weak_points_discovered" );
	level flag::init( "arena_defend_last_wave_weak_points_discovered" );
	level flag::init( "arena_defend_common_elements_initialized" );
	level flag::init( "arena_defend_sinkhole_igc_started" );
	level flag::init( "arena_defend_detonator_dropped" );
	level flag::init( "arena_defend_sinkhole_collapse_done" );
	level flag::init( "arena_defend_rocket_hits_vtol" );
}

function init_heroes( str_objective, b_starting )
{
	if( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
	}
	skipto::teleport_ai( str_objective, level.heroes ); // TODO: animations
	
	if ( IsDefined( level.ai_hendricks ) )
	{
		level.ai_hendricks colors::enable();
	}
	
	if ( IsDefined( level.ai_khalil ) )
	{
		level.ai_khalil colors::disable();
	}
}

function setup_ambient_elements()
{
	level flag::set( "flak_vtol_ride_stop" );  // this stops vtol ride flak exploders
	level thread ramses_util::arena_defend_flak_exploders();
	
	level thread ramses_util::delete_all_dead_turrets();	
	
	level thread ramses_util::arena_defend_sinkhole_exploders();
}

function add_spawn_functions()
{
	// AI
	spawner::add_spawn_function_group( "arena_defend_splined_entry", "script_noteworthy", &arena_defend_vehicle_ai_spawnfunc );
	spawner::add_spawn_function_group( "arena_defend_initial_enemies", "targetname", &enemies_move_up_after_mobile_wall_opens );
	spawner::add_spawn_function_group( "arena_defend_wall_jumper", "script_noteworthy", &arena_defend_wall_jumper_spawnfunc );
	
	//keep guys at beginning behind wall
	spawner::add_spawn_function_group( "arena_defend_cafe_defender_guys", "targetname", &arena_defend_wall_allies_spawnfunc );
	spawner::add_spawn_function_group( "arena_defend_intro_wall_ally", "script_noteworthy", &arena_defend_wall_allies_spawnfunc );
	spawner::add_spawn_function_group( "arena_defend_reset_anchor", "script_noteworthy", &arena_defend_wall_allies_spawnfunc );
	
	//use this for tracking spike launcher hitting enemies
	level.W_SPIKE_LAUNCHER = GetWeapon( "spike_launcher" );
	
	//add thread to monitor spike launcher damage on the majority of enemies.
	
	// set up weak point defenders: these are wp_01 to wp_05
	for ( i = 1; i < 6; i++ )
	{
		spawner::add_spawn_function_group( "wp_0" + i + "_defenders", "targetname", &spawn_func_weak_point_defenders, "wp_0" + i + "_destroyed" );
		spawner::add_spawn_function_group( "wp_0" + i + "_defenders", "targetname", &spike_launcher_damage_watcher );
	}
	
	
	spawner::add_spawn_function_group( "arena_defend_first_push_guys", "targetname", &spike_launcher_damage_watcher );
	spawner::add_spawn_function_group( "arena_defend_fill_guy", "targetname", &spike_launcher_damage_watcher );
	spawner::add_spawn_function_group( "arena_defend_checkpoint_wall_wave_01_guy", "targetname", &spike_launcher_damage_watcher );

	spawner::add_spawn_function_group( "arena_defend_initial_enemies", "script_noteworthy", &spike_launcher_damage_watcher );
	spawner::add_spawn_function_group( "arena_defend_wall_jumper", "script_noteworthy", &spike_launcher_damage_watcher );
	
	// vehicles
	vehicle::add_spawn_function( "arena_defend_quadtank", &quadtank_think );
	vehicle::add_spawn_function( "arena_defend_wall_vtol", &wall_vtol_think );
	vehicle::add_spawn_function( "arena_defend_mobile_wall_turret", &wall_turret_think );
	vehicle::add_spawn_function( "arena_defend_intro_technical", &spawn_func_intro_technical, "arena_defend_intro_technical_disabled" );
	vehicle::add_spawn_function( "arena_defend_intro_technical", &cinematic_crew_unload_on_level_notify, "cin_ram_05_01_defend_aie_nrc_exittruck_variation1", "arena_defend_mobile_wall_doors_open" );
	vehicle::add_spawn_function( "arena_defend_intro_technical", &warp_to_spline_end );
	vehicle::add_spawn_function( "arena_defend_intro_technical", &set_invulnerable_until_spline_end );
	vehicle::add_spawn_function( "arena_defend_technical_01", &cinematic_crew_unload_at_spline_end, "cin_ram_05_01_defend_aie_nrc_exittruck_variation2" );
	vehicle::add_spawn_function( "arena_defend_technical_02", &cinematic_crew_unload_at_spline_end, "cin_ram_05_01_defend_aie_nrc_exittruck_variation1" );
	
	foreach ( sp_technical in GetEntArray( "arena_defend_technical", "script_noteworthy" ) )
	{
		vehicle::add_spawn_function( sp_technical.targetname, &technical_think );	
		vehicle::add_spawn_function( sp_technical.targetname, &technical_nodes_think );
		
		ramses_util::enable_nodes( sp_technical.targetname + "_vh_end", "targetname", false );  // disable nodes for technicals at start
	}
	
	e_wasp_goal_volume = GetEnt( "arena_defend_wasp_goal_volume", "targetname" );
	foreach ( sp_wasp in GetEntArray( "arena_defend_wasp", "script_noteworthy" ) )
	{
		vehicle::add_spawn_function( sp_wasp.targetname, &wasp_think, e_wasp_goal_volume );
	}
}

// Spawn Functions
////////////////////////////////////////////////////////////////////

// Self is AI
function arena_defend_spawnfunc()
{

}

// Self is AI
function arena_defend_wall_allies_spawnfunc()
{
	self endon( "death" );
	
	if ( !level flag::get( "arena_defend_mobile_wall_doors_open" ) )
	{
		self SetGoal( GetEnt( "sinkhole_friendly_fallback_volume", "targetname" ), true ); //stay behind wall at first
	}
	
	//wait for door to open before trying to run out
	level flag::wait_till( "arena_defend_mobile_wall_doors_open" );
	
	self ClearForcedGoal();
	
	if ( isdefined( self.target ) )
	{
		e_goal = GetEnt( self.target, "targetname" );
		self SetGoal( e_goal );
	}
	else
	{
		self SetGoal( GetEnt( "arena_defend_main_goal_volume" , "targetname" ) ); //most spawners had no target set so I'm adding this to get AI out into the battle - Dan C
	}
}

// Self is Vehicle AI
// Starts scripted via KvP: "script_startstate"/"scripted"
function arena_defend_vehicle_ai_spawnfunc()
{
	self endon( "death" );
	
	wait 0.1;  // slight delay so vehicles don't spawn in and fall through the map
	
	Assert( IsDefined( self.target ), "Vehicle AI " + self.targetname + " at " + self.origin + " is missing 'target' KVP! This determines the vehicle path." );
	
	vnd_start = GetVehicleNode( self.target, "targetname" );
	
	Assert( IsDefined( vnd_start ), "Vehicle AI " + self.targetname + " at " + self.origin + " must target a vehicle spline start node to move." );
	
	//TODO revisit after DPS, don't want raps to follow spline for now and to stay in AI
	//raps in Arena Defend after destroying weakpoints are the only enemies affected by this in the level currently
	//self vehicle::get_on_and_go_path( vnd_start );
	
	if( IsDefined( self.script_string ) )
	{
		t_goal = GetEnt( self.script_string, "targetname" );
	}
	
	if( IsDefined( t_goal ) )
	{
		self SetGoal( t_goal );
	}
	
	self vehicle_ai::stop_scripted( "combat" );
}

function spawn_func_weak_point_defenders( str_flag ) // self = AI
{
	self endon( "death" );
	
	level flag::wait_till( str_flag );  // this will be 'wp_0X_destroyed', which is set when a weak point is destroyed
	
	wait RandomFloatRange( 2, 8 );  // wait a bit so guys don't all run off immediately
	
	self.goalradius = 1024;  // reset goal radius since we don't care about these guys position as much now
	
	self ClearGoalVolume(); 
}

function enemies_move_up_after_mobile_wall_opens()  // self = AI
{
	self endon( "death" );

	// in Radiant, these guys have an assigned goal volume that's mid-way through the checkpoint defend
	
	level flag::wait_till( "arena_defend_mobile_wall_doors_open" );
	
	wait RandomFloatRange( 2, 3 );  // stagger this a bit so players aren't immediately overwhelmed
	
	//TODO no longer clear goal volume here, may look into other actions for initial AI after the door opens
}

function quadtank_think() //self = quadtank
{
	self endon( "death" );
	
	monitor_vehicle_targets(); //gets the dummy targets to fire at
	
	waittillframeend;
	
	self ai::set_ignoreall( true );
	
	self quadtank::quadtank_weakpoint_display( false );  // this quad tank is only meant for background, not engagement
	
	const n_missiles = 4;
	
	while( !level flag::get( "sinkhole_charges_detonated" ) )
	{
		wait RandomFloatRange( 6, 8 );
		
	  	e_player = util::get_closest_player( self.origin , "allies" ); //get player closest to quad tank, i.e., the player pushed furthest ahead
	  	
	  	//TODO post-demo, pick target points centered around the player/players and try to find ways to make the missiles land within the player field of view
	  	a_targets = array::get_all_closest( e_player.origin , level.a_e_veh_targets , undefined , n_missiles ); //get nearest targets and randomize
	  	a_targets = array::randomize( a_targets );
		  	
		for ( i = 0 ; i < n_missiles ; i++ )
		{
			self _tank_fire_javelin( a_targets[i] );
		}
	}
	
	// move quad tank out of viewable space (towards QT plaza) then delete it
	nd_exit = GetNode( "arena_defend_outro_push_guys_exit", "targetname" );
	
	self SetGoal( nd_exit, true );
	self.goalradius = 250;
	
	self util::waittill_notify_or_timeout( "goal", 15 );
	
	self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
}

// Self is quad tank
function _tank_fire_javelin( e_target )
{
	self endon( "death" );

	weapon = GetWeapon( "quadtank_main_turret_rocketpods_javelin" );
	
	v_offset = (0,0,300); //offset of missile launch from tank origin //TODO make this fire from a tag on the tank in the correct spot
	
	MagicBullet( weapon , self.origin + v_offset , e_target.origin , self , e_target );
	
//	/#self thread draw_line_to_target( e_target, 2 );#/
	
	wait .65; //delay between missiles
}

function cinematic_crew_unload_at_spline_end( str_scene )  // self = vehicle
{
	self endon( "death" );
	
	a_ents = spawner::simple_spawn( "cinematic_technical_riders" );
	if ( !isdefined( a_ents ) ) a_ents = []; else if ( !IsArray( a_ents ) ) a_ents = array( a_ents ); a_ents[a_ents.size]=self;;
	
	//keep them from being murdered by friendlies until they get out the car
	//notetrack is a self notify on the AI in cin_ram_05_01_defend_aie_nrc_exittruck_variation* animations
	array_ignore_me_until_notify( a_ents, "stop_ignoring_me" );

	if (self.targetname == "arena_defend_technical_01_vh")
	{
		self playsound ("evt_tech_driveup_1");
		
		level thread vo_first_technical_drive_up();
		level notify( "first_turret_guy_vulnerable" );
	}
	
	if (self.targetname == "arena_defend_technical_02_vh")
	{
		self playsound ("evt_tech_driveup_2");
		level notify( "first_turret_guy_vulnerable" );
	}
	
	self thread scene::init( str_scene, a_ents );  // this will play looping anim
	
	self waittill( "reached_end_node" );
	
	a_ents = filter_invalid_ents_for_scene( a_ents );
	
	self thread scene::play( str_scene, a_ents );  // play cinematic 'get out' animation
}

function cinematic_crew_unload_on_level_notify( str_scene, str_notify )  // self = vehicle
{
	self endon( "death" );
	
	a_ents = spawner::simple_spawn( "cinematic_technical_riders" );	
	if ( !isdefined( a_ents ) ) a_ents = []; else if ( !IsArray( a_ents ) ) a_ents = array( a_ents ); a_ents[a_ents.size]=self;;
	
	//keep them from being murdered by friendlies until they get out the car
	//notetrack is a self notify on the AI in cin_ram_05_01_defend_aie_nrc_exittruck_variation* animations
	array_ignore_me_until_notify( a_ents, "stop_ignoring_me" );
	
	self thread scene::init( str_scene, a_ents );  // this will play looping anim
	
	level waittill( str_notify );
	
	a_ents = filter_invalid_ents_for_scene( a_ents );
	
	self thread scene::play( str_scene, a_ents );  // play cinematic 'get out' animation
}

//searches through an array of AI, and have them get ignored until a notify is sent to the AI
function array_ignore_me_until_notify( a_ai, str_notify )
{
	foreach ( ai in a_ai )
	{
		if ( IsAI( ai ) )
		{
			ai thread ignore_me_until_notify( str_notify );
		}
	}
}

//self is an AI
function ignore_me_until_notify( str_notify )
{
	self endon ( "death" );
	
	self ai::set_ignoreme( true );
	
	self waittill( str_notify );
	
	self ai::set_ignoreme( false );
}

function filter_invalid_ents_for_scene( a_ents )
{
	a_ents_filtered = ArrayCopy( a_ents );
	
	foreach ( ai in a_ents )
	{
		if ( IsAI( ai ) )  // can also be a vehicle/prop
		{
			if ( !IsAlive( ai ) || ai IsRagdoll() )
			{
				ArrayRemoveValue( a_ents_filtered, ai, false );
			}
		}
	}	
	
	return a_ents_filtered;
}

function vehicle_go_path_on_level_notify( str_notify )  // self = vehicle
{
	self endon( "death" );
	self endon( "warp_to_spline_end" );
	
	Assert( IsDefined( self.target ), "vehicle at " + self.origin + " using vehicle_go_path_on_level_notify() is not targeting a vehicle node!" );
	
	level waittill( str_notify );
	
	self thread vehicle::get_on_and_go_path( self.target );
}

// this function is used to make sure animated technicals are guaranteed to get to their end goal before dying
function set_invulnerable_until_spline_end()  // self = vehicle
{
	self endon( "death" );  // in case script deletes this somehow
	
	self SetCanDamage( false );
	
	self waittill( "reached_end_node" );
	
	self SetCanDamage( true );
}

function warp_to_spline_end()  // self = vehicle
{
	self endon( "death" );
	
	wait 0.1;  // slight delay so vehicles don't spawn in and fall through the map (ground is made of script_brushmodels)
	
	self notify( "warp_to_spline_end" );
	
	nd_target = GetVehicleNode( self.target, "targetname" );
	
	while ( IsDefined( nd_target.target ) )
	{
		nd_target = GetVehicleNode( nd_target.target, "targetname" );
	}
	
	// found end node, warp to it
	self.origin = nd_target.origin;
	self.angles = nd_target.angles;
	
	self notify( "reached_end_node" );  // fake pathing so animations play correctly
}

function hero_redshirt_think()  // self = AI
{
	self endon( "death" );
	self endon( "demote_hero" );
	
	if(!isdefined(level.arena_defend_redshirt_hero))level.arena_defend_redshirt_hero=[];
	
	n_hero_count_max = get_hero_redshirt_count();
	
	b_should_be_hero = ( ( n_hero_count_max > level.arena_defend_redshirt_hero.size ) && self is_redshirt_correct_color_group() && !self util::is_hero() );
	
	if ( b_should_be_hero )
	{
		if ( !isdefined( level.arena_defend_redshirt_hero ) ) level.arena_defend_redshirt_hero = []; else if ( !IsArray( level.arena_defend_redshirt_hero ) ) level.arena_defend_redshirt_hero = array( level.arena_defend_redshirt_hero ); level.arena_defend_redshirt_hero[level.arena_defend_redshirt_hero.size]=self;;
		
		self util::magic_bullet_shield( self );
		
		level waittill( "sinkhole_charges_detonated" );
		
		ArrayRemoveValue( level.arena_defend_redshirt_hero, self, false );
		
		self util::stop_magic_bullet_shield( self );
	}
}

function get_hero_redshirt_count()
{
	n_hero_count_max = ( 5 - level.players.size );  // solo = 4 redshirt heroes, 4 player = 1 redshirt hero
	
	return n_hero_count_max; 
}

function is_redshirt_hero()  // self = AI
{
	return ( IsDefined( level.arena_defend_redshirt_hero ) && IsInArray( level.arena_defend_redshirt_hero, self ) );
}

function is_redshirt_correct_color_group()
{	
	if ( !self colors::has_color() )
	{
		b_correct_group = false;
	}
	else 
	{
		str_my_color = self.script_forcecolor;
		
		// want 1:1 ratio of blue and yellow color groups
		n_guys_max = get_hero_redshirt_count();
		
		n_blue_max = Ceil( n_guys_max / 2 );  // use ceiling so this always returns non-zero when ( n_guys_max > 1 )
		n_yellow_max = ( n_guys_max - n_blue_max );  // favor blue guys in case of tie
		
		n_blue = 0;
		n_yellow = 0;
		
		foreach ( ai_guy in level.arena_defend_redshirt_hero )
		{
			if ( isdefined( ai_guy ) )
			{
				if ( ai_guy.script_forcecolor == "b" )
				{
					n_blue++;
				}
				else if ( ai_guy.script_forcecolor == "y" )
				{
					n_yellow++;
				}
			}
		}	

		if ( ( n_blue < n_blue_max ) && ( str_my_color == "b" ) )
		{
			b_correct_group = true;
		}
		else if ( ( n_yellow < n_yellow_max ) && ( str_my_color == "y" ) )
		{
			b_correct_group = true;
		}
		else 
		{
			b_correct_group = false;
		}
	}
	
	return b_correct_group;
}

function remove_redshirt_hero_on_player_count_change()  // self = player
{
	if(!isdefined(level.arena_defend_redshirt_hero))level.arena_defend_redshirt_hero=[];
	
	n_hero_count_max = get_hero_redshirt_count();
	
	if ( level.arena_defend_redshirt_hero.size > n_hero_count_max )
	{
		ai_guy = array::random( level.arena_defend_redshirt_hero );
		
		ArrayRemoveValue( level.arena_defend_redshirt_hero, ai_guy, false );
		
		ai_guy util::stop_magic_bullet_shield( ai_guy );
	}
}

function spawn_func_intro_technical( str_flag )  // self = vehicle
{
	self endon( "death" );
	
	//in case vehicle dies, set the flag as well
	self thread set_level_flag_on_death( str_flag );
	
	while ( !self flag::exists( "spawned_gunner" ) )
	{
		wait 1;  // flag initialized in another thread
	}
	
	self flag::wait_till( "spawned_gunner" );
	
	ai_rider = self vehicle::get_rider( "gunner1" );
	ai_rider ai::set_ignoreme( true ); //don't want him to get shot too early
	
	if ( IsDefined( ai_rider ) )
	{
		ai_rider waittill( "death" );
	}
	
	wait 8; //keep the rush to weakpoint 1 from happening too soon
	
	level flag::set( str_flag );
}

function set_level_flag_on_death( str_flag )  // self = entity
{
	self waittill( "death" );
	
	level flag::set( str_flag );
}

function wasp_think( e_goal_volume )  // self = vehicle
{
	self endon( "death" );
	
	if ( IsDefined( e_goal_volume ) )
	{
		self SetGoal( e_goal_volume );
	}
}

// Self is vehicle
function technical_think()
{
	self endon( "death" );

	self SetDrivePathPhysicsScale( 3.0 );  // this makes the technical follow the spline more closely while staying in DrivePath - predictable end locations are important!
	
	self thread allow_vehicle_to_fall_after_sinkhole_collapse();
	
	self flag::init( "spawned_gunner" );
	self flag::init( "gunner_position_occupied" );
	
	ai_gunner = self spawn_turret_gunner();
	//ai_driver = self spawn_technical_driver(); TODO uncomment ai_driver lines in this function once door open animations are working
	
	ai_gunner thread _kill_on_vehicle_death( self );
	ai_gunner thread turret_disable_on_vehicle_death( self );
	
	//ai_driver thread _kill_on_vehicle_death( self );
	
	self thread kill_vehicle_on_scene_play();
	self thread gunner_position_think();
	
	if ( IsDefined( self.target ) )
	{
		self waittill( "reached_end_node" );
		v_end_pos = self.origin;
		v_end_angles = self.angles;
		
		level notify( self.targetname + "_reached_end_node" );
		
//		if ( IsAlive( ai_driver ) )
//		{
//			ai_driver vehicle::get_out();
//		}
	}

	self vehicle::get_off_path();
	ramses_util::enable_nodes( self.targetname + "_covernode", "targetname" );
	
	self waittill( "death" ); // TODO: is there a way for the vehicle corpse to stay in the last frame position of the fxanim if it isn't dead when it animates?
	self.origin = v_end_pos;
	self.angles = v_end_angles;
}

function technical_nodes_think()  // self = vehicle
{
	self endon( "death" );
	
	// if vehicle reaches the end of its spline, enable the nodes associated with it
	self waittill( "reached_end_node" );
	
	ramses_util::enable_nodes( self.targetname + "_end", "targetname", true );  
}

function allow_vehicle_to_fall_after_sinkhole_collapse() // self = vehicle
{
	self.no_free_on_death = true;  // this prevents vehicle from being freed up so it can fall when the street collapses
	
	level waittill( "sinkhole_vehicle_fall" );
	
	if( IsDefined( self ) )
	{		
		wait 3; //approximate time the vehicle falls after the sinkhole animation starts TODO find a better notetrack to use
		
		//give vehicle a slight force to wake it up and drop into the hole
		self LaunchVehicle( (0, 0, 100) );
		
		//call again in case there are any other dynents formed by the explosion itself
		level clientfield::increment( "clear_all_dyn_ents", 1 );
	}
}

function gunner_position_think( b_find_new_gunner = false ) // self = vehicle
{
	self endon( "death" );
	
	const GUNNER_CHECK_TIME_MIN = 5;
	const GUNNER_CHECK_TIME_MAX = 8;
	
	// set burst fire parameters
	const FIRE_TIME_MIN = 1.0;
	const FIRE_TIME_MAX = 2.0;
	const FIRE_WAIT_MIN = 0.25;
	const FIRE_WAIT_MAX = 0.75;
	
	self turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, FIRE_WAIT_MIN, FIRE_WAIT_MAX, 1 );
	
	while ( true )
	{		
		ai_gunner = self vehicle::get_rider( "gunner1" );
		ai_gunner thread ramses_util::magic_bullet_shield_till_notify( "first_turret_guy_vulnerable", true );
		
		if ( IsDefined( ai_gunner ) )
		{			
			self turret::enable( 1, true );
			
			self flag::set( "gunner_position_occupied" );
			
			ai_gunner waittill( "death" );  // TODO: add check on turret exit, if we ever want that
		}
		
		self turret::disable( 1 );
		self flag::clear( "gunner_position_occupied" );
		
		if ( b_find_new_gunner )
		{
			wait RandomFloatRange( GUNNER_CHECK_TIME_MIN, GUNNER_CHECK_TIME_MAX );
			
			if ( self gunner_position_is_safe() )
			{
				ai_gunner_next = self find_new_gunner();
			
				if ( IsAlive( ai_gunner_next ) )
				{
					/# ai_gunner_next thread debug_run_to_gunner_position( self ); #/
					
					ai_gunner_next thread vehicle::get_in( self, "gunner1", false );  // gunner runs to turret
					
					ai_gunner_next util::waittill_any( "death", "in_vehicle" );  // 'in_vehicle' sent from vehicleriders_shared.gsc
				}
			}
		}
		else
		{
			break;
		}
	}
}

function find_new_gunner()  // self = vehicle
{
	const GUNNER_CHECK_RADIUS_MAX = 800;
	
	a_ai = GetAITeamArray( self.team );
	a_valid = [];
	
	foreach ( ai_guy in a_ai )
	{
		if ( !IsDefined( ai_guy.vehicle ) && ( ai_guy.archetype === "human" ) )  // check to see if this guy's in a vehicle already, or is a vehicle, or a robot...
		{
			if ( !isdefined( a_valid ) ) a_valid = []; else if ( !IsArray( a_valid ) ) a_valid = array( a_valid ); a_valid[a_valid.size]=ai_guy;;
		}
	}
	
	ai_gunner = ArraySort( a_valid, self.origin, true, a_ai.size, GUNNER_CHECK_RADIUS_MAX )[ 0 ];
	
	return ai_gunner;
}

function gunner_position_is_safe() // self = vehicle
{
	const RADIUS_DANGER_ZONE = 300;
	
	// are there enemies close by? if yes, don't try to use turret
	a_enemies = GetAITeamArray( get_enemy_team( self.team ) );
	a_enemies_nearby = ArraySort( a_enemies, self.origin, true, a_enemies.size, RADIUS_DANGER_ZONE );
	
	b_enemies_in_range = ( a_enemies_nearby.size > 0 );
	
	// TODO: maybe add in logic to see if there would be valid targets when using this turret
	
	b_is_safe = !b_enemies_in_range;
	
	return b_is_safe;
}

function get_enemy_team( str_team )
{
	if ( str_team == "axis" )
	{
		str_enemy_team = "allies";
	}
	else if ( str_team == "allies" )
	{
		str_enemy_team = "axis";
	}
	else 
	{
		AssertMsg( "get_enemy_team found invalid team '" + str_team + "'!" );
		str_enemy_team = "none";
	}
	
	return str_enemy_team;
}

// show that a guy's been claimed and he's running 
function debug_run_to_gunner_position( vehicle )  // self = AI
{
	self endon( "death" );
	self endon( "in_vehicle" );
	vehicle endon( "death" );
	
	while ( true )
	{
		/#
			Line( self.origin, vehicle.origin, ( 1, 0, 0 ), 1, false, 1 );
		#/
		
		wait 0.05;
	}
}

// Self is Vehicle
function kill_vehicle_on_scene_play()
{
	self endon( "death" );
	
	self waittill( "kill_passengers" );
	self Kill();
}

// Self is AI
function turret_disable_on_vehicle_death( vh_technical )
{
	self waittill( "death" );
	
	if( IsDefined( self ) ) // Catch case where he is deleted - when using debug
	{
		self Unlink();
	}
	
	
	if (!vehicle::is_corpse(vh_technical))
	{
		vh_technical turret::disable( 1 );
	}
}
// Self is AI
function _kill_on_vehicle_death( vh_technical )
{
	self endon( "death" );
	
	vh_technical util::waittill_either( "death", "kill_passengers" );
	
	self util::stop_magic_bullet_shield();
	
	self Unlink();
	self Kill();
}

// Self is vehicle
// HACK: fake gunner doesn't aim properly
function spawn_turret_gunner()
{
	ai_gunner = spawner::simple_spawn_single( "arena_defend_technical_gunner_generic" );

	ai_gunner vehicle::get_in( self, "gunner1", true );  // teleport AI to gunner position
	ai_gunner ai::set_ignoreme( true );  // only let players shoot at these guys
	
	self flag::set( "spawned_gunner" );
	
	return ai_gunner;
}

//self is vehicle
function spawn_technical_driver()
{
	ai_driver = spawner::simple_spawn_single( "arena_defend_technical_driver_generic" );
	
	ai_driver vehicle::get_in( self, "driver", true );
	
	return ai_driver;
}

function wall_vtol_think()
{
	vnd_start = GetVehicleNode( self.target, "targetname" );
	
	vehicle::get_on_and_go_path( vnd_start );
}

function wall_turret_think()  // self = vehicle
{
	self.team = "allies";  // BUG: script_team isn't getting picked up by script, so set it here
}

// Wall Defend
////////////////////////////////////////////////////////////////////
function friendlies_take_cover_behind_mobile_wall()
{
	trigger::use( "arena_defend_colors_allies_behind_mobile_wall" );
}	

function friendlies_move_to_position( str_trigger_suffix )
{
	trigger::use( "arena_defend_color_allies_" + str_trigger_suffix );
}

function friendlies_move_to_wp_02_03()
{
	friendlies_move_to_position( "wp_02_03" );
}

function friendlies_move_to_final_street_position()
{
	friendlies_move_to_position( "wp_04" );
	
	level thread hendricks_robot_melee();
}

function hendricks_robot_melee()
{
	level scene::init( "cin_gen_melee_hendricksmoment_closecombat_robot" );  // scene played from within 'init' callback
}

function vignette_egyptian_soldiers_killed_by_wasps()  // self = level
{
	// get some guys up to the scaffold
	a_nodes_on_scaffold = GetNodeArray( "arena_defend_wasp_vignette_nodes", "script_noteworthy" );
	Assert( a_nodes_on_scaffold.size, "vignette_egyptian_soldiers_killed_by_wasps: couldn't find nodes for egyptian soldiers!" );
	
	n_guys_required = a_nodes_on_scaffold.size;  // one guy per node
	
	//try to use fresh guys for this vignette since they're guaranteed to be closer positioned
	a_scaffold_guys = [];
	for( i = 0; i < a_nodes_on_scaffold.size; i++ )
	{
		ai_guy = spawner::simple_spawn_single( "arena_defend_wasp_vignette_friendly" );
		if ( !isdefined( a_scaffold_guys ) ) a_scaffold_guys = []; else if ( !IsArray( a_scaffold_guys ) ) a_scaffold_guys = array( a_scaffold_guys ); a_scaffold_guys[a_scaffold_guys.size]=ai_guy;;
		ai_guy ai::set_ignoreme( true );
		
		wait 1; //stagger spawns
	}
	
	//if we couldn't get enough, then just grab from the existing AI
	while ( a_scaffold_guys.size != a_nodes_on_scaffold.size )
	{
		wait 1; // add a delay here in case script can't find enough guys
		
		a_friendlies = GetAISpeciesArray( "allies", "human" );
		
		a_friendlies = ArraySortClosest( a_friendlies, a_nodes_on_scaffold[ 0 ].origin, a_friendlies.size );		
		
		a_scaffold_guys = [];
		
		foreach ( ai_guy in a_friendlies )
		{
			b_guy_is_valid = ( !ai_guy util::is_hero() && !ai_guy is_redshirt_hero() && !ai_guy IsInScriptedState() );
			
			if ( b_guy_is_valid )
			{
				if ( !isdefined( a_scaffold_guys ) ) a_scaffold_guys = []; else if ( !IsArray( a_scaffold_guys ) ) a_scaffold_guys = array( a_scaffold_guys ); a_scaffold_guys[a_scaffold_guys.size]=ai_guy;;
				ai_guy ai::set_ignoreme( true );
			}
			
			if ( a_scaffold_guys.size == n_guys_required ) 
			{
				break;  // out of foreach 
			}
		}
	}
	
	// send each guy to node
	for ( i = 0; i < a_scaffold_guys.size; i++ )
	{
		if ( IsAlive( a_scaffold_guys[i] ) )
		{
			a_scaffold_guys[ i ].goalradius = 64;
			a_scaffold_guys[ i ] thread ai::force_goal( a_nodes_on_scaffold[ i ], 64, false, "goal", false, true );
			self thread notify_self_on_goal( a_scaffold_guys[ i ] );
		}
	}
	
	// wait until all the guys are at their nodes
	n_guys_at_goal = 0;
	
	do 
	{
		self waittill( "arena_defend_wasp_vignette_guy_at_goal" );
		
		n_guys_at_goal++;
	}
	while ( n_guys_at_goal < a_scaffold_guys.size );
	
	wait_for_player_to_look_at_scaffold();
	
	// allow guys to die to wasps
	foreach ( ai_guy in a_scaffold_guys )
	{
		if ( IsAlive( ai_guy ) )
		{
			ai_guy ai::set_ignoreme( false );
		}
	}
	
	// spawn in wasps
	const WASP_COUNT = 3;
	for ( j = 0; j < WASP_COUNT; j++ )
	{
		vh_wasp = spawner::simple_spawn_single( "arena_defend_vignette_wasp" );
		vh_wasp thread vignette_wasp_think( a_scaffold_guys, j );
		
		wait 0.5;  // space out spawns so wasps don't fly on top of each other
	}
}

function wait_for_player_to_look_at_scaffold()
{
	level endon( "all_weak_points_destroyed" ); 
	
	trigger::wait_till( "arena_defend_wasp_vignette_trigger" );
	
	level thread vo_wasp_and_robot_jumper_entrance();
}

function vignette_wasp_think( a_targets, n_path )  // self = wasp vehicle
{
	self endon( "death" );
	
	const WASP_TARGET_DISTANCE_TO_GOAL = 300;
	
	// wasp focuses on its targets
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	// go after the closest guy and murder him
	self SetNearGoalNotifyDist( WASP_TARGET_DISTANCE_TO_GOAL );
	
	//splines in radiant named arena_defend_wasp_vignette_path0, arena_defend_wasp_vignette_path1, etc.
	e_wasp_path = GetVehicleNode( "arena_defend_wasp_vignette_path"+n_path, "targetname" );
	Assert( isdefined( e_wasp_path ), "arena_defend_wasp_vignette_path"+n_path+" vehicle node does not exist!" );
	
	self vehicle_ai::start_scripted();
	self vehicle::get_on_and_go_path( e_wasp_path );
	
	self util::waittill_any_timeout( 6, "reached_end_node" );
	
	self vehicle_ai::stop_scripted( "combat" );

	foreach ( ai_guy in a_targets )
	{		
		if ( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
		{
			self SetGoal( ai_guy );
			
			ai_guy util::stop_magic_bullet_shield();
			
			// wasp targets and kills target
			if ( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
			{
				ai_guy.health = 1;  // make health really low so wasps can actually win
				
				self thread ai::shoot_at_target( "shoot_until_target_dead", ai_guy );
				
				//kill him at the first sign of damage after being shot at.
				ai_guy util::waittill_any( "death", "pain" );
				
				if ( IsAlive( ai_guy ) )
				{
					ai_guy Kill();					
				}
			}
		}
	}
	
	// make wasp go back to normal 
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	
	arena_defend_wasp_goal_volume = GetEnt( "arena_defend_wasp_goal_volume", "targetname" );
	self SetGoal( arena_defend_wasp_goal_volume, true );
}

function notify_self_on_goal( ai_guy )
{	
	str_message = ai_guy util::waittill_any_timeout( 15, "goal", "near_goal", "death" );
	
	self notify( "arena_defend_wasp_vignette_guy_at_goal" );
}

function send_ai_type_within_radius_to_node( str_type, str_faction, str_node_targetname, n_radius_outer, n_radius_inner = 0 )
{
	// find AI nearby
	nd_goal = GetNode( str_node_targetname, "targetname" );
	
	do 
	{
		a_ai = GetAISpeciesArray( str_faction, str_type );
		a_sorted = ArraySortClosest( a_ai, nd_goal.origin, a_ai.size, n_radius_inner, n_radius_outer );
		
		// filter heroes
		foreach ( ai in a_ai )
		{
			if ( ai util::is_hero() || ai is_redshirt_hero() )
			{
				ArrayRemoveValue( a_sorted, ai, false );
			}
		}
		
		if ( a_sorted.size > 0 )
		{
			ai_guy = a_sorted[ 0 ];
		}
		else 
		{
			wait 1;  // wait a bit before attempting search again
		}
	} 
	while ( !IsDefined( ai_guy ) );	
	
	ai_guy.goalradius = 32;  // make sure AI goes to this specific node
	
	// since we're using this guy for a vignette, try to make him live longer but get to his goal quickly
	ai_guy ai::set_ignoreme( true );
	
	b_shoot = false;
	str_endon = undefined;
	b_keep_colors = false;
	b_should_sprint = true;
	
	ai_guy thread ai::force_goal( nd_goal, 32, b_shoot, str_endon, b_keep_colors, b_should_sprint );
	ai_guy util::waittill_any_timeout( 15, "goal", "death" );

	return ai_guy;
}

function vignette_intro_technical()
{
	vh_technical = vehicle::simple_spawn_single( "arena_defend_intro_technical" );	
	s_scene = struct::get( "arena_defend_intro_technical_kills_door_guys", "targetname" );
	
	// make sure a guy is on here and turret is enabled (this occurs in gunner_position_think() )
	while ( !vh_technical turret::is_turret_enabled( 1 ) )
	{
		wait 0.25;
	}
	
	// pause firing so we can manually control this for intro
	vh_technical turret::disable( 1 );  
	
	level waittill( "arena_defend_intro_player_exits_technical" );  // notify comes from xanim 'pb_ram_05_01_block_1st_rip_player' notetrack
	
	//friendlies rush into doorway and get shot by turret
	level scene::play( "cin_ram_05_02_block_vign_mowed" );
	
	// go back to normal turret behavior
	vh_technical turret::enable( 1, true );
}

function scene_callback_intro_technical_murder( a_ents )
{
	//spawned in vignette_intro_technical
	vh_technical = GetEnt( "arena_defend_intro_technical_vh", "targetname" );
	e_turret_target = GetEnt( "so_arena_defend_intro_turret_target", "targetname" );
	
	if ( isdefined( vh_technical ) && isdefined( e_turret_target ) )
	{
		//start turret as soon as scene starts to get more gunfire effects
		vh_technical thread turret::shoot_at_target( e_turret_target, 10, ( 0, 0, 0 ), 1, false );
		
		//TODO add notetracks to cin_ram_05_02_block_vign_mowed for more specific targeting of turret on each entity in the scene
	}
}

function vignette_hendricks_leap()
{
	level scene::init( "cin_ram_05_01_defend_vign_leapattack" );
	
	level util::waittill_notify_or_timeout( "hendricks_leap_started", 8 );
}

function vignette_spike_launched_guy()
{
	self endon( "death" );

	self thread spike_launched_guy_death();
	self ai::set_ignoreme( true );
	
	nd_spike_launcher_guy = GetNode( "node_spike_launch_start", "targetname" );
	
	self ai::force_goal( nd_spike_launcher_guy, 8, true, "goal" );
	
	self.goalradius = 8;
	
	wait 5; //allow a few seconds for player to shoot him, before letting AI get to him
	
	self ai::set_ignoreme( false );
	
	wait 5; //stay in place for a few seconds before letting him roam free again
	
	self.goalradius = 512;
}

function spike_launched_guy_death()
{
	self waittill( "death" );
	
	//TODO if spike launched guy is stuck with a spike and is on the concrete block, play destruction on it
	
}

function monitor_vehicle_targets()
{
	level endon( "sinkhole_charges_detonated" );
	
	level.a_e_veh_targets = GetEntArray( "arena_defend_tank_target" , "targetname" );
	
	//HACK - investigate why clientside script origins were not working
	a_e_model_targets = [];
	foreach( target in level.a_e_veh_targets )
	{
		mdl_target = spawn( "script_model", target.origin );
		mdl_target.angles = target.angles;
		mdl_target SetModel( "tag_origin" );
		
		util::wait_network_frame();
		
		if ( !isdefined( a_e_model_targets ) ) a_e_model_targets = []; else if ( !IsArray( a_e_model_targets ) ) a_e_model_targets = array( a_e_model_targets ); a_e_model_targets[a_e_model_targets.size]=mdl_target;;
	}
	
	level.a_e_veh_targets = ArrayCombine( level.players , a_e_model_targets , false , false );
	
	while ( 1 )
	{
		level waittill( "player_spawned" );
		
		level.a_e_veh_targets = ArrayCombine( level.players , level.a_e_veh_targets , false , false );
	}
}

function enable_initial_wave_spawn_managers()
{	
	spawn_manager::enable( "sm_arena_defend_initial_enemies" );
	spawn_manager::enable( "sm_arena_defend_initial_snipers" );
	spawn_manager::enable( "sm_arena_defend_initial_rear" );
	
	util::wait_network_frame(); //stagger a bit
	
	// friendlies stack up on wall
	spawn_manager::enable( "arena_defend_wall_allies" );  // ground
	spawn_manager::enable( "arena_defend_wall_allies2" );  // spawn guys on wall
	
	util::wait_network_frame(); //stagger a bit
	
	spawn_manager::enable( "arena_defend_bldg_allies" );  // spawn guys in building
	spawn_manager::enable( "arena_defend_cafe_defenders" ); // friendly guys heading to the cafe
	
	spawn_manager::enable( "arena_defend_wall_top_allies" );  // top of wall
	
	//allow a bit of time before they move up to use color chain
	level thread util::delay( 7, undefined, &friendlies_take_cover_behind_mobile_wall );
}

function enemy_wave_initial()
{
	// send hendricks to specific node to set him up for animation later
	nd_hendricks = GetNode( "hendricks_mobile_wall_top_node", "targetname" );
	level.ai_hendricks.goalradius = 64;
	level.ai_hendricks colors::disable();
	
	level.ai_hendricks SetGoal( nd_hendricks, true );
	
	enable_initial_wave_spawn_managers();
	
	// Push initial enemies back while a wave moves forward from the lane in back
	// Spawn first technical with infantry fireteam
	
	level.ai_hendricks util::waittill_notify_or_timeout( "goal", 15 );
	
	//is set when gunner dies on initial technical, a timer expires, or when a trigger in radiant is hit
	level flag::wait_till( "arena_defend_intro_technical_disabled" );

	wait 4; //allow a bit of time for Hendricks to settle at goal before going to leap
	
	vignette_hendricks_leap();
	
	//TODO see if we can get an exploding wall for guy to stand in front of for this moment
	//bring a guy in from the rear wall who is supposed to get spike launched
	//spawner::simple_spawn_single( "spike_launched_guy", &vignette_spike_launched_guy );
	
	wait 2;  // stagger this a bit from animation to make it look like Hendricks is leading the charge
	
	level thread friendlies_move_to_position( "wp_01" );
	
	trigger::use( "arena_defend_tech_1_trig", "targetname", undefined, false );  // spawns wp_01 technical; this can also be triggered by player moving into the street
	
	level notify( "initial_wave_completed" );
	
	spawn_manager::enable( "sm_wp_01_defenders" );
	
	vo_weak_point_first_intro();
}

function enemy_wave_right_wall_push()
{
	spawn_manager::enable( "sm_wp_02_defenders" );
	util::wait_network_frame();
	
	spawn_manager::enable( "arena_defend_push_wasps" );
	util::wait_network_frame();
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl4_hostile_grunts_movin_0"; //Hostile grunts moving through southwest checkpoint!
	a_dialogue_lines[1] = "esl3_enemy_grunts_breakin_0"; //Enemy grunts breaking through southwest checkpoint!
	a_dialogue_lines[2] = "esl4_hostile_grunts_at_so_0"; //Hostile grunts at southwest checkpoint!
	
	ai_guy = vo_find_closest_redshirt_for_dialog();
	ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ) );
	
	//only bring snipers in if billboard hasn't been shot down already
	if ( !level flag::get( "billboard1_crashed" ) )
	{
		spawn_manager::enable( "sm_arena_defend_snipers_center_building" );
		
		//snipers currently only show up in co-op
		if ( level.players.size > 1 )
		{
			a_dialogue_lines = [];
			a_dialogue_lines[0] = "esl1_sniper_on_the_roof_0"; //Sniper! On the roof between the checkpoints!
			a_dialogue_lines[1] = "egy2_i_have_an_enemy_snip_0"; //I have an enemy sniper on the roof between the checkpoint barricades!
			
			ai_guy = vo_find_closest_redshirt_for_dialog();
			ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ), 2 );
		}

	}
	
	spawn_manager::enable( "arena_defend_robot_fill" );
}

//self is a robot with script_noteworthy "arena_defend_wall_jumper"
function arena_defend_wall_jumper_spawnfunc()
{
	self endon( "death" );
	
	n_jump_location = RandomIntRange( 1, 3 );
	
	if ( n_jump_location == 1 )
	{
		str_jump_location_up = "scene_wall_left_jumpover_up_01";
		str_jump_location_down = "scene_wall_left_jumpover_down_01";
	}
	else
	{
		str_jump_location_up = "scene_wall_left_jumpover_up_02";
		str_jump_location_down = "scene_wall_left_jumpover_down_02";
	}
	
	//start jump animation part of the way through since beginning of it is hidden behind wall
	//spawners are also delayed in radiant to prevent potential bunching up
	level scene::skipto_end( str_jump_location_up, "targetname", self, 0.5 );
	
	level scene::play( str_jump_location_down, self );
	
	//make them get there asap
	self ai::set_behavior_attribute( "move_mode", "rusher" );
	
	//have them go to their predefined goal
	if ( isdefined ( self.target ) )
	{
		e_goal = GetEnt( self.target, "targetname" );
		self SetGoal( e_goal, true );
	}
}

function discover_weak_points_wave_2()
{
	spawn_manager::enable( "sm_arena_defend_fill_middle" );
	
	level util::delay( 15, undefined, &flag::set, "arena_defend_second_wave_weak_points_discovered" );
		
	// Wait for initial wave to clear
	spawner::waittill_ai_group_amount_killed( "arena_defend_fill_middle", 3 );  // spawn manager set up as infinite; controlled by sm_arena_defend_fill_middle
		
	level flag::set( "arena_defend_second_wave_weak_points_discovered" );
	
	spawn_manager::enable( "sm_wp_03_defenders" );
}

function discover_weak_points_wave_3()
{
	level util::delay( 20, undefined, &flag::set, "arena_defend_third_wave_weak_points_discovered" );

	// this should be across all active spawn managers in this area; excludes robot phalanx and technical, wp04 defenders, wp05 defenders	
	spawner::waittill_ai_group_amount_killed( "arena_defend_checkpoint_breach_enemies", 30 );  
	
	level flag::set( "arena_defend_third_wave_weak_points_discovered" );
}

function discover_weak_points_wave_final()
{
	level flag::wait_till_all( Array( "wp_01_destroyed", "wp_02_destroyed", "wp_03_destroyed", "wp_05_destroyed" ) );
	
	wait 2;  // stagger timing so player can react, VO plays, etc.
	
	level flag::set( "arena_defend_last_wave_weak_points_discovered" );
}

function enemy_wave_checkpoint_wall_breach()
{
	level thread play_checkpoint_wall_breach_left();
	
	level thread vo_checkpoint_wall_breached();
	
	spawn_manager::enable( "arena_defend_checkpoint_wall_wave_01" );
	
	level thread ramses_util::spawn_phalanx( "checkpoint_wall_phalanx" , "phalanx_column" , 6, true, 10, undefined, true, "arena_defend_wave_02b_phalanx", "script_noteworthy", ramses_util::get_num_scaled_by_player_count( 1, 1 ) );
	
	level util::waittill_notify_or_timeout( "checkpoint_wall_breach_complete", 20 );

	// Spawn another technical
	// Spawn robot wave from second lane
	spawn_manager::enable( "arena_defend_wave_02b" ); 
	spawn_manager::enable( "arena_defend_fill_b_guys" );
	spawn_manager::enable( "sm_wp_05_defenders" );
	
	spawn_manager::disable( "sm_arena_defend_fill_middle" );
	
	//wall is open, so we don't need guys jumping over
	spawn_manager::kill( "sm_wp_03_defenders_jumpers" );
	
	friendlies_move_to_position( "wp_05" );
	
	trigger::use( "arena_defend_tech_2_trig", "targetname" );  // spawn_technical_backup_1 (old notify)
	
	// Start spawning from original lane again
	level util::waittill_notify_or_timeout( "arena_defend_technical_02_vh_reached_end_node", 10 );
	
	wait 10; // stagger enemy arrival a bit
	
	spawn_manager::enable( "arena_defend_wave_02" );
	
	if ( !level flag::get( "billboard1_crashed" ) )
	{
		spawn_manager::enable( "arena_defend_snipers_02" );
		
		a_dialogue_lines = [];
		a_dialogue_lines[0] = "esl1_sniper_on_the_roof_0"; //Sniper! On the roof between the checkpoints!
		a_dialogue_lines[1] = "egy2_i_have_an_enemy_snip_0"; //I have an enemy sniper on the roof between the checkpoint barricades!
		
		ai_guy = vo_find_closest_redshirt_for_dialog();
		ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ), 2 );
	}
}

function enemies_overrun_checkpoint_area()
{
	spawn_manager::set_global_active_count( 30 );
	
	level thread overwhelming_phalanx_spawning( "checkpoint_wall_phalanx" );
	level thread overwhelming_phalanx_spawning( "checkpoint_wall_phalanx_right" );
	
	spawn_manager::enable( "arena_defend_push_enemies" );
	util::wait_network_frame();
	spawn_manager::enable( "arena_defend_push_wasps" );
	
	//only enable if we haven't destroyed the billboard
	if ( !level flag::get( "billboard1_crashed" ) )
	{
		spawn_manager::enable( "arena_defend_snipers_03" );
		util::wait_network_frame();
		spawn_manager::enable( "arena_defend_snipers_04", true );
	}
	
	spawn_manager::enable( "arena_defend_flood_raps" );
	
	spawn_manager::enable( "arena_defend_heavy_units" );  // vehicles
}

function overwhelming_phalanx_spawning( str_phalanx )
{
	level endon( "sinkhole_charges_detonated" );
	
	v_start = struct::get( str_phalanx + "_start" ).origin;
	v_end = struct::get( str_phalanx + "_end" ).origin;
	
	while ( 1 )
	{
		n_robot_count = ramses_util::get_num_scaled_by_player_count( 3 , 1 ); //using the same scaled number for robots in each phalanx tier and robot count breaking point because it works well
		
		o_phalanx = new RobotPhalanx();
		[[ o_phalanx ]]->Initialize( "phalanx_column", v_start, v_end, n_robot_count , n_robot_count );
		
		do
		{
			wait 0.25;
		}
		while ( isdefined( o_phalanx ) && o_phalanx.scattered_ == false ); //wait until phalanx is scattered or gone, then and respawn		
	}
}

function kill_spawn_manager_group( str_script_noteworthy )
{
	a_spawn_managers = GetEntArray( str_script_noteworthy, "script_noteworthy" );
	
	foreach ( e_spawn_manager in a_spawn_managers )
	{
		if ( IsDefined( e_spawn_manager.name ) )
		{
			str_name = e_spawn_manager.name;
		}
		else 
		{
			str_name = e_spawn_manager.targetname;
		}
		
		spawn_manager::kill( str_name );
	}
}

// Weak Points
////////////////////////////////////////////////////////////////////

// Control flow of weak points in init_weak_points_by_player_count()
function players_destroy_weak_points_in_arena()
{
	level flag::wait_till( "weak_points_objective_active" );
	
	level.players ramses_util::hero_slot_activate_tutorial( "HeroSlotActivateTutorial", "spike_launcher" );	
	
	a_waves = get_weak_point_discovery_data();
	
	// this will stagger the 'discovery' of structural weak points
	foreach ( wave in a_waves )
	{
		foreach ( s_weak_point in wave )
		{
			if ( IsDefined( s_weak_point.a_flags_wait_for_discovery ) )
			{
				level flag::wait_till_all( s_weak_point.a_flags_wait_for_discovery );
			}
			
			level flag::set( s_weak_point.str_weak_point_identifier + "_identified" );
			
			if ( IsDefined( s_weak_point.a_func_on_discovery ) )
			{
				foreach ( a_func_on_discovery in s_weak_point.a_func_on_discovery )
				{
					level thread [[ a_func_on_discovery ]]();
				}
			}
			
			if ( IsDefined( s_weak_point.a_func_on_destroyed ) )
			{
				foreach ( a_func_on_destroyed in s_weak_point.a_func_on_destroyed )
				{
					level thread ramses_util::flag_then_func( s_weak_point.str_weak_point_identifier + "_destroyed", a_func_on_destroyed );
				}
			}
		}
	}
	
	wait_till_all_weak_points_destroyed();
	level notify ("area_defend_music");
	
	
	level flag::set( "all_weak_points_destroyed" );
	
	level thread vo_weak_points_all_destroyed();
	
	//once weak points are destroyed get the streamer ready for the demostreet_3rd_sh010 scene that starts after you pick up the detonator
	level thread util::set_streamer_hint( 2 );
}

function setup_sinkhole_weak_points()
{
	// init fxanim pieces 
	a_fxanims = Array( "wp_01", "wp_02", "wp_03", "wp_04", "wp_05" );
	
	foreach ( str_scene_name in a_fxanims ) 
	{
		level scene::init( str_scene_name );
	}
	
	// make sure misc_models are showing
	level clientfield::set( "arena_defend_hide_sinkhole_models", 0 );
	
	// run init on pieces first to set up flags
	a_t = GetEntArray( "ad_weak_point_trig", "targetname" );
	array::thread_all( a_t, &weak_point_think ); // Flags set here: "wp_01", "wp_02", "wp_03", "wp_04", "wp_05"		
	
	init_weak_points_by_player_count();
}

function set_up_gameplay_borders()
{
	// these triggers will kill players that go behind the two breached checkpoints
	a_t_kill = GetEntArray( "ad_kill_player", "targetname" );
	
	array::thread_all( a_t_kill, &ramses_util::kill_players, "dead_alley_started" );	
}

function setup_intro_scenes_for_skipto()
{
	vehicle::simple_spawn_single( "arena_defend_intro_technical" );
	
	// set up center group of guys taking cover to warp behind cover
	level ramses_util::skipto_notetrack_time_in_animation( %generic::ch_ram_05_01_defend_vign_rescueinjured_r_group_injured, "cin_ram_05_01_defend_vign_rescueinjured_r_group", "skipto_start_frame" );

	// left group of guys warp behind cover
	level ramses_util::skipto_notetrack_time_in_animation( %generic::ch_ram_05_01_defend_vign_rescueinjured_l_group_injured, "cin_ram_05_01_defend_vign_rescueinjured_l_group", "skipto_start_frame" );
	
	// right group of guys warp behind cover
	level ramses_util::skipto_notetrack_time_in_animation( %generic::ch_ram_05_01_defend_vign_rescueinjured_c_group_exposed, "cin_ram_05_01_defend_vign_rescueinjured_c_group", "skipto_start_frame" );	
}

function enemies_spawn_in_checkpoint_area()
{	
	level thread friendlies_push_into_street_after_intro_enemies_killed();
	
	level flag::wait_till( "arena_defend_start_waves" );  // comes from Radiant trigger
	
	level thread enemy_wave_initial();
	
	// friendlies stack up on wall
	spawn_manager::enable( "arena_defend_wall_allies" );  // ground
	spawn_manager::enable( "arena_defend_wall_top_allies" );  // top of wall
}

function khalil_talks_to_area_commander()
{
	level scene::play( "cin_ram_05_01_block_vign_rip_khalilorder" );
	
	level thread vo_weak_point_initial_search();
}

function friendlies_push_into_street_after_intro_enemies_killed()
{
	level endon( "arena_defend_color_allies_street_middle" );
	
	level flag::wait_till( "arena_defend_intro_technical_disabled" );
	spawn_manager::wait_till_ai_remaining( "sm_arena_defend_initial_enemies", 3 );
	
	trigger::use( "arena_defend_enemies_fallback_colortrig" );
}

function ambient_spawns_start()
{
	t_cleanup = GetEnt( "arena_defend_plaza_cleanup_trig", "targetname" );
	
	// Temporarily disabling ambient spawns since our actor count is high - TJanssen 12/9/2014
//	level thread ramses_util::ambient_spawns( "arena_defend_plaza_guy", undefined, 5, t_cleanup, "sinkhole_charges_detonated", 9 );	
}

function init_weak_points_by_player_count()
{
	// TODO: break out into per-player setup for coop scaling
	a_funcs_on_first_wave_start = Array( &enemy_wave_right_wall_push, &vo_weak_point_first_found );
	a_funcs_on_first_wave_complete = Array( &discover_weak_points_wave_2, &vo_weak_point_first_destroyed, &enable_car4cover_vignette, &friendlies_move_to_wp_02_03, &vignette_egyptian_soldiers_killed_by_wasps );
	a_funcs_on_checkpoint_breach_start = Array( &enemy_wave_checkpoint_wall_breach, &vo_weak_point_second_wave_destroyed, &discover_weak_points_wave_3 );
	a_funcs_on_final_wave_start = Array( &friendlies_move_to_final_street_position, &vo_weak_point_last_group, &play_checkpoint_wall_breach_right );
	
	// register_weak_point_for_wave( n_wave, str_weak_point_identifier, a_flags_wait_for_discovery, a_func_on_discovery, a_func_on_destroyed )
	register_weak_point_for_wave( 1, "wp_01", undefined, a_funcs_on_first_wave_start, a_funcs_on_first_wave_complete );
	
	register_weak_point_for_wave( 2, "wp_02", "arena_defend_second_wave_weak_points_discovered", &vo_weak_point_second_found );
	register_weak_point_for_wave( 2, "wp_03", undefined, undefined, a_funcs_on_checkpoint_breach_start );
	
	register_weak_point_for_wave( 3, "wp_05", "arena_defend_third_wave_weak_points_discovered", &vo_weak_point_third_found, &discover_weak_points_wave_final );
	
	register_weak_point_for_wave( 4, "wp_04", "arena_defend_last_wave_weak_points_discovered", a_funcs_on_final_wave_start );
}

function get_weak_point_discovery_data()
{
	Assert( IsDefined( level.a_weak_point_discovery_waves ), "get_weak_point_discovery_data: level.a_weak_point_discovery_waves not yet initialized!" );
	
	return level.a_weak_point_discovery_waves;
}

function register_weak_point_for_wave( n_wave, str_weak_point_identifier, a_flags_wait_for_discovery, a_func_on_discovery, a_func_on_destroyed )
{
	if(!isdefined(level.a_weak_point_discovery_waves))level.a_weak_point_discovery_waves=[];
	if(!isdefined(level.a_weak_point_discovery_waves[ n_wave ]))level.a_weak_point_discovery_waves[ n_wave ]=[];
	
	// ensure each of these are arrays
	if ( !isdefined( a_flags_wait_for_discovery ) ) a_flags_wait_for_discovery = []; else if ( !IsArray( a_flags_wait_for_discovery ) ) a_flags_wait_for_discovery = array( a_flags_wait_for_discovery );;
	if ( !isdefined( a_func_on_discovery ) ) a_func_on_discovery = []; else if ( !IsArray( a_func_on_discovery ) ) a_func_on_discovery = array( a_func_on_discovery );;
	if ( !isdefined( a_func_on_destroyed ) ) a_func_on_destroyed = []; else if ( !IsArray( a_func_on_destroyed ) ) a_func_on_destroyed = array( a_func_on_destroyed );;	
	
	// if we're missing a flag, error out at the beginning 
	if ( IsDefined( a_flags_wait_for_discovery ) )
	{
		foreach ( str_flag in a_flags_wait_for_discovery )
		{
			Assert( level flag::exists( str_flag ), "register_weak_point_for_wave: attempting to use flag '" + str_flag + "' which has not yet been initialized!" );
		}
	}
	
	// store all the data
	s_temp = SpawnStruct();
	
	s_temp.str_weak_point_identifier = str_weak_point_identifier;
	s_temp.a_flags_wait_for_discovery = a_flags_wait_for_discovery;
	s_temp.a_func_on_discovery = a_func_on_discovery;
	s_temp.a_func_on_destroyed = a_func_on_destroyed;
	
	if ( !isdefined( level.a_weak_point_discovery_waves[ n_wave ] ) ) level.a_weak_point_discovery_waves[ n_wave ] = []; else if ( !IsArray( level.a_weak_point_discovery_waves[ n_wave ] ) ) level.a_weak_point_discovery_waves[ n_wave ] = array( level.a_weak_point_discovery_waves[ n_wave ] ); level.a_weak_point_discovery_waves[ n_wave ][level.a_weak_point_discovery_waves[ n_wave ].size]=s_temp;;	
}

function wait_till_all_weak_points_destroyed()
{
	a_data = get_weak_point_discovery_data();
	
	a_flags = [];
	
	foreach ( wave in a_data )
	{
		foreach ( s_weak_point in wave )
		{
			if ( !isdefined( a_flags ) ) a_flags = []; else if ( !IsArray( a_flags ) ) a_flags = array( a_flags ); a_flags[a_flags.size]=s_weak_point.str_weak_point_identifier + "_destroyed";;
		}
	}
	
	level flag::wait_till_all( a_flags );
}

// Self is damage trigger
function weak_point_think()
{	
	level flag::init( self.script_string );
	level flag::init( self.script_string + "_identified" );
	level flag::init( self.script_string + "_destroyed" );
	
	m_objective_marker = GetEnt( self.target, "targetname" );
	Assert( IsDefined( m_objective_marker ), "Weak point damage trigger must target a script model." );

	// set up weakness visualization	
	Assert( IsDefined( m_objective_marker.target ), "weak_point_think: m_objective_marker is missing struct target! This is used to visualize the structural weakness." );
	s_weak_point_model = struct::get( m_objective_marker.target, "targetname" );
	Assert( IsDefined( s_weak_point_model ), "weak_point_think: s_weak_point_model for weak point at " + self.origin + " not found!" );
	
	// set up walk traversals for AI - moving_platform_enabled should be on collision ent
	a_collision = GetEntArray( "collision_" + self.script_string, "targetname" );
	foreach ( mdl_collision in a_collision )
	{
		mdl_collision SetMovingPlatformEnabled( true );
	}
	
	ramses_util::enable_nodes( self.script_string + "_covernode", "script_noteworthy", true );
	ramses_util::link_traversals( self.script_string + "_traversal", "script_noteworthy", true );
	
	// set up bad place for friendly AI so they don't try to get close to these
	BadPlace_Cylinder( self.script_string, -1, self.origin, 125, 100, "allies" );
	
	// wait for weak point to be identified 
	level waittill( self.script_string + "_identified" );
	
	s_weak_point_trigger = GetEnt( s_weak_point_model.target , "targetname" );
	Assert( IsDefined( s_weak_point_trigger ), "Weak point use trigger must be targeted by the script model visual." );
	
	s_weak_point_trigger Show();
	
	s_weak_point_gameobject = create_weak_point_gameobject( m_objective_marker , s_weak_point_trigger );
	s_weak_point_gameobject.t_damage = self;  // custom field: used to manually trigger damage watcher
	
	s_weak_point_gameobject setup_badplace_for_spike_plant();

	m_weak_point_model = util::spawn_model( s_weak_point_model.model, s_weak_point_model.origin, s_weak_point_model.angles );
	m_weak_point_model clientfield::set( "arena_defend_weak_point_keyline", true );
	
	//TODO Find out if we want both the destroy prompts and the weak point prompts
	//objectives::set( "cp_level_ramses_destroy", m_objective_marker );

	level.players[0] playlocalsound("uin_hud_weakpoints");
	
	self wait_for_weak_point_destruction();
	
	m_weak_point_model clientfield::set( "arena_defend_weak_point_keyline", false );
	
	util::wait_network_frame(); //needed for the clientfield before this to be set correctly
	
	spawn_manager::kill( "sm_" + self.script_string + "_defenders" );
	
	level flag::set( self.script_string );
	
	m_objective_marker Ghost();
	
	level.players ramses_util::hero_slot_hint_stop();
	
	level flag::set( self.script_string + "_destroyed" );  // TODO: replace script_string stuff with this
	
	//objectives::complete( "cp_level_ramses_destroy", m_objective_marker );	

	level thread scene::play( self.script_string, "targetname" );  // play fxanim destruction
	
	//wp_05 is a special case, don't actually sink into the ground once it's destroyed
	foreach ( mdl_collision in a_collision )
	{
		if ( mdl_collision.targetname != "collision_wp_05" )
		{
			mdl_collision Delete();
		}
	}
	
	//HACK weakpoint_enable currently acts globally, and since these two show up at the same time
	//the keyline calls turns both of them off when destroyed. Force the call again if the other one is alive to keep it visible
	if ( (level flag::get( "wp_02_destroyed" ) && !level flag::get( "wp_03_destroyed" )) || ( !level flag::get( "wp_02_destroyed" ) && level flag::get( "wp_03_destroyed" ) ) )
	{
		m_weak_point_model clientfield::set( "arena_defend_weak_point_keyline", true );
		util::wait_network_frame();
	}
	
	m_weak_point_model Delete();
	
	ramses_util::enable_nodes( self.script_string + "_covernode", "script_noteworthy", false );
	ramses_util::link_traversals( self.script_string + "_traversal", "script_noteworthy", false );
	
	if ( self.script_string != "wp_05" )
	{
		ramses_util::enable_nodes( self.script_string + "_traversal_jump", "script_noteworthy", true ); //in case AI fall in hole, allow them to jump out
	}
	
	//note from _ammo_cache script on how to clear out this object:
	//this objective was set through the game object scripts and bypasses the objective CP scripts
	Objective_ClearEntity( s_weak_point_gameobject.objectiveID );
	s_weak_point_gameobject gameobjects::destroy_object( true );
	
	//this waypoint now has a flame effect after it's destroyed, so add a trigger_hurt, and don't delete its bad place
	if ( self.script_string === "wp_04" )
	{
		t_damage_fire = GetEnt( "trig_wp_04_damage", "targetname" );
		t_damage_fire TriggerEnable( true );
	}
	else
	{
		BadPlace_Delete( self.script_string );
	}
	
	self Delete();	
}

// notify will come from plant animation
function wait_for_weak_point_destruction()  // self = trigger
{
	self waittill( "planted_spike_detonation" );
}

function create_weak_point_gameobject( mdl_visual , trigger )
{
	const TRIGGER_USE_TIME = 0;
	
	trigger TriggerIgnoreTeam();
	trigger SetVisibleToAll();
	trigger SetTeamForTrigger( "none" );
	trigger SetCursorHint( "HINT_NOICON" );
	
	// You can add multiple models into the gameobjects model array, each with their own relative offset
	v_model_offset = ( 0, 0, 35 );
	a_mdl_visuals[ 0 ] = mdl_visual;

	// This is an objective indicator defined in the cp_objectives gdt
	str_objective_type = &"cp_spike_plant";

	// Create the gameobject
	str_team = "allies";
	s_gameobject = gameobjects::create_use_object( str_team, trigger, a_mdl_visuals, v_model_offset, str_objective_type );

	// Setup gameobject params
	s_gameobject gameobjects::allow_use( "any" );
	s_gameobject gameobjects::set_use_time( TRIGGER_USE_TIME );  // How long the progress bar takes to complete
	s_gameobject gameobjects::set_use_hint_text( &"CP_MI_CAIRO_RAMSES_PLANT_SPIKE" );
	s_gameobject gameobjects::set_visible_team( "any" );				// How can see the gameobject

	// Setup gameobject callbacks
	s_gameobject.onUse = &callback_gameobject_weak_point_on_use;
	s_gameobject.onBeginUse = &callback_gameobject_weak_point_on_begin_use;
	s_gameobject.onUseUpdate = &callback_gameobject_weak_point_on_use_update;
	s_gameobject.onCantUse = &callback_gameobject_weak_point_on_cant_use;
	s_gameobject.onEndUse = &callback_gameobject_weak_point_on_end_use;
	
	return s_gameobject;
}

// Called when gameobject has been "used"
function callback_gameobject_weak_point_on_use( e_player )
{
	if ( e_player player_has_spike_launcher_ammo() )
	{
		e_player player_plants_spike_in_ground( self );
		self gameobjects::allow_use( "none" );
	}
	else 
	{
		e_player thread util::screen_message_create_client( &"CP_MI_CAIRO_RAMSES_SPIKE_AMMO_MISSING", undefined, undefined, undefined, 2.5 );
	}
}

//--------------------------------------------------------------------------------
// Called when the Use Functionality Starts
//--------------------------------------------------------------------------------
function callback_gameobject_weak_point_on_begin_use( e_player )
{
}

//--------------------------------------------------------------------------------
// Called when the Use Functionality Ends
//--------------------------------------------------------------------------------
function callback_gameobject_weak_point_on_end_use( str_team, e_player, b_success )
{
}

// When Using gameobject
function callback_gameobject_weak_point_on_use_update( str_team, n_progress, b_change )
{
}

// Called when not able to use
function callback_gameobject_weak_point_on_cant_use( e_player )
{
}

function player_has_spike_launcher_ammo()  // self = player
{
	w_spike_launcher = GetWeapon( "spike_launcher" );

	n_ammo_clip = self GetWeaponAmmoClip( w_spike_launcher );
	
	b_has_ammo = ( n_ammo_clip > 0 );
	
	return b_has_ammo;
}

function player_plants_spike_in_ground( s_gameobject )  // self = player
{
	self endon( "death" );
	
	if(!isdefined(self.is_planting_spike))self.is_planting_spike=false;
	
	if ( !self.is_planting_spike )
	{
		self.is_planting_spike = true;
		
		self move_player_if_in_spike_plant_badplace( s_gameobject );
		
		if ( !self ramses_util::is_using_weapon( "spike_launcher" ) )
		{
			self SwitchToWeapon( GetWeapon( "spike_launcher" ) );
			
			wait 0.1; //HACK IsSwitchingWeapons() only seems to work after waiting this amount of time
			
			//TODO is there a notify for this?
			while ( self IsSwitchingWeapons() )
			{
				wait 0.05;
			}
		}
		
		self thread reduce_accuracy_against_solo_player_for_spike_plant();
		
		self thread scene::play( "cin_ram_05_02_spike_launcher_plant", self );
		
		self waittill( "fire_spike" );
		
		level notify( "player_plants_spike" );
		
		self thread fire_spike_into_ground();
		self thread watch_for_spike_detonation( s_gameobject.t_damage );	
	}
}

function move_player_if_in_spike_plant_badplace( s_gameobject )  // self = player
{	
	t_badplace = s_gameobject.t_plant_badplace;
	s_safe_location = s_gameobject.s_plant_badplace_move;
	
	if ( IsDefined( t_badplace ) && IsDefined( s_safe_location ) )
	{
		if ( self IsTouching( t_badplace ) )
		{
			self SetOrigin( s_safe_location.origin );
			
			util::wait_network_frame();  // allow move to happen before animation begins
		}
	}
}

// if a player touches this trigger when planting, he'll move away to struct position
// all triggers here should have targetname = 'wp_0X_bad_place_trigger"
function setup_badplace_for_spike_plant()  // self = gameobject
{
	str_identifier = self.visuals[ 0 ].script_string;  // this will be 'wp_0x'
	
	self.t_plant_badplace = GetEnt( str_identifier + "_bad_place_trigger", "targetname" );
	
	if ( IsDefined( self.t_plant_badplace ) )
	{
		self.s_plant_badplace_move = struct::get( self.t_plant_badplace.target, "targetname" );
		Assert( IsDefined( self.s_plant_badplace_move ), "setup_badplace_for_spike_plant: " + str_identifier + " found a badplace trigger but no accomapnying struct to move players!" );
	}
}

function scene_callback_spike_plant_done( a_ents )
{
	a_ents[ "player 1" ].is_planting_spike = undefined;
}

function fire_spike_into_ground()  // self = player
{
	self endon( "death" );
	
	waittillframeend;  // delay so watch_for_spike_detonation() can catch 'grenade_fire' notify
	
	w_spike_launcher_plant = GetWeapon( "spike_launcher_plant" );
	v_spawn = self GetTagOrigin( "tag_flash" );
	
	self clientfield::increment_to_player( "player_spike_plant_postfx" );

	e_spike = MagicBullet( w_spike_launcher_plant, ( v_spawn + ( 0, 0, 40 ) ), v_spawn, self );
	
	self spike_count_decrement();
}

// only spike_launcher and spike_charge weapon are watched by _weaponobjects threads - these need to get handled manually, but should look the same to the player
function watch_for_detonation_press( e_spike )  // self = player
{
	self endon( "death" );
	e_spike endon( "death" );  // timeout condition on spikes can detonate it before player does, though it takes a long time
	
	// show keylined spike in the ground... only that doesn't work properly on missiles. So fake it!
	mdl_spike = util::spawn_model( e_spike.model, e_spike.origin, e_spike.angles );
	mdl_spike clientfield::set( "arena_defend_weak_point_keyline", true );
	
	mdl_spike thread spike_keyline_disable_on_timeout( e_spike );
	
	e_spike Ghost();  // since angles may not match perfectly, hide the original
	
	self waittill( "detonate" );  // this gets sent to player when pressing R3 with Spike Launcher equipped, from code, but won't automatically detonate spike_charge_plant grenade
	
	mdl_spike clientfield::set( "arena_defend_weak_point_keyline", false );
	
	e_spike Detonate();
	mdl_spike Delete();
}

function watch_for_spike_detonation( trigger )  // self = player
{
	self endon( "death" );
	trigger endon( "death" );  // trigger may be deleted by another thread if multiple spikes are planted
	
	self waittill( "grenade_fire", e_spike );  // this will come from MagicBullet call in fire_spike_into_ground
	
	self thread watch_for_detonation_press( e_spike );
	
	v_spike_position = e_spike.origin;
	
	e_spike waittill( "death" );
	
	trigger notify( "planted_spike_detonation" );
	
	// get any other grenades within radius and detonate them too (this will pick up spikes, sticky grenades, etc.)
	level cleanup_nearby_explosives( v_spike_position );
}


//arg1 can be a vector or an entity
function cleanup_nearby_explosives( arg1 )
{
	a_grenades = GetEntArray( "grenade", "classname" );
	
	if ( IsVec( arg1 ) )
	{
		//if we need to check a radius starting from a position
		foreach ( i, e_grenade in a_grenades )
		{
			if ( isdefined( e_grenade ) && Distance2DSquared( arg1, e_grenade.origin ) <= 200 * 200 )
			{
				e_grenade Detonate();
			}
			
			//clamp how many of these nearby that can be detonated on the same frame
			if ( i % 2 == 0 )
			{
				util::wait_network_frame();
			}
		}
	}
	else if ( IsEntity( arg1 ) )
	{
		//if we need to check for any explosives touching this entity
		foreach ( i, e_grenade in a_grenades )
		{
			if ( isdefined( e_grenade ) && e_grenade IsTouching( arg1 ) )
			{
				e_grenade Detonate();
			}
			
			//clamp how many of these nearby that can be detonated on the same frame
			if ( i % 2 == 0 )
			{
				util::wait_network_frame();
			}
		}
	}
}

//self is the fake model that gets used for the spike launcher missile keyline. make sure it gets deleted even if a player never presses the button to detonate it
function spike_keyline_disable_on_timeout( e_spike )
{
	self endon( "death" );
	
	e_spike waittill( "death" );
	
	self Delete();
}

function spike_count_decrement()  // self = player
{
	w_spike_launcher = GetWeapon( "spike_launcher" );
	n_ammo_clip = self GetWeaponAmmoClip( w_spike_launcher );
	
	n_ammo_clip = math::clamp( ( n_ammo_clip - 1 ), 0, n_ammo_clip );
	
	self SetWeaponAmmoClip( w_spike_launcher, n_ammo_clip );
}

function reduce_accuracy_against_solo_player_for_spike_plant()  // self = player
{
	self endon( "death" );
	
	const DECREASE_ATTACKER_ACCURACY_TIME = 3;
	
	if ( level.players.size == 1 )
	{
		self.attackerAccuracy = 0.1;
		
                // wait for animation to finish
		while ( ( isdefined( self.is_planting_spike ) && self.is_planting_spike ) )
		{
			wait 0.1;
		}
		
		wait DECREASE_ATTACKER_ACCURACY_TIME;
		
		self.attackerAccuracy = 1;
	}
}

function friendlies_fall_back_behind_mobile_wall( b_wait_for_fallback = true )
{
	// stop friendly reinforcement spawning
	friendlies_clear_goals_and_colors();
	kill_spawn_manager_group( "arena_defend_spawn_manager_friendly" );
	
	// disable nodes on top of the wall except the cinematic one
	ramses_util::enable_nodes( "arena_defend_mobile_wall_top_nodes", "script_noteworthy", false );
	
	// handle redshirts: fall back behind mobile wall
	t_fallback_behind_mobile_wall = GetEnt( "sinkhole_friendly_fallback_volume", "targetname" );
	foreach ( ai_friendly in GetActorTeamArray( "allies" ) )
	{
		ai_friendly SetGoal( t_fallback_behind_mobile_wall, true );
	}

	//don't need to enable these, all it does is allow other AI to stand where the heroes are moving to
//	ramses_util::enable_nodes( "hendricks_mobile_wall_start_node", "targetname", true );
//	ramses_util::enable_nodes( "arena_defend_demostreet_intro_khalil", "targetname", true );
	
	level.ai_hendricks.goalradius = 32;
	nd_fallback_hendricks = GetNode( "hendricks_mobile_wall_start_node", "targetname" );
	level.ai_hendricks thread ai::force_goal( nd_fallback_hendricks, 32, true, undefined, true );
	
	level.ai_khalil.goalradius = 32;
	nd_fallback_khalil = GetNode( "arena_defend_demostreet_intro_khalil", "targetname" );
	level.ai_khalil thread ai::force_goal( nd_fallback_khalil, 32, true, undefined, true );
	
	// wait for heroes to get behind mobile wall
	const WAIT_TIME_MAX = 30;
	const UPDATE_TIME = 1;
	
	n_time_waited = 0;
	
	if ( b_wait_for_fallback )
	{
		do 
		{
			wait UPDATE_TIME;
			
			n_time_waited += UPDATE_TIME;
			
			b_heroes_clear_of_blast = ( level.ai_hendricks IsTouching( t_fallback_behind_mobile_wall ) && level.ai_khalil IsTouching( t_fallback_behind_mobile_wall ) );
			b_timeout_reached = ( n_time_waited > WAIT_TIME_MAX );
			
			if ( b_timeout_reached )
			{
				if ( !level.ai_hendricks IsTouching( t_fallback_behind_mobile_wall ) )
				{
					// teleport Hendricks to prevent a non-prog condition in a worst-case scenario
					/# ErrorMsg( "Hendricks failed to fall back behind the Mobile Wall after " + WAIT_TIME_MAX + " seconds. Hendricks origin = " + level.ai_hendricks.origin ); #/
					level.ai_hendricks ForceTeleport( nd_fallback_hendricks.origin, nd_fallback_hendricks.angles );
				}
				
				if ( !level.ai_khalil IsTouching( t_fallback_behind_mobile_wall ) )
				{
					// teleport Khalil to prevent a non-prog condition in a worst-case scenario
					/# ErrorMsg( "Khalil failed to fall back behind the Mobile Wall after " + WAIT_TIME_MAX + " seconds. Khalil origin = " + level.ai_khalil.origin ); #/
					level.ai_khalil ForceTeleport( nd_fallback_khalil.origin, nd_fallback_khalil.angles );
				}
			}
		}
		while ( !b_heroes_clear_of_blast );
	}
}

function friendlies_clear_goals_and_colors()
{
	if ( IsDefined( level.ai_hendricks ) && IsDefined( level.ai_hendricks.goalradius_old ) )
	{
		level.ai_hendricks.goalradius = level.ai_hendricks.goalradius_old;
	}
	
	//get only human AI, since wasps can technically be allies during firefly swarm and remote hijack
	a_ai_allies = GetActorTeamArray( "allies" );
	foreach( ai in a_ai_allies )
	{
		ai colors::disable();
		ai ClearGoalVolume();
	}	
}

// Sinkhole
////////////////////////////////////////////////////////////////////
function scene_friendly_detonation_guy_killed()
{
	level thread scene::init( "cin_ram_05_demostreet_vign_intro_detonation_guy" );
	level thread scene::init( "cin_ram_05_demostreet_vign_intro_khalil" );
	level thread scene::init( "cin_ram_05_demostreet_vign_intro_hendricks" );
	
	level util::waittill_notify_or_timeout( "vign_intro_runback_done", 5 ); //notify set in ch_ram_05_demostreet_vign_intro_hendricks_initial.xanim
	
	level thread scene::play( "cin_ram_05_demostreet_vign_intro_detonation_guy" );
	level thread scene::play( "cin_ram_05_demostreet_vign_intro_khalil" );
	level thread scene::play( "cin_ram_05_demostreet_vign_intro_hendricks" );
	
	level flag::wait_till_timeout( 5 , "arena_defend_detonator_dropped" );
}

function wait_till_players_are_behind_mobile_wall()
{
	trigger::wait_till( "sinkhole_friendly_fallback_volume" );
}

function wait_for_door_close()
{
	//all players trigger, close door once everyone is safely behind the wall
	//trigger only gets turned on once weak points are destroyed
	trigger::wait_till( "arena_defend_wall_gather_trig" );
	
	//make sure ai doesn't try to kill people anymore
	array::thread_all( GetAITeamArray( "axis", "allies" ), &ai::set_ignoreall, true );
	
	mobile_wall_doors_close();
}

function players_detonate_charges_from_mobile_wall()
{
	trigger::wait_till( "arena_defend_detonator_pickup" );
	
	// players can pick up detonator mid-way through this animation, so cancel it if it's not finished
	if ( level scene::is_active( "cin_ram_05_demostreet_vign_intro_hendricks" ) )
	{
		level scene::stop( "cin_ram_05_demostreet_vign_intro_hendricks" );
	}
	
	if ( level scene::is_active( "cin_ram_05_demostreet_vign_intro_khalil" ) )
	{
		level scene::stop( "cin_ram_05_demostreet_vign_intro_khalil" );
	}	
	
	foreach( player in level.players )
	{
		player.ignoreme = true;
		player EnableInvulnerability();
	}
	
	//make sure friendlies don't randomly pop up during final scene
	kill_spawn_manager_group( "arena_defend_spawn_manager" );
	kill_spawn_manager_group( "arena_defend_spawn_manager_friendly" );
	delete_friendly_ai_for_final_scene();
	
	//delete enemy AI before the sinkhole starts. don't want floating ragdolls
	array::run_all( GetAITeamArray( "axis" ), &Delete );
	array::run_all( GetCorpseArray(), &Delete );
	
	foreach( player in level.players )
	{
		player oed::set_player_tmode( false );
	}
	
	level scene::play( "cin_ram_05_demostreet_3rd_sh010" );
	
	kill_all_ai_in_street();
	
	level flag::wait_till( "arena_defend_sinkhole_collapse_done" );  // set in final scene callback of third person ICG
	
	foreach( player in level.players )
	{
		player.ignoreme = false;
		player DisableInvulnerability();		
	}
}

function delete_friendly_ai_for_final_scene()
{
	a_friendly = GetActorTeamArray( "allies" );
	
	foreach ( ai in a_friendly )
	{
		if ( !IsInArray( level.heroes, ai ) && ( !IsActor( ai ) || !ai IsInScriptedState() ) )
		{
			ai Delete();
		}
	}
}

function destroy_all_vehicles_in_street()
{
	a_vehicles = GetEntArray( "arena_defend_technical", "script_noteworthy" );
	n_living_vehicles = 0;
	
	foreach ( vehicle in a_vehicles )
	{
		if ( IsAlive( vehicle ) )
		{
			vehicle DoDamage( vehicle.health, vehicle.origin );
			n_living_vehicles++;
		}
	}
	
	if ( n_living_vehicles > 0 )
	{
		waittillframeend;  // allow vehicles to die before collision starts moving; they'll get shot into the air during death otherwise  
	}
}

function kill_all_ai_in_street()
{
	// this trigger can be triggered by AI, vehicles or players
	level flag::set( "sinkhole_explosion_started" );  // turns on trigger in Radiant that kills anything that touches it
}

// Outro
////////////////////////////////////////////////////////////////////

// Ths is called from alley script so it is running when starting from next skipto
function outro( b_starting )
{
	if( b_starting )
	{
		add_spawn_functions();
		
		level flag::set( "sinkhole_charges_detonated" );
		trigger::use( "arena_defend_colors_allies_behind_mobile_wall" );
		
		spawn_manager::enable( "arena_defend_wall_allies" );
		spawn_manager::enable( "arena_defend_wall_allies2" );
		spawn_manager::enable( "arena_defend_wall_top_allies" );
		spawn_manager::enable( "arena_defend_push_enemies" );
		spawn_manager::enable( "arena_defend_heavy_units" );
		
		level flag::wait_till( "all_players_spawned" );
		
		level thread scene::play( "cin_ram_05_02_block_nrc_vign_cheering" );
	}
	
	wait 5; // wait a bit so enemies can spawn in before we send them away
	
	enemies_move_to_quad_tank_plaza();
}

function enemies_move_to_quad_tank_plaza()
{
	ai_axis = GetAITeamArray( "axis" );
	
	nd_exit_ground = GetNode( "arena_defend_outro_push_guys_exit", "targetname" );	
	nd_exit_roof = GetNode( "arena_defend_roof_outro_node", "targetname" );

	t_roof = GetEnt( "checkpoint_walls_goaltrig", "targetname" );
	
	foreach ( ai in ai_axis )
	{
		if ( ai IsTouching( t_roof ) )
		{
			nd_goal = nd_exit_roof;
		}
		else 
		{
			nd_goal = nd_exit_ground;
		}
		
		ai thread fall_back_to_goal_then_delete( nd_goal );
	}
}

function fall_back_to_goal_then_delete( nd_goal )
{
	self endon( "death" );
	
	wait RandomFloatRange( 2.0, 6.0 );  // fake reaction time
	
	self.goalradius = 250;
	
	self SetGoal( nd_goal.origin );
	
	self util::waittill_notify_or_timeout( "goal", 30 );  // don't let any of these guys stick around forever
	
	if ( IsVehicle( self ) )
	{
		self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
	}
	else 
	{
		self Delete();
	}
}

function friendly_soldiers_celebrate_sinkhole_destruction()
{
	// all of these scenes are unaligned
	a_scenes = Array( "cin_ram_05_02_block_nrc_vign_cheering_a", 
	                 "cin_ram_05_02_block_nrc_vign_cheering_b",
	                 "cin_ram_05_02_block_nrc_vign_cheering_c",
	                 "cin_ram_05_02_block_nrc_vign_cheering_d",
	                 "cin_ram_05_02_block_nrc_vign_cheering_e",
	                 "cin_ram_05_02_block_nrc_vign_cheering_f" );
	
	a_redshirts = get_all_non_hero_friendlies();
	
	// loop through all the redshirts and play a scene on them, until we run out of scenes or guys
	for ( i = 0; ( i < a_redshirts.size && i < a_scenes.size ); i++ )
	{
		ai_guy = a_redshirts[ i ];
		str_scene = a_scenes[ i ];
	
		ai_guy thread scene::play( str_scene, ai_guy );
	}
}

function get_all_non_hero_friendlies()
{
	a_friendlies = GetActorTeamArray( "allies" );

	// get rid of the heroes	
	ArrayRemoveValue( a_friendlies, level.ai_hendricks, false );
	ArrayRemoveValue( a_friendlies, level.ai_khalil, false );
	
	return a_friendlies;
}

function fade_out_for_demo()
{
	level notify( "arena_defend_fade_out" );
	
	if ( ramses_util::is_demo() && level.skipto_point != "dev_sinkhole_test" )
	{
		s_streamer = struct::get( "vtol_igc_streamer_hint", "targetname" );
		e_streamer_hint_ent = CreateStreamerHint( s_streamer.origin, 1.0 );
		level.streamer_vtol_igc = e_streamer_hint_ent;
		
		level thread ramses_util::post_fx_transitions("dni_futz");
//		util::screen_fade_out( 2 );
	}
	
	//play in the interest of time movie  TODO: DELETE AFTER ALL DEMOS ARE DONE
	//level lui::play_movie( "interesttime05", "fullscreen" );
}

function remove_out_of_bounds_trigger_in_alley_building()
{
	ramses_util::delete_ent_array( "arena_defend_out_of_bounds_trigger", "targetname" );
}

// Scenes
////////////////////////////////////////////////////////////////////

function setup_scenes()
{	
	// fxanims
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_02_bundle", &scene_callback_fxanim_wp_01_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_02_bundle", &scene_callback_fxanim_wp_01_done, "done" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_01_bundle", &scene_callback_fxanim_wp_03_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_03_bundle", &scene_callback_fxanim_wp_04_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_04_bundle", &scene_callback_fxanim_wp_05_play, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_drop_bundle", &scene_callback_fxanim_mobile_wall_drop_init, "init" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_drop_bundle", &scene_callback_fxanim_mobile_wall_drop_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_drop_bundle", &scene_callback_fxanim_mobile_wall_drop_done, "done" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_checkpoint_wall_01_bundle", &scene_callback_checkpoint_left_breach_init, "init" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_checkpoint_wall_01_bundle", &scene_callback_checkpoint_left_breach_play, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_checkpoint_wall_01_bundle", &scene_callback_checkpoint_left_breach_done, "done" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_checkpoint_wall_02_bundle", &scene_callback_checkpoint_right_breach_play, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_drop_doors_up_bundle", &scene_callback_mobile_wall_doors_up, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_wall_drop_doors_down_bundle", &scene_callback_mobile_wall_doors_down, "play" );
	
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle", &scene_callback_sinkhole_handle_collision, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle", &scene_callback_sinkhole_play_all_bundles, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle", &scene_callback_fxanim_sinkhole_done, "done" );
	
	//billboard in rear
	scene::add_scene_func( "p7_fxanim_cp_ramses_arena_billboard_bundle", &scene_callback_billboard_init, "init" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_arena_billboard_bundle", &scene_callback_billboard_play, "play" );
	
	//billboard on right hand side
	scene::add_scene_func( "p7_fxanim_cp_ramses_arena_billboard_02_bundle", &scene_callback_billboard2_init, "init" );
	
	// cinematics
	scene::add_scene_func( "cin_ram_05_01_block_1st_rip", &scene_callback_intro_done, "done" );
	scene::add_scene_func( "cin_ram_05_01_block_1st_rip", &scene_callback_intro_technical, "done" );
	scene::add_scene_func( "cin_ram_05_01_block_1st_rip_skipto", &scene_callback_intro_technical, "done" );
	
	scene::add_scene_func( "cin_ram_05_02_block_vign_mowed", &scene_callback_intro_technical_murder, "play" );
	
	scene::add_scene_func( "cin_ram_05_01_defend_vign_leapattack", &scene_callback_hendricks_leap_init, "init" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_leapattack", &scene_callback_hendricks_leap_done, "done" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_rescueinjured_l_group", &scene_callback_intro_guys, "play" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_rescueinjured_r_group", &scene_callback_intro_guys, "play" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_rescueinjured_r_group", &scene_callback_intro_guys_r_done, "done" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_rescueinjured_c_group", &scene_callback_intro_guys, "play" );
	scene::add_scene_func( "cin_gen_melee_hendricksmoment_closecombat_robot", &scene_callback_hendricks_vs_robot_init, "init" );
	scene::add_scene_func( "cin_gen_melee_hendricksmoment_closecombat_robot", &scene_callback_hendricks_vs_robot_play, "play" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_car4cover", &scene_callback_car4cover_init, "init" );
	scene::add_scene_func( "cin_ram_05_01_defend_vign_car4cover", &scene_callback_car4cover_done, "done" );
	scene::add_scene_func( "cin_ram_05_02_spike_launcher_plant", &scene_callback_spike_plant_done, "done" );
	
	//scene::add_scene_func( "cin_ram_05_demostreet_vign_intro_hendricks", &scene_callback_demostreet_intro_init, "init" );
	scene::add_scene_func( "cin_ram_05_demostreet_vign_intro_detonation_guy", &scene_callback_demostreet_intro_play, "play" );
	
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh010", &scene_callback_demostreet_detonation_setup, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh010_female", &scene_callback_demostreet_detonation_setup, "play" );
	
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh020", &scene_callback_demostreet_light_blocker, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh020_female", &scene_callback_demostreet_light_blocker, "play" );
	
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh040", &scene_callback_demostreet_robot_hide, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh040_female", &scene_callback_demostreet_robot_hide, "play" );
	
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh080", &scene_callback_demostreet_detonation_play, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh080_female", &scene_callback_demostreet_detonation_play, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh080", &scene_callback_demostreet_detonation_done, "done" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh080_female", &scene_callback_demostreet_detonation_done, "done" );
	
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh140", &scene_callback_demostreet_play_fadeout, "play" );
	scene::add_scene_func( "cin_ram_05_demostreet_3rd_sh140", &scene_callback_demostreet_done, "done" );
}

function init_scenes()
{
	a_scriptbundles = struct::get_array( "arena_defend_friendly_fallback_intro", "targetname" );
	
	foreach ( struct in a_scriptbundles )
	{
		struct scene::init();
	}
	
	level scene::init( "p7_fxanim_cp_ramses_arena_billboard_bundle" );
	level scene::init( "p7_fxanim_cp_ramses_arena_billboard_02_bundle" );
}

function mobile_wall_drops_for_demo()
{	
	level scene::play( "p7_fxanim_cp_ramses_wall_drop_bundle" );
}

function scene_callback_mobile_wall_doors_up( a_ents )
{
	mobile_wall_door_collision_open( true );
}

function scene_callback_mobile_wall_doors_down( a_ents )
{
	mobile_wall_door_collision_open( false );
}

// mobile wall door collision starts in 'closed' state
function mobile_wall_door_collision_open( b_open )
{	
	level flag::wait_till( "arena_defend_mobile_wall_deployed" );  // make sure wall is deployed before messing with collision
	
	const MOVE_DISTANCE = 90;
	const MOVE_TIME = 2.5;
	
	m_collision = GetEnt( "mobile_wall_doors_clip", "targetname" );

	b_should_open = ( !level flag::get( "arena_defend_mobile_wall_doors_open" ) && b_open );
	b_should_close = ( level flag::get( "arena_defend_mobile_wall_doors_open" ) && !b_open );
	
	if ( b_should_open )
	{
		m_collision MoveZ( MOVE_DISTANCE, MOVE_TIME );
		
		m_collision waittill( "movedone" );
		
		m_collision NotSolid();
		m_collision ConnectPaths();
		
		ramses_util::enable_nodes( "mobile_wall_door_traversals", "targetname", true );
		
		level flag::set( "arena_defend_mobile_wall_doors_open" );
	}
	else if ( b_should_close )
	{
		m_collision MoveZ( -MOVE_DISTANCE, MOVE_TIME );
		
		m_collision waittill( "movedone" );
		
		m_collision Solid();
		m_collision DisconnectPaths();
		
		ramses_util::enable_nodes( "mobile_wall_door_traversals", "targetname", false );
		
		level flag::clear( "arena_defend_mobile_wall_doors_open" );
	}
}

function scene_callback_fxanim_wp_01_play( a_ents )
{
	// Kill riders and gunners if alive
	vh_tech_1 = GetEnt( "arena_defend_technical_01_vh", "targetname" );
	
	if ( IsDefined( vh_tech_1 ) )
	{
		vh_tech_1 notify( "kill_passengers" );
		
		waittillframeend;  // let script process passenger deaths
		
		vh_tech_1 Delete();  // animation is going to spawn in a new one
	}
	
	// Disable nodes around truck, enable nodes around pothole
	ramses_util::enable_nodes( "arena_defend_technical_01_vh_covernode", "targetname", false );
}

function scene_callback_fxanim_wp_01_done( a_ents )
{
	vh_technical = a_ents[ "wp_01_technical" ];
	
	vh_technical DisconnectPaths();  // this doesn't happen automatically
}

function scene_callback_fxanim_wp_03_play( a_ents )
{

}

function scene_callback_fxanim_wp_04_play( str_weakpoint_4 )
{	

}

function scene_callback_fxanim_wp_05_play( a_ents )
{
	// TODO: this fxanim doesn't have a bone that rotates on the door hinge, so we have to fake it temporarily
	t_clip = GetEnt( "arena_defend_trailer_door_clip", "targetname" );
	s_hinge = struct::get( "arena_defend_trailer_door_hinge", "targetname" );
	
	e_hinge = util::spawn_model( "tag_origin", s_hinge.origin, s_hinge.angles );
	t_clip LinkTo( e_hinge );
	
	e_hinge RotateYaw( 180, 1 );
	
	e_hinge waittill( "rotatedone" );
	
	e_hinge Delete();
	
	t_clip DisconnectPaths(); //keep AI from trying to walk under the door clip that just rotated open
}

//init and play functions for billboard in the rear
function scene_callback_billboard_init( a_ents )
{
	trigger = GetEnt( "arena_defend_billboard_trigger", "targetname" );
	mdl_clip = GetEnt( "arena_defend_billboard_fxanim_clip", "targetname" );
	
	// make sure AI can run on roof
	mdl_clip NotSolid();
	mdl_clip ConnectPaths();
	
	ramses_util::enable_nodes( "arena_defend_center_building_sniper_nodes_billboard_collapse", "script_noteworthy", true );	
	
	// spike_charge impact registers as "mod_explosion", so we need to detect this manually... (spike_charge = grenade)
	w_spike_charge = GetWeapon( "spike_charge" );
	
	do 
	{
		trigger waittill( "damage", undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, w_attacker );
		
		b_should_play_fxanim = ( IsDefined( w_attacker ) && ( w_attacker == w_spike_charge ) );
	}
	while ( !b_should_play_fxanim );
	
	level thread scene::play( "p7_fxanim_cp_ramses_arena_billboard_bundle" );
}

function scene_callback_billboard_play( a_ents )
{
	// disable nodes and kill spawn manager in this area
	ramses_util::enable_nodes( "arena_defend_center_building_sniper_nodes_billboard_collapse", "script_noteworthy", false );
	spawn_manager::kill( "sm_arena_defend_snipers_center_building" );
	
	//wait for billboard to crash onto the roof
	level waittill( "billboard_crash_notetrack" );
	
	//used to let us know not to spawn any snipers afterward
	level flag::set( "billboard1_crashed" );
	
	//find any AI touching the area the billboard just collapsed on and kill them
	t_kill_billboard_AI = GetEnt( "arena_defend_billboard_trigger", "targetname" );
	
	a_ai = GetAITeamArray( "axis" );
	if( isdefined( a_ai ) )
	{
		for( i = 0; i < a_ai.size; i++ )
		{
			if( a_ai[i] IsTouching( t_kill_billboard_AI ) && IsAlive( a_ai[i] ) )
			{
				a_ai[i] Kill();
			}
		}
	}

	// disable AI pathing	
	mdl_clip = GetEnt( "arena_defend_billboard_fxanim_clip", "targetname" );
	
	mdl_clip Solid();
	mdl_clip DisconnectPaths();
}

//init function for damaging billboard fxanim on right hand side. Currently, no special callback needed for when it plays
function scene_callback_billboard2_init( a_ents )
{
	trigger = GetEnt( "arena_defend_billboard2_trigger", "targetname" );
	
	// spike_charge impact registers as "mod_explosion", so we need to detect this manually... (spike_charge = grenade)
	w_spike_charge = GetWeapon( "spike_charge" );
	
	do 
	{
		trigger waittill( "damage", undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, w_attacker );
		
		b_should_play_fxanim = ( isdefined( w_attacker ) && ( w_attacker == w_spike_charge ) );
	}
	while ( !b_should_play_fxanim );
	
	level thread scene::play( "p7_fxanim_cp_ramses_arena_billboard_02_bundle" );
}

function scene_callback_fxanim_mobile_wall_drop_init( a_ents )
{
	//show intact wall pieces initially (misc_models, script_models, and script_brushmodels );
	level clientfield::set( "arena_defend_mobile_wall_destroyed_swap", 0 );
	level thread show_mobile_wall_building_impact( false );
	level thread show_mobile_wall_sidewalk_impact( false );
	
	//notetracks are in p7_fxanim_cp_ramses_wall_drop_wall_anim
	level util::waittill_notify_or_timeout( "mobile_wall_hit_sidewalk", 15 );
	
	level thread show_mobile_wall_sidewalk_impact( true );
	
	level util::waittill_notify_or_timeout( "mobile_wall_hit_building", 5 );
	
	//wall hits, now show destroyed pieces
	level clientfield::set( "arena_defend_mobile_wall_destroyed_swap", 1 );
	level thread show_mobile_wall_building_impact( true );
}

//handles any script_models, or script_brushmodels
function show_mobile_wall_building_impact( b_enable )
{
	a_models_before = GetEntArray( "mobile_wall_smash_before", "targetname" );
	a_models_after = GetEntArray( "mobile_wall_smash_after", "targetname" );
	
	//show the impact damage
	if ( b_enable )
	{
		foreach( i, model in a_models_before )
		{
			model Hide();
		}
		
		foreach( i, model in a_models_after )
		{
			model Show();
		}
	}
	else
	{
		foreach( i, model in a_models_before )
		{
			model Show();
		}
		
		foreach( i, model in a_models_after )
		{
			model Hide();
		}
	}
}

function show_mobile_wall_sidewalk_impact( b_enable )
{
	a_models_before = GetEntArray( "mobile_wall_sidewalk_smash_before", "targetname" );
		
	//show the impact damage
	if ( b_enable )
	{
		foreach( i, model in a_models_before )
		{
			model Hide();
		}
		
		//Show after models
		level clientfield::set( "arena_defend_mobile_wall_damage", 0 );
	}
	else
	{
		foreach( i, model in a_models_before )
		{
			model Show();
		}
		
		//Hide after models
		level clientfield::set( "arena_defend_mobile_wall_damage", 1 );
	}
}

function scene_callback_fxanim_mobile_wall_drop_play( a_ents )
{
	//wall_drop_wall is spawned in as a server object when p7_fxanim_cp_ramses_wall_drop_bundle is initialized
	e_vtol = GetEnt( "wall_drop_vtol", "targetname" );
	
	level waittill( "fire_rocket_at_vtol" ); //notetracks are in p7_fxanim_cp_ramses_wall_drop_wall_anim
	
	level thread rocket_notify();
	
	weapon = GetWeapon( "smaw" );
	s_vtol_rocket_start = struct::get( "s_vtol_rocket_start", "targetname" );
	
	for ( i = 0; i < 3; i++ )
	{
		//add offset to vtol's origin to account for vtol animating forward the whole time
		a_rockets[i] = MagicBullet( weapon, s_vtol_rocket_start.origin, e_vtol.origin, undefined, e_vtol, ( -300, 0, 400 ) );
		wait 0.25;
	}
	
	level flag::wait_till( "arena_defend_rocket_hits_vtol" );
	
	//if they haven't already hit something, detonate everything
	foreach( e_rocket in a_rockets )
	{
		if ( isdefined( e_rocket ) )
		{
			e_rocket Detonate();
			wait 0.1;
		}
	}
}

function rocket_notify()
{
	level waittill( "rocket_hits_vtol" );
	
	level flag::set( "arena_defend_rocket_hits_vtol" );
}

function scene_callback_fxanim_mobile_wall_drop_done( a_ents )
{
	level flag::set( "arena_defend_mobile_wall_deployed" );

	vehicle::simple_spawn( "arena_defend_mobile_wall_turret", true );
}

function scene_callback_checkpoint_left_breach_init( a_ents )
{
	mdl_checkpoint_wall = GetEnt( "arena_defend_checkpoint_wall_b", "targetname" );
	
	if ( IsDefined( mdl_checkpoint_wall ) )
	{
		mdl_checkpoint_wall DisconnectPaths();	
	}
}

function scene_callback_checkpoint_left_breach_play( a_ents )
{
	// get rid of clip
	mdl_checkpoint_wall = GetEnt( "arena_defend_checkpoint_wall_b", "targetname" );
	
	// detonate all grenades on the wall so they don't hang in the air (this will pick up spikes, sticky grenades, etc.)
	level cleanup_nearby_explosives( mdl_checkpoint_wall );
	
	// get rid of the clip and wall 
	if ( IsDefined( mdl_checkpoint_wall ) )
	{
		mdl_checkpoint_wall ConnectPaths();
		mdl_checkpoint_wall Delete();
	}	
	
	wait 0.1;  // there's a slight timing discrepancy when swapping models, so hide it here
	
	// hide models
	a_models = GetEntArray( "arena_defend_checkpoint_wall_left_models", "script_noteworthy" );
	
	foreach ( mdl_wall in a_models )
	{
		mdl_wall Delete();
	}
}

function scene_callback_checkpoint_left_breach_done( a_ents )
{
	level notify( "checkpoint_wall_breach_complete" );  // easier to read/track than scene name
}

function scene_callback_checkpoint_right_breach_play( a_ents )
{
	// get rid of clip
	mdl_clip = GetEnt( "arena_defend_checkpoint_wall_right_clip", "targetname" );		
	
	// detonate any grenades touching the clip brushes
	level cleanup_nearby_explosives( mdl_clip );
	
	mdl_clip Delete();
	
	wait 0.1;  // there's a slight timing discrepancy when swapping models, so hide it here
	
	// hide models
	a_models = GetEntArray( "arena_defend_checkpoint_wall_right_models", "script_noteworthy" );
	
	foreach ( mdl_wall in a_models )
	{
		mdl_wall Delete();
	}
}

function play_checkpoint_wall_breach_right( a_ents )
{
	// wait until players are looking
	trigger::wait_till( "arena_defend_checkpoint_wall_right_trigger" );
	
	spawn_manager::enable( "sm_wp_04_defenders" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_checkpoint_wall_02_bundle" );
}

function play_checkpoint_wall_breach_left( a_ents )
{
	// Add a short wait so the checkpoint breach doesn't play exactly as the player destroys the nearby sinkhole 
	wait 2.0;
	
	level scene::play( "p7_fxanim_cp_ramses_checkpoint_wall_01_bundle" );
}

// Set up wall fxanim in correct state
// b_active_deploy is true if you want to see it deployed from vtol drop
function wall_fxanim_scene( b_active_deploy = true, b_open_doors = true )
{	
	if ( b_active_deploy )
	{
//		if( ramses_util::is_demo() )
//		{
			mobile_wall_deploy();
//		}		
//		else
//		{
//			mobile_wall_deploy_full();
//		}
	}
	else
	{		
		mobile_wall_deploy_skipto( b_open_doors );  // wall already fully deployed
	}
}

function mobile_wall_deploy_full()
{
	vh_vtol = vehicle::simple_spawn_single( "arena_defend_wall_vtol" );  // vtol that drops wall and flies off
	
	level ramses_util::skipto_notetrack_time_in_animation( %generic::p7_fxanim_cp_ramses_vtol_ride_truck_01_end_anim, "p7_fxanim_cp_ramses_vtol_ride_bundle", "ramses2_start" );  // start at appropriate point for ramses 2 (where geo begins)
	
	//TODO just setting here for now, all this gets ignored anyway during the demo version, revisit for full level
	level flag::set( "intro_technical_dropped_from_vtol" );
	
	level flag::wait_till( "intro_technical_dropped_from_vtol" );
	
	level thread scene::play( "p7_fxanim_cp_ramses_mobile_wall_bundle" );
	level thread scene::play( "p7_fxanim_cp_ramses_mobile_wall_doors_intro_bundle" ); // Doors move with wall	
	
	level scene::play( "cin_ram_05_01_block_1st_rip" );
}

function mobile_wall_deploy_skipto( b_open_doors = true )
{
	level thread scene::skipto_end( "p7_fxanim_cp_ramses_wall_drop_bundle" );
		
	level flag::set( "arena_defend_mobile_wall_deployed" );  // HACK: skipto_end doesn't call "done" callback; this has been reported. -TJanssen 12/2/2014	
	
	if ( b_open_doors )
	{
		mobile_wall_doors_open();
	}
}

function mobile_wall_deploy()
{
	level thread mobile_wall_drops_for_demo(); 

	level scene::play( "cin_ram_05_01_block_1st_rip" );	
}

function mobile_wall_doors_open()
{
	e_doors = GetEnt( "wall_drop_doors", "targetname" );
	
	//manually spawn one in if we're starting from a skipto or something
	if ( !isdefined( e_doors ) )
	{
		e_doors = util::spawn_model( "p7_fxanim_cp_ramses_mobile_wall_doors_mod" );
		e_doors.targetname = "wall_drop_doors";
	}
	
	Assert( isdefined( e_doors ), "Make sure wall_drop_doors was spawned in by the previous VTOL drop animation or is placed in the world" );
	
	level scene::play( "p7_fxanim_cp_ramses_wall_drop_doors_up_bundle", e_doors );
}

function mobile_wall_doors_close()
{
	e_doors = GetEnt( "wall_drop_doors", "targetname" );
	
	//manually spawn one in if we're starting from a skipto or something
	if ( !isdefined( e_doors ) )
	{
		e_doors = util::spawn_model( "p7_fxanim_cp_ramses_mobile_wall_doors_mod" );
		e_doors.targetname = "wall_drop_doors";
	}
	
	Assert( isdefined( e_doors ), "Make sure wall_drop_doors was spawned in by the previous VTOL drop animation or is placed in the world" );
	
	level scene::play( "p7_fxanim_cp_ramses_wall_drop_doors_down_bundle", e_doors );
}

// Weak Points
function weak_points_fxanim_scenes_complete()
{
	level thread scene::skipto_end( "wp_01", "targetname" );
	level thread scene::skipto_end( "wp_02", "targetname" );
	level thread scene::skipto_end( "wp_03", "targetname" );
	level thread scene::skipto_end( "wp_04", "targetname" );
	level thread scene::skipto_end( "wp_05", "targetname" );
}

function weak_points_fxanim_scenes_cleanup()
{
	level scene::stop( "wp_01", "targetname", true );
	level scene::stop( "wp_02", "targetname", true );
	level scene::stop( "wp_03", "targetname", true );
	level scene::stop( "wp_04", "targetname", true );
	level scene::stop( "wp_05", "targetname", true );
}

function chain_explosion_fxanim_scenes( a_ents )
{
	t_detonate = GetEnt( "ad_detonator_trig", "targetname" );
	
	e_grenade = GetEnt( "sinkhole_grenade_ent", "targetname" );
	a_s = struct::get_array( t_detonate.target, "targetname" );
	
	foreach( s in a_s )
	{
		s thread _chain_explosion_fxanim_think( e_grenade );
	}
}

// TODO: fx, fxanim
// Self is struct
function _chain_explosion_fxanim_think( e )
{
	s_start = self;
	while( IsDefined( s_start.target ) )
	{
		s = struct::get( s_start.target, "targetname" );
		e MagicGrenadeType( GetWeapon( "frag_grenade" ), s.origin, ( 0, 0, 1 ), .1 );
		s_start = s;
		
		wait .25;
	}
}

// Sinkhole

function init_sinkhole()
{
	level.a_m_sinkhole_hide_props = [];
	
	a_m_props = GetEntArray( "arena_defend_models", "targetname" );
	a_m_sinkhole = GetEntArray( "arena_defend_sinkhole", "targetname" );
	s_street_spot = struct::get( "sinkhole_street_spot", "targetname" );
	
	foreach( m in a_m_props )
	{
		if( !IsDefined( m.script_noteworthy ) || m.script_noteworthy != "ignore_paths" )
		{
			m DisconnectPaths();
		}
	}
	a_m_sinkhole ramses_util::hide_ents();
}
// Self is script model
// TODO: need to have this set up in a way where this isn't needed anymore
/* Props linked to tags -----------------------------------------
 	In fxanim:
 	linked_bus01_jnt……………………….
	linked_car01_jnt………………………..veh_t7_civ_sedan_standard_org_dead
	linked_car02_jnt………………………..veh_t7_civ_sedan_standard_org_dead
	linked_car03_jnt………………………..veh_t7_civ_sedan_standard_org_dead
	linked_car04_jnt…………………………veh_t7_civ_sedan_standard_org_dead
	linked_car05_jnt………………………..veh_t7_civ_sedan_standard_org_dead
	linked_tailer01_jnt……………………..veh_t6_civ_18wheeler_trailer
	linked_truck_tanker01_jnt…………vehicle_tanker_truck_d
	linked_van01_jnt…………………………veh_t6_v_van_whole
	linked_van02_jnt…………………………veh_t6_v_van_whole
	
	In script:
	linked_truck_tractor01_jnt………..veh_t6_civ_18wheeler_cab
	linked_truck_trailer01_jnt…………..nt_2020_truck_01
*/
function scene_callback_sinkhole_handle_collision( a_ents )
{	
	mdl_street = a_ents[ "street_collapse_big_hole" ];
	
	a_mdl_street_collision = GetEntArray( "arena_defend_street_col", "targetname" );
	
	foreach ( model in a_mdl_street_collision )
	{
		model LinkTo( mdl_street, "bck_ground_sec_07_jnt" );
	}
}

function scene_callback_sinkhole_play_all_bundles( a_ents )
{
	level notify( "sinkhole_vehicle_fall" );
	
	// IMPORTANT: this numbering convention matches #define FXANIM_WP_* at the top of this file
	play_scene_on_existing_fxanim_model( "small_hole_01", "p7_fxanim_cp_ramses_street_collapse_small_hole_02_drop_bundle", "wp_01_technical" );  // wp_01
	play_scene_on_existing_fxanim_model( "small_hole_02", "p7_fxanim_cp_ramses_street_collapse_small_hole_05_drop_bundle" );  // wp_02
	play_scene_on_existing_fxanim_model( "small_hole_03", "p7_fxanim_cp_ramses_street_collapse_small_hole_01_drop_bundle" );  // wp_03
	play_scene_on_existing_fxanim_model( "small_hole_04", "p7_fxanim_cp_ramses_street_collapse_small_hole_03_drop_bundle" );  // wp_04
	play_scene_on_existing_fxanim_model( "small_hole_05", "p7_fxanim_cp_ramses_street_collapse_small_hole_04_drop_bundle" );  // wp_05
	
	//since this is unable to be animated with the truck in p7_fxanim_cp_ramses_street_collapse_small_hole_04_drop_bundle, just delete it. Can't see it anyway
	e_truck_cargo = GetEnt( "street_collapse_trailer_cargo", "targetname" );
	if ( isdefined( e_truck_cargo ) )
	{
		e_truck_cargo Delete();
	}
}

function play_scene_on_existing_fxanim_model( str_fxanim_targetname, str_scene, a_object_targetnames )
{
	mdl_fxanim = GetEnt( str_fxanim_targetname, "targetname" );
	Assert( IsDefined( mdl_fxanim ), "play_scene_on_existing_fxanim_model: " + str_fxanim_targetname + " entity is missing!" );
	
	a_models = [];
	if ( !isdefined( a_models ) ) a_models = []; else if ( !IsArray( a_models ) ) a_models = array( a_models ); a_models[a_models.size]=mdl_fxanim;;
	
	// optional scene objects	
	if ( IsDefined( a_object_targetnames ) )
	{
		if ( !IsArray( a_object_targetnames ) )
		{
			a_object_targetnames = Array( a_object_targetnames );
		}
		
		foreach ( str_targetname in a_object_targetnames )
		{
			ent = GetEnt( str_targetname, "targetname" );
			
			if ( !isdefined( a_models ) ) a_models = []; else if ( !IsArray( a_models ) ) a_models = array( a_models ); a_models[a_models.size]=ent;;
		}
	}
	
	mdl_fxanim thread scene::play( str_scene, a_models );
}

function scene_callback_fxanim_sinkhole_done( a_ents )
{
	level flag::set( "sinkhole_collapse_complete" );
}

function scene_callback_demostreet_intro_init( a_ents )  // self = scriptbundle
{
	//TODO look more into all this to try to prevent popping into place for scene, while also not needing to wait for AI that can get stuck on stuff
	vignette_get_hero( "hendricks", "hendricks_mobile_wall_start_node", "hendricks" );
	vignette_get_hero( "khalil", "arena_defend_demostreet_intro_khalil", "khalil" );
	
	self flag::wait_till_all( self.a_scene_flags );
	
	//give some time for Hendricks and Khalil to do initial backwards run animation, notetrack is in ch_ram_05_demostreet_vign_intro_hendricks_initial
	level util::waittill_notify_or_timeout( "vign_intro_runback_done", 5 );
	
	self notify( self.scriptbundlename + "_starting" );

	level thread scene::play( "cin_ram_05_demostreet_vign_intro_detonation_guy" );
	level thread scene::play( "cin_ram_05_demostreet_vign_intro_khalil" , level.ai_khalil );
	self scene::play( self.scriptbundlename , level.ai_hendricks );
}

function scene_callback_demostreet_detonation_setup( a_ents )
{	
	level flag::set( "arena_defend_sinkhole_igc_started" );
	
	//no longer need the detonation guy and his ipad from the previous scene, new scene has a dead body built-in
	e_detonation_guy = GetEnt( "detonation_guy", "targetname" );
	e_detonation_guy_ipad = GetEnt( "detonator", "targetname" );
	
	if ( isdefined( e_detonation_guy ) )
	{
		e_detonation_guy Delete();
	}
	
	if ( isdefined( e_detonation_guy_ipad ) )
	{
		e_detonation_guy_ipad Delete();
	}
	
	level thread swap_sinkhole();
}

function swap_sinkhole()
{
	wait 0.5; //let scene of player picking up the tablet run a bit before swapping the sinkhole
	
	level thread arena_defend::sinkhole_fxanim_hide_everything_in_street( false );
	util::wait_network_frame();
	level scene::init( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle" );  // show fxanim start model
}

//runs on shot demostreet_3rd_sh020
function scene_callback_demostreet_light_blocker( a_ents )
{
	a_shadow_blockers = GetEntArray( "lgt_shadow_block", "targetname" );

	foreach ( blocker in a_shadow_blockers )
	{
		blocker Show();
	}
}

function scene_callback_demostreet_robot_hide( a_ents )
{	
	//hide the swapped in versions until they need to show up in the animation. Model's built-in versions get hidden at that point
	a_ents[ "robot_arm" ] Hide();
	a_ents[ "robot_head" ] Hide();
	a_ents[ "robot_missing_arm" ] Hide();
	a_ents[ "robot_missing_arm_head" ] Hide();

	a_ents[ "robot_intact" ] waittill( "hide_rarm" );
	
	//hide the intact robot, and show the arm getting shot off
	a_ents[ "robot_intact" ] SetModel( "c_54i_robot_grunt_dam_dps_rarmoff" );
	
	//this should show regardless, animated piece flying off
	a_ents[ "robot_arm" ] Show();
		
	a_ents[ "robot_intact" ] waittill( "hide_head" );
	
	//hide the robot with his arm shot off, and now show its head getting shot off
	a_ents[ "robot_intact" ] DetachAll();
	a_ents[ "robot_intact" ] SetModel( "c_54i_robot_grunt_dam_dps_rarmoff_headoff" );
	
	//this should show regardless, animated piece flying off
	a_ents[ "robot_head" ] Show();
}

function scene_callback_demostreet_detonation_play( a_ents )
{
	level waittill( "start_sinkhole_collapse" );  // comes from notetrack in xanim 'ch_ram_05_demostreet_3rd_sh080_player'
	
	level flag::set( "sinkhole_charges_detonated" );
	
	fxanim_sinkhole_play();
}

//after sinkhole explosion, and before final conversation scene
function scene_callback_demostreet_detonation_done( a_ents )
{
	//there might be some stray wasps or other enemies who some avoided the sinkhole
	array::run_all( GetAITeamArray( "axis" ), &Delete );
}

//a couple seconds before the scene ends, start the fadeout
function scene_callback_demostreet_play_fadeout( a_ents )
{	
	//notetrack is in pb_ram_05_demostreet_3rd_sh140_viewbody.xanim, part of cin_ram_05_demostreet_3rd_sh140
	level util::waittill_notify_or_timeout( "start_level_fade_out", 4 );

	if ( ramses_util::is_demo() )
	{		
		//fade_out_for_demo();
		util::screen_fade_out( 1.5 );
	}
	
}

function scene_callback_demostreet_done( a_ents )
{
	level flag::set( "arena_defend_sinkhole_collapse_done" );
	
	level thread ramses_util::post_fx_transitions("dni_futz");
	
	a_shadow_blockers = GetEntArray( "lgt_shadow_block", "targetname" );

	foreach ( blocker in a_shadow_blockers )
	{
		blocker Hide();
	}
	
	util::clear_streamer_hint();
}

function scene_callback_demostreet_intro_play( a_ents )  // self = scriptbundle
{
	ai_guy = a_ents[ "detonation_guy" ];
	
	ai_guy waittill( "detonator_dropped" );  // sent from notetrack on xanim 'ch_ram_05_demostreet_vign_intro_detonation_guy'
	
	mdl_detonator = a_ents[ "detonator" ];
	mdl_detonator.script_noteworthy = "arena_defend_detonator_pickup_model";  // give this a more descriptive script_noteworthy so objective thread can use it
	
	mdl_detonator oed::enable_keyline( true );

	// spawn in trigger to start next IGC
	const TRIGGER_SPAWN_FLAGS = 0;
	const TRIGGER_RADIUS = 85;
	const TRIGGER_HEIGHT = 128;
	
	trigger = Spawn( "trigger_radius", mdl_detonator.origin, TRIGGER_SPAWN_FLAGS, TRIGGER_RADIUS, TRIGGER_HEIGHT );
	
	trigger TriggerIgnoreTeam();
	trigger SetVisibleToAll();
	trigger SetTeamForTrigger( "none" );
	trigger SetCursorHint( "HINT_NOICON" );	
	
	trigger.targetname = "arena_defend_detonator_pickup";  // give this a targetname so other threads can use it
	
	util::wait_network_frame();  // since objective thread is setting a 3d marker on the trigger, give it a moment for the coordinates to line up on client
	
	level flag::set( "arena_defend_detonator_dropped" );
}

function scene_callback_hendricks_leap_init( a_ents )
{
	self util::delay_notify( 30, self.scriptbundlename + "_cancelled" );  // if this doesn't work in 30 seconds, forget it
	
	// note: use third param as object name from GDT to match scene system
	vignette_get_hero( "hendricks", "arena_defend_vignette_hendricks_leap_hendricks", "hendricks" );
	vignette_get_redshirt( "axis", "human", "arena_defend_vignette_hendricks_leap_guy_front", "guy_shot" );
	vignette_get_redshirt( "axis", "human", "arena_defend_vignette_hendricks_leap_guy_rear", "guy_grenade" );
	
	self flag::wait_till_all( self.a_scene_flags );
	
	self notify( self.scriptbundlename + "_starting" );
	
	level notify( "hendricks_leap_started" );
	
	self scene::play( self.a_actors );
}

function vignette_get_redshirt( str_faction, str_type, str_node, str_flag, str_endon, n_distance_override )  // self = scene struct
{
	if ( IsDefined( str_endon ) )
	{
		self endon( str_endon );
	}
	
	if ( !self flag::exists( str_flag ) )
	{
		if(!isdefined(self.a_scene_flags))self.a_scene_flags=[];
		if ( !isdefined( self.a_scene_flags ) ) self.a_scene_flags = []; else if ( !IsArray( self.a_scene_flags ) ) self.a_scene_flags = array( self.a_scene_flags ); self.a_scene_flags[self.a_scene_flags.size]=str_flag;;
		
		self flag::init( str_flag );
	}
	
	self flag::clear( str_flag );
	
	self thread _vignette_get_redshirt( str_faction, str_type, str_node, str_flag, str_endon, n_distance_override );
}

function _vignette_get_redshirt( str_faction, str_type, str_node, str_flag, str_endon, n_distance = 400 )
{
	self endon( self.scriptbundlename + "_starting" );
	self endon( self.scriptbundlename + "_cancelled" );
	
	// find a guy nearby and start the animation
	if(!isdefined(self.a_actors))self.a_actors=[];
	
	do 
	{
		ai_guy = send_ai_type_within_radius_to_node( str_type, str_faction, str_node, n_distance, 0 );
	}
	while ( !IsDefined( ai_guy ) || !IsAlive( ai_guy ) );	
	
	self flag::set( str_flag );
	self.a_actors[ str_flag ] = ai_guy;  // string index this array so scene system can play correct scene on appropriate entity
	
	ai_guy util::waittill_any( "death", "start_ragdoll" );
	
	ArrayRemoveValue( self.a_actors, ai_guy, false );
	
	// call back into this if guy dies before we're ready
	self vignette_get_redshirt( str_faction, str_type, str_node, str_flag, str_endon );	
}

function vignette_get_hero( str_hero, str_node, str_flag )
{
	if(!isdefined(self.a_actors))self.a_actors=[];
	self.a_actors[ str_flag ] = util::get_hero( str_hero );  // string index array so scene system can play correct animation on specific entity
	
	if ( !self flag::exists( str_flag ) )
	{
		if(!isdefined(self.a_scene_flags))self.a_scene_flags=[];
		if ( !isdefined( self.a_scene_flags ) ) self.a_scene_flags = []; else if ( !IsArray( self.a_scene_flags ) ) self.a_scene_flags = array( self.a_scene_flags ); self.a_scene_flags[self.a_scene_flags.size]=str_flag;;		
		
		self flag::init( str_flag );
	}
	
	self thread _vignette_get_hero( str_hero, str_node, str_flag );
}

function _vignette_get_hero( str_hero, str_node, str_flag )
{
	const GOAL_RADIUS = 32;
	
	ai_hero = util::get_hero( str_hero );
	
	nd_goal = GetNode( str_node, "targetname" );
	Assert( IsDefined( nd_goal ), "vignette_get_hero can't find node for " + str_hero + " in scene " + self.scriptbundlename );
	
	n_goalradius = ai_hero.goalradius;
	ai_hero.goalradius = GOAL_RADIUS;

	if ( ai_hero colors::has_color() )
	{
		ai_hero colors::disable();
	}
	
	ai_hero SetGoal( nd_goal, true );
	
	ai_hero util::waittill_any_timeout( 15, "goal" );
	
	self flag::set( str_flag );	
	
	self util::waittill_any( self.scriptbundlename + "_starting", self.scriptbundlename + "_cancelled" );
	
	ai_hero.goalradius = n_goalradius;
	
	if ( ai_hero colors::has_color() )
	{
		ai_hero colors::enable();
	}	
}

function scene_callback_car4cover_init( a_ents )
{
	// find a guy nearby and start the animation
	do 
	{
		ai_guy = send_ai_type_within_radius_to_node( "human", "axis", "arena_defend_car4cover_node", 400, 0 );
	}
	while ( !IsDefined( ai_guy ) || !IsAlive( ai_guy ) );
	
	//level thread scene::play( "cin_ram_05_01_defend_vign_car4cover", ai_guy );
}

function scene_callback_car4cover_done( a_ents )
{	
	nd_goal = GetNode( "arena_defend_car4cover_node", "targetname" );
	SetEnableNode( nd_goal, true );
	
	ai_guy = a_ents[ "nrc_soldier" ];
	
	if ( IsDefined( ai_guy ) && IsAI( ai_guy ) )  // SetGoal call will error out if playing on a model through the scene menu
	{
		ai_guy SetGoal( nd_goal );
	}
}

function scene_callback_hendricks_vs_robot_play( a_ents )
{
	if ( IsDefined( level.ai_hendricks.goalradius_old ) )
	{
		level.ai_hendricks.goalradius = level.ai_hendricks.goalradius_old;
		level.ai_hendricks.goalradius_old = undefined;
	}
	
	level.ai_hendricks colors::enable();
}

function scene_callback_hendricks_vs_robot_init( a_ents )  // self = scene bundle
{
	level endon( "all_weak_points_destroyed" );  // don't continue to try this once all the weak points have been destroyed
	
	self flag::init( "hendricks_ready" );
	
	self thread hendricks_robot_melee_setup_hendricks();
	ai_robot = self hendricks_robot_melee_setup_robot();
	
	ai_robot endon( "death" );
	
	self flag::wait_till( "hendricks_ready" );

	// string index entities so scene system plays correct scene on appropriate ent; should match object name in GDT
	a_actors = [];
	a_actors[ "hendricks" ] = level.ai_hendricks;
	a_actors[ "robot" ] = ai_robot;  
	
	level scene::play( "cin_gen_melee_hendricksmoment_closecombat_robot", a_actors );  // scene played from within 'init' call	
}

function hendricks_robot_melee_setup_hendricks()  // this should always be threaded
{
	// bring hendricks to starting position
	nd_hendricks = GetNode( "melee_robot_vignette_goal_hendricks", "targetname" );
	
	level.ai_hendricks colors::disable();
	
	level.ai_hendricks.goalradius_old = level.ai_hendricks.goalradius;
	level.ai_hendricks.goalradius = 32;
	
	level.ai_hendricks ai::force_goal( nd_hendricks );
	
	level.ai_hendricks waittill( "goal" );	
	
	self flag::set( "hendricks_ready" );
}

function hendricks_robot_melee_setup_robot()
{
	// find robot nearby
	do 
	{
		ai_robot = send_ai_type_within_radius_to_node( "robot", "axis", "melee_robot_vignette_goal_robot", 1000, 0 );
	}
	while ( !IsDefined( ai_robot ) || !IsAlive( ai_robot ) );
	
	return ai_robot;
}

function enable_car4cover_vignette()
{
	wait RandomFloatRange( 4, 8 );  // delay this since players may still be looking at destruction from wp_01
	
	//level thread scene::init( "cin_ram_05_01_defend_vign_car4cover" );  // nrc car4cover vignette	
}

function scene_callback_intro_guys( a_ents )
{
	foreach ( ent in a_ents )
	{
		if ( IsAI( ent ) )
		{
			ent thread guarantee_life_for_time( 10 );
			ent thread stay_at_goal_for_time( 15 );
			ent SetGoal( ent.origin );  // these guys don't spawn in place, so set their goals to their current position to fix pathing issue
		}
	}
}

//make first turret guy vulnerable again
function scene_callback_intro_guys_r_done( a_ents )
{
	level notify( "first_turret_guy_vulnerable" );
}

function stay_at_goal_for_time( n_time )
{
	self endon( "death" );
	
	n_goalradius_old = self.goalradius;
	self.goalradius = 64;
	
	self SetGoal( self.origin );
	
	wait n_time;
	
	self.goalradius = n_goalradius_old;
}

function guarantee_life_for_time( n_time )
{
	self endon( "death" );  // in case of delete
	
	self ai::set_ignoreme( true );
	
	level util::waittill_notify_or_timeout( "all_weak_points_destroyed", n_time );
	
	self ai::set_ignoreme( false );
}

function scene_callback_hendricks_leap_done( a_ents )
{
	nd_end_goal = GetNode( "hendricks_leap_end_node", "targetname" );
	Assert( IsDefined( nd_end_goal ), "scene_callback_hendricks_leap_done: hendricks_leap_end_node is missing!" );
	
	level.ai_hendricks colors::disable();
	
	level.ai_hendricks SetGoal( nd_end_goal );
	
	wait RandomFloatRange( 5, 8 );  // hendricks takes cover here for a while before going back to color chain
	
	level.ai_hendricks colors::enable();
}

function scene_callback_intro_done( a_ents )
{
	skipto::teleport_players( "arena_defend" );
	
	// force weapon switch to spike launcher (players pick it up in intro anim)
	foreach ( player in level.players )
	{
		player SwitchToWeaponImmediate( GetWeapon( "spike_launcher" ) );
	}
	
	util::clear_streamer_hint();
}

function scene_callback_intro_technical( a_ents )
{
	vh_truck = a_ents[ "technical" ];
	
	vh_truck DisconnectPaths();	
	
	// HACK: animation currently puts Hendricks inside technical at the end of his animation - teleport him until this is updated
	if ( IsDefined( a_ents[ "hendricks" ] ) )
	{
	    skipto::teleport_ai( "arena_defend" );
	}
}

function sinkhole_fxanim_hide_everything_in_street( b_delete_collision = false )
{
	init_sinkhole();
	
	level.a_m_sinkhole_hide_props = GetEntArray( "arena_defend_models", "targetname" );
	a_m_street = GetEntArray( "arena_defend_street", "targetname" );
	a_m_sinkhole = GetEntArray( "arena_defend_sinkhole", "targetname" );
	s_street_spot = struct::get( "sinkhole_street_spot", "targetname" );
	
	util::wait_network_frame();
	
	array::delete_all( level.a_m_sinkhole_hide_props );
	util::wait_network_frame();
	array::delete_all( a_m_street );
	util::wait_network_frame();
	a_m_sinkhole ramses_util::show_ents();

	util::wait_network_frame();
	
	level clientfield::set( "arena_defend_hide_sinkhole_models", 1 );
	level clientfield::increment( "clear_all_dyn_ents", 1 );
	
	//TODO was function a possible cause for DT 35704? comment out for now and revisit
	//weak_points_fxanim_scenes_cleanup();
	
	// during normal playthrough, street collision is handled through a fxanim callback, not here
	if ( b_delete_collision )
	{
		a_mdl_street_collision = GetEntArray( "arena_defend_street_col", "targetname" );	
		
		foreach ( model in a_mdl_street_collision )
		{
			model Delete();
		}
	}
	
	// get rid of quad tank on flatbed truck
	if ( level scene::is_active( "cin_ram_05_01_quadtank_flatbed_pose" ) )
	{
		level scene::stop( "cin_ram_05_01_quadtank_flatbed_pose", true );
	}
	
	//cleanup animations on injured guys that were in loops at the beginning	
	if ( level scene::is_active( "cin_ram_05_01_defend_vign_rescueinjured_l_group" ) )
	{
		level scene::stop( "cin_ram_05_01_defend_vign_rescueinjured_l_group", true );	
	}
	
	if ( level scene::is_active( "cin_ram_05_01_defend_vign_rescueinjured_r_group" ) )
	{
		level scene::stop( "cin_ram_05_01_defend_vign_rescueinjured_r_group", true );
	}
}

function fxanim_sinkhole_play( b_play_full_anim = true )
{
	if ( b_play_full_anim )
	{
		level thread scene::play( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle" );
	}
	else 
	{
		level thread scene::skipto_end( "p7_fxanim_cp_ramses_street_collapse_big_hole_bundle" );
	}
}

// TODO: will need to remove most of this and add the door clips brushmodels
function cleanup_wall()
{
	a_m_wall = GetEntArray( "checkpoint_wall", "targetname" );
	m_wall = GetEnt( "mobile_wall_model", "targetname" );
	a_m_wall_clip = GetEntArray( "mobile_wall_clip", "targetname" );
	m_wall_doors = GetEnt( "mobile_wall_doors_model", "targetname" );
	
	if( IsDefined( m_wall ) )
	{
		m_wall Delete();
	}
	array::delete_all( a_m_wall );
	array::delete_all( a_m_wall_clip );
	if( IsDefined( m_wall_doors ) )
	{
		m_wall_doors Delete();
	}
}

// Hunter Crash Fx Anims
////////////////////////////////////////////////////////////////////

function hunter_crash_fx_anims()
{
	//level clientfield::set( "arena_defend_fxanim_hunters", 1 ); //TODO put this back in once it stops crashing the game
}

function stop_hunter_crash_fx_anims()
{
	level clientfield::set( "arena_defend_fxanim_hunters", 0 );
}

// Objectives
////////////////////////////////////////////////////////////////////

function objectives()
{
	s_defend = struct::get_array( "arena_defend_defend_obj", "targetname" );
	a_t = GetEntArray( "ad_weak_point_trig", "targetname" );
	
	level waittill( "vo_weak_points_identify_said" );
	
	level flag::set( "weak_points_objective_active" );
	objectives::set( "cp_level_ramses_destroy_weakpoints" );
	
	level flag::wait_till( "all_weak_points_destroyed" );
	
	level flag::clear( "weak_points_objective_active" );
	objectives::complete( "cp_level_ramses_destroy_weakpoints" );
	
	objectives::breadcrumb( "cp_level_ramses_reinforce_safiya_breadcrumb", "arena_defend_wall_gather_trig" );
	objectives::complete( "cp_level_ramses_reinforce_safiya_breadcrumb" );
	
	level flag::wait_till( "arena_defend_detonator_dropped" );
	
	m_button = GetEnt( "arena_defend_detonator_pickup_model", "script_noteworthy" );
	objectives::set( "cp_level_ramses_detonate_street_charges", m_button );
	
	level flag::wait_till( "arena_defend_sinkhole_igc_started" );
	
	objectives::complete( "cp_level_ramses_detonate_street_charges" );
}

// Self is trigger damage
function weak_point_objective_think()
{
	m_model = GetEnt( self.target, "targetname" );
	
	level waittill( self.script_string + "_identified" );
	objectives::set( "cp_level_ramses_destroy", m_model );
	
	m_model waittill( "destroyed" );
	objectives::complete( "cp_level_ramses_destroy", m_model );
}

// VO
////////////////////////////////////////////////////////////////////

/*
 * Blockout Temp VO
    * cp Ramses Station 4 1 1 Khalil The NRC have breached the checkpoint. We have to push them back! khal_the_nrc_have_breache_0
	* cp Ramses Station 4 2 1 Khalil We have to take the street down to stop them. Weaken the structure with the Spike Launcher! khal_we_have_to_take_the_0
	* cp Ramses Station 4 2 2 Kane I've identified structural weak points in the street. Hud has been updated. rach_i_ve_identified_stru_0
	* cp Ramses Station 4 2 3 Hendricks Okay, weak point identfied. Destroy the first weak point with the Spike Launcher! hend_okay_weak_point_ide_0
	* cp Ramses Station 4 2 4 Kane Additional weak points identified. rach_additional_weak_poin_0
	* cp Ramses Station 4 2 5 Hendricks Destroy the next two weak points. hend_destroy_the_next_two_0
	* cp Ramses Station 4 2 6 Kane Final weak points have been identified. rach_final_weak_points_ha_0
	* cp Ramses Station 4 2 7 Hendricks Last two weak points have been identified. Destroy them with the Spike Launcher. hend_last_two_weak_points_0
	* cp Ramses Station 4 2 8 Kane Confirm destruction of the final two weak points. rach_confirm_destruction_0
	* cp Ramses Station 4 3 1 Hendricks Regroup behind the mobile defense wall and detonate the charges. hend_regroup_behind_the_m_0
	* cp Ramses Station 4 4 1 Khalil Get on top of wall, we need to detonate the charges to drop the street to cut off the NRC. khal_get_on_top_of_wall_0
 */

//vo utility functions


function vo_find_closest_redshirt_for_dialog()
{	
	a_friendly = GetActorTeamArray( "allies" );
	
	//get rid of heroes and dead people
	foreach ( ai in a_friendly )
	{
		if ( IsInArray( level.heroes, ai ) || !IsAlive( ai ) )
		{
			ArrayRemoveValue( a_friendly, ai );
		}
	}
	
	//just find closest to first player for now
	a_friendly_closest = ArraySortClosest( a_friendly, level.players[0].origin );
	
	return a_friendly_closest[0];
}

function vo_pick_random_line( a_dialogue_lines )
{
	n_line = RandomIntRange( 0, a_dialogue_lines.size );
	
	return a_dialogue_lines[n_line];
}


//dialogue events


function vo_spike_launched_enemy_tracker()
{
	level endon( "all_weak_points_destroyed" );
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl1_enemy_down_0"; //Enemy down!
	a_dialogue_lines[1] = "egy2_that_s_a_bad_way_to_0"; //That’s a bad way to go...
	a_dialogue_lines[2] = "esl3_it_went_right_throug_0"; //It went right through him!
	a_dialogue_lines[3] = "esl4_he_got_torn_up_0"; //He got torn up!
	
	
	while ( true )
	{
		//wait for first time player hits enemy with spike launcher
		level waittill( "enemy_hit_by_spike" );
		
		//say a line in response
		ai_guy = vo_find_closest_redshirt_for_dialog();
		ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ) );
		
		//wait a while before being anyone can comment on this again
		wait RandomIntRange( 90, 120 );
	}
}

//self is an AI
//TODO logic seems sound, but the weapon value condition never passes, so the notify is never reached. Need to find out why
function spike_launcher_damage_watcher()
{
	self endon( "death" );
	level endon( "all_weak_points_destroyed" );
    
    while( true )
    {
        self waittill( "damage", n_damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );
            
        if( weapon === level.W_SPIKE_LAUNCHER )    
        {
        	level notify ( "enemy_hit_by_spike" );
            break;            
        }
    }
}

function vo_weak_point_initial_search()
{
	level endon ( "vo_technical_started" );
	level endon ( "vo_weak_point_started" );
	
	e_player = level.players[0];
	
	//level.players[0] dialog::say( "plyr_kane_can_you_scan_0" ); //Kane - can you scan the City Archives? Show us  where the supports are located?
	
	level dialog::remote( "kane_on_it_may_take_so_0" ); //On it... May take some time.
	
	level dialog::remote( "ecmd_nrc_reinforcements_f_0" ); //NRC Reinforcements five minutes out!
	
	level dialog::remote( "kane_got_to_give_me_time_0" ); //Got to give me time. Key systems are down - I’m doing this by eye!
	
	level.players[0] dialog::say( "plyr_we_don_t_have_time_0" ); //We don’t have time!
}

function vo_weak_point_first_intro()
{
	level notify( "vo_weak_point_started" );
	
	// play VO for reaction
	level thread dialog::remote( "kane_okay_i_ve_located_t_0" ); // Kane - Okay! I’ve located the southbound tunnel supports!
	
	wait 1; //allow a little bit of Rachel's line to start playing before starting movie showing weak point
	
	level thread lui::play_movie( "cp_ramses2_pip_unstableground", "pip" );
	
	wait 3; //allow hud to update while pip movie is in progress
	
	level notify( "vo_weak_points_identify_said" );
}

function vo_first_technical_drive_up()
{
	level notify( "vo_technical_started" );
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl3_eyes_on_enemy_techni_0"; //Eyes on enemy Technical at the Western Checkpoint!
	a_dialogue_lines[1] = "esl4_hostile_technical_mo_0"; //Hostile Technical moving through Southwest checkpoint!
	
	ai_guy = vo_find_closest_redshirt_for_dialog();
	ai_guy dialog::say( vo_pick_random_line( a_dialogue_lines ), 1 );
	
	level.ai_hendricks dialog::say( "hend_someone_move_on_that_0" ); //Someone move on that Technical!
}

function vo_weak_point_first_found()
{	
	level.ai_hendricks thread dialog::say( "hend_target_confirmed_0", 1 ); // Hendricks - "Target confirmed. Hit it, I’ll cover you.
	
	level waittill( "player_plants_spike" );
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "hend_blow_that_fucker_0"; //Blow that fucker!
	a_dialogue_lines[1] = "hend_blow_it_now_0"; //Blow it now!
	
	level.ai_hendricks dialog::say( vo_pick_random_line( a_dialogue_lines ), 1 );
}

function vo_weak_point_first_destroyed()
{
	level.players[0] dialog::say( "plyr_detonation_confirmed_0", 1 ); //Detonation confirmed.
	
	level.ai_hendricks dialog::say( "hend_move_up_right_side_0", 1 ); //Move up, right side of the tent!
}

function vo_wasp_and_robot_jumper_entrance()
{
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl4_enemy_wasps_incoming_0"; //Enemy WASPs incoming!
	a_dialogue_lines[1] = "esl3_hostile_wasps_inboun_0"; //Hostile WASPs inbound!
	a_dialogue_lines[2] = "egy2_grab_some_cover_was_0"; //Grab some cover, WASPs incoming!
	a_dialogue_lines[3] = "esl1_eyes_up_wasps_spot_0"; //Eyes up - WASPs spotted!
	
	ai_guy = vo_find_closest_redshirt_for_dialog();
	ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ) );
	
	wait 3; //allow some time for wasps to fly in before doing robot jumper stuff
	
	//also trigger jumping robots in the area
	spawn_manager::enable( "sm_wp_03_defenders_jumpers" );
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl1_i_got_grunts_scaling_0"; //I got grunts scaling the checkpoint wall!
	a_dialogue_lines[1] = "egy2_heads_up_hostile_0"; //Heads up -- Hostile Grunts coming over the wall!
	a_dialogue_lines[2] = "esl3_look_out_enemy_grun_0"; //Look out! Enemy grunts climbing the checkpoint!
	
	ai_guy = vo_find_closest_redshirt_for_dialog();
	ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ) );
}

function vo_weak_point_second_found()
{	
	level thread dialog::remote( "kane_two_more_in_the_nort_0" ); // Two more in the north line -  sending your way.
	
	wait 0.5; //allow a little bit of Rachel's line to start playing before starting movie showing weak point
	
	wait 2; //wait a bit after movie shows up for player to acknowledge
	
	level.players[0] dialog::say( "plyr_copy_that_hendricks_0" ); //Copy that. Hendricks, cover me!
	
	level.ai_hendricks dialog::say( "hend_you_re_good_go_0", 1 ); // You’re good, GO.	
}

function vo_checkpoint_wall_breached()
{

}

function vo_weak_point_second_wave_destroyed()
{
	
}

function vo_weak_point_third_found()
{
	//TODO two left, but she only shows one at a time. Better dialogue line needed?
	level.ai_hendricks dialog::say( "hend_we_need_those_locati_0" ); //We need those locations, Kane.
	
	level thread dialog::remote( "kane_last_two_0", 1); //Last two.
}

function vo_weak_point_last_group()
{
	//TODO current gameplay only has 1 final weak point at the end, need line for that
	
	wait 0.75; //allow a little bit of Rachel's line to start playing before starting movie
	
	level dialog::remote( "ecmd_nrc_reinforcements_i_0" ); //NRC Reinforcements inbound, ETA one minute.
	
	level.ai_hendricks thread dialog::say( "hend_last_two_weak_points_0", 1 ); // Hendricks - Last two weak points have been identified. Destroy them with the Spike Launcher. 
	
	level waittill( "player_plants_spike" );
	
	level.ai_hendricks thread dialog::say( "hend_blow_it_0", 2 ); // Blow it!
}

function vo_weak_points_all_destroyed()
{
	level.ai_hendricks dialog::say( "hend_that_s_it_we_got_0", 1 ); // Hendricks - That’s it - we got ‘em all! Fall back to the wall - GO, GO, GO!!
	
	if ( IsDefined( level.ai_khalil ) )  // Khalil might not be defined in dev skiptos
	{
		a_dialogue_lines = [];
		a_dialogue_lines[0] = "khal_we_have_to_blow_the_0"; //We have to blow the street, get back here, now!!
		a_dialogue_lines[1] = "khal_hurry_we_have_to_bl_0"; //Hurry, we have to blow the street!!
		a_dialogue_lines[2] = "hend_fall_back_to_mobile_0"; //Fall back to Mobile Command, go, GO!!
		a_dialogue_lines[3] = "hend_get_the_fuck_back_g_0"; //Get the fuck back, go, go, go!!
		a_dialogue_lines[4] = "hend_fall_back_behind_the_0"; //Fall back behind the wall, MOVE!!
	
		level.ai_khalil dialog::say( vo_pick_random_line( a_dialogue_lines ) );
	}
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl1_get_behind_the_wall_0"; //Get behind the wall! Hurry!
	a_dialogue_lines[1] = "egy2_move_behind_the_mobi_0"; //Move behind the Mobile Wall!
	a_dialogue_lines[2] = "esl1_get_behind_the_wall_1"; //Get behind the wall, go, go, GO!!
	
	//HACK this dev skipto causes problems for this line for some reason
	if ( level.skipto_point != "dev_sinkhole_test" )
	{
		ai_guy = vo_find_closest_redshirt_for_dialog();
		ai_guy thread dialog::say( vo_pick_random_line( a_dialogue_lines ), 3 );
	}
}

function vo_clear_to_detonate()
{
	if ( IsDefined( level.ai_khalil ) )  // Khalil might not be defined in dev skiptos
	{
		level.ai_khalil dialog::say( "khal_get_on_top_of_wall_0" ); // Khalil - Get on top of wall, we need to detonate the charges to drop the street to cut off the NRC. 		
	}
}

//TODO not currently used, need to know if this is used in animation, or done in the background via script
function vo_friendly_sinkhole_celebration( a_friendlies )
{	
	level endon( "arena_defend_fade_out" );
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "esl4_let_s_see_them_climb_0"; //Let’s see them climb out of that!
	a_dialogue_lines[1] = "esl3_they_won_t_be_coming_0"; //They won’t be coming through there anymore.
	a_dialogue_lines[2] = "egy2_they_think_we_ll_bre_0"; //They think we’ll break so easy!
	a_dialogue_lines[3] = "esl1_our_will_won_t_be_br_0"; //Our Will won’t be broken!
	
	//only do this if I have enough guys for each line of dialogue
	if ( a_friendlies > a_dialogue_lines.size )
	{
		for( i = 0; i < a_dialogue_lines.size; i++ )
		{
			a_friendlies[i] dialog::say( a_dialogue_lines[i] );
			wait 0.5; //slight pause after each line is said
		}
	}
}

/#
// Debug
////////////////////////////////////////////////////////////////////

// Self is vehicle
function draw_line_to_target( e, n_timer )
{
	self endon( "death" );
	
	n_timer = gettime() + ( n_timer * 1000 );
	while( GetTime() < n_timer )
	{
		line( self.origin + (0,0,300), e.origin, ( 1, 0, 0 ), .1 );
		debug::drawArrow( e.origin, e.angles );
		wait .05;
	}
}
#/

// Dev
////////////////////////////////////////////////////////////////////

function dev_weak_point_test( str_objective, b_starting )
{
	setup_ambient_elements();
	setup_sinkhole_weak_points();
	setup_scenes();
	setup_heroes( str_objective, b_starting );
	
	level thread wall_fxanim_scene( false, true );  // spawn in mobile wall
	
	level flag::set( "weak_points_objective_active" );  // temp: initialize scenes
	
	// set up technical test
	vehicle::add_spawn_function( "arena_defend_technical_01", &warp_to_spline_end );
	vehicle::simple_spawn_single( "arena_defend_technical_01" );
	
	expose_all_weak_points();
	
	// add in checkpoint walls for testing
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_01_bundle", &play_checkpoint_wall_breach_left, "play" );
	scene::add_scene_func( "p7_fxanim_cp_ramses_street_collapse_small_hole_03_bundle", &play_checkpoint_wall_breach_right, "play" );
	
	wait_till_all_weak_points_destroyed();
	
	dev_sinkhole_test( "dev_sinkhole_test", false );
}

function dev_weak_point_test_done( str_objective, b_starting )
{
	
}

function delete_dev_waypoint_collision( str_waypoint )
{
	a_collision = GetEntArray( "collision_" + str_waypoint, "targetname" );
	
	foreach ( mdl_collision in a_collision )
	{
		mdl_collision Delete();
	}
}

function dev_sinkhole_test( str_objective, b_starting )
{
	if ( b_starting )
	{
		add_spawn_functions();
		
		level flag::wait_till( "all_players_spawned" );
	}
	
	setup_ambient_elements();
	setup_scenes();
	
	init_heroes( str_objective, b_starting );
	friendlies_fall_back_behind_mobile_wall( false );  // just make sure guys stay behind wall
	init_sinkhole();
	level thread wall_fxanim_scene( false, true );
	
	dev_test_setup_vehicles_for_sinkhole();
	
	level thread monitor_vehicle_targets();
	
	//vehicles
	enemies_overrun_checkpoint_area();
	
	level flag::set( "all_weak_points_destroyed" );
	
	weak_points_fxanim_scenes_complete();
	
	delete_dev_waypoint_collision( "wp_01" );
	delete_dev_waypoint_collision( "wp_02" );
	delete_dev_waypoint_collision( "wp_03" );
	delete_dev_waypoint_collision( "wp_04" );
	
	level notify( "arena_defend_enemy_fallback" );
	
	wait 1;
	
	level thread sinkhole_objectives();  // added for testing objective alignment
	
	//get the streamer ready for the demostreet_3rd_sh010 scene that starts after you pick up the detonator
	level util::set_streamer_hint( 2 );
	
	//so that scene doesn't immediately play after spawning from dev skipto
	level thread util::screen_message_create( "PRESS UP ON D-PAD TO PLAY FINAL SCENE", undefined, undefined, undefined, 10 );
	while ( true )
	{
		if ( level.players[0] ActionSlotOneButtonPressed() )
		{
			break;
		}
		
		wait 0.05;
	}
	util::screen_message_delete();
	
	scene_friendly_detonation_guy_killed();
	
	level notify( "spawn_technical_backup_1" );
	level thread players_detonate_charges_from_mobile_wall();
	
	m_button = GetEnt( "temp_detonator_button", "targetname" );
	objectives::set( "cp_level_ramses_detonate_street_charges", m_button );
	
	// set up allies to test scene
	spawn_manager::enable( "arena_defend_wall_allies" );  // ground
	
	level flag::wait_till( "sinkhole_charges_detonated" );
	
	kill_spawn_manager_group( "arena_defend_spawn_manager" );	
	kill_all_ai_in_street();
	
	ramses_util::delete_all_non_hero_ai();
	
	friendly_soldiers_celebrate_sinkhole_destruction();
	
	enemies_move_to_quad_tank_plaza();
	
	//test out final movie via this dev skipto as well
	if ( ramses_util::is_demo() )
	{
		wait 0.25; //wait a little bit for previous scene to cleanup now that fadeout blocker isn't here
		
		ramses_util::delete_all_non_hero_ai();
		
		ramses_util::prepare_players_for_demo_warp();
	}
	
	skipto::objective_completed( str_objective );
}

function sinkhole_objectives()
{
	level thread objectives();
	
	wait 1;
	
	level notify( "vo_weak_points_identify_said" );
}

function dev_test_setup_vehicles_for_sinkhole()
{
	vh_technical_initial = vehicle::simple_spawn_single( "arena_defend_intro_technical" );
	vh_technical_initial DoDamage( vh_technical_initial.health, vh_technical_initial.origin );
}

function dev_sinkhole_test_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_ramses_detonate_street_charges" );
}

function wall_test_init( str_objective, b_starting )
{
	level thread wall_fxanim_scene( true );
}

function wall_test_done( str_objective, b_starting, b_direct, player )
{
}

function expose_all_weak_points()
{
	a_data = get_weak_point_discovery_data();
	
	a_flags = [];
	
	// get all flags this event is going to wait for
	foreach ( wave in a_data )
	{
		foreach ( s_weak_point in wave )
		{
			ArrayCombine( a_flags, s_weak_point.a_flags_wait_for_discovery, false, false );
			if ( !isdefined( a_flags ) ) a_flags = []; else if ( !IsArray( a_flags ) ) a_flags = array( a_flags ); a_flags[a_flags.size]=s_weak_point.str_weak_point_identifier + "_identified";;
		}
	}
	
	// set all the flags
	foreach ( str_flag in a_flags )
	{
		level flag::set( str_flag );
	}
}


/*
	
	THIS SCRIPT HANDLES EVERYTHING SPECIFIC TO FLYING THE HIND

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\pow_utility;
#include maps\_anim;

#using_animtree ("generic_human");

start()
{
	//-- This gets called again in case you are using a jumpto.
	level.hind = GetEnt("flyable_hind", "targetname");
	assert( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	
	//-- PLAYER HAS JUST ENTERED THE HIND HELICOPTER---------------------------------------------------------------
	//level notify("update_objectives");
	//flag_set( "obj_fly_to_base" );
	
	//-- RE-Enable Buoyancy
	//-- disable buoyancy for tunnel section
	SetSavedDvar("phys_buoyancy", 1);
	SetSavedDvar("phys_ragdoll_buoyancy", 1);
	
	//SOUND - Shawn J - start-up sound for the hind & setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	clientnotify( "no_ext_amb_snapshot" );
	
	//-- Starts the player's hand movement while flying the hind
	level thread init_animated_bridges();
	
	player = get_players()[0];
	//player FreezeControls( true );
	
	
	//-- create the tutorial hud for the hind
	//level.hind maps\_hind_player::create_tutorial_hud( true );
	
	player = get_players()[0];
	player FreezeControls( false );
	
	//level.hind SetVehMaxSpeed(0);
	//level.hind waittill("reached_end_node");
	level.hind waittill( "playable_hind_climbin" );
	level.hind thread maps\_hind_player::enable_driver_weapons();
	level.hind thread pow_rocket_achievement();
	level.hind ent_flag_set("took off");
	
	flag_set( "obj_fly_to_base" );
	
	//-- The Player's Animations, This drives the takeoff sequence
	level.hind thread maps\pow_utility::start_hands_flightstick();
	
	//-- turn on player's damage override function
	//player.overrideActorDamage = ::player_damage_helicopter_override;
	
	//-- PLAYER HAS CLEARED THE TOP OF THE CANOPY -------------------------------------------------------------------
	
	//------------ TUTORIAL -------------------------
	//screen_message_create("[{+moveup}] to move - [{+lookup}] to turn");
	screen_message_create(&"POW_HELI_INSTRUCT_LS", &"POW_HELI_INSTRUCT_RS");
	//------------ TUTORIAL -------------------------
	
	//SetSavedDvar("sm_sunSampleSizeNear", level.default_sun_samplesize);
	SetSavedDvar("sm_sunSampleSizeNear", 2.7);
			
	//-- Unlock the player controls once the other hind has flown past.`
	//level.hind init_hind_flight_dvars_flying();
	level thread init_water_dvars();

	//--DEMO temporarily remove all the point at stuff, review after demo
	//level thread init_barnes_pointat_triggers();
	level thread setup_veh_spawn_funcs();
	
	//-- spin off the convoy thread to track when vehicles are spawned
	level thread watch_for_convoys();
	
	
	//-- Since there is not enforced progression, here are the threads for each area
	level thread wooden_bridge();
	level thread hind_vs_hip();
	level thread watch_for_1st_village();
	level thread watch_for_bend_village();
	level thread watch_for_sam_missiles();
	level thread watch_for_halfway_cleanup();
	level thread watch_for_2nd_village();
	level thread hind_vs_hinds();
	level thread watch_for_cleanup_2();
	level thread manage_flying_dialog_triggers();
	
	//-- TODO: remove this
	level thread nva_med_boat_spawnfuncs();
	
	//-- setup the sampans
	
	//add_spawn_function_veh_by_type( "boat_sampan_pow", maps\pow_utility::throw_boat_driver_on_death );
	vehicles = GetEntArray("script_vehicle", "classname");
	for( i = 0; i < vehicles.size; i++)
	{
		if(vehicles[i].vehicletype == "boat_sampan_pow")
		{
			vehicles[i] thread maps\pow_utility::throw_boat_driver_on_death();
		}
	}
	
	//-- a little extra cleanup
	clearing_truck = GetEnt("clearing_truck_geo", "targetname");
	if (isdefined(clearing_truck))
	{
		clearing_truck Delete();
	}
	
	wait(1.0);
	//level thread dialog_fly_story( "just_after_takeoff" );
	
	//------------ TUTORIAL -------------------------
	wait(4.0);
	screen_message_delete();
	//------------ TUTORIAL -------------------------
	
	dialog_fly_russian( "takeoff", "vo_rus_truck_depot_attacked" );
	
	flag_wait("obj_enemy_hind_complete");
	level maps\pow_compound::start(); //-- Start the next section of the map
}

wooden_bridge()
{
	bridge_spawners = GetEntArray( "bridge_ai", "targetname");
	array_thread( bridge_spawners, ::add_spawn_function, maps\pow_spawnfuncs::bridge_death_launch );
	
	level waittill("woodbridge_start");
	
	drone_trigger = GetEnt("bridge_drone_trig", "script_noteworthy");
	drone_trigger notify("stop_drone_loop");
	
	on_bridge_trig = GetEnt("on_bridge_trig", "targetname");
	
	drones = GetEntArray("drone", "targetname");
	drones_on_bridge = [];
	
	//-- seperate out the drones on the bridge
	for( i=0; i<drones.size; i++)
	{
		if(drones[i] IsTouching(on_bridge_trig))
		{
			drones_on_bridge[drones_on_bridge.size] = drones[i];
			drones[i] notify("drone_death"); //-- kill the drone threads running on him
		}
	}
	
	//array_thread( drones_on_bridge, ::ragdoll_at_target, level.hind );
	array_delete( drones_on_bridge ); //-- for performance
}

init_water_dvars()
{
	player = get_players()[0];
	player SetClientDvar( "missileWaterMaxDepth", 1000 );
}

watch_for_cleanup_2()
{
	trigger_wait("trig_cleanup_2");
	cleanup_populate_with_vehicles(2);
	flag_clear( "drones_stop_looped_anims" );
	level notify("level clean up");
}

init_barnes_pointat_triggers()
{
	point_at_triggers = GetEntArray("point_at_trig", "targetname");
	array_thread(point_at_triggers, ::barnes_point_at_trig);
}

init_animated_bridges()
{
	//-- first village
	//level thread bridge_rocket_notify( "fxanim_pow_woodbridge_mod", "woodbridge_start" );
	level thread bridge_minigun_notify( "fxanim_pow_woodbridge_mod", "woodbridge_start", 1000 );
	level thread wood_bridge_rocket_clip_notify("wood_bridge_missile_clip", "woodbridge_start");
	
	//-- large concrete bridge at 2nd village
	level thread bridge_rocket_notify( "concbridge_lrg_sect01", "concbridge_lrg_sect01_start");
	level thread bridge_rocket_notify( "concbridge_lrg_sect02", "concbridge_lrg_sect02_start");
	level thread bridge_rocket_notify( "concbridge_lrg_sect03", "concbridge_lrg_sect03_start");
	level thread bridge_rocket_notify( "concbridge_lrg_sect04", "concbridge_lrg_sect04_start");
	
	//-- small concrete bridge after 2nd village
	level thread bridge_rocket_notify( "concbridge_sm_sect01", "concbridge_sm_sect01_start");
	level thread bridge_rocket_notify( "concbridge_sm_sect02", "concbridge_sm_sect02_start");
	
	//-- radar tower
	level thread radar_tower_notify( "radar_clip", "radar_tower_start" );
	
}

init_hind_flight_dvars_flying() //-- self == hind helicopter
{
	self thread hind_damage_think();
	
	players = get_players();
	
	for( i=0; i < players.size; i++ )
	{
		//--  Hind Movement Tweaks
		players[i] SetClientDvar("vehHelicopterMaxSpeedVertical", 30);
		players[i] SetClientDvar("vehHelicopterMaxAccelVertical", 60); //-- this is for the intial takeoff (change the vars once we have it setup for the clearing old value was 75)
		players[i] SetClientDvar("cg_tracerSpeed", 20000);
	}
	
	OnSaveRestored_Callback(maps\pow_utility::vehicle_in_use_save_restored_function);
	
	//-- Hind Control Tweaks	
	SetDvar("vehHelicopterTiltFromFwdandYaw", 3);
	SetDvar("vehHelicopterDefaultPitch", 2); 
	
	//-- Physics Vehicle Dvar
	get_players()[0] SetClientDvar("dynEnt_bulletForce", 400);
	
	//-- Idle Hover
	self SetJitterParams( (5,0,5), 0.5, 1.0 );
}

watch_for_1st_village()
{

	level thread village_1_spawn_trucks();
	level thread building_flame_drone( "depot_hut_1", "hut_flame_drone" );
	trig_village = trigger_wait("veh_spawn_bend_one", "targetname"); //-- TODO: rename this trigger to be something more appropriate
	flag_wait("village_1_vehicles_spawned");
	
	//-- ZSU anti-air defense, set up as a gate
	player = get_players()[0];
	zsu = GetEnt("td_zsu_00", "targetname");
	zsu thread zsu_basic_control( "zsu_depot_positions", level.hind, "first_village_zsu_shoot", 1);
	
	//-- drone spawns dependent on a building existing
	level thread truck_depot_drones( "depot_dock_1", "dock_drone_loop", "spawn_depot_drones", 4);
	
	level thread village_damaged( "first_village_zsu_shoot" );
  level thread kick_off_first_village_on_trigger( "first_village_zsu_shoot" );
  		
	level waittill("first_village_zsu_shoot");
	
	//level.drone_run_cycle_override =  undefined;
	flag_set( "drones_stop_looped_anims" );
	level notify("spawn_depot_drones");
	flag_set("vo_rus_truck_depot_attacked");
	
	trigger_use( "hut_drone", "script_noteworthy" );
	trigger_use( "hut_drone_loop", "script_noteworthy" );
	
	
	//trigger_use( "dock_drone_loop", "script_noteworthy" );
		
	moving_trucks = GetEntArray("small_village_moving_truck", "targetname");
	array_thread( moving_trucks, ::drive_to_target_struct_on_notify );
	array_thread( moving_trucks, ::delete_on_goal );
	array_thread( moving_trucks, ::pow_turn_truck_into_model );
	
	//-- make the trucks flee this area
	for( i = 0; i < moving_trucks.size; i++ )
	{
		delay_between_trucks = 5 * i;
		if(IsDefined(moving_trucks[i]))
		{
			moving_trucks[i] notify_delay("drive_away", delay_between_trucks);	
		}
	}
	
}

village_1_spawn_trucks()
{
	trigger_wait( "trigger_spawn_village_1_trucks" );
	
	//-- another set of vehicles (zsu and trucks that drive away)
	maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 26);
	wait(0.05);
	maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 27); //-- boats!
	wait(0.05);
	//-- spawn in the trucks
	for(i = 19; i < 23; i++)
	{
		trucks = maps\_vehicle::scripted_spawn( level.vehiclespawngroup + i );
		wait(0.05);
		array_thread(trucks, ::pow_turn_truck_into_model );
	}
	
	flag_set("village_1_vehicles_spawned");
}

kick_off_first_village_on_trigger( msg )
{
	level endon(msg);
	
	trigger_wait("trig_kick_off_village_1_anyway");
	level notify(msg);
}

village_damaged( notify_msg )
{
	//-- alert the village if they get shot at
	damage_trig = GetEnt("sm_village_damage_alert_trig", "targetname");
	
		//-- kick off ambient behavior that has to do with the player specifically
	
	while(1)
	{
		damage_trig waittill( "damage", amount, inflictor, direction, point, type ); //-- The point and type are the interesting parts
		if(inflictor == get_players()[0] || inflictor == level.hind)
		{
			break;
		}
	}
	
	level notify( notify_msg );
}

truck_depot_drones( building_script_noteworthy, drone_trig_script_noteworthy, start_spawn_notify, wait_delay )
{
	building = GetEnt(building_script_noteworthy, "script_noteworthy");
	assert( IsDefined(building), "Building for drone spawn does not exist");
	
	drone_trig = GetEnt(drone_trig_script_noteworthy, "script_noteworthy");
	assert( IsDefined(drone_trig), "Drone trigger does not exist" );
	
	building endon("broken");
	
	if(IsDefined(start_spawn_notify))
	{
		level waittill(start_spawn_notify);
	}
	
	if(IsDefined(wait_delay))
	{
		wait(wait_delay);
	}
	
	building thread kill_drone_trigger(drone_trig);
	trigger_use( drone_trig_script_noteworthy, "script_noteworthy" );
}

kill_drone_trigger(drone_trig)
{
	self waittill("broken");
	drone_trig Delete();
}


watch_for_bend_village()
{
	//-- Make Hip Invincible until it's event Starts
	flag_wait("village_1_vehicles_spawned");
	maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 29);
	wait(0.05);
	level.enemy_hip = GetEnt("enemy_hip", "targetname");
	if(IsDefined(level.enemy_hip))
	{
		level.enemy_hip SetCanDamage( false );
	}
	
	add_spawn_function_veh( "bend_truck_quad50", ::drive_to_target_struct_delay, 0.3);
	//add_spawn_function_veh( "bend_truck_quad50", maps\pow_utility::delayed_spawn_attack_gaz63_single_50, get_players()[0], 5 );
	
	for( i=0; i<2; i++)
	{
		my_wait = 2 + (2 * i);
		
		add_spawn_function_veh( "bend_truck_ambient" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "bend_truck_ambient" + i, ::delete_on_goal);
	}
	
	for( i=0; i<2; i++)
	{
		my_wait = 1 + (0.5 * i);
		
		add_spawn_function_veh( "bend_truck_passby" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "bend_truck_passby" + i, ::delete_on_goal);
	}
	
	trigger_wait( "trig_kick_off_village_1_anyway" );
	maps\_vehicle::scripted_spawn( level.vehiclespawngroup + 23 ); //-- the trucks that are just spawned in and sit
	
	
	//array_thread(GetEntArray("bend_truck_gaz63_quad50", "targetname"), ::delayed_spawn_attack_gaz63_single_50, get_players()[0], 5);
	
	trigger_wait("trig_bend_convoy", "targetname");

}

start_walking_villagers( spawners ) //-- self == level
{
	level endon("stop_walkers");
	
	while( spawners.size > 0)
	{
		rand_index = RandomInt(spawners.size);
		
		if( spawners[rand_index].count <= 0 )
		{
			spawners = array_remove( spawners, spawners[rand_index] );
		}
		else
		{
			walker = simple_spawn_single( spawners[rand_index].targetname );
			walker waittill("goal");
			walker Delete();	
		}
	}
}

alert_walking_villagers()
{
	level waittill("stop_walkers");
	self notify( "end_patrol" );
}

watch_for_2nd_village()
{
	for( i=0; i<4; i++)
	{
		my_wait = 1 + (0.5 * i);
		
		add_spawn_function_veh( "drive_by_village_truck" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "drive_by_village_truck" + i, ::delete_on_goal);
	}
	
	add_spawn_function_veh( "big_village_quad", maps\pow_utility::zsu_basic_fire, level.hind, "drones_stop_looped_anims", 1, 1);
	
	//-- DRONES
	lookat_structs = getstructarray( "village_drone_lookat", "targetname" );
	array_thread( lookat_structs, ::drone_lookat_restart );
	
	lookaway_structs = getstructarray( "village_drone_lookaway", "targetname" );
	array_thread( lookat_structs, ::drone_lookaway_restart, "village_start_drones_notify", "village_stop_drones_notify" );
	
	//-- drone thresholds
	level thread second_village_track_buildings();
	
	
	//-- flaming drones
	numbers_array = array( 3, 6, 9, 11, 12, 15, 19 );
	for(i = 0; i < numbers_array.size; i++)
	{
		level thread building_flame_drone( "village_building_" + numbers_array[i], "village_flame_drone_" + numbers_array[i], "break" );
	}
		
	//-- END DRONES
	
	
	trigger_wait("trig_trucks_before_village");

	flag_clear( "drones_stop_looped_anims" );
	maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 25); //-- the 4 ZSUs
	maps\_vehicle::scripted_spawn(level.vehiclespawngroup + 26); //-- the boat at the dock
	
	
	
	trig_zsu = trigger_wait("trig_hill_zsu", "targetname");
	
	player = get_players()[0];
	
	level thread player_fail_if_two_zsus_are_alive();
	
	zsu = GetEnt("hill_zsu", "script_noteworthy");
	//zsu thread zsu_basic_fire(player);
	zsu thread zsu_basic_fire(level.hind);
	zsu_positions = getstructarray( "zsu_hill_structs", "targetname");
	zsu thread zsu_track_target_movement(zsu_positions, level.hind);
	
	zsu = GetEnt("bridge_zsu_right", "script_noteworthy");
	zsu_positions = getstructarray( "bridge_zsu_positions_right", "targetname");
	zsu thread zsu_track_target_movement(zsu_positions, level.hind);
	
	zsu = GetEnt("bridge_zsu_left", "script_noteworthy");
	zsu_positions = getstructarray( "bridge_zsu_positions_left", "targetname");
	zsu thread zsu_track_target_movement(zsu_positions, level.hind);
	
	zsu = GetEnt("village_zsu", "script_noteworthy");
	//zsu thread zsu_basic_fire(player);
	zsu thread zsu_basic_fire(level.hind);
	zsu_positions = getstructarray( "village_zsu_structs", "targetname");
	zsu thread zsu_basic_movement( zsu_positions );
	//zsu thread zsu_track_target_movement(zsu_positions, player);
		
	trig_village = trigger_wait("trig_second_village", "targetname");
	
	player = get_players()[0];

	zsus = GetEntArray("village_zsus", "targetname");
	array_thread( zsus, ::zsu_basic_fire, level.hind );
	array_thread( zsus, ::notify_on_notify, "death", "large_village_objective" );

	rpg_trigs = GetEntArray("rpg_triggers", "targetname");
	array_thread( rpg_trigs, ::tower_rpg_at_player, level.hind );
	array_thread( rpg_trigs, ::notify_on_notify, "trigger", "large_village_objective" );
	
	//-- These are for the trucks that flee
	trigger_wait("trig_second_village_trucks");
	moving_trucks = GetEntArray("second_village_moving_truck", "script_noteworthy");
	array_thread( moving_trucks, ::drive_to_target_struct_on_notify );
	array_thread( moving_trucks, ::delete_on_goal );
	
	/*
	moving_trucks2 = GetEntArray("second_village_moving_trucks_left", "script_noteworthy");
	array_thread( moving_trucks2, ::drive_to_target_struct_on_notify );
	array_thread( moving_trucks2, ::delete_on_goal );
	*/
	//-- drone cleanup funciton
	//level thread stop_drones_on_trig( "hill_drone_stop" );
		
	//-- make the trucks flee this area
	for( i = 0; i < moving_trucks.size; i++ )
	{
		delay_between_trucks = 5 * i;
		if(IsDefined(moving_trucks[i]))
		{
			moving_trucks[i] notify_delay("drive_away", delay_between_trucks);	
		}
		//moving_trucks2[i] notify_delay("drive_away", delay_between_trucks);	
	}
}

//-- Hard Fail the player at the pipe of he doesn't participate in the Objective
//   and leaves the 2 ZSUs on the bridge alone.  The player will fail when he flies over the pipe.

player_fail_if_two_zsus_are_alive()
{
	zsus = [];
	zsus[0] = GetEnt("bridge_zsu_left", "script_noteworthy");
	zsus[1] = GetEnt("bridge_zsu_right", "script_noteworthy");
	
	trigger_wait("nva_pbr_start"); //-- this is the trigger over the pipes, where the hind engages you

	zsus = array_removedead(zsus);
	if(zsus.size > 0)
	{
		//kill the player
		level.hind notify("damage", 10000 ); //-- I think this works because the hind runs it's own damage function.
	}
}

second_village_track_buildings()
{
	building_array = [];
	numbers_array = array( 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19 );
	
	for(i = 0; i < numbers_array.size; i++)
	{
		building_array[i] = GetEnt("village_building_" + numbers_array[i], "targetname");
	}
	
	total_buildings = building_array.size;
	while(building_array.size > 0)
	{
		level waittill("second_village_break", broken_building);
		building_array = array_remove(building_array, broken_building);
		
		if(building_array.size < total_buildings * 0.8)
		{
			level notify("village_start_drones_notify");
		}
		
		if(building_array.size < total_buildings * 0.3)
		{
			level notify("village_stop_drones_notify");
		}
	}
}

stop_drones_on_trig( trig_name, trig_key )
{
	if(!IsDefined(trig_key))
	{
		trig_key = "targetname";
	}
	
	trigger = GetEnt( trig_name, trig_key );
	trigger waittill("trigger");
	
	drone_trig = GetEnt(trigger.target, "script_noteworthy" );
	drone_trig Delete();
	
	trigger Delete();
}

setup_veh_spawn_funcs()
{
	add_spawn_function_veh( "bend_one_sampan00", ::convoy_basic_fire_loop_rpg, level.hind );
	
}

spawn_more_convoy_behind_me( other_vehicles, delay, spawn_func, param1 ) //-- The primary vehicle
{
	start_node = GetVehicleNode(self.target, "targetname");
	starting_pos = self.origin;
	starting_angles = self.angles;
	
	new_targetname = self.targetname;
	
	for( i = 0; i < other_vehicles.size; i++ )
	{	
		wait(delay);
		new_vehicle = SpawnVehicle( undefined, new_targetname + i, other_vehicles[i], starting_pos, starting_angles);
		assert( IsDefined(new_vehicle), "Had trouble spawning the new vehicle for the convoy in spawn_more_convoy_behind_me" );
		
		new_vehicle thread go_path(start_node);
		
		if(IsDefined(spawn_func))
		{
			new_vehicle thread [[spawn_func]](param1);
		}
	}
}

watch_for_convoys() //-- self == level
{
	
	//-- first gaz63 with .50 cal that fights the player at the first village
	add_spawn_function_veh( "bridge_to_small_village_truck", maps\pow_utility::drive_to_target_struct_on_notify, undefined, "single50_on_road_go");
	//add_spawn_function_veh( "bridge_to_small_village_truck", maps\pow_utility::delayed_spawn_attack_gaz63_single_50, get_players()[0], 5 );
	
	//-- This is the first set of vehicles that drives across the initial bridge.	
	/*
	more_veh_array = [];
	more_veh_array[0] = "truck_gaz66";
	more_veh_array[1] = "truck_gaz66";
	more_veh_array[2] = "truck_gaz66";
	more_veh_array[3] = "truck_gaz66";
	more_veh_array[4] = "truck_gaz66";
	*/
	
	//add_spawn_function_veh( "bridge_one_truck00", ::spawn_more_convoy_behind_me, more_veh_array, 3, ::cleanup_ai_based_on_progression, "cleanup_first_half" );
	//add_spawn_function_veh( "bridge_one_truck00", ::cleanup_ai_based_on_progression, "cleanup_first_half" );

	//-- clean up all the trucks at the bend
	//array_thread( GetEntArray("bend_truck_gaz66", "targetname"), ::cleanup_ai_based_on_progression, "cleanup_first_half" );
		

	//-- These are the trucks that head out towards the straight away from the 2nd village
	veh_spawn_trig = trigger_wait("trig_trucks_before_village", "targetname");
	wait(0.1);
	
	//TODO: change to vehicle spawn function
	trucks = GetEntArray("troop_truck_bend2", "targetname");
	//array_thread( trucks, ::spawn_ai_at_path_end );
}

spawn_ai_at_path_end() //-- self is a troop truck
{
	assert( IsDefined(self.script_noteworthy), "The troop truck did not have a valid script noteworthy" );
	
	self endon("death");
	
	self waittill("reached_end_node");
	simple_spawn( self.script_noteworthy );
	
}

barnes_flinch(r_or_l)
{
	if(r_or_l == "right")
	{
		flinch_anim = "flinch_r";
	}
	else
	{
		flinch_anim = "flinch_l";
	}
	
	
	level.barnes_model ClearAnim(level.scr_anim["barnes"]["idle_in_hind"], 0.05);
	level.barnes_model SetFlaggedAnim( "flinch_anim", level.scr_anim["barnes"][flinch_anim], 1, 0.05, 1  );
	level.barnes_model waittill("flinch_anim");
	level.barnes_model ClearAnim(level.scr_anim["barnes"][flinch_anim], 0.05);	
	level.barnes_model SetAnim( level.scr_anim["barnes"]["idle_in_hind"], 1, 0.05, 1 );
	
	//level.hind anim_single( level.barnes_model, flinch_anim);
	//level.hind thread anim_single( level.barnes_model, "idle_in_hind");
}

watch_for_sam_missiles()
{
	add_spawn_function_veh( "sam_high_quad50", ::drive_to_target_struct_delay, 0.3);
	//add_spawn_function_veh( "sam_high_quad50", maps\pow_utility::delayed_spawn_attack_gaz63_single_50, get_players()[0], 5 );
	
	for( i=0; i<2; i++)
	{
		my_wait = 1 + (0.5 * i);
		
		add_spawn_function_veh( "sam_low_truck" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "sam_low_truck" + i, ::delete_on_goal);
	}
	
	for( i=0; i<3; i++) //-- should be more, but i got rid of 2
	{
		my_wait = 1 + (0.5 * i);
		
		add_spawn_function_veh( "sam_high_truck" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "sam_high_truck" + i, ::delete_on_goal);
	}
	
	
	for( i=0; i<4; i++)
	{
		my_wait = 0.5 + (1.0 * i);
		
		add_spawn_function_veh( "sam_corner_truck" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "sam_corner_truck" + i, ::delete_on_goal);
	}
	
	for( i=0; i<4; i++)
	{
		my_wait = 0.3 + (1.0 * i);
		
		add_spawn_function_veh( "sam_bridge_truck" + i, ::drive_to_target_struct_delay, my_wait);
		add_spawn_function_veh( "sam_bridge_truck" + i, ::delete_on_goal);
	}
	
	
	sam_volume = trigger_wait("trig_sam_target_zone", "targetname");
	flag_set("music_sameventstarted");
	flag_set("vo_sam_reached");
	
	/*CLEANUP*/
	level notify("level clean up");
	
	//-- spawn the 2 ZSUs that sit up there
	//maps\_vehicle::scripted_spawn( 24 ); //-- the 2 ZSUs in the cave
	
		
	level thread sam_missiles_fire();
	level.hind thread missile_lock_sounds( "obj_sam_cave_complete" );
	
	flag_set( "obj_sam_cave" ); //objective
	flag_set( "obj_enemy_hip_passed" );
	wait_for_sam_cave_destroyed();
	flag_set( "obj_sam_cave_complete" );
	flag_set("music_sameventfinished");
	
	level notify("hind_clear_of_sam_zone");
}

wait_for_sam_cave_destroyed()
{
	//-- "trig_sam_target_zone_exit" is a poorly named damage trigger
	//dmg_trig = GetEnt("trig_sam_target_zone_exit", "targetname" );
	dmg_trig = GetEnt("sam_cave_script_model", "targetname");
	dmg_trig SetCanDamage(true);
	
	total_damage = 0;
	max_damage = 50;
	max_damage_range = 10000;
	
	cave_ref_point = getstruct( "struct_sam_cave_explo", "targetname").origin;
	level thread sam_close_vo(max_damage_range, cave_ref_point);
	while(true)
	{
		dmg_trig waittill( "damage", amount, attacker, direction, point ); 
		
		if( !IsPlayer( attacker ) &&  attacker != level.hind)
		{
			continue;
		}
		
		if( !level.hind check_dist_to_cave( max_damage_range, cave_ref_point ) )
		{
			continue;
		}
		
		total_damage += amount;
		
		if(total_damage > max_damage )
		{
			break;
		}
	}
	
	exploder( 1 );
	level notify("cave_debris_start");
	//wait(1.0);
	//exploder(7);
	//explosion_struct = getstruct( "struct_sam_cave_explo", "targetname");
	//PlayFX( level._effect["cave_explode"], explosion_struct.origin, AnglesToForward(explosion_struct.angles), AnglesToUp(explosion_struct.angles));
}

sam_close_vo(max_damage_range, cave_ref_point)
{
	while( !level.hind check_dist_to_cave( max_damage_range, cave_ref_point ))
	{
		wait(0.05);
	}
	
	flag_set("vo_sam_close");
}

check_dist_to_cave( max_damage_range, cave_ref_point )
{
	if( Distance2D( self.origin, cave_ref_point ) > max_damage_range )
	{
		return false;
	}
	
	
	
	return true;		
}


player_went_right( threshhold, delay_time ) //-- self == level.hind
{
	original_position = (self.origin[0], self.origin[1], 0);
	right = AnglesToRight((self.angles[0], 0, self.angles[2]));
	
	wait(delay_time);
	
	new_position = (self.origin[0], self.origin[1], 0);
	move_vector = new_position - original_position;
	move_vector = VectorNormalize(move_vector);
	
	vec_dot = VectorDot(move_vector, right);

	if( vec_dot > threshhold )
	{
		return true;
	}

	return false;
}

player_went_left( threshhold, delay_time ) //-- self == level.HIND
{
	original_position = (self.origin[0], self.origin[1], 0);
	left = AnglesToRight((self.angles[0], 0, self.angles[2])) * -1;
	
	wait(delay_time);
	
	new_position = (self.origin[0], self.origin[1], 0);
	move_vector = new_position - original_position;
	move_vector = VectorNormalize(move_vector);
	
	vec_dot = VectorDot(move_vector, left);

	if( vec_dot > threshhold )
	{
		return true;
	}

	return false;
}

sam_missiles_fire()
{
	level endon("hind_clear_of_sam_zone");
	//sam_site = GetStruct("sam_site_struct", "targetname");
	sam_site = GetEntArray("sam_cave_origin", "targetname");
	
	player = get_players()[0];
	
	level.hind.missiles_incoming = [];
	
	missiles_shot = 0;
	
	while(1)
	{
		if(!flag("obj_sam_cave_passed"))
		{
			random_int = RandomInt(10);
			if(random_int < 3)
			{
				level thread dialog_fly_nag( "nag_sam" + random_int );
			}
			
			forward = level.hind.sam_target.origin - sam_site[0].origin;
			PlayFX(level._effect["sam_launch"], sam_site[0].origin);
			missile = MagicBullet("sam_pow_sp", sam_site[0].origin, level.hind.sam_target.origin, undefined, level.hind.sam_target, (0,0,0) );
			missile Solid();
			missile SetCanDamage( true );
			missile thread missile_damage_watcher();
			missile thread rocket_rumble_when_close(player);
			missile.origin_pt = sam_site[0].origin;
			level.hind.missiles_incoming[level.hind.missiles_incoming.size] = missile;
			
			wait(2.5);
			
			forward = level.hind.sam_target.origin - sam_site[1].origin;
			PlayFX(level._effect["sam_launch"], sam_site[1].origin);
			missile = MagicBullet("sam_pow_sp", sam_site[1].origin, level.hind.sam_target.origin, undefined, level.hind.sam_target, (0,0,0) );
			missile Solid();
			missile SetCanDamage( true );
			missile thread missile_damage_watcher();
			missile thread rocket_rumble_when_close(player);
			missile.origin_pt = sam_site[1].origin;
			level.hind.missiles_incoming[level.hind.missiles_incoming.size] = missile;
		}
		
		wait(5);
	}
}

missile_damage_watcher()
{
	self waittill( "damage" );
	
	self ResetMissileDetonationTime( 0 );
}

missile_lock_sounds( flag_name ) //-- self == trigger volume
{
	sound_on = false;
	player = get_players()[0];
	
	while(!flag( flag_name ))
	{
			while(self missiles_headed_at_me(self.missiles_incoming) )
			{
				if(!sound_on)
				{
					self.ent = spawn ("script_origin", player.origin );
					self.ent LinkTo( player );
					self.ent playloopsound("wpn_rocket_warning_loop");
					sound_on = true;
					
					self thread maps\_hind_player::flash_warning_indicator();
				}
			
				wait(0.05);
				self.missiles_incoming = array_removeUndefined(self.missiles_incoming);		
			}
			
			if(sound_on)
			{
				self.ent StopLoopSound();
				self.ent delete();
				sound_on = false;
				
				self notify("stop_warning_indicator");
			}
			
			wait(0.05);
	}
	
	if(IsDefined(self.ent))
	{
		self.ent StopLoopSound();
		self.ent Delete();
	}
}

missiles_headed_at_me( missiles ) // are missiles headed at me?
{
	missile_warning_range = 20000;
	
	if( missiles.size <= 0 )
	{
		//-- no missiles exist, so none are headed at you
		return false;
	}
	
	for( i=0; i < missiles.size; i++)
	{
		if(IsDefined(missiles[i]))
		{
			me_to_origin = VectorNormalize( self.origin - missiles[i].origin_pt );
			me_to_missile = self.origin - missiles[i].origin;
			dot = VectorDot( me_to_origin, me_to_missile );
			if(  dot > 0 && dot < missile_warning_range)
			{
				if ( dot < 10000 )
				{
					missiles[i]	play_rocket_flyby();
				}			
				
				return true;
			}
		}
	}
	
	return false;
}

play_rocket_flyby()
{
	self endon ("death");
	
	if(IsDefined ( self.flybysound ) )
	{
		return;	
	}
	
	self.flybysound = true;
	self playsound("evt_rocket_flyby_close");		
}

rocket_rumble_when_close(target)
{
	self endon("death");
	
	while(DistanceSquared(target.origin, self.origin) > 500 * 500)
	{
		wait(0.05);
	}
	
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 0.3, 1.5, self.origin, 700 );
}

watch_for_halfway_cleanup() //-- self == level
{
	trigger_wait("trig_sam_target_zone_exit", "targetname");
	level notify("cleanup_first_half");
	
	leftover_drones = GetEntArray( "drone", "targetname");
	array_delete(leftover_drones);
}

/*
cleanup_ai_based_on_progression( my_notify ) //-- self == ai
{
	if(!IsDefined(level.pow_clean_up))
	{
		level.pow_clean_up = [];
		level.pow_clean_up["ai"] = 0;
		level.pow_clean_up["vehicle"] = 0;
		level.pow_clean_up["other"] = 0;
	}
	
	self endon("death");
	level waittill( my_notify );
	
	if(IsSubStr(self.classname, "actor"))
	{
		level.pow_clean_up["ai"]++;
	}
	else if( self.classname == "script_vehicle" )
	{
		level.pow_clean_up["vehicle"]++;
	}
	else
	{
		level.pow_clean_up["other"]++;
	}
	
	self Delete();
}
*/

/*----------------------------------------------------------------------

		HIND VS HIP

----------------------------------------------------------------------*/

hind_vs_hip()
{
	trigger_wait("trig_bend_convoy");
	flag_set( "obj_enemy_hip");
	flag_set( "obj_truck_depot_passed");
	flag_set("music_hiptakingoff");
	
	level.enemy_hip = GetEnt("enemy_hip", "targetname");
	assert(IsDefined(level.enemy_hip), "The enemy hip doesn't exist");
	
	level.enemy_hip SetCanDamage( true );
	level.enemy_hip.lockheliheight = true;
	level.enemy_hip.script_nocorpse = true;
	level.vehicle_death_thread[level.enemy_hip.vehicletype] = ::heli_crash_think;
	
	//-- Uses .hind_target because this is borrowed targeting code from the hind vs hind engagement
	level.enemy_hip.hind_target = get_players()[0];
	
	level.enemy_hip SetVehGoalPos( level.enemy_hip.origin, true );
	level.enemy_hip SetNearGoalNotifyDist( 80 );
	level.enemy_hip SetLookAtEnt( level.enemy_hip.hind_target );
	level.enemy_hip waittill_either( "goal", "near_goal");
	
	level.enemy_hip thread enemy_hind_think( true );
	level.enemy_hip thread enemy_hind_rocket_attack();
	level.enemy_hip thread enemy_hip_cleanup_if_passed();
	
	/*
	CLEANUP
	*/
	cleanup_populate_with_vehicles(1); // cleans up the first village worth of vehicles
}

enemy_hip_cleanup_if_passed() //-- the hip
{
	self endon("death");
	
	flag_wait("obj_enemy_hind");
	
	self notify("heli_stop_moving");
	self SetVehGoalPos( self.origin, true );
	self notify("death");
}


/*----------------------------------------------------------------------

		HIND VS HIND

----------------------------------------------------------------------*/

hind_vs_hinds()
{
	trigger_wait("nva_pbr_start");
	
	//-- Spawn the final 2 hinds
	maps\_vehicle::scripted_spawn( level.vehiclespawngroup + 18 );
	
	flag_set( "obj_enemy_hind" );
	level.hinds = GetEntArray("hind_for_last_battle", "targetname");
	array_thread(level.hinds, ::hind_start_battle);
	level.hind thread barnes_model_think(level.hinds[0]);
	
	level.hind thread missile_lock_sounds( "obj_enemy_hind_complete" );
}

hind_start_battle()
{
	self.hind_target = get_players()[0];
	level.vehicle_death_thread[self.vehicletype] = ::heli_crash_think;
	self SetLookAtEnt( self.hind_target );
	self SetNearGoalNotifyDist( 120 );
	self.lockheliheight = true;
	
	if(IsDefined(self.script_noteworthy))
	{
		self enemy_hind_fire_rocket_barrage();
		flag_set("music_twohinds");
		
		goal_pos = getstruct("last_hind_fallback", "targetname").origin;
		flag_set("vo_hind_fallback");
		self SetVehGoalPos( goal_pos, true );
	}
	else
	{
		self SetVehGoalPos( self.origin, true );
	}
	
	self waittill_any("goal", "near_goal");
	
	self thread enemy_hind_think();
}

enemy_hind_think( no_weapon )
{
	self endon("death");
	
	//-- entity flags
	self ent_flag_init("too_close_to_target");
	
	//-- Behavior Threads
	self thread enemy_hind_dmg_fx();
	self thread enemy_hind_move_position();
	self thread heli_avoidance();
	
	if(self.vehicletype != "heli_hip")
	{
		self thread enemy_hind_set_flag_on_death("vo_one_hind_down");
	}
	
	if( !IsDefined(no_weapon))
	{
		self thread enemy_hind_weapon_think();
	}
}


heli_avoidance()
{
  self endon("done_avoiding");
  self endon("death");
  self endon("landing");

	max_push_dist = 0;
  max_push_vel = 0;
	min_height_diff = 0;
	max_push_side_vel = 0;
	collision_avoid_time = 0;
	
	switch(self.vehicletype)
	{
		case "heli_hind_doublesize":
		case "heli_hind":
			max_push_dist = 2500;
 			max_push_vel = 60;
 			max_push_side_vel = 100;
 			min_height_diff = 550;
 			collision_avoid_time = 3;
		break;
		
		case "heli_hip":
			max_push_dist = 1500;
  		max_push_vel = 40;
  		max_push_side_vel = 40;
  		min_height_diff = 360;
  		collision_avoid_time = 2;
		break;
	}
  
  avoiding = false;
  while (1)
  {
  	//-- General Check to make sure that things are kosher
    if (IsDefined(self.velocity))
    {
      // get current velocity
      velocity = self.velocity;

      // first avoid the player
      dist = Distance2D(level.hind.origin, self.origin);

      // if we are with in the bounds 
      still_avoiding = false;
      if (dist < max_push_dist || heli_on_collision_course( self, level.hind, collision_avoid_time ))
      {
      	// Check the Z Height as well
      	height_diff = self.origin[2] - level.hind.origin[2];
      	
      	if(height_diff < min_height_diff)
      	{
      	
	        // find out how far in we are
	        //normalized_dist = dist / max_push_dist;
	        normalized_dist = 1;
	
	        // push above player
	        dir = (0,0,1);
	        push_vel = dir * (max_push_vel * normalized_dist);
	        velocity = (velocity[0] * 0.75, velocity[1] * 0.75, velocity[2]);
	        velocity = velocity + push_vel;
		
					// push them to the side as well
					dir_to_right = AnglesToRight(self.angles);
					side_push_vel = dir_to_right * (max_push_side_vel * normalized_dist);
					if( VectorDot(dir_to_right, VectorNormalize(level.hind.velocity)) < 0)
					{
						//-- fly to my right
						side_push_vel = (side_push_vel[0], side_push_vel[1], 0);
					}
					else
					{
						//-- fly to my left
						side_push_vel = -1 * (side_push_vel[0], side_push_vel[1], 0);
					}
					
					//-- if the helicopter is already moving a different direction, don't push it
					if( VectorDot(VectorNormalize(side_push_vel), VectorNormalize(self.velocity)) >= 0 )
					{
						velocity = velocity + side_push_vel;
					}
					
	        avoiding = true;
	      }
	      
	      still_avoiding = true;
      }
      
      if(!still_avoiding)
      {
      	if (avoiding)
        {
        	velocity = (velocity[0], velocity[1], 0.0);
        }
        avoiding = false;
      }

      self SetVehVelocity(velocity);
    }

    wait(0.05);
	}
}

heli_on_collision_course( target_ent, incoming_ent, time_to_collision )
{
	collision_dir = VectorNormalize(target_ent.origin - incoming_ent.origin);
	incoming_velocity = VectorNormalize(incoming_ent.velocity);
	
	target_ent.collision_dot = VectorDot( collision_dir, incoming_velocity );
	if( target_ent.collision_dot > .8 ) // then player is on collision course
	{
		coll_vector_length = Length(target_ent.origin - incoming_ent.origin);
		target_ent.time_left_to_collision =  coll_vector_length / VectorDot(collision_dir, incoming_ent.velocity);
		if(target_ent.time_left_to_collision < time_to_collision)
		{
			return true;
		}
	}
	
	//not on a collision course
	return false;
}


enemy_hind_set_flag_on_death( flag_str )
{
	self waittill("death");
	flag_set(flag_str);
}

enemy_hind_move_position()
{
	self endon("death");
	self endon("heli_stop_moving");
	
	self notify("forced_move_now");
	self endon("forced_move_now");
	
	dist_to_keep = 2400;
	rotation_degree = 36;
	
	//-- circle strafing
	self SetLookAtEnt( self.hind_target );
	times_moved = 0;
	stop_at_goal = false;
	
	//-- don't get too close to player
	self thread enemy_hind_keep_dist_from_target( dist_to_keep );
	
	curr_direction = 1;
	
	while(1)
	{		
		//-- Find the new goal point
		curr_angle = VectorToAngles( self.origin - self.hind_target.origin );
		new_angle = (0, curr_angle[1] + (rotation_degree * curr_direction), 0);
		dir_to_goal = AnglesToForward(new_angle);
		goal_point = self.hind_target.origin + (dir_to_goal * dist_to_keep);
		
		//-- Don't fly through walls)
		trace = BulletTrace(self.origin, goal_point, false, self);
		if(trace["position"] != goal_point)
		{
			curr_direction = curr_direction * -1;
			wait(0.05);
			continue;
		}
		
		times_moved++;
		self SetVehGoalPos( goal_point, stop_at_goal );
		self SetNearGoalNotifyDist( 1200 );
		//self waittill_any("goal", "near_goal");
		
		if(self.smoke_fx_on)
		{
			self waittill_any_or_timeout(2, "goal", "near_goal");
			rotation_degree = RandomIntRange(24, 72);
			if(RandomInt(100) < 30)
			{
				curr_direction = curr_direction * -1;
			}
		}
		else
		{
			self waittill_any_or_timeout(5, "goal", "near_goal");
		}
		
		//-- rocket barrage, unless the player is too close
		if(stop_at_goal == true && !self ent_flag("too_close_to_target"))
		{
			wait(2);
			self notify("fire_rockets");
			wait(5);
			stop_at_goal = false;
			times_moved = 0;
			curr_direction = curr_direction * -1;
		}
		
		//-- stop at the goal point the next time you move
		if(times_moved == 2)
		{
			stop_at_goal = true;
		}
	}
}

enemy_hind_keep_dist_from_target( dist_to_target )
{
	self endon("death");
	self endon("forced_move_now");
	
	//-- alleviates constant spawn problem
	wait(1);
	
	while(1)
	{
		curr_dist = DistanceSquared( self.origin, self.hind_target.origin );
		if( curr_dist <= dist_to_target * dist_to_target )
		{
			self ent_flag_set("too_close_to_target");			
			self thread enemy_hind_move_position();
		}
		else
		{
			self ent_flag_clear("too_close_to_target");
		}
		
		wait(0.25);
	}
}

enemy_hind_weapon_think()
{
	self endon("death");
	self thread enemy_hind_rocket_attack();
	
	while(1)
	{
		self enemy_hind_minigun_attack(3);
		wait(3.0);
	}
}

enemy_hind_rocket_attack() //self = enemy hind
{
	self endon( "death" );

	while( IsAlive( self ) )
	{
		self thread enemy_hind_fire_single_rocket();
		self waittill("fire_rockets");
		
		self enemy_hind_fire_rocket_barrage();
	}
}

enemy_hind_fire_rocket_barrage() //-- self == Hind
{
	player = get_players()[0];
	switch(self.vehicletype)
	{
		case "heli_hind_doublesize":
		case "heli_hind":
			for(i = 0; i < 4; i++)
			{
				for(j = 2; j < 4; j++)
				{
					//"tag_rocket1"
					//"tag_rocket2"
					rocket = MagicBullet( "hind_rockets_2x_sp", self GetTagOrigin("tag_rocket" + j), self.hind_target.origin, self, self.hind_target );
					rocket thread rocket_rumble_when_close(player);
					rocket.origin_pt = self GetTagOrigin("tag_rocket" + j);
					level.hind.missiles_incoming[level.hind.missiles_incoming.size] = rocket;
					wait(0.15);
				}	
			}
		break;
		
		case "heli_hip":
		 //no rocket barrage for the hip
		break;
	}
}

enemy_hind_fire_single_rocket()
{
	self endon("fire_rockets");
	self endon("death");
	
	rocket_tag = "tag_origin";
	wait_min = 5;
	wait_max = 8.5;
	
	rocket_weapon = "hind_rockets_sp";
	switch(self.vehicletype)
	{
		case "heli_hind_doublesize":
		case "heli_hind":
			rocket_tag = "tag_rocket1";
			wait_min = 5;
			wait_max = 8.5;
			rocket_weapon = "hind_rockets_2x_sp";
		break;
		
		case "heli_hip":
			rocket_tag = "tag_rocket_left";
			wait_min = 2;
			wait_max = 3.5;
			rocket_weapon = "hind_rockets_norad_sp";
		break;
	}
		
	while(true)
	{
		rand_wait = RandomFloatRange(wait_min, wait_max);
		wait(rand_wait);
		forward = AnglesToForward(self.angles);
		start_point = self GetTagOrigin(rocket_tag) + (60 * forward);
		player = get_players()[0];
		rocket = MagicBullet( rocket_weapon, start_point, self.hind_target.origin, self, self.hind_target );
		rocket thread rocket_rumble_when_close(player);
	}
}

enemy_hind_minigun_attack( burst_time )
{
	self endon("death");
	self endon("stop_firing");
	
	//Kevin adding audio ent
	ent = spawn( "script_origin" , (0,0,0));
	self thread audio_ent_fakelink( ent );
	ent thread audio_ent_fakelink_delete();
	
	self SetTurretTargetEnt( self.hind_target );
	
	time_fired = 0;
	
	while( IsAlive(self) && time_fired < burst_time )
	{
		ent playloopsound( "wpn_huey_toda_minigun_fire_npc_loop2" );
		self FireWeapon();
		wait(0.05);
		time_fired += 0.05;
	}
	ent stoploopsound(.048);
}

///////////////////////////////////Kevin mini gun audio functions
audio_ent_fakelink( ent )
{
	level endon("stop_firing" );
	self endon ("death");
	
	while(1)
	{
		ent moveto( self.origin, .05 );
		wait(.1);
	}
}

audio_ent_fakelink_delete()
{
	level waittill( "stop_firing" );
	
	self delete();
}
///////////////////////////////////
/*-----------------------------------------------------------------------/
		Enemy Hind Damage FX and things
*/

enemy_hind_dmg_fx() //-- self == heli_hind
{
	self endon("death");
	
	self.smoke_fx_on = false;
	
	while(1)
	{

		self waittill("damage");
		
		if(!self.smoke_fx_on && self.health < (self.healthmax / 2) )
		{
			if(self.vehicletype != "heli_hip")
			{
				PlayFXOnTag( level._effect["prop_smoke_large"], self, "tag_origin" );
			}
			else
			{
				PlayFXOnTag( level._effect["prop_smoke"], self, "tag_origin" );
			}
			self.smoke_fx_on = true;
		}
	}
}

/*--------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------/
		NVA Med Boat Tests to make sure the whole thing is working.
		TODO: take this out once I don't need it anymore
*/

nva_med_boat_spawnfuncs()
{
	add_spawn_function_veh( "nva_med_patrol", ::nva_med_boat_shoot_in_range, "drones_stop_looped_anims" );
}

nva_med_boat_shoot_in_range( notify_msg )
{
	self endon("death");
	
	self thread nva_patrol_gunners();
	
	player = get_players()[0];
	self thread nva_med_boat_basic_fire(player, 0, 5000, notify_msg);
	self thread nva_med_boat_basic_fire(player, 1, 5000, notify_msg);
}

nva_med_boat_basic_fire( target, gun_num, dist, notify_msg, notify_count ) //self == nva_med_boat
{
	self endon("death");
	target endon("death");
	
	if(!IsDefined(notify_count))
	{
		notify_count = 1;
	}
	
	burst_fire_time = 3;
	fire_time = 0;
	
	self SetGunnerTargetEnt( target, (0,0,50), gun_num );
	
	while(1)
	{
		if(dist > Distance2D(self.origin, target.origin))
		{
			if(fire_time < burst_fire_time)
			{
				self FireGunnerWeapon(gun_num);
				wait(0.1);
				fire_time += 0.1;
				
				if(notify_count > 0)
				{
					level notify(notify_msg);
					notify_count--;
				}
			
			}
			else
			{
				fire_time = 0;
				wait(2.5);
			}
		}
		else
		{
			wait(0.3);
		}
	}
}

manage_flying_dialog_triggers()
{
	//-- all of the russian radio chatter
	level thread manage_russian_dialog();
	
	trigger_wait("dialog_bridge");
	level thread dialog_fly_story("bridge");
	
	trigger_wait("dialog_depot");
	level thread dialog_fly_story("depot");
	level thread dialog_fly_story("tank");
	
	flag_wait_any("obj_truck_depot_complete", "vo_bend_reached");
	level thread dialog_fly_story("depot_clear");
	flag_wait("vo_bend_reached");
	level thread dialog_fly_story("bend");
	
	flag_wait_any("obj_enemy_hip_complete", "vo_napalm_reached", "vo_sam_reached");
	//level thread dialog_fly_story("hip_dead"); //DEMO: look at this after the demo
	
	flag_wait_any("vo_napalm_reached", "vo_sam_reached");
	level thread dialog_fly_story("napalm");
	
	flag_wait("vo_sam_reached");
	level thread dialog_fly_story("sam_start");
	
	flag_wait("vo_sam_close");
	level thread dialog_fly_story("sam_close");
	
	flag_wait("obj_sam_cave_complete");
	level thread dialog_fly_story("sam_done");
	
	trigger_wait("dialog_ho_chi_minh");
	level thread dialog_fly_story("ho_chi_minh");
	
	flag_wait( "obj_large_village_complete");
	level thread dialog_fly_story("kravchenko_ahead");
	
	trigger_wait("nva_pbr_start");
	level thread dialog_fly_story("radar_blip");
	
	flag_wait( "vo_hind_fallback" );
	level thread dialog_fly_story("hind_fallback");
	
	flag_wait( "vo_one_hind_down");
	level thread dialog_fly_story("one_hind_down");
	
	flag_wait( "obj_enemy_hind_complete" );
	level thread dialog_fly_story("both_hinds_down");
	
}

manage_russian_dialog()
{
	//dialog_fly_russian( msg, flag_abort )
	
	flag_wait("vo_rus_truck_depot_attacked");
	level thread dialog_fly_russian( "truck_depot", "vo_bend_reached" );
	
	flag_wait("vo_bend_reached");
	level thread dialog_fly_russian( "bend_village", "obj_enemy_hip_complete" );
	
	flag_wait("vo_napalm_reached");
	level thread dialog_fly_russian( "sam_missile" );
	
	//flag_wait();
	level waittill("alert_all_drones"); //-- DEMO // TODO -- this is kind of hacky, look into a better way
	level thread dialog_fly_russian( "second_village", "obj_large_village_complete");
	
	flag_wait( "vo_hind_fallback" );
	level thread dialog_fly_russian( "hind_vs_hinds", "obj_enemy_hind_complete" );
}

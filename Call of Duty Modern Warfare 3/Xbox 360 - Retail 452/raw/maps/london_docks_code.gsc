#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include common_scripts\utility;
#include maps\london_code;
#include maps\london_uav;

//---------------------------
// Init Section 
//---------------------------

init_docks_spawner_functions()
{
	// AI
	array_spawn_function_noteworthy( "dock_enemy", 				::postspawn_docks_ai );
	array_spawn_function_noteworthy( "dock_soldier", 			::postspawn_docks_ai );
	array_spawn_function_targetname( "docks_worker", 			::postspawn_docks_worker );
	array_spawn_function_targetname( "warehouse_worker", 		::postspawn_docks_worker );
	array_spawn_function_targetname( "intro_sas", 				::postspawn_intro_sas );
	array_spawn_function_noteworthy( "intro_truck_door_guy", 	::postspawn_intro_truck_door_guy );

	array_spawn_function_targetname( "alley_enemy_cellphone",	::postspawn_alley_enemy_cellphone );
	array_spawn_function_targetname( "alley_enemy_sleeping", 	::postspawn_alley_enemy_sleeping );
	array_spawn_function_noteworthy( "alley_enemy_warehouse", 	::postspawn_alley_enemy_warehouse );

//	array_spawn_function_noteworthy( "warehouse_walkers",		::postspawn_warehouse_walkers );
	array_spawn_function_noteworthy( "warehouse_hallway_enemy",	::postspawn_warehouse_hallway_enemy );
	array_spawn_function_targetname( "warehouse_sniper_target", ::postspawn_warehouse_sniper_target );
	array_spawn_function_noteworthy( "sas_breacher", 			::postspawn_warehouse2_breachers );
	array_spawn_function_noteworthy( "sas_breacher_enemy", 		::postspawn_warehouse2_enemy );
	array_spawn_function_noteworthy( "warehouse_melee_enemy",	::postspawn_warehouse_melee_enemy );
	array_spawn_function_noteworthy( "sewer_pipe_enemy", 		::postspawn_sewer_pipe_ai );

	array_spawn_function_noteworthy( "sas_orange",				::postspawn_sas_orange );

	array_spawn_function_targetname( "docks_littlebird_rpger", 	::postspawn_littlebird_rpger );

//	array_spawn_function_targetname( "warehouse_enemies_group1", ::warehouse_breach_reaction );

	// Vehicles
	array_spawn_function_targetname( "docks_littlebird_spawner", ::postspawn_littlebird );
//	array_spawn_function_targetname( "docks_littlebird_spawner2", ::postspawn_littlebird2 );
	array_spawn_function_targetname( "docks_sas_van", 			 ::postspawn_sas_van );
}

init_triggers()
{
	triggers = GetEntArray( "trigger_garage_door", "targetname" );
	array_thread( triggers, ::trigger_garage_door );

	triggers = GetEntArray( "trigger_docks_chopper_hoverpoint", "targetname" );
	array_thread( triggers, ::trigger_chopper_hoverpoint );

	triggers = GetEntArray( "docks_getaway_trigger", "targetname" );
	array_thread( triggers, ::trigger_docks_enemies_getaway );

	triggers = GetEntArray( "footstep_splash_trigger", "targetname" );
	array_thread( triggers, ::footstep_splash_trigger );

	triggers = GetEntArray( "catchup_trigger", "targetname" );
	array_thread( triggers, ::catchup_trigger );

	trigger_off( "warehouse_delayed_flag_trigger", "targetname" );

	triggers = GetEntArray( "trigger_after_ambush", "script_noteworthy" );
	array_thread( triggers, ::trigger_off );

	trigger = GetEnt( "docks_truck_door", "targetname" );
	trigger trigger_off();
}

init_footsteps_wrapper()
{
	anim.optionalStepEffectSmallFunction = maps\london_fx::notetrack_footstep_wrapper;
	anim.optionalStepEffectFunction = maps\london_fx::notetrack_footstep_small_wrapper;
}

docks_precache()
{
	PreCacheTurret( "player_view_controller" );
	PreCacheTurret( "player_view_controller_uav" );
//	PreCacheTurret( "player_view_controller_uav_wide" );
	PrecacheModel( "tag_turret" );

	PrecacheTurret( "heli_spotlight" );
	PrecacheModel( "com_blackhawk_spotlight_on_mg_setup" );

	PrecacheModel( "london_porch_rig" );
	PrecacheModel( "tag_laser" );
	PrecacheModel( "vehicle_uk_delivery_truck_glowing" );
	PrecacheModel( "electronics_camera_cellphone_low" );

	PreCacheShader( "cinematic" );
	PreCacheShader( "veh_hud_target" );
	PreCacheShader( "veh_hud_target_offscreen" );
	PreCacheShader( "remotemissile_infantry_target" );
	PreCacheShader( "hud_fofbox_self_sp" );
	PreCacheShader( "veh_hud_friendly" );
	PreCacheShader( "uav_vehicle_target" );
	PreCacheShader( "uav_enemy_target" );

	PrecacheItem( "nosound_magicbullet" );
	PrecacheItem( "rpg" );

	PrecacheModel( "com_bolt_cutter_animated" );
	PrecacheModel( "ch_crate48x64" );
	PrecacheModel( "com_barrel_black" );
}

warehouse_light()
{
	light = GetEnt( "docks_warehouse_light01", "script_noteworthy" );
	light setLightIntensity( 0 );
	wait( 0.5 );
	flag_wait( "uav_slamzoom" );
	light SetLightIntensity( 1.8 );
}

//---------------------------------------------------------
// Intro Section
//---------------------------------------------------------
init_uav_intro()
{
	struct = SpawnStruct();

	struct.forklift = spawn_vehicle_from_targetname( "forklift_intro" );
	struct.forklift.targetname = "forklift_vehicle";
	struct.forklift.riders[ 0 ] assign_unique_id();
	struct.forklift.riders[ 0 ] uav_add_target();
	struct.forklift intro_get_forklift_cargo();

	struct.forklift ent_flag_init( "cargo_unloading" );
	struct.forklift ent_flag_init( "cargo_unloaded" );
	struct.forklift ent_flag_init( "up" );
	struct.forklift ent_flag_init( "down" );
	struct.forklift ent_flag_init( "doors_closed" );
	
	struct.forklift_static = GetEnt( "docks_forklift_static", "targetname" );
	struct.forklift_static Hide();
	
	if ( level.start_point == "start_of_level" )
	{
		struct.trucks = intro_spawn_trucks();

		foreach ( truck in struct.trucks )
		{
			if ( IsSpawner( truck ) )
			{
				continue;
			}

			if ( !IsDefined( truck.script_noteworthy ) )
			{
				continue;
			}

			if ( truck.script_noteworthy == "last_truck" )
			{
				truck ThermalDrawEnable();
				struct.docks_truck = truck;
			}
		}
	}

	if ( is_start_point_before( "docks_assault_ambush" ) )
	{
		array_spawn_targetname( "docks_worker" );
		array_spawn_targetname( "intro_sas" );
	}

	level.intro_controller = struct;
}

intro_cleanup()
{
	if ( !IsDefined( level.intro_controller ) )
	{
		return;
	}

	delete_cargo();

	level.intro_controller.forklift Delete();
	level.intro_controller.forklift_static Show();

	// Clean up the enemy ai
	if ( IsDefined( level.docks_worker_ai ) )
	{
		foreach ( ai in level.docks_worker_ai )
		{
			if ( !IsDefined( ai ) )
			{
				continue;
			}
	
			if ( IsDefined( ai.script_parameters ) && ai.script_parameters == "keep" )
			{
				ai thread postspawn_docks_ai();
				continue;
			}
	
			ai Delete();
		}
	}

	level.docks_worker_ai = undefined;
	level.intro_controller = undefined;
}

delete_cargo()
{
	cargo = level.intro_controller.forklift.cargo;

	if ( !IsDefined( cargo ) )
	{
		return;
	}

	array_call( cargo.ents, ::Delete );
	cargo Delete();
}

intro_dialogue()
{
	wait( 1 );
	radio_dialogue( "london_ldr_seeingthis" );
//	wait( 0.5 );
	radio_dialogue( "london_com_haveeyes" );

//	level.intro_controller.forklift ent_flag_wait( "cargo_unloading" );
//	wait( 1 );

	radio_dialogue( "london_ldr_focusontrucks" );
	wait( 0.5 );
	radio_dialogue( "london_ldr_trucksaremovin" );

	flag_wait( "trucks_are_moving" );
//	radio_dialogue( "london_ldr_trucksaremovin" );
//	radio_dialogue( "london_hp1_wereonit" );
	radio_dialogue( "london_dlt2_guysay" );
	radio_dialogue( "london_ldr_somethingbig" );

	radio_dialogue( "london_ldr_rollingout" );
	radio_dialogue( "london_dlt1_outallnight" );
	radio_dialogue( "london_ldr_wilco" );

	flag_wait( "uav_focusing_on_enemies" );
//	wait( 3 );
	radio_dialogue( "london_trk_packinheat" );
	radio_dialogue( "london_ldr_eyesopen" );

	flag_wait( "uav_focusing_on_player" );

//	wait( 2 );
	radio_dialogue( "london_ldr_readytorock" );
	wait( 0.5 );
	radio_dialogue( "london_com_missionisgo" );
//	radio_dialogue( "london_ldr_gettowork" );
	wait( 0.5 );
	level.sas_leader dialogue_queue( "london_ldr_gettowork" );

	flag_set( "uav_dialog_done" );
}

intro_flavor_bursts()
{
	if ( !IsDefined( level.player_radio_emitter ) )
	{
		ent = Spawn( "script_origin", ( 0, 0, 0 ) );
		ent LinkTo( level.player, "", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		level.player_radio_emitter = ent;
	}

	radio_dialogue_overlap( "london_uav1_tapesrollin" );
	radio_dialogue_overlap( "london_uav2_2miles" );
	radio_dialogue_overlap( "london_ovl_copy2miles" );
	radio_dialogue_overlap( "london_uav1_notcleared" );

	radio_dialogue_overlap( "london_ovl_5trucks" );
//	radio_dialogue_overlap( "london_uav1_5vehicles" );
	radio_dialogue_overlap( "london_uav2_tracking" );
//	radio_dialogue_overlap( "london_ovl_keeptracking" );
	radio_dialogue_overlap( "london_uav1_roger" );

	level.intro_controller.forklift ent_flag_wait( "cargo_unloading" );

	radio_dialogue_overlap( "london_uav2_rollinout" );
	radio_dialogue_overlap( "london_uav1_movingout" );
	radio_dialogue_overlap( "london_ovl_twovans" );
//	radio_dialogue_overlap( "london_ovl_onlytwowehave" );

	flag_wait( "uav_focusing_on_enemies" );
	radio_dialogue_overlap( "london_ovl_squarebuilding" );
	radio_dialogue_overlap( "london_uav1_rogerthat" );
	radio_dialogue_overlap( "london_uav2_inwindows" );
	radio_dialogue_overlap( "london_uav1_visible" );
	radio_dialogue_overlap( "london_ovl_identifyweapons" );
	radio_dialogue_overlap( "london_uav1_definitelyhot" );
	radio_dialogue_overlap( "london_uav2_maderpg" );
}

intro_scene_forklift( uav )
{
	forklift = level.intro_controller.forklift;

	forklift thread gopath();
	forklift.animname = "forklift";
	forklift assign_animtree();
	forklift forklift_lights();

	uav thread uav_target_tracking( forklift );

	forklift ent_flag_wait( "up" );
	forklift maps\london_docks_anim::forklift_up();

	forklift ent_flag_wait( "cargo_unloading" );

//	wait( 3 );

	forklift ent_flag_set( "cargo_unloaded" );
	forklift.cargo UnLink();

	forklift ent_flag_wait( "down" );
	forklift maps\london_docks_anim::forklift_down();

	forklift ent_flag_wait( "doors_closed" );
}

forklift_lights()
{
	PlayFXOnTag( getfx( "forklift_blinklight" ), self, "TAG_TAIL_LIGHT_CENTER" );
	PlayFxOnTag( getfx( "forklift_headlight" ), self, "TAG_HEADLIGHT_LEFT" );
	PlayFxOnTag( getfx( "forklift_headlight" ), self, "TAG_HEADLIGHT_RIGHT" );
}

// Workaround for not being able to set truck to notsolid
intro_truck()
{
	if ( level.start_point != "start_of_level" )
	{
		return;
	}

	spawner = GetEnt( "last_truck", "script_noteworthy" );

	// The origin/angles are based on the physics vehicle being spawned
	origin = ( 76711, -3562, 456.479 );
	angles = ( 0.0894979, 12.238, -0.00146479 );

	faketruck = Spawn( "script_model", origin );
	faketruck.angles = angles;
	faketruck SetModel( spawner.model );
	faketruck ThermalDrawEnable();

	faketruck.animname = "delivery_truck";
	faketruck assign_animtree();

	level thread truck_door_idle( faketruck );

//	faketruck thread anim_single_solo( faketruck, "docks_doors_open_nosound" );

	forklift = level.intro_controller.forklift;
	forklift ent_flag_wait( "down" );

//	faketruck anim_single_solo( faketruck, "docks_doors_close" );
	truck_door_close( faketruck );
	delete_cargo();

	spawner.angles = faketruck.angles;
	spawner.origin = faketruck.origin;

	truck = vehicle_spawn( spawner );
	faketruck Delete();
	level.intro_controller.trucks = array_insert( level.intro_controller.trucks, truck, 2 );

	forklift ent_flag_set( "doors_closed" );
}

intro_get_forklift_cargo()
{
	pallet = GetEnt( "forklift_pallet", "targetname" );
	pallet.ents = GetEntArray( pallet.target, "targetname" );

	array_call( pallet.ents, ::LinkTo, pallet );

	offset = ( 74, 0, 1 );
	pallet.origin = get_world_relative_offset( self.origin, self.angles, offset );
	pallet.angles = ( 5, self.angles[ 1 ] + 180, pallet.angles[ 2 ] );

	tag = "J_Fork_Lift";
	linkoffset = pallet.origin - self GetTagOrigin( tag );
	linkangles = pallet.angles - self GetTagAngles( tag );
	
	pallet LinkTo( self, tag, linkoffset, linkangles );

	self.cargo = pallet;
}

truck_door_idle( truck )
{
	guys = GetEntArray( "intro_truck_door_guy_ai", "targetname" );

	foreach ( guy in guys )
	{
		guy.animname = "truck_door_guy" + guy.script_index;
		truck thread anim_loop_solo( guy, "idle" );
		guy gun_remove();
	}

	truck thread maps\london_docks_anim::truck_doors_idle();
}

truck_door_close( truck )
{
	guys = GetEntArray( "intro_truck_door_guy_ai", "targetname" );
	truck notify( "stop_loop" );

	node = SpawnStruct();
	node.origin = truck.origin;
	node.angles = truck.angles;

	array_thread( guys, ::anim_stopanimscripted );
	array_thread( guys, ::truck_door_close_internal, node );

	truck maps\london_docks_anim::truck_doors_close();
}

truck_door_close_internal( node )
{
	node anim_single_solo( self, "close_door" );
	self gun_recall();
}

intro_scene_trucks( uav )
{
	array_thread( level.intro_controller.trucks, ::gopath );

//	thread lerp_fov_overtime( 1, 20 );
//	wait( 1 );
	flag_set( "trucks_are_moving" );
	uav thread uav_target_tracking( level.intro_controller.trucks[ 2 ], 0.80, 100 );
	wait( 4 );
	uav thread uav_target_tracking( level.intro_controller.trucks[ 1 ], 0.80, 200 );
	wait( 3 );
	uav thread uav_target_tracking( level.intro_controller.trucks[ 0 ], 0.80, 300 );
	wait( 3 );
}

intro_scene_patrol_look( uav )
{
	struct = getstruct( "uav_warehouse2_lookpoint", "targetname" );
	uav thread uav_target_tracking( struct );
	wait( 8 );

	array_spawn_targetname( "warehouse_worker" );

	flag_set( "uav_focusing_on_enemies2" );
	struct = getstruct( "uav_warehouse_lookpoint", "targetname" );
	uav thread uav_target_tracking( struct );
	wait( 10 );
}

intro_scene_playerstart( uav )
{
	thread intro_fake_player();
	
	temp_struct = SpawnStruct();
	temp_struct.origin = level.intro_controller.ground_origin;
//	uav thread uav_target_tracking( temp_struct, 0.89 );
	uav notify( "stop_uav_target_tracking" );
	time = 4;
	uav.target_ent MoveTo( temp_struct.origin, time, time * 0.5, time * 0.5 );
	flag_set( "start_fence_climb" );

	wait( 2 );
}

intro_fake_player()
{
	spawner = GetEnt( "intro_fake_player", "targetname" );
	
	structs = getstructarray( "docks_start", "targetname" );
	struct = undefined;
	foreach ( temp in structs )
	{
		if ( !IsDefined( temp.script_noteworthy ) )
		{
			continue;
		}

		if ( temp.script_noteworthy == "player" )
		{
			struct = temp;
		}
	}

	struct.origin = drop_to_ground( struct.origin );
	spawner.origin = struct.origin;
	spawner.angles = struct.angles;

	// If we have too many AI, delete the furthest docks worker, since they get deleted anyway
	ais = GetAiArray();
	if ( ais.size == 32 )
	{
		array = SortByDistance( level.docks_worker_ai, spawner.origin );
		foreach ( ai in array )
		{
			if ( !IsDefined( ai ) )
			{
				continue;
			}
	
			if ( IsDefined( ai.script_parameters ) && ai.script_parameters == "keep" )
			{
				continue;
			}
	
			ai Delete();
			break;
		}
	}

	ai = spawner spawn_ai( true );
	ai.name = "Sgt. Burns";

	struct thread anim_generic_loop( ai, "alert_idle" );

	flag_wait( "slamzoom_rotate" );
	wait( 0.4 );
	ai Delete();
}

intro_uav_add_targets()
{
	ents = GetAiArray( "allies" );
	array_thread( ents, ::uav_add_target );
	array_thread( ents, ::uav_remove_target_ondeath );
}

uav_cloud_thread()
{
	self endon( "slamzoom" );

	while ( 1 )
	{
		wait( RandomFloatRange( 2, 3 ) );

		forward = AnglesToForward( self.angles );
		up = AnglesToForward( self.angles ); 
		PlayFXOnTag( getfx( "clouds_predator" ), self.view_controller, "tag_aim" );
	}
}

uav_slamzoom()
{
	ground_origin = level.intro_controller.ground_origin;
	ground_angles = level.intro_controller.ground_angles;

	level.player uav_disable_view( 1 );
	VisionSetNaked( "uav_flir_Thermal", 0 );
	uav_clear_targets();
	
	ground_origin = ground_origin + ( 0, 0, 0 );

	level.player PlayerSetStreamOrigin( ground_origin );
	flying_ent = Spawn( "script_origin", self.view_controller GetTagOrigin( "tag_aim" ) );
	
	angles = VectorToAngles( ground_origin - self.view_controller GetTagOrigin( "tag_aim" ) );
	flying_ent.angles = angles;
	level.player FreezeControls( true );

	level.player SetOrigin( flying_ent.origin );
	level.player SetPlayerAngles( angles );
	wait( 0.05 );

//	org = level.player.origin;
	level.player PlayerLinkTo( flying_ent, undefined, 1, 0, 0, 0, 0 );
	self.view_rig Delete();

	level.player PlaySound( "player_slamzoom" );
	flying_ent MoveTo( ground_origin, 2, 0, 1 );
	level.player LerpFOV( 65, 2.5 );
	level.player delaythread( 1, ::vision_set_fog_Changes, "london_docks", 2 );

	thread lerp_saveddvar( "sm_cameraoffset", 0, 2 );

	wait( 1.0 );
//	thread lerp_saveddvar( "sm_sunsamplesizenear", 0.25, 1.0 );

	wait( 0.5 );

	flag_set( "alley_start" );
	flag_set( "slamzoom_rotate" );

	self Show();
	flying_ent RotateTo( ground_angles, 0.5, 0.25, 0.25 );
	wait( 0.5 );
	level.player Unlink();

	thread maps\_utility::set_ambient( "london_docks" );

	level.player uav_enable_weapons();
	level.player PlayerClearStreamOrigin();

	// Clean up Ents
	flying_ent Delete();
}

intro_spawn_trucks()
{
	trucks = spawn_vehicles_from_targetname( "docks_truck1" );

	trucks_sorted = [];
	foreach ( truck in trucks )
	{
		if( IsDefined( truck.script_noteworthy ) )
		{
			if ( truck.script_noteworthy == "lead_truck" )
			{
				trucks_sorted = array_insert( trucks_sorted, truck, 0 );
			}
			else
			{
				trucks_sorted[ trucks_sorted.size ] = truck;
			}
		}

		else
		{
			trucks_sorted[ trucks_sorted.size ] = truck;
		}
	}

	return trucks_sorted;
}

light_dvar_thread()
{
	ground = 456;
	dvar = "sm_lightscore_eyeprojectdist";
	while ( !flag( "alley_start" ) )
	{
		z = level.player.origin[ 2 ];
		height = z - ground;

		angles = level.player GetPlayerAngles();
		pitch = angles[ 0 ];

		l = height / cos( 90 - pitch );
		
		SetSavedDvar( dvar, l );
		wait( 0.2 );
	}

	SetSavedDvar( dvar, 64 );
}

//---------------------------
// Alley section
//---------------------------
alley_sas_movement()
{
//// TESTING!
///#
//	if ( GetDvarInt( "test_alley_bug" ) == 1 )
//	{
//		foreach ( guy in level.sas_squad )
//		{
//			guy.goalradius = 32;
//			guy walkdist_zero();
//			guy.ignoresuppression = 1;
//			guy docks_enable_cqbwalk();
//			guy disable_arrivals();
//			guy disable_exits();
//			guy disable_surprise();
//		
//			guy.dontavoidplayer = true;
//		}
//
//		leader_node = GetNode( "pf2_auto831", "target" );
//		other_node = GetNode( "pf2_auto834", "targetname" );
//
//		level.sas_squad[ 0 ] SetGoalNode( leader_node );
//		level.sas_squad[ 1 ] SetGoalnode( other_node );
//
//		level.sas_squad[ 0 ] waittill( "goal" );
//		wait( 15 );
//		node = GetNode( leader_node.target, "targetname" );
//		level.sas_squad[ 0 ] SetGoalNode( node );
//
//		return;
//	}
//#/

	level.sas_squad[ 1 ] thread alley_movement_think();
	flag_wait( "start_fence_climb" );

	if ( is_start_point_or_before( "post_intro" ) )
	{
		level thread alley_start_dialogue();
	}

	level.sas_squad[ 0 ] thread alley_movement_think();
	level.sas_squad[ 1 ] thread friendly_window_explosion_reaction();
}

alley_movement_think()
{
	self walkdist_zero();
	self docks_enable_cqbwalk();
	self disable_arrivals();
	self disable_exits();
	self disable_surprise();

	self.dontavoidplayer = true;
	self scripted_movement( ::alley_movement_func, true );

	self enable_ai_color();
}

alley_movement_func( note, goal )
{
	if ( !IsDefined( note ) )
	{
		return;
	}
	
	switch ( note )
	{
		case "alley_climb_in":
			self alley_climb_in( goal );
			break;
		case "alley_comm_check":
			self alley_comm_check( goal );
			break;
		case "alley_enemy_cellphone":
			self alley_quick_kill_enemy_cellphone( goal );
			break;
		case "alley_enemy_sleeping":
			self alley_quick_kill_enemy_sleeping( goal );
			break;
		case "alley_enemy_warehouse":
			self alley_quick_kill_enemy_warehouse( goal );
			break;
//		case "alley_enemy_warehouse_dialogue":
//			self alley_enemy_warehouse_dialogue( goal );
//			break;
		case "last_alley":
			self last_alley( goal );
			break;
		case "alley_sprint":
			self alley_sprint( goal );
			break;
		case "warehouse_breach_cutter":
			self warehouse_cutter( goal );
			break;
		case "warehouse_breach_breacher":
			self warehouse_breacher( goal );
			break;
		case "warehouse_hallway":
			self warehouse_hallway( goal );
			break;
		case "warehouse_melee1":
			self warehouse_melee( note, goal );
			flag_wait( "warehouse_player_lead_0" );
			self warehouse_melee_cleanup( goal );

			level thread warehouse_cqb_thread();
			break;
	}
}

//alley_enemy_warehouse_dialogue( goal )
//{
//	self thread alley_enemy_warehouse_dialogue_thread();
//
//	self SetGoalNode( goal );
//	self waittill( "goal" );
//}

alley_climb_in( goal )
{
	flag_wait( "uav_slamzoom" );
	goal thread anim_single_solo( self, "alley_fence_traverse" );
}

alley_comm_check( goal )
{
	flag_wait( "alley_start" );

	self anim_stopanimscripted();
	self thread anim_single_solo( self, "alley_comm_trans" );
}

alley_comm_check_intro_anim()
{
	level.sas_leader anim_single_solo( level.sas_leader, "alley_comm_check" );

	if ( flag( "alley_start" ) )
	{
		return;
	}

	level.sas_leader thread anim_loop_solo( level.sas_leader, "alley_comm_idle" );
}

alley_quick_kill_enemy_cellphone( goal )
{
	self enable_arrivals();
	self enable_exits();

	self SetGoalNode( goal );
	self waittill( "goal" );

	// Whoever gets here first will be the initial shooter.
	if ( level.alley_quick_kills >= 1 )
	{
		return;
	}

	level.alley_quick_kills++;

	flag_wait( "alley_spawn_enemy_cellphone" );
	wait( 1 );

	enemy = GetEnt( "alley_enemy_cellphone_ai", "targetname" );

	if ( !IsDefined( enemy ) || !IsAlive( enemy ) )
	{
		return;
	}

	// Send in both sas cause the player can mess with the scene.
	shooters = [ self, self get_opposite_sas() ];

	// It's safe to thread since both AI rely on a flag_wait (set on their node)
	thread quick_kill( shooters, enemy, 1, ::alley_quick_kill_enemy_cellphone_delay );
}

alley_quick_kill_enemy_cellphone_delay( shooters, enemy )
{
	while ( 1 )
	{
		if ( !IsAlive( enemy ) )
		{
			break;
		}

		if ( enemy GetAnimTime( enemy getanim_generic( "enemy_cellphone" ) ) > 0.7 )
		{
			break;
		}

		if ( IsDefined( enemy.kill_now ) )
		{
			break;
		}

		wait( 0.05 );
	}	
}

alley_quick_kill_enemy_sleeping( goal )
{
	enemies = GetEntArray( "alley_enemy_sleeping_ai", "targetname" );

	other_sas = self get_opposite_sas();

	self cqb_aim( enemies[ 0 ] );
	self enable_arrivals();
	self enable_exits();

	self SetGoalNode( goal );
	self waittill( "goal" );

	if ( level.alley_quick_kills >= 2 )
	{
		return;
	}

	level.alley_quick_kills++;

	shooters = [ self, other_sas ];

	flag_wait_or_timeout( "alley_enable_sleeper_kill", 10 );

	if ( flag( "alley_enable_sleeper_kill" ) )
	{
		wait( 1 + RandomFloat( 2 ) );
	}

	foreach ( enemy in enemies )
	{
		if ( !IsDefined( enemy ) )
		{
			continue;
		}

		if ( !IsAlive( enemy ) )
		{
			continue;
		}

		quick_kill( shooters, enemy, 2, ::alley_quick_kill_enemy_sleeping_delay );
	}
}

alley_quick_kill_enemy_sleeping_delay( shooters, enemy )
{
	enemy endon( "death" );

	if ( IsDefined( enemy.kill_now ) )
	{
		return;
	}

	wait( 0.5 );
}

alley_quick_kill_enemy_warehouse( goal )
{
	self enable_arrivals();
	self enable_exits();

	self SetGoalNode( goal );
	self waittill( "goal" );

	if ( level.alley_quick_kills >= 3 )
	{
		return;
	}

	level.alley_quick_kills++;

	enemies = GetEntArray( "alley_enemy_warehouse_ai", "targetname" );
	enemies = array_removedead_or_dying( enemies );

	shooters = [ self ];

	foreach ( enemy in enemies )
	{
		if ( !IsDefined( enemy ) )
		{
			continue;
		}

		if ( !IsAlive( enemy ) )
		{
			continue;
		}

		quick_kill( shooters, enemy, 2 );
		wait( 0.2 );
	}
}

last_alley( goal )
{
	self SetGoalNode( goal );
	self waittill( "goal" );

	flag_wait( "alley_go_to_breach" );
	flag_wait( "warehouse2_done" );

	if ( self == level.sas_leader )
	{
		self last_alley_dialogue();
		flag_set( "last_alley_dialogue_done" );
	}
	else
	{
		flag_wait( "last_alley_dialogue_done" );
	}

	goal script_delay();

	if ( self == level.sas_squad[ 1 ] )
	{
		self thread last_alley_cleared();
	}
}

last_alley_cleared()
{
	flag_wait( "alley_enemy_warehouse_dead" );
	level.sas_squad[ 1 ] delaythread( 0.5, ::dialogue_queue, "london_trk_alleyclear" );
}

last_alley_dialogue()
{
	enemies = GetEntArray( "alley_enemy_warehouse_ai", "targetname" );

	enemies = array_removedead_or_dying( enemies );
	if ( enemies.size > 0 )
	{
		level.sas_squad[ 1 ] dialogue_queue( "london_trk_10meters" );
	}

	enemies = array_removedead_or_dying( enemies );
	if ( enemies.size > 0 )
	{
		level.sas_leader dialogue_queue( "london_ldr_onme" );
	}

//	while ( enemies.size > 0 )
//	{
//		wait( 0.05 );
//		enemies = array_removedead_or_dying( enemies );
//	}
}

quick_kill( shooters, enemy, shots, delay_func )
{
	if ( !IsDefined( enemy ) || !IsAlive( enemy ) )
	{
		return;
	}

	array_thread( shooters, ::cqb_aim, enemy );

	if ( IsDefined( delay_func ) )
	{
		[[ delay_func ]]( shooters, enemy );
	}

	if ( !IsDefined( enemy ) || !IsAlive( enemy ) )
	{
		array_thread( shooters, ::cqb_aim, undefined );
		return;
	}

	enemy.dontattackme = undefined;

	if ( shots == 1 )
	{
		enemy.health = 1;
	}

	// TODO: use GetMuzzlePos instead of getting tag_flash
	start_pos = shooters[ 0 ] GetTagOrigin( "tag_flash" );
	end_pos = enemy GetTagOrigin( "j_head" );
	trace = BulletTrace( start_pos, end_pos, true );

	if ( shooters.size > 1 )
	{
		if ( IsDefined( trace[ "entity" ] ) && trace[ "entity" ] == level.player )
		{
			shooters = array_reverse( shooters );
		}
	}

	// Play Fire anim
	num = RandomInt( shooters[ 0 ].a.array[ "single" ].size );
	fireanim = shooters[ 0 ].a.array[ "single" ][ num ];
	rate = 0.1 / WeaponFireTime( shooters[ 0 ].weapon );

	if ( !IsAlive( enemy ) )
	{
		array_thread( shooters, ::cqb_aim, undefined );		
		return;
	}

	for ( i = 0; i < shots; i++ )
	{
		if ( IsAlive( enemy ) )
		{
			end_pos = enemy GetTagOrigin( "j_head" );

			// On the last shot, make sure we kill him.
			if ( shots - i == 1 )
			{
				enemy.health = 1;
			}
		}

		offset = ( 0, 0, 0 );
		if ( shots - i > 1 )
		{
			offset = ( 0, 0, RandomFloatRange( 5, 15 ) * -1 );
		}

		shooters[ 0 ] SetFlaggedAnimKnobRestart( "fire_notify", fireanim, 1, 0.2, rate );
		shooters[ 0 ] waittillmatch_or_timeout( "fire_notify", "fire", 0.2 );

		start_pos = shooters[ 0 ] GetTagOrigin( "tag_flash" );
		
		shooters[ 0 ] safe_magic_bullet( start_pos, end_pos + offset );
	
		if ( shots - i > 1 )
		{
			wait( 0.15 + RandomFloat( 0.1 ) );
		}
	}

	if ( IsAlive( enemy ) )
	{
		if ( IsDefined( enemy.magic_bullet_shield ) )
		{
			enemy stop_magic_bullet_shield();
		}

		enemy Kill();
	}

	array_thread( shooters, ::cqb_aim, undefined );
}

alley_sprint( goal )
{
//	level.sas_leader thread anim_single_solo( level.sas_leader, "london_ldr_gogogo" );
}

alley_start_dialogue()
{
	flag_wait( "uav_dialog_done" );
	skip_ending_popup();

	level.sas_leader dialogue_queue( "london_ldr_youclean" );
}

alley_quick_kills()
{
/#
	if ( level.start_point != "start_of_level" && level.start_point != "post_intro" && level.start_point != "2nd_alley" )
	{
		return;
	}
#/

	door = GetEnt( "alley_enemy_cellphone_door", "targetname" );
	door RotateTo( ( 0, -90, 0 ), 0.2 );

	flag_wait( "alley_spawn_enemy_cellphone" );

	if ( level.start_point != "2nd_alley" )
	{
		spawn_targetname( "alley_enemy_cellphone" );
	}

	array_spawn_targetname( "alley_enemy_sleeping" );
	level thread alley_enemy_sleeping_dialogue();
}

conditional_anim( reaction_func )
{
	node = self;
	if ( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		if ( !IsDefined( node ) )
		{
			node = getstruct( self.target, "targetname" );
		}
//		node = get_target_ent( self.target );
	}

	if ( !IsDefined( self.animname ) )
	{
		self.animname = "generic";
	}

	anime = self.script_animation;
	self.fovcosine = 0.5;

	loop = false;
	if ( IsDefined( self.script_looping ) )
	{
		loop = true;
	}

	if ( self is_valid_anim( anime + "_death" ) )
	{
		self magic_bullet_shield();
		self thread conditional_anim_death( node, anime );
	}

	if ( self is_valid_anim( anime + "_react" ) )
	{
		self thread conditional_anim_reaction( node, anime, reaction_func );
	}

	if ( IsDefined( level.scr_model[ anime + "_prop" ] ) )
	{
		prop = spawn_anim_model( anime + "_prop" );
		self.anim_props = [ prop ];
		node thread anim_first_frame_solo( prop, anime + "_death" );
	}

	if ( loop )
	{
		node thread anim_loop_solo( self, anime );
	}
	else
	{
		node thread anim_single_solo( self, anime );
	}
}

conditional_anim_props( node, anime )
{
	if ( !IsDefined( self.anim_props ) )
	{
		return;
	}

	if ( !self is_valid_anim( anime ) )
	{
		return;
	}

	node thread anim_single( self.anim_props, anime );
}

conditional_anim_add_alert_friends( tag )
{
	if ( !IsDefined( level.alert_friends ) )
	{
		level.alert_friends = [];
	}

	if ( !IsDefined( level.alert_friends[ tag ] ) )
	{
		level.alert_friends[ tag ] = [];
	}

	size = level.alert_friends[ tag ].size;
	level.alert_friends[ tag ][ size ] = self;

	if ( !IsDefined( self.alert_friend_tags ) )
	{
		self.alert_friend_tags = [];
	}

	self.alert_friend_tags[ self.alert_friend_tags.size ] = tag;
}

conditional_anim_alert_friends( suffix )
{
	if ( !IsDefined( self.alert_friend_tags ) )
	{
		return;
	}

	foreach ( tag in self.alert_friend_tags )
	{
		foreach ( ai in level.alert_friends[ tag ] )
		{
			ai notify( "friend_" + suffix );
		}
	}
}

conditional_anim_death( node, anime )
{
	self endon( "stop_conditional_anim_death" );

	anim_length = GetAnimLength( self getanim( anime + "_death" ) );

	self waittill( "damage" );
	self notify( "stop_conditional_anim_reaction" );

	self thread conditional_anim_alert_friends( "died" );

	// Stop previous loop
	node notify( "stop_loop" );

	if ( IsDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}

	percent = 0.8;
	if ( IsDefined( self.script_percent ) )
	{
		percent = self.script_percent * 0.01;
	}

	self delaythread( anim_length * percent, ::conditional_anim_kill );

	no_death_node = false;
	if ( IsDefined( self.script_parameters ) )
	{
		no_death_node = self.script_parameters == "no_death_node";
	}

	thread conditional_anim_props( node, anime + "_death" );

	self notify( "play_death_anim" );

	if ( no_death_node )
	{
		self anim_single_solo( self, anime + "_death" );
	}
	else
	{
		node notify( "stop_loop" );
		node anim_single_solo( self, anime + "_death" );
	}
}

conditional_anim_kill()
{
	if ( IsDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}

//	self.a.nodeath = true;
	script_do_ragdoll = false;
	if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "do_ragdoll" )
		{
			script_do_ragdoll = true;
		}
	}

	if ( !IsDefined( self.do_ragdoll ) )
	{
		self.do_ragdoll = script_do_ragdoll;
	}

	self.deathanim = undefined;
	self.ragdoll_immediate = undefined;
	self.deathfunction = ::conditional_anim_handledeath;
	self.allowdeath = true;
	self Kill();
}

conditional_anim_handledeath()
{
	self animscripts\shared::DropAllAIWeapons();
	wait( 0.1 );

	if ( self.do_ragdoll )
	{
		self StartRagDoll();
	}

	return true;
}

simple_reaction( node, exit_on_react )
{
	self endon( "death" );
	self endon( "stop_conditional_anim_reaction" );

	type = self conditional_anim_reaction_waittill();

	self conditional_anim_alert_friends();

	self.ignoreall = false;
	self.fovcosine = 0.1;
	self.reacted = true;

	radius = 300;
	if ( IsDefined( self.script_radius ) )
	{
		radius = self.script_radius;
	}

	self.goalradius = radius;

	self notify( "stop_conditional_anim_death" );
	if ( IsDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}

	if ( IsDefined( exit_on_react ) )
	{
		return;
	}

	// Just Stand
	if ( IsDefined( node ) )
	{
		node notify( "stop_loop" );
	}

	self anim_stopanimscripted();

	// _patrol cleanup
	self notify( "end_patrol" );
	self clear_run_anim();
	self AllowedStances( "stand", "crouch", "prone" );
	self enable_arrivals();
	self enable_exits();

	if ( IsDefined( self.script_animation ) )
	{
		self.allowdeath = true;
		self.ragdoll_immediate = true;
	
		if ( IsDefined( node ) )
		{
			node anim_generic( self, self.script_animation );
		}
		else
		{
			self anim_generic( self, self.script_animation );
		}

		self.ragdoll_immediate = undefined;
		return;
	}

	if ( IsDefined( self.gun_removed ) )
	{
		self gun_recall();
	}
}

conditional_anim_reaction_waittill()
{
	self endon( "death" );

//	if ( IsDefined( self.react_to_enemy ) )
//	{
//		self thread conditional_anim_reaction_wait( "enemy" );
//	}

	if ( IsDefined( self.pre_reaction_delay ) )
	{
		wait( self.pre_reaction_delay );
	}

	self thread conditional_anim_reaction_wait( "react" );
	self thread conditional_anim_reaction_wait( "doFlashBanged" );
	self thread conditional_anim_reaction_wait( "explode" );
	self thread conditional_anim_reaction_wait( "too_close" );
	self thread conditional_anim_reaction_wait( "bulletwhizby" );
	self thread conditional_anim_reaction_wait( "friend_died" );
	self thread conditional_anim_reaction_wait( "friend_reacted" );

	self thread conditional_anim_radius_reaction();
	self waittill( "conditional_anim_reaction", type );
	println( "reaction type = ", type );

	if ( IsDefined( self.reaction_delay ) )
	{
		wait( self.reaction_delay );
	}

	if ( type == "friend_died" )
	{
		wait( RandomFloatRange( 0.4, 0.6 ) );
	}

	return type;
}

conditional_anim_reaction( node, anime, reaction_func )
{
	self endon( "death" );
	self endon( "stop_conditional_anim_reaction" );

	type = self conditional_anim_reaction_waittill();

	self conditional_anim_alert_friends( "reacted" );

	self notify( "conditional_anim_react" );
	self notify( "stop_conditional_anim_death" );
	if ( IsDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}

	// Stop previous loop
	node notify( "stop_loop" );

	if ( IsDefined( reaction_func ) )
	{
		self thread [[ reaction_func ]]( type );
	}

	thread conditional_anim_props( node, anime + "_death" );

	if ( type != "doFlashBanged" )
	{
		no_death_node = false;
		if ( IsDefined( self.script_parameters ) )
		{
			if ( self.script_parameters == "kill_on_reaction" )
			{
				percent = 0.8;
				if ( IsDefined( self.script_percent ) )
				{
					percent = self.script_percent * 0.01;
				}

				anim_length = GetAnimLength( self getanim( anime + "_react" ) );
				self delaythread( anim_length * percent, ::conditional_anim_kill );
			}

			no_death_node = self.script_parameters == "no_death_node";

		}

		if ( IsString( level.scr_anim[ self.animname ][ anime + "_react" ] ) )
		{
			// Just Stand
			node notify( "stop_loop" );
			self notify( "stop_loop" );
			self anim_stopanimscripted();
		}
		else
		{
			self.allowdeath = true;
			self.ragdoll_immediate = true;

			if ( !IsDefined( self.ragdoll_directionScale ) )
			{
				self.ragdoll_directionScale = 500;
			}

			if ( no_death_node )
			{
				self anim_single_solo( self, anime + "_react" );
			}
			else
			{
				node anim_single_solo( self, anime + "_react" );
			}
			self.ragdoll_immediate = undefined;
		}
	}

	if ( IsDefined( self.gun_removed ) )
	{
		self gun_recall();
	}
}

conditional_anim_reaction_wait( msg )
{
	self endon( "death" );
	self waittill( msg );
	self notify( "conditional_anim_reaction", msg );
}

conditional_anim_radius_reaction()
{
	self endon( "death" );
	self endon( "conditional_anim_reaction" );

	dist = 300;
	if ( IsDefined( self.radius ) )
	{
		dist = self.radius;
	}

	dist *= dist;

	trigger = undefined;
	ent = GetEnt( self.target, "targetname" );

	if ( IsDefined( ent ) )
	{
		if ( ent.code_classname == "trigger_multiple" )
		{
			trigger = ent;
		}
	}

	while ( 1 )
	{
		wait( 0.05 );
		if ( DistanceSquared( level.player.origin, self.origin ) < dist )
		{
			break;
		}

		if ( !IsDefined( trigger ) )
		{
			continue;
		}

		if ( level.player IsTouching( trigger ) )
		{
			break;
		}
	}

	self notify( "too_close" );
}

//---------------------------------------------------------
// Warehouse section
//---------------------------------------------------------
warehouse_cutter( goal )
{
	prefix = "warehouse_breach_cut";

	self.boltcutters = Spawn( "script_model", self.origin + ( 0, 0, -150 ) );
	self.boltcutters SetModel( "com_bolt_cutter_animated" );
	self.boltcutters Hide();
	self.boltcutters.animname = "boltcutters";
	self.boltcutters setanimtree();

	ents = [ self, self.boltcutters ];

	goal anim_reach_solo( self, prefix + "_trans" );

	self.boltcutters PlaySound( "scn_london_boltcut_a_entry" );
	goal anim_single( ents, prefix + "_trans" );

	self.boltcutters PlaySound( "scn_london_boltcut_a_idle" );
	goal thread anim_loop( ents, prefix + "_idle" );

	flag_wait( "warehouse_breacher_in_position" );

	self anim_generic( self, "london_dlt1_ready" );

	trigger_on( "warehouse_delayed_flag_trigger", "targetname" );

	// We clear the flag just before waiting for it. 
	// Fixes issue if player leaves the area before breach actually occurs.
	flag_clear( goal.script_flag_wait );
	flag_wait( goal.script_flag_wait );

	flag_set( "warehouse_breacher_enter" );

	autosave_by_name( "warehouse_breach" );

//	array_spawn_targetname( "warehouse_enemies_group1" );

	goal notify( "stop_loop" );
	waittillframeend; // So notifies get processed

	self.ignoreall = false;
	self.boltcutters PlaySound( "scn_london_boltcut_a_breach" );
	goal thread anim_single( ents, prefix + "_enter" );

	level thread warehouse_padlock();
	
}

warehouse_padlock()
{
	door = GetEnt( "warehouse_door", "targetname" );
	latch2 = GetEnt( "warehouse_padlock_latch2", "targetname" );
	latch2 LinkTo( door );

	padlock = GetEnt( "warehouse_padlock", "targetname" );
	latch = GetEnt( "warehouse_padlock_latch", "targetname" );

	z = 457;

	wait( 1.6 );

	fall_time = 0.4;
	padlock MoveTo( ( padlock.origin[ 0 ], padlock.origin[ 1 ] - 10, z ), fall_time, fall_time * 0.8, 0 );
	padlock RotateTo( ( 90, RandomIntRange( -90, 90 ), 0 ), fall_time, fall_time * 0.8, 0 );
}

warehouse_breacher( goal )
{
	prefix = "warehouse_breacher";

	goal anim_reach_solo( self, prefix + "_trans" );
	goal anim_single_solo( self, "warehouse_breacher_trans" );

	goal thread anim_loop_solo( self, prefix + "_idle" );
	self thread nag_thread( "stackup_nag", 2, "warehouse_breacher_enter", undefined, undefined, 45 );

	if ( GetDvarInt( "slow_breach" ) > 0 )
	{
		warehouse_player_breach( self );
	}

	flag_set( "warehouse_breacher_in_position" );
	flag_wait( "warehouse_breacher_enter" );

	goal notify( "stop_loop" );
//	self anim_stopanimscripted();
	waittillframeend; // So notifies get processed

//	level.player delaycall( 3.5, ::Unlink );
	self thread warehouse_post_breach_dialogue();
	goal anim_single_solo( self, prefix + "_enter" );
}

warehouse_post_breach_dialogue()
{
	wait( 3.5 );
	self dialogue_queue( "london_ldr_roomclear" );
	self dialogue_queue( "london_ldr_upstairs" );
}

warehouse_player_breach( guy )
{
//	self thread maps\_debug::drawtagforever( "tag_origin" );

	offset = ( -40, -16, 0 );
	angles = ( 0, 20, 0 );
	origin = get_world_relative_offset( guy.origin, guy.angles, offset );
//	thread maps\_debug::drawArrow( origin, guy.angles + angles, undefined, 1000 );

	ent = Spawn( "script_origin", origin );
	ent.angles = guy.angles + angles;
	ent LinkTo( guy, "tag_origin" );

	level.player lerp_player_view_to_position( origin, guy.angles + angles, 2, 1, 30, 30, 30, 30, true );
	level.player PlayerLinkToDelta( ent, "", 1, 30, 30, 30, 30 );

	flag_wait( "warehouse_breach" );	
}

warehouse_melee( note, goal )
{
	self enable_arrivals();
	self enable_exits();
	guys[ 0 ] = self;

	ents = GetEntArray( goal.targetname, "target" );

	enemy = undefined;
	foreach ( ent in ents )
	{
		if ( IsSpawner( ent ) )
		{
			continue;
		}

		enemy = ent;
	}

	if ( IsDefined( enemy ) && IsAlive( enemy ) && !enemy doinglongdeath() )
	{
		if ( IsDefined( enemy.reacted ) )
		{
			self.ignoreall = false;
		}

		enemy.animname = "attacker";
		guys[ guys.size ] = enemy;
		enemy thread warehouse_enemy_melee_animreach( goal, note );
		level.sas_squad[ 1 ] thread dialogue_queue( "london_gfn_gotashadow" );
	}
	else
	{
		flag_set( "warehouse_melee_ready" );
	}

	if ( flag( "warehouse_player_lead_0" ) )
	{
		warehouse_melee_finish( goal );
		return;
	}

	self SetGoalNode( goal );
	self waittill( "goal" );

	flag_wait( "warehouse_melee_ready" );
	flag_wait( "warehouse_first_hallway" );

	guys = array_removedead_or_dying( guys );

	if ( guys.size > 1 )
	{
		self.og_animname = self.animname;
		self.animname = "defender";
		self.melee_attacker = enemy;

		enemy notify( "stop_conditional_anim_reaction" );

		near_goal = false;
		if ( IsDefined( enemy.goalpos ) )
		{
			if ( DistanceSquared( enemy.origin, enemy.goalpos ) < 64 * 64 )
			{
				near_goal = true;
			}
		}

		if ( near_goal )
		{
			// Stops any looping AI animation already playing on the struct
			goal notify( "stop_loop" );
			goal anim_single( guys, note );
		}

		self.animname = self.og_animname;
		self.og_animname = undefined;
	}

	self thread dialogue_queue( "london_ldr_takepoint" );
	self.ignoreall = false;

	level thread nag_single( level.sas_squad, "takepoint_nag", "warehouse_player_lead_1", 10, 20 );		

	warehouse_melee_finish( goal );
}

warehouse_melee_cleanup( goal )
{
	if ( !IsDefined( level.warehouse_melee_enemy ) )
	{
		return;
	}

	if ( !IsAlive( level.warehouse_melee_enemy ) )
	{
		return;
	}

	guy = level.warehouse_melee_enemy;
	guy.ignoreme = false;

	self enable_heat_behavior( true );
	self.ignoreme = false;
	self disable_pain();

	self SetGoalNode( goal );
	guy waittill( "death" );

	self disable_heat_behavior();
	self.ignoreme = true;
	self enable_pain();
}

warehouse_melee_finish( goal )
{
	if ( IsDefined( goal.script_flag_set ) )
	{
		flag_set( goal.script_flag_set );
	}	
}

warehouse_enemy_melee_animreach( goal, note )
{
	self endon( "death" );

	self thread flag_set_on_death( "warehouse_melee_ready" );
	goal anim_reach_solo( self, note );
	flag_set( "warehouse_melee_ready" );
}

warehouse_hallway( goal )
{
	self enable_arrivals();
	self enable_exits();

	self PushPlayer( true );

	self.goalradius = goal.script_radius;

	self SetGoalNode( goal );
	self waittill( "goal" );

	self.goalradius = goal.radius;

	enemies = GetEntArray( "warehouse_hallway_ai", "targetname" );
	enemies = array_randomize( enemies );

	if ( enemies.size > 0 )
	{
		if ( self != level.sas_leader )
		{
			self thread dialogue_queue( "london_gfn_morningents" );
		}
	}

	shooters = [ self ];

	enemies = SortByDistance( enemies, shooters[ 0 ].origin );
	foreach ( enemy in enemies )
	{
		quick_kill( shooters, enemy, RandomIntRange( 2, 3 ) );
	}

	if ( self != level.sas_leader )
	{
		self thread dialogue_queue( "london_trk_roomclear" );
	}

	if ( self == level.sas_leader )
	{
		self delaythread( 2, ::dialogue_queue, "london_ldr_move" );
	}

	self PushPlayer( false );
}

warehouse_tv()
{
	flag_wait( "warehouse_first_hallway" );
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	CinematicInGameSync( "london_football" );
	level thread warehouse_tv_screen_thread();

	tvs = GetEntArray( "warehouse_tv", "script_noteworthy" );
	array_thread( tvs, ::warehouse_tv_thread );

	wait( 1 );

	flag_wait( "warehouse_complete" );
	StopCinematicInGame();

	foreach ( tv in tvs )
	{
		tv StopLoopSound();
//		StopFxOnTag( getfx( "interactive_tv_light" ), tv, "tag_origin" );

		if ( IsDefined( tv.tv_fx ) )
		{
			tv.tv_fx Delete();
		}
	}
}

warehouse_tv_screen_thread()
{
	level endon( "warehouse_complete" );
	while ( 1 )
	{
		CinematicInGameLoop( "london_football" );
		wait( 5 );

		while ( IsCinematicPlaying() )
		{
			wait( 0.5 );
		}
	}
}

warehouse_tv_thread()
{
	level endon( "warehouse_complete" );

	self PlayLoopSound( "scn_london_soccer_tv_loop" );
//	PlayFXOnTag( getfx( "interactive_tv_light" ), self, "tag_origin" );
	origin = self.origin + ( AnglesToForward( self.angles ) * 25 );
	self.tv_fx = SpawnFx( getfx( "interactive_tv_light" ), origin );
	TriggerFx( self.tv_fx );

	self waittill( "death" );
	self StopLoopSound();
//	StopFxOnTag( getfx( "interactive_tv_light" ), self, "tag_origin" );
	self.tv_fx Delete();
}

stop_scripted_movement()
{
	self notify( "stop_scripted_movement" );
}

scripted_movement( switch_func, use_cqb )
{
	self endon( "death" );
	self endon( "stop_scripted_movement" );
	if ( !ent_flag_exist( "scripted_movement" ) )
	{
		self ent_flag_init( "scripted_movement" );
	}

	self ent_flag_set( "scripted_movement" );

	goal = undefined;
	is_node = false;
	if ( IsDefined( self.target ) )
	{
		goal = GetNode( self.target, "targetname" );
		is_node = true;

		if ( !IsDefined( goal ) )
		{
			is_node = false;
			goal = getstruct( self.target, "targetname" );
		}
	}

	while ( 1 )
	{
		note = goal.script_noteworthy;

		// Could be expanded if we want, since script_assaultmode is a string.
		if ( IsDefined( goal.script_assaultnode ) )
		{
			self enable_sprint();

			if ( use_cqb )
			{
				self docks_disable_cqbwalk();
			}
		}
		else
		{
			self disable_sprint();

			if ( use_cqb )
			{
				self docks_enable_cqbwalk();
			}
		}

		self notify( "scripted_movement_next_goal" );

		if ( IsDefined( note ) )
		{
			self [[ switch_func ]]( note, goal );
		}
		else // Just moving through the world, then call the switch_func
		{
			if ( is_stop_goal( goal ) )
			{
				self enable_arrivals();
				self enable_exits();
			}
			else
			{
				self disable_arrivals();
				// Delay thread used cause we want the AI to get to do their exits if they are enabled currently
				self thread scripted_movement_disable_exits();
			}

			self scripted_goto_goal( goal, is_node );
			self [[ switch_func ]]( note, goal );
		}

		if ( IsDefined( goal.script_flag_wait ) )
		{
			flag_wait( goal.script_flag_wait );
		}

		goal script_delay();

		if ( IsDefined( goal.script_sound ) )
		{
			self thread dialogue_queue( goal.script_sound );
		}

		if ( !IsDefined( goal.target ) )
		{
			break;
		}

		target = goal.target;
		goal = GetNode( target, "targetname" );
		is_node	= true;

		if ( !IsDefined( goal ) )
		{
			is_node	= false;
			goal = getstruct( target, "targetname" );
		}
	}

	self ent_flag_clear( "scripted_movement" );
	self notify( "scripted_movement_done" );
}

scripted_movement_disable_exits()
{
	self endon( "scripted_movement_next_goal" );
	self endon( "scripted_movement_done" );
	wait( 2 );
	self disable_exits();
}

// Only used by scripted_movement
scripted_goto_goal( goal, is_node )
{
	do_arrival = false;

	if ( IsDefined( goal.radius ) && goal.radius != 0 )
	{
		self.goalradius = goal.radius;
	}

	if ( IsDefined( goal.script_flag_wait ) )
	{
		if ( !flag( goal.script_flag_wait ) )
		{
			level endon( goal.script_flag_wait );
		}
		else
		{
			// We don't need to sit on our spot, just go.
			return;
		}
	}

	if ( is_node )
	{
		self SetGoalNode( goal );
	}
	else
	{
		self SetGoalPos( goal.origin );
	}

	self waittill( "goal" );

	if ( IsDefined( goal.script_flag_set ) )
	{
		flag_set( goal.script_flag_set );
	}

	if ( do_arrival )
	{
		self.type = undefined;
		self.scriptedarrivalent = undefined;
	}
}

is_stop_goal( goal )
{
	if ( IsDefined( goal.script_delay ) || IsDefined( goal.script_delay_min ) )
	{
		return true;
	}

	if ( IsDefined( goal.script_flag_wait ) )
	{
		// If the flag is set, then we're not stopping.
		if ( !flag( goal.script_flag_wait ) )
		{
			return true;
		}
	}

	if ( IsDefined( goal.script_stopnode ) )
	{
		return true;
	}

	return false;
}

warehouse_cqb_thread()
{
	flag_wait( "warehouse_player_lead_2" );
	level.sas_leader thread dialogue_queue( "london_ldr_checkthosecorners" );

	flag_wait( "warehouse_player_lead_7" );
	radio_dialogue( "london_spt_takingtheshot" );

	flag_wait( "warehouse_player_lead_8" );
	array_thread( level.sas_squad, ::set_ignoreall, true );

	flag_wait( "warehouse_snipe_enemies" );
	radio_dialogue( "london_spt_sendthem" );
}

//---------------------------------------------------------
// Warehouse EXIT
//---------------------------------------------------------

warehouse_exit_reach()
{
//	flag_wait( "warehouse_top" );

//	struct = getstruct( "warehouse_kick_spot2", "targetname" );
//	struct anim_reach_solo( level.sas_leader, "window_kick_enter" );

//	iprintlnbold( "Warehouse EXIT is work-in-progress." );

	thread warehouse_exit_anim();

//	flag_wait( "warehouse_exit_dialogue_done" );
}

warehouse_exit_anim()
{
	warehouse_exit_dialogue();

//	struct anim_single_solo( level.sas_leader, "window_kick_enter" );	
//	struct thread anim_loop_solo( level.sas_leader, "window_kick_idle" );

	thread warehouse_exit();
}

warehouse_exit_dialogue()
{
//	radio_dialogue( "london_ldr_grinchup" );
	level.sas_leader dialogue_queue( "london_ldr_bravostatus" );
	level.sas_leader dialogue_queue( "london_trk_whatthehell" );

	wait( 6 );

	level.sas_leader thread nag_thread( "downhere_nag", 4, "warehouse_complete" );
}

warehouse_exit()
{
//	flag_wait( "sas_van_destroyed" );

//	struct notify( "stop_loop" );
//	level.sas_leader anim_stopanimscripted();

//	level.sas_leader anim_generic( level.sas_leader, "window_explosion_reaction" );

//	struct = getstruct( "warehouse_exit_door_animnode", "targetname" );
//	struct anim_reach_solo( level.sas_leader, "door_kick" );

//	level.sas_leader delaythread( 1.5, ::anim_stopanimscripted );
//	delaythread( 0.75, ::doorkick_door_open );
//	struct anim_single_solo( level.sas_leader, "door_kick" );	

	flag_set( "warehouse_exit" );

//	level.sas_leader enable_ai_color();

	flag_wait( "out_of_warehouse" );
	activate_trigger_with_noteworthy( "docks_enable_reinforcements" );
}

//doorkick_door_open()
//{
//	door = GetEnt( "warehouse_exit_door", "targetname" );
//	door ConnectPaths();
//	door PlaySound( "metal_door_kick" );
//	door RotateTo( ( 0, -120, 0 ), 0.5, 0.2, 0 );
//}

friendly_window_explosion_reaction()
{
	self waittill( "scripted_movement_done" );
	
	self thread anim_generic_loop( self, "window_explosion_reaction_idle" );

	flag_wait( "sas_van_destroyed" );
	wait( 0.3 );

	self notify( "stop_loop" );
	self anim_generic( self, "window_explosion_reaction" );
}

sas_van_rpg()
{
	wait( 3 );

	flag_wait( "out_of_warehouse" );

	level.sas_squad[ 1 ] thread generic_dialogue_queue( "london_spt_rpgloose" );
	rpg = spawn_vehicle_from_targetname_and_drive( "docks_van_rpg_hit2" );
	rpg waittill( "explode", origin );
	self SetCanDamage( true );

	PlayFx( getfx( "rpg_explode" ), origin );

	RadiusDamage( self.origin, 300, 500, 50 );
	self DoDamage( self.health, self.origin );

	play_sound_in_space( "scn_london_window_blowout", self.origin );
	
	flag_set( "sas_van_destroyed" );

//	level thread warehouse_destroy_glass();
}

//warehouse_destroy_glass()
//{
//	wait( 0.75 );
////	SetTimeScale( 0.2 );
////	SetSlowmotion( 1, 0.2, 0.2 );
//	angles = ( 0, 0, 0 );
//	forward = AnglesToForward( angles );
//
//	prefix = "warehouse_glass_explode";
//	times = 9;
//
//	for ( i = 0; i < times; i++ )
//	{
//		glass_array = GetGlassArray( prefix + ( i + 1 ) );
//		foreach ( glass in glass_array )
//		{
//			DestroyGlass( glass, forward );
//		}
//
//		wait( RandomFloatRange( 0.05, 0.1 ) );
//	}
//
////	wait( 0.1 );
////	SetSlowmotion( 0.2, 1, 0.5 );
//}

//---------------------------------------------------------
// Docks Section
//---------------------------------------------------------
get_docks_truck_door_trigger()
{
	trigger = GetEnt( "docks_truck_door", "targetname" );
	trigger trigger_on();
	trigger UseTriggerRequireLookAt();
	trigger SetHintString( &"LONDON_HINT_TRUCK_DOORS" );
	trigger MakeUsable();

	return trigger;
}

//---------------------------------------------------------
// Enemy AI getaway
//---------------------------------------------------------

trigger_docks_enemies_getaway()
{
	self waittill( "trigger" );

	if ( IsDefined( self.script_flag_set ) )
	{
		flag_set( self.script_flag_set );
	}

	self thread docks_enemies_fallback( self.target );
}

docks_enemies_fallback( targetname )
{
	level notify( "stop_docks_enemies_getaway" );
	level endon( "stop_docks_enemies_getaway" );

	goals = GetEntArray( targetname, "targetname" );

	flag_wait( "docks_enemy_fallback" );

	while ( 1 )
	{
		goals = array_randomize( goals );
		goal = goals[ 0 ];

		guy = get_furthest_dock_guy( goal );

		if ( !IsDefined( guy ) )
		{
			wait( 0.2 );
			continue;
		}

		guy.docks_getaway = targetname;
		guy SetGoalVolumeAuto( goal ); 

		delayed = self script_delay();

		if ( !delayed )
		{
			wait( RandomFloatRange( 1, 2 ) );
		}
	}	
}

get_furthest_dock_guy( goal )
{
	if ( !IsDefined( level.docks_enemy_ai ) )
	{
		level.docks_enemy_ai = [];
	}

	level.docks_enemy_ai = array_removedead_or_dying( level.docks_enemy_ai );

	if ( level.docks_enemy_ai.size == 0 )
	{
		return undefined;
	}

	guys = SortByDistance( level.docks_enemy_ai, goal.origin );
	for( i = 0; i < guys.size; i++ )
	{
		if ( IsDefined( guys[ i ].docks_getaway ) && guys[ i ].docks_getaway == goal.targetname )
		{
			continue;
		}

		return guys[ i ];
	}

	return undefined;
}

//---------------------------
// Spawner Functions 
//---------------------------
postspawn_docks_ai()
{
	if ( !IsDefined( level.docks_enemy_ai ) )
	{
		level.docks_enemy_ai = [];
	}

	level.docks_enemy_ai[ level.docks_enemy_ai.size ] = self;
}

postspawn_docks_worker()
{
	if ( IsDefined( self.script_noteworthy ) )
	{
		if ( self.script_noteworthy == "docks_walker" )
		{
			self gun_remove();
			self.patrol_walk_anim = "walk_casual";
		}
	}

	if ( !IsDefined( level.docks_worker_ai ) )
	{
		level.docks_worker_ai = [];
	}

	level.docks_worker_ai[ level.docks_worker_ai.size ] = self;

	self uav_add_target();
}

postspawn_intro_sas()
{
	// Give the spawners at warehouse2 the proper names
	spawners = GetEntArray( "sas_breacher", "script_noteworthy" );
	foreach ( spawner in spawners )
	{
		if ( IsDefined( spawner.script_friendname ) )
		{
			continue;
		}

		spawner.script_friendname = self.name;
		break;
	}

	flag_wait( "uav_focusing_on_player" );

	self scripted_movement( ::empty, true );

	flag_wait( "alley_start" );

	wait( 3 );
	node = GetNode( "intro_sas_node", "targetname" );

	self script_delay();
	self.fixednode = false;

	self.goalradius = 32;
	self SetGoalNode( node );
	self waittill( "goal" );
	self Delete();
}

postspawn_intro_truck_door_guy()
{
	self.targetname = "intro_truck_door_guy_ai";
}

postspawn_alley_enemy_cellphone()
{
	door = GetEnt( "alley_enemy_cellphone_door", "targetname" );
	door delaycall( 1, ::RotateTo, ( 0, 29, 0 ), 5, 0, 2 );
	door delaycall( 1, ::PlaySound, "scn_london_door_slow_open" );
	level.sas_leader delaythread( 1.2, ::dialogue_queue, "london_ldr_weaponsfree" );

	self.targetname = "alley_enemy_cellphone_ai";
	self.dontattackme = true;
	self Attach( "electronics_camera_cellphone_low", "tag_inhand", true );
	self.pre_reaction_delay = 4;
	self thread conditional_anim( ::alley_enemy_cellphone_reaction );
	self thread alley_enemy_cellphone_dialogue();

//	self waittill( "death" );
	self waittill_either( "play_death_anim", "death" );

	self Detach( "electronics_camera_cellphone_low", "tag_inhand" );

	flag_set( "alley_enemy_cellphone_dead" );
}

alley_enemy_cellphone_dialogue()
{
	self endon( "death" );
	self endon( "conditional_anim_react" );

	self dialogue_queue( "cellphone_line1" );
	wait( 2.5 );
	self dialogue_queue( "cellphone_line3" );
//	wait( 1 );
//	self dialogue_queue( "cellphone_line2" );
}

alley_enemy_cellphone_reaction( type )
{
	wait( 0.2 );
	self.allowdeath = true;
	self.kill_now = true;
}

postspawn_alley_enemy_sleeping()
{
	self.targetname = "alley_enemy_sleeping_ai";
	self.dontattackme = true;
	self.noragdoll = true;
//	self gun_remove();
	self.gun_removed = true;
	self.dontmelee = true;

	self thread alley_enemy_sleeping_thread();

	node = self;
	if ( IsDefined( self.target ) )
	{
		node = get_target_ent( self.target );
	}

//	self thread simple_reaction( node );

	self waittill( "death" );
	flag_set( "alley_enemy_sleeping_dead" );
}

alley_enemy_sleeping_thread()
{
	self endon( "death" );

	flag_wait( "alley_enable_sleeper_reaction" );
	self thread conditional_anim( ::alley_enemy_sleeping_reaction );

	if ( self.script_animation == "enemy_sleeping" )
	{
		// Taken from 0.55 of reaction anim, tag_inhand
		origin = ( 80413.5, -3362.51, 482.766 ); 
		angles = ( 288.551, 162.212, -61.5698 );

		gun = Spawn( "weapon_" + self.weapon, origin, true );
		gun.angles = angles;

		self.gun_on_ground = gun;

		self gun_remove();
		self.DropWeapon = false;
	}
}

alley_enemy_sleeping_dialogue()
{
	flag_wait( "alley_enable_sleeper_reaction" );
	level.sas_squad[ 1 ] dialogue_queue( "london_trk_dozin" );
	level.sas_squad[ 0 ] dialogue_queue( "london_ldr_keepemsilent" );
}

alley_enemy_sleeping_reaction( type )
{
	self thread alley_enemy_sleeping_giveweapon();
	wait( 0.2 );
	self.kill_now = true;
}

alley_enemy_sleeping_giveweapon()
{
	if ( self.script_animation != "enemy_sleeping" )
	{
		return;
	}

	self endon( "death" );

	while ( self GetAnimTime( self getanim_generic( "enemy_sleeping_react" ) ) < 0.55 )
	{
		wait( 0.05 );
	}

	model = self.gun_on_ground.model;
	self.gun_on_ground Delete();
	self Attach( model, "tag_weapon_left", true );

	while ( self GetAnimTime( self getanim_generic( "enemy_sleeping_react" ) ) < 0.75 )
	{
		wait( 0.05 );
	}

	self Detach( model, "tag_weapon_left" );
	self gun_recall();
}

postspawn_alley_enemy_warehouse()
{
	self.patrol_end_idle[ 0 ] = "patrol_idle_smoke";
	self.patrol_end_idle[ 1 ] = "patrol_idle_stretch";
	self.patrol_end_idle[ 2 ] = "patrol_idle_checkphone";
	self.patrol_end_idle[ 3 ] = "patrol_idle_phone";

	self disable_long_death();
	self enable_cqbwalk();

///#
//	if ( GetDvarInt( "test_alley_bug" ) == 1 )
//	{
//		self magic_bullet_shield();
//	}
//#/

	self.alertlevelint = 1;
	self.fovcosine = 0.99;
	self.ignoreall = true;
	self.grenadeAmmo = 0;
	self.ignoresuppression = true;
	self.targetname = "alley_enemy_warehouse_ai";

	self thread simple_reaction();

	self waittill( "death" );
	flag_count_decrement( "alley_enemy_warehouse_dead" );
}

postspawn_sas_orange()
{
	// Don't have driver replace on death... Too many allies otherwise
	if ( IsDefined( self.script_startingposition ) && self.script_startingposition == 0 )
	{
		return;
	}

	self thread replace_on_death();
}

//warehouse_breach_reaction()
//{
//	self gun_remove();
//	self thread spawn_and_animate();
//	self disable_surprise();
//}

postspawn_warehouse_hallway_enemy()
{
	self.do_ragdoll = true;
	self.reaction_delay = 0.5;
	self.targetname = "warehouse_hallway_ai";
	self conditional_anim_add_alert_friends( "hallway" );
	self thread conditional_anim( ::warehouse_hallway_enemy_reaction );
}

warehouse_hallway_enemy_reaction( type )
{
	time = 2;
	switch( self.script_animation )
	{
		case "warehouse_computer":
			time = 0.6;
			break;
		case "warehouse_tv_watcher1":
			time = 1.8;
			break;
		case "warehouse_tv_watcher2":
			time = 2;
			break;
	}

	self endon( "gun_recalled" );
	self endon( "death" );
	self thread warehouse_hallway_enemy_reaction_thread( time );

	wait( 0.2 );
	self.ragdoll_immediate = true;
	self.ragdoll_directionscale = 1000;
	self.allowdeath = true;
	self.deathanim = getanim_generic( "standing_death" );
}

warehouse_hallway_enemy_reaction_thread( time )
{
	self endon( "death" );

//	curr_time = GetTime();
//	while ( 1 )
//	{
//		wait( 0.05 );
//		println( self.script_animation + " - " + ( GetTime() - curr_time ) );
//	}
	wait( time );

	self.ragdoll_immediate = undefined;
	self notify( "gun_recalled" );
	self anim_stopanimscripted();
	self gun_recall();
}

postspawn_warehouse_sniper_target()
{
	level thread warehouse_sniper_think( self );
}

warehouse_sniper_think( guy )
{
	flag_wait( "warehouse_snipe_enemies" );

	if ( !IsDefined( level.fake_sniper ) )
	{
		struct = getstruct( "sniper_struct", "targetname" );
		level.fake_sniper = Spawn( "script_model", struct.origin );
		level.fake_sniper SetModel( "tag_laser" );
		level.fake_sniper LaserForceOn();
		add_cleanup_ent( level.fake_sniper, "docks_stuff" );
	}

	animname = "target1";
	glass_id = GetGlass( "warehouse_glass_target1" );
	bullets = 1;
	time = 1.0;
	delay = 0.2;

	if ( !flag_exist( "sniped_target1" ) )
	{
		flag_init( "sniped_target1" );
	}

	if ( guy.script_noteworthy == "warehouse_sniper_target2" )
	{
		animname = "target2";
		glass_id = GetGlass( "warehouse_glass_target2" );
		bullets = 2;
		// delay * 2 cause the first bullet at target2 will delay twice since wait( delay ) is just before magicbullet
		// 1.6667 is the notetrack time of impact for target2
		time = 1.6667 - ( delay * 2 );
	}

	guy.animname = animname;
	guy.allowdeath = true;
	guy thread anim_loop_solo( guy, "idle" );

	if ( animname == "target2" )
	{
		flag_wait( "sniped_target1" );

		guy anim_stopanimscripted();
		waittillframeend;

		if ( isdefined_and_alive( guy ) )
		{
			guy thread anim_single_solo( guy, "death" );
		}
	}

	sniper_aim_think( guy, time );

	already_killed = false;
	glass_destroyed = false;
	angles = ( 0, 90, 0 );
	for ( i = 0; i < bullets; i++ )
	{
		if ( isdefined_and_alive( guy ) )
		{
			target_org = guy GetTagOrigin( "j_head" );
			angles = VectorToAngles( target_org - level.fake_sniper.origin );
			level.fake_sniper RotateTo( angles, delay );
		}

		wait( delay );

		if ( isdefined_and_alive( guy ) )
		{
			target_org = guy GetTagOrigin( "j_head" );
			angles = VectorToAngles( target_org - level.fake_sniper.origin );
			level.fake_sniper RotateTo( angles, delay );
		}

		flag_set( "sniped_target1" );

		if ( animname == "target1" && i == 0 )
		{
			guy anim_stopanimscripted();
			waittillframeend;

			if ( isdefined_and_alive( guy ) && !already_killed )
			{
				level thread play_sound_in_space( "scn_london_sniped_bodyfall1", guy.origin + ( 0, 0, 32 ) );
				guy thread anim_single_solo( guy, "death" );
			}
		}

		if ( isdefined_and_alive( guy ) )
		{
	//		MagicBullet( "nosound_magicbullet", level.fake_sniper.origin, guy GetTagOrigin( "j_head" ) );
			origin = guy GetTagOrigin( "j_head" );
			delaythread( 0.2, ::play_sound_in_space, "scn_london_sniped_bulletimpact", origin );
			PlayFx( getfx( "impact_fx" ), origin );
	
			if ( !already_killed )
			{
				// REMOVE THIS WHEN WE HAVE PROPER NOTETRACK
				level delaythread( 2, ::play_sound_in_space, "scn_london_sniped_bodyfall2", guy.origin + ( 0, 0, 32 ) );
				level delaythread( 1.8, maps\london_docks_anim::anim_drop_weapon, guy );
				level delaythread( 2, maps\london_docks_anim::anim_kill_ai, guy );
			}

			already_killed = true;
		}

		if ( !glass_destroyed && isdefined_and_alive( guy ) )
		{
			glass_destroyed = true;
			DestroyGlass( glass_id, AnglesToForward( angles ) );
		}


		if ( i < bullets - 1 )
		{
			wait( delay );
		}
	}

	if ( animname == "target2" )
	{
		radio_dialogue( "london_ldr_grinchup" );
//		wait( 1.5 );
		level.fake_sniper LaserForceOff();
		level.fake_sniper Delete();

		flag_set( "warehouse_sniper_done" );
	}
}

sniper_aim_think( guy, time )
{
	time = time * 0.5;
	for( i = 0; i < 2; i++ )
	{
		if ( isdefined_and_alive( guy ) )
		{
			target_org = guy GetTagOrigin( "j_head" );

			if ( i == 0 )
			{
				target_org += ( 0, 0, -30 );
			}

			angles = VectorToAngles( target_org - level.fake_sniper.origin );
			level.fake_sniper RotateTo( angles, time, time * 0.5, time * 0.5 );
		}
		wait( time );
	}
}

postspawn_warehouse2_breachers()
{
	if ( !flag( "alley_sas_breacher_dialog" ) )
	{
		flag_set( "alley_sas_breacher_dialog" );
		level thread warehouse2_breach_intro_dialog();	
	}

	self magic_bullet_shield();
	self.targetname = "sas_breacher_ai";

	self scripted_movement( ::warehouse2_breacher_func, true );
	self stop_magic_bullet_shield();
	self Delete();
}

postspawn_warehouse2_enemy()
{
	self.patrol_end_idle[ 0 ] = "patrol_idle_smoke";
	self.patrol_end_idle[ 1 ] = "patrol_idle_stretch";
	self.patrol_end_idle[ 2 ] = "patrol_idle_checkphone";
	self.patrol_end_idle[ 3 ] = "patrol_idle_phone";

	self disable_long_death();

	self thread simple_reaction();

	self.grenadeAmmo = 0;
	self.fovcosine = 0.01;
	self.targetname = "sas_breacher_enemy_ai";
}

postspawn_warehouse_melee_enemy()
{
	level.warehouse_melee_enemy = self;

	self endon( "death" );
	self set_generic_run_anim( "patrol_walk" );
	self set_generic_idle_anim( "patrol_idle_1" );
	self.targetname = "warehouse_melee_enemy_ai";

	self disable_arrivals();
	self disable_exits();
	self disable_long_death();

	self.dontmelee = true;
	self.goalradius = 64;
	struct = getstruct( "melee_patrol_spot", "targetname" );
	self SetGoalPos( struct.origin );

	self simple_reaction( undefined, true );

	self clear_generic_run_anim();
	self clear_generic_idle_anim();
	self enable_arrivals();
	self enable_exits();
}

postspawn_sewer_pipe_ai()
{
	self endon( "death" );

	flag_wait( "sewer_pipes_done" );

	self postspawn_docks_ai();
}

//---------------------------
// Warehouse 2 Breachers 
//---------------------------
warehouse2_breach_intro_dialog()
{
	level.sas_leader anim_single_solo( level.sas_leader, "london_ldr_bravo9ontime" );
	radio_dialogue( "london_sasl_copy" );
}

warehouse2_breach_dialog()
{
}

warehouse2_breacher_func( note, goal )
{
	if ( !IsDefined( note ) )
	{
		return;
	}

	switch ( note )
	{
		// case statements are in order of guys going through the door
		case "warehouse2_breach_cutter":
			self warehouse2_breach( goal, "warehouse2_cutter_enter" );
			break;
		case "warehouse2_breach_breacher2":
			self warehouse2_breach( goal, "warehouse2_breacher2_enter" );
			break;
		case "warehouse2_breach_breacher":
			self warehouse2_breach( goal, "warehouse2_breacher_trans", 1 );
			break;
		case "warehouse2_wait":
			self warehouse2_wait( goal );
			break;
	}
}

warehouse2_breach( goal, note, delay )
{
	goal anim_generic_reach( self, note );

	if ( note == "warehouse2_breacher_trans" )
	{
		goal anim_generic( self, note );
		goal thread anim_generic_loop( self, "warehouse2_breacher_idle" );
		note = "warehouse2_breacher_enter";
	}

	flag_count_decrement( "warehouse2_breach_go" );
	flag_wait( "warehouse2_breach_go" );
	flag_wait_or_timeout( "alley_go_to_breach", 10 );

	if ( note == "warehouse2_cutter_enter" )
	{
		flag_set( "warehouse2_breach_go_dialog" );
	}

	flag_wait( "warehouse2_breach_go_dialog" );

	if ( note == "warehouse2_breacher_enter" )
	{
		wait( 0.2 );
		flag_set( "warehouse2_breach_enter" );
	}

	flag_wait( "warehouse2_breach_enter" );

	if ( IsDefined( delay ) )
	{
		wait( delay );
	}

	if ( note == "warehouse2_breacher_enter" )
	{
		goal notify( "stop_loop" );
	}

	self.fixednode = false;
	self.ignoreForFixedNodeSafeCheck = true;
	self thread warehouse2_enemy_thread();
	self disable_surprise();
	self.dontmelee = true;
	self.baseaccuracy = 5;

	self thread warehouse2_breacher_stop_anim( note );
	self thread warehouse2_breach_after_anim( note );
	goal thread anim_generic( self, note );
}

warehouse2_wait( goal )
{
	self scripted_goto_goal( goal, true );

	enemy_array = GetEntArray( "sas_breacher_enemy_ai", "targetname" );
	enemy_array = array_removedead_or_dying( enemy_array );

	if ( !enemy_array.size )
	{
		return;
	}

	while ( enemy_array.size )
	{
		wait( 0.05 );
		enemy_array = array_removedead_or_dying( enemy_array );
	}

	goal script_delay();
}

warehouse2_enemy_thread()
{
	self endon( "death" );

	enemy_array = GetEntArray( "sas_breacher_enemy_ai", "targetname" );
	enemy_array = array_removedead_or_dying( enemy_array );

	if ( !enemy_array.size )
	{
		if ( !flag( "warehouse2_done" ) )
		{
			flag_set( "warehouse2_done" );
		}
		return;
	}

	if ( enemy_array.size > 1 )
	{
		enemy_array = SortByDistance( enemy_array, self.origin );
	}

	enemy = enemy_array[ 0 ];
	enemy.health = 5;
	self.favoriteenemy = enemy;

	enemy waittill_either( "damage", "death" );

	enemy_array = GetEntArray( "sas_breacher_enemy_ai", "targetname" );
	enemy_array = array_removedead_or_dying( enemy_array );

	if ( !enemy_array.size )
	{
		if ( !flag( "warehouse2_done" ) )
		{
			flag_set( "warehouse2_done" );
		}

		return;
	}

	enemy = enemy_array[ 0 ];
	enemy.health = 5;
	self.favoriteenemy = enemy;	

	if ( !flag( "warehouse2_done" ) )
	{
		flag_set( "warehouse2_done" );
	}
}

warehouse2_breach_after_anim( note )
{
	self waittillmatch( "single anim", "end" );

	self enable_arrivals();
	self.ignoreall = false;
	self.nododgemove = true;

	enemy_array = GetEntArray( "sas_breacher_enemy_ai", "targetname" );
	array_thread( enemy_array, ::set_ignoreall, false );
	array_thread( enemy_array, ::anim_stopanimscripted );
}

warehouse2_breacher_stop_anim( anime )
{
	time = undefined;
	switch ( anime )
	{
		case "warehouse2_breacher_enter":
			time = 0.72; //0.65
			break;
		case "warehouse2_breacher2_enter":
			time = 0.61;
			break;
		default:
			return;
	}

	while ( self GetAnimTime( self getanim_generic( anime ) ) < time )
	{
		wait( 0.05 );
	}

	self anim_stopanimscripted();
}

//---------------------------
// AI Section
//---------------------------
//docks_stack_up( guys, side )
//{
//	guys = array_index_by_script_index( guys );
//	for ( i = 1; i < 4; i++ )
//	{
//		guys[ i ] thread docks_stack_up_think( side );
//		wait( 1 );
//	}
//
//	flag_wait( "docks_assault" );
//
//	foreach ( guy in guys )
//	{
//		if ( IsDefined( guy ) )
//		{
//			guy.goalradius = 512;
//			guy notify( "stop_stack_up" );
//
//			org = getstruct( "docks_stack_point_" + side, "targetname" );
//			if ( IsDefined( org ) )
//			{
//				org notify( "stop_stack_up" );
//			}
//
//			// Use ClearAnim since the stack anim idles are loops
//			if ( guy.script_index < 3 )
//			{
//				guy ClearAnim( level.scr_anim[ "generic" ][ "stack_" + side + guy.script_index + "_idle" ][ 0 ], 0.2 );
//			}
//			
//			guy.ignoreall = false;
//			guy anim_stopanimscripted();
//			guy disable_cqbwalk();
//		}
//	}
//}
//
//docks_stack_up_think( side )
//{
//	org = undefined;
//	if ( self.script_index < 3 )
//	{
//		self.animname = "generic";
//		anime = "stack_" + side + self.script_index + "_idle";
//		org = getstruct( "docks_stack_point_" + side, "targetname" );
//		org thread anim_reach_and_idle_solo( self, anime, anime, "stop_stack_up" );
//	}
//	else
//	{
//		node_name = "docks_stack_point_" + side + "_node";
//		node = GetNode( node_name, "targetname" );
//		self.goalradius = 4;
//		self SetGoalNode( node );
//	}
//}

//--------------------------
// Vehicles Section 
//--------------------------
disable_sounds_on_useless_cars()
{
    cars = Vehicle_GetArray();
    foreach( car in cars )
	{
        if ( !IsDefined( car.targetname ) && !IsDefined( car.script_noteworthy ) )
		{
            car Vehicle_TurnEngineOff();
		}
	}

    foreach( car in cars)
	{
        if( !IsDefined( car.targetname ) )
		{
            car Vehicle_TurnEngineOff();
		}
	}
}

postspawn_sas_van()
{
    add_cleanup_ent( self, "docks_stuff" );
	self SetCanDamage( false );

	self thread sas_van_sounds();

	self waittill( "reached_end_node" );

	if ( IsDefined( self.script_parameters ) )
	{
		if ( self.script_parameters == "sas_orange" )
		{
			level.docks_van_target = self;
		
			self thread sas_van_rpg();

			array_thread( level.docks_enemy_ai, ::docks_enemies_engage );
		}
	}
}

sas_van_sounds()
{
	flag_wait( "docks_assault" );
	if ( IsDefined( self.script_parameters ) )
	{
		self waittill( "unloading" );
	}
}

sas_van_teleport()
{
	van = undefined;
	foreach( vehicle in level.docks_vans )
	{
		if ( !IsDefined( vehicle.script_parameters ) )
		{
			continue;
		}

		van = vehicle;
	}

	node = GetVehicleNode( "docks_van_teleport", "script_noteworthy" );
	van Vehicle_Teleport( node.origin, node.angles );
	van.attachedpath = node;
	van AttachPath( node );
	van thread vehicle_paths( node );
}

enemy_notify_end_patrol()
{
	array_thread( level.docks_enemy_ai, ::notify_end_patrol );
}

notify_end_patrol()
{
	self notify( "end_patrol" );
}


//--------------------------
// Helicopter Section 
//--------------------------
postspawn_littlebird()
{
	self ent_flag_init( "spotlight_on" );
	self ent_flag_init( "follow_path" );
	self ent_flag_init( "docks_rocket_lockon" );

	// This flag is to support the sprinting players
	self ent_flag_init( "earlyout" );

	self.spotlight = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_flash" ), "heli_spotlight" );
	self.spotlight SetMode( "manual" );
	self.spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	self.spotlight LinkTo( self, "tag_flash" );

	self mgOff();

	self.pause_spot_light_monitor = false;
	self thread littlebird_spotlight_monitor();
	self thread littlebird_spotlight_think();
	level.docks_littlebird = self;
	
	if ( IsDefined( self.skip_spawn_path_and_hover ) )
	{
		self ent_flag_set( "follow_path" );
	}
	else
	{
		self waittill( "reached_dynamic_path_end" );		
	}

	hover_point = getstruct( "docks_chopper_hoverpoint_1", "targetname" );
	self SetMaxPitchRoll( 25, 45 );	
	self Vehicle_SetSpeed( 30, 20, 10 );
	self SetYawSpeed( 90, 45 );
	self thread chopper_circle( hover_point );
	self.repulsor = Missile_CreateRepulsorEnt( self, 5000, 1000 );

	if ( IsDefined( self.skip_spawn_path_and_hover ) )
	{
		wait( 0.05 );
		self notify( "reached_dynamic_path_end" );
		self ent_flag_set( "spotlight_on" );
	}

	self thread littlebird_shoot_catwalk();
	self thread postspawn_littlebird_death();
	self thread maps\london_docks::docks_littlebird_rocket();

	// Override turret burst settings since	the turrets are spawned in during chopper spawn
	wait( 0.05 );
	foreach ( mg in self.mgturret )
	{
		mg.script_delay_min = 0.05;
		mg.script_delay_max = 0.1;
		mg.script_burst_min = 20;
		mg.script_burst_max = 30;
		mg.shell_fx = getfx( "minigun_shells" );
		mg.shell_sound = "scn_london_gattling_shells";
		mg notify( "stop_burst_fire_unmanned" );
		mg thread maps\_mgturret::burst_fire_unmanned();
	}
	
}

postspawn_littlebird2()
{
	self ent_flag_init( "spotlight_on" );
	self ent_flag_clear( "spotlight_on" );
	self ent_flag_init( "follow_path" );

	// This flag is to support the sprinting players
	self ent_flag_init( "earlyout" );

	self.spotlight = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_flash" ), "heli_spotlight" );
	self.spotlight SetMode( "manual" );
	self.spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	self.spotlight LinkTo( self, "tag_flash" );

	self mgOff();

	self thread littlebird_spotlight_monitor();
	self thread littlebird_spotlight_think();

	self SetHoverParams( 0, 0, 0 );

	hover_point = getstruct( "docks_chopper_hoverpoint_1", "targetname" );
	self SetMaxPitchRoll( 25, 45 );	
	self Vehicle_SetSpeed( 30, 20, 10 );
	self thread chopper_circle( hover_point );
	self.repulsor = Missile_CreateRepulsorEnt( self, 5000, 1000 );

	self thread postspawn_littlebird_death();

	// Override turret burst settings since	the turrets are spawned in during chopper spawn
	wait( 0.05 );
	foreach ( mg in self.mgturret )
	{
		mg.script_delay_min = 0.05;
		mg.script_delay_max = 0.1;
		mg.script_burst_min = 20;
		mg.script_burst_max = 30;
		mg.shell_fx = getfx( "minigun_shells" );
		mg.shell_sound = "scn_london_gattling_shells";
		mg notify( "stop_burst_fire_unmanned" );
		mg thread maps\_mgturret::burst_fire_unmanned();
	}

	level.docks_littlebird = self;
	self maps\london_docks::docks_littlebird_rocket();
}

set_littlebird_start( spawner_targetname, struct_targetname )
{
	spawner = GetEnt( spawner_targetname, "targetname" );

	// Make sure actor's are still targeted
	if ( IsDefined( spawner.target ) )
	{
		ents = GetEntArray( spawner.target, "targetname" );
		ai_spawners = [];
		foreach ( ent in ents )
		{
			if ( IsSubStr( ent.code_classname, "actor" ) )
			{
				ent.targetname = "unique_1616";
			}

		}
	}

	struct = getstruct( struct_targetname, "targetname" );

	spawner.origin = struct.origin;
	spawner.angles = struct.angles;
	spawner.target = "unique_1616";

	spawner.skip_spawn_path_and_hover = true;
}

postspawn_littlebird_death()
{
    spotlight = self.spotlight;
    self waittill ( "death" );

	if ( IsDefined( spotlight ) )
	{
    	spotlight delete();
	}
}

postspawn_littlebird_rpger()
{
	level thread littlebird_rpger_death( self );

	self disable_long_death();
	self waittill( "goal" );
	wait( 1 );

	self.a.rockets = 1;
	ent = Spawn( "script_origin", level.docks_littlebird.origin + ( 0, 0, -100 ) );
	self SetEntityTarget( ent );
	self.ignoreall = false;

	self waittill( "shooting" );
	level thread littlebird_rpg_dialogue();

	ent Delete();

	flag_set( "littlebird_rpg_shot" );
	self.goalradius = 1024;
	self ClearEntityTarget();
}

littlebird_rpger_death( rpger )
{
	rpger endon( "shooting" );
	rpger waittill( "death" );

	if ( !IsDefined( level.docks_littlebird ) )
	{
		return;
	}

	level.docks_littlebird ent_flag_set( "earlyout" );
}

littlebird_rpg_dialogue()
{
	thread radio_dialogue_overlap( "london_gfn_rpg" );
	wait( 0.5 );
	radio_dialogue_overlap( "london_hp2_pullup" );
}

littlebird_shoot_catwalk()
{
	flag_wait( "docks_after_ambush" );
	
	wait( 1 );
	level.sas_leader dialogue_queue( "london_ldr_tangosoncatwalk" );
	thread radio_dialogue( "london_hp2_engaging" );

	flag_set( "docks_shoot_catwalk" );

	lookat = GetEnt( "littlebird_catwalk_lookat", "targetname" );
//	self SetLookAtEnt( lookat );
//	self ClearLookAtEnt();

	forward = AnglesToForward( ( 0, 90, 0 ) );
	origin = self.origin + ( forward * 300 );
	ent = Spawn( "script_origin", lookat.origin );

	littlebird_set_override_target( ent );
//	self thread littlebird_line_to_target();

	foreach ( mg in self.mgturret )
	{
		mg SetTargetEntity( ent );
	}

	self SetMaxPitchRoll( 20, 20 );
	self SetLookAtEnt( ent );

	self ent_flag_clear( "earlyout" );
	self thread littlebird_target_move( ent );

	flag_wait( "littlebird_at_catwalk" );
	self thread littlebird_rpg_shoot();

	littlebird_catwalk_wait();
	self notify( "stop_target_move" );

	self mgoff();
	ent Delete();

	if ( self ent_flag( "earlyout" ) )
	{
		self chopper_follow_path( "littlebird_ambush_earlyout" );
	}
	else
	{
		self waittill( "follow_path_done" );
	}


	if ( !flag( "docks_littlebird_strafe" ) )
	{
		self thread chopper_follow_line_path( "littlebird_warehouse_line_path", "littlebird_warehouse_line_player_path" );
	}
}

littlebird_catwalk_wait()
{
	while ( !flag( "littlebird_rpg_shot" ) && !self ent_flag( "earlyout" ) )
	{
		wait( 0.05 );
	}
}

littlebird_target_move( ent, volume )
{
	self endon( "stop_target_move" );

	volume = GetEnt( "docks_catwalk_area", "targetname" );

	while ( 1 )
	{
		targets = littlebird_get_enemy_targets( volume, self );

		if ( targets.size > 0 )
		{
			target = targets[ 0 ];
			while ( IsDefined( target ) && IsALive( target ) )
			{
				spotlight_origin = self.spotlight GetTagOrigin( "tag_flash" );
				angles = VectorToAngles( target.origin - spotlight_origin );
				if ( angles[ 0 ] > 15 )
				{
					break;
				}
	
				if ( abs( angles[ 1 ] ) - 90 > 45 )
				{
					break;
				}

				origin = target.origin + ( 0, 0, 30 );
				dist = Distance( ent.origin, origin );
				time = dist / 500;
				time = max( time, 0.1 );
	
				ent MoveTo( origin, time );
				ent waittill( "movedone" );
			}
		}

		wait( 0.05 );
	}
}

littlebird_spotlight_monitor()
{
	self endon( "death" );

	while ( 1 )
	{
		wait( 0.05 );
		target = self.spotlight GetTurretTarget( 0 );

		if ( !is_ai_dead_or_undefined( target ) && !self.pause_spot_light_monitor )
		{
			continue;
		}

		if ( !IsDefined( self.spotlight_defaulttarget ) )
		{
			forward = AnglesToForward( self.angles + ( 20, 0, 0 ) );
			origin = self GetTagOrigin( "tag_flash" ) + ( forward * 100 );
			self.spotlight_defaulttarget = Spawn( "script_origin", origin );
			self.spotlight_defaulttarget LinkTo( self );
		}

		self.spotlight SetTargetEntity( self.spotlight_defaulttarget );
	}
}

littlebird_rpg_shoot()
{
//	trigger = GetEnt( "docks_catwalk_area", "targetname" );
//	trigger waittill_volume_dead_or_dying();
//	wait( 8 );
	wait( 3 );
	spawn_targetname( "docks_littlebird_rpger" );

//	flag_set( "littlebird_rpg_shot" );
}

littlebird_line_to_target()
{
/#
	while ( 1 )
	{
		spotlight_origin = self.spotlight GetTagOrigin( "tag_flash" );
		if ( IsDefined( self.override_target ) )
		{
			Line( spotlight_origin, self.override_target.origin );
		}

		wait( 0.05 );
	}
#/	
}

littlebird_spotlight_on()
{
    self.spotlight thread spot_light( "docks_heli_spotlight", "docks_heli_spotlight_cheap", "tag_flash", self );
}

littlebird_spotlight_think()
{
    self endon ( "death" );

	self notify( "stop_littlebird_spotlight" );
	self endon( "stop_littlebird_spotlight" );

	if ( !IsDefined( self.is_spotlight_on ) )
	{
		self.is_spotlight_on = false;
	}

	while( 1 )
	{
		if ( !self ent_flag( "spotlight_on" ) )
		{
			if ( self.is_spotlight_on )
			{
				self.is_spotlight_on = true;
				self littlebird_spotlight_off();
			}

			wait( 0.2 );
			continue;
		}


		self.is_spotlight_on = true;
		self littlebird_spotlight_on();

		while ( self ent_flag( "spotlight_on" ) )
		{
			target = undefined;
			if ( IsDefined( self.override_target ) )
			{
				self.spotlight SetTargetEntity( self.override_target );

				// Don't do anything else until the override target is removed
				while ( IsDefined( self.override_target ) )
				{
					wait( 0.5 );
				}

				continue;
			}
			else
			{
				targets = littlebird_get_enemy_targets();
			
				if ( targets.size > 0 )
				{
					target = targets[ 0 ];
					self.spotlight SetTargetEntity( target );
				}
				else
				{
	//				self.spotlight ClearTargetEntity();
				}
			}

			if ( IsDefined( target ) && IsAi( target ) )
			{
				delay = RandomFloatRange( 2, 5 ) * 1000;

				timer = GetTime() + delay;
				while ( GetTime() < timer )
				{
					if ( !IsDefined( target ) || !IsAlive( target ) )
					{
						break;	
					}

					wait( 0.1 );
				}
			}
			else
			{
				wait( RandomFloatRange( 2, 5 ) );
			}
		}
	}
}

littlebird_set_override_target( ent )
{
	level.docks_littlebird.override_target = ent;
	level.docks_littlebird thread littlebird_spotlight_think();
}

littlebird_clear_override_target()
{
	level.docks_littlebird.override_target = undefined;
}

littlebird_get_enemy_targets( volume, sort_by_ent )
{
	targets = array_randomize( GetAiArray( "axis" ) );
	targets = array_removedead_or_dying( targets );

	spotlight_origin = self.spotlight GetTagOrigin( "tag_flash" );

	good_targets = [];
	foreach ( target in targets )
	{
		if ( target.origin[ 0 ] > 78000 )
		{
			continue;
		}

		trace = SightTracePassed( spotlight_origin, target.origin + ( 0, 0, 60 ), false, self );
		if ( !IsDefined( trace ) || !trace )
		{
			continue;
		}

		if ( self.script_turretmg )
		{
			angles = VectorToAngles( target.origin - spotlight_origin );
			if ( angles[ 0 ] > 15 )
			{
				continue;
			}

			if ( abs( angles[ 1 ] ) - 90 > 45 )
			{
				continue;
			}
		}

		if ( IsDefined( volume ) && !target IsTouching( volume ) )
		{
			continue;
		}

		good_targets[ good_targets.size ] = target;
	}

	if ( IsDefined( sort_by_ent ) )
	{
		good_targets = SortByDistance( good_targets, sort_by_ent.origin );
	}
	else
	{
		good_targets = SortByDistance( good_targets, level.player.origin );
	}

	return good_targets;
}

chopper_target_movement( dist )
{
	self endon( "death" );

	if ( !IsDefined( dist ) )
	{
		dist = 100;
	}

	og_origin = self.origin;

	while ( 1 )
	{
		x = RandomFloatRange( dist * -1, dist );
		y = RandomFloatRange( dist * -1, dist );
		z = RandomFloatRange( dist * -1, dist );

		time = RandomFloatRange( 0.5, 1.5 );
		origin = og_origin + ( x, y, z );
		self MoveTo( origin, time, time * 0.4, time * 0.4 );
		self waittill( "movedone" );
	}
}

chopper_follow_line_path( path_targetname, player_path_targetname )
{
	self ent_flag_set( "follow_path" );
	self endon( "stop_follow_line_path" );

	start 		= getstruct( path_targetname, "targetname" );
	end 		= getstruct( start.target, "targetname" );
	path_angle 	= VectorToAngles( end.origin - start.origin );
	path_yaw 	= path_angle[ 1 ];
	total_dist 	= Distance( start.origin, end.origin );
	diff_yaw 	= end.angles[ 1 ] - start.angles[ 1 ];
	diff_radius = end.radius - start.radius;
	diff_speed 	= 35 - 5;

	player_start 		= undefined;
	player_end 			= undefined;
	player_total_dist 	= undefined;
	if ( IsDefined( player_path_targetname ) )
	{
		player_start 		= getstruct( player_path_targetname, "targetname" );
		player_end 			= getstruct( player_start.target, "targetname" );
		player_total_dist 	= Distance( player_start.origin, player_end.origin );
	}

	while ( 1 )
	{
		closest_point = PointOnSegmentNearestToPoint( start.origin, end.origin, level.player.origin );

		if ( IsDefined( player_path_targetname ) )
		{
			player_closest_point = PointOnSegmentNearestToPoint( player_start.origin, player_end.origin, level.player.origin );
			dist = Distance( player_closest_point, player_start.origin );
			percent = dist / player_total_dist;
		}
		else
		{
			dist = Distance( closest_point, start.origin );
			percent = dist / total_dist;
		}

		yaw = start.angles[ 1 ] + ( diff_yaw * percent );
		self SetTargetYaw( yaw );
		self SetGoalYaw( yaw );

//		dist = 600 * ( percent - 0.5 );
//		closest_point = closest_point + ( AnglesToForward( ( 0, path_yaw, 0 ) ) * dist );

		angle = RandomInt( 360 );
		max_radius = start.radius + ( diff_radius * percent );
		radius = RandomFloatRange( 0, max_radius );

		if ( IsDefined( player_path_targetname ) )
		{
			dist = total_dist * percent;
			pos = start.origin + ( AnglesToForward( path_angle ) * dist );
		}
		else
		{
			pos = closest_point + ( AnglesToForward( path_angle ) * radius );
		}

//		dist = Distance( pos, self.origin );
//		percent = dist / ( max_radius * 2 );
//		self Vehicle_SetSpeed( 5 + ( diff_speed * percent ) );

		self SetVehGoalPos( pos, true );
		self waittill_either( "near_goal", "goal" );
	}
}

chopper_circle( hover_point )
{
	self endon( "death" );

	self.hover = SpawnStruct();
	self.hover.hover_point = hover_point;
	self.hover.circle_segments = 15;
	self.hover.direction = 1;

	self.hover.pathpoint = chopper_get_closest_pathpoint( 1 );
	self SetNearGoalNotifyDist( 200 );

	if ( !self ent_flag( "follow_path" ) )
	{
		self chopper_move_till_goal();
	}

	while ( 1 )
	{
		if ( self ent_flag( "follow_path" ) )
		{
			wait( 0.1 );
			continue;
		}

		self.hover.pathpoint = chopper_get_next_pathpoint( self.hover.pathpoint[ "index" ] );
		self chopper_move_till_goal();
	}
}

chopper_get_closest_pathpoint( add_index )
{
	points = chopper_get_pathpoints();

	dist = DistanceSquared( points[ 0 ], self.origin );
	closest = points[ 0 ];
	index = 0;
	
	foreach ( i, point in points )
	{
		test = DistanceSquared( point, self.origin );
		if ( test < dist )
		{
			closest = point;
			index = i;
			dist = test;
		}
	}

	point_and_index = [];
	if ( IsDefined( add_index ) )
	{
		index = index + add_index;

		if ( index > points.size + 1 )
		{
			index = index - points.size + 1;
		}

		point_and_index[ "point" ] = chopper_get_pathpoint( index );
		point_and_index[ "index" ] = index;		
	}
	else
	{
		point_and_index[ "point" ] = closest;
		point_and_index[ "index" ] = index;
	}

	return point_and_index;
}

trigger_chopper_hoverpoint()
{
	self waittill( "trigger" );

	ent = self get_target_ent();
	level.docks_littlebird.hover.hover_point = ent;
}

//---------------------------------------------------------
// Docks Sniper Section
//---------------------------------------------------------
docks_sniper()
{
	spawners = GetEntArray( "snipers", "targetname" );
	array_levelthread( spawners, ::sniper_drone );

//	level waittill( "sniper_in_position" );
//	flag_wait( "snipers_in_position" );

//	struct = getstruct( "sniper_struct2", "targetname" );
	SetSavedDvar( "laserrange", 4000 );
	SetSavedDvar( "laserradius", 0.4 );


}

docks_laser_think()
{
	self endon( "death" );
	self ent_flag_wait( "in_position" );

	laser = Spawn( "script_model", self GetTagOrigin( "tag_flash" ) );
	laser SetModel( "tag_laser" );

	laser thread sniper_ent_linkto( self );
	self.laser_ent = laser;

	laser.target_ent = Spawn( "script_origin", self GetTagOrigin( "tag_flash" ) );
	laser thread sniper_angles_thread();
	self thread sniper_aim_thread();

	while ( !flag( "docks_warehouse" ) )
	{
		if ( flag( "docks_check_truck" ) && !flag( "docks_ambush" ) )
		{
			wait( 0.5 );
			laser LaserForceOff();
			continue;
		}

		targets = laser sniper_get_enemy_targets();

		if ( targets.size == 0 )
		{
			laser LaserForceOff();
			wait( 1 );
			continue;
		}

		if ( flag( "docks_warehouse" ) )
		{
			break;
		}

		target = targets[ 0 ];

		target.sniper_tracking = true;
		self sniper_track_target( laser, target );

		if ( isdefined_and_alive( target ) )
		{
			target.sniper_tracking = undefined;
		}
	}

	// Clean up
	laser.target_ent Delete();
	laser Delete();
}

sniper_ent_linkto( ent )
{
	self endon( "death" );
	ent endon( "death" );

	while ( 1 )
	{
		wait( 0.05 );
		origin = ent GetTagOrigin( "tag_flash" );
		self.origin = origin;
	}
}

sniper_drone( spawner )
{
	flag_wait( "warehouse_sniper_done" );
	spawner script_delay();

	drone = spawner spawn_ai();
	drone.animname = "drone";

	drone ent_flag_init( "in_position" );

//	if ( IsDefined( spawner.script_noteworthy ) && spawner.script_noteworthy == "sniper" )
//	{
//		level.docks_sniper = drone;
//	}

	if ( !IsDefined( drone.target ) )
	{
		return;
	}
	
	goal = getstruct( drone.target, "targetname" );
	goal drone_scripted_anim( drone, goal.animation );

	drone thread docks_laser_think();

	while ( 1 )
	{
		if ( !IsDefined( goal.target ) )
		{
			break;
		}

		goal = getstruct( goal.target, "targetname" );

		if ( IsDefined( goal.script_looping ) )
		{
			if ( IsDefined( goal.animation ) )
			{
				if ( IsDefined( goal.script_faceangles ) )
				{
					angles = VectorToAngles( goal.origin - drone.origin );
					drone RotateTo( angles, 0.5 );
				}

				drone drone_set_anim( goal.animation );
			}
		}


		if ( DistanceSquared( goal.origin, drone.origin ) > 10 * 10 )
		{
			speed = 95;
			dist = Distance( drone.origin, goal.origin );
			time = dist / speed;
			drone MoveTo( goal.origin, time );

			// Special handling to turn just before reaching goal
			if ( IsDefined( goal.script_faceangles ) && goal.script_faceangles == 2 )
			{
				drone delaycall( time * 0.8, ::RotateTo, ( 0, goal.angles[ 1 ], 0 ), 0.5 );
			}

			wait( time );
		}

		if ( !IsDefined( goal.script_looping ) )
		{
			if ( IsDefined( goal.animation ) )
			{
				if ( IsDefined( goal.script_faceangles ) )
				{
//					drone delaycall( 0.5, ::RotateTo, goal.angles, 3 );
					drone RotateTo( goal.angles, 3 );
				}
	
				goal drone_scripted_anim( drone, goal.animation );
			}
		}

		if ( IsDefined( goal.script_ent_flag_set ) )
		{
			drone ent_flag_set( goal.script_ent_flag_set );
		}

		if ( IsDefined( goal.script_flag_set ) )
		{
			flag_set( goal.script_flag_set );
		}

		if ( IsDefined( goal.script_flag_wait ) )
		{
			flag_wait( goal.script_flag_wait );
		}

		goal script_delay();

		if ( IsDefined( goal.script_delete ) )
		{
			drone Delete();
			break;
		}
	}
}

drone_set_anim( anime )
{
	body = self getanim( "body" );
	self ClearAnim( body, 0.2 );
	self StopAnimScripted();

	animation = self getanim( anime );
	self SetFlaggedAnimRestart( "drone_anim", animation, 1, 0.2, 1 );
}

drone_scripted_anim( guy, anime, not_animscripted )
{
	array = get_anim_position();
	origin = array[ "origin" ];
	angles = array[ "angles" ];

	animation = guy getanim( anime );
	if ( IsDefined( not_animscripted ) )
	{
		guy setFlaggedAnimKnobRestart( "drone_anim", animation, 1, 0.2 );
	}
	else
	{
		guy AnimScripted( "drone_anim", origin, angles, animation );
	//	guy waittillmatch( "drone_anim", "end" ); 
	}

	while ( 1 )
	{
		guy waittill( "drone_anim", note );
		if ( note == "end" )
		{
			break;
		}
	}
}

sniper_track_target( laser, target )
{
	level endon( "docks_warehouse" ); // from flag being set

	laser.target_ent MoveTo( target.origin + ( 0, 0, 32 ), 1 );
	laser.target_ent waittill( "movedone" );

	if ( !laser sniper_is_target_valid( target ) )
	{
		return;
	}

	laser LaserForceOn();

	// Track head of target.
	num = RandomIntRange( 8, 16 ) * 2;
	time = 0.2;
	for ( i = 0; i < num; i++ )
	{
		if ( !isdefined_and_alive( target ) )
		{
			break;
		}

		target_origin = target GetTagOrigin( "j_head" );
		offset = ( RandomFloatRange( -5, 5 ), RandomFloatRange( -5, 5 ), RandomFloatRange( -5, 5 ) );

		laser.target_ent MoveTo( target_origin + offset, time );
		wait( time );
	}

	if ( !laser sniper_is_target_valid( target ) )
	{
		return;
	}

	// Try to line up the shot better
	laser.target_ent MoveTo( target GetTagOrigin( "j_head" ), 0.05 );

	start_pos = laser.origin;

	offset = 10;
	x = RandomFloatRange( offset * -1, offset );
	y = RandomFloatRange( offset * -1, offset );
	z = RandomFloatRange( offset * -1, offset );
	end_pos = target GetTagOrigin( "j_head" ) + ( x, y, z );

	self thread drone_scripted_anim( self, "fire", true );
	PlayFxOnTag( getfx( "silencer_flash" ), laser, "tag_laser" );
	MagicBullet( "mp5", start_pos, end_pos );

	wait( 0.5 );

	laser LaserForceOff();
	self drone_scripted_anim( self, "reload", true );
	wait( RandomFloatRange( 1, 2 ) ); // delay acquiring another target
	laser LaserForceOn();
}

sniper_angles_thread()
{
	self endon( "death" );
	level endon( "docks_warehouse" ); // from flag being set

	rate = 0.05;
	while ( 1 )
	{
		angles = VectorToAngles( self.target_ent.origin - self.origin );
//		self RotateTo( angles, rate );
		self.angles = angles;
		wait( rate );
	}
}

isdefined_and_alive( ent )
{
	if ( !IsDefined( ent ) )
	{
		return false;
	}

	if ( !IsAlive( ent ) )
	{
		return false;
	}

	if ( ent doinglongdeath() )
	{
		return false;
	}

	return true;
}

sniper_is_target_valid( target, skip_vis )
{
	if ( !isdefined_and_alive( target ) )
	{
		return false;
	}

	if ( IsDefined( skip_vis ) )
	{
		return true;
	}

	if ( !self sniper_has_vis_on_target( target ) )
	{
		return false;
	}

	return true;
}

sniper_has_vis_on_target( target )
{
	trace = BulletTracePassed( self.origin, target GetTagOrigin( "j_head" ), false, self );
	if ( !IsDefined( trace ) || !trace )
	{
		return false;
	}

	return true;
}

sniper_get_enemy_targets( volume, sort_by_ent )
{
	targets = array_randomize( GetAiArray( "axis" ) );
	targets = array_removedead_or_dying( targets );

	good_targets = [];
	foreach ( target in targets )
	{
		if ( target.origin[ 0 ] > 78000 )
		{
			continue;
		}

		if ( !self sniper_has_vis_on_target( target ) )
		{
			continue;
		}

		if ( IsDefined( volume ) && !target IsTouching( volume ) )
		{
			continue;
		}

		if ( IsDefined( target.sniper_tracking ) )
		{
			continue;
		}

//		if ( DistanceSquared( target.origin, level.player.origin ) > 1200 * 1200 )
//		{
//			continue;
//		}

		good_targets[ good_targets.size ] = target;
	}

	if ( IsDefined( sort_by_ent ) )
	{
		good_targets = SortByDistance( good_targets, sort_by_ent.origin );
	}
	else
	{
		good_targets = SortByDistance( good_targets, level.player.origin );
	}

	return good_targets;
}

//---------------------------------------------------------
// Scripted Environment Section 
//---------------------------------------------------------
sewer_pipes()
{
//	flag_wait( "docks_sewer_pipes" );
//	wait( 1 );

	trigger = GetEnt( "sewer_pipes_trigger", "targetname" );
	while ( 1 )
	{
		trigger waittill( "damage", dmg, attacker, dir, point, mod, modelname, tag, part, weapon );

		if ( attacker == level.docks_littlebird )
		{
			break;
		}
	}

	trigger Delete();


	ents = GetEntArray( "sewer_pipe", "targetname" );
	dozer = GetEnt( "docks_bulldozer", "targetname" );
	ents[ ents.size ] = dozer;

	foreach ( ent in ents )
	{
    	add_cleanup_ent( ent, "docks_stuff" );
		ent.animname = ent.script_noteworthy;
		ent setanimtree();
		ent ent_flag_init( "anim_stopped" );
		ent thread sewer_pipe_fx();
	}

	node = getstruct( "sewer_pipes_animnode", "targetname" );
	node thread anim_single( ents, "sewer_pipe_roll" );
	level thread sewer_pipes_kill_ai( node, ents );

	wait( 6 );
	blocker = GetEnt( "sewer_pipes_blocker", "targetname" );
	blocker DisconnectPaths();
	flag_set( "sewer_pipes_done" );
}

sewer_pipe_fx()
{
	self endon( "death" );
	if ( self.targetname != "sewer_pipe" )
	{
		return;
	}

	while ( self.origin[ 2 ] > 575 )
	{
		wait( 0.05 );
	}

	self thread sewer_pipe_end_anim();

	while ( !ent_flag( "anim_stopped" ) )
	{
		wait( 0.2 );
		PlayFXOnTag( getfx( "dirt_kickup_concrete_cylinder_loop" ), self, "tag_origin" );
	}
}

sewer_pipe_end_anim()
{
	self endon( "death" );
	self waittillmatch( "single anim", "end" );
	self ent_flag_set( "anim_stopped" );
}

sewer_pipes_kill_ai( node, ents )
{
	anim_time = 6000;
	time = GetTime() + anim_time;

	while ( GetTime() < time )
	{
		wait( 0.05 );
		ais = GetAiArray( "axis" );

		if ( IsAlive( level.player ) )
		{
			foreach ( ent in ents )
			{
				if ( ent.script_noteworthy == "sewer_pipe3" )
				{
					continue;
				}

				// Fix for 2nd pipe killing player while he's hiding in another pipe
				if ( time - GetTime() > ( anim_time - 1100 ) && ent.script_noteworthy == "sewer_pipe2" )
				{
					continue;
				}

				if ( level.player is_touching_sewer_pipe( ent ) )
				{
					// TODO: Add "squish" sound
					level.player Kill( level.player.origin + ( 1000, 0, 0 ) );
				}
			}
		}

		foreach ( ai in ais )
		{
			foreach ( ent in ents )
			{
				if ( ai is_touching_sewer_pipe( ent ) )
				{
					ai.deathfunction = ::sewer_pip_ragdoll;
					ai.deathanim = getanim_generic( "standing_death" );
					ai Kill( ai.origin + ( 1000, 0, 0 ) );
				}
			}
		}
	}
}

sewer_pip_ragdoll()
{
	dir = AnglesToForward( ( 0, -180, 0 ) ) * 5000;
	self StartRagdollFromImpact( "torso_lower", dir );
	wait( 0.05 );
}

is_touching_sewer_pipe( ent )
{
	x = 150;
	min_x = ent.origin[ 0 ] + ( x * -1 );
	max_x = ent.origin[ 0 ] + x - 80;

	y = 100;
	min_y = ent.origin[ 1 ] + ( y * -1 );
	max_y = ent.origin[ 1 ] + y;

	if ( self.origin[ 0 ] < max_x && self.origin[ 0 ] > min_x && self.origin[ 1 ] < max_y && self.origin[ 1 ] > min_y )
	{
		return true;
	}

	return false;
}

//sewer_pipe_death_func()
//{
//	self animscripts\shared::DropAllAIWeapons();
//	self SetFlaggedAnimKnobAllRestart( "deathanim", self getanim_generic( "standing_death" ), %body, 1, .1 );
//}

footstep_splash_trigger()
{
	if ( !IsDefined( level.footstep_triggers ) )
	{
		level.footstep_triggers = [];
	}

	level.footstep_triggers[ level.footstep_triggers.size ] = self;
}

//---------------------------------------------------------
// Catch up Section
//---------------------------------------------------------
catchup_trigger()
{
	start = getstruct( self.target, "targetname" );
	end = getstruct( start.target, "targetname" );

	while ( 1 )
	{
		self waittill( "trigger", player );
		while ( player IsTouching( self ) )
		{
			vec = VectorNormalize( end.origin - start.origin );
			player_vec = ( player.origin - start.origin );
			player_dot = VectorDot( player_vec, vec );

			foreach ( ai in level.sas_squad )
			{
				ai_vec = ( ai.origin - start.origin );
				ai_dot = VectorDot( ai_vec, vec );

				dist = player_dot - ai_dot;
				speed = 1 + ( dist * 0.01 ); // dist * 0.01 is the same as dist / 100
				speed = Clamp( speed, 1.1, 1.4 );


				if ( speed > 1.1 )
				{
					ai.moveplaybackrate = speed;
				}
				else
				{
					ai.moveplaybackrate = 1.1;
				}
			}

			wait( 0.05 );
		}

		foreach ( ai in level.sas_squad )
		{
			ai.moveplaybackrate = 1.1;
		}
	}
}

//--------------------------
// Utility section
//--------------------------
docks_cleanup_ents()
{
	flag_wait( "warehouse_complete" );

    london_docks_warehouse_volume = GetEntArray( "london_docks_warehouse_volume", "script_noteworthy" );
    
	delete_destructibles_in_volumes( london_docks_warehouse_volume );
	delete_interactives_in_volumes( london_docks_warehouse_volume );
    //delete_exploders_in_volumes( london_docks_warehouse_volume );
    fx_volume_pause_noteworthy( "london_docks_warehouse_volume" );

	ents = GetEntArray( "trigger_multiple", "code_classname" );
//	ents = array_combine( ents, GetSpawnerArray() );

	x = 78944;
	max_x = 83000;
	foreach( ent in ents )
	{
	    if( ent.classname == "trigger_multiple_fx_volume" )
		{
	        continue;
		}

		// BattleChatter Triggers
	    if( IsDefined( ent.locationAliases ) )
		{
	        continue;
		}
	        
		if ( ent.origin[ 0 ] > x && ent.origin[ 0 ] < max_x )
		{
			ent Delete();
		}
	}

	flag_wait( "docks_street" );

	ents = GetEntArray( "trigger_multiple", "code_classname" );
	foreach ( ent in ents )
	{
		if ( ent.classname == "trigger_multiple_friendly_respawn" )
		{
			ents = array_remove( ents, ent );
		}
		
		if ( ent.classname == "trigger_multiple_fx_volume" )
		{
			ents = array_remove( ents, ent );
		}

		if ( ent.classname == "trigger_multiple_ambient" )
		{
			ents = array_remove( ents, ent );
		}

		if ( IsDefined( ent.script_color_allies ) )
		{
			ents = array_remove( ents, ent );
		}

		// BattleChatter Triggers
	    if( IsDefined( ent.locationAliases ) )
		{
	        ents = array_remove( ents, ent );
		}
	}

	ents = array_combine( ents, GetSpawnerArray() );

	x = 75400;
	max_x = 83000;
	y = -1152;
	foreach( ent in ents )
	{
		if ( ent.origin[ 0 ] > x && ent.origin[ 1 ] < y && ent.origin[ 0 ] < max_x )
		{
			ent Delete();
		}
	}
}

docks_enemies_engage()
{
	if ( !IsAlive( self ) )
	{
		return;
	}

	self notify( "end_patrol" );
	self.ignoreall = false;
	self.ignoreme = false;
	self gun_recall();
	self enable_arrivals();
	self enable_exits();
	self clear_run_anim();

	self.doDangerReact = true;
	self.dangerReactDuration = 1000;

	// Find the nearest cover area and get there
	ents = GetEntArray( "docks_cover_area", "script_noteworthy" );
	ents = SortByDistance( ents, self.origin );
	self SetGoalVolumeAuto( ents[ 0 ] );

	// Now if doing an idle anim, stop it!
	if ( !IsDefined( self.target ) )
	{
		return;
	}

	struct = getstruct( self.target, "targetname" );

	if ( !IsDefined( struct ) )
	{
		return;
	}

	struct notify( "stop_loop" );
	self anim_stopanimscripted();
}

nag_thread( prefix, count, while_flag, delay_min, delay_max, end_delay )
{
	self endon( "death" );

	if ( !IsDefined( delay_min ) )
	{
		delay_min = 20;
	}

	if ( !IsDefined( delay_max ) )
	{
		delay_max = 30;
	}

	lines = [];
	for ( i = 0; i < count; i++ )
	{
		lines[ i ] = prefix + ( i + 1 );
	}

	while ( !flag( while_flag ) )
	{
		lines = array_randomize( lines );

		for ( i = 0; i < count; i++ )
		{
			wait( RandomFloatRange( delay_min, delay_max ) );

			if ( flag( while_flag ) ) 
			{
				break;
			}

			self dialogue_queue( lines[ i ] );
		}

		if ( IsDefined( end_delay ) )
		{
			wait( end_delay );
		}
	}
}

nag_single_solo( nag_guy, ref, stop_flag, delay_min, delay_max )
{
	nag_guys = [];
	nag_guys[ 0 ] = nag_guys;

	thread nag_single( nag_guys, ref );
}

nag_single( nag_guys, ref, stop_flag, delay_min, delay_max )
{
	if ( !IsDefined( delay_min ) )
	{
		delay_min = 20;
	}

	if ( !IsDefined( delay_max ) )
	{
		delay_max = 30;
	}

	foreach ( nag_guy in nag_guys )
	{
		if ( flag( stop_flag ) )
		{
			return;
		}

		wait( RandomFloatRange( delay_min, delay_max ) );

		if ( flag( stop_flag ) )
		{
			return;
		}

		if ( !IsDefined( nag_guy ) )
		{
			continue;
		}

		if ( !IsAlive( nag_guy ) || nag_guy doinglongdeath() )
		{
			continue;
		}

		nag_guy dialogue_queue( ref );
	}
}

flag_set_on_death( msg )
{
	level endon( msg );

	self waittill( "death" );
	flag_set( msg );
}

radio_dialogue_and_notify( msg )
{
	if ( !flag_exist( "radio_dialogue_done" ) )
	{
		flag_init( "radio_dialogue_done" );
	}

	flag_clear( "radio_dialogue_done" );

	thread radio_dialogue_and_notify_internal( msg );
}

radio_dialogue_and_notify_internal( msg )
{
	radio_overlap_wrapper( msg );
	flag_set( "radio_dialogue_done" );
}


radio_overlap_wrapper( alias )
{
	if ( !IsDefined( level.player_radio_emitter ) )
	{
		radio_dialogue( alias );
	}
	else
	{
		radio_dialogue_overlap( alias );
	}
}

trigger_garage_door()
{
	self waittill( "trigger" );

	doors = GetEntArray( self.target, "targetname" );
	foreach ( door in doors )
	{
		if ( IsSpawner( door ) )
		{
			continue;
		}

		door thread garage_door_open();
	}
}

garage_door_open()
{
	if ( IsDefined( self.opened ) )
	{
		return;
	}

	self.opened = true;
	self script_delay();

	dist = 104;
	z = self.origin[ 2 ] + dist;
	pieces = GetEntArray( self.target, "targetname" );

	spawners = [];

	clip = undefined;
	foreach ( piece in pieces )
	{
		if ( IsSpawner( piece ) )
		{
			spawners[ spawners.size ] = piece;
			continue;
		}

		piece LinkTo( self );
		piece thread garage_door_unlink( z );
	}

	if ( spawners.size > 0 )
	{
		array_spawn( spawners );
	}

	min_dist = 48;
	time = 2.5;
	speed = dist / time;
	time = min_dist / speed;

	self play_sound_on_entity( "door_garage_metal_rolling_up" );
	self MoveZ( min_dist, time, time * 0.8 );
	wait( time - 0.05 );

	self ConnectPaths();

	dist -= min_dist;
	time = dist / speed;
	self MoveZ( dist, time );
}

garage_door_unlink( z )
{
	while ( self.origin[ 2 ] < z )
	{
		wait( 0.05 );
	}

	self Delete();
}

remove_attractor_on_death()
{
	self waittill( "death" );

	if ( !IsDefined( self ) )
	{
		return;
	}

	Missile_DeleteAttractor( self.attractor );
}

wait_for_match_or_death( note1, note2 )
{
	self endon( "death" );
	self waittillmatch( note1, note2 );
}

Waittillmatch_Or_Timeout( note1, note2, time )
{
	self notify( "waittillmatch_timeout" );

	self thread waittillmatch_timeout( time );
	self endon( "waittillmatch_timeout" );
	self endon( "death" );
	self waittillmatch( note1, note2 );

	self notify( "waittillmatch_timeout" );
}

waittillmatch_timeout( time )
{
	self endon( "waittillmatch_timeout" );
	wait( time );
	self notify( "waittillmatch_timeout" );
}

is_valid_anim( anime, animname )
{
	if ( !IsDefined( animname ) )
	{
		animname = self.animname;
	}

	if ( IsDefined( level.scr_anim[ animname ][ anime ] ) )
	{
		return true;
	}

	return false;
}

get_opposite_sas()
{
	foreach ( ai in level.sas_squad )
	{
		if ( ai != self )
		{
			return ai;
		}
	}

	return undefined;
}

safe_magic_bullet( start_pos, end_pos )
{
	fake_it = false;

	trace = BulletTrace( start_pos, end_pos, true );

	if ( IsDefined( trace[ "entity" ] ) && trace[ "entity" ] == level.player )
	{
		fake_it = true;
	}

	if ( IsDefined( trace[ "fraction" ] ) < 0.8 )
	{
		fake_it = true;
	}

	PlayFxOnTag( getfx( "silencer_flash" ), self, "tag_flash" );

	if ( fake_it )
	{
		angles = VectorToAngles( end_pos - start_pos );
		forward = AnglesToForward( angles );
		start_pos = end_pos + ( forward * -10 );
	}

	MagicBullet( self.weapon, start_pos, end_pos );
}

docks_enable_cqbwalk()
{
	self enable_cqbwalk();
	self.moveplaybackrate = 1.1;
}

docks_disable_cqbwalk()
{
	self disable_cqbwalk();
	self.moveplaybackrate = 1;
}

empty( val1, val2 )
{
}

is_ai_dead_or_undefined( ent )
{
	if ( !IsDefined( ent ) )
	{
		return true;
	}

	if ( IsAi( ent ) )
	{
		if ( !IsALive( ent ) )
		{
			return true;
		}

		if ( ent doingLongDeath() )
		{
			return true;
		}
	}

	return false;
}

ent_follow_path( targetname, speed )
{
	self endon( "death" );

	path_start = getstruct( targetname, "targetname" );
	path_point = path_start;

	while ( IsDefined( path_point ) )
	{
		dist = Distance( self.origin, path_point.origin );
		time = dist / speed;

		self MoveTo( path_point.origin, time );
		wait( time );

		if ( !IsDefined( path_point.target ) )
		{
			break;
		}

		path_point = getstruct( path_point.target, "targetname" );
	}
}

#using_animtree( "generic_human" );
sniper_aim_thread()
{
	self endon( "death" );
	self UseAnimTree( #animtree );

	transTime = 0.2;
	self setAnimKnobAll( %prone_aim_5, %body, 1, transTime );
	self setAnimLimited( %prone_aim_2_add, 1, transTime );
	self setAnimLimited( %prone_aim_4_add, 1, transTime );
	self setAnimLimited( %prone_aim_6_add, 1, transTime );
	self setAnimLimited( %prone_aim_8_add, 1, transTime );

	aim2 = %aim_2;
	aim4 = %aim_4;
	aim6 = %aim_6;
	aim8 = %aim_8;

	//// max change in angle in 1 frame
	normalDeltaChangePerFrame = 10;
	largeDeltaChangePerFrame = 30;

	prevYawDelta = 0;
	prevPitchDelta = 0;
	firstFrame = true;
	deltaChangePerFrame = normalDeltaChangePerFrame;

	while ( !flag( "docks_warehouse" ) )
	{
//		incrAnimAimWeight();

		shootFromPos = self GetTagOrigin( "tag_flash" );
		shootPos = self.laser_ent.target_ent.origin;

		shoot_angles = VectorToAngles( shootPos - shootFrompos );
		delta_angles = self.angles - shoot_angles;
		pitchDelta = delta_angles[ 0 ];
		yawDelta = delta_angles[ 1 ];

		deltaChangePerFrame = normalDeltaChangePerFrame;
		deltaChangePerFrameSq = squared( deltaChangePerFrame );

	
		checkDeltaChange = !firstFrame;
		if ( checkDeltaChange )
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if ( squared( yawDeltaChange ) > deltaChangePerFrameSq )
			{
				yawDelta = prevYawDelta + clamp( yawDeltaChange, -1 * deltaChangePerFrame, deltaChangePerFrame );
				yawDelta = clamp( yawDelta, -90, 90 );		
			}

			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( squared( pitchDeltaChange ) > deltaChangePerFrameSq )
			{
				pitchDelta = prevPitchDelta + clamp( pitchDeltaChange, -1 * deltaChangePerFrame, deltaChangePerFrame );
				pitchDelta = clamp( pitchDelta, -60, 60 );
			}
		}

		firstFrame = false;
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
//		pitchDelta = -30;
//		yawDelta = -30;
		sniper_aim_weights( aim2, aim4, aim6, aim8, pitchDelta, yawDelta );
		wait( 0.05 );
	}
}

sniper_aim_weights( aim2, aim4, aim6, aim8, pitchDelta, yawDelta )
{
	aim_weight = 1.0;
	aim_blend_time = 0.1;
	if ( yawDelta > 0 )
	{
		weight = yawDelta / 90 * aim_weight;
		self setAnimLimited( aim4, 0, aim_blend_time, 1, true );
		self setAnimLimited( aim6, weight, aim_blend_time, 1, true );
	}
	else if ( yawDelta < 0 )
	{
		weight = yawDelta / -90 * aim_weight;
		self setAnimLimited( aim6, 0, aim_blend_time, 1, true );
		self setAnimLimited( aim4, weight, aim_blend_time, 1, true );
	}

	if ( pitchDelta > 0 )
	{
		weight = pitchDelta / 60 * aim_weight;
		self setAnimLimited( aim2, 0, aim_blend_time, 1, true );
		self setAnimLimited( aim8, weight, aim_blend_time, 1, true );
	}
	else if ( pitchDelta < 0 )
	{
		weight = pitchDelta / -60 * aim_weight;
		self setAnimLimited( aim8, 0, aim_blend_time, 1, true );
		self setAnimLimited( aim2, weight, aim_blend_time, 1, true );
	}
}
//
//streets_visionset()
//{
//	trigger = GetEnt( "london_construction_street_vision", "targetname" );
//	trigger waittill( "trigger" );
//
//	og = GetMapSunLight();
//
//	new = og; // Store the map setting cause that's what we want it at after the blend.
//
//	// Hardscripted cause we cannot grab the stage settings
//	// GetMapSunLight() only grabs the worldspawn settings -- noted for next game.
//	// stage sets sun to 0.3
//	for ( i = 0; i < og.size; i++ )
//	{
//		og[ i ] *= 0.3;
//	}	
//
//	sun_light_fade( og, new, trigger.script_delay );
//}
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\london_code;
#include maps\london_docks_code;
#include maps\london_uav;

pre_load()
{
	maps\_vehicle::build_deathfx_override( "script_vehicle_sas_van_physics", "sas_van_physics", "script_vehicle_sas_van_physics", "explosions/large_vehicle_explosion_london", undefined, "car_explode" );
	maps\_patrol_anims::main();
	maps\london_docks_anim::main();
	docks_precache();
	uav_init();
}

main()
{
	if ( IsDefined( level.docks_initialized ) )
	{
		return;
	}

	level.docks_initialized = true;
	level.vehicle_draw_thermal = true;

	init_triggers();
	init_footsteps_wrapper();
	init_docks_spawner_functions();
	init_uav_intro();

	level thread warehouse_light();
	level thread intro_truck();

	thread light_dvar_thread();
	thread alley_quick_kills();
	thread docks_cleanup_ents();
	thread warehouse_tv();
	thread maps\london_docks_anim::rocking_items();

	level.docks_vans = spawn_vehicles_from_targetname( "docks_sas_van" );

	if ( !IsDefined( level.alley_quick_kills ) )
	{
		level.alley_quick_kills = 0;
	}

    // 5 idle sitting vehicles.. They should be spawners, will play with starts better.
	disable_sounds_on_useless_cars();

	spawners = GetEntArray( "snipers", "targetname" );
	foreach( spawner in spawners )
	{
		spawner.script_drone_override = true;
	}

	clip = GetEnt( "docks_truck_clip", "targetname" );
	clip ConnectPaths();
	clip trigger_off();

	collision = GetEnt( "sewer_pipe_collision", "targetname" );
	collision ConnectPaths();
	collision NotSolid();
	collision Hide();

	// Testing
/#
	thread debug_sound_stuff();
	thread debug_sound_positional();
#/
}

debug_sound_stuff()
{
/#
//	vehicle = spawn_vehicles_from_targetname( "docks_littlebird_spawner" );
//	goal = getstruct( "debug_sound_path", "targetname" );
//	vehicle[ 0 ] Vehicle_Teleport( goal.origin, vehicle[ 0 ].angles );

	SetDvarIfUninitialized( "debug_sound_stuff", "0" );
	if ( GetDvar( "debug_sound_stuff" ) == "0" )
	{
		return;
	}


	wait( 0.1 );

	door = GetEnt( "warehouse_door", "targetname" );
	door ConnectPaths();
	door RotateYaw( 140, 3, 0.25 );

	speed = 100;
	parent = Spawn( "script_origin", ( 0, 0, 0 ) );
	model = Spawn( "script_model", ( 0, 0, 0 ) );
	model SetModel( "vehicle_little_bird_armed" );

	model LinkTo( parent );

	goal = getstruct( "debug_sound_path", "targetname" );
	parent.origin = goal.origin + ( 50, 0, 0 );

	model thread print3d_on_ent( GetDvar( "debug_sound_stuff" ) );
	model thread debug_sound_stuff_sound();

	while ( 1 )
	{
		goal = getstruct( "debug_sound_path", "targetname" );

		while ( 1 )
		{
			MusicStop( 0 );

			dist = Distance( parent.origin, goal.origin );
			time = dist / speed;

			parent MoveTo( goal.origin, time );
			wait( time - 0.1 );

			if ( !IsDefined( goal.target ) )
			{
				break;
			}

			goal = getstruct( goal.target, "targetname" );
		}
	}
#/
}

debug_sound_stuff_sound()
{
/#
	loopsound = false;
	sound = undefined;
	delay = undefined;
	if ( GetDvar( "debug_sound_stuff" ) == "vehicle" )
	{
		self PlayLoopSound( "littlebird_engine_high" );
	}
	else if ( GetDvar( "debug_sound_stuff" ) == "weapon_sound" )
	{
		sound = "weap_kriss_fire_npc";
		delay = 0.1;

		while ( 1 )
		{
			self PlaySound( sound );
			wait( delay );
		}
	}
	else if ( GetDvar( "debug_sound_stuff" ) == "weapon_ai" )
	{
		target = Spawn( "script_origin", level.player.origin );
		level.sas_leader.ignoreall = false;
		level.sas_leader SetEntityTarget( target );
	}
	else if ( GetDvar( "debug_sound_stuff" ) == "mission" )
	{
		while ( 1 )
		{
//			target = Spawn( "script_origin", level.player.origin );
//			level.sas_leader.ignoreall = false;
//			level.sas_leader SetEntityTarget( target );
			level.sas_leader dialogue_queue( "frost_nag3" );
		}
	}
	else if ( GetDvar( "debug_sound_stuff" ) == "voice" )
	{
		while ( 1 )
		{
//			target = Spawn( "script_origin", level.player.origin );
//			level.sas_leader.ignoreall = false;
//			level.sas_leader SetEntityTarget( target );
			level.sas_leader PlaySound( "DF_0_callout_contactclock_12" );
			wait( 3 );
		}
	}
#/
}

print3d_on_ent( text )
{
	self endon( "death" );
	self notify( "stop_print3d_on_ent" );
	self endon( "stop_print3d_on_ent" );

	while ( 1 )
	{
		wait( 0.05 );
		print3d( self.origin, text );
	}
}

debug_sound_positional()
{
/#
	SetDvarIfUninitialized( "debug_sound_position", "0" );
	sound = "elm_stress";
	ent = undefined;
	while ( 1 )
	{
		if ( GetDvarInt( "debug_sound_position" ) == 1 )
		{
			if ( !IsDefined( ent ) )
			{
				ent = Spawn( "script_origin", level.player.origin );
			}

			dist = RandomFloatRange( 1000, 4000 );
			yaw = RandomFloatRange( 0, 360 );
			forward = AnglesToForward( ( 0, yaw, 0 ) );
	
			// Should always be about eye-level Z.
			origin = level.player.origin + ( forward * dist ) + ( 0, 0, 60 ); 

			ent.origin = origin;
//			wait( 0.1 );
			ent PlaySound( sound, "sounddone" );
			ent thread print3d_on_ent( sound );
			ent waittill( "sounddone" );
			ent notify( "stop_print3d_on_ent" );
			wait( 1 );
		}
		else
		{
			if ( IsDefined( ent ) )
			{
				ent Delete();
			}
		}

		wait( 1 );
	}
#/
}

// Starts -------------------------------------------------
start_alley()
{
	set_start_locations( "docks_start" );
	thread maps\_utility::set_ambient( "london_docks" );
}

start_alley_2nd_squad()
{
	level.alley_quick_kills = 1;
	set_start_locations( "2nd_alley_start" );
}

start_warehouse_breach()
{
	set_start_locations( "warehouse_start" );
}

start_warehouse_hallway()
{
	set_start_locations( "warehouse_hallway" );
}

start_docks_assault()
{
	set_start_locations( "docks_assault_start" );

//	if ( !GetDvarInt( "uav_intro" ) )
//	{
//		wait( 0.05 );
//		thread pip( "mole_takedown" );
//	}
}

start_docks_ambush()
{
	guys = array_spawn_noteworthy( "sas_orange" );

	foreach ( guy in guys )
	{
		guy thread postspawn_sas_orange();
		guy.script_noteworthy = undefined;
	}

	set_start_locations( "docks_assault_ambush", guys );
	set_littlebird_start( "docks_littlebird_spawner", "littlebird_ambush_start" );
}

start_docks_streets()
{
	guys = array_spawn_noteworthy( "sas_orange" );

	foreach ( guy in guys )
	{
		guy thread postspawn_sas_orange();
		guy.script_noteworthy = undefined;
	}

	if ( GetDvar( "test_chopper_rocket" ) != "" )
	{
		flag_set( "docks_street" );
		set_start_locations( "docks_assault_streets", guys );
		set_start_locations( "docks_assault_streets_chopper" );
		set_littlebird_start( "docks_littlebird_spawner", "littlebird_rocket_path" );
		return;
	}

	set_start_locations( "docks_assault_streets", guys );
	set_littlebird_start( "docks_littlebird_spawner", "littlebird_streets_start" );

	gate = GetEnt( "docks_gate_door", "targetname" );
	gate ConnectPaths();
	gate RotateTo( ( 0, -112, 0 ), 1, 0, 0 );

//	doors = GetEntArray( "docks_garage_doors", "targetname" );
//	array_thread( doors, ::garage_door_open );
}

// Intro Section ------------------------------------------
intro()
{
	main();

	set_flir_ents();

	level.player PlaySound( "scn_london_uav_intro" );
	level thread intro_flavor_bursts();
	level thread alley_sas_movement();

	level thread maps\london_docks_code::alley_comm_check_intro_anim();

	// Used for slamzoom
	level.intro_controller.ground_origin = level.player.origin;
	level.intro_controller.ground_angles = level.player.angles;

	if ( GetDvarInt( "quick_uav" ) )
	{
		ent = GetEnt( "intro_uav", "targetname" );
		node = GetVehicleNode( "quick_uav_node", "script_noteworthy" );
		ent.target = node.targetname;
	}

	// Spawn the UAV
	uav = uav_spawn_and_use( "intro_uav", level.player, level.intro_controller.forklift.origin );
	uav thread uav_cloud_thread();
	uav ent_flag_init( "slamzoom" );
	uav ent_flag_init( "focus_on_player" );

	level.uav = uav;

//	SetSavedDvar( "sm_sunsamplesizenear", 0.6 );
//	uav thread uav_update_shadows( "alley_start" );

	flag_wait( "introscreen_complete" );
	delaythread( 2, ::uav_view_cone_open, 4, 10, 10, 5, 5 );

	// Sequence
	thread intro_dialogue();

	if ( GetDvarInt( "quick_uav" ) )
	{
		level.intro_controller.forklift ent_flag_init( "cargo_unloading" );

		flag_set( "uav_focusing_on_player" );
		intro_scene_playerstart( uav );
		uav ent_flag_wait( "slamzoom" );
		uav uav_slamzoom();
		intro_cleanup();

		return;
	}

	intro_scene_forklift( uav );

//	intro_uav_add_targets();

	intro_scene_trucks( uav );

	flag_set( "uav_focusing_on_enemies" );
	intro_scene_patrol_look( uav );

	flag_set( "uav_focusing_on_player" );
	intro_scene_playerstart( uav );

	uav ent_flag_wait( "focus_on_player" );
//	level.player FreezeControls( true );
	level.player LerpFov( 20, 4 );
	uav_view_cone_open( 2, 0, 0, 0, 0 );

	uav ent_flag_wait( "slamzoom" );
	flag_set( "uav_slamzoom" );

	uav uav_slamzoom();

	flag_set( "uav_slamzoom_done" );

	thread lerp_saveddvar( "sm_sunsamplesizenear", 0.25, 0.5 );
	reset_flir_ents();
	intro_cleanup();
}

set_flir_ents()
{
	level.flir_ents = [];
	ents = GetEntArray( "destructible_vehicle", "targetname" );
	foreach ( ent in ents )
	{
		if ( ent.model != "vehicle_luxurysedan_2008_destructible" )
		{
			continue;
		}

		if ( ent.origin[ 0 ] < 75000 )
		{
			continue;
		}

		level.flir_ents[ level.flir_ents.size ] = ent;
	}

	ents = GetEntArray( "docks_truck_flir", "script_noteworthy" );
	foreach ( ent in ents )
	{
		ent.flir_model = "vehicle_uk_delivery_truck_flir";
		level.flir_ents[ level.flir_ents.size ] = ent;
	}

	foreach ( ent in level.flir_ents )
	{
		if ( IsDefined( ent.flir_model ) )
		{
			ent.og_model = ent.model;
			ent SetModel( ent.flir_model );
		}

		ent ThermalDrawEnable();
	}
}

reset_flir_ents()
{
	foreach ( ent in level.flir_ents )
	{
		if ( IsDefined( ent.og_model ) )
		{
			ent SetModel( ent.og_model );
			ent.og_model = undefined;
			ent.flir_model = undefined;
		}

		ent ThermalDrawDisable();
	}

	level.flir_ents = undefined;
}

// Alley Area ---------------------------------------------
alley_movement()
{
	main();
	intro_cleanup();

	thread save_post_intro();

/#
	if ( GetDvar( "debug_sound_stuff" ) != "0" )
	{
		level waittill( "never_ending" );
	}
#/

	battlechatter_off();
	player_speed_percent( 68 );
	level.player DisableOffHandWeapons();

	if ( is_start_point_after( "start_of_level" ) )
	{
		level thread alley_sas_movement();
	}

//	level.sas_leader waittill( "scripted_movement_done" );

	// Trigger at corner just before "warehouse_complete" trigger.
	flag_wait( "warehouse_player_lead_8" );
}

save_post_intro()
{
	flag_wait( "uav_slamzoom_done" );
	flag_wait( "uav_dialog_done" );
	wait( 1 );
	autosave_by_name( "post_intro" );
}

docks_assault()
{
	main();
	intro_cleanup();

	flag_wait( "warehouse_top" );

	autosave_by_name( "warehouse_complete" );
	player_speed_percent( 100, 3 );
	level.player EnableOffHandWeapons();

	level.player.ignoreme = true;
	array_thread( level.sas_squad, ::set_ignoreme, true );

	if ( level.start_point != "docks_assault_ambush" )
	{
		warehouse_exit_reach();
	}

	flag_set( "docks_assault" );

//	thread lerp_saveddvar( "sm_sunShadowScale", 0.5, 1 );
	SetSavedDvar( "sm_qualitySpotShadow", 0 );

	if ( level.start_point == "docks_assault_ambush" )
	{
		spawn_vehicles_from_targetname( "docks_littlebird_spawner" );
		thread docks_assault_squad_reset();
	}
	else
	{
		sas_van_teleport();

		delaythread( 5, ::spawn_vehicles_from_targetname_and_drive, "docks_littlebird_spawner" );
		array_thread( level.docks_vans, ::gopath );
		array_thread( level.docks_vans, ::docks_van_sounds );

		delaythread( 2, ::enemy_notify_end_patrol );
		// delaythread( 3, ::activate_trigger_with_noteworthy, "docks_initial_goalvolume" );

		activate_trigger_with_targetname( "docks_assault_colors" );

		thread docks_assault_squad_reset();
		thread docks_sniper();

		array_thread( level.sas_squad, ::stop_scripted_movement );	
		activate_trigger_with_targetname( "docks_sas_leader_colors" );
		flag_wait( "out_of_warehouse" );

		spawners = GetEntArray( "docks_floodspawners", "targetname" );
		maps\_spawner::flood_spawner_scripted( spawners );
//		array_spawn_targetname( "docks_floodspawners" );

		flag_wait_or_timeout( "docks_entrance", 10 );
		maps\_spawner::killspawner( 100 );
	}

	level thread docks_entrance();
}

docks_van_sounds()
{
	if ( IsDefined( self.script_parameters ) )
	{
		self thread play_sound_on_entity( "scn_london_rpg_van_arrive" );
		self waittill( "unloading" );
		self thread play_sound_on_entity( "scn_london_rpg_van_doors" );
	}
	else
	{
		wait( 1 );
		self thread play_sound_on_entity( "scn_london_rpg_van_arrive2" );		
	}
}

docks_assault_squad_reset()
{
	flag_wait_or_timeout( "out_of_warehouse", 5 );
	array_thread( level.sas_squad, ::docks_assault_guy_reset );
	level.player.ignoreme = false;
	battlechatter_on();
}

docks_assault_guy_reset()
{
	self.ignoreme = false;
	self.ignoreall = false;
	self.nododgemove = false;
	self docks_disable_cqbwalk();

	self.ignoresuppression = false;
	self.dontavoidplayer = false;
	self enable_arrivals();
	self enable_exits();
	self enable_surprise();
	self walkdist_reset();
}

docks_entrance()
{
	main();
	intro_cleanup();

//	level thread docks_start_getaway();

	if ( level.start_point != "docks_assault_ambush" )
	{
		array_spawn_targetname( "docks_enemy_group2" );
	}

	level thread docks_thread();
}

docks_thread()
{
	if ( level.start_point != "docks_assault_ambush" )
	{
		// Filter out enemy AI...
		guys = GetAiArray( "axis" );
		foreach ( guy in guys )
		{
			if ( !IsAlive( guy ) )
			{
				continue;
			}

			if ( guy.origin[ 0 ] > 78900 )
			{
				guy Kill();
				guys = array_remove( guys, guy );
			}
		}

		waittill_dead_or_dying( guys );
	}

	wait( 2 );
	if ( cointoss() )
	{
		radio_dialogue( "london_sr1_thrubuildings" );
	}
	else
	{
		level.sas_leader dialogue_queue( "london_ldr_allclear2" );
		level.sas_squad[ 1 ] dialogue_queue( "london_gfn_clear2" );
		
		closest = getclosest( level.player.origin, GetAiArray( "allies" ) );
		closest generic_dialogue_queue( "london_myr_clearboss" );
	}

	flag_set( "docks_check_truck" );

	triggers = GetEntArray( "docks_mid_color_trigger", "targetname" );
	array_thread( triggers, ::trigger_off );

	truck_scene();
}

truck_scene()
{
//	hover_spot = getstruct( "docks_chopper_hoverpoint_2", "targetname" );
//	level.docks_littlebird.hover.hover_point = hover_spot;

//	if ( level.start_point == "docks_assault_ambush" )
//	{
//		level.docks_littlebird waittill( "reached_dynamic_path_end" );
//		wait( 0.05 );
//	}

	level.docks_littlebird thread chopper_follow_path( "littlebird_ambush_path", ::littlebird_ambush_earlyout );

	flag_set( "docks_open_truck_door" );

	ent = GetEnt( "docks_truck_door_chopper_target", "targetname" );
	littlebird_set_override_target( ent );
	level.docks_littlebird SetLookAtEnt( ent );
	ent thread chopper_target_movement( 50 );

	level.sas_leader thread dialogue_queue( "london_ldr_perimetersecure" );

	// Docks are clear, check out the truck
	activate_trigger_with_targetname( "docks_truck_colors" );

	thread player_open_truck_door();
	truck_wallcroft_scene();

	flag_wait( "docks_truck_searched" );
}

littlebird_ambush_earlyout()
{
	self endon( "follow_path_done" );
	self endon( "stop_follow_path" );
	level endon( "littlebird_rpg_shot" );

	flag_wait( "docks_warehouse" );

	self ent_flag_set( "earlyout" );
}

truck_wallcroft_scene()
{
	level.sas_leader disable_ai_color();
	struct = getstruct( "dock_truck_anim_spot", "targetname" );
	anim_pos = GetStartOrigin( struct.origin, struct.angles, level.sas_leader getanim( "search_truck_entry" ) );

	struct anim_reach_solo( level.sas_leader, "search_truck_entry" );
//	level.sas_leader dialogue_queue( "london_ldr_lorrysecure" );
//	level.sas_leader ent_flag_init( "truck_wallcroft_dialogue" );

//	level thread truck_wallcroft_dialogue();
//	wait( 2 );

//	level.sas_leader.goalradius = 130;
//	level.sas_leader SetGoalPos( anim_pos );
//	level.sas_leader waittill( "goal" );

//	level.sas_leader ent_flag_wait( "truck_wallcroft_dialogue" );
//	level.sas_leader thread dialogue_queue( "london_ldr_keepusposted" );

	struct anim_single_solo( level.sas_leader, "search_truck_entry" );
	level.sas_leader thread truck_wallcroft_wait( struct );
}

truck_wallcroft_wait( struct )
{
	self thread truck_wallcroft_nag( struct );

	flag_wait( "docks_truck_door_opened" );
	struct notify( "stop_loop" );
	self anim_stopanimscripted();

	delaythread( 2, ::flag_set, "docks_truck_searched" );
	level.sas_squad[ 1 ] delaythread( 2.75, ::dialogue_queue, "london_gfn_nickedweapons" );

	self thread truck_wallcroft_cut_anim_short();
	struct anim_single_solo( self, "search_truck_lookinside" );

	level.sas_leader enable_ai_color();
}

truck_wallcroft_cut_anim_short()
{
	wait( 0.1 );
	animation = self getanim( "search_truck_lookinside" );
	duration = GetAnimLength( animation );
	self SetAnimTime( animation, 0.25 );
}

truck_wallcroft_nag( struct )
{
	if ( flag( "docks_truck_door_opened" ) )
	{
		return;
	}

	level endon( "docks_truck_door_opened" );

	lines  = [ "london_ldr_opendoors", "london_ldr_youdim", "london_ldr_getdoorsopen" ];

	delay = 2;
	while ( 1 )
	{
		lines = array_randomize( lines );

		if ( delay == 0 ) 
		{
			for ( i = 0; i < lines.size; i++ )
			{
				count = RandomIntRange( 1, 2 );
				for ( q = 0; q < count; q++ )
				{
					struct anim_single_solo( self, "search_truck_idle" );
				}
	
				level.scr_sound[ self.animname ][ "search_truck_point" ] = lines[ i ];
				struct anim_single_solo( self, "search_truck_point" );
			}
		}

		if ( delay > 0 )
		{
			delay--;
		}

		struct anim_single_solo( self, "search_truck_idle" );
	}
}

player_open_truck_door()
{
	level.player endon( "death" );

	flag_wait( "player_open_doors" );

	truck = GetEnt( "docks_truck", "targetname" );
	obj_model = Spawn( "script_model", truck.origin );
	obj_model.angles = truck.angles;
	obj_model SetModel( "vehicle_uk_delivery_truck_glowing" );

	trigger = get_docks_truck_door_trigger();
	trigger safe_playeruse_trigger();

	trigger Delete();

	flag_set( "docks_truck_door_opened" );

	truck = GetEnt( "docks_truck", "targetname" );
	truck.animname = "delivery_truck";
	truck assign_animtree();

	player_rig = spawn_anim_model( "player_rig" );
	player_rig Hide();

	tag = "tag_guy4";
	anime = "player_open_truck_doors";

	// Fixes player unlinking into solid bug
	fake_tag = spawn_tag_origin();
	fake_tag.origin = truck GetTagOrigin( tag ) + ( 0, 0, 1 );
	fake_tag.angles = truck GetTagAngles( tag );

	level.player SetStance( "stand" );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeapons();

	fake_tag anim_first_frame_solo( player_rig, anime, "tag_origin" );
	level thread docks_truck_player_linkto( player_rig );

	obj_model Delete();

	player_rig delayCall( 0.4, ::Show );

	struct = getstruct( "truck_door_sound_spot", "targetname" );
	thread play_sound_in_space( "scn_docks_truck_door_open", struct.origin );

	truck thread anim_single_solo( truck, anime );
	fake_tag anim_single_solo( player_rig, anime, "tag_origin" );

	clip = GetEnt( "docks_truck_clip", "targetname" );
	clip trigger_on();
	clip DisconnectPaths();

	wait( 3 );

	autosave_by_name( "docks_ambush" );

	level.player AllowCrouch( true );
	level.player AllowProne( true );

	player_rig Delete();
	fake_tag Delete();
	level.player Unlink();
	level.player EnableWeapons();

	triggers = GetEntArray( "trigger_after_ambush", "script_noteworthy" );
	array_thread( triggers, ::trigger_on );

	level thread docks_ambush();
}

docks_truck_player_linkto( player_rig )
{
	level.player endon( "death" );

	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.4, 0.2, 0.2 );
	wait( 0.5 );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 0 );
	time = 4;
	level.player LerpViewAngleClamp( time, time * 0.5, time * 0.5, 20, 20, 30, 10 );

	thread player_linked_death();
}

docks_ambush()
{
	gate = GetEnt( "docks_gate_door", "targetname" );
	gate ConnectPaths();
	gate RotateTo( ( 0, -112, 0 ), 1, 0, 0 );
//	wait( 0.05 );
//	gate.angles = ( 0, -112, 0 );

	delaythread( 1, ::flag_set, "docks_ambush" );
	delaythread( 1, ::spawn_vehicles_from_targetname_and_drive, "docks_ambush_rpg" );
	delaythread( 1.3, ::docks_ambush_dialogue );
	
	activate_trigger_with_targetname( "docks_ambush_colors" );
	array_spawn_targetname( "docks_ambusher" );

//	thread streets_visionset();
	thread docks_catwalk();

	delaythread( 1, ::flag_set, "docks_after_ambush" );
	delaythread( 2, ::MusicPlayWrapper, "london_ambush" );
//	flag_wait_or_timeout( "docks_after_ambush", 10 );

	doors = GetEntArray( "docks_garage_doors", "targetname" );
	array_thread( doors, ::garage_door_open );
}

docks_catwalk()
{
	flag_wait_or_timeout( "docks_after_ambush", 20 );

//	wait( 3 );

	upper_door = GetEnt( "docks_warehouse_door", "targetname" );
	upper_door ConnectPaths();
	upper_door RotateTo( ( 0, -175, 0 ), 1 );
	wait( 0.05 );

	array_spawn_targetname( "docks_catwalk_spawner" );
}

docks_ambush_dialogue()
{
	guys = get_force_color_guys( "allies", "r" );
	guys = SortByDistance( guys, level.player.origin );

	guys[ 0 ] thread generic_dialogue_queue( "london_myr_contact" );

	wait( 0.1 );
	guys = get_force_color_guys( "allies", "r" );
	guys = SortByDistance( guys, level.player.origin );
	guys[ 0 ] generic_dialogue_queue( "london_sasl_gotcompany" );
}

docks_streets()
{
	main();
	intro_cleanup();

	if ( level.start_point == "docks_assault_streets" )
	{
//		activate_trigger_with_noteworthy( "docks_getaway_streets" );
		vehicle = spawn_vehicles_from_targetname( "docks_littlebird_spawner" );
		thread docks_assault_squad_reset();
		activate_trigger_with_noteworthy( "docks_streets_color_trigger" );
		wait( 1 );
	}

	flag_wait( "docks_littlebird_strafe" );

	level thread docks_littlebird_strafe();

//	chopper = spawn_vehicle_from_targetname( "docks_littlebird_spawner2" );

	flag_wait( "docks_street" );
//	level.docks_littlebird thread chopper_follow_line_path( "littlebird_streets_path" );

//	flag_wait( "docks_street" );
//	wait( 5 );
	flag_wait( "docks_enemy_fallback" );
//	thread sewer_pipes();
//	level thread docks_enemies_fallback( "docks_getaway_volume" );
	wait( 3 );

//	level thread nag_thread( level.sas_leader, "reiterate_action", 5, "docks_complete" );

//	flag_wait( "docks_almost_half_way" );
	wait( 3 );

	thread docks_end_dialogue();
}

docks_littlebird_strafe()
{
	level.docks_littlebird.pause_spot_light_monitor = true;
	level.docks_littlebird notify( "stop_follow_line_path" );
	level.docks_littlebird thread chopper_follow_path( "littlebird_strafe_path" );

	level.sas_leader dialogue_queue( "london_ldr_keepuscovered" );
	radio_dialogue( "london_hp2_wereonit" );
}

docks_littlebird_rocket()
{
	flag_wait( "docks_sewer_pipes" );

	level.sas_leader dialogue_queue( "london_ldr_firefromwest" );
	thread radio_dialogue( "london_hp2_backaround" );
	flag_set( "docks_littlebird_rocket" );

	self ent_flag_set( "spotlight_on" );
//	self notify( "stop_follow_line_path" );

//	wait( 0.1 );
//	self thread chopper_follow_path( "littlebird_rocket_path4" );

	self ent_flag_wait( "docks_rocket_lockon" );

	struct = getstruct( "sewer_pipe_target", "targetname" );
	target = Spawn( "script_origin", struct.origin );
	self.target_ent = target;

	littlebird_set_override_target( target );

	self SetLookAtEnt( target );

	self waittill( "fire_rockets" );
	target thread ent_follow_path( struct.target, 200 );

	self waittill( "prep_stop_rockets" );
	level thread sewer_pipes();
	littlebird_clear_override_target();

	self waittill( "follow_path_done" );

//	self.pause_spot_light_monitor = undefined;
//	self.pause_spot_light_monitor = true;
	self ent_flag_set( "spotlight_on" );
	target Delete();

	struct = getstruct( "construction_area_hoverpoint", "targetname" );
	level.docks_littlebird.hover.hover_point = struct;
	level.docks_littlebird.pause_spot_light_monitor = false;
}

docks_end_dialogue()
{
	flag_wait( "docks_complete" );

	sewer_pipe_collision();

	level.docks_littlebird thread chopper_follow_line_path( "littlebird_tube_path" );

	wait( 3 );
	level.sas_squad[ 1 ] dialogue_queue( "london_gfn_tothetube" );
	level.sas_leader dialogue_queue( "london_ldr_pursuing" );
	radio_dialogue( "london_com_awaitorders" );
	radio_dialogue( "london_hp2_maintainshadow" );

	wait( 1 );
	level.docks_littlebird notify( "stop_follow_line_path" );
	level.docks_littlebird thread chopper_follow_path( "littlebird_exit_path" );
	level.docks_littlebird.pause_spot_light_monitor = true;

//	thread lerp_saveddvar( "sm_sunShadowScale", 1, 1 );
	SetSavedDvar( "sm_qualitySpotShadow", 1 );
}

sewer_pipe_collision()
{
	collision = GetEnt( "sewer_pipe_collision", "targetname" );
	collision Solid();
	collision Show();

	clip = GetEnt( "sewer_pipe_clip2", "targetname" );
	clip Delete();
}
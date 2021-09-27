#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\london_west_code;
#include maps\london_code;

pre_load()
{
	PrecacheString( &"LONDON_HINT_FLASHBANG" );
	add_hint_string( "hint_flashbang", &"LONDON_HINT_FLASHBANG", maps\london_west_code::should_break_flashbang_hint );
	
	PreCacheShellShock( "london_gas_nosway" );
	PreCacheShellShock( "london_gas" );
	PreCacheShellShock( "london_gas_post" );
	PreCacheShellShock( "london_explosion" );	
	PreCacheShellShock( "westminster_truck_crash" );
	
	PrecacheTurret( "heli_spotlight" );
	PreCacheTurret( "player_view_controller_shakeycam" );
	PrecacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	PrecacheModel( "electronics_camera_pointandshoot_low" );
	PrecacheModel( "electronics_camera_cellphone_low" );
	PrecacheModel( "body_sas_urban_smg" );
	PrecacheModel( "london_injector" );
	PrecacheModel( "prop_sas_gasmask" );
	PrecacheModel( "vehicle_uk_delivery_truck_destroyed" );
	PrecacheItem( "rpg_player" );

	maps\london_west_anim::main();
	maps\_readystand_anims::initReadyStand();
	maps\_drone_ai::init(); 

	westminster_sound_settings();

	lit_posters();

	flag_init( "train_crashed" );

	flag_init( "escalator_grenade_thrown" );
	flag_init( "start_station_music" ); 
	flag_init( "start_train_traverse" );
	flag_init( "player_has_flashed" );
	flag_init( "enemy_takedown" );
	flag_init( "truck_spawned" );
	flag_init( "setup_blockade" );
	flag_init( "truck_stopped" );
	flag_init( "truck_hit" );
	flag_init( "truck_explodes" );
	flag_init( "take_down_finished" );
	flag_init( "westminster_entity_cleanup" );
	flag_init( "ending_police_car_stopped" );
	flag_init( "do_innocent" );
	flag_init( "wallcroft_at_stairs" );
}

westminster_sound_settings()
{
	//set up dynamic sound channels that will only be partially affected by slomo (taken from breach code)
	SoundSetTimeScaleFactor( "Music", 0 );
	SoundSetTimeScaleFactor( "Menu", 0 );
	SoundSetTimeScaleFactor( "local3", 0.0 );
	SoundSetTimeScaleFactor( "Mission", 0.0 );
	SoundSetTimeScaleFactor( "Announcer", 0.0 );
	SoundSetTimeScaleFactor( "Bulletimpact", .60 );
	SoundSetTimeScaleFactor( "Voice", 0.0 );
	SoundSetTimeScaleFactor( "effects1", 0.20 );
	SoundSetTimeScaleFactor( "effects2", 0.20 );
	SoundSetTimeScaleFactor( "local", 0.20 );
	SoundSetTimeScaleFactor( "local2", 0.20 );
	SoundSetTimeScaleFactor( "physics", 0.20 );
	SoundSetTimeScaleFactor( "ambient", 0.50 );
	SoundSetTimeScaleFactor( "auto", 0.50 );
}

post_load()
{
	array_spawn_function_noteworthy( "dead_vendor", ::ai_to_animated_model_spawnfunc );
	array_spawn_function_noteworthy( "remove_fixednode", ::remove_fixednode );
	array_spawn_function_noteworthy( "wait_move_fight", ::wait_move_fight );
	array_spawn_function_targetname( "stairs_guys", ::stairs_guys );

	thread set_ambient( "london_tube_end" );
}

start_train_end()
{
}

post_train_crash_dialogue()
{
//	flag_wait( "train_crash_tumble_stops" );
	wait( 1 );

	radio_dialogue( "london_com_doyoucopy" );
	level.sas_leader dialogue_queue( "london_ldr_burnsalright" );
	radio_dialogue( "london_com_status" );
	level.sas_leader dialogue_queue( "london_ldr_scrapmetal2" );
	radio_dialogue( "london_com_rendevous" );
	level.sas_leader dialogue_queue( "london_ldr_nothingwecando" );
}

start_west_station()
{
	maps\london_code::set_start_locations( "start_west_station" );
	sas_leader_init();
}

start_west_ending()
{
	maps\london_code::set_start_locations( "start_west_ending" );
	sas_leader_init();
}

start_west_ending_stairs()
{
	SetDvar( "show_wip", "1" );
	maps\london_code::set_start_locations( "start_west_ending_stairs" );	
	activate_trigger_with_targetname( "cleared_station_exit" );

	sas_leader_init();
}

start_west_dad_scene()
{
	maps\london_code::set_start_locations( "start_west_dad_scene" );
	delaythread( 1, ::flag_set, "reached_station_exit" );
}

start_west_epilogue()
{
	thread maps\_ambient::use_eq_settings( "london_westminster_ending", level.eq_mix_track );
}

//--------------------------------------------------------
// Train Crash Exit
//---------------------------------------------------------
player_wake()
{
	get_black_overlay();
	level.black_overlay.alpha = 1;

	flag_wait( "fade_up" );
	wait( 2 );

	level.black_overlay FadeOverTime( 5 );
	level.black_overlay.alpha = 0;

	SetBlur( 5, 0 );
	wait( 2 );
	SetBlur( 2, 0.7 );
	wait( 0.7 );
	SetBlur( 5, 0.5 );
	wait( 0.5 );
	SetBlur( 1, 1 );
	wait( 1 );
	SetBlur( 3, 1 );
}

train_crash_exit()
{
	thread player_wake();

	flag_set( "fade_up" );

	thread maps\london_west::sandman_stumbles();
	thread post_train_crash_dialogue();

    level.player DisableWeapons();
	player_rig_tunnel_crash_teleport = spawn_anim_model( "player_rig_tunnel_crash_teleport" );
    level.player_rig_tunnel_crash_teleport = player_rig_tunnel_crash_teleport;
    
    //just use the same one on the crash site. for this start point.
    level.player_rig_tunnel_crash = player_rig_tunnel_crash_teleport;
	level.player PlayerLinkToDelta( level.player_rig_tunnel_crash, "tag_player", 1, 0, 0, 0, 0 );
	thread train_crash_open_view();

	teleport_node = getstruct( "train_crash_script_node_damaged_side_player", "targetname" );
	teleport_node thread function_stack( ::anim_single_solo, level.player_rig_tunnel_crash, "train_crash" );
	teleport_node thread function_stack( ::flag_set, "train_crashed" );

	percent = 0.78;
	teleport_node delaythread( 0.05, ::anim_set_time, [ level.player_rig_tunnel_crash ], "train_crash", percent );
	
//    player_car = spawn_anim_model( "player_car" );
	node = getstruct( "train_crash_script_node_damaged_side", "targetname" );
    thread maps\westminster_tunnels::train_crash_mirrored_in_crash_sight( node, true );
    
	thread player_getup();

	time = GetAnimLength( player_rig_tunnel_crash_teleport getanim( "train_crash" ) );
	time *= ( 1 - percent );
	wait( time );
	
	level.player_rig_tunnel_crash Delete();
}

train_crash_open_view()
{
	wait( 0.5 );
	time = 5;
	level.player LerpViewAngleClamp( time, time * 0.5, time * 0.5, 45, 45, 60, 60 );
}

player_getup()
{
	flag_wait( "train_crashed" );

//    thread vision_set_fog_changes( "london_westminster_station", 3 );

    level.player AllowSprint( false );
//    level.player EnableWeapons();
    level.player UnLink();
    
    level.player thread play_sound_on_entity( "breathing_better" );
    level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player.ignoreme = false;
	level.player AllowJump( false );
//    thread autosave_by_name( "train_crash" );

	thread limp();

	flag_waitopen( "limp" );
	level.player AllowSprint( true );
	level.player EnableWeapons();
	level.player AllowJump( true );
}

//---------------------------------------------------------
// Train Crash Section
//---------------------------------------------------------
sandman_stumbles( ent )
{
    //get the bastard off the vehicle.
//    level.sas_leader get_the_bastard_off_the_vehicle();
    level.sas_leader clear_run_anim();
	level.sas_leader enable_cqbwalk();
	level.sas_leader set_force_color( "b" );
	level.sas_leader.ignoreAll = false;

    truck_crash_crawl = getstruct( "truck_crash_crawl", "targetname" );
    truck_crash_crawl thread anim_first_frame_solo( level.sas_leader, "stumble" );
//    flag_wait( "train_crash_tumble_stops" );
    truck_crash_crawl anim_single_solo( level.sas_leader, "stumble" );
    wait( 2 );
    flag_set( "start_train_traverse" );
}

//---------------------------------------------------------
// Station Section
//---------------------------------------------------------

west_station()
{
	thread poster_bink();
//    london_west_fx_volume = GetEnt( "london_west_fx_volume", "script_noteworthy" );
//	london_west_fx_volume activate_destructibles_in_volume();
//	london_west_fx_volume activate_interactives_in_volume();
//	london_west_fx_volume activate_exploders_in_volume();

	flag_wait( "start_train_traverse" );

	thread primary_light_flicker( "wreck_fire_1", 3 );
	thread primary_light_flicker( "wreck_fire_2", 5 );
	thread primary_light_flicker( "wreck_fire_3", 6 );
		
//	enemies = GetAIArray( "axis" );
//	foreach ( e in enemies )
//	{
//		e Delete();
//	}

	remove_all_guns();

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	trigger = GetEntArray( "time_to_move", "script_noteworthy" );
	array_thread( trigger, ::time_to_move );
	trigger = GetEntArray( "delete_enemies_in_volume", "targetname" );
	array_thread( trigger, ::delete_enemies_in_volume );
	trigger = GetEntArray( "grenade_throw", "targetname" );
	array_thread( trigger, ::grenade_throw_trigger );
	trigger = GetEntArray( "flag_set_when_volume_cleared", "targetname" );
	array_thread( trigger, ::flag_set_when_volume_cleared );	
	trigger = GetEntArray( "vending_trigger", "targetname" );
	array_thread( trigger, ::vending_trigger );	

	sas_leader_init();

	thread sas_movement();
	thread tube_announcer();
	thread melee_scene();
	thread sas_turnstile();
	thread crawling_badguy();
	thread station_dialogue();
	thread subway_think();
	thread tunnel_doors_think();
	thread clear_lower_station();
	thread clear_upper_station();
	thread clear_station_exit();
}

sas_leader_init()
{
	if ( IsDefined( level.sas_leader.init ) )
	{
		return;
	}
	level.sas_leader.init = true;

	if ( is_start_point_or_before( "west_station" ) )
	{
		level.sas_leader enable_cqbwalk();
	}
	else
	{
		level.sas_leader set_battlechatter( true );
	}

	level.sas_leader clear_run_anim();
	level.sas_leader set_force_color( "b" );
	level.sas_leader.ignoreAll = false;
	level.sas_leader.goalradius = 512;
	level.sas_leader enable_readystand();
	level.sas_leader ent_flag_init( "turnstile" );

	if ( is_after_start( "west_station" ) )
	{
		level.sas_leader ent_flag_set( "turnstile" );
	}

	// Switch heads nomask
//	level.sas_leader Detach( level.sas_leader.headmodel, "" );
//
//	head = "head_london_male_a";
//	level.sas_leader Attach( head, "", true );
//	level.sas_leader.headModel = head;
}



//---------------------------------------------------------
// Station Dialogue Section
//---------------------------------------------------------

station_dialogue()
{
	level endon( "dumb_sprinter" );

	flag_wait( "station_reinforcements" );
	dialogue_contact();

	flag_wait( "approaching_hallway" );	
	level.sas_leader dialogue_queue( "london_ldr_checkcorners2" );

	flag_wait( "watch_for_civilians" );
	level.sas_leader dialogue_queue( "london_ldr_watchforcivvies" );

	flag_wait( "fallingback_dialogue" );
	dialogue_backup();

	flag_wait( "cleared_lower_station" );

	// "Keep pushing!  They're falling back!"
	level.sas_leader dialogue_queue( "london_ldr_keeppushing" );

	flag_wait( "escalator1" );
	// "Up the stairs!"
	level.sas_leader dialogue_queue( "london_ldr_upthestairs" );

	flag_wait( "escalator_grenade_thrown" );
	dialogue_grenade();

	flag_wait( "started_station_exit" );
	dialogue_backup2();
}

dialogue_contact()
{
	// "Baseplate, we got contact at Westminster Station!"
	level.sas_leader dialogue_queue( "london_ldr_usingthetube" );
	flag_set( "got_contact" );
	// "Copy, Bravo Six.  Teams are en route.  ETA - ten minutes."
	radio_dialogue( "london_com_deployteams" );
	// "Tell 'em to double-time it now!"
	level.sas_leader dialogue_queue( "london_ldr_doubletime" );

	wait( 2 );
	// "C'mon, mate!  Let's give these bastards a proper British welcome!"
	level.sas_leader dialogue_queue( "london_ldr_britishwelcome" );
	level.sas_leader set_battlechatter( true );
}

dialogue_backup()
{
	// "Baseplate!  Where's that backup?!?!"
	level.sas_leader dialogue_queue( "london_ldr_wheresbackup" );
	// "Local police are arriving on scene.  Bravo Two will be on station in five minutes."
	radio_dialogue( "london_com_stillenroute" );
	// "BOLLOCKS!  Nothing takes FIVE MINUTES!"
	level.sas_leader dialogue_queue( "london_ldr_stoplarkin" );
}

dialogue_grenade()
{
	level endon( "dumb_sprinter" );

	// "Grenade!!"
	level.sas_leader dialogue_queue( "london_ldr_grenade2" );
	wait( 5 );
	// "Cheeky bastards!!"
	level.sas_leader dialogue_queue( "london_ldr_cheekybastards" );
}

dialogue_backup2()
{
	// "Baseplate!  Where's that backup?!?!"
	level.sas_leader dialogue_queue( "london_ldr_wheresbackup" );
	// "They're arriving on scene now, Bravo Six."
	thread radio_dialogue( "london_com_onscene" );
}


//---------------------------------------------------------
// Street Area
//---------------------------------------------------------
west_ending()
{
//	thread west_ending_WIP();
	array_spawn_function_noteworthy( "takedown_spawner", ::postspawn_takedown_ai );

	if ( is_start_point_or_before( "west_ending" ) )
	{
		thread wallcroft_exit_badass();	
		thread enemy_takedown_scene();
	}

	level.vehicleSpawnCallbackThread = ::vehicles_print_stopped_positions;

	west_ending_init();
	flag_wait( "player_exits_station" );

	level thread drone_speakers_thread( "civ" );
	level thread drone_speakers_thread( "cop" );

	dumb_sprinter();

	level.player blend_movespeedscale_percent( 75, 3 );

	thread radio_dialogue( "london_hp2_truckcoming" );
	spawn_vehicles_from_targetname_and_drive( "ending_police_car_1" );
	chopper = spawn_vehicle_from_targetname_and_drive( "ending_littlebird_1" );
	chopper SetMaxPitchRoll( 35, 50 );
	chopper SetYawSpeed( 90, 60 );

	battlechatter_off();
	thread street_traffic();

	flag_wait( "setup_blockade" );
	flag_wait( "ending_player_in_position" );
	truck_crash();

//	flag_wait( "truck_explodes" );
	flag_wait( "do_innocent" );
}

dumb_sprinter()
{
	if ( level.sas_leader.origin[ 0 ] < 1800 && level.sas_leader.origin[ 1 ] < 1300 )
	{
		return;
	}

	axis = GetAiArray( "axis" );
	foreach ( ai in axis )
	{
		if ( ai.origin[ 0 ] > 2400 )
		{
			ai Delete();
		}
	}	

	level notify( "dumb_sprinter" );
	level.sas_leader notify( "killanimscript" );

	node = GetNode( "sas_leader_takedown_hold", "targetname" );
	level.sas_leader ForceTeleport( node.origin, node.angles );
	level.sas_leader SetGoalPos( node.origin );
	level.sas_leader ClearEnemy();
	level.sas_leader notify( "killanimscript" );
	level.sas_leader notify( "move_interrupt" );
//	level.sas_leader OrientMode( "face default" );
	level.sas_leader ent_flag_set( "turnstile" );
	level.sas_leader enable_ai_color();
}

west_ending_init()
{
//	model = GetEnt( "gas_fx_model", "targetname" );
//	model Hide();

//	hide_dead_bodies();

//	thread init_player_explosion();

	array_spawn_function_noteworthy( "ending_manstackers", ::postspawn_man_stackers );
	array_spawn_function_noteworthy( "ending_police", ::postspawn_police );
	array_spawn_function_noteworthy( "ending_truck_inspector", ::secure_truck );
	array_spawn_function_noteworthy( "sas_blockade_talker", ::postspawn_sas_blockade_talk );
	array_spawn_function_noteworthy( "sas_blockade_guy", ::postspawn_sas_blockade_guy );
	array_spawn_function_noteworthy( "ending_police_driver", ::postspawn_ending_police_driver );
	array_spawn_function_noteworthy( "ending_police_car", ::postspawn_ending_police_car );
//	array_spawn_function_targetname( "ending_gassed", ::postspawn_injured_gassed );

	triggers = GetEntArray( "ending_street_drones", "targetname" );
	array_thread( triggers, ::trigger_dronespawn, ::drone_think );
	thread entity_cleanup();
}

testing_vehicles()
{
	// TESTING!
//	trigger = getent( "ending_police_cars_2", "script_noteworthy" );
	while ( 1 )
	{
		vehicles = spawn_vehicles_from_targetname_and_drive( "ending_chase_vehicles" );
		wait( 0.5 );

		while ( vehicles[ 0 ].veh_speed > 0 )
		{
			wait( 0.05 );
		}

		wait( 5 );
		if ( IsDefined( vehicles ) )
		{
			array_call( vehicles, ::Delete );	
		}
	}
}

// Remove Ents from other side of map.
entity_cleanup()
{
	if ( flag( "westminster_entity_cleanup" ) )
	{
		return;
	}

	flag_set( "westminster_entity_cleanup" );

	wait( 1 );

	ents = GetEntArray( "trigger_multiple", "code_classname" );
	ents = array_combine( ents, GetEntArray( "trigger_radius", "code_classname" ) );
	ents = array_combine( ents, GetSpawnerArray() );

	foreach( ent in ents )
	{
		// BattleChatter Triggers
	    if( IsDefined( ent.locationAliases ) )
		{
	        continue;
		}

		if ( ent.origin[ 0 ] > 50000 )
		{
			ent Delete();
		}
	}
}

clear_lower_station()
{
	level endon( "dumb_sprinter" );

	flag_wait( "cleared_lower_station" );
	activate_trigger_with_targetname( "cleared_lower_station" );
}

clear_upper_station()
{
	level endon( "dumb_sprinter" );

	flag_wait( "cleared_upper_station" );
	activate_trigger_with_targetname( "cleared_upper_station" );
}

clear_station_exit()
{
	level endon( "dumb_sprinter" );

	flag_wait( "cleared_station_exit" );
	activate_trigger_with_targetname( "cleared_station_exit" );
}

//fade_out_next_mission()
//{
//	flag_wait( "the_end" );	
//
//	time = 5;
//	fade_time = 3;
//
////	delayThread( time - 7, ::fade_out, 5.0 );
//	delayThread( time - fade_time, ::music_stop, fade_time );
//
//	delay_before_text = 3;
//	wait( time - delay_before_text );
//	time -= delay_before_text;
////	flag_set( "show_objective_failed" );
//
////	sound_fade_time = 8;
////	level.player StopShellShock();
//	//thread maps\_ambient::use_eq_settings( "level_fadeout", level.eq_mix_track );
//	//thread maps\_ambient::blend_to_eq_track( level.eq_mix_track, sound_fade_time );
//
//	wait( time );
////	SetSavedDvar( "compass", "1" );
////	SetSavedDvar( "hud_showStance", "1" );
//	nextmission();
//}

enemy_takedown_scene()
{
	flag_wait( "enemy_takedown" );

	battlechatter_off();
	level thread enemy_takedown_dialogue();

	struct = getstruct( "fake_kill_origin", "targetname" );

	foreach ( ai in level.takedown_ai )
	{
		if ( IsDefined( ai.script_parameters ) )
		{
			if ( ai.script_parameters == "keep_alive" )
			{
				continue;
			}
		}

		ai stop_magic_bullet_shield();

		if ( ai.team == "axis" )
		{
			ai delaycall( RandomFloatRange( 0, 1 ), ::Kill, struct.origin );
		}
	}

    flag_count_set( "take_down_finished", 6 );
    
	thread takedown_sequence( "takedown_anim_node4" );
	thread takedown_sequence( "takedown_anim_node3" );
	thread takedown_sequence( "takedown_anim_node1" );
}

waittill_close( ent, origin, dist )
{
	ent endon( "death" );
	dist *= dist;
	while ( DistanceSquared( ent.origin, origin ) > dist )
	{
		wait( 0.05 );
	}
}

wallcroft_exit_badass()
{
	flag_wait( "started_station_exit" );

	node = GetNode( "sas_leader_takedown_hold", "targetname" );

	level.sas_leader disable_pain();
	level.sas_leader.nododgemove = true;
	level.sas_leader enable_heat_behavior( true );

	waittill_close( level.sas_leader, node.origin, 200 );

	level.sas_leader enable_pain();
	level.sas_leader disable_heat_behavior();

	level.sas_leader RemoveAIEventListener( "gunshot" );
	level.sas_leader RemoveAIEventListener( "gunshot_teammate" );
	level.sas_leader.nododgemove = false;
	level.sas_leader.ignoreall = true;
	level.sas_leader.alertlevel = "noncombat";

	node = GetNode( "sas_cleared_station_exit", "targetname" );
	waittill_close( level.sas_leader, node.origin, 340 );

	flag_set( "wallcroft_at_stairs" );
}

enemy_takedown_dialogue()
{
	next_time = 0;

	wait( 2 );
	level.sas_leader dialogue_queue( "london_ldr_thefuzz" );

	flag_wait( "wallcroft_near_takedown" );
	level.sas_leader dialogue_queue( "london_ldr_nicetiming" );

	flag_wait( "wallcroft_at_stairs" );

	nags = [];
	nags[ 0 ] = [ "guy", "london_sas1_sir" ];
	nags[ 1 ] = [ "wallcroft", "london_ldr_letsgoburns" ];

	num = 0;

	while ( !flag( "player_exits_station" ) )
	{
		flag_wait( "near_takedown_scene" );

		if ( IsDefined( level.bravo_leader ) )
		{
			guy = level.bravo_leader;
		}
		else
		{
			guys = GetAiArray( "allies" );
			guys = array_remove( guys, level.sas_leader );
			guys = SortByDistance( guys, level.player.origin );
			guys = array_removeundefined( guys );
			guys = array_removedead_or_dying( guys );
			guy = guys[ 0 ];
		}

		if ( GetTime() > next_time )
		{
			if ( nags[ num ][ 0 ] == "guy" )
			{
				guy generic_dialogue_queue( nags[ num ][ 1 ] );
			}
			else
			{
				level.sas_leader dialogue_queue( nags[ num ][ 1 ] );
			}

			next_time = GetTime() + 5000 + RandomInt( 2000 );

			num++;
		}

		if ( num == nags.size )
		{
			num = 0;
		}

		wait( 0.05 );
	}
}


//---------------------------------------------------------
// Ending Recovery
//---------------------------------------------------------

big_ben_minute_think()
{
	minute_hand = GetEnt( "big_ben_minute", "targetname" );
	target_hand = GetEnt( minute_hand.target, "targetname" );
	target_angles = target_hand.angles;
	target_hand Delete();
	
	flag_wait( "the_end" );
	
	wait( 4.5 );
	minute_hand RotateTo( target_angles, 0.5, 0.0, 0.5 );
}
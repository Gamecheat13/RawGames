#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\innocent_code;

main()
{
	template_level( "innocent" );
	maps\createart\innocent_art::main();
	maps\innocent_precache::main();
	maps\innocent_fx::main();
	maps\innocent_anim::main();

	maps\london_west::pre_load();

	maps\_drone_civilian::init();

	init_level();

/#
	if ( GetDvarInt( "r_reflectionProbeGenerate" ) == 1 )
	{
		return;
	}
#/

	maps\innocent_starts::init_starts();

//	init_introscreen();
	maps\_load::main();

	init_level_post_load();
	maps\london_west::post_load();

	maps\innocent_starts::start_thread();
}

//---------------------------------------------------------
// Innocent Scene 
//---------------------------------------------------------
start_innocent()
{
}

innocent_scene()
{
	init_introscreen();
	delaythread( 0.25, ::innocent_scene_player_init );

	SetSavedDvar( "ui_hidemap", "1" );

	// Clear all objectives
	for ( i = 0; i < 16; i++ )
	{
		Objective_Delete( i );
	}

	level.vehicleSpawnCallbackThread = ::vehicle_spawned;
	thread cleanup_westminster();

	thread ambient_switch();
	thread wind_on_mic();

	if ( !GetDvarInt( "no_lines" ) == 1 )
	{
		wait( 2 );
		intro_lines();
	}

	level thread street_traffic();
	level thread pigeons();

	flag_init( "do_truck_explosion" );

	battlechatter_off();

//	thread vehicle_traffic();
//	init_civilians();
	innocent_intro();
}

init_introscreen()
{
	if ( GetDvar( "createfx" ) != "" )
	{
		return;
	}

	get_black_overlay();
	level.black_overlay FadeOverTime( 0.1 );
	level.black_overlay.alpha = 1;
}

cleanup_westminster()
{
	wait( 0.5 );
	vehicles = Vehicle_GetArray();
	foreach ( vehicle in vehicles )
	{
		if ( vehicle.origin[ 0 ] < 30000 )
		{
			vehicle Delete();
		}
	}

	guys = GetAiArray();
	foreach ( guy in guys )
	{
		if ( guy.origin[ 0 ] < 30000 )
		{
			if ( IsDefined( guy.magic_bullet_shield ) )
			{
				guy stop_magic_bullet_shield();
			}

			guy Delete();
		}
	}

	models = GetEntArray( "script_model", "code_classname" );
	foreach ( model in models )
	{
		if ( model.origin[ 0 ] > 30000 )
		{
			continue;
		}

		// Drones only
		if ( !IsDefined( model.headmodel ) )
		{
			continue;
		}

		model Delete();
	}
}

ambient_switch()
{
//	time = 0.5;
//	maps\_audio_mix_manager::MM_start_preset( "mute_all", time );
//	wait( time + 0.05 );

	set_ambient( "innocent", 3 );

	flag_set( "innocent_ambient_switched" );
	delaythread( 0.5, ::set_start_locations, "start_innocent" );
//	set_ambient( "innocent", 0.5 );

	thread maps\_audio_mix_manager::MM_start_preset( "default", 1 );
}

innocent_intro()
{
	thread vehicles();

	flag_wait( "innocent_ambient_switched" );

	vision_set_fog_changes( "innocent_bloom", 0 );

	innocent_scene_spawn_friendlies();
	thread camera_thread();

//	wait( 0.5 );
	wait( 0.5 );
	delaythread( 1.5, ::splashscreen_on );

//	wait( 1.5 );
	wait( 1 );

	thread vision_set_fog_changes( "innocent", 2 );

	delaythread( 0.5, ::flag_set, "start_the_scene" );
	wait( 1 );

	civilians();
	thread couple_walking();
	thread splashscreen_off();
	flag_set( "splashscreen_off" );

	thread intro_blur();	
	set_ambient( "innocent_camera", 1 );

	level.player FreezeControls( false );
	level.cam_huds = camera_hud();
}

intro_blur()
{
	sound_ent = Spawn( "script_origin", level.player GetEye() );

	time = 0.5;
	blurs = [ 0.5, 2.5, 0 ];
	lerp = [ 50, 55, 53, 55 ];

	SetBlur( 5, 0 );
	wait( time );

	foreach ( i, blur in blurs )
	{
		SetBlur( blur, time );
		level.player LerpFov( lerp[ i ], time * 0.75 );

		sound_ent StopLoopSound();

		if ( i % 2 == 0 )
		{
			sound_ent PlayLoopSound( "scn_videocamera_zoom_loop2" );
		}
		else
		{
			sound_ent PlayLoopSound( "scn_videocamera_zoom_loop" );
		}

		wait( time );
	}

	sound_ent Delete();
}

vehicles()
{
	thread cop_car();
	spawn_vehicle_from_targetname_and_drive( "initial_cab" );

	thread vehicle_feeder_traffic();
	flag_wait( "start_the_scene" );

	wait( 6 );
	spawn_vehicle_from_targetname_and_drive( "side_street_coupe" );
}

cop_car()
{
	wait( 3 );
	car = spawn_vehicle_from_targetname_and_drive( "innocent_police_car" );
	car Vehicle_TurnEngineOff();
	car PlaySound( "scn_london_police_car_final_away" );

	tag_origin = spawn_tag_origin();
	tag_origin LinkTo( car, "tag_origin", ( -22, 0, 66 ), ( 0, 0, 0 ) );

	PlayFXOnTag( getfx( "light_blink_london_police_car" ), tag_origin, "tag_origin" );

	car waittill( "death" );
	tag_origin Delete();
}

innocent_scene_player_init()
{
	level.player FreezeControls( true );
	level.player TakeAllWeapons();
	level.player EnableInvulnerability();

//	struct = GetStruct( "dad_scene_start_point", "targetname" );
//	level.player SetOrigin( struct.origin );
//	level.player SetPlayerAngles( struct.angles );
	level.player AllowCrouch( false );
	level.player AllowSprint( false );
	level.player AllowProne( false );
	level.player AllowJump( false );
	level.player SetCanRadiusDamage( false );

	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "actionSlotsHide", "1" );

	thread player_speed();
}

//innocent_camera_intro()
//{
//	view_controller_parent = Spawn( "script_model", level.player.origin );
//	view_controller_parent SetModel( "tag_origin" );
//	view_controller_parent.angles = level.player.angles;
//	view_controller = get_player_view_controller( view_controller_parent, "tag_origin", ( 0, 0, 60 ), "player_view_controller" );
//
//	london_eye = getstruct( "london_eye", "targetname" );
//	dir = VectorNormalize( london_eye.origin - level.player GetEye() );
//	origin = level.player.origin + ( dir * 500 );
//
//	view_controller.target_ent = Spawn( "script_origin", origin );
//	view_controller SnapToTargetEntity( view_controller.target_ent );
//
//	view_rig = uav_rig_controller( view_controller, "player_view_controller_shakeycam" );
//
//	level.player PlayerLinkToDelta( view_controller, "tag_player", 1, 0, 0, 0, 0, true );
//	view_rig UseBy( level.player );
//	level.player DisableTurretDismount();
//
//	view_cone_clamp( 2, 30, 30, 30, 30 );
//
//	view_controller innocent_camera_track( level.wife, 5 );
//	return view_rig;
//}

innocent_scene_spawn_friendlies()
{
	level.wife = spawn_targetname( "wife" );
	level.wife.animname = "wife";
	level.wife.name = "";
	level.wife.noragdoll = true;
	level.wife SetCanRadiusDamage( false );

	level.daughter = spawn_targetname( "daughter" );
	level.daughter.animname = "daughter";
	level.daughter.name = "";
	level.daughter SetCanRadiusDamage( false );

	level.wife thread wife_thread();
	level.wife thread disconnectpaths_thread( "wife_disconnector" );
	level.daughter thread disconnectpaths_thread( "daughter_disconnector" );
	level.player thread disconnectpaths_thread( "player_disconnector" );
}

disconnectpaths_thread( target_name )
{
	self endon( "death" );
	ent = GetEnt( target_name, "targetname" );

	ent.origin = self.origin;
	ent DisconnectPaths();

	while ( 1 )
	{
		if ( DistanceSquared( ent.origin, self.origin ) > 20 )
		{
			ent.origin = self.origin;
			ent DisconnectPaths();
		}

		wait( 0.05 );
	}
}

wife_thread()
{
	struct = getstruct( "wife_spot", "targetname" );

	flag_wait( "start_the_scene" );

	guys = [ level.wife, level.daughter ];

	struct anim_single( guys, "anim_1" );
	struct nag_for_player( guys, "anim_1" );

	flag_set( "after_first_anim_stop" );
	thread last_cab();

	// So the vehicle birds do not move the player
	level.player SetContents( 0 );

	level.daughter thread daughter_thread();
	struct thread anim_single( guys, "anim_2" );
	level.dist_from_wife = 150;


	self.allowdeath = false;
//	self SetCanRadiusDamage( false );
	flag_wait( "do_truck_explosion" );
	thread innocent_scene_truck_explosion();

//	temp notify( "stop_loop" );

//	self.deathanim = getgenericanim( "death_explosion_stand_B_v2" );
//	self Kill();
//	self animMode( "nogravity" );

	temp = SpawnStruct();
	temp.origin = self.origin;
	temp.angles = VectorToAngles( level.end_truck.origin - self.origin );
	self.noragdoll = true;
//	self.a.nodeath = true;

	self anim_stopanimscripted();

	self.deathanim = getgenericanim( "death_explosion_stand_B_v2" );
//	temp thread anim_generic( self, "death_explosion_stand_B_v2" );

	level.wife_origin = level.wife.origin;
	wait( 0.5 );
	self Kill();
}

daughter_thread()
{
	self endon( "death" );

	prev_spot = self.origin;
	while ( 1 )
	{
//		angles = self GetTagAngles( "j_head" );
//		angles = self.angles;
		forward = VectorNormalize( self.origin - prev_spot );
		point = self.origin + ( forward * 60 );

		foreach ( pigeon in level.pigeons )
		{
			if ( DistanceSquared( pigeon.origin, point ) < 20 * 20 )
			{
				pigeon thread pigeon_fly();
			}
		}

		prev_spot = self.origin;
		wait( 0.05 );
	}
}

enemy_truck( wife )
{
	flag_wait( "after_first_anim_stop" );
	level.end_truck = spawn_vehicle_from_targetname_and_drive( "enemy_truck" );

	foreach ( rider in level.end_truck.riders )
	{
		rider.nododgemove = true;
		rider set_generic_run_anim( "unarmed_run" );
		rider disable_arrivals();
		rider disable_exits();
	}
}

last_cab()
{

	// Time from 2nd animation start to explosion is 16 seconds
	// time for last_cab to get in blast radius ~9 seconds
	wait( 16 - 9 );

	cab = spawn_vehicle_from_targetname_and_drive( "last_cab" );
	cab.no_destructible_animation = true;

	flag_wait( "truck_explodes" );

	cab DoDamage( 500, cab.origin );
	cab waittill( "reached_end_node" );
	cab destructible_force_explosion();
}

//wife_dialogue()
//{
//	daughter = level.daughter;
//
//	self dialogue_queue( "london_wif_recording" );
//	self dialogue_queue( "london_wif_hereweare" );
//
//	level.end_truck = spawn_vehicle_from_targetname_and_drive( "enemy_truck" );
//
//	self dialogue_queue( "london_wif_bigben" );
//
//	level waittill( "after_big_ben" );
//
//	daughter dialogue_queue( "london_dtr_lookoverhere" );
//	daughter dialogue_queue( "london_dtr_lookatme" );
//
//	self dialogue_queue( "london_wif_cantbelieve" );
//	self thread dialogue_queue( "london_wif_dontgofar" );
//	daughter delaythread( 1, ::dialogue_queue, "london_dtr_laugh" );
//	wait( 1.75 );
//
//	daughter dialogue_queue( "london_dtr_birds" );
//	wait( 0.5 );
//	daughter thread dialogue_queue( "london_dtr_laugh2" );
//	wait( 0.4 );
//	self dialogue_queue( "london_wif_thatsyour" );
//
//	delaythread( 1.7, ::flag_set, "do_truck_explosion" );
//	self dialogue_queue( "london_wif_fromyou" );
//}

truck_explosion_flag( wife )
{
	wait( 1.4 );
	flag_set( "do_truck_explosion" );
}

innocent_scene_truck_explosion()
{
//	exploders = get_exploder_array( "truck_bomb" );
//	foreach ( e in exploders )
//	{
//		e.v[ "origin" ] = level.end_truck.origin;
//	}
	
	level.end_truck thread play_sound_on_entity( "scn_innocent_truckgas_explode" );
	exploder( "truck_bomb" );
	level.end_truck SetModel( "vehicle_uk_delivery_truck_destroyed" );

	struct1 = getstruct( "scream_speaker1", "targetname" );
	struct2 = getstruct( "scream_speaker2", "targetname" );
	thread play_sound_in_space( "walla_innocent_scream_l", struct1.origin );
	thread Play_sound_in_space( "walla_innocent_scream_r", struct2.origin );

	flag_set( "truck_explodes" );

	set_ambient( "innocent_end", 0.5 );

	level.player vision_set_fog_changes( "innocent_explosion", 0.2 );
	EarthQuake( 0.8, 0.5, level.end_truck.origin, 2000 );

	thread camera_fall();
	thread blast_radius();

	thread delete_pigeons();

//	level.player vision_set_fog_changes( "london_ending", 10 );
	level.player delaythread( 1, ::vision_set_fog_changes, "innocent_post_explosion", 10 );

	wait( 5 );
	camera_cut();
}

blast_radius( origin )
{
	level.daughter_origin = level.daughter.origin;
	level.daughter Kill();

	truck = level.end_truck;

	origin = truck.origin + ( 0, 0, 32 );
	right = AnglesToRight( truck.angles + ( 0, 180, 0 ) );
	origin = origin + ( right * 64 );

	RadiusDamage( origin, 512, 300, 200, level.end_truck, "MOD_EXPLOSIVE" );

	wait( 0.05 );
//	runaway_civilians();




//	death_radius = 512 * 512;
//
//	data = level.civilians.ai_data;
//	data.ai_array = array_removeundefined( data.ai_array );
//	foreach ( ai in data.ai_array )
//	{
//		if ( DistanceSquared( ai.origin, origin ) < death_radius )
//		{
//			ai DoDamage
//		}
//	}
}

innocent_camera_track( ent, time )
{
	origin = ent.origin + ( 0, 0, 60 );
	self.target_ent MoveTo( origin, time, time * 0.5, time * 0.5 );
	wait( time );
}
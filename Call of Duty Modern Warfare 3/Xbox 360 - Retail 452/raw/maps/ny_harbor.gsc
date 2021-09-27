
/****************************************************

Level: NY Harbor
Moments: 
	5. Set Sub Ride - take a sdv to a Russian battleship
	6. Harbor Slava Battle - board the ship, storm the bridge, destroy the other slava, launch missile against the Slava we're on.
	7. NY Retaken - Escape on the Hind as missiles strike, American airstrike is called in,  America has regained control of NY Harbor.

****************************************************/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_gameevents;

#include maps\ny_harbor_code_sdv;
#include maps\ny_harbor_code_sub;
#include maps\ny_harbor_code_zodiac;
#include maps\ny_harbor_code_vo;

main()
{
	template_level("ny_harbor");
	// SDV ride
	flag_init( "npcs_spawned" );
	flag_init( "level_fade_done" );
	flag_init( "tunnel_anim_finished" );
	flag_init( "player_out_of_vent" );
	flag_init( "lead_sdv_reached_end" );
	flag_init( "player_sdv_moving" );
	flag_init( "entering_sdv_from_anim" );
	flag_init( "entering_water" );
	flag_init( "submine_planted" );
	flag_init( "submine_detonated" );
	flag_init( "get_onto_sub" );
	flag_init( "russian_sub_spawned" );
	flag_init ("russian_sub_event");
	flag_init( "detonate_sub" );
	flag_init( "done_watching_explosion" );
	flag_init("sub_breach_started");
	flag_init( "mine_plant_dialogue" );
	flag_init( "wait_for_player" );
	flag_init( "player_through_water" );
	flag_init( "vo_stop_mine_nag" );
	flag_init( "finished_head_turn_to_mine" );
	flag_init( "light_toggle_on_1" );
	flag_init( "vo_sdv_follow_nag" );
	flag_init( "player_mask_off" );

	// sub Battle
	flag_init( "vo_hatch_open" );
	flag_init( "hatch_player_using_ladder" );
	flag_init( "hatch_enemies_dead" );
	flag_init( "sandman_talking_on_deck" );
	flag_init( "barracks_exit_nag_vo" );
	
	//Needs review
	flag_init( "sub_control_room_sandman_at_control_panel" );  
	flag_init("door_opened_01");
	flag_init("door_peek_event");
	flag_init("ally_trigger_0");
	flag_init("kill_pointer");
	flag_init("ready_for_wave2");
	flag_init("start_reactor_gameplay");
	flag_init("ladder_done");
	flag_init("go_to_bridge");
	flag_init("sandman_surprise");
	flag_init("stop_peeker");
	flag_init("sm_stop_talking");
	flag_init ("stop_peeker3");
	flag_init ("stop_peeker2");
	flag_init("waver_stop");
	flag_init("start_end_scene");
	flag_init("vo_sub_interior_1");
	flag_init("vo_sub_interior_3");
	flag_init("vo_sub_interior_4");
	flag_init("vo_sub_interior_5");
	flag_init("vo_sub_interior_6");
	flag_init("vo_sandman_checkpointneptune");
	flag_init("vo_frag_out");
	flag_init("vo_go_downstairs");
	flag_init("vo_go_upstairs_mis1");
	flag_init( "vo_catwalk_surprise1" );
	flag_init( "vo_catwalk_surprise2" );
	flag_init( "vo_breach" );
	flag_init( "vo_overlord_dialogue" );
	flag_init( "vo_sub_exit" );
	flag_init("vo_frag_out_clear");
	flag_init("ready_for_player_slide");
	flag_init("trigger_grinch_ladder");
	flag_init("start_barracks_chaos");
	flag_init("reactor_left_nag");
	flag_init("mis1_watch_catwalk");
	flag_init("vo_enemies_in_mis1");
	flag_init("breach_done");
	flag_init("start_bridge_breach");
	flag_init("vo_bridge_is_done");
	flag_init ("ok_to_close_barracks_door");
	flag_init("sandman_note_1");
	flag_init("sandman_ready_for_t");
	flag_init("mis1_path_chosen");
	flag_init("set_objective_phase2");
	flag_init("clean_barracks");
	flag_init("ready_for_breach");
	flag_init("reactor_guys_in_position");
	flag_init( "sub_control_room_key_scene_ready" );
	flag_init( "player_at_controls" );
	flag_init( "sub_control_room_sandman_exit" );
	flag_init( "sandman_paired_kill_complete" );
	flag_init( "bridge_breach_all_enemies_dead" );
	flag_init( "vo_wait_at_door" );
	//flag_init("breach_started");
	
	// zodiac ride
	flag_init( "start_zodiac" );
	flag_init("start_opening_missile_doors");
	flag_init( "player_on_boat");
	flag_init( "player_in_sight_of_boarding" );
	flag_init( "no_more_physics_effects");
	flag_init("exit_missile_trigger");
	flag_init( "dvora_hit" );
	flag_init( "dvora_destroyed" );
	flag_init( "switch_objective_to_ch46" );
	flag_init( "finale_dialogue" );
	flag_init( "carrier_done" );
	flag_init ( "send_off_second_chinook" );
	flag_init("outside_above_water");
	flag_init("switch_chinook");
	flag_init("ally_zodiac_jumping");
	flag_init("ally_zodiac_landing");
	flag_init("ally_zodiac_point_of_no_return");
	flag_init ( "player_too_slow" );
	flag_init ( "player_off_path" );
	flag_init ( "player_going_too_slow" );
	flag_init ( "player_going_fast_enough" );
	flag_init ( "chinook_success" );
	
	//objectives
	flag_init( "obj_plantmine_given" );
	flag_init( "obj_plantmine_complete" );
	flag_init( "obj_capturesub_given" );
	flag_init( "obj_capturesub_complete" );
	flag_init( "obj_escape_given" );
	flag_init( "obj_escape_complete" );
	
	level.default_goalradius = 64;
	level.pipesDamage = false; //set pipe fx in sub interior to not do damage
	level.lead_sdv = getent( "lead_sdv", "targetname" );
	level.grinch_sdv = getent( "grinch_sdv", "targetname" );
	level.sdv02 = getent( "sdv02", "targetname" );
	level.sdv03 = getent( "sdv03", "targetname" );
	//level.sdv04 = getent( "sdv04", "targetname" );
	level.sdv06 = getent("sdv06", "targetname");
	level.other_sdv01 = getent("other_sdv01", "targetname");
	level.other_sdv02 = getent("other_sdv02", "targetname");
	level.player_sdv = getent( "sdv", "targetname" );
	level.player_sdv.use_realtime_lights = true;	// player is using realtime lights
	
	water_origin = getent( "water_origin", "targetname" );
	if ( isdefined( water_origin ) )
		level.water_z = water_origin.origin[2];
	else
		level.water_z = -360.0;
	level.underwater_z = level.water_z - 80;
	level.cull_dist = GetCullDist();
	
//	ge_CreateEventManager( "fx", [2048, 2048] /* fxelements, trailelements*/, ["ambientsurface", "ambientunderwater", "always"] );
//	ge_AddAlways( "fx", [512,0], 100 /* priority */, "always" );	// this one will be our reserve for the combat
//	ge_AddAlways( "fx", [512,0], 100 /* priority */, "always" );	// this one will be our reserve for our always effects
//	ge_InitDebugging();

	init_sdv_path();
	//flashlight_init();


	maps\ny_harbor_precache::main();
	maps\ny_harbor_anim::main();
	maps\createart\ny_harbor_art::main();
	maps\ny_harbor_fx::main();
	maps\ny_harbor_aud::main();


	maps\ny_harbor_sdv_drive::main();

	maps\_underwater_debris::main();
	maps\ny_harbor_code_sdv::setup_viewdependent_fog_vision();
		
	PreCacheString( &"NY_HARBOR_INTROSCREEN_LINE1" );
	PreCacheString( &"NY_HARBOR_INTROSCREEN_LINE2" );
	PreCacheString( &"NY_HARBOR_INTROSCREEN_LINE3" );
	PreCacheString( &"NY_HARBOR_INTROSCREEN_LINE4" );
	PreCacheString( &"NY_HARBOR_INTROSCREEN_LINE5" );

	PreCacheString( &"NY_HARBOR_OBJ_CONTROL_ROOM" );
	PreCacheString( &"NY_HARBOR_OBJ_LAUNCH_MISSILES" );
	PreCacheString( &"NY_HARBOR_OBJ_FOLLOW_SANDMAN" );
	PreCacheString( &"NY_HARBOR_OBJ_ESCAPE" );
	
	PreCacheString( &"NY_HARBOR_OBJ_PLANT_MINE" );
	PreCacheString( &"NY_HARBOR_CAPTURE_SUB" );
	PreCacheString( &"NY_HARBOR_ESCAPE" );
	PreCacheString( &"NY_HARBOR_HINT_DRIVE_SDV" );
	PreCacheString( &"NY_HARBOR_HINT_USE_TO_ENTER" );
	PreCacheString( &"NY_HARBOR_HINT_USE_TO_BREACH" );
	PreCacheString( &"NY_HARBOR_ZODIAC_HINT" );
	PreCacheString( &"NY_HARBOR_HINT_DVORA_MINES" );
	PreCacheString( &"NY_HARBOR_DEMO_1" );
	PreCacheString( &"NY_HARBOR_CARRIER_FAIL" );
	
	PreCacheItem( "usp_no_knife" );
	PreCacheItem( "mp5_silencer_reflex" );
	PreCacheItem( "ninebang_grenade" );
	PreCacheItem( "tomahawk_missile" );
	
	PreCacheItem( "rpg" );
	PreCacheShellShock( "default" );
	
	precacheModel( "viewlegs_generic" );
	PrecacheShader( "scubamask_overlay_delta" );
	PreCacheModel( "ny_harbor_tunnel_grate" );
	PreCacheModel( "weapon_underwater_limpet_mine" );
	PreCacheModel( "weapon_underwater_limpet_mine_obj" );
	PreCacheModel( "vehicle_russian_oscar2_sub_breached" );
	PreCacheModel( "ny_harbor_tunnel_evacuation_sign_01_alt" );
	PreCacheModel( "vehicle_taxi_rooftop_ad_base_off" );
	PreCacheModel( "vehicle_taxi_rooftop_ad_2" );	
	PreCacheModel( "vehicle_russian_burya_corvette_destroyed_front" );
	PreCacheModel( "vehicle_russian_burya_corvette_destroyed_mid" );
	PreCacheModel( "vehicle_russian_burya_corvette_destroyed_rear" );
	PreCacheModel( "ny_harbor_sub_pressuredoor_rigged" );
	PreCacheModel( "vehicle_zodiac_viewmodel_harbor" );
	PreCacheModel( "weapon_frame_charge_iw5_c4" );
	PreCacheModel( "ny_harbor_missle_key_panel" );
	PreCacheModel( "ny_harbor_missle_key_box" );
	PreCacheModel( "ny_harbor_missle_key_panel_main_obj" );
	PreCacheModel( "ny_harbor_missle_key_panel_obj" );
	PreCacheModel( "ny_harbor_missle_key_box_obj" );
	PreCacheModel( "ny_harbor_sub_pressuredoor_bridge_destroyed_door" );
	PreCacheModel( "ny_harbor_sub_pressuredoor_bridge_destroyed" );
	PreCacheModel( "ny_harbor_sub_pressuredoor_bridge" );
	PreCacheModel( "axis" );	// for debugging
	PreCacheModel( "ny_harbor_dive_gear_mask" );
	PreCacheModel( "head_tank_a_pilot" );
	PreCacheModel( "head_tank_b_pilot" );
	PreCacheModel( "zodiac_head_roller" );
	PreCacheModel( "body_city_civ_male_a" );
	PreCacheModel( "com_fire_extinguisher_anim" );
	PrecacheShader( "lstick" );
	PrecacheShader( "rstick" );
	

	PreCacheRumble( "viewmodel_small" );
	PreCacheRumble( "viewmodel_large" );
	PreCacheRumble( "falling_land" );
	PreCacheRumble( "steady_rumble" );

	// starts
	add_start( "rendezvous_with_seals",::start_rendezvous_with_seals, "NY_HARBOR_OBJ_FOLLOW_SANDMAN",::rendezvous_with_seals );
	add_start( "plant_mine_on_sub",::start_plant_mine_on_sub, "NY_HARBOR_OBJ_PLANT_MINE",::plant_mine_on_sub );
	add_start( "capture_sub",::start_capture_sub, "NY_HARBOR_OBJ_CONTROL_ROOM",::capture_sub );
	add_start( "bridge_breach",::start_bridge_breach, "NY_HARBOR_OBJ_LAUNCH_MISSILES",::bridge_breach_setup );
	add_start( "escape_on_zodiacs",::start_escape_on_zodiacs, "NY_HARBOR_OBJ_ESCAPE",::escape_on_zodiacs );
	add_start( "exit_flight",::start_exit_flight, "NY_HARBOR_EXIT_FLIGHT",::exit_flight );

	
	maps\_load::main();
	maps\_zodiac_harbor_ai::main();
	vehicle_scripts\_zodiac_drive::zodiac_preLoad( undefined, "vehicle_zodiac_boat" );

	setup_hints();

	// set E3 dvar to 0
	SetDvarIfUninitialized( "demo_itiot", 0 );
	
// setup for flickering light in the sub
  array_thread( GetEntArray( "flickering_sub_light", "targetname" ), ::flickering_sub_light );


	// more setup
	thread setup_throttle_button();
	thread battlechatter_off( "allies" ); //turned on in barracks_open_door() and off during command breach
	thread battlechatter_off( "axis" );
	setsaveddvar( "compassmaxrange", 3500 );
	maps\_compass::setupMiniMap("compass_map_ny_harbor_under", "underwater_minimap_corner");
	thread maps\_ocean::setup_ocean();
	obj_setup();
	init_floating_bodies();
	thread ShowWater( 0 );	// prepped for sub breach
	thread SetupBobbingObjects();
	thread wait_to_sequence_missiles();
	level.sdv_player_arms = spawn_anim_model( "player_sdv_rig" );
	level.sdv_player_arms.animname = "player_sdv_rig";
	level.sdv_player_legs = spawn_anim_model( "player_sdv_legs" );
	level.sdv_player_legs.animname = "player_sdv_legs";
	level.escape_zodiac = getent( "escape_zodiac", "targetname" );
	level.escape_zodiac Hide();
	level.escape_zodiac_start = spawn ( "script_origin", ( 0, 0, 0 ) );
	level.escape_zodiac_start.origin = level.escape_zodiac.origin;
	level.escape_zodiac_start.angles = level.escape_zodiac.angles;
	
	level.players_boat = level.escape_zodiac;
	level.escape_zodiac.animname = "zodiac_player";
	level.escape_zodiac assign_animtree();
	
	level.ally_zodiac = getent( "allies_escape_zodiac", "targetname" );
	level.ally_boat = level.ally_zodiac;
	level.escape_zodiac2 = getent( "escape_zodiac2", "targetname" );

	
	//Create_parallel_sdv_path();	// if we change the russian path we can build the player's lock on path with this
	
	thread ny_harbor_exit_dof();
//	thread maps\ny_harbor_fx::ny_harbor_sub_character_ambient();
	thread maps\ny_harbor_fx::ny_harbor_enter_sub_shadowfix();

//include this to get better shadow resolution on enter zodiac moment	
	thread maps\ny_harbor_fx::ny_harbor_enter_zodiac_shadowfix();

//include this if we can aford better shadows for the exit ride.
//	thread ny_harbor_exit_shadow_fix(); 
	coll = getent( "blackshadow_tube", "targetname" );
	coll Hide();
	coll = getent( "diver_death_collision", "targetname");
	coll Hide();
	turrets = getentarray( "50cal_turret_technical", "targetname" );
	foreach (turret in turrets)
	{
		turret Hide();
	}
	array_thread( getEntArray( "rotating_radar", "targetname" ), ::rotating_radar );
}

setup_hints()
{
	// hints
	add_hint_string( "hint_sdv_drive", &"NY_HARBOR_HINT_DRIVE_SDV",::should_break_drive_sdv );
	add_hint_string( "hint_sdv_drive_2", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_2" );
	add_hint_string( "hint_sdv_drive_2_stick", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_2_STICK" );
	add_hint_string( "hint_sdv_drive_2_stick_l", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_2_STICK_L" );
	add_hint_string( "hint_sdv_drive_3", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_3" );
	add_hint_string( "hint_sdv_drive_3_stick", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_3_STICK" );
	add_hint_string( "hint_sdv_drive_3_stick_l", &"NY_HARBOR_PLATFORM_HINT_DRIVE_SDV_3_STICK_L" );
	add_hint_string( "hint_sdv_drive_2_1", &"NY_HARBOR_HINT_DRIVE_SDV_2_1" );
	add_hint_string( "hint_sdv_drive_3_1", &"NY_HARBOR_HINT_DRIVE_SDV_3_1" );
	add_hint_string( "hint_sdv_drive_2_2", &"NY_HARBOR_HINT_DRIVE_SDV_2_2" );
	add_hint_string( "hint_sdv_drive_3_2", &"NY_HARBOR_HINT_DRIVE_SDV_3_2" );
	add_hint_string( "hint_sdv_drive_2_3", &"NY_HARBOR_HINT_DRIVE_SDV_2_3" );
	add_hint_string( "hint_sdv_drive_3_3", &"NY_HARBOR_HINT_DRIVE_SDV_3_3" );
	add_hint_string("sub_mine_plant", &"SCRIPT_PLATFORM_HINT_PLANTEXPLOSIVES", ::sub_mine_planted );
	add_hint_string( "hint_zodiac", &"NY_HARBOR_PLATFORM_HINT_ZODIAC", ::should_break_drive_zodiac );
	add_hint_string( "hint_dvora_mines", &"NY_HARBOR_HINT_DVORA_MINES" );
}

Create_parallel_sdv_path()
{
	/#
	start = getvehiclenode("start_mine_chance", "script_noteworthy");
	end = getvehiclenode("end_mine_chance", "script_noteworthy");
	brush = 383;
	userid = 4;
	user = "tdesmarais";
	autoid = 700;
	delta = end.origin - start.origin;
	spacing = 600.0;	// every 50 ft
	len = Length(delta);
	delta = (spacing/len)*delta;
	numnodes = int(len/spacing);
	//offset = ( -2500, 360, -160 );
	offset = ( -2110, 276, -170 );	// ( -2350, 240, -190 );
	angles = VectorToAngles(delta);
	forward = anglestoforward(angles);
	right = anglestoright(angles);
	up = anglestoup(angles);
	prefab_offset = (0, -107, 0);
	origin = start.origin - prefab_offset;
	origin = origin + offset[0]*forward + offset[1]*right + offset[2]*up;
	fileprint_launcher_start_file();
	for (i=0; i<numnodes; i++)
	{
		autoid2 = autoid + 1;
		fileprint_launcher("entity " + brush + " " + user + " " + userid);
		fileprint_launcher("{");
		fileprint_launcher("\t\"angles\" \"0 166 0\"");
		fileprint_launcher("\t\"model\" \"vehicle_blackshadow_730\"");
		fileprint_launcher("\t\"spawnflags\" \"0\"");
		fileprint_launcher("\t\"classname\" \"info_vehicle_node\"");
		if (i > 0)
			fileprint_launcher("\t\"targetname\" \"auto" + autoid + "\"");
		else
			fileprint_launcher("\t\"targetname\" \"mine_lockon_path\"");
		if (i < (numnodes-1))
			fileprint_launcher("\t\"target\" \"auto" + autoid2 + "\"");
		fileprint_launcher("\t\"origin\" \"" + origin[0] + " " + origin[1] + " " + origin[2] + "\"");
		fileprint_launcher("}");
		brush++;
		userid++;
		autoid++;
		origin = origin + delta;
	}
	fileprint_launcher_end_file( "\\map_source\\temp_path.map", false );

/*
entity 34 tdesmarais 3
{
	"angles" "0 166 0"
	"model" "vehicle_blackshadow_730"
	"targetname" "plant_sub_mine_follow"
	"spawnflags" "0"
	"lookahead" ".5"
	"speed" "12"
	"origin" "-24925.0 -20472.0 -1668.0"
	"classname" "info_vehicle_node"
	"script_flag_set" "sub_done"
}
*/	
	#/
}

/****************************************************************************
    HINT WAIT FUNCTIONS
****************************************************************************/

should_break_drive_sdv()
{
	if ( isdefined( level.player_sdv ) && (isdefined( level.player_sdv.veh_speed )) && (level.player_sdv.veh_speed > 0) )
		return true;
	return false;
}

sub_mine_planted()
{
	if (flag("submine_planted"))
		return true;
	return false;
}

should_break_drive_zodiac()
{
	if ( level.escape_zodiac.veh_speed > 0 )
		return true;
	return false;
}
/****************************************************************************
    DEBUG CHECKPOINTS
****************************************************************************/

start_rendezvous_with_seals()
{
	aud_send_msg("start_rendezvous_with_seals");
	thread russian_sub_intro(); // separate thread for intro vo for timing
	thread russian_sub_setup();
	ShowWater( 0 );
	thread player_entering_water();
	flag_set( "entering_water" );
	wait 0.1;	// we need to wait, or the flag_wait("entering_sdv_from_anim") won't start until after the flag_set, which fails to get the entity passed in
	flag_set("entering_sdv_from_anim", level.player );
	level.player teleport_player(level.player_sdv);
	thread handle_sdv_ais();
	thread hide_sub_water();
	setsaveddvar("sm_sunenable",0);
	setsaveddvar("sm_spotlimit",3);
	SetTunnelCharLighting();
}

start_plant_mine_on_sub()
{
	level.start_at_watching_sub = true;
	aud_send_msg("start_plant_mine_on_sub");
	thread russian_sub_intro(); // separate thread for intro vo for timing
	thread russian_sub_setup();
	thread sub_missile_tubes_hide();
	thread hide_sub_water();
	ShowWater( 0 );
	flag_set( "entering_water" );
	thread player_entering_water( true );
	wait 0.1;	// we need to wait, or the flag_wait("entering_sdv_from_anim") won't start until after the flag_set, which fails to get the entity passed in
	flag_set("entering_sdv_from_anim", level.player );
	level.player teleport_player(level.player_sdv);
	wait 0.1;	// wait for the entering_sdv_from_anim flag to be reacted to.
	thread handle_sdv_ais( );
	level.sdv_sandman thread sdv_ai_think( level.lead_sdv );
	level.sdv_grinch thread sdv_ai_think( level.grinch_sdv );
	flag_set( "tunnel_exit" );
//	thread vo_wetsub_russian_sub();
	level.player_sdv thread maps\ny_harbor_fx::underwater_particulate_fx();
	level.player_sdv thread maps\ny_harbor_fx::underwater_cam_distortion_fx();
	SetUnderwaterCharLighting();
	setsaveddvar("sm_sunenable",0);
	setsaveddvar("sm_spotlimit",1);
}

start_capture_sub()
{
	flag_set( "sub_breach_finished" );
	level.sandman = create_ally("sandman_sub", "lonestar", "Sandman", "o", true);
	level thread sub_extra_spawn();
	aud_send_msg("start_capture_sub");
	flag_set( "obj_plantmine_given" );
	flag_set( "obj_plantmine_complete" );
	wait 0.1;
	flag_set( "player_mask_off" );
	flag_set( "obj_capturesub_given");
	ShowWater( 0 );
	wait 0.1;
	flag_set("get_onto_sub");
	aud_send_msg("get_onto_sub");
	thread sub_missile_tubes_hide();
	thread hide_sub_water();
	player_start = getent("onto_sub","targetname");
	level.player teleport_player( player_start );
	SetAbovewaterCharLighting();
	setsaveddvar("sm_spotlimit",0);
	vision_set_fog_changes("ny_harbor_sub_breach", 0);
	thread RockingSub();
	array_spawn_function_targetname( "sub_exterior_hind" , ::sub_exterior_helicopter_fire_turret );
	array_spawn_function_targetname( "sub_exterior_chinook", ::sub_exterior_chinook );
}

start_bridge_breach()
{
	level.sandman = create_ally("sandman_sub", "lonestar", "Sandman", "o", true);
	aud_send_msg("start_bridge_breach");
	thread sub_missile_tubes_hide();
	thread sub_missile_tubes_show();
	thread open_hatch_rear();
	player_start = getstruct("start_breach_player_loc","targetname");
	level.player teleport_player( player_start );
	thread vo_sub_interior_missile_room_2();
	thread sub_exit();
	//flag sets for objectives
	flag_set( "obj_plantmine_given" );
	flag_set( "obj_plantmine_complete" );
	flag_set( "obj_capturesub_given");
	flag_set( "player_surfaces");
	flag_set( "player_mask_off" );
	flag_set( "ready_for_player_slide");
	flag_set( "hatch_player_using_ladder");
	flag_set( "sub_objective_breach");
	flag_set( "vo_wait_at_door" );
	flag_set( "vo_breach" );
	flag_set( "objective_crumb_flag_1" );
	flag_set( "objective_crumb_flag_2" );
	//flag_set( "sub_control_room_player_to_controls" );
	
	player_speed_percent( 75 );
	//run his setup code then override
	setup_sandman();
	sandman_start = getstruct("start_breach_sandman_loc","targetname");
	level.sandman forceTeleport( sandman_start.origin, sandman_start.angles );	
	thread RockingSub();
	vision_set_fog_changes("ny_harbor_sub_4", 0);
	setsaveddvar("sm_sunenable",0);
	setsaveddvar("sm_spotlimit",2);
	
	thread setup_music_before_door_breach();
}

start_escape_on_zodiacs()
{
	level.sandman = create_ally("sandman_sub", "lonestar", "Sandman", "o");
	start_point = getent("player_start_for_escape","targetname");
	level.player teleport_player( start_point );
	thread hide_sub_water();
	aud_send_msg("start_escape_on_zodiacs");
	flag_set( "obj_plantmine_given" );
	flag_set( "obj_plantmine_complete" );
	flag_set( "player_mask_off" );
	wait 0.1;
	flag_set( "obj_capturesub_given");
	flag_set( "obj_capturesub_complete");
	wait 0.1;
	flag_set( "start_zodiac" );
	
	//Objectives are now set after launching missiles in sub
	marker = getent ( "org_get_on_zodiac", "targetname" );
	objective_add( obj( "obj_escape" ), "active", &"NY_HARBOR_OBJ_ESCAPE", marker.origin );
	objective_current( obj( "obj_escape" ) );
	
	SetAbovewaterCharLighting();
	thread RockingSub();
	thread OnOutsideOfSub();
	setsaveddvar("sm_sunenable",1);
	setsaveddvar("sm_spotlimit",0);
	
	flag_set ( "sub_exit_player_going_out_hatch" );
	
	level.player disableoffhandweapons ();
	
}

start_exit_flight()
{
	aud_send_msg("start_exit_flight");
	level.debug_exit_flight = true;
	level.sandman = maps\ny_harbor::create_ally("sandman_sub", "lonestar", "Sandman", "o", true);
	flag_set( "obj_plantmine_given" );
	flag_set( "obj_plantmine_complete" );
	wait 0.1;
	flag_set( "obj_capturesub_given");
	flag_set( "obj_capturesub_complete");
	wait 0.1;
	flag_set( "get_on_zodiac" );
	flag_set( "spawn_chinook" );
	flag_set( "spawn_last_zubr" );
	flag_set( "switch_chinook" );
	thread zodiac_gameplay();
	wait 0.1;
	thread handle_rescue_seaknight();
	flag_set ( "start_exit_path_align" );
	flag_set ( "start_exit_path_earthquake" );
	flag_set("start_exit_path");
	
	SetAbovewaterCharLighting();
	level.player disableweapons();
	setsaveddvar("sm_sunenable",1);
	setsaveddvar("sm_spotlimit",0);
}

/****************************************************************************
    REAL GAME (SEQUENCED)
****************************************************************************/
rendezvous_with_seals()
{
	flag_clear("outside_above_water");
	thread maps\_autosave::_autosave_game_now( false );
	level.player FreezeControls( true );
	level.player_sdv thread maps\ny_harbor_fx::underwater_particulate_fx();
	level.player_sdv thread maps\ny_harbor_fx::underwater_cam_distortion_fx();
	thread sub_missile_tubes_hide();
	thread rotate_tunnel_fans();
	thread vo_wetsub_intro();
	thread flag_set_delayed( "level_fade_done", 17 );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 18, 2 );
	wait 7;
		
	lines = [];
	
	// Leviathan
	lines[ lines.size ] = &"NY_HARBOR_INTROSCREEN_LINE1";
	// Day 2 - 16:32:[{FAKE_INTRO_SECONDS:02}]
	lines[ lines.size ] = &"NY_HARBOR_INTROSCREEN_LINE2";
	// Sgt. Derek "Frost" Westbrook
	lines[ lines.size ] = &"NY_HARBOR_INTROSCREEN_LINE4";
	// Delta
	lines[ lines.size ] = &"NY_HARBOR_INTROSCREEN_LINE3";
	// New York Harbor
	lines[ lines.size ] = &"NY_HARBOR_INTROSCREEN_LINE5";

	maps\_introscreen::introscreen_feed_lines( lines );
	flag_wait( "tunnel_anim_finished" );
	level.player FreezeControls( false );
	flag_wait( "player_surfaces" );
}

plant_mine_on_sub()
{
	flag_clear("outside_above_water");
	thread player_surfaces( );
	array_spawn_function_targetname( "sub_exterior_hind" , ::sub_exterior_helicopter_fire_turret );
	array_spawn_function_targetname( "sub_exterior_chinook", ::sub_exterior_chinook );
	flag_wait("get_onto_sub");
}

capture_sub()
{
	flag_set("outside_above_water");
	ControlBobbingVolume( "1", true );	// start the first area bobbing
	thread ship2_squeeze_bob();
	setsaveddvar( "compassmaxrange", 1000 );
	maps\_compass::setupMiniMap("compass_map_ny_harbor_sub_outside", "sub_minimap_corner");
	flag_set( "obj_plantmine_complete" );
	thread sub_setup();
	blocker = getent( "sub_graph_blocker", "targetname" );
	blocker DisconnectPaths();
	thread vision_set_fog_changes( "ny_harbor_sub_breach", 0 );
	flag_wait("ladder_done");
	maps\_compass::setupMiniMap("compass_map_ny_harbor_sub", "sub_minimap_corner");
}

bridge_breach_setup()
{
	flag_clear("outside_above_water");
	thread bridge_breach();
	thread breach_sandman_take_keys();
	thread controls_scene();
	
	flag_wait( "obj_capturesub_complete");
}

escape_on_zodiacs()
{
	flag_set("outside_above_water");
	ControlBobbingVolume( "1", true );	// start the first area bobbing
	setsaveddvar( "compassmaxrange", 3500 );
	maps\_compass::setupMiniMap("compass_map_ny_harbor");
	thread wait_to_get_on_zodiac();
	SetDvar( "scr_zodiac_test", 1 ); // try to brute force hint text suppression
}

exit_flight()
{
	flag_set( "outside_above_water" );
	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	//end-top section
//	if ( start == "debug" )
//		return;
	if ( start == "rendezvous_with_seals" )
		return;
	if ( start == "plant_mine_on_sub" )
		return;
	if ( start == "capture_sub" )
		return;
	if ( start == "bridge_breach" )
		return;
	if ( start == "escape_on_zodiacs" )
		return;
	if ( start == "exit_flight" )
		return;
	AssertMsg( "Unhandled start point " + start );
}

ny_harbor_exit_dof()
{
	flag_wait("start_exit_path");
	thread vision_set_fog_changes("ny_harbor_escape",1);
	
	wait(4);
		
	//setup rack focus effect on end exit sequence
	start = level.dofDefault;
	
	ny_harbor_dof_exit_near_focus = [];
	ny_harbor_dof_exit_near_focus[ "nearStart" ] = 10;
	ny_harbor_dof_exit_near_focus[ "nearEnd" ] = 11;
	ny_harbor_dof_exit_near_focus[ "nearBlur" ] = 4.0;
	ny_harbor_dof_exit_near_focus[ "farStart" ] = 100;
	ny_harbor_dof_exit_near_focus[ "farEnd" ] = 700;
	ny_harbor_dof_exit_near_focus[ "farBlur" ] = .38;
	
	blend_dof( start, ny_harbor_dof_exit_near_focus, 1 );
//	iprintlnbold("set dof near");
	
	wait(2);
	
	ny_harbor_dof_exit_far_focus = [];
	ny_harbor_dof_exit_far_focus[ "nearStart" ] = 10;
	ny_harbor_dof_exit_far_focus[ "nearEnd" ] = 300;
	ny_harbor_dof_exit_far_focus[ "nearBlur" ] = 4;
	ny_harbor_dof_exit_far_focus[ "farStart" ] = 10000;
	ny_harbor_dof_exit_far_focus[ "farEnd" ] = 40000;
	ny_harbor_dof_exit_far_focus[ "farBlur" ] = .65;
	
	//leave dof on until end of shot.	
	blend_dof( ny_harbor_dof_exit_near_focus, ny_harbor_dof_exit_far_focus, 1.5 );

//	iprintlnbold("set dof far");

}

ny_harbor_exit_shadow_fix()
{
	flag_wait("start_exit_path");
	//push out sun shadow for exit ride, only use this is we can aford the x-tra rendering overhead.
	setsaveddvar("sm_sunsamplesizenear", 4);
}

/****************************************************************************
    OBJECTIVE FUNCTIONS
****************************************************************************/
obj_setup()
{
	thread obj_plant_mine_on_sub();
	thread obj_capture_sub();
	thread obj_escape_on_zodiac();
}

obj_plant_mine_on_sub()
{
	flag_wait( "obj_plantmine_given" );
	wait 0.05;	// wait to be sure the server is running before

	objective_add( obj( "obj_plantmine" ), "active", &"NY_HARBOR_OBJ_PLANT_MINE" );
	if ( !flag( "obj_plantmine_complete" ) )
	{
		while (!isdefined(level.sub_pilots))
			wait 0.05;
			
		obj_position = level.sdv_sandman;	// prefer to put on the pilot, since then fadeout will happen
		Objective_OnEntity( obj( "obj_plantmine" ), obj_position );
		objective_current( obj( "obj_plantmine" ) );
		flag_wait( "start_submarine02" );
		Objective_Position( obj( "obj_plantmine" ), ( 0, 0, 0 ) );
		flag_wait("sdvs_chase_sub");
		Objective_OnEntity( obj( "obj_plantmine" ), level.mine_sub_target );
	}

	flag_wait( "obj_plantmine_complete" );

	objective_complete( obj( "obj_plantmine" ) );
}

obj_capture_sub()
{
	flag_wait( "obj_capturesub_given" );
	wait 0.05;	// wait to be sure the server is running before

	objective_add( obj( "obj_capturesub" ), "active", &"NY_HARBOR_OBJ_CONTROL_ROOM" );
	objective_current( obj( "obj_capturesub" ) );
	flag_wait( "player_mask_off" );
	wait( 1 );
	Objective_OnEntity( obj( "obj_capturesub" ), level.sandman );
	
	flag_wait("ready_for_player_slide");
	obj_position = getstruct( "sub_objective_enter_sub", "targetname" );
	Objective_Position( obj( "obj_capturesub" ), obj_position.origin );
	objective_setpointertextoverride( obj( "obj_capturesub" ), &"NY_HARBOR_OBJ_POINTER_ENTER" );
	
	flag_wait ( "hatch_player_using_ladder" );
	obj_position = getstruct( "sub_objective_crumb_1", "targetname" );
	Objective_Position( obj( "obj_capturesub" ), obj_position.origin);
	objective_setpointertextoverride( obj( "obj_capturesub" ), "" );
	
	flag_wait( "objective_crumb_flag_1" );
	obj_position = getent( "sub_objective_missile_room", "targetname" );
	Objective_Position( obj( "obj_capturesub" ), obj_position.origin);

	flag_wait ("sub_objective_breach");
	obj_position = getstruct( "objective_crumb_2", "targetname" );
	Objective_Position( obj( "obj_capturesub" ), obj_position.origin);


	flag_wait ("objective_crumb_flag_2");
	obj_position = getstruct( "sub_objective_breach", "targetname" );
	Objective_Position( obj( "obj_capturesub" ), obj_position.origin);

	flag_wait("breach_started");
	Objective_Position( obj( "obj_capturesub" ), (0,0,0) );
	
	
	flag_wait( "sub_control_room_player_to_controls" );
	obj_position = getent("objective_bridge_1", "targetname");	
	objective_complete( obj( "obj_capturesub" ) );
	
	objective_add( obj( "obj_launch" ), "active", &"NY_HARBOR_OBJ_LAUNCH_MISSILES" );
	Objective_Position( obj( "obj_launch" ), obj_position.origin );
	objective_current( obj( "obj_launch" ) );
	
	flag_wait("player_at_controls");
	Objective_Position( obj( "obj_launch" ), (0,0,0) );
	
	flag_wait("vo_bridge_is_done");
	objective_complete( obj( "obj_launch" ) );
	
	obj_position = getstruct( "sub_objective_climb_ladder", "targetname" );
	objective_add( obj( "obj_escape" ), "active", &"NY_HARBOR_OBJ_ESCAPE", obj_position.origin );
	objective_current( obj( "obj_escape" ) );
	//Objective_Position( obj( "obj_escape" ), obj_position.origin );
	
	flag_wait( "sub_player_on_ladder" );
	obj_position = getstruct( "sub_objective_sub_exit", "targetname" );
	Objective_Position( obj( "obj_escape" ), obj_position.origin );
	
	flag_wait( "obj_capturesub_complete" );
}

obj_escape_on_zodiac()
{
	flag_wait ( "start_zodiac" );
	
	marker = getent ( "org_get_on_zodiac", "targetname" );
	//objective_add( obj( "obj_escape" ), "active", &"NY_HARBOR_OBJ_ESCAPE", marker.origin );
	//objective_current( obj( "obj_escape" ) );
	Objective_Position( obj( "obj_escape" ), marker.origin );
	
	flag_wait( "obj_escape_given" );
	wait 0.05;	// wait to be sure the server is running before
	
	//objective_delete ( obj( "obj_escape" ) );
	
	objective = level.truck;
	//objective_add( obj( "obj_escape" ), "active", &"NY_HARBOR_OBJ_ESCAPE" );
	Objective_OnEntity( obj( "obj_escape" ), objective );
	//objective_current( obj( "obj_escape" ) );

	flag_wait( "destroy_ally_zodiac" );
	Objective_OnEntity( obj( "obj_escape" ), level.exit_chinook );
//	objective = getent( "escape_target", "targetname" );
//	objective_add( obj( "obj_escape" ), "active", &"ESCAPE", objective.origin );
	flag_wait( "obj_escape_complete" );

	objective_complete( obj( "obj_escape" ) );
}

//flickering sub light via model swap
flickering_sub_light()
{
	self endon( "death" );
	// use scrolling texture and save some resources here.
	while ( 1 )
	{
		self SetModel( "light_wall_stairwell_on_blue" );
		wait( randomfloatrange( .05, .5 ) );
		self SetModel( "light_wall_stairwell" );
		wait( randomfloatrange( .05, .5 ) );
	}
}


create_ally( spawnername, animname, friendname, color, cqb )
{
	spawner = getent(spawnername, "script_noteworthy");
	spawner.count = 1;
	ally = spawner spawn_ai(true);
	ally.ignoreall = true;
	ally.animname = animname;
	ally.script_friendname = friendname;
	ally set_force_color( color );
	ally thread deletable_magic_bullet_shield( );
	if( isDefined( cqb ) )
	{
		ally enable_cqbwalk();
	}
	return ally;
}

/****************************************************************************
    UTILITY FUNCTIONS
****************************************************************************/

SetTunnelCharLighting()
{
	/#
//	setdvar("r_showMissingLightGrid","0");
	#/
	char_lighting_ref = getent("amb_tunnel","targetname");
	EnableOuterSpaceModelLighting(char_lighting_ref.origin, (0.05,0.15,0.22) );
}

SetUnderwaterCharLighting()
{
	/#
//	setdvar("r_showMissingLightGrid","0");
	#/
	char_lighting_ref = getent("amb_underwater","targetname");
	EnableOuterSpaceModelLighting(char_lighting_ref.origin, (0.06,0.13,0.26) );
}

SetAbovewaterCharLighting()
{
	/#
//	setdvar("r_showMissingLightGrid","0");
	#/
	char_lighting_ref = getent("amb_abovewater","targetname");
	//EnableOuterSpaceModelLighting(char_lighting_ref.origin, (.2,0.1921568,0.16336667) );
	EnableOuterSpaceModelLighting(char_lighting_ref.origin, (0.203922,0.247059,0.305882) );
	//new ambient value, waiting on fix for sunlight
	//EnableOuterSpaceModelLighting(char_lighting_ref.origin, (0.333333,0.360784,0.435294) );
}

SetInSubCharLighting()
{
	/#
//	setdvar("r_showMissingLightGrid","1");
	#/
	disableouterspacemodellighting();
}

SetupBobbingObjects()
{
	SetupBobbingShips();
	thread maps\ny_harbor_code_zodiac::setup_water_patch_triggers();
}

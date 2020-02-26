#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\pakistan_util;
#include maps\_glasses;
#include maps\_scene;
#include maps\_turret;
#include maps\_objectives;
#include maps\_dialog;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_anthem()
{
	/#
		IPrintLn( "Anthem" );
	#/
	
	level.harper = init_hero( "harper" );
		
	skipto_teleport( "skipto_anthem", array( level.harper ) );
}

main()
{	
	anthem_setup();
	wall_grapple_event();	
	id_menendez_event();
	menendez_surveillance_event();
	
	flag_wait( "tower_melee_complete" );
}

anthem_setup()
{
	screen_fade_out( 0 );
	
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	
	level.player set_ignoreme( true );
	level.player AllowMelee( false );
	level.harper set_ignoreme( true );
	level.harper set_ignoreall( true );
	level.harper change_movemode( "cqb_run" );
	level.salazar set_ignoreme( true );
	level.salazar set_ignoreall( true );
	
	vh_helipad_drone = spawn_vehicle_from_targetname( "rooftop_meeting_detection_drone" );
	vh_helipad_drone SetRotorSpeed( 0 );
	vh_helipad_drone veh_toggle_tread_fx( false );
	spawn_vehicle_from_targetname( "confirm_menendez_gaz" );
	
	setup_doors();
	setup_lights();
	
	level thread courtyard_sounds();
	level thread fake_spotlight_movement();
	level thread surveillance_spotlight_movement();
}

init_courtyard_ai()
{
	level.menendez = init_hero( "menendez" );
	ai_militia_leader = simple_spawn_single( "militia_leader" );
	ai_bodyguard1 = simple_spawn_single( "bodyguard1" );
	ai_bodyguard2 = simple_spawn_single( "bodyguard2" );
	
	level.menendez set_ignoreme( true );
	level.menendez set_ignoreall( true );
	ai_militia_leader set_ignoreme( true );
	ai_militia_leader set_ignoreall( true );
	ai_bodyguard1 set_ignoreme( true );
	ai_bodyguard1 set_ignoreall( true );
	ai_bodyguard2 set_ignoreme( true );
	ai_bodyguard2 set_ignoreall( true );
	
	a_courtyard_enemies = simple_spawn( "anthem_courtyard_soldiers" );
	a_helipad_enemies = simple_spawn( "anthem_helipad_soldiers" );
	a_enemies = ArrayCombine( a_courtyard_enemies, a_helipad_enemies, false, false );
	
	//Initialize stealth
	maps\_patrol::patrol_init();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	
	//Setup custom detection ranges to make it easier to stay hidden at closer ranges.
	custom_detect_range["prone"] = level._stealth.logic.detect_range["hidden"]["prone"] / 3.5;
	custom_detect_range["crouch"] = level._stealth.logic.detect_range[ "hidden" ][ "crouch" ] / 3.5;
	custom_detect_range["stand"] = level._stealth.logic.detect_range[ "hidden" ][ "stand" ] / 3.5;

	stealth_detect_ranges_set( custom_detect_range );
	
	level.player thread maps\_stealth_logic::stealth_ai();
	level.harper thread maps\_stealth_logic::stealth_ai();
	level.salazar thread maps\_stealth_logic::stealth_ai();
	level.menendez thread maps\_stealth_logic::stealth_ai();
	ai_militia_leader thread maps\_stealth_logic::stealth_ai();
	ai_bodyguard1 thread maps\_stealth_logic::stealth_ai();
	ai_bodyguard2 thread maps\_stealth_logic::stealth_ai();
	
	foreach( ai_enemy in a_enemies )
	{	
		if( IsDefined( ai_enemy.script_noteworthy ) )
		{
			ai_enemy thread maps\_patrol::patrol( ai_enemy.script_noteworthy );
		}
		
		ai_enemy thread maps\_stealth_logic::stealth_ai();
	}
	
	foreach( e_spawner in GetEntArray( "btr_guys", "script_noteworthy" ) )
	{
		e_spawner add_spawn_function( ::btr_scene_spawn_func );
	}
	
	run_scene_first_frame( "courtyard_btr_entrance" );
	run_scene_first_frame( "courtyard_train_box" );
	run_scene_first_frame( "courtyard_mechanics" );
	
	level thread run_scene( "courtyard_train_clipboard" );
	level thread run_scene( "courtyard_train_tire" );
	level thread run_scene( "courtyard_train_bolt" );
	level thread run_scene( "confirm_menendez_crew_idle" );
	
	level thread detection_fail_think();
}

stealth_init_spawn_func()
{
	if( IsDefined( self.script_noteworthy ) )
	{
		self thread maps\_patrol::patrol( self.script_noteworthy );
	}
		
	self thread maps\_stealth_logic::stealth_ai();
}

btr_scene_spawn_func()
{
	scene_wait( "courtyard_btr_entrance" );
	
	self thread maps\_stealth_logic::stealth_ai();
	self set_goalradius( 8 );
	
	if( self.script_int == 1 )
	{
		self waittill( "goal" );
		
		self Delete();
	}
	else
	{
		if( self.script_int == 3 )
		{
			//Stagger patrollers
			wait 2.0;
		}
		
		self thread maps\_patrol::patrol( "btr_patrol" + self.script_int );
	}
}

anthem_objectives()
{
	set_objective( level.OBJ_ID_MENENDEZ, GetStruct( "anthem_grapple_objective_marker", "targetname" ).origin, "shoot" );
	flag_wait( "anthem_grapple_complete" );
	
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "remove" );
	scene_wait( "anthem_grapple" );
	
	set_objective( level.OBJ_ID_MENENDEZ, GetStruct( "anthem_id_objective_marker", "targetname" ).origin, "breadcrumb" );
	trigger_wait( "anthem_id_menendez_start" );
	
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "remove" );
	flag_wait( "anthem_facial_recognition_complete" );
	
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_RECORD_MENENDEZ );
	flag_wait( "anthem_harper_start_tracking" );
	
	set_objective( level.OBJ_RECORD_MENENDEZ, level.harper, "follow" );
	flag_wait( "anthem_guard_tower_reached" );
	
	level thread autosave_by_name( "anthem_surveillance_complete" );
	set_objective( level.OBJ_RECORD_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
}

argus_enable()
{
	a_enemies = GetEntArray( "anthem_courtyard_soldiers_ai", "targetname" );
	ai_militia_leader = GetEnt( "militia_leader_ai", "targetname" );
	ai_bodyguard1 = GetEnt( "bodyguard1_ai", "targetname" );
	ai_bodyguard2 = GetEnt( "bodyguard2_ai", "targetname" );
	
	ClientNotify( "enable_argus" );
	
	foreach( ai_enemy in a_enemies )
	{	
		AddArgus( ai_enemy, "soldier" );
	}
	
	AddArgus( ai_militia_leader, "militia_leader" );
	AddArgus( ai_bodyguard1, "soldier" );
	AddArgus( ai_bodyguard2, "soldier" );
}

argus_disable()
{
	ClientNotify( "disable_argus" );
}

setup_doors()
{
	foreach( e_door in GetEntArray( "animated_door", "script_noteworthy" ) )
	{	
		GetEnt( e_door.target, "targetname" ) LinkTo( e_door, "door_hinge_jnt" );
	}
	
	run_scene_first_frame( "rooftop_entrance_open" );
	run_scene_first_frame( "rooftop_exit_open" );
	run_scene_first_frame( "trainyard_melee_door_door_open" );
	run_scene_first_frame( "claw_garage_defend_door_start" );
	run_scene_first_frame( "trainyard_melee_attack_door" );
}

setup_lights()
{
	foreach( m_spotlight in GetEntArray( "modern_spotlights", "targetname" ) )
	{
		PlayFXOnTag( GetFX( "courtyard_spotlight" ), m_spotlight, "tag_light" );
	}
}

wall_grapple_event()
{	
	has_player_fired_grapple_device = false;
	
	level.player thread take_and_giveback_weapons( "grapple_done" );
	level.player GiveWeapon( "rappelgun_sp" );
	
	//Wait for player to receive weapon
	wait 0.1;
	level.player SwitchToWeapon( "rappelgun_sp" );
	
	level thread screen_fade_in();
	level.harper thread say_dialog( "harp_place_is_buzzing_wit_0", 2.5 );
	level.player thread say_dialog( "sect_move_to_higher_groun_0", 6.0 );
	run_scene( "anthem_grapple_setup" );
	level thread run_scene( "anthem_grapple_idle" );
	level thread run_scene( "anthem_grapple_idle_body" );
	
	level.player DisableWeaponFire();
	level.player ShowViewModel();
	level.player EnableWeapons();
	level thread anthem_objectives();
	
	while( !has_player_fired_grapple_device )
	{
		level.player waittill_attack_button_pressed();
		
		if( level.player PlayerADS() == 1.0 && level.player get_dot_from_eye( GetStruct( "anthem_grapple_objective_marker", "targetname" ).origin ) >= Cos( 5 ) )
		{
			has_player_fired_grapple_device = true;
		}
		
		//Run once per frame
		wait 0.05;
	}
	
	grapple_rope();
	
	level.player TakeWeapon( "rappelgun_sp" );
	level.player notify( "grapple_done" );
	level.player EnableWeaponCycling();
	
	flag_set( "anthem_grapple_complete" );
	level.player DisableWeapons();
	level.player HideViewModel();
	level.player EnableWeaponFire();
	level.player SetLowReady( true );
	level thread grapple_drone_flyby();
	run_scene( "anthem_grapple" );
	
	level.player set_ignoreme( false );
}

grapple_rope_run( rope_id, grapple_origin )
{
	level.player EnableInvulnerability();
	
	v_player_offset = ( 0, -24, 0 );
	
	// link the rope to the player and the grapple point.
	RopeAddWorldAnchor( rope_id, 1, grapple_origin );
	RopeAddEntityAnchor( rope_id, 0, level.player, v_player_offset );
	
	const reanchor_at_dist_sq = 50 * 50;
	const delete_at_dist_sq = 32 * 32;
	
	// Update the position each frame until we're directly below
	do {
		wait_network_frame();
		dist_sq = Distance2DSquared( grapple_origin, level.player.origin );
	} while ( dist_sq > reanchor_at_dist_sq );
	
	v_anchor_pos = ( grapple_origin[0], grapple_origin[1], level.player.origin[2] );
	RopeAddWorldAnchor( rope_id, 0, v_anchor_pos );
	
	// Wait till we reach the top of the building.
	while ( DistanceSquared( grapple_origin, level.player.origin ) > delete_at_dist_sq )
	{
		wait_network_frame();
	}
	
	DeleteRope( rope_id );
	
	level.player DisableInvulnerability();
}

// Handles the grapple gun's rope.
//
grapple_rope()
{
	start = level.player GetWeaponMuzzlePoint();
	forward = level.player GetWeaponForwardDir();
	end = start + ( forward * 8000 );
	
	missile = MagicBullet( "rpg_grapple_anchor_sp", start, end, level.player );
	
	level thread init_courtyard_ai();
	
	s_grapple_point = GetStruct( "anthem_grapple_point" );
	
	len = distance( start, s_grapple_point.origin ) * 0.8;
	if ( len > 400 )
	{
		len = 400;
	}

	ropeid = CreateRope( start, ( 0, 0, 0 ), len, missile );
//	ropeid = CreateRope( start, end, len );
	RopeSetParam( ropeid, "width", 4 );
	
	missile waittill( "death" );
	
	level thread grapple_rope_run( ropeid, s_grapple_point.origin );
}

//Handles drone pathing and targeting for grapple event
//Self is the drone
grapple_drone_flyby()
{
	vh_drone = spawn_vehicle_from_targetname( "grapple_flyby_drone" );
	e_spotlight_target = GetEnt( "grapple_flyby_spotlight_target", "targetname" );
	e_salazar_spotlight_start = GetEnt( "grapple_salazar_spotlight_target", "targetname" );
	
	vh_drone play_fx( "drone_spotlight", vh_drone GetTagOrigin( "tag_flash" ), vh_drone GetTagAngles( "tag_flash" ), "kill_spotlight", true, "tag_flash" );
	e_spotlight_target LinkTo( vh_drone, "tag_origin" );
	vh_drone set_turret_target( e_spotlight_target, undefined, 0 );
	
	//Wait for player/Harper to reach the top of the roof before starting drone on path
	wait 9.0;
	
	vh_drone thread go_path( GetVehicleNode( "anthem_drone_flyby_path_enter", "targetname" ) );
	vh_drone waittill( "look_salazar" );
	
	vh_drone SetLookAtEnt( e_salazar_spotlight_start );
	vh_drone set_turret_target( e_salazar_spotlight_start, undefined, 0 );
	
	//Wait before drone exits
	wait 6.0;
	
	vh_drone ClearLookAtEnt();
	vh_drone clear_turret_target( 0 );
	vh_drone thread  go_path( GetVehicleNode( "grapple_drone_exit", "targetname" ) );
	scene_wait( "anthem_grapple" );
	
	vh_drone notify( "kill_spotlight" );
	vh_drone play_fx( "drone_spotlight_cheap", vh_drone GetTagOrigin( "tag_flash" ), vh_drone GetTagAngles( "tag_flash" ), undefined, true, "tag_flash" );
	
	//Wait for swap
	wait 0.05;
	
	level notify( "drone_spotlight_swapped" );
	vh_drone waittill( "delete" );
	
	vh_drone Delete();
}

ground_drone_landing()
{
	vh_drone = spawn_vehicle_from_targetname( "anthem_courtyard_drone_ground" );
	e_spotlight_target = GetEnt( "anthem_ground_drone_spotlight_target", "targetname" );
	
	vh_drone play_fx( "drone_spotlight_cheap", vh_drone GetTagOrigin( "tag_flash" ), vh_drone GetTagAngles( "tag_flash" ), "spotlight_off", true, "tag_flash" );
	vh_drone set_turret_target( e_spotlight_target, undefined, 0 );
	e_spotlight_target LinkTo( vh_drone, "tag_origin" );
	vh_drone thread go_path( GetVehicleNode( "anthem_drone_landing_start", "targetname" ) );
	vh_drone waittill( "start_landing" );
	
	vh_drone SetGoalYaw( 315 );
	
	//Wait to reach goal yaw
	wait 4.0;
	
	level thread run_scene( "courtyard_btr_entrance" );
	level thread run_scene( "courtyard_air_controller" );
	
	vh_drone SetNearGoalNotifyDist( 2 );
	vh_drone SetHoverParams( 0 );
	vh_drone ClearGoalYaw();
	vh_drone SetTargetYaw( 315 );
	vh_drone SetSpeedImmediate( 10 );
	vh_drone SetVehGoalPos( GetStruct( "anthem_drone_landing_end", "targetname" ).origin, true );
	
	//Wait before killing spotlight
	wait 3.0;
	
	vh_drone notify( "spotlight_off" );
	vh_drone waittill( "goal" );
	
	end_scene( "courtyard_air_controller" );
	vh_drone SetRotorSpeed( 0 );
	
	level thread confirm_menendez_gaz_driveaway();
	
	//Wait for rotor to spin down
	wait 10.0;
	
	vh_drone veh_toggle_tread_fx( false );
}

ambient_drone_start( n_drone )
{
	vh_drone = spawn_vehicle_from_targetname( "ambient_drone" + n_drone );
	e_drone_target = GetEnt( "ambient_drone_target" + n_drone, "targetname" );
	nd_start = GetVehicleNode( "ambient_drone_start" + n_drone, "targetname" );
	
	vh_drone play_fx( "drone_spotlight_cheap", vh_drone GetTagOrigin( "tag_flash" ), vh_drone GetTagAngles( "tag_flash" ), "spotlight_off", true, "tag_flash" );
	vh_drone set_turret_target( e_drone_target, undefined, 0 );
	e_drone_target LinkTo( vh_drone, "tag_origin" );
	vh_drone thread go_path( nd_start );
	vh_drone waittill( "delete" );
	
	vh_drone Delete();
}

id_menendez_event()
{	
	level thread anthem_vo();
	level thread autosave_by_name( "anthem_rooftop_reached" );
	level thread id_menendez_fail_think();
	level thread id_melee();
	scene_wait( "id_melee" );
	
	setmusicstate ("PAK_ANTHEM");
	
	level thread run_scene( "courtyard_train_box" );
	level thread run_scene( "courtyard_mechanics" );
	
	level thread take_train_car();
	
	level.player DisableWeaponCycling();
	str_previous_weapon = level.player GetCurrentWeapon();
	level.player GiveWeapon( "data_glove_sp" );
	
	//Wait to receive weapon
	wait 0.1;
	level.player SwitchToWeapon( "data_glove_sp" );
	
	//Wait before taking away weapon
	wait 1.5;
	level.player SwitchToWeapon( str_previous_weapon );
	level.player TakeWeapon( "data_glove_sp" );
	level.player EnableWeaponCycling();
	level thread argus_enable();
	
	level thread ground_drone_landing();
	
	level thread id_think( level.menendez, 60.0, 2.5, true );
	flag_wait( "anthem_facial_recognition_complete" );
	
	level thread drop_down_invulnerability_think();
	level thread menendez_crew_pathing();
	level notify( "id_complete" );
	surveillance_mark_menendez();
	level thread argus_disable();
	level thread autosave_by_name( "anthem_id_complete" );
}

take_train_car()
{
	scene_wait("courtyard_train_box");
	
	level thread ambient_drone_start( 1 );
	
	train_cars = getentarray("courtyard_train_cars", "targetname");
	script_car = getent("courtyard_cin_train", "targetname");
	engine = getent("courtyard_train_engine", "targetname");
	
	engine moveto((-20540, 39160, 515.5), 10, 0, 5);
	engine waittill("movedone");
	
	script_car linkto(engine);
	for(i = 0; i < train_cars.size; i++)
	{
		train_cars[i] linkto(engine);
	}
	engine MoveY(-6000, 30, 5, 0 );
	engine waittill("movedone");
	engine delete();
	script_car delete();
	for(i = 0; i < train_cars.size; i++)
	{
		train_cars[i] delete();
	}
}
	
id_melee()
{
	level endon( "melee_failed" );
	
	level thread id_melee_fail();
	level thread id_melee_approach( "id_melee_approach_harper", "id_melee_approach_idle_harper" );
	level thread id_melee_approach( "id_melee_approach_guard", "id_melee_approach_idle_guard" );
	level.harper thread say_dialog( "harp_lone_sentry_up_ahead_0" );
	screen_message_create( &"PAKISTAN_SHARED_MELEE_HINT" );
	
	while( !level.player IsTouching( GetEnt( "id_melee_trigger", "targetname" ) ) || !level.player MeleeButtonPressed() )
	{
		//Run once per frame
		wait 0.05;
	}
	
	level notify( "melee_succeeded" );
	
	screen_message_delete();
	run_scene( "id_melee" );
	level thread id_melee_success();
	
	//Pause before VO
	wait 1.0;
	
	flag_set( "anthem_harper_vo_id" );
}

id_melee_success()
{
	level.harper set_goal_node( GetNode( "id_harper_pos", "targetname" ) );
	run_scene( "id_melee_success" );
	level.harper waittill( "goal" );
	
	level.harper AllowedStances( "crouch" );
}

id_melee_fail()
{
	level endon( "melee_succeeded" );
	
	trigger_wait( "id_melee_fail_trigger" );
	
	level notify( "melee_failed" );
	
	end_scene( "id_melee_approach_idle_harper" );
	end_scene( "id_melee_approach_idle_guard" );
	
	//Delay before fail
	wait 1.0;
	
	mission_fail( &"PAKISTAN_SHARED_ANTHEM_ALERT_FAIL" );
}

id_melee_approach( str_anim, str_idle )
{
	run_scene( str_anim );
	
	if( IsAlive( GetEnt( "id_melee_guard_ai", "targetname" ) ) )
	{
		run_scene( str_idle );
	}
}

id_menendez_fail_think()
{
	level endon( "id_complete" );
	trigger_wait( "anthem_id_menendez_fail_trigger" );
	
	mission_fail( &"PAKISTAN_SHARED_FAIL_ID_MENENDEZ" );
}

confirm_menendez_gaz_driveaway()
{
	veh_gaz = GetEnt( "confirm_menendez_gaz", "targetname" );
	
	add_spawn_function_group( "confirm_menendez_soldiers", "targetname", ::stealth_init_spawn_func );
	a_guys = simple_spawn( "confirm_menendez_soldiers" );
	
	a_guys[0] thread gaz_load_and_delete( veh_gaz, "tag_driver" );
	//Stagger
	wait 0.5;
	a_guys[1] thread gaz_load_and_delete( veh_gaz, "tag_passenger" );
	//Stagger
	wait 0.5;
	a_guys[2] thread gaz_load_and_delete( veh_gaz, "tag_guy0" );
	//Stagger
	wait 0.5;
	a_guys[3] gaz_load_and_delete( veh_gaz, "tag_guy1" );
	
	veh_gaz thread go_path( GetVehicleNode( "confirm_menendez_gaz_path", "targetname" ) );
	
	AddArgus( level.menendez, "menendez" );
	flag_set( "id_ready" );
	veh_gaz waittill( "reached_end_node" );
	
	array_delete( a_guys );
	veh_gaz Delete();
}

gaz_load_and_delete( veh_gaz, str_tag )
{
	self run_to_vehicle_load( veh_gaz, false, str_tag );
	self Delete();
}

menendez_crew_pathing()
{	
	level.menendez run_scene( "confirm_menendez_crew" );
	level.menendez run_anim_to_idle( "menendez_path1", "menendez_path1_idle" );
	trigger_wait( "anthem_menendez_continue_trigger1" );
	
	level.menendez run_anim_to_idle( "menendez_path2", "menendez_path2_idle" );
	trigger_wait( "anthem_balcony_end_approach_trigger" );
	
	level.menendez run_scene( "menendez_path3" );
	level.menendez thread run_scene( "menendez_path3_idle" );
	
	//Hold idle
	wait 2.0;
	level.menendez thread run_scene( "menendez_path4" );
	
	//Wait before Harper stands as Menendez exits
	wait 4.0;
	flag_set( "anthem_harper_stand" );
	scene_wait( "menendez_path4" );
	
	run_scene_first_frame( "rooftop_meeting" );
}

menendez_surveillance_event()
{	
	level thread rooftop_meeting_scene_setup_think();
	level.harper thread surveillance_harper_pathing();
	
	level thread surveillance_think( level.menendez );
}

surveillance_mark_menendez()
{	
	level.menendez play_fx( "friendly_marker", level.menendez GetTagOrigin( "J_Head" ), undefined, "unmark", true, "J_Head" );
}

surveillance_harper_pathing()
{
	flag_wait( "anthem_harper_start_tracking" );
	
	flag_set( "anthem_harper_vo_surveillance" );
	level.harper AllowedStances( "stand", "crouch", "prone" );
	level.harper run_scene( "harper_path1" );
	flag_set( "anthem_harper_vo_interference" );
	level.harper run_anim_to_idle( "harper_path2", "harper_path2_idle" );
	level thread autosave_by_name( "anthem_surveillance_mid" );
	flag_wait( "anthem_harper_drop" );
	
	level.harper run_anim_to_idle( "harper_path2_crawl", "harper_path2_prone" );
	flag_wait( "anthem_harper_stand" );
	
	level thread guard_tower_melee();
	level.harper run_scene( "harper_path2_climb" );
	level thread run_scene( "rooftop_entrance_open" );
	level.harper run_anim_to_idle( "harper_path3", "harper_rooftop_door_idle" );
	flag_wait( "tower_melee_complete" );
	
	level thread run_scene( "rooftop_entrance_close" );
	level.harper run_anim_to_idle( "harper_rooftop_door_close", "harper_path3_idle" );
}

drop_down_invulnerability_think()
{
	trigger_wait( "drop_invuln_trigger" );
	
	level.player EnableInvulnerability();
	
	//Crunch stopper
	wait 0.5;
	
	level.player DisableInvulnerability();
}

guard_tower_melee()
{
	level endon( "melee_failed" );
	
	level thread guard_tower_melee_fail();
	level thread run_scene( "tower_melee_guard_idle" );
	trigger_wait( "tower_melee_prompt_trigger" );
	
	level thread autosave_by_name( "anthem_surveillance_done" );
	screen_message_create( &"PAKISTAN_SHARED_MELEE_HINT" );
	
	while( !level.player IsTouching( GetEnt( "tower_melee_trigger", "targetname" ) ) || !level.player MeleeButtonPressed() )
	{
		//Run once per frame
		wait 0.05;
	}
	
	level notify( "melee_succeeded" );
	
	screen_message_delete();
	run_scene( "tower_melee_kill" );
	level thread run_scene( "tower_melee_death_pose" );
	flag_set( "tower_melee_complete" );
}

guard_tower_melee_fail()
{
	level endon( "melee_succeeded" );
	
	trigger_wait( "tower_melee_fail_trigger" );
	
	level notify( "melee_failed" );
	
	end_scene( "tower_melee_guard_idle" );
	end_scene( "harper_rooftop_door_idle" );
	
	//Delay before fail
	wait 1.0;
	
	mission_fail( &"PAKISTAN_SHARED_ANTHEM_ALERT_FAIL" );
}

fake_spotlight_movement()
{
	e_spotlight = GetEnt( "fake_spotlight", "targetname" );
	e_target = Spawn( "script_origin", GetEnt( "fake_search_path1", "targetname" ).origin );
	
	e_spotlight play_fx( "big_spotlight_cheap", e_spotlight GetTagOrigin( "tag_flash" ), e_spotlight GetTagAngles( "tag_flash" ), "kill_spotlight", true, "tag_flash" );
	e_spotlight thread spotlight_search_path( GetEnt( "fake_search_path1", "targetname" ), 512, false, false, e_target );
}

surveillance_spotlight_movement()
{
	e_spotlight = GetEnt( "courtyard_spotlight", "targetname" );
	e_target = Spawn( "script_origin", GetEnt( "surveillance_search_path1", "targetname" ).origin );
	
	e_spotlight play_fx( "big_spotlight_cheap", e_spotlight GetTagOrigin( "tag_flash" ), e_spotlight GetTagAngles( "tag_flash" ), "kill_spotlight", true, "tag_flash" );
	
	e_spotlight thread spotlight_search_path( GetEnt( "surveillance_search_path1", "targetname" ), 384, false, false, e_target );
	level waittill( "drone_spotlight_swapped" );
	
	e_spotlight notify( "kill_spotlight" );
	e_spotlight play_fx( "big_spotlight", e_spotlight GetTagOrigin( "tag_flash" ), e_spotlight GetTagAngles( "tag_flash" ), "kill_spotlight", true, "tag_flash" );
	flag_wait( "anthem_facial_recognition_complete" );
	
	GetEnt( "spotlight_jump_down_wait", "targetname" ).target = undefined;
	e_spotlight waittill( "search_done" );
	
	e_spotlight notify( "stop_searching" );
	e_spotlight thread spotlight_search_path( GetEnt( "surveillance_search_path2", "targetname" ), 384, false, false, e_target );
	e_spotlight thread spotlight_dodge_fail_think();
	flag_wait( "spotlight_jump_down_enter" );
	
	//Delay before spotlight enters scene
	wait 2.5;
	
	e_spotlight notify( "stop_searching" );
	e_spotlight thread spotlight_search_path( GetEnt( "surveillance_search_path3", "targetname" ), 224, false, false, e_target );
	flag_wait( "menendez_path4_started" );
	
	e_spotlight notify( "stop_searching" );
	e_spotlight thread spotlight_search_path( GetEnt( "surveillance_search_path1", "targetname" ), 384, false, false, e_target );
	
	//Wait for spotlight to exit scene before stopping fail condition
	wait 2.0;
	
	e_spotlight notify( "stop_spotlight_fail" );
	flag_wait( "tower_melee_complete" );
	
	e_spotlight notify( "kill_spotlight" );
	e_spotlight play_fx( "big_spotlight_cheap", e_spotlight GetTagOrigin( "tag_flash" ), e_spotlight GetTagAngles( "tag_flash" ), "kill_spotlight", true, "tag_flash" );
}

spotlight_dodge_fail_think()
{
	self endon( "stop_spotlight_fail" );
	
	while( true )
	{
		v_spotlight_origin = BulletTrace( self GetTagOrigin( "tag_flash" ), ((AnglesToForward( self GetTagAngles( "tag_flash" ) ) * 10192 ) + self GetTagOrigin( "tag_flash" )), false, level.player )["position"];
		n_distance_from_spotlight = DistanceSquared( level.player.origin, v_spotlight_origin );
		e_spotlight_safe_trigger = GetEnt( "spotlight_safe_trigger", "targetname" );
		e_spotlight_prone_trigger = GetEnt( "spotlight_prone_trigger", "targetname" );
		
		if( n_distance_from_spotlight < (256 * 256) && !level.player IsTouching( e_spotlight_safe_trigger ) && !(level.player IsTouching( e_spotlight_prone_trigger ) && level.player GetStance() == "prone") )
		{	
			self set_turret_target( level.player, undefined, 0 );
			flag_set( "_stealth_alert" );
			
			//Delay before fail
			wait 1.0;
			
			mission_fail( &"PAKISTAN_SHARED_ANTHEM_ALERT_FAIL" );
		}
		
		//Update once per frame
		wait 0.05;
	}
}

rooftop_meeting_scene_setup_think()
{
	trigger_wait( "tower_melee_prompt_trigger" );
	
	level thread run_scene( "rooftop_meeting_soldiers_idle" );
	
	foreach( ai_soldier in GetEntArray( "anthem_helipad_soldiers_ai", "targetname" ) )
	{
		ai_soldier set_ignoreall( true );
	}
}

detection_fail_think()
{
	level endon( "courtyard_cleared" );
	flag_wait( "_stealth_alert" );
	flag_set( "_stealth_spotted" );
	
	//Delay before fail
	wait 5.0;
	
	GetAIArray( "axis" )[0] MagicGrenade( (level.player.origin + (0, 0, 128)), level.player.origin, 0.25 );
}

courtyard_sounds()
{
	//IPrintLnBold ("sounds threaded");
	train_yard = spawn ("script_origin" , (-12573, 34411, 649));
	train_yard playloopsound ( "amb_train_yard" );
	
	motor_pool = spawn ("script_origin" , (-20149, 39202, 1230));
	motor_pool playloopsound ( "amb_motor_pool" );
	
	flag_wait( "_stealth_spotted" );
	
	motor_pool stoploopsound (2);
	motor_pool playloopsound ("evt_fail_alarm" );
	
}

anthem_vo()
{
	flag_wait( "anthem_harper_vo_id" );
	
	level.harper say_dialog( "harp_we_need_to_identify_0" );
	flag_wait( "anthem_harper_vo_surveillance" );
	
	level.harper say_dialog( "harp_we_have_to_move_to_a_0" );
	flag_wait( "anthem_harper_vo_interference" );
	
	level.harper say_dialog( "harp_it_s_too_loud_up_her_0" );
}
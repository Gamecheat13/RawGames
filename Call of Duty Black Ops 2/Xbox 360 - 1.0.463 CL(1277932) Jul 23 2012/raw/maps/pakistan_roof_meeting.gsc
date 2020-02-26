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
skipto_roof_meeting()
{
	/#
		IPrintLn( "Roof Meeting" );
	#/
		
	level.harper = init_hero( "harper" );
	level.menendez = init_hero( "menendez" );
	level.defalco = init_hero( "defalco" );
	
	level.harper thread run_scene( "harper_path3_idle" );
	level.player SetLowReady( true );
	
	a_courtyard_enemies = simple_spawn( "anthem_courtyard_soldiers" );
	a_helipad_enemies = simple_spawn( "anthem_helipad_soldiers" );
	a_enemies = ArrayCombine( a_courtyard_enemies, a_helipad_enemies, false, false );
	vh_helipad_drone = spawn_vehicle_from_targetname( "rooftop_meeting_detection_drone" );
	vh_helipad_drone SetRotorSpeed( 0 );
	vh_helipad_drone veh_toggle_tread_fx( false );
	
	//Initialize stealth
	maps\_patrol::patrol_init();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	
	//Setup custom detection ranges to make it easier to stay hidden at closer ranges.
	custom_detect_range["prone"] = level._stealth.logic.detect_range["hidden"]["prone"] / 2.5;
	custom_detect_range["crouch"] = level._stealth.logic.detect_range[ "hidden" ][ "crouch" ] / 2.5;
	custom_detect_range["stand"] = level._stealth.logic.detect_range[ "hidden" ][ "stand" ] / 2.5;

	stealth_detect_ranges_set( custom_detect_range );
	
	level.player thread maps\_stealth_logic::stealth_ai();
	level.harper thread maps\_stealth_logic::stealth_ai();
	level.harper set_ignoreme( true );
	level.harper set_ignoreall( true );
	level.menendez set_ignoreme( true );
	level.menendez set_ignoreall( true );
	
	foreach( ai_enemy in a_enemies )
	{	
		if( IsDefined( ai_enemy.script_noteworthy ) )
		{
			ai_enemy thread maps\_patrol::patrol( ai_enemy.script_noteworthy );
		}
		
		ai_enemy thread maps\_stealth_logic::stealth_ai();
	}
	
	maps\pakistan_anthem::setup_doors();
	
	level thread run_scene( "rooftop_meeting_soldiers_idle" );
	
	foreach( ai_soldier in GetEntArray( "anthem_helipad_soldiers_ai", "targetname" ) )
	{
		ai_soldier set_ignoreall( true );
	}
	
	level thread run_scene( "courtyard_air_controller" );
	level thread run_scene( "courtyard_train_clipboard" );
	level thread run_scene( "courtyard_train_tire" );
	level thread run_scene( "courtyard_train_bolt" );
	level thread courtyard_sounds();
	
	level thread maps\pakistan_anthem::detection_fail_think();
	
	set_objective( level.OBJ_ID_MENENDEZ );
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_RECORD_MENENDEZ );
	set_objective( level.OBJ_RECORD_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
	
	wait 0.25;
	
	level.menendez play_fx( "friendly_marker", level.menendez GetTagOrigin( "J_Head" ), undefined, "unmark", true, "J_Head" );
	
	s_drone_target = GetStruct( "anthem_drone_landing_end", "targetname" );
	vh_drone = CodeSpawnVehicle( "veh_t6_drone_attack_copter", "anthem_courtyard_drone_ground", "drone_firescout", s_drone_target.origin, (0, 315, 0) );
	vehicle_init( vh_drone );
	vh_drone SetRotorSpeed( 0 );
	vh_drone veh_toggle_tread_fx( false );
	
	skipto_teleport( "skipto_roof_meeting", array( level.harper ) );
	
	level thread run_scene( "harper_path3_idle" );
	level thread surveillance_think( level.menendez );
}

skipto_underground()
{
	/#
		IPrintLn( "Underground" );
	#/
	
	//Initialize stealth
	maps\_patrol::patrol_init();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
		
	level.harper = init_hero( "harper" );
	level.menendez = init_hero( "menendez" );
	level.defalco = init_hero( "defalco" );
	level.harper thread maps\_stealth_logic::stealth_ai();
	level.player thread maps\_stealth_logic::stealth_ai();
	
	level.harper thread underground_harper_pathing();	
	
	maps\pakistan_anthem::setup_doors();
	
	run_scene_first_frame( "claw_garage_defend_door_start" );
	
	set_objective( level.OBJ_ID_MENENDEZ );
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_RECORD_MENENDEZ );
	set_objective( level.OBJ_RECORD_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
	level thread rooftop_meeting_objectives();
	level thread roof_meeting_vo();
	flag_set( "rooftop_meeting_defalco_vo_start" );
	flag_set( "rooftop_meeting_harper_hide" );
	flag_set( "harper_path4_hide_started" );
	level.harper notify( "goal" );
	flag_set( "rooftop_meeting_harper_pursue" );
	flag_set( "harper_jump_roll_done" );
	flag_set( "railyard_melee_ready" );
	flag_set( "railyard_melee_start" );
	flag_set( "trainyard_melee_finished" );
	flag_set( "railyard_drone_meeting_ready" );
	flag_set( "anthem_harper_vo_drone_meeting_drone" );
	flag_set( "trainyard_drone_meeting_started" );
	flag_set( "salazar_vo_claw_positioned" );
	
	SetSavedDvar( "player_waterSpeedScale", 1.0 );
	
	skipto_teleport( "skipto_underground", array( level.harper ) );
}

main()
{		
	rooftop_meeting_event();
	drone_meeting_event();
}

rooftop_meeting_objectives()
{
	flag_wait( "rooftop_meeting_harper_hide" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, level.harper, "follow" );
	flag_wait( "railyard_melee_ready" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ, GetStruct( "railyard_melee_objective_marker", "targetname" ).origin, "breadcrumb" );
	flag_wait( "railyard_melee_start" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
	flag_wait( "trainyard_melee_finished" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, level.harper, "follow" );
	flag_wait( "railyard_drone_meeting_ready" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ, GetStruct( "railyard_drone_meeting_obj_marker", "targetname" ).origin, "breadcrumb" );
	flag_wait( "railyard_harper_millibar_approach" );
	
	set_objective( level.OBJ_RECORD_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ, level.harper, "follow" );
	flag_wait( "railyard_player_millibar_approach" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ, GetStruct( "railyard_millibar_meeting_obj_marker", "targetname" ).origin, "breadcrumb" );
	flag_wait( "railyard_player_millibar_start" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
	flag_wait( "trainyard_elevator_escape_ready" );
	
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_ESCAPE, level.harper, "follow" );
	flag_wait( "claw_start_ready" );
	
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_CLEAR_RAILYARD );
}

rooftop_meeting_event()
{	
	level.defalco = init_hero( "defalco" );
	
	level thread rooftop_meeting_objectives();
	level thread roof_meeting_vo();
	level thread run_scene( "rooftop_meeting" );
	level.harper thread rooftop_meeting_harper_pathing();
	trigger_off( "railyard_melee_trigger", "targetname" );
	GetEnt( "trainyard_vision_trigger", "targetname" ) thread trainyard_vision_think();
	
	//HACK: Wait for defalco to walk out before launching facial recognition. Need notetrack to do this correctly.
	wait 15.0;
	
	flag_set( "rooftop_meeting_defalco_vo_start" );
	AddArgus( level.defalco, "defalco" );
	ClientNotify( "enable_argus" );
	level thread id_defalco();
	
	//TODO: C. Ayers: Change this client flag call to use a .gsh definition
	level.menendez SetClientFlag( 3 );
	
	flag_wait( "anthem_start_soldiers_exit" );
	
	level thread run_scene( "rooftop_meeting_soldiers_exit" );
	//HACK: Wait before starting drone takeoff for detection event
	wait 14.0;
	
	vh_drone = GetEnt( "anthem_courtyard_drone_ground", "targetname" );
	vh_drone thread detection_event_drone_pathing();
	
	//HACK: Wait before starting detection event
	wait 16.0;
	
	if( !flag( "roof_meeting_defalco_identified" ) )
	{
		level notify( "stop_defalco_id" );
		stop_id();
	}
	else
	{
		stop_surveillance();
	}
	
	ClientNotify( "disable_argus" );	
	
	//TODO: C. Ayers: Change this client flag call to use a .gsh definition
	level.menendez ClearClientFlag( 3 );
	
	flag_set( "rooftop_meeting_harper_hide" );
	level thread autosave_by_name( "rooftop_meeting_end" );
	flag_wait( "drone_detection_end" );
	
	flag_set( "rooftop_meeting_harper_pursue" );
}

rooftop_meeting_harper_pathing()
{
	level.harper change_movemode( "cqb_sprint" );
	flag_wait( "rooftop_meeting_harper_hide" );
	level thread run_scene( "rooftop_exit_open" );
	level.harper run_scene( "harper_path4" );
	flag_set( "anthem_harper_vo_take_cover" );
	level.harper thread run_anim_to_idle( "harper_path4_hide", "harper_path4_hide_idle" );
	flag_wait( "rooftop_meeting_harper_pursue" );
	
	//HACK: Scene system not handling the reach to this next anim correctly
	level.harper set_goalradius( 4 );
	end_scene( "harper_path4_hide_idle" );
	
	run_scene_first_frame( "enemy_jump_roll" );
	run_scene( "harper_path4_hide_exit" );
	level.harper thread run_scene( "harper_jump_roll" );
	level.harper waittill( "goal" );
	
	run_scene( "enemy_jump_roll" );
	level.harper thread run_scene( "rooftop_observation_harper_wait_idle" );
	flag_wait( "rooftop_meeting_harper_observe" );
	
	end_scene( "rooftop_observation_harper_wait_idle" );
	level.harper run_scene( "trainyard_melee_harper_cross_bridge" );
	level.harper run_anim_to_idle( "trainyard_melee_harper_approach", "trainyard_melee_harper_approach_idle" );
	flag_set( "railyard_melee_ready" );
	flag_wait( "trainyard_melee_finished" );
	
	level thread run_scene( "trainyard_melee_door_door_open" );
	level.harper run_anim_to_idle( "trainyard_melee_harper_door_open", "trainyard_melee_harper_door_idle" );
	flag_set( "anthem_harper_vo_drone_meeting_drone" );
	flag_wait( "railyard_drone_meeting_room_entered" );
	
	flag_set( "railyard_drone_meeting_ready" );
	level.harper run_scene( "trainyard_melee_harper_door_close" );
	level.harper run_anim_to_idle( "trainyard_drone_meeting_harper_approach", "trainyard_drone_meeting_harper_approach_idle" );
}

id_defalco()
{
	level endon( "stop_defalco_id" );
	
	stop_surveillance();
	level thread id_think( level.defalco, 60.0, 2.5, false );
	flag_wait( "anthem_facial_recognition_complete" );
	
	level.defalco play_fx( "friendly_marker", level.defalco GetTagOrigin( "J_Head" ), undefined, "unmark", true, "J_Head" );
	flag_set( "roof_meeting_defalco_identified" );
	level thread surveillance_think( level.menendez );
}

detection_event_drone_pathing()
{	
	level endon( "spotlight_detection" );
	
	s_takeoff_start = GetStruct( "rooftop_meeting_drone_takeoff_point", "targetname" );
	nd_flyby_start = GetVehicleNode( "rooftop_meeting_drone_flyby_point", "targetname" );
	e_takeoff_look_target = GetEnt( "drone_detection_search_target1", "targetname" );
	e_balcony_look_target = GetEnt( "drone_detection_balcony_search_path", "targetname" );
	
	level thread detection_tarp_blocker_think();
	self thread detection_spotlight_think();
	self SetRotorSpeed( 1 );
	
	//Wait for drone rotor to spin up to a point before starting tread fx
	wait 10.0;
	
	self veh_toggle_tread_fx( true );
	
	//Wait for drone rotor to finish spin up before taking off
	wait 7.0;
	
	self SetNearGoalNotifyDist( 2 );
	self SetHoverParams( 24 );
	self SetSpeedImmediate( 15 );
	self SetVehGoalPos( s_takeoff_start.origin, true );
	
	//Wait for take off before turning on the spotlight
	wait 1.0;
	
	self set_turret_target( e_takeoff_look_target, undefined, 0 );
	self play_fx( "drone_spotlight", self GetTagOrigin( "tag_flash" ), self GetTagAngles( "tag_flash" ), undefined, true, "tag_flash" );
	self waittill( "goal" );
	
	self SetSpeedImmediate( 25 );
	self ClearLookAtEnt();
	self clear_turret_target( 0 );
	self SetVehGoalPos( nd_flyby_start.origin, true );
	
	//Wait to reach goal position
	wait 6.0;
	
	self SetLookAtEnt( e_balcony_look_target );
	
	//Pause before starting spotlight search logic
	wait 2.0;
	
	self thread spotlight_search_path( e_balcony_look_target, 384, true, false );
	self waittill( "search_done" );

	self thread go_path( nd_flyby_start );
	self ResumeSpeed( 5 );
	self ClearLookAtEnt();
	self clear_turret_target( 0 );
	
	//Wait for drone to fly away before ending detection event
	wait 4.0;
	
	flag_set( "drone_detection_end" );
	self waittill( "delete" );
	
	self Delete();
	
	level notify( "detection_complete" );
}

detection_spotlight_think()
{	
	while( IsDefined( self ) )
	{
		v_drone_spotlight_trigger_origin = BulletTrace( self GetTagOrigin( "tag_flash" ), ((AnglesToForward( self GetTagAngles( "tag_flash" ) ) * 5096 ) + self GetTagOrigin( "tag_flash" )), false, level.player )["position"];
		n_distance_from_spotlight = DistanceSquared( level.player.origin, v_drone_spotlight_trigger_origin );
		
		if( ( n_distance_from_spotlight < (256 * 256) && BulletTracePassed( self GetTagOrigin( "tag_flash" ), level.player GetEye(), true, self, level.harper ) ) || flag( "drone_player_detected" ) )
		{	
			level notify( "spotlight_detection" );
			level thread detection_blocker_cleanup();
			self SetSpeedImmediate( 0 );
			self SetLookAtEnt( level.player );
			self enable_turret( 0 );
			self shoot_turret_at_target( level.player, 6.0, undefined, 0 );
			flag_set( "_stealth_alert" );
			
			//Delay before mission fail
			wait 3.0;
			
			mission_fail( &"PAKISTAN_SHARED_ANTHEM_ALERT_FAIL" );
		}
		
		//Update once per frame
		wait 0.05;
	}
}

detection_tarp_blocker_think()
{
	level endon( "spotlight_detection" );
	level endon( "detection_complete" );
	
	m_blocker = GetEnt( "drone_detection_tarp_blocker", "targetname" );
	
	while( true )
	{
		if( level.player IsTouching( GetEnt( "drone_detection_tarp_trigger", "targetname" ) ) )
		{
			m_blocker Solid();
		}
		else
		{
			m_blocker NotSolid();
		}
		
		//Run once per frame
		wait 0.05;
	}
}

detection_blocker_cleanup()
{
	foreach( m_blocker in GetEntArray( "drone_detection_blocker", "script_noteworthy" ) )
	{
		m_blocker Delete();
	}
}

courtyard_cleanup()
{
	end_scene( "courtyard_air_controller" );
	end_scene( "courtyard_train_clipboard" );
	end_scene( "courtyard_train_tire" );
	end_scene( "courtyard_train_bolt" );
	
	a_enemies = GetEntArray( "anthem_courtyard_soldiers_ai", "targetname" );
	
	foreach( ai_enemy in a_enemies )
	{
		ai_enemy Delete();
	}
	
	a_enemies = simple_spawn( "anthem_rearguard" );
	
	foreach( ai_enemy in a_enemies )
	{
		ai_enemy thread maps\_stealth_logic::stealth_ai();
	}
}

drone_meeting_event()
{	
	run_scene_first_frame( "trainyard_drone_meeting" );
	run_scene_first_frame( "trainyard_drone_meeting_gantry" );
	trigger_off( "train_interference_trigger", "script_noteworthy" );
	
	trigger_wait( "rooftop_melee_approach_trigger" );
	
	level thread run_scene( "trainyard_melee_tigr_idle" );
	level thread run_scene( "trainyard_melee_guards_idle" );
	level thread observation_gaz_convoy_start();
	level thread autosave_by_name( "observation_done" );
	level thread melee_cb_radio_audio();//kevin adding cb radio to melee targets
	flag_wait( "railyard_melee_ready" );
	
	GetEnt( "railyard_melee_trigger", "targetname" ) SetHintString( &"PAKISTAN_SHARED_PIPE_MELEE_INTERACT_TRIGGER_HINT" );
	trigger_on( "railyard_melee_trigger", "targetname" );
	trigger_wait( "railyard_melee_trigger" );
	
	flag_set( "railyard_melee_start" );
	trigger_off( "melee_drop_hurt_trigger", "targetname" );
	trigger_off( "melee_drop_hurt_trigger2", "targetname" );
	SetSavedDvar( "player_waterSpeedScale", 1.0 );
	level thread load_gump( "pakistan_2_gump_escape" );
	level thread run_scene( "trainyard_melee_attack_door" );
	run_scene( "trainyard_melee_attack" );
	level thread train_enter();
	flag_set( "trainyard_melee_finished" );
	flag_wait( "railyard_drone_meeting_room_entered" );
	
	level.menendez = init_hero( "menendez" );
	level.defalco = init_hero( "defalco" );
	
	level thread autosave_by_name( "drone_meeting_start" );
	level notify( "courtyard_cleared" );
	level.harper thread underground_harper_pathing();
	level thread run_scene( "trainyard_drone_meeting" );
	level thread run_scene( "trainyard_drone_meeting_gantry" );
	
	//Wait before starting train entrance
	wait 7.0;
	
	flag_set( "railyard_train_enter" );
	level thread surveillance_think( level.menendez );
	
	//Wait for train to finish entering the scene
	wait 23.0;
	
	stop_surveillance();
	flag_set( "salazar_vo_claw_positioned" );
	level thread maps\_glasses::play_bink_on_hud( "yemen_kill_pilot", false, false );
}

melee_attach_knife_player( e_player_body )
{
	level.player.m_knife = spawn_model( "t6_wpn_knife_melee", e_player_body GetTagOrigin( "tag_weapon1" ), e_player_body GetTagAngles( "tag_weapon1" ) );
	level.player.m_knife LinkTo( e_player_body, "tag_weapon1" );
}

melee_detach_knife_player( e_player_body )
{
	level.player.m_knife Delete();
}

melee_bloodfx_knife_player( e_player_body )
{
	PlayFXOnTag( GetFX( "melee_knife_blood_player" ), level.player.m_knife, "tag_knife_fx" );
}

melee_attach_knife_harper( ai_harper )
{
	level.harper.m_knife = spawn_model( "t6_wpn_knife_melee", ai_harper GetTagOrigin( "tag_weapon_right" ), ai_harper GetTagAngles( "tag_weapon_right" ) );
	level.harper.m_knife LinkTo( ai_harper, "tag_weapon_right" );
}

melee_detach_knife_harper( ai_harper )
{
	level.harper.m_knife Delete();
}

melee_bloodfx_knife_harper( ai_harper )
{
	PlayFXOnTag( GetFX( "melee_knife_blood_harper" ), level.harper.m_knife, "tag_knife_fx" );
}

drone_gantry_entry()
{
	m_drone_gantry = GetEnt( "drone_gantry", "targetname" );
	m_dead_drone = GetEnt( "dead_drone", "targetname" );
	
	m_dead_drone LinkTo( m_drone_gantry, "tag_drone_attach" );
	run_scene_first_frame( "trainyard_drone_meeting_gantry" );
}

melee_cb_radio_audio()
{
	cb_radio = GetEnt("trainyard_melee_guard1" , "targetname");
	cb_radio_sound = spawn( "script_origin" , cb_radio.origin );
	cb_radio_sound PlayLoopSound("amb_cb_radio_loop", 2);
	trigger_wait( "railyard_drone_meeting_trigger" );
	cb_radio_sound StopLoopSound(5);
	wait 1;
	cb_radio_sound Delete();
}

observation_gaz_convoy_start()
{
	veh_gaz1 = spawn_vehicle_from_targetname( "observation_gaz1" );
	veh_gaz2 = spawn_vehicle_from_targetname( "observation_gaz2" );
	veh_gaz3 = spawn_vehicle_from_targetname( "observation_gaz3" );
	nd_gaz_start1 = GetVehicleNode( "gaz_convoy_start1", "targetname" );
	nd_gaz_start2 = GetVehicleNode( "gaz_convoy_start2", "targetname" );
	nd_gaz_start3 = GetVehicleNode( "gaz_convoy_start3", "targetname" );
	flag_wait( "rooftop_meeting_convoy_start" );
	
	veh_gaz3 thread go_path( nd_gaz_start3 );
	veh_gaz3 thread observation_gaz_convoy_delete();
	
	//Delay second gaz start
	wait 0.05;
	veh_gaz2 thread go_path( nd_gaz_start2 );
	veh_gaz2 thread observation_gaz_convoy_delete();
	
	//Delay third gaz start
	wait 0.05;
	veh_gaz1 thread go_path( nd_gaz_start1 );
	veh_gaz1 thread observation_gaz_convoy_delete();
}

observation_gaz_convoy_delete()
{
	self waittill( "delete" );
	
	self Delete();
}

train_enter()
{
	m_train = GetEnt( "train_engine", "targetname" );
	v_final_position = m_train.origin;
	v_start_position = m_train.origin + (6144, 0, 0);
	
	foreach( m_attachment in GetEntArray( "train_engine", "target" ) )
	{
		m_attachment LinkTo( m_train, "tag_origin" );
	}
	
	m_train MoveTo( v_start_position, 0.05 );
	m_train Playloopsound ( "amb_train_idle_lp" );
	flag_wait( "railyard_train_enter" );
	
	m_train Playsound ( "evt_train_arrive");
	m_train MoveTo( v_final_position, 23.0, 0, 7.0 );
	
	//Wait to get close before enabling sound recording interference
	wait 15.0;
	
	trigger_on( "train_interference_trigger", "script_noteworthy" );
}

trainyard_vision_think()
{
	self waittill( "trigger" );
	self thread trigger_thread( level.player, ::turn_on_trainyard_vision, ::turn_off_trainyard_vision );
}

turn_on_trainyard_vision( ent, endon_string )
{
	maps\createart\pakistan_2_art::turn_on_trainyard_vision();
}

turn_off_trainyard_vision( ent )
{
	maps\createart\pakistan_2_art::turn_off_trainyard_vision();
	self thread trainyard_vision_think();
}

underground_main()
{
	clientnotify( "aS_on" );
	millibar_meeting_event();
	incendiary_grenade_event();
	
	//TODO: Not sure who put this in or what it's for
	wait 0.05;
}

millibar_meeting_event()
{
	
//	SetSavedDvar( "r_enableFlashlight", "1" );
	
	flag_set( "railyard_harper_millibar_approach" );
	flag_wait( "railyard_millibar_meeting_ready" );
	
	level thread run_scene( "trainyard_millibar_meeting_enemy_idle" );
	level thread run_scene( "trainyard_millibar_meeting_soldiers_idle" );
	
	//TUEY - Add Black Ops 1 Interrogation Escape music here
	setmusicstate("PAK_INT_ESCAPE_REFERENCE");
	
	trigger_wait( "railyard_millibar_meeting_trigger" );
	
	level thread millibar_toggle_think();
	
	level.player thread run_scene( "trainyard_millibar_meeting_player_approach", 0.5 );
	player_body = get_model_or_models_from_scene( "trainyard_millibar_meeting_player_approach", "player_body");
	player_body Attach("c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	//wait(1);
	
	
}

underground_harper_pathing()
{
	flag_wait( "railyard_harper_millibar_approach" );
	
	level.harper run_scene( "trainyard_drone_meeting_harper_exit" );
	flag_set( "railyard_millibar_meeting_ready" );
	level.harper run_scene( "trainyard_millibar_meeting_harper_approach");
	level.harper thread run_scene(	"trainyard_millibar_meeting_harper_idle" );
	flag_wait( "trainyard_elevator_escape_ready" );
	end_scene("trainyard_millibar_meeting_harper_idle");
	level thread run_scene_first_frame( "claw_garage_defend_soldiers_start" );
	//level.harper run_scene( "trainyard_escape_swim_harper" );
	level thread run_scene( "claw_garage_defend_harper_start" );
	level.harper waittill( "goal" );
	
	level thread run_scene( "claw_garage_defend_door_start" );
	level run_scene( "claw_garage_defend_soldiers_start" );
	flag_set( "claw_start_ready" );
}

incendiary_grenade_event()
{	
	level thread grenade_room_swap();
	level thread run_scene("trainyard_millibar_grenades_enemy_heroes");
	level thread run_scene("trainyard_millibar_grenades_enemies");
	level thread run_scene("trainyard_millibar_grenades_fire");
	level thread run_scene("trainyard_millibar_grenades_fire_grate");
	level thread run_scene( "trainyard_millibar_grenades" );
	flag_set( "millibar_vo_started" );
	run_scene("trainyard_harper_millibar_grenades");
	
	/*
	//TUEY - survey music
	setmusicstate ("PAK_SURVEY");
	*/
	
	level.player SetLowReady( false );
	level.player AllowMelee( true );
	level clientnotify("underground_fog_off");
	flag_set( "trainyard_elevator_escape_ready" );
	flag_wait( "claw_start_ready" );
	trigger_wait( "claw_start_trigger" );
	
	level thread harper_claw_defend_logic();
	level thread start_up_defending_guard_logics();
	flag_wait( "claw_start_vo_done" );
	
	screen_message_create( &"PAKISTAN_SHARED_CLAW_SWITCH_TO" );
	level.player waittill_weapon_switch_button_pressed();
	level notify ("defending_sequence_ends");
	screen_message_delete();
	clientnotify( "aS_off" );
	
	level thread claw1_startup_pip();
	
	level thread autosave_by_name( "grenades_complete" );
	level.player thread run_scene( "claw_start_player" );
	player_body = get_model_or_models_from_scene( "claw_start_player", "player_body");
	player_body Attach("c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	scene_wait("claw_start_player");
}

claw_player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	level.player ClearDamageIndicator();
	return 0;
}

grenade_room_swap()
{
	//wait(8);
	
	level waittill("trigger_grenade_room_change");
//	a_room_models_before = getentarray("gernade_room_before", "targetname");
//	a_room_models_after = getentarray("gernade_room_after", "targetname");
//	
//	room_offset_origin = getent("gernade_room_after_origin", "targetname");
//	room_before_origin = getent("gernade_room_before_origin", "targetname");
//	for(i = 0; i < a_room_models_before.size; i++)
//	{
//		a_room_models_before[i] hide();
//	}
//	
//	for(i = 0; i < a_room_models_after.size; i++)
//	{
//		a_room_models_after[i] linkto(room_offset_origin);
//	}
//	
//	room_offset_origin moveto(room_before_origin.origin, 0.05);
	level clientnotify("underground_mixer_light");
	
	level.player.overridePlayerDamage = ::claw_player_damage_override;
	level thread setup_guard_firing_into_water();
	
	level thread play_bullet_hitting_water_fx();
	level thread magic_bullet_hitting_water();
}

magic_bullet_hitting_water()
{
	level endon("kill_underground_grenade_scene");
	start_structs = getstructarray("underground_fake_fire_location", "targetname");
	for(i = 0; i < start_structs.size; i++)
	{
		start_structs[i] thread pick_firing_targets();
		
	}
}
pick_firing_targets()
{
	level endon("kill_underground_grenade_scene");
	
	target_structs = getstructarray("underground_fake_fire_target", "targetname");
	
	while(1)
	{
		index = RandomInt(target_structs.size);
		MagicBullet("vector_sp", self.origin, target_structs[index].origin);
		wait(RandomFloatRange(0.3, 0.6));
		     
	}
		
}


setup_guard_firing_into_water()
{
	wait(3);
	
	water_guard = simple_spawn_single("garage_utility_spawner");
	water_guard.targetname = "knife_guard";
	water_guard.animname = "knifed_guard";
	water_guard endon("death");
	water_guard_node = getnode("stairway_guy_shoot_at_harper", "targetname");
	water_guard forceteleport(water_guard_node.origin, water_guard_node.angles);
	water_guard SetGoalNode(water_guard_node);
	water_guard.fixednode = true;
	water_guard thread aim_at_target(level.harper);
	water_guard shoot_at_target_untill_dead(level.harper, "tag_body");
}

play_bullet_hitting_water_fx()
{
	
	level endon("kill_underground_grenade_scene");
	
	level thread bullet_escape();
	setmusicstate ("PAK_ESCAPE_ANTHEM");
	
	wait(7);
	water_height = 248;
	player_location = spawn("script_model", level.player.origin);
	player_location.origin = (level.player.origin[0], level.player.origin[1], 248);
	player_location SetModel("tag_origin");
	player_location.angles = (90, 0, 0);
	
	player_location RotateYaw(600, 60);
	
	wait_time = 0.1;
	player_damage_time = 0;
	
	while(1)
	{
		PlayFXOnTag(level._effect[ "underwater_bullet_fx" ],player_location, "tag_origin");
		player_location.origin = (level.player.origin[0], level.player.origin[1], 248);
		wait(wait_time);
		
//		player_damage_time += wait_time;
//		
//		if(player_damage_time == 0.5)
//		{
//			level.player DoDamage(8, player_location.origin);
//			player_damage_time = 0;
//		}
		
	}
}

bullet_escape()
{
	trigger_wait("underground_bullet_escape_trigger");

	level notify("kill_underground_grenade_scene");
	level.player.overridePlayerDamage = undefined;
	
	
}

harper_claw_defend_logic()
{
	harper_defend_node = getnode("harper_cover_node", "targetname");
	level.harper SetGoalNode(harper_defend_node);
	
}

start_up_defending_guard_logics()
{
	
	
	spawner = getent("defensive_sniper_1_spawner", "targetname");
	spawner thread reinforce_guard_event();
	
	spawner = getent("defensive_sniper_2_spawner", "targetname");
	spawner thread reinforce_guard_event();
	
	spawner = getent("defensive_heavy_1_spawner", "targetname");
	spawner thread reinforce_guard_event();
	
	spawner = getent("defensive_heavy_2_spawner", "targetname");
	spawner thread reinforce_guard_event();
	
	spawner = getent("defensive_rifle_1_spawner", "targetname");
	spawner thread reinforce_guard_event();
	
	level waittill("defending_sequence_ends");
	
	defending_guards = getentarray("defending_guard_clear", "script_noteworthy");
	wait(0.05);
	for(i = 0; i < defending_guards.size; i++)
	{
		defending_guards[i] delete();
	}
	
	
	
}
reinforce_guard_event()
{
	
	level endon("defending_sequence_ends");
	
	spawner_node = getnode(self.targetname + "_node", "targetname");
	
	guard = simple_spawn_single(self.targetname);
	guard.fixenode = true;
	guard.goalradius = 32;
	guard.script_noteworthy = "defending_guard_clear";
	guard SetGoalNode(spawner_node);
	
	
	while(1)
	{
		if(isalive(guard))
		{
			wait(RandomFloatRange(3, 5));
		}
		else
		{
			guard = simple_spawn_single(self.targetname);
			guard.fixenode = true;
			guard.goalradius = 32;
			guard SetGoalNode(spawner_node);
			guard.script_noteworthy = "defending_guard_clear";
		}
		
	}
	
}

claw1_startup_pip()
{
	//thread maps\_glasses::play_bink_on_hud( "claw_offline_temp", true, true );
	
	maps\pakistan_claw::claw1_spawn();
	
	e_extra_cam = maps\_glasses::get_extracam();
	e_extra_cam.origin = level.claw1 GetTagOrigin( "tag_eye" );
	e_extra_cam.angles = level.claw1 GetTagAngles( "tag_eye" );	
	e_extra_cam LinkTo( level.claw1, "tag_eye" );
	
	maps\_glasses::turn_on_extra_cam();
		
	level waittill( "claw1_startup_screen_faded" );
	
	maps\_glasses::turn_off_extra_cam();
	//thread maps\_glasses::stop_bink_on_hud();
}

millibar_toggle_think()
{
	level waittill("millibar_start");
	
	ceiling = getent("milibar_ceiling", "targetname");
	ceiling hide();
	
	level clientnotify( "millibar_on" );
	
	//Change to Millibar scene Music
	setmusicstate ("PAK_MILLIBAR");
	
	flag_set( "anthem_harper_vo_millibar_meeting_start" );
	level waittill("millibar_stop");
	
	level clientnotify( "millibar_off" );
	ceiling show();
}

courtyard_sounds()
{
	//IPrintLnBold ("sounds threaded");
	train_yard = spawn ("script_origin" , (-12573, 34411, 649));
	train_yard playloopsound ( "amb_train_yard" );
	
	motor_pool = spawn ("script_origin" , 	(-20312, 40531, 755));
	motor_pool playloopsound ( "amb_motor_pool" );
	
	//level waittill ( "XXXXXXX" );
	
	//motor_pool stoploopsound (2);	
}

roof_meeting_vo()
{
	level.harper say_dialog( "harp_menendez_has_stopped_0" );
	flag_wait( "rooftop_meeting_defalco_vo_start" );
	
	level.harper say_dialog( "harp_hey_hey_it_s_him_0" );
	level.player say_dialog( "sect_defalco_0", 0.5 );
	flag_wait( "rooftop_meeting_harper_hide" );
	
	level.harper say_dialog( "harp_drones_we_need_to_m_0", 3.0 );
	flag_wait( "harper_path4_hide_started" );
	level.harper waittill( "goal" );
	
	level.harper say_dialog( "harp_duck_in_here_0" );
	flag_wait( "rooftop_meeting_harper_pursue" );
	
	level.harper say_dialog( "harp_move_we_have_to_kee_0", 2.0 );
	flag_wait( "anthem_harper_vo_drone_meeting_drone" );
	
	level.harper say_dialog( "harp_they_re_bringing_in_0", 1.0 );
	flag_wait( "salazar_vo_claw_positioned" );
	
	level.player say_dialog( "sala_section_the_claws_0" );
	level.player say_dialog( "sect_we_re_not_done_yet_0", 0.5 );
	
	level.harper say_dialog( "harp_old_interrogation_ro_0", 1.0 );
	level.harper say_dialog( "harp_looks_like_we_got_to_0", 1.0 );
	flag_wait( "claw_garage_defend_harper_start_started" );
	
	level.player say_dialog( "sala_section_isi_forces_0" );
	level.player say_dialog( "sect_what_about_the_claws_0", 0.5 );
	level.player say_dialog( "sala_standing_by_one_on_0", 0.5 );
	level.player say_dialog( "sect_secure_us_a_vehicle_0", 0.5 );
	level.player say_dialog( "sect_we_are_leaving_0", 0.5 );
	level.harper say_dialog( "harp_shit_we_re_pinned_0", 6.0 );
	level.harper say_dialog( "harp_gonna_need_the_claws_0", 0.5 );
	flag_set( "claw_start_vo_done" );
}
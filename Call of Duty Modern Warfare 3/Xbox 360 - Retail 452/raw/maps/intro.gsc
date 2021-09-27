#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\intro_code;
#include maps\_shg_common;
#include maps\_audio;

#include maps\intro_obj;
#include maps\intro_utility;
#include maps\intro_maars;

main()
{
	template_level( "intro" );
	// constants

	
	//---- precache ----//
	PrecacheDigitalDistortCodeAssets();
	
	//player weapons
	PrecacheItem( "g36c_reflex" );
	PrecacheItem( "m4_grunt_eotech" );
	PrecacheItem( "mg36_grip" );
	
	//weapons/items
	PreCacheItem( "smoke_grenade_intro" );					//Price throws smoke into courtyard
	precacheItem( "cobra_seeker" );							//Courtyard helicopter attack
	PreCacheItem( "stinger_speedy" );						//Courtyard shoot down helicopters
	PreCacheItem( "mi28_turret_intro" );					//Escort helicopter
	PreCacheItem( "viper_tow_intro" );						//Building Slide UAV Run... missiles that you can see
	PreCacheItem( "stinger_speedy_intro" );					//Run
	
	//shaders
	PrecacheShader("black");								//intro fade
	PrecacheShader( "popmenu_bg" );
	
	//models
	PreCacheModel( "viewhands_player_yuri" );				//Intro Scene
	PreCacheModel( "viewlegs_generic" );					//Intro Scene
	PreCacheModel( "intro_props_gurney" );					//Intro Scene
	PreCacheModel( "vehicle_mi_28_destroyed" );				//Intro Scene
	PreCacheModel( "intro_forceps" );						//Intro Scene
	PreCacheModel( "intro_gauze" );							//Intro Scene
	PreCacheModel( "intro_props_wires_01" );				//Intro Scene
	PreCacheModel( "intro_props_wires_02" );				//Intro Scene
	PreCacheModel( "intro_props_wires_03" );				//Intro Scene
	PreCacheModel( "intro_ceiling_woodbeam_01" );			//Intro Scene
	PreCacheModel( "intro_ceiling_damage_med_01" );			//Intro Scene
	
	PreCacheModel( "intro_pillar_cover01" );				//Courtyard cover object
	
	PreCacheModel( "intro_props_front_gate" );				//Courtyard gate open
	
	PreCacheModel( "weapon_rappel_rope_long" );				//Escort Rappel rope
	
	PreCacheModel( "vehicle_80s_hatch1_brn_destructible" ); //Price Break and Rake
	
	PreCacheModel( "vehicle_ugv_robot" );					//MAARS control intro
	PreCacheModel( "intro_crate_sidewall01" );				//MAARS control intro
	PreCacheModel( "intro_rollingdoor_01" );				//MAARS control intro
	PreCacheModel( "intro_trapdoor_01" );					//MAARS control intro
	PreCacheModel( "paris_crowbar_01" );					//MAARS control intro
	PreCacheModel( "vehicle_mi-28_ugv_hitbox" );
	PreCacheModel( "vehicle_mi17_woodland_ugv_hitbox" );
	
	PreCacheModel( "foliage_intro_tree_01_destroyed" );		//RUN
	
	
	//strings
	PrecacheString( &"INTRO_INTROSCREEN_LINE1" );
	PrecacheString( &"INTRO_INTROSCREEN_LINE2" );
	PrecacheString( &"INTRO_INTROSCREEN_LINE3" );
	
	//misc
	PreCacheShellShock( "default" );
	PreCacheShellShock( "intro_opening" );
	PreCacheShellShock( "intro_injured" );
	PreCacheRumble( "artillery_rumble" );
	PreCacheRumble( "damage_light" );
	PreCacheRumble( "heavy_3s" );
	PreCacheRumble( "light_1s" );
	PreCacheRumble( "subtle_tank_rumble" );
	PreCacheRumble( "steady_rumble" );
	precacherumble( "light_3s" );
	precacherumble( "damage_heavy" );

	
	level.respawn_friendlies_force_vision_check = true;
	
	
	//set this dvar to see the gurney scene when running through launcher
	//setdvarifuninitialized( "prologue_select", 1 );
	
	//---- start points ----//
	if( getdvarint( "prologue_select" ) )
		add_start( "Intro", ::start_intro, undefined, ::intro );
		
	add_start( "Intro transition", ::start_intro_transition, undefined, ::intro_transition );
	add_start( "Courtyard", ::start_courtyard, undefined, ::courtyard );
	add_start( "Escort", ::start_escort, undefined, ::escort );
	add_start( "Regroup", ::start_regroup, undefined, ::regroup );
	add_start( "MAARS Shed", ::start_maars_shed, undefined, ::maars_shed );
	add_start( "MAARS Control", ::start_maars_control, undefined, ::maars_control );
	add_start( "Slide", ::start_slide, undefined, ::slide );
	
	//---- init flags ----//
	//Intro
	flag_init( "intro_complete" );
	flag_init( "intro_helicopter_landed_start_dialog" );
	flag_init( "intro_room_soap_to_wounded_idle" );
	flag_init( "intro_room_heli_crash_complete" );
	flag_init( "intro_dialog_shot_1" );
	flag_init( "intro_dialog_shot_2" );
	flag_init( "intro_dialog_shot_3" );
	flag_init( "intro_dialog_shot_4" );
	flag_init( "intro_dialog_shot_5" );
	flag_init( "intro_dialog_shot_6" );
	flag_init( "intro_dialog_shot_7" );
	flag_init( "intro_dialog_shot_8" );
	flag_init( "start_intro_transition_complete" );
	flag_init( "intro_stop_shake" );
	flag_init( "intro_transition_dialog_end" );
	flag_init( "intro_opening_movie_start" );
	flag_init( "intro_dialog_shot_8_complete" );
	
	//courtyard
	flag_init( "courtyard_dialog_balcony_start" );
	flag_init( "courtyard_drones_start" );
	flag_init( "courtyard_player_on_balcony" );
	flag_init( "courtyard_dialog_intro_start" );
	flag_init( "courtyard_dialog_intro_end" );
	flag_init( "courtyard_mi28_3_done_firing" );
	flag_init( "courtyard_helicopter_enemies_delete" );
	flag_init( "courtyard_start_scene" );
	flag_init( "courtyard_start_breach" );
	flag_init( "courtyard_doors_breach" );
	flag_init( "courtyard_combat_done" );
	flag_init( "courtyard_friendly_officer_in_pos" );
	flag_init( "courtyard_attack_helicopter_second_pass" );
	flag_init( "courtyard_price_back_inside" );
	
	//escort
	flag_init( "escort_smoke_out" );
	flag_init( "escort_player_help_soap" );
	flag_init( "escort_player_helping_soap" );
	//flag_init( "escort_help_soap_complete" );  set in radiant
	flag_init( "escort_help_soap_breachers_dead" );
	flag_init( "escort_lobby_combat_complete" );
	flag_init( "escort_hotel_door_open" );
	flag_init( "escort_carry_soap_done" );
	flag_init( "escort_start_nikolai_color" );
	
	//regroup
	flag_init( "regroup_dialog_intro_start_all_clear" );
	flag_init( "regroup_intro_start_sequence" );
	flag_init( "regroup_helicopters_start" );
	flag_init( "regroup_dialog_intro_complete" );
	flag_init( "regroup_intro_enemies_initial_retreat" );
	flag_init( "regroup_mi28_2_attacker_in_position" );
	//flag_init( "regroup_carry_soap_done" );	
	flag_init( "regroup_mi17_unloaded" );
	flag_init( "regroup_car_door_cover_door_open" );
	flag_init( "mg_event_over" );
	flag_init( "regroup_ending_shoot_at_player" );
	flag_init( "regroup_ending_follow_price" );
	flag_init( "regroup_ending_ugv_dialog_start" );
	flag_init( "regroup_ending_ugv_dialog_end" );
	flag_init( "regroup_ending_first_door_breached" );
	flag_init( "regroup_ending_shotgun_breach_complete" );
	flag_init( "regroup_ending_breaching" );
	flag_init( "regroup_drone_stop_loopers" );
	flag_init( "regroup_intro_enemies_start" );
	flag_init( "regroup_ending_shotgun_breach_dialog" );
	flag_init( "regroup_roll_up_dialog" );
	
	//maars control
	//flag_init( "player_to_maars_control" );
	flag_init( "maars_control_loading_helicopter" );
	flag_init( "maars_control_dialog_ugv_intro" );
	flag_init( "maars_control_door_open" );
	flag_init( "maars_control_player_controlling_maars" );
	flag_init( "maars_control_price_at_chopper" );
	flag_init( "maars_control_uav_start" );
	flag_init( "maars_control_uav_complete" );
	flag_init( "maars_control_soap_at_helicopter" );
	flag_init( "maars_control_spawn1_retreat" );
	flag_init( "maars_control_reinforcements" );
	flag_init( "maars_control_hold_complete" );
	flag_init( "maars_control_uav_start_dialog" );
	flag_init( "maars_control_end_enemies_dead" );
	flag_init( "maars_control_drone_inbound" );
	flag_init( "maars_control_boot_up_fading" );
	flag_init( "maars_shed_price_at_door" );
	
	//building slide
	flag_init( "building_slide_building_hit" );
	flag_init( "building_slide_complete" );
	flag_init( "building_slide_player_anim_done" );
	flag_init( "building_slide_player_under_second_time" );
	flag_init( "building_slide_missile1" );
	flag_init( "building_slide_missile2" );
	flag_init( "building_slide_missile3" );
	flag_init( "building_slide_missile4" );
	flag_init( "building_slide_missile5" );
	flag_init( "building_slide_missile6" );
	flag_init( "building_slide_missile7" );
	flag_init( "building_slide_missile8" );
	flag_init( "building_slide_pickup" );
	
	add_hint_string( "hint_heli_dmg", &"INTRO_HELI_DMG_HINT" );
	add_hint_string( "control_slide", &"INTRO_PLATFORM_SLIDE_HINT");
	add_hint_string( "control_slide_l", &"INTRO_PLATFORM_SLIDE_HINT_L");
	
	//---- loads ----//
	maps\createart\intro_art::main();
	// setup audio
	maps\intro_aud::main();
	maps\intro_fx::main();
	maps\intro_precache::main();
	maps\intro_anim::main();
	maps\_load::main();
	maps\intro_vo::main();
	maps\_drone_ai::init();
	maps\_drone_civilian::init();
	maps\_drone_ai_rambo::init();
	
	maps\_compass::setupMiniMap("compass_map_intro"); 
	
	//setup wounded carry
	thread maps\intro_carry::initCarry();
	
	//maars setup
	thread maars_init();
	
	// objectives
	thread intro_objectives();
	
	set_console_status();
	
	if ( level.console )
		level.hint_text_size = 1.6;
	else
		level.hint_text_size = 1.2;
		
	level.flashlight_tag = "tag_weapon_left";
	
	//enemy cleanup if the player runs through the level.
	trigger = GetEntArray( "delete_enemies_in_volume", "targetname" );
	array_thread( trigger, ::delete_enemies_in_volume );
	
	//define rumble for helis
	level.vehicle_rumble_override = [];
	struct = maps\_vehicle::build_quake( .2, .2, 1024, .05, .05 );
	PreCacheRumble( "mig_rumble" );
	struct.rumble = "mig_rumble";
	level.vehicle_rumble[ "script_vehicle_mi28_flying" ] = struct;
	level.vehicle_rumble[ "script_vehicle_mi17_woodland_fly_cheap_noai" ] = struct;
	
	//---- drone globals ----//
	//lets the drones path better on all the hills
	level.drone_lookAhead_value = 60;
	anim.fire_notetrack_functions[ "drone" ] = maps\_drone::Drone_Shoot;

	//dead drones
	array_thread( getentarray( "dead_body_spawner_trigger", "targetname" ), ::dead_body_spawner_trigger );
	
	//tutorial strings
	registerActions();
	
	//adjust exploders to allow script_group to differentiate
	//  exploders in prefabs
	adjust_exploders();
}


//---- INTRO ----//
start_intro()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	SetSavedDvar( "ui_hidemap", 1 );
	
	aud_send_msg("start_intro");
	
	setup_friendly_spawner( "price", ::setup_price );
	setup_friendly_spawner( "soap", ::setup_soap );
	setup_friendly_spawner( "nikolai", ::setup_nikolai );
}

intro()
{
	battlechatter_off( "allies" );
	
	thread maps\intro_vo::intro_dialog();
	
	intro_disable_playerhud();
	aud_send_msg("cinematic_sequence_prep");
	
	prep_cinematic( "india_flashback_1_1" );
	intro_shot_1();
	thread vision_set_fog_changes("Intro_cinematics",0);
	thread intro_shot_2_prime();
	play_cinematic( "india_flashback_1_1" );
	prep_cinematic( "india_flashback_2_1" );
	
	intro_shot_2();
	thread intro_shot_3_prime();
	play_cinematic( "india_flashback_2_1" );
	
	prep_cinematic( "india_flashback_3_1" );
	intro_shot_3();
	thread intro_shot4_open_doors();
	thread intro_shot_4_prime();
	play_cinematic( "india_flashback_3_1" );
	
	prep_cinematic( "india_flashback_4_1" );
	intro_shot_4();
	thread intro_shot_5_prime();
	play_cinematic( "india_flashback_4_1" );
	prep_cinematic( "opening" );
	intro_shot_5();
	aud_send_msg("cinematic_sequence_cleanup");
	flag_wait( "intro_opening_movie_start" );
	aud_send_msg("intro_opening_movie_start");
	play_cinematic( "opening", true, true );
	nextmission();

}

start_intro_transition()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	SetSavedDvar( "ui_hidemap", 1 );
	
	thread intro_light_tgl();
	thread background_trees_visibility();
	thread background_hillside_visibility();
			
	aud_send_msg("start_intro_transition");
		
	setup_friendly_spawner( "price", ::setup_price );
	setup_friendly_spawner( "soap", ::setup_soap );
	setup_friendly_spawner( "nikolai", ::setup_nikolai );
	
	thread intro_disable_playerhud();
	//scene setup
	thread SetUpPlayerForAnimations();
	level.player disableweapons();
	level.player disableoffhandweapons();
	//battlechatter_off( "allies" );
	
	intro_helicopter_landed_friendlies();
	doctor_spawn();
	thread vision_set_fog_changes("Intro_cinematics",0);
	
	level.player_rig = spawn_anim_model( "player_rig", ( 0, 0, 0 ) );
	level.player_rig.animname = "player_rig";
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 10, 10, 5, 0 );
	
	black_overlay = get_black_overlay( true );
	black_overlay.alpha = 1;
	
	//thread maps\_introscreen::introscreen_generic_black_fade_in( 11, 3 );
	
	flag_set( "start_intro_transition_complete" );
}

intro_transition()
{
	flag_wait( "start_intro_transition_complete" );
	thread courtyard_drones();
	thread maps\intro_vo::intro_dialog_transition();
	//intro_shot_6();
	thread vision_set_fog_changes("Intro",0);
	thread escrot_treat_soap_spawn_syringe();
	
	// need to set up all the actors in their proper position
	//   as soon as possible since you can see through the black
	//   fade when in the options menu
	intro_shot_7();
	thread intro_shot_8();
	
	flag_set( "courtyard_drones_start" );
	//battlechatter_on( "allies" );
}



//---- COURTYARD ----//
start_courtyard()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
		
	thread intro_light_tgl();
		
	aud_send_msg("start_courtyard");
	//setup_friendlies( "player_start_escort" );
	thread background_trees_visibility();
	thread background_hillside_visibility();
	
	level.heroes = [];
	setup_friendly_spawner( "price", ::setup_price );
	setup_friendly_spawner( "soap", ::setup_soap );
	setup_friendly_spawner( "nikolai", ::setup_nikolai );

	spawn_friendlies("player_start_escort" ,"price");
	spawn_friendlies("player_start_escort" ,"nikolai");
	
	intro_room_setup();

	flag_set( "intro_complete" );
	flag_set( "courtyard_drones_start" );
	flag_set( "courtyard_dialog_balcony_start" );
	thread vision_set_fog_changes("intro_courtyard",0);
	thread escrot_treat_soap_spawn_syringe();
	thread intro_room_heli_crash_as_yuri( undefined );
	thread courtyard_drones();
}

courtyard()
{
	SetSavedDvar( "ui_hidemap", 0 );
	
	thread intro_text();
	thread maps\intro_vo::courtyard_dialog_intro();
	thread courtyard_player_on_balcony();
	thread courtyard_friendly_intro();
	thread courtyard_helicopters();
	
	thread courtyard_breach();
	thread courtyard_combat();
	thread courtyard_price();
	thread courtyard_cover_pull_down();
	
	flag_set( "courtyard_dialog_intro_start" );
	
	flag_wait( "courtyard_dialog_intro_end" );
	thread maps\intro_vo::courtyard_dialog_watch_breach();
	
	wait 1;
	flag_set( "courtyard_start_scene" );
}


//---- ESCORT ----//
start_escort()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	
	thread intro_light_tgl();
	
	aud_send_msg("start_escourt");

	thread background_trees_visibility();
	thread background_hillside_visibility();

	move_player_to_start( "player_start_escort" );
	level.heroes = [];
	
	setup_friendly_spawner( "price", ::setup_price );
	setup_friendly_spawner( "soap", ::setup_soap );
	setup_friendly_spawner( "nikolai", ::setup_nikolai );

	spawn_friendlies( "player_start_escort", "price" );
	spawn_friendlies( "player_start_escort", "nikolai" );
	
	intro_room_setup();

	flag_set( "intro_complete" );
	flag_set( "obj_take_position_on_balcony" );
	thread breach_door( "courtyard_breach_door_left", "courtyard_breach_door_left_destroyed", "courtyard_left_breach_door_collision" );
	thread breach_door( "courtyard_breach_door_right", "courtyard_breach_door_right_destroyed", "courtyard_right_breach_door_collision" );
	flag_set( "courtyard_start_breach" );
	thread courtyard_friendly_cleanup();
	thread escrot_treat_soap_spawn_syringe();
	thread intro_room_heli_crash_as_yuri( undefined );
	thread courtyard_price();
	thread vision_set_fog_changes("intro_escort",0);
	
	flag_set( "courtyard_combat_done" );
}

escort()
{
	// gate the logic function since it runs threaded from a start point
	flag_wait( "courtyard_combat_done" );
	level.price thread escort_price_throw_smoke();
	flag_wait( "escort_smoke_out" );
	thread escort_doc_down_mi28();
	
	flag_wait( "escort_doc_down_mi28_fire" );
	
	wait 1;
	thread escort_advanced_nikolai_color();
	thread escort_help_soap();
	thread maps\intro_vo::escort_dialog();
	thread color_volume_advance( "escort_nikolai_color", 1, 1 );
	thread escort_rappelers();
	thread escort_price_open_door();
	thread escort_combat();
	thread escort_wounded();
	thread escort_carry_soap();
	thread escort_vehicles();

}


//---- REGROUP ----//
start_regroup()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .1);
	setsaveddvar("sm_sunshadowscale", .5);
	
	thread background_trees_visibility();
	thread background_hillside_visibility();
	thread escort_player_exits_courtyard();
	
	aud_send_msg("start_regroup");

	move_player_to_start( "player_start_regroup" );
	setup_friendlies( "player_start_regroup" );
	flag_set( "intro_complete" );
	thread breach_door( "courtyard_breach_door_left", "courtyard_breach_door_left_destroyed", "courtyard_left_breach_door_collision" );
	thread breach_door( "courtyard_breach_door_right", "courtyard_breach_door_right_destroyed", "courtyard_right_breach_door_collision" );
	flag_set( "courtyard_start_breach" );
	thread soap_wounded_start_position();
	flag_set( "escort_carry_soap_done" );
	thread vision_set_fog_changes("intro_regroup",0);

}

regroup()
{
	thread maps\intro_vo::regroup_dialog();
	thread color_volume_advance( "regroup_price_color", 2, 1, "price_stop_color_advance" );
	thread color_volume_advance( "regroup_nikolai_color", 5, 1 );

	thread remove_drone_spawners_from_respawners();
	thread regroup_intro_enemies_initial();
	thread regroup_carry_soap();
	thread regroup_intro_friends();
	thread regroup_intro_enemies();
	thread regroup_civilians();
	thread regroup_civ_car();
	thread regroup_helicopters();
	//thread regroup_uav_gate_fly_by();
	thread regroup_price_to_nikolai();
	thread regroup_price_break_and_rake();
	thread regroup_roll_up_door();
	thread regroup_uav_street();
	thread regroup_helicopters_gate();
	thread regroup_building_destructs_setup();
	thread regroup_price_down_alley();
	thread regroup_car_cover();
	thread regroup_damage_cars();
	thread regroup_ending();
	thread intro_fire_light();
	
	setsaveddvar("sm_spotlimit",2);

	flag_wait( "regroup_dialog_intro_complete" );
}


//---INTRO LIGHT TOGGLE---//
intro_light_tgl()
{

	light = GetEnt( "intro_light_tgl", "targetname" );
	if( !isdefined( light ) )
		return;
		
//flickerLight( color0, color1, minDelay, maxDelay )

light SetLightIntensity( ( .01 ) );
}

//---FIRE LIGHT---//
intro_fire_light()
{

	light = GetEnt( "fire_flicker", "targetname" );
	if( !isdefined( light ) )
		return;
		
//flickerLight( color0, color1, minDelay, maxDelay )

light SetLightIntensity( ( 6 ) );
light thread maps\_lights::flickerLight( ( 0.972549, 0.674510, 0.345098 ), ( .2, 0.1662746, 0.0878432 ), .005, .15 );

	original_origin = light.origin;
	original_angles = light.angles;
	original_radius = light.radius;
	
	random_x		= 5;
	random_y 		= 5;
	random_z 		= 5;
	random_r 		= 5;
	min_delay 	= .05;
	max_delay 	= .35;
	
	/*while( !flag( "off_fire_light" ) )
		{
			delay = RandomFloatRange( min_delay, max_delay );
			amount = randomfloatrange( .1, 1 );
		
			x = ( random_x * ( randomfloatrange( .1, 1 ) ) );
			y = ( random_y * ( randomfloatrange( .1, 1 ) ) );
			z = ( random_z * ( randomfloatrange( .1, 1 ) ) );
			r = ( random_r * ( randomfloatrange( .1, 1 ) ) );

			new_position = original_origin + ( x, y, z );
			new_radius = original_radius - ( r );
			light moveto( new_position, delay ) ;
			light SetLightRadius( new_radius );
			wait delay;
		}
	light SetLightIntensity( 0 );	*/
}

//---- MAARS Shed ----//
start_maars_shed()
{
	setsaveddvar("sm_spotlimit",0);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	
	thread background_hillside_visibility();
	thread escort_player_exits_courtyard();
	
	aud_send_msg("start_maars_shed");
	move_player_to_start( "player_start_maars_shed" );
	setup_friendlies( "player_start_maars_shed" );
	flag_set( "intro_complete" );
	thread soap_wounded_start_position();
	thread vision_set_fog_changes("intro_shack_yard",0);
	
	flag_set( "regroup_player_moving_down_alleyway" );
	thread regroup_ending();
	thread maps\intro_vo::regroup_dialog_weapons_ahead();
	thread regroup_intro_friends_cleanup();
	array_spawn_function_noteworthy( "regroup_drone_anim_then_delete", ::drone_anim_think );
	//flag_set( "regroup_carry_soap_done" );	
}

maars_shed()
{
	flag_set( "obj_control_ugv" );
	setsaveddvar("sm_spotlightscoremodelscale","1");
	
	thread maars_control_door();
	//thread maars_control_intro();
	thread maps\intro_vo::maars_shed_dialog();
	flag_wait( "player_to_maars_control" );
	//flag_init( "off_fire_light" );
}


//---- MAARS CONTROL ----//
start_maars_control()
{
	setsaveddvar("sm_spotlimit",2);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	
	setsaveddvar("sm_spotlightscoremodelscale","1");
	
	thread background_hillside_visibility();
	
	aud_send_msg("start_maars_control");

	move_player_to_start( "player_start_maars_control" );
	setup_friendlies( "player_start_maars_control" );
	flag_set( "intro_complete" );
	thread soap_wounded_start_position();
	thread vision_set_fog_changes("intro_shack",0);
	
	flag_set( "player_to_maars_control" );
	
	// make sure everyone is in the proper animations
	start_maars_control_anim();
}

start_maars_control_anim()
{
	prep_cinematic( "ugv_startup" );
	
	anim_pos = GetStruct( "maars_control_maars_intro", "targetname" );
	
	spawn_ugv_vehicle();
	
	rolling_door = spawn_anim_model( "rolling_door", ( 0, 0, 0 ) );
	anim_pos anim_first_frame_solo( rolling_door, "intro_weapon_cache_end" );
	
	flag_wait( "maars_control_player_controlling_maars" );
	flag_wait( "maars_control_boot_up_fading" );
	delaythread( 4, ::maars_control_garage_door_open );
	actors_end = [ level.price, rolling_door ];
	anim_pos anim_single( actors_end, "intro_weapon_cache_end" );
	anim_pos thread anim_loop_solo( level.price, "intro_weapon_cache_end_idle", "end_idle" );
	flag_wait( "maars_control_player_out_of_weapons_cache" );
	anim_pos notify( "end_idle" );

	trigger = getent( "maars_control_price_color", "targetname" );
	trigger notify( "trigger" );
}

maars_control()
{
	thread maars_control_monitor_background_hillside_visibility();  //manually showing some of the vista geo
	thread maps\intro_vo::maars_control_dialog();
	thread maars_control_activate_maars();
	thread maars_control_maars_setup();
	thread maars_control_combat();
	//thread maars_control_smoke();
	thread maars_control_helicopters();
	thread maars_control_ending_sequence();
	thread maars_control_carry_soap();
	thread building_slide_remove_player_clip();
	thread maars_control_setup_allied_targets();
	thread building_slide_destroy_tree_setup();
	thread maars_control_crate_top_collision();
	flag_wait( "obj_clear_helicopter_area_complete" );
}


//---- SLIDE ----//
start_slide()
{
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunsamplesizenear", .2);
	setsaveddvar("sm_sunshadowscale", .4);
	
	setsaveddvar("sm_spotlightscoremodelscale","0");
	
	aud_send_msg("start_slide");
	
	move_player_to_start( "player_start_slide" );
	setup_friendlies( "player_start_slide" );
	flag_set( "intro_complete" );
	thread soap_wounded_start_position();
	thread maars_control_garage_door_open();
	thread building_slide_destroy_tree_setup();
	thread vision_set_fog_changes("intro_shack_yard",0);
	
	thread maps\_spawner::killspawner(201);
	thread maps\_spawner::killspawner(202);
	thread maps\_spawner::killspawner(203);
	thread maps\_spawner::killspawner(204);
	thread maps\_spawner::killspawner(205);
	
	flag_set( "obj_clear_helicopter_area_complete" );
	
}

slide()
{
	thread maars_control_crate_top_collision( true );
	thread maps\intro_vo::building_slide_dialog();
	thread building_slide_player_setup();
	thread building_slide_spawn_player_clip();
	thread building_slide_run();
	
	flag_wait( "building_event_start" );
	aud_send_msg("building_event_start");
	level.player enableinvulnerability();
	thread vision_set_fog_changes("intro_slide",4.5);
	//thread building_slide_uav();
	thread building_slide_begins();
	//thread building_slide_monitor_player_in_water();
	
	flag_wait( "building_slide_complete" );
	nextmission();
}

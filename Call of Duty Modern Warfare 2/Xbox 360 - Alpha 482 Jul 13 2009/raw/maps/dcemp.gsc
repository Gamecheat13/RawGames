#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;
#include maps\_casual_killer;

#include maps\dcemp_code;

CONST_DUNN_LINE_TIME 		= 1.65;
CONST_FOLEY_LINE_TIME 		= .5;

main()
{
	flags();
	
	//STARTS
	default_start( ::start_intro );
	add_start( "intro", 	::start_intro, 		"[intro] -> play end of dc burning", 				::intro_main );
	add_start( "iss", 		::start_iss, 		"[iss] -> see the emp up close and personal", 		::iss_main );
	add_start( "emp",		::start_emp, 		"[emp] -> see the emp effects from the ground",		::emp_main );
	add_start( "street",	::start_street, 	"[street] -> find cover off the street",			::street_main );
	add_start( "corner",	::start_corner, 	"[corner] -> watch the plane crash",				::corner_main );
	add_start( "meetup",	::start_meetup, 	"[meetup] -> meetup with some allies",				::meetup_main );
	add_start( "lobby",		::start_lobby, 		"[lobby] -> sneak through the lobby",				::lobby_main );
	add_start( "office",	::start_office, 	"[office] -> fight through the office",				::office_main );
	add_start( "parking",	::start_parking, 	"[parking] -> traverse the parking deck",			::parking_main );
	add_start( "plaza",		::start_plaza, 		"[plaza] -> continue through the plaza",			::plaza_main );
	add_start( "tunnels",		maps\dcemp_endpart::start_tunnels, 	"[tunnels] -> traverse the tunnels", maps\dcemp_endpart::tunnels_main );
//	add_start( "whitehouse2", 	maps\dcemp_endpart::start_whitehouse, "[whitehouse] -> fight through the whitehouse", maps\dcemp_endpart::whitehouse_main );
//	add_start( "flare", 		maps\dcemp_endpart::start_flare, "[flare] -> pop the flare", maps\dcemp_endpart::flare_main );
		
	global_inits();
}

flags()
{
	flag_init( "intro_fx" );
	flag_init( "iss_fx" );
	flag_init( "rain_fx" );
	flag_init( "rain_fx2" );
	flag_init( "end_fx" );
	
	flag_init( "script2model_intro" );
	flag_init( "script2model_iss" );
	flag_init( "script2model_end" );
	
	flag_init( "team_initialized" );
	flag_init( "spotlight_lightning" );
	
	flag_init( "iss_player_first_controls" );
	flag_init( "iss_player_drive_controls" );
	flag_init( "iss_organize_ents" );
	flag_init( "iss_see_icbm" );				
	flag_init( "iss_space_nuke" );
	flag_init( "iss_destroy_first_wave" );
	flag_init( "iss_destroy_blast_wave" );
	flag_init( "iss_done" );
	flag_init( "iss_start_dialogue" );
	flag_init( "iss_copythat" );
	flag_init( "iss_nag_dialogue" );
			
	flag_init( "emp_main" );
	flag_init( "emp_jet_crash" );
		
	flag_init( "street_main" );
	flag_init( "do_player_crash_fx" );	
	flag_init( "street_crash_cop" );
	flag_init( "street_crash_left" );
	flag_init( "street_guy_fall" );
	flag_init( "street_crash_hide" );
	flag_init( "street_crash_left2" );
	
	flag_init( "street_crash_heli_first" );
	flag_init( "street_crash_btr_first" );	
	flag_init( "street_crash_heli_hide" );
	flag_init( "street_crash_heli_done" );
	flag_init( "street_safe" );
	flag_init( "street_btr_death" );
	flag_init( "street_btr_scene_done" );
	
	flag_init( "corner_start_crash_scene" );			
	flag_init( "corner_engine_crash" );			
	flag_init( "corner_engine_hit" );		
	flag_init( "corner_main" );
	flag_init( "corner_look_outside" );
	flag_init( "corner_moveout" );
	flag_init( "corner_crash_scene_done" );
	
	flag_init( "meetup_main" );
	flag_init( "meetup_moveout" );
	flag_init( "meetup_challenge_start" );
	flag_init( "meetup_challenge_done" );
	flag_init( "meetup_do_scripted_scene" );
	flag_init( "meetup_runner_safe" );
	flag_init( "meetup_runner_leave" );
	flag_init( "meetup_runner_sprint" );
	
	flag_init( "lobby_main" );
	flag_init( "lobby_check" );
	flag_init( "lobby_clear" );
	flag_init( "lobby_door_ready" );
	flag_init( "lobby_robo_death" );
	flag_init( "lobby_door_kick" );
		
	flag_init( "office_main" );
	flag_init( "office_go_red" );
	
	flag_init( "parking_main" );
	flag_init( "parking_moveout" );
	flag_init( "parking_moveout2" );
	flag_init( "parking_moveout3" );
	flag_init( "parking_checking_body" );
	flag_init( "parking_btr_shot_at" );
	flag_init( "parking_open_fire" );
	
	flag_init( "plaza_to_street" );
	flag_init( "plaza_show_enemies" );
	flag_init( "plaza_open_fire" );
	flag_init( "plaza_prepare_throw" );
	flag_init( "plaza_throw_react" );	
	flag_init( "plaza_flare_thrown" );
	flag_init( "plaza_moveout_exit" );
	flag_init( "plaza_moveout_exit2" );	
	
	flag_init( "tunnels_main" );
}

createfx_setup()
{
	// this array will be filled with code commands that SP or MP may use but doesn't exist in the other.
	if ( !isdefined( level.func ) )
		level.func = [];
	level.func[ "create_triggerfx" ] = ::dcemp_create_triggerfx;
	
	//ROBOT -> change fx groups here
	if( getdvar( "createfx" ) == "on" )
	{
		flag_set( "intro_fx" );
	//	flag_set( "iss_fx" );
	//		robot_iss_stuff();
			
	//	flag_set( "rain_fx" );
	//	flag_set( "end_fx" );	
	}	
}

robot_iss_stuff()
{
	precachemodel( "ch_street_light_01_on" );
	precachemodel( "iss_prop_3" );
	precachemodel( "iss_prop_5" );
	precachemodel( "com_outdoor_switch" );
	precachemodel( "iss_prop_7" );
	precachemodel( "iss_grip_1" );
	precachemodel( "iss_prop_1" );
	precachemodel( "iss_grip_2" );
	precachemodel( "iss_prop_8" );
	precachemodel( "iss_sail_frame" );
	precachemodel( "iss_sail_center" );
	precachemodel( "iss_prop_6" );
	precachemodel( "iss_prop_9" );
	precachemodel( "bg_iss" );	
	
	delaythread( .5, ::script2model_iss );
}

global_inits()
{	
	createfx_setup();
		
	triggers = getEntArray( "trigger_multiple_dyn_photo_copier", "classname" );
	triggers = array_combine( triggers, getEntArray( "trigger_multiple_dyn_copier_no_light", "classname" ) );
	array_call( triggers, ::delete );
	
	volumes = getentarray( "mask_ents", "targetname" );
	mask_destructibles_in_volumes( volumes );
	mask_interactives_in_volumes( volumes );
						
	maps\dcemp_precache::main();
	maps\createart\dcemp_fog::main();
	maps\createfx\dcemp_fx::main();
	maps\dcemp_fx::main();
	maps\dc_crashsite::main();
	maps\_load::main();
		
	thread maps\_mortar::bog_style_mortar();
	
	maps\dcemp_anim::main();
	maps\_drone_ai::init();
			
	level thread maps\dcemp_amb::main();
	
	maps\_compass::setupMiniMap( "compass_map_dcemp" );
		
	script2model_precache();
	level.bg_iss_darknum = 12;
	
	for( i = 1; i <= level.bg_iss_darknum; i++ )
	{
		name = "bg_iss_dark0";
		if( i > 9 )
			name = "bg_iss_dark";
		precachemodel( name + i );
	}
	
	//manually precaching models because of masking of destrucibles
	precacheModel( "prop_photocopier_destroyed" );
	precacheModel( "prop_photocopier_destroyed_top" );
	precacheModel( "prop_photocopier_destroyed_right_shelf" );
	precacheModel( "prop_photocopier_destroyed_left_feeder" );
	precacheModel( "com_tv2_d" );
	precacheModel( "com_newspaperbox_red_dam" );
	precacheModel( "com_newspaperbox_red_des" );
	precacheModel( "com_newspaperbox_red_door" );
	precacheModel( "com_newspaperbox_blue_dam" );
	precacheModel( "com_newspaperbox_blue_door" );
	precacheModel( "com_newspaperbox_blue_des" );
	precacheModel( "me_electricbox2_dest" );
	precacheModel( "me_electricbox2_door_upper" );
	precacheModel( "me_electricbox2_door" );
	precacheModel( "me_electricbox4_dest" );
	precacheModel( "me_electricbox4_door" );
	precacheModel( "com_filecabinetblackclosed_dam" );
	precacheModel( "com_filecabinetblackclosed_des" );
	precacheModel( "com_filecabinetblackclosed_drawer" );
	precacheModel( "me_lightfluohang_double_destroyed" );

	precachemodel( "projectile_us_smoke_grenade" );
	precacheModel( "tag_origin" );	
	precacheModel( "vehicle_van_white_door_rb" );
	precacheModel( "bc_military_tire01" );
	precacheModel( "vehicle_van_white_hood" );
	precacheModel( "rubble_large_slab_02" );
	precacheModel( "727_seats_row_left" );	
	precacheModel( "ch_street_light_01_off" );
						
	precacherumble( "tank_rumble" );
	precacherumble( "damage_heavy" );
	precacherumble( "steady_rumble" );
	precacheshader( "hint_mantle" );
	precacheShader( "white" );
	precacheshellshock( "default" );
	precacheshellshock( "nosound" );
		
	level.default_goalheight = 128;
	
	// whitehouse precaches
	precachemodel ( "rappelrope100_ri" );
	precachemodel ( "mil_emergency_flare" );
	PreCacheTurret( "heli_spotlight" );
	precachemodel( "cod3mg42" );	// should be a spotlight model but can't find one that works as a turret.
	PrecacheItem( "rpg_straight" );
	precachemodel( "com_door_01_handleleft2" );
		
	precacheString(&"DCEMP_INTROSCREEN_1");
	precacheString(&"DCEMP_INTROSCREEN_2");
	precacheString(&"DCEMP_INTROSCREEN_3");
	precacheString(&"DCEMP_INTROSCREEN_4");
	precacheString(&"DCEMP_INTROSCREEN_5");
	
	precachestring( &"DCEMP_ISS_INTROSCREEN1" );
	precachestring( &"DCEMP_ISS_INTROSCREEN2" );
	precachestring( &"DCEMP_ISS_INTROSCREEN3" );
	
	precachestring( &"DCEMP_OBJ_CRASH_SITE" );
	precachestring( &"DCEMP_OBJ_FIND_SHELTER" );
	precachestring( &"DCEMP_OBJ_FOLLOW_SGT_FOLEY" );
	precachestring( &"DCEMP_OBJ_WHISKEY_HOTEL" );

//	maps\_slowmo_breach::slowmo_breach_init();

	setup_sun();
	
	//--------------->	setup corner
	corner_hide_damage();
		
	array_thread( getentarray( "flickerlight1", "script_noteworthy" ), ::flickerlight_flares );
	fire_lights = getentarray( "light_street_fire", "script_noteworthy" );
	light = getclosest( getstruct( "runner_light", "targetname" ).origin, fire_lights );
	light setlightintensity( 3.5 );
	array_thread( fire_lights, ::light_street_fire );
	
	door = getent( "meetup_door_left", "targetname" );
	
	door delaycall( .1, ::rotateyaw, 90, .1 );
	door delaycall( .2, ::disconnectpaths );
	
	level.objnum = 0;
}



/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
intro_main()
{		
	flag_set( "player_crash_done" );
	
	lines = [];
	// 'Second Sun'
	lines[ lines.size ] = &"DCEMP_INTROSCREEN_1";
	// "Day 5, 18:12:[{FAKE_INTRO_SECONDS:02}] hrs"
	lines[ lines.size ] = &"DCEMP_INTROSCREEN_2";
	// "Pvt. James Ramirez"
	lines[ lines.size ] = &"DCEMP_INTROSCREEN_3";
	// 75th Ranger Regiment
	lines[ lines.size ] = &"DCEMP_INTROSCREEN_4";
	// "Washington, D.C."
	lines[ lines.size ] = &"DCEMP_INTROSCREEN_5";
	
	delaythread( 1, maps\_introscreen::introscreen_feed_lines, lines );
	
	thread intro_crash_vehicle_setup();
	thread intro_enemy_setup();
	maps\dc_crashsite::AA_crash_site_init();
}

intro_crash_vehicle_setup()
{
	getent( "heli_crash_site_spotlight", "targetname" ) add_spawn_function( ::emp_heli_spotlight );
	getent( "btr80s_end", "targetname" ) add_spawn_function( ::emp_btr );
	array_thread( getentarray( "helis_crash_rappel", "targetname" ), ::add_spawn_function, ::emp_heli_rappel );
	array_thread( getentarray( "helis_crash_distant", "targetname" ), ::add_spawn_function, ::emp_heli_distant );
		
	flag_wait( "first_wave_done" );
	
	wait 4;
	delaythread( 0, ::spawn_vehicles_from_targetname_and_drive, "helis_crash_distant" );
}



/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/
iss_main()
{	
	flag_wait( "emp_entity_cleanup_done" );
	
	thread maps\_utility::set_vision_set( "dcemp_iss", 0 );	
	thread maps\_utility::vision_set_fog_changes( "dcemp_iss", 0 );
		
	thread maps\_utility::set_ambient( "dcemp_iss" );
	level.player disableweapons();
	level.player freezecontrols( true );
	level.emp_player_angles = level.player getplayerangles();
	
	fx_intro_pause();
	flag_set( "iss_fx" );
	script2model_del_intro();
	thread script2model_iss();
		
	add_wait( ::flag_wait, "script2model_iss" );
	add_func( ::iss_organize_ents );
	thread do_wait();
		
	if ( !isdefined( level.white_overlay ) )
		level.white_overlay = create_client_overlay( "white", 1 );
		
	flag_wait( "iss_organize_ents" );
	
	//setsaveddvar( "cg_fovscale", .85 );
	setsaveddvar( "sm_sunsampleSizeNear", 1.25 );
	
	wait 1;
	
	level.white_overlay fadeOverTime( 4 );
	level.white_overlay.alpha = 0;	
	
	level.iss_sat = iss_satellite();		
		
	thread iss_temp_satelite_anim();
	thread iss_dialogue();
	
	flag_wait( "iss_start_dialogue" );
			
	wait 13;
	
	flag_set( "iss_see_icbm" );				
	thread flag_set_delayed( "iss_copythat", 11.5 );
	thread flag_set_delayed( "iss_nag_dialogue", 8 );
	iss_nuke_scene();
	
	wait 3.35;
	
	stopallRumbles();
	level.rumble delaycall( .5, ::delete );
	level.white_overlay.alpha = 1;
	
	level.nuke_water_tag delete();
	
	flag_set( "iss_done" );		
}

iss_wait_player_see_icbm( timeout )
{
	self endon( "iss_wait_player_see_icbm" );
	level.iss_missile endon( "death" );
	
	if( isdefined( timeout ) )
		self thread notify_delay( "iss_wait_player_see_icbm", timeout );
		
	while( !( self WorldPointInReticle_Circle( level.iss_missile.origin, getdvarint( "cg_fov" ), 500 ) ) )
		wait .1;	
	
	return true;
}

iss_nag_dialogue()
{
	level endon( "iss_nag_dialogue" );
	//level thread notify_delay( "iss_nag_dialogue", 8 );
	level.iss_missile endon( "death" );
	
	if( !isdefined( level.player iss_wait_player_see_icbm( .5 ) ) )
	//Sat1, rotate your view a little further to the right will ya?
	radio_dialogue( "dcemp_iss_rotateview" );
	
	level.player iss_wait_player_see_icbm();
}

iss_dialogue()
{
	flag_wait( "iss_start_dialogue" );
	//Come in Sat1, this is ISS Control. Houston's requesting a feed from your helmet cam, over.
	radio_dialogue( "dcemp_iss_requestfeed" );
	
	wait 1;
	//Uh, they want you to look over towards the dark side of the earth.  It should be cresting the horizon about 15 degrees east of the starboard PV arrays.
	radio_dialogue( "dcemp_iss_theywantyou" );
	
	flag_wait( "iss_see_icbm" );
	wait 1.5;	
	
	iss_nag_dialogue();
	
	radio_dialogue_stop();
	//There it is, we're getting your feed Sat1.  Come in Houston, are you getting this?
	radio_dialogue( "dcemp_iss_thereitis" );
	
	flag_wait( "iss_copythat" );
	//Copy that ISS, video feed from Sat1 is clear.	
	radio_dialogue( "dcemp_hsc_copythat" );	
	wait 1;
	//Sat1, keep tracking the bogey. We're looking into it, standby.
	radio_dialogue( "dcemp_hsc_keeptracking" );	
	
	wait 1.5;
	
	//Houston, we're not scheduled for any satellite launches today are we?
	radio_dialogue( "dcemp_iss_notscheduled" );	
	wait 2.5;
	
	//ISS, Houston. Standby. We may have a problem here.
	radio_dialogue( "dcemp_hsc_standby" );	
	wait 1.0;
	
	//Houston, this is ISS Control, uh... any word on the-
	thread radio_dialogue( "dcemp_iss_anyword" );	
	
	flag_wait( "iss_space_nuke" );
	wait .5;
	radio_dialogue_stop();
}

iss_nuke_scene()
{
	missile = spawn_vehicle_from_targetname( "iss_icbm_vehicle" );
	playfxontag( level._effect[ "dcemp_icbm_trail" ], missile, "TAG_ORIGIN" );
	missile startpath();
	missile vehicle_setspeedimmediate( 55, 100 );
	level.iss_missile = missile;
	
	missile waittill( "reached_end_node" );
	exploder ( "space_nuke" );
	missile delete(); 
	
	flag_set( "iss_space_nuke" );
	
	earth = getent( "earth_model", "targetname" );
	level.nuke_water_tag = spawn( "script_model", earth.origin + (5000,56500,500) );
	level.nuke_water_tag.angles = (-90,-90,0);
	level.nuke_water_tag setmodel( "tag_origin" );
	playfxontag( level._effect[ "dcemp_water_nuke_glow" ], level.nuke_water_tag, "TAG_ORIGIN" );
	
	thread iss_lights_out();
	thread iss_player_sounds();
	
	wait 4;
	
	iss_destroy_iss();
				
	flag_wait( "iss_destroy_first_wave" );
	exploder ( "iss_explodes" );
	
	wait .35;
			
	earthquake( .15, 3, level.player.origin, 512 );
				
	flag_wait( "iss_destroy_blast_wave" );
	wait .35;
	
	level.rumble = spawn( "script_origin", level.player.origin );
	level.rumble PlayRumbleLoopOnEntity( "steady_rumble" );
	level.rumble linkto( level.player );
		
	level.white_overlay fadeOverTime( 4 );
	level.white_overlay.alpha = .15;	
	thread iss_kill_player();
	thread iss_player_quake();
	
	SetBlur( 5, 0 );
	wait .1;
	setblur( 1.0, 3 );
	
	wait .5;
	thread iss_destroy_sat();
	exploder ( "sat_destroy" );
}

iss_temp_satelite_anim()
{
	angle = 45;
	dist = -2000;
	time = 70;
		
	node = level.iss_sat[ "node" ];
	node2 = level.iss_sat[ "camera" ].node;
	
	node.angles += ( 0,angle,0 );
	node.origin += ( dist,0, 0 );
	node2.angles += ( 0,angle,0 );
	node2.origin += ( dist,0, 0 );
	
	node rotateyaw( angle * -1, time );
	node movex( dist * -1, time );
	node2 rotateyaw( angle * -1, time );
	node2 movex( dist * -1, time );
	
	level.player lerpViewAngleClamp( .1, .1, 0, 75, 75, 90, 70 );	
	
	node thread anim_single_solo( level.iss_sat[ "model" ], "ISS_animation" );
	node2 thread anim_single_solo( level.iss_sat[ "camera" ], "ISS_animation" );
	level.iss_sat[ "camera" ] setanim( level.iss_sat[ "camera" ] getanim( "ISS_animation" ), 1, 0, 0 );
	
	wait 3.5;
	
	level.player freezecontrols( false );
	
	wait 1.0;
	
	thread flag_set_delayed( "iss_start_dialogue", 2.5 );
	
	node2 thread anim_single_solo( level.iss_sat[ "camera" ], "ISS_animation" );
	
	wait 5;
	thread iss_preload_lights();
	
	flag_wait( "iss_space_nuke" );
	level.player lerpViewAngleClamp( 7, 4, 0, 10, 10, 10, 10 );
	wait 6;
	
	level.iss_sat[ "camera" ].node = spawn( "script_origin", level.iss_sat[ "camera" ].origin );
	level.iss_sat[ "camera" ].node.angles = level.iss_sat[ "camera" ].angles;
	level.iss_sat[ "camera" ].node linkto( node );
	level.iss_sat[ "camera" ] linkto( level.iss_sat[ "camera" ].node );
	level.iss_sat[ "camera" ].node thread anim_single_solo( level.iss_sat[ "camera" ], "ISS_float_away" );
}


iss_player_sounds()
{
	level.player delaythread( .5, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 3, ::play_sound_on_entity, "breathing_heartbeat" );
	
	
	flag_wait( "iss_destroy_first_wave" );
	
	level.player delaythread( 0, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( .5, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 1, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 1.5, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 2, ::play_sound_on_entity, "breathing_heartbeat" );
				
	flag_wait( "iss_destroy_blast_wave" );
	
	wait .35;
	level.player delaythread( 0, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 1, ::play_sound_on_entity, "breathing_heartbeat" );
	level.player delaythread( 2, ::play_sound_on_entity, "breathing_heartbeat" );		
}


/************************************************************************************************************/
/*													EMP														*/
/************************************************************************************************************/
emp_main()
{
	flag_wait( "iss_done" );
	//level.player shellshock( "nosound", 2 );
			
	script2model_del_iss();
	fx_iss_pause();
	fx_intro_restart();
	script2model_intro();
	
	array_thread( getentarray( "street_crash_car", "script_noteworthy" ), ::street_crash_cars );
	array_thread( getentarray( "street_cars_bounce", "targetname" ), ::street_cars_bounce );
	
	wait 2;
		
	delaythread( 0, ::exploder, "emp_flash" );
	delaythread( .5, ::exploder, "emp_flash" );
	delaythread( 2, ::exploder, "emp_flash" );
	delaythread( 4, ::exploder, "emp_flash" );
	//delaythread( 6, ::exploder, "emp_flash" );	
		
	emp_ents = getentarray( "emp_delete", "targetname" );
	emp_ents = array_combine( emp_ents, getentarray( "emp_swap", "targetname" ) );
	emp_ents = array_combine( emp_ents, getentarray( "emp_show", "targetname" ) );
	emp_ents = array_combine( emp_ents, getentarray( "emp_light", "targetname" ) );
	array_thread( emp_ents, ::emp_entities );
	
	thread emp_empaftermath();
	thread emp_allies_animate();	
	thread emp_player_fx();
	thread emp_jet_crash();
	thread emp_heli_crash();
	thread emp_dialogue();
	
	add_wait( ::flag_wait, "emp_jet_crash" );
	add_func( ::flag_set_delayed, "street_main", 3.25 );
	thread do_wait();
}

emp_empaftermath()
{
	level.player freezecontrols( true );
	
	//setsaveddvar( "cg_fovscale", 1 );
	setsaveddvar( "sm_sunsampleSizeNear", 0.25 );
	setblur( 0, 0 );
	level.player PlayersetGroundReferenceEnt( undefined );
	
	thread maps\_utility::set_ambient( "dcemp_dry" );
	thread vision_set_intro( 0 );
	level.player SetOrigin( level.player.playerrig.origin );
	if( !isdefined( level.emp_player_angles ) )
	{
		level.player SetPlayerAngles( level.emp_player_angles );
		level.player.playerrig.angles = level.player.angles;
	}	
	else
		level.player SetPlayerAngles( level.player.playerrig.angles );
	level.player PlayerLinkToDelta( level.player.playerrig, "tag_player", 1, 60, 60, 20, 20, true );
		
	level.player enableweapons();
	level.player freezecontrols( false );
	level.player setempjammed( true );
	maps\_compass::setupMiniMap( "compass_map_dcemp_static" );
		
	wait( .35 );
		
	//fade back
	flag_set( "emp_back_from_whiteout" );
	level.white_overlay fadeOverTime( 4 );
	level.white_overlay.alpha = 0;
}

emp_dialogue()
{
	flag_wait( "emp_jet_crash" );
	wait 1;
	//What the hell's goin' on?
	level.dunn thread dialogue_queue( "dcemp_cpd_whatsgoinon" );	
}

emp_player_fx()
{
	flag_wait( "iss_done" );
				
	thread vision_set_emp();
	
	time = 4.25;
	wait time;
	thread play_sound_in_space( "veh_mig29_sonic_boom", level.player.origin + (0,0,100) );
}

emp_allies_animate()
{
	flag_wait( "emp_entity_cleanup_done" );
	
	thread battlechatter_off();
	
	start_common_dcemp();
		
	array_thread( level.team, ::set_ignoreme, true );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::disable_arrivals );
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::disable_pain );
		
	level.foley thread emp_foley();
	level.dunn thread emp_dunn();
	level.team[ "marine1" ] thread emp_marine1();
}

emp_foley()
{	
	link = getstruct( self.target, "targetname" );				
	node = getnode( link.target, "targetname" );
	self.goalradius = 16;
	self setgoalnode( node );
	
	link.origin = node.origin;
	link.angles = node.angles + (0,-90,0);
	link anim_generic( self, "DCemp_react_guyA_react" );
		
	flag_wait( "emp_jet_crash" );
	
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	self anim_generic( self, "corner_standR_flinchB" );
}

emp_dunn()
{
	node = getstruct( self.target, "targetname" );					
	link = getstruct( node.target, "targetname" );
	node = getnode( link.target, "targetname" );
	self.goalradius = 16;
	self setgoalnode( node );
	
	link.origin = node.origin;
	link.angles = node.angles + (0,-90,0);
	link anim_generic( self, "DCemp_react_guyB_react" );
	
	flag_wait( "emp_jet_crash" );
	
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	self thread anim_generic_gravity( self, "bog_b_spotter_react" );
	length = getanimlength( getanim_generic( "bog_b_spotter_react" ) );
	self delaycall( length * .93, ::stopanimscripted );	
}

emp_marine1()
{
	node = getstruct( "intro_heli_free_start", "targetname" );
	self teleport_actor( node );
	
	self disable_arrivals();
	self disable_exits();
	self walkdist_zero();
	self pathrandompercent_zero();
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "dcemp_BHrescue_soldier" );
	delaythread( 5.5, ::emp_free_player );
	actors = array_add( level.planks, self );
	node thread anim_single( actors, "dcemp_BHrescue" );
	
	length = getanimlength( getanim_generic( "dcemp_BHrescue_soldier" ) );
	wait length - .6;
	
	self stopanimscripted();
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles + (0,-7,0);
	node anim_generic_gravity_run( self, "corner_standR_trans_IN_3" );
	node delete();
		
	node = getnode( self.target, "targetname" );
	node = getnode( node.target, "targetname" );
	
	self.goalradius = 16;
	
	self enable_arrivals();
	self enable_exits();
	self setgoalnode( node );
		
	self waittill( "goal" );
	
	self disable_arrivals();
	self disable_exits();
}

emp_free_player()
{
	crash_site_clip = getent( "crash_site_clip", "targetname" );
	crash_site_clip delete();
	
	level notify( "player_unlinked" );
	
	wait .25;
	
	rig = level.player.playerrig;
	
	end = getent( "movement_grid_exit", "targetname" );
	
	time = 1;
	rig moveto( end.origin, time, time * .5, time * .5 );
	rig waittill( "movedone" );
	
	level.player unlink();
	level.player allowstand( true );
	level.player allowcrouch( true );
	level.player allowprone( false );
	level.player allowsprint( true );
	level.player allowjump( true );
	
	heli_clip = getent( "intro_heli_after_emp_clip", "targetname" );
	heli_clip solid();
	
	setsaveddvar( "ui_hidemap", 0 );
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar( "compass", "1" );
}

/************************************************************************************************************/
/*													STREET													*/
/************************************************************************************************************/
street_main()
{			
	flag_wait( "street_main" );
	flag_clear( "allow_ammo_pickups" );
	flag_set( "street_crash_heli_first" );
	
	thread autosave_now();
		
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	delaythread( 3, ::vision_set_sunset );
	delaythread( 1, ::activate_trigger, "meetup_allies", "target" );
		
	//introduction	
	array_thread( level.team, ::set_ignoreme, true );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::disable_arrivals );
	array_thread( level.team, ::disable_exits );
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::disable_pain );
	array_thread( level.team, ::walkdist_zero );
	array_thread( level.team, ::ent_flag_init, "street_hide" );	
	
	level.player blend_movespeedscale( .8 );
		
	//start the fallin shit
	newtime = CONST_DUNN_LINE_TIME + CONST_FOLEY_LINE_TIME + 1;
	thread flag_set_delayed( "street_crash_btr_first", 2.5 + newtime );
	delaythread( 2.5 + newtime, ::street_heli_player_kill );
	level.fallguy delaythread( 10 + newtime, ::spawn_ai );
	
	//What the hell's goin' on?
	//level.dunn thread dialogue_queue( "dcemp_cpd_whatsgoinon" );
	wait CONST_DUNN_LINE_TIME;
	//Seek shelter!!! Get off the street now!!!			
	level.foley thread dialogue_queue( "dcemp_fly_seekshelter" );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_FIND_SHELTER" );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
	objective_current( level.objnum );
	
	level.team[ "dunn" ] thread street_gohide_dunn();
	wait 1.0;
	level.team[ "foley" ] thread street_gohide_foley();
	wait .5;
	level.team[ "marine1" ] thread street_gohide_marine1();
	
	thread street_hide_moment();
	
	flag_wait( "street_safe" );
	flag_set( "corner_main" );
}

street_gohide_marine1()
{	
	node = getent( "street_marine2_anim0a", "targetname" );	
	
	self enable_heat_behavior();
	
	temp = spawnstruct();
	temp.origin = self.origin;
	temp.angles = self.angles + (0,-12,0);
	temp thread anim_generic_gravity( self, "corner_standR_trans_OUT_6" );
	
	wait .5;
	self stopanimscripted();
	
	self linkto( node );
	node delaycall( .25, ::movez, 8, .5 );
	node thread anim_generic( self, "gulag_sewer_slide" );
	length = getanimlength( getanim_generic( "gulag_sewer_slide" ) );
	wait length * .28;
	self unlink();
	self stopanimscripted();
	
	temp.origin = self.origin;
	temp.angles = (0,80,0);
	temp anim_generic_gravity_run( self, "stand_2_run_F_2" );
		
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_turn_R45" );
	node anim_generic_run( self, "run_turn_R45" );
	
	self thread anim_generic_gravity( self, "run_react_stumble_non_loop" );	
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	flag_wait( "street_btr_death" );
	
	self thread anim_generic( self, "bog_b_spotter_react" );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	wait .05;
		
	self setanimtime( getanim_generic( "bog_b_spotter_react" ), .1 );
	length = getanimlength( getanim_generic( "bog_b_spotter_react" ) );
	wait length * .72 - .05;
	self stopanimscripted();
	
	//What the hell is goin' on!!!
	self delaythread( .5, ::dialogue_queue, "dcemp_ar1_whatsgoinon" );
	
	link = spawn( "script_origin", self.origin );
	link.angles = self.angles;
	self linkto( link );
	link delaycall( .25, ::rotateyaw, 25, .5 );
	link anim_generic_run( self, "crouch_2run_F" );
	self unlink();
	link delete();			
				
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_turn_R45" );
	node anim_generic_run( self, "run_turn_R45" );
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_react_flinch_non_loop" );
	node anim_generic_run( self, "run_react_flinch_non_loop" );
		
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "traverse_window_M_2_dive" );
	link = spawn( "script_origin", node.origin );
	link.angles = node.angles;
	self linkto( link );
	link delaycall( .25, ::movez, 8, 1 );
	link delaycall( 1.5, ::movez, 8, 1.5 );
		
	link thread anim_generic( self, "traverse_window_M_2_dive" );
	self playsound( "generic_meleecharge_american_" + randomintrange( 1,9 ) );
	
	length = getanimlength( getanim_generic( "traverse_window_M_2_dive" ) );
	wait length * .73;
	self stopanimscripted();
		
	self unlink();
	link delete();	
	
	self disable_heat_behavior();
	self enable_arrivals();
	node = getnode( "street_macey_hide_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 250;
	self.moveplaybackrate = .9;
	
	self waittill( "goal" );
	
	self enable_pain();	
	self ent_flag_set( "street_hide" );
	self.moveplaybackrate = 1.0;
}

street_gohide_dunn()
{
	//This is not goood!	
	self delaythread( 2.25 + CONST_FOLEY_LINE_TIME, ::dialogue_queue, "dcemp_cpd_notgood" );
	
	self enable_heat_behavior();
	self anim_generic_gravity_run( self, "CornerCrR_trans_OUT_F" );
			
	node = getstruct( "street_marine1_anim0", "targetname" );	
		
	node anim_generic_reach( self, "run_reaction_L_quick" );
	//Whoa!!!
	self delaythread( .15, ::dialogue_queue, "dcemp_cpd_whoa" );
	node anim_generic_run( self, "run_reaction_L_quick" );
		
	node = getstruct( node.target, "targetname" );
	
	node.origin = self.origin;
	node anim_generic_run( self, "run_turn_R45" );
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_reaction_R_quick" );
	//Holy shiiiiiit!!!	
	self delaythread( 0.0, ::dialogue_queue, "dcemp_cpd_holy" );
	node anim_generic_run( self, "run_reaction_R_quick" );	
		
	node = getstruct( node.target, "targetname" );
	
	node.origin = self.origin;
	node anim_generic_run( self, "run_turn_L45" );
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "exposed_idle_reactB" );
	node thread anim_generic( self, "exposed_idle_reactB" );	
	length = getanimlength( getanim_generic( "exposed_idle_reactB" ) );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	wait length - .75;
	self stopanimscripted();
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_pain_fallonknee_03" );
	//self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	//Whoa!!!
	self delaythread( 0, ::dialogue_queue, "dcemp_cpd_whoa" );
	//Look out!!!
	length = getanimlength( getanim_generic( "run_pain_fallonknee_03" ) );
	self delaythread( length - .5, ::dialogue_queue, "dcemp_cpd_lookout" );
	node anim_generic_run( self, "run_pain_fallonknee_03" );
		
	node = getstruct( node.target, "targetname" );
	
	self disable_heat_behavior();

	node anim_generic_reach( self, "jump_across_100_spring" );
		
	link = spawn( "script_origin", node.origin );
	link.angles = node.angles;
	self linkto( link );
	link delaycall( .25, ::movez, 12, 1 );
		
	self playsound( "generic_meleecharge_american_" + randomintrange( 1,9 ) );	
	link anim_generic_run( self, "jump_across_100_spring" );
			
	self unlink();
	link delete();	
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	self anim_generic_gravity_run( self, "run_react_duck_non_loop" );
		
	self enable_arrivals();
	node = getnode( "street_marine1_hide_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 200;	
	self.moveplaybackrate = 1.1;
	
	self waittill( "goal" );
	
	self enable_pain();
	self ent_flag_set( "street_hide" );
	self.moveplaybackrate = 1.0;
}

street_gohide_foley()
{
	node = getstruct( "street_macey_anim0", "targetname" );
		
	self enable_heat_behavior();
	self anim_generic_gravity_run( self, "corner_standR_trans_OUT_6" );
	self anim_generic_gravity_run( self, "run_turn_L90" );
	self anim_generic_gravity_run( self, "run_turn_L45" );
		
	node anim_generic_reach( self, "exposed_idle_reactB" );
	node thread anim_generic( self, "exposed_idle_reactB" );	
	length = getanimlength( getanim_generic( "exposed_idle_reactB" ) );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	
	//Don't stop!! Keep moving!!			
	self delaythread( length - 1.0, ::dialogue_queue, "dcemp_fly_dontstop" );
	
	wait length - .75;
	self stopanimscripted();
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_pain_fallonknee" );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	node anim_generic_run( self, "run_pain_fallonknee" );	
		
	////Go go go!!!			
	self delaythread( 0, ::dialogue_queue, "dcemp_fly_gogogo" );
		
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "slide_across_car" );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );		
	node anim_generic_run( self, "slide_across_car" );
		
	self delaythread( 1.0, ::dialogue_queue, "dcemp_fly_justkeepmovin" );	
			
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_react_duck_non_loop" );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	node anim_generic_run( self, "run_react_duck_non_loop" );
	
	node = getstruct( node.target, "targetname" );
	
	node anim_generic_reach( self, "exposed_idle_reactB" );
	node thread anim_generic( self, "exposed_idle_reactB" );	
	length = getanimlength( getanim_generic( "exposed_idle_reactB" ) );
	self playsound( "generic_pain_american_" + randomintrange( 1,9 ) );
	
	wait length - .75;
	self stopanimscripted();
	
	//Go!! Go!!
	self delaythread( 0.5, ::dialogue_queue, "dcemp_fly_gogo" );
		
	self disable_heat_behavior();
	self enable_arrivals();
	node.origin = self.origin;
	node.angles = self.angles + ( 0,40,0 );
	node anim_generic_run( self, "stand_2_run_R" );
	node = getnode( "corner_macey_hide_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 200;	
	self.moveplaybackrate = 1.1;
	
	self waittill( "goal" );
	
	self enable_pain();
	self ent_flag_set( "street_hide" );
	self.moveplaybackrate = 1.0;
}

street_setup_stuff()
{
	array_thread( getentarray( "meetup_allies", "targetname" ), ::add_spawn_function, ::street_meetup_allies );	
	
	getent( "street_btr", "targetname" ) add_spawn_function( ::street_btr_scene );
	getent( "street_crash_motorcycle", "targetname" ) thread street_crash_motorcycle();
	level.fallguy = getent( "street_guy_fall_guy", "targetname" );
	level.fallguy add_spawn_function( ::street_guy_fall_guy );
	
	array_thread( getentarray( "street_crash_heli", "script_noteworthy" ), ::street_crash_helis );
		
	array_thread( getentarray( "corner_truck_engine_crash", "targetname" ), ::corner_truck_engine_crash );
	thread corner_plane_crash();
						
	clip = getent( "hide_clip", "targetname" );
	clip connectpaths();
	clip notsolid();
	
	//spawn btr
	add_wait( ::flag_wait, "emp_entity_cleanup_done" );
	add_func( ::activate_trigger_with_targetname, "street_btr_spawner" );
	thread do_wait();
}

street_meetup_allies()
{		
	self init_meetup_allies();
		
	if( self.script_noteworthy == "marine3" )
	{
		self ent_flag_set( "street_hide" );
		return;
	}
	
	self.team = "neutral";
	node = getstruct( self.target, "targetname" );
	node anim_generic_first_frame( self, "favela_run_and_wave" );
				
	flag_wait( "street_marine2_hide" );
	self.team = "allies";
	
	node anim_generic_gravity_run( self, "favela_run_and_wave" );
	node = getnode( node.target, "targetname" );
	
	self follow_path( node );
	self ent_flag_set( "street_hide" );
}

init_meetup_allies()
{
	add_team( self );
	
	self ent_flag_init( "street_hide" );
	self thread magic_bullet_shield();
	self set_pushplayer( true );
	self disable_pain();	
	self pathrandompercent_zero();
	self walkdist_zero();
}


/************************************************************************************************************/
/*													CORNER													*/
/************************************************************************************************************/
#using_animtree( "generic_human" );
corner_main()
{			
	flag_wait( "corner_main" );
		
	foreach( member in level.team )
		member.walkDistFacingMotion = 0;
			
	array_thread( level.team, ::enable_arrivals );
	array_thread( level.team, ::enable_exits );
	array_thread( level.team, ::enable_pain );
					
	flag_wait( "corner_look_outside" );
	thread corner_dead_check();
		
	level.player blend_movespeedscale( .77 );
	//What the hell was that?!			
	level.team[ "marine1" ] dialogue_queue( "dcemp_ar1_whatwasthat" );
	//Stay here.	
	level.foley add_wait( ::dialogue_queue, "dcemp_fly_stayhere" );
	//You're goin' out there? Are you nuts?			
	level.dunn add_func( ::delaythread, 0.5, ::dialogue_queue, "dcemp_cpd_younuts" );
	thread do_wait();
		
	level.foley thread corner_foley_go();
	
	flag_wait( "corner_moveout" );		
	
	objective_state( level.objnum, "done" );
	level.objnum++;
	objective_add( level.objnum, "active", &"DCEMP_OBJ_FOLLOW_SGT_FOLEY", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
			
	thread corner_dialogue();
	
	level.team[ "marine3" ] thread anim_generic( level.team[ "marine3" ], "scout_sniper_price_wave" );
	level.team[ "marine3" ] delaycall( .5, ::setlookatentity, level.player );
	length = getanimlength( getanim_generic( "scout_sniper_price_wave" ) );
	level.team[ "marine3" ] delaycall( length * .68, ::stopanimscripted );
	level.team[ "marine3" ] delaycall( length * .45, ::setlookatentity );
	
	level.team[ "marine1" ] thread corner_marine1_go();
	wait .5;
	level.team[ "dunn" ] thread corner_dunn_go();
	
	wait 6.0;
	
	level.team[ "marine3" ] thread corner_marine3_go();
	wait .5;
	level.team[ "marine2" ] thread corner_marine2_go();
	
	
	add_wait( ::array_wait, level.team, "corner_at_plane" );
	add_func( ::flag_set, "meetup_main" );
	thread do_wait();
}

corner_dialogue()
{
	wait 4.5;
	marine1 = level.team[ "marine1" ];
	////What happened here?	
	marine1 dialogue_queue( "dcemp_ar1_thisisweird" );
	wait .5;
	//It’s so…quiet.	
	level.dunn dialogue_queue( "dcemp_cpd_soquiet" );
	//Hey! What the…? My red dot's not working.	
	level.dunn dialogue_queue( "dcemp_cpd_heywhatthe" );
	//Mine's down too, this is weird, bro.			
	marine1 dialogue_queue( "dcemp_ar1_minedowntoo" );
	
	wait .5;
	
	//Looks like optics are down…comms too.  There's not even a street light for blocks.
	level.foley thread dialogue_queue( "dcemp_fly_empblast" );		
	wait 4.75;
	level.foley stopsounds();
}

corner_foley_go()
{
	self enable_cqbwalk();
	
	door = GetEnt( "corner_door", "targetname" );
	door thread corner_palm_style_door_open( "door_wood_slow_creaky_open" );
	
	node = getent( "corner_doornode", "targetname" );
	self linkto( node );
	node delaycall( 3.25, ::movez, -8, .25 );
	node anim_generic_run( self, "hunted_open_barndoor_flathand" );
		
	node = getent( "corner_lookout", "targetname" );
	
	node.angles = self.angles;
	node.origin = self.origin;
	self linkto( node );
	
	node delaycall( .25, ::rotateyaw, -15, .5 );
	node delaycall( 1.5, ::movez, -7, .25 );
	node anim_generic( self, "combatwalk_F_spin" );
	self unlink();
	
	self setgoalpos( self.origin );
	
	//It's over! Come on, we still have a war to fight.			
	self setlookatentity( level.team[ "marine1" ] );
	self delaycall( 3, ::setlookatentity );
	self thread dialogue_queue( "dcemp_fly_wartofight" );
		
	thread flag_set_delayed( "corner_moveout", 1.0 );
	
	node.origin = self.origin;
	node.angles = self.angles - (0,45,0);
	self orientmode( "face angle", self.angles[1] - 45 );
	wait .5;		
	
	node anim_generic_run( self, "cqb_stand_signal_move_out" );
		
	node = getstruct( "corner_anim2a", "targetname" );
	node anim_generic_reach( self, "patrol_jog_360_once" );
	node anim_generic_run( self, "CQB_walk_turn_9" );
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "patrol_jog_360_once" );
	node thread anim_generic_gravity( self, "patrol_jog_360_once" );
	
	length = getanimlength( getanim_generic( "patrol_jog_360_once" ) );
	wait length * .79;
	self clearanim( getanim_generic( "patrol_jog_360_once" ), .2);
	self notify( "killanimscript" );
	
	self disable_cqbwalk();
		
	self.alertlevel = "noncombat";
	
	node = getstruct( node.target, "targetname" );	
	node anim_reach_solo( self, "hunted_woundedhostage_check" );
	
	guys = [];
	guys[ guys.size ] = self;
	guys[ guys.size ] = level.corner_dead_check_guy;
	
	node notify( "stop_loop" );
	node anim_single( guys, "hunted_woundedhostage_check" );
	//dammit
	self thread dialogue_queue( "dcemp_fly_dammit" );
	self notify( "corner_at_plane" );
	
	node anim_generic_run( self, "DCemp_wounded_check_end" );
	self.a.pose	= "stand";
	self setgoalpos( self.origin );
}

corner_marine1_go()
{
	self enable_cqbwalk();
	
	node = getstruct( "corner_doorexit", "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_6" );
	node anim_generic_run( self, "CQB_walk_turn_6" );
	self anim_generic_gravity_run( self, "CQB_walk_turn_9" );
	
	
	node = getstruct( "corner_anim1", "targetname" );
	node anim_generic_reach( self, "patrol_jog_look_up_once" );
	
	node anim_generic_run( self, "patrol_jog_look_up_once" );
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_9" );
	node anim_generic_run( self, "CQB_walk_turn_9" );
	
	self disable_cqbwalk();
	self set_generic_run_anim_array( "casual_killer_jog" );
	
	self.alertlevel = "noncombat";
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "casual_killer_jog_stop" );
	
	level endon( "meetup_go" );
	self notify( "corner_at_plane" );
	
	self anim_generic_run( self, "casual_killer_jog_stop" );
	self setgoalpos( self.origin );
}

corner_marine2_go()
{
	self enable_cqbwalk();
	
	node = getstruct( "corner_doorexit3", "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_7" );
	node anim_generic_run( self, "CQB_walk_turn_7" );
	self anim_generic_gravity_run( self, "CQB_walk_turn_9" );
	
	self set_pushplayer( false );
	
	self disable_cqbwalk();
	waittillframeend;
	self set_generic_run_anim( "combat_jog" );	
	
	node = getstruct( "corner_anim1", "targetname" );
	node anim_generic_reach( self, "patrol_jog_360_once" );
	
	node anim_generic_run( self, "patrol_jog_360_once" );
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_9" );
	
	self notify( "corner_at_plane" );
	
	node anim_generic_run( self, "CQB_walk_turn_9" );
		
	self disable_cqbwalk();
		
	node = getnode( "corner_anim4", "targetname" );
		
	self follow_path( node );
	
	self set_pushplayer( true );
}

corner_marine3_go()
{
	self enable_cqbwalk();
	
	node = getstruct( "corner_doorexit2", "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_6" );
	node anim_generic_run( self, "CQB_walk_turn_6" );
	
	self set_pushplayer( false );	
	
	self disable_cqbwalk();
	waittillframeend;
	self set_generic_run_anim( "combat_jog" );	
			
	node = getstruct( "corner_anim5b", "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_9" );
	node anim_generic_run( self, "CQB_walk_turn_9" );
	
	self disable_cqbwalk();
	
	node = getnode( "corner_anim5", "targetname" );
		
	self follow_path( node );
	
	self set_pushplayer( true );
	
	self notify( "corner_at_plane" );
}

corner_dunn_go()
{
	self enable_cqbwalk();
	
	node = getstruct( "corner_doorexit", "targetname" );
	node anim_generic_reach( self, "CQB_walk_turn_6" );
	node anim_generic_run( self, "CQB_walk_turn_6" );
	self anim_generic_gravity_run( self, "CQB_walk_turn_9" );
	
	node = getstruct( "corner_anim3", "targetname" );
	node anim_generic_reach( self, "combatwalk_F_spin" );
	node anim_generic_run( self, "combatwalk_F_spin" );
	
	self disable_cqbwalk();
	self set_generic_run_anim_array( "casual_killer_jog" );
	
	self.alertlevel = "noncombat";
	
	//Whoa...check it out, man.		
	self thread dialogue_queue( "dcemp_cpd_checkitout" );
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "casual_killer_jog_stop" );
	
	level endon( "meetup_go" );
	self notify( "corner_at_plane" );
	
	node anim_generic_run( self, "casual_killer_jog_stop" );
	self setgoalpos( self.origin );
}

corner_plane_crash()
{
	getent( "corner_engine", "targetname" ) thread corner_engine_crash();	
	
	flag_wait( "street_crash_heli_done" );
	
	wait 2.5;
	
	flag_set( "corner_start_crash_scene" );
	
	node = getent( "corner_crash_plane_link", "targetname" );
	node playsound( "trophy_explode" );
	earthquake( 0.25, 1.5, node.origin, 5000 );
	quakeobj = spawn( "script_origin", level.player.origin + (0,0,500) );
	
	quakeobj PlayRumbleLoopOnEntity( "steady_rumble" );
	quakeobj movez( 400, 1.5 );
	quakeobj delaycall( 2, ::delete );
	noself_delaycall( 1.5, ::stopallRumbles );

	setsaveddvar( "r_spotlightstartradius", "100" );
	setsaveddvar( "r_spotlightEndradius", "1200" );
	setsaveddvar( "r_spotlightfovinnerfraction", "0" );
	setsaveddvar( "r_spotlightexponent", "0" );
	setsaveddvar( "r_spotlightBrightness", "16" );
		
	node = getstruct( "corner_plane_fx_light", "targetname" );
	model = spawn( "script_model", node.origin );
	model.angles = node.angles;
	model setmodel( "tag_origin" );
	playfxontag( level._effect[ "planecrash_spotlight" ], model, "TAG_ORIGIN" );
	delaythread( .5, ::lerp_savedDvar, "r_spotlightBrightness", 0, 3 );
	
	model delaycall( 3.75, ::delete );
	
	wait .25;
	
	array_thread( getstructarray( "corner_plane_launch", "targetname" ), ::corner_plane_launch );
	thread flag_set_delayed( "corner_engine_crash", .5 );
	wait 1.0;
	
	exploder( "corner_fire_streaks" );
	delaythread( .75, ::exploder, "corner_fire_streaks" );
	array_thread( getstructarray( "corner_plane_launch", "targetname" ), ::corner_plane_launch );
				
	flag_wait( "corner_engine_hit" );
	
	exploder( "corner_fire_trails" );
	corner_show_damage();
}

/************************************************************************************************************/
/*													MEETUP													*/
/************************************************************************************************************/
meetup_main()
{
	getent( "meetup_runner", "targetname" ) add_spawn_function( ::meetup_runner );
	
	flag_wait( "meetup_main" );
	
	level.foley thread meetup_foley();
	level.dunn thread meetup_dunn();
	level.team[ "marine1" ] thread meetup_marine1();
	level.team[ "marine2" ] thread meetup_marine2();
	level.team[ "marine3" ] thread meetup_marine3();
	
	flag_wait( "meetup_show_guys" );
	
	thread play_sound_in_space( "elm_thunder_distant", level.player.origin + ( 0, 0, 60 ) );
	
	delaythread( 3, maps\_weather::rainMedium, 20 );
	delaythread( 0, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
	
	wait 1;
	
	thread autosave_by_name( "meetup_main" );
	
	//Huah. We gotta regroup with whoever's left out there. Corporal Dunn, take point. 			
	level.foley setlookatentity( level.team[ "marine1" ] );
	level.foley delaycall( 2, ::setlookatentity );
	level.foley delaycall( 2.75, ::setlookatentity, level.dunn );
	level.foley delaycall( 5.5, ::setlookatentity );
	level.foley dialogue_queue( "dcemp_fly_regroup" );
	//Huah.		
	level.dunn thread dialogue_queue( "dcemp_cpd_huah2" );
	
	
	array_thread( level.team, ::set_ignoreme, true );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::walkdist_zero );
	
	flag_set( "meetup_moveout" );
	SetSavedDvar( "cg_crosshairEnemyColor", "0" );
	
	thread meetup_ironsite_dialogue();
	
	delaythread( 4, ::activate_trigger, "meetup_runner", "target" );
	
	flag_wait( "meetup_challenge_start" );
	
	aimobj = spawn( "script_origin", level.runner geteye() + (0,0,16) );
	aimobj linkto( level.runner );
	level.dunn setentitytarget( aimobj );
	level.dunn enable_dontevershoot();
	level.dunn set_ignoreall( false );
	
	//"Star"!	
	level.dunn dialogue_queue( "dcemp_cpd_star" );
	flag_set( "meetup_challenge_done" );	
	
	array_thread( level.team, ::clear_run_anim );
	
	wait 1.25;
	//"Star", or we will fire on you!	
	level.dunn dialogue_queue( "dcemp_cpd_willfire" );
	
	thread meetup_runner_threads();
	flag_set( "meetup_runner_safe" );
	
	wait .65;
	
	//I don't remember the damn countersign all right? I'm just a runner! Don't shoot!		
	level.runner dialogue_queue( "dcemp_ar3_dontshoot" );
	
	SetSavedDvar( "cg_crosshairEnemyColor", "1" );
	
	wait .5;
	//The proper response is "Texas", soldier. What'dya got?	
	level.foley dialogue_queue( "dcemp_fly_properresponse" );	
						
	flag_wait( "lobby_main" );
	
	aimobj delete();
}

meetup_ironsite_dialogue()
{
	wait 3.75;
	level.team[ "marine1" ] dialogue_queue( "dcemp_ar1_findironsite" );
	level.team[ "marine2" ] dialogue_queue( "dcemp_ar1_huah" );
}

meetup_foley()
{
	flag_wait( "meetup_moveout" );
	wait 1.5;
	
	meetup_moveout( "corner_flash_1" );
}
	
meetup_dunn()
{		
	flag_wait( "meetup_moveout" );
	
	self enable_heat_behavior();
	self clear_run_anim();
	
	node = getnode( "corner_flash_3", "targetname" );
	self.goalradius = 120;
	self setgoalnode( node );
	self waittill( "goal" );
	self disable_heat_behavior();
}
		
meetup_marine1()
{			
	flag_wait( "meetup_moveout" );
	wait 2;
	
	meetup_moveout( "corner_flash_4" );
}

meetup_marine2()
{
	flag_wait( "meetup_moveout" );
	
	wait 3;
	
	self set_generic_run_anim_array( "casual_killer_jog" );
		
	node = getnode( "corner_flash_5", "targetname" );
	self setgoalnode( node );	
}
	
meetup_marine3()
{
	flag_wait( "meetup_moveout" );
	
	wait 1.5;
	
	self set_generic_run_anim_array( "casual_killer_jog" );
		
	node = getnode( "corner_flash_2", "targetname" );
	self setgoalnode( node );	
}

meetup_walk_to_guys( node, name )
{
	struct = getstruct( name, "targetname" );
		
	node.origin = self.origin;
	node.angles = vectortoangles( struct.origin - self.origin );
	self orientmode( "face angle", node.angles[ 1 ] );
	self setgoalpos( self.origin );
	wait .5;
	node thread anim_generic_gravity_run( self, "patrol_bored_2_walk" );
	
	self clear_run_anim();
	self disable_arrivals();
	self disable_exits();
	
	waittillframeend;
	self set_generic_run_anim( "patrol_bored_patrolwalk" );	
		
	self setgoalpos( struct.origin );
	self.goalradius = 16;
}

meetup_walk_stop()
{
	self endon( "movingout" );
	
	self waittill( "goal" );
	self anim_generic_gravity( self, "patrol_bored_walk_2_bored" );
	self setgoalpos( self.origin );	
}

meetup_moveout( name )
{
	self setlookatentity();
	
	self notify( "movingout" );
	
	self clear_run_anim();
	self enable_arrivals();
		
	waittillframeend;
	self set_generic_run_anim_array( "casual_killer_jog" );
	
	node = getnode( name, "targetname" );
	ent = spawn( "script_origin", self.origin );
	ent.angles = self.angles;
	
	self linkto( ent );
	self disable_exits();
	
	time = .75;
	ent rotateto( vectortoangles( node.origin - ent.origin ), time, time );
	ent thread anim_generic_run( self, "casual_killer_jog_start" );
	
	ent waittill( "rotatedone" );
	self unlink();
	self setgoalnode( node );
	ent delete();
			
	self delaythread( 3, ::enable_exits );	
}

meetup_runner()
{
	level.runner = self;
	self.animname = "runner";
	self set_pushplayer( true );
	self thread magic_bullet_shield();
	self.name = "";
	
	node = getstruct( self.target, "targetname" );
	
	door = getent( "meetup_door_left", "targetname" );
	door connectpaths();
	
	time = 1.25;
	door delaycall( 2.0, ::rotateyaw, -90, time, 0, time );
	door delaycall( 2.5 + time, ::disconnectpaths );
	
	delaythread( 1.75, ::exploder, "meetup_dooropen" );	
	
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	self pathrandompercent_zero();
	self walkdist_zero();
	
	node anim_generic_run( self, "cargoship_open_cargo_guyL" );	
	
	node = getent( node.target, "targetname" );
	self.goalradius = 80;
	self setgoalpos( node.origin );
	self waittill( "goal" );
	
	flag_set( "meetup_challenge_start" );
	
	node = getent( node.target, "targetname" );
	
	node anim_generic_reach( self, "run_pain_fallonknee" );
	node thread anim_generic_gravity( self, "run_pain_fallonknee" );
	length = getanimlength( getanim_generic( "run_pain_fallonknee" ) );
	wait length * .77;
	self stopanimscripted();
	
	self anim_generic_gravity( self, "run_2_crouch_90R" );
	self setgoalpos( self.origin );
		
	flag_wait( "meetup_runner_safe" );
	self.name = "Pvt. Vaughan";

	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "DCemp_run_sequence_runner" );
	
	flag_set( "meetup_do_scripted_scene" );
	
	node anim_generic_gravity_run( self, "DCemp_run_sequence_runner" );
		
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 64;
	
	flag_wait( "meetup_runner_sprint" );
	
	self enable_heat_behavior();
	
	self waittill( "goal" );
	
	self stop_magic_bullet_shield();
	self delete();
}

/************************************************************************************************************/
/*													LOBBY													*/
/************************************************************************************************************/
lobby_main()
{
	thread handle_sunlight();
	thread vision_set_lobby();
	
	add_wait( ::trigger_wait_targetname, "lobby_vision_change" );
	level.player add_func( ::blend_movespeedscale, .65 );
	thread do_wait();
	
	add_wait( ::flag_wait, "lobby_robo_death" );
	level.player add_func( ::blend_movespeedscale, .77 );
	thread do_wait();
	
	flag_wait( "lobby_main" );
	
	level.player.ignoreme = false;
	array_thread( level.team, ::clear_run_anim );
	array_thread( level.team, ::enable_exits );
	array_thread( level.team, ::enable_arrivals );
	array_call( level.team, ::setlookatentity );
	
	thread autosave_by_name( "lobby_main" );
	
	//You heard the man, lets go.	
	level.foley delaythread( .5, ::dialogue_queue, "dcemp_fly_heardtheman" );
	
	level.foley thread anim_generic_gravity( level.foley, "exposed_tracking_turn180L" );
	
	wait 1.5;
	
	objective_string_NoMessage( level.objnum, &"DCEMP_OBJ_WHISKEY_HOTEL" );
				
	lobby_moveout();
		
	thread lobby_ambush();
	
	flag_set( "office_main" );
}

lobby_ambush()
{
	level.foley add_wait( ::waittill_msg, "reached_path_end" );
	level.dunn add_wait( ::waittill_msg, "reached_path_end" );
	add_wait( ::flag_wait, "meetup_movein" );
	do_wait();
	//Dunn, you're up.		
	level.foley thread dialogue_queue( "dcemp_fly_dunnyoureup" );
	
	wait 1.5;
	//Huah.		
	level.dunn thread dialogue_queue( "dcemp_cpd_huah2" );
	
	flag_set( "lobby_check" );	
	flag_wait( "lobby_clear" );	
	
	wait 1;
	//I got our six.	
	level.team[ "marine2" ] dialogue_queue( "dcemp_ar2_gotoursix" );
	//Copy that. 		
	level.foley thread dialogue_queue( "dcemp_fly_copythat" );	
	
	flag_wait( "lobby_robo_death" );
	
	
	team = array_remove( level.team, level.dunn );
	team = array_remove( team, level.foley );
	
	array_thread( team, ::set_ignoreme, false );
	array_thread( team, ::set_ignoreall, false );
	array_thread( team, ::walkdist_reset );
	array_thread( team, ::enable_exits );
	array_thread( team, ::enable_arrivals );
	array_thread( team, ::pathrandompercent_reset );
	array_thread( team, ::set_pushplayer, false );
	array_thread( team, ::enable_pain );
	
	
	trigger_wait_targetname( "office_ally_color_2" );
	flag_set( "office_go_red" );
	
	team = array_removedead( team );
	array_thread( team, ::set_force_color, "red" );
	SetSavedDvar( "ai_friendlyFireBlockDuration", "2000" );
}

lobby_moveout()
{
	nodes = getnodearray( "lobby_start_nodes", "targetname" );
	
	lobby_go = [];
	lobby_go[ "dunn" ] 		= ::lobby_go_dunn;
	lobby_go[ "foley" ] 	= ::lobby_go_foley;
	lobby_go[ "marine3" ] 	= ::lobby_go_robo;
	lobby_go[ "marine2" ] 	= ::lobby_go_rear;
	lobby_go[ "marine1" ] 	= ::lobby_go_extra;
	
	foreach( node in nodes )
	{
		time = 0;
		name = node.script_noteworthy;
		switch( name )
		{
			case "dunn":
				time = 0;
				break;	
			case "marine2":
				time = .5;
				break;	
			case "marine3":
				time = .75;
				break;	
			case "marine1":
				time = .15;
				break;	
			case "foley":
				time = .35;
				break;
		}	
		
		level.team[ name ] allowedstances( "stand", "crouch", "prone" );
		level.team[ name ] delaythread( time, lobby_go[ name ], node );
	}	
}

lobby_go_dunn( node )
{
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	self notify( "reached_path_end" );
	
	flag_wait( "lobby_check" );
	
	self enable_cqbwalk();
	
	node = getstruct( node.target, "targetname" );
	
	self thread anim_generic( self, "corner_standR_trans_CQB_OUT_8" );
	wait 2.3;
	self stopanimscripted();
	
	//node anim_generic_reach( self, "combatwalk_F_spin" );
	
	node thread anim_generic_run( self, "combatwalk_F_spin" );
	length = getanimlength( getanim_generic( "combatwalk_F_spin" ) );
	
	wait length - 1.5;
	
	//Clear.		
	self thread dialogue_queue( "dcemp_cpd_clear" );
	
	thread flag_set_delayed( "lobby_clear", 1 );
	
	node = getnode( node.target, "targetname" );
	self follow_path( node );
	
	self walkdist_reset();
	self enable_exits();
	self enable_arrivals();
	self disable_pain();
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	self disable_cqbwalk();
	
	flag_wait( "lobby_robo_death" );
	
	//Son of a....
	self delaythread( .5, ::dialogue_queue, "dcemp_cpd_sonofa" );
	
	self set_ignoreme( false );
	self set_ignoreall( false );
	self enable_dontevershoot();
			
	self thread anim_generic( self, "corner_standR_flinchB" );
	length = getanimlength( getanim_generic( "corner_standR_flinchB" ) );
	wait length * .65;
	self stopanimscripted();
	
	node = getstruct( "lobby_door_open2a", "targetname" );
			
	link = spawn( "script_origin", self.origin );
	link.angles = (0,225,0);
	link thread anim_generic_run( self, "exposed_tracking_turn180L" );
	
	thread lobby_dunn_threads_foley_flash();
		
	link waittill( "exposed_tracking_turn180L" );
	
	node thread anim_generic_run( self, "breach_kick_kickerR1_enter" );
	
	wait .25;
	
	self disable_dontevershoot();
	self set_force_color( "red" );	
	
	wait .05;
	self.goalradius = 32;
	
	self add_wait( ::waittill_msg, "goal" );
	add_wait( ::flag_wait, "office_go_red" );
	do_wait_any();
	
	self pathrandompercent_reset();
	self enable_pain();
	self enable_surprise();
	self enable_bulletwhizbyreaction();
	self set_pushplayer( false );
}

lobby_dunn_threads_foley_flash()
{
	wait 1.15;
	
	if( level.foley ent_flag( "lobby_door_ready" ) )
		level.foley.lobby_node thread anim_generic( level.foley, "CQB_stand_grenade_throw" );
}

lobby_go_foley( node )
{
	self ent_flag_init( "lobby_door_ready" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	self notify( "reached_path_end" );
		
	flag_wait( "lobby_clear" );
	self enable_cqbwalk();
		
	wait 2;
	
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "patrol_jog_360_once" );
	node thread anim_generic( self, "patrol_jog_360_once" );
	length = getanimlength( getanim_generic( "patrol_jog_360_once" ) );
	wait ( length * .68 ) - .05;
	
	self stopanimscripted();
	
	node = getnode( node.target, "targetname" );
	
	self.lobby_node = node;	
	self follow_path( node );
	flag_set( "lobby_door_ready" );
	self disable_cqbwalk();
	
	temp = getstruct( "lobby_arrive_foley", "targetname" );
	temp anim_generic_reach( self, "run_2_stand_90R" );
	temp anim_generic( self, "run_2_stand_90R" );
	
	self.goalradius = 8;
	self setgoalnode( node );
	self ent_flag_set( "lobby_door_ready" );
		
	flag_wait( "office_player_near_door" );
	self thread anim_generic( self, "stand_exposed_wave_down" );
	
	self disable_pain();
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	
	flag_wait( "lobby_robo_death" );
	
	//Contaaact!!!		
	self delaythread( 1.5, ::dialogue_queue, "dcemp_fly_contact" );
	self anim_generic_gravity( self, "exposed_idle_reactB" );
	
	flag_wait( "lobby_door_kick" );
	
	self walkdist_reset();
	self set_ignoreme( false );
	self set_ignoreall( false );
	self enable_arrivals();
		
	wait 2.25;
	
	node thread anim_generic( self, "stand_2_run_F_2" );
	length = getanimlength( getanim_generic( "stand_2_run_F_2" ) );
	wait length * .82;
	
	self stopanimscripted();
	
	self thread anim_generic_run( self, "run_turn_R45" );
				
	self delaythread( 2, ::enable_exits );
	
	self set_force_color( "red" );
	wait .05;
	self.goalradius = 32;
	
	self add_wait( ::waittill_msg, "goal" );
	add_wait( ::flag_wait, "office_go_red" );
	do_wait_any();
	
	self pathrandompercent_reset();
	self enable_pain();
	self enable_surprise();
	self enable_bulletwhizbyreaction();
	self set_pushplayer( false );
}

lobby_go_robo( node )
{
	self disable_exits();
	self anim_generic_gravity_run( self, "stand_2_run_L" );
	self anim_generic_gravity_run( self, "run_turn_L45" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	self enable_exits();
	
	self notify( "reached_path_end" );
	
	flag_wait( "lobby_clear" );
	self enable_cqbwalk();
			
	node = getnode( node.target, "targetname" );
	
	self follow_path( node );
	self disable_cqbwalk();
	
	flag_wait( "lobby_door_ready" );	
	flag_wait( "office_player_near_door" );
	
	wait .5;
	
	if( level.foley ent_flag( "lobby_door_ready" ) )
	{
		self setlookatentity( level.foley );
		self delaycall( 1, ::setlookatentity );	
	}
	wait .5;
	
	node = getstruct( "lobby_door_open", "targetname" );
	door = getent( "lobby_door_left", "targetname" );
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );
	
	level.team[ "marine3" ] delaythread( 1.5, ::dialogue_queue, "dcemp_ar3_star" );
	node thread anim_generic( self, "hunted_open_barndoor" );
	door thread hunted_style_door_open( "door_wood_slow_creaky_open" );
	
	length = getanimlength( getanim_generic( "hunted_open_barndoor" ) );
	wait ( length * .77 ) - .1;
	
	self thread lobby_enemy_suppressive_fire();
	
	wait .1;
	
	node = spawnstruct();
	node.origin = self.origin;
	node.angles = (0,48,0);
	
	flag_set( "lobby_robo_death" );
	
	node thread anim_generic( self, "airport_security_guard_pillar_death_R" );
	length = getanimlength( getanim_generic( "airport_security_guard_pillar_death_R" ) );
	
	self delaythread( .1, animscripts\shared::DropAllAIWeapons );
	
	wait length - .1;
	
	self stop_magic_bullet_shield();	
	self.allowdeath = true;
	self.nointerrupt = true;	
	self.a.nodeath = 1;
	self.noragdoll = 1;
	self kill();
}

lobby_go_rear( node )
{
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	self notify( "reached_path_end" );
	
	flag_wait( "lobby_clear" );
	
	self enable_cqbwalk();
	
	wait .5;
		
	node = getnode( "lobby_lookaround_node", "target" );
	
	self.goalradius = 16;
	self setgoalnode( node );
	
	wait 5.5;
	self set_pushplayer( false );
	
	node = getnode( "lobby_rear_security", "targetname" );
	self follow_path( node );
	self disable_cqbwalk();
	
	if( flag( "office_go_red" ) )
		return;	
	level endon( "office_go_red" );
	
	flag_wait( "lobby_door_kick" );
	
	node = getnode( "office_entry_cover_right", "targetname" );
	self setgoalnode( node );
}

lobby_go_extra( node )
{
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	self waittill( "goal" );
	
	self notify( "reached_path_end" );
	
	flag_wait( "lobby_clear" );
	self enable_cqbwalk();		
	wait 1.65;
	
	node = getnode( node.target, "targetname" );
	self follow_path( node );
	self disable_cqbwalk();
		
	if( flag( "office_go_red" ) )
		return;	
	level endon( "office_go_red" );
	
	flag_wait( "lobby_door_kick" );
	
	wait 2.5;
	
	node = getnode( "lobby_end_dunn", "targetname" );
	self setgoalnode( node );
}


/************************************************************************************************************/
/*													OFFICE													*/
/************************************************************************************************************/
office_main()
{
	thread handle_color_advance( "office_ally_color_", 2, 6 );
	array_thread( getentarray( "office_enemies_wave1", "script_noteworthy" ), ::add_spawn_function, ::office_enemies_wave1 );
	array_thread( getentarray( "office_enemies_wave1_runner", "targetname" ), ::add_spawn_function, ::office_enemies_wave1_runner );
	getent( "office_flickerlight1", "targetname" ) thread flickerlight_flares();	
	
	snd = getent( "office_suppressive_fire_target", "targetname" );				
	add_wait( ::flag_wait, "office_ally_color_1" );
	add_func( ::activate_trigger_with_targetname, "office_ally_color_1" );
	snd add_call( ::playsound, "scn_dcemp_interior_movement" );
	add_func( maps\_weather::rainHard, 15 );
	thread do_wait();
	
	flag_wait( "office_main" );
	
	//wave 1
	activate_trigger( "office_enemies_wave1", "target" );
	
	flag_wait( "lobby_robo_death" );
	flag_clear( "_weather_lightning_enabled" );
	
	delaythread( 1.5, ::autosave_by_name, "office_main" );
	
	thread battlechatter_on();
		
	//wait for certain number to die or player to run way too far
	enemies = get_living_ai_array( "office_enemies_wave1", "script_noteworthy" );
	add_wait( ::waittill_dead_or_dying, enemies, 2 );
	add_wait( ::trigger_wait, "office_enemies_wave1_runner", "target" );
	add_abort( ::flag_wait, "office_ally_color_4" );
	do_wait();
	
	//turn off intro fx and turn on rain fx
	fx_intro_pause();
	flag_set( "rain_fx" );
		
	//wave 2
	enemies = get_living_ai_array( "office_enemies_wave1", "script_noteworthy" );
	spawners = getentarray( "office_enemies_wave2", "targetname" );
	for( i = 0; i < enemies.size; i++ )
		spawners[ i ] delete(); 
	
	//blue retreat 1	
	array_thread( enemies, ::set_force_color, "blue" );
	activate_trigger_with_targetname( "office_enemy_color_1" );
	activate_trigger( "office_enemies_wave2", "target" );
	
	//make 1 friendly killable( 3 have bs )
	level.team[ "marine1" ] stop_magic_bullet_shield();
	wait .1;
	
	//grab guys and...
	enemies = get_living_ai_array( "office_enemies_wave1", "script_noteworthy" );
	enemies = array_combine( enemies, get_living_ai_array( "office_enemies_wave2", "script_noteworthy" ) );
	
	//...do the next two retreats
	//retreat 1
	add_wait( ::waittill_dead_or_dying, enemies, 4 );
	add_func( ::activate_trigger_with_targetname, "office_enemy_color_2" );
		thread do_wait();
	
	//retreat 2
	add_wait( ::waittill_dead_or_dying, enemies, 8 );
	add_func( ::delaythread, .2, ::activate_trigger_with_targetname, "office_enemy_color_3" );
	add_func( ::kill_random_teammate );
		thread do_wait();
	
	//wait for player to be near office 2	
	flag_wait( "office_predict_wave3" );
			
	thread autosave_by_name( "office2" );
			
	//wave 3
	enemies = get_living_ai_array( "office_enemies_wave1", "script_noteworthy" );
	enemies = array_combine( enemies, get_living_ai_array( "office_enemies_wave2", "script_noteworthy" ) );
	spawners = getentarray( "office_enemies_wave3", "targetname" );
	
	if( enemies.size < spawners.size )
	{
		for( i = 0; i < enemies.size; i++ )
			spawners[ i ] delete(); 
	}
	else
		array_call( spawners, ::delete );	
	
	add_wait( ::flag_wait, "office_enemies_wave1_dead" );	
	add_wait( ::flag_wait, "office_enemies_wave2_dead" );	
	add_wait( ::flag_wait, "office_enemies_wave3_dead" );	
	add_func( ::delaythread, 2, ::autosave_by_name, "office_done" );
	add_func( ::delaythread, 2, ::flag_set, "parking_main" );
	thread do_wait();
}

/************************************************************************************************************/
/*													PARKING													*/
/************************************************************************************************************/
parking_main()
{
	array_thread( getentarray( "parking_btr_guys", "targetname" ), ::add_spawn_function, ::parking_btr_guys );
		
	thread parking_drone();
	thread parking_dead_check();
	thread parking_high_spec();
	thread plaza_flare_fx();
	
	add_wait( ::flag_wait, "parking_vision_set" );
	add_func( ::vision_set_parking );
	level.player add_func( ::blend_movespeedscale, .8 );
	thread do_wait();
	
	add_wait( ::flag_wait, "parking_player_near_btr" );
	add_func( ::flag_set, "rain_fx2" );
	thread do_wait();
	
	flag_wait( "parking_main" );
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	
	lights = getentarray( "parking_lighting_primary", "script_noteworthy" );
	array_call( lights, ::setlightcolor, (.85, .85, 1) );
	flag_set( "spotlight_lightning" );
		
	thread battlechatter_off();
	
	if( level.start_point != "parking" )
	{
		level.team[ "marine2" ].script_noteworthy = "marine1";
		level.team[ "marine2" ].animname = "marine1";
		level.team[ "marine1" ] = level.team[ "marine2" ];
		level.team[ "marine2" ] = undefined;
	}
	
	parking_dialogue();
			
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::disable_pain );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::disable_ai_color );
	array_thread( level.team, ::ent_flag_init, "parking_start_at_node" );
	array_thread( level.team, ::ent_flag_init, "parking_start_at_node2" );
			
	level.foley thread parking_start( "parking_btr_node_foley" );
	level.dunn delaythread( 1, ::parking_start, "parking_btr_node_dunn" );
	level.team[ "marine1" ] delaythread( 1.5, ::parking_start, "parking_btr_node_marine1" );
	
	flag_clear( "_weather_lightning_enabled" );
	
	parking_building_scene();
	
	array_thread( level.team, ::walkdist_zero );
	flag_set( "parking_moveout" );	
	flag_set( "_weather_lightning_enabled" );
	
	parking_dialogue2();
		
	flag_wait( "parking_btr_guys_dead" );
	
	thread autosave_by_name( "parking_lot_done" );
}

parking_dialogue()
{
	level endon( "parking_open_fire" );
	
	level.dunn dialogue_queue( "dcemp_cpd_huaah" );
	wait .25;
	level.team[ "marine1" ] dialogue_queue( "dcemp_ar2_clear" );
	level.foley thread dialogue_queue( "dcemp_fly_roomclear" );	
}

parking_dialogue2()
{
	level endon( "parking_open_fire" );
	
	array_wait( level.team, "parking_start_at_node2" );
		
	wait 1;
	
	//Smoke 'em.			
	level.foley dialogue_queue( "dcemp_fly_smokeem" );

	flag_set( "parking_open_fire" );
}

parking_building_scene()
{
	level endon( "parking_open_fire" );
	
	level.foley waittill( "parking_start_at_node" );
	flag_wait( "parking_vision_set" );
	
	level thread dcemp_lightningFlash( "triple" );
		
	level.foley dialogue_queue( "dcemp_fly_oldexecbuilding" );
	level.dunn thread dialogue_queue( "dcemp_cpd_gottagoout" );
}

parking_start( name )
{
	self thread parking_open_fire();
	
	node = getnode( name, "targetname" );
	self parking_start_moveup( node );
	
	self parking_traverse_from_office();
	
	node = getnode( node.target, "targetname" );
		
	switch( self.script_noteworthy )
	{
		case "marine1":
			self thread parking_go_marine1( node );
			self thread parking_backup_marine1( node );
			break;	
		case "dunn":
			self thread parking_go_dunn( node );
			self thread parking_backup_dunn( node );
			break;	
		case "foley":
			self thread parking_go_foley( node );
			self thread parking_backup_foley( node );
			break;	
	}
}	

parking_start_moveup( node )
{
	if( flag( "parking_open_fire" ) )
		return;
	level endon( "parking_open_fire" );
		
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	self ent_flag_set( "parking_start_at_node" );
	
	flag_wait( "parking_moveout" );
			
	switch( self.script_noteworthy )
	{
		case "dunn":
			wait 1.5;
		case "marine1":
			wait .25;
		case "foley":
			wait .5;
			break;	
	}	
}

parking_open_fire()
{
	flag_wait_either( "parking_moveout3", "parking_open_fire" );
	
	node = getent( "parking_btr_aim_node", "targetname" );
	self setentitytarget( node );
	self enable_dontevershoot();
	self set_ignoreall( false );
	
	self.oldacc 		= self.accuracy;
	self.oldbase 		= self.baseaccuracy;
	self.oldgrenade 	= self.grenadeammo;
	self.baseaccuracy 	= 100;
	self.accuracy 		= 100;
	self.grenadeammo 	= 0;
	
	flag_wait( "parking_open_fire" );
	
	while( !flag( "parking_btr_guys_dead" ) )
	{
		flashorigin = self gettagorigin( "TAG_FLASH" );
		vec1 = vectornormalize( node.origin - flashorigin );
		vec2 = anglestoforward( self gettagAngles( "TAG_FLASH" ) );
		if( vectordot( vec1, vec2 ) > .7 )
			self shoot();
		else 
		if( !player_looking_at( self geteye() ) && distancesquared( self.origin, level.player.origin ) > squared( 512 ) )
		{
			array = bullettrace( self geteye(), node.origin, false, self );
			if( !isdefined( array[ "entity" ] ) || !isplayer( array[ "entity" ] ) )
				magicbullet( self.weapon, self geteye(), node.origin );
		}
		wait .1;		
	}
		
	self clearentitytarget();
	self notify( "stop_custom_aim" );
	self disable_dontevershoot();
	self.baseaccuracy 	= self.oldbase;
	self.accuracy 		= self.oldacc;
	self.grenadeammo 	= self.oldgrenade;	
}

parking_go_marine1( node )
{
	if( flag( "parking_open_fire" ) )
		return;
	level endon( "parking_open_fire" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_checking_body" );
	
	wait 1.0;
	
	node = getstruct( node.target, "targetname" );
	
	self enable_cqbwalk();
		
	node anim_generic_reach( self, "combatwalk_F_spin" );
	node anim_generic_run( self, "combatwalk_F_spin" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_moveout2" );
	self disable_cqbwalk();
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_player_near_btr" );
	
	//Got a visual on three tangos.	
	self thread dialogue_queue( "dcemp_ar2_gotavisual" );
	
	self.a.movement = "stop";
	self anim_generic( self, "CornerStndR_alert_signal_enemy_spotted" );
		
	flag_set( "parking_moveout3" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 8;
	
	self waittill( "goal" );
	
	//Clear shot.	
	self delaythread( 1, ::dialogue_queue, "dcemp_ar2_clearshot" );
	
	self ent_flag_set( "parking_start_at_node2" );
	
//	self anim_generic_run( self, "CornerCrR_alert_2_lean" );
//	self animcustom( ::CornerCrR_aim );
}

parking_go_foley( node )
{
	if( flag( "parking_open_fire" ) )
		return;
	level endon( "parking_open_fire" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_checking_body" );
	wait 2.5;
	
	self enable_cqbwalk();
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_moveout2" );
	self disable_cqbwalk();
	
	//Keep Quiet…			
	self delaythread( 2, ::dialogue_queue, "dcemp_fly_keepquiet" );
	
	node = getnode( "parking_moveup2_foley", "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_moveout3" );
	
	//Stay low, move into position.			
	self thread dialogue_queue( "dcemp_fly_moveintopos" );
	
	self.a.movement = "stop";
	self anim_generic( self, "CornerStndR_alert_signal_move_out" );
		
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
		
	self ent_flag_set( "parking_start_at_node2" );
}

parking_go_dunn( node )
{
	if( flag( "parking_open_fire" ) )
		return;
	level endon( "parking_open_fire" );
	
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_player_jumped_down" );
	
	node = getstruct( node.target, "targetname" );
	
	//Dunn. Check for vitals, we'll cover you.			
	level.foley thread dialogue_queue( "dcemp_fly_checkvitals" );
	
	node anim_reach_solo( self, "hunted_woundedhostage_check" );
	
	guys = [];
	guys[ guys.size ] = self;
	guys[ guys.size ] = level.parking_dead_check_guy;
	
	flag_set( "parking_checking_body" );
	
	node notify( "stop_loop" );
	node anim_single( guys, "hunted_woundedhostage_check" );
	
	//He's a gonner.			
	self thread dialogue_queue( "dcemp_cpd_gonner" );
	
	node anim_generic_run( self, "hunted_woundedhostage_check_soldier_end" );
	
	flag_set( "parking_moveout2" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 100;
	
	self waittill( "goal" );
	
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	flag_wait( "parking_moveout3" );
	
	node = getnode( "parking_moveup2_marine1", "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill( "goal" );
	
	self ent_flag_set( "parking_start_at_node2" );
	
	self anim_generic_run( self, "CornerStndR_alert_2_lean" );
	self animcustom( ::CornerStndR_aim );
}

parking_backup_marine1( node )
{
	self endon( "parking_start_at_node2" );	
	
	flag_wait( "parking_open_fire" );
	
	node = getstruct( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	
	self stopanimscripted();
	self setgoalnode( node );
	self.goalradius = 8;
}

parking_backup_foley( node )
{
	self endon( "parking_start_at_node2" );	
	
	flag_wait( "parking_open_fire" );
	
	node = getnode( "parking_moveup2_foley", "targetname" );
	node = getnode( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	
	self stopanimscripted();
	self setgoalnode( node );
	self.goalradius = node.radius;
}

parking_backup_dunn( node )
{
	self endon( "parking_start_at_node2" );	
	
	flag_wait( "parking_open_fire" );
	
	node = getstruct( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	node = getnode( "parking_moveup2_marine1", "targetname" );
	
	self stopanimscripted();
	self setgoalnode( node );
	self.goalradius = node.radius;
}

parking_btr_guys()
{
	//self endon( "death" );
	
	node = getstruct( self.target, "targetname" );	
	
	self.a.nodeath = true;
	self.skipdeathanim = true;
	self.noragdoll = true;
	self thread magic_bullet_shield();
	
	self addAIEventListener( "grenade danger" );
	//self addAIEventListener( "gunshot" );
	self addAIEventListener( "bulletwhizby" );
				
	self add_wait( ::waittill_msg, "death" );
	self add_wait( ::waittill_msg, "damage" );
	self add_wait( ::waittill_msg, "ai_event" );
	add_func( ::flag_set, "parking_open_fire" );
	add_func( ::flag_set, "parking_btr_shot_at" );
	thread do_wait_any();
	
	switch( self.script_animation )
	{
		case "DCemp_BTR_moment_guy1":
			node anim_generic( self, "DCemp_BTR_moment_climb_guy1" );
			if( !flag( "parking_open_fire" ) )
				node thread anim_generic_loop( self, "DCemp_BTR_moment_idle_guy1" );
			
			flag_wait( "parking_btr_shot_at" );
			self notify( "stop_loop" );
			self stopanimscripted();
				
			node thread anim_generic( self, self.script_animation );
			break;
		
		case "DCemp_BTR_moment_guy2":
			node anim_generic( self, "DCemp_BTR_moment_climb_guy2" );
			if( !flag( "parking_open_fire" ) )
				node thread anim_generic_loop( self, "DCemp_BTR_moment_idle_guy2" );
			
			flag_wait( "parking_btr_shot_at" );
			self notify( "stop_loop" );
			self stopanimscripted();
				
			node thread anim_generic( self, self.script_animation );
			break;
		
		case "DCemp_BTR_moment_guy3":
			parking_btr_extra_wait();
			
			node anim_generic( self, "DCemp_BTR_moment_climb_guy3" );
			if( !flag( "parking_open_fire" ) )
				node thread anim_generic_loop( self, "DCemp_BTR_moment_idle_guy3" );
			
			flag_wait( "parking_btr_shot_at" );
			self notify( "stop_loop" );
			self stopanimscripted();
							
			node thread anim_generic( self, self.script_animation );
			break;
	}
	
	length = getanimlength( getanim_generic( self.script_animation ) );
	
	wait length - randomfloatrange( 1.5, 2.25 );
	thread play_sound_in_space( "generic_death_russian_" + randomintrange( 1, 8 ), self geteye() );
	self thread bodyshot( "killshot" );
	
	wait 1;
	
	self.allowdeath = true;
	self stop_magic_bullet_shield();	
	self kill();
}


/************************************************************************************************************/
/*													PLAZA													*/
/************************************************************************************************************/
plaza_main()
{
	array_thread( getentarray( "plaza_enemies", "targetname" ), ::add_spawn_function, ::plaza_enemies );
	
	add_wait( ::flag_wait, "parking_high_spec" );
	foreach( member in level.team )
	{
		if( member.script_noteworthy == "marine1" )
			continue;
			
		member ent_flag_init( "plaza_at_tree" );
		member add_wait( ::ent_flag_wait, "plaza_at_tree" );
	}
	add_func( ::flag_set, "plaza_to_street" );
	thread do_wait();
	
	wait 1;
	
	level.team[ "marine1" ] delaythread( 0, ::plaza_moveup_marine1 );
	level.dunn delaythread( .25, ::plaza_moveup_dunn );
	level.foley delaythread( .5, ::plaza_moveup_foley );
	
	thread plaza_main2();
	
	script2model_del_intro();
}

plaza_main2()
{
	//Move up.	
	level.foley dialogue_queue( "dcemp_fly_moveup" );
	wait 1;
	//What about the guys inside?			
	level.dunn dialogue_queue( "dcemp_cpd_whatabout" );
	//What about 'em?
	level.foley dialogue_queue( "dcemp_fly_whataboutem" );
	
	flag_wait_either( "plaza_to_street", "plaza_show_enemies" );
	
	if( !flag( "plaza_show_enemies" ) )
	{
		flag_clear( "_weather_lightning_enabled" );
		thread plaza_dialogue();
		flag_wait( "plaza_player_ready_for_throw" );
			
		node = getstruct( "plaza_lookat_node", "targetname" );
		node add_wait( ::waittill_player_lookat_for_time, 1 );
		add_func( ::flag_set, "plaza_show_enemies" );
		thread do_wait();
		
		flag_wait( "plaza_show_enemies" );
	}
	
	SetSavedDvar( "aim_aimAssistRangeScale", "0" );
	SetSavedDvar( "aim_autoAimRangeScale", "0" );
	SetSavedDvar( "cg_crosshairEnemyColor", "0" );
		
	array_thread( level.team, ::set_ignoreall, false );
	array_thread( level.team, ::enable_dontevershoot );
	array_thread( level.team, ::disable_surprise );
	foreach( member in level.team )
	{
		member.oldgrenade = member.grenadeammo;	
		member.grenadeammo = 0;
	}
	
	thread array_spawn( getentarray( "plaza_enemies", "targetname" ), true );
	
	plaza_dialogue2();
	
	//Contaaact!!!	
	level.dunn thread dialogue_queue( "dcemp_cpd_conact" );	
	
	thread flag_set_delayed( "_weather_lightning_enabled", 3 );
	flag_set( "plaza_open_fire" );	
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "2000" );
	SetSavedDvar( "aim_aimAssistRangeScale", "1" );
	SetSavedDvar( "aim_autoAimRangeScale", "1" );
	SetSavedDvar( "cg_crosshairEnemyColor", "1" );
	
	level.player blend_movespeedscale_default( 1 );
	
	thread battlechatter_on();
	activate_trigger_with_targetname( "plaza_enemy_color_1" );
	activate_trigger_with_targetname( "plaza_ally_color_1" );
	
	//team stuff
	array_thread( level.team, ::disable_dontevershoot );
	array_thread( level.team, ::disable_cqbwalk );
	array_thread( level.team, ::walkdist_reset );
	array_thread( level.team, ::pathrandompercent_reset );
		
	//enemy stuff
	thread array_spawn( getentarray( "plaza_backup", "targetname" ), true );
	array_thread( getaiarray( "axis" ), ::set_force_color, "blue" );
	
	//more team stuff
	flag_wait( "plaza_flare_thrown" );
	array_thread( level.team, ::set_pushplayer, false );
	array_thread( level.team, ::set_force_color, "red" );
	array_call( level.team, ::allowedstances, "prone", "crouch", "stand" );
	foreach( member in level.team )
		member.grenadeammo = member.oldgrenade;
	
	//wait for the fight to be over
	flag_wait( "parking_plaza_guys_dead" );
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	thread autosave_by_name( "plaza_guys_dead" );
	
	thread battlechatter_off( "allies" );
	
	wait 2.5;
	
	level.team[ "marine1" ] dialogue_queue( "dcemp_ar2_streetclear" );
	level.foley thread dialogue_queue( "dcemp_fly_oscarmike" );
			
	array_thread( level.team, ::disable_ai_color );
	array_thread( level.team, ::walkdist_zero );
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::ent_flag_init, "plaza_moveout_exit" );
	array_thread( level.team, ::ent_flag_init, "plaza_moveout_exit2" );
	
	foreach( member in level.team )
		member add_wait( ::ent_flag_wait, "plaza_moveout_exit" );
	add_wait( ::flag_wait, "plaza_player_exit1" );
	add_func( ::flag_set, "plaza_moveout_exit" );
	thread do_wait();	
	
	foreach( member in level.team )
		member add_wait( ::ent_flag_wait, "plaza_moveout_exit2" );
	add_wait( ::flag_wait, "plaza_player_exit2" );
	add_func( ::flag_set, "plaza_moveout_exit2" );
	thread do_wait();	
	
	level.team[ "marine1" ] thread plaza_moveout_marine1();
	wait .5;
	level.dunn thread plaza_moveout_dunn();
	wait .25;
	level.foley plaza_moveout_foley();
	
	array_thread( level.team, ::walkdist_reset );
	array_thread( level.team, ::pathrandompercent_reset );
	array_thread( level.team, ::set_pushplayer, false );
	SetSavedDvar( "ai_friendlyFireBlockDuration", "2000" );
}

plaza_moveup_marine1()
{
	node = getnode( "park_moveup_marine1", "targetname" );	
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	node anim_generic( self, "coverstand_look_moveup" );
	node thread anim_generic_loop( self, "coverstand_look_idle" );
	
	self thread dialogue_queue( "dcemp_ar2_gotoursixgo" );
	
	wait 2;
	flag_wait( "plaza_player_at_stairs" );
	node notify( "stop_loop" );
	
	node thread anim_generic( self, "coverstand_trans_OUT_R" );
	
	length = getanimlength( getanim_generic( "coverstand_trans_OUT_R" ) );
	wait length * .84;
	self stopanimscripted();
	
	node = getstruct( node.target, "targetname" );
	node thread anim_generic( self, "gulag_sewer_slide" );
	
	length = getanimlength( getanim_generic( "gulag_sewer_slide" ) );
	wait length * .30;
	
	self stopanimscripted();
	node = getstruct( node.target, "targetname" );
	node thread anim_generic( self, "favela_civ_warning_landing" );
	
	length = getanimlength( getanim_generic( "favela_civ_warning_landing" ) );
	wait length * .1;
	
	self stopanimscripted();
	
	self anim_generic_run( self, "stand_2_run_R" );
	self thread anim_generic( self, "run_turn_R45" );	
	
	length = getanimlength( getanim_generic( "run_turn_R45" ) );
	wait length - .3;
	self stopanimscripted();
	
	node = getnode( node.target, "targetname" );
	
	self delaythread( 2, ::set_pushplayer, false );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
		
	flag_wait( "plaza_to_street" );
	
	wait 2.25;
		
	self enable_cqbwalk();
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
}

plaza_moveup_dunn()
{
	node = getnode( "park_moveup_dunn", "targetname" );	
	
	self setgoalnode( node );
	self.goalradius = 24;
	self disable_arrivals();
	
	self waittill( "goal" );
	
	self thread anim_generic_gravity( self, "run_turn_L90" );
	
	wait .75; 
	
	self clearanim( getanim_generic( "run_turn_L90" ), .2);
	self notify( "killanimscript" );
	
	self enable_arrivals();
	
	node = getnode( node.target, "targetname" );	
	
	self delaythread( .5, ::dialogue_queue, "dcemp_cpd_itsclear" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
		
	self ent_flag_set( "plaza_at_tree" );
	flag_wait( "plaza_to_street" );
		
	wait .5;
		
	self enable_cqbwalk();
	
	link = spawn( "script_origin", self.origin );
	self linkto( link );
	link rotateyaw( -6.6, .5 );
	link anim_generic_run( self, "corner_standR_trans_CQB_OUT_8" );
	
	self unlink();
	link delete();
	
	node = getstruct( node.target, "targetname" );
	node.origin = self.origin;
	node anim_generic_gravity_run( self, "patrol_jog_look_up_once" );
	
	node = getnode( node.target, "targetname" );
	
	self set_pushplayer( false );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
}

plaza_moveup_foley()
{
	node = getnode( "park_moveup_foley", "targetname" );	
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
	
	self ent_flag_set( "plaza_at_tree" );
	flag_wait( "plaza_to_street" );
			
	self enable_cqbwalk();
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
	
	flag_wait( "plaza_show_enemies" );
	
	self.a.movement = "stop";
	self anim_generic( self, "CornerStndR_alert_signal_enemy_spotted" );
	
	flag_wait_either( "plaza_prepare_throw", "plaza_open_fire" );
		
	//"Star"!!!
	add_wait( ::_wait, 2.0 );
	self add_func( ::dialogue_queue, "dcemp_fly_staaar" );
	add_abort( ::flag_wait, "plaza_open_fire" );
	thread do_wait();
					
	node = spawn( "script_origin", self.origin );
	self linkto( node );
	node rotateyaw( 17.9, .5 );
	node anim_generic_run( self, "corner_standR_trans_CQB_OUT_9" );
	
	self unlink();
	node delete();
	
	node = getstruct( "street_flarethrow_node", "targetname" );
	node anim_generic( self, "street_flare_throw" );
	flag_set( "plaza_flare_thrown" );
	
	if( flag( "plaza_open_fire" ) )
		return;
	
	self setgoalpos( self.origin );
	self.goalradius = 8;
	self allowedstances( "crouch" );
}

plaza_dialogue()
{
	wait 1;
	//I don't know what's worse, man- dodging falling helicopters or freezing my ass out here in this monsoon.		
	level.dunn dialogue_queue( "dcemp_cpd_freezingmonsoon" );	
	//Huah.		
	level.team[ "marine1" ] dialogue_queue( "dcemp_ar2_huah" );		
	//Quiet - I think I see something.		
	level.foley dialogue_queue( "dcemp_fly_quietseesomething" );
}

plaza_dialogue2()
{
	level endon( "plaza_open_fire" );
	
	wait 1;	

	level thread function_stack( ::dcemp_lightningFlash, "triple" );
	level thread function_stack( ::dcemp_lightningFlash, "double" );

	wait .5;
	
	//Hold your fire.	
	level.foley dialogue_queue( "dcemp_fly_holdyourfire" );
	wait 1;
	//Are they friendly	
	level.dunn dialogue_queue( "dcemp_cpd_aretheyfriedly" );
	wait .5;
	//I don't know…Star!	
	level.foley dialogue_queue( "dcemp_fly_dontknowstar" );
	wait 1;
	//Cover me.	
	level.foley thread dialogue_queue( "dcemp_fly_coverme" );
			
	flag_set( "plaza_prepare_throw" );
	
	//Say Texas, dammit…just say it.
	add_wait( ::_wait, 3.5 );
	level.dunn add_func( ::dialogue_queue, "dcemp_cpd_saytexas" );
	add_abort( ::flag_wait, "plaza_open_fire" );
	thread do_wait();
		
	flag_wait( "plaza_throw_react" );
	
	wait 3.5;
}

plaza_moveout_dunn()
{
	node = getnode( "plaza_moveout_marine1", "targetname" );
			
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
	
	self ent_flag_set( "plaza_moveout_exit" );
	flag_wait( "plaza_moveout_exit" );
	
	wait 1;
	
	link = spawn( "script_origin", self.origin );
	link.angles = self.angles;
	self linkto( link );
	link rotateyaw( 15, 1 );
	link anim_generic_run( self, "crouch_2run_R" );
	self unlink();
	link delete();
	self anim_generic_run( self, "run_turn_L45" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
	
	self ent_flag_set( "plaza_moveout_exit2" );
	
	flag_wait( "plaza_moveout_exit2" );
	
	wait .5;
		
	node = getstruct( node.target, "targetname" );
	node anim_generic_reach( self, "jump_across_100_lunge" );
	node anim_generic_run( self, "jump_across_100_lunge" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 90;
}

plaza_moveout_marine1()
{
	node = getnode( "plaza_moveout_dunn", "targetname" );
			
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
		
	self anim_generic( self, "corner_standR_alert_2_look" );
	self thread anim_generic_loop( self, "corner_standR_look_idle" );
	
	self ent_flag_set( "plaza_moveout_exit" );
	flag_wait( "plaza_moveout_exit" );
	
	wait .5;
	
	self notify( "stop_loop" );
	self stopanimscripted();
	
	self anim_generic_gravity_run( self, "corner_standR_trans_OUT_9" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
		
	self ent_flag_set( "plaza_moveout_exit2" );
	
	flag_wait( "plaza_moveout_exit2" );
	
	wait 1;
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 90;
}

plaza_moveout_foley()
{
	node = getnode( "plaza_moveout_foley", "targetname" );
			
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
	
	self ent_flag_set( "plaza_moveout_exit" );
	flag_wait( "plaza_moveout_exit" );
	
	//Watch for movement.		
	self thread dialogue_queue( "dcemp_fly_watchmovement" );
	
	self anim_generic_gravity_run( self, "corner_standR_trans_OUT_6" );
	
	node = getnode( node.target, "targetname" );
	
	self setgoalnode( node );
	self.goalradius = 8;
	self waittill( "goal" );
		
	self ent_flag_set( "plaza_moveout_exit2" );
	
	flag_wait( "plaza_moveout_exit2" );
	
	self thread dialogue_queue( "dcemp_fly_moveup" );	
	self.a.movement = "stop";
	self anim_generic( self, "CornerStndR_alert_signal_move_out" );
		
	wait 1;
	
	node = getent( node.target, "targetname" );
	
	self thread anim_generic( self, "corner_standR_trans_OUT_6" );
	length = getanimlength( getanim_generic( "corner_standR_trans_OUT_6" ) );
	wait length - .61;
	self stopanimscripted();
	
	self linkto( node );
	node delaycall( .25, ::movez, 8, .5 );
	node thread anim_generic( self, "gulag_sewer_slide" );
	length = getanimlength( getanim_generic( "gulag_sewer_slide" ) );
	wait length * .28;
	self unlink();
	self stopanimscripted();
	
	self anim_generic_gravity_run( self, "stand_2_run_F_2" );
	
	flag_set( "tunnels_main" );
}


/************************************************************************************************************/
/*												START POINTS												*/
/************************************************************************************************************/
start_intro()
{	
	script2model_intro();
	flag_set( "intro_fx" );
	
	thread maps\_utility::set_ambient( "dcemp_dry" );
	thread maps\_ambient::ambientEventStart( "dcemp_dry" );
	street_setup_stuff();
}

start_iss()
{
	//CRASHSITE STUFF	--> TOP
		movement_grid = maps\dc_crashsite::crash_site_player_and_heli_setup();
		
		ePlayer_rig = spawn_anim_model( "player_rig" );	
		anim_actors_rescue[ 0 ] = ePlayer_rig;	
		
		crash_node = getent( "crash_node", "targetname" );
		crash_node anim_first_frame( anim_actors_rescue, "dcburning_BHrescue" );
			
		level.player freezecontrols( true );
		level.player PlayerLinkToDelta( ePlayer_rig, "tag_player", 1, 0, 0, 0, 0, true );
			
		flag_set( "crash_fade_up" );
		flag_set( "redshirt_headshot" );
		thread maps\dc_crashsite::player_crash_movement(  movement_grid[ "top_left" ], movement_grid[ "bot_right" ], ePlayer_rig );	
		
		wait .05;
		level.player unlink();
	//CRASHSITE STUFF	--> BOTTOM
	
	thread flag_set_delayed( "emp_entity_cleanup_done", .05 );
}

start_emp()
{
	thread maps\_utility::set_ambient( "dcemp_dry" );
	flag_set( "intro_fx" );
	thread vision_set_intro( 0 );
	
	//CRASHSITE STUFF	--> TOP
		movement_grid = maps\dc_crashsite::crash_site_player_and_heli_setup();
		
		ePlayer_rig = spawn_anim_model( "player_rig" );	
		anim_actors_rescue[ 0 ] = ePlayer_rig;	
		
		crash_node = getent( "crash_node", "targetname" );
		crash_node anim_first_frame( anim_actors_rescue, "dcburning_BHrescue" );
			
		level.player freezecontrols( true );
		level.player PlayerLinkToDelta( ePlayer_rig, "tag_player", 1, 0, 0, 0, 0, true );
		
		thread maps\dc_crashsite::player_crash_movement(  movement_grid[ "top_left" ], movement_grid[ "bot_right" ], ePlayer_rig );	
	//CRASHSITE STUFF	--> BOTTOM
	
	street_setup_stuff();
	
	level.player takeallweapons();
	level.player giveWeapon( "m4m203_eotech" );
	level.player switchToWeapon( "m4m203_eotech" );
		
	level.player SetWeaponAmmoClip( "m203_m4_eotech", 0 );
	level.player SetWeaponAmmoStock( "m203_m4_eotech", 0 );
	level.player SetWeaponAmmoClip( "m4m203_eotech", 0 );
	level.player SetWeaponAmmoStock( "m4m203_eotech", 0 );
	
	setsaveddvar( "ui_hidemap", 1 );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	
	flag_set( "crash_fade_up" );
	
	wait 1;
	
	flag_set( "redshirt_headshot" );
	
	flag_set( "crash_cut_to_black" );
	
	delaythread( 0, ::exploder, "emp_flash" );
	delaythread( .5, ::exploder, "emp_flash" );
	delaythread( 1, ::exploder, "emp_flash" );
	delaythread( 3, ::exploder, "emp_flash" );
	
	thread maps\dc_crashsite::crash_end_scene();
}

start_street()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_dry" );
	script2model_intro();
	flag_set( "intro_fx" );
	thread vision_set_intro( 0 );
	
	street_setup_stuff();
	
	thread battlechatter_off();
	
	wait .1;
	
	node = getstruct( level.foley.target, "targetname" );
	node = getnode( node.target, "targetname" );
	level.foley teleport_actor( node );
	level.foley.goalradius = 16;
	level.foley setgoalnode( node );
	
	node = getstruct( level.dunn.target, "targetname" );
	node = getstruct( node.target, "targetname" );
	node = getnode( node.target, "targetname" );
	level.dunn teleport_actor( node );
	level.dunn.goalradius = 16;
	level.dunn setgoalnode( node );
	
	node = getnode( level.team[ "marine1" ].target, "targetname" );
	node = getnode( node.target, "targetname" );
	level.team[ "marine1" ] teleport_actor( node );
	level.team[ "marine1" ].goalradius = 16;
	level.team[ "marine1" ] setgoalnode( node );
	
	flag_set( "emp_entity_cleanup_done" );
	thread flag_set_delayed( "street_main", .5 );
}

start_corner()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_dry" );
	flag_set( "intro_fx" );
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	thread vision_set_sunset( 0 );
	
	array_thread( getentarray( "meetup_allies", "targetname" ), ::add_spawn_function, ::init_meetup_allies );
	activate_trigger( "meetup_allies", "target" );
	
	level.sky delete();
	
	wait .05;
	
	getent( "street_btr", "targetname" ) add_spawn_function( ::street_btr_scene );
	getent( "street_crash_motorcycle", "targetname" ) thread street_crash_motorcycle();
	array_thread( getentarray( "street_crash_car", "script_noteworthy" ), ::street_crash_cars );
	array_thread( getentarray( "street_crash_heli", "script_noteworthy" ), ::street_crash_helis );
	
	array_thread( getentarray( "corner_truck_engine_crash", "targetname" ), ::corner_truck_engine_crash );
	thread corner_plane_crash();
	
	exploder( "hide_heli_crash" );
	
	glass = getglassarray( "street_hide_glass" );
	dir = anglestoforward( ( 0, 345, 0 ) );
	foreach( piece in glass )
		noself_delaycall( 1, ::destroyglass, piece, dir * 200 );
	
	thread battlechatter_off();
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::walkdist_zero );
	
	nodes = [];
	nodes = array_add( nodes, getnode( "street_marine1_hide_node", "targetname" ) );
	nodes = array_add( nodes, getnode( "street_macey_hide_node", "targetname" ) );
	nodes = array_add( nodes, getnode( "corner_macey_hide_node", "targetname" ) );
	nodes = array_add( nodes, getnode( "corner_start2", "targetname" ) );
	nodes = array_add( nodes, getnode( "corner_start3", "targetname" ) );
	
	emp_teleport_team_specific( level.team, nodes );
	emp_teleport_player();
	
	foreach( member in level.team )
		member.alertLevel = "alert";
	
	node = getnode( "corner_macey_hide_node", "targetname" );
	level.foley delaycall( .5, ::setgoalnode, node );
	
	thread flag_set_delayed( "corner_main", .5 );
	thread flag_set_delayed( "street_crash_heli_done", .5 );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_FIND_SHELTER", getstruct( "hide_obj", "targetname" ).origin );
	objective_current( level.objnum );
}

start_meetup()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_dry" );
	flag_set( "intro_fx" );
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	thread vision_set_sunset( 0 );
	
	array_thread( getentarray( "meetup_allies", "targetname" ), ::add_spawn_function, ::init_meetup_allies );
	activate_trigger( "meetup_allies", "target" );
	
	level.sky delete();
	corner_show_damage();
					
	wait .05;
						
	thread battlechatter_off();
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::walkdist_zero );
	array_thread( level.team, ::set_generic_run_anim_array, "casual_killer_jog" );
		
	emp_teleport_team_specific( level.team, getstructarray( "meetup_ai_nodes", "targetname" ) );
	emp_teleport_player();
	
	thread flag_set_delayed( "meetup_main", .5 );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_FOLLOW_SGT_FOLEY", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
}	

start_lobby()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_light_rain" );
	flag_set( "intro_fx" );
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	thread vision_set_sunset( 0 );
	array_thread( getentarray( "meetup_allies", "targetname" ), ::add_spawn_function, ::init_meetup_allies );
	activate_trigger( "meetup_allies", "target" );
	
	waittillframeend;
		
	level.sky delete();
	corner_show_damage();
					
	thread battlechatter_off();
	array_thread( level.team, ::set_ignoreme, true );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::walkdist_zero );
	
	nodes = [];
	nodes = array_add( nodes, getstruct( "meetup_runner_dunn", "targetname" ) );
	nodes = array_add( nodes, getstruct( "meetup_runner_foley", "targetname" ) );
	nodes = array_add( nodes, getstruct( "meetup_runner_1", "targetname" ) );
	nodes = array_add( nodes, getstruct( "meetup_runner_2", "targetname" ) );
	nodes = array_add( nodes, getstruct( "meetup_runner_3", "targetname" ) );
			
	emp_teleport_team_specific( level.team, nodes );
	emp_teleport_player();
	
	thread flag_set_delayed( "lobby_main", .5 );
	
	door = getent( "meetup_door_left", "targetname" );	
	door delaycall( .5, ::connectpaths );
	door delaycall( 1, ::rotateyaw, -90, .5 );
	door delaycall( 2.0, ::disconnectpaths );
		
	thread maps\_weather::rainMedium( 1 );
	delaythread( 1, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_WHISKEY_HOTEL", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
}

start_office()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_dry" );
	flag_set( "intro_fx" );
	
	thread vision_set_office( 0 );
	array_thread( getentarray( "meetup_allies", "targetname" ), ::add_spawn_function, ::init_meetup_allies );
	activate_trigger( "meetup_allies", "target" );
	
	thread handle_sunlight();
	delaythread( .1, ::activate_trigger, "office_ally_color_1", "target" );
	delaythread( .5, ::activate_trigger, "office_ally_color_2", "target" );
	
	level.sky delete();
			
	thread battlechatter_off();
	
	wait .05;
	level.team[ "marine3" ] kill();
	level.team[ "marine2" ] thread magic_bullet_shield();
		
	emp_teleport_team_specific( level.team, getstructarray( "office_start_points1", "targetname" ) );
	emp_teleport_player();
	
	level.team = array_removedead( level.team );
	array_thread( level.team, ::set_force_color, "red" );
	
	door = getent( "lobby_door_left", "targetname" );
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );
	door thread hunted_style_door_open( "door_wood_slow_creaky_open" );
	
	door = getent( "lobby_door_right", "targetname" );	
	parts = getentarray( door.target, "targetname" );
	array_call( parts, ::linkto, door );
	door connectpaths();
	
	flag_set( "lobby_door_kick" );
	
	time = .4;
	door rotateroll( -90, time );
	door playsound( "wood_door_kick" );
	
	thread flag_set_delayed( "office_main", .25 );
	
	thread maps\_weather::rainHard( 1 );
	delaythread( 1, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_WHISKEY_HOTEL", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
}
	
start_parking()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_dry" );
	flag_set( "rain_fx" );
	
	thread vision_set_office( 0 );

	thread handle_sunlight();
		
	level.sky delete();
	
	thread battlechatter_off();
	
	waittillframeend;
	
	emp_teleport_team_specific( level.team, getstructarray( "parking_start_points", "targetname" ) );
	emp_teleport_player();
	
	thread flag_set_delayed( "parking_main", .25 );
	
	thread maps\_weather::rainHard( .05 );
	delaythread( .05, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_WHISKEY_HOTEL", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
}

start_plaza()
{	
	start_common_dcemp();
	thread maps\_utility::set_ambient( "dcemp_heavy_rain" );
	level.player blend_movespeedscale( .8 );
	flag_set( "rain_fx" );
	
	SetSavedDvar( "ai_friendlyFireBlockDuration", "0" );
	thread vision_set_parking( .1 );
	thread parking_high_spec();
	thread plaza_flare_fx();
	
	trigger_off( "parking_btr_guys", "target" );
	
	flag_set( "parking_main" );
	lights = getentarray( "parking_lighting_primary", "script_noteworthy" );
	array_call( lights, ::setlightcolor, (.85, .85, 1) );
	flag_set( "spotlight_lightning" );
	
	level.sky delete();
	thread battlechatter_off();
	
	waittillframeend;
				
	array_thread( level.team, ::pathrandompercent_zero );
	array_thread( level.team, ::walkdist_zero );
	array_thread( level.team, ::set_pushplayer, true );
	array_thread( level.team, ::disable_pain );
	array_thread( level.team, ::set_ignoreall, true );
	array_thread( level.team, ::disable_ai_color );
		
	emp_teleport_team_specific( level.team, getstructarray( "plaza_start_points", "targetname" ) );
	emp_teleport_player();
					
	flag_set( "parking_btr_guys_dead" );
	
	thread maps\_weather::rainHard( .05 );
	delaythread( .05, maps\_weather::lightning, maps\dcemp_fx::lightning_normal, maps\dcemp_fx::lightning_flash );
	
	objective_add( level.objnum, "active", &"DCEMP_OBJ_WHISKEY_HOTEL", level.foley.origin );
	objective_current( level.objnum );
	objective_onentity( level.objnum, level.foley, ( 0,0,70 ) );
}
	
start_common_dcemp()
{
	level.team = [];
	add_global_spawn_function( "allies", ::set_color_goal_func );
	array_thread( getentarray( "intro_team", "targetname" ), ::add_spawn_function, ::team_init );
	activate_trigger( "intro_team", "target" );	
		
	flag_wait( "team_initialized" );
	
	volume = getent( "mask_ents", "targetname" );
	volume activate_destructibles_in_volume();
	volume activate_interactives_in_volume();
}

set_color_goal_func()
{
	self.colornode_func = ::notify_node_on_goal;	
}

notify_node_on_goal( node )
{
	self endon( "stop_going_to_node" );	
	self endon( "stop_color_move" );
	self endon( "death" );
	
	self waittill( "goal" );
	
	node notify( "trigger", self );
}
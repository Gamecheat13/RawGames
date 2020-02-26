/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
*/

// External References
#include common_scripts\utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\_utility;

// Internal References
#include maps\createart\blackout_art;
#include maps\blackout_util;

#define CLIENT_FLAG_INTRO_EXTRA_CAM		11
#define CLIENT_FLAG_BLOOD_SHOULDER		12
#define CLIENT_FLAG_MIRROR_EXTRA_CAM	14

#define POWER_SURGE_EXPLODER			1000
#define TANKER_EXPLODER_STAGE_UNO		1001
#define GLASS_BREAK_EXPLODER			999

/////////////////////////////////////
//                                 //
// SKIPTO INITIALIZATION FUNCTIONS //
//                                 //
/////////////////////////////////////

skipto_mason_start()
{
	skipto_setup();
	skipto_teleport_players( "player_skipto_mason_interrogation_room" );
	
	// Spawn the dudes.
	spawn_interrogation_heroes();
}

skipto_mason_interrogation_room()
{
	move_interrogation_door( true );
	spawn_interrogation_heroes();
	
	skipto_setup();
	skipto_teleport_players( "player_skipto_mason_interrogation_room" );
	run_scene_first_frame( "intro_setup_chair" );
	
	level.player remove_guns();
}

skipto_mason_wakeup()
{
	skipto_setup();
	skipto_teleport_players( "player_skipto_mason_wakeup" );
	
	level.salazar = init_hero( "salazar" );
	screen_fade_out( 0.01 );
	
	level thread taser_knuckles_pickup();
	
	level.player remove_guns();
}

skipto_mason_hallway()
{	
	skipto_setup();
	skipto_teleport_players( "player_skipto_mason_interrogation_room" );
	
	// Bring in y'r buddy.
	level.salazar = init_hero_startstruct( "salazar", "salazar_hallway_start" );
	
	// start the hallway spawns now.
	trigger_use( "hallway_start_trigger", "targetname" );
}

/////////////////////////////////////
//                                 //
//       SKIPTO RUN FUNCTIONS      //
//                                 //
/////////////////////////////////////

run_mason_start()
{
	waittill_textures_loaded();
	
	//Eckert - making level sound fade in nicely
	level clientnotify( "fade" );
	
	//assign the extra cam to the struct in the interrogation room
	move_interrogation_door( true );

	level.player remove_guns();
	level thread run_scene_and_delete( "intro_player_loop" );
	run_scene_first_frame( "intro_cctv" );
	run_scene_first_frame( "intro_setup_chair" );
	
	level thread interrogation_camera();
	level thread interrogation_handcuffs();
	
	// Get the scene started so we know where sal's head is and can point
	// at it in the camera logic in turn_on_intro_cam.
	wait_network_frame();

	// Create a streaming hint so we can stream in the textures for menendez.
	e_streamer_hint = CreateStreamerHint( (280,-133,34), 1.0 );
	
	turn_on_intro_cam();
		
	//wait until introscreen fades out before starting camera movement and animation
	flag_wait( "introscreen_complete" );
	
	clientnotify ( "snd_commotion" );//lee adding commotion
	//SOUND - Shawn J
	level.player playsound ("sce_cctv_intro");
	
	level.player clientnotify( "intro_cctv_started" );
	
	level thread interrogation_menendez_bleed();
	
	wait 7.0;
	
	run_scene_and_delete( "intro_cctv" );
	
	// No more streaming hints.
	e_streamer_hint Delete();
}

run_mason_interrogation_room()
{
	level thread taser_knuckles_pickup();
	
	vision_set_interrogation();
	
	level.m_original_exposure = GetDvarFloat( "r_exposureValue" );

	// wait a few seconds, then show the objective.
	delay_thread( 4.0, ::set_objective, level.OBJ_INTERROGATE, level.menendez, "breadcrumb" );
	
	level thread scene_cctv_end();
	
	trigger_wait( "interrogation_room_trig" );
	
	clientnotify ( "snd_argument" );//lee argument

	set_objective( level.OBJ_INTERROGATE, undefined, "done", undefined, false );
	
	scene_interrogation();
	
	clientnotify ("argument_done");//lee adding alarm

	// give salazar his regular loadout back.
	level.salazar custom_ai_weapon_loadout( "scar_sp", undefined, "fiveseven_sp" );
	
	// Make sure the exposure tweak is disabled.
	SetDvar( "r_exposureTweak", 0 );
}

intercom_dialog()
{
	wait 1.5;
	level.player say_dialog( "pa_all_hands_all_hand_0" );
	wait 1.0;
	level.player say_dialog( "pa_all_pmcs_are_aligned_0" );
	level.player say_dialog( "pa_repeat_shoot_on_si_0" );
}

run_mason_wakeup()
{
	flag_set( "distant_explosions_on" );
	load_needed_gump();
	
	level notify( "mason_wakeup" );
	move_interrogation_door( true );
	
	// crack the door now that menendez escaped.
	run_scene_first_frame( "sal_door_open", true );
	
	s_player_pos = GetStruct( "player_skipto_mason_wakeup", "targetname" );
	
	// set up the hallway enemy spawn shenanigans
	level thread track_enemy_volumes( "battle_advance", "observation_hallway_enemy" );
	
	// TODO: remove this.
	{
		level.player SetVelocity( ( 0, 0, 0 ) );
		skipto_teleport_players("player_skipto_mason_wakeup");
	}
	
	run_scene_first_frame( "wakeup_player" );
	delay_thread( 0.5, ::simple_spawn, "noisy_mc_shooty_pants", ::hallway_shooting );
	level thread intercom_dialog();
	screen_fade_in(4);
	screen_fade_out(1);
	
	wait 3.0;
	
	// eyes open.
	run_scene_first_frame( "wakeup_sal" );
	level thread screen_fade_in(2);
	
	wait 1.0;
	
	// mason wakes up.
	level thread run_scene_and_delete( "wakeup_player" );
	run_scene_and_delete( "wakeup_sal" );
	
	level thread run_scene_and_delete( "getup_decide" );
	wait 1.5;
	
	// Accept Sal's help.
	run_scene_and_delete( "getup_sal" );
	
	move_interrogation_door( false, 0.1, true );
	
	level thread scene_sal_locker_and_door();
	
	level.player SetLowReady( false );
	level.player AllowPickupWeapons( true );
	level.player EnableWeapons();
	level.player AllowMelee( true );
	
	autosave_by_name( "mason_combat_start" );
	
	wpn_mount = GetEnt( "player_equipment_objective", "targetname" );
	set_objective( level.OBJ_PICKUP_WEAPONS, wpn_mount, "pickup" );
	
	trigger_use( "hallway_start_trigger", "targetname" );
	
	level thread update_player_ammo();
	
	// wait until the player has at least one primary weapon.
	wpn_list = [];
	while ( wpn_list.size < level.num_weapons_taken )
	{
		wpn_list = level.player GetWeaponsListPrimaries();
		wait 0.2;
	}
	
	// new objective: Follow Salazar
	set_objective( level.OBJ_PICKUP_WEAPONS, undefined, "done" );
	
	level notify( "player_grabbed_weapons" );
	
	scene_wait( "sal_door_walk" );
	wait 0.5; // make him stand there at least a moment.
	
	set_objective( level.OBJ_FOLLOW_SALAZAR, level.salazar, "follow" );
	
	if ( level.is_harper_alive )
	{
		level thread dialog_hallway_harper();
	} else {
		level thread dialog_hallway_briggs();
	}
	
	trigger_wait( "hallway_door_trigger" );
}

run_mason_hallway()
{
	flag_set( "distant_explosions_on" );
	run_scene_first_frame( "salazar_exit", true );
	
	// spawn good guys in the hallway, killing some of them.
	level thread scene_hallway();
	
	level thread scene_sal_open_door();
	
	spawn_manager_enable( "sm_friendly_hallway" );
	
	// ready the stairfall moment.
	level thread moment_stairfall();
	
	// free up salazar to go be awesome.
	level.salazar.fixednode = false;
	level.salazar.ignoreall = false;
	level.salazar.ignoreme = false;
	
	// salazar runs...carefully.
	level.salazar change_movemode( "cqb_run" );
	
	// Start Salazar and the homies into the hallway.
	trigger_use( "observation_start_colors_trig" );
	
	level.salazar thread say_dialog( "sect_end_of_the_hall_0", 10.0 );
	
	// Wait till we reach the end of the hallway.
	trigger_wait( "observation_hallway_done_trigger" );
	
	spawn_manager_disable( "sm_friendly_hallway" );
	
	level thread scene_salazar_exit();
	
	autosave_by_name( "observation_hallway_complete" );
	
	flag_clear( "distant_explosions_on" );
}

dialog_salazar_tool_up()
{
	level.salazar say_dialog( "sala_this_way_we_need_0" );
	level.salazar say_dialog( "sala_take_what_you_need_0" );
}

dialog_hallway_harper()
{
	level.player say_dialog( "harp_section_it_s_harper_0" );
	level.player say_dialog( "harp_briggs_is_pinned_dow_0" );
}

dialog_hallway_briggs()
{
	level.player say_dialog( "brig_section_it_s_briggs_0" );
	level.player say_dialog( "sect_where_are_you_0" );
	level.player say_dialog( "brig_pinned_down_in_the_s_0" );
	level.player say_dialog( "sect_we_ll_try_to_get_to_0" );
}

run_masons_quarters( str_door_name, str_trigger_name, open_angle, str_open_notify )
{
	t_door = GetEnt( "masons_door_trigger", "targetname" );
	t_door SetCursorHint( "HINT_NOICON" );
	t_door SetHintString( &"BLACKOUT_OPEN_DOOR" );
	t_door waittill( "trigger" );

	// open the door.
	e_door = GetEnt( "masons_door", "targetname" );	
	e_door RotateYaw( 90, 1.5, 0.5, 0.5 );
	
	t_cigar_box = GetEnt( "mason_personal_effects_trigger", "targetname" );
	t_cigar_box SetCursorHint( "HINT_NOICON" );
	t_cigar_box SetHintString( &"BLACKOUT_USE_PERSONAL_EFFECTS" );
	t_cigar_box waittill( "trigger" );
	
	// "pick up" the cigar box.
	level notify( "masons_personal_effects_found" );
	e_cigar_box = GetEnt( "mason_personal_effects", "targetname" );
	e_cigar_box Delete();
}

init_doors()
{
	hallway_door = GetEnt( "interrogation_hallway_door", "targetname" );
	collision = GetEnt( hallway_door.target, "targetname" );
	collision LinkTo( hallway_door, "tag_origin" );
	
	//hide broken mirror in the interrogation room
	glass_list = GetEntArray( "interrogation_mirror_broken", "targetname" );
	foreach ( glass in glass_list )
	{
		glass Hide();
	}
	
	level thread run_masons_quarters();
}

/////////////////////////////////////
//                                 //
//       SCRIPTED MOMENTS          //
//                                 //
/////////////////////////////////////

//self is Menendez
interrogation_menendez_bleed()
{
	ai_menendez = GetEnt( "menendez_ai", "targetname" );
	
	wait 0.5;
	
	PlayFXOnTag( getfx( "ear_blood" ), ai_menendez, "J_Head" );
	wait 1.0;
	/#PrintLn( "**** Setting shoulder blood client flag ****" );#/
	ai_menendez SetClientFlag( CLIENT_FLAG_BLOOD_SHOULDER );
}

//plays a recording fx until Salazar tampers with the camera
interrogation_camera()
{
	a_m_camera = GetEntArray( "security_intro_camera", "targetname" );
	
	foreach( m_camera in a_m_camera )
	{
		play_fx( "camera_recording", m_camera.origin, m_camera.angles, "stop_record" );
	}
	
	flag_wait( "intro_disable_camera" );
	
	level notify( "stop_record" );
}

interrogation_handcuffs()
{
	m_handcuffs = GetEnt( "intro_handcuffs", "targetname" );
	m_handcuffs play_fx( "handcuffs_light", m_handcuffs.origin, m_handcuffs.angles, "stop_handcuffs", true );

	flag_wait( "intro_disable_handcuffs" );
	
	m_handcuffs notify( "stop_handcuffs" );
}

notetrack_lights_out( ai_menendez )
{
	clientnotify( "INT_out" );
	
	SetDvar( "r_exposureTweak", 1 );
	SetDvar( "r_exposureValue", 10.0 );
}

notetrack_lights_on( ai_menendez )
{
	SetDvar( "r_exposureTweak", 0 );
	clientnotify( "interrogation_light" );
	stop_exploder( POWER_SURGE_EXPLODER );
}

notetrack_light_flicker( ai_menendez )
{
	SetDvar( "r_exposureTweak", 1 );
	
	clientnotify( "INT_flick" );
	
	blend_exposure_over_time( 1.0, 0.5 );
	blend_exposure_over_time( 7.0, 0.2 );
	blend_exposure_over_time( level.m_original_exposure, 3.0 );
	
	SetDvar( "r_exposureTweak", 0 );
}

notetrack_table_shake( ai_menendez )
{
	Earthquake( 0.3, 0.35, level.player.origin, 128 );
	PlayRumbleOnPosition( "grenade_rumble", level.player.origin );
}

//called off a notetrack on salazar to break the mirror
interrogation_break_mirror( ai_salazar )
{
	broken_glass_brushes = GetEntArray( "interrogation_mirror_broken", "targetname" );
	foreach( brush in broken_glass_brushes )
	{
		brush Show();
	}
	
	exploder( GLASS_BREAK_EXPLODER );
	
	// At this time, disable player's headlook.
	level.player LerpViewAngleClamp( 3.0, 0.5, 0.5, 0, 0, 0, 0 );
}

scene_hallway()
{
	level thread scene_hallway_injuries();
	
	run_scene_first_frame( "hallway_entry_attackers" );
	run_scene_first_frame( "hallway_entry_victims" );
	
	vision_set_hallway();
	
	// wait till the player can see the inside of the hallway.
	hallway_node = GetStruct( "salazar_hallway_start", "targetname" );
	level.player waittill_player_looking_at( hallway_node.origin, 0.7, true );
	
	level notify( "can_see_hallway" );
	
	level thread run_scene_and_delete( "hallway_entry_attackers" );
	level thread run_scene_and_delete( "hallway_entry_victims" );
}

scene_hallway_injuries()
{
	level thread run_scene_and_delete( "hallway_cougher" );
	level thread run_scene_and_delete( "hallway_dead" );
	run_scene_first_frame( "hallway_drag" );
	
	wait_network_frame();
	
	hallway_guys = get_ais_from_scene( "hallway_drag" );
	hallway_guys = ArrayCombine( hallway_guys, get_ais_from_scene( "hallway_cougher" ), true, false );
	
	foreach ( guy in hallway_guys )
	{
		// Leave us alone, Mel Brooks!
		guy.ignoreme = true;
		guy magic_bullet_shield();
	}
	
	level waittill( "can_see_hallway" );
	
	run_scene_and_delete( "hallway_drag" );
	level thread run_scene_and_delete( "hallway_surgery" );
	
	trigger_wait( "deck_reveal_trigger" );
	
	// These scenes automatically delete their guys.
	end_scene( "hallway_dead" );
	end_scene( "hallway_surgery" );
	end_scene( "hallway_cougher" );
}

scene_salazar_exit()
{
	// The scene automatically deletes salazar.
	run_scene_and_delete( "salazar_exit" );
	level.salazar = undefined;
}

scene_sal_locker_and_door()
{
	//run_scene( "sal_locker_walk" );
	level thread run_scene_and_delete( "sal_locker_stand" );
	
	level waittill( "player_grabbed_weapons" );
	
	run_scene_and_delete( "sal_door_walk" );
	level thread run_scene_and_delete( "sal_door_stand" );
}

scene_sal_open_door()
{
	level notify( "opening_hallway_door" );
	run_scene_and_delete( "sal_door_open" );
	
	// clear the way!
	hall_door = GetEnt( "interrogation_hallway_door", "targetname" );
	hall_door_collision = GetEnt( hall_door.target, "targetname" );
	hall_door_collision ConnectPaths();
}

scene_cctv_end()
{	
	//wait for camera to finish
	if ( flag( "intro_camera_on" ) )
	{
		delay_thread( 3.0, ::scene_playerturn );
		delay_thread( 5.0, ::turn_off_intro_cam );
	} else {
		level thread scene_playerturn();
	}
	
	level thread run_scene_and_delete( "intro_nag_loop" );
	
	scene_wait( "intro_playerturn" );
	
	// nag the player to go inside.
	level thread briggs_nag_mason();
	
	scene_wait( "intro_interrogation" );
	
	level thread run_scene_and_delete( "intro_briggs_leave" );
}

scene_playerturn()
{
	run_scene_and_delete( "intro_playerturn" );
	
	// re-disable the weapons since the scene system re-enables them.
	level.player DisableWeapons();
}

scene_interrogation()
{	
	delay_thread( 4.5, ::move_interrogation_door, false );
	
	//SOUND - Shawn J
	//level.player playsound ("sce_mendz_interro");
	
	run_scene_and_delete( "intro_interrogation" );
	level thread run_scene_and_delete( "intro_fight" );
	
	wait_network_frame();
	
	// Remove the .name for the mirror guys.
	ais = get_ais_from_scene( "intro_fight" );
	foreach ( ai in ais )
	{
		if ( IsSubStr( ai.targetname, "mirror" ) )
		{
			ai.name = "";
		}
	}
	
	mirror_menendez = GetEnt( "menendez_mirror_ai", "targetname" );
	mirror_menendez custom_ai_weapon_loadout( "fiveseven_sp" );
	
	scene_wait( "intro_fight" );
}

die_on_notify( str_notify )
{
	level waittill( str_notify );
	self stop_magic_bullet_shield();
	self die();
}

hallway_shooting()
{
	self endon( "death" );
	self thread die_on_notify( "opening_hallway_door" );
	
	self magic_bullet_shield();
	self.ignoreme = true;
	self.ignoreall = true;
	
	target = GetEnt( self.target, "targetname" );
	
	while ( true )
	{
		self shoot_at_target( target, undefined, 0, RandomFloatRange( 0.5, 1.0 ) );
		wait RandomFloatRange( 1.0, 4.0 );
	}
}

door_open_spawn_logic()
{
	self endon( "death" );
	if ( self.team != "allies" )
	{
		return;
	}
	
	wait 8.0;
	
	// after a few seconds, these guys join team orange.
	self set_force_color( "o" );
}

sal_exit_explosion()
{
	exploder( TANKER_EXPLODER_STAGE_UNO );
	level notify( "fxanim_stairwell_ceiling_start" );
	
	size = RandomFloatRange( 0.2, 0.4 );
	duration = RandomFloatRange( 0.5, 1.5 );
	
	PlayRumbleOnPosition( "grenade_rumble", level.player.origin );
	Earthquake( 0.8, 0.8, level.player.origin, 100 );
	level.player playsound ("exp_carrier_impact_room");
	
	
	//for audio---Celing Pipe Burst
	level ClientNotify ("cpb");
}

// spawn two guys at the top of the stairs, one kills the other,
// then takes cover.
moment_stairfall()
{
	trigger_wait( "observation_hallway_done_trigger" );
	
	playsoundatposition ("evt_stairfall_guy", (761, 1438, 376));	
	
	delay_thread( RandomFloatRange(1.0, 2.0), ::sal_exit_explosion );
	
	level thread run_scene_and_delete( "stairfall" );
	
	wait_network_frame();
	
	// spawn the enemy and keep him at the top of the stairs for a few.
	ai_enemy = simple_spawn_single( "stairfall_enemy_spawn" );
	
	ai_enemy endon( "death" );
	
	ai_enemy.fixednode = true;
	nd_cover = GetNode( "stairfall_cover", "targetname" );
	ai_enemy SetGoalNode( nd_cover );
	
	wait 0.5;
	
	ai_enemy bloody_death();
	
	scene_wait( "stairfall" );
	
	// If we haven't sent the guys upstairs toward the reveal yet, send them.
	trigger = GetEnt( "reveal_color_trigger", "targetname" );
	if ( IsDefined( trigger ) )
	{
		trigger trigger_use();
	}
}

/////////////////////////////////////
//                                 //
//       EXTRA CAM FUNCTIONS       //
//                                 //
/////////////////////////////////////


#define REFLECTION_WIDTH 16
#define REFLECTION_HEIGHT 9
turn_on_intro_cam()
{
    SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
    s_camera = getstruct( "interrogation_cam_pos", "targetname" );
    
    // point the camera struct at menendez's head.
    fudge_factor = ( -5, 0, -4.5 );
    v_mz_head = level.menendez GetTagOrigin( "J_head" ) + fudge_factor;
    v_cam_to_mz = v_mz_head - s_camera.origin;
    s_camera.angles = VectorToAngles( v_cam_to_mz );
    
    level.e_camera = Spawn( "script_model", s_camera.origin );
	level.e_camera SetModel( "tag_origin" );
	level.e_camera.angles = s_camera.angles;
	level.e_camera SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	level.e_camera thread camera_aim_update();
	
	level.player clientnotify( "intro_cctv_assigned" );
	level.extra_cam_surfaces[ "observation" ] Show();
	
	flag_set( "intro_camera_on" );
}

turn_off_intro_cam()
{
	clientnotify( "intro_cctv_complete" );
	if ( IsDefined( level.e_camera ) )
	{
		level.e_camera notify( "stop_camera_control" );
  		level.e_camera ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
  		wait_network_frame();
   		level.e_camera Delete();
	}
   	
   	//"turn off" the monitor since we can only render one extra cam at a time at 60fps
   	level.extra_cam_surfaces[ "observation" ] Hide();
   	
   	flag_clear( "intro_camera_on" );
}

room_cams_init()
{
	s_right_mirror = getstruct( "mirror_1_dir", "targetname" );
	level.e_right_mirror = Spawn( "script_model", s_right_mirror.origin );
	level.e_right_mirror SetModel( "tag_origin" );
	level.e_right_mirror.angles = s_right_mirror.angles;
	level.e_right_mirror.is_reflected_over_y = false;
	
	// store the original positions.
	level.e_right_mirror.s_fake_mirror = s_right_mirror;
	level.e_right_mirror.s_real_mirror = GetStruct( "mirror_1_real_room", "targetname" );
	
	s_left_mirror = getstruct( "mirror_2_dir", "targetname" );
	level.e_left_mirror = Spawn( "script_model", s_left_mirror.origin );
	level.e_left_mirror SetModel( "tag_origin" );
	level.e_left_mirror.angles = s_left_mirror.angles;
	level.e_left_mirror.is_reflected_over_y = true;
	
	level.e_left_mirror.s_fake_mirror = s_left_mirror;
	level.e_left_mirror.s_real_mirror = GetStruct( "mirror_2_real_room", "targetname" );
}

get_mirror_cam_offset( )
{
	v_player = level.player.origin;
	v_output = ( 0, 0, 0 );
	v_mirror = self.s_real_mirror.origin;
	v_vake = self.s_fake_mirror.origin;
	
	v_reflection = v_player - v_mirror;
	
	// TWEAK ME!
	if ( self.is_reflected_over_y )
	{
		v_reflection = ( -1 * v_reflection[0], v_reflection[1], v_reflection[2] );
	} else {
		v_reflection = (v_reflection[0], -1 * v_reflection[1], v_reflection[2] );
	}
	
	return v_reflection;
}

run_mirror_camera()
{
	self endon( "end_camera" );
	
	dist_mult = 0.6;
	offset_amount = 32;
	
	while ( true )
	{
		v_offset = get_mirror_cam_offset();
		a_dir = VectorToAngles( -1 * v_offset );
		
		if ( self.is_reflected_over_y )
		{
			v_offset = v_offset * dist_mult;
			v_offset = v_offset - ( offset_amount, 0, 0 );
		} else {
			v_offset = v_offset * dist_mult;
			v_offset = v_offset - ( 0, offset_amount, 0 );
		}
		
		frametime = 0.05;
		// self.origin = self.s_fake_mirror.origin + v_offset;
		// self.angles = a_dir;
		self MoveTo( self.s_fake_mirror.origin + v_offset, frametime, 0, 0 );
		self RotateTo( a_dir, frametime, 0, 0 );
		wait frametime;
		self.origin = self.s_fake_mirror.origin + v_offset;
		self.angles = a_dir;
	}
}

room_cams_left_on( m_player )
{
	//make sure the right camera is disabled
	level.e_right_mirror ClearClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );
	level.e_right_mirror notify( "end_camera" );
	
	wait 0.1;
	
	//turn on the left camera and hide the window
	level.e_left_mirror SetClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );  
	level.e_left_mirror thread run_mirror_camera();
}

room_cams_right_on( m_player )
{
	//make sure the right camera is disabled
	level.e_left_mirror ClearClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );
	level.e_left_mirror notify( "end_camera" );
	
	wait 0.1;
	
	//turn on the left camera and hide the window
	level.e_right_mirror SetClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );  
	level.e_right_mirror thread run_mirror_camera();
}

room_cams_cleanup( delete_cams )
{
	level.e_left_mirror ClearClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );
	level.e_right_mirror ClearClientFlag( CLIENT_FLAG_MIRROR_EXTRA_CAM );
	
	level.e_left_mirror notify( "end_camera" );
	level.e_right_mirror notify( "end_camera" );
	
  	wait_network_frame();
  	
  	if ( delete_cams )
  	{
  		level.e_left_mirror Delete();
   		level.e_right_mirror Delete();
  	}
}

#define INTRO_CAM_DT 0.05
#define INTRO_CAM_AIM_CLAMP_YAW 5	
#define INTRO_CAM_AIM_CLAMP_PITCH 5
#define INTRO_CAM_AIM_MAX_VEL 1
#define INTRO_CAM_ANGLE_CLAMP 10
//function aims the intro interrogation camera
camera_aim_update()
{
	//notified in the function that shuts this extra cam down
	self endon( "stop_camera_control" );

	// initial offset
	offset = ( 0, 0, 0 );
	INTRO_CAM_aim_vel = ( 0, 0, 0 );	
	max_INTRO_CAM_aim_vel = ( INTRO_CAM_AIM_MAX_VEL, INTRO_CAM_AIM_MAX_VEL, 0 );	
	
	// determine angle restraints
	start_angles = ( self.angles[0], self.angles[1], 0 );			
	angle_x_1 = self.angles[0] - INTRO_CAM_ANGLE_CLAMP;
	angle_x_2 = self.angles[0] + INTRO_CAM_ANGLE_CLAMP;
	angle_y_1 = self.angles[1] - INTRO_CAM_ANGLE_CLAMP;
	angle_y_2 = self.angles[1] + INTRO_CAM_ANGLE_CLAMP;
	
	// update aim
	while ( 1 )
	{
		stick = level.player GetNormalizedCameraMovement();
		
		clamp_yaw = INTRO_CAM_AIM_CLAMP_YAW;
		clamp_pitch = INTRO_CAM_AIM_CLAMP_PITCH;		
					
		// Get INTRO_CAM velocity
		desired_aim_vel_yaw = ( Abs( offset[1] ) >= clamp_yaw && ( offset[1] * -stick[1] >= 0 ) ? 0 : -stick[1] * max_INTRO_CAM_aim_vel[1] );
		desired_aim_vel_pitch = ( Abs( offset[0] ) >= clamp_pitch && ( offset[0] * -stick[0] >= 0 ) ? 0 : -stick[0] * max_INTRO_CAM_aim_vel[0] );
		
		intro_cam_aim_vel_yaw = DiffTrack( desired_aim_vel_yaw, intro_cam_aim_vel[1], 3, INTRO_CAM_DT );
		intro_cam_aim_vel_pitch = DiffTrack( desired_aim_vel_pitch, INTRO_CAM_aim_vel[0], 3, INTRO_CAM_DT );
		intro_cam_aim_vel = ( intro_cam_aim_vel_pitch, intro_cam_aim_vel_yaw, 0 );
		
		// Integrate angular velocity	
		offset += intro_cam_aim_vel * INTRO_CAM_DT;
		
		// Clamp and add offset
		p = clamp( offset[0], -clamp_pitch, clamp_pitch );
		y = clamp( offset[1], -clamp_yaw, clamp_yaw );
		offset = ( p, y, 0 );
		new_angles = start_angles + offset;
		
		// Clamp final angles
		a_x = clamp( new_angles[0], angle_x_1, angle_x_2 );
		a_y = clamp( new_angles[1], angle_y_1, angle_y_2 );
		self.angles = ( a_x, a_y, self.angles[2] );
			
		wait INTRO_CAM_DT;
	}
}

/////////////////////////////////////
//         SUPPORT FUNCTIONS       //
/////////////////////////////////////


// updates the player's ammo when he picks his weapons back up.
// stop doing that once he gets to the doorway.
//
update_player_ammo()
{
	level endon( "can_see_hallway" );
	
	// wait until the player has at least one primary weapon.
	wpn_list = [];
	num_weapons = wpn_list.size;
	while ( true )
	{
		wpn_list = level.player GetWeaponsListPrimaries();
		
		// if he now has more weapons
		if ( num_weapons != wpn_list.size )
		{
			// fill up all his weapons.
			for ( i = 0; i < wpn_list.size; i++ )
			{
				level.player refill_weapon_clip( wpn_list[i] );
				level.player GiveMaxAmmo( wpn_list[i] );
			}
			num_weapons = wpn_list.size;
		}
		wait 0.2;
	}
}

spawn_interrogation_heroes()
{
	level.briggs = init_hero( "briggs" );
	level.briggs.ignoreme = true;
	level.briggs.ignoreall = true;
	level.briggs.name = "Briggs";
	
	level.salazar = init_hero( "salazar" );
	level.salazar.name = "Salazar";
	
	level.menendez = init_hero( "menendez" );
	level.menendez.name = "Menendez";
	
	level.salazar custom_ai_weapon_loadout( "fiveseven_sp" );
}

briggs_nag_mason()
{
	level endon( "briggs_stop_nag" );	
	
	level.briggs say_dialog( "brig_he_won_t_speak_to_an_0" );
	level.briggs say_dialog( "brig_you_want_to_try_agai_0" );
	level.player say_dialog( "sect_don_t_know_if_it_ll_0" );
	level.briggs say_dialog( "brig_do_what_you_can_i_l_0" );
}

battle_trig_think( trigger_name, ai_group_name )
{
	self endon( "death" );
	
	// grab the info volume where we'll send the soldiers.
	info_vol_name = self.target;
	info_vol = GetEnt( info_vol_name, "targetname" );
	
	e_other = trigger_wait();
	
	// copy the info volume as our new battle volume for this group
	group = level._ai_group[ ai_group_name ];
	group.battle_volume = info_vol;
	
	// move all existing AI to that volume
	ai_list = get_ai_group_ai( ai_group_name );
	for ( i = 0; i < ai_list.size; i ++ )
	{
		ai_list[i] SetGoalVolumeAuto( group.battle_volume );
	}
}

track_enemy_volumes( trigger_script_noteworthy, ai_group_name )
{
	// clear any old battle volume defined.
	group = level._ai_group[ ai_group_name ];
	group.battle_volume = undefined;
	
	add_spawn_function_ai_group( ai_group_name, ::hallway_enemy_spawn_func, ai_group_name );
	
	trigs = GetEntArray( trigger_script_noteworthy, "script_noteworthy" );
	array_thread( trigs, ::battle_trig_think, trigger_script_noteworthy, ai_group_name );
}

hallway_enemy_spawn_func( ai_group_name )
{
	group = level._ai_group[ ai_group_name ];
	
	// if this group has already been assigned a battle volume
	// use that.  otherwise, continue as usual.
	if ( IsDefined( group.battle_volume ) )
	{
		self SetGoalVolumeAuto( group.battle_volume );
	}
}

// Removes the player's guns and places them in the cabinet.
//
// module: player
remove_guns()
{
	weapon_names = self GetWeaponsListPrimaries();
	positions = GetEntArray( "player_equipment_pos", "targetname" );
	safe_spawn_pos = getstruct( "weapon_spawn_pos", "targetname" );
	
	// drop your primary weapons.
	level.num_weapons_taken = 0;
	for ( i = 0; i < weapon_names.size; i++)
	{
		if ( weapon_names[i] != "knife_sp" )
		{
			// take the weapon.
			self TakeWeapon( weapon_names[i] );
			
			// create a new copy of that weapon.
			wpn = Spawn( "weapon_" + weapon_names[i], safe_spawn_pos.origin, 0 );
			
			// spawn it on the wall if we have a place to put it.
			if ( i < positions.size )
			{
				wpn.origin = positions[i].origin;
				wpn.angles = positions[i].angles;
				wpn LinkTo( positions[i] );
			}
			
			level.num_weapons_taken++;
		}
	}
	
	// player cannot melee or throw grenades either.
	self SetLowReady( true );
	self AllowMelee( false );
	self AllowPickupWeapons( false );
	self DisableWeapons();
}

move_interrogation_door( open_door, time_s, reverse_angle )
{
	// there are actually 2 of these doors, since there are two of this room.
	doors = GetEntArray( "interrogation_door_collision", "targetname" );
	foreach ( door in doors )
	{
		if ( !IsDefined( door.isopen ) )
		{
			door.isopen = false;
		}
		
		if ( !IsDefined( time_s ) )
		{
			time_s = 0.1;
		}
		
		if ( door.isopen == open_door )
		{
			return;
		}
		
		angle = 90;
		if ( is_true( reverse_angle ) )
		{
			angle = -270;
		}
		
		if ( open_door )
		{
			angle = -1 * angle;
		}
		
		door RotateYaw( angle, time_s, 0, 0 );
			
		door.isopen = open_door;
	}
}

taser_knuckles_pickup()
{
	run_scene_first_frame( "taser_knuckle_crate" );
	
	// put the lock on the drawer.
	taser_trigger = getent( "knuckles_pickup_trigger", "targetname" );
	
	taser_trigger trigger_off();
	
	level waittill( "mason_wakeup" );
	
	level.player waittill_player_has_intruder_perk();
	
	taser_trigger trigger_on();
	
	set_objective( level.OBJ_LOCK_PERK, taser_trigger, "interact" );
	
	taser_trigger SetCursorHint( "HINT_NOICON" );
	taser_trigger SetHintString( &"BLACKOUT_KNUCKLE_PICKUP" );
	
	trigger_wait( "knuckles_pickup_trigger" );
	
	set_objective( level.OBJ_LOCK_PERK, undefined, "remove" );
	
	level thread run_scene_and_delete( "taser_knuckle_crate" );
	level thread run_scene_and_delete( "taser_knuckle_get" );
	
	wait_network_frame();
	player_body = get_model_or_models_from_scene( "taser_knuckle_get", "player_body" );
	player_body Attach( "c_usa_cia_masonjr_viewbody_vson", "J_WristTwist_LE" );
	
	level.player GiveWeapon( "tazer_knuckles_sp" );
	flag_set("lockbreaker_used");
	taser_trigger trigger_off();
}

setup_hallway_ally()
{
	self endon( "death" );
	self change_movemode( "cqb_run" );
	
	wait 3.0;
	
	// one hit point--make them die quickly.
	self SetNormalHealth( 1 );
}

///////////////////////////////
//    ANIMATION CALLBACKS    //
///////////////////////////////

callback_player_knocked_out( player )
{
	level.player DoDamage(50, level.player.origin);
	level.player shellshock( "death", 3 );
	wait 0.5;
	screen_fade_out( 1.0 );
}

///////////////////////////////
//    EXTERNAL FUNCTIONS     //
///////////////////////////////

init_flags()
{
	flag_init( "intro_disable_camera" );
	flag_init( "intro_disable_handcuffs" );
	flag_init( "accept_getup_help" );
	flag_init( "intro_camera_on" );
}

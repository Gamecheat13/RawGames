#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{

	flag_init( "suspicious_pip_on" );	
	flag_init( "near_bombs" );				// set by trigger
	flag_init( "near_gulliver" );			// set by trigger
	flag_init( "spiderbot_entered_crc" );	// set by trigger
	flag_init( "guys_alerted" );
	flag_init( "alarm_activated" );
	flag_init( "scanned_retina" );
	flag_init( "spiderbot_end" );

// PROBABLY UNUSED NOW	
//	flag_init( "bug_zapper_disabled" );
//	flag_init( "spiderbot_in_swarm_hall" );
	flag_init( "camera_ready" );	//TODO <- this is stupid.  Remove
//	flag_init( "it_room_cleared" );
	flag_init( "bomb_found" );	// set by trigger
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "comp_security", ::it_guy_think );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
spiderbot_teleport( str_location )
{
	// Skipto movement
	s_tp_spot = GetStruct( str_location, "targetname" );
	level.vh_spiderbot.origin = s_tp_spot.origin;
	level.vh_spiderbot.angles = s_tp_spot.angles;
	
	level.vh_spiderbot UseBy( level.player );
}


skipto_spiderbot()
{
//	level.ai_harper 	= init_hero( "harper" );

	start_teleport( "skipto_spiderbot" );
	
	// this is to make the skipto more consistent by giving time for the teleport to occur
	// so that the player is right next to the spiderbot when the getin command occurs
	wait( 0.5 );
}


//
//
skipto_gulliver()
{
	start_teleport( "skipto_gulliver" );

	prep_spiderbot();
	spiderbot_teleport( "skipto_gulliver_spider" );

	t_crumb = GetEnt( "t_spiderbot_enter_crc", "targetname" );
	set_objective( level.OBJ_ENTER_CRC, t_crumb );

	maps\karma_anim::spiderbot_anims();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
vents()
{
	// Temp Development info
	/#
		IPrintLn( "Spiderbot" );
	#/

	level thread maps\createart\karma_art::karma_fog_spiderbot();
	maps\karma_anim::spiderbot_anims();

	// Initialization
	prep_spiderbot();
	// This was hidden in the lobby stuff so we could animate a prop spiderbot
	level.vh_spiderbot Show();
	level.vh_spiderbot MakeVehicleUsable();
	level.vh_spiderbot UseBy( level.player );
	level.vh_spiderbot MakeVehicleUnusable();

	level thread objective_breadcrumb( level.OBJ_ENTER_CRC, "t_spiderbot_crumbs" );
		
//	spiderbot_vents();

	flag_wait( "suspicious_pip_on" );		// set by trigger
	
	level thread suspicious_guys_pip();

	flag_wait( "near_bombs" );		// set by trigger
	
//	simple_spawn( "ai_bomb_planters" );
	level thread run_scene_and_delete( "planting_bombs" );
	level thread spin_giant_fan();
	
	flag_wait( "near_gulliver" );	// set by trigger

	level thread autosave_by_name( "karma_gulliver" );
}


//
//
gulliver()
{
	// Need to clear the alert from the previous room so we don't go
	//	running right away
	ai_gulliver = simple_spawn_single( "gulliver", ::gulliver_think );

	flag_wait( "spiderbot_entered_crc" );	// set by trigger
	
	// Drop down on CRC guy
	// get out before playing the animation, then get back in
//TODO stay inside for now, until we get the spiderbot animating properly	
//	level.vh_spiderbot Useby( level.player );
//	level.player FreezeControls( true );
	level.vh_spiderbot ent_flag_set( "playing_scripted_anim" );
	run_scene_and_delete( "it_mgr_surprise" );

//	level.vh_spiderbot Useby( level.player );
	level.vh_spiderbot ent_flag_clear( "playing_scripted_anim" );
//	level.player FreezeControls( false );
	self.ignoreall = true;

	set_objective( level.OBJ_ENTER_CRC, undefined );
	set_objective( level.OBJ_CRC_GUY, ai_gulliver, "shoot" );

	flag_wait( "scanned_retina" );

	screen_fade_out();
	
	level.player Unlink();
//	level.vh_spiderbot MakeVehicleUsable();
//	level.vh_spiderbot UseBy( level.player );
//	wait( 1 );
	
	flag_set( "spiderbot_end" );

	level thread screen_fade_in();
	level thread spiderbot_cleanup();
}


/* ------------------------------------------------------------------------------------------
	SUPPORT functions
 -------------------------------------------------------------------------------------------*/

//
//	Prep the spiderbot to be used.
prep_spiderbot()
{
	old_n_znear = GetDvar( "r_znear" );

	SetDvar( "r_znear", 1 );

	level.vh_spiderbot = GetEnt( "spiderbot", "targetname" );
	level.vh_spiderbot thread maps\_spiderbot::main();
//	level.vh_spiderbot thread spiderbot_jump();
	
	// Spawn spotlight
	level.vh_spiderbot thread bot_lights();
}


//
//	Control the spiderbot's light turning on and off
//	"spiderbot_light" is set and cleared in radiant.
//	self is the spiderbot
bot_lights()
{
	level endon( "spiderbot_end" );

	self waittill( "enter_vehicle", player );
	wait( 0.05 );	// wait until clientscript is ready
	
	flag_set( "spiderbot_light" );
	
	while (1)
	{
		ClientNotify( "spiderbot_light_on" );
		
		while( flag( "spiderbot_light" ) )
		{
			wait( 0.5 );
		}

		ClientNotify( "spiderbot_light_off" );

		flag_wait( "spiderbot_light" );
	}
}


//
//	Keep rotating the giant fan
spin_giant_fan()
{
	level endon( "spiderbot_end" );
	
	m_fan = GetEnt( "spiderbot_fan", "targetname" );
	m_fan SetScale( 3.25 );
//	level thread setup_proximity_scan_and_alarm( m_fan, "audio_passed", "spiderbot_end", 125 );
	add_cleanup_ent( "spiderbot", m_fan );
	CONST n_time = 10.0;
	while (1)
	{
		m_fan RotateYaw( 3600, n_time );
		wait( n_time );
	}
}


//-------------------------------------------------------------------------------------------
// Han becomes suspicious of the security guards.
//-------------------------------------------------------------------------------------------
suspicious_guys_pip()
{
	e_camera_one = simple_spawn_single( "suspicious_guys_camera", ::camera_think );

	//-------------------------------------------------------------------------------------------
	// Animation of suspicious dudes looking around.
	//-------------------------------------------------------------------------------------------	
	level thread run_scene_and_delete( "scene_suspicious_guys" );	
	
	flag_wait( "camera_ready" );

	turn_on_extra_cam();

	scene_wait( "scene_suspicious_guys" );

	turn_off_extra_cam();
	
	level.e_extra_cam Unlink();
}


//-------------------------------------------------------------------------------------------
// Han notfies player that suspicious dudes are leaving.
//-------------------------------------------------------------------------------------------
suspicious_guys_leaving_pip()
{
	// Flag is a trigger box.
	flag_wait( "bomb_found" );

	e_camera_two = simple_spawn_single( "suspicious_guys_camera", ::camera_think );
	
	wait 3;
	
	//-------------------------------------------------------------------------------------------
	// Animation of suspicious dudes leaving.
	//-------------------------------------------------------------------------------------------
	level thread run_scene_and_delete( "scene_suspicious_guys_leaving" );	
	
	flag_wait( "camera_ready" );

	turn_on_extra_cam();

	scene_wait( "scene_suspicious_guys_leaving" );

	turn_off_extra_cam();
	
	wait 1;
	
	level.e_extra_cam Unlink();
//	e_camera_two delete();
	
}

/*
//
//	The spiderbot roams the vents
spiderbot_vents()
{
	flag_wait( "near_big_fan" );

	level thread spin_giant_fan();
	level thread fan_death();
	
	autosave_now( "karma_fan" );

	
	flag_wait( "near_bug_zapper" );
	
	level thread setup_proximity_scan_and_alarm( getent("trig_bug_zapper", "targetname" ), "zapped", "spiderbot_end", 75 );
	thread fly_in_the_vent();
	thread zapper_power_box();
	autosave_now( "karma_zapper" );
}


//
//	fails the mission if you fall into the fans
fan_death()
{
	level endon( "spiderbot_end" );
	
	trigger_wait( "trig_fan_death" );
	
	spiderbot_lost( &"KARMA_FAILED_LOST_SIGNAL" );
}


//
//	Wait for a zap, then disable the damage trigger
zapper_power_box()
{
	exploder(445);
	audio_player = GetEnt( "trig_bug_zapper", "targetname" );
	audio_player playloopsound( "amb_spiderbot_trap_looper" );
	audio_player_origin = audio_player.origin;
	
	trigger_wait( "trig_zapper_power" );
	
	flag_set( "bug_zapper_disabled" );
	exploder(444);
	t_zapper_field = GetEnt( "trig_bug_zapper", "targetname" );
	t_zapper_field notify( "zapped" );
	t_zapper_field Delete();
	
	playsoundatposition( "amb_spiderbot_trap_off", audio_player_origin );
	
	stop_exploder(445);
}


//
//	FX of fly in the vents running into the bug zapper
fly_in_the_vent()
{
	//TODO This was supposed to be a trigger_lookat, but I'm having issues with
	// getting it to work because the call to GetEye in trigger_lookat_think
	//	is returning a point at my feet.
//	flag_wait( "vent_fly" );
	trigger_wait( "trig_vent_fly" );
	
	exploder( 441 );
	
	trigger_wait( "trig_shoo_fly" );
	
	exploder( 442 );
	wait( 3.0 );	// this is the current length of the FX
	
	if ( !flag( "bug_zapper_disabled" ) )
	{
		exploder( 443 );
	}
}
*/


// temp thread until we get anims.
bomb_planters()
{
	self.ignoreall = true;

	flag_wait( "scanned_retina" );
	
	self Delete();
}


//-------------------------------------------------------------------------------------------
// Camera setup.
//-------------------------------------------------------------------------------------------
camera_think()
{
	v_camera_eyes = self GetEye();
	level.e_extra_cam.origin = v_camera_eyes;
	level.e_extra_cam.angles = self.angles;
	level.e_extra_cam LinkTo( self );	
	self Hide();
	flag_set( "camera_ready" );
}


//
//	Signal the alarm and end the mission.
//	The alarm system generates a jamming signal, so contact with the spiderbot is lost
//	Notetrack function
alarm_pressed( ai_callback )
{
	level endon( "scanned_retina" );

	flag_set( "alarm_activated" );
	
	// Alarm sounds
	exploder( 475 );
	wait( 2.0 );
	
	// Full static
	spiderbot_lost( &"KARMA_FAILED_ALARM_SOUNDED" );
}


//------------------------------
//	GULLIVER
//------------------------------
gulliver_think()
{
	self endon( "damage" );
	
	add_cleanup_ent( "spiderbot", self );

	self.team = "axis";
	self.ignoreall = true;
	self.goalradius = 16;
	self SetGoalPos( self.origin );
	
	thread run_scene_and_delete( "it_mgr_idle" );

	// Don't let the player kill the AI
	self thread magic_bullet_shield();

//	self change_movemode( "cqb_walk" );
	self thread gulliver_wait_for_tazer();

	// wait until the player enters the area
	flag_wait( "spiderbot_entered_crc" );	// set by trigger

}


//
//	wait until you receive damage and then perform electrocution anim
gulliver_wait_for_tazer()
{
	self waittill( "damage" );

	set_objective( level.OBJ_CRC_GUY, undefined, "done" );
	set_objective( level.OBJ_CRC_GUY, undefined, "delete" );
	
	//TODO This needs to be a standing notetrack
	if ( flag( "guys_alerted" ) )
	{
		self run_scene_and_delete( "it_mgr_shock_run" );
	}
	else
	{
		self run_scene_and_delete( "it_mgr_shock_stationary" );
	}
	
	self thread run_scene_and_delete( "it_mgr_twitch_idle" );
	
	// Move the body clip over
	bm_body_clip = GetEnt( "clip_gulliver", "targetname" );
	bm_body_clip.origin = self.origin;
	bm_body_clip.angles = self.angles;
	
	// Wait for eye scan
	self NotSolid();
	self thread gulliver_wait_for_scan( bm_body_clip );
}


//
//	Wait for the player to get near, then enact the eye scan
gulliver_wait_for_scan( bm_clip )
{
	// Estimate the eye position.
	v_eye = self GetEye();
	n_dist = Distance( v_eye, level.vh_spiderbot.origin );

	set_objective( level.OBJ_SCAN_EYE, v_eye );

	while ( n_dist > 12 )
	{
		wait( 0.1 );

		n_dist = Distance( v_eye, level.vh_spiderbot.origin );
	}

	level.vh_spiderbot playsound( "evt_spiderbot_retinal_scan" );
	
	// We need to move the align node into position before doing the eye scan.
	bm_clip Delete();	// Delete the clip so the spider doesn't collide with it
	
	s_align = GetStruct( "gulliver_align", "targetname" );
	s_align.origin = self.origin;
	s_align.angles = self.angles;
	
	// Get the player out of the vehicle for the animation.
	level.vh_spiderbot ent_flag_set( "playing_scripted_anim" );
	level thread run_scene_and_delete( "eye_scan" );

	wait( 0.5 );
	
	// Play scanner effect
	v_tag_origin = level.vh_spiderbot GetTagOrigin( "tag_flash" );
	sm_tag_origin = Spawn( "script_model", v_tag_origin );
	sm_tag_origin SetModel( "tag_origin" );
	sm_tag_origin.angles = level.vh_spiderbot.angles;
	sm_tag_origin LinkTo( level.vh_spiderbot );
	PlayFxOnTag( level._effect["spiderbot_scanner"], sm_tag_origin, "tag_origin" );
	
	scene_wait( "eye_scan" );

	level.vh_spiderbot ent_flag_clear( "playing_scripted_anim" );
	level.vh_spiderbot Useby( level.player );
	sm_tag_origin Delete();
	set_objective( level.OBJ_SCAN_EYE, undefined, "done" );
	set_objective( level.OBJ_SCAN_EYE, undefined, "delete" );
	flag_set( "scanned_retina" );
}


//
//	The player loses contact with the spiderbot, either due to death 
//	or jamming
spiderbot_lost( str_msg )
{
	level.fade_screen.fadeTimer = 0.05;
	level.fade_screen.foreground = false;
	screen_fade_out();
	
	missionfailedwrapper( str_msg );
}
	
	
//
//
spiderbot_cleanup()
{
	cleanup_ents( "spiderbot" );
}


//########################################################
//						AUDIO
//########################################################
setup_proximity_scan_and_alarm( danger, danger_ender, level_ender, dist )
{
	danger endon( "death" );
	
	if( isdefined( danger_ender ) )
		danger endon( danger_ender );
	if( isdefined( level_ender ) )
		level endon( level_ender );
	
	if( !isdefined( dist ) )
		dist = 50;
	
	spiderbot = level.vh_spiderbot;
	
	danger._audio_alarm_active = false;
	
	while(1)
	{
		distance_diff = distance( danger.origin, spiderbot.origin );
		
		if( distance_diff <= dist )
		{
			if( !danger._audio_alarm_active )
			{
				danger._audio_alarm_active = true;
				spiderbot thread play_scan_and_alarm( danger, danger_ender, level_ender );
				spiderbot thread stop_alarms_on_ender( danger, danger_ender, level_ender );
			}
		}
		else
		{
			if( danger._audio_alarm_active )
			{
				danger._audio_alarm_active = false;
				spiderbot notify( "audio_stop_alarms" );
				spiderbot playsound( "veh_spiderbot_safe" );
			}
		}
		
		wait(.1);
	}
}

play_scan_and_alarm( danger, danger_ender, level_ender )
{
	self endon( "audio_stop_alarms" );
	self endon( "death" );
	danger endon( "death" );
	
	if( isdefined( danger_ender ) )
		danger endon( danger_ender );
	if( isdefined( level_ender ) )
		level endon( level_ender );
	
	self playsound( "veh_spiderbot_scan" );
	wait(.9);
	
	while(1)
	{
		self playsound( "veh_spiderbot_alarm" );
		wait(.4);
	}
}

stop_alarms_on_ender( danger, danger_ender, level_ender )
{
	self endon( "audio_stop_alarms" );
	self endon( "death" );
	danger endon( "death" );
	
	if( isdefined( level_ender ) )
		level endon( level_ender );
	
	if( isdefined( danger_ender ) )
	{
		danger waittill( danger_ender );
		self playsound( "veh_spiderbot_safe" );
	}
}

spiderbot_scanning_audio()
{
	self endon( "tazed" );
	
	spiderbot = level.vh_spiderbot;
	
	while(1)
	{
		if( distance( self.origin, spiderbot.origin ) <= 75 )
		{
			break;
		}
		
		wait(.1);
	}
	
	self thread playsound_on_zapped( spiderbot );
	spiderbot playsound( "veh_spiderbot_scan" );
	wait(.9);
	spiderbot playsound( "veh_spiderbot_scan_human" );
}

playsound_on_zapped( spiderbot )
{
	self waittill( "tazed" );
	
	wait(.5);
	spiderbot playsound( "veh_spiderbot_safe" );
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//---------------------------------------------------------------cleaning bots-------------
bots_alive_challenge( str_notify )  // self == player
{
	level endon( "bots_alive_challenge_complete" );
	level endon( "zapped" );
	
	flag_wait( "scanned_retina" );
	
	self notify( str_notify );
	
	level notify( "bots_alive_challenge_complete" );
}
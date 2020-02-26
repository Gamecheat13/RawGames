#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "spiderbot_bootup_done" );

	flag_init( "near_bombs" );				// set by trigger
	flag_init( "bomb_found" );				// set by trigger
	flag_init( "near_bug_zapper" );			// set by trigger
    flag_init( "near_power_box" );			// set by trigger
	flag_init( "bug_zapper_disabled" );
	flag_init( "near_gulliver" );			// set by trigger
	flag_init( "spiderbot_entered_crc" );	// set by trigger
	flag_init( "say_taze_him" );	
	flag_init( "it_mgr_disabled" );	
	flag_init( "scanning_eye" );
//	flag_init( "start_stomp_sequence" );
//	flag_init( "do_stomp" );
//	flag_init( "stomp_precalc_complete" );
	
	flag_init( "spiderbot_end" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    	add_spawn_function_group( "tarmac_workers", "targetname", ::add_cleanup_ent, "checkin" );
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
	level.vh_spiderbot MakeVehicleUnusable();
}


skipto_spiderbot()
{
	skipto_teleport( "skipto_spiderbot" );
	
	// this is to make the skipto more consistent by giving time for the teleport to occur
	// so that the player is right next to the spiderbot when the getin command occurs
	wait( 0.5 );
}


//
//
skipto_gulliver()
{
	skipto_teleport( "skipto_gulliver" );

	prep_spiderbot();
	spiderbot_teleport( "skipto_gulliver_spider" );

	// breadcrumb objective marker through the vents
	level.vh_spiderbot thread objective_breadcrumb_area( level.OBJ_ENTER_CRC, "breadcrumb_spiderbot", "spiderbot_entered_crc" );

	maps\karma_anim::spiderbot_anims();
	level.ai_gulliver = simple_spawn_single( "gulliver", ::gulliver_think );

	a_m_fans = GetEntArray( "spiderbot_fan", "targetname" );
	array_thread( a_m_fans, ::spin_fan );
	level thread fan_death();
	level thread setup_proximity_scan_and_alarm( getent("trig_bug_zapper", "targetname" ), "zapped", "spiderbot_end", 75 );
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
	
	level.player FreezeControls( true );
	level thread maps\createart\karma_art::vision_set_change( "karma_spiderbot" );
	maps\karma_anim::spiderbot_anims();

	// Initialization
	prep_spiderbot();
	// This was hidden in the lobby stuff so we could animate a prop spiderbot
	level.player SetStance( "stand" );
	level.player SetOrigin( level.vh_spiderbot.origin );
	level.vh_spiderbot Show();
	level.vh_spiderbot UseBy( level.player );
	level.vh_spiderbot MakeVehicleUnusable();
	level.vh_spiderbot thread display_hints();
	flag_set( "spiderbot_bootup_done" );

	level.player FreezeControls( false );
	level.player thread spiderbot_dialog();

	level.ai_gulliver = simple_spawn_single( "gulliver", ::gulliver_think );

	// breadcrumb objective marker through the vents
	level.vh_spiderbot thread objective_breadcrumb_area( level.OBJ_ENTER_CRC, "breadcrumb_spiderbot", "spiderbot_entered_crc" );

	a_m_fans = GetEntArray( "spiderbot_fan", "targetname" );
	array_thread( a_m_fans, ::spin_fan );

	flag_wait( "near_bombs" );		// set by trigger

	level thread run_scene_and_delete( "planting_bombs" );

	flag_wait( "bomb_found" );
	
	level thread setup_proximity_scan_and_alarm( getent("trig_bug_zapper", "targetname" ), "zapped", "spiderbot_end", 75 );
	level thread zapper_power_box();
	level thread autosave_now( "karma_zapper" );

	set_objective( level.OBJ_DISABLE_ZAPPER );
	flag_wait( "bug_zapper_disabled" );
	
	set_objective( level.OBJ_DISABLE_ZAPPER, undefined, "delete" );
	
	// Fans
	trigger_wait( "t_near_fans" );
	
	level thread fan_death();
	autosave_now( "karma_fans" );

	// Gulliver
	flag_wait( "near_gulliver" );	// set by trigger
	


	level thread autosave_now( "karma_gulliver" );
}


//
//	Ambush the guy in the CRC room and scan his eye
gulliver()
{
	trigger_wait( "t_see_gulliver" );

	// Drop down on CRC guy
	level.player thread gulliver_dialog();
	
	//SOUND - Shawn J
	clientnotify ("drpdn");

	Objective_Set3D( level.OBJ_ENTER_CRC, false );
	set_objective( level.OBJ_CRC_GUY, level.ai_gulliver, "disable" );
	
	flag_wait( "spiderbot_entered_crc" );	// set by trigger

	// Need this flag set when playing an anim
	level.vh_spiderbot ent_flag_set( "playing_scripted_anim" );

	run_scene_and_delete( "it_mgr_vent_open" );

	//Set music to Gulliver
	setmusicstate ("KARMA_1_GULLIVER");
	
	level.ai_gulliver setviewmodelrenderflag( true );
	run_scene_and_delete( "it_mgr_surprise", 0.5 );

	if ( flag( "it_mgr_disabled" ) )
	{
		level.ai_gulliver gulliver_eye_scan();
	}
	else
	{
		// Death
		spiderbot_lost( &"KARMA_FAILED_LOST_SIGNAL" );
	}

	level.vh_spiderbot ent_flag_clear( "playing_scripted_anim" );
	flag_wait( "spiderbot_end" );

	// Return to normal
	level.player SetClientDvar("cg_objectiveIndicatorNearDist", 2.0 );
	level.vh_spiderbot Useby( level.player );
	level.vh_spiderbot MakeVehicleUsable();
    wait( 0.05 );	// wait so that other functions can process the "exit_vehicle" message
    
	level thread screen_fade_in( 2 );
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

	level.vh_spiderbot = maps\_vehicle::spawn_vehicle_from_targetname( "spiderbot" );
	level.vh_spiderbot thread maps\_spiderbot::main();
	level.vh_spiderbot add_cleanup_ent( "cleanup_spiderbot" );
	
	// Reduce the fade out distance for objective indicators.  Both dvars need to be set for this to work
	level.cg_objectiveIndicatorNearFadeDist = GetDVarFloat( "cg_objectiveIndicatorNearFadeDist" );
	level.objectiveIndicatorNoDrawDistance  = GetDvarFloat( "objectiveIndicatorNoDrawDistance" );
	level.player SetClientDvar("cg_objectiveIndicatorNearFadeDist", 0.01 );
	level.player SetClientDvar("objectiveIndicatorNoDrawDistance", 0.01 );

	level.player SetClientDvar( "vehicle_riding", false );
}


//
//	Display various spiderbot hints
display_hints()
{
	trigger_wait( "t_spiderbot_climb" );
	
	screen_message( &"KARMA_HINT_SPIDERBOT_CLIMB", 3 );
	
	trigger_wait( "t_spiderbot_jump" );

	screen_message( &"KARMA_HINT_SPIDERBOT_JUMP", 3 );

	screen_message( &"KARMA_HINT_SPIDERBOT_REGISTER", 3 );

	flag_wait( "near_power_box" );

	if ( !flag( "bug_zapper_disabled" ) )
	{
		screen_message( &"KARMA_HINT_SPIDERBOT_TAZER", 3 );
	}
}


//
//	Keep rotating the giant fan
spin_fan()
{
	level endon( "spiderbot_end" );
	
	self add_cleanup_ent( "cleanup_spiderbot" );

	if ( IsDefined( self.script_float ) )
	{
		self IgnoreCheapEntityFlag( true );
		self SetScale( self.script_float );
	}

//	level thread setup_proximity_scan_and_alarm( m_fan, "audio_passed", "spiderbot_end", 125 );
	CONST n_time = 10.0;
	while (1)
	{
		self RotateYaw( 3600, n_time );
		wait( n_time );
	}
}


//
//	fails the mission if you fall into the fans
fan_death()
{
	level endon( "spiderbot_end" );
	
	trigger_wait( "trig_fan_death" );
	
	spiderbot_lost( &"KARMA_FAILED_LOST_SIGNAL" );
}



//-------------------------------------------------------------------------------------------
// Han notfies player that suspicious dudes are leaving.
//-------------------------------------------------------------------------------------------
suspicious_guys_leaving_pip()
{
	e_camera_two = simple_spawn_single( "suspicious_guys_camera", ::camera_think );
	
	// Animation of suspicious dudes leaving.
	level thread run_scene_and_delete( "scene_suspicious_guys_leaving" );	
	
	turn_on_extra_cam();

	scene_wait( "scene_suspicious_guys_leaving" );

	turn_off_extra_cam();

	wait 1;

	level.e_extra_cam Unlink();
//	e_camera_two delete();
	
}


//
//	Wait for a zap, then disable the damage trigger
zapper_power_box()
{
	exploder(445);	// zapper field
	
	// NOTE: This trigger is in an odd location because the actual detection radius
	//	is a lot larger than you might expect, even with Vehicle and Not Player checked.
	//	Since we're dealing with something a lot smaller than we're usually used to,
	//	it's a necessary concession.
	t_zapper_field = GetEnt( "trig_bug_zapper", "targetname" );
	t_zapper_field thread zap_player();
	t_zapper_field playloopsound( "amb_spiderbot_trap_looper" );

	audio_player_origin = t_zapper_field.origin;
	trigger_wait( "trig_zapper_power" );
	
	screen_message_delete();
	flag_set( "bug_zapper_disabled" );
	exploder(444);	// sparks (not Tyler)
	t_zapper_field notify( "zapped" );
	t_zapper_field Delete();
	
	playsoundatposition( "amb_spiderbot_trap_off", audio_player_origin );
	
	stop_exploder(445);	// zapper field
}


//
//	Player ran into the electric field...ZAP!
zap_player()
{
	level endon( "bug_zapper_disabled" );

	self waittill( "trigger" );

	spiderbot_lost( &"KARMA_FAILED_LOST_SIGNAL" );
}

	
////
////	FX of fly in the vents running into the bug zapper
//fly_in_the_vent()
//{
//	//TODO This was supposed to be a trigger_lookat, but I'm having issues with
//	// getting it to work because the call to GetEye in trigger_lookat_think
//	//	is returning a point at my feet.
////	flag_wait( "vent_fly" );
//	trigger_wait( "trig_vent_fly" );
//	
//	exploder( 441 );
//	
//	trigger_wait( "trig_shoo_fly" );
//	
//	exploder( 442 );
//	wait( 3.0 );	// this is the current length of the FX
//	
//	if ( !flag( "bug_zapper_disabled" ) )
//	{
//		exploder( 443 );
//	}
//}



//------------------------------
//	GULLIVER
//------------------------------
gulliver_think()
{
	self endon( "damage" );

	self add_cleanup_ent( "cleanup_crc" );

	self.team = "axis";
	self.ignoreall = true;
	self.goalradius = 16;
	self SetGoalPos( self.origin );
	self gun_remove();

	// Don't let the player kill the AI
	self thread magic_bullet_shield();

	thread run_scene_and_delete( "it_mgr_idle" );
}


//
//	Slow down 
spiderbot_slow_mo( vh_spiderbot )
{
	CONST N_SLOW_TIME = 0.15;
	timescale_tween( 1.0, N_SLOW_TIME, 0.1, 0.05 );
	wait( 0.05 );

	timescale_tween( N_SLOW_TIME, 1.0, 0.5, 0.05 );
	
	flag_set( "say_taze_him" );	
	level.ai_gulliver thread gulliver_wait_for_tazer();
}


//
//	wait until you receive damage and then perform electrocution anim
gulliver_wait_for_tazer()
{
	level thread screen_message( &"KARMA_HINT_SPIDERBOT_TAZER", 2 );

	while ( !level.player AttackButtonPressed() )
	{
		wait( 0.05 );
	}
	
	flag_set( "it_mgr_disabled" );
	set_objective( level.OBJ_CRC_GUY, undefined, "done" );
	set_objective( level.OBJ_CRC_GUY, undefined, "delete" );
	screen_message_delete();

	// Wait for eye scan
	self NotSolid();
}


//
//	enact the eye scan
// self is Gulliver
gulliver_eye_scan()
{
//	level.vh_spiderbot ent_flag_set( "playing_scripted_anim" );
	level.player FreezeControls( true );	// don't zap the guy who picks you up
	
	level thread run_scene_and_delete( "eye_scan", 0.5 );
	scene_wait( "eye_scan" );

	// After scan, you get picked up and squashed	
	ai_stomper = simple_spawn_single( "spiderbot_smasher" );
	ai_stomper NotSolid();
	level run_scene_and_delete( "spiderbot_smash" );

	level.player FreezeControls( false );
	ai_stomper Delete();	// kill this guy when we're done
}


//
//	Play sound and fx
play_eye_scan_fx( vh_spiderbot )
{
	flag_set( "scanning_eye" );

 	vh_spiderbot playsound( "evt_spiderbot_retinal_scan" );
	
	// Play scanner effect
	LUINotifyEvent( &"hud_spiderbot_eyescan" );
	vh_spiderbot play_fx( "spiderbot_scanner", vh_spiderbot GetTagOrigin( "tag_flash" ), vh_spiderbot GetTagAngles( "tag_flash" ), "scan_done" );
	level thread play_bink_on_hud( "eye_v5" );
	scene_wait( "eye_scan" );

	vh_spiderbot notify( "scan_done" );
	LUINotifyEvent( &"hud_spiderbot_eyescan_end" );
}
	

////
////	Wait for the player to get near, then enact the eye scan
//// self if Gulliver
//gulliver_wait_for_scan()
//{
//	// Estimate the eye position.
//	v_eye = self GetEye();
//	n_dist = Distance( v_eye, level.vh_spiderbot.origin );
//
//	set_objective( level.OBJ_SCAN_EYE, v_eye );
//
//	while ( n_dist > 12 )
//	{
//		wait( 0.1 );
//
//		n_dist = Distance( v_eye, level.vh_spiderbot.origin );
//	}
//
//	level.vh_spiderbot playsound( "evt_spiderbot_retinal_scan" );
//	
////	// We need to move the align node into position before doing the eye scan.
////	bm_clip Delete();	// Delete the clip so the spider doesn't collide with it
////	
////	s_align = GetStruct( "gulliver_align", "targetname" );
////	s_align.origin = self.origin;
////	s_align.angles = self.angles;
//	
//	// Get the player out of the vehicle for the animation.
//	level.vh_spiderbot ent_flag_set( "playing_scripted_anim" );
//	level thread run_scene_and_delete( "eye_scan", 1.0 );
//
//	wait( 1.0 );
//
//	// Play scanner effect
//	v_tag_origin = level.vh_spiderbot GetTagOrigin( "tag_flash" );
//	sm_tag_origin = Spawn( "script_model", v_tag_origin );
//	sm_tag_origin SetModel( "tag_origin" );
//	sm_tag_origin.angles = level.vh_spiderbot.angles;
//	sm_tag_origin LinkTo( level.vh_spiderbot );
//	level thread play_bink_on_hud( "eye_v5" );
//	PlayFxOnTag( level._effect["spiderbot_scanner"], level.vh_spiderbot, "tag_flash" );
//	scene_wait( "eye_scan" );
//
//	// Delete FX and objective complete	
//	sm_tag_origin Delete();
//	set_objective( level.OBJ_SCAN_EYE, undefined, "done" );
//	set_objective( level.OBJ_SCAN_EYE, undefined, "delete" );
//
//	ai_stomper = simple_spawn_single( "spiderbot_smasher" );
//	ai_stomper NotSolid();
//	level.player FreezeControls( true );	// don't zap the guy who picks you up
//	level run_scene_and_delete( "spiderbot_smash" );
//	level.player FreezeControls( false );
//	ai_stomper Delete();	// kill this guy when we're done
//
//	level.vh_spiderbot ent_flag_clear( "playing_scripted_anim" );
//}


//
//	The terrorist throws spiderbot down and stomps on it.
spiderbot_squashed( ai_callback )
{
	wait( 0.1 );
	
	spiderbot_lost( &"KARMA_FAILED_LOST_SIGNAL", true );

	flag_set( "spiderbot_end" );
}

//
//	The player loses contact with the spiderbot, either due to death 
//	or jamming
spiderbot_lost( str_msg, b_continue_mission )
{
	//level.fade_screen.foreground = false;
	screen_fade_out( 0 );

	if ( IS_TRUE( b_continue_mission ) )
	{
		screen_message_create( str_msg );
		// wait long enough for the message to be read and registered 
		//	in the player's mind
		wait( 2 );
		screen_message_delete();
	}
	else
	{
		missionfailedwrapper( str_msg );
	}
}
	
	
//
//	Cleanup at the end of the event
//
spiderbot_cleanup()
{
	wait( 0.05 );

	// restore DVARS
	level.player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", level.cg_objectiveIndicatorNearFadeDist );
	level.player SetClientDvar( "objectiveIndicatorNoDrawDistance", level.objectiveIndicatorNoDrawDistance );
	level.player SetClientDvar( "vehicle_riding", true );

	cleanup_ents( "cleanup_spiderbot" );
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



/////////////////////////////////////////////////////////////////////
//	D I A L O G
/////////////////////////////////////////////////////////////////////

//
//	Player dialog during the spiderbot
//	self is the player
spiderbot_dialog()
{
	
	setmusicstate ("KARMA_1_SPIDERBOT");
	
    self say_dialog("sect_alright_ziggy_ti_0" );	//Alright, Ziggy... Time to go to work.
    self say_dialog("sect_harper_the_security_0" );	//Harper. The security team has been compromised by PMCs.They're hostile.
    self say_dialog("harp_understood_1" );			//Understood.

    flag_wait( "bomb_found" );		// set by trigger

    self say_dialog("sala_wait_0");					//Wait.
    self say_dialog("sala_what_are_they_doing_0");	//What are they doing?
    self say_dialog("sect_planting_explosives_0");	//Planting explosives.
    self say_dialog("sala_they_going_to_blow_t_0");	//They going to blow the ship?
    self say_dialog("sect_not_before_they_ve_s_0");	//Not before they've secured Karma.
    self say_dialog("sect_harper_sitrep_1");		//Harper.  Sitrep.

// need updated lines    
    self say_dialog("harp_damn_mercs_gave_me_t_0");	//Damn mercs gave me the slip... I think they may be headed your way.
    self say_dialog("sect_dammit_0");				//Dammit.
    self say_dialog("sect_better_get_moving_z_0");	//Better get moving, Ziggy.

    flag_wait( "near_bug_zapper" );

   	if ( !flag( "bug_zapper_disabled" ) )
   	{
	    bug_zapper_dialog();
	    flag_wait( "bug_zapper_disabled" );

	    self say_dialog("sala_okay_0", 1.0);					//Okay.
   	}
}


//
//
bug_zapper_dialog()
{
    level endon( "bug_zapper_disabled" );

	// Bug zapper    
    say_dialog( "sala_should_be_a_control_0" );	//Should be a control box near.
	    
    // Power box
    flag_wait( "near_power_box" );
    
    say_dialog( "sala_taze_it_0" );			//Taze it.
}


//
//	Player dialog in the gulliver area
//	self is the player
gulliver_dialog()
{
	self say_dialog("sect_there_s_our_mark_0", 1.0 );		//There's our mark.

	flag_wait( "say_taze_him" );
	
    self say_dialog("sala_taze_him_section_0"  );			//Taze him, Section!

    flag_wait( "scanning_eye" );

    self say_dialog("sect_scanning_now_0");					//Scanning now.

    scene_wait( "eye_scan" );

	self say_dialog("sala_woah_what_the_fuck_0", 1.0 );			//Woah!  What the fuck?

	ai_smasher = get_ais_from_scene( "spiderbot_smash", "spiderbot_smasher" );
	ai_smasher say_dialog("pmc_what_the_hell_0", 1.0 );		//What the Hell?
  	self say_dialog("sect_it_s_the_pmcs_0");				//It's the PMCs.
}


//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//---------------------------------------------------------------cleaning bots-------------
bots_alive_challenge( str_notify )  // self == player
{
	level endon( "bots_alive_challenge_complete" );
	level endon( "zapped" );
	
	flag_wait( "spiderbot_end" );
	
	self notify( str_notify );
	
	level notify( "bots_alive_challenge_complete" );
}

#include common_scripts\utility;
#include maps\_utility;

//
//	Bregenz OperaHouse A : Photograph members of the Organization
//
//


//
//	Award achievement if player snuck through to stage area.
//
achievement_check()
{
	level waittill( "e3_start" );

	// Achievement - Sneak up to the stage top without alerting anyone
	if ( !level.broke_stealth )
	{
		GiveAchievement( "Challenge_Opera" );
	}
}


//############################################################################
//	EVENT 1 - Head under the stage and avoid environmental hazards and solve puzzles.
//
e1_main()
{
	thread fade_out_black(3);

	level thread achievement_check();
	level thread e1_holster_weapons();
	level.greene = maps\operahouse_util::spawn_guys("ai_e1_greene", true, "vips", "civ" );
	level.haines = maps\operahouse_util::spawn_guys("ai_e1_haines", true, "vips", "civ" );

	if ( level.play_cutscenes )
	{
//BX - SDOMPIERRE : wait a bit longuer to fix the forcedcover not always working properly.
		wait(0.1);	// wait a frame or the forcecover won't work

		level thread e1_camera_tutorial();
		thread letterbox_on( false, false, 1.0, false);
		setSavedDvar( "cg_disableBackButton", "1" ); // disable

		// temporarily freeze controls to get the player in place
		level.player FreezeControls(true);
		level.player playerSetForceCover( true );
		setDvar( "cg_disableHudElements", 1 );	// This is needed.  See Mike A.

		// Camera intro
		level thread e1_tanner_conversation();
//		PlayCutscene("OH_Intro", "opening_scene_done");
		level thread e1_camera_intro();
		level thread display_chyron();
		wait(2.0);	// wait a while before holstering to make sure it's equipped

		player_stick();
		level.player FreezeControls(false);
		level waittill( "opening_scene_done" );
		
		//Bond Intro Stinger - CRussom
		level.player playsound("intro_stinger_opera");

		// Let's play!
		letterbox_off();
		setSavedDvar( "cg_disableBackButton", "0" ); // enable
		setDvar( "cg_disableHudElements", 0 );
		level.player playerSetForceCover( false, false );
		if ( level.ps3 ) //GEBE
		{
			Visionsetnaked( "operahouse_ps3", 0.05 );
		}
		else
		{
			Visionsetnaked( "operahouse", 0.05 );
		}
		wait(0.5);	// need a wait here so the save works properly on all the commands I just fired off

		level thread maps\_autosave::autosave_now( "E1" );	// after intro cutscene
		wait(0.05);	
	}
	else
	{
		level thread e1_camera_tutorial();
	}

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements1", "e1_start_ai", false );
	flag_set( "obj_start" );

	level thread e1_patrol_boat_depart();
	level.greene CmdPlayAnim( "Gen_Civs_StandConversation", false );
	level.haines CmdPlayAnim( "Gen_Civs_StandConversationV2", false );

	trig = GetEnt( "trig_e1_start", "targetname" );
	trig waittill( "trigger" );

	// Move the eye out!
	thread stage_arm_up( 10.0 );
	
	//Steve G - play stage moving sounds
	level thread maps\operahouse_snd::play_stage_move_01();

	trig = GetEnt( "trig_e1_bridge", "targetname" );
	trig waittill( "trigger" );

	// Force guys to be rushers past this point
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e1_start_ai" )
		{
			ents[i] SetCombatRole( "rusher" );
		}
	}

	level thread e1_gate_puzzle();
	level thread e1_stealth_note();
	level thread e1b_main();

	level.light_bottom SetLightIntensity(1.0);

	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::delete_group( "e1_start_ai" );
	maps\operahouse_util::delete_group( "vips" );
}


//
//
e1_stealth_note()
{
	trig = GetEnt( "trig_e1_gates", "targetname" );
	trig waittill( "trigger" );

	wait( RandomFloatRange( 1.0, 3.0 ) );

	line = "";
	if ( level.broke_stealth )
	{
		line = "TANN_OperG_007A";	// Not too loud Bond?  We don't want Greene leaving just yet
	}
	else
	{
		line = "TANN_OperG_006A";	// Move quietly Bond.  You're on to something.  We're still gathering intel.  I'll get back as soon as I can.
	}
	level.player play_dialogue( line, true );
}


//############################################################################
//	EVENT 1 - Split up E1 for ease of testing.
//
e1b_main()
{
	// setup 1st guy
	flag_wait( "obj_reach_understage" );

	static_thug = maps\operahouse_util::spawn_guys("ai_e1_under_arm", true, "e1_ai", "thug" );
	maps\operahouse_util::reinforcement_update("ai_e1_elite_pipes", "e1_ai", false );
	
 	trig = GetEnt( "trig_e1_1st_guy", "targetname" );
 	trig waittill( "trigger" );

	unholster_weapons();
	level thread e1_crane_game();

	// Spawn patrol
	dock_thug = maps\operahouse_util::spawn_guys("ai_e1_dock_patrol", true, "e2_ai", "thug" );
	dock_thug thread e1_patrol();
	level thread maps\_autosave::autosave_now( "E1B" );	// before 1st stealth guy
	wait(0.4);

	level thread maps\operahouse_util::tutorial_block("@PLATFORM_OPERA_TUT_STEALTH", 12.0 );

	//
	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements2", "e2_ai" );

	//
	trig = GetEnt( "trig_e1_midpoint", "targetname" );
	trig waittill( "trigger" );

	level.crane_patroller = maps\operahouse_util::spawn_guys("ai_e1_crane_patrol", true, "e2_ai", "thug" );
	level.crane_patroller thread e1_patroller_alert( "fx_container_splash", "pat_e1_crane_alert" );

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements3", "e2_ai", false );
	level thread e1_dock_reinforcements();

	level thread maps\_autosave::autosave_by_name( "e1dock", 30.0 );	// Back dock

	// On deck, at the back
	wait( 1.0 );
	if ( level.crane_patroller GetAlertState() == "alert_green" )
	{
		level.crane_patroller play_dialogue( "OTM1_OperG_005A", true );	// Tell Mr. Greene backstage is secure.  Over.
	}
	flag_wait( "obj_reach_backstage" );

	maps\operahouse_util::reinforcement_update("", "", false );
	// Force guys to be rushers past this point
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e2_ai" && 
			 ents[i] GetAlertState() == "alert_red" )
		{
			ents[i] SetCombatRole( "rusher" );
		}
	}


// 	//
// 	trig = GetEnt( "trig_e2_rear_pier", "targetname" );
// 	trig waittill( "trigger" );

	level thread maps\_autosave::autosave_by_name( "E2", 30.0 );	// past container drop
	level thread e2_main();
}


//############################################################################
//	Intro shot of Opera
//
e1_camera_intro()
{
	level.player customcamera_checkcollisions( 0 );
	camera_id = level.player customCamera_push(
		"world",							// <required string, see camera types>
		(  2187, -2435, 651 ),				// <optional positional vector offset, default (0,0,0)>	
		(   1,   112,    0 ),				// <optional angle vector offset, default (0,0,0)>
		0.00, 								// <optional time to 'tween/lerp' to the camera, default 0.5>
		0.00,								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
		0.00								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
	);
	wait( 0.5 );

	level.player customCamera_change(
		camera_id,							// <required ID returned from customCameraPush>
		"world",							// <required string, see camera types below>
		(  2240, -2761, 541),				// <optional positional vector offset, default (0,0,0)>	
		(  9.36,   55,    0 ),				// <optional angle vector offset, default (0,0,0)>
		10.00,								// <optional time to 'tween/lerp' to the camera, default 0.5>
		2.00,								// <optional time used to accel/'ease in', default 1/2 lerpTime> 
		2.00								// <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
	);
	wait( 10.0 );

	// Stop Camera
	level.player customCamera_pop( 
		camera_id,	// <required ID returned from customCameraPush>
		5.0,		// <optional time to 'tween/lerp' to the previous camera, default prev camera>
		2.0,	// <optional time used to accel/'ease in', default prev camera> 
		1.0		// <optional time used to decel/'ease out', default prev camera>
	);
	wait( 5.0 );
	level.player customcamera_checkcollisions( 1 );
	level notify( "opening_scene_done" );
}


//############################################################################
//	Keep your weapons away until you need them
//
e1_holster_weapons( thug )
{
	level endon( "e3_start");

	holster_weapons();
	level waittill_any( "reinforcement_spawn", "start_camera_spawner", "alert_red" );

	level.broke_stealth = true;
	unholster_weapons();
}


//############################################################################
//	Conversation that will play after you eliminate the first guard
//
e1_tanner_conversation( )
{
 	wait( 1.0 );	// a bit of pacing

	level.player play_dialogue( "BOND_OperG_001A" );		// 	Bond: Tanner.  Greene's at the Bregenz Opera House.
	wait( 1.0 );

	level.player play_dialogue( "TANN_OperG_002A", true );	//  Tanner: Do you think we're wasting our time?  Perhaps he just likes opera.
	wait( 1.0 );

	level.player play_dialogue( "BOND_OperG_003A" );		// 	Bond: If he does, he chose the wrong night.  They're closed.
	flag_wait( "obj_start" );

	level.player play_dialogue( "TANN_OperG_501A", true );	// Bond, the live feed box for the security cameras is nearby...

	flag_wait( "flag_e1_camera" );

	// Don't interrupt
	while ( level.player.radio_origin IsWaitingOnSound() )
	{
		wait(0.1);
	}
	level.player play_dialogue( "TANN_OperG_702A", true );	// Bond, stay away from the infra-red cameras up ahead.  Don’t let them see you.
	flag_wait( "flag_e1_powerbox" );

	level.player play_dialogue( "TANN_OperG_703A", true );	// You’re near a power box for that camera, Bond.  Hack in and you can bypass it.  Once the light turns green, you’re safe.
}


//############################################################################
//	 Show tutorial messages for cameras 
e1_camera_tutorial()
{
	level endon( "e2_start" );

	// setup e1 security cameras
	e1_cameras = [];
	for ( i=0; i<3; i++ )
	{
		e1_cameras[i]			= GetEnt( "e1_camera"+(i+1), "targetname" );
		if ( IsDefined( e1_cameras[i] ) )
		{
			if ( IsDefined(e1_cameras[i].script_parameters) )
			{
				e1_cameras[i].power_box	= GetEnt( e1_cameras[i].script_parameters, "targetname" );
				e1_cameras[i] thread maps\_securitycamera::camera_start( e1_cameras[i].power_box, true, false, false );
			}
			else
			{
				e1_cameras[i] thread maps\_securitycamera::camera_start( undefined, true, true, false );
			}
		}
	}

	// view cameras
	e1_view_cam = [];
	e1_view_cam[0] = GetEnt( "view_cam_greene", "targetname" );
	e1_view_cam[0] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );

	view_cam	= GetEntArray( "view_cam", "targetname" );
	for ( i=0; i<view_cam.size; i++ )
	{
		e1_view_cam[i+1] = view_cam[i];
		e1_view_cam[i+1] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
	}

	// feedbox init
	feedbox = GetEnt( "e1_feedbox1", "targetname" );
	level thread maps\_securitycamera::camera_tap_start( feedbox, e1_view_cam );
	flag_wait( "obj_start" );

//	maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_FEEDBOX");
	feedbox thread e1_tapped();

	// 
	flag_wait( "flag_e1_camera" );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_CAMERA", 9 );
}


//############################################################################
//	 Show tutorial message after feedbox is accessed
e1_tapped()
{
	level endon( "e2_start" );
	self waittill( "tapped" );
	wait( 1.2 );	// pacing!  Let the lid fall at least

	level.player thread play_dialogue( "TANN_OperG_701A", true );	// Looks like we’ve only got partial access...

// 	while ( true )
// 	{
// 		level.player waittill( "phonemenu", phone_state );
// 		if ( phone_state == 3 )
// 		{

			wait( 1.0 );
			level.greene StopAllCmds();
			level.haines StopAllCmds();
			level.greene thread maps\operahouse_util::goto_spot( "n_greene_spot", 32 );
			wait( 1.1 );
			level.haines thread maps\operahouse_util::goto_spot( "n_guy_spot", 32 );

			level endon( "flag_e1_camera" );

			// Bond sees Greene.  Greene talks for a bit then walks away.
			while ( level.player.radio_origin IsWaitingOnSound() )
			{
				wait(0.05);
			}
			level.player thread play_dialogue( "BOND_OperG_503A", true );	// Bond: I see Greene

//			break;
// 		}
// 		wait( 0.05 );
// 	}
}


//############################################################################
// Gate Puzzle explanation:
//	There are three gates and two switches.  Each switch will move one gate.
//	The object is to open a path through the gates by pressing the right combination of switches
//
//	The switches are numbered from 1 (on the left) and 2 (on the right)
//	The gate closest to the player (#3) never actually moves.  Switch one controls the furthest gate
//	Switch two controls the middle gate.
//
e1_gate_puzzle()
{
	level thread maps\_autosave::autosave_by_name( "e1gates", 5.0);	// Back dock

	// Initialize the gate puzzle entities.
	for ( i=1; i<= 3; i++ )
	{
		level.gate[i] = GetEnt( "lift0"+i, "targetname" );
		// Gate position will be from -1 to 1.  0 = open in the middle, 1 = one shift up, -1 = one shift down
		level.gate[i].state = 0;	// Position offset multiplier
		level.gate[i].start_pos = level.gate[i].origin;

		attachments = GetEntArray( "hydraulic0"+i, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo( level.gate[i] );
		}
	}

	// There are two switches.  Each switch will move one gate
	for ( i=1; i<= 2; i++ )
	{
		level.gate_switch[i] = GetEnt( "sm_e1_gate_switch"+i, "targetname" );
		level.gate_switch[i].index = i+1;
	}

	// Initialize positions (See chart above)
	level.gate[2].state = 1;
	level.gate[3].state = -1;

	trig = GetEnt( "trig_e1_gates", "targetname" );
	trig waittill( "trigger" );

	level thread stage_cover_open( 10.0 );

	//Steve G - play stage moving sound
	level thread maps\operahouse_snd::play_stage_move_02();
	// Move the gates into position
//	e1_move_gate( 1, 0 );
	e1_move_gate( 2, level.gate[2].state );
	e1_move_gate( 3, level.gate[3].state );
	wait( 2.1 );

	// There are two switches.  Each switch will move one gate
	for ( i=1; i<= 2; i++ )
	{
		level.gate_switch[i].light_fx = SpawnFx(level._effect["light_green"], level.gate_switch[i].origin + (0.0, -0.6, 1.2) );
		TriggerFx(level.gate_switch[i].light_fx);
	}

	maps\_playerawareness::setupEntSingleUseOnly( 
		level.gate_switch[1],			//	awareness_entity_name,
		::e1_use_gate_control,			//	use_event_to_call,
		&"OPERAHOUSE_HINT_USE_SWITCH1",	//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		false,						   	//	single_use, 
		true,							//	require_lookat, 
		undefined,		   				//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false );					   	//	awareness_shine, 
	maps\_playerawareness::setupEntSingleUseOnly( 
		level.gate_switch[2],			//	awareness_entity_name,
		::e1_use_gate_control,			//	use_event_to_call,
		&"OPERAHOUSE_HINT_USE_SWITCH3",	//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		false,						   	//	single_use, 
		true,							//	require_lookat, 
		undefined,		   				//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false );					   	//	awareness_shine, 
/*
	maps\_playerawareness::setupEntSingleUseOnly( 
		level.gate_switch[3],			//	awareness_entity_name,
		::e1_use_gate_control,			//	use_event_to_call,
		&"OPERAHOUSE_HINT_USE_SWITCH3",	//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		false,						   	//	single_use, 
		true,							//	require_lookat, 
		undefined,		   				//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false );					   	//	awareness_shine, 
*/

}


//
//
//
e1_spark_hazard()
{
	level endon( "e2_start" );

	trig = GetEnt( "trig_e1_sparks", "targetname" );		// trigger to base damage on
	sparks = GetEntArray( "so_e1_gate_sparks", "targetname" );	// script_origins linked to the gate, so we always know where to spawn the fx
	for ( i=0; i<sparks.size; i++ )
	{
		sparks[i] LinkTo( level.gate[2] );	
	}

	// Now loop the hazard
	while (1)
	{
		e1_the_hurting( trig, sparks, 3 );
		e1_the_hurting( trig, sparks, 3 );
		wait( 2.0 );

		e1_the_hurting( trig, sparks, 1 );
		wait( 0.5 );

		e1_the_hurting( trig, sparks, 2 );
		wait( 1.0 );
	}
}

//
//
//
e1_the_hurting( trig, sparks, num )
{
	player_electrocuted = false;

	// create fx
	for ( i=0; i<sparks.size; i++ )
	{
//		PlayFX( level._effect["spark"], sparks[i].origin );
		switch( num )
		{
		case 1:
			level notify( "fx_wire_bolts1" );
			break;
		case 2:
			level notify( "fx_wire_bolts2" );
			break;
		default:
			level notify( "fx_wire_bolts1" );
			level notify( "fx_wire_bolts2" );
		}
		
		//Steve G spark sounds
		sparks[i] playsound("electric_shock");
	}

	timer = GetTime() + 500;	// milliseconds
	while( GetTime() < timer )
	{
		if ( level.player IsTouching(trig) )
		{
			player_stick();
			player_electrocuted = true;
			level.player DoDamage( 20, trig.origin );
			wait( 0.05 );
		}

		wait (0.05 );
	}

	if ( player_electrocuted )
	{
		player_unstick();
	}
}


//############################################################################
//	Move the puzzle gate
//
e1_use_gate_control( object )
{
	control = object.primaryEntity;

	hint_string = "";	// assign here for higher-level scope

	control.light_fx Delete();
	control.light_fx = undefined;

	// It will either be -1 for left or 1 for right.
	level.gate[ control.index ].state--;
	if ( level.gate[ control.index ].state < -1 )
	{
		level.gate[ control.index ].state = 1;
	}

	// Play a sound like a button press...
	control playsound("cell_phone_pickup");
	switch ( control.index )
	{
	case 2:
		e1_move_gate( 2, control.state );
		hint_string = &"OPERAHOUSE_HINT_USE_SWITCH1";
		break;
	case 3:	
		e1_move_gate( 3, control.state );
		hint_string = &"OPERAHOUSE_HINT_USE_SWITCH3";
		break;
	}

	wait( 2.1 );

	// If in position, lock all entities
	// Need an extra check on the fx in case both gates were moved into position simultaneously
	//	it would initiate this twice
	if ( level.gate[ 2 ].state == 0 &&
		 level.gate[ 3 ].state == 0 && 
		 ( IsDefined(level.gate_switch[1].light_fx) || IsDefined(level.gate_switch[2].light_fx) ) )
	{
		// change the lights to red!  Danger!
		for ( i=1; i<=2; i++ )
		{
			if ( IsDefined( level.gate_switch[i].light_fx ) )
			{
				level.gate_switch[i].light_fx Delete();
			}
			PlayFx( level._effect["light_red"], level.gate_switch[i].origin + (0.0, -0.6, 1.2) );
			level.gate_switch[i] setUseable( false );
		}

		// Start up the sparks on gate #2
		level.gate[2] thread e1_spark_hazard();
	}
	else
	{
		control.light_fx = SpawnFx(level._effect["light_green"], control.origin + (0.0, -0.6, 1.2) );
		TriggerFx(control.light_fx);

		// reinit use
		maps\_playerawareness::setupEntSingleUseOnly( 
			control,	//	awareness_entity_name,
			::e1_use_gate_control,			//	use_event_to_call,
			hint_string,					//	hint_string, 
			0,								//	use_time, 
			"",								//	use_text, 
			false,						   	//	single_use, 
			true,							//	require_lookat, 
			undefined,		   				//	filter_to_call, 
			level.awarenessMaterialNone,	//	awareness_material, 
			true,							//	awareness_glow, 
			false );					   	//	awareness_shine, 
	}
}


//############################################################################
// Gate position will be from -2 to 2.  0 = open in the middle, 2 = two shifts to the right
e1_move_gate( gate_num, direction )
{
	// switch the gate control direction.

	offset = level.gate[ gate_num ].state*(0,0,30);
	level.gate[gate_num] MoveTo( level.gate[gate_num].start_pos + offset, 2 );

	// Steve G - gate sounds
	level.gate[gate_num] playsound("opera_platform_move");
	
	if ( level.gate[ gate_num ].state == -1 )
	{
		level notify( "fx_stage_splash"+gate_num );
		
		// Steve G - splash sound
		level.gate[gate_num] playsound("opera_platform_splash");
	}
}


//############################################################################
//	 Ambient boat moving out
e1_patrol_boat_depart()
{
	start  = GetEnt( "so_e1_boat_path", "targetname" );
	goal_spot = GetEnt( start.target, "targetname" );
	speed = 5;	// default
	while ( IsDefined(goal_spot) )
	{
		old_speed = speed;
		if ( IsDefined( goal_spot.script_float ) )
		{
			speed = goal_spot.script_float;
		}

		// calculate the travel time
		dist = Distance( start.origin, goal_spot.origin );

		// sec = in / (mi/hr *  60s * 60min / 12in * 5280 )
		// sec = in / (63360 in / 3600 s)
		time = dist / (goal_spot.script_float * 17.6);
		level.patrol_boat MoveTo( goal_spot.origin, time );
		level.patrol_boat RotateTo( goal_spot.angles, time );
		
		//Steve G - steady boat sound
		level.patrol_boat playloopsound("power_boat_steady", 10.1);
		
		wait(time);

		if ( IsDefined( goal_spot.target ) )
		{
			goal_spot = GetEnt( goal_spot.target, "targetname" );
		}
		else
		{
			goal_spot = undefined;
		}
	}

	//Steve G - stop steady boat sound
	level.patrol_boat stoploopsound( );
	
	// now wait for the end
	wait_so = GetEnt( "so_e5_boat_wait", "targetname" );
	level.patrol_boat MoveTo( wait_so.origin, 0.05 );
	level.patrol_boat RotateTo( wait_so.angles, 0.05 );
}


//############################################################################
//	 
e1_patrol()
{
	self endon( "alert_yellow" );
	self endon( "alert_red" );
	self endon( "death" );

	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	self thread play_dialogue( "OPM1_OperG_004A" );		// Merc: All clear down below, over.
	self StartPatrolRoute( self.script_noteworthy );
	wait( 1.5 );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_PATROL", 7 );
}


//############################################################################
//
e1_crane_game()
{
	// init

	// crane_hook is now just the line.  Hook is the script_model of the hook
	level.crane_hook	= GetEnt( "crane_hook", "targetname" );
	hook				= GetEnt( "sm_crane_hook", "targetname" );
	if ( IsDefined(hook) )
	{
		hook LinkTo( level.crane_hook );
	}

	// This is separate because I need to connect and disconnect paths with this thing
	level.container_sbm = GetEnt( "sbm_e2_container", "targetname" );
	if ( IsDefined( level.container_sbm ) )
	{
		level.container_sbm LinkTo( level.crane_hook );
	}

	// container is a model, the doors are SBMs
	container			= GetEnt( "sm_e2_container", "targetname" );
	if ( IsDefined( container ) )
	{
		container LinkTo( level.crane_hook );
	}

	container_doors = GetEntArray( "sbm_e2_container_door", "targetname" );
	for ( i=0; i<container_doors.size; i++ )
	{
		container_doors[i] LinkTo( container );
	}

	level.crane_hook MoveZ( 118, 0.05 );
	wait( 0.1 );
	level.container_sbm DisconnectPaths();

	control_origin = GetEnt( "so_e2_crane_control", "targetname" );
	crane_control = Spawn( "script_model", control_origin.origin );
	crane_control SetModel( "tag_origin" );

	crane_control.light_fx = SpawnFx(level._effect["light_green"], crane_control.origin );
	TriggerFx(crane_control.light_fx);
//	playfx ( level._effect["light_green"], crane_control.origin );

	maps\_playerawareness::setupEntSingleUseOnly(
		crane_control,					//	awareness_entity,
		::use_crane,					//	use_event_to_call,
		&"OPERAHOUSE_HINT_CRANE",		//	hint_string, 
		0,								//	use_time, 
		"",								//	use_text, 
		true,						   	//	single_use, 
		false,							//	require_lookat, 
		undefined,		   				//	filter_to_call, 
		level.awarenessMaterialNone,	//	awareness_material, 
		true,							//	awareness_glow, 
		false,						   	//	awareness_shine, 
		false );					   	//	wait_until_finished )
}


use_crane( entObject )
{
	control = entObject.primaryEntity;

	control.light_fx Delete();

	level.container_sbm ConnectPaths();

	level.crane_hook MoveZ( -118, 2.0, 0.0, 1.0 );
	
	// Steve G - container sounds
	level thread maps\operahouse_snd::play_container_lower();
	
	wait( 1.0 );

	level notify("fx_container_splash");
	
//	level.crane_hook MoveZ( -43, 1.0, 0.05, 0.95 );
//	wait( 1.0 );	
}


e1_patroller_alert( alert_notify, redirect_patrol )
{
	self endon( "death" );
	self endon( "alert_red" );

	level waittill( alert_notify );

	self StopAllCmds();
	self SetAlertStateMin( "alert_yellow" );
// 	if ( self IsOnPatrol() )
// 	{
// 		self StopPatrolRoute();
// 	}
	self StartPatrolRoute( redirect_patrol );
}

e1_dock_reinforcements()
{
	level endon( "e2_start" );

 	dock_door = GetEnt( "e1_dock_door", "targetname" );
 	if ( IsDefined( dock_door ) )
	{
		dock_door MoveZ( 1022, 0.05 );
		dock_door DisconnectPaths();

		level waittill( "reinforcement_spawn" );

		// Open the door!
		dock_door ConnectPaths();
		dock_door MoveZ( 110, 2.0 );
	}
}


//############################################################################
//	EVENT 2 - Backstage, sneak past guards 
//
e2_main()
{
	level notify( "e2_start" );
	
//	level notify( "fx_siren_start" );

	level.light_bottom SetLightIntensity(0.0);
	if ( !level.ps3 && !level.bx ) //GEBE
	{
		level.light_ground SetLightIntensity(1.7);
	}

	level.player thread play_dialogue( "TANN_OperG_008A", true );	// Bond.  Is there a vantage point?

	// Spawn patroller
// 	thugs = maps\operahouse_util::spawn_guys("ai_e2_rear2", true, "e2_ai", "thug" );
	maps\operahouse_util::reinforcement_update("ai_e2_reinforcements1", "e2_ai", false );
	thread e2_reinforcements_roof();

	// setup e2 cameras
	e2_cameras = [];
	for ( i=0; i<3; i++ )
	{
		e2_cameras[i]			= GetEnt( "e2_camera"+(i+1), "targetname" );
		if ( IsDefined(e2_cameras[i].script_parameters) )		{
			e2_cameras[i].power_box	= GetEnt( e2_cameras[i].script_parameters, "targetname" );
			e2_cameras[i] thread maps\_securitycamera::camera_start( e2_cameras[i].power_box, true, true, false );
		}
		else
		{
			e2_cameras[i] thread maps\_securitycamera::camera_start( undefined, true, true, false );
		}
	}
	// feedbox init
// 	feedbox = GetEnt( "e2_feedbox", "targetname" );
// 	level thread maps\_securitycamera::camera_tap_start( feedbox, e2_cameras );

// 	maps\_playerawareness::setupSingle(
// 		"container_door",				//	awareness_entity,
// 		::e2_use_container_door,		//	use_event_to_call,
// 		false,							//  allow_aim_assist,
// 		::e2_use_container_door,		//	use_event_to_call,
// 		&"OPERAHOUSE_HINT_CONTAINER",	//	hint_string, 
// 		0,								//	use_time, 
// 		"",								//	use_text, 
// 		true,						   	//	single_use, 
// 		false,							//	require_lookat, 
// 		undefined,		   				//	filter_to_call, 
// 		level.awarenessMaterialNone,	//	awareness_material, 
// 		true,							//	awareness_glow, 
// 		false,						   	//	awareness_shine, 
// 		false );					   	//	wait_until_finished )

	//
	trig = GetEnt( "trig_e2_backstage", "targetname" );
	trig waittill( "trigger" );
	level thread stage_arm_down( 10.0 );
	
	//Steve G - play stage moving sound
	level thread maps\operahouse_snd::play_stage_move_03();

 	maps\operahouse_util::delete_group( "e1_ai" );	// cleanup

	trig = GetEnt( "trig_e2_middle", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("ai_e2_reinforcements2", "e2_ai", false );
	level notify( "e2_stop_roof_spawners" );

	trig = GetEnt( "trig_e2_dressing_room", "targetname" );
	trig waittill( "trigger" );

	level thread maps\_autosave::autosave_by_name( "E2dressing", 10.0 );	// Base of the stage
	wait(0.2);

	thug = maps\operahouse_util::spawn_guys("ai_e2_backstage", false, "e2_ai", "thug" );

	// When near the lift, move the iris out so the lift can move up and the screens can move into position
	trig = GetEnt( "trig_e2_near_front", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("", "", false );
	level thread maps\_autosave::autosave_by_name( "E2base", 30.0 );	// Base of the stage

	level thread e2b_main();
}


//
//	Special case spawning because being in cover can fool the code into thinking you can't see the
//	spawner.  Boo!!
//
e2_reinforcements_roof()
{
	level endon( "e2_stop_roof_spawners" );

	level waittill_any( "reinforcement_spawn", "start_camera_spawner" );

	trig = GetEnt( "trig_e2_prop_room", "targetname" );
	while ( !level.player IsTouching( trig ) )
	{
		wait(0.1);
	}

	elites = maps\operahouse_util::spawn_guys("ai_e2_reinforcements1_roof", false, "e2_ai", "thug" );
	for ( i=0; i<elites.size; i++ )
	{
		elites[i] SetPerfectSense( true );
	}
}


//
//	Split off from E2 just before the stage platforming
//
e2b_main()
{
	// Move the Iris
	level thread stage_iris_flat();
	
	//Steve G - play stage moving sound
	level thread maps\operahouse_snd::play_stage_move_04();
	
	level thread e2_spawn_quantum();

	trig = GetEnt( "trig_e2_onscreen", "targetname" );
	trig waittill( "trigger" );
	
	//pip for ledge
	// JA - BEENOX - Disabled for better minspec performance
	if ( GetDvarInt( "sf_bx_alt_vid_quality" ) == 0 )
	{
		level thread maps\operahouse_util::split_screen();
	}
	
	level thread e2_roof_sniper();

	level.roof_sniper = maps\operahouse_util::spawn_guys("ai_e3_wave1", false, "e3_ai", "thug" );
	level.roof_sniper.targetname = "sniper";

	trig = GetEnt( "trig_e2_off_ledge", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::delete_group( "e2_ai" );
	thug = maps\operahouse_util::spawn_guys("ai_e2_sniper", true, "e3_ai", "thug" );
	thug thread play_dialogue( "OPS1_OperG_009A" );	// Mr. Greene?  This is Morgan on the stage.  Bleachers are clear, stage is clear.  Good evening, sir.
	thug thread maps\operahouse_util::sniper( 10000, "so_e2_stage_sniper_aim", "true" );
	
	thug thread e3_thug_scan();

	level thread maps\_autosave::autosave_by_name( "e2_top", 5.0 );	// Past ledge

	flag_wait( "obj_reach_top" );

	// Move the Iris
	level thread stage_iris_closed();
	level thread e3_main();

	// cleanup
	level waittill( "e3_start" );
 
	maps\operahouse_util::delete_group( "e2_ai" );
}

e3_thug_scan()
{
		self endon("death");
		// ludes
		ent_move = getent("so_e2_stage_sniper_aim", "targetname");
		fake = spawn( "script_origin", (6358, -1228, -88));
		fake1 = spawn( "script_origin", (5601, -1505, -120));
		fake2 = spawn( "script_origin", (5346, -14, 158));
		fake3 = spawn( "script_origin", (4744, -1031, -124));	
		
		while(1)
		{
			ent_move Movex( -2000 , 5.0 ); // (6358 -1228 -88)
			ent_move waittill("movedone");
			ent_move Movex( 2000 , 5.0 ); // (5601 -1505 -120)
			ent_move waittill("movedone");
			ent_move Movex( -2000 , 5.0 ); // (5346 -14 158)
			ent_move waittill("movedone");
			ent_move Movex( 2000 , 5.0 ); // (4744 -1031 -124)
			ent_move waittill("movedone");
		}
}


//############################################################################
//	Intro sniper when on ledge
//
e2_roof_sniper()
{
	PlayCutscene("OH_Sniper", "scene_anim_done");

	level waittill( "scene_anim_done" );

	level.roof_sniper StartPatrolRoute( "pat_e2_roof" );

	level waittill( "e3_start" );

	level.roof_sniper StopPatrolRoute();
	level.roof_sniper thread maps\operahouse_util::goto_spot( "auto97" );
}


//############################################################################
//	Spawn the civs in the skybox
//
e2_spawn_quantum( )
{
	// spawn people in skyboxes
	level.civs		= maps\operahouse_util::spawn_guys("ai_box_seat_civs",	true, "civ_ai", "civ");
	default_animname = "Gen_Civs_StndArmsCrossed";

	// have them loop idle anims
	for ( i=0; i<level.civs.size; i++ )
	{
		level.civs[i] SetEnableSense( false );
		level.civs[i].script_pacifist = 0;		//  don't do that cower bullshit that doesn't work!
		if ( IsDefined( level.civs[i].script_string ) )
		{
			level.civs[i] CmdPlayAnim( level.civs[i].script_string, false );
		}
		else
		{
			level.civs[i] CmdPlayAnim( default_animname, false );
		}
	}

	flag_wait( "obj_reach_top" );

	// F*** hack for stupid savegame BS - restart the anims
	for ( i=0; i<level.civs.size; i++ )
	{
		level.civs[i] StopAllCmds();
		level.civs[i].script_pacifist = 0;		//  don't do that cower bullshit that doesn't work!
		if ( IsDefined( level.civs[i].script_string ) )
		{
			level.civs[i] CmdPlayAnim( level.civs[i].script_string, false );
		}
		else
		{
			level.civs[i] CmdPlayAnim( default_animname, false );
		}
	}


	// targetnames for the cutscene
	level.greene	= maps\operahouse_util::spawn_guys("ai_e3_greene",		true, "scene_ai", "civ");
	level.greene.targetname		= "greene";
	level.greene.team			= "neutral";

	level.haines	= maps\operahouse_util::spawn_guys("ai_e3_haines",		true, "scene_ai", "civ");
	level.haines.targetname		= "haines";
	level.haines.team			= "neutral";

	level.villain1	= maps\operahouse_util::spawn_guys("ai_e3_villain1",	true, "scene_ai", "civ");
	level.villain1.targetname	= "villain1";
	level.villain1.team			= "neutral";


}

//############################################################################
//	open container door
//
e2_use_container_door( object )
{
	door = object.primaryEntity;

	door RotateYaw( -60, 0.6, 0.0, 0.5 );
}


//############################################################################
//	EVENT 3 - Head under the stage and avoid environmental hazards and solve puzzles.
//
e3_main()
{
	level notify( "e3_start" );

	if ( level.play_cutscenes )
	{
		holster_weapons();	// holstering weapons here for consistency so I don't use DisableWeapons
		player_stick( false );
		setSavedDvar( "cg_disableBackButton", "1" ); // disable

		node = GetNode( "n_e3_stairs_top", "targetname" );
		level.sticky_origin MoveTo( node.origin, 0.5 );
		wait( 0.5 );

		node = GetNode( "n_e4_start", "targetname" );
		level.sticky_origin MoveTo( node.origin, 2.0, 1.0, 0.9 );

		// calculate vector to Greene
		vec = VectorNormalize( level.greene.origin - level.player.origin );
		level.sticky_origin RotateTo( VectorToAngles(vec), 2.0, 1.0, 0.9 );
		wait( 2.0 );

		level.player SwitchToWeapon( "sony_phone" );
		wait( 0.7 );
	
	  setdvar("ui_hud_showstanceicon", "0"); 

		// define phone hud
		if (!IsDefined(level.hud_phone))
		{
			level.hud_phone = newHudElem();
			level.hud_phone.x = 0;
			level.hud_phone.y = 0;
			level.hud_phone.horzAlign = "fullscreen";
			level.hud_phone.vertAlign = "fullscreen";
			level.hud_phone SetShader("sp_ig_ob_frame", 640, 480);
		}
 		level.hud_phone.alpha = 1;

		// define static
		if ( !IsDefined(level.hud_static) )
		{
			level.hud_static = [];
			for ( i=0; i<=3;i++ )
			{
				level.hud_static[i] = newHudElem();
				level.hud_static[i].x = -270;
				level.hud_static[i].y = -204;
				level.hud_static[i].horzAlign = "center";
				level.hud_static[i].vertAlign = "middle";
				level.hud_static[i] SetShader("sp_ig_ob_static"+(i+1), 540, 408);
			}
		}
		for ( i=0; i<=3;i++ )
		{
			level.hud_static[i].alpha = 0;
		}

		// display camera overlay
		if (!IsDefined(level.hud_camera))
		{
			level.hud_camera = newHudElem();
			level.hud_camera.x = 0;
			level.hud_camera.y = 0;
			level.hud_camera.horzAlign = "fullscreen";
			level.hud_camera.vertAlign = "fullscreen";
			level.hud_camera SetShader("oh_camera_hud", 640, 480);
		}
 		level.hud_camera.alpha = 1;

		// Define blackout HUD element
		if (!IsDefined(level.hud_black))
		{
			level.hud_black = newHudElem();
			level.hud_black.x = 0;
			level.hud_black.y = 0;
			level.hud_black.horzAlign = "fullscreen";
			level.hud_black.vertAlign = "fullscreen";
			level.hud_black SetShader("black", 640, 480);
		}
		level.hud_black.alpha = 0;

		if ( level.ps3 )
		{
			setdvar("r_znear", "16.0"); 
		}
		PlayCutscene("OH_Skybox", "scene_anim_done");
		level.freeze_frame = 0;
		
		//Steve G - play camera tone
		level.player playloopsound("camera_tone");
		//iprintlnbold("CLICK");
		
		level thread e3_camera_snap();
		level thread e3_camera_static();
		level thread e3_civs_flee();
		VisionSetNaked( "Operahouse_picture", 1.0 );
		wait( 1.5 );
		VisionSetNaked( "operahouse_picture_2", 0.5 );

		level waittill( "scene_anim_done" );
		
		if ( level.ps3 )
		{
			setdvar("r_znear", "2.0"); 
		}
		setdvar("ui_hud_showstanceicon", "1"); 

		level.player playerSetForceCover( true, (-1, 0, 0) );

		//Steve G - stop camera tone
		level.player stoploopsound(0.3);
		
		// kill static
		for ( i=0; i<=3;i++ )
		{
			level.hud_static[i].alpha = 0;
		}

		level.roof_sniper notify( "end_sniper" );
		level.hud_black.alpha = 0;
		level.hud_camera	Destroy();
		level.hud_phone		Destroy();
		VisionSetNaked( "Operahouse_sunset_03", 0.05 );
//		letterbox_off( true );	// NOTE: weapons will be given back in the tutorial section
		player_unstick();
		setSavedDvar( "cg_disableBackButton", "0" ); // disable
		level.player playerSetForceCover( false, false );
		wait(0.1);
		level thread maps\_autosave::autosave_now( "E3B" );		// after Skybox cutscene
		wait(0.1);
	}

	// Setup sniping settings
	setDVar( "cg_laserrange", 4500 );	// default 1500
	setDVar( "cg_laserradius", 0.2 );	// default 0.05
	setSavedDVar( "cg_laser_override_brightness", 0.7 );
	level thread e3_sniper_tutorial();

	flag_set( "obj_kill_snipers" );

	// wait for the first one to die
	wait(1.0);

	level.roof_sniper thread maps\operahouse_util::sniper( "10", undefined, "true" );		// true == allow this guy to interrupt his aim behavior.
	while ( IsAlive( level.roof_sniper ) )
	{
		wait( 0.5 );
	}

	// Start sniper spawns
	thread e3_sniper_talk( );
	e3_sniper_wave( "ai_e3_wave2", 2, 2, 2 );

	level thread e3_machine_gun_support();
	wait(2.0);	// pause between waves
	thread e3_sniper_talk2( );
	
	// jeremyl spawn support here
//	level thread e3_machine_gun_support();
	//e3_sniper_wave( "ai_e3_wave3", 5, 3, 3 );
	e3_sniper_wave( "ai_e3_wave3", 8, 3, 3 );
	
	
	level.kill_sniper_support_now = true;
	flag_set( "obj_snipers_dead" );
	
	
	// grab back guys and kill them here.

	// Ludes this is where the stage falls over.
	level thread e4_main();

	// delete the remaining snipers
	level waittill( "scene_anim_done" );
	maps\operahouse_util::delete_group( "e3_ai" );

}


//
//	Simulate taking pictures
//
e3_camera_snap()
{
	level endon( "scene_anim_done" );

	num_snaps = 0;
	while (1)
	{
		level.villain1 waittillmatch( "anim_notetrack", "freeze_start" );
		
		//Steve G - play camera shot
		level.player playsound("camera_shot");
		//iprintlnbold("CLICK");
		
		level.freeze_frame = 1;
		
		
		for ( i=0; i<level.civs.size; i++ )
		{
			level.civs[i] PauseAIAnim();
		}
		level.hud_camera.alpha = 0;

		level.villain1 waittillmatch( "anim_notetrack", "freeze_end" );
		level.freeze_frame = 0;
		for ( i=0; i<level.civs.size; i++ )
		{
			level.civs[i] ResumeAIAnim();
		}
		// temp black screen to help everyone recover and pretend like movement has continued
		//	behind the freeze
		level.hud_black.alpha = 1;
		wait( 0.3 );
		level.hud_black.alpha = 0;
		level.hud_camera.alpha = 1;

		VisionSetNaked( "Operahouse_picture", 0.2 );
		wait( 0.2 );
		visionsetnaked("operahouse_picture_2", 0.05);


		num_snaps++;
		if ( num_snaps == 5 )
		{
			level notify( "e3_bond_speaks" );
		}
	}
}

//
//	Add some distortion grain to the image
//
e3_camera_static()
{
	level endon( "scene_anim_done" );
	
	prev_static = 0;
	new_static = 0;
	while (1)
	{
		new_static = new_static + 1;
		if ( new_static >= level.hud_static.size )
		{
			new_static = 0;
		}

		level.hud_static[ new_static ].alpha = 0.30;
		level.hud_static[ prev_static ].alpha = 0.0;
		prev_static = new_static;

		// Pause the static with the frozen picture
		while ( level.freeze_frame == 1 )
		{
			level.hud_static[ new_static ].alpha = 0.15;
			wait(0.05);
		}

		wait(0.05);
	}
}

//
//	Head for the exit when the scene ends
e3_civs_flee( exit_node )
{
//	level waittill( "e3_bond_speaks" );

	// Members freak out and leave
	level waittill( "scene_anim_done" );

	exit_node = GetNode( "n_civ_exit", "targetname" );
	exit_node2 = GetNode( "n_civ_exit2", "targetname" );
	for ( i=0; i<level.civs.size; i++ )
	{
//	level.civs[i] setscriptspeed( "walk" );
		level.civs[i] thread e3_civ_flee( exit_node );
	}
	level.villain1	thread e3_civ_flee( exit_node2 );
	wait(1.0);
	level.haines	thread e3_civ_flee( exit_node2 );
	wait(2.0);
	level.greene	thread e3_civ_flee( exit_node2 );

	level.player thread play_dialogue( "GREE_OperG_021A" );	// "Damn, find him!"
}

e3_civ_flee( exit_node )
{
	self LockAlertState( "alert_yellow" );
	self SetEnableSense( false );
	self StopAllCmds();
	wait( RandomFloatRange( 0.0, 2.0 ) );

	maps\operahouse_util::goto_node( exit_node );
	self delete();
}


//
//	Pop up tutorial for sniper rifle
e3_sniper_tutorial()
{
	level.player LaserOff();
	unholster_weapons();

	// don't let them have too many weapons
	if ( level.player HasWeapon( "SAF45_Opera" ) && level.player HasWeapon( "Mk3LLD_Opera" ) )
	{
		level.player TakeWeapon( "Mk3LLD_Opera" );
		level.player GiveMaxAmmo("SAF45_Opera");
	}

	level.player GiveWeapon( "VTAK31_Opera" );
	level.player SwitchToWeapon( "VTAK31_Opera" );
//	level thread maps\operahouse_util::tutorial_block("@PLATFORM_OPERA_TUT_SNIPER", 10 );
	wait( 10.0 );

	if ( IsAlive( level.roof_sniper ) )
	{
		// this will cancel out the forced search behavior on the sniper
		level.roof_sniper SetAlertStateMin( "alert_yellow" );
	}
}


//
//	Spawners
//	spawnername = name of spawners in group
//	spawn_max = how many ai we will spawn total
//	alive_max = how many ais can be alive at any one time
//	kill_max = how many you need to kill to exit
e3_sniper_wave( spawnername, spawn_max, alive_max, kill_max )
{

	if ( !IsDefined(spawn_max) )
	{
		spawn_max = 10;
	}
	if ( !IsDefined(alive_max) )
	{
		alive_max = 4;
	}
	if ( !IsDefined(kill_max) )
	{
		kill_max = spawn_max;
	}

	spawners = GetEntArray( spawnername, "targetname" );
	spawners = maps\operahouse_util::randomize_array( spawners );
	// Give them unique targetnames
	for ( i=0; i<spawners.size; i++ )
	{
		spawners[i].targetname = spawnername + "_" + i;
	}
	if ( spawn_max > spawners.size )
	{
		spawn_max = spawners.size;
	}

	// Initialize the count controller
	ent = spawnstruct();
	ent count_init();

	// Start spawning
	snipers = [];
	while ( ent.count_ai_spawned < spawn_max )
	{
		while ( ent.count_ai_alive < alive_max )
		{
			wait( RandomInt(3) );
			guy = maps\operahouse_util::spawn_guys( spawners[ent.count_ai_spawned].targetname, true, "e3_ai", "thug_yellow" );
			if ( IsDefined(guy) )
			{
				guy thread count_monitor( ent );
			}
			wait( 0.1 );
		}
		if ( ent.count_ai_killed >= kill_max )
		{
			return;
		}
		wait( 0.5 );
	}

	// Okay all have spawned, now wait for them to die
	while ( ent.count_ai_alive > 0 )
	{
		if ( ent.count_ai_killed >= kill_max )
		{
			return;
		}
		wait( 0.5 );
	}
	
	// need to find out when last wave is called in then spawn these guys.
}

// jeremyl 
// ludes
e3_machine_gun_support()
{
	// if happened once don't call in guys again.

	node1 = getnode ("e3_sniper_support_roof","targetname"); // roofs
	node2 = getnode ("e3_sniper_support_right","targetname"); // middle left
	node3 = getnode ("e3_sniper_support","targetname"); // far left
	
	// setp one function with same names and make this cleaner.

	//  people didn't like total amount of guys so even though there is an array I just delete one of the guys out of there.

 // them in an array won't work, cause they won't know what level they are on.
 // I need three seperate names
	
	/*
	ai_e3_wave3_machinegun_lef1
	ai_e3_wave3_machinegun_roof1
	ai_e3_wave3_machinegun_right1
	
	ai_e3_wave3_machinegun_lef2
	ai_e3_wave3_machinegun_roof2
	ai_e3_wave3_machinegun_right2	
*/

		snipe1_auto_guns = getent ("ai_e3_wave3_machinegun_left1","targetname");
		snipe1_auto_gunsa = snipe1_auto_guns stalingradSpawn();
		snipe1_auto_gunsa waittill ("finished spawning");
		snipe1_auto_gunsa thread e3_machine_gun_support_basics();
		snipe1_auto_gunsa setgoalnode( node3 );
		snipe1_auto_gunsa waittill("goal");
		snipe1_auto_gunsa thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		

		snipe1_auto_guns2 = getent ("ai_e3_wave3_machinegun_roof1","targetname");
		snipe1_auto_guns2a = snipe1_auto_guns2 stalingradSpawn();
		snipe1_auto_guns2a waittill ("finished spawning");
		snipe1_auto_guns2a thread e3_machine_gun_support_basics();
		snipe1_auto_guns2a setgoalnode( node1 ); // roof
		snipe1_auto_guns2a waittill("goal");
		snipe1_auto_guns2a thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		

		snipe1_auto_guns3 = getent ("ai_e3_wave3_machinegun_right1","targetname");
		snipe1_auto_guns3a = snipe1_auto_guns3 stalingradSpawn();
		snipe1_auto_guns3a waittill ("finished spawning");
		snipe1_auto_guns3a thread e3_machine_gun_support_basics();
		snipe1_auto_guns3a setgoalnode( node2 );
		snipe1_auto_guns3a waittill("goal");
		snipe1_auto_guns3a thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);

	level waittill( "e4_start" );

		snipe1_auto_guns = getent ("ai_e3_wave3_machinegun_left2","targetname");
		snipe1_auto_gunsa = snipe1_auto_guns stalingradSpawn();
		snipe1_auto_gunsa waittill ("finished spawning");
		snipe1_auto_gunsa thread e3_machine_gun_support_basics();
		snipe1_auto_gunsa setgoalnode( node3 );
		

		snipe1_auto_guns2 = getent ("ai_e3_wave3_machinegun_roof2","targetname");
		snipe1_auto_guns2a = snipe1_auto_guns2 stalingradSpawn();
		snipe1_auto_guns2a waittill ("finished spawning");
		snipe1_auto_guns2a thread e3_machine_gun_support_basics();
		snipe1_auto_guns2a setgoalnode( node1 ); // roof
		

		snipe1_auto_guns3 = getent ("ai_e3_wave3_machinegun_right2","targetname");
		snipe1_auto_guns3a = snipe1_auto_guns3 stalingradSpawn();
		snipe1_auto_guns3a waittill ("finished spawning");
		snipe1_auto_guns3a thread e3_machine_gun_support_basics();
		snipe1_auto_guns3a setgoalnode( node2);
		
		
		wait(3);
//		snipe1_auto_guns3a waittill("goal");
		snipe1_auto_guns3a thread e3_machine_gun_support_random_fire2(0.01,  3,5,  1,1);
		
//		snipe1_auto_guns2a waittill("goal");
		snipe1_auto_guns2a thread e3_machine_gun_support_random_fire2(0.01,  3,5,  1,1);
		
//		snipe1_auto_gunsa waittill("goal");
		snipe1_auto_gunsa thread e3_machine_gun_support_random_fire2(0.01,  3,5,  1,1);
	

/*
		// spawn in like 5 guys that attack the player with zero accuracy.
	snipe1_auto_guns = getentarray ("ai_e3_wave3_machinegun_roof","targetname"); // guys on roof
	snipe1_auto_gunsa = [];
	for (i=0; i<snipe1_auto_guns.size; i++)
	{
		snipe1_auto_gunsa[i] = snipe1_auto_guns[i] stalingradSpawn();
		snipe1_auto_gunsa[i] waittill ("finished spawning");
		
		if(isalive(snipe1_auto_gunsa[0]) )
		{
			snipe1_auto_gunsa[0] delete();
			// snipe1_auto_gunsa[0] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
		
		snipe1_auto_gunsa[i] setgoalnode( node1 );
		snipe1_auto_gunsa[i].goalradius = 100;
		snipe1_auto_gunsa[i].maxvisibledist = 22000;
		snipe1_auto_gunsa[i] setscriptspeed("sprint");
		snipe1_auto_gunsa[i] setalertstatemin( "alert_red" );
		snipe1_auto_gunsa[i] lockalertstate( "alert_red" );
		snipe1_auto_gunsa[i] setperfectsense( true );
		
		snipe1_auto_gunsa[i] waittill("goal");
		
		if(isalive(snipe1_auto_gunsa[1]) )
		{
			 snipe1_auto_gunsa[1] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
	}
		
		
	snipe1_auto_guns2 = getentarray ("ai_e3_wave3_machinegun_area2","targetname"); // guys top middle left
	snipe1_auto_guns2a = [];
	for (i=0; i<snipe1_auto_guns.size; i++)
	{
		snipe1_auto_guns2a[i] = snipe1_auto_guns2[i] stalingradSpawn();
		snipe1_auto_guns2a[i] waittill ("finished spawning");
		snipe1_auto_guns2a[i] setgoalnode( node2 );
		snipe1_auto_guns2a[i].goalradius = 100;
		snipe1_auto_guns2a[i] setscriptspeed("sprint");
		snipe1_auto_guns2a[i] setalertstatemin( "alert_red" );
		snipe1_auto_guns2a[i] lockalertstate( "alert_red" );
		snipe1_auto_guns2a[i] setperfectsense( true );
		
		if(isalive(snipe1_auto_guns2a[0]) )
		{
				snipe1_auto_guns2a[0] delete();
			// snipe1_auto_guns2a[1] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
		
		snipe1_auto_guns2a[i] waittill("goal");
		//snipe1_auto_guns2a[i] SetCombatRole( "turret" );
		//snipe1_auto_guns2a[i] cmdshootatentity( level.player, true, -1, 0.8, true );
		
		if(isalive(snipe1_auto_guns2a[1]) )
		{
			 snipe1_auto_guns2a[1] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
	}
		
	snipe1_auto_guns3 = getentarray ("ai_e3_wave3_machinegun","targetname"); // guys far left
	snipe1_auto_guns3a = [];
	for (i=0; i<snipe1_auto_guns.size; i++)
	{
		snipe1_auto_guns3a[i] = snipe1_auto_guns3[i] stalingradSpawn();
		snipe1_auto_guns3a[i] waittill ("finished spawning");
		snipe1_auto_guns3a[i] setgoalnode( node3 );
		snipe1_auto_guns3a[i].goalradius = 100;
		snipe1_auto_guns3a[i] setscriptspeed("sprint");
		snipe1_auto_guns3a[i] setalertstatemin( "alert_red" );
		snipe1_auto_guns3a[i] lockalertstate( "alert_red" );
		snipe1_auto_guns3a[i] setperfectsense( true );
		
		if(isalive(snipe1_auto_guns3a[0]) )
		{
				snipe1_auto_guns3a[0] delete();
			// snipe1_auto_guns2a[0] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
		
		snipe1_auto_guns3a[i] waittill("goal");
		
		//snipe1_auto_guns3a[i] thread e3_machine_gun_support_random_fire( 0.01,  3,5,  3,5 );

		if(isalive(snipe1_auto_guns3a[1]) )
		{
			 snipe1_auto_guns3a[1] thread e3_machine_gun_support_random_fire(0.01,  3,5,  3,5);
		}
	}
	
	*/
	// need to grab these guys as the stage falls
		
		
	// when player kills last guys of sniper spawn alot of guys to just shoot at the player.
	
	// waitill last sniper guys shot	
	
	//level waittill( "e4_start" );
	//spawn e
}

e3_machine_gun_support_basics()
{
		self.goalradius = 200;
		self setscriptspeed("sprint");
		self setalertstatemin( "alert_red" );
		self lockalertstate( "alert_red" );
		self setperfectsense( true );
}

// loop shooting at the player because of distance making a fake shooting mechanic for these ai.
e3_machine_gun_support_random_fire( accuracy, shootMin, shootMax, waitMin, waitMax )
{
		self endon ("death");	
		// bursts of 3
		
		self allowedstances( "crouch" );
		//print3d (dude.origin + (0,0,0), "" + (sqrt(lengthsquared(delta))/12),	(1,0,0), 1, 1);	// origin, text, RGB, alpha, scale	
		//print3d (dude.origin + (0,0,20), "" + dude.PerceptHudNumBar,			(1,0,0), 1, 2);	// origin, text, RGB, alpha, scale				
				
		while(1)
		{
				random_time = randomintrange(2,4);
				wait(random_time);
				self SetEnableSense( false );				
				self StopAllCmds();
				//  false is used with cover.
				self CmdShootAtEntity( level.player, false, randomfloatrange(shootMin, shootMax), accuracy, false );
				self waittill("all_cmds_done");
				wait(randomfloatrange(waitMin, waitMax));
				
				
				////level notify("kill_sniper_support_now");
				if( level.kill_sniper_support_now == true )
				{
						wait(3.6);
						self delete(); // maybe call some sounds of them running away.
				}
		}
		
		// magic bullets shooting at you when the stage falls
		// 
		// make one guy
}

e3_machine_gun_support_random_fire2( accuracy, shootMin, shootMax, waitMin, waitMax )
{
		self endon ("death");	
		// bursts of 3
			self SetEnableSense( false );				
			self StopAllCmds();
			self CmdShootAtEntity( level.player, false, randomfloatrange(shootMin, shootMax), accuracy, false );
			self waittill("all_cmds_done");
			wait(3.6);
			self delete(); // maybe call some sounds of them running away.

}



count_init()
{
	self.count_ai_spawned	= 0;	// how many AI have been spawned?
	self.count_ai_alive		= 0;	// how many AI are alive?
	self.count_ai_killed	= 0;
}


count_monitor( controller )
{
	controller.count_ai_spawned++;
	controller.count_ai_alive++;
	self waittill( "death" );

	controller.count_ai_alive--;
	controller.count_ai_killed++;
}

//
//	Snipers
e3_sniper_talk( )
{
	wait( 2.0 );

	switch ( RandomInt(3) )
	{
	case 0:
		line = "SBS1_OperG_022A";	// He's across the water!
		break;
	case 1:
		line = "SBS2_OperG_026A";	// I see him!
		break;
	default:
		line = "SBS2_OperG_023A";	// Above the stage!
	}
	level.player play_dialogue( line, true );	// He's across the water!
}


//
//	Snipers
e3_sniper_talk2( )
{
	wait( 3.0 );

	line = "";
	switch ( RandomInt(3) )
	{
	case 0:
		line = "SBV2_OperG_028A";	// We've got him trapped up there!  Don't let him down.
		break;
	case 1:
		line = "SBS1_OperG_029A";	// I've got him on scope.  He's alone.
		break;
// 	case 2:
// 		line = "SBS1_OperG_027A";	// Kill on sight!  Greene's orders.
// 		break;
	default:
 		line = "SBS2_OperG_030A";	// He's moving!
		break;
	}

	level.player play_dialogue( line, true );
}


//############################################################################
//	EVENT 4 - Exit stage right!
// 	level thread slow_time(.25, 2.5, 0.5);
e4_main()
{
	level notify( "e4_start" );
	
	level.kill_random_shoot = false;
	level thread event_3_to_2_magic_bullet();
	
	if ( !level.ps3 && !level.bx )//GEBE
	{
		level.light_ground SetLightIntensity(0.0);
	}
	level.light_top    SetLightIntensity(1.0);
	
	black_screen_time = 1.0;
	
		//black screen
	level.hudBlack = newHudElem();
	level.hudBlack.x = 0;
	level.hudBlack.y = 0;
	level.hudBlack.horzAlign = "fullscreen";
	level.hudBlack.vertAlign = "fullscreen";
//	level.hudBlack.sort = 0;
	level.hudBlack.alpha = 0;
	level.hudBlack setShader("black", 640, 480);
	
	wait black_screen_time;

	// Get rid of the civilians if they haven't already been deleted
	maps\operahouse_util::delete_group( "civ_ai" );
	maps\operahouse_util::delete_group( "scene_ai" );

	// These little buggers get in the way of shooting, so we need to delete them.
	sbms = GetEntArray( "stage_ledge", "targetname" );
	for (i=0; i<sbms.size; i++ )
	{
		sbms[i] trigger_off();
	}

	level.player play_dialogue( "SBS2_OperG_031A", true );	// "Drop the stage!  Bring him down!"

	//Steve G - stop the pa music
	level thread maps\operahouse_snd::stop_wagner();

	earthquake( 0.3, 4.5, level.player.origin, 200 );

	curr_weapon = level.player getcurrentweapon();
	level.player SwitchToWeapon( "P99" );	// need to change weapon before forcing out of cover to remove the scope
	level.player givemaxammo("P99");	// Make sure they have enough to fight with

	wait(0.5);	// wait a bit for the weapon change

	forcephoneactive( false );
	level.player playerSetForceCover( false );	// force player off cover if in cover
	level.player setdemigod(true);
	wait(0.05);	// wait a frame for the force cover off to take effect

	setSavedDvar( "cg_disableBackButton", "1" ); // disable
	letterbox_on( true, true, 1.0, true );	
	wait(0.1);

	//Steve G - play the collaping sounds
	level.player playsound("stage_collapse_front");
	
	wait(3.0);

	//	KLUDGE ALERT!!  
	// Link the ammo_crate to the stage...
	//	Then use it as the source of the physics pulse.
	//	And delete it once the anim is done so it doesn't look weird.
	ammo_crate = GetEnt( "ammo_crate", "targetname" );
	ammo_crate Delete();
	level.player playsound("bond_xrt_grunt");
	player_unstick();	// need to unstick before playing a cutscene
	PlayCutscene("OH_StageFall", "scene_anim_done");
	//level thread stage_lude_spark();
	level thread stage_collapse( 0.05 );

	so = GetEnt( "so_e3_roof_sniper_aim", "targetname" );
	so LinkTo( level.stage.eye );
	level thread physics_pulse( so );

	// Stage 1st drop
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.kill_random_shoot = true;
	earthquake( 1.5, 1.0, level.player.origin, 100 );
	
	wait( 1.3 );
	// level thread maps\operahouse_util::slow_time( .20, 1.5, 0.5 );
	level thread maps\operahouse_util::slow_time( .20, 1.5, 0.5 );
	//level thread maps\operahouse_util::slow_time( .20, 1.7, 0.5 );
	//level thread slow_time(.25, 1.3, 0.5);
	// need bond breathing.
//	wait(0.6);
//	level.player playsound("bond_xrt_grunt");

	// Stage 2nd stop
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level notify ("stop_fake_gunners");
	wait(1.0);
	earthquake( 2.0, 0.5, level.player.origin, 100 );
	setblur( 5.0, 0.05 );
	
	level thread e3_fade_control();
	
	// calling effects on his head
	// ludes
	PlayFX( level._effect["spark"], level.player.origin + (0,0,0));
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,40,0));
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,-40,0));

	// Stage falls onto frame
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	earthquake( 0.75, 1.0, level.player.origin, 100 );

	//Steve G - restart pa music
	level thread maps\operahouse_snd::start_mozart_02();

//	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "end" );
	level waittill( "scene_anim_done" );

	// Immediately take over so the player can't do anything to get into trouble
	player_stick(true);
	// Need to take over from the cutscene or we'll get stuck.
	fall_spot = GetEnt( "so_e3_fall_spot", "targetname" );
	level.sticky_origin.origin = fall_spot.origin;
	level.sticky_origin.angles = fall_spot.angles;
	wait(0.05);
	level.sticky_origin LinkTo( level.stage.arm );
	level.player AllowStand(false);
	wait(4.3);

	setblur( 0.0, 5.0 );
//	level.player DoDamage( 1000, level.player.origin );

	wait(.05);

	level.player setdemigod(false);
	level.player AllowStand(true);

	// Okay you can go now.  Move along
	thread letterbox_off( true, 0.05 );	// turn letterbox off here so that you can see yourself take damage when you land
	wait(0.1);

	if ( IsDefined( curr_weapon ) )
	{
		level.player SwitchToWeapon( curr_weapon );
	}


	setSavedDvar( "cg_disableBackButton", "0" ); // disable

//	level waittill( "stage_collapsed" );
	level thread maps\_autosave::autosave_now( "E4" );		// after stage collapse
	wait(0.5);
	thugs = maps\operahouse_util::spawn_guys( "ai_e4_roof_wave", true, "e4_ai", "thug_red" );

	flag_set( "obj_leave_docks" );

	// Start sniper spawns
	flag_wait( "obj_stage_iris" );

//	thug = maps\operahouse_util::spawn_guys( "ai_e5_backstage_tower", true, "e4_ai", "thug_red" );
	level thread e4_stage_dialog();

	trig = GetEnt( "trig_balance_beam", "targetname" );
	trig waittill( "trigger" );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_BALANCE", 8 );
	level.player thread play_dialogue( "TANN_OperG_035A", true );	// Tanner: Bond, our satellite is showing incoming hostiles from the lake.  Keep your eyes open.


	level thread e5_main();
}

event_3_to_2_magic_bullet()
{
	bullet_org = spawn( "script_origin", (2297, -569, 215));
	//bullet_org = GetEnt("e3_sniper_support","targetname");
	//bullet_end = GetEnt("magic_bullet_end3","targetname");
	//magicbullet("SAF45_opera", bullet_org.origin, bullet_end.origin);
	//level.player playsound ("whizby");
	//wait(.2);
	
	//level waittill ("stop_fake_gunners");
	
	
	while(1)
	{
		magicbullet("SAF45_Opera", bullet_org.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
		level.player playsound ("whizby");
		wait(.1);
		magicbullet("SAF45_Opera", bullet_org.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
		level.player playsound ("whizby");
		wait(.1);
		magicbullet("SAF45_Opera", bullet_org.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
		level.player playsound ("whizby");
		
		// waittill stage done
		if(level.kill_random_shoot == true)
		{
			break;
		}
	}
}

// jeremyl control this here so it does not mess with timing.
e3_fade_control()
{
	// need to call sparks as this thig is falling.
	// steve g need to place heavy breathing in here.
	wait(0.5);
	
	// Fall to ground black out
	fade_out(0.5);
	setblur( 2.0, 0.05 );
	wait 1.9;
	setblur( 0.0, 5.0 );
	fade_in(1);	
	
	// Fade in in time to see stage fall again then black out
	wait(1.1);
	PlayFX( level._effect["spark"], level.player.origin + (0,0,100));
	wait(0.5);
	fade_out(0.5);
//	wait(0.5)
	// player hits the ground
	
//	PlayFX( level._effect["spark"], level.player.origin + (0,0,100));
//		PlayFX( level._effect["spark"], level.player.origin + (0,0,100));
//	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,40,100));
//	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,-40,100));
	
	wait (0.8);
	// Steve G - Fixed faked vo
	// player looks up
	//level.player thread play_dialogue( "SAM_E_1_McLS_Cmb", true );
	wait (2.8);
	fade_in(6);
	//level.player thread playdialogue("stage_bc_01", true);
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + ( 0, 0,100));
	wait( 2.5 );
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,0,100));
	fade_out(0.5);
	wait (0.8);
	level.player play_dialogue ("stage_bc_01", true );
	wait (0.8);
	fade_in(6);
	wait (1.1);
	bc_org = spawn( "script_origin", (5159, -95, 278));
	//level.player play_dialogue( "SAM_E_1_McLS_Cmb", true );
	wait(0.8);
	bc_org playsound("stage_bc_02");
	wait (1);
	//level.player play_dialogue ("SAM_E_4_McGS_Cmb", true );
	bc_org playsound("stage_bc_03");
	wait(1.2);
	//level.player play_dialogue ("SAM_E_3_McGS_Cmb", true );
	bc_org playsound("stage_bc_04");
	wait(1);
	//level.player play_dialogue ("SAM_E_4_McGS_Cmb", true );
	
}

// jeremy l
// fade out and in
fade_out(t)
{
	level.hudBlack fadeOverTime(t);		// fade out
	level.hudBlack.alpha = 1;
}

fade_in(t)
{
	level.hudBlack fadeOverTime(t);		// fade in
	level.hudBlack.alpha = 0;
}


//	Play some dialog
e4_stage_dialog()
{
	line = "";
	switch ( RandomInt(2) )
	{
	case 0:
		line = "OSM1_OperG_032A";	// He's on the stage!
		break;
	default:
		line = "OSM2_OperG_033A";	// Keep him there!
	}
	//level.player play_dialogue( line, true );
	//Steve G - Fixed faked vo
	bc_org_2 = spawn( "script_origin", (5159, -95, 278));
	bc_org_2 playsound(line);
	wait( 1.0 );

	//level.player play_dialogue( "BSM1_OperG_034A", true );	// Close that gate!
}


//
//	NOTE: Not needed any more for physics objects, but we need it to shove the dead body off...
//	
physics_pulse( source )
{
	level endon("scene_anim_done" );

	if ( !IsDefined( source ) )
	{
		source = level.player;
	}

	while (1)
	{
		// physics
		physicsJolt( source.origin, 640, 1, (0.3, 0.0, 0.1) );
		wait(1.0);
	}
}

//############################################################################
//	EVENT 5 - Patrol boat intercedes
//
e5_main() // this is the event I need to change up.
{
	level notify( "e5_start" );

	// will need to set this up earlier in level.
	boat_lookat = getent("spawn_boat","targetname");	
	boat_lookat trigger_off();
	
//	maps\_vsedan::main( "v_sedan_silver_radiant" );
//	maps\_vsedan::main( "v_sedan_blue_radiant" );
	

	gate = GetEnt( "sbm_e5_backstage_gate", "targetname" );
	gate MoveX( 184, 2 );

	// Backstage
	flag_wait( "obj_backstage_roof" );
	
	level thread e5_ladder_control();
	level thread kill_player_if_drop();


	level thread maps\_autosave::autosave_by_name( "e5", 25.0 );	// after balance beam
	
	// jeremyl
	// escape sequence.
	level thread jump_text();
	level thread fake_vo();
	wait(0.1);
	thugs = maps\operahouse_util::spawn_guys( "ai_e5_far_pier", true, "e5_ai", "thug_red" );
	array_thread( thugs, ::run_or_diw );

	// On the pier
	trig = GetEnt( "trig_e5_boat", "targetname" );
	trig waittill( "trigger" );
	
// jeremyl made it so these guys spawn right away.	
//	trig = GetEnt( "trig_e5_pier", "targetname" );
//	trig waittill( "trigger" );
 
	thugs = maps\operahouse_util::spawn_guys( "ai_e5_pier", true, "e5_ai", "thug_red" );
	thugs2 = maps\operahouse_util::spawn_guys( "ai_e5_towers", true, "e5_ai", "thug_red" );
	array_thread( thugs2, ::run_or_diw );
	array_thread( thugs, maps\operahouse_util::tether_on_goal, 128 );
	level thread ai_accuracy_e5();
	
	level thread e5_cars_escaping_pullup(); // start cars pulling up.
	wait( 9.3 );
	boat_lookat trigger_on();
	wait( 0.1 );
	GetEnt("spawn_boat", "targetname") waittill("trigger");
	level.patrol_boat thread e5_boat_intro();
	
	//Steve G - Boat sounds
	//iprintlnbold("SHIP AHOY");
	thread maps\operahouse_snd::play_boat_crash();

	// Player reaches the Opera House!
	flag_wait("obj_escaped");

	level notify( "time_limit_stop" );

// jeremyl took out camera inside of building with explosions
//	level.player customcamera_checkcollisions( 0 );
//	camera = level.player customCamera_Push( "world", ( 4381, 2951, 105), (5.86, -94.55, 0.0) , 0.05);

//	wait( 1.0 );

	so = GetEnt( "big_bang", "targetname" );
	fx = playfx (level._effect["bigbang"], so.origin);
	level.player EnableInvulnerability();
	radiusdamage( so.origin+(0,0,500), 500, 500, 500 );
	physicsExplosionSphere( so.origin, 500, 400, 8 );
	earthquake( 1.0, 1, so.origin, 2000 );

//	wait( 2.0 );
//	level thread fade_out_black( 4 );
//	level.player thread play_dialogue( "TANN_OperG_043A", true  );	//Tanner: Run for it, Bond!  That boat could explode at any moment!
//  play good job bond here.
	wait( 3 );
	maps\_endmission::nextmission();
}

e5_ladder_control()
{
	ladder1 = getent ("e5_ladder1","targetname");
	ladder2 = getent ("e5_ladder2","targetname");
	
	ladder1 trigger_off();
	ladder2 trigger_off();
	
	level waittill("kill_e5_snipers");
	
	//Steve G - start pier music
	level thread maps\operahouse_snd::start_dvorak();
	
	ladder1 trigger_on();
	ladder2 trigger_on();
}

// jeremyl fake vo of guys running into position
fake_vo()
{
				// this doesn't sound that good.
				// Steve G - That's an understatement - fixed faked vo
				fake = spawn( "script_origin", (5529, 886, 12));
				wait(2.5);
				fake playsound ("dock_bc_01" );
				wait(1.5);
				fake playsound ("dock_bc_02" );
				wait(1.3);
				fake playsound ("dock_bc_03" );
				//wait(1.4);
				//fake playsound ("SAM_E_1_McLS_Cmb" );
				//wait(1.4);
				//fake playsound ("SAM_E_1_McGS_Cmb" );
				//wait(1.1);
				//fake playsound ("SAM_E_3_PinD_Cmb" );
				//wait(2.3);
				//fake playsound ("SAM_E_1_FrRs_Cmb" );
				wait(2);
				fake delete();
	
}


//############################################################################
//	EVENT 5 - bloack player so he has to sniper people as he running away.
//
e5_explosion_allow_player_down()
{
	// setup script brush model so the player cannot run
	// Set off all remaining explosions for earthquak shake part
	// this blocks the path to the right.
	// can you make some thing rotate and fall over that looks good with enough foreshadowing to make sense!
	blocker1 = getent("e5_ladder_blocker1","targetname"); 
	blocker2 = getent("e5_ladder_blocker2","targetname"); 
	
	earthquake( 1.0, 1, level.player.origin, 2000 );
	wait( 0.3 );
	// wait till explosion then it is time to go.
	// call effect that hides swap

//	blocker1 delete();
// spawn origin to call
	blocker1_fake_origin = spawn("script_origin", blocker1.origin );
	fx = playfx (level._effect["bigbang"], blocker1_fake_origin.origin);
	physicsExplosionSphere( blocker1_fake_origin.origin, 250, 200, 8 );
	earthquake( 0.7, 0.3, blocker1_fake_origin.origin, 2000 );
	wait(0.1);
	blocker1 delete();
	blocker1_fake_origin delete();
	
	wait( 0.7 );
	 
	blocker2_fake_origin = spawn("script_origin", blocker2.origin );
	fx = playfx (level._effect["bigbang"], blocker2_fake_origin.origin);
	physicsExplosionSphere( blocker2_fake_origin.origin, 250, 200, 8 );
	earthquake( 0.7, 0.3, blocker2_fake_origin.origin, 2000 );
	wait(0.1);
	blocker2 delete();
	blocker2_fake_origin delete();
}


// This sets up all the triggers and calls earth quake and the correct explosions as the player runs out.
escape_jl()
{
	explode2_swap1 = GetEnt( "bridge_exploder02_good", "targetname" );
	explode2_swap1b = GetEnt( "bridge_exploder02_bad", "targetname" );
	explode7_swap1 = GetEnt( "bridge_exploder01_good", "targetname" );
	explode7_swap1b = GetEnt( "bridge_exploder01_bad", "targetname" );
	
	explode2_swap1b hide();
	
	explode7_swap1b hide();
	
	// dmg triggers
	dmg_explode1 = GetEnt( "dmg_explode1", "targetname" );
	dmg_explode2 = GetEnt( "dmg_explode2", "targetname" );
	dmg_explode3 = GetEnt( "dmg_explode3", "targetname" );
	dmg_explode4 = GetEnt( "dmg_explode4", "targetname" );
	
	dmg_explode1 trigger_off();
	dmg_explode2 trigger_off();
	dmg_explode3 trigger_off();
	dmg_explode4 trigger_off();

	flag_wait( "obj_backstage_roof" );

	// setup single triggers at once then do an array and use script noteoworthy to know the difference.
	// explosion1: PLayer just gets off the ladder and object blow up right in his face
	// explosion2
	
	// added effects and base timing
	// a need to effect that hidees model swap with geo that looks good
	// need add brush models being swapped out.
	// need to get stuff flying over players head in the last moment.
			// spawn in entities at the last moment and throw them.
			// if playe is aggresive and cause shell shock, if he slows down a little no shell
						// keep radius tight to circle
						// make some peices like a light is slowly falling over.
						
	// blast decal with fire					
	
	// add cars taking off down the road 

	explode1 = GetEnt( "explode1", "targetname" );	
	GetEnt("trig_e5_pier", "targetname") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode1.origin);
	radiusdamage( explode1.origin+(0,0, 0), 500, 4, 4 );
	radiusdamage( explode1.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode1.origin, 250, 200, 8 );
	earthquake( 0.7, 0.3, explode1.origin, 2000 );
	
//	explode1_swap1 show();
//	fx = playfx (level._effect["opera_large_fire"], explode1.origin + (60,90,-20));
	dmg_explode1 trigger_on();
	
	
	// need to change to burnt decal and call pier on fire.
	
	explode2 = GetEnt( "explode2", "targetname" );
	GetEnt("explode2", "script_noteworthy") waittill("trigger");
	
	level thread kill_last_guys_on_pier();
//	fx2 = playfx (level._effect["tank_explosion"], explode2.origin);	
	fx2 = playfx (level._effect["bigbang"], explode2.origin);
	radiusdamage( explode2.origin+(0,0, 0), 75, 200, 200 );
	physicsExplosionSphere( explode2.origin, 250, 200, 8 );
	earthquake( 1.6, 0.3, explode2.origin, 2000 );
	dmg_explode3 trigger_on();
	explode2_swap1 hide();
	explode2_swap1b show();
	//	playfx( level._effect["opera_large_fire"], so[i].origin );
	//
	
	// explosion3 n 4 a quik two timed explosion
	// explode3_4 trigger
	
	explode3 = GetEnt( "explode3", "targetname" );
	explode4 = GetEnt( "explode4", "targetname" );
	GetEnt("explode3_4", "script_noteworthy") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode3.origin);
	radiusdamage( explode3.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode3.origin, 250, 200, 8 );
	earthquake( 1.6, 0.3, explode3.origin, 2000 );
//	fx = playfx (level._effect["opera_large_fire"], explode3.origin + (-30,-30,-20));
//	dmg_explode3 trigger_on();
	
	
//	wait( 0.7 );
//	level.player shellshock("default", 0.5);
//	fx = playfx (level._effect["bigbang"], explode4.origin);
	radiusdamage( explode4.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode4.origin, 250, 200, 8 );
	earthquake( 1.3, 0.5, explode4.origin, 2000 );
//	explode3_swap4 show();

	
	explode5 = GetEnt( "explode5", "targetname" );
	GetEnt("explode5", "script_noteworthy") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode5.origin);
	radiusdamage( explode5.origin+(0,0, 0), 220, 200, 200 );
	physicsExplosionSphere( explode5.origin, 250, 200, 8 );
	earthquake( 1, 1, explode5.origin, 2000 );
//	fx = playfx (level._effect["opera_large_fire"], explode5.origin + (90,90,-20));
//	explode5_swap1 show();
	
	
	
	explode6 = GetEnt( "explode6", "targetname" ); // this one feels like it is to close.
	explode6b = GetEnt( "explode6b", "targetname" ); // this one feels like it is to close.
	GetEnt("explode6", "script_noteworthy") waittill("trigger");
	
	
//	spawner = getent ("june_park1", "targetname");
//	ent_poop = spawner stalingradSpawn();
	
//	poop_node = getnode ("e5_poop_node","targetname");
//	ent_poop setscriptspeed("sprint");
//	ent_poop lockalertstate( "alert_red" );
//	ent_poop setperfectsense( true );
//	ent_poop setgoalnode( poop_node);
	// if the player waits then bring him in.
//	wait( 1.9 );
	fx = playfx (level._effect["bigbang"], explode6.origin);
//	fx = playfx (level._effect["opera_large_fire"], explode6b.origin + ( 0, 0,-51));
	radiusdamage( explode6.origin+(0,0,10), 75, 200, 200 );
	physicsExplosionSphere( explode6.origin, 60, 10, 2 );
	earthquake( 1.8, 0.2, explode6.origin, 2000 );
//	level.player shellshock("default", 1.5);
//	truck = getent ("dock_truck","targetname");
//	truck_sign = GetEnt( "dock_truck_sign", "targetname" );
//	truck_sign LinkTo( truck);
//	truck moveTo( truck.origin + (0,0,-11) ,0.1 );
//	truck rotateroll( 4, 0.1); 
	
	wait( 0.2 );
	
	explode7_swap1 delete();
	explode7_swap1b show();
	
//	truck = getent("dock_truck","targetname");
//	truck moveto( truck.origin = ( 300, 330 ,250 ), 0.3, 0.1, 0.1 ); 
//	truck waittill("movedoone");
		
//	fx = playfx (level._effect["bigbang"], explode6b.origin);
	physicsExplosionSphere( explode6b.origin, 500, 400, 8 );
	earthquake( 0.9, 0.2, explode6b.origin, 2000 );	
	
	//Steve G - pit fire
	//iprintlnbold("THE FLAMING PIT");
	pit_org = spawn("script_origin", (4116, 2004, -277));
	pit_org playloopsound("dock_fire_01", 0.5);
	
	GetEnt("explode7", "script_noteworthy") waittill("trigger");
//	fx = playfx (level._effect["bigbang"], explode7.origin);
//	if ( IsAlive(ent_poop) )
//	{
//		ent_poop dodamage(1000, (0,0,0));
//	}
//	radiusdamage( explode7.origin+(0,0,10), 10, 10, 10 );
	explode7 = GetEnt( "explode7", "targetname" );
	physicsExplosionSphere( explode7.origin, 200, 100, 1 );
	earthquake( 2.3, 0.2, explode7.origin, 2000 );
	//wait( 1 );
	level.player shellshock("default", 3.3);
	// explosion4
	// explosion5
}

// jeremyl added this cause it's to tough with guys alive on pier
kill_last_guys_on_pier()
{
	guys = getaiarray("axis");
	for (i=0; i<guys.size; i++)
	{
			if (isalive(guys[i]))
			{		
					guys[i] dodamAge(1000, (0,0,5));
					radiusdamage( guys[i].origin+(0,0,50), 200, 500, 500 );
			}
	}
}

kill_player_if_drop()
{
	GetEnt("damage_player_hole", "targetname") waittill("trigger");
//	wait(1);
	dead = spawn( "script_origin", level.player.origin);
	level.player LinkTo( dead );
	level.player dodamAge(1000, (0,0,1));	
		
	
	// ludes
}

jump_text()
{
	GetEnt("jump_hint", "targetname") waittill("trigger");
	tutorial_message( "OPERAHOUSE_HINT_JUMP" );	// PRESS [[{+gostand}]] TO JUMP

	// need to put into locs // need to creatte string editer
	wait(1.3);
	tutorial_message( "" );
}

// new jodi timier
jl_timer_new()
{
		level thread timer_start(45);
}

// setup cars here that are seen taking off and driving away as bond does the jump..
e5_cars_escaping_pullup()
{

	// spawn in cars differently and place effects on the 
	e5_car1 = getent( "e5_car1", "targetname" );
	e5_car1 thread setup_car_driver();
	vnode_start1 = getvehiclenode( "e5_car1_path1", "targetname" );
	
	
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_l_front" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_r_front" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back" );
	
	e5_car1 attachpath( vnode_start1 );
	e5_car1 startpath( vnode_start1 );
	e5_car1.health = 100000;

	//Steve G 
	//iprintlnbold("CAR ONE");
	e5_car1 playsound("car_approach_01");
	
	wait( 3 );
	e5_car2 = getent( "e5_car2", "targetname" );
	e5_car2 thread setup_car_driver();
	
	e5_car2 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_l_front" );
	e5_car2 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_r_front" );
	e5_car2 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back" );
	e5_car2 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back" );
	
	vnode_start2 = getvehiclenode( "car2_path", "targetname" );
	e5_car2 attachpath( vnode_start2 );
	e5_car2 startpath( vnode_start2 );
	e5_car2.health = 100000;
	
	//Steve G 
	//iprintlnbold("CAR TWO");
	e5_car2 playsound("car_approach_02");
	
	// if not then delete and make a new one..
	GetEnt("explode7", "script_noteworthy") waittill("trigger");
	
	//Steve G - Car Sounds
	//iprintlnbold("VROOOOOMMM");
	level.player playsound("cars_ending");
		
	vnode_start3 = getvehiclenode( "e5_car1_path2", "targetname" );
	e5_car1 thread setup_car_driver();
	e5_car1 attachpath( vnode_start3 );
	e5_car1 startpath( vnode_start3 );
	
	wait( 0.3);
	vnode_start4 = getvehiclenode( "car2_path2", "targetname" );
	e5_car2 thread setup_car_driver();
	e5_car2 attachpath( vnode_start4 );
	e5_car2 startpath( vnode_start4 );
}


// setup guy with passengers in car
// need to precache model being used.
#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver setmodel ("henchman_b1_h1_complete");
	driver LinkTo( self, "tag_driver" );
	
	passenger = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
	passenger.angles = self.angles;
	passenger setmodel ("henchman_b1_h1_complete");
	passenger LinkTo( self, "tag_passenger02" ); 
	
	// play anims
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	passenger useAnimTree(#animtree);
	passenger setFlaggedAnimKnobRestart("idle", %vehicle_passenger);
	
	// delete at end node.
	self waittill("reached_end_node");
	driver delete();
	passenger delete();
}	
// only put this in if we can afford the memory of that guy



//############################################################################
//	
e5_boat_intro()
{
// 	time = 2;	// time between segments
// 	level.patrol_boat.origin = goal_spot.origin;
// 	level.patrol_boat.angles = goal_spot.angles;
// 	wait(0.05);	// let the boat move into position before the MoveTo command starts


	// Need to move to the anim start position or it won't work
	goal_spot = GetEnt( "so_e5_boat_path", "targetname" );
	level.patrol_boat Hide();
	level.patrol_boat.origin = goal_spot.origin;
	level.patrol_boat.angles = goal_spot.angles;
	wait(0.05);

	level.patrol_boat Show();
	// Shoot at the player
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		// on the off chance they're dead...
		if ( IsAlive( level.patrol_sailors[i] ) )
		{
			level.patrol_sailors[i] SetEnableSense(true);
			level.patrol_sailors[i] SetDeathEnable(true);
			level.patrol_sailors[i] Show();
			if ( IsDefined( level.patrol_sailors[i].script_noteworthy ) &&
				 level.patrol_sailors[i].script_noteworthy == "gunner" )
			{
				level.patrol_sailors[i] cmdshootatentity( level.player, true, 8.0, 0.25 );
				level.patrol_sailors[i] thread maps\operahouse_util::reinforcement_awareness( 8 );
			}
		}
	}

	level.patrol_boat thread maps\operahouse_fx::boat_crash();

	// Crash into the dock
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "dock_impact_1" );
	earthquake( 0.15, 0.5, level.patrol_boat.origin, 2000 );

	//	Pier gets sideswiped
	earthquake( 0.3, 1.0, level.patrol_boat.origin, 2000 );
	so_crash = GetEnt( "so_platform_crash1", "targetname" );
	jolt_force = AnglesToForward( so_crash.angles ) * 100;
//	physicsJolt( so_crash.origin, so_crash.radius, 0, jolt_force );
	radiusdamage(so_crash.origin, 168, 5, 5, level.player, "MOD_FORCE_EXPLOSION" );

	// Light falls into the water too
	so_push_light = GetEnt( "so_e5_ignite_light", "targetname" );
	jolt_force = AnglesToForward( (0.0, 45.0, 0.0) ) * 100;
	physicsJolt( so_push_light.origin, 10, 0, jolt_force );

	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "dock_impact_2" );

	// Crash into the dock
	earthquake( 0.2, 1, level.patrol_boat.origin, 2000 );


	// Far platform collapses
	platform = GetEnt( "sbm_e5_platform", "targetname" );
	so_crash = GetEnt( "so_platform_crash2", "targetname" );
	platform RotateTo( so_crash.angles, 1.0 );
	jolt_force = AnglesToForward( (0.0, so_crash.angles[1], 0.0) ) * 10;	// direction vector * force
	physicsJolt( so_crash.origin, so_crash.radius, 0, jolt_force );

	// Allow them to run around!
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "spark_stop" );
	dialog_played = false;
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		if ( IsAlive(level.patrol_sailors[i]) )
		{
			level.patrol_sailors[i] Unlink();

			if ( dialog_played == false )
			{
				// Intro dialog
				line = "";
				switch( RandomInt(4) )
				{
				case 0:
					line = "PBM1_OperG_036A";
					break;
				case 1:
					line = "PBM2_OperG_037A";
					break;
				case 2:
					line = "PBM1_OperG_038A";
					break;
				case 3:
					line = "PBM1_OperG_039A";
					break;
				}
				level.patrol_sailors[i] thread play_dialogue( line );
				dialog_played = true;
			}
		}
	}

	// Reset to init pos
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "end" );
	level.patrol_boat.origin = level.patrol_boat.start_origin;
	level.patrol_boat.angles = level.patrol_boat.start_angles;

	level thread e5_start_fire();

	flag_set( "obj_escape" );
	level thread maps\operahouse_util::time_limit_init(72);
	// jeremyl commented out bad guys for the last run
	wait( 27 );
	level thread jl_timer_new(); // need more time to get across 45
	// need to make it so the player has to at least kill one or two guys before doing this.. but this works now.
	// start studios run 
//	level thread run_or_diw(); // kill of guys alive 

	level thread maps\_autosave::autosave_now( "e5run");	// Back dock
	level thread e5_explosion_allow_player_down();  // remove blockers and allow the player down.
	level thread e5_big_bang(); // start big bang and all other goodies.
	level notify("kill_e5_snipers");

	wait( 0.5 );

	// Set everyone to perfect sense because they get reset to alert_green 
	//	after a restart from checkpoint.  Retarded, yes.
	ai = GetAIArray( "axis" );
	for ( i=0; i<ai.size; i++ )
	{
		ai[i] SetPerfectSense( true );
	}
}


//
//	Play fire effects at the appropriate times
e5_start_fire()
{
	fire_level = 1;
	while (1)
	{
		so = GetEntArray( "so_e5_fire"+fire_level, "targetname" );
		for ( i=0; i<so.size; i++ )
		{
			if ( (level.bx || level.ps3) && IsDefined(so[i].script_noteworthy) ) //GEBE
			{
				if ( so[i].script_noteworthy == "no_ps3" )
				{
					continue;	// not on PS3!
				}
			}
			playfx( level._effect["opera_large_fire"], so[i].origin );
		}
		level waittill( "advance_fire" );

		fire_level++;
	}
}

// this grabs all the ai, makes them run away or kills them depending on there location
// setup script noteworthy for guys on each plat form that if they are alive, then blow them up
// setup grab any guys that be run and let them run away and get blow up as they run away just like whites and eco hotel
run_or_diw()
{	

	self setperfectsense( true );
	level waittill("kill_e5_snipers");
	// ludes
//	guys = getaiarray("axis");
//	for (i=0; i<guys.size; i++)
//	{
			if (isalive(self))
			{		
				//if ( IsDefined( self.targetname ) && self.targetname == "ai_e5_towers" )
				//{
					self dodamage(1000, (0,0,5));
					radiusdamage( self.origin+(0,0,50), 200, 500, 500 );
					wait( 0.5 + randomfloat( .7 ) );
				//}
			}
//	}
}

// make all of these guys easy to shoot the event is way to hard now.
ai_accuracy_e5()
{	
	guys = getaiarray("axis");
	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i].accuracy = 0.3;
		}
	}
	//ludes
	flag_wait("obj_escaped");
	
	guys = getaiarray("axis");
	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i].accuracy = 0.01;
		}
	}
}
//
//
e5_big_bang_warning()
{
	level endon( "time_limit_stop" );
	level endon( "time_limit_expired" );


//	curtime 
	// using my own variable so I can control the playing of dialog.
	//	if it's a float, it can skip a number.
	time_left = int( level.timer_hud.time );
	while ( 1 )
	{
		switch( time_left )
		{
		case 75:
			level.player thread play_dialogue( "TANN_OperG_040A", true );	//Tanner: Those flames are too close to that boat, Bond.  You've got to leave.
			level notify( "advance_fire" );
			break;
		case 45:
			level.player thread play_dialogue( "TANN_OperG_041A", true  );	//Tanner: Bond, that boat's a timebomb!  Hurry!
			level notify( "advance_fire" );
			break;
		case 30:
			level.player thread play_dialogue( "TANN_OperG_042A", true  );	//Tanner: You've got to get off that dock!
			level notify( "advance_fire" );
			break;
		case 15:
			level.player thread play_dialogue( "TANN_OperG_043A", true  );	//Tanner: Run for it, Bond!  That boat could explode at any moment!
			level notify( "advance_fire" );
			break;
		case 3:
//			iPrintLnBold( "Tanner: BOND!!");
			break;
		}
		wait( 1.0 );
		time_left = time_left - 1;
	}
}


//############################################################################
//	BIG EXPLOSION!
e5_big_bang()
{
	so = GetEnt( "big_bang", "targetname" );

	thread e5_big_bang_warning(); // this is where he starts the timer countdown.
	level waittill( "time_limit_expired" );

//	camera = level.player customCamera_Push( "world", ( 4381, 2951, 105), (5.86, -94.55, 0.0) , 0.05);
//	player_stick();
//	level.sticky_origin RotateTo();
//	wait( 1.0 );

	//	BOOM!
	fx = playfx (level._effect["bigbang"], level.patrol_boat.origin + (0,0,50));
	radiusdamage( so.origin+(0,0,500), 00, 500, 500 );
//	physicsExplosionSphere( so.origin, 3000, 2000, 8 );
	earthquake( 2.0, 1, level.player.origin, 2000 );
	level.player DoDamage( 10001, level.player.origin );
	player_stick();
	wait(0.4);
	fx = playfx (level._effect["bigbang"], level.player.origin + (0,0,0));
//	MissionFailedWrapper();
	level.player shellshock( "flashbang", 50 ); // much cooler and smoother ending
}

fade_to_black()
{
	level.hud_black = newHudElem();
	level.hud_black.x = 0;
	level.hud_black.y = 0;
	level.hud_black.horzAlign = "fullscreen";
	level.hud_black.vertAlign = "fullscreen";
	level.hud_black SetShader("black", 640, 480);
	level.hud_black.alpha = 0;
	
	wait( 0.1 );
	
	level.hud_black.alpha = 1;
	level.hud_black fadeOverTime( 2.0 ); 
//	level.hud_black.alpha = 1;
}


//############################################################################
//	setup the special balcony push quick kill anim
set_balcony_qk()
{
	self endon( "death" );

	// give time for the guy to get close to the edge and in position
	wait( 1.5 );

	if ( !IsDefined(self.new_qk_anim) )
	{
		self.new_qk_anim = true;
		self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");
	}
}

//############################################################################
//	Cause the stage to fall
//
stage_controller()
{
	level.stage = spawnstruct();

	// Stage
	level.stage.eye				= GetEnt( "sbm_eye",				"targetname" );
	level.stage.eye_flat		= GetEnt( "sbm_eye_flat",			"targetname" );
	level.stage.eye_flat_clip	= GetEnt( "sbm_eye_clip",			"targetname" );
	level.stage.arm				= GetEnt( "sbm_arm",				"targetname" );
	level.stage.arm_base		= GetEnt( "sbm_arm_base",			"targetname" );
	level.stage.iris			= GetEnt( "sbm_iris",				"targetname" );
//	level.stage.pupil			= GetEnt( "sbm_pupil",				"targetname" );
	level.stage.screen_l		= GetEnt( "sbm_stage_screen_left",	"targetname" );
	level.stage.screen_r		= GetEnt( "sbm_stage_screen_right", "targetname" );
	level.stage.screen_image	= GetEnt( "sbm_stage_screen_image",	"targetname" );
	level.stage.cover_l			= GetEnt( "cover_stage_left",		"targetname" );
	level.stage.cover_r			= GetEnt( "cover_stage_right",		"targetname" );

	// the anim model will animate and the eye, being linked to it, should animate with it.
	level.stage.fx_eye			= GetEnt( "fxanim_stage_fall",		"targetname" );
	level.stage.eye	LinkTo(level.stage.fx_eye, "stage_jnt" );

	level.stage.eye				maps\operahouse_util::save_orientation();
	level.stage.arm				maps\operahouse_util::save_orientation();
	level.stage.iris			maps\operahouse_util::save_orientation();
//	level.stage.pupil			maps\operahouse_util::save_orientation();
	level.stage.screen_l		maps\operahouse_util::save_orientation();
	level.stage.screen_r		maps\operahouse_util::save_orientation();
	level.stage.screen_image	maps\operahouse_util::save_orientation();
	level.stage.cover_l			maps\operahouse_util::save_orientation();
	level.stage.cover_r			maps\operahouse_util::save_orientation();



	// attach stuff to the eye
	attach_array = GetEntArray( "attach_eye", "targetname" );
	for ( i=0; i<attach_array.size; i++ )
	{
		attach_array[i] LinkTo( level.stage.eye );
	}

	// attach flat eye clip to the flat eye
	//	This is used after the stage collapses.  Without this, you will sink into the eye
	//	because the game doesn't think you're meant to run on the wall (which is now a floor)
	//	So we compile a flat version so the game doesn't get confused.
	level.stage.eye_flat_clip	LinkTo( level.stage.eye_flat );

	// attach stuff to the iris
	attach_array = GetEntArray( "attach_iris", "targetname" );
	for ( i=0; i<attach_array.size; i++ )
	{
		attach_array[i] LinkTo( level.stage.iris );
	}

//	level.stage.pupil		LinkTo( level.stage.iris );
	level.stage.iris		maps\operahouse_util::linkEx( level.stage.arm );
	level.stage.arm_base	maps\operahouse_util::linkEx( level.stage.arm );
	wait(0.1);

	// This piece is rotated 90 degrees so that the game knows you will be standing on this surface.
	//	But we need to rotate it up at the start so it's in the closed position.
//	level.stage.pupil	RotatePitch( 90, 0.1 );
	level thread stage_screen_open( 0.1 );	// open the projection screen
	level thread stage_cover_close( 0.1 );	// cover the stage ... it will open when you come under it
	level.stage.screen_image Hide();	// Hide the projection.  It will turn on when you are moving across

// 	// Testing ONLY
// 	if (0)	// make true to enable
// 	{
// 		trig = GetEnt( "trig_stage", "targetname" );
// 		while (1)
// 		{
// 			trig waittill("trigger" );
// 			stage_collapse( 10.0 );
// 	//		stage_iris_flat();
// 
// 			trig waittill("trigger" );
// 			stage_standup( 10.0 );
// 	//		stage_iris_closed();
// 		}
// 	}
}


stage_collapse( time )
{
	// Stage falls
	level.stage.screen_l	LinkTo(level.stage.fx_eye, "stage_jnt" );
	level.stage.screen_r	LinkTo(level.stage.fx_eye, "stage_jnt" );

	level notify( "stage_fall_1_start" );	// collapse stage

	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.arm		RotatePitch( -13, 5.0 );

	// stage falls
//	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "end" );
// 	thread stage_arm_out( 5.0 );
	level waittill( "scene_anim_done" );
	level.stage.arm		MoveX( -230, 5.0 );
	wait(5.0);

	// finish stage collapse and swap
//	trig = GetEnt( "trig_e4_arm_walk", "targetname" );
//	trig waittill( "trigger" );
//	wait( 0.5 );	// slight delay 

	level notify( "stage_fall_2_start" );	// collapse stage
	level.stage.fx_eye waittillmatch( "a_stage_fall_2", "stage_hits" );

	earthquake( 0.5, 2.0, level.player.origin, 100 );

	// swap the panels - we need to swap them so the player can walk on the one that
	//	was compiled sideways.  Otherwise, the player will sink into the rotated one.
	level.stage.eye_flat.origin = level.stage.eye.origin;
	level.stage.eye_flat Show();
	wait(0.05);
	level.stage.eye Hide();

	level notify( "stage_collapsed" );
}


stage_standup( time )
{
	level.stage.eye		RotatePitch( -90, time, 2, 1 );

	thread stage_arm_in( time );

	level.stage.screen_l	RotatePitch( -90, time );
	level.stage.screen_r	RotatePitch( -90, time );
	wait( time );
}


//############################################################################
// Screen open and close
stage_arm_in( time )
{
	level.stage.arm		MoveX( 230, time );
	level.stage.arm		RotatePitch( 13, time );
//	level.stage.pupil	RotatePitch( 90, time );
	wait( time );
}


//############################################################################
// Screen open and close
stage_arm_out( time )
{
	level.stage.arm		RotatePitch( -13, time );
	level.stage.arm		MoveX( -230, time );
//	level.stage.pupil	RotatePitch( -90, time );
	wait( time );
}


//############################################################################
// Screen elevated and out
stage_arm_up( time )
{
	// used for checkpoints
	if ( time < 0.5 )
	{
		level.stage.arm		MoveX( -330, time );
		level.stage.iris	RotatePitch( -50, time );
//		level.stage.pupil	RotatePitch( -50, time );
		level.stage.arm		RotatePitch( 30, time );
		return;
	}

	level.stage.arm		MoveX( -330, time );
	wait(4.0);
	level.stage.iris	RotatePitch( -45, time-4.0 );
//	level.stage.pupil	RotatePitch( -45, time-4.0 );
	level.stage.arm		RotatePitch( 30, time-4.0 );
	wait( time-4.0 );
}


//############################################################################
	// Screen back in and closed
stage_arm_down( time )
{
	level.stage.arm		MoveTo( level.stage.arm.saved_origin,		time );
	level.stage.arm		RotateTo( level.stage.arm.saved_angles,		time-2.0 );
	level.stage.iris	RotateTo( level.stage.iris.saved_angles,	time-2.0 );
//	level.stage.pupil	RotateTo( level.stage.pupil.saved_angles,	time-2.0 );
	wait( time-2.0 );
}


//############################################################################
// Screen iris open and close
stage_iris_flat()
{
	level.stage.arm		MoveX( -600, 10 );
	wait(2);
	thread stage_screen_close( 8 );
	level.stage.arm		RotatePitch( -25, 12, 2.0, 2.0  );
	level.stage.iris	RotatePitch( 90, 12, 2.0, 2.0  );
//	level.stage.pupil	RotatePitch( 90, 12, 2.0, 2.0  );
	wait( 12 );

	level.stage.screen_image Show();
}


//############################################################################
// Screen iris open and close
stage_iris_closed()
{
	level.stage.screen_image Hide();

	thread stage_screen_open( 10 );
	level.stage.arm		RotatePitch( 25, 12, 2.0, 2.0 );
	level.stage.iris	RotatePitch( -90, 12, 2.0, 2.0 );
//	level.stage.pupil	RotatePitch( -90, 12, 2.0, 2.0 );
	wait(2);
	level.stage.arm		MoveX( 600, 10 );
	wait( 12 );
}


//############################################################################
// Screen open and close
stage_screen_open( time )
{
	level.stage.screen_l	MoveY( -300, time );
	level.stage.screen_r	MoveY( 300, time );
	wait( time );
}


//############################################################################
// Screen open and close
stage_screen_close( time )
{
	level.stage.screen_l	MoveY( 300, time );
	level.stage.screen_r	MoveY( -300, time );
}


//############################################################################
// Screen open and close
stage_cover_open( time )
{
	level.stage.cover_l	MoveY( -200, time, 1.0, 1.0 );
	level.stage.cover_r	MoveY( 200, time, 1.0, 1.0 );
	wait( time );
}


//############################################################################
// cover open and close
stage_cover_close( time )
{
	level.stage.cover_l	MoveY( 200, time );
	level.stage.cover_r	MoveY( -200, time );
}


//############################################################################
//	Open the doors
//
use_trapdoor( object )
{
	door1 = GetEnt( "sbm_trapdoor_1", "targetname" );
	door2 = GetEnt( "sbm_trapdoor_2", "targetname" );

	door1 RotateRoll( -90, 0.5 );
	door2 RotateRoll( 90, 0.5 );

	trig = GetEnt( "trig_e2_trapdoor", "targetname" );
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( ents[i] IsTouching(trig) )
		{
			ents[i] DoDamage( ents[i].health, ents[i].origin );
		}
	}
}

display_chyron()
{
	wait(2.5);
	maps\_introscreen::introscreen_chyron(&"OPERAHOUSE_INTRO_01", &"OPERAHOUSE_INTRO_02", &"OPERAHOUSE_INTRO_03");
}

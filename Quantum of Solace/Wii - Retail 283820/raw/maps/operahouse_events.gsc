#include common_scripts\utility;
#include maps\_utility;










achievement_check()
{
	level waittill( "e3_start" );

	
	if ( !level.broke_stealth )
	{
		GiveAchievement( "Challenge_Opera" );
	}
}





e1_main()
{
	thread fade_out_black(3);

	level thread achievement_check();
	level thread e1_holster_weapons();
	level.greene = maps\operahouse_util::spawn_guys("ai_e1_greene", true, "vips", "civ" );
	level.greene CmdPlayAnim( "Gen_Civs_StandConversation", false );
	level.haines = maps\operahouse_util::spawn_guys("ai_e1_haines", true, "vips", "civ" );
	level.haines CmdPlayAnim( "Gen_Civs_StandConversationV2", false );

	if ( level.play_cutscenes )
	{
		wait(0.05);	

		level thread e1_camera_tutorial();
		thread letterbox_on( false, false, 1.0, false);

		
		level.player FreezeControls(true);
		level.player playerSetForceCover( true );
		setDvar( "cg_disableHudElements", 1 );	

		
		level thread e1_tanner_conversation();
		
		level thread e1_camera_intro();
		level thread display_chyron();
		wait(2.0);	

		player_stick();
		level.player FreezeControls(false);
		level waittill( "opening_scene_done" );

		
		letterbox_off();
		setDvar( "cg_disableHudElements", 0 );
		level.player playerSetForceCover( false, false );
		wait(0.5);	

		level thread maps\_autosave::autosave_now( "E1" );	
		wait(0.05);	
	}
	else
	{
		level thread e1_camera_tutorial();
	}

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements1", "e1_start_ai", false );
	flag_set( "obj_start" );

	level thread e1_patrol_boat_depart();

	trig = GetEnt( "trig_e1_start", "targetname" );
	trig waittill( "trigger" );

	
	thread stage_arm_up( 10.0 );
	
	
	level thread maps\operahouse_snd::play_stage_move_01();

	trig = GetEnt( "trig_e1_bridge", "targetname" );
	trig waittill( "trigger" );

	
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

	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::delete_group( "e1_start_ai" );
	maps\operahouse_util::delete_group( "vips" );
}




e1_stealth_note()
{
	trig = GetEnt( "trig_e1_gates", "targetname" );
	trig waittill( "trigger" );

	wait( RandomFloatRange( 1.0, 3.0 ) );

	line = "";
	if ( level.broke_stealth )
	{
		line = "TANN_OperG_007A";	
	}
	else
	{
		line = "TANN_OperG_006A";	
	}
	level.player play_dialogue( line, true );
}





e1b_main()
{
	
	flag_wait( "obj_reach_understage" );

	static_thug = maps\operahouse_util::spawn_guys("ai_e1_under_arm", true, "e1_ai", "thug" );
	maps\operahouse_util::reinforcement_update("ai_e1_elite_pipes", "e1_ai", false );
	
 	trig = GetEnt( "trig_e1_1st_guy", "targetname" );
 	trig waittill( "trigger" );
	
	
	startemergencylock();
	
	
	level thread maps\operahouse_util::tutorial_block("OPERAHOUSE_WII_TUTORIAL_STEALTH", 12.0 );

	unholster_weapons();

	
	dock_thug = maps\operahouse_util::spawn_guys("ai_e1_dock_patrol", true, "e2_ai", "thug" );
	dock_thug thread e1_patrol();
	level thread maps\_autosave::autosave_now( "E1B" );	

	
	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements2", "e2_ai" );

	
	trig = GetEnt( "trig_e1_midpoint", "targetname" );
	trig waittill( "trigger" );

	level.crane_patroller = maps\operahouse_util::spawn_guys("ai_e1_crane_patrol", true, "e2_ai", "thug" );
	level.crane_patroller thread e1_patroller_alert( "fx_container_splash", "pat_e1_crane_alert" );

	maps\operahouse_util::reinforcement_update("ai_e1_reinforcements3", "e2_ai", false );
	level thread e1_crane_game();
	level thread e1_dock_reinforcements();

	level thread maps\_autosave::autosave_by_name( "e1dock", 30.0 );	

	
	wait( 1.0 );
	if ( level.crane_patroller GetAlertState() == "alert_green" )
	{
		level.crane_patroller play_dialogue( "OTM1_OperG_005A", true );	
	}
	flag_wait( "obj_reach_backstage" );

	maps\operahouse_util::reinforcement_update("", "", false );
	
	ents = GetAIArray();
	for ( i=0; i<ents.size; i++ )
	{
		if ( IsDefined(ents[i].groupname) && ents[i].groupname == "e2_ai" && 
			 ents[i] GetAlertState() == "alert_red" )
		{
			ents[i] SetCombatRole( "rusher" );
		}
	}






	level thread maps\_autosave::autosave_by_name( "E2", 30.0 );	
	level thread e2_main();
}





e1_camera_intro()
{
	level.player customcamera_checkcollisions( 0 );
	camera_id = level.player customCamera_push(
		"world",							
		(  2187, -2435, 651 ),				
		(   1,   112,    0 ),				
		0.00, 								
		0.00,								
		0.00								
	);
	wait( 0.5 );

	level.player customCamera_change(
		camera_id,							
		"world",							
		(  2240, -2761, 541),				
		(  9.36,   55,    0 ),				
		10.00,								
		2.00,								
		2.00								
	);
	wait( 10.0 );

	
	level.player customCamera_pop( 
		camera_id,	
		5.0,		
		2.0,	
		1.0		
	);
	wait( 5.0 );
	level.player customcamera_checkcollisions( 1 );
	level notify( "opening_scene_done" );
}





e1_holster_weapons( thug )
{
	level endon( "e3_start");

	holster_weapons();
	level waittill_any( "reinforcement_spawn", "start_camera_spawner", "alert_red" );

	level.broke_stealth = true;
	unholster_weapons();
}





e1_tanner_conversation( )
{
 	wait( 1.0 );	

	level.player play_dialogue( "BOND_OperG_001A" );		
	wait( 1.0 );

	level.player play_dialogue( "TANN_OperG_002A", true );	
	wait( 1.0 );

	level.player play_dialogue( "BOND_OperG_003A" );		
	flag_wait( "obj_start" );

	level.player play_dialogue( "TANN_OperG_501A", true );	

	flag_wait( "flag_e1_camera" );

	level.player play_dialogue( "TANN_OperG_702A", true );	
	flag_wait( "flag_e1_powerbox" );

	level.player play_dialogue( "TANN_OperG_703A", true );	
}




e1_camera_tutorial()
{
	level endon( "e2_start" );

	
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

	
	
	
	
	flag_wait( "obj_start" );


	

	
	flag_wait( "flag_e1_camera" );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_CAMERA", 9 );
}




e1_tapped()
{
	level endon( "e2_start" );
	self waittill( "tapped" );
	wait( 1.2 );	

	level.player thread play_dialogue( "TANN_OperG_701A", true );	

	while ( true )
	{
		level.player waittill( "phonemenu", phone_state );
		if ( phone_state == 3 )
		{
			wait( 2.0 );

			
			while ( level.player.radio_origin IsWaitingOnSound() )
			{
				wait(0.05);
			}
			level.player thread play_dialogue( "BOND_OperG_503A", true );	

			wait( 1.0 );
			level.greene StopAllCmds();
			level.haines StopAllCmds();
			level.greene thread maps\operahouse_util::goto_spot( "n_greene_spot", 32 );
			wait( 1.1 );
			level.haines thread maps\operahouse_util::goto_spot( "n_guy_spot", 32 );
			break;
		}
		wait( 0.05 );
	}
}











e1_gate_puzzle()
{
	level thread maps\_autosave::autosave_by_name( "e1gates", 5.0);	

	
	for ( i=1; i<= 3; i++ )
	{
		level.gate[i] = GetEnt( "lift0"+i, "targetname" );
		
		level.gate[i].state = 0;	
		level.gate[i].start_pos = level.gate[i].origin;

		attachments = GetEntArray( "hydraulic0"+i, "targetname" );
		for ( j=0; j<attachments.size; j++ )
		{
			attachments[j] LinkTo( level.gate[i] );
		}
	}

	
	for ( i=1; i<= 2; i++ )
	{
		level.gate_switch[i] = GetEnt( "sm_e1_gate_switch"+i, "targetname" );
		level.gate_switch[i].index = i+1;
		level.gate_switch[i].light_fx = SpawnFx(level._effect["light_green"], level.gate_switch[i].origin + (0.0, 0.6, 1.2) );
		TriggerFx(level.gate_switch[i].light_fx);
	}

	
	level.gate[2].state = 1;
	level.gate[3].state = -1;

	trig = GetEnt( "trig_e1_gates", "targetname" );
	trig waittill( "trigger" );

	level thread stage_cover_open( 10.0 );

	
	level thread maps\operahouse_snd::play_stage_move_02();
	

	e1_move_gate( 2, level.gate[2].state );
	e1_move_gate( 3, level.gate[3].state );
	wait( 2.1 );

	maps\_playerawareness::setupEntSingleUseOnly( 
		level.gate_switch[1],			
		::e1_use_gate_control,			
		&"OPERAHOUSE_HINT_USE_SWITCH1",	
		0,								
		"",								
		false,						   	
		true,							
		undefined,		   				
		level.awarenessMaterialNone,	
		true,							
		false );					   	
	maps\_playerawareness::setupEntSingleUseOnly( 
		level.gate_switch[2],			
		::e1_use_gate_control,			
		&"OPERAHOUSE_HINT_USE_SWITCH3",	
		0,								
		"",								
		false,						   	
		true,							
		undefined,		   				
		level.awarenessMaterialNone,	
		true,							
		false );					   	


}





e1_spark_hazard()
{
	level endon( "e2_start" );
	
	stopemergencylock();
	
	trig = GetEnt( "trig_e1_sparks", "targetname" );		
	sparks = GetEntArray( "so_e1_gate_sparks", "targetname" );	
	for ( i=0; i<sparks.size; i++ )
	{
		sparks[i] LinkTo( level.gate[2] );	
	}

	
	while (1)
	{
		e1_the_hurting( trig, sparks );
		e1_the_hurting( trig, sparks );
		wait( 2.0 );

		e1_the_hurting( trig, sparks );
		wait( 0.5 );

		e1_the_hurting( trig, sparks );
		wait( 1.0 );
	}
}




e1_the_hurting( trig, sparks )
{
	player_electrocuted = false;

	
	for ( i=0; i<sparks.size; i++ )
	{




		PlayFX( level._effect["spark"], sparks[i].origin );
		
		
		sparks[i] playsound("electric_shock");
	}

	timer = GetTime() + 500;	
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





e1_use_gate_control( object )
{
	control = object.primaryEntity;

	hint_string = "";	

	
	level.gate[ control.index ].state--;
	if ( level.gate[ control.index ].state < -1 )
	{
		level.gate[ control.index ].state = 1;
	}

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

	
	
	
	if ( level.gate[ 2 ].state == 0 &&
		 level.gate[ 3 ].state == 0 && IsDefined(level.gate_switch[1].light_fx) )
	{
		
		for ( i=1; i<=2; i++ )
		{
			level.gate_switch[i].light_fx Delete();
			PlayFx( level._effect["light_red_solid"], level.gate_switch[i].origin + (0.0, 0.6, 1.2) );
			level.gate_switch[i] setUseable( false );
		}

		
		level.gate[2] thread e1_spark_hazard();
	}
	else
	{
		
		maps\_playerawareness::setupEntSingleUseOnly( 
			control,	
			::e1_use_gate_control,			
			hint_string,					
			0,								
			"",								
			false,						   	
			true,							
			undefined,		   				
			level.awarenessMaterialNone,	
			true,							
			false );					   	
	}
}




e1_move_gate( gate_num, direction )
{
	

	offset = level.gate[ gate_num ].state*(0,0,30);
	level.gate[gate_num] MoveTo( level.gate[gate_num].start_pos + offset, 2 );

	
	level.gate[gate_num] playsound("opera_platform_move");
	
	if ( level.gate[ gate_num ].state == -1 )
	{
		level notify( "fx_stage_splash"+gate_num );
		
		
		level.gate[gate_num] playsound("opera_platform_splash");
	}
}




e1_patrol_boat_depart()
{
	start  = GetEnt( "so_e1_boat_path", "targetname" );
	goal_spot = GetEnt( start.target, "targetname" );
	speed = 5;	
	while ( IsDefined(goal_spot) )
	{
		old_speed = speed;
		if ( IsDefined( goal_spot.script_float ) )
		{
			speed = goal_spot.script_float;
		}

		
		dist = Distance( start.origin, goal_spot.origin );

		
		
		time = dist / (goal_spot.script_float * 17.6);
		level.patrol_boat MoveTo( goal_spot.origin, time );
		level.patrol_boat RotateTo( goal_spot.angles, time );
		
		
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

	
	level.patrol_boat stoploopsound( );
	
	
	wait_so = GetEnt( "so_e5_boat_wait", "targetname" );
	level.patrol_boat MoveTo( wait_so.origin, 0.05 );
	level.patrol_boat RotateTo( wait_so.angles, 0.05 );
}




e1_patrol()
{
	self endon( "alert_yellow" );
	self endon( "alert_red" );
	self endon( "death" );

	trig = GetEnt( "trig_e1_patrol", "targetname" );
	trig waittill( "trigger" );

	self thread play_dialogue( "OPM1_OperG_004A" );		
	self StartPatrolRoute( self.script_noteworthy );
	wait( 1.5 );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_PATROL", 7 );
}




e1_crane_game()
{
	

	
	level.crane_hook	= GetEnt( "crane_hook", "targetname" );
	hook				= GetEnt( "sm_crane_hook", "targetname" );
	if ( IsDefined(hook) )
	{
		hook LinkTo( level.crane_hook );
	}

	
	level.container_sbm = GetEnt( "sbm_e2_container", "targetname" );
	if ( IsDefined( level.container_sbm ) )
	{
		level.container_sbm LinkTo( level.crane_hook );
	}

	
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
	playfx ( level._effect["light_green"], crane_control.origin );

	maps\_playerawareness::setupEntSingleUseOnly(
		crane_control,					
		::use_crane,					
		&"OPERAHOUSE_HINT_CRANE",		
		0,								
		"",								
		true,						   	
		false,							
		undefined,		   				
		level.awarenessMaterialNone,	
		true,							
		false,						   	
		false );					   	
}


use_crane( entObject )
{
	level.container_sbm ConnectPaths();

	level.crane_hook MoveZ( -75, 1.0, 0.9 );
	
	
	level thread maps\operahouse_snd::play_container_lower();
	
	wait( 1.0 );

	level notify("fx_container_splash");
	
	level.crane_hook MoveZ( -43, 1.0, 0, 0.9 );
	wait( 1.0 );	
}


e1_patroller_alert( alert_notify, redirect_patrol )
{
	self endon( "death" );
	self endon( "alert_red" );

	level waittill( alert_notify );

	self SetAlertStateMin( "alert_yellow" );




	self StartPatrolRoute( redirect_patrol );
}

e1_dock_reinforcements()
{
	level endon( "e2_start" );

 	dock_door = GetEnt( "e1_dock_door", "targetname" );
 	if ( IsDefined( dock_door ) )
	{
		dock_door MoveZ( -90, 0.05 );
		dock_door DisconnectPaths();

		level waittill( "reinforcement_spawn" );

		
		dock_door ConnectPaths();
		dock_door MoveZ( 120, 3.0 );
	}
}





e2_main()
{
	level notify( "e2_start" );
	


	level.player thread play_dialogue( "TANN_OperG_008A", true );	

	

	maps\operahouse_util::reinforcement_update("ai_e2_reinforcements1", "e2_ai", false );

	
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
	



















	
	trig = GetEnt( "trig_e2_backstage", "targetname" );
	trig waittill( "trigger" );
	level thread stage_arm_down( 10.0 );
	
	
	level thread maps\operahouse_snd::play_stage_move_03();

 	maps\operahouse_util::delete_group( "e1_ai" );	

	trig = GetEnt( "trig_e2_middle", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("ai_e2_reinforcements2", "e2_ai", false );

	trig = GetEnt( "trig_e2_dressing_room", "targetname" );
	trig waittill( "trigger" );

	level thread maps\_autosave::autosave_by_name( "E2dressing", 10.0 );	

	
	trig = GetEnt( "trig_e2_near_front", "targetname" );
	trig waittill( "trigger" );

	maps\operahouse_util::reinforcement_update("", "", false );
	level thread maps\_autosave::autosave_by_name( "E2base", 30.0 );	

	level thread e2b_main();
}





e2b_main()
{
	
	level thread stage_iris_flat();
	
	
	level thread maps\operahouse_snd::play_stage_move_04();
	
	level thread e2_spawn_quantum();

	trig = GetEnt( "trig_e2_onscreen", "targetname" );
	trig waittill( "trigger" );
	
	
	
	level.player customcamera_checkcollisions( 0 );
	
	
	
	
	level thread e2_roof_sniper();

	
	level.roof_sniper = maps\operahouse_util::spawn_guys("ai_e3_wave1", false, "e3_ai", "thug" );
	level.roof_sniper.targetname = "sniper";

	trig = GetEnt( "trig_e2_off_ledge", "targetname" );
	trig waittill( "trigger" );

	level.player customcamera_checkcollisions( 1 );
	
	thug = maps\operahouse_util::spawn_guys("ai_e2_sniper", true, "e3_ai", "thug" );
	thug thread play_dialogue( "OPS1_OperG_009A" );	
	thug thread maps\operahouse_util::sniper( 10000, "so_e2_stage_sniper_aim", "true" );

	level thread maps\_autosave::autosave_by_name( "e2_top", 5.0 );	
	

	flag_wait( "obj_reach_top" );

	
	level thread stage_iris_closed();
	level thread e3_main();

	
	level waittill( "e3_start" );
 
	maps\operahouse_util::delete_group( "e2_ai" );
}





e2_roof_sniper()
{
	PlayCutscene("OH_Sniper", "scene_anim_done");

	level waittill( "scene_anim_done" );

	level.roof_sniper thread maps\operahouse_util::goto_spot( "auto97" );
}





e2_spawn_quantum( )
{
	
	level.civs		= maps\operahouse_util::spawn_guys("ai_box_seat_civs",	true, "civ_ai", "civ");
	default_animname = "Gen_Civs_StndArmsCrossed";

	
	for ( i=0; i<level.civs.size; i++ )
	{
		level.civs[i] SetEnableSense( false );
		level.civs[i].script_pacifist = 0;		
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

	
	for ( i=0; i<level.civs.size; i++ )
	{
		level.civs[i] StopAllCmds();
		if ( IsDefined( level.civs[i].script_string ) )
		{
			level.civs[i] CmdPlayAnim( level.civs[i].script_string, false );
		}
		else
		{
			level.civs[i] CmdPlayAnim( default_animname, false );
		}
	}


	
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




e2_use_container_door( object )
{
	door = object.primaryEntity;

	door RotateYaw( -60, 0.6, 0.0, 0.5 );
}





e3_main()
{
	level notify( "e3_start" );

	if ( level.play_cutscenes )
	{
		holster_weapons();	

		player_stick( false );

		node = GetNode( "n_e3_stairs_top", "targetname" );
		level.sticky_origin MoveTo( node.origin, 0.5 );
		wait( 0.5 );

		node = GetNode( "n_e4_start", "targetname" );
		level.sticky_origin MoveTo( node.origin, 2.0, 1.0, 0.9 );

		
		vec = VectorNormalize( level.greene.origin - level.player.origin );
		level.sticky_origin RotateTo( VectorToAngles(vec), 2.0, 1.0, 0.9 );
		wait( 2.0 );

		level.player SwitchToWeapon( "sony_phone" );
		wait( 0.7 );
		
		level.player freezecontrols(true);
		
		if (!IsDefined(level.hud_phone))
		{
			x = 0;
			w = 640;
			if ( Getdvar("wideScreen") == "0")
			{
				x = -107;
				w =  854;
			}
			level.hud_phone = newHudElem();
			level.hud_phone.x = x;
			level.hud_phone.y = 0;
			level.hud_phone.horzAlign = "fullscreen";
			level.hud_phone.vertAlign = "fullscreen";
			level.hud_phone SetShader("sp_ig_ob_frame", w, 480);
		}
 		level.hud_phone.alpha = 1;

		
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

		PlayCutscene("OH_Skybox", "scene_anim_done");
		level.freeze_frame = 0;
		level thread e3_camera_snap();
		level thread e3_camera_static();
		level thread e3_civs_flee();
		VisionSetNaked( "Operahouse_picture", 1.0 );
		wait( 1.5 );
		VisionSetNaked( "Operahouse_sunset_03", 0.5 );
		level waittill( "scene_anim_done" );

		
		for ( i=0; i<=3;i++ )
		{
			level.hud_static[i].alpha = 0;
		}

		level.roof_sniper notify( "end_sniper" );
		level.hud_black.alpha = 0;
		level.hud_camera	Destroy();
		level.hud_phone		Destroy();
		VisionSetNaked( "Operahouse_sunset_03", 0.05 );

		
		level.player freezecontrols(false);
		player_unstick();
		level thread maps\_autosave::autosave_now( "E3B" );		
		wait(0.1);

	}

	
	setDVar( "cg_laserrange", 4500 );	
	setDVar( "cg_laserradius", 1.0 );	
	level thread e3_sniper_tutorial();

	flag_set( "obj_kill_snipers" );

	
	wait(1.0);

	level.roof_sniper thread maps\operahouse_util::sniper( "10", undefined, "true" );		
	while ( IsAlive( level.roof_sniper ) )
	{
		wait( 0.5 );
	}
	wait( 2.0 );

	
	thread e3_sniper_talk( );
	e3_sniper_wave( "ai_e3_wave2", 2, 2, 2 );

	wait(2.0);	
	thread e3_sniper_talk2( );
	e3_sniper_wave( "ai_e3_wave3", 5, 3, 3 );

	flag_set( "obj_snipers_dead" );

	level thread e4_main();

	
	level waittill( "scene_anim_done" );
	maps\operahouse_util::delete_group( "e3_ai" );

}





e3_camera_snap()
{
	level endon( "scene_anim_done" );

	num_snaps = 0;
	while (1)
	{
		level.villain1 waittillmatch( "anim_notetrack", "freeze_start" );
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
		
		
		
		level.hud_black.alpha = 1;
		wait( 0.3 );
		level.hud_black.alpha = 0;
		level.hud_camera.alpha = 1;

		VisionSetNaked( "Operahouse_picture", 0.2 );
		wait( 0.2 );
		VisionSetNaked( "Operahouse_sunset_03", 1.0 );

		num_snaps++;
		if ( num_snaps == 5 )
		{
			level notify( "e3_bond_speaks" );
		}
	}
}




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

		level.hud_static[ new_static ].alpha = 0.35;
		level.hud_static[ prev_static ].alpha = 0.0;
		prev_static = new_static;

		
		while ( level.freeze_frame == 1 )
		{
			wait(0.05);
		}

		wait(0.05);
	}
}



e3_civs_flee( exit_node )
{


	
	level waittill( "scene_anim_done" );

	exit_node = GetNode( "n_civ_exit", "targetname" );
	exit_node2 = GetNode( "n_civ_exit2", "targetname" );
	for ( i=0; i<level.civs.size; i++ )
	{

		level.civs[i] thread e3_civ_flee( exit_node );
	}
	level.villain1	thread e3_civ_flee( exit_node2 );
	wait(1.0);
	level.haines	thread e3_civ_flee( exit_node2 );
	wait(2.0);
	level.greene	thread e3_civ_flee( exit_node2 );

	level.player thread play_dialogue( "GREE_OperG_021A" );	
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




e3_sniper_tutorial()
{
	unholster_weapons();

	
	if ( level.player HasWeapon( "SAF45_Opera" ) && level.player HasWeapon( "Mk3LLD_Opera" ) )
	{
		level.player TakeWeapon( "Mk3LLD_Opera" );
		level.player GiveMaxAmmo("SAF45_Opera");
	}

	level.player GiveWeapon( "VTAK31_Opera" );
	level.player SwitchToWeapon( "VTAK31_Opera" );
	
	
	level thread maps\operahouse_util::tutorial_block("OPERAHOUSE_WII_TUTORIAL_SNIPER", 10 );
	
	wait( 15.0 );

	if ( IsAlive( level.roof_sniper ) )
	{
		
		level.roof_sniper SetAlertStateMin( "alert_yellow" );
	}
}








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
	
	for ( i=0; i<spawners.size; i++ )
	{
		spawners[i].targetname = spawnername + "_" + i;
	}
	if ( spawn_max > spawners.size )
	{
		spawn_max = spawners.size;
	}

	
	ent = spawnstruct();
	ent count_init();

	
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

	
	while ( ent.count_ai_alive > 0 )
	{
		if ( ent.count_ai_killed >= kill_max )
		{
			return;
		}
		wait( 0.5 );
	}
}


count_init()
{
	self.count_ai_spawned	= 0;	
	self.count_ai_alive		= 0;	
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



e3_sniper_talk( )
{
	wait( 10.0 );

	switch ( RandomInt(2) )
	{
	case 0:
		level.player play_dialogue( "SBS1_OperG_022A", true );	
		break;
	default:
		level.player play_dialogue( "SBS2_OperG_023A", true );	
	}
}




e3_sniper_talk2( )
{
	wait( 3.0 );

	line = "";
	switch ( RandomInt(5) )
	{
	case 0:
		line = "SBS2_OperG_026A";	
		break;
	case 1:
		line = "SBS1_OperG_027A";	
		break;
	case 2:
		line = "SBV2_OperG_028A";	
		break;
	case 3:
		line = "SBS1_OperG_029A";	
		break;
	case 4:
 		line = "SBS2_OperG_030A";	
		break;
	}

	level.player play_dialogue( line, true );
}





e4_main()
{
	level notify( "e4_start" );

	level.kill_random_shoot = false;
	level thread event_3_to_2_magic_bullet();
	
	black_screen_time = 1.0;
	
		
	level.hudBlack = newHudElem();
	level.hudBlack.x = 0;
	level.hudBlack.y = 0;
	level.hudBlack.horzAlign = "fullscreen";
	level.hudBlack.vertAlign = "fullscreen";

	level.hudBlack.alpha = 0;
	level.hudBlack setShader("overlay_hunted_black", 640, 480);
	
	wait black_screen_time;

	
	maps\operahouse_util::delete_group( "civ_ai" );
	maps\operahouse_util::delete_group( "scene_ai" );

	
	sbms = GetEntArray( "stage_ledge", "targetname" );
	for (i=0; i<sbms.size; i++ )
	{
		sbms[i] trigger_off();
	}

	
	
	
	

	level.player play_dialogue( "SBS2_OperG_031A", true );	
	
	
	level thread maps\operahouse_snd::stop_wagner();

	level.player playerSetForceCover( false );	
	level.player setdemigod(true);

	curr_weapon = level.player getcurrentweapon();
	level.player SwitchToWeapon( "P99" );
	wait(0.05);	
	setSavedDvar( "cg_disableBackButton", "1" ); 
	letterbox_on( true, true, 1.0, true );	
	wait(0.1);

	earthquake( 0.3, 4.5, level.player.origin, 200 );
	
	
	level.player playsound("stage_collapse_front");
	
	wait(3.0);

	ammo_crate = GetEnt( "ammo_crate", "targetname" );
	ammo_crate Delete();
	level.player playsound("bond_xrt_grunt");
	player_unstick();	
	PlayCutscene("OH_StageFall", "scene_anim_done");
	
	level thread stage_collapse( 0.05 );

	so = GetEnt( "so_e3_roof_sniper_aim", "targetname" );
	so LinkTo( level.stage.eye );
	level thread physics_pulse( so );

	
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.kill_random_shoot = true;
	earthquake( 1.5, 1.0, level.player.origin, 100 );

	wait( 1.3 );
	
	level thread maps\operahouse_util::slow_time( .20, 1.5, 0.5 );
	
	
	



	
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level notify ("stop_fake_gunners");
	wait(1.0);
	earthquake( 2.0, 0.5, level.player.origin, 100 );
	setblur( 5.0, 0.05 );
	
	level thread e3_fade_control();
	
	
	

	PlayFX( level._effect["spark"], level.player.origin + (0,0,0));
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,40,0));
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,-40,0));

	
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	earthquake( 0.75, 1.0, level.player.origin, 100 );

	
	level thread maps\operahouse_snd::start_mozart_02();


	level waittill( "scene_anim_done" );

	
	player_stick(true);
	
	fall_spot = GetEnt( "so_e3_fall_spot", "targetname" );
	level.sticky_origin.origin = fall_spot.origin;
	level.sticky_origin.angles = fall_spot.angles;
	wait(0.05);
	level.sticky_origin LinkTo( level.stage.arm );
	level.player AllowStand(false);
	wait(4.3);

	setblur( 0.0, 5.0 );


	wait(.05);

	level.player setdemigod(false);
	level.player AllowStand(true);

	
	thread letterbox_off( true, 0.05 );	
	wait(0.1);

	if ( IsDefined( curr_weapon ) )
	{
		level.player SwitchToWeapon( curr_weapon );
	}


	setSavedDvar( "cg_disableBackButton", "0" ); 


	level thread maps\_autosave::autosave_now( "E4" );		
	wait(0.5);
	thugs = maps\operahouse_util::spawn_guys( "ai_e4_roof_wave", true, "e4_ai", "thug_red" );

	flag_set( "obj_leave_docks" );

	
	flag_wait( "obj_stage_iris" );


	level thread e4_stage_dialog();

	trig = GetEnt( "trig_balance_beam", "targetname" );
	trig waittill( "trigger" );

	level thread maps\operahouse_util::tutorial_block("@OPERAHOUSE_TUT_BALANCE", 8 );
	level.player thread play_dialogue( "TANN_OperG_035A", true );	


	level thread e5_main();
}

event_3_to_2_magic_bullet()
{
	bullet_org = spawn( "script_origin", (2297, -569, 215));
	
	
	
	
	
	
	
	
	
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
		
		
		if(level.kill_random_shoot == true)
		{
			break;
		}
	}
}


e3_fade_control()
{
	
	
	wait(0.5);
	
	
	fade_out(0.5);
	setblur( 2.0, 0.05 );
	wait 1.9;
	setblur( 0.0, 5.0 );
	fade_in(1);	
	
	
	wait(1.1);
	PlayFX( level._effect["spark"], level.player.origin + (0,0,100));
	wait(0.5);
	fade_out(0.5);

	
	




	
	wait (0.8);
	
	
	
	wait (2.8);
	fade_in(6);
	
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + ( 0, 0,100));
	wait( 2.5 );
	PlayFX( level._effect["opera_stage_sparks_r"], level.player.origin + (0,0,100));
	fade_out(0.5);
	wait (0.8);
	
	wait (0.8);
	fade_in(6);
	wait (1.1);
	bc_org = spawn( "script_origin", (5159, -95, 278));
	
	wait(0.8);
	bc_org playsound("stage_bc_02");
	wait (1);
	
	bc_org playsound("stage_bc_03");
	wait(1.2);
	
	bc_org playsound("stage_bc_04");
	wait(1);
	
	
}



fade_out(t)
{
	level.hudBlack fadeOverTime(t);		
	level.hudBlack.alpha = 1;
}

fade_in(t)
{
	level.hudBlack fadeOverTime(t);		
	level.hudBlack.alpha = 0;
}



e4_stage_dialog()
{
	line = "";
	switch ( RandomInt(2) )
	{
	case 0:
		line = "OSM1_OperG_032A";	
		break;
	default:
		line = "OSM2_OperG_033A";	
	}
	
	
	bc_org_2 = spawn( "script_origin", (5159, -95, 278));
	bc_org_2 playsound(line);
	wait( 1.0 );

	
}





physics_pulse( source )
{
	level endon("scene_anim_done" );

	if ( !IsDefined( source ) )
	{
		source = level.player;
	}

	while (1)
	{
		
		physicsJolt( source.origin, 640, 1, (0.3, 0.0, 0.1) );
		wait(1.0);
	}
}




e5_main() 
{
	level notify( "e5_start" );

	
	boat_lookat = getent("spawn_boat","targetname");	
	boat_lookat trigger_off();



	

	gate = GetEnt( "sbm_e5_backstage_gate", "targetname" );
	gate MoveX( 184, 2 );

	
	flag_wait( "obj_backstage_roof" );
	
	level thread e5_ladder_control();
	level thread kill_player_if_drop();


	level thread maps\_autosave::autosave_by_name( "e5", 25.0 );	
	
	
	
	level thread jump_text();
	level thread fake_vo();
	wait(0.1);
	thugs = maps\operahouse_util::spawn_guys( "ai_e5_far_pier", true, "e5_ai", "thug_red" );
	array_thread( thugs, ::run_or_diw );

	
	trig = GetEnt( "trig_e5_boat", "targetname" );
	trig waittill( "trigger" );
	



 
	thugs = maps\operahouse_util::spawn_guys( "ai_e5_pier", true, "e5_ai", "thug_red" );
	thugs2 = maps\operahouse_util::spawn_guys( "ai_e5_towers", true, "e5_ai", "thug_red" );
	array_thread( thugs2, ::run_or_diw );
	array_thread( thugs, maps\operahouse_util::tether_on_goal, 128 );
	level thread ai_accuracy_e5();
	
	level thread e5_cars_escaping_pullup(); 
	wait( 9.3 );
	boat_lookat trigger_on();
	wait( 0.1 );
	GetEnt("spawn_boat", "targetname") waittill("trigger");
	level.patrol_boat thread e5_boat_intro();
	
	
	
	thread maps\operahouse_snd::play_boat_crash();

	
	flag_wait("obj_escaped");

	level notify( "time_limit_stop" );







	so = GetEnt( "big_bang", "targetname" );
	fx = playfx (level._effect["bigbang"], so.origin);
	level.player EnableInvulnerability();
	radiusdamage( so.origin+(0,0,500), 500, 500, 500 );
	physicsExplosionSphere( so.origin, 500, 400, 8 );
	earthquake( 1.0, 1, so.origin, 2000 );





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
	
	
	level thread maps\operahouse_snd::start_dvorak();
	
	ladder1 trigger_on();
	ladder2 trigger_on();
}


fake_vo()
{
				
				fake = spawn( "script_origin", (5529, 886, 12));
				wait(1.5);
				fake playsound ("SAM_E_1_CvFr_Cmb" );
				wait(1.5);
				fake playsound ("SAM_E_2_CvFr_Cmb" );
				wait(1.3);
				fake playsound ("SAM_E_3_CvFr_Cmb" );
				wait(1.4);
				fake playsound ("SAM_E_1_McLS_Cmb" );
				wait(1.4);
				fake playsound ("SAM_E_1_McGS_Cmb" );
				wait(1.1);
				fake playsound ("SAM_E_3_PinD_Cmb" );
				wait(2.3);
				fake playsound ("SAM_E_1_FrRs_Cmb" );
				wait(1);
				fake delete();
	
}





e5_explosion_allow_player_down()
{
	
	
	
	
	blocker1 = getent("e5_ladder_blocker1","targetname"); 
	blocker2 = getent("e5_ladder_blocker2","targetname"); 
	
	earthquake( 1.0, 1, level.player.origin, 2000 );
	wait( 0.3 );
	
	



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



escape_jl()
{
	explode2_swap1 = GetEnt( "bridge_exploder02_good", "targetname" );
	explode2_swap1b = GetEnt( "bridge_exploder02_bad", "targetname" );
	explode7_swap1 = GetEnt( "bridge_exploder01_good", "targetname" );
	explode7_swap1b = GetEnt( "bridge_exploder01_bad", "targetname" );
	
	explode2_swap1b hide();
	
	explode7_swap1b hide();
	
	
	dmg_explode1 = GetEnt( "dmg_explode1", "targetname" );
	dmg_explode2 = GetEnt( "dmg_explode2", "targetname" );
	dmg_explode3 = GetEnt( "dmg_explode3", "targetname" );
	dmg_explode4 = GetEnt( "dmg_explode4", "targetname" );
	
	dmg_explode1 trigger_off();
	dmg_explode2 trigger_off();
	dmg_explode3 trigger_off();
	dmg_explode4 trigger_off();

	flag_wait( "obj_backstage_roof" );

	
	
	
	
	
	
	
	
			
			
						
						
						
	
	
	

	explode1 = GetEnt( "explode1", "targetname" );	
	GetEnt("trig_e5_pier", "targetname") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode1.origin);
	radiusdamage( explode1.origin+(0,0, 0), 500, 4, 4 );
	radiusdamage( explode1.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode1.origin, 500, 400, 8 );
	earthquake( 0.7, 0.3, explode1.origin, 2000 );
	

	fx = playfx (level._effect["opera_large_fire"], explode1.origin + (60,90,-20));
	dmg_explode1 trigger_on();
	
	dmg_explode1 playsound("Fireball_Explosion");
	
	
	
	
	explode2 = GetEnt( "explode2", "targetname" );
	GetEnt("explode2", "script_noteworthy") waittill("trigger");
	
	level thread kill_last_guys_on_pier();

	fx2 = playfx (level._effect["bigbang"], explode2.origin);
	radiusdamage( explode2.origin+(0,0, 0), 75, 200, 200 );
	physicsExplosionSphere( explode2.origin, 500, 400, 8 );
	
	explode2 playsound("Fireball_Explosion");

	earthquake( 1.6, 0.3, explode2.origin, 2000 );
	dmg_explode3 trigger_on();
	
	dmg_explode3 playsound("Fireball_Explosion");

	explode2_swap1 hide();
	explode2_swap1b show();
	
	
	
	
	
	
	explode3 = GetEnt( "explode3", "targetname" );
	explode4 = GetEnt( "explode4", "targetname" );
	GetEnt("explode3_4", "script_noteworthy") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode3.origin);
	radiusdamage( explode3.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode3.origin, 500, 400, 8 );
	
	explode3 playsound("Fireball_Explosion");

	earthquake( 1.6, 0.3, explode3.origin, 2000 );


	
	



	radiusdamage( explode4.origin+(0,0, 0), 100, 200, 200 );
	physicsExplosionSphere( explode4.origin, 500, 400, 8 );
	
	explode4 playsound("Fireball_Explosion");

	earthquake( 1.3, 0.5, explode4.origin, 2000 );


	
	explode5 = GetEnt( "explode5", "targetname" );
	GetEnt("explode5", "script_noteworthy") waittill("trigger");
	fx = playfx (level._effect["bigbang"], explode5.origin);
	radiusdamage( explode5.origin+(0,0, 0), 220, 200, 200 );
	physicsExplosionSphere( explode5.origin, 500, 400, 8 );
	
	explode5 playsound("Fireball_Explosion");

	earthquake( 1, 1, explode5.origin, 2000 );
	fx = playfx (level._effect["opera_large_fire"], explode5.origin + (90,90,-20));

	
	
	
	explode6 = GetEnt( "explode6", "targetname" ); 
	explode6b = GetEnt( "explode6", "targetname" ); 
	GetEnt("explode6", "script_noteworthy") waittill("trigger");
	
	


	





	

	fx = playfx (level._effect["bigbang"], explode6.origin);
	fx = playfx (level._effect["opera_large_fire"], explode6b.origin + ( 0, 0,-51));
	radiusdamage( explode6.origin+(0,0,10), 75, 200, 200 );
	physicsExplosionSphere( explode6.origin, 60, 10, 2 );
	
	explode6 playsound("Fireball_Explosion");

	earthquake( 1.8, 0.2, explode6.origin, 2000 );

	





	
	wait( 0.2 );
	
	explode7_swap1 delete();
	explode7_swap1b show();
	



		

	physicsExplosionSphere( explode6b.origin, 500, 400, 8 );
	earthquake( 0.9, 0.2, explode6b.origin, 2000 );	
	
	explode6b playsound("Fireball_Explosion");
	
	
	GetEnt("explode7", "script_noteworthy") waittill("trigger");






	explode7 = GetEnt( "explode7", "targetname" );
	physicsExplosionSphere( explode7.origin, 200, 100, 1 );
	
	explode7 playsound("Fireball_Explosion");
	
	earthquake( 2.3, 0.2, explode7.origin, 2000 );
	
	level.player shellshock("default", 3.3);
	
	
}


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
	level.player dodamAge(1000, (0,0,1));	
}

jump_text()
{
	GetEnt("jump_hint", "targetname") waittill("trigger");
	
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message( "OPERAHOUSE_WII_TUTORIAL_JUMP" );
	}
	else
	{
		tutorial_message( "OPERAHOUSE_WII_TUTORIAL_JUMP_ZAPPER" );
	}
	
	
	wait(1.3);
	tutorial_message( "" );
}


jl_timer_new()
{
		level thread timer_start(45);
}


e5_cars_escaping_pullup()
{

	
	e5_car1 = getent( "e5_car1", "targetname" );
	e5_car1 thread setup_car_driver();
	vnode_start1 = getvehiclenode( "e5_car1_path1", "targetname" );
	
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_l_front" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_headlight02"], "tag_light_r_front" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_l_back" );
	e5_car1 thread maps\_vehicle::bond_veh_lights( level._effect["vehicle_night_taillight"], "tag_light_r_back" );
	
	e5_car1 attachpath( vnode_start1 );
	e5_car1 startpath( vnode_start1 );
	
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
	
	
	GetEnt("explode7", "script_noteworthy") waittill("trigger");
	
	
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
	
	
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	passenger useAnimTree(#animtree);
	passenger setFlaggedAnimKnobRestart("idle", %vehicle_passenger);
	
	
	self waittill("reached_end_node");
	driver delete();
	passenger delete();
}	






e5_boat_intro()
{






	
	goal_spot = GetEnt( "so_e5_boat_path", "targetname" );
	level.patrol_boat Hide();
	level.patrol_boat.origin = goal_spot.origin;
	level.patrol_boat.angles = goal_spot.angles;
	wait(0.05);

	level.patrol_boat Show();
	
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		
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

	
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "dock_impact_1" );
	earthquake( 0.15, 0.5, level.patrol_boat.origin, 2000 );

	
	earthquake( 0.3, 1.0, level.patrol_boat.origin, 2000 );
	so_crash = GetEnt( "so_platform_crash1", "targetname" );
	jolt_force = AnglesToForward( so_crash.angles ) * 100;

	radiusdamage(so_crash.origin, 168, 5, 5, level.player, "MOD_FORCE_EXPLOSION" );

	
	so_push_light = GetEnt( "so_e5_ignite_light", "targetname" );
	jolt_force = AnglesToForward( (0.0, 45.0, 0.0) ) * 100;
	physicsJolt( so_push_light.origin, 10, 0, jolt_force );

	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "dock_impact_2" );

	
	earthquake( 0.2, 1, level.patrol_boat.origin, 2000 );


	
	platform = GetEnt( "sbm_e5_platform", "targetname" );
	so_crash = GetEnt( "so_platform_crash2", "targetname" );
	platform RotateTo( so_crash.angles, 1.0 );
	jolt_force = AnglesToForward( (0.0, so_crash.angles[1], 0.0) ) * 10;	
	physicsJolt( so_crash.origin, so_crash.radius, 0, jolt_force );

	
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "spark_stop" );
	dialog_played = false;
	for ( i=0; i<level.patrol_sailors.size; i++ )
	{
		if ( IsAlive(level.patrol_sailors[i]) )
		{
			level.patrol_sailors[i] Unlink();

			if ( dialog_played == false )
			{
				
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

	
	level.patrol_boat waittillmatch( "a_fxanim_boat_crash", "end" );
	level.patrol_boat.origin = level.patrol_boat.start_origin;
	level.patrol_boat.angles = level.patrol_boat.start_angles;

	level thread e5_start_fire();

	flag_set( "obj_escape" );
	level thread maps\operahouse_util::time_limit_init(72);
	
	wait( 27 );
	level thread jl_timer_new(); 
	
	


	level thread maps\_autosave::autosave_now( "e5run");	
	level thread e5_explosion_allow_player_down();  
	level thread e5_big_bang(); 
	level notify("kill_e5_snipers");
}




e5_start_fire()
{
	fire_level = 1;
	while (1)
	{
		so = GetEntArray( "so_e5_fire"+fire_level, "targetname" );
		for ( i=0; i<so.size; i++ )
		{
			playfx( level._effect["opera_large_fire"], so[i].origin );
		}
		level waittill( "advance_fire" );

		fire_level++;
	}
}




run_or_diw()
{	

	self setperfectsense( true );
	level waittill("kill_e5_snipers");
	



			if (isalive(self))
			{		
				
				
					self dodamage(1000, (0,0,5));
					radiusdamage( self.origin+(0,0,50), 200, 500, 500 );
					wait( 0.5 + randomfloat( .7 ) );
				
			}

}


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


e5_big_bang_warning()
{
	level endon( "time_limit_stop" );
	level endon( "time_limit_expired" );



	
	
	time_left = int( level.timer_hud.time );
	while ( 1 )
	{
		switch( time_left )
		{
		case 75:
			level.player thread play_dialogue( "TANN_OperG_040A", true );	
			level notify( "advance_fire" );
			break;
		case 45:
			level.player thread play_dialogue( "TANN_OperG_041A", true  );	
			level notify( "advance_fire" );
			break;
		case 30:
			level.player thread play_dialogue( "TANN_OperG_042A", true  );	
			level notify( "advance_fire" );
			break;
		case 15:
			level.player thread play_dialogue( "TANN_OperG_043A", true  );	
			level notify( "advance_fire" );
			break;
		case 3:

			break;
		}
		wait( 1.0 );
		time_left = time_left - 1;
	}
}




e5_big_bang()
{
	so = GetEnt( "big_bang", "targetname" );

	thread e5_big_bang_warning(); 
	level waittill( "time_limit_expired" );






	

	radiusdamage( so.origin+(0,0,500), 00, 500, 500 );
	physicsExplosionSphere( so.origin, 3000, 2000, 8 );
	earthquake( 2.0, 1, level.player.origin, 2000 );

	player_stick();
	wait(0.4);

	MissionFailed();
	level.player shellshock( "flashbang", 5 ); 
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

}




lift_controller()
{
	level.lift_cage		= GetEnt( "scissorlift_cage", "targetname" );

	lift_cage_clip		= GetEnt( "scissorlift_cage_collision", "targetname" );
	lift_cage_clip		linkto( level.lift_cage );


	lift_control = GetEnt( "scissorlift_control", "targetname" );
	maps\_playerawareness::setupEntSingleUseOnly( 
		lift_control,					
		::use_lift,						
		"Raise scissor lift",			
		0,								
		"",								
		true,						   	
		false,							
		undefined,		   				
		level.awarenessMaterialNone,	
		true,							
		false,						   	
		false );					   	
}




use_lift( object )
{
	level.lift_cage MoveZ( 263, 10.0 );
	wait( 10.0 );
}




set_balcony_qk()
{
	if ( !IsDefined(self.new_qk_anim) )
	{
		self.new_qk_anim = true;
		self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");
	}
}




stage_controller()
{
	level.stage = spawnstruct();

	
	level.stage.eye				= GetEnt( "sbm_eye",				"targetname" );
	level.stage.eye_flat		= GetEnt( "sbm_eye_flat",			"targetname" );
	level.stage.eye_flat_clip	= GetEnt( "sbm_eye_clip",			"targetname" );
	level.stage.arm				= GetEnt( "sbm_arm",				"targetname" );
	level.stage.arm_base		= GetEnt( "sbm_arm_base",			"targetname" );
	level.stage.iris			= GetEnt( "sbm_iris",				"targetname" );

	level.stage.screen_l		= GetEnt( "sbm_stage_screen_left",	"targetname" );
	level.stage.screen_r		= GetEnt( "sbm_stage_screen_right", "targetname" );
	
	level.stage.cover_l			= GetEnt( "cover_stage_left",		"targetname" );
	level.stage.cover_r			= GetEnt( "cover_stage_right",		"targetname" );

	
	level.stage.fx_eye			= GetEnt( "fxanim_stage_fall",		"targetname" );
	level.stage.eye	LinkTo(level.stage.fx_eye, "stage_jnt" );

	level.stage.eye				maps\operahouse_util::save_orientation();
	level.stage.arm				maps\operahouse_util::save_orientation();
	level.stage.iris			maps\operahouse_util::save_orientation();

	level.stage.screen_l		maps\operahouse_util::save_orientation();
	level.stage.screen_r		maps\operahouse_util::save_orientation();
	
	level.stage.cover_l			maps\operahouse_util::save_orientation();
	level.stage.cover_r			maps\operahouse_util::save_orientation();



	
	attach_array = GetEntArray( "attach_eye", "targetname" );
	for ( i=0; i<attach_array.size; i++ )
	{
		attach_array[i] LinkTo( level.stage.eye );
	}

	
	
	
	
	level.stage.eye_flat_clip	LinkTo( level.stage.eye_flat );

	
	attach_array = GetEntArray( "attach_iris", "targetname" );
	for ( i=0; i<attach_array.size; i++ )
	{
		attach_array[i] LinkTo( level.stage.iris );
	}


	level.stage.iris		maps\operahouse_util::linkEx( level.stage.arm );
	level.stage.arm_base	maps\operahouse_util::linkEx( level.stage.arm );
	wait(0.1);

	
	

	level thread stage_screen_open( 0.1 );	
	level thread stage_cover_close( 0.1 );	
	
















}


stage_collapse( time )
{
	
	level.stage.screen_l	LinkTo(level.stage.fx_eye, "stage_jnt" );
	level.stage.screen_r	LinkTo(level.stage.fx_eye, "stage_jnt" );

	level notify( "stage_fall_1_start" );	

	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "stage_hits" );
	level.stage.arm		RotatePitch( -13, 5.0 );

	
	level.stage.fx_eye waittillmatch( "a_stage_fall_1", "end" );

	level.stage.arm		MoveX( -230, 5.0 );
	wait(5.0);

	




	level notify( "stage_fall_2_start" );	
	level.stage.fx_eye waittillmatch( "a_stage_fall_2", "stage_hits" );

	earthquake( 0.5, 2.0, level.player.origin, 100 );

	
	
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




stage_arm_in( time )
{
	level.stage.arm		MoveX( 230, time );
	level.stage.arm		RotatePitch( 13, time );

	wait( time );
}




stage_arm_out( time )
{
	level.stage.arm		RotatePitch( -13, time );
	level.stage.arm		MoveX( -230, time );

	wait( time );
}




stage_arm_up( time )
{
	
	if ( time < 0.5 )
	{
		level.stage.arm		MoveX( -330, time );
		level.stage.iris	RotatePitch( -50, time );

		level.stage.arm		RotatePitch( 30, time );
		return;
	}

	level.stage.arm		MoveX( -330, time );
	wait(4.0);
	level.stage.iris	RotatePitch( -45, time-4.0 );

	level.stage.arm		RotatePitch( 30, time-4.0 );
	wait( time-4.0 );
}




stage_arm_down( time )
{
	level.stage.arm		MoveTo( level.stage.arm.saved_origin,		time );
	level.stage.arm		RotateTo( level.stage.arm.saved_angles,		time-2.0 );
	level.stage.iris	RotateTo( level.stage.iris.saved_angles,	time-2.0 );

	wait( time-2.0 );
}




stage_iris_flat()
{
	level.stage.arm		MoveX( -600, 10 );
	wait(2);
	thread stage_screen_close( 8 );
	level.stage.arm		RotatePitch( -25, 12, 2.0, 2.0  );
	level.stage.iris	RotatePitch( 90, 12, 2.0, 2.0  );

	wait( 12 );
}




stage_iris_closed()
{
	

	thread stage_screen_open( 10 );
	level.stage.arm		RotatePitch( 25, 12, 2.0, 2.0 );
	level.stage.iris	RotatePitch( -90, 12, 2.0, 2.0 );

	wait(2);
	level.stage.arm		MoveX( 600, 10 );
	wait( 12 );
}




stage_screen_open( time )
{
	level.stage.screen_l	MoveY( -300, time );
	level.stage.screen_r	MoveY( 300, time );
	wait( time );
}




stage_screen_close( time )
{
	level.stage.screen_l	MoveY( 300, time );
	level.stage.screen_r	MoveY( -300, time );
}




stage_cover_open( time )
{
	level.stage.cover_l	MoveY( -200, time, 1.0, 1.0 );
	level.stage.cover_r	MoveY( 200, time, 1.0, 1.0 );
	wait( time );
}




stage_cover_close( time )
{
	level.stage.cover_l	MoveY( 200, time );
	level.stage.cover_r	MoveY( -200, time );
}





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
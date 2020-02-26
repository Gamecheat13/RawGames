#include maps\_utility;
#include maps\gettler_util;


init()
{
	
	level thread atrium();

	
	level thread intermission_a();

	
	level thread boat_yard();

	
	level thread gettler_intro();
	level thread ledge_pip();
}






atrium()
{
	
	trigger_wait( "trig_atrium_ground_floor", "script_noteworthy" );
	level thread atrium_rush(); 

	
	entaTemp = GetEntArray( "ai_atrium_upper", "script_noteworthy" );
	for( i = 0; i < entaTemp.size ; i++ )
	{
		entaTemp[i] Delete();
	}

	
	
	
	
	

	
	waittill_aigroupcleared( "atrium_ground_floor" );
	

	maps\_autosave::autosave_by_name("gettler");

	
	aiGateGuard = GetEnt( "ai_atrium_gate_guard_spawner", "targetname" ) StalingradSpawn( "ai_atrium_gate_guard" );

	
	if( !spawn_failed( aiGateGuard ) )
	{
		aiGateGuard SetDeathEnable(false);
		aiGateGuard thread exit_atrium();
		aiGateGuard waittill( "goal" );
		aiGateGuard CmdFaceAngles( 90, 0 );
		aiGateGuard waittill( "cmd_done" );
		aiGateGuard CmdPlayAnim( "Thu_Alrt_Traversal_DoorOpen_ForeGrip", 0 );
	}

	
	
	wait( 0.75 );
	GetEnt( "ent_atrium_gate", "targetname" ) playsound( "GET_Fence_Open" );
	GetEnt( "ent_atrium_gate", "targetname" ) RotateTo( (0, 90, 0), 0.25 );

	aiGateGuard SetDeathEnable(true);
}


atrium_rush()
{
	level endon("atrium_ground_floor_cleared");

	while (true)
	{
		ai = GetAIArray("axis");
		if (ai.size <= 1)
		{
			for (i = 0; i < ai.size; i++)
			{
				ai[i] SetCombatRole("Rusher");
			}

			break;
		}

		wait .5;
	}
}

exit_atrium()
{
	
	self PlaySound( "GTMR_GettG_025A" );

	self waittill( "death" );
	
	GetEnt( "ent_atrium_gate", "targetname" ) RotateTo( (0, 90, 0), 0.25 );

	
	

	
	if( IsDefined( level.church_bell ) )
	{
		level.church_bell StopLoopSound();
	}
}






intermission_a()
{
	thread intermission_a_ambient();

	
	trigger_wait( "trig_intermission_a_gate" );
	trig = GetEntArray( "drone_civs", "targetname" );
	for( i = 0; i < trig.size; i++  )
	{
		trig[i] notify( "stop_drone_loop" );
	}
	level notify( "stop_gondolas" );
	GetEnt( "ent_intermission_gate_left", "targetname" ) playsound( "GET_Fence_Close" );
	GetEnt( "ent_intermission_gate_left", "targetname" ) RotateTo( (0, 90, 0), 0.25 );
	GetEnt( "ent_intermission_gate_right", "targetname" ) RotateTo( (0, 270, 0), 0.25 );

	
	

	
	
	
	
	
	
	
	
	
}

intermission_a_ambient()
{
	
	trigger_wait( "trig_intermission_a", "script_noteworthy" );

	
	level.player thread intermission_a_vo();

	
	array_thread(GetEntArray("ai_civ_intermission_a_spawner", "targetname"), ::civ_intermission_anim);
	GetVehicleNode("nod_motor_boat_path", "targetname") thread maps\gettler_load::motor_boat_loop();
}

intermission_a_vo()
{
	level.player play_dialogue("TANN_GettG_028A", true);
	level.player play_dialogue("BOND_GettG_029A");
}

civ_intermission_anim()
{
	
	aiCiv = self StalingradSpawn( "ai_civ_intermission_a" );

	aiCiv endon("death");
	aiCiv waittill( "goal" );
	wait( 2 );

	
	aiCiv thread civ_intermission_vo();

	
	while( IsDefined( aiCiv ) )
	{
		aiCiv CmdPlayAnim( aiCiv.script_noteworthy, 0 );
		aiCiv waittill( "cmd_done" );
	}
}

civ_intermission_vo()
{
	
	if( self.script_noteworthy == "Gen_Civs_CellPhoneTalk" )
		self thread civ_cellphone();

	self.vo_exhausted = false;
	while( IsDefined( self ) && !self.vo_exhausted )
	{
		if( Distance( level.player.origin, self.origin ) > 128 )
		{
			wait( 0.15 );
			continue;
		}

		switch(self.script_noteworthy)
		{
			case "Gen_Civs_StandConversation_Female":
				self maps\gettler_load::vo_two_female(self);
				break;

			case "Gen_Civs_CellPhoneTalk":
				self maps\gettler_load::vo_phone_male(self);
				break;

			case "Gen_Civs_CellPhoneTalk_Female":
				self maps\gettler_load::vo_phone_female(self);
				break;

			case "Gen_Civs_StandConversation_V2_Female":
				return;
		}
		wait( 0.15 );
	}
}

civ_cellphone()
{
	wait 1;

	if (IsDefined(self))
	{
		self Attach("w_t_bond_phone", "TAG_WEAPON_LEFT");
	}

	
	
	
	
	
	
	
	
	
}





boat_yard()
{
	
	GetEnt("script_constraint", "script_noteworthy") thread gondola_drop();

	
	trigger_wait( "trig_boatyard_vo" );
	
	
	

	
	trigger_wait( "trig_boat_yard_vesper_escape" );

	trig = GetEntArray( "drone_civs", "targetname" );
	for( i = 0; i < trig.size; i++  )
	{
		trig[i] notify( "stop_drone_loop" );
	}

	level thread play_boat_scene();
	

	
	trigger_wait( "trig_boat_yard_wave_b", "script_noteworthy" );
	GetEnt( "ent_door_1st_floor_boat_yard", "targetname" ) RotateTo( (0, 135, 0), 0.25 );
	GetEnt( "ent_shutter_boat_yard_left", "targetname" ) RotateTo( (0, 230, 0), 0.25 );
	GetEnt( "ent_shutter_boat_yard_right", "targetname" ) RotateTo( (0, 135, 0), 0.25 );	
	GetEnt( "ent_shutter_boat_yard_left", "targetname" ) PlaySound( "GET_Wood_Door" );
	GetEnt( "ent_shutter_boat_yard_right", "targetname" ) PlaySound( "BGM1_GettG_054A" );
}

play_boat_scene()
{
	boat = GetEnt( "veh_boat_vesper_escape", "targetname" );

	level.escape_boat_thug = Spawn("script_model", (0, 0, 0));
	level.escape_boat_thug character\character_thug_1_venice::main();
	level.escape_boat_thug.targetname = "boatdriver";

	level.escape_boat_vesper = Spawn("script_model", (0, 0, 0));
	level.escape_boat_vesper character\character_vesper_venice::main();
	level.escape_boat_vesper.targetname = "vesper";
	level.escape_boat_vesper Attach("p_msc_suitcase_vesper", "TAG_WEAPON_RIGHT");

	PlayCutScene("Gettler_BoatScene", "Gettler_BoatScene_Done");

	wait 2;
	level.escape_boat_thug PlaySound( "GOM1_GettG_044A" );	

	level.escape_boat_vesper Attach("v_boat_motor_b", "TAG_WEAPON_LEFT");
	boat Hide();

	wait 4;
	boat PlaySound( "GET_MotorBoat_Start" );
	
	level thread play_wake_fx(boat);

	level waittill("Gettler_BoatScene_Done");
	move_escape_boat_to_end_node();

	flag_set("vesper_boat_escape");
}

play_wake_fx(boat)
{
	level endon("Gettler_BoatScene_Done");

	wake = Spawn("script_model", boat GetTagOrigin("tag_wake") + (0, -100, 0));
	wake SetModel("tag_origin");
	wake.angles = boat GetTagAngles("tag_wake");
	wake LinkTo(level.escape_boat_vesper);

	while (true)
	{
		PlayfxOnTag(level._effect["motor_boat"], wake, "tag_origin");
		wait .2;
	}
}

guard_dialog()
{
	if (!IsDefined(self.boat_yard_guard_did_dialog))
	{
		self PlaySound("GMR3_GettG_043A");		
	}

	self.boat_yard_guard_did_dialog = true;
}



















release_gondoloa()
{
	
	entGondola = GetEnt( "veh_gondola_bridge", "targetname" );
	vnodPath = GetVehicleNode( "vnod_gondola_bridge", "targetname" );
	entGondola AttachPath( vnodPath );

	
	level waittill( "gondola_fall_start" );
	wait( 1 );

	
	entGondola StartPath();
	entGondola thread maps\gettler_load::boat_float();

	
	
	
	

	
	
	
}

gondola_drop()
{
	clip = GetEnt("gondola_mousetrap_clip", "targetname");
	clip ConnectPaths();
	clip trigger_off();

	flag_wait("vesper_boat_escape");
	self waittill("trigger");

	flag_set("gondola_drop");

	
	level notify( "gondola_fall_start" );

	
	entOrigin = Spawn( "script_origin", (2942, -828, 163.3) );
	entOrigin2 = Spawn( "script_origin", (2942, -828, 163.3) );

	
	wait 1.3;
	RadiusDamage((2960, -528, 160), 200, 150, 80);
	
	RadiusDamage((2960, -720, 160), 200, 150, 80);
	
	RadiusDamage((2952, -856, 160), 200, 150, 80);
	

	clip trigger_on();
	clip DisConnectPaths();

	
	entOrigin playsound( "GET_Gondola_Crash" );
	entOrigin2 playsound( "BMR1_GettG_053A" );
	wait( 4 );
	entOrigin Delete();
	entOrigin2 Delete();
}






gettler_intro()
{
	
	trigger_wait("gettler_start");

	
	level thread ledge_main_crop();
	level thread ledge_main_move();





















}


ledge_main_crop()
{
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 4);		
	
	
	
	level.player animatepip( 1000, 1, -1, -1, 1, 0.5, 0, 0);
	wait(1);

	level notify( "window_crop" );
		
	
	level waittill( "window_up" );

	
	
	level.player animatepip( 1000, 1, -1, -1, 1, 1, 0, 0);
	wait(1);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	

}


ledge_main_move()
{
	
	level waittill( "window_crop" );
			
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);	
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



ledge_pip()
{

	level waittill( "window_down" );
	
	level.player setsecuritycameraparams( 65, 3/4 );	
	wait(0.01);
	
	
	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					
	

	
	cameraID_gettler = level.player securityCustomCamera_Push("world", (2561, -2922, 188), (0, 269.4, 0.01), 0.0);

	
	SetDVar("r_pipSecondaryMode", 5);						

	
	
	level.player animatepip( 500, 0, 0.25, -1 );
	wait(0.5);	
	
	
	trig = getent( "trig_ledge_stop", "targetname" );
	trig waittill( "trigger" );
	










	
	
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_ledge" );
	
	
	SetDVar("r_pipSecondaryMode", 0);
	level.player securityCustomCamera_Pop( cameraID_gettler );	
						
}






gettler_building()
{
	level thread destroy_wall();
}

destroy_wall()
{
	trigger_wait( "trig_gettler_destroy_wall", "script_noteworthy" );

	level.player RadiusDamage( (2736, -3808, 472), 256, 300, 200 );
}
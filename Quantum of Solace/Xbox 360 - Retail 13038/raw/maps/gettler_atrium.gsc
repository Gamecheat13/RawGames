#include maps\_utility;
#include maps\gettler_util;


init()
{
	// atrium fight
	level thread atrium();

	// intermission a
	level thread intermission_a();

	// boat yard
	level thread boat_yard();

	// gettler building
	level thread gettler_intro();
	level thread ledge_pip();
}


///////////////////////////////////////////////////////////////////
// Atrium
///////////////////////////////////////////////////////////////////

atrium()
{
	// wait for bond to hit trigger
	trigger_wait( "trig_atrium_ground_floor", "script_noteworthy" );
	level thread atrium_rush(); // last guys rush player

	// Remove upstairs guards
	//entaTemp = GetEntArray( "ai_atrium_upper", "script_noteworthy" );
	//for( i = 0; i < entaTemp.size ; i++ )
	//{
	//	entaTemp[i] Delete();
	//}

	// Close Gate to upstairs
	//GetEnt( "ent_atrium_lower_door_left", "targetname" ) playsound( "GET_Fence_Close" );
	//GetEnt( "ent_atrium_lower_door_left", "targetname" ) RotateTo( (0, 270, 0), 0.25 );
	//GetEnt( "ent_atrium_lower_door_right", "targetname" ) RotateTo( (0, 90, 0), 0.25 );
	//wait( 3 );

	// wait for atrium guys to be cleared
	waittill_aigroupcleared( "pillar_guards" );
	waittill_aigroupcleared( "pillar_guards_backup" );
	waittill_aigroupcleared( "atrium_ground_floor" );

	flag_clear("enable_battle_chatter");

	// spawn last guy to open gate
	aiGateGuard = GetEnt( "ai_atrium_gate_guard_spawner", "targetname" ) StalingradSpawn( "ai_atrium_gate_guard" );

	// play anim
	if( !spawn_failed( aiGateGuard ) )
	{
		aiGateGuard SetQuickKillEnable(false);
		aiGateGuard SetEnableSense(false);
		aiGateGuard.health = 999999;

		aiGateGuard thread exit_atrium();
		aiGateGuard waittill( "goal" );
		aiGateGuard CmdFaceAngles( 90, 0 );
		aiGateGuard waittill( "cmd_done" );
		aiGateGuard CmdPlayAnim( "Thu_Alrt_Traversal_DoorOpen_ForeGrip", 0 );

		wait( 0.75 );
		gate = GetEnt( "ent_atrium_gate", "targetname" );
		gate ConnectPaths();
		gate playsound( "GET_Fence_Open" );
		gate RotateTo( (0, 90, 0), 0.25 );

		aiGateGuard.health = 100;
		aiGateGuard CmdShootAtEntity(level.player, false, -1);	// just shoot at the player until you die

		aiGateGuard waittill("death");
	}
	else
	{
		// open gate if failed to spawn
		gate = GetEnt( "ent_atrium_gate", "targetname" );
		gate ConnectPaths();
		gate playsound( "GET_Fence_Open" );
		gate RotateTo( (0, 90, 0), 0.25 );
	}

	GetEnt("atrium_player_clip", "targetname") delete();
	flag_set("enable_battle_chatter");

	maps\_autosave::autosave_by_name("gettler");
}

// rush the player when guys get down to a minimum - fixes problem with findind turrets/guardians that aren't dead yet
atrium_rush()
{
	level endon("weapons_holstered");

	while (true)
	{
		ai = GetAIArray("axis");
		if (ai.size <= 2)
		{
			for (i = 0; i < ai.size; i++)
			{
				if (!IsDefined(ai[i].script_noteworthy) || (ai[i].script_noteworthy != "ai_atrium_gate_guard"))
				{
					ai[i] SetCombatRole("Rusher");
				}
			}

			// wait for all the rushers to die and then do it all over again because we might have spawned more guys
			for (i = 0; i < ai.size; i++)
			{
				if (!IsDefined(ai[i].script_noteworthy) || (ai[i].script_noteworthy != "ai_atrium_gate_guard"))
				{
					if (IsDefined(ai[i]) && IsAlive(ai[i]))
					{
						ai[i] waittill("death");
					}
				}
			}

			wait 3;	// wait after all the rushers died
		}

		wait .5;
	}
}

exit_atrium()
{
	// vo
	self PlaySound( "GTMR_GettG_025A" );

	self waittill( "death" );
	//GetEnt( "ent_atrium_exit_block", "targetname" ) trigger_off();
	GetEnt( "ent_atrium_gate", "targetname" ) RotateTo( (0, 90, 0), 0.25 );

	// bond & tanner vo
	//level.player thread intermission_a_vo();

	// stop church bell
	if( IsDefined( level.church_bell ) )
	{
		level.church_bell StopLoopSound();
	}
}


///////////////////////////////////////////////////////////////////
// Intermission A
///////////////////////////////////////////////////////////////////

intermission_a()
{
	thread intermission_a_ambient();

	// wait for trig to gate off Bond and stop drones
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

	level notify("objective_find_a_way");

	level.player waittill("beam");	// started beam

	// make vesper run so player can't catch up to her //
	if (IsDefined(level.vesper))
	{
		level.vesper SetScriptSpeed("Run");
	}

	// add vesper
	//trigger_wait( "trig_intermission_vesper" );

	//level.vesper = GetEnt( "vepser_spawner_intermission", "targetname" ) StalingradSpawn( "vesper" );
	//if (!spawn_failed(level.vesper))
	//{
	//	level.vesper thread maps\gettler_util::attach_suit_case();
	//	node = GetNode("nod_chase_intermission_vesper", "targetname");
	//	level.vesper maps\_chase::start_chase_route(node);
	//	wait( 0.5 );
	//	level.vesper PlaySound( "VESP_GettG_042A" );
	//}
}

intermission_a_ambient()
{
	// wait for bond to hit trigger
	trigger_wait( "trig_intermission_a", "script_noteworthy" );
	unholster_trig = GetEnt("atrium_exit_unholster_trigger", "script_noteworthy");
	if (IsDefined(unholster_trig))
	{
		unholster_trig delete();
	}

	// bond & tanner vo
	level.player thread intermission_a_vo();

	// spawn civs & boat
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
	// spawn civ and wait for it to reach goal
	aiCiv = self StalingradSpawn( "ai_civ_intermission_a" );

	aiCiv endon("death");
	aiCiv waittill( "goal" );
	wait( 2 );

	// vo
	aiCiv thread civ_intermission_vo();

	// loop animations
	while( IsDefined( aiCiv ) )
	{
		aiCiv CmdPlayAnim( aiCiv.script_noteworthy, 0 );
		aiCiv waittill( "cmd_done" );
	}
}

civ_intermission_vo()
{
	// give cellphone to ai if needed
	if( (self.script_noteworthy == "Gen_Civs_CellPhoneTalk") || (self.script_noteworthy == "Gen_Civs_CellPhoneTalk_Female"))
		self thread civ_cellphone();

	self.vo_exhausted = false;
	while( IsDefined( self ) && !self.vo_exhausted )
	{
		if( Distance( level.player.origin, self.origin ) > 350 )
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
				//self maps\gettler_load::vo_phone_male(self);
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
	self.ok_to_talk = false;
	phone_attached = false;

	self waittill("cmd_started");

	while( IsDefined(self) )
	{
		wait .25;	// we need this so the tag can start animating before we attach the phone

		if (!phone_attached)
		{
			self Attach("w_t_bond_phone", "TAG_WEAPON_LEFT");
			phone_attached = true;
		}

		wait 4;
		self.ok_to_talk = true;
		self notify("talk");
		wait 30;
		self.ok_to_talk = false;
		wait 13.5;
	}
}

///////////////////////////////////////////////////////////////////
// Boat Yard
///////////////////////////////////////////////////////////////////

boat_yard()
{
	// thread gondola drop
	GetEnt("script_constraint", "script_noteworthy") thread gondola_drop();

	// vo
	trigger_wait( "trig_boatyard_vo" );
	//entOrigin = Spawn( "script_origin", (2942, -828, 163.3) );
	//wait( 0.05 );
	//entOrigin PlaySound( "GOM1_GettG_044A" );
	


	// wait for trig and force cowbell if it hasn't happened yet
	trigger_wait( "trig_boat_yard_vesper_escape" );

	trig = GetEntArray( "drone_civs", "targetname" );
	for( i = 0; i < trig.size; i++  )
	{
		trig[i] notify( "stop_drone_loop" );
	}

	level thread play_boat_scene();
	//level thread release_gondoloa();	// this does the bridge

	// wait for trig of 2nd wave to open shutters and door
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

	level.escape_boat_vesper SetCanDamage(true);
	level.escape_boat_vesper thread fail_mission_on_ai_death();
	PlayCutScene("Gettler_BoatScene", "Gettler_BoatScene_Done", true);

	//wait .05;	// wait for animation to start
	//shelter = GetEnt("vesper_shelter", "script_noteworthy");
	//shelter show_label("shelter");
 	//shelter MoveTo(level.escape_boat_vesper.origin, 0.05);
 	//shelter LinkTo(level.escape_boat_vesper);

	wait 2;
	level.escape_boat_thug PlaySound( "GOM1_GettG_044A" );	// Boat Driver - "Gettler is waiting."

	level.escape_boat_vesper Attach("v_boat_motor_b", "TAG_WEAPON_LEFT");
	boat Hide();

	wait 4;
	boat PlaySound( "GET_MotorBoat_Start" );
	
	level thread play_wake_fx(boat);

	flag_set("vesper_boat_escape");

	level waittill("Gettler_BoatScene_Done");
	move_escape_boat_to_end_node();

	//shelter delete();

	//flag_set("vesper_boat_escape");

	GetEnt("boat_yard_player_clip", "targetname") delete();
}

play_wake_fx(boat)
{
	level endon("Gettler_BoatScene_Done");

 	wake = Spawn("script_model", boat GetTagOrigin("tag_wake") + (0, 160, 0));
	//wake = Spawn("script_model", boat GetTagOrigin("tag_wake"));
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
		self PlaySound("GMR3_GettG_043A");		// guard - "Bond's still alive, we gotta stop him here."
	}

	self.boat_yard_guard_did_dialog = true;
}

//force_cowbell()
//{
//	level endon( "gondola_fall_start" );
//
//	// wait for trig and force cowbell if it hasn't happened yet
//	trigger_wait( "trig_boat_yard_cowbell", "script_noteworthy" );
//
//	// spawn last guy to activate cowbell
//	aiGateGuard = GetEnt( "ai_boat_yard_a_cowbell_spawner", "targetname" ) StalingradSpawn( "ai_boat_yard_a_cowbell" );
//
//	// command to shoot gondola
//	if( !spawn_failed( aiGateGuard ) )
//	{
//		aiGateGuard waittill( "goal" );
//		aiGateGuard CmdShootAtPos( (2966, -790, 330), false, 2 );
//	}
//}

release_gondoloa()
{
	// get gondola and path
	entGondola = GetEnt( "veh_gondola_bridge", "targetname" );
	vnodPath = GetVehicleNode( "vnod_gondola_bridge", "targetname" );
	entGondola AttachPath( vnodPath );

	// wait for gondola anim then release it
	level waittill( "gondola_fall_start" );
	wait( 1 );

	// start gondola bridge
	entGondola StartPath();
	entGondola thread maps\gettler_load::boat_float();

	//// set wait node
	//entGondola SetWaitNode( GetVehicleNode( "vnod_gondola_bridge_a", "targetname" ) );
	//entGondola waittill( "reached_wait_node" );
	//entGondola SetSpeed( 0, 5, 5 );

	//// wait for trig and move boat
	//trigger_wait( "trig_far_side_of_the_yard", "script_noteworthy" );
	//entGondola SetSpeed( 10, 2 );
}

gondola_drop()
{
	gondola = GetEnt("fxanim_gondola_fall", "targetname");

	glowy_gondola = GetEnt("glowy_gondola", "targetname");
	if (IsDefined(glowy_gondola))
	{
		glowy_gondola thread gondola_glow(self, gondola);
	}

	clip = GetEnt("gondola_mousetrap_clip", "targetname");
	clip ConnectPaths();
	clip trigger_off();

	flag_wait("vesper_boat_escape");

	ent = undefined;
	while (!IsPlayer(ent))
	{
		self waittill("trigger", ent);
	}

	flag_set("gondola_drop");

	// notify to start fx
	level notify( "gondola_fall_start" );

	// sound fx
	entOrigin = Spawn( "script_origin", (2942, -828, 163.3) );
	entOrigin2 = Spawn( "script_origin", (2942, -828, 163.3) );

	// wait a sec and do radius damage in effect areas
	wait 1.3;
	RadiusDamage((2960, -528, 160), 200, 150, 80);
	//PhysicsExplosionSphere((2960, -528, 160), 1, 128, 2);
	RadiusDamage((2960, -720, 160), 200, 150, 80);
	//PhysicsExplosionSphere((2960, -720, 160), 300, 128, 2);
	RadiusDamage((2952, -856, 160), 200, 150, 80);
	//PhysicsExplosionSphere((2952, -856, 160), 300, 128, 2);

	clip trigger_on();

	if (level.player IsTouching(clip))
	{
		level.player DoDamage(level.player.health << 2, level.player.origin);
	}

	clip DisConnectPaths();

	// sound
	entOrigin playsound( "GET_Gondola_Crash" );
	entOrigin2 playsound( "BMR1_GettG_053A" );
	wait( 4 );
	entOrigin Delete();
	entOrigin2 Delete();
}

gondola_glow(trig, gondola)
{
	self Show();
	gondola Hide();

	flag_wait("gondola_drop");

	gondola Show();
	self delete();
}


///////////////////////////////////////////////////////////////////
// Gettler Building
///////////////////////////////////////////////////////////////////

gettler_intro()
{
	// wait for trigger to start gettler section //
	trigger_wait("gettler_start");

	//crop and move down
	level thread ledge_main_crop();
	level thread ledge_main_move();

//	// do picture in picture
//	wait .1;
//	setdvar("cg_pipsecondary_border", 2);
//	setdvar("cg_pipsecondary_border_color", "0.0 0.0 0.0 1");
//	SetDVar("r_pipSecondaryX", 0.05);
//	SetDVar("r_pipSecondaryY", 0.15);						// place top left corner of display safe zone
//	SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
//	SetDVar("r_pipSecondaryScale", "0.00 0.00 1.0 1.0");	// scale image, without cropping
//	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
//	SetDVar("r_pipSecondaryMode", 5);
//	level.player setsecuritycameraparams(55, 3/4);
//	// set growing pip
//	level.player animatepip(1500, 0, 0.05, 0.15, 0.5, 0.5, 1, 1);
//
//	wait 0.05;
//	level.player SecurityCustomCamera_Push("world", (2561, -2922, 188), (0, 269.4, 0.01), 0.0);
//
//	wait 7 ;
//	SetDVar("r_pipSecondaryMode", 0);

}

ledge_main_crop()
{
	SetDvar("ui_hud_showstanceicon", "0"); 
	SetSavedDvar("ammocounterhide", "1");

	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 4);		// use top middle anchor point
	
	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 1000, 1, -1, -1, 1, 0.5, 0, 0);
	wait(1);

	level notify( "window_crop" );
		
	//level waittill( "off_ledge" );
	level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 1000, 1, -1, -1, 1, 1, 0, 0);
	wait(1);
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up

}

ledge_main_move()
{
	level waittill( "window_crop" );
			
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);	//match animate pip time - or this should wait unless threaded
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	//move back up
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}

ledge_pip()
{
	//set pos so it always comes in from left
	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 0.49 1.0 0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	//SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		

	level waittill( "window_down" );
			
	level.player setsecuritycameraparams( 65, 3/4 );	//this needs to be set first so it won't crash
	wait(0.05);

	//pip cam
	//cameraID_gettler = level.player securityCustomCamera_Push("world", (2561, -2922, 188), (0, 269.4, 0.01), 0.0);
	//cameraID_gettler = level.player securityCustomCamera_Push("external", "gettler", "gettler_vesper_meet");

	cameraID_gettler = level.player securityCustomCamera_Push("world", (2940, -3423, 312), (12.6, 123, 0), 0.0);
	level thread ledge_pip_change_camera(cameraID_gettler);

	//draw in front
	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
	
	//iprintlnbold("PIP_moving");
	//(time,screen,x,y,scalex, scaley, cropx, cropy)

	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");

	level.player animatepip( 500, 0, 0.25, -1 );
	//wait(0.5);	
	
	//use a trigger nr end of mantle
	trig = getent( "trig_ledge_stop", "targetname" );
	trig waittill( "trigger" );
	
//	while(1)
//	{
//		trig waittill( "trigger", guy );	//make sure it's not ai triggering
//		if( guy == level.player )
//		{
//			break;
//		}
//		wait( 0.05 );
//		
//	}
	
	//move pip offscreen fast and turn off
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_ledge" );
	
	//reset
	SetDVar("r_pipSecondaryMode", 0);
	level.player securityCustomCamera_Pop( cameraID_gettler );	//turn off

	SetDvar("ui_hud_showstanceicon", "1"); 
	SetSavedDvar("ammocounterhide", "0");
}

ledge_pip_change_camera(cam)
{
	cam_org = GetEnt("guard_cam_1", "targetname");

	GetEnt("ledge_after_the_jump", "targetname") waittill("trigger");
	level.player securityCustomCamera_change(cam, "world", cam_org.origin, cam_org.angles, 0.0);
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
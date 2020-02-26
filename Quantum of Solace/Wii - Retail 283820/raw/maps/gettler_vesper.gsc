#include maps\gettler_util;
#include maps\_utility;

main()
{
	if (level.script == "gettlertest")
	{
		return;
	}

	
	if( GetDVarInt( "skip_intro" ) != 1 )
	{
		level.player FreezeControls( true );		
		level thread intro_cinematic();
		level waittill( "scene_anim_done" );
		level.player FreezeControls( false );
	}

	level.vesper_cam = undefined;
	
	level.vesper = GetEnt("vesper_spawner", "targetname") StalingradSpawn("vesper");
	if (!spawn_failed(level.vesper))
	{
		level.vesper gun_remove();
		level.vesper thread maps\gettler_util::attach_suit_case();

		level.vesper maps\_chase::start_chase_route(GetNode("vesper_chase", "targetname"));
		level.vesper.chase_done = false;

		level.vesper SetScriptSpeed("Run");

		level.vesper.vesper_alerted = true;
		flag_set("vesper_alert");

		
		level notify("follow_vesper");
		

		
		

		level.vesper thread vesper_died();

		gate1();

		level.vesper waittill("chase_route_done");
		if( IsDefined( level.vesper ) )
		{
			level.vesper delete();
		}
	}
	else
	{
		assertmsg("vesper spawn failed");
	}
}


intro_cinematic()
{
	
	level thread fade_out_black( 3.0, false, true );
	wait( 0.05 ); 

	SetSavedDVar( "sf_compassmaplevel", "label1" );
	if( GetDVarInt( "skip_intro" ) != 1 )
	{
		
		level thread display_chyron();
		PlayCutScene( "Gettler_Intro", "scene_anim_done" );
		level.player PlaySound("GET_IntroCinematic_Foley");
		
		level thread letterbox_on( false, true, 2, false );
		level.player Attach("w_t_bond_phone", "TAG_WEAPON_RIGHT");	
		level waittill( "scene_anim_done" );
		GetVehicleNode("nod_motor_boat_path", "targetname") thread maps\gettler_load::motor_boat_loop();
		level.player Detach("w_t_bond_phone", "TAG_WEAPON_RIGHT");	

		level.player FreezeControls( true );
		wait 3;
		level thread letterbox_off( false );
		level.player FreezeControls( false );
		
	}
	else
	{
		level thread letterbox_on( false, true, 0.05, false );
		GetNode("nod_motor_boat_path", "targetname") thread maps\gettler_load::motor_boat_loop();
	}

	level.church_bell = Spawn( "script_origin", (2937, 3999, 140) );
	level.church_bell PlaySound( "GET_Large_Church_Bell" );
	
	
	level notify("playmusicpackage_ambient");
}

vesper_died()
{
	self waittill("death");
	if (IsDefined(self))
	{
		iPrintLnBold("Vesper Died!");
		
		missionFailedWrapper();
	}
}

vesper_alert()
{
	self endon("death");
	self endon("stop_alert");
	
	while (true)
	{
		if (self CanSeeThreat(level.player, "Notice") || self CanHearThreat(level.player, "Identify"))
		{	
			break;
		}

		wait .05;
	}
	
	level.vesper show_label("James... I'm so sorry.", "talk", 3); 
			 
	self.vesper_alerted = true;
	flag_set("vesper_alert");

	wait .05;

	self StopAllCmds();
	
	self SetScriptSpeed("Run");	
	self SetOverrideSpeed(14);	
}


gate1()
{
	
	
	
	level.vesper._chase_too_close_callback = undefined; 
	level.vesper notify("stop_alert");
	
	
}

spawn_run_aways()
{
	run_away_spawners = GetEntArray("run_away_spawner", "targetname");
	for (i = 0; i < run_away_spawners.size; i++)
	{
		guy = run_away_spawners[i] DoSpawn("run_away");
		if (!spawn_failed(guy))
		{
			guy show_label("civilian");
			
		}
	}
}

redlight_trigger()
{
	self waittill("trigger");
	level.vesper redlight();
}


redlight(node)
{
	level endon("vesper_alert");

	if (!self.vesper_alerted)
	{
		node start_vesper_cam((-1880.94, 1198.95, 265.39), (2.29, -15.50, 0.00));
		vesper_action("Listen");
		stop_vesper_cam();

		iPrintLnBold("^1Find Cover!");

		wait 3;
		
		vesper_action("LookBehind", true);

		
		iPrintLnBold("^2OK Go!");
	}
}

vesper_gotaway()
{
	
	
	
	
	
	
	
	return false;
}

vesper_chase_end(node)
{
	if( IsDefined( level.vesper ) )
	{
		level.vesper.chase_done = true;
	}

	if( IsDefined( self ) )
	{
		self Delete();
	}
}


vesper_action(action, end)
{
	level endon("vesper_alert");

	self show_label(action, "main", 3);	

	self StopAllCmds();
	self CmdAction(action);

	if ((action == "Scan") || (action == "Listen"))
	{
		wait 3;
	}
	else if ((action == "LookBehind"))
	{
		self waittill("Cmd_Done");
	}

	if (IsDefined(end) && end)
	{
		self StopAllCmds();
	}
}

start_vesper_cam(org, ang)
{
	if (!IsDefined(org) && !IsDefined(ang))
	{
		cam_ent = GetEnt(self.targetname, "target");
		if (IsDefined(cam_ent.script_noteworthy) && (cam_ent.script_noteworthy == "camera"))
		{
			org = cam_ent.origin;
			ang = cam_ent.angles;
		}
	}

	level.hud_black.alpha = 1;
	level.vesper_cam = level.player customCamera_Push("world", level.player, org, ang, 0.0);
	level.hud_black fadeOverTime(.5); 
	level.hud_black.alpha = 0;
}

stop_vesper_cam()
{
	if (IsDefined(level.vesper_cam))
	{
		level.hud_black.alpha = 1;
		level.player CustomCamera_Pop(level.vesper_cam, 0.0);
		level.hud_black fadeOverTime(.5); 
		level.hud_black.alpha = 0;
	}

	level.vesper_cam = undefined;
}

display_chyron()
{
	wait(41);
	maps\_introscreen::introscreen_chyron(&"GETTLER_INTRO_01", &"GETTLER_INTRO_02", &"GETTLER_INTRO_03");
}
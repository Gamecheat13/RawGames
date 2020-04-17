#include maps\_utility;

#using_animtree("generic_human");


spawn_enemy(spawner)
{
	new_enemy = spawner stalingradspawn();
	spawn_failed(new_enemy);
	
	console_print(spawner.targetname + " has spawned.");
	
	if( getdvar( "relaxed" ) == "1")
	{
		new_enemy LockAlertState("alert_green");
	}
	
	return new_enemy;
}


spawn_civilian(spawner)
{
	new_civ = spawner stalingradspawn();
	spawn_failed(new_civ);
	
	
	
	new_civ animscripts\shared::placeWeaponOn( new_civ.weapon, "none" );
	new_civ SetEnableSense(false);
	
	
	return new_civ;
}


create_civilian_group(civilian_spawner_name, delete_trigger_name, spawn_trigger_name)
{
	
	if(!isDefined(spawn_trigger_name))
	{
		spawn_trigger_name = "notrigger";
	}
	
	
	if(spawn_trigger_name != "notrigger")
	{
		spawn_trigger = GetEnt(spawn_trigger_name,"targetname");
		spawn_trigger waittill("trigger");
		spawn_trigger delete();
	}
	
	
	civilian_spawners = GetEntArray(civilian_spawner_name,"targetname");
	civilians = [];
	
	for(i = 0; i < civilian_spawners.size; i++)
	{
		civilians[i] = spawn_civilian(civilian_spawners[i]);
		if(civilian_spawners[i].script_noteworthy == "cower"  || !isDefined(civilian_spawners[i].script_noteworthy) )
		{
			
		}
		else
		{
			goal_node = GetNode(civilian_spawners[i].script_noteworthy,"targetname");
			civilians[i] SetGoalNode(goal_node);
		}
	}
	
	
	delete_trigger = GetEnt(delete_trigger_name,"targetname");
	delete_trigger waittill("trigger");
	delete_trigger delete();
	
	
	for(i = 0; i < civilians.size; i++)
	{
		if(isalive(civilians[i]) )
		{
			civilians[i] delete();
		}
	}
}

bomber_pause()
{
	level.bomber maps\_chase::pause_chase_route();
}

bomber_resume()
{
	level.bomber maps\_chase::resume_chase_route();
}

bomber_start(targetname)
{
	temp_node = GetNode(targetname,"targetname");
	level.bomber maps\_chase::start_chase_route(temp_node);
}


console_print(string)
{
	if( getdvar( "consoleprint" ) == "1")
	{
		iprintln(string);
	}
}

create_time_limit(seconds)
{
	
	if(seconds <= 0)
		return;

	self endon("checkpoint_reached");

	

	level thread end_chase_timer();

	radio_interval = seconds / 3;

	x = 0;
	for(i = seconds; i > 0.00; )
	{
		
		
		
		
		wait(0.05);

		i -= 0.05;
		x += 0.05;		

		if (x >= radio_interval)
		{
			if (level.radio_warning)
			{
				x = 0;
	
				if (level.radio_not_played.size == 0)
				{
					level.radio_not_played = level.radio;
				}

				sound = random(level.radio_not_played);
				level.player play_dialogue(sound);
				level.radio_not_played = array_remove(level.radio_not_played, sound);
			}
		}
	}

	level notify("time_limit_reached");
}


end_chase_timer()
{
	level waittill("checkpoint_reached");
	
}

chase_status()
{
	if( getdvar( "pip_off") == "true")
	{
		return;
	}

	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");

	SetSavedDVar("bal_wobble_sensitivity", 1);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	trigger = GetEnt("trigger_drywall","targetname");
	trigger waittill("trigger");
	

	
	
	
	
	level thread split_screen();
	
		
	
	
	wait(7);
	
	
	
	
	
}


camera_test()
{
	first_person = true;
	cameraID_test = undefined;
	cameraID_prev = undefined;
	last_button = "button_y";

	while ( 1 )
	{
		if( level.player ButtonPressed( "dpad_up" ) && last_button != "dpad_up")
		{
			last_button = "dpad_up";
			if(first_person == true)
			{
				cameraID_test = level.player customCamera_Push( "offset",  (-35.0,-15.0,0.0), (0.0, 0.0, 0.0), 1.0);
			}
			else
			{
				cameraID_prev = cameraID_test;
				cameraID_test = level.player customCamera_Change( cameraID_prev, "offset",  (-35.0,-15.0,0.0), (0.0, 0.0, 0.0), 1.0);
			}
			first_person = false;
			wait(1);
		}
		
		if( level.player ButtonPressed( "dpad_right") && last_button != "dpad_right")
		{
			last_button = "dpad_right";
			if(first_person == true)
			{
				cameraID_test = level.player customCamera_Push( "offset",  (-100.0,5.0,-10.0), (0.0, 0.0, 0.0), 1.0);
			}
			else
			{
				cameraID_prev = cameraID_test;
				cameraID_test = level.player customCamera_Change( cameraID_prev, "offset",  (-100.0,5.0,-10.0), (0.0, 0.0, 0.0), 1.0);
			}
			first_person = false;
			wait(1);
		}

		
		if( level.player ButtonPressed( "dpad_left") && last_button != "dpad_left")
		{
			last_button = "dpad_left";
			if(first_person == true)
			{
				cameraID_test = level.player customCamera_Push( "offset",  (0.0,0.0,240.0), (90.0, 0.0, 0.0), 1.0);
			}
			else
			{
				cameraID_prev = cameraID_test;
				cameraID_test = level.player customCamera_Change( cameraID_prev, "offset", (0.0,0.0,240.0), (90.0, 0.0, 0.0), 1.0);
			}
			first_person = false;
			wait(1);
		}

		
		if( level.player ButtonPressed( "dpad_down") && last_button != "dpad_down")
		{
			last_button = "dpad_down";
			if(first_person == true)
			{
				cameraID_test = level.player customCamera_Push( "offset",  (-40.0,20.0,-45.0), (0.0, -30.0, 0.0), 1.0);
			}
			else
			{
				cameraID_prev = cameraID_test;
				cameraID_test = level.player customCamera_Change( cameraID_prev, "offset", (-40.0,20.0,-45.0), (0.0, -30.0, 0.0), 1.0);
			}
			first_person = false;
			wait(1);
		}

		
		if( level.player ButtonPressed( "button_y") && last_button != "button_y")
		{
			last_button = "button_y";
			if(first_person == true)
			{
				cameraID_test = level.player customCamera_Push( "offset",  (0.0,0.0,0.0), (0.0, 0.0, 0.0), 1.0);
			}
			else
			{
				cameraID_prev = cameraID_test;
				cameraID_test = level.player customCamera_Change( cameraID_prev, "offset", (0.0,0.0,0.0), (0.0, 0.0, 0.0), 1.0);
			}
			first_person = false;
			wait(1);
		}

		wait 0.01;
	}
}

civilian_action_warn()
{
	self endon("death");

	while(1)
	{
		self CmdAction("CallOut");
		wait(2.0);
	}
}

civilian_action_confront()
{
	self endon("death");
	self endon("stop_anim");

	while(1)
	{
		self CmdAction("ConfrontThreat");
		wait(2.0);
	}
}

civilian_action_scared()
{
	self endon("death");
	self endon("stop_anim");

	while(1)
	{
		self CmdAction("Flinch");
		wait(2.0);
	}
}

civilian_action_anim(anim_name)
{
	self endon("death");
	self endon("stop_anim");

	while(1)
	{
		self CmdPlayAnim(anim_name);
		self waittill("Cmd_Done");
	}
}


clear_civilians(targetname)
{
	todelete = GetEntArray(targetname,"targetname");
	for(i = 0; i < todelete.size; i++)
	{
		if(isalive(todelete[i]) )
		{
			todelete[i] delete();
		}
	}
}


saw_sparks()
{
	spark = GetEnt("saw_spark","targetname");
	
	
	while(1)
	{
		wait(1.25);
		
		Playfx(level._effect["fxworkerFX3"], spark.origin);
		wait(2.25);
		
	}
}

flash_drive_find(awareness_object)
{
	level.information++;
	iPrintLnBold(level.information+" of 3 found");
}

elevator_sparks()
{
	self endon("elevator_crashed");
	spark_l = GetEnt("elevator_spark_left","targetname");
	spark_r = GetEnt("elevator_spark_right","targetname");

	while(1)
	{
		Playfx(level._effect["const_elevator_sparks"],spark_l.origin);
		Playfx(level._effect["const_elevator_sparks"],spark_r.origin);
		wait(.1);
	}
}

create_shake(mag, dur)
{
	while(dur > 0)
	{
		earthquake(mag, 1, level.player.origin, 256);
		dur--;
		wait(1);
	}
}

adjust_pip(newx, newy, newscalex, newscaley, time)
{
	deltax = (newx*time) / 0.05;
	deltay = (newy*time) / 0.05;
	deltasx = (newscalex*time) / 0.05;
	deltasy = (newscaley*time) / 0.05;

	x = GetDVarfloat("r_pipSecondaryX");
	y = GetDVarfloat("r_pipSecondaryY");
	scalestring = GetDVar("r_pipSecondaryScale");					
	scale = strtok(scalestring, " ");

	for(t = time; t > 0.00; )
	{
		x += deltax;
		y += deltay;
		scale[0] += deltasx;
		scale[1] += deltasy;

		SetDVar("r_pipSecondaryX", x + "");
		SetDVar("r_pipSecondaryY", y + "");						
		SetDVar("r_pipSecondaryScale", scale[0] + scale[1] + " 1.0 1.0");		

		wait(0.05);
		t -= 0.05;
	}
}

set_default_pip()
{
	wait(.5);

	SetDVar("r_pipSecondaryX", -0.20);
	SetDVar("r_pipSecondaryY", 0.05);						
	SetDVar("r_pipSecondaryAnchor", 0);						
	SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		
	SetDVar("r_pipSecondaryAspect", false);					
	SetDVar("r_pipSecondaryMode", 5);
	
	SetDVar("cg_pip_buffering","0");

	level.player animatepip(150, 0, 0.0, -1);
	wait(0.15);
	level.player animatepip(50, 0, 0.2, -1);
	wait(0.05);
	level.player animatepip(150, 0, 0.05, -1);
	

}

jump_hud_on()
{
	if (!IsDefined(level.jump_hint_on) || !level.jump_hint_on)
	{
		level.player SetCursorHint("HINT_JUMP");
		level.player SetHintString(&"HINT_JUMP");
		level.jump_hint_on = true;
	}
}

jump_hud_off()
{
	level.player SetCursorHint("");
	level.player SetHintString("");
	level.jump_hint_on = false;
}

jump_trigger()
{
	self waittill("trigger");
	level.player play_dialogue_nowait("TANN_CONSG_300A");
	hud_wait = 1.0;
	t = 0.0;

	while (true)
	{
		if (level.player IsTouching(self))
		{
			if (t >= hud_wait)
			{
				jump_hud_on();
			}

			
			
			update_dvar_scheme();
			if( getdvar( "flash_control_scheme" ) == "0" )
			{
				if (level.player ButtonPressed("NUNCHUK_BUTTON_C"))
				{
					jump_hud_off();
					return;
				}
			}
			else
			{
				if (level.player buttonPressed( "WIIMOTE_BUTTON_A" ))
				{
					jump_hud_off();
					return;
				}
			}			
		}
		else
		{
			jump_hud_off();
			t = 0.0;
		}
		
		wait .05;
		t += .05;
	}
}

set_split_screen()
{
	SetDVar("r_pipMainMode", "1");
	level.player animatepip (500, 0, 0.05, 0.034, 1, 1, 1, 1);
	level.player animatepip( 500, 1, 0.48, 0.40, 0.46, 0.54, 1, 1);
}

set_default_main()
{

	
	
	




	level.player animatepip(50, 0, 0.1, -1);
	wait(0.05);
	level.player animatepip(100, 0, 0.05, -1);
	wait(0.10);
	level.player animatepip(200, 0, -0.20, -1);
	wait(0.2);
	SetDVar("r_pipMainMode", "0");
	SetDVar("r_pipSecondaryMode", 0);
}

split_screen()
{
	
	
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );

	level.player setsecuritycameraparams( 55, 3/4 );
	wait(0.05);
	level.cameraID_bomber = level.player SecurityCustomCamera_Push("entity_abs",level.bomber, level.bomber, (-150.0, 0.0, 200.0), (0.0, 0.0, 0.0), (0.0, 0.0, 72.0), 0.0);

	
	
	
	
	level thread main_crop();
	level thread main_move();
	
	
	level thread second_move();
		
}


main_crop()
{

	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	level.player waittill( "animatepip_done" );
		
	level notify( "window_crop" );
		
	
	level waittill( "window_up" );

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	level.player waittill( "animatepip_done" );
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}


main_move()
{
	
	level waittill( "window_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



second_move()
{
	
	
	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					
	wait(0.05);	
	
	
	level waittill("window_down");
	level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (388.0, -1259.0, 568.0), (1.77, -23.13, 0.0), 0.0);
	
	SetDVar("r_pipSecondaryMode", 5);						
	


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(5);

	
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	

	
	SetDVar("r_pipSecondaryMode", 0);	
	level.player SecurityCustomCamera_pop(level.cameraID_bomber); 
	
}


second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("pb_security_lock");
		wait .05;
	}
	
}


#include maps\_utility;

#using_animtree("generic_human");

/*
Name: spawn_enemy							  
Author: Kevin Drew							  
Purpose: A wrapper function for the new ai to spawn an enemy from a spawn 
	point and set default parameters that can be easily changed here. 
Parameters:								  
	spawner - a spawnpoint	  
*/
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

/*
Name: spawn_civilian							  
Author: Kevin Drew							  
Purpose: A wrapper function for the new ai to spawn a civilian from a spawn 
	point and set default parameters that can be easily changed here. 
Parameters:								  
	spawner - a spawnpoint	  
*/
spawn_civilian(spawner)
{
	new_civ = spawner stalingradspawn();
	spawn_failed(new_civ);
	
	//console_print(spawner.targetname + " has spawned");
	//new_civ SetMachine( "Brain", "BrainAiSoldierBasic" );
	new_civ animscripts\shared::placeWeaponOn( new_civ.weapon, "none" );
	new_civ SetEnableSense(false);
	//new_civ LockAlertState("alert_yellow");
	//new_civ setoverridespeed(15);
	return new_civ;
}

/*
Name: create_civilian_group
Author: Kevin Drew
Purpose: Grabs a group of civilian spawners and handles their spawning, goals, and
	deletion.
Parameters:
	civilian_spawner_name 	- name of the civlian spawners to create an array with
	delete_trigger_name 	- name of the trigger that deletes that group of civilians
	spawn_trigger_name 	- name of the trigger that spawns the group, if not specified
			    	the group will spawn on function call
*/
create_civilian_group(civilian_spawner_name, delete_trigger_name, spawn_trigger_name)
{
	//checks to see if spawn_trigger_name is defined
	if(!isDefined(spawn_trigger_name))
	{
		spawn_trigger_name = "notrigger";
	}
	
	//if the spawn_trigger_name is defined, waits until it is triggered
	if(spawn_trigger_name != "notrigger")
	{
		spawn_trigger = GetEnt(spawn_trigger_name,"targetname");
		spawn_trigger waittill("trigger");
		spawn_trigger delete();
	}
	
	//grab the group of civilians to spawn
	civilian_spawners = GetEntArray(civilian_spawner_name,"targetname");
	civilians = [];
	//spawns the civilians and makes them go to their goal nodes or cower
	for(i = 0; i < civilian_spawners.size; i++)
	{
		civilians[i] = spawn_civilian(civilian_spawners[i]);
		if(civilian_spawners[i].script_noteworthy == "cower"  || !isDefined(civilian_spawners[i].script_noteworthy) )
		{
			//cower
		}
		else
		{
			goal_node = GetNode(civilian_spawners[i].script_noteworthy,"targetname");
			civilians[i] SetGoalNode(goal_node);
		}
	}
	
	//wait until the delete trigger is hit
	delete_trigger = GetEnt(delete_trigger_name,"targetname");
	delete_trigger waittill("trigger");
	delete_trigger delete();
	
	//delete all of the spawned civilians in the group
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

/*
Name: console_print					  	  	  
Author: Kevin Drew							  
Purpose: Looks to see if the dvar consoleprint is on and prints out debug 
	text.		  						  
Parameters:								  
	string - the string to print to the console	  		  
*/
console_print(string)
{
	if( getdvar( "consoleprint" ) == "1")
	{
		iprintln(string);
	}
}

create_time_limit(seconds)
{
	//dividing by 0 is a bad thing
	if(seconds <= 0)
		return;

	//self endon("checkpoint_reached");

	/*level.chase_timer = newHudElem();
	level.chase_timer.alignX = "center";
	level.chase_timer.alignY = "top";
	level.chase_timer.fontScale = 1.5;
	level.chase_timer.x = 0;
	level.chase_timer.y = 50;
	level.chase_timer.horzAlign = "center";
	level.chase_timer.vertAlign = "fullscreen";
	level.chase_timer setText( seconds );*/

	//level thread end_chase_timer();

	radio_interval = seconds / 3;

	x = 0;
	for(i = seconds; i > 0.00; )
	{
		//level.chase_timer settext(i);
		//static_value = 1.0 - (i / seconds);
		//SetDVar("cg_pipstatic_opacity", "" + static_value); 
		
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

				
			}
		}
	}

//	level notify("time_limit_reached");
}

//deletes the timer if Bond reaches the checkpoint in time
end_chase_timer()
{
	//level waittill("checkpoint_reached");
	level waittill("timer_ended");
	if(getdvar("timer_off") == "1")
	{
		return;
	}
	//sound = random(level.radio_not_played);
	//level.player play_dialogue(sound);
	//level.radio_not_played = array_remove(level.radio_not_played, sound);
	missionfailedwrapper();
	//level.chase_timer destroy();
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
	////////////////////////////////////////////////////////////
	//	comment out for demo
	//  please only uncomment the line with starting with //, and leave the lines with //// out.
	//
	//trigger = GetEnt("digger_shoot_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	////adjust_pip(newx, newy, newscalex, newscaley, time)
	//
	//
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (-1569.44, -3233.0, 180.0), (-1.76, 3.65, 0.0), 0.0);
	//
	//level thread set_default_pip();
	//
	//
	//trigger = GetEnt("digger_fall_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	//
	//
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (-1220.0, -3555.0, 169.0), (27.0, 52.0, 0.0), 1.0);
	//
	//
	////level thread set_default_pip();
	//
	//
	//trigger = GetEnt("climb_girder_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	//
	////level thread set_default_main();
	//level.cameraID_bomber = level.player SecurityCustomCamera_Push("entity_abs",level.bomber, level.bomber, (-7.63, -113.53, 102.0), (-18.34, -6.11, -0.0), (0.0, 0.0, 0.0), 0.5);
	//wait(7);
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "entity_abs", level.bomber, level.bomber, (-79.7, -69.48, -107.11), (-10.64, -1.54, 0.0), 1.0);
	//
	//trigger = GetEnt("top_floor_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	//
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (-827.4, -2215.0, 675.0), (30.0, 0.64, 0.0), 1.0);
	//
	//trigger = GetEnt("table_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	//level thread set_default_pip();
	//
	//SetSavedDVar("bal_wobble_sensitivity", 1.5);
	//
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (-589.46, -1345.0, 585.0), (-1.0, -71.50, 0.0), 0.0);
	//
	//wait(2.25);
	//
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (-589.46, -1345.0, 585.0), (-1.0, 17.85, 0.0), 0.5);
	//
	//wait(3);
	//
	////SetDVar("cg_pip_buffering","1");
	////SetDVar("r_pipSecondaryMode", 0);
	//level thread set_default_main();
	//
	//trigger = GetEnt("drywall_cam","targetname");
	//trigger waittill("trigger");
	//trigger delete();
	//
	//changed for demo
	//level thread set_default_pip();
	///////////////////////////////////////////////
	trigger = GetEnt("trigger_drywall","targetname");
	trigger waittill("trigger");
	//trigger delete();
	
	////////////////////////
	//added for demo, comment it out afterwards
	//level thread set_default_pip();
	////////////////////////////////////////
	level thread split_screen();
	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (388.0, -1259.0, 568.0), (1.77, -23.13, 0.0), 0.0);
		
	//level waittill("Bond_Drywall_Done"); 
	//level thread set_default_main();
	wait(7);
	///////////////////////////////////////
	// comment out for demo
	//
	/*trigger = GetEnt("bomber_parkur_cam","targetname");
	trigger waittill("trigger");
	trigger delete();

	level.player SecurityCustomCamera_Change(level.cameraID_bomber, "entity_abs", level.bomber, level.bomber, (-92.5, 7.00, 66.11), (-28.85, -4.22, 0.0), 0.5);
	
	wait(3);

    level.player SecurityCustomCamera_Change(level.cameraID_bomber, "entity_abs",level.bomber, level.bomber, (52.0, -97.75, 136.31), (-15.94, 6.00, 0.0), 0.5);

	trigger = GetEnt("crane_1_cam","targetname");
	trigger waittill("trigger");
	trigger delete();

	level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (1520.0, -2271.0, 1533.0), (20.0, -29.0, 0.0), 0.0);

	wait(4);

	level.player SecurityCustomCamera_Change(level.cameraID_bomber, "entity_abs",level.bomber, level.bomber, (-150.0, 0.0, 200.0), (0.0, 0.0, 0.0), (0.0, 0.0, 72.0), 0.0);*/
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

/*
Name: camera_switch
Author: Kevin Drew
Purpose: Allows the dev to cycle between 4 different camera angles and the default using the
	directional pad and Y button.
Parameters: None
*/
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

		//top down
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

		//foot
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

		//first person
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

/*
Name: clear_civilians					  	  	  
Author: Kevin Drew							  
Purpose: Gathers all entities with the specified targetname and deletes them
	from the map.
Parameters:								  
	targetname - the targetname of all civilians that should be removed  							  
*/
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

/*
Name: saw_sparks
Author: Kevin Drew
Purpose: Loops a spark effect at the location of the saw
Paramters:
	none.
*/
saw_sparks()
{
	spark = GetEnt("saw_spark","targetname");
	interior_light = GetEnt("flicklight","targetname");
	
	while(1)
	{
		wait(1.25);
		interior_light thread light_flicker(true, 0.5 , 1.5);
		Playfx(level._effect["fxworkerFX3"], spark.origin);
		wait(2.25);
		interior_light notify("stop_light_flicker");
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
		SetDVar("r_pipSecondaryY", y + "");						// place top left corner of display safe zone
		SetDVar("r_pipSecondaryScale", scale[0] + scale[1] + " 1.0 1.0");		// scale image, without cropping

		wait(0.05);
		t -= 0.05;
	}
}

set_default_pip()
{
	wait(.5);

	SetDVar("r_pipSecondaryX", -0.20);
	SetDVar("r_pipSecondaryY", 0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
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
	//wait(1);
	//
	hud_wait = 0.1;
	t = 0.0;

	while (level.player.beam_fallen == 0)
	{
		if (level.player IsTouching(self))
		{
			if (t >= hud_wait)
			{
				jump_hud_on();
			}

			if (level.player JumpButtonPressed())
			{
				jump_hud_off();
				return;
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

	// must have fallen off of the beam
	jump_hud_off();
	while (level.player.beam_fallen == 1)
	{
		wait .05;
	}
}

set_split_screen()
{
	SetDVar("r_pipMainMode", "1");
	level.player animatepip(500, 0, 0.05, 0.034, 1, 1, 1, 1);
	level.player animatepip(500, 1, 0.48, 0.40, 0.46, 0.54, 1, 1);
}

set_default_main()
{

	//level.player animatepip(1000, 0, 0.05, 0.05, 0.5, 0.5, 1, 1);
	//level.player animatepip(1000, 1, 0, 0, 1, 1, 1, 1);
	//wait(0.5);

	
	
	
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
	//no hud
	//setSavedDvar("cg_drawHUD","0");
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );

	level.player setsecuritycameraparams( 55, 3/4 );
	wait(0.05);
	level.cameraID_bomber = level.player SecurityCustomCamera_Push("entity_abs",level.bomber, level.bomber, (-150.0, 0.0, 200.0), (0.0, 0.0, 0.0), (0.0, 0.0, 72.0), 0.0);

	//let anim play before split screen
	//wait(2);
	
	//crop and move down
	level thread main_crop();
	level thread main_move();
	
	//PIP
	level thread second_move();
		
}


main_crop()
{

	//set border size and color
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 3);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 0.5, 0, 0);
	level.player waittill( "animatepip_done" );
		
	level notify( "window_crop" );
		
	//wait(7);
	level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 0, 0);
	level.player waittill( "animatepip_done" );
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	//setSavedDvar("cg_drawHUD","1");
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );

}

//
main_move()
{
	
	level waittill( "window_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_screen" );
	//wait(7);

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}


//pip
second_move()
{
	//trig = getent( "trigger_exit_cover", "targetname" );
	//setup PIP
	SetDVar("r_pipSecondaryX", -0.2 );						// start off screen
	SetDVar("r_pipSecondaryY", -0.13);						// place top left corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		// scale image, without cropping
	SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	wait(0.05);	//need this or it will crash
	
	
	level waittill("window_down");
	level.player SecurityCustomCamera_Change(level.cameraID_bomber, "world", (388.0, -1259.0, 568.0), (1.77, -23.13, 0.0), 0.0);
	
	SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
	//SetDVar("r_lodBias", -500);


	level.player animatepip( 500, 0, 0.25, -1 );
	wait(3);

	//trig waittill( "trigger" );
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_screen" );
	//wait(7);

	//reset
	SetDVar("r_pipSecondaryMode", 0);	
	level.player SecurityCustomCamera_pop(level.cameraID_bomber); 
	//SetDVar("r_lodBias", 0);					
}

//bond anim during pip
second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("pb_security_lock");
		wait .05;
	}
	
}


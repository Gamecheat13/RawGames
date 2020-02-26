#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;






setup_sniperScope()
{
	level.player endon ("death");

	while(true)
	{
		wait(0.05);
		currentweapon = level.player GetCurrentWeapon();
		
	}	
}	

sniperScope()
{

	
	level.sniperMinFov = 5.0;
	level.sniperMaxFov = 65.0;
	
	level.sniperZoomSpeed = 17.0;
	
	
    updateTime = 0.05;

	while (1)
	{
		currentweapon = level.player GetCurrentWeapon();
		
		if(level.player playerads() > 0.99 && level.no_zoom == 0 && ( currentweapon == "wa2000_sca" || currentweapon == "wa2000_sca_s") )
		{
			maps\_utility::player_stick( true );
			level.sniperCamera = level.player customcamera_push( "offset", 0.0 );

			
			
			setExpFog(0,35000,.075,.125,.125,0);


			level.sniperScopeActive = 1;
			while( level.player playerads() > 0.99 )
			{
				
				zoomDir = 0.0;
				if( level.player buttonPressed("APAD_UP") )
					zoomDir = -1.0;
				else if( level.player buttonPressed("APAD_DOWN") )
					zoomDir = 1.0;

				
				deltaSniperFov = level.sniperFov;
				level.sniperFov = level.sniperFov + (zoomDir * (level.sniperZoomSpeed * updateTime));
				if( level.sniperFov < level.sniperMinFov )
					level.sniperFov = level.sniperMinFov;
				if( level.sniperFov > level.sniperMaxFov )
					level.sniperFov = level.sniperMaxFov;
				deltaSniperFov = level.sniperFov - deltaSniperFov;

				level.player customcamera_setFov( level.sniperCamera, level.sniperFov, updateTime, 0.0, 0.0 );
				wait updateTime;
			}

			level.player customcamera_pop( level.sniperCamera, 0.0 );
			
			
			setExpFog(0,3700,.075,.125,.125,0);
			
			maps\_utility::player_unstick();
		}
		wait updateTime;
	}
}	






global_ai_random_anims()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( 6 );
		if ( isdefined ( self ))
		{
			self stopallcmds();
		}
		wait( 6 );
		if ( isdefined ( self ))
		{
			self stopallcmds();
		}
		wait( .05 );
		self CmdAction ("fidget");
	}
}





ledge_make_ai_leave()
{
	trigger = getent ( "reached_roof_trig", "targetname" );
	trigger waittill ( "trigger" );

	if ( IsDefined ( self ))
	{
		self StartPatrolRoute( "ledge_thugs_come_here" );
	}

}

setup_cutscenes()
{
		level thread preview_cutscene();
}

preview_cutscene()
{
	
	strIGC = GetDVar( "preview");
	if(	!IsDefined(	strIGC ) )
	{
		return;
	}

	
	if(	 strIGC	== "MM_SC_0201"	)
	{
		
		wait(	2	);
		
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	else if(	 strIGC	== "MM_SC_0301"	)
	{
		
		wait(	2	);
		
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	
	
	level	waittill(	"scene_anim_done"	);
	preview_cutscene();
	
}



global_delete_end_node()
{
	if (( isdefined ( self )) && ( !level.player islookingat( self )))
	{
		wait( .5 );
		self delete();
	}
}



global_rain1()
{

	level.player_outside = true;
	while( 1 )
	{
		wait ( 0.3 );

		player_angle = level.player.angles[1];
		offset = anglestoforward( ( 0,  player_angle, 0 ) );
		offset = vectorscale( offset, 1500 );
		forwardrain = level.player.origin ;	                        
		
		
		
		if (level.player_outside)
		{
            playfx ( level._effect["rain_runner"], forwardrain ,(0,0,1),(1,0,0));
			
			
	    }

	}

}



global_rain5()
{

	}





global_rain_05()
{
	trigger = getent ( "roof_rain_last_trigger", "targetname" );
	trigger waittill ( "trigger" );

	level notify ( "kill_spotlight_tracker" );
}



change_environment_setup()
{
	rain_change_trigs = getentArray("rain_control_triggers", "targetname");
	if ( IsDefined(rain_change_trigs) )
	{
		for (i=0; i<rain_change_trigs.size; i++)
		{
			rain_change_trigs[i] thread change_environment_triggers();
		}
	}
}	


change_environment_triggers()
{
	level.player endon("death");
	
	while(true)
	{
		self waittill("trigger");
		

		level.player_outside = false;


		while(level.player IsTouching(self))
		{
			wait(0.05);
			
			
			if(level.player_outside == true)
			{
				level.player_outside = false;

			}	
		}	
		
		level.player_outside = true;


	}	
}	


track_current_weapon()
{
	level.player endon("death");

	level.weapon_active = 0;
	
	
	
	

	while(true)
	{
		currentweapon = level.player GetCurrentWeapon();
		if(currentweapon == "wa2000_sca_s" && level.weapon_active != 1)
		{
			level.weapon_active = 1;
			
		}	
		else if(currentweapon == "p99_wet_s" && level.weapon_active != 2)
		{
			level.weapon_active = 2;
			
		}
		else if(currentweapon == "saf9_sca" && level.weapon_active != 3)
		{
			level.weapon_active = 3;
			
		}
		else if(currentweapon == "m14_sca" && level.weapon_active != 4)
		{
			level.weapon_active = 4;
			
		}
		wait(0.05);	
	}
}





skip_to_points()
{
	
	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "1" ) 
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");

		level thread maps\sciencecenter_a::sniper_event_end_cinematic();
		wait(1);
	}     
	else if(Getdvar( "skipto" ) == "2" ) 
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");

		start_org = getent( "skipTo_2_origin", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		level notify( "set_off_01" );
		level thread maps\sciencecenter_a_backlot::backlot_main();
		
		level.player TakeAllWeapons();
		level.player GiveWeapon("p99_wet_s");
		level.player switchToWeapon( "p99_wet_s" );
		
		level endon ( "enter_back_lot" );
		wait(1);
	}     
	else if(Getdvar( "skipto" ) == "3" ) 
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");

		start_org = getent( "skipTo_3_origin", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		level notify( "set_off_01" );

		level.player TakeAllWeapons();
		level.player GiveWeapon("p99_wet_s");
		level.player switchToWeapon( "p99_wet_s" );
		level thread maps\sciencecenter_a_ledge::ledge_main();
		
		setSavedDvar( "sf_compassmaplevel", "level3" );
		level thread maps\sciencecenter_a_ledge::roof_spotlight_tracker();
		
		level endon ( "enter_back_lot" );
		wait(1);
	}
		else if(Getdvar( "skipto" ) == "4" ) 
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");

		start_org = getent( "skipto_4_origin", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		level.player TakeAllWeapons();
		level.player GiveWeapon("p99_s");
		level.player giveweapon( "SAF9_SCa" );
		level.player givemaxammo( "SAF9_SCa" );
		
		level.player switchToWeapon( "SAF9_SCa" );
		level thread maps\sciencecenter_a_rooftop::rooftop_main();
		level thread maps\sciencecenter_a_rooftop::rooftop_start();

		setSavedDvar( "sf_compassmaplevel", "level4" );
		level thread maps\sciencecenter_a_ledge::roof_spotlight_tracker();
		
		level endon ( "enter_back_lot" );
		wait(1);
	}          
	else if ( getdvar ( "skipto" ) == "00" ) 
	{
		
		level notify ( "skip_to_00" );
		start_org = getent( "front_across_street_point_01", "targetname" );
		start_org_angles = start_org.angles;
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		player_stick( false );
		point2 = getent( "front_across_street_point_01", "targetname" );
		wait ( 3 );
		level.sticky_origin rotateto ( ( 0, 90, 0 ), 4 );
		level.sticky_origin waittill ( "rotatedone" );
		wait ( 5 );
		new_org = getent( "bond_startpos_origin", "targetname" );
		level.sticky_origin moveto ( new_org.origin, 10 );
		level.sticky_origin waittill ( "movedone" );
		player_unstick();
	}
}




random_command_node()
{
	self CmdAction ("fidget");
		}




hud_fade_in_out(time, freeze)
{
	if( !IsDefined( time ) )
	{
		time = 1.5;
	}
	if( !IsDefined( freeze ) )
	{
		freeze = false;
	}
	level.hudblack fadeOverTime( time * 0.5 );
	level.hudblack.alpha = 1; 
	
	if( freeze )
	{
		level.player freezeControls(true);
	}
	
	wait( time * 0.5 );
	
	level.hudblack fadeOverTime( time * 0.5 );
	level.hudblack.alpha = 0;
	
	wait(time * 0.5); 	

	if( freeze )
	{
		level.player freezeControls(false);
	}
	level.hudblack Destroy();
}	
sniper_scope_overlay()
{
	level.hudsniper = NewHudElem();
	level.hudsniper.x = -240;
	level.hudsniper.y = 0;
	level.hudsniper.horzAlign = "fullscreen";
	level.hudsniper.vertAlign = "fullscreen";
	level.hudsniper.foreground = true;
	level.hudsniper SetShader( "scope_overlay_aug", 480, 480 );
	level.hudsniper.alpha = 0;
		
	level.hudsniper fadeOverTime(0.05); 
	level.hudsniper.alpha = 1;

	level waittill("intro_cutscene_done");	

	level.hudsniper fadeOverTime(0.05); 
	level.hudsniper.alpha = 0;
	if (isdefined(level.hudsniper))
	{
		level.hudsniper destroy();
	}	
	
}
hud_info_text()
{
	level.hud_text = newHudElem();
	level.hud_text.x = -200;
	level.hud_text.y = -120;
	level.hud_text.horzAlign = "center";
	level.hud_text.vertAlign = "middle";
	level.hud_text.foreground = true;
	level.hud_text.fontScale = 1.2;
}	

dialog_placeholder(text)
{
	level.hud_text settext(text);
	wait(3.0);
	level.hud_text settext("");
}	




map_change_level1()
{
	map_level1_trig = GetEnt("map_level_01", "targetname");
	map_level1_trig waittill("trigger");

	setSavedDvar( "sf_compassmaplevel", "level1" );
	
	thread map_change_level2a();
}	
map_change_level2a()
{
	map_level2a_trig = GetEnt("map_level_02a", "targetname");

	map_level2a_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
	
	thread map_change_level3();
	thread map_change_level1(); 
}	
map_change_level2b()
{
	map_level2b_trig = GetEnt("map_level_02b", "targetname");

	map_level2b_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
	

	thread map_change_level3();
	thread map_change_level1(); 
}	
map_change_level3()
{
	map_level3_trig = GetEnt("map_level_03", "targetname");
	map_level3_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level3" );
	

	thread map_change_level2b(); 
}	




setup_laptop_pets()
{
	level.player endon("death");
	
	laptop = GetEnt("sca_laptop", "targetname");
	laptop_default_screen = GetEnt("sca_laptop_screen_default", "targetname");
	laptop_screensaver = getentarray("sca_laptop_screens", "targetname");
	
	
	if(IsDefined(laptop_default_screen))
	{
		laptop_default_screen hide();
	}	
	if ( IsDefined(laptop_screensaver) )
	{
		for (i=0; i<laptop_screensaver.size; i++)
		{
			laptop_screensaver[i] hide();
		}
		
		
		i = 0;
		while(true)
		{
			
			if(Distance( laptop.origin, level.player.origin ) < 128 )
			{
				laptop_default_screen show();
				wait(1.0);
			}
			else
			{
				if(IsDefined(laptop_default_screen))
				{
					laptop_default_screen hide();
				}	
				if(IsDefined(laptop_screensaver[i]))
				{
					laptop_screensaver[i] show();
				}
				else
				{
					i = 0;
					laptop_screensaver[i] show();
				}	
				wait(4.0);
				laptop_screensaver[i] hide();
				i++;
			}
		}
	}
	else if(IsDefined(laptop_default_screen))
	{
		laptop_default_screen show();
	}	
}	



check_achievement()
{
	if((Getdvar( "skipto" ) == "1" ) || (Getdvar( "skipto" ) == "2" ) || 
	(Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		return;
	}
	

	level.sniper_ammo = 0;
	while(level.sniper_ammo <= 5)
	{
		level.player waittill("weapon_fired");
		level.sniper_ammo++;
		wait(0.05);
		
	}	
	
	
	wait(0.1);

	if(level.all_snipers_dead == true)
	{
		GiveAchievement("Challenge_ScienceExt");
		
	}
	else
	{
		
	}	
		
}




track_weapon_silenced()
{
	while(level.all_snipers_dead == false)
	{
		
		level.player waittill("weapon_fired", silenced);
		if( silenced == false )
	{
			
			thread wake_up_ai();
		}
		
	}	
}



setup_dead_roof_guy()
		{

	if((Getdvar( "skipto" ) == "1" ) || (Getdvar( "skipto" ) == "2" ) || 
	(Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		dead_roof_thug = GetEnt("dead_roof_thug", "targetname");
		dead_roof_thug delete();
		return;
	}

	dead_roof_thug = GetEnt("dead_roof_thug", "targetname");
	dead_roof_thug animscripts\shared::placeWeaponOn(dead_roof_thug.weapon, "none");
	dead_roof_thug setenablesense(false);
	dead_roof_thug.dropweapon = false;

		wait(0.05);
	dead_roof_thug dodamage(dead_roof_thug.health + 100, dead_roof_thug.origin + (0, -10, 10) );

	
	
	
	

}





setup_car_alarms()
{
	level endon("end_sniper_event");
	
	car_dmg_trig = GetEntArray("car_dmg_trig", "targetname");

	for(i = 0; i < car_dmg_trig.size; i++)
	{
		if(isdefined(car_dmg_trig[i]))
		{
			car_dmg_trig[i] thread car_alarm_triggered();
		}
	}
}
car_alarm_triggered()
{
	level endon("end_sniper_event");
	
	
	i = randomintrange(1, 5);
	alarm_snd = ("car_alarm_"+i);
	
	self waittill("trigger");
	
	level.alarm_triggered = true;

	self playloopsound (alarm_snd);

	thread wake_up_ai();
	self thread flash_carlights();
	
	wait 15.0;
	self stoploopsound();
}	

flash_carlights()
{
	light_pos = GetEntArray(self.target, "targetname");
	if(IsDefined(light_pos))
	{
		for (i=0; i<light_pos.size; i++)
		{
			light_pos[i] thread light_flash_loop();
		}
	}	
}
light_flash_loop()
{
	
	headlightfx = level._effect["vehicle_night_headlight"];
	taillightfx = level._effect["vehicle_night_taillight"];
	
	time = 0;
	while(time <= 7.5 )
	{
		if (IsDefined(self.script_noteworthy) && (self.script_noteworthy == "taillights"))
		{
			fx = spawnfx(taillightfx, self.origin);
		}	
		else
		{
			fx = spawnfx(headlightfx, self.origin, self.angles);
		}
		triggerFx( fx );	
		wait(1.0); 
		time++;
		fx delete();
		wait(1.0); 

	}
}	

wake_up_ai()
{
	
	thug = getaiarray("axis");

	if(level.balcony_snipers.size == 0 && thug.size == 0)
	{
		
	}	
	
	for (i=0; i<thug.size; i++)
	{
		thug[i] thread alarm_shoot_bond();
	}
}	

alarm_shoot_bond(node)
{
	self endon("death");

	if(IsDefined(node))
	{
		self SetScriptSpeed("Run");
		self setgoalnode(node);
		self waittill("goal");
		self SetScriptSpeed("default");
	}	

	self setalertstatemin("alert_red");	
	self setperfectsense(true);
	self addengagerule("tgtperceive");

	while(IsDefined(self))
	{
		xtime = randomfloatrange( 1.0, 2.5 );
		self cmdshootatentityxtimes( level.player, false, 2, 0.8 );		
		self cmdaimatentity( level.player, false, -1);
	
		wait( xtime );
		self stopallcmds();
	}
}

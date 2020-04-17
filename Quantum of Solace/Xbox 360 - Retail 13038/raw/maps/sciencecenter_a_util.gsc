#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////////////////////////////////////////////////
//			GLOBAL FUNCTIONS 
////////////////////////////////////////////////////////////////////////////////////
// dsielke
//
setup_sniperScope()
{
	level.player endon ("death");

	thread ADS_culldist_change();
}	

ADS_culldist_change()
{
	level.cull_near = true;
	 
	while(true)
	{
		wait(0.05);
		currentweapon = level.player GetCurrentWeapon();
		
		if(level.player playerads() > 0.99 && ( currentweapon == "wa2000_sca" || currentweapon == "wa2000_sca_s") )
		{
			if(level.cull_near == true)
			{
				//temp xenon test for ps3.
//				setculldist(18000);
//				setExpFog(0,25000,.180,.188,.195,0);
				//iprintlnbold("push out cull distance");
				level.cull_near = false;
//			}	
			
				// push out fog so can see snipers.
				if(level.ps3)
				{
					setculldist(18000);
					setExpFog(0,25000,.180,.188,.195,0);
				}
				else //xenon
				{
					setExpFog(0,35000,.180,.188,.195,0);
				}
			}	
		}
		else
		{	
			if(level.cull_near == false)
			{
				//temp xenon test for ps3.
//				setculldist(8000);
//				setExpFog(0,2500,.180,.188,.195,0);
				//iprintlnbold("bring in cull distance");
				level.cull_near = true;
//			}	
				// reset fog values.
				if(level.ps3)
				{
					setculldist(8000);
					setExpFog(0,2500,.180,.188,.195,0);
				}
				else //xenon
				{
					setExpFog(0,3700,.180,.188,.195,0);
				}
			}	
		}
	}	
}
sniperScope()
{

	// FOV settings
	level.sniperMinFov = 5.0;
	level.sniperMaxFov = 65.0;
	//level.sniperFov = 65.0;
	level.sniperZoomSpeed = 17.0;
	
	// Misc settings
    updateTime = 0.05;

	while (1)
	{
		currentweapon = level.player GetCurrentWeapon();
		
		if(level.player playerads() > 0.99 && level.no_zoom == 0 && ( currentweapon == "wa2000_sca" || currentweapon == "wa2000_sca_s") )
		{
			maps\_utility::player_stick( true );
			level.sniperCamera = level.player customcamera_push( "offset", 0.0 );
			

			level.sniperScopeActive = 1;
			while( level.player playerads() > 0.99 )
			{
				// listen to controls
				zoomDir = 0.0;
				if( level.player buttonPressed("APAD_UP") )
					zoomDir = -1.0;
				else if( level.player buttonPressed("APAD_DOWN") )
					zoomDir = 1.0;

				// Update Fov
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
			
			
			maps\_utility::player_unstick();
		}
		wait updateTime;
	}
}	


////////////////////////////////////////////////////////////////////////////////////
//avulaj
//this will handle random anims and actions playing on thugs in a loop
//just pass through the thug and the function will do the rest
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



//avulaj
//this will send ai to goal nodes inside the sc and delete this way we can delete them out of sight
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
	// check for DVAR and exit out if nothingspecified
	strIGC = GetDVar( "preview");
	if(	!IsDefined(	strIGC ) )
	{
		return;
	}

	//check	to see if	DVar matches one of	the	IGCs
	if(	 strIGC	== "MM_SC_0201"	)
	{
		// play	scene		
		wait(	2	);
		//iPrintLnBold(	"Previewing	"	+	strIGC );
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	else if(	 strIGC	== "MM_SC_0301"	)
	{
		// play	scene	anim
		wait(	2	);
		//iPrintLnBold(	"Previewing	"	+	strIGC );
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	
	// wait	for	scene	anim to	finish,	clean	up and repeat
	level	waittill(	"scene_anim_done"	);
	preview_cutscene();
	
}

//avulaj
//this deletes any thug who gets to a node with pt_ongoal "global_delete_end_node"
global_delete_end_node()
{
	if (( isdefined ( self )) && ( !level.player islookingat( self )))
	{
		wait( .5 );
		self delete();
	}
}

//avulaj
//
global_rain1()
{

	level.player_outside = true;
	while( 1 )
	{

/*	
		ent_tag = Spawn("script_model", level.player GetTagOrigin("TAG_CAMERA") );
		ent_tag SetModel("TAG_ORIGIN");
		ent_tag.angles = (90,0,0);
		if (level.player_outside)
			{
				
				PlayFxOnTag(level._effect["rain_9"], ent_tag, "TAG_ORIGIN");
				PlayFxOnTag(level._effect["rain_mid"], ent_tag, "TAG_ORIGIN");
			}
	
		PlayFxOnTag(level._effect["rain_far"], ent_tag, "TAG_ORIGIN");
		PlayFxOnTag(level._effect["rain_bg"], ent_tag, "TAG_ORIGIN");
		
		ent_tag.pos = level.player.origin;
		wait ( 0.5 );
		ent_tag delete();
	
*/

		wait ( 0.5 );

		player_angle = level.player.angles[1];
		offset = anglestoforward( ( 0,  player_angle, 0 ) );
		offset = vectorscale( offset, 1500 );
		forwardrain = level.player.origin ;	        
		playfx ( level._effect["rain_bg"], forwardrain ,(0,0,1),(1,0,0) );                
		playfx ( level._effect["rain_far"], forwardrain ,(0,0,1),(1,0,0));
		
		if (level.player_outside)
			{

				playfx ( level._effect["rain_9"], forwardrain ,(0,0,1),(1,0,0));
				playfx ( level._effect["rain_mid"], forwardrain ,(0,0,1),(1,0,0));
		}

	}

}

//avulaj
//
global_rain5()
{
/*
	level waittill ( "rain_level_05" );
	level endon ( "rain_level_06" );
	while( 1 )
	{
		wait ( 0.5 );
		player_angle = level.player.angles[1];
		offset = anglestoforward( ( 0,  player_angle, 0 ) );
		offset = vectorscale( offset, 1500 );
		forwardrain = level.player.origin + offset;
		                        
		playfx ( level._effect["rain8"], forwardrain + (0,0,650), forwardrain + (0,0,680), forwardrain + (800,0,0) );
		playfx ( level._effect["rain9"], level.player.origin + (0,0,650), level.player.origin + (0,0,680), (0,0,680) );
*/
	}


//avulaj
//

global_rain_05()
{
	trigger = getent ( "roof_rain_last_trigger", "targetname" );
	trigger waittill ( "trigger" );
//	level notify ( "rain_level_05" );
	level notify ( "kill_spotlight_tracker" );
}
////////////////////////////////////////////////////////////////////////////////////
//                    Track Interior/Exterior Transitions                
////////////////////////////////////////////////////////////////////////////////////
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

// DCS: change effects on environment change.
change_environment_triggers()
{
	level.player endon("death");
	
	while(true)
	{
		self waittill("trigger");
	//	iprintlnbold("entered interior trigger");

		level.player_outside = false;
		materialsetwet( 0 );

		while(level.player IsTouching(self))
		{
			wait(0.05);
			
			//check for hitting an adjoining trigger.
			if(level.player_outside == true)
			{
				level.player_outside = false;
				materialsetwet( 0 );
			}	
		}	
	//	iprintlnbold("exited interior trigger");
		level.player_outside = true;
		materialsetwet( 1 );

	}	
}	

// DCS: change effects on weapon change.
track_current_weapon()
{
	level.player endon("death");

	level.weapon_active = 0;
	// wa2000_sca_s = 1;
	// p99_s = 2;
	// saf9_sca = 3;
	// m14_sca = 4;

	while(true)
	{
		currentweapon = level.player GetCurrentWeapon();
		if(currentweapon == "wa2000_sca_s" && level.weapon_active != 1)
		{
			level.weapon_active = 1;
			//iprintlnbold("changed to wa2000");
		}	
		else if(currentweapon == "p99_wet_s" && level.weapon_active != 2)
		{
			level.weapon_active = 2;
			//iprintlnbold("changed to p99");
		}
		else if(currentweapon == "saf9_sca" && level.weapon_active != 3)
		{
			level.weapon_active = 3;
			//iprintlnbold("changed to saf9");
		}
		else if(currentweapon == "m14_sca" && level.weapon_active != 4)
		{
			level.weapon_active = 4;
			//iprintlnbold("changed to m14");
		}
		wait(0.05);	
	}
}

////////////////////////////////////////////////////////////////////////////////////
// 									Define Skipto Points.
////////////////////////////////////////////////////////////////////////////////////

skip_to_points()
{
	
	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "1" ) //this will take you to the front of the alley
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");
		level.player takeweapon("WA2000_intro");
		
		level thread maps\sciencecenter_a::sniper_event_end_cinematic();
		wait(1);
	}     
	else if(Getdvar( "skipto" ) == "2" ) //this will take you to the end of the alley
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
	else if(Getdvar( "skipto" ) == "3" ) //this will take you to the start of the ledge walk
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
		else if(Getdvar( "skipto" ) == "4" ) //heli fight
	{
		wait (0.05);
		level.player unlink();
		setdvar("skipto", "0");
		
		start_org = getent( "skipto_4_origin", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		level.player TakeAllWeapons();
		level.player GiveWeapon("p99_wet_s");
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
	else if ( getdvar ( "skipto" ) == "00" ) //this will do the new open shot
	{
		//maps\_utility::unholster_weapons();
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

////////////////////////////////////////////////////////////////////////////////////
//                    Random Command node              
////////////////////////////////////////////////////////////////////////////////////
random_command_node()
{
	self CmdAction ("fidget");
}	

////////////////////////////////////////////////////////////////////////////////////
//			HUD FADE OUT/IN 
////////////////////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////////
//                   Change Map              
////////////////////////////////////////////////////////////////////////////////////
map_change_level1()
{
	map_level1_trig = GetEnt("map_level_01", "targetname");
	map_level1_trig waittill("trigger");

	setSavedDvar( "sf_compassmaplevel", "level1" );
	//iprintlnbold("load map level 1");
	thread map_change_level2a();
}	
map_change_level2a()
{
	map_level2a_trig = GetEnt("map_level_02a", "targetname");

	map_level2a_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
	//iprintlnbold("load map level 2");
	thread map_change_level3();
	thread map_change_level1(); // incase go backwards.
}	
map_change_level2b()
{
	map_level2b_trig = GetEnt("map_level_02b", "targetname");

	map_level2b_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
	//iprintlnbold("load map level 2");

	thread map_change_level3();
	thread map_change_level1(); // incase go backwards.
}	
map_change_level3()
{
	map_level3_trig = GetEnt("map_level_03", "targetname");
	map_level3_trig waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level3" );
	//iprintlnbold("load map level 3");

	thread map_change_level2b(); // incase go backwards.
}	

////////////////////////////////////////////////////////////////////////////////////
//                   Team Pet Laptop Screensaver              
////////////////////////////////////////////////////////////////////////////////////
setup_laptop_pets()
{
	level.player endon("death");
	
	laptop = GetEnt("sca_laptop", "targetname");
	laptop_default_screen = GetEnt("sca_laptop_screen_default", "targetname");
	laptop_screensaver = getentarray("sca_laptop_screens", "targetname");
	
	//// intially hide all screens.
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
		
		//// cycle pet pictures.
		i = 0;
		while(true)
		{
			//// shut off screen saver if get close.
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
////////////////////////////////////////////////////////////////////////////////////
//                   CHECK ACHIEVEMENT              
////////////////////////////////////////////////////////////////////////////////////
check_achievement()
{
	if((Getdvar( "skipto" ) == "1" ) || (Getdvar( "skipto" ) == "2" ) || 
	(Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		return;
	}
	level thread track_weapon_silenced();

	level.sniper_ammo = 0;
	while(level.sniper_ammo <= 5)
	{
		level.player waittill("weapon_fired");
		level.sniper_ammo++;
		wait(0.05);
		//iprintlnbold("shots fired = ", level.sniper_ammo);
	}	

	//iprintlnbold("Checking Achievement");
	wait(0.1);

	if(level.all_snipers_dead == true)
	{
		GiveAchievement("Challenge_ScienceExt");
		//iprintlnbold("Achievement Earned!");
	}
	else
	{
		//iprintlnbold("Achievement Failed!");
	}	
		
}



// new parameter from Michel to track when firing unsilenced sniper rifle.
track_weapon_silenced()
{
	while(level.all_snipers_dead == false)
	{
		//silenced = undefined;
		level.player waittill("weapon_fired", silenced);
		if( silenced == false )
		{
			//iprintlnbold("Fired unsilenced weapon!");
			thread wake_up_ai();
		}

	}	
}
////////////////////////////////////////////////////////////////////////////////////
//                   SETUP DEAD ROOF GUY              
////////////////////////////////////////////////////////////////////////////////////	
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
	dead_roof_thug lockalertstate( "alert_green" );
	dead_roof_thug setenablesense(false);
	dead_roof_thug.dropweapon = false;
	dead_roof_thug SetDeathEnable(false);
	dead_roof_thug SetPainEnable(false);


	wait(0.05);
	
	dead_roof_thug cmdplayanim( "p_lvl_deadguy_a", false, true );
	//dead_roof_thug startragdoll();
	wait(1.0);
	//dead_roof_thug waittill("cmd_done");
	dead_roof_thug becomecorpse(); 
	
/*
	while(level.crossed_street == false)
	{
		dead_roof_thug cmdplayanim( "p_lvl_deadguy_a", false );
		dead_roof_thug waittill("cmd_done");
	}
	level waittill("street_crossing_done");
	dead_roof_thug delete();
*/
}

////////////////////////////////////////////////////////////////////////////////////
//                   SETUP CAR ALARMS              
////////////////////////////////////////////////////////////////////////////////////

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
	
	//random car alarm 1-5.
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
	// flash lights.
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
		wait(1.0); //on
		time++;
		fx delete();
		wait(1.0); //off

	}
}	

wake_up_ai()
{
	//wake up ai.
	thug = getaiarray("axis");

	if(level.balcony_snipers.size == 0 && thug.size == 0)
	{
		//iprintlnbold("No enemies to alert and fire back");
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
////////////////////////////////////////////////////////////////////////////////////
//                  FIX DAD ROCKET JUMP              
////////////////////////////////////////////////////////////////////////////////////
// checking amount, if shot right on you damage is greater than 125, anything less normal damage.
dad_rocket_jump_fix()
{
	level.player endon("death");
	while(true)
	{
		wait(0.05);
		level.player waittill("damage", amount, attacker,direction_vec, point, type);
		if(attacker == level.player && type == "MOD_PROJECTILE_SPLASH" && amount >= 125)
		{
			//iprintlnbold("amount of DAD damage", amount);
			level.player dodamage( level.player.health *2, level.player.origin);
		}	 
	}	
}	

#include maps\_utility;


//sniper battle chatter 
//enemy chatter before vesper gets grabbed
vesper_fail_chatter1()
{
	radio = getent("warehouse_radio_ori", "targetname");
	//level endon("death");
	switch( RandomInt(4) )
	{
			case 0:
				//radio play_dialogue("BAM1_BargG_050A"); //Move it.   //////////////////switch this to level.sniper_vesper
				level.sniper_vesper play_dialogue("VESP_BargG_014A"); //Let go!
				break;
			case 1:
				level.sniper_vesper play_dialogue("VESP_BargG_052A"); //Get your hands off me!
				//radio play_dialogue("BMR2_BargG_053A"); //Shut up.
				break;
			case 2:
				//radio play_dialogue("BMR2_BargG_054A"); //Not this time.  Now move!
				level.sniper_vesper play_dialogue("VESP_BargG_055A"); //You can’t do this!
				break;
			case 3:
				//radio play_dialogue("BMR4_BargG_056A"); //Get inside.
				level.sniper_vesper play_dialogue("VESP_BargG_057A"); //You bastard!
				break;
	}
}	

vesper_fail_chatter2()
{
	radio = getent("warehouse_radio_ori", "targetname");
	//level endon("death");
	switch( RandomInt(7) )
	{
			case 0:
				//radio play_dialogue("BMR5_BargG_058A"); //Keep moving.
				level.sniper_vesper play_dialogue("VESP_BargG_059A"); //Don’t touch me!
				break;
			case 1:
			
				level.sniper_vesper play_dialogue("VESP_BargG_060A"); //Let me go!
				break;
			case 2:
			
				level.sniper_vesper play_dialogue("VESP_BargG_062A"); //I said let go!
				break;
			case 3:
				//radio play_dialogue("BMR1_BargG_066A"); //Someone wants to talk to you.
				level.sniper_vesper play_dialogue("VESP_BargG_065A"); //[scream of frustration]
				break;
			case 4:
	
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_067A"); //No!
				break;
			case 5:
			
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_068A"); //This isn’t right!
				break;
			case 6:
			
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_071A"); //[scream in frustration/anger]
				break;
	}
}

vesper_thug_kill_chatter1()
{
	switch( RandomInt(2) )
	{
			case 0:
				level.sniper_vesper play_dialogue("VESP_BargG_065A"); //[scream of frustration]
				break;
			case 1:	
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_071A"); //[scream in frustration/anger]
				break;
	}
}

vesper_ambient_chatter()
{
	switch( RandomInt(4) )
	{
			case 0:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_112A"); //James!  Help me!
				break;
			case 1:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_113A"); // James!
				break;
			case 2:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_114A"); //Watch out!
				break;
			case 3:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_115A"); //Help!
				break;
	}
}

vesper_caught_chatter()
{
	switch( RandomInt(4) )
	{
			case 0:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_123A"); //James!?
				break;
			case 1:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_124A"); //James!?  What happened?
				break;
			case 2:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_125A"); //What happened to you?
				break;
			case 3:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_129A"); //Help!
				break;
	}
}

bond_wont_move()
{
	radio = getent("warehouse_radio_ori", "targetname");
	switch( RandomInt(4) )
	{
			case 0:
				radio play_dialogue_nowait ("BMR6_BargG_046A"); //Get him before he moves location!
				break;
			case 1:
				radio play_dialogue_nowait ("BMR6_BargG_047A"); //He’s not moving.  Take the shot! 
				break;
			case 2:
				radio play_dialogue_nowait ("BMR6_BargG_048A"); //He’s right there! In the window!
				break;
			case 3:
				radio play_dialogue_nowait ("BMR6_BargG_049A"); //He isn’t moving!  Shoot him!
				break;
	}
}

vesper_guidance()
{
		if(level.vesper_guidance_var == 0)
		{
			level.player play_dialogue("TANN_BargG_506A", 1); //iprintlnbold("Tanner: Bond, they're heading down the deck from your left.");
		}
		else if(level.vesper_guidance_var == 1)//1
		{
			level.player play_dialogue("TANN_BargG_507A", 1); //iprintlnbold("Tanner: There's another!");
		}
		else if(level.vesper_guidance_var == 2) 
		{
			level.player play_dialogue("TANN_BargG_508A", 1); //iprintlnbold("Tanner: Behind her, Bond!");
		}
		else if(level.vesper_guidance_var == 3)//2
		{
			level.player play_dialogue("TANN_BargG_509A", 1); //iprintlnbold("Tanner: Target on upper deck, in front of her.");
		}
		else if(level.vesper_guidance_var == 4) //3
		{
			level.player play_dialogue("TANN_BargG_511A", 1);  //iprintlnbold("Tanner: Target to your right.");
		}
		else if(level.vesper_guidance_var == 5)
		{
			level.player play_dialogue("TANN_BargG_513A", 1); //iprintlnbold("Tanner: Look left, Bond."); //
		}
		else if(level.vesper_guidance_var == 6)
		{
			level.player play_dialogue("TANN_BargG_514A", 1); //iprintlnbold("Tanner: Jumping down, to your right.");
		}
		else if(level.vesper_guidance_var == 7) //4
		{
			level.player play_dialogue("TANN_BargG_516A", 1); //iprintlnbold("Tanner: Right next to her, Bond. At the door.");
		}
		else if(level.vesper_guidance_var == 8)
		{
			wait(1.5);
			level.player play_dialogue("TANN_BargG_517A", 1); //iprintlnbold("Tanner: In front of her. He's getting close.");
		}
		else if(level.vesper_guidance_var == 9)
		{
			level.player play_dialogue("TANN_BargG_518A", 1); //iprintlnbold("Tanner: New target, straight ahead of her.");
		}
		else if(level.vesper_guidance_var == 10)
		{
			//level.player play_dialogue("TANN_BargG_518A", 1); //iprintlnbold("Vesper: James, They're coming down the deck from your left");
		}
}


spotlight_que()
{
	while(1)
	{
		if((level.spot_death_var ==1) && (level.spot_death_var2 == 0))
		{
			level thread spotlight2_logic();
			break;
		}
	wait(0.5);
	}
}

//
spotlight2_logic()
{
	dyn_light2 = getent("spotlight_light_two", "targetname");
	light_origin2 = getent("spotlight2_script_origin", "targetname");
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	window_1 = getent(pos1.target, "targetname");
	window_2 = getent(pos2.target, "targetname");
	window_3 = getent(pos3.target, "targetname");
	idle_ori = getent("search_idle_ori", "targetname");
	spotlight2 = getent("spotlight_2", "targetname");
	spotlight2_dmg = getent("spotlight_2_dmg", "targetname");
	spotlight2_dmg hide();
	spotlight_arm2 = getent("spotlight_2_arm", "targetname");
	//spotlight_arm linkto(spotlight);
	level.spotlight_tag2 = Spawn("script_model", spotlight2.origin + (0, 0, 0));
	level.spotlight_tag2 SetModel("tag_origin");
	level.spotlight_tag2.angles = spotlight2.angles;
	level.spotlight_tag2 LinkTo(spotlight2);
	PlayFxOnTag(level._effect["barge_spotlight"], level.spotlight_tag2, "tag_origin");
	dyn_light2 linkLightToEntity(light_origin2);
	dyn_light2.origin = (0,0,0);
	dyn_light2.angles = (0,0,0);
	dyn_light2 setlightintensity (5);
	//level thread spotlight2_damage_trigger();
	level thread spotlight2_random_search();
	z = randomintrange(1,2);
	while(level.sniper_event == 0)
	{
		if(level.spotlight_var == 1)
		{
			//iprintlnbold("I see you in window one!");
			win = spotlight2.origin - window_1.origin;  //vectors have to be reversed because the fx was exported incorrectly
			winx = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin2 rotateto(VectorToAngles(winx)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			//wait(z);
		}
		else if(level.spotlight_var == 2)
		{
			//iprintlnbold("I see you in window two!");
			win2 = spotlight2.origin - window_2.origin;
			winx2 = window_2.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win2)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin2 rotateto(VectorToAngles(winx2)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			//wait(z);
		}
		else if(level.spotlight_var == 3)
		{
			//iprintlnbold("I see you in window three");
			win3 = spotlight2.origin - window_3.origin;
			winx3 = window_3.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win3)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin2 rotateto(VectorToAngles(winx3)+( 0 , 0, 0), 1, 0.5, 0.1);	 
			spotlight2 waittill("rotatedone");
			//wait(z);
		}
		else if((level.spotlight_var == 0) && (level.spotted_var == 9))
		{
			//iprintlnbold("where is he?");
			win4 = spotlight2.origin - idle_ori.origin;
			winx4 = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin2 rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			//wait(z);
		}
		else if(level.spotlight_var == 88)
		{
			win4 = spotlight2.origin - idle_ori.origin;
			winx4 = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin2 rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			//wait(5);
			//spotlight_tag delete();
			dyn_light2 setlightintensity (0);
			break;
		}
		else
		{
			level thread spotlight2_random_search();
			level waittill("random2_search_done");
		}
		wait(0.2);
	}
}


spotlight2_random_search()
{
		light_origin2 = getent("spotlight2_script_origin", "targetname");
		pos1 = getent("sniper_pos1", "targetname");
		pos2 = getent("sniper_pos2", "targetname");
		pos3 = getent("sniper_pos3", "targetname");
		window_1 = getent(pos1.target, "targetname");
		window_2 = getent(pos2.target, "targetname");
		window_3 = getent(pos3.target, "targetname");
		spotlight2 = getent("spotlight_2", "targetname");
		r = randomfloatrange(0.4, 1.7);
		s = randomfloatrange(0.3, 2.1);
		w = randomfloatrange(0.2, 1.2);
		win[0] = window_1.origin - spotlight2.origin;
		win[1] = window_2.origin - spotlight2.origin;
		win[2] = window_3.origin - spotlight2.origin;
		lamp = randomint(3);
		spotlight2 rotateto(VectorToAngles(win[lamp] )+(0, 90, 0), r, r/3, r/4);
		light_origin2 rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), r, r/3, r/4);
		spotlight2 waittill("rotatedone");
		lamp = randomint(3);
		spotlight2 rotateto(VectorToAngles(win[lamp])+(0, 90, 0), s, s/3, s/3);
		light_origin2 rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), s, s/3, s/4);
		spotlight2 waittill("rotatedone");
		lamp = randomint(3);
		spotlight2 rotateto(VectorToAngles(win[lamp])+(0, 90, 0), r, r/3, r/4);
		light_origin2 rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), r, r/3, r/4);
		spotlight2 waittill("rotatedone");
		lamp = randomint(3);
		spotlight2 rotateto(VectorToAngles(win[lamp])+(0, 90, 0), w, w/3, w/4);
		light_origin2 rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), w, w/3, w/4);
		spotlight2 waittill("rotatedone");
		lamp = randomint(3);
		//light_origin rotateto(VectorToAngles(winx3)+( 0 ,90, 0), 2, 1, 1);	 // Need to add 90 yaw because the light is relative
		level notify("random2_search_done");
}

spotlight2_damage_trigger()
{
	spotlight2 = getent("spotlight_2", "targetname");
	spotlight2_dmg = getent("spotlight_2_dmg", "targetname");
	ori1 = getent("spotlight2_ori1", "targetname");
	ori2 = getent("spotlight2_ori2", "targetname");
	trigger = getent("spl2_dmg_trg", "targetname");
	dynEnt_StopPhysics("fence_cage_2_dyn_brushes");
	trigger waittill("trigger");
	level.spot_death_var2 = 1;
	playfx (level._effect["fxsmoke"], spotlight2.origin +(0, 0, 0));
	trigger waittill("trigger");
	playfx (level._effect["barge_electric_spark1"], spotlight2.origin +(0, 0, 0));
	playfx (level._effect["barge_electric_spark1"], spotlight2.origin +(0, 0, 0));
	wait(0.05);
	playfx (level._effect["barge_electric_spark1"], spotlight2.origin +(0, 0, 0));
	wait(0.05);
	playfx (level._effect["barge_electric_spark1"], spotlight2.origin +(0, 0, 0));
	trigger waittill("trigger");
	playfx (level._effect["fxfire3"], spotlight2.origin +(0, 0, 0));
	wait(4);
	playfx (level._effect["fxpumpgen"], spotlight2.origin +(0, 0, 0));
	
	dynEnt_StartPhysics("fence_cage_2_dyn_brushes");
	
	array = getentarray("fence_cage_apparatus_2", "targetname");
	if(isdefined(array))
	{
		for (i = 0; i < array.size; i++)
		{
			array[i] delete(); 
		}
	}
	physicsExplosionSphere( ori1.origin, 350, 10, 2 );
	ori1 radiusdamage(ori1.origin, 80,500,400);
	ori2 radiusdamage(ori2.origin, 80,500,400);
	level.spotlight_var = 88;
	level.spotlight_tag2 delete();
	spotlight2 hide();
	spotlight2_dmg show();
	level notify("fx_spotlight_spark2"); //CG - trigger the sparking effects 
	//if( trigger.triggeredDamage )
	//{
		//if( trigger.damageAttacker = !level.player )
		//	xx = false;
	//}
}

spotlight1_kill()
{
	dyn_light = getent("spotlight_light_one", "targetname");
	if(!level.spotlight_var == 77)
	{
		level.spotlight_tag delete();
		dyn_light setlightintensity(0);
	}
}

spotlight2_kill()
{
	dyn_light2 = getent("spotlight_light_two", "targetname");
	if(!level.spotlight_var == 88)
	{
		level.spotlight_tag2 delete();
		dyn_light2 setlightintensity(0);
	}
}

spotlight_trace()
{
	trace_distance = 1416;
	fov = 0.9;
	spot_ori = self.origin;
	
	vector = level.player.origin - spot_ori;
	vNormal = vectorNormalize( vector );
	light_forward = anglesToForward( self.angles );
	fDot = vectorDot( light_forward, vNormal );
	
	while(1)
	{
		if( sightTracePassed( spot_ori, level.player GetEye(), false, undefined ) )
		{
			if( fDot >= fov )	// in view and not too far away
			{
				//iprintlnbold("oh noes");
			}
		}
		wait(0.1);
	}
	
}

//playing a 50/50 between vesper panicing or
//vesper covering her head 
vesper_stop_anim()
{
	stop_anim[0] = "Vesper_StandCover";
	stop_anim[1] = "Vesper_PanicIdle";
	//x = randomintrange(40, 130);
	//level.sniper_vesper cmdfaceangles(x, 0); //always make vesper face towards the warehouse
	level.sniper_vesper CmdPlayanim(stop_anim[randomint(2)], false);
}

//this is %100 vepser covering her head
vesper_stop_anim2()
{
	stop_anim[0] = "Vesper_StandCover";
	stop_anim[1] = "Vesper_StandCover";
	//x = randomintrange(40, 130);
	//level.sniper_vesper cmdfaceangles(x, 0); 
	
	level.sniper_vesper cmdfaceangles(90, false, 1); //always make vesper face towards the warehouse
	level.sniper_vesper waittill("cmd_done");
	level.sniper_vesper CmdPlayanim(stop_anim[randomint(2)], false);
}

//playing thug shinkick anims either on the left or right side of vepser depending on her
//hiding spot.
thug_grab_anim()
{

	self endon("death");
	//self cmdglanceatentity(level.sniper_vesper, 0.2);
  //level thread grab_thug_angles();
  //level waittill("thug_angles_finished");
  //self waittill("facing_node");
  if((level.vesper_guidance_var == 0) || (level.vesper_guidance_var == 1) || (level.vesper_guidance_var == 3) || (level.vesper_guidance_var == 7) || (level.vesper_guidance_var == 8) || (level.vesper_guidance_var == 9))
	{
  	self CmdPlayanim("Thug_ShinKick", false);
  }
  else if((level.vesper_guidance_var == 2) || (level.vesper_guidance_var == 4) || (level.vesper_guidance_var == 5) || (level.vesper_guidance_var == 6))
  {
  	self CmdPlayanim("Thug_ShinKick_Left", false);
  }
  wait(10);
  self stopallcmds();
  self cmdshootatentity(level.player, false, 1, 0.1);
}

//playing vespers shinkick anims either on the left or right side of the thug depending on vespers
//hiding spot.
vesper_grab_anim(guy)
{
	level.sniper_vesper stopallcmds();
	//wait(0.2);
	//level thread vesper_angles();
	//level waittill("vespers_angles_finished");

	if((level.vesper_guidance_var == 0) || (level.vesper_guidance_var == 1) || (level.vesper_guidance_var == 3))
	{
		level.sniper_vesper CmdPlayanim("Vesper_ShinKick", false);
	}
	else if((level.vesper_guidance_var == 2) || (level.vesper_guidance_var == 4) || (level.vesper_guidance_var == 5) || (level.vesper_guidance_var == 6))
	{
		level.sniper_vesper CmdPlayanim("Vesper_ShinKick_Left", false);
	}
	else if((level.vesper_guidance_var == 7) || (level.vesper_guidance_var == 8) || (level.vesper_guidance_var == 9))
	{
		level.sniper_vesper CmdPlayanim("Vesper_ShinKick", false);
	}
	//wait(10); //new!
	guy waittill("death"); //new!
	level.sniper_vesper thread vesper_thug_kill_chatter1();
	level.sniper_vesper stopallcmds();
	wait(0.1);
	if(level.vesper_guidance_var <= 1)
	{
		level.sniper_vesper setgoalnode(level.hidenode);
		level.sniper_vesper waittill("goal");
		level.vesp_anim1 = true;
		level.vesper_stp1_orib = level.sniper_vesper.origin; //grabbing her origin after the first anim 
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 2) || (level.vesper_guidance_var == 3))
	{
		level.sniper_vesper setgoalnode(level.hidenode_sigma);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 4) || (level.vesper_guidance_var == 5) || (level.vesper_guidance_var == 6))
	{
		level.sniper_vesper setgoalnode(level.hidenode_zeta);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 7) || (level.vesper_guidance_var == 8) || (level.vesper_guidance_var == 9))
	{
		level.sniper_vesper setgoalnode(level.hidenode_omega);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
}	

//additional anims
vesper_grab_anim2()
{
	//level.sniper_vesper stopallcmds();
	//wait(0.2);
	//level.sniper_vesper CmdPlayanim("Vesper_FaceElbow", false);
}

vesper_drag_anim()
{
	drag_anim[0] = 	"Vesper_WalkFast";
	drag_anim[1] = 	"Vesper_VesprDrag";
	self CmdPlayanim(drag_anim[randomint(2)]);
}



//this was the first attempt to face vesper towards her pursuants during the anim sync
//not used anymore, but kept around just in case.
vesper_angles()
{
		if(level.vesper_guidance_var == 0)
		{
			level.sniper_vesper stopcmd();
			level.sniper_vesper cmdfaceangles(322.5, false, 0.5);
			level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 1)//1
		{
			level.sniper_vesper stopcmd();
			level.sniper_vesper cmdfaceangles(00.0, false, 0.5);
			level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 2) 
		{
			level.sniper_vesper stopcmd();
			level.sniper_vesper cmdfaceangles(180.0, false, 0.5);
			level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 3)//2
		{
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 4) //3
		{
			level.sniper_vesper stopcmd();
			level.sniper_vesper cmdfaceangles(136.0, false, 0.5);
			level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 5)
		{
			//level.sniper_vesper stopcmd();
			//level.sniper_vesper cmdfaceangles(141.0, false, 0.5);
			//level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 6)
		{
			//level.sniper_vesper stopcmd();
			//level.sniper_vesper cmdfaceangles(141.0, false, 0.5);
			//level.sniper_vesper waittill("cmd_done");
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 7) //4
		{
			
			
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 8)
		{
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 9)
		{
			level notify("vespers_angles_finished");
		}
		else if(level.vesper_guidance_var == 10)
		{
			level notify("vespers_angles_finished");
		}
}

//this was the first attempt to face vesper towards her pursuants during the anim sync
//not used anymore, but kept around just in case.
grab_thug_angles()
{
		if(level.vesper_guidance_var == 0)
		{
			self stopallcmds();
			self cmdfaceangles(142.5, false, 0.5);
			self waittill("cmd_done");
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 1)//1
		{
			self stopallcmds();
			self cmdfaceangles(180.0, false, 0.5);
			self waittill("cmd_done");
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 2) 
		{
			self stopallcmds();
			self cmdfaceangles(00.0, false, 0.5);
			self waittill("cmd_done");
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 3)//2
		{
			//not needed
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 4) //3
		{
			self stopallcmds();
			self cmdfaceangles(316.0, false, 0.5);
			self waittill("cmd_done");
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 5)
		{
			//not needed
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 6)
		{
			//not needed
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 7) //4
		{
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 8)
		{
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 9)
		{
			level notify("thug_angles_finished");
		}
		else if(level.vesper_guidance_var == 10)
		{
			level notify("thug_angles_finished");
		}
}


slow_time(val, tim, out_tim)
{
	self endon("stop_timescale");

	thread check_for_death();
	SetSavedDVar( "timescale", val);

	wait(tim - out_tim);

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);

	level notify("timescale_stopped");
}

check_for_death()
{
	self endon("timescale_stopped");

	while(level.player.health > 0)
	{
		wait(.05);
	}

	level notify("stop_timescale");
	SetSavedDVar( "timescale", 1);
}


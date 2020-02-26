#include maps\_utility;




vesper_fail_chatter1()
{
	radio = getent("warehouse_radio_ori", "targetname");
	
	switch( RandomInt(4) )
	{
			case 0:
				
				level.sniper_vesper play_dialogue("VESP_BargG_014A"); 
				break;
			case 1:
				level.sniper_vesper play_dialogue("VESP_BargG_052A"); 
				
				break;
			case 2:
				
				level.sniper_vesper play_dialogue("VESP_BargG_055A"); 
				break;
			case 3:
				
				level.sniper_vesper play_dialogue("VESP_BargG_057A"); 
				break;
	}
}	

vesper_fail_chatter2()
{
	radio = getent("warehouse_radio_ori", "targetname");
	
	switch( RandomInt(7) )
	{
			case 0:
				
				level.sniper_vesper play_dialogue("VESP_BargG_059A"); 
				break;
			case 1:
			
				level.sniper_vesper play_dialogue("VESP_BargG_060A"); 
				break;
			case 2:
			
				level.sniper_vesper play_dialogue("VESP_BargG_062A"); 
				break;
			case 3:
				
				level.sniper_vesper play_dialogue("VESP_BargG_065A"); 
				break;
			case 4:
	
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_067A"); 
				break;
			case 5:
			
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_068A"); 
				break;
			case 6:
			
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_071A"); 
				break;
	}
}

vesper_ambient_chatter()
{
	switch( RandomInt(4) )
	{
			case 0:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_112A"); 
				break;
			case 1:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_113A"); 
				break;
			case 2:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_114A"); 
				break;
			case 3:
				level.sniper_vesper play_dialogue_nowait ("VESP_BargG_115A"); 
				break;
	}
}


vesper_guidance()
{
		if(level.vesper_guidance_var == 0)
		{
			level.player play_dialogue("TANN_BargG_506A", 1); 
		}
		else if(level.vesper_guidance_var == 1)
		{
			level.player play_dialogue("TANN_BargG_507A", 1); 
		}
		else if(level.vesper_guidance_var == 2) 
		{
			level.player play_dialogue("TANN_BargG_508A", 1); 
		}
		else if(level.vesper_guidance_var == 3)
		{
			level.player play_dialogue("TANN_BargG_509A", 1); 
		}
		else if(level.vesper_guidance_var == 4) 
		{
			level.player play_dialogue("TANN_BargG_511A", 1);  
		}
		else if(level.vesper_guidance_var == 5)
		{
			level.player play_dialogue("TANN_BargG_513A", 1); 
		}
		else if(level.vesper_guidance_var == 6)
		{
			level.player play_dialogue("TANN_BargG_514A", 1); 
		}
		else if(level.vesper_guidance_var == 7) 
		{
			level.player play_dialogue("TANN_BargG_516A", 1); 
		}
		else if(level.vesper_guidance_var == 8)
		{
			wait(1.5);
			level.player play_dialogue("TANN_BargG_517A", 1); 
		}
		else if(level.vesper_guidance_var == 9)
		{
			level.player play_dialogue("TANN_BargG_518A", 1); 
		}
		else if(level.vesper_guidance_var == 10)
		{
			
		}
}

spotlight_que()
{
	while(1)
	{
		if(level.spot_death_var ==1)
		{
			level thread spotlight2_logic();
			break;
		}
	wait(0.5);
	}
}


spotlight2_logic()
{
	
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
	
	level.spotlight_tag2 = Spawn("script_model", spotlight2.origin + (0, 0, 0));
	level.spotlight_tag2 SetModel("tag_origin");
	level.spotlight_tag2.angles = spotlight2.angles;
	level.spotlight_tag2 LinkTo(spotlight2);
	PlayFxOnTag(level._effect["barge_spotlight"], level.spotlight_tag2, "tag_origin");
	
	
	
	
	level thread spotlight2_damage_trigger();
	level thread spotlight2_random_search();
	z = randomintrange(1,2);
	while(level.sniper_event == 0)
	{
		if(level.spotlight_var == 1)
		{
			
			win = spotlight2.origin - window_1.origin;  
			winx = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin2 rotateto(VectorToAngles(winx)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			
		}
		else if(level.spotlight_var == 2)
		{
			
			win2 = spotlight2.origin - window_2.origin;
			winx2 = window_2.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win2)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin2 rotateto(VectorToAngles(winx2)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			
		}
		else if(level.spotlight_var == 3)
		{
			
			win3 = spotlight2.origin - window_3.origin;
			winx3 = window_3.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win3)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin2 rotateto(VectorToAngles(winx3)+( 0 , 0, 0), 1, 0.5, 0.1);	 
			spotlight2 waittill("rotatedone");
			
		}
		else if((level.spotlight_var == 0) && (level.spotted_var == 9))
		{
			
			win4 = spotlight2.origin - idle_ori.origin;
			winx4 = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin2 rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			
		}
		else if(level.spotlight_var == 88)
		{
			win4 = spotlight2.origin - idle_ori.origin;
			winx4 = window_1.origin - light_origin2.origin;
			spotlight2 rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin2 rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight2 waittill("rotatedone");
			
			
			
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
		
		level notify("random2_search_done");
}

spotlight2_damage_trigger()
{
	spotlight2 = getent("spotlight_2", "targetname");
	spotlight2_dmg = getent("spotlight_2_dmg", "targetname");
	ori1 = getent("spotlight2_ori1", "targetname");
	ori2 = getent("spotlight2_ori2", "targetname");
	trigger = getent("spl2_dmg_trg", "targetname");
	trigger waittill("trigger");
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
	array = getentarray("fence_cage_apparatus_2", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i] delete(); 
	}
	physicsExplosionSphere( ori1.origin, 300, 10, 2 );
	ori1 radiusdamage(ori1.origin, 80,500,400);
	ori2 radiusdamage(ori2.origin, 80,500,400);
	level.spotlight_var = 88;
	level.spotlight_tag2 delete();
	spotlight2 hide();
	spotlight2_dmg show();
	
	
		
		
	
}

spotlight1_kill()
{
	
	if(!level.spotlight_var == 77)
	{
		level.spotlight_tag delete();
		
	}
}

spotlight2_kill()
{
	
	if(!level.spotlight_var == 88)
	{
		level.spotlight_tag2 delete();
		
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
			if( fDot >= fov )	
			{
				
			}
		}
		wait(0.1);
	}
	
}
#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;


main()
{
	level thread init_excavator_consoles();
	level thread hide_diggers();
	level thread show_diggers();
	level thread wait_for_biodome_breach();
	level thread stop_all_digger_rumble();
}

digger_moving_earthquake_rumble(localClientNum, set,newEnt)
{
	
	if(localClientNum != 0)
	{
		return;
	}
				
	if(set)
	{
		for(i=0;i<level.localPlayers.size;i++)
		{
			level thread do_digger_moving_earthquake_rumble(i,self);
		}
		
	}
	else
	{
		if(isDefined(self.headlight1))
		{
			//players = getLocalPlayers();
			for(i=0;i<level.localPlayers.size;i++)
			{
				stopfx(i,self.headlight1);
				stopfx(i,self.headlight2);
				stopfx(i,self.blink1);
				stopfx(i,self.blink2);
				
				if(isDefined(self.tread_fx))
				{
					stopfx(i,self.tread_fx);
				}
				
			}
		} 
		self notify("stop_moving_rumble");
	}
}

wait_for_biodome_breach()
{
	level waittill("BIO");
	
	for(i=0;i<level.localPlayers.size;i++)
	{
		player = getlocalplayers()[i];
		
		if(!isDefined(player))
		{
			continue;
		}
		
		piece = getent(i,"biodome_breached","targetname");
		if(!isDefined(piece))
		{
			continue;
		}
		
		if(distancesquared(player.origin,piece.origin) < 2500*2500)
		{
			player earthquake(.5,3,player.origin,1500);	
			player thread bio_breach_rumble(i);			
		}
		piece setmodel("p_zom_moon_biodome_hole_broken");
		
		//BioDome - spinning lights for breach
		level notify("sl9");
		level notify("sl10");		
	}
}

bio_breach_rumble(LocalClientNum)
{
	self endon("disconnect");
	
	for(i=0;i<10;i++)
	{
		self PlayRumbleOnEntity(LocalClientNum, "damage_heavy" );
		wait(randomfloatrange(.1,.2));
	}
}

digger_digging_earthquake_rumble(localClientNum, set,newEnt)
{
	
	if(localClientNum != 0)
	{
		return;
	}
				
	if(set)
	{
		for(i=0;i<level.localPlayers.size;i++)
		{
			level thread do_digger_digging_earthquake_rumble(i,self);
		}
		
	}
	else
	{
		self notify("stop_digging_rumble");
	}
}

//quake_ent = the excavator 'body' model ( the tracks )
//self= a player
do_digger_moving_earthquake_rumble(LocalClientNum,quake_ent)
{
		
	quake_ent endon("entityshutdown");	
	quake_ent endon("stop_moving_rumble");
	
	dist_sqd = 2500*2500;
	
	quake_ent.headlight1 = playfxontag(LocalClientNum,level._effect["exca_beam"],quake_ent,"tag_fx_headlight1");
	quake_ent.headlight2 = playfxontag(LocalClientNum,level._effect["exca_beam"],quake_ent,"tag_fx_headlight2");
	quake_ent.blink1 =  playfxontag(LocalClientNum,level._effect["exca_blink"],quake_ent,"tag_fx_blink1");
	quake_ent.blink2 =  playfxontag(LocalClientNum,level._effect["exca_blink"],quake_ent,"tag_fx_blink2");
	quake_ent.tread_fx = playfxontag(LocalClientNum,level._effect["digger_treadfx_fwd"],quake_ent,"tag_origin");
	
	player = getlocalplayers()[LocalClientNum];
	if(!isDefined(player))
	{
		return;
	}

	while(1)
	{
		
		if(!isDefined(player))
		{
			return;
		}
		
		player earthquake(randomfloatrange(0.15,0.25),3.0,quake_ent.origin, 2500);
		if( distancesquared(quake_ent.origin,player.origin) < dist_sqd)
		{
			player PlayRumbleOnEntity(LocalClientNum, "slide_rumble");
		}
		wait(randomfloatrange(.05,.15));
	}
		
}

//quake_ent = the excavator blade
do_digger_digging_earthquake_rumble(LocalClientNum,quake_ent)
{
	quake_ent endon("entityshutdown");
	quake_ent endon("stop_digging_rumble");
	level endon("stop_digger_rumble");
	
	player = getlocalplayers()[LocalClientNum];
	if(!isDefined(player))
	{
		return;
	}
	
	count = 0;
	dist = 1500*1500;
	
	while(1)
	{
		if(!isDefined(player))
		{
			return;
		}
		
		player earthquake(randomfloatrange(0.12,0.17),3.0,quake_ent.origin, 1500);
		if( (distancesquared(quake_ent.origin,player.origin) < dist) && abs(quake_ent.origin[2] - player.origin[2]) < 750)
		{
			player PlayRumbleOnEntity(LocalClientNum, "grenade_rumble");
		}
		wait(randomfloatrange(.1,.25));		
	}
		
}


digger_arm_fx(localClientNum, set,newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
				
	if(set)
	{
		for(i=0;i<level.localPlayers.size;i++)
		{
			level thread do_digger_arm_fx(i,self);
		}		
	}
	else
	{
		if(isDefined(self.blink1))
		{
			for(i=0;i<level.localPlayers.size;i++)
			{
				stopfx(i,self.blink1);
				stopfx(i,self.blink2);
				
			}	
		}
	}
}

do_digger_arm_fx(LocalClientNum,ent)
{
	ent endon("entityshutdown");
	
	player = getlocalplayers()[LocalClientNum];
	if(!isDefined(player))
	{
		return;
	}
	
	ent.blink1 =  playfxontag(LocalClientNum,level._effect["exca_blink"],ent,"tag_fx_blink3");
	ent.blink2 =  playfxontag(LocalClientNum,level._effect["exca_blink"],ent,"tag_fx_blink4");
 
}


hide_diggers()
{
	
	while(1)
	{
		level waittill("DH");
		for(i=0;i<level.localPlayers.size;i++)
		{
			level thread digger_visibility_toggle(i,"hide");
		}
	}
	
}

show_diggers()
{	
	while(1)
	{
		level waittill("DS");
		for(i=0;i<level.localPlayers.size;i++)
		{
			level thread digger_visibility_toggle(i,"show");
		}
	}	
}

digger_visibility_toggle(localclient,visible)
{
	diggers = GetEntArray(localclient,"digger_body","targetname");
	
	tracks = getentarray(localclient,"tracks","targetname");
	
	switch(visible)
	{
	
	case "hide":
		
		for(i=0;i<tracks.size;i++)
		{
			tracks[i] hide();
		}
		
		for(i=0;i<diggers.size;i++)
		{
			arm = GetEnt(localclient, diggers[i].target, "targetname");
			blade_center = GetEnt(localclient, arm.target, "targetname");
			blade = GetEnt(localclient, blade_center.target,"targetname");
			
			diggers[i] hide();
			arm hide();
			blade hide();
		}
		
		break;
		
	case "show":
		
		for(i=0;i<tracks.size;i++)
		{
			tracks[i] show();
		}
		
		for(i=0;i<diggers.size;i++)
		{
			arm = GetEnt(localclient, diggers[i].target, "targetname");
			blade_center = GetEnt(localclient, arm.target, "targetname");
			blade = GetEnt(localclient, blade_center.target,"targetname");
			
			diggers[i] show();
			arm show();
			blade show();
		}		
		break;
	}
	
}


//CONSOLE STUFF

init_excavator_consoles()
{
	
	wait(15);
	
	for(index=0;index<level.localPlayers.size;index++)
	{
		level thread excavator_console(index,"tunnel");
		level thread excavator_console(index,"hangar");
		level thread excavator_console(index,"biodome");
	}
	
}

/*------------------------------------
self = local player
------------------------------------*/
excavator_console(LocalClientNum,name)
{
	//self endon("entityshutdown");
	
	player = getlocalplayers()[LocalClientNum];
	if(!isDefined(player))
	{
		println("**MOON_CLIENT** NO PLAYER : " + name + "_console");
	
		return;
	}
	
	console = getent(LocalClientNum,name + "_console","targetname");

	str_wait = undefined;
	str_off = undefined;
	
	switch(name)
	{
		case "tunnel":str_wait = "TCA";str_off = "TCO";break;
		case "hangar":str_wait = "HCA";str_off = "HCO";break;
		case "biodome":str_wait = "BCA";str_off = "BCO";break;
	}	
	console.dlight =  playfxontag(LocalClientNum,level._effect["panel_off"],console,"tag_origin");	

	while(1)
	{
		level waittill(str_wait);
		stopfx(LocalClientNum,console.dlight);
		console.dlight =  playfxontag(LocalClientNum,level._effect["panel_on"],console,"tag_origin");
		level waittill(str_off);
		stopfx(LocalClientNum,console.dlight);
		console.dlight =  playfxontag(LocalClientNum,level._effect["panel_off"],console,"tag_origin");
	
	}
}

stop_all_digger_rumble()
{
	level waittill("EDR");
	
	level notify("stop_digger_rumble");
	
}


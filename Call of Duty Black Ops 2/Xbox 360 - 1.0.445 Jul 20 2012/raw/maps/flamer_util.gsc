#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;

#insert raw\common_scripts\utility.gsh;

// ***END***  Net Friendly / Too many ents in snapshot spawning system ***END***   \\

random_offset(xoffset, yoffset, zoffset, minx, miny, minz)
{
	if (xoffset ==0)
	{
		xoffset =1;
	}
	if (yoffset ==0)
	{
		yoffset =1;
	}
	if (zoffset ==0)
	{
		zoffset =1;
	}
	if (isdefined(minx) )
	{
		x = randomintrange(minx, xoffset);
	}
	else
	{
		x = randomint(int(xoffset));
	}
	if (isdefined(miny) )
	{
		y = randomintrange(miny, yoffset);
	}
	else
	{
		y = randomint(int(yoffset));
	}
	if (isdefined(minz) )
	{
		z = randomintrange(minz, zoffset);
	}
	else
	{
		z = randomint(int(zoffset));
	}

	
	if (cointoss())
	{
		x = x*-1;
	}
	if (cointoss())
	{
		y = y*-1;
	}
	if (cointoss())
	{
		z = z*-1;
	}
	
	return (x,y,z);
}

continue_facing_object(target, ender)
{
	self endon (ender);
	vec = target.origin - self.origin;
	ang = vectortoangles(vec);
	self rotateto(ang, 0.8);
	self waittill ("rotatedone");
	while(1)
	{
		vec = target.origin - self.origin;
		ang = vectortoangles(vec);
		self rotateto(ang, 0.05);
	 	self waittill ("rotatedone");
	}
}

wait_and_setcandamage(time, state)
{
	wait time;
	self setcandamage(state);
}

wait_and_setclientflagasval(delay, val)
{
	wait delay;
	self setclientflagasval(val);
}

anim_first_frame_delayed(guy, myanim, delay)
{
	wait delay;
	self anim_first_frame(guy, myanim);
}

wait_and_playsoundatposition(delay, sound, position)
{
	wait delay;
	playsoundatposition ( sound, position );
}

wait_and_hide(time)
{
	self endon ("death");
	wait time;
	self Hide();
}

wait_and_kill(time, spot, ragdoll)
{
	self endon ("death");
	wait time;
	self killme(spot, ragdoll);
}

delete_on_notify(mynotify)
{
	self endon ("death");
	level waittill (mynotify);
	self delete();
}

delete_on_ent_notify(myent, mynotify)
{
	myent waittill (mynotify);
	self delete();
}

delete_after_trig(time)
{
	self endon ("death");
	self waittill ("trigger");
	wait time;
	self delete();
}

wait_and_delete(time, do_ConnectPaths)
{
	self endon ("death");
	if (isdefined(time))
	{
		wait time;
	}
	if (IsDefined(do_ConnectPaths) )
	{
		self ConnectPaths();
	}
	
	self delete();
}

wait_and_change_text(time, text)
{
	self notify ("reset_textchange");
	self endon ("reset_textchange");
	wait 1;
	self settext(text);
}

setflag_ontrig(myflag)
{
	//level endon (myflag);
	self waittill ("trigger");
	flag_set(myflag);
}

setflag_on_notify(mynotify,myflag)
{
	//level endon (myflag);
	level waittill (mynotify);
	flag_set(myflag);
}

wait_and_print(time, text, ender, doPrintLn)
{
	if (isdefined(ender))
	{
		level endon (ender);
	}
	wait time;
	if (IsDefined(doPrintLn))
	{
		iprintln(text);
		return;
	}
	iprintlnbold(text);
}
	
objective_follow_target(num, ender, flash)
{
	self endon (ender);
	counter = 0;
	while(1)
	{
		Objective_Position( num, self.origin );
		wait 0.05;
		counter++;
		if (counter ==20 && isdefined(flash) )
		{
			counter = 0;
			//Objective_Ring(num);
		}
	}
}

tp_to_start(eventname, hero_spawners_eventname)
{
	level.skipto = eventname;
	if (!IsDefined(hero_spawners_eventname))
	{
		hero_spawners_eventname = eventname;
	}
	struct_spawn(hero_spawners_eventname+"_hero_struct_spawners");
	
	squad = GetAIArray("allies");
	players = get_players();
	event3_players_start = getstructarray(eventname+"_playerstart", "targetname");
	for (i=0; i < players.size; i++)
	{
		players[i] EnableInvulnerability();
		players[i] setOrigin(event3_players_start[i].origin+(0,0,-10000) );
		players[i] setplayerangles( event3_players_start[i].angles);
	}
	wait 0.05;
	squad_start_spots = getstructarray(eventname+"_squadstart", "targetname");
	for( i=0; i < squad.size; i++ )
	{
		if (IsDefined(squad_start_spots[i]))
		{
			squad[i] teleport(squad_start_spots[i].origin, squad_start_spots[i].angles);
		}
	}
	wait 0.05;
	for (i=0; i < players.size; i++)
	{
		players[i] setOrigin(event3_players_start[i].origin);
		players[i] setplayerangles( event3_players_start[i].angles);
		wait 0.1;
		players[i] DisableInvulnerability();
	}
}

solo_set_pacifist(pacifist_state)
{
	self endon ("death");
	if (isdefined(self) && isai(self))
	{
		self.pacifist = pacifist_state;
		if (pacifist_state == false)
		{
			self.maxsightdistsqrd = 90000000;
			self stopanimscripted();
			self.ignoreme = false;
			self.ignoreall = false;
			self.script_sightrange = 90000000;
			self reset_run_anim();
		}
	}
}

reset_run_anim()
{
	self endon ("death");
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}

killme(spot, ragdoll)
{
	if (!IsDefined(self) || !IsAlive(self))
	{
		return;
	}
	
	eye = self GetEye();
	
	if (	IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield == true )
	{
		self stop_magic_bullet_shield();
	}
	
	if (isai(self))
	{
		
		if (IsDefined(ragdoll))
		{
			self ragdoll_death();
		}
		
		if (isdefined(spot))
		{
			
			if (isvec(spot))
			{
				BulletTracer(spot, eye, 1);
				MagicBullet("fnfal_sp", spot, eye );
			}
			
			else
			{
				BulletTracer(spot.origin, eye, 1);
				MagicBullet("fnfal_sp", spot, eye );
			}
			
		}
		if (!IsDefined(ragdoll))
		{
			self stopanimscripted();
			self dodamage(99999, (0,0,0));
		}
		return;
		
	}
	
	self dodamage(99999, (0,0,0));

}

killus(guys, time)
{
	if (isdefined(time))
	{
		for( i=0; i < guys.size; i++ )
		{
			guys[i] thread wait_and_kill(time);
		}
	}
	else
	{
		for( i=0; i < guys.size; i++ )
		{
			guys[i] killme();
		}
	}
}
		

killspawner_on_trigger(num)
{
	self waittill ("trigger");
	wait 2;
	kill_spawnernum(num);
}

move_with(thing, ender, offset)
{
	level endon (ender);
	while(1)
	{
		if (IsDefined(offset))
		{
			dest = thing.origin + offset;
			self.origin = dest;
		}
		else
		{
			self.origin = thing.origin;
		}
		wait 0.05;
	}
}

move_along_with(thing, ender, offset, tag)
{
	level endon (ender);
	while(1)
	{
		if (IsDefined(offset))
		{
			dest = thing.origin + offset;
			self moveto (dest, 0.05);
			self waittill ("movedone");
		}
		else if (IsDefined(tag))
		{
			dest = thing GetTagOrigin(tag);
			self moveto (dest, 0.05);
			self waittill ("movedone");
		}
		else
		{
			self moveto (thing.origin, 0.05);
			self waittill ("movedone");
		}
	}
}


trigger_on_clear(aigroup, delay)
{
	self endon ("trigger");
	if (!isdefined(self))
		return;
	
	if (IsArray(aigroup))
	{
		for (i=0; i < aigroup.size; i++)
		{
			waittill_aigroupcleared(aigroup[i]);
		}
	}
	else
	{
		waittill_aigroupcleared(aigroup);
	}
	if (IsDefined(delay))
	{
		wait delay;
	}
	self UseBy (level.player);
}


	
keep_angles(thing, ender)
{
	level endon (ender);
	thing endon (ender);
	while(1)
	{
		self RotateTo(thing.angles, 0.5);
		self waittill ("rotatedone");
	}
}

repeat_text(text, ender, time)
{
	level endon (ender);
	while(1)
	{
		iprintln(text);
		wait time;
	}
}

billboard_fadeout()
{
	level.billboardBlack FadeOverTime( 2 );
	level.billboardBlack.alpha = 0;

	level.billboardWhite FadeOverTime( 2 );
	level.billboardWhite.alpha = 0;

	//rest is text
	level.billboardName FadeOverTime( 2 );
	level.billboardName.alpha = 0;

	level.billboardType FadeOverTime( 2 );
	level.billboardType.alpha = 0;

	level.billboardSize FadeOverTime( 2 );
	level.billboardSize.alpha = 0;
}

billboard_appear()
{
	level.billboardBlack FadeOverTime( 1 );
	level.billboardBlack.alpha = 0.3;

	level.billboardWhite FadeOverTime( 1 );
	level.billboardWhite.alpha = 0.3;

	//rest is text
	level.billboardName FadeOverTime( 1 );
	level.billboardName.alpha = 1;

	level.billboardType FadeOverTime( 1 );
	level.billboardType.alpha = 1;

	level.billboardSize FadeOverTime( 1 );
	level.billboardSize.alpha = 1;
}

stop_running()
{
	self waittill ("goal");
	self solo_set_pacifist(false);
}

getstructent(value, key, model, dontsave)
{
	spot1 = undefined;
	if ( !IsDefined(key))
	{
		key = "targetname";
	}	
	spots = getentarray(value, key);
	if (spots.size == 1)
	{
		spot1 = getent(value, key);
	}
	if (isdefined(spot1) && !isdefined(dontsave) )
	{
		return spot1;
	}
	spot1 = getstruct(value, key);
	if (isdefined(model))
	{
		spot2 = spawn ("script_model", spot1.origin);
		spot2 setmodel(model);
	}
	else
	{
		spot2 = spawn ("script_origin", spot1.origin);
	}
	if (isdefined(spot1.angles))
	{
		spot2.angles = spot1.angles;
	}
	
	if (IsDefined(spot1.target))
	{
		spot2.target = spot1.target;
	}
	
	if (key == "targetname")
	{
		spot2.targetname = value;
	}
	if (key == "script_noteworthy")
	{
		spot2.script_noteworthy = value;
	}
	
	return spot2;
}

text_display(text, time, x,y,ender, scale, flashrate )
{
	if (!IsDefined(level._mytextdisplay))
	{
		level._mytextdisplay = newClientHudElem( get_players()[0] );
	}
	
	level._mytextdisplay.x = 0; 
	level._mytextdisplay.y = 25;
	level._mytextdisplay.alignX = "left";
	level._mytextdisplay.alignY = "top";
	level._mytextdisplay.horzAlign = "left";
	level._mytextdisplay.vertAlign = "top";
	level._mytextdisplay.fontScale = 1.25;

	if (IsDefined(x))
	{
		level._mytextdisplay.x = x;
	}
	if (IsDefined(y))
	{
		level._mytextdisplay.y = y;
	}
	
	if (IsDefined(scale))
	{
		level._mytextdisplay.fontScale = scale;
	}
	
	level._mytextdisplay settext(text);
	level._mytextdisplay endon ("death");
	
	if (IsDefined(flashrate))
	{
		level._mytextdisplay thread flash_text(flashrate, ender);
	}
	else
	{
		level._mytextdisplay notify ("stop_flashing");
	}
	
	if (IsDefined(ender))
	{
		level._mytextdisplay thread destroy_on_notify(ender, level);
	}
	
	if (IsDefined(time))
	{
		wait time;
		level._mytextdisplay Destroy();
	}

}

a_text_display(text, time, x,y,ender, scale, flashrate, color)
{
	_mytextdisplay = newClientHudElem( get_players()[0] );
	_mytextdisplay.alignX = "right"; 
	
	
	_mytextdisplay.x = 0; 
	_mytextdisplay.y = 25;
	_mytextdisplay.alignX = "left";
	_mytextdisplay.alignY = "top";
	_mytextdisplay.horzAlign = "left";
	_mytextdisplay.vertAlign = "top";
	_mytextdisplay.fontScale = 1.25;

	if (IsDefined(color))
	{
		_mytextdisplay.color = color;
	}

	if (IsDefined(x))
	{
		_mytextdisplay.x = x;
	}
	if (IsDefined(y))
	{
		_mytextdisplay.y = y;
	}
	
	if (IsDefined(scale))
	{
		_mytextdisplay.fontScale = scale;
	}
	
	_mytextdisplay settext(text);
	_mytextdisplay endon ("death");
	
	if (IsDefined(time))
	{
		wait time;
		_mytextdisplay Destroy();
	}

	if (IsDefined(ender))
	{
		_mytextdisplay thread destroy_on_notify(ender, level);
	}

	return _mytextdisplay;

}

a_safe_text_display(text, x, y, ender, scale, alignX, alignY, horzAlign, vertAlign )
{
	_mytextdisplay = newClientHudElem( get_players()[0] );
	
	
	_mytextdisplay.x = 0; 
	_mytextdisplay.y = 25;
	_mytextdisplay.alignX = alignX;
	_mytextdisplay.alignY = alignY;
	_mytextdisplay.horzAlign = horzAlign;
	_mytextdisplay.vertAlign = vertAlign;
	_mytextdisplay.fontScale = 1.1;

	if (IsDefined(x))
	{
		_mytextdisplay.x = x;
	}
	if (IsDefined(y))
	{
		_mytextdisplay.y = y;
	}
	
	if (IsDefined(scale))
	{
		_mytextdisplay.fontScale = scale;
	}
	
	_mytextdisplay settext(text);
	_mytextdisplay endon ("death");
	

	if (IsDefined(ender))
	{
		_mytextdisplay thread destroy_on_notify(ender, level);
	}

	return _mytextdisplay;

}

flash_text(flashrate, ender)
{
	self notify ("running_flash_text");
	self endon ("running_flash_text");
	
	self endon ("stop_flashing");
	level endon (ender);
	while(1)
	{
		self FadeOverTime(flashrate);
		self.alpha = 0.2;
		wait flashrate;
		self FadeOverTime(flashrate);
		self.alpha = 1; 
		wait flashrate;
	}
}
	

destroy_on_notify(mynotify, notifyent, second_notify, third_notify)
{
	self notify ("running_destroy_on_notify");
	self endon ("running_destroy_on_notify");
	
	if (isdefined(second_notify) && !isdefined(third_notify))
	{
		third_notify = "placeholder_notify_dontask";
	}
	
	self endon ("death");
	if (IsDefined(notifyent))
	{
		if (isdefined(second_notify))
			notifyent waittill_any(mynotify, second_notify, third_notify);
		else
			notifyent waittill (mynotify);
	}
	else
	{
		if (isdefined(second_notify))
			self waittill_any(mynotify, second_notify, third_notify);
		else
			self waittill (mynotify);
	}
	self Destroy();
}

debug_ai()
{
	level thread debug_delete_ai();
	level.ai_info = NewHudElem(); 
	level.ai_info.alignX = "right"; 
	level.ai_info.x = 85; 
	level.ai_info.y = 430;

		while( 1 )
		{
		
			axis_ai = GetAiArray( "axis" );
			allied_ai = GetAiArray( "allies" );
			neutral_ai = GetAiArray( "neutral" );
			
			if( axis_ai.size + allied_ai.size >= 30 )
			{
				level.ai_info.color = (1,0,0);
			}
			else
			{
				level.ai_info.color = (1,1,1);
			}
			
			level.ai_info settext( "axis: " + axis_ai.size + "  allies: " + allied_ai.size + " neutral: " + neutral_ai.size + "  total: " + GetAIArray().size  );
		
			if (GetAIArray().size > 31)
			{
				IPrintLnBold(" TOO MANY AI ");
			}
			
			wait 0.6;
		
		}

}

trig_on_aiclear(group, mynotify, time)
{
	waittill_aigroupcleared(group);
	if (isdefined(time))
	{
		wait time;
	}
	if (isdefined(mynotify))
	{
		self notify (mynotify);
	}
	else
	{
		self notify ("trigger");
	}
}	

make_a_tag_origin(myorigin, myangles)
{
	spot = spawn ("script_model", myorigin);
	if (isdefined(myangles))
	{
		spot.angles = myangles;
	}
	spot setmodel("tag_origin");
	return spot;
}

spawn_a_model(model, myorigin, myangles)
{
	spot = spawn ("script_model", myorigin);
	if (isdefined(myangles))
	{
		spot.angles = myangles;
	}
	spot setmodel(model);
	return spot;
}

trig_thread(thing, func)
{
	self waittill ("trigger");
	thing thread [[func]]();
}
	
trig_notify(key, value)
{
	trig = getent(key, value);
	trig notify ("trigger");
}

trig_on_trig(trig)
{
	self waittill ("trigger");
	trig notify ("trigger");
}

trig_on_notify(mynotify,thing, delay)
{
	self endon ("trigger");
	self endon ("death");
	
	if (IsDefined(thing))
	{
		thing waittill (mynotify);
	}
	else
	{
		level waittill (mynotify);
	}
	
	if (IsDefined(delay))
	{
		wait delay;
	}
	self notify ("trigger");
}

notify_on_notify(first_notify, thing, second_notify)	
{
	self waittill (first_notify);
	thing notify (second_notify);
}


notify_on_trigger(mynotify, thing )
{
	self waittill ("trigger");
	if (isdefined(thing))
	{
		thing notify (mynotify);
	}
	else
	{
		level notify (mynotify);
	}
}

ignore_on(paci)
{
	self.ignoreme = true;
	self.ignoreall = true;
	if (isdefined(paci))
	{
		self.pacifist = true;
	}
}

ignore_off()
{
	self.ignoreme = false;
	self.ignoreall = false;
	self.pacifist = false;
}

squared(dist)
{
	sq = dist*dist;
	return sq;
}

waittill_aigroupcleared(group) // just retaining the old function name,
{
	waittill_ai_group_cleared(group);
}

stalingradspawnsafe(force_em)
{
	self endon ("death");
	while(isdefined(self))
	{
		while(!oktospawn() && !isdefined(force_em) )
		{
			wait 0.05;
		}
		guy = self stalingradspawn();
		if (!spawn_failed(guy) )
		{
			return guy;
		}
		wait 0.05;
	}
}

stalingradspawnsafe_guys(value, key, force_em)
{
	if (!isdefined(force_em))
	{
		force_em = undefined;
	}
	
	spawners = getentarray(value, key);
	guys = [];
	for( i=0; i < spawners.size; i++ )
	{
		guys[i] = spawners[i] stalingradspawnsafe(force_em);
	}
	return guys;
}

camera_tweak()
{
	level endon ("stop_camera_tweak");
	player = get_players()[0];
	player endon ("death");
	
	while(1)
	{
		if ( player buttonpressed("BUTTON_RSHLDR") )
		{
			player = get_players()[0];
			spot = spawn ("script_model", player.origin);
			spot setmodel("tag_origin");
			wait 0.05;
			player playerlinktodelta(spot, "tag_origin", 1, 180, 180, 30, 40, true );
			waittime = 0.3;
			wait waittime;
			while(1)
			{
				if ( player buttonpressed("DPAD_DOWN") )
				{
					spot.origin = spot.origin+(0,1,0);
					wait waittime;
				}
				if ( player buttonpressed("DPAD_UP") )
				{
					spot.origin = spot.origin+(0,-1,0);
					wait waittime;
				}
				if ( player buttonpressed("DPAD_RIGHT") )
				{
					spot.origin = spot.origin+(-1,0,0);
					wait waittime;
				}
				if ( player buttonpressed("DPAD_LEFT") )
				{
					spot.origin = spot.origin+(1,0,0);
					wait waittime;
				}
				if ( player ThrowButtonPressed() )
				{
					spot.origin = spot.origin+(0,0, -1);
					wait waittime;
				}
				if ( player attackbuttonpressed() )
				{
					spot.origin = spot.origin+(0,0,1);
					wait waittime;
				}
				if ( player buttonpressed("BUTTON_RSHLDR") )
				{
					wait 0.3;
					break;
				}
				wait 0.05;
			}
		}
		wait 0.05;
	}
}


killme_ontrig(guy,time)
{
	guy endon ("death");
	self waittill ("trigger");
	if (isdefined(time))
	{
		wait time;
	}
	guy killme();
}

kill_on_notify(mynotify)
{
	self endon ("death");
	level waittill (mynotify);
	self killme();
}


ignore_till_goal()
{
	self endon ("death");
	self.ignoreall = true;
	self waittill ("goal");
	self.ignoreall = false;
}

delayearthquake( time,intensity, duration, location, myradius)
{
	wait time;
	earthquake(intensity, duration, location, myradius);
}

delay_setspeed(time, speed, accel, deccel)
{
	wait time;
	self setspeed( speed, accel, deccel);
}

func_on_trig(func, param1, param2, param3)
{
	self waittill ("trigger");
	if (isdefined(param3))
	{
		level thread [[func]] ( param1, param2, param3 );
	}
	else if (isdefined(param2))
	{
		 
		level thread [[func]] ( param1, param2 );
	}
	else if (isdefined(param1))
	{
		level thread [[func]] ( param1 );
	}
	else
	{	
		level thread [[func]]();
	}
}

func_on_notify(mynotify, func, param1, param2, param3)
{
	self waittill (mynotify);
	if (isdefined(param3))
	{
		level thread [[func]] ( param1, param2, param3 );
	}
	else if (isdefined(param2))
	{
		 
		level thread [[func]] ( param1, param2 );
	}
	else if (isdefined(param1))
	{
		level thread [[func]] ( param1 );
	}
	else
	{	
		level thread [[func]]();
	}
}


chain_anim_single_solo_aligned(guy, anim1, anim2, anim3, anim4)
{
	self anim_single_aligned(guy, anim1);
	self anim_single_aligned(guy, anim2);
	if (isdefined(anim3))
	{
		self anim_single_aligned(guy, anim3);
	}
	if (isdefined(anim4))
	{
		self anim_single_aligned(guy, anim4);
	}
}

find_my_guys(key)
{
	while(1)
	{
		print3d(self.origin+(0,0,70), key);
		wait 0.05;
	}
}


wait_and_show(time)
{
	wait time;
	self show();
}

wait_and_shake(time)
{
	wait time;
	Earthquake(0.8,0.5, get_players()[0].origin, 500);
	get_players()[0] PlayRumbleOnEntity("artillery_rumble");	
}

wait_and_shake_custom(time, scale, shaketime, rumble)
{
	wait time;
	Earthquake(scale,0.5, get_players()[0].origin, 1000);
	if (IsDefined(rumble))
	{
		get_players()[0] PlayRumbleOnEntity(rumble);
	}
}


stealth_checker()
{
	player = level.player;
	player endon ("stealthbreak");
	while( player AttackButtonPressed() == false ) 
	{
		if ( player isfiring() )
		{
			break;
		}
		if ( player isthrowinggrenade() )
		{
			break;
		}
		wait 0.1;
	}
	player notify ("stealthbreak");
}

origin_counter()
{
	while(1)
	{
		spots = getentarray("script_origin", "classname");
		trigs = getentarray("trigger_radius", "classname");
		trigs2 = getentarray("trigger_multiple", "classname");
		models = getentarray("script_model", "classname");
		brushes = getentarray("script_brushmodel", "classname");
		dest = getentarray("destructible", "targetname");
		
		angles = level.player getplayerangles();
		wait 2;
	}
}

is_in_place()
{
	self waittill ("goal");
	self._is_in_place = true;
}

/*ragdoll_death()
{
	self waittill ("death");
	self startragdoll();
}*/

delete_if_cantsee(thing, mynotify)
{
	self endon ("death");
	if (isdefined(thing) && isdefined (mynotify))
	{
		thing waittill (mynotify);
	}
	if ( !player_can_see_me( level.player ) )
	{
		self delete();
	}
}
	

player_can_see_me( player )
{
	playerAngles = player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );
	
	banzaiPos = self GetOrigin();
	playerPos = player GetOrigin();
	playerToBanzaiVec = banzaiPos - playerPos;
	playerToBanzaiUnitVec = VectorNormalize( playerToBanzaiVec );
	
	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToBanzaiUnitVec );
	angleFromCenter = ACos( forwardDotBanzai ); 

	playerFOV = GetDvarfloat( "cg_fov" );
	banzaiVsPlayerFOVBuffer = GetDvarfloat( "g_banzai_player_fov_buffer" );	
	if ( banzaiVsPlayerFOVBuffer <= 0 )
	{
		banzaiVsPlayerFOVBuffer = 0.2;
	}

	//println( "Banzai is " + angleFromCenter + " degrees from straight ahead. Player FOV is" + playerFOV );

	playerCanSeeMe = ( angleFromCenter <= ( playerFOV * 0.5 * ( 1 - banzaiVsPlayerFOVBuffer ) ) );
	
	return playerCanSeeMe;
}

exploder_on_trigger(num, delay)
{
	self waittill ("trigger");
	if (IsDefined(delay))
	{
		wait delay;
	}
	exploder(num);
}

Ent_can_see_me( Ent )
{
	EntAngles = Ent.angles;
	EntForwardVec = AnglesToForward( EntAngles );
	EntUnitForwardVec = VectorNormalize( EntForwardVec );
	
	MyPos = self GetOrigin();
	EntPos = Ent GetOrigin();
	EntToMyVec = MyPos - EntPos;
	EntToMyUnitVec = VectorNormalize( EntToMyVec );
	
	forwardDotMy = VectorDot( EntUnitForwardVec, EntToMyUnitVec );
	angleFromCEnter = ACos( forwardDotMy ); 

	EntFOV = GetDvarfloat( "cg_fov" );
	MyVsEntFOVBuffer = GetDvarfloat( "g_banzai_player_fov_buffer" );	
	if ( MyVsEntFOVBuffer <= 0 )
	{
		MyVsEntFOVBuffer = 0.2;
	}

	//println( "My is " + angleFromCEnter + " degrees from straight ahead. Ent FOV is" + EntFOV );

	EntCanSeeMe = ( angleFromCEnter <= ( EntFOV * 0.5 * ( 1 - MyVsEntFOVBuffer ) ) );
	
	return EntCanSeeMe;
}

movewith(thing,ender)
{
	level endon (ender);
	while(1)
	{
		self moveto(thing.origin, 0.05);
		self waittill ("movedone");
	}
}

hold_weapons_till_notify(mynotify)
{
	myweapons = self GetWeaponsList();
	myweaponscount = [];
	currentweapon = self GetCurrentWeapon();

	
	for (i=0; i < myweapons.size; i++)
	{
		myweaponscount[i] =  self GetWeaponAmmoStock( myweapons[i] );
		self TakeWeapon (myweapons[i]);
	}
	
	self waittill (mynotify);
	
	for (i=0; i < myweapons.size; i++)
	{
		self GiveWeapon (myweapons[i]);
		self SetWeaponAmmoStock( myweapons[i], myweaponscount[i]);
	}
	
	self SwitchToWeapon(currentweapon);
}

wait_for_use_button()
{
	breakme = 0;
	while(breakme == 0)
	{
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (players[i] usebuttonpressed() )
			{
				breakme = 1;
			}
		}
		wait 0.05;
	}
}

	// enables an array of spawn managers, pass through either script noteworthy and/or the array itself
enable_sms(sm_script_noteworthy, sms)
{
	//self waittill ("trigger");
	if (!IsDefined(sms))
	{
		sms = GetEntArray(sm_script_noteworthy, "script_noteworthy");
	}
	
	for (i=0; i < sms.size; i++)
	{
		sms[i] UseBy (get_players()[0]);
	}
}

wait_and_fireweapon(time, repeat)
{
	wait time;
	self FireWeapon();
	if (IsDefined(repeat))
	{
		repeat = repeat-1;
		for (i=0; i < repeat; i++)
		{
			self FireWeapon();
		}
	}
	
}

// just for reference on how to use this
is_part_of_name(largstr, partstr)
{
			// first just an example about how to use this
	/* 
	ai = GetAIArray();
	civilians = [];
	for (i=0; i < ai.size; i++)
	{
		if( IsSubStr( ToLower( ai[i].classname ), "civilian" ) )
		{
			civilians[civilians.size] = ai[i];
		}	
	}
	*/
	if( IsSubStr( ToLower(largstr), partstr ) )
	{
		return true;
	}	
	else
		return false;
	
		
}


button_unpressed(button)
{
	while(1)
	{
		if (!self ButtonPressed(button))
		{
			return true;
		}
		wait 0.05;
	}
}

setlookatent_delay(time, ent, ender)
{
	self endon ("death");
	if (IsDefined(ender) )
	{
		level endon (ender);
	}
	
	wait time;
	self SetLookAtEnt( ent);
}

clearlookatent_delay(time, ent, ender)
{
	self endon ("death");
	if (IsDefined(ender) )
	{
		level endon (ender);
	}
	
	wait time;
	self ClearLookAtEnt();
}

jitter(angle, frequency, time, type)
{
	times = time/frequency;
	
	times = Int(times/2);
	
	for (i=0; i < times; i++)
	{
		if (type == "roll")
		{
			self RotateRoll(angle, frequency);
			self waittill ("rotatedone");
			self RotateRoll(angle*-1, frequency);
			self waittill ("rotatedone");
		}
		if (type == "yaw")
		{
			self RotateYaw(angle, frequency);
			self waittill ("rotatedone");
			self RotateYaw(angle*-1, frequency);
			self waittill ("rotatedone");
		}
		if (type == "pitch")
		{
			self RotatePitch(angle, frequency);
			self waittill ("rotatedone");
			self RotatePitch(angle*-1, frequency);
			self waittill ("rotatedone");
		}
	}
}

/* GLocke 2/10/10 - moved this to _utility
average_origin(orgs)
{
	orgx = 0;
	orgy = 0;
	orgz = 0;
	
	for (i=0; i < orgs.size; i++)
	{
		orgx += orgs[0];
		orgy += orgs[1];
		orgz += orgz[2];
	}
	orgx = orgx / orgs.size;
	orgy = orgy / orgs.size;
	orgz = orgz / orgs.size;
	return ( (orgx, orgy, orgz) );
}
*/

undefined_delay(time, myvar)
{
	wait time;
	myvar = undefined;
}

increment_on_death(var, amount)
{
	self waittill ("death");
	if (IsDefined(amount))
	{
		var+= amount;
	}
	else
	{
		var++;
	}
}

delete_spawners_in_radius(spot, myradius)
{
	enemies = GetSpawnerTeamArray( "axis" );
	for (i=0; i < enemies.size; i++)
	{
		if (DistanceSquared(enemies[i].origin, spot) < (myradius*myradius) )
		{
			enemies[i] Delete();
		}
	}
}

seek_player(goalrad)
{
	self.goalradius = 128;
	if (IsDefined(goalrad))
	{
		self.goalradius = goalrad;
	}
	self SetGoalEntity( get_players()[0] );	
}

enable_nodes(key, value)
{
	nodes = GetNodeArray(key, value);
	enabler = GetEnt("node_enabler_disabler", "targetname");
	//enabler = Spawn("script_origin", (0,0,0) );
	
	for (i=0; i < nodes.size; i++)
	{
		enabler.origin = nodes[i].origin;
		wait 0.05;
		enabler ConnectPaths();
		wait 0.05;
	}
	enabler trigger_off();
}

disable_nodes(key, value)
{
	nodes = GetNodeArray(key, value);

	enabler = GetEnt("node_enabler_disabler", "targetname");
	//enabler = Spawn("script_origin", (0,0,0) );
	
	for (i=0; i < nodes.size; i++)
	{
		enabler.origin = nodes[i].origin;
		wait 0.05;
		enabler DisconnectPaths();
		wait 0.05;
	}
	enabler trigger_off();
}

anim_intro_then_loop(guy, introanim, loopanim, ender)
{
	guy endon ("death");
	if (!IsDefined(ender))
	{
		ender = "stoploop";
	}
	self endon (ender);
	
	self anim_single_aligned(guy, introanim);
	self anim_loop_aligned(guy, loopanim, undefined, ender);
}

anim_reach_then_loop(guy, introanim, loopanim, ender)
{
	guy endon ("death");
	if (!IsDefined(ender))
	{
		ender = "stoploop";
	}
	if (!IsDefined(introanim))
	{
		introanim = loopanim;
	}
	
	self endon (ender);
	
	self anim_reach_aligned(guy, introanim);
	self anim_loop_aligned(guy, loopanim, undefined, ender);
}



debug_delete_ai()
{
	while(1)
	{
		if (get_players()[0] ButtonPressed("DPAD_UP") 
		&& get_players()[0] ButtonPressed("BUTTON_RSHLDR") 
		&& get_players()[0] UseButtonPressed() )
		{
			axis = GetAIArray("axis");
			for (i=0; i < axis.size; i++)
			{
				axis[i] Delete();
			}
		}
		if (get_players()[0] ButtonPressed("DPAD_UP") 
		&& get_players()[0] ButtonPressed("BUTTON_LSHLDR") 
		&& get_players()[0] UseButtonPressed() )
		{
			allies = GetAIArray("allies");
			for (i=0; i < allies.size; i++)
			{
				allies[i] Delete();
			}
		}
		wait 1;
	}
}
		
		
hide_and_show(time)
{
	self Hide();
	wait time;
	self Show();
}

goal_when_cantsee()
{
	self endon("goal");
	self endon("death");

	while(1)
	{
		wait 0.1;
		if (!self player_can_see_me(get_players()[0]) )
		{
			self notify ("goal");
		}

	}
}
			
			
pulsing_hud(ender)
{

	ender = "stop_pulsing_hud";
	level thread notify_delay("stop_pulsing_hud", 3.7);
	
	if (!IsDefined(level._my_pulsing_hud))
	{
		level._my_pulsing_hud = newClientHudElem( get_players()[0] );
		
	}
	
	if (IsDefined(ender))
	{
		level endon(ender);
		level._my_pulsing_hud thread destroy_on_notify(ender, level);
	}
	

	
	
	text = &"HUE_CITY_X_BUTTON";
	size_min = 2;
	size_max = 3.5;

	level._my_pulsing_hud.x = 320; 
	level._my_pulsing_hud.y = 150;
	level._my_pulsing_hud.alignX = "left";
	level._my_pulsing_hud.alignY = "top";
	level._my_pulsing_hud.horzAlign = "left";
	level._my_pulsing_hud.vertAlign = "top";
	level._my_pulsing_hud.fontScale = size_min;
	level._my_pulsing_hud SetText(text);
	
	size_max_org = size_max;
	size_min_org = size_min;
	
	level thread button_count_timer(ender);
	
	while(1)
	{
		while(level._my_pulsing_hud.fontScale < size_max)
		{
			level._my_pulsing_hud.fontScale += .2;
			size_max = size_max_org - (level._button_press_counts *0.5);
			size_min = size_min_org - (level._button_press_counts *0.2);
			wait 0.05;
		}
		while(level._my_pulsing_hud.fontScale > size_min)
		{
			size_max = size_max_org - (level._button_press_counts *0.5);
			size_min = size_min_org - (level._button_press_counts *0.2);
			level._my_pulsing_hud.fontScale -= .2;
			wait 0.05;
		}
	}
}



button_count_timer(ender)
{
	level endon (ender);
	level thread button_counts_permin(ender);
	level._button_press_counts = 0;
	
	while(1)
	{
		level._button_press_per_sec = 0;
		wait 0.2;			
		level._button_press_counts = level._button_press_per_sec + 1;
	}
}
		

button_counts_permin( ender)
{
	level endon (ender);
	level._total_button_press_counts = 0;
	level._button_press_per_sec = 0;
	
	while(1)
	{
		waited = 0;
		if (get_players()[0] UseButtonPressed() )
		{
			level._total_button_press_counts++;
			level._button_press_per_sec++;
		}
		
		if (level._button_press_per_sec > 3)
		{
			level._button_press_per_sec = 3;
		}
		
		wait 0.05;
	}
}

fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	get_players()[0] setblur( blur, duration );
	wait duration;
}

player_speed_set(speed, time)
{
	currspeed = int( GetDvar( "g_speed" ) );
	goalspeed = speed;
	if (IsDefined(level._player_speed_modifier ) )
	{
		goalspeed = speed * level._player_speed_modifier ;
	}
	
	
	if( !isdefined( self.g_speed ) )
		self.g_speed = currspeed;     
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;          
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
    setsaveddvar( "g_speed", int(currspeed) );
  	wait interval;
	}
  setsaveddvar( "g_speed", goalspeed );
}

glass_only_player_can_break()
{
	trigs = GetEntArray("glass_only_player_can_break_trig", "targetname");
	for (i=0; i < trigs.size; i++)
	{
		trigs[i] thread delete_on_hit_by_player();
	}
}
	
delete_on_hit_by_player()
{
	while(1)
	{
		self waittill ("damage", amount, who);
		if (IsPlayer(who))
		{
			clip = GetEnt(self.target, "targetname");
			level notify ("only_player_window_broke", clip.origin);
			clip Delete();
			self Delete();
			return;
		}
	}
}

vehicle_delete()
{
	self notify ("nodeath_thread");
	self Delete();
}

adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[0];
	ra = stumble_angles[2];

	rv = AnglesToRight( self.angles );
	fv = AnglesToForward( self.angles );

	rva = ( rv[0], 0, rv[1]*-1 );
	fva = ( fv[0], 0, fv[1]*-1 );
	angles = ( rva * pa );
	angles = angles + ( fva * ra );
	return angles + ( 0, stumble_angles[1], 0 );
}

random_int_not_in_array(min, max, array)
{
	counter = 0;
	while(1)
	{
		counter++;
		num = RandomIntRange(min, max);
		if ( !is_in_array(array, num))
		{
			return num;
		}
		if (counter == 10)
		{
			wait 0.05;
		}
		if (counter == 200)
		{
			for (i=min; i < max; i++)
			{
				if ( !is_in_array(array, i))
				{
					return i;
				}
			}
			assert( !IsDefined(i), "All numbers in array have been used");
			return min;
		}
	}
}

find_halfway_point(spot1, spot2, return_offset)
{
	dist = Distance(spot1, spot2);
	vec = spot1 - spot2;
	nvec = VectorNormalize(vec);
	halfway_point = spot1 + (nvec * (dist /2)) ;
	
	if (IsDefined(return_offset))
	{
		halfway_point = halfway_point + return_offset;
	}
	return halfway_point;
}
	
	
timescale_fadeup(target_timescale,delay)
{
	current_timescale = GetTimeScale();
	if (!IsDefined(target_timescale))
	{
		target_timescale = 1;
	}
	
	if (IsDefined(delay))
	{
		wait delay;
	}

	
	while( current_timescale < target_timescale)
	{
		current_timescale = current_timescale + 0.1;
		SetTimeScale (current_timescale);
		wait 0.05;
		
	}
	SetTimeScale(target_timescale);
}

timescale_fadedown( target_timescale,delay)
{
	current_timescale = GetTimeScale();
	if (IsDefined(delay))
	{
		wait delay;
	}

	while( current_timescale > target_timescale)
	{
		current_timescale = current_timescale - 0.1;
		SetTimeScale (current_timescale);
		wait 0.05;
		
	}
	SetTimeScale(target_timescale);
}

wtf_am_i( ender)
{
	if (IsDefined(ender))
	{
		level endon (ender);
	}
	hud = a_text_display(self.origin);
	while(1)
	{
		hud SetText(self.origin);
		wait 0.05;
	}
}

stopanim_and_kill(guy, killnotify, anim_ender)
{
	guy endon ("death");
	level waittill (killnotify);
	if (IsDefined(anim_ender))
	{
		self notify (anim_ender);
	}
	
	guy StopAnimScripted();

	guy killme();	
	guy Delete();
}



anim_spot_finder(guy, myanim)
{
	spot = Spawn("script_origin", self.origin);
	spot.angles = self.angles;
	
	SetDvar("civ_originx", spot.origin[0]);
	SetDvar("civ_originy", spot.origin[1]);
	SetDvar("civ_originz", spot.origin[2]);
	
	SetDvar("civ_anglex", spot.angles[0]);
	SetDvar("civ_angley", spot.angles[1]);
	SetDvar("civ_anglez", spot.angles[2]);
	
	
	if (!IsDefined(guy.magic_bullet_shield))
	{
		guy thread magic_bullet_shield();
	}
	
	while(1)
	{
		spotx = Int(GetDvar("civ_originx"));
		spoty = Int(GetDvar("civ_originy"));
		spotz = Int(GetDvar("civ_originz"));
	
		angx = Int(GetDvar("civ_anglex"));
		angy = Int(GetDvar("civ_angley"));
		angz = Int(GetDvar("civ_anglez"));
		
		
		spot.origin = (spotx, spoty, spotz);
		spot.angles = (angx, angy, angz);
		spot anim_single_aligned(guy, myanim);
	}

}


spot_finder()
{
	
	spot = self;
	if (self.classname == "script_struct") 
	{
		spot = Spawn("script_origin", self.origin);
		spot.angles = self.angles;
	}
	
	SetDvar("spot_orgx", spot.origin[0]);
	SetDvar("spot_orgy", spot.origin[1]);
	SetDvar("spot_orgz", spot.origin[2]);
	
	SetDvar("spot_angx", spot.angles[0]);
	SetDvar("spot_angy", spot.angles[1]);
	SetDvar("spot_angz", spot.angles[2]);
	
	
	while(1)
	{
		spotx = Int(GetDvar("spot_orgx"));
		spoty = Int(GetDvar("spot_orgy"));
		spotz = Int(GetDvar("spot_orgz"));
	
		angx = Int(GetDvar("spot_angx"));
		angy = Int(GetDvar("spot_angy"));
		angz = Int(GetDvar("spot_angz"));
		
		
		spot.origin = (spotx, spoty, spotz);
		spot.angles = (angx, angy, angz);
		wait 0.05;
	}

}


wait_and_fire_shots(time, shotspot, hitspot, shots_fired, delay, weapon, killme)
{
	if (!IsDefined(shots_fired))
	{
		shots_fired = 3;
	}
	if (!IsDefined(delay))
	{
		delay = 0.1;
	}
	if (!IsDefined(weapon))
	{
		weapon = "fnfal_sp";
	}

	wait time;
	if (!IsDefined(hitspot))
	{
		hitspot = self.origin + (0,0,55);
	}
	
	for (i=0; i < shots_fired; i++)
	{
		MagicBullet(weapon, shotspot, hitspot);
		vec = hitspot - shotspot;
		nvec = VectorNormalize(vec);
		tracer_end = hitspot + (nvec*100);
		BulletTracer(shotspot, tracer_end, 1);
		
		wait delay;
	}
	
	if (IsDefined(killme))
	{
		self killme();
	}
}


player_look_at_me(mytime, dont_lowerweapon)
{
	if (!IsDefined(mytime))
	{
		mytime = 0.5;
	}
	waittime = mytime;
	
	get_players()[0] AllowProne(false);
	get_players()[0] AllowCrouch(false);
	while( get_players()[0] GetStance() != "stand")
	{
		wait 0.05;
	}
		
	linker = spawn_a_model("tag_origin", get_players()[0].origin, get_players()[0].angles);
	vec = self.origin - get_players()[0].origin;
	
	if (!IsDefined(dont_lowerweapon))
	{
		get_players()[0] DisableWeapons();
		waittime += 0.2;
	}
	
	get_players()[0] lerp_player_view_to_position(linker.origin, linker.angles, 0.05);
	get_players()[0] PlayerLinkToAbsolute (linker, "tag_origin");
	
	
	ang = VectorToAngles(vec);
	linker RotateTo(ang, mytime);
	linker moveto(linker.origin + (0,0,4), mytime);
	time = mytime+ 0.2;
	override_player_look_at_me(time);
	
	get_players()[0] Unlink();
	get_players()[0] EnableWeapons();
	get_players()[0] AllowProne(true);
	get_players()[0] AllowCrouch(true);
	
	linker Delete();
}

override_player_look_at_me(time, ender)
{
	level endon ("stop_playerlook_override");
	counter = 0;
	
	while(counter < time)
	{
		counter += 0.05;
		score = get_players()[0] control_score( "right", 1, 1, 1, 1 );
		if (IsDefined(score) && score > 0.3)
		{
			return;
		}
		wait 0.05;
	}
}


trig_burn_u()
{
	//trig notify ("newthread");
	self endon ("death");
	
	if( !IsDefined( level.burning_sound_ent ) )
        level.burning_sound_ent = Spawn( "script_origin", (0,0,0) );

	player = get_players()[0];
	
	while(1)
	{
		if ( player istouching(self) )
		{
			level.burning_sound_ent PlayLoopSound( "chr_burning_loop", .5 );
			level.burning_sound_ent thread stop_burning_loop();
			playsoundatposition( "vox_plr_burning_pain", (0,0,0) );
			//get_players()[0] setburn(0.5);
			player setblur(2,0.6);
			wait 0.3;
			player dodamage(20, self.origin);
			wait 0.3;
			player setblur(0,0.1);
		}
		wait 0.1;
	}
}

stop_burning_loop()
{
    self notify( "force_stop" );
    self endon( "force_stop" );
    
    wait(1);
    self StopLoopSound( 1 );
}

shuffle_array(array)
{
	temparray = [];
	tempentry = undefined;

	
	for (i=0; i < array.size; i++)
	{
		tempentry = undefined;
		failsafe = 0;
		
		while( !IsDefined(tempentry) )
		{
			failsafe++;
			tempentry = array[RandomInt(array.size)];
			if (is_in_array( temparray, tempentry ))
			{
					tempentry = undefined;
			}
			
			if (failsafe > 200)
			{
				for (j=0; j < array.size; j++)
				{
					if (!is_in_array( temparray, array[j] ) )
					{
						tempentry = array[j];
						break;
					}
				}
			}
		}
		ARRAY_ADD(temparray, tempentry);
	}
	
	assert(temparray.size == array.size , "The return array is not the same size as the given array");
	return temparray;
}

sort_high_to_low(array)
{
	sorted = [];
	rightsize = array.size;
	
	while(sorted.size < rightsize)
	{
		highest = array[0];
		for (i=0; i < array.size; i++)
		{
			if ( array[i].origin[2] > highest.origin[2])
			{
				highest = array[i];
			}
		}
		ARRAY_ADD(sorted, highest);
		array = array_remove(array, highest);
	}
	return sorted;
}

sort_ints_low_to_high(array)
{
	sorted = [];
	rightsize = array.size;
	
	while(sorted.size < rightsize)
	{
		lowest = array[0];
		for (i=0; i < array.size; i++)
		{
			if ( array[i] <  lowest)
			{
				lowest = array[i];
			}
		}
		ARRAY_ADD(sorted, lowest);
		array = array_remove(array, lowest);
	}
	return sorted;
}

out_of_cqb_until_near_goal(dist)
{
	self endon ("death");
	if (!IsDefined(dist))
	{
		dist = 200;
	}
	
	self reset_movemode();
	while(DistanceSquared(self.origin, self.goalpos) > (dist*dist) )
	{
		wait 0.1;
	}
	
	self change_movemode("cqb");
}

struct_spawn_trigger()
{
	self endon ("death");
	self waittill ("trigger");
	if (IsDefined(self.target))
	{
		level thread struct_spawn(self.target);
	}
}

struct_spawn(targetname, spawn_func, param1, param2, param3, param4, param5)
{
	struct_spawners = undefined;
	if (IsString(targetname))
	{
		struct_spawners = getstructarray(targetname, "targetname");
	}
	else if (!IsArray(targetname) )
	{
		struct_spawners = [];
		ARRAY_ADD(struct_spawners,targetname);
		targetname = targetname.targetname;
	}
	else if (IsArray(targetname))
	{
		struct_spawners = targetname;
		targetname = struct_spawners[0].targetname;
	}
	assert(IsDefined(struct_spawners), "Spawner array not defineed in struct_spawn");
		
	guys = [];
	
	for (i=0; i < struct_spawners.size; i++)
	{
		guy = undefined;
			
		struct_spawner = struct_spawners[i];
		if (!IsDefined(struct_spawner.script_string))
		{
			continue;
		}
		
		myspawner = GetEnt(struct_spawner.script_string, "targetname");
		
		struct_spawner script_delay();

		while(!IsDefined(guy))
		{
			guy = simple_spawn( myspawner )[0];
			wait 0.05;
		}
		
		guy forceteleport(struct_spawner.origin);
		guy.targetname = targetname+"_ai";
		guy pass_attributes(struct_spawner);
		
		if (IsDefined( spawn_func ))
		{
			single_thread(guy, spawn_func, param1, param2, param3, param4, param5);
		}
		ARRAY_ADD(guys, guy);		
	}
	return guys;
}
	
pass_attributes(passer)
{
	if (IsDefined(passer.script_noteworthy))
	{
		self.script_noteworthy = passer.script_noteworthy;
	}
	if (IsDefined(passer.script_spawner_targets))
	{
		self.script_spawner_targets = passer.script_spawner_targets;
	}
	if (IsDefined(passer.script_animname))
	{
		self.animname = passer.script_animname;
	}
	if (IsDefined(passer.script_killspawner))
	{
		self.script_killspawner = passer.script_killspawner;
	}
	if (IsDefined(passer.script_aigroup))
	{
		self.script_aigroup = passer.script_aigroup;
	}
	if (IsDefined(passer.script_grenades))
	{
		self.grenadeammo = passer.script_grenades;
	}
	if (IsDefined(passer.script_nodropweapon))
	{
		self.script_nodropweapon = passer.script_nodropweapon;
	}
	if (IsDefined(passer.script_allowdeath))
	{
		self.allowdeath = passer.script_allowdeath;
	}
	if (IsDefined(passer.script_forcecolor))
	{
		self set_force_color( passer.script_forceColor );

		if( !IsDefined( self.script_no_respawn ) || self.script_no_respawn < 1 )
		{
			self thread replace_on_death();
		}
	}
	if (IsDefined(passer.target))
	{
		self.target = passer.target;
		if (IsDefined(GetNode(self.target, "targetname") ) )
		{
			self SetGoalNode(GetNode(self.target, "targetname") );
		}
	}
	if (IsDefined(passer.script_radius))
	{
		self.goalradius = passer.script_radius;
	}
	if (IsDefined(passer.script_nodropweapon) )
	{
		self.dropweapon = 0;
	}
}


threatbias_debug()
{
	tb_group_huds = [];
	tb_defined_huds = [];
	
	while(1)
	{
		all_tb_groups = get_all_threatbias_groups();

		
		for (i=0; i < all_tb_groups.size; i++) // create hud elem saying all TB groups
		{
			if (!IsDefined(tb_group_huds[i]) )
			{
				tb_group_huds[i] = a_text_display (all_tb_groups[i], undefined, 20, 200+(i*10) );
			}
			tb_group_huds[i] SetText(all_tb_groups[i]);
		}
		for (i=0; i < tb_group_huds.size; i++)	// make sure to delete old ones
		{
			if (!IsDefined(all_tb_groups[i]) && IsDefined(tb_group_huds[i]) )
			{
				tb_group_huds[i] Destroy();
			}
		}
		
		for (i=0; i < all_tb_groups.size; i++)
		{
			if (IsDefined(all_tb_groups[i+1]) )
			{
				if (!IsDefined(tb_defined_huds[i]))
				{
					tb_defined_huds[i] = a_text_display (" against "+all_tb_groups[i+1]+" = "+GetThreatBias(all_tb_groups[i], all_tb_groups[i+1]), undefined, 200, 200+(i*10) );
				}
				tb_defined_huds[i] SetText(" against "+all_tb_groups[i+1]+" = "+GetThreatBias(all_tb_groups[i], all_tb_groups[i+1]) );
			}
			
			if (IsDefined(all_tb_groups[i-1]) )
			{
				if (!IsDefined(tb_defined_huds[i]))
				{
					tb_defined_huds[i] = a_text_display (" against "+all_tb_groups[i-1]+" = "+GetThreatBias(all_tb_groups[i], all_tb_groups[i-1]), undefined, 400, 200+(i*10) );
				}
				tb_defined_huds[i] SetText(" against "+all_tb_groups[i-1]+" = "+GetThreatBias(all_tb_groups[i], all_tb_groups[i-1]) );
			}
		}
		
		wait 0.2;
	}
}
	
get_all_threatbias_groups()
{
	ai = GetAIArray();
	tb_groups = [];
	for (i=0; i < ai.size; i++)
	{
		in_tb_groups = undefined;
		my_tb_group = ai[i] GetThreatBiasGroup();
		for (j=0; j < tb_groups.size; j++)
		{
			if ( tb_groups[j] == my_tb_group)
			{
				in_tb_groups = 1;
			}
		}
		if (!IsDefined(in_tb_groups))
		{
			ARRAY_ADD(tb_groups, my_tb_group);
		}
	}
	ARRAY_ADD(tb_groups, get_players()[0] GetThreatBiasGroup() );
	return tb_groups;
}

set_generic_threatbias(num, group1, group2)
{
	assert( (IsDefined(group1) && IsDefined(group2)) || (!IsDefined(group1) && !IsDefined(group2) ) , "Only one group defined.  Either pass in 2 groups or none at all");
	
	if (!IsDefined(group1))
	{
		group1 = "axis";
	}
	if (!IsDefined(group2))
	{
		group2 = "allies";
	}
	
	SetThreatBias(group1, group2, num);
	SetThreatBias(group2, group1, num);
}

gunner_turret_own_target(mytarget, index, ender)
{
	mytarget endon ("death");
	self endon ("death");
	level endon (ender);
	
	while(1)
	{
		self setgunnertargetent(mytarget, (0,0,0), index);
		self firegunnerweapon(index);
		wait 0.1;
	}
}

turret_own_target(mytarget, delay, ender)
{
	level endon (ender);
	mytarget endon ("death");
	self endon ("death");
	
	if (!IsDefined(delay))
	{
		delay = 5;
	}
	
	while(1)
	{
		self SetTurretTargetEnt(mytarget);
		wait delay;
		self FireWeapon();
	}
}

debug_monsterclips(hero, effectid)
{
	spot = spawn_a_model("tag_origin", (0,0,0) );
	player = get_players()[0];
	
	if (IsDefined(effectid))
	{
		PlayFXOnTag(level._effect[effectid], spot, "tag_origin");
	}
	
	while(get_players()[0] UseButtonPressed() && get_players()[0] AttackButtonPressed() )
	{
		wait 0.05;
	}
	hero disable_ai_color();
	
	while(!get_players()[0] UseButtonPressed() || !get_players()[0] AttackButtonPressed() ) // move the targetpoint to the appropriate place the player is looking
	{
		hero.goalradius = 4;
		direction = player getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = player getEye();
		trace = bullettrace( eye, eye + ( direction_vec * 10000 ), 0, undefined );
		spot.origin = trace["position"];
		
		hero SetGoalPos(spot.origin);
		wait 0.1;
	}
	hero enable_ai_color();
}

onscreen_stopwatch(ender)
{
	if (!IsDefined(ender))
	{
		ender = "end_stopwatch";
	}
	
	level endon (ender);
	counter = 0;
	stopwatch = a_text_display(counter, undefined, 300,80,ender);

	
	while(1)
	{
		level._aiarray = GetAIArray();
		wait 0.05;
		counter += 0.05;
		stopwatch SetText(counter);
	}
}

display_tag_origin(tag)
{
	self endon ("death");
	while(1)
	{
		Print3d(self GetTagOrigin(tag), "HERE", (1,1,1) ,1, 0.5, 2 );
		wait 0.05;
	}
}

display_animname()
{
	self endon ("death");
	while(1)
	{
		Print3d(self.origin+(0,0,60), self.animname, (1,1,1) ,1, 0.5, 2 );
		wait 0.05;
	}
}

is_hard_mode()
{
	if ( level.gameskill > 1 )
	{
		return true;
	}
	else
	{
		return false;
	}
}

throw_object_with_gravity( object, target_pos, velocity_strength )
{
	
	if (!isdefined(velocity_strength))
	{
		velocity_strength = 2000;
	}
	 //object endon ("remove thrown object");
   start_pos = object.origin; // Get the start position

   ///////// Math Section
   // Reverse the gravity so it's negative, you could change the gravity
// by just putting a number in there, but if you keep the dvar, then the
// user will see it change.
   gravity = GetDvarInt( "bg_gravity" ) * -1;
   
   // Get the distance
   dist = Distance( start_pos, target_pos );

   // Figure out the time depending on how fast we are going to
// throw the object... 300 changes the "strength" of the velocity.
// 300 seems to be pretty good. To make it more lofty, lower the number.
// To make it more of a b-line throw, increase the number.
   time = dist / velocity_strength;

   // Get the delta between the 2 points.
   delta = target_pos - start_pos;

   // Here's the math I stole from the grenade code. :) First figure out
// the drop we're going to need using gravity and time squared.
   drop = 0.5 * gravity * ( time * time );

   // Now figure out the trajectory to throw the object at in order to
// hit our map, taking drop and time into account.
   velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
   ///////// End Math Section

   object MoveGravity( velocity, time );  
   
   object rotatepitch(100, time);  
    
   wait time - 0.4;
   
   trace = BulletTrace(object.origin, target_pos, false, object);
   
   counter = 0;
   while(object.origin[2] > trace["position"][2] )
   {
   	wait 0.05;
   	counter++;
   	if (counter > 8)
   	{
   		break;
   	}
   }
   
   object.origin = target_pos;
}

//C. Ayers: Different func so I can thread a timer in order to play mortar incoming sound at the correct time
throw_object_with_gravity_for_mortars( object, target_pos, velocity_strength )
{
	
	if (!isdefined(velocity_strength))
	{
		velocity_strength = 2000;
	}
	 //object endon ("remove thrown object");
   start_pos = object.origin; // Get the start position

   ///////// Math Section
   // Reverse the gravity so it's negative, you could change the gravity
// by just putting a number in there, but if you keep the dvar, then the
// user will see it change.
   gravity = GetDvarInt( "bg_gravity" ) * -1;
   
   // Get the distance
   dist = Distance( start_pos, target_pos );

   // Figure out the time depending on how fast we are going to
// throw the object... 300 changes the "strength" of the velocity.
// 300 seems to be pretty good. To make it more lofty, lower the number.
// To make it more of a b-line throw, increase the number.
   time = dist / velocity_strength;
   level thread play_incoming_sound( object, time, target_pos );

   // Get the delta between the 2 points.
   delta = target_pos - start_pos;

   // Here's the math I stole from the grenade code. :) First figure out
// the drop we're going to need using gravity and time squared.
   drop = 0.5 * gravity * ( time * time );

   // Now figure out the trajectory to throw the object at in order to
// hit our map, taking drop and time into account.
   velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
   ///////// End Math Section

   object MoveGravity( velocity, time );  
   
   object rotatepitch(100, time);  
    
   wait time - 0.4;
   
   trace = BulletTrace(object.origin, target_pos, false, object);
   
   counter = 0;
   while(object.origin[2] > trace["position"][2] )
   {
   	wait 0.05;
   	counter++;
   	if (counter > 8)
   	{
   		break;
   	}
   }
   
   object.origin = target_pos;
}

play_incoming_sound( object, time, target_pos )
{ 
    for( i=0; i<200; i++ )
    {
        time = time-.05;
        
        if( time < .6 )
            break;
            
        wait(.05);
    }
    
    PlaySoundatposition( "prj_mortar_incoming", target_pos + (0,0,20) );
}

delete_array(value, key)
{
	stuff = GetEntArray(value, key);
	for (i=0; i < stuff.size; i++)
	{
		stuff[i] Delete();
	}
}

delete_on_delete(first_deleter)
{
	first_deleter waittill ("death");
	self Delete();
}

display_player_health()
{
	level endon ("stop_player_health_display");
	display = a_text_display("", undefined, 5,170,"stop_player_health_display");
	
	while(1)
	{
		display SetText(get_players()[0].health);
		wait 0.1;
	}
}

what_killed_me()
{
	self waittill ("death", attacker, damagetype);
	wait 1;
} 

control_score( stick, up_score, left_score, down_score, right_score )
{
	movement = (0,0,0);
	
	if(stick == "left")
	{
		movement = self GetNormalizedMovement();
	}
	else if(stick == "right")
	{
		movement = self GetNormalizedCameraMovement();
	}
	
	total_score = 0;
	
	if( movement[0] < 0 )
	{
		total_score += movement[0] * down_score * -1;
	}
	else
	{
		total_score += movement[0] * up_score;
	}
	
	if( movement[1] < 0 )
	{
		total_score += movement[1] * left_score * -1;
	}
	else
	{
		total_score += movement[1] * right_score;
	}
	
	if(total_score > 1)
	{
		return 1;
	}
	
	return total_score;
}

wait_and_unlink(delay)
{
	wait delay;
	self Unlink();
}

xattack_is_unlink()
{
	while(1)
	{
		if (get_players()[0] UseButtonPressed() && get_players()[0] AttackButtonPressed() )
		{
			get_players()[0] Unlink();
		}
		wait 0.05;
	}
}

wait_and_rumble(time, rumble)
{
	wait time;
	get_players()[0] PlayRumbleOnEntity(rumble);
}

wait_and_stoprumble(time, rumble)
{
	wait time;
	get_players()[0] StopRumble(rumble);
}

wait_and_stop_loop_sounds(time)
{
	wait time;
	self stoploopsound();
}

hud_hide()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		//player SetClientDvar( "ammoCounterHide", "1" );
	}
}

hud_show()
{
	wait 0.1;
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
	}
}

delay_flag2_on_flag1(flag1, flag2, delay)
{
	flag_wait(flag1);
	wait delay;
	flag_set(flag2);
}

is_int_in_range( value, max, min)
{
	if (!IsDefined(min))
	{
		min = 0;
	}
	for (i=0; i < max+1; i++)
	{
		if ( value == i)
		{
			return true;
		}
	}
	return false;
}

move_between_points(point1, point2, time, ender, pausetime)
{
	self notify ("new_move_between_points");
	self endon ("new_move_between_points");
	if (IsDefined(ender))
	{
		level endon (ender);
	}
	while(1)
	{
		self moveto (point1, time);
		self waittill ("movedone");
		if (IsDefined(pausetime))
		{
			wait pausetime;
		}
		self moveto (point2, time);
		self waittill ("movedone");
		if (IsDefined(pausetime))
		{
			wait pausetime;
		}
	}
}

safe_forced_save()
{
	if (!IsDefined(level._safe_forced_saves))
	{
		level._safe_forced_saves = 0;
	}
	
	regulated_mbs = 0;
	if (!IsDefined(get_players()[0].magic_bullet_shield ))
		get_players()[0] thread magic_bullet_shield();
	else
		regulated_mbs = 1;
		
	
	wait 1;
	level._safe_forced_saves++;
	maps\_autosave::autosave_game_now("force_save"+level._safe_forced_saves);
	wait 3;
	
	if (regulated_mbs ==0)
	{
		get_players()[0] thread stop_magic_bullet_shield();
	}
}

create_fullscreen_cinematic_hud(fadetime)
{
	if (!IsDefined(level.fullscreen_cin_hud))
	{
		level.fullscreen_cin_hud					 = NewHudElem();
	}
	level.fullscreen_cin_hud.x 				 = 0;
	level.fullscreen_cin_hud.y 			   = 0;
	level.fullscreen_cin_hud.horzAlign  = "fullscreen";
	level.fullscreen_cin_hud.vertAlign  = "fullscreen";
	level.fullscreen_cin_hud.foreground = false; //Arcade Mode compatible
	level.fullscreen_cin_hud.sort			 = 0;

	level.fullscreen_cin_hud setShader( "cinematic", 640, 480 );
	level.fullscreen_cin_hud.alpha = 1;
}

wait_and_fade(delay, fadetime)
{
	self endon ("death");
	wait delay;
	self FadeOverTime(fadetime);
	self.alpha = 0;
}

wait_fade_destroy(delay, fadetime)
{
	wait delay;
	self FadeOverTime(fadetime);
	self.alpha = 0;
	wait fadetime;
	self Destroy();
}

create_crossfade_cinematic_hud(shader, fadeintime, uptime, fadeouttime)
{
	level.crossfade_cin_hud					 = NewHudElem();
	level.crossfade_cin_hud.x 				 = 0;
	level.crossfade_cin_hud.y 			   = 0;
	level.crossfade_cin_hud.horzAlign  = "fullscreen";
	level.crossfade_cin_hud.vertAlign  = "fullscreen";
	level.crossfade_cin_hud.foreground = false; //Arcade Mode compatible
	level.crossfade_cin_hud.sort			 = 0;

	level.crossfade_cin_hud setShader( "cinematic", 640, 480 );
	
	
	level.crossfade_cin_hud.alpha = 0;
	level.crossfade_cin_hud FadeOverTime(fadeintime);
	level.crossfade_cin_hud.alpha = 1;

	wait uptime;

	level.crossfade_cin_hud FadeOverTime(fadeouttime);
	level.crossfade_cin_hud.alpha = 0;

}

freeze_controls_for_time(time)
{
	get_players()[0] FreezeControls(true);
	wait time;
	get_players()[0] FreezeControls(false);
}

player_warpto(spot, do_link)
{
	get_players()[0] Unlink();
	if (IsDefined(do_link))
	{
		get_players()[0] PlayerLinkToAbsolute(spot);
		wait 0.1;
		get_players()[0] Unlink();
		return;
	}
	get_players()[0] SetOrigin (spot.origin);
	get_players()[0] setplayerangles( spot.angles);
}


#using_animtree("animated_props");
origin_animate_jnt_aligned(animated_object, animation_name, animname_override)
{
	animname = undefined;
	if (IsDefined(animated_object.animname))
	{
		animname = animated_object.animname;
	}
	if (IsDefined(animname_override))
	{
		animname = animname_override;
	}
	
	linker = undefined;
	 
  if(IsDefined(animated_object._linker))
  {
  	linker = animated_object._linker;
  }
  else
  {
		linker = spawn_a_model( "tag_origin_animate", self.origin, self.angles );
		linker.animname = animname;
  	linker UseAnimTree( #animtree );
		animated_object LinkTo( linker, "origin_animate_jnt", (0,0,0), (0,0,0) );
	}

	self anim_single_aligned(linker, animation_name);
}

#using_animtree("animated_props");
origin_firstframe_jnt_aligned(animated_object, animation_name, animname_override)
{
	animname = undefined;
	if (IsDefined(animated_object.animname))
	{
		animname = animated_object.animname;
	}
	if (IsDefined(animname_override))
	{
		animname = animname_override;
	}
	
  linker = spawn_a_model( "tag_origin_animate", self.origin, self.angles );
	linker.animname = animname;
  linker UseAnimTree( #animtree );
  animated_object._linker = linker;
                
  self anim_first_frame(linker, animation_name);   
  animated_object LinkTo( linker, "origin_animate_jnt", (0,0,0), (0,0,0) );
}

cover_screen_in_black(time, fadeintime, fadeouttime)
{
	level.cover_screen_in_black						 = NewClientHudElem(get_players()[0]);
	level.cover_screen_in_black.x 				 = 0;
	level.cover_screen_in_black.y 			   = 0;
	level.cover_screen_in_black.horzAlign  = "fullscreen";
	level.cover_screen_in_black.vertAlign  = "fullscreen";
	level.cover_screen_in_black.foreground = false; //Arcade Mode compatible
	level.cover_screen_in_black.sort			 = 0;

	level.cover_screen_in_black setShader( "black", 640, 480 );
	
	if (IsDefined(fadeintime) && fadeintime > 0)
	{
		level.cover_screen_in_black.alpha = 0;
		level.cover_screen_in_black FadeOverTime(fadeintime);
		level.cover_screen_in_black.alpha = 1;
		wait fadeintime;
	}
	
	level.cover_screen_in_black.alpha = 1;
	wait time;
	
	if (IsDefined(fadeouttime) && fadeouttime > 0)
	{
		level.cover_screen_in_black FadeOverTime(fadeouttime);
		level.cover_screen_in_black.alpha = 0;
		wait fadeouttime;
	}
	
	level.cover_screen_in_black Destroy();
}


cover_screen_in_white(time, fadeintime, fadeouttime)
{
	level.cover_screen_in_white						 = NewClientHudElem(get_players()[0]);
	cover_screen_in_white = level.cover_screen_in_white;
	level.cover_screen_in_white.x 				 = 0;
	level.cover_screen_in_white.y 			   = 0;
	level.cover_screen_in_white.horzAlign  = "fullscreen";
	level.cover_screen_in_white.vertAlign  = "fullscreen";
	level.cover_screen_in_white.foreground = false; //Arcade Mode compatible
	level.cover_screen_in_white.sort			 = 0;

	level.cover_screen_in_white setShader( "white", 640, 480 );
	
	if (IsDefined(fadeintime) && fadeintime > 0)
	{
		level.cover_screen_in_white.alpha = 0;
		level.cover_screen_in_white FadeOverTime(fadeintime);
		level.cover_screen_in_white.alpha = 1;
		wait fadeintime;
	}
	
	level.cover_screen_in_white.alpha = 1;
	wait time;
	
	if (IsDefined(fadeouttime) && fadeouttime > 0)
	{
		level.cover_screen_in_white FadeOverTime(fadeouttime);
		level.cover_screen_in_white.alpha = 0;
		wait fadeouttime;
	}
	
	if (IsDefined(cover_screen_in_white ) )
	{
		cover_screen_in_white Destroy();
	}
}

add_angle(angle1, amount_to_add)
{
	while (angle1 < 360 && amount_to_add > 0)
	{
		angle1 += 1;
		amount_to_add-= 1;
	}
	
	if (angle1 == 360 && amount_to_add > 0)
	{
		angle1 = 0;
		while (angle1 < 360 && amount_to_add > 0)
		{
			angle1 += 1;
			amount_to_add-= 1;
		}
	}
	return angle1;
}
	
	
fov_transition(target_fov)
{
	og_target_fov = target_fov;
	first_fov = Int(GetDvar("cg_fov"));
	if ( first_fov > target_fov)
	{
		while(first_fov> target_fov)
		{
			first_fov -= 2;
			self SetClientDvar("cg_fov", first_fov);
			wait 0.05;
		}
	}
	else if ( first_fov < target_fov)
	{
		while(first_fov< target_fov)
		{
			first_fov += 2;
			self SetClientDvar("cg_fov", first_fov);
			wait 0.05;
		}
	}
	self SetClientDvar("cg_fov", og_target_fov);
}

next_tv_round()
{
	flag_wait("next_tv_round");
	flag_clear("next_tv_round");
}

whats_my_vision()
{
	while(1)
	{
		visionset = get_players()[0] getvisionsetnaked();
		IPrintLn(visionset);
		wait 2;
	}
}

play_short_movie(movie)
{
	stop3dcinematic();
	start3dcinematic(movie, false, true);
	playsoundatposition(movie+"_movie",(0,0,0));
	wait 0.05;
	hud = create_movie_hud();

		
	timeleft = GetCinematicTimeRemaining();
	counter = 0;
	while ( (timeleft < 0.05) && counter < 100 )
	{
		wait 0.05;
		counter++;
		timeleft = GetCinematicTimeRemaining();
		PrintLn(timeleft);
	}

	oldtimeleft = GetCinematicTimeRemaining();
	
	while (timeleft >= 0.2)
	{
		wait 0.05;

		timeleft = GetCinematicTimeRemaining();

		if (timeleft < oldtimeleft )
		{
			oldtimeleft = timeleft;
		}
		else
		{
			timeleft -= 0.05;
		}
	}
	wait 0.15;
	stop3dcinematic();
	hud Destroy();
}

sort_holy_array( array)
{
	newArray = [];
	keys = sort_ints_low_to_high(getArrayKeys( array ));
	
	for( i = 0; i < keys.size; i++ )
	{
		newArray[ i ] = array[ keys[ i ] ];
	}
	return newArray;
}

radiusdamage_delay(origin, range, max, min, delay )
{
	wait delay;
	radiusdamage(origin, range, max, min);
}

sort_arrays_small_to_large(array_of_arrays)
{
	sorted_array_of_arrays = [];

	rightsize = array_of_arrays.size;

	
	while(sorted_array_of_arrays.size < rightsize)
	{
		index = 0;
		smallest = array_of_arrays[0];
		for (i=0; i < array_of_arrays.size; i++)
		{
			if ( array_of_arrays[i].size > smallest.size)
			{
				smallest = array_of_arrays[i];
				index = i;
			}
		}
		ARRAY_ADD(sorted_array_of_arrays, smallest);
		array_of_arrays = array_remove_index(array_of_arrays, index);
	}
	return sorted_array_of_arrays;
}
main()
{
	mortars = getentarray ("mortar","targetname");
	for (i=0;i<mortars.size;i++)
		mortars[i] thread burnville_style_mortar();


	if ( !(isdefined (level.mortar) ) )
		maps\_utility::error ("level.mortar not defined. define in level script");
}


hurtgen_style()
{
	// One mortar within x distance goes off every x seconds but not within x units of the player

	mortars = getentarray ("mortar","targetname");
	lastmortar = -1;

	for (i=0;i<mortars.size;i++)
	{
		mortars[i] setup_mortar_terrain();
	}
	if ( !(isdefined (level.mortar) ) )
		maps\_utility::error ("level.mortar not defined. define in level script");

	level waittill ("start_mortars");

	while (1)
	{
		wait (1 + (randomfloat (2) ) );

		r = randomint (mortars.size);
		//println ("mortar size: ", mortars.size);
		//println ("r: ", r);
		for (i=0;i<mortars.size;i++)
		{
			c = (i + r) % mortars.size;
			//println ("current number: ", c);
			d = distance (level.player getorigin(), mortars[c].origin);
			d2 = distance (level.foley.origin, mortars[c].origin);
			if ( (d < 1600) && (d > 300) && (d2 > 350) && (c != lastmortar ) )
			{
				mortars[c] activate_mortar(400, 300, 25);
				lastmortar = c;
				if (d < 500)
					maps\_shellshock::main(4);
//					level.player shellshock("default", 4);
				break;
			}
		}
	}
}

railyard_style(fRandomtime, iMaxRange, iMinRange, iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius, targetsUsed)
{
	// One mortar within iMaxRange distance goes off every (random + random) seconds but not within iMinRange units of the player
	// Terminate on demand by setting level.iStopBarrage != 0, operates indefinitely by default
	// Pass optional custom radius damage settings to activate_mortar()
	// Also pass optional custom earthquake settings to mortar_boom() via activate_mortar() if you want more shaking

	if (!isdefined(fRandomtime))
		fRandomtime = 7;
	if (!isdefined(iMaxRange))
		iMaxRange = 2200;
	if (!isdefined(iMinRange))
		iMinRange = 300;

	if (!isdefined(level.iStopBarrage))
		level.iStopBarrage = 0;

	if (!isdefined(targetsUsed))	//this allows railyard_style to get called again and not setup any terrain related stuff
		targetsUsed = 0;

	mortars = getentarray ("mortar","targetname");
	lastmortar = -1;

	for (i=0;i<mortars.size;i++)
	{
		if(isdefined(mortars[i].target) && (targetsUsed == 0))	//no target necessary, mortar will just play effect and sound
		{
			mortars[i] setup_mortar_terrain();
		}
	}
	if ( !(isdefined (level.mortar) ) )
		maps\_utility::error ("level.mortar not defined. define in level script");

	if (isdefined(level.mortar_notify))
		level waittill (level.mortar_notify);

	while (level.iStopBarrage == 0)
	{
		wait (randomfloat (fRandomtime) + randomfloat (fRandomtime) );

		r = randomint (mortars.size);
		//println ("mortar size: ", mortars.size);
		//println ("r: ", r);
		for (i=0;i<mortars.size;i++)
		{
			c = (i + r) % mortars.size;
			//println ("current number: ", c);
			d = distance (level.player getorigin(), mortars[c].origin);
			if ( (d < iMaxRange) && (d > iMinRange) && (c != lastmortar ) )
			{
				mortars[c] activate_mortar(iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius);
				lastmortar = c;
				break;
			}
		}
	}

	//println("MORTAR BARRAGE TERMINATED");
}

script_mortargroup_style()
{

	mortars = getentarray ("mortar","targetname");
	for (i=0;i<mortars.size;i++)
	{
//		mortars[i] setup_mortar_terrain(); 		// errors out because my mortars don't have targets.
		mortars[i].has_terrain = false;  		//meh to terrain mortars (not ready to do this just yet).
	}
	if ( !(isdefined (level.mortar) ) )
		maps\_utility::error ("level.mortar not defined. define in level script");

	mortartrigs = getentarray("mortartrigger","targetname");
	for(i=0;i<mortartrigs.size;i++)
	{
		mortartrigs[i].mortargroup = 0;
		mortartrigs[i] thread script_mortargroup_mortar_group();
	}
	while(1)
	{
		level waittill ("mortarzone",mortartrig);
		if(isdefined(lasttrig))
			lasttrig thread script_mortargroup_mortar_group();
		level.mortarzone = mortartrig.script_mortargroup;
		mortartrig thread script_mortargroup_mortarzone();
		lasttrig = mortartrig;

	}
}
script_mortargroup_mortarzone()
{
	if(isdefined(self.groupedmortars))
	while(level.mortarzone == self.script_mortargroup && isdefined(self.groupedmortars))
	{
		if(self.groupedmortars.size > 0)
			pick = randomint(self.groupedmortars.size);  // - 1 ?
		else
			pick = 0;
		self.groupedmortars[pick] thread script_mortargroup_domortar();
		self.groupedmortars = maps\_utility::array_remove(self.groupedmortars,self.groupedmortars[pick]);
		delay = randomFloat( 2.4 ) + 4;
		wait( delay );
	}
}

script_mortargroup_domortar()
{
	self thread activate_mortar();

	self waittill ("mortar");
	if(isdefined(self.target))
	{
		targ = getent(self.target,"targetname");
		if(isdefined(targ))
			targ notify ("trigger");
	}
}

script_mortargroup_mortar_group()
{

	if(!isdefined(self.groupedmortars))
	{
		mortars = getentarray ("mortar","targetname");
		group = 0;
		for(i=0;i<mortars.size;i++)
		{
			if(!isdefined (mortars[i].script_mortargroup))
				println ("mortar without mortargroup at", mortars[i].origin);
			if(mortars[i].script_mortargroup == self.script_mortargroup)
			{
				groupedmortars[group] = mortars[i];
				group++;
			}
		}
		self.groupedmortars = groupedmortars;
	}
	self waittill ("trigger");
	level notify ("mortarzone", self);
}

trigger_targeted()
{
	//While the player is touching a trigger named "mortartrigger" a targeted script_origin mortar with a defined
	//script_mortargroup value will go off every x seconds regardless of the players distance to the mortar.

	level.mortartrigger = getentarray ("mortartrigger","targetname");
	level.mortars = getentarray ("script_origin","classname");

	for (i=0;i<level.mortars.size;i++)
	{
		if (isdefined (level.mortars[i].script_mortargroup))
		{
			level.mortars[i] setup_mortar_terrain();
		}
	}

	level.lastmortar = -1;

	if ( !(isdefined (level.mortar) ) )
		maps\_utility::error ("level.mortar not defined. define in level script");

	for (i=0;i<level.mortartrigger.size;i++)
	{
		thread trigger_targeted_mortars(i);
	}
}

trigger_targeted_mortars(num)
{
	targeted_mortars = getentarray (level.mortartrigger[num].target, "targetname");

	while(1)
	{
		if (level.player istouching (level.mortartrigger[num]))
		{
			r = randomint (targeted_mortars.size);
			while (r == level.lastmortar)
			{
				r = randomint (targeted_mortars.size);
				wait .1;
			}
			targeted_mortars[r] activate_mortar();
			level.lastmortar = r;
		}
		wait (randomfloat (3) + randomfloat (4) );
	}
}

burnville_style_mortar()
{
	// Mortar waits for player to come within x units. Then explodes every x seconds if player is x range away
	level endon ("stop falling mortars");
	setup_mortar_terrain();

	wait (randomfloat (0.5) + randomfloat (0.5));

	while (1)
	{
		if (distance(level.player getorigin(), self.origin) < 600)
		{
			activate_mortar();
			break;
		}
		wait (1);
	}

	wait (7 + randomfloat (20));

	while (1)
	{
		if ((distance(level.player getorigin(), self.origin) < 1200) &&
			(distance(level.player getorigin(), self.origin) > 400))
		{
			activate_mortar();
			wait (3 + randomfloat (14));
		}

		wait (1);
	}
}

setup_mortar_terrain()
{
	self.has_terrain = false;
	if (isdefined (self.target))
	{
		self.terrain = getentarray (self.target, "targetname");
		self.has_terrain = true;
	}
	else
	{
		println ("z:          mortar entity has no target: ", self.origin);
	}

	if (!isdefined (self.terrain))
		println ("z:          mortar entity has target, but target doesnt exist: ", self.origin);

	if (isdefined (self.script_hidden) )
	{
		self.hidden_terrain = getent (self.script_hidden, "targetname");
	//	println ("hiding terrain");
		if (isdefined (self.hidden_terrain) )
			self.hidden_terrain hide();
	}

}

activate_mortar (range, max_damage, min_damage, fQuakepower, iQuaketime, iQuakeradius)
{
	incoming_sound();

	level notify ("mortar");
	self notify ("mortar");

	if (!isdefined (range))
		range = 256;
	if (!isdefined (max_damage))
		max_damage = 400;
	if (!isdefined (min_damage))
		min_damage = 25;

	radiusDamage ( self.origin, range, max_damage, min_damage);

	if ((isdefined(self.has_terrain) && self.has_terrain == true) && (isdefined (self.terrain)))
	{
		for (i=0;i<self.terrain.size;i++)
		{
			if (isdefined (self.terrain[i]))
				self.terrain[i] delete();
		}
	}
	
	if (isdefined (self.hidden_terrain) )
		self.hidden_terrain show();
	self.has_terrain = false;
	
	mortar_boom( self.origin, fQuakepower, iQuaketime, iQuakeradius );
}

mortar_boom (origin, fPower, iTime, iRadius)
{
	if (!isdefined(fPower))
		fPower = 0.15;
	if (!isdefined(iTime))
		iTime = 2;
	if (!isdefined(iRadius))
		iRadius = 850;

	mortar_sound();
	playfx ( level.mortar, origin );
	earthquake(fPower, iTime, origin, iRadius);
	
	// Special Burnville Shell shocking
	if (level.script != "burnville")
		return;
	if (isdefined (level.playerMortar))
		return;
	if (distance (level.player.origin, origin) > 300)
		return;

	level.playerMortar = true;		
	level notify ("shell shock player",	iTime*4);
	maps\_shellshock::main(iTime*4);
//	level.player shellshock("default", iTime*4);
	

//	earthquake(0.15, 2, origin, 1050);
	/*
	earthquake(float scale, float duration, vector source, float radius)

	Example:
		player = getent("player", "classname");
		scale = 0.15;
		duration = 1;
		source = (866, 2240, 0);
		radius = 600;

		earthquake(scale, duration, source, radius);
	*/
}

mortar_sound()
{
	if (!isdefined (level.mortar_last_sound))
		level.mortar_last_sound = -1;

	soundnum = 0;
	while (soundnum == level.mortar_last_sound)
		soundnum = randomint(3) + 1;

	level.mortar_last_sound	= soundnum;

	if (soundnum == 1)
		self playsound ("mortar_explosion1");
	else
	if (soundnum == 2)
		self playsound ("mortar_explosion2");
	else
		self playsound ("mortar_explosion3");
}

incoming_sound(soundnum)
{
	if (!isdefined (soundnum))
		soundnum = randomint(3) + 1;

	if (soundnum == 1)
	{
		self playsound ("mortar_incoming1");
		wait (1.07 - 0.25);
	}
	else
	if (soundnum == 2)
	{
		self playsound ("mortar_incoming2");
		wait (0.67 - 0.25);
	}
	else
	{
		self playsound ("mortar_incoming3");
		wait (1.55 - 0.25);
	}
}
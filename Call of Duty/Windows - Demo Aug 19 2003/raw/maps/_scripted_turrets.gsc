main()
{
	
}

flakdeath (other, flaknum)
{
	other waittill ("death");
	level.flaktrigger[flaknum]--;
}

flak_operator_death (other, flaknum)
{
	other waittill ("death");
	level.flakactive[flaknum] = false;
	level notify ("flak died with flaknum " + flaknum);
}

flak_trigger (trigger, flaknum)
{
	if (isdefined (trigger.target)) 
	{
		pretrigger = getent (trigger.target, "targetname");
		pretrigger thread flak_pretrigger (flaknum);
		level.flakpretrigger[flaknum] = true;
	}

	while (level.flakactive[flaknum])
	{
		trigger waittill ("trigger", other);
		if ((!isdefined (other.flaktrigger)) || (!isdefined (other.flaktrigger[flaknum])))
		{
			level.flaktrigger[flaknum]++;
			other.flaktrigger[flaknum] = true;
			level thread flakdeath (other, flaknum);
		}
		wait 1;
	}
}

flak_start_trigger (trigger, flaknum)
{
	trigger waittill ("trigger");
	if (isdefined (trigger.target))
	{
		triggers = getentarray (trigger.target,"targetname");
		for (i=0;i<triggers.size;i++)
			self thread flak_end_trigger(triggers[i], flaknum);
	}
	self notify ("start_turret");
	trigger delete();
}

flak_end_trigger (trigger, flaknum)
{
	trigger endon("death");
	while(1)
	{
		trigger waittill ("trigger",other);
		if (trigger.classname == "trigger_damage" && (isdefined(trigger.script_noteworthy)) && trigger.script_noteworthy == "deathtrig")
		{
			if((isdefined(other)) && (isdefined(other.targetname)) && other.targetname == "player_tank")
			{
				thread flak_explode();
				break;
			}
		}
		else
			break;
	}
	trigger delete();

	if (isdefined (self.script_offtime))
		offtime = self.script_offtime;
	else
		offtime = 20000;

	if (isdefined (self.script_offradius))
		offradius = self.script_offradius;
	else
		offradius = 350;
	
	timer = gettime() + offtime;
	while ((timer > gettime()) && (distance (level.player getorigin(), self.origin) > offradius))
		wait (1);
	
	level.flakactive[flaknum] = false;
	level notify ("flak died with flaknum " + flaknum);
}

flak_explode(flaknum)
{
	self notify ("explode");
}

flak_pretrigger (flaknum)
{
	self waittill ("trigger");
	level.flakpretrigger[flaknum] = false;	
}

scriptedRadiusDamage ( org, dmg )
{
	mod = 2.0;
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		dist = distance (org, ai[i].origin);
		println ("ai dist is ", dist);
		if (dist > dmg)
			continue;
			
		ai[i] DoDamage ( (dmg - dist)*mod , org );
	}
	
	dist = distance (org, level.player.origin);
	println ("player dist is ", dist);
	if (dist > dmg)
		return;
		
	level.player DoDamage ( (dmg - dist)*mod , level.player.origin);
	println ("doing ", (dmg - dist)*mod, " damage to the player");
}

flak_explode_wait (flaknum)
{
	self waittill ("explode");
	level notify ("broken");
	self playsound ("explo_metal_rand");
//	radiusDamage ( self.origin, 200, 600, 400); // origin radius damagemax damagemin
	println ("^3DO THE DAMAGE");
   	playfx ( level._effect["explosion"], self.origin );
	
//	maps\_fx::GrenadeExplosionfx(model.origin);
	earthquake(0.75, 3, self.origin, 1150);
	scriptedRadiusDamage ( self.origin, 420 );
//	radiusDamage ( self.origin, 900, 900, 200); // origin radius damagemax damagemin
	
	level.flakactive[flaknum] = false;
	level notify ("flak died with flaknum " + flaknum);
	if (isdefined (self.script_objective))
		level notify (self.script_objective);
	
	wait (.22);
	self setmodel (self.dead_model);
}

flak_explosive (model, flaknum)
{
	if (!isdefined (model.target))
		maps\_utility::error ("Bomb at " + model.origin + " needs to target a trigger_use");

	trigger = getent (model.target,"targetname");
	model setmodel ("xmodel/bomb_objective_incomplete");
//	model setmodel ("xmodel/cow_dead");
	
	trigger setHintString (&"SCRIPT_HINTSTR_PLANTEXPLOSIVES");
	//trigger setCursorHint("HINT_NONE");
	
	trigger waittill ("trigger");
	self playsound ("explo_plant_rand");
	
	model setmodel ("xmodel/bomb");
	if (!isdefined (level.explosivesPlantedStandBack))
	{
		iprintlnbold (&"SCRIPT_EXPLOSIVESPLANTED");
		level.explosivesPlantedStandBack = true;
	}
//	badplace_cylinder(name, duration, origin, radius, height, team[, other team...]);
	badplace_cylinder(self.script_objective, 6, self.origin, 400, 400, "allies");
	trigger delete();

	if (isdefined (self.script_objective))
		flag_set (self.script_objective + "bomb placed");
	
	hdSinglePlayerTimer(level.player, getTime()+(5*1000)); //5 second stop watch timer	
	wait (5);
	playfx (level._effect["grenade"], model.origin);
	model delete();
	self notify ("explode");
}

flag_set (msg)
{
	level.flag[msg] = true;
	level notify (msg);
}

#using_animtree("flak88");
flak_animation(flaknum)
{
//	self.origin = node.origin;
//	flak_init();
	level._effect["explosion"] = loadfx ("fx/explosions/metal_b.efx");
	level._effect["grenade"] = loadfx ("fx/explosions/grenade1.efx");
	
	if (self.model == "xmodel/vehicle_tank_flakpanzer")  //remove this stuff maybe?
		flaktype = "flakpanzer";
	
	if (isdefined(self.script_flaktype))
		flaktype = self.script_flaktype;
		
	if (!(flaktype == "flakair" || flaktype == "flakairlow" || flaktype == "flakpanzer" || flaktype == "flaktank"))
	{
		println ("^cError: invalid flaktype on flak at ", self.origin);
		return;
	}
	
	self thread flak_explode_wait(flaknum);
	
	
	flaker_setup = getentarray (self.target, "targetname");
	trigger = false;
	for (i=0;i<flaker_setup.size;i++)
	{
		if (flaker_setup[i].classname == "trigger_multiple")
		{
			thread flak_start_trigger (flaker_setup[i], flaknum);
			trigger = true;
		}
		else
		if (flaker_setup[i].classname == "script_model")
			self thread flak_explosive (flaker_setup[i], flaknum);
		else
//		if (isSentient (flaker_setup[i]))
		{
			if (!isdefined (flaker_spawn))
				flaker_spawn[0] = flaker_setup[i];
			else
				flaker_spawn[flaker_spawn.size] = flaker_setup[i];
		}
	}
	
	if (trigger)
		self waittill ("start_turret");

//	thread flaker_earthquake();

	for (i=0;i<flaker_spawn.size;i++)
		flakers[i] = flaker_spawn[i] dospawn();
	
	for (i=0;i<flakers.size;i++)
	if (!isalive (flakers[i]))
	{
		println ("^cError: Flakers " + i + " didn't spawn");
		return;
	}

	if (flakers.size < flaker_spawn.size)
	{
		println ("^cError: Turret couldn't spawn enough operators");
		return;
	}
	
	if (flaktype == "flakair")
	{
		if ((!isdefined (flakers)) || (flakers.size < 3))
		{
			println ("^cError: Flak node didn't have 4 AI targetting it");
			return;
		}
	}
	else
	if (flaktype == "flakairlow")
	{
		if ((!isdefined (flakers)) || (flakers.size < 3))
		{
			println ("^cError: Flak node didn't have 4 AI targetting it");
			return;
		}
	}
	else
	if (flaktype == "flaktank")
	{
		if ((!isdefined (flakers)) || (flakers.size < 3))
		{
			println ("^cError: Flak node didn't have 4 AI targetting it");
			return;
		}
	}
	else
	if (flaktype == "flakpanzer")
	{
		self.clip_1 = true;
		self attach("xmodel/panzerflak_ammo", "tag_clip_1");
		self.clip_2 = true;
		self attach("xmodel/panzerflak_ammo", "tag_clip_2");
		self.clip_3 = true;
		self attach("xmodel/panzerflak_ammo", "tag_clip_3");
		self.clip_4 = true;
		self attach("xmodel/panzerflak_ammo", "tag_clip_4");
		
		if ((!isdefined (flakers)) || (flakers.size != 3))
		{
			println ("^cError: Flak node didn't have 3 AI targetting it");
			return;
		}
	}
	
	if (flaktype == "flakair")
		self setmodel ("xmodel/turret_flak88");
	if (flaktype == "flakairlow")
		self setmodel ("xmodel/turret_flak88");
	if (flaktype == "flaktank")
		self setmodel ("xmodel/turret_flak88");
	if (flaktype == "flakpanzer")
		self setmodel ("xmodel/vehicle_tank_flakpanzer");
			
	level.flakactive[flaknum] = true;
	level.flaktrigger[flaknum] = 0;
	level.flakpretrigger[flaknum] = false;
	
	/*
	if (isdefined (self.target))
	{
		triggers = getentarray (self.target, "targetname");
		for (i=0;i<triggers.size;i++)
			self thread flak_trigger (triggers[i], flaknum);
	}	
	*/
	
//	if (flaktype != "tank")
//		level.flakpretrigger[flaknum] = false;

//	flakanim = getFlakanim(flaktype);
	flakanim = [[self.getflakanim]](flaktype);

	for (i=0;i<flakers.size;i++)
	{
		flakers[i] animscripts\shared::putGunInHand ("none");
		flakers[i] thread [[self.anim_thread]](i);
		thread flak_operator_death (flakers[i], flaknum);
		flakers[i].clip_on = false;
		
		/*
		if (i==0)
			gunner = flakers[i];
		else
		if (i==1)
			leftloader = flakers[i];
		else
		if (i==2)
			rightloader = flakers[i];
		*/
	}

	for (i=0;i<flakers.size;i++)
		flakers[i] thread flakers_animsetup( self.origin, flaknum );

	level.flakanim[flaknum] = 0;
	level.flakinposition[flaknum] = 0;
	self.playingFlakSound = false;
	self.stoploopsoundTimer = 0;
	self thread flak_death (flakers);
	self thread stopFlakSound (flaknum);
	if (flaktype == "flakpanzer")
	{
		self thread soundBlender ("flakpanzer_loop", 		flaknum);
		self thread soundBlender ("flakpanzer_loop_fast",	flaknum);
	}

	while (level.flakactive[flaknum])
	{
//		maps\_spawner::waitframe();
		
		if ((flaktype == "flakair") || (flaktype == "flaktank"))
		{
			if (!level.flaktrigger[flaknum])
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("none");

				if (level.flakpretrigger[flaknum])
					animname = "preidle";
				else if (!level.flakinposition[flaknum])
				{
					level.flakinposition[flaknum] = 1;
					animname = "turn";
				}
				else
				{
					if (randomint (100) > 95)
						animname = "twitch";
					else
					if (randomint (100) > 60)
						animname = "fire";
					else
						animname = "idle";
				}

				// Flak model animates
				thread flak_anim(flakanim, animname, flaknum);
				
				if (animname == "fire")
				{
					playfxOnTag ( level._effect["flak_burst"], self, "tag_flash" );
					self playsound ("flak88_fire");
				}
				
				for (i=0;i<flakers.size;i++)
					flakers[i] thread flakers_anim (self, flaknum, animname);
					
				level waittill ("flak_anim_done" + flaknum);
			}
			else
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("right");
			
				wait (1);
			}
		}
		else
		if (flaktype == "flakairlow")
		{
			if (!level.flaktrigger[flaknum])
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("none");
					
				if (level.flakpretrigger[flaknum])
					animname = "idle";
				else if (!level.flakinposition[flaknum])
				{
					level.flakinposition[flaknum] = 1;
					animname = "idle";
				}
				else
				{
					if (randomint (100) > 70)
						animname = "fire";
					else
						animname = "idle";
				}
				thread flak_anim(flakanim, animname, flaknum);
				
				//TEMP STUFF UNTIL FLAK_ANIM UPDATED
				if (animname == "fire")
				{
					playfxOnTag ( level._effect["flak_burst"], self, "tag_flash" );
					self playsound ("Flak88_fire");
				}
				//END OF TEMP STUFF
				
				for (i=0;i<flakers.size;i++)
					flakers[i] thread flakers_anim (self, flaknum, animname);
				wait 2;
				//level waittill ("flak_anim_done" + flaknum);
			}
			else
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("right");
				wait (1);
			}
		}
		else
		if (flaktype == "flakpanzer")
		{
			if (!level.flaktrigger[flaknum])
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("none");

				if (randomint (100) > 50)
					animname = "fireA";
				else
					animname = "fireB";

				// Flak model animates
				thread flak_anim(flakanim, animname, flaknum, "panzer");
				
				for (i=0;i<flakers.size;i++)
					flakers[i] thread flakers_anim (self, flaknum, animname);
					
				level waittill ("flak_anim_done" + flaknum);
			}
			else
			{
				for (i=0;i<flakers.size;i++)
					flakers[i] animscripts\shared::putGunInHand ("right");
			
				wait (1);
			}
		}
	}		
}

stopFlakSound (flaknum)
{	
	level waittill ("flak died with flaknum " + flaknum);
	println ("STOP THE LOOP SOUND");
	self stoploopsound();
	self notify ("flakpanzer_loop" + "off");
	self notify ("flakpanzer_loop_fast" + "off");
}

flaker_earthquake ()
{
	self endon ("broken");
	while (1)
	{
		earthquake(0.05, 2, self.origin, 2500);
		wait (1);
	}
}

flaker_died (flaker)
{
	flaker.health = 1;
	flaker waittill ("death");
	self notify ("end_sequence");
}

flak_death (flakers)
{
	for (i=0;i<flakers.size;i++)
		thread flaker_died (flakers[i]);
		
	self waittill ("end_sequence");

	for (i=0;i<flakers.size;i++)
	if (isalive (flakers[i]))
	{
		flakers[i] notify ("end_sequence");
		flakers[i].health = 250;

		if (!flakers[i].clip_on)
			continue;

		flakers[i].clip_on = false;
		flakers[i] detach("xmodel/panzerflak_ammo", "tag_weapon_left");	
	}
	
}

flakers_anim (node, flaknum, animname)
{	
	level.flakanim[flaknum]++;
	self animscripted("scriptedanimdone", node.origin, node.angles, self.flakanim[animname]);
	self.allowDeath = 1;
	

	while (1)
	{
		self waittill ("scriptedanimdone", notetrack);
		if (notetrack == "end")
			break;
		if (notetrack == "clip on")
		{
			if (!self.clip_on)
			{
				self.clip_on = true;
				self attach("xmodel/panzerflak_ammo", "tag_weapon_left");	
			}
		}
		if (notetrack == "clip off")
		{
			if (self.clip_on)
			{
				self.clip_on = false;
				self detach("xmodel/panzerflak_ammo", "tag_weapon_left");	
			}
		}
	}
	
	level.flakanim[flaknum]--;
	if (!level.flakanim[flaknum])
		level notify ("flak_anim_done" + flaknum);
}

flakers_animsetup (org, flaknum)
{	
//	org = getStartOrigin (, self.flakanim["fireA"]);
	self endon ("death");
	self teleport (org);
	wait 1;
	self setgoalpos (org);
	self.goalradius = 200;
	if (!isdefined (self.target))
		return;

	level waittill ("flak died with flaknum " + flaknum);
	node = getnode (self.target,"targetname");
	self setgoalnode (node);
	if (isdefined (node.radius))
		self.goalradius = node.radius;
	else
		self.goalradius = 128;
}

soundBlenderDelete (alias,  flaknum)
{
	level waittill ("flak died with flaknum " + flaknum);
	for (i=1.0;i>0;i-=0.5)
	{
		self setSoundBlend( alias + "_null", alias, i );
		wait (0.05);
	}
	self delete();
}


soundBlender (alias, flaknum)
{
	blend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	blend.origin = self.origin;
	level endon ("flak died with flaknum " + flaknum);
	blend thread soundBlenderDelete (alias, flaknum);
	
	while (1)
	{
		self waittill (alias + "on");
		for (i=0;i<1;i+=0.1)
		{
			blend setSoundBlend( alias + "_null", alias, i );
			wait (0.05);
		}
		
		self waittill (alias + "off");
		for (i=1.0;i>0;i-=0.1)
		{
			blend setSoundBlend( alias + "_null", alias, i );
			wait (0.05);
		}
	}
}

fireA (flaknum)
{
	level endon ("flak died with flaknum " + flaknum);
	self notify ("flakpanzer_loop" + "off");
	self notify ("flakpanzer_loop_fast" + "on");
	wait (2.083);
	self notify ("flakpanzer_loop_fast" + "off");
	self notify ("flakpanzer_loop" + "on");
}

fireB (flaknum)
{
	self notify ("flakpanzer_loop" + "off");
	self notify ("flakpanzer_loop_fast" + "on");
}

flak_anim (flakanim, animname, flaknum, flaktype)
{

//	self animscripted("animdone", self.origin, self.angles, flakanim[animname]);

	self setFlaggedAnimKnobRestart("animdone", flakanim[animname]);
	lastsound = gettime();
	if (getcvar ("old flak") != "on")
	if ((isdefined (flaktype)) && (flaktype == "panzer"))
	{
		if (animname == "fireA")
			self thread fireA(flaknum);
		else
			self thread fireB(flaknum);
			/*
		
		println ("^2flak flakanim: ", flakanim, " animname: ", animname);
//		self maps\_utility::playsoundinspace ("flakpanzer_cooldown", self.origin);
		if (randomint (100) > 50)
		{
			self notify ("flakpanzer_loop" + "on");
			self notify ("flakpanzer_loop_fast" + "off");
		}
		else
		{
			self notify ("flakpanzer_loop" + "off");
			self notify ("flakpanzer_loop_fast" + "on");
		}
		*/
	}
	
	while (level.flakactive[flaknum])
	{
		self waittill ("animdone", notetrack);
		if (notetrack == "end")
			break;
		if (notetrack == "clip_1 on")
		{
			if (!self.clip_1)
				self attach("xmodel/panzerflak_ammo", "tag_clip_1");
			self.clip_1 = true;
		}
		if (notetrack == "clip_2 on")
		{
			if (!self.clip_2)
				self attach("xmodel/panzerflak_ammo", "tag_clip_2");
			self.clip_2 = true;
		}
		if (notetrack == "clip_3 on")
		{
			if (!self.clip_3)
				self attach("xmodel/panzerflak_ammo", "tag_clip_3");
			self.clip_3 = true;
		}
		if (notetrack == "clip_4 on")
		{
			if (!self.clip_4)
				self attach("xmodel/panzerflak_ammo", "tag_clip_4");
			self.clip_4 = true;
		}
		if (notetrack == "clip_1 off")
		{
			if (self.clip_1)
				self detach("xmodel/panzerflak_ammo", "tag_clip_1");
			self.clip_1 = false;
		}
		if (notetrack == "clip_2 off")
		{
			if (self.clip_2)
				self detach("xmodel/panzerflak_ammo", "tag_clip_2");
			self.clip_2 = false;
		}
		if (notetrack == "clip_3 off")
		{
			if (self.clip_3)
				self detach("xmodel/panzerflak_ammo", "tag_clip_3");
			self.clip_3 = false;
		}
		if (notetrack == "clip_4 off")
		{
			if (self.clip_4)
				self detach("xmodel/panzerflak_ammo", "tag_clip_4");
			self.clip_4 = false;
		}
		
		dosound = false;
		if (notetrack == "fire_1")
		{
	        playfxOnTag ( level._effect["flak_burst"], self, "tag_flash_1" );
	        playfxOnTag ( level._effect["flak_burst_lite"], self, "tag_flash_11" );
			dosound = true;
//			if (dosound)
		}
		if (notetrack == "fire_2")
		{
			dosound = true;
	        playfxOnTag ( level._effect["flak_burst_lite"], self, "tag_flash_2" );
	        playfxOnTag ( level._effect["flak_burst"], self, "tag_flash_22" );
		}

//		if (dosound)
//			self thread maps\_utility::playsoundinspace ("flak_singleshot", self.origin);
		if ((!isdefined (flaktype)) || (flaktype != "panzer"))
		//if (getcvar ("old flak") == "on")
		{
			if (dosound)
				self.stoploopsoundTimer = gettime() + 600;
			else
			{
				if (gettime() > self.stoploopsoundTimer)
				{
					self stoploopsound();
					self playsound ("flakpanzer_cooldown");
					self.playingFlakSound = false;
				}
			}
	
			if ((dosound) && (!self.playingFlakSound))
			{
				self.playingFlakSound = true;
				self playloopsound ("flakpanzer_loop");
				/*
				if (randomint(100) > 50)
					self playsound ("Flak88_fire");
				else
					self playsound ("Flak88_fire");
					
				*/
			}
		}
		
		/*
		if (notetrack == "sound")
		{
			self playsound ("flak_burst_medium5");
		    println ("played sound");
		}
		*/
	}
}

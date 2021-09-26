#include maps\_utility;
main()
{
	//------------------
	//EFECTS DEFINITIONS
	//------------------
	
		qBarrels = false;
		barrels = getentarray ("explodable_barrel","targetname");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBarrels = true;
		barrels = getentarray ("explodable_barrel","script_noteworthy");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBarrels = true;
		if (qBarrels)
		{
			level.breakables_fx["barrel"]["explode"] 	= loadfx ("fx/props/barrelExp.efx");
			level.breakables_fx["barrel"]["burn_start"]	= loadfx ("fx/props/barrel_ignite.efx");
			level.breakables_fx["barrel"]["burn"]	 	= loadfx ("fx/props/barrel_fire.efx");
		}
		
		tincans = getentarray ("tincan","targetname");
		if ( (isdefined(tincans)) && (tincans.size > 0) )
			level.breakables_fx["tincan"] 				= loadfx ("fx/props/tincan_bounce.efx");
		
		qBreakables = false;
		breakables = getentarray ("breakable","targetname");
		if ( (isdefined(breakables)) && (breakables.size > 0) )
			qBreakables = true;
		breakables = getentarray ("breakable_vase","targetname");
		if ( (isdefined(breakables)) && (breakables.size > 0) )
			qBreakables = true;
		breakables = getentarray ("breakable box","targetname");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBreakables = true;
		breakables = getentarray ("breakable box","script_noteworthy");
		if ( (isdefined(barrels)) && (barrels.size > 0) )
			qBreakables = true;
		if (qBreakables)
		{
			level.breakables_fx["vase"] 				= loadfx ("fx/props/vase_water.efx");
			level.breakables_fx["bottle"] 				= loadfx ("fx/props/wine_bottle.efx");
			level.breakables_fx["box"][0] 				= loadfx ("fx/props/crateExp_dust.efx");
			level.breakables_fx["box"][1] 				= loadfx ("fx/props/crateExp_dust.efx");
			level.breakables_fx["box"][2] 				= loadfx ("fx/props/crateExp_dust.efx");
			level.breakables_fx["box"][3] 				= loadfx ("fx/props/crateExp_ammo.efx");
		}
	//------------------
	//------------------
	
	
	//-----------------
	//SOUND DEFINITIONS
	//-----------------
		level.barrelExpSound = "explo_metal_rand";
	//-----------------
	//-----------------
	
	//-------------
	//MISC SETTINGS
	//-------------
		maxBrokenPieces = 25;
		level.breakables_peicesCollide["orange vase"] = true;
		level.breakables_peicesCollide["green vase"] = true;
		level.breakables_peicesCollide["bottle"] = true;
	//*************IF YOU PUT THIS BACK IN - SEARCH FOR "PLATE WAIT" AND PUT THAT BACK IN TOO*************
	//	level.breakables_peicesCollide["plate"] = true;
	//*************IF YOU PUT THIS BACK IN - SEARCH FOR "PLATE WAIT" AND PUT THAT BACK IN TOO*************
	
		
		level.barrelHealth = 160;
	//-------------
	//-------------
	
	level.precachemodeltype = [];
	level.barrelExplodingThisFrame = false;
	level.breakables_clip = [];
	level.breakables_clip = getentarray ("vase_break_remove","targetname");
	level.xenon_auto_aim = [];
	
	
		level.xenon_auto_aim = getentarray("xenon_auto_aim","targetname");
		level.xenon_auto_aim_2nd = getentarray("xenon_auto_aim_secondary","targetname");
		for(i=0;i<level.xenon_auto_aim.size;i++)
			level.xenon_auto_aim[i] notsolid();
		for(i=0;i<level.xenon_auto_aim_2nd.size;i++)
			level.xenon_auto_aim_2nd[i] notsolid();
	if(! (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" ) )
	{
		level.xenon_auto_aim = undefined;
		level.xenon_auto_aim_2nd = undefined;
	}
	if(level.script == "moscow")
	{
		level._moscow_xauto_helmetarray = [];
		level._moscow_xauto_targetarray = [];
	}
	temp = getentarray ("breakable clip","targetname");
	for (i=0;i<temp.size;i++)
		level.breakables_clip[level.breakables_clip.size] = temp[i];
	level._breakable_utility_modelarray = [];
	level._breakable_utility_modelindex = 0;
	level._breakable_utility_maxnum = maxBrokenPieces;
	array_thread(getentarray ("tincan","targetname"), ::tincan_think);
	array_thread(getentarray ("helmet_pop","targetname"), ::helmet_pop);
	array_thread(getentarray ("explodable_barrel","targetname"), ::explodable_barrel_think);
	array_thread(getentarray ("explodable_barrel","script_noteworthy"), ::explodable_barrel_think);
	array_thread(getentarray ("shuddering_entity","targetname"), ::shuddering_entity_think);
	array_thread(getentarray ("breakable box","targetname"), ::breakable_think);
	array_thread(getentarray ("breakable box","script_noteworthy"), ::breakable_think);
	array_thread(getentarray ("breakable","targetname"), ::breakable_think);
	array_thread(getentarray ("breakable_vase","targetname"), ::breakable_think);
}

explodable_barrel_think()
{	
	if (self.classname != "script_model")
		return;
	if ( (self.model != "xmodel/prop_barrel_benzin") && (self.model != "xmodel/prop_barrel_benzin_snow") )
		return;
	if(!isdefined(level.precachemodeltype["xmodel/prop_barrel_benzin"]))
	{
		level.precachemodeltype["xmodel/prop_barrel_benzin"] = true;
		precacheModel("xmodel/prop_barrel_piece");
		precacheModel("xmodel/prop_barrel_piece2");	
	}
	self endon ("exploding");
	
	self breakable_clip();
	self xenon_auto_aim();
	self.damageTaken = 0;
	self setcandamage(true);
	for (;;)
	{
		self waittill ("damage", amount ,attacker);
		if (level.barrelExplodingThisFrame)
			wait randomfloat(1.5);
		self.damageTaken += amount;
		if (self.damageTaken == amount)
			self thread explodable_barrel_burn();
	}
}

explodable_barrel_burn()
{
	count = 0;
	startedfx = false;
	while (self.damageTaken < level.barrelHealth)
	{
		if (!startedfx)
		{
			playfx (level.breakables_fx["barrel"]["burn_start"], self.origin);
			startedfx = true;
		}
		if (count > 20)
			count = 0;
		
		if (count == 0)
		{
			playfx (level.breakables_fx["barrel"]["burn"], self.origin);
			self.damageTaken += (10 + randomfloat(10));
			badplace_cylinder("",1, self.origin, 128, 250);
		}
		count++;
		wait 0.05;
	}
	self thread explodable_barrel_explode();
}

explodable_barrel_explode()
{
	self notify ("exploding");
	self notify ("death");
	
	level thread playSoundInSpace(level.barrelExpSound, self.origin);
	playfx (level.breakables_fx["barrel"]["explode"], self.origin);
	
	level.barrelExplodingThisFrame = true;
	
	if (isdefined (self.remove))
	{
		self.remove connectpaths();
		self.remove delete();
	}
	
	if (randomint(2) == 0)
		self setModel("xmodel/prop_barrel_piece");
	else
		self setModel("xmodel/prop_barrel_piece2");
	
	minDamage = 1;
	maxDamage = 250;
	blastRadius = 250;
	if (isdefined(self.radius))
		blastRadius = self.radius;
	radiusDamage(self.origin + (0,0,56), blastRadius, maxDamage, minDamage);
	
	wait 0.05;
	level.barrelExplodingThisFrame = false;
}

shuddering_entity_think()
{
	assert (self.classname == "script_model");
	helmet = false;
	if(self.model == "xmodel/prop_helmet_german_normandy")
		helmet = true;
	self setcandamage(true);
	for(;;)
	{
        self waittill("damage", other, damage, direction_vec, point );    
        if(helmet)
        	self vibrate(direction_vec, 20, 0.6, 0.75 );
        else
        	self vibrate(direction_vec, 0.4, 0.4, 0.4 );
        self waittill("rotatedone");
    }
}

tincan_think()
{
	if (self.classname != "script_model")
		return;
	
	self setcandamage(true);
	self waittill ("damage", damage, ent);
	
	if (isSentient(ent))
		direction_org = ((ent getEye()) - (0,0,(randomint(50) + 50)));
	else
		direction_org = ent.origin;
	
	direction_vec = vectornormalize (self.origin - direction_org);
	direction_vec = vectorScale(direction_vec, .5 + randomfloat(1));
	
	self notify ("death");
	playfx (level.breakables_fx["tincan"], self.origin, direction_vec);
	self delete();
}

helmet_pop()
{
	if (self.classname != "script_model")
		return;
	self xenon_auto_aim();
	
	self setcandamage(true);
	self thread helmet_logic();
}

helmet_logic()
{
	self waittill ("damage", damage, ent);
	
	if(level.script == "moscow" && (!isdefined(self.norecreate)) && ent == level.player) 
	{
		level._moscow_xauto_helmetarray[level._moscow_xauto_helmetarray.size] = self;
		if(level.xenon)
			self.autoaim.recreate = true;
		if(level._moscow_xauto_helmetarray.size > 13)
		{
			helmetspwn = getFurthestEnt(self.origin, level._moscow_xauto_helmetarray);
			level._moscow_xauto_helmetarray = array_remove ( level._moscow_xauto_helmetarray , helmetspwn );
			helmetspwn notify("recreate");
			if(level.xenon)
			{
				helmetspwn.autoaim.recreate = false;
				helmetspwn.autoaim notify("recreate");
			}
		}
	}	
	
	if (isSentient(ent))
		direction_org = ent getEye();
	else
		direction_org = ent.origin;
	
	direction_vec = vectornormalize (self.origin - direction_org);
	
	if(!(isdefined(self.dontremove) || (level.script == "moscow"  && (!isdefined(self.norecreate)))) && ent == level.player)
		self thread animscripts\death::helmetMove(direction_vec);
	else
	{	
		self notsolid();
		self hide();
		model = spawn("script_model", self.origin + (0,0,5));
		model.angles = self.angles;
		model setmodel(self.model);
		model thread animscripts\death::helmetMove(direction_vec);
		
		if(level.script == "moscow"  && (!isdefined(self.norecreate)) && ent == level.player)
		{
			self waittill("recreate");
			self solid();
			self show();
			self thread helmet_logic();
		}
		else
		{
			self.dontremove = false;
			self notify("ok_remove");
		}
	}
}

allowBreak(ent)
{
	if (!isdefined (level.breakingEnts))
		return true;
		
	if (level.breakingEnts.size == 0)
		return false;
	else
	{
		for (i=0;i<level.breakingEnts.size;i++)
		{
			if (ent == level.breakingEnts[i])
				return true;
		}
		return false;
	}
	return true;
}

breakable_think_triggered(eBreakable)
{
	for (;;)
	{
		self waittill ("trigger", other);
		eBreakable notify("damage", 100, other);
	}
}

breakable_think()
{
	if (self.classname != "script_model")
		return;
	if (!isdefined (self.model))
		return;
	
	type = undefined;
	
	if(self.model == "xmodel/egypt_prop_vase1" || self.model == "xmodel/egypt_prop_vase3" || self.model == "xmodel/egypt_prop_vase4")
	{
		if(!isdefined(level.precachemodeltype["xmodel/egypt_prop_vase_o"]))
		{
			level.precachemodeltype["xmodel/egypt_prop_vase_o"]	= true;
			precacheModel("xmodel/egypt_prop_vase_br2");
			precacheModel("xmodel/egypt_prop_vase_br5");
			precacheModel("xmodel/egypt_prop_vase_br7");
		}
		type = "orange vase";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/egypt_prop_vase2" || self.model == "xmodel/egypt_prop_vase5" || self.model == "xmodel/egypt_prop_vase6")
	{
		if(!isdefined(level.precachemodeltype["xmodel/egypt_prop_vase_g"]))
		{
			level.precachemodeltype["xmodel/egypt_prop_vase_g"]	= true;
			precacheModel ("xmodel/egypt_prop_vase_br1");
			precacheModel("xmodel/egypt_prop_vase_br3");
			precacheModel("xmodel/egypt_prop_vase_br4");
			precacheModel("xmodel/egypt_prop_vase_br6");
		}
		type = "green vase";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_crate_dak1" || self.model == "xmodel/prop_crate_dak2" || self.model == "xmodel/prop_crate_dak3" || self.model == "xmodel/prop_crate_dak4" || self.model == "xmodel/prop_crate_dak5" || self.model == "xmodel/prop_crate_dak6" || self.model == "xmodel/prop_crate_dak7" || self.model == "xmodel/prop_crate_dak8" || self.model == "xmodel/prop_crate_dak9")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_crate_dak_shard"]))
		{
			level.precachemodeltype["xmodel/prop_crate_dak_shard"] = true;
			precacheModel("xmodel/prop_crate_dak_shard");
		}
		type = "wood box";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_winebottle_breakable")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_winebottle"]))
		{
			level.precachemodeltype["xmodel/prop_winebottle"] = true;
			precacheModel("xmodel/prop_winebottle_broken_top");
			precacheModel("xmodel/prop_winebottle_broken_bot");
		}
		type = "bottle";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_roundfloral")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenfloral1");
			precacheModel("xmodel/prop_diningplate_brokenfloral2");
			precacheModel("xmodel/prop_diningplate_brokenfloral3");
			precacheModel("xmodel/prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "round_floral";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_roundplain")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenplain"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenplain1");
			precacheModel("xmodel/prop_diningplate_brokenplain2");
			precacheModel("xmodel/prop_diningplate_brokenplain3");
			precacheModel("xmodel/prop_diningplate_brokenplain4");
		}
		type = "plate";
		self.plate = "round_plain";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_roundstack")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenplain"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenplain1");
			precacheModel("xmodel/prop_diningplate_brokenplain2");
			precacheModel("xmodel/prop_diningplate_brokenplain3");
			precacheModel("xmodel/prop_diningplate_brokenplain4");
		}
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenfloral1");
			precacheModel("xmodel/prop_diningplate_brokenfloral2");
			precacheModel("xmodel/prop_diningplate_brokenfloral3");
			precacheModel("xmodel/prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "round_stack";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_ovalfloral")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenfloral1");
			precacheModel("xmodel/prop_diningplate_brokenfloral2");
			precacheModel("xmodel/prop_diningplate_brokenfloral3");
			precacheModel("xmodel/prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "oval_floral";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_ovalplain")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenplain"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenplain1");
			precacheModel("xmodel/prop_diningplate_brokenplain2");
			precacheModel("xmodel/prop_diningplate_brokenplain3");
			precacheModel("xmodel/prop_diningplate_brokenplain4");
		}
		type = "plate";
		self.plate = "oval_plain";
		self xenon_auto_aim();
	}
	else if(self.model == "xmodel/prop_diningplate_ovalstack")
	{
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenplain"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenplain1");
			precacheModel("xmodel/prop_diningplate_brokenplain2");
			precacheModel("xmodel/prop_diningplate_brokenplain3");
			precacheModel("xmodel/prop_diningplate_brokenplain4");
		}
		if(!isdefined(level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["xmodel/prop_diningplate_brokenfloral"] = true;	
			precacheModel("xmodel/prop_diningplate_brokenfloral1");
			precacheModel("xmodel/prop_diningplate_brokenfloral2");
			precacheModel("xmodel/prop_diningplate_brokenfloral3");
			precacheModel("xmodel/prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "oval_stack";
		self xenon_auto_aim();
	}
	if(!isdefined(type))
	{
		println ("Entity ",  self.targetname," at ", self.origin, " is not a valid breakable object.");
		return;
	}
	
	if (isdefined (self.target))
	{
		trig = getent (self.target,"targetname");
		if ( (isdefined (trig)) && (trig.classname == "trigger_multiple") )
			trig thread breakable_think_triggered(self);
	}
	
	self setcandamage(true);
	self thread breakable_logic(type);
}

breakable_logic(type)
{
	ent = undefined;
	for (;;)
	{
		self waittill("damage", amount, ent);
		if(isdefined(ent) && ent.classname == "script_vehicle")
			ent joltbody(self.origin+(0,0,-90),.2);
		if (type == "wood box")
		{
			if (!allowBreak(ent))
				continue;
			if ( (!isdefined (level.flags)) || (!isdefined (level.flags["Breakable Boxes"])) )
				break;
			if ( (isdefined (level.flags["Breakable Boxes"])) && (level.flags["Breakable Boxes"] == true) )
				break;
			continue;
		}
		break;
	}
	
	self notify ("death");
	
	soundAlias = undefined;
	fx = undefined;
	hasDependant = false;
	switch (type)
	{
		case "orange vase":
		case "green vase":
			soundAlias = "bullet_large_vase";
			fx = level.breakables_fx["vase"];
			break;
		case "wood box":
			if (isdefined(level.crateImpactSound))
				soundAlias = level.crateImpactSound;
			else
				soundAlias = "bullet_large_vase";
			fx = level.breakables_fx["box"][randomint(level.breakables_fx["box"].size)];
			hasDependant = true;
			break;
		case "bottle":
			soundAlias = "bullet_small_bottle";
			fx = level.breakables_fx["bottle"];
			break;
		case "plate":
			soundAlias = "bullet_small_plate";
			break;
	}
	thread playSoundinSpace (soundAlias, self.origin );
	self thread make_broken_peices(self, type);
	if(isdefined(fx))
		playfx( fx, self.origin );
	
	//certain types should destroy objects sitting on top of them
	if (hasDependant)
	{
		others = getentarray("breakable","targetname");
		for (i=0;i<others.size;i++)
		{
			other = others[i];	
			//see if it's within 40 units from this box on X or Y
			diffX = abs(self.origin[0] - other.origin[0]);
			diffY = abs(self.origin[1] - other.origin[1]);
			
			if ( (diffX <= 20) && (diffY <= 20) )
			{
				//see if it's above the box (would probably be resting on it)
				diffZ = (self.origin[2] - other.origin[2]);
				if (diffZ <= 0)
					other notify ("damage", amount, ent);
			}
		}
	}
	
	if (isdefined (self.remove))
	{
		self.remove connectpaths();
		self.remove delete();
	}
	
	if(level.script == "moscow" && (type == "plate" || type == "bottle") && (!isdefined(self.norecreate)) && ent == level.player) 
	{
		level._moscow_xauto_targetarray[level._moscow_xauto_targetarray.size] = self;
		if(level.xenon)
			self.autoaim.recreate = true;
		if(level._moscow_xauto_targetarray.size > 20)
		{
			targetspwn = getFurthestEnt(self.origin, level._moscow_xauto_targetarray);
			level._moscow_xauto_targetarray = array_remove ( level._moscow_xauto_targetarray , targetspwn );
			targetspwn notify("recreate");
			if(level.xenon)
			{
				targetspwn.autoaim.recreate = false;
				targetspwn.autoaim notify("recreate");
			}
		}
		
		self notsolid();
		self hide();
		self waittill("recreate");
		self solid();
		self show();
		self thread breakable_logic(type);
		return;
	}	

	if(!isdefined(self.dontremove))
		self delete();

	else
		self.dontremove = false;
		self notify("ok_remove");
}

xenon_auto_aim()
{
	if(	(isdefined (level.xenon_auto_aim)) && (level.xenon_auto_aim.size > 0))
		self.autoaim = getClosestAccurantEnt( self.origin , level.xenon_auto_aim );

	if (isdefined (self.autoaim))
	{
		level.xenon_auto_aim = array_remove ( level.xenon_auto_aim , self.autoaim );
		self thread xenon_remove_auto_aim();	
	}
}

xenon_auto_aim_stop_logic()
{
	self notify("entered_xenon_auto_aim_stop_logic");
	self endon("entered_xenon_auto_aim_stop_logic");
	
	self.autoaim waittill("xenon_auto_aim_stop_logic");
	self.dontremove = undefined;
}

xenon_remove_auto_aim(wait_message)
{
	self thread xenon_auto_aim_stop_logic();
	self endon("xenon_auto_aim_stop_logic");
	self.autoaim endon("xenon_auto_aim_stop_logic");
	
	self notify("xenon_remove_auto_aim");
	self.autoaim thread xenon_enable_auto_aim(wait_message);
	self.dontremove = true;
	self waittill("damage", amount, ent);


	self.autoaim disableAimAssist();
	
	if (level.script == "moscow" && (!isdefined(self.norecreate)) && ent == level.player)
	{
		self waittill("recreate");
		self xenon_remove_auto_aim(self.autoaim.wait_message);
	}
	else
	{
		self.autoaim delete();
		if(self.dontremove)
			self waittill("ok_remove");
		self delete();
	}
	
}

xenon_enable_auto_aim(wait_message)
{
	self endon("xenon_auto_aim_stop_logic");
	self endon("death");
	if(!isdefined(wait_message))
		wait_message = true;
	
	if(isdefined(self.script_noteworthy) && wait_message)
	{
		string = "enable_xenon_autoaim_" + self.script_noteworthy;
		level waittill(string);
	}
	
	self.wait_message = false;
	if(isdefined(self.recreate) && self.recreate == true)
		self waittill("recreate");
	self enableAimAssist();
}

breakable_clip()
{
	//targeted brushmodels take priority over proximity based breakables - nate
	if (isdefined(self.target))
	{
		targ = getent(self.target,"targetname");
		if(targ.classname == "script_brushmodel")
		{
			self.remove = targ;
			return;
		}
	}
	//setup it's removable clip part
	if ((isdefined (level.breakables_clip)) && (level.breakables_clip.size > 0))
		self.remove = getClosestEnt( self.origin , level.breakables_clip );
	if (isdefined (self.remove))
		level.breakables_clip = array_remove ( level.breakables_clip , self.remove );
}

make_broken_peices(wholepiece, type)
{	
	rt		= anglesToRight (wholepiece.angles);
	fw		= anglesToForward (wholepiece.angles);	
	up	 	= anglesToUp (wholepiece.angles);	
	
	piece = [];
	switch(type)
	{
		case "orange vase":
			piece[piece.size] = addpiece(rt, fw, up, -7, 0, 22, wholepiece, (0,0,0), "xmodel/egypt_prop_vase_br2");
			piece[piece.size] = addpiece(rt, fw, up, 13, -6, 28, wholepiece, (0, 245.1, 0), "xmodel/egypt_prop_vase_br7");
			piece[piece.size] = addpiece(rt, fw, up, 12, 10, 27, wholepiece, (0, 180, 0), "xmodel/egypt_prop_vase_br7");
			piece[piece.size] = addpiece(rt, fw, up, 3, 2, 0, wholepiece, (0, 0, 0), "xmodel/egypt_prop_vase_br5");
			break;
		case "green vase":
			piece[piece.size] = addpiece(rt, fw, up, -6, -1, 26, wholepiece, (0,0,0), "xmodel/egypt_prop_vase_br1");
			piece[piece.size] = addpiece(rt, fw, up, 12, 1, 31, wholepiece, (0, 348.5, 0), "xmodel/egypt_prop_vase_br3");
			piece[piece.size] = addpiece(rt, fw, up, 6, 13, 29, wholepiece, (0, 153.5, 0), "xmodel/egypt_prop_vase_br6");
			piece[piece.size] = addpiece(rt, fw, up, 3, 1, 0, wholepiece, (0, 0, 0), "xmodel/egypt_prop_vase_br4");
			break;
		case "wood box":
			piece[piece.size] = addpiece(rt, fw, up, -10,  10, 25, wholepiece, (0,  0,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10,  10, 25, wholepiece, (0, 90,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10, -10, 25, wholepiece, (0,180,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, -10, -10, 25, wholepiece, (0,270,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, 10,  10, 5, wholepiece, (180,  0,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10,  -10, 5, wholepiece, (180, 90,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  -10, -10, 5, wholepiece, (180,180,0), "xmodel/prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, -10, 10, 5, wholepiece, (180,270,0), "xmodel/prop_crate_dak_shard");
			break;
		case "bottle":
			piece[piece.size] = addpiece(rt, fw, up, 0, 0, 10, wholepiece, (0, 0,0), "xmodel/prop_winebottle_broken_top");		piece[piece.size-1].type = "bottle_top";
			piece[piece.size] = addpiece(rt, fw, up, 0, 0, 0, wholepiece, (0, 0,0), "xmodel/prop_winebottle_broken_bot");		piece[piece.size-1].type = "bottle_bot";
			break;
		case "plate":
		{
			switch(wholepiece.plate)
			{
				case "round_floral":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "xmodel/prop_diningplate_brokenfloral1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "xmodel/prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "xmodel/prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					break;
				case "round_plain":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "xmodel/prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "xmodel/prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					break;
				case "round_stack":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "xmodel/prop_diningplate_brokenfloral1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "xmodel/prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "xmodel/prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -4, 3, 2.5, wholepiece, (0, 60, 0), "xmodel/prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -1, -3, 2.5, wholepiece, (0, 59.8,0), "xmodel/prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, -1, 2.5, wholepiece, (0, 60.2,0), "xmodel/prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, 4, 2.5, wholepiece, (0, 56.8,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, 4.5, wholepiece, (0, 150, 0), "xmodel/prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, 4.5, wholepiece, (0, 149.8,0), "xmodel/prop_diningplate_brokenfloral2");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, 4.5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, 4.5, wholepiece, (0, 146.8,0), "xmodel/prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					break;
				case "oval_floral":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "xmodel/prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "xmodel/prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "xmodel/prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "xmodel/prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					break;
				case "oval_plain":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "xmodel/prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "xmodel/prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					break;
				case "oval_stack":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "xmodel/prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "xmodel/prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "xmodel/prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "xmodel/prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "xmodel/prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -4, 5, 2.5, wholepiece, (0, 25.9, 0), "xmodel/prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 6, 0, 2.5, wholepiece, (0, 172.2,0), "xmodel/prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, -1, 2.5, wholepiece, (0, 330.2,0), "xmodel/prop_diningplate_brokenplain3");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, -4, 2.5, wholepiece, (0, 282.3,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, 4, 2.5, wholepiece, (0, 66.7,0), "xmodel/prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					break;
			}
		}break;
		default:
			return;
	}
	array_thread(piece, ::pieces_move, wholepiece.origin);
	
	if ( (isdefined (level.breakables_peicesCollide[type])) && (level.breakables_peicesCollide[type] == true) )
	{
		height = piece[0].origin[2];
		for(i = 0; i<piece.size; i++)
		{
			if (height > piece[i].origin[2])
				height = piece[i].origin[2];
		}
		array_thread(piece, ::pieces_collision, height);
	}
	else
	{
		wait 2;
		for (i=0;i<piece.size;i++)
		{
			if (isdefined (piece[i]))
				piece[i] delete();
		}
	}
}

list_add(model)
{
	if(isdefined(level._breakable_utility_modelarray[level._breakable_utility_modelindex]))
		level._breakable_utility_modelarray[level._breakable_utility_modelindex] delete();
	level._breakable_utility_modelarray[level._breakable_utility_modelindex] = model;
	level._breakable_utility_modelindex++;
	
	if(!(level._breakable_utility_modelindex < level._breakable_utility_maxnum))
		level._breakable_utility_modelindex = 0;	
}

pieces_move(origin)
{
	self endon ("do not kill");
	if(isdefined(self.type) && self.type == "bottle_bot")
		return;
	
	org = spawn("script_origin", self.origin);
	self linkto(org);
	end = self.origin + (randomfloat(10) - 5, randomfloat(10) - 5, randomfloat(10) + 5);
	//end = self.origin + (randomfloat(50) - 25, randomfloat(50) - 25, randomfloat(50) + 25);
	
	vec = undefined;
	if(isdefined(self.type) && self.type == "bottle_top")
	{
		vec = (randomfloat(40) - 20,randomfloat(40) - 20, 70 + randomfloat(15));
		x = 1;
		y = 1;
		z = 1;
		if (randomint(100) > 50)
			x = -1;
		if (randomint(100) > 50)
			y = -1;
		if (randomint(100) > 50)
			z = -1;
		
			org rotatevelocity((250*x,250*y, randomfloat(100)*z), 2, 0, .5);
	}
	else if(isdefined(self.type) && self.type == "plate")
	{
		vec = vectornormalize (end - origin);
		vec = vectorScale(vec, 125 + randomfloat(25));
		if (randomint(100) > 50)
			org rotateroll((800 + randomfloat (4000)) * -1, 5,0,0);
		else
			org rotateroll(800 + randomfloat (4000), 5,0,0);
	}
	else
	{
		vec = vectornormalize (end - origin);
		vec = vectorScale(vec, 60 + randomfloat(50));
		if (randomint(100) > 50)
			org rotateroll((800 + randomfloat (1000)) * -1, 5,0,0);
		else
			org rotateroll(800 + randomfloat (1000), 5,0,0);
	}
	
	
		
	org moveGravity(vec, 5);
	
	wait 5;
	if(isdefined(self))
		self unlink();
	org delete();
}

pieces_collision(height)
{
	self endon ("death");

//*************IF YOU PUT THIS BACK IN - SEARCH FOR "PLATE WAIT" AND PUT THAT BACK IN TOO*************	
//	if(isdefined(self.type) && self.type == "plate")
//		wait .35;
//	else
//*************IF YOU PUT THIS BACK IN - SEARCH FOR "PLATE WAIT" AND PUT THAT BACK IN TOO*************
		wait .1;
	trace = bullettrace(self.origin, self.origin - (0,0,50000), false, undefined);
	vec = trace["position"];
		
	while(	self.origin[2] > vec[2] )
		wait .05;
	
	self unlink();
	
	self.origin = (self.origin[0], self.origin[1], vec[2]);
	
	self notify("do not kill");
	self unlink();
}

addpiece(rt, fw, up, xs, ys, zs, wholepiece, angles, model)
{
	scale = 1;
//	if(isdefined(wholepiece.modelscale))
//		scale = wholepiece.modelscale;
		
	x 		= rt;
	y 		= fw;
	z 		= up;
	x	 	= vectorScale(x, ys * scale);
	y 		= vectorScale(y, xs * scale);
	z		= vectorScale(z, zs * scale);
	origin 		= wholepiece.origin + x + y + z;
	part 		= spawn("script_model", origin);
	part 		setmodel(model);
	part.modelscale =  scale;
	part.angles	= wholepiece.angles + angles;	
	
	list_add(part);
	
	return part;
}

getFurthestEnt(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0] getorigin(), org);
	ent = array[0];
//	dist = 256;
//	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist < dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestEnt(org, array)
{
	if (array.size < 1)
		return;
		
//	dist = distance(array[0] getorigin(), org);
//	ent = array[0];
	dist = 256;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestAccurantEnt(org, array)
{
	if (array.size < 1)
		return;
		
//	dist = distance(array[0] getorigin(), org);
//	ent = array[0];
	dist = 8;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestAimEnt(org, array)
{
	if (array.size < 1)
		return;
		
//	dist = distance(array[0] getorigin(), org);
//	ent = array[0];
	dist = 1000000;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}
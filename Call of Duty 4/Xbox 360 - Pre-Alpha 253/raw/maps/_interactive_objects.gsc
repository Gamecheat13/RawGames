#include maps\_utility;
#include common_scripts\utility;
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
			level.breakables_fx["barrel"]["explode"] 	= loadfx ("props/barrelExp");
			level.breakables_fx["barrel"]["burn_start"]	= loadfx ("props/barrel_ignite");
			level.breakables_fx["barrel"]["burn"]	 	= loadfx ("props/barrel_fire_top");
		}
		oilspill = getentarray ("oil_spill","targetname");
		if(isdefined(oilspill) && oilspill.size > 0)
		{
			level.breakables_fx["oilspill"]["burn"]		= loadfx ("props/barrel_fire");	
			level.breakables_fx["oilspill"]["spark"]	= loadfx("impacts/small_metalhit_1"); 
		}
		
		tincans = getentarray ("tincan","targetname");
		if ( (isdefined(tincans)) && (tincans.size > 0) )
			level.breakables_fx["tincan"] 				= loadfx ("props/tincan_bounce");
		
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
			level.breakables_fx["vase"] 				= loadfx ("props/vase_water");
			level.breakables_fx["bottle"] 				= loadfx ("props/wine_bottle");
			level.breakables_fx["box"][0] 				= loadfx ("props/crateExp_dust");
			level.breakables_fx["box"][1] 				= loadfx ("props/crateExp_dust");
			level.breakables_fx["box"][2] 				= loadfx ("props/crateExp_dust");
			level.breakables_fx["box"][3] 				= loadfx ("props/crateExp_ammo");
		}
		
		glassarray = getentarray("glass","targetname");
		if ( (isdefined(glassarray)) && (glassarray.size > 0) )
		{
			level._glass_info = [];
		
			level._glass_info["glass_large"]["breakfx"] = loadfx( "props/car_glass_large" );
			level._glass_info["glass_large"]["breaksnd"] = "veh_glass_break_large";
			
			level._glass_info["glass_med"]["breakfx"] = loadfx( "props/car_glass_med" );
			level._glass_info["glass_med"]["breaksnd"] = "veh_glass_break_small";
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
	
		
		level.barrelHealth = 150;
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
	if(! (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" ) )
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
	array_thread(getentarray ("oil_spill", "targetname"), ::oil_spill_think);
	array_thread(getentarray ("glass", "targetname"), ::glass_logic);
}

glass_logic()
{
	if( !isdefined(self.target) )
		assertMsg( "Destructible glass at origin (" + self.origin + ") is not targeting a cracked version" );
	cracked = getent(self.target, "targetname"); 
	if( !isdefined(cracked) )
		assertMsg( "Destructible glass at origin (" + self.origin + ") has a target but the cracked version doesn't exist" );
	
	whole = self;
	
	origin = whole getorigin();
	info = undefined;
	
	assert( isdefined( self.destructible_type ) );
	switch( self.destructible_type )
	{
		case "glass_large":
			info = "glass_large";
			break;
		case "glass_med":
			info = "glass_med";
			break;
		default:
			assertMsg( "Destructible glass 'destructible_type' key/value of '" + self.destructible_type + "' is not valid" );
			break;
	}	
	
	whole setcandamage(true);
	whole.glasshealth = 99;
	cracked hide();
	prevdamage = 0;
	direction_vec = undefined;
	
	while(whole.glasshealth > 0)
	{
		whole waittill( "damage", damage, attacker, direction_vec, point, damageType, modelName, tagName );
		whole.glasshealth -= damage;		
	}
	prevdamage = whole.glasshealth * -1;
	
	whole delete();
	cracked show();
	cracked setcandamage(true);
	cracked.glasshealth = (200) - prevdamage;
	
	while(cracked.glasshealth > 0)
	{
		cracked waittill("damage", damage, other, direction_vec);
		cracked.glasshealth -= damage;		
	}
	
	thread play_sound_in_space(level._glass_info[ info ][ "breaksnd" ], origin);
	playfx(level._glass_info[ info ][ "breakfx" ], origin, direction_vec);
	
	cracked delete();
}

oil_spill_think()
{
	self.end = getstruct(self.target, "targetname");
	self.start = getstruct(self.end.target, "targetname");
	self.barrel = getClosestEnt(self.start.origin, getentarray ("explodable_barrel","targetname"));
	
	if(isdefined(self.barrel))
	{
		self.barrel.oilspill = true;
		self thread oil_spill_burn_after();
	}
	
	self.extra = getent(self.target, "targetname");
	self setcandamage(true);
	
	while(1)
	{
		self waittill("damage", amount, attacker, direction_vec, P, type );
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		
		self.damageOwner = attacker;
		
		playfx (level.breakables_fx["oilspill"]["spark"], P, direction_vec);
		P = pointOnSegmentNearestToPoint(self.start.origin, self.end.origin, P);
		thread oil_spill_burn_section(P);
		self thread oil_spill_burn(P, self.start.origin);
		self thread oil_spill_burn(P, self.end.origin);
		break;
	}
	if(isdefined(self.barrel))
		self.barrel waittill("exploding");
	
	self.extra delete();
	self hide();
	
	wait 10;
	self delete();
}

oil_spill_burn_after()
{
	while(1)
	{
		self.barrel waittill("damage", amount ,attacker, direction_vec, P, type);
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		self.damageOwner = attacker;
		break;
	}
	self radiusdamage (self.start.origin, 4, 10, 10, self.damageOwner);
}

oil_spill_burn(P, dest)
{
	
	forward = vectornormalize(dest - P);
	dist = distance(p, dest);
	range = 8;
	interval = vector_multiply(forward, range);	
	angle = vectortoangles(forward);
	right = anglestoright(angle);
	
	barrels = getentarray ("explodable_barrel","targetname");
	distsqr = 22 * 22;
	
	test = spawn("script_origin", P);
	
	num = 0;
	while(1)
	{
		dist -= range;
		if(dist < range *.1)
			break;
			
		p += (interval + vector_multiply(right, randomfloatrange(-6, 6)));		
		
		thread oil_spill_burn_section(P);
		num++;
		if(num == 4)
		{
			badplace_cylinder("", 5, P, 64, 64);	
			num = 0;
		}
		
		test.origin = P;
		
		remove = [];
		barrels = array_removeUndefined(barrels);
		for(i=0; i<barrels.size; i++)
		{
			vec = anglestoup(barrels[i].angles);
			start = barrels[i].origin + (vector_multiply(vec, 22));
			pos = physicstrace(start, start + (0,0,-64));
			
			if(distancesquared(P, pos) < distsqr) 
			{
				remove[remove.size] = barrels[i];
				barrels[i] dodamage( (80 + randomfloat(10)) , P);
			}
		}
		for(i=0; i<remove.size; i++)
			barrels = array_remove(barrels, remove[i]);	
		wait .1;
	}		
	
	if(!isdefined(self.barrel))
		return;
	if( distance(P, self.start.origin) < 32)
		self.barrel dodamage( (80 + randomfloat(10)), P);
}

oil_spill_burn_section(P)
{
	count = 0;
	time = 0;
	playfx (level.breakables_fx["oilspill"]["burn"], P);
	/*
	while(time < 5)
	{
		attacker = undefined;
		if(isdefined(self.damageOwner))
			attacker = self.damageOwner;
		
		self radiusdamage(P, 32, 5, 1, attacker);
		time += 1;
		wait 1;
	}*/
}

explodable_barrel_think()
{	
	if (self.classname != "script_model")
		return;
	//if ( (self.model != "com_barrel_benzin") && (self.model != "com_barrel_benzin_snow") )
	//	return;
	if(!isdefined(level.precachemodeltype["com_barrel_benzin"]))
	{
		level.precachemodeltype["com_barrel_benzin"] = true;
		precacheModel("com_barrel_piece");
		precacheModel("com_barrel_piece2");	
	}
	self endon ("exploding");
	
	self breakable_clip();
	self xenon_auto_aim();
	self.damageTaken = 0;
	self setcandamage(true);
	for (;;)
	{
		self waittill("damage", amount ,attacker, direction_vec, P, type);
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		
		self.damageOwner = attacker;
		
		if (level.barrelExplodingThisFrame)
			wait randomfloat(1);
		self.damageTaken += amount;
		if (self.damageTaken == amount)
			self thread explodable_barrel_burn();
	}
}

explodable_barrel_burn()
{
	count = 0;
	startedfx = false;
	
	up = anglestoup(self.angles);
	worldup = anglestoup((0,90,0));
	dot = vectordot(up, worldup);
	
	offset1 = (0,0,0);
	offset2 =  vector_multiply(up, 44);
	
	if(dot < .5)
	{
		offset1 = vector_multiply(up, 22) - (0,0,30);
		offset2 = vector_multiply(up, 22) + (0,0,14);	
	}
	while (self.damageTaken < level.barrelHealth)
	{
		if (!startedfx)
		{
			playfx (level.breakables_fx["barrel"]["burn_start"], self.origin + offset1);
			startedfx = true;
		}
		if (count > 20)
			count = 0;
		
		playfx (level.breakables_fx["barrel"]["burn"], self.origin + offset2);
		
		if (count == 0)
		{
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
	
	up = anglestoup(self.angles);
	worldup = anglestoup((0,90,0));
	dot = vectordot(up, worldup);
	
	offset = (0,0,0);
	if(dot < .5)
	{
		start = (self.origin + vector_multiply(up, 22));
		end  = physicstrace(start, (start + (0,0,-64)));
		offset = end - self.origin;
	}
	offset += (0,0,4);
	
	level thread play_sound_in_space(level.barrelExpSound, self.origin);
	playfx (level.breakables_fx["barrel"]["explode"], self.origin + offset);
	physicsexplosionsphere( self.origin + offset, 100, 80, 1 );
	
	level.barrelExplodingThisFrame = true;
	
	if (isdefined (self.remove))
	{
		self.remove connectpaths();
		self.remove delete();
	}
	
	minDamage = 1;
	maxDamage = 250;
	blastRadius = 250;
	if (isdefined(self.radius))
		blastRadius = self.radius;
	//radiusDamage(self.origin + (0,0,56), blastRadius, maxDamage, minDamage);
	
	attacker = undefined;
	
	if(isdefined(self.damageOwner))
		attacker = self.damageOwner;
		
	self radiusDamage(self.origin + (0,0,30), blastRadius, maxDamage, minDamage, attacker);
		
	if (randomint(2) == 0)
		self setModel("com_barrel_piece");
	else
		self setModel("com_barrel_piece2");
		
			
	if(dot < .5)
	{
		start = (self.origin + vector_multiply(up, 22));
		pos = physicstrace(start, (start + (0,0,-64)));
		
		self.origin = pos;
		self.angles += (0,0,90);
			
	}
	wait 0.05;
	level.barrelExplodingThisFrame = false;
}

shuddering_entity_think()
{
	assert (self.classname == "script_model");
	helmet = false;
	if(self.model == "prop_helmet_german_normandy")
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
		self thread animscripts\death::helmetLaunch(direction_vec);
	else
	{	
		self notsolid();
		self hide();
		model = spawn("script_model", self.origin + (0,0,5));
		model.angles = self.angles;
		model setmodel(self.model);
		model thread animscripts\death::helmetLaunch(direction_vec);
		
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
	
	if(self.model == "egypt_prop_vase1" || self.model == "egypt_prop_vase3" || self.model == "egypt_prop_vase4")
	{
		if(!isdefined(level.precachemodeltype["egypt_prop_vase_o"]))
		{
			level.precachemodeltype["egypt_prop_vase_o"]	= true;
			precacheModel("egypt_prop_vase_br2");
			precacheModel("egypt_prop_vase_br5");
			precacheModel("egypt_prop_vase_br7");
		}
		type = "orange vase";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "egypt_prop_vase2" || self.model == "egypt_prop_vase5" || self.model == "egypt_prop_vase6")
	{
		if(!isdefined(level.precachemodeltype["egypt_prop_vase_g"]))
		{
			level.precachemodeltype["egypt_prop_vase_g"]	= true;
			precacheModel ("egypt_prop_vase_br1");
			precacheModel("egypt_prop_vase_br3");
			precacheModel("egypt_prop_vase_br4");
			precacheModel("egypt_prop_vase_br6");
		}
		type = "green vase";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "prop_crate_dak1" || self.model == "prop_crate_dak2" || self.model == "prop_crate_dak3" || self.model == "prop_crate_dak4" || self.model == "prop_crate_dak5" || self.model == "prop_crate_dak6" || self.model == "prop_crate_dak7" || self.model == "prop_crate_dak8" || self.model == "prop_crate_dak9")
	{
		if(!isdefined(level.precachemodeltype["prop_crate_dak_shard"]))
		{
			level.precachemodeltype["prop_crate_dak_shard"] = true;
			precacheModel("prop_crate_dak_shard");
		}
		type = "wood box";
		self breakable_clip();
		self xenon_auto_aim();
	}
	else if(self.model == "prop_winebottle_breakable")
	{
		if(!isdefined(level.precachemodeltype["prop_winebottle"]))
		{
			level.precachemodeltype["prop_winebottle"] = true;
			precacheModel("prop_winebottle_broken_top");
			precacheModel("prop_winebottle_broken_bot");
		}
		type = "bottle";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_roundfloral")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["prop_diningplate_brokenfloral"] = true;	
			precacheModel("prop_diningplate_brokenfloral1");
			precacheModel("prop_diningplate_brokenfloral2");
			precacheModel("prop_diningplate_brokenfloral3");
			precacheModel("prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "round_floral";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_roundplain")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["prop_diningplate_brokenplain"] = true;	
			precacheModel("prop_diningplate_brokenplain1");
			precacheModel("prop_diningplate_brokenplain2");
			precacheModel("prop_diningplate_brokenplain3");
			precacheModel("prop_diningplate_brokenplain4");
		}
		type = "plate";
		self.plate = "round_plain";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_roundstack")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["prop_diningplate_brokenplain"] = true;	
			precacheModel("prop_diningplate_brokenplain1");
			precacheModel("prop_diningplate_brokenplain2");
			precacheModel("prop_diningplate_brokenplain3");
			precacheModel("prop_diningplate_brokenplain4");
		}
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["prop_diningplate_brokenfloral"] = true;	
			precacheModel("prop_diningplate_brokenfloral1");
			precacheModel("prop_diningplate_brokenfloral2");
			precacheModel("prop_diningplate_brokenfloral3");
			precacheModel("prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "round_stack";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_ovalfloral")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["prop_diningplate_brokenfloral"] = true;	
			precacheModel("prop_diningplate_brokenfloral1");
			precacheModel("prop_diningplate_brokenfloral2");
			precacheModel("prop_diningplate_brokenfloral3");
			precacheModel("prop_diningplate_brokenfloral4");
		}
		type = "plate";
		self.plate = "oval_floral";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_ovalplain")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["prop_diningplate_brokenplain"] = true;	
			precacheModel("prop_diningplate_brokenplain1");
			precacheModel("prop_diningplate_brokenplain2");
			precacheModel("prop_diningplate_brokenplain3");
			precacheModel("prop_diningplate_brokenplain4");
		}
		type = "plate";
		self.plate = "oval_plain";
		self xenon_auto_aim();
	}
	else if(self.model == "prop_diningplate_ovalstack")
	{
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenplain"]))
		{
			level.precachemodeltype["prop_diningplate_brokenplain"] = true;	
			precacheModel("prop_diningplate_brokenplain1");
			precacheModel("prop_diningplate_brokenplain2");
			precacheModel("prop_diningplate_brokenplain3");
			precacheModel("prop_diningplate_brokenplain4");
		}
		if(!isdefined(level.precachemodeltype["prop_diningplate_brokenfloral"]))
		{
			level.precachemodeltype["prop_diningplate_brokenfloral"] = true;	
			precacheModel("prop_diningplate_brokenfloral1");
			precacheModel("prop_diningplate_brokenfloral2");
			precacheModel("prop_diningplate_brokenfloral3");
			precacheModel("prop_diningplate_brokenfloral4");
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
	thread play_sound_in_space (soundAlias, self.origin );
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
			piece[piece.size] = addpiece(rt, fw, up, -7, 0, 22, wholepiece, (0,0,0), "egypt_prop_vase_br2");
			piece[piece.size] = addpiece(rt, fw, up, 13, -6, 28, wholepiece, (0, 245.1, 0), "egypt_prop_vase_br7");
			piece[piece.size] = addpiece(rt, fw, up, 12, 10, 27, wholepiece, (0, 180, 0), "egypt_prop_vase_br7");
			piece[piece.size] = addpiece(rt, fw, up, 3, 2, 0, wholepiece, (0, 0, 0), "egypt_prop_vase_br5");
			break;
		case "green vase":
			piece[piece.size] = addpiece(rt, fw, up, -6, -1, 26, wholepiece, (0,0,0), "egypt_prop_vase_br1");
			piece[piece.size] = addpiece(rt, fw, up, 12, 1, 31, wholepiece, (0, 348.5, 0), "egypt_prop_vase_br3");
			piece[piece.size] = addpiece(rt, fw, up, 6, 13, 29, wholepiece, (0, 153.5, 0), "egypt_prop_vase_br6");
			piece[piece.size] = addpiece(rt, fw, up, 3, 1, 0, wholepiece, (0, 0, 0), "egypt_prop_vase_br4");
			break;
		case "wood box":
			piece[piece.size] = addpiece(rt, fw, up, -10,  10, 25, wholepiece, (0,  0,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10,  10, 25, wholepiece, (0, 90,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10, -10, 25, wholepiece, (0,180,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, -10, -10, 25, wholepiece, (0,270,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, 10,  10, 5, wholepiece, (180,  0,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  10,  -10, 5, wholepiece, (180, 90,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up,  -10, -10, 5, wholepiece, (180,180,0), "prop_crate_dak_shard");
			piece[piece.size] = addpiece(rt, fw, up, -10, 10, 5, wholepiece, (180,270,0), "prop_crate_dak_shard");
			break;
		case "bottle":
			piece[piece.size] = addpiece(rt, fw, up, 0, 0, 10, wholepiece, (0, 0,0), "prop_winebottle_broken_top");		piece[piece.size-1].type = "bottle_top";
			piece[piece.size] = addpiece(rt, fw, up, 0, 0, 0, wholepiece, (0, 0,0), "prop_winebottle_broken_bot");		piece[piece.size-1].type = "bottle_bot";
			break;
		case "plate":
		{
			switch(wholepiece.plate)
			{
				case "round_floral":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "prop_diningplate_brokenfloral1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					break;
				case "round_plain":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					break;
				case "round_stack":
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, .5, wholepiece, (0, 150, 0), "prop_diningplate_brokenfloral1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, .5, wholepiece, (0, 149.8,0), "prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, .5, wholepiece, (0, 146.8,0), "prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -4, 3, 2.5, wholepiece, (0, 60, 0), "prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -1, -3, 2.5, wholepiece, (0, 59.8,0), "prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, -1, 2.5, wholepiece, (0, 60.2,0), "prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, 4, 2.5, wholepiece, (0, 56.8,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -3, -4, 4.5, wholepiece, (0, 150, 0), "prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, -2, 4.5, wholepiece, (0, 149.8,0), "prop_diningplate_brokenfloral2");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 1, 2, 4.5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, 2, 4.5, wholepiece, (0, 146.8,0), "prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					break;
				case "oval_floral":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					break;
				case "oval_plain":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenplain3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					break;
				case "oval_stack":
					piece[piece.size] = addpiece(rt, fw, up, 4, -4, .5, wholepiece, (0, 205.9, 0), "prop_diningplate_brokenfloral1");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -6, 1, .5, wholepiece, (0, 352.2,0), "prop_diningplate_brokenfloral2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 4, 2, .5, wholepiece, (0, 150.2,0), "prop_diningplate_brokenfloral3");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -2, 5, .5, wholepiece, (0, 102.3,0), "prop_diningplate_brokenfloral4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -3, -3, .5, wholepiece, (0, 246.7,0), "prop_diningplate_brokenfloral4");	piece[piece.size-1].type = "plate";
					
					piece[piece.size] = addpiece(rt, fw, up, -4, 5, 2.5, wholepiece, (0, 25.9, 0), "prop_diningplate_brokenplain1");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 6, 0, 2.5, wholepiece, (0, 172.2,0), "prop_diningplate_brokenplain2");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, -4, -1, 2.5, wholepiece, (0, 330.2,0), "prop_diningplate_brokenplain3");	piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 2, -4, 2.5, wholepiece, (0, 282.3,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
					piece[piece.size] = addpiece(rt, fw, up, 3, 4, 2.5, wholepiece, (0, 66.7,0), "prop_diningplate_brokenplain4");		piece[piece.size-1].type = "plate";
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
#include common_scripts\utility;
#include maps\_utility;

main()
{
	level._effect["watersplash"]	= loadfx ("misc/cargoship_splash");
	level._sea_scale = 1;
	
	level.sea_model = getent("sea","targetname");
	level._sea_org = spawn("script_origin", level.sea_model.origin);
	level._sea_org.offset = vector_multiply(level.sea_model.origin, -1);
	level._sea_link = spawn("script_origin", level.sea_model.origin);
	level._sea_link.offset = level._sea_org.offset;
	level.sea_model linkto(level._sea_link);
	
	flag_init("_sea_waves");
	flag_init("_sea_viewbob");
	flag_init("_sea_bob");
	flag_set("_sea_bob");
	
	objects = getentarray("boat_sway", "script_noteworthy");
	array_thread(objects, ::sea_objectbob, level._sea_org);
	thread sea_logic();
	return;
}

sea_logic()
{
	wait .05;
	
	string = getdvar("r_lightTweakSunDirection");
	token = strtok(string, " ");
	level.lite_settings = (int(token[0]), int(token[1]), int(token[2]));
	level.new_lite_settings = level.lite_settings;

	level._sea_org thread sea_bob();
	level._sea_org thread sea_litebob();
	level._sea_org thread sea_waves();
	level._sea_org thread sea_viewbob();
}

sea_objectbob_precalc(org, type)
{
	self.waittime = randomfloatrange(.5, 1);
	if(isdefined(self.setscale))
		self.scale = self.setscale;
	else
		self.scale = randomfloatrange(4, 6);
	
	swaymax = 0;
	swaynum = 0;
	
	switch(type)
	{
		case "sway1":{
			swaymax = self.sway1max;
			}break;
		case "sway2":{
			swaymax = self.sway2max;
			}break;
	}	
	
	if(self.axial)
	{
		swaycalc = (org.rotation[0] * self.pratio * self.scale) + (org.rotation[2] * self.rratio * self.scale);

		if(swaymax < abs(swaycalc))
		{
			if(swaycalc < 1)
				swaynum = swaymax * -1;
			else
				swaynum = swaymax;
		}
		else
			swaynum = swaycalc;
		
		self.ang = (self.angles[0], self.angles[1], swaynum);
	}
		
	else
		self.ang = vector_multiply(org.rotation, self.scale);
}

sea_objectbob(org)
{
	if(isdefined(self.targetname))
	{
		dependants = getentarray(self.targetname, "target");
		for(i=0; i<dependants.size; i++)
			dependants[i] linkto(self);
	}
	
	nodes = getstructarray (self.target,"targetname");
	A = nodes[0].origin;
	B = undefined;
	ent = spawn ("script_model",(0,0,0));
	ent.axial = false;
	
	if(isdefined(nodes[1]))
	{
		B = nodes[1].origin;
		ent.axial = true;
	}
	else
	{
		vec = anglestoup(nodes[0].angles);
		vec = vector_multiply(vec, 10);
		B = A+vec;	
	}
	
	ent.origin = A;
	ent.angles = vectortoangles (B - A);
	ent.pratio = 1;
	ent.rratio = 1;
	ent.sway1max = 100;
	ent.sway2max = 100;
	ent.setscale = undefined;
	
	if(isdefined(nodes[0].script_parameters))
	{
		token = strtok(nodes[0].script_parameters, ":;, ");
		for(i=0; i<token.size; i++)
		{
			switch (token[i])
			{
				case "axial":{
					ent.axial = true;
					}break;	
				case "sway1":{
					i++;
					ent.sway1max = int(token[i]);
					}break;
				case "sway2":{
					i++;
					ent.sway2max = int(token[i]);
					}break;
				case "setscale":{
					i++;
					if(token[i] == "randomrange")
					{
						i++;
						r1 = int(token[i]);
						i++;
						r2 = int(token[i]);
						ent.setscale = randomfloatrange(r1, r2);
					}
					else
						ent.setscale = int(token[i]);
					}break;
			}
		}
	}
	
	if(ent.axial)
	{
		ang 	= undefined;
		world 	= (0,360,0);
		
		if(!isdefined(nodes[1]))
			ang = nodes[0].angles;
		else
			ang = vectortoangles(B-A);
			
		ent.rratio = vectordot(anglestoright(ang), anglestoright(world));
		ent.pratio = vectordot(anglestoright(ang), anglestoforward(world));
	}
	
	self.link = ent;
	self notify("got_link");
	
	for(i=0; i<nodes.size; i++)
		nodes[i] thread sea_objectbob_findparent(ent, org);
	
	wait .05;
	
	self linkto (ent);
	if(isdefined(self.script_parameters))
	{
		token = strtok(self.script_parameters, ":;, ");
		for(i=0; i<token.size; i++)
		{
			switch (token[i])
			{
				case "snd":{
					i++;
					fxent = maps\_createfx::createLoopSound();
					fxent.v["soundalias"] = token[i];
					fxent.v["origin"] = self.origin;
					fxent.v["fxid"] = "chains";
					
					fxent.v["angles"] = vectortoangles( ( fxent.v["origin"] + (0,0,100) ) - fxent.v["origin"] );
					fxent maps\_createfx::update_fx_looper(true);
				}break;
			}
		}
	}

	while(1)
	{
		org waittill("sway1");
			
			ent sea_objectbob_precalc(org, "sway1");
			ent notify("precalcdone1");
			if(!isdefined(ent.parent))
				wait ent.waittime;
			
			ent rotateto(ent.ang, org.time, org.time * .5, org.time * .5);
		
		org waittill("sway2");
			
			ent sea_objectbob_precalc(org, "sway2");
			ent notify("precalcdone2");
			if(!isdefined(ent.parent))
				wait ent.waittime;
			
			ent rotateto(ent.ang, org.time, org.time * .5, org.time * .5);
	}
}

sea_objectbob_follow(ref)
{
	while(1)
	{
		self moveto(ref.origin, .1);
		wait .1;	
	}	
}

sea_objectbob_findparent(ent, org)
{
	if(!isdefined(self.target))
		return;
		
	ent.parent = getent(self.target, "targetname");
	if(!isdefined(ent.parent.link))
		ent.parent waittill("got_link");
	
	link = ent.parent.link;
	origin = ent.origin;
	base = spawn("script_origin", (link.origin));
	base.angles = link.angles;
	ref = spawn("script_origin", (ent.origin));
	ref.angles = ent.angles;
	ref linkto(base);
	
	ent thread sea_objectbob_follow(ref);
	
	while(1)
	{
		link waittill("precalcdone1");
		
		wait link.waittime - .05;
		base rotateto(link.ang, org.time, org.time * .5, org.time * .5);
		
		
		link waittill("precalcdone2");
		wait link.waittime - .05;
		base rotateto(link.ang, org.time, org.time * .5, org.time * .5);
	
	}	
	
}

sea_bob()
{
	self endon("manual_override");
	flag_wait("_sea_bob");

	self thread sea_bob_reset();
		
	wait .05;
	while(1)
	{
		rotationy = randomfloatrange(1, 1.75);
		rotationp = randomfloatrange(.4, .75) * level._sea_scale;
		rotationr = randomfloatrange(2, 4) * level._sea_scale;
		self.time = randomfloatrange(3, 4);
		self.rotation = (rotationp, rotationy, rotationr);	
	
		self notify("sway1");
		if(flag("_sea_bob"))
			level._sea_link rotateto(self.rotation, self.time, self.time * .5, self.time * .5);	
		self rotateto(self.rotation, self.time, self.time * .5, self.time * .5);	
		wait self.time;
		
		self.rotation = vector_multiply(self.rotation, -1);
		
		self notify("sway2");
		if(flag("_sea_bob"))
			level._sea_link rotateto(self.rotation, self.time, self.time * .5, self.time * .5);
		self rotateto(self.rotation, self.time, self.time * .5, self.time * .5);
		wait self.time;
	}
}

sea_bob_reset_loop()
{
	self endon("manual_override");
	
	flag_wait("_sea_bob");
	self thread sea_bob_reset();
}

sea_bob_reset()
{
	self endon("manual_override");
	
	level waittill("_sea_bob");
	thread sea_bob_reset_loop();

	level endon("_sea_bob");
	
	time = (1.5);
	rotation = (0,0,0);
	
	level._sea_link rotateto(rotation, time, time * .5, time * .5);
	wait time;
	wait .05;
	level.new_lite_settings = level.lite_settings;
	level._sea_link.angles = (0,0,0);
}

sea_waves()
{
	waves = sea_waves_setup();
	if(!isdefined(waves))
		return;
	
	self.oldwaves = [];
	
	while(1)
	{
		flag_wait("_sea_waves");
		self waittill("sway1");
			self thread sea_waves_fx(waves, "right");
		
		flag_wait("_sea_waves");
		self waittill("sway2");
			self thread sea_waves_fx(waves, "left");
	}
}

sea_waves_fx(waves, name)
{
	wait self.time * .5;
	range = 2;
	
	wave = random(sea_closestWaveArray(waves[name], range));
	if(!isdefined(self.oldwaves[name]))
		self.oldwaves[name] = wave;
	
	while(self.oldwaves[name] == wave)
	{
		wait .05;
		wave = random(sea_closestWaveArray(waves[name], range));
	}
	self.oldwaves[name] = wave;
	
	wave thread sea_waves_fx2();	
	
	thread play_sound_in_space("elm_wave_crash_ext", wave.origin);
}

sea_waves_fx2()
{
	wait randomfloat(.15);
	exploder(self.exploder.v["exploder"]);
}

sea_closestWaveArray(array, arraysize)
{
	temp = [];
	for (i=0;i<array.size;i++)
		array[i]._sea_dist = distancesquared(array[i].origin, level.player.origin); 
	
	for(i=0; i<array.size; i++)
		temp = sea_closestWaveLogic(temp, array[i]);
	
	temp2 = [];
	for(i=0; i<arraysize; i++)
		temp2[i] = temp[i];	
	
	return temp2;
}
sea_closestWaveLogic(array, object)
{
	if(!array.size)
	{
		array[0] = object;
		return array;
	}
	
	for(i=0; i<array.size; i++)
	{
		if(array[i]._sea_dist > object._sea_dist)
		{
			array = array_insert(array, object, i);	
			break;
		}
	}
	if(i == array.size)
		array = array_add(array, object);
	
	return array;
}

sea_waves_setup()
{
	nodes = getstructarray("wave_fx", "targetname");
	center =  getstruct("wave_fx_center", "targetname");
	
	if(!nodes.size)
		return undefined;
	
	forward = anglestoforward(center.angles);
	right = anglestoright(center.angles);
	
	waves = [];
	waves["right"] = [];
	waves["left"] = [];
	
	for(i=0; i<nodes.size; i++)
	{
		nodes[i].forward = anglestoforward(nodes[i].angles);
		nodes[i].up = anglestoup(nodes[i].angles);
		nodes[i].right = anglestoright(nodes[i].angles);
	}
	
	for(i=0; i<nodes.size; i++)
	{
		if(vectordot(nodes[i].forward, right) > 0)
			waves["right"][waves["right"].size] = nodes[i];
		else
			waves["left"][waves["left"].size] = nodes[i];
	}
	
	//now that we have our positions...lets grab our actual exploders
	array = level._waves_exploders;
	for(i=0; i<array.size; i++)
		array[i].origin =array[i].v["origin"];
		
	for(i=0; i<waves["right"].size; i++)
	{
		exp = getClosest(waves["right"][i].origin, array, 64);
		array = array_remove(array, exp);
		if(isdefined(waves["right"][i].angles))
			exp.v["forward"] = anglestoup(waves["right"][i].angles);
		waves["right"][i].exploder = exp;
	}
	for(i=0; i<waves["left"].size; i++)
	{
		exp = getClosest(waves["left"][i].origin, array, 64);
		array = array_remove(array, exp);
		if(isdefined(waves["left"][i].angles))
			exp.v["forward"] = anglestoup(waves["left"][i].angles);
		waves["left"][i].exploder = exp;
	}
	return waves;
}

sea_litebob()
{		
	while(1)
	{
		wait .05;
		ang = vector_multiply(self.angles, 2);
		level.new_lite_settings = level.lite_settings + (ang[0], ang[1]*-1, ang[2]);
		if(flag("cargoship_lighting_off"))
			setsaveddvar("r_lightTweakSunDirection", (level.new_lite_settings[0] + " " +  level.new_lite_settings[1] + " " +  level.new_lite_settings[2]));	
	}
}

sea_viewbob()
{
	ong = self.angles;
	while(1)
	{
		wait .05;
		flag_wait("_sea_viewbob");
		pang = level.player getplayerangles();
		pang = (pang[0], pang[1], 0);
		ang = self.angles;// - pang;

		for1 = anglestoforward(self.angles);
		for2 = anglestoforward(pang);
		for3 = anglestoright(pang);
		
		ang = (ang[0], ang[1], (ang[2] * vectordot(for1, for2)) + (ang[0] * vectordot(for1, for3)) );
		ong = ang;
		level.player setplayerangles(pang + (0,0,ang[2]) );
	}
}
#include maps\_utility;
#using_animtree("drones");
guy_delete (group)
{
	self endon ("death");
	group waittill ("delete time");
	self notify ("delete time");
	self delete();
}

guy_run (animname)
{
	self endon ("death");
	while (1)
	{
		self waittill ("run");
//		self thread current_target(1500, "run");
		self.move_anim = level.scr_anim[animname]["run"][self.run_index];
		self thread guy_animloop ();
	}	
}

guy_walk (animname)
{
	self endon ("death");
	while (1)
	{
		self waittill ("walk");
//		self thread current_target(1500, "walk");
		self.move_anim = level.scr_anim[animname]["walk"][self.walk_index];
		self thread guy_animloop ();
	}	
}

guy_animloop ()
{
	self endon ("walk");
	self endon ("run");
	self endon ("death");
	
	wait randomfloat(.5); // offset those anims a bit
	while (1)
	{
		self setFlaggedAnimKnob("animdone", self.move_anim);
		self waittillmatch ("animdone", "end");
	}
	
	self notify ("finished animating");
}

guy_think(group, animname, live)
{
	self endon("death");
	
//	level thread add_totalguys(self);
	self.run_index = randomint (level.scr_anim[animname]["run"].size);
	self.walk_index = randomint (level.scr_anim[animname]["walk"].size);
	self.move_anim = level.scr_anim[animname]["run"][self.run_index];
	
	
	self thread guy_delete(group);
	level thread guy_mortar_death(self);
	self endon ("mortar death");
	self UseAnimTree(#animtree);
	self [[random(level.scr_character[animname])]]();
	self.origin = group gettagorigin (self.tag);
	wait (0.1);

	self linkto (group, self.tag, (0,0,0), (0,0,0));

	self thread guy_run (animname);
	self thread guy_walk (animname);

	self thread guy_animloop ();
	self waittill ("finished animating");
			

	self unlink();
	
	deathanim = random (level.scr_anim[animname]["death"]);
	if (animname == "flag drone")
	{
		org = getStartOrigin (self.origin, self.angles, deathanim);
		ang = getStartAngles (self.origin, self.angles, deathanim);
		self moveto (org, 0.15);
		self rotateto (ang, 0.15);
		wait (0.15);
	}
	
	self animscripted("death anim", self.origin, self.angles, deathanim, "deathplant");
	self.died = true;
	self bloody_death();
	
	wait (4);
	self movez (-100, 3, 2, 1);
	wait (3);
	self delete();
}

guy_mortar (delayer)
{
	self endon ("delete time");
	wait (2);
	while (self.origin[1] < -250)
		wait (2);
		
	self playsound ("mortar_incoming", "sounddone");
	self waittill ("sounddone");
//	playfx ( random(level.drone_mortar), self.origin );
	self playsound ("mortar_explosion");

	earthquake(0.3, 3, self.origin, 850); // scale duration source radius
	radiusDamage (self.origin, 150, 150, 0);

	ai = getentarray ("drone","targetname");
	for (i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].died))
			continue;
			
		dist = distance (ai[i].origin, self.origin);
		if (dist < 200)
		{	
			ai[i].died = true;
			ai[i].mortarDeath = getExplodeDeath("drone", self.origin, dist);
			ai[i] notify ("mortar death");
			ai[i] animscripted("death anim", ai[i].origin, ai[i].angles, ai[i].mortarDeath);
			ai[i] unlink();
		}
	}
}

guy_mortar_death(guy)
{
	guy endon ("death");
	guy waittill ("mortar death");
	level thread guy_mortar_sink (guy);
}
	
guy_mortar_sink (guy)
{
	org = spawn ("script_origin",(0,0,3));
	org.origin = guy.origin;
	org.angles = guy.angles;
	guy linkto (org);
//	guy thread current_target(8000);
	if (guy.mortarDeath == level.scr_anim["drone"]["explode death up"])
	{
		upHeight = 200;
		downHeight = -500;
//		println ("^FLY SKY HIGH");
	}
	else
	{
		upHeight = 30;
		downHeight = -500;
	}
	
	org moveto (guy.origin + (0,0,upHeight), 0.3);
	wait (0.3);
	if (isdefined (guy))
		org moveto (guy.origin + (0,0,downHeight), 1.2, 1.2);
	wait (1.2);
//	self waittillmatch ("death anim", "end");
//	self bloody_death();
	org delete();
	if (isdefined (guy))
		guy delete();
}

#using_animtree("animation_rig_largegroup20");
large_group(groupnum, node, ender, flagguy, dummymodel)
{
	if(isdefined(level.large_group_delay[groupnum]))
		wait level.large_group_delay[groupnum];
	if (isdefined (ender))
		level endon (ender);
	
	group = spawn ("script_model",(1,2,3));
	group.origin = node.origin;
	group.origin = node.origin + (0, 0, 0);
	group setmodel (dummymodel);
	group hide();
	group UseAnimTree(#animtree);
	group.angles = (0,0,0);

	group setFlaggedAnimKnobRestart("animdone", level.large_group[groupnum]);
	mortarguy = randomint (20);
	guys = [];
			
	if(isdefined(level.large_group_extramodel[groupnum]))
	{
		vehicle = spawn("script_model",group gettagorigin(level.large_group_extramodel_tag[groupnum]));
		vehicle setmodel (level.large_group_extramodel[groupnum]);
		vehicle.origin = group gettagangles(level.large_group_extramodel_tag[groupnum]);
		vehicle linkto(group,level.large_group_extramodel_tag[groupnum],(0,0,0),(0,0,0));
		vehicle thread extramodel_think(group,groupnum);
	}
		
	for (i=1;i<=level.large_group_size[groupnum];i++)
	{
		if (isdefined(flagguy) && (i != flagguy) && (randomint (100) > 40))
			continue;
		
		if (i < 10)
			msg = ("guy_0" + i);
		else
			msg = ("guy_" + i);

		guy = spawn ("script_model",(1,2,3));
		guy.targetname = "drone";
		guy.tag = msg;
		guy.num = i;
		guy makeFakeAI();

		if (i == mortarguy)
			guy thread guy_mortar (i);

		if (isdefined(flagguy) && i == flagguy)
		{
			guy thread guy_think(group, "flag drone");
		}
		else
		{
			guy thread guy_think(group,  "drone");
			//guy attach ("xmodel/weapon_mosinnagant", "tag_weapon_Right");
		}

		guys[guys.size] = guy;
	}

	while (1)
	{	
		group waittill ("animdone", notetrack);
		
		if (notetrack == "end")
			break;
		
		for (i=0;i<20;i++)
		{
			if (i < 10)
				msg = ("guy0" + i);
			else
				msg = ("guy" + i);
				
			if (!isdefined (guys[i]))
				continue;
				
			if (notetrack == msg + " walk")
				guys[i] notify ("walk");
			else
			if (notetrack == msg + " run")
				guys[i] notify ("run");
		}
	}
	group notify ("delete time");
	wait .2;
	group delete();
}


bloody_death_waittill ()
{
	self waittill ("death");
	if (!isdefined (self))
		return;
	self bloody_death();
}

bloody_death()
{
	tag_array = level.scr_dyingguy["tag"];
	tag_array = array_randomize(tag_array);
	tag_index = 0;
	waiter = false;

	for (i=0;i<3 + randomint (5);i++)
	{
		playfxOnTag ( level._effect [random (level.scr_dyingguy["effect"])], self, level.scr_dyingguy["tag"][tag_index] );
//		thread playSoundOnTag(random (level.scr_dyingguy["sound"]), level.scr_dyingguy["tag"][tag_index]);

		tag_index++;
		if (tag_index >= tag_array.size)
		{
			tag_array = array_randomize(tag_array);
			tag_index = 0;
		}

		if (waiter)
		{
			wait (0.05);
			waiter = false;
		}
		else
			waiter = true;
//		wait (randomfloat (0.3));
	}
}

getExplodeDeath (msg, org, dist)
{
	if (isdefined (org))
	{
		if (dist < 50)
			return level.scr_anim[msg]["explode death up"];

		ang = vectornormalize ( self.origin - org );
		ang = vectorToAngles (ang);
		ang = ang[1];
		ang -= self.angles[1];
		if (ang <= -180)
			ang += 360;
		else
		if (ang > 180)
			ang -= 360;

		if ((ang >= 45) && (ang <= 135))
			return level.scr_anim[msg]["explode death forward"];
		if ((ang >= -135) && (ang <= -45))
			return level.scr_anim[msg]["explode death back"];
		if ((ang <= 45) && (ang >= -45))
			return level.scr_anim[msg]["explode death right"];

		return level.scr_anim[msg]["explode death left"];
	}

	randdeath = randomint(5);
	if (randdeath == 0)
		return level.scr_anim[msg]["explode death up"];
	else
	if (randdeath == 1)
		return level.scr_anim[msg]["explode death back"];
	else
	if (randdeath == 2)
		return level.scr_anim[msg]["explode death forward"];
	else
	if (randdeath == 3)
		return level.scr_anim[msg]["explode death left"];

	return level.scr_anim[msg]["explode death right"];
}

extramodel_think(group,groupnum)
{
	if(isdefined(level.large_group_extramodel_thread[groupnum]))
		self thread [[level.large_group_extramodel_thread[groupnum]]](groupnum);
	group waittill ("delete time");
	self delete();
}

//################################################
//################################################
//############## NEW FUNCTIONALITY ###############
//################################################
//################################################

init()
{
	animscripts\weaponList::initWeaponList();
	setAnimArray();
	level._effect["impact_flesh1"]				= loadfx ("fx/impacts/flesh_hit.efx");
	level.drone_muzzleflash = loadfx ("fx/muzzleflashes/standardflashworld.efx");
	
	if (!isdefined(level.traceHeight))
		level.traceHeight = 400;
	
	if (!isdefined(level.droneStepHeight))
		level.droneStepHeight = 100;
	
	if(!isdefined(level.max_drones))
		level.max_drones = [];
	if(!isdefined(level.max_drones["axis"]))
		level.max_drones["axis"] = 99999;
	if(!isdefined(level.max_drones["allies"]))
		level.max_drones["allies"] = 99999;

	if(!isdefined(level.drones))
		level.drones = [];
	if(!isdefined(level.drones["axis"]))
		level.drones["axis"] = struct_arrayspawn();
	if(!isdefined(level.drones["allies"]))
		level.drones["allies"] = struct_arrayspawn();
	init_struct_targeted_origins();
	array_thread (getentarray("drone_axis","targetname"), ::drone_triggers_wait_axis );
	array_thread (getentarray("drone_allies","targetname"), ::drone_triggers_wait_allies );
	//finish_struct_targeted_origins();
}

build_struct_targeted_origins()
{
	if (!isdefined(self.target))
		return;
	self.targeted = level.struct_targetname[self.target];
	if (!isdefined(self.targeted))
		self.targeted = [];
}

init_struct_targeted_origins()
{
	level.struct_targetname = [];

	count = level.struct.size;

	for ( i = 0; i < count; i++ )
	{
		struct = level.struct[i];
		if (!isdefined(struct.targetname))
			continue;
		struct_targetname = level.struct_targetname[struct.targetname];
		if (!isdefined(struct_targetname))
			targetname_count = 0;
		else
			targetname_count = struct_targetname.size;
		level.struct_targetname[struct.targetname][targetname_count] = struct;
	}

	for ( i = 0; i < count; i++ )
	{
		struct = level.struct[i];
		if (!isdefined(struct.target))
			continue;
		struct.targeted = level.struct_targetname[struct.target];
	}
}
/*
finish_struct_targeted_origins()
{
	level.struct = undefined;
	level.struct_targetname = undefined;
}
*/
drone_triggers_wait_axis()
{
	self build_struct_targeted_origins();
	qFakeDeath = true;
	if ( (isdefined(self.script_allowdeath)) && (self.script_allowdeath == 0) )
		qFakeDeath = false;
	qSightTrace = false;
	if ( (isdefined(self.script_trace)) && (self.script_trace > 0) )
		qSightTrace = true;
	//make sure it has data
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	self waittill ("trigger");
	if ( ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") ) || ( (isdefined(self.script_looping)) && (self.script_looping > 0) ) )
	{
		//looping
		assert( isdefined(self.script_delay) || ( isdefined(self.script_delay_min) && isdefined(self.script_delay_max) ) );
		self endon ("stop_drone_loop");
		for (;;)
		{
			//how many drones should spawn?
			spawnSize = undefined;
			if (isdefined (self.script_drones_min))
			{
				max = spawnpoint.size;
				if (isdefined (self.script_drones_max))
					max = self.script_drones_max;
				if (self.script_drones_min == max)
					spawnSize = max;
				else
					spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
			}
			
			thread drone_axis_spawngroup(spawnpoint, qFakeDeath, spawnSize, qSightTrace);
			if (isdefined(self.script_delay))
			{
				if (self.script_delay < 0)
					return;
				wait (self.script_delay);
			}
			else
				wait ( self.script_delay_min + randomfloat(self.script_delay_max - self.script_delay_min) );
			if ( (isdefined(self.script_requires_player)) && (self.script_requires_player > 0) )
				self waittill ("trigger");
		}
	}
	else	//one time only
	{
		//how many drones should spawn?
		spawnSize = undefined;
		if (isdefined (self.script_drones_min))
		{
			max = spawnpoint.size;
			if (isdefined (self.script_drones_max))
				max = self.script_drones_max;
			if (self.script_drones_min == max)
				spawnSize = max;
			else
				spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
		}
		thread drone_axis_spawngroup(spawnpoint, qFakeDeath, spawnSize, qSightTrace);
	}
}

drone_triggers_wait_allies()
{
	self build_struct_targeted_origins();
	qFakeDeath = true;
	if ( (isdefined(self.script_allowdeath)) && (self.script_allowdeath == 0) )
		qFakeDeath = false;
	qSightTrace = false;
	if ( (isdefined(self.script_trace)) && (self.script_trace > 0) )
		qSightTrace = true;
	assert(isdefined(self.targeted));
	assert(isdefined(self.targeted[0]));
	spawnPoint = self.targeted;
	assert(isdefined(spawnPoint[0]));
	
	self waittill ("trigger");
	if ( ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "looping") ) || ( (isdefined(self.script_looping)) && (self.script_looping > 0) ) )
	{
		//looping
		assert( isdefined(self.script_delay) || ( isdefined(self.script_delay_min) && isdefined(self.script_delay_max) ) );
		self endon ("stop_drone_loop");
		for (;;)
		{
			//how many drones should spawn?
			spawnSize = undefined;
			if (isdefined (self.script_drones_min))
			{
				max = spawnpoint.size;
				if (isdefined (self.script_drones_max))
					max = self.script_drones_max;
				if (self.script_drones_min == max)
					spawnSize = max;
				else
					spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
			}
			
			thread drone_allies_spawngroup(spawnpoint, qFakeDeath, spawnSize, qSightTrace);
			if (isdefined(self.script_delay))
			{
				if (self.script_delay < 0)
					return;
				wait (self.script_delay);
			}
			else
				wait ( self.script_delay_min + randomfloat(self.script_delay_max - self.script_delay_min) );
			if ( (isdefined(self.script_requires_player)) && (self.script_requires_player > 0) )
				self waittill ("trigger");
		}
	}
	else	//one time only
	{
		//how many drones should spawn?
		spawnSize = undefined;
		if (isdefined (self.script_drones_min))
		{
			max = spawnpoint.size;
			if (isdefined (self.script_drones_max))
				max = self.script_drones_max;
			if (self.script_drones_min == max)
				spawnSize = max;
			else
				spawnSize = (self.script_drones_min + randomint(max - self.script_drones_min));
		}
		thread drone_allies_spawngroup(spawnpoint, qFakeDeath, undefined, qSightTrace);
	}
}

drone_allies_spawngroup(spawnpoint, qFakeDeath, spawnSize, qSightTrace)
{
	spawncount = spawnpoint.size;
	if (isdefined(spawnSize))
	{
		spawncount = spawnSize;
		spawnpoint = array_randomize(spawnpoint);
	}
	
	for (i=0;i<spawncount;i++)
		spawnpoint[i] thread drone_allies_spawn(qFakeDeath, qSightTrace);
}

drone_axis_spawngroup(spawnpoint, qFakeDeath, spawnSize, qSightTrace)
{
	spawncount = spawnpoint.size;
	if (isdefined(spawnSize))
	{
		spawncount = spawnSize;
		spawnpoint = array_randomize(spawnpoint);
	}
	
	for (i=0;i<spawncount;i++)
		spawnpoint[i] thread drone_axis_spawn(qFakeDeath, qSightTrace);
}

drone_axis_spawn(qFakeDeath, qSightTrace)
{
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;
	
	//if qSightTrace, wait until player can't see the drone spawn point
	if (!isdefined(qSightTrace))
		qSightTrace = false;
	while ( (qSightTrace) && (self spawnpoint_playersView()) )
		wait 0.2;
	
	if (level.drones["axis"].lastindex > level.max_drones["axis"])
		return;
		
	//spawn a drone
	guy = spawn("script_model", self.origin);
	assert(isdefined(level.drone_spawnFunction["axis"]));
	guy [[level.drone_spawnFunction["axis"]]]();
	guy drone_axis_assignWeapon();
	guy.targetname = "drone";
	guy makeFakeAI();
	guy.team = "axis";
	guy.fakeDeath = qFakeDeath;
	
	guy thread drone_think( self );
}

drone_allies_spawn(qFakeDeath, qSightTrace)
{
	if (!isdefined (qFakeDeath))
		qFakeDeath = false;
	
	//if qSightTrace, wait until player can't see the drone spawn point
	if (!isdefined(qSightTrace))
		qSightTrace = false;
	while ( (qSightTrace) && (self spawnpoint_playersView()) )
		wait 0.2;
	
	if (level.drones["allies"].lastindex > level.max_drones["allies"])
		return;
		
	//spawn a drone
	guy = spawn("script_model", self.origin);
	assert(isdefined(level.drone_spawnFunction["allies"]));
	guy [[level.drone_spawnFunction["allies"]]]();
	guy drone_allies_assignWeapon();
	guy.targetname = "drone";
	guy makeFakeAI();
	guy.team = "allies";

	guy.fakeDeath = qFakeDeath;
	
	guy thread drone_think( self );
}

spawnpoint_playersView()
{
	//first check if it's within the players FOV
	if (!isdefined(level.cos80))
		level.cos80 = cos(80);
	
	prof_begin("drone_math");
		forwardvec = anglestoforward(level.player.angles);
		normalvec = vectorNormalize(self.origin - (level.player getOrigin()) );
		vecdot = vectordot(forwardvec,normalvec);
	prof_end("drone_math");
	if (vecdot > level.cos80)	//it's within the players FOV so try a trace now
	{
		prof_begin("drone_math");
			success = ( bullettracepassed(level.player getEye(), self.origin + (0,0,48), false, self) );
		prof_end("drone_math");
		return success;
	}
	
	//isn't in the field of view so it must be out of sight
	return false;
}

drone_axis_assignWeapon()
{
	randWeapon = randomint(4);
	switch(randWeapon)
	{
		case 0:
		case 1:
		case 2: self.weapon = "kar98k";	break;
		case 3:	self.weapon = "mp40";	break;
	}
	weaponModel = getWeaponModel(self.weapon);
	self attach(weaponModel, "tag_weapon_right");
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

drone_allies_assignWeapon()
{
	switch(level.campaign)
	{
		case "american":
			self.weapon = drone_allies_assignWeapon_american();
			break;
		case "british":
			self.weapon = drone_allies_assignWeapon_british();
			break;
		case "russian":
			self.weapon = drone_allies_assignWeapon_russian();
			break;
	}
	
	weaponModel = getWeaponModel(self.weapon);
	self attach(weaponModel, "tag_weapon_right");
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

drone_allies_assignWeapon_american()
{
	randWeapon = randomint(5);
	switch(randWeapon)
	{
		case 0:
		case 1:
		case 2: return "m1garand";
		case 3: return "BAR";
		case 4:	return "thompson";
	}
}

drone_allies_assignWeapon_british()
{
	randWeapon = randomint(4);
	switch(randWeapon)
	{
		case 0:
		case 1:
		case 2: return "enfield";
		case 3:	return "thompson";
	}
}

drone_allies_assignWeapon_russian()
{
	randWeapon = randomint(2);
	switch(randWeapon)
	{
		case 0: return "SVT40";
		case 1: return "ppsh";
	}
}

drone_setName()
{
	wait 0.25;
	if (!isdefined(self))
		return;
	
	//set friendlyname on allies
	if (self.team != "allies")
		return;
	
	maps\_names::setup_variables();
	
	if (isdefined(self.script_friendname))
		self.name = self.script_friendname;
	else
	{
		switch(level.campaign)
		{
			case "american":
				game["americannames"]++;
				self maps\_names::get_american_name();
				break;
			case "russian":
				game["russian_firstnames_male"]++;
				game["russian_lastnames_male"]++;
				self maps\_names::get_russian_name();
				break;
			case "british":
				game["britishnames"]++;
				self maps\_names::get_british_name();
				break;
		}
	}
	assert(isdefined(self.name));
	
	subText = undefined;
	if(!isdefined(self.weapon))
		subText = (&"WEAPON_RIFLEMAN");
	else
	{
		switch(self.weapon)
		{
			case "m1garand":
			case "enfield":
			case "m1carbine":
			case "SVT40":
				subText = (&"WEAPON_RIFLEMAN");
				break;
			case "thompson":
				subText = (&"WEAPON_SUBMACHINEGUNNER");
				break;
			case "BAR":
			case "ppsh":
				subText = (&"WEAPON_SUPPORTGUNNER");
				break;
		}
	}
	if ( (isdefined(self.model)) && (issubstr(self.model, "medic")) )
		subText = (&"WEAPON_MEDICPLACEHOLDER");
	assert(isdefined(subText));
	
	self setlookattext(self.name, subText);
}

#using_animtree("fakeshooters");
drone_think(firstNode)
{
	self.health = 1000000;
	self thread drone_setName();
	
	level thread maps\_spawner::killfriends_missionfail_think(self);
	self thread drones_clear_variables();
	structarray_add(level.drones[self.team],self);
	level notify ("new_drone");
	if (level.script != "duhoc_assault")
	{
		self.turrettarget = spawn ("script_origin",self.origin+(0,0,50));
		self.turrettarget linkto (self);
	}
	self endon ("drone_death");
	assert(isdefined(firstNode));
	
	//fake death if this drone is told to do so
	if ( (isdefined(self.fakeDeath)) && (self.fakeDeath == true) )
		self thread drone_fakeDeath();
	
	self endon ("drone_shooting");
	self drone_runChain(firstNode);
	wait 0.05;
	self.running = undefined;
	if (!isdefined(self))
		return;
	idle_org = self.origin;
	idle_ang = self.angles;
	self useAnimTree(#animtree);
	idleAnim[0] = %stand_alert_1;
	idleAnim[1] = %stand_alert_2;
	idleAnim[2] = %stand_alert_3;
	while(isdefined(self))
	{
		self animscripted("drone_idle_anim", idle_org, idle_ang, idleAnim[randomint(idleAnim.size)]);
		self waittillmatch("drone_idle_anim","end");
	}
}

#using_animtree("duhoc_drones");
drone_mortarDeath(direction)
{
	self useAnimTree(#animtree);
	switch(direction)
	{
		case "up":
			self thread drone_doDeath(%death_explosion_up10);
			break;
		case "forward":
			self thread drone_doDeath(%death_explosion_forward13);
			break;
		case "back":
			self thread drone_doDeath(%death_explosion_back13);
			break;
		case "left":
			self thread drone_doDeath(%death_explosion_left11);
			break;
		case "right":
			self thread drone_doDeath(%death_explosion_right13);
			break;
	}
}

#using_animtree("duhoc_drones");
drone_fakeDeath(instant)
{
	if (!isdefined(instant))
		instant = false;
	
	self endon ("delete");
	self endon ("drone_death");
	
	while(isdefined(self))
	{
		if (!instant)
		{
			self setCanDamage(true);
			self waittill ("damage", amount, attacker, parm1, parm2, parm3);
			if (parm3 == "MOD_GRENADE_SPLASH")
				self.damageweapon = "none";
			self notify ("death", attacker, parm3);
			
			if ( attacker == level.player || attacker == level.playervehicle)
				level notify ( "player killed drone" );
		}
		
		if ( (isdefined(self.customFirstAnim)) && (self.customFirstAnim == true) )
			self waittill ("customFirstAnim done");
		
		if (!isdefined(self))
			return;
		
		self notify ("Stop shooting");
		self.dontDelete = true;
		
		deathAnim = undefined;
		self useAnimTree(#animtree);
		
		if (isdefined(self.running))
		{
			deaths[0] = %death_run_stumble;
			deaths[1] = %death_run_onfront;
			deaths[2] = %death_run_onleft;
			deaths[3] = %death_run_forward_crumple;
		}
		else
		{
			deaths[0] = %death_stand_dropinplace;
		}
		
		self thread drone_doDeath( deaths[randomint(deaths.size)] );
		return;
	}
}

#using_animtree("duhoc_drones");
drone_delayed_bulletdeath(waitTime, deathRemoveNotify)
{
	self endon ("delete");
	self endon ("drone_death");
	
	self.dontDelete = true;
	
	if (!isdefined(waitTime))
		waitTime = 0;
	if (waitTime > 0)
		wait (waitTime);
	
	self thread drone_fakeDeath(true);
}

#using_animtree("duhoc_drones");
drone_doDeath(deathAnim, deathRemoveNotify)
{
	self moveTo (self.origin, 0.05, 0, 0);
	
	traceDeath = false;
	if ( (isdefined(self.running)) && (self.running == true) )
		traceDeath = true;
	self.running = undefined;
	self notify ("drone_death");
	self notify ("Stop shooting");
	self unlink();
	self useAnimTree(#animtree);
	self thread drone_doDeath_impacts();
	
	if (randomint(3) == 0)
	{
		alias = "generic_death_american_" + (1 + randomint(6));
		self thread playsoundinspace(alias);
	}
	
	prof_begin("drone_math");
	cancelRunningDeath = false;
	if (traceDeath)
	{
		//trace last frame of animation to prevent the body from clipping on something coming up in its path
		//backup animation if trace fails: %death_stand_dropinplace
		
		offset = getcycleoriginoffset( self.angles, deathAnim );
		endAnimationLocation = (self.origin + offset);
		endAnimationLocation = physicstrace( (endAnimationLocation + (0,0,128)), (endAnimationLocation - (0,0,128)) );
		//thread debug_line( endAnimationLocation + (0,0,256), endAnimationLocation - (0,0,256) );
		d1 = abs(endAnimationLocation[2] - self.origin[2]);
		
		if (d1 > 20)
			cancelRunningDeath = true;
		else
		{
			//trace even more forward than the animation (bounding box reasons)
			forwardVec = anglestoforward(self.angles);
			rightVec = anglestoright(self.angles);
			upVec = anglestoup(self.angles);
			relativeOffset = (50,0,0);
			secondPos = endAnimationLocation;
			secondPos += vectorMultiply(forwardVec, relativeOffset[0]);
			secondPos += vectorMultiply(rightVec, relativeOffset[1]);
			secondPos += vectorMultiply(upVec, relativeOffset[2]);
			secondPos = physicstrace( (secondPos + (0,0,128)), (secondPos - (0,0,128)) );
			d2 = abs(secondPos[2] - self.origin[2]);
			if (d2 > 20)
				cancelRunningDeath = true;
		}
	}
	prof_end("drone_math");
	
	if (cancelRunningDeath)
		deathAnim = %death_stand_dropinplace;
	
	self animscripted("drone_death_anim", self.origin, self.angles, deathAnim, "deathplant");
	self waittillmatch("drone_death_anim","end");
	
	if (!isdefined(self))
		return;
	self setcontents(0);
	if (isdefined(deathRemoveNotify))
		level waittill (deathRemoveNotify);
	else
		wait 3;
	if (!isdefined(self))
		return;
	self moveto(self.origin - (0,0,100), 7);
	wait 3;
	if (!isdefined(self))
		return;
	self.dontDelete = undefined;
	self thread drone_delete();
}
/*
debug_line(start, end)
{
	seconds = 5;
	cycles = (seconds * 20);
	for( i = 0 ; i < cycles ; i++ )
	{
		line (start, end, (1,1,1) );
		wait 0.05;
	}
}
*/
drone_doDeath_impacts()
{
	bone[0] = "J_Knee_LE";
	bone[1] = "J_Ankle_LE";
	bone[2] = "J_Clavicle_LE";
	bone[3] = "J_Shoulder_LE";
	bone[4] = "J_Elbow_LE";
	
	impacts = (1 + randomint(2));
	for (i=0;i<impacts;i++)
	{
		playfxontag( level._effect["impact_flesh1"], self, bone[randomint(bone.size)] );
		self playsound ("bullet_small_flesh");
		wait 0.05;
	}
}

drone_runChain(point_start)
{
	self endon ("drone_death");
	self endon ("drone_shooting");
	runPos = undefined;
	while(isdefined(self))
	{
		//check for script_death, script_death_min, script_death_max, and script_delete
		//-----------------------------------------------------------------------------
		if (isdefined(point_start.script_death))
		{
			//drone will die in this many seconds
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(0);
		}
		else
		if ( (isdefined(point_start.script_death_min)) && (isdefined(point_start.script_death_max)) )
		{
			//drone will die between min-max seconds
			self.dontDelete = true;
			self thread drone_delayed_bulletdeath(point_start.script_death_min + randomfloat( point_start.script_death_max - point_start.script_death_min));
		}
		
		if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
			self thread drone_delete(point_start.script_delete);
		
		//-----------------------------------------------------------------------------
		
		if (!isdefined(point_start.targeted))
			break;
		point_end = point_start.targeted;
		if ( (!isdefined(point_end)) || (!isdefined(point_end[0])) )
			break;
		index = randomint(point_end.size);
		
		runPos = point_end[index].origin;
		
		//check for radius on node, since you can now make them run to a radius rather than an exact point
		if (isdefined(point_end[index].radius))
		{
			assert(point_end[index].radius > 0);
			
			//offset for this drone (-1 to 1)
			if (!isdefined(self.droneRunOffset))
				self.droneRunOffset = (0 - 1 + (randomfloat(2)) );
			
			if (!isdefined(point_end[index].angles))
				point_end[index].angles = (0,0,0);
				
			prof_begin("drone_math");
				forwardVec = anglestoforward(point_end[index].angles);
				rightVec = anglestoright(point_end[index].angles);
				upVec = anglestoup(point_end[index].angles);
				relativeOffset = (0, (self.droneRunOffset * point_end[index].radius) ,0);
				runPos += vectorMultiply(forwardVec, relativeOffset[0]);
				runPos += vectorMultiply(rightVec, relativeOffset[1]);
				runPos += vectorMultiply(upVec, relativeOffset[2]);
			prof_end("drone_math");
		}
		
		if (isdefined(point_start.script_noteworthy))
			self ShooterRun(runPos, point_start.script_noteworthy);
		else
			self ShooterRun(runPos);
		
		point_start = point_end[index];
	}
	
	if (isdefined(runPos))
	{
		if (isdefined(point_start.script_noteworthy))
			self ShooterRun(runPos, point_start.script_noteworthy);
		else
			self ShooterRun(runPos);
	}
	
	if ( (isdefined(point_start.script_delete)) && (point_start.script_delete >= 0) )
		self thread drone_delete(point_start.script_delete);
}

drones_clear_variables()
{
	if(isdefined(self.voice))
		self.voice = undefined;
}

drone_delete(delayTime)
{
	if ((isdefined(delayTime)) && (delayTime > 0))
		wait delayTime;
	if (!isdefined(self))
		return;
	self notify ("drone_death");
	self notify ("drone_idle_anim");
	structarray_remove(level.drones[self.team],self);
	if (!isdefined(self.dontDelete))
	{
		if(isdefined(self.turrettarget))
			self.turrettarget delete();
		if(isdefined(self.shootTarget))
			self.shootTarget delete();
		self detachall();
		self delete();
	}
}

#using_animtree("fakeShooters");
ShooterRun(destinationPoint, event)
{
	if(!isdefined(self))
		return;
	self notify ("Stop shooting");
	self UseAnimTree(#animtree);
	
	prof_begin("drone_math");
	
	//calculate the distance to the next run point and figure out how long it should take
	//to get there based on distance and run speed
	d = distance(self.origin, destinationPoint);
	
	if (!isdefined(level.droneRunRate))
		level.droneRunRate = 200;
	speed = (d/level.droneRunRate);
	
	//set his trace height back to normal
	self.lowheight = false;
	//orient the drone to his run point
	self turnToFacePoint( destinationPoint, speed );
	
	//if I want the guy to do a jump first do that here before continuing the run
	customFirstAnim = undefined;
	if ( (isdefined(event)) && (event == "jump") )
		customFirstAnim = %jump_across_100;
	if ( (isdefined(event)) && (event == "jumpdown") )
		customFirstAnim = %jump_down_56;
	if ( (isdefined(event)) && (event == "dismount") )
		customFirstAnim = %duhoc_climber_dismount;
	//check to see if he's in a low height area
	if ( (isdefined(event)) && (event == "low_height") )
		self.lowheight = true;
	if ( (isdefined(event)) && (event == "mortardeath_up") )
	{
		self thread drone_mortarDeath("up");
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_forward") )
	{
		self thread drone_mortarDeath("forward");
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_back") )
	{
		self thread drone_mortarDeath("back");
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_left") )
	{
		self thread drone_mortarDeath("left");
		return;
	}
	if ( (isdefined(event)) && (event == "mortardeath_right") )
	{
		self thread drone_mortarDeath("right");
		return;
	}
	if ( (isdefined(event)) && (event == "shoot") )
	{
		forwardVec = anglestoforward(self.angles);
		rightVec = anglestoright(self.angles);
		upVec = anglestoup(self.angles);
		relativeOffset = (300,0,0);
		shootPos = self.origin;
		shootPos += vectorMultiply(forwardVec, relativeOffset[0]);
		shootPos += vectorMultiply(rightVec, relativeOffset[1]);
		shootPos += vectorMultiply(upVec, relativeOffset[2]);
		self.shootTarget = spawn("script_origin",shootPos);
		
		self thread ShooterShoot(self.shootTarget);
		return;
	}
	
	minRate = 0.5;
	maxRate = 1.5;
	randomAnimRate = minRate + randomfloat( maxRate - minRate);
	if (isdefined(customFirstAnim))
	{
		self.customFirstAnim = true;
		self.running = undefined;
		randomAnimRate = undefined;
		
		//figure out the offset of the animation so the dummy can be moved to the correct spot
		angles = VectorToAngles( destinationPoint - self.origin );
		offset = getcycleoriginoffset( angles, customFirstAnim );
		endPos = self.origin + offset;
		endPos = physicstrace( (endPos + (0,0,64)), (endPos - (0,0,level.traceHeight)) );
		
		t = getanimlength(customFirstAnim);
		assert(t > 0);
		
		//guy does custom anim
		self clearanim( %drone_run_forward_1, 0 );
		self notify ("stop_run_anim");
		
		self moveto (endPos, t, 0, 0);
		
		//self animscripted( "drone_custom_anim", self.origin, self.angles, customFirstAnim );
		self setflaggedanimknobrestart( "drone_custom_anim" , customFirstAnim );
		self waittillmatch("drone_custom_anim","end");
		
		self.origin = endPos;
		self notify ("customFirstAnim done");
		
		//recalculate the distance to the next point since it changed now
		d = distance(self.origin, destinationPoint);
		speed = (d/level.droneRunRate);
		
		if ( ( (isdefined(event)) && (event == "jumpdown") ) && (level.script == "duhoc_assault") )
		{
			structarray_remove(level.drones[self.team],self);
			if(isdefined(self.turrettarget))
				self.turrettarget delete();
			if(isdefined(self.shootTarget))
				self.shootTarget delete();
			self detachall();
			self delete();
			return;
		}
	}
	
	self.customFirstAnim = undefined;
	
	//drone loops run animation until he gets to his next point
	self thread ShooterRun_doRunAnim(randomAnimRate);
	
	//actually move the dummies now)
	self drone_runto(destinationPoint, speed);
	
	prof_end("drone_math");
}

drone_runto(destinationPoint, totalMoveTime)
{
	assert(totalMoveTime > 0);
	if (totalMoveTime < 0.1)
		return;
	//Make several moves to get there, each point tracing to the ground
	//X = (x2-x1) * p + x1
	
	percentIncrement = 0.1;
	percentage = 0.0;
	incements = (1 / percentIncrement);
	dividedMoveTime = (totalMoveTime * percentIncrement);
	startingPos = self.origin;
	oldZ = startingPos[2];
	for (i=0;i<incements;i++)
	{
		prof_begin("drone_math");
			percentage += percentIncrement;
			x = (destinationPoint[0] - startingPos[0]) * percentage + startingPos[0];
			y = (destinationPoint[1] - startingPos[1]) * percentage + startingPos[1];
			if(self.lowheight == true)
				percentageMark = physicstrace((x,y,destinationPoint[2] + 64), (x,y,destinationPoint[2] - level.traceHeight));		
			else
				percentageMark = physicstrace((x,y,destinationPoint[2] + level.traceHeight), (x,y,destinationPoint[2] - level.traceHeight));
				
			//if drone was told to go up more than level.droneStepHeight(100) units, keep old height
			if ((percentageMark[2] - oldZ) > level.droneStepHeight )
				percentageMark = (percentageMark[0], percentageMark[1], oldZ);
			
			oldZ = percentageMark[2];
		prof_end("drone_math");
		
		//thread drone_debugLine(self.origin, percentageMark, (1,1,1), dividedMoveTime);
		
		self moveTo (percentageMark, dividedMoveTime, 0, 0);
		wait (dividedMoveTime);
	}
}

CreateShooter( spawnFunction , spawnOrigin )
{
	if (!isdefined(spawnOrigin))
		spawnOrigin = (0,0,0);
	guy = spawn("script_model", spawnOrigin );
	guy [[spawnFunction]]();
	
	guy InitShooter();
	
	return guy;
}

InitShooter()
{
	if (!isdefined (self.weaponModel))
	{
		self.weapon = "m1garand";
		weaponModel = getWeaponModel(self.weapon);
		self attach(weaponModel, "tag_weapon_right");
    }
	self.bulletsInClip = self animscripts\weaponList::ClipSize();
}

ShooterShoot( target )
{
    self thread ShooterShootThread(target);
}

#using_animtree("fakeShooters");
ShooterShootThread(target)
{
    self notify ("Stop shooting");
    self notify ("drone_shooting");
    self endon ("Stop shooting");
    self UseAnimTree(#animtree);
	self.running = undefined;
    self thread aimAtTargetThread ( target, "Stop shooting" );

    shootAnimLength = 0;
    while(isdefined(self))
    {
        if (self.bulletsInClip <= 0)    // Reload
        {
        	weaponModel = getWeaponModel(self.weapon);
        	if (isdefined(self.weaponModel))
        		weaponModel = self.weaponModel;
        	
        	//see if this model is actually attached to this character
        	numAttached = self getattachsize();
        	attachName = [];
        	for (i=0;i<numAttached;i++)
        		attachName[i] = self getattachmodelname(i);
        	
            self detach(weaponModel, "tag_weapon_right");
            self attach(weaponModel, "tag_weapon_left");
            self setflaggedanimknoballrestart ( "shootinganim", %reload_stand_rifle, %root, 1, 0.4 );
            self.bulletsInClip = self animscripts\weaponList::ClipSize();
            self waittillmatch ("shootinganim", "end");
            self detach(weaponModel, "tag_weapon_left");
            self attach(weaponModel, "tag_weapon_right");
        }

        // Aim for a while
        self Set3FlaggedAnimKnobs("no flag", "aim", "stand", 1, 0.3, 1);
        wait 1 + (randomfloat(2));
		
		if (!isdefined(self))
			return;
		
        // And shoot a few times
        numShots = randomint(4)+1;
        if (numShots > self.bulletsInClip)
        {
            numShots = self.bulletsInClip;
        }
        for (i=0; i<numShots; i++)
        {
        	if (!isdefined(self))
				return;
            self Set3FlaggedAnimKnobsRestart("shootinganim", "shoot", "stand", 1, 0.05, 1);
			
			playfxontag(level.drone_muzzleflash, self, "tag_flash");
			if (self.team == "axis")
				self playsound ("weap_kar98k_fire");
			else
			{
				switch(level.campaign)
				{
					case "american":
            			self playsound ("weap_m1garand_fire");
            			break;
            		case "russian":
            			self playsound ("weap_nagant_fire");
            			break;
            		case "british":
            			self playsound ("weap_enfield_fire");
            			break;
            	}
            }
            
            self.bulletsInClip--;

            // Remember how long the shoot anim is so we can cut it short in the future.
            if (shootAnimLength==0)
            {
                shootAnimLength = gettime();
                self waittillmatch ("shootinganim", "end");
                shootAnimLength = ( gettime() - shootAnimLength ) / 1000;
            }
            else
            {
                wait ( shootAnimLength - 0.1 + randomfloat(0.3) );
                if (!isdefined(self))
                	return;
            }
        }
    }
}

ShooterRun_doRunAnim(animRateMod)
{
	if ( (isdefined(self.running)) && (self.running == true) )
		return;
	self.running = true;
	if (!isdefined(animRateMod))
		animRateMod = 1.0;
	self endon ("stop_run_anim");
	adjustAnimRate = true;
	while( (isdefined(self.running)) && (self.running == true) )
	{
		animRate = (level.droneRunRate/200);
		
		if (adjustAnimRate)
		{
			animRate = (animRate * animRateMod);
			adjustAnimRate = false;
		}
		
		self setflaggedanimknobrestart( "drone_run_anim" , %drone_run_forward_1, 1, .1, animRate );
		self waittillmatch("drone_run_anim","end");
		self clearanim( %drone_run_forward_1, 0 );
		if (!isdefined(self))
			return;
	}
}

debugDummyLines(dummy, dummy_trace)
{
	dummy endon ("stop_debug_line");
	dummy_trace endon ("stop_debug_line");
	for (;;)
	{
		line( level.player.origin + (0,0,20), dummy.origin, (1,1,1) );
		line( level.player.origin + (0,0,20), dummy_trace.origin, (1,0,0) );
		wait 0.05;
	}
}

drone_debugLine(fromPoint, toPoint, color, durationFrames)
{
    for (i=0;i<durationFrames*20;i++)
    {
        line (fromPoint, toPoint, color);
        wait (0.05);
    }
}

turnToFacePoint(point, speed)
{
    // TODO Make this turn gradually, not instantly.
	desiredAngles = VectorToAngles( point - self.origin );
	
	if (!isdefined(speed))
		speed = 0.5;
	else if (speed > 0.5)
		speed = 0.5;
	
	if (speed < 0.1)
		return;
	
	self rotateTo((0,desiredAngles[1],0), speed, 0, 0);
}

anglesToPoint(point)
{
	desiredAngles = VectorToAngles( point - self.origin );
    return (0,desiredAngles[1],0);
}

//---------------------------------------------------------------------------------------------------------------

Set3FlaggedAnimKnobs(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnob(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnob(animFlag,    level.drone_animArray[animArray][pose]["up"],        1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnob(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
}

Set3FlaggedAnimKnobsRestart(animFlag, animArray, pose, weight, blendTime, rate)
{
	if (!isdefined(self))
		return;
    self setAnimKnobRestart(%combat_directions, weight, blendTime, rate);
    self SetFlaggedAnimKnobRestart(animFlag,    level.drone_animArray[animArray][pose]["up"],        1, blendTime, 1);
    self SetAnimKnobRestart(                    level.drone_animArray[animArray][pose]["straight"],    1, blendTime, 1);
    self SetAnimKnobRestart(                    level.drone_animArray[animArray][pose]["down"],        1, blendTime, 1);
}

applyBlend (offset)
{
    if (offset < 0)
    {
        unstraightAnim = %combat_down;
        self setanim( %combat_up,        0.01,    0, 1);
        offset *= -1;
    }
    else
    {
        unstraightAnim = %combat_up;
        self setanim( %combat_down,        0.01,    0, 1);
    }
    if (offset > 1)
        offset = 1;
    unstraight = offset;
    if (unstraight >= 1.0)
        unstraight = 0.99;
    if (unstraight <= 0)
        unstraight = 0.01;
    straight = 1 - unstraight;
    self setanim( unstraightAnim,         unstraight,    0, 1);
    self setanim( %combat_straight,        straight,    0, 1);
}    

aimAtTargetThread( target, stopString )
{
    self endon (stopString);
    while(isdefined(self))
    {
        targetPos = target.origin;
        turnToFacePoint(targetPos);
        offset = getTargetUpDownOffset(targetPos);
        applyBlend(offset);
        wait (0.05);
    }
}

getTargetUpDownOffset(target)
{
    pos = self.origin;// getEye();
    dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
    dir = VectorNormalize( dir );
    fact = dir[2] * -1;
    return fact;
}

setAnimArray()
{
    level.drone_animArray["aim"]    ["stand"] ["down"]			= %stand_aim_down;
    level.drone_animArray["aim"]    ["stand"] ["straight"]		= %stand_aim_straight;
    level.drone_animArray["aim"]    ["stand"] ["up"]			= %stand_aim_up;

    level.drone_animArray["aim"]    ["crouch"]["down"]			= %crouch_aim_down;
    level.drone_animArray["aim"]    ["crouch"]["straight"]		= %crouch_aim_straight;
    level.drone_animArray["aim"]    ["crouch"]["up"]			= %crouch_aim_up;

    level.drone_animArray["auto"]    ["stand"] ["down"]			= %stand_shoot_auto_down;
    level.drone_animArray["auto"]    ["stand"] ["straight"]		= %stand_shoot_auto_straight;
    level.drone_animArray["auto"]    ["stand"] ["up"]			= %stand_shoot_auto_up;

    level.drone_animArray["auto"]    ["crouch"]["down"]			= %crouch_shoot_auto_down;
    level.drone_animArray["auto"]    ["crouch"]["straight"]		= %crouch_shoot_auto_straight;
    level.drone_animArray["auto"]    ["crouch"]["up"]			= %crouch_shoot_auto_up;

    level.drone_animArray["shoot"]    ["stand"] ["down"]		= %stand_shoot_down;
    level.drone_animArray["shoot"]    ["stand"] ["straight"]	= %stand_shoot_straight;
    level.drone_animArray["shoot"]    ["stand"] ["up"]			= %stand_shoot_up;

    level.drone_animArray["shoot"]    ["crouch"]["down"]		= %crouch_shoot_down;
    level.drone_animArray["shoot"]    ["crouch"]["straight"]	= %crouch_shoot_straight;
    level.drone_animArray["shoot"]    ["crouch"]["up"]			= %crouch_shoot_up;
}

#include maps\_utility;

main ()
{
//	paintbrush();
	if(getcvar("scr_88ridge_fast") == "")
		setcvar("scr_88ridge_fast","0");
	if(getcvar("scr_88ridge_fxlevel") == "")
		setcvar("scr_88ridge_fxlevel","2");
	aitype\axis_afrikakorp_reg_mp40::precache();
	level.drone_spawnFunction["axis"] =  aitype\axis_afrikakorp_reg_mp40::main;
	level.drone_spawnFunction["allies"] =  aitype\axis_afrikakorp_reg_mp40::main;
	maps\_drones::init();
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_crusader::main("xmodel/vehicle_crusader2_viewmodel");
	maps\_crusader_player::main("xmodel/vehicle_crusader2");
	maps\_crusader_player::main("xmodel/vehicle_crusader2_viewmodel");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\libya_fx::main();


	thread skill_sethealth();

	tankshareprecache();
	thread delayed_aiaction();

	maps\_load::main();
	gobblethebits();
	setExpFog(.0000144, 100/255, 70/255, 50/255, 0);

//	dothestuff();
	
	thread maps\_mortar::script_mortargroup_style();
	thread playervehicleturretmghack();
	thread ignoreplayerforabit();
	thread maps\libya_amb::main();
	tankshare();
	thread objectives();
	thread allenemiesdead(); // objectives
	thread save_squadbreakup();
	thread minspec_killaianddrones();
	level.flag["stick_close_dialog"] = true;
	thread hintprints(); // introduce player to tank controls
	
	thread music_approach(-36566, "tank_desert_01");
	thread music_approach(-15550, "tank_closeinandduel_01", 9.05);
	
	soundplay("libya_tgc_payattention",undefined,true);
	soundplay("libya_tgc_knowthedrill",undefined,true);
	wait .2;
	soundplay("libya_tgc_fritzoutranges",undefined,true);
	wait .2;
	soundplay("libya_tgc_getclose",undefined,true);
	soundplay("libya_tgc_groupreportin",-35380,true);
	array_thread(getentarray("script_vehicle","classname"), ::alltanks_loseai);

	soundplay("libya_btc_bakeroneready",undefined,true);
	soundplay("libya_easyone_ready",undefined,true);
	soundplay("libya_foxone_ready",undefined,true);
	soundplay("libya_zebra_ready",undefined,true);
	soundplay("libya_tgc_loadaprounds",undefined,true);
	soundplay("libya_tgc_holdfire",-19500,true);
	soundplay("libya_tgc_staytogether",undefined,true);
	wait 2;
	soundplay("libya_btc_theressomany",undefined,true);
	soundplay("libya_tgc_cutchatter",undefined,true); // Cut the chatter Baker One!
	wait 1;
	soundplay("libya_tcd_followleadtank",undefined,true);
	wait 4;
	soundplay("libya_tcd_followtanksir",undefined,true);
	soundplay("libya_zebra_takingfire",undefined,true);
	soundplay("libya_tgc_staytogether",-14000,true);
	soundplay("libya_foxone_almostinrange",-5000,true);
	soundplay("libya_easyone_littlecloser",0,true);
	soundplay("libya_tgc_fireatwill",5000,true);
	level notify ("commence_fire");
	level.flag["stick_close_dialog"] = false;
}

soundplay(sound,xpos,prioritysound)
{
	timer = gettime()+(3000);
	while(level.soundplaying && timer>gettime())
		wait .1;
	if(level.soundplaying && !isdefined(prioritysound))
		return;
	if(isdefined(xpos))
	{
		if(level.script == "libya")
			while(level.player.origin[0] < xpos)
				wait .01;
		if(level.script == "88ridge")
			while(level.player.origin[0] > xpos)
				wait .01;
	}
	if(isdefined(prioritysound) && level.soundplaying)
		level.soundplayer waittill ("soundfinished");
	if(level.soundplaying && !isdefined(prioritysound))
		return;
//	if(isdefined(level.tmpmsg[sound]))
//		iprintln("^3"+level.tmpmsg[sound]);
	level.soundplaying = true;
	level.soundplayer playsoundasmaster(sound,"sounddone");
	level.soundplayer waittill ("sounddone");
	level.soundplaying = false;
	level.soundplayer notify ("soundfinished");
}

hitbyplayervehiclethread()
{
	timer = gettime()+1500;
	while(timer>gettime())
	{
		level.hitbyplayervehicle = true;
		wait .05;
	}
	level.hitbyplayervehicle = false;
}

tankshareprecache()
{
	flag_init("initial_hints_finished");
	precacheitem("kar98k");
	precacheitem("mp40");
	if(getcvar("gobblethebits") == "")
		setcvar("gobblethebits","off");

	array_thread(getspawnerarray(),::tankdrive_mission_spawners);
	array_thread(getaiarray(),::tankdrive_mission_ai);

	level.tanks_killed_forsave = 0;
	level.flameremover = ::flameremover;
	level.customautosavecheck = ::isneartanks;
	level.mortarthread["rideinmortar"] = ::rideinmortar;
	level.enemycountdownthread = ::enemycountdownthread;
	level.hitbyplayervehicle = false;
	level.soundplaying = false;
	level.hitbyplayervehiclethread = ::hitbyplayervehiclethread;
	level.enemytanks = [];
	level.friendlytanks = [];
	level.superdust = loadfx("fx/dust/tread_dust_libya_linger.efx");
	level.tread_override_thread = ::tread;	
	setsavedcvar("cg_hudCompassMaxRange", "7000");
	level.compassradius = int(getcvar("cg_hudCompassMaxRange"));
	level._effects["tankgroundblast"] = loadfx("fx/dust/tread_dust_brown.efx");
}

tankshare()
{
	level.soundplayer = spawn("script_origin",level.player.origin);
	level.soundplayer linkto(level.player);
	gettanks = getentarray("groundfxapply","targetname");
	array_levelthread(gettanks,::applygroundfx);  //ghetto rigging of dustkickup fix me fixme should be moved to global scripts when trace to ground picks up a sand/dust shader whatever.
	array_levelthread(getentarray("predictoron","script_noteworthy"),::predictoron);  
	array_levelthread(getentarray("predictoroff","script_noteworthy"),::predictoroff);  // for triggers
	array_levelthread(getvehiclenodearray("predictoron","script_noteworthy"),::predictoron);  
	array_levelthread(getvehiclenodearray("predictoroff","script_noteworthy"),::predictoroff); 
	array_levelthread(getentarray("wrongway","targetname"),::wrongway);
	thread player_direction();
	thread staynearfriends();
	thread player_killed_drone("player killed drone");
	thread player_killed_car();
	thread hint_binoculars();
	thread hint_frontarmor();
	thread dialog_all();
	thread apply_player_rumble();
	thread playerturretsetup();
}

playerturretsetup()
{
	newarray = [];
	wait 1;
	for(i=0;i<level.playervehicle.mgturret.size;i++)
	{
		level.playervehicle.mgturret[i].isplayerturret = true;
		if(i == 1)
			level.playervehicle.mgturret[i] delete();
		else
			newarray[newarray.size] = level.playervehicle.mgturret[i];
	}
	level.playervehicle.mgturret = newarray;
	
}

apply_player_rumble()
{
	wait 1;
	level.playervehicle thread player_tank_rumble();
}


player_tank_rumble ()
{
	self.rumble_scale = 0.12;
	self.rumble_duration = 0.3;
	self.rumble_radius = 300;
	self.rumble_basetime = .15;
	self.rumble_randomaditionaltime = .01;
	while (isdefined (self))
	{
		if(self getspeedmph() == 0)
		{
			wait .1;
			continue;
		}

		self playlooprumble("tank_rumble");
		while(self getspeedmph() > 0)
		{
			rumblemod =  self getspeedmph()/30.00;
			scale = self.rumble_scale*rumblemod;
			if(scale <= 0)
			{
				wait .1;
				continue; // wierd xbox math hack? I dun know
			}
			earthquake(scale, self.rumble_duration, self.origin, self.rumble_radius); // scale duration source radius
			wait (self.rumble_basetime + randomfloat(self.rumble_randomaditionaltime));
		}
		self stoprumble("tank_rumble");
	}
}



/*hint_binoculars()
{
	wait 1;
	level.playervehicle waittill ("turret_fire");
	wait .5;
	keyHintPrint(&"PLATFORM_TANK_BINOCULARS",getkeybinding("+binoculars"));
}
*/
bindingGen(binding, key)
{
	bind = spawnstruct();
	bind.name = binding;
	bind.key = key;
	bind.binding = getKeyBinding( binding )[key];
	return bind;
}

hint_binoculars()
{
	wait 1;
	while(level.script == "libya" && !flag("initial_hints_finished"))
		level.playervehicle waittill ("turret_fire");
	if(level.script == "88ridge")
		level.playervehicle waittill ("turret_fire");
		
	wait .5;

	bindings = [];
	
	bindings[bindings.size] = bindingGen("+binoculars", "key1");
	bindings[bindings.size] = bindingGen("+binoculars", "key2");
	bindings[bindings.size] = bindingGen("+breath_binoculars", "key1");
	bindings[bindings.size] = bindingGen("+breath_binoculars", "key2");
	
	bind = undefined;
	for (i=0;i<bindings.size;i++)
	{
		if (bindings[i].binding == &"KEY_UNBOUND")
			continue;
		if (bindings[i].binding == &"")
			continue;
		bind = bindings[i];
		break;
	}
	if (!isdefined(bind))
		return;
		
	iprintlnbold( &"PLATFORM_TANK_BINOCULARS", bind.binding );
//	keyHintPrint(&"PLATFORM_TANK_BINOCULARS",bind.binding);

}


hint_frontarmor()
{
	level waittill ("tank_hit_from_front");
	iprintlnbold(&"88RIDGE_PANZER_TANKS_ARE_HEAVILY");
}

wrongway(trigger)
{
	destorg = getent(trigger.target,"targetname");
	org = destorg.origin;
	destorg delete();
	
	while(1)
	{
		trigger waittill ("trigger");
		triggervec = vectornormalize(org-level.player.origin);
		if(vectordot(triggervec,level.player.movement_direction) > .7 && !level.soundplaying)
			level notify ("boundry");
	}
}

trigger_missedshot()
{
	level.missedtrigger = false;
	trigger = getent("misstrigger","targetname");
	while(1)
	{
		trigger waittill ("damage",ammount,attacker);
		if(attacker == level.playervehicle)
			level.missedtrigger = true;
	}
}

dialog_playerdamaged(dialog,dialog2)
{
	dialogque= array_randomize(dialog);
	dialog2que= array_randomize(dialog2);
	waittill_playervehicle();
	level.playervehicle endon ("death");
	while(1)
	{
		level.playervehicle waittill ("damage");
		if(level.playervehicle.health-level.playervehicle.healthbuffer < 900)
			dialog2que = dialog_play_random(dialog2que,dialog2);
		else
			dialogque = dialog_play_random(dialogque,dialog);
	}
}

dialog_missedshot(dialog)
{
	dialogque=array_randomize(dialog);
	wait 1;
	level waittill ("commence_fire");
	waittill_playervehicle();
	level thread trigger_missedshot();
	while(1)
	{
		level.playervehicle thread remindtoshoot();
		level.playervehicle waittill ("turret_fire");
		level.remindtoshoottime = gettime()+randomintrange(20000,28000);
		timer = gettime()+2500;
		hit = false;
		while(gettime() < timer )
		{
			if(level.missedtrigger)
			{
				wait .1;
				level.missedtrigger = false;
				if(level.hitbyplayervehicle)
				{
					hit = true;
					break;
				}
				else
				{
					hit = false;
					break;
				}
			}
			wait .05;
		}
		if(!hit)
			dialogque = dialog_play_random(dialogque,dialog);
	}	
}

dialog_deadtank(dialog)
{
	dialogque= array_randomize(dialog);
	waittill_playervehicle();
	while(1)
	{
		level waittill ("tankdied",other);
		if(!isdefined(other) ||other != level.playervehicle)
			continue;
		dialogque = dialog_play_random(dialogque,dialog);
	}
}

dialog_enemyspotter(forward,left,right,back)
{
	forwardque = array_randomize(forward);
	leftque = array_randomize(left);
	backque = array_randomize(back);
	rightque = array_randomize(right);
	waittill_playervehicle();
	if(level.script == "libya")
	{
		while(level.playervehicle.origin[0] < 4000)
			wait .1;
	}
	while(1)
	{
		level waittill("targettingplayer",other);
		org1 = level.playervehicle.origin;
		org2 = other.origin;
		angles = flat_angle(level.playervehicle gettagangles("tag_turret"));
		forwardvec = anglestoforward(angles);
		rightvec = anglestoright(angles);
		normalvec = vectorNormalize(org2-org1);
		vectordotup = vectordot(forwardvec,normalvec);
		vectordotright = vectordot(rightvec,normalvec);
		if(vectordotup > .708)
			forwardque = dialog_play_random(forwardque,forward);
		else if(vectordotup < -.708)
			backque = dialog_play_random(backque,back);
		else if(vectordotright > .708)
			rightque = dialog_play_random(rightque,right);
		else if(vectordotright < -.708)
			leftque = dialog_play_random(leftque,left);
		thread targettingplayer_timeout();
		other thread targettingplayer_dead();
		
		level waittill_any ("targettingplayer_timeout","targettingplayer_dead");
		wait(1+randomfloat(2));
	}
}

dialog_generic(dialog,msg,floatmin,floatmax,tankcheck,waitmsg)
{
	if(!isdefined(tankcheck))
		tankcheck = false;
	dialogque=array_randomize(dialog);
	if(isdefined(waitmsg))
		level waittill ("waitmsg");
	while(1)
	{
		level waittill (msg);
		if(tankcheck && !level.enemytanks.size)
			continue;
		dialogque = dialog_play_random(dialogque,dialog);
		if(isdefined(floatmax))
			wait randomfloatrange(floatmin,floatmax);
	}	
}

dialog_play_random(dialogque,dialog)
{
	pick = randomint(dialogque.size);
	soundplay(dialogque[pick]);
	dialogque = array_remove(dialogque,dialogque[pick]);
	if(!dialogque.size)
		dialogque = array_randomize(dialog);
	return dialogque;
}

remindtoshoot()
{
	level.remindtoshoottime = gettime()+randomintrange(20000,28000);
	while(1)
	{
		while(gettime() < level.remindtoshoottime)
			wait .1;
		for(i=0;i<level.enemytanks.size;i++)
		{
			if(level.enemytanks[i].enemyque.size && level.enemytanks[i].enemyque[0] == level.playervehicle)
			{
				level notify ("remind_shot");	
				level.remindtoshoottime = gettime()+randomintrange(20000,28000);
				break;
			}
		}
		wait 3;
	}
}

waittill_playervehicle()
{
	while(level.playervehicle.classname != "script_vehicle")
		wait .1;
}

targettingplayer_timeout()
{
	level endon ("targettingplayer_dead");
	level endon ("targettingplayer_timeout");
	wait 8+randomfloat(4);
	level notify ("targettingplayer_timeout");
}

targettingplayer_dead()
{
	level endon("targettingplayer_dead");
	level endon("targettingplayer_timeout");
	self waittill ("death");
	level notify("targettingplayer_dead");
}

vehicle_sightedbyplayer()
{
	self endon ("death");
	waittill_playervehicle();
	while(1)
	{
		org1 = level.playervehicle gettagorigin("tag_barrel");
		org2 = self.origin+(0,0,40);
		dist = distance(org1,org2);
		forwardvec = anglestoforward(level.playervehicle gettagangles("tag_barrel"));
		normalvec = vectorNormalize(org2-org1);
		vectordotforward = vectordot(forwardvec,normalvec);
		if(vectordotforward > .98 && dist < 2500)
			level notify ("on_target");
		wait .3;
	}
}

applygroundfx (info)  //piggy backing lots of stuff here that isn't exactly ground fx related.. bad nate!
{
	vehicle = getent(info.target,"targetname");
	if(!isdefined(vehicle))
		vehicle = maps\_vehicle::waittill_vehiclespawn(info.target);
	if(vehicle.script_team == "axis")
	{
		level.enemytanks[level.enemytanks.size] = vehicle;			
		if(isdefined(level.enemycountdownthread))
			vehicle thread [[level.enemycountdownthread]]();	
		vehicle thread vehicle_sightedbyplayer();
		vehicle enableAimAssist();
	}	
	else if(vehicle.script_team == "allies" && (!isdefined(vehicle.spawnflags) || !(vehicle.spawnflags & 1)))
	{
		level.friendlytanks[level.friendlytanks.size] = vehicle;
		vehicle.stop_for_attack_origins = true;
		thread tankdeathcheck (vehicle);
		return;		
	}
	else
		return;
			
	thread tankdeathcheck (vehicle);
	vehicle endon ("death");
	effect = level._effects["tankgroundblast"];
	while(1)
	{
		vehicle waittill("turret_fire");
	      	playfxOnTag ( level._effect["libya_dust_kickup"], vehicle, "tag_turret");
	}
}

tankpositionupdate (position,objectiveindex,bIsleadtank)
{
	self thread tankpositiondeathupdate(position,objectiveindex);
	self endon ("death");
	self endon ("newobjective");
	while(1)
	{
		objective_additionalposition(objectiveindex, position,self.origin);
		wait .05;
	}
}

tankpositiondeathupdate (position,objectiveindex)
{
	self waittill ("death");
	self endon ("newobjective");
	objective_additionalposition(objectiveindex, position,(0,0,0));
}

objectives ()
{
	flag_init("player over ridge");
	level.currentlytargetingplayertanks = [];
	leadtank = getvehiclenode("leadtank","script_noteworthy");
	leadtank waittill ("trigger",other);
//	other.script_avoidvehicles = false;
	level.objective_followtank = 0;
	level.objective_panzers = 1;
	level.objective_regroup = 2;
	
	thread objective_panzers();
	objective_add(level.objective_followtank, "active", &"LIBYA_FOLLOW_TANK_FORMATION", leadtank.origin);
	objective_current (level.objective_followtank);
	other thread tankpositionupdate(0,0,1);
	flag_wait("player over ridge");
	array_thread(getaiarray(),::deleteme);
	thread killdrones();
	level waittill ("commence_fire");
	other notify ("newobjective");
	objective_state (level.objective_followtank, "done");
	objective_add(level.objective_panzers, "active", &"LIBYA_DEFEAT_INCOMING_ENEMY", other.origin);
	
	thread keep_attacking();
	objective_current (level.objective_panzers);
//	other.script_avoidvehicles = true;
	
	while(level.enemytanks.size || !isdefined(level.script_vehiclespawngroup[2]))
		wait .1;
	thread music("victory_seaofsand_01", 7);
	objective_state (level.objective_panzers, "done");
	
	soundplay("libya_tgc_allunitsregroup",undefined,true);
	soundplay("libya_tgc_checkpointsuzy",undefined,true);
	
	if(level.friendlytanks.size > 4)
		soundplay("libya_tgc_rommelwalloping",undefined,true);

	wait 12;
	maps\_endmission::nextmission();
}

allenemiesdead ()
{
	starttrigger = getent("enemiestrigger","targetname");
	starttrigger waittill ("trigger");
	wait 1;
	flag_set("player over ridge"); //update objective
}


libya_saves()
{
	level.tanks_killed_forsave++;
	if(level.playervehicle.health < level.playervehicle.maxhealth || level.tanks_killed_forsave < 3)
		return;
	level.tanks_killed_forsave = 0;
	autosavebyname("tank killed");
	
}

tankdeathcheck (tank)
{
	tank waittill ("death");
	if(level.script == "88ridge")
		tank thread [[level.flameremover]]();
	if(tank.script_team == "axis")
	{
		if(level.script == "libya")
			thread libya_saves();
		level.enemytanks = array_remove(level.enemytanks,tank);
		
	}
	else if(tank.script_team == "allies")
	{
		level.friendlytanks = array_remove(level.friendlytanks,tank);
		return;
	}
//	level endon ("4");
	if(level.script == "libya" && level.enemytanks.size < 9 && !isdefined(level.script_vehiclespawngroup[2]))
		vehicles_spawnandgo(2);
	if(!level.enemytanks.size)
		level notify ("enemytanks retreating");
}

tread (tagname, side, relativeOffset)  //special libya desert treads..
{
	self endon ("death");
	puffcount = 0;
	if(!isdefined(level.bigpuffoccurance))
		level.bigpuffoccurance = 12;
	treadfx = maps\_treads::treadget(self, side);
	wait .1;
	self.tuningvalue = 235;
	for (;;)
	{
		speed = self getspeed();
		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		puffcount++;
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue);
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.3)
			waitTime = 0.3;
		wait waitTime;
		lastfx = treadfx;
		treadfx = maps\_treads::treadget(self, side);
		if(treadfx != lastfx)
			self notify ("treadtypechanged");
		if(treadfx != -1)
		{
			ang = self getTagAngles(tagname);
			forwardVec = anglestoforward(ang);
			rightVec = anglestoright(ang);
			upVec = anglestoup(ang);
			effectOrigin = self getTagOrigin(tagname);
			effectOrigin += vectorMultiply(forwardVec, relativeOffset[0]);
			effectOrigin += vectorMultiply(rightVec, relativeOffset[1]);
			effectOrigin += vectorMultiply(upVec, relativeOffset[2]);
			forwardVec = vectorMultiply(forwardVec, waitTime);
			/*if(puffcount == level.bigpuffoccurance)
			{
				playfx (level.superdust, effectOrigin, (0,0,0) - forwardVec);
				puffcount = 0;
			}
			else */
			playfx (treadfx, effectOrigin, (0,0,0) - forwardVec);
		}
	}
}

tanknode_killme (node)
{
	node waittill("trigger",other);
	radiusDamage (other.origin, 2, 10000, 9000);
}

tank_lotsofhealth (node)
{
	node waittill("trigger",other);
	other.godmode = true;
}

save_squadbreakup ()
{
	getent ("squadbreakup","targetname") waittill ("trigger");
	autosavebyname("Breaking Formation");
}

getnearest (array,ammount)
{
	newarray = [];
	for(j=0;j<ammount;j++)
	{
		closest = getClosest(level.player.origin, array);
		if(isdefined(closest))
		{
			newarray[newarray.size] = closest;
			array = array_remove(array,closest);
		}

	}
	return newarray;
}

staynearfriends ()
{
	nearfriendsmod = 1.5;
	wait 1;
	switch(getdifficulty())
	{
		case "gimp":
		nearfriendsmod = 1.8;
		break;
		case "easy":
		nearfriendsmod = 1.5;
		break;
		case "medium":
		nearfriendsmod = 1.5;
		break;
		case "hard":
		nearfriendsmod = .7;
		break;
		case "fu":
		nearfriendsmod = .5;
		break;
		default:
		nearfriendsmod = 1.5;
		break;
		
	}

	level endon ("enemies thwarted");
	thread bombslackerplayer();
	thread bombfriendlytanks();
	killafriendtime = 7000;
	killafriendtimer = gettime()+killafriendtime;

			
	while(1)
	{
		averagedist = getaveragefrienddistance();
		wait 2;
		if(averagedist > 8000 && level.enemytanks.size && level.friendlytanks.size < 3)
		{
			level notify ("bomb slacker player");
			level.playervehicle.accuracyoffsetmod = .2;
		}
		else if(averagedist > 4000 && (level.script != "libya" || flag("player over ridge")))
		{
			if(level.script == "88ridge")
				level notify ("bomb random friendly tank");
			level.playervehicle.accuracyoffsetmod = .3;
		}
		else if(averagedist > 2800 )
		{
			level notify ("staynearfriendsremind");
			level.playervehicle.accuracyoffsetmod = .5;
		}
		else if(averagedist < 1800)
			level.playervehicle.accuracyoffsetmod = nearfriendsmod;  // they get less accurate when you're closer to your buddies
		else
			level.playervehicle.accuracyoffsetmod = undefined;
	}
}

getaveragefrienddistance()
{
	closefriendcount = 2;
	totaldist = 0;
	closefriends = getnearest(level.friendlytanks,closefriendcount);
	if(!closefriends.size)
		return 4000;
	for(i=0;i<closefriends.size;i++)
	{
		totaldist+= distance(level.player.origin,closefriends[i].origin);
	}
	averagedist = totaldist/closefriends.size;
	return averagedist;	
}

bombfriendlytanks()
{
	
	level endon ("enemies thwarted");
	while(1)
	{
		thetank = undefined;
		level waittill ("bomb random friendly tank");
		for(i=0;i<level.friendlytanks.size;i++)
		{
			if(isdefined(level.friendlytanks[i].godmode) && level.friendlytanks[i].godmode)
				continue;
			if(distance(level.playervehicle.origin,level.friendlytanks[i].origin) > 4000)
			{
				thetank = level.friendlytanks[i];
				break;
			}
		}
		if(isdefined(thetank))
			radiusDamage (thetank.origin, 16, 2000, 2000);
		wait 4;
	}
	
}

bombslackerplayer()
{
	level endon ("enemies thwarted");
	while(1)
	{
		level waittill ("bomb slacker player");
		radiusDamage (level.playervehicle.origin, 16, 1000, 1000);	
		wait 8;
	}
}

keep_attacking()
{
	level endon ("enemies thwarted");
	while(1)
	{
		{
			tanksarray = [];
			for(i=0;i<level.enemytanks.size;i++)
				if(level.enemytanks[i].enemyque.size && level.enemytanks[i].enemyque[0] != level.playervehicle)
					tanksarray[tanksarray.size] = level.enemytanks[i];
			if(tanksarray.size)
			{
				closertank = getClosest(level.playervehicle.origin, tanksarray);
				closertank maps\_tank::queaddtofront(level.playervehicle);
			}
		}
		wait 3;
	}
}

predictoroff(node)
{
	node waittill ("trigger",other);
	if(other == level.player)
		other = level.playervehicle;
	other notify ("predictor_off");
	other.predictor delete();
	other.predictor = undefined;
}

predictoron(node)
{
	predictor = getent(node.targetname,"target");
	vect = predictor.origin-node.origin;
	node waittill ("trigger",other);
	if(other == level.player)
		other = level.playervehicle;
	other endon ("predictor_off");
	other endon ("death");
	other.predictor  = predictor;
	while(isdefined(other.predictor))
	{
		speed = other getspeedmph();
		if(other getspeedmph() == 0)
			speed = 1;
		other.predictor.origin = other.origin+vectormultiply(vect,speed/25);
		wait .2;
	}
}

enemycountdownthread()
{
	self thread dialog_direction();
	self thread tankobjective();
	self waittill ("death");
	level notify ("enemy down");
	if(!isdefined(level.enemytankcount))
		return;  // for libya which doesn't count the tanks
	level.enemytankcount--;
	if(!level.enemytankcount)
		flag_set("enemies dead");
}

dialog_direction()
{
	self endon ("death");
	while(1)
	{
		if((self.enemyque.size && self.enemyque[0] == level.playervehicle))
			level notify ("targettingplayer",self);
		wait .6;
	}		
}

tankobjective()
{
	level endon ("enemies dead");
	positionindex = undefined;
//	level waittill ("commence_fire");
	self endon ("death");
	origin = self.origin;
	self thread tankobjective_death();
	while(isdefined(self) && self.health > 0) //isdefined added for deleting groups
	{
		if(isdefined(self.positionindex))
		{
//			positionindex = self.positionindex;
			origin = self.origin;
			objective_additionalposition(level.objective_panzers,self.positionindex, self.origin);
		}
//		else
//		{
//			positionindex = undefined;
//		}
		wait .05;
	}
//	wait .5;
//	if(isdefined(positionindex))
//		objective_additionalposition(level.objective_panzers,positionindex, (0,0,0));
}

tankobjective_death()
{
	self waittill ("death");
	if(!isdefined(self) || !isdefined(self.positionindex))
	{
		level notify ("tankobject_cleared");
		return;
	}
	objective_additionalposition(level.objective_panzers,6, self.origin);
	objective_additionalposition(level.objective_panzers,self.positionindex, (0,0,0));
	wait .5;
	objective_additionalposition(level.objective_panzers,6, (0,0,0));
	level notify ("tankobject_cleared");
}

objective_panzers()
{
	thread objective_panzers_manageindex();
}

objective_panzers_manageindex()
{	
	level endon ("enemies dead");
	maxpositions = 4;
	while(1)
	{
		if(level.enemytanks.size)
		{
			for(i=0;i<level.enemytanks.size;i++)
				level.enemytanks[i].positionindex = undefined;
			position = 0;
			nearesttanks = maps\libya::getnearest(level.enemytanks,maxpositions);
			for(i=0;i<maxpositions;i++)
			{
				if(i<nearesttanks.size)
					nearesttanks[i].positionindex = position;
				else
					objective_additionalposition(level.objective_panzers,position, (0,0,0));
				position++;

			}
		}
		thread objective2_manageindex_refresh();
		msg = level waittill_any("tankobject_cleared","refreshobj2index");
	}
}

objective2_manageindex_refresh()
{
	level endon ("tankobject_cleared");
	wait 4;
	level notify ("refreshobj2index");
}

hintprints()
{
	wait 10;
	iprintlnbold(&"LIBYA_PLATFORM_USE_YOUR_MOVEMENT_KEYS");
}

tanks_disable_allturrets()
{
	wait .1;
	for(i=0;i<level.tanks.size;i++)
	{
		if(!isdefined(level.tanks[i].script_nomg))
			level.tanks[i].script_turretmg = false;
	}
}

tanks_enable_allturrets()
{
	wait .1;
	for(i=0;i<level.tanks.size;i++)
	{
		if(!isdefined(level.tanks[i].script_nomg))
			level.tanks[i].script_turretmg = true;
	}
}

playervehicleturretmghack()  // passes triggers script_Turretmg toggle to the players vehicles
{
	thread tanks_disable_allturrets();
	
	while(!isdefined(level.player.script_turretmg))
		wait 1;

	level.playervehicle.script_turretmg = level.player.script_turretmg;
	//crazy here.. player can have like 4 buttons bound to jump I just choose one that is bound priority being on +gostand..
	if(getcvar ("xenonGame") == "true")
	{

		key = getkeybinding("+speed");				
	}
	else
	{

		key = getKeyBinding("+gostand");
	}
	
	if(key["key1"] != &"KEY_UNBOUND")
	{
		keyHintPrint(&"PLATFORM_HOLD_1_TO_TURN_THE_BASE", key);
		wait 7;
	}
	else
	{
		if(getcvar ("xenonGame") == "true")
		{

			key = getkeybinding("+speed");				
		}
		else
		{
			key = getkeybinding("+moveup");	
		}
		
		if(key["key1"] != &"KEY_UNBOUND")
		{
			keyHintPrint(&"PLATFORM_HOLD_1_TO_TURN_THE_BASE", key);
			wait 7;
		}
	}
	wait 8;
	iprintlnbold(&"LIBYA_THE_MACHINE_GUN_ON_YOUR");
	thread tanks_enable_allturrets();
	
	wait 7;
	flag_set("initial_hints_finished");

}

dialog_all()
{

	// when player misses a shot	
	dialog = [];
	dialog[dialog.size] = "libya_tcg_gotdust";
	dialog[dialog.size] = "libya_tcg_youmissed";
	dialog[dialog.size] = "libya_tcg_wemissed";
	dialog[dialog.size] = "libya_tcg_thatsamiss";
	dialog[dialog.size] = "libya_tcg_wemissedthem";
	dialog[dialog.size] = "libya_tcg_wedidnthit";
//	thread dialog_missedshot(dialog);

	//when player takes damage
	dialog = [];
	dialog[dialog.size] = "libya_tcg_hitus";
	dialog[dialog.size] = "libya_tcg_sonofa";
	dialog[dialog.size] = "libya_tcg_wevebeenhit";
	dialog[dialog.size] = "libya_tcd_werehit";
	dialog[dialog.size] = "libya_tcd_owww";
	dialog[dialog.size] = "libya_tcd_wevebeenhit";
	dialog[dialog.size] = "libya_tcd_didntpenetrate";
	dialog[dialog.size] = "libya_tcd_takingdamage";
	dialog[dialog.size] = "libya_foxone_foxthreealright";
	dialog[dialog.size] = "libya_foxone_welshalright";
	dialog[dialog.size] = "libya_foxone_welshokay";
	
	//when player is really hurting
	dialog2 = [];
	dialog2[dialog2.size] = "libya_tcd_takemuchmore";
	dialog2[dialog2.size] = "libya_tcd_takingbeating";
	dialog2[dialog2.size] = "libya_tcd_putoutfire";
	thread dialog_playerdamaged(dialog,dialog2);

	//when the player's turret is on target
	dialog = [];
	dialog[dialog.size] = "libya_tcg_ontarget";
	dialog[dialog.size] = "libya_tcg_wereontarget";
	dialog[dialog.size] = "libya_tcg_wereon";
	dialog[dialog.size] = "libya_tcg_weretarget";
	dialog[dialog.size] = "libya_tcg_tankinrange";
	dialog[dialog.size] = "libya_tcg_insights";
	dialog[dialog.size] = "libya_tcg_panzerinrange";
//	dialog[dialog.size] = "libya_foxone_foxthreewhy";
//	dialog[dialog.size] = "libya_foxone_foxthreeopenfire";
//	dialog[dialog.size] = "libya_foxone_welshmatter";
	dialog[dialog.size] = "libya_tcg_readytofire";
//	dialog[dialog.size] = "libya_foxone_foxthreefire";
	thread dialog_generic(dialog,"on_target",4,6);

	
	//remind the player to shoot
	dialog = [];
	dialog[dialog.size] = "libya_tcg_arentwefiring";
	dialog[dialog.size] = "libya_foxone_foxthreewhy";
	dialog[dialog.size] = "libya_foxone_foxthreeopenfire";
	dialog[dialog.size] = "libya_foxone_welshmatter";
	dialog[dialog.size] = "libya_foxone_foxthreefire";
//	thread dialog_generic(dialog,"remind_shot",undefined,undefined,true);

	//boundry warning dialog
	dialog = [];
	dialog[dialog.size] = "libya_tcd_wrongway";
	dialog[dialog.size] = "libya_tcd_whereyougoing";
	thread dialog_generic(dialog,"boundry",4,4.1);

	//directional enemy spotting dialog
	forward = [];
	forward[forward.size] = "libya_tcg_anotheroneahead";	
	forward[forward.size] = "libya_tcg_panzerdeadahead";	
	forward[forward.size] = "libya_tcg_panzer12oclock";	
	forward[forward.size] = "libya_tcg_panzerinfront";	
	forward[forward.size] = "libya_tcd_enemytankfront";	
	forward[forward.size] = "libya_tcd_panzerfront";	
	forward[forward.size] = "libya_tcd_tankdirectfront";	
	forward[forward.size] = "libya_tcd_anotherdirectfront";	
	forward[forward.size] = "libya_tcd_anotherinfront";	
	forward[forward.size] = "libya_tcd_anotherahead";	
	forward[forward.size] = "libya_tcd_panzerdeadahead";	
	forward[forward.size] = "libya_tcd_panzer12oclock";	
	forward[forward.size] = "libya_tcd_panzerinfront";	

	left = [];
	left[left.size] = "libya_tcg_panzertoleft";	
	left[left.size] = "libya_tcg_panzeronleft";	
	left[left.size] = "libya_tcg_enemytoleft";	
	left[left.size] = "libya_tcg_enemyontheleft";	
	left[left.size] = "libya_tcg_anothertoleft";	
	left[left.size] = "libya_tcg_anotheronleft";	
	left[left.size] = "libya_tcd_panzertoleft";	
	left[left.size] = "libya_tcd_panzeronleft";	
	left[left.size] = "libya_tcd_enemytoleft";	
	left[left.size] = "libya_tcd_enemyonleft";	
	left[left.size] = "libya_tcd_anothertoleft";	
	left[left.size] = "libya_tcd_anotheronleft";	

	right = [];
	right[right.size] = "libya_tcd_panzertoright";	
	right[right.size] = "libya_tcd_panzeronright";	
	right[right.size] = "libya_tcd_enemytoright";	
	right[right.size] = "libya_tcd_enemyonright";	
	right[right.size] = "libya_tcd_anothertoright";	
	right[right.size] = "libya_tcd_anotheronright";	
	right[right.size] = "libya_tcg_panzertoright";	
	right[right.size] = "libya_tcg_panzeronright";	
	right[right.size] = "libya_tcg_enemytoright";	
	right[right.size] = "libya_tcg_enemyonright";	
	right[right.size] = "libya_tcg_anothertoright";	
	right[right.size] = "libya_tcg_anotheronright";

	back = [];
	back[back.size] = "libya_tcg_panzerbehind";	
	back[back.size] = "libya_tcg_panzerbehind";	
	back[back.size] = "libya_tcg_panzerbehind";	
	back[back.size] = "libya_tcg_panzerbehind";	
	back[back.size] = "libya_tcg_panzertorear";	
	back[back.size] = "libya_tcg_panzeronsix";	
	back[back.size] = "libya_tcg_panzeronsix";	
	back[back.size] = "libya_tcg_panzerontail";	
	back[back.size] = "libya_tcg_anotherbehind";	
	back[back.size] = "libya_tcg_anothertorear";	
	back[back.size] = "libya_tcg_enemytorear";	
	back[back.size] = "libya_tcg_enemytosix";
	back[back.size] = "libya_tcg_enemybehindus";
	back[back.size] = "libya_tcd_panzerbehindus";
	back[back.size] = "libya_tcd_panzerrear";
	back[back.size] = "libya_tcd_panzeronsix";
	back[back.size] = "libya_tcd_panzerontail";
	back[back.size] = "libya_tcd_anotherbehindus";
	back[back.size] = "libya_tcd_anothertorear";
	back[back.size] = "libya_tcd_tanktorear";
	back[back.size] = "libya_tcd_enemyonsix";
	back[back.size] = "libya_tcd_enemybehind";
	thread dialog_enemyspotter(forward,left,right,back);

	//player kills a tank
	dialog = [];
	dialog[dialog.size] = "libya_tcg_wegotem";
	dialog[dialog.size] = "libya_tcg_thatsgotem";
	dialog[dialog.size] = "libya_tcg_takethat";
	dialog[dialog.size] = "libya_tcg_gotem";
	dialog[dialog.size] = "libya_tcg_gothim";
	dialog[dialog.size] = "libya_tcg_gotim";
	dialog[dialog.size] = "libya_tcg_gothim2";
	dialog[dialog.size] = "libya_tcg_illseeyou";
	dialog[dialog.size] = "libya_tcg_onedown";
	dialog[dialog.size] = "libya_tcg_goodshooting";
	dialog[dialog.size] = "libya_tcg_gotdust";
	thread dialog_deadtank(dialog);
	
	//when an enemy tank gets hit by an allied tank
	dialog = [];
	dialog[dialog.size] = "libya_foxone_gotonegotone";
	dialog[dialog.size] = "libya_foxone_nailedone";
	dialog[dialog.size] = "libya_foxone_gotone";
	dialog[dialog.size] = "libya_easyone_gothim";
	dialog[dialog.size] = "libya_easyone_thanksmate";
	thread dialog_generic(dialog,"hitbyalliedtank");

	//when a friendly tank gets hit by an enemy tank
	dialog = [];
	dialog[dialog.size] = "libya_btc_imhit";
	dialog[dialog.size] = "libya_easyone_ivebeenhit";
	dialog[dialog.size] = "libya_foxone_werehit";
	if(level.script == "libya") // hack need to make alias available to both levels
		dialog[dialog.size] = "libya_zebra_aaah";
	if(level.script == "88ridge")	
		waitmsg = "commence_fire";
	else
		waitmsg = undefined;
		
	thread dialog_generic(dialog,"hitbyaxistank",undefined,undefined,undefined,waitmsg);
	
		
	
	if(level.script != "libya")
		return;
	
	//tell the player to stay near his friendly tanks
	dialog = [];
	dialog[dialog.size] = "libya_tcd_saferamongother";
	dialog[dialog.size] = "libya_tcd_followthattank";
	dialog[dialog.size] = "libya_tcd_notsafefar";
	dialog[dialog.size] = "libya_tcd_inthedust";
	dialog[dialog.size] = "libya_tcd_stickwithothers";	
	thread dialog_generic(dialog,"staynearfriendsremind",5,8);
}

music_approach(xpos, cuename, fadetime)
{	
	if(!isdefined(fadetime))
		fadetime = 0;
	
	if(isdefined(xpos))
	{
		if(level.script == "libya")
			while(level.player.origin[0] < xpos)
				wait .01;
	}
	
	if(isdefined(cuename))
	{
		thread music(cuename, fadetime);
	}
}

music(cuename, fadetime)
{
	if(!isdefined(fadetime))
		fadetime = 0;
	
	musicstop(fadetime);
	wait (fadetime + .05);
	musicplay(cuename);
}

rideinmortar(mortar)
{
	fPower = 0.45;
	iTime = 1;
	iRadius = 1850;
	earthquake(fPower, iTime, mortar.origin, iRadius);
	playfx(level._effect["rideinmortar"]	, mortar.origin);
	thread playsoundinspace ("mortar_explosion"+(randomint(3)+1), mortar.origin + (0,0,256));
	wait .1;
	mortar notify ("mortar");
	level notify ("mortar");
}

vehicles_spawnandgo (group)
{
	vehicles = maps\_vehicle::scripted_spawn(group);
	array_levelthread(vehicles,maps\_vehicle ::gopath);
}

alltanks_loseai()
{
	self endon ("death");
	self thread maps\_vehicle::setturretfireondrones(false);
	self.script_attackai = false;
	wait 1;
	self.attackingtroops = 0;
	self notify ("turretidle");
}

tankdrive_mission_spawners()
{
	self.script_grenades = 0;
	self waittill ("spawned",other);
	other tankdrive_mission_ai();
}

tankdrive_mission_ai()
{
	self.dropweapon = false;
	while(isalive(self))
	{
		self waittill ("damage",ammount,attacker);
		if(isdefined(attacker) && (attacker == level.playervehicle || isdefined(attacker.isplayerturret)))
			thread [[level.hitbyplayervehiclethread]](); // disables "we missed" dialog;
	}
}

player_killed_drone(msg)
{
	while(1)
	{
		level waittill (msg);
		thread [[level.hitbyplayervehiclethread]]();
	}
}

player_killed_car()
{
	while(1)
	{
		level waittill ("car killed");
		thread [[level.hitbyplayervehiclethread]]();
	}
}

paintbrush()
{
	player = getent("player", "classname" );
	level.player = player;
	thing = spawn("script_model",level.player.origin+(0,0,100));
	thing setmodel("xmodel/vehicle_crusader2_bitgobbler");
//	thing setcandamage(true);
//	thing.health = 10000;
	thing notsolid();	
	array_thread(getaiarray(),::deleteme);
//	array_thread(getentarray("script_vehicle","classname"),::deleteme);
	pressed = false;
	lastorg = level.player.origin;
	while(1)
	{
		if(!level.player usebuttonpressed())
		{
			wait .05;
			pressed = false;
			continue;
		}
		
		org = level.player geteye();	
		origin = bullettrace(org,org+vectormultiply(anglestoforward(level.player getplayerangles()),15000),0,level.playervehicle)["position"];
		if(!pressed)
		{
			thing.origin = origin;
			thread paintbrush_guide(origin);
			pressed = true;
		}
		else
		{
			if(lastorg != origin)
				thing moveto(origin,.1,0,0);
		}
		lastorg = origin;

		wait .1;
	}
}

paintbrush_guide(origin)
{
	self notify ("paintbrush_guide");
	self endon ("paintbrush_guide");
	org1 = (origin[0],origin[1]-60000,origin[2]);
	org2 = (origin[0],origin[1]+60000,origin[2]);
	while(1)
	{
		line (org1,org2, (1,1,1), 1);
		wait .05;
	}
}

deleteme()
{
	self delete();
}

ignoreplayerforabit()
{
	level.player.ignoreme = true;
	wait 10;
	level.player.ignoreme = false;
	
}

delayed_aiaction()
{
	level endon ("gobblethebits");
	dronetriggers = getentarray("drone_axis","targetname");
	array_thread(dronetriggers,::triggeroff);
	spawners = getspawnerarray();
	level waittill ("controls_active");
	
	array_thread(dronetriggers,::triggeron);
	for(i=0;i<spawners.size;i++)
	{
		spawners[i] stalingradspawn();
	} 
}

dothestuff()
{
	wait 1;
	
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
		if(vehicles[i] != level.playervehicle)
			vehicles[i] delete();
	array_thread(getentarray("trigger_multiple","classname"),::deleteme);
	array_thread(getaiarray(),::deleteme);
	array_thread(getspawnerarray(),::deleteme);
	
		level waittill("never");

}

isneartanks()
{
	if(getaveragefrienddistance() > 6000)
		return false;
	return true;
}

widepaint()
{
	while(level.playervehicle.classname != "script_vehicle")
		wait .05;
	level notify("gobblethebits");
	level.playervehicle setmodel("xmodel/vehicle_crusader2_viewmodel_bitgobbler");
	oldvehicle = level.playervehicle;
	level.playervehicle = spawnVehicle( "xmodel/vehicle_crusader2_viewmodel_bitgobbler", "playersride", "crusader_bitgobbler" ,(oldvehicle.origin), (oldvehicle.angles) );

	oldvehicle makevehicleusable();
	oldvehicle useby(level.player);
	oldvehicle delete();
	level.playervehicle.health = 1000000000;
//	level.playervehicle makevehicleusable();
	level.playervehicle useby(level.player);
	wait .1;
//	level.playervehicle makevehicleunusable();
		

	wait 6;
	xpoints = 6;
	ypoints = 6;
	dist = 196;
	pos = level.playervehicle.origin-(xpoints/2*dist,ypoints/2*dist,-512);
	for(x=0;x<xpoints;x++)
	{
		for(y=0;y<ypoints;y++)
		{
			spawn("script_origin",pos) thread widepaint_painter();
			pos+=(0,dist,0);
		}
		pos+=(dist,-1*dist*ypoints,0);
	}
}

widepaint_painter()
{
	self linkto (level.playervehicle,"tag_turret");
	thing = spawn("script_model",self.origin);
	thing setmodel("xmodel/vehicle_crusader2_bitgobbler");
	lastorg = level.player.origin;
	while(1)
	{
		trace = bullettrace(self.origin,self.origin+(0,0,-1000),15000,0,level.playervehicle);
		origin = trace["position"];
		angles = trace["normal"];
//		assert(isdefined(angles));
		if(lastorg != origin)
			thing moveto(origin,.1,0,0);
		thing.angles = angles;
		lastorg = origin;
		wait .1;
	}
}

flameremover()
{
	if(!level.flamecount)
		return;
	for(i=0;i<level.flamecount;i++)
		level waittill ("tankdied");
	self notify ("fire extinguish");
}

killdrones()
{
	drones = [];
	for(i=0;i<level.drones["axis"].lastindex;i++)
	{
		drones[drones.size] = level.drones["axis"].array[i];
	}
	for(i=0;i<drones.size;i++)
	{
		drones[i] notify ("damage",100,level.player,undefined,undefined,"nothing");
		wait .1;
	}
}

minspec_killaianddrones()
{
	if(getcvarint("scr_88ridge_fast") > 0)
	{
		thread minspec_kill_half_drones();
		while(!getaiarray().size)
			wait .1;
		wait 1;
		ai =getaiarray();
		halfai = int(ai.size/2);
		for(i=0;i<halfai;i++)
			ai[i] thread deleteme();
	}
}

minspec_kill_half_drones()
{
	
	triggers = getentarray("drone_axis","targetname");
	for(i=0;i<triggers.size;i++)
	{
		halfammount = int(level.struct_targetname[triggers[i].target].size/2);
		triggers[i].script_drones_max = halfammount;
		triggers[i].script_drones_min = halfammount;
	}
}

skill_sethealth()
{
	switch(getdifficulty())
	{
		case "gimp":
		oneshotfraction = .75;
		break;
		case "easy":
		oneshotfraction = .75;
		break;
		case "medium":
		oneshotfraction = .5;
		break;
		case "hard":
		oneshotfraction = 0;
		break;
		case "fu":
		oneshotfraction = 0;
		break;
		default:
		oneshotfraction = 0;
		break;
		
	}
	enemytanks = [];
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
		if(vehicles[i].vehicletype == "panzer2")
			enemytanks[enemytanks.size] = vehicles[i];
	vehicles = array_randomize(enemytanks);
	fractionvehicles = int(vehicles.size*oneshotfraction);
	for(i=0;i<fractionvehicles;i++)
		vehicles[i].script_startinghealth = 800;	
}

player_direction()
{
	level.player endon ("death");
	lastorg = level.player.origin;
	while(1)
	{
		level.player.movement_direction = vectorNormalize(level.playervehicle.origin-lastorg);
		lastorg = level.playervehicle.origin;
		wait .05;
	}
}

gobblethebits()
{
	/#
	if(getcvar("gobblethebits") != "off")
	{
		precachemodel("xmodel/vehicle_crusader2_bitgobbler");
		precachemodel("xmodel/vehicle_crusader2_viewmodel_bitgobbler");
		precachevehicle("crusader_bitgobbler");
		thread maps\libya::paintbrush();
		thread widepaint();
		maps\libya::dothestuff();
	}
	#/
}

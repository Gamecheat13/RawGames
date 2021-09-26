#include maps\_utility;

// script_vehicleattackgroup 7 attacking all

main()
{

	if (getcvar("showtheway") == "")
		setcvar("showtheway", "off");
	level.enemyflakcount = 0;
	level.enemytankcount = 0;	
	level.tankposition = 0;
	level.flakposition = 0;
	level.objective_gettoridge = 0;
	level.objective_flak = 1;
	level.objective_panzers = 2;
	level.flag["chaosdialog_finished"] = false;
	level.safetynodes = getnodearray("safetynode","targetname");
	flaks = [];
	level.attack_origin_condition_threadd["supply_dump"] = ::supply_dump_isalive;
	
	if(getcvar("scr_88ridge_fast") == "")
		setcvar("scr_88ridge_fast","0");
	if(getcvar("scr_88ridge_fxlevel") == "")
		setcvar("scr_88ridge_fxlevel","2");
	
	switch(getcvarint("scr_88ridge_fxlevel"))
	{
		case 0:
		level.flamecount = 2; break;
		case 1:
		level.flamecount = 4; break;
		case 2:
		level.flamecount = 0; break;
		default:
		level.flamecount = 0; break;
	}
	array_thread(getentarray("flakassist","targetname"),::flakassist);
	array_thread(getentarray("getawaygate","targetname"),::getawaygate);	
	if(getcvarint("scr_88ridge_fast") > 0)
	{
		level.flakaicountmod = -1;
	}
	level.starttrigger = getent("the_start_trigger","script_noteworthy");
	level.starttrigger triggeroff();
	mggiver = 0;
	flaks = getentarray("flak88s","script_noteworthy");
	array_thread(flaks, ::flakcountdown);
	array_thread(getentarray("disable","script_noteworthy"), ::deleteme);
	level.enemytankcount = getentarray("enemytank","script_noteworthy").size;

	vehicles=getentarray("crusaders","script_noteworthy");
	for(i=0;i<vehicles.size;i++)
	{
		if (vehicles[i].vehicletype == "crusader" || vehicles[i].vehicletype == "crusader_player" )
		{
			vehicles[i] thread hold_fire();
			if (isdefined(vehicles[i].spawnflags) && vehicles[i].spawnflags & 1 )
				continue;
			vehicles[i].script_noteworthy = "onemg";
			if(getcvarint("scr_88ridge_fast") > 0 && mggiver)
			{
				vehicles[i].script_nomg = true;
				mggiver = false;
			}
			else
				mggiver = true;
		}
	}	
	
	level.flaks = flak_sort(flaks);
	thread objective_flakorder();

	array_levelthread(getentarray("stop flak88","targetname"),::flakersloadup);
	level.custombadplacethread = ::tank_badplace;	

	breakables = array_combine(getentarray("breakable","targetname"),getentarray("explodable_barrel","targetname"));
	
	maps\libya::tankshareprecache();
	level.currentlytargetingplayertanks = [];
	maps\_sherman::main("xmodel/vehicle_american_sherman_desert");
	maps\_jeep::main("xmodel/vehicle_africa_jeep");
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_crusader_player::main("xmodel/vehicle_crusader2");
	maps\_crusader_player::main("xmodel/vehicle_crusader2_viewmodel");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\ridge88_fx::main();

	aitype\axis_afrikakorp_reg_kar98::precache();
	level.drone_spawnFunction["axis"] = aitype\axis_afrikakorp_reg_kar98::main;
	level.drone_spawnFunction["allies"] = aitype\axis_afrikakorp_reg_kar98::main;  // no allies
	maps\_drones::init();
	if(getcvarint("scr_88ridge_fast") > 0)
		thread maps\libya::minspec_kill_half_drones();

	maps\_load::main();
	maps\libya::gobblethebits();

	setExpFog(.0000114, 100/255, 70/255, 50/255, 0);
	level.supplystacks = [];

	array_thread(getentarray("supplystack","targetname"),::supplystack);
//	thread maps\libya_amb::main();
	thread maps\_mortar::script_mortargroup_style();

	maps\libya::tankshare();

	array_levelthread(getentarray("dialog_trench","targetname"),::dialog_trench_trigger); 
	array_levelthread(getentarray("relay","script_noteworthy"),::relay); // for starting all of the flak88's in the level may turn into something else
	array_levelthread(getentarray("cleartrailingai","targetname"),::cleartrailingai); 
	array_levelthread(breakables,::supplydestroy); 

	thread objectives();
	thread dialog_trench();
	thread dialog_intro();
	thread dialog_earlyfire();
	thread dialog_supplybroke();
	thread dialog_chaosdialog();
	
	thread music_main();
	thread music_victory();
	level._flakignoretanks = [];
	for(i=0;i<level.tanks.size;i++)
		if(level.tanks[i].vehicletype == "crusader" || level.tanks[i].vehicletype == "crusader_player")
			level._flakignoretanks[level._flakignoretanks.size] = level.tanks[i];
	wait 1;
//	level.player setplayerangles(level.playervehicle.angles);
}

waittill_playervehicle()
{
	maps\libya::waittill_playervehicle();
}

hold_fire()
{
	self.holdfire = true;
	level waittill ("commence_fire");
	self.holdfire = false;
}

dialog_supplybroke()
{
	dialog = [];
	dialog[dialog.size] = "ridge88_tcg_niceone";
	dialog[dialog.size] = "ridge88_tcg_lovely";
	dialog[dialog.size] = "ridge88_tcg_brilliant";
	dialog[dialog.size] = "ridge88_tcg_excellent";
	dialogque= array_randomize(dialog);
	waittill_playervehicle();
	while(1)
	{
		level waittill ("breakabled");
		pick = randomint(dialogque.size);
		soundplay(dialogque[pick]);
		dialogque = array_remove(dialogque,dialogque[pick]);
		if(!dialogque.size)
			dialogque = array_randomize(dialog);
	}
}

dialog_success ()
{
	level notify ("victory");
	soundplay("ridge88_tgc_havetargets",undefined,true);
	soundplay("ridge88_fox_negativesir",undefined,true);
	soundplay("ridge88_zebra_negativetargets",undefined,true);
	soundplay("ridge88_tgc_excellent",undefined,true);
}

dialog_chaosdialog2(trigger)
{
	trigger waittill ("trigger");
	flag_wait("chaosdialog_finished");
	vehicles_spawnandgo(5);
	soundplay("ridge88_zebra_fireatwill",undefined,true);
	soundplay("ridge88_tgc_justintime",undefined,true);
	soundplay("ridge88_zebra_pleasuresir",undefined,true);
}

dialog_chaosdialog ()
{
	trigger = getent("chaosdialog","targetname");
	trigger2 = getent("chaosdialog2","targetname");
	thread dialog_chaosdialog2(trigger2);
	trigger waittill ("trigger");
	soundplay("ridge88_fox_panzersridge",undefined,true);
	soundplay("ridge88_btc_whatdirection",undefined,true);
	soundplay("ridge88_fox_fromthewest",undefined,true);
	wait 8;
	soundplay("ridge88_tgc_zebraone",undefined,true);
	soundplay("ridge88_tgc_onmyway",undefined,true);
	soundplay("ridge88_tgc_oneholdposition",undefined,true);
	wait 3;
	soundplay("ridge88_tgc_comeback",undefined,true);
	wait 1;
	soundplay("ridge88_tgc_allregroup",undefined,true);
	wait 3;
	soundplay("ridge88_fox_takinglosses",undefined,true);
	soundplay("ridge88_tgc_steadyfoxone",undefined,true);
	flag_set("chaosdialog_finished");
}

dialog_earlyfire()
{
	level endon ("commence_fire");
	dialog = [];
	dialog[dialog.size] = "ridge88_tgc_holdyourfire";
	dialog[dialog.size] = "ridge88_tgc_foxthreehold";
	dialog[dialog.size] = "ridge88_tgc_waittilinrange";
	dialog[dialog.size] = "ridge88_tgc_whatyoudoing";

	dialogque= array_randomize(dialog);
	waittill_playervehicle();
	while(1)
	{
		level.playervehicle waittill ("turret_fire",other);
		pick = randomint(dialogque.size);
		soundplay(dialogque[pick]);
		dialogque = array_remove(dialogque,dialogque[pick]);
		if(!dialogque.size)
			dialogque = array_randomize(dialog);
	}
}

delayed_tankstart ()
{
	wait 7.5;
	level.starttrigger triggeron();	
}

dialog_intro ()
{
	wait .2;
	thread delayed_tankstart();
	soundplay("ridge88_tgc_payattentionnow",undefined,true);
	
	soundplay("ridge88_tgc_reportin",undefined,true);
	soundplay("ridge88_btc_bakeroneready",undefined,true);
	soundplay("ridge88_fox_foxoneready",undefined,true);
	soundplay("ridge88_zebra_givinghell",undefined,true);
	soundplay("ridge88_tgc_loadaprounds",undefined,true);
	wait 4;
	soundplay("ridge88_tgc_staytogether",undefined,true);
	soundplay("ridge88_btc_hopethisworks",undefined,true);
	soundplay("ridge88_tgc_killchatter",undefined,true);
	soundplay("ridge88_tgc_holdyourfire",undefined,true);
	soundplay("ridge88_fox_spottedus",-18000,true);
	soundplay("ridge88_tgc_steady",undefined,true);
//	soundplay("ridge88_btc_imtakingfire",undefined,true);
	soundplay("ridge88_tgc_steadyyy",undefined,true);
	wait 2;
	soundplay("ridge88_tgc_almostinrange",undefined,true);
	wait 2;
	soundplay("ridge88_tgc_nearlythere",undefined,true);
	wait 1;
	soundplay("ridge88_tgc_fireatwill",undefined,true);
	level notify ("commence_fire");
	soundplay("ridge88_tgc_repeatfire",undefined,true);
	
}

soundplay(sound,xpos,prioritysound)
{
	maps\libya::soundplay(sound,xpos,prioritysound);
}


objective_followtanks()
{
	leadtank = getvehiclenode("auto2568","targetname");
	leadtank waittill ("trigger",other);
//	objective_add(level.objective_gettoridge, "active", &"88RIDGE_FOLLOW_TANK_SQUAD_TO", other.origin);
//	objective_additionalposition(level.objective_gettoridge, 0,other.origin);
//	objective_current (level.objective_gettoridge);
	other thread maps\libya::tankpositionupdate(0,level.objective_gettoridge,1);
	
}

objectives ()
{
	precacheshader("objectiveA");
	precacheshader("objectiveB");
	thread objective_followtanks();

	level waittill ("introscreen_complete");
	wait .1;

	objective_add(level.objective_gettoridge, "active", &"88RIDGE_FOLLOW_TANK_SQUAD_TO",(-24464,-20736,-303));
	objective_current(level.objective_gettoridge);

	level waittill ("commence_fire");

	objective_state(level.objective_gettoridge,"done");

//	objective_icon(level.objective_flak,"objectiveA");
	objective_add(level.objective_flak, "active", "");
	objective_string(level.objective_flak,&"88RIDGE_DESTROY_FLAK88_POSITIONS",level.enemyflakcount);
	objective_current(level.objective_flak);

//	objective_icon(level.objective_panzers,"objectiveB");
	objective_add(level.objective_panzers, "active", "");
	objective_string(level.objective_panzers,&"88RIDGE_DESTROY_DEFENDING_PANZER",level.enemytankcount);
	objective_additionalcurrent(level.objective_panzers);
	
	thread objective1();
	thread objective2();
	
	level waittill_multiple ("flaks dead","enemies dead");

	objective_string(level.objective_panzers,&"88RIDGE_DESTROY_DEFENDING_PANZER",0);
	getent("endgate","targetname") notify ("trigger");
	dialog_success();
	
	wait 8;
	maps\_endmission::nextmission();
}

objective1()
{

	level waittill ("flaks dead");
	objective_string(level.objective_flak,&"88RIDGE_DESTROY_FLAK88_POSITIONSDONE");
	objective_state(level.objective_flak,"done");
	if(!level.flag["enemies dead"])
		objective_current(level.objective_panzers);	

}

objective2()
{
	thread objective2_manageindex();
	level.flag["enemies dead"] = false;
	flag_wait("enemies dead");
	objective_string(level.objective_panzers,&"88RIDGE_DESTROY_DEFENDING_PANZERDONE");
	objective_state(level.objective_panzers,"done");
}

objective2_manageindex()
{	
	level endon ("enemies dead");
	maxpositions = 4;
	while(1)
	{
		if(level.enemytanks.size)
		{
			position = 0;
			for(i=0;i<level.enemytanks.size;i++)
			{
				level.enemytanks[i].positionindex = undefined;
				if(level.player.origin[1] - level.enemytanks[i].origin[1] > 8000)
					for(j=0;j<level.friendlytanks.size;j++)
						if(level.friendlytanks[j].vehicletype == "crusader" &&  distance(level.friendlytanks[j].origin,level.player.origin) <5000)
							level.enemytanks[i] notify ("death");  //magically gets blow up...
			}
			nearesttanks = maps\libya::getnearest(level.enemytanks,4);
			for(i=0;i<maxpositions;i++)
			{
				if(nearesttanks.size && i<nearesttanks.size)
					nearesttanks[i].positionindex = position;
				else
					objective_additionalposition(level.objective_panzers,position, (0,0,0));
				position++;
			}
		}
		thread objective2_manageindex_refresh();
		msg = level waittill_any("tankobject_cleared","refreshobj2index");
		wait .5;
		if(msg == "tankobject_cleared")
			objective_string_nomessage(level.objective_panzers,&"88RIDGE_DESTROY_DEFENDING_PANZER",level.enemytankcount);	
	}
}

objective2_manageindex_refresh()
{
	level endon ("tankobject_cleared");
	wait 4;
	level notify ("refreshobj2index");
}



relay(trigger)
{
	targs = getentarray(trigger.target,"targetname");
	trigger waittill ("trigger");
	wait 5;
	for(i=0;i<targs.size;i++)
		targs[i] notify ("trigger");
}




flakcountdown()
{
	level.enemyflakcount++;
	self.position = level.flakposition;
	level.flakposition++;
	if(self.script_flak88 == "4")
		self thread deathonvalleycross();
//	objective_additionalposition(objectiveindex, self.position,self.origin);
	self waittill_any ("death","flakai_cleared");
	level.flaks = array_remove(level.flaks, self);
	objective_additionalposition(level.objective_flak, self.position,(0,0,0));
	level notify ("flakdeath");
	level.enemyflakcount--;
	objective_string_nomessage(level.objective_flak,&"88RIDGE_DESTROY_FLAK88_POSITIONS",level.enemyflakcount);
	if(!level.enemyflakcount)
	{
		level notify ("flaks dead");
	}	
}



tank_badplace()
{
	self endon ("death");
	self endon ("delete");
	bp_duration = .5;
	bp_height = 400;
	for (;;)
	{
		if(!self.script_badplace)
		{
//			badplace_delete("tankbadplace");
			while(!self.script_badplace)
				wait .5;
		}
		speed = self getspeedmph();
		if (speed > 0)
		{
			if (speed < 5)
				bp_radius = 800;
			else if ((speed > 5) && (speed < 8))
				bp_radius = 1400;
			else
				bp_radius = 2500;
			
			bp_direction = anglestoforward(self.angles);
			badplace_cylinder("", bp_duration, self.colidecircle[0].origin, bp_radius,bp_height , "allies","axis");
		}
		wait bp_duration+.05;
	}
}


flak_leasty(flaks)
{
	theone = undefined;
	bigy = 1000000;
	for(i=0;i<flaks.size;i++)
	{
		if(flaks[i].origin[1] < bigy)
		{
			bigy = flaks[i].origin[1];
			theone = flaks[i];
		}
	}
	return theone;	
}

flak_sort(flaks)
{
	sortedflaks = [];
	while(flaks.size)
	{
		nearestflak = flak_leasty(flaks);
		flaks = array_remove(flaks,nearestflak);
		sortedflaks[sortedflaks.size] = nearestflak;
	}
	return sortedflaks;
}

objective_flakorder()
{
	level waittill ("commence_fire");
	while(level.flaks.size)
	{
		if(level.flaks.size > 3)
			for(i=0;i<3;i++)
				level.flaks[i] thread objective_flakposition();
		else
			for(i=0;i<level.flaks.size;i++)
				level.flaks[i] thread objective_flakposition();
				
		level waittill ("flakdeath");
	}
}

objective_flakposition()
{
	position = self.position;
	self endon ("death");
	self endon ("flakdeath");
//	while(1)
//	{
		objective_additionalposition(level.objective_flak, position,self.origin);
		wait .2;
//	}
	while(1)
	{
		if(level.player.origin[1] - self.origin[1] > 10000)
		{
			for(i=0;i<level.friendlytanks.size;i++)
			{
				if(level.friendlytanks[i].vehicletype == "crusader" &&  distance(level.friendlytanks[i].origin,level.player.origin) <3000)
				{
					self notify ("death");  //magically gets blow up...
				}
			}
		}
		wait 2;
	}
	
}

cleartrailingai(trigger)
{
	trigger waittill ("trigger");
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if((ai[i].origin[1] - level.playervehicle.origin[1])< -2000)
			ai[i] delete();
	}
}


supplydestroy (breakable)
{
	breakable waittill ("damage",amount,attacker);
	if(attacker == level.playervehicle)
	{
		level notify ("breakabled");
		thread [[level.hitbyplayervehiclethread]](); // disables "we missed" dialog;		
	}
}

dialog_trench()  // used for slittrench
{
	dialog = [];
	dialog[dialog.size] = "ridge88_tcd_trenchnearby";
	dialog[dialog.size] = "ridge88_tcd_ofthattrench";
	dialog[dialog.size] = "ridge88_tcd_carefultrench";
	dialogque= array_randomize(dialog);
	waittill_playervehicle();
	while(1)
	{
		level.playervehicle waittill ("trench_dialog");
		pick = randomint(dialogque.size);
		soundplay(dialogque[pick]);
		dialogque = array_remove(dialogque,dialogque[pick]);
		if(!dialogque.size)
			dialogque = array_randomize(dialog);
	}
}

dialog_trench_trigger(trigger)
{
	d = false;
	timer = gettime();
	waittime = 5000;
	while(1)
	{
		trigger waittill ("trigger");
		if(!d)
		{
			soundplay(trigger.script_noteworthy);
			d = true;
		}
		if(gettime()>timer)
		{
			aitouching = false;
			ai = getaiarray("axis");
			for(i=0;i<ai.size;i++)
			{
				if(ai[i] istouching (trigger))
				{
					aitouching = true;
					break;
				}
			}
			if(aitouching)
			{
				timer = gettime()+waittime;
				level notify ("trench_dialog");				
			}
		}
	}
}

flakersloadup(trigger)
{
	thetruck = undefined;
	while(1)
	{
		trigger waittill ("trigger",other);
		if(other == level.player || other == level.playervehicle)
			break;
		
	}
	assert(isdefined(trigger.script_flak88));
	ai = getaiarray("axis");
	flakai = [];
	for(i=0;i<ai.size;i++)
		if(isdefined(ai[i].script_flak88) && ai[i].script_flak88 == trigger.script_flak88)
			flakai[flakai.size] = ai[i];
	
	nearestdist = trigger.radius;
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
	{
		if(vehicles[i].vehicletype != "blitz")
			continue;
		dist = distance(flat_origin(vehicles[i].origin),flat_origin(trigger.origin));
		if(dist < nearestdist)
		{
			thetruck = vehicles[i];
			nearestdist = dist;
		}
	}
	if(!isdefined(thetruck))
	{
		array_thread(flakai,::firepanzerandruntosafety);
		return;
	}
	thetruck endon ("death");
	thetruck notify ("load_nearby");
	
}

vehicles_spawnandgo (group)
{
	vehicles = maps\_vehicle::scripted_spawn(group);
	array_levelthread(vehicles,maps\_vehicle ::gopath);
}


firepanzerandruntosafety()
{
	self endon ("death");
	if(!isdefined(self.target))
		return;
	targetnode = getnode(self.target,"targetname");
	level thread maps\_spawner::panzer_target(self, targetnode, undefined, level.playervehicle, (0,0,40) );
	self waittill ("panzer mission complete");
	maps\_spawner::go_to_node(getclosest(self.origin,level.safetynodes));
	
}

flakassist()
{
	targ = getent(self.target,"targetname");
	while(1)
	{
		self waittill ("damage",amount,attacker);
		if(isdefined(attacker) && attacker == level.playervehicle)
		{
			targ notify ("death");
			break;
		}
	}
}

music_main()
{
	//ridge88_main_music
	//ridge88_victory_music
	
	level endon ("victory");
	
	while(1)
	{
		wait 0.1;
		musicplay("ridge88_main_music");
		wait 193; 
	}
}

music_victory()
{
	level waittill ("victory");
	musicstop(2);
	wait 2.1;
	musicplay("ridge88_victory_music");
}

getawaygate()
{
	firstnode = getvehiclenode(self.target,"targetname");
	lastnode = getvehiclenode(firstnode.target,"targetname");
	assert(isdefined(firstnode) && isdefined(lastnode));
	firstnode.script_turret = 0;
	lastnode.script_turret = 1;
	firstnode waittill ("trigger",other);
	thread getawaygate_death(other,lastnode);
	self notsolid();
	lastnode waittill_any("trigger","vehicledied");
	self solid();
}

getawaygate_death(other,lastnode)
{
	lastnode endon ("trigger");
	other waittill ("death");
	lastnode notify ("vehicledied");
}

supplystack()
{

	targ = getent(self.target,"targetname");
	areatrigger = spawn( "trigger_radius", targ.origin+(0,0,-256), 0, 5000, 5000);
	areatrigger thread supplystack_flee();
	level.supplystacks[level.supplystacks.size] = targ;
	self setcandamage(true);
	thread supplystack_autocomplete(targ);
	while(1)
	{
		self waittill ("damage",ammount,attacker);
		if(ammount > 300 && isdefined(attacker) && attacker.classname == "script_vehicle")
			break;
	}
	thread [[level.hitbyplayervehiclethread]](); // disables "we missed" dialog;
	self delete();
	targ notify ("finished");
	assert(isdefined(targ.script_exploder));
	maps\_utility::exploder(targ.script_exploder);
	wait 4;
	level.supplystacks = array_remove(level.supplystacks,targ);
	level notify ("supplystackblown");
}

supplystack_flee()
{
	thetruck = undefined;
	self waittill ("trigger");
	trucks = getentarray("getawaytruck","targetname");
	for(i=0;i<trucks.size;i++)
	{
		if(distance(self.origin,trucks[i].origin) < 1000)
		{
			thetruck = trucks[i];
			break;
		}
	}
	if(!isdefined(thetruck))
		return;
	thetruck notify ("load_nearby");
}

supplystack_autocomplete(targ)
{
	targ endon ("finished");
	while((level.player.origin[1] - self.origin[1]) < 7000)
		wait .5;
	self notify ("damage",500,level.playervehicle);  //magical death
}


supply_dump_isalive()
{
	closest = getclosest(self.origin,level.supplystacks,500);
	if(isdefined(closest))
		return true;
	else
		return false;
}


deleteme()
{
	self delete();
}

deathonvalleycross()
{
	level waittill ("commence_fire");
	self notify ("death");
}
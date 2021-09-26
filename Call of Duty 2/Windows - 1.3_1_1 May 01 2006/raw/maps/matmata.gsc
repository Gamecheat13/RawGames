#include maps\_utility;
#include maps\_anim;

main()
{
	precacheShellshock("default");
	precachevehicle("flakveirling_player");
	level.campaign = "british";
	maps\_tankai::main();
	maps\_tankai_crusader::main("xmodel/vehicle_crusader2");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_desert");
	maps\_jeep::main("xmodel/vehicle_africa_jeep_cot");
	maps\_jeep::main("xmodel/vehicle_africa_jeep_can");
	maps\_jeep::main("xmodel/vehicle_africa_jeep");
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\_stuka::main("xmodel/vehicle_stuka_flying");
	maps\matmata_fx::main(); 
	maps\_load::main();
	level._effect["wallchunk"] = loadfx ("fx/impacts/wall_impact_chimney_dirt.efx");
	level.scr_sound["wallsound"] = "mortar_explosion";
	precacheModel("xmodel/weapon_brit_smoke_grenade");
    precacheModel("xmodel/vehicle_africa_jeep_crash");
	precacheModel("xmodel/us_ranger_radio_hand");
	precacheModel("xmodel/vehicle_africa_jeep_dmg");
    precacheItem("smoke_grenade_british");
	precacheString(&"MATMATA_PLATFORM_USE_FLAKVEIRLING"); 
	precacheString(&"MATMATA_SCOUT_OBJECTIVE"); 
	precacheString(&"MATMATA_CLEAR_OBJECTIVE"); 
	precacheString(&"MATMATA_AAGUN_OBJECTIVE"); 
	precacheString(&"MATMATA_FLAK_OBJECTIVE"); 
	precacheString(&"MATMATA_PLATFORM_APPROACH_AA_GUN");	
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		precacheshader("popmenu_bg");
	
	level thread maps\matmata_amb::main();
	level thread maps\matmata_anim::main(); 
	
	//temp();

	thread levelSetup();
	thread grabVehicles();
	level.dogfighters = []; 
	if(getcvar("start") == "planes")
	{
		level.player setorigin((5408, 3696, 50));
		level thread planeJumpTo(); 
	}
	
	level thread halftrackRetreatSequence();
	level thread halftrackStopByHQ();
	level thread courtyard();
	level thread radioCall();
	level thread runIntoSmoke(); 
	level thread shootHalftrack();
	level thread planeRun();
	level thread checkPlayerPastGate(); 
	level thread grabMacGregor(); 
	level thread grabPrice();
	level thread macgregorUseRadio();
	level thread priceWaitByMacGregor();
	level thread dogFights();
	level thread courtyardFlak();
	level thread throwCoverSmoke();
	level thread tankSequence(); 
	level thread alleyNorthStrafe(); 
	level thread alleySouthStrafe(); 
	level thread tankStrafe(); 
	level thread autosave1(); 
	level thread autosave2(); 
	level thread autosave3(); 
	level thread autosave4(); 
	level thread deletePriceAndMacGregor(); 
	level thread resurrectPriceAndMacGregor();
	level thread getBritThree();
	level thread getBritFour(); 
	level thread getDriver();
	level thread tankArrivedDialogue();
	level thread crashjeep();
	level thread makeQuadUseable();
	level thread fireFakeQuadGun(); 
	level thread fireRealQuadGun(); 
	level thread getOffFlakHint();
//	level thread hackJeepCollision();
	level thread killAmbushDudes();	

	if(getcvar("start") != "tankbomb" && getcvar("start") != "courtyard" && getcvar("start") != "halftrack" && getcvar("start") != "assert" && getcvar("start") != "planenorth" && getcvar("start") != "planesouth" && getcvar("start") != "planetank" && getcvar("start") != "planes")
	{
		
		level thread ridein();
		thread objective_master();
		level thread killdriver();
		level thread frontgate();
		level thread macgregorAtGate(); 
		level thread shakeGateSequence();
		
		level thread crashSoundCue(); 
	}
	
	if(getcvar("start") == "tankbomb")
	{
		level.player setorigin((5464,6098,60)); 
		wait(5); 
		thread killdogfight(); 
		level.bomber = sky_makeplane(getvehiclenode("tankBomber","targetname"));
	
		thread blowTank(); 
		level.bomber thread _planeRunSound();
	}
	
	if(getcvar("start") == "courtyard")
	{
		level.player setorigin(getent("playerAtCourtyard","targetname").origin);
		wait(1);
		level notify("fire_fakeQuad");
	}
	
	if(getcvar("start") == "halftrack")
	{
		level.player setorigin(getent("beforeHalftrack","targetname").origin);		
	}
	
	if(getcvar("start") == "planenorth")
	{
		level.player setorigin(getent("planenorth","targetname").origin);				
		level.player setFriendlyChain(getnode("alleyfriendlychain","targetname"));
		level.britfour = getent("smokeyTheBrit","targetname") dospawn();
	
	}

	if(getcvar("start") == "planesouth")
	{
		level.player setorigin(getent("planesouth","targetname").origin);				
		level.player setFriendlyChain(getnode("alleyfriendlychain","targetname"));
		level.britfour = getent("smokeyTheBrit","targetname") dospawn();
	}

	if(getcvar("start") == "planetank")
	{
		level.player setorigin(getent("planetank","targetname").origin);				
		level.player setFriendlyChain(getnode("alleyfriendlychain","targetname"));
		level.britfour = getent("smokeyTheBrit","targetname") dospawn();
	}

}

crashSoundCue()
{
	wait(18.45-2);
	getent("jeep","targetname") playsound("jeep_crash_truck"); 
//	iprintlnbold("CRASH"); 
	
}

testPlanesGo()
{
//	sky_makeplane(getvehiclenode("firstpath","targetname"));
//	sky_makeplane(getvehiclenode("secondpath","targetname"));
//	sky_makeplane(getvehiclenode("thirdpath","targetname"));
//	firstStrafeRun(); 
		sky_makeplane(getvehiclenode("spit","targetname"));
}

strafeRun(vehicleNode)
{
	//left gun
	plane = sky_makeplane(vehicleNode);

	plane.Mg_left = spawnTurret("misc_turret", (0,0,0), "stuka_guns");
	plane.Mg_left linkto(plane, "tag_gunLeft", (0, 0, -14), (0, 0, 0));
	plane.Mg_left setleftarc(5);
	plane.Mg_left setrightarc(5);
	plane.Mg_left settoparc(5);
	plane.Mg_left setbottomarc(5);
	plane.Mg_left setconvergencetime(0);	
	plane.Mg_left setaispread(0.5);
	plane.Mg_left setturretteam("axis");
	plane.Mg_left setmode("auto_nonai");
	plane.Mg_left setmodel ("xmodel/weapon_mg42");
	plane.Mg_left hide();
	plane.Mg_left settargetentity(level.player); 
	
	//right gun
	plane.Mg_right = spawnTurret("misc_turret", (0,0,0), "stuka_guns");
	plane.Mg_right linkto(plane, "tag_gunRight", (0, 0, -14), (0, 0, 0));
	plane.Mg_right setmodel ("xmodel/weapon_mg42");
	plane.Mg_right hide();
	plane.Mg_right setleftarc(5);
	plane.Mg_right setrightarc(5);
	plane.Mg_right settoparc(5);
	plane.Mg_right setbottomarc(5);
	plane.Mg_right setconvergencetime(0);
	plane.Mg_right setaispread(0.5);
	plane.Mg_right setturretteam("axis");
	plane.Mg_right setmode("auto_nonai");	
	plane.Mg_right settargetentity(level.player);
	
	return plane; 	
}

firstStrafeRun()
{
	plane = strafeRun(getvehiclenode("strafepath1","targetname"));
	plane setWaitNode(getvehiclenode("fireGuns1","script_noteworthy")); 
	
	plane waittill("reached_wait_node"); 
	thread plane_shoot_guns(plane, plane.Mg_left, plane.Mg_right);		
	wait(2); 
	plane notify("plane_stop_shooting"); 
}

plane_shoot_guns(plane, leftgun, rightgun)
{
	plane endon("plane_stop_shooting");
	
	for (;;)
	{
		leftgun ShootTurret();
		rightgun ShootTurret();
		wait 0.1;
	}
}

alleyNorthStrafe()
{
	getent("planeTriggerNorth","targetname") waittill("trigger"); 	
	if(isdefined(level.alleySequence))
		return; 
	level.alleySequence = true; 

	plane = strafeRun(getvehicleNode("northalley","targetname")); 
	plane playsound("matmata_stuka_strafe1"); 
	

	plane setWaitNode(getvehiclenode("fireGunsNorth","script_noteworthy")); 
	if(getcvar("start") != "planenorth")
		level.britfour thread dodialogue("matmata_planewarning");
	plane waittill("reached_wait_node"); 
//	plane playloopsound(level.scrsound["stuka_gun_loop"][0]);

	// HACK - since the gun loop doesn't seem to want to play nice with the airplane. 
	org = spawn ("script_origin",plane.origin);
	org linkto(plane); 
	org playloopsound (level.scrsound["stuka_gun_loop"][0]);
	
	thread plane_shoot_guns(plane, plane.Mg_left, plane.Mg_right);		
	wait(2.2);
	earthquake(0.5, 1.0, plane.origin, 5000); // scale duration source radius
	wait(1); 
	plane notify("plane_stop_shooting"); 
	org stoploopsound();
}


alleySouthStrafe()
{
	getent("planeTriggerSouth","targetname") waittill("trigger"); 	
	if(isdefined(level.alleySequence))
		return; 

	level.alleySequence = true; 

	plane = strafeRun(getvehicleNode("southalley","targetname")); 
	plane playsound("matmata_stuka_strafe2");

	plane setWaitNode(getvehiclenode("fireGunsSouth","script_noteworthy")); 
	if(getcvar("start") != "planesouth")
		level.britfour thread dodialogue("matmata_planewarning");


	plane waittill("reached_wait_node"); 
	org = spawn ("script_origin",plane.origin);
	org linkto(plane); 
	org playloopsound (level.scrsound["stuka_gun_loop"][0]);

	thread plane_shoot_guns(plane, plane.Mg_left, plane.Mg_right);		
	wait(2.2);
	earthquake(0.5, 1.0, plane.origin, 5000); // scale duration source radius
	wait(1); 
	plane notify("plane_stop_shooting"); 
	org stoploopsound();
}

tankStrafe()
{
	getent("tankStrafeTrigger","targetname") waittill("trigger"); 
	plane = strafeRun(getvehicleNode("tankStrafe","targetname")); 
	plane playsound("matmata_stuka_strafe3");

	plane setWaitNode(getvehiclenode("fireGunsTank","script_noteworthy")); 
	if(getcvar("start") != "planetank")
		level.britfour thread dodialogue("matmata_planewarning");
	
	plane waittill("reached_wait_node"); 

	org = spawn ("script_origin",plane.origin);
	org linkto(plane); 
	org playloopsound (level.scrsound["stuka_gun_loop"][0]);

	thread plane_shoot_guns(plane, plane.Mg_left, plane.Mg_right);		
	wait(2.2);
	earthquake(0.5, 1.0, plane.origin, 5000); // scale duration source radius
	wait(1); 
	plane notify("plane_stop_shooting"); 
	org stoploopsound();
}

rideAnimation()
{
	jeep = getent ("jeep","targetname");
	level.macgregor linkto(jeep,"tag_guy0");
	level.gateshaker linkto(jeep,"tag_guy1"); 
	level.macgregor thread anim_loop_solo(level.macgregor,"idle","tag_guy0","stop_idle",undefined,jeep);
	level.gateshaker thread anim_loop_solo(level.gateshaker,"idle","tag_guy1","stop_idle",undefined,jeep);


	wait(1.05);
	if(isdefined(level.macgregor))
		level.macgregor thread doDialogue("matmata_mcg_thereyet"); // matmata_mcg_thereyet
	wait(1.8);
	if(isdefined(level.gateshaker))
		level.gateshaker thread doDialogue("matmata_bs4_stopasking"); // matmata_bs4_stopasking

	
//	anim_loop_solo(jeep,"idle",undefined,"stop_driving",undefined,jeep);
	
	wait(8);
	
	level.driver.animname = "driver"; 
	
	if(isdefined(level.driver) && isalive(level.driver))
		thread anim_single_solo(level.driver,"badfeeling","tag_driver",undefined,jeep);
	level.driver waittillmatch("single anim","startnext"); 

	level.gateshaker notify("stop_idle");
	if(isdefined(level.gateshaker) && isalive(level.driver))
		thread anim_single_solo(level.gateshaker,"dialog","tag_guy1",undefined,jeep);
//	level.driver thread doDialogue("matmata_bs2_badfeeling"); // matmata_bs2_badfeeling
	wait(2); 
//	level.britfour thread doDialogue("matmata_bs4_eyesonroad"); // matmata_bs4_eyesonroad
	
}

ridein()
{
	wait 0.05;
	jeep = getent ("jeep","targetname");
	jeep.animname = "jeep"; 
	battlechatteroff("allies"); 
	level.player setorigin(jeep gettagorigin("tag_player_passenger"));
	level.player setplayerangles(jeep gettagangles("tag_player_passenger"));
	level.player playerLinkToDelta(jeep,"tag_player_passenger",.3);
	
	thread rideAnimation(); 
		
	jeep waittill ("reached_end_node");
//	level.player shellshock ("default",5);
	level.driver notify("stop_driving");
	level.player setFriendlyChain(getnode("alleyfriendlychain","targetname"));
	friendlies = getaiarray("allies"); 
	array_thread(friendlies, ::friendlyMethod);	
	wait 3;
	thread jeepGetOut();
	//level.player unlink();
	//level.player setorigin ((1538,5626,24));
	level thread roof_guys();
	level thread deleteNaziTrucker();
}

jeepGetOut()
{
	jeep = getent ("jeep","targetname");
	dummy = spawn("script_origin", jeep getTagOrigin("tag_player_passenger") );
	dummy.angles = jeep getTagAngles("tag_player_passenger");
	
	level.player unlink();
	level.player linkto (dummy);
	
	endPos = (1556, 5483, 60);
	
	dummy moveTo(dummy.origin + (0,0,10), .6, .3, .2);
	wait .6;
	dummy moveTo(endPos, .6, .3, .2);
	wait .5;
	
	level.player unlink();
	hackJeepCollision();
}

objective_master()
{
	//1st objective - Scout the Matmata route to Tunis
	compass_scout = getent ("compass_scout", "targetname");
	objective_add(0, "active", &"MATMATA_SCOUT_OBJECTIVE", compass_scout.origin);
	objective_current(0);
}

objective_clearRoute()
{
	objective_state(0,"done");
	objective_add(1, "active", &"MATMATA_CLEAR_OBJECTIVE", getent("aaGunObjective","targetname").origin);
	objective_current(1);			
}

objective_aaGun()
{
	objective_state(1,"done");
	objective_add(2, "active", &"MATMATA_AAGUN_OBJECTIVE", getent("aaGunObjective","targetname").origin);
	objective_current(2);	
}

roof_guys()
{
//	level waittill("spawn_roof_guys");
	
	thread autosavebyname("in alley");
	wait(2); 
	level.axis_accuracy = .9;
	spawners = getentarray("tankKiller","targetname");
	tank = getent ("tank1","targetname");
	tank.health = 50;
	thread panzerguys(spawners, tank);
	ambushGuys = getentarray("intialAmbushGuys","targetname");
	for(i = 0; i < ambushGuys.size; i++)
	{
		ambushGuys[i] thread ambushSpawnerThink();
	}
	
	level.britfour thread doDialogue("matmata_bs4_pzambush"); // matmata_bs4_pzambush
	thread playAmbushMusic();

	getent("truck","targetname").health = 50; 
	wait(2.5); 
	level.britthree thread doDialogue("matmata_bs3_stayaway"); // matmata_bs3_stayaway
	level.britthree notify ("stop magic bullet shield");

	wait(4);
	battlechatteron("allies");

	thread panzerguys(getentarray("secondPanzer","targetname"),getent("carrier","targetname"));
	
	level.britfour thread doDialogue("matmata_bs4_retfire"); // matmata_bs4_retfire
	wait(1);
	
	thread panzerguys(getentarray("thirdPanzer","targetname"),getent("truck","targetname"));
	wait(1);
	
	level.macgregor thread doDialogue("matmata_mcg_opengate"); // matmata_mcg_opengate
	wait(2);
	
	level notify("shake_gate"); 
	level.gateshaker thread doDialogue("matmata_bs4_onitmate"); // matmata_bs4_onitmate
	spawnAndTag(getentarray("mp40dudes","targetname")); 
	level waittill("at_the_gate"); 
	wait(7);
	 
	thread panzerguys(getentarray("fourthPanzer","targetname"),getent("gate","targetname")); 
	wait(2); 
	
	
	
}


playAmbushMusic()
{
	level endon("stop_ambush_music");
	wait(1);
	while(1)
	{
		musicplay("matmata_ambush");
		wait(33.436);
	}	
}

shakeGateSequence()
{
	gateshaker = getent("gateshaker","targetname");
	gateshaker thread magic_bullet_shield();
	gateshaker.animname = "gateopener"; 
	level.gateshaker = gateshaker; 
	level waittill("shake_gate");
	gateshaker.ignoreme = true;
	gateshaker.team = "neutral";
	gateshaker set_forcegoal();
	node = getent("gate_anim","targetname");
	level.gateshaker pushPlayer(true);
	node anim_reach_solo(gateshaker, "gateopen", undefined, undefined, gateshaker);
	level notify("at_the_gate");
	
	gateshaker.allowdeath = true; 
	gateshaker thread shakeGate(node); 
	gateshaker thread checkGateShakerDeath(); 
	gateshaker unset_forcegoal();
}

shakeGate(node)
{
	level endon("gate destroyed");
	
	self anim_single_solo(self, "gateopen", undefined, node, self);
	self playsound("matmata_gaterattle"); 
	while(1)
	{
		self anim_single_solo(self, "shakegate", undefined, node, self);
		self playsound("matmata_gaterattle"); 
		self anim_single_solo(self, "shakegaterest", undefined, node, self);
		self anim_single_solo(self, "shakegate", undefined, node, self);
		self playsound("matmata_gaterattle"); 		
	}

}

checkGateShakerDeath()
{
	level waittill("gate destroyed");
	self.deathanim = level.scr_anim[self.animname]["blownup"];
	self dodamage(self.health + 1, self.origin);
	wait(1);
	level.player setfriendlychain(getnode("chainPastGate","targetname")); 
}

panzerguys(spawners, target)
{
	for (i = 0; i < spawners.size; i++)
	{
		guy = spawners[i] dospawn();
		if (spawn_failed(guy))
			continue;
	
		guy.deleteme = spawners[i].deleteme; 
		guy.targetname = spawners[i].targetname; 
		guy.script_noteworthy = spawners[i].script_noteworthy; 
		guy thread magic_bullet_shield();
		guy.dropweapon = false;	
		guy.anim_disablePain = true;
		guy.ignoreme = true;
		guy.grenadeawareness = 0; 
		guy thread shootPanzer(target);
	}
}


shootPanzer(target)
{
	if(!isdefined(self))
		return; 
		
	node = getnode (self.target,"targetname");

	if(target.targetname != "gate")
		level thread maps\_spawner::panzer_target(self, node, undefined, target, (0,0,32));
	else
	{
		
		level thread maps\_spawner::panzer_target(self, node, target.origin);
		self thread shootGate(); 
	}

	self waittill("shot_at_target");

	node = getnode(self.script_noteworthy,"script_noteworthy"); 
	self notify ("stop magic bullet shield");

	self.anim_disablePain = false;
	self.ignoreme = false;
	wait(1);
	if(!isdefined(self))
		return; 
	if(isdefined(node))
		self setGoalNode(node);
	else
		self dodamage(self.health + 100, self.origin); 
		
	self.pacifist = true; 
	self.goalradius = 64;
	self waittill("goal");
	self delete();
}

shootGate()
{
	self waittill("shot_at_target"); 
	wait(0.3);
	getent("gate","targetname") playsound("explo_metalgate"); 
	level notify("blow_gate"); 	
}

killdriver()
{
	spawner = getent("driver","targetname");
	spawner waittill("spawned",driver);
	level.driver = driver; 
	driverkill = getvehiclenode("driverkill","script_noteworthy");
	driverkill waittill("trigger");	
	driver dodamage(driver.health + 100, driver.origin);
}

crashjeep()
{
	getvehiclenode("crash","script_noteworthy") waittill("trigger");
	
	jeep = getent("jeep","targetname");
	jeep setmodel("xmodel/vehicle_africa_jeep_crash"); 
	thread blurPlayer();
	earthquake(1, 1, level.player.origin, 3000); // scale duration source radius
	level.macgregor notify("stop_idle");
	thread anim_single_solo(level.gateshaker,"crash","tag_guy1",undefined,jeep);
	thread anim_single_solo(level.macgregor,"crash","tag_guy0",undefined,jeep);
	wait(1); 
	level.driver unlink();
	level.driver linkto(level.jeep,"tag_driver",(2,0,0),(0,0,0));
	
	thread anim_single_solo(level.gateshaker,"jumpout","tag_guy1",undefined,jeep); 
	level.gateshaker unlink(); 
	thread anim_single_solo(level.macgregor,"jumpout","tag_guy0",undefined,jeep); 
	level.macgregor unlink(); 
		
	maps\_fx::loopfx("vehicle_steam", (1494,5542,37), 0.3, (1484,5598,75));
//	level.player shellshock ("default",2);

	
	level.player unlink();
	level.player playerLinkToDelta(jeep, "tag_player_passenger", 1.0);
}

blurPlayer()
{
	setblur(15,.5); 
	wait(2); 
	setblur(0,2); 
	
}
frontgate()
{
 	level waittill("blow_gate"); 

  exploder(0);
	level notify("gate destroyed");
}

friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;
		
	guy.followmin = level.followmin;
	guy.followmax = level.followmax;
	guy setgoalentity (level.player);
}

spawnAndTag(spawnerArray,maxNumberToSpawn,spawnRandom,isPlayerGoal,startRadius)
{
	if(!isdefined(spawnerArray))
		return; 

	if(isdefined(maxNumberToSpawn) && isdefined(spawnRandom) && (spawnRandom == true))
	{
		for(i = 0; i < maxNumberToSpawn; i++)
		{
			spawned = spawnerArray[randomint(spawnerArray.size - 1)] doSpawn(); 
			if(spawn_failed(spawned))
				continue;
			
			if(isdefined(spawnerArray[i].targetname))
			{
				spawned.targetname = "spawned_" + spawnerArray[i].targetname; 
			}
			if(isdefined(spawnerArray[i].script_noteworthy))
			{
				spawned.script_noteworthy = "spawned_" + spawnerArray[i].script_noteworthy;
			}				
			if(isdefined(isPlayerGoal) && isPlayerGoal == true)
			{
				spawned setgoalentity(level.player); 
				if(isdefined(startRadius))
				{
					spawned.goalradius = startRadius; 
				}
			}
		}
		return spawnerArray; 
	}
	
	for(i = 0; i < spawnerArray.size; i++)
	{
		
		if(isdefined(maxNumberToSpawn) && (i >= maxNumberToSpawn))
			continue; 

		spawned = spawnerArray[i] doSpawn();
		 
		if(spawn_failed(spawned))
			continue; 
		
		if(isdefined(spawnerArray[i].targetname))
		{
			spawned.targetname = "spawned_" + spawnerArray[i].targetname; 
		}
		if(isdefined(spawnerArray[i].script_noteworthy))
		{
			spawned.script_noteworthy = "spawned_" + spawnerArray[i].script_noteworthy;
		}				
	}	
	return spawnerArray; 
}

levelSetup()
{
	setCullFog (0, 80000, .25, .2, .1, 0);	

	//Cpt price
	level.price = getent("price","script_noteworthy");
	level.price thread maps\_utility::magic_bullet_shield();
	level.price.animname = "price";
	
	//macgregor
	level.macgregor = getent("macgregor","script_noteworthy");
	level.macgregor thread maps\_utility::magic_bullet_shield();
	level.macgregor.animname = "macgregor";
	
	level.maxfriendlies = 6;
	level.friendlywave_thread = ::friendlyMethod;
	level.friendlyradius = 350;
	level.followmax = 1;
	level.followmin = -2;
	precacheModel("xmodel/vehicle_stuka_flying");
 	precacheModel("xmodel/vehicle_spitfire_flying");
	precacheModel("xmodel/german_artillery_flakveirling_viewmodel");
	level.ongun = false; 
	level.gunswapped = false; 
	level.playerhit = 0; 
	level.easyhits = 0; 
	level.flaktaken = false; 
	level.planeStarted = false; 
	level.timesFlakShot = 0; 
	getent("blownJeepClip","targetname") triggerOff();
	getent("blownJeepClip2","targetname") triggerOff();

	level.jeep = maps\_vehicle::waittill_vehiclespawn("jeep");


}

courtyardFlak()
{
//	getent("courtyard_trigger","targetname") waittill("trigger"); 
	level waittill("fire_aa");
	level thread setupQuadGun(); 
	thread objective_aaGun();
}

courtyard()
{
	thread flakGuys(); 
	getent("courtyard_trigger","targetname") waittill("trigger"); 
	
	setCullFog (0, 80000, .25, .2, .1, 10);

	thread autosavebyname("courtyard");
	level waittill("flak_guys_diminished"); 
	level.price thread doDialogue("matmata_pri_jerriesonwestwall");
	level.player setfriendlychain(getnode("friendly_north","targetname")); 

	spawnAndTag(getentarray("northGroup","targetname"));
	level thread checkGuysAlive("spawned_northGroup",2,"north diminished");
	level waittill("north diminished"); 
	level.player setfriendlychain(getnode("friendly_east","targetname")); 
	level.price thread doDialogue("matmata_pri_jerriesonnorthwall");
	
	thread autosavebyname("courtyard");
	spawnAndTag(getentarray("eastGroup","targetname"));
	level thread checkGuysAlive("spawned_eastGroup",2,"east diminished");
	level waittill("east diminished"); 
	level.player setfriendlychain(getnode("friendly_south","targetname")); 
	level.price thread doDialogue("matmata_pri_jerriestoeast");
	
	spawnAndTag(getentarray("southGroup","targetname"));
	level thread checkGuysAlive("spawned_southGroup",2,"south diminished");
	level waittill("south diminished"); 

	objective_state(2,"done");
	objective_add(3, "active", &"MATMATA_FLAK_OBJECTIVE", getent("aaGunObjective","targetname").origin);
	objective_current(3);	

	level.price thread doDialogue("matmata_pri_20mm");
	approachHint = spawnStruct(); 
	approachHint.text = &"MATMATA_PLATFORM_APPROACH_AA_GUN";
	add_hudelm_hint(approachHint,undefined,7);
	
	
	wait(2); 
	level thread planeSequence();
}

flakGuys()
{
	getent("courtyard_trigger","targetname") waittill("trigger"); 
	spawnAndTag(getentarray("flak_guys","targetname")); 
	flakGuys = getentarray("spawned_flak_guys","targetname");
	level thread checkGuysAlive("spawned_flak_guys",2,"flak_guys_diminished"); 
}

checkGuysAlive(nameOfGuys, num, message)
{
	wait 0.05;
	while(1)
	{
		guys = getentarray(nameOfGuys,"targetname");
		if(guys.size < num || !guys.size)
		{
			level notify(message); 
			break; 
		} 
		wait(0.05); 
	}
}

autosave1()
{
	getent("autosave1","targetname") waittill("trigger"); 
	thread autosavebyname("mg nest"); 
}

autosave2()
{
	getent("autosave2","targetname") waittill("trigger"); 
	thread autosavebyname("before smoke"); 
	level notify("shut up");
}

autosave3()
{
	getent("autosave3","targetname") waittill("trigger"); 
	thread autosavebyname("after car"); 
}

autosave4()
{
	getent("autosave4","targetname") waittill("trigger"); 
	thread autosavebyname("before courtyard"); 
}

radioCall()
{
	getent("radioGuy","targetname") waittill("trigger"); 
	level notify("stop_ambush_music");
	musicstop(6);
	objective_clearRoute();	
	thread autosavebyname("radio call");
}

runIntoSmoke()
{
	getent("smokerRunner_trigger","targetname") waittill("trigger"); 

//	spawnAndTag(getentarray("smokeRunners","targetname")); 	
	smokeRunnerSpawner = getent("smokeRunners","targetname"); 
	while(smokeRunnerSpawner.count)
	{				
		guy = smokeRunnerSpawner doSpawn(); 
		if(spawn_failed(guy))
		{
			return; 
		}			
		guy thread _deleteAtSecondBuilding();
   		wait(1);
   }
//	smokeRunners = getentarray("spawned_smokeRunners","targetname"); 
//	for( i = 0; i < smokeRunners.size; i++)
//	{
//		smokeRunners[i] thread _deleteAtSecondBuilding(); 
//	} 
}


_deleteAtSecondBuilding()
{
	while(1)
	{
		if(isdefined(self))
		{
			if(self istouching(getent("secondBuilding_trigger","targetname")))
			{
				
				self delete(); 
				break; 
			}
		}
		wait(0.05); 
	}	
}

throwCoverSmoke()
{ 
	getent("throwCoverSmoke_trigger","targetname") waittill("trigger"); 
	level.britfour thread doDialogue("matmata_bs4_smokegrenade");
	smokey = getent("smokeyTheBrit","targetname") dospawn(); 
	if(spawn_failed(smokey))
	{
		return; 		
	}
	smokey.ignoreme = true;
	smokey thread magic_bullet_shield(); 
	smokey setgoalnode(getnode("smokeNode","targetname")); 
	smokey set_forcegoal(); 
	smokey.goalradius = 8; 
	smokey waittill("goal"); 
	
	smokey.grenadeWeapon = "smoke_grenade_british";
	smokey.grenadeAmmo++; 
	smokey MagicGrenade(smokey.origin,getent("smokePos02","targetname").origin);	
	smokey notify("stop magic bullet shield"); 
	smokey.ignoreme = false; 
	smokey setgoalentity(level.player); 
}


halftrackRetreatSequence()
{
	node = getVehicleNode("firstStop","script_noteworthy");
	node waittill ("trigger");
	level.halftrack setspeed(0,10);
	getent("halftrackRetreat_trigger","targetname") waittill("trigger"); 
	
	if(!isdefined(level.halftrack))
		return; 
	level.halftrack setspeed(10,10); 		
}

halftrackStopByHQ()
{
	node = getVehicleNode("secondStop","script_noteworthy");
	node waittill ("trigger");
	level.halftrack setspeed(0,10);	
}

shootHalftrack()
{
	node = getVehicleNode("shootHalftrack","script_noteworthy");
	node waittill ("trigger");
	if(!isdefined(level.halftrack))
		return;
		
	level.tank setspeed(0,10);
	eTarget = level.halftrack; 
	level.halftrack resumespeed(5,0);
	axis = getaiarray("axis"); 
	for( i = 0; i < axis.size; i++)
	{
		if(isdefined(axis[i]) && isalive(axis[i]))
		{
			axis[i] customBattleChatter("move_back"); 
			break; 
		}
		
	}
	wait(2);
	level.tank setTurretTargetVec(eTarget.origin);
	level.tank waittill("turret_on_target");
	level.tank notify("turret_fire");
	wait(1);
	level.tank setTurretTargetVec(eTarget.origin);
	level.tank waittill("turret_on_target");
	level.tank notify("turret_fire");
	
	level.tank resumespeed(3);
	node = getVehicleNode("kill_halftrack","script_noteworthy");
	node waittill("trigger"); 
	level.tank setTurretTargetVec(eTarget.origin + (0,0,50));
	level.tank waittill("turret_on_target");
	level.tank notify("turret_fire");
	level notify("fire_fakeQuad");
	level.tank setTurretTargetVec(getent("straightAhead","targetname").origin);
}

fireFakeQuadGun()
{
	level endon("fire_aa"); 
	level waittill("fire_fakeQuad"); 

	level.flakgun.health = 100000;
	level.flakgun UseAnimTree(level.scr_animtree["panzerflak"]);

	level.flakgun setanimknobrestart(level.scr_anim["panzerflak"]["basepose"]);
	
	self endon("stop firing"); 
	while(1)
	{
		for(i = 0; i < 30; i++)
		{
			level.flakgun fireturret(); 
			wait(0.13);
		}	
		wait(2.5 + randomint(1)); 
	}
}


fireRealQuadGun()
{
	getent("playerCanSeeQuad","targetname") waittill("trigger");
	level notify("fire_aa"); 
}

grabVehicles()
{
	level.flakGun = getent("flakGun","targetname");
	level.flakgun.health = 100000;
	level.flakgun makevehicleunusable();
	level.flakgun setTurretTargetVec(getent("flakspot","targetname").origin); 
	thread _getHalftrack();
	thread _getTank();
}

_getHalftrack()
{
	level.halftrack = maps\_vehicle::waittill_vehiclespawn("thehalftrack");	
}

_getTank()
{
	level.tank = maps\_vehicle::waittill_vehiclespawn("happyTank");	
}

setupQuadGun()
{
	spawnAndTag(getentarray("gunner","targetname")); 
	spawnAndTag(getentarray("rightloader","targetname")); 
	spawnAndTag(getentarray("leftloader","targetname")); 
	
	gunner = getent("spawned_gunner","targetname"); 
	leftLoader = getent("spawned_leftloader","targetname");
	rightLoader = getent("spawned_rightloader","targetname");
	
	
	gunner linkto (level.flakGun, "driver_flak");
	gunner.animname = "gunner"; 
	gunner.attachpoint = "driver_flak"; 
	gunner.dropweapon = false;
	gunner.grenadeammo = 0;

	leftLoader linkto (level.flakGun, "loaderL_flak");
	leftLoader.animname= "leftloader";
	leftLoader.attachpoint = "loaderL_flak"; 
	leftloader.dropweapon = false; 
	leftloader.grenadeammo = 0; 

	rightLoader linkto (level.flakGun, "loaderR_flak");
	rightLoader.animname = "rightloader"; 
	rightLoader.attachpoint = "loaderR_flak";
	rightloader.dropweapon = false; 
	rightloader.grenadeammo = 0; 
	
	level.flakgun.health = 100000;

	gunner thread fireQuadGun(); 
	leftLoader thread fireQuadGun(); 
	rightLoader thread fireQuadGun(); 

	level thread fireQuadGunCannon(); 
	
	gunner thread checkCrewMemberDeath();
	rightLoader thread checkCrewMemberDeath();
	leftLoader thread checkCrewMemberDeath();

	gunner thread dismountQuadGun(); 
	rightLoader thread dismountQuadGun();
	leftLoader thread dismountQuadGun();

	level thread dismountIfClose(); 
	level waittill("dismount_gun"); 
	level thread resetGun();
	level.flakgun thread shootQuadGun(); 
}

#using_animtree("flakpanzer"); 
fireQuadGunCannon()
{
	level.flakgun UseAnimTree(level.scr_animtree["panzerflak"]);
	level.flakgun endon("stop firing"); 
	level.flakgun thread _fire(); 
	while(1)
	{
		level.flakgun setflaggedanimrestart ("fitsandgiggles",level.scr_anim["panzerflak"]["fire_b"]);
		level.flakgun waittillmatch("fitsandgiggles","end");	 	
//		wait(3.5);
	}
}

_fire()
{
	self endon("stop firing"); 
	while(1)
	{
		if(level.flaktaken == true)
			break; 
		level.flakgun fireturret(); 
		wait(0.13);
	}
}

fireQuadGun()
{
		self endon("stop firing"); 
		self.hasWeapon = false;
		self animscripts\shared::putGunInHand ("none");
		self.allowdeath = true; 
		self anim_loop_solo(self, "fire_b", self.attachpoint,"fire_anim_loop" ,undefined, level.flakgun);
}

dismountIfClose()
{
	for(;;)
	{
		allies = getaiarray("allies"); 
		for(i = 0; i < allies.size; i++)
		{
			if(allies[i] istouching(getent("getOffGunTrigger","targetname")) || 
				 level.player istouching(getent("getOffGunTrigger","targetname")))
			{
				level notify("dismount_gun"); 
				level notify("kill_checkdeath"); 
				level.flakgun notify("stop firing");		
			}
		}
		wait(0.05); 
	}
}

checkCrewMemberDeath()
{
	self endon("kill_checkdeath"); 
	for (;;)
	{
		self waittill ("damage", amount, attacker);
		break;
	}
	
	level.flakgun notify("stop firing");
	level.flaktaken = true; 
	level notify("dismount_gun");
	self.olddeathanim = self.deathanim;
	self.deathanim = level.scr_anim[self.animname]["deathfall"];
	self unlink(); 
	self dodamage(self.health + 1, self.origin);
}

dismountQuadGun()
{
	level waittill("dismount_gun"); 
	if(isdefined(self) && isalive(self))
	{
		self anim_single_solo(self, "dismount", self.attachpoint, undefined, level.flakgun);
		self.hasWeapon = true;
		self animscripts\shared::putGunInHand("right");
		self unlink(); 
		self notify("kill_checkdeath");
		if(isdefined(self.olddeathanim))
		{
			self.deathanim = self.olddeathanim; 
			
		}
	}
}

planeJumpto()
{
	level thread setupQuadGun(); 
	level.flakgun makevehicleusable();
	thread planeSequence(); 	
}

makeQuadUseable()
{
	
	level waittill("dismount_gun"); 
	level.flakgun makevehicleusable();
}

resetGun()
{

	for(;;)
	{
		level.flakgun waittill("trigger");
		thread killdogfight();
		
		owner = level.flakgun getvehicleowner();
		if (!isdefined(owner))
			continue;
		if (owner != level.player)
			continue;
		level.flakgun setmodel("xmodel/german_artillery_flakveirling_viewmodel");
		if(level.gunswapped == false)
		{
			level.gunswapped = true; 
			angles = level.flakgun.angles; 
			origin = level.flakgun.origin; 
			level.flakgun useby(level.player); 
			level.flakgun delete(); 
			level.flakgun = undefined;
			level.flakgun = spawnVehicle("xmodel/german_artillery_flakveirling_viewmodel", "flakGun", "flakveirling_player", origin, angles);
			level.flakgun.health = 100000;
			level.flakgun UseAnimTree(level.scr_animtree["panzerflak"]);
			level.flakgun makevehicleusable();
			level.flakgun useby(level.player);
			level.flakgun thread shootQuadGun();
		}
		level.ongun = !level.ongun;
		
		level.flakgun setanimknobrestart(level.scr_anim["panzerflak"]["basepose"]);
		
		while(1)
		{
			owner = level.flakgun getvehicleowner(); 
			if(!isdefined(owner))
				break; 
			wait(0.05);
		}
		level.flakgun setmodel("xmodel/german_artillery_flakveirling");

		wait(0.05); 
	}
}

bombingRun(node)
{
	sky_makeplane(node) thread planeThink();
}

planeSequence()
{
	thread autosavebyname("in alley");
	extrawait = 0; 
	if(level.xenon || level.gameSkill == 0)
	{	
		extrawait = 2;
	}
	if(level.xenon && (level.gameSkill == 2))
		extrawait = 1; 
	
	if(level.xenon && (level.gameSkill == 3))
		extrawait = 0; 
	
	level.player.planeskilled = 0; 
	
	left = getvehiclenode("fourthpath","targetname");
	upperleft = getvehiclenode("sixthpath","targetname");
	middle = getvehiclenode("thirdpath","targetname");
	upperright = getvehiclenode("seventhpath","targetname");
	right = getvehiclenode("fifthpath","targetname");
	level.planeStarted = true; 
	thread playPlaneMusic(extrawait); 
	
	thread checkForMissionFailure(extrawait); 

	thread bombingRun(right);
	
	wait(5 + extrawait); 
	thread bombingRun(middle); 
	wait(3 + extrawait);
	thread bombingRun(upperright); 
	wait(2 + extrawait); 
	thread bombingRun(right);
	wait(5 + extrawait); 
	thread bombingRun(upperleft); 
	wait(2 + extrawait); 
	thread bombingRun(middle); 
	wait(3 + extrawait); 
	thread bombingRun(left); 
	wait(5 + extrawait); 

	if(isalive(level.player))
	{
		level.macgregor thread dodialogue("matmata_mcg_planecheer"); 
	}
	
	thread bombingRun(left); 
	wait(3 + extrawait); 
	thread bombingRun(right); 
	wait(3 + extrawait); 
	thread bombingRun(upperleft); 
	wait(3 + extrawait); 
	thread bombingRun(upperRight); 
	wait(1 + extrawait); 
	thread bombingRun(middle); 			
	wait(13.5);
	thread playVictoryMusic(); 
	objective_state(3,"done");
	level.price thread doDialogue("matmata_pri_ending");
	wait(11.5);
	maps\_endmission::nextmission();
}

checkForMissionFailure(extrawait)
{
	wait(20 + (extrawait * 2));
	missionFail = false; 
	owner = level.flakgun getvehicleowner();
	if (!isdefined(owner))
		missionFail = true;
	if (isdefined(owner) && owner != level.player)
		missionFail = true;
	
	if(missionFail == false)
		return; 
		
	setCvar("ui_deadquote", &"MATMATA_FAILED_TO_MAN_ANTIAIRCRAFTGUN");
	maps\_utility::missionFailedWrapper();		
}
playVictoryMusic()
{
	musicstop(1);
	wait(1);
	musicplay("matmata_victory");
}

playPlaneMusic(extrawait)
{
	wait(2 + (11 * extrawait)); 
	musicplay("matmata_antiaircraft");	
}

planesound()
{
	wait(9);
	self playsound("matmata_stuka_flyby" + ( 1 + randomint(3)),"done",true);
//	breakpoint;
//	wait(0.1); 
//	self playsound("explo_plane","done",true);
}

planeThink()
{
//	iprintlnbold(self.health);
	self thread planeSound(); 
	self thread bombPlayer();
	while(1)
	{
		self waittill("damage",amount,attacker);
		if(attacker == level.flakgun)
			break; 
		wait(0.05); 
	}
	org = spawn ("script_origin",self.origin);
	org linkto(self); 
	playfx(level._effect["planeexplosion"], self.origin);
	self playsound("explo_plane","done",true);
	earthquake(1.0, 1.5, self.origin, 5000);
	self playsound("game_save","done",true); 
	wait(0.05); 
	self thread _spewSmoke(); 
	thread explodeInDistance(org); 
	self dodamage(self.health + 1, self.origin);
	level.player.planeskilled++;


//	iprintlnbold("damaged"); 
//	playfx(level._effect["planeexplosion"], self.origin);	
//	self thread explodeInDistance(); 

	
	
//	node = getVehicleNode(self.startnode.endnode,"targetname");
//	self setwaitnode(node);
//	self waittill("reached_wait_node");
//	self delete(); 
}

explodeInDistance(ent)
{
	wait(5);
	ent playsound("distant_explosion_triggered");
}

bombPlayer()
{
	while(1)
	{
		if(!isdefined(self))
			break;
		if(self.health > 0 && (self.origin[1] < 4350))
		{
			if(level.gameSkill == 0)
			{
					
				if(level.easyhits < 2)
				{
					level.easyhits++;
					break;		
				}
			}
			
			playfx(level._effect["boom"], getent("bombspot1","targetname").origin);	
			level.player playsound("explo_metal_rand");
			earthquake(0.7, 2.5, level.player.origin, 5000);
		
		///	level.player shellshock ("default",1);
			wait(.3);
			if(level.gameSkill == 3)
			{
				level.player dodamage(level.player.health + 1,level.player.origin);								
				break;
			}
			if(level.playerhit < 3)
			{
				level.player dodamage(50,level.player.origin);
				level.playerhit++; 
			}
			else
			{
				level.player dodamage(level.player.health + 1,level.player.origin);				
			}
			break; 
		}
		wait(0.05); 
	}
}

_spewSmoke()
{
	while (1)
	{
		if(isdefined(self))
			playfxOnTag ( level._effect["planeenginesmoke"], self, "tag_engine_left" );
		wait .1;
	}	
}

shootQuadGun()
{
	while(self.health > 0)
	{
		owner = level.flakgun getvehicleowner();
		if ((level.planeStarted == false) && isdefined(owner) && owner == level.player)
		{
			level.timesFlakShot++;
		}

		self waittill( "turret_fire" );
		self _shoot();
	}
}

getOffFlakHint()
{
	while(1)
	{
		if(level.timesFlakShot > 20)
		{
			iprintlnbold(&"MATMATA_NOT_EFFECTIVE_AGAINST_INFANTRY");	
			level.timesFlakShot = 0; 	
			break; 
		}
		wait(0.05);
	}	
	
}
_shoot()
{
	if(self.health <= 0)
		return;

	// fire the turret
	self setanimrestart (level.scr_anim["panzerflak"]["basefire"]);
	self FireTurret();
}

planeRun()
{
	node = getVehicleNode("startPlaneRun","script_noteworthy");
	node waittill ("trigger");
	level.bomber = sky_makeplane(getvehiclenode("tankBomber","targetname"));
	level thread blowTank(); 
	level.bomber thread _planeRunSound();

}

_planeRunSound()
{
	wait(3); 
	level.bomber playsound("matmata_stuka_flyby1"); 
}

sky_makeplane(node, type, speed)
{
//	node = getVehicleNode( name, "targetname" );
	plane = undefined;
	path = node;
  assert(isdefined(path));
  plane = spawnVehicle("xmodel/vehicle_stuka_flying", "plane", "stuka", (0,0,0), (0,0,0));
  assert(isdefined(plane));
  
  plane setmodel ("xmodel/vehicle_stuka_flying");
  plane.vehicletype = "stuka";
  plane.health = 22;
  plane.target = path.targetname;
  plane.script_team = "axis"; 
  plane setvehicleteam(plane.script_team);
//  iprintlnbold(plane.target);
  //plane maps\_vehicle::vehicle_paths_setup(path);
  plane maps\_vehicle::getonpath();
  level thread maps\_vehicle::gopath(plane);
//  plane thread die();
  plane thread end_node();

//	if(isdefined(speed))
//		plane setspeed(speed, speed);
	
	//plane thread sky_quake();
	return plane;
}

end_node()
{
	if(!isdefined(self))
		return; 
	self waittill ("reached_end_node");
//	waittillframeend; 
	self delete();
}

sky_quake()
{
	self endon("death");
	while (1)
	{
		earthquake(0.5, 0.1, self.origin, 3000); // scale duration source radius
		wait (0.1);
	}
}


blowTank()
{
		node = getVehicleNode("tankBoom","script_noteworthy");
		level.bomber setwaitnode(node);
		level.bomber waittill("reached_wait_node");
//		level.bomber thread end_node(); 
		if(getcvar("start") != "tankbomb")
		{
			earthquake(1.0, 1.0, level.tank.origin, 6000);
			level.tank dodamage(10000000,(0,0,0));
			level.tank notify ("death");	
		}
		else
		{
			iprintlnbold("BOOM"); 
		}
}

doDialogue(string,dev)
{

	
	if(isdefined(dev))
	{
		iprintlnbold(string); 
	}
	else
	{
		self setbattlechatter(false);
		if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
			self waittill ("my done speaking");
		
		self.myisspeaking = true; 
		
		level anim_single_solo(self, string);
		// we could have been killed during the animation
		if(!isdefined(self))
			return; 		
		self setbattlechatter(true);
		self.myisspeaking = false;
		self notify("my done speaking");
	}

}

killAmbushDudes()
{
	level waittill("player_past_gate");
	nazis = getaiarray("axis"); 
	for(i = 0; i < nazis.size; i++)
	{
		if(!isdefined(nazis[i]))
			continue;
		if(!isalive(nazis[i]))
			continue; 
		
		if(nazis[i] istouching(getent("killAmbushDudes","targetname")))
		{
				nazis[i] dodamage(nazis[i].health + 1, nazis[i].origin);
		}	
		
	}	
	
}
macgregorAtGate()
{
	level endon("player_past_gate"); 
	level waittill("gate destroyed"); 
	for(;;)
	{
		level.macgregor thread doDialogue("matmata_mcg_gateisopen"); // matmata_mcg_gateisopen
		wait(15); 
	}	
}

checkPlayerPastGate()
{
	getent("pastGate","targetname") waittill("trigger"); 
	level notify("player_past_gate"); 	
}


priceWaitByMacGregor()
{
	level endon("shut up");
	getent("pastGate","targetname") waittill("trigger"); 
	wait(1); 
	level.price setgoalnode(getnode("priceRadio","targetname")); 	
	level.price.goalradius = 16; 
	level.price set_forcegoal();
	level.price waittill("goal"); 	
}

macgregorUseRadio()
{
	level endon("shut up");
	getent("pastGate","targetname") waittill("trigger"); 
	level.axis_accuracy = 1;
	wait(1); 
	level.macgregor setgoalnode(getnode("macgregorRadio","targetname")); 	
	level.macgregor.goalradius = 16; 
	level.macgregor set_forcegoal();
	level.macgregor waittill("goal"); 
	level.macgregor.animname = "macgregor";
  level.macgregor attach("xmodel/us_ranger_radio_hand");
// 	anim_reach_solo(level.macgregor, "radioidle", undefined,getnode("macgregorRadio","targetname"), level.macgregor);
  
  level.macgregor thread anim_loop_solo(level.macgregor,"radioidle",undefined,"stop_radioman_idle",getnode("macgregorRadio","targetname"));
  

//  radioman notify ("stop_radioman_idle");
//  radioman scene_playAnim("talk", undefined, node, undefined, "duhocassault_coffey_tarefoxabel", undefined, undefined, false);
   
//  radioman thread anim_loop_solo( radioman, "idle", undefined, "stop_radioman_idle", node ); }


	for(;;)
	{
		if(distance(level.macgregor.origin,level.player.origin) < 600) 
		{
			level.macgregor thread doDialogue("matmata_mcg_radiosummon"); // matmata_mcg_radiosummon
			wait(15);
		} 		
		
		wait(0.05);
	}	
}

grabMacGregor()
{
	level.macgregor = getent("macgregor","script_noteworthy");
}

grabPrice()
{
	level.price = getent("price","script_noteworthy");
}

#using_animtree("eldaba_dogfight");
DogFights()
{
	level thread DogFights_CreateGroup(60);
	wait 2;
	level thread DogFights_CreateGroup(93);
	wait 2;
	level thread DogFights_CreateGroup(90);
}

DogFights_CreateGroup(angles)
{
	rigAngles = (0,angles,0);

	level thread DogFights_CreateSingle("axis", rigAngles);
	level thread DogFights_CreateSingle("allies", rigAngles);
}

DogFights_CreateSingle(team, rigAngles)
{
	//spawn rig
	rig 				= spawn("script_model", (5488,3648, 1500 + randomint(1500) ));
	rig.angles			= rigAngles;
	rig.animname 		= "plane rig";
	rig setmodel ("xmodel/eldaba_plane_rig");
	rig UseAnimTree(#animtree);
	rig hide();
	//spawn plane
	plane = spawn ("script_model",(0,0,0));
	tag = undefined;
   
 
	if (team == "allies")
	{
		plane setmodel ("xmodel/vehicle_spitfire_flying");
		tag = "tag_rotator_b";
	}
	else if (team == "axis")
	{
		plane setmodel ("xmodel/vehicle_stuka_flying");
		tag = "tag_rotator_g";
	}
    plane thread playLoopSoundOnTag("stuka_plane_loop", "tag_prop");
 	
	level.dogfighters[level.dogfighters.size] = plane; 
	plane linkto (rig, tag, (0,0,0), (0,0,0));
	plane.script_noteworthy = "dogfighter"; 
	
	//rig plays anim
	rigArray[0] = rig;
	rig thread maps\_anim::anim_loop( rigArray, team );
}

killDogFight()
{
	dogfighters = getentarray("dogfighter","script_noteworthy"); 
	for(i = 0; i < dogfighters.size; i++)
	{
		if(isdefined(dogfighters[i]))
		{
			//dogfighters[i] moveto((0,0,-10000),.05);
			dogfighters[i] hide(); 
		}
	}
	
}
ambushSpawnerThink()
{
	level endon("gate destroyed");
	guy = self doSpawn(); 
	if(spawn_failed(guy))
	{
		return; 
	}

	while(self.count)
	{
		if( !isdefined(guy) || !isalive(guy) )
		{
			guy = self doSpawn(); 
			if(spawn_failed(guy))
			{
				return; 
			}			
		}				
		wait(0.05); 
	}
}

deleteNaziTrucker()
{
	nazis = getaiarray("axis"); 
	for( i = 0; i < nazis.size; i++ )
	{
		if(isdefined(nazis[i].script_noteworthy) && nazis[i].script_noteworthy == "naziTrucker")
		{
			nazis[i] delete(); 
		}
	}
}

tankSequence()
{
	getent("tankTrigger","targetname") waittill("trigger"); 
	level thread cleanUpPreHalftrackNazis(); 
}

cleanUpPreHalftrackNazis()
{
	nazis = getaiarray("axis"); 
	for(i = 0; i < nazis.size; i++)
	{
		if(isdefined(nazis[i]) && (nazis[i] istouching(getent("triggerOfDoom","targetname"))))
		{
			nazis[i] delete(); 
		}
	}
}

deletePriceAndMacGregor()
{
	getent("deletePriceAndMacGregor","targetname") waittill("trigger"); 
	level notify("shut up"); 
	level.price delete(); 
	level.macgregor delete(); 
	level.price = undefined; 
	level.macgregor = undefined; 
}

resurrectPriceAndMacGregor()
{
	getent("courtyard_trigger","targetname") waittill("trigger"); 
	level.price = getent("price2","targetname") dospawn(); 
	spawn_failed(level.price);
	level.macgregor = getent("macgregor2","targetname") dospawn(); 
	spawn_failed(level.macgregor); 
	level.price setgoalentity(level.player); 
	level.macgregor setgoalentity(level.player); 	
	level.price thread magic_bullet_shield();
	level.macgregor thread magic_bullet_shield();
	level.price.animname = "price";
	level.macgregor.animname = "macgregor"; 
}

getBritThree()
{
	spawner = getent("brit3","targetname");
	spawner waittill("spawned",driver);
	level.britthree = driver;
	level.britthree.animname = "soldier";
	level.britthree thread magic_bullet_shield();
}

getBritFour()
{
	spawner = getent("brit4","targetname");
	spawner waittill("spawned",driver);
	level.britfour = driver;
	level.britfour.animname = "soldier";	
	level.britfour thread magic_bullet_shield();
}

getDriver()
{
	spawner = getent("driver","targetname");
	spawner waittill("spawned",driver);
	level.driver = driver; 
	level.driver.animname = "soldier";	
}

tankArrivedDialogue()
{
	getent("tankTrigger","targetname") waittill("trigger"); 
	level.britfour thread dodialogue("matmata_bs4_arrived"); 
}

hackJeepCollision()
{
//	wait(5);
//	jeep waittill("death"); 
//	brushModel = getent("blownJeepClip","targetname");
	getent("blownJeepClip","targetname") triggerOn();
	getent("blownJeepClip2","targetname") triggerOn();

//	brushModel moveto(level.jeep.origin,10); 
	//brushModel.angles = level.jeep.angles; 	
}

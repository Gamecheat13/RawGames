#include maps\_utility;
main()
{
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\_sherman::main("xmodel/vehicle_american_sherman");
	maps\_vehicledroneai::main("xmodel/fx");
	level.enemyflak88s = [];
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	
	if(getcvar("scr_elalamein_fxlevel") == "")
		setcvar("scr_elalamein_fxlevel","2");
	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
		level.smokethrowmod = .05;
		break;
		case 1:
		level.smokethrowmod = .1;
		break;
		case 2:
		level.smokethrowmod = .3;
		break;
		default:
		level.smokethrowmod = .4;
		break;
	}

	setExpFog(.0000544, 131/255, 116/255, 95/255, 0);
	level.mortarthread["cavemortars"] = ::cavemortars_go;
	level.totalfriends = 0;
	level.maxfriendlies = 7;
	level.tanksobjective_index = 0;
	maps\elalamein_fx::main();
	vehicles=getentarray("script_vehicle","classname");	
	for(i=0;i<vehicles.size;i++)
	{
		if(vehicles[i].vehicletype == "crusader" && !isdefined(vehicles[i].script_noteworthy))
			vehicles[i].script_noteworthy = "onemg";
		vehicles[i].script_attackai = 0;//hack all disabled because this now works and tanks destroy everything
	}

	
	array_thread(getentarray("flak88s","script_noteworthy"),::remove_bomb_hack);
	maps\_load::main();
	if (level.xenon)
	{
		setcvar("scr_elalamein_fxlevel","2");
	}
	thread hacktriggers();
	thread endmg42s();
	thread ai_barneyfollow_org();
	maps\elalamein_anim::main(); //includes drones
	thread maps\_mortar::script_mortargroup_style();
	level thread maps\elalamein_amb::main();
	start = getcvar("start");
	thread valley3chainflag();
	thread objectives(start);
	

	mg42s = getentarray("misc_turret","classname");
	level.walkwithtankspeed = 6.6;
	level.friendlywave_thread = ::friendlyMethod;	
	array_levelthread(getentarray("keepmovingai","targetname"),::keepmovingai);
	array_levelthread(getentarray("mg42mod","targetname"),::mg42mod);
	array_levelthread(getentarray("autoclearflaks","targetname"),::autoclearflaks);
	array_levelthread(getentarray("pricechat","targetname"),::pricechat);
	array_levelthread(getentarray("fleetrigger","targetname"),::enemy_retreat_trigger);
	array_levelthread(getentarray("smokethrowtrig","targetname"),::smokethrowtrig);
	array_levelthread(getvehiclenodearray("wave1death","script_noteworthy"),::wave1death);
	array_levelthread(getvehiclenodearray("wave2death","script_noteworthy"),::wave2death);
	array_levelthread(getvehiclenodearray("clearque","script_noteworthy"),::clearque);
	array_levelthread(getvehiclenodearray("noattackback","script_noteworthy"),::noattackback);
	array_thread(getentarray("tankduster","targetname"),::tankduster);
	
	
	level.price = getent("price","targetname");
	level.price.goal_commit = false; //for ignoring setfriendlychains
	level.price.not_hopeless = true;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price setBattleChatter(false);
	level.price.followmin = -3;
	level.price.followmax = 0;
	level.price.dialogque = [];
	level.price thread dialog_handle();
	level.price thread pricechat_handle();
	level.price thread price_chainthink();
	dronetrigger = getent("drone1go","targetname");
	thread valley1_drone(spawn("script_origin",(0,0,0)),dronetrigger);	 // drones
	thread valley2();
	thread valley3();
	if(start != "valley4")
		thread valley3_to_valley4();
	thread valley4();

	/*
	precachestring(&"ELALAMEIN_NORTHERN_EGYPT");
	precachestring(&"ELALAMEIN_NOVEMBER_3_1942");
	precachestring(&"ELALAMEIN_0517_HRS");
	*/
	precachestring(&"SCRIPT_PLATFORM_HINT_USERADIO");
	precachemodel("xmodel/prop_door_metal_bunker_damaged");
	precachemodel("xmodel/military_tntbomb");
//	precacheshader("objpoint_flak");
	
	spawntrigger = getent("stalingradspawn","targetname");
	valley2midtrigger = getent("valley2mid","targetname");
	valley3startspawner = getent("valley3startspawner","targetname");

	dronetrigger triggeroff();
	spawntrigger triggeroff();
	valley2midtrigger triggeroff();
	valley3startspawner triggeroff();
	spawntrigger thread valley1_spawnertrigger();
	thread start_dialog(start);
	


	
	//move the player to the start
	switch(start)
	{
		case "start":
			//level thread maps\_introscreen::introscreen(&"ELALAMEIN_NORTHERN_EGYPT", &"ELALAMEIN_NOVEMBER_3_1942", &"ELALAMEIN_0517_HRS");
			position = getent("start","script_noteworthy");
			level.player setorigin (position.origin);
			level.player setplayerangles((0,180,0));
			level waittill ("finished final intro screen fadein");
			wait 2.8;
			dronetrigger triggeron();
			spawntrigger triggeron();	
			thread valley1_tank_fire_at_trench1();
			break;
		case "valley2": 
			level notify ("player over ridge");
			thread triggerchase(getent(start,"script_noteworthy"));
			break;
		case "valley2mid":
			level notify ("player over ridge");
			valley2midtrigger triggeron();  // spawns 5 friends..
			thread triggerchase(getent(start,"script_noteworthy"));
			break;
		case "valley3":
			level notify ("player over ridge");
			valley3startspawner triggeron();
			thread triggerchase(getent(start,"script_noteworthy"));
			break;
		case "valley4":
			level notify ("player over ridge");
			thread triggerchase(getent(start,"script_noteworthy"));
			wait 1;
			level notify ("flak crews cleared");
			break;
		default:
			thread triggerchase(getent(start,"script_noteworthy"));
			break;
	}
	wait 4;
	
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
		vehicles[i] connectpaths();
}

shield()
{
	self.health = 3000;
	while(1)
	{
		self waittill("damage");
		self.health = 3000;
	}
}

valley1_spawnertrigger()
{
	targ = getent(self.target,"targetname");
	spawners = getentarray(targ.target,"targetname");
	self waittill ("trigger");
	for(i=0;i<spawners.size;i++)
	{
		spawned = spawners[i] stalingradspawn();  //spawning in behind fade in screens
		spawned thread setBattleChatter( false );
		if(spawn_failed(spawned))
			continue;
		spawned thread gotonode(spawners[i]);
	}

}

valley1_drone (node,trigger)
{
	trigger waittill ("trigger");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp10", node, undefined, undefined,"xmodel/elalamein_drones_joints");
//	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp01", node, undefined, undefined,"xmodel/elalamein_drones_joints");
//	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp02", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp03", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp04", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp05", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp06", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp07", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp08", node, undefined, undefined,"xmodel/elalamein_drones_joints");
	thread maps\_drones::large_group("elalamein_drones_1stvalley_grp09", node, undefined, undefined,"xmodel/elalamein_drones_joints");
}

valley1_tank_fire_at_trench1 ()
{
	other = undefined;
	array_levelthread(getvehiclenodearray("fireattrench1","script_noteworthy"),::valley1_tank_fire_at_trench1_nodes);
	trenchclear = getent("cleared_first_trench","targetname");
	trenchclear endon ("trigger");
	trenchclear thread valley1_tank_fire_at_trench1_clear();
	for(i=0;i<2;i++)
	{
		level waittill ("fireattrench1",other);
		thread valley1_tank_fire_at_trench1_doing(other,trenchclear);
	}
}

valley1_tank_fire_at_trench1_nodes(node)
{
	node waittill ("trigger",other);
	level notify ("fireattrench1",other);
}

valley1_tank_fire_at_trench1_clear ()
{
	wait .5;
	while(1)
	{
		ai = getaiarray("axis");
		if(ai.size == 0)
			break;
		else
			wait .5;
	}
	self notify ("trigger");
	
}

valley1_tank_fire_at_trench1_doing (other,trenchclear)
{
	
	trenchclear endon ("trigger");
	other endon ("death");
	thread valley1_tank_fire_at_trench1_cleared(trenchclear,other);
	other setspeed (0,15);
	waittime = 1;
	while(1)
	{
		badplace_arc("", waittime, other.origin, 600, 500, anglestoforward(other.angles), 10, 10);
		wait waittime;
	}
}

valley1_tank_fire_at_trench1_cleared (trigger,other)
{
	trigger waittill ("trigger");
	level notify ("trench1 cleared");
	other.script_turret = 0;
	other resumespeed (15);
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		ai[i] setgoalentity(level.player);
		if(ai[i] == level.price)
			continue;
		ai[i].followmin = 0;
		ai[i].followmax = 2;
	}
}

dummytanks (groupnum)  // called from elalamein_anim.gsc
{
	wait .4;
	if(groupnum == "elalamein_drones_1stvalley_grp10")
	{
		tank = getent(groupnum,"targetname");
		tank thread squad_follow (self);
	}
	else
	{
		self thread tread("tag_wheel_back_left","back_left"); 
		self thread tread("tag_wheel_back_right","back_right"); 
	}
}

squad_follow (leader)
{
	leader hide();
	self.tanksquadfollow = true; 
	self endon ("breaksquad");
	self endon ("death");
	leader endon ("death");
	maxspeed = 20; // for testing and Libya should go somewhere else (like in vehiclesettings.gdt)
	mindist = 100; // distance to try and be within from the tank
	maxdist = 300; // distance at which tank will drive at it's maxspeed to catch up
	self.avoidresumespeed = 5;
	rangedist = maxdist-mindist;
	while(1)
	{
		leaderspeed = 12;
		rangespeed = (maxspeed - leaderspeed);
		dist = distance(self.origin,leader.origin);
		forwardvec = anglestoforward(flat_angle(leader.angles));
		normalvec = vectorNormalize(self.origin-leader.origin);
		vectordotup = vectordot(forwardvec,normalvec);
		if(vectordotup > 0)
		{
			speed = 10;
			msg = "ahead of position";
			self maps\_vehicle::vehicle_setspeed(speed,5,"squad: "+msg);
			thread maps\_vehicle::squad_debugline(leader,1,0,0,speed,msg,leader);

		}
		else if(dist < mindist)
		{
			speed = leaderspeed;
			msg = "matching speed";
			self maps\_vehicle::vehicle_setspeed(speed,55,"squad: "+msg);
			thread maps\_vehicle::squad_debugline(leader,1,1,0,speed,msg,leader);
		
		}
		else if(dist > mindist && dist < maxdist)
		{
			speed = ( ( (dist-mindist)/rangedist)   *   (maxspeed-rangespeed) )+leaderspeed;
			msg = "speeding up";
			self maps\_vehicle::vehicle_setspeed(speed,55,"squad: "+msg);
			thread maps\_vehicle::squad_debugline(leader,1,1,0,speed,msg,leader);

		}
		else if (dist > maxdist)
		{
			msg = "fullspeed";
			speed = maxspeed;
			self maps\_vehicle::vehicle_setspeed(speed,55,"squad: "+msg);
			thread maps\_vehicle::squad_debugline(leader,0,1,0,speed,msg,leader);
		}
		wait randomfloat(.7)+.3;		
	}
	
	maps\_vehicle::script_resumespeed("squade leader dead",level.resumespeed);
}

tread (tagname, side, relativeOffset)  // for the drones
{
	self endon ("death");
	treadfx = level._effect["crusader"]["sand"];
	switch(getcvarint("scr_elalamein_fxlevel"))
	{
		case 0:
		waittime = 1.65; break;
		case 1:
		waittime = 1.25; break;
		case 2:
		waittime = .65; break;
		default:
		waittime = .65; break;
	}
	
	for (;;)
	{
			wait waittime;
			playfx (treadfx, self getTagOrigin(tagname), (2,0,.3) );
	}
}

objective_valleyfollow(objective)
{
	self endon ("stop_following_ai");
	self endon ("death");
	while(1)
	{
		objective_position(objective,self.origin);
		wait .1;	
	}
}

objectives(start)
{
	level waittill ("introscreen_complete");
	wait 1;
	
	thread objective_capture_elalamein();
	objectivemain = 0;
	objectiveflaks = 1;
	objectivefollowtanksset1 = 2;
	objectivefollowtanksset2 = 2;
	objectiveclearenemybarracks = 3;
	objectivesecurevillage = 4;
	objectivemeetprice = 5;
	objective_add(objectivemain, "active", &"ELALAMEIN_ASSIST_TANKS_SQUADS_IN", (-12479, -8118, 290));
	objective_current (objectivemain);
	if(start == "start")
		level waittill ("player over ridge");
	objective_state(objectivemain,"done");
	flak88s = sort_flaks(getentarray("flak88s","script_noteworthy"));
	level.enemyflak88s = flak88s;
	array_levelthread (flak88s,::flak88deathcheck);
	for(i=0;i<flak88s.size;i++)
	{
		flak88s[i] thread flak88position_nearest(i,objectiveflaks);
		flak88s[i] thread flak88positiondeathupdate(i,objectiveflaks);
//		objective_additionalposition(objectiveflaks, i,flak88s[i].origin);
	}

	if(start != "valley3" && start != "valley4")
	{
	
		objective_add(objectivefollowtanksset1,"active", &"ELALAMEIN_FOLLOW_THE_TANKS_ACROSS");
		objective_current(objectivefollowtanksset1);

		level.valley2tank thread objective_valleyfollow(objectivefollowtanksset1);
		level.valley2tank waittill ("stop_following_ai");
		
	}
	waittill_xpos(-4900);
	objective_state(objectivefollowtanksset1,"done");
	objective_add(objectiveflaks, "active", "", (5544, 8872, -944));
	objective_string(objectiveflaks,&"SCRIPT_ELIMINATE_THE_FLAK_88",level.enemyflak88s.size);
//	objective_icon(objectiveflaks,"objpoint_flak");
	objective_current (objectiveflaks);
	level notify ("flak_obective_refresh");
	
	if(start != "valley4")
	{
		getvehiclenode("valley3objectivefollow","script_noteworthy") waittill ("trigger",other);
		thread flag_ypos(-4900);
		objective_add(objectivefollowtanksset2,"active", &"ELALAMEIN_FOLLOW_THE_TANKS_ACROSS",other.origin);
		objective_current(objectivefollowtanksset2);

		other thread objective_valleyfollow(objectivefollowtanksset2);
		other waittill_any ("stop_following_ai","death");
		level waittill ("valley3midtank",other);
		for(i=0;i<2;i++)
		{
			other thread objective_valleyfollow(objectivefollowtanksset2);
			other waittill ("stop_following_ai");
		}
			
	}
	flag_wait("ypos_reached");	
	thread autoSaveByName("Crossed Second Valley");
	objective_state(objectivefollowtanksset2,"done");
	objective_current(objectiveflaks);  //potential for breaking maybe? flaks get blown up by tanks? I don't think so
	objective_string(objectiveflaks,&"SCRIPT_ELIMINATE_THE_FLAK_88",level.enemyflak88s.size);
	
	if(start !="valley4")
		level waittill ("flak crews cleared");
		
	objective_state (objectiveflaks, "done");
	wait 1;
	objective_add(objectiveclearenemybarracks, "active", &"ELALAMEIN_CLEAR_THE_ENEMY_BARRACKS", (-11312 , -8031, 313));
	objective_add(objectivesecurevillage, "invisible", &"ELALAMEIN_SECURE_THE_VILLAGE_USING", (-14309, -5761, 63));
	objective_current (objectiveclearenemybarracks);
	if(getcvar("start") != "valley4")
	{
		level waittill ("bombobjective",node);
		objective_position(objectiveclearenemybarracks,node.origin);
		
	}
	thread objectives_objective_barracks(objectivesecurevillage,objectiveclearenemybarracks);	
	level waittill ("valley4axisretreat");
	objective_state (objectivesecurevillage, "done");
	objective_add(objectivemeetprice, "active", &"ELALAMEIN_MEET_WITH_CAPTAIN_PRICE", getnode("radionode","targetname").origin);
	objective_current (objectivemeetprice);
	level waittill ("met with price");
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
		ai[i] delete();
	objective_state (objectivemeetprice, "done");
	level waittill ("radio done");	
	objective_state (objectivemain, "done");
	wait 1;
	maps\_endmission::nextmission();
}

objectives_objective_barracks(objectivesecurevillage,objectiveclearenemybarracks)
{
	if(getcvar("start") != "valley4")
		level waittill ("enemybarracks cleared");
	thread autoSaveByName("Cleared enemy barracks");
	objective_state (objectiveclearenemybarracks, "done");
	objective_state (objectivesecurevillage, "active");
	objective_current (objectivesecurevillage);

}

get_followtank_orgs(startfolloworg)
{
	followorgs = [];
	targ = getent(startfolloworg.target,"targetname");
	while(isdefined(targ))
	{
		followorgs[followorgs.size] = targ;
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
		
	}
	return followorgs;
}

valley2_gotank()
{
	level.valley2_gotank = false;
	self waittill ("trigger");
	level.valley2_gotank = true;
	level notify ("valley2_gotank");
}
valley2()
{
	followtanknode = getvehiclenode("aifollowvalley2start","script_noteworthy");
	valley2tankcoverchain = getnode("valley2tankcoverchain","targetname");

	followorgs = get_followtank_orgs(getent("valley2tankfollow","targetname"));

	getent("gotankvalley2","targetname") thread valley2_gotank();
	followtanknode waittill ("trigger",other);
	level.valley2tank = other;
	level notify ("player over ridge"); 
	thread autoSaveByName("Second Valley Tunnels");
	
	other maps\_vehicle::vehicle_setspeed(0,15,"wait for player");

	ai =getaiarray("allies");
	for(i=0;i<followorgs.size;i++)
	{
//		followorgs[i] thread print_followorgs(i);
		followorgs[i] linkto (other);
		
	}
	for(i=0;i<ai.size;i++)
		ai[i] thread ai_followtank_orgent(followorgs,i,other);
	valley2barragetrigger = getent("valley2barragetrigger","targetname");
	valley2barragetrigger thread valley2_barrage_optimize();
	valley2leftflankstop = getvehiclenodearray("valley2leftflankstop","script_noteworthy");
	
	if(!level.valley2_gotank)
		level waittill ("valley2_gotank");

	level.player setfriendlychain (valley2tankcoverchain);
	array_levelthread(valley2leftflankstop,maps\_vehicle ::path_gate_open);

	other tank_waitfor_ai();
	other maps\_vehicle::vehicle_setspeed(level.walkwithtankspeed,2,"wait for player");
//	other maps\_vehicle::script_resumespeed("donewaiting for player",10);
	maps\_vehicle::path_gate_open(getvehiclenode("valley2secondtankgate","script_noteworthy"));
	
	valley2guysstopfollow = getvehiclenode("valley2guysstopfollow","script_noteworthy");
	valley2guysstopfollow waittill ("trigger");
	thread autosavebyname("crossed second valley");
	other maps\_vehicle::script_resumespeed("done crossing the valley",10);
	other notify ("stop_following_ai");

	ai =getaiarray("allies");
	for(i=0;i<ai.size;i++)
		ai[i] setgoalentity (level.player);

}

valley2_barrage_optimize()
{
	self waittill ("trigger");
	assert(isdefined(self.script_timer));
	thread setfireloopmodfortime(level.smokethrowmod,self.script_timer);
}

ai_followtank_deathclearposition (ai,tank)
{
	if(!isdefined(tank.ai_notinposition))
		tank.ai_notinposition = 0;
	thread ai_followtank_inposition(ai,tank);
	tank endon ("death");
	ai waittill ("death");
	ai.followingorg.occupied = false;
}

ai_followtank_inposition(ai,tank)
{
	tank endon ("death");
	tank.ai_notinposition++;
	ai waittill ("set_tank_goal");
	ai waittill_any ("goal","death");
	tank.ai_notinposition--;
}

ai_followtank_end (ai)
{
	ai endon ("death");
	self waittill_any ("stop_following_ai","death");
	if(isdefined(ai) && isalive(ai))
	{
		ai allowedstances ("stand","crouch","prone");
		ai unset_forcegoal();
		ai.suppressionwait = ai.oldsuppressionwait;
		ai.goalradius = ai.oldgoalradius;
//		ai setgoalentity(level.player);
	}
}

ai_followtank_orgent(followorgs,position,tank,delay)
{
	level thread ai_followtank_deathclearposition(self,tank);
	tank thread ai_followtank_end(self);
	tank endon ("stop_following_ai");
	tank endon ("death");
	self endon ("death");
	followorgs[position].occupied = true;
	assertex(isdefined(followorgs[position]),"no followorg with position index: "+position);
	self.followingorg = followorgs[position];
	self.interval = 48;  //testing.. just leave the interval so guys can get around eachother in trenches
	self.oldsuppressionwait = self.suppressionwait;
	self.oldgoalradius = self.goalradius;
	self.suppressionwait = 0;
	self.goalradius = 8;
	self set_forcegoal();
	self.pathenemyfightdist = 512;
	self.pathenemylookahead = 512;
	self.maxsightdistsqrd = 1000;
	if(isdefined(delay))
		wait delay;
	while(1)
	{
		if(position != 0 && !(followorgs[position-1].occupied))
		{
			position--;
			self.followingorg = followorgs[position];
		}
		org = self.followingorg.origin;
		trace = bulletTrace((org + (0,0,100)), (org - (0,0,800)), false, undefined);
		self setGoalPos (trace["position"]);
		self notify ("set_tank_goal");
		wait .7;
	}
}

triggerchase(position)
{
	level.price teleport (getent(position.targetname,"target").origin);
	level.price setgoalentity (level.player);
	
	level.player setorigin (position.origin);
	level.player setplayerangles(position.angles);
	if(isdefined(position.target))
		targ = getent(position.target,"targetname");
	else
		targ = undefined;
	while(isdefined(targ))
	{
		wait .2;
		level.player setorigin (targ.origin);
		level.player setplayerangles(targ.angles);
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
	}
	wait 1;
	if(isdefined(position.script_linkTo))
	{
		links = strtok( position.script_linkTo, " " );
		linkMap = [];
		for ( i = 0; i < links.size; i++ )
			linkMap[links[i]] = true;
		links = undefined;
		flaks = getlinks_array(level.enemyflak88s,linkmap);
		for(i=0;i<flaks.size;i++)
			flaks[i] notify ("death");
	}
}

cavemortars_go(mortar)
{
	fPower = 0.15;
	iTime = 1;
	iRadius = 1850;
	thread playsoundinspace ("distant_explosion_triggered", mortar.origin + (0,0,256));
	earthquake(fPower, iTime, mortar.origin, iRadius);
	wait .1;
	playfx(level._effect["tunneldust"]	, mortar.origin);
	thread playsoundinspace ("ceiling_debris", mortar.origin);
	wait .2;
	mortar notify ("mortar");
	level notify ("mortar");
}


flak88position_nearest(position,objectiveflaks)
{
	self endon ("death");
	self endon ("flakai_cleared");
	while(1)
	{
		if(isclosest_flak())
			objective_additionalposition(objectiveflaks, position,self.origin);
		else
			objective_additionalposition(objectiveflaks, position,(0,0,0));
	
		level waittill_any ("a_flak_died","flak_obective_refresh");
		wait .1;
	}
}

flak88positiondeathupdate(position,objectiveflaks)
{
	self waittill_any ("death","flakai_cleared");
	level.enemyflak88s = array_remove(level.enemyflak88s,self);
	objective_additionalposition(objectiveflaks, position,(0,0,0));
	if(level.enemyflak88s.size)
		objective_string(objectiveflaks,&"SCRIPT_ELIMINATE_THE_FLAK_88",level.enemyflak88s.size);
	else
		objective_string(objectiveflaks,&"SCRIPT_ELIMINATE_THE_FLAK_88_DONE");
		
}

flak88deathcheck(flak88)
{
	flak88 waittill_any ("death","flakai_cleared");
	level notify ("a_flak_died");
	level.enemyflak88s = array_remove(level.enemyflak88s,flak88);
	thread autosavebyname("Eliminated flak crew");
	if(!level.enemyflak88s.size)
		level notify ("flak crews cleared");  // for ugbunker	
}
																																																																																																																																																	
keepmovingai(trigger)
{
	while(1)
	{
		trigger waittill ("trigger");
		axis = getaiarray("axis");
		for(i=0;i<axis.size;i++)
		{
			axis[i].accuracy = 0;
		}
		ai = getaiarray("allies");
		for(i=0;i<ai.size;i++)
		{
			if(!isdefined(ai[i].isinkeepmovingtrigger))
				ai[i] thread keepMovingWhileIntrigger(trigger);
			else if(!(ai[i].isinkeepmovingtrigger))
				ai[i] thread keepMovingWhileIntrigger(trigger);	
			
		}
		wait .2;
	}
}

keepMovingWhileIntrigger(trigger)
{
	self endon ("death");
	if(!(self istouching (trigger)))
		return;
	self clearEnemyPassthrough();
//	self.team = "neutral";
	self.ignoreme = true;
	self.dontavoidplayer = true;
	self.isinkeepmovingtrigger = true;
	while(self istouching (trigger))
		wait .05;
	self.ignoreme = false;
	self.dontavoidplayer = false;
	self.isinkeepmovingtrigger = false;
	
}

print_followorgs(i)
{
	while(1)
	{
		print3d(self.origin,i,(1,1,1),1,2);
		wait .05;
	}
}



mg42mod(ent)
{
/*
	if(isdefined(ent.script_delay_min))
	if(isdefined(ent.script_delay_max))
	if(isdefined(ent.script_burst_max))
	if(isdefined(ent.script_burst_min))
	if(isdefined(ent.convergencetime))
*/
	vehicle = maps\_vehicle::waittill_vehiclespawn(ent.target);
	for(i=0;i<vehicle.mgturret.size;i++)
	{
		vehicle.mgturret[i].convergencetime = 8;
		vehicle.mgturret[i].accuracy = .2;
		
	}
}

valley3_tank2folllow(followorgs,firsttank)
{	 
	aifollowvalley3_1end = getvehiclenode("aifollowvalley3_1end","script_noteworthy");

	followtanknode = getvehiclenode("aifollowvalley3_1start","script_noteworthy");
	followtanknode waittill ("trigger",other);
	
	other maps\_vehicle::vehicle_setspeed(0,5,"wait for player");
	level notify ("valley3midtank",other);
	if(isdefined(firsttank) && firsttank.health > 0)
		firsttank waittill ("death");

	ai = getaiarray("allies");

	for(i=0;i<followorgs.size;i++)
	{
//		followorgs[i] thread print_followorgs(i);
		followorgs[i] linkto (other);
	}
	for(i=0;i<ai.size;i++)
		ai[i] thread ai_followtank_orgent(followorgs,i,other);	
	
	other tank_waitfor_ai();
	other maps\_vehicle::vehicle_setspeed(level.walkwithtankspeed,5,"wait for player");

	level.valley3_tank2followorgs = followorgs;
	level.valley3_tank2folllow = true;
	
	valley3_3tankcoverchain = getent("valley3_3tankcoverchain","targetname");
//	for(i=0;i<followorgs.size;i++)
//		followorgs[i] delete();
		
	followorgs = get_followtank_orgs(valley3_3tankcoverchain);
	aifollowvalley3_3start = getvehiclenode("aifollowvalley3_3start","script_noteworthy");
	aifollowvalley3_3start waittill ("trigger");
	other notify ("stop_following_ai");
	ai =getaiarray("allies");
	for(i=0;i<followorgs.size;i++)
	{
//		followorgs[i] thread print_followorgs(i);
		followorgs[i] linkto (other);
	}
	for(i=0;i<ai.size;i++)
		ai[i] thread ai_followtank_orgent(followorgs,i,other);		
	
	aifollowvalley3_1end waittill ("trigger",other);
	other notify ("stop_following_ai");
	other maps\_vehicle::script_resumespeed("done crossing the valley",10);

	
	ai =getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		if(ai[i] == level.price && ai[i].goal_commit)
			continue;
		ai[i] setgoalentity (level.player);
	}
		
	if(!level.flag["valley3crossed"])
		level.player setfriendlychain (getnode("valley3friendchain","targetname"));
	
}

valley3_gotankvalley3()
{
	level.gotankvalley3 = false;
	self waittill ("trigger");
	level.gotankvalley3 = true;
	level notify ("gotankvalley3");
	
}

valley3()
{
	thread valley3_dialog();
	level.valley3_tank2folllow = false;
	followtanknode = getvehiclenode("aifollowvalley3start","script_noteworthy");
	valley2tankcoverchain = getent("valley3tankcoverchain","targetname");
	valley3_2tankcoverchain = getent("valley3_2tankcoverchain","targetname");
	followorgs = get_followtank_orgs(valley2tankcoverchain);
	followorgs2 = get_followtank_orgs(valley3_2tankcoverchain);
	getent("gotankvalley3","targetname") thread valley3_gotankvalley3();
	followtanknode waittill ("trigger",other);
	level notify ("valley3start",other);
	other.deathdamage_max = 120;
	other.deathdamage_min = 50;	
	thread autoSaveByName("Following Tanks");
	thread valley3_tank2folllow(followorgs2,other);
	other maps\_vehicle::vehicle_setspeed(0,15,"wait for player");


	ai =getaiarray("allies");
	for(i=0;i<followorgs.size;i++)
	{
//		followorgs[i] thread print_followorgs(i);
		followorgs[i] linkto (other);
		
	}
	for(i=0;i<ai.size;i++)
	{
		ai[i].chainfallback = true;		
		ai[i] thread ai_followtank_orgent(followorgs,i,other,randomfloat(2));
	}

	array_levelthread( getspawnerarray(), ::chainfallback_onspawn);
	
	if(!level.gotankvalley3)
		level waittill("gotankvalley3");

	other tank_waitfor_ai();
	other maps\_vehicle::vehicle_setspeed(level.walkwithtankspeed,5,"wait for player");
//	other maps\_vehicle::script_resumespeed("donewaiting for player",10);
}

tank_waitfor_ai()
{
	timer = gettime()+3000;
	while(self.ai_notinposition && gettime()<timer)
		wait .05;
}

chainfallback_onspawn(spawner)
{
	spawner waittill ("spawned", spawn);
	if (!spawn_failed(spawn))
	{
		waittillframeend;
		if(spawn.team == "allies")
			spawn.chainfallback = true;		
	}
}
valley3_dialog()
{
	level.valley3dialoghit = false;
	getent("valley3_dialog","targetname") waittill ("trigger");
	level notify ("valley3_dialog");
	level.valley3dialoghit = true;
	level.price dialog_add("alamein_prc_holdup",0);
	level.price dialog_add("alamein_prc_acrossthisvalley",3);
	
}

price_goto_trigger()
{
	targnode = getnode(self.target,"targetname");
	level endon ("valley3_to_valley4");
	while(1)
	{
		self waittill ("trigger");
		level.price.goalradius = 128;
		level.price setgoalnode(targnode);
	}
}

valley3_to_valley4()
{
	//undergroung bunker 
	//ugbunker prefab stuff
	ugbunkertrigger1 = getent("ugbunkertrigger1","targetname");
	ugbunkertrigger2 = getent("ugbunkertrigger2","targetname");
	ugbunkertrigger1 thread price_goto_trigger();
	ugbunkertrigger2 thread price_goto_trigger();
	ugbunkerdoor1model = getent("ugbunkerdoor1","script_noteworthy");
	ugbunkerdoor2model = getent("ugbunkerdoor2","script_noteworthy");
	ugbunkerdoor1 = getent(ugbunkerdoor1model.target,"targetname");
	ugbunkerdoor2 = getent(ugbunkerdoor2model.target,"targetname");
	ugbunkerdoor1 disconnectpaths();
	ugbunkerdoor2 disconnectpaths();
	bunkerspawners = getentarray("bunkerspawners","script_noteworthy");
	level waittill ("flak crews cleared");
	lastflakchain = getnode(getent("lastflakchain","targetname").target,"targetname");
	level.player setfriendlychain(lastflakchain);

	/// all the ai run to the chain in reverse order	
	ai = getaiarray("allies");
	nodes = get_lastflakchain_reversed(lastflakchain);
	if(ai.size > nodes.size)
		num = nodes.size;
	else
		num = ai.size;
	for(i=0;i<num;i++)
	{
		if(ai[i] == level.price)
			continue;
		ai[i].goalradius = 12;
		ai[i] setgoalnode (nodes[i]);
	}
		

	level.price dialog_add("alamein_prc_clearoutbarracks",2);
	for(i=0;i<bunkerspawners.size;i++)
		bunkerspawners[i] notify ("trigger");
	waittillframeend;
	getent("bunkerarea","script_noteworthy") thread bunkerobjectiveclear();
	getent("bunkerflee","script_noteworthy") notify ("trigger");  // make guys flee from gunner positions

	thread valley3_to_valley4_bombandrun_triggger(ugbunkertrigger1);
	thread valley3_to_valley4_bombandrun_triggger(ugbunkertrigger2);

//	level.price setgoalentity(level.barneyorg);
	level.price.goalradius = (64); //get closer
	level waittill ("valley3_to_valley4",other);
	
	nodes = [];
	nodes[nodes.size] = getnode(ugbunkertrigger1.target,"targetname");
	nodes[nodes.size] = getnode(ugbunkertrigger2.target,"targetname");
	
	closernode = getclosest(level.player.origin,nodes);
	if(isdefined(closernode.radius))
		level.price.goalradius = 32;
	level.price.goal_commit = true;
	level.price setgoalnode(closernode);
	if(other == ugbunkertrigger1)
		thread valley3_to_valley4_bombandrun(level.price,ugbunkertrigger1,ugbunkerdoor1,ugbunkerdoor1model);
	else if(other == ugbunkertrigger2)
		thread valley3_to_valley4_bombandrun(level.price,ugbunkertrigger2,ugbunkerdoor2,ugbunkerdoor2model);
	level waittill ("valley3_to_valley4_blown");
//	level.player setfriendlychain(getnode("ugbunkerchain","targetname"));
	trigger = getent("ugbunkerchain","target");
	trigger waittill("trigger");
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
		ai[i] setgoalentity(level.player);
}

valley3_to_valley4_bombandrun(guy,trigger,door,doormodel)
{
	node = getnode(trigger.target,"targetname");
	level notify ("bombobjective",node);
	level.price.goalradius = 4;
	level.price.old_pathEnemyFightDist = level.price.pathEnemyFightDist;
	level.price.pathEnemyFightDist = 32;
	level.price setGoalNode (node);
	level.price waittill ("goal");
	level.price.goal_commit = false;
	level.price thread Plant_Explosives_Notes();
	level.price animscripts\shared::PutGunInHand("none");
	offset = (0,0,0);
	level.price animscripted("plantexplosives", node.origin, (node.angles + offset), level.scr_anim["plantbomb"]["flak"]);
	
	badplace_node = getent ("flak1badplace","targetname");
	badplace_cylinder("bpFlak1", -1, door.origin, 100, 200);

	level.price waittillmatch ("plantexplosives","end");
	level.price animscripts\shared::PutGunInHand("right");
	door playSound( "explo_plant_no_tick" );
	door playLoopSound( "bomb_tick" );

//	level.price setgoalentity (level.player);
	level.price.goalradius = 96;
	level.price setgoalpos ((-10643,-8514,390));
		
	stopwatch = maps\_utility::getstopwatch(60,5);
	wait 5;
	stopwatch destroy();
	door stopLoopSound( "bomb_tick" );

	badplace_delete("bpFlak1");
	level.price.goalradius = 512;
	level.price.pathEnemyFightDist = level.price.old_pathEnemyFightDist;
	origin = level.ugdoorbomb.origin;
	level.ugdoorbomb delete();
	earthquake(0.25, 3, door.origin, 1050);
	door playsound ("explo_plant_rand");
	level.player enableHealthShield( false );
	radiusDamage (node.origin, 250, 300, 100);
	level.player enableHealthShield( true);

	doormodel linkto (door);
	level notify ("valley3_to_valley4_blown");
	exploder(1);
	doormodel setmodel("xmodel/prop_door_metal_bunker_damaged");
	doormodel playsound ("explo_metal_rand");
	door rotateyaw(89, 0.4,0.05,0.05);
	wait 2;
	door connectpaths();
}

valley3_to_valley4_bombandrun_triggger(trigger)
{
	trigger waittill ("trigger");
	level endon ("valley3_to_valley4");
	level notify ("valley3_to_valley4",trigger);
}

autoclearflaks(trigger)
{
	trigger waittill ("trigger");
	links = strtok( trigger.script_linkTo, " " );
	linkMap = [];
	for ( i = 0; i < links.size; i++ )
		linkMap[links[i]] = true;
	links = undefined;
	flaks = getlinks_array(level.enemyflak88s,linkmap);
	for(i=0;i<flaks.size;i++)
		flaks[i] notify ("death");
}

start_dialog(start)
{
	wait 5;
	switch(start)
	{
		case "start":
		wait .1;
		level.price dialog_add("alamein_prc_sixpertank",0);
		level.price dialog_add("alamein_prc_cmonboys",.2);
		level.price dialog_add("alamein_prc_staywithtanks",1);
		level waittill ("trench1 cleared");
		level.price dialog_add("alamein_prc_thruthistunnel",1);
		case "valley2":
		level waittill ("timed barrage");
		level.price dialog_add("alamein_prc_holdforartillery",0);
		level.price dialog_add("alamein_prc_waitforguns",2);
		level waittill ("timed barrage finished");
		wait .5;
		level.price dialog_add("alamein_prc_thisisit",2);
		level.price dialog_add("alamein_prc_usetankscover",2);
		level.price dialog_add("alamein_prc_gettotrenchline",3);
	//	level.price dialog_add("alamein_prc_thisisit",2);
		case "valley2mid":
	}
//	battlechatteron("allies");
}

pricechat (trigger)
{
	switch(trigger.script_noteworthy)
	{
		case "flak88":
		case "mgnest":
			trigger thread pricechat_trigger_trigger(trigger.script_noteworthy);
			break;
		case "keepmoving_west":
			trigger thread pricechat_keepmoving_west();
			break;
		case "minefields":
			trigger thread pricechat_mine();
			break;
		case "alamein_prc_getintobunker":
			trigger thread pricechat_once(trigger.script_noteworthy);
			break;
	}
}

pricechat_once (dialog)
{
	self waittill ("trigger");
	level.price dialog_add(dialog,0);
}

pricechat_keepmoving_west ()
{
	while(1)
	{
		disttraveledwest = 0;
		self waittill ("trigger");
		originalorigin = level.player.origin;
		samplecounts = 5;
		lastorg = level.player.origin[0]+64;
		samples = [];
		newsamples = [];
		totaldist = 0;
		for(i=0;i<samplecounts;i++)
		{
			samples[i] = 64;
			totaldist+= samples[i];
		}
		while(level.player istouching(self))
		{
			thisdisttraveledwest = -1*(level.player.origin[0] -lastorg);
			disttraveledwest = -1*(level.player.origin[0] - originalorigin[0]);
			totaldist+=thisdisttraveledwest;
			newsamples = [];
			newsamples[0] = thisdisttraveledwest;
			totaldist-=samples[samples.size-1];
			for(i=0;i<samples.size-1;i++)
				newsamples[newsamples.size] = samples[i];
			samples = newsamples;
			average = totaldist/samplecounts;
			if(average < 40)
				level notify ("pricechat","keepmoving_west");
			lastorg = level.player.origin[0];
			wait 1;
		}
	}
}

pricechat_mine ()
{
	while(1)
	{
		self waittill ("trigger");
		level notify ("pricechat","minefields");
	}
}

pricechat_trigger_trigger (type)
{
	getent(self.target,"targetname") waittill ("trigger");
	otherarray = [];
	mergearray = [];
	dochat = true;
	while(1)
	{
		self waittill ("trigger",other);
		if(other == level.player || (isdefined(other.team) && other.team != "axis"))
		{
			self notify ("chat_kill");
			break;			
		}
		dochat = true;
		mergearray[0] = other;
		for(i=0;i<otherarray.size;i++)
		{
			if(other == otherarray[i])
				dochat = false;
		}
		if(dochat)
		{
			otherarray = array_merge(otherarray,mergearray);
			other thread pricechat_trigger_trigger_chattrace(self,type);
		}
	}
}

pricechat_trigger_trigger_chattrace(trigger,type)
{
	trigger endon ("chat_kill");
	self endon ("death");
	while(1)
	{
		trace = bullettrace(level.price geteye(),self geteye(),false,level.price);
		if(trace["fraction"] == 1 && self istouching(trigger))
			level notify ("pricechat",type);
		wait .5;
	}
}

enemy_retreat_trigger (trigger)
{
	enemyarea = getent(trigger.target,"targetname");
	if(isdefined(trigger.count))
	{
		if(trigger.count == 0)
			count = 3;
		else
			count = trigger.count;
	}
	else
		count = 3;
	trigger waittill ("trigger");
	ai = getaiarray("axis");
	enemyarea.intriggerai = [];
	targetnodes = getnodearray(enemyarea.target,"targetname");
	for(i=0;i<ai.size;i++)
		if(ai[i] istouching (enemyarea))
		{
			ai[i] thread enemy_retreat_death(enemyarea);
			enemyarea.intriggerai[enemyarea.intriggerai.size] = ai[i];
		}
	while(enemyarea.intriggerai.size > count)
		enemyarea waittill ("deadguy");
	if(isdefined(enemyarea.radius) && isdefined(enemyarea.height))
		badplace_cylinder("", 2, enemyarea.origin, enemyarea.radius, enemyarea.height);
	for(i=0;i<enemyarea.intriggerai.size;i++)
	{
		if(!isdefined(targetnodes[i]))
			continue;
		enemyarea.intriggerai[i].goalradius = 32;
		enemyarea.intriggerai[i] setgoalnode(targetnodes[i]);
	}
}

enemy_retreat_death (enemyarea)
{
	self waittill ("death");
	enemyarea.intriggerai = array_remove(enemyarea.intriggerai,self);
	enemyarea notify ("deadguy");
}

smokethrowtrig (trigger)
{
	node = getnode(trigger.target,"targetname");
	trigger waittill ("trigger",other);
	assertEX(isalive(other),"other.classname is"+other.classname);
	if(other != level.price)
		other thread magic_bullet_shield();
	thread setfireloopmodfortime(level.smokethrowmod,55);
	other checkForSmokeHint(node);
	if(other != level.price)
		other notify ("stop magic bullet shield");
	trigger delete();
}

setfireloopmodfortime_fxoverride(dustfx)
{
	level._effect["crusader"]["dirt"] = dustfx;
	level._effect["crusader"]["sand"] = dustfx;
	level._effect["crusader"]["mud"] = dustfx;

	level._effect["blitz"]["dirt"] = dustfx;
	level._effect["blitz"]["sand"] = dustfx;
	level._effect["blitz"]["mud"] = dustfx;
}

setfireloopmodfortime(mod,time)
{
	setfireloopmodfortime_fxoverride(level._effect["dustfx_low"]);
	timer = gettime()+(time*1000);
	while(gettime()<timer)
	{
		if(level.fxfireloopmod == 1)
			maps\_fx::setfireloopmod(mod);
		wait .05;
	}
	setfireloopmodfortime_fxoverride(level._effect["dustfx"]);
	maps\_fx::setfireloopmod(1);
}

valley4 ()
{
	thread valley4_dialog();
	valley4friendchaintrigger = getent("valley4friendchain","targetname");
	valley4friendchain = getnode(valley4friendchaintrigger.target,"targetname");
	getvehiclenode("valley4trigger","script_noteworthy") waittill ("trigger"); // asigned to a vehicles start node.
	thread autoSaveByName("Entering Village");
	level notify ("enemybarracks cleared");
	level notify ("roofmg42s");
	thread valley4_wave2();
	wait 10;
	level.player setfriendlychain(valley4friendchain);
}

valley4_dialog ()
{
	trigger = getent("valley4_dialog","targetname");
	level.schrecks = 0;
	allschrecks = getentarray("weapon_panzerschreck","classname");
	for(i=0;i<allschrecks.size;i++)
	{
		if((isdefined(allschrecks[i].script_noteworthy) && allschrecks[i].script_noteworthy == "houseschreck") || allschrecks[i].origin[2]<-200)  //hack.. panzerschreck in geo file that's unavailable to me.
			continue;
		allschrecks[i] thread schreck_countdown();
	}
	
	trigger waittill ("trigger");
	level.price dialog_add("alamein_prc_rallypoint",0);
	level.price dialog_add("alamein_prc_clearbuildings",4);
//	level.price dialog_add("alamein_prc_enemypanzers",7);
//	level.price waittill ("que finished");
//	wait 10;
//	while(level.schrecks)
//	{
//		level notify ("pricechat","panzerschrecks");
//		timer = gettime()+25000;
//		while(gettime()<timer && level.schrecks)
//			wait .5;
//	}
//	vehicles_spawnandgo(11); // tanks to the rescue
	
	
	
}

valley4_wave2 ()
{
	for(i=0;i<2;i++)
		level waittill ("wave1death");
	vehicles_spawnandgo(10);
}

objective_tank(objective)
{
	self.objective_index = level.tanksobjective_index;
	level.tanksobjective_index++;
	self endon ("death");
	while(1)
	{
//		objective_additionalposition(objective,self.objective_index,self.origin);
		wait .1;	
	}
}

wave1death (trigger)
{
	trigger waittill ("trigger",other);  // these guys are in god mode so it doesn't matter that this stuff happens on this node
	other thread objective_tank(0);
	other waittill ("death");
//	objective_additionalposition(0,other.objective_index,(0,0,0));
	level notify ("wave1death");
	level notify ("valley4death");
}

wave2death (trigger)
{
	trigger waittill ("trigger",other);  // these guys are in god mode so it doesn't matter that this stuff happens on this node
	other thread objective_tank(0);
	other waittill ("death");
//	objective_additionalposition(0,other.objective_index,(0,0,0));
	level notify ("wave2death");
	level notify ("valley4death");
}

clearque (trigger)
{
	trigger waittill ("trigger",other);
	other.enemyque = [];
}

noattackback (trigger)
{
	trigger waittill ("trigger",other);
	other.attackback = false;
}

bunkerobjectiveclear ()
{
	level endon ("enemybarracks cleared");
	while(1)
	{
		ai = getaiarray("axis");
		aitouching = false;
		for(i=0;i<ai.size;i++)
		{
			if(ai[i] istouching (self))
			{
				aitouching = true;
				break;	
			}
		}
		if(!aitouching)
			break;
		wait .5;
	}
	level notify ("enemybarracks cleared");
	if(randomint(100) < 50)
		level.price dialog_add("alamein_prc_ontotherallypoint",0);
	else
		level.price dialog_add("alamein_prc_ontothevillage",0);
}

radio_init()
{
	if(int(self getorigin()[1]) == -5749)
		self.origin = (-20,20,0); // hack.. avoiding long recompile by moving trigger forward on the table
	if(int(self getorigin()[1]) == -5717)
		self.origin = (-15,0,0); // hack.. avoiding long recompile by moving trigger forward on the table
	self triggeroff();
	self sethintstring(&"SCRIPT_PLATFORM_HINT_USERADIO"); // maybe make a new string for elalamein.
	
}

objective_capture_elalamein ()
{
	radio_obj_trigger = getentarray("radio_obj_trigger","targetname");
	radio_obj_model = getentarray("radio_obj_model","targetname");
	array_thread(radio_obj_trigger,::radio_init);
	for(i=0;i<radio_obj_model.size;i++)
		radio_obj_model[i] hide();
	housespawners = getent("housespawners","targetname");
	housespawners spawnergrab();  // waits till spawned guys come out and die
	level notify ("valley4axisretreat");
	thread objective_capture_radio(radio_obj_model,radio_obj_trigger);
}

endflee(node)
{
	self thread ai_fadefromview();
	self endon ("death");
	wait randomfloat(2);
	self setgoalnode(node);
}

ai_fadefromview ()  // magically get rid of ai's who are in old zones.
{
	self endon ("death");
	timing = 3000;
	timer = gettime()+timing;
	self thread ai_magic_snipe();
	while(gettime()< timer)
	{
		forwardvec = anglestoforward(level.player.angles);
		othervec = vectorNormalize(self.origin-level.player.origin);
		dot = vectordot(forwardvec,othervec); 
		if(dot > .26)
		{
			timer = gettime()+timing;
			wait .05;
		}
		else
			wait .05;
	}
	self delete();
}

ai_magic_snipe()
{
	self endon ("death");
	wait randomfloatrange(0,2);
	magicbullet("enfield", self.origin+vectormultiply(anglestoforward(self.angles),2000)+(0,0,1200),self gettagorigin("J_Neck"));
	wait .3;
	magicbullet("enfield", self.origin+vectormultiply(anglestoforward(self.angles),2000)+(0,0,1200),self gettagorigin("J_Neck"));
	wait 3;
	self delete();
}

radio_triggers()
{
	level endon ("radio_triggered");
	self triggeron();
	self waittill ("trigger");
	level notify ("radio_triggered");	
}

objective_capture_radio (radio_obj_model,radio_obj_trigger)
{
	array_thread(getaiarray("axis"),::endflee,getnode("endflee","targetname"));
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
		ai[i].ignoreme = true;
	level.player.ignoreme = true;
	radiospeaker = getent("radiospeaker","targetname");
//	radiotrigger = getent("radiotrigger","targetname");
	radionode = getnode("radionode","targetname");
	thread endstopalltrucks();
	while(getaiarray("axis").size)
		wait .1;
	level.price dialog_add("alamein_prc_wirelessradio",0);
	level.price waittill ("que finished");	
	
	array_thread(radio_obj_trigger,::radio_triggers);
	for(i=0;i<radio_obj_model.size;i++)
		radio_obj_model[i] show();

	thread endstand();
	thread endkillallenemytanks();
	level waittill ("radio_triggered");

//	radiotrigger waittill ("trigger");
	
	for(i=0;i<radio_obj_model.size;i++)
		radio_obj_model[i] delete();
	for(i=0;i<radio_obj_trigger.size;i++)
		radio_obj_trigger[i] delete();
	
	array_thread(getaiarray("axis"),::deleteme);
	radiospeaker playsound ("alamein_hqr_bloodyfinework","sounddone");
	radiospeaker waittill ("sounddone");
	level.price.goalradius = 4;
	node = getnode("endpricestand2","targetname");
	level.price setgoalnode(getnode("endpricestand2","targetname"));
	level.price.anim_node = node;
	level.price waittill ("goal");
	level.price dialog_add("alamein_prc_welldoneboys",0);
	level.price waittill ("que finished");
	level.price stopanimscripted();
	level.price.anim_node = undefined;
	level notify ("met with price");
	wait 4;
	level notify ("radio done");	
}

deleteme()
{
	self delete();
}

pricechat_handle ()
{
	timer = gettime();
	lasttype = "none";

	type = "minefields";
	dialogarray[type] = [];	
	array = [];
	array[array.size] = "alamein_prc_minefields";
	array[array.size] = "alamein_prc_minesupahead";
	array[array.size] = "alamein_prc_lookforsigns";
	array[array.size] = "alamein_prc_watchformines";
	array[array.size] = "alamein_prc_carefulminefields";
	dialogarray[type] = array;
	workingdialogarray[type] = dialogarray[type];

	type = "flak88";
	dialogarray[type] = [];	
	array = [];
	array[array.size] = "alamein_prc_silencegun";
	array[array.size] = "alamein_prc_takeoutantitank";
	array[array.size] = "alamein_prc_silenceantitankgun";
	array[array.size] = "alamein_prc_eliminateposition";	
	dialogarray[type] = array;
	workingdialogarray[type] = dialogarray[type];
	
	type = "mgnest";
	dialogarray[type] = [];	
	array = [];
	array[array.size] = "alamein_prc_knockoutmg";
	array[array.size] = "alamein_prc_machinegun";
	array[array.size] = "alamein_prc_grenademg";
	array[array.size] = "alamein_prc_pineapple";	
	dialogarray[type] = array;
	workingdialogarray[type] = dialogarray[type];
	
	type = "keepmoving_west";
	dialogarray[type] = [];	
	array = [];
	array[array.size] = "alamein_prc_mortars";
	array[array.size] = "alamein_prc_move";
	array[array.size] = "alamein_prc_stopyouredead";
	array[array.size] = "alamein_prc_nostopping";	
	dialogarray[type] = array;
	workingdialogarray[type] = dialogarray[type];
	
	type = "panzerschrecks";
	dialogarray[type] = [];	
	array = [];
	array[array.size] = "alamein_pri_schrecktrench1";
	array[array.size] = "alamein_pri_schrecktrench2";
	dialogarray[type] = array;
	workingdialogarray[type] = dialogarray[type];
		
	
	while(1)
	{
		level waittill ("pricechat",type);
		if(gettime()>timer || type != lasttype && !level.price.dialogque.size)
		{
			randnum = randomint(workingdialogarray[type].size);
			level.price dialog_add(workingdialogarray[type][randnum],0);
			workingdialogarray[type] = array_remove(workingdialogarray[type],workingdialogarray[type][randnum]);
			if(!workingdialogarray[type].size)
				workingdialogarray[type] = dialogarray[type];
			timer = gettime()+10000+randomint(3000);
		}
		else
			wait .05;
		lasttype = type;
	}
}



Plant_Explosives_Notes()
{
	self attach("xmodel/military_tntbomb","tag_weapon_right");
	for (;;)
	{
		self waittill ("plantexplosives", notetrack);
		switch (notetrack)
		{
			case "end":
			case "release bomb from hands":
				self detach("xmodel/military_tntbomb","tag_weapon_right");
				org = self gettagOrigin("tag_weapon_right");
				ang = self gettagangles("tag_weapon_right");
				ang = (0,ang[1],ang[2]);
				level.ugdoorbomb = spawn("script_model", org);
				level.ugdoorbomb.angles = ang;
				level.ugdoorbomb playsound("detpack_plant");
				level.ugdoorbomb setModel ("xmodel/military_tntbomb");
				return;
		}
	}
}

ai_barneyfollow_org ()
{
	level.barneyorg = spawn("script_origin",level.player.origin);
	level.barneyorg linkto (level.player);
}


tankduster()
{
	node = getvehiclenode(self.target,"targetname");
	node waittill ("trigger",other);
	other.rumble_scale = .25;
	other.rumble_radius = 700;
	while(other.currentNode == node)
	{
		playfx(level._effect["tunneldust"]	, self.origin);
		thread playsoundinspace ("ceiling_debris", self.origin);
		wait randomfloatrange(.4,.6);	
	}
}

schreck_countdown()
{
	level.schrecks++;
	while(isdefined(self))
		wait .25;
	level.schrecks--;
	level notify ("schreck taken");	
}

friendlyMethod(spawned)
{
	spawned endon ("death");
	if(isdefined(spawned.target) && spawned.target != "player")
	{
		spawned.goalradius = 8;
		spawned setgoalnode(getnode(spawned.target,"targetname"));
		spawned waittill ("goal");
		
	}
	spawned setgoalentity (level.player);
}

valley3chainflag()
{
	level.flag["valley3crossed"] = false;
	getent("auto2947","target") waittill ("trigger"); // script_hack
	level.flag["valley3crossed"] = true;
	
	
}

endmg42s()
{
	endmg42s = getentarray("endmg42","script_noteworthy");
	array_thread(endmg42s,::triggeroff);
	level waittill ("roofmg42s");
	array_thread(endmg42s,::triggeron);
}

vehicles_spawnandgo (group)
{
	vehicles = maps\_vehicle::scripted_spawn(group);
	array_levelthread(vehicles,maps\_vehicle ::gopath);
}

remove_bomb_hack()
{
	targs = getentarray(self.target,"targetname");
	for(i=0;i<targs.size;i++)
	{
		if(targs[i].classname == "trigger_use")
		{
			target = targs[i].target;
			targs[i] delete();
			getent(target,"targetname") delete();
		}
	}
}

endstand()
{
	level.price.goal_commit = true;
	level.price.goalradius = 8;
	level.price setgoalnode(getnode("endpricestand","targetname"));
	ai = getaiarray("allies");
	ai = array_remove(ai,level.price);
	nodes = getnodearray("endstand","targetname");
	for(i=0;i<nodes.size && i<ai.size;i++)
		ai[i] thread endstand_goto(nodes[i]);
	getvehiclenode("endstoptank","script_noteworthy") thread end_tank();
}

endstand_goto(node)
{
	self.goalradius = 8;
	self setgoalnode(node);	
	self waittill ("goal");
}

end_tank()
{
	self waittill("trigger",other);
	other setspeed(0,15);
}


spawnergrab()
{
	self.spawnedguys = 0;
	array_thread(getentarray(self.target,"targetname"),::spawnergrab_spawner,self);
	self waittill ("trigger");
	vehicles_spawnandgo(11);
	wait .4;
	while(self.spawnedguys)
		wait .3;
}

spawnergrab_spawner(trigger)
{
	trigger.spawnedguys++;
	self waittill ("spawned",other);
	if(spawn_failed(other))
	{
		trigger.spawnedguys--;
		return;
	}
	other waittill("death");
	trigger.spawnedguys--;
}

endkillallenemytanks()
{
	for(i=0;i<level.tanks.size;i++)
	{
		if(level.tanks[i].script_team == "axis")
			level.tanks[i] thread tank_delayed_death();
		if(level.tanks[i].script_team == "allies")
			level.tanks[i].script_turret = 0;
		
	}
}

tank_delayed_death()
{
	self endon ("death");
	wait randomfloatrange(0,2);
	self notify ("death");
}

endstopalltrucks()
{
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
		if(vehicles[i].vehicletype == "germanfordtruck")
			vehicles[i] setspeed(0,15);
}

gotonode(spawner)
{
	self endon ("death");
	wait .1;
	if(!isdefined(spawner.target))
		return;
	node = getnode(spawner.target,"targetname");
	radius = 500;
	if(isdefined(node.radius))
		radius = node.radius;
	self.goalradius = node.radius;
	self setgoalnode(node);
}

hacktriggers()
{
	thread hacktriggers_minefield((-866,-10562, 129),(-1103, -8911, 594));
	thread hacktriggers_minefield((-7709,-8407, -175),(-10314, -9473, 582));
	thread hacktriggers_bounceout((-6743, -6834, 75),(-6861, -6910, 166),(-6715,-6940,155));
	thread hacktriggers_autosave();
}

hacktriggers_autosave()
{
	trigger= spawn( "trigger_radius", (-14292,-5904,0), 0, 500, 500);
	trigger waittill ("trigger");
	autosavebyname("near_radiohouse");
}

hacktriggers_minefield(org1,org2)
{
	trigger = script_trigger(org1,org2);
	while(1)
	{
		trigger waittill ("trigger");
		level.player maps\_minefields::minefield_kill(trigger.radiustrig);
	}	
}

hacktriggers_bounceout(org1,org2,org3)
{
	trigger = script_trigger(org1,org2);
	while(1)
	{
		trigger waittill ("trigger");
		level.player setorigin(org3);
	}	
}


isclosest_flak()
{
	if(self== level.enemyflak88s[0])
		return true;
	return false;
}

//

sort_flaks(flaks)
{
	newflaks = [];
	order = [];
	order[order.size] = (-5833,-9311,141);
	order[order.size] = (-5669,-6943,165);
	order[order.size] = (-10709,-2343,159);
	order[order.size] = (-10861,-6695,295);
	order[order.size] = (-10989,-10575,439);
	for(i=0;i<order.size;i++)
	for(j=0;j<flaks.size;j++)
	{
		if(flaks[j].origin == order[i])
		{
			newflaks[newflaks.size] = flaks[j];
			continue;
		}
	}
	return newflaks;
}

waittill_xpos(pos)
{
	while(level.player.origin[0] > pos)
		wait .1;
}

flag_ypos(pos)
{
	flag_init("ypos_reached");
	while(level.player.origin[1] < pos)
		wait .1;
	flag_set("ypos_reached");
}

get_lastflakchain_reversed(node)
{
	nodearray = [];
	while(isdefined(node))
	{
		nodearray[nodearray.size] = node;
		if(isdefined(node.target))
			node = getnode(node.target,"targetname");
		else
			node = undefined;
	}
	newnodearray = [];
	for(i=nodearray.size-1;i>=0;i--)
		newnodearray[newnodearray.size] = nodearray[i];
	return newnodearray;
}

price_chainthink() //sticks price closer to the player when he's the only remaining ai.
{
	lasttotal = 20;
	while(1)
	{
		wait 1;
		if(lasttotal == level.totalfriends)
			continue;
		if(level.totalfriends == 1)
			price_closechain();
		else
			price_farchain();
		lasttotal = level.totalfriends;
	}
}

price_farchain()
{
	level.price.followmax = 0;
	level.price.followmin = 3;
}

price_closechain()
{
	level.price.followmax = 1;
	level.price.followmin = 0;
}
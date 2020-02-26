#include maps\_utility;
#include common_scripts\utility;
/#
mainDebug()
{
	thread lastSightPosWatch();
	
	if(level.script != "background")
		thread camera();






	
	if (getdvar("chain") == "1")
		thread debugchains();

	thread debugDvars();
	precacheShader("white");
	thread debugColorFriendlies();
	
	thread watchMinimap();
}
#/

debugchains()
{
	nodes = getallnodes();
	fnodenum = 0;

	fnodes = [];
	for (i=0;i<nodes.size;i++)
	{
		if ((!(nodes[i].spawnflags & 2)) &&
		(
		((isdefined (nodes[i].target)) && ((getnodearray (nodes[i].target, "targetname")).size > 0)   ) ||
		((isdefined (nodes[i].targetname)) && ((getnodearray (nodes[i].targetname, "target")).size > 0) )
		)
		)
		{
			fnodes[fnodenum] = nodes[i];
			fnodenum++;
		}
	}

	count = 0;

	while (1)
	{
		if (getdvar("chain") == "1")
		{
			for (i=0;i<fnodes.size;i++)
			{
				if (distance (level.player getorigin(), fnodes[i].origin) < 1500)
				{
					print3d (fnodes[i].origin, "yo", (0.2, 0.8, 0.5), 0.45);
					
				}
			}

			friends = getaiarray ("allies");
			for (i=0;i<friends.size;i++)
			{
				node = friends[i] animscripts\utility::GetClaimedNode();
				if (isdefined (node))
					line (friends[i].origin + (0,0,35), node.origin, (0.2, 0.5, 0.8), 0.5);
			}

		}
		maps\_spawner::waitframe();
	}
}

debug_enemyPos(num)
{
	ai = getaiarray();
	
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentitynumber() != num)
			continue;
			
		ai[i] thread debug_enemyPosProc();
		break;	
	}
}

debug_stopEnemyPos(num)
{
	ai = getaiarray();
	
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentitynumber() != num)
			continue;
			
		ai[i] notify ("stop_drawing_enemy_pos");
		break;	
	}
}

debug_enemyPosProc()
{
	self endon ("death");
	self endon ("stop_drawing_enemy_pos");
	for (;;)
	{
		wait (0.05);

		if (isalive(self.enemy))
			line (self.origin + (0,0,70), self.enemy.origin + (0,0,70), (0.8, 0.2, 0.0), 0.5);

		if (!self animscripts\utility::hasEnemySightPos())
			continue;
		
		pos = animscripts\utility::getEnemySightPos();
		line (self.origin + (0,0,70), pos, (0.9, 0.5, 0.3), 0.5);
	}
}

debug_enemyPosReplay()
{
	ai = getaiarray();
	guy = undefined;
	
	for (i=0;i<ai.size;i++)
	{


			
		guy = ai[i];
		if (!isalive(guy))
			continue;
	

		if (isdefined(guy.lastEnemySightPos))
			line (guy.origin + (0,0,65), guy.lastEnemySightPos, (1, 0, 1), 0.5);
			
		if (guy.goodShootPosValid)
		{
			if (guy.team == "axis")
				color = (1,0,0);
			else
				color = (0,0,1);
			

			nodeOffset = guy.origin + (0,0,54);
			if (isdefined(guy.node))
			{
				if (guy.node.type == "Cover Left")
				{
					cornerNode = true;
					nodeOffset = anglestoright(guy.node.angles);
					nodeOffset = vectorScale(nodeOffset, -32);
					nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
					nodeOffset = guy.node.origin + nodeOffset;
				}
				else
				if (guy.node.type == "Cover Right")
				{
					cornerNode = true;
					nodeOffset = anglestoright(guy.node.angles);
					nodeOffset = vectorScale(nodeOffset, 32);
					nodeOffset = (nodeOffset[0] , nodeOffset[1], 64);
					nodeOffset = guy.node.origin + nodeOffset;
				}
			}			
			draw_arrow (nodeOffset, guy.goodShootPos, color);
		}

	}
	if (1) return;

	if (!isalive(guy))
		return;
		
	if (isalive(guy.enemy))
		line (guy.origin + (0,0,70), guy.enemy.origin + (0,0,70), (0.6, 0.2, 0.2), 0.5);

	if (isdefined(guy.lastEnemySightPos))
		line (guy.origin + (0,0,65), guy.lastEnemySightPos, (0, 0, 1), 0.5);

	if (isalive(guy.goodEnemy))
		line (guy.origin + (0,0,50), guy.goodEnemy.origin, (1, 0, 0), 0.5);


	if (!guy animscripts\utility::hasEnemySightPos())
		return;

	pos = guy animscripts\utility::getEnemySightPos();
	line (guy.origin + (0,0,55), pos, (0.2, 0.2, 0.6), 0.5);

	if (guy.goodShootPosValid)
		line (guy.origin + (0,0,45), guy.goodShootPos, (0.2, 0.6, 0.2), 0.5);
}

drawEntTag(num)
{
	/#
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentnum() != num)
			continue;
		ai[i] thread dragTagUntilDeath(getdebugdvar("debug_tag"));
	}
	setdvar("debug_enttag", "");
	#/
}

drawTag(tag)
{
	org = self GetTagOrigin (tag);
	ang = self GetTagAngles (tag);
	forward = anglestoforward (ang);
	forwardFar = vectorScale(forward, 10);
	forwardClose = vectorScale(forward, 8);
	right = anglestoright (ang);
	leftdraw = vectorScale(right, -2);
	rightdraw = vectorScale(right, 2);
	
	up = anglestoup(ang);
	right = vectorScale(right, 10);
	up = vectorScale(up, 10);
	
	line (org, org + forwardFar, (0.9, 0.2, 0.2), 0.9);
	line (org + forwardFar, org + forwardClose + rightdraw, (0.9, 0.2, 0.2), 0.9);
	line (org + forwardFar, org + forwardClose + leftdraw, (0.9, 0.2, 0.2), 0.9);

	line (org, org + right, (0.2, 0.2, 0.9), 0.9);
	line (org, org + up, (0.2, 0.9, 0.2), 0.9);
}


drawTagForever(tag)
{
	self endon ("death");
	for (;;)
	{
		drawTag(tag);
		wait (0.05);
	}
}


dragTagUntilDeath(tag)
{
	for (;;)
	{
		if (!isdefined(self.origin))
			break;
		drawTag(tag);
		wait (0.05);
	}
}

viewTag(type,tag)
{
	if(type == "ai")
	{
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
			ai[i] drawTag(tag);
	}
	else
	{
		vehicle = getentarray("script_vehicle","classname");
		for (i=0;i<vehicle.size;i++)
			vehicle[i] drawTag(tag);
	}
}
















































coverTest()
{
	coverSetupAnim();
}

#using_animtree ("generic_human");
coverSetupAnim()
{
	spawn = undefined;
	spawner = undefined;
	for (;;)
	{
		for (i=0;i<level.debugspawners.size;i++)
		{
			wait (0.05);
			spawner = level.debugspawners[i];
			nearActive = false;
			for (p=0;p<level.activeNodes.size;p++)
			{
				if (distance(level.activeNodes[p].origin, self.origin) > 250)
					continue;
				nearActive = true;
				break;
			}
			if (nearActive)
				continue;
				
			completed = false;
			for (p=0;p<level.completedNodes.size;p++)
			{
				if (level.completedNodes[p] != self)
					continue;
				completed = true;
				break;
			}
			if (completed)
				continue;
				
			level.activeNodes[level.activeNodes.size] = self;
			spawner.origin = self.origin;
			spawner.angles = self.angles;
			spawner.count = 1;
			spawn = spawner stalingradspawn();
			if (spawn_failed(spawn))
			{
				removeActiveSpawner(self);
				continue;
			}
			
			break;
		}
		if (isalive(spawn))
			break;
	}

	wait (1);
	if (isalive (spawn))
	{
		spawn.ignoreme = true;
		spawn.team = "neutral";
		spawn setgoalpos (spawn.origin);
		thread createLine(self.origin);
		spawn thread debugorigin();
		thread createLineConstantly(spawn);
		spawn waittill ("death");
	}
	removeActiveSpawner(self);
	level.completedNodes[level.completedNodes.size] = self;
}

removeActiveSpawner(spawner)
{
	newSpawners = [];	
	for (p=0;p<level.activeNodes.size;p++)
	{
		if (level.activeNodes[p] == spawner)
			continue;
		newSpawners[newSpawners.size] = level.activeNodes[p];
	}
	level.activeNodes = newSpawners;
}


createLine(org)
{
	for (;;)
	{
		line (org + (0,0,35), org, (0.2, 0.5, 0.8), 0.5);
		wait (0.05);
	}
}

createLineConstantly(ent)
{
	org = undefined;
	while (isalive(ent))
	{
		org = ent.origin;
		wait (0.05);		
	}
	
	for(;;)
	{
		line (org + (0,0,35), org, (1.0, 0.2, 0.1), 0.5);
		wait (0.05);
	}
}

debugMisstime()
{
	self notify ("stopdebugmisstime");
	self endon ("stopdebugmisstime");
	self endon ("death");
	for (;;)
	{
		if (self.a.misstime <= 0)
			print3d(self gettagorigin ("TAG_EYE") + (0,0,15), "hit", (0.3,1,1), 1);
		else
			print3d(self gettagorigin ("TAG_EYE") + (0,0,15), self.a.misstime/20, (0.3,1,1), 1);
		wait (0.05);
	}
}

debugMisstimeOff()
{
	self notify ("stopdebugmisstime");
}

setEmptyDvar(dvar, setting)
{
	/#
	if (getdebugdvar(dvar) == "")
		setdvar(dvar, setting);
	#/		
}

debugJump(num)
{
	/#
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] getentnum() != num)
			continue;
			
		line (level.player.origin, ai[i].origin, (0.2,0.3,1.0));
		return;
	}
	#/
}

debugDvars()
{
	/#
	waittillframeend; 
	setEmptyDvar("debug_accuracypreview","off");

	if (getdebugdvar("debug_lookangle") == "")
		setdvar("debug_lookangle", "off");

	if (getdebugdvar("debug_grenademiss") == "")
		setdvar("debug_grenademiss", "off");

	if (getdebugdvar("debug_enemypos") == "")
		setdvar("debug_enemypos", "-1");
		
	if (getdebugdvar("debug_dotshow") == "")
		setdvar("debug_dotshow", "-1");
		
	if (getdebugdvar("debug_stopenemypos") == "")
		setdvar("debug_stopenemypos", "-1");

	if (getdebugdvar("debug_replayenemypos") == "")
		setdvar("debug_replayenemypos", "-1");

	if (getdebugdvar("debug_tag") == "")
		setdvar("debug_tag", "");

	if (getdebugdvar("debug_arrivals") == "")
		setdvar("debug_arrivals", "");

	if (getdebugdvar("debug_chatlook") == "")
		setdvar("debug_chatlook", "");
		
	if (getdebugdvar("debug_vehicletag") == "")
		setdvar("debug_vehicletag", "");

	if (getdebugdvar("debug_vehiclesittags") == "")
		setdvar("debug_vehiclesittags", "off");
		
	if (getdebugdvar("debug_colorfriendlies") == "")
		setdvar("debug_colorfriendlies", "off");

	if (getdebugdvar("debug_animreach") ==  "")
		setdvar("debug_animreach", "off");

	if (getdebugdvar("debug_hatmodel") == "")
		setdvar("debug_hatmodel", "on");

	if (getdebugdvar("debug_trace") == "")
		setdvar("debug_trace", "off");

	level.debug_badpath = false;
	if (getdebugdvar("debug_badpath") == "")
		setdvar("debug_badpath", "off");

	if (getdebugdvar ("anim_lastsightpos") == "")
		setdvar("debug_lastsightpos", "off");

	if (getdvar ("debug_nuke") == "")
		setdvar("debug_nuke", "off");

	if (getdebugdvar("debug_deathents") == "on")
		setdvar("debug_deathents", "off");

	if (getdvar ("debug_jump") == "")
		setdvar("debug_jump", "");

	if (getdvar ("debug_hurt") == "")
		setdvar("debug_hurt", "");

	if (getdvar ("debug_depth") == "")
		setdvar("debug_depth", "");

	if (getdebugdvar ("debug_colornodes") == "")
		setdvar("debug_colornodes", "");
		
	if (getdebugdvar ("debug_reflection") == "")
		setdvar("debug_reflection", "0");
	
	level.last_threat_debug = -23430;
	if (getdebugdvar ("debug_threat") == "")
		setdvar("debug_threat", "-1");
	
	precachemodel("test_sphere_silver");

	red = ( 1, 0, 0 );
	blue = ( 0, 0, 1 );
	yellow = ( 1, 1, 0 );
	cyan = ( 0, 1, 1 );
	green = ( 0, 1, 0 );
	purple = ( 1, 0, 1 );
	orange = ( 1, 0.5, 0 );

	level.color_debug[ "r" ] = red;
	level.color_debug[ "b" ] = blue;
	level.color_debug[ "y" ] = yellow;
	level.color_debug[ "c" ] = cyan;
	level.color_debug[ "g" ] = green;
	level.color_debug[ "p" ] = purple;
	level.color_debug[ "o" ] = orange;
	
	level.debug_reflection = false;
	

	
	
		

	

	noAnimscripts = getdvar("debug_noanimscripts") == "on";
	for (;;)
	{
		if (getdebugdvar("debug_jump") != "")
			debugJump(getdebugdvarint("debug_jump"));
		
		if (getdebugdvar("debug_tag") != "")
		{
			thread viewTag("ai",getdebugdvar("debug_tag"));
			if (getdebugdvarInt("debug_enttag") > 0)
				thread drawEntTag(getdebugdvarInt("debug_enttag"));
		}

		if (getdebugdvar("debug_vehicletag") != "")
			thread viewTag("vehicle",getdebugdvar("debug_vehicletag"));

		if (getdebugdvar("debug_colornodes") == "on" )
			thread debug_colornodes();
		
		if (getdebugdvar("debug_vehiclesittags") != "off")
			thread debug_vehiclesittags();

		if (getdebugdvar("debug_replayenemypos") == "on")
			thread debug_enemyPosReplay();

		if (getdvar("debug_nuke") == "on")
			thread debug_nuke();

		if (getdvar("debug_misstime") == "on")
		{
			setdvar("debug_misstime", "start");
			array_thread(getaiarray(), ::debugMisstime);
		}
		else
		if (getdvar("debug_misstime") == "off")
		{
			setdvar("debug_misstime", "start");
			array_thread(getaiarray(), ::debugMisstimeOff);
		}

		if (getdvar("debug_deathents") == "on")
			thread deathspawnerPreview();	

		if (getdvar("debug_hurt") == "on")
		{
			setdvar("debug_hurt", "off");
			level.player dodamage(50, (324234,3423423,2323));
		}

		if (getdvar("debug_hurt") == "on")
		{
			setdvar("debug_hurt", "off");
			level.player dodamage(50, (324234,3423423,2323));
		}

		if (getdvar("debug_depth") == "on")
		{
			thread fogcheck();
		}

		if (getdebugdvar("debug_threat") != "-1")
		{
			debugThreat();
		}

		if (getdebugdvar("debug_badpath") == "on")
		{
			level.debug_badpath = true;
		}
		else
		{
			level.debug_badpath = false;
		}

		if (getdebugdvarint("debug_enemypos") != -1)
		{
			thread debug_enemypos(getdebugdvarint("debug_enemypos"));
			setdvar("debug_enemypos", "-1");
		}
		if (getdebugdvarint("debug_stopenemypos") != -1)
		{
			thread debug_stopenemypos(getdebugdvarint("debug_stopenemypos"));
			setdvar("debug_stopenemypos", "-1");
		}
		
		if (!noAnimscripts && getdvar("debug_noanimscripts") == "on")
		{
			anim.defaultException = animscripts\init::infiniteLoop;
			noAnimscripts = true;
		}
		
		if (noAnimscripts && getdvar("debug_noanimscripts") == "off")
		{
			anim.defaultException = animscripts\init::empty;
			anim notify ("new exceptions");
			noAnimscripts = false;
		}

		if (getdebugdvar("debug_trace") == "on")
		{
			if (!isdefined (level.traceStart))
				thread showDebugTrace();
			level.traceStart = level.player geteye();
			setdvar("debug_trace", "off");
		}
		
		debug_reflection();


		
		wait (0.05);
	}
	#/
}

debug_reflection()
{
	/#
		if (getdebugdvar("debug_reflection") != "0"  && !level.debug_reflection)
		{
				level.debug_reflection = true;
				level.debug_reflectionobject = spawn ( "script_model", level.player geteye() + ( vector_multiply ( anglestoforward ( level.player.angles ), 100) ));
				level.debug_reflectionobject setmodel("test_sphere_silver");
				level.debug_reflectionobject.origin = level.player geteye() + ( vector_multiply ( anglestoforward ( level.player getplayerangles() ), 100) );
				level.debug_reflectionobject linkto ( level.player );
				thread 	debug_reflection_buttons();
			
		}
		else if(getdebugdvar("debug_reflection") == "0" && level.debug_reflection)
		{
			level.debug_reflection = false;
			level.debug_reflectionobject delete();
		}	
		#/
}

debug_reflection_buttons()
{
	/#
	offset = 100;
	lastoffset = offset;
	offsetinc = 50;
	while(getdebugdvar("debug_reflection") != "0")
	{
		if(level.player buttonpressed ("BUTTON_X"))
			offset+=offsetinc;
		if(level.player buttonpressed ("BUTTON_Y"))
			offset-=offsetinc;
		if(offset > 1000)
			offset = 1000;
		if(offset < 64)
			offset = 64;


			level.debug_reflectionobject unlink();
			level.debug_reflectionobject.origin = level.player geteye() + ( vector_multiply ( anglestoforward ( level.player getplayerangles() ), offset) );
			lastoffset = offset;
		level.debug_reflectionobject linkto (level.player);

		wait .05;
	}
	#/
}

showDebugTrace()
{
	startOverride = undefined;
	endOverride = undefined;
	startOverride = (15.1859, -12.2822, 4.071);
	endOverride = (947.2, -10918, 64.9514);

	assert (!isdefined (level.traceEnd));
	for (;;)
	{
		wait (0.05);
		start = startOverride;
		end = endOverride;
		if (!isdefined(startOverride))
			start = level.traceStart;
		if (!isdefined(endOverride))
			end = level.player geteye();
			
		trace = bulletTrace(start, end, false, undefined);
		line (start, trace["position"], (0.9, 0.5, 0.8), 0.5);
	}	
}

hatmodel()
{
	/#
	for (;;)
	{
		if (getdebugdvar("debug_hatmodel") == "off")
			return;
		noHat = [];
		ai = getaiarray();
		
		for (i=0;i<ai.size;i++)
		{
			if (isdefined(ai[i].hatmodel))
				continue;
				
			alreadyKnown = false;
			for (p=0;p<noHat.size;p++)
			{
				if (noHat[p] != ai[i].classname)
					continue;
				alreadyKnown = true;
				break;
			}
			if (!alreadyKnown)
				noHat[noHat.size] = ai[i].classname;
		}
		
		if (noHat.size)
		{
			println (" ");
			println ("The following AI have no Hatmodel, so helmets can not pop off on head-shot death:");
			for (i=0;i<noHat.size;i++)
				println ("Classname: ", noHat[i]);
			println ("To disable hatModel spam, type debug_hatmodel off");
		}
		wait (15);
	}
	#/
}

debug_character_count ()
{
	
	drones = newHudElem();
	drones.alignX = "left";
	drones.alignY = "middle";
	drones.x = 10;
	drones.y = 100;
	
	drones.alpha = 0;
	
	
	allies = newHudElem();
	allies.alignX = "left";
	allies.alignY = "middle";
	allies.x = 10;
	allies.y = 115;
	
	allies.alpha = 0;
	
	
	axis = newHudElem();
	axis.alignX = "left";
	axis.alignY = "middle";
	axis.x = 10;
	axis.y = 130;
	
	axis.alpha = 0;
	

	
	vehicles = newHudElem();
	vehicles.alignX = "left";
	vehicles.alignY = "middle";
	vehicles.x = 10;
	vehicles.y = 145;
	
	vehicles.alpha = 0;

	
	total = newHudElem();
	total.alignX = "left";
	total.alignY = "middle";
	total.x = 10;
	total.y = 160;
	
	total.alpha = 0;
	
	lastdvar = "off";
	for (;;)
	{
		dvar = getdvar("debug_character_count");
		if(dvar == "off")
		{
			if(dvar != lastdvar)
			{
				drones.alpha = 0;
				allies.alpha = 0;
				axis.alpha = 0;
				vehicles.alpha = 0;
				total.alpha = 0;
				lastdvar = dvar;
			}
			wait .25;
			continue;
		}
		else
		{
			if(dvar != lastdvar)
			{
				drones.alpha = 1;
				allies.alpha = 1;
				axis.alpha = 1;
				vehicles.alpha = 1;
				total.alpha = 1;
				lastdvar = dvar;

			}
		}
		
		count_drones = getentarray("drone","targetname").size;
		drones setValue( count_drones );
		
		
		count_allies = getaiarray("allies").size;
		allies setValue( count_allies );
		
		
		count_axis = getaiarray("axis").size;
		axis setValue( count_axis );
		
		vehicles setValue (getentarray("script_vehicle","classname").size);
		
		
		total setValue ( count_drones + count_allies + count_axis );
		
		wait 0.25;
	}
}

debug_nuke()
{
	setdvar("debug_nuke", "off");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
		ai[i] dodamage(300, (0,0,0));
}

debug_missTime()
{
	
}

camera()
{
	wait (0.05);
	cameras = getentarray ("camera","targetname");
	for (i=0;i<cameras.size;i++)
	{
		ent = getent (cameras[i].target,"targetname");
		cameras[i].origin2 = ent.origin;
		cameras[i].angles = vectortoangles(ent.origin - cameras[i].origin);
	}
	for (;;)
	{
		/#
		if (getdebugdvar ("camera") != "on")
		{
			if (getdebugdvar ("camera") != "off")
				setdvar ("camera", "off");
			wait (1);
			continue;
		}
		#/
		
		ai = getaiarray ("axis");
		if (!ai.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}
		cameraWithEnemy = [];
		for (i=0;i<cameras.size;i++)
		{
			for (p=0;p<ai.size;p++)
			{
				if (distance(cameras[i].origin, ai[p].origin) > 256)
					continue;
				cameraWithEnemy[cameraWithEnemy.size] = cameras[i];
				break;
			}
		}
		if (!cameraWithEnemy.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}

		cameraWithPlayer = [];
		for (i=0;i<cameraWithEnemy.size;i++)
		{
			camera = cameraWithEnemy[i];
			
			start = camera.origin2;
			end = camera.origin;
			difference = vectorToAngles((end[0],end[1],end[2]) - (start[0],start[1],start[2]));
			angles = (0, difference[1], 0);
		    forward = anglesToForward(angles);
		
			difference = vectornormalize(end - level.player.origin);
			dot = vectordot(forward, difference);
			if (dot < 0.85)
				continue;
				
			cameraWithPlayer[cameraWithPlayer.size] = camera;
		}
		
		if (!cameraWithPlayer.size)
		{
			freePlayer();
			wait (0.5);
			continue;
		}
		
		dist = distance(level.player.origin, cameraWithPlayer[0].origin);
		newcam = cameraWithPlayer[0];
		for (i=1;i<cameraWithPlayer.size;i++)
		{
			newdist = distance(level.player.origin, cameraWithPlayer[i].origin);
			if (newdist > dist)
				continue;
			
			newcam = cameraWithPlayer[i];
			dist = newdist;
		}
		
		setPlayerToCamera(newcam);
		wait (3);
	}
}
	
freePlayer()
{
	setdvar ("cl_freemove","0");
}

setPlayerToCamera(camera)
{
	setdvar ("cl_freemove","2");
	setdebugangles (camera.angles);
	setdebugorigin (camera.origin + (0,0,-60));
}


anglescheck()
{
	while (1)
	{
		if (getdvar ("angles") == "1")
		{
			println ("origin " + level.player getorigin());
			println ("angles " + level.player.angles);
			setdvar("angles", "0");
		}
		wait (1);
	}
}

dolly ()
{
	if (!isdefined (level.dollyTime))
		level.dollyTime = 5;
	setdvar ("dolly", "");
	thread dollyStart();
	thread dollyEnd();
	thread dollyGo();
}

dollyStart()
{
	while (1)
	{
		if (getdvar ("dolly") == "start")
		{
			level.dollystart = level.player.origin;
			setdvar ("dolly", "");
		}
		wait (1);
	}
}

dollyEnd()
{
	while (1)
	{
		if (getdvar ("dolly") == "end")
		{
			level.dollyend = level.player.origin;
			setdvar ("dolly", "");
		}
		wait (1);
	}
}

dollyGo()
{
	while (1)
	{
		wait (1);
		if (getdvar ("dolly") == "go")
		{
			setdvar ("dolly", "");
			if (!isdefined (level.dollystart))
			{
				println ("NO Dolly Start!");
				continue;
			}
			if (!isdefined (level.dollyend))
			{
				println ("NO Dolly End!");
				continue;
			}

			org = spawn ("script_origin",(0,0,0));
			org.origin = level.dollystart;
			level.player setorigin (org.origin);
			level.player linkto (org);

			org moveto (level.dollyend, level.dollyTime);
			wait (level.dollyTime);
			org delete();
		}
	}
}

deathspawnerPreview()
{
	waittillframeend;
	for (i=0;i<50;i++)
	{
		if (!isdefined (level.deathspawnerents[i]))
			continue;
		array = level.deathspawnerents[i];
		for (p=0;p<array.size;p++)
		{
			ent = array[p];
			if (isdefined(ent.truecount))
				print3d (ent.origin, i + ": " + ent.truecount, (0,0.8,0.6), 5);
			else
				print3d (ent.origin, i + ": " +  ".", (0,0.8,0.6), 5);
		}
	}
}


lastSightPosWatch()
{
	/#
	for (;;)
	{
		wait (0.05);
		num = getdvarint("lastsightpos");
		if (!num)
			continue;
		
		guy = undefined;
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] getentnum() != num)
				continue;
				
			guy = ai[i];
			break;
		}
		
		if (!isalive(guy))
			continue;

		if (guy animscripts\utility::hasEnemySightPos())
			org = guy animscripts\utility::getEnemySightPos();
		else
			org = undefined;
		
					
		for (;;)
		{
			newnum = getdvarint("lastsightpos");
			if (num != newnum)
				break;
				
			if ((isalive(guy)) && (guy animscripts\utility::hasEnemySightPos()))
				org = guy animscripts\utility::getEnemySightPos();
			
			if (!isdefined(org))
			{
				wait (0.05);
				continue;
			}
			
			range = 10;
			color = (0.2, 0.9, 0.8);
			line (org + (0,0,range), org + (0,0,range * -1), color, 1.0);
			line (org + (range,0,0), org + (range * -1,0,0), color, 1.0);
			line (org + (0,range,0), org + (0,range * -1, 0), color, 1.0);
			wait (0.05);
		}
	}
	#/
}

watchMinimap()
{
	
	while(1)
	{
		updateMinimapSetting();
		wait .25;
	}
}

updateMinimapSetting()
{	
	
	requiredMapAspectRatio = getdvarfloat("scr_requiredMapAspectRatio");

	if (!isdefined(level.minimapheight)) {
		setdvar("scr_minimap_height", "0");
		level.minimapheight = 0;
	}
	minimapheight = getdvarfloat("scr_minimap_height");
	if (minimapheight != level.minimapheight)
	{
		if (isdefined(level.minimaporigin)) {
			level.minimapplayer unlink();
			level.minimaporigin delete();
			level notify("end_draw_map_bounds");
		}
		
		if (minimapheight > 0)
		{
			level.minimapheight = minimapheight;
			
			player = level.player;
			
			corners = getentarray("minimap_corner", "targetname");
			if (corners.size == 2)
			{
				viewpos = (corners[0].origin + corners[1].origin);
				viewpos = (viewpos[0]*.5, viewpos[1]*.5, viewpos[2]*.5);

				maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
				mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
				if (corners[1].origin[0] > corners[0].origin[0])
					maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
				else
					mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
				if (corners[1].origin[1] > corners[0].origin[1])
					maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
				else
					mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
				
				viewpostocorner = maxcorner - viewpos;
				viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
				
				origin = spawn("script_origin", player.origin);
				
				northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
				eastvector = (northvector[1], 0 - northvector[0], 0);
				disttotop = vectordot(northvector, viewpostocorner);
				if (disttotop < 0)
					disttotop = 0 - disttotop;
				disttoside = vectordot(eastvector, viewpostocorner);
				if (disttoside < 0)
					disttoside = 0 - disttoside;
				
				
				if ( requiredMapAspectRatio > 0 )
				{
					mapAspectRatio = disttoside / disttotop;
					if ( mapAspectRatio < requiredMapAspectRatio )
					{
						incr = requiredMapAspectRatio / mapAspectRatio;
						disttoside *= incr;
						addvec = vecscale( eastvector, vectordot( eastvector, maxcorner - viewpos ) * (incr - 1) );
						mincorner -= addvec;
						maxcorner += addvec;
					}
					else
					{
						incr = mapAspectRatio / requiredMapAspectRatio;
						disttotop *= incr;
						addvec = vecscale( northvector, vectordot( northvector, maxcorner - viewpos ) * (incr - 1) );
						mincorner -= addvec;
						maxcorner += addvec;
					}
				}
				
				if ( level.xenon )
				{
					aspectratioguess = 16.0/9.0;
					
					angleside = 2 * atan(disttoside * .8 / minimapheight);
					angletop = 2 * atan(disttotop * aspectratioguess * .8 / minimapheight);
				}
				else
				{
					aspectratioguess = 4.0/3.0;
					angleside = 2 * atan(disttoside / minimapheight);
					angletop = 2 * atan(disttotop * aspectratioguess / minimapheight);
				}
				if (angleside > angletop)
					angle = angleside;
				else
					angle = angletop;
				
				znear = minimapheight - 1000;
				if (znear < 16) znear = 16;
				if (znear > 10000) znear = 10000;

				player playerlinktoabsolute(origin);
				origin.origin = viewpos + (0,0,-62);
				origin.angles = (90, getnorthyaw(), 0);
				
				
				
				setsaveddvar("cg_fov", angle);
				
				
				
				
				
				level.minimapplayer = player;
				level.minimaporigin = origin;
				
				thread drawMiniMapBounds(viewpos, mincorner, maxcorner);
			}
			else
				println("^1Error: There are not exactly 2 \"minimap_corner\" entities in the level.");
		}
	}
}

getchains()
{
	chainarray = [];
	chainarray = getentarray("minimap_line","script_noteworthy");
	array = [];
	for(i=0;i<chainarray.size;i++)
	{
		array[i] = chainarray[i] getchain();
	}
	return array;
}

getchain()
{
	array = [];
	ent = self;
	while(isdefined(ent))
	{
		array[array.size] = ent;
		if(!isdefined(ent) || !isdefined(ent.target))
			break;
		ent = getent(ent.target,"targetname");
		if(isdefined(ent) && ent == array[0])
		{
			array[array.size] = ent;
			break;
		}
	}
	originarray = [];
	for(i=0;i<array.size;i++)
		originarray[i] = array[i].origin;
	return originarray;
	
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}
drawMiniMapBounds(viewpos, mincorner, maxcorner)
{
	level notify("end_draw_map_bounds");
	level endon("end_draw_map_bounds");
	
	viewheight = (viewpos[2] - maxcorner[2]);
	
	diaglen = length(mincorner - maxcorner);

	mincorneroffset = (mincorner - viewpos);
	mincorneroffset = vectornormalize((mincorneroffset[0], mincorneroffset[1], 0));
	mincorner = mincorner + vecscale(mincorneroffset, diaglen * 1/800*0);
	maxcorneroffset = (maxcorner - viewpos);
	maxcorneroffset = vectornormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
	maxcorner = maxcorner + vecscale(maxcorneroffset, diaglen * 1/800*0);
	
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	
	diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	sidenorth = vecscale(north, abs(vectordot(diagonal, north)));
	
	corner0 = mincorner;
	corner1 = mincorner + side;
	corner2 = maxcorner;
	corner3 = maxcorner - side;
	
	toppos = vecscale(mincorner + maxcorner, .5) + vecscale(sidenorth, .51);
	textscale = diaglen * .003;
	chains = getchains();

	
	while(1)
	{
		line(corner0, corner1);
		line(corner1, corner2);
		line(corner2, corner3);
		line(corner3, corner0);

		array_levelthread(chains, maps\_utility::plot_points);

		print3d(toppos, "This Side Up", (1,1,1), 1, textscale);
		
		wait .05;
	}
}


debug_vehiclesittags()
{
	vehicles = getentarray("script_vehicle","classname");
	type = "none";
/#	type = getdebugdvar("debug_vehiclesittags");#/
	for(i=0;i<vehicles.size;i++)
	{

		if(!isdefined(level.vehicle_aianims[vehicles[i].vehicletype]))
			continue;
		
		anims = level.vehicle_aianims[vehicles[i].vehicletype];
		for(j=0;j<anims.size;j++)
		{
			if(isdefined(anims[j].sittag))
			{
				vehicles[i] thread drawtag(anims[j].sittag);
				org = vehicles[i] gettagorigin(anims[j].sittag);
				if(level.player islookingatorigin(org))
					print3d(org+(0,0,16),anims[j].sittag,(1,1,1),1,1);
			}
		}
	}
}

islookingatorigin(origin)
{
	normalvec = vectorNormalize(origin-self getShootAtPos());
	veccomp = vectorNormalize((origin-(0,0,24))-self getShootAtPos());
	insidedot = vectordot(normalvec,veccomp);
	
	anglevec = anglestoforward(self getplayerangles());
	vectordot = vectordot(anglevec,normalvec);
	if(vectordot > insidedot)
		return true;
	else
		return false;
}

debug_colornodes()
{
	wait (0.05);
	ai = getaiarray();

	array = [];
	array[ "axis" ] = [];
	array[ "allies" ] = [];
	array[ "neutral" ] = [];
	for ( i=0; i<ai.size; i++ )
	{
		guy = ai[ i ];
			
		if ( !isdefined( guy.currentColorCode ) )
			continue;
			
		array[ guy.team ][ guy.currentColorCode ] = true;
		
		color = ( 1, 1, 1 );
		if ( isdefined( guy.script_forceColor ) )
			color = level.color_debug[ guy.script_forceColor ];

		print3d( guy.origin + ( 0,0,50 ), guy.currentColorCode, color, 1, 1 );

		
		if ( guy.team == "axis" )
			continue;
		
		guy try_to_draw_line_to_node();
	}
	
	draw_colorNodes( array, "allies" );
	draw_colorNodes( array, "axis" );
}

draw_colorNodes( array, team )
{
	keys = getArrayKeys( array[ team ] );
	for ( i=0; i<keys.size; i++ )
	{
		color = ( 1, 1, 1 );
		
		color = level.color_debug[ getsubstr( keys[ i ], 0, 1 ) ];
	
		if ( isdefined( level.colorNodes_debug_array[ team ][ keys[ i ] ] ) )
		{
			teamArray = level.colorNodes_debug_array[ team ][ keys[ i ] ];
			for ( p=0; p < teamArray.size; p++ )
			{
				print3d( teamArray[ p ].origin, "N-" + keys[ i ], color, 1, 1 );
			}
		}
	}
}

get_team_substr()
{
	if ( self.team == "allies" )
	{
		if ( !isdefined( self.node.script_color_allies ) )
			return;
			
		return self.node.script_color_allies;
	}
	
	if ( self.team == "axis" )
	{
		if ( !isdefined( self.node.script_color_axis ) )
			return;
			
		return self.node.script_color_axis;
	}
}

try_to_draw_line_to_node()
{
	if ( !isdefined( self.node ) )
		return;
		
	if ( !isdefined( self.script_forceColor ) )
		return;
	
	substr = get_team_substr();
	if ( !isdefined( substr ) )
		return;
		
	if ( !issubstr( substr, self.script_forceColor ) )
		return;
		
	line( self.origin + ( 0,0,64 ), self.node.origin, level.color_debug[ self.script_forceColor ] );
}

fogcheck()
{
	if ( getdvar( "depth_close" ) == "" )
		setdvar( "depth_close", "0" );
		
	if ( getdvar( "depth_far" ) == "" )
		setdvar( "depth_far", "1500" );
		
	close = getdvarint( "depth_close" );
	far = getdvarint( "depth_far" );
	setexpfog( close, far, 1, 1, 1, 0 );
}

debugThreat()
{
	if ( gettime() > level.last_threat_debug + 1000 )
	{
		level.last_threat_debug = gettime();
		thread debugThreatCalc();
	}
}

debugThreatCalc()
{
	
	/#
	ai = getaiarray();
	entnum = getdebugdvarint( "debug_threat" );
	entity = undefined;
	if ( entnum == 0 )
	{
		entity = level.player;
	}
	else
	{
		for ( i=0; i < ai.size; i++ )
		{
			if ( entnum != ai[ i ] getentnum() )
				continue;
			entity = ai[ i ];
			break;
		}
	}
	
	if ( !isalive( entity ) )
		return;
	
	entityGroup = entity getthreatbiasgroup();
	array_thread( ai, ::displayThreat, entity, entityGroup );
	level.player thread displayThreat( entity, entityGroup );
	#/
}

displayThreat( entity, entityGroup )
{
	if ( self.team == entity.team )
		return;

	selfthreat = 0;		
	selfthreat+= self.threatBias;

	threat = 0;
	threat+= entity.threatBias;
	myGroup = undefined;

	if ( isdefined( entityGroup ) )
	{
		myGroup = self getthreatbiasgroup();
		if ( isdefined( myGroup ) )
		{
			threat += getthreatbias( entityGroup, myGroup );
			selfThreat += getthreatbias( myGroup, entityGroup );
		}
	}
	
	if ( entity.ignoreme || threat < -900000 )
		threat = "Ignore";

	if ( self.ignoreme || selfthreat < -900000 )
		selfthreat = "Ignore";
			
	timer = 1*20;
	col = ( 1, 0.5, 0.2 );
	col2 = ( 0.2, 0.5, 1 );
	pacifist = self != level.player && self.pacifist;
	
	for ( i=0; i <= timer; i++ )
	{
		print3d( self.origin + (0,0,65), "Him to Me:", col, 3 );
		print3d( self.origin + (0,0,50), threat, col, 5 );
		if ( isdefined( entityGroup ) )
		{
			print3d( self.origin + (0,0,35), entityGroup, col, 2 );
		}

		print3d( self.origin + (0,0,15), "Me to Him:", col2, 3 );
		print3d( self.origin + (0,0,0), selfThreat, col2, 5 );
		if ( isdefined( mygroup ) )
		{
			print3d( self.origin + (0,0,-15), mygroup, col2, 2 );
		}
		if ( pacifist )
		{
			print3d( self.origin + (0,0,25), "(Pacifist)", col2, 5 );
		}
		
		wait( 0.05 );
	}
}

debugColorFriendlies()
{
	level.debug_color_friendlies = [];
	level.debug_color_huds = [];
	
	for ( ;; )
	{
		level waittill( "updated_color_friendlies" );
		draw_color_friendlies();
	}
}

draw_color_friendlies()
{
	level endon( "updated_color_friendlies" );
	keys = getarraykeys( level.debug_color_friendlies );
	
	colored_friendlies = [];
	colors = [];
	colors[ colors.size ] = "r";
	colors[ colors.size ] = "o";
	colors[ colors.size ] = "y";
	colors[ colors.size ] = "g";
	colors[ colors.size ] = "c";
	colors[ colors.size ] = "b";
	colors[ colors.size ] = "p";
	
	rgb[ "r" ] = ( 1,0,0 );
	rgb[ "o" ] = ( 1,0.5,0 );
	rgb[ "y" ] = ( 1,1,0 );
	rgb[ "g" ] = ( 0,1,0 );
	rgb[ "c" ] = ( 0,1,1 );
	rgb[ "b" ] = ( 0,0,1 );
	rgb[ "p" ] = ( 1,0,1 );
	

	for ( i=0; i < colors.size; i++ )
	{
		colored_friendlies[ colors[ i ] ] = 0;
	}

	for ( i=0; i < keys.size; i++ )
	{
		color = level.debug_color_friendlies[ keys[ i ] ];
		colored_friendlies[ color ]++;
	}
	
	for ( i=0; i < level.debug_color_huds.size; i++ )
	{
		level.debug_color_huds[ i ] destroy();
	}
	level.debug_color_huds = [];

/#
	if ( getdebugdvar( "debug_colorfriendlies" ) != "on" )
		return;
#/
		
	x = 15;
	y = 365;
	offset_x = 25;
	offset_y = 25;
	for ( i=0; i < colors.size; i++ )
	{
		if ( colored_friendlies[ colors[ i ] ] <= 0 )
			continue;
		for ( p=0; p < colored_friendlies[ colors[ i ] ]; p++ )
		{
			overlay = newHudElem();
			overlay.x = x + 25*p;
			overlay.y = y;
			overlay setshader ("white", 16, 16);
			overlay.alignX = "left";
			overlay.alignY = "bottom";
			overlay.alpha = 1;
			overlay.color = rgb[ colors[ i ] ];
			level.debug_color_huds[ level.debug_color_huds.size ] = overlay;
		}
		
		y += offset_y;
	}
}

puppetWatcher()
{
	self endon( "death" );

	puppet	 = undefined;
	cameraId = -1;

	while(1)
	{
		self waittill("puppetToggle");

		if( isdefined(level.player) )
		{
			if( isdefined(puppet) )
			{
				iprintlnbold("Stop Puppet");

				puppet SetMachine("Brain", "BrainAiSoldierBasic");
				puppet SetEnableSense( true );

				level.player freezeControls(false);

				puppet = undefined;

				level.player customCamera_pop( cameraId, 0, 0, 0.0 ); 
			}
			else
			{
				nearAi = entsearch( level.CONTENTS_ACTOR, level.player.origin, 100*12 );

				if( nearAi.size > 0 )
				{
					iprintlnbold("Start Puppet");

					bestDist = 999999999;
					for( i=0; i < nearAi.size; i++ )
					{
						dist = distancesquared( nearAi[i].origin, level.player.origin );

						if( dist < bestDist )
						{
							bestDist = dist;
							puppet = nearAi[i];
						}
					}

					puppet SetEnableSense( false );
					puppet SetMachine("Brain", "BrainAiPlayerControlled");

					level.player freezeControls(true);

					cameraID = level.player customCamera_push( "entity", level.player, puppet, (0,0,0), (0,0,0), 0.0 ); 
				}
				else
				{
					iprintlnbold("No Puppet Available");
				}
			}
		}
	}
}

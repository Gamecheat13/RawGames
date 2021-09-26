#include maps\_utility;
#include maps\_anim;

#using_animtree("generic_human");


main()
{
	setExpFog(0.00008, .56, .55, .53, 0);
	setCullDist(18000);
	maps\downtown_sniper_anim::main();

	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_snow");

	maps\downtown_sniper_fx::main();
	maps\_load::main();
	maps\_waypoint::squads();
	maps\_groupMove::main();
	//*** Ambient Sounds
	level thread maps\downtown_sniper_amb::main();
	
	setEnvironment ("cold");

	precacheString( &"DOWNTOWN_SNIPER_OBJ_SECURE" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_PICKUP" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_KILL" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_REPULSE" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_REPULSEDONE" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_PANZER" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_HALFTRACK" );
	precacheString( &"DOWNTOWN_SNIPER_OBJ_RESISTANCE" );
	
	precacheItem( "panzerschreck" );
	precacheModel( "xmodel/weapon_panzerschreck_obj" );
	precacheModel( "xmodel/weapon_mosinnagantscoped_cloth_obj" );

	level.flag["soldiers safe"] = false;
	level.flag["sniper exposed"] = false;
	level.flag["aware of sniper"] = false;
	level.flag["intermission"] = false;
	level.flag["major killed"] = false;
	level.flag["kill lieutenant"] = false;
	level.flag["officers killed"] = false;
	level.flag["tank at goal"] = false;
	level.flag["tank commander killed"] = false;
	level.flag["tank destroyed"] = false;
	level.flag["halftrack scene"] = false;
	level.flag["halftrack at goal"] = false;
	level.flag["halftrack destroyed"] = false;
	level.flag["panzerschreck picked up"] = false;
	level.flag["troops protected"] = false;
	level.flag["helmet shot"] = false;
	level.flag["got sniper rifle"] = false;

	level.player takeWeapon( "smoke_grenade_american" );
	

	getEnt( "spotterguy", "script_noteworthy" ) thread VolskySpawner_Think();
	getEnt( "helmetguy", "script_noteworthy" ) thread Soldier4Spawner_Think();
	getEnt( "warningguy", "script_noteworthy" ) thread Soldier1Spawner_Think();
	
	thread Trigger_FloorClear();
	thread Trigger_HelmetMoment();
	thread Propaganda();
	
	thread music_defense();
	thread music_victory();
	
	thread IntroShout();

	level thread initial_retreat();

	getEnt( "snipezone_blocker", "targetname" ) notsolid();
	
	objective_add(1, "active", &"DOWNTOWN_SNIPER_OBJ_SECURE", getObjOrigin("north_building"));
	objective_current(1);
	
	objEvent = getObjEvent("north_building");
	objEvent waittill_objectiveEvent();
	
	battleChatterOff( "allies" );
	level.soldier4 anim_single_solo( level.soldier4, "groundfloorclear" );
	wait .5;
	level.volsky anim_single_solo( level.volsky, "topfloorclear" );
	wait 2;
	objective_state(1, "done");
	level.volsky anim_single_solo( level.volsky, "preparecounter" );
	battleChatterOn( "allies" );
	
	level.wavesRemaining = 4;
	objective_add(4, "invisible", &"DOWNTOWN_SNIPER_OBJ_REPULSEDONE", getObjOrigin("north_building"));
	objective_state(4, "active" );
	objective_string(4, &"DOWNTOWN_SNIPER_OBJ_REPULSE", level.wavesRemaining );
	objective_current(4);
	
	level.player setfriendlychain(getnode("defend_chain", "targetname"));
	thread autosavebyname("cityhall_captured");
	wait (4.0);
	
	assault_groups = [];
	assault_groups[0] = "ge_assault1";
	assault_groups[1] = "ge_assault2";
	assault_groups[2] = "ge_assault3";
	assault_groups = array_randomize(assault_groups);
	
	wait (4.0);
	
	battleChatterOff( "allies" );
	level dialog_attack_starting();
	level thread playSoundInSpace( "walla_german_large", (2432,2624,216) );
	level thread assaultGroup(assault_groups[0]);
	level thread assaultGroup(assault_groups[1]);

	if ( level.gameSkill > 1 )
		level thread assaultGroup(assault_groups[2]);
	
	wait 4;
	level dialog_attack_heretheycome();
	battleChatterOn( "allies" );
	level thread dialog_portable_mg42();
	portable_spawners = getentarray ("ge_portable", "targetname");
	portable_spawners = array_randomize(portable_spawners);
	level thread portableMG42(portable_spawners[0]);
	
	wait (60.0);
	level.wavesRemaining --;
	objective_string(4, &"DOWNTOWN_SNIPER_OBJ_REPULSE", level.wavesRemaining );
	//iprintlnbold("1 minute");	
	
	if ( level.gameSkill < 2 )
		level thread assaultGroup(assault_groups[2]);
	
	level thread dialog_mg42callout();
	building_mgs = getentarray ("frog_sniper", "targetname");
	level thread frogSniperController (building_mgs, 0, "end_building_mgs");
	
	wait (60.0);
	level.wavesRemaining --;
	objective_string(4, &"DOWNTOWN_SNIPER_OBJ_REPULSE", level.wavesRemaining );
	//iprintlnbold("2 minutes");
	
	thread autosavebyname("two_minutes");
	
	level thread portableMG42(portable_spawners[3]);
	level thread portableMG42(portable_spawners[4]);	
	
	wait (60.0);
	level.wavesRemaining --;
	objective_string(4, &"DOWNTOWN_SNIPER_OBJ_REPULSE", level.wavesRemaining );
	//iprintlnbold("3 minutes");
	
	battleChatterOff( "allies" );
	thread spawn_reinforcements(getentarray ("reinforcements", "targetname") );
	level.volsky thread anim_single_solo( level.volsky, "reinforcementscoming1" );
	battleChatterOn( "allies" );
	
	level thread portableMG42(portable_spawners[1]);
	level thread portableMG42(portable_spawners[2]);

	halftrack = level halftrack_setup();
	wait ( 6.0 );
	battleChatterOff( "allies" );
	level.volsky anim_single_solo( level.volsky, "enemyhalftrackapp" );
	level.volsky anim_single_solo( level.volsky, "findantitank" );
	battleChatterOn( "allies" );

	wait (60.0);
	level.wavesRemaining --;
	objective_string(4, &"DOWNTOWN_SNIPER_OBJ_REPULSEDONE" );
	
	thread autosavebyname("fourminutes");
	
	wait 3;
	
	objective_state(4, "done");
	//iprintlnbold("4 minutes");
	
	flag_set ("halftrack scene");
//	halftrack = level halftrack_setup();

	level notify ("assault stop ge_assault1");
	//stop building_mgs
	level notify ("end_building_mgs");

	/*
	if ( level.player getWeaponSlotWeapon( "primary" ) != "panzerschreck" && level.player getWeaponSlotWeapon( "primaryb" ) != "panzerschreck" )
	{
		objective_add(5, "active", &"DOWNTOWN_SNIPER_OBJ_PANZER", (-1721, 2747, 231));
		objective_current(5);
		
		thread Poll_Panzerschreck();
		
		panzerObj show();
		panzerObj_wait();
		panzerObj delete();
		
		objective_string(5, &"DOWNTOWN_SNIPER_OBJ_HALFTRACK");
	}
	else
	{
		objective_add(5, "active", &"DOWNTOWN_SNIPER_OBJ_HALFTRACK", halftrack.origin);
	}

	level notify ("assault stop ge_assault2");

	objective_current(5);
	while (!flag("halftrack destroyed"))
	{
		objective_position(5, halftrack.origin);
		wait (0.05);
	}
	
	objective_state(5, "done");
	*/
	objective_add(6, "active", &"DOWNTOWN_SNIPER_OBJ_RESISTANCE", getObjOrigin("north_building"));
	objective_current(6);
	
	level notify ("assault stop ge_assault3");

	wait 4;
	
	thread kill_mg_gunners();
	println ("zzzzzzzzzzzzzzzzz assault groups retreating");
	axis = getAIArray( "axis" );
	for ( index = 0; index < axis.size; index++ )
		axis[index] setGoalNode( getNode("ge_assault1_retreat_node", "targetname") );
	
	battleChatterOff( "allies" );
	thread spawn_reinforcements(getentarray ("reinforcements", "targetname") );
	level.volsky thread anim_single_solo( level.volsky, "reinforcementscoming2" );
	wait (5.0);
	level.soldier4 anim_single_solo( level.soldier4, "givingup" );
	wait (2.0);
	level.volsky anim_single_solo( level.volsky, "germansfallingback");
	wait (1.0);
	level.soldier4 anim_single_solo( level.soldier4, "runcowardshaha" );

//	level thread playSoundInSpace( "walla_russian_small", (-1152,2880,160) );
	wait (4.0);
	level dialog_victory();
	
	wait (6.0);
	maps\_endmission::nextmission();
	
}

/*
panzerObj_wait()
{
	level endon ( "panzerschreck picked up" );

	while ( true )
	{
		wait ( 20.0 );
		level thread playSoundInSpace( "RU_1_threat_vehicle_halftrack", level.volsky.origin );
		wait ( 2.0 );
		level.volsky thread anim_single_solo( level.volsky, "findantitank" );
	}
}
*/

IntroShout()
{
	level waittill ( "starting final intro screen fadeout" );
	
	thread playSoundInSpace( "RU_1_order_move_generic", level.player.origin );
}	


Propaganda()
{
	getEnt( "propaganda3", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda5", (3071,3200,104) );

	getEnt( "propaganda4", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda6", (3071,3200,104) );
	getEnt( "snipezone_blocker", "targetname" ) solid();
}

/*
Poll_Panzerschreck()
{
	level endon ( "panzerschreck picked up" );

	while ( !flag( "panzerschreck picked up" ) )
	{
		if ( level.player getWeaponSlotWeapon( "primary" ) == "panzerschreck" || level.player getWeaponSlotWeapon( "primaryb" ) == "panzerschreck" )
		{
			flag_set( "panzerschreck picked up" );
			return;
		}
	
		wait ( 0.25 );
	}
}


Trigger_Panzerschreck()
{
	trigger = getEnt( "trigger_panzerschrecks", "targetname" );

	if (level.xenon)
		trigger sethintstring(&"SCRIPT_PLATFORM_HINT_PICKUP_PANZERSCHRECK", getKeyBinding("+usereload")["key1"]);
	else
		trigger sethintstring(&"SCRIPT_PLATFORM_HINT_PICKUP_PANZERSCHRECK", getKeyBinding("+activate")["key1"]);

	slots = getEntArray( trigger.target, "targetname" );

	while ( true )
	{
		trigger waittill ( "trigger" );
		
		if ( flag( "halftrack scene" ) )
			flag_set( "panzerschreck picked up" );
		
		playerWeapons[0] = level.player getWeaponSlotWeapon( "primary" );
		playerWeapons[1] = level.player getWeaponSlotWeapon( "primaryb" );
		
		if ( playerWeapons[0] == "panzerschreck" || playerWeapons[1] == "panzerschreck" )
		{
			level.player giveMaxAmmo( "panzerschreck" );
			level.player switchToWeapon( "panzerschreck" );
			continue;
		}

		// Figure out which slot to put the weapon in, empty slot if one is empty, otherwise overwrite the one the player
		// is currently using.		
		if ( playerWeapons[0] == "none" || playerWeapons[1] == "none" )
		{
			level.player giveWeapon( "panzerschreck" );
			level.player giveMaxAmmo( "panzerschreck" );
			level.player switchToWeapon( "panzerschreck" );		
			continue;
		}

		if ( level.player getCurrentWeapon() == playerWeapons[0] )
			slotToFill = "primary";
		else
			slotToFill = "primaryb";

		weapon = level.player getWeaponSlotWeapon( slotToFill );
		
		// Toss out the player's weapon if he has one
		for ( i = 0; i < slots.size; i++ )
		{
			if ( isDefined( slots[i].groundWeapon ) )
				continue;

			weaponClassname = "weapon_" + weapon;

			gun = spawn ( weaponClassname, (0,0,0) );
			gun.origin = slots[i].origin;
			gun.angles = slots[i].angles;

			gun linkto ( slots[i] );
			slots[i].groundWeapon = gun;
			break;
		}

		level.player takeWeapon( weapon );
		level.player giveWeapon( "panzerschreck" );
		level.player switchToWeapon( "panzerschreck" );
		
		level.player giveMaxAmmo( "panzerschreck" );
	}
}
*/

kill_mg_gunners()
{
	portable_mgs = getentarray ("ge_portable", "targetname");
	building_mgs = getentarray ("ai_frog_sniper", "targetname");
	for (i=0;i<building_mgs.size;i++)
	{
		if (isalive (building_mgs[i]))
		{
			building_mgs[i] dodamage( building_mgs[i].health + 200, (0,0,0) );
			wait 2;
		}
	}
	for (i=0;i<portable_mgs.size;i++)
	{
		if (isalive (portable_mgs[i]))
		{
			portable_mgs[i] dodamage( portable_mgs[i].health + 200, (0,0,0) );
			wait 2;
		}
	}
}


spawn_reinforcements(spawners)
{
	spawned = [];
	for (i=0;i<spawners.size;i++)
	{
		spawners[i].count = 1;
		guy = spawners[i] doSpawn();
		if (spawn_failed(guy))
			continue;
		spawned[spawned.size] = guy;
	}
	return spawned;
}


initial_retreat()
{
	retreaters = getentarray ("retreating_guys", "script_noteworthy");
	array_thread(retreaters, ::spawn_dies_at_goal);
	
	retreaters[0] endon ("death");
	retreaters[0] waittill ("spawned",spawn);
	if (!spawn_failed(spawn))
	{
		spawn playsound ("downtownsniper_gr_retreat1");
		println	("zzzzzzzzzzzzzz  retreating");
		
	}
	
}	

spawn_dies_at_goal()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
		return;
	spawn kill_at_goal();
}

kill_at_goal()
{
	println	("zzzzzzzzzzzzzzzz   will kill at goal");
	self endon ("death");
	self waittill ("goal");
	self dodamage( self.health + 200, (0,0,0) );
	println	("zzzzzzzzzzzzzzz    killed at goal");
}

portableMG42(soldierSpawner)
{
	//soldierSpawner = getent(soldierName, "targetname");
	mg42 = getent (soldierSpawner.target, "targetname");
	
	soldier = soldierSpawner dospawn();
	if (!spawn_failed(soldier))
	{
		soldier.targetname = "ge_portable";
		soldier thread portableMG42Think();
		soldier waittill ("death");
	}
}

portableMG42Think()
{
	self endon ("death");
	
	wait (15.0);
	level notify ("dialog_portable_mg42");
}

assaultGroupRetreat(groupName)
{
	level endon ("assault stop " + groupName);

	while (1)
	{
		level waittill ("assault retreat " + groupName);
		level.assaultGroupRetreat[groupName] = true;
	}
}

assaultGroupAttack(groupName)
{
	level endon ("assault stop " + groupName);

	while (1)
	{
		level waittill ("assault attack " + groupName);
		level.assaultGroupRetreat[groupName] = false;
	}
}

assaultGroup(groupName)
{
	level endon ("assault stop " + groupName);
	
	spawners = getentarray(groupName, "targetname");

	level.assaultGroupRetreat[groupName] = false;
	level thread assaultGroupRetreat(groupName);
	level thread assaultGroupAttack(groupName);
	
	while (1)
	{
		if (level.assaultGroupRetreat[groupName])
			level waittill ("assault attack " + groupName);

		soldiers = [];
		for (i = 0; i < spawners.size; i++)
		{
			soldier = spawners[i] dospawn();
			if (spawn_failed(soldier))
			{
				wait (0.1);
				continue;
			}
			spawners[i].count++;
			soldier.targetname = ("_" + groupName);
			soldier.assaultNode = getnode (spawners[i].target, "targetname");
			soldier.goalradius = 64;
			soldier.interval = 0;
			//soldier.health = 90;
			soldiers[soldiers.size] = soldier;
		}

		goalNode = undefined;

		while (soldiers.size > 0)
		{
			if (level.assaultGroupRetreat[groupName])
			{
				// goalNode = getnode(groupName + "_retreat_node", "targetname");
				for ( index = 0; index < soldiers.size; index++ )
				{
					goalNode = getNode("ge_assault1_retreat_node", "targetname");
					soldiers[index].goalradius = 64;
					soldiers[index] setGoalNode( goalNode );
					soldiers[index] thread DeleteOnGoal_Think();
				}
				return;
			}

			assaultToGoal(soldiers, goalNode, groupName);
			wait (0.25);
			soldiers = assaultGetSoldiers(groupName);
		}
	}
}

DeleteOnGoal_Think()
{
	self endon ( "death" );
	
	self waittill ( "goal" );
	self delete();
}

assaultGetSoldiers(groupName)
{
	liveSoldiers = [];
	soldiers = getentarray("_" + groupName, "targetname");
	for (i = 0; i < soldiers.size; i++)
	{
		if (!isalive(soldiers[i]))
			continue;
			
		liveSoldiers[liveSoldiers.size] = soldiers[i];
	}
	return liveSoldiers;
}

assaultToGoal(soldiers, goalNode, groupName)
{
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);

	trackerEnt = spawnStruct();
	trackerEnt.notAtGoal = 0;

	for (i = 0; i < soldiers.size; i++)
	{
		// used only when retreating
		if (isdefined (goalNode))
		{
			soldiers[i] setgoalnode(goalNode);
			continue;
		}
		
		if (isdefined (soldiers[i].assaultNode))
		{
			trackerEnt.notAtGoal++;
			soldiers[i] thread assaultThink(groupName, trackerEnt);
			soldiers[i] thread assaultThinkDeathWaiter(groupName, trackerEnt);
		}
	}
	
	while ( trackerEnt.notAtGoal )
	{
		trackerEnt waittill ("goalordeath");
	}

	wait randomfloatrange (1.5, 4);
}

assaultThink(groupName, trackerEnt)
{
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);
	
	self endon ( "death" );
	wait randomfloatrange (0, 0.6);
	while ( true )
	{
		if ( isDefined( self.assaultNode.radius ) )
			self.goalradius = self.assaultNode.radius;
			
		self setGoalNode( self.assaultNode );	
		self waittill ( "goal" );

		if ( !isDefined( self.assaultNode.target ) )
		{
			self.assaultNode = undefined;
			self notify ( "reached stop node" );
			trackerEnt.notAtGoal--;
			trackerEnt notify ("goalordeath");
			self.goalradius = 3000;
			self setGoalEntity( level.player );
			return;
		}
		
		if ( isDefined( self.assaultNode.script_noteworthy ) && self.assaultNode.script_noteworthy == "assaultcover" )
		{
			self.assaultNode = getNode( self.assaultNode.target, "targetname" );
			self notify ( "reached stop node" );
			trackerEnt.notAtGoal--;
			trackerEnt notify ("goalordeath");
			return;
		}
		
		self.assaultNode = getNode( self.assaultNode.target, "targetname" );
	}
}

assaultThinkDeathWaiter(groupName, trackerEnt)
{
	self endon ( "reached stop node" );
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);
	
	self waittill ( "death" );
	trackerEnt.notAtGoal--;
	trackerEnt notify ("goalordeath");
}


dialog_mg42callout()
{
	lastDialogs["building1_floor1"] = 0;
	lastDialogs["building1_floor2"] = 0;
	lastDialogs["building1_floor3"] = 0;
	lastDialogs["building2_floor1"] = 0;
	lastDialogs["building2_floor3"] = 0;
	while (1)
	{
		level waittill ("dialog_mg42callout", location);

		if ( getTime() - level.volsky.lastSpoke < 6000 )
			continue;

		level.volsky.lastSpoke = getTime();
			
		lastDialog = lastDialogs[location];
		switch (location)
		{
		case "building1_floor1":
			level.volsky anim_single_solo( level.volsky, "secondfloorleftloud" );
			break;
		case "building1_floor2":
			level.volsky anim_single_solo( level.volsky, "redbuildingleftloud" );
			break;
		case "building1_floor3":
			level.volsky anim_single_solo( level.volsky, "redbldgfourthfloorloud" );
			break;
		case "building2_floor1":
			level.volsky anim_single_solo( level.volsky, "graybldgsecondfloorloud" );
			break;
		case "building2_floor3":
			level.volsky anim_single_solo( level.volsky, "graybldgfourthfloorloud" );
			break;
			
		}
		lastDialog++;
		lastDialogs[location] = lastDialog;
	}
}

dialog_sniperCallout()
{
	level endon ("helmet moment finished");

	while (1)
	{
		level waittill ("dialog_sniperCallout", location);

		switch (location)
		{
		case "building1_floor1":
			level.volsky anim_single_solo( level.volsky, "redbldgsecondfloor" );
			break;
		case "building1_floor2":
			level.volsky anim_single_solo( level.volsky, "thirdfloorleft" );
			break;
		case "building1_floor3":
			level.volsky anim_single_solo( level.volsky, "leftfourthfloor" );
			break;
		case "building2_floor1":
			level.volsky anim_single_solo( level.volsky, "graysecondfloor" );
			break;
		case "building2_floor3":
			level.volsky anim_single_solo( level.volsky, "fourthfloorgray" );
			break;
		}
	}
}


dialog_attack_starting()
{
	level.volsky anim_single_solo( level.volsky, "startingattackloud" );
	level notify ("defense music");
}

dialog_attack_heretheycome()
{
	level.soldier4 anim_single_solo( level.soldier4, "heretheycome" );
}

dialog_portable_mg42()
{
	level endon ( "halftrack scene" );
	lastDialog = 0;
	randomLines = 2;
	while (1)
	{
		level waittill ("dialog_portable_mg42");
		
		if ( getTime() - level.volsky.lastSpoke < 6000 )
			continue;

		level.volsky.lastSpoke = getTime();

		if (lastDialog == 0)
		{
			level.volsky anim_single_solo( level.volsky, "mg42frontlinesloud" );
		}
		else if (lastDialog == 1)
		{
			level.volsky anim_single_solo( level.volsky, "anothermg42loud" );
		}
		else
		{
			if (randomint(randomLines) < 1)
				level.volsky anim_single_solo( level.volsky, "mg42squareloud" );
			else if (randomint(randomLines) < 2)
				level.volsky anim_single_solo( level.volsky, "mg42movingfrontlineloud" );
			else if (randomint(randomLines) < 3)
				level.volsky anim_single_solo( level.volsky, "anotherinsquareloud" );
		}
		lastDialog++;
	}
}

dialog_victory()
{
	level notify ("absolute victory");
	battleChatterOff( "allies" );	
	level.volsky anim_single_solo( level.volsky, "numbersdidntcomeup" );
//	soldier playsound ("downtownsniper_volsky_facistsretreating");
}

deleteSelf()
{
	self delete();
}

frogSniperController (snipers, doubleChance, endonString)
{
	level endon (endonString);
	self notify ("frogSniperController");
	self endon ("frogSniperController");
	
	liveFrogSnipers = 0;
	
	sniperStruct = spawnstruct();
	sniperStruct.count = 0;
	
	while (1)
	{
		if (liveFrogSnipers == 0) 
		{
			temp = randomFloatRange(5.0, 10.0);
			println ("zzzzzzzzzzzzzzzzzzzz wait:" + temp);
			wait (temp);
			
			
			if (randomfloat (1) > doubleChance)
				numSnipers = 1;
			else
				numSnipers = 2;

			while (liveFrogSnipers < numSnipers)
			{
				sniper = snipers[randomint(snipers.size)] dospawn();
				if (spawn_failed (sniper))
					continue;
				
				level notify ("frog sniper spawned");
				liveFrogSnipers++;
				sniper thread deathWaiter("frog sniper died");
				sniper thread frogSniperThink();
				sniper.isSuppressable = false;
				sniper.health = 1;
				sniper.suppressionwait = 0;
				sniper.accuracy = 100;
				sniper.goalradius = 32;
				sniper.targetname = "ai_frog_sniper";
				sniper.health = 75;
			}
		}
		
		while (liveFrogSnipers > 0)
		{
			level waittill ("frog sniper died");
			liveFrogSnipers--;
		}
	}
}


frogSniperThink ()
{
	self endon ("death");
	
	self waittill ("goal");
	wait (randomFloatRange(1.5, 4.0));
	level notify ("dialog_mg42callout", self.script_noteworthy);
}


hint_display(text, time)
{
	hintElem = newHudElem();
	hintElem.x = 320;
	hintElem.y = 260;
	hintElem.alignX = "center";
	hintElem.alignY = "middle";
	hintElem.fontScale = 1;
	hintElem setText(text);
	wait (time);

	hintElem fadeOverTime(0.3); 
	hintElem.alpha = 0;
	wait (0.3);
	hintElem destroy();
}

helmet_obj()
{	
	helmet_obj_org = (-1404,1654,52);

	objective_add(2, "active", &"DOWNTOWN_SNIPER_OBJ_PICKUP", helmet_obj_org);
	objective_current(2);

	while ( level.player getWeaponSlotWeapon( "primary" ) != "mosin_nagant_sniper" && level.player getWeaponSlotWeapon( "primaryb" ) != "mosin_nagant_sniper" )
		wait 0.1;

	flag_set("got sniper rifle");
	objective_state(2,"done"); 
	
	
	objective_add(3, "active", &"DOWNTOWN_SNIPER_OBJ_KILL", helmet_obj_org);
	objective_current(3);
	level waittill ( "helmet moment finished" );
	
	wait 1;
	objective_state(3,"done"); 
	objective_current(1); 
	
	level.player setfriendlychain(getnode("after_sniper_chain", "targetname"));
}


VolskySpawner_Think()
{
	self.script_friendname = "Lt. Dimitri Volsky";

	self waittill ( "spawned", soldier );
	spawn_failed( soldier );
	
	level.volsky = soldier;
	level.volsky.animname = "volsky";
	level.volsky thread magic_bullet_shield();
	level.volsky.atGoal = false;
	level.volsky thread FriendlyFire_DamageCheck();

	level.volsky.dontavoidplayer = true;
	level.volsky.ignoreme = true;
	level.volsky.goalradius = 24;
	level.volsky forceGoal( true );

	level waittill ("sniper music");
	
	goalNode = getNode( "spotter_node", "targetname");
	level.volsky setGoalNode( goalNode );
	level.volsky waittill ( "goal" );
	level.volsky.atGoal = true;
	
	level waittill ( "play helmet moment" );
	goalNode anim_reach_solo( level.volsky, "turnbacktwitch" );
	level.volsky thread anim_loop_solo( level.volsky, "idle", undefined, "stopidle" );
	
	level waittill ( "sniper spawned" );
	level.volsky notify ( "stopidle" );

	level waittill ( "helmet moment finished" );
	
	level.volsky.dontavoidplayer = false;
	level.volsky.ignoreme = false;
	level.volsky.goalradius = 128;
	level.volsky forceGoal( false );
	
	level.volsky.lastSpoke = 0;
}

Soldier4Spawner_Think()
{
	self waittill ( "spawned", soldier );
	spawn_failed( soldier );
	
	level.soldier4 = soldier;
	level.soldier4.animname = "soldier4";
	level.soldier4 thread magic_bullet_shield();
	level.soldier4.atGoal = false;
	level.soldier4.name = "Pvt. Pavel Semenov";
	level.soldier4.bcName = "Pavel";
	level.soldier4.bcRank = "private";
	level.soldier4 thread FriendlyFire_DamageCheck();

	level.soldier4.dontavoidplayer = true;
	level.soldier4.ignoreme = true;
	level.soldier4.goalradius = 24;
	level.soldier4.anim_forced_cover = "hide";
	level.soldier4 forceGoal( true );

	level waittill ("sniper music");

	level.soldier4 setGoalNode( getNode( "helmet_node", "targetname") );
	level.soldier4 waittill ( "goal" );
	level.soldier4.atGoal = true;
	
	level waittill ( "play helmet moment" );
	
	while ( !flag( "helmet shot" ) )
		level.soldier4 HelmetSoldier_HelmetAnim( getNode( "helmet_node", "targetname") );
		
	level waittill ( "helmet moment finished" );

	level.soldier4.dontavoidplayer = false;
	level.soldier4.ignoreme = false;
	level.soldier4.anim_forced_cover = "show";
	level.soldier4.goalradius = 128;
	level.soldier4 forceGoal( false );
}


Soldier1Spawner_Think()
{
	self waittill ( "spawned", soldier );
	spawn_failed( soldier );
	
	level.soldier1 = soldier;
	level.soldier1.animname = "soldier1";
	level.soldier1 thread FriendlyFire_DamageCheck();
	level.soldier1 thread magic_bullet_shield();
}


Trigger_FloorClear()
{
	getEnt( "trigger_floorclear", "targetname" ) waittill ( "trigger" );

	battleChatterOff( "allies" );
	level.soldier1 anim_single_solo( level.soldier1, "firstfloorisclear" );
}

Trigger_HelmetMoment()
{
	getEnt( "helmet_moment", "targetname" ) waittill ( "trigger" );

	getEnt( "sniper_zone", "targetname" ) thread Trigger_SniperZone();

	level.soldier1 notify ( "stop magic bullet shield" );
	level.soldier1.deathanim = %death_stand_dropinplace;
	playFXOnTag( level._effect["helmet_hit"], level.soldier1, "J_helmet" );
	level.soldier1 playSound( "bullet_small_metal" );
	level.soldier1 doDamage( level.soldier1.health + 100, level.soldier1.origin );
	magicBullet( "kar98k_sniper", (-860,2074,287), (-860,2074,288) );

	wait ( 0.5 );
	
	soldiers = getEntArray( "scattersoldier", "script_noteworthy" );
	level playSoundInSpace( "RU_3_threat_infantry_sniper", (-1480,1823,92) );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( !isAlive( soldiers[index] ) )
			continue;
		soldiers[index] setGoalNode( getNode( soldiers[index].target, "targetname" ) );
		wait ( randomFloat( 0.25) );
	}

	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index].ignoreme = true;

	level notify ("sniper music");

	level thread dialog_sniperCallout();
	while ( !level.volsky.atGoal || !level.soldier4.atGoal )
		wait ( 0.05 );

	wait ( 1.5 );
		
	thread helmet_obj();
	if ( !flag("got sniper rifle") )
	{
		rifle = getEnt( "mosin_nagant_sniper", "targetname" );

		if ( isDefined( rifle ) )
		{	
			objRifle = spawn( "script_model", rifle.origin );
			objRifle setModel( "xmodel/weapon_mosinnagantscoped_cloth_obj" );
			objRifle.angles = rifle.angles;
			level.volsky anim_single_solo( level.volsky, "pickuprifle" );
			flag_wait("got sniper rifle");
			objRifle delete();
		}
	}
	
	level.volsky anim_single_solo( level.volsky, "waitpavel" );
	autoSaveByName( "doit" );
	level.volsky anim_single_solo( level.volsky, "paveldoit" );
	level.soldier4 anim_single_solo( level.soldier4, "yescomrade" );	
	level notify ( "play helmet moment" );
	
	flag_wait( "helmet shot" );
	sniperSpawners = getEntArray( "sniperguy", "targetname" );
	sniper = undefined;
	while ( !isdefined( sniper ) )
	{
		sniper = sniperSpawners[randomInt( sniperSpawners.size )] dospawn();
		if ( spawn_failed( sniper ) )
		{
			sniper = undefined;
			wait ( 0.1 );
			continue;
		}
		// attach the glint
		sniper thread SniperThink();
	}
	
	level notify ( "sniper spawned" );
	sniper thread SniperHint_Thread();
	
	sniper waittill ( "death" );
	
	wait ( 2.0 );
	level notify ( "helmet moment finished" );
	level notify ( "stop sniper music" );
	level.soldier4 anim_single_solo( level.soldier4, "hesdead" );
	level.volsky anim_single_solo( level.volsky, "letsmoveon" );
	battleChatterOn( "allies" );	
	level.volsky setGoalentity( level.player );
	level.soldier4 setGoalentity( level.player );

	soldiers = getEntArray( "scattersoldier", "script_noteworthy" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( !isAlive( soldiers[index] ) )
			continue;
		soldiers[index] setGoalEntity( level.player );
		wait ( randomFloat( 0.25) );
	}

	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index].ignoreme = false;

}


SniperHint_Thread()
{
	self endon ( "death" );

	level notify ( "dialog_sniperCallout", self.script_noteworthy );
	wait ( randomFloatRange( 20.0, 40.0 ) ); 
	
	while ( true )
	{
		forward = anglesToForward(level.player.angles);
		if (vectordot(forward, vectornormalize(self.origin - level.player.origin)) > 0.984 ) // 10 fov
			level notify ( "dialog_sniperCallout", self.script_noteworthy );
		
		wait ( randomFloatRange( 30.0, 60.0 ) ); 
	}
}

HelmetSoldier_HelmetAnim( goalNode )
{
	self endon ( "player exposed" );

	goalNode anim_reach_solo( self, "ready" );
	goalNode anim_single_solo( self, "ready" );
	goalNode thread anim_loop_solo( self, "loop", undefined, "stoploop" );
	wait ( randomFloatRange( 3.0, 5.0 ) );
	goalNode notify ( "stoploop" );
	playFXOnTag( level._effect["helmet_hit"], self, "J_helmet" );
	self playSound( "bullet_small_metal" );
	wait ( 0.25 );
	magicBullet( "kar98k_sniper", (-500,2736,392), (-500,2736,392) );
	goalNode anim_single_solo( self, "react" );
	self setgoalnode ( goalNode );
	
	flag_set( "helmet shot" );
}

FriendlyFire_DamageCheck()
{
	while( true )
	{
		self waittill ( "damage", damage, attacker, direction, point, method );
		
		if (attacker != level.player)
			continue;
		
		if ( (isdefined(method)) && (method == "MOD_GRENADE_SPLASH") )
			continue;
			
		break;
	}

	setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
	maps\_utility::missionFailedWrapper();
}

SniperThink()
{
	self endon ("death");
	self.goalradius = 16;
	self.ignoreme = true;
	self.health = 1;
	self.baseAccuracy = 100;
	self.accuracy = 100;
	nodes = getnodearray (self.target, "targetname");
	while (1)
	{
		self setgoalnode (nodes[randomint (nodes.size)]);
		self waittill ("goal");
		wait randomfloatrange (1, 4.0);
	}
}

Trigger_SniperZone()
{
	level endon ( "helmet moment finished" );

	awarenessTime = 0;
	while ( true )
	{
		playerExposed = level.player isTouching( self );
		if ( playerExposed )
		{
			//level.player.ignoreme = false;
			
			if ( awarenessTime <= 0 )
				awarenessTime = 0.05;
			else
				awarenessTime += 0.05;
		}
		else
		{
			//level.player.ignoreme = true;

			if ( awarenessTime > 0 )
				awarenessTime = -0.05;
			else
				awarenessTime -= 0.05;
		}

		if ( flag( "helmet shot" ))
		{
			if ( awarenessTime > 3.0 )
			{
				level notify ( "player exposed" );
				magicBullet( "kar98k_sniper", (-500,2736,392), level.player.origin );
				wait ( 0.2 );
				level.player doDamage( level.player.health + 100, level.player.origin );
				// damage/kill the player
				return;
			}
		}
		else
		{
			if ( awarenessTime > 1.0 )
			{
				level notify ( "player exposed" );
				magicBullet( "kar98k_sniper", (-500,2736,392), level.player.origin );
				wait ( 0.2 );
				level.player doDamage( level.player.health + 100, level.player.origin );
				// damage/kill the player
				return;
			}
		}
		wait (0.05);
	}
}


halftrack_setup()
{
	halftrack = maps\_vehicle::scripted_spawn(0);
	//halftrack[0] thread halftrack_stop();
	halftrack[0] thread halftrack_death();
	thread maps\_vehicle::gopath(halftrack[0]);
	htriders = halftrack[0].riders;
	for (i=0;i<htriders.size;i++)
		htriders[i] thread halftrack_riders_think();
	return halftrack[0];
}

halftrack_riders_think()
{
	self endon ("death");
	
	level waittill ("halftrack destroyed");
	
	goalNode = getNode("ge_assault1_retreat_node", "targetname");
	self.goalradius = 64;
	self setGoalNode( goalNode );
	
	self thread DeleteOnGoal_Think();
}

halftrack_death()
{
	self waittill ("death");
	println	("zzzzzzzzzzzzzz   halftrack destroyed");
	flag_set("halftrack destroyed");
}

halftrack_stop()
{
	node = getvehiclenode("tank_stop","script_noteworthy");
	node waittill("trigger");
	self setspeed(0,40);
	wait 2;
	//flag_wait ("halftrack at goal");
	self notify ("unload");
}

music_defense()
{
	//Activates when the guy says "They're starting the attack!!!"
	
	level endon ("absolute victory");
	
	level waittill ("defense music");
	musicstop(1);
	wait 0.1;
	
	while(1)
	{
		musicplay("soviet_tension_medium01");
		wait 71;
	}
}

music_victory()
{
	level waittill ("absolute victory");
	musicstop(4);
	wait 4.1;
	
	musicplay("soviet_victory_light01");
}

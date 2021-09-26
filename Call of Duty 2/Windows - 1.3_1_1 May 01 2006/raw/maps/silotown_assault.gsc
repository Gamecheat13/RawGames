/****************************************************************************

Level: 		OUTSKIRTS OF BEAUMONT-HAGUE (silotown_assault.bsp)
Campaign: 	American Rangers Normandy
Objectives: 	1. Await new orders from Sgt. Randall.
		2. Cover the squad's advance (50% must survive.)
		[3. Move into the village and destroy the nebelwerfer halftracks. (3 remaining)
		[4. Clear out the enemy-held buildings in the village. (6 remaining)
			a. Capture the stone farmhouse at the south end of town.
			b. Clear the barn of enemy infantry.
			c. Secure the inn at the north end of town.
			d. Seize the house overlooking the fork in the road.
			e. Take control of the sign-covered house at the main intersection.
			f. Neutralize the German fire direction center in the manor to the west.
		5. Regroup with the squad at the intersection.
		6. Get to the top of the silo with Pvt. Braeburn and Pvt. McCloskey.
		7. Neutralize the German mortar crews.
		8. Hold off the German counterattack until reinforcements arrive. (3 minutes)
		9. Assemble with the reinforcements.
		
*****************************************************************************/

/*
	skipto cvars

	field
	town
	midbriefing
	defense
	victory

*/

#include maps\_utility;
#include maps\_anim;

main()
{	
	setExpFog(0.00005, 0.6484, 0.6484, 0.6015, 0);
	
	maps\_flak88::main("xmodel/german_artillery_flak88_nm");
	maps\_sherman::main("xmodel/vehicle_american_sherman");
	maps\_halftrack::main("xmodel/vehicle_halftrack_rockets_woodland");

	maps\silotown_assault_fx::main(); // This must be loaded before main or createFx and tread overrides won't work
	level.smokegrenade = loadfx("fx/explosions/smoke_grenade.efx");
	maps\_load::main();
	maps\_mortarTeam::main();
	maps\silotown_assault_anim::main();
	
	level.xenon = false;
	
	if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
		level.xenon = true;
	
	if (getcvar("scr_silotown_minspec") == "")
		setcvar("scr_silotown_minspec","0");
	
	if(!level.xenon && (getcvarint("scr_silotown_minspec") > 0))
	{
		setCullDist(4800);
		thread minspec_cull_field();
		thread minspec_cull_town();
		thread minspec_cull_silo();
	}
	
	thread town_tankmove("sherman1");
	thread town_tankmove("sherman2");
	thread town_tankmove("sherman3");
	thread town_tankmove("sherman4");
	thread town_tankmove("sherman5");
	thread town_tankmove("sherman6");
	thread town_tankmove("sherman7");

	//*** Precaching
		
		precacheString(&"SILOTOWN_ASSAULT_REINFORCEMENTS");
		precacheString(&"SILOTOWN_ASSAULT_FRIENDLY_FIRE_WILL_NOT");
		precacheString(&"SILOTOWN_ASSAULT_SUPPORT_THE_SQUADS_ADVANCE");
		precacheString(&"SILOTOWN_ASSAULT_CLEAR_THE_BARN_OF_ENEMY");
		precacheString(&"SILOTOWN_ASSAULT_SECURE_THE_POST_OFFICE");
		precacheString(&"SILOTOWN_ASSAULT_CAPTURE_THE_STONE_FARMHOUSE");
		precacheString(&"SILOTOWN_ASSAULT_SEIZE_THE_HOUSE_OVERLOOKING");
		precacheString(&"SILOTOWN_ASSAULT_TAKE_CONTROL_OF_THE_SIGNCOVERED");
		precacheString(&"SILOTOWN_ASSAULT_CLEAR_THE_GERMAN_FIELD");
		precacheString(&"SILOTOWN_ASSAULT_REGROUP_WITH_THE_SQUAD");
		precacheString(&"SILOTOWN_ASSAULT_GET_TO_THE_TOP_OF_THE");
		precacheString(&"SILOTOWN_ASSAULT_GET_THE_GERMAN_SNIPER");
		precacheString(&"SILOTOWN_ASSAULT_WATCH_OUT_FOR_AN_ENEMY");
		precacheString(&"SILOTOWN_ASSAULT_SNIPE_THE_ENEMY_MORTAR");
		precacheString(&"SILOTOWN_ASSAULT_HELP_THE_REINFORCEMENTS");
		precacheString(&"SILOTOWN_ASSAULT_DEBRIEF_WITH_SGT_RANDALL");
		precacheString(&"SILOTOWN_ASSAULT_ELIMINATE_THE_ENEMY_INFANTRY");
		precacheShader("objectiveA");
		precacheShader("objectiveB");
		precacheShader("objectiveC");
		precacheShader("objectiveD");
		precacheShader("objectiveE");
		precacheShader("objectiveF");
		
		precacheModel("xmodel/weapon_kar98_scoped_obj");
		
		precacheRumble("artillery_quake");

	//*** Ambient Sounds
	
		level thread maps\silotown_assault_amb::main();
		
	//*** Dev Cvars
		
		if (getcvar("skipto") == "")
		{
			setcvar ("skipto", "");
		}
		
		if (getcvar("print3d") == "")
		{
		 	setcvar ("print3d", "off");
		}
		
		if (getcvar("defendtime") == "")
		{
			setcvar ("defendtime", "");
		}
		
		if (getcvar("constantAttackDiag") == "")
		{
			setcvar ("constantAttackDiag", "");
		}
		
		if (getcvar("buddyPopDiag") == "")
		{
			setcvar ("buddyPopDiag", "");
		}
		
	//*** Level Variables and Flags & Tweakables for difficulty-based mission paramters
	
		level.mortar = loadfx("fx/explosions/grenadeExp_wood.efx");
		level.siloblast = loadfx("fx/explosions/tank_impact_libya.efx");
		level.silodeathfx = loadfx("fx/explosions/mortarExp_concrete.efx");
		//level.silodeathfx = loadfx("fx/explosions/grenadeExp_dirt.efx");
		
		flag_clear("30cal may fire");
		flag_clear("30cal is setup");
		flag_clear("randall at jumpoff");
		flag_clear("all in position");
		flag_clear("player has joined the battle");
		flag_clear("field completed");
		flag_clear("dialogue getuphere done");
		flag_clear("field attack started");
		flag_clear("silo beheaded");
		flag_clear("doc arrived at bof");
		flag_clear("player in silo");
		flag_clear("defenders in position");
		flag_clear("town invaded");
		flag_clear("retreating");
		flag_clear("area secure");
		
		flag_clear("field_sector_1");
		flag_clear("field_sector_2");
		flag_clear("field_sector_3");
		flag_clear("field_sector_4");
		flag_clear("field_sector_5");
		
		flag_clear("resetFriendlyTownStats");
		
		flag_clear("player_rushed_field");
		
		flag_clear("player_killed_one_guy");
		
		flag_clear("bermSave_triggered");
		
		flag_clear("player_has_sniper_rifle");
		
		flag_clear("timed_defense");
		
		flag_clear("playerArrivedBerm");
		
		flag_clear("silo_occupied");
		
		//Silo model
		
		level.eSiloIntact = getent("silomodel_intact", "targetname");
		level.eSiloBreached = getent("silomodel_breached", "targetname");
		level.eSiloPieces = getent("silomodel_pieces", "targetname");
		level.eSiloHatch = getent("siloHatch", "targetname");
		level.eSiloBreached hide();
		level.eSiloPieces hide();
		
		level.fieldTeamSpawnAmount = 0;
		level.braeburnSpeech = 0;
		level.randalltalking = true;	//keeps Braeburn from yelling 'come back here' dialog at the player when Randall is talking
		level.bermbanter = 0; //indicates that the dialogue banter at the berm is happening so everyone be quiet
		
		level.enemyTypeOld = "null";
		level.enemyDestOld = "null";
		
		//MG teams only show up once (nearwindow, leftgap, rightgap)
		//Mortar teams only show up once (leftgap, rightgap)
		//Rifle teams (stonewall, rightgap, leftgap, flak88, bridge)
		//Snipers (farwindow, nearwindow, rightgap, leftgap, barnroof)
		
		level.bridgeTaken = 0;
		level.nearwindowTaken = 0;
		level.farwindowTaken = 0;
		level.leftgapTaken = 0;
		level.rightgapTaken = 0;
		level.stonewallTaken = 0;
		level.flak88Taken = 0;
		level.barnroofTaken = 0;
		
		level.fieldAdvanceBaglimit = 3;	//number of enemies player must kill to make flankers advance
		
		level.garciaPlanting = 0;
		level.hawkinsPlanting = 0;
		level.rosettiPlanting = 0;
		level.jonesPlanting = 0;
		level.lentzPlanting = 0;
		
		level.victory = 0;
		level.iRosterMax = 18;
		level.spawnLock = 0;
		
		level.mortarIndexSize = 8;	//number of indices available when using objective_additionalposition
		level.mortarObjNumber = 5; 	//objective index of the 'defend against mortar teams' obj (in case it changes)
		
		level.earlystart = false;
		level.buildingscleared = 0;
		
		//level.introFollowersKilled = 0;
		
		level.createdMortars = 0;
		level.totalMortars = 6;
		
		level.savehere = true;
		
		level.player.oldthreatbias = level.player.threatbias;
		
		level.busyFriendlyChannel = false; //keep hint dialogue from stomping itself
		
		//Axis Squads

		level.strAlpha = "alpha";
		level.strBeta = "beta";
		level.strGamma = "gamma";
		level.strDelta = "delta";
		level.strEpsilon = "epsilon";
		level.strZeta = "zeta";
		level.strEta = "eta";
		level.strTheta = "theta";
		level.strIota = "iota";
		level.strKappa = "kappa";
		level.strLambda = "lambda";
		level.strMu = "mu";
		level.strNu = "nu";
		level.strXi = "xi";
		
		/*
		level.strOmikron = "omikron";
		level.strPi = "pi";
		level.strRho = "rho";
		level.strSigma = "sigma";
		level.strTau = "tau";
		*/
		
		//Depending on difficulty
			//some max number of enemy teams are allowed to deploy during the field charge
			//time to guaranteed friendly death during field charge will change for the various enemy squad types
			//++++adjust the time to death for the base setup time where applicable (mortars, mg42s)
			//++++cvar needed for CONSOLE vs. PC values, these are all CONSOLE values
			
		level.gameSkill = getcvarint("g_gameskill");
		
		//!!Fader
		
		level.fieldTeamSpawnLimit = 6;
		
		//!Fader - time between enemy squad spawns
		
		level.fSpawnInterval = 3;
		
		if (level.gameSkill == 0)
		{
			level.mortarTeamPopLimit = 2;		//!!Fader, max number of mortar teams to spawn/active at a time
			level.mortarMisses = 16;				//!!Fader - number of times a mortar team will miss before killing the player
			level.mortarDeployGap = 16;		//!!Fader, time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarTeamGapTime = 15;		//!!Fader, time between death of a team and spawning of new team (nonoverlap spawns)
			
			level.protectplayer = true;
			level.saveCrawlTime = 20;
			level.saySmokeHint = true;
			
			thread smokegrenade_booster();
		}
		if (level.gameSkill == 1)
		{
			level.mortarTeamPopLimit = 3;		//!!Fader, max number of mortar teams to spawn/active at a time
			level.mortarMisses = 8;				//!!Fader - number of times a mortar team will miss before killing the player
			level.mortarDeployGap = 16;			//!!Fader, time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarTeamGapTime = 14;		//!!Fader, time between death of a team and spawning of new team (nonoverlap spawns)
			
			level.protectplayer = true;
			level.saveCrawlTime = 45;
			level.saySmokeHint = true;
			
			thread smokegrenade_booster();
		}
		if (level.gameSkill == 2)
		{
			level.mortarTeamPopLimit = 3;	//!!Fader, max number of mortar teams to spawn/active at a time
			level.mortarMisses = 4;			//!!Fader - number of times a mortar team will miss before killing the player
			level.mortarDeployGap = 10;		//!!Fader, time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarTeamGapTime = 12;	//!!Fader, time between death of a team and spawning of new team (nonoverlap spawns)
			
			level.protectplayer = false;
			level.saveCrawlTime = 75;
			level.saySmokeHint = false;
		}
		if (level.gameSkill == 3)
		{
			level.mortarTeamPopLimit = 4;	//!!Fader, max number of mortar teams to spawn/active at a time
			level.mortarMisses = 2;			//!!Fader - number of times a mortar team will miss before killing the player
			level.mortarDeployGap = 7;		//!!Fader, time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarTeamGapTime = 10;	//!!Fader, time between death of a team and spawning of new team (nonoverlap spawns)
			
			level.protectplayer = false;
			level.saySmokeHint = false;
		}
		
		level.mortarTeamSlots = 0;					//number of currently occupied mortar team slots
		level.defense_mortarphase_totalteams = 0;	//running total of mortar teams destroyed by player
		level.mortarActiveTeams = 0;				//monitor, actual number of mortar teams active, not slots used
		
		if(getcvar("defendtime") != "dev")
		{
			level.stopwatch = 2.5;	//final battle requisite length in minutes
		}
		else
		{
			level.stopwatch = 0.5;	//fast forward for LD testing
		}
		
		level.friendlyForwardDistance = 1000;
		level.friendlyPopLimit = 7;
		level.firstrun = false;
		
		level.lastFriendlyArea = "entrystartingarea";
		
		level.surveyTime = 12;
		
		level.failsafeTime = 90;
		
	//*** Threads
	
		setupCharacters();
		
		if (getcvar("skipto") == "" || getcvar("skipto") == "field")
		{
			level thread intro();
			level thread intro_earlystart();
			level thread field_charge_mccloskey_spawn();
			level thread friendly_stance();
			level thread field_charge();
			level thread flak88_crew_setup();
			
			level thread field_charge_init();
			level thread field_enemy_defeat();
			level thread field_axis_wakeupcall();
			level thread field_nearmiss();
			level thread field_charge_dialogue_override();
			level thread field_charge_with_signal();
			level thread field_playercrossing();
			level thread field_enemy_selection();
			level thread field_mccloskey_traverse();
			level thread field_braeburn_traverse();
			level thread field_bof_banter();
			level thread field_player_rush_alert();
			
			level thread field_advance_triggers();
			
			level thread music_intro();
			
			level thread bermSave();
			
			level thread playerRushKill();
			
			level thread field_charge_playerwait();
		}
		
		if (getcvar("skipto") == "town")
		{
			//skip_teleport_init(teleporter, playerOrigin)
			skiptotown_init();	
			level thread skip_teleport_init("skiptotown_teleporter", (-1172, -203, 30));
		}
		
		if (getcvar("skipto") == "midbriefing")
		{
			skiptownbattle_init();
			level thread skip_teleport_init("skiptotown_teleporter", (622, 1676, 47));
		}
		
		if (getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
		{
			playerNode = getent("skiptoinfantry_player_teleporter", "targetname");
			level thread skip_teleport_init("skiptoinfantry_teleporter", playerNode.origin);
			skiptownbattle_init();
		}
		
		if (getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town")
		{
			level thread town_player_arrival();
			level thread town_endless_skirmish();
			level thread town_welcomewagon();
			level thread portable_mg42_moment_setup();
			level thread constantAttack();
			level thread playerBuddiesStart();
			level thread buddyPopMonitor();
			level thread dialogue_smokehint_init();
			level thread targets_of_opportunity();
			
			if(level.gameSkill != 3)
			{
				thread saveCrawl();
			}
		}

		if (getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing" || getcvar("skipto") == "defense")
		{
			level thread town_defense_preparations();
			level thread town_defense();
			level thread town_defense_autosaves();
			level thread town_silo_climb();		
			level thread town_timed_defense();
			level thread town_silo_ladder_handling();
			level thread town_silo_solidify();
			
			level thread mortarteam_announcement_dialogue();
		}
		
		if (getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing" || getcvar("skipto") == "defense" || getcvar("skipto") == "retreat")
		{
			level thread town_german_evac();
		}
		
		level thread nobacktrack();
		level thread town_tankspawn();
		level thread objectives();
		
		//Force field as a failsafe to keep player from busting past McCloskey in the silo
		failSafeBlocker = getent("playerRestraint", "targetname");
		failSafeBlocker notsolid();
		failSafeBlocker connectpaths();
}

smokegrenade_booster()
{
	//extra pack of smoke grenades on farmbldg crates
			
	item = spawn("weapon_smoke_grenade_american", (-341, 2475, 26), 1); // suspended
	item.angles = (0, 123.75, -90);
}

minspec_cull_field()
{
	trig = getent("minspec_field", "targetname");
	
	while(1)
	{	
		trig waittill ("trigger");
		setCullDist (4800);
	}
}

minspec_cull_town()
{
	trig = getent("minspec_town", "targetname");
	
	while(1)
	{
		trig waittill ("trigger");
		setCullDist (2800);
	}
}

minspec_cull_silo()
{
	trig = getent("minspec_silo", "targetname");
	
	while(1)
	{
		trig waittill ("trigger");
		setCullDist (16000);
	}
}

intro()
{
	aAllies = getaiarray("allies");
	aFollowNodes = getnodearray("intro_follownode", "targetname");
	eSgtStartNode = getnode("intro_randall_node", "targetname");
	
	level.aNamedGuys = [];
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && ((aAllies[i].script_friendname == "Pvt. Garcia") || (aAllies[i].script_friendname == "Pvt. Hawkins") || (aAllies[i].script_friendname == "Pvt. Rosetti") || (aAllies[i].script_friendname == "Pvt. Jones") || (aAllies[i].script_friendname == "Pvt. Lentz")))
		{
			level.aNamedGuys[level.aNamedGuys.size] = aAllies[i];
		}
	}
	
	for(i=0; i<aAllies.size; i++)
	{
		//Keep Allies from reacting to Axis before the field charge
		
		if(isdefined(aAllies[i].targetname) && aAllies[i].targetname != "randall")
		{	
			//Friendlies already in the pit
			aAllies[i] allowedStances ("crouch");
			aAllies[i].dontavoidplayer = true;
		}
	}
	
	wait 0.05;
	
	//Sgt. Randall running up to deliver briefing
	
	level.randall allowedStances ("stand");
	level.randall setgoalnode(eSgtStartNode);
	level.randall.goalradius = 16;
	level.randall thread intro_briefing();
	
	if (getcvar ("skipto") == "" || getcvar ("skipto") == "field")
	{
		//Follower array setup
		
		wait 5;
		
		aFollowers = [];
		for(i=0; i<aAllies.size; i++)
		{
			if(isdefined(aAllies[i].targetname) && aAllies[i].targetname == "intro_follower")
			{
				aFollowers[aFollowers.size] = aAllies[i];
			}
		}
		
		for(i=0; i<aFollowers.size; i++)
		{
			//Friendlies who jump into start area from behind
			if(isdefined(aFollowNodes[i]))
			{
				aFollowers[i] setgoalnode(aFollowNodes[i]);
				aFollowers[i].goalradius = 16;
				//aFollowers[i] thread introFollowerDeath();
			}
		}
	}
}

/*
introFollowerDeath()
{
	self waittill ("death");
	level.introFollowersKilled++;
}
*/

intro_earlystart()
{
	//eTrig = getent("early_start", "targetname");
	//eTrig waittill ("trigger");
	
	trig = getent("mccloskey_spawntrig", "targetname");
	trig waittill ("trigger");
	
	level.earlystart = true;
	level notify ("go to jumpoff points");
}

intro_briefing()
{
	if (getcvar ("skipto") == "")
	{
		thread grenadeAwareness(false);
		
		battleChatterOff("allies");
		
		intro_speech();
	}
	
	level notify ("go to jumpoff points");
	
	trig = getent("mccloskey_spawntrig", "targetname");
	trig notify ("trigger");
	
	if(level.protectplayer)
	{
		level.player.ignoreme = true;
	}
	else
	{
		switch(level.gameskill)
		{
			case 2: 
				level.player.threatbias = 300;
				break;
			case 3: 
				level.player.threatbias = 1000;
				break;
		}	
	}
		
	thread autoSaveByName ("introdone");	
}

intro_speech()
{
		wait 0.05;
		
		//DIALOGUE: "Sounds like we've got screaming meemies up ahead, but I couldn't make visual contact."
		level.randall Dialogue_Thread("silotown_rnd_screamingmeemies");
		
		wait 0.25;
		
		//DIALOGUE: "I did spot an 88 on the other side of this hedgerow. Expect a crew of at least two and a couple of MG42s."
		level.randall Dialogue_Thread("silotown_rnd_spot88");
		
		wait 0.1;
		
		//DIALOGUE: "So what's the plan, sarge?"
		level.braeburn Dialogue_Thread("silotown_braeburn_whatplan");
		wait 0.2;
	
		//DIALOGUE: "I need runners with suppressing fire. Garcia, Hawkins, take the left with Rosetti and Jones. The rest will follow me up the right flank." 
		level.randall Dialogue_Thread("silotown_rnd_needrunners");
		wait 0.15;
		
		//DIALOGUE: "I want grenades on them as soon as we're in range. Braeburn, McCloskey, and Taylor - you stay back and provide a base of fire." 
		level.randall Dialogue_Thread("silotown_rnd_wantgrenades");
		wait 0.15;

		//DIALOGUE: "Keep those Krauts off of us so we can move in."
		level.randall thread Dialogue_Thread("silotown_rnd_keepkrautsoff");
		
		wait 2;
		
		if(!level.earlystart)
		{
			//DIALOGUE: "All right. Move up, and wait for my signal."
			level.randall thread Dialogue_Thread("silotown_rnd_allrightmoveup", undefined, "nowait");
		}
		
		wait 1;
}

grenadeAwareness(status)
{
	//Covers situations where the player tries to toss a grenade and screw up situations
	//AI are temporarily unaware of grenades and also have zero-tolerance for friendly fire
	
	if(!isdefined(status))
		status = true;
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(status)
		{
			aAllies[i].grenadeawareness = 0.9;
		}
		else
		{
			aAllies[i].grenadeawareness = 0;
		}
	}
}

/*
ff_damagecheck()
{
	level endon ("begin field charge");
	while(1)
	{
		self waittill("damage", amount, attacker);
		if(attacker == level.player)
			break;
	}	
	setCvar("ui_deadquote", &"SILOTOWN_ASSAULT_FRIENDLY_FIRE_WILL_NOT");
	maps\_utility::missionFailedWrapper();
}
*/

setupCharacters()
{
	level.randall = getent("randall", "targetname");
	level.randall.animname = "randall";
	level.randall.anim_disablePain = true;
	level.braeburn = getent("braeburn", "targetname");
	level.braeburn.animname = "braeburn";
	level.braeburn.anim_disablePain = true;
	
	//McCloskey is activated when the guys start moving out
	//level.mccloskey = getent("mccloskey", "targetname");
	//level.mccloskey.animname = "mccloskey";
	//level.mccloskey.anim_disablePain = true;
	
	level.garcia = getent("garcia", "targetname");
	//level.garcia thread maps\_utility::magic_bullet_shield();
	
	level.hawkins = getent("hawkins", "targetname");
	//level.hawkins thread maps\_utility::magic_bullet_shield();
	
	level.rosetti = getent("rosetti", "targetname");
	//level.rosetti thread maps\_utility::magic_bullet_shield();
	
	level.jones = getent("jones", "targetname");
	//level.jones thread maps\_utility::magic_bullet_shield();
	
	level.lentz = getent("lentz", "targetname");
	//level.lentz thread maps\_utility::magic_bullet_shield();
	
	//level.randall thread maps\_utility::magic_bullet_shield();
	level.randall.script_bcdialog = 0;
	//level.braeburn thread maps\_utility::magic_bullet_shield();
	level.braeburn.accuracy = 0.4;
	level.braeburn.script_bcdialog = 0;
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].animplaybackrate = 1;
		aAllies[i].interval = 0;
		aAllies[i] thread maps\_utility::magic_bullet_shield();
		aAllies[i].anim_disablePain = true;
	}
}
				
objective_setup_2()
{
	// objective 2
	level.flag["Hardpoint Complete " + "bigwallbldg"] = false;
	objEvent = getObjEvent("bigwallbldg");
	objEvent waittill_objectiveEvent();
	flag_set("Hardpoint Complete " + "bigwallbldg");
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(2, "done");
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_areasecure");
	}
	
	thread autoSaveByName ("bigwallbldg");
}

objective_setup_3()
{
	// objective 3
	level.flag["Hardpoint Complete " + "barn"] = false;
	objEvent = getObjEvent("barn");
	objEvent waittill_objectiveEvent();	
	flag_set("Hardpoint Complete " + "barn");
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(3, "done");
	
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_areasecure");
	}
	
	thread autoSaveByName ("barn");
}

objective_setup_4()
{
	// objective 4
	level.flag["Hardpoint Complete " + "northbldg"] = false;
	objEvent = getObjEvent("northbldg");
	objEvent waittill_objectiveEvent();
	flag_set("Hardpoint Complete " + "northbldg");	
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(4, "done");
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_postofficecleared");
	}
	
	thread autoSaveByName ("northbldg");
}

objective_setup_5()
{
	// objective 5
	level.flag["Hardpoint Complete " + "forkbldg"] = false;
	objEvent = getObjEvent("forkbldg");
	objEvent waittill_objectiveEvent();
	flag_set("Hardpoint Complete " + "forkbldg");
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(5, "done");
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_forkclearup");
		wait 0.25;
		thread dialogue_nearby_friendly("hint_forkcleardown");	
	}
	
	thread autoSaveByName ("forkbldg");
}

objective_setup_6()
{
	// objective 6
	level.flag["Hardpoint Complete " + "signbldg"] = false;
	objEvent = getObjEvent("signbldg");
	objEvent waittill_objectiveEvent();
	flag_set("Hardpoint Complete " + "signbldg");
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(6, "done");
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_signbldgcleared");
	}
	
	thread autoSaveByName ("signbldg");
}

objective_setup_7()
{
	// objective 7
	level.flag["Hardpoint Complete " + "westbldg"] = false;
	objEvent = getObjEvent("westbldg");
	objEvent waittill_objectiveEvent();
	flag_set("Hardpoint Complete " + "westbldg");
	level.buildingscleared++;
	level notify ("building_cleared");
	wait 4;
	objective_state(7, "done");
	
	if(level.buildingscleared < 6)
	{
		thread dialogue_nearby_friendly("hint_hqcleared");
	}
	
	thread autoSaveByName ("westbldg");
}

objectives()
{	
	eFieldPoint = getent("crossfield_objective", "targetname");
		
	//Cover the squad's advance while keeping casualties below 50 percent. 
	
	//Text: Support the squad's advance into the town.
	objective_add(1, "active", &"SILOTOWN_ASSAULT_SUPPORT_THE_SQUADS_ADVANCE", eFieldPoint.origin);
	objective_current(1);
	
	if (getcvar("skipto") == "" || getcvar("skipto") == "field")
	{
		level waittill ("field secured");
	}
	
	objective_state(1, "done");
	
	level.mg42BadPlace = true;	//keeps ai from using mg42s immediately after the previous user was killed, less dumb
	level.mg42badplace_mintime = 25;
	level.mg42badplace_maxtime = 40;
	
	if (getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town")
	{
		//activate the town capturing objectives
		
		thread autoSaveByName ("fieldsecured");
	
		//Text: Capture the stone farmhouse at the south end of town.
		objective_add(2, "active", &"SILOTOWN_ASSAULT_CAPTURE_THE_STONE_FARMHOUSE", getObjOrigin("bigwallbldg_origin"));
		objective_current(2);
		objective_icon(2, "objectiveA");
		
		//Text: Clear the barn of enemy infantry.
		objective_add(3, "active", &"SILOTOWN_ASSAULT_CLEAR_THE_BARN_OF_ENEMY", getObjOrigin("barn_origin"));
		objective_additionalcurrent(3);
		objective_icon(3, "objectiveB");
		
		//Text: Secure the post office at the north end of town.
		objective_add(4, "active", &"SILOTOWN_ASSAULT_SECURE_THE_POST_OFFICE", getObjOrigin("northbldg_origin"));
		objective_additionalcurrent(4);
		objective_icon(4, "objectiveC");
		
		//Text: Seize the house overlooking the fork in the road.
		objective_add(5, "active", &"SILOTOWN_ASSAULT_SEIZE_THE_HOUSE_OVERLOOKING", getObjOrigin("forkbldg_origin"));
		objective_additionalcurrent(5);
		objective_icon(5, "objectiveD");
		
		//Text: Take control of the sign-covered house at the main intersection.
		objective_add(6, "active", &"SILOTOWN_ASSAULT_TAKE_CONTROL_OF_THE_SIGNCOVERED", getObjOrigin("signbldg_origin"));
		objective_additionalcurrent(6);
		objective_icon(6, "objectiveE");
		
		//Text: Clear the German field HQ in the manor.
		objective_add(7, "active", &"SILOTOWN_ASSAULT_CLEAR_THE_GERMAN_FIELD", getObjOrigin("westbldg_origin"));
		objective_additionalcurrent(7);
		objective_icon(7, "objectiveF");
		
		thread objective_setup_2();
		thread objective_setup_3();
		thread objective_setup_4();
		thread objective_setup_5();
		thread objective_setup_6();
		thread objective_setup_7();
		
		thread dialogue_roomclearing_init();
		thread dialogue_roomclearing("Hardpoint Complete bigwallbldg");
		thread dialogue_roomclearing("Hardpoint Complete barn");
		thread dialogue_roomclearing("Hardpoint Complete northbldg");
		thread dialogue_roomclearing("Hardpoint Complete forkbldg");
		thread dialogue_roomclearing("Hardpoint Complete signbldg");
		thread dialogue_roomclearing("Hardpoint Complete westbldg");
		thread dialogue_buildingcleared();
		
		//activate the objective completion based deletion of portable mg42 moments
		
		level thread portable_mg42_moment_hqsandbags_cancel();
		level thread portable_mg42_moment_officewall_cancel();
		level thread portable_mg42_moment_barnbags_cancel();
		level thread portable_mg42_moment_officebags_cancel();
		level thread portable_mg42_moment_signwall_cancel();
	
		//activate friendly management systems for town capture
	
		level thread friendlyAreaSeed();
		level thread friendlyAreaStart();
		level thread friendlyTownStats();
		//level thread playerBuddiesFollowers();
		
		flag_wait("Hardpoint Complete " + "bigwallbldg");
		flag_wait("Hardpoint Complete " + "barn");
		flag_wait("Hardpoint Complete " + "northbldg");
		flag_wait("Hardpoint Complete " + "forkbldg");
		flag_wait("Hardpoint Complete " + "signbldg");
		flag_wait("Hardpoint Complete " + "westbldg");
		
		//Kill any remaining enemy troops in the town
		aAxis = getaiarray("axis");
		for(i=0; i<aAxis.size; i++)
		{
			aAxis[i] doDamage (aAxis[i].health + 10050, aAxis[i].origin);
		}
		
		wait 4.5;
	}
	
	if(getcvar("skipto") == "midbriefing" || getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		//Text: Capture the stone farmhouse at the south end of town.
		objective_add(2, "done", &"SILOTOWN_ASSAULT_CAPTURE_THE_STONE_FARMHOUSE");
		
		//Text: Clear the barn of enemy infantry.
		objective_add(3, "done", &"SILOTOWN_ASSAULT_CLEAR_THE_BARN_OF_ENEMY");
		
		//Text: Secure the post office at the north end of town.
		objective_add(4, "done", &"SILOTOWN_ASSAULT_SECURE_THE_POST_OFFICE");
		
		//Text: Seize the house overlooking the fork in the road.
		objective_add(5, "done", &"SILOTOWN_ASSAULT_SEIZE_THE_HOUSE_OVERLOOKING");
		
		//Text: Take control of the sign-covered house at the main intersection.
		objective_add(6, "done", &"SILOTOWN_ASSAULT_TAKE_CONTROL_OF_THE_SIGNCOVERED");
		
		//Text: Clear the German field HQ in the manor.
		objective_add(7, "done", &"SILOTOWN_ASSAULT_CLEAR_THE_GERMAN_FIELD");
		
		aFloodspawners = getentarray("flood_spawner", "targetname");
		aAntispawns = getentarray("antispawn", "targetname");
		
		for(i=0; i<aFloodspawners.size; i++)
		{
			aFloodspawners[i] delete();
		}
		
		for(i=0; i<aAntispawns.size; i++)
		{
			aAntispawns[i] delete();
		}
		
		wait 1;
	}
	
	level notify ("town captured");
	
	//Everyone stops following the player and goes to the briefing/defensive points
	
	eMidBriefPoint = getent("midbriefing_point", "targetname");
	
	if(getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		objective_delete(2);
		objective_delete(3);
		objective_delete(4);
		objective_delete(5);
		objective_delete(6);
		objective_delete(7);
		
		//Text: Eliminate the enemy infantry occupying the town.
		objective_add(2, "done", &"SILOTOWN_ASSAULT_ELIMINATE_THE_ENEMY_INFANTRY", eMidBriefPoint.origin);
		
		//Text: Regroup with the squad at the intersection.
		objective_add(3, "done", &"SILOTOWN_ASSAULT_REGROUP_WITH_THE_SQUAD");
	}	
	else
	{
		wait 3;
		
		objective_delete(2);
		objective_delete(3);
		objective_delete(4);
		objective_delete(5);
		objective_delete(6);
		objective_delete(7);
		
		//Text: Eliminate the enemy infantry occupying the town.
		objective_add(2, "done", &"SILOTOWN_ASSAULT_ELIMINATE_THE_ENEMY_INFANTRY", eMidBriefPoint.origin);
		
		//Text: Regroup with the squad at the intersection.
		objective_add(3, "active", &"SILOTOWN_ASSAULT_REGROUP_WITH_THE_SQUAD", eMidBriefPoint.origin);
		objective_state(3, "active");
		objective_current(3);
	
		thread friendly_cutscene_settings("on");
		
		town_defense_randall_briefing();
		
		level notify ("midbriefing done");
		objective_state(3, "done");
		thread friendly_cutscene_settings("independent");
	}
	
	eSiloObjPoint = getent("silo_objective_point", "targetname");
	
	if(getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		//Text: Get to the top of the silo with Pvt. Braeburn and Pvt. McCloskey.
		objective_add(4, "done", &"SILOTOWN_ASSAULT_GET_TO_THE_TOP_OF_THE");
	}
	else
	{		
		//Text: Get to the top of the silo with Pvt. Braeburn and Pvt. McCloskey.
		objective_add(4, "active", &"SILOTOWN_ASSAULT_GET_TO_THE_TOP_OF_THE", eSiloObjPoint.origin);
		objective_current(4);
	
		flag_wait("player in silo");
		objective_state(4, "done");
	}
	
	if(getcvar("skipto") != "retreat" || getcvar("skipto") != "epilogue")
	{
		sniperAmmoFrac = 0;
		sniperWeapon = undefined;
		playerWeapon1 = level.player getweaponslotweapon("primary");
		playerWeapon2 = level.player getweaponslotweapon("primaryb");
		
		if(playerWeapon1 == "g43_scope" || playerWeapon1 == "springfield" || playerWeapon1 == "kar98k_sniper")
		{
			sniperAmmoFrac = level.player getfractionmaxammo(playerWeapon1);
			sniperWeapon = playerWeapon1;
		}
		else
		if(playerWeapon2 == "g43_scope" || playerWeapon2 == "springfield" || playerWeapon2 == "kar98k_sniper")
		{
			sniperAmmoFrac = level.player getfractionmaxammo(playerWeapon2);
			sniperWeapon = playerWeapon2;
		}
		
		if((getcvar("skipto") == "defense" && level.gameskill != 2 && level.gameskill != 3) || ((sniperAmmoFrac < 0.5) && (level.gameSkill == 0 || level.gameSkill == 1)))
		{
			//On Easy & Normal, force the player to get the silo sniper rifle if they are empty on a carried sniper rifle, or don't have one at all
			
				level.SniperRifle = undefined;
				thread objective_pickupSniperRifle();
				wait 0.1;
			
			if(getcvar("skipto") != "defense")
			{	
				objective_add(5, "active", &"SILOTOWN_ASSAULT_GET_THE_GERMAN_SNIPER", level.SniperRifle.origin);
				objective_current(5);
			
				flag_wait("player_has_sniper_rifle");
			}
			
			objective_state(5, "done");
		}
		else
		{	
			//On Easy & Normal, give the player a free refill if they are carrying a sniper rifle with any ammo in it
			/*
			if((level.gameskill == 0 || level.gameskill == 1) && sniperAmmoFrac > 0)
			{
				level.player giveMaxAmmo(sniperWeapon);
			}
			*/
			
			level.SniperRifle = spawn("weapon_kar98k_sniper", (448, 422, 567), 1); // suspended
			level.SniperRifle.angles = (0, 240, -90);
			
			flag_set("player_has_sniper_rifle");
		}
	}
	
	if(getcvar("skipto") != "retreat" || getcvar("skipto") != "epilogue")
	{
		objective_add(5, "active", &"SILOTOWN_ASSAULT_WATCH_OUT_FOR_AN_ENEMY", eSiloObjPoint.origin);
		objective_current(5);
		
		flag_wait("timed_defense");
		objective_state(5, "done");
		
		thread autoSaveByName("counterattack_action");
		
		wait 0.05;
	}
	
	if(getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		//Text: Hold the town while eliminating the German mortar teams.
		objective_add(level.mortarObjNumber, "done", &"SILOTOWN_ASSAULT_SNIPE_THE_ENEMY_MORTAR");	
	}
	else
	{
		//Text: Hold the town while eliminating the German mortar teams.
		objective_add(level.mortarObjNumber, "active", &"SILOTOWN_ASSAULT_SNIPE_THE_ENEMY_MORTAR");
		objective_current(level.mortarObjNumber);

		level waittill ("retreat");

		objective_state(level.mortarObjNumber, "done");
	}
	
	if(getcvar("skipto") == "epilogue")
	{
		//Text: Help the reinforcements clear the area of any remaining enemies.
		objective_add(6, "done", &"SILOTOWN_ASSAULT_HELP_THE_REINFORCEMENTS");	
	}
	else
	{
		//Text: Help the reinforcements clear the area of any remaining enemies.
		objective_add(6, "active", &"SILOTOWN_ASSAULT_HELP_THE_REINFORCEMENTS", level.player.origin);
		objective_current(6);
	
		flag_wait("area secure");
		objective_state(6, "done");
	}
	
	battleChatterOff("allies");
	
	thread autoSaveByName ("debriefing");
	
	//DIALOGUE: "Squaaad! Regroup on me!!! Hustle up!"
	level.randall Dialogue_Thread("silotown_rnd_squadregroup");
	
	endBriefPoint = getent("endbriefing_point", "targetname");
	
	//Text: Debrief with Sgt. Randall.
	objective_add(7, "active", &"SILOTOWN_ASSAULT_DEBRIEF_WITH_SGT_RANDALL", endBriefPoint.origin);
	objective_current(7);
	
	epilogue();
	
	objective_state(7, "done");

	maps\_endmission::nextmission();
}

objective_pickupSniperRifle()
{
	ent = spawnstruct();
	ent.origin = (448, 422, 567);
	ent.angles = (0, 240, -90);
	ent.usable = true;
	
	level.SniperRifleFake = spawn("script_model", ent.origin);
	level.SniperRifleFake.angles = ent.angles;
	level.SniperRifleFake setmodel ("xmodel/weapon_kar98_scoped_obj");
	
	level.SniperRifle = spawn("weapon_kar98k_sniper", (448, 422, 567), 1); // suspended
	level.SniperRifle.angles = (0, 240, -90);
	level.SniperRifle hide();
	
	level.SniperRifle waittill ("trigger");
	
	level.SniperRifleFake delete();
	
	flag_set("player_has_sniper_rifle");
	
	thread autoSaveByName ("locked in silo");
}

dialogue_retreat()
{
	mccloskeyNode = getnode("mccloskey_blocker", "targetname");
	//DIALOGUE: "Hey! We got friendly tanks comin' in from the east! Looks like they sent us a couple a' Shermans!"
	level.mccloskey Dialogue_Thread("silotown_mccloskey_friendlytanks", mccloskeyNode);

	wait 1.5;
	
	//DIALOGUE: "Bout' damn time! The Krauts are givin' up the fight! Thaaat's right Fritz! Just keep on runnin'!!"
	level.braeburn Dialogue_Thread("silotown_braeburn_givingup");
}

epilogue()
{
	thread town_silo_ladder_handling();
	
	level.mccloskey.team = "allies";
	failSafeBlocker = getent("playerRestraint", "targetname");
	failSafeBlocker notsolid();
	failSafeBlocker connectpaths();
	
	thread autoSaveByName ("leaving the silo");
	
	wait 0.5;
	
	schoolcircle("endbriefing_schoolcircle_node", "Sgt. Randall", "endbriefing_randall_node", level.randall, "endbriefing_point");
	
	randallNode = getnode("endbriefing_randall_node", "targetname");
	
	//"Good work everyone."
	level.randall Dialogue_Thread("silotown_rnd_goodwork", randallNode);
	
	//"Make sure your sectors are well covered and we'll meet back here in an hour. Dismissed."
	level.randall Dialogue_Thread("silotown_rnd_sectorscovered", randallNode);
}

//====================================================

nobacktrack()
{
	forcefield = getent("nobacktrack", "targetname");
	forcefield notsolid();
	forcefield connectpaths();
	
	trig = getent("nobacktrack_trigger", "targetname");
	trig waittill ("trigger");
	
	forcefield solid();
}

//====================================================

friendly_stance()
{
	level waittill ("go to jumpoff points");
	
	//stagger the switch to standing for a more natural look
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i] allowedStances ("stand", "crouch", "prone");
		aAllies[i] pushPlayer(true);
	}
}

field_charge_mccloskey_spawn()
{
	//.30cal McCloskey spawns and runs using global 30cal guy behavior
	
	trig = getent("mccloskey_spawntrig", "targetname");
	trig waittill ("trigger");
	
	level.mccloskey = getent("mccloskey", "targetname") stalingradSpawn();
	level.mccloskey.animname = "mccloskey";
	level.mccloskey.anim_disablePain = true;
	level.mccloskey thread field_30cal_mccloskey();
	level.mccloskey thread maps\_utility::magic_bullet_shield();
	level.mccloskey.accuracy = 0.6;
	level.mccloskey.script_bcdialog = 0;
	level.mccloskey.dontavoidplayer = true;
	level.mccloskey pushPlayer(true);
	//level.mccloskey.animplaybackrate = 1.5;
	wait 0.05;
	level.mccloskey.grenadeawareness = 0;
	level.mccloskey waittill ("mg42_portable_setup");
	level.mccloskey.goalradius = 384;
	wait 0.1;
	level.mccloskey.dontavoidplayer = false;
	//level waittill ("begin field charge");
	//wait 2;
}

field_charge_init()
{
	level waittill ("go to jumpoff points");
	
	ent = spawnstruct();
	ent.count = 0;
	
	//base of fire guys
	
	nBraeburnNode = getnode("braeburn_jumpoff", "targetname");
	level.braeburn thread field_bof_jumpoff(nBraeburnNode, ent);
	
	//get flankers
	
	aFlankers = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].goalradius = 32;
		if(isdefined(aAllies[i].script_noteworthy) && aAllies[i].script_noteworthy == "flanker")
		{
			aFlankers[aFlankers.size] = aAllies[i];	
		}
	}
	
	//assign special flankers' moves, get generic flankers
	
	aGenFlankers = [];
	
	//Of the flanking team members, Randall always moves first
	
	for(i=0; i<aFlankers.size; i++)
	{
		if(aFlankers[i] != level.randall)
		{
				continue;
		}
		else
		{
			nRightJumpoff1 = getnode("rightflanker_jumpoff1", "targetname");
			level.randall setgoalnode(nRightJumpoff1);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nRightJumpoff1.targetname;
			wait 0.6;
		}
	}
	
	for(i=0; i<aFlankers.size; i++)
	{
		if(aFlankers[i] == level.garcia)
		{
			nLeftJumpoff1 = getnode("leftflanker_jumpoff1", "targetname");
			aFlankers[i] setgoalnode(nLeftJumpoff1);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nLeftJumpoff1.targetname;
			level.garcia.anim_disablePain = true;
			//level.garcia.health = 2000;
			wait 0.5;
		}
		else
		if(aFlankers[i] == level.hawkins)
		{
			nLeftJumpoff2 = getnode("leftflanker_jumpoff2", "targetname");
			level.hawkins setgoalnode(nLeftJumpoff2);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nLeftJumpoff2.targetname;
			level.hawkins.anim_disablePain = true;
			//level.hawkins.health = 2000;
			wait 0.8;
		}
		else
		if(aFlankers[i] == level.rosetti)
		{
			nLeftJumpoff3 = getnode("leftflanker_jumpoff3", "targetname");
			level.rosetti setgoalnode(nLeftJumpoff3);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nLeftJumpoff3.targetname;;
			level.rosetti.anim_disablePain = true;
			//level.rosetti.health = 2000;
			wait 0.5;
		}
		else
		if(aFlankers[i] == level.jones)
		{
			nLeftJumpoff4 = getnode("leftflanker_jumpoff4", "targetname");
			level.jones setgoalnode(nLeftJumpoff4);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nLeftJumpoff4.targetname;;
			level.jones.anim_disablePain = true;
			//level.jones.health = 2000;
			wait 0.6;
		}
		else
		if(aFlankers[i] == level.lentz)
		{
			nRightJumpoff2 = getnode("rightflanker_jumpoff2", "targetname");
			level.lentz setgoalnode(nRightJumpoff2);
			ent.count++;
			aFlankers[i] thread field_charge_arrival(ent);
			aFlankers[i].target = nRightJumpoff2.targetname;;
			level.lentz.anim_disablePain = true;
			//level.lentz.health = 2000;
			wait 0.77;
		}
		else
		if(!isdefined(aFlankers[i].script_friendname))
		{
			aGenFlankers[aGenFlankers.size] = aFlankers[i];	
		}

	}
	
	//get leftover left side/right side jumpoff nodes if any
	
	aRightStarts = getnodearray("rightflanker_jumpoff", "targetname");
	aLeftStarts = getnodearray("leftflanker_jumpoff", "targetname");
	
	//generic jumpoff node assignment for any number of leftover flankers, alternate left right
	
	n=0;
	
	for(i=0; i<aGenFlankers.size; i++)
	{
		if(!n)
		{
			n=1;
			if(aLeftStarts.size != 0)
			{
				r = field_charge_genflankpos(aGenFlankers[i], aLeftStarts, aLeftStarts.size, ent);
				aLeftStarts = maps\_utility::array_remove(aLeftStarts, aLeftStarts[r]);
				continue;
			}
		}
		
		if(n==1)
		{
			n=0;
			if(aRightStarts.size != 0)
			{	
				r = field_charge_genflankpos(aGenFlankers[i], aRightStarts, aRightStarts.size, ent);
				aRightStarts = maps\_utility::array_remove(aRightStarts, aRightStarts[r]);
				continue;
			}
		}
	}
	
	while(1)
	{
		if(ent.count <= 1)
		{
			break;
		}
		ent waittill ("arrived");
	}
	
	flag_set("all in position");
	flag_wait("30cal is setup");
}

field_bof_jumpoff(node, ent)
{
	wait 0.3;
	self setgoalnode(node);
	ent.count++;
	self thread field_charge_arrival(ent);
}

field_charge_genflankpos(guy, array, size, ent)
{
	r = randomint(size);
	nRouteNode = array[r];
	
	guy setgoalnode(nRouteNode);	
	ent.count++;
	guy thread field_charge_arrival(ent);
	guy.target = nRouteNode.target;
	
	return(r);
}

field_charge_arrival(ent)
{
	if(self != level.braeburn)
	{
		level endon ("charge activated");
	}
	
	self waittill ("goal");
	ent.count--;
	ent notify ("arrived");
	
	if(self == level.braeburn)
	{
		self allowedStances ("crouch");
	}
	
	if(self == level.randall)
	{
		flag_set("randall at jumpoff");
	}
}

field_bof_banter()
{
	//The dialogue sequence between doc, Braeburn, and McCloskey
	
	level waittill ("ammo banter");
	
	wait 5;
	level.bermbanter = 1;
	
	spawndoc = getent("doc", "targetname");
	
	level.doc = spawndoc stalingradSpawn();
	if(spawn_failed(level.doc))
	{
		return;
	}
	
	level.doc.animname = "wells";
	level.doc thread maps\_utility::magic_bullet_shield();
	//level.doc.team = "neutral";
	level.doc.goalradius = 64;
	level.doc thread field_bof_docgoal();
	level.doc.ignoreme = true;
	level.doc.anim_disablePain = true;
	
	machineGun = getent("mccloskey_30cal", "targetname");
	mg42user = machineGun getturretowner();
	
	if(isdefined(mg42user) && mg42user == level.mccloskey)
	{
		level.braeburnSpeech = 1;
		
		//DIALOGUE: "Braeburn! I'm runnin' out of .30 cal!"
		level.mccloskey Dialogue_Thread("silotown_mccloskey_runningout");
		wait 0.25;
		
		//DIALOGUE: "I've got problems of my own! Where's your spare can of ammo?"
		level.braeburn Dialogue_Thread("silotown_braeburn_sparecan");
		wait 0.5;
		
		//DIALOGUE: "I thought you had it!"
		level.mccloskey Dialogue_Thread("silotown_mccloskey_youhadit");
		wait 0.5;
		
		//DIALOGUE: "Jeez Louise, McCloskey, how the hell did you get to be company gunner?!?! Shootin' chickens in a barnyard?!"
		level.braeburn Dialogue_Thread("silotown_braeburn_chickens");
		
		flag_wait("doc arrived at bof");
		
		//DIALOGUE: "Private Braeburn!"
		level.doc Dialogue_Thread("silotown_med_pvtbraeburn");
		wait 0.25;
		//DIALOGUE: "Braeburn! You left this ammo on the road! You'd forget your ass if it wasn't glued on!"
		level.doc Dialogue_Thread("silotown_med_ammo");
		wait 0.5;
		//level.mccloskey Dialogue_Thread("silotown_mccloskey_docsays");
		//wait 0.5;
		//level.braeburn Dialogue_Thread("silotown_braeburn_canthear");
		//wait 0.5;
		
		level.braeburnSpeech = 0;
	}
	flag_wait("field completed");
	flag_wait("dialogue getuphere done");
	
	thread grenadeAwareness(true);
	
	detector = getent("braeburn_packbags", "targetname");
	
	if(level.player isTouching(detector))
	{
		//DIALOGUE: "Nice shootin' Taylor. Pack your bags we're movin' in."
		level.braeburn thread Dialogue_Thread("silotown_braeburn_packbags");
	}
	
	wait 1;
	
	level notify ("braeburn says go");
	
	level.braeburn allowedstances ("stand", "crouch", "prone");
	level.mccloskey allowedstances ("stand", "crouch", "prone");
	level.doc allowedstances ("stand", "crouch", "prone");
	
	wait 0.8;	//Braeburn leads the way
	level.doc thread field_doc_traverse();
	
	level.braeburn.anim_disablePain = false;
	level.mccloskey.anim_disablePain = false;
}

field_bof_docgoal()
{
	docprox = getnode("doc_enroute", "targetname");
	level.doc setgoalnode(docprox);
	self waittill ("goal");
	
	//DIALOGUE: "Private Braeburn!"
	level.doc thread Dialogue_Thread("silotown_wells_braeburn");
	
	docnode = getnode("doc_arrival", "targetname");
	level.doc setgoalnode(docnode);
	self waittill ("goal");
	
	level.doc allowedstances ("crouch");
	flag_set("doc arrived at bof");
}

field_30cal_mccloskey()
{		
	self waittillmatch ("setup done", "end");
	flag_set("30cal is setup");
	
	//initiate conditions for mccloskey firing the 30cal
	//level.mccloskey thread field_30cal_signal();
	//level.mccloskey thread field_30cal_auto();
}

/*
field_30cal_signal()
{
	//after mccloskey has reached his assigned spot and set up the machine gun
	//he will fire if ordered by randall
	
	level endon ("charge activated");
	flag_wait("all in position");
	level waittill ("randall gives signal");
	self thread field_30cal_suppression();
}

field_30cal_auto()
{
	//after mccloskey has reached his assigned spot and set up the machine gun
	//if the charge is already started, he will fire as soon as he's set up
	
	flag_wait("30cal may fire");
	level endon ("randall gives signal");
	self thread field_30cal_suppression();
}

field_30cal_suppression()
{
	//this thread controls mccloskey's firing and targeting patterns with the 30cal
	while(1)
	{
		//++++insert firing pattern here
		if(level.flag["field completed"] == true)
		{
			break;
		}	
	}
}
*/

field_mccloskey_traverse()
{
	level waittill ("braeburn says go");
	
	wait 0.6;	//Braeburn leads the way
	
	node = getnode("mccloskey_rifle_switch", "targetname");
	level.mccloskey setgoalnode(node);
	level.mccloskey.goalradius = 16;
	
	level.mccloskey waittill("goal");
	level.mccloskey.ignoreme = false;
	level.mccloskey.dontavoidplayer = true;
	level.mccloskey thread heroDelete();
}

field_braeburn_traverse()
{
	level waittill ("braeburn says go");
	
	node = getnode("braeburn_fieldcross", "targetname");
	level.braeburn setgoalnode(node);
	level.braeburn.goalradius = 16;
	level.braeburn waittill("goal");
	level.braeburn.ignoreme = false;
	level.braeburn.dontavoidplayer = true;
	level.braeburn thread heroDelete();
}

field_doc_traverse()
{
	node = getnode("doc_fieldcross", "targetname");
	self setgoalnode(node);
	self.goalradius = 800;
	self waittill ("goal");
	
	level.doc.anim_disablePain = false;
	level.doc notify ("stop magic bullet shield");
	level.doc.ignoreme = false;
	self.dontavoidplayer = false;
	self thread friendlyAreaNav(undefined, undefined, undefined, undefined);
}

heroDelete()
{
	//deletes the chosen hero AI to free up combatant slots
	
	deleteArea = getent("heroarea", "targetname");
	while(1)
	{
		wait 2;
		if(level.player istouching (deleteArea))
			continue;
		success = bullettracepassed(level.player.origin + (0, 0, 128), self.origin + (0,0,128), false, undefined);
		if(success)
			continue;
		self delete();
		break;
	}
}

field_charge_playerwait()
{
	level endon ("charge activated");
	
	trig = getent("fieldChargeTrigger", "targetname");
	trig waittill ("trigger");
	
	wait randomfloat(2.5, 3.8);
	
	flag_set("playerArrivedBerm");
}

field_charge_with_signal()
{
	//Field condition 3
	
	level endon ("charge activated");
	
	//randall must be in position
	//Everyone else must be in position
	//The 30cal must be ready
	//Player must be nearby
	
	flag_wait("randall at jumpoff");
	flag_wait("30cal is setup");
	flag_wait("all in position");
	flag_wait("playerArrivedBerm");
	
	wait 2;
	
	machineGun = getent("mccloskey_30cal", "targetname");
	mg42user = machineGun getturretowner();
	
	if(isdefined(mg42user) && mg42user == level.mccloskey)
	{
		//DIALOGUE: "McCloskey! Do it!"
		level.randall Dialogue_Thread("silotown_rnd_mccloskeydoit");
	}
	else
	if((isdefined(mg42user) && mg42user != level.mccloskey) || !isdefined(mg42user))
	{
		//Open fire!!!
		level.randall dialogue_thread("silotown_randall_openfire");
	}
	
	level notify ("randall gives signal");
	level notify ("begin field charge");
}

field_charge_dialogue_override()
{
	level waittill ("charge activated");
	level.randall.MyIsSpeaking = false;
	level.randall notify ("my done speaking");
}

field_playercrossing()
{
	level endon ("field secured");
	
	played = 1;
	nTrigger = getent("player_rush_alert", "targetname");
	
	while(1)
	{
		nTrigger waittill ("trigger");
		
		//player gets a warning line from braeburn
		if(played == 1 && !level.bermbanter && !level.randalltalking)
		{
			//DIALOGUE: "Where the hell are you goin' Taylor?! Hang back and cover the squad!!"
			level.Braeburn Dialogue_Thread("silotown_braeburn_whereyougoing");
			played = 2;
			break;
		}
		/*
		else 
		if(played == 2 && !level.bermbanter && !level.randalltalking)
		{
			level.Braeburn Dialogue_Thread("silotown_braeburn_getbackhere");
			played = 3;
			break;
		}
		
		else 
		if(played == 3 && !level.bermbanter && !level.randalltalking)			
		{
			level.Braeburn Dialogue_Thread("silotown_braeburn_taylorstayhere");
			break;
		}
		*/
		
		wait 10; //time between verbal warnings from Braeburn
	}
}

field_player_rush_alert()
{
	//If player charges into field early, the Germans wake up and the Allies rush the field
	level endon ("field completed");
	
	tPlayerAlert = getent("player_rush_alert", "targetname");
	tPlayerAlert waittill("trigger");
	
	level notify ("begin field charge");
	level notify ("charge activated");
	flag_set("player_rushed_field");
	
	level.player.threatbias = 1000000;
	level.player.ignoreme = false;
}

field_advance_triggers()
{
	//Sets up the field advancement triggers that make friendlies move forward based on the player's actions
	aAdvanceTrigs = getentarray("player_advance", "targetname");
	for(i=0; i<aAdvanceTrigs.size; i++)
	{
		thread field_advance_trigger_monitor(aAdvanceTrigs[i]);
	}
}

field_advance_trigger_monitor(eTrigger)
{
	//Monitors player's progression across the field to push friendlies forward 
	//Each trigger is manually set off if the player kills X enemies, also pushing friendlies forward
	//A trigger must be set off in order for the friendly 'flankers' to move up
	//This thread just sets the flag to on regardless of triggering cause (player position vs. player baglimit)
	
	assertEX(isdefined(eTrigger.script_idnumber), "Field sector trigger must have a script_idnumber of the sector number.");
	
	string = undefined;
	stringPreviousTrigger = undefined;
	switch(eTrigger.script_idnumber)
	{
		case 0:
			break;
		case 1:
			string = "1";
			stringPreviousTrigger = "0";
			break;
		case 2:
			string = "2";
			stringPreviousTrigger = "1";
			break;
		case 3:
			string = "3";
			stringPreviousTrigger = "2";
			break;
		case 4:
			string = "4";
			stringPreviousTrigger = "3";
			break;	
		case 5:
			string = "5";
			stringPreviousTrigger = "4";
			break;	
	}
	
	//Wait until the previous sector is completed (unless it's the first sector)
	if(eTrigger.script_idnumber != 1)
		flag_wait("field_sector_" + stringPreviousTrigger);
	
	//Now activate monitoring on this field sector trigger
	thread field_advance_killcondition(eTrigger);
	thread field_advance_baglimit_monitor();
	eTrigger waittill ("trigger");
	flag_set("field_sector_" + string);
}

field_advance_killcondition(eTrigger)
{
	//Notifies any time an enemy dies to track how many are killed by the player
	//When X spawned enemies are killed by the player, the advancement trigger is set off
	
	level waittill ("player reached baglimit");
	eTrigger notify ("trigger");
}

field_advance_baglimit_monitor()
{
	i=0;
	while(i<level.fieldAdvanceBaglimit)
	{
		level waittill ("player killed a field defender");
		i++;
	}
	
	level notify ("player reached baglimit");
}

field_advance_baglimit_deathmonitor()
{
	self waittill ("death", nAttacker);
	if(isdefined(nAttacker) && nAttacker == level.player)
	{
		level notify ("player killed a field defender");
	}
}

field_charge()
{
	//Several ways to initiate the German wakeupcall and field charge
	//1. Player kills an enemy
	//2. Player shoots near an enemy in a 'conspicuous' way from a reasonable spot
	//3. All units are in position, ie. randall gets to give a signal to McCloskey
	//4. Player charges into field ahead of everyone and wakes up the enemies
	
	//This thread:
	//a. controls the pathing and timing of the flankers
	//b. initiates completion monitoring threads
	//c. initiates enemy deployment thread
	
	level waittill ("begin field charge");
	flag_set("30cal may fire");
	flag_set("field attack started");
	
	thread field_charge_randalltalking();
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname))
			continue;
			
		aAllies[i] notify ("stop magic bullet shield");
		aAllies[i].anim_disablePain = false;
	}
	
	//Don't let McCloskey and Braeburn get targeted
	level.mccloskey.ignoreme = true;
	level.braeburn.ignoreme = true;
	
	wait 1.5;
	
	aFlankers = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_noteworthy) && aAllies[i].script_noteworthy == "flanker")
		{
			aFlankers[aFlankers.size] = aAllies[i];	
			aAllies[i].goalradius = 32;
		}
	}
	
	for(i=0; i<aFlankers.size; i++)
	{
		if(isdefined(aFlankers[i].target))
		{
			nFlankStart = getnode(aFlankers[i].target, "targetname");
			aFlankers[i] thread field_charge_pathing(nFlankStart);
			//aFlankers[i] forceReachGoal();
		}
	}
}	

field_charge_randalltalking()
{
	//DIALOGUE: "Flankers out! Let's go! Let's go!"	
	wait 2;
	level.randall Dialogue_Thread("silotown_rnd_flankersout");
	level.randalltalking = false;
	
	wait 0.25;

	if(!flag("player_rushed_field") && flag("bermSave_triggered"))
	{
		thread autoSaveByName ("gogogo");
	}
}

field_ending_node(nNode)
{
	self endon ("death");
	flag_wait("field completed");
	self setgoalnode(nNode);
}

field_charge_pathing(startnode)
{
	//get the last node in each chain and send to save thread
	//thread field_advance_triggers() sets 'field sector completed' flags, allowing the flankers to move up
	//thread field_advance_triggers() flag sets are based on player physically advancing or killing X enemies
	
	self endon ("death");
	
	iAdvanceSector = 1;
	strAdvanceSector = undefined;
	
	if(isdefined(startnode.target))
	{
		nFinalNode = getnode(startnode.target, "targetname");
		while(1)
		{
			if(isdefined(nFinalNode.target))
			{
				nFinalNode = getnode(nFinalNode.target, "targetname");
			}
			else
			{
				self thread field_ending_node(nFinalNode);
				break;
			}
		}
	}
	
	//two of the named Rangers have to respond to randall's order to use the 88
	
	if(isdefined(startnode.target))
	{
		if(isdefined(self.script_friendname) && (self.script_friendname == "Pvt. Garcia"))
		{
			level endon ("garcia attack");	
		}
		if(isdefined(self.script_friendname) && (self.script_friendname == "Pvt. Hawkins"))
		{
			level endon ("hawkins attack");	
		}
		if(isdefined(self.script_friendname) && (self.script_friendname == "Pvt. Jones"))
		{
			level endon ("jones attack");	
		}
		if(isdefined(self.script_friendname) && (self.script_friendname == "Pvt. Rosetti"))
		{
			level endon ("rosetti attack");	
		}
		if(isdefined(self.script_friendname) && (self.script_friendname == "Pvt. Lentz"))
		{
			level endon ("lentz attack");	
		}
		
		//Disregard pathing and go to end directly if not Sgt. Randall
		
		if(isdefined(self.script_friendname) && (self.script_friendname != "Sgt. Randall") || !isdefined(self.script_friendname))
		{
			level endon ("field completed");
		}
		
		nNextNode = getnode(startnode.target, "targetname");
		
		while(1)
		{	
			self.maxdist = 1000;	//1
			self.pathenemyfightdist = 300;
			self.pathenemylookahead = 640;
			self setgoalnode(nNextNode);
		
			//self.pacifist = true;
			
			self waittill ("goal");
			self.maxdist = 1000;	//680
			self.pathenemyfightdist = 412;
			self.pathenemylookahead = 300;
			
			//self.pacifist = false;
			
			if(isdefined(self.script_friendname) && (self.script_friendname == "Sgt. Randall"))
			{
				//randall triggers the dialogue sequence between Braeburn, McCloskey, and doc
				
				if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "start_bof_talk"))
				{
					level notify ("ammo banter");
				}
				
				//randall orders the guys to take the Flak88, selecting two men max for the job, if alive
				
				if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "randall_fieldorder"))
				{
					while(level.braeburnSpeech == 1)
					{
						wait 0.05;
					}
					level.randalltalking = 1;
					thread field_flak_send();
					level waittill ("randall flakorder done");
					level.randalltalking = 0;
				}
				
				//Sgt. Randall waits for the silo to explode before moving on to the end of the field
				/*
				if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "randall_holdforflak"))
				{
					//Warning: Silo must blow up
					
					//flag_wait("silo beheaded");
				}
				*/
				//randall waves and tells the player to cross the field
				
				if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "randall_wavenode"))
				{
					//master notify for field completion
					level notify ("field secured");	//used for playersuicide endon, teamarrival endon, starting town capture objective
					
					//master flag for field completion
					flag_set("field completed");	//makes friends beeline to end of route, bof moves up
					
					level.player.ignoreme = false;
					level.player.threatbias = level.player.oldthreatbias;
					
					//++++randall uses a big 'get over here' gesture, need anim
					
					//DIALOGUE: McCloskey! Braeburn! Taylor! Get up here! We gotta clear out these buildings! (distant)
					level.randall Dialogue_Thread("silotown_rnd_getuphere", nNextNode);
					flag_set("dialogue getuphere done");
					level.randall.anim_disablePain = false;
					node = getnode("randall_endnode", "script_noteworthy");
					level.randall.dontavoidplayer = true;
					level.randall setgoalnode(node);
					level.randall waittill ("goal");
					level.randall thread heroDelete();
					
					break;
				}
				
				//randall triggers the retreat/death of the enemy forces
				
				if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "enemy_fallback"))
				{
					level notify ("randall near end");
				}
				
				//Wait for randall's special pausepoints
				
				if(isdefined(nNextNode.script_delay))
				{
					//wait nNextNode.script_delay;
				}
			}
			
			//General wait for all other users
			
			if(isdefined(nNextNode.script_noteworthy) && (nNextNode.script_noteworthy == "pausepoint"))
			{
				/*
				if(isdefined(nNextNode.script_delay))
				{
					//wait nNextNode.script_delay;
				}
				*/
				
				//Check detent flags for field_advance_triggers() to allow this soldier to advance up the field
				//Soldier will wait forever until the player kills X enemies or moves up through a sector trigger
				
				switch(iAdvanceSector)
				{
					case 1:
						strAdvanceSector = "1";
						break;
					case 2:
						strAdvanceSector = "2";
						break;
					case 3:
						strAdvanceSector = "3";
						break;
					case 4:
						strAdvanceSector = "4";
						break;
					case 5:
						strAdvanceSector = "5";
						break;
				}
				flag_wait("field_sector_" + strAdvanceSector);
				
				if(strAdvanceSector == "3")
					flag_wait("player_killed_one_guy");
				
				iAdvanceSector++;					
			}
			
			if(isdefined(nNextNode.target))
			{
				nNextNode = getnode(nNextNode.target, "targetname");
			}
			
			wait 0.1;
		}
	}
}

#using_animtree( "scripted_anim" );
field_flak_send()
{
	battleChatterOff("allies");
					
	//Rattle off a maximum of two names
	
	n = 0;
	a = 0;
	b = 0;
	c = 0;
	d = 0;
	e = 0;
	
	//All applicable guys deploy to attack the flak
	
	ent = spawnstruct();
	ent.count = 0;
	
	for(i=0; i<level.aNamedGuys.size; i++)
	{
		if(isalive(level.aNamedGuys[i]) && (level.aNamedGuys[i].script_friendname == "Pvt. Garcia"))
		{
			n++;
			level.garciaPlanting = 1;
			level.garcia thread field_flak_attack(ent, "garcia attack");
			//DIALOGUE: "Garcia!" (distant)
			level.randall Dialogue_Thread("silotown_rnd_garcia");
			a = 1;
		}
		if(isalive(level.aNamedGuys[i]) && (level.aNamedGuys[i].script_friendname == "Pvt. Hawkins"))
		{
			n++;
			level.hawkinsPlanting = 1;
			level.hawkins thread field_flak_attack(ent, "hawkins attack");
			//DIALOGUE: "Hawkins!" (distant)
			level.randall Dialogue_Thread("silotown_rnd_hawkins");
			b = 1;
		}
		if(isalive(level.aNamedGuys[i]) && (level.aNamedGuys[i].script_friendname == "Pvt. Rosetti"))
		{
			n++;
			if(n <= 2)
			{
				level.rosettiPlanting = 1;
				level.rosetti thread field_flak_attack(ent, "rosetti attack");
				//DIALOGUE: "Rosetti!" (distant)
				level.randall Dialogue_Thread("silotown_rnd_rosetti");
				c = 1;
			}
		}
		if(isalive(level.aNamedGuys[i]) && (level.aNamedGuys[i].script_friendname == "Pvt. Jones"))
		{
			n++;
			if(n <= 2)
			{
				level.jonesPlanting = 1;
				level.jones thread field_flak_attack(ent, "jones attack");
				//DIALOGUE: "Jones!" (distant)
				level.randall Dialogue_Thread("silotown_rnd_jones");
				d = 1;
			}
		}
		if(isalive(level.aNamedGuys[i]) && (level.aNamedGuys[i].script_friendname == "Pvt. Jones"))
		{
			n++;
			if(n <= 2)
			{
				level.lentzPlanting = 1;
				level.lentz thread field_flak_attack(ent, "lentz attack");
				//DIALOGUE: "Lentz!" (distant)
				level.randall Dialogue_Thread("silotown_rnd_lentz");
				e = 1;
			}
		}
	}
	
	thread field_flak_ordertalk(a,b,c,d,e);
	
	while(1)
	{
		if(ent.count <= 1)
		{
			break;
		}
		ent waittill ("arrived at flak");
	}
	
	//tick off two GUARANTEED arrivals, this animation requires two people moving around the flak88 as it turns
	//++++all enemies around the flak gun need to die now
	//++++when both have reached the flak gun, detect, play the scripted flak gun animations, one pushes, one uses flywheel
	
	eFlak88 = getent("field_flak88", "targetname");
	eFlaktarget = getent("kaboom", "targetname");
	
	//++++temp  - turn the flak manually here for now
	eFlak88 setTurretTargetEnt(eFlaktarget, eFlaktarget.origin);
	eFlak88 waittill("turret_on_target");
	wait 1;
	eFlak88 fireTurret();
		
	wait .5;
	
	thread maps\_utility::playSoundinSpace("silotown_assault_siloexplode", eFlaktarget.origin);
	level.eSiloIntact delete();
	level.eSiloBreached show();
	level.eSiloPieces show();
	level.eSiloHatch delete();
	
	killvol = getent("siloKillTrigger", "targetname");
	if(level.player istouching(killvol))
		thread killplayer();
	
	exploder(0);
	
	level.eSiloPieces UseAnimTree(#animtree);
        level.eSiloPieces setflaggedanim("siloexplode",%silotown_silopieces);
        level.eSiloPieces waittillmatch ("siloexplode", "end");
	level.eSiloPieces delete();
	
	flag_set("silo beheaded");
	
	//++++the flakattack dudes run to their pre-arranged ending positions
}

field_flak_ordertalk(a,b,c,d,e)
{
	wait 0.7;
	
	//DIALOGUE: "Get on that 88 and blast that silo!" (distant)
	level.randall Dialogue_Thread("silotown_rnd_geton88");
	
	level notify ("randall flakorder done");
	
	//Only one guy has to talk
	
	if(isalive(level.garcia) && a == 1)
	{
		level.garcia.animname = "gr1";
		//DIALOGUE: "Yes sir!"
		level.garcia Dialogue_Thread("silotown_gr1_yessir");
	}
	else
	if(isalive(level.hawkins) && b == 1)
	{
		level.hawkins.animname = "gr1";
		//DIALOGUE: "Yes sir!"
		level.hawkins Dialogue_Thread("silotown_gr1_yessir");
	}
	else
	if(isalive(level.rosetti) && c == 1)
	{
		level.rosetti.animname = "gr1";
		//DIALOGUE: "Yes sir!"
		level.rosetti Dialogue_Thread("silotown_gr1_yessir");
	}
	else
	if(isalive(level.jones) && d == 1)
	{
		level.jones.animname = "gr1";
		//DIALOGUE: "Yes sir!"
		level.jones Dialogue_Thread("silotown_gr1_yessir");
	}
	else
	if(isalive(level.lentz) && e == 1)
	{
		level.lentz.animname = "gr1";
		//DIALOGUE: "Yes sir!"
		level.lentz Dialogue_Thread("silotown_gr1_yessir");
	}
}

field_flak_attack(ent, msg)
{
	//these guys need to be ignored by the enemy
	
	self.ignoreme = true;
	self.flakattack = true;
	
	//these guys need to be invulnerable until they complete the flak gun sequence and silo blows up
	
	self thread maps\_utility::magic_bullet_shield();

	ent.count++;
	level notify (msg);
	
	nFlakDestNode = getnode("field_flak_capturepoint", "targetname");
	self setgoalnode(nFlakDestNode);
	self waittill ("goal");
	
	ent.count--;
	ent notify ("arrived at flak");
	
	flag_wait("silo beheaded");
	
	self.ignoreme = false;
	self.anim_disablePain = false;
	level.garciaPlanting = 0;
	level.hawkinsPlanting = 0;
	level.jonesPlanting = 0;
	level.rosettiPlanting = 0;
	level.lentzPlanting = 0;
	
	flag_wait("resetFriendlyTownStats");
	
	self notify ("stop magic bullet shield");	
	wait 0.05;
	self.health = 250;
}

flak88_crew_setup()
{
	//Spawns the Flak88 crew
	
	tFlakStart = getent("field_flak_start", "targetname");
	tFlakStart notify ("trigger");
	wait 0.05;
	
	//Make Flak88 crew unaware and wait for the Allied attack
	
	aAxis = getaiarray("axis");
	for(i=0; i<aAxis.size; i++)
	{
		aAxis[i].ignoreme = true;
		
		if(isdefined(aAxis[i].script_noteworthy) && aAxis[i].script_noteworthy == "field_flak_crew")
		{
			aAxis[i] thread flak88_crew_deathwaiter();
			aAxis[i] thread enemy_deathmonitor();
		}
	}
	
	eFlak88 = getent("field_flak88", "targetname");
	eFlaktarget = getent("field_flaktarget", "targetname");
	eFlak88.autoTarget = false;
	
	while(level.flag["field attack started"] == false)
	{
		eFlak88 setTurretTargetEnt(eFlaktarget, eFlaktarget.origin);
		eFlak88 waittill("turret_on_target");
		eSpeakerHouse = getent("speaker_house", "targetname");
		//++++replace these old CoD1 lines with CoD2 recordings
		//thread maps\_utility::playSoundinSpace("silotown_gg_fire", eSpeakerHouse.origin);
		wait 1;
		//eFlak88 thread maps\_flak88::fire(eFlaktarget.origin);
		eFlak88 fireTurret();
		wait 8 + randomfloat(3);
	}
}

flak88_crew_deathwaiter()
{
	//Field charge condition 1
	
	self waittill ("death");
	
	level notify ("begin field charge");
	level notify ("charge activated");
}

field_nearmiss()
{
	//Field charge condition 2
	//Make as many nearmiss triggers as needed (around patrolling enemies, etc.)
	
	aTriggers = getentarray("nearmiss", "targetname");
	for(i=0; i<aTriggers.size; i++)
	{
		aTriggers[i] thread field_nearmiss_detect();
	}
}

field_nearmiss_detect()
{
	tPlayer = getent("nearmiss_playerpos", "targetname");
	while(1)
	{
		self waittill ("trigger");
		if(level.player istouching(tPlayer))
		{
			level notify ("begin field charge");
			level notify ("charge activated");
			break;
		}		
	}
}

field_axis_wakeupcall()
{
	level waittill ("begin field charge");
	
	//Flak88 crew abandons gun and starts fighting
	
	tFlakStop = getent("stop flak88", "targetname");
	tFlakStop notify ("trigger");
	
	thread axis_ambient_speech();
	
	aAxis = getaiarray("axis");
	for(i=0; i<aAxis.size; i++)
	{
		aAxis[i].ignoreme = false;
	}
}

axis_ambient_speech()
{
	//Play the German voices in the distance
	/*
		silotown_gg_takecover
		silotown_gg_pinneddown
		
		silotown_gg_enemysighted
		silotown_gg_fireatwill
		silotown_gg_fire
		
		silotown_gg_defensiveposition
		silotown_gg_keepshooting
		
		silotown_gg_overleftflank
		silotown_gg_leftflank
		silotown_gg_someonecoverme
		silotown_gg_mg42team
		silotown_gg_overtheleftflank
		silotown_gg_overrightflank
		silotown_gg_gogogo
		
		silotown_gg_onedown
		silotown_gg_igotone
	*/
	
	eSpeakerFlak88 = getent("speaker_flak88", "targetname");
	eSpeakerHouse = getent("speaker_house", "targetname");
	eSpeakerLeftgap = getent("speaker_leftgap", "targetname");
	
	wait 3;
	
	//++++replace these old CoD1 lines with CoD2 recordings
	/*
	maps\_utility::playSoundinSpace("silotown_gg_takecover", eSpeakerFlak88.origin);
	maps\_utility::playSoundinSpace("silotown_gg_pinneddown", eSpeakerFlak88.origin);
	maps\_utility::playSoundinSpace("silotown_gg_enemysighted", eSpeakerHouse.origin);
	thread maps\_utility::playSoundinSpace("silotown_gg_fireatwill", eSpeakerLeftgap.origin);
	*/
	wait 1;
	
	//maps\_utility::playSoundinSpace("silotown_gg_fire", eSpeakerHouse.origin);
}

//=======================================================================================================================================================//

skiptotown_init()
{
	thread town_endless_skirmish();
	thread town_player_arrival();
	
	level.mccloskey = getent("mccloskey", "targetname") stalingradSpawn();
	level.mccloskey.animname = "mccloskey";
	level.mccloskey.anim_disablePain = true;
	level.mccloskey thread maps\_utility::magic_bullet_shield();
	level.mccloskey.accuracy = 0.6;
	level.mccloskey.script_bcdialog = 0;
	
	node = getnode("mccloskey_rifle_switch", "targetname");
	level.mccloskey setgoalnode(node);
	level.mccloskey.goalradius = 16;
	
	node = getnode("braeburn_fieldcross", "targetname");
	level.braeburn setgoalnode(node);
	level.braeburn.goalradius = 16;
	
	node = getnode("randall_endnode", "script_noteworthy");
	level.randall setgoalnode(node);
	level.randall.goalradius = 16;
	
	level.randall thread heroDelete();
	level.mccloskey thread heroDelete();
	level.braeburn thread heroDelete();
}

skiptownbattle_init()
{
	wait 0.05;
	level.eSiloHatch delete();
	aTrigs = getentarray("flood_and_secure", "targetname");
	for(i=0; i<aTrigs.size; i++)
	{
		aTrigs[i] delete();
	}
}

town_player_arrival()
{
	//make noisemaker enemies vulnerable once player is close enough to attack them
	
	level endon ("town captured");
	
	eTrig = getent("welcomewagon_trigger", "targetname");
	eTrig waittill ("trigger");
	
	flag_set("player has joined the battle");
	
	//make them move out of the player's way and follow the player
	
	aAllies = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].dontavoidplayer = false;
		aAllies[i] allowedstances("stand", "crouch", "prone");
	}
	
	battleChatterOn("allies");
	
	triggerSave = getent("reachedtownsave", "targetname");
	triggerSave waittill ("trigger");
	
	thread autoSaveByName ("reachedtown");
}

town_welcomewagon()
{
	level endon ("team arrived early");
	
	eTrig = getent("welcomewagon_trigger", "targetname");
	eTrig waittill ("trigger");
	
	level notify ("player arrived early");
	
	aWelcomeParty = getentarray("noisemaker_spawner", "targetname");
	for(i=0; i<aWelcomeParty.size; i++)
	{
		nSoldier = aWelcomeParty[i] doSpawn();
		if(spawn_failed(nSoldier))
		{
			continue;
		}
	
		nSoldier.goalradius = 1024;
		nSoldier.suppressionwait = 0;
		nSoldier thread enemy_deathmonitor();
	}
}

enemy_deathmonitor()
{
	self waittill ("death", nAttacker);
	if(isdefined(nAttacker) && nAttacker == level.player)
	{
		flag_set("player_killed_one_guy");
	}
}

playerRushKill()
{
	trig = getent("playerKillTrigger", "targetname");
	trig waittill ("trigger");
	
	if(!flag("player_killed_one_guy"))
	{
		level.player enableHealthShield( false );
		for(i=0; i<4; i++)
		{
			level.player doDamage (level.player.health*0.25, level.player.origin);	//killplayer
			if(i%2 == 0)
			{
				thread playsoundinspace("bullet_large_flesh", level.player.origin);
			}
			else
			{
				thread playsoundinspace("bullet_small_flesh", level.player.origin);
			}
			wait randomfloatrange(0.15, 0.5);
		}
		
		level.player doDamage (level.player.health, level.player.origin);	//killplayer
		level.player enableHealthShield( true );
	}
}

town_endless_skirmish()
{
	//Invincible friendlies fight invincible enemies until the player crosses the field and catches up
	//Makes it seem like the game continues without waiting for the player, battle rages on
	
	level endon ("player arrived early");
	
	if (getcvar("skipto") == "" || getcvar("skipto") == "field")
	{	
		flag_wait("field completed");
		level notify ("team arrived early");
	}

	//route Allies to fight from their short wall (change the terminal positions, no more waiting around for player)
	//spawn enemies to their short wall until player hits a termination trigger within sight of the enemy
	//make everyone invulnerable until the player shows up
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i] thread maps\_utility::magic_bullet_shield();	
	}
	
	aNoisemaker = getentarray("noisemaker_spawner", "targetname");
	for(i=0; i<aNoisemaker.size; i++)
	{
		nSoldier = aNoisemaker[i] doSpawn();
		if(spawn_failed(nSoldier))
		{
			continue;
		}
		nSoldier thread maps\_utility::magic_bullet_shield();	
		nSoldier thread town_endless_dropshield();
		nSoldier thread enemy_deathmonitor();
		
		nSoldier.goalradius = 128;
		nSoldier.suppressionwait = 0;
		nSoldier.accuracy = 0;
	}
}

town_endless_dropshield()
{
	flag_wait("player has joined the battle");
	self notify ("stop magic bullet shield");
}

town_silo_climb()
{
	if(getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing")		
		level waittill ("midbriefing done");
	
	//++++Send the player into the silo with McCloskey and Braeburn in town

	nBraeburn = getnode("braeburn_perch", "targetname");
	level.braeburn.goalradius = 8;
	level.braeburn setgoalnode(nBraeburn);
	
	nMcCloskey = getnode("mccloskey_doorman", "targetname");
	level.mccloskey.goalradius = 8;
	level.mccloskey.dontavoidplayer = true;
	level.mccloskey setgoalnode(nMcCloskey);
	level.mccloskey.anim_disablePain = true;

	level.braeburn waittill ("goal");
	level.mccloskey waittill ("goal");
	
	flag_set("silo_occupied");
	
	level.braeburn.goalradius = 8;
	level.braeburn allowedStances ("crouch");
	
	//Use Braeburn to block the silo exit - if player is in place when this is ready, complete the objective

	if(getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing")
	{
		eTrigger = getent("silo_entry_trigger", "targetname");
		eTrigger waittill ("trigger");
	}
	
	failSafeBlocker = getent("playerRestraint", "targetname");
	failSafeBlocker solid();

	nBlocker = getnode("mccloskey_blocker", "targetname");
	level.mccloskey pushPlayer(true);
	level.mccloskey setgoalnode(nBlocker);
	level.mccloskey allowedStances ("crouch");
	level.mccloskey.ignoreme = true;
	level.mccloskey.team = "neutral";

	flag_set("player in silo");
}

town_silo_ladder_handling()
{
	if(getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing")
	{
		if(!flag("silo_occupied"))
			level waittill ("midbriefing done");
	}
	
	//McCloskey & Braeburn become non-solid while player is touching the silo ladder
	
	level endon ("silo_occupied");
	
	level.oldcontents1 = level.braeburn setcontents(0);
	level.oldcontents2 = level.mccloskey setcontents(0);	
	
	level.braeburn setcontents(level.oldcontents1);
	level.mccloskey setcontents(level.oldcontents2);
	
	volume = getent("ladder_presence", "targetname");
	while(1)
	{
		if(level.player isTouching(volume))
		{
			level.braeburn setcontents(0);
			level.mccloskey setcontents(0);	
		}
		else
		{
			level.braeburn setcontents(level.oldcontents1);
			level.mccloskey setcontents(level.oldcontents2);
		}
		
		wait 0.05;
	}
}

town_silo_solidify()
{
	if(getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing")
		level waittill ("midbriefing done");
	
	flag_wait("silo_occupied");
	
	//Force McCloskey & Braeburn to be solid
	
	level.braeburn setcontents(level.oldcontents1);
	level.mccloskey setcontents(level.oldcontents2);	
}

town_defense_randall_lastofem()
{
	wait 0.5;
	
	level.randall.goalradius = 16;
	level.braeburn.goalradius = 16;
	level.mccloskey.goalradius = 16;
	
	wait 1;
	
	//DIALOGUE: "All right, I think that's the last of 'em! Everyone assemble on me!"
	level.randall Dialogue_Thread("silotown_rnd_lastofem");
}

town_defense_randall_briefing()
{	
	//The guys regroup for a quick dialogue plan
	
	//Respawn the main characters who would by now have been deleted
	
	aSpawners = getspawnerarray();
	for(i=0; i<aSpawners.size; i++)	
	{
		if(!isdefined(aSpawners[i].script_friendname))
			continue;
			
		if(aSpawners[i].script_friendname == "Sgt. Randall")
		{
			level.randall = aSpawners[i] doSpawn();
			level.randall.animname = "randall";
			level.randall pushPlayer(true);
			level.randall thread maps\_utility::magic_bullet_shield();
		}
		
		if(aSpawners[i].script_friendname == "Pvt. Braeburn")
		{
			level.braeburn = aSpawners[i] doSpawn();
			level.braeburn.animname = "braeburn";
			level.braeburn thread maps\_utility::magic_bullet_shield();
		}
		
		if(!isdefined(aSpawners[i].script_noteworthy))
			continue;
			
		if(aSpawners[i].script_noteworthy == "Pvt. McCloskey returns")
		{
			level.mccloskey = aSpawners[i] doSpawn();
			level.mccloskey.animname = "mccloskey";
			level.mccloskey thread maps\_utility::magic_bullet_shield();
		}
	}
	
	thread town_defense_randall_lastofem();
	
	battleChatterOff("allies");
	
	schoolcircle("midbriefing_schoolcircle_node", "Sgt. Randall", "midbriefing_randall_node", level.randall, "midbriefing_point");
	
	randallNode = getnode("midbriefing_randall_node", "targetname");
	
	//DIALOGUE: "Corporal Taylor, climb that silo with Braeburn and McCloskey and watch for an enemy counterattack."
	level.randall Dialogue_Thread("silotown_rnd_climbsilo", randallNode);
	
	//DIALOGUE: "Everyone else, take up positions around the perimeter and stay sharp!"
	level.randall Dialogue_Thread("silotown_rnd_everyoneelse", level.randall);
	
	level notify ("midbriefing done");
	
	thread town_midbriefing_save();
}

town_midbriefing_save()
{
	thread autoSaveByName ("silo order received");
}

town_defense_preparations()
{	
	if(getcvar("skipto") != "defense")
		level waittill ("midbriefing done");
	
	aGroundTeam = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(!isdefined(aAllies[i].script_friendname))
		{
			aGroundTeam[aGroundTeam.size] = aAllies[i];
		}
		else
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname != "Pvt. Braeburn" && aAllies[i].script_friendname != "Pvt. McCloskey")
		{
			aGroundTeam[aGroundTeam.size] = aAllies[i];
		}
		
		if(isdefined(aAllies[i].script_friendname) && (aAllies[i].script_friendname == "Pvt. Braeburn" || aAllies[i].script_friendname == "Pvt. McCloskey"))
		{
			aAllies[i].grenadeawareness = 0;
			aAllies[i].grenadeammo = 0;
		}
	}
	
	//Move the rest of the Allies to various positions.
	
	aDefenseNodes = getnodearray("defense_prep_node", "targetname");
	for(i=0; i<aGroundTeam.size; i++)
	{
		aGroundTeam[i].goalradius = 32;
		aGroundTeam[i] setgoalnode(aDefenseNodes[i]);
		aGroundTeam[i] thread town_defense_soldier_stats();
	}
	
	flag_set("defenders in position");
}

town_defense_soldier_stats()
{
	self waittill ("goal");
	self.goalradius = 1024;
	self.accuracy = 0.5;
}

town_defense()
{
	flag_wait("defenders in position");
	flag_wait("player in silo");
	
	//Once everyone is in place, force the player to complete the 'pick up the sniper rifle' objective
	
	flag_wait("player_has_sniper_rifle");

	//Give the player some time to familiarize self with environment before starting the counterattack
	
	wait level.surveyTime;
	
	//Now start the German counterattack
	
	flag_set("timed_defense");
	
	//Make sure the German ambient track switches to contain more distant shouts, using script_origins
	
	level.player.threatbias = 100000;
	
	thread town_assault_schedule();
	thread town_assault_enemyshouts();
	
	//Bring in the enemy mortar teams to kill the player periodically
	
	thread mortar_group_control();
	
	battleChatterOn("allies");
}

town_defense_autosaves()
{
	flag_wait("defenders in position");
	flag_wait("player in silo");
	
	level waittill ("start stopwatch");
	
	//autosave every 25% of town defense time completion, but not if player is in danger of being mortared
	
	wait (level.stopwatch*60*0.25);
	if(level.savehere)
		thread autoSaveByName ("townDefense1");
	
	level.savehere = true;
	wait (level.stopwatch*60*0.25);
	
	if(level.savehere)
		thread autoSaveByname ("townDefense2");
	
	level.savehere = true;	
	wait (level.stopwatch*60*0.25);
	
	if(level.savehere)
		thread autoSaveByname ("townDefense3");
		
	level.savehere = true;
	wait (level.stopwatch*60*0.25);
	
	if(level.savehere)
		thread autoSaveByname ("townDefense4");
}

town_assault_enemyshouts()
{
	level endon ("retreat");
	
	wait (level.stopwatch*60*0.10);
	speaker = getent("german_amb_speaker1", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi1_80mmmorter", speaker.origin);
	
	wait (level.stopwatch*60*0.10);
	speaker = getent("german_amb_speaker2", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi2_lieutenant", speaker.origin);
	
	wait (level.stopwatch*60*0.20);
	speaker = getent("german_amb_speaker3", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi1_extramorterrounds", speaker.origin);
	
	wait (level.stopwatch*60*0.18);
	speaker = getent("german_amb_speaker4", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi1_overtoright", speaker.origin);
	
	wait (level.stopwatch*60*0.12);
	speaker = getent("german_amb_speaker5", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi2_halftrack", speaker.origin);
	
	wait (level.stopwatch*60*0.14);
	speaker = getent("german_amb_speaker6", "targetname");
	maps\_utility::playSoundinSpace("silotown_gi2_grouptwo", speaker.origin);
}

town_assault_schedule()
{	
	level endon ("retreat");
	
	thread army_group_control("southeast");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("southwest");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("northeast");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("northwest");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("southwest");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("southeast");
	town_assault_schedule_recycle(20);
	
	thread army_group_control("southwest");
	thread army_group_control("northwest");
	town_assault_schedule_recycle(60);
	
	thread army_group_control("northeast");
	thread army_group_control("southeast");
	town_assault_schedule_recycle(60);
	
	thread army_group_control("northeast");
	thread army_group_control("southeast");
	thread army_group_control("southwest");
	thread army_group_control("northwest");
	town_assault_schedule_recycle(60);
}

town_assault_schedule_recycle(pausetime)
{
	level endon ("retreat");
	
	notifyWait = 1;
	
	wait pauseTime;
	level notify ("reset army group control");
	wait notifyWait;
}

town_timed_defense()
{	
	//if (getcvar("skipto") != "defense")	//chapter break handler
		flag_wait("timed_defense");
	
	level.braeburn endon ("death");
	level.braeburn.speaking = true;
	
	wait 2;	//soft wait
	
	aAllies = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && (aAllies[i].script_friendname == "Sgt. Randall" || aAllies[i].script_friendname == "Pvt. McCloskey" || aAllies[i].script_friendname == "Pvt. Braeburn"))	
			continue;
		aAllies[i].animname = "gr1";
		//DIALOGUE: "Here they come!!!"
		aAllies[i] Dialogue_Thread("silotown_gr1_heretheycome");		
		break;
	}
	
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && (aAllies[i].script_friendname == "Sgt. Randall" || aAllies[i].script_friendname == "Pvt. McCloskey" || aAllies[i].script_friendname == "Pvt. Braeburn"))	
			continue;
		aAllies[i].animname = "gr2";
		//DIALOGUE: "German counterattack!"
		aAllies[i] Dialogue_Thread("silotown_gr2_counterattack");
		break;
	}
	
	wait 4;	//soft wait on triggering enemy counterattack before starting dialogue and stopwatch
	
	//DIALOGUE: "Braebuuurn!!!! Get through to Captain Blake and get us some reinforcements!!"
	level.randall Dialogue_Thread("silotown_rnd_getthru");
	
	wait 0.5;
	
	//DIALOGUE: "I'm on it Sarge!!!"
	level.braeburn Dialogue_Thread("silotown_braeburn_onitsarge");
	
	wait 3;
	
	//++++Braeburn talks into his radio handset, need anim
	
	//DIALOGUE: "Baker Six this is Baker One-Four, objective taken at Rally Point Echo! Enemy infantry counterattacking in force, request additional support, over!"
	level.braeburn Dialogue_Thread("silotown_braeburn_request");
	
	wait 0.75;
	
	maps\_utility::playSoundinSpace("silotown_blake_shermans", level.braeburn.origin);
	
	wait 0.5;
	
	//DIALOGUE: "Due respect sir, I don't think we're gonna last that long! Over!"
	level.braeburn Dialogue_Thread("silotown_braeburn_respect");
	
	wait 0.75;
	
	maps\_utility::playSoundinSpace("silotown_blake_calmdown", level.braeburn.origin);
	
	level.braeburn.speaking = false;
	
	thread town_defensesave();
	
	level.braeburn allowedStances ("stand");
	
	objective_stopwatch();	//acts as a waitthread as well as showing the countdown timer
	
	flag_set("retreating");		//turns off mortar teams and Braeburn's mortar team spotting dialogue
	level notify ("retreat"); 	//enemy begins retreat after player has successfully survived a certain amount of time
}

town_defensesave()
{
	thread autoSaveByName ("infantrydefense");	//save AFTER the talking is done
}

town_tankspawn()
{	
	if (getcvar("skipto") == "" || getcvar("skipto") == "field" || getcvar("skipto") == "town" || getcvar("skipto") == "midbriefing" || getcvar("skipto") == "defense" || getcvar("skipto") == "infantry")
		level waittill ("spawn friendly tanks");
	
	//level.sherman1 = maps\_vehicle::vehicle_spawn(level.tankSpawner1);
	//level.sherman2 = maps\_vehicle::vehicle_spawn(level.tankSpawner2);
	
	
	vehicle1 = maps\_vehicle::scripted_spawn(0);
	vehicle2 = maps\_vehicle::scripted_spawn(1);
	
	wait 4;
	
	vehicle6 = maps\_vehicle::scripted_spawn(5);
	
	wait 3;
	
	vehicle5 = maps\_vehicle::scripted_spawn(4);
	
	wait 3;
	
	vehicle3 = maps\_vehicle::scripted_spawn(2);
	vehicle4 = maps\_vehicle::scripted_spawn(3);
	
	wait 4;
	
	vehicle7 = maps\_vehicle::scripted_spawn(6);
}

town_tankmove(name)
{
	vehicle = maps\_vehicle::waittill_vehiclespawn(name);
    	maps\_vehicle::gopath(vehicle);
}

town_german_evac()
{
	//notifies all Germans dead or departed after the reinforcements have arrived
	
	if (getcvar("skipto") != "retreat")	//chapter break handler
		level waittill ("retreat");
	
	thread autoSaveByName ("german retreat");
	
	wait 0.5;
	
	ent = spawnstruct();
	ent.count = 0;
	node = undefined;
	
	aRetreatnodes = getnodearray("axis_retreatnode", "targetname");
	aAxis = getaiarray("axis");
	
	if(aAxis.size > 0)
		thread dialogue_retreat();
	
	for(i=0; i<aAxis.size; i++)
	{	
		if(!isdefined(aAxis[i].script_squadname))
			continue;
		if(aAxis[i].script_squadname == "alpha" || aAxis[i].script_squadname == "mortarteam_alpha")
		{
			node = thread town_german_evac_nodescan("alpha", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "beta" || aAxis[i].script_squadname == "mortarteam_beta")
		{
			node = thread town_german_evac_nodescan("alpha", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "gamma" || aAxis[i].script_squadname == "mortarteam_gamma")
		{
			node = thread town_german_evac_nodescan("gamma", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "delta" || aAxis[i].script_squadname == "mortarteam_delta")
		{
			node = thread town_german_evac_nodescan("delta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "epsilon" || aAxis[i].script_squadname == "mortarteam_epsilon")
		{
			node = thread town_german_evac_nodescan("epsilon", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "zeta" || aAxis[i].script_squadname == "mortarteam_zeta")
		{
			node = thread town_german_evac_nodescan("zeta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "eta" || aAxis[i].script_squadname == "mortarteam_eta")
		{
			node = thread town_german_evac_nodescan("eta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "theta" || aAxis[i].script_squadname == "mortarteam_theta")
		{
			node = thread town_german_evac_nodescan("theta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "iota" || aAxis[i].script_squadname == "mortarteam_iota")
		{
			node = thread town_german_evac_nodescan("theta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "kappa" || aAxis[i].script_squadname == "mortarteam_kappa")
		{
			node = thread town_german_evac_nodescan("theta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "lambda" || aAxis[i].script_squadname == "mortarteam_lambda")
		{
			node = thread town_german_evac_nodescan("delta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "mu" || aAxis[i].script_squadname == "mortarteam_mu")
		{
			node = thread town_german_evac_nodescan("zeta", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "nu" || aAxis[i].script_squadname == "mortarteam_nu")
		{
			node = thread town_german_evac_nodescan("alpha", aRetreatnodes);
		}
		if(aAxis[i].script_squadname == "xi" || aAxis[i].script_squadname == "mortarteam_xi")
		{
			node = thread town_german_evac_nodescan("gamma", aRetreatnodes);
		}
		
		aAxis[i] thread town_german_evac_monitor(node, ent);
	}
	
	while(1)
	{
		if(ent.count <= 0)
		{
			break;
		}
		
		level waittill ("axis unit retreated");
	}
	
	flag_set("area secure");
}

town_german_evac_nodescan(squadname, array)
{
	for(i=0; i<array.size; i++)
	{
		if(!isdefined(array[i].script_squadname))
			continue;
		if(array[i].script_squadname == squadname)
			return(array[i]);
	}
}

town_german_evac_monitor(node, ent)
{
	//enemies are considered to have retreated if they reach their goal (and deleted) or are killed en route
	
	ent.count++;
	self thread town_german_evac_nav(node);
	self waittill ("death");
	ent.count--;
	level notify ("axis unit retreated");
}

town_german_evac_nav(node)
{
	self endon ("death");
	self thread town_german_evac_failsafe();
	
	wait randomintrange(1,4);
	self setgoalnode(node);
	self.goalradius = 64;
	self.pathenemyfightdist = 32;
	self.pathenemylookahead = 640;
	self.maxdist = 8;
	
	self waittill ("goal");
	self doDamage (self.health, self.origin);
	//self delete();
}

town_german_evac_failsafe()
{
	self endon ("death");
	wait level.failsafeTime;
	self doDamage (self.health, self.origin);
}

objective_stopwatch()
{
	level notify ("start stopwatch");
	
	fMissionLength = level.stopwatch;							//how long until relieved (minutes)	
	iMissionTime_ms = gettime() + int(fMissionLength*60*1000);	//convert to milliseconds
	
	// Setup the HUD display of the timer.
	
	level.hudTimerIndex = 20;
	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    level.timer.vertAlign = "top";
    if(level.xenon)
	{
		level.timer.fontScale = 2;
		level.timer.x = -225;
	}
	else
	{
		level.timer.fontScale = 1.6;    
		level.timer.x = -180;
	}
	level.timer.y = 100;
	level.timer.label = &"SILOTOWN_ASSAULT_REINFORCEMENTS";
	level.timer setTimer(level.stopwatch*60);
	
	x = 10;
	
	thread music_ending();
	
	wait(level.stopwatch*60 - x);
	
	//x seconds ahead of victory notification (which activates the next objective), tanks enter, cosmetic
	level notify ("spawn friendly tanks");

	wait x;
	
	level.timer destroy();
}

targets_of_opportunity()
{	
	while(level.buildingscleared < 5)
	{
		level waittill ("building_cleared");
	}
	
	trig = getent("opportunity_stop", "targetname");
	trig notify ("trigger");
}

mortar_group_control()
{
	//use a variable that controls the allowed number of mortar teams within an available AI population space
	//randomly pick a team, alpha-theta if there is available AI population space, e.g. script_squadname = mortarteam_gamma
	//pass collected arrays to the mortar team global script - spawners, dest nodes, target points
	//loop this function
	
	//==============
	
	//two extra slots are always reserved for a mortar team deployment, infantry squads can't impinge on these slots
	//up to level.mortarTeamPopLimit mortar teams can be active at peak difficulty/intensity
	//no more than one mortar team may use a given location's teamcode at any time (avoid piling up on same spot)
	
	level endon ("retreat");
	
	deployLock = false;
	
	//Initialize indices required by objective_additionalposition script command, for each mortar team
	level.teamIndices = [];
	
	teamName[0] = "alpha";
	teamName[1] = "beta";
	teamName[2] = "gamma";
	teamName[3] = "delta";
	teamName[4] = "epsilon";
	teamName[5] = "zeta";
	teamName[6] = "eta";
	teamName[7] = "theta";
	teamName[8] = "iota";	//++++weird pathing issue with the mortar carrier
	teamName[9] = "kappa";
	teamName[10] = "lambda";
	teamName[11] = "mu";
	teamName[12] = "nu";
	teamName[13] = "xi";
	
	for (i=0;i<teamName.size;i++)
		level.inUse[teamName[i]] = false;
	
	teamName = array_randomize(teamName);		
	index = 0;
	
	while(!flag("retreating"))
	{	
		//prevent consecutive mortar team spawns from the same spot
		
		//if (level.inUse[teamName[index]])
			//continue;
			
		if (level.inUse[teamName[index]])
		{
			index++;
			
			if (index >= teamName.size)
			{
				//teamName = array_randomize(teamName);			
				index = 0;
			}	
			
			wait 0.05;
			continue;
		}		

		if(flag("retreating"))
			break;

		if(level.mortarTeamSlots < level.mortarTeamPopLimit)
		{	
			level.inUse[teamName[index]] = true;		//position slot in use
			thread mortarteam_deploy(teamName[index]);
			index++;
			level.mortarActiveTeams++;				//dev monitor
			level.mortarTeamSlots++;				//population slot taken
			
			deployLock = true;
		}
	
		teamName = array_randomize(teamName);		
	
		if (index >= teamName.size)
		{	
			index = 0;
				
			//for (i=0;i<teamName.size;i++)
				//level.inUse[teamName[i]] = false;
		}		
		
		if(deployLock)
		{
			if(isdefined(level.mortarDeployGap))
			{
				wait level.mortarDeployGap;	//this is used for overlapping spawns if desired, for increased difficulty
			}
			else
			{
				level waittill ("no mortar teams");	//this is used to force non-overlapping spawns, 1 at a time method
			}

			deployLock = false;
		}
		else
		{
			wait 0.1;
		}
	}
}

mortarteam_deploy(strTeamcode)
{
	//Mortar team behavior in the global script
	//The mortar carrier guy must remain alive until he is SETUP, or the whole sequence is terminated.
	//If the mortar carrier guy gets to his destination and is SETUP, both the carrier and the assistant must be killed...
	//The assistant can take over firing duties if the carrier is killed and vice versa.
	//They will do a paired firing animation if they are both alive on station with SETUP completed.
	
	//This thread gets the spawners, destnodes, and mortarsquibs for a team with the desired strTeamcode and
	//sends these arrays to the global script.

	level endon ("retreat");
	
	/*	
	ent = spawnstruct();
	ent.count = 0;
	ent.attemptCount = 0;		//tally of attempts by this team to mortar the player in the silo
	ent.script_namenumber = undefined;

	nMortarAssistant = undefined;
	nMortarCarrier = undefined;

	ent endon ("mortarteam intercepted");
	*/
	
	//Assemble names
	
	strMortarcode = "mortarteam_" + strTeamcode;
	strDestcode = "mortarposition_" + strTeamcode;
	
	//Get the correct spawners for the chosen team
	
	aSpawner = getspawnerarray();	
	aSpawnTeam = [];
	
	for(i=0; i<aSpawner.size; i++)
	{
		if(!isdefined (aSpawner[i].script_squadname))
			continue;
		if(aSpawner[i].script_squadname != strMortarcode)
			continue; 
		aSpawnTeam[aSpawnTeam.size] = aSpawner[i];
	}
	
	//Get the correct destination nodes for the chosen team
	
	aMortarDests = getnodearray(strDestcode, "targetname");
	
	//Plot a randomized course
	
	nDestNode = aMortarDests[randomint(aMortarDests.size)];
	
	//Get the correct squibs for the chosen team
	
	aImpacts = [];
	aImpactEnts = [];
	aImpactEnts = getentarray("mortarImpactPoint", "targetname");
	for(i=0; i<aImpactEnts.size; i++)
	{
		if(!isdefined(aImpactEnts[i].script_noteworthy))
			continue;
		if(aImpactEnts[i].script_noteworthy != strTeamcode)
			continue;
		aImpacts[aImpacts.size] = aImpactEnts[i];
	}
	
	//Assign an additionalposition index to avoid objective index overflow
	
	ent = spawnstruct();
	
	foundEmptyIndex = false;
	
	for(i=0; i<level.mortarIndexSize; i++)
	{
		if(isdefined(level.teamIndices[i]))
			continue;
		
		foundEmptyIndex = true;
		level.teamIndices[i] = ent;
		ent.index = i;
		break;
	}
	
	//Send array + random dest node to mortarteam global script
	
	mortarEnt = maps\_mortarTeam::mortarTeam(aSpawnTeam, nDestNode, aImpacts, 1, 2);
	mortarEnt thread objectiveThink(ent, strTeamcode);
	mortarEnt thread mortar_impact_playerkill();
	mortarEnt thread mortarteam_speechQueue(strTeamcode);
	
	//Spawn and start death/arrival monitor threads for a team that is en route but has not setup the mortar tube
	/*
	thread mortar_team_intercepted(ent, strTeamcode);
	
	for(i=0; i<aSpawnTeam.size; i++)
	{
		aSpawnTeam[i].count = 1;
		nMortarGuy = aSpawnTeam[i] doSpawn();	
		if(spawn_failed(nMortarGuy))
		{
			continue;
		}
		
		nMortarGuy setgoalnode(nDestNode);
		nMortarGuy.goalradius = 64;
		if(isdefined(nMortarGuy.script_noteworthy) && nMortarGuy.script_noteworthy == "mortar_carrier")
		{
			nMortarCarrier = nMortarGuy;
			nMortarGuy thread mortar_carrier_death(ent);
			nMortarGuy thread mortar_carrier_arrival(ent, strTeamcode);
		}
		else
		{	
			nMortarAssistant = nMortarGuy;
			nMortarGuy thread mortar_assistant_arrival(ent);
		}
	}
	
	level.teamIsAlive[strTeamcode] = true;
	
	foundEmptyIndex = false;
	
	for(i=0; i<level.mortarIndexSize; i++)
	{
		if(isdefined(level.teamIndices[i]))
			continue;
		
		foundEmptyIndex = true;
		level.teamIndices[i] = ent;
		ent.index = i;
		break;
	}
	
	assert(foundEmptyIndex);
	
	//Compass ping management	
	//thread mortar_team_compass(nMortarCarrier, nMortarAssistant, ent);
	//thread mortar_team_compass_eraseIntercept(ent);
	//thread mortar_team_compass_eraseDestroyed(ent);
	
	//ent waittill ("mortar is setup");
	
	//Enable different elimination conditions for a team that is already setup
	
	//if(isAlive(nMortarCarrier))
		//nMortarCarrier thread mortar_team_death_inposition(ent);
	//if(isAlive(nMortarAssistant))
		//nMortarAssistant thread mortar_team_death_inposition(ent);
	
	//thread mortar_team_death(ent, strTeamcode);
	
	//wait 3;	//natural pause, free shot for player
	
	//thread mortarteam_firecontrol(ent, nMortarCarrier, nMortarAssistant, strTeamcode);
	
	*/
}
/*
mortar_team_compass(nMortarCarrier, nMortarAssistant, ent)
{
	//Displays a ping on the compass continuously on the mortar team
	
	ent endon ("mortarteam intercepted");
	ent endon ("setup team destroyed");

	while(1)
	{
		if(isalive(nMortarCarrier))
		{
			objective_additionalposition(level.mortarObjNumber, ent.index, nMortarCarrier.origin);
		}
		else
		if(isalive(nMortarAssistant))
		{
			objective_additionalposition(level.mortarObjNumber, ent.index, nMortarAssistant.origin);
		}
		
		objective_ring(level.mortarObjNumber);
		wait 1;
	}
}

mortar_team_compass_eraseIntercept(ent)
{
	ent endon ("setup team destroyed");
	ent waittill ("mortarteam intercepted");
	objective_additionalposition(level.mortarObjNumber, ent.index, (0,0,0));
}

mortar_team_compass_eraseDestroyed(ent)
{
	ent endon ("mortarteam intercepted");
	ent waittill ("setup team destroyed");
	objective_additionalposition(level.mortarObjNumber, ent.index, (0,0,0));
}

mortar_team_intercepted(ent, strTeamcode)
{
	ent endon ("mortar is setup");
	
	//Destroyed en route to firing position, frees up a population slot and a position slot
	ent waittill ("mortarteam intercepted");
	thread mortar_deathinfo(ent, strTeamcode);
}

mortar_carrier_death(ent)
{	
	//If mortar is already setup, carrier death does nothing
	//If mortar is not setup, carrier death stops the whole sequence
	
	ent endon ("mortar is setup");
	
	self waittill ("death", nAttacker);
	ent notify ("mortarteam intercepted");
	if(isdefined(nAttacker) && nAttacker == level.player)
		level notify ("player killed a mortar team");
}

mortar_carrier_arrival(ent, strTeamcode)
{
	ent endon ("mortarteam intercepted");
	self waittill ("goal");
	
	//++++Mortar setup animation here
	
	thread temp_message(self, "SETTING UP MORTAR TUBE", 4, undefined, 256);
	wait 4;	//temp for anim
	
	thread temp_message(self, "MORTAR TUBE READY", 4, undefined, 256);
	ent notify ("mortar is setup");
	level notify ("mortarteam is setup", strTeamcode);
	
	//Braeburn shouts a warning to the player if the mortar tube is setup
	//cancel pending speech with corresponding team death
	//if already talking, wait until done (simultaneous request problem, need to queue up requests)
	
	
		alpha = southeast
		beta = southeast
		gamma = northeast
		delta = north-northeast
		epsilon = north
		zeta = northwest
		eta = southwest
		theta = south-southwest
		
		iota = southwest (by halftrack)
		kappa = northwest (in field)
		lambda = north (at the fork in the road)
		mu = west (low, by the alley)
		nu = south-southeast (by the flak gun)
		xi = east (on the road)
	
}
*/

mortarteam_announcement_dialogue()
{
	level.mortarSpotSpeech["mortarteam_alpha"] = "silotown_braeburn_mortarfieldse";
 	level.mortarSpotSpeech["mortarteam_beta"] = "silotown_braeburn_mortarfieldse";
 	level.mortarSpotSpeech["mortarteam_gamma"] = "silotown_braeburn_mortarne";
 	level.mortarSpotSpeech["mortarteam_delta"] = "silotown_braeburn_mortarnne";
 	level.mortarSpotSpeech["mortarteam_epsilon"] = "silotown_braeburn_mortarnorth";
 	level.mortarSpotSpeech["mortarteam_zeta"] = "silotown_braeburn_mortarfieldnw";
 	level.mortarSpotSpeech["mortarteam_eta"] = "silotown_braeburn_mortarsw";
 	level.mortarSpotSpeech["mortarteam_theta"] = "silotown_braeburn_mortarsouth";
 	level.mortarSpotSpeech["mortarteam_iota"] = "silotown_braeburn_mortarhtsw";
 	level.mortarSpotSpeech["mortarteam_kappa"] = "silotown_braeburn_mortarfieldnw2";
 	level.mortarSpotSpeech["mortarteam_lambda"] = "silotown_braeburn_mortarnorthfork";
 	level.mortarSpotSpeech["mortarteam_mu"] = "silotown_braeburn_mortarwest";
 	level.mortarSpotSpeech["mortarteam_nu"] = "silotown_braeburn_mortarsseflak";
 	level.mortarSpotSpeech["mortarteam_xi"] = "silotown_braeburn_mortareastroad";
}

mortarteam_speechQueue(strTeamcode)
{	
	level endon ("retreating");
	level.braeburn endon ("death");
	self endon ("mortar_done");
 	
 	self waittill ("mortar_setup_finished", strTeamcode);
  
	if (!level.braeburn.speaking)
		thread mortarteam_announcement(strTeamcode);
}

mortarteam_announcement(strTeamcode)
{
	level.braeburn endon ("death");
	
 	level.braeburn.speaking = true;
 	level.braeburn Dialogue_Thread(level.mortarSpotSpeech[strTeamcode]);
 	wait 5;	//soft wait
 	level.braeburn.speaking = false;
}

/*
mortar_assistant_arrival(ent)
{
	ent endon ("mortarteam intercepted");
	self endon ("death");
	self waittill ("goal");
	ent.script_namenumber = "assistant ready";
}

mortar_team_death_inposition(ent)
{
	ent.count++;
	self waittill ("death", nAttacker);
	ent notify ("mortar soldier killed");
	ent.count--;
	if(isdefined(nAttacker) && nAttacker == level.player && ent.count == 0)
		level notify ("player killed a mortar team");
}

mortar_team_death(ent, strTeamcode)
{
	//Elimination condition for a team that is already setup, frees up a population slot and a position slot
	
	ent endon ("mortarteam intercepted");
	while(ent.count > 0)
	{
		ent waittill ("mortar soldier killed");
	}
	
	ent notify ("setup team destroyed");
	thread mortar_deathinfo(ent, strTeamcode);
}

mortar_deathinfo(ent, strTeamcode)
{
	level.teamIsAlive[strTeamcode] = false;
	level.mortarActiveTeams--;
	level notify ("mortar team destroyed");
	level.teamIndices[ent.index] = undefined;

	wait level.mortarTeamGapTime;	//time before opening the spawn gate again
	
	level notify ("no mortar teams");	//for easier difficulty levels, prevents any overlapping spawns, 1 team at a time only
	
	level.mortarTeamSlots--;
	level.inUse[strTeamcode] = false;	//was used to avoid concurrent spawns on the same mortar team spawners
}

mortarteam_firecontrol(ent, nMortarCarrier, nMortarAssistant, strTeamcode)
{
	//The mortar is already known to be SETUP. This thread can only end if BOTH the carrier and the assistant are dead.
	//The CARRIER is already known to be in the right spot to fire solo.
	//Loops forever until both guys in this mortar team are destroyed.
	//Checks if carrier is alive AND assistant is dead. Do the SINGLE anim on CARRIER.
	//Checks if assistant is alive AND carrier is dead AND that the assistant has reached the spot. Do the SINGLE anim on ASSISTANT.
	//Checks if BOTH carrier and assistant are alive AND that the assistant has not reached the spot. Do the SINGLE anim on CARRIER.
	//Checks if BOTH carrier and assistant are alive AND that the assistant has reached the spot. Do the PAIRED anim.
	
	//++++'A' type outer squib ring, 'B' type inner squib ring to make it look like they are bracketing the player, breakable geo
	//++++make them fire once, and set off an 'A' squib, then a 'B' squib, then blow up the player (targetname = silo_mortar_squib)
	//++++use an artillery fx and radius damage
	
	ent endon ("setup team destroyed");
	level endon ("retreat");
	
	while(1)
	{
		if(!isAlive(nMortarCarrier) && !isAlive(nMortarAssistant))
		{
			break;
		}
		if(isAlive(nMortarCarrier) && !isAlive(nMortarAssistant))
		{
			//fire using SOLO animation/animation timing on the CARRIER
			mortarteam_carrier_fire(nMortarCarrier, ent, strTeamcode);
		}
		if(isAlive(nMortarAssistant) && !isAlive(nMortarCarrier) && isdefined(ent.script_namenumber) && ent.script_namenumber == "assistant ready")
		{
			//fire using SOLO animation/animation timing on the ASSISTANT
			mortarteam_assistant_fire(nMortarAssistant, ent, strTeamcode);
		}
		if(isAlive(nMortarCarrier) && isAlive(nMortarAssistant) && !isdefined(ent.script_namenumber))
		{
			//fire using SOLO animation/animation timing on the CARRIER
			mortarteam_carrier_fire(nMortarCarrier, ent, strTeamcode);
		}
		if(isAlive(nMortarCarrier) && isAlive(nMortarAssistant) && isdefined(ent.script_namenumber) && ent.script_namenumber == "assistant ready")
		{
			//fire using PAIRED animations & animation timing on BOTH
			mortarteam_paired_fire(nMortarCarrier, nMortarAssistant, ent, strTeamcode);
		}
		
		wait 1;
	}
}

mortarteam_carrier_fire(nCarrier, ent, strTeamcode)
{
	level endon ("retreat");
	nCarrier endon ("death");
	
	if(level.flag["retreating"] == false)
	{
		//carrier fires solo
		thread temp_message(nCarrier, "MORTAR FIRED! - CARRIER SOLO ANIMATION", 4, undefined, 256);
		wait 1;	//temp - mortar carrier fire animation
		//++++mortar puff launch effect on tube
		thread mortar_impact_filter(ent, strTeamcode);
		wait 7;	//temp - mortar carrier reload & adjust animation
	}
}

mortarteam_assistant_fire(nAssistant, ent, strTeamcode)
{
	level endon ("retreat");
	nAssistant endon ("death");

	if(level.flag["retreating"] == false)
	{
		//assistant fires solo
		thread temp_message(nAssistant, "MORTAR FIRED! - ASSISTANT SOLO ANIMATION", 4, undefined, 256);
		wait 1;	//temp - mortar assistant fire animation
		//++++mortar puff launch effect on tube
		thread mortar_impact_filter(ent, strTeamcode);
		wait 7;	//temp - mortar assistant reload & adjust animation
	}
}

mortarteam_paired_fire(nCarrier, nAssistant, ent, strTeamcode)
{
	level endon ("retreat");
	nCarrier endon ("death");
	nAssistant endon ("death");
	
	if(level.flag["retreating"] == false)
	{
		//paired firing action
		thread temp_message(nCarrier, "MORTAR FIRED! - PAIRED ANIMATION", 4, undefined, 256);
		wait 1;	//temp - mortar paired fire animation
		//++++mortar puff launch effect on tube
		thread mortar_impact_filter(ent, strTeamcode);
		wait 7;	//temp - mortar paired reload & adjust animation
	}
}

mortar_impact_filter(ent, strTeamcode)
{
	level endon ("retreat");
	if(ent.attemptCount < level.mortarMisses)
	{
		aImpacts = [];
		aImpactEnts = [];
		aImpactEnts = getentarray("mortarImpactPoint", "targetname");
		for(i=0; i<aImpactEnts.size; i++)
		{
			if(!isdefined(aImpactEnts[i].script_noteworthy))
				continue;
			if(aImpactEnts[i].script_noteworthy != strTeamcode)
				continue;
			aImpacts[aImpacts.size] = aImpactEnts[i];
		}
		
		eHit = aImpacts[randomint(aImpacts.size)];
		eHit thread mortar_impact();
		ent.attemptCount++;
	}
	else
	{
		thread mortar_impact_playerkill();	
	}
}

mortar_impact()
{
	level endon ("retreat");
	//++++ script error here due to sound notify issue
	//self playsound ("mortar_incoming", "sounddone");
	self playsound ("mortar_incoming");
	//self waittill ("sounddone");
	wait 4;
	self playsound ("mortar_explosion");
	playfx ( level.mortar, self.origin );
}
*/

objectiveThink(ent, strTeamcode)
{
	self waittill ("objective_created");
	//level.createdMortars++;
	//index = level.createdMortars;
	
	index = ent.index;
	
	if (level.createdMortars == 1)
	{
		// first mortar to be created creates the objective
		//objective_add (level.mortarObjNumber, "active", "Kill the mortar teams [" + level.totalMortars + " remaining]");
		//objective_current(level.mortarObjNumber);
	}
	else
	{
		// new mortars add new objectives
		objective_additionalposition(level.mortarObjNumber, ent.index, self.objectivePositionEntity.origin);
	}
	thread updateObjective(index);
	thread updateObjectivePing(index);
	self waittill ("mortar_done");

	//Reset the counter so the objective index doesn't overflow (additional position only allows 0 thru 7)
	//Free up a slot
	
	level.teamIndices[ent.index] = undefined;
	level.mortarTeamSlots--;
	level.inUse[strTeamcode] = false;
	if(!isdefined(level.mortarDeployGap))
	{
		level notify ("no mortar teams");
	}
	
	//level.totalMortars--;
	
	//objective_string(level.mortarObjNumber, "Kill the mortar teams [" + level.totalMortars + " remaining]");
	
	//Deletes the compass star for this mortar team
	objective_additionalposition(level.mortarObjNumber, ent.index, (0,0,0));
	
	//if (!level.totalMortars)
		//objective_state (level.mortarObjNumber, "done");
}

updateObjective(index)
{
	level endon ("retreat");
	self endon ("mortar_done");
	for (;;)
	{
		//Track mortar team on compass and ping constantly
		objective_additionalposition(level.mortarObjNumber, index, self.objectivePositionEntity.origin);
		wait (0.05);
	}
}

updateObjectivePing(index)
{
	level endon ("retreat");
	self endon ("mortar_done");
	for (;;)
	{
		//Track mortar team on compass and ping constantly
		objective_ring(level.mortarObjNumber);
		wait (1);
	}
}


mortar_impact_playerkill()
{
	self endon ("mortar_done");
	level endon ("retreat");
	
	//Player and buddies are hit by a mortar in the silo after X misses
	
	i=0;
	while(i < level.mortarMisses + 1)
	{
		self waittill ("mortar_fired");
		i++;
		if(i >= level.mortarMisses - 3)	//don't allow saving if they are on their playerkill shot
		{
			level.savehere = false;
		}
	}
	
	thread mortar_impact_deathsequence();
}

mortar_impact_deathsequence()
{
	level.savehere = false;
	
	level.braeburn notify ("stop magic bullet shield");	
	level.mccloskey notify ("stop magic bullet shield");	
	
	eSiloTarget = getent("silo_mortar_squib", "targetname");
	playSoundinSpace("mortar_incoming", eSiloTarget.origin);
	wait 2.5;
	//playfx (level.mortar, eSiloTarget.origin);
	thread playSoundinSpace("mortar_explosion", eSiloTarget.origin);
	
	//radiusDamage(origin, range, maxdamage, mindamage);
	radiusDamage(eSiloTarget.origin, 1024, 10050, 10050);
	
	for(i=0; i<6; i++)
	{
		//playfx (level.mortar, eSiloTarget.origin);
		playfx (level.silodeathfx, level.player.origin);
		wait 0.05;
		
		if(i==3)
		{
			thread killplayer();
			
			if(level.xenon)
			{
				playRumbleOnPos("artillery_quake", level.player.origin);
			}
		}
	}
}

army_group_control(strAttackPattern)
{
	//***** Controls enemy squad deployments - basic infantry that encroach and try to kill the player if outside silo
	
	level endon ("reset army group control");
	level endon ("retreat");
	
	//flag "town invaded" is set to true when 50% of the player's mortar team kill requirement has been met
	
	/*
		alpha = southeast
		beta = southeast
		nu = south-southeast (by the flak gun)
		
		gamma = northeast
		delta = north-northeast
		
		epsilon = north
		lambda = north (at the fork in the road)
		
		zeta = northwest
		kappa = northwest (in field)
		
		eta = southwest
		theta = south-southwest
		iota = southwest (by halftrack)
		
		mu = west (low, by the alley)

		xi = east (on the road)
	*/
	
	if(strAttackPattern == "southeast")
	{	
		
		//Cycle spawning to the east, main front
		
		while(1)
		{	
			thread squad_assault(level.strNu);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strBeta);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strXi);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strNu);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strAlpha);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strXi);
			wait(level.fSpawnInterval);
		}
	}
	
	if(strAttackPattern == "northeast")
	{	
		//Cycle spawning to the north, fork area
		
		while(1)
		{
			thread squad_assault(level.strDelta);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strGamma);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strEpsilon);
			wait(level.fSpawnInterval);
			
			if(level.flag["town invaded"] == true)
			{
				thread squad_assault(level.strLambda);
				wait(level.fSpawnInterval);
			}
		}
	}
	
	if(strAttackPattern == "northwest")
	{		
		//Cycle spawning to the west, flakfield areas
		
		while(1)
		{
			thread squad_assault(level.strZeta);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strKappa);
			wait(level.fSpawnInterval);
			
			if(level.flag["town invaded"] == true)
			{
				thread squad_assault(level.strMu);
				wait(level.fSpawnInterval);
			}
		}
	}
	
	if(strAttackPattern == "southwest")
	{		
		//Cycle spawning to the west, flakfield areas
		
		while(1)
		{
			thread squad_assault(level.strEta);
			wait(level.fSpawnInterval);
			
			thread squad_assault(level.strTheta);
			wait(level.fSpawnInterval);
			
			if(level.flag["town invaded"] == true)
			{
				thread squad_assault(level.strIota);
				wait(level.fSpawnInterval);
			}
		}
	}
}


//=======================================================================================================================================================//
//=======================================================================================================================================================//

//**************************************//
//		INFANTRY COMBAT UTILITIES		//
//**************************************//

/*******************

Field crossing mechanic

1. Threats are spawned to use rifle/smg/autorifle/mg/maybe mortar/maybe AT-weapon
2. Threats have a "Time Before Guaranteed Allied Kill" that varies with the difficulty setting
3. Once this TBGAK is reached and the threat is still operational, it will kill an assigned enemy in its sector (left of right)
4. Once it has killed its assigned target, the threat will count down the TBGAK before killing another target.
5. If the TBGAK is reached but the enemy is out of sight, the assigned target still "dies by sniper" with a gunshot sound.
6. Certain threats will have the player as the assigned target.
7. The player can't cross the field without suiciding.
8. The Allied runners have pausepoints along their paths where they will appear to be pinned down behind cover.
9. The Allied runners, even in cover, can still be killed by player inaction. See rule #5.
9. The enemies will always miss until their TBGAK is reached, but maintain a high volume of fire.
10. Positional spawning of threats is completely random and unpredictable.

script_noteworthy on enemy team spawners for matching with selected field defense destination
		stonewall_defender_rifle/mortar/mg42/sniper
		bridge_defender_rifle/mortar/mg42/sniper
		rightgap_defender_rifle/mortar/mg42/sniper
		leftgap_defender_rifle/mortar/mg42/sniper
		flak88_defender_rifle/mortar/mg42/sniper
	

Depending on difficulty, some max number of enemy teams are allowed to deploy
MG teams only show up once (nearwindow, leftgap, rightgap)
Mortar teams only show up once (leftgap, rightgap)
Rifle teams (stonewall, rightgap, leftgap, flak88, bridge)
Snipers (farwindow, nearwindow, rightgap, leftgap, barnroof)

When all the members of an enemy team reaches their destinations, the killtimer starts, and a friendly is designated
When all the members of an enemy team reaches their destinations, Braeburn shouts spotting dialogue
Set accuracy on them to 0

When killtimer runs out, the designated friendly is killed by magic bullet and another friendly is designated
Killtimer starts anew, continue this process until the mission fails
Complete team destruction cancels the killtimer for that team
Stop the flak88_defender team when the flak88 is arrived at by the friendlies, but allow the other teams to operate

Kill the rest when randall calls up the player

********************/

field_enemy_selection()
{
	level endon ("randall near end");
	
	flag_wait("field attack started");
	
	//wait 3;
	
	//Tweak percent chances of spawning a given team here
	
	//!!Fader
	
	riflechance = 60;	//65
	sniperchance = 0;
	mg42chance = 40;	//25 is insane
	mortarchance = 0;
	
	/*
	riflechance = 0;
	sniperchance = 0;
	mg42chance = 100;
	mortarchance = 0;
	*/
	
	badtotal = undefined;
	
	if((riflechance + sniperchance + mg42chance + mortarchance) != 100)
	{
		assertEX(isdefined(badtotal), "field_enemy_deploy chances must add up to 100");
	}
	
	r = 100 - riflechance;
	s = r - sniperchance;
	g = s - mg42chance; 

	//Send out an enemy team
	
	while(1)
	{	
		if(level.fieldTeamSpawnAmount < level.fieldTeamSpawnLimit)
		{
			//select an enemy type based on selection percent values	
			
			enemyType = field_enemy_type(r, s, g);
			
			//select the destination for that type from the ones available
			
			enemyDest = field_enemy_dest(enemyType);
			
			//assemble deployment string
			
			enemyID = enemyDest + "_defender_" + enemyType;
			
			thread field_enemy_deploy(enemyID, enemyDest, enemyType);
			
			level.fieldTeamSpawnAmount++;
		}
		
		wait 0.05;
	}	
}

field_enemy_type(r, s, g)
{	
	level endon ("randall near end");
	
	msg = undefined;
	n = randomint(100);

	if(n >= r)
	{
		msg = "rifle";
	}
	if(n < r && n >= s)
	{
		msg = "sniper";
	}
	if(n < s && n >= g)
	{
		msg = "mg42";
	}
	if(n < g)
	{
		msg = "mortar";
	}
	
	return(msg);
}

field_enemy_dest(enemyType)
{
	//randomly select an unoccupied destination for that type
	//filter for type vs. locations available
	//tweakable percent chance of a particular location being chosen
	
	level endon ("randall near end");
	
	msg = undefined;
	if(enemyType == "rifle")
	{
		//stonewall, rightgap, leftgap, flak88, bridge
		
		//!!Fader
		
		rifle_wall_chance = 0;
		rifle_rightgap_chance = 40;
		rifle_leftgap_chance = 50;
		rifle_flak88_chance = 10;
		rifle_bridge_chance = 0;
		
		rifle_badtotal = undefined;
		
		if((rifle_wall_chance + rifle_rightgap_chance + rifle_leftgap_chance + rifle_flak88_chance + rifle_bridge_chance) != 100)
		{
			assertEX(isdefined(rifle_badtotal), "rifle dest chances must add up to 100");
		}
		
		r_wall = 100 - rifle_wall_chance;
		r_right = r_wall - rifle_rightgap_chance;
		r_left = r_right - rifle_leftgap_chance; 
		r_flak = r_left - rifle_flak88_chance;
		
		locationFound = 0;
		
		while(!locationFound)
		{
			n = randomint(100);
			
			if(n >= r_wall && !level.stonewallTaken)
			{
				msg = "stonewall";
				level.stonewallTaken = 1;
				break;
			}
			if(n < r_wall && n >= r_right && !level.rightgapTaken)
			{
				msg = "rightgap";
				level.rightgapTaken = 1;
				break;
			}
			if(n < r_right && n >= r_left && !level.leftgapTaken)
			{	
				msg = "leftgap";
				level.leftgapTaken = 1;
				break;
			}
			if(n < r_left && n >= r_flak && !level.flak88Taken)
			{
				msg = "flak88";
				level.flak88Taken = 1;
				break;
			}
			if(n < r_flak && !level.bridgeTaken)
			{
				msg = "bridge";
				level.bridgeTaken = 1;
				break;
			}
			
			wait 0.05;
		}
	}
	if(enemyType == "sniper")
	{
		//farwindow, nearwindow, rightgap, leftgap, barnroof
		
		//!!Fader
		
		sniper_farwindow_chance = 100;
		sniper_nearwindow_chance = 0;
		sniper_rightgap_chance = 0;
		sniper_leftgap_chance = 0;
		sniper_barnroof_chance = 0;
		
		sniper_badtotal = undefined;
		
		if((sniper_farwindow_chance + sniper_nearwindow_chance + sniper_rightgap_chance + sniper_leftgap_chance + sniper_barnroof_chance) != 100)
		{
			assertEX(isdefined(sniper_badtotal), "sniper dest chances must add up to 100");
		}
		
		s_far = 100 - sniper_farwindow_chance;
		s_near = s_far - sniper_nearwindow_chance;
		s_right = s_near - sniper_rightgap_chance; 
		s_left = s_right - sniper_leftgap_chance;
		
		locationFound = 0;
		
		while(!locationFound)
		{
			n = randomint(100);
			
			if(n >= s_far && !level.farwindowTaken)
			{
				msg = "farwindow";
				level.farwindowTaken = 1;
				break;
			}
			if(n < s_far && n >= s_near && !level.nearwindowTaken)
			{
				msg = "nearwindow";
				level.nearwindowTaken = 1;
				break;
			}
			if(n < s_near && n >= s_right && !level.rightgapTaken)
			{
				msg = "rightgap";
				level.rightgapTaken = 1;
				break;
			}
			if(n < s_right && n >= s_left && !level.leftgapTaken)
			{
				msg = "leftgap";
				level.leftgapTaken = 1;
				break;
			}
			if(n < s_left && !level.barnroofTaken)
			{
				msg = "barnroof";
				level.barnroofTaken = 1;
				break;
			}
			
			wait 0.05;
		}
	}
	if(enemyType == "mg42")
	{
		//nearwindow, leftgap, rightgap
		
		//!!Fader
		
		mg_nearwindow_chance = 33;
		mg_leftgap_chance = 33;
		mg_rightgap_chance = 34;
		
		mg_badtotal = undefined;
		
		if((mg_nearwindow_chance + mg_leftgap_chance + mg_rightgap_chance) != 100)
		{
			assertEX(isdefined(mg_badtotal), "mg dest chances must add up to 100");
		}
		
		mg_near = 100 - mg_nearwindow_chance;
		mg_left = mg_near - mg_leftgap_chance;
		
		locationFound = 0;
		
		while(!locationFound)
		{	
			n = randomint(100);
			
			if(n >= mg_near && !level.nearwindowTaken)
			{
				msg = "nearwindow";
				level.nearwindowTaken = 1;
				break;
			}
			if(n < mg_near && n >= mg_left && !level.leftgapTaken)
			{
				msg = "leftgap";
				level.leftgapTaken = 1;
				break;
			}
			if(n < mg_left && !level.rightgapTaken)
			{
				msg = "rightgap";
				level.rightgapTaken = 1;
				break;
			}
			
			wait 0.05;
		}
		
	}	
	if(enemyType == "mortar")
	{
		//leftgap, rightgap
		
		//!!Fader
		
		mortar_leftgap_chance = 50;
		mortar_rightgap_chance = 50;
		
		mortar_badtotal = undefined;
		
		if((mortar_leftgap_chance + mortar_rightgap_chance) != 100)
		{
			assertEX(isdefined(mortar_badtotal), "mortar dest chances must add up to 100");
		}
		
		mortar_left = 100 - mortar_leftgap_chance;
		
		locationFound = 0;
		
		while(!locationFound)
		{
			n = randomint(100);
			
			if(n >= mortar_left && !level.leftgapTaken)
			{
				msg = "leftgap";
				level.leftgapTaken = 1;
				break;
			}
			if(n < mortar_left && !level.rightgapTaken)
			{
				msg = "rightgap";
				level.rightgapTaken = 1;
				break;
			}
			
			wait 0.05;
		}
	}
	
	return(msg);
}

field_enemy_deploy(enemyID, enemyDest, enemyType)
{
	ent = spawnstruct();
	ent.count = 0;
	
	altent = spawnstruct();
	altent.count = 0;
	
	level endon ("randall near end");
	
	//spawn the team and begin monitoring arrival and death
	
	aSpawners = [];
	aSpawners = getentarray(enemyID, "targetname");
	for(i=0; i<aSpawners.size; i++)
	{
		aSpawners[i].count++;
		nSoldier = aSpawners[i] doSpawn();
		if(spawn_failed(nSoldier))
		{
			continue;
		}
		
		nSoldier.goalradius = 256;
		nSoldier.suppressionwait = 0;
		nSoldier.pathenemyfightdist = 1000;
		nSoldier.pathenemylookahead = 256;
		nSoldier.maxdist = 1280;
		nSoldier.baseAccuracy = 1;
		nSoldier.health = 1;
		
		nSoldier thread field_enemy_death(ent);
		nSoldier thread field_enemy_arrival(altent, enemyDest, enemyType);
		nSoldier thread field_advance_baglimit_deathmonitor();
		nSoldier thread enemy_deathmonitor();
	}
	
	wait 0.05;
	
	thread field_enemy_teamdeath(ent, enemyDest);
	thread field_enemy_teamarrival(ent, altent, enemyType, aSpawners);
}

field_enemy_death(ent)
{
	ent.count++;
	self waittill ("death");
	ent.count--;
	ent notify ("killed");
}

field_enemy_arrival(altent, enemyDest, enemyType)
{
	altent.count++;
	self endon ("death");
	self waittill ("goal");
	altent.count--;
	altent notify ("arrived");
	thread field_braeburn_spot(enemyDest, enemyType);
}

field_braeburn_spot(enemyDest, enemyType)
{
	//stonewall, rightgap, leftgap, flak88, bridge, farwindow, nearwindow, barnroof
	//rifle, mg42, mortar, sniper

	level endon ("randall near end");

	//each thread instance waits its turn to deliver dialogue and times out eventually
	
	delayTime = 3;	//seconds
	timer = 0;
	timeLimit = 5;	
	
	while(1)
	{
		if(timer >= timeLimit)
		{
			break;
		}
		
		if(level.enemyTypeOld != enemyType || level.enemyDestOld != enemyDest)
		{
			if(!level.braeburnSpeech && !level.randalltalking && !level.bermbanter)
			{
				level.enemyTypeOld = enemyType;
				level.enemyDestOld = enemyDest;
				level.braeburnSpeech = 1;
				
				if(enemyType == "sniper")
				{	
					if(enemyDest == "farwindow")
					{
						level.braeburn Dialogue_Thread("silotown_braeburn_sniperfarwindow");
					}
					if(enemyDest == "nearwindow")
					{
						level.braeburn Dialogue_Thread("silotown_braeburn_snipernearwindow");
					}
					if(enemyDest == "rightgap")
					{
						level.braeburn Dialogue_Thread("silotown_braeburn_snipergapbldg");
					}
					if(enemyDest == "leftgap")
					{
						level.braeburn Dialogue_Thread("silotown_braeburn_snipergapleft");
					}
					if(enemyDest == "barnroof")
					{
						level.braeburn Dialogue_Thread("silotown_braeburn_sniperbarn");
					}
				}
				
				if(enemyType == "mg42")
				{
					if(enemyDest == "flak88")
					{
						//DIALOGUE: "MG42 to the right of the flak gun! Take it out!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mgbyflakgun");
					}
					if(enemyDest == "nearwindow")
					{
						//DIALOGUE: "MG42 in the window!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mg42window");
					}
					if(enemyDest == "leftgap")
					{
						//DIALOGUE: "MG42! Hedgerow gap on the left!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mg42gapleft");
					}
					if(enemyDest == "rightgap")
					{
						//DIALOGUE: "MG42 in the hedgerow gap by the house!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mg42gapbyhouse");
					}
				}
				
				if(enemyType == "rifle")
				{
					if(enemyDest == "bridge")
					{
						//DIALOGUE: "Kraut squad on the bridge at 2 o'clock!"
						level.braeburn Dialogue_Thread("silotown_braeburn_squadbridge");
					}
					if(enemyDest == "stonewall")
					{
						//DIALOGUE: "Enemy squad by the wall on the far right!"
						level.braeburn Dialogue_Thread("silotown_braeburn_squadwall");
					}
					if(enemyDest == "rightgap")
					{
						//DIALOGUE: "Kraut squad in the hedgerow gap by the house!"
						level.braeburn Dialogue_Thread("silotown_braeburn_squadgaphouse");
					}
					if(enemyDest == "leftgap")
					{
						//DIALOGUE: "Enemy reinforcements, 11 o'clock!"
						level.braeburn Dialogue_Thread("silotown_braeburn_enemy11oclock");
					}
					if(enemyDest == "flak88")
					{
						//DIALOGUE: "Enemy infanty heading for the flak gun!"
						level.braeburn Dialogue_Thread("silotown_braeburn_headingflakgun");
					}	
				}
				
				if(enemyType == "mortar")
				{
					if(enemyDest == "leftgap")
					{
						//DIALOGUE: "Mortar team! Coming through the gap in the hedgerow, 11 o'clock!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mortargaphedge");
					}
					if(enemyDest == "rightgap")
					{
						//DIALOGUE: "Mortar team by the house!"
						level.braeburn Dialogue_Thread("silotown_braeburn_mortarbyhouse");
					}
				}
				
				level.braeburnSpeech = 0;
				wait delayTime;
				break;
			}
		}
		else
		{
			break;
		}
		
		wait 1;
		timer++;
	}
}

field_enemy_teamdeath(ent, enemyDest)
{	
	while(1)
	{
		if(ent.count == 0)
		{
			break;
		}
		ent waittill ("killed");
	}
		
	//level notify ("field team destroyed");????	//shuts down team arrival monitor
	ent notify ("field team destroyed");
	level.fieldTeamSpawnAmount--;		//frees up a team spawn slot
	
	//free up a team destination
	
	if(enemyDest == "nearwindow")
	{
		level.nearwindowTaken = 0;
	}
	if(enemyDest == "leftgap")
	{
		level.leftgapTaken = 0;
	}
	if(enemyDest == "rightgap")
	{
		level.rightgapTaken = 0;
	}
	if(enemyDest == "stonewall")
	{
		level.stonewallTaken = 0;
	}
	if(enemyDest == "flak88")
	{
		level.flak88Taken = 0;
	}
	if(enemyDest == "barnroof")
	{
		level.barnroofTaken = 0;
	}
	if(enemyDest == "bridge")
	{
		level.bridgeTaken = 0;
	}
	if(enemyDest == "farwindow")
	{
		level.farwindowTaken = 0;
	}
}

field_enemy_teamarrival(ent, altent, enemyType, aSpawners)
{
	ent endon ("field team destroyed");
	level endon ("field secured");
	
	while(1)
	{
		if(altent.count == 0)
		{
			break;
		}
		altent waittill ("arrived");
	}
	
	//pick an Allied flanker who is not a Hero or is not trying to commandeer the flak gun
	//repeat until this enemy team is dead or mission is failed
	
	while(1)
	{
		aSheep = [];
		aAllies = [];
		aAllies = getaiarray("allies");
		for(i=0; i<aAllies.size; i++)
		{
			if(!isdefined(aAllies[i].script_friendname))
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
			if((aAllies[i].script_friendname == "Pvt. Garcia") && !level.garciaPlanting)
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
			if((aAllies[i].script_friendname == "Pvt. Hawkins") && !level.hawkinsPlanting)
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
			if((aAllies[i].script_friendname == "Pvt. Jones") && !level.jonesPlanting)
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
			if((aAllies[i].script_friendname == "Pvt. Rosetti") && !level.rosettiPlanting)
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
			if((aAllies[i].script_friendname == "Pvt. Lentz") && !level.lentzPlanting)
			{
				aSheep[aSheep.size] = aAllies[i];
				continue;
			}
		}
		
		aAllies = undefined;
		
		if(!aSheep.size)
		{
			return;
		}
	
		eGuy = aSheep[randomint(aSheep.size)];
		
		//everyone on the team targets this friendly
		
		for(i=0; i<aSpawners.size; i++)
		{
			if(!isdefined(aSpawners[i]))
				continue;
			
			aSpawners[i].favoriteenemy = eGuy;
		}
		
		wait 0.05;
	}
}

field_enemy_defeat()
{
	//enemies who are close enough to a retreat point run to it before fighting again
	//enemies who are too far away from their retreat points die at random times by cardiac arrest
	
	//escapenode_groundlevel
	//escapenode_barnroof
	//escapenode_farwindow
	//escapenode_river
	
	level waittill ("randall near end");
	
	//There can be only one of each escape node
	
	ground = 0;
	barnroof = 0;
	farwindow = 0;
	river = 0;
	
	escapeGround = undefined;
	escapeBarnroof = undefined;
	escapeFarwindow = undefined;
	escapeRiver = undefined;
	
	//Match escape points to enemies
	
	aNodes = getnodearray("enemy_field_retreat", "targetname");
	for(i=0; i<aNodes.size; i++)
	{
		if(isdefined(aNodes[i].script_noteworthy) && aNodes[i].script_noteworthy == "escapenode_groundlevel" && !ground)
		{
			escapeGround = aNodes[i];
			ground = 1;
		}
		if(isdefined(aNodes[i].script_noteworthy) && aNodes[i].script_noteworthy == "escapenode_barnroof" && !barnroof)
		{
			escapeBarnroof = aNodes[i];
			barnroof = 1;
		}
		if(isdefined(aNodes[i].script_noteworthy) && aNodes[i].script_noteworthy == "escapenode_farwindow" && !farwindow)
		{
			escapeFarwindow = aNodes[i];
			farwindow = 1;
		}
		if(isdefined(aNodes[i].script_noteworthy) && aNodes[i].script_noteworthy == "escapenode_river" && !river)
		{
			escapeRiver = aNodes[i];
			river = 1;
		}
	}
	
	//Send enemies to correct escape point
	
	aAxis = getaiarray("axis");
	for(i=0; i<aAxis.size; i++)
	{
		if(isdefined(aAxis[i].script_noteworthy) && aAxis[i].script_noteworthy == "escapenode_groundlevel")
		{
			aAxis[i] thread field_enemy_defeatcheck(escapeGround);
		}
		if(isdefined(aAxis[i].script_noteworthy) && aAxis[i].script_noteworthy == "escapenode_barnroof")
		{
			aAxis[i] thread field_enemy_defeatcheck(escapeBarnroof);
		}
		if(isdefined(aAxis[i].script_noteworthy) && aAxis[i].script_noteworthy == "escapenode_farwindow")
		{
			aAxis[i] thread field_enemy_defeatcheck(escapeFarwindow);
		}
		if(isdefined(aAxis[i].script_noteworthy) && aAxis[i].script_noteworthy == "escapenode_river")
		{
			aAxis[i] thread field_enemy_defeatcheck(escapeRiver);
		}
	}
}

field_enemy_defeatcheck(node)
{
	//Enemies during field battle fall back if the player is not too close to them
	
	self endon ("death");
	
	dist = length(self.origin - node.origin);
	playerdist = length(self.origin - level.player.origin);
	if(dist < playerdist && dist > 384)
	{
		self setgoalnode(node);
		self waittill ("goal");
	}
}

//***************************************************

squad_assault(strSquadName, iAxisAcc)
{	
	level endon ("retreat");
	
	//Create blank arrays
	
	aSpawner = [];		//sort for roster	
	aSortCheckpointA = [];	//sort from route nodes
	
	aSquadRoster = [];	//soldiers in the specified squad
	aCheckpointA = [];	//all squad route nodes
	aCheckpointB = [];	//all contact nodes
	aCheckpointC = [];	//all entry nodes
	aSquadCapture = [];	//all capture nodes
	
	if(!isdefined(strSquadName))
	{
		thread maps\_utility::error("You need to specify a squadname string.");
	}
	if(!isdefined(iAxisAcc))
	{
		iAxisAcc = 0.06;		//accuracy of spawned axis troops
	}
	
	//***** Create roster (array) for specified squad
	
	aSpawner = getspawnerarray();	
	aSpawnTeam = [];
	
	for(i=0; i<aSpawner.size; i++)
	{
		if(!isdefined (aSpawner[i].script_squadname))
			continue;
		if(aSpawner[i].script_squadname != strSquadName)
			continue; 
		aSpawnTeam[aSpawnTeam.size] = aSpawner[i];
	}
	
	if(level.spawnLock)
	{
		return;
	}
	else
	{
		//Check and don't spawn troops over the max number of enemies (before victory) or friendlies (at victory) allowed in the level
		//Spawn full teams of enemies, not a random trickle of enemies
		
		aArmyRoster = getaiarray("axis");
		nBodyCount = aArmyRoster.size;
		aArmyRoster = undefined;
		
		if(nBodyCount <= level.iRosterMax - aSpawnTeam.size)	
		{	
			level.spawnLock = 1;
			
			for(i=0; i<aSpawnTeam.size; i++)
			{	
				if(level.victory == 1)
				{
					aFriendRoster = getaiarray("allies");
					nBodyCount = aFriendRoster.size + nBodyCount;
				}
				
				println("Spawning Group ", strSquadName, " Soldier ", i);
				aSpawnTeam[i].count = 1; 	//reset spawn limit, never run out
				nSoldier = aSpawnTeam[i] doSpawn();	
				if(spawn_failed(nSoldier))
				{
					continue;
				}
				
				nSoldier.pathenemyfightdist = 580;
				nSoldier.pathenemylookahead = 320;
				nSoldier.maxdist = 800;
				aSquadRoster[aSquadRoster.size] = nSoldier;
			}
			
			level.spawnLock = 0;
		}
		else
		{
			return;
		}
	}
	
	aSquadRoster = cleanUp(aSquadRoster);
	
	aSpawner = undefined;
	aSpawnTeam = undefined;	
	
	//***** Get the checkpoints to be chosen from
	
	//CheckpointA
	
	aSortCheckpointA = getnodearray("checkpointA","targetname");
	for(i=0; i<aSortCheckpointA.size; i++)
	{
		if(isdefined (aSortCheckpointA[i].script_squadname) && (aSortCheckpointA[i].script_squadname == strSquadName))
		{
			aCheckpointA[aCheckpointA.size] = aSortCheckpointA[i];
		}
	}
	
	assertEX((aSortCheckpointA.size > 0), strSquadName + " does not have a Checkpoint A node");
	aSortCheckpointA = undefined;
	
	//CheckpointB
	
	aSortCheckpointB = getnodearray("checkpointB","targetname");
	for(i=0; i<aSortCheckpointB.size; i++)
	{
		if(isdefined (aSortCheckpointB[i].script_squadname) && (aSortCheckpointB[i].script_squadname == strSquadName))
		{
			aCheckpointB[aCheckpointB.size] = aSortCheckpointB[i];
		}
	}
	
	assertEX((aSortCheckpointB.size > 0), strSquadName + " does not have a Checkpoint B node");
	aSortCheckpointB = undefined;
	
	//CheckpointC
	
	aSortCheckpointC = getnodearray("checkpointC","targetname");
	for(i=0; i<aSortCheckpointC.size; i++)
	{
		if(isdefined (aSortCheckpointC[i].script_squadname) && (aSortCheckpointC[i].script_squadname == strSquadName))
		{
			aCheckpointC[aCheckpointC.size] = aSortCheckpointC[i];
		}
	}
	
	assertEX((aSortCheckpointC.size > 0), strSquadName + " does not have a Checkpoint C node");
	aSortCheckpointC = undefined;
	
	//***** Get capture node, only one unique capture point per squad
	
	aSquadCapture = getnodearray("capturepoint","targetname");
	nSquadCaptureNode = undefined;
	for(i=0; i<aSquadCapture.size; i++)
	{
		if(isdefined (aSquadCapture[i].script_squadname) && (aSquadCapture[i].script_squadname == strSquadName))
		{
			nSquadCaptureNode = aSquadCapture[i];
		}
	}
	
	assertEX((aSquadCapture.size > 0), strSquadName + " does not have a capture node");
	aSquadCapture = undefined;
	
	//***** Deploy squad on assault mission with roster, routes, and nodes
	
	thread squad_deploy(aSquadRoster, aCheckpointA, aCheckpointB, aCheckpointC, nSquadCaptureNode);
}

squad_deploy(aSoldiers, aCheckpointA, aCheckpointB, aCheckpointC, nCaptureNode)
{	
	level endon ("retreat");
	
	//++++Navigation system. Send squads to checkpoints using shrinking goalradius method, attacking the town
	
	//Check for valid nav data
	
	if(aCheckpointA.size <= 0)
		return;
	if(aCheckpointB.size <= 0)
		return;
	if(aCheckpointC.size <= 0)
		return;
	if(!isdefined(nCaptureNode))
		return;
		
	for(i=0; i<aSoldiers.size; i++)
	{
		aSoldiers[i] thread squad_navigation(aCheckpointA, aCheckpointB, aCheckpointC, nCaptureNode);
	}
}

squad_navigation(aCheckpointA, aCheckpointB, aCheckpointC, nCaptureNode)
{
	level endon ("retreat");
	self endon ("death");
	
	transtimeAB = 6;
	transtimeBC = 8;
	transtimeCD = 20;
	
	a = aCheckpointA[randomint(aCheckpointA.size)];
		stepA = 2;
		closuretimeA = 5;	//10
		startradiusA = 800;
		rateA = 0.6;
	b = aCheckpointB[randomint(aCheckpointB.size)];
		stepB = 3;
		closuretimeB = 3;	//15
		startradiusB = 1000;
		rateB = 0.8;
	c = aCheckpointC[randomint(aCheckpointC.size)];
		stepC = 2;		//4
		closuretimeC = 2;	//20
		startradiusC = 1200;
		rateC = 0.75;
	d = nCaptureNode;
		stepD = 3;		//12
		closuretimeD = 8;	//8
		startradiusD = 1200;
		rateD = 0.9;
	
	self.goalradius = startradiusA;
	self setgoalnode(a);
	
	self squad_encroach(stepA, closuretimeA, startradiusA, rateA, a);
	wait transtimeAB;
	
	self squad_encroach(stepB, closuretimeB, startradiusB, rateB, b);
	wait transtimeBC;
	
	self squad_encroach(stepC, closuretimeC, startradiusC, rateC, c);
	wait transtimeCD;
	
	self squad_encroach(stepD, closuretimeD, startradiusD, rateD, d);
	
	//self setgoalentity(level.player);
	//self.goalradius = 96;
}

squad_encroach(step, time, startradius, rate, goalnode)
{
	level endon ("retreat");
	self endon ("death");
	
	if(isdefined(goalnode))
		self setgoalnode(goalnode);
	
	if(isdefined(startradius))
		self.goalradius = startradius;
		
	for(i=0; i<step; i++)
	{
		self waittill ("goal");
		wait time;
		self.goalradius = startradius * rate;
	}
}

cleanUp(ai)
{
	newai = [];
	for (i=0;i<ai.size;i++)
	{
		if (!isalive(ai[i]))
			continue;
		newai[newai.size] = ai[i];
	}
	return newai;
}
	

//**********************************************//

/*
PORTABLE MG42 DEPLOY MOMENTS
1. Targetname = portablemg_moment on trigger_once
2. Targetname = portablemg_moment_cancel on trigger_once
3. Position triggers so that cancellations occur sensibly.
4. Script_noteworthy = custom name of the moment for sorting and cancelling
*/

portable_mg42_moment_setup()
{
	aPortmg = [];
	aTriggers = getentarray("flood_spawner", "targetname");
	for(i=0; i<aTriggers.size; i++)
	{
		if(!isdefined(aTriggers[i].script_namenumber))
			continue;
		if(aTriggers[i].script_namenumber == "portablemg_moment")
			aPortmg[aPortmg.size] = aTriggers[i];
	}
	
	aPortmgCancel = getentarray("portablemg_moment_cancel", "targetname");
	
	assertEX(aPortmgCancel.size == aPortmg.size, "Portable MG42 moment triggers must equal number of cancellation triggers.");
	
	if(aPortmg.size <= 0)
		return;
	
	for (i=0; i<aPortmg.size; i++)
	{
		ent = spawnstruct();
		assertEX(isdefined(aPortmg[i].script_commonname), "Portable MG42 moment trigger must have a script_commonname.");
		assertEX(isdefined(aPortmgCancel[i].script_commonname), "Portable MG42 moment cancel trigger must have a script_commonname.");
		aPortmg[i] thread portable_mg42_moment(ent);
		aPortmgCancel[i] thread portable_mg42_moment_cancel(aPortmg, ent);
	}
}

portable_mg42_moment(ent)
{
	//stops the cancellation trigger from sending its endon
	
	ent endon ("portable mg42 moment master off");
	ent endon ("portable mg42 moment canceled");
	self thread portable_mg42_moment_master_cancel(ent);
	self waittill ("trigger");
	ent notify ("portable mg42 moment activated");
}

portable_mg42_moment_cancel(aPortmg, ent)
{
	//deletes the portable mg42 moment trigger, stops moment trigger from sending its endon
	
	ent endon ("portable mg42 moment master off");
	ent endon ("portable mg42 moment activated");

	self waittill ("trigger");
	ent notify ("portable mg42 moment canceled");
	for (i=0; i<aPortmg.size; i++)
	{
		if(!isdefined(aPortmg[i]))
			continue;
		if(!isdefined(aPortmg[i].script_commonname))
			continue;
		if(aPortmg[i].script_commonname == self.script_commonname)
			aPortmg[i] delete();
	}
}

portable_mg42_moment_master_cancel(ent)
{
	//removes a specific portable_mg42 moment trigger on demand, but otherwise ignored if triggers are normally activated
	
	ent endon ("portable mg42 moment canceled");
	ent endon ("portable mg42 moment activated");
	level waittill (self.script_commonname + "_cancel");
	ent notify ("portable mg42 moment master off");
	self delete();
}

portable_mg42_moment_hqsandbags_cancel()
{
	flag_wait("Hardpoint Complete " + "westbldg");
	level notify ("hq_sandbags_cancel");
}

portable_mg42_moment_officewall_cancel()
{
	flag_wait("Hardpoint Complete " + "northbldg");
	level notify ("officewall_cancel");
}

portable_mg42_moment_barnbags_cancel()
{
	flag_wait("Hardpoint Complete " + "barn");
	level notify ("barnbags_cancel");
}

portable_mg42_moment_officebags_cancel()
{
	flag_wait("Hardpoint Complete " + "forkbldg");
	level notify ("officebags_cancel");
}

portable_mg42_moment_signwall_cancel()
{
	flag_wait("Hardpoint Complete " + "bigwallbldg");
	level notify ("signwall_cancel");
}

//**********************************************//

/*
FRIENDLYAREA SYSTEM
	Friendlies using this system will migrate gradually between friendlyAreas activated by changes in the player's position.
	Response time to friendlyArea changeovers can be set for some or all of the friendlies, as well as basic debounce.
	In linear levels they can be made to act like normal friendlychains by changing the ai settings.
	
	a. trigger_multiple (script_noteworthy = unique name of area, targetname = "friendlyArea", targets nodes and core node))
	b. pathnodes/covernodes for the trigger_multiple to target
	c. one core pathnode with script_noteworthy of the trigger_multiple also targeted by the trigger_multiple, with huge radius
	d. one info_volume with script_noteworthy of the trigger_multiple & targetname = "friendlyVolume"
*/

friendlyTownStats()
{
	//Makes everyone mortal after the field is secured, except for main characters or silo blasters
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Sgt. Randall")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. Braeburn")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. McCloskey")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. Peas")
			continue;
		if(isdefined(aAllies[i].flakattack) && aAllies[i].flakattack)
			continue;
			
		aAllies[i].health = 250;
		aAllies[i] notify ("stop magic bullet shield");
		aAllies[i].anim_disablePain = false;
		flag_set("resetFriendlyTownStats");
	}
}

friendlyAreaSeed()
{
	//Makes initial group of survivors wait on death to respawn replacements if player hasn't reached a friendly trigger
	
	level notify ("new orders");

	seedVolume = undefined;	
	aFriendlyVolumes = getentarray("friendlyArea", "targetname");
	for(i=0; i<aFriendlyVolumes.size; i++)
	{
		if(!isdefined(aFriendlyVolumes[i].script_noteworthy))
			continue;
		
		if(aFriendlyVolumes[i].script_noteworthy == "entrystartingarea")
		{
			seedVolume = aFriendlyVolumes[i];
			break;
		}
	}
	
	assertEX(isdefined(seedVolume), "Couldn't find friendlyVolume with noteworthy = entrystartingarea");
	
	aNavData = seedVolume friendlyAreaNavData();
	
	coreNode = aNavData[1];	
	aAreaNodes = aNavData[2];
	
	wait 0.1;
	
	thread friendlyAreaReplenish(seedVolume, coreNode, aAreaNodes);
}

friendlyAreaStart()
{
	level endon ("town captured");
	
	level.baseDelayTime = 0.5;	//1;
	level.moveGapTime = 0.8;	//2 + randomfloat(3);
	level.instantFollowLimit = 0;		//number of guys that should respond instantly to friendlyArea changes	
	level.friendlyAreaCooldown = 20;	//time in seconds for a friendlyAreaTrigger to become active again
	//level.lastFriendlyArea = undefined; 	

	thread friendlyAreaCollect();
}

friendlyAreaCollect()
{
	level endon ("town captured");
	
	aAreas = getentarray("friendlyArea", "targetname");
	for(i=0; i<aAreas.size; i++)
	{
		aAreas[i] thread friendlyAreaSetup();
	}
}

friendlyAreaSetup()
{
	level endon ("town captured");
	
	while(1)
	{
		self waittill ("trigger");
		
		//Anti-consecutive-repeat lock, no friendlyArea trigger needs to activate twice in a row
		
		currentFriendlyArea = self.script_noteworthy;
		if(isdefined(level.lastFriendlyArea) && currentFriendlyArea == level.lastFriendlyArea)
		{
			wait 0.05;
			continue;
		}
		level.lastFriendlyArea = currentFriendlyArea;
		
		level notify ("new orders");
		
		aNavData = self friendlyAreaNavData();
		
		friendlyVolume = aNavData[0];
		coreNode = aNavData[1];	
		aAreaNodes = aNavData[2];
		
		thread friendlyAreaReplenish(friendlyVolume, coreNode, aAreaNodes);
	}
}

friendlyAreaReplenish(friendlyVolume, coreNode, aAreaNodes)
{
	level endon ("town captured");
	level endon ("new orders");
	
	aNormalGuys = [];
	aAllies = getaiarray("allies");
	
	//assertEX(aAreaNodes.size >= aAllies.size, "A friendlyArea trigger must target at least as many nodes as there are allies.");
	
	moveDelay = level.baseDelayTime;	//time between guys deploying to their respective nodes, staggered leapfrog style
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Sgt. Randall")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. Braeburn")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. McCloskey")
			continue;
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. Peas")
			continue;
		
		aNormalGuys[aNormalGuys.size] = aAllies[i];
	}
	
	for(i=0; i<aNormalGuys.size; i++)
	{
		aNormalGuys[i] thread friendlyAreaNav(aAreaNodes[i], moveDelay, friendlyVolume, coreNode);
		aNormalGuys[i] thread friendlyAreaDeath(aAreaNodes[i], moveDelay, friendlyVolume, coreNode);
		
		if(i>level.instantFollowLimit - 1)
		{
			//level.instantFollowLimit number of friendlies will respond instantly instead of waiting in line to move
			moveDelay = moveDelay + level.moveGapTime;
		}
	}
	
	if(aNormalGuys.size <= level.friendlyPopLimit && !level.firstrun)
	{
		level.firstrun = true;
		n = level.friendlyPopLimit - aNormalGuys.size;
		for(i=0; i<n; i++)
		{
			thread playerBuddies(aAreaNodes[i], moveDelay, friendlyVolume, coreNode);
		}
	}
	
	//wait level.friendlyAreaCooldown;
}

friendlyAreaNavData()
{
	level endon ("town captured");
	
	//Get the friendlyVolume that matches this friendlyArea
		
	friendlyVolume = undefined;
	aFriendlyVolumes = getentarray("friendlyVolume", "targetname");
	assertEX(aFriendlyVolumes.size > 0, "No friendlyVolumes were found. There should be one per friendlyArea trigger.");
	
	for(i=0; i<aFriendlyVolumes.size; i++)
	{
		if(!isdefined(aFriendlyVolumes[i].script_noteworthy))
			continue;
		if(aFriendlyVolumes[i].script_noteworthy == self.script_noteworthy)
		{
			friendlyVolume = aFriendlyVolumes[i];
			break;
		}
	}
	
	//Collect the custom placed nodes targeted by the friendlyArea trigger_multiple, which friendlies get sent to randomly
	//Get the coreNode that matches this friendlyArea and filter it out from the array of normal nodes
	
	aAreaNodes = [];
	coreNode = undefined;
	aNodes = getnodearray(self.target, "targetname");
	for(i=0; i<aNodes.size; i++)
	{	
		if(isdefined(aNodes[i].script_noteworthy) && aNodes[i].script_noteworthy == self.script_noteworthy)
		{
			coreNode = aNodes[i];
			continue;
		}
		
		aAreaNodes[aAreaNodes.size] = aNodes[i];
	}
	
	assertEX(isdefined(coreNode), "Each friendlyArea package must include a script_noteworthy = coreNode targeted by the friendlyArea trigger.");
	
	aNavData = [];
	
	aNavData[0] = friendlyVolume;
	aNavData[1] = coreNode;
	aNavData[2] = aAreaNodes;
	
	return(aNavData);
}

friendlyAreaNav(node, moveDelay, friendlyVolume, coreNode)
{
	self endon ("death");
	level endon ("new orders");
	level endon ("town captured");
	//Forcemove to a tight destination within friendlyArea
	if(isdefined(moveDelay))
	{
		wait moveDelay;
	}
	
	//Navigation orders package
	self.goalradius = 64;
	self.pathenemyfightdist = 128;
	self.pathenemylookahead = 128;
	
	//Send friendly to a node targeted by the friendlyArea most recently visited by the player
	
	lastTrig = undefined;
	
	if(!isdefined(node))
	{
		aTrigs = getentarray("friendlyArea", "targetname");
		for(i=0; i<aTrigs.size; i++)
		{
			if(!isdefined(aTrigs[i].script_noteworthy))
				continue;
			
			if(aTrigs[i].script_noteworthy == level.lastFriendlyArea)
			{
				lastTrig = aTrigs[i];
				break;
			}
		}
		
		aNavData = lastTrig friendlyAreaNavData();
		aAreaNodes = aNavData[2];
		
		node = aAreaNodes[randomint(aAreaNodes.size)];
	}
	
	self setgoalnode(node);
	self waittill ("goal");
	
	self.goalradius = 128;
	
	/*
	if(isdefined(friendlyVolume))
		self setgoalvolume(friendlyVolume);
	*/
	
	/*
	
	//Free up movement for combat, but keep them inside a well defined volume

	if(isdefined(coreNode))
	{
		self setgoalnode(coreNode);
		self.goalradius = coreNode.radius;
	}
	*/
}

friendlyAreaDeath(node, moveDelay, friendlyVolume, coreNode)
{
	level endon ("town captured");
	level endon ("new orders");
	self waittill ("death");
	//wait 0.05;
	thread playerBuddies(node, moveDelay, friendlyVolume, coreNode);
}

//**********************************************//

/*

constant attacks, bringing the action to the player

1. Enemies constantly attack and harrass the player to avoid lulls of boredom and silence, making the level a struggle
2. They are spawned as squads of X guys from inside hardpoints, get a waypoint, and fight to it, then switch to the player
		- waypoints are any place that makes them run from their spawn point in an interesting way
			OR
		- waypoints are assigned randomly to individuals, no squad clumps
		- the waypoints are randomly selected at spawntime, so that a geometric attack approach never results in predictable behavior
		- their interval is set to 0
		- enemies get a large goalradius and attack their .favoriteenemy which is level.player, and goalentity to him after some time		
		- assumes that the flood_and_secure system keeps the hardpoints full; these constantattack guys are for in between
 		- when the player gets very close to a hardpoint, 
 			- they stop spawning until the player gets far enough away
 			OR
 			- they keep spawning but do not use the waypoint, instead going straight for the player due to the proximity
 		- when the hardpoint is captured, they will never resume spawning

Recipe:

- manual spawners on a while(1) loop activated by script events, spawners with hardpoint label
- reference point inside a hardpoint, and length checks to the player every second to monitor proximity to hardpoint
	- skip spawn phase condition in the loop depending on length check dist
- random waypoint node selection, waypoint nodes with hardpoint label
- collect waypoints & spawners into arrays
- at least one waypoint per spawner
- these enemies don't enter buildings (could be seen as confusing the objective to secure a building)
- the farthest uncaptured objective one (or other distance condition, maybe closest) is the active constantattack spawner

*/

constantAttack()
{
	if (getcvar("skipto") == "" || getcvar("skipto") == "field")
	{
		level waittill ("field secured");
	}
	
	wait 1;	//wait for flags to set
	
	while(1)
	{
		//find squad that meets the distance requirement (farthest away)
		
		currentDistRef = undefined;
		olddist = 0;
		newdist = 0;
		aDistrefs = getentarray("distrefpoint", "targetname");
		if(aDistrefs.size == 0)
			break;
		for(i=0; i<aDistrefs.size; i++)
		{
			assertEX(isdefined(aDistrefs[i].script_noteworthy), "distref for constantAttack thread must have a script_noteworthy");
			
			if(aDistrefs[i].script_noteworthy == "farmbldg" && level.flag["Hardpoint Complete bigwallbldg"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			if(aDistrefs[i].script_noteworthy == "barnbldg" && level.flag["Hardpoint Complete barn"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			if(aDistrefs[i].script_noteworthy == "officebldg" && level.flag["Hardpoint Complete northbldg"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			if(aDistrefs[i].script_noteworthy == "forkbldg" && level.flag["Hardpoint Complete forkbldg"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			if(aDistrefs[i].script_noteworthy == "signbldg" && level.flag["Hardpoint Complete signbldg"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			if(aDistrefs[i].script_noteworthy == "hqbldg" && level.flag["Hardpoint Complete westbldg"] == true)
			{
				aDistrefs[i] delete();
				continue;
			}
			
			newdist = length(level.player.origin - aDistrefs[i].origin);
			if(newdist < olddist)
				continue;
			olddist = newdist;
			currentDistRef = aDistrefs[i];
		}
		
		//abort spawn if only one hardpoint remains & the player is too close (change this to a trigger/volume detection)
		
		if(level.buildingscleared == 5 && newdist < 1600)
		{
			wait 0.5;
			continue;
		}
		
		if(level.buildingscleared == 6)
		{
			break;
		}
		
		//abort spawn if the corresponding hardpoint is already captured, delete distref so it is no longer considered
		
		if(!isdefined(currentDistRef))
		{
			wait 0.05;
			continue;
		}
	
		//choose a random waypoint
		
		aWaypoints = getnodearray(currentDistRef.target, "targetname");
		x = aWaypoints.size - 1;
		if(x == 0)
		{
			num = 0;
		}
		else
		{
			num = randomint(x);
		}
		
		waypoint = aWaypoints[num];
		
		//deploy the constantAttackers
		
		aSquadSpawners = [];
		aSpawners = getentarray("constantattack_spawner", "targetname");
		for(i=0; i<aSpawners.size; i++)
		{
			assertEX(isdefined(aSpawners[i].script_noteworthy), "constantattack_spawner without a script_noteworthy");
			if(aSpawners[i].script_noteworthy == currentDistRef.script_noteworthy)
				aSquadSpawners[aSquadSpawners.size] = aSpawners[i];
			wait 0.05;
		}
		
		ent = spawnstruct();
		ent.count = 0;
		
		for(i=0; i<aSquadSpawners.size; i++)
		{
			nSoldier = aSquadSpawners[i] doSpawn();
			if(spawn_failed(nSoldier))
			{
				continue;
			}
			aSquadSpawners[i].count = 1;
			ent.count++;
			nSoldier.script_noteworthy = aSquadSpawners[i].script_noteworthy;
			nSoldier thread constantAttackDeath(ent);
			nSoldier thread constantAttackNav(waypoint, ent);
			nSoldier thread enemy_deathmonitor();
		}
		
		//Wait for this set of attackers to die before sending a new one
		
		while(ent.count > 0)
		{
			ent waittill ("constant attacker died");
		}
		
		wait 0.05;
	}
}

constantAttackDeath(ent)
{
	self waittill ("death");
	ent.count--;
	ent notify ("constant attacker died");
}

constantAttackNav(waypoint, ent)
{
	//combat navigation properties and goal changing for attacker
	
	self endon ("death");
	
	if (getcvar ("constantAttackDiag") == "on")
	{
		self thread constantAttackNavDiag();
	}
	
	self.pathenemyfightdist = 300;
	self.pathenemylookahead = 384;
	
	if(isdefined(waypoint.radius))
	{
		self.goalradius = waypoint.radius;
	}
	else
	{
		self.goalradius = 500;
	}
	
	self setgoalnode(waypoint);
	self waittill ("goal");
	wait randomintrange(6, 10);
	self setgoalentity(level.player);
	self.favoriteenemy = level.player;
	self thread constantAttackPlayerRadius();
}

constantAttackPlayerRadius()
{
	//steps down goalradius, making attacker slowly close in on player
	
	self endon ("death");
	self.goalradius = 1800;
	while(self.goalradius > 600)
	{
		wait randomfloatrange(8, 12);
		self.goalradius = self.goalradius - 128;
	}
}

constantAttackNavDiag()
{
	self endon ("death");
	time = 60;
	scale = 1.6;
	off = undefined;
	height = undefined;
	while(1)
	{
		thread temp_message(self, self.script_noteworthy, scale, off, height, time);
		wait time*0.05;
	}
}

//**********************************************//

playerBuddiesStart()
{
	level.currentBuddySpawnZone = "buddy_startroad";	//initial buddy spawnzone label on one of the zone triggers
	thread buddySpawnZoneSetup();
}

/*
playerBuddiesFollowers()
{
	//2 mortal field followers to account for 
	
	node = getnode("braeburn_fieldcross", "targetname");
	
	for(i=0; i<level.introFollowersKilled; i++)
	{
		 thread playerBuddies(undefined, undefined, undefined, undefined);
	}
}
*/

playerBuddies(node, moveDelay, friendlyVolume, coreNode)
{
	//X redshirts for the player at all times who can die, then respawn and catch up again, using the node used by predecessor
	//call this thread to spawn one replacement
	
	//Get all of the buddy spawners for the currently tracked location
	
	level endon ("town captured");
	
	aSpawners = getspawnerarray();
	aBuddies = [];
	for(i=0; i<aSpawners.size; i++)
	{
		if(!isdefined(aSpawners[i].targetname))
			continue;
		if(aSpawners[i].targetname != "player_buddy")
			continue;
		if(aSpawners[i].script_noteworthy != level.currentBuddySpawnZone)
			continue;
		aBuddies[aBuddies.size] = aSpawners[i];
	}
	
	//Pick a weapon from the distribution
		
	garandchance = 35;
	thompsonchance = 20;
	carbinechance = 25;
	barchance = 20;
	
	n = randomint(100);
	
	g = 100 - garandchance;
	t = g - thompsonchance;
	c = t - carbinechance; 	
	b = c - barchance;
	
	msg = "";
		
	if(n >= g)
	{
		msg = "garand";
	}
	if(n < g && n >= t)
	{
		msg = "thompson";
	}
	if(n < t && n >= c)
	{
		msg = "carbine";
	}
	if(n < c && n >= b)
	{
		msg = "bar";
	}
	
	//Match chosen weapons to one of the available buddy spawners for that location
	
	for(i=0; i<aBuddies.size; i++)
	{
		assertEX(isdefined(aBuddies[i].script_namenumber), "Buddy spawner without a script_namenumber indicating weapon type.");
		if(aBuddies[i].script_namenumber == msg)
			break;
	}	
	
	//Keep trying to spawn until successful
	
	while(1)
	{			
		aBuddies[i].count = 1;
		
		aAllies = undefined;
		aNormalGuys = undefined;
		aAllies = [];
		aNormalGuys = [];
		nBuddy = undefined;
		aAllies = getaiarray("allies");

		for(k=0; k<aAllies.size; k++)
		{
			if(isdefined(aAllies[k].script_friendname) && aAllies[k].script_friendname == "Sgt. Randall")
				continue;
			if(isdefined(aAllies[k].script_friendname) && aAllies[k].script_friendname == "Pvt. Braeburn")
				continue;
			if(isdefined(aAllies[k].script_friendname) && aAllies[k].script_friendname == "Pvt. McCloskey")
				continue;
			if(isdefined(aAllies[k].script_friendname) && aAllies[k].script_friendname == "Pvt. Peas")
				continue;
			
			aNormalGuys[aNormalGuys.size] = aAllies[k];
		}
		
		if(aNormalGuys.size < level.friendlyPopLimit)
		{
			nBuddy = aBuddies[i] doSpawn();	
			if(spawn_failed(nBuddy))
			{
				wait 1;
				continue;
			}
			
			nBuddy.suppressionwait = 0;
			break;
		}
		
		wait 0.05;
	}
	
	nBuddy thread friendlyAreaNav(node, moveDelay, friendlyVolume, coreNode);
	nBuddy thread friendlyAreaDeath(node, moveDelay, friendlyVolume, coreNode);
}

buddySpawnZoneSetup()
{	
	aBuddySpawnZones = getentarray("buddyspawntrig", "targetname");
	for(i=0; i<aBuddySpawnZones.size; i++)
	{
		aBuddySpawnZones[i] thread buddySpawnZoneMonitor();
	}
}

buddySpawnZoneMonitor()
{
	//Updates the current spawn zone location for mortal player buddies
	
	while(1)
	{
		self waittill ("trigger");
		level.currentBuddySpawnZone = self.script_noteworthy;
	}
}

buddyPopMonitor()
{
	//Diagnostic prints for friendly population
	
	if (getcvar ("buddyPopDiag") != "on")
	{
		return;
	}
	
	level endon ("town captured");
	
	while(1)
	{
		wait 0.05;
		if(isalive(level.braeburn))
			continue;
		if(isalive(level.randall))
			continue;
		if(isalive(level.mccloskey))
			continue;
		break;
	}
	
	while(1)
	{
		aAllies = [];
		aAllies = getaiarray("allies");
		println("Buddy population is ", aAllies.size);
		//assertEX(aAllies.size < 7, "Buddy population is less than 7");
		wait 0.5;
		aAllies = undefined;
		
	}
}

//**********************************************//
//		  		DEV UTILITIES					//
//**********************************************//

temp_message(eObject, msg, scale, off, height, time)
{
	//Displays a message for 3 seconds in 3D space above an AI or vehicle
	eObject endon("death");
	
	if(isdefined(off))
	{
		if (getcvar ("print3d") != "on")
		{
			return;
		}
	}
	
	if(!isdefined(height))
	{
		height = 64;
	}
	
	if(!isdefined(scale))
	{
		scale = 0.8;
	}
	
	if(!isdefined(time))
	{
		time = 60;
	}

	for(i=0; i<time; i++)
	{
		if(isdefined(eObject))
		{
			print3d (eObject.origin + (0,0,height), msg, (0.0,0.7,1.0), 1, scale);	// origin, text, RGB, alpha, scale
			wait 0.05;
		}
		else
		{
			break;
		}
	}
	
	//wait 0.75;	
}

skip_teleport_init(teleporter, playerOrigin)
{
	//Teleports friendlies and player to starting positions appropriate for a given chapter break
	
	aStartNodes = getentarray(teleporter, "targetname");
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aStartNodes[i]))
		{
			aAllies[i] teleport (aStartNodes[i].origin);
		}
	}
	
	//special allied character teleports for chapter break support
	
	if(getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		braeburnNode = getnode("braeburn_perch", "targetname");
		level.braeburn teleport (braeburnNode.origin);
		
		mccloskeyNode = getnode("mccloskey_doorman", "targetname");
		
		mcspawner = getent("Pvt. McCloskey returns", "script_noteworthy");
		level.mccloskey = mcspawner doSpawn();
		level.mccloskey.animname = "mccloskey";
		level.mccloskey thread maps\_utility::magic_bullet_shield();
		
		level.mccloskey teleport (mccloskeyNode.origin);
	}
	
	level.eSiloIntact delete();
	level.eSiloPieces delete();
	level.eSiloBreached show();
	
	wait 0.05;
	
	level.player setorigin (playerOrigin);
	
	if(getcvar("skipto") == "defense" || getcvar("skipto") == "retreat" || getcvar("skipto") == "epilogue")
	{
		level.mccloskey.goalradius = 8;
		level.mccloskey.dontavoidplayer = true;
	}
}

//**************************************//
//		  DIALOGUE UTILITIES			//
//**************************************//

Dialogue_Thread(dialogue, node, override)
{
	if(!isalive(self))
		return;
	
	self setBattleChatter(false);
	
	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking && !isdefined(override))
		self waittill ("my done speaking");

	if(!isalive(self))
		return;

	self.MyIsSpeaking = true;
	
	if(isdefined(node))
	{
		node anim_single_solo(self, dialogue);	
	}
	else
	{
		self anim_single_solo(self, dialogue);
	}
	
	if(isalive(self))
	{
		self setBattleChatter(true);
		self.MyIsSpeaking = false;
		self notify ("my done speaking");
	}
}

dialogue_smokehint_init()
{
	aSmokeHints = getentarray("hint_smokethrow", "targetname");
	for(i=0; i<aSmokeHints.size; i++)
	{
		aSmokeHints[i] thread dialogue_smokehint();
	}
}

dialogue_smokehint()
{	
	level endon ("town captured");
	
	self waittill ("trigger");
	guy = undefined;
	
	//nag the player to use smoke grenades
	
	//for(i=0; i<2; i++)
	//{
		if(level.player getfractionmaxammo("smoke_grenade_american") == 0)
			return;
			//break;
		
		if(!level.saySmokeHint)
			return;

		battleChatterOff("allies");

		aAllies = getaiarray("allies");
		if(aAllies.size <= 0)
		{
			playSoundinSpace("hint_smokegrenade", self.origin);
		}
		else
		{
			guy = aAllies[randomint(aAllies.size)];
			playSoundinSpace("hint_smokegrenade", guy.origin);
		}
		
		battleChatterOn("allies");
		
		//wait randomintrange(5,10);
	//}
}

dialogue_roomclearing_init()
{
	level.roomClearingPhrase[0] = "silotown_gr5_onebyone";
	level.roomClearingPhrase[1] = "silotown_gr5_checkeachroom";
	level.roomClearingPhrase[2] = "silotown_gr5_makesure";
	level.roomClearingPhrase[3] = "silotown_gr5_makesuretheyredead";
	level.roomClearingPhrase[4] = "silotown_gr5_usegrenades";
	level.roomClearingPhrase[5] = "silotown_gr5_checkotherrooms";
	level.roomClearingPhrase[6] = "silotown_gr5_makesureroomsclear";
}

dialogue_roomclearing(flagName)
{
	if(!isdefined(flagName))
		return;
	
	level endon (flagName);
	level.phraseIndex = 0;
	
	aTrigs = getentarray(flagName, "targetname");
	
	if(aTrigs.size <= 0)
		return;
	
	for(i=0; i<aTrigs.size; i++)
	{
		aTrigs[i] thread dialogue_roomclearing_phrase(flagName);
	}
}

dialogue_roomclearing_phrase(flagName)
{
	level endon (flagName);
	
	self waittill ("trigger");
	
	if(level.phraseIndex > 6)
	{
		level.phraseIndex = 0;
	}
	
	thread dialogue_nearby_friendly(level.roomClearingPhrase[level.phraseIndex]);
	level.phraseIndex++;
}

dialogue_buildingcleared()
{
	while(1)
	{
		level waittill ("building_cleared");
		
		wait 3.5;
		
		if(level.buildingscleared == 1)
		{
			thread dialogue_nearby_friendly("silotown_gr5_morebuildings");		
		}
		
		if(level.buildingscleared == 4)
		{
			thread dialogue_nearby_friendly("silotown_gr5_twobuildingsleft");		
		}
	}
}

dialogue_nearby_friendly(soundAlias)
{
	if(level.busyFriendlyChannel)
		level waittill ("friendly_channel_open");
	
	level.busyFriendlyChannel = true;
	
	battleChatterOff("allies");
	
	aAllies = [];
	aAllies = getaiarray("allies");
	if(aAllies.size <= 0)
	{
		playSoundinSpace(soundAlias, level.player.origin);
	}
	else
	{
		guy = aAllies[randomint(aAllies.size)];
		playSoundinSpace(soundAlias, guy.origin);
		wait 5;
	}
	
	level.busyFriendlyChannel = false;
	level notify ("friendly_channel_open");
	
	battleChatterOn("allies");
}

//**********************************************//
//		  MISCELLANEOUS UTILITIES				//
//**********************************************//

friendly_cutscene_settings(msg)
{
	aAllies = [];
	aAllies = getaiarray("allies");
	
	if(msg == "on")
	{
		for(i=0; i<aAllies.size; i++)
		{
			aAllies[i].dontavoidplayer = true;
			aAllies[i].goalradius = 32;
		}
	}
	if(msg == "follow")
	{
		for(i=0; i<aAllies.size; i++)
		{
			aAllies[i].dontavoidplayer = false;
			aAllies[i].goalradius = 1024;
		}
	}
	if(msg == "independent")
	{
		for(i=0; i<aAllies.size; i++)
		{
			aAllies[i].dontavoidplayer = false;
			aAllies[i].goalradius = 768;
		}
	}
	
	aAllies = undefined;
}

schoolcircle(nodename, leadername, leaderNodeName, leader, locationName)
{	
	//Makes any number of Allied troops assemble with a leader, useful for regrouping for in-level briefings
	
	//nodename = targetname of the nodes used by the grunts
	//leadername = script_friendname of the commanding officer character who will give the speech
	//leaderNodeName = targetname of the node used by the commander
	//leader = variable used to represent the leader character entity
	//locationName = targetname of the location shown on the compass, player must enter within 192 units of this to arrive
	
	failSafeBlocker = undefined;
	
	aTroops = [];
	nodearray = getnodearray(nodename, "targetname");
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{	
		if(!isdefined(aAllies[i].script_friendname))
		{
			aTroops[aTroops.size] = aAllies[i];
		}
		else
		if(aAllies[i].script_friendname != leadername)
		{
			/*
			if(nodename == "endbriefing_schoolcircle_node" && aAllies[i].script_friendname == "Pvt. Braeburn")
			{
				braeburnLookoutNode = getnode("braeburn_lookout_post", "targetname");
				aAllies[i] setgoalnode(braeburnLookoutNode);
				continue;
			}
			
			if(nodename == "endbriefing_schoolcircle_node" && aAllies[i].script_friendname == "Pvt. McCloskey")
			{
				//level.mccloskey setcontents(0);	
				mccloskeyLookoutNode = getnode("mccloskey_lookout_post", "targetname");
				aAllies[i] setgoalnode(mccloskeyLookoutNode);
				continue;
			}
			*/
			
			aTroops[aTroops.size] = aAllies[i];
		}
	}
	
	for(i=0; i<aTroops.size; i++)
	{
		aTroops[i] thread schoolcircle_nav(nodearray, i);
	}
	
	leaderNode = getnode(leaderNodeName, "targetname");
	leader.goalradius = 64;
	leader setgoalnode(leaderNode);
	leader waittill ("goal");
	
	//Wait for player to meet up with the squad
	
	briefingPoint = getent(locationName, "targetname");
	dist = length(level.player.origin - briefingPoint.origin);
	while(dist > 256)
	{
		dist = length(level.player.origin - briefingPoint.origin);
		wait 0.1;
	}	
}

schoolcircle_nav(nodearray, i)
{
	self endon ("death");
	
	wait 2.5;	//soft wait to avoid traffic jams w/ leader
	self setgoalnode(nodearray[i]);
	self.goalradius = 32;
	self.dontavoidplayer = true;
	self allowedstances ("stand");
	if(!isdefined(nodearray[i].script_noteworthy))
		return;
	if(nodearray[i].script_noteworthy == "kneel")
		thread schoolcircle_crouch(self);
}

schoolcircle_crouch(soldier)
{
	soldier waittill ("goal");
	soldier allowedstances ("crouch");
}

killplayer()
{
	level.player enableHealthShield( false );
		level.player doDamage (level.player.health, level.player.origin);	//killplayer
	level.player enableHealthShield( true );
}

saveCrawl()
{
	level endon ("town captured");
	
	if (getcvar("skipto") == "" || getcvar("skipto") == "field")
	{
		flag_wait("field completed");
	}	
	
	while(1)
	{
		wait level.saveCrawlTime;
		thread autoSaveByname ("townAssault");
	}
}

bermSave()
{
	//level endon ("charge activated");
	
	bermSaveTrig = getent("autosave_berm", "targetname");
	bermSaveTrig waittill ("trigger");
	
	flag_set("bermSave_triggered");
	
	thread autoSaveByname ("at_the_berm");
}

//******************************//
//		  MUSIC UTILITIES		//
//******************************//

music_intro()
{
	musicplay("silotown_intro_music");
	level waittill ("begin field charge");
	musicstop(8);
}

music_ending()
{
	//wait 182.2;
	wait 124;
	musicplay("victory_somber_01");
}

/*
	//Smokescreens
	smokeright = getent("smokeright", "targetname");
	playfx(level.smokegrenade, smokeright.origin);
	
*/

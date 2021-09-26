/****************************************************************************
Level: 		HILL 400 DEFEND (hill400_defend.bsp)
Campaign: 	American Rangers Hurtgen Forest
Objectives:
	1. Hold Hill 400 until relieved by friendly forces. (persistent throughout)
	2. Snipe the enemy mortar teams.
	3. Stop the Germans from breaching and storming the bunker aid station.
	4. Take cover from the artillery barrage.
	5. Clear out any remaining opposition on the hill.	
	6. Head back down the hill to report in at the HQ in Bergstein.

*****************************************************************************/
/*

- hill400_defend

	- start cvars for testing
		start
		mortars
		firstbarrage
		secondwave
		secondbarrage
		thirdwave
		rescue
		planes
*/

#include maps\_utility;
#include maps\_anim;
#include maps\_ambient;
#using_animtree("generic_human");

main()
{
	
	//*** Dev Cvars
	
	setExpFog( 0.00002, .4, .4, .444, 0 );
	
	//Global Scripts & Precaching
	
	precacheString(&"HILL400_DEFEND_REINFORCEMENTS");
	precacheString(&"HILL400_DEFEND_WOUNDED_IN_ACTION");
	precacheString(&"HILL400_DEFEND_THE_GERMANS_TOOK_THE");
	precacheString(&"HILL400_DEFEND_HINT_THE_MORTAR_TEAMS");
	precacheString(&"HILL400_DEFEND_HINT_YOU_WILL_SEE_A_SMOKE");
	
	precacheModel( "xmodel/vehicle_spitfire_flying" );
	precacheModel("xmodel/vehicle_p51_mustang");
	
	precacheModel("xmodel/military_tntbomb");
	precacheModel("xmodel/military_tntbomb_obj");
	precacheModel("xmodel/weapon_stickybomb");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
 	precacheShader("inventory_tnt_small");   
 	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		precacheshader("popmenu_bg");
	
	precacheRumble("artillery_quake");
	
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");
    maps\_halftrack::main("xmodel/vehicle_halftrack_mg_brush");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland_brush");
	
	maps\hill400_defend_fx::main();
	maps\hill400_defend_anim::main();
	maps\hill400_defend_str::main();
	maps\_load::main();
	maps\_mortarTeam::main();
	
	level.xenon = false;
	
	if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
		level.xenon = true;
	
	if (getcvar("scr_hill400defend_minspec") == "")
	setcvar("scr_hill400defend_minspec","0");
		
	if (!level.xenon && getcvarint("scr_hill400defend_minspec") > 0)
	{
		setCullDist (6000);
	}
	
	//Flags
	
	if(getcvar("start") == "start")
		flag_clear("mortar teams approaching");
	else
		flag_set("mortar teams approaching");
	
	flag_clear("bunkerempty");
	flag_clear("bunkersealed");
	flag_clear("bunker friendlies clear");
	
	flag_clear("player vulnerable");
	flag_clear("on_our_side");
	flag_clear("falling_back");
	flag_clear("halftracks_in_place");
	flag_clear("cue_end_music");
	
	flag_clear("real_threat_ended");
	
	//Objective Related Flags
	
	flag_clear("mortars completed");
	flag_clear("first wave completed");
	flag_clear("first artillery barrage starts");
	
	flag_clear("second_wave_starts");
	flag_clear("second wave completed");
	flag_clear("second wave eliminated");
	flag_clear("second artillery barrage starts");
	
	flag_clear("start timer");
	flag_clear("third_wave_starts");
	flag_clear("third_wave_tanks");
	flag_clear("third wave completed");
	flag_clear("third_wave_eliminated");
	
	flag_clear("planes arrive");
	flag_clear("planes bombing");
	flag_clear("stop_on_planes_approach");
	flag_clear("epilogue_done");
	flag_clear("victory");
	
	//Level Variables
	
	level.gameSkill = getcvarint("g_gameskill");
	
	if (getcvar("start") != "rescue")
		level.stopwatch = 5;	//time until relieved, in minutes
	else
		level.stopwatch = 1;	//for testing timing of music and sfx near the end of the battle

	level.secondWaveDuration = 180;
	level.thirdWaveDuration = level.stopwatch * 60;
	
	level.planeDelay = 30;
	level.planePop = 0;
	aPlaneSpawners = getvehiclenodearray("mustangs", "script_noteworthy");
	level.maxPlanePop = aPlaneSpawners.size;
	aPlaneSpawners = undefined;

	if(getcvar("start") == "start")
		level.simulatedBattle = true;	//fighting is fake whenever player is inside the bunker_volume
	else
		level.simulatedBattle = false;

	level.playerShocked = false;
	
	switch(level.gameSkill)
	{
		case 0:
			level.player.threatbias = 50;
			level.playerMortarScareTime = 120;	//time before a mortar team is able to damage the player
			level.patternHoldTime = 90;		//time before smoke squad units seek and attack the player
			level.mortarTeamsRequired = 3;	//number of mortar teams the player must eliminate before the first arty barrage
			level.mortarTeamPopLimit = 2;	//max number of mortar teams allowed to be active at a time
			level.mortarMisses = 20;			//number of times a mortar team will miss before killing a friendly during mortar sequence
			level.mortarDeployGap = 25;		//time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarHintThreshold = 2;	//number of mortarteams that must be eliminated before the hints stop printing
			level.mortarTeamHintDelay = 2;	//time before the mortarteam hints start to print
			level.mortarHintInterval = 20;	//time between mortarteam hint reprints
			level.shelterReachTime = 15;	//time the player gets to safely reach shelter, after which shellshock ensues on chance hit
			level.friendlyMaxPop = 7;	//max number of reinforcements the player gets at the end of each barrage
			level.friendliesMortal = 3;	//number of friendlies allowed to die by mortarteam attacks
			level.magicGrenadeIntervalMin = 30;	//min time between magic grenades
			level.magicGrenadeIntervalMax = 60;	//max time between magic grenades
			level.grenadeFuseTime = 12;
			level.preBarrageTime = 26;		//time for player to grab weapons before the next barrage begins
			level.replenishDelay  = 20;		//delay before a new smoke squad can respawn
			level.playerFightCheckTime = 45;	//interval for checking if player is killing enemies
			level.friendlyAccuracy = 3;		//baseAccuracy for friendlies
			level.normalAccuracy = 2.8;		//baseAccuracy for friendlies to revert to during normal attack waves
			level.smokeSquadAcc = 0.4;			//baseAccuracy for enemies from smoke squads default
			level.smokeSquadAccRifle = 0.3;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.25;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.3;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.28;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.5;		//baseAccuracy for enemies from death squads
			break;
		case 1:
			level.player.threatbias = 80;
			level.playerMortarScareTime = 100;	//time before a mortar team is able to damage the player
			level.patternHoldTime = 70;			//time before smoke squad units seek and attack the player
			level.mortarTeamsRequired = 5;	//number of mortar teams the player must eliminate before the first arty barrage
			level.mortarTeamPopLimit = 3;	//max number of mortar teams allowed to be active at a time
			level.mortarMisses = 16;		//number of times a mortar team will miss before killing a friendly during mortar sequence
			level.mortarDeployGap = 20;		//time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarHintThreshold = 2;	//number of mortarteams that must be eliminated before the hints stop printing
			level.mortarTeamHintDelay = 12;	//time before the mortarteam hints start to print
			level.mortarHintInterval = 30;	//time between mortarteam hint reprints
			level.shelterReachTime = 15;	//time the player gets to safely reach shelter, after which shellshock ensues on chance hit
			level.friendlyMaxPop = 6;	//max number of reinforcements the player gets at the end of each barrage
			level.friendliesMortal = 3;	//number of friendlies allowed to die by mortarteam attacks
			level.magicGrenadeIntervalMin = 18;	//min time between magic grenades
			level.magicGrenadeIntervalMax = 25;	//max time between magic grenades
			level.grenadeFuseTime = 6;
			level.preBarrageTime = 24;		//time for player to grab weapons before the next barrage begins
			level.replenishDelay = 18;		//delay before a new smoke squad can respawn
			level.playerFightCheckTime = 30;		//interval for checking if player is killing enemies
			level.friendlyAccuracy = 3;		//baseAccuracy for friendlies
			level.normalAccuracy = 2.7;		//baseAccuracy for friendlies to revert to during normal attack waves
			level.smokeSquadAcc = 0.5;		//baseAccuracy for enemies from smoke squads default
			level.smokeSquadAccRifle = 0.3;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.28;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.3;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.28;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.5;		//baseAccuracy for enemies from death squads
			break;
		case 2:
			level.player.threatbias = 100;
			level.playerMortarScareTime = 60;	//time before a mortar team is able to damage the player
			level.patternHoldTime = 60;			//time before smoke squad units seek and attack the player
			level.mortarTeamsRequired = 7;	//number of mortar teams the player must eliminate before the first arty barrage
			level.mortarTeamPopLimit = 3;	//max number of mortar teams allowed to be active at a time
			level.mortarMisses = 15;			//number of times a mortar team will miss before killing a friendly during mortar sequence
			level.mortarDeployGap = 18;		//time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarHintThreshold = 0;	//number of mortarteams that must be eliminated before the hints stop printing
			level.mortarTeamHintDelay = 0;	//time before the mortarteam hints start to print
			level.mortarHintInterval = 0;	//time between mortarteam hint reprints
			level.shelterReachTime = 15;	//time the player gets to safely reach shelter, after which shellshock ensues on chance hit
			level.friendlyMaxPop = 6;	//max number of reinforcements the player gets at the end of each barrage
			level.friendliesMortal = 2;	//number of friendlies allowed to die by mortarteam attacks
			level.magicGrenadeIntervalMin = 16;	//min time between magic grenades
			level.magicGrenadeIntervalMax = 20;	//max time between magic grenades
			level.grenadeFuseTime = 6;
			level.preBarrageTime = 24;		//time for player to grab weapons before the next barrage begins
			level.replenishDelay = 16;		//delay before a new smoke squad can respawn
			level.playerFightCheckTime = 28;		//interval for checking if player is killing enemies
			level.friendlyAccuracy = 3;		//baseAccuracy for friendlies
			level.normalAccuracy = 2.6;		//baseAccuracy for friendlies to revert to during normal attack waves
			level.smokeSquadAcc = 0.55;		//baseAccuracy for enemies from smoke squads default
			level.smokeSquadAccRifle = 0.45;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.45;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.45;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.45;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.75;		//baseAccuracy for enemies from death squads
			break;
		case 3:
			level.player.threatbias = 150;
			level.playerMortarScareTime = 50;	//time before a mortar team is able to damage the player
			level.patternHoldTime = 55;		//time before smoke squad units seek and attack the player
			level.mortarTeamsRequired = 10;	//number of mortar teams the player must eliminate before the first arty barrage
			level.mortarTeamPopLimit = 4;	//max number of mortar teams allowed to be active at a time
			level.mortarMisses = 14;			//number of times a mortar team will miss before killing a friendly during mortar sequence
			level.mortarDeployGap = 16;		//time between attempts to spawn another mortar team (overlapping spawns)
			level.mortarHintThreshold = 0;	//number of mortarteams that must be eliminated before the hints stop printing
			level.mortarTeamHintDelay = 0;	//time before the mortarteam hints start to print
			level.mortarHintInterval = 0;	//time between mortarteam hint reprints
			level.shelterReachTime = 15;	//time the player gets to safely reach shelter, after which shellshock ensues on chance hit
			level.friendlyMaxPop = 6;	//max number of reinforcements the player gets at the end of each barrage
			level.friendliesMortal = 1;	//number of friendlies allowed to die by mortarteam attacks
			level.magicGrenadeIntervalMin = 14;	//min time between magic grenades
			level.magicGrenadeIntervalMax = 18;	//max time between magic grenades
			level.grenadeFuseTime = 5.5;
			level.preBarrageTime = 24;		//time for player to grab weapons before the next barrage begins
			level.replenishDelay = 14;		//delay before a new smoke squad can respawn
			level.playerFightCheckTime = 23;	//interval for checking if player is killing enemies
			level.friendlyAccuracy = 2.9;		//baseAccuracy for friendlies
			level.normalAccuracy = 2.5;		//baseAccuracy for friendlies to revert to during normal attack waves
			level.smokeSquadAcc = 0.55;		//baseAccuracy for enemies from smoke squads default
			level.smokeSquadAccRifle = 0.6;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.6;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.6;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.6;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.6;		//baseAccuracy for enemies from death squads
			break;
	}
	
	//Desertion Controllers
	
	level.desertionSmokeStartTime = 10;
	level.desertionTimeLimit = 40;
	level.playerDeparted = false;
	level.shelterAccessClip = true;
	
	assertEX(level.desertionTimeLimit > level.desertionSmokeStartTime, "Desertion - smoke start time must be less than timelimit.");

	//Smoke Squad Controllers
	
	level.smokegrenadetime = 6;		//time for smoke squad's smokescreen to build up sufficiently to spawn
	level.smokeDuration = 30;		//time during which there is enough smoke to do multiple spawns without spewing more smoke
	level.closurepercent = 0.82;	//goalradius reduction target per turn
	level.closuretime = 2;			//time between goalradius reductions
	level.closurethreshold = 512;	//minimum distance from goal before changing to new goalnode in world units
	level.closuremod = 3.8;			//randomfloat added to base closuretime
	level.replenishPercent = 0.25;	//fraction of squad strength at which reinforcements may respawn for that squad id
	level.stopSmokeSquads = false;	//switch to stop spawning at end of waves

	//Mortar Team Controllers
	
	level.mortarTeamSlots = 0;		//number of currently occupied mortar team slots
	level.explosionhide	= true; 	//explosions played in mortarteam.gsc are bypassed, so they can be played manually
	level.timetoimpact = 3;			//time before the explosion fx & sound plays on the impact point
	level.shockRange = 128;			//distance in world units from a friendly mortar death at or below which the player gets shellshocked
	level.shockTime = 3;			//duration of shellshock
	level.shockTimeLong = 20;
	level.safemortardist = 192;		//minimum distance at which a fake mortar impact can be played from an AI to look reasonably ineffective
	level.mortarIndexSize = 8;		//number of indices available when using objective_additionalposition
	level.mortarActiveTeams = 0;	//monitor, actual number of mortar teams active
	level.mortarObjNumber = 2; 		//objective index of the 'defend against mortar teams' obj (in case it changes)
	level.mortarTeamsDeployed = 0;	
	level.mortarTeamsEliminated = 0;
	level.playerMortarScareGrace = 8;	//one-time grace period on mortar scaring
	level.mortarFriendlyKill = 0;		//tracks number of guys killed by the enforced mortar deaths
	level.difficultMortarSave = 1;		//used to determine save point on every other mortar team on Veteran
	
	//Artillery Barrage Controllers
	
	level.firstBarrageDuration = 30;	//45
	level.artyMinTime = 0.3;		
	level.artyMaxTime = 2;		
	level.safeartydist = 3000;
	level.playerSafe = false;
	level.barrageGracePeriod = 2;	//grace period before final check, in case player drifts or tempts fate
	level.cos80 = cos(80);

	assertEX(level.firstBarrageDuration > level.shelterReachTime, "Length of barrage must be longer than min time to reach shelter.");
	
	//Friendlies
	
	level.currentPop = 0;			
	level.friendlyMinPop = 4;	//this many friendlies are shielded per attackwave
	level.friendlieskilled = 0;	
	level.guaranteedSurvivalPop = 3;	//this many friendlies are guaranteed to survive per attackwave regardless of player participation
	
	//Enemies
	
	level.allowedMaxPop = 32;
	
	//Vehicles
	
	level.carpetBomb = true;	
	level.tankpop = 3;
	level.halftracksSpawned = 0;
	level.tanksSpawned = 0;
	level.halftracksArrived = 0;
	level.tankArmy = [];
	
	//Bomb Planting
	
	level.timersused = 0;
	level.player.tnt = 6;
	level.inv_tnt = maps\_inventory::inventory_create("inventory_tnt_small",true);
	
	//Dialogue
	
	level.introtalking = true;
	level.onetimeshout = false;
	level.busyFriendlyChannel = false;
	level.friendlyTalkQueue = [];
	level.friendlySpeechNum = 0;
	level.friendlySpeechPos = 0;
	
	//Death Squads & Anti-Camping
	
	level.deathSquadPop = 0;
	level.deathSquadPopLimit = 4;		//max number of undeletable player hunters
	level.deathSquadInterval = 30;		//time between respawns
	level.deathSquadInitRadius = 1000;	//starting radius from player	
	level.deathSquadHoldTime = 3;		//time to spend at the current radius from player
	level.deathSquadRadiusStep = 200;	//step down radius each cycle
	level.minMagicGrenadeAI = 2;		//min AI population for magic grenades to happen
	level.playerKillCount = 0;			//increments each time player kills an enemy during an attack wave
	
	//Compass
	
	level.baseCompassRange = getcvarint("cg_hudCompassMaxRange");
	
	//Dataset Init Threads
	
	smoke_timeout_init();
	smoke_squad_status_init();
	
	//Threads
	
	setupCharacters();
	
	thread maps\hill400_defend_amb::main();
	
	if (getcvar("start") == "start")
	{
		detector = getent("bunker_volume", "targetname");
		
		thread intro();
		thread intro_bunker_door();
		thread intro_bunker_action_monitor(detector);
		thread intro_bunker_player_monitor(detector);
		thread intro_bunker_generics(detector);
		thread music_intro();
		//thread ff_damagecheck();
	}
	
	if (getcvar("start") != "start")
	{	
		thread startcvar_afterintro_init();		//bunker locks down, everyone moved to starting places
		thread intro_bunker_character_depart();	//delete AI in bunker
	}
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars")
	{
		thread objective_mortars();
		thread friendly_stats_boost();
		//thread lookout_mortal();
		thread mortar_group_control();
		thread dialogue_mortarsnipenag();
	}
	
	if (getcvar("start") == "firstbarrage" || getcvar("start") == "secondbarrage")
	{
		thread artillery_barrage_control();
	}
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars")
	{
		thread smoke_squad_deploy(1);
	}
	
	if (getcvar("start") == "secondwave")
	{
		thread smoke_squad_deploy(2);
	}
	
	if (getcvar("start") == "thirdwave" || getcvar("start") == "rescue")
	{
		thread smoke_squad_deploy(3);
	}
	
	if(getcvar("start") == "secondbarrage" || getcvar("start") == "thirdwave" || getcvar("start") == "rescue" || getcvar("start") == "planes")
	{
		thread startcvar_after_westbreach();
	}
	
	if(getcvar("start") == "rescue" || getcvar("start") == "planes")
	{
		thread startcvar_after_northbreach();
	}

	if (getcvar("start") != "planes")
	{
		thread objective_stopwatch();
	}
	
	if (getcvar("start") == "planes")
	{
		thread startcvar_planes_tankinit();
	}
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars")
	{
		thread shoutingDuringMortars();
	}
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage" || getcvar("start") == "secondwave")
	{
		thread shoutingDuringSecondWaveAttack();
	}
	
	if (getcvar("start") != "rescue" || getcvar("start") != "planes")
	{	
		thread shoutingDuringThirdWaveAttack();
		thread shoutingDuringThirdWaveAttackLate();
		thread shoutingDuringThirdWaveTanks();
		thread player_deathsquad();
		thread magic_grenades();
		thread magic_grenade_data();
	}
	
	thread vehicle_halftracks_kill();
	thread dialogue_nearby_friendly();
	thread mortarteam_announcement_dialogue();
	thread dialogue_atmosphere_endons();
	thread atmosphere_wounded_characters();
	
	thread desertion_monitor();
	thread desertion_outofbounds();
	
	thread ambient_track();
	thread objectives();
	thread vehicle_airplanes();
	thread shoutingDuringVictory();
	thread retreat_init();
	thread victory();
}

startcvar_afterintro_init()
{
	//Starts at the moment the bunker locksdown
	
	thread intro_bunker_door();
	
	//Teleport the player to a spot just outside the bunker
	
	playerpos = getent("startcvar_mortars_playerpos", "targetname");
	level.player setorigin (playerpos.origin);
	
	//Teleport the non-lookout generic friendlies to generic_stations
	
	thread intro_friendly_depart();
}

startcvar_after_westbreach()
{
	aBlocker = getentarray("vehiclebreach_west", "targetname");
	playerclip = getent("vehiclebreach_west_playerclip", "targetname");
		
	playerclip delete();
	for(i=0; i<aBlocker.size; i++)
	{
		aBlocker[i] delete();
	}
}

startcvar_after_northbreach()
{
	aBlocker = getentarray("vehiclebreach_north", "targetname");
	playerclip = getent("vehiclebreach_north_playerclip", "targetname");
		
	playerclip delete();
	for(i=0; i<aBlocker.size; i++)
	{
		aBlocker[i] delete();
	}
}

startcvar_planes_tankinit()
{
	aTrigs = getentarray("startcvar_planes_tankinit", "targetname");
	for(i=0; i<aTrigs.size; i++)
	{
		aTrigs[i] notify ("trigger");
	}
}

setupCharacters()
{
	level.randall = getent("randall", "targetname");
	level.randall.animname = "randall";
	//level.randall.anim_disablePain = true;
	
	level.braeburn = getent("braeburn", "targetname");
	level.braeburn.animname = "braeburn";
	//level.braeburn.anim_disablePain = true;
	
	level.mccloskey = getent("mccloskey", "targetname");
	level.mccloskey.animname = "mccloskey";
	
	level.carter = getent("carter", "targetname");
	level.carter.animname = "carter";
	//level.carter.anim_disablePain = true;
	
	level.randall.script_bcdialog = 0;
	level.braeburn.script_bcdialog = 0;
	level.mccloskey.script_bcdialog = 0;
	level.carter.script_bcdialog = 0;
}

intro()
{
	//indefinite simulated battle until bunker lockdown (starts action noise)	
	//original outside friendlies (lookouts) all on magic_bullet_shield, with high accuracy, firing at enemies
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].goalradius = 8;
		aAllies[i].dontavoidplayer = true;
		aAllies[i] pushPlayer(true);
		aAllies[i].grenadeawareness = 0;
		aAllies[i] thread maps\_utility::magic_bullet_shield();
		//aAllies[i].anim_disablePain = true;
		aAllies[i].script_bcdialog = 0;
		aAllies[i].interval = 0;
		aAllies[i].baseAccuracy = 2;
		
		//aAllies[i] thread ff_damagecheck();
		
		if(!isdefined(aAllies[i].script_namenumber))
			continue;
		
		if(aAllies[i].script_namenumber == "crouchguy")
			aAllies[i] allowedstances ("crouch");
			
		if(aAllies[i].script_namenumber == "lookout")
		{
			aAllies[i].goalradius = 8;
			aAllies[i].dontavoidplayer = false;
		}
	}
	
	randallNode = getnode("randall_startnode", "targetname");
	level.randall setgoalnode (randallNode);
		
	level.randall dialogue_thread("hill400_defend_rnd_intro1");
	//"Dog Company listen up. We're the only ones left - everyone else is either dead or wounded."
	wait 0.1;

	level.randall thread dialogue_thread("hill400_defend_rnd_intro2");
	//Battalion has promised to relieve us soon, but I wouldn't hold my breath, until we get some --(interrupted)
	wait 3.5;
	
	thread ambientEventStart("combat infantry");
	
	//COUNTERATTACK!!! Enemy mortar teams moving up the hill!!
	speaker = getent("counterattack_speaker", "targetname");
	
	thread intro_friendly_depart();
	playSoundinSpace("hill400_defend_countatkannounce1", speaker.origin);
	thread intro_bunker_gocodes();
	
	//Randall goes to the murderhole and 'guards' forever
	randallNode = getnode("randall_idlenode", "targetname");
	level.randall setgoalnode (randallNode);
	
	playSoundinSpace("hill400_defend_countatkannounce2", speaker.origin);
	
	flag_set("mortar teams approaching");
	
	level.randall dialogue_thread("hill400_defend_rnd_mortarteams1");
	//"Taylor! Get out there and take out those Kraut mortar teams!  Everyone else, get to your stations, MOVE!!"
	wait 0.2;
	
	level.randall dialogue_thread("hill400_defend_rnd_mortarteams2");
	//"Don't let the Krauts get into this bunker! We got a lotta wounded in here!!"
	wait 0.5;
	
	if(!flag("bunkersealed"))
	{
		level.randall dialogue_thread("hill400_defend_rnd_securedoor");
		//"Carter, wait for 1st squad to move out, then secure the main door!
		
		level.carter dialogue_thread("hill400_defend_gr9_yessir");
		//"Yes sir!"
	}
	
	flag_wait("bunkerempty");
	
	thread intro_bunker_character_depart();
	
	wait 3;
	
	level.introtalking = false;
}

intro_bunker_gocodes()
{
	wait 1;
	//Come on! Move! Move!
	thread dialogue_nearby_friendly_queue("hill400_defend_gocode1");
	wait 4;
	//Let's go! Let's go!
	thread dialogue_nearby_friendly_queue("hill400_defend_gocode2");
	wait 4;
	//Hustle up!!
	thread dialogue_nearby_friendly_queue("hill400_defend_gocode3");
	wait 7;
	//Let's get moving people!
	thread dialogue_nearby_friendly_queue("hill400_defend_gocode4");
}

intro_bunker_character_depart()
{
	//Run Randall, Carter, and McCloskey to the deletenode
	
	deletenode = getnode("character_deletenode", "targetname");
	
	if (getcvar("start") == "start")
	{
		level.randall thread intro_bunker_character_delete(deletenode);
		level.mccloskey thread intro_bunker_character_delete(deletenode);
		level.carter delete();
	
		wait 3;
		speaker = getent("bunker_speaker_randall", "targetname");
		thread maps\_utility::playSoundinSpace("hill400_defend_rnd_wounded", speaker.origin);
		//Randall: "McCloskey, give me a hand with these men!"
	}
	else
	{
		wait 1;
		level.randall delete();
		level.mccloskey delete();
		level.carter delete();
	}
}

intro_bunker_character_delete(node)
{
	self.goalradius = 8;
	self setgoalnode(node);
	self waittill ("goal");
	self delete();
}

intro_friendly_depart()
{
	//Other generic friendlies go straight outside to assigned defensive positions
	
	level endon ("new orders");
	
	aGenericStations = getnodearray("generic_station", "targetname");
	
	nolookouts = undefined;
	
	if (getcvar("start") == "start")
	{
		aGenerics = gather_generic_allies();
	}
	else
	{
		nolookouts = true;
		aGenerics = gather_generic_allies(nolookouts);
	}
	
	assertEX((aGenerics.size <= aGenericStations.size), "Make more cover/concealment nodes with targetname 'generic_station' for the friendlies along perimeter.");	
	
	thread friendly_shields_down(aGenerics);
	
	for(i=0; i<aGenerics.size; i++)
	{
		aGenerics[i] setgoalnode(aGenericStations[i]);
		
		if (getcvar("start") != "start")
		{	
			aGenerics[i] teleport (aGenericStations[i].origin);
			aGenerics[i] pushPlayer(true);
		}
		
		aGenerics[i] allowedstances ("stand", "crouch", "prone");
		
		if (getcvar("start") == "start")
		{	
			wait 0.8;
		}
	}
	
	aGenericStations = undefined;
	aGenerics = undefined;
}

intro_bunker_door()
{
	/*
		If the generic allies & player are not touching the bunker interior volume
			- door shuts
			- timer begins
			- all friendlies all lose their magic_bullet_shield
			- Randall shouts to McCloskey to help him with the wounded
			- run McCloskey & Randall out of sight and delete them
	*/
	
	bunkerdoor = getent("bunkerdoor", "targetname");
	oldDoorOrigin = bunkerdoor.origin;
	bunkerdoorOpen = getent("bunkerdoor_open", "targetname");
	bunkerdoorClip = getent("bunkerdoor_clip", "targetname");
	
	if (getcvar("start") == "start")
	{
		bunkerdoor hide();
		bunkerdoor.origin = (oldDoorOrigin + (0,0,-2000));
		
		bunkerdoorClip hide();
		bunkerdoorClip notsolid();
		bunkerdoorClip connectpaths();
		bunkerdoorOpen solid();
	
	//Bunker locks down, starting timer, making Randall, Carter, and McCloskey run away and delete, action is all real
	//Friendlies lose their magic_bullet_shields but get high health
	
		flag_wait("bunkerempty");
	}
	
	//++++play the sound of the bunker door closing
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars")
	{
		//SLAM!! <Bunker door closing SFX>
		thread playSoundinSpace("hill400defend_bunkerdoor", bunkerdoor.origin);
	}
	
	bunkerdoorOpen hide();
	
	bunkerdoor.origin = oldDoorOrigin;
	bunkerdoor show();
	
	bunkerdoorClip solid();
	bunkerdoorClip disconnectpaths();
		
	flag_set("bunkersealed");
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].grenadeawareness = 0.9;
		aAllies[i].anim_disablePain = false;
		aAllies[i] pushPlayer(false);
		aAllies[i].dontavoidplayer = false;
	}
	
	thread friendlyAreaStart();
	
	wait 6;
	
	thread autoSaveByName("introdone"); 
}

intro_bunker_player_monitor(detector)
{
	//Checks for player presence in bunker_volume AFTER friendlies have departed it completely
	
	flag_wait("bunker friendlies clear");
	
	while(1)
	{
		if(level.player isTouching(detector))
		{
			wait 0.05;
			continue;
		}

		break;
	}
	
	flag_set("bunkerempty");
}

intro_bunker_action_monitor(detector)
{
	//Checks for player presence in bunker_volume to determine if perimeter battle should be switched between staged and real
	//Real battle mode is permanently set 'on' when the bunker locks down
	
	while(!flag("bunkerempty"))
	{
		if(level.player isTouching(detector))
		{
			level.simulatedBattle = true;
		}
		else
		{
			level.simulatedBattle = false;
		}
		
		wait 0.05;
	}
	
	level.simulatedBattle = false;
}

intro_bunker_generics(detector)
{
	//Starts bunker presence monitors on the generic friendlies
	
	aGenerics = gather_generic_allies();
	ent = spawnstruct();
	ent.count = 0;
	
	for(i=0; i<aGenerics.size; i++)
	{
		ent.count++;
		aGenerics[i] thread intro_bunker_generics_monitor(ent, detector);
		aGenerics[i] thread intro_bunker_generics_deathmonitor(ent);
	}
	
	while(ent.count > 0)
	{
		wait 0.05;
	}
	
	//all generic friendlies have left the bunker
	
	flag_set("bunker friendlies clear");
}

intro_bunker_generics_monitor(ent, detector)
{
	//Waiting for generic guy to leave the bunker
	
	self endon ("death");
	
	while(self isTouching(detector))
	{
		wait 0.05;
	}
	
	self notify ("departed bunker");
	
	ent.count--;
}

intro_bunker_generics_deathmonitor(ent)
{
	self endon ("departed bunker");
	self waittill ("death");
	ent.count--;
}

smoke_squad_deploy(waveNumber)
{	
	if (getcvar("start") == "start" && waveNumber == 1)
	{
		wait 10;
	}
	
	if(waveNumber == 1)
	{
		while(!flag("mortars completed"))
		{
			thread smoke_squad_assault("alpha");
			thread smoke_squad_assault("beta");	
			thread smoke_squad_assault("gamma");	
			thread smoke_squad_assault("delta");
			wait 0.05;
		}
		
		level.stopSmokeSquads = true;
		wait 1;
		flag_set("real_threat_ended");
		thread squad_cleanup("axis", "first wave completed");
		flag_wait("first wave completed");	
		level.stopSmokeSquads = false;
	}

	if(waveNumber == 2)
	{
		if (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage")
		{
			wait (level.firstBarrageDuration - level.shelterReachTime - level.barrageGracePeriod + level.smokegrenadetime);
		}
		
		thread artillery_breach("vehiclebreach_west", "vehiclebreach_west_playerclip", "west");
		thread vehicle_deploy("halftrack_spawn", "halftrack_move", "halftrack");
		thread ambientEventStart("combat armored");
	
		while(!flag("second wave completed"))
		{
			thread smoke_squad_assault("alpha");
			thread smoke_squad_assault("beta");	
			thread smoke_squad_assault("gamma");	
			thread smoke_squad_assault("delta");
			thread smoke_squad_assault("epsilon");
			thread smoke_squad_assault("zeta");	
			wait 5;
		}
		
		level.stopSmokeSquads = true;
		wait 1;
		flag_set("real_threat_ended");
		thread squad_cleanup("axis", "second wave eliminated");
		flag_wait("second wave eliminated");
		level.stopSmokeSquads = false;
	}
	
	if(waveNumber == 3)
	{
		if (getcvar("start") != "thirdwave" && getcvar("start") != "rescue" )
		{
			wait (level.firstBarrageDuration - level.shelterReachTime - level.barrageGracePeriod + level.smokegrenadetime);
		}
		
		if(getcvar("start") != "rescue")
			thread artillery_breach("vehiclebreach_north", "vehiclebreach_north_playerclip", "north");
		
		thread vehicle_deploy("tank_tiger_spawn", "tank_tiger_move", "tank");
	
		thread ambientEventStart("combat armored");
	
		thread smoke_deploy_finalwave();
		
		flag_wait("planes bombing");
		
		level.stopSmokeSquads = true;
		wait 1;	
		thread squad_cleanup("axis", "third_wave_eliminated");
		flag_wait("third_wave_eliminated");
		level.stopSmokeSquads = false;
		
		return;
	}
	
	thread artillery_barrage_control();
}

smoke_deploy_finalwave()
{
	level endon ("planes bombing");
	while(1)
	{
		thread smoke_squad_assault("alpha");
		thread smoke_squad_assault("beta");	
		thread smoke_squad_assault("gamma");	
		thread smoke_squad_assault("delta");
		thread smoke_squad_assault("epsilon");
		thread smoke_squad_assault("zeta");	
		thread smoke_squad_assault("eta");
		wait 6;
	}
}

artillery_barrage_sfx()
{
	//play distant artillery firing sounds in large quantities, tremble the earth
	
	speaker1 = getent("distant_barrage_speaker1", "targetname");
	speaker2 = getent("distant_barrage_speaker2", "targetname");
	speaker3 = getent("distant_barrage_speaker3", "targetname");
	
	thread maps\_utility::playSoundinSpace("distant_artillery_barrage1", speaker1.origin);
	//iprintlnbold("Faraway artillery firing SFX 1");
	earthquake(0.15, 4.5, level.player.origin, 1000);
	wait 3;
	thread maps\_utility::playSoundinSpace("distant_artillery_barrage2", speaker1.origin);
	//iprintlnbold("Faraway artillery firing SFX 2");
	earthquake(0.15, 4.5, level.player.origin, 1000);
	wait 3;
	thread maps\_utility::playSoundinSpace("distant_artillery_barrage3", speaker1.origin);
	//iprintlnbold("Faraway artillery firing SFX 3");
	earthquake(0.15, 4.5, level.player.origin, 1000);
}

artillery_barrage_control()
{
	flag_clear("shockable artillery");
	
	if(getcvar("start") == "start" || getcvar("start") == "mortars")
		flag_wait("first wave completed");
	
	//When the last enemy in the first attack dies, pause for a bit
	
	wait 6;
	
	level notify ("stop_friendly_areas");
	
	//DIALOGUE: Friendlies shout stuff about gathering weapons and ammo
	if(!flag("first artillery barrage starts") && (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage"))
	{
		thread shoutingBeforeBarrage("firstbarrage");
	}
	else
	{
		thread shoutingBeforeBarrage("secondbarrage");
		wait 3.4;
		flag_set("start timer");
	}
	
	wait level.preBarrageTime;
	level notify ("stop_dialogue_atmosphere");
	
	thread artillery_barrage_sfx();
	
	wait 2;
	
	//Friendlies head for shelters
	
	aGenerics = gather_generic_allies();	
	aShelters = getnodearray("shelter_node", "targetname");
	
	assertEX((aShelters.size >= aGenerics.size), "Not enough shelter nodes.");
		
	for(i=0; i<aGenerics.size; i++)
	{
		aGenerics[i].goalradius = 8;
		aGenerics[i] setgoalnode (aShelters[i]);
		aGenerics[i] thread friendly_barrage_cower();
		
		if(i % 2 == 0)
		{
			aGenerics[i] notify ("stop magic bullet shield");
		}
	}
	
	thread ambientEventStart("barrage");
	
	if(!flag("first artillery barrage starts") && (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage"))
	{
		flag_set("first artillery barrage starts");
	}
	else
	{
		flag_set("second artillery barrage starts");
	}
	
	//++++DIALOGUE here, randomized order, two phases with different lines, everyone starts freaking out, we gotta run!!! Artillery bombardment!!! 
	
	if(!flag("first artillery barrage starts") && (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage"))
	{
		thread shoutingBarrageWarning("firstbarrage");
		if(isalive(level.braeburn))
		{
			thread artillery_braeburn_warning("taylortakecover");
		}
	}
	else
	if(getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage" || getcvar("start") == "secondwave" || getcvar("start") == "secondbarrage")
	{
		thread shoutingBarrageWarning("secondbarrage");
		if(isalive(level.braeburn))
		{
			thread artillery_braeburn_warning("notgonnalast");
		}
	}
	
	setExpFog( 0.00075, .4, .4, .444, level.firstBarrageDuration );
	
	//player has level.shelterReachTime to get away
	//at halftime, player cannot be killed outright, but loses 50% health and goes into extended shellshock if nicked
	
	thread artillery_barrage_impacts();
	thread artillery_fov_squibs();
	thread artillery_safezone_check();
	
	if(!flag("second artillery barrage starts") && (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage"))
	{
		wait 6;
		flag_set("shockable artillery");
	}
	
	wait (level.shelterReachTime*0.5);
	
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i] thread artillery_friendlykill();
	}
	
	wait (level.shelterReachTime*0.5);
	
	if(!level.onetimeshout)
	{
		//"Stay in your foxhole!!! It's ain't much, but it sure beats gettin' your head blown off!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_stayshelter1");
		level.onetimeshout = true;
	}
	
	wait 5;
	
	flag_set("player vulnerable");
	
	//"Wait for the barrage to lift!!! Hold your cover!!!!"
	thread dialogue_nearby_friendly_queue("hill400_defend_stayshelter2");
	
	if(!flag("second artillery barrage starts") && (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage" || getcvar("start") == "secondwave"))
	{
		thread artillery_phase_completion(2, level.firstBarrageDuration, "second_wave_starts", level.secondWaveDuration);
		thread ambientEventStart("combat infantry");
		thread player_deathsquad();
		flag_clear("real_threat_ended");
	}		
	else
	{
		thread artillery_phase_completion(3, level.firstBarrageDuration, "third_wave_starts", (level.stopwatch * 60 - level.planeDelay - 60));
		thread ambientEventStart("combat infantry");
		thread player_deathsquad();
		flag_clear("real_threat_ended");
	}
}

artillery_friendlykill()
{
	level endon ("second_wave_starts");
	level endon ("third_wave_starts");
	self endon ("death");
	
	aShelters = getentarray("shelter_volume", "targetname");
	
	//Test for exposure repeatedly in case AI is just passing thru safezone instead of sitting tight
	
	for(j=0; j<2; j++)
	{
		wait randomfloatrange(1, 3);

		self.reachedSafeArea = false;
		
		for(i=0; i<aShelters.size; i++)
		{
			if(self isTouching(aShelters[i]))
			{
				self.reachedSafeArea = true;
				break;
			}
		}
	}
	
	if(!self.reachedSafeArea)
	{
		thread maps\_utility::playSoundinSpace("mortar_explosion", self.origin);
		playfx(level.mortar, self.origin);
		radiusDamage(self.origin, 32, self.health, self.health);
	}
}

artillery_braeburn_warning(soundalias)
{
	wait randomfloatrange(5, 8);
	level.braeburn dialogue_thread(soundalias);
}

artillery_phase_completion(waveNumber, duration, nextChapter, nextSectionDuration)
{
	switch(level.gameSkill)
	{
		case 0:
			level.smokeSquadAccRifle = 0.3;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.05;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.2;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.1;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.2;			//baseAccuracy for enemies from death squads
			if(!flag("second artillery barrage starts"))
			{
				level.replenishDelay = 18;		//delay before a new smoke squad can respawn
			}
			else
			{
				level.replenishDelay = 14;		//delay before a new smoke squad can respawn
			}
			break;
		case 1:
			level.smokeSquadAccRifle = 0.35;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.28;			//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.3;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.28;		//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.28;			//baseAccuracy for enemies from death squads
			if(!flag("second artillery barrage starts"))
			{
				level.replenishDelay = 16;		//delay before a new smoke squad can respawn
			}
			else
			{
				level.replenishDelay = 14;		//delay before a new smoke squad can respawn
			}
			break;
		case 2:
			level.smokeSquadAccRifle = 0.4;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.3;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.3;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.3;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.3;			//baseAccuracy for enemies from death squads
			if(!flag("second artillery barrage starts"))
			{
				level.replenishDelay = 15;		//delay before a new smoke squad can respawn
			}
			else
			{
				level.replenishDelay = 12;		//delay before a new smoke squad can respawn
			}
			break;
		case 3:
			level.smokeSquadAccRifle = 0.25;		//baseAccuracy for enemies from smoke squads bolt-action rifle
			level.smokeSquadAccSmg = 0.1;		//baseAccuracy for enemies from smoke squads smg
			level.smokeSquadAccSemiauto = 0.2;	//baseAccuracy for enemies from smoke squads semi-auto
			level.smokeSquadAccAssault = 0.1;	//baseAccuracy for enemies from smoke squads assault rifle
			level.deathsquadAcc = 0.1;			//baseAccuracy for enemies from death squads
			if(!flag("second artillery barrage starts"))
			{
				level.replenishDelay = 10;		//delay before a new smoke squad can respawn
			}
			else
			{
				level.replenishDelay = 8;		//delay before a new smoke squad can respawn
			}
			break;
	}
		
	thread friendly_reinforcements();
	thread smoke_squad_deploy(waveNumber);
	
	wait (duration - level.shelterReachTime - level.barrageGracePeriod);
		
	thread shoutingThruSmoke(waveNumber);	
		
	level notify ("stopbarrage");
	flag_clear("player vulnerable");
	
	flag_set(nextChapter);
	
	assertEX(isdefined(nextSectionDuration), "Specify a duration over which the smoke clears after a barrage.");
	
	level.friendlyAccuracy = level.normalAccuracy;		//baseAccuracy for friendlies is lowered after mortarteams are done
	
	wait 2;
	thread friendly_stats_boost();
	thread friendlyAreaStart();
	
	softwait = 1;
	wait softwait;
	
	aAllies = getaiarray("allies");
	thread friendly_shields_down(aAllies);
	
	fogFadeTime = nextSectionDuration - softwait;
	
	setExpFog( 0.00002, .4, .4, .444, fogFadeTime);
}

artillery_barrage_impacts()
{	
	level endon ("stopbarrage");
	
	i = 0;	
	playerShocked = false;
	detectHit = undefined;
	impactpoint = undefined;
	aHits = getentarray("artillery_impactpoint", "targetname");
	aHits = array_randomize(aHits);		
	aGuys = gather_generic_allies();
	
	//early impacts are set to intentionally miss the player and all but 10% of the friendlies for X seconds
	
	doomedGuyCount = int((aGuys.size * 0.1) + 0.5);	//find 10% of the generic guys and round up
	if(doomedGuyCount >= 1)
	{
		for(i=0; i<doomedGuyCount; i++)	
		{
			aGuys = maps\_utility::array_remove(aGuys, aGuys[i]);
		}
	}
	
	n = 0;
	
	while(1)
	{	
		if(!flag("shockable artillery"))
		{
			for(i=n; i<aHits.size; i++)
			{
				detectHit = aHits[i] shell_impact_safedist_check(aGuys, level.safeartydist);
				if(detectHit == "success")
				{
					impactpoint = aHits[i];
					break;
				}	
			}
			
			i++;
			
			if(detectHit == "failed")
			{
				wait 0.05;
				continue;
			}
		}
		else
		{
			i = n;
			
			impactpoint = aHits[i];
			i++;
			
			//Player should only get shocked once during these bombardments at most
				
			dist = distance(level.player.origin, impactpoint.origin);
			if(playerShocked == false && level.playerSafe == false)
			{
				if(dist <= level.safeartydist)
				{
					thread artillery_player_shock_check(impactpoint);
					playerShocked = true;
				}
			}
		}
		
		thread shell_impact(impactpoint, level.artyhit, "fast_artillery_round", "artillery_impact", "smoke", 0.4, 5, 3500);
		wait randomfloatrange(level.artyMinTime, level.artyMaxTime);
		
		//Resume loop in aHits from where we left off instead of starting at 0
		
		if(i == aHits.size)
			n = 0;
		else
			n = i;
	}
}

artillery_fov_squibs()
{
	level endon ("stopbarrage");
	
	wait 3;
	
	aHits = getentarray("artillery_impactpoint", "targetname");
	aHits = array_randomize(aHits);		
	
	while(1)
	{
		for(i=0; i<aHits.size; i++)
		{	
			if (aHits[i] maps\_mortar::duhoc_style_mortar_checkPlayerFOV())
			{	
				thread shell_impact(aHits[i], level.artyhit, "fast_artillery_round", "artillery_impact", undefined, 0.4, 5, 3500);
				wait randomfloatrange(0.5, 1.5);
			}
			
			wait 0.1;
		}	
		
		aHits = array_randomize(aHits);		
	}
}

artillery_safezone_check()
{
	//determines if player is in a shelter
	
	level endon ("stopbarrage");
	
	n = 0;
	i = 0;
	level.playerSafe = false;
	aShelters = getentarray("shelter_volume", "targetname");
	
	while(1)
	{
		for(i=0; i<aShelters.size; i++)
		{
			if(!level.player isTouching(aShelters[i]) && !level.playerSafe)
			{
				level.playerSafe = false;
				wait 0.05;
				continue;
			}
			
			while(level.player isTouching(aShelters[i]))
			{
				level.playerSafe = true;
				n = 0;
				wait 0.05;
			}
			
			level.playerSafe = false;
			break;
		}
		
		if(flag("player vulnerable"))
		{		
			if(!level.playerSafe)
			{
				n++;
				if(n == 1)
				{
					wait level.barrageGracePeriod; 
					continue;
				}
				else
				{
					playfx(level.artyhit, level.player.origin);
					thread playSoundinSpace("mortar_explosion", level.player.origin);
					killplayer();
				}
			}
		}
		
		wait 0.05;
	}
}

artillery_player_shock_check(impactpoint)
{
	//shocks player at halftime to forced death period
	
	level endon ("stopbarrage");
	
	impactpoint waittill ("exploded");
	if(!level.playerSafe)
	{
		thread shockPlayer(level.shockTimeLong);
	}
}

artillery_breach(obstacleName, clipName, breachName)
{
	//prior to 2nd wave attack, west barricades are blown away, prior to 3rd, north barricades
	//vehiclebreach_west/north gets destroyed in the barrage
	//vehiclebreach_west/north_playerclip gets destroyed in the barrage
	//++++custom geometry work needed for before and after scenes
	
	obstacles = getentarray(obstacleName, "targetname");
	playerclip = getent(clipName, "targetname");
	bigBlastPoint = playerclip.origin;
	playerclip delete();
	
	//Open up all perimeter access points to the player
	
	if(level.shelterAccessClip)
	{
		shelterAccessClip = getent("shelterAccessClip", "targetname");
		shelterAccessClip delete();
		level.shelterAccessClip = false;
	}
	
	for(i=0; i<obstacles.size; i++)
	{
		playfx(level.breachfx, obstacles[i].origin);
		thread maps\_utility::playSoundinSpace("mortar_explosion", obstacles[i].origin);
		
		if(level.xenon)
			playRumbleOnPos("artillery_quake", level.player.origin);
		
		wait randomfloat(1, 1);
		radiusDamage(obstacles[i].origin + (0, 0, 64), 512, 100, 25);
		obstacles[i] delete();
	}
	
	thread maps\_utility::playSoundinSpace("hill400_defend_breach", bigBlastPoint);
	earthquake(0.5, 4, level.player.origin, 1000);
	
	assertEX(isdefined(breachName), "Breachname not defined.");
	if(breachName == "west")
	{
		//++++SPAM GUYS IN THIS HOLE IN THE PERIMETER!!!
		wait 1.5;
		//"Penetration on the west flank!!! Get over there and hold that side!!! Go! Go! Go!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_westbreach");
	}
	
	if(breachName == "north")
	{
		wait 1.5;
		//"Perimeter breach on the north side!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_northbreach");
		wait 2.5;
	}
}

desertion_monitor()
{
	level endon ("planes bombing");
	
	exit = getent("exitTrig", "targetname");
	entry = getent("entryTrig", "targetname");
	
	while(1)
	{
		exit waittill ("trigger");
		
		if(!level.playerDeparted)
		{
			level.playerDeparted = true;
			level.canSave = false;
			thread desertion_timer();
			thread desertion_warnings();
			thread shoutingDuringBunkerDanger();
		}
		
		entry waittill ("trigger");
		level notify ("player_returned");
		level.playerDeparted = false;
		level.canSave = true;
	}
}

desertion_timer()
{	
	level endon ("planes bombing");
	level endon ("player_returned");
	level endon ("real_threat_ended");
	
	if(!flag("real_threat_ended"))
	{
		wait (level.desertionTimeLimit - level.desertionSmokeStartTime);
		
		smokePoint = getent("bunker_danger_smoke", "targetname");
		playfx(level.smokegrenade, smokePoint.origin);
		
		wait level.desertionSmokeStartTime;
		
		thread desertion_failure_bunker();
	}
}

desertion_warnings()
{
	level endon ("planes bombing");
	level endon ("player_returned");
	level endon ("real_threat_ended");
	
	if(!flag("real_threat_ended"))
	{
		wait level.desertionTimeLimit * 0.30;
		
		//"They're all over the hill and movin' in!!! Corporal Taylor! Get back here!"
		thread dialogue_nearby_friendly_queue("hill400_defend_tether1");
		wait level.desertionTimeLimit * 0.20;
		
		//"We're totally outnumbered!! Taylor! Stick close to the bunker!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_tether2");
		wait level.desertionTimeLimit * 0.20;
		
		//"The bunker's under attack!! Somebody find Corporal Taylor and get him up here!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_tether3");
		wait level.desertionTimeLimit * 0.15;
		
		//"We're gonna lose the bunker!! Where's Corporal Taylor!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_tether4");
		wait level.desertionTimeLimit * 0.10;
		
		//"They're about to take the bunker!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_tether5");
	}
}

desertion_failure_bunker()
{
	if(!flag("real_threat_ended"))
	{
		level notify ("mission_failed");
		
		speaker = getent("counterattack_speaker", "targetname");
		
		//"They're in the bunker - AAAA!!!!"
		playSoundinSpace("hill400_defend_defeated1", speaker.origin);
		//wait 0.3;
		
		/*
		//"The Krauts have us beat!!! They've retaken the hill! We gotta fall back!!!"
		playSoundinSpace("hill400_defend_defeated2", speaker.origin);
		wait 0.4;
		
		//"The Germans have taken the bunker!! They're all over the hill! We can't win this one!!"
		playSoundinSpace("hill400_defend_defeated3", speaker.origin);
		wait 0.5;
		*/
		setCvar("ui_deadquote", &"HILL400_DEFEND_THE_GERMANS_TOOK_THE");
		maps\_utility::missionFailedWrapper();
	}
}

desertion_outofbounds()
{	
	//outofbounds trigger, randomly chooses one of two options				
	//if all the enemies are dead and it's victory time, just end the mission early
	
	desertionTrig = getent("desertion_trigger", "targetname");
	desertionTrig waittill ("trigger");
	
	if(!flag("third_wave_eliminated"))
	{
		option = randomint(2);
		
		if(option == 0)
		{
			//player is killed by succession of 'stray bullets' from an 'enemy' (not just one hit)
			
			for(i=0; i<5; i++)
			{
				j = randomint(2);
				if(j == 0)
				{
					thread playsoundinspace("bullet_small_flesh", level.player.origin);
				}
					
				if(j == 1)
				{
					thread playsoundinspace("bullet_large_flesh", level.player.origin);
				}
					
				level.player doDamage (level.player.health*0.15, level.player.origin);
				
				k = randomint(3);
				if(k == 0)
					wait randomfloat(0.1);	
				if(k == 1)
					wait randomfloat(0.13);	//rate of fire of an MP44
				if(k == 2)
					wait randomfloat(0.18);	
			}
			
			killplayer();
		}
		else
		{
			//player is killed by 'lucky' mortar hit
			
			playfx(level.artyhit, level.player.origin);
			thread playSoundinSpace("mortar_explosion", level.player.origin);
			killplayer();
		}
	}
	else
	{	
		//objective_state(6, "done");
		flag_set("victory");
		maps\_endmission::nextmission();
	}
}

objective_mortars()
{
	flag_wait("bunkersealed");
	
	while(level.mortarTeamsEliminated < level.mortarTeamsRequired)
	{
		wait 2;
	}
	
	flag_set("mortars completed");
}

objective_mortarteam_hintprints()
{
	flag_wait("bunkersealed");
	
	wait level.mortarTeamHintDelay;
	
	while(level.mortarTeamsEliminated < level.mortarHintThreshold)
	{	
		//Hint: Watch for smoke trails against the sky to locate the mortar teams.
		add_hudelm_hint(level.strings["mortarteam_hint1"], "erase_mortarteam_hint1");	
		wait 12;
		level notify ("erase_mortarteam_hint1");
		
		wait 2;
		
		//Hint: Move along the barbed wire until you have a clear shot on a mortar team.
		add_hudelm_hint(level.strings["mortarteam_hint2"], "erase_mortarteam_hint2");	
		wait 8;
		level notify ("erase_mortarteam_hint2");
		
		wait level.mortarHintInterval;
	}
	
}

objectives()
{
	/*
		1. Hold Hill 400 until relieved by friendly forces. (persistent throughout)
		2. Snipe the enemy mortar teams.
		3. Stop the Germans from breaching and storming the bunker aid station.
		4. Take shelter from the artillery barrage. (activates when #2 is done)
		5. Clear out any remaining opposition on the hill.	
		6. Head back down the hill to report in at the HQ in Bergstein.
	*/
	
	bunkerPoint = getent("bunker_objective", "targetname");
	objective_add(1, "active", &"HILL400_DEFEND_HOLD_HILL_400_UNTIL_RELIEVED", bunkerPoint.origin);
	objective_current(1);
	
	if (getcvar("start") == "start")
	{
		flag_wait("mortar teams approaching");
	}
	
	objective_add(2, "active", &"HILL400_DEFEND_SNIPE_THE_ENEMY_MORTAR", bunkerPoint.origin);
	objective_current(2);
	
	thread objective_mortarteam_hintprints();
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars")
	{
		flag_wait("mortars completed");
	}
	
	level notify ("stop_death_squads");
	
	thread autoSaveByName("mortarsdone"); 
	
	objective_state(2, "done");
	objective_current(1);
	
	if (getcvar ("start") == "start" || getcvar("start") == "mortars")
	{
		thread forceParticipation("first wave completed");
		flag_wait("first wave completed");
		level notify ("stop_magic_grenades");
	}
	
	thread ambientEventStart("exterior");
	
	thread autoSaveByName("firstwavedone"); 
	
	if (getcvar ("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage")
	{
		flag_wait("first artillery barrage starts");
		objective_shelters();
		objective_current(3);
		flag_wait("second_wave_starts");
		thread autoSaveByName("firstbarragedone"); 
	}
	
	if (getcvar("start") != "start" || getcvar("start") != "mortars" || getcvar ("start") != "firstbarrage")
	{
		objective_add(3, "active", &"HILL400_DEFEND_TAKE_SHELTER_FROM_THE", bunkerPoint.origin);
		objective_state(3, "done");
	}
	
	if (getcvar ("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage" || getcvar("start") == "secondwave")
	{
		objective_state(3, "done");
		objective_add(4, "active", &"HILL400_DEFEND_STOP_THE_GERMANS_FROM", bunkerPoint.origin);
		objective_current(4);
		
		//setsavedcvar("cg_hudCompassMaxRange", "100000");
		
		flag_set("second wave started");
		thread forceParticipation("second wave eliminated");
		thread objective_wavetimer(level.secondWaveDuration, "second wave completed");
		thread autosave_attackwave(level.secondWaveDuration);
		thread magic_grenades();
		
		flag_wait("second wave completed");
		thread autoSaveByName("secondwavecompleted"); 
		flag_wait("second wave eliminated");
		level notify ("stop_magic_grenades");
		thread autoSaveByName("secondwavedone"); 
		
		thread ambientEventStart("exterior");
	}
	
	if (getcvar ("start") != "thirdwave" && getcvar("start") != "rescue" && getcvar("start") != "planes")
	{
		flag_wait("second artillery barrage starts");
		//setsavedcvar("cg_hudCompassMaxRange", level.baseCompassRange);
		objective_shelters();
		objective_current(3);
		flag_wait("third_wave_starts");
		thread autoSaveByName("secondbarragedone"); 
		thread forceParticipation("third_wave_eliminated");
		thread autosave_attackwave(level.thirdWaveDuration);
		thread magic_grenades();
	}
	
	if (getcvar("start") != "start" || getcvar("start") != "mortars" || getcvar ("start") != "firstbarrage" || getcvar("start") != "secondbarrage")
	{
		objective_add(3, "active", &"HILL400_DEFEND_TAKE_SHELTER_FROM_THE", bunkerPoint.origin);
		objective_state(3, "done");
	}
	
	if (getcvar("start") != "planes")
	{
		objective_state(3, "done");
		objective_add(4, "active", &"HILL400_DEFEND_STOP_THE_GERMANS_FROM", bunkerPoint.origin);
		objective_current(4);
		//setsavedcvar("cg_hudCompassMaxRange", "100000");
		flag_wait("planes arrive");
		thread autoSaveByName("attackvectorlockedin"); 
		flag_wait("planes bombing");
		level notify ("stop_magic_grenades");
		battleChatterOff("allies");
		battleChatterOff("axis");
	}
	
	if (getcvar("start") == "planes")
	{
		objective_add(4, "active", &"HILL400_DEFEND_STOP_THE_GERMANS_FROM", bunkerPoint.origin);
		//setsavedcvar("cg_hudCompassMaxRange", "100000");
	}
	
	objective_state(1, "done");
	objective_state(4, "done");
	
	objective_add(5, "active", &"HILL400_DEFEND_CLEAR_OUT_ANY_REMAINING", bunkerPoint.origin);
	objective_current(5);
	
	flag_wait("third_wave_eliminated");
	
	//++++put the origin in Bergstein
	bergsteinPoint = getent("bergsteinPoint", "targetname");
	
	thread ambientEventStart("exterior");
	
	objective_state(5, "done");
	//objective_add(6, "active", &"HILL400_DEFEND_HEAD_BACK_DOWN_THE_HILL", bergsteinPoint.origin);
	//objective_current(6);
	
	thread epilogue();
	
	//Tank attacks on separate thread, only one tank active at a time
	//Tanks are optional and destroyed by planes at the end 
}

objective_shelters()
{
	aShelters = getentarray("objective_point_shelter", "targetname");
	for(i=0; i<aShelters.size; i++)
	{
		if(i==0)
			objective_add(3, "active", &"HILL400_DEFEND_TAKE_SHELTER_FROM_THE", aShelters[i].origin);
		else
			objective_additionalposition(3, i, aShelters[i].origin);
	}
}

objective_wavetimer(duration, notifyFlag)
{
	wait (duration - 3);
	level notify ("stop_death_squads");
	wait 3;
	
	flag_set(notifyFlag);
}

objective_stopwatch()
{
	if (getcvar("start") != "thirdwave" && getcvar("start") != "rescue")
	{	
		flag_wait("start timer");
	}

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
	level.timer.label = &"HILL400_DEFEND_REINFORCEMENTS";
	level.timer setTimer(level.stopwatch*60);

	thread music_timer();

	wait ((level.stopwatch * 60) - level.planeDelay);
	flag_set("planes arrive");	//Bring in the Allied aircraft and activate the mop up procedure
	
	wait level.planeDelay - 3;
	level notify ("stop_death_squads");
	wait 3;

	level.timer destroy();	
}

victory()
{
	//planes, mop up, and epilogue dialogue are complete, and player is on the way down the hill
	
	flag_wait("third_wave_eliminated");
	flag_wait("planes arrive");	
	flag_wait("epilogue_done");
	//flag_wait("victory");
	wait 10.5;
	
	maps\_endmission::nextmission();
}

retreat_init()
{
	//++++Enemies must start running away when the bombing starts
	
	flag_wait("on_our_side");
	
	wait 2;
	
	aPositions = getnodearray("axisRetreatPoint", "targetname");
	aAxis = getaiarray("axis");
	for(i=0; i<aAxis.size; i++)
	{
		aAxis[i] thread retreat(aPositions);
	}
	
	//"They're falling back!!!"
	thread dialogue_nearby_friendly_queue("hill400_defend_fallingback1");
	wait 3;
	
	flag_set("falling_back");
	
	//"Come on, take 'em out!!!"
	//thread dialogue_nearby_friendly_queue("hill400_defend_fallingback2");
}

retreat(aPositions)
{
	//give the AI a short random time and then magic bullet the AI, definitely if they reach their retreat goalnode
	//should still fight a bit on their way out, not just run completely
		
	self endon ("death");
	
	playerDist = undefined;
	aiDist = undefined;
	farDist = 0;
	retreatPos = undefined;
	
	for(i=0; i<aPositions.size; i++)
	{
		playerDist = distance(level.player.origin, aPositions[i].origin);
		aiDist = distance(self.origin, aPositions[i].origin);
		
		if(playerDist >= aiDist && playerDist >= farDist)
		{
			farDist = playerDist;
			retreatPos = aPositions[i];
		}
		else
		{
			wait 0.05;
		}
	}
	
	self setgoalnode(retreatPos);
	self.pathenemyfightdist = 128;
	self.pathenemylookahead = 640;
	self.goalradius = 800;
	self thread retreat_suicide();
	
	while(self.goalradius > 64)
	{
		self.goalradius = self.goalradius * 0.75;
		wait 0.5;
	}
	self.goalradius = 8;
	wait randomfloatrange(10, 20);
	self doDamage (self.health, self.origin);
}

retreat_suicide()
{
	self endon ("death");
	self waittill ("goal");
	self doDamage (self.health, self.origin);
}

epilogue()
{
	//++++Randall and McCloskey show up
	//++++DIALOGUE ON ACTUAL GUYS
	
	bunkerTrig = getent("hidingPlace", "script_noteworthy");
	
	while(level.player istouching(bunkerTrig))
	{
		wait 0.1;
	}
	
	bunkerdoor = getent("bunkerdoor", "targetname");
	bunkerdoorClip = getent("bunkerdoor_clip", "targetname");
	
	bunkerdoor hide();
	bunkerdoorClip hide();
	bunkerdoorClip notsolid();
	bunkerdoorClip connectpaths();
	
	thread atmosphere_wounded_characters();
	
	//+++door opening sfx
	
	randallSpawner = getent("randall_endspawner", "targetname");
	mccloskeySpawner = getent("mccloskey_endspawner", "targetname");
	
	while(1)
	{
		level.randall = randallSpawner stalingradSpawn();			
		if(spawn_failed(level.randall))
		{
			continue;
		}
		level.randall.animname = "randall";
		break;
	}
	
	while(1)
	{
		level.mccloskey = mccloskeySpawner stalingradSpawn();			
		if(spawn_failed(level.mccloskey))
		{
			continue;
		}
		level.mccloskey.animname = "mccloskey";
		break;
	}
	
	level.randall.goalradius = 8;
	level.mccloskey.goalradius = 8;
	
	randallNode = getnode("randall_epilogue_node", "targetname");
	mccloskeyNode = getnode("mccloskey_epilogue_node", "targetname");
	
	level.randall setgoalnode(randallNode);
	level.mccloskey setgoalnode(mccloskeyNode);
	level.randall waittill ("goal");
	level.mccloskey waittill ("goal");
	
	//"McCloskey: Who are those guys, Sarge?"
	level.mccloskey dialogue_thread("hill400_defend_mcc_whoareguys");
	wait 0.3;
	//"Randall: Guardian angels, McCloskey. P-51 Mustangs, and not a blessed moment too soon...Great job guys, we did it."
	//level.randall dialogue_thread("hill400_defend_rnd_guardianangels");
	//level.randall Dialogue_Thread("hill400_defend_rnd_guardianangels", level.randall);
	
	level.randall.animname = "randall";
	level.randall.anim_node = randallNode;
	randallNode anim_reach_solo (level.randall, "hill400_defend_rnd_guardianangels_anim");
	
	randallNode thread anim_single_solo (level.randall, "hill400_defend_rnd_guardianangels_anim");
	level.randall waittillmatch ("single anim", "dialog");
	level.randall anim_single_solo (level.randall, "hill400_defend_rnd_guardianangels");
	
	level.randall.walkdist = 9999;
	level.randall.walk_noncombatanim = %patrolwalk_tired;
	randallWalknode = getnode("randall_epilogue_walknode", "targetname");
	level.randall setgoalnode (randallWalkNode);
	level.randall.anim_node = randallWalknode;
	//level.randall waittill ("goal");
	//level.randall allowedstances ("crouch");
	//level.randall.anim_node thread anim_loop_solo(level.randall, "final_scene_idle");
	
	flag_set("epilogue_done");
}

ambient_track()
{
	if (getcvar("start") == "start")
	{
		flag_wait("mortar teams approaching");
	}
	
	level notify ("action_moment");
	
	if (getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage")
	{
		flag_wait("first artillery barrage starts");
		level notify ("barrage_ambient");
		//iprintlnbold("Very Heavy Barrage Ambient SFX Track");
	}
}


//=======================================================================================================================================================//
//=======================================================================================================================================================//

//**************************************//
//		INFANTRY COMBAT UTILITIES		//
//**************************************//

smoke_squad_assault(location)
{
	//Generates a smoke screen from which AI are spawned and attack on the desired nav plan
	//Don't use this if the player can physically reach the spawn location
	
	//Use a script_origin with the following information:
	
		//targetname = smoke_squad
		//script_squadname = "alpha, etc."
		//target = some spawners
		//target = some nodes as well
	
	if(!level.smokeSquadActive[location])
	{	
		assertEX(isdefined(location), "Must specify a location when calling smoke_squad_assault");
		
		level.smokeSquadActive[location] = true;	//spawnlock
		
		//iprintlnbold("Deploying " + location + " smoke squad!");
		
		smokeSquad = undefined;
		aSquads = getentarray("smoke_squad", "targetname");
		for(i=0; i<aSquads.size; i++)
		{
			if(!isdefined(aSquads[i].script_squadname))
				continue;
			if(aSquads[i].script_squadname != location)
				continue;
			smokeSquad = aSquads[i];		
			break;
		}
		
		//Pick a starting node
		
		startNodes = getnodearray(smokeSquad.target, "targetname");
		if(startNodes.size == 1)
		{
			launchpoint = getnode(smokeSquad.target, "targetname");
		}
		else
		{
			launchpoint = startNodes[randomint(startNodes.size)];
		}
		
		//Deploy smoke if smoke is no longer active in sufficient density to conceal the spawn
		
		if(!level.smokeActive[location] && !level.stopSmokeSquads)
		{
			playfx(level.smokegrenade, smokeSquad.origin);
			
			wait level.smokegrenadetime;	//time it takes for smoke to fully conceal the spawners
			level.smokeActive[location] = true;
			thread smoke_timeout(location);
		}
		
		//Get the spawners for this smoke squad and spawn in smoke, and deploy on nav plan
		
		aSpawners = [];
		aSpawngroup = getspawnerarray();
		
		for(i=0; i<aSpawngroup.size; i++)
		{
			if(!isdefined(aSpawngroup[i].targetname))
				continue;
			if(aSpawngroup[i].targetname != smokeSquad.target)
				continue;
			aSpawners[aSpawners.size] = aSpawngroup[i];
		}
		
		ent = spawnstruct();
		ent.count = 0;
		
		for(i=0; i<aSpawners.size; i++)
		{
			aAxisPop = [];
			aAlliesPop = [];
			aAxisPop = getaiarray("axis");
			aAlliesPop = getaiarray("allies");
			totalPop = aAxisPop.size + aAlliesPop.size;
			
			if(totalPop > level.allowedMaxPop)
			{
				wait 0.05;
				continue;
			}
			
			aSpawners[i].count++;
			
			if(!level.stopSmokeSquads)
			{
				nSoldier = aSpawners[i] stalingradSpawn();
			
				if(spawn_failed(nSoldier))
				{
					continue;
				}
				
				//Stats 
						
				//nSoldier.suppressionwait = 0;
				nSoldier.pathenemyfightdist = 1024;
				nSoldier.pathenemylookahead = 1024;
				//nSoldier.maxdist = 1280;
				
				if(nSoldier.weapon == "kar98k")
				{
					nSoldier.baseAccuracy = level.smokeSquadAccRifle;	
				}
				else
				if(nSoldier.weapon == "mp40")
				{
					nSoldier.baseAccuracy = level.smokeSquadAccSmg;					
				}
				else
				if(nSoldier.weapon == "g43" || nSoldier.weapon == "g43_sniper")
				{
					nSoldier.baseAccuracy = level.smokeSquadAccSemiauto;					
				}
				else
				if(nSoldier.weapon == "mp44")
				{
					nSoldier.baseAccuracy = level.smokeSquadAccAssault;					
				}
				else
				{
					nSoldier.baseAccuracy = level.smokeSquadAcc;					
				}
				
				//nSoldier.health = 1;
				
				nSoldier thread smoke_squad_nav(launchpoint);
				nSoldier thread smoke_squad_status_deathmonitor(ent);
				nSoldier thread smoke_squad_suicide_monitor();
				nSoldier thread smoke_squad_playerattack();
				nSoldier thread forceDeathmonitor();
			}
			
			wait 0.05;
		}
		
		if(ent.count > 0)
		{
			thread smoke_squad_status(ent, location);
		}
	}
}

smoke_timeout_init()
{
	//Used with any desired condition to lock/unlock the retriggering of smokescreen fx on smoke_squads
	
	level.smokeActive["alpha"] = false;
 	level.smokeActive["beta"] = false;
 	level.smokeActive["gamma"] = false;
 	level.smokeActive["delta"] = false;
 	level.smokeActive["epsilon"] = false;
 	level.smokeActive["zeta"] = false;
 	level.smokeActive["eta"] = false;
}

smoke_timeout(location)
{
	wait level.smokeDuration;
	level.smokeActive[location] = false;
}

smoke_squad_playerattack()
{
	self endon ("death");
	self endon ("on_our_side");
	
	wait level.patternHoldTime;
	
	if(!flag("on_our_side"))
	{
		self notify ("attack_the_player");
		self.goalradius = 2000;
		self.pathenemyfightdist = 1024;
		self.pathenemylookahead = 1024;
		self setgoalentity(level.player);
	
		while(self.goalradius > 128)
		{
			wait 3;
			
			if((self.goalradius - 200) > 0)
			{
				self.goalradius = self.goalradius - 200;
			}
			else
			{
				break;
			}
		}
	}
}

smoke_squad_nav(node)
{
	//Sends to next node in the nav chain
	
	level endon ("planes bombing");
	self endon ("death");
	self endon ("attack_the_player");
	
	while(!flag("planes bombing"))
	{	
		if(isdefined(node.radius))
		{
			self.goalradius = node.radius;
		}
		else
		{
			self.goalradius = 800;
		}
		
		self setgoalnode(node);
		self waittill ("goal");
		self smoke_squad_delay();
		
		if(!isdefined(node.target))
			break;	//++++ or unleash DOOMSDAY DEVICE

		branches = getnodearray(node.target, "targetname");		
		if(branches.size == 1)
		{
			node = getnode(node.target, "targetname");		
		}
		else
		{
			node = branches[randomint(branches.size)];
		}
	}
}

smoke_squad_delay()
{
	level endon ("planes bombing");
	self endon ("death");
	self endon ("attack_the_player");
	
	//Shrinking goalradius method
	
	while(self.goalradius > level.closurethreshold && !flag("planes bombing"))
	{
		self.goalradius = self.goalradius * level.closurepercent;
		wait level.closuretime + randomfloat(level.closuremod);
	}
}

smoke_squad_status_init()
{
	//Used with any desired condition to lock/unlock the ability to spawn more guys from a smoke_squad
	
	level.smokeSquadActive["alpha"] = false;
 	level.smokeSquadActive["beta"] = false;
 	level.smokeSquadActive["gamma"] = false;
 	level.smokeSquadActive["delta"] = false;
 	level.smokeSquadActive["epsilon"] = false;
 	level.smokeSquadActive["zeta"] = false;
 	level.smokeSquadActive["eta"] = false;
}

smoke_squad_status(ent, location)
{
	//unlocks the smoke_squad spawners when the squad is reduced past some percentage
	
	test = ent.count;
	while(ent.count/test > level.replenishPercent)
	{
		wait 1;
	}
	
	wait level.replenishDelay;	//gap between respawns
	
	level.smokeSquadActive[location] = false;
	
	ent notify ("team ready for more respawns");
	ent = undefined;
}

smoke_squad_status_deathmonitor(ent)
{
	ent endon ("team ready for reinforcements");
	ent.count++;
	self waittill ("death");
	ent.count--;
}

smoke_squad_suicide_monitor()
{
	/*
	smokesquad attack on death timers, dying at random times on the hill well before penetrating the perimeter
		- when player is not touching the bunker interior volume
			- action is real (death on smokesquad enemies is bypassed)
		- when player IS touching the bunker interior volume
			- action goes back to fake (death on smokesquad enemies is reactivated)
	*/
	
	self endon ("death");
	
	wait randomfloatrange(8, 16);
	
	while(1)
	{
		if(level.simulatedBattle)
		{
			wait randomfloatrange(8, 16);
			
			if(!level.simulatedBattle)
				continue;
			
			self doDamage (self.health, self.origin);
			break;
		}
		else
		{
			wait 0.1;
			continue;
		}
	}	
}

//***********************************

player_deathsquad()
{
	//their mission in life is to attack the player
	
	level endon ("stop_death_squads");
	
	flag_wait("bunkersealed");
	
	aDeathSquads = [];
	aDeathSquads = getentarray("constantattack_volume", "targetname");
	
	while(1)
	{
		wait level.deathSquadInterval;
		
		for(i=0; i<aDeathSquads.size; i++)
		{
			if(level.player istouching(aDeathSquads[i]))
				break;
			
			wait 0.05;
		}
		
		aSpawners = [];
		aSpawners = getentarray(aDeathSquads[i].target, "targetname");
		
		for(i=0; i<aSpawners.size; i++)
		{
			if(level.deathSquadPop < level.deathSquadPopLimit)
			{
				aSpawners[i].count++;
				deathSquadGuy = aSpawners[i] doSpawn();			
				if(spawn_failed(deathSquadGuy))
				{
					continue;
				}
				
				level.deathSquadPop++;
				
				deathSquadGuy.baseAccuracy = level.deathsquadAcc;
					
				deathSquadGuy thread player_deathsquad_nav();
				deathSquadGuy thread player_deathsquad_death();
				deathSquadGuy thread forceDeathmonitor();
			}
			
			wait 0.05;
		}
	}
}

player_deathsquad_nav()
{
	self endon ("death");
	
	self setgoalentity(level.player);
	
	self.goalradius = level.deathSquadInitRadius;
	while(self.goalradius > 128)
	{
		//self setgoalpos (level.player.origin);
		self waittill ("goal");
		
		wait level.deathSquadHoldTime;
		
		if((self.goalradius - level.deathSquadRadiusStep) > 0)
		{
			self.goalradius = self.goalradius - level.deathSquadRadiusStep;
		}
	}
}

player_deathsquad_death()
{
	self waittill ("death");
	level.deathSquadPop--;
}

//***********************************

forceDeathmonitor()
{
	self waittill ("death", nAttacker);
	if(isdefined(nAttacker) && nAttacker == level.player)
	{
		level.playerKillCount++;
	}
}

forceParticipation(endonString)
{
	//If the player doesn't kill one enemy every X seconds during the defend objectives
	//This thread lowers the shields on a friendly and sets his health so the enemy eventually overpowers them all
	
	level endon (endonString);
	
	level.playerKillCount = 0;
	
	aAllies = [];
	aAllies	= getaiarray("allies");
	
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].markedfordeath = false;
	}
	
	while(1)
	{
		level.oldPlayerKillCount = level.playerKillCount;
		wait level.playerFightCheckTime;
		
		aCurrentAllies = [];
		aCurrentAllies = getaiarray("allies");
		
		if(level.playerKillCount > level.oldPlayerKillCount)
			continue;
			
		if(aCurrentAllies.size <= level.guaranteedSurvivalPop)
		{
			aCurrentAllies = undefined;
			break;
		}
		
		aAllies = [];
		aAllies	= getaiarray("allies");
			
		if(aAllies.size)
		{
			for(i=0; i<aAllies.size; i++)
			{
				if(isalive(aAllies[i]) && !aAllies[i].markedfordeath)
				{
					aAllies[i] notify ("stop magic bullet shield");
					aAllies[i].health = 250;
					aAllies[i].markedfordeath = true;
					break;
				}
				wait 0.05;
			}
		}		
	}
}

//***********************************

gather_generic_allies(nolookouts)
{
	//Returns only the redshirts
	
	aGenerics = [];
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{	
		if(isdefined(nolookouts))
		{
			if(isdefined(aAllies[i].script_namenumber) && aAllies[i].script_namenumber == "lookout")
				continue;
		}
		
		if(!isdefined(aAllies[i].script_friendname))
		{
			aGenerics[aGenerics.size] = aAllies[i];
			continue;
		}
		
		if(aAllies[i].script_friendname == "Pvt. Braeburn")
		{
			aGenerics[aGenerics.size] = aAllies[i];
			continue;
		}
			
		if(aAllies[i].script_friendname == "Pvt. McCloskey")
			continue;
			
		if(aAllies[i].script_friendname == "Sgt. Randall")
			continue;
			
		if(aAllies[i].script_friendname == "Pvt. Carter")
			continue;
			
		aGenerics[aGenerics.size] = aAllies[i];
	}
	
	return(aGenerics);
}

//***********************************

friendly_reinforcements()
{
	//Just before the end of each artillery barrage, friendly reinforcements are magically spawned inside the huts/bunker
	
	aFriends = gather_generic_allies();
	level.currentPop = aFriends.size;
	
	if(level.currentPop < level.friendlyMaxPop)
	{
		aVolumes = getentarray("shelter_volume", "targetname");
		for(i=0; i<aVolumes.size; i++)
		{
			wait 0.05;
			
			if(level.player isTouching(aVolumes[i]))
				continue;
			
			if(!isdefined(aVolumes[i].target))
				continue;
			
			if(level.currentPop >= level.friendlyMaxPop)
				continue;
			
			spawner = getent(aVolumes[i].target, "targetname");
			spawner.count++;
			
			friendlyGuy = spawner stalingradSpawn();
			if(spawn_failed(friendlyGuy))
			{
				continue;
			}
				
			friendlyGuy thread friendly_reinforcement_deathmonitor();
			friendlyGuy.goalradius = 8;
			level.currentPop++;
		}
	}
}

friendly_reinforcement_deathmonitor()
{
	self waittill ("death");
	level.currentPop--;
}

friendly_barrage_cower()
{
	self endon ("death");
	self waittill ("goal");
	self allowedstances ("crouch");
	level waittill ("stopbarrage");
	self allowedstances ("stand", "crouch", "prone");
}

friendly_stats_boost()
{
	//Sets the Allied redshirts from the bunker to decent initial levels for survival during the real battle
	//Lookouts are normal mortal guys
	
	if (getcvar("start") == "start")
	{
		flag_wait("bunkersealed");
	}
	
	if(!flag("first artillery barrage starts"))
	{
		aGenerics = gather_generic_allies();
	}
	else
	{
		aGenerics = getaiarray("allies");
	}
	
	for(i=0; i<aGenerics.size; i++)
	{
		
		aGenerics[i].goalradius = 8;
		aGenerics[i].pathenemyfightdist = 256;
		aGenerics[i].pathenemylookahead = 8;
		aGenerics[i].baseAccuracy = level.friendlyAccuracy;
		
		//if(isdefined(aGenerics[i].script_namenumber) && aGenerics[i].script_namenumber == "lookout")
			//continue;
		
		aGenerics[i] thread maps\_utility::magic_bullet_shield();
	}
}

friendly_shields_down(aGuys)
{
	//Drops shields on X friendlies above some required 'friendlies must live' amount
	
	surplus = aGuys.size - level.friendlyMinPop;
	
	if(surplus >= 1)
	{
		for(i=0; i<surplus; i++)
		{
			aGuys[i] notify ("stop magic bullet shield");
		}
	}
}

lookout_mortal()
{
	if (getcvar("start") == "start")
	{
		flag_wait("bunkersealed");
	}
	
	aGenerics = gather_generic_allies();
	
	for(i=0; i<aGenerics.size; i++)
	{
		aGenerics[i].goalradius = 8;
	}
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

friendlyAreaStart()
{
	level endon ("stop_friendly_areas");
	
	level.baseDelayTime = 0.5;	//1;
	level.moveGapTime = 0.8;	//2 + randomfloat(3);
	level.instantFollowLimit = 0;		//number of guys that should respond instantly to friendlyArea changes	
	level.friendlyAreaCooldown = 20;	//time in seconds for a friendlyAreaTrigger to become active again

	thread friendlyAreaCollect();
}

friendlyAreaCollect()
{
	level endon ("stop_friendly_areas");
	
	aAreas = getentarray("friendlyArea", "targetname");
	for(i=0; i<aAreas.size; i++)
	{
		aAreas[i] thread friendlyAreaSetup();
	}
}

friendlyAreaSetup()
{
	level endon ("stop_friendly_areas");
	
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

		thread friendlyAreaReplenish(aNavData);
	}
}

friendlyAreaReplenish(aAreaNodes)
{
	level endon ("new orders");
	level endon ("stop_friendly_areas");
	
	aAllies = getaiarray("allies");
	
	//assertEX(aAreaNodes.size >= aAllies.size, "A friendlyArea trigger must target at least as many nodes as there are allies.");
	
	moveDelay = level.baseDelayTime;	//time between guys deploying to their respective nodes, staggered leapfrog style
	
	for(i=0; i<aAllies.size; i++)
	{
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Sgt. Randall")
			continue;
		
		if(isdefined(aAllies[i].script_friendname) && aAllies[i].script_friendname == "Pvt. McCloskey")
			continue;
		
		aAllies[i] thread friendlyAreaNav(aAreaNodes[i], moveDelay);
		
		if(i>level.instantFollowLimit - 1)
		{
			//level.instantFollowLimit number of friendlies will respond instantly instead of waiting in line to move
			moveDelay = moveDelay + level.moveGapTime;
		}
	}
	
	//wait level.friendlyAreaCooldown;
}

friendlyAreaNavData()
{
	level endon ("stop_friendly_areas");
	
	//Collect the custom placed nodes targeted by the friendlyArea trigger_multiple, which friendlies get sent to randomly
	//Get the coreNode that matches this friendlyArea and filter it out from the array of normal nodes
	
	aNavData = getnodearray(self.target, "targetname");
	return(aNavData);
}

friendlyAreaNav(node, moveDelay)
{
	self endon ("death");
	level endon ("new orders");
	level endon ("stop_friendly_areas");

	//Forcemove to a tight destination within friendlyArea
	if(isdefined(moveDelay))
	{
		wait moveDelay;
	}
	
	//Navigation orders package
	self.goalradius = 64;
	self.pathenemyfightdist = 192;
	self.pathenemylookahead = 256;
	
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
		node = aNavData[randomint(aNavData.size)];
	}
	
	self setgoalnode(node);
	self waittill ("goal");
	
	self.goalradius = 64;
}

//***********************************

squad_cleanup(teamname, flagname)
{
	//cleanup all remaining enemy ai and set the desired flag
	//cleanup means attacking the player
	
	assertEX(isdefined(teamname), "Thread squad_cleanup called without specifying a team name - axis, allies, or neutral.");
	assertEX(isdefined(flagname), "Thread squad_cleanup called without specifying a flag string.");
	
	wait 3;
	
	ent = spawnstruct();
	ent.count = 0;
	aSquad = getaiarray(teamname);
	for(i=0; i<aSquad.size; i++)
	{
		aSquad[i] thread squad_cleanup_deathmonitor(ent);
		
		if(!flag("planes bombing"))
			aSquad[i] setgoalentity(level.player);
	}
	
	while(ent.count > 0)
	{
		ent waittill ("died");
	}
	
	flag_set(flagname);
}

squad_cleanup_deathmonitor(ent)
{
	ent.count++;
	self waittill ("death");
	ent notify ("died");
	ent.count--;
}

//***********************************

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
	
	level endon ("mortars completed");
	
	flag_wait("mortar teams approaching"); //mortar teams are spawned when the objective is given
	
	deployLock = false;
	
	//Initialize indices required by objective_additionalposition script command, for each mortar team
	level.teamIndices = [];
	
	teamName[0] = "alpha";
	teamName[1] = "beta";
	teamName[2] = "gamma";
	teamName[3] = "delta";
	teamName[4] = "epsilon";
	//teamName[5] = "zeta";
	teamName[5] = "eta";
	//teamName[7] = "theta";
	//teamName[8] = "iota";	
	//teamName[8] = "kappa";
	//teamName[9] = "lambda";
	//teamName[10] = "mu";
	//teamName[11] = "nu";
	//teamName[12] = "xi";
	
	for (i=0;i<teamName.size;i++)
		level.inUse[teamName[i]] = false;
	
	teamName = array_randomize(teamName);		
	index = 0;
	
	level.initialTeamPopLimit = level.mortarTeamPopLimit;
	
	while(level.mortarTeamsDeployed < level.mortarTeamsRequired)
	{	
		//only one active mortar objective team at a time until the bunker is sealed
		
		if(flag("bunkersealed"))
			level.mortarTeamPopLimit = level.initialTeamPopLimit;
		else
			level.mortarTeamPopLimit = 1;
			
		//prevent consecutive mortar team spawns from the same spot
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

		if(level.mortarTeamsDeployed >= level.mortarTeamsRequired)
			break;

		if(level.mortarTeamSlots < level.mortarTeamPopLimit)
		{	
			level.inUse[teamName[index]] = true;		//position slot in use
			thread mortarteam_deploy(teamName[index]);
			
			level.mortarTeamsDeployed++;	
				
			index++;
			level.mortarActiveTeams++;				//dev monitor
			level.mortarTeamSlots++;				//population slot taken
			
			deployLock = true;
		}
	
		teamName = array_randomize(teamName);	//randomize each turn, rather than doing it at the beginning only		
	
		if (index >= teamName.size)
		{
			//teamName = array_randomize(teamName);			
			index = 0;
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
	
	//Assemble names
	
	level endon ("mortars completed");
	
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
	mortarEnt thread mortar_impact_friendlykill(strTeamcode);
	mortarEnt thread mortar_impact_playerscare(strTeamcode);
	
	if(!level.introtalking)
		mortarEnt thread mortarteam_speechQueue(strTeamcode);
}

mortarteam_announcement_dialogue()
{
	level.mortarSpotSpeech["mortarteam_alpha"] = "hill400_defend_mortar_west";
 	level.mortarSpotSpeech["mortarteam_beta"] = "hill400_defend_mortar_northeast";
 	level.mortarSpotSpeech["mortarteam_gamma"] = "hill400_defend_mortar_north";
 	level.mortarSpotSpeech["mortarteam_delta"] = "hill400_defend_mortar_south";
 	level.mortarSpotSpeech["mortarteam_epsilon"] = "hill400_defend_mortar_southeast";
 	//level.mortarSpotSpeech["mortarteam_zeta"] = "hill400_defend_mortar_east";
 	level.mortarSpotSpeech["mortarteam_eta"] = "hill400_defend_mortar_northwest";
 	level.mortarSpotSpeech["mortarteam_theta"] = "hill400_defend_mortar_west";
}

mortarteam_speechQueue(strTeamcode)
{	
	level endon ("mortars completed");
	self endon ("mortar_done");
 	
 	self waittill ("mortar_setup_finished", strTeamcode);
  
	thread mortarteam_announcement(strTeamcode);
}

mortarteam_announcement(strTeamcode)
{
 	thread dialogue_nearby_friendly_queue(level.mortarSpotSpeech[strTeamcode]);
 	wait 3;	//soft wait
}

objectiveThink(ent, strTeamcode)
{
	self waittill ("objective_created");
	
	index = ent.index;
	
	// new mortars add new objectives
	objective_additionalposition(level.mortarObjNumber, ent.index, self.objectivePositionEntity.origin);

	thread updateObjective(index);
	thread updateObjectivePing(index);
	self waittill ("mortar_done");
	
	requiredKills = undefined;
	
	if(level.gameskill == 2)
		requiredKills = 2;
	
	if(level.gameskill == 3)
		requiredKills = 3;

	if(level.gameskill == 0 || level.gameskill == 1)
	{
		thread autoSaveByName("mortarKilled");
	}
	else
	{
		if(level.difficultMortarSave%requiredKills == 0)
		{
			thread autoSaveByName("mortarKilled");
		}
		
		level.difficultMortarSave++;
	}

	//Reset the counter so the objective index doesn't overflow (additional position only allows 0 thru 7)
	//Free up a slot
	
	level.teamIndices[ent.index] = undefined;
	level.inUse[strTeamcode] = false;
	level.mortarTeamSlots--;

	//mortar team kills don't count unless the bunker is locked down (player leaves quickly)

	if(flag("bunkersealed"))
		level.mortarTeamsEliminated++;
	
	/*
	if(level.mortarTeamsEliminated == int(level.mortarTeamsRequired * 0.3))
	{
		if(level.gameskill == 3)
			thread autoSaveByName("firstthirdmortars");
	}
	
	if(level.mortarTeamsEliminated == int(level.mortarTeamsRequired * 0.6))
	{
		if(level.gameskill == 3)
			thread autoSaveByName("secondthirdmortars");
	}
	*/
	
	if(!isdefined(level.mortarDeployGap))
	{
		level notify ("no mortar teams");
	}
	
	//Deletes the compass star for this mortar team
	objective_additionalposition(level.mortarObjNumber, ent.index, (0,0,0));
}

updateObjective(index)
{
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
	self endon ("mortar_done");
	for (;;)
	{
		//Track mortar team on compass and ping constantly
		objective_ring(level.mortarObjNumber);
		wait (1);
	}
}

mortar_impact_friendlykill(strTeamcode)
{
	level endon ("mortars completed");
	self endon ("mortar_done");
	
	//A friendly loses his bullet shield and dies from a mortar hit
	
	//Their shots do not kill any friendlies until bunker is locked down
	
	while(1)
	{
		i=0;
		while(i < level.mortarMisses + 1)
		{
			self waittill ("mortar_fired");
			i++;
			if(i < level.mortarMisses + 1)
				thread mortar_impact_fake(strTeamcode);
		}
	
		if(flag("bunkersealed") && level.mortarFriendlyKill < 3)
		{
			thread mortar_impact_deathsequence(strTeamcode);
			level.mortarFriendlyKill++;
		}
		
		wait 0.05;
	}
}

mortar_impact_playerscare(strTeamcode)
{
	level endon ("mortars completed");
	self endon ("mortar_done");
	
	//After X time, damages the player but doesn't kill him
	
	wait level.playerMortarScareGrace;
	
	while(1)
	{
		if(flag("bunkersealed"))
		{
			playersafe = false;
			wait level.playerMortarScareTime;
			self waittill ("mortar_fired");
			
		    x = randomfloatrange(64, 128);
		    y = randomfloatrange(64, 128);
		    z = -64;
		   
			impactpoint = level.player.origin + (x, y, z);
			
			aShelters = getentarray("shelter_volume", "targetname");
			for(i=0; i<aShelters.size; i++)
			{
				if(level.player istouching(aShelters[i]))
				{
					playerSafe = true;
					break;
				}
				wait 0.05;
			}
			
			if(!playerSafe)
			{
				playfx (level.mortar, impactpoint);
				thread playSoundinSpace("mortar_explosion", impactpoint);
				earthquake(0.2, 3, level.player.origin, 1000);
				level.player doDamage (level.player.health*0.8, level.player.origin);	//sting player	
			}
		}
		
		wait 0.1;
	}
}

mortar_impact_fake(strTeamcode)
{
	level endon ("mortars completed");
	
	/*
		Sets off a bogus mortar explosion for atmosphere, after an enemy mortar team fires.
		
		1. Find a valid impactpoint that meets required conditions
			-Checks distance between all mortarImpactPoints with this strTeamcode and all the AI
			-Accepts the first one found that is not in 'believable' killing range of any AI
			-Mortar hits the bunker roof if no valid impactpoints are determined
			-Mortar hits any strTeamcode matched location if no AI exist
		
		2. Plays the sound and fx on the impactpoint.
	*/
	
	//Get the datasets
	
	aRoofHits = [];
	aHits = [];
	aImpacts = getentarray("mortarImpactPoint", "targetname");
	for(i=0; i<aImpacts.size; i++)
	{
		if(!isdefined(aImpacts[i].script_noteworthy))
			continue;
		
		if(aImpacts[i].script_noteworthy != strTeamcode)
			continue;
		
		aHits[aHits.size] = aImpacts[i];	
	}
	
	for(i=0; i<aImpacts.size; i++)
	{
		if(!isdefined(aImpacts[i].script_commonname))
			continue;	
		
		if(aImpacts[i].script_commonname == "roofimpact")
			aRoofHits[aRoofHits.size] = aImpacts[i];
	}
	
	assertEX((aHits.size > 0), "At least 1 script_origin with teamcode is needed for the mortar impacts.");
	assertEX((aRoofHits.size > 0), "At least 1 script_origin with teamcode and script_commonname = roofimpact is needed for the bunker roof impacts.");
	
	//Get the best impactpoint
	
	detectHit = undefined;
	impactpoint = undefined;
	
	aGuys = getaiarray();
	
	for(i=0; i<aHits.size; i++)
	{
		detectHit = aHits[i] shell_impact_safedist_check(aGuys, level.safemortardist);
		if(detectHit == "success")
		{
			impactpoint = aHits[i];
			break;
		}	
	}
	
	if(detectHit == "failed")
		impactpoint = aRoofHits[randomint(aRoofHits.size)];	
	
	//Sound & Fx for an impact
	
	thread shell_impact(impactpoint, level.mortar, "mortar_incoming", "mortar_explosion", undefined, 0.2, 3, 3000);
}

mortar_impact_deathsequence(strTeamcode)
{	
	level endon ("mortars completed");
	
	if(level.friendlieskilled >= level.friendliesMortal)
	{
		return;
	}
	
	//Kills a redshirt with an incoming sound and mortar explosion on the guy
	
	aGenerics = gather_generic_allies();
	
	if(aGenerics.size <= 0)
	{
		thread mortar_impact_fake(strTeamcode);
		return;
	}
	
	i = randomint(aGenerics.size);
	guy = aGenerics[i];	
	dmg = guy.health;
	impactpoint = guy.origin;
	
	shell_impact(aGenerics[i], level.mortar, "mortar_incoming", "mortar_explosion");
	
	//radiusDamage(origin, range, maxdamage, mindamage);
	guy notify ("stop magic bullet shield");
	radiusDamage(impactpoint + (0, 0, 64), level.shockRange, dmg, dmg);
	
	level.friendlieskilled++;
	
	if(distance(level.player.origin, impactpoint) <= level.shockRange)
		maps\_shellshock::main(level.shockTime,int(level.player.health/2),int((level.player.health + 4)/2),int(level.player.health/2));
}

mortarteam_cleanup()
{
	//kills all the mortarteams that are remaining when the player completes the objective
	
	flag_wait("mortars completed");
	wait 1;

	aGuys = getentarray("mortarguy", "script_noteworthy");
	for(i=0; i<aGuys.size; i++)
	{
		aGuys[i] doDamage (aGuys[i].health, aGuys[i].origin);
	}
}

//**************************************//
//		  IMPACT UTILITIES				//
//**************************************//

shell_impact(impactpoint, fx, incomingSfx, explodeSfx, shelltype, quakeStrength, quakeLength, quakeRadius, skipIncoming)
{	
	if(!isdefined(skipIncoming))
	{
		playSoundinSpace(incomingSfx, impactpoint.origin);
	}
	
	playfx (fx, impactpoint.origin);
	thread playSoundinSpace(explodeSfx, impactpoint.origin);
	
	if(level.xenon)
		playRumbleOnPos("artillery_quake", impactpoint.origin);
	
	if(!isdefined(quakeStrength))
		quakeStrength = 0.4;
	if(!isdefined(quakeLength))
		quakeLength = 5;
	if(!isdefined(quakeRadius))
		quakeRadius = 3500;
	
	earthquake(quakeStrength, quakeLength, impactpoint.origin, quakeRadius);
	impactpoint notify ("exploded");
	
	if(!isdefined(shelltype))
		return;
	
	if(shelltype == "smoke")
		playfx(level.smokegrenade, impactpoint.origin);
}

shell_impact_safedist_check(aGuys, safedist)
{
	//Go thru AI array aGuys and player and do safe distance checks
	
	playerdist = distance(self.origin, level.player.origin);
	
	if(aGuys.size <= 0)
	{
		if(playerdist <= safedist)
			return("failed");
	}
	else
	{
		for(i=0; i<aGuys.size; i++)
		{
			if(isalive(aGuys[i]))
			{
				dist = distance(self.origin, aGuys[i].origin);
				if(dist <= safedist || playerdist <= safedist)
					return("failed");
			}
		}
	}
	
	return("success");
}

//**************************************//
//		 	MISC UTILITIES				//
//**************************************//

killplayer()
{
	level.player enableHealthShield( false );
		level.player doDamage (level.player.health, level.player.origin);	//killplayer
	level.player enableHealthShield( true );
}

shockPlayer(shockTimeSpecial)
{
	if(isdefined(shockTimeSpecial))
	{
		shockTime = shockTimeSpecial;
	}
	else
	{
		shockTime = level.shockTime;
	}
	
	maps\_shellshock::main(shockTime,int(level.player.health/2),int((level.player.health + 4)/2),int(level.player.health/2));
	wait 0.15;
	
	if(level.xenon)
		playRumbleOnPos("artillery_quake", level.player.origin);
		
	playfx(level.artyhit, level.player.origin);
}

/*
ff_damagecheck()
{
	level endon ("bunkersealed");
	while(1)
	{
		self waittill("damage", amount, attacker);
		if(attacker == level.player)
			break;
	}	
	setCvar("ui_deadquote", "Friendly fire will not be tolerated!");
	maps\_utility::missionFailedWrapper();
}
*/

autosave_attackwave(duration)
{
	assertEX(isdefined(duration), "Specify the attack wave duration for this autosave thread.");
	
	for(i=0; i<4; i++)
	{
		wait ((duration / 4) - 1);
		thread autoSaveByName("bookmark"); 
	}
}

magic_grenades()
{
	level endon ("stop_magic_grenades");
	flag_wait("bunkersealed");
	
	minTime = level.magicGrenadeIntervalMin;
	maxTime = level.magicGrenadeIntervalMax;
	fuseTime = level.grenadeFuseTime;
	modifier = 1;
	modifierLimit = 0.4;
	grenadeZone = undefined;
	
	while(1)
	{
		voicenum = undefined;
		aAxis = [];
		aMagics = [];
		aMagics = getentarray("magic_grenade_volume", "targetname");
		testNum = 1;
		grenadeHoldTime = 1.2;
		
		//wait (randomfloatrange(minTime * modifier, maxTime * modifier));
		
		fuseTime = level.grenadeFuseTime;
		
		for(i=0; i<aMagics.size; i++)
		{
			//use istouching instead of a waittill trigger because we need to know if/when the player leaves the volume
			
			if(level.player istouching(aMagics[i]))
			{
				if(!isdefined(aMagics[i].script_namenumber))
					continue;
			
				//faster magic grenade rate if player is hiding in bunker entrance
				if(aMagics[i].script_namenumber == "shelter0a" || aMagics[i].script_namenumber == "shelter0b" || aMagics[i].script_namenumber == "shelter0c")
				{
					minTime = level.magicGrenadeIntervalMin * 0.25;
					maxTime = level.magicGrenadeIntervalMax * 0.25;
					fuseTime = 3.5;
				}
				
				//Make sure the player gets the allocated time
				wait (randomfloatrange(minTime * modifier, maxTime * modifier));
				
				if(aMagics[i].script_namenumber != "shelter0a" && aMagics[i].script_namenumber != "shelter0b" && aMagics[i].script_namenumber != "shelter0c")
				{
					if(!(level.player istouching(aMagics[i])))
					{
						modifier = 1;
						break;
					}
				}
				
				if(modifier > modifierLimit)
				{
					modifier = modifier - 0.05;	//the grenades get more frequent each iteration
				}
					
				aSources = getentarray(aMagics[i].target, "targetname");
				if(aSources.size > 1)
				{
					grenadeSource = aSources[randomint(aSources.size)];
				}
				else
				{
					grenadeSource = aSources[0];
				}
				
				//temp testing begins for individual magic grenades
				/*
				grenadeSource = undefined;
				
				for(j=0; j<aSources.size; j++)
				{
					if(aSources[j].script_namenumber == "s0ag2")
					{
						grenadeSource = aSources[j];
						break;
					}
				}
				
				if(!isdefined(grenadeSource))
					break;
				*/
				//temp testing ends
				
				grenadeDest = getent(grenadeSource.target, "targetname");
				
				if(isdefined(grenadeSource.script_grenadespeed))
				{
					speed = grenadeSource.script_grenadespeed;
				}
				else
				if(isdefined(aMagics[i].script_namenumber) && isdefined(grenadeSource.script_namenumber))
				{
					speed = level.magicdata[aMagics[i].script_namenumber][grenadeSource.script_namenumber];
				}
				else
				{
					speed = 1000;	
				}
				
				velocity = vectorNormalize (grenadeDest.origin - grenadeSource.origin);
				velocity = maps\_utility::vectorScale (velocity, speed);
				
				aAxis = getaiarray("axis");
				
				//Don't throw a magic grenade if there aren't enough AI around
				if(aAxis.size <= level.minMagicGrenadeAI)
					break;
				
				grenadeZone = aMagics[i];
				
				for(i=0; i<aAxis.size; i++)
				{
					if(isalive(aAxis[i]))
					{
						aAxis[i] magicGrenadeManual(grenadeSource.origin, velocity, fuseTime);
						
						grenadeHoldTime = randomfloatrange(0.25, 1);
						wait grenadeHoldTime;	//0.7
						
						if(grenadeZone.script_namenumber == "shelter0a" || grenadeZone.script_namenumber == "shelter0b" || grenadeZone.script_namenumber == "shelter0c")
						{	
							//extra throws
							fuseTime = randomfloatrange(fuseTime, fuseTime+0.8);
							if(isalive(aAxis[i]))
							{
								aAxis[i] magicGrenadeManual(grenadeSource.origin, velocity, fuseTime);
							}
							
							grenadeHoldTime = randomfloatrange(0.7, 1);
							wait grenadeHoldTime;	//0.7
							
							fuseTime = randomfloatrange(fuseTime, fuseTime+0.8);
							//fusetime = 5;
								
							for(z=0; z<2; z++)
							{
								if(isalive(aAxis[i]))
								{
									aAxis[i] magicGrenadeManual(grenadeSource.origin, velocity, fuseTime);
																		
									grenadeHoldTime = randomfloatrange(0.5, 0.7);
									wait grenadeHoldTime;	//0.7
								}
							}
						}
						
						voicenum = randomint(6);
						switch(voicenum)
						{
							case 0:
								thread playSoundinSpace("US_bra_inform_incoming_grenade", level.player.origin);
								break;
							case 1:
								thread playSoundinSpace("US_mcc_inform_incoming_grenade", level.player.origin);
								break;
							case 2:
								thread playSoundinSpace("US_0_inform_incoming_grenade", level.player.origin);
								break;
							case 3:
								thread playSoundinSpace("US_1_inform_incoming_grenade", level.player.origin);
								break;
							case 4:
								thread playSoundinSpace("US_2_inform_incoming_grenade", level.player.origin);
								break;
							case 5:
								thread playSoundinSpace("US_3_inform_incoming_grenade", level.player.origin);
								break;
						}
						
						break;
					}
				}
				
				aAxis = [];
			
				break;
			}
			
			wait 0.05;
		}
		
		wait 0.05;
	}
}

magic_grenade_data()
{
	//launch speeds for magic grenades
	
	level.magicdata["shelter0a"]["s0ag1"] = 1260;
	level.magicdata["shelter0a"]["s0ag2"] = 1460;
	
	level.magicdata["shelter0b"]["s0bg1"] = 700;
	level.magicdata["shelter0b"]["s0bg2"] = 1400;
	
	level.magicdata["shelter0c"]["s0cg1"] = 1000;
	
	level.magicdata["shelter1"]["s1g1"] = 880;
	level.magicdata["shelter1"]["s1g2"] = 910;
	level.magicdata["shelter1"]["s1g3"] = 1050;
	level.magicdata["shelter1"]["s1g4"] = 1080;
	
	level.magicdata["shelter2"]["s2g1"] = 1080;
	level.magicdata["shelter2"]["s2g2"] = 1150;
	level.magicdata["shelter2"]["s2g3"] = 1060;
	level.magicdata["shelter2"]["s2g4"] = 1180;
	
	level.magicdata["shelter3"]["s3g1"] = 1030;
	level.magicdata["shelter3"]["s3g2"] = 780;
	level.magicdata["shelter3"]["s3g3"] = 1000;
	level.magicdata["shelter3"]["s3g4"] = 1080;
	
	level.magicdata["shelter4"]["s4g1"] = 1350;
	level.magicdata["shelter4"]["s4g2"] = 1270;
	level.magicdata["shelter4"]["s4g3"] = 1280;
	level.magicdata["shelter4"]["s4g4"] = 1150;
	
	level.magicdata["shelter5"]["s5g1"] = 1120;
	level.magicdata["shelter5"]["s5g2"] = 930;
	level.magicdata["shelter5"]["s5g3"] = 1280;
}

//**************************************//
//		  VEHICLE UTILITIES				//
//**************************************//

vehicle_deploy(spawnerName, moverName, vehicleClass)
{
	//halftrack deployments in the thickest part of the smoke
	//3 halftracks come rolling in at different times during the mid phase attack
	
	//Halftracks drive through the west breach and unload infantry with automatic weapons
	//Match pairs of triggers that spawn and send the halftrack
	//Deployment array is randomized each turn
	
	assertEX(isdefined(spawnerName), "vehicle_deploy called without a spawnerName parameter");
	assertEX(isdefined(moverName), "vehicle_deploy called without a moverName parameter");
	assertEX(isdefined(vehicleClass), "vehicle_deploy called without a vehicleClass parameter");
	
	triggerPairs = [];
	aSpawners = getentarray(spawnerName, "targetname");
	aMovers = getentarray(moverName, "targetname");
	
	for(i=0; i<aSpawners.size; i++)
	{
		if(!isdefined(aSpawners[i].script_vehiclespawngroup))
			continue;
	
		triggerPairs[i]["spawner"] = aSpawners[i];
		
		for(n=0; n<aMovers.size; n++)
		{
			if(!isdefined(aMovers[n].script_vehiclestartmove))
				continue;
				
			if(aSpawners[i].script_vehiclespawngroup == aMovers[n].script_vehiclestartmove)
			{
				triggerPairs[i]["mover"] = aMovers[n];
				break;
			}
		}
	}
	
	//Spawn with randomization
	triggerPairs = array_randomize(triggerPairs);
	smokescreen = undefined;
	halftrack = undefined;
	
	for(i=0; i<triggerPairs.size; i++)
	{
		smokescreen = getent(triggerPairs[i]["spawner"].target, "targetname");
		playfx(level.smokegrenade, smokescreen.origin);
		wait level.smokegrenadetime;
		triggerPairs[i]["spawner"] notify ("trigger");
		wait 1;
		triggerPairs[i]["mover"] notify ("trigger");
		wait 1;
		
		if(vehicleClass == "halftrack")
		{
			halftrack = getent(triggerPairs[i]["mover"].target, "targetname");
			level.halftracksSpawned++;
			halftrack.threatVehType = "halftrack";
			halftrack thread vehicle_halftrack_deathmonitor();
			halftrack thread vehicle_halftrack_unload();
			halftrack thread vehicle_halftrack_gunner_arrived();
			halftrack thread tank_explosives();
			halftrack thread dialogue_halftrack_spotted();
			wait level.secondWaveDuration*0.05;
		}
		
		if(vehicleClass == "tank")
		{
			tank = getent(triggerPairs[i]["mover"].target, "targetname");
			level.tanksSpawned++;
			
			tank.threatVehType = "tigertank";
			size = level.tankArmy.size;
			level.tankArmy[size] = tank;
			level.tankArmy[size].threatVehType = tank.threatVehType;
			
			if(isdefined(triggerPairs[i]["mover"].script_namenumber))
			{
				level.tankArmy[size].threatInfo = triggerPairs[i]["mover"].script_namenumber;;
			}
			
			tank thread tank_explosives();
			tank thread vehicle_tank_arrived();
			tank thread dialogue_tank_spotted();
			tank thread vehicle_tank_deathmonitor();
			wait level.thirdWaveDuration*0.2;
		}
	}
}

vehicle_halftrack_unload()
{
	self waittill ("reached_end_node");
	self notify ("unload");
}

vehicle_halftracks_kill()
{
	while(level.halftracksArrived < 3)
	{
		level waittill ("halftrack_arrived");
		level.halftracksArrived++; 
	}
	
	flag_set("halftracks_in_place");
}

vehicle_halftrack_gunner_arrived()
{
	gunner = undefined;
	self waittill ("reached_end_node");
	level notify ("halftrack_arrived");
	
	flag_wait("halftracks_in_place");
	
	if(isdefined(self.mgturret[0].fakeowner))
	{
		gunner = self.mgturret[0].fakeowner;
	}
	
	wait randomfloat(2, 3);
	
	if(isalive(gunner))
	{
		gunner doDamage (gunner.health, gunner.origin);
	}
}

vehicle_tank_arrived()
{
	self waittill ("reached_end_node");
	flag_set("third_wave_tanks");
}

vehicle_halftrack_deathmonitor()
{
	self waittill ("death");
	thread autoSaveByName("bonus_save_tankdestroyed"); 
}

vehicle_tank_deathmonitor()
{
	self waittill ("death");
	level.tankpop--;
	thread autoSaveByName("bonus_save_tankdestroyed"); 
}

vehicle_airplanes()
{
	level endon ("mission_failed");
	
	if(getcvar("start") != "planes")
	{
		flag_wait("planes arrive");
	}
	else
	{
		wait 1;
	}
	
	thread vehicle_airplanes_deploy("mustang1");
	wait 10;
	thread vehicle_airplanes_deploy("mustang2");
	
	flag_set("stop_on_planes_approach");	//stops atmosphere dialogue so plane arrival dialogue is heard clearly
	
	wait 4;
	thread vehicle_airplanes_deploy("mustang3");
	
	thread vehicle_airplanes_dialogue();

	wait 12;
	thread vehicle_airplanes_deploy("mustang4");
	wait 3;
	thread vehicle_airplanes_deploy("mustang5");
	
	//++++must make more cool plane flybys but will loop for now
	
	while(1)
	{
		if(level.planePop < level.maxPlanePop + 10)	//added fudge factor
		{
			planeName = "mustang" + (randomint(level.maxPlanePop) + 1);
			
			if(flag("third_wave_eliminated"))
				thread vehicle_airplanes_deploy(planeName, 1);
			else
				thread vehicle_airplanes_deploy(planeName);
			
			wait 1;
		}
		
		wait 0.05;
	}
}

vehicle_airplanes_deploy(planeName, holdFire)
{
	plane = sky_makeplane(planeName);
	level.planePop++;
	plane thread plane_sound();
	plane thread flyby_quake();
	plane thread vehicle_airplanes_delete();
	
	if(!isdefined(holdFire))
	{
		plane thread vehicle_airplanes_targeting(planeName);
		thread vehicle_airplanes_pyrodata(planeName);
	}
}

vehicle_airplanes_delete()
{
	self waittill("reached_end_node");
	self delete();
	level.planePop--;
}

vehicle_airplanes_dialogue()
{
	//"AIRCRAFT COMING IN FROM THE WEST! It's a bombing run!!! Take cover!!!"
	thread dialogue_nearby_friendly_queue("hill400_defend_aircraft1");
	wait 9;
	
	flag_set("cue_end_music");
	
	//"Hey!!! Look at those markings!!! They're friendlies!!!"
	thread dialogue_nearby_friendly_queue("hill400_defend_aircraft2");
	wait 2;
	
	flag_set("planes bombing");
	
	wait 0.05;
	level.canSave = true;
	
	//"Hot damn!! They're P-51 Mustangs!!! They're on our side!!!!"
	thread dialogue_nearby_friendly_queue("hill400_defend_aircraft3");
	
	flag_set("on_our_side");
	
	if(getcvar("start") == "planes")
	{
		flag_set("third_wave_eliminated");
	}
}

vehicle_airplanes_targeting(planeName)
{
	//Gets the flight path node at which the pyrotechnics sequence should start
	
	node = getVehicleNode( planeName, "targetname" );
	starterName = planeName + "_pyrostart";
	planeTankTarget = undefined;
	bombTank = false;
	
	while(1)
	{			
		if(!isdefined(node.target) && !isdefined(node.script_noteworthy))
			break;
		
		testNode = getVehicleNode(node.target, "targetname");
		
		if(!isdefined(testNode) && !isdefined(node.script_noteworthy))
			break;
		
		if(isdefined(testNode))
			node = testNode;		
		
		if(!isdefined(node.script_noteworthy))
		{
			wait 0.05;
			continue;
		}
		
		if(node.script_noteworthy != starterName)
		{
			wait 0.05;
			continue;
		}
		
		//Carpet bombing only allowed to happen some limited number of times
		
		if(planeName == "mustang2" && level.carpetBomb)
		{
			level.carpetBomb = false;
			self thread vehicle_airplanes_pyro(node, planeName);
			break;
		}
		
		if(planeName == "mustang2" && !level.carpetBomb)
		{
			break;
		}
		else
		if(planeName == "mustang1" && level.tankPop <= 0)
		{
			break;
		}
		else
		if(planeName == "mustang3" && level.tankPop <= 0)
		{
			break;
		}
		else
		{
			if(planeName == "mustang1" || planeName == "mustang3")
			{
				planeTankTarget = planeName + "_tank";
				
				for(i=0; i<level.tankArmy.size; i++)
				{
					if(isdefined(level.tankArmy[i].health) && level.tankArmy[i].health > 0)
					{
						if(isdefined(level.tankArmy[i].threatInfo) && level.tankArmy[i].threatInfo == planeTankTarget)
						{
							bombTank = true;
						}
					}
				}
				
				if(bombTank)
					self thread vehicle_airplanes_pyro(node, planeName);
			}
			else
			{
				self thread vehicle_airplanes_pyro(node, planeName);
			}
		}
		break;
	}
}

vehicle_airplanes_pyro(node, planeName)
{
	//node is where the pyrotechnics for a given plane are notified to start, this should be placed before the first hit location
	//fx and radiusdamage are then triggered along a preset chain of script_origins with delays adjusted in script
	
	name = planeName + "_squibstart";
	impactPoint = getent(name, "targetname");
	
	self setwaitnode(node);
	self waittill ("reached_wait_node");
		
	i = 0;
	while(1)
	{
		if(!isdefined(level.pyroProg[planeName][i]))
			wait 2;
		else
			wait level.pyroProg[planeName][i];
			
		thread vehicle_airplanes_detonate(impactPoint);
		
		if(!isdefined(impactpoint.target))
			break;
		
		impactPoint = getent(impactpoint.target, "targetname");
		i++;
	}
}

vehicle_airplanes_pyrodata(planeName)
{
	//Pyrotechnics programs for different planes
	
	if(planeName == "mustang1")
	{
		level.pyroProg["mustang1"][0] = 2.1;
	}
	
	if(planeName == "mustang2")
	{
		level.pyroProg["mustang2"][0] = 0.4;
		level.pyroProg["mustang2"][1] = 0.15;
		level.pyroProg["mustang2"][2] = 0.15;
		level.pyroProg["mustang2"][3] = 0.15;
		level.pyroProg["mustang2"][4] = 0.2;
		level.pyroProg["mustang2"][5] = 0.2;
		level.pyroProg["mustang2"][6] = 0.2;
		level.pyroProg["mustang2"][7] = 0.2;
		level.pyroProg["mustang2"][8] = 0.2;
		level.pyroProg["mustang2"][9] = 0; //hits the tank
		level.pyroProg["mustang2"][10] = 0;
		level.pyroProg["mustang2"][11] = 0.3;	
		level.pyroProg["mustang2"][12] = 0.2;
	}
	
	if(planeName == "mustang3")
	{
		level.pyroProg["mustang3"][0] = 0.15;
		level.pyroProg["mustang3"][1] = 0.5;
		level.pyroProg["mustang3"][2] = 0.2;
		level.pyroProg["mustang3"][3] = 0.2;
		level.pyroProg["mustang3"][4] = 0.2;
		level.pyroProg["mustang3"][5] = 0.25;
	}
	
	if(planeName == "mustang4")
	{
		level.pyroProg["mustang4"][0] = 2.3;
		level.pyroProg["mustang4"][1] = 0.65;
	}
	
	if(planeName == "mustang5")
	{
		level.pyroProg["mustang5"][0] = 0.3;
		level.pyroProg["mustang5"][1] = 0.3;
		level.pyroProg["mustang5"][2] = 0.3;
		level.pyroProg["mustang5"][3] = 0.3;
	}
}

vehicle_airplanes_detonate(impactPoint)
{
	deathradius = 512;
	dist = distance(level.player.origin, impactPoint.origin);
	
	//++++would like to guarantee a first bomb hit, if the player is too close shellshock instead of killing player
	
	if((!flag("third_wave_eliminated") || level.tankpop > 0) && (dist > deathradius))
	{
		radiusDamage(impactPoint.origin + (0, 0, 64), deathradius, 10000, 1000); //radiusDamage(origin, range, maxdamage, mindamage)
	}
	
	if((!flag("third_wave_eliminated") || level.tankpop > 0) && (dist < deathradius))
	{
		if(!level.playerShocked)
		{
			thread shockPlayer();
			level.playerShocked = true;
			radiusDamage(impactPoint.origin + (0, 0, 64), 64, 10000, 10000); //radiusDamage(origin, range, maxdamage, mindamage)
		}
		else
		{
			radiusDamage(impactPoint.origin + (0, 0, 64), deathradius, 10000, 1000); //radiusDamage(origin, range, maxdamage, mindamage)
		}
	}
	
	if(level.xenon)
			playRumbleOnPos("artillery_quake", impactpoint.origin);
	
	playfx(level.breachfx, impactPoint.origin);	
	thread playSoundinSpace("mortar_explosion", impactPoint.origin);
}

sky_makeplane(name, speed)
{
	node = getVehicleNode( name, "targetname" );
	
		plane = spawnVehicle( "xmodel/vehicle_p51_mustang", "plane", "stuka", (0,0,0), (0,0,0) );
		plane setmodel ("xmodel/vehicle_p51_mustang");
	
	plane attachPath( node );
	plane startPath();
	if(isdefined(speed))
		plane setspeed(speed, speed);
	
	return plane;
}

plane_sound()
{
	self thread flyby_sound();
	self thread playLoopSoundOnTag("p51_mustang_loop", "tag_origin");
}

flyby_sound()
{
	self endon("reached_end_node");
	while (true)
	{
		if (distance(level.player getorigin(), self getorigin()) < 3500)
		{
			self thread playSoundOnTag("p51_mustang_flyby", "tag_origin");
			wait 3;
		}
		wait .05;
	}
}

flyby_quake()
{
	self endon("death");
	while (1)
	{
		earthquake(0.4, 0.2, self.origin, 2500); // scale duration source radius
		wait (0.2);
	}
}

//Halftracks w/ bomblets

tank_explosives()
{
	self endon ("death");

	self thread tank_ondeath();
	self.bombTriggers = [];
	self.bombs = [];
	tags = [];
	location_angles = [];

	if(self.threatVehType == "halftrack")
	{
		tags[0] = "tag_engine_left";
		tags[1] = "tag_engine_right";
		
		location_angles[0] = (90,0,0);
		location_angles[1] = (90,0,0);
	}
	
	if(self.threatVehType == "tigertank")
	{
		tags[0] = "tag_gastank_left";
		tags[1] = "tag_left_wheel_09";
		tags[2] = "tag_right_wheel_09";
		
		location_angles[0] = self.angles + (0,0,0);
		location_angles[1] = self.angles + (180,90,0);
		location_angles[2] = self.angles + (0,90,0);
	}

	for (i=0; i < tags.size; i++)
	{
		bomb = spawn("script_model", self gettagorigin(tags[i]));
		bomb setmodel("xmodel/military_tntbomb_obj");
		bomb.angles = location_angles[i];
		bomb linkto(self,tags[i]);

		bomb.trigger = undefined;

		aTrigger = getentarray("sticky_trigger","targetname");
		for (t=0; t < aTrigger.size; t++)
		{
			if (!isdefined(aTrigger[t].inuse))
			{
				bomb.trigger = aTrigger[t];
				break;
			}
		}

		assert(isdefined(bomb.trigger));
		bomb.trigger.inuse = true;

		bomb.trigger.oldorigin = bomb.trigger.origin;
		bomb.trigger.origin = bomb.origin;
		if (!isdefined(bomb.trigger.linktoenable))
			bomb.trigger enablelinkto();
		bomb.trigger.linktoenable = true;
		bomb.trigger linkto(bomb);

		self.bombs[i] = bomb;
		self thread tank_explosives_wait(bomb.trigger,i);
	}

	self waittill ("explosives planted",id);

	badplacename = ("tank_badplace_" + randomfloat(1000));
	badplace_cylinder(badplacename, -1, self.origin, 250, 300);
	
	//iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");

	bomb = self.bombs[id];

	level thread remove_stickys(self.bombs,id);

	bomb setmodel ("xmodel/military_tntbomb");
	bomb playsound ("explo_plant_rand");
	bomb playloopsound ("bomb_tick");

	actualVeh = self;

	level thread stopwatch(bomb, actualVeh, badplacename);

	/*
		self waittill ("death");

		badplace_delete(badplacename);
	
		self notify ("death", level.player);
		bomb delete();
	*/
}

remove_stickys(bombs, id)
{
	if (!isdefined(id))
		id = 1000; // a value that will never match
	for (i=0;i < bombs.size;i++)
	{
		if (!isdefined(bombs[i]))
			continue;
		bombs[i].trigger unlink();
		bombs[i].trigger.inuse = undefined;
		bombs[i].trigger.origin =  bombs[i].trigger.oldorigin;

		if (i != id)
			bombs[i] delete();
	}
}

stopwatch(bomb, actualVeh, badplacename)
{
	if (isdefined (self.bombstopwatch))
		self.bombstopwatch destroy();
	
	self.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	
	//Handle case of player destroying the vehicle with a Panzerschreck while a bomb is ticking
	
	ent = spawnstruct();
	ent.completed = false;
	level thread stopwatchCancel(bomb, actualVeh, ent, badplacename);
	
	wait level.explosiveplanttime;
	actualVeh notify ("death", level.player);
	
	level thread stopWatchClear(ent, badplacename, bomb);
}

stopwatchCancel(bomb, actualVeh, ent, badplacename)
{
	//In case player destroys the vehicle with a Panzerschreck while it is counting down
	
	actualVeh waittill ("death");
	wait 0.1;
	
	level thread stopWatchClear(ent, badplacename, bomb);	
}

stopWatchClear(ent, badplacename, bomb)
{
	if(!ent.completed)
	{
		ent.completed = true;
		badplace_delete(badplacename);
		
		//bomb delete();
		
		level.timersused--;
		if (level.timersused < 1)
		{
			if (isdefined (self.bombstopwatch))
				self.bombstopwatch destroy();
		}
	}
}

tank_explosives_wait(trigger,id)
{
	self endon ("death");
	self endon ("explosives planted");
	
	trigger setHintString (&"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES");
	while(true)
	{
		trigger waittill ("trigger");
		level.player.tnt--;
		if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();


		level notify ("explosives planted");
		self notify ("explosives planted", id);
		return;
	}
}

tank_ondeath()
{
	self waittill("death");
	level thread remove_stickys(self.bombs);
	level notify("tank destroyed",self.pos_id);
}

//**************************************//
//		  DIALOGUE UTILITIES			//
//**************************************//

Dialogue_Thread(dialogue, node)
{
	if(!isalive(self))
		return;
	
	self setBattleChatter(false);
	
	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
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

/*
dialogue_thread(dialogue)
{
	self setBattleChatter(false);
	
	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	
	facial = undefined;	
	
	self anim_single_solo(self, dialogue);
	//self thread animscripts\face::SaySpecificDialogue(facial, dialogue, 1.0, "single dialogue");
	//self waittill ("single dialogue");
	
	self setBattleChatter(true);
		
	self.MyIsSpeaking = false;
	self notify ("my done speaking");
}
*/
dialogue_atmosphere_endons()
{
	flag_wait("stop_on_planes_approach");
	level notify ("stop_badnews_chatter");
	level notify ("stop_dialogue_atmosphere");
}

dialogue_atmosphere(teamSetName, dialogueSetName, minDelay, maxDelay, endonSpecial, teamName)
{	
	if(!isdefined(endonSpecial))
	{
		level endon ("stop_dialogue_atmosphere");
	}
	else
	{
		level endon (endonSpecial);
	}
	
	assert(isdefined(teamSetName));
	assert(isdefined(dialogueSetName));
	assert(isdefined(minDelay));
	assert(isdefined(maxDelay));
	assert((teamName == "axis" || teamName == "allies"), "teamName must be axis or allies");
	
	speaker = undefined;
	aSpeakers = getentarray("atmosphereSpeaker", "targetname");
	aValidSpeakers = [];
	
	//The speaker is a backup in the event no usable AI is found to play the dialogue
	
	minSpeakerDist = 1400;
	
	for(i=0; i<aSpeakers.size; i++)
	{
		dist = distance(level.player.origin, aSpeakers[i].origin);
		
		if(dist < minSpeakerDist)
		{
			wait 0.05;
			continue;
		}
		
		aValidSpeakers[aValidSpeakers.size] = aSpeakers[i];
	}
	
	if(aValidSpeakers.size <= 0)
	{
		speaker = aSpeakers[randomint(aSpeakers.size)];
	}
	else
	{
		speaker = aValidSpeakers[randomint(aValidSpeakers.size)];
	}
	
	aSpeakers = undefined;
	aValidSpeakers = undefined;
	
	soundAliases = [];
	for(i=0; i < level.ambientChatter[teamSetName][dialogueSetName]; i++ )
	{
		soundAliases[i] = level.scrsound[teamSetName][dialogueSetName][i];
	}
	
	soundAliases = array_randomize(soundAliases);		
	for(i=0; i<soundAliases.size; i++)
	{
		dialogue_atmosphere_playback(speaker, soundAliases[i], teamName, endonSpecial, teamSetName);
		wait randomfloatrange(minDelay, maxDelay);
	}
}

dialogue_atmosphere_playback(speaker, soundalias, team, endonSpecial, teamSetName)
{
	if(!isdefined(endonSpecial))
	{
		level endon ("stop_dialogue_atmosphere");
	}
	else
	{
		level endon (endonSpecial);
	}
	
	//Play the sound on the most appropriately distanced AI, or use the speaker if none found
	
	minTalkRange = 612;
	
	dist = undefined;
	aTalkers = [];
	aGuys = getaiarray(team);
	for(i=0; i<aGuys.size; i++)
	{
		if(isdefined(aGuys[i].origin))
			dist = distance(level.player.origin, aGuys[i].origin);
		
		if(!isdefined(dist))
			continue;
			
		if(dist < minTalkRange)
		{
			wait 0.05;
			continue;
		}
			
		aTalkers[aTalkers.size] = aGuys[i];
	}
	
	if(aTalkers.size <= 0)
	{
		level playSoundInSpace( soundalias , speaker.origin );
		return;
	}
	
	talker = aTalkers[randomint(aTalkers.size)];
	
	//talker.animname = teamSetName;
	//talker thread dialogue_thread(soundalias);
	
	level playSoundInSpace( soundalias , talker.origin );
}

shoutingThruSmoke(waveNumber)
{
	//Different sets of dialogue for the two post-barrage attack waves
	
	assertEX(isdefined(waveNumber), "waveNumber not found for thread shoutingThruSmoke");
	
	if(waveNumber == 2)
	{
		//dialogue_atmosphere(teamSetName, dialogueSetName, minDelay, maxDelay, endonSpecial, teamName)
		thread dialogue_atmosphere("axis_chatter","secondwavestart", 0.6, 1.2, undefined, "axis");
		wait 2;
		
		//"They're usin' smoke shells to cover their advance!! Get readyyy!!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_smokescreen1");
		wait 1;
		
		//"I can't see a damn thing out there!!! Which way are they comin' from???"
		thread dialogue_nearby_friendly_queue("hill400_defend_smokescreen2");
		wait 1;
		
		//"Here comes the second wave!!! Hold em off!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_nextwave1");
		wait 2;
		
		//"Stay close to the bunker!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_nextwave2");
	}
	if(waveNumber == 3)
	{
		thread dialogue_atmosphere("axis_chatter","thirdwavestart", 0.6, 1.2, undefined, "axis");
		wait 2;
		
		//"Here they come again!!! Rangers, stand your ground!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_finalwave1");
		wait 2;
		
		//"Don't let 'em get into that bunker!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_finalwave2");
		wait 2;
		
		//"They're movin' in!!!" 
		thread dialogue_nearby_friendly_queue("hill400_defend_enemyrush1");
		wait 2;
		
		//"They're making a push!!! Hold your ground!!!"
		thread dialogue_nearby_friendly_queue("hill400_defend_enemyrush2");
	}
}

shoutingDuringMortars()
{
	if(getcvar("start") == "start")
	{
		flag_wait("bunkersealed");
	}
	
	if(getcvar("start") == "start" || getcvar("mortars") == "mortars")
	{
		thread dialogue_atmosphere("axis_chatter","duringmortars", 5, 10, undefined, "axis");
		
		while(1)
		{
			if(level.mortarTeamsEliminated >= level.mortarTeamsRequired - 1)
			{
				level notify ("stop_dialogue_atmosphere");
				break;
			}
			
			wait 0.05;
		}
	}
}

shoutingBeforeBarrage(barrageName)
{
	assert(isdefined(barrageName));
	
	if(barrageName == "firstbarrage")
	{
		thread dialogue_atmosphere("allies_chatter","prebarrage1", 0.25, 0.8, undefined, "allies");	
	}
	
	if(barrageName == "secondbarrage")
	{
		//++++MODIFY THE DIALOGUE PACKAGE FOR THIS BRANCH, GET NEW DIALOGUE RECORDED
		thread dialogue_atmosphere("allies_chatter","prebarrage2", 0.25, 0.8, undefined, "allies");	
	}
}

shoutingBarrageWarning(barrageName)
{
	assert(isdefined(barrageName));
	
	if(barrageName == "firstbarrage")
	{
		thread dialogue_atmosphere("allies_incoming","barragecover1", 1, 2, undefined, "allies");	
	}
	
	if(barrageName == "secondbarrage")
	{
		//++++MODIFY THE DIALOGUE PACKAGE FOR THIS BRANCH, GET NEW DIALOGUE RECORDED
		thread dialogue_atmosphere("allies_incoming","barragecover2", 1, 2, undefined, "allies");	
	}
}

shoutingDuringSecondWaveAttack()
{
	if(getcvar("start") == "start" || getcvar("start") == "mortars" || getcvar("start") == "firstbarrage")
	{
		flag_wait("second_wave_starts");
	}

	//dialogue_atmosphere(teamSetName, dialogueSetName, minDelay, maxDelay)
	thread dialogue_atmosphere("axis_chatter","secondwaveattack", 8, 12, undefined, "axis");
	
	level waittill ("second wave completed");
	level notify ("stop_dialogue_atmosphere");
}

shoutingDuringThirdWaveAttack()
{
	if(getcvar("start") != "thirdwave")
	{
		flag_wait("third_wave_starts");
	}
	
	softWait = 6;	//fudge factor for timing
	
	thread dialogue_atmosphere("axis_chatter","thirdwaveattack", 8, 12, "stop_thirdwave_chatter", "axis");
	wait softWait;
	
	thread dialogue_atmosphere("allies_chatter","thirdwave", 5, 20, "stop_thirdwave_chatter", "allies");
}

shoutingDuringThirdWaveAttackLate()
{
	if(getcvar("start") != "thirdwave")
	{
		flag_wait("start timer");
	}
	
	wait (level.thirdWaveDuration - 45);	//start a bit before the music
	
	level notify ("stop_thirdwave_chatter");
	wait 4;
	thread dialogue_atmosphere("allies_chatter","medicscream", 3, 4, "stop_badnews_chatter", "allies");
	wait 2.5;
	thread dialogue_atmosphere("allies_chatter","thirdwavelate", 1.5, 2.8, "stop_badnews_chatter", "allies");
}

shoutingDuringThirdWaveTanks()
{
	if(getcvar("start") != "thirdwave")
	{
		flag_wait("third_wave_tanks");
	}
	
	thread dialogue_atmosphere("axis_chatter","thirdwavetanks", 6, 10, "stop_dialogue_atmosphere", "axis");
	wait 3;
	thread dialogue_atmosphere("allies_chatter","tankarrival", 6, 12, "stop_dialogue_atmosphere", "allies");
}

shoutingDuringBunkerDanger()
{
	level endon ("planes_bombing");
	level endon ("player_returned");
	level endon ("real_threat_ended");
	
	if(!flag("real_threat_ended"))
	{
		thread dialogue_atmosphere("axis_chatter","bunkerdanger", 10, 20, "player_returned", "axis");
	}
}

shoutingDuringVictory()
{
	if(getcvar("start") != "planes")
	{
		//flag_wait("planes arrive");
		flag_wait("falling_back");
	}
	
	thread dialogue_atmosphere("allies_chatter","victory", 0.1, 0.3, "third_wave_eliminated", "allies");
	wait 5;
	thread dialogue_atmosphere("axis_chatter","retreat", 0.5, 1, "third_wave_eliminated", "axis");
	wait 5;
	thread dialogue_atmosphere("axis_chatter","dying", 4, 6, "third_wave_eliminated", "axis");
}
/*
dialogue_nearby_friendly_queue(soundAlias, nostomp)
{
	assertEX(isdefined(soundAlias), "You must specify a soundalias.");
	level.friendlySpeechArray[level.friendlySpeechNum] = soundAlias;
	level.friendlySpeechNum++;
	wait 0.05;
	thread dialogue_nearby_friendly(soundAlias, nostomp);
}

dialogue_nearby_friendly(soundAlias, nostomp)
{
	if(isdefined(nostomp))
	{
		if(level.busyFriendlyChannel)
			level waittill ("friendly_channel_open");
	}
	
	level.busyFriendlyChannel = true;
	
	aAllies = [];
	aAllies = getaiarray("allies");
	if(aAllies.size <= 0)
	{
		playSoundinSpace(level.friendlySpeechArray[level.friendlySpeechPos], level.player.origin);
	}
	else
	{
		guy = aAllies[randomint(aAllies.size)];
		playSoundinSpace(level.friendlySpeechArray[level.friendlySpeechPos], guy.origin);
	}
	
	level.friendlySpeechPos++;
	level.busyFriendlyChannel = false;
	level notify ("friendly_channel_open");
}
*/

dialogue_nearby_friendly_queue(msg)
{
	level.friendlySpeechArray[level.friendlySpeechArray.size] = msg;
	level notify ("dialogue_nearby_friendly_add");
}

dialogue_nearby_friendly()
{
	// gets price voice commands as they come in and play them in the order they arrived
	level.friendlySpeechArray = [];
	while(1)
	{
		level waittill ("dialogue_nearby_friendly_add");
		while (level.friendlySpeechArray.size)
		{
			aAllies = [];
			aAllies = getaiarray("allies");
			if(aAllies.size <= 0)
			{
				playSoundinSpace(level.friendlySpeechArray[0], level.player.origin);
			}
			else
			{
				guy = aAllies[randomint(aAllies.size)];
				playSoundinSpace(level.friendlySpeechArray[0], guy.origin);
			}
			wait (0.3);
			newQueue = [];
			for (i=1;i<level.friendlySpeechArray.size;i++)
				newQueue[newQueue.size] = level.friendlySpeechArray[i];
			level.friendlySpeechArray = newQueue;
		}
		//level notify ("queue_cleared");
	}
}

dialogue_mortarsnipenag()
{
	flag_wait("bunkersealed");
	wait 16;
	while(level.mortarTeamsEliminated < 1)
	{
		//"Taylor! Those mortars teams are gonna get us killed!! Use your sniper rifle to take 'em out!!"
		//"Corporal Taylor!!! Keep moving along the perimeter! Snipe those mortar teams!!!"
		//"Taylor! Take out the mortar crews on the perimeter or we're dead!! Hurry!"
		
		thread dialogue_nearby_friendly_queue("hill400_defend_mortar_warning");
		wait 40;
	}
}

dialogue_halftrack_spotted()
{
	node = getvehiclenode(self.target, "targetname");
	
	while(1)
	{
		if(!isdefined(node.target))
		{
			return;
		}
		
		if(!isdefined(node.script_namenumber))
		{
			node = getvehiclenode(node.target, "targetname");
			continue;
		}
			
		if(node.script_namenumber == "halftrack_spotted")
		{
			break;
		}
	}
	
	self setwaitnode(node);
	self waittill ("reached_wait_node");
	
	switch(level.halftracksSpawned)
	{
		case 1:
			//"Halftrack moving towards the west breach!!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_halftrack_west1");
			break;
		case 2:
			//"Get to the west breach!!! Halftrack movin' in!!!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_halftrack_west2");
			break;
		case 3:
			//"Halftraaack - coming - up - the - west sloooope!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_halftrack_west3");
			break;
	}
}

dialogue_tank_spotted()
{
	node = getvehiclenode(self.target, "targetname");
	
	while(1)
	{
		if(!isdefined(node.target))
		{
			return;
		}
		
		if(!isdefined(node.script_namenumber))
		{
			node = getvehiclenode(node.target, "targetname");
			continue;
		}
			
		if(node.script_namenumber == "tank_spotted")
		{
			break;
		}
	}
	
	if(!isdefined(node.script_namenumber))
		return;
	
	self setwaitnode(node);
	self waittill ("reached_wait_node");
	
	switch(level.tanksSpawned)
	{
		case 1:
			//"TIGER TANK!!!!! Kraut armor comin' up the north slope!!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_tigernorth1");
			wait 5;
			//"What the hell are we supposed to do against that thing???"
			thread dialogue_nearby_friendly_queue("hill400_defend_tigernorth2");
			break;
		case 2:
			//"Tiger tank moving up the north slope!!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_tanknorth1");
			wait 4;
			//"Tiger tank movin' up the north slooope!!!"
			thread dialogue_nearby_friendly_queue("hill400_defend_tanknorth2");
			break;
	}
}

//**************************************//
//		  ANIMATION UTILITIES			//
//**************************************//

atmosphere_wounded_characters()
{
	//nodes = getnodearray("wounded","targetname");
	nodes = getentarray("wounded","targetname");
	assert(isdefined(nodes[0]));
	
	maps\_names::setup_variables();
	
	for (i=0;i<nodes.size;i++)
	{
		assert(isdefined(nodes[i].script_noteworthy));
		
		//spawn the wounded soldier and place him at this node
		wounded_guy = character_nonAI_spawn();
		wounded_guy UseAnimTree(level.scr_animtree["wounded"]);
		wounded_guy.animname = "wounded";
		wounded_guy.origin = nodes[i].origin;
		wounded_guy.script_noteworthy = randomint(3);
		
		//determine which wounded animation set to use
		animName = nodes[i].script_noteworthy;
		assert(isdefined(level.scr_anim["wounded"][animName]));
		
		assert(isdefined(animName));
		wounded_guy thread atmosphere_wounded_think(animName, nodes[i]);
		
		if(!isdefined(nodes[i].script_commonname))
			continue;
		
		//if(nodes[i].script_commonname == "backroom")
		wounded_guy thread atmosphere_wounded_remove();
	}
}

atmosphere_wounded_think(animName, node)
{
	randomfloat(3);
	assert(isdefined(self.script_noteworthy));
	self thread anim_loop_solo (self, animName, undefined, "stop_wounded_anim", node);
}

atmosphere_wounded_remove()
{
	flag_wait("bunkersealed");
	self notify ("stop_wounded_anim");
	self delete();
}

character_nonAI_spawn(type, location, lowRes)
{
	//-----------------------------------------------------------------------------------
	//create a character using the valid bodys, heads, helmets, and other attached models
	//-----------------------------------------------------------------------------------
	if (!isdefined(location))
		location = (0,0,0);
	if (!isdefined(lowRes))
		lowRes = false;
	guy = spawn ("script_model", location );
	
	if (!isdefined(type))
		type = "ranger";
	
	if (type == "british")
		guy character\british_duhoc_driver::main();
	else
	if (type == "medic")
		guy character\american_ranger_medic_wells::main();
	else
	if (type == "radioguy")
		guy character\american_ranger_radio::main();
	else
	if (type == "ranger")
	{
		if (lowRes)
			guy character\american_ranger_normandy_low::main();
		else
			guy character\american_ranger_normandy::main();
	}
	else
	if (type == "randall")
		guy character\american_ranger_randall::main();
	
	assert(isdefined(guy));
	guy.targetname = "drone";
	
	guy makeFakeAI();
	guy thread maps\_utility::detectFriendlyFire(1);
	
	game["americannames"]++;
	guy maps\_names::get_american_name();
	assert(isdefined(guy.name));

	guy setlookattext(guy.name, &"HILL400_DEFEND_WOUNDED_IN_ACTION");
	
	//guy drones_clear_variables();
	
	return guy;
}


//******************************//
//		  MUSIC UTILITIES		//
//******************************//

music_intro()
{
	musicplay("hill400_defend_badtimes");
	wait 45;
	musicstop(15);
}

music_timer()
{
	//wait (level.thirdWaveDuration + 1);
	//flag_wait("falling_back");
	flag_wait("cue_end_music");
	//wait 1;
	musicplay("hill400_mustangs");
}

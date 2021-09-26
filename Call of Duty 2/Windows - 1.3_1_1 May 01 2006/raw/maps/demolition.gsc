#include maps\_utility;
#include maps\_anim;
#using_animtree ("generic_human");
main()
{	
	/*
	
		tank_target	
		tank_display
		waitnode_1
		waitnode_2
	*/
	// debugging for grenades that get generated at the player
	/*
	ai = getspawnerarray();
	for (i=0;i<10;i++)
	{
		if (!issubstr(ai[i].classname, "axis"))
			continue;
			
		ai[i] dospawn();
	}
	array_thread(getentarray("hide_grenade", "targetname"), ::triggerGrenades);
	thread moveplayer();
	*/
//	thread showignoreme();
	setCullFog(1000, 4500, 156/256, 158/256, 148/256, 0);
	setExpFog(0.000145, 156/256, 158/256, 148/256, 0);
	level.fastVersion = getcvar("scr_demolition_fast") == "1";
//	level.fastVersion = 1;

	level.showExploder = false;
	level.showExploder = true;
//	setCullDist (5000);
//	setcvar("cg_hudCompassMaxRange","1000");
	
	setsavedcvar("cg_hudCompassMaxRange", "700");
//	maps\demo_fx::main(); 
	level.movelength = 200;
	hideBuildingParts();
//	getent ("demo_start","targetname") hide();
//	getent ("demo_4","targetname") hide();

/*
	level.objText1 = "Rendezvous with the defensive line at Solechnaya St.";
	level.objText2 = "Repulse the German attack.";
	level.objText3 = "Clear out the German hardpoint on the far side of the intersection.";
	level.objText4 = "Rendezvous with Commissar Letlev.";
	level.objText5 = "Obtain explosives from the engineer.";
	level.objText6a = "Plant explosives throughout the building. (3 remaining).";
	level.objText6 = "Plant explosives throughout the building. ( remaining).";
	level.objText7 = "Get to a safe distance.";
	*/

	precacheItem("smoke_grenade_american");
	precacheShader("inventory_tnt_large");
	precacheString(&"DEMOLITION_OBJ_1");
	precacheString(&"DEMOLITION_OBJ_2");
	precacheString(&"DEMOLITION_OBJ_3");
	precacheString(&"DEMOLITION_OBJ_4");
	precacheString(&"DEMOLITION_OBJ_5");
	precacheString(&"DEMOLITION_OBJ_6a");
	precacheString(&"DEMOLITION_OBJ_6");
	precacheString(&"DEMOLITION_OBJ_7");
	
	level.objText1 = &"DEMOLITION_OBJ_1";
	level.objText2 = &"DEMOLITION_OBJ_2";
	level.objText3 = &"DEMOLITION_OBJ_3";
	level.objText4 = &"DEMOLITION_OBJ_4";
	level.objText5 = &"DEMOLITION_OBJ_5";
	level.objText6a= &"DEMOLITION_OBJ_6A";
	level.objText6 = &"DEMOLITION_OBJ_6";
	level.objText7 = &"DEMOLITION_OBJ_7";

	
	level.mortar = loadfx ("fx/explosions/large_snow_explode1.efx");
	aitype\ally_rus_reg_ppsh::precache();
	aitype\axis_snow_wehr_reg_kar98k::precache();
	level.drone_spawnFunction["allies"] = aitype\ally_rus_reg_ppsh::main;
	level.drone_spawnFunction["axis"] = aitype\axis_snow_wehr_reg_kar98k::main;
	precacheModel("xmodel/military_tntbomb");
	precacheModel("xmodel/tag_origin");
	maps\_drones::init();	
	maps\_panzer2::main("xmodel/vehicle_panzer_ii_winter");
	maps\_stuka::main("xmodel/vehicle_stuka_flying");
	maps\demolition_fx::main();
	maps\_load::main();
	maps\demolition_anim::main();
	setEnvironment ("cold");

	flag_init("start_explosives");
	flag_init("axis_reinforce");
	flag_init("chargeBegins");
	flag_init("axis_retreat");
	flag_init("tnt_objective");
	flag_init("move_out");
	flag_init("germans_retreat");
	flag_init("tanks_done");
	flag_init("start_toss");
	flag_init("tanks_over_trench");
	flag_init("engineers_run_up");
	flag_init("tossed_tnt");
	flag_init("here_they_come");
	flag_init("hold_the_line");
	flag_init("attack_hardpoint");
	flag_init("trench_guys_start");
	flag_init("delete_trench_guys");
	flag_init("hit_end_trigger");
	flag_init("chunk_falls");
	flag_init("explosion_done");
	flag_init("autosave1");
	flag_init("autosave2");
	flag_init("autosave3");
	flag_init("autosave4");
	flag_init("autosave5");
	flag_init("autosave6");
	flag_init("autosave7");
	flag_init("stop_hardpoint_spawners");
	flag_init("discussion_begins");
	flag_init("get_tnt_objective");
	flag_init("demolition_team_on_the_way");
	flag_init("german_demoralizing_chatter");
	flag_init("german_demoralizing_chatter2");
	flag_init("grenade_player");
	flag_init("axis_attacks_player");
	flag_init("defend_sequence_begins");
	flag_init("bino_hint");

	flag_init("hint_get_explosives");
	flag_init("hint_plant_explosives");
	flag_init("hint_plant_explosives_singular");
	flag_init("hint_plant_explosives_plural");
	flag_init("hint_use_explosives");
	flag_init("hint_height_above");
	
	
	
	level thread maps\demolition_amb::main();
	level thread music_tensionfragments();
	level thread music_tanktrench();
	level thread music_awaitingattack();
	level thread tankEarthQuake();
	// this is the trigger for the axis drones later in the level.
	level.axis_trigger = getTargetNote2("drone_axis", "axis_attack");
	level.axis_trigger triggerOff();

	getent ("trench_follow_guy","targetname") thread trenchFollowGuySetup();
	getent ("german_pa_trigger","targetname") thread germanPATrigger(); // triggers german demoralizing broadcasts
	getent ("stop_german_pa_trigger","targetname") thread stopGermanPATrigger(); // stops first broadcast
	array_thread (getentarray("squad", "targetname"), ::squadThink);
	array_thread (getentarray("delete","targetname"), ::deleter);
	array_thread (getentarray("zero_accuracy","script_noteworthy"), ::allyDefenderSpawner);	
	array_thread (getentarray("savepoint","targetname"), ::savePoint);
	array_thread (getentarray("plane_trigger","targetname"), ::planeThink);
	array_thread (getentarray("drone_allies","targetname"), ::droneAlliesThink);
	array_thread (getentarray("axis_flee","targetname"), ::axisFleeTrigger);
	array_thread (getentarray("delayed_spawner","targetname"), ::delayedSpawner);
	array_thread (getentarray("cullfog_enable","targetname"), ::cullfogEnable);
	array_thread (getentarray("cullfog_disable","targetname"), ::cullfogDisable);

	array_thread (getentarray("objective_hint","targetname"), ::objectiveHintTrigger);
	
	// delayed friendly chains
	array_thread (getentarray("friendly_forcetrigger","targetname"), ::friendlyForcetrigger);
	
	getent ("waver_trigger","targetname") thread waveTrigger(); // makes guys with script noteworthy waver wave as they run through
	getent ("attack_hardpoint", "targetname") thread attackHardpoint(); // final friendly chain triggers
	getent ("binocular","targetname") thread binocular_hint();
	getent ("player_blocker","targetname") thread playerBlocker(); // blocks the player from getting stuck at last sequence
	setupTnt();
	thread smgGuy();
	getent ("tank_display","targetname") thread tankDisplay(); // tank you can see with the binoculars
	
	// ending bomb triggers
	bombLeft = getent ("bomb_use_left","targetname");
	bombRight = getent ("bomb_use_right","targetname");
	bombLeft triggerOff();
	bombRight triggerOff();

	if (getcvar("start") != "start")
		setcvar("debug_nuke","on");

	if (getcvar("start") == "end")
	{
		pre_ending();
		return;
	}

	if (getcvar("start") == "tank" || getcvar("start") == "defend")
	{
		wait (0.05);
		level.player setorigin (getent("tank_origin","targetname").origin);
		getent("german_pa_2","targetname") thread germanDemoralizingChatter("german_demoralizing_chatter2");
		tank();
		return;
	}

	if (getcvar("start") == "boom")
	{
		buildingStart();
		return;
	}

	battleChatterOff( "allies" );
	getent ("german_pa_1","targetname") thread germanDemoralizingChatter("german_demoralizing_chatter");
	
	// "Rendezvous with the defensive line at Solechnaya St."
	objective_add(1, "active",  level.objText1, getent("obj1","targetname").origin);
	objective_current(1);

	// sends Germans running back to nodes
	getent ("flee","targetname") thread fleeTrigger();
	getent ("new_friendlies","targetname") thread newFriendlies();

	// this chain enables when the office is clear of Germans
	thread officeFriendlyChain();	
	
	tank();
}

trenchFollowGuy()
{
	spawn = self dospawn();
	if (spawn_failed(spawn))
		assert(0);
		
	spawn setgoalentity (level.player);
	spawn endon ("death");
	spawn.dontavoidplayer = true;
	flag_wait("tanks_done");
	spawn.dontAvoidPlayer = false;
}

trenchFollowGuySetup()
{
	self waittill ("spawned",spawn);
	level.trenchFollowGuy = spawn;
	spawn thread magic_bullet_shield();
	getent (self.targetname,"target") waittill ("trigger");
	node = getnode (spawn.target,"targetname");
	idleNode = spawn("script_origin",(0,0,0));
	idleNode.origin = node.origin;
	idleNode.angles = node.angles + (0,-90,0);
	spawn.dontavoidplayer = true;
	spawn.animname = "trench_guy";
	idlenode thread anim_loop_solo (spawn, "idle", undefined, "stopLoop");
	wait (1);
	idlenode notify ("stopLoop");
	node anim_single_solo(spawn, "this_way");	
	spawn.animname = undefined;
//	node thread anim_loop_solo (spawn, "idle", undefined, "stopLoop");
	flag_wait("tanks_done");
	spawn.dontAvoidPlayer = false;
	
}

tankSoundDelete()
{
	flag_wait ("tanks_over_trench");
	self delete();
}

distantTankRumble()
{
	level endon ("tanks_over_trench");
//	start = level.struct_targetname["tank_sound"][0];
	start = getent ("tank_sound","targetname");
	ent = spawn("script_model",start.origin);
//	ent setmodel ("xmodel/temp");
	ent thread tankSoundDelete();
	targ = getent(start.target,"targetname");
	angles = vectortoangles(targ.origin - ent.origin);
	forward = anglestoforward(angles);
	dist = distance(ent.origin, targ.origin);
	timer = 5;
	steps = dist /(timer*20); 

	forward = vectorscale(forward, steps);	
	
	
	for (i=0;i < timer*20;i++)
	{
		ent.origin += forward;
		ent playloopsound("panzer2_engine_manual");
		wait (0.05);
	}
}
	
tank()
{
	friendlyChainTrigger = getent ("trench_friendly_trigger","targetname");
	friendlyChainTrigger triggerOff();
	chain_node = getnode(friendlyChainTrigger.target, "targetname");
	
	getent ("tank_trigger","targetname") thread deleteTanks();
	getent ("trench_follow_guy","target") waittill ("trigger");
	flag_set ("trench_guys_start");
	
	guy[0] = getentarray("wounded_drag","targetname")[0] dospawn();
	guy[1] = getentarray("wounded_drag","targetname")[1] dospawn();
	if (spawn_failed(guy[0]))
		assert(0);
	if (spawn_failed(guy[1]))
		assert(0);
		
	guy[0].animname = "wounded_puller";
	guy[1].animname = "wounded_dragged";
	guy[0].health = 50000;
	guy[1].health = 50000;
	level.dragGuys = guy;
	node = getent("drag_guy","targetname");
	
	node thread anim_loop(guy, "start_idle", undefined, "stopIdle");

//	trigger = getent("trench_friendly_trigger","targetname");
//	trigger waittill ("trigger");

	// trigger that makes the guys in the trench follow
	getent ("trenchguys_start","targetname") thread trenchGuys(chain_node);

	
	trigger = getent("tank_start","targetname");
	trigger waittill ("trigger");
	trigger delete();

	thread distantTankRumble();	
	
	node notify ("stopIdle");
	guy[0] thread snowSound();
	node anim_single(guy, "drag_start");
	guy[0] notify ("stopSnowSound");

	trigger = getent("tank_start2","targetname");
	node thread anim_loop(guy, "middle_idle", undefined, "stopIdle");
	if (!level.player istouching (trigger))
		trigger waittill ("trigger");
	flag_set ("german_demoralizing_chatter2"); // stops the propaganda

	trigger delete();
	getent ("trench_sound","targetname") playsound ("demolition_trenchtanks");
	wait (1);
	flag_set("tanks_over_trench");

	node notify ("stopIdle");
	guy[0] playsound ("dragsoldier_snow2");
	node thread anim_single(guy, "drag_end");
	node thread dragLoop(guy);
	wait (2);

	getent("vehicle_delete","targetname") thread vehicleDelete();
	getent("brush_delete1","targetname") thread brushDelete();
	getent("brush_delete2","targetname") thread brushDelete();
	getent("exploder_effect7","targetname") thread exploderTrigger(7, 0.3);
	getent("exploder_effect8","targetname") thread exploderTrigger(8, 0.55);

	thread tankSpawnerSound();
	triggers = getentarray("vehicle_trigger","targetname");
	thread tankOverpass(triggers, 2);
	wait (1.4);
	triggers = getentarray("vehicle_trigger2","targetname");
	thread tankOverpass(triggers, 3);
	
	maps\_utility::autosave(1);
	thread defend();
	
	/*
	flag_wait("delete_trench_guys");
	node notify ("stopIdle");
	for (i=0;i<guy.size;i++)
		guy[i] delete();	
	
	*/
}

snowSound()
{
	self endon ("stopSnowSound");
	for (;;)
	{
		self playsoundontag ("dragsoldier_snow","tag_origin");
		wait (randomfloat(0.5) + 0.15);
	}
}


dragLoop(guy)
{
	self waittill ("drag_end");
	self thread anim_loop(guy, "end_idle", undefined, "stopIdle");
}

attackAccuracy()
{
	self endon ("death");
	flag_wait ("axis_retreat");
	self.accuracy = 1;
	self.baseaccuracy = 1;
}

allyDefenderSpawner()
{
	level endon ("axis_retreat");
	for (;;)
	{
		self waittill ("spawned",spawn);
//		assert(0);
		spawn_failed(spawn);
		spawn zeroAccuracy();
	}
}

zeroAccuracy()
{
	self.accuracy = 0;
	self.baseaccuracy = 0;
	self thread attackAccuracy();
}

deleteAxisTrigger()
{
	// deletes the guys that flee to the building
	trigger = getent ("defend_delete_trigger_player","targetname");
	for (;;)
	{
		self waittill ("trigger",other);
		if (level.player istouching (trigger))
			continue;
		other doom();
	}
}

checkPlayerTouchedEscapeStopper()
{
	self waittill ("trigger");
	flag_set("player_touched_escape_stopper");
	while (level.player.origin[0] < 715 || level.player istouching (self))
		wait (0.05);

	// delete nonessential friendlies in the west
	deleteAIwestOf(getent("delete_line","targetname").origin[0], level.buddies);
}

defendFriendlies(buddies)
{
	// 4 good friends that get caught up and sent on a whirlwind adventure, afterwhich an explosion occurs
	// that stops the player from backtracking.
	
	// record who touches the trigger in case both try to trigger on the same frame
	buddyTouch = [];
	for (i=0;i<buddies.size;i++)
		buddyTouch[i] = false;
		
	flag_clear("player_touched_escape_stopper"); // monitors if the player has entered the defend area
	trigger = getent ("escape_stopper","targetname");
	trigger thread checkPlayerTouchedEscapeStopper();
	
	for (;;)
	{
		self waittill("trigger", other);
//		assertEx(isalive(other), "should be impossible for a dead guy to hit this trigger");
		allTouched = true;
		for (i=0;i<buddies.size;i++)
		{
			if (buddyTouch[i])
				continue;
			if (buddies[i] istouching (self))
				buddyTouch[i] = true;
			else
				allTouched = false;
		}
		
		if (allTouched)
			break;
	}
	
	self delete();

	flag_wait("player_touched_escape_stopper"); // otherwise the player may still be hanging out in the trench
	
	// wait until the player is no longer able to see the wall collapse
	while (level.player istouching (trigger))
		wait (0.05);
		
	flag_wait("defend_sequence_begins");
	
	org = getent ("delete_line","targetname").origin[0];
	if (level.player.origin[0] < org)
	{
		// if the player is west of the collapse point he dies
		level.player maps\_mortar::activate_mortar (500, 5000, 5000, 1, 4, 500, false);
		wait (0.5);
		level.player dodamage(level.player.health,(0,0,0));
	}
		
	
	exploder(0); // wall collapses
	
		
	for (i=0;i<buddies.size;i++)
	{
		if (!isalive(buddies[i]))
			continue;
		buddies[i] notify ("stop magic bullet shield");
	}

}

disablePlayerIgnoreme()
{
	// trigger midfield that lets the Germans shoot at the player if he leaves the defend area.
	self waittill ("trigger");
	level.player.ignoreme = false;
}

startGermanChatter()
{
	level endon ("stopGerman_preparationChatter");
	base = 2;
	range = 1.5;
	for (;;)
	{
		exploder(70);
		wait (base + randomfloat (range));
		exploder(71);
		wait (base + randomfloat (range));
		exploder(72);
		wait (base + randomfloat (range));
	}
}

defend()
{
	thread axisAttackPlayerTrigger();
	thread startGermanChatter();
	level.player.ignoreme = true;
	level.sightBlock = getent("sightblock","targetname");
	level.sightBlock thread disablePlayerIgnoreme();

	battleChatterOff( "allies" );
	trigger = getent("friendly_catcher","targetname");
	trigger waittill ("trigger");
	array = getArrayOfClosest(level.player.origin, getaiarray("allies"), level.dragGuys);
	buddies = [];
	for (i=0;i<4;i++)
	{
		array[i] setgoalentity (level.player);
		array[i] notify ("stop magic bullet shield"); // in case he was a previously shielded guy
		waittillframeend; // because otherwise he'll get his old health after getting the shield health
		array[i] thread magic_bullet_shield();
		buddies[i] = array[i];
	}
	for (i=4;i<array.size;i++)
	{
		array[i] setgoalpos (array[i].origin);
		array[i].goalorigin = 64;
	}
	level.buddies = buddies;
	getent("escape_catcher","targetname") thread defendFriendlies(buddies);
	thread setupRetreatNodes(); // the arrays of nodes the axis will retreat to

	// triggers that specify nodes that the Germans will later use to retreat
//	thread axisReinforceTriggers();
	
	flag_clear ("friendly_wave_spawn_enabled");

	trigger = getent ("start_axis_attackers","targetname");
//	trigger waittill ("trigger");
	trigger delete();

	flag_clear("defend_dialogue_trigger_2");	
	flag_clear("defend_dialogue_trigger_3");	
	thread handleRemoveandSpawnofAI();


	node = getnode("stove_node","targetname");
	trigger = getent("defend_dialogue","targetname");
	trigger waittill ("trigger");

	letlev = getent("letlev","targetname") commissarThink("letlev");
	commissar = getent("commissar","targetname") commissarThink("commissar");
	level.commissar = commissar; // used later for demolition sequence

	node anim_teleport_solo (commissar, "stay");
	spawn_failed(Commissar);
	commissar setgoalpos (commissar.origin);
	trigger thread defendDialogueTriggerWait();
	speaker = getent ("defend_dialogue_speaker_1","targetname");
	speaker playsound ("demolition_rs1_massing", "sounddone");
	speaker waittill ("sounddone");
	maps\_utility::autosave(2);
	
	flag_wait("defend_dialogue_trigger_2");	
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
		ai[i].ignoreme = true;

	speaker = getent ("defend_dialogue_speaker_2","targetname");
//	timer = gettime();
	flag_set ("hold_the_line");
	
	speaker playsound ("demolition_rs3_toofew", "sounddone");
	wait (2.6);
//	speaker waittill ("sounddone");
//	println ("timer :", ((gettime() - timer) * 0.001));
	flag_wait("defend_dialogue_trigger_3");
	
	flag_set("defend_sequence_begins");
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
		ai[i].pacifist = true;

	
//	node anim_reach_solo (commissar, "stay");
//	“Stay where you are! We will hold this position until help arrives! The aid station on Solechnaya Street 
//	is counting on us to stop the fascists!”	
//	node anim_reach_solo (commissar, "stay");
	node thread anim_single_solo (commissar, "stay");
	node thread commissar_idle(commissar);
	
	
//	level.player.team = "axis";
//	level.player.threatbias = 151221;
	wait (10);
	exploder(51); // german Walla
	org = getent ("delete_line","targetname").origin[0];
	while (level.player.origin[0] < org)
		wait (0.05);
	thread smokeStart();
	

	objective_state(1, "done");
	
	// "Repulse the German attack."
	objective_add(2, "active", level.objText2, getent("obj1","targetname").origin);
	objective_current(2);

	thread nearestGenericAllyLine("hold_line");
	
//	getent ("defend_delete_trigger","targetname") thread deleteAxisTrigger();
	/*
	trigger = getent ("defend_prepare","targetname");
	trigger waittill ("trigger");
	trigger delete();
	*/
	if (!flag("axis_attacks_player"))
		maps\_utility::autosave(2);
	

	thread axisDefendTrigger();
	level.chargeIndex = 0;
//	iprintlnbold ("It's been two days of hard fighting. The German's final push is about to begin. Prepare yourself!");


	
	wait (8);
	level notify ("stopGerman_preparationChatter");
	node notify ("stopLoop");
	node anim_reach_solo (commissar, "steady");
	node anim_single_solo (commissar, "steady");
	
	flag_set ("chargeBegins");
//	level.sightBlock connectpaths();
	level.sightBlock delete();
	

	// turn on the drones
	thread axisDrones();	

//	wait (2);
	thread mortarWave(getent("german_mortar","targetname"));
	flag_set("delete_trench_guys");
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		ai[i] zeroAccuracy();
		ai[i].anim_forced_cover = "show";
	}
//	wait (3);
//	Letlev commissar_charge_ready (screaming up and down the line) 
//  "Comrades!!!! For the Soviet Union, and for your glorious Motherlaaaand...Get readyyyyy!!!!" 
	letlev anim_single_solo (letlev, "ready");
	wait (1.5);
	//	Here they cooome!!! Open fire!!!!!	
	thread nearestGenericAllyLine("open_fire");
//	wait (0.5);
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		ai[i].pacifist = false;
		ai[i].ignoreme = false;
	}
	level.player.ignoreme = false;
	wait (3);
	battleChatterOn( "allies" );
	wait (2);
	
	flag_set ("here_they_come");
	wait (1);
	
	if (!flag("axis_attacks_player"))
		maps\_utility::autosave(2);
	
	// toss grenades at the player if he's hiding
	array_thread(getentarray("hide_grenade", "targetname"), ::triggerGrenades);
	letlev thread anim_single_solo (letlev, "no_falling_back");
	/*
	letlev anim_single_solo (letlev, "attack");
	letlev anim_single_solo (letlev, "keep_forward");
	*/
	wait (4);
	letlev thread anim_single_solo (letlev, "kill_fascists");
	wait (4);
	thread axisSecondWave(getentarray("axis_second_wave","targetname"));
	wait (5);
	letlev thread anim_single_solo (letlev, "cowards_executed");
	wait (10);
	flag_set ("axis_reinforce");
	
//	wait (20);
	flag_wait ("germans_retreat");
	level.fallback = 1;
	level.player_fallback = 1; // fallback the player has actually triggered
	flag_set ("axis_retreat");
	thread axisDefenderSpawners(); // guys that spawn from the hardpoint and fill in the current defend spot
	// triggers that stop the defenders from spawning
	array_thread(getentarray("stop_axis_defenders","script_noteworthy"), ::stopAxisDefenders);
	
	wait (3);
//	iprintlnbold ("They're falling back!");
	node anim_reach_solo (commissar, "charge");
	exploder(50); // russian Walla
	

	thread allyBuildingTrigger();	
//	level.allyCounterAttackers = 7;
	level.alliesCounter = 7;
	thread alliesCounterSpawners(); // spawns allies from various spawners
	array_thread(getentarray("increase_allies","script_noteworthy"), ::increaseAllies);
	chain_node = getnode("charge_chain", "targetname");
	level.player setfriendlychain(chain_node);
	allies = getaiarray("allies");
	// reverse chain of script origins
	for (i=0;i<allies.size;i++)
	{
		allies[i] setgoalentity (level.player);
		allies[i].anim_forced_cover = "none";
	}

	node thread anim_single_solo (commissar, "charge");
	letlev thread anim_single_solo_delayed (3, letlev, "attack");

	// friendly chain triggers that control the flow of battle
	array_thread (getentarray("reinforce_trigger","targetname"), ::reinforceTrigger);
/*		
	node = getentarray("counter_attack","script_noteworthy");
	index = 0;
	for (i=0;i<allies.size;i++)
	{
		allies[i] thread reverseChain(node[index]);
		index++;
		if (index >= node.size)def
	}
*/	
	thread ending();
	wait (1);
	thread nearestGenericAllyLine("for_russia");
	
	wait (15);
	letlev anim_single_solo (letlev, "keep_forward");
}

alliesCounterSpawners()
{
	spawners = getentarray ("defenders_counter","targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] endon ("death");
		
	// spawners that spawn counter attack ally guys
	// they have a trigger that deactivates them if the player is touching the trigger
	index = 0;
	for (;;)
	{
		wait (1);
		if (getaiarray("allies").size >= level.alliesCounter)
			continue;

		index++;
		if (index >= spawners.size)
			index = 0;
		spawner = spawners[index];
			
		trigger = undefined;
		if (isdefined(spawner.target))
			trigger = getent(spawner.target,"targetname");

		if (isdefined(trigger) && level.player istouching (trigger))
			continue;
		
		spawner.count = 1;
		spawn = spawner dospawn();
		if (spawn_failed(spawn))
			continue;
		
//		spawn thread counterAttack();
		spawn setgoalentity (level.player);
	}
	
}

/*
counterAttack()
{
	level.allyCounterAttackers--;

	// spawned guy that attacks German side
	nodes = getentarray("counter_attack","script_noteworthy");
	node = getclosest(self.origin, nodes);
	thread reverseChain(node);
	
	self waittill ("death");
	level.allyCounterAttackers++;
}
*/

allyBuildingTrigger()
{
	level endon ("attack_hardpoint");
	// a trigger the friendlies hit that causes them to run to a spot from which they can attack the building
	trigger = getent ("attack_building","targetname");
	nodes = getnodearray (trigger.target,"targetname");
	for (;;)
	{
		trigger waittill ("trigger", other);
		other notify ("reached_end", random(nodes));
	}
}

onEndSetGoal()
{
	self endon ("end_sequence");
	self endon ("death");
	self waittill ("reached_end",node);
	if (flag("attack_hardpoint"))
		return;
	self.goalradius = node.radius;
	self setgoalnode (node);
}

reverseChain(node)
{
	self endon ("death");
	reverseChainFunc(node);
	flag_wait("attack_hardpoint");
	self setgoalentity (level.player);
}

reverseChainFunc(node)
{
	// allies run back up the axis chain and attack their HQ
	ent = getent ("ally_threat","targetname");
	self endon ("reached_end");
	
	self thread onEndSetGoal();
	self.goalradius = 512;
	self.pathenemyfightdist = 500 + randomfloat (400);
	self.pathenemylookahead = 500 + randomfloat (400);
	
	for (;;)
	{
		yaw = VectorToAngles(ent.origin - node.origin);
		self setpotentialthreat(yaw[1]);
//		println ("set yaw " + yaw[1] + " from position " + node.origin);
		self setgoalpos (node.origin);
		self waittill ("goal");
		node = getent (node.targetname,"target");
		if (!isdefined(node))
			break;
	}
}

smokeTrigger()
{
	// triggers smoke the first time an AXIS touches it
	self waittill ("trigger", other);
	throwSmoke(other.origin, other);
}

smokeGen()
{
	smokers = getentarray("smoker","targetname");
	for (i=0;i<smokers.size;i++)
	{
		ai = getclosest(smokers[i] getorigin(), getaiarray("axis"));
		assert (isalive(ai));
		smokers[i] throwSmoke(smokers[i].origin, ai);
		wait (0.5 + randomfloat(0.5));
	}
}

throwSmoke(origin, ai)
{	
	org = getent (self.target,"targetname").origin;
	if (!isdefined(ai.oldGrenadeWeapon))
		ai.oldGrenadeWeapon = ai.grenadeWeapon;
		
	ai.grenadeWeapon = "smoke_grenade_american";
	ai.grenadeAmmo++;
	
	ai MagicGrenade (origin + (0,0,50), org, 2.5);
	ai.grenadeWeapon = ai.oldGrenadeWeapon;
}

spawnAttack()
{
	// guys that spawn and setup an offensive field of fire so the other attackers can make it in

	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;

	spawn endon ("death");
	spawn attackerSettings();
	spawn setgoalpos (spawn.origin);
	flag_wait ("chargeBegins");
	spawn moveToNodeOrAttackPlayerUntilRetreat();
	spawn spawnRetreat();
}

moveToNodeOrAttackPlayerUntilRetreat()
{
	level endon ("axis_retreat");
	for (;;)
	{
		if (flag("axis_attacks_player"))
		{
			self setgoalentity (level.player);
			flag_waitopen("axis_attacks_player");
		}
		else
		{
			self setgoalnode (getnode(self.target,"targetname"));
			flag_wait("axis_attacks_player");
		}
	}
}

attackerSettings()
{	
	self.pathEnemyFightDist = 1050;
	self.pathEnemyLookAhead = 1050;
	if (self.suppressionwait != 0)
		self.oldsuppressionwait = self.suppressionwait;

	self.suppressionwait = 0;
}

axisAttackPlayerTrigger()
{
	// triggers if the player gets too far west, makes the AI super deadly to the player
	level endon ("germans_retreat");
	trigger = getent ("axis_retreat_trigger","targetname");
	x = trigger getorigin()[0];
	thread monitorAttackFlag();
	for (;;)
	{
		trigger waittill ("trigger");
		flag_set ("axis_attacks_player");
		for (;;)
		{
			wait (0.05);
			if (level.player.origin[0] > x)
				continue;
			if (level.player istouching (trigger))
				continue;
			break;
		}
		flag_clear ("axis_attacks_player");
	}
}
		
monitorAttackFlag()
{
	threatbias = level.player.threatbias;
	monitorAttackFlagUntilGermansRetreat();
	flag_clear ("axis_attacks_player");
	level.player.threatbias = threatbias;
}	

monitorAttackFlagUntilGermansRetreat()
{
	level endon ("germans_retreat");
	threatbias = level.player.threatbias;

	for (;;)
	{
		flag_wait ("axis_attacks_player");
		level notify ("new_attack_flag_spawner");
		spawners = getspawnerarray();
		array_thread (spawners, ::attackFlagSpawner);
		ai = getaiarray("axis");
		array_thread (ai, ::attackFlagAI);
		level.player.threatbias = 10532;
		
		flag_waitopen ("axis_attacks_player");
		level.player.threatbias = threatbias;
	}
}		

attackFlagAI()
{
	if (isdefined(self.attackFlagSet))
		return;
		
	self endon ("death");
	self.attackFlagSet = true;
	fightdist = self.pathenemyfightdist;
	maxdist = self.pathenemylookahead;
	baseaccuracy = self.baseaccuracy;

	waittillframeend; // so we set stuff after spawnaxisattack sets it
	useSpecialFightDistWhileNotRetreating();	

	self.pathenemyfightdist = fightdist;
	self.pathenemylookahead = maxdist;
	self.baseaccuracy = baseaccuracy;
}

useSpecialFightDistWhileNotRetreating()
{
	level endon ("germans_retreat");
	fightdist = self.pathenemyfightdist;
	maxdist = self.pathenemylookahead;
	baseaccuracy = self.baseaccuracy;
	
	for (;;)
	{
		flag_wait ("axis_attacks_player");
		self.pathenemyfightdist = 600;
		self.pathenemylookahead = 8024;
		self.baseaccuracy = 4;
		flag_waitopen("axis_attacks_player");
		self.pathenemyfightdist = fightdist;
		self.pathenemylookahead = maxdist;
		self.baseaccuracy = baseaccuracy;
	}
}

attackFlagSpawner()
{
	level endon ("germans_retreat");
	level endon ("new_attack_flag_spawner");
	self endon ("death");
	
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (!flag ("axis_attacks_player"))
			return;
		if (spawn_failed(spawn))
			continue;
		if (spawn.team == "allies")
			continue;
		spawn thread attackFlagAI();
	}
}
		
axisDefendTrigger()
{
	level endon ("axis_reinforce");
	trigger = getent ("axis_retreat_trigger","targetname");
	trigger waittill ("trigger");
	flag_set ("axis_reinforce");
}

/*
axisReinforce()
{
	// the AI that fill in the area when the player moves in 
	flag_wait ("axis_reinforce");
	if (isdefined (level.sightBlock))
	{
		level.sightBlock connectpaths();
		level.sightBlock delete();
	}
	spawners = getentarray("axis_retreat_defender","targetname");
	nodes = getnodearray ("reinforce_node","targetname");
	index = 0;
	for (i=0;i<nodes.size;i++)
	{
		index++;
		if (index >= spawners.size)
			index = 0;
		spawner = spawners[index];
		
		spawner.count = 1;
		spawn = spawner dospawn();
		if (spawn_failed(spawn))
		{
			wait (0.5);
			continue;
		}
		
		nodes[i] thread reinforceNode(spawners, spawn);
		wait (0.25);
	}
}

reinforceNode(spawners, spawn)
{
	// guys that spawn and take up various positions so you have to fight your way to the hardpoint
	for (;;)
	{
		spawn setgoalnode (self);
		spawn.goalradius = self.radius;
		spawn attackerSettings();
		spawn waittill ("death");
		spawner = random(spawners);
		spawner.count = 1;
		for (;;)
		{
			// Stop executing once the player gets close to me
			if (level.player.origin[0] + 200 > self.origin[0])
				return;
			spawn = spawner dospawn();
			if (spawn_failed(spawn))
			{
				wait (0.25);
				continue;
			}
			break;
		}
	}
}
*/

spawnAwaitAttack()
{
	// Guys that spawn and charge the front line
	level endon ("axis_reinforce");
	maxGuys = 32; 
	if (level.fastVersion)
		maxGuys = 16; // mincpu cant handle so many ai!
	for (;;)
	{
		self.count = 1;
		if (getaiarray().size >= maxGuys)
			return;
		
		spawn = self dospawn();
		if (spawn_failed(spawn))
		{
			wait (1);
			continue;
		}
		spawn thread spawnAttacks();
		spawn waittill ("death");
	}
}

retreatNode_OccupierIncrement(num) // keep track of how many AI are "on" each set of retreat nodes
{
	level endon ("attack_hardpoint");
	
	if (level.player_fallback < level.fallback)
		return;

	level.retreatNode_Occupier[num]++;
	level.retreatNode_OccupierMax[num]++;
	waittillframeend; // in case you die in the same frame a bunch of guys are being added
	self waittill ("death");
	level.retreatNode_Occupier[num]--;
	if (level.player_fallback < level.fallback)
		return;
	if (level.retreatNode_OccupierMax[num] <= 4)
		return;
	if (level.fallback == 7)
		return;
		
	if (num != level.fallback)
		return;

	// flee if the group is below 40% strength
	if (level.retreatNode_Occupier[num] / level.retreatNode_OccupierMax[num] >= 0.4)
		return;

	level.fallback++;
	level notify ("new_retreat_node");
	if (!flag("autosave" + level.fallback))
	{
		autosave(7);
		flag_set("autosave" + level.fallback);
	}
	num = level.fallback;
	wait (1.5);
	if (num != level.fallback) // in case player has pushed AI even farther forward
		return;
		
	// AI charge forward chasing Germans
	triggers = getentarray ("reinforce_trigger","targetname");
	for (i=0;i<triggers.size;i++)
	{
		if (triggers[i].script_fallback_group != level.fallback)
			continue;
	
		node = getnode(triggers[i].target,"targetname");		
		level.player setfriendlychain(node);
		return;
	}

	/*
	assert(0);
	// removed some of th	
	for (i=0;i<triggers.size;i++)
	{
		if (triggers[i].script_fallback != level.fallback)
			continue;
	
		node = getnode(triggers[i].target,"targetname");		
		level.player setfriendlychain(node);
		return;
	}
	*/
}

spawnRetreat()
{
	// ai that attack then retreat
	self endon ("death");
	flag_wait ("axis_retreat");
	wait (randomfloat(5));
	if (level.fallback == 7)
		return;

	num = level.fallback;
		
	spawnRetreatThink(num);
}

defenderRetreat()
{
	// ai that defend and then fallback
	self endon ("death");
	flag_wait ("axis_retreat");
	if (level.fallback == 7)
		return;

	num = level.fallback;
	if (level.player_fallback >= level.fallback)
	{
		// if the player has progressed at least as far as the current level.fallback
		// then the spawning AI run to the next fallback line
		if (isdefined(level.retreatNodes[level.fallback+1]))
			num = level.fallback+1;
	}
		
	spawnRetreatThink(num);
}

nodeFallbackerIncrement(node)
{
	// track the amount of AI at a node
	node.fallbackers++;
	self waittill ("death");
	node.fallbackers--;
}


spawnRetreatThink(num)
{
	if (self.suppressionwait == 0)
		self.suppressionwait = self.oldsuppressionwait;

	self endon ("death");
	for (;;)
	{
		/*
		node = level.retreatNodes[num][level.retreatNodeIndex[num]];
		level.retreatNodeIndex[num]++;
		if (level.retreatNodeIndex[num] >= level.retreatNodes[num].size)
			level.retreatNodeIndex[num] = 0;
		*/
		
		// pick a node based on which has the fewest AI near it
		nodes = level.retreatNodes[num];
		lowest = nodes[0].fallbackers;
		index = 0;
		for (i=1;i<nodes.size;i++)
		{
			if (nodes[i].fallbackers >= lowest)
				continue;
			lowest = nodes[i].fallbackers;
			index = i;
		}
		node = nodes[index];
		// track the amount of AI at a node
		self thread nodeFallbackerIncrement(node);
		
		thread retreatNode_OccupierIncrement(num); // keep track of how many AI are "on" each set of retreat nodes
			
		self setgoalnode (node);
		self.goalradius = 340;
		self.pathenemyfightdist = 50 + randomint(150);
		self.pathenemylookahead = 50 + randomint(150);
		level waittill ("new_retreat_node");
		if (!flag("autosave" + level.fallback))
		{
			autosave(7);
			flag_set("autosave" + level.fallback);
		}
		if (level.fallback == 7)
			break;
		if (num < level.fallback)
			num = level.fallback;
		wait (0.3 + randomfloat(3));
	}
	
	nodes = level.retreatNodes[6];
	for (i=1;i<nodes.size;i++)
	{
		if (nodes[i].fallbackers >= lowest)
			continue;
		lowest = nodes[i].fallbackers;
		index = i;
	}
	node = nodes[index];
	// track the amount of AI at a node
	self thread nodeFallbackerIncrement(node);
	thread retreatNode_OccupierIncrement(num); // keep track of how many AI are "on" each set of retreat nodes
		
	self setgoalnode (node);
	self.goalradius = 340;
	self.pathenemyfightdist = 50 + randomint(150);
	self.pathenemylookahead = 50 + randomint(150);
}

spawnAttacks()
{
	// guys that spawn and charge the front line
	self endon ("death");
	level endon ("axis_retreat");
		
	thread spawnRetreat();
	flag_wait ("chargeBegins");
	wait (2);
	chain = getentarray("axis_attack_chain","targetname");
	level.chargeIndex++;
	if (level.chargeIndex>= chain.size)
		level.chargeIndex = 0;
	chain = chain[level.chargeIndex];
	self.goalradius = 380;	
	if (!flag("axis_attacks_player"))
	{
		self.pathenemyfightdist = 100 + randomfloat (200);
		self.pathenemylookahead = 100 + randomfloat (200);
	}
	self.oldsuppressionwait = self.suppressionwait;
	self.suppressionwait = 0;
//	self attackerSettings();

	chainArray[0] = chain;
	while (isdefined (chainArray[chainArray.size-1].target))
		chainArray[chainArray.size] = getent (chainArray[chainArray.size-1].target,"targetname");
	
	for (;;)
	{
		if (flag("axis_attacks_player"))
		{
			self setgoalentity (level.player);
			wait (1);
			chain = getclosest(self.origin, chainArray);
		}
		else
		{
			self setgoalpos (chain.origin);
			self waittill ("goal");
			if (isdefined (chain.target))
				chain = getent (chain.target,"targetname");
			else
				break;
		}
	}
	
	self setgoalentity (level.player);
	self.goalradius = 350;
	
//	node = getnode ("get_all_mega","targetname");
//	self setgoalnode (node);
}

delayedExploder(num, delay)
{
	wait (delay);
	exploder(num);
}

brushDelete()
{
	/*
	ent = getent (self.target,"targetname");
	ent delete();
	if (1) return;
	*/
	ent = getent (self.target,"targetname");
	ent2 = getent (ent.target,"targetname");
	ent2 moveto(ent2.origin + (0,0,-50), 0.25, 0.1);
	for (;;)
	{
		self waittill ("trigger");
		wait (0.52);
		ent moveto(ent.origin + (0,0,-100), 0.25, 0.1);
		wait (0.2);
		ent2 moveto(ent2.origin + (0,0, 80), 0.3);
		wait (0.3);
		ent2 moveto(ent2.origin + (0,0, -80), 0.5);
		wait (0.6);
		ent moveto(ent.origin + (0,0, 100), 0.5);
		wait (0.1);
	}
}

tankSpawnerSound()
{
	for (;;)
	{
		level waittill ("new vehicle spawned"+"tank_spawner",spawn);
		spawn thread tankSoundPlay();
	}
}

tankSoundPlay()
{
	org = spawn ("script_model",self.origin);
//	org setmodel ("xmodel/temp");
	org linkto (self, "tag_origin", (0,0,0), (0,0,0));
	playTankSoundUntilTankDies(org);
	org delete();
}

playTankSoundUntilTankDies(org)
{
	self endon ("death");
	for (;;)
	{
		org playloopsound("panzer2_engine_manual");
		wait (0.05);
	}
}

tankOverpass(triggers, timer)
{
	for (i=0;i<triggers.size-1;i++)
	{
		triggers[i] notify ("trigger");
		wait (timer);
	}
	flag_set("tanks_done");
}

vehicleDelete()
{
	for (;;)
	{
		self waittill ("trigger",other);
		other delete();
	}
}

newFriendlies()
{
	// these guys spawn in so you have more friendlies with you after a certain point
	array_thread (getentarray(self.target,"targetname"), ::newFriendlySpawner);
}

squadThink()
{
	self.isSquad = true;
	thread maps\_spawner::squadRespawnThink();
	self endon ("death");
	self endon ("leftSquad");
		
	waittillframeend;
	/*
	if (level.currentObjective != "obj1")
	{
		self setgoalentity (level.player);
		return;
	}
	*/
	
	
	olddist = self.walkdist;
//	nodes = getnodearray ("tank_support_node","targetname");
	self.walkdist = 25035;
	wait randomfloat(5);
	self setgoalentity (level.player);
	wait (9);
	self.walkdist = olddist;
}

newFriendlySpawner()
{
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
		assert(0);
	spawn maps\_spawner::squadThink();
}

fleeTrigger()
{
	// The AI run off to nodes, some hang for a bit to cover then run too.
	self waittill ("trigger");
	ai = getentarray(self.target,"targetname");
	ai = array_randomize(ai);
	nodes = getnodearray(self.target,"targetname");
	nodes = array_randomize(nodes);
	index = randomint(nodes.size);
	timer = 0;
	for (i=0;i<ai.size;i++)
	{
		ai[i] thread setDelayedGoal(nodes[index], timer);
		index++;
		if (index >= nodes.size)
			index = 0;
		timer += 0.4;
	}
}

setDelayedGoal(goal, timer)
{
	self endon ("death");
	wait (timer);
	self setgoalnode (goal);
}

teleportPlayer( org )
{
	wait (0.1);
	level.player setorigin (org);
}

pre_ending()
{

	spawners = getentarray("upstairs_defender","targetname");
	allspawners = getspawnerarray();
	for (i=0;i<allspawners.size;i++)
	{
		if (!issubstr(allspawners[i].classname, "axis"))
			continue;
		
		included = false;
		for (p=0;p<spawners.size;p++)
		{
			if (spawners[p] != allspawners[i])
				continue;
			included = true;
			break;
		}
		if (!included)
			allspawners[i] delete();
	}

	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
		ai[i] delete();
	
	getent ("attack_hardpoint", "targetname") delete();
	thread teleportPlayer( getent ("ending","targetname").origin);
	spawners = getentarray("end_sequence","targetname");
	array_thread(spawners,::spawnGuy);	
	wait (0.1); // so player is teleported
	waittillframeend; // so the players origin is actually different



	level.commissar = getClosestAI (level.player.origin, "allies");
	thread endingStart();

	wait (1);
	chain_node = getnode("final_building_chain", "targetname");
	level.player setfriendlychain(chain_node);
	
	spawners = getentarray("engineer","script_noteworthy");
	for (i=0;i<spawners.size;i++)
	{
		spawners[i].count = 1;
		spawn = spawners[i] stalingradspawn();
		if (spawn_failed(spawn))
			continue;
		spawn setgoalentity (level.player);
		spawn.script_noteworthy = "not very noteworthy";
	}
	wait (0.5);
	for (i=0;i<1;i++)
	{
		spawners[i].count = 1;
		spawn = spawners[i] stalingradspawn();
		if (spawn_failed(spawn))
			continue;
		spawn setgoalentity (level.player);
		spawn.script_noteworthy = "not very noteworthy";
	}
	
//	wait (10);
	
}

/*
endForceTrigger()
{
	self waittill ("trigger");
	flag_set ("hit_end_trigger");
}
*/

/*
waitForEndingTrigger()
{
	// wait until ending building is clear or deeper trigger is hit
	level endon ("hit_end_trigger");
	trigger = getent ("pre_end","targetname");
	trigger waittill ("trigger");
	getent(trigger.target,"targetname") thread endForceTrigger();
	for (;;)
	{
		axis = getaiarray("axis");
		toucher = [];
		for (i=0;i<axis.size;i++)
		{
			if (axis[i] istouching(trigger))
				toucher[toucher.size] = axis[i];
		}
		if (!toucher.size)
			break;
		for (i=0;i<toucher.size;i++)
		{
			if (isalive(toucher[i]))
				toucher[i] waittill ("death");
		}
	}
}
*/

killSoon()
{
	// kill off the remaining axis that aren't upstairs
	self endon ("death");

	// we don't kill off the guys defending upstairs
	if (isdefined (self.script_noteworthy) && self.script_noteworthy == "axis_defend")
		return;

	wait (randomfloat(2));
	self dodamage(self.health+5, (0,0,0));		
}

setupTnt()
{
	tnt = getentarray("tnt","targetname");
	for (i=0;i<tnt.size;i++)
		tnt[i] thread tntThink(i);
	
}

tntThink(position)
{
	trigger = getent(self.target,"targetname");
	trigger triggerOff();
	self hide();
	flag_wait ("tnt_objective");
	trigger setHintString (&"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES");

	objective_additionalposition(6, position, self.origin);
	
	self show();
	trigger triggerOn();

	level.totaltnt++;
	trigger waittill ("trigger");	
	level.totaltnt--;
	self setmodel ("xmodel/military_tntbomb");
	self playsound ("explo_plant_rand");
	trigger delete();

	flag_clear ("hint_use_explosives");

	if (level.totaltnt == 1)
	{
		flag_clear ("hint_plant_explosives_plural");
		flag_set ("hint_plant_explosives_singular");
	}
	
	if (!level.totaltnt) // last one placed
	{
		level.inv_tnt maps\_inventory::inventory_destroy();

		flag_clear ("friendly_wave_spawn_enabled");
		spawners = getspawnerarray();
		for (i=0;i<spawners.size;i++)
			spawners[i] delete();
		axis = getaiarray("axis");
//		for (i=0;i<axis.size;i++)
//			axis[i] delete();
		flag_set("move_out");
		ai = getaiarray("allies");
		for (i=0;i<ai.size;i++)
		{
			ai[i].pathenemyfightdist = 0;
			ai[i].pathenemylookahead = 0;
		}
		chain_node = getnode("tnt_gather_chain", "targetname");
		level.player setfriendlychain(chain_node);
	}
	else 
		objective_string(6,  level.objText6,  level.totaltnt);
		
	objective_additionalposition(6, position, (0,0,0));
	
//	objective_string(5, "active",  "Plant explosives throughout the building. (3 remaining).", tnt[0].origin);
//	objective_current(5);
//	for (i=1;i<tnt.size;i++)
	
}

delayed_autosave(num, delay)
{
	wait (delay);
	maps\_utility::autosave(num);
}

ending()
{
	delayed_autosave(2, 1);

	objective_state(2, "done");
	// "Clear out the German hardpoint on the far side of the intersection.";
	objective_add(3, "active",  level.objText3, getent ("clear_hardpoint","targetname").origin);
	objective_current(3);
	
	objEvent = getObjEvent("hardpoint");
	objEvent waittill_objectiveEvent();
	chain_node = getnode("final_building_chain", "targetname");
	level.player setfriendlychain(chain_node);
	
	wait (1.3);
//	waitForEndingTrigger();
	array_thread(getaiarray("axis"), ::killSoon);
	// "Rendezvous with Commissar Letlev.";

	objective_state(3, "done");
	objective_add(4, "active",  level.objText4, getnode ("end_left","targetname").origin);
	objective_current(4);
	setsavedcvar("cg_hudCompassMaxRange", "400");
	endingStart();
}

offerExplosives(node)
{
	level endon ("player_got_explosives");
	thread stopOfferingTNT();
	self endon ("stop_offering_explosives");
	self setHintString (&"SCRIPT_PLATFORM_HINTSTR_TAKEEXPLOSIVES");
	self.useable = true;
	self.givingTnt = false;
	self waittill ("trigger");
	self thread giveTnt(node); // thread off so we can kill the thread of everybody else giving tnt
}

stopOfferingTNT()
{
	self endon ("stop_offering_explosives");

	assert (!flag("player_got_explosives"));
	level waittill ("player_got_explosives");
	self.useable = false;
}

giveTnt(node)
{
	flag_set("player_got_explosives");

	node notify ("stopLoop");
	self.givingTnt = true;
	right = anglestoright(self.angles);
	othervec = vectorNormalize(self.origin-level.player.origin);
	dot = vectordot(right,othervec); 
	if (dot > 0) // left
		node anim_single_solo(self, "bomb_left");
	else
		node anim_single_solo(self, "bomb_right");
	level.inv_tnt = maps\_inventory::inventory_create( "inventory_tnt_large", true );
	self notify ("tnt_given");
	
//	node thread anim_loop_solo(self, "planting_idle", undefined, "stopLoop");
}

endingStart()
{
	flag_set ("hint_height_above");
	
	// upstairs guys that shoot at you
	spawners = getentarray("upstairs_defender","targetname");
	array_thread (spawners, ::prepDefenderSpawners);
	flood_and_secure_scripted(spawners);
	
	array_thread(getaiarray("allies"), ::aiLowAccuracyVSAI);
	array_thread(getspawnerarray(), ::spawnerLowAccuracyVSAI);

	org = getent("ally_threat","targetname").origin;
	level.endGuys = [];
	excluders = [];
	
	assert (isalive(level.commissar));
	level.endGuys["barricade"] = level.commissar; // getClosestAIExclude (org, "allies", excluders);
	excluders[excluders.size] = level.endGuys["barricade"];
	level.endGuys["barricade"] thread magic_bullet_shield();
	
	// dont let any antanovas get involved in the final sequence
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		if (!issubstr(ai[i].classname, "antanova"))
			continue;
		excluders[excluders.size] = ai[i];
	}

	for (;;)
	{
		level.endGuys["plant_explosives"] = getClosestAIExclude (org, "allies", excluders);
		if (isalive(level.endGuys["plant_explosives"]))
			break;
		wait (0.5);
	}
	excluders[excluders.size] = level.endGuys["plant_explosives"];
	level.endGuys["plant_explosives"] thread magic_bullet_shield();
	
	for (;;)
	{
		level.endGuys["call_engineers"] = getClosestAIExclude (org, "allies", excluders);
		if (isalive(level.endGuys["call_engineers"]))
			break;
		wait (0.5);
	}
	excluders[excluders.size] = level.endGuys["call_engineers"];
	level.endGuys["call_engineers"] thread magic_bullet_shield();
	
	for (;;)
	{
		level.endGuys["question"] = getClosestAIExclude (org, "allies", excluders);
		if (isalive(level.endGuys["question"]))
			break;
		wait (0.5);
	}
	excluders[excluders.size] = level.endGuys["question"];
	level.endGuys["question"] thread magic_bullet_shield();
	
	thread leftGuy();
	for (i=0;i<excluders.size;i++)
	{
//		excluders[i].dontavoidplayer = true; // they can trap the player
		excluders[i].pathenemyfightdist = 0;
		excluders[i].pathenemylookahead = 0;
	}

	node = getnode("end_sequence","targetname");
	
	guy[0] = level.endGuys["plant_explosives"];
	guy[0].animname = "explosives_guy";
	explosivesGuy = guy[0];
	guy[1] = level.endGuys["call_engineers"];
	guy[1].animname = "call_guy";
	callGuy = guy[1];
	/*
	guy[0] setgoalnode (getnode("explosives_guy","targetname"));
	guy[0].goalradius = 4;
	guy[0] notify ("end_sequence");
	
	start = getstartorigin(node.origin, node.angles, level.scr_anim["call_guy"]["got_some"]);
	guy[1] setgoalpos (start);
	guy[1].goalradius = 4;
	guy[1] notify ("end_sequence");

	guy[0] waittill ("goal");
	*/
	
//	explosivesGuy animscripts\shared::putGunInHand ("left");
//	callGuy animscripts\shared::putGunInHand ("right");
	
	
	node anim_reach(guy, "start_pos");
	node thread anim_loop_solo(explosivesGuy, "start_idle", undefined, "stopExplosivesguyIdle");
	node thread anim_loop_solo(callGuy, "start_idle", undefined, "stopCallguyIdle");
/*
	
	callGuy thread debugorigin();
	

	for (;;)
	{
		println ("got some");
		node anim_single_solo(callGuy, "got_some");
		println ("test1");
		node anim_single_solo(callGuy, "test1");
		println ("test2");
		node anim_single_solo(callGuy, "test2");
	}
	for (;;)
		node anim_single(guy, "got_some");
*/
	flag_wait ("discussion_begins");
	flag_clear ("hint_height_above");

	node notify ("stopCallguyIdle");
	node thread anim_loop_solo(callGuy, "call_idle", undefined, "stopCallguyIdle");

	flag_wait ("start_explosives");
	node notify ("stopCallguyIdle");
	// get the engineers up here, we need explosives
	node thread anim_single_solo(callGuy, "bring_explosives");
//	flag_wait("start_toss");
	wait (4.2);
	node notify ("stopExplosivesguyIdle");
	// I've got some tnt, I'll get started over here
	node thread anim_single_solo(explosivesGuy, "got_some");
	thread callGuyLoop(node, callGuy);
	
//	node thread anim_lookat_solo(callGuy, "got_some");
	
	explosivesGuy waittillmatch ("single anim", "stick");
	explosivesGuy placeTNT();
	flag_set ("tossed_tnt");
	explosivesGuy detach ("xmodel/military_tntbomb", "tag_weapon_left");
	
	explosivesGuy waittillmatch ("single anim","end");
	node thread anim_loop_solo(explosivesGuy, "planting_idle", undefined, "stopLoop");
	flag_clear("player_got_explosives");
	explosivesGuy thread offerExplosives(node); // lets player get explosives from him
	
	
	flag_set ("get_tnt_objective");
	flag_set ("hint_get_explosives");
	battleChatterOff( "allies" ); // particularly so they dont respond "yes" when you get explosives from them
	
	objective_state(4, "done");	
	// "Obtain explosives from the engineer.";
	objective_add(5, "active",  level.objText5, explosivesGuy.origin);
	objective_current(5);
	flag_wait("player_got_explosives");
	flag_clear ("hint_get_explosives");
	level.lastPlantHint = gettime();
	flag_set ("hint_use_explosives");
	flag_set ("hint_plant_explosives");
	flag_set ("hint_plant_explosives_plural");
	
	battleChatterOn( "allies" );
	wait (2.5);
	maps\_utility::autosave(5);


/*	
	bombLeft = getent ("bomb_use_left","targetname");
	bombRight = getent ("bomb_use_right","targetname");
	bombLeft triggerOn();
	bombRight triggerOn();
	bombLeft setHintString (&"SCRIPT_PLATFORM_HINTSTR_TAKEEXPLOSIVES");
	bombRight setHintString (&"SCRIPT_PLATFORM_HINTSTR_TAKEEXPLOSIVES");
	bombLeft thread bombTrigger("left");
	bombRight thread bombTrigger("right");
	level waittill ("bombTrigger",side);
	flag_set ("got_bomb");
	bombLeft delete();
	bombRight delete();
	node notify ("stopLoop");
	if (side == "left")
		node anim_single_solo(explosivesGuy, "bomb_left");
	else
		node anim_single_solo(explosivesGuy, "bomb_right");

	node thread anim_loop_solo(explosivesGuy, "planting_idle", undefined, "stopLoop");
*/	

	objective_state(5, "done");	
	spawners = getentarray("upstairs_defender","targetname");
//	ai = getaiarray("axis");
//	assertEx(!ai.size, "Still living enemies when there shouldnt be");
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
//		ai[i].ignoreme = true; // no more ai vs ai in the level
		ai[i].pathenemyfightdist = 0;
		ai[i].pathenemylookahead = 0;
	}
	array_thread (spawners, ::prepDefenderSpawners);
	flood_and_secure_scripted(spawners);
	
	tnt = getentarray("tnt","targetname");
	// "Plant explosives throughout the building. (3 remaining).";
	objective_add(6, "invisible",  level.objText6a,  tnt[0].origin);
	objective_state(6, "active");
	objective_string(6,  level.objText6,  3);
	objective_current(6);

	level.totaltnt = 0;
	flag_set ("tnt_objective");
	flag_wait ("move_out");
	flag_clear ("hint_use_explosives");
	flag_clear ("hint_plant_explosives");
	flag_clear ("hint_plant_explosives_singular");
	
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		ai[i] notify ("stop magic bullet shield");
		ai[i].health = 100;
	}

	node notify ("stopLoop");
	for (i=0;i<guy.size;i++)
		guy[i] setgoalentity (level.player);

	node = getnode("tnt_gather","targetname");
	objective_state(6,"done");
	objective_string(6,  level.objText6a);
	
	// "Get to a safe distance.";
	objective_add(7, "active", level.objText7, node.origin);
	objective_current(7);

	/*
	while (distance(level.player.origin, node.origin) > 128)
		wait (0.2);
	*/	
	
	maps\_utility::autosave(4);
	
	wait (1);
	thread dialogue_runaway();
	music_demolition();
	thread music_ending();
	thread buildingExplodes();
	
	thread victory();	
}

callGuyLoop(node, callguy)
{
//	node thread anim_loop_solo(callGuy, "start_idle", undefined, "stopCallguyIdle");
	wait (1.8);
	node notify ("stopCallguyIdle");
	node anim_single_solo(callGuy, "get_some");
	callGuy engineerThink(true);
}

buildingStart()
{
	wait (0.1);
	level.player setorigin ((5162, 615, -106));
	wait (3.5);
	buildingExplodes();
}

hideBuildingParts()
{
	getent ("demo_1","targetname") hide();
	getent ("demo_2","targetname") hide();
	getent ("demo_3","targetname") hide();
	getent ("demo_4","targetname") hide();
	getent ("demo_5","targetname") hide();
	getent ("demo_wall","targetname") hide();
	base1 = getent ("demo_base","targetname");
	base2 = getent ("demo_base2","targetname");
	base1 hide();
	base1 notsolid();
	base2 hide();
	base2 notsolid();
	
	array_thread (getentarray ("demo_back","targetname"), ::hider);
	getent ("demo_base_chunk","targetname") hide();
	rubble = getent ("demo_base_rubble","targetname");
	rubble hide();
	rubble.origin += (0,0,-1*level.movelength);
	rubble notsolid();
}

hider()
{
	self hide();
}

shower()
{
	self show();
}

deleter()
{
	self delete();
}

explosionDamage()
{
	level endon ("explosion_done");
	org = self;
	for (;;)
	{
		radiusdamage(org.origin, 1000, 1000, 100);
		wait (0.5);
		org = getent (org.target,"targetname");
	}
}

quickQuake()
{
	earthquake(0.45,0.15, level.eq_org, 5000);
}


buildingExplodes()
{
	maps\demolition_fx::createWallShredExploders();
	wait (2.0);
	demoStart = getentarray ("demo_start","targetname");
	demoBack = getentarray ("demo_back","targetname");
	demo1 = getent ("demo_1","targetname");
	demo2 = getent ("demo_2","targetname");
	demo3 = getent ("demo_3","targetname");
	demo4 = getent ("demo_4","targetname");
	demo5 = getent ("demo_5","targetname");
	demo_wall = getent ("demo_wall","targetname");
	rubble = getent ("demo_base_rubble","targetname");
	demoBase = getent ("demo_base","targetname");
	demoBase2 = getent ("demo_base2","targetname");
	demoBaseChunk = getent ("demo_base_chunk","targetname");
	level.eq_org = (7088, 754, 384);
	earthquake(0.2, 5, level.eq_org, 5000);

	if (level.showExploder)
		exploder(20);
	level notify ("stopGermanPlanning"); // stops german planning sound fx
	getent ("explosion_sound","targetname") playsound ("demolition_demoexplosion");
	ai = getaiarray();
	trigger = getent("demolition_death_trigger","targetname");
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] istouching (trigger))
			ai[i] dodamage(ai[i].health,(0,0,0));
	}
	if (level.player istouching (trigger))
		level.player dodamage (level.player.health, (0,0,0));
	if (level.showExploder)
		exploder(1);
	quickQuake();

	if (level.showExploder)
		exploder(2);
	quickQuake();
//	demoBase hide();
	if (level.showExploder)
		exploder(3);
	quickQuake();
	wait (0.5);

//	demoStart hide();

	if (level.showExploder)
		exploder(21);
	quickQuake();
	wait .25;

	earthquake(0.35, 14, level.eq_org, 5000);

	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
		ai[i] dodamage(ai[i].health +5, (0,0,0));
	maps\_spawner::kill_spawnerNum(1);
	getent ("death_point","targetname") thread explosionDamage();
	demo1 thread moveRotate(-10, 0);	
	thread chunkSpawnStart(level.build_brick[10], "brick_spawn_short", demo1, 10, (-30,270,0), 0.15);
	demo1 show();
	demo2 show();
	demo3 show();
	demo4 show();
	demo5 show();
	for (i=0;i<demoStart.size;i++)
		demoStart[i] delete();
	array_thread (demoBack, ::shower);
	demoBase show();
	demoBase solid();
	demoBaseChunk show();
//	demo_wall show();

	exploder(19);

	array_thread(getentarray("building_glow","script_noteworthy"), ::deleter);
	array_thread(getentarray("demo_start_model","targetname"), ::deleter);
	level notify ("stop fx" + "lantern_stop");
	wait (0.45);
	wait (0.25);
/*
	if (level.showExploder)
		exploder(4);
*/
	wait .25;

	if (level.showExploder)
		exploder(22);
	
	demo2 thread moveRotate(-15, -5);	
	offsetTimer = 0.3;
	thread chunkSpawnStart(level.build_brick[20], "brick_spawn_short", 	demo2, 2.4, (-30,285,0), 0.35);
	thread chunkSpawnStart(level.build_brick[25], "brick_spawn_short", 	demo2, 1, (-30,285,0), 0.35);
	wait (offsetTimer);
	chunkSetFX(level.build_brick[20], "brick_spawn_long");
	chunkSetFX(level.build_brick[25], "brick_spawn");
//	thread chunkSpawnStart(level.build_brick[20], "brick_spawn_long", 	demo2, 2-offsetTimer, (-30,270,0), 0.15);
//	thread chunkSpawnStart(level.build_brick[25], "brick_spawn", 		demo2, 1-offsetTimer, (-30,270,0), 0.15);

	wait (0.65 - offsetTimer);
/*
	if (level.showExploder)
		exploder(5);
*/
	rubble show();
	rubble solid();
	rubble moveto (rubble.origin + (0,0,level.movelength), 6, 2, 4);
	wait .25;
	wait (0.65);
	if (level.showExploder)
		exploder(23); // 3rd bricks
	demo3 thread moveRotate(-20, -10);
	thread chunkSpawnStart(level.build_brick[30], "brick_spawn_short", demo3, 2, (-30,270,0), 0.25);
	wait .24;
	chunkSetFX(level.build_brick[30], "brick_spawn");
/*
	if (level.showExploder)
		exploder(6);
*/
	if (level.showExploder)
		exploder(24);
	demo4 thread moveRotate(-10, -40);	
//	thread chunkSpawnStart(level.build_brick[40], demo4, 1.5, (-30,350,0));
	thread chunkSpawnStart(level.build_brick[40], "brick_spawn", demo4, 2, (-30,340,0), 0.25);
	wait (0.65);
	array_thread (demoBack, ::deleter);
	demoBase2 show();
	demoBase2 solid();
	demo5 thread moveRotate(-10, 0);	 // -10 -10
	demo_wall delete();


/*
	
//	demo5 thread moveRotate();	
	demo5a thread moveRotateFall(7, 1, -4000);	
	wait (0.15);
	demo5b thread moveRotateFall(6, -1, 2000);	
	wait (0.35);
	demo5c thread moveRotateFall(5, 1, -2000);
	wait (0.35);
	demo5d thread moveRotateFall(4, 1, -2000);	
	wait (0.35);
	demo5e thread moveRotateFall(3, 1, -2000);	
	wait (0.35);
	demo5f thread moveRotateFall(2, 1, -2000);	
	wait (0.35);
	demo5g thread moveRotateFall(1, 1, -2000);	
*/
	flag_set ("explosion_done");
	if (getcvar("start") != "boom")
		flag_wait("chunk_falls");
	else
		wait (15);
	
	demoBaseChunk playsound ("demolition_brick_crumble");
	demoBaseChunk moveto (demoBaseChunk.origin + (0,0,-3000), 4, 1);
	demoBaseChunk rotatevelocity((-1500,0,0), 6, 4);
	wait (1.0);
	demoBaseChunk playsound ("demolition_brick_hitsground");
}


moveRotate(roll, pitch)
{
	ent = getent (self.target,"targetname");
	ent2 = getent (ent.target,"targetname");
	
//	self linkto (ent);
//	ent moveto (ent2.origin, 5);
	org = ent2.origin - ent.origin;
	self moveto (self.origin + org, 4, 2);
//	self rotatepitch(-20, 5, 4);
//	self rotateroll(-20, 5, 4);
	self rotatevelocity((pitch,0,roll), 5, 4);
	wait (6);
	self delete();

}

moveRotateFall(fall, rotdir, y)
{
//	fall = 3;
	fall = fall*-1000;
	self moveto (self.origin + (y,0,(-3000 + fall)), 10, 2);
//	self rotateroll(-20, 5);
	self rotatevelocity((-500 * rotdir,0,0), 15, 2);

}


bombTrigger(side)
{
	self endon ("death");
	self waittill ("trigger");
	level notify ("bombTrigger",side);
}
	

leftGuy()
{
	barricadeGuy = level.endGuys["barricade"];
	level.leonov = barricadeGuy;
	barricadeGuy notify ("end_sequence");
	barricadeGuy.animname = "barricade";
	node = getnode("end_left","targetname");
	
	questionGuy = level.endGuys["question"];
	questionGuy.animname = "question_guy";
	guy[0] = barricadeGuy;
	guy[1] = questionGuy;
	
	node anim_reach_idle(guy, "shout", "idle");
//	questionGuy thread handmadness();
//	barricadeGuy animscripts\shared::putGunInHand ("right");
//	questionGuy animscripts\shared::putGunInHand ("left");
	level.player_blocker moveto (level.player_blocker.original_origin, 1);
	waittillframeend; // so the killing of the reach idle loop doesnt also kill the new loop
	node thread anim_loop_solo(barricadeGuy, "idle", undefined, "stopLoop");
	node thread anim_loop_solo(questionGuy, "idle", undefined, "stopQuestionLoop");

	thread endObjectiveHint();	
	trigger = getent ("end_start_left","targetname");
	trigger waittill ("trigger");
	level notify ("end_objective_hint");
	flag_set ("discussion_begins");
	array_thread(getnodearray("tnt_node","targetname"), ::tntNode);
	thread engineerMove();
	array_thread(getentarray("engineer","script_noteworthy"), ::spawnEngineers);
	
	node notify ("stopLoop");
	getent ("start_toss","targetname") thread start_toss_trigger();
	talkTimer = 10.85;
	// damn those fascists, they barricaded themselves on the upper floors
	node thread anim_single_solo(barricadeGuy, "shout");

	talkTimer -= 2.9;
	wait (2.9);
	node notify ("stopQuestionLoop");
	// shouldn't we ask them to surrender comrade?
	
//	node thread anim_single_solo_then_loop(questionGuy, "shout", "idle");
	node thread anim_single_solo(questionGuy, "shout");
	wait (6);
	talkTimer -= 6;

	wait (.3);
	talkTimer -= 0.3;
	flag_set ("start_explosives");
	wait (talkTimer);
	level.player_blocker delete();
	barricadeGuy stopanimscripted();
	barricadeGuy thread engineerThink(undefined, true);

	wait (2);	
	questionGuy thread engineerThink();
	/*
	node thread anim_loop_solo(barricadeGuy, "shout_idle", undefined, "stopLoop");
	flag_wait ("move_out");

	node notify ("stopLoop");
	for (i=0;i<guy.size;i++)
		guy[i] setgoalentity (level.player);
	*/
}

anim_single_solo_then_loop(guy, anim1, anim2)
{
	anim_single_solo(guy, anim1);
	anim_loop_solo(guy, anim2, undefined, "stopLoop");
}

engineerMove()
{
	flag_wait ("start_explosives");
	wait (4);
	flag_set ("engineers_run_up");
}

start_toss_trigger()
{
	self waittill ("trigger");
	flag_set ("start_toss");
}

tntNode()
{
	self.used = false;
}

spawnEngineers()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		assert(0);
	spawn engineerThink();
}

engineerPrep(guy)
{
	guy waittillmatch ("single anim","end");
	guy engineerThink(true);
}

demoTeamSound()
{
	self endon ("death");
	flag_set("demolition_team_on_the_way");
	wait (18);
	self anim_single_solo(self, "on_the_way");
}

engineerThink(noBulletShield, noFlagWait)
{
	if (!isdefined(noBulletShield))
		self thread magic_bullet_shield();

	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
		 
	self.animname = "engineer";
	if (!flag("demolition_team_on_the_way"))
		self thread demoTeamSound();
		
	if (!isdefined(noFlagWait))
		flag_wait ("engineers_run_up");
		
	nodes = getnodearray("tnt_node","targetname");
	newNodes = [];
	for (i=0;i<nodes.size;i++)
	{
		if (nodes[i].used)
			continue;
		newNodes[newNodes.size] = nodes[i];
	}
	
	nodes = newNodes;
	node = getclosest(self.origin, nodes);
	node.used = true;
	self.animnode = node;
	
	plantExplosivesUntilItsTimeToGo(node);	
	if (self.anim_pose == "crouch")
	{
		self.animnode notify ("stopLoop");
		self.animnode anim_single_solo(self, "stand");
	}

	self setgoalentity (level.player);
}

plantExplosivesUntilItsTimeToGo(node)
{
	level endon ("move_out");
	self.givingTnt = false;
	for (;;)
	{
//		node anim_reach_solo(self, "plant");	
//		node thread anim_single_solo(self, "plant");	
		node anim_reach_solo(self, "crouch");	
		self animscripts\shared::putguninhand("right"); // because the animation he's about to do doesn't handle the gun being in left
		node thread anim_single_solo(self, "crouch");
		self.animnode = node;

		self waittillmatch ("single anim", "stick");
		placeTNT();
		node waittill ("crouch");
		node thread anim_loop_solo(self, "planting_idle", undefined, "stopLoop");
		flag_wait ("tossed_tnt");
		wait (3);
		flag_wait ("get_tnt_objective");
		
		if (!flag("player_got_explosives"))
		{
			thread offerExplosives(node);
			flag_wait("player_got_explosives");
			if (self.givingTnt)
				self waittill ("tnt_given");
		}
		if (!self.givingTnt)
			wait (randomfloat(2));

		nodes = getnodearray("tnt_node","targetname");
		newNodes = [];
		for (i=0;i<nodes.size;i++)
		{
			if (nodes[i].used)
				continue;
			newNodes[newNodes.size] = nodes[i];
		}
		
		oldnode = undefined;
		if (newNodes.size)
		{		
			oldnode = node;
			nodes = newNodes;
			node = getclosest(self.origin, nodes);
			node.used = true;
		}
		else
			flag_wait ("move_out");

		self notify ("stop_offering_explosives");
		self.useable = false;		
		oldnode notify ("stopLoop");
		oldnode anim_single_solo(self, "stand");
	}
}

placeTNT()
{
	tnt = spawn("script_model",(0,0,0));
	tnt setmodel ("xmodel/military_tntbomb");
	tnt.origin = self gettagorigin ("tag_weapon_left");
	tnt.angles = self gettagangles ("tag_weapon_left");
}

spawnGuy()
{
	if (self.script_noteworthy == "engineer")
		return;
	self.count = 1;
	spawn = self dospawn();
	level.endGuys[spawn.script_noteworthy] = spawn;
	
}

getTargetNote2(targetname, msg)
{
	triggers = getentarray(targetname,"targetname");
	for (i=0;i<triggers.size;i++)
	{
		if (!isdefined(triggers[i].script_noteworthy2))
			continue;
		if (triggers[i].script_noteworthy2 != msg)
			continue;
		return triggers[i];
	}
}

mortarWave(mortar)
{
	for (;;)
	{
		mortar maps\_mortar::activate_mortar(undefined,undefined,undefined,undefined,undefined,undefined, false);
		if (!isdefined(mortar.target))
			break;
		mortar = getent (mortar.target,"targetname");
		wait (0.8 + randomfloat(1));
	}
}

dialogue_runaway()
{
	//alias: demolition_rs4_safedistance
//		iprintlnbold("The charges are set, get to a safe distance!");
	thread ambientSoundDialogue("safe_distance");
//		wait 4;
		wait 8;
	thread ambientSoundDialogue("get_clear");
	//alias: demolition_rs1_abouttoblow
//		iprintlnbold("It's about to blow, get clear of the building!!!");
//		wait 3.3;	
		wait 3.3;	
	thread ambientSoundDialogue("move_it");
	//alias: demolition_rs4_moveitrun
//		iprintlnbold("Move iiit!!! Ruuun!!!!");
//		wait 2.6;	
		wait 3.1;
	thread ambientDialogue("lets_go");
	//alias: demolition_rs3_letsgoletsgo
//		iprintlnbold("Let's go, let's go!!! (add embellishment in Russian)");
//		wait 3.3;	
		wait 2.8;	
	thread ambientDialogue("hurry_comrades");
	//alias: demolition_rs1_hurrycomrades
//		iprintlnbold("Hurry Comraaades!!");	
}

music_tensionfragments()
{
	level endon ("hold_the_line");
	/*
	while(1)
	{
		wait randomfloatrange(5,12);
		musicplay("soviet_tension_fragment01");
		wait 120;
		musicplay("soviet_tension_fragment02");
		wait 120;
		musicplay("soviet_tension_fragment03");
		wait 120;
	}
	*/
	
	wait randomfloatrange(3,8);
	musicplay("soviet_tension_fragment01");
	//wait 120;
}

music_tanktrench()
{
	trig = getent("music_tanktrench", "targetname");
	trig waittill ("trigger");
	musicplay("soviet_tension_fragment03");
}

music_awaitingattack()
{
	flag_wait ("hold_the_line");
	musicstop(2);
	wait 10.1;
	musicplay("soviet_holdline_soft");
	wait 33;
	musicstop(0.5);
	wait 1.2;
	musicplay("soviet_charge01");
	wait (34);
	flag_set("germans_retreat");
}

music_demolition()
{
//	wait 27;
	wait (5);
	musicplay("soviet_cresc01");
	wait 12.7;
}

music_ending()
{
	wait 7;
	musicplay("soviet_victory_serious01");
	wait 4;
	
	thread ambientDialogue("cough1");
	//alias: demolition_rs1_coughing
//		iprintlnbold("<Russian Soldier 1 coughing from dust, 5 sec>");
		wait 2;	
	thread ambientDialogue("cough2");
	//alias: demolition_rs4_coughing
//		iprintlnbold("<Russian Soldier 4 coughing from dust, 5 sec>");
		wait 1.4;	
	thread ambientDialogue("cough3");
	//alias: demolition_rs3_coughing
//		iprintlnbold("<Russian Soldier 3 coughing from dust, 5 sec>");
		wait 1.2;	
}

victory()
{
	flag_wait("explosion_done");
	objective_state(7, "done");

	//dialogue alias: demolition_rs1_negotiate
//		iprintlnbold("That is how you negotiate with the fascists, Comrades.");
	wait (12);
	level.leonov.animname = "barricade";
	level.leonov anim_single_solo (level.leonov, "negotiate");
//		wait 4;
//		iprintlnbold("Viktor! Go with Vasili and report to Major Zubov that");
//		iprintlnbold("we've eliminated the German hardpoint.");
//	wait (9.25);
//	ambientDialogue("report");
//		wait 5;
//		iprintlnbold("The rest of us will secure this area against another counterattack.");
//		wait 5;

//	wait (0.35);
//	thread ambientDialogue("right_away");
		
	//dialogue alias: demolition_rs4_rightawayletsgo
//		iprintlnbold("Right away Comrade Lieutenant! Vasili, let's go!");
//		wait 3;
		flag_set("chunk_falls");
		wait (2);
	
	maps\_endmission::nextmission();
}

savePoint()
{
	self waittill ("trigger");
	maps\_utility::autosave(0);
}

planeThink()
{
	level.plane = [];
	self waittill ("trigger");
	paths = getvehiclenodearray (self.target,"targetname");
	for (i=0;i<paths.size;i++)
		thread planeThinkPath(paths[i]);
}

planeThinkPath(path)
{
	wait (3);
	
	plane = spawnVehicle( "xmodel/vehicle_stuka_flying", "plane", "Stuka", (0,0,0), (0,0,0) );
	level.plane[level.plane.size] = plane;
	plane thread plane_quake();
	plane attachPath( path );

	if (!isdefined(level.demo_plane_sound))
		level.demo_plane_sound = randomint(3) + 1;
	plane playsound ("plane_flyby_stuka" + level.demo_plane_sound);
	level.demo_plane_sound++;
	if (level.demo_plane_sound >= 4)
		level.demo_plane_sound = 1;
	
//		level.player linkto (plane, "tag_prop", (0,0,0),(0,0,0));
	plane startPath();
	plane waittill ("reached_end_node");
	plane delete();
}

plane_quake()
{
	self endon ("death");
	while (1)
	{
		earthquake(0.35, 0.5, self.origin, 1450); // scale duration source radius
		wait (0.05);
	}
}

tank_quake()
{
	self endon ("death");
	while (1)
	{
		earthquake(0.4, 1, self.origin, 350); // scale duration source radius
		wait (0.4);
	}
}

tankEarthQuake()
{
	for (;;)
	{
		tank = maps\_vehicle::waittill_vehiclespawn("tank_spawner");
		tank thread tank_quake();
	}
}


anim_lookat_solo()
{
	
}

commissarThink(name)
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		assertEx(0, "important spawn failed");
	spawn thread magic_bullet_shield();
	spawn endon ("death");
	spawn.animname = name;
	return spawn;
	/*
	flag_wait ("hold_the_line");
	
	node = getnode("stove_node","targetname");
	wait (3);	
//	node = getnode (spawn.target,"targetname");
	node anim_single_solo (spawn, "stay");
	node anim_single_solo (spawn, "ready");
	flag_wait ("here_they_come");
	wait (2);
	node anim_single_solo (spawn, "no_falling_back");
	wait (4);
	node anim_single_solo (spawn, "kill_fascists");
	wait (2);
	node anim_single_solo (spawn, "cowards_executed");
	flag_wait ("axis_retreat");
	wait (7);
	node anim_single_solo (spawn, "attack");
	wait (7);
	node anim_single_solo (spawn, "keep_forward");
	*/
	
/*
Letlev commissar_charge_ready (screaming up and down the line) "Comrades!!!! For the Soviet Union, and for your glorious Motherlaaaand...Get readyyyyy!!!!" 
Letlev commissar_charge_nofallingback (apoplectic) "No falling back! Do not retreat!!!" 
Letlev commissar_charge_keepforward "Keep going forward!!!!" 
Letlev commissar_charge_killfascists "Kill the fascists!!!! Show them no mercy!!!" 
Letlev commissar_charge_cowards "Cowards will be executed for dereliction for duty!!!" 
Letlev commissar_charge_attack "Attack!!! ATTAAAAACK!!!!" 
Letlev commissar_charge_movecoward (livid) "Get moving you coward!!!!" 
Letlev commissar_charge_shootyou "Go! Or I will shoot you myself!!!" 
Letlev commissar_charge_finalwarning "This is your final warning!!!!" 
Letlev commissar_charge_chargethose "Charge those enemy positions you fool! Get out there! Move!!!" 
Letlev commissar_charge_dietraitor (overzealous) "Die traitorrr!!!!!" 
Letlev commissar_charge_deserters "No mercy for deserterrrrs!!!" 
Letlev commissar_charge_betrayer "Betrayer!! Die!!!!" 
Letlev commissar_charge_dog "Traitorous dog!!!" 
*/	
}

droneAlliesThink()
{
	for (;;)
	{
		self waittill ("trigger");
		while (level.player istouching (self))
			wait (0.1);
//		self notify ("stop_drone_loop");
	}
}

axisFleeTrigger()
{
	self waittill ("trigger");
		
	triggers = getentarray(self.target,"targetname");
	for (i=0;i<triggers.size;i++)
	{
		// spread out the hit from touchchecking the triggers
		triggers[i] thread axisFleeTriggerThink();
		wait (0.05);
	}
	self delete();
}

axisFleePlayerTrigger()
{
	self waittill ("trigger");
	self notify ("player_triggered");
	forceAIToFlee();
}

axisFleeTriggerThink()
{
	self endon ("player_triggered");
	thread axisFleePlayerTrigger();
	ai = getaiarray("axis");
	guy = [];
	for	(i=0;i<ai.size;i++)
	{
		if (!self istouching (ai[i]))
			continue;
		guy[guy.size] = ai[i];
		thread reportDeath(ai[i]);
	}

	if (!guy.size)
		return;
			
	self.count = guy.size;
	cutoff = self.count * 0.5;
	while (self.count > cutoff)
		self waittill ("guy_died");
	forceAIToFlee();
}

forceAIToFlee()
{
	ai = getaiarray("axis");
	guy = [];
	for	(i=0;i<ai.size;i++)
	{
		if (!self istouching (ai[i]))
			continue;
		guy[guy.size] = ai[i];
	}
	
	nodes = getnodearray(self.target,"targetname");
	array_thread(guy, ::fleeToNearestNode, nodes);
}

fleeToNearestNode(nodes)
{
	self endon ("death");
	wait (randomfloat (3.5));
	node = getclosest(self.origin, nodes);
	self setgoalnode (node);
	self.goalradius = node.radius;
}

reportDeath(guy)
{
	guy waittill ("death");
	self.count--;
	self notify ("guy_died");
}

delayedSpawner()
{
	// spawn AI if the player sits in one spot for awhile
	spawners = getentarray(self.target,"targetname");
	array_thread(spawners, ::delayedSpawnerThink, self);
	
	timer = 5; // 5 seconds
	checkTime = 1; // check once a second
	iterations = timer / checkTime;
	
	for (;;)
	{
		self waittill ("trigger");
		playerTouching = true;
		for (i=0;i<iterations;i++)
		{
			if (!self isTouching (level.player))
			{
				playerTouching = false;
				break;
			}
			wait (checkTime);
		}
		
		if (!playerTouching)
			continue;
		if (self isTouching (level.player))
			break;
	}
	
	self notify ("action");
}

delayedSpawnerThink(trigger)
{
	self endon ("death");
	// dont spawn these guys until its time
	self.triggerUnlocked = true;
	trigger waittill ("action");
	
	self.count = 1;
	self dospawn();
}

bindingGen(binding, key)
{
	bind = spawnstruct();
	bind.name = binding;
	bind.key = key;
	bind.binding = getKeyBinding( binding )[key];
	return bind;
}

binocular_hint()
{
	self waittill ("trigger");
	flag_set("bino_hint");

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
		
	// push/click [button] to use binoculars
	iprintlnbold( &"DEMOLITION_PLATFORM_HINTSTR_BINOCULAR", bind.binding );
}

smgGuy()
{
	// made the one escort guy magic bullet shield cause he has to show the player The Way
	for (;;)
	{
		level waittill ("set_smgguy", guy);
		if (isalive(guy))
		{
			guy notify ("stop magic bullet shield");
			waittillframeend; // because otherwise he'll get his old health after getting the shield health
			guy thread magic_bullet_shield();
		}
	}
}

exploderTrigger(num, delay)
{
	for (;;)
	{
		self waittill ("trigger");
		wait (delay);
		exploder(num);
	}
}

attackHardpoint()
{
	self waittill ("trigger");
	flag_set ("attack_hardpoint");
	flag_wait("move_out"); // friendlies flee the building
	self delete();
}

officeFriendlyChain()
{
	level endon ("trench_guys_start"); // in case the player runs through the area without killing all the Germans
	objEvent = getObjEvent("office");
	objEvent waittill_objectiveEvent();
	objChain = getnode(objEvent.target,"targetname");
	level.player setFriendlyChainWrapper(objChain);
	
//	objEvent objSetChainAndEnemies();
	// doing this manually so the smgguy doesnt get back on the friendly chain
	ai = getaiarray("allies");
	if (isalive(level.smgGuy))
	{
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] == level.smgGuy)
				continue;
			ai[i] setgoalentity (level.player);
		}
	}
	else
	for (i=0;i<ai.size;i++)
		ai[i] setgoalentity (level.player);
}

axisSecondWave(spawners)
{
	level endon ("axis_reinforce");
	maxGuys = 32; 
	if (level.fastVersion)
		maxGuys = 20; // mincpu cant handle so many ai!

	ai = getaiarray();
	if (ai.size + spawners.size >= maxGuys)
		return;
	
	array_thread (spawners, ::spawnAwaitAttack);	
}

/*
axisReinforceTriggers()
{
	level.retreatNodes = getnodearray ("reinforce_start_node","targetname");
	array_thread (getentarray("reinforce_trigger","targetname"), ::retreatTrigger);
}
*/

/*
retreatTrigger()
{
	self waittill ("trigger");
	nodes = getnodearray(self.target,"targetname");
	self delete();
	if (nodes[0].origin[0] <= level.retreatNodes[0].origin[0])
		return;
	level.retreatNodes = nodes;
	level notify ("new_retreat_node");
}
*/


axisDefenderSpawners()
{
	/*
	// player ran too close already
	if (flag ("hit_end_trigger"))
		return;
		
	level endon ("hit_end_trigger");
	*/
	
	level endon ("attack_hardpoint");
	level endon ("stop_hardpoint_spawners");

	level.axis_defenders = 0;
	spawners = getentarray("axis_retreat_defender","targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] endon ("death");
		
	index = 0;
	
	// put a hard limit on the # of guys that can spawn to each fallback point
	for (i=0;i<7;i++)
		level.fallbackLimit[i] = 20;
	
	for (;;)
	{
		if (level.axis_defenders < 16 && getaiarray().size + level.axis_defenders < 32)
		{
			index++;
			if (index >= spawners.size)
				index = 0;
			spawners[index] thread defenderSpawners();
			wait (0.25);
		}
		else
			wait (2.5);
	}
}

defenderSpawners()
{
	if (level.fallbackLimit[level.fallback] <= 0)
		return;

	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
		
	level.fallbackLimit[level.fallback]--;
		
	level.axis_defenders++;
	spawn defenderRetreat();
	level.axis_defenders--;
}

deleteAIwestOf(org, exclude)
{
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		excluded = false;
		for (p=0;p<exclude.size;p++)
		{
			if (ai[i] != exclude[p])
				continue;
			excluded = true;
			break;
		}
		if (excluded)
			continue;
			
		if (ai[i].origin[0] < org)
			ai[i] delete();
	}
}

setupRetreatNodes()
{
	// the arrays of nodes the axis will retreat to
	for (i=0;i<7;i++)
	{
		level.retreatNodes[i] = [];
		level.retreatNode_Occupier[i] = 0;
		level.retreatNode_OccupierMax[i] = 0;
	}

	nodes = getnodearray("fallback_node", "targetname");
	for (i=0;i<nodes.size;i++)
	{
		level.retreatNodes[nodes[i].script_fallback][level.retreatNodes[nodes[i].script_fallback].size] = nodes[i];
		nodes[i].fallbackers = 0;
	}
}

reinforceTrigger()
{
	level endon ("attack_hardpoint");
	num = self.script_fallback;
	for (;;)
	{
		self waittill ("trigger");
		if (level.player_fallback < num)
			level.player_fallback = num;
			
		if (num < level.fallback)
			break;

		level.fallback = num;
		level notify ("new_retreat_node");
		if (!flag("autosave" + level.fallback))
		{
			autosave(7);
			flag_set("autosave" + level.fallback);
		}
		node = getnode(self.target,"targetname");
		level.player setfriendlychain(node);
		break;
	}
	self delete();
}

waveTrigger()
{
	// makes wave guys wave
	for (;;)
	{
		self waittill ("trigger", other);
		/*
		if (!isdefined (other.script_noteworthy))
			continue;
		if (!isdefined (other.script_noteworthy != "waver"))
			continue;
		*/
		if (isdefined (other.wave)) // already waved
			continue;
		other thread wave();
	}
}

wave()
{
	self endon ("death");
	self.wave = true;
	self.animname = "generic";
//	self anim_single_solo (self, "wave");
	self.run_combatanim = %run_and_wave;
	wait (2);
	self.run_combatanim = undefined;
}

chunkSpawnStart(array, fx, slice, timer, angles, rate)
{
	for (i=0;i<array.size;i++)
		array[i] thread chunkSpawner(fx, slice, timer, angles, rate);
}

chunkSetFX(array, fx)
{
	for (i=0;i<array.size;i++)
		array[i].fx = fx;
}

chunkSpawner(fx, slice, timer, angles, rate)
{
	self setmodel ("xmodel/tag_origin");
	self.angles = angles;
	self linkto(slice); //,  (0,0,0), (0,90,0));
	self endon ("done");
	thread delete_timer(timer);
	self.fx = fx;
//	thread previewliner(angles);
	for (;;)
	{
//		if (randomint(100) > 90)
			playfxontag ( level._effect[self.fx], self, "TAG_ORIGIN");

		wait (rate);
	}
}

previewliner(angles)
{
	for (;;)
	{
		angles = self gettagangles("TAG_ORIGIN");
		forward = anglestoforward(angles);
		forward = vectorscale(forward, 15);		
		org = self gettagorigin("TAG_ORIGIN");
		line (org, org + forward, (1,1,0));
		wait (0.05);
	}
}

delete_timer(timer)
{
	wait (timer);
	self notify ("done");
}

defendDialogueTriggerWait()
{
	// monitors if the player has passed the targetted triggers, causing more dialogue
	trigger = getent (self.target,"targetname");
	trigger waittill ("trigger");
	flag_set("defend_dialogue_trigger_2");	
	trigger = getent (trigger.target,"targetname");
	trigger waittill ("trigger");
	flag_set("defend_dialogue_trigger_3");	
}

axisDrones()
{
	if (!level.fastVersion) // min cpu doesnt even get drones!
		level.axis_trigger triggerOn();
	if (level.player istouching (level.axis_trigger))
		level.axis_trigger notify ("trigger");

	wait (5);
	level.axis_trigger triggerOff();
	level.axis_trigger notify ("stop_drone_loop");
}

smokeStart()
{
	thread smokeGen();
	getent ("smoke_trigger", "targetname") thread smokeTrigger();
}

increaseAllies()
{
	level.alliesCounter = 10;
}

stopAxisDefenders()
{
	self waittill ("trigger");
	flag_set("stop_hardpoint_spawners");
}


handleRemoveandSpawnofAI()
{
	flag_wait("defend_dialogue_trigger_3");	
	array_thread (getentarray("pre_attackers","targetname"), ::spawnAttack);
	array_thread (getentarray("axis_charge","targetname"), ::spawnAwaitAttack);
}

commissar_idle(commissar)
{
	self waittill ("stay");
	anim_loop_solo (commissar, "idle", undefined, "stopLoop");
}

prepDefenderSpawners()
{
	self endon ("death");
	self.count = 1;
	for (;;)
	{
		self waittill ("spawned", spawn);
		if (spawn_failed(spawn))
			continue;
//		spawn.ignoreme = true;
	}
}

handmadness()
{
	for (;;)
	{
		self animscripts\shared::putGunInHand ("left");
		wait (2);
		self animscripts\shared::putGunInHand ("right");
		wait (2);
	}
}

liner ( start, end)
{
	trace = bullettrace(start, end, false, undefined);
	for (;;)
	{
		line (start, trace["position"], (1,0,0));
		line (start + (0,0,1), end + (0,0,1), (0,0,1));
		wait (0.05);
	}
}

ambientDialogue(msg)
{
	if (self == level.leonov)
		return;
		
	ambientDialogueProc(false, msg);
}

ambientSoundDialogue(msg)
{
	if (self == level.leonov)
		return;
		
	ambientDialogueProc(true, msg);
}

ambientDialogueProc(soundOnly, msg)
{
	ai = getaiarray("allies");
	if (!isdefined(level.dialogueGuy))
		level.dialogueGuy = [];
	
	excluder = [];
	// exclude the most recent 5 people that talked
	for (i=level.dialogueGuy.size-1; i>=level.dialogueGuy.size-5;i--)
	{
		if (i <= 0)
			break;
		excluder[excluder.size] = level.dialogueGuy[i];
	}
	guy = getClosestAIExclude (level.player.origin, "allies", excluder);
	assertEx(isalive(guy), "script assumed it could get a guy but could not");
	if (!isalive(guy))
		return;
		
	level.dialogueGuy[level.dialogueGuy.size] = guy;	
	if (!soundOnly)
	{
		guy.animname = "generic";
		guy anim_single_solo(guy, msg);
	}
	else
		guy playSoundOnEntity(level.scrsound["generic"][msg]);
}

germanDemoralizingChatter(msg)
{
	level endon (msg);
	
	index = 0;
	wait (2);
	for (;;)
	{
		self playsoundinspace (level.announcement[index]);
		wait (1 + randomfloat(3));
		index++;
		if (index >= level.announcement.size)
			index = 0;
	}
}

germanPATrigger()
{
	// more propaganda chatter from the Germans
	self waittill ("trigger");
	getent("german_pa_2","targetname") germanDemoralizingChatter("german_demoralizing_chatter2");
}

stopGermanPATrigger()
{
	self waittill ("trigger");
	battleChatterOn( "allies" );
	flag_set("german_demoralizing_chatter");
}


deleteTanks()
{
	for (;;)
	{
		self waittill ("trigger", other);
		other delete();
	}
}

showIgnoreme()
{
	for (;;)
	{
		ai = getaiarray("allies");
		for (i=0;i<ai.size;i++)
			print3d (ai[i].origin + (0,0,64), "" + ai[i].ignoreme, (1,1,1), 5);
		wait (0.05);
	}
}

triggerDetectPlayer()
{
	level endon ("germans_retreat");
	level.hide_filled = 4 * 20; // seconds * serverframetime
	for (;;)
	{
		self waittill ("trigger");
		while (level.hide_filled > 0)
		{
			if (!level.player istouching (self))
				break;
			level.hide_filled--;
			wait (0.05);
		}
		if (!level.player istouching (self))
			continue;
		if (!flag("grenade_player"))
		{
			flag_set ("grenade_player");
			level.grenadesToThrow = 4;
			level.hide_filled = 4*20;
		}
		flag_waitopen("grenade_player");
	}
}

triggerGrenades()
{
	level endon ("germans_retreat");
	ent = getent(self.target,"targetname");
	extraHeight = 100;
	range = 100;

	thread triggerDetectPlayer();
			
	for (;;)
	{
		/*
		ent = getent(self.target,"targetname");
		extraHeight = 100;
		range = 100;
		org1 = ent.origin;
		org2 = getent(ent.target,"targetname").origin;

		angles = vectortoangles ((org2[0], org2[1], 0) - (org1[0], org1[1], 0));
		forward = anglestoforward(angles);
		right = anglestoright(angles);
		right = vectorscale(right, randomfloat(range) - range*0.5);
		back  = vectorscale(forward, -300);
		

		org1 = ent.origin + back + right + (0,0,extraHeight);
		org2 = getent(ent.target,"targetname").origin + (0,0,extraHeight);
		angles = vectortoangles (org2 - org1);
		forward = anglestoforward(angles);
		vec = vectorscale(forward, 860 + randomint (50));

		
		getaiarray("axis")[0] magicgrenademanual(org1 + randomvector(5), vec, 10000);
		wait (0.2);

		if (1) continue;
		*/
				
		flag_wait ("grenade_player");
		if (!level.player istouching(self))
			self waittill ("trigger");

		if (!flag("grenade_player"))
			continue;
		level.grenadesToThrow--;
		if (level.grenadesToThrow <= 0)
			flag_clear ("grenade_player");

		axis = getaiarray("axis");
		if (!axis.size)
		{
			wait (0.1);
			continue;
		}
		
		ent = getent(self.target,"targetname");
		extraHeight = 100;
		range = 100;
		org1 = ent.origin;
		org2 = getent(ent.target,"targetname").origin;

		angles = vectortoangles ((org2[0], org2[1], 0) - (org1[0], org1[1], 0));
		forward = anglestoforward(angles);
		right = anglestoright(angles);
		right = vectorscale(right, randomfloat(range) - range*0.5);
		back  = vectorscale(forward, -300);

		org1 = ent.origin + back + right + (0,0,extraHeight);
		org2 = getent(ent.target,"targetname").origin + (0,0,extraHeight);
		angles = vectortoangles (org2 - org1);
		forward = anglestoforward(angles);
		vec = vectorscale(forward, 860 + randomint (50));

		getaiarray("axis")[0] magicgrenademanual(org1 + randomvector(5), vec, 3 + randomfloat(2));
		wait (1.5 + randomfloat(1.5));
	}
}

moveplayer()
{
	wait (0.05);
	level.player setorigin ((940, 493, 7));
	timer = gettime() + 10000;
	for (;;)
	{
		if (timer <= gettime())
		{
			timer = gettime() + 10000;
			grenades = getentarray("grenade","classname");
			grenades = array_randomize(grenades);
			for (i=0;i<grenades.size-200;i++)
				grenades[i] delete();
		}
		wait (0.05);
	}
}

aiLowAccuracyVSAI()
{
	self endon ("death");
	oldAccuracy = self.baseAccuracy;
	self.baseAccuracy = 0.2;
	if (self.team == "allies")
		return;
	for (;;)
	{
		if (isalive(self.enemy))
		{
			if (self.enemy == level.player)
				self.baseAccuracy = oldAccuracy;
			else
				self.baseAccuracy = 0.2;
		}
		
		wait (0.2);
	}
}

spawnerLowAccuracyVSAI()
{
	self endon ("death");
	for (;;)
	{
		self waittill ("spawned", spawn);
		if (spawn_failed(spawn))
			continue;
		spawn thread aiLowAccuracyVSAI();
	}
}

friendlyForcetrigger()
{
	// friendly chain trigger that turns on after a delay so the friendlies can auto move up
	
	self waittill ("trigger");
	triggerOff();
	wait (5);
	
//	trigger = getent ("enemy_detect","script_noteworthy");
	triggers = getentarray ("auto2076","targetname");
	// dont trigger if enemies are still hanging out in the street
	for (;;)
	{
		toucher = [];
		for (p=0;p<triggers.size;p++)
		{
			trigger = triggers[p];
			ai = getaiarray("axis");
			toucher[p] = false;
			for (i=0;i<ai.size;i++)
			{
				if (!ai[i] istouching (trigger))
					continue;
				toucher[p] = true;
				break;
			}
			if (toucher[p])
				continue;
			wait (0.1);
		}
		touchers = false;
		for (p=0;p<triggers.size;p++)
		{
			if (toucher[p])
			{
				touchers = true;
				break;
			}
		}
		if (!touchers)
			break;
		
		wait (1);
	}
	
	triggerOn();
	for (;;)
	{
		if (!level.player istouching (self)) // in case the player is already in the trigger since it just got moved
			self waittill ("trigger");
		
		chain_node = getnode(self.target, "targetname");
		level.player setfriendlychain(chain_node);
		while (level.player istouching (self))
			wait (0.2);
	}
}

playerBlocker()
{
	level.player_blocker = self;
	self.original_origin = self.origin;
	self moveto (self.origin + (-100,0,0), 1);
}

trenchGuys(chain_node)
{
	self waittill ("trigger");
	getent ("tank_display","targetname") delete();

	level.player setfriendlychain(chain_node);
	
	level.trenchFollowGuy setgoalentity (level.player);
	level.trenchFollowGuy.dontAvoidPlayer = true;
	level.trenchFollowGuy.followmin = -1;
	level.trenchFollowGuy.followmax = 0;

	//start the trench follow guys
	array_thread (getentarray("trench_follower","targetname"), ::trenchFollowGuy);
}

cullfogDisable()
{
	for (;;)
	{
		self waittill ("trigger");
		if (level.fastVersion)
			setExpFog(0.000145, 156/256, 158/256, 148/256, 0);
		wait (0.25);
	}
}

cullfogEnable()
{
	for (;;)
	{
		self waittill ("trigger");
		if (level.fastVersion)
			setCullFog(1000, 4500, 156/256, 158/256, 148/256, 0);
		wait (0.25);
	}
}

objectiveHintTrigger()
{
	hint = self.script_noteworthy;
	hintflag = "hint_" + hint;
	
	hintStringArray["use_explosives"] 			= &"DEMOLITION_PLATFORM_OBJ_HINT_USE_EXPLOSIVES";
	hintStringArray["plant_explosives"] 		= &"DEMOLITION_OBJ_HINT_PLANT_EXPLOSIVES";
	hintStringArray["plant_explosives_singular"]= &"DEMOLITION_OBJ_HINT_PLANT_EXPLOSIVES_SINGULAR";
	hintStringArray["plant_explosives_plural"] 	= &"DEMOLITION_OBJ_HINT_PLANT_EXPLOSIVES_PLURAL";
	hintStringArray["get_explosives"] 			= &"DEMOLITION_OBJ_HINT_GET_EXPLOSIVES";
	hintStringArray["height_above"] 			= &"DEMOLITION_OBJ_HINT_HEIGHT_ABOVE";
	hintStringArray["height_below"] 			= &"DEMOLITION_OBJ_HINT_HEIGHT_BELOW";
	
	hintString = hintStringArray[hint];
	
	level.lastPlantHint = 0;
	
	for (;;)
	{
		self waittill ("trigger");
		if (!flag(hintflag))
		{
			wait (1);
			continue;
		}
		
		if (hintString == hintStringArray["plant_explosives_singular"]
		 || hintString == hintStringArray["plant_explosives_plural"]
		 || hintString == hintStringArray["use_explosives"])
		{
			if (gettime() < level.lastPlantHint + 13000)
				continue;
			level.lastPlantHint = gettime();
		}
		
		// use explosives requires a key binding to be passed to the hint string
		if (hint == "use_explosives")
			iprintlnbold( hintString, getKeyBinding( getUseKey() )["key1"]);
		else
			iprintlnbold( hintString);

		for (i=2;i<8;i++)
			objective_ring(i);
		wait (10);
	}
}

endObjectiveHint()
{
	level endon ("end_objective_hint");
	for (;;)
	{
		wait (20);
		iprintlnbold( &"DEMOLITION_OBJ_HINT_COMMISSAR");
	}
}

tankDisplay()
{
	self endon ("death");
	path = getvehiclenode(self.target,"targetname");
	self attachPath( path );
	flag_wait("bino_hint");	
	self thread tankDisplayTargetsOrigins(getent("tank_target","targetname"));
	self setwaitnode(getvehiclenode("waitnode_1","script_noteworthy"));
	self startpath();
	self waittill ("reached_wait_node");
	self setspeed(0,5);
	wait (4);
	self setwaitnode(getvehiclenode("waitnode_2","script_noteworthy"));
	self setspeed(4,2);
	self waittill ("reached_wait_node");
	self setspeed(0,5);
	wait (6);
	self setspeed(4,2);

	self setwaitnode(getvehiclenode("waitnode_3","script_noteworthy"));
	self waittill ("reached_wait_node");
	self setspeed(0,150);
	wait (6);
	self setspeed(4,2);

	self setwaitnode(getvehiclenode("waitnode_4","script_noteworthy"));
	self waittill ("reached_wait_node");
	self setspeed(0,150);
	wait (1.5);
	self setspeed(4,2);
	self notify ("path_complete");
}

tankDisplayTargetsOrigins(target)
{
	self endon ("death");
	self endon ("path_complete");
	originalTarget = target;
	for (;;)
	{
		self setTurretTargetEnt(target, (0,0,0));
		wait (2.2 + randomfloat(3));
		if (!isdefined(target.target))
			target = originalTarget;
		else
			target = getent(target.target,"targetname");
	}
}
#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");
main()
{
	flag_clear("battle_dialogue");
	array_thread(getentarray("artillery_gun","targetname"), ::artillery_gun);
	flag_wait("do_thermites");
	
	//stop some drones on the right feild
	trigs = getentarray("looping_drones_rightfield","script_noteworthy");
	for( i = 0 ; i < trigs.size ; i++ )
	{
		trigs[i] notify ("stop_drone_loop");
		trigs[i].script_delay = -1;
	}
	
	maps\duhoc_town::town_triggers_disable();
	
	assert(isdefined(level.randall));
	
	thread autoSaveByName("found_guns");
	
	//disable old friendlychains
	array_thread(getentarray("friendlychain_town","script_noteworthy"), ::triggerOff);
	//turn on the return ai spawn trigs and friendly chains
	array_thread(getentarray("return_ai_trigger","script_noteworthy"), ::triggerOn);
	array_thread(getentarray("friendlychain_returntrip","script_noteworthy"), ::triggerOn);
	
	thread planting_guns_battlechatter();
	thread artillery_gun_randall();
	thread gate_sequence();
	thread friends_advance_gate();
	
	//add objective here
	level.artillery_guns_remaining = getentarray("artillery_gun","targetname").size;
	objective_destroy_artillery_guns();
}

friends_advance_gate()
{
	//when field germans are dead the allies automatically move up
	level endon ("cancel_friends_advance_gate");
	thread friends_advance_gate_disable();
	waittill_aiAndSpawners_dead(getentarray("field_german_spawner","script_noteworthy"));
	
	level.player setfriendlychain(getnode("friends_gate_chain1","script_noteworthy"));
	level notify ("friends_advancing_gate");
}

friends_advance_gate_disable()
{
	level endon ("friends_advancing_gate");
	getent("entering_house_again","targetname") waittill ("trigger");
	level notify ("cancel_friends_advance_gate");
}

leaving_town_autosave()
{
	getent("leaving_town_autosave","targetname") waittill ("trigger");
	thread autoSaveByName("leaving_town");
}

objective_destroy_artillery_guns()
{
	flag_clear("guns_destroyed");
	objective_state(level.objective["locate_coastal_guns"], "done");
	objective_position(level.objective["locate_coastal_guns"], (0,0,0) );
	objective_string(level.objective["locate_coastal_guns"], &"DUHOC_OBJ_DESTROYGUNS_COUNT", level.artillery_guns_remaining );
	objective_current(level.objective["locate_coastal_guns"]);
	level.artillery_gun_positions = 0;
}

objective_backtoRallyPoint()
{
	objective_string(level.objective["locate_coastal_guns"], &"DUHOC_OBJ_DESTROYGUNS" );
	objective_state( level.objective["locate_coastal_guns"], "done" );
	flag_set("guns_destroyed");
	
	//flag_wait("back_to_rallypoint");
	wait 0.1;
	objective_add( level.objective["rallypoint"], "current", &"DUHOC_OBJ_RALLYPOINT", (-594, 7315, 1065) );
	flag_wait("remaining_bunkers");
	thread clear_right_field();
}

artillery_gun()
{
	trigger = undefined;
	thermite = undefined;
	ents = getentarray(self.target,"targetname");
	for (i=0;i<ents.size;i++)
	{
		if (ents[i].classname == "trigger_use")
			trigger = ents[i];
		else if (ents[i].classname == "script_model")
			thermite = ents[i];
	}
	assert(isdefined(trigger));
	assert(isdefined(thermite));
	
	trigger sethintstring(&"DUHOC_PLATFORM_USETHERMITE", getKeyBinding( getUseKey() )["key1"]);
	
	thermite hide();
	trigger triggerOff();
	flag_wait("do_thermites");
	thermite show();
	trigger triggerOn();
	
	thermite setmodel ("xmodel/weapon_us_thermite_grenade_obj");
	
	//update objective remaining count here
	objective_index = level.artillery_gun_positions;
	level.artillery_gun_positions++;
	objective_additionalposition(level.objective["locate_coastal_guns"],objective_index, thermite.origin);
	
	trigger waittill ("trigger");
	trigger delete();
	thermite setmodel ("xmodel/weapon_us_thermite_grenade");
	thermite playsound ("thermitegrenade_plant");
	
	//decreaase objective remaining count here and update objective
	objective_additionalposition(level.objective["locate_coastal_guns"],objective_index, (0,0,0) );
	level.artillery_guns_remaining--;
	objective_string(level.objective["locate_coastal_guns"], &"DUHOC_OBJ_DESTROYGUNS_COUNT", level.artillery_guns_remaining );
	
	if (level.artillery_guns_remaining <= 0)
	{
		thread objective_backtoRallyPoint();
		level thread roadblock_setup();
		thread leaving_town_autosave();
		level.inventory_thermite maps\_inventory::inventory_destroy();
	}
	
	//add a timer for the thermite fuse time
	artillery_gun_stopwatch();
	
	playfx(level._effect["thermite"], thermite.origin);
	thread playsoundinspace("thermitegrenade_explosion", thermite.origin);
	self setmodel("xmodel/german_artillery_155gpf_d");
	thermite delete();
}

artillery_gun_stopwatch()
{
	artillery_gun_stopwatch_delete();
	
	level.bombstopwatch = maps\_utility::getstopwatch(60);
	
	wait level.explosiveplanttime;
	
	artillery_gun_stopwatch_delete();
}

artillery_gun_stopwatch_delete()
{
	if (isdefined (level.bombstopwatch))
		level.bombstopwatch destroy();
}

artillery_gun_randall()
{
	//randall plants thermits on 2 of the guns and then returns to his position near the road
	assert(isdefined(level.randall));
	level.randall.animname = "randall";
	level.randall allowedStances("crouch");
	
	level.randall thread anim_single_solo(level.randall, "duhocassault_randall_onesoverhere");
	
	guns = getentarray("artillery_gun_randall","targetname");
	for( i = 0 ; i < guns.size ; i++ )
	{
		guns[i].thermite = getent(guns[i].target,"targetname");
		guns[i].thermite hide();
	}
	for( i = 0 ; i < guns.size ; i++ )
	{
		level.randall anim_reach_solo(level.randall, "plant_thermite", undefined, guns[i]);
		level.randall thread artillery_gun_randall_thermiteNotetrack(guns[i]);
		level.randall anim_single_solo(level.randall, "plant_thermite", undefined, guns[i]);
	}
	guns = undefined;
	nodes = undefined;
	
	//randall runs out of thermite grenades
	level.randall thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound[level.randall.animname]["duhocassault_randall_outtathermite"], 1);
	
	//run back to the entrance and wait for the player to finish his objective
	randall_node = getnode("randall_doneplanting_node","targetname");
	level.randall.goalraius = 16;
	level.randall setgoalnode (randall_node);
	
	//do the animation "...get back to rally point..."
	flag_wait("guns_destroyed");
	getent ("thermites_planted_dialogue_trigger","targetname") waittill ("trigger");
	level.randall allowedStances("stand","crouch","prone");
	level.randall anim_reach_solo(level.randall, "thermites_planted", undefined, randall_node);
	level.randall maps\duhoc_assault::scene_playAnim("thermites_planted", undefined, randall_node, undefined, "duhocassault_randall_getthehellout");
	//flag_set("back_to_rallypoint");
	level.randall allowedStances("stand","crouch","prone");
	level.randall.goalradius = 8;
	level.randall setgoalnode( getnode("randall_mopup_node","targetname") );
}

artillery_gun_randall_thermiteNotetrack(gun)
{
	assert(isdefined(gun.thermite));
	self waittillmatch ("single anim", "detach");
	
	gun.thermite playsound ("thermitegrenade_plant");
	gun.thermite show();
	wait level.explosiveplanttime;
	playfx(level._effect["thermite"], gun.thermite.origin);
	thread playsoundinspace("thermitegrenade_explosion", gun.thermite.origin);
	wait 0.1;
	gun setmodel("xmodel/german_artillery_155gpf_d");
	gun.thermite delete();
}

planting_guns_battlechatter()
{
	origins = getentarray("planting_guns_battlechatter","targetname");
	
	alias[0] = "duhocassault_gi3bck_fallschirm";		//(whispered O.S.) "Radioman! Find out when the Fallschirmjager company will be ready to advance!"
	alias[1] = "duhocassault_gi3bck_findlt";			//(whispered O.S.) "Find the Lieutenant! Tell him we need to get the tanks up here ASAP!"
	alias[2] = "duhocassault_gi3bck_getmestatus";		//(whispered O.S.) "Get me the status of those halftracks to the northwest!"
	alias[3] = "duhoc_gi3bck_halfthearmy";				//"They must be sending out half the American Army!"
	alias[4] = "duhoc_gi3bck_largenumbers";				//"American troops attacking in large numbers!"
	alias[5] = "duhoc_gi2bck_takehalfofplatoon";		//"Lieutenant, take half of 1st platoon around those hedgerows to the east! Get a machine gun set up in the treeline and suppress the Americans by the bridge!"
	alias[6] = "duhocassault_gi3bck_panzerbn";			//"Radioman! Contact the 2nd Panzer Battalion commander! I want those Panther tanks moving up here immediately!"
	alias[7] = "duhocassault_gi2bck_riverbed";			//"2nd squad! Move up through the riverbed and stay low! Use your hand grenades as soon as you're within range of the bridge! Then wait for 3rd squad to move up with the machine gun! Stay close to the hedgerow on the right side!"
	alias[8] = "duhocassault_gi2bck_swingaround";		//"Swing around to the left! Use the shell craters for cover!"
	alias[9] = "duhocassault_gi2bck_stayhere";			//"You four stay here with the 80mm mortar and aim for those trenches! You two – get the machine gun set up and fire low over their positions! The rest of you, come with me!"
	alias[10] = "duhocassault_gi2bck_whatthehell";		//"What the hell is going on here? Who's in command of this unit?"
	alias[11] = "duhocassault_gi2bck_getyourmen";		//"Get your men into those trenches!"
	alias[12] = "duhocassault_gi3bck_fieldstowest";		//"Sergeant! Take your men on a flanking mission through the fields to the west! Try and capture that house and get a machine gun in the window!"
	alias[13] = "duhocassault_gi3bck_keepmortars";		//"Keep those mortars firing!"
	alias[14] = "duhocassault_gi3bck_forward";			//"Move in!"
	alias[15] = "duhocassault_gi3bck_minefields";		//"Watch out for minefields!"
	
	for (i=0;i<alias.size;i++)
	{
		rand = randomint(origins.size);
		origins[rand] playsound (alias[i], "sounddone");
		origins[rand] waittill ("sounddone");
		wait (0.2 + randomfloat(0.3));
	}
	
	for (i=0;i<origins.size;i++)
		origins[i] delete();
}

roadblock_setup()
{
	//delete all the allies and axis in the level (except for randall)
	ai = getaiarray("axis","allies");
	for (i=0;i<ai.size;i++)
	{
		if (ai[i] == level.randall)
			continue;
		ai[i] delete();
	}
	
	//spawn the roadblock guys
	spawner_roadblock = getentarray("spawner_roadblock","targetname");
	for (i=0;i<spawner_roadblock.size;i++)
	{
		guy = spawner_roadblock[i] stalingradSpawn();
		if (spawn_failed(guy))
			continue;
		if (!isdefined(guy.script_noteworthy))
			continue;
		switch(guy.script_noteworthy)
		{
			case "carter":
				level.carter = guy;
				level.carter.animname = "carter";
				level.carter thread magic_bullet_shield();
				break;
			case "ward":
				level.ward = guy;
				level.ward.animname = "ward";
				level.ward thread magic_bullet_shield();
				break;
			case "mccloskey":
				level.mccloskey = guy;
				level.mccloskey.animname = "mccloskey";
				level.mccloskey thread magic_bullet_shield();
				break;
		}
	}
	
	//spawn braeburn
	braeburn_roadblock = getent("braeburn_roadblock","targetname");
	braeburn_roadblock_node = getnode(braeburn_roadblock.target,"targetname");
	assert(isdefined(braeburn_roadblock_node));
	level.braeburn = braeburn_roadblock stalingradSpawn();
	if(spawn_failed(level.braeburn))
	{
		assertMsg("Braeburn failed to spawn at the roadblock");
		return;
	}
	
	assert(isdefined(level.randall));
	assert(isdefined(level.mccloskey));
	assert(isdefined(level.carter));
	assert(isdefined(level.ward));
	assert(isdefined(level.braeburn));
	
	level.braeburn allowedstances("crouch");
	level.braeburn.animname = "braeburn";
	level.braeburn.goalradius = 8;
	level.braeburn setgoalnode(braeburn_roadblock_node);
	
	//wait until randall and the player are headed back to the roadblock
	getent("braeburn_radio_animation","targetname") waittill ("trigger");
	
	//braeburn does his radio animation
	level.braeburn attach("xmodel/us_ranger_radio_hand");
	level.braeburn anim_reach_solo(level.braeburn, "secure_remaining_bunkers", undefined, braeburn_roadblock_node);
	level.braeburn anim_single_solo(level.braeburn, "secure_remaining_bunkers", undefined, braeburn_roadblock_node);
	level.braeburn detach("xmodel/us_ranger_radio_hand");
	
	thread autoSaveByName("guns_destroyed");
	
	musicstop(30);
	
	//randall responds "Taylor Ward Carter! Let’s go mop up!  The rest of you stay here and hold this road until the rest of the company shows up!"
	level.randall thread anim_single_solo(level.randall, "duhocassault_randall_gomopup");
	wait 2;
	thread roadblock_friendlychain();
	flag_set("remaining_bunkers");
	
	//did you find the guns? damn right...
	wait 8;
	level.mccloskey anim_single_solo(level.mccloskey, "duhocassault_mcc_findthoseguns");
	level.randall anim_single_solo(level.randall, "duhocassault_randall_damnright");
}

roadblock_friendlychain()
{
	assert(isdefined(level.randall));
	assert(isdefined(level.mccloskey));
	assert(isdefined(level.carter));
	assert(isdefined(level.ward));
	
	level.player setfriendlychain(getnode("roadblock_friendlychain_node","targetname"));
	
	level.randall.followmin = 0;
	level.randall.followmax = 4;
	level.randall setgoalentity(level.player);
	
	level.mccloskey.followmin = 0;
	level.mccloskey.followmax = 4;
	level.mccloskey setgoalentity(level.player);
	
	level.carter.followmin = 0;
	level.carter.followmax = 4;
	level.carter setgoalentity(level.player);
	
	level.ward.followmin = 0;
	level.ward.followmax = 4;
	level.ward setgoalentity(level.player);
}

gate_sequence()
{
	flag_wait("openGateAllowed");
	
	getent("gate_spawn_trigger","targetname") waittill ("trigger");
	
	//delete a floating mg42 in one of the bunkers
	getent ("floating_mg42","script_noteworthy") delete();
	
	thread gate_friendlyChain();
	
	guy1_spawner = getent("gate_bomb_planter","targetname");
	guy1_animnode = getnode(guy1_spawner.target,"targetname");
	guy1_runnode = getnode(guy1_animnode.target,"targetname");
	
	guy1 = guy1_spawner stalingradSpawn();
	if (spawn_failed(guy1))
		return;
	guy1.animname = "gateguy";
	guy1 thread magic_bullet_shield();
	guy1.anim_disablePain = true;
	guy1.ignoreme = true;
	guy1 thread anim_loop_solo (guy1, "idle", undefined, "stop_idle", guy1_animnode);
	
	//wait until the player approaches
	getent("gate_run_trigger","targetname") waittill ("trigger");
	
	//guy runs away!
	if (isdefined(guy1))
	{
		guy1 notify ("stop_idle");
		guy1.goalradius = 8;
		guy1 setgoalnode (guy1_runnode);
	}
	
	badplace_cylinder("gatebomb", -1, getent("gate_location","targetname").origin - (0,0,75), 400, 400 , "allies","axis");
	
	wait 0.5;
	
	if (isdefined(guy1))
	{
		guy1 anim_single_solo(guy1, "run");
		guy1 notify ("stop magic bullet shield");
	}
	else
		wait 4;
	
	thread gate_blast_open();
	badplace_delete("gatebomb");
	
	flag_set("update_bunker_positions");
}

gate_friendlyChain()
{
	getent("gate_friendlychain_trigger","targetname") waittill ("trigger");
	
	//put all allies on friendly chain
	level.player setfriendlychain(getnode("gate_friendlychain_node","targetname"));
	allies = getaiarray("allies");
	node1 = getnode ("gate_node_1","targetname");
	node2 = getnode ("gate_node_2","targetname");
	for (i=0;i<allies.size;i++)
	{
		if (!isdefined(allies[i].script_noteworthy))
			continue;
		if (allies[i].script_noteworthy == "gate_node_1")
		{
			allies[i].goalradius = node1.radius;
			allies[i] setgoalnode(node1);
		}
		else if (allies[i].script_noteworthy == "gate_node_2")
		{
			allies[i].goalradius = node2.radius;
			allies[i] setgoalnode(node2);
		}
		else if (allies[i].script_noteworthy == "gate_friendlychain")
		{
			allies[i].followmin = -5;
			allies[i].followmax = 5;
			allies[i] setgoalentity(level.player);
		}
	}
}

gate_blast_open()
{
	gate_door_left = getent("gate_door_left","targetname");
	gate_door_right = getent("gate_door_right","targetname");
	
	gate_door_left thread gate_blast_open_left();
	gate_door_right thread gate_blast_open_right();	
	
	vec = (1325, -241, 1275);
	thread playsoundinspace("explo_metal_rand", vec );
	playfx (level._effect["gate"], vec );
	
	wait 0.2;
	//if player is within 320 units of gate, kill player from explosion
	if (distance(level.player.origin, vec) <= 320)
	{
		level.player enableHealthShield(false);
		level.player dodamage(level.player.health + 10, vec);
		level.player enableHealthShield(true);
		maps\_utility::missionFailedWrapper();
		return;
	}
	//radiusDamage(vec, 256, 200, 10);
	
	thread autoSaveByName("gate_opened");
}

gate_blast_open_left()
{
	self rotateto( self.angles + (0,90,0) , 0.2, 0.0, 0.0 );
	wait 0.2;
	self rotateto( self.angles - (0,90,0) , 0.6, 0.0, 0.5 );
	wait 0.6;
	self rotateto( self.angles + (0,60,0) , 1.4, 0.3, 1.0 );
	wait 1.4;
	self connectpaths();
}

gate_blast_open_right()
{
	self connectpaths();
	self rotateto( self.angles - (0,90,0) , 0.35, 0, 0 );
	wait 0.35;
	self rotateto( self.angles + (0,90,0) , 0.8, 0.0, 0.7 );
	wait 0.8;
	self rotateto( self.angles - (0,30,0) , 1.7, 0.5, 1.2 );
	wait 1.7;
	self disconnectpaths();
}

clear_right_field()
{
	bunker = getentarray ("bunker","targetname");
	level.bunkers_remaining = bunker.size;
	
	//add objective to secure the remaining bunkers
	objective_remaining_bunkers();
	
	for (i=0;i<bunker.size;i++)
		bunker[i] thread clear_right_field_bunkerThink(i);
	
	flag_wait("update_bunker_positions");
	
	for (i=0;i<bunker.size;i++)
		objective_additionalposition( level.objective["clear_bunkers"], i, getent(bunker[i].target,"targetname").origin );
}

clear_right_field_bunkerThink(positionIndex)
{
	area = self;
	ai = getaiarray("axis");
	spawners = getspawnerteamarray("axis");
	
	touchingAI_and_Spawners = [];
	
	for (i=0;i<ai.size;i++)
	{
		if (!ai[i] isTouching (area))
			continue;
		touchingAI_and_Spawners[touchingAI_and_Spawners.size] = ai[i];
	}
	
	for (i=0;i<spawners.size;i++)
	{
		if (!spawners[i] isTouching (area))
			continue;
		touchingAI_and_Spawners[touchingAI_and_Spawners.size] = spawners[i];
	}
	
	ai = undefined;
	spawners = undefined;
	
	waittill_aiAndSpawners_dead(touchingAI_and_Spawners);
	level.bunkers_remaining--;
	objective_additionalposition( level.objective["clear_bunkers"], positionIndex, (0,0,0) );
	objective_string( level.objective["clear_bunkers"], &"DUHOC_OBJ_BUNKERS", level.bunkers_remaining );
	
	switch(positionIndex)
	{
		case 0:
			thread autoSaveByName("bunker1_cleared");
			break;
		case 1:
			thread autoSaveByName("bunker2_cleared");
			break;
		case 2:
			thread autoSaveByName("bunker3_cleared");
			break;
	}
	
	level notify ("stop_mortars 0");
	level notify ("stop_mortars 1");
	level notify ("stop_mortars 2");
	level notify ("stop_mortars 3");
	level notify ("stop_mortars 4");
	level notify ("stop_right_field_mortars");
	level.noMortars = true;
	
	if (level.bunkers_remaining <= 2)
		thread battledialogue();
	if (level.bunkers_remaining <= 0)
		thread objective_remaining_bunkers_completed();
}

objective_remaining_bunkers()
{
	objective_state( level.objective["rallypoint"], "done" );
	gate_location = getent("gate_location","targetname").origin;
	objective_add( level.objective["clear_bunkers"], "current", &"DUHOC_OBJ_BUNKERS", gate_location );
	wait 0.1;
	objective_string( level.objective["clear_bunkers"], &"DUHOC_OBJ_BUNKERS", level.bunkers_remaining );
	flag_set("openGateAllowed");
	level notify ("start_mortars 2");
}

objective_remaining_bunkers_completed()
{
	objective_state( level.objective["clear_bunkers"], "done" );
	level thread enemy_cleanup();
}

waittill_aiAndSpawners_dead(guys)
{
	ent = spawnStruct();
	
	ent.count = guys.size;
	array_thread(guys, ::waittill_aiAndSpawners_dead_thread, ent);
	
	while (ent.count > 0)
		ent waittill ("waittill_dead guy died");
}

waittill_aiAndSpawners_dead_thread(ent)
{
	if (!isalive(self))	//a spawner so wait for it to spawn
	{
		self endon ("spawn_failed");
		self thread waittill_aiAndSpawners_dead_spawnfailed_thread(ent);
		self waittill ("spawned", guy);
	}
	else
		guy = self;
	
	if (!spawn_failed(guy))
		guy waittill ("death");
	
	ent.count--;
	ent notify ("waittill_dead guy died");
}

waittill_aiAndSpawners_dead_spawnfailed_thread(ent)
{
	self endon ("spawned");
	
	self waittill ("spawn_failed");
	
	ent.count--;
	ent notify ("waittill_dead guy died");
}

enemy_cleanup()
{
	area = getent("rightfield","targetname");
	enemies = getaiarray("axis");
	spawners = getspawnerteamarray("axis");
	
	//kill all the spawners so nobody else spawns
	for (i=0;i<spawners.size;i++)
		spawners[i] delete();
	spawners = undefined;
	
	//enemies outside the rightfield get killed
	//enemies inside the rightfield close in on the player
	remaining = [];
	for (i=0;i<enemies.size;i++)
	{
		if (!enemies[i] isTouching(area))
			enemies[i] doDamage(enemies[i].health + 1, enemies[i].origin);
		else
		{
			remaining[remaining.size] = enemies[i];
			enemies[i] thread maps\duhoc_assault::playerseek();
		}
	}
	enemies = undefined;
	
	if (remaining.size > 0)
	{
		thread objective_remaining_enemies();
		level waittill_dead(remaining);
		thread objective_remaining_enemies_done();
	}
	
	thread levelend_music();
	thread objective_finalspeach();
	
	//mission complete...do planes, animations/dialogue, and go to the next level
	thread finalspeach();
	thread planes();
	thread cheers();
	flag_wait("mission_complete");
	flag_wait("objectives_complete");
	wait 7;
	maps\_endmission::nextmission();
}

objective_remaining_enemies()
{
	wait 0.1;
	objective_add( level.objective["remaining_enemies"], "current", &"DUHOC_OBJ_ENEMIES", level.player.origin );
}

objective_remaining_enemies_done()
{
	objective_state( level.objective["remaining_enemies"], "done" );
}

planes()
{
	wait 5;
	
	level.spitfireSound = 1;
	plane_path = getvehiclenodearray("plane_path","targetname");
	for ( i=0 ; i < plane_path.size ; i++ )
		plane_path[i] thread planes_spawnAndDie();
	
	wait 12;
	
	plane_path = getvehiclenodearray("plane_path2","targetname");
	for ( i=0 ; i < plane_path.size ; i++ )
		plane_path[i] thread planes_spawnAndDie();
}

planes_sound()
{
	self endon ("reached_end_node");
	
	flybyAlias = undefined;
	switch(level.spitfireSound)
	{
		case 1:	flybyAlias = "plane_flyby_spitfire1"; break;
		case 2:	flybyAlias = "plane_flyby_spitfire2"; break;
		case 3:	flybyAlias = "plane_flyby_spitfire3"; break;
	}
	assert(isdefined(flybyAlias));
	level.spitfireSound++;
	if (level.spitfireSound > 3)
		level.spitfireSound = 1;
	
	//wait until the plane is close to the player
	for(;;)
	{
		flatPlanePos = (self.origin[0], self.origin[1], 0);
		flatPlayerOrigin = (level.player.origin[0], level.player.origin[1], 0);
		if ( distance(flatPlanePos, flatPlayerOrigin) <= 3200 )
			break;
		wait 0.05;
	}
	self playsound(flybyAlias);
}

planes_spawnAndDie()
{
	plane = spawnvehicle( "xmodel/vehicle_p51_mustang" , "plane" , "Stuka", self.origin, self.angles );
	
	plane attachpath(self);
	plane startpath();
	plane setspeed(160,10000);
	plane thread planes_sound();
	plane waittill ("reached_end_node");
	plane delete();
}

battledialogue()
{
	if (flag("battle_dialogue"))
		return;
	
	flag_set("battle_dialogue");
	
	x_min = 1300;
	x_max = 5000;
	
	y_min = 800;
	y_max = 2200;
	
	//while enemies still exist
	i = 0;
	alias[i] = "duhocassault_gr2_goaround"; i++; 		//"Go around and see if you can cut ‘em off!"
	alias[i] = "duhocassault_gr1_thirdsquad"; i++; 		//"3rd squad! Spread out!"
	alias[i] = "duhocassault_gr1_searchbunkers"; i++; 	//"Search those bunkers!"
	alias[i] = "duhocassault_gr2_holdleft"; i++; 		//"Hold the left side!"
	alias[i] = "duhocassault_gr2_cleardown"; i++; 		//"Clear down!"
	alias[i] = "duhocassault_gr5_tieupflanks"; i++; 	//"Tie up the flanks!"
	alias[i] = "duhocassault_gr2_keepemrunning"; i++; 	//"Keep ‘em running!"
	alias[i] = "duhocassault_gr3_watchtrenches"; i++; 	//"Watch those trenches!"
	alias[i] = "duhocassault_gr5_securearea"; i++; 		//"Secure the area!"
	
	level endon ("area_secure");
	for ( i = 0 ; i < alias.size ; i++ )
	{
		//x is always subtracted so it doesn't play off the wrong side of the cliff
		randX = x_min + randomfloat(x_max - x_min);
		soundX = level.player.origin[0] - randX;
		
		//y can be added or subtracted
		randY = y_min + randomfloat(y_max - y_min);
		if (randomint(2) == 0)
			randY = (randY * -1);
		soundY = level.player.origin[1] + randY;
		
		playsoundinspace( alias[i], (soundX, soundY, level.player.origin[2] + 72) );
		wait (2 + randomfloat(6));
	}
}

cheers()
{
	x_min = 1300;
	x_max = 5000;
	
	y_min = 800;
	y_max = 2200;
	
	
	level notify ("area_secure");
	
	i = 0;
	alias[i] = "duhocassault_gr1_clearup"; i++; 		//"Clear up!"
	alias[i] = "duhocassault_gr1_get60up"; i++; 		//"Get that sixty set up!"
	alias[i] = "duhocassault_gr1_mortarrounds"; i++; 	//"Bring up the mortar rounds!"
	alias[i] = "duhocassault_gr2_30calhere"; i++; 		//"I want the .30 cal right over here!"
	alias[i] = "duhocassault_gr3_checkwounded"; i++; 	//"Check for wounded!"
	alias[i] = "duhocassault_gr3_getmedicup"; i++; 		//"Get the medic up here!"
	alias[i] = "duhocassault_gr3_extramedkit"; i++; 	//"I need the extra medical kit!"
	alias[i] = "duhocassault_gr4_checkoutguns"; i++; 	//"Go check out those guns! Make sure they’re disabled!"
	alias[i] = "duhocassault_gr4_searchbodies"; i++; 	//"Search those bodies for intel!"
	alias[i] = "duhocassault_gr4_putupaid"; i++; 		//"Put up an aid station! Over here!"
	alias[i] = "duhocassault_gr5_setupperimeter"; i++; 	//"Set up a perimeter!"
	alias[i] = "duhocassault_gr5_getco"; i++; 			//"Get in touch with the CO!"
	alias[i] = "duhocassault_gr6_stretcherbearers"; i++; //"Stretcher bearers this way!"
	alias[i] = "duhocassault_gr5_watchforcounter"; i++; //"Watch for counterattacks!"
	
	for ( i = 0 ; i < alias.size ; i++ )
	{
		//x is always subtracted so it doesn't play off the wrong side of the cliff
		randX = x_min + randomfloat(x_max - x_min);
		soundX = level.player.origin[0] - randX;
		
		//y can be added or subtracted
		randY = y_min + randomfloat(y_max - y_min);
		if (randomint(2) == 0)
			randY = (randY * -1);
		soundY = level.player.origin[1] + randY;
		
		playsoundinspace( alias[i], (soundX, soundY, level.player.origin[2] + 72) );
	}
}

mission_complete_timeout()
{
	wait 20;
	flag_set("mission_complete");
}

finalspeach()
{
	thread finalspeach_trigger();
	
	thread mission_complete_timeout();
	
	if (!isdefined(level.randall))
		return;
	
	node_finalspeach_radioguy = getnode("node_finalspeach_radioguy","targetname");
	node_finalspeach_randall = getnode("node_finalspeach_randall","targetname");
	
	assert(isdefined(node_finalspeach_radioguy));
	assert(isdefined(node_finalspeach_randall));
	
	if (isdefined(level.ward))
	{
		level.ward.goalradius = 4;
		level.ward setgoalnode(node_finalspeach_radioguy);
	}
	
	level.randall.goalradius = 4;
	level.randall setgoalnode(node_finalspeach_randall);
	
	if (isdefined(level.ward))
	{
		level.ward waittill ("goal");
		level.ward allowedStances("crouch");
	}
	
	flag_wait("start_finalspeach");
	
	level.randall anim_reach_solo(level.randall, "finalspeach", undefined, node_finalspeach_randall);
	level.randall allowedStances("crouch");
	level.randall anim_single_solo(level.randall, "finalspeach", undefined, node_finalspeach_randall);
	wait 3;
	level.randall anim_single_solo(level.randall, "finalspeach2", undefined, node_finalspeach_randall);
	flag_set("mission_complete");
}

finalspeach_trigger()
{
	getent("randall_finalspeach_start","targetname") waittill ("trigger");
	flag_set("start_finalspeach");
}

objective_finalspeach()
{
	trig = getent("final_objective_area","targetname");
	loc = getent(trig.target,"targetname");
	
	wait 0.1;
	objective_add( level.objective["final_speach"], "current", &"DUHOC_OBJ_FINALSPEACH", loc.origin );
	trig waittill ("trigger");
	objective_state( level.objective["final_speach"], "done" );
	flag_set("objectives_complete");
}

levelend_music()
{
	wait 5;
	musicPlay(level.music["misson_complete"]);	
}
/****************************************************************************

Level: 		Beltot
Campaign: 	
Objectives: 	
		
*****************************************************************************/

#include maps\_utility;
#include maps\_anim;
#using_animtree("generic_human");

main()
{
	thread ambientchange();
	level.campaign = "british";

	maps\_truck::main("xmodel/vehicle_opel_blitz_woodland");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");

	maps\beltot_fx::main();

	precacheModel("xmodel/prop_mortar_ammunition");
	level._effect["mortar launch"] = loadfx ("fx/muzzleflashes/mortar_flash.efx");

	precacheString(&"BELTOT_PLATFORM_TRUCK_CLIMB_HINT");
	precacheString(&"BELTOT_OBJECTIVE_SECURE");
	precacheString(&"BELTOT_OBJECTIVE_ELIMINATE");
	precacheString(&"BELTOT_OBJECTIVE_JOINUP");
	precacheString(&"BELTOT_OBJECTIVE_BRING_TRUCK");

	maps\_load::main();
	maps\beltot_anim::main();
	level thread maps\beltot_amb::main();

	level.scr_sound["wall_burst"]		= "wall_crumble";
	level.scr_sound["grenade"]		= "grenade_explode_wood";

	setExpFog(0.00015, 0.15, 0.14, 0.13, 0);
 
	setCullDist (4500);
 

	precacheString(&"BELTOT_PLATFORM_TRUCK_CLIMB_HINT");

	level thread setup_huntplayer();
	level thread setup_final_building();
  	
	level.maxfriendlies = 0;
	level.friendlyMethod = "friendly chains";
	level.friendlywave_thread = ::friendlyMethod;
	level.friendlyradius = 350;
	level.followmax = 1;
	level.followmin = -3;

 	// activate badplaces when mg42 is active.
	badplace_mg42 = getent("badplace_mg42","script_noteworthy");
	badplace_mg42 thread badplace_mg42_arc("bad_mg1",anglestoforward((0, 347, 0)));
	badplace_mg42 thread badplace_mg42_arc("bad_mg2",anglestoforward((0, 319, 0)));

	level thread setup_price();

	// open initial gate
	gate = getent("startgate","targetname");
//	gate notsolid();
	gate rotateto((0,80,0),0.01);

	biggate_left = getent("biggate_left","targetname");
	biggate_right = getent("biggate_right","targetname");
	biggate_left rotateto((0,-10,0),0.01);
	biggate_right rotateto((0,-10,0),0.01);

	level.enemies_killed = 0;
	level.center_captured = false;

	level thread initial_briefing();
	level thread orchard();
	level thread village_edge();
	level thread mg42_nest();
	level thread village_center();
	level thread mortar_objective();
	level thread surrender();
	level thread backyard();
	level thread truck();
	level thread final_sequence();

	chain_off("mcgregor_chains");

}

initial_briefing()
{
	battleChatterOff("allies");

	aFriendlyFlanker = getentarray("flanker","targetname");
	aFriendly = getentarray("maingroup","targetname");

	level array_thread (aFriendly, ::set_walkdist,999);

	for (i=0 ; i < aFriendlyFlanker.size ; i++)
	{
		aFriendlyFlanker[i] thread animscripts\shared::SetInCombat(false);
		aFriendlyFlanker[i].goalradius = 0;
		if(isdefined(aFriendlyFlanker[i].script_noteworthy) && aFriendlyFlanker[i].script_noteworthy == "crouch")
			aFriendlyFlanker[i] allowedStances ("crouch");
	}

	for (i=0 ; i < aFriendly.size ; i++)
	{
		aFriendly[i] thread animscripts\shared::SetInCombat(false);
		aFriendly[i].dontavoidplayer = true;
		if(isdefined(aFriendly[i].script_noteworthy) && aFriendly[i].script_noteworthy == "crouch")
			aFriendly[i] allowedStances ("crouch");
	}

	// lock ai inplace
	level array_thread (aFriendly, ::set_goalradius, 0);

	wait 1;

	// play dialog
	tmp_mcgregor = getent("tmp_mcgregor","script_noteworthy");
	tmp_mcgregor.animname = "mcgregor";

	tmp_mcgregor thread maps\_anim::anim_loop_solo (tmp_mcgregor, "briefing_loop", undefined, "stop_idle");

	node = getnode(level.price.target,"targetname");

	level thread close_gate();
	level.price Dialogue_Thread("beltot_price_downthisroad");
	level notify("gate");
	level.price Dialogue_Thread("beltot_british_briefing_dialog",node);

	tmp_mcgregor notify("stop_idle");

	for (i=0 ; i < aFriendly.size ; i++)
	{
		if ( isdefined(aFriendly[i]) && isalive(aFriendly[i]) )
			aFriendly[i] thread set_goalradius();
	}

	obj = getent("main_objective_a","targetname");
	objective_add(0, "active" , &"BELTOT_OBJECTIVE_SECURE",obj.origin);
	objective_current(0);

	aCrouchers = getentarray("crouch","script_noteworthy");
	for (i=0 ; i < aCrouchers.size ; i++)
	{
		if ( isdefined(aCrouchers[i]) && isalive(aCrouchers[i]) )
			aCrouchers[i] allowedStances ("crouch", "prone", "stand");
	}

	targetnode = getnode("flankgoal", "targetname");
	for (i=0 ; i < aFriendlyFlanker.size ; i++)
	{
		if ( isdefined(aFriendlyFlanker[i]) && isalive(aFriendlyFlanker[i]) )
			aFriendlyFlanker[i] thread movetoanddelete(targetnode);
	}

	chain_node = getnode("chain_1", "targetname");
	level.player setfriendlychain(chain_node);

	level.price setgoalentity(level.player);

	for (i=0 ; i < aFriendly.size ; i++)
	{
		if ( isdefined(aFriendly[i]) && isalive(aFriendly[i]) )
			aFriendly[i] thread randomstartout();
	}

	level.maxfriendlies = 4;

	wait 3;
	level thread autoSaveByName("orchard");
	wait 2;
	for (i=0 ; i < aFriendly.size ; i++)
	{
		if ( isdefined(aFriendly[i]) && isalive(aFriendly[i]) )
			aFriendly[i] thread set_walkdist();
	}
}

randomstartout()
{
	self endon("death");
	wait randomfloat(1.5);
	self setgoalentity(level.player);
	self.dontavoidplayer = false;
	self.followmin = -3;
	self.followmax = 1;
	self.ignoreme = true;
}

close_gate()
{
	// close gate
	level waittill("gate");
	wait 3.95;
	gate = getent("startgate","targetname");
	gate rotateto((0,0,0),0.5,0.2);
	gate waittill("rotatedone");
	level thread playsoundinspace("door_bounce",gate.origin);
	gate rotateto((0,7,0),.13);
	gate waittill("rotatedone");
	gate rotateto((0,4,0),.13,0,.1);

	gate_clip = getent("gate_clip","targetname");
	gate_clip delete();
}

orchard()
{
	level thread orchard_guard();
	level thread orchard_reinforcement();
	level thread orchard_boundary();
	level thread orchard_retreat();
}

orchard_guard()
{
	aGuard = getentarray("guard","targetname");
	aGuards = [];

	for (i=0; i < aGuard.size; i++)
	{
		guard = aGuard[i] dospawn();
		if (spawn_failed(guard))
			return;
		guard.old_maxsightdistsqrd = guard.maxsightdistsqrd;
		guard.maxsightdistsqrd = (1400*1400);
		guard.ignoreme = true;
		guard thread patrol();
		guard thread waittill_combat();
		guard thread waittill_death();

		aGuards[i] = guard;
	}

	level waittill("patroldone");

	// changed to next ambient intensity
	level notify("change ambient");

	// lets price chatter
	level.price setBattleChatter(true);
	level.price thread animscripts\battlechatter_ai::aiOfficerOrders();

	battleChatterOn("allies");

	dialogue = true;
	for (i=0; i < aGuards.size; i++)
	{
		if(dialogue && isalive(aGuards[i]))
		{
			dialogue = false;
			aGuards[i].animname = "gi1";
			aGuards[i] thread Dialogue_Thread("beltot_gi1_lookout");
		}

		if(isalive(aGuards[i]))
		{
			aGuards[i].maxsightdistsqrd = aGuards[i].old_maxsightdistsqrd;
			aGuards[i].ignoreme = false;
			aGuards[i].goalradius = 512;
		}
	}
//	wait 2;
	level notify("orchard_reinforce");
}

orchard_reinforcement()
{
	level waittill("orchard_reinforce");

	level endon("orchard_retreat");
	level.enemies_killed = 0;

	wait 3;
	
	spawn_gm_group("axis_orchard_middle_a");

/*	squads[0] = "axis_orchard_left";
	squads[1] = "axis_orchard_right";
	i = randomint(2);
	assert(!(i > 1));
*/

	spawn_gm_group("axis_orchard_right");
//	spawn_gm_group(squads[i]);

//	while(level.enemies_killed < 2) { wait(1); }
	wait 4;

	spawn_gm_group("axis_orchard_left");
	spawn_gm_group("axis_orchard_middle_b");

//	while(level.enemies_killed < 4) { wait(1); }
	wait 5;

	spawn_gm_group("axis_orchard_right");
	while(level.enemies_killed < 14) { wait(1); }

	// get all axis and retreat
	level notify("orchard_retreat");
	// play axis retreat dialog.
}

orchard_boundary()
{
	level endon("orchard_retreat");
	trigger = getent("orchard_boundary","targetname");
	trigger waittill("trigger");
	level notify("orchard_retreat");
}

orchard_retreat()
{
	level waittill("orchard_retreat");

	ai = getaiarray("axis");
	assert(isdefined(ai));
	living_ai = ai.size;
	level.enemies_killed = 3-living_ai;

	// give all axis ai orchard_retreat_goal
	goalnode = getnode("orchard_retreat_goal","targetname");
	axis_ai = getaiarray("axis");
	level array_thread (axis_ai, ::set_goalnode, goalnode);
	level notify("orchard captured");
	wait 3;
	level thread autoSaveByName("village edge");
}

village_edge()
{
	level waittill("orchard captured");

	mortar_trigger = getent("village_edge_mortar","targetname");
	level thread village_edge_mortar(mortar_trigger);
	level thread village_edge_mortar_delay();

	// spawn new enemie
	spawn_gm_group("axis_village_edge_a",true);
	trigger = getent("village_edge","targetname");
	trigger waittill("trigger");

	while(level.enemies_killed < 0) { wait(1); }
	spawn_gm_group("axis_village_edge_b",true);

	while(level.enemies_killed < 6) { wait(1); }
	mortar_trigger notify("trigger");
}

village_edge_mortar_delay()
{
	trigger = getent("mortar_delay","targetname");
	while(true)
	{
		trigger waittill("trigger",ent);
		if (ent == level.price)
			break;
		if (ent == level.player)
		{
			// player should be ignored while in shell shock. Can still get killed by grenades though.
			maps\_shellshock::main(8,10,10,10);
			break;
		}
	}
}

pre_mortar_fire()
{
	level endon("stop pre mortar");

	while (true)
	{
		level notify("beltot mortar fire");
		wait randomfloat(1.5) + 1;
	}
}


beltot_mortar()
{
	// mortars activated by the mortar crews firing.
	level endon("mortars done");
	last_mortar = undefined;

	aMortar = getentarray("edge_mortar","targetname");
	while (true)
	{
		aMortar = array_randomize(aMortar);
		level waittill("beltot mortar fire");
		hit = false;
		for (i = 0; i < aMortar.size; i++)
		{
			fDist = distance (level.player getorigin(), aMortar[i] getorigin());
			if ( (fDist < 800) && (fDist > 50) )
			{
					if ( !isdefined(last_mortar) || last_mortar == aMortar[i] )
						continue;

				hit = true;
				last_mortar = aMortar[i];
				aMortar[i] thread beltot_mortar_explode();
				break;
			}
		}
		if (!hit)
		{
			i = randomint(aMortar.size);
			last_mortar = aMortar[i];
			aMortar[i] thread beltot_mortar_explode();
		}			
	}
}

beltot_mortar_explode()
{
	wait .7;
	switch (randomint(4))
	{
	case 1:
		self playsound ("mortar_incoming1");
		wait (1.07 - 0.25);
		break;
	case 2:
		self playsound ("mortar_incoming2");
		wait (0.67 - 0.25);
		break;
	case 3:
		self playsound ("mortar_incoming3");
		wait (1.55 - 0.25);
		break;
	default:
		wait (1.75);
		break;
	}

	self playsound ("mortar_explosion" + (randomint(5)+1));

	playfx (level._effect["edge_mortar"], self.origin);
	earthquake(.5, 2, self.origin, 500);

	dist = distance (level.player.origin, self.origin);
	if (dist > 300)
		return;

	radiusDamage(self.origin, 256, 200, 10);
//	earthquake(0.75, 2, self.origin, 1024);

//	maxdamage = ((dist+1) / 300) * 130;
//	maps\_shellshock::main(8,maxdamage,100,100);
}

village_edge_mortar(trigger)
{
	// wait for trigger then call in mortar barrage at predefined locations.
	// trigger might get triggered by script if player doesn't move forward.
	trigger waittill("trigger");

	level thread beltot_mortar();
	level thread pre_mortar_fire();
	wait 1.5;

	level thread village_edge_price();

	// move allies to cover
	ai = getaiarray("allies");

	chain_node = getnode("chain_2","targetname");
	level.player setfriendlychain(chain_node);

	// move axis from the open area
	ai = getaiarray("axis");
	goalnode = getnode("axis_mortar_cover","targetname");
	for(i=0 ; i < ai.size; i++)
	{
		ai[i] thread set_goalnode(goalnode,0.5);
	}

	wait 4;
//	level thread maps\_mortar::generic_style("edge_mortar_2", 1,undefined,undefined,350,2000);
//	level notify ("start edge_mortar_2");

	wait 5;
	level notify("mortar_objective");
	wait 10;
	level notify("stop pre mortar");

/*
	level thread maps\_mortar::generic_style("edge_mortar_2", .5,undefined,undefined,350,2000);
	level notify ("start edge_mortar_2");
	wait 10;

	// the mortars continue untill 2:nd mortar crew is taken out.
	level notify ("stop edge_mortar_2");
	level thread maps\_mortar::generic_style("edge_mortar_2", .75,4,3,300,2000);
	level notify ("start edge_mortar_2");
*/
}

village_edge_price()
{
	level endon("destroy mg42 nest");

	// changed to next ambient intensity
	level notify("change ambient");

	level.price thread Dialogue_Thread("beltot_price_mortarinsidebuilding");
	level.price.ignoreme = true;
	old_maxsightdistsqrd = level.price.maxsightdistsqrd;
	level.price.maxsightdistsqrd = (64*64);
	level.price clearEnemyPassthrough();
	level.price.atnode = false;
	level.price.goalradius = 0;
	node = getnode("price_mg42_cover","targetname");
	level.price thread set_goalnode(node);
	level.price waittill("goal");

	// play idle animation at node if dialogue hasn't been played.
	node thread maps\_anim::anim_loop_solo (level.price, "beltot_british_mg42_warning_idle", undefined, "stop idle", node);

	level.price.atnode = true;
	level.price.maxsightdistsqrd = old_maxsightdistsqrd;
}

mg42_nest()
{
	trigger = getent("mg42_nest","targetname");
	trigger waittill("trigger");

	ent = getent("axis_mg42_nest_guy","targetname");
	level.mg42_nest_guy = ent dospawn();
	if (spawn_failed(level.mg42_nest_guy))
		return;

	mg = getent("automg42","script_noteworthy");
	mg thread autofire_mg();

	support_trigger = getent("mg42_nest_support_trigger","targetname");

	level thread mg42_nest_support(support_trigger);
	level thread mg42_nest_alert();
	level thread mg42_nest_destroy(support_trigger);

	level waittill("remove mg");
	mg notify("stop autofire");

	wait 1;
	while (isdefined(mg getturretowner()))
		wait 1;
	mg.origin = mg.origin + (0,0,-1000);
}

mg42_nest_support(support_trigger)
{
	support_trigger waittill("trigger");

	spawn_gm_group("axis_village_1");
	support_trigger endon("trigger");
	wait 16;
	spawn_gm_group("axis_village_1");

/*
	// spawn enemies at somewhat random intervals.
	level.enemies_killed = 0;
	spawned = 0;
	for (spawned=0; spawned < 16 ;)
	{
		if (level.enemies_killed >= (spawned-1))
		{
			spawned = spawned+4;
			if (level.enemies_killed > 4)
				spawn_gm_group("axis_village_1",true);
			else
				spawn_gm_group("axis_village_1");
		}
		wait randomint(2)+2;
	}
*/
}

mg42_nest_alert()
{
	// alert player of mg42 nest ahead.
	trigger = getent("mg42_nest_alert","targetname");
	trigger waittill("trigger");

	level notify("destroy mg42 nest");

	if (!level.price.atnode)
	{
		level.price Dialogue_Thread("beltot_price_mg42onsecondfloor_noanim");
	}
	else
	{
		animnode = getnode("price_mg42_cover","targetname");
		level.price notify("stop idel");
		level.price Dialogue_Thread("beltot_price_mg42onsecondfloor",animnode);
	}

	wait 3;
	level.price thread Dialogue_Thread("beltot_price_macgregorandboys");

}

mg42_nest_destroy(support_trigger)
{
	// alert player of mg42 nest ahead.
	level waittill("destroy mg42 nest");

	level thread autoSaveByName("mg42_nest");

	// spawn most allied flankers
	mg42_spawn_friendly_flankers();

	animNode = getnode("mcgregor_mg42_goal","targetname");

	level.mcgregor = getent("mcgregor","targetname") dospawn();

	while (spawn_failed(level.mcgregor))
	{
		wait 1;
		level.mcgregor = getent("mcgregor","targetname") dospawn();
	}

	level.mcgregor.old_grenadeawareness = level.mcgregor.grenadeawareness;
	level.mcgregor.grenadeawareness  = 0;
	level.mcgregor.followmax = -2;
	level.mcgregor.followmin = -4;
	level.mcgregor.animname = "mcgregor";
	level.mcgregor thread magic_bullet_shield();
	level.mcgregor.ignoreme = true;

	guy[0] = level.mcgregor;

	// wait till goalreached
	animNode anim_reach (guy, "grenade_toss_guy", undefined, animNode);
	level thread maps\_anim::anim_single (guy, "grenade_toss_guy", undefined, animNode);
	wait 3;

	support_trigger notify("trigger");

	wait 9;

	level.price.ignoreme = false;
	level.price setgoalentity(level.player);
	level thread exploder(1);

	if (isalive(level.mg42_nest_guy))
		level.mg42_nest_guy dodamage(level.mg42_nest_guy.health + 50, (0,0,0));

	wait 1.5;

	level.mcgregor.grenadeawareness = level.mcgregor.old_grenadeawareness;

	level notify("remove mg");

	level.price endon("stop objective follow");

	level notify("mg42_destroyed");
	if (!level.center_captured)
	{
		level.price Dialogue_Thread("beltot_price_machinegunsdown");

		level.mcgregor.ignoreme = false;

		chain_node = getnode("chain_3","targetname");
		level.player setfriendlychain(chain_node);
	}

	// make sure every ai is on the friendlychain.
	aAi = getaiarray("allies");
	for (i=0;i<aAi.size;i++)
	{
		aAi[i].followmax = 1;
		aAi[i].followmin = -3;
		aAi[i] setgoalentity(level.player);
	}
}

mg42_spawn_friendly_flankers()
{
	spawner = undefined;
	ai = getentarray("allied_flanker","targetname");
	for (i=0; i < ai.size; i++)
	{
		spawner = ai[i] dospawn();
		if (spawn_failed(spawner))
			continue;
	//	spawner.goalradius = 512;
	}
}

mortar_objective()
{
	level waittill("mortar_objective");

	level.mortars = 2;
	level.alive = [];
	level thread spawn_crew("mortar_crew_1",0);
	level thread spawn_crew("mortar_crew_2",1);

	level.price Dialogue_Thread("beltot_price_takeoutmortars");

	level thread clear_building_dialogue();

	ent1 = getent("mortar_objective_1","targetname");
	ent2 = getent("mortar_objective_2","targetname");

	level thread crew1_obj();
	level thread crew2_obj();

	// activate second objective
	ent1 = getent("mortar_objective_1","targetname");
	ent2 = getent("mortar_objective_2","targetname");
	objective_add(1, "active");
	objective_string(1, &"BELTOT_OBJECTIVE_ELIMINATE", 2);
	objective_additionalposition(1, 0, ent1.origin);
	objective_additionalposition(1, 1, ent2.origin);
	objective_current(1);

	level waittill("all mortars down",id);

	objective_additionalposition(1, id, (0,0,0));
	objective_string_nomessage(1, &"BELTOT_OBJECTIVE_ELIMINATE", 0);
	objective_state(1,"done");

	level thread autoSaveByName("crossing");

	// reactivete first objective with a new location
	ent = getent("main_objective","targetname");
	objective_position(0,ent.origin);
	objective_current(0);

	level notify ("mortars done");
}

clear_building_dialogue()
{
	trigger =  getent("mortar_objective_trigger","targetname");
	trigger waittill("trigger");

	level.price Dialogue_Thread("beltot_price_davisclearsecond");
}

crew2_obj()
{
	level waittill("crew 1 down",crew_id);

	level notify ("stop edge_mortar_2");
	level.mortars--;
	if (!level.mortars)
	{
		level notify("all mortars down",crew_id);
	}
	else
	{
		objective_additionalposition(1, crew_id, (0,0,0));
		objective_string(1, &"BELTOT_OBJECTIVE_ELIMINATE", 1);
		level thread autoSaveByName("one down");
	}

	// force trigger to trigger.
	trigger = getent("mortars_done","script_noteworthy");
	if (isdefined(trigger))
	{
		// trigger is undefined if the player hits it in game.
		trigger notify("trigger");
		trigger delete();
	}
	// disable used friendlychain trigger.
	chain_off("mortar_chain");
	// make ai go to new friendlychain.
	chain_node = getnode("chain_5","targetname");
	level.player setfriendlychain(chain_node);
}

crew1_obj()
{
	level waittill("crew 0 down",crew_id);
	if (!level.center_captured)
		level waittill("center_captured");

	level.mortars--;
	if (!level.mortars)
	{
		level notify("all mortars down",crew_id);
		return;
	}
	objective_additionalposition(1, crew_id, (0,0,0));
	objective_string(1, &"BELTOT_OBJECTIVE_ELIMINATE", 1);
	level thread autoSaveByName("one down");
}

spawn_crew(crew_targetname,crew_id)
{
	level endon("crew " + crew_id + " down");

	waittillframeend;

	ent = spawnstruct();
	ent.count = 0;

	spawner = getentarray(crew_targetname,"targetname");

	crew = [];
	mortar = undefined;

	for (i=0; i < spawner.size; i++)
	{
		ai = spawner[i] dospawn();
		if (spawn_failed(ai))
			continue;
		ai thread mortar_crew_track(crew_id,ent);
		ent.count++;

		if (isdefined(spawner[i].script_noteworthy))
		{
			crew[crew.size] = ai;
			mortar = spawner[i].script_noteworthy;
		}
	}

	assert(isdefined(mortar));
	eMortar = getent(mortar,"targetname");
	eMortar thread mortar_loadfire(crew);

	level thread crew_down_alt(crew_id,crew);

	while(true)
	{
		ent waittill("crew die");
		if (!ent.count)
			break;
	}

	wait 4;
	level notify("crew " + crew_id + " down",crew_id);
}

crew_down_alt(crew_id,crew)
{
	level endon("crew " + crew_id + " down");

	trigger = getent("mortar_" + (crew_id + 1) + "_clear","targetname");
	trigger waittill("trigger");
	wait 8;
	level notify("crew " + crew_id + " down",crew_id);
	for(i=0; i < crew.size; i++)
	{
		if (isdefined(crew[i]) && isalive(crew[i]))
		{
			crew[i] setgoalentity(level.player);
		}
	}
}

mortar_loadfire(crew)
{
	self endon("stop mortar");
	crew[0] endon("death");
	crew[1] endon("death");

	wait randomfloat(5) + 0.1;

	crew[0].animname = "loadguy";
	crew[1].animname = "aimguy";

	crew[0].allowDeath = 1;
	crew[1].allowDeath = 1;

	for (i=0; i < crew.size; i++)
	{
		crew[i] thread stopmortar_anim(self);
		crew[i] thread stopmortar_grenade(self);
	}

	triggers = getentarray(self.target,"targetname");

	array_thread(triggers,::stopmortar,self);

	while(true)
	{
		switch (randomint(5))
		{
			case 0:
				self anim_single(crew,"waitidle",undefined,undefined,self);
				break;
			case 1:
				self anim_single(crew,"waittwitch",undefined,undefined,self);
				break;
		}
		self anim_single(crew,"pickup",undefined,undefined,self);
		self thread anim_single(crew,"fire",undefined,undefined,self);
		crew[0] waittillmatch ("single anim", "fire");
		level notify("beltot mortar fire");
		playfxontag (level._effect["mortar launch"], self, "tag_flash");
		crew[0] waittillmatch ("single anim", "end");
	}
}

stopmortar_anim(mortar)
{
	self endon("death");
	self animscripts\shared::putGunInHand ("none");
	mortar waittill("stop mortar");
	self stopanimscripted();
	self animscripts\shared::putGunInHand ("right");
	self.allowDeath = 0;
}

stopmortar(mortar)
{
	self waittill("trigger");
	mortar notify("stop mortar");
	self delete();
}

stopmortar_grenade(mortar)
{
	self.grenadeawareness  = 1;
	self waittill("grenade danger");
	wait randomint(2) + 1;
	mortar notify("stop mortar");
}

mortar_crew_track(crew_id,ent)
{
	self waittill("death");
	ent.count--;
	ent notify("crew die");
}

village_center()
{
	trigger = getent("village_center","targetname");
	trigger waittill("trigger");

	level thread autoSaveByName("village_center");

	level.enemies_killed = 0;
	level thread village_center_runners();
	level thread village_center_defenders();
	level thread populate_building();

	trigger = getent("center_captured","targetname");
	trigger waittill("trigger");

	level notify("stop reinforcement");

	level.center_captured = true;
	level notify("center_captured");
}

village_center_defenders()
{
	level endon("stop reinforcement");

	trigger = getent("mortar_spot","targetname");
	trigger waittill("trigger");

	spawn_gm_group("axis_village_center_building",true);

	while(level.enemies_killed < 1) { wait(1); }
	level notify("runners");
	spawn_gm_group("axis_village_center_reinforcement",true);
	while(level.enemies_killed < 4) { wait(1); }
	spawn_gm_group("axis_village_center_reinforcement",true);
	level notify("runners");
	while(level.enemies_killed < 6) { wait(1); }
	spawn_gm_group("axis_village_center_reinforcement",true);
	while(level.enemies_killed < 8) { wait(1); }

	level.center_captured = true;
	level notify("center_captured");

}

village_center_runners()
{
	level endon("center_captured");

	spawn_gm_group("axis_village_runner",true,true);
	wait 10;
	spawn_gm_group("axis_village_runner",undefined,true);
	level waittill("runners");
	spawn_gm_group("axis_village_runner",true,true);
	level waittill("runners");
	spawn_gm_group("axis_village_runner",true,true);
	wait 7;
	level notify("right_flank");
}

populate_building()
{
	level endon("center_captured");

	trigger = getent("2floor_trigger","targetname");
	trigger waittill("trigger");

	// place 1 allied on the second floor.
	aAi = getaiarray("allies");

	for (i=0; i < aAi.size; i++)
	{
		if (aAi[i] == level.price)
			continue;
		if (aAi[i] == level.mcgregor)
			continue;

		floor2_goalnode = getnode("2floor_goal","targetname");
		aAi[i] setgoalnode(floor2_goalnode);
		aAi[i].goalradius = 0;
		aAi[i].oldmaxsightdistsqrd = aAi[i].maxsightdistsqrd;
		aAi[i].maxsightdistsqrd = 64*64;
		aAi[i].animname = "bs1";
		aAi[i] thread mortar_dialog();
		aAi[i] thread right_attack_dialog();
		aAi[i] thread magic_bullet_shield();
		break;
	}
}

mortar_dialog()
{
	self endon("death");
	level endon("right_flank");
	level endon("center_captured");

	self waittill("goal");

	trigger = getent("mortar_spot","targetname");
	trigger waittill("trigger");

	if (!isdefined(self) && !isalive(self))
		return;

	self Dialogue_Thread("beltot_bs1_mortarcrew");

	self.maxsightdistsqrd = self.oldmaxsightdistsqrd;
}

right_attack_dialog()
{
	self endon("death");
	msg = level waittill_any("right_flank","center_captured");
	if (level.player.origin[2] > 200)
		self Dialogue_Thread("beltot_bs2_launchingcounter");
	self notify("stop magic bullet shield");
	self.goalradius = 256;
	self.maxsightdistsqrd = self.oldmaxsightdistsqrd;
	self setgoalentity(level.player);
}

surrender()
{
	level waittill("mortars done");

	level thread savebyname();

	trigger = getent("allied_support","targetname");
	trigger waittill("trigger");

	trigger = getent("last_building","targetname");
	trigger waittill("trigger");

	// changed to next ambient intensity
	level notify("change ambient");

	level notify("final_building_guys_attack");

	chain_off("main_chains");
	chain_on("mcgregor_chains");

	price_inhouse_goal = getnode("price_inhouse_goal","targetname");
	mcgregor_inhouse_goal = getnode("mcgregor_inhouse_goal","targetname");

	level.mcgregor setgoalnode(mcgregor_inhouse_goal);
	level.mcgregor.goalradius = 32;
	level.price setgoalnode(price_inhouse_goal);
	level.price.goalradius = 32;

	level.price waittill("goal");
	level.price.walkdist = 128;

	closest_inhouse_goal = getnode("closest_inhouse_goal","targetname");
	excluders[0] = level.price;
	excluders[1] = level.mcgregor;

	closest_ai = getClosestAIExclude (level.player.origin, "allies", excluders);
	if (isdefined(closest_ai))
	{
		closest_ai.animname = "bs1";
		closest_ai.health = 3000;
		closest_ai setgoalnode(closest_inhouse_goal);
		closest_ai.goalradius = 150;
	}

	trigger = getent("surrender","targetname");
	trigger waittill("trigger");

	level thread autoSaveByName("surrender");

	// kill of all axis ai on the map
	ai = getaiarray("axis");
	for(i=0; i < ai.size; i++)
	{
		ai[i] dodamage(ai[i].health + 50,(0,0,0));
	}

	// spawn wounded
	wounded();

	// spawns and handles surrendering Germans
	level thread surrender_guys();

	goalnode = getnode("surrender_allies_goal","targetname");

	allies = getaiarray("allies");
	for (i=0; i < allies.size; i++)
	{
		if (allies[i] == level.price || allies[i] == level.mcgregor || allies[i] == closest_ai || !isalive(allies[i]))
			continue;

		allies[i] clearEnemyPassthrough();
		allies[i].goalradius = 512;
		allies[i] setgoalnode(goalnode);
	}

	// play kick animation on price
	
	guy[0] = level.price;
	animNode = getnode("doorkick_goal","targetname");

	animNode anim_reach (guy, "chateau_kickdoor1", undefined, animNode);
	level thread maps\_anim::anim_single (guy, "chateau_kickdoor1", undefined, animNode);

	guy[0] waittillmatch ("single anim", "kick");

	level.savehere = false; // block any autosaves at this point.

	door_shadow = getent("backyard_door_shadow","targetname");
	door_shadow thread door_shadow();
	
	door = getent("backyard_door","targetname");
	door rotateto((0,160,0), 0.6, 0.01, 0.55);

	level notify("backyard_door");
	door playsound ("wood_door_kick");

	// starts German surrendering
	level notify("surrender");
	level waittill("price talk");

	if (isdefined(closest_ai) && isalive(closest_ai))
	{
		level.price thread Dialogue_Thread("beltot_price_holdfirelads");
		wait 1.7;
		closest_ai thread Dialogue_Thread("beltot_bs1_sayweslot");
		wait .3;
		level.price Dialogue_Thread("beltot_price_thatsanorder");
		closest_ai Dialogue_Thread("beltot_bs1_whateveryousay");
	}
	else
	{
		level.price Dialogue_Thread("beltot_price_holdfirelads");
	}
	
	wait 1;
	door connectpaths();

	objective_state(0,"done");
	level notify("backyard");
}

door_shadow()
{
	end = getent("backyard_door_shadow_end","targetname");

	level waittill("backyard_door");
	self moveto(end.origin, .25, .25);
	wait .35;
	self delete();
	end delete();
}

surrender_guys()
{
	// surrender guy2
	spawner = getent("surrender_guy_2","targetname");
	guy2 = spawner stalingradspawn();

	if (spawn_failed(guy2))
	{
		assertmsg("Second surrender guy didn't spawn");
		level notify("price talk");
		return;
	}

	guy2 setBattleChatter(false);
	guy2.animname = "gi2";
	guy2.health = 1;
	guy2.ignoreme = 1;
	guy2.allowDeath = 1;

	node = getnode(guy2.target,"targetname");

	guy2 animscripts\shared::putGunInHand ("none");
	node thread maps\_anim::anim_loop_solo (guy2, "surrender_loop", undefined, "death", node);

	// surrender guy
	spawner = getent("surrender_guy","targetname");
	guy = spawner stalingradspawn();

	if (spawn_failed(guy))
	{
		assertmsg("First surrender guy didn't spawn");
		level notify("price talk");
		return;
	}

	guy setBattleChatter(false);
	guy.animname = "gi2";
	guy.ignoreme = 1;
	guy.maxsightdistsqrd = 4;
	guy.goalradius = 0;
	guy.health = 1;
	guy.allowDeath = 1;

	if (isdefined(guy2) && isalive(guy2))
		guy2 thread missionfailedondamage();
	if (isdefined(guy) && isalive(guy))
		guy thread missionfailedondamage();

	goal = getnode("door_goal","targetname");
	goal thread anim_reach_solo (guy, "surrender", undefined, goal);

	level waittill("surrender");
	if (!isalive(guy))
		return;
	guy anim_single_solo (guy, "surrender", undefined, goal);
	if (isalive(guy))
		guy thread maps\_anim::anim_loop_solo (guy, "surrender_loop", undefined, "death");
	level notify("price talk");
}

wounded()
{
	wounded_anim_limit = 4;
	wounded_anim_count = 0;

	wounded = getentarray("wounded","targetname");

	for (i=0 ; i < wounded.size; i++)
	{
		wounded_anim_count = (wounded_anim_count+1) % wounded_anim_limit;

		animnode = getnode(wounded[i].target,"targetname");
		guy = wounded[i] stalingradspawn();

		if (spawn_failed(guy))
			continue;

		guy.animname = "wounded";
		guy animscripts\shared::PutGunInHand("none");
		guy.hasWeapon = 0;
		guy.pacifist = 1;
		guy.allowDeath = 1;
		guy thread missionfailedondamage(true);

		if (isdefined(guy.script_noteworthy))
			guy thread anim_loop_solo (guy, "wounded_"+ int(guy.script_noteworthy), undefined, "end_loop", animnode);
		else
			guy thread anim_loop_solo (guy, "wounded_"+wounded_anim_count , undefined, "end_loop", animnode);
	}
}

missionfailedondamage(brit)
{
	if (!isdefined(brit))
		level endon("tank_dead");

//	level endon("activate truck");

	while (true)
	{
		self waittill("damage",amount,attacker);
		if (attacker != level.player)
			continue;
		if (isdefined(level.reascent_save) && level.reascent_save)
		{
			if ( (isdefined (self.damagelocation)) && (self.damagelocation == "none") )
				return;
		}

		if (isdefined(brit))
			setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH");
		else
			setCvar("ui_deadquote", "@BELTOT_MISSIONFAIL_KILLPOW");
		maps\_utility::missionFailedWrapper();
	}
}

backyard()
{
	level waittill("backyard");

	battleChatterOff("allies");

	closest_backyard_goal = getnode("closest_backyard_goal","targetname");

	excluders[0] = level.price;
	excluders[1] = level.mcgregor;

	aAi = getaiarray("allies");	
	aAllies = [];
	for (i=0; i < aAi.size; i++)
	{
		if (isdefined(aAi[i].animname) && aAi[i].animname == "wounded")
			continue;
		if (aAi[i] == level.price || aAi[i] == level.mcgregor)
			continue;
		aAllies[aAllies.size] = aAi[i];
	}

	closest_ai = getClosest(level.player getorigin(), aAllies);

	if (isdefined(closest_ai))
	{
		closest_ai setgoalnode(closest_backyard_goal);
		closest_ai.goalradius = 0;
	}

	mcgregor_goal = getnode("backyard_mcgregor_goal","targetname");
	level.mcgregor setgoalnode(mcgregor_goal);
	level.mcgregor.goalradius = 0;

	price_goal = getnode("backyard_price_goal","targetname");

	objective_add(2, "active", &"BELTOT_OBJECTIVE_JOINUP", price_goal.origin);
	objective_current(2);

	level.price.goalradius = 0;
	level.price setgoalnode(price_goal);

	backyard_center = getnode("backyard_center","targetname");

	// make price walk less as if in combat
	level.price.walk_noncombatanim = %patrolwalk_tired;
	level.price.walk_noncombatanim2 = %patrolwalk_tired;

	backyard_trigger = getent("backyard_trigger","targetname");
	backyard_trigger waittill("trigger");

	// put this here so that the player can't run past the trigger before the thread is running.
	level thread tank_infantry();

	// will save once the player exits the final building.
	// this should guard agains save/death loops on friendly wounded
	level thread backyard_save();

	level thread setup_gatepath();

	mcgregor_goal = getnode("backyard_mcgregor_goal_2","targetname");

	level.price.anim_node = price_goal;
	level.mcgregor.anim_node = mcgregor_goal;
	guy[0] = level.price;
	guy[1] = level.mcgregor;

	self maps\_anim::anim_reach(guy, "bring_truck");
	self maps\_anim::anim_single(guy, "bring_truck");

	level.price.anim_node = undefined;
	level.mcgregor.anim_node = undefined;

	objective_state(2,"done");

	level notify("activate truck");

	battleChatterOn("allies");

	node = getnode("mcgregor_node_wall","targetname");
	level.mcgregor thread gatepath(node);

	// force disabled BC on McG.
	level.mcgregor.script_bcdialog = false;
	level.mcgregor setBattleChatter(false);
}

backyard_save()
{
	trigger = getent("last_building","targetname");
	trigger waittill("trigger");

	level.savehere = true; // allow autosaves.

	level.reascent_save = true;
	level autoSaveByName("get_truck");
	wait 5;
	level.reascent_save = false;

}

setup_gatepath()
{
	aTrigger = getentarray("gatepath_trigger","targetname");
	array_thread(aTrigger,::gatepath_trigger);
}

gatepath_trigger()
{
	node = getnode(self.target,"targetname");
	node.open = false;
	self waittill("trigger");
	if (isdefined(self.script_noteworthy))
	{
		level notify("path end");
		level.mcgregor thread gatepath(node);
	}
	node.open = true;
	node notify("node open");
	level.mcgregor notify("node open");
}

gatepath(startnode)
{
	level endon("path end");

	reminder = 0;

	self setgoalnode(startnode);
	self.goalradius = startnode.radius;
	self waittill("goal");

	goalnode = getnode(startnode.target,"targetname");

	oldtime = undefined;
	diftime = 100000;

	while (isdefined(goalnode))
	{
		if (isdefined(goalnode.open) && !goalnode.open)
		{
			goalnode waittill("node open");

			if ( isdefined(oldtime) )
			{
				diftime = gettime() - oldtime;
			}
			
			// stop McG from naging to often
			if ( diftime > 20000) // 20 seconds
			{
				oldtime = gettime();
				self thread Dialogue_Thread("beltot_mcg_follow");
			}
		}

		assertex(isdefined(goalnode.radius),"A radius must be set for all nodes in the path");

		self setgoalnode(goalnode);
		self.goalradius = goalnode.radius;

		self waittillEither("goal","node open");
		if (!isdefined(goalnode.target))
			break;
		goalnode = getnode(goalnode.target,"targetname");
	}
}

truck()
{
	truck = getent("truck","targetname");
	truck.health = 100000;

	truck thread attach_to_truck();

	level.player.on_truck = false;

	truck stopEngineSound();
	truck thread mount_truck();

	level waittill("activate truck");

	blocker = getent("pathblocker","targetname");
	blocker connectpaths();
	blocker delete();

//	moved to earlier
//	level thread tank_infantry();

	obj = getent("truck_objective","targetname");
	objective_add(3, "active", &"BELTOT_OBJECTIVE_BRING_TRUCK", obj.origin);
	objective_current(3);

	truck thread truck_pause();
	truck thread truck_sound();
	truck thread truck_death();


	trigger = getent("mount_truck","targetname");
	trigger waittill("trigger");

	level notify("path end");

	level.mcgregor.anim_node = undefined;

	animNode = getnode("driver_goal","targetname");
	animNode anim_reach_solo (level.mcgregor, "truckscene", "tag_driver", animNode, truck);

	truck thread anim_truck_door();
	level.mcgregor macgregor_check_truck(animNode,truck);

	wait 1;

	if (!level.player.on_truck)
		level waittill("player on truck");

	level thread biggate_crash();

	blocker = getent("biggate_blocker","targetname");
	blocker delete();

	truck thread objective_follow(3);

	truck playSound("truck_hotwire_beltot");
	wait 3;
	level.mcgregor thread mcgregor_dialog();

	wait 2.5;
	truck startEngineSound();
	wait 3.5;

	truck.health = 1000;

	level thread tank();
	level thread maps\_vehicle::gopath(truck);

	level notify("truck on path");

	truck waittill("reached_end_node");
	level.player unlink();
	level.player setorigin(level.player.origin + (0,16,8));
	level.player allowLeanLeft(true);
	level.player allowLeanRight(true);
	level.player allowProne(true);

	objective_state(3,"done");
	truck endon("stop objective follow");

	level notify("truck on goal");
}

biggate_crash()
{
	vNode = getvehiclenode("biggate_crash","script_noteworthy");
	vNode waittill("trigger");

	earthquake(.5, .6, level.player getorigin(), 350); // scale duration source radius

	biggate_left = getent("biggate_left","targetname");
	biggate_right = getent("biggate_right","targetname");
	biggate_left rotateto((0,85,0),0.4,0.01,0.1);
	biggate_right rotateto((0,-135,0),0.5,0.01,0.1);
	biggate_sound = getent("biggate_sound","targetname");
	biggate_sound playsound ("vehicle_breakfence");
}

macgregor_check_truck(animNode,truck)
{
	self endon("death");

	self anim_single_solo (self, "truckscene", "tag_driver", animNode, truck);

	self linkto(truck, "tag_driver");
	truck thread anim_loop_solo (self, "drive_loop", "tag_driver", "stop_idle");
}

mount_truck()
{
	trigger = getent("mount_trigger","targetname");
	trigger triggerOff();
	level waittill("activate truck");
	trigger triggerOn();

	trigger sethintstring(&"BELTOT_PLATFORM_TRUCK_CLIMB_HINT");

	trigger waittill("trigger");

	// this will hide the hint print
	trigger triggerOff();

	moverorg = spawn("script_origin",level.player.origin);
	moverorg.angles = level.player.angles;
	level.player dontInterpolate();
	level.player playerlinktoabsolute(moverorg);

	mountorigin = self gettagorigin("tag_climbnode")+(0,0,-16);

	movetime = (1.0/100.0) * distance(level.player.origin, mountorigin); //move at 100 units per second
	println("movetime is ",movetime);
	moverorg moveTo(mountorigin, movetime, 0, 0);
	moverorg waittill ("movedone");
	playerorigin = self getTagOrigin("tag_player");
	moverorg moveTo(playerorigin, 1, 0, 0);
	moverorg waittill ("movedone");
	tagorg = self getTagOrigin("tag_player");
	level.player setorigin ((self getTagOrigin ("tag_player")));
	level.player unlink();
	level.player playerLinkToDelta (self, "tag_player", 0.1);
	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);
	level.player allowProne(false);

	moverorg delete();
	level notify("player on truck");
	level.player.on_truck = true;

	// remove dialogue from notetrack array
	removeNotetrack_dialogue("mcgregor", "dialogue02", "truckscene", "beltot_mcg_jumpinback");

	level thread autoSaveByName("on_truck");
}

#using_animtree("germantruck");
anim_truck_door()
{
	// tmp door open and close;
	self endon("death");
	self useanimtree (#animtree);
	self setanim(%beltot_truckscene_checktruck_truck);

	wait 6.3;
	playsoundinspace ("truck_door_open", self gettagorigin("tag_driver"));
	wait 10.1;
	playsoundinspace ("car_door_close", self gettagorigin("tag_driver"));

}

#using_animtree("generic_human");
attach_to_truck()
{

	offset = angleoffset(self.angles,(0,-14,0));

/*
	aDragontooth = getent("dragontooth","targetname");
	aDragontooth.origin = self getTagOrigin ("tag_guy02")+offset;
	aDragontooth.angles = self.angles;
	waittillframeend;
	aDragontooth linkto(self,"tag_guy02");
*/

	offset = angleoffset(self.angles,(-13,-9,0));

	schreck_box = getent("schreck_box","targetname");
	schreck_box.origin = self getTagOrigin ("tag_guy08") + offset;

	schreck_box.angles = self.angles;
	waittillframeend;
	schreck_box linkto(self);

	level waittill("activate truck");

	schreck = getent("schreck","targetname");

	offset = angleoffset(self.angles,(1,-10,24));

	schreck.origin = self getTagOrigin ("tag_guy08") + offset;
	schreck.angles = self.angles;
	waittillframeend;

	schreck thread attach_weapon(self);
	level.player thread extra_ammo();
}

angleoffset(vAngles, vOffset)
{
	vf = anglestoforward(vAngles);
	vr = anglestoright(vAngles);
	vu = anglestoup(vAngles);
	
	offset_front = vectorscale(vf,vOffset[0]);
	offset_right = vectorscale(vr,(vOffset[1]*-1));
	offset_top = vectorscale(vu,vOffset[2]);

	new_offset = offset_right+offset_front+offset_top;

	return new_offset;	
}

attach_weapon(ent)
{
	self linkto(ent);

	self waittill("trigger", user, old_weapon);
	old_weapon thread attach_weapon(ent);
}

extra_ammo()
{
	while (true)
	{
		wait 2;
		slot = "primary";
		if (level.player getweaponslotweapon(slot) != "panzerschreck")
			slot = "primaryb";
		if (level.player getweaponslotammo(slot) == 0)
		{
			level.player givemaxammo("panzerschreck");
			// return;
		}	
	}
}

mcgregor_dialog()
{

//	Dialogue_Thread
	self endon("death");
	level endon("tank_dead");

	level.mcgregor thread Dialogue_Thread("beltot_mcg_almostgotbugger");
	wait 20;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_damnthislorry");
	wait 6;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_counter");

	vNode = getvehiclenode("spot_tank","script_noteworthy");
	vNode waittill("trigger");
	wait .75;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_bloodyhell");
	wait 4;
	if (!level.player hasweapon("panzerschreck"))
		level.mcgregor thread Dialogue_Thread("beltot_mcg_davistakeout");
	wait 6;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_notgonnafit");

	wait 7.5;
	if (!level.player hasweapon("panzerschreck"))
		level.mcgregor thread Dialogue_Thread("beltot_mcg_panzerschreck");

	level notify("tank_death");
}

truck_death()
{
	self waittill("death");
	level waittill("truck on goal");

	level.mcgregor animscripts\shared::PutGunInHand("right");

	level.mcgregor notify("stop magic bullet shield");
	wait 1;
	level.mcgregor dodamage(level.mcgregor.health * 2, (0,0,0));
	killplayer();
}

truck_pause()
{
	self endon("death");

	aVnode = getvehiclenodearray("pause","script_noteworthy");
	level array_thread (aVnode, ::truck_pause_node, self);

	q1 = .3;
	q2 = .3;

	if (isdefined(level.q1))
		q1 = level.q1;
	if (isdefined(level.q2))
		q2 = level.q2;

	while(true)
	{
		self waittill("pause",waittime);
		earthquake(q1, q2, level.player getorigin(), 350); // scale duration source radius
		self setspeed(0,100);
		assertEX(isdefined(waittime),"script_wait on the node must be a number > 0");
		wait waittime;
		self resumespeed(25);
	}
}

truck_pause_node(truck)
{
	truck endon("death");

	self waittill("trigger");
	truck notify("pause",self.script_wait);
}

truck_sound()
{
	aVnode = getvehiclenodearray("sound","script_noteworthy");
	level array_thread (aVnode, ::truck_sound_node, self);
}

truck_sound_node(truck)
{
	truck endon("death");

	self waittill("trigger");
	truck playsoundontag(level.scr_sound[self.script_sound],"tag_engine_left");
}

tank_infantry()
{
	trigger = getent("tank_infantry_trigger","targetname");
	trigger waittill("trigger");
	level endon("tank on path");

	level.enemies_killed = 0;

	spawn_gm_group("tank_infantry_1");

	trigger = getent("tank_infantry_trigger2","targetname");
	trigger waittill("trigger");

	// spawn some ai and one portable mg42.
	aSpawner = getentarray("tank_infantry_3","targetname");
	for (i=0; i < aSpawner.size; i++)
	{
		ai = aSpawner[i] dospawn();
		if (spawn_failed(ai))
			continue;
	}

	level waittill("truck on path");

	wait 17; // delay the spawn somewhat so that there are a few ai running to there goal.
	spawn_gm_group("tank_infantry_4", true);
	spawn_gm_group("tank_infantry_5", true);

	level waittill("tank_infantry");

	level.enemies_killed = 0;
	spawn_gm_group("tank_infantry_2", true);
}

tank()
{
	aTank = maps\_vehicle::scripted_spawn(0);
	tank = aTank[0];
	tank.health = 100000;
	tank.script_turret = 0;

	tank stopEngineSound();

	tank thread tank_wall();
	tank thread tank_squash();
	tank thread tank_ondeath();
	tank.health = tank.health+int(tank.health/2); // should not get killed with one hit.
	
	vNode = getvehiclenode("start_tank","script_noteworthy");
	vNode waittill("trigger");
	level notify("tank_infantry");

	tank startEngineSound();

	wait 3;

	level thread maps\_vehicle::gopath(tank);
	tank thread tank_fire_1();
	tank thread tank_fire_2();
	tank thread tank_damage();
	tank thread tank_kill_player();

	level notify("tank on path");

	level waittill("tank_death");
	tank.health = 1000;
}

tank_damage()
{
	self endon ("death");
	self waittill("damage");
	wait 0.5;

//	Dialogue_Thread
	level.mcgregor thread Dialogue_Thread("beltot_mcg_armorstoothick");
	self waittill("damage");
	wait 0.5;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_cmonanotherone");
	wait 0.5;
	level notify("tank_death");
}

tank_ondeath()
{
	self waittill("death");
	level notify("tank_dead");
	level.mcgregor endon("death");

	wait 2;
	level.mcgregor thread Dialogue_Thread("beltot_mcg_wemadeit");

	// remove tank infantry and surrender guys.
	ai = getaiarray("axis");
	for(i=0; i < ai.size; i++)
	{
		ai[i] delete();
//		ai[i] dodamage(ai[i].health + 50,(0,0,0));
	}
}

tank_wall()
{
	self endon("death");
	trigger = getent("tank_wall","targetname");
	trigger waittill("trigger");
	self playsound("wall_crumble");
	exploder(3);
}

tank_squash()
{
	self endon("death");
	trigger = getent("tank_squash_trigger","targetname");
	trigger waittill("trigger");
	aEnts = getentarray("tank_squash","targetname");
	for (i=0; i < aEnts.size; i++)
	{
		aEnts[i] moveto(aEnts[i].origin + ((randomint(8)-32),0,(randomint(6)-28)),1);
	}
}

tank_fire_1()
{
	self endon("death");

	node = getvehiclenode("fire_target_1","script_noteworthy");
	while(true)
	{
		node waittill("trigger");
		self setspeed(0,40);
		wait 0.5;

		eTarget = getent("target_1","targetname");
		self setTurretTargetVec(eTarget.origin);
		self waittill("turret_on_target");
		self notify("turret_fire");
		wait 0.2;
		earthquake(.5, 1, level.player getorigin(), 350); // scale duration source radius
		wait 0.3;
		self resumespeed(30);
		self clearTurretTarget();
	}
}

tank_fire_2()
{
	self endon("death");

	node = getvehiclenode("fire_target_2","script_noteworthy");
	while(true)
	{
		node waittill("trigger");
		self setspeed(0,40);
		wait 0.5;

		eTarget = getent("target_2","targetname");
		self setTurretTargetVec(eTarget.origin);
		self waittill("turret_on_target");
		self notify("turret_fire");
		exploder(eTarget.script_noteworthy);
		wait 0.2;
		earthquake(.7, 1.4, level.player getorigin(), 350); // scale duration source radius
		wait 0.3;
		self resumespeed(30);
		self clearTurretTarget();
	}
}

tank_kill_player()
{
	self endon("death");

	truck = getent("truck","targetname");

	node = getvehiclenode("kill_player","script_noteworthy");
	node waittill("trigger");
	wait 3;
	self setTurretTargetEnt(truck,(0,0,24));
	wait 5;
	self waittill("turret_on_vistarget");
	self notify("turret_fire");

	truck dodamage(truck.health * 2, (0,0,0));
	thread killplayer();

	wait 1.5;
	self resumespeed(30);
}

final_sequence()
{
	level waittill("truck on path");

	allies = getaiarray("allies");
	nodes = getnodearray("allies_end_path","targetname");
	rest_node = getnode("allies_end_area","targetname");
	a = 0;

	for (i=0; i < allies.size; i++)
	{
		if (allies[i] == level.price || allies[i] == level.mcgregor)
			continue;
		if (isdefined(nodes[a]))
		{
			allies[i] thread movepath(nodes[a]);
			a++;
		}
		else
		{
			allies[i] setgoalnode(rest_node);
			allies[i].goalradius = rest_node.radius;
		}
	}

	aAI = getaiarray("allies");
	wounded = [];
	for (i=0; i < aAi.size; i++)
	{
		if (isdefined(aAi[i].animname) && aAi[i].animname == "wounded")
			wounded[wounded.size] = aAi[i];
	}

	idle_nodes = getnodearray("axis_end_idle","targetname");

	a = 0;
	for (i=0; i < wounded.size; i++)
	{
		if (i < idle_nodes.size)
		{
			wounded[i] notify("end_loop");
			wounded[i] thread anim_loop_solo (wounded[i], "wounded_"+ int(idle_nodes[i].script_noteworthy), undefined, "end_loop_2", idle_nodes[i]);
		}
		else
			wounded[i] delete();
	}

	// move price to dialog location
	animnode = getnode("price_end_1","targetname");
	level.price teleport(animnode.origin);
	level.price.goalradius = 0;
	level.price setgoalnode(animnode);

	// wait till truck hits this vehicle node
	vnode = getvehiclenode("start_walks","script_noteworthy");

	vnode waittill("trigger");

	level notify("walk early path");

	level waittill("truck on goal");

	level notify("walk path");

	wait 2;
	
	thread music();
	
	level.price Dialogue_Thread("alrightchaps");

	wait 1;
	animnode = getnode("price_end_2","targetname");
	animnode anim_reach_solo (level.price, "almostenvyblokes", undefined, animnode);
	level.price thread Dialogue_Thread("almostenvyblokes", animnode);
	wait 11;
	maps\_endmission::nextmission();
}

movepath(start_node)
{
	self endon("death");

	self.goalradius = 0;
	self setgoalnode(start_node);
	self allowedStances ("stand");
	self.maxsightdistsqrd = (2*2);
	
	if (isdefined(start_node.script_noteworthy))
		level waittill("walk early path");
	else
		level waittill("walk path");

	if (isdefined(start_node.script_wait))
		wait start_node.script_wait;

	targetnode = start_node;

	while(isalive(self))
	{
		self setgoalnode(targetnode);
		self waittill("goal");

		if (isdefined(targetnode.target))
			targetnode = getnode(targetnode.target, "targetname");
		else
			break;
	}

}

/**** setup ****/
setup_price()
{
	level.price = getent("price","script_noteworthy");
	assertex(isdefined(level.price),"Price not getting defined!");
//	level.price set_goalradius(0);
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price setBattleChatter(false);
//	level.price.followmax = -2;
//	level.price.followmin = -4;
}

patrol(targetnode)
{
	level endon("patroldone");
	self endon("death");

	waittillframeend;
	self setBattleChatter(false);

	self set_walkdist(9999);
	self set_goalradius(0);

	self.walk_noncombatanim = %patrolwalk_tired;
	self.walk_noncombatanim2 = %patrolwalk_tired;

	if (!isdefined(targetnode))
		targetnode = getnode(self.target, "targetname");

	while(isalive(self))
	{
		self setgoalnode(targetnode);
		self waittill("goal");

		if(isdefined(targetnode.target))
			targetnode = getnode(targetnode.target, "targetname");
		else
			break;
	}

	self set_walkdist();
	self set_goalradius();

	level notify("patroldone");
}

waittill_combat()
{
	level endon("patroldone");
	self endon("death");
	assert(!isdefined(self.enemy));

	self waittill("enemy");
	self set_walkdist();
	self set_goalradius();
	level notify("patroldone");
}

waittill_death()
{
	level endon("patroldone");
	self waittill("death");
	level notify("patroldone");
}

setup_huntplayer()
{
	aSpawner = getentarray("huntplayerguy","script_noteworthy");
	level array_thread(aSpawner, ::huntplayer_track);
}

huntplayer_track()
{
	assertEX(isdefined(self.script_wait),"need a script_wait value");
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread huntplayer_wait(self.script_wait);
	}
}

huntplayer_wait(waittime)
{
	self endon("death");
	self waittill("goal");
	wait randomfloatrange(waittime,waittime+4);
	self setgoalentity(level.player);
	self.goalradius = 720;
	self.pathenemyfightdist = 720;
	self.pathenemylookahead = 720;
}

setup_final_building()
{
	aSpawner = getentarray("final_building","script_noteworthy");
	level array_thread(aSpawner, ::final_building_track);
}

final_building_track()
{
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread final_building_wait();
	}
}

final_building_wait()
{
	self endon("death");
	level waittill("final_building_guys_attack");
	wait randomfloatrange(0.5,3);
	self setgoalentity(level.player);
	self.goalradius = 350;
	wait 5;
	self.goalradius = 64;
}


/******** utilities ********/

savebyname()
{
	trigger = getent("savebyname","targetname");
	trigger	waittill("trigger");

	// changed to next ambient intensity
	level notify("change ambient");

	autosavebyname("broken wall");
}

objective_follow(id)
{
	self endon("stop objective follow");

	while (true)
	{
		wait 1;
		objective_position(id, self.origin);
	}
}

killplayer()
{
	level.player enableHealthShield( false );
	level.player doDamage (level.player.health, level.player.origin); //killplayer
	level.player enableHealthShield( true );
}

autofire_mg()
{
	self endon("stop autofire");
	aBullseye = getentarray(self.target,"targetname");
	while(true)
	{
		bullseye = aBullseye[randomint(aBullseye.size)];
		target = self getturrettarget();
		if (isdefined(target) && target == bullseye)
		{
			self cleartargetentity();
			wait randomfloatrange(2,5);
		}
		else if (!isdefined(target))
		{
			self settargetentity(bullseye);
			wait randomfloatrange(3,8);
		}
		else
			wait 1;
	}
}

friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;
	
	if (level.friendlyMethod == "friendly chains")
	{
		guy.followmin = level.followmin;
		guy.followmax = level.followmax;
		guy setgoalentity (level.player);
	}
}

badplace_mg42_arc(name,direction)
{
	badarea = false;
	self waittill("startfiring");
	
	while(true)
	{
		if (isdefined(self getturretowner()) && self isfiringturret())
		{
			if (!badarea)
			{
				badplace_arc(name, -1, self.origin, 2048, 400, direction, 5, 5, "allies");
				badarea = true;
			}
		}
		else if (badarea)
		{
			badplace_delete(name);
			badarea = false;
			
		}
		wait 1;
	}
}

spawn_gm_group(targetname, nocharge, nokilladd)
{
	spawner = getentarray(targetname,"targetname");
	assertEX((isdefined(spawner) && spawner.size > 0),"no spawners named: " + targetname);
	goal_node_name = "";
	group = [];

	for (i=0; i < spawner.size; i++)
	{
		goal_node_name = spawner[i].target;

		ai = spawner[i] dospawn();
		if (spawn_failed(ai))
			continue;
		if (!isdefined(nokilladd))
			ai thread increment_on_death();

		// tmp fix
		ai notify("stop_going_to_node");
		group[group.size] = ai;
	}
	goal_node = getnode(goal_node_name,"targetname");
	assertEX(isdefined(goal_node),"No node named: " + goal_node_name);		
	assertEX(isdefined(goal_node.radius),"No radius set in node named: " + goal_node_name);	

	// no group if nospawn
	if (group.size < 1)
		return false;

	simple_groupmove(group, goal_node, nocharge);
}

simple_groupmove(group, goal_node, nocharge)
{
	for (i=0; i < group.size; i++)
	{
		group[i] thread follow_chain(goal_node, nocharge);
	}
}

follow_chain(first_node, nocharge)
{
	self endon("death");
	self endon("abort_chain");
	node = first_node;

	while(true)
	{
		if(!isalive(self))
			break;
		self setgoalnode(node);
		assert(isdefined(node.radius));
		self.goalradius = node.radius;
		if (!isdefined(node.target))
			break;
		node = getnode(node.target,"targetname");
		self waittill("goal");
		if (isdefined(node.script_wait))
			wait node.script_wait;
		else
			wait 5; // default wait time before moving on to the next goal node.
	}
	if (!isdefined(nocharge) && isalive(self))
	{
		self waittill("goal");
		if (isdefined(node.script_wait))
			wait node.script_wait;
		else
			wait 8; // default wait time before charging the player.
		self setgoalentity(level.player);
		self.goalradius = 720;
		self.pathenemyfightdist = 720;
		self.pathenemylookahead = 720;
	}
}

increment_on_death()
{
	self waittill("death");
	level.enemies_killed++;
}

movetoanddelete(node)
{
	self endon("death");
	assert(isdefined(node));
	wait randomfloatrange (0.1, 1);
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}

set_goalradius(radius)
{
	if (!isdefined(radius))
	{
		if (isdefined(self.old_goalradius))
		{
			self.goalradius = self.old_goalradius;
			self.old_goalradius = undefined;
		}
		return;
	}

	if (!isdefined(self.old_goalradius))
		self.old_goalradius = self.goalradius;
	self.goalradius = radius;
}

set_walkdist(dist)
{
	if (!isdefined(dist))
	{
		if (isdefined(self.old_walkdist))
		{
			self.walkdist = self.old_walkdist;
			self.old_walkdist = undefined;
		}
		return;
	}

	if (!isdefined(self.old_walkdist))
		self.old_walkdist = self.walkdist;
	self.walkdist = dist;
}

set_goalnode(node,range)
{
	self endon("death");
	self notify("abort_chain");

	assert(isdefined(node));
	if (isdefined(range))
	{
		assert(range >= 0.1);
		wait randomfloatrange (0.1, range);
	}
	if (isdefined(node.radius) && node.radius > 4)
		self.goalradius = node.radius;
	if (isalive(self))
		self setgoalnode(node);
}

array_prune(array)
{
	assert(array.size > 0);

	newarray = [];
	for(i = 1; i < array.size; i++)
	{
		newarray[newarray.size] = array[i];
	}
	return newarray;
}

Dialogue_Thread(dialogue,node)
{
	self endon("death");

	if (!isdefined(self.dialogueque))
		self.dialogueque = [];

	entnum = self getentitynumber();
	key = self.dialogueque.size;

	self.dialogueque[key]["key"] = key;

	if (self.dialogueque.size > 1)
		self waittill("dialogue_"+entnum+"_"+key);

	self setBattleChatter(false);

	if (isdefined(node))
	{
		self maps\_anim::anim_reach_solo(self, dialogue, undefined, node);
		self maps\_anim::anim_single_solo(self, dialogue, undefined, node);
	}
	else
		self maps\_anim::anim_single_solo(self, dialogue);

	self setBattleChatter(true);

	self.dialogueque = array_prune(self.dialogueque);
	if (self.dialogueque.size > 0)
		self notify("dialogue_"+entnum+"_"+self.dialogueque[0]["key"]);
}

music()
{
	wait 0.3;
	musicplay("tough_road_ahead_beltot_01");
}

ambientchange()
{
	waittillframeend;

	// start
	setAmbientAlias("exterior", "light");
	level waittill("change ambient");
	// orchard fight
	setAmbientAlias("exterior", "medium");
	level waittill("change ambient");
	wait 4;
	// after mortar barrage
	setAmbientAlias("exterior", "");
	level waittill("change ambient");
	// on road towards final house
	setAmbientAlias("exterior", "medium");
	level waittill("change ambient");
	// in final house
	setAmbientAlias("exterior", "light");
}
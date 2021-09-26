#include maps\_utility;
#using_animtree("generic_human");

main()
{
	if (getcvar("scr_duhoc_defend_fast") == "")
		setcvar("scr_duhoc_defend_fast","0");

//	setExpFog(0.00005, 190/255, 195/255, 200/255, 0);
	if (getcvarint("scr_duhoc_defend_fast"))
		setculldist(2500);
	setcullFog(0, 3900, 210/255, 210/255, 210/255, 0);
	setsavedcvar("r_specularColorScale", "1.3");
	setsavedcvar("r_cosinePowerMapShift", "-.49");

	precacheString(&"DUHOC_DEFEND_OBJ_1");
	precacheString(&"DUHOC_DEFEND_OBJ_1B");
	precacheString(&"DUHOC_DEFEND_OBJ_2");
	precacheString(&"DUHOC_DEFEND_OBJ_3");
	precacheString(&"DUHOC_DEFEND_OBJ_4");
	precacheString(&"DUHOC_DEFEND_OBJ_5");
	precacheString(&"DUHOC_DEFEND_OBJ_6");
	precacheString(&"DUHOC_DEFEND_TIMER");
	precacheString(&"DUHOC_DEFEND_PLATFORM_DEPLOY_SMOKE");
	
	precacheModel("xmodel/vehicle_p51_mustang");

	// vehicles
	maps\_tankai::main();
	maps\_tankai_sherman::main("xmodel/vehicle_american_sherman");
	maps\_sherman::main("xmodel/vehicle_american_sherman");
	maps\_jeep::main("xmodel/vehicle_american_jeep_can");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_brush");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland_brush");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");

	// drones
	aitype\axis_nrmdy_wehr_reg_kar98::precache();
	aitype\ally_ranger_wet_nrmdy_reg_garand::precache();
	level.drone_spawnFunction["axis"] =  aitype\axis_nrmdy_wehr_reg_kar98::main;
	level.drone_spawnFunction["allies"] =  aitype\ally_ranger_wet_nrmdy_reg_garand::main;
	maps\_drones::init();

	maps\duhoc_defend_fx::main();

	level thread maps\duhoc_defend_amb::main();

	maps\_load::main();

	maps\duhoc_defend_anim::main();

	/* friendly wave stuff */
	level.totalfriends = 0;
	level.maxfriendlies = 8;
	level.friendlyMethod = "defend_area";
	level.friendlywave_thread = ::friendlyMethod;

	// used by the "defend_area" friendly method
	level.defend_area_lock = false;
	level.autosave_disabled = 0;

	level.sortie_radius = 300;

	level.colored_smoke_deployed = false;
	level.in_orchard = false;
	level.machine_gun = false;
	level.in_farmhouse = false;
	level.in_charlie = false;
	level.in_easy = false;
	level.orchard_clear = false;

	level.magic_fix = true;

	// Fix to stop autosave if the player is stuck on the cliff.
	level thread cliff_nosave();

	/* ai stuff */
	thread setup_character();
	thread setup_ai_smoke();
	thread setup_sortie();
	thread setup_autofire_mg();
	thread setup_delete_node();

	/* vehicle stuff */
	thread setup_vehicle_pause();
	thread setup_vehicle_deploy();
	thread setup_vehicle_fire();
	thread setup_vehicle_aim();

	// sound by trigger
	thread setup_play_trigger_sound();

	// kill player if he leaps of the cliff.
	thread cliff_fall_killplayer();

	/* put farmhouse door in it's initial closed position. */
	farm_door = getent("farmhouse_door","targetname");
	farm_door rotateto((0,30.6,0),1);

	// give farm_arch ents correct script_exploder number
	farm_arch = getentarray("farm_arch","script_noteworthy");
	farm_arch[0].script_exploder = 0;
	farm_arch[1].script_exploder = 0;


	// minspec slow area
	if (!getcvarint("scr_duhoc_defend_fast"))
	{
		door = getent("townhouse_loftdoor","targetname");
		door connectpaths();
		door delete();
	}

	/* initialization done */

	thread objectives();

	/* gameplay threads */
	thread roadblock();
	thread orchard();
	thread machine_gun();
	thread farm_area();
	thread trench_able();
	thread trench_baker();
	thread trench_charlie();
	thread trench_easy();

	thread deploy_colored_smoke();
	thread flyby();
	thread friendly_reinforcements();

	level notify("roadblock");

	start = getcvar("start");
	if (start == "")
		setcvar("start","");

	if (isdefined(start) && start == "green")
		exploder(7);

}

objectives() /**************** ALL OBJECTIVES ****************/
{
	wait 3; // wait some seconds before the objective shows up.
	ent = getent("obj_roadblock_south","targetname");
	objective_add(0,"active",&"DUHOC_DEFEND_OBJ_1",ent.origin);
	objective_current(0);

	level waittill("west halftrack");
	ent = getent("obj_roadblock_west","targetname");
	objective_string(0,&"DUHOC_DEFEND_OBJ_1B");
	objective_position(0,ent.origin);

	level waittill("orchard");
	wait 3;
	objective_state(0,"done");
	ent = getent("obj_orchard","targetname");
	objective_add(1,"active",&"DUHOC_DEFEND_OBJ_2",ent.origin);
	objective_current(1);

	level waittill("machine gun");
	wait 3;
	objective_state(1,"done");
	ent = getent("obj_machine_gun","targetname");
	objective_add(2,"active",&"DUHOC_DEFEND_OBJ_3",ent.origin);
	objective_current(2);

	level waittill("farm area");
	wait 3;
	objective_state(2,"done");
	orgA = getent("trench_able","targetname");
	objective_add(3,"active",&"DUHOC_DEFEND_OBJ_4",orgA.origin);
	objective_current(3);

	level waittill("in trench able");

	start_time = gettime();

	objective_state(3,"done");
	objective_add(4,"active",&"DUHOC_DEFEND_OBJ_5",orgA.origin);
	objective_current(4);

	level waittill("trench charlie");

	// if the player fallsback ahead of time, the time untill reinforcement will be greater.
	fallback_time = gettime();
	total_time = int((fallback_time - start_time)/1000);	// 65000 = 65 secunder = 1.05 minut.
	coward_time = 65 - total_time;
	if (coward_time < 0)
		coward_time = 0;
	wait 3;

	orgC = getent("trench_charlie","targetname");
	objective_position(4,orgC.origin);
	objective_ring(4);
	objective_current(4);

	if (!level.in_charlie)
		level waittill("in trench charlie");
	level thread objective_stopwatch(300+coward_time, 40,4);

	level waittill("trench easy");
	
	orgE = getent("trench_easy","targetname");
	objective_position(4,orgE.origin);
	objective_ring(4);
	objective_current(4);

	level waittill("time warning 0");

	wait 3;

	org_smoke = getent("color_smoke","targetname");
	objective_add(5,"active",&"DUHOC_DEFEND_OBJ_6",org_smoke.origin);
	objective_current(5);

	level waittill("germans destroyed");

	objective_state(4,"done");
	maps\_endmission::nextmission();

}

roadblock() /**************** ROADBLOCK AREA ****************/
{
	// all dialgoue for the roadblock battle
	level thread roadblock_dialogue();

	level waittill("roadblock");
	level.maxfriendlies = 6;

	// init defend areas;
	level.defend_area = [];
	level.defend_area[0] = getnode("roadblock_south","targetname"); 
	level.defend_area[1] = getnode("roadblock_west","targetname");
	level.defend_area[0].ai_in_area = 0;
	level.defend_area[1].ai_in_area = 0;

	level thread defenders();

	// start spawning enemies from the south
	south_axis = getentarray("south_assault","targetname");
	level thread killcount(south_axis,7,35,100,"south repelled");
	level thread flood_spawn(south_axis);

	level waittill("south repelled");

	level thread array_thread(south_axis,::set_count,0);

	level thread autoSaveByName("roadblock");

	// start spawning enemies from the west
	level thread roadblock_halftrack();

	wait 4;
	level notify("west halftrack");
	wait 12;
	west_axis = getentarray("west_assault","targetname");
	level thread killcount(west_axis,7,20,100,"roadblocks lost");
	level thread flood_spawn(west_axis);

	level waittill("roadblocks lost");

	if (!getcvarint("scr_duhoc_defend_fast"))
	{
		level thread array_thread(south_axis,::set_count,1);
		level thread flood_spawn(south_axis);
	}

	level thread roadblock_tanks();

	wait 15;
	level notify("east tank");
	level.panzer1 thread tank_killarea("farmroad_east");
	wait 5;

	// start second tiger tank
	level notify("tank2");
	wait 3;

	// activate retreat back to orchard
	level notify("orchard");

	wait 10;
	// activate sortie
	level thread continuous_sortie("roadblock_sortie");

	// set killarea.
	wait 5;
	level.tiger2 thread tank_killarea("farm_road_2");
	wait 10;
	level.panzer1 thread tank_killarea("farm_road");

}

set_count(count)
{
	self.count = count;
}

roadblock_dialogue()
{
	level thread battleChatterOff("allies");
	level thread battleChatterOff("axis");

	level waittill("roadblock");

	level thread roadblock_east();

	wait 1;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_movinginsouth");
	wait 3;

	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi1_secondcompany");
	wait 2;

	battleChatterOn("allies");
	battleChatterOn("axis");

	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr3_krautssouth");

	wait 5;
	// Stop magic bullet shield on guy that deployes the 30cal.
	level.guy30cal notify("stop magic bullet shield");
	level.guy30cal.anim_disablePain = false;

	wait 5;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi4_battalion");
	wait 5;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_pushinginsouth");

	level waittill("west halftrack");
	level.randall thread Dialogue_Thread("duhocdefend_rnd_halftrackcover");
	wait 2;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_halftrackcomingthru");
	wait 3;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_htwestcover");
	wait 5;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr3_infantryfromwest");
	wait 1.5;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_krautcompany");
	wait 3;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi3_threemenflank");

	level waittill("east tank");
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr9_gertankseast");
	wait 8;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_fallbackorchard");
	wait 3;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_dropbackorchard");
	wait 2;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi2_lieutenant");
	wait 2;
//	if the player doesn't leave?
//	level.randall thread Dialogue_Thread("duhocdefend_rnd_dropbackorchard");
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr3_pullingback");
}

roadblock_east()
{
	trigger = getent("east_roadblock_trigger","targetname");
	trigger waittill("trigger");
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_rnd_giveshout");
}

defenders()
{
	aAi = getaiarray("allies");
	aAi[0] setpotentialthreat(200);
	aAi[1] setpotentialthreat(200);


	aSpawner = getentarray("defenders","targetname");
	for (i=0; i < aSpawner.size; i++)
	{
		ai = aSpawner[i] dospawn();
		if (spawn_failed(ai))
			continue;
		if (isdefined(aSpawner[i].script_noteworthy) && aSpawner[i].script_noteworthy == "defend_area")
		{
			area_node = getnode(ai.target,"targetname");
			ai thread defend_area(area_node);
			ai thread battlechatter_fix();
		}
		if (isdefined(aSpawner[i].script_noteworthy) && aSpawner[i].script_noteworthy == "30calguy")
		{
			level.guy30cal = ai;
			level.guy30cal thread magic_bullet_shield();
			level.guy30cal.anim_disablePain = true;
		}
	}
}

battlechatter_fix()
{
	self endon("death");
	self.battlechatter = false;
	wait 5;
	self.battlechatter = true;
}

roadblock_halftrack()
{
	/* spawn halftrack */
	aVehicle = maps\_vehicle::scripted_spawn(0);
	vehicle = aVehicle[0];
	level thread maps\_vehicle::gopath(vehicle);

	mgguy = vehicle.riders[1];
	wait 30;
	// kill mg guy.
	if (isdefined(mgguy) && isalive(mgguy))
	{
		mgguy dodamage(mgguy.health * 1.25, level.player getorigin());
	}
}

roadblock_tanks()
{
	/* spawn tank */
	aVehicle = maps\_vehicle::scripted_spawn(1);
	level.panzer1 = aVehicle[0];
	level.panzer1.script_turret = 0;

	level thread maps\_vehicle::gopath(level.panzer1);

	level waittill("tank2");
	aVehicle = maps\_vehicle::scripted_spawn(2);
	level.tiger2 = aVehicle[0];
	level.tiger2.script_turret = 0;
	level thread maps\_vehicle::gopath(level.tiger2);
}

orchard() /**************** ORCHARD AREA ****************/
{
	level thread orchard_flanker();
	level thread orchard_mg_guy();

	level waittill("orchard");

	if (!getcvarint("scr_duhoc_defend_fast"))
		level.maxfriendlies = 8;
	else
		level.maxfriendlies = 6;

	// dialogue for orchard battle
	level thread orchard_dialogue();

	level thread change_defend_area("orchard_area");

	// wait for player to enter the orchard proper.
	orchard_trigger = getent("orchard_defend_trigger","targetname");
	orchard_trigger waittill("trigger");

	level thread autoSaveByName("orchard");

	level thread right_flank_warning("orchard_right_flank","machine gun",35);
	level thread left_flank_warning("orchard_left_flank","machine gun",35);

	// stop continuous sortie
	level notify("terminate_sortie");

	// stop spawning axis attacking roadblock
	getent("killspawner_trigger_0","targetname") notify("trigger");

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] thread kill_guy(5);
	}

	// delete halftrack
	trigger = getent("delete_halftrack","targetname");
	trigger notify("trigger");

	wait 5;
	// This will move tiger2 past the east entrance to the orchard.
	level notify("in_orchard");
	level.in_orchard = true;

	orchard_axis = getentarray("orchard_assault","targetname");

	// delete half of the enemy ai and make the remaining more deadly.
	if (getcvarint("scr_duhoc_defend_fast"))
	{
		level.axis_accuracy = 1.5;
		aNew = [];
		for (i=0; i < orchard_axis.size; i++)
		{
			if (isdefined(orchard_axis[i].script_noteworthy2))
				aNew[aNew.size] = orchard_axis[i];
		}
		orchard_axis = aNew;
	}

	// start spawning enemies attacking the orchard.
	level thread killcount(orchard_axis,7,40,200,"orchard fallback");
	level thread flood_spawn(orchard_axis);

	if (!getcvarint("scr_duhoc_defend_fast"))
		level thread decrement_maxfriendlies(8,4,10);	// from 8 to 4 in 40 seconds.
	else
		level thread decrement_maxfriendlies(6,4,10);	// from 6 to 4 in 40 seconds on minspec.

	level waittill("orchard fallback");

	level notify("mortar attack");
	exploder(11);
	wait 15;
	
	level thread decrement_maxfriendlies(4,2,30);	// from 4 to 2 in 60 seconds.

	level notify("machine gun");
	level.machine_gun = true;
}

orchard_mg_guy()
{
	level endon("exit farmhouse");

	while (true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread orchard_mg_guy_kill();
	}
}

orchard_mg_guy_kill()
{
	self endon("death");
	level waittill("exit farmhouse");
	self delete();
}

orchard_flanker()
{
	level endon("on 30cal");
	
	level.orchard_flanker = false;
	level thread orchard_flanker_stop();

	trigger_start = getent("orchard_flanker_start","targetname");
	aSpawner = getentarray("orchard_flanker","targetname");

	while (true)
	{
		if (!level.orchard_flanker)
		{
			trigger_start waittill("trigger");
			level.orchard_flanker = true;
		}
		level notify("orchard_flanker");
		wait 1;
		if (level.orchard_flanker)
		{
			for (i=0; i < aSpawner.size; i++)
			{
				if (level.in_orchard && !level.machine_gun)
					continue;
				if (randomint(10) < 3 && !level.machine_gun)
					continue;
				aSpawner[i] dospawn();
			}
			if (level.machine_gun)
				break;
			wait 20 + randomint(10);
		}
	}
}

orchard_flanker_stop()
{
	level endon("on 30cal");

	trigger_stop = getent("orchard_flanker_stop","targetname");
	while (true)
	{
		if (!level.orchard_flanker)
			level waittill("orchard_flanker");
		trigger_stop waittill("trigger");
		level.orchard_flanker = false;
	}
}

orchard_dialogue()
{
	wait 2;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi1_firstgroup");
	
	if (!level.in_orchard)
		level waittill("in_orchard");

	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_acrossroad");

	wait 10;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_holysmokes");

	wait 7;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi4_takecover");

	level waittill("mortar attack");
	wait .5;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_incoming");
	wait 2;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_takecover");
	wait 5;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_holdtheline");

	level waittill("machine gun");

	level.randall thread Dialogue_Thread("duhocdefend_rnd_mgfarmhouse");

	// When player gets on the mg end this thread so that the reminders doesn't play.
	level thread mg_reminder();
}

mg_reminder()
{
	level endon("all allies safe");

	first = true;
	e30cal = getent("farm_house_30cal","targetname");

	while (true)
	{
		wait 1;
		if (!isdefined(e30cal getturretowner()))
		{
			wait randomint(8)+8;
			if (first)
				wait 15;
			if (!isdefined(e30cal getturretowner()))
			{
				if (randomint(2) || first)
					level.randall thread Dialogue_Thread("duhocdefend_rnd_mgisinwindow");
				else
					level.randall thread Dialogue_Thread("duhocdefend_rnd_getonmg");
				first = false;
			}
		}
	}
}

right_flank_warning(trigger_name,endon_string,delay)
{
	level endon(endon_string);

	trigger = getent(trigger_name,"targetname");
	while(true)
	{
		trigger waittill("trigger");

		switch(randomint(4))
		{
			case 0:
				level.randall thread Dialogue_Thread("duhocdefend_rnd_tryingrightflank");
				break;
			case 1:
				ranger = get_ranger();
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr3_infantryfromwest");
			case 2:
				ranger = get_ranger();
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr1_germanwestflank");
				break;
			default:
				ranger = get_ranger();
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr4_infantryfromwest");
				break;
		}

		wait (delay * 0.75) + (randomfloat(delay * 0.25));
	}
}

left_flank_warning(trigger_name,endon_string,delay)
{
	level endon(endon_string);

	wait (delay * 0.25);

	trigger = getent(trigger_name,"targetname");
	while(true)
	{
		trigger waittill("trigger");

		ranger = get_ranger();
		switch(randomint(4))
		{
			case 0:
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr2_germans");
				break;
			case 1:
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr1_germansleftflank");
				break;
			case 2:
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr3_movingfromeast");
				break;
			default:
				if (isdefined(ranger))
					ranger thread Dialogue_Thread("duhocdefend_gr2_eastflank");
		}
		wait (delay * 0.75) + (randomfloat(delay * 0.25));
	}
}

in_farmhouse()
{
	level endon("exit farmhouse");

	in_trigger = getent("in_trigger","targetname");
	out_trigger = getent("out_trigger","targetname");

	while (true)
	{
		if (!level.in_farmhouse)
		{
			in_trigger waittill("trigger");
			level.in_farmhouse = true;
			level notify("in farmhouse");
		}
		else
		{
			out_trigger waittill("trigger");
			level.in_farmhouse = false;
			level notify("not in farmhouse");
		}
	}
}

machine_gun() /**************** COVER ORCHARD RETREAT ****************/
{
	level thread in_farmhouse();

	level waittill("machine gun");

	if (getcvarint("scr_duhoc_defend_fast"))
		level.axis_accuracy = 1;

	level thread machine_gun_dialogue();

	// keep characters fighting
	level.magic_fix = false;

	if (!level.in_farmhouse)
	{
		level waittill("in farmhouse");

		// teleport character away from the center of the orchard.
		goal = getnode("randall_teleport","targetname");
		level.randall teleport(goal.origin, goal.angles);
	}

	// stop decrement of maxfriendlies
	level notify("stop decrement");

	level thread autoSaveByName("machine gun");

	// stop friendly wave reinforcement
	level.maxfriendlies = 0;

	// spawn some extra allies when the player get close to the 30cal
	level thread extra_orchard_allies();

	e30cal = getent("farm_house_30cal","targetname");

	if (!isdefined(e30cal getturretowner()))
		e30cal waittill("trigger");
	else
		wait 5;
	level notify("on 30cal");

	// let them stay and fight for a short time before escaping
	wait 2;
	// safe_ent will be notified "allies_safe" when they have all passed the safe_trigger
	safe_ent = spawnstruct();
	safe_ent.safe = 0;
	allies_ai = getaiarray("allies");
	level thread array_thread(allies_ai,::allies_safe,safe_ent);
	level thread allies_safe_trigger("farmarea_safe_trigger",safe_ent);

	// move allies to new defend area once player uses mg
	change_defend_area("farmhouse_area",4);

	// stop characters from lagging behind.
	level.magic_fix = true;

	// spawn farm door guy
	spawner = getent("farmdoor_guy","targetname");
	spawner dospawn();	// No need to do anything here. He should move to his node and that will be that.

	// move the panzer1 into the orchard and have it blow up the arch and shoot it's mg.
	level thread orchard_tank(safe_ent);

	wait 6;

	// stop spawning axis attacking roadblock
	getent("killspawner_trigger_1","targetname") notify("trigger");

	// give axis a new path to follow.
	goalnode = getnode("orchard_assault_goal","script_noteworthy");
	axis_ai = getaiarray("axis");
	level thread array_thread(axis_ai,::follow_path, goalnode);
	
	// start spawning new enemies attacking the orchard.
	orchard_axis = getentarray("extra_orchard_axis","targetname");
	level thread flood_spawn(orchard_axis);


	if (safe_ent.safe > 0)
		safe_ent waittill("allies_safe");
	wait 10;

	level.orchard_clear = true;
	level notify("all allies safe");

	// stop spawning axis attacking roadblock
	getent("killspawner_trigger_2","targetname") notify("trigger");

	wait 2;

	level notify("farm area");
}

machine_gun_dialogue()
{
	level waittill("on 30cal");

	wait 1;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_fieldoffire");	
	wait 3;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr4_getouttathere");	
	wait 5;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_fallbackpositions");	
	wait 1;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi3_gogogo");	
	wait 4;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi3_openfire");	
	wait 3;
	german = get_german();
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi2_needcover");	

	if (!level.orchard_clear)
		level waittill("all allies safe");

	level.randall thread Dialogue_Thread("duhocdefend_rnd_goodwork");
	wait 3;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_restlater");
}

orchard_tank(safe_ent)
{
	wait 12;

	level notify("orchard_tank");

	// give the tiger mg some auto targets
	level.panzer1 waittill("reached_end_node");

	ent = getent("orchard_tree","targetname");
	level.panzer1 setturrettargetent(ent,(0,0,0));
	level.panzer1 waittill("turret_on_target");
	level.panzer1 notify("turret_fire");
	exploder(6);

	wait 3;
	level.panzer1.mgturret[0] thread autofire_mg("panzer1_orchard_target",level.panzer1);


	if (safe_ent.safe > 0)
		safe_ent waittill("allies_safe");

	// once all allies are safe blow up the arch.
	ent = getent("orchard_arch","targetname");
	level.panzer1 setturrettargetent(ent,(0,0,0));
	level.panzer1 waittill("turret_on_target");
	level.panzer1 notify("turret_fire");
	exploder(0);
}

extra_orchard_allies()
{
	// spawn in upto 8 additional allies. We need some guys that retreat don't we?
	aSpawner = getentarray("extra_orchard_allies","targetname");
	allied_ai = getaiarray("allies");
	a = 6 - allied_ai.size;
	for (i=0; i<a;i++)
	{
		index = randomint(aSpawner.size);
		aSpawner[index].count = 1;
		ai = aSpawner[index] dospawn();
		
		if (spawn_failed(ai))	// I assume the spawning will work so no special stuff here.
			continue;
		ai thread ignoreme_timed(randomint(10)+5,true);
		ai thread friendlyMethod();
	}
}

farm_area() /**************** FARM AREA FIGHT ****************/
{
	level waittill("farm area");

	level thread farm_area_dialogue();

	level thread autoSaveByName("farmarea");
	level.maxfriendlies = 4;

	// opens the farm door when the player gets down from the second floor.
	farm_door();

	// start spawning new enemies in the farm area.
	farmarea_axis_1 = getentarray("farmarea_axis_1","targetname");
	level thread flood_spawn(farmarea_axis_1);

	// player leaving farm house
	trigger = getent("farmhouse_exit","targetname");
	trigger waittill("trigger");

	level notify("exit farmhouse");

	level thread farm_area_tanks();

	// start spawning new enemies in the farm area.
	farmarea_axis_2 = getentarray("farmarea_axis_2","targetname");
	level thread flood_spawn(farmarea_axis_2);

	// set friendly chain
	chain_node = getnode("farmhouse_chain","targetname");
	level.player setfriendlychain(chain_node);

	// put friendlies on friendly chain.
	level.friendlyMethod = "friendly chains";
	aAllies = getaiarray("allies");
	level thread array_thread(aAllies,::friendlyMethod);

	// player leaving farm area
	trigger = getent("farmarea_exit","targetname");
	trigger waittill("trigger");

	level notify("exit farmarea");

	/* close farmhouse door again so that the player can't backtrack. */
	farm_door = getent("farmhouse_door","targetname");
	farm_door rotateto((0,30.6,0),1);

	// put ai in defend_area
	level.friendlyMethod = "defend_area";
	change_defend_area("trench_able");

	level notify("trench_able");
}

farm_door()
{
	// open farmhouse door
	farm_door = getent("farmhouse_door","targetname");
	farm_door.isopen = false;

	spawner = getent("axis_doorkicker","targetname"); 	// spawn axis door kicker.
	animNode = getnode(spawner.target,"targetname");
	guy = spawner dospawn();
	if (spawn_failed(guy))
	{
		// just open the door by magic.
		farm_door thread open_farm_door();
	}
	else
	{
		// Place an enemy behind the door.
		guy.animname = "german";

		if (level.in_farmhouse)
			level waittill("not in farmhouse");

		farm_door playsound ("wood_door_kick");
		wait 1;

		farm_door thread open_farm_door();
	}

	wait 1;
	farm_door.isopen = true;
}

open_farm_door()
{
	level endon("farm door open");

	self.issolid = true;

	self playsound ("wood_door_shoulderhit");
	self rotateto((0,-105,0), 0.3, 0.2);
	self connectpaths();

	trigger = getent("farmhouse_exit","targetname");
	while (true)
	{
		if ( trigger istouching(level.player) )
		{
			if (self.issolid)
			{
				self notsolid(); // stop the player from geting stuck.
				self.issolid = false;
			}
		}
		else
		{
			if (!self.issolid)
			{
				self solid();
				self.issolid = true;
				if (self.isopen)
					break;
			}
		}
		wait .1;
	}
}

farm_area_dialogue()
{
	level waittill("exit farmhouse");
	level endon("exit farmarea");

	wait 2;
	german = get_german(true);
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi4_southroad");

	wait 7;
	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_germansleftflank");

	wait 4;
	german = get_german(true);
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi1_forward");

	wait 5;
	german = get_german(true);
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi2_forward");

	wait 7;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_penetrationsouth");

	wait 10;
	german = get_german(true);
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi2_inposition");

	wait 10;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_germans");

	wait 8;
	ranger = get_ranger(true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr3_movingfromeast");

	wait 5;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_getoutflanked");

	wait 5;
	german = get_german(true);
	if (isdefined(german))
		german thread Dialogue_Thread("duhocdefend_gi2_forward");

}

farm_area_tanks()
{
	// stop tiger_1 autofire.
	level.panzer1.mgturret[0] notify("stop autofire");

	// panzer1 new kill area.
	level.panzer1 thread tank_killarea("farm_road_2");

	// move tiger_1 up to farmarea
	vnode = getvehiclenode("farmarea_path","targetname");
	level.panzer1 attach_to_path(vnode);
	level thread maps\_vehicle::gopath(level.panzer1);

	// move tiger2 passed farmarea
	level notify("pass_farmarea");
}

trench_able()
{
	level waittill("trench_able");

	level thread trench_able_dialogue();

	level thread autoSaveByName("trench_able");
	level.maxfriendlies = 6;

	level thread trench_able_halftrack();

	// waittill player in trench
	able_trigger = getent("trench_able_trigger","targetname");
	able_trigger waittill("trigger");

	level notify("in trench able");
	wait 1;

	// set killarea
	level.panzer1 thread tank_killarea("killzone_able");
	level.tiger2 thread tank_killarea("killzone_baker");

	wait 10;

	able_drone_trigger = undefined;
	baker_drone_trigger = undefined;
	baker_allies_drone_trigger = undefined;

	// start able axis drones
//	if (!getcvarint("scr_duhoc_defend_fast"))
//	{
		able_drone_trigger = getent("able_assault_drones","script_noteworthy");
		able_drone_trigger notify("trigger");
//	}

	// start baker axis drones
	if (!getcvarint("scr_duhoc_defend_fast"))
	{
		baker_drone_trigger = getent("baker_assault_drones","script_noteworthy");
		baker_drone_trigger notify("trigger");
	}

	// start baker allies drones
	if (!getcvarint("scr_duhoc_defend_fast"))
	{
		baker_allies_drone_trigger = getent("baker_defend_drones","script_noteworthy");
		baker_allies_drone_trigger notify("trigger");
	}

	// attack_wave(wave_name, wave_percentage, charge_notify)
	controll_ent = attack_wave("able_assault_axis", 0.25, "able");

	level thread coward("trench_able_area",20);

	// stop drones, on minspec, once real ai reaches max number.
	if (getcvarint("scr_duhoc_defend_fast"))
		able_drone_trigger thread stop_minispec_drones(controll_ent);

	// this increases the number of attackers to 100% over time.
	controll_ent attack_stage(50);
	
	level notify("trench baker");

	// stop drones a bit quicker on minspec
	if (getcvarint("scr_duhoc_defend_fast"))
		able_drone_trigger notify("stop_drone_loop");

	// stops baker defend drones
	if (!getcvarint("scr_duhoc_defend_fast"))
		baker_allies_drone_trigger notify("stop_drone_loop");

	wait 5;

	// stops baker assault drones
	if (!getcvarint("scr_duhoc_defend_fast"))
		baker_drone_trigger notify("stop_drone_loop");

	level notify("trench charlie");

	// stops able assault drones
	if (!getcvarint("scr_duhoc_defend_fast"))
		able_drone_trigger notify("stop_drone_loop");

	wait 5;
	controll_ent notify("charge");

	if (!level.in_charlie)
		level waittill("in trench charlie");
	controll_ent notify("terminate attack");
	level notify("terminate able");
}

stop_minispec_drones(controll_ent)
{
	wait 5;
	while (controll_ent.ai_alive < ( controll_ent.total_ai-1 ) )
		wait 1;
	self notify("stop_drone_loop");
}

trench_able_dialogue()
{
	level endon ("trench charlie");

	level waittill("in trench able");

	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_holdup");
	wait 1.5;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_holdhere");
	wait 1;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr3_lockandload");
	wait 2.5;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr4_checkyourammo");
	wait 2;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_getready");
	wait 2;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr6_thisisit");

	wait 5;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr1_heretheycome");
	wait 7;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_tookthefarm");
	wait 3;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr2_pushingsouth");
	wait 9;
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr6_tookthefarm");
}

trench_able_halftrack()
{
	// dissable backtrack trigger
	backtrack_trigger = getent("farm_backtrack","script_noteworthy");
	backtrack_trigger triggeroff();

	// start german halftrach when player exits the farmarea.
	trigger = getent("halftrack2","targetname");
	trigger waittill("trigger");

	// enable backtrack trigger
	backtrack_trigger triggeron();

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
	{
		
		aAi[i] thread kill_guy(5);
	}

	/* spawn halftrack */
	aVehicle = maps\_vehicle::scripted_spawn(3);
	vehicle = aVehicle[0];
	vehicle.health = 100000; // high health so that the player can't kill it.
	level thread maps\_vehicle::gopath(vehicle);

	vehicle waittill("reached_end_node");
	level notify("halftrack_gone");
	maps\_vehicle::delete_group(vehicle);

	// set the panzer tank to cycle through targets.
	level.panzer1 thread cycle_tank_target();

}

trench_baker()
{
	level waittill("trench baker");

	ranger = get_ranger();
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr9_brokenthruable");
}

trench_charlie()
{
	// start it here so that it doesn't miss the notification
	level thread trench_charlie_timer_dialgoue();

	level waittill("trench charlie");

	level thread trench_charlie_dialogue();
	
	if (getcvarint("scr_duhoc_defend_fast"))
		setculldist(0);
	else
		setcullFog(0, 5000, 210/255, 210/255, 210/255, 60);
	
	level.maxfriendlies = 4;

	wait 2;

	level thread change_defend_area("trench_charlie",5);

	// wait for player to enter trench Charlie.
	charlie_trigger = getent("trench_charlie_trigger","targetname");
	charlie_trigger waittill("trigger");

	// Spawn braeburn
	spawner = getent("braeburn","targetname");
	ai = undefined;
	while (!isdefined(ai))
	{
		ai = spawner stalingradspawn();
		spawn_failed(ai);
	}

	level thread autoSaveByName("trench charlie");

	level.in_charlie = true;
	level notify("in trench charlie");
	wait 1;

	// Due to the fact that I have much fewer axis in this area have them be more deadly.
	level.axis_accuracy = 1.4;

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] thread kill_guy(10);
	}

	level thread right_flank_warning("charlie_right_flank","trench easy",60);
	level thread left_flank_warning("charlie_left_flank","trench easy",60);

	level notify("light rain");
	// level.heavy_rain = false;

	// change killzone for panzer tank.
	level.panzer1 thread tank_killarea("killzone_charlie");

	charlie_drone_trigger = undefined;

	// start able drones
//	if (!getcvarint("scr_duhoc_defend_fast"))
//	{
		charlie_drone_trigger = getent("charlie_assault_drones","script_noteworthy");
		charlie_drone_trigger notify("trigger");
//	}

	// attack_wave(wave_name, wave_percentage, charge_notify)
	controll_ent = attack_wave_stalingrad("trench_charlie_attack", 0.25, "charlie");

	level thread coward("anti_charlie_area",30,true);

	// stop drones, on minspec, once real ai reaches max number.
	if (getcvarint("scr_duhoc_defend_fast"))
		charlie_drone_trigger thread stop_minispec_drones(controll_ent);

	// this increases the number of attackers to 100% over time. Will also end on "coward"
	controll_ent attack_stage(120);
	wait 20;

	// stops charlie assault drones
	if (!getcvarint("scr_duhoc_defend_fast"))
		charlie_drone_trigger notify("stop_drone_loop");

	level notify("trench easy");
	
	wait 5; // give player a 5 second window before ai charge.

	// sets attackes to charge player.
	controll_ent notify("charge");

	if (!level.in_easy)
		level waittill("in trench easy");
	controll_ent notify("terminate attack");
	level notify("terminate charlie");
}

trench_charlie_dialogue()
{
	level endon ("trench easy");

	level.randall thread Dialogue_Thread("duhocdefend_rnd_ableoverrun");
	wait 6;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_onfeet");

	level thread trench_charlie_reminder();
}

trench_charlie_timer_dialgoue()
{
	level waittill("stopwatch");

	wait 4;
	level.dialogue_block = true;
	wait 2;

	level.braeburn thread Dialogue_Thread("duhocdefend_bra_igotthrough",undefined,true);
	wait 6;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_cominginwhen",undefined,true);
	wait 3;
	level.braeburn thread Dialogue_Thread("duhocdefend_bra_aboutfivemin",undefined,true);
	wait 4;
	level.dialogue_block = false;

	node = getnode("delete_braeburn","targetname");
	level.braeburn setgoalnode(node);
	level.braeburn waittill("goal");
	while( level.braeburn cansee( level.player ) )
		wait 2;
	level.braeburn delete();
}

trench_charlie_reminder()
{
	level endon("in trench charlie");

	wait 14;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_keepupcorp");
	wait 8;
	level.randall thread Dialogue_Thread("duhocdefend_rnd_taylormove");
}

trench_easy()
{
	level waittill("trench easy");

	if (!getcvarint("scr_duhoc_defend_fast"))
		setcullFog(0, 9000, 210/255, 210/255, 210/255, 60);
	else
	{
		setcullFog(0, 7000, 210/255, 210/255, 210/255, 60);
		setculldist(3900);
	}
	level.maxfriendlies = 3;

	level thread trench_easy_dialogue();

	level thread change_defend_area("trench_easy",5);

	// terminates the coward thread.
	level notify("new coward area");

	// wait for player to enter trench easy.
	easy_trigger = getent("trench_easy_trigger","targetname");
	easy_trigger waittill("trigger");

	level.in_easy = true;
	level notify("in trench easy");
	
	// Due to the fact that I have much fewer axis in this area have them be more deadly.
	level.axis_accuracy = 1.8;

	wait 1;
	level thread killzone_easy();

	// stops rain
	level notify("no rain");

	level thread autoSaveByName("trench easy");

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] thread kill_guy(10);
	}

	// attack_wave(wave_name, wave_percentage, charge_notify)
	controll_ent = attack_wave_stalingrad("trench_easy_attack", 0.25, "easy");

	// this increases the number of attackers to 100% over time.
	controll_ent attack_stage(90);
	wait 30;

	level waittill("time warning 2");

	controll_ent notify("terminate attack");
	level notify("terminate easy");

}

killzone_easy()
{
	wait 15;
	// change killzone for panzer tank.
	level.panzer1 thread tank_killarea("killzone_easy",true);
}

kill_guy(delay)
{
	self endon("death");
	wait randomint(delay);
	self dodamage(self.health * 1.25, level.player getorigin());
}


trench_easy_dialogue()
{
	// total time 170 minutes

	level.randall thread Dialogue_Thread("duhocdefend_rnd_charlie");
	wait 5; // 5
	level.randall thread Dialogue_Thread("duhocdefend_rnd_charlienow");
	wait 7; // 12
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr9_nextphase");

	wait 10; // 22
	level.randall thread Dialogue_Thread("duhocdefend_rnd_watchtunnel");

	wait 5; // 27

	// gives warning when enemies are in the tunnel.
	level thread bunker_tunnel_easy();
//	level thread right_flank_warning("easy_right_flank","time warning 0",60);
//	level thread left_flank_warning("easy_left_flank","time warning 0",60);

	wait 20; // 27
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_holdtheline");
	
	wait 20; // 67
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr9_holdpointe");

	wait 33; // 100
	level.randall thread Dialogue_Thread("duhocdefend_rnd_lastline");

	wait 25; // 125
	ranger = get_ranger(undefined,true);
	if (isdefined(ranger))
		ranger thread Dialogue_Thread("duhocdefend_gr5_whereflyboys");
}

bunker_tunnel_easy()
{
	level endon("time warning 0");

	trigger = getent("bunker_tunnel_easy_warning","targetname");
	cancel_trigger = getent("bunker_tunnel_easy","targetname");

	lines = [];
	lines[0] = "duhocdefend_gr5_thrutunnels";
	lines[1] = "duhocdefend_gr9_thrutunnelsbig";
	lines[2] = "duhocdefend_gr5_moretunnel";
	lines[3] = "duhocdefend_gr9_morekrauts";

	count=0;
	while (true)
	{
		trigger waittill("trigger",ent);
		if (!level.player istouching(cancel_trigger))
		{
			ranger = get_ranger(undefined,true);
			if (isdefined(ranger))
				ranger thread Dialogue_Thread(lines[count%4]);
			wait 30;
			count++;
		}
	}
}

deploy_colored_smoke()
{
	grenade_ent = getent("color_smoke","targetname");
	objective_ent = getent("color_smoke_obj","targetname");
	grenade_ent hide();
	objective_ent hide();
	use_trigger = getent("color_smoke_use","targetname");
	use_trigger triggeroff();

	use_trigger sethintstring(&"DUHOC_DEFEND_PLATFORM_DEPLOY_SMOKE");

	level waittill("time warning 0");
	
	level thread autoSaveByName("deploy smoke");

	level.randall thread Dialogue_Thread("duhocdefend_rnd_popsmoke");

	level thread deploy_reminder();

	// block any autosaves at this point.
	disable_autosave();

	objective_ent show();
	use_trigger triggeron();

	use_trigger waittill("trigger");

	use_trigger delete();
	objective_ent delete();

	exploder(7);
	wait 2;
	level.colored_smoke_deployed = true;
	level notify("smoke deployed");

	objective_state(5,"done");
	objective_current(4);
}

deploy_reminder()
{
	level endon("smoke deployed");
	level waittill("time warning 1");

	level.randall thread Dialogue_Thread("duhocdefend_rnd_bombevery",undefined,true);
	level waittill("time warning 2");
	level.randall thread Dialogue_Thread("duhocdefend_rnd_before",undefined,true);
	level waittill("time warning 3");
	level.randall thread Dialogue_Thread("duhocdefend_rnd_wheresmoke",undefined,true);
	wait 4;
	iprintlnbold(&"DUHOC_DEFEND_SMOKE_REMINDER");
}

flyby()
{
	level waittill("time warning 3");
	wait 4;
	level thread kill_tanks();

	plane = sky_makeplane("spitfire1");
	plane thread plane_sound();
	plane thread flyby_quake();
	plane thread plane_delete();
	exploder(8);

	wait .75;
	plane2 = sky_makeplane("spitfire2");
	plane2 thread plane_sound();
	plane2 thread flyby_quake();
	plane2 thread plane_delete();
	exploder(10);

	// just two planes on minspec
	if (!getcvarint("scr_duhoc_defend_fast"))
	{
		wait 1.25;
		plane3 = sky_makeplane("spitfire3");
		plane3 thread plane_sound();
		plane3 thread flyby_quake();
		plane3 thread plane_delete();
		exploder(9);

	}
	else
	{
		wait 1.25;
	}

	wait 3;
	if (!level.colored_smoke_deployed)
	{
		exploder(12);
		wait 3.6;
		maps\_shellshock::main(8,50,50,50);
		wait .4;
		level thread maps\_fx::OneShotfx("spitfire_bomb", level.player getorigin(), 0);
		level.player playsound(level.scr_sound ["mud_impact"]);
		wait .4;
		killplayer();
	}
	else
	{
		enable_autosave();
		level thread autoSaveByName("pointe secure");
	}

}

kill_tanks()
{
	wait 10;
	// kill panzer when the flyby happens.
	level.panzer1 notify("death");
	wait 12;
	level.tiger2 notify("death");
}

plane_delete()
{
	self waittill("reached_end_node");
	self delete();
}

plane_sound()
{
	self thread flyby_sound();
	self thread playLoopSoundOnTag(level.scr_sound ["spitfire_plane_loop"], "tag_prop");
}

flyby_sound()
{
	self endon("reached_end_node");
	while (true)
	{
		if (distance(level.player getorigin(), self getorigin()) < 2500)
		{
			name = "plane_flyby_spitfire" + (randomint(3)+1);
			self thread playSoundOnTag(level.scr_sound[name], "tag_prop");
			wait 2;
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

friendly_reinforcements()
{
	level waittill("time warning 3");

	wait 12;

	// start friendly vehicles (then returns)
	friendly_vehicles();

	level thread friendly_reinforcements_dialogue();

	// germans escape and die.
	node = getnode("final_escape","targetname");
	aAi = getaiarray("axis");
	for (i=0; i<aAi.size; i++)
	{
		aAi[i] thread escape_and_die(node);
	}

	level.sherman waittill("reached_end_node");

	wait 10;

	level notify("germans destroyed");
}

friendly_reinforcements_dialogue()
{
	wait 25;

	ranger = get_ranger();
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr1_howdoyoulike");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr1_howdoyoulike"]);
	}

	wait 4;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr2_bakercharlie");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr2_bakercharlie"]);
	}

	wait 4;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr4_getmerunner");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr4_getmerunner"]);
	}
	wait 2;
	if (isalive(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr4_getmedichere");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr4_getmedichere"]);

	}
	wait 2;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr5_keepmoving");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr5_keepmoving"]);
	}

	wait 3;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr2_ddtanks");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr2_ddtanks"]);
	}

	wait 2;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr3_guardsintersection");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr3_guardsintersection"]);
	}

	wait 4;
	ranger = get_ranger(true);
	if (isdefined(ranger))
	{
		if (ranger.animname == "ranger")
			ranger thread Dialogue_Thread("duhocdefend_gr5_signallamp");
		else
			ranger playsound(level.scrsound["ranger"]["duhocdefend_gr5_signallamp"]);
	}
}


friendly_vehicles()
{
	/* spawn Shermans and the jeep */
	aVehicle = maps\_vehicle::scripted_spawn(4);
	for (i=0; i < aVehicle.size;i++)
	{
		if (isdefined(aVehicle[i].targetname) && aVehicle[i].targetname == "transporter")
			level.sherman = aVehicle[i];
		level thread maps\_vehicle::gopath(aVehicle[i]);
	}
}

escape_and_die(node)
{
	self endon("death");

	self notify("escape your doom");

	self.maxSightDistSqrd = 350*350;
	self clearEnemyPassthrough();
	wait 15;
	self.pathenemyfightdist = 64;
	self.pathenemylookahead = 64;
	self clearEnemyPassthrough();
	self setgoalnode(node);
	self.goalradius = 256;
	wait randomint(15) + 5;
	self dodamage(self.health * 1.5, level.player getorigin());
}

/***** ai setup and controll *****/


getFurthestExclude (org, ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	for (i=0; i<excluders.size; i++)
	{
		ents = array_remove (ents, excluders[i]);
	}

	return getFurthest(org, ents);
}

getFurthest(org, array, dist)
{
	if(!isdefined(dist))
		dist = 0;
	if (array.size < 1)
		return;
	ent = undefined;		
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist <= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getFurthestAI (org, team)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getFurthest (org, ents);
}

getRandomExclude (ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	for (i=0; i<excluders.size; i++)
	{
		ents = array_remove (ents, excluders[i]);
	}

	return getRandom(ents);
}

getRandom(ents)
{
	i = randomint(ents.size);
	return ents[i];
}

getRandomAI(team)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getRandom (ents);
}

getRandomAIExclude (team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getRandomExclude (ents, excluders);
}

getFurthestAIExclude (org, team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getFurthestExclude (org, ents, excluders);
}

get_ranger(furthest,randomize)
{
	excluders = [];
	excluders[0] = level.randall;
	if (isdefined(level.braeburn))
		excluders[1] = level.braeburn;
	if (isdefined(furthest))
		ranger = getFurthestAIExclude (level.player getorigin(), "allies", excluders);
	else if (!isdefined(randomize))
	{
		ranger = getClosestAIExclude (level.player getorigin(), "allies", excluders);
	}
	else
		ranger = getClosestAIExclude (level.player getorigin(), "allies", excluders);

	if (isdefined(ranger) && !isdefined(ranger.animname))
		ranger.animname = "ranger";
	return ranger;
}

get_german(furthest)
{
	excluders = [];
	if (!isdefined(furthest))
		german = getClosestAI (level.player getorigin(), "axis");
	else
		german = getFurthestAI (level.player getorigin(), "axis");
	
	if (isdefined(german))
		german.animname = "german";
	return german;
}

attack_stage(base_time)
{
	level endon("coward");

	total_increase = 1 - self.wave_percentage;
	stage_increase = total_increase/4;
	part_time = base_time/5;

	for (i=0; i<4;i++)
	{
		wait part_time;
		self.wave_percentage += stage_increase;

		if (i == 3)
			level thread autoSaveByName("halftime");
	}

	// at this point it should hit 100%
	self.wave_percentage = 1;
	wait part_time;
}

attack_wave(wave_name, wave_percentage, name)
{
	controll_ent = spawnstruct();

	controll_ent.info = name;
	controll_ent.ai_alive = 0;

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
		aAi[i] thread attack_wave_track(controll_ent);

	controll_ent.total_ai = 0;
	controll_ent.wave_timeout = false;
	controll_ent.wave_percentage = wave_percentage;

	aSpawner = getentarray(wave_name,"targetname");
	controll_ent.total_ai = aSpawner.size;
	level thread attack_wave_spawn(aSpawner,controll_ent);

	level thread attack_wave_controll(controll_ent);
	
	return controll_ent;
}

attack_wave_stalingrad(wave_name, wave_percentage, name)
{
	controll_ent = spawnstruct();

	controll_ent.info = name;

	controll_ent.ai_alive = 0;

	aAi = getaiarray("axis");
	for (i=0; i < aAi.size; i++)
		aAi[i] thread attack_wave_track(controll_ent);

	controll_ent.total_ai = 0;
	controll_ent.wave_timeout = false;
	controll_ent.wave_percentage = wave_percentage;

	// for each area trigger run the attack_wave_spawn thread for it's spawner;
	aArea_trigger = getentarray(wave_name,"targetname");

	aArea_spawners = [];

	for (i=0; i < aArea_trigger.size; i++)
	{
		aSpawner = getentarray(aArea_trigger[i].script_noteworthy,"targetname");
		controll_ent.total_ai += aSpawner.size;
		level thread attack_wave_spawn(aSpawner,controll_ent,aArea_trigger[i]);
	}

	level thread attack_wave_controll(controll_ent);

	return controll_ent;
}

attack_wave_controll(controll_ent)
{
	controll_ent endon("terminate attack");
	level endon("terminate " + controll_ent.info);

	while(true)
	{
		controll_ent waittill("attacker died");

		current_cap = controll_ent.total_ai * controll_ent.wave_percentage;
		percentage_alive = controll_ent.ai_alive / current_cap;

		// when 60 % is dead, spawn again.
		if (percentage_alive < 0.4 || (controll_ent.ai_alive < 10 && controll_ent.wave_timeout))
		{
			before = controll_ent.ai_alive;
			controll_ent notify("spawn wave");
			level thread wave_timeout(controll_ent);
			wait .5; // wait a while so that the ai can spawn
		}
	}
}

wave_timeout(controll_ent)
{
	controll_ent endon("spawn wave");
	controll_ent endon("terminate attack");
	controll_ent.wave_timeout = false;
	wait 20;
	controll_ent.wave_timeout = true;
	controll_ent notify("attacker died");
}

attack_wave_spawn(aSpawner,controll_ent,area_trigger)
{
	controll_ent endon("terminate attack");
	level endon("terminate " + controll_ent.info);

	while(true)
	{
		spawned = 0;
		cap = int(aSpawner.size * controll_ent.wave_percentage);

		// stops the same type of ai from getting spawned all the time.
		aSpawner = array_randomize(aSpawner);

		for (i=0; i < aSpawner.size; i++)
		{
			if (controll_ent.ai_alive >= controll_ent.total_ai)
				break;

			aSpawner[i].count = 1;
			if (isdefined(area_trigger))
			{
				if (level.player istouching(area_trigger))
					continue;
				ai = aSpawner[i] stalingradspawn();
			}
			else
				ai = aSpawner[i] dospawn();
			if (spawn_failed(ai))
				continue;

			ai thread attack_wave_track(controll_ent);
			ai thread attack_wave_charge(controll_ent);
			
			spawned++;
			if (spawned > cap)
				break;
		}

		wait .5;
		controll_ent waittill("spawn wave");
	}
}

attack_wave_track(controll_ent)
{
	controll_ent.ai_alive++;
	self waittill("death");
	controll_ent.ai_alive--;
	controll_ent notify("attacker died");
}

attack_wave_charge(controll_ent)
{
	self endon("death");
	controll_ent waittill("charge");
	if (randomint(10) < 6)
		self thread kill_guy(7);
	self notify("stop_going_to_node");
	self setgoalentity(level.player);
	self.goalradius = 512;
}

coward(area_name,leisure_time,anti)
{
	level notify("new coward area");
	level endon("new coward area");

	lines = [];
	lines[0] = "duhocdefend_rnd_firepower";
	lines[1] = "duhocdefend_rnd_getbackhere";

	count = 0;

	trigger = getent(area_name,"targetname");
	while(true)
	{
		if (isdefined(anti) && anti == true)
		{
			if (level.player istouching(trigger))
			{
				level.randall thread Dialogue_Thread(lines[count%2]);
				count++;
				if (count > 2)
				{
					level notify("coward");
					break;
				}
				wait (leisure_time / count);
			}
		}
		else
		{
			if (!level.player istouching(trigger))
			{
				level.randall thread Dialogue_Thread(lines[count%2]);
				count++;
				if (count > 2)
				{
					level notify("coward");
					break;
				}
				wait (leisure_time / count);
			}
		}
		wait 1;
	}
}

setup_character()
{
	aSpawner = getentarray("character","script_noteworthy");
	for (i=0; i < aSpawner.size; i++)
	{
		assert(isdefined(aSpawner[i].script_noteworthy));
		if (aSpawner[i].script_friendname == "Sgt. Randall")
			aSpawner[i] thread setup_randall();
		if (aSpawner[i].script_friendname == "Pvt. Braeburn")
			aSpawner[i] thread setup_braeburn();
	}
}

setup_randall()
{
	self waittill("spawned",ai);
	if (spawn_failed(ai))
	{
			assertmsg("randall didn't spawn");
			return;
	}

	level.randall = ai;
	level.randall.animname = "randall";
	level.randall.magicbulletshield = true;
	level.randall thread magic_bullet_shield();
	level.randall thread animscripts\battlechatter_ai::aiOfficerOrders();

	level.randall.battlechatter = false;

//	level.randall.old_maxsightdistsqrd = level.randall.maxsightdistsqrd;
//	level.randall.maxsightdistsqrd = (256*256);
	level.randall.pathenemyfightdist = 720;
	level.randall.pathenemylookahead = 64;

	level.randall thread magic_fix();

	wait 5;
	level.randall.battlechatter = true;

}

setup_braeburn()
{
	self waittill("spawned",ai);
	if (spawn_failed(ai))
	{
			assertmsg("braeburn didn't spawn");
			return;
	}
	level.braeburn = ai;
	level.braeburn.animname = "braeburn";
	level.braeburn.magicbulletshield = true;
	level.braeburn thread magic_bullet_shield();

	level.braeburn.battlechatter = false;

	level.braeburn.pathenemyfightdist = 720;
	level.braeburn.pathenemylookahead = 64;
}

magic_fix()
{
	self endon("death");
	while (true)
	{
		wait .5;
		if (!level.magic_fix)
			continue;
		if (distance(self getorigin(), level.player getorigin()) > 256)
		{
			self ignoreme_timed(9.5);
			wait 9;
		}
	}
}

follow_path(node)
{
	self endon("death");

	self notify("stop_going_to_node");

	self setgoalnode(node);
	self.goalradius = node.radius;

	while(isdefined(node.target))
	{
		self waittill("goal");
		if (isdefined(node.script_delay))
			wait node.script_delay;
		node = getnode(node.target,"targetname");
		assert(isdefined(node));
		self setgoalnode(node);
		self.goalradius = node.radius;
	}
}

decrement_maxfriendlies(max,min,time)
{
	level endon("stop decrement");
	// will decrement level.maxfriendlies by 1 from max to min with a intervall of time.

	for (friendlies=max; friendlies >= min; friendlies--)
	{
		level.maxfriendlies = friendlies;
		wait time;
	}	
}

change_defend_area(area_name,max_delay)
{
	level.defend_area_lock = true;

	level.defend_area = [];
	aNode = getnodearray(area_name,"targetname");

	for (i=0; i < aNode.size; i++)
	{
		level.defend_area[i] = aNode[i];
		level.defend_area[i].ai_in_area = 0;
	}

	aAi = getaiarray("allies");
	for (i=0; i < aAi.size; i++)
	{
		aAi[i] thread defend_area(aNode[randomint(aNode.size)],max_delay);
		
	}

	level.defend_area_lock = false;
	level notify("defend_area_unlocked");
}

allies_safe(ent)
{
	// don't check for this one reaching the safe area.
	if (isdefined(self.script_noteworthy) && self.script_noteworthy == "in safe area")
		return;
	ent.safe++;
	// decrement safe counter if ai dies or get to safety.
	// notify "allies_safe" when no allies in left in danger area.
	self waittill_any("death","safe");
	ent.safe--;
	if (ent.safe <= 0)
		ent notify("allies_safe");
}

allies_safe_trigger(trigger_name,ent)
{
	// notify ai "safe" when it triggers the safe trigger
	ent endon("allies_safe");
	safe_trigger = getent(trigger_name,"targetname");
	while (true)
	{
		safe_trigger waittill("trigger",ai);
		ai notify ("safe");
	}
}

setup_sortie()
{
	aSpawner = getentarray("sortie","script_noteworthy");
	level array_thread(aSpawner, ::sortie);

	aTrigger = getentarray("sortie_trigger","targetname");
	level array_thread(aTrigger, ::sortie_trigger);
}

sortie()
{
	while(true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread sortie_wait(self.script_wait,self.script_waittill);
	}
}

sortie_wait(waittime, waitstring)
{
	self endon("death");
	self endon("escape your doom");

	assert(isdefined(level.sortie_radius));

	if (isdefined(waitstring))
		level waittill(waitstring);
	else
		self waittill("goal");
	if (isdefined(waittime))
		wait randomfloatrange(waittime,waittime+4);

	println("sortie " + self getentitynumber());

	// stops the built in node to node movement.
	self notify("stop_going_to_node");

	self setgoalentity(level.player);
	self.goalradius = level.sortie_radius;
}

sortie_trigger()
{
	// match the script_noteworthy with the script_waittill for the sortie guys you want to trigger.
	self waittill("trigger");
	level notify(self.script_noteworthy);
}

continuous_sortie(notify_string)
{
	level endon("terminate_sortie");

	while (true)
	{
		level notify(notify_string);
		wait 1;
	}
}

setup_delete_node()
{
	ents = getnodearray("delete","script_noteworthy");
	array_thread(ents,::delete_node);
}

delete_node()
{
	assert(isdefined(self.radius));

	flags = 11; // triggor on all ai

	if (isdefined(self.script_team))
	{
		if (self.script_team == "axis")
			flags = 9; // trigger on axis only
		else
			flags = 10; // trigger on allies only
	}

	trigger = spawn( "trigger_radius", self.origin, flags, self.radius, 256);

	while(true)
	{
		trigger waittill("trigger",ai);
		ai delete();
	}
}

setup_play_trigger_sound()
{
	aSound_trigger = getentarray("sound_trigger","targetname");
	array_thread(aSound_trigger,::play_trigger_sound);
}

play_trigger_sound()
{
	self waittill("trigger",ent);
	if (isdefined(self.target))
		ent = getent(self.target,"targetname");
	
	ent playsound(self.script_noteworthy);
}

setup_ai_smoke()
{

	ents = getnodearray("ai_smoke","script_noteworthy");
	array_thread(ents,::ai_smoke);
}

ai_smoke()
{
	/*
		script_noteworthy: "ai_smoke"
		script_increment: number of times the node will need to be triggerd before a grenade is thrown.
		script_shots: max number of times a grenade will be thrown. undefined = endless.
		script_wait: time to wait between waiting for hits.
	*/

	assert(isdefined(self.radius));

	flags = 11; // triggor on all ai

	if (isdefined(self.script_team))
	{
		if (self.script_team == "axis")
			flags = 9; // trigger on axis only
		else
			flags = 10; // trigger on allies only
	}

	trigger = spawn( "trigger_radius", self.origin, flags, self.radius, 256);
	goal = getent(self.target,"targetname");

	interval_hit = 0;
	interval = 0;

	if (isdefined(self.script_increment))
		interval_hit = self.script_increment;

	while(true)
	{
		trigger waittill("trigger",ai);

		if (interval >= interval_hit)
		{
			if (!isalive(ai))
				continue;
			ai thread ai_throw_smoke(goal);
			interval = 0;
			if (isdefined(self.script_shots))
			{
				self.script_shots--;
				if (self.script_shots <= 0)
					break;
			}
		}
		else
		{
			interval++;
		}
		// if script_wait is defined restart thread once the wait is over. else terminate trigger
		if (isdefined(self.script_wait))
			wait self.script_wait;
		else
		{
			trigger delete();
			break;
		}
	}
}

ai_throw_smoke(goal)
{
	self endon("death");
	
	wait 0.5; // to raise the odds that the ai will face more or less the right way.

	self.ignoreme = true;

	if (!isdefined(self.oldanimname))
		self.oldanimname = self.animname;

	if (!isdefined(self.oldGrenadeWeapon))
		self.oldGrenadeWeapon = self.grenadeWeapon;

	self.animname = "generic";
	self.grenadeWeapon = "smoke_grenade_american";
	self.grenadeAmmo++;
	self animscripts\shared::PutGunInHand("left");
	self thread maps\_anim::anim_single_solo(self, "nade_throw");
	wait 1.45;
	self MagicGrenade (self.origin + (0,0,50), goal.origin, 1.5);
	wait .9;

	self animscripts\shared::PutGunInHand("right");
	self.animname = self.oldanimname;
	self.grenadeWeapon = self.oldGrenadeWeapon;
	self.ignoreme = false;
}

ignoreme_timed(time,full_sight)
{
	// Actor will not get shot at or shoot for [time] seconds.
	self notify("new ignore");
	self endon("new ignore");
	self endon("death");

	self.ignoreme = true;
	if (!isdefined(full_sight))
	{
		old_maxsightdistsqrd = self.maxsightdistsqrd;
		self.maxsightdistsqrd = (4*4);
		self clearEnemyPassthrough();
		wait time;
		self.maxsightdistsqrd = old_maxsightdistsqrd;
	}
	else
		wait time;
	self.ignoreme = false;
}

set_follow_dists()
{
	if (self.classname ==  "actor_ally_ranger_wet_nrmdy_reg_garand" || self.classname == "actor_ally_ranger_wet_nrmdy_reg_BAR")
	{
		self.followmax = -2;
		self.followmin = -4;
		self.follow_delay = 2;
	}
	if (self.classname == "actor_ally_ranger_wet_nrmdy_randall" || self.classname == "actor_ally_ranger_wet_nrmdy_braeburn")
	{
		self.followmax = -2;
		self.followmin = -4;
		self.follow_delay = 0;
	}
	else
	{
		self.followmax = 2;
		self.followmin = -1;
		self.follow_delay = 0;
	}
}

friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;
	
	// Is this good values? We'll know soon enough.
	self.pathEnemyLookAhead = 256;
	self.pathEnemyFightDist = 512;

	if (level.friendlyMethod == "defend_area")
	{
		guy.friendlyWaypoint = false;
		area = undefined;
		specific = false;

		if (level.defend_area_lock)
			level waittill("defend_area_unlocked");
	
		aArea = array_randomize(level.defend_area);

		// find an area that need more ai.
		for (i=0; i < aArea.size; i++)
		{
			area = aArea[i];
			if (area.ai_in_area < int(area.script_noteworthy))
			{
				specific = true;
				break;
			}
		}

		// if all areas are full pick a random area to reinforce.
		if (!specific)
			area = aArea[randomint(aArea.size)];

		guy thread defend_area(area);
	}
	if (level.friendlyMethod == "friendly chains")
	{
		guy.friendlyWaypoint = false;
		guy set_follow_dists();
		guy setgoalentity (level.player);
	}
}

defend_area(node,max_delay)
{
	self notify("new defend area");
	self endon("new defend area");

	assert(isdefined(node.ai_in_area));
	node.ai_in_area++;

	if (isdefined(max_delay))
		wait randomfloat(max_delay)+0.1;
	if (!isalive(self))
	{
		node.ai_in_area--;
		return;
	}

	self thread ignoreme_timed(3);
	self setgoalnode(node);
	self.goalradius = node.radius;

	self waittill("death");
	node.ai_in_area--;
}

/***** utility *****/

disable_autosave()
{
	level.autosave_disabled++;
	level.savehere = false;
}

enable_autosave()
{
	level.autosave_disabled--;
	if (level.autosave_disabled <= 0)	
	{
		level.savehere = true;
		level.autosave_disabled = 0;
	}
}

objective_stopwatch(total_time, warning_time, num_warnings)
{
	wait_time = total_time-310;
	if (wait_time > 0)
		wait wait_time;
	level notify("stopwatch");
	wait 10;
	//total_time = 300 + randomint(15)+5;
	total_time = 302;

	// Setup the HUD display of the timer.
	level.stopwatch = 1;
	level.hudTimerIndex = 20;
	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
	level.timer.vertAlign = "top";
	level.timer.y = 100;
	level.timer.label = &"DUHOC_DEFEND_TIMER";

    if(level.xenon)
	{
		level.timer.x = -225;
		level.timer.fontScale = 2;
	}
	else
	{
		level.timer.fontScale = 1.6;    
		level.timer.x = -180;
	}

	level.timer setTimer(total_time);

	level thread music(total_time);

	wait total_time - warning_time;

	assert(isdefined(num_warnings));

	for (i=0; i < num_warnings; i++)
	{
		level notify("time warning " + (i));
		wait warning_time/num_warnings;
	}

	level.timer destroy();

	level notify("times up");
}

cliff_nosave()
{
	cliff_nosave = getent("cliff_nosave","targetname");

	while (true)
	{
		cliff_nosave waittill("trigger");
		disable_autosave();
		while(level.player istouching(cliff_nosave))
			wait .5;
		enable_autosave();
	}
}

cliff_fall_killplayer()
{
	cliff_fall_killplayer = getent("cliff_fall_killplayer","targetname");
	activator = getent(cliff_fall_killplayer.target,"targetname");
	
	activator waittill ("trigger");
	
	cliff_fall_killplayer waittill ("trigger");
	
	level.player enableHealthShield(false);
	level.player dodamage(level.player.health + 10, level.player.origin);
	level.player enableHealthShield(true);
	maps\_utility::missionFailedWrapper();
}

killcount(spawners,kills,mintime,timeout,notify_string)
{
	level endon(notify_string);

	mintime = gettime() + (mintime * 1000);

	counter = spawnstruct();
	counter.count = 0;
	counter.notify_string = notify_string;

	level thread killcount_timeout(notify_string,timeout);
	array_thread(spawners, ::killcount_spawn_wait, counter);

	while (true)
	{
		counter waittill("player kill");
		if (counter.count >= kills)
		{
			if (gettime() > mintime)
			{
				level notify(notify_string);
				break;
			}
		}
	}
}

killcount_timeout(notify_string,timeout)
{
	level endon(notify_string);
	if (isdefined(timeout))
	{
		time = int(timeout/3);
		wait time;
		level thread autoSaveByName("halftime");
		wait time;
		level thread autoSaveByName("halftime");
		wait time;
		level notify(notify_string);
	}
}

killcount_spawn_wait(counter)
{
	level endon(counter.notify_string);

	while (true)
	{
		self waittill("spawned",ai);
		if (spawn_failed(ai))
			continue;
		ai thread killcount_death_wait(counter);
	}
}

killcount_death_wait(counter)
{
	level endon(counter.notify_string);

	self waittill("death",ent);
	if (ent == level.player)
	{
		counter.count++;
		counter notify("player kill");
	}
}

setup_autofire_mg()
{
	mgs = getentarray("autofire_mg","script_noteworthy");
	level thread array_thread(mgs,::autofire_mg);
}

autofire_mg(targetname,tank)
{
	// run on any mg turret
	self endon("stop autofire");

	if (isdefined(tank))
		tank endon("death");

	if (isdefined(targetname))
		aBullseye = getentarray(targetname,"targetname");
	else
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

killplayer()
{
	level.player enableHealthShield( false );
	level.player doDamage (level.player.health, level.player.origin); //killplayer
	level.player enableHealthShield( true );
}

Dialogue_Thread(dialogue,node,override)
{
	self endon("death");

	if (!isdefined(override) && isdefined(level.dialogue_block) && level.dialogue_block)
		return;

	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	self setBattleChatter(false);

	if (isdefined(node))
	{
		self maps\_anim::anim_reach_solo(self, dialogue, undefined, node);
		self maps\_anim::anim_single_solo(self, dialogue, undefined, node);
	}
	else
		self maps\_anim::anim_single_solo(self, dialogue);

	self setBattleChatter(true);
	self.MyIsSpeaking = false;
	self notify ("my done speaking");
}

/***** vehicle *****/

attach_to_path(vnode)
{
	self.attachedpath = vnode;
	self.origin = vnode.origin;
	self attachpath (vnode);
	self notify ("onpath");
	self disconnectpaths();
	self thread maps\_vehicle::vehicle_paths();
}

tank_killarea(trigger_name,vis)
{
	self notify("termintate_killarea");
	self endon("termintate_killarea");
	self endon("death");

	trigger = getent(trigger_name,"targetname");

	while(true)
	{
		self clearturrettarget();
		trigger waittill("trigger");

		// stop autosaves
		disable_autosave();

		self setturrettargetent(level.player, (0,0,32));
		wait 3;
		if (level.player istouching(trigger))
		{
			if (isdefined(vis))
				self waittill("turret_on_vistarget");
			else
				self waittill("turret_on_target");

			if (level.player istouching(trigger))
			{
				self notify("turret_fire");
				waittillframeend;
				if (isalive(level.player))
				{
					maps\_shellshock::main(8,10,10,10);
					wait 6;
					if (level.player istouching(trigger))
					{
						self notify("turret_fire");
						wait .15;
						thread killplayer();
					}
				}
			}
		}
		enable_autosave();
		// level.savehere = true;
	}
}

setup_vehicle_pause()
{
	aVnode = getvehiclenodearray("pause","script_noteworthy");
	level array_thread (aVnode, ::vehicle_pause_node);
}

vehicle_pause_node()
{
	brush_trigger = undefined;

	if (isdefined(self.target))
	{
		aEnt = getentarray(self.target,"targetname");
		for (i=0; i < aEnt.size; i++)
		{
			if (aEnt[i].classname == "trigger_multiple")
			{
				brush_trigger = aEnt[i];
				brush_trigger thread vehicle_pause_trigger();
			}
		}
	}

	if (isdefined(self.script_waittill))
		self thread vehicle_pause_waittill();

	while(true)
	{
		self waittill("trigger",vehicle);

		vehicle endon("death");
		vehicle endon("disabled");

		if (isdefined(vehicle.node_action) && vehicle.node_action)
			vehicle waittill("node action done");

		vehicle.node_action = true;

		vehicle setspeed(0,10);
		pause_trigger = undefined;

		if (isdefined(self.radius))
		{
			trigger = spawn( "trigger_radius", vehicle.origin, 0, self.radius, 256);
			trigger waittill("trigger");
			trigger delete();
		}
		else if (isdefined(brush_trigger))
		{
			brush_trigger waittill("trigger");
		}

		if (isdefined(self.script_wait))
			wait self.script_wait;

		if (isdefined(self.script_waittill))
			level waittill(self.script_waittill);

		if (isalive(vehicle)  || isdefined(vehicle.vehicle_disabled))
			vehicle resumespeed(35);

		if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		{
			vehicle.node_action = false;
			vehicle notify("node action done");
		}
	}
}

vehicle_pause_trigger()
{
//	if (isdefined(brush_trigger.script_noteworthy))
//		level waittill(self.script_noteworthy);
	self waittill("trigger");
	waittillframeend;
	self delete();
}

vehicle_pause_waittill()
{
	level waittill(self.script_waittill);
	self.script_waittill = undefined;
}

setup_vehicle_deploy()
{
	aVnode = getvehiclenodearray("deploy","script_noteworthy");
	level array_thread (aVnode, ::vehicle_deploy_node);
}

vehicle_deploy_node()
{
	while(true)
	{
		self waittill("trigger",vehicle);
		vehicle setspeed(0,30);
		vehicle notify("unload");
		wait 10;
		vehicle resumespeed(3);
	}
}

setup_vehicle_fire()
{
	aVnode = getvehiclenodearray("fire","script_noteworthy");
	level array_thread (aVnode, ::vehicle_fire_node);
}

vehicle_fire_node()
{
	self waittill("trigger",vehicle);

	vehicle endon("death");
	vehicle endon("disabled");

	if (isdefined(vehicle.node_action) && vehicle.node_action)
		vehicle waittill("node action done");

	vehicle.node_action = true;
	vehicle.cycle_target = false;
	eTarget = undefined;
	aTarget = [];

	brush_trigger = undefined;

	if (isdefined(self.target))
	{
		aEnt = getentarray(self.target,"targetname");
		for (i=0; i < aEnt.size; i++)
		{
			if (aEnt[i].classname == "script_origin")
				aTarget[aTarget.size] = aEnt[i];
			else if (aEnt[i].classname == "trigger_multiple")
				brush_trigger = aEnt[i];
		}
	}

	stoped = false;
	if (isdefined(self.script_wait) || isdefined(self.radius) || isdefined(brush_trigger))
	{
		stoped = true;
		vehicle setspeed(0,10);
	}
	
	for (i=0; i < aTarget.size; i++)
	{
		eTarget = aTarget[i];

		badplace_cylinder("", 4, eTarget.origin, 256, 256, "allies", "axis");

		vehicle setturrettargetent(eTarget,(0,0,0));
		vehicle waittill("turret_on_target");

		if (isdefined(self.radius))
		{
			trigger = spawn( "trigger_radius", vehicle.origin, 0, self.radius, 256);
			trigger waittill("trigger");
			trigger delete();
		}
		if (isdefined(brush_trigger))
			brush_trigger waittill("trigger");

		vehicle notify("turret_fire");

		// do shellshock if player within 200 units of target.
		// make sure the target is close to where the shell will detonate.
		if (distance(level.player.origin, eTarget.origin) < 200)
			maps\_shellshock::main(8,30,30,10);

		if (isdefined(eTarget.script_exploder))
		{
			waittillframeend;
			level thread exploder(eTarget.script_exploder);
		}
		vehicle clearTurretTarget();

		if (isdefined(self.script_wait) && i < (aTarget.size-1) )
		{
			min_time = self.script_wait/2;
			wait min_time + randomfloat(min_time) + randomfloat(min_time);
		}
	}

	vehicle.cycle_target = true;

	if (isdefined(self.script_wait))
		wait self.script_wait;


	if (stoped && isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		vehicle resumespeed(35);

	if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
	{
		vehicle.node_action = false;
		vehicle notify("node action done");
	}
}

setup_vehicle_aim()
{
	aVnode = getvehiclenodearray("aim","script_noteworthy");
	level array_thread (aVnode, ::vehicle_aim_node);
}

vehicle_aim_node()
{
	while (true)
	{
		self waittill("trigger",vehicle);

		vehicle notify("turret aim");

		vehicle endon("death");
		vehicle endon("disabled");

		if (isdefined(vehicle.node_action) && vehicle.node_action)
			vehicle waittill("node action done");

		vehicle.node_action = true;
		vehicle.cycle_target = false;
		eTarget = undefined;
		brush_trigger = undefined;

		if (isdefined(self.target))
		{
			aEnt = getentarray(self.target,"targetname");
			for (i=0; i < aEnt.size; i++)
			{
				if (aEnt[i].classname == "script_origin")
					eTarget = aEnt[i];
				else if (aEnt[i].classname == "trigger_multiple")
					brush_trigger = aEnt[i];
			}
		}

		assert(isdefined(eTarget));

		vehicle.curr_target = eTarget;
		vehicle setturrettargetent(eTarget,(0,0,0));
		vehicle waittill("turret_on_target");

		if (isdefined(self.script_wait))
			wait self.script_wait;

		vehicle clearTurretTarget();
		vehicle.curr_target = undefined;
		vehicle.cycle_target = true;

		if (isalive(vehicle) || isdefined(vehicle.vehicle_disabled))
		{
			vehicle.node_action = false;
			vehicle notify("node action done");
		}
	}
}

cycle_tank_target()
{
	self endon("death");
	self endon("stop cycle");
	self.cycle_target = true;

	while(true)
	{
		if (self.cycle_target == false)
		{
			wait 1;
			continue;
		}
		ai = getaiarray("allies");
		if (isdefined(ai) && ai.size > 0 && randomint(2))
			target = ai[randomint(ai.size)];
		else
			target = level.player;

		iRnd = randomint(3)+1;

		for(i=0; i < iRnd; i++)
		{
			if (!isalive(target) || !self.cycle_target)
				break;

			value = randomint(96) + randomint(96) + randomint(96) - 144;
			offset = (value , value , 45);

			self setturrettargetent(target, offset);
			self waittill("turret_on_target");
			if (!self.cycle_target)
				break;
			self clearTurretTarget();
			wait (randomfloat(5) + 1) / iRnd;
		}
	}
}

music(total_time)
{
	wait (total_time - 6);	//6 is the lead-in time before the music hits the main peak
	musicplay("relief_happy_01");
}

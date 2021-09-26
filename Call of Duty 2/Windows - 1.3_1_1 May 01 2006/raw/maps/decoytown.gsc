/****************************************************************************

Level: 		Holding the Line
Campaign: 	British North Africa - Battle of El Alamein
Objectives: 	
		
		1. Hold the town until relieved by friendly forces. (6 minutes remaining)
		2. Use artillery strikes and stop the incoming tanks.
		3. Assemble at the rally point.
		
*****************************************************************************/

#include maps\_utility;
#using_animtree("generic_human");

main ()
{
	precacheitem("kar98k");
	precacheitem("mp40");
	level.smoke_grenade_weapon = "smoke_grenade_american_night";
	precacheitem(level.smoke_grenade_weapon );
	level.slackerplayer = false;
	panzerschrecks = getentarray("weapon_panzerschreck","classname");
	for(i=0;i<panzerschrecks.size;i++)
	{
		panzerschrecks[i] delete();
	}
	
	level.price_layernodes = [];
	nodes = getnodearray("pricenode","script_noteworthy");
	for(i=0;i<nodes.size;i++)
		level.price_layernodes[nodes[i].script_layer] = nodes[i];

	level.macgregor_layernodes = [];
	nodes = getnodearray("macgregornode","script_noteworthy");
	for(i=0;i<nodes.size;i++)
		level.macgregor_layernodes[nodes[i].script_layer] = nodes[i];
	
	nodes = undefined;

	firsttankever = getent("firsttankever","targetname");
	firsttankever thread firsttankever();
	
	level.tread_override_thread = ::tread;
	orgs = [];
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
	{
		if(isdefined(vehicles[i].targetname))
		{
			level thread mg_hack(vehicles[i].targetname);	
		}
	}
	precacheshellshock("pain");
	
	lights = getentarray("lights","targetname");
	for(i=0;i<lights.size;i++)
	{
		lights[i] setshadowhint("receiver");
	}
	type = "units";
	level.remind = [];
	level.remind[type] = [];
	level.remind[type]["south1"] = [];
	level.remind[type]["south1"][level.remind[type]["south1"].size] = "decoytown_pri_enemytosouth";
	level.remind[type]["south1"][level.remind[type]["south1"].size] = "decoytown_pri_moregermanunits";
	level.remind[type]["south1"][level.remind[type]["south1"].size] = "decoytown_bs4_southernapproach";
	level.remind[type]["west1"] = [];
	level.remind[type]["west1"][level.remind[type]["west1"].size] = "decoytown_pri_approachingwest";
	level.remind[type]["west1"][level.remind[type]["west1"].size] = "decoytown_bs2_breakwestflank";
	level.remind[type]["north1"] = [];
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_bs3_northwestcomeon";
	level.remind[type]["southwest1"] = [];
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_pri_southwestenemy";
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_pri_enemyreinforcements";
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_pri_morejerries";
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_bs3_swdontletthru";

	type = "tanks";
	level.remind[type] = [];
	level.remind[type]["south1"] = [];
	level.remind[type]["south1"][level.remind[type]["south1"].size] = "decoytown_bs4_tankstosouth";
	level.remind[type]["west1"] = [];
	level.remind[type]["west1"][level.remind[type]["west1"].size] = "decoytown_pri_jerrytankswest";
	level.remind[type]["west1"][level.remind[type]["west1"].size] = "decoytown_pri_tankstowest";
	level.remind[type]["north1"] = [];
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_pri_moreenemyarmor";
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "";
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_bs3_tankstonorthwest";
	level.remind[type]["southwest1"] = [];
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_bs2_tankstosouthwest";

	type = "onetank";
	level.remind[type] = [];
	level.remind[type]["south1"] = [];
	level.remind[type]["south1"][level.remind[type]["south1"].size] = "decoytown_bs3_onetanksouth";
	level.remind[type]["west1"] = [];
	level.remind[type]["west1"][level.remind[type]["west1"].size] = "decoytown_bs4_onetankwest";
	level.remind[type]["north1"] = [];
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_bs2_onetanknorthwest";
	level.remind[type]["southwest1"] = [];
	level.remind[type]["southwest1"][level.remind[type]["southwest1"].size] = "decoytown_bs2_onetanksouthwest";

	type = "getoffflak";
	level.remind[type]["north1"] = [];
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_bs3_defendnorthfoot";
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_mcg_forgetflak";
	level.remind[type]["north1"][level.remind[type]["north1"].size] = "decoytown_bs4_cantcovernorth";
	


	mg42s = getentarray("misc_turret","classname");
	for(i=0;i<mg42s.size;i++)
	{
		mg42s[i] thread mg42_badplaces();
		mg42s[i].script_fireondrones = true;
	}
	
	level thread maps\decoytown_amb::main();
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\_unicarrier::main("xmodel/vehicle_uni_carrier_yw");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii_brokentread");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_desert");
	maps\_vehicledroneai::main("xmodel/fx");
	maps\decoytown_fx::main();
	maps\_load::main();

//	thread hacktrigger();
	getvehiclenode("tank_die_afterabit","script_noteworthy") thread tank_die_afterabit();
	getent("centertown","targetname") thread trigger_centertown();
	level.houseblock = getent("houseblock","targetname");
	level.houseblock disconnectpaths();
	array_thread(getvehiclenodearray("deletegroup","script_noteworthy"),::deletegroup);
	array_thread(getentarray("misc_turret","classname"),::turret_pwner);
	setExpFog(0.000055, 0.00, .03 , 0.05, 0);
	maps\_artillery::main();
	maps\_artillery::DisableUse(); // enable the use of artillery
	maps\decoytown_anim::main();
	level.layers = [];
	level.layeredtriggers = [];
	level.is_availablevehicleenforcement = [];
	level.availablevehicleenforcement = [];
	level.dronepools = [];
	level.dronepool_spawners = [];
	level.layergotonodes = [];
	level.fadingai = 0;
	level.axiskilledbyplayer = 0;
	level.layergotonodes_que = [];
	level.defendzone = [];
	level.currentlayer = "south1";
	level.eventcondition_vehiclesremaining = 0;
	level.eventcondition_airemaining = 0;
	level.eventcondition_timeremaining = 0;
	level.player.threatbias = -50; // hack 
	
	flag_clear("music_artillery");
	
	thread music();
	
//	setsavedcvar("r_glow","1");
//	setsavedcvar("r_glowNEW","1");
//	setsavedcvar("r_glowkernalspread",".006");

	level.onroof = false;

	flag_clear("flak_dialog");
	flag_clear("remind_on");
	flag_clear("roof_dialog_delivered");
	flag_clear("artillery_ready");
	flag_clear("roof_nag_trigger_reached");
	flag_clear("flaks_blown");
	flag_clear("macgregor_radio_request");
	flag_clear("objective_on_the_roof");

	if(getcvar("debug_character_count") == "")
//		setcvar("debug_character_count","1");
		setcvar("debug_character_count","off");
	if(getcvar("debug_eventconditions") == "")
//		setcvar("debug_eventconditions","1");
		setcvar("debug_eventconditions","off");
	getvehiclenode("explosionnode","script_noteworthy") thread blowup_carrier();

	thread eventconditions_hud();
		
	level.retreat_nodes = [];	
	retreat_nodes = getvehiclenodearray("retreat_node","script_noteworthy");
	for(i=0;i<retreat_nodes.size;i++)
	{
		retreat_nodes[i].scriptOverride = true;
		retreat_nodes[i].scriptdetour_persist = true;
		assert(isdefined(retreat_nodes[i].script_layer));
		if(!isdefined(level.retreat_nodes[retreat_nodes[i].script_layer]))
			level.retreat_nodes[retreat_nodes[i].script_layer] = [];
		level.retreat_nodes[retreat_nodes[i].script_layer][level.retreat_nodes[retreat_nodes[i].script_layer].size] = retreat_nodes[i];
	}
		
	layergotonodes = getnodearray("layergoto","script_noteworthy");
	for(i=0;i<layergotonodes.size;i++)
	{
		assert(isdefined(layergotonodes[i].script_layer));
		if(!isdefined(level.layergotonodes[layergotonodes[i].script_layer]))
			level.layergotonodes[layergotonodes[i].script_layer] = [];
		level.layergotonodes[layergotonodes[i].script_layer][level.layergotonodes[layergotonodes[i].script_layer].size] = layergotonodes[i];
		 
	}
	level.layergotonodes_que = level.layergotonodes;

	togglenodes = getvehiclenodearray("toggle","script_noteworthy");
	for(i=0;i<togglenodes.size;i++)
		togglenodes[i].toggledetour = true;

	level.explodertriggers = [];

	damagetriggers = getentarray("trigger_damage","classname");
	for(i=0;i<damagetriggers.size;i++)
		if(isdefined(damagetriggers[i].script_exploder))
		{
			damagetriggers[i] thread explodertriggers_triggerremove();
			level.explodertriggers[level.explodertriggers.size] = damagetriggers[i];
			
		}
	
	triggers = array_combine(getentarray("trigger_multiple","classname"),getentarray("trigger_radius","classname"));
	for(i=0;i<triggers.size;i++)
	{
		if(isdefined(triggers[i].script_layer))
		{
			if(!isdefined(level.layeredtriggers[triggers[i].script_layer]))
			{
				level.layeredtriggers[triggers[i].script_layer] = [];
				level.layers[level.layers.size] = triggers[i].script_layer;
			}
			level.layeredtriggers[triggers[i].script_layer]
				[level.layeredtriggers[triggers[i].script_layer].size] = triggers[i];
			if(isdefined(triggers[i].targetname))
			{
			if(triggers[i].targetname == ("start_layer"))
				triggers[i] thread layer_start();
			if(triggers[i].targetname == ("defendzone"))
				level.defendzone[triggers[i].script_layer] = triggers[i];
				
			}
		}

		
	}
	
	for(i=0;i<level.layers.size;i++)
	{
		if(level.layers[i] != "south1")
			thread layer_off(level.layers[i]); 
	}
			
	level.panzerfaustguys = [];
			
	spawners = getspawnerarray();
	for(i=0;i<spawners.size;i++)
	{
		if(isdefined(spawners[i].script_noteworthy) && spawners[i].script_noteworthy == "panzerfaustguy")
		{
			assert(isdefined(spawners[i].script_layer));
			level.panzerfaustguys[spawners[i].script_layer] = spawners[i];
		}
	}
	level.smoke_lastthrown = gettime();	
	array_thread(getvehiclenodearray("originloopforabit","script_noteworthy"),::originloopforabit);
	array_levelthread(getentarray("smokethrowtrig","targetname"),::smokethrowtrig);
	array_levelthread(getvehiclenodearray("pathsuccess","script_noteworthy"),::pathsuccess);
	array_levelthread(getvehiclenodearray("godmodenode","script_noteworthy"),::godmodenode);
	array_levelthread( getspawnerarray(),::spawner_layer_handle);
	array_levelthread(getentarray("availablevehicleenforcement","targetname"),::availablevehicleenforcement);
	array_levelthread(getentarray("redrover","targetname"),::redrover);
	array_levelthread(getentarray("perimeter","targetname"),::perimeter);
	maketheflakdead = getent("maketheflakdead","targetname");
	maketheflakdead triggeroff();
	thread theflakisdead();
	thread playersride();
	thread ai_barneyfollow_org();
	thread allied_reinforcementtruck();

	thread objectives();
	level.enemies = 0;
	
	if(getcvar("start") == "start")
	{
	
		//////////////////
		//south attack 1//
		//////////////////
		thread autosavebyname("south attack");
		
		script_layer = "south1";
		thread price_and_macgergor_node_goto(script_layer);
		vehiclegroups = [];
		thread eventconditions_set(vehiclegroups,15,80,script_layer);
//		vehicles_spawnandgo(9);
		wait 15;	
		thread magic_ai_balancer(script_layer);
		if(!level.eventdone[script_layer])
			level waittill ("eventdone"+script_layer);		level notify ("newlayer");
		thread axis_fadefromeview();
		thread autosavebyname_wrapper("west attack");
		wait 3;
		while(getentarray("drone","targetname").size > 22)
			wait .1; // wait for drones to clear away before adding new drones..
	
		level notify ("objective_south_finished");
	
		//////////////////n
		//west attack 1//
		//////////////////
			array_thread(getaiarray("axis"),::ai_runandhide);

		script_layer = "west1";
		price_and_macgergor_node_goto(script_layer);

		layer_switch(script_layer);
		level thread dronepoolhandle(script_layer); 
//		vehicles_spawnandgo(3);
		vehiclegroups = [];
	//	vehiclegroups[vehiclegroups.size] = 3;	
	//	vehiclegroups[vehiclegroups.size] = 14;	
		thread eventconditions_set(vehiclegroups,15,50,script_layer);
		thread magic_ai_balancer(script_layer);
		wait 10;
//		vehicles_spawnandgo(14);
	
		
		if(!level.eventdone[script_layer])
			level waittill ("eventdone"+script_layer);
		level notify ("newlayer");
		thread autosavebyname_wrapper("South West attack");
		thread axis_fadefromeview();
	
		while(getentarray("script_vehicle","classname").size > 32)
			wait .1; // wait for drones to clear away before adding new drones..
		
		//////////////////
		//SouthWest attack//
		//////////////////
	
		level notify ("objective_west_finished");
	
		script_layer = "southwest1";
		price_and_macgergor_node_goto(script_layer);

		layer_switch(script_layer);
		level thread dronepoolhandle(script_layer); 
		vehiclegroups = [];
	//	vehiclegroups[vehiclegroups.size] = 17;
		thread eventconditions_set(vehiclegroups,15,45,script_layer);
		thread magic_ai_balancer(script_layer);
//		vehicles_spawnandgo(17);
		
		wait 20;
//		vehicles_spawnandgo(21);
		
		if(!level.eventdone[script_layer])
			level waittill ("eventdone"+script_layer);
		level notify ("newlayer");
		thread autosavebyname_wrapper("North flank attack");
		thread axis_fadefromeview();
		while(getentarray("script_vehicle","classname").size > 32)
			wait .1; // wait for drones to clear away before adding new drones..
	
	
	
		//////////////////
		//north1        //
		//////////////////
	
		level notify ("objective_southwest_finished");
	
		script_layer = "north1";
		price_and_macgergor_node_goto(script_layer);
		layer_switch(script_layer);
		level thread dronepoolhandle(script_layer); 
		vehiclegroups = [];
		thread eventconditions_set(vehiclegroups,15,80,script_layer,"override");
		thread magic_ai_balancer(script_layer);
		wait 20;
//		vehicles_spawnandgo(20);
		if(!level.eventdone[script_layer])
			level waittill ("eventdone"+script_layer);
		level notify ("newlayer");
		thread axis_fadefromeview();		
	}
	else
	{
		while(!isdefined(level.price))
			wait .1;
	}
	level.panzerfaustguys = [];
	maketheflakdead triggeron();
	battlechatteroff();
	thread maketheflakdead(maketheflakdead);
	if(getcvar("start") != "start")
	{
		maketheflakdead notify ("trigger");
		thread killgroup(9);
		thread killgroup(0);
		thread killgroup(3);
		thread killgroup(14);
		
		vehicles_spawnandgo(17);
		thread killgroup(17);
		
		thread killgroup(21);
		vehicles_spawnandgo(20);
		thread killgroup(20);
		
	}

	thread autosavebyname_wrapper("Second south attack");
	while(getentarray("script_vehicle","classname").size > 32)
		wait .1; // wait for drones to clear away before adding new drones..
	maketheflakdead notify ("trigger");
	//////////////////
	//wsouth 1 again//
	//////////////////

	level notify ("objective_north_finished");
	script_layer = "south1";

	doorKicker(level.price, getnode("doorkick_node","targetname"));
	thread autosavebyname_wrapper("door kicked");

	price_and_macgergor_node_goto("roof_"+script_layer);

	layer_switch(script_layer);
	level thread dronepoolhandle(script_layer); 
	vehiclegroups = [];
//	vehiclegroups[vehiclegroups.size] = 9;
	vehiclegroups[vehiclegroups.size] = 0;
	vehiclegroups[vehiclegroups.size] = 2;

//	if(getcvar("start") != "start")
//		vehicles_spawnandgo(9);

	//////////////////
	//get to the roof//
	///////////////////

	thread autosavebyname_wrapper("Get to the roof");
	rooftrigger = getent("roofnagger","targetname");
	thread roof_nagger();
	rooftrigger waittill ("trigger");
	flag_set("roof_nag_trigger_reached");
	flag_set("roof_dialog_delivered"); // dialog doesn't get delivered if player is on the roof already
	flag_set("artillery_ready");
	level battlechatteron();
	thread autosavebyname_wrapper("On the roof");
	wait 1;
	thread binoc_hints();
	flag_set("objective_on_the_roof");

	rooftrigger thread rooftrigger();
	
	
	vehicles_spawnandgo(2);
	thread eventconditions_set(vehiclegroups,0,30,script_layer);
	wait 5;
	if(!level.eventdone[script_layer])
		level waittill ("eventdone"+script_layer);
	level notify ("newlayer");
	thread axis_fadefromeview();
	thread autosavebyname_wrapper("Second South West attack 2");
	while(getentarray("script_vehicle","classname").size > 32)
		wait .1; // wait for drones to clear away before adding new drones..

	level notify ("objective_south_finished");

	//////////////////
	//SouthWest attack 2//
	//////////////////

	script_layer = "southwest1";
	price_and_macgergor_node_goto("roof_"+script_layer);

	layer_switch(script_layer);
	level thread dronepoolhandle(script_layer); 
	vehiclegroups = [];
//	vehiclegroups[vehiclegroups.size] = 17;
	vehiclegroups[vehiclegroups.size] = 24;
	vehicles_spawnandgo(24);
	thread eventconditions_set(vehiclegroups,0,32,script_layer);
	wait 10;
	thread killremainingtriggers(5);
	if(!level.eventdone[script_layer])
		level waittill ("eventdone"+script_layer);
	level notify ("newlayer");
	thread axis_fadefromeview();
	thread autosavebyname_wrapper("North attack 2");
	while(getentarray("script_vehicle","classname").size > 32)
		wait .1; // wait for drones to clear away before adding new drones..

	level notify ("objective_southwest_finished");


	//////////////////
	//north attack2//
	//////////////////

	script_layer = "north1";
	price_and_macgergor_node_goto("roof_"+script_layer);

	layer_switch(script_layer);
	level thread dronepoolhandle(script_layer); 
	vehiclegroups = [];
//	vehiclegroups[vehiclegroups.size] = 20;
	vehiclegroups[vehiclegroups.size] = 25;
	vehicles_spawnandgo(25);
	thread eventconditions_set(vehiclegroups,0,32,script_layer,"override");
	wait 10;
	thread killremainingtriggers();
	if(!level.eventdone[script_layer])
		level waittill ("eventdone"+script_layer);
	level notify ("newlayer");
	thread axis_fadefromeview();
	level notify ("the_ends");
	level thread ending_safeplayer();
	while(getentarray("script_vehicle","classname").size > 50)
		wait .1; // wait for drones to clear away before spawning the last group
	waitfordialog();
	
	vehicles_spawnandgo(26);
	timer = gettime()+25000;
	while(level.script_vehiclespawngroup[26].size && gettime()<timer)
		wait .1;
	level.macgregor dialog_add("decoytown_mcg_tellrommel");
	level.macgregor waittill ("que finished");
	level.macgregor.goalradius = 64;
	level.macgregor setgoalpos(level.barneyorg.origin);
	wait 2;
	level.macgregor dialog_add("decoytown_mcg_lastofthehuns");
	level.macgregor waittill ("que finished");
	level notify ("end_dialog");
}

axis_fadefromeview ()
{
	ai = getaiarray("axis");
	drones = getentarray("drone","targetname");
	array_thread(ai,::ai_fadefromview);
	array_thread(drones,::ai_fadefromview);  //testing.. also get rid of drones who are not in view.
}

ai_fadefromview_death ()
{
	self waittill ("death");
	level.fadingai--;
}

ai_fadefromview ()  // magically get rid of ai's who are in old zones.
{
	level.fadingai++;
	self thread ai_fadefromview_death();
	self endon ("death");
	timing = 3000;
	timer = gettime()+timing;
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
	if(self.classname == "script_model")
		self maps\_drones::drone_delete();
	else
		self delete();
}

availablevehicleenforcement (ent)
{
	assert(isdefined(ent.script_linkTo));
	assert(isdefined(ent.script_layer));
	links = strtok( ent.script_linkTo, " " );
	linkMap = [];
	for ( i = 0; i < links.size; i++ )
		linkMap[links[i]] = true;
	links = undefined;
	
	if(!isdefined(level.availablevehicleenforcement[ent.script_layer]))
		level.availablevehicleenforcement[ent.script_layer] = [];
	level.availablevehicleenforcement[ent.script_layer] = getlinks_array( level.layeredtriggers[ent.script_layer], linkMap );
	array_levelthread(level.availablevehicleenforcement[ent.script_layer],::availablevehicleenforcement_toggle);
}

pathsuccess (trigger)
{
	while(1)
	{
		trigger waittill ("trigger",other);
		vehiclegroup = other.script_vehiclespawngroup;
		other waittill ("death");
		wait randomfloat(5)+5;
		level.is_availablevehicleenforcement[vehiclegroup] = true;
	}
}

availablevehicleenforcement_toggle (trigger)
{
	level.is_availablevehicleenforcement[trigger.script_vehiclespawngroup] = true;
	while(1)
	{
		trigger waittill ("trigger");
		level.is_availablevehicleenforcement[trigger.script_vehiclespawngroup] = false;
	}
}

getplayersride ()
{
	level.playersride = maps\_vehicle::waittill_vehiclespawn("playersride");	
}

getprice ()
{
	price = getent("price","targetname");
	price.script_friendname = "Cpt. Price";
	price waittill ("spawned",other);
	level.price = other;
	level.price animscripts\shared::putguninhand("none");
	level.price.weapon = "bren";
	level.price animscripts\shared::putguninhand("right");

	level.price.script_usemg42 = false;
	level.price thread magic_bullet_shield();
//	level.price thread avoid_me_imdangerous();
	level.price thread death_failmission();

}

getmacgregor ()
{
	macgregor = getent("macgregor","targetname");
	macgregor.script_friendname = "Pvt. MacGregor";
	macgregor waittill ("spawned",other);
	level.macgregor = other;
	level.macgregor.requestintensity = 0;
	level.radioorg = spawn("script_origin",level.macgregor.origin+(0,0,44));
	level.radioorg linkto (level.macgregor);
	level.macgregor.script_usemg42 = false;
	level.macgregor thread magic_bullet_shield();
//	level.macgregor thread avoid_me_imdangerous();
	level.macgregor thread death_failmission();

}

intro_attack()
{
	wait 10;
	level.playersride notify ("attack");
}

playersride ()
{

	level.macgregor = undefined;
	level.playersride = undefined;
	level.price = undefined;
	level.player playergodon();

	level.player.ignoreme = true;
	playersride = undefined;
	targ = undefined;
	getoutpath = getent("getoutpath","targetname");
	thread getplayersride();
	thread getprice();
	thread getmacgregor();
	while(!isdefined(level.price) && !isdefined(level.macgregor) && !isdefined(level.playersride))
		wait .05;
	level.player allowprone(false);
	thread intro_attack();
	playersride = level.playersride;
	playersride thread godmode();
	waittillframeend;
	for(i=0;i<playersride.riders.size;i++)
	{
		playersride.riders[i].ignoreme = true;
	}
	level.player dontInterpolate();
	level.player playerlinktodelta (playersride,"tag_playerride", 1);
	level.player setplayerangles (playersride.angles);
	level thread battlechatteroff();
	level.price.dialogque = [];
	level.macgregor.dialogque = [];
	level.price.animname = "price";
	level.macgregor.animname = "macgregor";
	level.price thread dialog_handle();
	level.macgregor thread dialog_handle();
	thread ride_in_dialog();
	playersride waittill ("reached_end_node");
	level notify ("perimeter_enable");
	
	level.price dialog_add("decoytown_pri_krautmgsfiring");
	wait 2;
	

	level notify ("ride_in_finished");
	nextpath = getoutpath;
	level.player unlink();
	level.player linkto(getoutpath);
	if(isdefined(getoutpath.target))
		targ = getent(getoutpath.target,"targetname");
	while(isdefined(targ))
	{
		getoutpath moveto(targ.origin,.5,0,0);
		wait .7;
		if(isdefined(targ.target))
			targ = getent(targ.target,"targetname");
		else
			targ = undefined;
	}
	ai = getaiarray("allies");
	for(i=0;i<ai.size;i++)
	{
		ai[i].ignoreme = false;
	}
	level.player playergodoff();
	level.player unlink();
	level.player.ignoreme = false;
//	level.player setplayerangles((0,level.player.angles[1],0));
	
	ai_goto_layer();
	level.player allowprone(true);

	thread autosavebyname_wrapper("Entered town");
	
	while(level.price.dialogque.size)
		wait .05;
//	thread remind_dialog_usetheflak();

	playersride notify ("godoff");
	playersride.health = 200;
		
	soldier2 = getsoldier(2,2);	
	if(isdefined(soldier2))
		soldier2 dialog_add("decoytown_bs2_yessir");

	wait 1;
	while(level.price.dialogque.size)
		wait .05;
	level thread Battlechatteron();
	flag_set("remind_on");
	
}

ai_mg42_goto()
{
	self endon ("death");
	while(1)
	{
		self waittill ("stopped_use_turret");
		waittillframeend;
		thread ai_goto_layer_node(true);
	}
}



spawner_layer_handle (spawner)
{
	while(1)
	{
		spawner waittill ("spawned", spawn);
		if(spawn_failed(spawn))
			continue;
		if(spawn.team == "allies")
		{
			spawn thread ai_mg42_goto();
			if(isdefined(spawner.script_noteworthy) && spawner.script_noteworthy == "gotolayernode")
				spawn thread ai_goto_layer_node();
			if(isdefined(spawner.script_flak88))
				spawn thread ai_flak88_ignoreforabit();
		}
		if(spawn.team == "axis")
		{
			spawn.cower_pos = spawn.origin;
			spawn.grenadeammo+=2;
			spawn thread ai_axis_death();		
			
		}
	}
}

ai_barneyfollow_org ()
{
	level.barneyorg = spawn("script_origin",level.player.origin);
	level.barneyorg linkto (level.player);
}

ai_axis_death ()
{
	level.enemies++;
	if(isdefined(self.dronepool))
		self.dronepool.spawnercount++;
	thread damage_by_player();
	self waittill ("death",other);
	level.enemies--;
	if(isdefined(self.dronepool))
		self.dronepool.spawnercount--;
	if(isdefined(self.script_layer) && level.currentlayer == self.script_layer)
	{
		if(!isdefined(other))
			level notify ("axis death"+self.script_layer);
		else if(other == level.player || (other.classname == "script_vehicle" && other == level.playervehicle) || self.playerdiddamage)
		{
			level.axiskilledbyplayer++;
			level notify ("axis death by player"+self.script_layer);
			level notify ("axis death"+self.script_layer);
		}
		else
			level notify ("axis death"+self.script_layer);

	}
}

magic_ai_balancer(script_layer)
{
	level endon ("newlayer");
	wait 15;
	while(1)
	{
		level.slackerplayer = false;
		thread magic_ai_balancer_timer(script_layer);
		msg = level waittill_any("axis death by player"+script_layer,"magic_ai_balancer");
		if(msg =="magic_ai_balancer")
			thread magic_ai_balancer_killpeople(script_layer);
		level waittill ("axis death by player"+script_layer);
	}
}

magic_ai_balancer_killpeople(script_layer)
{
	mins = 6;
	maxs = 10;
	level.slackerplayer = true;;
	level endon ("newlayer");
	level notify("ai_balancer_killpeople");
	level endon("ai_balancer_killpeople");
	level endon ("axis death by player"+script_layer);
	while(1)
	{
		wait randomfloatrange(mins,maxs);
		ai = array_strip_magic_bullet(getaiarray("allies"));
		if(ai.size)
		{
			ai[randomint(ai.size)] thread ai_magic_snipe();
			if(mins>2)
				mins--;
			if(maxs>4)
				maxs--;
		}
	}
}

array_strip_magic_bullet(array)
{
	newarray = [];
	for(i=0;i<array.size;i++)
		if(!(isdefined(array[i].magic_bullet_shield) && array[i].magic_bullet_shield) && !isdefined(array[i].deathanim) && array[i] != level.price && array[i] != level.macgregor)
			newarray[newarray.size] = array[i];
	return newarray;
}

ai_magic_snipe()
{
	magicbullet("kar98k", self.origin+vectormultiply(anglestoforward(self.angles),2000)+(0,0,1200),self gettagorigin("J_Neck"));
}

magic_ai_balancer_timer(script_layer)
{
	level endon ("newlayer");
	level endon ("axis death by player"+script_layer);
	wait 10;
	level notify ("magic_ai_balancer");
	
}

damage_by_player()
{
	self endon ("death");
	self.playerdiddamage = false;
	while(1)
	{
		self waittill("damage",amount,attacker);
		if(attacker == level.player)
			self.playerdiddamage = true;
	}
}

dronepooltimeout (script_layer)
{
	level endon ("axis death"+script_layer);
	wait 5;
	level notify ("dronepooltimeout"+script_layer);
}

dronepoolhandle (script_layer)
{
	array_levelthread(getentarray("dronepool","script_noteworthy"),::dronepool,script_layer);
	level.currentlayer = script_layer;
	self endon ("stoplayer"+script_layer);
	level endon ("newlayer");
	maxenemies = 9;
	vehicletimer = gettime();
	while(1)
	{
		level thread dronepooltimeout(script_layer);
		wait 1;
//		level waittill_any ("axis death"+script_layer,"dronepooltimeout"+script_layer);
		if(level.enemies > maxenemies)
			continue;
		if(isdefined(level.availablevehicleenforcement[script_layer]) && gettime() > vehicletimer && level.enemies < maxenemies )
		{
			for(i=0;i<level.availablevehicleenforcement[script_layer].size;i++)
			{
				if(level.is_availablevehicleenforcement[level.availablevehicleenforcement[script_layer][i].script_vehiclespawngroup])
				{
					level.availablevehicleenforcement[script_layer][i] notify ("trigger");
					vehicletimer = gettime()+25000;
					break;
				}
			}
		}
		wait .5; //lets guys in vehicles spawn.
		if(level.enemies < maxenemies)
		{
			if(level.dronepool_spawners[script_layer].size)
			{
				spawnfailed = false;
				while(level.enemies < maxenemies && level.dronepool_spawners[script_layer].size && !spawnfailed)
				{
					spawn = level.dronepool_spawners[script_layer][0] stalingradspawn();
					level.dronepool_spawners[script_layer][0].count = 1;
					spawnfailed = spawn_failed(spawn);
//					if(!spawnfailed)
						level.dronepool_spawners[script_layer] = array_remove(level.dronepool_spawners[script_layer],level.dronepool_spawners[script_layer][0]);
					wait .1;
				}
			}
			lowest = 100;
			index = randomint(level.dronepools[script_layer].size);
			for(i=0;i<level.dronepools[script_layer].size;i++)
			{
				if(level.dronepools[script_layer][i].spawnercount < lowest)
				{
					lowest = level.dronepools[script_layer][i].spawnercount;
					index = i;
				}
			}

			dronepool = getent(level.dronepools[script_layer][index].targetname,"target"); 
			if(!isdefined(level.script_VehicleSpawngroup[dronepool.script_VehicleSpawngroup]) || !level.script_VehicleSpawngroup[dronepool.script_VehicleSpawngroup].size)
			{
				if(getentarray("script_vehicle","classname").size < 40)
					dronepool notify ("trigger");
			}
		}
	}
}

dronepool (trigger,script_layer)
{
	assert(isdefined(trigger.script_layer));
	if(trigger.script_layer != script_layer)
		return;
	level endon ("newlayer");	
	if(!isdefined(level.dronepools[trigger.script_layer]))
		level.dronepools[trigger.script_layer] = [];
	thread dronepool_clear(script_layer);
	level.dronepools[trigger.script_layer][level.dronepools[trigger.script_layer].size] = trigger;
	trigger.spawnercount = 0;
	trigger.targetspawners = getentarray(trigger.target,"targetname");
	
	for(i=0;i<trigger.targetspawners.size;i++)
	{
		trigger.targetspawners[i].dronepool = trigger;
		trigger.targetspawners[i].triggerUnlocked = true;
	}
	trigger thread dronepool_add();
}

dronepool_clear(script_layer)
{
	level waittill ("newlayer");
	level.dronepools[script_layer] = [];
}


dronepool_add ()
{
	self.cycleindex = 0;
	while(1)
	{
		if(!isdefined(level.dronepool_spawners[self.script_layer]))
			level.dronepool_spawners[self.script_layer] = [];
		self waittill ("trigger",other);
		if(other.vehicletype != "vehicledroneai")
			continue;
		other notify ("reached_end_node");
		level.dronepool_spawners[self.script_layer][level.dronepool_spawners[self.script_layer].size] = self.targetspawners[self.cycleindex];
		self.cycleindex++;
		if(self.cycleindex >= self.targetspawners.size)
		{
			self.targetspawners = array_randomize(self.targetspawners);
			self.cycleindex = 0;
		}
	}
}

layer_start () // only used once right now.
{
	self waittill ("trigger");
	assert(isdefined(self.script_layer));
	level thread dronepoolhandle(self.script_layer);
}

godmode ()
{
	self endon ("godoff");
	self endon ("death");
	while(1)
	{
		self.health = 3000;
		self waittill ("damage");
	}
}

redrover (trigger)
{
	level endon ("last_objective_done");
	playerseek = !isdefined(trigger.target);
	if(!playerseek)
		targetnodes = getnodearray(trigger.target,"targetname");
	else
		targetnodes = undefined;
	team = "axis";
	while(1)
	{
		touching = [];
		trigger waittill ("trigger",other);
		team = other.team;
		wait randomfloatrange(3.5,6);
		ai = getaiarray(team);
		for(i=0;i<ai.size;i++)
			if(ai[i] istouching (trigger) && ai[i] != level.price && ai[i] != level.macgregor)
				touching[touching.size] = ai[i];
		for(i=0;i<touching.size;i++)
		{
			if(playerseek)
			{
				touching[i].goalradius = 800;
				touching[i] setgoalentity (level.player);
				touching[i] thread playerSeekThink();
				continue;
			}
			touching[i] notify ( "stop_player_seek" );
			chosennode = targetnodes[randomint(targetnodes.size)];
			touching[i] setgoalnode (chosennode);
			touching[i].goalradius = chosennode.radius;
		}
		wait 1;
	}
}

playerSeekThink()
{
	self notify ( "stop_player_seek" );
	self endon ( "stop_player_seek" );
	self endon ( "death" );

	while ( true )
	{
		if ( self.goalradius > 200 )
			self.goalradius -= 200;

		wait ( 6 );
	}
}

ride_in_dialog ()
{
	wait 5.3;
	setsoldiers();
	soldier1 = getsoldier(1);	
	if(isdefined(soldier1))
		soldier1 dialog_add("decoytown_bs1_krautsalreadyhere");
//	soldier1 waittill ("que finished");
//	level.macgregor dialog_add("decoytown_mcg_didnthavetime");
//	level.macgregor waittill ("que finished");
	level waittill ("ride_in_finished");
	level.price dialog_add("decoytown_pri_takeuppositions");
}

getsoldier(index,timeout)
{
	struct = spawnstruct();
	if(isdefined(timeout))
	{
		struct thread getsoldier_timeout(timeout);
		struct endon ("timeout");
	}
	while(!isdefined(level.soldiers[index-1]))
		wait .1;
	struct notify ("found");
	return level.soldiers[index-1];
}

getsoldier_timeout(timeout)
{
	self endon ("found");
	wait timeout;
	self notify ("timeout");
}

getclosest_noanimname(amount,waittill_soldier_spawns)
{
	if(!isdefined(waittill_soldier_spawns))
		waittill_soldier_spawns = false;
	gotsoldiers = [];
	ai = getaiarray("allies");
	while(ai.size && gotsoldiers.size <amount)
	{
		nearest = getclosest(level.player.origin,ai);
		if(!waittill_soldier_spawns)
			assert(isdefined(nearest));
		else
		{
			if(!isdefined(nearest))
			{
				wait .1;
				ai = getaiarray("allies");
				continue;
			}
		}
		if(isdefined(nearest.animname))
		{
			ai = array_remove(ai,nearest);
			if(ai.size)
				continue;
			else
			{
				wait .1;
				ai = getaiarray("allies");
				continue;
			}
		}
		gotsoldiers[gotsoldiers.size] = nearest;
		ai = array_remove(ai,nearest);
	}
	return gotsoldiers;
}

setsoldiers ()
{
	gotsoldiers = getclosest_noanimname(4);
	for(i=0;i<gotsoldiers.size;i++)
	{
		level.soldiers[i] = gotsoldiers[i];
		level.soldiers[i] thread set_soldier(i);
	}
}

set_soldier(index)
{
	self.dialogque = [];
	self.animname = "soldier"+(index+1);
	self thread dialog_handle();
	self thread soldier_death_replace(index);
}

soldier_death_replace(index)
{
	self waittill ("death");
	gotsoldiers = undefined;
	while(!isdefined(gotsoldiers) || !gotsoldiers.size)
	{
		wait .05;
		gotsoldiers = getclosest_noanimname(1,true);
	}
		
	level.soldiers[index] = gotsoldiers[0];
	level.soldiers[index] thread set_soldier(index);
}

ai_goto_layer()
{
	array_thread(getaiarray("allies"),::ai_goto_layer_node);
}

layer_switch (script_layer)
{
	
	thread layer_off(level.currentlayer);
	level notify ("layer on",script_layer);
	level.currentlayer = script_layer;
	ai_goto_layer();
	if(isdefined(level.panzerfaustguys[script_layer]))
		level thread panzerguy(level.panzerfaustguys[script_layer]);
}


layer_off (script_layer)
{
	array_thread(getaiarray("axis"),::ai_runandhide);
	for(i=0;i<level.layeredtriggers[script_layer].size;i++)
		level.layeredtriggers[script_layer][i] triggeroff();
	for(i=0;i<level.retreat_nodes[script_layer].size;i++)
		level.retreat_nodes[script_layer][i].scriptOverride = false;
	level waittill ("layer on",script_layer);
	for(i=0;i<level.layeredtriggers[script_layer].size;i++)
		level.layeredtriggers[script_layer][i] triggeron();
	for(i=0;i<level.retreat_nodes[script_layer].size;i++)
		level.retreat_nodes[script_layer][i].scriptOverride = true;
	
}

ai_goto_layer_node(nowait)
{
	if(!level.layergotonodes_que[level.currentlayer].size)
		level.layergotonodes_que[level.currentlayer]	= level.layergotonodes[level.currentlayer];
	node = getClosest(self.origin,level.layergotonodes_que[level.currentlayer]);
	thread layer_goto_node(self,node,nowait);
	level.layergotonodes_que[level.currentlayer] = array_remove(level.layergotonodes_que[level.currentlayer],node);
}

layer_goto_node (guy,node,nowait)
{
	if(!isdefined(nowait))
		nowait = false;
	if(guy == level.price || guy == level.macgregor || (isdefined(guy.script_noteworthy) && guy.script_noteworthy == "panzerfaustguy"))
		return;
	guy endon ("death");
	while(level.fadingai > 0 && !nowait)
		wait .05;
	guy setgoalnode_thing(node);
}

eventconditions_set (vehicle_groups,ai_killcount,time,script_layer,overridetriggerzone)
{
	thread eventconditions_remind(script_layer);
	if(isdefined(level.defendzone[script_layer]) && !isdefined(overridetriggerzone))
		trigger = level.defendzone[script_layer];
	else
		trigger = undefined;
	
	level.eventdone[script_layer] = false;
	thing = spawnstruct();
	conditioncount = 3;
	thread eventconditions_time(thing,time);
	thread eventconditions_vehicleskilled(thing,vehicle_groups);
	thread eventconditions_aikilled(thing,ai_killcount,script_layer);
	level.eventconditionsmet = 0;
	for(i=0;i<conditioncount;i++)
	{
		thing waittill ("condition_met");
		
	}
	if(isdefined(trigger))
		while(!(level.player istouching (trigger)))
			wait .05;
	level.eventdone[script_layer] = true;
	level notify ("eventdone"+script_layer);
	thing notify ("eventdone");
	
}

eventconditions_aikilled (thing,ai_killcount,script_layer)
{
	level.eventcondition_airemaining = ai_killcount;
	while(level.axiskilledbyplayer < ai_killcount)
	{
		level waittill ("axis death by player"+script_layer);
		level.eventcondition_airemaining = ai_killcount-level.axiskilledbyplayer;
		
	}
	wait .1;
	thing notify ("condition_met");
	level.axiskilledbyplayer=0;
}

eventconditions_vehicleskilled (thing,vehicles)
{
	waittillframeend;
//	array_levelthread(vehicles,::eventconditions_vehicleskilled_death,thing);
	isinit = false;
	level.eventcondition_vehiclesremaining = vehicles.size;
	timer = gettime()+21000+randomint(3000);
	while(level.eventcondition_vehiclesremaining > 0)
	{
		if(!isinit)
		{
			for(i=0;i<vehicles.size;i++)
			{
				if(!isdefined(level.script_VehicleSpawngroup[vehicles[i]]))
				{
					isinit = false;
					break;
				}
				isinit = true;
			}
		}
		else
		{
			vehiclecount = 0;
			for(i=0;i<vehicles.size;i++)
			{
				vehiclecount+= level.script_VehicleSpawngroup[vehicles[i]].size;
			}
			level.eventcondition_vehiclesremaining = vehiclecount;
		}
		wait .1;
		if(gettime()>timer)
		{
			level notify ("vehicle remind");
			timer = gettime()+21000+randomint(4000);
		}		

	}
	wait .2;
	thing notify ("condition_met");
}

eventconditions_vehicleskilled_death (group,thing)
{
	waittillframeend;
	while(!isdefined(level.script_VehicleSpawngroup[group]))
		wait .1;
	while(level.script_VehicleSpawngroup[group].size)
		wait .1;		

	thing notify ("vehicle_killed");
}

eventconditions_time (thing,time)
{
	waittillframeend;
	level.eventcondition_timeremaining = time;
	while(level.eventcondition_timeremaining > 0)
	{
		wait 1;
		level.eventcondition_timeremaining--;
	}
	wait .3;
	thing notify ("condition_met");
}

eventconditions_hud ()
{
/*	if(!isdefined(level.currentlayer))
		level.currentlayer = "not specified";
	Event = newHudElem();
	Event.alignX = "right";
	Event.alignY = "middle";
	Event.x = 630;
	Event.y = 300;
//	Event.label = "Event Conditions: "+level.currentlayer;
	
*/	

	if(getcvar("debug_eventconditions") == "off")
		return;
	//vehicles killed
	vehicles_killed = newHudElem();
	vehicles_killed.alignX = "right";
	vehicles_killed.alignY = "middle";
	vehicles_killed.x = 630;
	vehicles_killed.y = 300;
	vehicles_killed.label = "vehicles remaining: ";
	
	//ai killed
	ai_killed = newHudElem();
	ai_killed.alignX = "right";
	ai_killed.alignY = "middle";
	ai_killed.x = 630;
	ai_killed.y = 315;
	ai_killed.label = "ai remaining: ";
	
	//time remaining	
	time_passed = newHudElem();
	time_passed.alignX = "right";
	time_passed.alignY = "middle";
	time_passed.x = 630;
	time_passed.y = 330;
	time_passed.label = "time remaining: ";

	vehicles_killed.alpha = 0;
	ai_killed.alpha = 0;
	time_passed.alpha = 0;
	while(getcvar("debug_eventconditions") == "off")
		wait .1;		
	vehicles_killed.alpha = 1;
	ai_killed.alpha = 1;
	time_passed.alpha = 1;
	
	while(1)
	{
		wait 0.05;
//		Event.label = "Event Conditions: "+level.currentlayer;
		vehicles_killed setValue( level.eventcondition_vehiclesremaining );
		ai_killed setValue( level.eventcondition_airemaining );
		time_passed setValue( level.eventcondition_timeremaining );
		
	}
}

vehicles_spawnandgo (group)
{
	vehicles = maps\_vehicle::scripted_spawn(group);
	array_levelthread(vehicles,maps\_vehicle ::gopath);
}

objective_vehicles (objective ,vehicles)
{
	isinit = false;
	while(1)
	{
		if(!isinit)
		{
			for(i=0;i<vehicles.size;i++)
			{
				if(!isdefined(level.script_VehicleSpawngroup[vehicles[i]]))
				{
					isinit = false;
					break;
				}
				isinit = true;
			}
		}
		else
		{
			vehiclecount = 0;
			for(i=0;i<vehicles.size;i++)
			{
				vehiclecount+= level.script_VehicleSpawngroup[vehicles[i]].size;
			}
			if(!vehiclecount)
				break;
		}
		wait .1;
	}
	objective_state(objective,"done");
}



objectives ()
{
	objective_south = 0;
	objective_west = 1;
	objective_southwest = 2;
	objective_north = 3;

	objective_roof = 4;

	objective_south2 = 5;
	objective_southwest2 = 6;
	objective_north2 = 7;
	objective_west2 = 8;
	
	if(getcvar("start") == "start")
	{
		level waittill ("introscreen_complete");
		wait 1;
		objective_add(objective_south, "active", &"DECOYTOWN_DEFEND_THE_SOUTH_SIDE", (2590, -4950, 78));
		objective_current(objective_south);
		level waittill ("objective_south_finished");
		vehiclegroups = [];
//		vehiclegroups[vehiclegroups.size] = 0;
//		vehiclegroups[vehiclegroups.size] = 9;
//		thread objective_vehicles(objective_south,vehiclegroups);
		objective_state(objective_south,"done");

		objective_add(objective_west, "active", &"DECOYTOWN_DEFEND_THE_WEST_SIDE", (705, -5388, 29));
		objective_current(objective_west);
		level waittill ("objective_west_finished");

//		vehiclegroups = [];
//		vehiclegroups[vehiclegroups.size] = 3;	
//		vehiclegroups[vehiclegroups.size] = 14;	
//		thread objective_vehicles(objective_west,vehiclegroups);
		objective_state(objective_west,"done");
	
		objective_add(objective_southwest, "active", &"DECOYTOWN_DEFEND_THE_SOUTH_WEST", (2262, -5371, 49));
		objective_current(objective_southwest);
		level waittill ("objective_southwest_finished");

//		vehiclegroups = [];
//		vehiclegroups[vehiclegroups.size] = 17;
//		thread objective_vehicles(objective_southwest,vehiclegroups);
		objective_state(objective_southwest,"done");
	
		objective_add(objective_north, "active", &"DECOYTOWN_DEFEND_THE_NORTH_SIDE", (4, -2906, 131));
		objective_current(objective_north);
		level waittill ("objective_north_finished");


//		vehiclegroups = [];
//		vehiclegroups[vehiclegroups.size] = 20;
//		thread objective_vehicles(objective_north,vehiclegroups);
		objective_state(objective_north,"done");
	}

	rooforg = (1792, -3968, 462);
	flag_wait("roof_dialog_delivered");
	objective_add(objective_roof, "active", &"DECOYTOWN_GET_A_BETTER_VANTAGE", (rooforg));
	objective_current(objective_roof);
	flag_wait("objective_on_the_roof");
	objective_state(objective_roof,"done");
	

	objstr = &"DECOYTOWN_DEFEND_THE_SOUTH_SIDE1";
	objdonestr = &"DECOYTOWN_DEFEND_THE_SOUTH_SIDE1DONE";
	endstr = "objective_south_finished";
	objective_add(objective_south2, "active", "", rooforg);
	thread objective_string_update_tankcount(objective_south2,objstr,endstr,objdonestr);
	objective_current(objective_south2);
	level waittill (endstr);
	objective_string(objective_south2,objstr,0);
	objective_state(objective_south2,"done");
	
	objstr = &"DECOYTOWN_DEFEND_THE_SOUTH_WEST1";
	objdonestr = &"DECOYTOWN_DEFEND_THE_SOUTH_WEST1DONE";
	endstr = "objective_southwest_finished";
	objective_add(objective_southwest2, "active", "", rooforg);
	thread objective_string_update_tankcount(objective_southwest2,objstr,endstr,objdonestr);
	objective_current(objective_southwest2);
	level waittill (endstr);
	objective_string(objective_southwest2,objstr,0);
	objective_state(objective_southwest2,"done");

	objstr = &"DECOYTOWN_DEFEND_THE_NORTH_SIDE1";
	objdonestr = &"DECOYTOWN_DEFEND_THE_NORTH_SIDE1DONE";
	endstr = "the_ends";
	objective_add(objective_north2, "active", "", rooforg);
	thread objective_string_update_tankcount(objective_north2,objstr,endstr,objdonestr);
	objective_current(objective_north2);
	level waittill (endstr);
	objective_string(objective_north2,objstr,0);
	objective_state(objective_north2,"done");

	maps\_artillery::DisableUse(); // enable the use of artillery
	level notify ("music_ending");
	level notify ("last_objective_done");
	
	level waittill ("end_dialog");
	
	wait 5;
	maps\_endmission::nextmission();

}

objective_string_update_tankcount(objective,string,endstr,string_finished)
{
	level endon (endstr);
	lastcount = 99;
	thread objective_string_update_tankcount_finished(objective,endstr,string_finished);
	while(1)
	{
		if(level.eventcondition_vehiclesremaining != lastcount)
		{
			if(level.eventcondition_vehiclesremaining)
				objective_string(objective,string,level.eventcondition_vehiclesremaining);
			lastcount = level.eventcondition_vehiclesremaining;
		}
		wait .05;
	}
}

objective_string_update_tankcount_finished(objective,endstr,string_finished)
{
	level waittill (endstr);
	wait 4;
	objective_string_nomessage(objective,string_finished);
}

get_speaker (dialog,timeout)
{
	if(isdefined(level.scrsound["price"][dialog]))
		return level.price;
	if(isdefined(level.scrsound["macgregor"][dialog]))
		return level.macgregor;
	for(i=0;i<4;i++)
		if(isdefined(level.scrsound["soldier"+(i+1)][dialog]))
			return getsoldier((i+1),timeout);
}

eventconditions_remind (script_layer)
{
	dialog["tanks"] = array_randomize(level.remind["tanks"][script_layer]);
	dialog["units"] = array_randomize(level.remind["units"][script_layer]);
	dialog["onetank"] = array_randomize(level.remind["onetank"][script_layer]);
	if(script_layer == "north1")
		dialog["getoffflak"] = array_randomize(level.remind["getoffflak"][script_layer]);
	level endon ("eventdone"+script_layer);

	flag_wait("remind_on");
	while(1)
	{
		type = "units";
		if(level.flag["artillery_ready"])
		for(i=0;i<level.tanks.size;i++)
		{
			if(level.tanks[i].script_team == "axis" && level.tanks[i] getvehicle_direction() == script_layer)
			{
				if(type == "onetank")
					type = "tanks";
				else
					type = "onetank"; 
			}
		}
		if(script_layer == "north1" && level.playeronvehicle)
			type = "getoffflak";
		thedialog = dialog[type][0];
		speaker = get_speaker(thedialog,2);
		if(!isdefined(speaker))
		{
			wait 1;
			continue;
		}
		if(speaker.dialogque.size)
		{
			wait 1;
			continue;
		}
		speaker dialog_add(thedialog);
		dialog[type] = array_remove(dialog[type],thedialog);
		if(!dialog[type].size)
			dialog[type] = array_randomize(level.remind[type][script_layer]);
		if(level.flag["artillery_ready"])
			wait randomfloatrange(10.0,20.0);
		else
			wait randomfloatrange(30,40);
	}
}

perimeter (trigger)
{
	level waittill ("perimeter_enable");
	trigger waittill ("trigger",other);
	thread playsoundinspace("weap_enfield_fire",level.player.origin+(0,0,100));
	level.player enablehealthshield(false);
	wait .05;
	magicbullet("kar98k", level.player.origin+vectormultiply(anglestoforward(level.player.angles),1000)+(0,0,1200),level.player geteye());
	wait .2;
	while(level.player.health > 0)
	{
		
		level.player dodamage(level.player.health+100,level.player.origin);
		wait .1;
	}
}

allied_reinforcementtruck ()
{
	wait 10;
	level.price endon ("death");
	level.macgregor endon ("death");
	while(1)
	{
		while(getaiarray("allies").size > 7 || level.slackerplayer)
			wait .2;
		vehicles_spawnandgo(22);
		while(level.price.dialogque.size)
			wait .1;
		wait 2;
//		level.price dialog_add("decoytown_pri_reinforcementseast");
		wait 10;

	}
}

dialog_needartillerysupport()
{
	if(level.flag["artillery_ready"])
	{
		wait .1;
		return;
		
	}
	level.price endon ("death");
	level.macgregor endon ("death");
	waitfordialog();

	if(level.macgregor.requestintensity == 0)
	{
		level.macgregor dialog_add("decoytown_mcg_canyoureadme");
		level.macgregor waittill ("que finished");
		return;
	}
	else if(level.macgregor.requestintensity == 1)
	{
		level.macgregor dialog_add("decoytown_mcg_wherearty");
		level.macgregor waittill ("que finished");
		radiosound("decoytown_brv2_workingonit");
		level.macgregor dialog_add("decoytown_mcg_nowgood");
		level.macgregor waittill ("que finished");
		radiosound("decoytown_brv2_almostinplace");
		return;
	}
	else if(level.macgregor.requestintensity == 2 && !level.flag["flaks_blown"])
	{
		level.macgregor dialog_add("decoytown_mcg_rallypointfox");
		level.macgregor waittill ("que finished");
		radiosound("decoytown_brv2_batteryoccupied");
		level.macgregor dialog_add("decoytown_mcg_timetoarty");
//		level.macgregor waittill ("que finished");
		level.macgregor dialog_add("decoytown_mcg_letjerriesthru");
		level.macgregor waittill ("que finished");
		radiosound("decoytown_brv2_preventkrauts");
		if(!level.flag["flaks_blown"])
		return;
	}
	waitfordialog();
	level.macgregor dialog_add("decoytown_mcg_queensix");
//	level.macgregor waittill ("que finished");
	level.macgregor dialog_add("decoytown_mcg_needartillerysupport");
	level.macgregor waittill ("que finished");	
	level notify ("artillery_request_finished");
	level waittill ("never");
}

waitfordialog()
{
	while(level.price.dialogque.size && level.macgregor.dialogque.size)
		wait .1;
}

remind_dialog_usetheflak ()
{
	level.price endon ("death");
	wait 5;
	while(level.macgregor.requestintensity != 2)
	{
		if(level.currentlayer == "north1" || level.playeronvehicle)
		{
			wait 1;
			continue;
		}
		dialog = "decoytown_pri_gettoflak";
		if(level.currentlayer == "west1" || level.eastflakblown)
		{
			dialog = "decoytown_pri_flakwest";
		}
		if(level.price.dialogque.size)
		{
			wait .1;
			continue;  //prevents price from queing up dialog and then telling the player to man the flak after as the northobjective happens
		}
		level.price dialog_add(dialog);
		wait(randomfloatrange(20.0,25.0));
	}
}

theflakisdead ()
{
	level.flag["reminded_dialog_needartillerysupport"] = false;
	level.theflak = getentarray("theflak","script_noteworthy");
	for(i=0;i<level.theflak.size;i++)
	{
		level.theflak[i].script_accuracy = .9;
		level.theflak[i].script_shootai = 1;
	}
	level.eastflakblown = false;
	thread remind_dialog_needartillerysupport();
	wait 1;
	level.price endon ("death");
	level.macgregor endon ("death");
	
	while(1)
	{
		blownflaks = true;
		for(i=0;i<level.theflak.size;i++)
		{
			if(level.theflak[i].health > 0)
				blownflaks = false;
			else
			{
				if(level.theflak[i].script_flak88 == "0")
					level.eastflakblown = true;
				level.macgregor.requestintensity = 1;
				
			}
		}
		if(blownflaks)
			break;
		wait .15;
	}
	level.macgregor.requestintensity = 2;
	
	wait 1;	
	
	waitfordialog();
	//soldier supposed to say something here.
	level.price dialog_add("decoytown_pri_checkstatusofgun");
	level.price waittill ("que finished");
	level.macgregor dialog_add("decoytown_mcg_alreadyonit");
	level.macgregor waittill ("que finished");
	flag_set("flak_dialog");

}

remind_dialog_needartillerysupport()
{
	level endon ("reminded_dialog_needartillerysupport");
	level waittill ("ride_in_finished");
	wait 10;
	level.price endon ("death");
	level.macgregor endon ("death");

	while(!level.flag["reminded_dialog_needartillerysupport"])
	{
		dialog_needartillerysupport();
		timer = gettime()+randomint(30000)+60000;
		while(gettime()<timer && !level.flag["flak_dialog"])
			wait .05;
	}
}

maketheflakdead (maketheflakdead)
{
	maketheflakdead waittill ("trigger");
	
	flakstoblow = [];
	for(i=0;i<level.theflak.size;i++)
		if(level.theflak[i].health > 0)
			flakstoblow[flakstoblow.size] = level.theflak[i];
	
	if(flakstoblow.size)
	{
		for(i=0;i<flakstoblow.size;i++)
			flakstoblow[i] notify ("death");
	}
	flag_set("flaks_blown");
	level waittill ("artillery_request_finished");
	flag_set("reminded_dialog_needartillerysupport");
	radiosound("decoytown_brv2_inluck");
	
	//enable artillery music loop when they're in luck
	flag_set("music_artillery");
	
	level.macgregor dialog_add("decoytown_mcg_boutbloodytime");
	level.macgregor waittill ("que finished");
	flag_set("macgregor_radio_request");
	maps\_artillery::SetRadioMan( level.macgregor );
	maps\_artillery::EnableUse(); // enable the use of artillery
	thread remind_player_about_artillery();
}	

remind_player_about_artillery()
{
	level.price endon ("death");
	level.macgregor endon ("death");
	level endon ("artillery_inprogress");
	while(1)
	{
		flag_wait("roof_nag_trigger_reached");
		level.price dialog_add("decoytown_pri_usebinoc");
		wait (randomfloatrange(12,16));
		level.macgregor dialog_add("decoytown_mcg_usebinoc");
		wait (randomfloatrange(12,16));
	}
}

roof_nagger()
{
	level.price endon ("death");
	level.macgregor endon ("death");
	level endon ("roof_nag_trigger_reached");
	wait (randomfloatrange(12,16));
	while(!level.flag["roof_nag_trigger_reached"])
	{
		waitfordialog();
		flag_wait("macgregor_radio_request");
		level.price dialog_add("decoytown_pri_rooftop");
		wait 2;
		flag_set("roof_dialog_delivered");
		wait (randomfloatrange(12,16));
	}
}	

godmodenode (node)
{
	node waittill ("trigger",other);
	other thread godmode();
}


panzerguy (panzerguyspawner)
{
	level endon ("newlayer");
	runtonode = getnode(panzerguyspawner.target,"targetname");
	while(!level.tanks.size)
		wait .05;
	while(1)
	{
		if(!level.tanks.size)
		{
			wait .05;
			continue;
		}
		panzerguyspawner.count = 1;
		guy = panzerguyspawner dospawn();
		if(spawn_failed(guy))
		{
			wait .05;
			continue;
		}
		guy.ignoreme = 1;
		guy.anim_disablePain = true;
		guy thread magic_bullet_shield();
		guy.takedamage = false;
		thetank = undefined;
		preferedtanks = [];
		for(i=0;i<level.tanks.size;i++)
		{
			if(isdefined(level.tanks[i].script_layer) && level.tanks[i].script_layer == level.currentlayer)
				preferedtanks[preferedtanks.size] = level.tanks[i];
		}
		if(!preferedtanks.size)
			thetank = getclosest(guy.origin,level.tanks);
		else
			thetank = getclosest(guy.origin,preferedtanks);
		level thread maps\_spawner::panzer_target(guy, runtonode, undefined, thetank, (0,0,40) );
		guy thread panzerguy_timeout();
		level thread panzerguy_return(guy,panzerguyspawner);
		guy waittill_any("panzer mission complete","panzer mission timeout");
		wait 15;	

	}
}

panzerguy_return(guy,panzerguyspawner)
{
	guy waittill_any("panzer mission complete","panzer mission timeout");
	guy.goalradius = 8;
	guy setgoalpos(panzerguyspawner.origin+(0,0,15));
	guy.goalradius = 8;
	guy waittill ("goal");
	guy delete();
}

panzerguy_timeout()
{
	self endon ("death");
	self endon ("panzer mission complete");
	wait 15;
	self notify ("panzer mission timeout");
}

killgroup(group)
{
	while(!isdefined(level.script_vehiclespawngroup[group]))
		wait .1;
	for(i=0;i<level.script_vehiclespawngroup[group].size;i++)
	{
		level.script_vehiclespawngroup[group][i] notify ("death");
	}
}

mg_hack(targetname)
{
	level waittill ("new vehicle spawned"+targetname,vehicle);
	
	vehicle endon ("death");
	waittillframeend;
	if(!isdefined(vehicle.mgturret))
		return;
	turrets = vehicle.mgturret;
	for(i=0;i<turrets.size;i++)
	{
		turrets[i].convergenceTime = 8;
//		turrets[i].suppressionTime = 3;
		turrets[i].accuracy = .7;
//		turrets[i].aiSpread = .5;
//		turrets[i].playerSpread = level.mg42settings[difficulty]["playerSpread"];	
	}
}

radiosound(sound)
{
//	if(isdefined(level.tmpmsg[sound]))
//		iprintln(level.tmpmsg[sound]);
	level.radioorg playsound (sound,"sounddone");
	level.radioorg waittill ("sounddone");

}

getvehicle_direction()
{
	switch(self.script_vehiclespawngroup)
	{
		case 0:
		case 9:
		case 2:
		case 8:
		return "south1";
		case 24:
		case 17:
		return "southwest1";
		case 14:
		case 3:
		case 23:
		return "west1";
		case 20:
		case 21:
		case 25:
		case 26:
		return "north1";
	}
}

waittill_dialog_empty()
{
	while(self.dialogque.size)
		wait .1;
}
	
runawayfrom_carrier()
{
	self waittill("trigger",other);
	badplace_cylinder("carrier", 3, other.origin, 1500, 500, "axis");
}

blowup_carrier()
{
	runawaynode = getvehiclenode(self.targetname,"target");
	runawaynode thread runawayfrom_carrier();
	self waittill ("trigger",other);
	playfxontag(level._effect["carrier_blowup"],other,"tag_wheel_front_right");
	thread playsoundinspace("explo_metal_rand",other gettagorigin("tag_wheel_front_right"));
	other joltbody((other.origin + (23,33,64)),3);
	level.player shellshock("pain", 2.5);
	earthquake(1.5,2.3,other.origin,5000);
}

rooftrigger()  //makes people fire at player less
{
	level.onroof = false;
	level.price endon ("death");
	level.macgregor endon ("death");
	touching = false;
	while(1)
	{
		if(level.player istouching(self))
		{
			if(!touching)
			{
				if(!isdefined(level.player.oldthreatbias))
					level.player.oldthreatbias = level.player.threatbias;
				level.player.threatbias = -4000;
				if(!isdefined(level.macgregor.oldthreatbias))
					level.macgregor.oldthreatbias = level.macgregor.threatbias;
				level.macgregor.threatbias = -4000;
				if(!isdefined(level.price.oldthreatbias))
					level.price.oldthreatbias = level.price.threatbias;
				level.price.threatbias = -4000;
				touching = true;
				level.onroof = true;
				flag_clear("playerontheroof");
			}
		}
		else
		{
			if(touching)
			{
				assert(isdefined(level.player.oldthreatbias));
				assert(isdefined(level.macgregor.oldthreatbias));
				assert(isdefined(level.price.oldthreatbias));
				level.player.threatbias = level.player.oldthreatbias;
				level.player.oldthreatbias = false;
				level.macgregor.threatbias = level.macgregor.oldthreatbias;
				level.macgregor.oldthreatbias = false;
				level.price.threatbias = level.price.oldthreatbias;
				level.price.oldthreatbias = false;
				touching = false;
				level.onroof = false;
				flag_set("playerontheroof");
			}
		}
		wait .1;
	}
}

originloopforabit()
{
	self waittill ("trigger",other);
	other endon ("death");
	other maps\_vehicle::vehicle_setspeed(0,20,"attacking originloopforabit");
	wait 7;
	other.originque = [];
	other notify ("attacking origins");  // oi this is getting ugly
	other.attackingtroops = false;	//sets flag of not attacking troops
	other.turretonvistarg = false;
	wait randomfloatrange(13,23);
	other maps\_vehicle::script_resumespeed("attacking originloopforabit done",15);
}

ending_safeplayer()
{
	level.ai_victorywait = 4;
	array_thread(getaiarray("allies"),::ai_dovictory);
	axis = getaiarray("axis");
	array_thread(axis,::ai_runandhide);
	array_thread(axis,::ai_end_snipe);
	for(i=0;i<level.script_VehicleSpawngroup[25].size;i++)
		level.script_VehicleSpawngroup[25][i].script_turretmg = false;
//	level.player.ignoreme = true;
	level.price allowedstances("stand");
	level.macgregor allowedstances("stand");	
}

ai_runandhide()
{
	if(!isdefined(self.cower_pos))
		return;
	self endon ("death");
	self.goalradius = 8;
	self setgoalpos(self.cower_pos);
	self waittill ("goal");
	while(self cansee(level.player))
		wait .1;
	self delete();	
}

ai_dovictory()
{
	waittime = level.ai_victorywait;
	level.ai_victorywait+= randomfloatrange(.3,.6);
	self endon ("death");
	self.ignoreme = true;
	wait waittime;
	while(1)
	{
		animation = %decoy_town_cheer_crouch;
		if(self.anim_pose == "crouch")
			animation = %decoy_town_cheer_crouch;
		else if(self.anim_pose == "stand")
			animation = %decoy_town_cheer_stand;
		if(isdefined(self.enemy))
			self animscripted("cheering", self.origin, flat_angle(vectortoangles(self.enemy.origin-self.origin)), animation);
		else
			self animscripted("cheering", self.origin, self.angles, animation);
		self waittillmatch("cheering","end");
		wait (randomfloatrange(5,10));
	}
}

tread (tagname, side, relativeOffset)  //special decoytown tread thread
{
	self endon ("death");
	treadfx = maps\_treads::treadget(self, side);
	wait .1;
	self.tuningvalue = 300;
	for (;;)
	{
		speed = self getspeed();
		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue);
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.3)
			waitTime = 0.3;
		wait waitTime;
		lastfx = treadfx;
		treadfx = maps\_treads::treadget(self, side);
		if(treadfx != lastfx)
			self notify ("treadtypechanged");
		if(treadfx != -1)
		{
			ang = self getTagAngles(tagname);
			forwardVec = anglestoforward(ang);
			rightVec = anglestoright(ang);
			upVec = anglestoup(ang);
			effectOrigin = self getTagOrigin(tagname);
			effectOrigin += vectorMultiply(forwardVec, relativeOffset[0]);
			effectOrigin += vectorMultiply(rightVec, relativeOffset[1]);
			effectOrigin += vectorMultiply(upVec, relativeOffset[2]);
			forwardVec = vectorMultiply(forwardVec, waitTime);
			playfx (treadfx, effectOrigin, (0,0,0) - forwardVec);
		}
	}
}

firsttankever()
{
	getvehiclenode(self.target,"targetname") waittill ("trigger",other);
	orgorg = other.origin;
	other endon ("death");
	other waittill ("reached_end_node");
	offset = other.origin-orgorg;
	self.origin+=offset;
	printcount = 3;
	while(printcount)
	{
		self waittill ("damage",ammount,attacker);
		if(ammount>500 || attacker != level.player)
			continue;
		iprintlnbold(&"DECOYTOWN_TANKS_CAN_NOT_BE_HURT");
		printcount--;
		wait 8;
	}
}

price_and_macgergor_node_goto(layer)
{
	while(!isdefined(level.price) && !isdefined(level.macgregor))
		wait .1;
	level.price setgoalnode_thing(level.price_layernodes[layer]);
	level.macgregor setgoalnode_thing(level.macgregor_layernodes[layer]);
}

setgoalnode_thing(node)
{
	if(isdefined(node.radius) && node.radius != 0)
		self.goalradius = node.radius;
	else
		self.goalradius = 128;
	self setgoalnode(node);
}

music()
{
	musicplay("british_decoytown_intro");

	flag_wait("music_artillery");
	
	thread music_loop("british_action_artillery");
	
	level waittill("incoming_shell_start");	//notified from _artillery.gsc
	wait 1.6;
	musicstop();	//cut off just before the first ever player-activated artillery strike hits 
	
	level waittill ("music_ending");
	
	wait 12;
	
	musicplay("british_decoytown_victory");
}

music_loop(musicAlias)
{
	level endon ("incoming_shell_start");
	while(1)
	{
		musicplay(musicAlias);
		wait 26;
	}
}

smokethrowtrig (trigger)
{
	node = getnode(trigger.target,"targetname");
	nodetarg = getent(node.target,"targetname");
	node.smoke_lastthrown = gettime();
	while(1)
	{
		trigger waittill ("trigger",other);
		if (!isalive(other))
			continue;
		if (isdefined(other.deathanim)) // deathanim is set on halftrack guys.
			continue;
		if (gettime() - node.smoke_lastthrown < 45000)
			continue;
			
		node.smoke_lastthrown = gettime();
		level.smoke_thrown["smoke" + nodetarg.origin] = undefined;
		node throwSmoke (node.origin + (0,0,40), other);
	}
}

throwSmoke(origin, ai)
{	
	org = getent (self.target,"targetname").origin;
	if (!isdefined(ai.oldGrenadeWeapon))
		ai.oldGrenadeWeapon = ai.grenadeWeapon;
		
	ai.grenadeWeapon = level.smoke_grenade_weapon;
	ai.grenadeAmmo++;
	
	ai MagicGrenade (origin + (0,0,50), org, 2.5);
	ai.grenadeWeapon = ai.oldGrenadeWeapon;
}


turret_pwner()
{
	level endon ("the_ends");
	while(1)
	{
		wait randomfloat(12,20);
		turretpwner = self getturretowner();
		if(isdefined(turretpwner) && issentient(turretpwner) && turretpwner != level.player)
			magicbullet("kar98k", turretpwner.origin+vectormultiply(anglestoforward(turretpwner.angles),2000)+(0,0,1200),turretpwner gettagorigin("J_Neck"));
		wait 1;
		while(!isdefined(self getturretowner()))
			wait .5;
			
	}
}

binoc_hints()
{
	//keyHintPrint(&"SCRIPT_PLATFORM_HINTSTR_BINOCULAR", getKeyBinding("+binoculars"));
	hint(&"SCRIPT_PLATFORM_HINTSTR_BINOCULAR");
	level.player waittill ("binocular_enter");
	if(getcvar ("xenonGame") == "true")
	{
		keyHintPrint(&"PLATFORM_WHILE_LOOKING_THROUGH", getKeyBinding("+usereload"));

	}
	else
	{
		keyHintPrint(&"PLATFORM_WHILE_LOOKING_THROUGH", getKeyBinding("+activate"));		
	}
}

bindingGen(binding, key)
{
	bind = spawnstruct();
	bind.name = binding;
	bind.key = key;
	bind.binding = getKeyBinding( binding )[key];
	return bind;
}

hint(string)
{
	wait 1;
	while(level.script == "libya" && !flag("initial_hints_finished"))
		level.playervehicle waittill ("turret_fire");
	if(level.script == "88ridge")
		level.playervehicle waittill ("turret_fire");
		
	wait .5;

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
		
	iprintlnbold( string, bind.binding );
//	keyHintPrint(&"PLATFORM_TANK_BINOCULARS",bind.binding);

}
ai_flak88_ignoreforabit()
{
	self endon ("death");
	self.ignoreme = true;
	wait 50;
	self.ignoreme = false;
}

deletegroup()
{
	while(1)
	{
		self waittill ("trigger",other);
		other delete();
	}
}

avoid_me_imdangerous()
{
	self endon ("death");
	wait 2;
	while(1)
	{
		radius = 300;
		badplace_cylinder(self.animname, 1, self.origin, radius, 500, "axis");
		wait .1;
	}
}



death_failmission()
{
	self waittill ("death");
	setCvar( "ui_deadquote", &"DECOYTOWN_FAILED_TO_DEFEND_THE" );
	maps\_utility::missionFailedWrapper();
}

trigger_centertown()
{
	level endon ("the_ends");
	wait 3;
	level.price endon ("death");
	level.macgregor endon ("death");
	timer = gettime();
	touching = false;
	other = undefined;
	while(1)
	{
		ai =getaiarray("axis");
		for(i=0;i<ai.size;i++)
			if(ai[i] istouching(self))
			{
				touching = true;
				other = ai[i];
			}
		if(!touching || level.onroof)
		{
			if(!isdefined(level.price.magic_bullet_shield))
				level.price thread magic_bullet_shield();
			if(!isdefined(level.macgregor.magic_bullet_shield))
				level.macgregor thread magic_bullet_shield();
			self waittill ("trigger",other);
			timer = gettime()+5000;
				
		}
		ai_breached_centertown(other,timer);
		touching = false;
	}
}


ai_breached_centertown(other,timer)
{
	level endon ("the_ends");
	while(isalive(other) && other istouching(self) && gettime()<timer && !level.onroof )
		wait .1;
	if(!isalive(other) || level.onroof)
	{
		wait .1;
		return;
	}
	level.price notify ("stop magic bullet shield");
	level.macgregor notify ("stop magic bullet shield");
	while(isalive(other) && other istouching(self) && !level.onroof)
		wait .1;
	wait .1;
}

tank_die_afterabit()
{
	self waittill ("trigger",other);
	other endon("death");
	wait 30;
	other notify ("death");
}

ai_end_snipe()
{
	self endon ("death");
	wait randomfloatrange(1,3);
	self ai_magic_snipe();
}

killremainingtriggers(ammount)
{
	level endon ("newlayer");
	level endon ("the_ends");
	thetrigger = undefined;
	if(isdefined(ammount))
		countto = ammount;
	else
		countto = level.explodertriggers.size;
	count = 0;
	while(level.explodertriggers.size)
	{
		potentials = [];
		for(i=0;i<level.explodertriggers.size;i++)
			if(distance(level.explodertriggers[i] getorigin(),level.player.origin) > 800)
				potentials[potentials.size] = level.explodertriggers[i];
		thetrigger = getHighestDot(level.player.origin, level.player.origin+anglestoforward(level.player.angles), potentials);
		if(!isdefined(thetrigger))
		{
			wait 1;
			continue;
		}
		count++;
		if(count>countto)
			break;
		thetrigger notify ("trigger");
		wait randomfloatrange(2,6);
	}
}


explodertriggers_triggerremove()
{
	self waittill ("trigger");
	level.explodertriggers = array_remove(level.explodertriggers,self);
}

autosavebyname_wrapper(name)
{
	timer = gettime()+155000;
	while(timer>gettime())
	{
		if(isdefined(level.price.magic_bullet_shield) && isdefined(level.macgregor.magic_bullet_shield))
		{
			autosavebyname(name);	
			break;			
		}
		wait .1;
	}
}

hacktrigger() //kills players trying to get on the roof
{
//	trigger = spawn( "trigger_radius", (156,-3263, 223), 0, 128, 500);
//	org1 = (157,-3248, 223);
//	org2 = (278, -3760, 548);
//	trigger = script_trigger(org1,org2);
//	thread perimeter(trigger );
}

mg42_badplaces()
{
	durration = .3;
	while(1)
	{
		turretowner = self getturretowner();
		while(self isfiringturret() || (isdefined(turretowner) && turretowner == level.player && level.player attackbuttonpressed()))
		{
			badplace_arc("", durration, self.origin+(0,0,45), 2000, 300,anglestoforward( self gettagangles ("tag_flash")), 15, 15,"allies","axis");
			wait durration;		
		}
		wait .2;
	}
	
}

doorKicker(guy, node)
{
	guy.goalradius = 4;
		
	guy setgoalnode(node);
	guy notify ("stop friendly think");
	guy.anim_node = node;
	guy waittill ("goal");
	
	level thread maps\_anim::anim_single_solo(guy, "fh_kickdoor",undefined,node);
	
	//kick open the door
	fh_door = level.houseblock;
	
	guy waittillmatch ("single anim", "soundfx = kickdoor");
	
	fh_door playsound ("wood_door_kick");
	fh_door rotateyaw(-110,.3,.1,.1);
	
	level notify ("door_is_open");
	
	guy notify ("stop magic bullet shield");
	
	wait .5;
	
	fh_door connectpaths();

			
}	
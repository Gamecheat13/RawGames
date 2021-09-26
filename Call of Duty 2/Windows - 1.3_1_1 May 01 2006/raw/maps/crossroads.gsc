/****************************
Objectives:
1. Secure the town crossroads - main objective
2. Destroy communication outpost 
3. Destroy the tiger tank


***old - could change*** 
2. Secure the farm house
3. Secure the barn
4. Fight off the German counter attack
5. Return to friendly lines
******************************/

#include maps\_utility;
#include maps\_anim;



main()
{
	
	//jumpto
	if (getcvar("jumpto") == "")
    	setcvar("jumpto", "");
    	
  
 	
  level.jumptoBarn = false;
  
  if (!isdefined(getcvar ("jumpto")))
	 	setcvar ("jumpto", "null");
	else if((getcvar ("jumpto") == "barn"))
		level.jumptoBarn = true;

		
		  	
	level.campaign = "british";
	maps\_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tiger::main("xmodel/vehicle_tiger_woodland_brush");
	maps\_truck::main("xmodel/vehicle_opel_blitz_woodland");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");
	maps\_tankai::main();
	maps\_tankai_tiger::main("xmodel/vehicle_tiger_woodland");
	maps\_tankai_tiger::main("xmodel/vehicle_tiger_woodland_brush");
	
	maps\_unicarrier::main("xmodel/vehicle_uni_carrier_gr_mud");
	

	//*** Load External Scripts
 	level thread maps\crossroads_amb::main();
	maps\crossroads_fx::main();
	maps\_load::main();
	maps\crossroads_anim::main();
	

	//precache
	precacheModel("xmodel/vehicle_spitfire_flying");
	precacheModel("xmodel/prop_stuka_bomb");
	precacheModel("xmodel/military_german_radio1_green_d");
	precacheModel("xmodel/military_german_radio2_green_d");
	precacheModel("xmodel/military_german_fieldradio_green_d");
	level.smoke_grenade_weapon = "smoke_grenade_american_night";
	


	
	//strings
	precacheString(&"CROSSROADS_OBJ_SECURE_CROSSROADS");
	precacheString(&"CROSSROADS_OBJ_DESTORY_TIGER");
	precacheString(&"CROSSROADS_OBJ_REGROUP");
	precacheString(&"CROSSROADS_OBJ_FARMHOUSE");
	precacheString(&"CROSSROADS_OBJ_BARN");
	precacheString(&"CROSSROADS_OBJ_RADIO");
	precacheString(&"CROSSROADS_OBJ_REPULSE");
	precacheString(&"CROSSROADS_OBJ_REPULSE6");
	precacheString(&"CROSSROADS_OBJ_REPULSE_2");
	precacheString(&"CROSSROADS_OBJ_CONVOY");
	
	precacheString(&"CROSSROADS_PLATFORM_HINT_RADIO");
	
	
	
	precacheitem("stuka_guns");

	precacheShellshock("default");
	
	// Backdrop
	if (getcvar("r_fullbright") != "1")
	{
		backdrop = spawn("script_model", (0,0,0) );
		backdrop.modelscale = 0.7;
		backdrop setmodel("xmodel/backdrop_newvillers_card");
		backdrop2 = spawn("script_model", (0,0,0) );
		backdrop2.modelscale = 0.3;
		backdrop2 setmodel("xmodel/backdrop_newvillers_trees");
	}
	

	//this is used for counting the germans that spawn in the house so when it reaches zero it completes an objective
	level.farmhouseGermans = 0;
	
	//this is used to setup dialogue for when all the germans during the half track encounter are dead
	level.halftrack_germans = 0;
	
	//this is used to count how many germans are alive that are attacking the barn
	level.barn_wave_germans = 0;
	
	//this is used for the counter attack during the first half track encounter
	level.ht_germans = 0;
	
	//for the counter attack objective
	level.wavesRemaining = 6;
	
	level.barnAI = 0;
	
	
	//flags
	level.flag["ambush_started"] = false;
	level.flag["radios_destroyed"] = false;
	level.flag["farmHouse_secure"] = false;
	level.flag["barn_secure"] = false;
	level.flag["counter_attack_over"] = false;
	level.flag["ht_german_waves_done"] = false;
	level.flag["ht_germans_escaping"] = false;
	
	
	//Cpt price
	level.price = getent ("price", "script_noteworthy");
	level.price thread maps\_utility::magic_bullet_shield();
	level.price.animname = "price";
	
	
	//fog
	if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
		setCullFog (0, 6500, .37, .41, .42, 0);
		
	if (getcvar("r_rendererInUse") == "dx9")
 		setCullFog (0, 6500, .37, .41, .42, 0);
	
	//FIXME - commented out as a test for plane
//	setCullDist (6000);


	// Set some cvars
	setsavedcvar("r_specularColorScale", "18");
	setsavedcvar("r_cosinePowerMapShift", "-.17");
	
	//threads
	if (level.jumptoBarn == false)
	{
		
	
		thread objective_master();
		
		//first encounter - house ambush
		thread germanEncounter_One();
		
		//this disables the mg42 untill the windows of the house are open
		thread farmhouse_mg42();
	
		//initial friendly chain setup
		thread friendlyChain_master();
	
		//start the intro dialogue
		thread intro_dialogue();
		
		//germans running from one house to another
		thread german_runners();
		
		//communication outpost tank
		thread CommTank();
		thread commTank_destruction();
		
		//thread the barn roof stuff
		thread barn_roof();
		
		//max friendlys
		level.maxfriendlies = 5;
		
		//
		thread CommRadio();
		thread convoy();
		
	}
		
	//respawning pazerschrecks

	level thread panzerschrecks();
	
	
	
	//jumpto barn stuff
	if (level.jumptoBarn == true)
	{
		level.player setorigin ((2072, 4416, 8));
		
		setupFriendlyChain();
		
//		open the gate
		farmhouse_gate = getent ("farmhouse_gate", "targetname");
		farmhouse_gate rotateyaw(90,.5,.2,.2);
		farmhouse_gate connectpaths();
		
		thread stopRain();
		thread barn_encounter();
		thread barn_roof();
		thread reinforcement2();
		thread CommRadio();
		thread convoy();
		
	
		
		chain7 = get_friendly_chain_node ("400");
		level.player SetFriendlyChain (chain7);
		
		
		
		
	}
	
	
}

intro_dialogue()
{

	allies = getaiarray ("allies");
	
	for (i=0;i<allies.size;i++)
	{	
		allies[i].oldgoalradius = allies[i].goalradius;
		allies[i].goalradius = 2;
	//	allies[i].interval = 2;
	}
	
	//makes a couple of allies run in front of the window to look cool
	thread window_runners();
	

	price_node = getnode ("price_intro_node", "targetname");
	
	price_node anim_reach_solo (level.price, "intro");
	price_node  thread anim_single_solo(level.price, "intro");
	
	wait 7;
	price_node anim_reach_solo (level.price, "wave2run");
	price_node anim_single_solo(level.price, "wave2run");
	
	level.price putOnFriendlyChain();
	
	thread cornerSignal();
	
	wait 1;
	
	//thread autoSaveByName ("intro_dialogue_done");


	for (i=0;i<allies.size;i++)
		allies[i].goalradius = allies[i].oldgoalradius;
	

}

window_runners()
{
	window_runners = getentarray ("window_runner", "script_noteworthy");
	
	wait 4;
	
	for (i=0;i<window_runners.size;i++)
		window_runners[i] putOnFriendlyChain();
	
}	
		


friendlyChain_master()
{
	//turn the friendly chains off
	maps\_utility::chain_off ("50");
	maps\_utility::chain_off ("75");
	maps\_utility::chain_off ("100");
	maps\_utility::chain_off ("200");
	maps\_utility::chain_off ("225");
	maps\_utility::chain_off ("250");
	maps\_utility::chain_off ("300");
	maps\_utility::chain_off ("350");
	maps\_utility::chain_off ("400");
	maps\_utility::chain_off ("500");
	
	
	//first chain
	chain0 = get_friendly_chain_node ("50");
	level.player SetFriendlyChain (chain0);
	level notify ("allies_on_chain");
	
	chain0a = get_friendly_chain_node ("75");
	level waittill ("corner_wave_done");
	level.player SetFriendlyChain (chain0a);
	
	level waittill ("player_returned_to_price");
	
	mg42_chain2 = get_friendly_chain_node("100");
	level.player SetFriendlyChain (mg42_chain2);
	
	level waittill_any ("garage_mg42_gunner_died","halftrack_encounter_started");
	
	//this chain is so the friendly stop at the post office untill the garage mg42 is dead
	chain2 = get_friendly_chain_node ("200");
	level.player SetFriendlyChain (chain2);
	
	//this is for the chain after the half tracks are destoryed and the germans attack for a bit then run away.
	level waittill ("halftrack_encounter_over");
	chain3 = get_friendly_chain_node ("225");
	level.player SetFriendlyChain (chain3);
	
	//turn off triggers
	first_trigger = getentarray ("first_trip_chain_trigger", "targetname");
	
	for (i=0;i<first_trigger.size;i++)
		first_trigger[i] triggerOff();
	
	
	level waittill ("add_farmhouse_objective");
	chain4 = get_friendly_chain_node ("250");
	level.player SetFriendlyChain (chain4);
	
	level waittill ("farmhouse_gate_open");
	chain5 = get_friendly_chain_node ("300");
	level.player SetFriendlyChain (chain5);
	
	//for the fight outside of the barn
	flag_wait ("farmHouse_secure");
	//level waittill ("germans_outside_of_barn");
	chain6 = get_friendly_chain_node ("350");
	level.player SetFriendlyChain (chain6);
	
	//send friendlys into the barn
	flag_wait ("barn_secure");
	chain7 = get_friendly_chain_node ("400");
	level.player SetFriendlyChain (chain7);
	
	level waittill ("last_friendly_chain");
	endChain = get_friendly_chain_node ("500");
	level.player SetFriendlyChain (endChain);
	
	
}


objective_master()
{
	//1st objective - Secure the town crossroads
	compass_crossroads = getent ("compass_crossroads", "targetname");
	objective_add(0, "active", &"CROSSROADS_OBJ_SECURE_CROSSROADS", compass_crossroads.origin);
	objective_current (0);
	
	//2nd objective Destroy the tiger tank
	
	level waittill ("add_tank_objective");
	

//	compass_commtank = getent ("compass_commtank", "targetname");
	
	compass_panzer = getent ("compass_panzers", "targetname");
	
	objective_add(1, "active", &"CROSSROADS_OBJ_DESTORY_TIGER", compass_panzer.origin);
	objective_current (1);
	
	level waittill ("Comm_Tank_destroyed");
	
	objective_state (1, "done");
	
	//3rd objective - Regroup with Cpt Price
	
	compass_regroup = getent ("compass_regroup", "targetname");
	objective_add(2, "active", &"CROSSROADS_OBJ_REGROUP", compass_regroup.origin);
	objective_current (2);
	
	level waittill ("player_returned_to_price");
	
	objective_state (2, "done");
	
	objective_current (0);
	
	level waittill ("crossroads_reached");
	
	objective_state (0, "done");
	
	//2nd objective - Secure the farm house
	
	level waittill ("add_farmhouse_objective");
	
	compass_farmhouse = getent ("compass_farmhouse", "targetname");
	objective_add(3, "active", &"CROSSROADS_OBJ_FARMHOUSE", compass_farmhouse.origin);
	objective_current (3);
	
	flag_wait ("farmHouse_secure");
	
	objective_state (3, "done");
	
	//3rd objective - Secure the barn
	compass_barn = getent ("compass_barn", "targetname");
	
	objective_add(4, "active", &"CROSSROADS_OBJ_BARN", compass_barn.origin);
	objective_current (4);
	
	flag_wait ("barn_secure");
	
	thread reinforcement2();
	
	objective_state (4, "done");
	
	//4th objective - Destroy the radio equipment
	compass_radios = getent ("compass_commoutpost", "targetname");
	
	
	objective_add(5, "active", &"CROSSROADS_OBJ_RADIO", compass_radios.origin);
	objective_current (5);
	
	flag_wait ("radios_destroyed");
	
	objective_state (5, "done");
	
	
	//5th objective - Fight off the German counter attack
	compass_gOfficer = getent ("compass_barn", "targetname");
	
	objective_add(6, "active",&"CROSSROADS_OBJ_REPULSE6", compass_barn.origin);

	objective_current (6);
	
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE", level.wavesRemaining);
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE", level.wavesRemaining);
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE", level.wavesRemaining);
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE", level.wavesRemaining);
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE", level.wavesRemaining);
	
	level waittill ("barn_german_wave_is_dead");
	wait .05;
	objective_string(6, &"CROSSROADS_OBJ_REPULSE_2");
	
	flag_wait ("counter_attack_over");
	
	objective_state (6, "done");
	
	//5th objective - Escort the convoy to safety.
	compass_start = getent ("compass_start", "targetname");
	
	objective_add(7, "active", &"CROSSROADS_OBJ_CONVOY", compass_start.origin);
	objective_current (7);
	

	level waittill ("convoy_reached");
	
//	wait 2;
	
	objective_state (7, "done");
	
//	wait 4;
	
	wait 1;
	 
	//END THE LEVEL
	maps\_endmission::nextmission();
	
}


setupFriendlyChain()
{
//	eTrigger = getent ("friendlychain_trigger", "targetname");
//	eTrigger waittill ("trigger");
	
	level maps\_utility::array_thread (getaiarray ("allies"), ::putOnFriendlyChain);
}


//setup the friendly chain
putOnFriendlyChain()
{
	self.followmax = 4;
	self.followmin = -4;
	self setgoalentity (level.player);
	
}
	
cornerSignal()
{
	
	guy = getent ("corner_guy", "script_noteworthy");
	corner_node = getnode ("corner_signal", "targetname");
	
	//wall stackers
	stacker1 = getent ("intro_wall_stacker1", "script_noteworthy");
	stacker2 = getent ("intro_wall_stacker2", "script_noteworthy");
	
	stacker1_node = getnode ("intro_wall_stacker1_node", "targetname");
	stacker2_node = getnode ("intro_wall_stacker2_node", "targetname");

	stacker1.goalradius = 4;
	stacker2.goalradius = 4;
	
	stacker1 setgoalnode (stacker1_node);
	stacker2 setgoalnode (stacker2_node);


	guy.animname = "generic";

	corner_node anim_reach_solo (guy, "signal_left");
	
	eTrigger = getent ("player_left_start_building", "targetname");
	eTrigger waittill ("trigger");
	
	//BS4: Careful lads! There's an MG42 at the end of this road!
	guy thread anim_single_solo (guy, "recon");

	//waving animation
	corner_node thread anim_single_solo (guy, "signal_left");
	
	wait 1.5;
	stacker1 putOnFriendlyChain();
	
	level notify ("corner_wave_done");

	wait 1;
	stacker2 putOnFriendlyChain();
	
	wait 2;
	

	setupFriendlyChain();


}
		
//First encounter with germans in a building
//This is the ambush house
germanEncounter_One()
{
	thread mg42Guys_One();
	
	//set this to one if the player runs in the house before the ambush
	level.abortAmbush = 0;
	
	ambush_override_trigger = getent ("ambush_override", "targetname");
	thread AmbushOverride(ambush_override_trigger);
	
	eTrigger = getent ("encounter1_trigger", "targetname");
	
	thread ambushTrigger(eTrigger);
	
	level waittill ("e1_spawn_ai");
	
	//eTrigger waittill ("trigger");
	
	//goal volume node
	goalnode = getnode ("e1_goalvol_node", "script_noteworthy");
	
	if (level.abortAmbush == 0)
		wait 3;
			
	non_window_spawners = getentarray ("first_encounter_spawner", "targetname");
	
	for (i=0;i<non_window_spawners.size;i++)
		non_window_spawners[i] thread germanEncounter_One_think(goalnode); 
	
	
	
	//opening the windows 
	guy01 = getent ("window_guy_01", "script_noteworthy");
	guy02 = getent ("window_guy_02", "script_noteworthy");
	guy03 = getent ("window_guy_03", "script_noteworthy");
	
	e1_window01_node = getnode ("e1_window01_node", "targetname");
	e1_window02_node = getnode ("e1_window02_node", "targetname");
	e1_window03_node = getnode ("e1_window03_node", "targetname");
	
	e1_window01_right = getent ("e1_window01_right", "targetname");
	e1_window01_left = getent ("e1_window01_left", "targetname");
	
	e1_window02_right = getent ("e1_window02_right", "targetname");
	e1_window02_left = getent ("e1_window02_left", "targetname");
	
	e1_window03_right = getent ("e1_window03_right", "targetname");
	e1_window03_left = getent ("e1_window03_left", "targetname");
	

	//spawns the guy in the destoryed house across from the first mg42
	thread germansLeftFlank();
	
	if (level.abortAmbush == 0)
	{	
		level.flag["ambush_started"] = true;
		
		guy01 thread e1_OpenWindows(guy01, e1_window01_node, goalnode, e1_window01_left, e1_window01_right);
		guy02 thread e1_OpenWindows(guy02, e1_window02_node, goalnode, e1_window02_left, e1_window02_right);
		guy03 thread e1_OpenWindows(guy03, e1_window03_node, goalnode, e1_window03_left, e1_window03_right);
		
		level waittill ("e1_window_is_open");
	
		wait 1;
	
		battleChatterOff( "allies" );
		
		level.price.animname = ("soldier1");
		level.price anim_single_solo(level.price, "ambush");
		level.price.animname = ("price");
		
		wait 1;
		
		level.price anim_single_solo (level.price, "secure_ambush");
		
		battleChatterOn( "allies" );
	}
	else
	{
		guy01 thread germanEncounter_One_think(goalnode);
		guy02 thread germanEncounter_One_think(goalnode);
		guy03 thread germanEncounter_One_think(goalnode);
	}
	 	

			
}

ambushTrigger(trigger)
{
	//this is the trigger in front the wall the mg42 is firing at
	trigger waittill ("trigger");
	level notify ("e1_spawn_ai");
}


AmbushOverride(trigger)
{
	//this is the trigger inside the house
	trigger waittill ("trigger");
	
	//flag
	if (level.flag["ambush_started"] == false)
	{	
		level.abortAmbush = 1;
		level notify ("e1_spawn_ai");
	}		
		
	
}

e1_OpenWindows(guy, window_node, goal_node, window_left, window_right)
{
	
	spawn = guy dospawn();
	
	if (spawn_failed (spawn))
	{	
		return;
	}
	
	spawn endon ("death");
	
	spawn.oldgoalradius = spawn.goalradius;
	spawn.goalradius = 4;
	
	spawn setgoalnode (window_node);
	spawn waittill ("goal");
	
	
	level notify ("e1_window_is_open");
	
	spawn.goalradius = spawn.oldgoalradius;
	
	window_left rotateyaw (-130, .5,.4,0);
	window_right rotateyaw (130, .5,.4,0);	
	
	wait 5;
	spawn setgoalnode (goal_node);
	
	//if the player doesn't clear out the house he will get rolled on.
	wait 10;
	spawn setgoalentity (level.player);
	
	
}

germanEncounter_One_think(goalnode)
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn))
	{
		return;
	}
	
	spawn endon ("death");

	spawn setgoalnode (goalnode);	
	
	wait 10;
	
	//roll on the player if he takes too long
	spawn setgoalentity (level.player);
	
}	

//these guys are in the destroyed house in front of the first mg42
germansLeftFlank()
{
	spawners = getentarray ("germans_first_mg42_leftflank", "targetname");
	
	//spawn germans
	for (i=0;i<spawners.size;i++)
		spawners[i] dospawn();
	
}
	
	
// First set of mg42 guys
// This is the communications outpost
mg42Guys_One()
{
	//Get the spawners in an array 
	spawners = getentarray ("mg42_guys1", "targetname");
	mg42_gunner = getent ("mg42_guys1_gunner", "targetname");
	
	mg42_gunner thread mg42_gunner1_think();
		
	array_thread (getentarray ("mg42_guys1", "targetname"), ::mg42guys_one_think);
		
}

mg42guys_one_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
		
	spawn endon ("death");
	
	level waittill ("halftrack_encounter_started");
	
	//roll on the player if he tries to run past
	spawn setgoalentity (level.player);		
}


mg42_gunner1_think()
{
	spawn = self dospawn();
	if (spawn_failed (spawn))
	{	
		level notify ("first_mg42_gunner_died");
		return;
	}
	
	spawn waittill ("death");
	level notify ("first_mg42_gunner_died");
}

/*
mg42_controller(aeTargetSet, eTurret, spawner)
{
	while (isalive (spawner))
	{
		eMG42_user = eTurret getturretowner();
		
		if(isalive (eMG42_user))
		{
			if (!isdefined (eMG42_user.enemy))
			{
				println (eMG42_user.origin, " has no AI enemy, using targets");
				eTurret settargetentity (aeTargetSet[randomint (aeTargetSet.size)]);
				wait randomint((4 + 2));
			}
				
		}
		wait (2);
		
	}
}		
*/



destroyedRadioFX()
{
	maps\_utility::exploder(5);
	maps\_fx::loopfx("radio_sparks_smoke", (758,2630,75), 1.5, (748,2630,175));
	maps\_fx::loopfx("radio_sparks_smoke", (760,2658,71), 1.5, (750,2658,171));
}


//send in some reinforcements when the player is inside the Comm Outpost
StartReinforcements()
{	
	maxallies = 5;
	allied_spawners = getentarray ("reinforcements_start", "targetname");
		
	alive_allies = getaiarray ("allies");
		
	spawn_spots = (maxallies - alive_allies.size);
		
	if (spawn_spots <= 0)
		println ("Debug: Not sending any reinforcements");
	else
		println ("Debug: Sending in " +spawn_spots +" reinforcements");	
		
	//spawn the AI
	for (i=0;i<spawn_spots;i++)
		allied_spawners[i] thread StartReinforcements_think();
		

		
}

StartReinforcements_think()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed (spawn))
	{
		return;
	}
	
	spawn endon ("death");
	spawn thread putOnFriendlyChain();

}

//Bring in the tank when the player is on the road
CommTank()
{
	thread commTank_riders();
		
	level.commTank = maps\_vehicle::waittill_vehiclespawn("tank_comm");
	
	wait .05;
	level.commTank.script_attackai = 0;
	level.commTank.allowUnloadIfAttacked = false;
	
	//bring in some reinforcements for the player
	thread StartReinforcements();
	
	//figure out which node price should go to
	thread PricePathHint();
	
	wait .05;
	level notify ("commtank_spawned");
	
	thread autoSaveByName ("player_inside_CommOutpost");
	

	level.commTank.oldHealth = level.commTank.health;
	level.commTank.health = 100000;
		
	thread commTank_mg_controller();
	
	waitnode = getvehiclenode ("commtank_wait", "script_noteworthy");
	
	level.commtank setwaitnode (waitnode);
	
	level.commtank waittill("reached_wait_node");
	
	thread commTank_dialouge();
	
	wait .05;
	level notify ("commTank_is_ready_to_shoot");
		
	wait .05;
	level notify ("add_tank_objective");
	
	level waittill ("tank_destroyed_path_wall");
	level.commTank.health = level.commTank.oldHealth;
	

	level.commTank.script_attackai = 1;
	
	level.commTank waittill ("death");
	
//	Send in some reinforcements to assualt the next part	
	thread StartReinforcements();
	
	level notify ("Comm_Tank_destroyed");
	
	wait 1;
	
	thread autoSaveByName ("CommTank_destroyed");
	
}

commTank_riders()
{
	level waittill ("commTank_is_ready_to_shoot");
	
	wait 3.5;
	
	level.commTank.allowUnloadIfAttacked = true;
	
	
}


commTank_dialouge()
{
	//get the closest ai to the player, but not price
	level.price.team = "neutral";
	
	closestAI = maps\_utility::getClosestAI (level.player getorigin(), "allies" );
	
	level.price.team = "allies";
	
	
	

	battlechatterOff ("allies");
	
	if (isalive (closestAI))
	{
		closestAI.animname = "generic";
		closestAI anim_single_solo (closestAI, "bloody_hell");
	}
	
	wait 1;
	
	//Price: Sergeant Davis!!! Find an anti-tank weapon and take out that tank! Go!
	level.price anim_single_solo (level.price, "find_antitank");
	
	battlechatterOn ("allies");
	
}
	

commTank_mg_controller()
{
	
	targets = getentarray ("commTank_mg_target", "targetname");
	
//for (i=0;i<targets.size;i++)
	
	while (isalive (level.commTank))
	{
		
		if(isalive (level.commTank))
		{
			if (!isdefined (level.commTank.mgturret[0].enemy))
			{
				println ("Tank MG has no AI enemy, using targets");
				level.commTank.mgturret[0] settargetentity (targets[randomint (targets.size)]);
				wait randomint((4 + 2));
			}
				
		}
		wait (2);
		
	}
}	


panzerschrecks()
{
	//get the panzers already placed.
	temp_panzer1 = getent ("panzer1", "targetname");
	
	temp_panzer2 = getent ("panzer2", "targetname");
	
	
	//get their origins
	panzer1_org = temp_panzer1 getorigin();
	
	panzer2_org = temp_panzer1 getorigin();
	
	//get their angles
	panzer1_angles = temp_panzer1.angles;
	
	panzer2_angles = temp_panzer1.angles;
	
	
	//delete the second panzer
	temp_panzer2 delete();
	
	level waittill ("commtank_spawned");
		
	//respawn panzers untill the tank is dead
	while (isalive (level.commTank) )
	{
		level.commTank endon ("death");
		
		temp_panzer1 waittill ("trigger");
		
		//spawn the other panzer
		panzer2 = spawn("weapon_panzerschreck", panzer2_org);
		panzer2.angles = panzer2_angles;
		
		panzer2 waittill ("trigger");
		
		//spawn the first panzer agian
		temp_panzer1 = spawn("weapon_panzerschreck", panzer1_org);
		temp_panzer1.angles = panzer1_angles;
		
		
	}	
}


PricePathHint()
{
	
	level waittill ("tank_destroyed_path_wall");
	//nodes to send Price to
	block_node = getnode ("price_wall_block_node", "targetname"); 
	hint_node = getnode ("price_wall_hint_node", "targetname");
	
	blocker = getent ("commtank_blocker", "targetname");
	
	
	level.price setgoalnode (block_node);
	level.price.dontavoidplayer = true;
	
	level waittill ("Comm_Tank_destroyed");
	
	level.price.dontavoidplayer = false;
	level.price setgoalnode (hint_node);
	
	blocker hide();
	blocker connectpaths();
	
	wait .05;
	
	blocker delete();
	
	thread mg42_spot_dialogue2();
	thread mg42Guys_Two();


}

mg42_spot_dialogue2()
{
	trigger = getent ("mg42_spot_trigger2", "targetname");
	trigger waittill ("trigger");
	
	wait .05;
	level notify ("player_returned_to_price");
	
	level.price putOnFriendlyChain();
	
	battleChatterOff( "allies" );
	
	level.price anim_single_solo(level.price, "flank_left2");
	
	wait .2;
	
	level.price anim_single_solo(level.price, "give_covering_fire");
	
	battleChatterOn( "allies" );
	
	
}	
	
	
commTank_destruction()
{
	//get the before and after brush models
	wall1_before = getent ("commtank_wall01_before", "targetname");
	wall1_after = getent ("commtank_wall01_after", "targetname");
	
	wall2_before = getent ("commtank_wall02_before", "targetname");
	wall2_after = getent ("commtank_wall02_after", "targetname");
	
	wood_supports = getent ("commtank_wood_supports", "targetname");
		
	//hide the after models
	wall1_after hide();
	wall2_after hide();
	
	level waittill ("commTank_is_ready_to_shoot");
	
	//tank shoot logic
	tank_target1 = getent ("commtank_target1", "targetname");
	tank_target2 = getent ("commtank_target2", "targetname");
	tank_target3 = getent ("commtank_target3", "targetname");
	tank_target4 = getent ("commtank_target4", "targetname");
	
	//tank warning shot
	level.CommTank thread Tank_shoot_think(tank_target1);
	level waittill ("tank_fired");
	wait 2;
	
	//tank makes the hole player can get out of
	level.CommTank thread Tank_shoot_think(tank_target2);
	level waittill ("tank_fired");
	wait .05;
	level notify ("tank_destroyed_path_wall");
	wait .1;	
	maps\_utility::exploder(6);
	wall1_before hide();
	wall1_before connectpaths();
	wall1_before delete();
	wall1_after show();
		
	wait 2;	
	
	//tank destroys top of building
	level.CommTank thread Tank_shoot_think(tank_target3);
	level waittill ("tank_fired");
	wait .1;
	maps\_utility::exploder(7);
	wall2_before delete();
	wood_supports delete();
	wall2_after show();
	wait 2;	
	
	//tank fires Kuz hes a Krazy Kraut
	level.CommTank thread Tank_shoot_think(tank_target4);
	level waittill ("tank_fired");
			
}

					
german_runners()
{	
	trigger = getent ("runners_trigger", "targetname");
	trigger waittill ("trigger");
	//trigger delete();
	
	array_thread (getentarray ("german_runner1", "targetname"), ::german_runners_think);	
}

german_runners_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn))
		return;

	
	spawn endon ("death");
	
	oldfightdist = spawn.fightdist;
	oldmaxdist = spawn.maxdist;
	
	spawn.fightdist = 2;
	spawn.maxdist = 2;
	
	
	spawn waittill ("goal");
	
	spawn.fightdist = oldfightdist;
	spawn.maxdist = oldmaxdist;
	
	level waittill ("halftrack_encounter_started");
	
	//roll on the player if he tries to run past
	spawn setgoalentity (level.player);		
	
	
}



mg42Guys_Two()
{
	// get the trigger
	trigger = getent ("mg42_guys2_trigger", "targetname");
		
	//wait for the trigger to be hit
	trigger waittill ("trigger");
	
	//spawn	
	array_thread (getentarray ("mg42_guys2", "targetname"), ::mg42guys_two_think);
		
	//thread the 3rd mg42 encounter
	thread mg42Guys_Three();
		
}

mg42guys_two_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
		
	spawn endon ("death");
	
	level waittill ("halftrack_encounter_started");
	
	//roll on the player if he tries to run past
	spawn setgoalentity (level.player);	
	
}


	

mg42Guys_Three()
{	
	//get the trigger
	trigger = getent ("mg42_guys3_trigger", "targetname");
	trigger waittill ("trigger");
//	trigger delete();

	//get the spawners in an array
	spawners = getentarray ("mg42_guys3", "targetname");
	
	//mg42 gunner
	mg42_gunner = getent ("mg42_guys3_gunner", "targetname");
	mg42_gunner thread mg42_gunner3_think(); 	

	//spawn 
	for (i=0;i<spawners.size;i++)
		spawners[i] dospawn();
		
	array_thread (getentarray ("mg42_guys3", "targetname"), ::mg42_guys3_think);	
	
	
	//thread the half track encounter
	thread price_crossroads_dialogue();
	thread HalfTrack_Encounter();
	
	
}

mg42_guys3_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
		
	spawn endon ("death");
	
	level waittill ("halftrack_encounter_started");
	
	//roll on the player if he tries to run past
	spawn setgoalentity (level.player);	
}

mg42_gunner3_think()
{
	spawn = self dospawn();
	if (spawn_failed (spawn))
	{	
		level notify ("garage_mg42_gunner_died");
		return;
	}
	
	spawn waittill ("death");
	
	wait .05;
	level notify ("garage_mg42_gunner_died");
}

price_crossroads_dialogue()
{
	eTrigger = getent ("price_crossroads_trigger", "targetname");
	eTrigger waittill ("trigger");
	
	wait .05;
	
//send in some reinforcements
	thread halftrack_encounter_reinforcements();
	
	wait .05;
	level notify ("price_starting_halftrack_dialogue");	

	thread autoSaveByName ("before_halftrack");
	
	battleChatterOff( "allies" );
	level.price thread anim_single_solo(level.price, "crossroads_ahead");
		
	price_crossroads_node = getnode ("price_crossroads_node", "targetname");	
	level.price setgoalnode (price_crossroads_node);

	
	//send in the the half track
	wait 3;	
	

	level.price anim_single_solo(level.price, "get_behind");
	
	battleChatterOn( "allies" );
	
	//wait till the first half track is destoryed
	level waittill ("first_ht_destoryed");
	
	
	wait 1.5;
	
	battleChatterOff( "allies" );
	level.price anim_single_solo(level.price, "spot_of_luck");
	battleChatterOn( "allies" );
	
	level.price thread putOnFriendlyChain();
	
		
}

halftrack_encounter_reinforcements()
{
	maxallies = 4;
	allied_spawners = getentarray ("reinforcements_halftrack", "targetname");
		
	alive_allies = getaiarray ("allies");
		
	spawn_spots = (maxallies - alive_allies.size);
	
	if (spawn_spots <= 0)
		println ("Debug: Not sending any reinforcements");
	else
		println ("Debug: Sending in " +spawn_spots +" reinforcements");	
		
	//spawn the AI
	for (i=0;i<spawn_spots;i++)
		allied_spawners[i] thread halftrack_encounter_reinforcements_think();
		
}

halftrack_encounter_reinforcements_think()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed (spawn))
	{
		return;
	}
	
	spawn endon ("death");
	spawn thread putOnFriendlyChain();

}
	

HalfTrack_Encounter()
{

	
	level waittill ("price_starting_halftrack_dialogue");
	
	//removed left over germans
//	aGermans = getaiarray ("axis");
	
//	for (i=0;i<aGermans.size;i++)
//		aGermans[i] delete();

	wait .05;
	level notify ("halftrack_encounter_started");
	
	trigger = getent ("ht_halftrack_trigger", "targetname");
	trigger notify ("trigger");
	
	//Get the half track
	halftrack = maps\_vehicle::waittill_vehiclespawn("ht_first");
	
	thread halftrack1(halftrack);
	
	//spawn the reinforcements
	array_thread (getentarray ("reinforce1", "targetname"), ::reinforcements1_think);
	
	//send the first panzer guy to his node
	
	
	panzer_spawner = getent ("panzer_guy", "script_noteworthy");

	
	panzer_guy_node = getnode ("panzer_guy_node", "targetname");
	panzer_guy_node2 = getnode ("panzer_guy_node2", "targetname");
	
	
	thread Second_HalfTrack();
	
	wait 3;
	
	//waittill the halftrack is dead
	if (isalive (halftrack))
	{
		wait 14;
		if (isalive (halftrack) )
		{
			//spawn the guy to shoot the half track
			guy = panzer_spawner dospawn();
			if (spawn_failed(guy))
				return;
			
			guy.animname = ("generic");
			guy thread maps\_utility::magic_bullet_shield();
			guy.ignoreme = true;
			guy.anim_disablePain = true;
			
			thread ht_dialogue(guy);

			//kill the half track
			guy.anim_dropPanzer = true;
			guy setstablemissile(true);
			level maps\_spawner::panzer_target( guy, panzer_guy_node, undefined, halftrack, (0,0,80) );
			println ("Debug: Panzerfaust fired!");
			wait .5;
			halftrack notify ("death");
			wait .05;
			level notify ("first_ht_destoryed");
			
		
			//turn off his magic bullet shield
			guy notify ("stop magic bullet shield");
		
			wait .05;
			
			if (isalive (guy) )
			{
				guy.health = 1;
				guy.anim_disablePain = false;
				guy thread putOnFriendlyChain();
			}		
				
			
			thread reinforcement2();
	
		}
		
	}
		
	
	
}

ht_dialogue(guy)
{
	
	wait 8;
	//price dialogue
	level.price anim_single_solo (level.price, "ht_kill");
	
	wait .5;
	
	//generic dialogue
	guy anim_single_solo (guy, "yes_sir");
	
}

Second_HalfTrack()
{
	wait 5;		
	
	door_node = getnode ("ht_door_node", "targetname");
	
	//start the second halftracks path
	halftrack2_trigger = getent ("ht_second_trigger", "targetname");
	halftrack2_trigger notify ("trigger");
	halftrack2 = maps\_vehicle::waittill_vehiclespawn("ht_second");
	halftrack2_wait_node = getvehiclenode ("ht_halftrack2_waitnode", "script_noteworthy");
	
	halftrack2 waittill ("reached_end_node");
	halftrack2 stopEngineSound();
	
	//spawn the second panzer guy
	panzer_spawner2 = getent ("panzer_guy02", "script_noteworthy");
	guy02 = panzer_spawner2 dospawn();
	if (spawn_failed(guy02))
		return;
	
	guy02 thread maps\_utility::magic_bullet_shield();
			
	guy02_node = getnode ("ht_panzer_guy02_node", "targetname");
	
	
	guy02.goalradius = 4;
	guy02 setgoalnode (door_node);
	
	guy02 waittill ("goal");
	
	//open the door
	door = getent ("ht_door", "targetname");
	door rotateyaw (90, .5,.4,0);

	//connect the paths
	door connectpaths();
	
	//dont clip through the door
	wait .5;
	
	//fire the panzerfaust
	guy02.anim_dropPanzer = true;
	guy02 setstablemissile(true);
	level maps\_spawner::panzer_target( guy02, guy02_node, undefined, halftrack2, (0,0,40) );
	guy02.anim_dropPanzer = true;
	wait .5;
	println ("panzerfaust fired!");

	
	//stop the rain
	thread stopRain();

	wait .2;
		
	//turn off his magic bullet shield
	//guy02 thread maps\_utility::stop_magic_bullet_shield();
	guy02 notify ("stop magic bullet shield");
	wait .2;
	guy02.health = 1;
	
	wait .05;	
	level notify ("halftrack_encounter_over");
	
	guy02 thread putOnFriendlyChain();
	
	thread reinforcement2();
		
	//bring in some germans
	array_thread (getentarray ("ht_germans1", "targetname"), ::ht_germans_think);
	
	level waittill ("spawn_next_xr_wave");
	
	array_thread (getentarray ("ht_germans1", "targetname"), ::ht_germans_think);
	
	flag_set ("ht_german_waves_done");
		
	//wait untill the germans start escaping then bring in some reinforcements
	level waittill ("ht_germans1_escape");
	
	thread reinforcement2();
	
	wait 4;
	
	//get the closest ai to the player, but not price
	level.price.team = "neutral";
	
	closestAI = maps\_utility::getClosestAI (level.player getorigin(), "allies" );
	
	level.price.team = "allies";
	
	closestAI.animname = "generic";
	
	closestAI thread maps\_utility::magic_bullet_shield();
	
	battleChatterOff( "allies" );
	
	//BS4: They're falling back! We've held the crossroads!!!
	if (isalive (closestAI))
	{
		closestAI anim_single_solo (closestAI, "falling_back");
		closestAI notify ("stop magic bullet shield");
			
	}
	
	wait 5;
	thread autoSaveByName ("crossroads_reached");
	
	node = getnode ("cr_price_node", "targetname");
	
	level.price setgoalnode (node);
	level.price.goalradius = 512;
	
	level.price waittill ("goal");
	
	trigger = getent ("cr_price_trigger", "targetname");
	
	trigger waittill ("trigger");
	
	wait .05;
	level notify ("crossroads_reached");
	
	//level.price lookat(level.player, 2);
	battleChatterOff( "allies" );
	level.price anim_single_solo(level.price, "farm_house");
	
	wait .5;
	level.price thread anim_single_solo(level.price, "take_some_lads");
	
	battleChatterOn( "allies" );
	
	thread halftrack_encounter_reinforcements();
	
	wait .05;
	level notify ("add_farmhouse_objective");
	
	//thread the farm house encounter
	thread priceKickGate();
	
	level.price putOnFriendlyChain();
	
	//send all the remaining germans at the player
	germans = getaiarray ("axis");
	
	for (i=0;i<germans.size;i++)
		germans[i] setgoalentity (level.player);	
		
	
	
}

halftrack1(halftrack)
{
	while (isalive (halftrack))
	{
		wait .5;
	}
	
	level notify ("first_ht_destoryed");
	
}

ht_germans_think()
{
	self.count = 1;
	
	spawn = self dospawn();
	level.ht_germans ++;
	
	if (spawn_failed (spawn))
	{	
		level.ht_germans--;
		return;
	}
	
	spawn thread ht_germans_deathwaiter();
	
	spawn endon ("death");
	
	spawn.anim_disableLongDeath = true;
	firstgoalnode = getnode (spawn.target, "targetname");
	spawn setgoalnode (firstgoalnode);
	spawn.goalradius = firstgoalnode.radius;
	
	level waittill ("ht_germans1_escape");
	println ("Debug: Germans are Escaping!!!");
	
	secondgoalnode = getnode (firstgoalnode.target, "targetname");
	
	spawn setgoalnode (secondgoalnode);
	spawn waittill ("goal");
	
	spawn delete();
	
	
}

ht_germans_deathwaiter()
{
	self waittill ("death");
	level.ht_germans--;
	
	if (level.flag["ht_germans_escaping"] == false)
		thread ht_germans_counter();
}
		

ht_germans_counter()
{
	if ((level.ht_germans <= 3) && (level.flag["ht_german_waves_done"] == false))
	{
		wait .05;	
		level notify ("spawn_next_xr_wave");
	}
	
	if ((level.ht_germans <= 3) && (level.flag["ht_german_waves_done"] == true))
	{	
		array_thread (getentarray ("ht_germans2", "targetname"), ::ht_germans2_think);
		wait .05;
		level notify ("ht_germans1_escape");
		flag_set ("ht_germans_escaping");

	}	
		
}
		
ht_germans2_think()
{
	spawn = self dospawn();
	level.ht_germans ++;
	
	if (spawn_failed (spawn))
	{	
		level.ht_germans--;
		return;
	}
	
	spawn thread ht_germans_deathwaiter2();
	spawn endon ("death");
	spawn waittill ("goal");
	wait 1;
	spawn waittill ("goal");
	spawn delete();
	
//	thread ht_germans_counter2();

}



ht_germans_deathwaiter2()
{
	self waittill ("death");
	level.ht_germans--;
	
//	if (level.ht_germans == 0)
//		thread soliders_dialogue_setup();
}
	
			
reinforcements1_think()
{
	self.count = 1;
	spawn = self dospawn();
	
	if (spawn_failed (spawn))
		return;
	
	spawn endon ("death");
	
	spawn thread putOnFriendlyChain();

}	

/*
soliders_dialogue_setup()
{
	
//	level waittill ("all_ht_germans_dead");
		
	thread autoSaveByName ("crossroads_reached");
	
	node = getnode ("cr_price_node", "targetname");
	
	level.price setgoalnode (node);
	level.price.goalradius = 512;
	
	level.price waittill ("goal");
	
	trigger = getent ("cr_price_trigger", "targetname");
	
	trigger waittill ("trigger");
	
	wait .05;
	level notify ("crossroads_reached");
	
	//level.price lookat(level.player, 2);
	battleChatterOff( "allies" );
	level.price anim_single_solo(level.price, "farm_house");
	
	wait .5;
	level.price thread anim_single_solo(level.price, "take_some_lads");
	
	battleChatterOn( "allies" );
	
	thread halftrack_encounter_reinforcements();
	
	wait .05;
	level notify ("add_farmhouse_objective");
	
	//thread the farm house encounter
	thread priceKickGate();
	
	level.price putOnFriendlyChain();
	
	//send all the remaining germans at the player
	germans = getaiarray ("axis");
	
	for (i=0;i<germans.size;i++)
		germans[i] setgoalentity (level.player);
			
}	
*/

stopRain()
{
	
	thread maps\crossroads_fx::fogbankFX();
//	wait 3;
//	level notify ("fogstart");
	
	
	
	
	
}

//make the closest AI to the gate kick it open
priceKickGate()
{
	gate_node = getnode ("gate_node", "targetname");
	
	trigger = getent ("gate_trigger", "targetname");
	trigger waittill ("trigger");
	
	guy[0] = level.price;
	guy[0].animname = "left";
	guy[0].anim_node = gate_node;
	guy[0] notify ("stop friendly think");
	
	gate_node maps\_anim::anim_reach (guy, "kickdoor", undefined, gate_node);
	guy[0] pushPlayer (false);
	
	
	thread halftrack_encounter_reinforcements();
	
	
	gate_node thread maps\_anim::anim_single (guy, "kickdoor");
	
	thread autoSaveByName ("before_gateKick");
	
	
	guy[0] waittillmatch ("single anim", "soundfx = kickdoor");
	
	guy[0] thread putOnFriendlyChain();
	
//	closestAI thread maps\_utility::stop_magic_bullet_shield();
	
	farmhouse_gate = getent ("farmhouse_gate", "targetname");
	farmhouse_gate playsound ("gate_iron_open");
	
	farmhouse_gate rotateyaw(90,.5,.2,.2);
	
	farmhouse_gate connectpaths();
	
	guy[0] waittillmatch ("single anim", "end");
	guy[0] pushPlayer (true);
	
	wait .05;
	level notify ("farmhouse_gate_open");
	
	guy[0].animname = "price";
	
	thread houseEncounter();
	thread house_dialogue();
	thread barn_encounter();
	
}

house_dialogue()
{
	thread barn_encounter_outside();
	
	//bring some more allies in
	halftrack_encounter_reinforcements();
	
	wait 1;
		
	level.price.team = ("neutral");
	
	allies = getaiarray ("allies");
	
	
	soldier1 = allies[0];
	soldier2 = allies[1];
	soldier3 = allies[2];
	
	soldier1.animname = "soldier1";
	soldier2.animname = "soldier2";
	soldier3.animname = "soldier3";
	
	soldier3 thread maps\_utility::magic_bullet_shield();
	
	level.price.team = ("allies");
	
	wait 2;
	battleChatterOff( "allies" );
		
//	if (isalive (soldier1) )
//		soldier1 anim_single_solo(soldier1, "ambush");

//	wait 1;
	if (isalive (soldier2) )
		soldier2 anim_single_solo(soldier2, "mg42_window");
		
	wait 1;
	level.price anim_single_solo (level.price, "farmMg42");
	
	battleChatterOn( "allies" );
	
	flag_wait ("farmHouse_secure");
//	level waittill ("farmhouse_secure");
	
	battleChatterOff( "allies" );
	
	wait 1;
	if (isalive (soldier3) )
		soldier3 anim_single_solo(soldier3, "house_clear");
	
	wait 1;
	if (level.flag["barn_secure"] == false)
		level.price anim_single_solo(level.price, "check_barn");
	
	wait 2;
	if (level.flag["radios_destroyed"] == false)
		level.price anim_single_solo (level.price, "barn_radio");
	
	battleChatterOn( "allies" );
	
	soldier3 notify ("stop magic bullet shield");
		
}

//this is the farm house encounter	
houseEncounter()
{	
	//spawn the ai in the house
	array_thread (getentarray ("farmhouse_spawner", "targetname"), ::farmhouseGermans_think);
	
	//thread the farm house windows
	thread farmHouseWindows();

}


//disable the mg42 untill the windows are open
farmhouse_mg42()
{	
	mg42_node = getnode ("house_mg42_node", "script_noteworthy");
	mg42_node.mg42_enabled = false;
	
	level waittill ("enable_mg42");
	
	mg42_node notify ("enable mg42");
}	


//check to see if the german spawned
farmhouseGermans_think()
{
	spawn = self dospawn();
	
	level.farmhouseGermans++;
	
	
	if (spawn_failed (spawn))
	{
		level.farmhouseGermans--;
		return;
	}		
	
	spawn endon ("death");
	spawn thread farmhouseGermans_DeathWaiter();

}

//wait until a german dies then run the counter thread
farmhouseGermans_DeathWaiter()
{
	self waittill ("death");
	level.farmhouseGermans--;
	thread 	farmhouseGermans_Counter();
}		

//check to see if all the germans are dead in the farmhouse
farmhouseGermans_Counter()
{
	if (level.farmhouseGermans == 0)
	{
		wait 3;
		flag_set ("farmHouse_secure");
		thread autoSaveByName ("farmhouse_secure");
	}	
}	

farmHouseWindows()
{
	//get ent for the mg42 gunner
	gunner = getent ("farmhouse_spawner_mg42", "targetname");
	gunner thread farmHouseMG42Gunner_think();
	
	//get the ents for the windows
	window_left = getent ("farmwindowleft", "targetname");
	window_right = getent ("farmwindowright", "targetname");
	
	//open the windows
	wait 1;
	
	level notify ("enable_mg42");
	
	window_left rotateyaw (-130, .5,.4,0);
	window_right rotateyaw (130, .5,.4,0);

}	

farmHouseMG42Gunner_think()
{
	spawn = self dospawn();
	
	level.farmhouseGermans++;
		
	if (spawn_failed (spawn))
	{
		level.farmhouseGermans--;
		return;
	}
	
	spawn endon ("death");
	spawn thread mg42gunner_deahtwaiter();
	
}
	
mg42gunner_deahtwaiter()
{
	self waittill ("death");
	level.farmhouseGermans--;
	
	level notify ("house_mg42_gunner_died");
	thread farmhouseGermans_Counter();	
}


barn_encounter_outside()
{
	barn_trigger = getent ("barn_ai_outside_trigger", "targetname");
	barn_trigger waittill ("trigger");
	
	wait .05;
	level notify ("germans_outside_of_barn");
	
	wait 2;
	germans = getentarray  ("barn_ai_outside", "targetname");

	
	for (i=0;i<germans.size;i++)
	{
		ai = germans[i] dospawn();
		if (spawn_failed (ai) )
			continue;
	}
	
}
	
		
barn_encounter()
{

	//waittill all the AI in the barn are dead before starting the counter attack
	

	array_thread (getentarray ("barn_spawner", "targetname"), ::barn_ai_think);
	
	flag_wait ("farmHouse_secure");
	flag_wait ("barn_secure");
	flag_wait ("radios_destroyed");
	
	//take price off the friendly chain a give him a node
	price_node = getnode ("price_barn_node", "targetname");
	level.price setgoalnode (price_node);
	level.price.goalradius = 4;
	
	//waves of german counter attackers
	//first wave
	array_thread (getentarray ("barn_wave1", "targetname"), ::barn_germans_think);	
	println ("Debug: Sending in first wave");
	
	//dialogue
	thread barn_dialogue();
		
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining --;
	
	//second wave
	array_thread (getentarray ("barn_wave3", "targetname"), ::barn_germans_think);
	println ("Debug: Sending in second wave");	
	
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining--;
	
	//thirdwave - Send in a portable MG42 guy 
	array_thread (getentarray ("barn_wave1", "targetname"), ::barn_germans_think);
	array_thread (getentarray ("barn_wave2", "targetname"), ::barn_germans_think);
		
	barn_wave_mg42_guy1 = getent ("barn_wave_mg42_guy1", "targetname");
		
	barn_wave_mg42_guy1 thread barn_ai_think();
		
	println ("Debug: Sending in third wave");
	
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining--;	
	
	//Fourth wave
	//wave is sent in by a german truck - don't wait for all of them to be killed
	
	truck_trigger = getent ("barn_truck_trigger", "targetname");
	truck_trigger notify ("trigger");
	
	array_thread (getentarray ("barn_wave3", "targetname"), ::barn_germans_think);
	println ("Debug: Sending in fourth wave");		
		
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining--;
	
	//Fifth Wave
	//germans trying to come into the barn
	//Send in a smoke grenade guy
	array_thread (getentarray ("barn_wave1", "targetname"), ::barn_germans_think);
	array_thread (getentarray ("barn_wave4", "targetname"), ::barn_germans_think);
	
	println ("Debug: Sending in fifth wave");		
	
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining--;
	
	//6th wave of germans - Another portable mg42 guy
	array_thread (getentarray ("barn_wave1", "targetname"), ::barn_germans_think);
	array_thread (getentarray ("barn_wave2", "targetname"), ::barn_germans_think);
			
	barn_wave_mg42_guy2 = getent ("barn_wave_mg42_guy2", "targetname");
	barn_wave_mg42_guy2 thread barn_ai_think();	
	
	level waittill ("barn_german_wave_is_dead");
	level.wavesRemaining--;
	
	//Send in the tank
	wait 2;
	
	barn_reinforcement();
	wait 1;
	thread tank_dialogue();
	thread tank_encounter();
	
	
	
}

barn_dialogue()
{
	//reinforce the player
	barn_reinforcement();
	
	wait 3;
	level.price.team = ("neutral");
	
	allies = getAIArray( "allies" );
	
	level.price.team = ("allies");
	
	soldier4 = allies[0];
	soldier3 = allies[1];
	
	soldier4.animname = "soldier4";
	soldier3.animname = "soldier3";

	battleChatterOff ("allies");
	
	if (isalive (soldier4) )
		soldier4 anim_single_solo (soldier4, "counter_attack2");
		
	wait 1;
	
	if (isalive (soldier3) )
		soldier4 anim_single_solo (soldier3, "counter_attack");
		
	wait 1;
	
	level.price anim_single_solo (level.price, "def_positions");
	
	wait .5;
	
	level.price anim_single_solo (level.price, "use_mg");	
		
	battleChatterOn ("allies");	
		
}
	

barn_ai_think()
{
	spawn = self dospawn();
	
	level.barnAI++;
	
	if (spawn_failed (spawn) )
	{
		level.barnAI--;
		return;
	}
	
	spawn endon ("death");
	spawn.anim_disableLongDeath = true;
	
	spawn thread barn_ai_deathwaiter();
	
}

barn_ai_deathwaiter()
{
	self waittill ("death");
	level.barnAI--;
	
	thread barn_ai_counter();
}

barn_ai_counter()
{
	if (level.barnAI == 0)
	{	
		wait 3;
		flag_set ("barn_secure");
		wait 2;
		thread autoSaveByName ("barn_secure");			
	}
		
}
	

barn_roof()
{
	
	//get FX ents
	fx_1 = getent ("tank_target1", "targetname");
	fx_2 = getent ("tank_target2", "targetname");
	fx_3 = getent ("tank_target3", "targetname");
	fx_4 = getent ("tank_target4", "targetname");
	fx_5 = getent ("tank_target5", "targetname");

	
	shellshock1 = getent ("barn_shellshock_trigger1", "targetname");
	shellshock2 = getent ("barn_shellshock_trigger2", "targetname");
	shellshock3 = getent ("barn_shellshock_trigger3", "targetname");
	shellshock4 = getent ("barn_shellshock_trigger4", "targetname");
	shellshock5 = getent ("barn_shellshock_trigger5", "targetname");

	
	//main piece
	roof_before = getent ("barn_roof_before", "targetname");
	roof_after_1 = getent ("barn_roof_after01", "targetname");
	
	roof_before_2 = getent ("barn_roof_before02", "targetname");
	roof_after_2 = getent ("barn_roof_after02", "targetname");

	roof_before_3 = getent ("barn_roof_before03", "targetname");
	roof_after_3 = getent ("barn_roof_after03", "targetname");
	
	roof_after_4 = getent ("barn_roof_after04", "targetname");
	
	//floor
	floor_before_2 = getent ("barn_floor_before02", "targetname");	
	floor_before_4 = getent ("barn_floor_before04", "targetname");
	
	floor_after_2 = getent ("barn_floor_after02", "targetname");
	floor_after_4 = getent ("barn_floor_after04", "targetname");
	
	//wall
	wall_before_1 = getent ("barn_wall_before01", "targetname");
	wall_after_1 = getent ("barn_wall_after01", "targetname");
	
	//hide the after models
	roof_after_1 hide();
	roof_after_2 hide();
	roof_after_3 hide();
	roof_after_4 hide();
	
	floor_after_2 hide();
	floor_after_4 hide();
	
	wall_after_1 hide();
	
	//hide the before models except roof_before
	roof_before_2 hide();
	roof_before_3 hide();
	
	//monster clip to makes ure the ai doesnt use the cover nodes after the wall is blown out
	barn_wall_blocker = getent ("barn_wall_blocker", "targetname");
	
	barn_roof_blocker1 = getent ("barn_roof_blocker1", "targetname");
	barn_roof_blocker2 = getent ("barn_roof_blocker2", "targetname");
	barn_roof_blocker4 = getent ("barn_roof_blocker4", "targetname");
	
	barn_wall_blocker notsolid();
	barn_wall_blocker connectpaths();
	
	barn_roof_blocker1 notsolid();
	barn_roof_blocker1 connectpaths();
	
	barn_roof_blocker2 notsolid();
	barn_roof_blocker2 connectpaths();
	
	barn_roof_blocker4 notsolid();
	barn_roof_blocker4 connectpaths();


	//first part destoryed
	level waittill ("barn_first_target_shot");
	
	maps\_utility::exploder(1);
	earthquake(1.0, 1.0, level.player.origin, 6000);
	

	if (level.player istouching (shellshock1))
		thread maps\_shellshock::main(.5, 1, 1, 1);
		
	roof_before delete();
	
	roof_after_1 show();
	roof_before_2 show();
	roof_before_3 show();
	
	barn_roof_blocker1 solid();
	barn_roof_blocker1 disconnectpaths();
	
	setplayerignoreradiusdamage(true);
	radiusdamage(fx_1.origin, 300, 200, 50);
	setplayerignoreradiusdamage(false);
	
	
	//second part destroyed
	level waittill ("barn_second_target_shot");
	maps\_utility::exploder(2);
	earthquake(1.0, 1.0, level.player.origin, 6000);
	
	if (level.player istouching (shellshock2))
		thread maps\_shellshock::main(.5, 1, 1, 1);
	
	roof_before_2 delete();
	floor_before_2 delete();
	
	roof_after_2 show();
	floor_after_2 show();
	
	barn_roof_blocker2 solid();
	barn_roof_blocker2 disconnectpaths();
	
	setplayerignoreradiusdamage(true);
	radiusdamage(fx_2.origin, 300, 200, 50);
	setplayerignoreradiusdamage(false);
	
	
	//third part destroyed - wall
	level waittill ("barn_third_target_shot");
	maps\_utility::exploder(3);
	earthquake(1.0, 1.0, level.player.origin, 6000);
	
	if (level.player istouching (shellshock3))
		thread maps\_shellshock::main(.5, 1, 1, 1);
		
	wall_before_1 delete();
	wall_after_1 show();
	
	radiusdamage(fx_3.origin, 300, 200, 50);
	
	barn_wall_blocker solid();
	barn_wall_blocker disconnectpaths();

			
	//fourth part destroyed
	level waittill ("barn_fourth_target_shot");
	maps\_utility::exploder(4);
	earthquake(1.0, 1.0, level.player.origin, 6000);
	
		if (level.player istouching (shellshock4))
			thread maps\_shellshock::main(.5, 1, 1, 1);
	
	roof_before_3 delete();
	roof_after_3 show();
	
	barn_roof_blocker4 solid();
	barn_roof_blocker4 disconnectpaths();
	
	barn_roof_damage4 = getent ("barn_roof_damage4", "targetname");		
	
	setplayerignoreradiusdamage(true);
	radiusdamage(barn_roof_damage4.origin, 500, 300, 300);
	setplayerignoreradiusdamage(false);	
	
	//5th part destroyed
	level waittill ("barn_fifth_target_shot");
	level thread maps\_fx::OneShotfx("tank_barn_explode", fx_4.origin, 0);
	earthquake(1.0, 1.0, level.player.origin, 6000);

	if (level.player istouching (shellshock5))
		thread maps\_shellshock::main(.5, 1, 1, 1);
			

	roof_after_2 delete();
	roof_after_3 delete();
	
	floor_before_4 delete();
	
	roof_after_4 show();
	floor_after_4 show();
	
	
}
	
//reinforce the player again when he makes it to the barn
reinforcement2()
{	
	
	maxallies = 4;
	allied_spawners = getentarray ("reinfoce2", "targetname");
		
	alive_allies = getaiarray ("allies");
		
	spawn_spots = (maxallies - alive_allies.size);
	
	if (spawn_spots <= 0)
		println ("Debug: Not sending any reinforcements");
	else
		println ("Debug: Sending in " +spawn_spots +" reinforcements");
		
	//spawn the AI
	for (i=0;i<spawn_spots;i++)
		allied_spawners[i] thread reinforcements2_think();
			
}

reinforcements2_think()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed (spawn))
	{
		return;
	}
	
	spawn endon ("death");
	spawn thread putOnFriendlyChain();

}

barn_germans_think()
{	
	self.count = 1;
	spawn = self dospawn();
	
	level.barn_wave_germans++;
	
	if (spawn_failed (spawn))
	{
		level.barn_wave_germans--;
		return;
	}

	spawn.anim_disableLongDeath = true;
	spawn endon ("death");
	spawn thread barn_germans_deathWaiter();
		
}

//this will make the germans go to their next goal node
/*
barn_germans_cover()
{
	self endon ("death");
	
	if (!isdefined (self.target))
	{
		assertMsg("^2node at origin " + self.origin + " has no target");
		return;
	}

	firstnode = getnode (self.target, "targetname");
	self setgoalnode (firstnode);
	
	self waittill ("goal");
	wait randomint ((2+5));
	
	secondnode = getnode (firstnode.target, "targetname");
	
	if (isalive (self) )
	{
		wait (randomfloat (1));
		self setgoalnode (secondnode);
	}

}
*/

barn_germans_deathWaiter()
{
	self waittill ("death");
	level.barn_wave_germans--;
	
	thread barn_wave_germans_counter();
}

barn_wave_germans_counter()
{
	if (level.barn_wave_germans <= 3)
	{
		wait .05;
		level notify ("barn_german_wave_is_dead");
	}
	
}	


tank_encounter()
{	
	//start the tank driving 
	eTrigger = getent ("tank_trigger", "targetname");
	eTrigger notify ("trigger");
		
	thread autoSaveByName("beforeTank");
	
	//get the tank
	level.tank = maps\_vehicle::waittill_vehiclespawn("tank");
	
	wait .05;
//	level.tank.script_attackai = 0;
	level.tank.health = 1000000;
		
	//send some germans in with the tank 
	array_thread (getentarray ("barn_wave1", "targetname"), ::barn_germans_think);
	
	
	level.tank waittill ("reached_end_node");
	
 	level.tank thread tank_shoot();
 
}

barn_reinforcement()
{	
	
	maxallies = 6;
	allied_spawners = getentarray ("reinfoce2", "targetname");
		
	alive_allies = getaiarray ("allies");
		
	spawn_spots = (maxallies - alive_allies.size);
	
	if (spawn_spots <= 0)
		println ("Debug: Not sending any reinforcements");
	else
		println ("Debug: Sending in " +spawn_spots +" reinforcements");
		
	//spawn the AI
	for (i=0;i<spawn_spots;i++)
		allied_spawners[i] thread barn_reinforcement_think();
			
}

barn_reinforcement_think()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed (spawn))
		return;
	
	spawn endon ("death");
	spawn thread putOnFriendlyChain();

}

CommRadio()
{
	
	level.radiohealth = 100;
	
	thread CommRadio_use();
	thread CommRadio_damage();

	radios = getentarray ("comm_radio", "targetname");
	
	level waittill ("radios_dead");
	
	for (i=0;i<radios.size;i++)
	{
		dmodel = undefined;
		switch (radios[i].model)
		{
			case "xmodel/military_german_radio1_green":
			case "xmodel/military_german_radio1_green_obj":
				dmodel = "xmodel/military_german_radio1_green_d";
				break;
			case "xmodel/military_german_radio2_green":
			case "xmodel/military_german_radio2_green_obj":
				dmodel = "xmodel/military_german_radio2_green_d";
				break;
			case "xmodel/military_german_fieldradio_green":
			case "xmodel/military_german_fieldradio_green_obj":
				dmodel = "xmodel/military_german_fieldradio_green_d";
				break;
		}			
		assert (isdefined (dmodel));
		radios[i] setmodel (dmodel);
	}
	level.radios = 0;
	destroyedRadioFX();
	radios[0] playsound ("explo_radio");
		
	flag_set ("radios_destroyed");
	
	wait 1;
	
	thread autoSaveByName ("radios_destroyed");
	

}

CommRadio_use()
{
	level.radio_use_trigger = getent ("radio_use_trigger", "targetname");
	
	level.radio_use_trigger setHintString (&"CROSSROADS_PLATFORM_HINT_RADIO");
	
	level.radio_use_trigger waittill ("trigger");
	
	wait .05;
	level notify ("radios_dead");
	level.radio_use_trigger triggeroff();
	level.radiohealth = 0;
}

CommRadio_damage()
{
	dmg_trigger = getent ("comm_radio_trigger", "targetname");
	
	while(1)
	{
		dmg_trigger waittill ("damage",dmg);
		
		level.radiohealth -= dmg;
		if(level.radiohealth <= 0)
		{
			wait .05;
			level notify ("radios_dead");
			level.radio_use_trigger triggeroff();
			break;
		}
	}
	
}



tank_dialogue()
{
	
	//get 4 random allies for the tank dialogue
	
	level.price.team = ("neutral");
	
	
	allies = getAIArray( "allies" );
	
	level.price.team = ("allies");
			
	soldier1 = allies[0];
	soldier2 = allies[1];
	soldier3 = allies[2];
	soldier4 = allies[3];
	
	soldier1.animname = "soldier1";
	soldier2.animname = "soldier2";
	soldier3.animname = "soldier3";
	soldier4.animname = "soldier4";
	
	soldier1 thread maps\_utility::magic_bullet_shield();
	soldier2 thread maps\_utility::magic_bullet_shield();
	soldier3 thread maps\_utility::magic_bullet_shield();	
	soldier4 thread maps\_utility::magic_bullet_shield();
		
	wait 6;
	
	battleChatterOff( "allies" );
	
	soldier1 anim_single_solo(soldier1, "panzer_tank");
	soldier1 notify ("stop magic bullet shield");
	

	soldier3 anim_single_solo(soldier3, "blow_us_away");
	
	soldier4 anim_single_solo(soldier4, "what_do_we_do");
	soldier4 notify ("stop magic bullet shield");

	soldier2 anim_single_solo(soldier2, "we_should_run");
	soldier2 notify ("stop magic bullet shield");

	
	soldier3 anim_single_solo(soldier3, "gonna_kill_us");
	soldier3 notify ("stop magic bullet shield");

	
	level.price anim_single_solo(level.price, "shut_it");
	
	wait .5;
	
	level.price anim_single_solo(level.price, "keep_quiet");
	
	wait 1;
	
	level.price anim_single_solo(level.price, "we_run");
	
	battleChatterOn( "allies" );
	
	
	//wait for the tank to be destory so price can finish his dialogue and start the convoy objective.
	level.tank waittill ("death");
	
	battleChatterOff( "allies" );
	
	wait 1;
	
	//Price: God bless the bloody RAF!
	level.price anim_single_solo (level.price, "god_bless");
	
	wait .5;
	
	//Price: Lads! Listen up! We're pulling out!
	level.price anim_single_solo (level.price, "pulling_out");

	wait .5;
	
	//Price: All right, everyone regroup at the crossroads! Let's go!
	level.price anim_single_solo (level.price, "meet_convoy");

	
	battleChatterOn( "allies" );
	
//	level.price putOnFriendlyChain();
	
	wait .05;
	level notify ("last_friendly_chain");
	
}

	
tank_shoot()
{
	
	tank_target1 = getent ("tank_target1", "targetname");
	tank_target2 = getent ("tank_target2", "targetname");
	tank_target3 = getent ("tank_target3", "targetname");
	tank_target4 = getent ("tank_target4", "targetname");
	tank_target5 = getent ("tank_target5", "targetname");
	
	level.tank thread tank_shoot_think(tank_target1);
	
	level waittill ("tank_fired");
	wait .25;
	level notify ("barn_first_target_shot");
	wait 3;
	
	level.tank thread tank_shoot_think(tank_target2);
	
	level waittill ("tank_fired");
	wait .25;
	level notify ("barn_second_target_shot");
	
	//bring in some AI for the plane to shoot at
	array_thread (getentarray ("plane_fodder", "targetname"), ::barn_germans_think);
	
	wait 2;
	
	//bring in the plane to destory the tank
	thread plane_tankbomber();
	
	wait 1;	
	
	level.tank thread tank_shoot_think(tank_target3);
	
	level waittill ("tank_fired");
	wait .25;
	level notify ("barn_third_target_shot");
	wait 3;	
	
	level.tank thread tank_shoot_think(tank_target4);
	
	level waittill ("tank_fired");
	wait .25;
	level notify ("barn_fourth_target_shot");
	
	level.tank thread tank_shoot_think(tank_target5);
	
	level waittill ("tank_fired");
	wait .25;
	level notify ("barn_fifth_target_shot");
	

		
}

//self is the tank shooting
tank_shoot_think(target)
{
	self endon ("death");
	
	if (isalive (self))
	{
		self clearTurretTarget();
		self setTurretTargetVec(target.origin);
		wait .05;
		self waittill ("turret_on_target");
		wait .05;
		self notify ("turret_fire");
		wait .05;
		level notify ("tank_fired");	
	}
	else
		println ("Debug: Tank is Dead");

}	

plane_tankbomber()
{
	
	//wait 10;
	start_node = getVehicleNode( "plane_bomber_node", "targetname" );
	plane = spawnVehicle( "xmodel/vehicle_spitfire_flying", "plane", "stuka", (0,0,0), (0,0,0) );
	
	
	
	wait .05;
	
	//left gun
	//FIXME - change back to stuka guns
	planeMg_left = spawnTurret("misc_turret", (0,0,0), "stuka_guns"); 
	planeMg_left linkto(plane, "tag_gunLeft", (0, 0, -14), (0, 0, 0));
	
	planeMg_left setleftarc(5);
	planeMg_left setrightarc(5);
	planeMg_left settoparc(5);
	planeMg_left setbottomarc(5);
	
	planeMg_left setconvergencetime(0);	
	planeMg_left setaispread(0.2);
	
	planeMg_left setturretteam("allies");
	
	planeMg_left setmode("auto_nonai");
	
	planeMg_left setmodel ("xmodel/weapon_mg42");
	
	planeMg_left hide();
	
	//right gun
	planeMg_right = spawnTurret("misc_turret", (0,0,0), "stuka_guns");
	planeMg_right linkto(plane, "tag_gunRight", (0, 0, -14), (0, 0, 0));
	
	planeMg_right setmodel ("xmodel/weapon_mg42");
	
	planeMg_right hide();
	
	planeMg_right setleftarc(5);
	planeMg_right setrightarc(5);
	planeMg_right settoparc(5);
	planeMg_right setbottomarc(5);
	
	planeMg_right setconvergencetime(0);
	planeMg_right setaispread(0.2);
	
	planeMg_right setturretteam("allies");
	
	planeMg_right setmode("auto_nonai");	
	
	
	plane attachPath (start_node);
	plane startPath();
	
	plane thread playSoundOnTag(level.scr_sound ["plane_1"], "tag_prop");
	
	plane setshadowhint("always");
	
	fireMGnode = getvehiclenode ("fire_mgs", "script_noteworthy");
	
					
	plane setwaitnode (fireMGnode);
	
	plane setspeed(150, 150);
	
	plane waittill("reached_wait_node");
	
	plane thread playSoundOnTag(level.scr_sound ["plane_1"], "tag_prop");
	
	plane setspeed(100, 100);
	
	thread plane_shoot_guns(plane, planeMg_left, planeMg_right);
	

	wait 3;
//wait 7;
	
	plane notify ("plane_stop_shooting");
	
//	wait 1;
	
	plane setspeed(150, 150);

	plane thread playSoundOnTag(level.scr_sound ["plane_1"], "tag_prop");

	bomb_waitnode = getvehiclenode ("drop_the_bomb", "script_noteworthy");
	plane setwaitnode (bomb_waitnode);
	

	bombnode = getent("drop_bomb", "targetname");
	
	plane waittill("reached_wait_node");
	thread plane_drop_bomb(bombnode, 1500);
	
	plane_sound3 = getvehiclenode ("plane_sound3", "script_noteworthy");
	plane setwaitnode (plane_sound3);
	plane waittill("reached_wait_node");
	
	plane thread playSoundOnTag(level.scr_sound ["plane_1"], "tag_prop");
	
	
	plane waittill("reached_end_node");
	plane delete();
	
	
}

plane_shoot_guns(plane, leftgun, rightgun)
{
	plane endon("plane_stop_shooting");
	
	for (;;)
	{
		leftgun ShootTurret();
		rightgun ShootTurret();
		wait 0.1;
	}
}

plane_drop_bomb(startnode, speed)
{
	//create the bomb
	model = spawn("script_model", startnode.origin);
	model setmodel ("xmodel/prop_stuka_bomb");
	bomb = spawn("script_origin", startnode.origin);
	model linkto(bomb);
	node1 = startnode;
	node2 = getent (node1.target, "targetname");
	
	vec = vectorNormalize(node2.origin - node1.origin);
	vec = maps\_utility::vectorScale(vec, speed);
	
	bomb moveGravity(vec, 10);
	thread blowUpTank();
}


blowUpTank()
{
	wait 1;
	earthquake(1.0, 1.0, level.tank.origin, 6000);
	level.tank notify ("death");
	
	TankFireSound = spawn("script_origin",level.tank.origin);
	TankFireSound playloopsound ("medfire");
	
	wait .05;
	flag_set ("counter_attack_over");
	
	wait 1;
	
	thread autoSaveByName("barn_tank_destroyed");
	
	thread german_retreat();
		
}

german_retreat()
{
	node = getnode ("german_retreat_node", "targetname");
	
	germans = getaiarray ("axis");
	
	for (i=0;i<germans.size;i++)
		germans[i] thread german_retreat_think(node);
		
		
}

german_retreat_think(node)
{
	self endon ("death");
	
	self.goalradius = 4;
	self setgoalnode (node);
	
	self waittill ("goal");
	
	self delete();
	
}
	
	

convoy()
{
	clip = getent ("convoy_clip", "targetname");
	clip hide();
	clip connectpaths();
	
	flag_wait ("counter_attack_over");

	thread price_end();
	
	array_thread (getentarray ("reinfoce2", "targetname"), ::reinforcements2_think);
	
	trigger1 = getent ("carrier1", "targetname");
	trigger2 = getent ("carrier2", "targetname");
	trigger3 = getent ("carrier3", "targetname");	
	
	trigger1 notify  ("trigger");
	
	convoy1 = maps\_vehicle::waittill_vehiclespawn("convoy1");
	
	clip show();
	clip disconnectpaths();
	
	wait 1;
	
	trigger2 notify ("trigger");
	
	convoy2 = maps\_vehicle::waittill_vehiclespawn("convoy2");
	
	wait 1;
	
	trigger3 notify ("trigger");
	
	convoy3 = maps\_vehicle::waittill_vehiclespawn("convoy3");
	
	wait .05;
	
	convoy1 thread convoy1_think();
	convoy2 thread convoy2_think();
	convoy3 thread convoy3_think();

//	wait at the wait node
	convoy1_waitnode = getvehiclenode ("carrier1_wait", "script_noteworthy");
	convoy1 setwaitnode (convoy1_waitnode);
	
	convoy1 waittill("reached_wait_node");
	
	convoy1 setspeed (0, 20);
	convoy2 setspeed (0, 20);
	convoy3 setspeed (0, 20);

	convoy_trigger = getent ("convoy_trigger", "targetname");
	convoy_trigger waittill ("trigger");
	
//	thread convoy_badplace(convoy1);
//	thread convoy_badplace(convoy2);
//	thread convoy_badplace(convoy3);
	
	wait .05;
	level notify ("player_close_to_convoy");
	
	convoy1 setspeed (5, 5);
	convoy2 setspeed (5, 5);
	convoy3 setspeed (5, 5);
	
	
}

price_end()
{
	price_node = getnode ("price_convoy_node", "targetname");
	level.price setgoalnode (price_node);
	
	level.price.goalradius = 4;
	level.price waittill ("goal");
	

	//	get the trigger to end the level
	end_trigger = getent ("endlevel_trigger", "targetname");	

//	wait for the trigger to be hit
	end_trigger waittill ("trigger");
	
	battlechatterOff ("allies");
	
	level.price anim_single_solo (level.price, "outro");
	
	//	complete the last objective	
	wait 6;
	level notify ("convoy_reached");
	
}
	
	

convoy1_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
}


convoy2_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
	
}

convoy3_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
}

convoy_badplace(carrier)
{
	carrier endon ("death");
	
	for(;;)
	{
		badplace_cylinder("", .5, carrier.origin, 128,64 , "allies","axis");
		wait .5;

	}

}

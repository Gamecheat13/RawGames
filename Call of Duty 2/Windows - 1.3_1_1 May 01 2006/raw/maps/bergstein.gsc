#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;

main()
{
	level.campaign = "american";
		

	//fog	
	//setcullfog (5, 4000, 0.247059, 0.254902, 0.286275, 0);
	setcullfog (5, 4000, 0.43, 0.43, 0.454, 0);
	
	//setExpFog (.0008, 0.247059, 0.254902, 0.286275, 0);
	setCullDist (6000);

	//load fx, anim and amb files	
	maps\_halftrack::main("xmodel/vehicle_halftrack_rockets_woodland");	
	maps\_jeep::main("xmodel/vehicle_american_jeep");
	
	maps\bergstein_fx::main();
	maps\bergstein_anim::main();
	level thread maps\bergstein_amb::main();
		
	maps\_load::main();	
	
	maps\_utility::array_thread(getaiarray(),::PersonalColdBreath);
	maps\_utility::array_thread(getspawnerarray(),::PersonalColdBreathSpawner);
	
	//rain dvars
	setsavedcvar ("r_outdoorAwayBias", "32");
	setsavedcvar ("r_outdoorDownBias", "-40");
	setsavedcvar ("r_outdoorFeather", "8");
	
	//precache
	precacheShellshock("default");
	
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("inventory_tnt_large");

	level.smoke_grenade_weapon = "smoke_grenade_american_night";

	
	//strings
	precacheString(&"BERGSTEIN_OBJ_HOUSES");
	precacheString(&"BERGSTEIN_OBJ_ASSEMBLE");
	precacheString(&"BERGSTEIN_OBJ_EASTHP");
	precacheString(&"BERGSTEIN_OBJ_MORTAR");
	precacheString(&"BERGSTEIN_OBJ_LASTHOUSE");
	precacheString(&"BERGSTEIN_OBJ_PANZERW");
	precacheString(&"BERGSTEIN_OBJ_CHURCH");
	
	
	
	// Set some cvars
	setsavedcvar("r_specularColorScale", "3.5");
	setsavedcvar("r_cosinePowerMapShift", "-.17");
	

	
	//first section encounters
	level.encounter1 = 0;
	level.encounter2 = 0;
	level.encounter3 = 0;
	level.encounter4 = 0;
	
	//flags for the first objective
	level.flag["house1_cleared"] = false;
	level.flag["house2_cleared"] = false;
	level.flag["house3_cleared"] = false;
	level.flag["house4_cleared"] = false;
	
	level.flag["player_entered_house1"] = false;
	level.flag["player_entered_house2"] = false;
	level.flag["player_entered_house3"] = false;
	level.flag["player_entered_house4"] = false;
	
	//this is for the first section friendly chains
	level.flag["all_houses_cleared"] = false;
	
	//this is for the setup outside the last house
	level.flag["ai_outside_out_clear"] = false;
	level.flag["mg42_gunner_dead"] = false;
	
	level.flag["panzerw_destroyed"] = false;
	
	level.flag["church_clear"] = false;
	
	level.flag["mortar_krew_dead"] = false;
	
	
	level.housesCleared = 0;
	
	level.encounter7 = 0;
	level.flag["player_inside_eastHP"] = false;
	
	level.churchEncounter = 0;
	
	level.germansOutsideHouse = 0;
	
	level.eastHPclear = 0;
	
	//TNT
	level.inventory_tnthud = maps\_inventory::inventory_create( "inventory_tnt_large", true );
	
	//threads
	thread objective_master();
	thread encounter_one();
	thread encounter_two();
	
	thread reinforcement_manager();
	
	thread encounter9();
	thread panzer_encounter();
	
	//FIXME - TEMP
	thread basement_guys();
	
		
	//characters
	level.randall = getent ("randall", "script_noteworthy");
	level.randall thread maps\_utility::magic_bullet_shield();
		
	//Friendly chains
	thread friendlyChain_manager();
	thread intro();
	thread mortar_attack();
	
	thread panzerwerfer();
	
	//mortar stuff
	level.explosion_startNotify["mortar"] = "start_mortars1";
	level.explosion_stopNotify["mortar"] = "stop_mortars1";
	
	level.explosion_startNotify["mortar2"] = "start_mortars2";
	level.explosion_stopNotify["mortar2"] = "stop_mortars2";
	
	
	thread maps\_mortar::generic_style("mortar", .3, undefined, undefined, 256, 2000, undefined);


}

objective_master()
{
	//objective 1 - Eliminate enemy resistance in the houses.
	
	encounter[0] = getent ("compass_encounter1", "targetname");
	encounter[1] = getent ("compass_encounter2", "targetname");
	encounter[2] = getent ("compass_encounter3", "targetname");
	encounter[3] = getent ("compass_encounter4", "targetname");
		
	level waittill ("intro_over");
	objective_add(0, "active", &"BERGSTEIN_OBJ_HOUSES", encounter[0].origin);
	objective_current (0);
	
	flag_wait ("house1_cleared");
	
	wait 2;
	battleChatterOff( "allies" );
	level.randall thread anim_single_solo(level.randall, "house_clear1");
	battleChatterOn( "allies" );
	
	//remove the star for the first house
	objective_additionalposition(0, 0, (0,0,0));
	
	//add the compass star for house 2
	objective_additionalposition(0, 1, encounter[1].origin);
	
	flag_wait ("house2_cleared");
	
	thread smoke_grenade_throw();
	
	//spawn the 30 cal guyz
	array_thread (getentarray ("30cal_spawner", "targetname"), ::ranger_mg_guy_think);
	
	wait 2;
	battleChatterOff( "allies" );
	level.randall thread anim_single_solo(level.randall, "house_clear2");
	battleChatterOn( "allies" );
	
	//remove the star for the second house
	objective_additionalposition(0, 1, (0,0,0));
	
	//add the compass stars for house3 and 4
	objective_additionalposition(0, 2, encounter[2].origin);
	objective_additionalposition(0, 3, encounter[3].origin);

	flag_wait ("house3_cleared");

	wait 2;
	battleChatterOff( "allies" );
	level.randall thread anim_single_solo(level.randall, "house_clear3");
	battleChatterOn( "allies" );
	
	//remove the star for house 3
	objective_additionalposition(0, 2, (0,0,0));
	
	flag_wait ("house4_cleared");
	
	wait 2;
	battleChatterOff( "allies" );
	level.randall thread anim_single_solo(level.randall, "regroup");
	battleChatterOn( "allies" );
	
	//remove the star for the fourth house
//	objective_additionalposition(0, 3, (0,0,0));
	
	
	objective_state (0, "done");
	
	thread assemble_with_randall();
	
	//objective 2 - Assemble with Sargent randall on the road
	compass_assemble = getent ("compass_assemble", "targetname");
	objective_add(1, "active", &"BERGSTEIN_OBJ_ASSEMBLE", compass_assemble.origin);
	objective_current (1);
	
	level waittill ("randall_done_talking");
	
	objective_state(1, "done");
	
	//objective 3 - Take over the german hardpoint to the east
	compass_easthp = getent ("compass_easthp", "targetname");
	objective_add (2, "active", &"BERGSTEIN_OBJ_EASTHP", compass_easthp.origin);
	objective_current (2);
	
	level waittill ("easthp_complete");
	
	objective_state (2, "done");
	
	//objective 4 - Eliminate the enemy mortar crew
	compass_mortarCrew = getent ("compass_mortarCrew", "targetname");
	
	objective_add(3, "active", &"BERGSTEIN_OBJ_MORTAR", compass_mortarCrew.origin);
	objective_current (3);
	
	level waittill ("add_flak_house_objective");
	
	//objective 5 - Clear the house of enemy resistance
	compass_flakHouse = getent ("compass_flakHouse", "targetname");
	
	objective_add(4, "active", &"BERGSTEIN_OBJ_LASTHOUSE", compass_flakHouse.origin);
	objective_current (4);
	
	level waittill ("final_house_clear");
	
	objective_state(4, "done");
	objective_current (3);
	
	flag_wait ("mortar_krew_dead");

	//check off the mortar crew objective
	objective_state(3, "done");
	
	//Destroy the Panzerwerfer!
	compass_panzerw = getent ("panzerw", "targetname");	
	
	objective_add(5, "active", &"BERGSTEIN_OBJ_PANZERW", compass_panzerw.origin);
	objective_current (5);
	
	flag_wait ("panzerw_destroyed");
	
	objective_state(5, "done");
	
	
	//objective 6 - take over the church
	compass_church = getent ("compass_church", "targetname");
	objective_add(6, "active", &"BERGSTEIN_OBJ_CHURCH", compass_church.origin);
	objective_current (6);
	
	level waittill ("church_complete");
	
	objective_state(6, "done");
	
	//objective 7 - assemeble on the road
	compass_road2 = getent ("compass_road2", "targetname");
	
	objective_add (7, "active", &"BERGSTEIN_OBJ_ASSEMBLE", compass_road2.origin);
	objective_current (7);
	
	level waittill ("player_is_on_road");
	
	objective_state(7, "done");
	
	wait 14;
	
	//END THE LEVEL
	maps\_endmission::nextmission();
		
}

friendlyChain_manager()
{
	//turn the friendly chains off
	maps\_utility::chain_off ("100");
	maps\_utility::chain_off ("105");
	maps\_utility::chain_off ("125");
	maps\_utility::chain_off ("130");
	maps\_utility::chain_off ("150");
	maps\_utility::chain_off ("155");
	maps\_utility::chain_off ("175");		
	maps\_utility::chain_off ("180");				
	maps\_utility::chain_off ("200");
	maps\_utility::chain_off ("300");
	maps\_utility::chain_off ("325");
	maps\_utility::chain_off ("350");
	maps\_utility::chain_off ("375");
	maps\_utility::chain_off ("380");
	maps\_utility::chain_off ("400");
	maps\_utility::chain_off ("500");	

//	chain_intro = get_friendly_chain_node ("75");
	
	chainHouse1_outside = get_friendly_chain_node ("100");
	chainHouse1_inside = get_friendly_chain_node ("105");
	
	chainHouse2_outside = get_friendly_chain_node ("125");
	chainHouse2_inside = get_friendly_chain_node ("130");
	
	chainHouse3_outside = get_friendly_chain_node ("150");
	chainHouse3_inside = get_friendly_chain_node ("155");
	
	chainHouse4_outside = get_friendly_chain_node ("175");
	chainHouse4_inside = get_friendly_chain_node ("180");
	
	chain5 = get_friendly_chain_node ("200");
	chain6 = get_friendly_chain_node ("300");
	chain_panzerdoor = get_friendly_chain_node ("325");
	chain7 = get_friendly_chain_node ("350");
	
	chainEastHP_inside = get_friendly_chain_node ("360");
	
	chain8 = get_friendly_chain_node ("375");
	last_house_chain = get_friendly_chain_node ("380");
	last_house_downstairs_chain = get_friendly_chain_node ("390");
	church_chain = get_friendly_chain_node ("400");
	chain9 = get_friendly_chain_node ("500");

	
//	level.player SetFriendlyChain (chain_intro);
	
	level waittill ("intro_over");
	
	wait 2;
	level.player SetFriendlyChain (chainHouse1_outside);

	flag_wait ("player_entered_house1");
	level.player SetFriendlyChain (chainHouse1_inside);
	
	flag_wait ("house1_cleared");
	level.player SetFriendlyChain (chainHouse2_outside);
	
	if (level.flag["house2_cleared"] == false)
	{
		flag_wait ("player_entered_house2");
		level.player SetFriendlyChain (chainHouse2_inside);
	}
	
	flag_wait ("house2_cleared");
	level.player SetFriendlyChain (chainHouse3_outside);


	if (level.flag["house3_cleared"] == false)
	{
		flag_wait ("player_entered_house3");
		level.player SetFriendlyChain (chainHouse3_inside);
	}
	
	flag_wait ("house3_cleared");
	level.player SetFriendlyChain (chainHouse4_outside);
	
	if (level.flag["house4_cleared"] == false)
	{
		flag_wait ("player_entered_house4");
		level.player SetFriendlyChain (chainHouse4_inside);
	}
	
	flag_wait ("all_houses_cleared");


	//chain at the roadblock for dialogue
	level.player SetFriendlyChain (chain5);

	level waittill ("randall_done_talking");
	level.player SetFriendlyChain (chain6);
	
	level waittill ("player_inside_eastHP");
	level.player SetFriendlyChain (chainEastHP_inside);
	
	level waittill ("easthp_complete");
	level.player SetFriendlyChain (chain_panzerdoor);
	
	level waittill ("panzer_door_open");
	level.player SetFriendlyChain (chain7);
	
	level waittill ("germans_outside_house_retreated");
	level.player SetFriendlyChain (chain8);
	
	//	chain for AI waiting near door
	level waittill ("player_inside_last_house");
	level.player SetFriendlyChain (last_house_chain);
	
//	chain for AI inside house
	level waittill ("fh_get_downstairs");
	level.player SetFriendlyChain (last_house_chain);
	

//	Chain to assault the church
//	level waittill ("house_back_door_open");
	
	level waittill ("player_left_last_house");
	level.player SetFriendlyChain (church_chain);
	
	//chain after the church is clear
	level waittill ("church_complete");
	level.player SetFriendlyChain (chain9);
}

	
//setup the friendly chain
putOnFriendlyChain()
{
	self.followmax = 2;
	self.followmin = -2;
	self setgoalentity (level.player);
	
}


intro()
{	
	corner_guy = getent ("corner_guy", "script_noteworthy");
	
	corner_guy.team = ("neutral");
	
	
	allies = getaiarray ("allies");
	
	for (i=0;i<allies.size;i++)
	{
		allies[i].goalradius = 4;
		allies[i] setgoalpos (allies[i].origin);
		allies[i] allowedstances ("stand");
	}
	
//	array_thread (getentarray ("friendly1", "targetname"), ::putOnFriendlyChain);
	
	level.randall.animname = "randall";
	wait 1;
	level.randall anim_single_solo(level.randall, "intro");
	
	//take the ai off the friendly chain
//	for (i=0;i<allies.size;i++)
	
	wait .05;		
	level notify ("intro_over");
	
	array_thread (getentarray ("friendly1", "targetname"), ::intro_chain_think);
	
	for (i=0;i<allies.size;i++)
	{
		allies[i].goalradius = 512;
		allies[i] allowedstances ("stand", "crouch", "prone");
	}
	
	corner_guy.team = ("allies");
	
}

intro_chain_think()
{
	wait (2 + randomfloat( 2));
	
	if (isalive (self) )
		self setgoalentity (level.player);


}


//reinforce the player again when he makes it to the barn
reinforcement_manager()
{	
	
	while (level.housesCleared < 3)
	{

		level waittill ("house_cleared");
		
		spawner_set1 = getentarray ("reinforcement_set1", "targetname");
		
		thread reinforcement_controller(spawner_set1);
	
	}
	
	//reinforcements at the road block
	level waittill ("player_at_roadblock");
	spawn_set_roadblock = getentarray ("reinforcement_roadblock", "targetname");
	thread reinforcement_controller(spawn_set_roadblock);
	
	//reinforcements after the mortar attack
	level waittill ("spawn_mortar_reinforcements");
	spawner_set2 = getentarray ("reinforcement_set2", "targetname");
	thread reinforcement_controller(spawner_set2);
	
	//reinforcements for the east hp
	level waittill ("spawn_eastHP_reinforcements");
	thread reinforcement_controller(spawner_set2);
	
	//reinforcements before the mg42 encounter
	level waittill ("start_mg42_firing");
	spawner_set3 = getentarray ("reinforcement_set3", "targetname");
	thread reinforcement_controller(spawner_set3);
	
	//reinforcements before the final house
	level waittill ("spawn_finalHouse_reinforcements");
	spawner_set4 = getentarray ("reinforcement_set4", "targetname");
	thread reinforcement_controller(spawner_set4);
	
	//reinforcements before the flak encounter
	level waittill ("finalHouse_reinforcements");
	thread reinforcement_controller(spawner_set4);
	
}
	

reinforcement_controller(spawner_set)
{	
	maxallies = 4;
	
	alive_allies = getaiarray ("allies");
			
	spawn_spots = (maxallies - alive_allies.size);
		
	if (spawn_spots <= 0)
		println ("Debug: Not sending any reinforcements");
	else
		println ("Debug: Sending in " +spawn_spots +" reinforcements");
		
	//spawn the AI
	for (i=0;i<spawn_spots;i++)
		spawner_set[i] thread reinforcement_think();

				
}


reinforcement_think()
{
	self.count = 1;	
	spawn = self dospawn();

	if (spawn_failed (spawn) )
		return;
		
	spawn.pathenemyfightdist = 350;
	spawn.pathenemylookahead = 350;	
	
	spawn endon ("death");
	
	spawn thread putOnFriendlyChain();
}


//First encounter
encounter_one()
{	
	trigger = getent ("encounter1_trigger", "targetname");
	trigger waittill ("trigger"	);
	
	array_thread (getentarray ("encounter1", "targetname"), ::encounter_one_think);
	
	//ai that is outside of the house
	array_thread (getentarray ("house1_trench", "targetname"), ::encounter_one_trench_think);
	
	//trigger 
	inside_trigger = getent ("house1_inside_trigger", "targetname");
	inside_trigger waittill ("trigger");
	
	flag_set ("player_entered_house1");	
	
	wait .05;
	thread encounter_one_counter();	
	
	//set a new friendly chain to they move into the house to clear it with you
	wait .05;
	level notify ("player_inside_house1");
	
	//spawn AI upstairs
	if (level.flag["house1_cleared"] == false)
		array_thread (getentarray ("house1_upstairs", "script_noteworthy"), ::encounter_one_think);
	
}

encounter_one_trench_think()
{
	//try to add some randomness so the AI doesn't congo line
	wait (4 + randomint( 2));
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
	
	spawn endon ("death");
}


encounter_one_think()
{
	self.count = 1;
	spawn = self dospawn();
	
	level.encounter1++;
	
	if (spawn_failed (spawn) )
	{
		level.encounter1--;
		return;
	}
	
	//clear their script_noteworthy so I can just get the spawners again later
	spawn.script_noteworthy = undefined;
	
	spawn endon ("death");
	
	spawn.anim_forced_cover = "show";
	
	spawn thread encounter_one_deathwaiter();
	
}

encounter_one_deathwaiter()
{
	self waittill ("death");
	level.encounter1--;
	
	thread encounter_one_counter();
}

encounter_one_counter()
{
	if ( (level.encounter1 == 0) && (level.flag["player_entered_house1"] == true) )
	{
		flag_set ("house1_cleared");
		level.housesCleared++;
		wait 1;
		thread autoSaveByName ("first_house_clear");
		level notify ("house_cleared");
	}
	
	if (level.housesCleared == 4)
		flag_set ("all_houses_cleared");
			
}


encounter_two()
{
	//get the trigger
	trigger = getent ("encounter2_trigger", "targetname");
	trigger waittill ("trigger");
	
	//get the spawn ents in an array
	array_thread (getentarray ("encounter2", "targetname"), ::encounter_two_think);
	
	//thread the 3rd encounter
	thread encounter_three();
	
	//trigger 
	inside_trigger = getent ("house2_inside_trigger", "targetname");
	inside_trigger waittill ("trigger");	
	
	spawner_set1 = getentarray ("reinforcement_set1", "targetname");
	thread reinforcement_controller(spawner_set1);
	
	flag_set ("player_entered_house2");	
	
	//spawn more AI upstairs so there is action
	array_thread (getentarray ("house2_upstairs", "script_noteworthy"), ::encounter_two_think);
	
	wait .05;
	thread encounter_two_counter();	
	
	//set a new friendly chain to they move into the house to clear it with you
	wait .05;
	level notify ("player_inside_house2");
	

	
	
}

encounter_two_think()
{
	self.count = 1;
	
	spawn = self dospawn();
	
	level.encounter2++;
	
	if (spawn_failed (spawn) )
	{
		level.encounter2--;
		return;
	}
	
	//clear the script noteworthy off the guys so I can just get the spawners again 
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "house2_upstairs") )
		spawn.script_noteworthy = undefined;
	
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "house2_mg42guy") )
		spawn thread encounter_two_mg42_deathwaiter();
	
	spawn endon ("death");
	
	spawn.anim_forced_cover = "show";
	
	spawn thread encounter_two_deathwaiter();
	
}

encounter_two_deathwaiter()
{
	self waittill ("death");
	level.encounter2--;
	
	thread encounter_two_counter();
}

encounter_two_mg42_deathwaiter()
{
	self waittill ("death");
	
	wait .05;
	level notify ("house2_mg42_gunner_dead");	

}

encounter_two_counter()
{
	if ( (level.encounter2 == 0) && (level.flag["player_entered_house2"] == true) )
	{
		flag_set ("house2_cleared");
		level.housesCleared++;
		wait 1;
		thread autoSaveByName ("second_house_clear");
		level notify ("house_cleared");
	}
	
	if (level.housesCleared == 4)
		flag_set ("all_houses_cleared");
		 		
		
}


encounter_three()
{
	//spawn some germans with a trigger is hit
	trigger = getent ("encounter3_trigger", "targetname");
	trigger waittill ("trigger");
	
	//FIXME - figure out WTF this is for
//	flag_set ("enable_counter1");
	
	//get the spawn ents in an array
	array_thread (getentarray ("encounter3", "targetname"), ::encounter_three_think);
	
	thread encounter3_trench();
			
	thread encounter_four();
	
	//trigger 
	inside_trigger = getent ("house3_inside_trigger", "targetname");
	inside_trigger waittill ("trigger");
	
	flag_set ("player_entered_house3");	
	
	spawner_set1 = getentarray ("reinforcement_set1", "targetname");
	thread reinforcement_controller(spawner_set1);
	
	
	
	//set a new friendly chain to they move into the house to clear it with you
	wait .05;
	level notify ("player_inside_house3");
	
	//spawn more AI upstairs so there is action
	array_thread (getentarray ("house3_upstairs", "script_noteworthy"), ::encounter_three_think);
	wait .05;
	thread encounter_three_counter();	

}

encounter_three_think()
{
	self.count = 1;
	spawn = self dospawn();
	
	level.encounter3++;
	
	if (spawn_failed (spawn) )
	{
		level.encounter3--;
		return;
	}
	
	spawn endon ("death");
	
	//clear the script noteworthy off the guys so I can just get the spawners again 
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "house3_upstairs") )
		spawn.script_noteworthy = undefined;
	
	spawn.anim_forced_cover = "show";
	
	spawn thread encounter_three_deathwaiter();
	
}

encounter_three_deathwaiter()
{
	self waittill ("death");
	level.encounter3--;
	
	thread encounter_three_counter();
}

encounter_three_counter()
{
	if ( (level.encounter3 == 0) && (level.flag["player_entered_house3"] == true) )
	{
		flag_set ("house3_cleared");
		level.housesCleared++;
		wait 1;
		thread autoSaveByName ("third_house_clear");
		level notify ("house_cleared");
	}
	
	if (level.housesCleared == 4)
		flag_set ("all_houses_cleared");
		
}

encounter3_trench()
{
	trigger = getent ("trench3_trigger", "targetname");
	trigger waittill ("trigger");
	
	array_thread (getentarray ("encounter3_trench", "targetname"), ::encounter3_trench_think);
		
	
}

encounter3_trench_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
	
	spawn endon ("death");
	
	//wait a while then attack the player
	wait 15;
	
	spawn setgoalentity (level.player);
	
	
}

encounter_four()
{
	
	//get the spawn ents in an array
	array_thread (getentarray ("encounter4", "targetname"), ::encounter_four_think);
	
	inside_trigger = getent ("house4_inside_trigger", "targetname");
	inside_trigger waittill ("trigger");	
	
	flag_set ("player_entered_house4");
	
	//set a new friendly chain to they move into the house to clear it with you
	wait .05;
	level notify ("player_inside_house4");
	
	//spawn more AI upstairs so there is action
	array_thread (getentarray ("house4_upstairs", "script_noteworthy"), ::encounter_four_think);
	
	thread encounter_four_counter();	
	
	
}
encounter_four_think()
{
	self.count = 1;
	spawn = self dospawn();
	
	level.encounter4++;
	
	if (spawn_failed (spawn) )
	{
		level.encounter4--;
		return;
	}
	
	spawn endon ("death");
	
	//clear the script noteworthy off the guys so I can just get the spawners again 
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "house4_upstairs") )
		spawn.script_noteworthy = undefined;
	
	spawn.anim_forced_cover = "show";
	
	spawn thread encounter_four_deathwaiter();
	
}

encounter_four_deathwaiter()
{
	self waittill ("death");
	level.encounter4--;
	
	thread encounter_four_counter();
}

encounter_four_counter()
{
	if ( (level.encounter4 == 0) && (level.flag["player_entered_house4"] == true) )
	{
		flag_set ("house4_cleared");
		level.housesCleared++;
		wait 1;
		thread autoSaveByName ("fourth_house_clear");
		wait .05;
		level notify ("house_cleared");
		objective_additionalposition(0, 3, (0,0,0));
	}
	
	if (level.housesCleared == 4)
		flag_set ("all_houses_cleared");
		
}

assemble_with_randall()
{
	
	//give randall a goal node
	node = getnode ("randall_assemble_node", "targetname");
	
	level.randall.goalradius = 4; 
	level.randall setgoalnode (node);
	
	
	//waittill randall is at this node
	level.randall waittill ("goal");	
	
	trigger = getent ("meeting1_trigger", "targetname");
	trigger waittill ("trigger");
	
	wait .05;
	level notify ("player_at_roadblock");

	battleChatterOff( "allies" );
	level.randall anim_single_solo(level.randall, "blocked");
	battleChatterOn( "allies" );
	
	wait .05;
	level notify ("randall_done_talking");
	
	thread autoSaveByName ("before_mortars");
	
	
	level waittill ("mortar_building_hit_done");
	
	//put randall back on the friendly chain
	level.randall thread putOnFriendlyChain();
	

	//spawn some guys in the trench
//	array_thread (getentarray ("mortar_ai_trench", "targetname"), ::mortar_ai_think);
		
}

ranger_mg_guy_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
	
	spawn endon ("death");
	
	thread mg_guy_dialogue();
	
	
	
	level waittill ("easthp_complete");
	
	spawn putOnFriendlyChain();
	
	
//	spawn delete();
		
}

mg_guy_dialogue()
{
	battlechatterOff ("allies");
	
	wait 4;
	
	level.randall anim_single_solo (level.randall, "setupMG");
	
	battlechatterOn ("allies");

}


smoke_grenade_throw()
{

	trigger = getent ("smoke_trigger", "targetname");
	trigger waittill ("trigger");	
	
	//spawn some more AI
	array_thread (getentarray ("encounter3_retreat", "targetname"), ::encounter3_trench_think);
	
		
	//send randall to his node to throw a smoke
	
	if (level.flag["house3_cleared"] == false || level.flag["house4_cleared"] == false)
	{
		node = getnode ("randall_smoke_node", "targetname");
		level.randall setgoalnode (node);
		
		level.randall.oldgoalradius = level.randall.goalradius;
		level.randall.goalradius = 4;
		level.randall waittill ("goal");
		level.randall allowedstances ("crouch");
		
		//get the end pos for the nade
		nadeEnd = getent ("smoke_grenade", "targetname");
		
		//give randall smoke grenades
		level.randall.grenadeWeapon = "smoke_grenade_american_night";
		level.randall.grenadeAmmo++;
		
		//throw the nade
		node thread anim_single_solo (level.randall, "smoke_throw"); 
		level.randall waittillmatch ("single anim", "fire");
		
		nadeStart = level.randall gettagorigin("TAG_WEAPON_RIGHT");	
	
		level.randall magicgrenade (nadeStart, nadeEnd.origin);
		
		battleChatterOff( "allies" );
		
		level.randall anim_single_solo (level.randall, "smoke_screen");
		
		battleChatterOn( "allies" );
		
		//give randall reg grenades again
		level.randall.grenadeWeapon = "fraggrenade";
		level.randall.grenadeAmmo++;
		
		//put randall back on the friendly chain
		level.randall.goalradius = level.randall.oldgoalradius;
		level.randall allowedstances ("stand", "crouch", "prone");
		level.randall putOnFriendlyChain();
	}	
	

}	

mortar_ai_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
		return;
	
	spawn endon ("death");
	
}
	

mortar_attack()
{
	//get the brush models for the wall
	wall_before = getent ("mortar_wall_before", "targetname");
	wall_after = getent ("mortar_wall_after", "targetname");
	
	//hide the destoryed version
	wall_after hide();
	
	//get the target for the mortar
	wall_mortar_target = getent ("mortar_wall_target", "targetname");
	
	
	level waittill ("randall_done_talking");
	

	wall_mortar_target maps\_mortar::activate_mortar(0, 0, 0, .5, undefined, undefined, false);
	
	//get the trigger near the explosion
	
	//FIXME - shellshock if the player is touching the trigger
	thread maps\_shellshock::main(.5, 15, 2, 5);
	
	wall_before delete();
	wall_after show();
	
	
	wait .5;
	level notify ("mortar_building_hit_done");
	
	thread mortar_dialogue();
	
//	eTrigger = getent ("mortar_trigger", "targetname");
//	eTrigger waittill ("trigger");
	
	level notify ("start_mortars1");
	
	thread encounter5();
	
	wait 15;
	
	level notify ("spawn_mortar_reinforcements");
	
	
	//stop the mortars
	level notify ("stop_mortars1");
	
	//start the mortars again, but with a longer delay
	thread maps\_mortar::generic_style("mortar2", 7, undefined, undefined, 400, 6000, undefined);
//	generic_style (strExplosion, fDelay, iBarrageSize, fBarrageDelay, iMinRange, iMaxRange, bTargetsUsed)		
		
	wait .05;	
	level notify ("start_mortars2");	
	
	level waittill ("stop_the_mortars");
	
	wait .05;
	level notify ("stop_mortars2");

	
	
}

mortar_dialogue()
{
	wait 1;
	battleChatterOff( "allies" );
	level.randall anim_single_solo(level.randall, "mortars");
	
	wait 1;
	level.randall anim_single_solo(level.randall, "dont_stop");
	
	wait 1;
	level.randall anim_single_solo(level.randall, "keep_moving");	
	battleChatterOn( "allies" );
}

//this is the house after the mortar attack
encounter5()
{
//	eTrigger = getent ("encounter5_trigger", "targetname");
//	eTrigger waittill ("trigger");

	
	//get the spawners
	aSpawners = getentarray ("encounter5", "targetname");
	
	aSpawners_trench = getentarray ("encounter5_trench", "targetname");
	//spawn 
	//FIXME - need a spawn_failed check
	for (i=0;i<aSpawners.size;i++)
		aSpawners[i] dospawn();
	
	//FIXME - need a spawn failed check
	for (i=0;i<aSpawners_trench.size;i++)
		aSpawners_trench[i] dospawn();	
	
	
	//TEMP FIXME - AI needs to kick the gate open
	mortar_gate = getent ("mortar_gate", "targetname");
	mortar_gate rotateyaw(90,.5,.2,.2);
	mortar_gate connectpaths();
	
//	thread mortar_kickgate();	
	thread encounter6();
	thread encounter7();
	thread basement_guys();
}


//FIXME - AI doesn't kick this open, hacked around it
mortar_kickgate()
{
	gate_kicker_spawner = getent ("encounter5_trench_gate", "targetname");
	
	//FIXME need a spawn failed check
	guy[0] = gate_kicker_spawner dospawn();
	
	gate_node = getnode ("mortar_gate_node", "targetname");
	
//	closestAI = maps\_utility::getClosestAI (level.player getorigin(), "axis" );
	
//	guy[0] = closestAI;
	guy[0].animname = "left";
	guy[0].anim_node = gate_node;
//	guy[0] notify ("stop friendly think");
	
	level maps\_anim::anim_reach (guy, "kickdoor", undefined, gate_node);
//	guy[0] pushPlayer (false);
	gate_node thread maps\_anim::anim_single (guy, "kickdoor");
	
	guy[0] waittillmatch ("single anim", "soundfx = kickdoor");
	
//	guy[0] thread putOnFriendlyChain();
		
	mortar_gate = getent ("mortar_gate", "targetname");
	mortar_gate playsound ("wood_door_kick");
	
	mortar_gate rotateyaw(90,.5,.2,.2);
	
	mortar_gate connectpaths();
	
	guy[0] waittillmatch ("single anim", "end");
//	guy[0] pushPlayer (true);
	
}

encounter6()
{
	aSpawners = getentarray ("encounter5", "targetname");
	
	//spawn 
	//FIXME need a spawn failed check
	for (i=0;i<aSpawners.size;i++)
		aSpawners[i] dospawn();
		
}

basement_guys()
{
	
	//get the trigger
	eTrigger = getent ("encounter7_trigger", "targetname");
	eTrigger waittill ("trigger");
	
	//spawn
	array_thread (getentarray ("basement_guy", "targetname"), ::basement_guys_think);
	
	
}

basement_guys_think()
{
	
	//spawn the guys
	spawn = self dospawn();
	

	if (spawn_failed (spawn) )
		return;
		
	spawn endon ("death");	
	
	
	//wait a while before setting the goal ent to level.player	
	wait 15;
	
	spawn setgoalentity (level.player);
	

}

//this is the east hard point
encounter7()
{
	thread panzer_door();
	
	eTrigger = getent ("encounter7_trigger", "targetname");
	eTrigger waittill ("trigger");
	
	level notify ("spawn_eastHP_reinforcements");
	
	//get the spawners
	array_thread (getentarray ("encounter7", "targetname"), ::encounter_7_think);
	
	
	thread easthp_dialogue();
	

	//waittill player is inside
	inside_trigger = getent ("easthp_inside_trigger", "targetname");
	inside_trigger waittill ("trigger");
	
	array_thread (getentarray ("easthp_upstairs", "script_noteworthy"), ::encounter_7_think);
	
	flag_set ("player_inside_eastHP");
	
	wait .05;
	level notify ("player_inside_eastHP");
	thread encounter_7_counter();
	
	//waittill encounter 7 is cleared out
	level waittill ("easthp_complete");
	
	wait 3;
	
	battleChatterOff( "allies" );
	level.randall thread anim_single_solo(level.randall, "good_work");
	battleChatterOn( "allies" );
	
	thread autosavebyname ("east_hp_clear");
	
	wait .05;
	level notify ("randall_moving_to_panzer_door");	
	

		
}

encounter_7_think()
{
	spawn = self dospawn();
	
	level.encounter7++;
	
	if (spawn_failed (spawn) )
	{
		level.encounter7--;
		return;
	}
	
	spawn endon ("death");
	
	spawn.anim_forced_cover = "show";
	
	//clear the script noteworthy off the guys so I can just get the spawners again 
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "easthp_upstairs") )
		spawn.script_noteworthy = undefined;
	
	spawn thread encounter_7_deathwaiter();
	
}

encounter_7_deathwaiter()
{
	self waittill ("death");
	level.encounter7--;
	
	thread encounter_7_counter();
}

encounter_7_counter()
{
	if ( (level.encounter7 == 0) && (level.flag["player_inside_eastHP"] == true) )
	{
		wait 3;
		level notify ("easthp_complete");			
	}

		
}

easthp_dialogue()
{
	battlechatterOff ("allies");
	
	level.randall anim_single_solo (level.randall, "eastHP");
	
	battlechatterOn ("allies");

}

//this is the house that gets hit with the panzershcrek
encounter9()
{
	
	//wait for the wall to be destoryed
	level waittill ("panzer_fired");
	wait .05;  //FIXME code bug work around


	//get the spawners
	array_thread (getentarray ("encounter9", "targetname"), ::encounter_9_think);
	
	thread finalHouse_encounter();
	thread finalHouse_Setup();
	thread finalHouse_german_dialogue();


}

encounter_9_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )	
		return;
	
	spawn endon ("death");
	
	wait 15;
	
	spawn setgoalentity (level.player);

	
}

panzer_door()
{
	level waittill ("randall_moving_to_panzer_door");
	
	trigger = getent ("panzer_door_trigger", "targetname");
	trigger waittill ("trigger");
	
	door = getent ("panzer_door", "targetname");	
	door_node = getnode ("pdoor_node", "targetname");
	
	level.randall.animname = "left";
	
	door_node anim_reach_solo (level.randall, "kickdoor");
	
	door_node thread anim_single_solo(level.randall, "kickdoor");
	
	level.randall waittillmatch ("single anim", "soundfx = kickdoor");
	
	door playsound ("wood_door_kick");		
	door rotateyaw(-90,.5,.2,.2);
	
	wait .5;
	
	door connectpaths();
	
	level.randall.animname = "randall";
	
	wait .05;
	level notify ("panzer_door_open");
	
	level.randall putOnFriendlyChain();
	
	
	
}
	

//Panzerschreck firing at the side of a building
panzer_encounter()
{
	//get the walls that will be destoryed
	wall_before = getent ("wall_panzer_before", "targetname");
	wall_after = getent ("wall_panzer_after", "targetname");
	
	wall_after hide();
	
	
	//waittill the player clears the east HP
	level waittill ("easthp_complete");
	
	//get the spawners
	panzer_support_spawners = getentarray ("panzer_support", "targetname");
	
	panzer_guy_spawner = getent ("panzer_guy", "targetname");
	
	
	//get the node the panzer guy will start at
	
	//get the node the panzer guy will fire from
	panzer_fire_node = getnode ("panzer_fire_node", "targetname");

	//spawn the friendlys
	panzer_support_1 = getent ("panzer_support_1", "targetname");
	
	//FIXME - need a spawn failed check
	panzer_support_guy1 = panzer_support_1 dospawn();
		
	if (spawn_failed (panzer_support_guy1) )
		assertMsg("^2{Panzer support 1 failed to spawn");
	
	panzer_support_2 = getent ("panzer_support_2", "targetname");
	
	//FIXME - need a spawn failed check
	panzer_support_guy2 = panzer_support_2 dospawn();
		
	if (spawn_failed (panzer_support_guy2) )
		assertMsg("^2{Panzer support 2 failed to spawn");

	
	//FIXME - need a spawn_failed check
	panzer_guy = panzer_guy_spawner dospawn();
	
	if (spawn_failed (panzer_guy) )
		assertMsg("^2{Panzer guy failed to spawn");

	//give the friendlys a small goal radius
	panzer_guy.goalradius = 4;
	panzer_support_guy1.goalradius = 4;
	panzer_support_guy2.goalradius = 4;
	
	panzer_guy setgoalpos (panzer_guy.origin);
	panzer_support_guy1 setgoalpos (panzer_support_1.origin);
	panzer_support_guy2 setgoalpos (panzer_support_2.origin);
	
	//magic bullet shield the panzer guy
	panzer_guy thread maps\_utility::magic_bullet_shield();
	
	//get the trigger so the event doesnt start until the player is close
	start_trigger = getent ("panzer_start_trigger", "targetname");

	start_trigger waittill ("trigger");
	
	level notify ("panzer_event_starting");
	
	//make the guy fire his panzershreck
	panzer_target = getent ("panzer_target", "targetname");
	
	//spawn the zombie guy	
	getent("zombie","targetname") thread zombieGuy();
	
	//panzer_guy.team = ("neutral");
	panzer_guy.grenadeawareness = 0;
	level maps\_spawner::panzer_target( panzer_guy, panzer_fire_node, panzer_target.origin);
	panzer_guy.anim_dropPanzer = true;
   	println ("panzer fired!");
	level notify ("panzer_fired");
	
	panzer_guy thread panzer_guy_think();
	
	
	//delete the before wall
	wait .5;
	
//	maps\_fx::loopfx( "pshreck_smoke", (-14280,1808,10376), 1);
	wall_before hide();
	wall_before connectpaths();
	wall_before delete();
	
	//unhide the after wall
	wall_after show();

	//Play wall explosion effects
	exploder(1);	
	
	wait 3;
	
	//put those friendlys on the chain
	if (isalive (panzer_support_guy1) )
		panzer_support_guy1 thread putOnFriendlyChain();
	
	if (isalive (panzer_support_guy2) )
		panzer_support_guy2 thread putOnFriendlyChain();
	
		
}

panzer_guy_think()
{
	self endon ("death");
	//set health to 1
	self.health = 1;
	self.grenadeawareness = 1;
	
	self putOnFriendlyChain();
	
	//turn off magic bullet shield
	self notify ("stop magic bullet shield");
	
}
		

#using_animtree("generic_human");
zombieGuy()
{
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
	spawn endon ("death");
	spawn.health = 100000;
	
	spawn.goalradius = 4;
	spawn.goalheight = 4;	
	spawn setgoalpos (spawn.origin);
	
	spawn thread zombieBurn("J_Spine3", level._effect["torso"], .2);
	spawn thread zombieBurn("J_Wrist_RI", level._effect["arms"], .1);
	spawn thread zombieBurn("J_Wrist_LE", level._effect["arms"], .1);

	level waittill ("panzer_fired");
	
	spawn.anim_disablePain = true;
//	spawn animscripts\shared::PutGunInHand("none");
	spawn.ignoreme = true;
	spawn.run_combatanim = %duhoc_german_shellshocked_walk;
	spawn.anim_combatrunanim = %duhoc_german_shellshocked_walk;
	spawn setexceptions(animscripts\run::InfiniteMoveStandCombatOverride);
	
	
	wait .5;
	
	node = getnode  (spawn.target, "targetname");
	spawn setgoalnode (node);
	

	wait (4);
	spawn.ignoreme = false;
	spawn.anim_disablePain = false;
	spawn.health = 50;
	
	
	spawn waittill ("death");
	
	wait .05;
	level notify ("zombie_dead");
}

		

zombieBurn(tag, fxName, loopTime)
{
	while(isalive(self))
	{
		playfxOnTag (fxName, self, tag);
		wait (loopTime);
	}
}
	


//FIX ME
//house assault - this is where randall gives the order to kick the door open and frag the germans
finalHouse_Setup()
{
	
	
	flag_wait ("mg42_gunner_dead");
	
	flag_wait ("ai_outside_out_clear");
	
	
	//get the trigger in front of the house
	trigger = getent ("final_house_trigger", "targetname");
	trigger waittill ("trigger");
	
	thread house_randall_dialogue();
	
	level notify ("spawn_finalHouse_reinforcements");
	
	wait 1;
	
	thread autosavebyname ("before_house_encounter");
	
	
	//put them on their correct nodes
	//nodes
	randall_node = getnode ("fh_randall_node", "targetname");
	grenade_node = getnode ("fh_grenade_node", "targetname");
	doorkick_node = getnode ("fh_doorkick_node", "targetname");

	//send AI to their nodes	
	level.randall.team = ("neutral");
	
	allies = getaiarray ("allies");
	
	grenade_guy = allies[0]; 
	doorkick_guy = allies[1];
	
	level.randall.team = ("allies");
	
	grenade_guy.goalradius = 4;
	grenade_guy setgoalnode (grenade_node);
	
	guy[0] = level.randall;
	guy[1] = doorkick_guy;
	guy[2] = grenade_guy;
	
	guy[0].goalradius = 4;
	guy[1].goalradius = 4;
	
	guy[0].animname = "randall";
	guy[0] notify ("stop friendly think");
	guy[0].anim_node = randall_node;
	
	guy[1].animname = "kicker";
	guy[1] notify ("stop friendly think");
	guy[1].anim_node = doorkick_node;
	guy[1] thread maps\_utility::magic_bullet_shield();
	
	guy[2].animname = "grenade_guy";
	guy[2].grenadeawareness = 0;
	guy[2].anim_node = grenade_node;
	guy[2] notify ("stop friendly think");
	guy[2] thread maps\_utility::magic_bullet_shield();
	
	
	level anim_reach (guy, "run_to_door");
	
	thread throw_grenades(guy[2], grenade_node);
	
	//wait for start trigger
//	start_trigger waittill ("trigger");
	
	

	randall_node thread anim_single_solo(level.randall, "randall_doorkick_yell");
	guy[0] waittillmatch ("single anim", "start_kick_anim");
	
	thread doorKicker(guy[1], doorkick_node);
	
	level waittill ("grenades_thrown");
	
	wait 2;
	guy[0] putOnFriendlyChain();
	
	if (isalive (guy[1]) )
		guy[1] putOnFriendlyChain();
	
	if (isalive (guy[2]) )
		guy[2] putOnFriendlyChain();

}

house_randall_dialogue()
{
	//play randalls dialogue
	battleChatterOff( "allies" );
	level.randall anim_single_solo(level.randall, "listen_up");
	battleChatterOn( "allies" );
	
	wait .05;
	level notify ("add_flak_house_objective");
	
}

	
doorKicker(guy, node)
{
	guy.goalradius = 4;
	
	guy.animname = "kicker";
	guy notify ("stop friendly think");
	guy.anim_node = node;
	
	node thread anim_single_solo(guy, "fh_kickdoor");
	
	//kick open the door
	fh_door = getent ("fh_frontdoor", "targetname");
	
	guy waittillmatch ("single anim", "soundfx = kickdoor");
	
	fh_door playsound ("wood_door_kick");	
	fh_door rotateyaw(-90,.5,.2,.2);
	
	level notify ("door_is_open");
	
	guy notify ("stop magic bullet shield");
	
	wait .5;
	
	fh_door connectpaths();

			
}	

throw_grenades(guy, node)
{
	
	node thread anim_loop_solo (guy, "grenade_idle", undefined, "stop_grenade_idle");
		
	//waittill the door is open
	level waittill ("door_is_open");
	
	guy allowedstances ("crouch");
	
	guy notify ("stop_grenade_idle");
	
	wait .5;
	
	node thread anim_single_solo(guy, "grenade_throw_crouch");
	guy waittillmatch("single anim", "fire");
				
	nadeStart = guy gettagorigin("TAG_WEAPON_RIGHT");	
	nadeEnd = getent("magic_grenade1","targetname");
	
	guy magicgrenade (nadeStart, nadeEnd.origin, 1.5);
	
	wait 1;
	
	node thread anim_single_solo(guy, "grenade_throw_crouch");
	guy waittillmatch("single anim", "fire");
	
	guy magicgrenade (nadeStart, nadeEnd.origin, 1.5);
	
	wait .05;
	level notify ("grenades_thrown");
	
	wait 1.5;
	guy.grenadeawareness = 1;
	
	wait 2;
		
	level.randall anim_single_solo(level.randall, "go");
	
	guy allowedstances ("stand", "crouch", "prone");
	
	guy notify ("stop magic bullet shield");
	
	
	
}

//This is the house that gets the door kicked open
finalHouse_encounter()
{	
	thread mortar_guys();
	
	//these are the germans outside the house
	array_thread (getentarray ("encounter10_outside", "targetname"), ::finalHouse_outside_think);
	
	mg42_gunner = getent ("house_mg42_gunner", "targetname");
	mg42_gunner thread mg42_gunner_think();
	
	level.finalHouse = 0;
	
	
	level waittill ("germans_outside_house_are_dead");
	//spawn 
	array_thread (getentarray ("encounter10", "targetname"), ::finalHouse_think);
	
	//get the trigger to know if the player is inside
	trigger = getent ("finalhouse_inside_trigger", "targetname");
	trigger waittill ("trigger");
	
	//notify the player is inside the house to set a new friendly chain
	wait .05;
	level notify ("player_inside_last_house");
	


		
}

finalHouse_german_dialogue()
{
	
	trigger = getent ("final_house_dialogue_trigger", "targetname");
	trigger waittill ("trigger");
	
	battlechatterOff ("axis");
	
	level playsoundinspace("bergstein_german_holedup1",(-11944, 3574, 10428));
	
	wait .5;
	
	level playsoundinspace("bergstein_german_holedup2",(-11944, 3574, 10428));
	
	wait .5;
	
	level playsoundinspace("bergstein_german_holedup3",(-11944, 3574, 10428));
	
	wait .5;
	
	level playsoundinspace("bergstein_german_holedup4",(-11944, 3574, 10428));
	
	battlechatterOn ("axis");
	
}

finalHouse_outside_think()
{
	
	//FIXME - need a spawn failed check
	spawn = self dospawn();
	
	level.germansOutsideHouse++;
	
	if (spawn_failed (spawn) )
	{
		level.germansOutsideHouse--;
		return;
	}
		
	spawn endon ("death");
	
	first_node = getnode (spawn.target, "targetname");
	
	spawn setgoalnode (first_node);
	
	next_node = getnode (first_node.target, "targetname");
	
	spawn thread finalHouse_outside_deathwaiter();
	
	level waittill ("mg42_gunner_dead");
	
	level notify ("germans_outside_house_retreated");
	
	spawn.goalradius = next_node.radius;
	spawn setgoalnode (next_node);
	
}

finalHouse_outside_deathwaiter()
{
	self waittill ("death");
	
	level.germansOutsideHouse--;
	
	thread finalHouse_outside_counter();
}

finalHouse_outside_counter()
{
	if (level.germansOutsideHouse == 0)
	{
		flag_set ("ai_outside_out_clear");
		wait .05;
		level notify ("germans_outside_house_are_dead");
	}
}	
	
mg42_gunner_think()
{
	spawn = self dospawn();
	
	if (spawn_failed (spawn) )
	{
		level notify ("mg42_gunner_dead");
		return;
	}
		
	spawn endon ("death");
	spawn thread mg42_gunner_deathwaiter();
	
	spawn.ignoreme = true;
	
	spawn.anim_disableLongDeath = true;
	
	turret = getent ("mg42", "script_noteworthy");
	aeTargets = getentarray ("mg42_target", "targetname");
	
	
	thread mg42_dialogue(spawn);
	
	level waittill ("start_mg42_firing");
	spawn thread mg42_controller(aeTargets,turret);
	
	
}

mg42_gunner_deathwaiter()
{
	self waittill ("death");
	
	flag_set ("mg42_gunner_dead");
}

mg42_controller(aeTargetSet, eTurret)
{
	while (isalive (self))
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

mg42_dialogue(mg42_gunner)
{
	//get the trigger
	trigger = getent ("mg42_dialogue_trigger", "targetname");
	
	trigger waittill ("trigger");
	
	//stop the mortars
	wait .05;
	level notify ("stop_the_mortars");
	
	//notify the mg42 to start firing
	wait .05;
	level notify ("start_mg42_firing");
	
	wait 1;	
	
	//define ranger 1 and 2
	level.randall.team = ("neutral");
	
	allies = getaiarray ("allies");
	
	level.randall.team = ("allies");
	
	ranger1 = allies[0];
	ranger2 = allies[1];
	
	ranger1.animname = "ranger1";
	ranger2.animname = "ranger2";
	
	//magic bullet shield untill they are done with their dialogue
	ranger1 thread maps\_utility::magic_bullet_shield();
	ranger2 thread maps\_utility::magic_bullet_shield();
	
	battleChatterOff( "allies" );
	
	if (isalive (mg42_gunner) )
		ranger1 anim_single_solo (ranger1, "look_out");
	
	wait 1;
	if (isalive (mg42_gunner) )
		ranger2 anim_single_solo (ranger2, "get_back");
	

	//turn off the magic bullet shield for ranger 1 and 2
	ranger1 notify ("stop magic bullet shield");
    ranger2 notify ("stop magic bullet shield");
    
	wait .5;
	
	if (isalive (mg42_gunner) )
	{
		battleChatterOff( "allies" );
		level.randall anim_single_solo (level.randall, "takeout_mg42");
		battleChatterOn( "allies" );
	}
	
	wait 1;
	if (isalive (mg42_gunner) )
	{
		battleChatterOff( "allies" );
		level.randall anim_single_solo (level.randall, "lets_go");
		battleChatterOn( "allies" ); 
		
		level waittill ("mg42_gunner_dead");
		
		wait 1;
		
		battleChatterOff( "allies" );
		level.randall anim_single_solo (level.randall, "move_up");
		battleChatterOn ("allies");   		
	}
	
	else 
	{
		battleChatterOff( "allies" );
		level.randall anim_single_solo (level.randall, "move_up");		
	 	battleChatterOn ("allies");
	 }
	
		
}

	
finalHouse_think()
{
	//spawn AI
	spawn = self dospawn();
	
	level.finalHouse++;
	
	if (spawn_failed (spawn) )
	{
		level.finalHouse--;
		return;
	}
	
	spawn endon ("death");
	
	spawn.anim_forced_cover = "show";
	spawn.anim_disableLongDeath = true;
	
	spawn thread fianlHouse_deathwaiter();

}

fianlHouse_deathwaiter()
{
	self waittill ("death");
	level.finalHouse--;
	
	thread finalHouse_counter();
}

finalHouse_counter()
{
	if (level.finalHouse == 0)
	{	
		
		wait 3;
		level notify ("final_house_clear");
		
		//temp print - FIXME
		println ("House is clear!!!");
		
		 
		
		thread autosavebyname ("before_church");
		
		thread finalHouse_dialogue();
		
	}
				
}


finalHouse_dialogue()
{
	
	//make sure i have a ranger 1 and 2
	wait .05;
	level notify ("finalHouse_reinforcements");
	
	wait 1;
	
	//send the friendlys to their nodes
	ranger1_node = getnode ("ranger1_flak_node", "targetname");
	ranger2_node = getnode ("ranger2_flak_node", "targetname");
		
	level.randall.team = ("neutral");
	
	allies = getaiarray ("allies");
	
	ranger1 = allies[0];
	ranger2 = allies[1];
	
	level.randall.team = ("allies");
	
	ranger1 setgoalnode (ranger1_node);
	ranger2 setgoalnode (ranger2_node);
	
	ranger1.animname = "ranger1";
	ranger2.animname = "ranger2";
	
	ranger1 thread magic_bullet_shield();
	ranger2 thread magic_bullet_shield();
	
	ranger1 waittill ("goal");
	
	//turn battle chatter off
	battleChatterOff( "allies" );
	
	wait .5;
	
	if (level.flag["mortar_krew_dead"] == false)
	{
		//Ranger5: Kraut mortar in the church yard!
		ranger1 anim_single_solo (ranger1, "kraut_mortar");
	
		wait 1;
		//Randall: Silence out those mortars! 
		level.randall anim_single_solo (level.randall, "silence_mortars");
		wait 1;
	
	}
	
	
	//Randall: We've got to clear that church. Taylor, take point!
	level.randall anim_single_solo (level.randall, "clear_church");
	
	
	//send the AI downstairs
	wait .05;
	level notify ("fh_get_downstairs");
	
	//put randall and ranger2 back on the friendly chain
	level.randall thread putOnFriendlyChain();
	ranger2 thread putOnFriendlyChain();
	ranger1 thread putOnFriendlyChain();
	
	
	battleChatterOn( "allies" );
	
		
	//send the AI to the front door
	ranger1_door_node = getnode ("fh_doorkick_node2", "targetname");
	
	ranger1.animname = "left";
	ranger1.anim_node = ranger1_door_node;
	
	//this turns on the chain to wait near the door
	level notify ("wait_near_door");
	
	ranger1_door_node anim_reach_solo (ranger1, "kickdoor");
	
	//wait for the player to get close to the front door
	front_door_trigger = getent ("flak_house_frontdoor_trigger", "targetname");
	front_door_trigger waittill ("trigger");
	
	//kick open the door
	ranger1_door_node thread anim_single_solo (ranger1, "kickdoor");
	
	open_door(ranger1);
	
	//turn off the magic bullet shields
	ranger1 notify ("stop magic bullet shield");
	ranger2 notify ("stop magic bullet shield");
	
	//set the new friendly chain
	level notify ("house_back_door_open");
	
	//put ranger1 back on the friendly chain
	ranger1 thread putOnFriendlyChain();
	
	thread church_encounter();
	
	
	
	
}


open_door(guy)
{
	guy waittillmatch ("single anim", "soundfx = kickdoor");
	
	door = getent ("fh_backdoor", "targetname");
	door playsound ("wood_door_kick");	
	door rotateyaw(-90,.5,.2,.2);
	
	wait .5;
	
	door connectpaths();
	
	//trigger 
	trigger = getent ("player_left_last_house_trigger", "targetname");
	
	trigger waittill ("trigger");
	
	//friendly chain notify
	wait .05;
	level notify ("player_left_last_house");
}
	
mortar_guys()
{

	level.mortar_guys = 0;
	
	level waittill ("player_inside_last_house");
	
	array_thread (getentarray ("mortar_crew", "targetname"), ::mortar_guys_think);
	
}

mortar_guys_think()
{
	spawn = self dospawn();
	
	level.mortar_guys++;
	
	if (spawn_failed (spawn) )
	{
		level.mortar_guys--;
		return;
	}
	
	spawn endon ("death");
	
	spawn thread mortar_guys_deathwaiter();
	
}

mortar_guys_deathwaiter()
{
	self waittill ("death");
	level.mortar_guys--;
	
	thread mortar_guys_counter();
}	


mortar_guys_counter()
{

	if (level.mortar_guys == 0)
	{
		wait 2;
		level notify ("mortar_crew_dead");
		
		//add the objective to take over the church
		wait .05;
		level notify ("add_church_objective");
		flag_set ("mortar_krew_dead");
	}


}

panzerwerfer()
{
	glow = getent("panzerw_bomb_glow", "targetname");
	
	tnt = getent("panzerw_bomb", "targetname");
	tnt hide();
	
	panzerw = getent("panzerw", "targetname");
	panzerw.health = 10000000;
	
	//stop the engine sound
	wait .05;
	panzerw stopEngineSound();
	
	thread panzerwerfer_dialogue(panzerw);
	
	trigger = getent ("panzerw_trigger", "targetname");
	trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	trigger waittill("trigger");
	
	wait .05;
	level notify("bomb_planted");
		
	glow hide();
	
	tnt show();
	
	trigger delete();
	
	level.inventory_tnthud thread maps\_inventory::inventory_hide();
	
	badplace_cylinder("name", 12, panzerw.origin, 512, 128, "axis","allies","neutral");
	
	tnt playSound( "explo_plant_no_tick" );
	tnt playLoopSound( "bomb_tick" );
	
	level.bombstopwatch = maps\_utility::getstopwatch(60);//setClock( level.explosiveplanttime, 60, "hudStopwatch", 64, 64 ); // count down for 10 of 60 seconds, size is 64x64

	wait ( level.explosiveplanttime );
	tnt stopLoopSound( "bomb_tick" );
		
	level.bombstopwatch destroy();
	
	radiusdamage(panzerw.origin, 216, 350, 50);
	earthquake( 0.25, 1, panzerw.origin, 1000 );
	
	tnt delete();
	
	panzerw notify("death");
	wait .05;
	level notify("panzerw_obj_done");
	
	flag_set ("panzerw_destroyed");
	
}

panzerwerfer_dialogue(panzerw)
{
	//waittill panzerw objective is added
	level waittill ("add_church_objective");
	
	//check to see if it has been destoryed
	if (isalive (panzerw) )
	{
		//turn BC off
		battlechatterOff ("allies");
		
		//randalls dialogue
		level.randall anim_single_solo (level.randall, "panzerwerfer");
		
		//turn bc on
		battlechatterOn ("allies");
		
		flag_wait ("panzerw_destroyed");
		
		wait 1;
		
		battlechatterOff ("allies");
		
		level.randall anim_single_solo (level.randall, "secure_church");
		
		battlechatterOn ("allies");
	}
	
	else
	{
		wait 1;
		
		battlechatterOff ("allies");
		
		level.randall anim_single_solo (level.randall, "secure_church");
		
		battlechatterOn ("allies");
	}		
	
}


//FIXME
/*
nebelwerfers()
{
	trigger = undefined;

	trigger = getent("stop_fire2","targetname");
	pause = getent("pause_fire2","targetname");
	resume = getent("resume_fire2", "targetname");
	
	pause thread nebelwerfers_pause(resume, trigger);
	
	trigger endon("trigger");
	
	while(1)
	{
		rockets = 0;
		for(i=1;i<7;i++)
			self thread nebelwerfers_makerocket(i, trigger, (i));
		
		while(rockets < 6 )
		{
			level waittill("fired_rockets");
			rockets++;	
		}
		wait 4 + randomfloat(3);
		while(level.flag["pause_nebel"])
			level waittill("resume_nebel");
	}
}

nebelwerfers_pause(resume, trigger)
{
	trigger endon("trigger");
	while(1)
	{
		level.flag["pause_nebel"] = false;
		level notify("resume_nebel");
		self waittill("trigger");
		level.flag["pause_nebel"] = true;
		resume waittill("trigger");
	}	
}

nebelwerfers_makerocket(index, trigger, num, exacttime)
{
	tagname = "tag_rocket_base_0" + index;
	rocket = spawn("script_model", (self gettagorigin(tagname)) );
	rocket.tagname = tagname;
	rocket.angles = self gettagangles(tagname);
	rocket setmodel("xmodel/vehicle_halftrack_rockets_shell");
	rocket linkto(self, tagname);
	
	trigger endon("trigger");
	if(isdefined(exacttime))
		wait exacttime;
	else
	{
		wait ((level.werfertime * num * .5) + (num * 6) + (randomfloat(2)));
		while(level.flag["pause_nebel"])
			level waittill("resume_nebel");
	}
	rocket thread nebelwerfers_firerocket();
}

nebelwerfers_firerocket()
{
	level notify("fired_rockets");
	thread playsoundinspace("nebelwerfer_fire", self.origin);//, self.origin);
	if(player_viewpos_check(self.origin, .2))
	{
		x = 20;
		self unlink();	
		time = .5;
		mov = anglestoforward(self.angles);
		mov = vectornormalize(mov);
		mov = vectorscale(mov, 2000);
		mov = mov + (randomfloat(100) - 50, randomfloat(100) - 50, randomfloat(16));
		self thread nebelwerfers_fire_fx();
		wait .5;
		while(x)
		{
			angles = vectortoangles(mov);
			self.angles = angles;
			dir = self.origin + mov;
		
			self moveto(dir, time, 0,0);	
			wait time;
			mov = mov + (0,0,-64);
			x--;
		}
	}
	self delete();
}

nebelwerfers_fire_fx()
{
	self endon ("death");
	while (1)
	{
		playfxOnTag ( level._effect["rocketfx"], self, "tag_rocket" );
		wait .1;
	}
}
*/		
	
church_encounter()
{
	//eTrigger = getent ("church_trigger", "targetname");
	//eTrigger waittill ("trigger");
	
	level notify ("start_church_obj");
	
	array_thread (getentarray ("church_encounter", "targetname"), ::church_think);
		
}

church_think()
{
	spawn = self dospawn();
	
	level.churchEncounter++;
	
	if (spawn_failed (spawn) )
	{
		level.churchEncounter--;
		return;
	}
	
	spawn endon ("death");
	
	spawn thread church_deathwaiter();
	
}

church_deathwaiter()
{
	self waittill ("death");
	level.churchEncounter--;
	
	thread church_counter();
}

church_counter()
{
	if (level.churchEncounter == 0)
	{
		wait 2;
		flag_set ("church_clear");
		thread assemble_for_debrief();
	}
				
}


assemble_for_debrief()
{
	flag_wait ("panzerw_destroyed");
	flag_wait ("church_clear");
	
	thread KickGate();
			
	eTrigger = getent ("debrief_trigger", "targetname");
	
	level waittill ("gate_is_open");
	
	wait .05;
	level notify ("church_complete");
	
	outro_node = getnode ("randall_outro_node", "targetname");
	level.randall.anim_node = (outro_node);
	outro_node anim_reach_solo (level.randall, "outro_anim");
	
	eTrigger waittill ("trigger");
	
	wait .05;
	level notify ("start_jeeps");
	
	musicplay("tough_road_ahead_01");
	
	battleChatterOff( "allies" );
	
	
	outro_node thread anim_single_solo (level.randall, "outro_anim");
	
	level.randall waittillmatch ("single anim", "dialog");
	
	level.randall anim_single_solo (level.randall, "outro");
	
	battleChatterOn( "allies" );
	
	wait 1;
	level notify ("player_is_on_road");
	
}


//FIXME - kicking the gate looks weird, look for a open door animation
KickGate()
{
	
	level notify ("spawn_debrief_reinforcements");
	
	//set randall to neutral so he doesnt kick the gate
	gate_node = getnode ("gate_node", "targetname");
		
	church_gate = getent ("church_gate", "targetname");	
	
	level.randall.animname = "generic";
	level.randall.anim_node = gate_node;
	level.randall notify ("stop friendly think");
	
	level maps\_anim::anim_reach_solo (level.randall, "gatekick", undefined, gate_node);
	level.randall pushPlayer (false);
	gate_node thread maps\_anim::anim_single_solo (level.randall, "gatekick");
	
	level.randall waittillmatch ("single anim", "soundfx = kickdoor");
	
	church_gate playsound ("gate_iron_open");
	
	church_gate rotateyaw(90,.5,.2,.2);
	
	church_gate connectpaths();

	level.randall.animname = "randall";
	
	level.randall thread putOnFriendlyChain();
	
	level notify ("gate_is_open");
	
	thread jeeps();


}


//jeeps
jeeps()
{
	//get the road blocks
	
	
	
	//wait for player to trigger the debrief
	level waittill ("start_jeeps");
	
	//loop through the road blocks
	
	//delete the roadblocks
	
	
	//get the triggers to start the jeeps
	jeep1_trigger = getent ("jeep1_trigger", "targetname");
	jeep2_trigger = getent ("jeep2_trigger", "targetname");
	jeep3_trigger = getent ("jeep3_trigger", "targetname");
	

	//start the jeeps moving
	jeep1_trigger notify ("trigger");
	jeep1 = maps\_vehicle::waittill_vehiclespawn("jeep1");
	
	jeep2_trigger notify ("trigger");
	jeep2 = maps\_vehicle::waittill_vehiclespawn("jeep2");
	
	jeep3_trigger notify ("trigger");
	jeep3 = maps\_vehicle::waittill_vehiclespawn("jeep3");
	
	wait .05;
	
	array_thread (getentarray ("jeep_ranger", "targetname"), ::jeep_ai_think);
	

	//wait for the jeeps to unload
		
	jeep1 thread jeep1_think();
	jeep2 thread jeep2_think();
	jeep3 thread jeep3_think();
	
	jeep2 waittill ("reached_end_node");
	
	thread jeep_dialogue();
	
		
}

jeep_ai_think()
{
	//wait untill spawned
	self waittill ("spawned",spawn);
	if (spawn_failed(spawn))
		return;
		
		
	self.goalradius = (1024);
	
	/*
	//check to see if they have a script noteworthy
	if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger1") )
	{
		level.g_ranger1 = self;
		level.g_ranger1.animname = "g_ranger1";
	}
	else if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger2") )
	{
		level.g_ranger2 = self;
		level.g_ranger2.animname = "g_ranger2";
	}
	else if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger3") )
	{
		level.g_ranger3 = self;
		level.g_ranger3.animname = "g_ranger3";
	}
	else if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger4") )
	{
		level.g_ranger4 = self;
		level.g_ranger4.animname = "g_ranger4";
	}
	else if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger5") )
	{
		level.g_ranger5 = self;
		level.g_ranger5.animname = "g_ranger5";
	}
	else if (isdefined (spawn.script_noteworthy) && (spawn.script_noteworthy == "ranger6") )
	{
		level.g_ranger6 = self;
		level.g_ranger6.animname = "g_ranger6";
	}
	*/
	

	
	
}

jeep_dialogue()
{
	battlechatterOff ("allies");
	
	level playsoundinspace("bergstein_ranger_backup1",(-12504, 4016, 10408));
	
	wait .5;
	level playsoundinspace("bergstein_ranger_backup2",(-13016, 4080, 10408));
	
	wait .5;
	level playsoundinspace("bergstein_ranger_backup3",(-12504, 4016, 10408));
	
	wait .5;
	level playsoundinspace("bergstein_ranger_backup4",(-12848, 3832, 10408));
	
	wait .5;
	level playsoundinspace("bergstein_ranger_backup5",(-12504, 4016, 10408));
	
	wait .5;
	level playsoundinspace("bergstein_ranger_backup6",(-12848, 3832, 10408));
	
	
	/*
	//Ranger1: 3rd squad! Spread out!
	level.g_ranger1 anim_single_solo (level.g_ranger1, "backup1");
	wait .5;
	
	//Ranger2: I want the .30 cal right over here!
	level.g_ranger2 anim_single_solo (level.g_ranger2, "backup2");
	wait .5;
	
	//Ranger3: 3Put some guards on the intersection!
	level.g_ranger3 anim_single_solo (level.g_ranger3, "backup3");
	wait .5;
	
	//Ranger4: Search those bodies for intel!
	level.g_ranger4 anim_single_solo (level.g_ranger4, "backup4");
	wait .5;
	
	//Ranger5: Tie up the flanks!
	level.g_ranger5 anim_single_solo (level.g_ranger5, "backup5");
	wait .5;
	
	//Ranger6: Private! Let’s check out that roadblock! Follow me!
	level.g_ranger6 anim_single_solo (level.g_ranger6, "backup6");
	*/
	
}

jeep1_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
		
}

jeep2_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
		
}

jeep3_think()
{
	self waittill ("death");
	
	maps\_spawner::killfriends_missionfail();
		
}
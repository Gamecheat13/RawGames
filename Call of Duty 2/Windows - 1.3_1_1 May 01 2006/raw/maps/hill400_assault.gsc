/*
ToDo:
do breach explosion sound
do allied artillery on the hill first
strategically placed mg42s
foxholes and craters 
enemy machinegun tracking
advancing moving from cover point to cover point
create 30cal base of fire for attacking the left bunker (use manual mg42 temporarily)

stalingrad style mg42s
frogger style advancement
more nearby impacts (craters and trees)
more craters for cover


Make sure escapers spawn ahead of time so the player can't disable them because he's looking at them
Make escapers run out later

Make animations play, Add the second one in, update start positions to match pauls moves
Make the move in into a curving route
Figure out why no smoke shows up (Bugged)
Figure out why no one shoots at escapers (Bugged)
*/

/****************************************************************************
Objectives:
		1. Wait for the signal to attack.
		2. Breach the left bunker rear door by planting a satchel charge.
		3. Clear the left bunker of any remaining resistance.
		4. Breach the top bunker rear door by planting a satchel charge.
		5. Clear the top bunker of any remaining resistance.
		6. Hold the hill against any counterattacks.
		7. Assemble with the squad by the top bunker entrance.

*****************************************************************************/

#include maps\_utility;
#using_animtree("generic_human");

main()
{
	maps\hill400_assault_fx::main();
	maps\hill400_assault_anim::main();
	
 	level.objectives_done = 0; 
    level.mortarcrews = 2;
    level.bunkercrews = 4;
    level.halftracks = 1;    	
	maps\_halftrack::main("xmodel/vehicle_halftrack_rockets_woodland");	
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_woodland");	 	
	character\american_ranger_normandy_low::precache();
	level.drone_spawnFunction["allies"] = character\american_ranger_normandy_low::main;
	
	maps\_drones::init();	
	maps\_load::main();
	
	//maps\_utility::array_thread(getaiarray(),::PersonalColdBreath);
	//maps\_utility::array_thread(getspawnerarray(),::PersonalColdBreathSpawner);
		
	level.player thread fog();
	//setEnvironment ("cold");	
	//setCullFog (0, 4000, 0.375, .41, .42, 0);

	//setcvar("r_glow", "1");
	//setcvar("r_glow", "0");
	//setcvar("r_fullbright", "1");

	//thread AI_Overrides();

	//*** Precaching
		
	precacheModel("xmodel/weapon_brit_smoke_grenade");
	precacheItem("smoke_grenade_british");
	precacheModel("xmodel/military_tntbomb");
	precacheModel("xmodel/military_tntbomb_obj");
	precacheModel("xmodel/weapon_stickybomb");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
    precacheModel("xmodel/vehicle_halftrack_rockets_shell");
    precacheModel("xmodel/vehicle_halftrack_rockets_shell_d");
 	precacheShader("inventory_tnt_small");   
    		
	
	level.mortar = loadfx("fx/explosions/artilleryExp_grass.efx");
	level.treeburst = loadfx("fx/explosions/tree_burst.efx");
	level.smokegrenade = loadfx("fx/explosions/smoke_grenade.efx");
	level.doorblast = loadfx("fx/explosions/exp_pack_doorbreach.efx");

	//*** Ambient Sounds
	
	level thread maps\hill400_assault_amb::main();
		
	level.holdouts = [];
	level.werfertime = 9;
	level.player.tnt = 7;
	level.inv_tnt = maps\_inventory::inventory_create("inventory_tnt_small",true);

/*
		level.player.tnt--;
		if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();
*/
		
	//*** Threads
	
	level thread setupCharacters();
	level thread setupWallas();

	//level thread music();
	//level thread objectives();
	level thread objective_counter();
	level thread objective_1_bunker_crews();
	level thread objective_2_mortar_crews();
	level thread objective_3_halftracks();	
	level thread bunker01_clear();
	level thread bunker02_clear();
	level thread bunker03_clear();		
	level thread bunker04_clear();
	level thread first_mortar_crew();
	level thread second_mortar_crew();	
	level thread intro_dialog();
	level thread friendly_fire();
	level thread intro_axis_artillery();
	level thread intro_allied_artillery();
	level thread intro_charge();
	level thread bunker_mg42s();
	level thread bunker1_door();
	level thread bunker1sup_door();
	level thread bunker2_door();
	level thread bunker3_door();
	level thread bunker4_door();
	level thread bunker5_door();			
	level thread bunker_spawn();
	level thread plant_hintb1();
	level thread plant_hintb2();
	level thread plant_hintb3();
	level thread plant_hintb4();			
	//level thread maps\_treeburst::main();
	level thread crater_sequence();
	level thread setup_mortar_intro();	
	level thread startmortar_intro();
	level thread setup_mortar1();	
	level thread startmortar1();
	level thread killed_in_action();	
	thread misc2();
	level.timersused = 0;
	
	getent("select_leftcover", "targetname") thread select_cover();
	getent("select_rightcover", "targetname") thread select_cover();
	

	maps\_utility::array_thread(getentarray("cover", "targetname"), ::cover_think);
	left = getentarray("coverleft", "script_noteworthy");
	right = getentarray("coverright", "script_noteworthy");
	level.guys = left.size + right.size;
	//iprintln("^6level.guys = ", level.guys);
	maps\_utility::array_thread(left, ::watchdeath);
	maps\_utility::array_thread(right, ::watchdeath);
	/*
	if(getCvar("skipto") == "")
		setCvar("skipto", "1");
	skipto = getcvar("skipto");

	switch(skipto)
	{
	case "1":
		level notify("intro_screen");
		break;
	
	case "2":
		level notify("intro_dialog");
		break;
		
	case "3":
		level notify("intro_axis_artillery");
		
		blah = getentarray("script_brushmodel", "classname");
		for(i = 0; i < blah.size; i++)
		{
			if(isdefined(blah[i].script_noteworthy) && blah[i].script_noteworthy == "delete")
			{
				if(isdefined(blah[i].targetname) && blah[i].targetname != "left_bunker_door")
					blah[i] delete();
			}

			if(isdefined(blah[i].script_noteworthy) && blah[i].script_noteworthy == "show")
			{
				if(isdefined(blah[i].targetname) && blah[i].targetname != "left_bunker_door")
					blah[i] show();
			}
		}
		
		//iprintln("^6Force Stand");
		level.gr1 allowedStances("stand");
		level.gr1 dialogue_thread("hill400_assault_gr5_letsgoget");
		//level thread temp_message(level.gr1, "LET’S GO GET THE BASTARDS!!!!!", 0.3);
		
		wait 1;
	
		level.gr1 charge();
		
		wait 0.5;
		
		level notify("intro_charge");
	
		wait 1.5;
	
		level.myers dialogue_thread("hill400_assault_myers_waitwait");
		level thread temp_message(level.myers, "Wait! Wait! What are you doing??", 0.3);
		
		wait 1.5;
		
		level.myers charge();
		break;
		
	case "4":
		level notify("intro_allied_artillery");
		break;

	case "5":
		level notify ("intro_charge");
		break;
	}
	*/
}

setupCharacters()
{
	level.randall = getent("randall", "targetname");
	level.randall.animname = "randall";
	level.randall.grenadeAmmo = 0;	//TEMP
	level.randall.script_bcdialog = 0;
	level.randall thread maps\_utility::magic_bullet_shield();
	
	level.myers = getent("myers", "targetname");
	level.myers.animname = "myers";
	level.myers.grenadeAmmo = 0;	//TEMP
	level.myers.script_bcdialog = 0;
	level.myers thread maps\_utility::magic_bullet_shield();

	level.braeburn = getent("braeburn", "targetname");
	level.braeburn.animname = "braeburn";
	level.braeburn.grenadeAmmo = 0;	//TEMP
	level.braeburn.script_bcdialog = 0;
	level.braeburn thread maps\_utility::magic_bullet_shield();

	level.mccloskey = getent("mccloskey", "targetname");
	level.mccloskey.animname = "mccloskey";
	level.mccloskey.grenadeAmmo = 0;	//TEMP
	level.mccloskey.script_bcdialog = 0;
	level.mccloskey thread maps\_utility::magic_bullet_shield();

	level.gr1 = getent("gr1", "targetname");
	level.gr1.animname = "gr1";
	level.gr1.grenadeAmmo = 0;	//TEMP
	level.gr1.script_bcdialog = 0;
	level.gr1 thread maps\_utility::magic_bullet_shield();
	/*
	level.mcallister = getent("mcallister", "targetname");
	level.mcallister.animname = "mcallister";
	level.mcallister.grenadeAmmo = 0;	//TEMP
	*/
	level.player.ignoreme = true;

	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		ally = allies[i];
		ally allowedStances("crouch");
		ally.dontavoidplayer = true;
		ally.ignoreme = true;
	}

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		axis[i].ignoreme = true;
}

setupWallas()
{
	level.wallas = [];
	for(i = 1; i < 16; i++)
		level.wallas[i] = "Redsquare_walla" + i;	
}

setup_mortar_intro()
{
	level.explosion_startNotify["mortar_intro"] = "start mortar_intro";
	level.explosion_stopNotify["mortar_intro"] = "stop mortar_intro";
}


setup_mortar1()
{
	level.explosion_startNotify["mortar1"] = "start mortar1";
	level.explosion_stopNotify["mortar1"] = "stop mortar1";
}

setup_mortar2()
{
	level.explosion_startNotify["mortar2"] = "start mortar2";
	level.explosion_stopNotify["mortar2"] = "stop mortar2";
}

setup_mortar3()
{
	level.explosion_startNotify["mortar3"] = "start mortar3";
	level.explosion_stopNotify["mortar3"] = "stop mortar3";
}

objective_1_bunker_crews()
{
	level.bunker01 = getent("bunker01","targetname");
	assertex(isDefined(level.bunker01), "level.bunker01 not found" );
	level.bunker02 = getent("bunker02","targetname");
	assertex(isDefined(level.bunker02), "level.bunker02 not found" );
	level.bunker03 = getent("bunker03","targetname");
	assertex(isDefined(level.bunker03), "level.bunker03 not found" );
	level.bunker04 = getent("bunker04","targetname");
	assertex(isDefined(level.bunker04), "level.bunker04 not found" );      
		
	objective_add(1, "active");
	objective_string(1, &"HILL400_ASSAULT_BREACH_CLEAR_BUNKERS", 4);
	objective_current(1);
	
	level.bunkers = 4;
	level.bunker01 thread objectives_bunkers(1, 0);
	level.bunker02 thread objectives_bunkers(1, 1);
	level.bunker03 thread objectives_bunkers(1, 2);
	level.bunker04 thread objectives_bunkers(1, 3);	

	level thread objectives_star();
}

objectives_star()
{
	objective_position(1, level.bunker01.origin);

	while (true)
	{
		level waittill("obj_done");
		if (!level.bunker01.done)
		{
			objective_position(1, level.bunker01.origin);
		}
		else if (!level.bunker02.done)
		{
			objective_position(1, level.bunker02.origin);
		}
		else if (!level.bunker03.done)
		{
			objective_position(1, level.bunker03.origin);
		}
		else if (!level.bunker04.done)
		{
			objective_position(1, level.bunker04.origin);
		}
		else
			break;
	}
}


objectives_bunkers(objnum, i)
{
	self.done = false;
//	objective_additionalposition(objnum, i, self.origin);
	
	self waittill("done");
	
	self.done = true;

	level notify ("obj_done");
	//iprintlnbold(level.bunkercrews);

	level.bunkers--;
//	objective_additionalposition(objnum, i, (0,0,0) );
	if ( level.bunkers )
		objective_string(objnum, &"HILL400_ASSAULT_BREACH_CLEAR_BUNKERS", level.bunkers);
	else
	{
		//level notify( "bunkers_dead" );
		objective_state( objnum, "done" );
		objective_string(objnum, &"HILL400_ASSAULT_BREACH_CLEAR_BUNKERS", 0);
	}
}

objective_2_mortar_crews()
{

	level.mortar01 = getent("mortar01","targetname");
	assertex(isDefined(level.mortar01), "level.mortar01 not found" );
	level.mortar02 = getent("mortar02","targetname");
	assertex(isDefined(level.mortar02), "level.mortar02 not found" );
	//level.mortar03 = getent("mortar03","targetname");
	//assertex(isDefined(level.mortar03), "level.mortar03 not found" );	
		
	trigger = getent("halfttracks_spotted","targetname");
	trigger waittill("trigger");

	objective_add(2, "active");
	objective_string(2, &"HILL400_ASSAULT_ELIMINATE_THE_ENEMY_MORTAR", 2);
	objective_current(1,2);
		
	level notify("halftrack objective");

	level.mortarcrews = 2;
	level.mortar01 thread objectives_mortarcrews(2, 0);
	level.mortar02 thread objectives_mortarcrews(2, 1);
	//level.mortar03 thread objectives_mortarcrews(2, 2);
	
	level waittill("allmortars_dead");
	level notify ("stop mortar3");      


}

objectives_mortarcrews(objnum, i)
{
	objective_additionalposition(objnum, i, self.origin);
	
	self waittill("done");

	level.mortarcrews--;
	objective_additionalposition(objnum, i, (0,0,0) );
	if ( level.mortarcrews )
		objective_string(objnum, &"HILL400_ASSAULT_ELIMINATE_THE_ENEMY_MORTAR", level.mortarcrews);
	else
	{
		level notify( "allmortars_dead" );
		objective_state( objnum, "done" );
		objective_string(objnum, &"HILL400_ASSAULT_ELIMINATE_THE_ENEMY_MORTAR", 0);
	}
		
}

objective_3_halftracks()
{
	level thread halftrack01_spawn_wait();
	level thread halftrack02_spawn_wait();
 
	level waittill ("halftrack objective");
	
	wait 2;

	assertex(isdefined(level.halftrack01),"no halftrack01");
	assertex(isdefined(level.halftrack02),"no halftrack02");
	
	level thread move_guys();			
	level thread halftrack01();
	level thread halftrack_rockets();
	 	
	objective_add(3, "active");
	objective_string(3, &"HILL400_ASSAULT_ELIMINATE_PANZERWERFER", 1);
	objective_current(1,2,3);	
	
	level.halftracks = 1;
	//level.halftrack01 thread objectives_halftracks(3, 0);
	level.halftrack02 thread objectives_halftracks(3, 1);

	level notify ("show halftrack01");

	//level waittill("allhalftracks_dead");
}


objectives_halftracks(objnum, i)
{
	objective_additionalposition(objnum, i, self.origin);
	
	self waittill("done");
	level.halftracks--;
	objective_additionalposition(objnum, i, (0,0,0) );
	if ( level.halftracks )
		objective_string(objnum, &"HILL400_ASSAULT_ELIMINATE_PANZERWERFER", level.halftracks);
	else
	{
		//level notify( "allhalftracks_dead" );
		objective_state( objnum, "done" );
		objective_string(objnum, &"HILL400_ASSAULT_ELIMINATE_PANZERWERFER", 0);
	}
		
}


objective_follow(obj_id,notify_string)
{
	self endon("stop objective follow");
	self endon("death");

	if (isdefined(notify_string))
		level waittill(notify_string);

	if (isdefined(self.pos_id))
	{
		while (true)
		{
			wait 1;
			objective_additionalposition(obj_id, self.pos_id, self.origin);
		}
	}
	else
	{
		while (true)
		{
			wait 1;
			objective_position(obj_id, self.origin);
		}
	}
}

halftrack01_spawn_wait()
{
	level.halftrack01 = maps\_vehicle::waittill_vehiclespawn("halftrack01");
	//level.halftrack01 thread tank_explosives();
	//level.halftrack01.pos_id = 0;
	//level.halftrack01 thread objective_follow(3,"show halftrack01");
}

halftrack02_spawn_wait()
{
	trigger = getent("spawn_ht2","targetname");
	trigger waittill("trigger");	
 	level.halftrack02 = maps\_vehicle::waittill_vehiclespawn("halftrack02");
	level.halftrack02 thread tank_explosives();
	level notify("ht02 spawned");
}

objective_4_clean_up_hill()
{

	end_node = getent("end_node","targetname");
	assertex(isDefined(end_node), "end_node not found" );
	objective_add(4, "active", &"HILL400_ASSAULT_SECURE_HILL", end_node.origin);
	objective_current(4);
	
	maps\_utility::exploder(7);
	maps\_utility::exploder(4);	

	killaxis_node = getnode("killaxis_node","targetname");
	axis = getAIArray( "axis" );
	   for ( index = 0; index < axis.size; index++ )
			{
				axis[index].ignoreme = false;
				axis[index].goalradius = 100;
				axis[index].fightdist = 0;
				axis[index].maxdist = 0;
				axis[index] setGoalnode(killaxis_node);			
			}
	
	wait 20;
	objective_state(4, "done");
	wait 1;	 		     
	//level thread regroup_ending();
	level thread ending();
	
	//CLEAN UP LOOSE ENDS - temp
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
		 if(isalive(ai[i]))
			  ai[i] delete();
		
}


//BUNKER KILL COUNTERS
bunker01_clear()
{
	/*
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("first_bunker_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	*/
	objEvent = getObjEvent("bunker1_kill_trigger");
	objEvent waittill_objectiveEventNoTrigger(); 
	 	 
	wait 2;   
 	level notify("forwardbunker_breached");      
	level.objectives_done++;
	level.bunker01 notify ("done");

	if (level.bunkers == 0)
	{
			objective_state(1, "done");
	}
	 

	wait 1;
	autoSaveByName("firstbunker clear");
	//MOVES EVERYONE
	level.braeburn dialogue_thread("hill400_assault_braeburn_cleardown");
	wait 0.5;
	level.randall dialogue_thread("hill400_assault_rnd_gogogo");	
	regroup_bunker01 = getnode("regroup_bunker01","targetname"); 
	setgoalforallies( regroup_bunker01 );	
	trigger = getent("move_out01","targetname");
	assertex(isDefined(trigger), "move_out01 trigger not found");
	trigger waittill("trigger");
		     
	setgoalentityforallies(level.player);
	level thread setup_mortar2();
	level thread startmortar2();
	level thread smoke_bunker02();

	level notify ("charge done");	


			
	      
}
killed_in_action()
{
	wait 1;
	trigger = getent("kia","targetname");
	trigger waittill("trigger");

    level.myers delete();
	level.mccloskey delete();
	level.gr1 delete();
	
}

bunker02_clear()
{

	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("second_bunker_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;
									
	waittill_dead(ent.guys);
	 
	wait 2;	
	//level notify("bunker02_cleared");
	level.objectives_done++;      
	level.bunker02 notify ("done");

	if (level.bunkers == 0)
	{
			objective_state(1, "done");
	}
		 

	wait 1;
	autoSaveByName("secondbunker clear");
	wait 0.5; 
	level.braeburn dialogue_thread("hill400_assault_braeburn_cleardown");
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_gogogo");
      
	//MOVES EVERYONE
	bunker02_regroup = getnode("bunker02_regroup","targetname");
 
	setgoalforallies( bunker02_regroup );	
	trigger = getent("move_out02","targetname");
	assertex(isDefined(trigger), "move_out02 trigger not found");
	trigger waittill("trigger");

	setgoalentityforallies(level.player);

	      
}

bunker03_clear()
{
	//trigger = getent("bunker03guys_trigger","targetname");
	//assertex(isDefined(trigger), "bunker03guys_trigger not found" );
	//trigger waittill("trigger");
	//wait 2;
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("third_bunker_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	 
	wait 2;	
	//level notify("bunker03_cleared");
	level.objectives_done++;      
	level.bunker03 notify ("done");

	 if (level.bunkers == 0)
	{
			objective_state(1, "done");
	}
		

	wait 1;
	autoSaveByName("thirdbunker clear"); 
	wait 0.5; 
	level.braeburn dialogue_thread("hill400_assault_braeburn_cleardown");
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_gogogo");
	
	//MOVES EVERYONE TO THE TRANSITION HOUSE
	bunker03_regroup = getnode("bunker03_regroup","targetname");
 
	setgoalforallies( bunker03_regroup );	
	trigger = getent("move_out03","targetname");
	assertex(isDefined(trigger), "move_out03 trigger not found");
	trigger waittill("trigger");
	
	setgoalentityforallies(level.player);
	level thread setup_mortar3();
	level thread startmortar3();
	level thread smoke_hilltop();


     
}

bunker04_clear()
{

	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("forth_bunker_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	wait 0.5; 
	level.braeburn dialogue_thread("hill400_assault_braeburn_cleardown");
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_gogogo");
	 
	wait 2;
	level.objectives_done++;
	level notify ("done");
	level.bunker04 notify ("done");

	if (level.bunkers == 0)
	{
			objective_state(1, "done");
	}
   
	wait 1;
	autoSaveByName("topbunker clear"); 

}

kill_fc01()
{
       trigger = getent("fc01","targetname");
       assertex(isDefined(trigger), "fc01 trigger not found");
       trigger waittill("trigger");
       trigger delete();
}
kill_fc02()
{
       trigger = getent("fc02","targetname");
       assertex(isDefined(trigger), "fc02 trigger not found");
       trigger waittill("trigger");
       trigger delete();
}
kill_fc03()
{
       trigger = getent("fc03","targetname");
       assertex(isDefined(trigger), "fc03 trigger not found");
       trigger waittill("trigger");
       trigger delete();
}


move_guys()
{

       randall_node_top = getnode("randall_node_top","targetname"); 
       level.randall setgoalnode(randall_node_top);

       braeburn_node_top = getnode("braeburn_node_top","targetname");
	   level.braeburn setgoalnode(braeburn_node_top);
	   level.randall dialogue_thread("hill400_assault_rnd_taylorsmoke");
	   //iprintlnbold ("Taylor!!! Use your smoke grenades!!");	


       trigger = getent("fallin_guys_trigger","targetname");
       assertex(isDefined(trigger), "fallin_guys_trigger trigger not found");
       trigger waittill("trigger");
	
       level.randall setgoalentity (level.player);       
       level.braeburn setgoalentity (level.player);		 


}


halftrack01()
{
		//level.halftrack01 = maps\_vehicle::waittill_vehiclespawn("halftrack01");
		level.halftrack01 thread vehicle_quake();
						
		level.halftrack01 waittill ("death");
/*
		wait 2;
	 level.objectives_done++;
		level.halftrack01 notify ("done");	 
	 level notify ("done");
		//iprintlnbold(level.halftrack);
	  if (level.halftracks == 0)
		{
				objective_state(3, "done");
		}
	
		 wait 1;
	  autoSaveByName("halftrack01 dead");
*/	   	
}



halftrack_rockets()
{
	//level.halftrack02 = maps\_vehicle::waittill_vehiclespawn("halftrack02");	
		level.halftrack02 waittill ("death");
	
	wait 2;
	level.objectives_done++;
    level.halftrack02 notify ("done");	
 	level notify ("obj_done");   
	level notify ("done");
	//iprintlnbold(level.halftrack);
	if (level.halftracks == 0)
		{
				objective_state(3, "done");
		}
	
	wait 1;
	autoSaveByName("halftrack02 dead"); 	
	
}

tank_explosives()
{
	self endon ("death");

	self thread tank_ondeath();
	self.bombTriggers = [];
	self.bombs = [];

	tags = [];
	tags[0] = "tag_engine_left";
	tags[1] = "tag_engine_right";
	//tags[1] = "tag_left_wheel_07";
	//tags[2] = "tag_right_wheel_07";
	location_angles = [];
	location_angles[0] = (90,0,0);
	location_angles[1] = (90,0,0);
	//location_angles[2] = (180,0,0);

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
	
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");

	bomb = self.bombs[id];

	level thread remove_stickys(self.bombs,id);

	bomb setmodel ("xmodel/military_tntbomb");
	bomb playsound ("explo_plant_rand");
	bomb playloopsound ("bomb_tick");

	level stopwatch(bomb);

	badplace_delete(badplacename);
	
	self notify ("death", level.player);
	bomb delete();

	
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


vehicle_quake()
{
	self endon("death");
	while (1)
	{
		earthquake(0.20, 0.1, self.origin, 300); // scale duration source radius
		wait (0.1);
	}
}

objective_counter()
{
	while(level.objectives_done < 7)
	{
		//iprintlnbold(level.objectives_done); 	
		level waittill ("obj_done");
	}
		//iprintlnbold ("level.objectives_done");

	level thread stop_spawners();
	level thread objective_4_clean_up_hill();
}

stop_spawners()
{
	wait 2;
	trigger = getent("kill_spawners","targetname");
	assertex(isDefined(trigger), "kill_spawners trigger not found");
 	trigger notify("trigger");


}



goToNodeAndDie(node)
{
	self setgoalnode(node); 
	self.goalradius = 8; 
	self waittill("goal"); 
	self delete(); 

}
	      
regroup_ending()
{

	end_node = getent("end_node","targetname");
	assertex(isDefined(end_node), "end_node not found" );
	objective_add(5, "active", "Assemble with the squad at the top of the hill.", end_node.origin);
	objective_current(5);

	ending_regroup = getnode("ending_regroup","targetname"); 
	setgoalforallies( ending_regroup );	
	trigger = getent("ending_trigger","targetname");
	assertex(isDefined(trigger), "ending_trigger trigger not found");
	trigger waittill("trigger");
	
	objective_state(5, "done");
	wait 1;	      
	level thread ending();
		   
}

first_mortar_crew()
{
	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("mortar01_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	 
	wait 2;
	level.objectives_done++;
	level notify ("obj_done");		
	level.mortar01 notify ("done");
	if (level.mortarcrews == 0)
	{
			objective_state(2, "done");
	}
	
	wait 1;
	autoSaveByName("mortar01 dead");

}

second_mortar_crew()
{
	
	ent = spawnstruct();
	ent.guys = [];
	array_thread(getentarray("mortar02_crew","script_noteworthy"), ::spawnerThink, ent);
	ent waittill ("spawned_guy");
	waittillframeend;

	waittill_dead(ent.guys);
	wait 2;
	//STOPS SECOND MORTARS
	level.objectives_done++;
	level notify ("obj_done");		
	level.mortar02 notify ("done");
	if (level.mortarcrews == 0)
	{
			objective_state(2, "done");
	}
				   
	wait 1;
	autoSaveByName("mortar02 dead");
}



stop_killer_attack()
{
	   trigger = getent("stop_killer","targetname");
	   trigger waittill("trigger");
	   level notify("player safe");
	   level notify ("go crater scene");

}


movement_checker(barn)
{
	level endon ("player safe");
	awol = getent("awol", "targetname");
	dist = length(level.player.origin - awol.origin); //(returns world units)
	
	range = 256;
	time = 10;
	
	newtime = 0;
	// changes the amount of time inbetween mortar hits.
	interval = 10;
	
	mortarnum = 1;
	maxmortars = 2;
	mortartimemax = 3;
	mortartime = mortartimemax;
	while(1)
	{
		wait interval;
		newdist = length(level.player.origin - awol.origin); //(returns world units);
		
		if((dist - newdist) < range)
			newtime += interval;	
		else
		{
			newtime = 0;
			dist = newdist;
			mortarnum = 0;
		}
		
		if(newtime >= time)
		{
			if(mortartime >=mortartimemax)
			{
				if(mortarnum < maxmortars)
				{	
					x = 160 + randomfloat(60);
					if(randomint(100) > 50)
						x *= -1;
					y = 160 + randomfloat(60);
					if(randomint(100) > 50)
						y *= -1;
						
					origin = level.player.origin + (x,y,0);
					impactPoint = spawn ("script_origin", origin);
					impactPoint maps\_mortar::explosion_activate ("mortar_intro", 1, 1, 2, 0.5, 2, 2000); //
					mortarnum++;
					radiusdamage(origin, 600, 80, 80);
				}
				else
				{
					impactPoint = spawn ("script_origin", level.player.origin);
					impactPoint maps\_mortar::explosion_activate ("mortar_intro", 1, 1, 2, 0.5, 2, 2000); //
					killplayer();
				}
				mortartime = 0;
			}
			mortartime += interval;
		}
	}	
}


killplayer()
{
	 level.player enableHealthShield( false );
	  level.player doDamage (level.player.health, level.player.origin); //killplayer
	 level.player enableHealthShield( true );
}

friendly_fire()
{
	//Covers situations where the player tries to toss a grenade and screw up situations
	//AI are temporarily unaware of grenades and also have zero-tolerance for friendly fire
	wait 13;
	aAllies = getaiarray("allies");
	for(i=0; i<aAllies.size; i++)
	{
		aAllies[i].grenadeawareness = 0;
		aAllies[i] thread ff_damagecheck();
	}
}

ff_damagecheck()
{
	level endon ("intro_charge");
	while(1)
	{
		self waittill("damage", amount, attacker);
		if(attacker == level.player)
			break;
	}	
	setCvar("ui_deadquote", &"HILL400_ASSAULT_FRIENDLY_FIRE_WILL_NOT");
	maps\_utility::missionFailedWrapper();
}

intro_dialog()
{
	level.player allowCrouch(true);
	level.player allowStand(false);
	level.player allowProne(false);

	battleChatterOff( "allies" );
	//level waittill("intro_dialog");
	//level thread count_time();

	guys[0] = level.braeburn;
	guys[1] = level.mccloskey;
//	animNode = getnode("intro_sequence_node", "targetname");
//	animNode maps\_anim::anim_reach(guys, "hill400_dialogue_scene1");
//	animNode maps\_anim::anim_single(guys, "hill400_dialogue_scene1");



	level notify("intro_axis_artillery");
	wait 0.7;
	level.randall dialogue_thread("hill400_assault_rnd_whatareorders");
	wait 0.0001;
	level.myers dialogue_thread("hill400_assault_myers_shutup");
	wait 0.2;
	level.gr1 dialogue_thread("hill400_assault_cof_thinkfast");
	wait 0.4;
	level.randall dialogue_thread("hill400_assault_rnd_wecantsithere");
	level.gr1 allowedStances("stand");
	wait 0.5;				
	level.gr1 dialogue_thread("hill400_assault_gr5_letsgoget");
	level.gr1 thread charge_anim();
	level.gr1 thread charge();
	level notify("kill_time");	
	//wait 0.001;	
	level notify("intro_charge");
	level.player allowStand(true);
	level.player allowProne(true);
		
	wait 1.5;
	level thread movement_checker();
	level thread stop_killer_attack();
	level.myers dialogue_thread("hill400_assault_myers_waitwait");
	//level thread temp_message(level.myers, "Wait! Wait! What are you doing??", 0.3);
		
	level.myers charge();
	battleChatterOn( "allies" );

}

intro_charge()
{
	level waittill("intro_charge");
	friendlies = getaiarray("allies");
	level thread array_thread(friendlies,::charge_anim);	


	for(i = 0; i < friendlies.size; i++)
	{
		if(isdefined(friendlies[i].script_commonname) && friendlies[i].script_commonname == "rightcharger")
			friendlies[i] thread charge();
	}

	wait 4;

	for(i = 0; i < friendlies.size; i++)
	{
		if(isdefined(friendlies[i].script_commonname) && friendlies[i].script_commonname == "leftcharger")
			friendlies[i] thread charge();
	}
}

charge()
{
	self.interval = 0;
	
	chargestart_nodes = getnodearray("chargestart_node", "script_noteworthy");
	for(i = 0; i < chargestart_nodes.size; i++)
	{
		if(isdefined(self.script_namenumber) && self.script_namenumber == chargestart_nodes[i].script_namenumber)
			level thread redsquare_routing(self, chargestart_nodes[i]);
	}

	wait (0.15 + randomfloat(1.1));
	self playsound("hill400_walla");
	level.player.ignoreme = false;
	//level waittill("charge done");

	
}

redsquare_routing(nSoldier, nStartNode)
{
	nSoldier endon("death");
	level endon ("redsquare is under soviet control");
	
	wait randomfloat(1);

	nSoldier.goalradius = 80;
	nSoldier.suppressionwait = 0;
	nSoldier allowedStances("stand");
	nSoldier setgoalnode(nStartNode);
	nCurrentNode = nStartNode;
	nNextNode = undefined;
	
	while(1)
	{
		nSoldier waittill ("goal");
		
		if(isdefined(nNextNode))
		{
			nCurrentNode = nNextNode;
		}
		
		//Move to the next node if there is one, or switch to squad_assault suicide mission
		
		if(isdefined(nCurrentNode) && isdefined(nCurrentNode.target))
		{
			nNextNode = getnode(nCurrentNode.target, "targetname");
			//println(nCurrentNode.target);
			nSoldier setgoalnode(nNextNode);
		}
		else
		{
//			if(isdefined(nCurrentNode) && isdefined(nCurrentNode.script_commonname) && nCurrentNode.script_commonname == "terminalnode")
//			{
//				println("REACHED TERMINAL NODE");
//				
//				aAsltNodes = getnodearray("assaultnode", "script_noteworthy");
//				
//				if(isdefined(nCurrentNode.script_assaultnode))
//				{	
//					for(k=0; k<aAsltNodes.size; k++)
//					{
//						if(aAsltNodes[k].targetname == nCurrentNode.script_assaultnode)
//						{
//							level thread redsquare_advance(nSoldier, aAsltNodes[k]);		
//						}
//					}
//				}
//			}
			nSoldier allowedStances("crouch", "prone", "stand");
			break;
		}
	}
}




setgoalforallies(goal)
{
    
	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
			{
				allies[index].ignoreme = false;
				allies[index].goalradius = 256;
				allies[index].fightdist = 0;
				allies[index].maxdist = 0;
				allies[index] setGoalnode( goal );			
				allies[index] .goalradius = goal.radius;
			}
		
}

setgoalentityforallies(target)
{
	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
			{
				allies[index].ignoreme = false;
				allies[index].goalradius = 256;
				allies[index].fightdist = 0;
				allies[index].maxdist = 0;
				allies[index] setGoalEntity( target );			
			}

}

//KILL COUNTER GET GUYS
spawnerThink(ent)
{
	self endon ("death");
	self waittill ("spawned",spawn);
	ent.guys[ent.guys.size] = spawn;
	ent notify ("spawned_guy");
}



//**********************************************//
//		  DEV UTILITIES			//
//**********************************************//

temp_message(eObject, msg, scale, off)
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
	
	if(!isdefined(scale))
	{
		scale = 0.8;
	}

	for(i=0; i<60; i++)
	{
		print3d (eObject.origin + (0,0,64), msg, (0.0,0.7,1.0), 1, scale);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}
	
	wait 0.75;	
}

ending()
{
				
	wait 5;
	//iprintlnbold ("D Company! Get the wounded into the bunker! Gather up weapons and ammo! Jerry’s sure to be comin’ back! Get moving! Now!");
    level.randall dialogue_thread("hill400_assault_rnd_dcompany");	 
	wait 2;     
	maps\_endmission::nextmission();


}

startmortar_intro()
{
	trigger = getent("start_mortar_intro","targetname");
	assertex(isDefined(trigger), "start_mortar_intro trigger not found");
	trigger waittill("trigger");

	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("mortar_intro", 0.5,5,2.5,350,2000,false);
	level notify ("start mortar_intro");
	
}

startmortar1()
{
	trigger = getent("startmortar1","targetname");
	assertex(isDefined(trigger), "startmortar1 trigger not found");
	trigger waittill("trigger");

	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("mortar1", 1.0, 3, 1, 350, 2000,false);
	level notify ("start mortar1");
	level notify ("stop mortar_intro");
}

startmortar2()
{
	trigger = getent("startmortar2","targetname");
	assertex(isDefined(trigger), "startmortar2 trigger not found");
	trigger waittill("trigger");

	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("mortar2", 1.0, 3, 1, 350, 2000,false);
	level notify ("start mortar2");
	level notify ("stop mortar1");
	
}

startmortar3()
{
	trigger = getent("top_trigger","targetname");
	assertex(isDefined(trigger), "top_trigger trigger not found");
	trigger waittill("trigger");

	//START MORTAR ATTACK
	level thread maps\_mortar::generic_style("mortar3", 0.5,5,2.5,350,2000,false);
	level notify ("start mortar3");
	level notify ("stop mortar2");
	
}





//**********************************************//
//		  DIALOGUE UTILITIES		//
//**********************************************//

dialogue_thread(dialogue)
{
	self setBattleChatter(false);

	if ( isdefined (self.MyIsSpeaking) && self.MyIsSpeaking )
		self waittill ("my done speaking");

	self.MyIsSpeaking = true;
	
	facial = undefined;	
	
	level maps\_anim::anim_single_solo(self, dialogue);
	//self thread animscripts\face::SaySpecificDialogue(facial, dialogue, 1.0, "single dialogue");
	//self waittill ("single dialogue");
	
	self setBattleChatter(true);
	self.MyIsSpeaking = false;
	self notify("my done speaking");
}

intro_axis_artillery()
{
	intro_axis_artillery = getentarray("intro_axis_artillery", "targetname");

	for(i = 0; i < intro_axis_artillery.size; i++)
		level thread setup_marching_artillery(intro_axis_artillery[i]);

	//level waittill("intro_axis_artillery");

	for(i = 0; i < intro_axis_artillery.size; i++)
		level thread marching_artillery(intro_axis_artillery[i]);
}

intro_allied_artillery()
{
	intro_allied_artillery = getentarray("intro_allied_artillery", "targetname");

	for(i = 0; i < intro_allied_artillery.size; i++)
		level thread setup_marching_artillery(intro_allied_artillery[i]);

	//level waittill("intro_allied_artillery");

	for(i = 0; i < intro_allied_artillery.size; i++)
		level thread marching_artillery(intro_allied_artillery[i]);
}

setup_marching_artillery(ent)
{
	if(isdefined(ent.target))
	{
		targets = getentarray(ent.target, "targetname");	
		for(i = 0; i < targets.size; i++)
		{
			if(isdefined(targets[i].script_noteworthy))
			{
				if(targets[i].script_noteworthy == "show")
					targets[i] hide();
					
//				if(targets[i].script_noteworthy == "treeburst")
//					targets[i] thread maps\_treeburst::treeburst();
			}
		}
				
		for(i = 0; i < targets.size; i++)
			level thread setup_marching_artillery(targets[i]);
	}
}

marching_artillery(ent)
{
	longest_delay = 0;

	if(isdefined(ent.target))
	{
		targets = getentarray(ent.target, "targetname");	
		ent.delete = [];
		ent.show = [];

		for(i = 0; i < targets.size; i++)
		{
			if(isdefined(targets[i].script_noteworthy))
			{
				if(targets[i].script_noteworthy == "ignore")
				{
					continue;
				}
				else if(targets[i].script_noteworthy == "delete")
				{
					ent.delete[ent.delete.size] = targets[i];
					ent.process = true;
					continue;
				}
				else if(targets[i].script_noteworthy == "show")
				{
					ent.show[ent.show.size] = targets[i];
					ent.process = true;
					continue;
				}
			}

			delay =	(1 + randomfloat(1));
			
			if(delay > longest_delay)
				longest_delay = delay;
		
			targets[i] thread delay_artillery(delay);
			//iprintln("^5threading artillery with delay: ", delay);
		}
	
		//iprintln("Waiting longest_delay: ", longest_delay);
		//wait longest_delay;
		wait 1.2;
				
		for(i = 0; i < targets.size; i++)
			level thread marching_artillery(targets[i]);
	}
}

delay_artillery(delay)
{
	wait delay;
	
	thread artillery_fired_sound();
	
	wait 1;
	
	thread activate_artillery();
}

artillery_fired_sound()
{
	if(!isdefined(level.artillery_fired_last_sound))
		level.artillery_fired_last_sound = -1;

	soundnum = randomint(4) + 1;
	while(soundnum == level.artillery_fired_last_sound)
		soundnum = randomint(4) + 1;

	level.artillery_fired_last_sound = soundnum;

	if(soundnum == 1)
		level.player playsound ("elm_distant_explod5");
	else if(soundnum == 2)
		level.player playsound ("elm_distant_explod6");
	else if(soundnum == 3)
		level.player playsound ("elm_distant_explod5");
	else
		level.player playsound ("elm_distant_explod8");
}

activate_artillery(range, max_damage, min_damage, fQuakepower, iQuaketime, iQuakeradius)
{
	maps\_mortar::incoming_sound(undefined, false);

	if(!isdefined(range))
		range = 256;
	if(!isdefined(max_damage))
		max_damage = 400;
	if(!isdefined(min_damage))
		min_damage = 25;

	radiusDamage(self.origin, range, max_damage, min_damage);

	if(isdefined(self.process) && self.process == true)
	{
		if(isdefined(self.delete))
		{
			for(i = 0; i < self.delete.size; i++)
			{
				if(isdefined(self.delete[i]))
				{
					if(isdefined(self.delete[i].spawnflags) && self.delete[i].spawnflags)
						self.delete[i] connectpaths();
						
					self.delete[i] delete();
				}
			}
		}
		
		if(isdefined(self.show))
		{
			for(i = 0; i < self.show.size; i++)
			{
				if(isdefined(self.show[i]))
					self.show[i] show();
			}
		}
	}
	
	self.process = false;

	if(isdefined(self.script_noteworthy) && (self.script_noteworthy == "treeburst"))
	{
		maps\_mortar::mortar_boom(self.origin, fQuakepower, iQuaketime, iQuakeradius, level.treeburst, false);
		self notify("treeburst");
	}
	else
		maps\_mortar::mortar_boom(self.origin, fQuakepower, iQuaketime, iQuakeradius, undefined, false);
}

fog()
{
	r = .5;
	g = .5;
	b = .554;
	if(level.xenon)
	{	
		low = .0001;
		high = .0002;
	}
	else
	{
		low = .0001;
		high = .0002;
	}
	range_top = 12860;
	range_bottom = 10352;
	freq = 5;
	range = range_top - range_bottom;
	
	setExpFog(high, r, g, b, 0);
	wait freq;
	
	while(isalive(self))
	{
		dist = (range_top - self.origin[2]);
		
//		if(dist < 0)
//			dist = dist * -1;
		
		if(dist > range)
			frac = 1;
		else if(dist < 0)
			frac = 0;
		else
			frac = (dist / range);
		
		expfrac = frac * frac;
		//expfrac = frac;
		
		density = low + expfrac * (high - low);
		setExpFog(density, r, g, b, freq);		

		wait freq;
	}
}


bunker_mg42s()
{
	mg42_gunners = getentarray("bunker_mg42_gunner", "targetname");
	for(i = 0; i < mg42_gunners.size; i++)
	{
		gunner = mg42_gunners[i] doSpawn();
		
		if(spawn_failed(gunner))
			continue;
			
		gunner.ignoreme = true;
	}
		
	bunker_mg42_trigger = getent("bunker_mg42_trigger", "targetname");
	bunker_mg42_trigger waittill("trigger");

	//iprintln("^5Activating MG42s");
	//gunner.ignoreme = false;
	//level.player.ignoreme = false;

	allies = getaiarray("allies");
	for(i = 0; i < allies.size; i++)
	{
		ally = allies[i];
		ally.goalradius = 160;
		ally.anim_forced_cover = "hide";
		
		if(isdefined(ally.targetname) && (ally.targetname == "randall" || ally.targetname == "braeburn" || ally.targetname == "mccloskey" || ally.targetname == "myers"))
			continue;
	
		ally.ignoreme = false;
	}

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		axis[i].ignoreme = false;
/*
	while(isalive(level.player))
	{
		if(player_is_safe())
		{
			level.player.ignoreme = true;
			//turret setmode("auto_ai");
		}
		else
		{
			level.player.ignoreme = false;
			//turret setmode("manual_ai");
		}
			
		wait(0.1);
	}
*/	
}

print_safety()
{
	while(isalive(level.player))
	{
		if(player_is_safe())
			iprintln("^3player is safe");
		else
			iprintln("^5player is NOT safe");
			
		wait(1);
	}
}

plant_hintb1()
{
       trigger = getent("plant_hintb1","targetname");
       assertex(isDefined(trigger), "plant_hintb1 not found" );
       trigger waittill("trigger");
       
       level.randall dialogue_thread("hill400_assault_rnd_usesatchelcharge");	
                  
}

plant_hintb2()
{
       trigger = getent("plant_hintb2","targetname");
       assertex(isDefined(trigger), "plant_hintb2 not found" );
       trigger waittill("trigger");
       
       level.randall dialogue_thread("hill400_assault_rnd_takedowndoor");	
                  
}

plant_hintb3()
{
       trigger = getent("plant_hintb3","targetname");
       assertex(isDefined(trigger), "plant_hintb3 not found" );
       trigger waittill("trigger");
       
       level.randall dialogue_thread("hill400_assault_rnd_usesatchelcharge");	
                  
}

plant_hintb4()
{
       trigger = getent("plant_hintb4","targetname");
       assertex(isDefined(trigger), "plant_hintb4 not found" );
       trigger waittill("trigger");
       
       level.randall dialogue_thread("hill400_assault_rnd_takedowndoor");	
                  
}


bunker1_door()
{

	forwardbunker_trigger = getent("forwardbunker_trigger", "targetname");
	forwardbunker_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	
	bomb_origin = getent("bomb_origin", "targetname");
	bomb_target = getent(bomb_origin.target, "targetname");	
	bomb = spawn("script_model", bomb_origin.origin);
	bomb setmodel("xmodel/military_tntbomb_obj");
	bomb.angles = bomb_origin.angles;

	forwardbunker_trigger waittill("trigger");
	forwardbunker_trigger triggeroff();		
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");
	level.braeburn setgoalnode(getnode("b_bunker01", "targetname"));	
	if(level.xenon)
	{	
	badplace_cylinder("", 11, bomb_origin.origin, 150, 128, "axis", "allies");	
	}
	else
	{	
	badplace_cylinder("", 6, bomb_origin.origin, 150, 128, "axis", "allies");
	}	
	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
		level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");			
	vector = vectorNormalize(bomb_target.origin - bomb_origin.origin);
	
	effect_origin = spawn("script_origin", bomb_origin.origin);
//	effect_origin.angles = vectortoangles(vector);

	wait level.explosiveplanttime;
	forwardbunker_trigger process_targets();
	
	door = getent(forwardbunker_trigger.target, "targetname");
	bunkdoor01_coll = getent("bunkdoor01_coll", "targetname");
	level thread doorblast_anim(door);
	
	playfx(level.doorblast, effect_origin.origin, vector);
	//bomb playsound ("grenade_explode_default");
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );

	bunkdoor01_coll = getent("bunkdoor01_coll", "targetname");
	bunkdoor01_coll delete();
	bomb hide();
	
	blast01 = getent("blast01", "targetname");	
	//origin, range, max damage, min damage
	radiusDamage( blast01.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast01.origin, 1050 );
	wait 2;
	level.braeburn setgoalnode(getnode("bunker_braeburn", "targetname"));
	wait 2;
	bomb delete();
		
}

bunker1sup_door()
{

	bunker1sup_trigger = getent("bunker1sup_trigger", "targetname");
	bunker1sup_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	bombsup_origin = getent("bombsup_origin", "targetname");
	bomb_target = getent(bombsup_origin.target, "targetname");	
	bomb = spawn("script_model", bombsup_origin.origin);		
	bomb setmodel("xmodel/military_tntbomb_obj");
	bomb.angles = bombsup_origin.angles;	
	
	bunker1sup_trigger waittill("trigger");
	bunker1sup_trigger triggeroff();	
	badplace_cylinder("", 7, bombsup_origin.origin, 150, 128, "axis", "allies");
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");

	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");			
	vector = vectorNormalize(bomb_target.origin - bombsup_origin.origin);
	
	effect_origin = spawn("script_origin", bombsup_origin.origin);
//	effect_origin.angles = vectortoangles(vector);

	wait level.explosiveplanttime;
	bunker1sup_trigger process_targets();
	
	door = getent(bunker1sup_trigger.target, "targetname");
	bunkdoorsup_coll = getent("bunkdoorsup_coll", "targetname");	
	level thread doorblast_anim(door);
	
	exploder(69);
	//bomb playsound ("grenade_explode_default");
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );

	bunkdoorsup_coll = getent("bunkdoorsup_coll", "targetname");
	bunkdoorsup_coll delete();		
	bomb hide();
	
	blast_sup = getent("blast_sup", "targetname");			
	//origin, range, max damage, min damage
	radiusDamage( blast_sup.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast_sup.origin, 1050 );
	wait 4;
	bomb delete();
	
	
}


bunker2_door()
{

	secondbunker_trigger = getent("secondbunker_trigger", "targetname");
	secondbunker_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );

	bomb2_origin = getent("bomb2_origin", "targetname");
	bomb_target = getent(bomb2_origin.target, "targetname");	
	bomb = spawn("script_model", bomb2_origin.origin);		
	bomb setmodel("xmodel/military_tntbomb_obj");	
	bomb.angles = bomb2_origin.angles;
	
	secondbunker_trigger waittill("trigger");
	secondbunker_trigger triggeroff();	
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");
	if(level.xenon)
	{	
	badplace_cylinder("", 11, bomb2_origin.origin, 150, 128, "axis", "allies");	
	}
	else
	{	
	badplace_cylinder("", 6, bomb2_origin.origin, 150, 128, "axis", "allies");
	}
	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");		
	vector = vectorNormalize(bomb_target.origin - bomb2_origin.origin);
	
	effect_origin = spawn("script_origin", bomb2_origin.origin);
//	effect_origin.angles = vectortoangles(vector);
	wait level.explosiveplanttime;
	secondbunker_trigger process_targets();
	
	door = getent(secondbunker_trigger.target, "targetname");
	bunkdoor02_coll = getent("bunkdoor02_coll", "targetname");
	level thread doorblast_anim(door);
	
	playfx(level.doorblast, effect_origin.origin, vector);
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );

	blast02 = getent("blast02", "targetname");	
	//origin, range, max damage, min damage
	radiusDamage( blast02.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast02.origin, 1050 );
	
	secondbunker_trigger delete();
	bunkdoor02_coll = getent("bunkdoor02_coll", "targetname");
	bunkdoor02_coll delete();		
	bomb hide();
	wait 4;
	bomb delete();
		

}

bunker3_door()
{

	thirdbunker_trigger = getent("thirdbunker_trigger", "targetname");
	thirdbunker_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );

	bomb3_origin = getent("bomb3_origin", "targetname");
	bomb_target = getent(bomb3_origin.target, "targetname");	
	bomb = spawn("script_model", bomb3_origin.origin);		
	bomb setmodel("xmodel/military_tntbomb_obj");
	bomb.angles = bomb3_origin.angles;		
	
	thirdbunker_trigger waittill("trigger");
	thirdbunker_trigger triggeroff();
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");
	if(level.xenon)
	{	
	badplace_cylinder("", 11, bomb3_origin.origin, 150, 128, "axis", "allies");	
	}
	else
	{	
	badplace_cylinder("", 6, bomb3_origin.origin, 150, 128, "axis", "allies");
	}
	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
			level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");		
	vector = vectorNormalize(bomb_target.origin - bomb3_origin.origin);
	
	effect_origin = spawn("script_origin", bomb3_origin.origin);
//	effect_origin.angles = vectortoangles(vector);
	wait level.explosiveplanttime;
	thirdbunker_trigger process_targets();
	
	door = getent(thirdbunker_trigger.target, "targetname");
	bunkdoor03_coll = getent("bunkdoor03_coll", "targetname");	
	level thread doorblast_anim(door);
	
	playfx(level.doorblast, effect_origin.origin, vector);
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );
	
	blast03 = getent("blast03", "targetname");	
	//origin, range, max damage, min damage
	radiusDamage( blast03.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast03.origin, 1050 );
	
	thirdbunker_trigger delete();
	bunkdoor03_coll = getent("bunkdoor03_coll", "targetname");
	bunkdoor03_coll delete();		
	bomb hide();
	wait 4;
	bomb delete();	

}

bunker4_door()
{

	forthbunker_trigger = getent("forthbunker_trigger", "targetname");
	forthbunker_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );

	bomb4_origin = getent("bomb4_origin", "targetname");
	bomb_target = getent(bomb4_origin.target, "targetname");	
	bomb = spawn("script_model", bomb4_origin.origin);		
	bomb setmodel("xmodel/military_tntbomb_obj");
	bomb.angles = bomb4_origin.angles;		
	
	forthbunker_trigger waittill("trigger");
	forthbunker_trigger triggeroff();	
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");
	if(level.xenon)
	{	
	badplace_cylinder("", 11, bomb4_origin.origin, 150, 128, "axis", "allies");	
	}
	else
	{	
	badplace_cylinder("", 6, bomb4_origin.origin, 150, 128, "axis", "allies");
	}
	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
		level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");		
	vector = vectorNormalize(bomb_target.origin - bomb4_origin.origin);
	
	effect_origin = spawn("script_origin", bomb4_origin.origin);
//	effect_origin.angles = vectortoangles(vector);
	wait level.explosiveplanttime;
	forthbunker_trigger process_targets();
	
	door = getent(forthbunker_trigger.target, "targetname");
	bunkdoor04_coll = getent("bunkdoor04_coll", "targetname");		
	level thread doorblast_anim(door);
	
	playfx(level.doorblast, effect_origin.origin, vector);
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );
	
	blast04 = getent("blast04", "targetname");	
	//origin, range, max damage, min damage
	radiusDamage( blast04.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast04.origin, 1050 );
	
	forthbunker_trigger delete();
	bunkdoor04_coll = getent("bunkdoor04_coll", "targetname");
	bunkdoor04_coll delete();			
	bomb hide();
	wait 4;
	bomb delete();

}
bunker5_door()
{

	bunker05_trigger = getent("bunker05_trigger", "targetname");
	bunker05_trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	
	bomb5_origin = getent("bomb5_origin", "targetname");
	bomb_target = getent(bomb5_origin.target, "targetname");	
	bomb = spawn("script_model", bomb5_origin.origin);		
	bomb setmodel("xmodel/military_tntbomb_obj");
	bomb.angles = bomb5_origin.angles;		
		
	bunker05_trigger waittill("trigger");
	bunker05_trigger triggeroff();		
	iprintlnbold (&"HILL400_ASSAULT_EXPLOSIVES_PLANTED");
	if(level.xenon)
	{	
	badplace_cylinder("", 11, bomb5_origin.origin, 150, 128, "axis", "allies");	
	}
	else
	{	
	badplace_cylinder("", 6, bomb5_origin.origin, 150, 128, "axis", "allies");
	}
	bomb setmodel("xmodel/military_tntbomb");
	bomb playloopsound ("bomb_tick");
	level.player.tnt--;
	if (level.player.tnt <= 0)
		level.inv_tnt maps\_inventory::inventory_destroy();

	
	level thread stopwatch(bomb);
	bomb playsound("explo_plant_rand");		
	vector = vectorNormalize(bomb_target.origin - bomb5_origin.origin);
	
	effect_origin = spawn("script_origin", bomb5_origin.origin);
//	effect_origin.angles = vectortoangles(vector);
	wait level.explosiveplanttime;
	bunker05_trigger process_targets();
	
	door = getent(bunker05_trigger.target, "targetname");
	bunkdoor05_coll = getent("bunkdoor05_coll", "targetname");		
	level thread doorblast_anim(door);
	
	playfx(level.doorblast, effect_origin.origin, vector);
	//BEGIN EXPLOSION
	bomb playSound( "explo_metal_rand" );
	
	blast05 = getent("blast05", "targetname");	
	//origin, range, max damage, min damage
	radiusDamage( blast05.origin, 150, 10000, 10000 );
	earthquake( 0.25, 3, blast05.origin, 1050 );
	
	bunker05_trigger delete();
	bunkdoor05_coll = getent("bunkdoor05_coll", "targetname");
	bunkdoor05_coll delete();			
	bomb hide();
	wait 4;
	bomb delete();

}

process_targets()
{
	if(isdefined(self.target))
	{
		targets = getentarray(self.target, "targetname");	
		self.delete = [];
		self.show = [];

		for(i = 0; i < targets.size; i++)
		{
			if(isdefined(targets[i].script_noteworthy))
			{
				if(targets[i].script_noteworthy == "delete")
				{
					self.delete[self.delete.size] = targets[i];
					self.process = true;
					continue;
				}
				else if(targets[i].script_noteworthy == "show")
				{
					self.show[self.show.size] = targets[i];
					self.process = true;
					continue;
				}
			}
		}
	}
	
	if(isdefined(self.process) && self.process == true)
	{
		if(isdefined(self.delete))
		{
			for(i = 0; i < self.delete.size; i++)
			{
				if(isdefined(self.delete[i]))
					self.delete[i] delete();
			}
		}
		
		if(isdefined(self.show))
		{
			for(i = 0; i < self.show.size; i++)
			{
				if(isdefined(self.show[i]))
					self.show[i] show();
			}
		}
	}
}


action_mg42_use(nGunner, nMG42, nNode)
{	
	nGunner endon ("death");
	level endon ("capturedbunker");
	
	while(1)
	{
		//Get close to gun
		
		nGunner.goalradius = 64;
		nGunner setgoalnode(nNode);
		nGunner waittill ("goal");
		
		//Use the gun
		
		nGunner useturret(nMG42);
		nMG42 setmode("auto_ai");
		nMG42 notify ("startfiring");
		
		level waittill ("suppression");	//bunker_suppression
		//println("WE ARE SUPPRESSED!");	
		
		nGunner stopuseturret();
		
		level waittill ("good to go");	//bunker_timeout
	}
}

smoke_bunker02()
{
	trigger = getent("smoke_bunker02_trig","targetname");
	trigger waittill("trigger");
	wait 3;
	level.randall dialogue_thread("hill400_assault_rnd_getsmoke");
	//iprintlnbold ("Someone get a smoke grenade out there!!!");		
	wait 2;
	maps\_utility::exploder(1);
	wait 1;
	maps\_utility::exploder(2);	
	wait 10;
	level.randall dialogue_thread("hill400_assault_rnd_gogogo");	


}

smoke_hilltop()
{
	trigger = getent("hilltop_smoke","targetname");
	trigger waittill("trigger");
	
	level.randall dialogue_thread("hill400_assault_rnd_concealsmoke");
	//iprintlnbold ("We need more concealment! Put up a smokescreen!!! Use your smoke grenades!!");

	wait 2;
	maps\_utility::exploder(3);
	wait 10;
	maps\_utility::exploder(4);
	wait 30;
	maps\_utility::exploder(5);	
	wait 5;
	maps\_utility::exploder(4);	
	wait 4;
	maps\_utility::exploder(5); 
	wait 20;
	maps\_utility::exploder(4);
	wait 50;
	maps\_utility::exploder(4);	
	wait 14;
	maps\_utility::exploder(5); 
	
	 

}


cover_think()
{
	self waittill("trigger");

	while(1)
	{
		level.cover_trigger = self;
//		if (isdefined (self.script_noteworthy))
//			level notify (self.script_noteworthy);

		while(level.player istouching(self))
			wait(0.25);
			
		level.cover_trigger = undefined;

		self waittill("trigger");
	}
}

player_is_safe()
{

	if((isdefined(level.cover_trigger)) && (level.player getstance() != "stand"))
		return true;

	return false;
}

select_cover()
{
	coverlist = getnodearray(self.target, "targetname");
	ailist = [];

	for(;;)
	{
		self waittill("trigger", other);
		
		if(!isdefined(other.script_idnumber))
			continue;
			
		if(foundinarray(other.script_idnumber, ailist))
			continue;
		
		ailist[ailist.size] = other.script_idnumber;
		storedradius = other.goalradius;
		other.goalradius = 8;
		
		bestrow = 99;
		for(i = 0; i < coverlist.size; i++)
		{
			currentrow = int(coverlist[i].script_namenumber);
			if(currentrow < bestrow)
				bestrow = currentrow;
		}
		
		bestdist = 999999;
		bestcover = undefined;
		for(i = 0; i < coverlist.size; i++)
		{
			currentrow = int(coverlist[i].script_namenumber);
			if(currentrow != bestrow)
				continue;
			
			dist = distance(other.origin, coverlist[i].origin);
			if(dist < bestdist)
			{
				bestdist = dist;
				bestcover = coverlist[i];
			}
		}

		if(isdefined(bestcover))
		{
			coverlist = array_remove(coverlist, bestcover);
			other setgoalnode(bestcover);
			other thread resetgoalradius(storedradius);
		}
		else
			iprintln("^6select_cover ran out of cover nodes");
	}	
}

foundinarray(element, array)
{
	for(i = 0; i < array.size; i++)
	{
		if(array[i] == element)
			return true;
	}
	
	return false;
}

resetgoalradius(storedradius)
{
	self notify("end_watchdeath");

	level.guys--;
	if(level.guys == 0)
		level notify("guys");

}

watchdeath()
{
	self endon("end_watchdeath");

	self waittill("death");
	level.guys--;

	
	if(level.guys == 0)
		level notify("guys");
}

crater_sequence()
{
	level waittill ("go crater scene");
	level.randall dialogue_thread("hill400_assault_rnd_holdrighthere");

	//level waittill("guys");	
	wait 3;
	level.randall dialogue_thread("hill400_assault_rnd_getsatchelcharges");
	wait 0.5;
	level.randall dialogue_thread("hill400_assault_rnd_getsmoke");	
	wait 0.5;
	level.randall thread maps\_hardpoint::waitUntilSmokeIsThrown(getent("smokeright", "targetname"));
	wait 1;
	level.gr1 thread maps\_hardpoint::waitUntilSmokeIsThrown(getent("smokeleft", "targetname"));
	wait 2;

	smokeright = getent("smokeright", "targetname");
	playfx(level.smokegrenade, smokeright.origin);
	wait 1.5;

	smokeleft = getent("smokeleft", "targetname");
	playfx(level.smokegrenade, smokeleft.origin);
	wait 3;

	level.randall dialogue_thread("hill400_assault_rnd_gogogo");
	//temp_message(level.randall, "Go! Go! Go!", 0.3);
	

	level thread minefield_warn();
	level thread minefield_warn2();
	level thread minefield_warn3();


//move in
	level.randall setgoalnode(getnode("bunker_nixon", "targetname"));
	level.braeburn setgoalnode(getnode("bunker_braeburn", "targetname"));
	level.mccloskey setgoalnode(getnode("bunker_mccloskey", "targetname"));
	level.myers setgoalnode(getnode("bunker_myers", "targetname"));

	left = getentarray("coverleft", "script_noteworthy");
	left = array_remove(left, level.myers);
	bunkerleft = getnodearray("bunker_left", "targetname");
	level thread movein(left, bunkerleft);

	right = getentarray("coverright", "script_noteworthy");
	right = array_remove(right, level.randall);
	right = array_remove(right, level.braeburn);
	right = array_remove(right, level.mccloskey);
	bunkerright = getnodearray("bunker_right", "targetname");
	level thread movein(right, bunkerright);
	

	axis = getaiarray("axis");
	for(i = 0; i < axis.size; i++)
		axis[i].ignoreme = false;
}

minefield_warn()
{
	trigger = getent("minefield_warn01","targetname");
	trigger waittill("trigger");
	
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_minefieldwarning");
	level thread kill_fc01();
	level thread kill_fc02();
	level thread kill_fc03();
		
}

minefield_warn2()
{
	trigger = getent("minefield_warn02","targetname");
	trigger waittill("trigger");
	
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_minefieldwarning");
		
}

minefield_warn3()
{
	trigger = getent("minefield_warn03","targetname");
	trigger waittill("trigger");
	
	wait 1;
	level.randall dialogue_thread("hill400_assault_rnd_minefieldwarning");
		
}

movein(guys, nodes)
{
	for(i = 0; i < guys.size; i++)
	{
		if(!isalive(guys[i]))
			continue;
			
		chosen = nodes[randomint(nodes.size)];
		guys[i] setgoalnode(chosen);
		nodes = array_remove(nodes, chosen);
	}
}

bunker_spawn()
{
	holdout_trigger = getent("holdout_trigger", "targetname");
	holdout_spawner = getentarray(holdout_trigger.target, "targetname");
	array_thread(holdout_spawner, ::bunker_spawn_thread);

	level waittill("forwardbunker_breached");
		
	wait 1;
	level.randall.anim_forced_cover = "none";
	level.braeburn.anim_forced_cover = "none";
	//level.mccloskey.anim_forced_cover = "none";
	
}

bunker_spawn_thread()
{
	self waittill("spawned", holdout_guy);
	
	if(spawn_failed(holdout_guy))
		return;
		
	level.holdouts[level.holdouts.size] = holdout_guy;
	
	waittillframeend;
	level notify("holdouts_spawned");
	
	if(isdefined(holdout_guy.script_noteworthy) && holdout_guy.script_noteworthy == "thrower")
	{
		throw_end = getent("throw_start", "targetname");
		throw_start = getent("throw_end", "targetname");
		//thread drawline(throw_start.origin, throw_end.origin);
		
		holdout_guy magicgrenade(throw_end.origin, throw_start.origin, 3);
	}
}

test_thread()
{
	self waittill("death");
	iprintln("^6I DIED!");
}

drawline(start, end)
{
	while(1)
	{
		line(start, end, (1,0,0));
		wait .05;
	}
}

bunker_escape(node)
{
	wait 3;
	self setgoalnode(node);
}

count_time()
{
	level endon("kill_time");
	
	time = 0;
	while(1)
	{
		wait 1;
		time++;
		iprintln("time: ", time);
	}
}

stopwatch(bomb)
{
	if (isdefined (self.bombstopwatch))
		self.bombstopwatch destroy();
	self.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	wait level.explosiveplanttime;
	bomb stoploopsound ("bomb_tick");
	level.timersused--;
	if (level.timersused < 1)
	{
		if (isdefined (self.bombstopwatch))
			self.bombstopwatch destroy();
	}
}

//NEBAL STUFF FROM MOSCOW
misc2()
{
	level waittill("ht02 spawned");
			
	wait 5;
	nebel = level.halftrack02;
	nebel thread nebelwerfers();
	trigs = getent("fireoff2", "targetname");
	trigs thread fire2(nebel);
}

fire2(nebel)
{
	self waittill("trigger");
	
	for(i=1;i<4;i++)
	{
		nebel thread nebelwerfers_makerocket(i, self, (0));
	}
}

nebelwerfers()
{
	trigger = undefined;

	trigger = getent("stop_fire2","targetname");
	//pause = getent("pause_fire2","targetname");
	//resume = getent("resume_fire2", "targetname");
	
	//pause thread nebelwerfers_pause(resume, trigger);
	
	trigger endon("trigger");
	
	while(1)
	{
		rockets = 0;
		for(i=1;i<7;i++)
		{
			self thread nebelwerfers_makerocket(i, trigger, (i%2));
		}
		
		while(rockets < 6 )
		{
			level waittill("fired_rockets");
			rockets++;	
		}
		wait 4 + randomfloat(3);
		//while(level.flag["pause_nebel"])
			//level waittill("resume_nebel");
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

nebelwerfers_makerocket(index, trigger, num)
{
	self endon ("death");	
	tagname = "tag_rocket_base_0" + index;
	rocket = spawn("script_model", (self gettagorigin(tagname)) );
	rocket.tagname = tagname;
	rocket.angles = self gettagangles(tagname);
	rocket setmodel("xmodel/vehicle_halftrack_rockets_shell");
	rocket linkto(self, tagname);
	
	trigger endon("trigger");
	
	wait ((level.werfertime * num * .5) + (num * 6) + (randomfloat(2)));
	rocket thread nebelwerfers_firerocket();
}

nebelwerfers_firerocket()
{
	level notify("fired_rockets");
	self playsound("nebelwerfer_fire");//, self.origin);
	x = 35;
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


charge_anim()
{
	self.run_noncombatanim = %combat_run_fast_3;
	level waittill("charge done");
	self.run_noncombatanim = undefined;
}

#using_animtree("scripted_anim");
doorblast_anim(door)
{
	door UseAnimTree(#animtree);
	door setanim(%hill400_bunkerdoor_01);
}


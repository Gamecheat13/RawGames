//
// file: ber3_event_wave.gsc
// description: "ride the wave" event script for berlin3
// scripter: slayback
//
// ber3_plaza_statue

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\ber3;
#include maps\ber3_util;
#include maps\_music;

// -- STARTS --
// start at the start of the plaza event
event_plaza_start()
{	
	// set up the spawners for the level
	thread simple_spawners_level_init();	
	
	warp_players_underworld();
	
	warp_friendlies( "struct_plaza_start_friends", "targetname" );	// Put friendlies in the correct location
	GetEnt( "trig_spawn_basement_friendlies", "script_noteworthy" ) notify( "trigger" );	// spawn other AI 
	GetEnt( "trig_e2_friendlies_start", "script_noteworthy" ) notify( "trigger" );	// move friendlies to correct spot
	getent("e2_trig_spawn_plaza_mgs", "script_noteworthy") notify("trigger");	// spawn the mgs in the plaza

	// spawn repopulate_flak on each of the flaks in the level
	for(i = 0; i < 4; i++)
	{
		// don't allow the repopulating of this specific flak
		if(i != 1)
		{
			thread wait_repopulate_flak(i + 10);
		}
	}
	
	// spawn the flaks that should already exist
	flak_trigs = getentarray("trig_e2_spawn_flak", "script_noteworthy");
	for(i = 0; i < flak_trigs.size; i++)
	{
		flak_trigs[i] notify("trigger");
		wait_network_frame();
	}	
	
	remove_allies = getentarray("rus_leave_at_library", "script_noteworthy");
	for(i = 0; i < remove_allies.size; i++)
	{
		remove_allies[i] notify( "_disable_reinforcement" );
		remove_allies[i] delete();
	}
	
	warp_players( "struct_plaza_start", "targetname" );

	// set up some of the drone triggers
	thread maps\ber3_event_intro::e1_drones();
	
	// remove some unwanted actors
	thread maps\ber3_event_intro::delete_street_allies();
	wait(1);
	getent("trig_left_street", "targetname") notify("trigger");

	// start the event scripting
	level thread e2_init_charge();
	
	wait(1);
	
	getent("trig_entering_basement", "targetname") notify("trigger");
}
// -- END STARTS --

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Event 2:  Player charges the Plaza
////////////////////////////////////////////////////////////////////////////////////////////////////////

e2_init_charge()
{
	thread reich_fake_mg_fire();
	
	//e2_init_friendly_spawners();
	thread move_tank_2();
	
	getent("trig_entering_basement", "targetname") waittill("trigger");
	
	level.e1_rez_10_done = false;
	thread reznov_cellar_vo();
	
	//thread lower_veteran_nade_count();
	thread remove_e1_friendlies();
	thread move_street_tanks();
	thread move_charging_tanks();
	thread e2_drone_battle_right_init();
	thread e2_tank_plaza_logic();
	thread destroy_mg();
	
	getent("trig_leaving_basement", "targetname") waittill("trigger");
	
	thread first_mortar();
	
	thread e2_charge_drones();
	
//	comm_node = getnode("comm_whistle_node", "targetname");
//	level.comm setgoalnode( comm_node );
	
	while(!level.e1_rez_10_done)
	{
		wait(.1);
	}
	
	wait(1);
	
	thread blow_whistle();
	//Kevin's notify for the battle cry.
	level notify("battle_cry");
	
	thread e2_charge_destroy_flaks_vo();

	pClip = getent("e2_charge_player_clip", "targetname");
	pClip delete();

	level notify("stop katyusha");

	//TUEY set music state to Last Fight
	setmusicstate("LAST_FIGHT");

	getent("e2_start_charge", "targetname") notify("trigger");					// move the tanks up
	getent("e2_friendlies_charge", "targetname") notify("trigger"); 		// have the friendlies move
	//getent("e2_plaza_germans", "script_noteworthy") notify("trigger");	// send in the germans
	
	// Now start the objectives for the event
	thread e2_objectives();
	thread e2_friendly_fodder();
	//thread maps\ber3_event_steps::e3_tanks_init();		// initializing the tanks now
	thread e2_plaza_planes_init();										// send in the planes
	thread e2_plaza_amb_left();
	thread maps\ber3_event_steps::e3_init_event();		// thread early in case the player runs forward
}

lower_veteran_nade_count()
{
	if( getDifficulty() == "fu" )
	{
		germs = getentarray("veteran_remove_grenades", "script_noteworthy");
		
		array_thread( germs, ::add_spawn_function, ::veteran_remove_grenades );
	}
}

veteran_remove_grenades()
{
	self.grenadeAmmo = 0;
}

e2_charge_drones()
{
	for(i = 0; i < level.trig_charge_drones.size; i++)
	{
		// pause between the spawns
		while( !OkToSpawn() )
		{
			wait_network_frame();
		}			
		
		if(NumRemoteClients()) // Fewer charging drones in coop
		{
			if(i % 2)
			{
				level.trig_charge_drones[i] notify("trigger");	// send in the drones
			}
			else
			{
				level.trig_charge_drones[i] delete();	// delete this drone trigger - fewer drones in coop
			}
		}
		else
		{
				level.trig_charge_drones[i] notify("trigger");	// send in the drones
		}		
		wait(0.1);
	}
}

reznov_cellar_vo()
{
	level.sarge	anim_single_solo(level.sarge, "e1_rez_wait_signal");	// "Wait for the signal."
	level.sarge	anim_single_solo(level.sarge, "e1_rez_09");	// "It is almost over."
	level.sarge	anim_single_solo(level.sarge, "e1_rez_10");	// "Today is the day of our glorious vengeance! For ourselves... and for mother Russia!"
	
	level.e1_rez_10_done = true;
}


e2_charge_destroy_flaks_vo()
{
	level.sarge	thread anim_single_solo(level.sarge, "e1_rez_11");	// "Charge!!!"
	
	getent("trig_vo_destroy_flaks", "targetname") waittill("trigger");
	
	level.sarge anim_single_solo(level.sarge, "e2_rez_01");	// "We need to destroy the 88s before our can armor move up!"
	level.sarge anim_single_solo(level.sarge, "e2_rez_02");	// "Killing the crews is not enough…"
	level.sarge anim_single_solo(level.sarge, "e2_rez_03");	// "The emplacement itself must be obliterated!"
	level.sarge anim_single_solo(level.sarge, "e2_rez_04");	// "Plant charges... Find a bazooka…"
	level.sarge anim_single_solo(level.sarge, "e2_rez_05");	// // "Do whatever it takes to blow the bastards to hell!!!"
}



e2_init_friendly_spawners()
{
	base_guy_spawner = getent("e2_basement_guy", "script_noteworthy");
	base_guy_spawner thread add_spawn_function(::init_basement_guy );
}



init_basement_guy()
{
	level.base_guy = self;
	level.base_guy.animname = "basement_guy1";	
}



move_street_tanks()
{
	tank2 = getent("e1_tank2", "targetname");
	tank3 = getent("e1_tank3", "targetname");

	if(NumRemoteClients())	// coop
	{
		tank2 delete();
		tank3 delete();
	}
	else
	{
		tank2 thread move_tank_on_trigger("e2_tank2_start_node", "e2_start_charge");
		tank3 thread move_tank_on_trigger("e2_tank3_start_node", "e2_start_charge");	
	}
}



move_charging_tanks()
{
	getent("e2_start_charge", "targetname") waittill("trigger");
	
	// spawn the tanks that charge the plaza
	tank_nodes = getvehiclenodearray("e2_charge_tanks", "targetname");
	
	for(i = 0; i < tank_nodes.size; i++)
	{
		newTank = spawn_tank("vehicle_rus_tracked_t34", tank_nodes[i], false );	
		newTank thread e2_charge_tanks_shoot();
		wait_network_frame();
	}
}

// Have the tank that storms up the plaza fire at random targets
e2_charge_tanks_shoot()
{
	self endon("death");
	
	tank_targs = getstructarray("e2_charge_tank_targ", "targetname");
	
	while(true)
	{
		wait(randomintrange(2, 6));
		
		targ = tank_targs[randomint(tank_targs.size)]; // grab a random target
		
		self setturrettargetvec(targ.origin);
		self waittill ("turret_on_target");
		wait(1);
		self fireWeapon();		
	}
}



// Gets rid of friendlies no longer used at this point in the level
remove_e1_friendlies()
{
	guys = getentarray("e1_friendly_fodder", "script_noteworthy");
	
	for(i = 0; i < guys.size; i++)
	{
		if( isdefined(guys[i]) && isalive(guys[i]) )
		{
			guys[i] delete();
		}
	}	
}

blow_whistle()
{	
	tank2 = getent("e2_tank1", "targetname");	
	tank2 playSound("whistle_blow");
	
	level.comm notify("stop_comm_idle");
	
	level.comm anim_single_solo( level.comm, "comm_whistle" );
	level.comm thread anim_loop_solo( level.comm, "comm_whistle_idle", undefined, "stop_comm_idle" );
}



// Makes sure the guys charging with you die
e2_friendly_fodder()
{
	guys = getentarray("friendly_charge_fodder", "script_noteworthy");
	
	for(i = 0; i < guys.size; i++)
	{
		if( isdefined(guys[i]) && isalive(guys[i]) )
		{
			guys[i] thread bloody_death_after_wait(5, true, 5);
		}
	}
}



// Objectives for the second event
e2_objectives()
{
	wait(3);
	// Objective 4:  Destroy the Flak's
	obj_struct0 = getstruct( "obj_flak88_0", "targetname" );
	obj_struct1 = getstruct( "obj_flak88_1", "targetname" );	
	obj_struct2 = getstruct( "obj_flak88_2", "targetname" );	
	obj_struct3 = getstruct( "obj_flak88_3", "targetname" );	
	
	// Used to update objectives
	level.flaks_alive = 4;
	level.flak0_destroyed = false;
	level.flak1_destroyed = false;
	level.flak2_destroyed = false;
	level.flak3_destroyed = false;
	
	objective_add( 3, "current", &"BER3_OBJ3_4", obj_struct0.origin );
	objective_AdditionalPosition( 3, 1, obj_struct1.origin );		
	objective_AdditionalPosition( 3, 2, obj_struct2.origin );		
	objective_AdditionalPosition( 3, 3, obj_struct3.origin );		
}



e2_objectives_update_flak88()
{
	objective_delete(3);											// Remove the objective so we can update it
	
	objective_add(3,"current");
	
	if(isDefined(level.flaks_alive) && level.flaks_alive)
	{
		switch(level.flaks_alive)
		{
			case 1: 
				objective_string(3, &"BER3_OBJ3_1");	
				thread e2_flak88_vo(level.flaks_alive);
				break;
			case 2:	
				objective_string(3, &"BER3_OBJ3_2");
				autosave_by_name("ber3 two flaks destroyed");
				thread e2_flak88_vo(level.flaks_alive);
				break;
			case 3: 
				objective_string(3, &"BER3_OBJ3_3");
				thread e2_flak88_vo(level.flaks_alive);
				break;
			case 4: 
				objective_string(3, &"BER3_OBJ3_4");
				thread e2_flak88_vo(level.flaks_alive);
				break;
		}
	
		first_set = false;
		obj_index = 1;
		
		if(!level.flak0_destroyed)			// Place a star at the first flak, if it isn't destroyed
		{
			obj_struct0 = getstruct( "obj_flak88_0", "targetname" );
			
			objective_additionalPosition(3, obj_index, obj_struct0.origin);
			obj_index++;
		}

		if(!level.flak1_destroyed)	// Place a star at the third flak, if it isn't destroyed
		{
			obj_struct1 = getstruct( "obj_flak88_1", "targetname" );
			
			objective_AdditionalPosition( 3, obj_index, obj_struct1.origin );
			obj_index++;
		}	
		
		if(!level.flak2_destroyed)	// Place a star at the second flak, if it isn't destroyed
		{
			obj_struct2 = getstruct( "obj_flak88_2", "targetname" );
			
			objective_AdditionalPosition( 3, obj_index, obj_struct2.origin );
			obj_index++;
		}
		
		if(!level.flak3_destroyed)	// Place a star at the third flak, if it isn't destroyed
		{
			obj_struct3 = getstruct( "obj_flak88_3", "targetname" );
			
			objective_AdditionalPosition( 3, obj_index, obj_struct3.origin );
			obj_index++;
		}		
	}
	else
	{
		// all flaks destroyed, print objective and have it marked done
		objective_string(3, &"BER3_OBJ3");
		objective_state( 3, "done");
		
		autosave_by_name("ber3 flaks destroyed");
	}
}

e2_flak88_vo(flaks_left)
{
	switch(flaks_left)
	{
		case 3: 	
			level.sarge anim_single_solo(level.sarge, "e2_rez_flak3_1");				// "One down - three to go!"
			level.sarge	thread anim_single_solo(level.sarge, "e2_rez_flak3_2");	// "Keep going, Dimitri!"
			break;
		case 2: 	
			level.sarge anim_single_solo(level.sarge, "e2_rez_flak2_1");				// "Another one destroyed!"
			level.sarge	thread anim_single_solo(level.sarge, "e2_rez_flak2_2");	// "Two more remain!"	
			break;
		case 1: 
			level.sarge anim_single_solo(level.sarge, "e2_rez_flak1_1");				// "Ha! Dimitri... You are unstoppable!"
			level.sarge	thread anim_single_solo(level.sarge, "e2_rez_flak1_2");	// "Get to the last 88!"	
			break;
		case 0: 
			level.sarge anim_single_solo(level.sarge, "e2_rez_flak0_1");				// "Their artillery is in ruins!"
			level.sarge	thread anim_single_solo(level.sarge, "e2_rez_flak0_2");	// "MOVE IN!!!"	
			break;
	}
}




// Moves the tank outside of the basement, has it fire towards the 88's, gets shot by the 88
move_tank_2()
{
	tank2 = getent("e2_tank1", "targetname");
	tank2 move_tank_on_trigger("e2_tank1_start_node", "trig_entering_basement");
	
	tank_targ = getstruct("e2_tank1_target1", "targetname");
		
	// Have the tank fire towards the plaza
	tank2 setturrettargetvec(tank_targ.origin);
	tank2 waittill ("turret_on_target");
	wait(1);
	tank2 fireWeapon();
	
	getent("e2_tank1_destroy", "targetname") waittill("trigger");
	
	// Have the flak88 shoot the tank
	flak = getent("flak88_11", "targetname");
	aim_org = (tank2.origin + (0,0,40));
	
	flak setTurretTargetVec(aim_org);
	flak waittill("turret_on_target");
	flak clearTurretTarget();	
	
	flak maps\_flak88::shoot_flak(aim_org);
	
	tank2 waittill ("damage");
	
	tank2 notify ("death");		
}



e2_tank_plaza_logic()
{
	getent("e2_start_charge", "targetname") waittill("trigger");
	
	start_node = getvehiclenode("e2_plaza_tank", "targetname");
	tank = spawnvehicle( "vehicle_rus_tracked_t34", "tank", "t34", start_node.origin, start_node.angles );
	tank.vehicletype = "t34";	// safety check, just to make sure the vehicletype is set (needed in maps\_vehicle::vehicle_paths())
	maps\_vehicle::vehicle_init(tank);
	
	tank.script_turretmg = 0;
	
	//tank.health = 10000;
	
	tank attachPath( start_node );
	tank thread maps\_vehicle::vehicle_paths( start_node );   // do tank init path stuffs
	tank startPath();	
	
	level.plaza_tank_move = false;
	thread e2_tank_plaza_wait_move();		// watch for the move up trigger to be hit	
	
	tank veh_stop_at_node("e2_plaza_tank_stop1");
	level waittill ("flak0 destroyed");
	tank resumespeed( 8 );
	
	tank thread e2_tank_plaza_shoot();	// have the tank start shooting at stuffs
	
	tank veh_stop_at_node("e2_plaza_tank_stop2");

	// loop until the trigger is hit (player has a chance to hit trigger before the function gets here, so in that case the tank will just keep going
	while(!level.plaza_tank_move)
	{
		wait(.5);
	}

	tank resumespeed( 8 );		

	// have it start traveling forward, only to get owned
	tank veh_stop_at_node("e2_plaza_tank_stop3");
	tank doDamage( tank.health + 200, (0,0,0) );		
	tank notify("death");
	//tank veh_stop_at_node("stop_node_3");
	
	
}

// Have the tank that storms up the plaza fire at random targets
e2_tank_plaza_shoot()
{
	self endon("death");
	
	tank_targs = getstructarray("e2_plaza_tank_targ", "targetname");
	statue_targ = getstruct("e2_tank1_target2", "targetname");
	
	wait(7);
		
	// Have the tank fire towards the plaza
	self setturrettargetvec(statue_targ.origin);
	self waittill ("turret_on_target");
	self fireWeapon();	
	
	wait(.5);
	
	playfx(level._effect["e2_statue_explode"], statue_targ.origin);
	
	statue = getent("ber3_plaza_statue", "targetname");
	statue delete();	
	
	while(true)
	{
		wait(randomintrange(4, 7));
		
		targ = tank_targs[randomint(tank_targs.size)]; // grab a random target
		
		self setturrettargetvec(targ.origin);
		self waittill ("turret_on_target");
		wait(1);
		self fireWeapon();		
	}
}

e2_tank_plaza_wait_move()
{
	getent("e2_plaza_tank_move", "targetname") waittill("trigger");
	
	level.plaza_tank_move = true;
}



destroy_mg()
{	
	thread e2_satchel_init();
	
	thread watch_flak("trig_dmg_flak0", "flak88_10", 0, "flak0 destroyed");
	thread watch_flak("trig_dmg_flak1", "flak88_11", 1);
	thread watch_flak("trig_dmg_flak2", "flak88_12", 2);
	thread watch_flak("trig_dmg_flak3", "flak88_13", 3);
	
	// Wait for one of the flaks to be destroyed
	//level waittill("flak destroyed");
	
	//tank = getent("e1_tank3", "targetname");
}



watch_flak(trigName, flakName, destVar, specNotify)
{
	flak = getent(flakName, "targetname");
	flak thread wait_stop_flak_firing();
	flak thread watch_flak_death(destVar, specNotify);

	getent(trigName, "targetname") waittill("damage", amount, attacker);
	
	// Used to update objectives correctly
//	destVar = 1;
//	level.flaks_alive--;
//	e2_objectives_update_flak88();	
	
	if( isdefined( attacker ) && isplayer( attacker ) )
	{
		if( isdefined(attacker.damageWeapon) && attacker.damageWeapon == "panzerschrek" )
		{
			flak notify("death");
			level notify("flak destroyed");
		}
	}
}



// Watch for death here in case flak dies without the damage trigger being hit
watch_flak_death(destVar, specNotify)
{
	self waittill("death");
	
	//chris_p - add rumble when flaks are exploded
	level thread rumble_all_players("damage_heavy","damage_light",self.origin,512,512);

	if( isdefined(specNotify) )
	{
		level notify(specNotify);
	}

	// Used to update objectives correctly
	if(destVar == 0)
	{
		level.flak0_destroyed = 1;
	}	
	else if(destVar == 1)
	{
		level.flak1_destroyed = 1;
	}
	else if(destVar == 2)
	{
		level.flak2_destroyed = 1;
	}
	else if(destVar == 3)
	{
		level.flak3_destroyed = 1;
	}
	
	level.flaks_alive--;
	e2_objectives_update_flak88();
	
	if(level.flaks_alive == 0)
	{
		wait(2);
		thread maps\ber3_event_steps::e3_objectives();
	}
}



wait_stop_flak_firing()
{
	self waittill_any("crew dismounted", "crew dead", "death");
	
	self.target = undefined;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Satchel Stuff
////////////////////////////////////////////////////////////////////////////////////////////////////////
e2_satchel_init()
{
	// set the proper hint string to the triggers (to be localized and whatnot)
	trigs = getentarray("trig_flak_objective", "script_noteworthy");
	for(i = 0; i < trigs.size; i++)
	{
		trigs[i] SetHintString( &"BER3_HINT_PLANT_CHARGE" );
	}
	
	flak0 = getent("flak88_10", "targetname");
	flak0_satchel_trig = getent("objective_flak0", "targetname");	
	
	flak1 = getent("flak88_11", "targetname");
	flak1_satchel_trig = getent("objective_flak1", "targetname");
	
	flak2 = getent("flak88_12", "targetname");
	flak2_satchel_trig = getent("objective_flak2", "targetname");
	
	flak3 = getent("flak88_13", "targetname");
	flak3_satchel_trig = getent("objective_flak3", "targetname");	
		
	flak0 thread satchel_setup( flak0_satchel_trig, flak0 );
	flak1 thread satchel_setup( flak1_satchel_trig, flak1 );
	flak2 thread satchel_setup( flak2_satchel_trig, flak2 );
	flak3 thread satchel_setup( flak3_satchel_trig, flak3 );
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
//	FLAK logic
////////////////////////////////////////////////////////////////////////////////////////////////////////

// wait for the flak's spawn group, then call repopulate_flak();
wait_repopulate_flak(spawn_group)
{
	level waittill ( "spawnvehiclegroup" + spawn_group );
	
	wait(1);
	
	flak = getent("flak88_" + spawn_group, "targetname");
	flak repopulate_flak();
}



// If the men on the flak die, repopulate it with more flak folk
repopulate_flak()
{
	self endon("death");
	
	while(true)
	{
		// wait until all flak members are killed
		self waittill("crew dead");
		
		//iprintlnbold("flak crew dead");
		wait(5);
		
		// find the nearest four axis, and have them move to position
		new_flak_gunners = [];  		// the array that will eventually be filled w/ the closest germans
		
		// loop until we have 4 new gunners
		for(; new_flak_gunners.size < 4;)
		{
			guy = get_closest_ai_exclude( self.origin, "axis", new_flak_gunners );
			
			if( isdefined(guy) && isalive(guy) )
			{
				guy.script_ignoreme = 1;
				new_flak_gunners = array_add(new_flak_gunners, guy);
			}
			else
			{
				wait(1);
			}
		}
		
		self thread maps\_flak88::mount_world_flakcrew(new_flak_gunners);
		
		//iprintlnbold("repopulating flak with " + new_flak_gunners.size + " guys");
	}
}

reich_fake_mg_fire()
{	
	clientNotify("rff");
	/*
	fake_reich_mg_trigs = getstructarray("e3_reich_mg_trig", "targetname");
	
	for(i = 0; i < fake_reich_mg_trigs.size; i++)
	{
		//fire_struct = getstruct(fake_reich_mg_trigs[i].target, "targetname");
		fake_reich_mg_trigs[i] thread ambient_fakefire( "level done", true, fake_reich_mg_trigs[i]);
	}
	*/
}
	
	

////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Mortar stuff
////////////////////////////////////////////////////////////////////////////////////////////////////////

first_mortar()
{
	launchers = getstructarray("e2_mortar_start", "targetname");
	targ = getstruct("e2_mortar_targ_first", "targetname" );
	
	launchers[0] thread fire_mortar(targ);
	
	// start up the ambient mortars
	for(i = 0; i < launchers.size; i++)
	{
		launchers[i] thread e2_mortar_looping();
		wait(2);	// wait to put a pause between the two
	}
}



e2_mortar_looping()
{
	thread e2_mortar_looping2();
	level endon("stop first mortar set");
	
	targs = getstructarray("e2_mortar_targ", "targetname" );
	while(true)
	{
		self thread fire_mortar( targs[randomint(targs.size)] ); // fire at a random target
		wait(randomintrange(4, 7));
	}
}

e2_mortar_looping2()
{
	getent("trig_vo_destroy_flaks", "targetname") waittill("trigger");
	
	level notify("stop first mortar set");	// stop the first set of mortars
	
	targs = getstructarray("e2_mortar_targ2", "targetname" );
	while(true)
	{
		self thread fire_mortar( targs[randomint(targs.size)] ); // fire at a random target
		wait(randomintrange(4, 7));
	}	
}



// Mortar stuffs
fake_launch(org)
{
	targs = getstructarray("dirt_mortar","targetname");
	targ = targs[randomint(targs.size)];
}

fire_mortar(targ_struct)
{
	// Play sound/fx of mortar being fired
	playsoundatposition(level.scr_sound["mortar_flash"], self.origin);
	playfx( level._effect["mortar_flash"], self.origin, anglestoforward(self.angles) );
	
	// Wait while mortar travels through air
	wait(randomintrange(4,7));
	
	// play sound/fx of where the mortar hits
	playsoundatposition( "mortar_dirt", targ_struct.origin );
	playfx( level._effect["dirt_mortar"], targ_struct.origin );
	earthquake( 0.5, 2.5, targ_struct.origin, 512);
	
	// apply damage and create a physics explosion to send entities flying
	radiusDamage(targ_struct.origin, 128, 300, 35);
	physicsExplosionSphere(targ_struct.origin, 160, 100, 1);
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Planes in the Plaza
////////////////////////////////////////////////////////////////////////////////////////////////////////

e2_plaza_planes_init()
{
	if(!NumRemoteClients())	// Not in coop.
	{
		il2_nodes = getvehiclenodearray("e2_plaza_planes", "targetname");
		il2_nodes2 = getvehiclenodearray("e2_plaza_planes2", "targetname");
		
		while(true)
		{
			// spawn the planes
			for(i = 0; i < il2_nodes.size; i++)
			{
				thread spawn_plane("vehicle_rus_airplane_il2", il2_nodes[i]);
			}
			
			wait(5);
			
			// spawn the planes
			for(i = 0; i < il2_nodes2.size; i++)
			{
				thread spawn_plane("vehicle_rus_airplane_il2", il2_nodes2[i]);
			}
					
			wait(10);
		}
	}
}



e2_plaza_amb_left()
{
	thread e2_plaza_amb_left_panzer();
}

e2_plaza_amb_left_panzer()
{
	trig = getent("trig_e2_amb_building_schreck", "targetname");
	trig waittill("trigger");
	
	schreck_start = getstruct("e2_amb_building_shreck", "targetname");
	schreck_end = getstruct(schreck_start.target, "targetname");
	thread maps\ber3_event_intro::fire_shrecks(schreck_start, schreck_end, 1);
}



////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Fake battle on right of plaza
////////////////////////////////////////////////////////////////////////////////////////////////////////
e2_drone_battle_right_init()
{
	thread e2_dbattle_right_tanks();
}

// This is sloppy, sorry
e2_dbattle_right_tanks()
{
	if(!NumRemoteClients())	// Not in coop.
	{
		getent("e2_spawn_right_tanks", "targetname") waittill("trigger");
		
		wait(2);
		tank1 = getent("e2_db_tank1", "targetname");
		tank2 = getent("e2_db_tank2", "targetname");
		tank3 = getent("e2_db_tank3", "targetname");
		tank4 = getent("e2_db_tank4", "targetname");
		tank5 = getent("e2_db_tank5", "targetname");
		
		tank1 thread veh_stop_at_node("e2_db_tank1_stop1");
		tank2 thread veh_stop_at_node("e2_db_tank2_stop1");
		tank3 thread veh_stop_at_node("e2_db_tank3_stop1");
		tank4 thread veh_stop_at_node("e2_db_tank4_stop1");
		tank5 thread veh_stop_at_node("e2_db_tank5_stop1");	
		
		
		getent("e2_setup_back_flaks", "targetname") waittill("trigger");
		
		tank1 resumespeed( 8 );
		tank2 resumespeed( 8 );
		tank3 resumespeed( 8 );
		tank4 resumespeed( 8 );
		tank5 resumespeed( 8 );
		
		tank1 thread veh_stop_at_node("e2_db_tank1_stop2");
		tank2 thread veh_stop_at_node("e2_db_tank2_stop2");
		tank3 thread veh_stop_at_node("e2_db_tank3_stop2");
		tank4 thread veh_stop_at_node("e2_db_tank4_stop2");
		tank5 thread veh_stop_at_node("e2_db_tank5_stop2");	
	}
}
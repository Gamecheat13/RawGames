#include maps\_utility;
//#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#using_animtree("generic_human");

//createdistraction()
//startdistraction()
//killdistraction()

//starboard = right side of the ship
//larboard = left side of the ship

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////               THIS IS DECK TWO                  ///////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////




main()
{
	level waittill ( "deck01_complete" );

/*

	// ------------- PLAYER -------------
	// ----------------------------------

	// ------ GLOBAL FUNCTIONS ----------
	level.door_pressure = 0;
	level.kratt_death = 0;
	level thread global_kratt_holding_vesper02();
	// ----------------------------------

	//--------- HALL FUNCTIONS ----------
	//-----------------------------------

	// ------ ROOM ONE FUNCTIONS --------
	level thread room01_spawn_thugs01_trigger();
	//level thread room01_spawn_thugs02_trigger();
	level thread room_one_deck02_spawn_four_thugs();
	// ----------------------------------

	// ------ GEN ROOM FUNCTIONS --------
	//level thread gen_room_deck02_thugs01();
	// ----------------------------------

	// ------ PUMP ROOM FUNCTIONS -------
	level thread pump_room_deck02_spawn_thugs01_A();
	level thread pump_room_deck02_spawn_thugs01_B();
	level thread pump_room_deck02_damage_pump01();
	level thread pump_room_release_pressure_door();
	level thread pump_room_deck02_light_control();
	// ----------------------------------

	// ------ MESSHALL FUNCTIONS --------
	level thread messhall_water_hits_thugs();
	//level thread messhall_galley_damage_trigger();
	//level thread galley_stove_obj();
	// ----------------------------------

	// ------ BUNK ROOM FUNCTIONS -------
	level thread bunk_room_vesper_screams02();
	// ----------------------------------

	// ------ FUEL ROOM FUNCTIONS -------
	level thread fuel_room_fan_spin();
	level thread fuel_room_fuel_pipe_explode();
	
	//level thread take_control_of_bond();
	// ----------------------------------
	
	
	*/
	
}



/*


////////////////////////////////////////////////////
//////////////// GLOBAL FUNCTIONS //////////////////
////////////////////////////////////////////////////


//avulaj
//mid level save
global_new01_savegame()
{
	savegame ( "barge" );
}

////////////////////////////////////////////////////
//////////////// GLOBAL FUNCTIONS //////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
/////////////// ROOM ONE FUNCTIONS /////////////////
////////////////////////////////////////////////////

//avulaj
//this function grabs an array and makes the thugs pacifist
//then the function grabs the pathnode linked to the spawner
//last the function threads another function that checks for an alert status
room01_spawn_thugs01_trigger()
{
	deck02_room01_spawn_thugs = getent ( "deck02_room01_spawn_thugs", "targetname" );
	deck02_room01_spawn_thugs waittill ( "trigger" );
	
	room01_thug01 = getentarray ( "deck02_room01_thug01_spawner", "script_noteworthy" );

	for (i = 0; i < room01_thug01.size; i++  )
	{
		room01_thugs1[i] = room01_thug01[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( room01_thugs1[i]) )
    { 
			room01_thugs1[i].goalradius = 35;
			room01_thugs1[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//this function grabs an array and makes the thugs pacifist
//then the function grabs the pathnode linked to the spawner
//last the function threads another function that checks for an alert status
//room01_spawn_thugs02_trigger()
//{
//	deck02_room01_spawn_thugs = getent ( "deck02_room01_spawn_thugs", "targetname" );
//	deck02_room01_spawn_thugs waittill ( "trigger" );
	
//	room01_thug02 = getentarray ( "deck02_room01_thug02_spawner", "script_noteworthy" );

//	for (i = 0; i < room01_thug02.size; i++  )
//	{
//		room01_thugs2[i] = room01_thug02[i] stalingradspawn();
//  }
//}

//avulaj
//this function spwans four thugs in an array for cannon fodder
room_one_deck02_spawn_four_thugs()
{
	bow_trigger_spawn_two_thugs = getent ( "bow_trigger_spawn_two_thugs", "targetname" );
	bow_trigger_spawn_two_thugs waittill ( "trigger" );

	room01_thug01_A = getentarray ( "deck02_room01_thug01_A_spawner", "script_noteworthy" );

	for (i = 0; i < room01_thug01_A.size; i++  )
	{
		room01_thugs_A[i] = room01_thug01_A[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( room01_thugs_A[i]) )
    {
    	//iprintlnbold ( "AI failed to spawn" );
    }
  }
}

////////////////////////////////////////////////////
/////////////// ROOM ONE FUNCTIONS /////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
/////////////// GEN ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////

//avulaj
//
//gen_room_deck02_thugs01()
//{
//	deck02_gen_room_spawn_thugs = getent ( "deck02_gen_room_spawn_thugs", "targetname" );
//	deck02_gen_room_spawn_thugs waittill ( "trigger" );
	
//	level thread gen_room_deck02_spawn_thugs01();
	//level thread gen_room_deck02_spawn_thugs02();
//}

//avulaj
//this function spawns four thugs into an array
//two functions are threaded when this array is created
//gen_room_deck02_spawn_thugs01()
//{
//	gen_room_thug01 = getentarray ( "deck02_gen_room_thug01_spawner", "script_noteworthy" );

//	for (i = 0; i < gen_room_thug01.size; i++  )
//	{
//		gen_room_thugs1[i] = gen_room_thug01[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( gen_room_thugs1[i]) )
//    { 
//			gen_room_thugs1[i].goalradius = 35;
//    }
//  }
//}

//avulaj
//this function spawns four thugs into an array
//two functions are threaded when this array is created
//gen_room_deck02_spawn_thugs02()
//{
//	gen_room_thug02 = getentarray ( "deck02_gen_room_thug02_spawner", "script_noteworthy" );

//	for (i = 0; i < gen_room_thug02.size; i++  )
//	{
//		gen_room_thugs2[i] = gen_room_thug02[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( gen_room_thugs2[i]) )
//    { 
// 			gen_room_thugs2[i].goalradius = 24;
//			gen_room_thugs2[i].walkdist = 9999;
//    }
//  }
//}


////////////////////////////////////////////////////
/////////////// GEN ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
////////////// PUMP ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////

//avulaj
//this controls the lights that light up when the door closes
pump_room_deck02_light_control()
{
	pump01_damage_trigger = getent ( "deck02_pump01_damage_trigger", "targetname" );
	pump01_damage_trigger trigger_off();

	ele_light_off_01 = getent ( "ele_light_off_01", "targetname" );	ele_light_off_02 = getent ( "ele_light_off_02", "targetname" );
	ele_light_off_03 = getent ( "ele_light_off_03", "targetname" );	ele_light_off_04 = getent ( "ele_light_off_04", "targetname" );
	ele_light_off_05 = getent ( "ele_light_off_05", "targetname" );	ele_light_off_06 = getent ( "ele_light_off_06", "targetname" );

	ele_light_on_01 = getent ( "ele_light_on_01", "targetname" );	ele_light_on_02 = getent ( "ele_light_on_02", "targetname" );
	ele_light_on_03 = getent ( "ele_light_on_03", "targetname" );	ele_light_on_04 = getent ( "ele_light_on_04", "targetname" );
	ele_light_on_05 = getent ( "ele_light_on_05", "targetname" );	ele_light_on_06 = getent ( "ele_light_on_06", "targetname" );
	
	ele_light_on_01 hide(); ele_light_on_02 hide(); ele_light_on_03 hide(); ele_light_on_04 hide(); ele_light_on_05 hide();
	ele_light_on_06 hide();
	
	level waittill ( "ele_door_closed" );
	ele_light_on_01 show(); ele_light_off_01 hide();
	wait(.5);
	ele_light_on_02 show(); ele_light_off_02 hide();
	wait(.5);	
	ele_light_on_03 show(); ele_light_off_03 hide();
	wait(.5);	
	ele_light_on_04 show(); ele_light_off_04 hide();
	wait(.5);	
	ele_light_on_05 show(); ele_light_off_05 hide();
	wait(.5);	
	ele_light_on_06 show(); ele_light_off_06 hide();
	
	pump01_damage_trigger trigger_on();

	level waittill ( "ele_door_blown" );
	wait(1.5);
	
	ele_light_on_01 hide(); ele_light_off_01 show();
	wait(.5);
	ele_light_on_02 hide(); ele_light_off_02 show();
	wait(.5);	
	ele_light_on_03 hide(); ele_light_off_03 show();
	wait(.5);	
	ele_light_on_04 hide(); ele_light_off_04 show();
	wait(.5);	
	ele_light_on_05 hide(); ele_light_off_05 show();
	wait(.5);	
	ele_light_on_06 hide(); ele_light_off_06 show();
}

//avulaj
//this function grabs an array and makes the thugs pacifist
//then the function grabs the pathnode linked to the spawner
//last the function threads another function that will trigger the alert status of the thugs in the array
pump_room_deck02_spawn_thugs01()
{
	pump_room_thugs01 = getentarray ( "deck02_pump_room_thug01_spawner", "script_noteworthy" );

	for (i = 0; i < pump_room_thugs01.size; i++  )
	{
		pump_room_thugs[i] = pump_room_thugs01[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( pump_room_thugs[i]) )
    { 
			pump_room_thugs[i].goalradius = 24;
			pump_room_thugs[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//
pump_room_deck02_spawn_thugs01_A()
{
	pump_room_thugsA = getentarray ( "deck02_gen_room_thug01_spawner_A", "script_noteworthy" );
	gen_spawn_trigger = getent ( "deck02_gen_room_spawn", "targetname" );
	gen_spawn_trigger waittill ( "trigger" );

	//iprintlnbold ( "TRIGGER A" );
	
	gen_spawn_triggerB = getent ( "deck02_gen_room_spawn_B", "targetname" );
	gen_spawn_triggerB trigger_off();

	for (i = 0; i < pump_room_thugsA.size; i++  )
	{
		pump_room_thugs[i] = pump_room_thugsA[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( pump_room_thugs[i]) )
    { 
			pump_room_thugs[i].goalradius = 24;
			pump_room_thugs[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//
pump_room_deck02_spawn_thugs01_B()
{
	pump_room_thugsB = getentarray ( "deck02_gen_room_thug01_spawner_B", "script_noteworthy" );
	gen_spawn_triggerB = getent ( "deck02_gen_room_spawn_B", "targetname" );
	gen_spawn_triggerB waittill ( "trigger" );

	//iprintlnbold ( "TRIGGER B" );

	gen_spawn_trigger = getent ( "deck02_gen_room_spawn", "targetname" );
	gen_spawn_trigger trigger_off();

	for (i = 0; i < pump_room_thugsB.size; i++  )
	{
		pump_room_thugs[i] = pump_room_thugsB[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( pump_room_thugs[i]) )
    { 
			pump_room_thugs[i].goalradius = 24;
			pump_room_thugs[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//This function grabs three different script origins for FX use
//once the trigger has been damaged the fx will play
//the variable level.door_pressure is increased each time a pump is damaged
//A hurt trigger is turned on to cause damge if anything gets to close to the flames
pump_room_deck02_damage_pump01()
{
	//this is for when the pump gen blows
	fxboom1	= LoadFx ( "maps/barge/barge_exp_generator01" );
	//this is for when the door is blown off the hinges
	fxboom2	= LoadFx ( "maps/barge/barge_exp_generator04" );
	//this id for when flames are shot out the window
	fxboom3	= LoadFx ( "maps/barge/barge_exp_generator03" );
	
	pump01_damage_trigger = getent ( "deck02_pump01_damage_trigger", "targetname" );
	pump01_damage_trigger waittill ( "damage" );
	level notify ( "ele_door_blown" );
	gen_pump01 = getent ("deck02_gen_pump01", "targetname");
	pumporigin = gen_pump01.angles;

	flame_out_window = getent ("deck02_flame_out_window_of_pump01", "targetname");
	windoworigin = flame_out_window.angles;

	blow_door = getent ("deck02_blow_door_to_pump01", "targetname");
	doororigin = blow_door.angles;
	
	fx = playfx (fxboom1, gen_pump01.origin, pumporigin);
	gen_pump01 playSound( "Expl_Barge_GasHeater" );
	wait(.5);
	fx = playfx (fxboom2, blow_door.origin, doororigin);
	wait(.5);
	fx = playfx (fxboom3, flame_out_window.origin, windoworigin);
	fx = playfx (fxboom3, gen_pump01.origin, pumporigin);
	
	level.door_pressure++;
}

//avulaj
//This function is waiting for level.door_pressure to = 2 then the door will open
pump_room_release_pressure_door()
{
	while (1)
	{
		wait(1);
		if (level.door_pressure == 1)
		{
			wait(1);
			level thread pump_room_release_steam();
			wait(1.5);
			pump_room_main_door = getent ( "deck02_pump_room_main_door", "targetname" );
			pump_room_main_door rotateYaw(115, 2);
			
			level thread messhall_thugs01_spawn();
			level thread messhall_spawn_thugs_patrol();
			level thread bunk_room_spawn_thugs01();
			level thread bunk_room_spawn_thugs01_B();
			break;
		}
	}
}

//avulaj
//this controlls all the steam that get created when the player releases the pressure dfrom the door
pump_room_release_steam()
{
	fxsteam = loadfx ( "impacts/pipe_steam" );
	steam_pressure = getentarray ( "deck02_steam_pressure", "targetname" );
	
	for (i = 0; i < steam_pressure.size; i++  )
	{
		fxid = playfx ( fxsteam, steam_pressure[i].origin, steam_pressure[i].angles );
	}
}

////////////////////////////////////////////////////
////////////// PUMP ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
////////////// MESSHALL FUNCTIONS //////////////////
////////////////////////////////////////////////////

//avulaj
//when this function is triggered water bust out of a pipe and knockes two thugs over
//right now it just kills them since ragdoll isn't working
messhall_water_hits_thugs()
{
	water_damage_trigger = getent ( "messhall_water_does_damage_trigger", "targetname" );
	water_damage_trigger trigger_off();
	fxwater	= LoadFx ( "misc/water_gush" );

	water_pipe_origin = getent ( "messhall_water_pipe_origin", "targetname" );
	water_pipe_trigger = getent ( "messhall_water_pipe_trigger", "targetname" );
	water_pipe_trigger waittill ( "trigger" );
	
	//level thread messhall_raise_water();
	
	fxid = playfx (fxwater, water_pipe_origin.origin);
	water_damage_trigger trigger_on();
	wait(3);
	water_damage_trigger trigger_off();
}

//avulaj
//this function grabs an array of thugs
//then the function grabs the pathnode linked to the spawner
messhall_thugs01_spawn()
{
	messhall_spawners = getentarray ( "deck02_messhall_thugs", "script_noteworthy" );
	
	for (i = 0; i < messhall_spawners.size; i++  )
	{
		messhall_thugs[i] = messhall_spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( messhall_thugs[i]) )
    {
			messhall_thugs[i].targetname = "messhall_thugs" + i;
			messhall_thugs[i] lockalertstate( "alert_red" );
			messhall_thugs[i].goalradius = 35;
    }
  }
}


//avulaj
//this function spawns an array of thugs
messhall_spawn_thugs_patrol()
{
	messhall_trigger_spawn_thugs = getent ( "deck02_messhall_spawn_thugs_patrol", "targetname" );
	messhall_trigger_spawn_thugs waittill ( "trigger" );
	
//	messhall_thug_stairs = getent ( "deck02_messhall_thugs_stairs", "targetname" )stalingradspawn( "messhall_thug_stairs" );
//	messhall_thug_stairs waittill ("finished spawning");

	messhall_thugs_patrol = getentarray ( "deck02_messhall_thugs_patrol", "script_noteworthy" );
	
	for (i = 0; i < messhall_thugs_patrol.size; i++  )
	{
		messhall_patrol[i] = messhall_thugs_patrol[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( messhall_patrol[i]) )
    {
    	messhall_patrol[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//THIS IS TEMP
//this function sets up a look at trigger and spawns kratt & vesper
global_kratt_holding_vesper02()
{
	pump_room_main_door = getent ( "deck02_pump_room_main_door", "targetname" );
	pump_room_main_door rotateYaw(115, 2);
	pump_room_main_door connectpaths();
	
	deck02_new_pump_door = getent ( "deck02_new_pump_door", "targetname" );

	prime_look_at = getent ( "deck02_prime_look_at_trigger02", "targetname" );
	prime_look_at waittill ( "trigger" );

	level thread pump_room_deck02_spawn_thugs01();
	prime_look_at trigger_off();

	kratt = getent ("deck02_kratt02", "targetname")  stalingradspawn( "kratt" );
	kratt waittill ("finished spawning");
	kratt thread check_kratt_dead();
	kratt lockalertstate( "alert_green" );
	vesper = getent ("deck02_vesper02", "targetname");
	vesper linkto( kratt, "tag_origin", ( 8, 8, 0 ), ( 0, 0, 0 ) );
	if( !maps\_utility::spawn_failed( kratt ) )
   { 
			kratt.goalradius = 35;
			level thread kratt_text_kill( kratt );
   }

	deck02_new_pump_door rotateYaw(115, 1);
	deck02_new_pump_door connectpaths();

	iprintlnbold ( "Vesper screams for Bond!!!" );
	
	node01 = getnode ( "deck02_kratt_vesper_node01", "targetname" );
	wait(.5);
	kratt setgoalnode ( node01 );
	kratt lockalertstate( "alert_red" );
	
	level thread global_kratt_dialog( kratt );

	close_door = getent ( "pump_room_close_door", "targetname" );
	close_door waittill ( "trigger" );
	level thread messhall_close_door( pump_room_main_door );

	kratt waittill ( "goal" );
	vesper delete();
	kratt delete();
	level thread global_new01_savegame();
}

//avulaj
//this is checking if the player killed kratt if so the player failed
check_kratt_dead()
{
	self waittill ( "damage" );
	iprintlnbold ( "You killed Vesper." );
	missionfailed();
	return;
}

//avulaj
//
messhall_close_door( door )
{
	door rotateYaw(-115, .5);
	door disconnectpaths();
	level notify ( "ele_door_closed" );
}

//avulaj
//This is TEMP this the line of VO Kratt would say, it is placed above his head in red text this is for testing
kratt_text_kill( kratt )
{
	while(1)
	{
		wait(.01);
		if (!isdefined ( kratt ))
		{
			//iprintlnbold ( "break out of loop" );
			break;
		}
		else
		{
			pos = kratt.origin + (0, 0, 64);
			color = (.5, 0, 0);            
			scale = 1.5;       
			Print3d( pos, "Get him! Kill Bond!", color, 1, scale, 1);
		}
	}
}


//avulaj
//This is TEMP this puts the word Kratt above his head in red text this is for testing
kratt_text( kratt )
{
	while(1)
	{
		wait(.01);
		if (!isdefined ( kratt ))
		{
			break;
		}
		else
		{
			pos = kratt.origin + (0, 0, 64);
			color = (.5, 0, 0);            
			scale = 1.5;       
			Print3d( pos, "KRATT", color, 1, scale, 1);
		}
	}
}


////////////////////////////////////////////////////
////////////// MESSHALL FUNCTIONS //////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
////////////// BUNK ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////


//avulaj
//this function spawns an array of thugs
bunk_room_spawn_thugs01()
{
	bunk_room_spawn_thugs = getent ( "deck02_bunk_room_spawn_thugs", "targetname" );
	bunk_room_spawn_thugs waittill ( "trigger" );

	//iprintlnbold ( "TRIGGER A" );
	
	bunk_room_spawn_thugsB = getent ( "deck02_bunk_room_spawn_thugs_B", "targetname" );
	bunk_room_spawn_thugsB trigger_off();
	
	bunk_room_spawn_thugs = getentarray ( "deck02_bunk_room_thug01_spawner", "script_noteworthy" );
	
	for (i = 0; i < bunk_room_spawn_thugs.size; i++  )
	{
		bunk_room_thugs[i] = bunk_room_spawn_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( bunk_room_thugs[i]) )
    {
    	bunk_room_thugs[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//this function spawns an array of thugs
bunk_room_spawn_thugs01_B()
{
	bunk_room_spawn_thugsB = getent ( "deck02_bunk_room_spawn_thugs_B", "targetname" );
	bunk_room_spawn_thugsB waittill ( "trigger" );

	//iprintlnbold ( "TRIGGER B" );
	
	bunk_room_spawn_thugs = getent ( "deck02_bunk_room_spawn_thugs", "targetname" );
	bunk_room_spawn_thugs trigger_off();

	bunk_room_spawn_thugsB = getentarray ( "deck02_bunk_room_thug01_spawner_B", "script_noteworthy" );
	
	for (i = 0; i < bunk_room_spawn_thugsB.size; i++  )
	{
		bunk_room_thugs[i] = bunk_room_spawn_thugsB[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( bunk_room_thugs[i]) )
    {
    	bunk_room_thugs[i] lockalertstate( "alert_red" );
    }
  }
}

//avulaj
//this just makes vesper scream
bunk_room_vesper_screams02()
{
	vesper_screams = getent ( "global_vesper_scream03", "targetname" );
	vesper_screams waittill ( "trigger" );

	iprintlnbold ( "Vesper screams for Bond!!!" );
}

////////////////////////////////////////////////////
////////////// BUNK ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
////////////// FUEL ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////




//avulaj
//THIS IS TEMP

take_control_of_bond()
{
	deck02_fuel_room_start = getent ( "deck02_fuel_room_start", "targetname" );
	deck02_fuel_room_start waittill ( "trigger" );
	level notify ( "drop_kill_trigger" );

	level notify ( "fodder_non_agro" );
	
	level thread fuel_room_spawn_bodyguards();

	kratt = getent ("krattspawner", "targetname") stalingradspawn( "kratt" );
	kratt waittill ("finished spawning");
	kratt lockalertstate( "alert_green" );
	level thread global_kratt_dialog( kratt );
	vesper = getent ("deck02_vesper03", "targetname");

	level thread ready_fight_kratt( kratt, vesper );

	vesper linkto( kratt, "tag_origin", ( 8, 8, 0 ), ( 0, 0, 0 ) );

	level thread kratt_text( kratt );
	
	fuel_room_main_door = getent ("fuel_room_main_door", "targetname");
	fuel_room_main_door rotateYaw(90, .5);

	bondstart = getent ("fuel_room_start_node", "targetname");
	bondgoto = getent ("fuel_room_move_node01", "targetname");
	bondgoto2 = getent ("fuel_room_move_node02", "targetname");
	
	org = spawn("script_origin",level.player.origin);
	
	level.player linkto( org );
	level.player freezeControls(true);
	wait (.5);
	
	org moveTo (bondstart.origin, 1);
	org waittill ("movedone");
	
	org moveTo (bondgoto.origin, 2);
	wait (2);
	org waittill ("movedone");

	org moveTo (bondgoto2.origin, 2);
	org waittill ("movedone");

	fuel_room_main_door = getent ("fuel_room_main_door", "targetname");
	fuel_room_main_door rotateYaw(-90, .5);

	level.player unlink();
	level.player freezeControls(false);
	wait(.5);
	savegame ( "barge" );
	kratt lockalertstate( "alert_yellow" );
	level thread global_kratt_dialog( kratt );
	level notify ( "agro_bodyguards" );
	level.player SetWeaponAmmoStock( "beretta", 800 );
	
	deck02_fuel_room_start trigger_off();
	
	kratt waittill ( "death" );
	if ( level.kratt_death == 0 )
	{
		iprintlnbold ( "You killed Vesper." );
		missionfailed();
		return;
	}
	//vesper delete();
	level notify ( "kratt_dead" );
}

//avulaj
//this waits till all of the thugs are dead then makes kratt aggro
ready_fight_kratt( kratt, vesper )
{
	level waittill ( "fight_kratt" );
	vesper delete();
	kratt lockalertstate( "alert_red" );
}

//avulaj
//this randonly plays VO form Kratt
//TEMP I am using the bombers VO for temp till I get VO for Kratt
global_kratt_dialog( kratt )
{

	dialog[0] = "vo_bomber_get_him";
	dialog[1] = "vo_bomber_get_him_behind_me";
	dialog[2] = "vo_bomber_get_him_3_times";
	dialog[3] = "vo_bomber_go_go_go";
	dialog[4] = "vo_bomber_hurry_hurry";
	dialog[5] = "vo_bomber_right_behind_me";
	dialog[6] = "vo_bomber_right_there";

	i = randomint(7);

	kratt playsound( dialog[i] );
}

//avulaj
//this controlls Kratt's bodyguard's spawn and their health
fuel_room_spawn_bodyguards()
{
	fuel_room_bodyguard_spawner = getentarray ( "fuel_room_bodyguard", "script_noteworthy" );
 	level.fuel_room = 0;
	
	for (i = 0; i < fuel_room_bodyguard_spawner.size; i++  )
	{
		fuel_room_bodyguards[i] = fuel_room_bodyguard_spawner[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( fuel_room_bodyguards[i]) )
    {
    	fuel_room_bodyguards[i].goalradius = 35;
    	fuel_room_bodyguards[i] lockalertstate( "alert_green" );
    	level.fuel_room++;
			fuel_room_bodyguards[i] thread fuel_room_wait_for_array_to_end();
			fuel_room_bodyguards[i] thread fuel_room_bodyguards_agro( fuel_room_bodyguards );
    }
  }
}

//avulaj
//this function is waitting till the array nolonger exist
//once the array is nolonger defined the Kratt IGC will begin
//fuel_room_bodyguards[i] = self
fuel_room_wait_for_array_to_end()
{
	self waittill ( "death" );
	level.fuel_room--;
	if (level.fuel_room == 0)
	{
		iprintlnbold ( "IGC: KRAT FIGHT BEGINS" );
		iprintlnbold ( "Kill Kratt." );
		level notify ( "fight_kratt" );
		level.kratt_death++;
	}
}

//avulaj
//this function will make the bodyguards in the fuel room agro
fuel_room_bodyguards_agro( aithug )
{
	level waittill ( "agro_bodyguards" );
	wait (1);
	for( i = 0; aithug.size > i; i++ )
	{
		if( IsDefined( aithug[i] ) )
		{
    	aithug[i] lockalertstate( "alert_red" );
		}
	}
}

*/

////////////////////////////////////////////////////
////////////// FUEL ROOM FUNCTIONS /////////////////
////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////// DECK TWO END ///////////////////////////////////////////


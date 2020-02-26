/*-----------------------------------------------------
	OKINAWA 2
 scripter:	Jeremy Statz, inheriting from Chris Pierro
 builder:	Christian Easterly, inheriting from Jeff Zaring
-----------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\oki2_callbacks;
#include maps\_anim;
#include maps\oki2_util;
#include maps\_music;

main()
{
	oki2_init();
	flag_init( "opening_screen_dialogue_complete" );
	
	maps\oki2_fx::main();
	
	// type 94 truck destroy needs this
	maps\_destructible_type94truck::init();

	//_load baby!
	maps\_load::main();

	//level support scripts
	maps\oki2_anim::main();
	maps\oki2_amb::main();
	maps\_mgturret::init_mg_animent();
	maps\_banzai::init();
	maps\_tree_snipers::main();
	
	//camera stuff
	maps\createcam\oki2_cam::main();

	//start ambient packages
	level thread maps\oki2_amb::main();
	level thread maps\oki2_fx::cliffside_ambient_fire();

	// weapon swapping for the flame thrower
	level.onPlayerWeaponSwap = maps\_coop_weaponswap::flamethrower_swap;

	cleanup_trigger_disable( "e1_cleanup_volume" );
	cleanup_trigger_disable( "e2_cleanup_volume" );
	cleanup_trigger_disable( "e3_right_cleanup_volume" );
	cleanup_trigger_disable( "e3_left_cleanup_volume" );
	cleanup_trigger_disable( "e3_rear_cleanup_volume" );
	
	createThreatBiasGroup( "squad" );
	createThreatBiasGroup( "players" );
	
	level thread swap_in_flamethrower();

	if(NumRemoteClients())
	{
		if(NumRemoteClients()>1)	// 3 or 4 player coop
		{
			level.max_drones["allies"] = 5;
		}
		else	// 2 player coop
		{
			level.max_drones["allies"] = 10;
		}
	}

	level waittill("introscreen_complete");
	
	give_players_satchel_charge_and_threatbiasgroup();
	level thread oki2_objectives();
}

swap_in_flamethrower()
{
	wait_for_first_player();
	
	players = get_players();
	
	players[0] TakeWeapon("thompson_wet");
	players[0] GiveWeapon("m2_flamethrower_wet");
	players[0] SwitchToWeapon("m2_flamethrower_wet");
}

give_players_satchel_charge_and_threatbiasgroup()
{
	players = get_players();
	for( i=0; i<players.size; i++ )
	{
		players[i] GiveWeapon( "satchel_charge_new" );
		players[i] SetActionSlot( 3, "weapon", "satchel_charge_new" );
		//players[i] SwitchToWeapon( "satchel_charge_new" );
		players[i] setweaponammoclip("satchel_charge_new",3);
		
		players[i] thread e2_track_satchel_for_player();
		
		players[i] setThreatBiasGroup( "players" );
		
		//make sure all this stuff is turned on
		players[i] setclientDvar("miniscoreboardhide","0");
		players[i] setclientDvar("compass","1");
		players[i] SetClientDvar( "hud_showStance", "1" ); 
		players[i] SetClientDvar( "ammoCounterHide", "0" );
		
	}
}


////////////////////////////////////////////////////////////
////////////////////INITIALIZATION STUFFS///////////////////
////////////////////////////////////////////////////////////
oki2_init()
{

	//starts
	add_start("event3_bash",::e3_startpoint_bash, &"STARTS_OKI2_FINALBUNKER_BASH");
	add_start("event3",::e3_startpoint, &"STARTS_OKI2_FINALBUNKER");
	add_start("event2",::e2_startpoint, &"STARTS_OKI2_CANYON");
	add_start("outro",::outro_startpoint, &"STARTS_OKI2_OUTRO");
	default_start( ::e1_startpoint );

	//vehicle stuff
	level.tanks = 0;
	maps\_sherman::main( "vehicle_usa_tracked_shermanm4a3_green_w" );
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair" );
	maps\_model3::main( "artillery_jap_model3" );
//	maps\_artillery::main("artillery_jap_47mm", "at47"); // now a static model to save the two dudes who had to man it
	maps\_jeep::main( "vehicle_usa_wheeled_jeep", "jeep" );
	//maps\_jeep::main( "vehicle_usa_wheeled_gmc_truck","gmc" );

	// weapon swapping for the flame thrower
	maps\_coop_weaponswap::init();

	//callbacks
	level thread onFirstPlayerConnect();
	level thread onPlayerConnect();
	level thread onPlayerDisconnect();
	level thread onPlayerSpawned();
	level thread onPlayerKilled();

	//gun objectives stuff
	level.gun1 = getent("gun_1","targetname");
	level.gun2 = getent("gun_2","targetname");
	//level.gun3 = getent("gun3","targetname");
	level.gun4 = getent("gun_4","targetname");
	level.gun1_org = level.gun1.origin;
	level.gun2_org = level.gun2.origin;
	//level.gun3_org = level.gun3.origin;
	level.gun4_org = level.gun4.origin;
	level.gun1_destroyed = false;
	level.gun2_destroyed = false;
	//level.gun3_destroyed = false;
	level.gun4_destroyed = false;
	level.all_guns_destroyed = false;
	level.event_1_finished = false;

	level.e1_smokethrown = false;

	//for cliff gun
	level.cliff_intact = getent("cliff_intact","targetname");
	level.cliff_destroyed = getent("destroyed_cliff","targetname");
	level.cliff_rocks = getentarray("delete_these_rocks","targetname");

	//model used
	precachestring(&"OKI2_SATCHEL_HINT1");
	precachestring(&"OKI2_SATCHEL_HINT2");
	precachemodel("peleliu_aerial_rocket");
	precachemodel("radio_jap_bro");
	precacheitem("satchel_charge_new");
	//precachemodel("weapon_ger_panzershreck_rocket");

	level.drone_weaponlist_allies[0] = "m1garand_wet";
	level.drone_weaponlist_allies[1] = "thompson_wet";
	
	init_drones();

	level.earthquake["bunker"]["magnitude"] = 0.185;
	level.earthquake["bunker"]["duration"] = 3;
	level.earthquake["bunker"]["radius"]= 2048;

	setdvar ( "arcademode_score_oki2_bunker", 500 );
	setdvar ( "arcademode_score_oki2_radio", 150 );
}

// all the objective changing happens here
oki2_objectives()
{
	objective_add( 0, "current", &"OKI2_OBJ_1", (4612,3740,-256) ); // the elbow of the player's route
	objective_current(0); 

	level waittill( "OBJ_1_UPDATEPOS" );
	objective_position(0, (620, 700, -192) ); // the bunker itself

	level waittill( "OBJ_1_COMPLETE" );
	objective_state(0,"done");
	objective_add(1,"current",&"OKI2_OBJ_2_3",level.gun1_org); // these are maintained by update_gun_objectives()
	objective_additionalposition(1,1,level.gun2_org);
	objective_additionalposition(1,2,level.gun4_org);
	objective_current(1); 

	level waittill( "OBJ_2_COMPLETE" );
	objective_string_nomessage(1, &"OKI2_OBJ_2");
	objective_state(1,"done");
	objective_add(2,"current",&"OKI2_OBJ_3", getent("move_to_hill","targetname").origin );
	objective_current(2);

	level waittill( "OBJ_3_COMPLETE" );
	objective_state(2,"done");
	objective_add(3,"current",&"OKI2_OBJ_4", (-4866, -4595, 393) ); // bunker location, we'll update that in a sec
	objective_current(3); 

	level waittill( "OBJ_4_UPDATEPOS" ); // means polonsky said to go around and find an entrance, after tank blows
	objective_position(3, (-6170, -6168, 332.1) ); // tunnel entrance

	level waittill( "OBJ_4_COMPLETE" );
	objective_state(3,"done");
	objective_add(4,"current",&"OKI2_OBJ_5", (-4866, -4595, 393) ); // last bunker centerpoint
	objective_current(4); 

	level waittill( "OBJ_5_COMPLETE" );
	objective_state(4,"done");
}


//setup the friendlies for the first time..
setup_friends()
{
	// facial animation
	animscripts\face::initLevelFace();
	
	spwns = getentarray("friends","targetname");
	for(i=0;i<spwns.size;i++)
	{
		spwns[i] stalingradspawn();
		wait_network_frame();
	}

	////okiPrint( "Setting friends!" );

	friends = get_ai_group_ai("dasquad");//getentarray("friends","targetname");
	for(i=0;i<friends.size;i++)
	{
		if(isDefined(friends[i].script_noteworthy) && friends[i].script_noteworthy == "sarge")
		{
			level.sarge = friends[i];
			level.sarge.animname = "sarge";
			//friends[i].name = "Sarge";
			friends[i] thread magic_bullet_Shield();
			level.sarge animscripts\face::initCharacterFace();
			////okiPrint( "Setting level.sarge!" );
		}
		if(isDefined(friends[i].script_noteworthy) && friends[i].script_noteworthy == "hero1")
		{
			level.polonsky = friends[i];
			level.polonsky.animname = "polonsky";
			//level.polonsky.name = "polonsky";
			friends[i] thread magic_bullet_Shield();
			level.polonsky animscripts\face::initCharacterFace();
			////okiPrint( "Setting level.polonsky!" );
		}
		
		friends[i] setwetness( 1.0, true );
		friends[i].pacifist = false;
		friends[i].maxSightDistSqrd = (1800 * 1800 );
		friends[i] setThreatBiasGroup( "squad" );
	}

	battlechatter_on("allies");
}

init_friendly_reinforcements()
{
	triggers = getentarray( "friendly_respawn_trigger", "targetname" );
	if( !isDefined(triggers) )
	{
		////okiPrint( "Couldn't find friendly respawn triggers!" );
		return; 
	}
	
	for( i=0; i<triggers.size; i++ )
	{
		
		if( isDefined(triggers[i].target) )
		{
			spawner = getent( triggers[i].target, "targetname" );
			if( isDefined(spawner) )
			{
				////okiPrint( "init_friendly_reinforcements: Adding wet_spawnfunc to spawner " + spawner.targetname );
				spawner add_spawn_function( ::wet_spawnfunc );
			}
		}
	}
}

wet_spawnfunc()
{
	self setwetness( 1.0, true );
	self setThreatBiasGroup( "squad" );
}


init_drones()
{
	character\char_usa_marinewet_r_rifle::precache();
	level.drone_spawnFunction["allies"] = character\char_usa_marinewet_r_rifle::main;
	maps\_drones::init();
}


//temp until new spiderhole stuff comes in
init_spiderholes()
{
	ents = getentarray("spiderhole_lid","script_noteworthy");
	array_thread(ents,::monitor_spiderhole_lid);
}

monitor_spiderhole_lid()
{
	self waittill("emerge");
	self playsound("spider_hole_open");
	//self moveto( self.origin + (0,randomintrange(68,80),0), .4,.1,.2);
	//self rotateto( self.angles + (0,randomintrange(-15,15),0), .2);
}

//make the model3 on the cliff fire it's weapon
//temp until all the anims come online
e1_fake_gun_fire()
{
	level endon("stop_cliffgun");
	trig = getent("spawn_model3","targetname");
	trig waittill("trigger");

	level notify("e1_approaching_first_rocks");

	gun = getent("falling_gun_hideme","targetname");
	while(!isDefined(gun))
	{
		wait(1);
	}
	while(!isDefined(gun.nofire))
	{
		{
			playfxontag(level._effect["gunflash"],gun,"tag_flash");
			//maps\_model3::arty_fire(gun);
			gun playsound("model3_fire");
			wait(randomintrange(4,7));
		}
	}

}

///////////////////////////////////////////////////////////
////////////////////GAMEPLAY///////////////////////////////
///////////////////////////////////////////////////////////


//begin the assault on Wana Ridge
e1_startpoint()
{
	//TEMP HAX UNTIL SPIDERHOLES ARE FINISHED
	level thread init_spiderholes();

	//fog settings
	//maps\oki2_amb::set_opening_fog();

	//gotta wait
	wait_for_first_player();

	//setsaveddvar("r_showmissinglightgrid","0");
	if(getdvar("extra_guys") == "0")
	{
		atrig = getent("auto2807","target");
		atrig trigger_off();
	}

	//turn off ai colors
	disable_friendly_color();

	//vision file for opening area
	VisionSetNaked("Okinawa2",1);

	setup_friends(); //initialize the friendlies
	set_friendly_stances( "crouch", undefined, undefined );
	move_players("player_start");

	// play the level start dialogue
	level thread e1_opening_screen_dialogue();

	level waittill("introscreen_complete");

	//set up the defenders by the cave opening
	level thread e1_cave_defenders();

	//guys get surprised by the spiderholes
	level thread e1_spider_redshirt();
	level thread e1_spider_surprise();
	level thread e1_spider_reinforcements();

	//falling gun
	level thread e1_gun_fall();

	// bunch of rockets that streak overhead and hit the cliff in front of you
	level thread fire_rocket_series( "rocketbarrage_points", (1400,2562,-569), 30, false );
	level thread e1_second_rocket_barrage(); // waits for a trigger to hit it

	// now we wait for e1_opening_screen_dialogue to finish, then our boys can get moving
	//level waittill( "opening_screen_dialogue_complete" );
	flag_wait("opening_screen_dialogue_complete");
	set_friendly_stances("crouch","prone","stand");

	trig = getent("init_ai","targetname");
	trig notify("trigger");

	trigs = getentarray("done_allies","targetname");
	for(i=0;i<trigs.size;i++)
	{
			trigs[i] notify("stop_drone_loop");
			trigs[i] trigger_off();
	}

	battlechatter_off("allies");
	level thread enable_friendly_color_gradual( 1.1 );

	//fake gun fire until the _model3 script gets updated
	level thread e1_fake_gun_fire();
	
	level thread watersheet_on_trigger( "e1_cave_waterfall" ); // waterall inside the cave
	
	wait(2);
	players_satchel_hint();

	//wait for event 1 end
	event1_end = getent("end_event_1","script_noteworthy");
	event1_end waittill("trigger");

	e2_start();
}

e1_opening_screen_dialogue()
{
	//TUEY Set Music State to INTRO
	setmusicstate("INTRO");
	
	battlechatter_off("allies");

	level.sarge dialogue( "moveout", level.polonsky );
	level.polonsky dialogue( "skinny", level.sarge );
	level.sarge dialogue( "gordon", level.polonsky );
	wait(0.5);
	level.polonsky dialogue( "supplies", level.sarge );
	level.sarge dialogue( "coming", level.polonsky );
	level.polonsky dialogue( "when", level.sarge );
	wait(0.5);
	level.sarge dialogue( "uphill", level.polonsky );
	
	flag_set("opening_screen_dialogue_complete");
	//level notify( "opening_screen_dialogue_complete" );

	level waittill("e1_approaching_first_rocks");
	level.sarge dialogue("fortifiedmg");
	level.sarge dialogue("spreadout");
}

e1_spider_redshirt()
{
	level endon( "e1_spiderholes_triggered" );
	
	trig = getent( "e1_spider_redshirt", "targetname" );
	trig waittill( "trigger" );
	
	wait(3);
	
	// first, we need to get a random redshirt
	friends = get_ai_group_ai("dasquad");
	redshirt = undefined;
	
	for( i=0; i<friends.size; i++ )
	{
		if( isDefined(friends[i].script_noteworthy) && friends[i].script_noteworthy == "designated_redshirt" )
		{
			redshirt = friends[i];
			break;
		}
	}
	
	// then, we tell him to stupidly oke his face out into the grass
	redshirt setGoalNode( getNode("e1_spider_redshirt_destination","targetname") );
	
	// then he hits a trigger...
	trig2 = getent( "e1_spider_redshirt_inposition", "targetname" );
	while( true )
	{
		trig2 waittill( "trigger", who );
		if( who == redshirt )
		{
				break;
		}
	}
	
	// that tells the spiderholes to go off
	spiderholetrig = getent( "spider_surprise", "script_noteworthy" );
	spiderholetrig notify( "trigger" );
	redshirt.health = 5;
	
	wait(2);
	redshirt setGoalNode( getNode("e1_spider_redshirt_retreat","targetname") );
	redshirt thread random_death();
}

/*------------------------------------
surprise the guys
------------------------------------*/
e1_spider_surprise()
{

	trigs = getentarray("spider_surprise","script_noteworthy");
	array_thread(trigs,::e1_spiderholes_triggered);
	level waittill("e1_spiderholes_triggered");
	battlechatter_on("axis");

	//TUEY Set Music State to OH_SHIT
	setmusicstate("OH_SHIT");

	level.sarge dialogue("spiderholes");
	level.sarge dialogue("returnfire");
	level.sarge dialogue("burngrass");

	level notify( "OBJ_1_UPDATEPOS" );
	
	battlechatter_on("allies");
}

/*------------------------------------
guys act surprised when the spiderholes first pop
------------------------------------*/
e1_spiderholes_triggered()
{
	self waittill("trigger");
	wait(0.75);
	level notify("e1_spiderholes_triggered");

	//wait 15 seconds after the spiderholes pop and send in a few extra guys down from the caves
	wait(15);
	trig = getent("spiderhole_support","script_noteworthy");
	trig notify("trigger");

	//new fog settings
	//maps\oki2_amb::set_assault_fog();
}

e1_spiderhole_guys_assign_color()
{
	guys = getEntArray( "e1_spiderhole_guys", "script_noteworthy" );
	okiPrint( "e1_spiderhole_guys_assign_color: Found " + guys.size );
	
	for( i=0; i<guys.size; i++ )
	{
		if( isAlive(guys[i]) )  // some of these are spawners
		{
			guys[i] set_force_color( "o" );
			okiPrint( "e1_spiderhole_guys_assign_color:  Setting color!" );
		}
	}
}

e1_spider_reinforcements()
{
	trig = getent( "e1_spider_reinforcements_trigger", "targetname" );
	trig waittill( "trigger" );
	
	level thread manage_spawners_nogoal("e1_spider_reinforcements",3,5,"e1_spider_reinforcements_stop",0.25,undefined); 
}

// happens as the player's turning the corner up towards the bunker
// look for the trigger!
e1_second_rocket_barrage()
{
	trig = getent( "e1_second_rocket_barrage", "targetname" );
	trig waittill( "trigger" );
	fire_rocket_series( "rocketbarrage_points", (3729, 2, -561), 24, false );
}

e1_mg_start()
{
	trig = getent("e1_mg_start","targetname");
	trig waittill( "trigger" );

	mg = getent("e1_bunker_mg","targetname");
	mg setturretignoregoals( true );

	level thread maintain_mg_guy( "stop_cave_defenders2", "e1_mg_gunner_spawn", "e1_mg_gunner" );
	level thread e1_mg_guy_banzai();
	level thread e1_sarge_mg_dialogue();
}

e1_mg_guy_banzai()
{
	trig = getent( "e1_mg_gunner_banzai", "targetname" );
	trig waittill( "trigger" );

	guy = getent( "e1_mg_gunner", "targetname" );
	mg = getent("e1_bunker_mg","targetname");
	
	////okiPrint( "e1_mg_guy_banzai triggered!" ); 
	
	if( isdefined(guy) && isdefined(mg) )
	{
		mg setturretignoregoals( false );
		guy.script_mg42 = undefined;
		guy.ready_to_charge = true;
		wait(0.2);
		guy maps\_banzai::banzai_force();
	}
}

// triggers a bit before E1 so the smoke grenade nagging isn't so protracted
e1_smokegrenade_stopthread()
{
	trig = getent( "e1_smokegrenade_stop", "targetname" );
	trig waittill( "trigger" );
	
	level notify( "e1_smokegrenade_stop" );
}

// dialogue about the MG and watches for the player to throw a smoke grenade
e1_sarge_mg_dialogue()
{
	level endon("OBJ_1_COMPLETE");
	level endon("e1_smokegrenade_stop");
	
	level thread e1_smokegrenade_stopthread();

	players = get_players();
	for( i=0; i<players.size; i++ )
	{
		players[i] thread e1_track_smokegrenade_for_player();
	}
	
	wait(1);

	level.polonsky dialogue("mgcovered");
	wait(0.5);
	level.sarge dialogue("popsmoke");

	for( i=0; level.e1_smokethrown == false; i++  )
	{
		if( i > 10 )
		{
			i = 0;
		}

		if( i == 5)
		{
			level.sarge dialogue("smokereminder");
		}

		if( i == 10)
		{
			level.polonsky dialogue("smokereminder");
		}
		wait( 2 );
	}
	
	wait(3);

	level.sarge dialogue("cantseeus");
	level.sarge dialogue("clearbunker");
}

// all this does is sit on a player and run the tracking thread when the player tosses a smoke grenade
e1_track_smokegrenade_for_player()
{
	level endon("OBJ_1_COMPLETE");

	while( true )
	{
		self waittill( "grenade_fire", grenade, weapname );
		if ( weapname == "m8_white_smoke" )
		{
			self thread e1_watch_for_smoke_intersection( grenade );
		}
	}
}

// watch for a player-thrown smoke grenade intersecting the trigger before the E1 MG bunker
e1_watch_for_smoke_intersection( grenade )
{
	trigger = getent("stop_cave_defenders","targetname");

	touched_trig = false;

	while( isdefined(grenade) )
	{
		if( grenade istouching(trigger) )
		{
			touched_trig = true;
		}
		wait( 0.25 );
	}

	if( touched_trig == true )
	{
		level.e1_smokethrown = true;
		level thread random_banzai( trigger, 3 );
	}
}

// grab a handful of guys who're within this trigger, and force them to banzai
random_banzai( volume, num )
{
	wait(5);
	
	guys = getaiarray("axis");
	
	banzai_guys = [];
	num_banzai_guys = 0;
	
	if( isDefined(guys) && guys.size && num > 0 )
	{
		for(i=0;i<guys.size;i++)
		{
			if( guys[i] istouching(volume) )
			{
				banzai_guys[num_banzai_guys] = guys[i];
				num_banzai_guys++;
				
				if( num_banzai_guys >= num )
				{
					break;
				}
			}
		}
		
		////okiPrint( "random_banzai: found " + num_banzai_guys + " guys" );
		
		for(i=0;i<banzai_guys.size;i++)
		{
			wait(0.5);
			////okiPrint( "random_banzai: Setting banzai!" );
			if( isdefined(banzai_guys[i]) && isalive(banzai_guys[i]) )
			{
				banzai_guys[i] maps\_banzai::banzai_force();
			}
		}
		
	}

}

/*------------------------------------
japanese ouside of the main cave entrance
------------------------------------*/
e1_cave_defenders()
{
	//wait until the trigger's hit
	trig = getent("cave_defenders","script_noteworthy");
	trig waittill("trigger");
	
	level notify( "e1_spider_reinforcements_stop" );
	e1_spiderhole_guys_assign_color(); // some of them might be alive still, get them fighting with their friends

	level thread manage_spawners_nogoal("cave_defenders",4,8,"stop_cave_defenders",0.25,undefined);
	level thread manage_spawners_nogoal("e1_flank_defenders",2,3,"stop_e1_flank_defenders",1,undefined);

	//monitor the cave defenders
	level thread e1_monitor_cave_defenders();
	level thread e1_stop_cave_defenders();

	//add some more defenders once the players get close
	level thread e1_more_cave_defenders();

	// start the MG once the players reach the plinth
	level thread e1_mg_start();
}

e1_more_cave_defenders()
{
	trig = getent("more_cave_defenders","script_noteworthy");
	trig waittill("trigger");

	level thread manage_spawners_nogoal("cave_defenders2",3,5,"stop_cave_defenders2",4,undefined);
	level thread e1_monitor_cave_defenders2();
	level thread e1_stop_cave_defenders2();
}

e1_monitor_cave_defenders()
{
	level endon("stop_monitoring");
	wave = 0;
	while(wave < 4)
	{
		level waittill("cave_defenders min threshold reached");
		wave++;
	}

	level notify("stop_cave_defenders");
}

e1_monitor_cave_defenders2()
{
	level endon("stop_monitoring");
	wave = 0;
	while(wave < 4)
	{
		level waittill("cave_defenders2 min threshold reached");
		wave++;
	}

	level notify("stop_cave_defenders2");
}

e1_stop_cave_defenders()
{
	trig = getent("stop_cave_defenders","targetname");
	trig waittill("trigger");
	level notify("stop_cave_defenders");
	level notify("stop_e1_flank_defenders");
}

e1_stop_cave_defenders2()
{
	trig = getent("stop_cave_defenders2","targetname");
	trig waittill("trigger");

	//TUEY Set music state to UNDERSCORE
	setmusicstate("UNDERSCORE");

	level notify("stop_cave_defenders2");
	level notify("stop_cave_mg");


	level.sarge dialogue("throughcaves");
}


/*------------------------------------
for starts
------------------------------------*/
e2_startpoint()
{

	wait_for_first_player();
	setup_friends();
	disable_friendly_color();

	move_players("skipto_e2_players");
	move_ai("skipto_e2_friendlies");

	enable_friendly_color();

	triga = getent("start_e2","script_noteworthy");
	triga notify("trigger");

	battlechatter_on("axis");
	level notify( "OBJ_1_UPDATEPOS" );
	wait_network_frame();
	level notify( "OBJ_1_COMPLETE" );

	e2_start();
}

/*------------------------------------
take out the guns
------------------------------------*/
e2_start()
{
	//tell the level that the first event is finished
	level.event_1_finished = true;
	e2_hidesatchels();

	//stop the firing FX playing from the broken upper grotto gun
	level notify("stop_upper");

	//give player grenades if he runs out ( temp hax for now until I hook it up so sarge does it for ya )
	//level thread temp_player_grenade_hack();

	friends = get_ai_group_ai("dasquad");//getentarray("friends","targetname");
	for(i=0;i<friends.size;i++)
	{
		friends[i].maxSightDistSqrd = (1100 * 1100 );
	}

	getent("move_to_hill","targetname") trigger_off();
	
	level thread e2_grotto_fight();

	//wait for the guns to be destroyed
	level thread maps\oki2_gunbunkers::monitor_gun(1);
	level thread maps\oki2_gunbunkers::monitor_gun(2);
	level thread maps\oki2_gunbunkers::monitor_gun(4);

	//set up the bunkers
	level thread maps\oki2_gunbunkers::bunker_wait_for_flame(1,"bunker_inner_fire","bunker1_flamers",maps\oki2_gunbunkers::cave_flamers,201);
	level thread maps\oki2_gunbunkers::bunker_wait_for_flame(2,"bunker_inner_fire","bunker2_flamers",maps\oki2_gunbunkers::cave_flamers,202);
	level thread maps\oki2_gunbunkers::bunker_wait_for_flame(4,"bunker_inner_fire","bunker4_flamers",maps\oki2_gunbunkers::cave_flamers,203);

	level thread maps\oki2_gunbunkers::bunker_dialogue();

	level thread e2_first_rocket_barrage();
	level thread e2_second_rocket_barrage();

	level thread e2_linefight_a_start();

	// delete any stray axis guys on the wana ridge approach
	level thread cleanup_trigger_enable( "e1_cleanup_volume" );

	level thread e2_refresh_satchel_ammo( "e2_satchelbox_a", "OBJ_5_COMPLETE" ); // let these go on forever
	level thread e2_refresh_satchel_ammo( "e2_satchelbox_b", "OBJ_5_COMPLETE" );
	level thread e2_refresh_satchel_ammo( "e2_satchelbox_c", "OBJ_5_COMPLETE" );
	
	level thread watersheet_on_trigger( "e2_grotto_waterfall" );
	
	level thread e2_collectible_corpse();
	
	e2_end_setdoorangle();

	//set up the grotto fog y'all
	//maps\oki2_amb::set_grotto_fog();

	//wait until all the guns have been destroyed
	while(!level.all_guns_destroyed)
	{
		wait(1);
	}

	//update the objectives once the guns are taken out
	level notify("OBJ_2_COMPLETE");

	//enable the tunnel entrance trigger
	thread e2_end_playergate();

	//TUEY Set the music state to UNDERSCORE
	setmusicstate("UNDERSCORE");
}

#using_animtree( "generic_human" );
e2_collectible_corpse()
{

	orig = getstruct( "orig_collectible_loop", "targetname" );

	corpse = spawn( "script_model", orig.origin );
	corpse.angles = orig.angles;
	corpse character\char_jap_makpelwet_rifle::main();
	corpse detach( corpse.gearModel );
	corpse UseAnimTree( #animtree );
	corpse.animname = "collectible";
	corpse.targetname = "collectible_corpse";

	level thread anim_loop_solo( corpse, "collectible_loop", undefined, "stop_collectible_loop", orig );
}

e2_grotto_fight()
{
	trig = getent( "e2_grottofight_start", "targetname" );
	trig waittill( "trigger" );
	
	spawns = getentarray( "e2_grotto_spawns", "targetname" );
	guys = [];
	numguys = 0;
	
	for( i=0; i<spawns.size; i++ ) // spawn all the matching spawners
	{
		guys[numguys] = spawns[i] stalingradspawn();
		if( isDefined(guys[numguys]) ) // make a list of the resultant guys
		{
			numguys++;
		}
	}
	
	livingguys = guys.size;
	lastguy = undefined;
	
	while( livingguys > 1 ) // loop until only one guy's left alive
	{
		livingguys = 0;
		for( i=0; i<guys.size; i++ )
		{
			if( isDefined(guys[i]) && isAlive(guys[i]) )
			{
				livingguys++;	
				lastguy = guys[i];
			}
		}
		wait(0.2);
	}
	
	// now we know only one guy is still alive, and lastguy should equal him
	// let's make him run away
	lastguy setGoalNode( getNode("e2_grotto_runawaynode","targetname") );
	lastguy endon("death");
	lastguy.ignoreall = true;
	lastguy.goalradius = 64;
	
	lastguy waittill("goal");
	lastguy.ignoreall = false;
}

// hides the glowy satchels atop the duffels in E2
e2_hidesatchels()
{
	ents = getentarray( "e2_satchel_glow", "targetname" );
	for( i=0; i<ents.size; i++ )
	{
		ents[i] hide(); 
	}
}

// shows the glowy satchels atop the duffels in E2
e2_showsatchels()
{
	ents = getentarray( "e2_satchel_glow", "targetname" );
	for( i=0; i<ents.size; i++ )
	{
		ents[i] show(); 
	}	
}

e2_refresh_satchel_ammo( triggername, end )
{
	level endon( end );

	while( true )
	{
		trig = getent( triggername, "targetname" );
		trig waittill( "trigger", who );

		if( isDefined(who) && isPlayer(who) && who.active_satchels < 3 )
		{
			if( who GetWeaponAmmoStock( "satchel_charge_new" ) < 3 )
			{
				who givestartammo( "satchel_charge_new" );
				PlaySoundAtPosition( "ammo_pickup_plr", trig.origin );
			}
		}

		wait(2);
	}
}

// all this does is sit on a player and run the tracking thread when the player tosses a satchel
e2_track_satchel_for_player()
{
	//level endon("OBJ_2_COMPLETE");
	
	self.active_satchels = 0;

	while( true )
	{
		self waittill( "grenade_fire", satchel, weapname );
		if ( weapname == "satchel_charge_new" ) // "satchel_charge"
		{
			// only need to do this during e2
			if( level.all_guns_destroyed == false && level.event_1_finished == true )
			{
				self thread e2_watch_for_bunker_intersection( satchel, self );
			}
			else
			{
				self thread watch_satchel_simple( satchel, self);	
			}
			
			self.active_satchels++;
		}
	}
}

watch_satchel_simple( satchel, player )
{
	while( isdefined(satchel) )
	{
		wait(0.25);
	}
	
	player.active_satchels--;
}

// runs watches whether the satchel touches any of the bunker triggers
// it tracks which one it has touched, then sends a notify to the appropriate
// trigger if necessary.  This is pretty much required to make the bunker
// explosions foolproof.
e2_watch_for_bunker_intersection( satchel, player )
{
	triggers[0] = getent("bunker1_dmg_trig","targetname");
	triggers[1] = getent("bunker2_dmg_trig","targetname");
	triggers[2] = getent("bunker4_dmg_trig","targetname");

	touched_trig = -1;

	while( isdefined(satchel) )
	{
		for( i=0; i<triggers.size; i++ )
		{
			if( satchel istouching(triggers[i]) )
			{
				touched_trig = i;
			}
		}
		wait( 0.25 );
	}
	
	player.active_satchels--;

	if( touched_trig != -1 && isDefined(triggers[touched_trig]) )
	{
		
		////okiPrint( "e2_watch_for_bunker_intersection found intersection" );
		triggers[touched_trig] notify( "satchel_exploded" );
		
		// award points in arcade mode
		// no really, this is the only good way to do this
		if( touched_trig == 0 && !level.gun1_destroyed )
			arcademode_assignpoints( "arcademode_score_oki2_bunker" , player );
		
		if( touched_trig == 1 && !level.gun2_destroyed )
			arcademode_assignpoints( "arcademode_score_oki2_bunker" , player );
			
		if( touched_trig == 2 && !level.gun4_destroyed )
			arcademode_assignpoints( "arcademode_score_oki2_bunker" , player );
	}
}

// right as the player's passing through the grotto
e2_first_rocket_barrage()
{
	////okiPrint( "Beginning e2_first_rocket_barrage()" );
	trig = getent( "e2_first_rocket_barrage", "targetname" );
	trig waittill( "trigger" );
	fire_rocket_series( "canyon_rocketbarrage_points_a", (-860,-654,36.1), 12, true );
	////okiPrint( "Exiting e2_first_rocket_barrage()" );
}

// as the player's halfway down the valley, hits at the far end
e2_second_rocket_barrage()
{
	////okiPrint( "Beginning e2_second_rocket_barrage()" );
	trig = getent( "e2_second_rocket_barrage", "targetname" );
	trig waittill( "trigger" );
	fire_rocket_series( "canyon_rocketbarrage_points_b", (-5737,-313,8), 30, true );
	////okiPrint( "Exiting e2_second_rocket_barrage()" );
}

e2_linefight_a_start()
{
	trig = getent("e2_linefight_a_start","targetname");
	trig waittill("trigger");

	level thread maps\_squad_manager::manage_spawners("e2_linefight_a",2,4,"e2_linefight_a_stop",1,undefined);
	level thread e2_linefight_a_stop();
}

// stops respawning guys in linefight a, sets up bridge triggers
// bridge banzai doubles as a bridge-commentary disabler
e2_linefight_a_stop()
{
	trig = getent("e2_linefight_a_stop","targetname");
	trig waittill("trigger");

	level notify( "e2_linefight_a_stop" );

	level thread e2_bridge_banzai_setup();
	level thread e2_bridge_commentary_setup();
	level thread e2_check_for_bridge_skip();

}

e2_check_for_bridge_skip()
{
	trig = getent( "e2_player_skipping_bridge", "targetname" );
	trig waittill("trigger");
	
	trig = getent( "e2_bridge_banzai_trigger", "targetname" );
	trig trigger_off();
	
	trig = getent("e2_bridge_commentary", "targetname");
	trig trigger_off();
	
	// kill the threads that might be running
	level notify( "e2_player_skipped_bridge" );
}

// gets a banzai dude to rush you as you cross the little bridge in E2
e2_bridge_banzai_setup()
{
	////okiPrint( "e2_setup_bridge_banzai: starting" );
	level endon("e2_player_skipped_bridge");
	
	trig = getent("e2_bridge_banzai_trigger","targetname");
	trig waittill( "trigger" );

	spawner = getent("e2_bridge_banzai", "targetname" );
	spawner add_spawn_function( ::e2_bridge_banzai_spawnfunc );
	guy = spawner stalingradspawn();

	wait(0.1);

	guy allowedstances( "crouch", "prone", "stand" );
	////okiPrint( "e2_setup_bridge_banzai: triggered!" );
}

e2_bridge_banzai_spawnfunc()
{
	self allowedstances( "crouch" );
	self.a.pose = "crouch";
}

// Sarge dialogue about crossing the bridge
e2_bridge_commentary_setup()
{
	level endon( "e2_player_skipped_bridge" );
	
	trig = getent("e2_bridge_commentary", "targetname");
	trig waittill( "trigger" );

	level.sarge dialogue( "otherside" );
}

// Means the player's reached the pass-through tunnel at the end of the canyons
e2_end_playergate()
{
	level notify( "bunker_noneleft"); // turns off other acknowledgements if two bunkers are done at once
	level.sarge dialogue( "lastone" );
	
	checktrig = getEnt( "e2_bunker3_checkifclear", "targetname" );
	
	deathCountdown = 15;
	
	while( true )
	{
		numEnemies = 0;
		guys = getaiarray("axis");

		if( isDefined(guys) &&	guys.size )
		{

			for( i=0; i<guys.size; i++ )
			{
				if( isAlive(guys[i]) && guys[i] istouching(checktrig) )
				{
					numEnemies++;
					
					if( deathCountdown == 0 ) // kill of stragglers if too long has passed
					{
						guys[i] thread random_death();
					}
				}
			}
			////okiPrint( "Looking for axis touching e2_bunker3_checkifclear: " + numEnemies );
		}
		
		// countdown until we just kill them to avoid player confusion... sometimes one is
		// in a hard to find corner, or may have fallen through the ground or something
		if( numEnemies < 3 )
		{
			//okiPrint( "Death Countdown: " + deathCountdown );
			deathCountdown--;			
		}
		
		if( numEnemies == 0 )
		{
			break;	
		}
		
		wait(0.66);
	}
	
	level thread e2_end_sargedialogue();
	
	// do this twice because friendlycolor could mess this up
	level.sarge disable_ai_color();
	level.sarge setgoalnode( getnode("e2_finish_sargenode_wait","targetname") );
	
	trig = getent("move_to_hill","targetname");
	trig trigger_on();
	trig waittill("trigger");
	
	level.sarge setgoalnode( getnode("e2_finish_sargenode_kickready","targetname") );
	level.sarge waittill("goal");

	// grab the player blocker, knock the gate over, remove the clip brush
	thread e3_start_trigger();
	e2_end_sarge_bash_door();
	
	//enable_friendly_color();
	
	level notify("OBJ_3_COMPLETE");
}

e2_end_setdoorangle()
{
	gate = getent( "e2_finish_gate", "targetname" );
	gate.angles = (0,-24,0);
}

e2_end_sargedialogue()
{
	battlechatter_off("allies"); // turned back on in e2_end_bash_door_dialogue
	wait(2);
	level.sarge dialogue( "meetme" );
}

// sarge knocks down the big metal grating that's in the way
e2_end_sarge_bash_door()
{
	level.sarge.ignoreall = true;
	
	gate = getent( "e2_finish_gate", "targetname" );
	anim_node = getnode("e2_finish_kickspot","targetname");
	
	anim_node anim_reach_solo(level.sarge, "door_bash");
	level thread e2_end_bash_door_dialogue();
	anim_node anim_single_solo(level.sarge,"door_bash");

	level.sarge setgoalnode( getnode("e2_finish_sargepostbash","targetname") );
	level.sarge.ignoreall = false;
}

e2_end_bash_door_dialogue()
{
	level.polonsky dialogue("whatnow");
	level.sarge dialogue("keepmovingpolonsky");
	wait(0.5);
	level.sarge dialogue("keepmoving");
	
	battlechatter_on("allies");
}

#using_animtree("oki2_falling_gun");
e2_end_cachedooranim()
{
	level.scr_model["e2_door"] = "tag_origin_animate";
	level.scr_anim["e2_door"]["flyopen"] = %o_okinawa2_bunkerdoor_smash;
	level.scr_animtree["e2_door"] = #animtree;
}

move_e3_start_gate( GARBAGE )
{
	e2_end_cachedooranim();
	
	gate = getent( "e2_finish_gate", "targetname" );
	gateclip = getent( "e2_finish_gate_clip", "targetname" );
	scrorigin = getent( "e2_finish_animorigin", "targetname" );
	
	anim_model = spawn_anim_model( "e2_door" );
	anim_model.animname= "e2_door";
	anim_model.origin = scrorigin.origin;
	anim_model.angles = scrorigin.angles;
	
	//anim_model thread draw_tag_name( "origin_animate_jnt" );
	//anim_model thread draw_tag_name( "tag_origin" );
	
	scrorigin maps\_anim::anim_first_frame_solo( anim_model, "flyopen" );
	gate linkto( anim_model, "origin_animate_jnt", ( 0, 0, 0 ), ( 0, -24, 0 ) );
	
	scrorigin thread anim_single_solo( anim_model, "flyopen" );

	gateclip delete();
}

e3_start_trigger()
{
	trig = getEnt("e3_start_trigger","targetname");
	trig waittill("trigger");

	e3_start();
}

e3_startpoint()
{
	wait_for_first_player();

	level.event_1_finished = true;

	level notify("stop_upper");
	level notify("stop_1" );
	level notify("stop_2" );
	level notify("stop_4" );

	setup_friends();
	move_ai("e3_ai_start");
	move_players("e3_player_start");
	enable_friendly_color();

	level notify( "OBJ_1_UPDATEPOS" );
	wait_network_frame();
	level notify( "OBJ_1_COMPLETE" );
	wait_network_frame();
	level notify( "OBJ_2_COMPLETE" );
	wait_network_frame();
	level notify( "OBJ_3_COMPLETE" );

	level thread e3_start_trigger();

	level thread move_e3_start_gate( undefined );

	startcovertrig = getent("e3_start_coverpoints","targetname"); // move guys to nearby cover spots, otherwise they act stupid
	startcovertrig notify("trigger");
	
	players = get_players();
	
//	wait(10); // uncomment these to test doorbash easily
	
//	level thread sarge_bash_door();
}

e3_startpoint_bash()
{
	wait_for_first_player();

	level.event_1_finished = true;

	level notify("stop_upper");
	level notify("stop_1" );
	level notify("stop_2" );
	level notify("stop_4" );

	setup_friends();
	move_ai("e3_ai_start");
	move_players("e3_player_start");
	enable_friendly_color();

	level notify( "OBJ_1_UPDATEPOS" );
	wait_network_frame();
	level notify( "OBJ_1_COMPLETE" );
	wait_network_frame();
	level notify( "OBJ_2_COMPLETE" );

	startcovertrig = getent("e3_start_coverpoints","targetname"); // move guys to nearby cover spots, otherwise they act stupid
	startcovertrig notify("trigger");
	
	e2_end_setdoorangle();
	
	level thread e2_end_playergate();
}


/*------------------------------------
start the assault on the bunker
------------------------------------*/
e3_start()
{
	//maps\oki2_amb::set_final_fog();
	
	//level.drone_think_func = ::e3_drone_slowspeed; // guys following the tank are drones // not anymore

	thread e3_tankstart(); // does some setup then waits for 'tank_move'
	thread e3_playerneartank(); // waits on a trigger, which notifies level 'tank_move'

	level thread e3_bunker_defenders();
	level thread e3_player_enters_tunnel();

	level thread e3_rightrear_linefight_start();
	level thread e3_leftrear_linefight_start();

	startup_e3_freeflow_triggers();
}

e3_turrets_ignoregoals_true()
{
	t1 = getent("auto448","targetname");
	t2 = getent("auto709","targetname");
	t1 setturretignoregoals( true );
	t2 setturretignoregoals( true );
}

e3_turrets_ignoregoals_false()
{
	t1 = getent("auto448","targetname");
	t2 = getent("auto709","targetname");
	t1 setturretignoregoals( false );
	t2 setturretignoregoals( false );
}

e3_playerneartank()
{
	trig_playerneartank = getent("trigger_playerneartank", "targetname");
	////okiPrint( "Found trigger_playerneartank" );
	enable_friendly_color();

	trig_playerneartank waittill("trigger");
	level notify("tank_move");

	spawn_array_once( "e3_hill_friendlies", "targetname" );

	// delete any stray axis guys in the canyon
	level thread cleanup_trigger_enable( "e2_cleanup_volume" );

	//thread e3_approachfight(); // waits for the drones to hit a trigger indicating they're in front of the spiderholes
}

/*------------------------------------
tank spawns, moves forward, and eventually gets blown up
------------------------------------*/
e3_tankstart()
{	
	//wait for tank to be destroyed
	trig_spawn = getent("tank_spawn","targetname");
	trig_spawn notify("trigger");

	// starts the tank moving once we're ready
	level waittill("tank_move");

	trig_move = getent("tank_move", "targetname");
	trig_move notify("trigger");
	
	tank1 = getent("e3_tank1","targetname");
	tank2 = getent("e3_tank2","targetname");
	
	level thread e3_tankfollowers( tank1 );
	
	wait(1);

	tank1 thread e3_tank_explode();
	tank2 thread e3_tank_explode();
	level thread e3_tank_dialogue();
	level thread e3_extra_mortar();
}

// dudes who follow along behind the first tank in E3
e3_tankfollowers( tank )
{
	spawns = getentarray( "e3_tankfollower_spawn", "targetname" );
	guys = [];
	
	dest_node = getNode("e3_tankfollower_goal","targetname");
	
	for( i=0; i<spawns.size; i++ )
	{
		guys[i] = spawns[i] StalingradSpawn();
		wait_network_frame();
		guys[i].ignoreall = true;
		guys[i].health = 1;
		
		guys[i] thread maps\_utility::set_generic_run_anim( "combat_jog", true );
		guys[i] setGoalPos( dest_node.origin );
		guys[i].goalradius = 128;
		
		wait( 0.35 );
	}
	
	tank waittill("reached_end_node");
	
	for( i=0; i<guys.size; i++ )
	{
		if( isAlive(guys[i]) )
		{
			guys[i] doDamage( 100, tank.origin );
		}
	}
}

e3_tank_explode()
{
	self waittill("reached_end_node");

	playfx( level.mortar, self.origin );
	radiusdamage( self.origin, 512, 60, 15 );

	level notify( "e3_tank_destroyed" );	
	
	self notify( "death" );
}

//#using_animtree( "generic_human" );
e3_drone_slowspeed()
{
	//self.drone_run_cycle = %combat_jog;
	self.droneRunRate = 125;	
}

e3_extra_mortar()
{
	level waittill( "e3_tank_destroyed" );
	
	locs = getStructArray( "e3_extra_mortar", "targetname" );
	for( i=0; i<locs.size; i++ )
	{
		wait( RandomIntRange(1,4) );
		playfx( level.mortar, locs[i].origin );
		radiusdamage( locs[i].origin, 512, 40, 10 );
	}
	
	wait( RandomIntRange(1,4) );
	
	jeepmortar = getstruct( "e3_jeep_mortar", "targetname" );
	jeep1 = getent( "e3_parked_jeep1", "targetname" );
	jeep2 = getent( "e3_parked_jeep2", "targetname" );
	
	playfx( level.mortar, jeepmortar.origin );
	radiusdamage( jeepmortar.origin, 512, 40, 10 );
	
	wait(0.1);
	jeep1 notify( "death" );
	
	wait(0.4);
	jeep2 notify( "death" );
	
	
}

e3_tank_dialogue()
{
	level.sarge dialogue("tanksmoving");

	// BOOM!  Need to attach more chaos to this in general
	// BANG!  Actually happened!
	level waittill( "e3_tank_destroyed" );

	//TUEY Set music state to MORTARS
	setmusicstate("MORTARS");

	level.polonsky dialogue("mortarfire");
	level.sarge dialogue("takecover");

	wait(6);

	level.polonsky dialogue("fortress");
	level.polonsky dialogue("seepaths");

	level notify( "OBJ_4_UPDATEPOS" );
}

// turns on appropriate triggers to keep the squad following the player
startup_e3_freeflow_triggers()
{
	thread trigger_noteworthy_if_player0( "e3_righthand_trigger_a", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_righthand_trigger_b", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_righthand_trigger_c", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_righthand_trigger_d", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_righthand_trigger_e", "player_entered_tunnel" );

	thread trigger_noteworthy_if_player0( "e3_lefthand_trigger_a", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_lefthand_trigger_b", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_lefthand_trigger_c", "player_entered_tunnel" );
	thread trigger_noteworthy_if_player0( "e3_lefthand_trigger_d", "player_entered_tunnel" );
}

/*------------------------------------
Japanese defending the bunker
------------------------------------*/
e3_bunker_defenders()
{

	trig = getent("start_bunker_defenders","script_noteworthy");
	trig waittill("trigger");
	
	level thread e3_righthand_defenders();
	level thread e3_lefthand_defenders();
	
	createThreatBiasGroup( "e3_gunners" );
	
	level thread maintain_mg_guy( "player_entered_tunnel", "e3_bunker_gunner_spawn1", "e3_bunker_gunner1", "e3_gunners" );
	level thread maintain_mg_guy( "player_entered_tunnel", "e3_bunker_gunner_spawn2", "e3_bunker_gunner2", "e3_gunners" );
	level thread maintain_mg_guy( "player_entered_tunnel", "e3_bunker_gunner_spawn3", "e3_bunker_gunner3", "e3_gunners" );
	
	setThreatBias( "e3_gunners", "players", 25 );
}

// start righthand guys right away
e3_righthand_defenders()
{
	thread manage_spawners_nogoal("bunker_right_defenders",3,5,"stop_right_defenders",1, ::guy_to_goal_blind);
	thread e3_monitor_defenders("bunker_right_defenders",6,"stop_right_defenders");
	thread e3_stop_lower_defenders("stop_lower_defenders_right");
}

// this fight feels better if the dudes spawn as you get down into the valley
e3_lefthand_defenders()
{
	trig = getent( "e3_start_lefthand_defenders", "targetname" );
	trig waittill( "trigger" );
	
	thread manage_spawners_nogoal( "bunker_left_defenders", 3, 7, "stop_left_defenders", 1, undefined );
	thread e3_monitor_defenders("bunker_left_defenders",6,"stop_left_defenders");
	thread e3_stop_lower_defenders("stop_lower_defenders_left");
	thread e3_left_treesnipers();
}

e3_monitor_defenders(guys,maxWaves,strEndon)
{
	level endon(strEndon);

	waves = 0;
	while(waves < maxWaves)
	{
		level waittill(guys + " min threshold reached");
		waves++;
	}
	level notify(strEndon);
}

e3_stop_lower_defenders( triggername )
{
	trig = getent(triggername,"targetname");
	trig waittill("trigger");

	level notify("stop_left_defenders");
	level notify("stop_right_defenders");
}

e3_init_defenders()
{
	self.goalradius = 64;
	self.maxsightdistsqrd = ( 2048 * 2048 );
}

// prepare for spawning guys in the tunnel
e3_player_enters_tunnel()
{
	////okiPrint( "starting player_enters_tunnel!" );
	//wait until players enter tunnels
	trig = getent("e3_player_enters_tunnel","targetname");
	trig waittill("trigger");

	////okiPrint( "triggered player_enters_tunnel!" );

	level notify( "player_entered_tunnel" );
	level notify( "OBJ_4_COMPLETE" );

	//TUEY Sets music state to INTO BUNKERS
	setmusicstate("INTO_BUNKERS");

	// waits for player to get to the end of the tunnels
	level thread e3_player_reaches_bunker();
	level thread e3_tunnels_spawn();
	level thread e3_tunnels_radio();

	battlechatter_off( "allies" );
	level.polonsky dialogue( "tunnelahead" );
	level.sarge dialogue( "goodworkpeople" );
	level.sarge dialogue( "convoyenroute" );
	battlechatter_on( "allies" );
}

e3_tunnels_radio()
{
	// oki2_radio_transmission
	// oki2_radio_deadair_loop
	// radio_destroyed
	
	trig = getent( "e3_tunnels_radio_trigger", "targetname" );
	trig waittill( "trigger" );
	
	level endon("player_reaches_bunker");
	radio = getent("e3_tunnel_radio","targetname");
	radio endon("radio_damaged");
	
	radio setcandamage(true);
	radio thread e3_tunnels_radio_takedamage();
	
	radio playsound("oki2_radio_transmission", "sound_finished");
	radio waittill( "sound_finished" );
	radio playloopsound("oki2_radio_deadair_loop");
}

// self is the radio
e3_tunnels_radio_takedamage()
{
	self waittill( "damage", who );
	self notify( "radio_damaged" );
	self stopsounds();
	
	wait_network_frame();
	
	self playsound("radio_destroyed");
	self setmodel("radio_jap_bro");

	if( isPlayer(who) )
	{
		arcademode_assignpoints( "arcademode_score_oki2_radio" , who );	
	}
}

// walk through the spawn sets in the tunnels one by one
e3_tunnels_spawn()
{
	// outro_kill_treesniper();
	
	thread notify_when_trigger_hit( "e3_tunnel_firstwave", "start_tunnels_axis_a" );
	level waittill( "start_tunnels_axis_a" );
	guys = spawn_array_once( "e3_tunnels_axis_a", "targetname" );
	thread e3_trigger_when_guys_dead( guys, "e3_tunnels_allies_a", "player_reaches_bunker", "e3_tunnels_allies_a_disable" );

	thread notify_when_trigger_hit( "e3_trigger_tunnels_secondroom", "player_in_secondroom" );
	level waittill( "player_in_secondroom" );
	level thread cleanup_trigger_enable( "e3_right_cleanup_volume" );
	level thread cleanup_trigger_enable( "e3_left_cleanup_volume" );
	guys = spawn_array_once( "e3_tunnels_axis_b", "targetname" );
	thread e3_trigger_when_guys_dead( guys, "e3_tunnels_allies_b", "player_reaches_bunker", "e3_tunnels_allies_b_disable" );

	thread notify_when_trigger_hit( "e3_trigger_tunnels_firstladder", "player_climbs_first_ladder" );
	level waittill( "player_climbs_first_ladder" );
	level thread cleanup_trigger_enable( "e3_rear_cleanup_volume" );
	thread manage_spawners_nogoal("e3_tunnels_axis_c",2,4,"e3_tunnels_allies_c_stop",.1, undefined);
	thread notify_when_trigger_hit( "e3_tunnels_allies_c", "e3_tunnels_allies_c_stop" );
}

e3_trigger_when_guys_dead( guys, targetname, endmsg, disablename )
{
	if( isDefined(endmsg) )
	{
		level endon( endmsg );
	}
	
	guysalive = true;
	
	while( guysalive )
	{
		guysalive = false;
		for( i=0; i<guys.size; i++ )
		{
			if( isDefined(guys[i]) && isAlive(guys[i]) ) // check if anybody's still alive...
			{
				guysalive = true;
			}
		}
		wait(0.25);
	}
	
	trig = getent( targetname, "targetname" );
	if( isDefined(trig) )
	{
		////okiPrint( "e3_trigger_when_guys_dead triggering " + trig.targetname );
		trig notify( "trigger" );
	}
	
	if( isDefined(disablename) )
	{
		dtrig = getent( disablename, "targetname" );
		dtrig trigger_off();
	}
	
}

// sets up the guys in the bunker for iminent player arrival
e3_player_reaches_bunker()
{
	////okiPrint( "starting player_reaches_bunker!" );
	trig = getent("e3_player_reaches_bunker","targetname");
	trig waittill("trigger");

	////okiPrint( "triggered player_reaches_bunker!" );
	level notify( "player_reaches_bunker" );

	level thread e3_bunkertop_spawn();

	//TUEY Set Music State to UP_THE_LADDER
	setmusicstate("UP_THE_LADDER");

	level.sarge dialogue( "upladder" );
	level.sarge dialogue( "areasecured" );
}


// spawns the two sets of guys in the top floor of the bunker
e3_bunkertop_spawn()
{
	trig = getent( "e3_start_bunkertop_axis_a", "targetname" );
	trig waittill( "trigger" );
	
	e3_bunkertop_relocategunners();
	
	thread manage_spawners_nogoal("e3_bunkertop_axis_a",4,7,"stop_bunkertop_axis_a",.1, undefined);
	thread notify_when_trigger_hit( "e3_stop_bunkertop_axis_a", "stop_bunkertop_axis_a" );
	e3_turrets_ignoregoals_false();
	
	trig = getent( "e3_start_bunkertop_axis_b", "targetname" );
	trig waittill( "trigger" );
	thread manage_spawners_nogoal("e3_bunkertop_axis_b",5,8,"stop_bunkertop_axis_b",.1, undefined);
	thread notify_when_trigger_hit( "e3_stop_bunkertop_axis_b", "stop_bunkertop_axis_b" );
	thread e3_sarge_mortar_reminder();
	
	wait(2);
	
	e3_monitor_bunker_status(); // end the mission when the bunker's empty
}

// grabs the dudes manning the MGs at the top of the E3 bunker and sends them to sensible nodes for the fight
e3_bunkertop_relocategunners()
{
	guy1 = getent( "e3_bunker_gunner1", "targetname" );
	if( isDefined(guy1) )
	{
		guy1 setGoalNode( getNode("e3_bunkertop_gunner1node","targetname") );	
	}
	
	guy2 = getent( "e3_bunker_gunner2", "targetname" );
	if( isDefined(guy2) )
	{
		guy2 setGoalNode( getNode("e3_bunkertop_gunner2node","targetname") );	
	}
	
	guy3 = getent( "e3_bunker_gunner3", "targetname" );
	if( isDefined(guy3) )
	{
		guy3 setGoalNode( getNode("e3_bunkertop_gunner3node","targetname") );	
	}
}

e3_sarge_mortar_reminder()
{
	level endon( "OBJ_5_COMPLETE" );

	wait(30);
	level.sarge dialogue( "mortarpositions" );
}

// checks who's touching the e3_bunker_interior trigger.  When all the Axis are dead, it's called secure
e3_monitor_bunker_status()
{
	vol = getent("e3_bunker_interior","targetname");
	guys_inside = 0;

	////okiPrint ("Monitoring guys in bunker!");

	while(1)
	{
		wait(1);
		guys_inside = 0;
		countdown_to_kill = 12;
		guys = getaiarray("axis");

		if( isDefined(guys) &&	guys.size )
		{

			for(i=0;i<guys.size;i++)
			{
				if( isAlive( guys[i]) && guys[i] istouching(vol) )
				{
					guys_inside++;
				}

				if( countdown_to_kill == 0 )
				{
					guys[i] thread random_death();
				}

			}
			////okiPrint( "MONITOR_GUYS_IN_BUNKER: found " + guys_inside );
		}

		if(guys_inside == 0)
		{
			break;
		}

		if( guys_inside < 3 )
		{
			//okiPrint( "Death Countdown: " + countdown_to_kill );
			countdown_to_kill--;
		}
	}

	// we had to have hit the break above to get here
	// this means everybody in the bunker is dead and we're good to finish the level
	e3_complete();
}

/*------------------------------------
player secures the bunker
------------------------------------*/
e3_complete()
{

	level notify( "OBJ_5_COMPLETE" );
	battlechatter_off("allies");
	
	wait(1);
	
	level.sarge AllowedStances ("stand");

	level.sarge dialogue( "outstandingmarines" );
	level.sarge dialogue( "outfuckingstanding" );
	level.sarge dialogue( "tendwounded" );

	// fade to black, then play closing IGC
	//thread fade_to_black(3);
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(3);
		players[i] thread magic_bullet_shield();
	}
		
	
	wait(3);
	outro_start(); // this'll finish in about 45 seconds

	nextmission();
}

e3_rightrear_linefight_start()
{
	level endon( "player_entered_tunnel" );

	trig = getent( "e3_rightrear_linefight_start", "targetname" );
	trig waittill( "trigger" );

	thread manage_spawners_nogoal("e3_rightrear_linefight",4,6,"player_entered_tunnel",.1, undefined);

	// want the timer to be right whichever one hits the trigger first.  These threads kill each other.
	thread e3_rightrear_spiderholes_start( "e3_rightrear_spiderholes_trigger_ai" );
	thread e3_rightrear_spiderholes_start( "e3_rightrear_spiderholes_trigger_player" );
}

e3_rightrear_spiderholes_start( triggername )
{
	level endon( "player_entered_tunnel" );
	level endon( "e3_rightrear_spiderholes_triggered" );

	////okiPrint( "e3_rightrear_spiderholes_start: Found spiderhole trigger " + triggername );

	trig = getent( triggername, "targetname" );
	trig waittill( "trigger" );

	////okiPrint( "e3_rightrear_spiderholes_start: Spawning!" );

	spawntrig = getent( "e3_rightrear_spiderholes_spawntrigger", "targetname" );
	spawntrig notify( "trigger" );
}

e3_leftrear_linefight_start()
{
	level endon( "player_entered_tunnel" );

	trig = getent( "e3_leftrear_linefight_start", "targetname"	);
	trig waittill( "trigger" );

	thread manage_spawners_nogoal("e3_leftrear_linefight",3,4,"player_entered_tunnel",.1, undefined);
}

// when the player hits the trigger, two tree snipers spawn just ahead
e3_left_treesnipers()
{
	level endon( "player_entered_tunnel" );
	
	tree = getent( "dunes_flame_tree", "script_noteworthy" );
	
	model_tag_origin = spawn( "script_model", tree.origin );
	model_tag_origin setmodel("tag_origin");
	model_tag_origin linkto( tree, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );

	trig = getent( "e3_left_treesnipers_trigger", "targetname" );
	trig waittill( "trigger" );
	
	// Tree snipers!
	////okiPrint( "Spawning left treesnipers!" );
	simple_spawn( "e3_left_treesnipers", ::e3_treesniper_spawn );
	
	model_tag_origin unlink();
	model_tag_origin delete();
	
	playfx( level._effect["sniper_leaf_canned"], tree.origin );

	// radius check to see if squad members are nearby, have them do dialogue if so
	pol_distance = distancesquared( level.polonsky.origin, trig.origin );
	sar_distance = distancesquared( level.sarge.origin, trig.origin );
	
	pass_distance = 750 * 750; // the radius I want to check, squared
	
	////okiPrint( "e3_left_treesnipers: Polonsky distance is " + pol_distance );
	////okiPrint( "e3_left_treesnipers: Sarge distance is " + sar_distance );
	
	// if both polonsky and roebuck are within distance of the sniper-activating trigger, they converse
	// if just one or the other is within distance, I play the lines that make best sense
	if( pol_distance < pass_distance )
	{
		level.polonsky dialogue("snipersintrees");
		if( sar_distance < pass_distance )
		{
			level.sarge dialogue("iseeem");
		}		
	}
	
	if( sar_distance < pass_distance )
	{
		level.sarge dialogue("bringemdown");		
	}
	
	tree waittill( "destroyed" ); // kill the sniper if the tree's destroyed
	sniper = getEnt( "e3_left_treesnipers_alive", "targetname" );
	if( isDefined(sniper) && isAlive(sniper) )
	{
		sniper thread random_death(1);
	}
}

// function that runs on the actual tree sniper individual
e3_treesniper_spawn()
{
	self endon("death");

	////okiPrint( "Doing e3_treesniper_spawn!" );

	anim_node = getnode(self.target, "targetname");
	anim_point = getent(anim_node.target,"targetname");
	self.ignoreme = true;
	self.animname = "tree_guy";

	if (self.script_noteworthy == "climb")
	{
		self maps\_tree_snipers::do_climb(anim_point);
	}

	self.ignoreme = false;

	if (isdefined(self))
	{
		self allowedstances ("crouch");
	}
	self.allowdeath = true;
	self thread maps\_tree_snipers::tree_death(self, anim_point);
	self.health = 1;
}

#using_animtree("player");
outro_cacheplayer()
{
	level.scr_model["player_hands"] = "viewmodel_usa_marinewet_rolledup_player";
	level.scr_animtree["player_hands"] = #animtree;
	level.scr_anim["player_hands"]["outro"] = %int_oki2_outro_player;
}

#using_animtree("generic_human");
outro_cachenpcs()
{
	level.scr_anim["sarge"]["outro"] = %ch_okinawa2_outro_roebuck;
	level.scr_anim["polonsky"]["outro"] = %ch_okinawa2_outro_polonski;
	level.scr_anim["guy1"]["outro"] = %ch_okinawa2_outro_guy1;
	level.scr_anim["guy2"]["outro"] = %ch_okinawa2_outro_guy2;
	level.scr_anim["co"]["outro"] = %ch_okinawa2_outro_co;
}

#using_animtree("vehicles");
outro_cachevehicles()
{
	level.scr_anim["truck"]["outro"] = %v_oki2_outro_gmc_truck;
	level.scr_animtree["truck"] = #animtree;
}

#using_animtree("vehicles");
outro_set_truck_animtree()
{
	self useAnimTree( #animtree );
}

outro_kill_treesniper()
{
	//okiPrint( "outro_kill_treesniper:  Looking for tree sniper!" );
	ent = getEnt( "e3_left_treesnipers_alive", "targetname" );
	if( isDefined(ent) )
	{
		//okiPrint( "outro_kill_treesniper:  Deleting tree sniper!" );
		ent Delete();
	}
}

outro_start()
{
	//TUEY Set music state to LEVEL_END
	setmusicstate("LEVEL_END");
	
	outro_kill_treesniper();
	level.nextmission_cleanup = ::fade_cleanup;
	level thread cleanup_trigger_enable( "e3_rear_cleanup_volume" ); // just in case there's a guy wandering around out back

	node = getent("outro_alignment", "targetname");

	disable_friendly_color();
	battlechatter_off("allies");
	move_players( "outro_players_start" );
	move_ai_single( level.sarge, "outro_alignment_struct" );
	move_ai_single( level.polonsky, "outro_alignment_struct" );

	outro_cacheplayer();
	outro_cachenpcs();
	outro_cachevehicles();
	
	outro_dialogue();
	
	// turn off hud stuff
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
		player setClientDvar ( "miniscoreboardhide", "1" );
	}
	
	//SetSavedDvar( "miniscoreboardhide", "1" );
	share_screen( get_host(), true, true );

	// get everybody into position.  Teleport the AI guys to their node beforehand
	players = get_players();
	p1 = players[0];
	
	// no shooting!
	for( i = 0; i < players.size; i++ )
	{
		
		players[i] FreezeControls( true ); // disable this so they don't have a chance to re-use weapons or turrets
		
		//players[i] RevivePlayer();
		//players[i] thread magic_bullet_shield();

		players[i] DisableWeapons();
		players[i] DisableOffhandWeapons();
		players[i] TakeAllWeapons();
		players[i] StopUsingTurret();
		
		players[i] AllowJump( false );
		players[i] AllowCrouch( false );
		players[i] AllowProne( false );		
		players[i] SetStance( "stand" );
		
		players[i] thread outro_delete_grenade();
		players[i] thread outro_prevent_bleedout();
		
		players[i] hide();
		
//		if( i != 0)
//		{
//			// put the player in spectator mode
//			level.otherPlayersSpectate = true;
//			level.otherPlayersSpectateClient = players[0];
//
//			players[i] thread maps\_callbackglobal::spawnSpectator();
//		}
		
		//wait_network_frame();
		players[i] thread play_outro_on_player(node);
	}
	
	

	guy1_spawn = getent( "outro_guy1", "targetname" );
	guy2_spawn = getent( "outro_guy2", "targetname" );
	co_spawn = getent( "outro_co", "targetname" );
	truck = getent( "outro_truck", "targetname");

	guy1 = guy1_spawn stalingradspawn();
	guy2 = guy2_spawn stalingradspawn();
	co = co_spawn stalingradspawn();
	truck makefakeai();

	guy1.animname = "guy1";
	guy2.animname = "guy2";
	co.animname = "co";
	truck.animname = "truck";

	truck outro_set_truck_animtree();
	
	level.sarge Detach( level.sarge.hatmodel );
	guy1 gun_remove();
	
//	// Spawn in the player hands
//	player_hands = spawn_anim_model( "player_hands" );
//	player_hands hide();
//	player_hands.animname= "player_hands";
//
//	player_hands.origin = node.origin;
//	player_hands.angles = node.angles;
//
//	// put player camera in right place, based on the first frame of the animation
//	node maps\_anim::anim_first_frame_solo( player_hands, "outro" );
//	p1 lerp_player_view_to_tag( player_hands, "tag_player", 0.1, 1, 60, 25, 25, 10 );

//	p1 playerlinkto( player_hands, "tag_player", 0, 1, 30, 30, 10, 10, false );
//	player_hands linkto( level.sarge, "tag_sync", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	level.sarge linkto( guy1, "tag_sync", ( 0, 0, 0 ), ( 0, 0, 0 ) );
//	guy1 linkto( node );

	//player_hands show(); // because you don't see the arms anymore

	// actually play the animations for all involved parties
	node thread anim_single_solo( level.sarge, "outro" );
//	node thread anim_single_solo( player_hands, "outro" );
	node thread anim_single_solo( level.polonsky, "outro" );
	node thread anim_single_solo( guy1, "outro" );
	node thread anim_single_solo( guy2, "outro" );
	node thread anim_single_solo( co, "outro" );
	node thread anim_single_solo( truck, "outro" );
	
	wait(8);
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_in(2);
	}	
	
	wait(29);
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(2);
	}	
	
	//SetSavedDvar( "miniscoreboardhide", "1" );
	share_screen( get_host(), false);
	
	// turn back on the hud stuff
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
		player setClientDvar ( "miniscoreboardhide", "0" );
	}
	
	//thread fade_to_black(2);
}


play_outro_on_player(node)
{
	
		// Spawn in the player hands
	self.player_hands = spawn_anim_model( "player_hands" );
	self.player_hands hide();
	self.player_hands.animname= "player_hands";

	self.player_hands.origin = node.origin;
	self.player_hands.angles = node.angles;

	// put player camera in right place, based on the first frame of the animation
	node maps\_anim::anim_first_frame_solo( self.player_hands, "outro" );
	self lerp_player_view_to_tag( self.player_hands, "tag_player", 0.1, 1, 60, 25, 25, 10 );	
	self linkto(self.player_hands,"tag_player");
	node thread anim_single_solo( self.player_hands, "outro" );
	self FreezeControls( false );
		
	
}


// wait for the player to throw a grenade, then immediately delete it.
outro_delete_grenade()
{
	self waittill( "grenade_fire", what );
	what Delete(); // SO THERE
}

outro_prevent_bleedout()
{
    self endon( "death" );
    self endon( "disconnect" );

    while( 1 )
    {
    	if( self maps\_laststand::player_is_in_laststand())
			{
				self RevivePlayer();
				self.bleedout_time = 100000;
			}
			wait_network_frame();
    }
}

outro_dialogue()
{
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_007A_POLO" );
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_009A_POLO" );
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_011A_POLO" );
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_012A_POLO" );
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_013A_POLO" );
	addnotetrack_dialogue( "polonsky", "dialog", "outro", "Oki2_OUT_017A_POLO" );
	
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Oki2_OUT_001A_ROEB" );
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Oki2_OUT_002A_ROEB" );
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Oki2_OUT_003A_ROEB" );
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Oki2_OUT_005A_ROEB" );
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Oki2_OUT_006A_ROEB" );
	
	addnotetrack_dialogue( "co", "dialog", "outro", "Oki2_OUT_004A_MAJG" );
	addnotetrack_dialogue( "co", "dialog", "outro", "Oki2_OUT_008A_MAJG" );
	addnotetrack_dialogue( "co", "dialog", "outro", "Oki2_OUT_010A_MAJG" );
	addnotetrack_dialogue( "co", "dialog", "outro", "Oki2_OUT_014A_MAJG" );
	addnotetrack_dialogue( "co", "dialog", "outro", "Oki2_OUT_016A_MAJG" );
	
	//addnotetrack_dialogue( "guy1", "dialog", "outro", "Oki2_OUT_015A_COR1" );
	
	//addnotetrack_dialogue( "guy2", "dialog", "outro", "Oki2_OUT_500A_COR2" );
	//addnotetrack_dialogue( "guy2", "dialog", "outro", "Oki2_OUT_501A_COR2" );
}

outro_startpoint()
{
	wait_for_first_player();
	setup_friends();
	move_players( "outro_players_start" );
	move_ai_single( level.sarge, "outro_sarge_start" );
	move_ai_single( level.polonsky, "outro_polonsky_start" );
	
	
	//fade_to_black(0.1);
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(1);
	}	

	level waittill("introscreen_complete");
	outro_start();
	nextmission();
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// E1 CLIFFSIDE GUN BEING BOMBED
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

e1_gun_fall()
{
	//hide the destroyed cliffside
	level.cliff_destroyed hide();

	//hide the falling gun
	level.cliff_gun = getent("falling_gun","targetname");
	level.cliff_gun hide();

	//explosion origins, we have three bombs hit spaced a bit apart
	exp1_origin = getstruct( "e1_cliffgun_bomb_a", "targetname" ).origin;
	exp2_origin = level.cliff_gun.origin;
	exp3_origin = getstruct( "e1_cliffgun_bomb_b", "targetname" ).origin;

	//wait until the player hits the trigger
	trig = getent("more_cave_defenders", "script_noteworthy");
	trig waittill("trigger");

	//spawn the plane in
	bomber_trig = getent("cliff_bomber","targetname");
	bomber_trig notify("trigger");
	wait(1);

	bomber = getent("e1_bomber_a","targetname");
	bomber playsound("planeby_3");

	plane = getent("e1_bomber_b","targetname");
	plane playsound("planeby_3");

	bomber waittill("e1_bombers_above_target");

	gun = getent("falling_gun_hideme","targetname"); //the crewed gun
	gun notify("crew dismounted");
	gun.nofire = true;
	level notify("stop_cliffgun");
	gun thread e1_arty_crew_setup_death();	//setup the arty crew for their death sequence

	playfx( level._effect["default_explosion"], exp1_origin );
	playsoundatposition( "mortar_dirt", exp1_origin );
	radiusdamage( exp1_origin, 512, 1000, 250);
	exp1_palm = getent( "e1_cliffgun_bomb01_palm", "targetname" );
	exp1_palm thread tree_rotate();

	wait(0.4);

	playfx( level._effect["default_explosion"], exp2_origin );
	playsoundatposition( "mortar_dirt", exp2_origin );
	radiusdamage( exp2_origin, 512, 1000, 250);
	level.cliff_destroyed show();
	level.cliff_intact hide();
	gun hide();
	level.cliff_gun show();
	for(i=0;i<level.cliff_rocks.size;i++)
	{
		level.cliff_rocks[i] delete();
	}

	wait(0.4);

	playfx( level._effect["default_explosion"], exp3_origin );
	playsoundatposition( "mortar_dirt", exp3_origin );
	radiusdamage( exp3_origin, 512, 1000, 250);

	exp3_palm = getent( "e1_cliffgun_bomb03_palm", "targetname" );
	exp3_palm thread tree_rotate();

	playfx(level._effect["falling_rocks"], (2010, 625 ,-156.5) );

	//temp until the animation gets in
	level.cliff_gun moveto( (2095.45 ,603.123, -353) ,2.5);
	level.cliff_gun rotateto( ( 47.0138 ,302.803, -85.4194 ),2.4);

	wait(1);
	level.cliff_gun playsound("gun_slide");


	level.cliff_gun waittill("movedone");
	playfx(level._effect["gunsmoke"],level.cliff_gun.origin + (0,0,25));
}


///*------------------------------------
//arty crew gets owned if they are alive when
//the gun gets taken out
//------------------------------------*/
#using_animtree("generic_human");
e1_arty_crew_setup_death()
{

	//move the arty crew to the edge of the cliff before killing them ( helps to make them always fall off the cliff )
	if( isDefined(self.arty_crew) && (self.arty_crew.size > 0) && isAlive(self.arty_crew))
	{
		for(i=0;i<self.arty_crew.size;i++)
		{
			self.arty_crew[i].deathanim = %death_explosion_forward13;
			throw_guy( self.arty_crew[i], self.arty_crew[i].origin + (500,0,-250) );
		}
	}

	//notify the gun script
	self notify ("dismount crew");

	//set  this flag so that the fake fire script stops ( won't need this once the model3 is setup and scripted )
	self.nofire = true;
	wait_network_frame();
	radiusdamage(self.origin,256,1000,1000);
}

tree_rotate()
{
	self rotateto((180, 270, 0), 1.0, 0.2, 0.3);
	wait(2.0);
}



// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ROCKET BARRAGE STUFF
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fire_rocket_series( launch_points_targetname, destination_vector, total_rockets, silent_launch )
{
	// rockets from each ship
	num_rockets = total_rockets;
//	num_rockets_per_ship = 12;

	// grab start points
	start_points = [];

	orgs = getstructarray( launch_points_targetname, "targetname" );

	// populate the ship
	q = 0;
	for(i = 0; i < num_rockets; i++)
	{
		q = i % orgs.size;
		start_points[i] = orgs[q].origin;
	}

	level thread rocket_salvo( destination_vector, start_points, silent_launch );
}

rocket_salvo( dest_point, start_points, silent_launch )
{
	use_launch_effects = true;

	if( isdefined(silent_launch) && silent_launch == true )
	{
		use_launch_effects = false;
	}

	for (i = 0; i < start_points.size; i++)
	{
			rocket = spawn ("script_model", start_points[i]);
			rocket setmodel ("peleliu_aerial_rocket");
			yaw_vec = vectortoangles(dest_point - rocket.origin);

			rocket.angles = (yaw_vec[0], yaw_vec[1] ,0);
			rocket.targetname = "oki_salvo_rocket";

			// TODO: take out this wait
			wait (0.01);
			if( use_launch_effects )
			{
				playfx( level._effect[ "rocket_launch" ], rocket.origin, anglestoforward(rocket.angles + (20,0,0) ) );
			}
			playfxontag( level._effect[ "rocket_trail" ], rocket, "tag_origin" );

			// sound of rocket flying through the air
			level thread rocket_sound(rocket);

			rocket thread rocket_think((dest_point[0] - 1500 + randomint(3000), dest_point[1] - 1500 + randomint(3000), dest_point[2] + randomint (40)));

			wait (randomfloatrange (0.15, 0.3));
	}
	
	wait(15);
	
	// forcibly cleanup, because occasionally a rocket sticks around
	rockets = getentarray( "oki_salvo_rocket", "targetname" );
	if( isDefined(rockets) )
	{
		////okiPrint( "rocket_salvo: Cleaning up stray rockets!" );
		for( i=0; i<rockets.size; i++ )
		{
			rockets[i] notify( "force delete" );
			rockets[i] delete();
		}
	}
}

// stolen to avoid loading all of _dpad_asset
throw_object_with_gravity( object, target_pos )
{
	object endon ("remove thrown object");
	start_pos = object.origin; // Get the start position
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = GetDvarInt( "g_gravity" ) * -1;
	
	// Get the distance
	dist = Distance( start_pos, target_pos );
	
	// Figure out the time depending on how fast we are going to
	// throw the object... 300 changes the "strength" of the velocity.
	// 300 seems to be pretty good. To make it more lofty, lower the number.
	// To make it more of a b-line throw, increase the number.
	time = dist / 2000;
	
	// Get the delta between the 2 points.
	delta = target_pos - start_pos;
	
	// Here's the math I stole from the grenade code. :) First figure out
	// the drop we're going to need using gravity and time squared.
	drop = 0.5 * gravity * ( time * time );
	
	// Now figure out the trajectory to throw the object at in order to
	// hit our map, taking drop and time into account.
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
	///////// End Math Section
	
	object MoveGravity( velocity, time );
}

rocket_sound(rocket)
{

	//wait(RandomIntRange(2, 5));
	counter = RandomIntRange(1,2);
	if (counter == 1)
	{
		rocket playloopsound ("rocket_run");
	}
}

rocket_think( destination_pos )
{
	// self is the rocket
	//self endon ("remove thrown object");
	self endon( "force delete" );

	thread throw_object_with_gravity( self, destination_pos );

	while (1)
	{
		if (self.origin[2] < destination_pos[2] )
		{
				playfx(level._effect["lci_rocket_impact"], self.origin);
				thread play_sound_in_space ("rocket_dirt", self.origin); // lci rocket impact sound
				earthquake( 0.5, 3, self.origin, 2050 );
				break;
		}
		wait (0.05);
	}
	self notify ("remove thrown object");

	// to get shit deleting again
	wait (0.1);
	self delete();
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Throwing guys!
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

throw_guy( guy, targetpos )
{
	throw_object_with_gravity( guy, targetpos );
	guy StartRagdoll();
}
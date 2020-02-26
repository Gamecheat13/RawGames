#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_anim;

main()
{
	level.hint_text_size = 1.6;
	level.targets_hit = 0;
	set_console_status();

	//setDvar ( "hud_fade_offhand", 6 ); 
	
	//setsaveddvar ( "r_lodbias", -400 );

	// add the starts before _load because _load handles starts now
	default_start( ::look_training );
	add_start( "look", ::look_training );
	add_start( "obj", ::navigationTraining );
	add_start( "shoot", ::rifle_start );
	add_start( "timed", ::rifle_timed_start );
	add_start( "sidearm", ::sidearm_start );
	add_start( "frag", ::frag_start );
	add_start( "m203", ::launcher_start );
	add_start( "c4", ::explosives_start );
	add_start( "course", ::obstacle_start );
	add_start( "ship", ::reveal_start );
	add_start( "mp5", ::cargoship_start );
	add_start( "deck", ::deck_start );

	precacheShader( "objective" );
	precacheShader( "hud_icon_c4" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_right" );
	precacheShader( "hud_icon_40mm_grenade" );
	precacheshader( "popmenu_bg" );
	
	maps\_blackhawk::main( "vehicle_blackhawk" );
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_red" );
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_green" );
	maps\_bus::main( "vehicle_bus_destructable" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_humvee::main( "vehicle_humvee_camo" );
	maps\_small_wagon::main( "vehicle_small_wagon_turq" );
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_brn" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	maps\killhouse_fx::main();
	maps\_load::main();
	maps\killhouse_anim::main();
	level thread maps\killhouse_amb::main();
	//maps\_compass::setupMiniMap("compass_map_training");
	maps\_c4::main(); // Add in you main() function.
	maps\createart\killhouse_art::main();

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	level.curObjective = 1;
	level.objectives = [];

	//speakersInit();
	registerActions();
	//thread playerShootTracker();
	
	flag_init( "ADS_targets_shot" );
	flag_init( "hip_targets_shot" );
	flag_init( "crosshair_dialog" );	
	flag_init( "ADS_shoot_dialog" );	
	//flag_init ( "sidearm_complete" );
	flag_init ( "melee_run_dialog" );
	flag_init( "melee_complete" );
	flag_init ( "picked_up_launcher_dialog" );
	flag_init ( "plant_c4_dialog" );
	//flag_init ( "c4_equiped" );
	flag_init ( "c4_thrown" );
    flag_init ( "C4_planted" );
    flag_init ( "car_destroyed" );
    flag_init ( "reveal_dialog_done" );
	flag_init ( "player_sprinted" );
	flag_init ( "fragTraining_end" );
	flag_init ( "got_flashes" );

	precacheString( &"KILLHOUSE_OBJ_GET_RIFLE_AMMO" );
	precacheString( &"KILLHOUSE_OBJ_ENTER_STALL" );
	precacheString( &"KILLHOUSE_HINT_SIDEARM" );
	precacheString( &"KILLHOUSE_HINT_OBJECTIVE_MARKER" );
	precacheString( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER" );
	precacheString( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER2" );
	precacheString( &"KILLHOUSE_HINT_LADDER" );
	precacheString( &"KILLHOUSE_HINT_HOLDING_SPRINT" );
	precacheString( &"KILLHOUSE_AXIS_OPTION_MENU1_ALL" );
	precacheString( &"KILLHOUSE_AXIS_OPTION_MENU2_ALL" );

	precacheMenu("invert_axis");
	precacheMenu("invert_axis_pc");

    flag_init ( "spawn_sidearms" );
    flag_init ( "spawn_frags" );
    flag_init ( "spawn_launcher" );
	
	flashes = getEntArray( "pickup_flash", "targetname" );
	frags = getEntArray( "frag_ammoitem", "targetname" );
	launcher_ammoitem = getEntArray( "launcher_ammoitem", "targetname" );
	array_thread( flashes, ::Ammorespawnthink , undefined, "flash_grenade", "got_flashes" );
	array_thread( getEntArray( "pickup_mp5", "targetname" ), ::ammoRespawnThink , undefined, "mp5" );
	array_thread( getEntArray( "pickup_rifle", "targetname" ), ::ammoRespawnThink , undefined, "g36c" );
	array_thread( getEntArray( "pickup_sidearm", "targetname" ), ::ammoRespawnThink , "spawn_sidearms", "usp" );
	array_thread( frags, ::ammoRespawnThink , "spawn_frags", "fraggrenade", "fragTraining_end" );
	array_thread( launcher_ammoitem, ::ammoRespawnThink , "spawn_launcher", "m203_m4" );
	array_thread( getEntArray( "pickup_pistol", "targetname" ), ::ammoRespawnThink , undefined, "usp" );
	
	
	level.gunPrimary = "g36c";
	level.gunPrimaryClipAmmo = 30;
	level.gunSidearm = "usp";
	lowerPlywoodWalls();
	thread training_targetDummies( "rifle" );
	//thread test();
	thread melon_think();
	thread turn_off_frag_lights();
	thread waters_think();
	thread mac_think();
	thread newcastle_think();
	thread price_think();
	
	car = getent ( "destructible", "targetname" );
	car thread do_in_order( ::waittill_msg, "destroyed", ::flag_set, "car_destroyed" );
	car destructible_disable_explosion();
	
	pickupTrigger = getEnt( "c4_pickup", "targetname" );
	pickupTrigger trigger_off();
	
	C4_models = getEntArray( pickupTrigger.target, "targetname" );
	for ( i = 0; i < C4_models.size; i++ )
		C4_models[ i ] hide();
		
		
	//level.destructible_type[0].parts[0][3].v["validDamageCause"] = "ai_only";
	
	flag_init ( "start_deck" );
	thread deck_training();
	thread ambient_trucks();
	helis = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 8 );
	array_thread(getentarray("level_scripted_unloadnode","script_noteworthy"),::level_scripted_unloadnode );
	
	//array_thread(getentarray("killhouse_interior","targetname"),::vision_trigger, "killhouse_interior" );
	//array_thread(getentarray("killhouse_exterior","targetname"),::vision_trigger, "killhouse" );
}

vision_trigger( vision_file )
{
	while ( 1 )
	{
		self waittill ( "trigger" );	
		set_vision_set( vision_file, 1 );
		while ( level.player istouching ( self ) )
			wait .1;
	}
}

look_training()
{
	thread hint( &"KILLHOUSE_LOOK_UP", 9999 );
	
	while ( 1 )
	{
		angles = level.player getPlayerAngles();
		println ( angles );
		if ( angles[ 0 ] <  -40 )
			break;
		wait .1;
	}
	clear_hints();
	wait .5;
	thread hint( &"KILLHOUSE_LOOK_DOWN", 9999 );
	
	while ( 1 )
	{
		angles = level.player getPlayerAngles();
		println ( angles );
		if ( angles[ 0 ] >  0 )
			break;
		wait .1;
	}
	clear_hints();
	
    level.invertaxis = false;
    
    if ( level.Console )//why?
	{
		if(isdefined( getdvar("input_invertPitch") ) && getdvar("input_invertPitch") == "1" )
			level.invertaxis = true;			
	}
	

	if( level.invertaxis )
		setDvar( "ui_start_inverted", 1 );
	else
		setDvar( "ui_start_inverted", 0 );
	
	setDvar( "ui_invert_string", "@KILLHOUSE_AXIS_OPTION_MENU1_ALL" );
	if ( level.console )
		level.player openMenu("invert_axis");
	else
		level.player openMenu("invert_axis_pc");
	
	level.player freezecontrols(true);
	setblur(5, .1);
	level.player waittill("menuresponse", menu, response);
    setblur(0, .2);
    level.player freezecontrols(false);
    
    if(response == "try_invert")
    {
		thread hint( &"KILLHOUSE_LOOK_UP", 9999 );
		
		while ( 1 )
		{
			angles = level.player getPlayerAngles();
			println ( angles );
			if ( angles[ 0 ] <  -40 )
				break;
			wait .1;
		}
		clear_hints();
		wait .5;
		thread hint( &"KILLHOUSE_LOOK_DOWN", 9999 );
		
		while ( 1 )
		{
			angles = level.player getPlayerAngles();
			println ( angles );
			if ( angles[ 0 ] >  0 )
				break;
			wait .1;
		}
		clear_hints();
		
		setDvar( "ui_invert_string", "@KILLHOUSE_AXIS_OPTION_MENU2_ALL" );
		if ( level.console )
			level.player openMenu("invert_axis");
		else
			level.player openMenu("invert_axis_pc");
		
		level.player freezecontrols(true);
		setblur(5, .1);
		level.player waittill("menuresponse", menu, response);
		setblur(0, .2);
		level.player freezecontrols(false);
	}
	thread navigationTraining();
}


level_scripted_unloadnode()
{
	while(1)
	{
		self waittill ("trigger",helicopter );
		helicopter vehicle_detachfrompath();
		helicopter setspeed( 20,20 );
		helicopter vehicle_land();
		//helicopter notify ("unload");
		//helicopter waittill ("unloaded");
		//ai = getnonridingai();
		//helicopter notify ("load",ai);
		//helicopter waittill ("loaded");
		wait 10;
		helicopter vehicle_resumepath();
	}
}




ambient_trucks()
{
	trigger = getent ( "se_truck_trigger", "targetname" );
	while ( 1 )
	{
		//trigger notify ( "trigger" );
		group = randomint( 8 );
		vehicles = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( group );
		for ( i = 0; i < vehicles.size; i++ )
		{
			speed = randomintrange ( 30, 50 );
			vehicles [ i ] setspeed ( speed, 30, 30 );
		}
		wait ( randomintrange ( 2, 5 ) );
	}
}

waters_think()
{
	level.waters = getent("waters", "script_noteworthy");
	assert( isDefined( level.waters ) );
	level.waters.animname = "gaz";
	level.waters.disablearrivals = true;
	level.waters.disableexits = true;
	level.waters.lastSpeakTime = 0;
	level.waters.lastNagTime = 0;
	level.waters.speaking = false;
	//level.waters pushplayer( true );
}

newcastle_think()
{
	flag_wait ( "spawn_frags" );
	
	spawner = getent("nwc", "script_noteworthy");
	assert( isDefined( spawner ) );
	
	level.newcastle = spawner spawn_ai();
	
	level.newcastle.animname = "nwc";
	level.newcastle.disablearrivals = true;
	level.newcastle.disableexits = true;
	level.newcastle.lastSpeakTime = 0;
	level.newcastle.lastNagTime = 0;
	level.newcastle.speaking = false;
	//level.newcastle pushplayer( true );
}

mac_think()
{
	level.mac = getent("mac", "script_noteworthy");
	assert( isDefined( level.mac ) );
	level.mac.animname = "mac";
	level.mac.disablearrivals = true;
	level.mac.disableexits = true;
	level.mac.lastSpeakTime = 0;
	level.mac.lastNagTime = 0;
	level.mac.speaking = false;
	//level.mac pushplayer( true );
}

price_think()
{
	level.price = getent("price", "script_noteworthy");
	assert( isDefined( level.price ) );
	level.price.animname = "price";
	level.price.disablearrivals = true;
	level.price.disableexits = true;
	level.price.lastSpeakTime = 0;
	level.price.lastNagTime = 0;
	level.price.speaking = false;
	level.price pushplayer( true );
}

//****************************************************************
//****************************************************************
//****************************************************************

navigationTraining()
{
	level notify ( "navigationTraining_start" );

	level.waters thread execDialog( "illletyouin" );

	registerObjective( "obj_enter_range", "Use the Objective Indicator on your HUD to find the firing range.", getEnt( "rifle_range_obj", "targetname" ) );
	setObjectiveState( "obj_enter_range", "current" );
	
	wait 3;
	
	thread objective_hints();

	flag_wait( "at_rifle_range" );
	
	door = getEnt( "rifle_range_door", "targetname" );
	door rotateto( door.angles + (0,-115,0), 1, .5, 0 );
	door connectpaths();
	
	flag_wait ( "inside_firing_range" );
	
	setObjectiveState( "obj_enter_range", "done" );
	
	level.waters thread execDialog( "goodtosee" );
	//level.waters Delaythread( 1, ::execDialog, "goodtosee" );

	level notify ( "navigationTraining_end" );
	
	clear_hints();
	
	wait ( 0.5 );
	thread rifleTraining();
}


objective_hints()
{
	level endon ( "mission failed" );
	level endon ( "navigationTraining_end" );
	
	compass_hint();
	
	wait 2;
	
	keyHint( "objectives", 6.0);
	
	//level.marine1.lastNagTime = getTime();
	timePassed = 6;
	for ( ;; )
	{
		//if( distance( level.player.origin, level.marine1.origin ) < 512 )
		//	level.marine1 nagPlayer( "squadwaiting", 15.0 );

		if ( !flag( "at_rifle_range" ) && timePassed > 10.0 )
		{
			//hint( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER", 6.0 );
			thread compass_reminder();
			RefreshHudCompass();
			//wait( 0.5 );
			//thread hint( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER2", 10.0 );
			timePassed = 0;
		}

		timePassed += 0.05;
		wait ( 0.05 );
	}
}

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	level.hintbackground setPoint( "TOP", undefined, 0, 125 );
	level.hintbackground.alpha = .5;
}

compass_hint( text, timeOut )
{
	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background();
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	level.hintElem setText( &"KILLHOUSE_HINT_OBJECTIVE_MARKER" );

	level.iconElem = createIcon( "objective", 32, 32 );
	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
	level.iconElem setPoint( "TOP", undefined, 0, 155 );

	wait 5;

	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	wait .5;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}

compass_reminder()
{	
	clear_hints();
	level endon ( "clearing_hints" );

	double_line = true;
	add_hint_background( double_line );
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	level.hintElem setText( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER" );


	level.iconElem = createIcon( "objective", 32, 32 );
	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
	level.iconElem setPoint( "TOP", undefined, 0, 175 );

	wait 5;
	setObjectiveLocation( "obj_enter_range", getEnt( "rifle_range_obj", "targetname" )  );

	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	wait 2;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}

rifle_start()
{
	shooting_start = getent( "shooting_start", "targetname" );
	level.player setOrigin( shooting_start.origin );
	level.player setPlayerAngles( shooting_start.angles );
	
	flag_set ( "inside_firing_range" );
	
	thread rifleTraining();
}

move_gaz_once_player_past()
{
	flag_wait ( "past_gaz" );
	//level.waters walk_to ( 	getnode ( "stationone_node", "script_noteworthy" ) );
	level.waters setgoalnode ( 	getnode ( "stationone_node", "script_noteworthy" ) );
}


rifleTraining()
{
	level notify ( "rifleTraining_start" );
	flag_trigger_init( "player_at_rifle_stall", getEnt( "rifleTraining_stall", "targetname" ), true );

	flag_wait ( "inside_firing_range" );
	
	
	registerObjective( "obj_rifle", "Pick up a rifle from the table.", getEnt( "obj_rifle_ammo", "targetname" ) );
	setObjectiveState( "obj_rifle", "current" );
	
	thread move_gaz_once_player_past();

	while ( !(level.player GetWeaponAmmoStock( level.gunPrimary ) ) )
		wait ( 0.05 );

	door = getEnt( "rifle_range_door", "targetname" );
	door rotateto( door.angles + (0,115,0), 1, .5, 0 );
	door disconnectpaths();
	autosave_by_name( "rifle_training" );

	setObjectiveString( "obj_rifle", "Enter station number 1 and aim down your sights." );
	setObjectiveLocation( "obj_rifle", getEnt( "obj_rifle_stall", "targetname" )  );


	//You know the drill. Go to station one...and aim your rifle downrange.
	level.waters execDialog( "youknowdrill" );

	/*
	if ( !flag( "player_at_rifle_stall" ) )
	{
		//Captain Price wants an evaluation of everyone's shooting skills, so don't fuck it up mate! You may have passed Selection, but you're still on probation as far as the Regiment's concerned.
		level.waters thread execDialog( "priceevaluation" );
	}
	*/
	
	while( !flag( "player_at_rifle_stall" ) )
		wait ( 0.05 );
	
	if ( !isADS() )
	{
		//Now aim your rifle down range, Soap.
		level.waters thread execDialog( "rifledownrange" );
		thread keyHint( "ads" );
	}
	
	while( !isADS() )
		wait ( 0.05 );
	
	thread ADS_shoot_dialog();
	
	
	wait ( 0.1 );
	raiseTargetDummies( "rifle", undefined, undefined );
	setObjectiveString( "obj_rifle", "Shoot each target while aiming down your sights." );

	thread flag_when_lowered( "ADS_targets_shot" );

	flag_wait( "ADS_targets_shot" );
	flag_wait( "ADS_shoot_dialog" );

	//Brilliant. You know Soap, it might help to aim your rifle before firing.
	//level.waters thread execDialog( "brilliant" );

	thread rifle_hip_shooting();
}

flag_when_lowered( flag )
{
	level.targets_hit = 0;
	targetDummies = getTargetDummies( "rifle" );
	numRaised = targetDummies.size;
	while ( level.targets_hit < numRaised )
		wait ( 0.05 );
	
	flag_set ( flag );
}


ADS_shoot_dialog()
{
	//Lovely…
	level.waters execDialog( "lovely" );

	if ( !flag( "ADS_targets_shot" ) )
	{
		if( level.Console )
			thread keyHint( "attack" );
		else
			thread keyHint( "pc_attack" );
			
		//Now. Shoot - each - target, while aiming down the sights.
		level.waters execDialog( "shooteachtarget" );
	}
	
	flag_set( "ADS_shoot_dialog" );	
}

rifle_hip_shooting()
{
	wait .5;
	thread hint ( &"KILLHOUSE_HINT_ADS_ACCURACY", 10 );
	//Now, shoot at the targets while firing from the hip.
	level.waters execDialog( "firingfromhip" );
	
	setObjectiveString( "obj_rifle", "Shoot each target while firing from the hip." );
	wait 1;
	
	if ( isADS() )
		thread keyHint( "stop_ads" );
	
	while( isADS() )
		wait ( 0.05 );
		
	raiseTargetDummies( "rifle", undefined, undefined );
	thread flag_when_lowered( "hip_targets_shot" );
	

	if( level.Console )
		keyHint( "hip_attack" );
	else
		keyHint( "pc_hip_attack" );

	//thread crosshair_dialog();

	double_line = true;
	thread hint ( &"KILLHOUSE_HINT_CROSSHAIR_CHANGES", 10, double_line );

	flag_wait( "hip_targets_shot" );
	//flag_wait( "crosshair_dialog" );	
	thread rifle_penetration_shooting();
}


crosshair_dialog()
{
	wait 1;
	//Notice that your crosshair changes size as you fire, this indicates your current accuracy blah blah blaaah…
	level.waters execDialog( "changessize" );
	
	//…uhhh, also note that you will never be as accurate when you fire from the hip, as when you aim down your sights. (Bloody hell this is a stupid test innit?) All right let's get this over with.
	level.waters execDialog( "stupidtest" );
	
	wait 1;
	
	flag_set( "crosshair_dialog" );	
}

rifle_penetration_shooting()
{
	wait .5;
	//Now I'm going to block the targets with a sheet of plywood.
	level.waters execDialog( "blocktargets" );
	
	raiseTargetDummies( "rifle", undefined, undefined );
	raisePlywoodWalls();
	setObjectiveString( "obj_rifle", "Shoot a target through the wood." );

	
	wait .5;
	
	//I want you to shoot the targets through the wood.
	level.waters execDialog( "shoottargets" );
	
	//Bullets will penetrate thin, weak materials like wood, plaster and sheet metal. The larger the weapon, the more penetrating power it has. But - you already knew that. Moving on.
	level.waters thread execDialog( "bulletspenetrate" );

	targetDummies = getTargetDummies( "rifle" );
	numRaised = targetDummies.size;
	while ( numRaised == targetDummies.size )
	{
		numRaised = 0;
		for ( index = 0; index < targetDummies.size; index++ )
		{
			if ( targetDummies[index].raised )
				numRaised++;
		}
	
		/*
		if ( !(level.player GetWeaponAmmoStock( level.gunPrimary )) )
		{
			level.marine2 nagPlayer( "getammo", 8.0 ); // should tell carver to get more ammo
			println ("z:             wtf2");
		}
		else if ( !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
		{
			wait ( 2.0 );
			if ( !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
			{
				thread keyHint( "reload" );

				level.marine2 nagPlayer( "loadweapon", 8.0 );
				println ("z:             wtf");
			}
		}
		else if ( !flag( "player_at_rifle_stall" ) )
		{
			level.marine2 nagPlayer( "backtostation", 8.0 );
		}
		*/
		wait ( 0.05 );
	}

	//Good.
	level.waters execDialog( "good" );
	
	setObjectiveState( "obj_rifle", "done" );
	lowerPlywoodWalls();
	lowerTargetDummies( "rifle", undefined, undefined );
	
	wait .5;
	
	thread rifle_timed_shooting();
}

rifle_timed_start()
{
	shooting_start = getent( "shooting_start", "targetname" );
	level.player setOrigin( shooting_start.origin );
	level.player setPlayerAngles( shooting_start.angles );
	level.player giveWeapon("g36c");
	level.player switchtoWeapon("g36c");
	
	thread rifle_timed_shooting();
}

rifle_timed_shooting()
{
	//Now I'm going make the targets pop up one at a time.
	level.waters execDialog( "targetspop" );
	
	wait .5;
	
	//Hit all of them as fast as you can.
	level.waters execDialog( "hitall" );
		
	registerObjective( "obj_timed_rifle", "Shoot each target as quickly as possible.", getEnt("obj_rifle_stall", "targetname" ) );
	setObjectiveState( "obj_timed_rifle", "current" );
	
	if ( level.console )
	{
		actionBind = getActionBind( "ads_switch" );
		double_line = true;
		thread hint( actionBind.hint, 10, double_line );
		
		//As long as your crosshairs are near the targets, you can snap onto them by repeatedly popping in 		//and out of aiming down the sight. 
		level.waters execDialog( "cansnap" );
	}
	
	if ( (level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
	{
		keyHint( "reload" );
		wait ( 2.0 );
	}
	
	tooslow_dialog = [];
	tooslow_dialog[ 0 ] = "stilltooslow"; //You're still too slow…
	tooslow_dialog[ 1 ] = "again"; //Again.
	tooslow_dialog[ 2 ] = "again2"; //Again.
	tooslow_dialog[ 3 ] = "walkinpark"; //Too slow. Come on. This should be a walk in the park for you.
	

	numRepeats = 0;
	while ( 1 )
	{
		//level.marine2 execDialog( "fire" );
		lowerTargetDummies( "rifle" );
		
		if ( level.console )
		{
			actionBind = getActionBind( "ads_switch" );
			double_line = true;
			thread hint( actionBind.hint, 10, double_line );
			wait 4;
		}
		
		level.num_hit = 0;
		thread timedTargets();
		
		wait 10;
		
		level notify ("times_up");

		if ( level.num_hit > 6 )
			break;
		wait 1;

		numRepeats++;
		//iprintlnbold( "Too slow" );
		lowerTargetDummies( "rifle" );
		if ( numRepeats == 1 )
			level.waters execDialog( "tryagain" );//Too slow mate! Try again!
		else
			level.waters execDialog( tooslow_dialog[ randomint ( tooslow_dialog.size ) ] );

		wait 2;
		
		if ( (level.player GetWeaponAmmoClip( level.gunPrimary ) ) < level.gunPrimaryClipAmmo )
		{
			keyHint( "reload" );
			//wait ( 2.0 );
			//level.marine2 nagPlayer( "loadweapon", 8.0 );
		}
	}
	flag_set ( "spawn_sidearms" );

	wait 1;

	//iprintlnbold( level.num_hit + " hits" );
	setObjectiveState( "obj_timed_rifle", "done" );

	//Proper good job mate!
	level.waters execDialog( "propergood" );

	level notify ( "rifleTraining_end" );
	wait 0.5;
	thread sidearm_Training();
}

timedTargets()
{
	level endon ("times_up");
	targets = getentarray ( "rifle_target_dummy", "script_noteworthy" );
	last_selection = -1;
	while (1)
	{
		while (1)
		{
			//randomly pop up a target
			selected_target = randomint(targets.size);
			if ( selected_target != last_selection )
				break;
		}
		
		last_selection = selected_target;
		targets[ selected_target ] thread moveTargetDummy( "raise" );
		
		//wait for target to be hit
		targets[ selected_target ] waittill ( "hit" );
		level.num_hit++;
		
		wait .1;
	}
}

sidearm_start()
{
	shooting_start = getent( "shooting_start", "targetname" );
	level.player setOrigin( shooting_start.origin );
	level.player setPlayerAngles( shooting_start.angles );
	level.player giveWeapon("g36c");
	level.player switchtoWeapon("g36c");
	
	thread sideArm_Training();
}


sideArm_Training()
{
	level notify ( "sideArmTraining_begin" );
	autosave_by_name( "sidearm_training" );
	
	flag_set( "spawn_sidearms" );


	//level.waters thread walk_to ( getnode ( "sidearm_node", "script_noteworthy" ) );
	
	//Now go get a side arm from the table.
	level.waters execDialog( "getsidearm" );
	
	//OBJECTIVE 3: Pick up a pistol.
	registerObjective( "obj_sidearm", "Get a pistol from the same place you got the rifle.", getEnt( "obj_rifle_ammo", "targetname" ) );
	setObjectiveState( "obj_sidearm", "current" );


	while ( level.player getCurrentWeapon() != level.gunSidearm )
	{
		//NAG_HINT: Approach the table and hold [USE_BUTTON] to pick up a pistol.
		wait .05;
	}
	level notify ( "show_melon" );
	
	setObjectiveString( "obj_sidearm", "Switch to your rifle and then back to your pistol." );
	
	//NEW2 Sgt. Waters: "Good. Now switch to your rifle."
	level.waters execDialog( "switchtorifle" );
	
	//OBJECTIVE 3: Switch to your rifle and then back to your pistol.

	while ( level.player getCurrentWeapon() != level.gunPrimary )
	{
		//NAG_HINT: Press [WEAPON_SWITCH] to switch to your rifle.
		thread keyHint( "primary" );
		wait .05;
	}

	
	//NEW2 Sgt. Waters: "Good. Now switch to your side arm again."
	level.waters execDialog( "pulloutsidearm" );

	if ( level.player getCurrentWeapon() != level.gunSidearm )
	{
		//NAG_HINT: Press [WEAPON_SWITCH] to switch to your pistol.
		thread keyHint( "sidearm" );
		//wait .05;
	}

	//*fast pistol swapping

	//Sgt. Waters: "Switching to your pistol is always faster than reloading."
	level.waters execDialog( "switchingfaster" );

	//Sgt. Waters: "If your caught with an empty magazine I recommend you use your side arm, 
	//thats what its there for."
	//level.waters execDialog( "shortofelephant" );
	
	setObjectiveState( "obj_sidearm", "done" );

	flag_set ( "sidearm_complete" );
	level notify ( "sideArmTraining_end" );
	wait ( 0.5 );
	thread melee_training();
}

melee_training()
{
	//while( !flag( "melee_entered" ) )
	//	wait ( 0.05 );
	level notify ( "melee_training" );
	
	registerObjective( "obj_melee", "Melee the water melon with your knife.", getEnt( "scr_watermelon", "targetname" ) );
	setObjectiveState( "obj_melee", "current" );
	
	//level.waters thread walk_to ( getnode ( "melon_node", "script_noteworthy" ) );
	
	if ( !flag ( "near_melee" ) || !flag ( "melee_complete" ) )
	{
		thread hint( &"KILLHOUSE_HINT_APPROACH_MELEE", 9999 );
		
		//All right Soap, come this way.
		level.waters execDialog( "comethisway" );
	}
	
	thread melee_run_dialog();
	
	flag_wait ( "near_melee" );
	
	if ( !flag ( "melee_complete" ) )
		thread keyHint( "melee" );
	
	flag_wait ( "melee_complete" );
	
	door = getEnt( "rifle_range_door", "targetname" );
	door rotateto( door.angles + (0,-115,0), 1, .5, 0 );
	door connectpaths();
	
	flag_wait ( "melee_run_dialog" );

	wait .5;
	
	
	flag_set ( "spawn_frags" );
	
	//Lovely. Your fruit killing skills are remarkable.
	level.waters  execDialog( "fruitkilling" );
	
	setObjectiveState( "obj_melee", "done" );
	
	level.waters  execDialog( "allgoodhere" );

	//level.waters thread walk_to ( getnode ( "door_node", "script_noteworthy" ) );
	
	level notify ( "meleeTraining_end" );
	wait ( 0.5 );
	thread frag_Training();
}

melee_run_dialog()
{
	if ( !flag ( "melee_complete" ) )
	{
		//Here's the situation. You're caught with an empty magazine and you're just a few feet from your enemy.
		level.waters execDialog( "fewfeet" );
		wait .3;
		//What do you do? Easy. You gut the bastard!
		level.waters execDialog( "whatdoyoudo" );
	}
	if ( !flag ( "melee_complete" ) )
		level.waters execDialog( "attackwithknife" );

	flag_set ( "melee_run_dialog" );
}


frag_start()
{
	frag_start = getent( "frag_start", "targetname" );
	level.player setOrigin( frag_start.origin );
	level.player setPlayerAngles( frag_start.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("usp");
	level.player switchtoWeapon("g36c");
	
	flag_set ( "spawn_frags" );
	
	thread frag_Training();
}

frag_trigger_think( flag, trigger, continuous )
{
	flag_init( flag );
	trigger enablegrenadetouchdamage();
	if ( isdefined ( trigger.target ) )
		trigger.light = getEnt( trigger.target, "targetname" );
	
	if ( isdefined ( trigger.light ) )
		trigger.light thread flicker_on();
	
	if( !isDefined( continuous ) )
		continuous = false;
	
	trigger _flag_wait_trigger( flag, continuous );
	
	level.player playSound( "killhouse_buzzer" );
	
	if ( isdefined ( trigger.light ) )
		trigger.light thread flicker_off();
	
	return trigger;
}

light_off()
{
	self setLightIntensity( 0 );
}

light_on()
{
	self setLightIntensity( 1 );
}

flicker_off()
{
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .1);
	self setLightIntensity( .7 );
	wait randomfloatrange ( .1, .2);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .4);
	self setLightIntensity( .5 );
	wait randomfloatrange ( .1, .5);
	self setLightIntensity( 0 );
}

flicker_on()
{
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( .4 );
	wait randomfloatrange ( .2, .4);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( .6 );
	wait randomfloatrange ( .05, .2);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .1);
	self setLightIntensity( 1 );
}

in_pit()
{
	pit = getEnt( "safety_pit", "targetname" );
	if ( !level.player istouching( pit ) )
		return false;
	return true;
}

frag_too_low_hint()
{
	level endon ( "fragTraining_end" );
	self enablegrenadetouchdamage();
	while( 1 )
	{
		self waittill ( "trigger" );	
		clear_hints();
		hint( &"KILLHOUSE_HINT_GRENADE_TOO_LOW", 6 ); 
	}
}

walk_to( goal )
{
	self set_generic_run_anim( "walk", true );
	//self.walk_combatanim = level.scr_anim[ "generic" ][ "walk" ];
	//self.walk_noncombatanim = level.scr_anim[ "generic" ][ "walk" ];
	self.disablearrivals = true;
	self.disableexits = true;
	
	self.goalradius = 32;
	self setgoalnode ( goal );
	self waittill ( "goal" );
	self anim_generic( self, "patrol_stop" );
	self setgoalpos ( self.origin );
}

frag_Training()
{
	level notify ( "fragTraining_begin" );
	autosave_by_name( "frag_training" );
	
	flag_set ( "start_frag_training" );	
	
	registerObjective( "obj_frags", "Go outside and report to Sgt. Newcastle.", getEnt( "obj_frag_ammo", "targetname" ) );
	setObjectiveState( "obj_frags", "current" );

	flag_wait ( "near_grenade_area" );

	setObjectiveString( "obj_frags", "Pick up the frag grenades." );

	//It's time for some fun mate. Let's blow some shit up…
	level.newcastle execDialog( "timeforfun" );
	
	if ( !( level.player GetWeaponAmmoStock( "fraggrenade" ) ) &&  (!( in_pit() ) ) )
	{
		//Pick up those frag grenades and get in the safety pit.
		level.newcastle execDialog( "pickupfrag" );
	}
		
	while ( !(level.player GetWeaponAmmoStock( "fraggrenade" ) ) )
		wait ( 0.05 );
	
	getEnt( "grenade_too_low", "targetname" ) thread frag_too_low_hint();
	
	thread frag_trigger_think( "frag_target_1", getEnt( "grenade_damage_trigger1", "targetname" ) );
	thread frag_trigger_think( "frag_target_2", getEnt( "grenade_damage_trigger2", "targetname" ) );
	thread frag_trigger_think( "frag_target_3", getEnt( "grenade_damage_trigger3", "targetname" ) );
	
	
	setObjectiveLocation( "obj_frags", getEnt( "safety_pit", "targetname" ) );
	
	if (! ( in_pit() ) )
	{ 
		setObjectiveString( "obj_frags", "Enter the safety pit." );
		//Get in the safety pit Soap.
		level.newcastle execDialog( "getinsafety" );
	}
	
	getEnt( "safety_pit", "targetname" ) waittill ( "trigger" );
	
	//level.newcastle thread walk_to( getnode ( "watch_pit_node", "script_noteworthy" ) );
	level.newcastle setgoalnode ( getnode ( "watch_pit_node", "script_noteworthy" ) );
	
	//Now throw a grenade into windows two, three and four.
	level.newcastle thread execDialog( "throwgrenade" );
	thread keyHint( "frag" );
	
	setObjectiveString( "obj_frags", "Throw a grenade into windows two, three and four." );
	setObjectiveLocation( "obj_frags", getEnt( "safety_pit", "targetname" )  );

	wait ( 0.1 );

	numRemaining = 0;
	for ( index = 1; index < 4; index++ )
	{
		if ( flag( "frag_target_" + index ) )
			continue;

		numRemaining++;
	}


	//level.marine4 execDialog( "firstwindow" );

	//level.marine4.lastNagTime = getTime();
	while( numRemaining )
	{
		curRemaining = 0;

		nextTarget = "";
		if ( !flag( "frag_target_1" ) )
		{
			curRemaining++;
			nextTarget = "firstwindow";
		}
		if ( !flag( "frag_target_2" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "secondwindow";
		}
		if ( !flag( "frag_target_3" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "dumpster";
		}

		if ( !curRemaining )
			break;

		if ( curRemaining != numRemaining )
		{
			//level.marine4 execDialog( nextTarget );
			//level.marine4.lastNagTime = getTime();
		}
		else
		{
			//level.marine4 nagPlayer( nextTarget + "again", 10.0 );
		}

		numRemaining = curRemaining;

		wait ( 0.05 );
	}

	setObjectiveState( "obj_frags", "done" );

	wait ( 1.0 );
	//level.marine4 thread execDialog( "gotorange" );

	flag_set ( "fragTraining_end" );
	thread launcherTraining();
}

launcher_trigger_think( flag, trigger, continuous )
{
	flag_init( flag );
	trigger.light = getEnt( trigger.target, "targetname" );
	
	trigger.light thread flicker_on();
	
	if( !isDefined( continuous ) )
		continuous = false;
	
	trigger _flag_wait_trigger( flag, continuous );
	
	level.player playSound( "killhouse_buzzer" );
	trigger.light thread flicker_off();
	
	return trigger;
}


launcher_start()
{
	frag_start = getent( "frag_start", "targetname" );
	level.player setOrigin( frag_start.origin );
	level.player setPlayerAngles( frag_start.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("usp");
	level.player switchtoWeapon("g36c");
	
	flag_set ( "spawn_frags" );
	wait .1;
	thread launcherTraining();
}

launcherTraining()
{
	level notify ( "launcherTraining_begin" );
	autosave_by_name( "launcher_training" );
	
	flag_set ( "spawn_launcher" );
	
	level.newcastle setgoalnode ( getnode ( "watch_table_node", "script_noteworthy" ) );
	//level.newcastle thread walk_to ( getnode ( "watch_table_node", "script_noteworthy" ) );
	
	//Now let's try something with a little more 'mojo'. I don't know how much experience you've got with demolitions, so just do as I say, all right?
	//level.newcastle execDialog( "moremojo" );	
	
	if ( !level.player hasWeapon( "m203_m4" ) )
	{
		//Come back here and pick up this grenade launcher.
		level.newcastle execDialog( "pickuplauncher" );	
	}
		
	flag_trigger_init( "launcher_wall_target", getEnt( "launcher_wall_trigger", "script_noteworthy" ) );

	registerObjective( "obj_launcher", "Pick up the rifle with the grenade launcher attachment.", getEnt( "obj_frag_ammo", "targetname" ) );
	setObjectiveState( "obj_launcher", "current" );

	thread keyHint( "swap_launcher" );

	while ( !level.player hasWeapon( "m203_m4" ) )
		wait ( 0.05 );
	clear_hints();
	thread M203_icon_hint();
	RefreshHudAmmoCounter();
	
	
	level.player giveMaxAmmo( "m203_m4" );

	setObjectiveString( "obj_launcher", "Return to the safety pit and equip the grenade launcher." );
	setObjectiveLocation( "obj_launcher", getEnt( "safety_pit", "targetname" )  );
	
	//Notice you now have an icon of a grenade launcher on your HUD.
	//level.newcastle execDialog( "icononhud" );	
	
	if ( !( level.player istouching( getEnt( "safety_pit", "targetname" ) ) ) )
	{
		//Now get back into the safety pit.
		level.newcastle execDialog( "nowbacktopit" );	
	}
	getEnt( "safety_pit", "targetname" ) waittill ( "trigger" );
	
	//level.newcastle thread walk_to( getnode ( "watch_pit_node", "script_noteworthy" ) );
	level.newcastle setgoalnode ( getnode ( "watch_pit_node", "script_noteworthy" ) );
	
	if ( !(level.player getCurrentWeapon() == "m203_m4") )
	{
		//Equip the grenade launcher.
		level.newcastle execDialog( "equiplauncher" );
		thread keyHint( "firemode" );
		RefreshHudAmmoCounter();
	}
	
	while ( !(level.player getCurrentWeapon() == "m203_m4") )
	{
		thread keyHint( "firemode" );
		wait ( 1.0 );
	}

	clear_hints();

	
	setObjectiveString( "obj_launcher", "Fire at the wall with the number one on it." );
	setObjectiveLocation( "obj_launcher", getEnt( "safety_pit", "targetname" )  );
	wait ( 0.1 );

	//Fire at the wall with the number one on it.
	level.newcastle execDialog( "firewall1" );	
	
	if( level.Console )
		thread keyHint( "attack" );
	else
		thread keyHint( "pc_attack" );
	
	while ( !flag( "launcher_wall_target" ) )
	{
		//level.player giveMaxAmmo( "m203_m4" );
		wait ( 0.05 );
	}
	clear_hints();
	wait ( 0.1 );

	//Notice it didn't explode.
	level.newcastle execDialog( "didntexplode" );
	
	//As you know, all grenade launchers have a minimum safe arming distance.
	level.newcastle execDialog( "safearming" );	
	
	//The grenade wont explode unless it travels that distance.
	//level.newcastle execDialog( "wontexplode" );	
	
	//Right. Now pop a grenade in each window, five, six and seven.
	level.newcastle thread execDialog( "56and7" );	
	
	thread launcher_trigger_think( "launcher_target_1", getEnt( "launcher_damage_trigger1", "targetname" ) );
	thread launcher_trigger_think( "launcher_target_2", getEnt( "launcher_damage_trigger2", "targetname" ) );
	thread launcher_trigger_think( "launcher_target_3", getEnt( "launcher_damage_trigger3", "targetname" ) );


	setObjectiveString( "obj_launcher", "Fire your grenade launcher into windows five, six and seven." );

	numRemaining = 0;
	for ( index = 1; index < 4; index++ )
	{
		if ( flag( "launcher_target_" + index ) )
			continue;

		numRemaining++;
	}


	//level.marine5.lastNagTime = getTime();
	while( numRemaining )
	{
		curRemaining = 0;

		nextTarget = "";
		if ( !flag( "launcher_target_1" ) )
		{
			curRemaining++;
			nextTarget = "hittwo";
		}
		if ( !flag( "launcher_target_2" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "hitthree";
		}
		if ( !flag( "launcher_target_3" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "hitfour";
		}

		if ( !curRemaining )
			break;

		//level.player giveMaxAmmo( "m203_m4" );

		if ( curRemaining != numRemaining )
		{
			//level.marine5.lastNagTime = getTime();
		}
		else
		{
			//level.marine5 nagPlayer( nextTarget, 8.0 );
		}

		numRemaining = curRemaining;

		wait ( 0.05 );
	}

	setObjectiveState( "obj_launcher", "done" );

	wait ( 1.0 );
	//level.marine5 execDialog( "oorah" );
	wait ( 1.0 );

	level notify ( "launcherTraining_end" );
	thread c4_Training();
}

M203_icon_hint()
{
	clear_hints();
	//level endon ( "clearing_hints" );
	
	add_hint_background();
	//Notice you now have an icon of a grenade launcher on your HUD.
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	level.hintElem setText( &"KILLHOUSE_HINT_LAUNCHER_ICON" );
	
	iconElem = createIcon( "hud_dpad", 32, 32 );
	iconElem setPoint( "TOP", undefined, 0, 165 );
	
	iconElem2 = createIcon( "hud_icon_40mm_grenade", 32, 32 );
	iconElem2 setPoint( "TOP", undefined, 0, 195 );	
	
	level waittill ( "clearing_hints" );

	iconElem setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	iconElem scaleovertime(1, 20, 20);
	iconElem2 scaleovertime(1, 20, 20);
	
	wait .70;
	iconElem fadeovertime(.15);
	iconElem.alpha = 0;
	
	iconElem2 fadeovertime(.15);
	iconElem2.alpha = 0;
	wait .5;
	
	//clear_hints();
}



explosives_start()
{
	c4_start = getent( "c4_start", "targetname" );
	level.player setOrigin( c4_start.origin );
	level.player setPlayerAngles( c4_start.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("m4_grenadier");
	level.player switchtoWeapon("m4_grenadier");
	
	flag_set ( "spawn_frags" );
	//mp5 = spawn ( "weapon_mp5", c4_start.origin );
	
	wait .1;
	thread c4_Training();
}

c4_Training()
{
	level notify ( "explosivesTraining_begin" );
	autosave_by_name( "c4_training" );
	
	pickupTrigger = flag_trigger_init( "explosives_pickup", getEnt( "c4_pickup", "targetname" ) );
	C4_models = getEntArray( pickupTrigger.target, "targetname" );
	
	pickupTrigger setHintString (&"KILLHOUSE_C4_PICKUP");
	pickupTrigger trigger_on();
	for ( i = 0; i < C4_models.size; i++ )
		C4_models[ i ] show();

	registerObjective( "obj_c4", "Pick up the C4 explosive.", pickupTrigger );
	setObjectiveState( "obj_c4", "current" );

	//Come back around and pick up some C4 off the table.
	level.newcastle thread execDialog( "c4offtable" );

	//level.newcastle thread walk_to ( getnode ( "watch_c4_node", "script_noteworthy" ) );
	level.newcastle setgoalnode ( getnode ( "watch_c4_node", "script_noteworthy" ) );
	
	thread keyHint( "swap_explosives" );

	while ( !flag( "explosives_pickup" ) )
		wait ( 0.05 );
		
	for ( i = 0; i < C4_models.size; i++ )
		C4_models[ i ] hide();
	pickupTrigger trigger_off();
	old_weapon = level.player GetCurrentWeapon ();
	level.player giveWeapon("c4");
	level.player SetWeaponAmmoClip( "c4", 1 );
	level.player SetActionSlot( 4, "weapon" , "c4" );
	
	thread C4_icon_hint();
	RefreshHudAmmoCounter();
	thread flag_when_c4_thrown();
	
	wait .5;
	
	if ( !(level.player getCurrentWeapon() == "c4") )
	{
		level.newcastle execDialog( "equipc4" );	//Equip the C4, Soap.
		//thread keyHint( "equip_C4" );
		level notify ( "c4_equiped" );
		level.hintElem setText( &"KILLHOUSE_HINT_EQUIP_C4" );
		RefreshHudAmmoCounter();
	}
	
	while ( !(level.player getCurrentWeapon() == "c4") )
	{
		wait ( 1.0 );
	}
	
	
	flag_set ( "c4_equiped" );
	level.hintbackground destroy();
	double_line = true;
	add_hint_background( double_line );
	level.hintElem setText( &"KILLHOUSE_HINT_HUD_CHANGES" );
	RefreshHudAmmoCounter();
	//thread hint( &"KILLHOUSE_HINT_HUD_CHANGES", 9999 );
	
	//It seems my ex-wife was kind enough to donate her car to furthering your education Soap.
	level.newcastle execDialog( "exwifecar" );
	
	setObjectiveLocation( "obj_c4", getEnt( "c4_target", "targetname" )  );
	
	level notify ( "C4_the_car" );
	
	if ( !flag ( "c4_thrown" ) )
		level.newcastle execDialog( "throwc4car" );	//Throw some C4 on the car.
	
	if ( !flag ( "near_car" ) )
	{
		//thread hint( &"KILLHOUSE_HINT_APPROACH_C4_THROW", 9999 );
		level.hintbackground destroy();
		add_hint_background();
		level.hintElem setText( &"KILLHOUSE_HINT_APPROACH_C4_THROW" );
	}
	
	flag_wait ( "near_car" );
	
	if ( !flag ( "c4_thrown" ) )
		keyHint( "throw_C4" );
	
	flag_wait ( "c4_thrown" );
	
	wait .5;
	
	//Sgt Newcastle - When planting C4 is your objective, you will see a glowing marker in the world that indicates where to plant it.
	//thread add_dialogue_line( "newcastle", "When planting C4 is your objective, you will see a glowing marker in the world that indicates where to plant it." );
	double_line = true;
	thread hint( &"KILLHOUSE_C4_OBJECTIVE", 9999, double_line );
	wait 4;
	
	//Place the C4 on the indicated spot.
	level.newcastle thread execDialog( "placec4" );
	
	c4_target = getent( "c4_target", "targetname" );
	c4_target maps\_c4::c4_location( undefined, undefined, undefined, c4_target.origin );
	level thread do_in_order( ::waittill_msg, "c4_in_place", ::flag_set, "C4_planted" );

	wait ( 1.0 );
	
	setObjectiveString( "obj_c4", "Plant the C4 explosive at the glowing spot." );
	setObjectiveLocation( "obj_c4", c4_target  );
	//thread keyHint( "plant_explosives" );
	
    flag_wait ( "C4_planted" );
	
	c4_target thread force_detonation();
	
	clear_hints();

	setObjectiveState( "obj_c4", "done" );
	
	//level.newcastle execDialog( "morec4" );	//Go get some more C4 from the table.
	//level.newcastle execDialog( "behindwall" );	//Now come over here behind the safety wall.
	
	if( !flag( "car_destroyed" ) )
		level.newcastle execDialog( "safedistance" );	//Now get to a safe distance from the explosives.
	
	
	while ( ( distance( c4_target.origin, level.player.origin ) <= 256 ) && !flag( "car_destroyed" ) )
		wait 0.05;
	
	if( !flag( "car_destroyed" ) )
	{
		level.newcastle execDialog( "fireinhole" );	//Fire in the hole!
		thread keyHint( "detonate_C4", 9999 );
	}
	
	flag_wait ( "car_destroyed" );
	thread switch_in_two( old_weapon );
	
	clear_hints();
	
	setObjectiveState( "obj_c4", "done" );
	
	thread C4_complete_dialog();
	
	level notify ( "explosivesTraining_end" );
	thread obstacle_Training();
}

switch_in_two( old_weapon )
{
	wait 2;	
	level.player SwitchToWeapon ( old_weapon ); 
}

force_detonation()
{
	self waittill ( "c4_detonation" );
	
	wait .05; //destructable cars can only take damage from one source per frame
	
	car = getent ( "destructible", "targetname" );
	car destructible_force_explosion();
}

flag_when_c4_thrown()
{
	while (1)
	{
		level.player waittill ( "grenade_fire", grenade );
	
		if (level.player getCurrentWeapon() == "c4")
		{
			flag_set ( "c4_thrown" );
			return;
		}
	}
}


C4_icon_hint()
{
	clear_hints();
	level endon ( "clearing_hints" );


	add_hint_background();
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	level.hintElem setText( &"KILLHOUSE_HINT_C4_ICON" );
	//level.hintElem endon ( "death" );

	level.iconElem = createIcon( "hud_dpad", 32, 32 );
	level.iconElem setPoint( "TOP", undefined, -16, 175 );
	
	level.iconElem2 = createIcon( "hud_icon_c4", 32, 32 );
	level.iconElem2 setPoint( "TOP", undefined, 16, 175 );

	level waittill ( "c4_equiped" );

	level.iconElem3 = createIcon( "hud_arrow_right", 24, 24 );
	level.iconElem3 setPoint( "TOP", undefined, -16, 179 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;

	level waittill ( "C4_the_car" );
	
	
	level.iconElem setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	level.iconElem2 scaleovertime(1, 20, 20);
	level.iconElem3 scaleovertime(1, 15, 15);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.15);
	level.iconElem3.alpha = 0;
	
	level.iconElem destroy();
	level.iconElem2 destroy();
	level.iconElem3 destroy();
}

C4_complete_dialog()
{
	level.newcastle execDialog( "chuckle" );	//< satisfied chuckling > 
	level.newcastle execDialog( "muchimproved" );	//Much improved.
	
	if ( ! flag ( "start_obstacle" ) )
		level.newcastle execDialog( "passedeval" ); //All right Soap, you passed the weapons evaluation.
		
	if ( ! flag ( "start_obstacle" ) )
		level.newcastle execDialog( "reporttomac" ); //Now report to Mac on the obstacle course.	
		
	if ( ! flag ( "start_obstacle" ) )
		level.newcastle execDialog( "thrilledtosee" ); //I’m sure he'll be thrilled to see you.	
		
	//level.newcastle execDialog( "justbetween" ); //Just between you and me, he's a real arsehole.	
	//level.newcastle execDialog( "goodluck" ); //Good luck!	
}


obstacle_start()
{
	
	start_obstacle_course = getent( "start_obstacle_course", "targetname" );
	level.player setOrigin( start_obstacle_course.origin );
	level.player setPlayerAngles( start_obstacle_course.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("m4_grenadier");
	level.player switchtoWeapon("m4_grenadier");
	
	flag_set ( "spawn_frags" );
	
	thread obstacle_Training();
}

obstacle_Training()
{
	level notify ( "obstacleTraining_start" );
	
	registerObjective( "obj_obstacle", "Run the obstacle course.", getEnt( "obstacleTraining_objective", "targetname" ) );
	setObjectiveState( "obj_obstacle", "current" );
	
	getEnt( "obstacle_course_start", "targetname" ) waittill ( "trigger" );	

	flag_set ( "start_obstacle" );

	flag_trigger_init( "prone_entered", getEnt( "obstacleTraining_prone", "targetname" ) );
	thread obstacleTraining_buddies();
	
	thread obstacleTraining_dialog();

	flag_wait( "start_course" );
	
	setObjectiveLocation( "obj_obstacle", getEnt( "obj_course_end", "targetname" )  );
	
	move_mac_triggers = getentarray( "move_mac", "targetname" );
	array_thread( move_mac_triggers, ::move_mac );
	
	getEnt( "obstacleTraining_mantle", "targetname" ) waittill ( "trigger" );
	thread keyHint( "mantle", 5.0 );

	flag_wait( "obstacleTraining_crouch" );
	thread keyHint( "crouch" );

	flag_wait( "obstacleTraining_mantle2" );
	thread keyHint( "mantle", 5.0 );
	
	flag_wait( "prone_entered" );
	thread keyHint( "prone" );

	getEnt( "obstacleTraining_Standup", "targetname" ) waittill ( "trigger" );
	thread keyHint( "stand", 5.0 );
	clear_hints_on_stand();

	wait .1;
	
	keyHint( "sprint" ); //player must sprint
	flag_set ( "player_sprinted" );
	
	if( !flag( "obstacle_course_end" ) )
		thread second_sprint_hint();
	
	flag_wait( "obstacle_course_end" );
	setObjectiveState( "obj_obstacle", "done" );
	//clear_hints();
	
	thread report_to_price();
}

second_sprint_hint()
{
	level endon ( "obstacle_course_end" );
	//getEnt( "obstacleTraining_sprint", "targetname" ) waittill ( "trigger" );

	wait .5;
	actionBind = getActionBind( "sprint2" );
	hint( actionBind.hint, 5 );
}

obstacleTraining_dialog()
{
	level endon( "obstacleTraining_end" );

	//Wellll...it seems Miss Soap here was kind enough to join us!
	level.mac execDialog( "misssoap" );
	
	if( !flag( "start_course" ) )
	{
		//Line up ladies!
		level.mac execDialog( "lineup" );
		flag_set( "start_course" );
	}
	
	//iprintlnbold ( "go!" );
	//level.mac execDialog( "go" );
	level.mac playsound( "killhouse_mcm_go" );
	
	flag_set( "start_course" );
		
	//This isn't a bloody charity walk - get your arses in gear! MOVE!
	level.mac execDialog( "isntcharitywalk" );

	flag_wait( "obstacleTraining_mantle2" );
	
	//Jump over those obstacles!
	level.mac execDialog( "jumpobstacles" );


	//You thought it was going to easier once you passed Selection didn't you? Didn't you?!!!
	//level.mac execDialog( "didntyou" );

	flag_wait( "crawl_dialog" );

	//You crawl like old people screw!
	level.mac execDialog( "youcrawllike" );

	//if( !flag( "obstacle_course_end" ) )
	//{
		//You're all too slow! You're all just too fucking slow!!! You'd be dead by now if this were the real thing!
		//level.mac execDialog( "bedeadbynow" );
	//}

	if( !flag( "obstacle_course_end" ) )
	{
		//I've seen "Sandhurst Commandos" run faster than you lot!
		level.mac execDialog( "commandos" );
	}
	
	if( !flag( "obstacle_course_end" ) )
	{
		//Move move move!!!! What's the matter with you? You all want to be R.T.U'd?
		level.mac execDialog( "bertud" );
	}
	
	flag_wait ( "player_sprinted" );
	flag_wait( "obstacle_course_end" );
	
	//Oi! Soap! Captain Price wants to see you in Hangar 4. You passed my little test, now get out of my sight.
	level.mac execDialog( "passedtest" );

	//The rest of you bloody ponces are going to run it again until I'm no longer embarassed to look at you!
	level.mac execDialog( "runitagain" );
	
	thread loop_obstacle();
}



clear_hints_on_stand()
{
	while (level.player GetStance() != "stand" )
		wait .05;
	clear_hints();
}


move_mac()
{
	self waittill ( "trigger" );
	
	level.mac set_generic_run_anim(  "jog" );
	level.mac setgoalnode ( getnode ( self.target, "targetname" ) );
}

loop_obstacle()
{
	for ( index = 0; index < level.buddies.size; index++ )
	{
		level.mac set_generic_run_anim(  "jog" );
		level.buddies[index] thread obstacleTrainingCourseThink( level.buddies[index].startNode );
	}
	
	level.mac set_generic_run_anim( "walk", true );
	level.mac setgoalnode ( getnode ( "mac_start_node", "targetname" ) );
	level.mac waittill ( "goal" );
	
	//level notify ( "start_course" );
}

obstacleTraining_buddies()
{
	buddiesInit();

	for ( index = 0; index < level.buddies.size; index++ )
	{
		buddy = level.buddies[index];
		buddy.startNode = getNode( "obstacle_lane_node" + buddy.buddyID, "targetname" );

		level.buddies[index] thread obstacleTrainingCourseThink( buddy.startNode );
	}
}

buddiesInit()
{
	level.buddies = getEntArray( "buddy", "script_noteworthy" );
	level.buddiesByID = [];
	for ( index = 0; index < level.buddies.size; index++ )
	{
		level.buddies[index].buddyID = int( level.buddies[index].targetname[5] );
		level.buddiesByID[level.buddies[index].buddyID] = level.buddies[index];
	}
}

obstacleTrainingCourseThink( goalNode )
{
	level endon( "obstacleTraining_end" );

	self.goalradius = 32;
	self setGoalNode( goalNode );
	self waittill ( "goal" );

	flag_wait ( "start_course" );
	
	self.disablearrivals = true;
	while ( isDefined( goalNode.target ) )
	{
		goalNode = getNode( goalNode.target, "targetname" );

		self setGoalNode( goalNode );
		self waittill ( "goal" );

		if ( isDefined( goalNode.script_noteworthy ) && goalNode.script_noteworthy == "prone" )
			self allowedStances( "prone" );
		else if ( isDefined( goalNode.script_noteworthy ) && goalNode.script_noteworthy == "stand" )
			self allowedStances( "prone", "stand", "crouch" );
		else if ( isDefined( goalNode.script_noteworthy ) && goalNode.script_noteworthy == "sprint" )
			self.sprint = true;
	}
	self.disablearrivals = false;
}

reveal_start()
{
	start_reveal = getent( "start_reveal", "targetname" );
	level.player setOrigin( start_reveal.origin );
	level.player setPlayerAngles( start_reveal.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("m4_grenadier");
	level.player switchtoWeapon("m4_grenadier");
	
	thread report_to_price();
}

report_to_price()
{
	wait .1;
	registerObjective( "obj_price", "Report to Cpt. Price.", getEnt( "obj_price", "targetname" ) );
	setObjectiveState( "obj_price", "current" );
	
	flag_set ( "obstacle_complete" );
	
	level.price	gun_remove();
	
	SAS_blackkits = getentarray ( "SAS_blackkit", "targetname" );
	sas1 = getent ( "sas1" , "script_noteworthy" );
	sas2 = getent ( "sas2" , "script_noteworthy" );
	sas3 = getent ( "sas3" , "script_noteworthy" );
	
	sas1.animname = "sas1";
	sas2.animname = "sas2";
	sas3.animname = "sas3";
	
	node = getent ( "reveal_node", "targetname" );
	//node thread maps\_debug::drawOriginForever ();
	
	//node thread anim_reach_and_idle( SAS_blackkits, "reveal", "reveal_idle", "start_reveal_anim" );
	
	
	flag_wait ( "open_ship_hanger" );
	
	thread do_in_order( ::flag_wait, "at_ladder", ::hint, &"KILLHOUSE_HINT_LADDER" );
	
	hangerdoor = getent ( "ship_hanger_door" , "targetname" );
	//hangerdoor moveX( 380, 8, .3, 0 );
	hangerdoor moveX( 150, 8, .3, 0 );
	
	node notify ( "start_reveal_anim" );
	thread reveal_dialog( sas2 );
	node thread reveal_anims ( SAS_blackkits );
	
	
	flag_wait ( "on_ladder" );
	node notify ( "end_idle" );
	level.price animscripts\shared::placeWeaponOn( level.price.weapon, "right" );
	
	//flag_wait ( "reveal_dialog_done" );
	
	thread cargoship_training();
}

reveal_anims( SAS_blackkits )
{
	self anim_single( SAS_blackkits, "reveal" );
	
	if ( !flag ( "on_ladder" ) )
		self thread anim_loop( SAS_blackkits, "reveal_idle", undefined, "end_idle");
		
}

reveal_dialog( sas2 )
{
	wait 4;
	//thread add_dialogue_line( "Misc SAS", "Its the fingy sir." );
	sas2 execDialog ( "fingy" ); //It's the fingy sir.	
	wait .3;
	//Ah, good to have you on board Soap. Welcome to the Regiment.
	level.price execDialog( "welcome" );	
	
	//"Soap, it's your turn for the CQB test. Everyone else head to observation."
	level.price execDialog( "cbqtest" );
	
	//"For this test, you'll have to run the cargoship solo in less than 60 seconds." 
	level.price execDialog( "runsolo" );
	
	//"Gaz holds the current squadron record at 25 seconds. Good luck." 
	level.price execDialog( "record19sec" );
	
	if ( !flag ( "at_ladder" ) )
		level.price execDialog( "ladderthere" );	//Climb the ladder over there.
		
	setObjectiveLocation( "obj_price", getent( "top_of_ladder_trigger", "targetname" ) );
	
	flag_set ( "reveal_dialog_done" );
}


/*
level.price execDialog( "startover" );	//That was too slow, come back to the ladder and start over.
level.price execDialog( "doitagain" );	//Soap, that was way too slow. Do it again.
*/


cargoship_start()
{
	
	start_pre_rope = getent( "start_pre_rope", "targetname" );
	level.player setOrigin( start_pre_rope.origin );
	level.player setPlayerAngles( start_pre_rope.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("m4_grenadier");
	level.player switchtoWeapon("m4_grenadier");
	
	registerObjective( "obj_price", "Report to Cpt. Price.", getEnt( "obj_price", "targetname" ) );
	setObjectiveState( "obj_price", "current" );
	
	thread cargoship_training();
}

cargoship_training()
{
	cargoship_targets = getentarray( "cargoship_target", "script_noteworthy" );
	array_thread( cargoship_targets, ::cargoship_targets );
	thread rope();
	top_of_rope_trigger = getent( "top_of_rope_trigger", "targetname" );
	near_rope = getent( "near_rope", "targetname" );
	top_of_rope = getent( "top_of_rope", "targetname" );
	top_of_ladder_trigger = getent( "top_of_ladder_trigger", "targetname" );
	position_one = getent( "position_one", "targetname" );
	two = getent( "position_two", "targetname" );
	three = getent( "position_three", "targetname" );
	four = getent( "position_four", "targetname" );
	five = getent( "position_five", "targetname" );
	six = getent( "position_six", "targetname" );
	finish = getent( "finish", "targetname" );
	
	volume = getent( three.script_noteworthy, "targetname" );
	volume2 = getent( six.script_noteworthy, "targetname" );
	first_time = true;
	
	flash_volumes = getentarray ( "flash_volume", "script_noteworthy" );
	jump_off_trigger = getent ( "jump_off_trigger", "targetname" );
	
	setObjectiveString( "obj_price", "Climb the ladder." );
	setObjectiveLocation( "obj_price", top_of_ladder_trigger );
	
	flag_wait( "at_top_of_ladder" );
	clear_hints(); //remove ladder hint
	thread autosave_by_name( "ladder_top" );
	
	while ( 1 )
	{
		jump_off_trigger thread jumpoff_monitor();
		
		if ( first_time )
		{
			//"Pick up that MP5 and four flashbangs." );
			level.price thread execDialog( "pickupmp5" );
			setObjectiveString( "obj_price", "Equip the MP5 and pick up 4 flashbangs." );
			setObjectiveLocation( "obj_price", getent( "obj_flashes", "targetname" ) );
		}
		else
		{
			//"Replace any flash bangs you used." 
			level.price thread execDialog( "replaceflash" );
			if ( !(level.player getCurrentWeapon() == "mp5") )
			{
				//"Equip your MP5." 
				level.price thread execDialog( "equipmp5" );
			}
		}
		
		nag_time = 0;
		while ( !(level.player getCurrentWeapon() == "mp5") )
		{
			if ( (level.player istouching ( near_rope ) ) && ( nag_time > 4 ) )
			{
				//"Soap. Equip your MP5." );
				level.price thread execDialog( "soapequipmp5" );
				nag_time = 0;
			}
			wait ( 1.0 );
			nag_time++;
		}
		
		nag_time = 0;
		while ( level.player GetWeaponAmmoStock( "flash_grenade" ) < 4 )
		{
			if ( (level.player istouching ( near_rope ) ) && ( nag_time > 4 ) )
			{
				level.price thread execDialog( "soap4flash" );
				//"Soap. Pick up four flash bangs." );
				nag_time = 0;
			}
			wait ( 1.0 );
			nag_time++;
		}
		if ( first_time )
			flag_set ( "got_flashes" );
		
		setObjectiveString( "obj_price", "Slide down the rope." );
		setObjectiveLocation( "obj_price", top_of_rope );
			
		if ( first_time )
		{
			level.price execDialog( "ropedeck" );	//On my go, I want you to rope down to the deck and rush to position 1.
			level.price execDialog( "stormstairs" );	//After that you will storm down the stairs to position 2.
			level.price execDialog( "hit3and4" );	//Then hit position 3 and 4 following my precise instructions at each position.
		}

		//"Grab the rope when your ready."
		level.price thread execDialog( "grabrope" );
		
		level notify ( "activate_rope" );
		thread autosave_by_name( "starting_bridge_attack" );
		
		level waittill ( "starting_rope" );
		
		setObjectiveString( "obj_price", "Clear the cargoship bridge mock-up." );
		setObjectiveLocation( "obj_price", position_one );
		
		level.price thread execDialog( "gogogo" );	//Go go go!
		
		thread startTimer( 60 );
		thread accuracy_bonus();
		if ( isdefined ( level.IW_deck ) )
			level.IW_deck destroy();
		thread flashbang_ammo_monitor ( flash_volumes );
		
		position_one wait_till_pos_cleared();
		
		setObjectiveLocation( "obj_price", two );
		level.price thread execDialog( "position2" );	//Position 2 go!
		
		two wait_till_pos_cleared();
			
		level.price thread execDialog( "position3" );	//Go to Position 3!
		setObjectiveLocation( "obj_price", three );
		
		//three wait_till_pos_cleared();
		three thread flash_dialog( volume );
		three wait_till_flashed( volume );
			
		level.price thread execDialog( "position4" );	//Position 4!
		setObjectiveLocation( "obj_price", four );
		
		four wait_till_pos_cleared();
			
		setObjectiveLocation( "obj_price", five );
		//"Position five go!!" );
		level.price thread execDialog( "5go" );
		
		five wait_till_pos_cleared();
			
		setObjectiveLocation( "obj_price", six );
		//"Six go!!" );
		level.price thread execDialog( "6go" );
		
		six thread flash_dialog( volume2 );
		six wait_till_flashed( volume2 );
		six wait_till_pos_cleared();
			
		setObjectiveLocation( "obj_price", finish );
		//"Final position go!!" );
		level.price thread execDialog( "finalgo" );
		
		finish waittill ( "trigger" );
		
		level notify ( "test_cleared" );
		if ( first_time )
			thread debrief();
		first_time = false;
		//flag_set ( "start_deck" );
		killTimer( 16.3, false );
		
		//"Pretty good, Soap. But I've seen better." );
		level.price execDialog( "seenbetter" );
		
		//"Climb up the ladder if you want another go." );
		level.price execDialog( "anothergo" );
		
		//thread add_dialogue_line( "price", "Otherwise go over to the second CBQ course." );//new
		
		//"Otherwise come over to the monitors for a debrief." );
		level.price execDialog( "debrief" );
		
		clear_hints();
		setObjectiveState( "obj_price", "done" );

		top_of_ladder_trigger waittill ( "trigger" );
	}
}



debrief()
{
	debrief_trigger = getent( "debrief_trigger", "targetname" );
	registerObjective( "obj_debrief", "Debrief with Cpt. Price.", debrief_trigger );
	setObjectiveState( "obj_debrief", "current" );
	
	debrief_trigger waittill ( "trigger" );
	setObjectiveState( "obj_debrief", "done" );
	level.price execDialog( "goodjob" );	//Good job Soap. It appears you may have earned that winged dagger after all. Now get ready to deploy for the cargoship operation. We go 'wheels up' in twenty minutes.
	wait 1;
	missionsuccess( "cargoship", false );	
}


deck_start()
{	
	deck_start = getent( "deck_start", "targetname" );
	level.player setOrigin( deck_start.origin );
	level.player setPlayerAngles( deck_start.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("mp5");
	level.player switchtoWeapon("mp5");
	
	flag_set ( "start_deck" );
}



deck_training()
{
	deck_targets = getentarray( "deck_target", "script_noteworthy" );
	array_thread( deck_targets, ::cargoship_targets );

	flag_wait ( "start_deck" );
	registerObjective( "obj_deck", "Complete the deck mock-up.", getent( "area_two_one", "targetname" ) );	
	setObjectiveState( "obj_deck", "current" );
	
	one = getent( "area_two_one", "targetname" );
	two = getent( "area_two_two", "targetname" );
	three = getent( "area_two_three", "targetname" );
	four = getent( "area_two_four", "targetname" );
	five = getent( "area_two_five", "targetname" );
	finish = getent( "area_two_finish", "targetname" );
	first_time = true;
	
	while ( 1 )
	{
		one waittill ( "trigger" );
		thread add_dialogue_line( "price", "Get ready..." );
		wait 2;
		thread add_dialogue_line( "price", "Go go go!!" );
		thread accuracy_bonus();
		thread startTimer( 60 );
		if ( isdefined ( level.IW_best ) )
			level.IW_best destroy();
		thread autosave_by_name( "starting_deck_attack" );
		
		one pop_up_and_wait();
		level.price thread execDialog( "position2" );	//Position 2 go!
		setObjectiveLocation( "obj_deck", two );
		two pop_up_and_wait();
		level.price thread execDialog( "position3" );	//Go to Position 3!
		setObjectiveLocation( "obj_deck", three );
		three pop_up_and_wait();
		level.price thread execDialog( "position4" );	//Position 4!
		setObjectiveLocation( "obj_deck", four );
		four pop_up_and_wait();
		thread add_dialogue_line( "price", "Position five go!!" );
		setObjectiveLocation( "obj_deck", five );
		five pop_up_and_wait();
		thread add_dialogue_line( "price", "Final position go!!" );
		setObjectiveLocation( "obj_deck", finish );
		
		finish waittill ( "trigger" );
		
		level notify ( "test_cleared" );
		killTimer( 15.85, true );
		setObjectiveState( "obj_deck", "done" );
		thread add_dialogue_line( "price", "Not bad, but not that good either." );
		thread add_dialogue_line( "price", "Go back to position one if you want try for a better time." );
		thread add_dialogue_line( "price", "Otherwise come over to the monitors for a debrief." );
		
		if ( first_time )
			thread debrief();
		first_time = false;
	}
}


get_randomized_targets()
{
	tokens = strtok( self.script_linkto, " " );
	targets = [];
	for ( i=0; i < tokens.size; i++ )
	{
		token = tokens[ i ];
		target = getent( token, "script_linkname" );
		if ( isdefined( target ) )
		{
			targets = add_to_array( targets, target ); 
			continue;
		}
	}
	targets = array_randomize( targets );
	return targets;
}

pop_up_and_wait()
{
	self waittill ( "trigger" );
	
	deck_targets = self get_randomized_targets();
	
	targets_needed = 0;
	level.targets_hit = 0;
	friendlies_up = [];
	j = 0;
	
	for ( i = 0; targets_needed < 3; i++ )
	{
		wait randomfloatrange (.25, .4);
		deck_targets[ i ] notify ( "pop_up" );
		if ( deck_targets[ i ].targetname == "hostile" )
			targets_needed++;
		else
		{
			friendlies_up[ j ] = deck_targets[ i ];
			j++;
		}
	}
	
	//level.price thread execDialog( "hittargets" );	//Hit the targets!
			
	while ( level.targets_hit != targets_needed )
		wait ( .05 );
			
	if ( friendlies_up.size > 0 )
	{
		for ( k = 0; k < friendlies_up.size; k++ )
			friendlies_up[ k ] notify ( "pop_down" );
	}
}


jumpoff_monitor()
{
	level endon ( "starting_rope" );
	self waittill ( "trigger" );
		
	level notify ( "mission failed" );	
	setDvar("ui_deadquote", &"KILLHOUSE_SHIP_JUMPED_TOO_EARLY");
	maps\_utility::missionFailedWrapper();	
}

flashbang_ammo_monitor ( flash_volumes )
{
	level endon ( "test_cleared" );
	level.volumes_flashed = 0;
	
	while ( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		
		grenade waittill ( "death" );
		waittillframeend;
		
		flashes_needed = flash_volumes.size - level.volumes_flashed;
		if ( ( level.player GetWeaponAmmoStock( "flash_grenade" ) ) < flashes_needed )
		{
			level notify ( "mission failed" );	
			setDvar("ui_deadquote", &"KILLHOUSE_SHIP_OUT_OF_FLASH");
			maps\_utility::missionFailedWrapper();	
		}
	}
}


check_if_in_volume( tracker, volume )
{
	self waittill ( "death" );
	if ( tracker istouching ( volume ) )
	{
		volume notify ( "flashed" );
		level.volumes_flashed++;
	}
}

track_grenade_origin( tracker, volume )
{
	self endon ( "death" );
	volume endon ( "flashed" );
	while ( 1 )
	{
		tracker.origin = self.origin;
		wait .05;
	}
}

flash_dialog( volume )
{
	volume endon ( "flashed" );
	self waittill ( "trigger" );
	
	while( 1 )
	{
		level.price thread execDialog( "flashthrudoor" );	//Flashbang through the door!
		thread keyHint( "flash" );
		//thread add_dialogue_line( "price", "Flash the room!!" );
		wait 5;
	}
}

wait_till_flashed( volume )
{	
	volume endon ( "flashed" );
	assert ( isdefined ( volume ) );
	
	
	while ( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		if ( weaponname == "flash_grenade" )
		{
			tracker = spawn ("script_origin", (0,0,0));
			grenade thread track_grenade_origin( tracker, volume );
			grenade thread check_if_in_volume( tracker, volume );
		}
	}
}


wait_till_pos_cleared()
{	
	self waittill ( "trigger" );
	
	level.targets_hit = 0;
	if ( isdefined ( self.target ) )
	{
		targets = getentarray( self.target, "targetname" );

		for ( i = 0; i < targets.size; i++ )
			targets[ i ] notify ( "pop_up" );
		
		level.price thread execDialog( "hittargets" );	//Hit the targets!
		time_waited = 0;
		
		while ( level.targets_hit != targets.size )
		{
			if ( time_waited > 3 )
			{
				level.price thread execDialog( "hittargets" );	//Hit the targets!
				//thread add_dialogue_line( "price", "Shoot the other target." );
				//thread add_dialogue_line( "price", "Shoot the remaining targets." );
				//thread add_dialogue_line( "price", "Hit other targets." );
				time_waited = 0;
			}
			time_waited += 0.05;
			wait ( .05 );
		}
	}
	return;
}



rope()
{
	top_of_rope_trigger = getent( "top_of_rope_trigger", "targetname" );
	top_of_rope_trigger trigger_off();
	top_of_rope = getent( "top_of_rope", "targetname" );
	bottom_of_rope = getent( "bottom_of_rope", "targetname" );
	
	while ( 1 )
	{
	
		level waittill ( "activate_rope" );
		
		top_of_rope_trigger trigger_on();
		top_of_rope_trigger setHintString (&"KILLHOUSE_USE_ROPE");
		
		top_of_rope_trigger waittill ( "trigger" );
		level notify ( "starting_rope" );
		level.player DisableWeapons();
		
		tag_origin = spawn("script_model", top_of_rope.origin + (0,0,-60) );
		tag_origin.angles = top_of_rope.angles;
		tag_origin setmodel("tag_origin");
		
		//lerp_player_view_to_tag( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
		tag_origin lerp_player_view_to_tag( "tag_origin", .2, .2, 45, 45, 30, 30 );
		
		rope_time = 1.5;
		tag_origin moveto ( bottom_of_rope.origin + (0,0,-60), rope_time, 1, .2 );
		wait rope_time;
		tag_origin delete();
		
		level.player EnableWeapons();
		top_of_rope_trigger trigger_off();
	}
}



fail_if_damage_waiter()
{
	self endon ( "pop_down" );
	self waittill ( "damage", amount, attacker, direction_vec, point, cause );
	
	setDvar("ui_deadquote", &"KILLHOUSE_HIT_FRIENDLY");
	maps\_utility::missionFailedWrapper();
}



set_up_timer()
{
	self.alignX = "left";
	self.alignY = "middle";
	self.horzAlign = "right";
    self.vertAlign = "top";
    self.x = -225;
    self.y = 110;
    
  	self.fontScale = 1.6;
	self.color = (0.8, 1.0, 0.8);
	self.font = "objective";
	self.glowColor = (0.3, 0.6, 0.3);
	self.glowAlpha = 1;

 	self.hidewheninmenu = true;
}


// ****** Get the timer started ****** //
startTimer( timelimit )
{
// destroy any previous timer just in case ****** //
	if (isdefined (level.timer) )
		level.timer destroy();
	if (isdefined (level.bonus) )
		level.bonus destroy();
	if (isdefined (level.label) )
		level.label destroy();
	if (isdefined (level.IW_best) )
		level.IW_best destroy();
// destroy timer and thread if objectives completed within limit ****** //
	level endon ( "kill_timer" );
	
	level.hudTimerIndex = 20;

	level.start_time = gettime();
// Timer size and positioning ****** //	
	level.timer = newHudElem();
	level.timer set_up_timer();
  		
	level.timer.label = &"KILLHOUSE_YOUR_TIME";
	level.timer settenthstimerUp( .05 );

// Wait until timer expired
	wait ( timelimit );
	//flag_set ( "timer_expired" );

// Get rid of HUD element and fail the mission 
	level.timer destroy();	
	
	level thread mission_failed_out_of_time();
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );

	level notify ( "mission failed" );	
	setDvar("ui_deadquote", &"KILLHOUSE_SHIP_TOO_SLOW");
	maps\_utility::missionFailedWrapper();	
}

killTimer( best_time, deck )	
{
	level notify ( "kill_timer" );
	if (isdefined (level.timer))
		level.timer destroy();
	if (isdefined (level.bonus))
		level.bonus destroy();
	if (isdefined (level.label))
		level.label destroy();
	time = ( ( gettime() - level.start_time ) / 1000 );
	level.timer = newHudElem();
	level.timer set_up_timer();
	level.timer.label = &"KILLHOUSE_YOUR_FINAL_TIME";
	
	level waittill ( "accuracy_bonus" );
	final_time = time - level.bonus_time;
	//iprintlnbold ( "time: " +  time );
	level.timer setValue ( final_time );
	
	level.IW_best = newHudElem();
	level.IW_best set_up_timer();
	level.IW_best.y = 125;
	level.IW_best.label = &"KILLHOUSE_IW_BEST_TIME";
	level.IW_best setValue ( best_time );
	
	/*
	level.label = newHudElem();
	level.label set_up_timer();
	level.label.y = 70;
	if ( deck )
		level.label.label = &"KILLHOUSE_DECK_LABEL";
	else
		level.label.label = &"KILLHOUSE_SHIP_LABEL";
	*/
}

accuracy_bonus()
{
	guns = level.player GetWeaponsListPrimaries();
	gun0 = level.player GetWeaponAmmoStock( guns[0] );
	gun1 = level.player GetWeaponAmmoStock( guns[1] );
	gunc0 = level.player GetWeaponAmmoClip( guns[0] );
	gunc1 = level.player GetWeaponAmmoClip( guns[1] );
	starting_ammo = gun0 + gun1 + gunc0 + gunc1;
	//iprintlnbold ( "starting_ammo " +  starting_ammo );
	
	level waittill ( "test_cleared" );
	
	gun0 = level.player GetWeaponAmmoStock( guns[0] );
	gun1 = level.player GetWeaponAmmoStock( guns[1] );
	gunc0 = level.player GetWeaponAmmoClip( guns[0] );
	gunc1 = level.player GetWeaponAmmoClip( guns[1] );
	ending_ammo = gun0 + gun1 + gunc0 + gunc1;
	//iprintlnbold ( "ending_ammo " +  ending_ammo );
	
	used = starting_ammo - ending_ammo;
	//iprintlnbold ( "ammo used: " +  used );

	level.bonus = newHudElem();
	level.bonus set_up_timer();
	level.bonus.y = 95;

	level.bonus_time = ( ( 25 - used ) * .2 ); 
	if ( level.bonus_time <= 0 )
	{
		level.bonus.label = &"KILLHOUSE_ACCURACY_BONUS_ZERO";
		level.bonus_time = 0;
	}
	else
	{
		level.bonus.label = &"KILLHOUSE_ACCURACY_BONUS";
		level.bonus setValue ( level.bonus_time );
	}

	level notify ( "accuracy_bonus" );
}



nagPlayer( nagAnim, minNagTime )
{
	if ( self.speaking )
		return false;

	time = getTime();
	if ( time - self.lastSpeakTime < 1.0 )
		return false;

	if ( time - self.lastNagTime < (minNagTime * 1000) )
		return false;

	self execDialog( nagAnim );
	self.lastNagTime = self.lastSpeakTime;
	return true;
}


scoldPlayer( scoldAnim )
{
	if ( self.speaking )
		return false;

	self execDialog( scoldAnim );
	return true;
}


execDialog( dialogAnim )
{
	//assert( !self.speaking );
	self.speaking = true;
	//self anim_single_solo( self, dialogAnim );
	self anim_single_queue( self, dialogAnim );
	self.speaking = false;
	self.lastSpeakTime = getTime();
}



isADS()
{
	return ( level.player playerADS() > 0.5 );
}






endOfLevel()
{
	wait ( 3.0 );
	iPrintLnBold( "End of currently scripted level." );
	wait ( 3.0 );
	missionsuccess( "cargoship", false );
}



actionNodeThink( actionNode )
{
	assert( isDefined( actionNode.script_noteworthy ) );

	switch( actionNode.script_noteworthy )
	{
		case "ammo_node":
			wait ( 2.0 );
			println( self.buddyID + " leaving" );
		break;
	}
}


getFreeActionNode( curNode )
{
	actionNode = undefined;
	while ( isDefined( curNode.target ) )
	{
		nextNode = getNode( curNode.target, "targetname" );

		if ( isDefined( nextNode.script_noteworthy ) )
		{
			if ( nextNode.inUse )
			{
				if ( !isDefined( actionNode ) )
					return curNode;
				else
					return actionNode;
			}

			actionNode = nextNode;
		}

		curNode = nextNode;
	}
	return actionNode;
}


initActionChain( actionNode )
{
	while ( isDefined( actionNode.target ) )
	{
		actionNode.inUse = false;
		actionNode = getNode( actionNode.target, "targetname" );
	}
}


actionChainThink( startNode )
{
	self setGoalNode( startNode );
	self waittill( "goal" );
	curNode = startNode;
	actionNode = undefined;

	while ( !isDefined( actionNode ) )
	{
		actionNode = getFreeActionNode( curNode );
		wait ( 0.05 );
	}

	while ( isDefined( actionNode ) )
	{
		actionNode.inUse = true;
		while ( curNode != actionNode )
		{
			curNode = getNode( curNode.target, "targetname" );
			self setGoalNode( curNode );
			self waittill ( "goal" );
		}

		self actionNodeThink( actionNode );

		while ( isDefined( actionNode ) && curNode == actionNode )
		{
			actionNode = getFreeActionNode( curNode );
			wait ( randomFloatRange( 0.1, 0.5 ) );
		}
		curNode.inUse = false;
	}

	while( isDefined( curNode.target ) )
	{
		curNode = getNode( curNode.target, "targetname" );
		self setGoalNode( curNode );
		self waittill ( "goal" );
	}
}


raisePlywoodWalls()
{
	plywoodWalls = getEntArray( "plywood", "script_noteworthy" );

	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( 90, 0.25, 0.1, 0.1 );
	}
}


lowerPlywoodWalls()
{
	plywoodWalls = getEntArray( "plywood", "script_noteworthy" );

	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( -90, 0.25, 0.1, 0.1 );
	}
}


raiseTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( targetDummy.raised )
			continue;

		targetDummies[index] thread moveTargetDummy( "raise" );
	}
}

moveTargetDummy( command )
{
	self setCanDamage( false );

	while ( self.moving )
		wait ( 0.05 );

	switch( command )
	{
	case "raise":
		if ( !self.raised )
		{
			self.aim_assist_target enableAimAssist();
			speed = 0.25;
			self playSound( "killhouse_target_up" );
			self.orgEnt rotatePitch( 90, speed, 0.1, 0.1 );
			wait ( 0.25 );
			self.raised = true;
			self.light light_on();

			//if ( self.laneID == 1 )
			//	self enableAimAssist();

			self setCanDamage( true );
		}
		break;

	case "lower":
		if ( self.raised )
		{
			speed = 0.75;
			self.orgEnt rotatePitch( -90, speed, 0.25, 0.25 );
			wait ( 0.75 );
			self.raised = false;
			self.cause = "lower";
			self.light light_off();

			//if ( self.laneID == 1 )
			//	self disableAimAssist();
			self disableAimAssist();

		}
		break;
	}
}

lowerTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( !targetDummy.raised )
			continue;

		targetDummies[index] thread moveTargetDummy( "lower" );
	}
}


training_targetDummies( group )
{
	targetDummies = getTargetDummies( group );
	for ( index = 0; index < targetDummies.size; index++ )
		targetDummies[index] thread targetDummyThink();
}


targetDummyThink()
{
	self.orgEnt = getEnt( self.target, "targetname" );
	assert( isdefined( self.orgEnt ) );

	self linkto (self.orgEnt);

	self.dummyID = int( self.script_label );
	self.laneID = int( self.targetname[4] );
	
	self.aim_assist_target = getEnt( self.orgEnt.target, "targetname" );
	self.aim_assist_target hide();
	self.aim_assist_target notsolid();
	
	self.light = getEnt( self.aim_assist_target.target, "targetname" );

	self.light light_off();
	self.orgEnt rotatePitch( -90, 0.25 );
	self.raised = false;
	self.moving = false;
	self.cause = "";

	for( ;; )
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, cause );
		self notify ( "hit" );
		self.health = 1000;
		level.targets_hit++;

		self playSound( "killhouse_buzzer" );

		self.moving = true;
		self.cause = cause;
		self.aim_assist_target disableAimAssist();
		self setCanDamage( false );
		self.orgEnt rotatePitch( -90, 0.25 );
		wait ( 0.25 );
		self.raised = false;
		self.moving = false;
		self.light light_off();
	}
}



cargoship_targets()
{
	orgEnt = getEnt( self.target, "targetname" );
	assert( isdefined( orgEnt ) );
	
	self linkto (orgEnt);
	//self.origin = orgEnt.origin;
	//self.angles = orgEnt.angles;
	if ( ! isdefined ( orgEnt.script_noteworthy ) )
		orgEnt.script_noteworthy = "standard";
	
	if (orgEnt.script_noteworthy == "reverse" )
		orgEnt rotatePitch( 90, 0.25 );
	else
		orgEnt rotatePitch( -90, 0.25 );
	
	aim_assist_target = getEnt( orgEnt.target, "targetname" );
	aim_assist_target hide();
	aim_assist_target notsolid();
	
	while ( 1 )
	{
		self waittill ( "pop_up" );
		
		wait randomfloatrange (0, .2);
		
		self playSound( "killhouse_target_up" );
		self setCanDamage( true );
		if ( self.targetname != "friendly" )
			aim_assist_target enableAimAssist();
		if (orgEnt.script_noteworthy == "reverse" )
			orgEnt rotatePitch( -90, 0.25 );
		else
			orgEnt rotatePitch( 90, 0.25 );
		wait .25;
		
		if ( self.targetname == "friendly" )
		{
			self fail_if_damage_waiter();
		}
		else
		{
			self waittill ( "damage", amount, attacker, direction_vec, point, cause );
			
			self notify ( "hit" );
			self.health = 1000;
			level.targets_hit++;
			self playSound( "killhouse_buzzer" );
			aim_assist_target disableAimAssist();
		}
		
		if (orgEnt.script_noteworthy == "reverse" )
			orgEnt rotatePitch( 90, 0.25 );
		else
			orgEnt rotatePitch( -90, 0.25 );
		self setCanDamage( false );
		wait .25;
	}
}

getTargetDummies( group, laneID, dummyID )
{
	groupTargetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	targetDummies = [];
	for ( index = 0; index < groupTargetDummies.size; index++ )
	{
		targetDummy = groupTargetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		targetDummies[targetDummies.size] = targetDummy;
	}

	if ( isDefined( laneID ) && isDefined( dummyID ) )
	{
		assert( targetDummies.size == 1 );
	}
	return targetDummies;
}

set_ammo()
{
	if ( (self.classname == "weapon_fraggrenade") || (self.classname == "weapon_flash_grenade") )
		self ItemWeaponSetAmmo( 1, 0 );
	else
		self ItemWeaponSetAmmo( 999, 999 );
}

ammoRespawnThink( flag, type, obj_flag )
{
	wait .2; //timing 
	weapon = self;
	ammoItemClass = weapon.classname;
	ammoItemOrigin = ( weapon.origin + (0,0,8) ); //wont spawn if inside something
	ammoItemAngles = weapon.angles;
	weapon set_ammo();
	
	obj_model = undefined;
	if ( isdefined ( weapon.target ) )
	{
		obj_model = getent ( weapon.target, "targetname" );
		obj_model.origin = weapon.origin;
	}
	
	if ( type == "flash_grenade" )
		ammo_fraction_required = 1;
	else 
		ammo_fraction_required = .2;
		
	if ( isdefined ( flag ) )
	{
		//self delete();
		self.origin = self.origin + (0, 0, -10000);
		if ( isdefined ( obj_model ) )
			obj_model hide();
		
		flag_wait ( flag );
		
		if ( isdefined ( obj_model ) )
			obj_model show();
		self.origin = self.origin + (0, 0, 10000);
		//weapon = spawn ( ammoItemClass, ammoItemOrigin );
		//weapon.angles = ammoItemAngles;
		weapon set_ammo();
	}
	
	if ( ( isdefined ( obj_model ) ) && ( isdefined ( obj_flag ) ) )
		obj_model thread delete_if_obj_complete( obj_flag );
	
	weapon waittill ( "trigger" );
	
	if ( isdefined ( obj_model ) )
		obj_model delete();
	
	while ( 1 )
	{
		wait 1;

		if ( ( level.player GetFractionMaxAmmo( type ) ) < ammo_fraction_required )
		{
			while ( distance( level.player.origin, ammoItemOrigin ) < 160 )
				wait 1;
	
			//if ( level.player pointInFov( ammoItemOrigin ) )
			//	continue;
	
			weapon = spawn ( ammoItemClass, ammoItemOrigin );
			//weapon = spawn ( "weapon_mp5", ammoItemOrigin );
			weapon.angles = ammoItemAngles;
			weapon set_ammo();
			
			//weapon waittill ( "trigger" );
			while ( isdefined ( weapon ) )
				wait 1;
		}
	}
}

delete_if_obj_complete( obj_flag )
{
	self endon ( "death" );
	flag_wait ( obj_flag );
	self delete();
}


test2( type )
{
	while (1)
	{
		println ( type + " " + (level.player GetFractionMaxAmmo( type ) ) );
		wait 1;
	}	
}


pointInFov( origin )
{
    forward = anglesToForward( self.angles );
    return ( vectorDot( forward, origin - self.origin ) > 0.766 ); // 80 fov
}


registerObjective( objName, objText, objEntity )
{
	flag_init( objName );
	objID = level.objectives.size;

	newObjective = spawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.entity = objEntity;
	newObjective.added = false;

	level.objectives[objName] = newObjective;

	return newObjective;
}


setObjectiveState( objName, objState )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];
	objective.state = objState;

	if ( !objective.added )
	{
		objective_add( objective.id, objective.state, objective.text, objective.entity.origin );
		objective.added = true;
	}
	else
	{
		objective_state( objective.id, objective.State );
	}

	if ( objective.state == "done" )
		flag_set( objName );
}


setObjectiveString( objName, objString )
{
	objective = level.objectives[objName];
	objective.text = objString;

	objective_string( objective.id, objString );
}

setObjectiveLocation( objName, objLoc )
{
	objective = level.objectives[objName];
	objective.loc = objLoc;

	objective_position( objective.id, objective.loc.origin );
}

setObjectiveRemaining( objName, objString, objRemaining )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];

	if ( !objRemaining )
		objective_string( objective.id, objString );
	else
		objective_string( objective.id, objString, objRemaining );
}


printAboveHead (string, duration, offset, color)
{
	self endon ("death");

	if (!isdefined (offset))
		offset = (0, 0, 0);
	if (!isdefined (color))
		color = (1,0,0);

	for(i = 0; i < (duration * 20); i++)
	{
		if (!isalive (self))
			return;

		aboveHead = self getshootatpos() + (0,0,10) + offset;
		print3d (aboveHead, string, color, 1, 0.5);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}


registerActions()
{
	level.actionBinds = [];
	registerActionBinding( "objectives",		"pause",				&"KILLHOUSE_HINT_CHECK_OBJECTIVES_PAUSED" );
	registerActionBinding( "objectives",		"+scores",				&"KILLHOUSE_HINT_CHECK_OBJECTIVES_SCORES" );

	registerActionBinding( "pc_attack", 		"+attack",				&"KILLHOUSE_HINT_ATTACK_PC" );
	registerActionBinding( "pc_hip_attack", 	"+attack",				&"KILLHOUSE_HINT_HIP_ATTACK_PC" );
	
	registerActionBinding( "hip_attack", 		"+attack",				&"KILLHOUSE_HINT_HIP_ATTACK" );
	registerActionBinding( "attack", 			"+attack",				&"KILLHOUSE_HINT_ATTACK" );

	registerActionBinding( "stop_ads",			"+speed_throw",			&"KILLHOUSE_HINT_STOP_ADS_THROW" );
	registerActionBinding( "stop_ads",			"+speed",				&"KILLHOUSE_HINT_STOP_ADS" );
	registerActionBinding( "stop_ads",			"+toggleads_throw",		&"KILLHOUSE_HINT_STOP_ADS_TOGGLE_THROW" );
	registerActionBinding( "stop_ads",			"toggleads",			&"KILLHOUSE_HINT_STOP_ADS_TOGGLE" );
	
	registerActionBinding( "ads",				"+speed_throw",			&"KILLHOUSE_HINT_ADS_THROW" );
	registerActionBinding( "ads",				"+speed",				&"KILLHOUSE_HINT_ADS" );
	registerActionBinding( "ads",				"+toggleads_throw",		&"KILLHOUSE_HINT_ADS_TOGGLE_THROW" );
	registerActionBinding( "ads",				"toggleads",			&"KILLHOUSE_HINT_ADS_TOGGLE" );
	
	registerActionBinding( "ads_switch",		"+speed_throw",			&"KILLHOUSE_HINT_ADS_SWITCH_THROW" );
	registerActionBinding( "ads_switch",		"+speed",				&"KILLHOUSE_HINT_ADS_SWITCH" );

	registerActionBinding( "breath",			"+melee_breath",		&"KILLHOUSE_HINT_BREATH_MELEE" );
	registerActionBinding( "breath",			"+breath_sprint",		&"KILLHOUSE_HINT_BREATH_SPRINT" );
	registerActionBinding( "breath",			"+holdbreath",			&"KILLHOUSE_HINT_BREATH" );

	registerActionBinding( "melee",				"+melee_breath",		&"KILLHOUSE_HINT_MELEE_BREATH" );
	registerActionBinding( "melee",				"+melee",				&"KILLHOUSE_HINT_MELEE" );

	registerActionBinding( "prone",				"+stance",				&"KILLHOUSE_HINT_PRONE_STANCE" );
	registerActionBinding( "prone",				"goprone",				&"KILLHOUSE_HINT_PRONE" );
	registerActionBinding( "prone",				"toggleprone",			&"KILLHOUSE_HINT_PRONE_TOGGLE" );
	registerActionBinding( "prone",				"+prone",				&"KILLHOUSE_HINT_PRONE_HOLD" );
	registerActionBinding( "prone",				"lowerstance",			&"KILLHOUSE_HINT_PRONE_DOUBLE" );
//	registerActionBinding( "prone",				"+movedown",			&"" );

	registerActionBinding( "crouch",			"+stance",				&"KILLHOUSE_HINT_CROUCH_STANCE" );
	registerActionBinding( "crouch",			"gocrouch",				&"KILLHOUSE_HINT_CROUCH" );
	registerActionBinding( "crouch",			"togglecrouch",			&"KILLHOUSE_HINT_CROUCH_TOGGLE" );
//	registerActionBinding( "crouch",			"lowerstance",			&"KILLHOUSE_HINT_CROUCH_DOU" );
//	registerActionBinding( "crouch",			"+movedown",			&"KILLHOUSE_HINT_CROUCH" );

	registerActionBinding( "stand",				"+gostand",				&"KILLHOUSE_HINT_STAND" );
	registerActionBinding( "stand",				"+stance",				&"KILLHOUSE_HINT_STAND_STANCE" );

	registerActionBinding( "jump",				"+gostand",				&"KILLHOUSE_HINT_JUMP_STAND" );
	registerActionBinding( "jump",				"+moveup",				&"KILLHOUSE_HINT_JUMP" );

	registerActionBinding( "sprint",			"+breath_sprint",		&"KILLHOUSE_HINT_SPRINT_BREATH" );
	registerActionBinding( "sprint",			"+sprint",				&"KILLHOUSE_HINT_SPRINT" );

	registerActionBinding( "sprint2",			"+breath_sprint",		&"KILLHOUSE_HINT_HOLDING_SPRINT_BREATH" );
	registerActionBinding( "sprint2",			"+sprint",				&"KILLHOUSE_HINT_HOLDING_SPRINT" );

	registerActionBinding( "reload",			"+usereload",			&"KILLHOUSE_HINT_RELOAD_USE" );
	registerActionBinding( "reload",			"+reload",				&"KILLHOUSE_HINT_RELOAD" );

	registerActionBinding( "mantle",			"+gostand",				&"KILLHOUSE_HINT_MANTLE" );

	registerActionBinding( "sidearm",			"weapnext",				&"KILLHOUSE_HINT_SIDEARM_SWAP" );

	registerActionBinding( "primary",			"weapnext",				&"KILLHOUSE_HINT_PRIMARY_SWAP" );

	registerActionBinding( "frag",				"+frag",				&"KILLHOUSE_HINT_FRAG" );
	
	registerActionBinding( "flash",				"+smoke",				&"KILLHOUSE_HINT_FLASH" );

	registerActionBinding( "swap_launcher",		"+activate",			&"KILLHOUSE_HINT_SWAP" );
	registerActionBinding( "swap_launcher",		"+usereload",			&"KILLHOUSE_HINT_SWAP_RELOAD" );

	registerActionBinding( "firemode",			"+actionslot 2",		&"KILLHOUSE_HINT_FIREMODE" );

	registerActionBinding( "attack_launcher", 	"+attack",				&"KILLHOUSE_HINT_LAUNCHER_ATTACK" );

	registerActionBinding( "swap_explosives",	"+activate",			&"KILLHOUSE_HINT_EXPLOSIVES" );
	registerActionBinding( "swap_explosives",	"+usereload",			&"KILLHOUSE_HINT_EXPLOSIVES_RELOAD" );

	registerActionBinding( "plant_explosives",	"+activate",			&"KILLHOUSE_HINT_EXPLOSIVES_PLANT" );
	registerActionBinding( "plant_explosives",	"+usereload",			&"KILLHOUSE_HINT_EXPLOSIVES_PLANT_RELOAD" );

	registerActionBinding( "equip_C4",			"+actionslot 4",		&"KILLHOUSE_HINT_EQUIP_C4" );
	
	registerActionBinding( "throw_C4",			"+toggleads_throw",		&"KILLHOUSE_HINT_THROW_C4_TOGGLE" );
	registerActionBinding( "throw_C4",			"+speed_throw",			&"KILLHOUSE_HINT_THROW_C4_SPEED" );
	registerActionBinding( "throw_C4",			"+throw",				&"KILLHOUSE_HINT_THROW_C4" );
	
	registerActionBinding( "detonate_C4",		"+attack",				&"KILLHOUSE_DETONATE_C4" );

	initKeys();
	updateKeysForBindings();
}


registerActionBinding( action, binding, hint )
{
	if ( !isDefined( level.actionBinds[action] ) )
		level.actionBinds[action] = [];

	actionBind = spawnStruct();
	actionBind.binding = binding;
	actionBind.hint = hint;

	actionBind.keyText = undefined;
	actionBind.hintText = undefined;

	precacheString( hint );

	level.actionBinds[action][level.actionBinds[action].size] = actionBind;
}


getActionBind( action )
{
	for ( index = 0; index < level.actionBinds[action].size; index++ )
	{
		actionBind = level.actionBinds[action][index];

		binding = getKeyBinding( actionBind.binding );
		if ( !binding["count"] )
			continue;

		return level.actionBinds[action][index];
	}
	//unbound = spawnStruct();
	//unbound.binding = "unbound";
	
	return undefined;
}


updateKeysForBindings()
{
	if ( level.console )
	{
		setKeyForBinding( getCommandFromKey( "BUTTON_START" ), "BUTTON_START" );
		setKeyForBinding( getCommandFromKey( "BUTTON_A" ), "BUTTON_A" );
		setKeyForBinding( getCommandFromKey( "BUTTON_B" ), "BUTTON_B" );
		setKeyForBinding( getCommandFromKey( "BUTTON_X" ), "BUTTON_X" );
		setKeyForBinding( getCommandFromKey( "BUTTON_Y" ), "BUTTON_Y" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSTICK" ), "BUTTON_LSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSTICK" ), "BUTTON_RSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSHLDR" ), "BUTTON_LSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSHLDR" ), "BUTTON_RSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LTRIG" ), "BUTTON_LTRIG" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RTRIG" ), "BUTTON_RTRIG" );
	}
	else
	{
		//level.kbKeys = "1234567890-=QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./";
		//level.specialKeys = [];

		for ( index = 0; index < level.kbKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.kbKeys[index] ), level.kbKeys[index] );
		}

		for ( index = 0; index < level.specialKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.specialKeys[index] ), level.specialKeys[index] );
		}

	}
}


getActionForBinding( binding )
{
	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			return arrayKeys[index];
		}
	}
}

setKeyForBinding( binding, key )
{
	if ( binding == "" )
		return;

	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys.size; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			bindArray[bindIndex].key = key;
		}
	}
}


hint( text, timeOut, double_line )
{
	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background( double_line );
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	level.hintElem setText( text );
	//level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
		wait ( timeOut );
	else
		return;

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;
	wait ( 0.5 );

	clear_hints();
}

clear_hints()
{
	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
	if ( isDefined( level.iconElem ) )
		level.iconElem destroyElem();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroyElem();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroyElem();
	if ( isDefined( level.hintbackground ) )
		level.hintbackground destroyElem();
	level notify ( "clearing_hints" );
}

keyHint( actionName, timeOut )
{
	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background();
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	actionBind = getActionBind( actionName );
	level.hintElem setText( actionBind.hint );
	//level.hintElem endon ( "death" );

	notifyName = "did_action_" + actionName;
	for ( index = 0; index < level.actionBinds[actionName].size; index++ )
	{
		actionBind = level.actionBinds[actionName][index];
		level.player notifyOnCommand( notifyName, actionBind.binding );
	}

	if ( isDefined( timeOut ) )
		self thread notifyOnTimeout( notifyName, timeOut );
	level.player waittill( notifyName );

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;

	wait ( 0.5 );
	
	clear_hints();
}

notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
}


training_stallTriggers( group, endonString )
{
	stallTriggers = getEntArray( group + "_stall_trigger", "script_noteworthy" );

	for ( index = 0; index < stallTriggers.size; index++ )
		stallTriggers[index] thread stallTriggerThink( group );

	thread wrongStallNag( endonString );
}


wrongStallNag( endonString )
{
	level endon ( endonString );
	for( ;; )
	{
		level waittill ( "player_wrong_stall", stallString );

		level.marine2 anim_single_solo( level.marine2, "gotofour" );

		wait ( 10.0 );
	}
}


stallTriggerThink( group )
{
	for ( ;; )
	{
		self waittill ( "trigger", entity );

		if ( entity != level.player )
			continue;

		if ( self.targetname != "stall4" )
			level notify ( "player_wrong_stall", self.targetname );
		else
			flag_set( group + "_player_at_stall" );
	}
}

initKeys()
{
	level.kbKeys = "1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";

	level.specialKeys = [];

	level.specialKeys[level.specialKeys.size] = "TAB";
	level.specialKeys[level.specialKeys.size] = "ENTER";
	level.specialKeys[level.specialKeys.size] = "ESCAPE";
	level.specialKeys[level.specialKeys.size] = "SPACE";
	level.specialKeys[level.specialKeys.size] = "BACKSPACE";
	level.specialKeys[level.specialKeys.size] = "UPARROW";
	level.specialKeys[level.specialKeys.size] = "DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "ALT";
	level.specialKeys[level.specialKeys.size] = "CTRL";
	level.specialKeys[level.specialKeys.size] = "SHIFT";
	level.specialKeys[level.specialKeys.size] = "CAPSLOCK";
	level.specialKeys[level.specialKeys.size] = "F1";
	level.specialKeys[level.specialKeys.size] = "F2";
	level.specialKeys[level.specialKeys.size] = "F3";
	level.specialKeys[level.specialKeys.size] = "F4";
	level.specialKeys[level.specialKeys.size] = "F5";
	level.specialKeys[level.specialKeys.size] = "F6";
	level.specialKeys[level.specialKeys.size] = "F7";
	level.specialKeys[level.specialKeys.size] = "F8";
	level.specialKeys[level.specialKeys.size] = "F9";
	level.specialKeys[level.specialKeys.size] = "F10";
	level.specialKeys[level.specialKeys.size] = "F11";
	level.specialKeys[level.specialKeys.size] = "F12";
	level.specialKeys[level.specialKeys.size] = "INS";
	level.specialKeys[level.specialKeys.size] = "DEL";
	level.specialKeys[level.specialKeys.size] = "PGDN";
	level.specialKeys[level.specialKeys.size] = "PGUP";
	level.specialKeys[level.specialKeys.size] = "HOME";
	level.specialKeys[level.specialKeys.size] = "END";
	level.specialKeys[level.specialKeys.size] = "MOUSE1";
	level.specialKeys[level.specialKeys.size] = "MOUSE2";
	level.specialKeys[level.specialKeys.size] = "MOUSE3";
	level.specialKeys[level.specialKeys.size] = "MOUSE4";
	level.specialKeys[level.specialKeys.size] = "MOUSE5";
	level.specialKeys[level.specialKeys.size] = "MWHEELUP";
	level.specialKeys[level.specialKeys.size] = "MWHEELDOWN";
	level.specialKeys[level.specialKeys.size] = "AUX1";
	level.specialKeys[level.specialKeys.size] = "AUX2";
	level.specialKeys[level.specialKeys.size] = "AUX3";
	level.specialKeys[level.specialKeys.size] = "AUX4";
	level.specialKeys[level.specialKeys.size] = "AUX5";
	level.specialKeys[level.specialKeys.size] = "AUX6";
	level.specialKeys[level.specialKeys.size] = "AUX7";
	level.specialKeys[level.specialKeys.size] = "AUX8";
	level.specialKeys[level.specialKeys.size] = "AUX9";
	level.specialKeys[level.specialKeys.size] = "AUX10";
	level.specialKeys[level.specialKeys.size] = "AUX11";
	level.specialKeys[level.specialKeys.size] = "AUX12";
	level.specialKeys[level.specialKeys.size] = "AUX13";
	level.specialKeys[level.specialKeys.size] = "AUX14";
	level.specialKeys[level.specialKeys.size] = "AUX15";
	level.specialKeys[level.specialKeys.size] = "AUX16";
	level.specialKeys[level.specialKeys.size] = "KP_HOME";
	level.specialKeys[level.specialKeys.size] = "KP_UPARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGUP";
	level.specialKeys[level.specialKeys.size] = "KP_LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_5";
	level.specialKeys[level.specialKeys.size] = "KP_RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_END";
	level.specialKeys[level.specialKeys.size] = "KP_DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGDN";
	level.specialKeys[level.specialKeys.size] = "KP_ENTER";
	level.specialKeys[level.specialKeys.size] = "KP_INS";
	level.specialKeys[level.specialKeys.size] = "KP_DEL";
	level.specialKeys[level.specialKeys.size] = "KP_SLASH";
	level.specialKeys[level.specialKeys.size] = "KP_MINUS";
	level.specialKeys[level.specialKeys.size] = "KP_PLUS";
	level.specialKeys[level.specialKeys.size] = "KP_NUMLOCK";
	level.specialKeys[level.specialKeys.size] = "KP_STAR";
	level.specialKeys[level.specialKeys.size] = "KP_EQUALS";
	level.specialKeys[level.specialKeys.size] = "PAUSE";
	level.specialKeys[level.specialKeys.size] = "SEMICOLON";
	level.specialKeys[level.specialKeys.size] = "COMMAND";
	level.specialKeys[level.specialKeys.size] = "181";
	level.specialKeys[level.specialKeys.size] = "191";
	level.specialKeys[level.specialKeys.size] = "223";
	level.specialKeys[level.specialKeys.size] = "224";
	level.specialKeys[level.specialKeys.size] = "225";
	level.specialKeys[level.specialKeys.size] = "228";
	level.specialKeys[level.specialKeys.size] = "229";
	level.specialKeys[level.specialKeys.size] = "230";
	level.specialKeys[level.specialKeys.size] = "231";
	level.specialKeys[level.specialKeys.size] = "232";
	level.specialKeys[level.specialKeys.size] = "233";
	level.specialKeys[level.specialKeys.size] = "236";
	level.specialKeys[level.specialKeys.size] = "241";
	level.specialKeys[level.specialKeys.size] = "242";
	level.specialKeys[level.specialKeys.size] = "243";
	level.specialKeys[level.specialKeys.size] = "246";
	level.specialKeys[level.specialKeys.size] = "248";
	level.specialKeys[level.specialKeys.size] = "249";
	level.specialKeys[level.specialKeys.size] = "250";
	level.specialKeys[level.specialKeys.size] = "252";
}



turn_off_frag_lights()
{
	frag_lights = getentarray ( "frag_lights", "script_noteworthy" );
	
	for(i = 0; i < frag_lights.size; i++)
		frag_lights[ i ] setLightIntensity( 0 );
}

blink_primary_lights()
{
	frag_lights = getentarray ( "frag_lights", "script_noteworthy" );
	
	while( 1 )
	{
		wait 1;
		for(i = 0; i < frag_lights.size; i++)
			frag_lights[ i ] setLightIntensity( 1 );
		wait 1;
	
		for(i = 0; i < frag_lights.size; i++)
			frag_lights[ i ] setLightIntensity( 0 );
	}
}


melon_think()
{	
	melon = getEnt ( "scr_watermelon", "targetname" );
	melon_model = getEnt ( melon.target, "targetname" );
	melon_model hide();

	level waittill ( "show_melon" );
	
	melon_model show();
	
	melon waittill ( "trigger" );
	
	flag_set ( "melee_complete" );
	playfx (level._effect["watermelon"], melon_model.origin);
	melon_model hide();
}

test()
{
	while (1)
	{
		println (" ammo: " + level.player GetWeaponAmmoClip( level.gunPrimary )	);
		wait 1;
	}
}

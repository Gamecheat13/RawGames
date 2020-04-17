#include common_scripts\utility;
#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");







main()
{
	level.strings["eco_hotel_collection0_name"] = &"ECO_HOTEL_COLLECTION0_NAME";
	level.strings["eco_hotel_collection0_body"] = &"ECO_HOTEL_COLLECTION0_BODY";
	level.strings["eco_hotel_collection1_name"] = &"ECO_HOTEL_COLLECTION1_NAME";
	level.strings["eco_hotel_collection1_body"] = &"ECO_HOTEL_COLLECTION1_BODY";
	level.strings["eco_hotel_collection2_name"] = &"ECO_HOTEL_COLLECTION2_NAME";
	level.strings["eco_hotel_collection2_body"] = &"ECO_HOTEL_COLLECTION2_BODY";
	level.strings["eco_hotel_collection3_name"] = &"ECO_HOTEL_COLLECTION3_NAME";
	level.strings["eco_hotel_collection3_body"] = &"ECO_HOTEL_COLLECTION3_BODY";
	level.strings["eco_hotel_collection4_name"] = &"ECO_HOTEL_COLLECTION4_NAME";
	level.strings["eco_hotel_collection4_body"] = &"ECO_HOTEL_COLLECTION4_BODY";
	
	SetExpFog( 0, 20504, 0.7, 0.7, 0.68, 0 );

	
	maps\eco_hotel_fx::main();	
	maps\_vsedan::main("v_sedan_silver_radiant");
	maps\_vsuv::main("v_suv_clean_black_radiant");
	maps\_load::main();
	maps\eco_hotel_amb::main();
	maps\eco_hotel_mus::main();
	
	
	precacheModel( "w_t_sony_phone" );
	precacheModel( "p_msc_suitcase_vesper_igc" );
	
	precacheShader( "compass_map_eco_hotel" );
	precacheshader("white_progressbar");
	precacheShader("black_clear");
	setminimap( "compass_map_eco_hotel", 5072, 4400, -3400, -4024 );
	maps\_phone::setup_phone();
	holster_weapons();
		
	
	
	level._effect["suv_sparks"] = loadfx ("maps/operahouse/opera_boat_sparks");
	level._effect["suv_sparks2"] = loadfx ("maps/operahouse/opera_boat_sparks2");

	level._effect["suv_smoke"] = loadfx ("maps/Eco_Hotel/eco_carsmoke");
	level._effect["suv_smoke_2"] = loadfx ("maps/Eco_Hotel/eco_carsmoke_2");

	level._effect["face_plant"] = loadfx ("maps/constructionsite/const_roofdent_dust");
	level._effect["chopper_dust"] = loadfx ("maps/SinkHole/sink_chopper_cyclone_emit");

	level._effect["muzzle_flash"] = Loadfx( "weapons/p99_discharge" );
	level._effect["small_fire"] = Loadfx( "maps/Eco_Hotel/eco_medrano_fire" );

	precachevehicle( "defaultvehicle" );
	PreCacheitem("w_t_grenade_flash");
	
	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}
	
	SetDVar( "sm_SunSampleSizeNear", 0.7 );
	VisionSetNaked( "eco_hotel_0" );

	
	PrecacheCutScene( "EcoHotel_Intro" );
	PrecacheCutScene( "Eco_MedranoDeath" );
	PrecacheCutScene( "Eco_GreeneTalk_1" );
	PrecacheCutScene( "Eco_GreeneTalk2" );
	PrecacheCutScene( "Eco_Ending" );
	precacheShellshock( "default" );

	thread setup_level();
	thread setup_objectives();
	thread skip_to_points();

	
	level thread map_level1_func();
	level thread map_level2_func();
	level thread map_level3_func();
	level thread map_level4_func();

	level thread spawn_suite();
	level thread parking_lot_02();
	
	
	
	
	level thread runway_save_trigger_func();
	level thread vision_trigger_02();
	level thread spawn_main_entrance_trigger_func();
	level thread spawn_room_trigger_func();
	level thread pre_fire_dome_fight();
	level thread countdown_tip();
	level thread setting_vision();
	thread last_blockers();
	level thread balance_beam_look_at();
	level thread balance_beam_trigger();
	

			
	
	
	

	level.cop_dead = 0;
	level.camille_dead = 0;
	level.fire_hall = 0;
	level.garage_counter = 0;
	level.kitchen_counter = 0;
	level.ai_atrium = 0;
	level.time_remaining = 0;
	level.end_scene = 0;
	level.medrano_cutscene = 0;

	wait( .1 );
	level.player maps\_gameskill::saturateViewThread( false );
	VisionSetSecondary( 0.0, "pain_death" );
}






setup_level()
{
	wait(0.01);

	thread open_garage_door();
	
	level.garage_progression = false;
	level.inposition = 0;
	level.bond_spotted = false;
	level.retreat = true;
	level.atrium_reinforced = false;
	level.atrium_left = false;
	
	broken_window_01 = getent("kitchen_shatter_01", "targetname");
	broken_window_02 = getent("kitchen_shatter_02", "targetname");
	broken_window_03 = getent("kitchen_shatter_03", "targetname");
	broken_window_04 = getent("kitchen_shatter_04", "targetname");
	
	broken_window_01 hide();
	broken_window_02 hide();
	broken_window_03 hide();
	broken_window_04 hide();
	
	medrano_broken_wall_01 = getent("medrano_wall_broken01", "targetname");
	medrano_broken_wall_02 = getent("medrano_wall_broken02", "targetname");
	
	medrano_broken_wall_01 hide();
	medrano_broken_wall_02 hide();
	
	
	
	
	

	suv_collision = GetEnt( "suv_collision", "targetname" );
	suv_collision trigger_off();

	end_extinguisher_event = GetEnt( "end_extinguisher_event", "targetname" );
	end_extinguisher_event trigger_off();

	breadcrume_greene = GetEnt( "auto3001", "targetname" );
	breadcrume_greene trigger_off();

	
	
	

	medrano_glass_bad = GetEntArray( "eh_medrano_glass_sb2", "targetname" );
	for ( i = 0; i < medrano_glass_bad.size; i++ )
	{
		medrano_glass_bad[i] hide();
	}

	trigger_fireball = getentarray("triggerhurt_fireball", "targetname");
	for (i=0; i<trigger_fireball.size; i++)
	{
		trigger_fireball[i] trigger_off();
	}
	
	fuelcell = getentarray ("fuelcell_hallway", "targetname");
    for (i=0; i<fuelcell.size; i++)
    {
		fuelcell[i] hide();
    }
    
    fuelcell_suite = getentarray ("fuelcell_balcony", "targetname");
    for (i=0; i<fuelcell_suite.size; i++)
    {
		fuelcell_suite[i] trigger_off();
    }
    
    cables = getentarray("cables_brk", "targetname");
    for (i=0; i<cables.size; i++)
    {
    	cables[i] hide();
    }
    
    triggerhurt_01 = getent("triggerhurt_fire_hallway", "targetname");
    triggerhurt_01 trigger_off();
    triggerhurt_02 = getent("triggerhurt_fire_stairs01", "targetname");
    triggerhurt_02 trigger_off();
    triggerhurt_03 = getent("triggerhurt_fire_stairs02", "targetname");
    triggerhurt_03 trigger_off();
	
	
	triggerhurt_03b = getent("triggerhurt_fire_stairs03", "targetname");
    triggerhurt_03b trigger_off();
    triggerhurt_04 = getent("triggerhurt_fire_room", "targetname");
    triggerhurt_04 trigger_off();
    
	
	triggerhurt_05 = getent("triggerhurt_fire_balcony", "targetname");
    triggerhurt_05 trigger_off();
    triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
    triggerhurt_06 trigger_off();

	final_blocker = GetEnt( "final_blocker", "targetname" );
	final_blocker trigger_off();

	trigger = GetEnt( "blow_bond_back", "targetname" );
	
	
	trigger sethintstring(&"ECO_HOTEL_OPEN_DOOR");
	trigger trigger_off();

	blocker = getent("fire_blocker_03", "targetname");
	blocker trigger_off();
	blocker1 = getent("fire_dome_blocker_00", "targetname");
	blocker1 trigger_off();

	fire_dome_01 = getent("fire_dome_01", "targetname");
	fire_dome_01 trigger_off();
	fire_dome_02 = getent("fire_dome_02", "targetname");
	fire_dome_02 trigger_off();
	fire_dome_03 = getent("fire_dome_03", "targetname");
	fire_dome_03 trigger_off();
	fire_dome_04 = getent("fire_dome_04", "targetname");
	fire_dome_04 trigger_off();
	fire_dome_05 = getent("fire_dome_05", "targetname");
	fire_dome_05 trigger_off();
	fire_dome_06 = getent("fire_dome_06", "targetname");
	fire_dome_06 trigger_off();


	triggerhurt_07 = getent("triggerhurt_dining_exit", "targetname");
    triggerhurt_07 trigger_off();
    
    triggerhurt_rampback = getent("triggerhurt_fire_rampback", "targetname");
    triggerhurt_rampback trigger_off();
    
    triggerhurt_leftexit = getent("triggerhurt_fire_leftexit", "targetname");
    triggerhurt_leftexit trigger_off();
    
    triggerhurt_camille = getent("triggerhurt_camille_escape", "targetname");
	triggerhurt_camille trigger_off();
        
	flag_init("police_chief_dead");
	flag_init( "all_dead_parking1" );
	flag_init( "send_rushers" );
	flag_init("exit_parking");
	flag_init("greene_spotted");
	flag_init("save_outside_atrium");
	flag_init("kitchen_battle");
	flag_init("kitchen_destroyed");
	flag_init("start_kitchen_counter_fire");
	flag_init("suite_located");
	flag_init("fuelcell_suite_destroyed");
	flag_init("greene_left");
	flag_init("greene_middle");
	flag_init("greene_right");
	flag_init( "kill_greene" );
	flag_init("greene_dead");
	flag_init("escape");
	flag_init( "fire_hall_boom" );
	flag_init( "end_of_greene" );
		
	thread spawn_greene_car();
	setsaveddvar( "melee_enabled", "0" );

	
	SetSavedDVar( "bal_move_speed", 75.0 );


	
	SetSavedDVar( "Bal_wobble_accel", 1.025 );
	SetSavedDVar( "Bal_wobble_decel", 1.045 );

	
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black_clear", 640, 480);
		level.hud_black.alpha = 0;
	}

	
	if (!IsDefined(level.hud_white))
	{
		level.hud_white = newHudElem();
		level.hud_white.x = 0;
		level.hud_white.y = 0;
		level.hud_white.horzAlign = "fullscreen";
		level.hud_white.vertAlign = "fullscreen";
		level.hud_white SetShader("white_progressbar", 640, 480);
		level.hud_white.alpha = 0;
	}
}



map_level1_func()
{
	trigger = GetEnt( "map_trigger_level1", "targetname" );
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	level thread map_level2_func();
}



map_level2_func()
{
	trigger = GetEnt( "map_trigger_level2", "targetname" );
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	level thread map_level1_func();
	level thread map_level3_func();
}



map_level3_func()
{
	trigger = GetEnt( "map_trigger_level3", "targetname" );
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
	level thread map_level2_func();
	level thread map_level4_func();
}



map_level4_func()
{
	trigger = GetEnt( "map_trigger_level4", "targetname" );
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level4" );
	level thread map_level3_func();
}




setup_objectives()
{
	wait(47);
	objective_add( 1, "active", &"ECO_HOTEL_OBJECTIVE_ENTER_HEADER", ( 1712, -152, -56 ), &"ECO_HOTEL_OBJECTIVE_ENTER_BODY");
	
	trigger_car = getent("trigger_garage_door", "targetname");
	trigger_car waittill("trigger");

	thug = GetEnt( "spawner_police_driver", "targetname" );
	
	objective_state(1, "empty");
	
	objective_add( 2, "active", &"ECO_HOTEL_OBJECTIVE_CAR_HEADER", ( thug.origin ));
	

	
	
	flag_wait("police_chief_dead");
	wait( 4 );

	if ( isalive ( level.player ))
	{
		objective_state(2, "done");

		objective_state(1, "active");

		trigger_enter = getent("trigger_spawn_parking", "targetname");
		trigger_enter waittill("trigger");

		objective_state(1, "done");

		objective_add( 3, "active", &"ECO_HOTEL_OBJECTIVE_GARAGE_HEADER", ( 1216, 1688, -168 ), &"ECO_HOTEL_OBJECTIVE_GARAGE_BODY");
		wait(1.0);

		flag_wait( "all_dead_parking1" );
		objective_state( 3, "done");
	}
	
	
	
	objective_add( 4, "active", &"ECO_HOTEL_OBJECTIVE_SURVIVE_HEADER", ( -120, 2200, -168 ), &"ECO_HOTEL_OBJECTIVE_SURVIVE_BODY");
	wait(2.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("exit_parking");
	objective_state( 4, "done");
	
	
	
	greene = GetEnt( "spawner_greene_fuelcell", "targetname" );

	objective_add( 5, "active", &"ECO_HOTEL_OBJECTIVE_LOCATE_GREENE_HEADER", ( greene.origin ), &"ECO_HOTEL_OBJECTIVE_LOCATE_GREENE_BODY");
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("greene_spotted");
	objective_state( 5, "done");
	
	
	
	
	
	objective_add( 6, "active", &"ECO_HOTEL_OBJECTIVE_KITCHEN_HEADER", ( -2687, -105.5, 23.5 ), &"ECO_HOTEL_OBJECTIVE_KITCHEN_BODY");
	wait(1.0);
	
	flag_wait("kitchen_destroyed");
	objective_state( 6, "done");
	
	
	
	objective_add( 7, "active", &"ECO_HOTEL_OBJECTIVE_LOCATE_MEDRANO_HEADER", ( -2729, 2958, 38 ), &"ECO_HOTEL_OBJECTIVE_LOCATE_MEDRANO_BODY");
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("suite_located");
	objective_state( 7, "done");
	
	
	
	objective_add( 8, "active", &"ECO_HOTEL_OBJECTIVE_GREENE_HEADER", ( -1558, 867, -90 ), &"ECO_HOTEL_OBJECTIVE_GREENE_BODY");
	wait(1.0);
	
	flag_wait( "kill_greene" );
	objective_state( 8, "done");
	
	

	objective_add( 9, "active", &"ECO_HOTEL_OBJECTIVE_GREENE_HEADER2", ( -1040, 840, -88 ), &"ECO_HOTEL_OBJECTIVE_GREENE_BODY2");
	wait( 1.0 );
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	level thread blow_back_bond_func();
	
	flag_wait( "end_of_greene" );
	objective_state( 9, "done");
	
	
	
	objective_add( 10, "active", &"ECO_HOTEL_OBJECTIVE_HEADER_KILL_GREENE", ( -1310, 882, 38 ), &"ECO_HOTEL_OBJECTIVE_BODY_KILL_GREENE");
	wait( 1.0 );

	flag_wait( "greene_dead" );

	flag_wait( "greene_dead" );
	objective_state( 10, "done");

	

	objective_add( 11, "active", &"ECO_HOTEL_OBJECTIVE_ESCAPE_HEADER", ( -3270.5, 901, -90 ), &"ECO_HOTEL_OBJECTIVE_ESCAPE_BODY");
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("escape");
	objective_state( 11, "done");
}




skip_to_points()
{
	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	
	else if(Getdvar( "skipto" ) == "garage" )
	{
		setdvar("skipto", "0");
		
		start_org = getent( "skip_to_garage", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("police_chief_dead");
		
		thread spawn_first_parking();
		thread check_locker_door();
		level notify ( "Eco_Intro_done" );
		setsaveddvar( "melee_enabled", "1" );

		
		
		
		
		
		
		
		
		
		
		
	}
	
	else if(Getdvar( "skipto" ) == "locker" )
	{
		setdvar("skipto", "0");
		
		start_org = getent( "skip_to_locker", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("exit_parking");
		
		thread spawn_greene_runaway();
		setsaveddvar( "melee_enabled", "1" );
	}
	
	else if(Getdvar( "skipto" ) == "kitchen" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_kitchen", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("greene_spotted");
		
		
		thread spawn_kitchen();
		thread atrium_exterior_gate();
		setsaveddvar( "melee_enabled", "1" );
	}
	
	else if(Getdvar( "skipto" ) == "balcony" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_balcony", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("kitchen_destroyed");
		
		thread amb_explosion_balcony();
		thread atrium_exterior_gate();
		thread block_atrium();
		setsaveddvar( "melee_enabled", "1" );
	}
	
	else if(Getdvar( "skipto" ) == "medrano" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_medrano", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		thread atrium_exterior_gate();
		setsaveddvar( "melee_enabled", "1" );
		
		camille = GetEnt( "camille_balcony", "targetname" );
		camille gun_remove();
		level thread balance_beam_look_at();
		level thread balance_beam_trigger();
	}
	
	else if(Getdvar( "skipto" ) == "greene" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_greene", "targetname" );
		start_org_angles = start_org.angles;
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		thread atrium_exterior_gate();
		thread spawn_atrium_lower();
		thread blow_back_bond_func();
		setsaveddvar( "melee_enabled", "1" );
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		exit_fire_block_01 trigger_off();
		
		
		
		
		
		
		greene = getent( "spawner_greene_fuelcell", "targetname" ); medrano = getent( "spawner_medrano_fuelcell", "targetname" );
		greene delete(); medrano delete();
		thread last_blockers();
	}

	else if(Getdvar( "skipto" ) == "escape" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_escape", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		thread atrium_exterior_gate();
		wait( 2 );
		thread check_all_dead();
		thread blow_back_bond_func();
		setsaveddvar( "melee_enabled", "1" );
		wait( 3.0 );
		door_node = Getnodearray( "auto2944", "targetname" );
		for ( i = 0; i < door_node.size; i++ )
		{
			door_node[i] maps\_doors::open_door_from_door_node();
		}
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		exit_fire_block_01 trigger_off();
		
		
		
		
		
		
		greene = getent( "spawner_greene_fuelcell", "targetname" ); medrano = getent( "spawner_medrano_fuelcell", "targetname" );
		greene delete(); medrano delete();
		thread last_blockers();
		
		
		
		triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
		triggerhurt_06 trigger_on();
		blocker = getent("fire_blocker_03", "targetname");
		blocker trigger_on();
	}
}





lighting_start_off()
{
	trigger = GetEnt( "trigger_close_gates", "targetname" );

	light_01 = GetEnt( "kitchen_light01", "targetname" );
	light_02 = GetEnt( "kitchen_light02", "targetname" );

	light_01 setlightintensity ( 0 );
	light_02 setlightintensity ( 0 );
	
	trigger waittill ( "trigger" );

	light_01 setlightintensity ( 1.5 );
	light_02 setlightintensity ( 1.5 );
}




spawn_greene_car()
{	
	if(Getdvar( "skipto" ) != "" )
	{
		return;
	}
	
	wait(0.05);
	
	level thread black_white_fade();
	thread antenna_func_00();
	thread antenna_func_01();
	thread antenna_func_02();
	thread antenna_func_03();
	thread extra_setup();
	
	suv_ramp = GetEnt( "suv_replace_ramp", "script_noteworthy" );
	suv_ramp hide();
	suv_ramp notsolid();
	suv_ramp movez(1000, 0.1);
	
	playcutscene( "EcoHotel_Intro", "Eco_Intro_done" );
	
	
	level waittill ( "Eco_Intro_done" );

	maps\_utility::unholster_weapons();
	level.player SwitchToWeapon("p99");
	
	suv = GetEnt( "suv", "targetname" );
	sedan = GetEnt( "sedan", "targetname" );

	SetDVar( "sm_SunSampleSizeNear", 0.25 );
	letterbox_off();
	
	
	
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	suv delete();
	sedan delete();

	
	
	level.player freezeControls(false);

	
	wait(0.5);

	maps\_autosave::autosave_now( "eco_hotel" );

	endcutscene( "EcoHotel_Intro" );

	camille = GetEnt( "camille", "targetname" );
	camille delete();
}



















extra_setup()
{
	cell_01 = GetEnt( "car_crash_cell", "targetname" );
	if ( isdefined( cell_01 ))
	{
		cell_01 trigger_off();
	}
	
	
	
	
	
	

	level thread display_chyron();
	letterbox_on(false, false);
	
	
	level notify("playmusicpackage_start");
	
	level.player PlaySound( "3_cars" );

	camille = GetEnt( "camille", "targetname" );
	camille gun_remove();
	wait( 0.1 );

	
	camille attach( "w_t_sony_phone", "TAG_WEAPON_PHONE" );
	level.player attach( "w_t_sony_phone", "TAG_WEAPON_RIGHT" );
	

	level waittill ( "Eco_Intro_done" );
	level.player detach( "w_t_sony_phone", "TAG_WEAPON_RIGHT" );

	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );
	greene.team = "neutral";
	medrano.team = "neutral";
	greene gun_remove();
	medrano gun_remove();
	exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
	exit_fire_block_01 trigger_off();
}



black_white_fade()
{
	level waittill ( "Eco_Intro_done" );
	trigger = GetEnt( "out_of_bounds_black_white", "targetname" );
	x = 0.0;

	level endon ( "kill_vision" );
	while( 1 )
	{
		wait( .1 );
		if ( level.player istouching ( trigger ))
		{
			VisionSetSecondary( x, "pain_death" );
			x = x + 0.01;
			if ( x >= 1 )
			{
				missionfailed();
			}
		}
		else if ( !level.player istouching ( trigger ))
		{
			if ( x >= 0 )
			{
				VisionSetSecondary( x, "pain_death" );
				x = x - 0.01;
			}
			if ( x <= 0 )
			{
				VisionSetSecondary( 0.0, "pain_death" );
			}
		}
	}
}



setting_vision()
{
	trigger = GetEnt ( "trigger_reset_vision", "targetname" );
	
	
	
	trigger waittill ( "trigger" );
	
	level.player thread maps\_gameskill::saturateViewThread();
	level thread set_vision_mode();
}



set_vision_mode()
{
	trigger = GetEnt ( "trigger_set_vision", "targetname" );
	
	
	
	trigger waittill ( "trigger" );
	
	level.player thread maps\_gameskill::saturateViewThread( false );
	level thread setting_vision();
}




open_garage_door()
{
	trigger = getent("trigger_garage_door","targetname");
	trigger waittill("trigger");
	
	thread spawn_police_car();
	
	garage_door = getent("garage_door","targetname");
	garage_door movey(-278, 3.0);
}




spawn_police_car()
{	
	spawnpt = getent("origin_spawn_police", "targetname");
	start_node = getvehiclenode( "node_police_start", "targetname" );
	wait_node = getvehiclenode( "auto125", "targetname" );
	spawner = getent("spawner_police_driver", "targetname");
	spawner stalingradspawn("police_driver");

	
	suv_dmg_trigger_ramp = GetEnt( "suv_dmg_trigger_ramp", "targetname" );
	suv_dmg_trigger_ramp enablelinkto();
	level.police_car = getent("police_car_chief", "targetname");
	level.police_car.health = 100000;
	suv_dmg_trigger_ramp linkto( level.police_car, "tag_driver", ( 0, -8, 0 ), ( 0, 90, 0 ));
	

	driver = getent("police_driver", "targetname");
	driver.DropWeapon = false;
	driver.health = 100000;
	driver gun_remove();
	driver setenablesense( false );
	driver setpainenable( false );

	driver thread magic_bullet_shield();

	driver thread car_check_driver_func();

	
	level notify("playmusicpackage_garage");

	driver Teleport( level.police_car GetTagOrigin( "tag_driver" ), ( level.police_car GetTagAngles( "tag_driver")+ ( 0, 90 ,0 )), true );
	driver LinkTo( level.police_car, "tag_driver", ( 30, 0, -16 ), ( 0, 0, 0 ));

	level.police_car PlaySound( "1_car" );
	driver thread suv_spark_scrape();
	level.police_car thread suv_tire_smoke();

	thread driver();

	driver thread check_police_driver();
	thread spawn_first_parking();
	level waittill ( "driver_dead" );
	suv_dmg_trigger_ramp unlink();
	suv_dmg_trigger_ramp trigger_off();
}



suv_tire_smoke()
{
	
	
	wait( .8 );
	playfxontag ( level._effect["suv_smoke"], self, "tag_right_wheel_02_jnt" );
	playfxontag ( level._effect["suv_smoke_2"], self, "tag_left_wheel_02_jnt" );
}



suv_spark_scrape()
{
	spark_tag_01 = GetEnt( "spark_tag_01", "targetname" );
	
	spark_tag_02 = GetEnt( "spark_tag_02", "targetname" );
	
	wait( 1.0 );
	radiusdamage( ( 1264, -224, -80 ), 500, 1000, 1000 );
	physicsExplosionSphere( ( 1264, -224, -80 ), 500, 400, 75 );
	physicsExplosionSphere( ( 1264, -216, -56 ), 500, 400, 75 );
	wait( 0.2 );
	self stop_magic_bullet_shield();
	playfxontag ( level._effect["suv_sparks2"], spark_tag_01, "tag_origin" );

	
	
	
	
	
	
	
	wait( 0.5 );
	spark_tag_01 delete();

	wait( 0.7 );
	sparxfx2 = spawnfx( level._effect["suv_sparks"], spark_tag_02.origin );
	triggerFx( sparxfx2 );

	
	
	
	

	wait( .5 );
	sparxfx2 delete();
}

driver()
{
	driver = getent("police_driver", "targetname");
	driver setenablesense( false );
	driver cmdplayanim("Gen_Civs_SitIdle_E", true);
}





car_check_driver_func()
{
	level thread suv_swap();
	trigger = GetEnt( "car_check_driver", "targetname" );
	trigger waittill ( "trigger" );
	wait ( .2 );
	if ( isdefined ( self ))
	{
		
		self delete();
		thug_fly = getent ("police_driver_dummy", "targetname")  stalingradspawn( "thug_fly" );
		thug_fly waittill( "finished spawning" );
		thug_fly.DropWeapon = false;
		radiusdamage( ( 3967.5, -190.5, 279.5 ), 200, 200, 200 );
		
		
		
		
		
		
		playfx( level._effect[ "propane_explosion" ], ( 4000, -112, 200 )); playfx( level._effect[ "propane_explosion" ], ( 3904, -112, 200 ));
		playfx( level._effect[ "propane_explosion" ], ( 3808, -112, 200 )); playfx( level._effect[ "propane_explosion" ], ( 3792, -184, 200 ));
		
		
		
		
		thug_fly launch( (100, 100, 100) );
	}
	
	physicsExplosionSphere( ( 3890, -144, 254 ), 200, 100, 60 );
	level notify ( "driver_dead" );

	wait( 0.7 );
	playfx( level._effect[ "face_plant" ], ( 4232, -120, 208 )); playfx( level._effect[ "face_plant" ], ( 4256, -120, 216 ));
	playfx( level._effect[ "face_plant" ], ( 4280, -120, 224 ));
	wait( 0.5 );
	
	
	
	
	
	
	
	
}





























suv_swap()
{
	
	
	suv_collision = GetEnt( "suv_collision", "targetname" );
	level waittill ( "driver_dead" );
	suv = GetEnt( "suv_replace_ramp", "script_noteworthy" );
	suv solid();
	suv show();
	suv_collision trigger_on();
	suv PlaySound( "car_crash" );
	
	
	
	wait( 1.0 );
	
	if ( IsDefined ( level.police_car ))
	{
		level.police_car delete();
	}
}




check_police_driver()
{
	driver = getent("police_driver", "targetname");
	

	
	driver SetFlashBangPainEnable ( false );

	driver thread check_achievement_eco();

	level waittill ( "driver_dead" );
	level.cop_dead++;
	

	flag_set( "police_chief_dead" );
	setsaveddvar( "melee_enabled", "1" );

	

	earthquake( 0.6, 1, ( 3967.5, -190.5, 279.5 ), 500 );
	
	
}



check_achievement_eco()
{
	amount = undefined;
	self waittill ( "damage", amount, ent );
	if ( ent == level.player )
	{
		GiveAchievement( "Challenge_EcoHotel" ); 
	}
}



runway_save_trigger_func()
{
	trigger = getent("runway_save_trigger","targetname");
	trigger waittill("trigger");
	maps\_autosave::autosave_now( "eco_hotel" );
}




spawn_first_parking()
{
	trigger = getent("trigger_spawn_parking","targetname");
	trigger waittill("trigger");
	level notify ( "kill_vision" );

	

	thread parking_lot_blocker_01();
	thread guard_runaway();

	spawnerarray = getentarray("spawner_parking_01", "targetname");
	spawner = getent("spawner_parking_01rusher", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_parking_01");
		spawnerarray[i] setperfectsense(true);
		spawnerarray[i] thread garage_counter_01();
	}

	spawner stalingradspawn("guard_parking_01rusher");
	spawner thread garage_counter_01();

	thread spawn_gate_guards();

	if ( IsDefined ( spawner ))
	{
		spawner play_dialogue_nowait( "RSO2_EcohG_007A" );
	}
}



garage_counter_01()
{
	self waittill ( "death" );
	level.garage_counter++;

	if ( level.garage_counter >= 4 )
	{
		level notify ( "spawn_next_garage_wave_01" );
	}
	if ( level.garage_counter >= 7 )
	{
		level notify ( "spawn_next_garage_wave_02" );
	}
}



parking_lot_blocker_01()
{
	trigger = GetEnt( "office_blocker_trigger_01", "targetname" );
	trigger waittill ( "trigger" );

	
	

	
	badplace_cylinder( "blocker_01a", 0, ( 770, 682, -176 ), 28, 182, "axis" );
	badplace_cylinder( "blocker_01b", 0, ( 1630, 686, -176 ), 64, 182, "axis" );
	thread parking_lot_blocker_01_off();
}



parking_lot_blocker_01_off()
{
	trigger = GetEnt( "trigger_badplace_1_off", "targetname" );
	trigger waittill ( "trigger" );

	badplace_delete( "blocker_01a" );
	badplace_delete( "blocker_01b" );

	thread parking_lot_blocker_01();
}



parking_lot_blocker_02()
{
	trigger = GetEnt( "office_blocker_trigger_02", "targetname" );
	trigger waittill ( "trigger" );

	
	

	
	badplace_cylinder( "blocker_02a", 0, ( 1834, 1986, -176 ), 28, 182, "axis" );
	badplace_cylinder( "blocker_02b", 0, ( 1796, 2306, -176 ), 28, 182, "axis" );
	thread parking_lot_blocker_02_off();
}



parking_lot_blocker_02_off()
{
	trigger = GetEnt( "trigger_badplace_2_off", "targetname" );
	trigger waittill ( "trigger" );

	badplace_delete( "blocker_02a" );
	badplace_delete( "blocker_02b" );

	thread parking_lot_blocker_02();
}


guard_runaway()
{
	node = getnode("node_parking_runaway", "targetname");

	runaway = getent ("spawner_parking_runaway", "targetname")  stalingradspawn( "runaway" );
	runaway waittill( "finished spawning" );
	runaway thread garage_counter_01();

	if (isdefined(runaway))
	{
		runaway setgoalnode(node);
		runaway play_dialogue( "RSO1_EcohG_006A" );
	}
	if ( isdefined( runaway ))
	{
		runaway play_dialogue( "RSO1_EcohG_006B" );
	}
}




spawn_gate_guards()
{
	trigger = getent("trigger_close_gates", "targetname");
	trigger waittill("trigger");
	
	thread close_entrance_gate();
	thread close_gates();
	thread spawn_room();
	
	spawnerarray = getentarray("spawner_parking_gate", "targetname");
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("gate_guards");
		spawnerarray[i] thread garage_counter_01();
	}
}




close_entrance_gate()
{
	trigger = getent("trigger_close_entrance", "targetname");
	trigger waittill("trigger");
	
	garage_door = GetEnt( "garage_door", "targetname" );
	garage_door movey( 278, 1.0 );

	gate = getent("parking_entrance_gate","targetname");
	
	gate PlaySound( "gate_shut" );
	gate movez( -192, 1.0 );
	
	
	
	wait(11.0);
	
	rusher = getent("guard_parking_01rusher", "targetname");
	
	if (isdefined(rusher))
	{
		rusher setcombatrole("rusher");
		rusher setscriptspeed("walk");
	}
}




open_gates()
{
	partition_gate_02 = getentarray ( "parking_gate_02","targetname" );
	partition_gate_03 = getent("parking_gate_03","targetname");
	
	partition_gate_03 connectpaths();

	partition_gate_03 PlaySound( "big_gate_open" );
	
	partition_gate_03 movez(180, 5.0);
	wait( 2.5 );

	for ( i = 0; i < partition_gate_02.size; i++ )
	{
		partition_gate_02[i] connectpaths();
		partition_gate_02[i] movez(180, 5.0);
	}
	
}




close_gates()
{	
	partition_gate_02 = GetEntArray ( "parking_gate_02","targetname" );
	partition_gate_03 = getent("parking_gate_03","targetname");
	
	wait(0.5);

	partition_gate_03 PlaySound( "big_gate_close" );

	for ( i = 0; i < partition_gate_02.size; i++ )
	{
		partition_gate_02[i] movez(-180, 2.0);
	}

	wait(0.5);
	
	partition_gate_03 movez( -180, 2.0 );
	
	wait(3.0);
	partition_gate_03 disconnectpaths();

	for ( i = 0; i < partition_gate_02.size; i++ )
	{
		partition_gate_02[i] disconnectpaths();
	}

}







spawn_room_trigger_func()
{
	trigger = getent("trigger_spawn_room", "targetname");
	trigger waittill("trigger");

	level notify ( "spawn_next_garage_wave_01" );
}

spawn_room()
{
	level waittill ( "spawn_next_garage_wave_01" );

	if (!(level.garage_progression))
	{
		nodearray = getnodearray("node_cover_garage", "targetname");
		level.rusher_array = getentarray("spawner_parking_room", "targetname");
		for (i=0; i<level.rusher_array.size; i++)
		{
			level.rusher_array[i] = level.rusher_array[i] stalingradspawn("room_guard");
			level.rusher_array[i] thread garage_counter_01();
			if (isdefined(level.rusher_array[i]))
			{
				level.rusher_array[i] setgoalnode(nodearray[i], 1);
			}
		}
	}

	level thread thug_vo_01();
	level thread thug_vo_backup();

	level thread garage_thug_vo_line_01();
	thread spawn_main_entrance();
	wait( 8.0 );
	thread parking_lot_blocker_02();
}



garage_thug_vo_line_01()
{
	flanker_thug = getent ("spawner_parking_room_alt", "targetname")  stalingradspawn( "flanker_thug" );
	flanker_thug waittill( "finished spawning" );
	flanker_thug thread garage_counter_01();
	flanker_thug LockAlertState( "alert_red" );
	flanker_thug waittill ( "goal" );
	if ( IsDefined ( flanker_thug ))
	{
		flanker_thug play_dialogue_nowait( "GSO1_EcohG_101A" );
	}
	level notify ( "thug_play_vo_01" );
}



thug_vo_01()
{
	level waittill ( "thug_play_vo_01" );
	if ( IsDefined ( level.rusher_array[0] ))
	{
		level.rusher_array[0] play_dialogue_nowait( "GSO2_EcohG_008A" );
	}
	else if ( IsDefined ( level.rusher_array[1] ))
	{
		level.rusher_array[1] play_dialogue_nowait( "GSO2_EcohG_008A" );
	}
	else if ( IsDefined ( level.rusher_array[2] ))
	{
		level.rusher_array[2] play_dialogue_nowait( "GSO2_EcohG_008A" );
	}
}



thug_vo_backup()
{
	level waittill ( "thug_play_vo_backup" );
	wait( .1 );
	if ( IsDefined ( level.rusher_array[0] ))
	{
		level.rusher_array[0] play_dialogue_nowait( "GSO1_EcohG_009A" );
	}
	else if ( IsDefined ( level.rusher_array[1] ))
	{
		level.rusher_array[1] play_dialogue_nowait( "GSO1_EcohG_009A" );
	}
	else if ( IsDefined ( level.rusher_array[2] ))
	{
		level.rusher_array[2] play_dialogue_nowait( "GSO1_EcohG_009A" );
	}
}







spawn_main_entrance_trigger_func()
{
	trigger = getent("trigger_spawn_main", "targetname");
	trigger waittill("trigger");

	level notify ( "spawn_next_garage_wave_02" );
}

spawn_main_entrance()
{
	level waittill ( "spawn_next_garage_wave_02" );

	level notify ( "thug_play_vo_backup" );

	thread main_guard_rusher();
	
	level.garage_progression = true;
	
	spawnerarray = getentarray("spawner_parking_main", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("main_guard");
		spawnerarray[i] setperfectsense(true);
		spawnerarray[i] thread garage_counter_01();
		
	}
	
	spawner = getent("spawner_parking_mainrusherlast", "targetname");
	spawner stalingradspawn("main_rusher_last");
	spawner thread garage_counter_01();
	
	wait (4.0);
	
	gate = getent("main_entrance_gate", "targetname");
	gate movez( -100, 1.0 );
	
	thread check_parking_01();
}

main_guard_rusher()
{
	spawnerarray = getentarray("spawner_parking_mainrusher", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("main_guard_rusher");
		spawnerarray[i] setperfectsense(true);
		spawnerarray[i] thread garage_counter_01();
	}
	
	wait(10.0);
	
	for (i=0; i<spawnerarray.size; i++)
	{
		if (isdefined(spawnerarray[i]))
		{
			spawnerarray[i] setcombatrole("rusher");
		}
	}
}




check_parking_01()
{
	alldead = false;
	
	while(!(alldead))
	{
		guards = getaiarray("axis");
		
		if ((guards.size) == 1)
		{
			if (isdefined(guards[0]))
			{
				guards[0] setcombatrole("rusher");
			}
		}
		
		if (!(guards.size))
		{
			alldead = true;
			thread spawn_greene_garage();
			thread parking_lot_02_lookat();
		}
		
		wait(0.5);
	}
	
	flag_set( "all_dead_parking1" );
}




spawn_greene_garage()
{
	wait ( 10 );
	level notify ( "spawn_parking_02" );
}



parking_lot_02_lookat()
{
	trigger = GetEnt( "trigger_lookat_parking_02", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "spawn_parking_02" );
}



parking_lot_02()
{
	level waittill ( "spawn_parking_02" );
	
	level thread green_speaks_to_thugs();
	wait( 5 );
	thread spawn_parking_rushers();
}



green_speaks_to_thugs()
{
	level.player play_dialogue( "GREE_EcohG_010A" );
	level.player play_dialogue( "GREE_EcohG_011A" );
	level.player play_dialogue_nowait( "GREE_EcohG_013B" );
}




spawn_parking_rushers()
{
	flanker_thug = getent ( "spawner_parking_eliterusher_alt", "targetname")  stalingradspawn( "flanker_thug" );
	flanker_thug waittill( "finished spawning" );
	flanker_thug thread parking_rusher_func();

	rusher_thug = getentarray ( "spawner_parking_eliterusher", "targetname" );
	for ( i = 0; i < rusher_thug.size; i++ )
	{
		thug[i] = rusher_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] thread parking_rusher_func();
		}
	}
	thread check_rusher_position();
	thread send_rushers( flanker_thug );

	flanker_thug waittill("goal");
	flanker_thug play_dialogue( "ELG1_EcohG_014A" );
}



parking_rusher_func()
{
	self waittill("goal");
	self setengagerule("never");
	self cmdfaceangles(0);
	self waittill("cmd_done");
	wait(1.5);
	self stopallcmds();

	level waittill ( "rushers_go" );
	self setengagerule("redalert");
	self setcombatrole("rusher");
	self setperfectsense(true);
	self setscriptspeed("walk");
}




check_rusher_position()
{
	wait(12.0);
	
	flag_set( "send_rushers" );
	
	partition_gate_02 = GetEntArray ( "parking_gate_02","targetname" );
	partition_gate_03 = getent("parking_gate_03","targetname");
	
	partition_gate_03 connectpaths();

	for ( i = 0; i < partition_gate_02.size; i++ )
	{
		partition_gate_02[i] connectpaths();
	}

}




send_rushers( flanker_thug )
{
	flag_wait("send_rushers");
	
	thread check_rushers();
	
	level notify ( "rushers_go" );
	
	wait(1.0);
	
	flanker_thug play_dialogue_nowait ( "ELG1_EcohG_015A" );
	thread open_gates();
	thread spawn_backup();
	
	wait(2.0);
	
	spawnerarray = getentarray("spawner_backup_rushers", "targetname");
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_backup_rushers");
	}
	flanker_thug play_dialogue ( "ELG1_EcohG_016A" );
}




check_rushers()
{
	guards = getentarray("guard_parking_rusher", "targetname");
	flank = false;
	one_left = false;
	
	while(!(flank))
	{
		guards = getentarray("guard_parking_rusher", "targetname");
		
		if (guards.size < 4)
		{
			flank = true;
		}
		
		for (i=0; i<guards.size; i++)
		{
			dist = guards[i] GetClosestEnemySqDist();
			if (dist < 160000)
			{
				flank = true;
			}
		}
		wait(0.1);
	}
	
	for (i=0; i<guards.size; i++)
	{
		if (isdefined(guards[i]))
		{
			guards[i] setcombatrole("elite");
		}
	}
	
	while(!(one_left))
	{
		rushers = getentarray("guard_parking_rusher", "targetname");
		
		if (rushers.size == 1)
		{
			one_left = true;
		}
		
		if (isdefined(rushers[0]))
		{
			rushers[0] setcombatrole("rusher");
		}
		
		wait(0.1);
	}
}




spawn_backup()
{
	trigger = getent("trigger_spawn_backup", "targetname");
	trigger waittill("trigger");

	thread car_roof();
	
	nodearray = getnodearray("node_cover_middle", "targetname");
	spawnerarray = getentarray("spawner_parking_backup", "targetname");
	gate = getent("gate_storage", "targetname");
	
	gate movez(120, 1.0);
	gate connectpaths();
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_parking_backup");
		if (isdefined(spawnerarray[i]))
		{
			spawnerarray[i] setgoalnode(nodearray[i], 1);
		}
	}
	
	trigger = getent("trigger_change_backup", "targetname");
	trigger waittill("trigger");
	
	thread spawn_parking_last();
	
	guards = getentarray("guard_parking_backup", "targetname");
	
	for (i=0; i<guards.size; i++)
	{
		if (isdefined(guards[i]))
		{
			guards[i] setcombatrole("flanker");
		}
	}
	
	array = getentarray("guard_backup_rushers", "targetname");
	for (i=0; i<array.size; i++)
	{
		array[i] setcombatrole("flanker");
	}
}

car_roof()
{
	spawner = getent("spawner_parking_backupCAT", "targetname");
	spawner stalingradspawn("guard_roof");
	
	node_cover = getnode("node_cover_CAT", "targetname");
	node = getnode("node_car_roof", "targetname");
	guard = getent("guard_roof", "targetname");
	
	if (isdefined(guard))
	{
		guard setgoalnode(node, 1);
		guard waittill("goal");
		guard setcombatrole( "turret" );
	}
	else
	{
		array = getentarray("guard_parking_backup", "targetname");
		if (isdefined(array[0]))
		{
			array[0] setgoalnode(node, 1);
			array[0] waittill("goal");
			array[0] setcombatrole("turret");
		}
	}
}




spawn_parking_last()
{
	spawnerarray = getentarray("spawner_parking_last", "targetname");
	guardarray = getentarray("spawner_parking_lastrunner", "targetname");
	nodes = getnodearray("node_cover_last", "targetname");
	nodearray = getnodearray("node_cover_runner", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_parking_last");		
	}
	
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_parking_runner");		
	}
	
	thread check_garage();
	thread garage_exit();
	
	trigger = getent("trigger_change_last", "targetname");
	trigger waittill("trigger");
	
	array = getentarray("guard_parking_last", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		if (isdefined(array[i]))
		{
			array[i] setcombatrole("flanker");
		}
	}
	
	wait(5.0);
	
	guards = getentarray("guard_parking_runner", "targetname");
	for (i=0; i<guards.size; i++)
	{
		if (isdefined(guards[i]))
		{
			guards[i] setgoalnode(nodearray[i]);
			guards[i] setcombatrole("flanker");
			guards[i] addengagerule( "tgtPerceive" );
			wait(1.0);
		}
	}
	
	wait(3.0);
	
	if (isdefined(array[0]))
	{
		array[0] setcombatrole("rusher");
	}
}	




check_garage()
{
	all_clear = false;
	
	while(!(all_clear))
	{
		guards = getaiarray("axis");
		
		if (!(guards.size))
		{
			all_clear = true;
		}		
		wait(0.5);
	}
	
	wait(2.0);
	
	thread spawn_garage_exit();
}




spawn_garage_exit()
{
	node = getnode("node_garage_exit", "targetname");
	spawner = getent("spawner_parking_exitdoor", "targetname");
	door = getnodearray("auto2419", "targetname");
	
	guard = spawner stalingradspawn("guard_door");
	guard setgoalnode(node);
	
	thread garage_guards();
	
	guard waittill("goal");
	
	guard setperfectsense(true);
	guard setcombatrole("rusher");
	
	door[0] maps\_doors::open_door();
	
	thread spawn_greene_runaway();
	thread check_locker_door();
}



check_locker_door()
{
	level.player waittill( "lockpick_done" );
	level notify ( "vending_machine" );
}

garage_guards()
{
	wait(2.0);

	parking_thugs = getentarray ( "spawner_parking_exit", "targetname" );

	for ( i = 0; i < parking_thugs.size; i++ )
	{
		thug[i] = parking_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			
		}
	}
}




garage_exit()
{
	trigger = getent("trigger_exit_parking","targetname");
	trigger waittill("trigger");

	
	level notify("playmusicpackage_ambient");

	level notify ( "kill_blockers" );

	broken_window = GetEnt( "broken_window", "targetname" );
	broken_window trigger_off();

	level thread bond_speaks_to_camille_01();

	flag_set("exit_parking");
	
	trigger = getent("trigger_locker_save","targetname");
	trigger waittill("trigger");
	
	maps\_autosave::autosave_now( "eco_hotel" );
}



bond_speaks_to_camille_01()
{
	
	
	
	
	
}




spawn_greene_runaway()
{
	trigger = getent("trigger_greene_fuelcell", "targetname");
	trigger waittill("trigger");

	
	

	
	

	playcutscene( "Eco_GreeneTalk2", "Eco_GreeneTalk2_done" );

	thread suitcase_handoff();
	thread greene_hall_backup();
	thread check_bond_spotted();
}



suitcase_handoff()
{
	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );

	greene gun_remove();
	medrano gun_remove();

	
	
	
	
	medrano attach( "p_msc_suitcase_vesper_igc", "TAG_WEAPON_RIGHT" );
}



greene_hall_backup()
{
	wait( 14 );
	thread spawn_atrium_perimeter();
}



greene_shoots_hall_panel()
{
	tag_fuelcell = GetEnt( "tag_fuelcell_explosion", "targetname" );
	self cmdshootatentityxtimes( tag_fuelcell, false, 10, 1, false );
	level notify ( "panel_drop_01_start" );
	wait( 4.0 );
	level notify ( "panel_drop_01_done" );
}




check_bond_spotted()
{
	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );

	greene play_dialogue( "GREE_EcohG_022A" );
	medrano play_dialogue( "MEDR_EcohG_023A" );

	level.player play_dialogue( "BOND_EcohG_024A" );
	level.player play_dialogue( "CAMI_EcohG_026A" );

	wait(4.0);
	greene play_dialogue( "GREE_EcohG_028A" );
	
	level waittill ( "Eco_GreeneTalk2_done" );
	endcutscene( "Eco_GreeneTalk2" );

	
	level notify("endmusicpackage");

	greene setenablesense( false );
	

	greene cmdidle( false, -1 );
	

	greene setengagerule( "never" );
	

	wait( .1 );

	greene stopallcmds();
	

	
	level notify("playmusicpackage_greene");

	
	greene lockalertstate( "alert_red" );

	blocker = GetEnt( "fire_blocker_00", "targetname" );
	blocker ConnectPaths();
	thread greene_medrano_run();
}




greene_medrano_run()
{
	
	medrano = getent("spawner_medrano_fuelcell", "targetname");
	
	thread spawn_greene_shoot();
	
	medrano delete();	
}








damage_transfert(trig_damage, target, endon_str)
{
	self endon(endon_str);

	trig_damage = GetEnt(trig_damage, "targetname");
	target = GetEnt(target, "targetname");
	
	while (1)
	{
		trig_damage waittill("damage", damage);
		target dodamage(damage, level.player.origin);
		wait(0.1);
	}
}





spawn_greene_shoot()
{
	node_greene = getnode("node_greene_fuelcell", "targetname");
	greene = getent( "spawner_greene_fuelcell", "targetname" );

	blocker = GetEnt( "fire_blocker_00", "targetname" );

	greene thread magic_bullet_shield();
	greene setpainenable( false );

	wait( .1 );

	greene setgoalnode(node_greene);

	greene waittill("goal");
	greene maps\_utility::gun_recall();
	wait( .1 );

	greene = getent( "spawner_greene_fuelcell", "targetname" );
	greene thread greene_shoots_hall_panel();

	
	
	

	level waittill ( "panel_drop_01_done" );

	greene setengagerule( "never" );

	
	

	

	flag_set("greene_spotted");

	explosion = getent("tag_fuelcell_explosion", "targetname");

	broken_window = GetEnt( "broken_window", "targetname" );
	good_window = GetEnt( "atrium_window_clean", "targetname" );

	fire_extinguish = getentarray("tag_extinguisher_example", "targetname");

	level notify ( "exp_1" );

	explosion playsound ( "green_tank_expl" );
	broken_window trigger_on();
	good_window trigger_off();
	radiusdamage( ( -1264.5, 286, 59.5 ), 100, 150, 200 );
	blocker trigger_on();
	earthquake( 0.5, 2.0, level.player.origin, 100 );
	
	thread bond_fuel_cell_talk();

	extinguisher = getent("extinguisher_auto", "targetname");

	level notify ( "fx_fire_3" );
	
	fx_fire_3_org = GetEnt( "badplace_fire_org_03", "targetname" ); 
	badplace_cylinder( "fx_fire_03", 0, fx_fire_3_org.origin, 56, 182, "axis" );
	fx_fire_3_org playloopsound( "fire_A" );

	for ( i = 0; i < fire_extinguish.size; i++ )
	{
		firefx2 = spawnfx( level._effect["fx_fire_large"], fire_extinguish[i].origin );
		triggerFx( firefx2 );
		fire_extinguish[i] playloopsound( "fire_A" );
		fire_extinguish[i] thread stop_fire_hall_sound();
		firefx2 thread delete_fx_spawn( extinguisher );
		wait(0.1);
	}
	radiusdamage( explosion.origin, 25, 25, 25 );

	thread greene_enter_atrium();
	thread spawn_kitchen();
	thread kitchen_save_game();

	wait(2.0);

	earthquake( 0.5, 2.0, level.player.origin, 100 );

	wait(0.1);

	trigger2 = getent("triggerhurt_extinguisher_example", "targetname");
	
	fire_ext = getent("fire_extinguisher_drop", "targetname");

	fire_ext physicslaunch(fire_ext.origin , ((-2500.0, 0.0, 0.0)) );

	wait(2.0);

	
	
	extinguisher moveto(fire_ext.origin, 0.01);
	extinguisher rotateto(fire_ext.angles, 0.01);
	wait(0.5);
	fire_ext delete();

	
	
	thread damage_transfert("td_fire_extinguisher_drop", "extinguisher_auto", "stopDamageExtAuto");
	extinguisher thread extra_damage();

	extinguisher waittill("death");
	level notify("stopDamageExtAuto");

	wait(2.0);

	trigger2 trigger_off();
	blocker trigger_off();
}



bond_fuel_cell_talk()
{
	level.player play_dialogue( "CAMI_EcohG_019A" );
	level.player play_dialogue( "BOND_EcohG_020A" );
}












delete_fx_spawn( extinguisher )
{
	extinguisher waittill ( "death" );
	self delete();
	level notify ( "kill_fire" );
}



stop_fire_hall_sound()
{
	level waittill ( "kill_fire" );
	self stoploopsound();
}





foreshadow_kitchen()
{
	array = getentarray("spawner_kitchen_foreshadow", "targetname");
		
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("foreshadow_guard");
		array[i] thread delete_kitchen_foreshadow();
		wait(1.0);
	}
}

delete_kitchen_foreshadow()
{
	node = getnode("node_kitchen_foreshadow", "targetname");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}




spawn_atrium_perimeter()
{
	thread foreshadow_kitchen();
	
	array_thug = getentarray("spawner_atrium_perimeter", "targetname");
	node = getnodearray("node_perimeter", "targetname");
	
	for (i=0; i<array_thug.size; i++)
	{
		array_thug[i] = array_thug[i] stalingradspawn("perimeter_guard");
		array_thug[i] setperfectsense(true);
		array_thug[i] thread perimeter_rusher();
		array_thug[i] thread fire_hall_thug_check();
		wait(0.3);
	}
	
	wait( 6.0 );
	
	thread atrium_exterior_gate();
}

perimeter_rusher()
{
	wait(5.0);
	self setscriptspeed("walk");
}



fire_hall_thug_check()
{
	self waittill ( "death" );
	level.fire_hall++;
	if ( level.fire_hall >= 2 )
	{
		flag_set( "fire_hall_boom" );
	}
}




atrium_exterior_gate()
{
	gate = getent("gate_atrium_outside", "targetname");
	
	gate connectpaths();

	gate PlaySound( "metal_door" );
	
	gate movez ( 120, 4.5 );
	
	thread grenade();
	
	trigger = getent("trigger_close_perimeter", "targetname");
	trigger waittill("trigger");
	
	gate waittill ( "movedone" );
	gate disconnectpaths();
	
	gate movez (-120, 0.5);
}




grenade()
{
	origin = getent("origin_grenade", "targetname");
	guards = getentarray("perimeter_guard", "targetname");
	
	wait(1.3);
	
	if (isdefined(guards[0]) || isdefined(guards[1]))
	{
		guards[0] magicgrenade (origin.origin, level.player.origin, 2.0);		
	}
}




greene_enter_atrium()
{
	node = getnode("node_greene_runto", "targetname");
	greene = getent("spawner_greene_fuelcell", "targetname");
	greene setgoalnode(node);
	greene waittill("goal");
	greene setengagerule( "never" );
	wait( 0.5 );
	node2 = getnode( "node_greene_last", "targetname" );
	greene setgoalnode( node2 );
	greene waittill( "goal" );
	greene stop_magic_bullet_shield();
	wait( 0.5 );
	greene delete();
}




spawn_greene_victims()
{
	spawnerarray = getentarray("spawner_greene_victim", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_victim");
	}
}




kitchen_save_game()
{
	trigger = getent( "trigger_save_before_kitchen", "targetname" );
	trigger waittill( "trigger" );

	maps\_autosave::autosave_now( "eco_hotel" );
}

spawn_kitchen()
{
	trigger = getent("trigger_spawn_kitchen", "targetname");
	trigger waittill("trigger");
	
	flag_set("kitchen_battle");
	
	spawnerarray = getentarray("spawner_kitchen_01", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_kitchen_01");
		spawnerarray[i] thread kitchen_counter_01();
	}
	
	greene = getent("spawner_greene_fuelcell", "targetname");
	if (isdefined(greene))
	{
		greene stop_magic_bullet_shield();
		greene delete();
	}
	
	thread spawn_kitchen_reinforce();
	thread kitchen_fires();
	thread kitchen_explosion_enter();
}



kitchen_counter_01()
{
	self waittill ( "death" );
	level.kitchen_counter++;

	if ( level.kitchen_counter >= 4 )
	{
		level notify ( "spawn_next_kitchen_wave_01" );
	}
	if ( level.kitchen_counter >= 7 )
	{
		level notify ( "spawn_next_kitchen_wave_02" );
	}
}



spawn_kitchen_reinforce()
{
	trigger = getent("trigger_kitchen_reinforce", "targetname");
	trigger waittill("trigger");
	
	flag_set("start_kitchen_counter_fire");
	
	spawnerarray = getentarray("spawner_kitchen_02", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_kitchen_reinforce");
	}
	
	array = getentarray("guard_kitchen_reinforce", "targetname");
	
	while((array.size) > 1)
	{
		array = getentarray("guard_kitchen_reinforce", "targetname");
		wait(0.1);
	}	
	
	thread spawn_kitchen_backup();
}




kitchen_fires()
{
	fire_tag_01 = getent("tag_kitchenfire_01", "targetname");
	firefx = spawnfx( level._effect["fx_fire_large"], fire_tag_01.origin );
	triggerFx( firefx );
	level notify ( "fx_fire_7" ); level notify ( "fx_fire_8" ); level notify ( "fx_fire_9" ); level notify ( "fx_fire_10" );

	fx_fire_7_org = GetEnt( "badplace_fire_org_07", "targetname" ); 
	badplace_cylinder( "fx_fire_07", 0, fx_fire_7_org.origin, 28, 182, "axis" );
	fx_fire_7_org playloopsound( "fire_A" );

	fx_fire_9_org = GetEnt( "badplace_fire_org_09", "targetname" ); 
	badplace_cylinder( "fx_fire_09", 0, fx_fire_9_org.origin, 28, 182, "axis" );
	fire_sound_org_10 = GetEnt( "fire_sound_org_10", "targetname" );
	fire_sound_org_10 playloopsound( "fire_A" );

	flag_wait("start_kitchen_counter_fire");
	
	wait(3.0);
	level notify ("fx_kitchen_smoke"); 
	
	explosion1 = getent("tag_kitchen_explosion1", "targetname");
	level.player PlaySound( "kitchen_expl_02" );
	level notify ( "exp_7" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
	
	

	
	
	physicsExplosionSphere(( -1308, -256, 68 ), 200, 100, 15 ); physicsExplosionSphere(( -1304, -160, 68 ), 200, 100, 15 );
	physicsExplosionSphere(( -1304, -52, 68 ), 200, 100, 15 ); physicsExplosionSphere(( -1440, -144, 68 ), 200, 100, 15 );
	

	wait( 0.5 );
	
	thread kitchen_fire_right();
}




kitchen_fire_right()
{
	level notify ( "fx_fire_45" ); level notify ( "fx_fire_11" );

	fire_sound_org_11 = GetEnt( "fire_sound_org_11", "targetname" );
	fire_sound_org_11 playloopsound( "fire_A" );
}




kitchen_explosion_enter()
{
	
	

	exp_org = GetEnt( "exp_org", "targetname" );
	level notify ( "exp_6" );
	exp_org PlaySound( "kitchen_expl" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
	
	thread kitchen_explosion_mid();
	thread kitchen_phy_push_func();
	thread dining_trigger_func();
	thread prep_lookat_dining_func();
	thread kitchen_extra_shake_func();

	fire_tag_02 = getent("tag_kitchenfire_02", "targetname");
	firefx = spawnfx( level._effect["fx_fire_large"], fire_tag_02.origin );
	level notify ( "kitchen_door_start" );
	triggerFx( firefx );
	firefx thread kitchen_fire_extinguisher1();

	badplace_cylinder( "fire_tag002", 0, fire_tag_02.origin, 28, 182, "axis" );

	level notify ( "fx_fire_15" ); level notify ( "fx_fire_16" ); level notify ( "fx_fire_17" ); level notify ( "fx_fire_50" ); level notify ( "fx_fire_41" );

	fx_fire_15_org = GetEnt( "badplace_fire_org_15", "targetname" ); 
	badplace_cylinder( "fx_fire_15", 0, fx_fire_15_org.origin, 28, 182, "axis" );
	fire_sound_org_15 = GetEnt( "fire_sound_org_15", "targetname" );
	fire_sound_org_15 playloopsound( "fire_A" );
	fire_sound_org_16 = GetEnt( "fire_sound_org_16", "targetname" );
	fire_sound_org_16 playloopsound( "fire_A" );
	fire_sound_org_50 = GetEnt( "fire_sound_org_50", "targetname" );
	fire_sound_org_50 playloopsound( "fire_A" );
	
	fire_tag2 = getent("tag_kitchenfire_midext", "targetname");
	firefx2 = spawnfx( level._effect["fx_fire_large"], fire_tag2.origin );
	triggerFx( firefx2 );

	badplace_cylinder( "fire_tag001", 0, fire_tag2.origin, 28, 182, "axis" );

	firefx2 thread kitchen_fire_extinguisher2();
	wait( 0.5 );
	radiusdamage (( -764, -122, 79 ), 100, 200, 50);

	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");

}



prep_lookat_dining_func()
{
	trigger = GetEnt( "prep_lookat_trigger_dining", "targetname" );
	trigger waittill ( "trigger" );
	thread trigger_lookat_dining();
}




trigger_lookat_dining()
{
	trigger = GetEnt( "lookat_trigger_dining", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "blow_dining_doors" );
}



dining_trigger_func()
{
	trigger = GetEnt( "kitchen_extra_shake", "targetname" );
	trigger waittill ( "trigger" );
	wait( 1.5 );
	level notify ( "blow_dining_doors" );
}



kitchen_extra_shake_func()
{
	level waittill ( "blow_dining_doors" );

	exp_org = GetEnt( "kitchen_extra_exp_org", "targetname" );
	playfx( level._effect[ "fx_explosion" ], exp_org.origin );
	level notify ( "dining_doors_start" );
	exp_org PlaySound( "dining_doors_exp" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
}



kitchen_phy_push_func()
{
	trigger = GetEnt( "kitchen_door_flyby", "targetname" );
	trigger waittill ( "trigger" );

	
	fire_tag = getent( "tag_kitchenfire_off_shoot", "targetname" );
	
	firefx = spawnfx( level._effect["fx_fire_large"], fire_tag.origin );
	level notify ( "kitchen_single_start" );
	triggerFx( firefx );
	
	
		playfx( level._effect[ "fx_explosion" ], ( -1193, 184, 79 ));
		physicsExplosionSphere(( -1193, 184, 79 ), 200, 100, 35 );
		
	
}



dining_phy_push_func()
{
	

	
	
	physicsExplosionSphere(( -2024, -336, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2176, -400, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2304, -376, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2376, -296, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2184, -200, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2088, -32, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -1992, 64, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2408, -136, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2416, -40, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2360, 72, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2464, 144, 152 ), 75, 25, 2 );
	
}




kitchen_explosion_mid()
{
	trigger = getent("trigger_kitchen_explosion2", "targetname");
	trigger waittill("trigger");
	
	guards = getentarray("guard_kitchen_01", "targetname");
	for (i=0; i<guards.size; i++)
	{
		if (isdefined(guards[i]))
		{
			guards[i] setcombatrole("basic");
		}
	}
	
	thread table_turnover();
	thread spawn_kitchen_midguards();
	thread spawn_dining_room();

	
	level.player PlaySound( "kitchen_expl_03" );
	level notify ( "exp_8" );
	physicsExplosionSphere(( -1580, -208, 104 ), 200, 100, 15 );
	physicsExplosionSphere(( -1716, -252, 104 ), 200, 100, 15 );
	physicsExplosionSphere(( -1712, -156, 104 ), 200, 100, 15 );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
	
	wait(0.1);
	
	window1 = getent("kitchen_window_01", "targetname");
	window1 hide();
	shatter1 = getent("kitchen_shatter_01", "targetname");
	shatter1 show();
	
	wait(0.5);
	
	firefx4 = spawnfx( level._effect["fx_fire_large"], ( -1242, -438, 64 ));
	triggerFx( firefx4 );


	fire_sound_org_04 = GetEnt( "fire_sound_org_04", "targetname" );
	fire_sound_org_04 playloopsound( "fire_A" );
	
	fire_tag = getent("tag_kitchenfire_mid", "targetname");
	
	firefx2 = spawnfx( level._effect["fx_fire_large"], ( -1585, -352, 18 ));
	triggerFx( firefx2 );

	explosion3 = getent("tag_kitchen_explosion3", "targetname");
	level notify ( "exp_9" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
	
	wait(0.5);
	
	
	firefx42 = spawnfx( level._effect["fx_fire_large"], ( -1718, -228, 64 ));
	triggerFx( firefx42 );

	fire_sound_org_42 = GetEnt( "fire_sound_org_42", "targetname" );
	fire_sound_org_42 playloopsound( "fire_A" );
	wait(3.0);
	thread kitchen_explosion_counterend();

	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");
	firefx2 delete(); firefx4 delete(); firefx42 delete();

}




table_turnover()
{
	trigger = getent("trigger_spawn_table", "targetname");
	trigger waittill("trigger");
	
	guard = getent("spawner_kitchen_table", "targetname");
	guard stalingradspawn("guard_table");
	
	thread dining_table();
}




dining_table()
{
	trigger = getent("trigger_turnover_table", "targetname");
	trigger waittill("trigger");
	
	table = getent("dining_table", "targetname");
	
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}




spawn_kitchen_midguards()
{
	spawnerarray = getentarray("spawner_kitchen_04", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_kitchen_mid");
	}
	
	wait(3.0);
	
	array = getentarray("spawner_kitchen_05", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_kitchen_midreinforce");
	}
}




kitchen_fire_extinguisher1()
{
	extinguisher = getent( "kitchen_extinguisher1", "targetname" );
	ext_replace = getent("kitchen_extinguisher1a", "targetname");


	extinguisher3 = getent( "kitchen_extinguisher3", "targetname" );
	ext_replace3 = getent("kitchen_extinguisher3a", "targetname");

	trigger = getent("trigger_hurtfire_kitchen01", "targetname");
	blocker = getent("fire_blocker_01", "targetname");
	
	extinguisher thread extinguisher_second_drop( ext_replace );
	extinguisher3 thread extinguisher_third_drop( ext_replace3 );
	
	
	
	thread damage_transfert("td_kitchen_extinguisher1", "kitchen_extinguisher1a", "stopDamageExtKitch1");
	ext_replace thread extra_damage();
	ext_replace waittill( "death" );
	level notify("stopDamageExtKitch1");
	trigger trigger_off();
	blocker trigger_off();
	blocker ConnectPaths();
	self delete();
	badplace_delete( "fire_tag002" );
}



extinguisher_second_drop( ext_replace )
{
	trigger = GetEnt( "kitchen_ext_fall_2", "targetname" );
	trigger waittill ( "trigger" );
	
	earthquake( 0.4, 1.5, level.player.origin, 100 );
	self physicslaunch( self.origin+( 10, 0, 0 ), (( 0.0, -10000.0, -10000.0 )));

	wait( 2.0 );

	phy_clip = GetEntArray( "phy_fire_01", "targetname" );
	for ( i = 0; i < phy_clip.size; i++ )
	{
		phy_clip[i] trigger_off();
	}


	ext_replace moveto( self.origin, 0.01 );
	ext_replace rotateto( self.angles, 0.01 );
	wait( 0.5 );
	self delete();
}



extinguisher_third_drop( ext_replace3 )
{
	trigger = GetEnt( "kitchen_ext_fall_3", "targetname" );
	trigger waittill ( "trigger" );

	earthquake( 0.4, 1.5, level.player.origin, 100 );
	self physicslaunch( self.origin+( -10, 0, 0 ), (( 10000.0, 10000.0, 0.0 )));

	wait( 2.0 );

	phy_clip = GetEnt( "phy_fire_02", "targetname" );
	phy_clip trigger_off();

	ext_replace3 moveto( self.origin, 0.01 );
	ext_replace3 rotateto( self.angles, 0.01 );
	wait( 0.5 );
	self delete();
}




kitchen_fire_extinguisher2()
{
	extinguisher = getent("kitchen_extinguisher3a", "targetname");
	trigger = getent("trigger_hurtfire_kitchen03", "targetname");
	blocker = getent("fire_blocker_02", "targetname");
	
	
	
	thread damage_transfert("td_kitchen_extinguisher2", "kitchen_extinguisher3a", "stopDamageExtKitch2");
	extinguisher thread extra_damage();

	extinguisher waittill( "death" );
	level notify("stopDamageExtKitch2");
	trigger trigger_off();
	blocker trigger_off();
	blocker ConnectPaths();
	self delete();

	badplace_delete( "fire_tag001" );
}



extra_damage()
{
	self waittill( "damage" );
	wait( 1.0 );
	radiusdamage ( self.origin, 15, 50, 50 ); 
}




spawn_kitchen_backup()
{
	spawnerarray = getentarray("spawner_kitchen_03", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_kitchen_backup");
	}
}




kitchen_explosion_counterend()
{	
	
	
	playfx( level._effect[ "fx_explosion" ], ( -1827, 129, 78 ));
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	
	
	
	radiusdamage (( -1804, 114, 64 ), 100, 200, 200 );
	
	wait(0.1);
	
	window2 = getent("kitchen_window_02", "targetname");
	window2 hide();
	shatter2 = getent("kitchen_shatter_02", "targetname");
	shatter2 show();
	
	wait(1.0);

	
	firefx43 = spawnfx( level._effect["fx_fire_large"], ( -1804, 114, 64 ));
	triggerFx( firefx43 );

	firefx44 = spawnfx( level._effect["fx_fire_large"], ( -1716, -38, 64 ));
	triggerFx( firefx44 );

	fire_sound_org_43 = GetEnt( "fire_sound_org_43", "targetname" );
	fire_sound_org_43 playloopsound( "fire_A" );
	fire_sound_org_44 = GetEnt( "fire_sound_org_44", "targetname" );
	fire_sound_org_44 playloopsound( "fire_A" );

	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");
	firefx43 delete(); firefx44 delete();

}




spawn_dining_room()
{
	trigger = getent("trigger_spawn_dining", "targetname");
	trigger waittill("trigger");
	
	spawnerarray = getentarray("spawner_kitchen_dining", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_dining");
	}
	
	thread no_retreat();
	thread perimeter_explosion();
	thread spawn_dining_exit();
}




spawn_dining_exit()
{
	trigger = getent("trigger_dining_exit", "targetname");
	trigger waittill("trigger");
	
	thread dining_table_exit01();
	thread dining_table_exit02();
	thread retreat_dining_room();
	
	spawnerarray = getentarray("spawner_dining_exit", "targetname");
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_dining_exit");
		spawnerarray[i] setperfectsense(true);
		wait(1.0);
	}
	
	spawner = getent("spawner_dining_exitrusher", "targetname");
	spawner stalingradspawn("dining_rusher");
	rusher = getent("dining_rusher", "targetname");
	rusher setscriptspeed("walk");
}




dining_table_exit01()
{
	trigger = getent("trigger_turnover_table01", "targetname");
	trigger waittill("trigger");
	
	table = getent("dining_table_exit01", "targetname");
	
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}

dining_table_exit02()
{
	trigger = getent("trigger_turnover_table02", "targetname");
	trigger waittill("trigger");
	
	table = getent("dining_table_exit02", "targetname");
	
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}




retreat_dining_room()
{
	node = getnodearray("node_retreat_dining", "targetname");

	retreat = false;
	
	while(!(retreat))
	{
		guards = getaiarray("axis");
		
		if (((guards.size) < 2) && (level.retreat))
		{
			retreat = true;
			
			for (i=0; i<guards.size; i++)
			{
				if (isdefined(guards[i]))
				{
					guards[i] setgoalnode(node[i]);
					guards[i] setcombatrole("turret");
				}
			}
		}
		wait(0.1);
	}
}

no_retreat()
{
	trigger = getent("trigger_no_retreat", "targetname");
	trigger waittill("trigger");
	
	level.retreat = false;
	
	wait(8.0);
	
	guys = getaiarray("axis");
	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i] setcombatrole("rusher");
			wait(1.5);
		}
	}
}




perimeter_explosion()
{
	trigger = getent("trigger_perimeter_explosion", "targetname");
	trigger waittill("trigger");
	
	thread hallway_fires();
	thread spawn_hallway_victims();
	
	explosion = getent("tag_perimeter_explosion", "targetname");
	explosion PlaySound( "dining_secondary_exp" );
	playfxontag( level._effect[ "fx_explosion" ], explosion, "tag_origin" );
	earthquake( 0.7, 3.0, level.player.origin, 100 );
	
	
	
	
	fire_array = getentarray("tag_perimeter_fire", "targetname");
	for (i=0; i<fire_array.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire_array[i], "tag_origin" );
		wait(0.3);
	}
	
	earthquake( 0.7, 3.0, level.player.origin, 100 );
	
	wait(3.0);
	
	earthquake( 0.7, 3.0, level.player.origin, 100 );
	wait(0.5);
	earthquake( 0.3, 3.0, level.player.origin, 100 );
	wait(0.3);
	earthquake( 0.5, 3.0, level.player.origin, 100 );
}




hallway_fires()
{
	fire_array = getentarray("tag_fire_hallway", "targetname");
	for (i=0; i<fire_array.size; i++)
	{
		firefx = spawnfx( level._effect["fx_fire_large"], fire_array[i].origin );
		triggerFx( firefx );
	}

	triggerhurt_07 = getent("triggerhurt_dining_exit", "targetname");
    triggerhurt_07 trigger_on();
}




spawn_hallway_victims()
{
	trigger = getent("trigger_hallway_victims", "targetname");
	trigger waittill("trigger");

	

	

	flag_set("kitchen_destroyed");
	
	
	array = getentarray("spawner_hallway_guards", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_hallway");
	}
	
	
	
	
	
	wait(1.5);
	
	thread hallway_explosions();
	thread glass_break();
	thread balcony2_save_func();
}



balcony2_save_func()
{
	trigger = getent( "balcony2_save", "targetname" );
	trigger waittill( "trigger");

	maps\_autosave::autosave_now( "eco_hotel" );
	thread alt_dialog_camille_bond();
}



alt_dialog_camille_bond()
{
	level.player play_dialogue( "CAMI_EcohG_029A" );
	level.player play_dialogue( "BOND_EcohG_032A" );
	level.player play_dialogue( "MEDR_EcohG_033A" );
	
	
	level notify("playmusicpackage_medrano");
}



bond_speaks_to_camille_02()
{
	
	level.player play_dialogue( "BOND_EcohG_032A" );
}

glass_break()
{
	
	
	
	
	
	radiusdamage (( -2799.5, 318.5, -39.5 ), 50, 100, 100);
}




hallway_explosions()
{
	
	exp_org = GetEnt( "exp_org_2", "targetname" );
	
	thread	fire_block_hallway();
	
	level thread exp_notifies_for_hall();

	exp_org PlaySound( "dining_exp" );
	thread hall_radius_damage_func();
	
	triggerhurt_01 = getent("triggerhurt_fire_hallway", "targetname");
	triggerhurt_01 trigger_on();
	
		earthquake( 0.5, 3.0, level.player.origin, 100 );
		radiusdamage (( -3006, 800, -78 ), 150, 100, 100 ); wait( 0.8 ); 
		earthquake( 0.5, 3.0, level.player.origin, 100 );
		radiusdamage (( -3006, 592, -78 ), 150, 100, 100 ); wait( 0.8 );
		earthquake( 0.5, 3.0, level.player.origin, 100 );
		radiusdamage (( -3006, 456, -78 ), 150, 100, 100 ); wait( 0.8 ); 
		earthquake( 0.5, 3.0, level.player.origin, 100 );
		radiusdamage (( -2978, 176, -78 ), 150, 100, 100 );
		
		
	

	thread atrium_side_fires();
	thread block_atrium();
    thread amb_explosion_balcony();
}



hall_radius_damage_func()
{
	
	
	
	radiusdamage (( -3006, 800, -78 ), 150, 100, 100 ); wait( 0.5 ); radiusdamage (( -3006, 592, -78 ), 150, 100, 100 ); wait( 0.5 );
	radiusdamage (( -3006, 456, -78 ), 150, 100, 100 ); wait( 0.5 ); radiusdamage (( -2978, 176, -78 ), 150, 100, 100 );
	
}



exp_notifies_for_hall()
{
	level notify ( "exp_5" );
	wait(0.8);
	level notify ( "exp_4" );
	wait(0.8);
	level notify ( "exp_3" );
	wait(0.8);
	level notify ( "exp_2" );
}




fire_block_hallway()
{
	wait(1.1);
	level notify ( "fx_fire_20" );
	fire_sound_org_20 = GetEnt( "fire_sound_org_20", "targetname" );
	fire_sound_org_20 playloopsound( "fire_A" );
	wait(0.1);
	level notify ( "fx_fire_21" );
	fire_sound_org_21 = GetEnt( "fire_sound_org_21", "targetname" );
	fire_sound_org_21 playloopsound( "fire_A" );
	wait(0.8);
	
	fire_sound_org_22 = GetEnt( "fire_sound_org_22", "targetname" );
	fire_sound_org_22 playloopsound( "fire_A" );
	wait(0.1);
	level notify ( "fx_fire_23" );
	fire_sound_org_23 = GetEnt( "fire_sound_org_23", "targetname" );
	fire_sound_org_23 playloopsound( "fire_A" );
}




atrium_side_fires()
{
	level notify ( "fx_fire_29" ); level notify ( "fx_fire_31" );
	fire_sound_org_29 = GetEnt( "fire_sound_org_29", "targetname" );
	fire_sound_org_29 playloopsound( "fire_A" );
	fire_sound_org_31 = GetEnt( "fire_sound_org_31", "targetname" );
	fire_sound_org_31 playloopsound( "fire_A" );
}




amb_explosion_balcony()
{
	trigger = getent("trigger_ambexplosion_balcony", "targetname");
	trigger waittill("trigger");
	
	thread spawn_ramp_guards();
	
	explosion2 = getent("origin_ambexplosion_balcony2", "targetname");
	explosion2 PlaySound( "side_bldg_expl" );
	playfx( level._effect[ "propane_explosion" ], explosion2.origin );
	earthquake( 0.3, 1, level.player.origin, 400 );
	
	
	wait(0.2);
	radiusdamage (( -3217, 1186, -51 ), 100, 100, 100 );
	
	wait(1.2);
	
	
	playfx( level._effect[ "propane_explosion" ], ( -3225, 1322, -9.5 ));
	earthquake( 0.3, 1, level.player.origin, 400 );
	
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
}




block_atrium()
{
	trigger = getent("trigger_block_atrium", "targetname");
	
	trigger waittill("trigger");
	
	thread lower_hall_fire();
	
	fire = getent("tag_fire_blockatrium", "targetname");
	
	block = getent( "block_atrium", "targetname" );
	earthquake( 0.5, 3.0, level.player.origin, 100 );
	block PlaySound( "block_drop" );
	
	wait( 0.2 );
	

	playfx( level._effect[ "fx_explosion" ], ( -2624, 792, -88 ));
	block PlaySound( "block_drop" );
	wait( 0.2 );
	level notify ( "column_block_start" );
	block movez(-208, 0.5);
	
	wait(0.5);

	firefx = spawnfx( level._effect["fx_fire_large"], fire.origin );
	triggerFx( firefx );

	fire playloopsound( "fire_A" );

	level waittill ( "camille_put_out_fire_02" );
	firefx delete();
	fire stoploopsound();
}




lower_hall_fire()
{
	trigger = getent("trigger_fire_lowerhall", "targetname");
	exp_org = getent( "exp_org_3", "targetname" );
	trigger waittill("trigger");
	
	thread upper_hall_block();
	
	explosion = getent("origin_explosion_lowerhall", "targetname");
	
	thread fireball_triggers();
	exp_org PlaySound( "thunderball" );
	wait( .5 );
	playfx( level._effect[ "fx_explosion" ], explosion.origin );
	wait(0.1);
	earthquake( 0.7, 1, level.player.origin, 200 );
	
	wait( .5 );	
	level notify ( "fx_fireball_1" );
	
	thread fire_block_lowerhall();
}

turn_off_fire()
{
	wait(0.5);
	self delete();
}

fireball_triggers()
{
	trigger = getentarray("triggerhurt_fireball", "targetname");
	
	wait( 0.1 );
	
	for (i=0; i<trigger.size; i++)
	{
		trigger[i] trigger_on();
		wait( 0.15 );
		trigger[i] trigger_off();
	}
}




fire_block_lowerhall()
{
	fire_block = getentarray("tag_fire_blocklowerhall", "targetname");
	for (i=0; i<fire_block.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire_block[i], "tag_origin" );
	}
	
	triggerhurt_02 = getent("triggerhurt_fire_stairs01", "targetname");
    triggerhurt_02 trigger_on();
    triggerhurt_03 = getent("triggerhurt_fire_stairs02", "targetname");
    triggerhurt_03 trigger_on();
	
	
	triggerhurt_03b = getent("triggerhurt_fire_stairs03", "targetname");
    triggerhurt_03b trigger_on();
}




upper_hall_block()
{
	floor_01 = GetEnt( "eh_sb_crack_a", "targetname" );
	trigger = getent("trigger_debris_upperhall", "targetname");
	trigger waittill("trigger");
	
	level notify ( "fx_fire_25" ); level notify ( "fx_fire_26" );
	fire_sound_org_25 = GetEnt( "fire_sound_org_25", "targetname" );
	fire_sound_org_25 playloopsound( "fire_A" );
	fire_sound_org_26 = GetEnt( "fire_sound_org_26", "targetname" );
	fire_sound_org_26 playloopsound( "fire_A" );

	exp_org = getent( "exp_org_4", "targetname" );
	

	exp_org playsound( "balance_beam_expl" );
	floor_01 hide();
	level notify ( "floor_collapse_1_start" );
	
	
	playfx( level._effect[ "fx_explosion" ], ( -2788, 1774.5, 56 ));
	playfx( level._effect[ "fx_explosion" ], ( -2788, 1899.5, 56 ));
		
		earthquake( 0.7, 1, level.player.origin, 200 );
	
	
	level notify ( "fx_fire_27" );
	fire_sound_org_27 = GetEnt( "fire_sound_org_27", "targetname" );
	fire_sound_org_27 playloopsound( "fire_A" );
}





spawn_ramp_guards()
{
	array = getentarray("spawner_ramp_guard", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_ramp");
	}
	
	
	trigger = getent("trigger_debris_upperhall", "targetname");
	trigger waittill("trigger");
	
	for (i=0; i<array.size; i++)
	{
		if (isdefined(array[i]))
		{
			array[i] thread delete_ramp_guard();
			wait(1.0);
		}
	}
	
	thread spawn_balcony_guards();
}




delete_ramp_guard()
{
	node = getnode("node_room", "targetname");
	self setgoalnode(node, 0);
	self waittill("goal");
	self delete();
}




spawn_balcony_guards()
{
	trigger = getent("trigger_spawn_rooms", "targetname");
	trigger waittill("trigger");

	

	array = getentarray("spawner_balcony_guard", "targetname");
		
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_balcony");
		wait(0.2);
	}
	
	explosion = getent("origin_explosion_balcony", "targetname");
	spawner = getent("spawner_balcony_victim", "targetname");
		
	wait(1.0);
	
	spawner stalingradspawn("guard_balcony_victim");
	victim = getent("guard_balcony_victim", "targetname");
	victim setenablesense(false);
	
	earthquake( 0.5, 1, level.player.origin, 200 );
	explosion PlaySound( "balcony_expl" );
	
	wait(0.3);

	playfx( level._effect[ "propane_explosion" ], explosion.origin );
	earthquake( 0.7, 1, level.player.origin, 200 );
	wait(0.3);
	radiusdamage ( explosion.origin, 100, 100, 100 );
	
			
	fire = getentarray("tag_fire_room01", "targetname");
	for (i=0; i<fire.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
		wait(0.05);
	}
	
	trigger = getent("triggerhurt_fire_room", "targetname");
	trigger trigger_on();
}





fuelcell_suite_setup()
{
    fuelcell = getentarray ("fuelcell_balcony", "targetname");
	level thread check_medrano_loop_anim();

	earthquake( 0.5, 1.0, level.player.origin, 400 );
	thread shake_and_dust();
	
	cover_org = getent( "cover_fuelcell_balcony_org", "targetname" );
	cover_org playsound ( "tank_reveal" );
	
	level notify ( "panel_drop_02_start" );
	for ( i = 0; i < fuelcell.size; i++ )
	{
		fuelcell[i] trigger_on();
		fuelcell[i] thread fuelcell_suite_explode();
	}
}



shake_and_dust()
{
	physicsExplosionSphere(( -3106.9, 2739.7, 50 ), 25, 25, 2 ); physicsExplosionSphere(( -2954, 2602, 43 ), 25, 25, 0.5 );
	physicsExplosionSphere(( -3002, 2541, 43 ), 25, 25, 0.5 );

	playfx( level._effect[ "face_plant" ], ( -3167, 2784, 136 )); wait( .5 + randomfloat( 2.0 ));
	playfx( level._effect[ "face_plant" ], ( -2943, 2720, 135 ));
}

fuelcell_suite_explode()
{
	medrano_glass_good = GetEntArray( "eh_medrano_glass_sb1", "targetname" );
	medrano_glass_bad = GetEntArray( "eh_medrano_glass_sb2", "targetname" );

	camille = GetEnt( "camille_balcony", "targetname" );
	self setcandamage( true );
	self waittill ( "damage" );

	fire_sound = getent( "cover_fuelcell_balcony_org", "targetname" );
	fire_sound playloopsound( "fire_A" );

	level.medrano_cutscene++;
	for ( i = 0; i < medrano_glass_bad.size; i++ )
	{
		medrano_glass_bad[i] show();
	}
	for ( i = 0; i < medrano_glass_good.size; i++ )
	{
		medrano_glass_good[i] trigger_off();
	}
	camille LockAlertState( "alert_red" );

	thread medrano_special_camera();
	level.camille_dead++;
	level thread check_wall_cell();
	wait( .1 );
	radiusdamage (self.origin, 80, 100, 100 );
	earthquake( 0.5, 1, self.origin, 400 );
	playfx( level._effect[ "fx_explosion" ], self.origin );
	playfx( level._effect[ "fx_explosion" ], ( -2876, 3003, 87 ));
	playfx( level._effect[ "fx_explosion" ], ( -2877, 2945, 87 ));
	playfx( level._effect[ "fx_explosion" ], ( -2879, 2960, 27 ));
	level.player playsound ( "green_room_expl" );

	wait( 1.0 );
	
	
	level notify("endmusicpackage");

	self delete();

	medrano_broken_wall_01 = getent("medrano_wall_broken01", "targetname");
	medrano_broken_wall_02 = getent("medrano_wall_broken02", "targetname");

	medrano_clean_wall_01 = getent("medrano_wall_clean01", "targetname");
	medrano_clean_wall_02 = getent("medrano_wall_clean02", "targetname");

	collision = getent("medrano_suite_collision", "targetname");

	collision delete();

	

	medrano_clean_wall_01 delete();
	medrano_clean_wall_02 delete();

	medrano_broken_wall_01 show();
	medrano_broken_wall_02 show();

	flag_set("fuelcell_suite_destroyed");
	wait( 2 );
	blocker = GetEnt( "medrano_blocker", "targetname" );
	blocker trigger_off();
	wait( 10 );
	
	camille = GetEnt( "camille_balcony", "targetname" );
	camille gun_remove();
	
	
	
	
	
}



shut_down_camille_ai()
{
	self thread camille_check_damage();
	self LockAlertState( "alert_green" );
	self SetEnableSense( false );
	self setpainenable( false );
	self.health = 1000000;
}



check_cut_scene_pop()
{
	wait( 13 );
	if( level.medrano_cutscene <= 0 )
	{
		earthquake( 0.7, 2, level.player.origin, 400 );
		wait( 0.2 );
		setblur( 5.0, 0.5 );
		wait( 1.0 );
		setblur( 0.0, 0.1 );
	}
}



medrano_special_camera()
{
	
	level.player hideviewmodel();
	level.player FreezeControls( true );
	thread time_scale_cutscene();
	
	cameraID_medrano_fly = level.player customCamera_Push( "world", ( -2967.86, 2949.41, 86.72 ), ( 6.77, 5.21, 0.00 ), 2.5 );
	letterbox_on( false, false );
	wait( 15 );
	level.player customcamera_pop( cameraID_medrano_fly, 2.0 );
	
	level.player showviewmodel();
	earthquake( 1.0, 2, level.player.origin, 720 );
	setblur( 5.0, 0.5 );
	wait( 1.0 );
	setblur( 0.0, 0.1 );
	wait( 1.5 );
	letterbox_off();
	level.player FreezeControls( false );
}



bullet_flies_to_medrano()
{
	camille = GetEnt( "camille_balcony", "targetname" );
	camille waittillmatch( "anim_notetrack", "camille_shoot" );
	start_bullet = GetEnt( "bullet_start", "targetname" );
	end_bullet = GetEnt( "bullet_end", "targetname" );
	
	playfx( level._effect[ "muzzle_flash" ], start_bullet.origin );
	magicbullet( "p99", start_bullet.origin, end_bullet.origin );
}















camille_check_damage()
{
	self waittill ( "damage", amount, ent );
	if ( ent == level.player )
	{
		missionfailed();
	}
}



camille_runaway()
{
	self SetEnableSense( false );
}



check_wall_cell()
{
	if ( !IsCutsceneLoopSec( "Eco_MedranoDeath" ))
	{
		SkipCutSceneSection ( "Eco_MedranoDeath" );
		wait( 0.1 );
		SkipCutSceneSection ( "Eco_MedranoDeath" );
		wait( 0.1 );
		SkipCutSceneSection ( "Eco_MedranoDeath" );
	}
	else
	{
		SkipCutSceneSection ( "Eco_MedranoDeath" );
	}
}




check_medrano_loop_anim()
{
	while ( 1 )
	{
		wait( .1 );
		if ( IsCutsceneLoopSec( "Eco_MedranoDeath" ))
		{
			wait( 5.0 );
			if ( level.camille_dead == 0 )
			{
				level thread bond_speaks_to_camille_02();
				SkipCutSceneSection ( "Eco_MedranoDeath" );
				wait( .2 );
				missionfailed();
				break;
			}
		}
	}
}




spawn_suite()
{
	trigger = getent("trigger_medrano_balcony", "targetname");
	trigger waittill("trigger");

	thread fuelcell_suite_setup();
	
	level thread camille_medrano_speak();
	level thread medrano_death_scene_end();
	level thread camille_bond_speak();
	
	node = getnode("node_shut_door", "targetname");
	node2 = getnode("node_medrano_shot", "targetname");
	node3 = getnode("node_camille_shoot", "targetname");
	node4 = getnode("node_camille_open", "targetname");
	door = getent("suite_sliding_door", "targetname");
	door2 = getent("suite_sliding_dooropen", "targetname");
		
	playcutscene( "Eco_MedranoDeath", "medrano_dead" );

	fake_camille = getent ( "fake_camille", "targetname" )  stalingradspawn( "fake_camille" );
	fake_camille waittill( "finished spawning" );
	fake_camille hide();
	fake_camille thread shut_down_camille_ai();

	thread check_cut_scene_pop();

	thread bullet_flies_to_medrano();
	

	flag_wait("fuelcell_suite_destroyed");
	level notify ( "bedroom_doors_start" );
	flag_set("suite_located");
	level thread start_camille_dialog();
	
	fire = getentarray("tag_fire_suite", "targetname");
	for (i=0; i<fire.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
		wait(0.05);
	}
	
	
	
	triggerhurt_05 = getent("triggerhurt_fire_balcony", "targetname");
    triggerhurt_05 trigger_on();
	
	thread spawn_outside_suite();
	thread spawn_atrium_lower();
	thread balance_beam();
}

start_camille_dialog()
{
	wait(5.0);
	level notify("medrano_dead");
}



time_scale_cutscene()
{
	wait( 6 );
	SetSavedDVar( "timescale", ".5" );
	wait( 2 );
	SetSavedDVar( "timescale", "1.0" );
}



kill_ents_fire()
{
	fire_dome_boom = getentarray( "fire_dome_boom", "targetname" );
	for ( i = 0; i < fire_dome_boom.size; i++ )
	{
		fire_dome_boom[i] delete();
	}

	new_fire_dome_01 = getentarray( "new_fire_dome_01", "targetname" );
	for ( i = 0; i < new_fire_dome_01.size; i++ )
	{
		new_fire_dome_01[i] delete();
	}

	new_exp_dome_01 = getentarray( "new_exp_dome_01", "targetname" );
	for ( i = 0; i < new_exp_dome_01.size; i++ )
	{
		new_exp_dome_01[i] delete();
	}

	fire_dome_doorway = getentarray( "fire_dome_doorway", "targetname" );
	for ( i = 0; i < fire_dome_doorway.size; i++ )
	{
		fire_dome_doorway[i] delete();
	}
}



camille_medrano_speak()
{
	camille = GetEnt( "camille_balcony", "targetname" );
	wait( 2 );
	
	camille play_dialogue( "MEDR_EcohG_034A", true );
	camille play_dialogue( "CAMI_EcohG_035A", true );
}



medrano_death_scene_end()
{
	level waittill ( "medrano_dead" );
	camille = GetEnt( "camille_balcony", "targetname" );
	org_camille = GetEnt( "medrano_suit_audio_dist", "targetname" );
	
	
	
	

	
	
			
			
			SetSavedDVar( "timescale", "1.0" );
			level.player play_dialogue( "BOND_EcohG_601A" );
	
	
	

	
	level notify("playmusicpackage_bond");
}



camille_bond_speak()
{
	level waittill ( "medrano_dead" );
	org_camille = GetEnt( "medrano_suit_audio_dist", "targetname" );
	camille = GetEnt( "camille_balcony", "targetname" );
	level endon( "dome_fight_begin" );
	while ( 1 )
	{
		wait( 5.0 );
		dist = Distance( level.player.origin, org_camille.origin );

		if ( dist <= 75 )
		{
			camille play_dialogue( "CAMI_EcohG_042A" );
			wait( 12.0 );
		}
		else if ( dist <= 125 )
		{
			camille play_dialogue( "CAMI_EcohG_041A" );
			wait( 12.0 );
		}
	}
}




spawn_outside_suite()
{
	trigger = getent("trigger_outside_suite", "targetname");
	trigger waittill("trigger");
	
	level notify ( "fx_fire_28" );
	fire_sound_org_28 = GetEnt( "fire_sound_org_28", "targetname" );
	fire_sound_org_28 playloopsound( "fire_A" );

	level notify ( "fx_fire_29" ); level notify ( "fx_fire_30" ); level notify ( "fx_fire_31" );
	fire_sound_org_30 = GetEnt( "fire_sound_org_30", "targetname" );
	fire_sound_org_30 playloopsound( "fire_A" );
}







balance_beam_look_at()
{
	trigger = getent( "trigger_balance_event01_look_at", "targetname" );
	trigger waittill( "trigger" );
	level notify ( "trigger_balance_event" );
}



balance_beam_trigger()
{
	trigger = getent( "trigger_balance_event01", "targetname" );
	trigger waittill( "trigger" );
	level notify ( "trigger_balance_event" );
}

balance_beam()
{
	floor_02b = GetEnt( "eh_sb_crack_b2", "targetname" );

	level waittill ( "trigger_balance_event" );

	thread balance_save();
	
	thread balance_explosions();
	thread fire_spout();
	
	trigger = getent("trigger_balance_event02", "targetname");
	trigger waittill("trigger");
	
	trigger = getent("trigger_balance_event03", "targetname");
	trigger waittill("trigger");

	playfx( level._effect[ "fx_explosion" ], ( -2788, 2260.5, 56 ));
	level notify ( "floor_collapse_2b_start" );
	floor_02b hide();
	
	trigger = getent("trigger_balance_event04", "targetname");
	trigger waittill("trigger");
	
	earthquake( 0.5, 1, level.player.origin, 400 );
	
	trigger = getent("trigger_balance_event05", "targetname");
	trigger waittill("trigger");
	
	earthquake( 0.5, 1, level.player.origin, 400 );
}



balance_save()
{
	maps\_autosave::autosave_now( "eco_hotel" );
}




fire_spout()
{
	fire = getent("tag_balance_firespout", "targetname");
	triggerhurt = getent("triggerhurt_balance_01", "targetname");
	
	while(1)
	{
		playfxontag( level._effect[ "fire_spout" ], fire, "tag_origin" );
		wait( 0.2 );
		triggerhurt trigger_on();
		wait( 0.5 );
		triggerhurt trigger_off();
		wait( 2.5 );
	}
}




balance_explosions()
{
	floor_02a = GetEnt( "eh_sb_crack_b", "targetname" );
	
	exp_org = getent( "exp_org_5", "targetname" );
	fire = getentarray("tag_fire_balanceroom", "targetname");
	
	exp_org playsound( "balance_beam_expl" );
	level notify ( "floor_collapse_2a_start" );
	floor_02a hide();

	
	
	playfx( level._effect[ "propane_explosion" ], ( -2788, 2331.5, 56 ));
	playfx( level._effect[ "propane_explosion" ], ( -2788, 2190.5, 56 ));
	earthquake( 0.5, 1, level.player.origin, 400 );
		
	
	for (i=0; i<fire.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
		wait(0.05);
	}
	
	thread hallway_glass_break();
}




hallway_glass_break()
{
	explosion = getentarray("origin_hallway_glass", "targetname");
	
	for (i=0; i<explosion.size; i++)
	{
		radiusdamage( explosion[i].origin, 100, 80, 80 );
	}
	
	wait(1.5);
	
	for (i=0; i<explosion.size; i++)
	{
		radiusdamage( explosion[i].origin, 100, 200, 200 );
		wait(0.2);
	}
	wait( 0.5 );
	for ( i = 0; i < explosion.size; i++ )
	{
		explosion[i] delete();
	}
}




spawn_atrium_lower()
{
	trigger = getent("trigger_spawn_atrium", "targetname");
	trigger waittill("trigger");

	level thread check_bond_damage();

	
	
	
	
	thread spawn_atrium();
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	gate = getent("gate_atrium_outside", "targetname");
	gate connectpaths();
	gate PlaySound( "metal_door" );
	gate movez (120, 4.0);
	gate hide();
	
	array = getentarray("spawner_atrium_lower", "targetname");
	nodearray = getnodearray("node_cover_atrium", "targetname");
		
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("atrium_lower");
		array[i] setgoalnode(nodearray[i]);
	}
}



check_bond_damage()
{
	level.player waittill ( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
}



dome_door_func()
{
	door_node = Getnodearray( "auto2944", "targetname" );

	
	for ( i = 0; i < door_node.size; i++ )
	{
		door_node[i] maps\_doors::open_door_from_door_node();
	}

	
	
	
	
	
}



greene_runaround_func()
{
	level waittill( "dome_fight_begin" );
	greene = getent ( "spawner_greene_runaround", "targetname" )  stalingradspawn( "greene" );
	greene waittill( "finished spawning" );
	greene LockAlertState( "alert_red" );
	greene SetEnableSense( false );
	greene setpainenable( false );
	greene SetFlashBangPainEnable ( false );

	greene thread greene_run_down_stairs();
	
	wait( .5 );
	
	greene StartPatrolRoute( "greene_shout_point_03" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_501A" ); 

	greene StartPatrolRoute( "greene_shout_point_01" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_502A" ); 

	greene StartPatrolRoute( "greene_shout_point_06" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_503A" ); 

	greene StartPatrolRoute( "greene_shout_point_04" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_504A" ); 

	greene StartPatrolRoute( "greene_shout_point_02" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_043A" ); 

	
	
	
	

	greene StartPatrolRoute( "greene_shout_point_03" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_501A" ); 

	
	
	
	

	greene StartPatrolRoute( "greene_shout_point_06" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_049A" ); 

	greene StartPatrolRoute( "greene_shout_point_04" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_50A" );

	greene StartPatrolRoute( "greene_shout_point_02" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_051A" ); 

	greene StartPatrolRoute( "greene_shout_point_05" );
	greene waittill ( "goal" );
	greene CmdAction( "CallOut" );
	greene play_dialogue( "GREE_EcohG_052A" ); 

	greene StartPatrolRoute( "greene_delete" );
	greene waittill ( "goal" );
	level notify ( "fake_greene_gone" );
	greene delete();
}



greene_run_down_stairs()
{
	level waittill( "greene_done" );
	if ( IsDefined ( self ))
	{
		self stopallcmds();
		self StartPatrolRoute( "greene_delete" );
		self waittill ( "goal" );
		level notify ( "fake_greene_gone" );
		self delete();
	}
}




check_lower()
{
	shift = false;
	shift_again = false;
	guards_initial = getentarray("atrium_lower", "targetname");
	nodes = getnodearray("node_cover_atriumne", "targetname");
	noden = getnodearray("node_cover_atriumn", "targetname");
	num_alive = guards_initial.size;
	
	while(!(shift))
	{
		guards = getentarray("atrium_lower", "targetname");
				
		if (guards.size == (num_alive-1))
		{
			for (i=0; i<guards.size; i++)
			{
				guards[i] setgoalnode(nodes[i]);
				wait(0.5);
			}
			shift = true;
		}
		wait(0.5);
	}

	while(!(shift_again))
	{
		guardarray = getentarray("atrium_lower", "targetname");
		
		if (guardarray.size == (num_alive-2))
		{
			for (i=0; i<guardarray.size; i++)
			{
				guardarray[i] setgoalnode(noden[i]);
				wait(0.5);
			}
			shift_again = true;
		}
		wait(0.5);
	}
}




spawn_atrium()
{
	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");

	thread pre_fire_notify();
	level notify( "dome_fight_begin" );

	
	level notify("playmusicpackage_atrium");

	thread release_idle_guards();
	thread block_atrium_exit();
	
	trigger = getent("trigger_spawn_atriumleft", "targetname");
	trigger waittill("trigger");
	
	thread spawn_atrium_left();
	
	trigger = getent("trigger_spawn_atrium01", "targetname");
	trigger waittill("trigger");
	
	thread spawn_lower_reinforcements();
}



pre_fire_notify()
{
	wait( 10 );
	level notify ( "pre_fire_01" );
	wait( 4.0 + randomfloat( 8.0 ));
	thread atrium_glass_fall_func();
}




block_atrium_exit()
{
	level thread greene_runaround_func();
	level thread dome_door_func();

	earthquake( 0.5, 1, level.player.origin, 400 );	
	fire = getentarray("tag_fire_atriumexit", "targetname");
	exp_org = getent( "exp_org_6", "targetname" );
	exp_org playsound( "doom_room_expl" );
	for (i=0; i<fire.size; i++)
	{
		firefx = spawnfx( level._effect["fx_fire_large"], fire[i].origin );
		triggerFx( firefx );
		firefx thread kill_atrium_fire();
		wait(0.05);
	}

	triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
    triggerhurt_06 trigger_on();

	blocker = getent("fire_blocker_03", "targetname");
	blocker trigger_on();
}



kill_atrium_fire()
{
	level waittill ( "camille_put_out_fire_01" );
	wait( 1.5 );
	self delete();
}




release_idle_guards()
{
	 array = getentarray("atrium_lower", "targetname");
		
	for (i=0; i<array.size; i++)
	{
		array[i] stopallcmds();
		wait(0.2);
	}
	
	wait(10.0);
	
	for (i=0; i<array.size; i++)
	{
		if (isdefined(array[i]))
		{
			array[i] setcombatrole("flanker");
		}
	}
	
	wait(1.0);
	
	thread spawn_lower_reinforcements();
}




spawn_lower_reinforcements()
{
	array = getentarray("spawner_atrium_01", "targetname");
	
	if (!(level.atrium_reinforced))
	{
		for (i=0; i<array.size; i++)
		{
			array[i] = array[i] stalingradspawn("atrium_reinforcements");
			wait(0.5);
		}
		
		level.atrium_reinforced = true;
	}
	
	wait(3.0);
	
	thread atrium_rusher();
}




atrium_rusher()
{
	array = getentarray("atrium_reinforcements", "targetname");
	
	if (isdefined(array[0]))
	{
		array[0] setcombatrole("rusher");
	}
	else if (isdefined(array[1]))
	{
		array[1] setcombatrole("rusher");
	}
}




spawn_atrium_left()
{
	array = getentarray("spawner_atrium_left", "targetname");
	
	if (!(level.atrium_left))
	{
		for (i=0; i<array.size; i++)
		{
			array[i] = array[i] stalingradspawn("atrium_left");
			wait(0.5);
		}
		
		level.atrium_left = true;
	}
	
	wait(5.0);
	
	thread spawn_upper_01();
	
	wait(5.0);
	
	thread spawn_upper_02();
	
	wait(5.0);
	
	thread spawn_upper_03();
	
	wait(5.0);
	
	thread check_all_dead();
}




spawn_upper_01()
{
	array = getentarray("spawner_atrium_upper01", "targetname");
	nodes = getnodearray("node_cover_upperatrium", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("atrium_upper01");
		index = randomintrange(0, 18);
		if (isdefined(array[i]) && isdefined(nodes[index]))
		{
			array[i] setperfectsense(true);
			array[i] setcombatrolelocked(true);
			array[i] setgoalnode(nodes[index]);
		}
		wait(0.5);
	}
}




spawn_upper_02()
{
	array = getentarray("spawner_atrium_upper02", "targetname");
	nodes = getnodearray("node_cover_upperatrium", "targetname");
	
	guards = getaiarray("axis");
	
	while((guards.size) > 2)
	{
		wait(0.5);
		guards = getaiarray("axis");
	}
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("atrium_upper02");
		index = randomintrange(0, 18);
		if (isdefined(array[i]) && isdefined(nodes[index]))
		{
			array[i] setperfectsense(true);
			array[i] setcombatrolelocked(true);
			array[i] setgoalnode(nodes[index]);
		}
		wait(1.5);
	}
}




spawn_upper_03()
{
	array = getentarray("spawner_atrium_upper03", "targetname");
	nodes = getnodearray("node_cover_upperatrium", "targetname");
	
	guards = getaiarray("axis");
	
	while((guards.size) > 4)
	{
		wait(0.5);
		guards = getaiarray("axis");
	}
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("atrium_upper03");
		index = randomintrange(0, 18);
		if (isdefined(array[i]) && isdefined(nodes[index]))
		{
			array[i] setperfectsense(true);
			array[i] setcombatrolelocked(true);
			array[i] setgoalnode(nodes[index]);
		}
		wait(1.2);
	}
}




check_all_dead()
{
	all_dead = false;
	
	while(!(all_dead))
	{
		guards = getaiarray("axis");
		
		if (!(guards.size))
		{
			all_dead = true;
		}
		
		wait(0.5);
	}
	
	level notify( "greene_done" );
	flag_set( "kill_greene" );
	wait( 5.0 );
	
	
}



atrium_fire_extinguisher_func()
{
	extinguisher = getent( "atrium_fire_extinguisher", "targetname" );
	atrium_fire = GetEntArray( "atrium_fire", "targetname" );
	fire_blocker = GetEnt( "fire_dome_blocker_00", "targetname" );
	fire_trigger = GetEnt( "fire_dome_01", "targetname" );

	for ( i = 0; i < atrium_fire.size; i++ )
	{
		firefx = spawnfx( level._effect["fx_fire_large"], atrium_fire[i].origin );
		triggerFx( firefx );
		firefx thread delete_fx_spawn( extinguisher );
		wait( 0.1 );
	}
	level waittill ( "kill_fire" );
	fire_blocker trigger_off();
	fire_trigger trigger_off();
}




spawn_ax_greene()
{
	
	
	

	greene = getent ( "spawner_greene_ax", "targetname" )  stalingradspawn( "greene" );
	greene waittill( "finished spawning" );
	
	thread greene_backup_atrium();
	greene LockAlertState( "alert_red" );
	greene SetEnableSense( false );
	greene SetFlashBangPainEnable ( false );
	greene setpainenable( false ) ;

	greene thread magic_bullet_shield();

	greene thread greene_shoot_from_high();

	if ( isdefined( greene ))
	{
		greene setperfectsense( true );
	}

	while(isdefined(greene))
	{
		wait(0.5);
	}

	flag_set("greene_dead");

	wait( 2.0 );
	thread camille_extinguish_fire();
	thread explosion_atrium_exit();

	thread atrium_fire_extinguisher_func();
	level notify ( "fx_fire_36" ); level notify ( "fx_fire_37" ); level notify ( "fx_fire_38" );
	level notify ( "fx_fire_47" ); level notify ( "fx_fire_49" );
	fire_sound_org_36 = GetEnt( "fire_sound_org_36", "targetname" ); fire_sound_org_37 = GetEnt( "fire_sound_org_37", "targetname" );
	fire_sound_org_38 = GetEnt( "fire_sound_org_38", "targetname" ); fire_sound_org_47 = GetEnt( "fire_sound_org_47", "targetname" );
	fire_sound_org_49 = GetEnt( "fire_sound_org_49", "targetname" );
	fire_sound_org_36 playloopsound( "fire_A" ); fire_sound_org_37 playloopsound( "fire_A" ); fire_sound_org_38 playloopsound( "fire_A" );
	fire_sound_org_47 playloopsound( "fire_A" ); fire_sound_org_49 playloopsound( "fire_A" );

	earthquake( 0.5, 1, level.player.origin, 1000 );

	explosion = getentarray("fire_dome_boom", "targetname");

	exp_org = getent( "exp_org_7", "targetname" );
	exp_org playsound( "doom_room_2_expl" );
	for (i=0; i<explosion.size; i++)
	{
		firefx00 = spawnfx( level._effect["propane_explosion"], explosion[i].origin );
		triggerFx( firefx00 );
		
		
	}

	blocker1 = getent("fire_dome_blocker_00", "targetname");
	blocker1 trigger_on();

	fire_dome_01 = getent("fire_dome_01", "targetname");
	fire_dome_01 trigger_on();
	fire_dome_02 = getent("fire_dome_02", "targetname");
	fire_dome_02 trigger_on();
	fire_dome_03 = getent("fire_dome_03", "targetname");
	fire_dome_03 trigger_on();
	fire_dome_04 = getent("fire_dome_04", "targetname");
	fire_dome_04 trigger_on();
}




































countdown_tip()
{
	level.tool_tip = newHudElem();
	level.tool_tip.x = 0;
	level.tool_tip.y = -150;
	level.tool_tip.alignX = "center";
	level.tool_tip.alignY = "middle";
	level.tool_tip.horzAlign = "center";
	level.tool_tip.vertAlign = "middle";
	level.tool_tip.foreground = true;
	level.tool_tip.fontScale = 1.50;
	level.tool_tip.alpha = 1.0;
	level.tool_tip.color = (1, 1, 1);
}



count_down_to_backup()
{
	level.time_remaining = 30;
	while( level.time_remaining >0 )
	{
		level.tool_tip settext( level.time_remaining );
		level.time_remaining--;	
		wait( 1.0 );
		level.tool_tip settext( "" );
	}
	level thread massive_back_up();
	level.tool_tip settext( "" );
}





massive_back_up()
{
	max_to_dispatch = 6;
	nb_dispatched = 0;

	greene_guards_plus = getentarray ( "greene_guards_massive", "targetname" );
	nodes = getnodearray( "node_path_massive", "targetname" );
	for ( i = 0; i < greene_guards_plus.size && nb_dispatched < max_to_dispatch; i++ )
	{
		randSpawn = randomintrange(0, greene_guards_plus.size - i );
		if (randSpawn < max_to_dispatch - nb_dispatched)
		{
			thug[nb_dispatched] = greene_guards_plus[nb_dispatched] stalingradspawn();
			index = randomintrange( 0, 18 );
			if( !maps\_utility::spawn_failed( thug[nb_dispatched] ))
			{
				thug[nb_dispatched] setperfectsense( true );
				thug[nb_dispatched] LockAlertState( "alert_red" );
				thug[nb_dispatched] setgoalnode( nodes[index] );
			}
			nb_dispatched++;
		}
	}
}



greene_backup_atrium()
{	
	spawners = GetEntArray( "greene_guards_02", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );

	

	
	
	
	
	
	
	
	
	
	
	
}



greene_fight_func()
{
	
	tank = GetEnt( "dome_panel_tank_one", "targetname" );
	tank_exp = GetEnt( "tank_exp_01", "targetname" );

	wait( 1.5 + randomfloat( 3.5 ));
	earthquake( 0.5, 1, level.player.origin, 400 );
	
	level notify ( "panel_drop_03_start" );
	tank SetCanDamage( true );
	weapon_block_01 = GetEnt( "weapon_block_01", "targetname" );
	weapon_block_01 trigger_off();
	tank waittill ( "damage" );
	self thread stop_magic_bullet_shield();
	self thread rapid_damage1();
	
	thread panel_destoryed2();
	playfx( level._effect[ "propane_explosion" ], tank_exp.origin );
	
	
	
		playfx( level._effect[ "propane_explosion" ], ( -1313.5, 959, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "propane_explosion" ], ( -1371, 1076.5, 120.5 ));
	
	
	
	
	
	
		
	
}



panel_destoryed2()
{
	panel_atrium_01 = GetEntArray( "eh_atrium_railings_b_cov_sb", "targetname" );
	panel_atrium_02 = GetEntArray( "eh_atrium_railings_c_cov_sb", "targetname" );
	panel_atrium_03 = GetEntArray( "eh_atrium_railings_d_sb", "targetname" );

	
	
	
	

	for ( i = 0; i < panel_atrium_01.size; i++ )
	{
		panel_atrium_01[i] trigger_off();
	}
	for ( i = 0; i < panel_atrium_02.size; i++ )
	{
		panel_atrium_02[i] trigger_off();
	}
	for ( i = 0; i < panel_atrium_03.size; i++ )
	{
		panel_atrium_03[i] trigger_off();
	}
}


rapid_damage1()
{
	org_node = GetEnt( "tank_exp_01", "targetname" );
	wait ( 0.1 );
	self dodamage( 200, org_node.origin );
	radiusdamage( org_node.origin, 300, 600, 650 );
	
	
	
	
}







greene_shoots()
{
	self thread greenes_final_move();
	wait( 0.5 );
	level endon ( "greene_move_final" );
	while ( 1 )
	{
		if ( IsDefined ( self ))
		{
			
			self cmdthrowgrenadeatentity ( level.player, false, -1 );
			
			wait( 3.5 + randomfloat( 4.5 ));
		}
		else if ( !IsDefined ( self ))
		{
			break;
		}
	}
}



greenes_final_move()
{
	final_node = getnode ( "greenes_final_node", "targetname" );
	level waittill ( "greene_move_final" );
	self setgoalnode( final_node, 1 );
	self waittill ( "goal" );
	self thread greene_shoots();
	self thread greene_fight_func();
}



greene_shoot_from_high()
{
	bond_position = GetEnt( "bond_position_blow_back", "targetname" );
	self waittill ( "goal" );

	self cmdshootatentityxtimes( bond_position, false, 10, 1, false );
	wait( 3.0 );
	self thread greene_fight_func2();

	node_point = GetNode ( "greenes_node_01", "targetname" );
	self setgoalnode( node_point, 1 );
	self waittill ( "goal" );
	

	
	
	
	
	
	
}



greene_fight_func2()
{
	tank = GetEnt( "dome_panel_tank_two", "targetname" );
	tank_exp = GetEnt( "tank_exp_02", "targetname" );

	
	

	
	
	
	
	
	tank SetCanDamage( true );
	weapon_block_02 = GetEnt( "weapon_block_02", "targetname" );
	weapon_block_02 trigger_off();

	
	thread count_down_to_backup();
	self thread greene_shoots();


	tank waittill ( "damage" );
	level notify ( "greene_move_final" );
	thread rapid_damage2();

	thread panel_destoryed();
	playfx( level._effect[ "propane_explosion" ], tank_exp.origin );
	
	
	
		playfx( level._effect[ "propane_explosion" ], ( -1312.5, 714.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "propane_explosion" ], ( -1382.5, 589, 120.5 ));
	
	
	
	
	
	
	
	
}



panel_destoryed()
{
	panel_atrium_01 = GetEntArray( "eh_atrium_railings_b_cov_sbr", "targetname" );
	panel_atrium_02 = GetEntArray( "eh_atrium_railings_c_cov_sbr", "targetname" );
	panel_atrium_03 = GetEntArray( "eh_atrium_railings_d_sbr", "targetname" );

	
	
	
	

	for ( i = 0; i < panel_atrium_01.size; i++ )
	{
		panel_atrium_01[i] trigger_off();
	}
	for ( i = 0; i < panel_atrium_02.size; i++ )
	{
		panel_atrium_02[i] trigger_off();
	}
	for ( i = 0; i < panel_atrium_03.size; i++ )
	{
		panel_atrium_03[i] trigger_off();
	}
}



rapid_damage2()
{
	org_node = GetEnt( "tank_exp_02", "targetname" );
	wait ( 0.1 );
	radiusdamage( org_node.origin, 200, 100, 200 );
	
	
}


atrium_glass_fall_func()
{
	earthquake( 0.6, 2.0, level.player.origin, 400 );	
	glass_fall = GetEntArray( "atrium_glass_fall", "targetname" );
	for ( i = 0; i < glass_fall.size; i++ )
	{
		radiusdamage( glass_fall[i].origin, 200, 25, 15 );
		wait( 0.3 );
	}
	earthquake( 0.6, 2.0, level.player.origin, 400 );
	for ( i = 0; i < glass_fall.size; i++ )
	{
		radiusdamage( glass_fall[i].origin, 200, 25, 15 );
		wait( 0.3 );
	}
}




check_atrium_01()
{
	all_dead = false;
	
	while(!(all_dead))
	{
		guards = getentarray("guard_01", "targetname");
		
		if (!(guards.size))
		{
			all_dead = true;
			wait(1.0);
			earthquake( 0.5, 1, level.player.origin, 400 );	
		}
		
		wait(0.5);
	}
	
	wait(1.0);
	
	
}





explosion_atrium_exit()
{
	trigger = getent("trigger_explosion_atriumexit", "targetname");
	trigger waittill("trigger");
	
	fire = getentarray( "tag_fire_escapeatrium", "targetname" );
	explosion = getentarray( "origin_explosion_atriumexit", "targetname" );
	
	wait( 3 );
	for ( i = 0; i < explosion.size; i++ )
    {
    	playfx( level._effect[ "propane_explosion" ], explosion[i].origin );
    	earthquake( 0.5, 1, level.player.origin, 1000 );
    	wait( 0.3 );
    	playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
    	wait( 0.1 );
    }
}




camille_extinguish_fire()
{
	node_extinguish = getnode("node_camille_extinguish", "targetname");
	node_wait = getnode("node_camille_wait", "targetname");
	node_over = getnode("node_camille_over", "targetname");
	node_jump = getnode("node_camille_jump", "targetname");
	

	trigger_escape = getent("trigger_camille_escape", "targetname");

	cover_block = GetEnt( "block_atrium_cover", "targetname" );
	cover_block movez ( -208, 0.5 );

	spawner = getent("spawner_camille_atrium", "targetname");
	spawner stalingradspawn("camille_extinguish");
	camille = getent("camille_extinguish", "targetname");
	camille.team = "neutral";
	camille setpainenable( false );
	camille setscriptspeed ( "sprint" );

	camille thread extinguisher_attach_func();

	exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
	exit_fire_block_01 trigger_on();

	camille gun_remove();
	camille thread camille_dies_you_fail();
	camille.health = 10000;

	cables_broken = getentarray("cables_brk", "targetname");
    for (i=0; i<cables_broken.size; i++)
    {
    	if (isdefined(cables_broken[i]))
    	{
    		cables_broken[i] show();
    	}
    }
   
	cables_clean = getentarray("cables_cln", "targetname");
    for (i=0; i<cables_clean.size; i++)
    {
    	if (isdefined(cables_clean[i]))
    	{
    		cables_clean[i] delete();
    	}
    }

	thread end_level();

	camille.team = "allies";
	camille setgoalnode(node_wait);
	camille waittill("goal");
	
	
	
	level notify ( "camille_put_out_fire_01" );

	playfx( level._effect[ "exp_extinguisher" ], ( -2656, 872, -90 ));

	thread fire_escape();
   
	
	
	camille setgoalnode( node_extinguish );
	camille waittill("goal");
	level notify ( "camille_put_out_fire_02" );

	playfx( level._effect[ "exp_extinguisher" ], ( -2312, 836, -102 ));

	if(IsDefined( camille ))
	{
		camille play_dialogue( "CAMI_EcohG_058A" );
		level.player play_dialogue_nowait( "BOND_EcohG_506A" );
	}

	
	
	
	
	
	
	
	

	fire_ramp = getentarray("tag_fire_blockramp", "targetname");
	for (i=0; i<fire_ramp.size; i++)
	{
		if (isdefined(fire_ramp[i]))
		{
			playfxontag( level._effect[ "fx_fire_large" ], fire_ramp[i], "tag_origin" );
			
		}
	}

	triggerhurt_rampback = getent("triggerhurt_fire_rampback", "targetname");
    triggerhurt_rampback trigger_on();

	
	
	
	

	
	
	
	

	

	
	
	
	
	

	camille setgoalnode( node_over );

	

	triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
	triggerhurt_06 trigger_off();

	triggerhurt_blocker = getent("triggerhurt_atrium_blocker", "targetname");
	triggerhurt_blocker trigger_off();

	blocker = getent("fire_blocker_03", "targetname");
	blocker thread release_blocker();

	camille waittill("goal");

	wait( .5 );

	camille thread wave_come_over();

	thread dust_fall_end();
	earthquake( 0.5, 1, level.player.origin, 400 );

	fire_jump = getentarray( "tag_fire_blockjump", "targetname" );
	playfx( level._effect[ "propane_explosion" ], ( -3020, 903, -110 ));
	final_blocker = GetEnt( "final_blocker", "targetname" );
	final_blocker trigger_on();
	for ( i = 0; i < fire_jump.size; i++ )
	{
		if ( isdefined( fire_jump[i] ))
		{
			playfxontag( level._effect[ "fx_fire_large" ], fire_jump[i], "tag_origin" );
			wait( 0.05 );
		}
	}

	camille setgoalnode(node_jump);

	wait(0.5);

	triggerhurt_camille = getent("triggerhurt_camille_escape", "targetname");
	triggerhurt_camille trigger_on();

	camille waittill("goal");
}



extinguisher_attach_func()
{
	end_extinguisher_event = GetEnt( "end_extinguisher_event", "targetname" );
	

	end_extinguisher_event thread extra_damage();
	

	level waittill ( "camille_put_out_fire_02" );
	end_extinguisher_event trigger_on();

	
	
	
}



wave_come_over()
{
	if ( IsDefined ( self ))
	{
		self cmdfaceangles( 0, 0, 90 );
	}

	if ( IsDefined ( self ))
	{
		self cmdplayanim( "camille_waving", false );
	}

	
	wait( 1.0 );

	if ( IsDefined ( self ))
	{
		self stopallcmds();
	}
}



release_blocker()
{
	wait( .5 );
	playfx( level._effect[ "exp_extinguisher" ], ( -2312, 767, -107 ));
	playfx( level._effect[ "exp_extinguisher" ], ( -2313, 897, -107 ));
	wait( 2.0 );
	self trigger_off();
}



dust_fall_end()
{
	earthquake( 0.5, 1, level.player.origin, 400 );
	playfx( level._effect[ "face_plant" ], ( -2900, 992, 8 )); wait( .5 + randomfloat( 2.0 ));

	earthquake( 0.5, 1, level.player.origin, 400 );
	playfx( level._effect[ "face_plant" ], ( -3004, 812, 8 ));
}



camille_dies_you_fail()
{
	self waittill ( "death" );
	if ( level.end_scene == 0 )
	{
		missionfailed();
	}
}




fire_escape()
{
	fire1 = getentarray("tag_fire_escape", "targetname");
	for (i=0; i<fire1.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire1[i], "tag_origin" );
	}
	triggerhurt_leftexit = getent("triggerhurt_fire_leftexit", "targetname");
	triggerhurt_leftexit trigger_on();
}




end_level()
{
	trigger = getent("trigger_escape", "targetname");
	trigger waittill("trigger");

	VisionSetNaked( "eco_hotel_0", 1.5 );
	
		
	level.player playloopsound("police_helicopter_low");
	playcutscene( "Eco_Ending", "Eco_end_done" );

	eco_chopper = GetEnt( "eco_chopper", "targetname" );
	playfxontag( level._effect[ "chopper_dust" ], eco_chopper, "tag_ground" );

	level.end_scene++;
	camille = getent( "camille_extinguish", "targetname" );
	camille delete();

	thread end_camera();
	thread kill_ents_fire();
	
	
	
	earthquake( 0.5, 1, level.player.origin, 400 );
	level.player playsound ( "final_expl" );

	
	level notify("playmusicpackage_ending");

	wait( 2 );
	level notify ( "end_exp_1" );
	level notify ( "end_exp_2" );
	wait( .35 );
	
	earthquake( 0.5, 1, level.player.origin, 1400 );
	level notify ( "end_exp_3" );
	wait( .35 );

	level notify ( "end_exp_4" );
	wait( .35 );

	earthquake( 0.5, 1, level.player.origin, 1400 );
	level notify ( "end_exp_5" );
	wait( .35 );

	level notify ( "end_exp_6" );
	wait( 5 );
	
	level notify ( "play_last_dialog" );
}



end_dialog()
{
	level waittill ( "play_last_dialog" );
	wait( 5.0 );
	level.player play_dialogue( "BOND_EcohG_507A" );
	level.player play_dialogue( "CAMI_EcohG_508A" );
	level.player play_dialogue( "BOND_EcohG_511A" );
	
	level thread fade_in_black(3, false);
}




end_camera()
{
	
	level.player waittillmatch( "anim_notetrack", "fade_black" );
	level thread fade_in_black(3, false);
	wait(3.0);
	maps\_endmission::nextmission();
	level.hud_black.alpha = 0;
	level.hud_black fadeOverTime( 2.0 ); 
	level.hud_black.alpha = 1;
	
	
	
	
	
	
	
	
	
	
	
	
}




last_explosion()
{
	
	explosion02 = getentarray("origin_explosion_end2", "targetname");
	explosion03 = getentarray("origin_explosion_end3", "targetname");
	
	wait(0.5);
	
	earthquake( 0.5, 1, level.player.origin, 1400 );
	
	
	playfx( level._effect[ "propane_explosion" ], ( -3200, 899.5, -51 ));
	playfx( level._effect[ "propane_explosion" ], ( -3200, 697.5, -51 ));
	
	
	wait(0.3);
	
	earthquake( 0.5, 1, level.player.origin, 1400 );
	for (i=0; i<explosion02.size; i++)
	{
		playfx( level._effect[ "propane_explosion" ], explosion02[i].origin );
	}
	
	wait(0.2);
	
	earthquake( 0.5, 1, level.player.origin, 1400 );
	for (i=0; i<explosion03.size; i++)
	{
		playfx( level._effect[ "propane_explosion" ], explosion03[i].origin );
	}
}



vision_trigger_01()
{
	trigger = GetEnt( "vision_trigger_outside", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_0", 1.5 );
	level thread vision_trigger_02();
}



vision_trigger_02()
{
	trigger = GetEnt( "vision_trigger_inside", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_1", 1.5 );
	level thread vision_trigger_01();
	level thread vision_trigger_kitchen();
}



vision_trigger_kitchen()
{
	trigger = GetEnt( "vision_trigger_fire", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_kitchen", 1.5 );
	level thread vision_trigger_02();
	level thread vision_trigger_03();
}



vision_trigger_03()
{
	trigger = GetEnt( "vision_trigger_after_kitchen", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_2", 1.5 );
	level thread vision_trigger_kitchen();
}

display_chyron()
{
	wait(6);
	maps\_introscreen::introscreen_chyron(&"ECO_HOTEL_INTRO_01", &"ECO_HOTEL_INTRO_02", &"ECO_HOTEL_INTRO_03");
}



pre_fire_dome_fight()
{
	thread pre_fire_fight_func();
	trigger = GetEnt( "trigger_pre_fire_dome_01", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "pre_fire_01" );
}



pre_fire_fight_func()
{
	level waittill ( "pre_fire_01" );
	thread pre_exp_fight_func();

	exp_point = GetEntArray( "new_exp_dome_01", "targetname" );
	for ( i = 0; i < exp_point.size; i++ )
	{
		firefx00 = spawnfx( level._effect["fx_explosion"], exp_point[i].origin );
		triggerFx( firefx00 );
		
		physicsExplosionSphere( exp_point[i].origin, 200, 100, 35 );
		radiusdamage( exp_point[i].origin, 50, 300, 200 );
		wait( 0.1 );
	}
}



pre_exp_fight_func()
{
	fire_point = GetEntArray( "new_fire_dome_01", "targetname" );
	fire_dome_05 = getent("fire_dome_05", "targetname");
	fire_dome_06 = getent("fire_dome_06", "targetname");
	dome_badplace_01 = GetEnt( "dome_badplace_01", "targetname" );
	dome_badplace_02 = GetEnt( "dome_badplace_02", "targetname" );

	earthquake( 0.5, 1, level.player.origin, 200 );
	for ( i = 0; i < fire_point.size; i++ )
	{
		firefx2 = spawnfx( level._effect["fx_fire_large"], fire_point[i].origin );
		triggerFx( firefx2 );
		fire_point[i] playloopsound( "fire_A" );
		wait( 0.1 );
	}
	fire_dome_05 trigger_on();
	fire_dome_06 trigger_on();

	badplace_cylinder( "dome_fire_a", 0, dome_badplace_01.origin, 28, 182, "axis" );
	badplace_cylinder( "dome_fire_b", 0, dome_badplace_02.origin, 28, 182, "axis" );
}


red_light_blink_func()
{
	red_light_greene = GetEnt( "greene_lock_setup", "targetname" );
	level endon( "setup_blockers" );
	while ( 1 )
	{
		fx_red_light = SpawnFx( level._effect["light_red"], red_light_greene GetTagOrigin( "TAG_REDLIGHT" ));
		TriggerFx( fx_red_light );
		wait 1;
		fx_red_light delete();
		wait 1.5;
	}
}





blow_back_bond_func()
{
	
	trigger = GetEnt( "blow_bond_back", "targetname" );
	
	breadcrume_greene = GetEnt( "auto3001", "targetname" );
	
	trigger trigger_on();
	trigger waittill ( "trigger" );
	level.player playerSetForceCover( false, true );
	flag_set( "end_of_greene" );
	breadcrume_greene trigger_on();
	thread spawn_ax_greene();
	level notify ( "setup_blockers" );

	thread door_explode();
	wait( 0.1 );
	greene = getent ( "spawner_greene_ax", "targetname" );
	greene thread fade_to_black();

	
	level notify("playmusicpackage_greene");

	
	

	level.player FreezeControls( true );
	maps\_utility::holster_weapons();
	org = spawn( "script_origin", level.player.origin );
	org_2 = GetEnt( "bond_position_blow_back", "targetname" );
	level.player linkto( org );
	
	org MoveTo( org_2.origin, .1 );
	org waittill ( "movedone" );
	level.player shellshock( "default", 8 );
	
	level waittill ( "custom_cam_done" );
	level.player unlink();
	level.player FreezeControls( false );
	maps\_utility::unholster_weapons();
}



last_blockers()
{
	trigger = GetEnt( "geene_fight_triggers", "targetname" );
	blockers = GetEnt( "geene_fight_blockers", "targetname" );
	trigger trigger_off(); blockers trigger_off();
	level waittill ( "setup_blockers" );
	
	

	
	
	
	

	firefx1 = spawnfx( level._effect["small_fire"], ( -1904, 552, -104 )); triggerFx( firefx1 ); firefx2 = spawnfx( level._effect["small_fire"], ( -1736, 900, -96 )); triggerFx( firefx2 );
	firefx3 = spawnfx( level._effect["small_fire"], ( -1668, 832, -96 )); triggerFx( firefx3 ); firefx4 = spawnfx( level._effect["small_fire"], ( -1668, 756, -96 )); triggerFx( firefx4 );
	firefx5 = spawnfx( level._effect["fx_fire_large"], ( -2040, 1172, -96 )); triggerFx( firefx5 );	firefx6 = spawnfx( level._effect["fx_fire_large"], ( -2040, 1268, -96 )); triggerFx( firefx6 );
	firefx7 = spawnfx( level._effect["fx_fire_large"], ( -1764, 416, -104 )); triggerFx( firefx7 );
	firefx8 = spawnfx( level._effect["fx_fire_large"], ( -1911, 500, -104 )); triggerFx( firefx8 );

	wait( 2.0 );
	trigger trigger_on(); blockers trigger_on();

	trigger_end = getent("trigger_escape", "targetname");
	trigger_end waittill("trigger");

	firefx1 delete(); firefx2 delete(); firefx3 delete(); firefx4 delete(); firefx5 delete(); firefx6 delete(); firefx7 delete(); firefx8 delete();
}




































fade_to_black()
{
	level.hud_white.alpha = 0;
	level.hud_white fadeOverTime( 2.0 ); 
	level.hud_white.alpha = 1;
	earthquake( 0.5, 2.0, level.player.origin, 750 );
	
	cameraID_bond_fly = level.player customCamera_Push( "world", ( -1801.64, 805.71, -61.40 ), ( -18.83, -6.20, 0.00 ), 1.5 );
	wait( 3.0 );

	
	
	level.player customCamera_change ( cameraID_bond_fly, "world", ( -1796.39, 785.75, -35.47  ), ( -7.00, -23.30, 0.0 ), 0.1 );
	fov_transition( 56 );

	level.hud_white.alpha = 1;
	level.hud_white fadeOverTime( 2.0 ); 
	level.hud_white.alpha = 0;

	wait( 2.0 );
	level notify ( "panel_drop_04_start" );
	earthquake( 0.5, 1, level.player.origin, 400 );
	wait( 1.0 );

	level.player customcamera_pop( cameraID_bond_fly, 2.0 );
	fov_transition( 65 );
	level notify ( "custom_cam_done" );
}



door_explode()
{
	
	
	
	

	level notify ( "cafe_doors_start" );
	fire_point = GetEntArray( "fire_dome_doorway", "targetname" );

	
	
	
	

	
	

	

	for ( i = 0; i < fire_point.size; i++ )
	{
		firefx00 = spawnfx( level._effect["fx_explosion"], fire_point[i].origin );
		triggerFx( firefx00 );
		
		physicsExplosionSphere( fire_point[i].origin, 200, 100, 35 );
		firefx2 = spawnfx( level._effect["fx_fire_large"], fire_point[i].origin );
		triggerFx( firefx2 );
		firefx2 thread delete_fires();
		fire_point[i] playloopsound( "fire_A" );
		wait( 0.1 );
	}
}



delete_fires()
{
	
	
	wait( 5.0 );
	self delete();
}

antenna_func_00()
{
	self endon( "stop_antenna_func" );

	antenna = GetEnt( "antenna_00","targetname" );
	direction = true;
	max_angle = 25;
	min_angle = -25;
	duration = .8;

	while( min_angle < 0 )
	{
		if( direction == true )
		{
			antenna rotateyaw( min_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = false;
			if( min_angle < -10 )
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			antenna rotateyaw( max_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = true;	
			if( max_angle > 10 )
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}
}

antenna_func_01()
{
	self endon( "stop_antenna_func" );

	antenna = GetEnt( "antenna_01","targetname" );
	direction = true;
	max_angle = 25;
	min_angle = -25;
	duration = .7;

	while( min_angle < 0 )
	{
		if( direction == true )
		{
			antenna rotateyaw( min_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = false;
			if( min_angle < -10 )
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			antenna rotateyaw( max_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = true;	
			if( max_angle > 10 )
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}
}

antenna_func_02()
{
	self endon( "stop_antenna_func" );

	antenna = GetEnt( "antenna_02","targetname" );
	direction = true;
	max_angle = 27;
	min_angle = -27;
	duration = .7;

	while( min_angle < 0 )
	{
		if( direction == true )
		{
			antenna rotateyaw( min_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = false;
			if( min_angle < -10 )
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			antenna rotateyaw( max_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = true;	
			if( max_angle > 10 )
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}
}

antenna_func_03()
{
	self endon( "stop_antenna_func" );

	antenna = GetEnt( "antenna_03","targetname" );
	direction = true;
	max_angle = 27;
	min_angle = -27;
	duration = .8;

	while( min_angle < 0 )
	{
		if( direction == true )
		{
			antenna rotateyaw( min_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = false;
			if( min_angle < -10 )
			{
				min_angle += 10;
				duration += .1;
			}
		}
		else
		{
			antenna rotateyaw( max_angle,duration, ( duration/3 ), ( duration/3 ));
			antenna waittill( "rotatedone" );
			direction = true;	
			if( max_angle > 10 )
			{
				max_angle -= 10;
				duration += .1;
			}
		}
	}
}

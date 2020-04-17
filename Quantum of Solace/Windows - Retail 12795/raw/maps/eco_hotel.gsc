#include common_scripts\utility;
#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");


//////////////////////////////////////////////////////////////////////////////////////////
//
//	ECO Hotel
//
//////////////////////////////////////////////////////////////////////////////////////////
main()
{
	level maps\_utility::timer_init();

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

	//precache & load FX entities (do before calling _load::main) - not for ps3 branching! moved under load::main() -D.O.
	maps\_vsedan::main("v_sedan_radiant_igc");
	maps\_vsuv::main("v_suv_clean_black_radiant");
	maps\_load::main();
	maps\eco_hotel_fx::main();	
	maps\eco_hotel_amb::main();
	maps\eco_hotel_mus::main();
	
	// Phone setup
	precacheModel( "w_t_sony_phone" );
	precacheModel( "p_msc_suitcase_vesper_igc" );
	precacheShader( "compass_map_eco_hotel" );
	setminimap( "compass_map_eco_hotel", 5072, 4400, -3400, -4024 );
	maps\_phone::setup_phone();
		
	level._effect[ "power_spark_burst" ] = loadfx( "explosions/powerlines_a" );
	level._effect[ "power_spark_linger" ] = loadfx( "explosions/powerlines_f" );
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
	
	// Artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}
	
	SetDVar( "sm_SunSampleSizeNear", 0.7 );
	VisionSetNaked( "eco_hotel_0" );

	//precache the sceneanims
	PrecacheCutScene( "EcoHotel_Intro" );
	PrecacheCutScene( "Eco_MedranoDeath" );
	PrecacheCutScene( "Eco_GreeneTalk_1" );
	PrecacheCutScene( "Eco_GreeneTalk2" );
	PrecacheCutScene( "Eco_Ending" );
	precacheShellshock( "default" );

	thread setup_level();
	thread setup_objectives();
	thread skip_to_points();

	//map functions
	level thread map_level1_func();
	level thread map_level2a_func();
	level thread map_level2b_func();
	level thread map_level3_func();

	level thread spawn_suite();
	level thread parking_lot_02();
	level thread lighting_start_off();
	level thread runway_save_trigger_func();
	level thread vision_trigger_02();
	level thread spawn_main_entrance_trigger_func();
	level thread spawn_room_trigger_func();
	level thread pre_fire_dome_fight();
	level thread setting_vision();
	level thread balance_beam_look_at();
	level thread balance_beam_trigger();
	level thread small_cull_dist_func();

	thread last_blockers();
	thread dinning_room_end_save_func();
	thread shadow_01_off_func();
	thread shadow_02_off_func();
	thread shadow_03_off_func();
	thread trigger_dining_exit_func();
	thread save_before_balcony_func();
	thread fake_dome_off_func();
	thread intro_pipes_func();
	thread key_pad_func();
	thread close_entrance_gate();
	array_thread( getentarray("screensaver","targetname") , ::screensaver );

	level.cop_dead = 0;
	level.camille_dead = 0;
	level.fire_hall = 0;
	level.garage_counter = 0;
	level.kitchen_counter = 0;
	level.ai_atrium = 0;
	level.end_scene = 0;
	level.medrano_cutscene = 0;
	level.table_01 = 0;
	level.table_02 = 0;
	level.camille_shot = 0;
	level.atrium = 0;
}

//use this to kill shadows while inside eco hotel
//setdvar( "sm_sunshadowenable", 0 );

//ai kick anim
//cmdplayanim( "thug_alrt_frontkick", true );
///////////////////////////////////////////////////////////////////////////////////////
//	Level setup
///////////////////////////////////////////////////////////////////////////////////////
setup_level()
{
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
	
	railB = GetEnt( "eh_ext_rail_brk", "targetname" );	
	railB trigger_off();

	cover_fuelcell_balcony_01 = GetEnt( "cover_fuelcell_balcony_01", "targetname" );
	if ( isdefined( cover_fuelcell_balcony_01 )) //GEBE
	{
	cover_fuelcell_balcony_01 trigger_off();
	}		
	cover_fuelcell_balcony_03 = GetEnt( "cover_fuelcell_balcony_03", "targetname" );
	if ( isdefined( cover_fuelcell_balcony_03 )) //GEBE
	{
	cover_fuelcell_balcony_03 trigger_off();
	}

	kill_the_end_spawner = GetEnt( "kill_the_end_spawner", "targetname" );
	if ( isdefined( kill_the_end_spawner )) //GEBE
	{
	kill_the_end_spawner trigger_off();
	}

	eh_medrano_burn = GetEnt( "eh_medrano_burn", "targetname" );
	if ( isdefined( eh_medrano_burn )) //GEBE
	{
	eh_medrano_burn trigger_off();
	}

	triggerhurt_fire_hallway_2 =GetEnt( "triggerhurt_fire_hallway_2", "targetname" );
	if ( isdefined( triggerhurt_fire_hallway_2 )) //GEBE
	{
	triggerhurt_fire_hallway_2 trigger_off();
	}

	temp_block_main_gate = GetEnt( "temp_block_main_gate", "targetname" );
	if ( isdefined( temp_block_main_gate )) //GEBE
	{
	temp_block_main_gate trigger_off();
	}
	temp_block_main_gate ConnectPaths();

	long_hall_extra_fire = GetEnt( "long_hall_extra_fire", "targetname" );
	long_hall_extra_fire trigger_off();

	suv_collision = GetEnt( "suv_collision", "targetname" );
	suv_collision trigger_off();

	end_extinguisher_event = GetEnt( "end_extinguisher_event", "targetname" );
	end_extinguisher_event trigger_off();
	end_extinguisher_event_01 = GetEnt( "end_extinguisher_event_01", "targetname" );
	end_extinguisher_event_01 trigger_off();

	breadcrume_greene = GetEnt( "auto3001", "targetname" );
	breadcrume_greene trigger_off();

	scratch_01 = GetEnt( "scratch_01", "targetname" );
	scratch_02 = GetEnt( "scratch_02", "targetname" );
	scratch_01 hide();
	scratch_02 hide();

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
    triggerhurt_04 = getent("triggerhurt_fire_room", "targetname");
    triggerhurt_04 trigger_off();
    triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
    triggerhurt_06 trigger_off();

	final_blocker = GetEnt( "final_blocker", "targetname" );
	final_blocker trigger_off();

	trigger = GetEnt( "blow_bond_back", "targetname" );
	trigger trigger_off();

	blocker = getent("fire_blocker_03", "targetname");
	blocker trigger_off();
	blocker1 = getent("fire_dome_blocker_00", "targetname");
	blocker1 trigger_off();

	fire_dome_01 = getent("fire_dome_01", "targetname");
	fire_dome_01 trigger_off();
	fire_dome_05 = getent("fire_dome_05", "targetname");
	fire_dome_05 trigger_off();
	fire_dome_06 = getent("fire_dome_06", "targetname");
	fire_dome_06 trigger_off();

	clip_outside_dining = getent("clip_outside_dining", "targetname");
	clip_outside_dining trigger_off();

	triggerhurt_07 = getent("triggerhurt_dining_exit", "targetname");
    triggerhurt_07 trigger_off();
    
    triggerhurt_rampback = getent("triggerhurt_fire_rampback", "targetname");
    triggerhurt_rampback trigger_off();
    
    triggerhurt_leftexitA = getent("triggerhurt_fire_leftexitA", "targetname");
    triggerhurt_leftexitA trigger_off();
    
    triggerhurt_leftexitB = getent("triggerhurt_fire_leftexitB", "targetname");
    triggerhurt_leftexitB trigger_off();
    
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

	//speed of the balance beam walk
	SetSavedDVar( "bal_move_speed", 75.0 );


	//readjust balance beam settings
	SetSavedDVar( "Bal_wobble_accel", 1.025 );
	SetSavedDVar( "Bal_wobble_decel", 1.045 );

	// Define blackout HUD element
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
		level.hud_black.alpha = 0;
	}

	// Define whiteout HUD element
	if (!IsDefined(level.hud_white))
	{
		level.hud_white = newHudElem();
		level.hud_white.x = 0;
		level.hud_white.y = 0;
		level.hud_white.horzAlign = "fullscreen";
		level.hud_white.vertAlign = "fullscreen";
		level.hud_white SetShader("white", 640, 480);
		level.hud_white.alpha = 0;
	}
}

//avulaj
//this will change the map to level 1 and thread the level2 function
map_level1_func()
{
	trigger = GetEnt( "map_trigger_level1", "targetname" );
	if ( isdefined( trigger )) //GEBE		
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	level thread map_level2_func();
}
}

//avulaj
//this will change the map to level 2 and thread the level3 & level1 function
map_level2_func()
{
	trigger = GetEnt( "map_trigger_level2", "targetname" );
	if ( isdefined( trigger )) //GEBE		
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	level thread map_level1_func();
}
}

//avulaj
//this will change the map to level 2 and thread the level3 & level1 function
map_level2a_func()
{
	trigger = GetEnt( "map_trigger_level2a", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{	
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	level thread map_level3a_func();
}
}

//avulaj
//this will change the map to level 3 and thread the level4 & level2 function
map_level3a_func()
{
	trigger = GetEnt( "map_trigger_level3a", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
	level thread map_level2a_func();
}
}

//avulaj
//this will change the map to level 2 and thread the level3 & level1 function
map_level2b_func()
{
	trigger = GetEnt( "map_trigger_level2b", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	level thread map_level3b_func();
}
}

//avulaj
//this will change the map to level 3 and thread the level4 & level2 function
map_level3b_func()
{
	trigger = GetEnt( "map_trigger_level3b", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
	level thread map_level2b_func();
		
	}
}

//avulaj
//this will change the map to level 3 and thread the level4 & level2 function
map_level3_func()
{
	trigger = GetEnt( "map_trigger_level4", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level3" );
	level thread map_level4_func();
}
}

//avulaj
//this will change the map to level 4 and thread the level3 function
map_level4_func()
{
	trigger = GetEnt( "map_trigger_level3", "targetname" );
	if ( isdefined( trigger )) //GEBE	
	{
	trigger waittill ( "trigger" );
	setSavedDvar( "sf_compassmaplevel",  "level2" );
	level thread map_level3_func();
}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Level Objectives
///////////////////////////////////////////////////////////////////////////////////////
setup_objectives()
{
	//wait(47);
	level waittill ( "Eco_Intro_done" );
	objective_add( 1, "active", &"ECO_HOTEL_OBJECTIVE_ENTER_HEADER", ( 1712, -152, -56 ), &"ECO_HOTEL_OBJECTIVE_ENTER_BODY");
	
	trigger_car = getent("trigger_garage_door", "targetname");
	trigger_car waittill("trigger");

	thug = GetEnt( "spawner_police_driver", "targetname" );
	
	objective_state(1, "empty");
	
	objective_add( 2, "active", &"ECO_HOTEL_OBJECTIVE_CAR_HEADER", ( thug.origin ));

	//********************************************************************
	
	flag_wait("police_chief_dead");

	if ( isalive ( level.player ))
	{
		objective_state(2, "done");

		objective_state(1, "active");

		trigger_enter = getent("trigger_spawn_parking", "targetname");
		if ( isdefined( trigger_enter )) //GEBE	
		{
		trigger_enter waittill("trigger");
		}

		objective_state(1, "done");

		objective_add( 3, "active", &"ECO_HOTEL_OBJECTIVE_GARAGE_HEADER", ( 1216, 1688, -168 ), &"ECO_HOTEL_OBJECTIVE_GARAGE_BODY");
		wait(1.0);

		flag_wait( "all_dead_parking1" );
		objective_state( 3, "done");
	}
	
	//********************************************************************
	
	objective_add( 4, "active", &"ECO_HOTEL_OBJECTIVE_SURVIVE_HEADER", ( -120, 2200, -168 ), &"ECO_HOTEL_OBJECTIVE_SURVIVE_BODY");
	wait(2.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("exit_parking");
	objective_state( 4, "done");
	
	//********************************************************************
	
	greene = GetEnt( "spawner_greene_fuelcell", "targetname" );

	objective_add( 5, "active", &"ECO_HOTEL_OBJECTIVE_LOCATE_GREENE_HEADER", ( greene.origin ), &"ECO_HOTEL_OBJECTIVE_LOCATE_GREENE_BODY");
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("greene_spotted");
	objective_state( 5, "done");
	
	//********************************************************************
	
	objective_add( 6, "active", &"ECO_HOTEL_OBJECTIVE_KITCHEN_HEADER", ( -2687, -105.5, 23.5 ), &"ECO_HOTEL_OBJECTIVE_KITCHEN_BODY");
	wait(1.0);
	
	flag_wait("kitchen_destroyed");
	objective_state( 6, "done");
	
	//********************************************************************
	
	objective_add( 7, "active", &"ECO_HOTEL_OBJECTIVE_LOCATE_MEDRANO_HEADER", ( -2729, 2958, 38 ), &"ECO_HOTEL_OBJECTIVE_LOCATE_MEDRANO_BODY");
	wait(1.0);
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	flag_wait("suite_located");
	objective_state( 7, "done");
	
	//********************************************************************	
	
	objective_add( 8, "active", &"ECO_HOTEL_OBJECTIVE_GREENE_HEADER", ( -1558, 867, -90 ), &"ECO_HOTEL_OBJECTIVE_GREENE_BODY");
	wait(1.0);
	
	flag_wait( "kill_greene" );
	objective_state( 8, "done");
	
	//********************************************************************	

	objective_add( 9, "active", &"ECO_HOTEL_OBJECTIVE_GREENE_HEADER2", ( -1040, 840, -88 ), &"ECO_HOTEL_OBJECTIVE_GREENE_BODY2");
	wait( 1.0 );

	maps\_autosave::autosave_now( "eco_hotel" );

	level thread blow_back_bond_func();

	flag_wait( "end_of_greene" );
	objective_state( 9, "done");

	//********************************************************************	

	objective_add( 10, "active", &"ECO_HOTEL_OBJECTIVE_HEADER_KILL_GREENE", ( -1310, 882, 38 ), &"ECO_HOTEL_OBJECTIVE_BODY_KILL_GREENE");
	wait( 1.0 );
	
	flag_wait( "greene_dead" );
	objective_state( 10, "done");

	//********************************************************************	

	objective_add( 11, "active", &"ECO_HOTEL_OBJECTIVE_ESCAPE_HEADER", ( -3270.5, 901, -90 ), &"ECO_HOTEL_OBJECTIVE_ESCAPE_BODY");
	wait(1.0);

	maps\_autosave::autosave_now( "eco_hotel" );

	objective_state( 11, "done");
}

///////////////////////////////////////////////////////////////////////////////////////
//	Skip to points
///////////////////////////////////////////////////////////////////////////////////////
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

		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		exit_fire_block_01 trigger_off();

		wait( 10.0 );
		thread spawn_garage_exit();
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
		thread small_cull_dist_func();
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		if ( isdefined( exit_fire_block_01 )) //GEBE		
		{
		exit_fire_block_01 trigger_off();
	}
	}
	
	else if(Getdvar( "skipto" ) == "kitchen" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_kitchen", "targetname" );
		start_org_angles = ( 0, 0, 0 ); //GGL: need to initialize the var in the right scope
		if ( isdefined( start_org )) //GEBE		
		{
		start_org_angles = start_org.angles;
		}			
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("greene_spotted");
		
		thread spawn_kitchen();
		thread atrium_exterior_gate();
		setsaveddvar( "melee_enabled", "1" );
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		if ( isdefined( exit_fire_block_01 )) //GEBE		
		{
		exit_fire_block_01 trigger_off();
		}
		thread trigger_dining_exit_func();
		triggerhurt_fire_hallway_2 =GetEnt( "triggerhurt_fire_hallway_2", "targetname" );
		if ( isdefined( triggerhurt_fire_hallway_2 )) //GEBE		
		{
		triggerhurt_fire_hallway_2 trigger_off();
	}
	}
	
	else if(Getdvar( "skipto" ) == "balcony" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_balcony", "targetname" );
		start_org_angles = ( 0, 0, 0 ); //GGL
		if ( isdefined( start_org )) //GEBE		
		{
		start_org_angles = start_org.angles;
		}
		
		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		flag_set("kitchen_destroyed");
		
		thread amb_explosion_balcony();
		thread atrium_exterior_gate();
		thread block_atrium();
		setsaveddvar( "melee_enabled", "1" );
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		if ( isdefined( exit_fire_block_01 )) //GEBE		
		{
		exit_fire_block_01 trigger_off();

		wait( 10 );
		end_extinguisher_event_01 = GetEnt( "end_extinguisher_event_01", "targetname" );
		end_extinguisher_event_01 trigger_on();
		cover_fuelcell_balcony_01 = GetEnt( "cover_fuelcell_balcony_01", "targetname" );
		cover_fuelcell_balcony_01 hide();
	}
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
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		exit_fire_block_01 trigger_off();
		triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
		triggerhurt_06 trigger_off();
		blocker = getent("fire_blocker_03", "targetname");
		blocker trigger_off();

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

		trigger_hurt_00 = GetEnt( "triggerhurt_extinguisher_example", "targetname" );
		fire_blocker_00 = GetEnt( "fire_blocker_00", "targetname" );
		trigger_hurt_00 trigger_off();
		fire_blocker_00 trigger_off();

		setsaveddvar( "melee_enabled", "1" );
		exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
		exit_fire_block_01 trigger_off();
		broken_rail_01 = GetEnt( "broken_rail_01", "targetname" );
		broken_rail_01 trigger_off();
		broken_rail_02 = GetEnt( "broken_rail_02", "targetname" );
		broken_rail_02 trigger_off();
		greene = getent( "spawner_greene_fuelcell", "targetname" ); medrano = getent( "spawner_medrano_fuelcell", "targetname" );
		greene delete(); medrano delete();
		thread last_blockers();
		triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
		triggerhurt_06 trigger_off();
		blocker = getent("fire_blocker_03", "targetname");
		blocker trigger_off();

	}

	else if(Getdvar( "skipto" ) == "escape" )
	{
		setdvar("skipto", "0");

		start_org = getent( "skip_to_escape", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		thread atrium_exterior_gate();
		thread break_glass();
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
		broken_rail_01 = GetEnt( "broken_rail_01", "targetname" );
		broken_rail_01 trigger_off();
		broken_rail_02 = GetEnt( "broken_rail_02", "targetname" );
		broken_rail_02 trigger_off();
		greene = getent( "spawner_greene_fuelcell", "targetname" ); medrano = getent( "spawner_medrano_fuelcell", "targetname" );
		greene delete(); medrano delete();
		thread last_blockers();
		triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
		triggerhurt_06 trigger_off();
		blocker = getent("fire_blocker_03", "targetname");
		blocker trigger_off();
	}
}

//****************************************************************************************************************************************	

//avulaj
//
lighting_start_off()
{
	trigger = GetEnt( "trigger_close_gates", "targetname" );

	light_01 = GetEnt( "kitchen_light01", "targetname" );
	light_02 = GetEnt( "kitchen_light02", "targetname" );

	light_01 setlightintensity ( 0 );
	light_02 setlightintensity ( 0 );
	
	trigger waittill ( "trigger" );

	garage_door = GetEnt( "garage_door", "targetname" );
	garage_door movey( 278, 1.0 );

	light_02 setlightintensity ( 1.5 );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Greene car entering parking garage
///////////////////////////////////////////////////////////////////////////////////////
spawn_greene_car()
{	
	if(Getdvar( "skipto" ) != "" )
	{
		return;
	}
	
	thread antenna_func_00();
	thread antenna_func_01();
	thread antenna_func_02();
	thread antenna_func_03();
	thread extra_setup();

	suv_ramp = GetEnt( "suv_replace_ramp", "script_noteworthy" );
	suv_ramp hide();
	suv_ramp notsolid();

	maps\_utility::holster_weapons();
	wait( 0.1 );
	playcutscene( "EcoHotel_Intro", "Eco_Intro_done" );
	level waittill ( "Eco_Intro_done" );

	suv = GetEnt( "suv", "targetname" );
	sedan = GetEnt( "sedan", "targetname" );

	SetDVar( "sm_SunSampleSizeNear", 0.25 );
	letterbox_off();
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	suv delete();
	sedan delete();

	endcutscene( "EcoHotel_Intro" );
	wait( 0.1 );
	maps\_utility::unholster_weapons();
	wait( 0.5 );
	maps\_autosave::autosave_now( "eco_hotel" );

	camille = GetEnt( "camille", "targetname" );
	camille delete();
	thread black_white_fade();
}

//avulaj
//
extra_setup()
{
	cell_01 = GetEnt( "car_crash_cell", "targetname" );
	if ( isdefined( cell_01 ))
	{
		cell_01 trigger_off();
	}
	broken_rail_01 = GetEnt( "broken_rail_01", "targetname" );
	broken_rail_01 trigger_off();
	broken_rail_02 = GetEnt( "broken_rail_02", "targetname" );
	broken_rail_02 trigger_off();

	level thread display_chyron();
	letterbox_on(false, false);
	
	//Intro Music - crussom
	level notify("playmusicpackage_start");
	
	level.player PlaySound( "3_cars" );

	camille = GetEnt( "camille", "targetname" );
	camille gun_remove();
	wait( 0.1 );

	camille attach( "w_t_sony_phone", "TAG_WEAPON_RIGHT" );
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

//avulaj
//
black_white_fade()
{
	wait .1;
	level.player maps\_gameskill::saturateViewThread( false );
	VisionSetSecondary( 0.0, "pain_death" );

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
				//missionfailed();
				missionfailedwrapper();
			}
		}
		else if ( !level.player istouching ( trigger ))
		{
			if ( x > 0 )
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

//avulaj
//
setting_vision()
{
	trigger = GetEnt ( "trigger_reset_vision", "targetname" );
	trigger waittill ( "trigger" );
	level.player thread maps\_gameskill::saturateViewThread();
	level thread set_vision_mode();
}

//avulaj
//
set_vision_mode()
{
	trigger = GetEnt ( "trigger_set_vision", "targetname" );
	trigger waittill ( "trigger" );
	level.player thread maps\_gameskill::saturateViewThread( false );
	level thread setting_vision();
}

//avulaj
//
fake_dome_off_func()
{
	trigger = GetEnt ( "fake_dome_off_func", "targetname" );
	eh_dome_fake = GetEnt( "eh_dome_fake", "targetname" );
	trigger waittill ( "trigger" );
	eh_dome_fake trigger_off();
	thread fake_dome_on_func();
}

//avulaj
//
fake_dome_on_func()
{
	trigger = GetEnt ( "fake_dome_on_func", "targetname" );
	eh_dome_fake = GetEnt( "eh_dome_fake", "targetname" );
	trigger waittill ( "trigger" );
	eh_dome_fake trigger_on();
	thread fake_dome_off_func();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Opens parking garage door
///////////////////////////////////////////////////////////////////////////////////////
open_garage_door()
{
	trigger = getent("trigger_garage_door","targetname");
	trigger waittill("trigger");
	
	thread spawn_police_car();
	
	garage_door = getent("garage_door","targetname");
	garage_door movey(-278, 3.0);
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn police car
///////////////////////////////////////////////////////////////////////////////////////
spawn_police_car()
{	
	spawnpt = getent("origin_spawn_police", "targetname");
	start_node = getvehiclenode( "node_police_start", "targetname" );
	wait_node = getvehiclenode( "auto125", "targetname" );
	spawner = getent("spawner_police_driver", "targetname");
	spawner stalingradspawn("police_driver");

	suv_dmg_trigger_ramp = GetEnt( "suv_dmg_trigger_ramp", "targetname" );
	suv_dmg_trigger_ramp enablelinkto();
	level.police_car = getent( "police_car_chief", "targetname" );
	level.police_car.health = 100000;
	suv_dmg_trigger_ramp linkto( level.police_car, "tag_driver", ( 0, -8, 0 ), ( 0, 90, 0 ));

	driver = getent("police_driver", "targetname");
	driver.DropWeapon = false;
	driver.health = 100000;
	driver gun_remove();
	driver setenablesense( false );
	driver setpainenable( false );
	driver thread check_police_driver();

	driver thread magic_bullet_shield();

	driver thread car_check_driver_func();

	driver Teleport( level.police_car GetTagOrigin( "tag_driver" ), ( level.police_car GetTagAngles( "tag_driver")+ ( 0, 90 ,0 )), true );
	driver LinkTo( level.police_car, "tag_driver", ( 30, 0, -16 ), ( 0, 90, 0 ));

	//Garage Music Start - crussom
	level notify("playmusicpackage_garage");
	
	level.police_car PlaySound( "1_car" );
	driver thread suv_spark_scrape();
	level.police_car thread suv_tire_smoke();

	thread driver();

	thread spawn_first_parking();
}

//avulaj
//
suv_tire_smoke()
{
	wait( .8 );
	playfxontag ( level._effect["suv_smoke"], self, "tag_right_wheel_02_jnt" );
	playfxontag ( level._effect["suv_smoke_2"], self, "tag_left_wheel_02_jnt" );
}

//avulaj
//
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

	scratch_01 = GetEnt( "scratch_01", "targetname" );
	scratch_01 show();

	wait( 0.5 );
	spark_tag_01 delete();

	wait( 0.7 );
	sparxfx2 = spawnfx( level._effect["suv_sparks"], spark_tag_02.origin );
	triggerFx( sparxfx2 );

	scratch_02 = GetEnt( "scratch_02", "targetname" );
	scratch_02 show();

	wait( 0.5 );
	sparxfx2 delete();
	wait( 1.35 );
	level notify ( "suv_no_solid" );
}

driver()
{
	driver = getent("police_driver", "targetname");
	driver setenablesense( false );
	driver cmdplayanim("Gen_Civs_SitIdle_E", true);
}

//avulaj
//this does a check to see if the driver is alive
//if the driver is alive he will be killed in the crash
//a physic push will throw him through the windshield
car_check_driver_func()
{
	level thread suv_swap();
	trigger = GetEnt( "car_check_driver", "targetname" );
	trigger waittill ( "trigger" );
	wait ( .2 );
	if ( isdefined ( self ))
	{
		suv_dmg_trigger_ramp = GetEnt( "suv_dmg_trigger_ramp", "targetname" );
		suv_dmg_trigger_ramp unlink();
		suv_dmg_trigger_ramp trigger_off();
		self delete();
		wait( 0.1 );
		thug_fly = getent ("police_driver_dummy", "targetname")  stalingradspawn( "thug_fly" );
		thug_fly waittill( "finished spawning" );
		thug_fly.DropWeapon = false;
		radiusdamage( thug_fly.origin+( -5, 0, 0 ), 25, 200, 200 );
		rail = GetEnt( "eh_ext_rail_cln", "targetname" );
		rail trigger_off();
		railB = GetEnt( "eh_ext_rail_brk", "targetname" );	
		railB trigger_on();
	}
	physicsExplosionSphere( ( 3890, -144, 254 ), 200, 100, 60 );
	level notify ( "driver_dead" );

	fire_sound_car = GetEnt( "fire_sound_car", "targetname" );
	if ( isdefined( fire_sound_car )) //GEBE
	{
	fire_sound_car playloopsound( "fire_A" );
	}		

	wait( 0.7 );
	playfx( level._effect[ "face_plant" ], ( 4232, -120, 208 )); playfx( level._effect[ "face_plant" ], ( 4256, -120, 216 ));
	wait( 0.2 );
	cell_01 = GetEnt( "car_crash_cell", "targetname" );
	if ( isdefined( cell_01 ))
	{
		cell_01 trigger_on();
	}
}

//avulaj
//
suv_swap()
{
	thread make_suv_solid();
	suv = GetEnt( "suv_replace_ramp", "script_noteworthy" );
	level waittill ( "driver_dead" );
	suv PlaySound( "car_crash" );
	wait( 0.1 );
}

//avulaj
//
make_suv_solid()
{
	level waittill ( "suv_no_solid" );
	suv_collision = GetEnt( "suv_collision", "targetname" );
	suv = GetEnt( "suv_replace_ramp", "script_noteworthy" );
	suv solid();
	suv show();
	radiusdamage( suv.origin, 5, 1000, 1000 );
	if ( IsDefined ( level.police_car ))
	{
		level.police_car delete();
	}
	suv_collision trigger_on();

	if (level.player IsTouching(suv_collision))
	{
		level.player DoDamage(50000, level.player.origin);
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check if driver has been killed in time
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
check_achievement_eco()
{
	amount = undefined;
	while(IsDefined(self))
	{	
		self waittill ( "damage", amount, ent );
		if ( ent == level.player )
		{
			GiveAchievement( "Challenge_EcoHotel" ); 
		}
	}
}

//avulaj
//this simply just saves the game before the garage fight
runway_save_trigger_func()
{
	trigger = getent("runway_save_trigger","targetname");
	trigger waittill("trigger");
	maps\_autosave::autosave_now( "eco_hotel" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn first group of guards in first parking garage area
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
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

//avulaj
//
parking_lot_blocker_01()
{
	trigger = GetEnt( "office_blocker_trigger_01", "targetname" );
	trigger waittill ( "trigger" );

	// make a badplace so the AI don't come over here anymore
	badplace_cylinder( "blocker_01a", 0, ( 770, 682, -176 ), 28, 182, "axis" );
	badplace_cylinder( "blocker_01b", 0, ( 1630, 686, -176 ), 64, 182, "axis" );
	thread parking_lot_blocker_01_off();
}

//avulaj
//
parking_lot_blocker_01_off()
{
	trigger = GetEnt( "trigger_badplace_1_off", "targetname" );
	trigger waittill ( "trigger" );

	badplace_delete( "blocker_01a" );
	badplace_delete( "blocker_01b" );

	thread parking_lot_blocker_01();
}

//avulaj
//
parking_lot_blocker_02()
{
	trigger = GetEnt( "office_blocker_trigger_02", "targetname" );
	trigger waittill ( "trigger" );

	// make a badplace so the AI don't come over here anymore
	badplace_cylinder( "blocker_02a", 0, ( 1834, 1986, -176 ), 28, 182, "axis" );
	badplace_cylinder( "blocker_02b", 0, ( 1796, 2306, -176 ), 28, 182, "axis" );
	thread parking_lot_blocker_02_off();
}

//avulaj
//
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
	runaway thread check_runaway_death();
	thread check_runaway_pos();
	thread block_off_entrance();

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

//avulaj
//
check_runaway_death()
{
	self waittill ( "death" );
	level notify ( "kill_garage_node" );
}

//avulaj
//
check_runaway_pos()
{
	wait( 6.5 );
	level notify ( "kill_garage_node" );
}

//avulaj
//
block_off_entrance()
{
	level waittill ( "kill_garage_node" );
	temp_block_main_gate = GetEnt( "temp_block_main_gate", "targetname" );
	temp_block_main_gate trigger_on();
	temp_block_main_gate disconnectpaths();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards who run from 2nd parking section to 1st
///////////////////////////////////////////////////////////////////////////////////////
spawn_gate_guards()
{
	trigger = getent("trigger_close_gates", "targetname");
	trigger waittill("trigger");
	
	thread close_gates();
	thread spawn_room();
	
	spawnerarray = getentarray("spawner_parking_gate", "targetname");
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("gate_guards");
		spawnerarray[i] thread garage_counter_01();
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Close gate behind player in parking garage
///////////////////////////////////////////////////////////////////////////////////////
close_entrance_gate()
{
	trigger = getent("trigger_close_entrance", "targetname");
	trigger waittill("trigger");
	
	gate = getent("parking_entrance_gate","targetname");
	gate PlaySound( "gate_shut" );
	gate movez( -192, 1.0 );

	wait( 11.0 );
	
	rusher = getent("guard_parking_01rusher", "targetname");
	
	if (isdefined(rusher))
	{
		rusher setcombatrole("rusher");
		rusher setscriptspeed("walk");
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Open gates
///////////////////////////////////////////////////////////////////////////////////////
open_gates()
{
	partition_gate_02 = getentarray ( "parking_gate_02","targetname" );
	partition_gate_03 = getent("parking_gate_03","targetname");
	
	partition_gate_03 connectpaths();

	partition_gate_03 PlaySound( "big_gate_open" );
	
	partition_gate_03 movez(180, 5.0);
	wait( 1.5 );

	thread remove_no_sight_func();
	for ( i = 0; i < partition_gate_02.size; i++ )
	{
		partition_gate_02[i] connectpaths();
		partition_gate_02[i] movez(180, 5.0);
	}
	
}

//avulaj
//
remove_no_sight_func()
{
	no_sight_clip = GetEnt( "remove_no_sight_garage", "targetname" );
	trigger_01_damage = GetEnt( "remove_no_sight_garage_01", "targetname" );
	trigger_02_trigger = GetEnt( "remove_no_sight_garage_02", "targetname" );

	trigger_01_damage thread check_garage_trigger_01();
	trigger_02_trigger thread check_garage_trigger_02();
	thread check_garage_trigger_timer();

	level waittill ( "rushers_go" );
	no_sight_clip trigger_off(); trigger_01_damage trigger_off(); trigger_02_trigger trigger_off();
}

//avulaj
check_garage_trigger_timer()
{
	wait( 1.5 );
	level notify ( "rushers_go" );
}

//avulaj
//
check_garage_trigger_01()
{
	amount = undefined;
	self waittill ( "damage", amount, ent );
	if ( ent == level.player )
	{
		self waittill( "trigger" );
		level notify ( "rushers_go" );
	}
}

//avulaj
//

check_garage_trigger_02()
{
	self waittill( "trigger" );
	level notify ( "rushers_go" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Closes parking garage partition gates
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards in side room of 1st parking section
///////////////////////////////////////////////////////////////////////////////////////
//avulaj
//this is a backup trigger if the player moves forward without killing an AI
//the next wave will spawn
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

//avulaj
//setup a thug to shout out a vo line
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

//avulaj
//this will grab all AI that is alive and pick one to speak
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

//avulaj
//
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards coming out of main entrance
///////////////////////////////////////////////////////////////////////////////////////
//avulaj
//this is a backup trigger if the player moves forward without killing an AI
//the next wave will spawn
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
	gate playsound ( "gate_shut_small" );
	
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

///////////////////////////////////////////////////////////////////////////////////////
//	Check for surviving guards in first parking area
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Greene in garage
///////////////////////////////////////////////////////////////////////////////////////
spawn_greene_garage()
{
	wait ( 10 );
	level notify ( "spawn_parking_02" );
}

//avulaj
//this will kick off the second parking lot early if the plpayer looks in the direction
parking_lot_02_lookat()
{
	trigger = GetEnt( "trigger_lookat_parking_02", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "spawn_parking_02" );
}

//avulaj
//this will set off the second parking lot
parking_lot_02()
{
	level waittill ( "spawn_parking_02" );
	level thread green_speaks_to_thugs();
	wait( 5 );
	thread spawn_parking_rushers();
}

//avulaj
//
green_speaks_to_thugs()
{
	level.player play_dialogue( "GREE_EcohG_010A" );
	level.player play_dialogue( "GREE_EcohG_011A" );
	level.player play_dialogue_nowait( "GREE_EcohG_013B" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn elites after first parking area is cleared
///////////////////////////////////////////////////////////////////////////////////////
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

	thread check_garage2();

	flanker_thug play_dialogue( "ELG1_EcohG_014A" );
}

//avulaj
//
parking_rusher_func()
{
	if (IsDefined ( self ))
	{
		self waittill("goal");
		self setengagerule("never");
		self cmdfaceangles(0);
		self waittill("cmd_done");
	}
	wait(1.5);
	if (IsDefined ( self ))
	{
		self stopallcmds();
	}

	level waittill ( "rushers_go" );
	if (IsDefined ( self ))
	{
		self setengagerule("redalert");
		self setcombatrole("rusher");
		self setperfectsense(true);
		self setscriptspeed("walk");
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check if rushers are all in position
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Send in the rushers into first parking section
///////////////////////////////////////////////////////////////////////////////////////
send_rushers( flanker_thug )
{
	flag_wait("send_rushers");
	
	thread check_rushers();
	
	wait(1.0);
	
	flanker_thug play_dialogue_nowait ( "ELG1_EcohG_015A" );
	thread open_gates();
	thread spawn_backup();
	
	wait(2.0);
	
	spawnerarray = getentarray("spawner_backup_rushers", "targetname");
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_backup_rushers");
		spawnerarray[i] thread set_up_sense_01();
	}
	flanker_thug play_dialogue ( "ELG1_EcohG_016A" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check rushers and turn into elite after x dead
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn backup guards to rushers in 2nd parking section
///////////////////////////////////////////////////////////////////////////////////////
spawn_backup()
{
	trigger = getent("trigger_spawn_backup", "targetname");
	trigger waittill("trigger");

	thread car_roof();
	
	nodearray = getnodearray("node_cover_middle", "targetname");
	spawnerarray = getentarray("spawner_parking_backup", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_parking_backup");
		if (isdefined(spawnerarray[i]))
		{
			spawnerarray[i] setgoalnode(nodearray[i], 1);
			spawnerarray[i] thread set_up_sense_01();
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

//avulaj
//
set_up_sense_01()
{
	if (IsDefined ( self ))
	{
		self setperfectsense( true );
	}
	
	level.player waittill ( "damage" );
	
	if (IsDefined ( self ))
	{
		self setperfectsense( false );
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
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn last group of parking garage guards
///////////////////////////////////////////////////////////////////////////////////////
spawn_parking_last()
{
	gate = getent("gate_storage", "targetname");

	gate movez(120, 1.0);
	gate connectpaths();
	wait( 0.5 );

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

///////////////////////////////////////////////////////////////////////////////////////
// Check if garage is cleared
///////////////////////////////////////////////////////////////////////////////////////
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
	
	wait( 2.0 );
	maps\_autosave::autosave_now( "eco_hotel" );
	
	thread spawn_garage_exit();
}

///////////////////////////////////////////////////////////////////////////////////////
// Check if garage is cleared beforgoing fully into garage 2
///////////////////////////////////////////////////////////////////////////////////////
check_garage2()
{
	all_clear = false;

	while(!(all_clear))
	{
		guards = getaiarray("axis");

		if (!(guards.size))
		{
			all_clear = true;
		}		
		wait( 0.5 );
	}

	wait( 0.5 );
	maps\_autosave::autosave_now( "eco_hotel" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guys who unlock door out of the garage
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
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

///////////////////////////////////////////////////////////////////////////////////////
// Save after garage
///////////////////////////////////////////////////////////////////////////////////////
garage_exit()
{
	trigger = getent("trigger_exit_parking","targetname");
	trigger waittill("trigger");
	
	//Start Ambient Music - crussom
	level notify("playmusicpackage_ambient");

	level notify ( "kill_blockers" );

	broken_window = GetEnt( "broken_window", "targetname" );
	broken_window trigger_off();

	flag_set("exit_parking");
	
	trigger = getent("trigger_locker_save","targetname");
	trigger waittill("trigger");
	
	maps\_autosave::autosave_now( "eco_hotel" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Greene revealing fuelcell
///////////////////////////////////////////////////////////////////////////////////////
spawn_greene_runaway()
{
	door_node = GetNodeArray( "auto2659", "targetname" );
	door = GetEntArray( "auto2844", "targetname" );
	trigger = getent("trigger_greene_fuelcell", "targetname");
	trigger waittill("trigger");

	playcutscene( "Eco_GreeneTalk2", "Eco_GreeneTalk2_done" );

	thread suitcase_handoff();
	thread greene_hall_backup();
	thread check_bond_spotted();

	for ( i = 0; i < door_node.size; i++ )
	{
		door_node[i] maps\_doors::close_door_from_door_node();
	}
	for ( i = 0; i < door.size; i++ )
	{
		door[i] thread check_door_close();
	}
}

check_door_close()
{
	self waittill("closed");
	self maps\_doors::barred_door();
}

//avulaj
//
suitcase_handoff()
{
	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );

	greene gun_remove();
	medrano gun_remove();

	medrano attach( "p_msc_suitcase_vesper_igc", "TAG_WEAPON_RIGHT" );
}

//avulaj
//
greene_hall_backup()
{
	wait( 14 );
	thread spawn_atrium_perimeter();
}

//avulaj
//
greene_shoots_hall_panel()
{
	tag_fuelcell = GetEnt( "tag_fuelcell_explosion", "targetname" );
	self cmdshootatentityxtimes( tag_fuelcell, false, 10, 1, false );
	level notify ( "panel_drop_01_start" );
	wait( 4.0 );
	level notify ( "panel_drop_01_done" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check if Bond is spotted by Medrano or Greene
///////////////////////////////////////////////////////////////////////////////////////
check_bond_spotted()
{
	level thread check_bond_dialog();

	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );
	
	//moved -jc
	//greene play_dialogue( "GREE_EcohG_022A" );
	//medrano play_dialogue( "MEDR_EcohG_023A" );
	//iprintlnbold( "dialog2");

	//level.player play_dialogue( "BOND_EcohG_024A" );
	//level.player play_dialogue( "CAMI_EcohG_026A" );
	//wait( 2 );
	//iprintlnbold( "dialog3");
	//greene play_dialogue( "GREE_EcohG_028A" );
		

	level waittill ( "Eco_GreeneTalk2_done" );
	endcutscene( "Eco_GreeneTalk2" );

	//Start Ambient Music - crussom
	level notify("endmusicpackage");
	greene setenablesense( false );
	greene cmdidle( false, -1 );
	greene setengagerule( "never" );
	wait( .1 );
	greene stopallcmds();
	greene lockalertstate( "alert_green" );
	blocker = GetEnt( "fire_blocker_00", "targetname" );
	blocker ConnectPaths();
	thread greene_medrano_run();
}

//fix bug where cutscene notify is missed on ps3 -jc
check_bond_dialog()
{
	greene = getent( "spawner_greene_fuelcell", "targetname" );
	medrano = getent( "spawner_medrano_fuelcell", "targetname" );
	
	greene play_dialogue( "GREE_EcohG_022A" );
	medrano play_dialogue( "MEDR_EcohG_023A" );

	level.player play_dialogue( "BOND_EcohG_024A" );
	level.player play_dialogue( "CAMI_EcohG_026A" );
	wait( 3.4 );

	greene play_dialogue( "GREE_EcohG_028A" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Medrano and Greene run away when Bond is spotted
///////////////////////////////////////////////////////////////////////////////////////
greene_medrano_run()
{
	medrano = getent("spawner_medrano_fuelcell", "targetname");
	thread spawn_greene_shoot();
	medrano delete();	
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Greene revealing fuelcell
///////////////////////////////////////////////////////////////////////////////////////
spawn_greene_shoot()
{
	node_greene = getnode("node_greene_fuelcell", "targetname");
	greene = getent( "spawner_greene_fuelcell", "targetname" );

	blocker = GetEnt( "fire_blocker_00", "targetname" );

	greene thread magic_bullet_shield();
	greene setpainenable( false );

	wait( 0.1 );

	greene setgoalnode(node_greene);
	wait( 0.25 );
	greene lockalertstate( "alert_red" );

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

	tag_fuelcell_fire = getentarray( "tag_fuelcell_fire", "targetname" );
	for ( i = 0; i < tag_fuelcell_fire.size; i++ )
	{
		firefx00 = spawnfx( level._effect["fx_fire_large"], tag_fuelcell_fire[i].origin );
		triggerFx( firefx00 );
		tag_fuelcell_fire[i] playloopsound( "fire_A" );
		tag_fuelcell_fire[i] thread stop_fire_hall_sound_hall();
		firefx00 thread stop_fire_hall_fx_hall();
		wait( 0.1 );
	}

	//don't forget to turn this badplace off for the dome fight
	fx_fire_3_org = GetEnt( "badplace_fire_org_03", "targetname" ); //cords -1376, 344, 32
	badplace_cylinder( "fx_fire_03", 0, fx_fire_3_org.origin, 56, 182, "axis" );
	fx_fire_3_org playloopsound( "fire_A" );

	for ( i = 0; i < fire_extinguish.size; i++ )
	{
		firefx2 = spawnfx( level._effect["fx_fire_large"], fire_extinguish[i].origin );
		triggerFx( firefx2 );
		fire_extinguish[i] playloopsound( "fire_A" );
		fire_extinguish[i] thread stop_fire_hall_sound();
		firefx2 thread delete_fx_spawn( extinguisher );
		wait( 0.1 );
	}
	radiusdamage( explosion.origin, 25, 25, 25 );

	thread greene_enter_atrium();
	thread spawn_kitchen();
	thread kitchen_save_game();

	wait( 0.5 );

	earthquake( 0.5, 2.0, level.player.origin, 100 );

	wait(0.1);

	trigger2 = getent("triggerhurt_extinguisher_example", "targetname");
	fire_ext = getent("fire_extinguisher_drop", "targetname");

	fire_ext physicslaunch(fire_ext.origin , ((-2500.0, 0.0, 0.0)) );
	extinguisher thread extra_damage();

	wait(2.0);

	extinguisher moveto(fire_ext.origin, 0.01);
	extinguisher rotateto(fire_ext.angles, 0.01);
	wait( 0.1 );
	fire_ext delete();

	extinguisher waittill("death");

	wait( 2.0 );

	trigger2 trigger_off();
	blocker trigger_off();
}

//avulaj
//
bond_fuel_cell_talk()
{
	level.player play_dialogue( "CAMI_EcohG_019A" );
	level.player play_dialogue( "BOND_EcohG_020A" );
}


//avulaj
//this will delete the fire effect in the hall
delete_fx_spawn( extinguisher )
{
	if (IsDefined ( extinguisher ))
	{
		extinguisher waittill ( "death" );
		self delete();
		level notify ( "kill_fire" );
	}
}

//avulaj
//
stop_fire_hall_sound()
{
	level waittill ( "kill_fire" );
	self stoploopsound();
}

//avulaj
//
stop_fire_hall_sound_hall()
{
	trigger = GetEnt( "trigger_explosion_atriumexit", "targetname" );
	trigger waittill ( "trigger" );
	self stoploopsound();
}

stop_fire_hall_fx_hall()
{
	trigger = GetEnt( "trigger_explosion_atriumexit", "targetname" );
	trigger waittill ( "trigger" );
	wait( 0.1 );
	self delete();
}


///////////////////////////////////////////////////////////////////////////////////////
//	Foreshadow kitchen battle
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Guards come after Bond after Green/Medrano meeting
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
fire_hall_thug_check()
{
	self waittill ( "death" );
	level.fire_hall++;
	if ( level.fire_hall >= 2 )
	{
		flag_set( "fire_hall_boom" );
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Atrium exterior gate opens
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Grenade thrown as atrium exterior gate opens
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Greene runs into the atrium
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards who get killed by Greene shooting fuelcell
///////////////////////////////////////////////////////////////////////////////////////
spawn_greene_victims()
{
	spawnerarray = getentarray("spawner_greene_victim", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_victim");
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn kitchen guards
///////////////////////////////////////////////////////////////////////////////////////
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
	}
	wait( 0.1 );
	if (isdefined(greene))
	{
		greene delete();
	}
	
	thread spawn_kitchen_reinforce();
	thread kitchen_fires();
	thread kitchen_explosion_enter();
}

//avulaj
//
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
///////////////////////////////////////////////////////////////////////////////////////
//	Spawn kitchen reinforcements
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Start fires in kitchen
///////////////////////////////////////////////////////////////////////////////////////
kitchen_fires()
{
	fire_tag_01 = getent("tag_kitchenfire_01", "targetname");
	firefx = spawnfx( level._effect["fx_fire_large"], fire_tag_01.origin );
	triggerFx( firefx );
	firefx00 = spawnfx( level._effect["fx_fire_large"], ( -1372, -180, 18 ));
	triggerFx( firefx00 );
	level notify ( "fx_fire_9" ); //level notify ( "fx_fire_10" );

	fx_fire_7_org = GetEnt( "badplace_fire_org_07", "targetname" ); //cords -1368 -168 32
	badplace_cylinder( "fx_fire_07", 0, fx_fire_7_org.origin, 28, 182, "axis" );
	fx_fire_7_org playloopsound( "fire_A" );

	fx_fire_9_org = GetEnt( "badplace_fire_org_09", "targetname" ); //cords -1416, 48, 32
	badplace_cylinder( "fx_fire_09", 0, fx_fire_9_org.origin, 28, 182, "axis" );
	fire_sound_org_10 = GetEnt( "fire_sound_org_10", "targetname" );
	fire_sound_org_10 playloopsound( "fire_A" );

	flag_wait("start_kitchen_counter_fire");
	
	wait(3.0);
	level notify ("fx_kitchen_smoke"); //start the ceiling smoke effects
	
	explosion1 = getent("tag_kitchen_explosion1", "targetname");
	level.player PlaySound( "kitchen_expl_02" );
	level notify ( "exp_7" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	thread dining_phy_push_func();
	
	physicsExplosionSphere(( -1308, -256, 68 ), 200, 100, 15 ); physicsExplosionSphere(( -1304, -160, 68 ), 200, 100, 15 );
	physicsExplosionSphere(( -1304, -52, 68 ), 200, 100, 15 ); physicsExplosionSphere(( -1440, -144, 68 ), 200, 100, 15 );

	wait( 0.5 );
	
	thread kitchen_fire_right();
	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");
	firefx delete(); firefx00 delete();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Start fires on right side of  kitchen after explosion
///////////////////////////////////////////////////////////////////////////////////////
kitchen_fire_right()
{
	level notify ( "fx_fire_45" ); level notify ( "fx_fire_11" );

	fire_sound_org_11 = GetEnt( "fire_sound_org_11", "targetname" );
	fire_sound_org_11 playloopsound( "fire_A" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Explosion in kitchen blocks path when Bond enters
///////////////////////////////////////////////////////////////////////////////////////
kitchen_explosion_enter()
{
	exp_org = GetEnt( "exp_org", "targetname" );
	level notify ( "exp_6" );
	exp_org PlaySound( "kitchen_expl" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	thread dining_phy_push_func();
	
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

	level notify ( "fx_fire_15" ); level notify ( "fx_fire_16" ); //level notify ( "fx_fire_17" );
	level notify ( "fx_fire_50" ); level notify ( "fx_fire_41" );

	fx_fire_15_org = GetEnt( "badplace_fire_org_15", "targetname" ); //cords -1640, -360, 32
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
}

//avulaj
//this will setup a lookat trigger to blow the dining room doors open incase the player doesn't progress forward
prep_lookat_dining_func()
{
	trigger = GetEnt( "prep_lookat_trigger_dining", "targetname" );
	trigger waittill ( "trigger" );

	light_01 = GetEnt( "kitchen_light01", "targetname" );
	light_01 setlightintensity ( 1.5 );

	thread trigger_lookat_dining();
	wait( 3.0 );
	level notify ( "thread_table_thugs" );
}

//avulaj
//this func will fire off a notify if the player looks at the lookat trigger in the dining room
//the lookat trigger will set off the function kitchen_extra_shake_func
trigger_lookat_dining()
{
	trigger = GetEnt( "lookat_trigger_dining", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "blow_dining_doors" );
}

//avulaj
//this will fire off the doors blowing off in the dining room if the player progresses forward and hits the trigger
dining_trigger_func()
{
	trigger = GetEnt( "kitchen_extra_shake", "targetname" );
	trigger waittill ( "trigger" );
	wait( 0.5 );
	level notify ( "blow_dining_doors" );
}

//avulaj
//
kitchen_extra_shake_func()
{
	level waittill ( "blow_dining_doors" );

	exp_org = GetEnt( "kitchen_extra_exp_org", "targetname" );
	playfx( level._effect[ "fx_explosion" ], exp_org.origin );
	level notify ( "dining_doors_start" );
	exp_org PlaySound( "dining_doors_exp" );
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	thread dining_phy_push_func();
}

//avulaj
//
kitchen_phy_push_func()
{
	trigger = GetEnt( "kitchen_door_flyby", "targetname" );
	trigger waittill ( "trigger" );

	fire_tag = getent( "tag_kitchenfire_off_shoot", "targetname" );
	
	firefx = spawnfx( level._effect["fx_fire_large"], fire_tag.origin );
	//level notify ( "kitchen_single_start" );
	triggerFx( firefx );
	playfx( level._effect[ "fx_explosion" ], ( -1193, 184, 79 ));
	fire_tag PlaySound ( "door_fly" );
	physicsExplosionSphere(( -1193, 184, 79 ), 200, 100, 35 );
}

//avulaj
//
dining_phy_push_func()
{
	physicsExplosionSphere(( -2024, -336, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2176, -400, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2304, -376, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2376, -296, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2184, -200, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2088, -32, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -1992, 64, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2408, -136, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2416, -40, 152 ), 75, 25, 2 ); physicsExplosionSphere(( -2360, 72, 152 ), 75, 25, 2 );
	physicsExplosionSphere(( -2464, 144, 152 ), 75, 25, 2 );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Explosion in kitchen blocks path in middle of room
///////////////////////////////////////////////////////////////////////////////////////
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
	thread dining_phy_push_func();
	
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
	thread dining_phy_push_func();
	
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn kitchen table turnover
///////////////////////////////////////////////////////////////////////////////////////
table_turnover()
{
	trigger = getent("trigger_spawn_table", "targetname");
	trigger waittill("trigger");
	
	guard = getent("spawner_kitchen_table", "targetname");
	guard stalingradspawn("guard_table");
	
	thread dining_table();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Dining table knocked over
///////////////////////////////////////////////////////////////////////////////////////
dining_table()
{
	trigger = getent("trigger_turnover_table", "targetname");
	trigger waittill("trigger");
	
	table = getent("dining_table", "targetname");
	
	table playsound ( "table_flip_01" );
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn kitchen guards when Bond extinguishes first fire
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Fire extinguisher puts out fire in kitchen
///////////////////////////////////////////////////////////////////////////////////////
kitchen_fire_extinguisher1()
{
	//extinguisher = getent( "kitchen_extinguisher1", "targetname" );
	ext_replace = getent("kitchen_extinguisher1a", "targetname");

	trigger = getent("trigger_hurtfire_kitchen01", "targetname");
	blocker = getent("fire_blocker_01", "targetname");
	
	//extinguisher thread extinguisher_second_drop( ext_replace );
	ext_replace thread extinguisher_second_drop();
	thread extinguisher_third_drop();
	
	ext_replace thread extra_damage();
	ext_replace waittill( "death" );
	trigger trigger_off();
	blocker trigger_off();
	blocker ConnectPaths();
	self delete();
	badplace_delete( "fire_tag002" );
}

//avulaj
//
//extinguisher_second_drop( ext_replace )
extinguisher_second_drop()
{
	trigger = GetEnt( "kitchen_ext_fall_2", "targetname" );
	trigger waittill ( "trigger" );
	
	trigger playsound ( "kitchen_expl_mini_01" );
	earthquake( 0.4, 1.5, level.player.origin, 100 );
	//self physicslaunch( self.origin+( 10, 0, 0 ), (( 0.0, -10000.0, -10000.0 )));

	//wait( 2.0 );

	//phy_clip = GetEntArray( "phy_fire_01", "targetname" );
	//for ( i = 0; i < phy_clip.size; i++ )
	//{
	//	phy_clip[i] trigger_off();
	//}


	//ext_replace moveto( self.origin, 0.01 );
	//ext_replace rotateto( self.angles, 0.01 );
	//wait( 0.5 );
	//self delete();
}

//avulaj
//
extinguisher_third_drop()
{
	trigger = GetEnt( "kitchen_ext_fall_3", "targetname" );
	trigger waittill ( "trigger" );

	trigger playsound ( "kitchen_expl_mini_02" );
	earthquake( 0.4, 1.5, level.player.origin, 100 );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Fire extinguisher puts out fire in kitchen mid section
///////////////////////////////////////////////////////////////////////////////////////
kitchen_fire_extinguisher2()
{
	extinguisher = getent("kitchen_extinguisher3a", "targetname");
	trigger = getent("trigger_hurtfire_kitchen03", "targetname");
	blocker = getent("fire_blocker_02", "targetname");
	
	extinguisher thread extra_damage();

	extinguisher waittill( "death" );
	trigger trigger_off();
	blocker trigger_off();
	blocker ConnectPaths();
	self delete();

	badplace_delete( "fire_tag001" );
}

//avulaj
//
extra_damage()
{
	self waittill( "damage" );
	wait( 1.0 );
	radiusdamage ( self.origin, 15, 50, 50 ); 
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn kitchen backups
///////////////////////////////////////////////////////////////////////////////////////
spawn_kitchen_backup()
{
	spawnerarray = getentarray("spawner_kitchen_03", "targetname");
	
	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_kitchen_backup");
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Explosion in kitchen at the end of the counters
///////////////////////////////////////////////////////////////////////////////////////
kitchen_explosion_counterend()
{	
	playfx( level._effect[ "fx_explosion" ], ( -1827, 129, 78 ));
	earthquake( 0.4, 3.0, level.player.origin, 100 );
	thread dining_phy_push_func();
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn dining room guards
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn dining room exit
///////////////////////////////////////////////////////////////////////////////////////

//avulaj
//when this is triggered it will send a notify to spawn thugs and flip tables
trigger_dining_exit_func()
{
	trigger = getent( "trigger_dining_exit", "targetname" );
	trigger waittill("trigger");
	level notify ( "thread_table_thugs" );
}

spawn_dining_exit()
{
	wood_01 = GetEnt( "table_wood_01", "targetname" );
	wood_02 = GetEnt( "table_wood_02", "targetname" );
	
	level waittill ( "thread_table_thugs" );

	wood_01 trigger_off();
	wood_02 trigger_off();

	thread dining_table_exit01();
	thread dining_table_exit02();
	thread retreat_dining_room();
	
	spawner_dining_exit = getentarray ( "spawner_dining_exit", "targetname" );
	for ( i = 0; i < spawner_dining_exit.size; i++ )
	{
		thug_01[i] = spawner_dining_exit[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug_01[i]) )
		{
			thug_01[i] thread dining_table_exit01_check();
		}
	}

	wait( 1.0 );

	spawner_dining_exit02 = getentarray ( "spawner_dining_exit02", "targetname" );
	for ( i = 0; i < spawner_dining_exit02.size; i++ )
	{
		thug_02[i] = spawner_dining_exit02[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug_02[i]) )
		{
			thug_02[i] thread dining_table_exit02_check();
		}
	}

	spawner = getent("spawner_dining_exitrusher", "targetname");
	spawner stalingradspawn("dining_rusher");
	rusher = getent("dining_rusher", "targetname");
	rusher setscriptspeed("walk");
}

///////////////////////////////////////////////////////////////////////////////////////
//	Dining tables knocked over by exit
///////////////////////////////////////////////////////////////////////////////////////
dining_table_exit01()
{
	trigger = getent("trigger_turnover_table01", "targetname");
	trigger waittill("trigger");

	level.table_01++;
	
	table = getent("dining_table_exit01", "targetname");
	
	table playsound ( "table_flip_01" );
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}

//avulaj
//if the table doesn't get fliped this will remove the cover brush
dining_table_exit01_check()
{
	wood_01 = GetEnt( "table_wood_01", "targetname" );
	table_block_01 = GetEnt( "table_block_01", "targetname" );

	self waittill ( "death" );
	if ( level.table_01 == 0 )
	{
		table_block_01 trigger_off();
		wood_01 trigger_on();
	}
}

dining_table_exit02()
{
	trigger = getent("trigger_turnover_table02", "targetname");
	trigger waittill("trigger");

	level.table_02++;
	
	table = getent("dining_table_exit02", "targetname");
	
	table playsound ( "table_flip_01" );
	table rotatepitch(15.0, 0.4, 0.0, 0.4);
	
	wait(0.2);
	
	table rotatepitch(75.0, 0.6, 0.6);
}

//avulaj
//if the table doesn't get fliped this will remove the cover brush
dining_table_exit02_check()
{
	wood_02 = GetEnt( "table_wood_02", "targetname" );
	table_block_02 = GetEnt( "table_block_02", "targetname" );

	self waittill ( "death" );
	if ( level.table_02 == 0 )
	{
		table_block_02 trigger_off();
		wood_02 trigger_on();
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Trigger retreat from dining room
///////////////////////////////////////////////////////////////////////////////////////
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
					guards[i] setcombatrole("rusher");
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

///////////////////////////////////////////////////////////////////////////////////////
//	Explosion outside of the dining room by the atrium
///////////////////////////////////////////////////////////////////////////////////////
perimeter_explosion()
{
	trigger = getent("trigger_perimeter_explosion", "targetname");
	trigger waittill("trigger");
	
	if ( !level.ps3 )
	{
		thread hallway_fires();
	}
	
	thread spawn_hallway_victims();
	
	explosion = getent("tag_perimeter_explosion", "targetname");
	explosion PlaySound( "dining_secondary_exp" );
	playfxontag( level._effect[ "fx_explosion" ], explosion, "tag_origin" );
	earthquake( 0.7, 3.0, level.player.origin, 100 );
	thread dining_phy_push_func();
	
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

//avulaj
//this will just save as soon as the player exits the dinning room
dinning_room_end_save_func()
{
	trigger = GetEnt( "dinning_room_end_save", "targetname" );
	trigger waittill ( "trigger" );
	maps\_autosave::autosave_now( "eco_hotel" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Set fires to hallway outside the dining room
///////////////////////////////////////////////////////////////////////////////////////
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
    
    clip_outside_dining = getent("clip_outside_dining", "targetname");
	clip_outside_dining trigger_on();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn the guards in the hallway next to the balcony
///////////////////////////////////////////////////////////////////////////////////////
spawn_hallway_victims()
{
	trigger = getent("trigger_hallway_victims", "targetname");
	trigger waittill("trigger");

	flag_set("kitchen_destroyed");
	
	array = getentarray("spawner_hallway_guards", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_hallway");
		array[i] thread explode_guards();
	}
	
	wait(1.5);
	
	thread hallway_explosions();
	thread glass_break();
	thread balcony2_save_func();
}

//avulaj
//
explode_guards()
{
	level waittill ( "blow_guards" );
	wait( 2.0 );
	if (IsDefined ( self ))
	{
		radiusdamage ( self.origin+( -5, 0, 0 ), 10, 200, 200 );
	}
}

//avulaj
//
balcony2_save_func()
{
	trigger = getent( "balcony2_save", "targetname" );
	trigger waittill( "trigger");

	maps\_autosave::autosave_now( "eco_hotel" );
	thread alt_dialog_camille_bond();
}

//avulaj
//
alt_dialog_camille_bond()
{
	level.player play_dialogue( "CAMI_EcohG_029A" );
	level.player play_dialogue( "Headset_Gunshot" );
	level.player play_dialogue( "CAMI_EcohG_800A" );
	level.player play_dialogue( "MEDR_EcohG_033A" );
	level.player play_dialogue( "CAMI_EcohG_801A" );
	level.player play_dialogue( "BOND_EcohG_032A" );
	
	//Music for run to Medrano - CRussom
	level notify("playmusicpackage_medrano");
}

glass_break()
{
	radiusdamage (( -2799.5, 318.5, -39.5 ), 50, 100, 100);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Set off explosions in the hallway
///////////////////////////////////////////////////////////////////////////////////////
hallway_explosions()
{
	exp_org = GetEnt( "exp_org_2", "targetname" );
	
	thread	fire_block_hallway();
	
	level thread exp_notifies_for_hall();

	exp_org PlaySound( "dining_exp" );
	level notify ( "blow_guards" );
	triggerhurt_01 = getent("triggerhurt_fire_hallway", "targetname");
	triggerhurt_01 trigger_on();
	earthquake( 0.5, 3.0, level.player.origin, 100 );
	earthquake( 0.5, 3.0, level.player.origin, 100 );
	earthquake( 0.5, 3.0, level.player.origin, 100 );
	earthquake( 0.5, 3.0, level.player.origin, 100 );

	thread atrium_side_fires();
	thread block_atrium();
    thread amb_explosion_balcony();

	wait( 0.5 );
	triggerhurt_fire_hallway_2 = GetEnt( "triggerhurt_fire_hallway_2", "targetname" );
	triggerhurt_fire_hallway_2 trigger_on();
}

//avulaj
//
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

///////////////////////////////////////////////////////////////////////////////////////
// Fire in hallway after explosions
///////////////////////////////////////////////////////////////////////////////////////
fire_block_hallway()
{
	wait( 1.1 );
	fire_org_20 = GetEnt( "fire_sound_org_20", "targetname" );
	fire_org_20 playloopsound( "fire_A" );
	firefx1 = spawnfx( level._effect["fx_fire_large"], fire_org_20.origin );
	triggerFx( firefx1 );

	wait( 0.1 );
	fire_org_20a = GetEnt( "fire_sound_org_20a", "targetname" );
	fire_org_20a playloopsound( "fire_A" );
	firefx2 = spawnfx( level._effect["fx_fire_large"], fire_org_20a.origin );
	triggerFx( firefx2 );

	wait( 0.1 );
	fire_org_21 = GetEnt( "fire_sound_org_21", "targetname" );
	fire_org_21 playloopsound( "fire_A" );
	firefx3 = spawnfx( level._effect["fx_fire_large"], fire_org_21.origin );
	triggerFx( firefx3 );

	wait( 0.8 );
	fire_org_22 = GetEnt( "fire_sound_org_22", "targetname" );
	fire_org_22 playloopsound( "fire_A" );
	firefx4 = spawnfx( level._effect["fx_fire_large"], fire_org_22.origin );
	triggerFx( firefx4 );

	wait( 0.1 );
	fire_org_22a = GetEnt( "fire_sound_org_22a", "targetname" );
	fire_org_22a playloopsound( "fire_A" );
	firefx5 = spawnfx( level._effect["fx_fire_large"], fire_org_22a.origin );
	triggerFx( firefx5 );
	long_hall_extra_fire = GetEnt( "long_hall_extra_fire", "targetname" );
	long_hall_extra_fire trigger_on();

	wait( 0.1 );
	fire_org_23 = GetEnt( "fire_sound_org_23", "targetname" );
	fire_org_23 playloopsound( "fire_A" );
	firefx6 = spawnfx( level._effect["fx_fire_large"], fire_org_23.origin );
	triggerFx( firefx6 );

	trigger_end = getent("trigger_escape", "targetname");
	trigger_end waittill("trigger");

	firefx1 delete(); firefx2 delete(); firefx3 delete(); firefx4 delete(); firefx5 delete(); firefx6 delete();
 }

///////////////////////////////////////////////////////////////////////////////////////
//	Set fires next to atrium opening
///////////////////////////////////////////////////////////////////////////////////////
atrium_side_fires()
{
	level notify ( "fx_fire_29" ); level notify ( "fx_fire_31" );
	fire_sound_org_29 = GetEnt( "fire_sound_org_29", "targetname" );
	fire_sound_org_29 playloopsound( "fire_A" );
	fire_sound_org_31 = GetEnt( "fire_sound_org_31", "targetname" );
	fire_sound_org_31 playloopsound( "fire_A" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Ambient explosion while on balcony
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Explosion blocks access to atrium after balcony
///////////////////////////////////////////////////////////////////////////////////////
block_atrium()
{
	trigger = getent("trigger_block_atrium", "targetname");
	cover_fuelcell_balcony_01 = GetEnt( "cover_fuelcell_balcony_01", "targetname" );
	cover_fuelcell_balcony_02 = GetEnt( "cover_fuelcell_balcony_02", "targetname" );
	cover_fuelcell_balcony_03 = GetEnt( "cover_fuelcell_balcony_03", "targetname" );
	cover_fuelcell_balcony_03 thread swap_last_panel( cover_fuelcell_balcony_01 );

	trigger waittill("trigger");
	
	block_sound = getent("fire_sound_org_29", "targetname");
	
	block_sound playsound( "stairs_expl" );
	
	thread lower_hall_fire();
	
	fire = getent("tag_fire_blockatrium", "targetname");
	
	block = getent( "block_atrium", "targetname" );
	earthquake( 0.5, 3.0, level.player.origin, 100 );
	level.player PlaySound( "block_drop" );
	
	wait( 0.2 );
	
	playfx( level._effect[ "fx_explosion" ], ( cover_fuelcell_balcony_02.origin ));
	playfx( level._effect[ "fx_explosion" ], ( -2624, 792, -88 ));
	wait( 0.2 );
	level notify ( "column_block_start" );
	cover_fuelcell_balcony_02 trigger_off();
	cover_fuelcell_balcony_01 trigger_on();
	block movez(-208, 0.5);
	
	wait(0.5);

	firefx = spawnfx( level._effect["fx_fire_large"], fire.origin );
	triggerFx( firefx );

	fire playloopsound( "fire_A" );

	level waittill ( "camille_put_out_fire_01" );
	firefx delete();
	fire stoploopsound();
}

//avulaj
//
swap_last_panel( cover_fuelcell_balcony_01 )
{
	flag_wait( "greene_dead" );
	self trigger_on();
	cover_fuelcell_balcony_01 trigger_off();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Lower hallway explosion and fire
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Fire blocks lower hallway
///////////////////////////////////////////////////////////////////////////////////////
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
}

///////////////////////////////////////////////////////////////////////////////////////
//	Upper hallway explosion and debris blockage
///////////////////////////////////////////////////////////////////////////////////////
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

	exp_org playsound( "stairs_expl" );
	floor_01 hide();
	level notify ( "floor_collapse_1_start" );
	playfx( level._effect[ "fx_explosion" ], ( -2788, 1774.5, 56 ));
	playfx( level._effect[ "fx_explosion" ], ( -2788, 1899.5, 56 ));
	earthquake( 0.7, 1, level.player.origin, 200 );
	
	level notify ( "fx_fire_27" );
	fire_sound_org_27 = GetEnt( "fire_sound_org_27", "targetname" );
	fire_sound_org_27 playloopsound( "fire_A" );
}


///////////////////////////////////////////////////////////////////////////////////////
//	Spawn the guards running into the upper rooms
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Delete guard once he reaches the room
///////////////////////////////////////////////////////////////////////////////////////
delete_ramp_guard()
{
	node = getnode("node_room", "targetname");
	self setgoalnode(node, 0);
	self waittill("goal");
	self delete();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on balcony
///////////////////////////////////////////////////////////////////////////////////////
spawn_balcony_guards()
{
	trigger = getent("trigger_spawn_rooms", "targetname");
	trigger waittill("trigger");

	array = getentarray("spawner_balcony_guard", "targetname");
		
	for ( i = 0; i < array.size; i++ )
	{
		array[i] = array[i] stalingradspawn("guard_balcony");
		wait( 0.2 );
	}
	
	explosion = getent("origin_explosion_balcony", "targetname");
	spawner = getent("spawner_balcony_victim", "targetname");
		
	wait( 1.0 );
	
	spawner stalingradspawn("guard_balcony_victim");
	victim = getent("guard_balcony_victim", "targetname");
	victim setenablesense(false);
	
	earthquake( 0.5, 1, level.player.origin, 200 );
	explosion PlaySound( "balcony_expl" );
	
	wait( 0.3 );

	playfx( level._effect[ "propane_explosion" ], explosion.origin );
	earthquake( 0.7, 1, level.player.origin, 200 );
	wait( 0.3 );
	radiusdamage ( victim.origin+( 5, 0, 0 ), 10, 200, 200 );
			
	fire = getentarray("tag_fire_room01", "targetname");
	for (i=0; i<fire.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
		wait( 0.05 );
	}
	
	trigger = getent("triggerhurt_fire_room", "targetname");
	trigger trigger_on();
	wait( 2.0 );

	badplace_cylinder( "balcony_fire", 0, ( -3070.5, 2085, 18 ), 28, 182, "axis" );

	trigger_bad_place = getent( "trigger_balance_event01", "targetname" );
	trigger_bad_place waittill ( "trigger" );

	badplace_delete( "balcony_fire" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Fuelcell next to Medrano's suite                                                 //
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
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
	eh_medrano_burn = GetEnt( "eh_medrano_burn", "targetname" );
	camille = GetEnt( "camille_balcony", "targetname" );
	
	self setcandamage( true );
	self waittill ( "damage" );
	level.player hideViewModel();
	level.camille_shot++;

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
	thread medrano_hide_pop();
	level.camille_dead++;
	level thread check_wall_cell();
	wait( .05 );
	radiusdamage (self.origin, 80, 100, 100 );
	earthquake( 0.5, 1, self.origin, 400 );

	playfx( level._effect[ "fx_explosion" ], self.origin );
	playfx( level._effect[ "fx_explosion" ], ( -2824, 2987, 38 ));
	playfx( level._effect[ "fx_explosion" ], ( -2879, 2960, 27 ));
	eh_medrano_burn trigger_on();
	level.player playsound ( "green_room_expl" );
	
	level thread stop_music_suite();
	
	self delete();

	medrano_broken_wall_01 = getent("medrano_wall_broken01", "targetname");
	medrano_broken_wall_02 = getent("medrano_wall_broken02", "targetname");

	medrano_clean_wall_01 = getent("medrano_wall_clean01", "targetname");
	medrano_clean_wall_02 = getent("medrano_wall_clean02", "targetname");

	medrano_clean_wall_01 delete();
	medrano_clean_wall_02 delete();

	medrano_broken_wall_01 show();
	medrano_broken_wall_02 show();

	flag_set("fuelcell_suite_destroyed");
	wait( 12 );
	camille = GetEnt( "camille_balcony", "targetname" );
	camille gun_remove();
}

stop_music_suite()
{
	wait( 1.0 );
	
	//Stop Music - Crussom
	level notify("endmusicpackage");
}

//avulaj
//
shut_down_camille_ai()
{
	self thread camille_check_damage();
	self LockAlertState( "alert_green" );
	self SetEnableSense( false );
	self setpainenable( false );
	self.health = 1000000;
}

//avulja
//
check_cut_scene_pop()
{
	wait( 15 );
	if( level.medrano_cutscene <= 0 )
	{
		earthquake( 0.7, 2, level.player.origin, 400 );
		level.player playsound ( "distant_explo_01" );
		wait( 0.2 );
		setblur( 5.0, 0.5 );
		wait( 1.0 );
		setblur( 0.0, 0.1 );
	}
}

//avulaj
//
medrano_hide_pop()
{
	wait( 16.5 );
	earthquake( 1.0, 2, level.player.origin, 720 );
	level.player playsound ( "distant_explo_02" );
	setblur( 5.0, 0.5 );
	wait( 1.0 );
	setblur( 0.0, 0.1 );
	wait( 1.5 );
}
//avulaj
//
medrano_special_camera()
{
	level.player FreezeControls( true );
	thread time_scale_cutscene();
	cameraID_medrano_fly = level.player customCamera_Push( "world", ( -2967.86, 2949.41, 86.72 ), ( 6.77, 5.21, 0.00 ), 4.5 );
	letterbox_on( false, false );
	wait( 8 );
	level.player showViewModel();
	level.player customcamera_pop( cameraID_medrano_fly, 2.5 );
	//earthquake( 1.0, 2, level.player.origin, 720 );
	//level.player playsound ( "distant_explo_02" );
	//setblur( 5.0, 0.5 );
	//wait( 1.0 );
	//setblur( 0.0, 0.1 );
	//wait( 1.5 );
	letterbox_off();
	level.player FreezeControls( false );
}

//avulaj
//
bullet_flies_to_medrano()
{
	camille = GetEnt( "camille_balcony", "targetname" );
	camille waittillmatch( "anim_notetrack", "camille_shoot" );
	start_bullet = GetEnt( "bullet_start", "targetname" );
	end_bullet = GetEnt( "bullet_end", "targetname" );
	playfx( level._effect[ "muzzle_flash" ], start_bullet.origin );
	magicbullet( "p99", start_bullet.origin, end_bullet.origin );
	camille playsound ( "pistol_shot" );
}

//avulaj
//
bullet_flies_to_camille()
{
	wait( 18.5 );
	if ( level.camille_shot == 0 )
	{
		level.hud_white.alpha = 0;
		level.hud_white fadeOverTime( 2.0 ); 
		level.hud_white.alpha = 1;
		end_bullet = GetEnt( "medrano_suit_audio_dist", "targetname" );
		playfx( level._effect[ "muzzle_flash" ], ( -2766, 2969.25, 42.5 ));
		magicbullet( "p99", ( -2766, 2969.25, 42.5 ), end_bullet.origin );
		end_bullet playsound ( "pistol_shot" );
	}
}

//avulaj
//
camille_check_damage()
{
	self waittill ( "damage", amount, ent );
	if ( ent == level.player )
	{
		//missionfailed();
		missionfailedwrapper();
	}
}

//avulaj
//
camille_runaway()
{
	self SetEnableSense( false );
}

//avulaj
//
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


//avulaj
//this will loop untill medrano is in his looping animation
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
				SkipCutSceneSection ( "Eco_MedranoDeath" );
				wait( .2 );
				//missionfailed();
				missionfailedwrapper();
				break;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Medrano and Camille in suite
///////////////////////////////////////////////////////////////////////////////////////
spawn_suite()
{
	trigger = getent("trigger_medrano_balcony", "targetname");
	trigger waittill("trigger");

	//thread fuelcell_suite_setup();
	thread smash_cam_medrano();
	
	level thread camille_medrano_speak();
	level thread medrano_death_scene_end();
	level thread camille_bond_speak();
	
	node = getnode("node_shut_door", "targetname");
	node2 = getnode("node_medrano_shot", "targetname");
	node3 = getnode("node_camille_shoot", "targetname");
	node4 = getnode("node_camille_open", "targetname");
	door = getent("suite_sliding_door", "targetname");
	door2 = getent("suite_sliding_dooropen", "targetname");
		
	playcutscene( "Eco_MedranoDeath", "medrano_done" );

	thread kill_extra_lights();

	thread camille_sticky_func();

	thread check_cut_scene_pop();

	thread bullet_flies_to_medrano();
	wait( 0.1 );
	thread bullet_flies_to_camille();

	flag_wait("fuelcell_suite_destroyed");
	level notify ( "bedroom_doors_start" );
	//flag_set("suite_located");
	
	fire = getentarray("tag_fire_suite", "targetname");
	for (i=0; i<fire.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire[i], "tag_origin" );
		wait(0.05);
	}
	
	thread spawn_outside_suite();
	thread spawn_atrium_lower();
	thread balance_beam();

	firefx = spawnfx( level._effect["fx_fire_large"], ( -2488, 1179, -125.25 ));
	triggerFx( firefx );
	trigger_start_greene = GetEnt( "trigger_start_greene", "targetname" );
	trigger_start_greene waittill( "trigger" );
	firefx delete();
}

//avulaj
//
smash_cam_medrano()
{
	level.player FreezeControls( true );
	level.player hideViewModel();
	cameraID_smash_cam = level.player customCamera_Push( "world", ( -3107.53, 2606.79, 94.17 ), ( 4.53, 62.76, 0.00 ), 1.5 );
	wait( 1.0 );
	fov_transition( 25 );
	wait( 0.5 );
	thread fuelcell_suite_setup();
	wait( 2.5 );
	level.player showViewModel();

	level.player customcamera_pop( cameraID_smash_cam, 2.0 );
	fov_transition( 65 );
	wait( 2.0 );
	level.player FreezeControls( false );
}

//avulaj
//this will play a sound of medrano loding a gun and cocking it
play_gun_sounds_medrano()
{
	wait( 11.0 );
	if ( level.camille_shot == 0 )
	{
		self playsound ( "load_gun" );
	}
	wait( 1.0 );
	if ( level.camille_shot == 0 )
	{
		self playsound ( "cock_gun" );
	}
}

//avulaj
//
camille_sticky_func()
{
	new_point = GetEnt( "fake_camille_new_point", "targetname" );
	fake_camille = getent ( "fake_camille", "targetname" )  stalingradspawn( "fake_camille" );
	fake_camille waittill( "finished spawning" );
	fake_camille thread play_gun_sounds_medrano();
	fake_camille hide();
	fake_camille thread shut_down_camille_ai();

	org = spawn( "script_origin", fake_camille.origin );
	fake_camille linkto( org );
	org moveto ( new_point.origin, 0.1 );
}

//avulaj
//this will set the 
kill_extra_lights()
{
	light_01 = GetEnt( "kitchen_light01", "targetname" );
	light_02 = GetEnt( "kitchen_light02", "targetname" );
	light_03 = GetEnt( "greene_light01", "targetname" );
	light_04 = GetEnt( "greene_light02", "targetname" );

	light_01 setlightintensity ( 0 );
	light_02 setlightintensity ( 0 );
	light_03 setlightintensity ( 0 );
	light_04 setlightintensity ( 0 );
}

//avulaj
//
time_scale_cutscene()
{
	wait( 6 );
	SetSavedDVar( "timescale", ".5" );
	wait( 1.0 );
	SetSavedDVar( "timescale", "1.0" );
}

//avulaj
//
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

//avulaj
//
camille_medrano_speak()
{
	camille = GetEnt( "camille_balcony", "targetname" );
	wait( 2 );
	camille play_dialogue( "MEDR_EcohG_034A", true );
	camille play_dialogue( "CAMI_EcohG_035A", true );
}

//avulaj
//
medrano_death_scene_end()
{
	level waittill ( "medrano_dead" );
	camille = GetEnt( "camille_balcony", "targetname" );
	camille play_dialogue( "CAMI_EcohG_036A" );
	level.player play_dialogue( "BOND_EcohG_601A" );
	
	//Music for Bond going heading to kick ass - CRussom
	level notify("playmusicpackage_bond");

	
	level notify ( "medrano_dead2" );
	flag_set("suite_located");
}

//avulaj
//
camille_bond_speak()
{
	level waittill ( "medrano_dead2" );
	org_camille = GetEnt( "medrano_suit_audio_dist", "targetname" );
	camille = GetEnt( "camille_balcony", "targetname" );

	level endon( "dome_fight_begin" );
	while ( 1 )
	{
		wait( 1.0 );
		dist = Distance( level.player.origin, org_camille.origin );

		if ( dist <= 40 )
		{
			camille play_dialogue( "CAMI_EcohG_042A" );
			wait( 25.0 );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on ramp to atrium
///////////////////////////////////////////////////////////////////////////////////////
spawn_outside_suite()
{
	trigger = getent("trigger_outside_suite", "targetname");
	trigger waittill("trigger");

	level notify ( "medrano_dead" );

	level notify ( "fx_fire_29" );
	level notify ( "fx_fire_30" );
	level notify ( "fx_fire_31" );
	fire_sound_org_30 = GetEnt( "fire_sound_org_30", "targetname" );
	fire_sound_org_30 playloopsound( "fire_A" );
	
	triggerhurt_leftexitA = getent("triggerhurt_fire_leftexitA", "targetname");
	triggerhurt_leftexitA trigger_on();
	
	triggerhurt_leftexitB = getent("triggerhurt_fire_leftexitB", "targetname");
	triggerhurt_leftexitB trigger_on();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Balance beam
///////////////////////////////////////////////////////////////////////////////////////

//avulaj
//
balance_beam_look_at()
{
	trigger = getent( "trigger_balance_event01_look_at", "targetname" );
	trigger waittill( "trigger" );
	level notify ( "trigger_balance_event" );
}

//avulaj
//
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
	level.player playsound ( "balance_beam_02" );
	earthquake( 0.5, 1, level.player.origin, 400 );
	level notify ( "floor_collapse_2b_start" );
	floor_02b hide();
	
	trigger = getent("trigger_balance_event04", "targetname");
	trigger waittill("trigger");
	
	level.player playsound ( "distant_explo_01" );
	earthquake( 0.5, 1, level.player.origin, 400 );
	
	trigger = getent("trigger_balance_event05", "targetname");
	trigger waittill("trigger");
	
	level.player playsound ( "balance_beam_03" );
	earthquake( 0.5, 1, level.player.origin, 400 );
}

//avulaj
//
balance_save()
{
	maps\_autosave::autosave_now( "eco_hotel" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Fire spout on balance beam
///////////////////////////////////////////////////////////////////////////////////////
fire_spout()
{
	fire = getent("tag_balance_firespout", "targetname");
	triggerhurt = getent("triggerhurt_balance_01", "targetname");
	triggerhurt trigger_on();
	i = 0;
	while( i < 8 )
	{
		playfxontag( level._effect[ "fire_spout" ], fire, "tag_origin" );
		fire PlaySound( "flame_beam" );
		i++;
		wait( 0.5 );
	}
	triggerhurt trigger_off();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Explosions that collapse floor for balance beam
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Glass breaks over hallway
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn first atrium guards
///////////////////////////////////////////////////////////////////////////////////////
spawn_atrium_lower()
{
	trigger = getent("trigger_spawn_atrium", "targetname");
	trigger waittill("trigger");

	guys = getaiarray( "axis" );
	for ( i = 0; i < guys.size; i++ )
	{
		if (isdefined( guys[i] ))
		{
			guys[i] delete();
		}
	}

	wait( 1.0 );

	level thread check_bond_damage();
	
	thread spawn_atrium();
	
	maps\_autosave::autosave_now( "eco_hotel" );
	
	gate = getent("gate_atrium_outside", "targetname");
	gate connectpaths();
	gate PlaySound( "metal_door" );
	gate movez (120, 4.0);
	gate hide();
}

//avulaj
//
check_bond_damage()
{
	level.player waittill ( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
}

//avulaj
//this will handle the door opening and closing in the dome room
dome_door_func()
{
	door_node = Getnodearray( "auto2944", "targetname" );

	for ( i = 0; i < door_node.size; i++ )
	{
		door_node[i] maps\_doors::open_door_from_door_node();
	}
}

//avulaj
//
hack_seup_for_greene()
{
	level.player play_dialogue_nowait( "GREE_EcohG_501A" );

	greene_fake = getentarray ( "spawner_greene_runaround", "targetname" );
	for ( i = 0; i < greene_fake.size; i++ )
	{
		greene[i] = greene_fake[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( greene[i]) )
		{
			greene[i] thread greene_runaround_func();
		}
	}
}

//avulaj
//this will handel greene running around yelling at thugs to kill bond
greene_runaround_func()
{
	self LockAlertState( "alert_red" );
	self SetEnableSense( false );
	self setpainenable( false );
	self SetFlashBangPainEnable ( false );

	self thread greene_run_down_stairs();
	
	wait( .5 );
	
	self StartPatrolRoute( "greene_shout_point_03" );
	self waittill ( "goal" );
	self CmdAction( "CallOut" );
	self play_dialogue( "GREE_EcohG_051A" ); 

	self StartPatrolRoute( "greene_shout_point_01" );
	self waittill ( "goal" );
	self CmdAction( "CheckEarpiece" );
	self play_dialogue( "GREE_EcohG_502A" ); 

	self StartPatrolRoute( "greene_shout_point_06" );
	self waittill ( "goal" );
	self CmdAction( "CheckWeapon" );
	self play_dialogue( "GREE_EcohG_503A" ); 

	self StartPatrolRoute( "greene_shout_point_04" );
	self waittill ( "goal" );
	self CmdAction( "CallOut" );
	self play_dialogue( "GREE_EcohG_504A" ); 

	self StartPatrolRoute( "greene_shout_point_02" );
	self waittill ( "goal" );
	self CmdAction( "CallOut" );
	self play_dialogue( "GREE_EcohG_043A" ); 

	//self StartPatrolRoute( "greene_shout_point_06" );
	//self waittill ( "goal" );
	//self CmdAction( "CheckEarpiece" );
	//self play_dialogue( "GREE_EcohG_049A" ); 

	//self StartPatrolRoute( "greene_shout_point_02" );
	//self waittill ( "goal" );
	//self CmdAction( "CallOut" );
	//self play_dialogue( "GREE_EcohG_050A" ); 

	//self StartPatrolRoute( "greene_shout_point_05" );
	//self waittill ( "goal" );
	//self CmdAction( "CheckWeapon" );
	//self play_dialogue( "GREE_EcohG_052A" ); 

	self StartPatrolRoute( "greene_delete" );
	self waittill ( "goal" );
	level notify ( "fake_greene_gone" );
	self delete();
}

//avulaj
//
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

///////////////////////////////////////////////////////////////////////////////////////
//	Check if first wave in atrium has been eliminated
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn first wave of atrium battle
///////////////////////////////////////////////////////////////////////////////////////
spawn_atrium()
{
	trigger = getent("trigger_start_greene", "targetname");
	trigger waittill("trigger");

	thread pre_fire_notify();
	level notify( "dome_fight_begin" );
	
	//Start Atrium Battle Music - Crussom
	level notify("playmusicpackage_atrium");


	thread release_idle_guards();
	thread block_atrium_exit();
	
	//trigger = getent("trigger_spawn_atriumleft", "targetname");
	//trigger waittill("trigger");

	wait( 2.0 );
	
	thread spawn_atrium_left();
	thread hack_seup_for_greene();
	
	//trigger = getent("trigger_spawn_atrium01", "targetname");
	//trigger waittill("trigger");

	wait( 1.0 );

	thread spawn_lower_reinforcements();
}

//avulaj
//
pre_fire_notify()
{
	wait( 10 );
	level notify ( "pre_fire_01" );
	wait( 4.0 + randomfloat( 8.0 ));
	thread atrium_glass_fall_func();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Block atrium exit
///////////////////////////////////////////////////////////////////////////////////////
block_atrium_exit()
{
	//level thread greene_runaround_func();
	level thread dome_door_func();

	earthquake( 0.5, 1, level.player.origin, 400 );

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

	exit_fire_block_01 = GetEnt( "exit_fire_block_01", "targetname" );
	exit_fire_block_01 trigger_on();

	exp_org = getent( "exp_org_6", "targetname" );
	exp_org playsound( "doom_room_expl" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Release idle guards to attack
///////////////////////////////////////////////////////////////////////////////////////
release_idle_guards()
{
	 array = getentarray("atrium_lower", "targetname");
		
	for (i=0; i<array.size; i++)
	{
		array[i] stopallcmds();
		wait(0.2);
	}
	
	wait( 10.0 );
	
	for (i=0; i<array.size; i++)
	{
		if (isdefined(array[i]))
		{
			array[i] setcombatrole("flanker");
		}
	}
	
	//wait(1.0);
	
	//thread spawn_lower_reinforcements();
}

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn lower reinforcements
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Turn reinforcements into rushers
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn from left room in atrium
///////////////////////////////////////////////////////////////////////////////////////
spawn_atrium_left()
{
	array00 = getentarray("spawner_atrium_lower", "targetname");
	nodearray = getnodearray("node_cover_atrium", "targetname");

	for ( i = 0; i < array00.size; i++ )
	{
		array00[i] = array00[i] stalingradspawn("atrium_lower");
		array00[i] setgoalnode(nodearray[i]);
	}

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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn upper atrium wave one
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn upper atrium wave two
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn upper atrium wave three
///////////////////////////////////////////////////////////////////////////////////////
spawn_upper_03()
{
	array = getentarray("spawner_atrium_upper03", "targetname");
	nodes = getnodearray("node_cover_upperatrium", "targetname");
	
	guards = getaiarray("axis");
	
	while((guards.size) > 4)
	{
		wait( 0.5 );
		guards = getaiarray("axis");
	}
	
	//greene_guards_plus = getentarray ( "greene_guards_massive", "targetname" );
	//for ( i = 0; i < greene_guards_plus.size; i++ )
	//{
	//	thug[i] = greene_guards_plus[i] stalingradspawn();
	//	index = randomintrange( 0, 18 );
	//	if( !maps\_utility::spawn_failed( thug[i] ))
	//	{
	//		thug[i] setperfectsense( true );
	//		thug[i] LockAlertState( "alert_red" );
	//		if (IsDefined ( nodes[index] ))
	//		{
	//			thug[i] setgoalnode( nodes[index] );
	//		}
	//	}
	//}

	for ( i = 0; i < array.size; i++ )
	{
		wait( 0.5 );
		array[i] = array[i] stalingradspawn( "atrium_upper03" );
		index = randomintrange( 0, 18 );
		if (isdefined(array[i]) && isdefined(nodes[index]))
		{
			array[i] setperfectsense( true );
			array[i] setcombatrolelocked( true );
			array[i] setgoalnode(nodes[index]);
		}
		wait(1.2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check for all enemies dead
///////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Ax Greene
///////////////////////////////////////////////////////////////////////////////////////
spawn_ax_greene()
{
	greene = getent ( "spawner_greene_ax", "targetname" )  stalingradspawn( "greene" );
	greene waittill( "finished spawning" );
	thread greene_backup_atrium();
	greene thread greene_final_fight_func();
	greene LockAlertState( "alert_red" );
	greene SetEnableSense( false );
	greene SetFlashBangPainEnable ( false );
	greene setpainenable( false ) ;
	greene setpeekallowed ( false );

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

	thread explosion_atrium_exit();

	breadcrume_greene = GetEnt( "auto3001", "targetname" );
	flag_set("greene_dead");
	breadcrume_greene trigger_on();

	thread break_glass();
	//thread the_end_func();
	thread kill_all();
	kill_the_end_spawner = GetEnt( "kill_the_end_spawner", "targetname" );
	kill_the_end_spawner trigger_on();
	radiusdamage (( -3034.5, 696, -51 ) , 5, 25, 25 );
	thread camille_extinguish_fire();

	wait( 2.0 );
	level notify ( "fx_fire_47" );
	fire_sound_org_47 = GetEnt( "fire_sound_org_47", "targetname" );
	fire_sound_org_47 playloopsound( "fire_A" );

	earthquake( 0.5, 1, level.player.origin, 1000 );

	explosion = getentarray("fire_dome_boom", "targetname");

	exp_org = getent( "exp_org_7", "targetname" );
	exp_org playsound( "doom_room_2_expl" );
	for (i=0; i<explosion.size; i++)
	{
		firefx00 = spawnfx( level._effect["propane_explosion"], explosion[i].origin );
		triggerFx( firefx00 );
	}
}

//avulaj
//this will crack the glass leading out of the hotel
break_glass()
{
	magicbullet( "p99", ( -3059.75, 697.3, -56 ), ( -2980.5, 699.25, -56 ));
}

//avulaj
//
count_down_to_backup()
{
	level thread maps\_utility::timer_start( 45 );
	//thread massive_back_up();
	thread check_greene_fight();
	level waittill ( "timer_ended" );
	level notify ( "time_done_backup" );
}

//avulaj
//when greene is killed the timer will be killed and the back up will spawn
//a new timer will be threaded from here
check_greene_fight()
{
	flag_wait( "greene_dead" );
	level notify ( "kill_timer" );
	level notify ( "time_done_backup" );
	wait( 0.1 );
	
	level endon ( "kill_timer" );
	
	level thread maps\_utility::timer_start( 30 );
	level waittill ( "timer_ended" );

	level.player playsound ( "green_tank_expl" );
	playfx( level._effect[ "propane_explosion" ], level.player.origin+( 25, 0, 0 ) );
	playfx( level._effect[ "propane_explosion" ], level.player.origin+( 0, 25, 0 ) );
	playfx( level._effect[ "propane_explosion" ], level.player.origin+( -25, 0, 0 ) );
	playfx( level._effect[ "propane_explosion" ], level.player.origin+( 0, -25, 0 ) );
	wait( 1.5 );
	level.player dodamage( 500, level.player.origin );
}

//avulaj
//
massive_back_up()
{
	level waittill ( "time_done_backup" );
	greene_guards_plus = getentarray ( "greene_guards_massive", "targetname" );
	nodes = getnodearray( "node_path_massive", "targetname" );
	for ( i = 0; i < greene_guards_plus.size; i++ )
	{
		thug[i] = greene_guards_plus[i] stalingradspawn();
		index = randomintrange( 0, 18 );
		if( !maps\_utility::spawn_failed( thug[i] ))
		{
			thug[i] setperfectsense( true );
			thug[i] LockAlertState( "alert_red" );
			thug[i] setgoalnode( nodes[index] );
		}
	}
}

//avulaj
//
greene_backup_atrium()
{	
	spawners = GetEntArray( "greene_guards_02", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

//avulaj
//
greene_fight_func()
{
	tank = GetEnt( "dome_panel_tank_one", "targetname" );
	tank_exp = GetEnt( "tank_exp_01", "targetname" );
	fuel_cell_boom_clip_02 = GetEnt( "fuel_cell_boom_clip_02", "targetname" );

	wait( 1.5 + randomfloat( 3.5 ));
	earthquake( 0.5, 1, level.player.origin, 400 );
	level.player playsound ( "distant_explo_01" );
	level notify ( "panel_drop_03_start" );
	tank SetCanDamage( true );
	weapon_block_01 = GetEnt( "weapon_block_01", "targetname" );
	weapon_block_01 trigger_off();
	tank waittill ( "damage" );
	
	level thread slo_mo_time();
		
	fuel_cell_boom_clip_02 trigger_off();
	wait( 0.1 );

	self thread stop_magic_bullet_shield();
	self thread rapid_damage1();
	tank_exp playsound ( "green_tank_expl" );
	thread panel_destoryed2();

	playfx( level._effect[ "propane_explosion" ], tank_exp.origin );

	if ( !level.ps3 ) //GEBE
	{
		playfx( level._effect[ "power_spark_burst" ], ( -1393, 1048.5, 120.5 ));
		playfx( level._effect[ "power_spark_linger" ], ( -1393, 1048.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1371, 1096.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1311, 947.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1321, 972.5, 120.5 ));
		wait( 1.0 );
	}

	badplace_cylinder( "end_no_go_03", 0, ( -1366.1, 926.3, 38 ), 5, 40, "axis" );
	badplace_cylinder( "end_no_go_04", 0, ( -1390, 1002, 42 ), 5, 40, "axis" );
}

//avulaj
//
panel_destoryed2()
{
	panel_atrium_01 = GetEntArray( "eh_atrium_railings_b_cov_sb", "targetname" );
	panel_atrium_02 = GetEntArray( "eh_atrium_railings_c_cov_sb", "targetname" );
	panel_atrium_03 = GetEntArray( "eh_atrium_railings_d_sb", "targetname" );

	broken_rail_01 = GetEnt( "broken_rail_01", "targetname" );
	broken_rail_01 trigger_on();

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
//avulaj
//
rapid_damage1()
{
	org_node = GetEnt( "tank_exp_01", "targetname" );
	wait ( 0.1 );
	self dodamage( 200, org_node.origin );
	radiusdamage( org_node.origin, 300, 600, 650 );
	physicsExplosionSphere( org_node.origin, 200, 100, 45 );
}

/*
=============
ActorCmd_CmdThrowGrenadeAtEntity
///ScriptDocBegin
"Name: cmdthrowgrenadeatentity( <command> ) \n"
"Summary: This will pause the Ai (Brain level) and will generate a command to throw a grenade at an entity\n This use the cmd system which mean you can expect receiving cmd_started and cmd_done. You can also Stop this command"
"Module: New AI\n"
"MandatoryArg: <command> (entity) The Target\n"
"OptionalArg: <CanBeInterrupted>    IF the AI has a threat, should this be interrupted. True = Ai is more important False=This command is more important"\n"
"OptionalArg: <maxDuration>               How long before we stop this (default is -1 == go forever)"\n"
"CallOn: <actor> An actor\n"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

/*
=============
ActorCmd_CmdShootAtEntityXTimes

///ScriptDocBegin
"Name: cmdshootatentityxtimes( <command> ) \n"
"Summary: This will pause the Ai (Brain level) and will generate a command to shoot at an entity\n This use the cmd system which mean you can expect receiving cmd_started and cmd_done. You can also Stop this command"
"Module: New AI\n"
"MandatoryArg: <command> (entity) The Target\n"
"OptionalArg: <CanBeInterrupted>	IF the AI has a threat, should this be interrupted. True = Ai is more important False=This command is more important"\n"
"OptionalArg: <count>				How many shot before stopping (default = -1)"\n"
"OptionalArg: <accuracy>			Will override the AI accuracy. If < 0 = disable (Default). If 0 = Alway miss. If 0.5 = hit 50%. If 1.0 = hit 100%. "\n"
"OptionalArg: <blind>				Set to true for doing blindfire. (default is 0)"\n"
"CallOn: <actor> An actor\n"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

//avulaj
//
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

//avulaj
//
greenes_final_move()
{
	final_node = getnode ( "greenes_final_node", "targetname" );
	level waittill ( "greene_move_final" );
	self setgoalnode( final_node, 1 );
	self waittill ( "goal" );
	self thread greene_shoots();
	self thread greene_fight_func();
}

//avulaj
//
greene_shoot_from_high()
{
	bond_position = GetEnt( "bond_position_blow_back", "targetname" );
	self waittill ( "goal" );

	self cmdshootatentityxtimes( bond_position, false, 10, 1, false );
	wait( 3.0 );
	self stopallcmds();
	self thread greene_fight_func2();

	node_point = GetNode ( "greenes_node_01", "targetname" );
	self setgoalnode( node_point, 1 );
	self waittill ( "goal" );
}

//avulaj
//
greene_fight_func2()
{
	tank = GetEnt( "dome_panel_tank_two", "targetname" );
	tank_exp = GetEnt( "tank_exp_02", "targetname" );
	fuel_cell_boom_clip_01 = GetEnt( "fuel_cell_boom_clip_01", "targetname" );
	tank SetCanDamage( true );
	weapon_block_02 = GetEnt( "weapon_block_02", "targetname" );
	weapon_block_02 trigger_off();

	thread count_down_to_backup();
	self thread greene_shoots();
	tank waittill ( "damage" );
	fuel_cell_boom_clip_01 trigger_off();
	wait( 0.1 );
	level notify ( "greene_move_final" );
	thread rapid_damage2();

	thread panel_destoryed();
	tank_exp playsound ( "green_tank_expl" );
	playfx( level._effect[ "propane_explosion" ], tank_exp.origin );

	if ( !level.ps3 ) //GEBE
	{
		playfx( level._effect[ "power_spark_burst" ], ( -1316, 701.5, 120.5 ));
		playfx( level._effect[ "power_spark_linger" ], ( -1316, 701.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1287, 718.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1404, 607.5, 120.5 ));
		wait( 0.1 );
		playfx( level._effect[ "power_spark_linger" ], ( -1374, 582.5, 120.5 ));
		wait( 1.0 );
	}
	badplace_cylinder( "end_no_go_01", 0, ( -1366.6, 738.3, 38 ), 5, 40, "axis" );
	badplace_cylinder( "end_no_go_02", 0, ( -1388.5, 664, 38 ), 5, 40, "axis" );
}

//avulaj
//
panel_destoryed()
{
	panel_atrium_01 = GetEntArray( "eh_atrium_railings_b_cov_sbr", "targetname" );
	panel_atrium_02 = GetEntArray( "eh_atrium_railings_c_cov_sbr", "targetname" );
	panel_atrium_03 = GetEntArray( "eh_atrium_railings_d_sbr", "targetname" );

	broken_rail_02 = GetEnt( "broken_rail_02", "targetname" );
	broken_rail_02 trigger_on();

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

//avulaj
//
rapid_damage2()
{
	org_node = GetEnt( "tank_exp_02", "targetname" );
	wait ( 0.1 );
	radiusdamage( org_node.origin, 200, 100, 200 );
	physicsExplosionSphere( org_node.origin, 200, 100, 45 );
}
//avulaj
//
atrium_glass_fall_func()
{
	level.player playsound ( "distant_explo_01" );
	earthquake( 0.6, 2.0, level.player.origin, 400 );
	glass_fall = GetEntArray( "atrium_glass_fall", "targetname" );
	for ( i = 0; i < glass_fall.size; i++ )
	{
		radiusdamage( glass_fall[i].origin, 200, 25, 15 );
		wait( 0.3 );
	}
	level.player playsound ( "distant_explo_02" );
	earthquake( 0.6, 2.0, level.player.origin, 400 );
	for ( i = 0; i < glass_fall.size; i++ )
	{
		radiusdamage( glass_fall[i].origin, 200, 25, 15 );
		wait( 0.3 );
	}
}

///////////////////////////////////////////////////////////////////////////////////////
//	Check if first wave in atrium has been eliminated
///////////////////////////////////////////////////////////////////////////////////////
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
			level.player playsound ( "distant_explo_02" );
			earthquake( 0.5, 1, level.player.origin, 400 );	
		}
		
		wait(0.5);
	}
}


///////////////////////////////////////////////////////////////////////////////////////
//	Explosions after Greene is killed
///////////////////////////////////////////////////////////////////////////////////////
explosion_atrium_exit()
{
	wait( 15.0 );
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

///////////////////////////////////////////////////////////////////////////////////////
// Camille extinguishes flames block atrium exit
///////////////////////////////////////////////////////////////////////////////////////
camille_extinguish_fire()
{
	node_over = getnode("node_camille_over", "targetname");
	node_jump = getnode("node_camille_jump", "targetname");

	trigger_escape = getent("trigger_camille_escape", "targetname");

	spawner = getent("spawner_camille_atrium", "targetname");
	spawner stalingradspawn("camille_extinguish");
	camille = getent("camille_extinguish", "targetname");
	camille.team = "neutral";
	camille setpainenable( false );
	camille setscriptspeed ( "sprint" );

	camille thread extinguisher_attach_func();

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

	thread fire_escape();

	camille thread check_atrium_clear();
	camille thread escape_vo();
	//camille thread escape_vo_02();

	camille setgoalnode( node_over );

	camille waittill( "goal" );

	wait( .5 );

	camille thread wave_come_over();

	trigger_escape waittill ( "trigger" );

	thread dust_fall_end();
	earthquake( 0.5, 1, level.player.origin, 400 );
	end_boom_escape = GetEnt( "end_boom_escape", "targetname" );
	end_boom_escape PlaySound( "camille_explo" );
	
	level.atrium++;
	fire_jump = getentarray( "tag_fire_blockjump", "targetname" );
	playfx( level._effect[ "propane_explosion" ], ( -3020, 903, -110 ));
	final_blocker = GetEnt( "final_blocker", "targetname" );
	final_blocker trigger_on();
	for ( i = 0; i < fire_jump.size; i++ )
	{
		if ( isdefined( fire_jump[i] ))
		{
			playfxontag( level._effect[ "fx_fire_large" ], fire_jump[i], "tag_origin" );
		}
	}

	camille setgoalnode(node_jump);

	wait(0.5);
	
	thread blow_out_window();

	triggerhurt_camille = getent("triggerhurt_camille_escape", "targetname");
	triggerhurt_camille trigger_on();

	camille waittill("goal");
	wait( 2.0 );
	if (isdefined ( camille ))
	{
		camille cmdplayanim( "camille_waving", false );
	}
}


blow_out_window()
{
	wait(0.5);

	radiusdamage( (-2997, 698, -78), 50, 200, 200 );
}



//avulaj
//
escape_vo()
{
	//level waittill ( "play_camille_last_line" );
	
	wait(2.0);
	
	if((IsDefined( self )) && ( level.atrium <= 1 ))
	{
		self play_dialogue( "CAMI_EcohG_058A" );
		level.player play_dialogue_nowait( "BOND_EcohG_506A" );
	}
}

//avulaj
//
escape_vo_02()
{
	wait( 12 );
	level notify ( "play_camille_last_line" );
}

check_atrium_clear()
{
	all_clear = false;

	while(!(all_clear))
	{
		guards = getaiarray("axis");

		if (!(guards.size))
		{
			all_clear = true;
		}		
		wait( 0.1 );
	}
	wait( 0.1 );
	if ( level.atrium <= 1 )
	{
		//level notify ( "play_camille_last_line" );
	}
}

//avulaj
//
extinguisher_attach_func()
{
	end_extinguisher_event_01 = GetEnt( "end_extinguisher_event_01", "targetname" );
	
	end_extinguisher_event_01 thread extra_damage();

	flag_wait( "greene_dead" );
	end_extinguisher_event_01 trigger_on();
	
	end_extinguisher_event_01 thread death_check_01();
	
	wait(7.0);
	
	if (isdefined(end_extinguisher_event_01))
	{
		radiusdamage( end_extinguisher_event_01.origin, 50, 300, 200 );
	}
}

//avulaj
//
death_check()
{
	self waittill ( "damage" );
	level notify ( "camille_put_out_fire_02" );
	blocker = getent("fire_blocker_03", "targetname");
	blocker thread release_blocker();
}

//avulaj
//
death_check_01()
{
	self waittill ( "damage" );
	level notify ( "camille_put_out_fire_01" );
	triggerhurt_blocker = getent("triggerhurt_atrium_blocker", "targetname");
	triggerhurt_blocker trigger_off();
	cover_block = GetEnt( "block_atrium_cover", "targetname" );
	cover_block movez ( -208, 0.5 );

}

//avulaj
//
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

	trigger_escape = getent("trigger_camille_escape", "targetname");
	trigger_escape waittill ( "trigger" );

	if ( IsDefined ( self ))
	{
		self stopallcmds();
	}
}

//avulaj
//these are kicked off when camille comes in the atrium to put ou the fire for Bond
release_blocker()
{
	wait( .5 );
	wait( 2.0 );
	self trigger_off();
	triggerhurt_06 = getent("triggerhurt_fire_atriumentrance", "targetname");
	triggerhurt_06 trigger_off();
}

//avulaj
//
dust_fall_end()
{
	earthquake( 0.5, 1, level.player.origin, 400 );
	playfx( level._effect[ "face_plant" ], ( -2900, 992, 8 )); wait( .5 + randomfloat( 2.0 ));

	earthquake( 0.5, 1, level.player.origin, 400 );
	playfx( level._effect[ "face_plant" ], ( -3004, 812, 8 ));
}

//avulaj
//
camille_dies_you_fail()
{
	self waittill ( "death" );
	if ( level.end_scene == 0 )
	{
		//missionfailed();
		missionfailedwrapper();
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// Fire blockers for escape
///////////////////////////////////////////////////////////////////////////////////////
fire_escape()
{
	fire1 = getentarray("tag_fire_escape", "targetname");
	for (i=0; i<fire1.size; i++)
	{
		playfxontag( level._effect[ "fx_fire_large" ], fire1[i], "tag_origin" );
	}
}

///////////////////////////////////////////////////////////////////////////////////////
// End level
///////////////////////////////////////////////////////////////////////////////////////
end_level()
{
	trigger = getent("trigger_escape", "targetname");
	trigger waittill("trigger");

	level notify ( "kill_timer" );

	VisionSetNaked( "eco_hotel_0", 1.5 );
	
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

	//Play Ending Music - crussom
	level notify("playmusicpackage_ending");

	wait( 2.0 );
	level notify ( "end_exp_1" );
	wait( 2.0 );
	level notify ( "end_exp_2" );
	wait( 2.0 );
	
	earthquake( 0.5, 1, level.player.origin, 1400 );
	level notify ( "end_exp_3" );
	wait( 2.0 );

	level notify ( "end_exp_4" );
	wait( 2.0 );

	earthquake( 0.5, 1, level.player.origin, 1400 );
	level notify ( "end_exp_5" );
	wait( 2.0 );

	level notify ( "end_exp_6" );
}

///////////////////////////////////////////////////////////////////////////////////////
// End level camera
///////////////////////////////////////////////////////////////////////////////////////
end_camera()
{
	level.player waittillmatch( "anim_notetrack", "fade_black" );
	level.player FreezeControls( true );
	level.hud_black.alpha = 0;
	level.hud_black fadeOverTime( 2.0 ); 
	level.hud_black.alpha = 1;
	wait( 2.0 );
	maps\_endmission::nextmission();
}

///////////////////////////////////////////////////////////////////////////////////////
// Last explosion
///////////////////////////////////////////////////////////////////////////////////////
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

//avulaj
//
vision_trigger_01()
{
	trigger = GetEnt( "vision_trigger_outside", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_0", 1.5 );
	level thread vision_trigger_02();
}

//avulaj
//
vision_trigger_02()
{
	trigger = GetEnt( "vision_trigger_inside", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_1", 1.5 );
	level thread vision_trigger_01();
	level thread vision_trigger_kitchen();
}

//avulaj
//
vision_trigger_kitchen()
{
	trigger = GetEnt( "vision_trigger_fire", "targetname" );
	trigger waittill ( "trigger" );
	VisionSetNaked( "eco_hotel_kitchen", 1.5 );
	level thread vision_trigger_02();
	level thread vision_trigger_03();
}

//avulaj
//
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

//avulaj
//
pre_fire_dome_fight()
{
	thread pre_fire_fight_func();
	trigger = GetEnt( "trigger_pre_fire_dome_01", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "pre_fire_01" );
}

//avulaj
//
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

//avulaj
//
pre_exp_fight_func()
{
	fire_point = GetEntArray( "new_fire_dome_01", "targetname" );
	fire_dome_05 = getent("fire_dome_05", "targetname");
	fire_dome_06 = getent("fire_dome_06", "targetname");
	dome_badplace_01 = GetEnt( "dome_badplace_01", "targetname" );
	dome_badplace_02 = GetEnt( "dome_badplace_02", "targetname" );

	earthquake( 0.5, 1, level.player.origin, 200 );
	dome_badplace_01 playsound ( "doom_room_corner" );
	for ( i = 0; i < fire_point.size; i++ )
	{
		firefx2 = spawnfx( level._effect["fx_fire_large"], fire_point[i].origin );
		triggerFx( firefx2 );
		fire_point[i] playloopsound( "fire_A" );
		wait( 0.1 );
	}
	fire_dome_05 trigger_on();
	wait( 3.0 );
	fire_dome_06 trigger_on();

	badplace_cylinder( "dome_fire_a", 0, dome_badplace_01.origin, 28, 182, "axis" );
	badplace_cylinder( "dome_fire_b", 0, dome_badplace_02.origin, 28, 182, "axis" );
}

//avulaj
//this function will fire off when Bond tries to open the doors in the atrium fight
//once triggered Bond will fly backwards and white out. Greene will stand over him at a high position firing on Bond
//Bond's weapons will be holstered controls of Bond will go back to the player once the panle falls off
blow_back_bond_func()
{
	trigger = GetEnt( "blow_bond_back", "targetname" );
	trigger trigger_on();
	trigger waittill ( "trigger" );
	level.player playerSetForceCover( false, true );
	flag_set( "end_of_greene" );
	//breadcrume_greene = GetEnt( "auto3001", "targetname" );
	//breadcrume_greene trigger_on();
	thread spawn_ax_greene();
	level notify ( "setup_blockers" );

	thread door_explode();
	wait( 0.1 );
	greene = getent ( "spawner_greene_ax", "targetname" );
	greene thread fade_to_black();
	
	//Music For Greene Fight - Crussom
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
	maps\_autosave::autosave_now( "eco_hotel" );
}

//avulaj
//
last_blockers()
{
	trigger = GetEnt( "geene_fight_triggers", "targetname" );
	blockers = GetEnt( "geene_fight_blockers", "targetname" );
	trigger trigger_off(); blockers trigger_off();
	level waittill ( "setup_blockers" );

	firefx1 = spawnfx( level._effect["small_fire"], ( -2005, 600, -88 )); triggerFx( firefx1 );
	firefx2 = spawnfx( level._effect["small_fire"], ( -1736, 900, -88 )); triggerFx( firefx2 );
	firefx3 = spawnfx( level._effect["small_fire"], ( -1668, 832, -88 )); triggerFx( firefx3 );
	firefx4 = spawnfx( level._effect["small_fire"], ( -1668, 756, -88 )); triggerFx( firefx4 );
	firefx6 = spawnfx( level._effect["fx_fire_large"], ( -2095, 1154, -88 )); triggerFx( firefx6 );
	firefx7 = spawnfx( level._effect["fx_fire_large"], ( -2092, 582.5, -88 )); triggerFx( firefx7 );

	wait( 2.0 );
	trigger trigger_on(); blockers trigger_on();

	trigger_end = getent("trigger_escape", "targetname");
	trigger_end waittill("trigger");

	firefx1 delete(); firefx2 delete(); firefx3 delete(); firefx4 delete(); firefx6 delete(); firefx7 delete();
}

//these are the params for the camera detach function
//cameraID = customCamera_push(
//	cameraType,     //<required string, see camera types below>
//	originEntity,      //<required only by "entity" and "entity_abs" cameras>
//	targetEntity,     //<optional entity to look at>
//	offset,              // <optional positional vector offset, default (0,0,0)>
//	angles,            // <optional angle vector offset, default (0,0,0)>
//	lerpTime,         // <optional time to 'tween/lerp' to the camera, default 0.5>
//	lerpAccelTime, // <optional time used to accel/'ease in', default 1/2 lerpTime> 
//	lerpDecelTime, // <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
//	);

//customCamera_pop(
//cameraID,        // <required ID returned from customCameraPush>
//lerpTime,         // <optional time to 'tween/lerp' to the previous camera, default prev camera>
//lerpAccelTime, // <optional time used to accel/'ease in', default prev camera> 
//lerpDecelTime, // <optional time used to decel/'ease out', default prev camera>
//);

//To change a camera mid-use, use the 'customCamera_change' function. 
//
//customCamera_change(
//cameraID,         // <required ID returned from customCameraPush>
//cameraType,     //<required string, see camera types below>
//originEntity,      //<required only by "entity" and "entity_abs" cameras>
//targetEntity,     //<optional entity to look at>
//offset,              // <optional positional vector offset, default (0,0,0)>
//angles,            // <optional angle vector offset, default (0,0,0)>
//lerpTime,         // <optional time to 'tween/lerp' to the camera, default 0.5>
//lerpAccelTime, // <optional time used to accel/'ease in', default 1/2 lerpTime> 
//lerpDecelTime, // <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
//);

//avulaj
//
fade_to_black()
{
	level.hud_white.alpha = 0;
	level.hud_white fadeOverTime( 2.0 ); 
	level.hud_white.alpha = 1;
	earthquake( 0.5, 2.0, level.player.origin, 750 );
	cameraID_bond_fly = level.player customCamera_Push( "world", ( -1801.64, 805.71, -61.40 ), ( -18.83, -6.20, 0.00 ), 1.5 );
	wait( 3.0 );

	level.hud_white.alpha = 1;
	level.hud_white fadeOverTime( 2.0 ); 
	level.hud_white.alpha = 0;
	level.player customCamera_change ( cameraID_bond_fly, "world", ( -1810.88, 804.76, -31.55  ), ( -10.07, -0.09, 0.00 ), 0.1 );

	wait( 2.0 );
	//level notify ( "panel_drop_04_start" );
	earthquake( 0.5, 1, level.player.origin, 400 );
	level.player playsound ( "distant_explo_02" );
	//level.player customCamera_change ( cameraID_bond_fly, "world", ( -1810.88, 804.76, -31.55  ), ( -11.60, -16.50, 0.00 ), 1.5 );
	level.player customCamera_change ( cameraID_bond_fly, "world", ( -1868.94, 785.58, -28.00  ), ( -10.37, -20.45, 0.00 ), 1.5 );

	wait( 1.0 );
	fov_transition( 17 );
	wait( 0.5 );
	level notify ( "panel_drop_04_start" );
	wait( 1.0 );

	level.player customcamera_pop( cameraID_bond_fly, 2.0 );
	fov_transition( 65 );
	level notify ( "custom_cam_done" );
}

//avulaj
//
door_explode()
{
	level notify ( "cafe_doors_start" );
	fire_point = GetEntArray( "fire_dome_doorway", "targetname" );

	level.player playsound ( "doom_room_3_expl" );
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

//avulaj
//
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

//avulaj
//this will set a large cull dist when the player is on the uper part of the atrium
//once the player enters the hall of the uper atrium the cull will be shrunk
large_cull_dist_func()
{
	trigger = GetEnt( "large_cull_dist", "targetname" );
	trigger waittill ( "trigger" );
	setculldist( 0 );
	thread small_cull_dist_func();
}

//avulaj
//this will set a small cull dist when the player is on the uper part of the atrium
//once the player enters the kitchen it will go back to normal
small_cull_dist_func()
{
	trigger = GetEnt( "small_cull_dist", "targetname" );
	trigger waittill ( "trigger" );
	setculldist( 2500 );
	thread large_cull_dist_func();
}

//avulaj
//this will randomly select a VO to play off of greene during the final fight
greene_final_fight_func()
{
	wait( 5.0 );
	self endon ( "death" );
	while ( 1 )
	{
		wait( 15.0 );
		j = randomint( 10 );
		if (( j <= 7 ) && ( isdefined ( self )))
		{
			random_vo[0] = "GREE_EcohG_052A";
			random_vo[1] = "GREE_EcohG_502A";
			random_vo[2] = "GREE_EcohG_503A";
			random_vo[3] = "GREE_EcohG_504A";
			random_vo[4] = "GREE_EcohG_049A";
			random_vo[5] = "GREE_EcohG_050A";

			i = randomint( 6 );
			self play_dialogue ( random_vo[i] );
		}
	}
}

//avulaj
//this will turn shadows off when inside the eco hotel
shadow_01_off_func()
{
	trigger = GetEnt( "shadow_01_off", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 0 );
	thread shadow_01_on_func();
}

//avulaj
//this will turn shadows on when inside the eco hotel
shadow_01_on_func()
{
	trigger = GetEnt( "shadow_01_on", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 1 );
	thread shadow_01_off_func();
}

//avulaj
//this will turn shadows off when inside the eco hotel
shadow_02_off_func()
{
	trigger = GetEnt( "shadow_02_off", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 0 );
	thread shadow_02_on_func();
}

//avulaj
//this will turn shadows on when inside the eco hotel
shadow_02_on_func()
{
	trigger = GetEnt( "shadow_02_on", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 1 );
	thread shadow_02_off_func();
}

//avulaj
//this will turn shadows off when inside the eco hotel
shadow_03_off_func()
{
	trigger = GetEnt( "shadow_03_off", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 0 );
	thread shadow_03_on_func();
}

//avulaj
//this will turn shadows on when inside the eco hotel
shadow_03_on_func()
{
	trigger = GetEnt( "shadow_03_on", "targetname" );
	trigger waittill ( "trigger" );
	setdvar( "sm_sunshadowenable", 1 );
	thread shadow_03_off_func();
}

//avulaj
//
save_before_balcony_func()
{
	trigger = GetEnt( "save_befor_balcony", "targetname" );
	trigger waittill ( "trigger" );
	maps\_autosave::autosave_now( "eco_hotel" );
}

//avulaj
//
intro_pipes_func()
{
	good_pipe = GetEnt( "Intro_clean_pipe", "targetname" );
	bad_pipe = GetEnt( "intro_bad_pipe", "targetname" );
	bad_pipe trigger_off();

	trigger = GetEnt( "car_check_driver", "targetname" );
	trigger waittill ( "trigger" );

	playfx( level._effect[ "fx_explosion" ], ( 4093, -151, 228 ));

	bad_pipe trigger_on();
	good_pipe trigger_off();
}

key_pad_func()
{
	key_pad_00 = GetEnt( "key_pad_00", "targetname" );
	key_pad_00 maps\_utility::red_light();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Kill all ai when Greene dies
///////////////////////////////////////////////////////////////////////////////////////
kill_all()
{
	guys = getaiarray("axis");

	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			earthquake( 0.5, 2.0, level.player.origin, 100 );
			playfx( level._effect[ "fx_explosion" ], guys[i].origin );
			level.player radiusdamage( guys[i].origin, 400, 500, 500 );
			level.player playsound ( "distant_explo_01" );
			wait(0.2 + randomfloat(0.3));
		}
	}
	
	level thread the_end_func();
}

//avulaj
//
the_end_func()
{
	end_exp = getentarray( "the_end_exp", "targetname" );

	level.player endon ( "death" );
	while ( 1 )
	{
		if(!IsDefined ( level.player ))
		{
			break;
		}
		else
		{
			for ( i = 0; i < end_exp.size; i++ )
			{
				wait( 1.5 + randomfloat( 2.5 ));
				earthquake( 0.5, 2.0, level.player.origin, 100 );
				playfx( level._effect[ "fx_explosion" ], end_exp[i].origin );
				level.player radiusdamage( end_exp[i].origin, 400, 500, 500 );
				level.player playsound ( "distant_explo_01" );
			}
			wait( 1.5 + randomfloat( 2.5 ));
		}
	}
}

//avulaj
//this will pop on the screen saver when Bond gets close to the laptops
screensaver()
{
	level.player endon ( "death" );

	screen = getent(self.target, "targetname");
	screen hide();
	while(IsAlive(level.player))
	{
		self waittill("trigger");
		screen show();
		screen playSound("ui_menu_phone_on");
		wait(60);
		screen hide();
	}
}


slo_mo_time()
{
	wait(0.35);
	
	level thread slow_time(.15, 0.4, 0.25);
}


slow_time(val, tim, out_tim)
{
	self endon("stop_timescale");

	thread check_for_death();
	SetSavedDVar( "timescale", val);

	wait(tim - out_tim);

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);

	level notify("timescale_stopped");
}

check_for_death()
{
	self endon("timescale_stopped");

	while(level.player.health > 0)
	{
		wait(.05);
	}

	level notify("stop_timescale");
	SetSavedDVar( "timescale", 1);
}

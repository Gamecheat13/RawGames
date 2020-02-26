#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;









































main()
{
	
	maps\whites_estate_fx::main();
	
	
	
	
	maps\_blackhawk::main( "v_heli_estate" );
	
	
	maps\_securitycamera::init();	
	
	
	
	
	setExpFog( 1536, 3317, 0.507, 0.507, 0.476, 0, 0.7622 );
	
	precacheShader( "compass_map_whites_estate" );
	setminimap( "compass_map_whites_estate", 3648, 2368, -6080, -2168 );

	SetDVar("sm_SunSampleSizeNear", 1.208);

	
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	
	precacheshellshock ("default");
	precacheshellshock ("flashbang");
	
	
	
	PrecacheCutScene("WE_END");
	PrecacheCutScene("WE_Detonate");
	
	
	level.strings["whites_estate_phone1_name"] = &"WHITES_ESTATE_WHITES_NAME1";
	level.strings["whites_estate_phone1_body"] = &"WHITES_ESTATE_WHITES_BODY1";
	
	level.strings["whites_estate_phone2_name"] = &"WHITES_ESTATE_WHITES_NAME2";
	level.strings["whites_estate_phone2_body"] = &"WHITES_ESTATE_WHITES_BODY2";
	
	level.strings["whites_estate_phone3_name"] = &"WHITES_ESTATE_WHITES_NAME3";
	level.strings["whites_estate_phone3_body"] = &"WHITES_ESTATE_WHITES_BODY3";
	
	level.strings["whites_estate_phone4_name"] = &"WHITES_ESTATE_WHITES_NAME4";
	level.strings["whites_estate_phone4_body"] = &"WHITES_ESTATE_WHITES_BODY4";
		
	level.strings["whites_estate_phone5_name"] = &"WHITES_ESTATE_WHITES_NAME5";
	level.strings["whites_estate_phone5_body"] = &"WHITES_ESTATE_WHITES_BODY5";
	
	maps\_load::main();
	
	
	thread maps\whites_estate_snd::main();
	thread maps\whites_estate_mus::main();

	array_thread(getentarray ("dest_v_sedan","targetname"), maps\_vehicle::bond_veh_flat_tire);

	VisionSetNaked( "whites_estate_0" );

	
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	
	
	
	


	
	level.debug_text = 1;          
	level.skipto_1 = 0;            
	level.skipto_1a = 0;           
	level.skipto_1b = 0;           
	level.skipto_2 = 0;            
	level.skipto_3 = 0;            
	level.skipto_4 = 0;            
	level.skipto_5 = 0;            
	level.tracker = 0;             
	level.tool_ads = 0;            
	level.kill_pip = 0;            
	level.white_shot = 0;          
	level.thug_death_tracker = 0;  
	level.boathouse_tracker = 0;   
	level.greenhouse_thug = 0;     
	level.cellar_thug = 0;         
	level.force_gh_spawn = 0;      
	level.boathouse = 0;           
	level.statue_head = 0;         
	level.move_left = 0;           
	level.move_right = 0;          
	level.last_man = 0;            
	level.water_tank = 0;          
	level.tutorial_00 = 0;         
	level.tutorial_01 = 0;         
	level.tutorial_02 = 0;         
	level.tutorial_03 = 0;         
	level.tutorial_04 = 0;         
	level.tutorial_05 = 0;         
	level.tutorial_06 = 0;         
	level.tutorial_07 = 0;         
	level.second_wave = 0;         
	level.garden_death = 0;        
	
	
	
	
	
	flag_init("gogogo");
	flag_init("rundown_reached");
	flag_init("garden_alert");
	
	flag_init("hack_initiated");
	flag_init("safe_hacked");
	flag_init("vo_computer_done");
	flag_init("destroy_computer_room");
	flag_init("victims_in_place");
	flag_init("balcony_victim");
	flag_init("atrium_victim");
	flag_init("balcony_boom");
	flag_init("explosion_done");
	flag_init("open_doors");
	flag_init("blowup_floor");
		
	level.door_kicked_open = false;
	level.turn_off_flicker = false;
	level.reached_garden = false;	
	level.greenhouse_lure = false;
	level.greenhouse_thru = false;
	level.gotime = false;
	level.top_01 = false;
	level.mid_01 = false;
	level.top_02 = false;
	level.mid_02 = false;
	level.top_03 = false;
	level.mid_03 = false;
	level.top_04 = false;
	level.mid_04 = false;
	level.wine_barrels = 0;
	level.floor_gone = false;
	level.safe_room_found = false;
	level.vo_cellar_done = false;
	level.cellar_alerted = false;
	
	level.displaying_hint = false;
	level.cover_taken = false;
	
	
	level.heli_go = false;
	level thread wiiTutorial();

	level thread setup_bond();
	level thread spawn_heli_garden();
	
	level thread spawn_gate_guards();
	level thread spawn_boathouse_quickkill();
	level thread objectives_whites_estate();
	level thread house_setup();
	level thread safe_button();
	level thread safe_keyboard();

	
	
	
	level thread vo_explosions_start();



	level thread vision_secondout_01();
	level thread vision_secondout_02();
	level thread vision_thirdout();
	level thread vision_atrium_outside();

	
	
	blowupfloor2_after = GetEnt( "blowupfloor2_after", "targetname" );
	blowupfloor2_after hide();
	
	
	
	
	
	
	

	level thread skip_to_points();	
	
	strings = [];
	strings[0] = "White's Estate";
	strings[1] = "Play Intro";

	level thread bond_setup();	
	

	
	
	
	

	
	level thread tool_tip();
	level thread tool_tip_mantel_func();
	

	
	level thread vision_set_boathouse();
	level thread tunnel_save_trigger();
	level thread boathouse_save_trigger();
	level thread estate_save_trigger();
	
	level thread fx_precache();
	
	
	


	
	
	
	level thread front_copter_land();

        
	level thread check_helicopter();

	
	level thread villa_fish_tank_func();
	

	
	
	
	
	level thread end_thug_alert_check_func();
	level thread greenhouse_water_tank_func();
	

	
	level thread cellar_trigger_fall_guy_fuc();
	

	
	level thread cellar_thugs_spawn_01_func();
	level thread cellar_door_close_func();
	

	
	level thread villa_second_wave();
	level thread villa_save_game_func();
	level thread front_door_temp_open_func();
	level thread safe_room_save_func();
	level thread villa_hurt_triggers();
	level thread villa_bomb_prop_swap();
	level thread villa_fire_triggers_setup();
	level thread villa_trigger_primer_func();
	level thread villa_backup_trigger_door();
	
	
	
	level thread conservatory_trigger_fight();
	level thread conservatory_trigger_end_mr_white();
	

	
	level thread pip_trigger_01_func();
	
}


skip_to_points()
{

	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "1" ) 
	{
		setdvar("skipto", "0");
		level.skipto_1++;

		start_org = getent( "skipTo_1_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );

		bond_position_01 = GetEnt( "org_bond_hide", "targetname" );
		bond_position_01_angles = bond_position_01.angles;
		level.player setorigin( bond_position_01.origin);
		level.player setplayerangles((bond_position_01_angles));
		level.player playerlinktodelta ( bond_position_01, undefined, 0, 25, 25, 15, 10 );
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();
		
		
		
	}     
	else if(Getdvar( "skipto" ) == "1a" ) 
	{
		setdvar("skipto", "0");
		level.skipto_1a++;

		start_org = getent( "skipTo_1a_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();
		
		level thread boat_arrive();
		
		
		
	}     
	else if(Getdvar( "skipto" ) == "1b" ) 
	{
		setdvar("skipto", "0");
		level.skipto_1b++;

		start_org = getent( "skipTo_1b_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();
		
		
		
		
		level thread spawn_lure();
		level thread tip_sprint();
	}     
	else if(Getdvar( "skipto" ) == "2" ) 
	{
		setdvar("skipto", "0");
		level.skipto_2++;

		start_org = getent( "skipTo_2_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();
		
		
		
		
		level thread greenhouse_shootout();
	}     
	else if(Getdvar( "skipto" ) == "3" ) 
	{
		setdvar("skipto", "0");
		level.skipto_3++;

		start_org = getent( "skipTo_3_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();
		
		level thread open_balcony_window();
		level thread spawn_cellar_intro();
		level thread vo_cellar_entered();
		
		
		
		
		level thread vision_set_inside();
	}     
	else if(Getdvar( "skipto" ) == "4" ) 
	{
		setdvar("skipto", "0");
		level.skipto_4++;

		start_org = getent( "skipTo_4_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		wait( 1 );
		level.player allowcrouch( true );
		level thread cellar_ext();
		maps\_utility::unholster_weapons();

		fire_clip = GetEnt( "fire_block_temp", "targetname" );
		fire_clip trigger_off();
		fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
		fire_clip2 trigger_off();
		fire_clip2 connectPaths();

		flag_set("safe_hacked");
		
		level thread close_balcony_window();
		level thread vision_set_fire();
	}
	else if(Getdvar( "skipto" ) == "white" ) 
	{
		setdvar("skipto", "0");
		level.skipto_5++;

		start_org = getent( "skipTo_5_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		
		playcutscene("Blood_Barrell", "Blood_Barrel_Done");
		
		level waittill("Blood_Barrel_Done");
	}
}



objectives_whites_estate_tutorial_00()
{
	level endon ( "tutorial_00" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_00 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_00" ); 
			objective_state( 1, "current" );
		}
	}
}



objectives_whites_estate_tutorial_01()
{
	level endon ( "tutorial_01" );
	while ( 1 )
	{
		wait( 15 );
		if ( level.tutorial_01 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_01" ); 
			objective_state( 1, "current" );
		}
	}
}



objectives_whites_estate_tutorial_02()
{
	objective_marker_icon = GetEnt( "objective_marker_icon", "targetname" );






			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_02", ( objective_marker_icon.origin ) ); 
			objective_state( 1, "current" );


}



objectives_whites_estate_tutorial_03()
{
	level endon ( "tutorial_03" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_03 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_03" ); 
			objective_state( 1, "current" );
		}
	}
}



objectives_whites_estate_tutorial_04()
{
	level endon ( "tutorial_04" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_04 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_04" ); 
			objective_state( 1, "current" );
		}
	}
}



objectives_whites_estate_tutorial_05()
{
	objective_add( 1, "invisible", &"WHITES_ESTATE_tutorial_05" ); 
	objective_state( 1, "current" );
}



objectives_whites_estate_tutorial_06()
{
	level endon ( "tutorial_06" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_06 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_06" ); 
			objective_state( 1, "current" );
		}
	}
}



objectives_whites_estate_tutorial_07()
{
	level endon ( "tutorial_07" );
	
	
	
	
	
			objective_add( 1, "active", &"WHITES_ESTATE_TUTORIAL_07" ); 
			objective_state( 1, "current" );
	
	
}



objectives_whites_estate()
{
	objective_marker_1 = getent( "objective1_marker", "targetname" );
	objective_marker_1A = getent( "objective1A_marker", "targetname" );
	objective_marker_2 = getent( "objective2_marker", "targetname" );
	objective_marker_3 = getent( "objective3_marker", "targetname" );
	objective_marker_4 = getent( "objective4_marker", "targetname" );
	objective_marker_5 = getent( "objective5_marker", "targetname" );
	objective_marker_6 = getent( "objective6_marker", "targetname" );
	objective_marker_6A = getent( "objective6A_marker", "targetname" );
	objective_marker_7 = getent( "objective7_marker", "targetname" );
	objective_marker_8 = getent( "objective8_marker", "targetname" );
	objective_marker_9 = getent( "objective9_marker", "targetname" );
	objective_marker_10 = getent( "objective10_marker", "targetname" );
	
	flag_init("boathouse_reached");
	flag_init("greenhouse_reached");
	flag_init("security_eliminated");
	flag_init("house_entered");
	flag_init("entrance_found");
	flag_init("safe_located");
	flag_init("defended");
	flag_init("helipad_located");
	flag_init("white_stopped");

	mr_white_org = GetEnt( "mr_white_org", "targetname" );

	
	
	
	
	wait(1.0);
	
	objective_add( 1, "active", &"WHITES_ESTATE_OBJECTIVE_01", ( objective_marker_1.origin ), &"WHITES_ESTATE_OBJECTIVE_BOATHOUSE_BODY" );
	
	

	
	
	flag_wait("boathouse_reached");
	
	objective_state( 1, "done");
	
	objective_marker_1 delete();

	

	
	
	objective_add( 2, "active", &"WHITES_ESTATE_OBJECTIVE_02", ( objective_marker_2.origin ), &"WHITES_ESTATE_OBJECTIVE_GREENHOUSE_BODY" );
	
	flag_wait("greenhouse_reached");
	
	objective_state( 2, "done");

	objective_marker_2 delete();
	
	

	objective_add( 3, "active", &"WHITES_ESTATE_OBJECTIVE_03", ( objective_marker_3.origin ), &"WHITES_ESTATE_OBJECTIVE_SECURITY_BODY" );
	
	
	
	
	flag_wait("security_eliminated");
	
	objective_state( 3, "done");

	
	
 
	objective_marker_3 delete();

	

	objective_add( 4, "active", &"WHITES_ESTATE_OBJECTIVE_04", ( objective_marker_4.origin ), &"WHITES_ESTATE_OBJECTIVE_HOUSE_BODY" );
	
	
	
	
	flag_wait("house_entered");
	
	objective_state( 4, "done");

	objective_marker_4 delete();
	
	

	objective_add( 5, "active", &"WHITES_ESTATE_OBJECTIVE_05", ( objective_marker_5.origin ),&"WHITES_ESTATE_OBJECTIVE_ENTRANCE_BODY" );
	
	
	
	
	flag_wait("entrance_found");
	
	objective_state( 5, "done");
	
	objective_marker_5 delete();
	
	

	objective_add( 6, "active", &"WHITES_ESTATE_OBJECTIVE_06", ( objective_marker_6.origin ), &"WHITES_ESTATE_OBJECTIVE_SAFE_BODY" );
	
	
	
	
	flag_wait("safe_located");
	
	objective_state( 6, "done");
	
	objective_marker_6 delete();
	
	

	objective_add( 7, "active", &"WHITES_ESTATE_OBJECTIVE_06A", ( objective_marker_6A.origin ), &"WHITES_ESTATE_OBJECTIVE_COMPUTER_BODY" );
	
	flag_wait("explosion_done");
	
	objective_state( 7, "done");
	
	objective_marker_6A delete();
	
	

	objective_add( 8, "active", &"WHITES_ESTATE_OBJECTIVE_07", ( objective_marker_7.origin ), &"WHITES_ESTATE_OBJECTIVE_DEFEND_BODY" );
	
	
	
	flag_wait("defended");
	
	objective_state( 8, "done");
	
	objective_marker_7 delete();
	
	

	objective_add( 9, "active", &"WHITES_ESTATE_OBJECTIVE_08", ( objective_marker_8.origin ), &"WHITES_ESTATE_OBJECTIVE_WHITE_BODY" );
	
	
	
	trigger_helipad = getent("trigger_helipad_objective", "targetname");
	trigger_helipad waittill("trigger");
	
	objective_state( 9, "done");
	
	objective_marker_8 delete();
	
	

	objective_add( 10, "active", &"WHITES_ESTATE_OBJECTIVE_09", ( objective_marker_9.origin ), &"WHITES_ESTATE_OBJECTIVE_CHOPPER_BODY" );
	
	
	

	
	
	flag_wait("white_stopped");
	
	objective_state( 10, "done");
	
	objective_marker_9 delete();
}



objective_tracker()
{
	level notify ( "start_objective_" + level.tracker );
	level.tracker++;
}



objective_dist()
{
	while ( 1 )
	{
		wait( .5 );
		dist = Distance( level.player.origin, self.origin );

		if ( dist <= 100 )
		{
			level thread objective_tracker();
			break;
		}
	}
}







map_level()
{
	level.map_level_01_trig_wait = 0;
	level.map_level_02_trig_wait = 0;
	level.map_level_03_trig_wait = 0;
	level.map_level_04_trig_wait = 0;
	level.map_level_05_trig_wait = 0;
	level.map_level_06_trig_wait = 0;
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	level thread map_level_01();
}



map_level_01()
{
	trigger = GetEnt( "map_trigger_level_1", "targetname" );
	if(level.map_level_01_trig_wait == 0)
	{
		level.map_level_01_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_01_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level1" );
		level thread map_level_02();
	}
}



map_level_02()
{
	trigger = GetEnt( "map_trigger_level_2", "targetname" );
	if(level.map_level_02_trig_wait == 0)
	{
		level.map_level_02_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_02_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level2" );
		level thread map_level_01();
		level thread map_level_03();
	}
}



map_level_03()
{
	trigger = GetEnt( "map_trigger_level_3", "targetname" );
	if(level.map_level_03_trig_wait == 0)
	{
		level.map_level_03_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_03_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level3" );
		level thread map_level_02();
		level thread map_level_04();
	}
}



map_level_04()
{
	trigger = GetEnt( "map_trigger_level_4", "targetname" );
	if(level.map_level_04_trig_wait == 0)
	{
		level.map_level_04_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_04_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		level thread map_level_03();
		level thread map_level_05();
	}
}



map_level_05()
{
	trigger = GetEnt( "map_trigger_level_5", "targetname" );
	if(level.map_level_05_trig_wait == 0)
	{
		level.map_level_05_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_05_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level5" );
		level thread map_level_04();
		level thread map_level_06();
	}
}



map_level_06()
{
	trigger = GetEnt( "map_trigger_level_6", "targetname" );
	if(level.map_level_06_trig_wait == 0)
	{
		level.map_level_06_trig_wait = 1;
		trigger waittill ( "trigger" );
		level.map_level_06_trig_wait = 0;
		setSavedDvar( "sf_compassmaplevel",  "level6" );
		level thread map_level_01();
		level thread map_level_05();
	}
}



tool_tip()
{
	level.tool_tip = newHudElem();
	level.tool_tip.x = 0;
	level.tool_tip.y = 0;
	level.tool_tip.alignX = "center";
	level.tool_tip.alignY = "middle";
	level.tool_tip.horzAlign = "center";
	level.tool_tip.vertAlign = "middle";
	level.tool_tip.foreground = true;
	level.tool_tip.fontScale = 1.5;
	level.tool_tip.alpha = 1.0;
	level.tool_tip.color = (1, 1, 1);
}



hide_destruc_cars()
{
	car_00 = GetEntArray( "villa_destruc_car_00", "script_noteworthy" );

	for (i=0; i<car_00.size; i++)
	{
		car_00[i] thread hide_car_00_func();
		car_00[i] thread unhide_car_00_func();
	}
	level thread hide_old_cars();

	car_boom = GetEnt( "villa_destruc_car_boom", "script_noteworthy" );
	car_boom thread hide_car_00_func();
	car_boom thread unhide_car_00_func();
}



villa_blow_car_early_func()
{
	trigger = GetEnt( "villa_blow_car_early", "targetname" );
	
	
	trigger waittill ( "trigger" );
	
	stairs_main_after = getent("stairs_main_after", "targetname");
	stairs_main_after show();

	stairs_main = getent("stairs_main", "targetname");
	stairs_main delete();

	exp_stairs = getent("origin_explosion_stairs", "targetname");
	physicsExplosionSphere( exp_stairs.origin, 100, 100, 10 );
	playfx (level._effect["explosion_1"], exp_stairs.origin);
	exp_stairs delete();
	
	coll_main_stairs = getent("collision_main_stairs", "targetname");
	coll_main_stairs trigger_on();
	
	if (!(level.floor_mezz_collapsed))
	{
		level.floor_mezz_collapsed = true;
		
		
		
		
	
		floor = getent("blowupfloor_mezz", "targetname");
		if (isdefined(floor))
		{
			floor delete();
		}
		
		level notify("balcony_collapse_start");
		
		balcony_kill = getentarray("origin_front_balcony", "targetname");
		for (i=0; i<balcony_kill.size; i++)
		{
			radiusdamage(balcony_kill[i].origin, 140, 200, 200 );
		}
		
		level.player playsound("whites_estate_falling_ceiling");
		
		earthquake (0.7, 1.5, level.player.origin, 700, 10.0 );
		
		wait(0.3);
		
		fire_frontdoor = getentarray("triggerhurt_front_door", "targetname");
		for (i=0; i<fire_frontdoor.size; i++)
		{
			fire_frontdoor[i] trigger_on();
		}
	
		balconyfire = getent("origin_front_balconyfire", "targetname");
		balconyfire = spawnfx(level._effect["med_fire"], balconyfire.origin);
		triggerFX(balconyfire);
		
		dining_fire = spawnfx(level._effect["large_fire"], (-168, -203, 60));
		triggerFX(dining_fire);
		
		for (i=0; i<balcony_kill.size; i++)
		{
			balcony_kill[i] delete();
		}
	}
	
	
	
	
	
	
	
}




car_boom_func()
{
	level.car_brush = GetEnt( "car_brush_damage", "targetname" );
	level.car_brush.health = 300;
	level.car_brush setcandamage( true );

	while ( 1 )
	{
		wait( .1 );
		if ( level.car_brush.health == 0 )
		{
			
			villa_blow_car_early = GetEnt( "villa_blow_car_early", "targetname" );
			

			stairs_main_after = getent("stairs_main_after", "targetname");
			stairs_main_after show();

			stairs_main = getent("stairs_main", "targetname");
			stairs_main delete();

			
			

			villa_blow_car_early trigger_off();

			car = GetEnt( "villa_destruc_car_boom", "script_noteworthy" );
			
			car playsound("whites_estate_house_car_explosion");
			
			earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
			
			if (!(level.floor_mezz_collapsed))
			{
				level.floor_mezz_collapsed = true;
		
				
				
				
	
				floor = getent("blowupfloor_mezz", "targetname");
				if (isdefined(floor))
				{
					floor delete();
				}
				
				level notify("balcony_collapse_start");
				
				level.player playsound("whites_estate_falling_ceiling");
				
				
				
			}
	
			
			radiusdamage( ( 38, 476, -20 ), 300, 2000, 50 );

			windows = GetEntArray( "frontdoorwindow", "targetname" );
			window_right = GetEnt( "front_door_boom_right", "targetname" );
			window_left = GetEnt( "front_door_boom_left", "targetname" );
			

			org_left = window_left.origin;
			org_right = window_right.origin;
			car_org = car.origin;

			

			fx = playfx (level._effect["estate_car_explosion"], car_org );
			
			radiusdamage( car_org + ( 0, 0, 36 ), 200, 400, 500 );

			fx1 = playfx (level._effect["estate_car_explosion"], org_right );
			
			radiusdamage( org_right + ( 0, 0, 36 ), 200, 150, 200 );

			fx2 = playfx (level._effect["estate_car_explosion"], org_left );
			
			radiusdamage( org_left + ( 0, 0, 36 ), 200, 150, 200 );

			for ( i = 0; i < windows.size; i++ )
			{
				windows[i] delete();
			}

			
			
			
			
			
			level notify ( "fires_15" ); level notify ( "fires_16" ); level notify ( "fires_33" ); level notify ( "fires_34" );
			
			
			
			
			break;
		}
	}
}




hide_car_00_func()
{
	self trigger_off();
}



hide_old_cars()
{
	level waittill ( "unhide_car_00" );
	old_car_01 = GetEnt( "car_01", "targetname" ); old_car_01 delete();
	old_car_02 = GetEnt( "car_02", "targetname" ); old_car_02 delete();
	old_car_03 = GetEnt( "car_03", "targetname" ); old_car_03 delete();
	old_car_04 = GetEnt( "car_04", "targetname" ); old_car_04 delete();
}



unhide_car_00_func()
{
	level waittill ( "unhide_car_00" );
	wait( .2 );
	self trigger_on();
}




start_of_level( strings, outro )
{	
	
	
	
	
	
	
	

	if (((( level.skipto_1 != 0 ) || ( level.skipto_1a != 0 ) || ( level.skipto_1b != 0 ) || ( level.skipto_2 != 0 ) || (level.skipto_3 != 0) || (level.skipto_4 != 0) || (level.skipto_5 != 0))))
	{
		return;
	}

	level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); 

	level.player FreezeControls( true );
	level.player allowcrouch( false );

	level.player = GetEnt("player", "classname" );

	level.introblack = NewHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;

	if( IsDefined( outro ) )
	{
		level.introblack.alpha = 0;
	}

	level.introblack SetShader( "black", 640, 480 );

	if( IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 2.0 );
		level.introblack.alpha = 1;
		wait( 3 );
	}

	wait( 0.05 );

	level.introstring = [];

	for( i = 0; i < strings.size; i++ )
	{
		maps\_introscreen::introscreen_create_line( strings[i] );
		if( !IsDefined( outro ) )
		{
			wait( 2 );

			if( i == strings.size - 1 )
			{
				wait( 2.5 );
			}
		}
	}

	level.player FreezeControls( false );
	level thread player_start_link_func();

	
	if( !IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 1.5 ); 
		level.introblack.alpha = 0;
	}
	else
	{
		return;
	}

	
	maps\_introscreen::introscreen_fadeOutText();
	
	level thread front_thug_follow();
}




tool_tip_mantel_func()
{
	trigger = GetEnt( "tool_tip_mantel", "targetname" );
	trigger waittill ( "trigger" );

	maps\_autosave::autosave_now("whites_estate");
}



boathouse_gen_boats_sail()
{
	gen_yacht_01 = GetEnt( "gen_yacht_01", "targetname" );
	gen_yacht_01 movey ( 35000, 180 );
	gen_yacht_01 waittill ( "movedone" );
	gen_yacht_01 delete();
}



boathouse_boat_mousetrap()
{
	clip = GetEnt( "dock_hanging_boat_clip", "targetname" );
	trigger = GetEnt( "dock_hanging_boat", "targetname" );
	trigger waittill ( "trigger" );
	clip trigger_off();
	wait( .1 );
	physicsExplosionSphere( ( -4772, 2034, -376 ), 200, 100, 1 );
	wait( .3 );
	radiusdamage( ( -4772, 2034, -462 ), 100, 150, 125 );

}


tool_tip_pip()
{
	

	
	
	

	

	level thread pip_trigger_00_func();
}




tool_tip_lean_over_cover_func()
{
	trigger = GetEnt( "tool_tip_lean_over_cover", "targetname" );
	trigger trigger_off();
	
	flag_wait("safe_hacked");
	trigger trigger_on();
	trigger waittill ( "trigger" );

	while ( 1 )
	{
		wait( .5 );
		if( level.player isInCover ())
		{
			
			
			
			
		}
	}
}



tool_tip_dash_reminder_func()
{
	trigger = GetEnt( "tool_tip_dash_reminder", "targetname" );
	trigger waittill ( "trigger" );
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_DASH");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_DASH_ZAPPER");
	}

	wait( 6 );
	tutorial_message( "" );
}








player_start_link_func()
{
	if (((( level.skipto_1 != 0 ) || ( level.skipto_1a != 0 ) || ( level.skipto_1b != 0 ) || ( level.skipto_2 != 0 ) || (level.skipto_3 != 0) || (level.skipto_4 != 0))))
	{
		return;
	}
	wait( .1 );
	org = spawn("script_origin",level.player.origin);
	level.player playerlinktodelta ( org, undefined );
}



bond_setup()
{
	level.player takeallweapons();
	level.player GiveWeapon( "p99_s" );
	
	maps\_phone::setup_phone();
	wait( .1 );
	
	wait( 3 );
	level thread map_level();
}



global_plane_flyby()
{
	plane = GetEnt( "plane_flyby", "targetname" );
	plane movex( -80000, 100 );
	plane waittill ( "movedone" );
	plane delete();
}





vision_set_boathouse()
{
	trigger = GetEnt( "vision_set_boathouse", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_1" );
	level thread vision_set_outside();
}



vision_set_outside()
{
	trigger = GetEnt( "vision_set_outside", "targetname" );
	trigger waittill ( "trigger" );

	VisionSetNaked( "whites_estate_0" );
	level thread vision_set_boathouse();
	level thread vision_set_inside();
}



vision_set_inside()
{
	trigger = GetEnt( "vision_set_inside", "targetname" );
	trigger waittill ( "trigger" );

	VisionSetNaked( "whites_estate_2" );
	level thread vision_set_outside();
	level thread vision_set_house();
	
	setExpFog(129.0, 523.0, 0.268, 0.2706, 0.221, 0, 1.0);
}

vision_set_house()
{
	trigger = GetEnt( "trigger_visionset_house", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_house" );
	level thread vision_set_cellar();
	level thread vision_set_fire();
	
	setExpFog( 494.189, 1570.0, 0.4, 0.49, 0.5, 0, 0.74 );
}


vision_set_cellar()
{
	trigger = GetEnt( "trigger_visionset_cellar02", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_2" );
	level thread vision_set_house();
	
	setExpFog(129.0, 523.0, 0.268, 0.2706, 0.221, 0, 1.0);
}


vision_set_fire()
{
	level waittill ( "white_blows_estate" );
	
	VisionSetNaked( "whites_estate_3" );
	level thread vision_set_atrium();
}


vision_set_atrium()
{
	trigger = GetEnt( "vision_set_outside", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_0" );
	level thread vision_set_housefire();
}
	

vision_set_housefire()
{
	trigger = getent("estate_save_trigger", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_house" );
	level thread vision_set_atrium();
}


vision_secondin_01()
{
	trigger = getent("trigger_vision_secondin01", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_house" );
	
	level thread vision_secondout_01();
}


vision_secondout_01()
{
	trigger = getent("trigger_vision_secondout01", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_0" );
	
	level thread vision_secondin_01();
}


vision_secondin_02()
{
	trigger = getent("trigger_vision_secondin02", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_house" );
	
	level thread vision_secondout_02();
}


vision_secondout_02()
{
	trigger = getent("trigger_vision_secondout02", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_0" );
	
	level thread vision_secondin_02();
}


vision_thirdin()
{
	trigger = getent("trigger_vision_thirdin", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_house" );
	
	level thread vision_thirdout();
}


vision_thirdout()
{
	trigger = getent("trigger_vision_thirdout", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_0" );
	
	level thread vision_thirdin();
}


vision_atrium_outside()
{
	trigger = getent("trigger_vision_atriumoutside", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_0" );
	
	setExpFog( 1536, 3317, 0.507, 0.507, 0.476, 0, 0.7622 );
	
	level thread vision_atrium_inside();
}


vision_atrium_inside()
{
	trigger = getent("trigger_vision_atriuminside", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_house" );
	
	setExpFog( 0, 200, 0.25, 0.25, 0.25, 0, 0.65 );
	
	level thread vision_atrium_outside();
}
	
	


tunnel_save_trigger()
{
	trigger = GetEnt( "tunnel_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	maps\_autosave::autosave_now("whites_estate");
}



boathouse_save_trigger()
{
	trigger = GetEnt( "boathouse_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set("boathouse_reached");
	
	level notify ( "give_up_on_weapon" );
	trigger2 = GetEnt( "estate_save_trigger", "targetname" );
	trigger2 trigger_off();

	
	maps\_autosave::autosave_now("whites_estate");
}



estate_save_trigger()
{
	trigger = GetEnt( "estate_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	
}





fx_precache()
{
	

	
	
	level._effect["estate_car_explosion"] = loadfx ("explosions/vehicle_exp_runner");
	
	
	
	level._effect["house_explosion"] = loadfx ("props/welding_exp");
}




































front_copter_land()
{
	wait( .5 );
	vehicle = GetEnt( "copter_fly_land", "targetname" );

	vehicle trigger_off();

	copter_fly_by = getent( "copter_fly_by", "targetname" );

	vehicle.vehicletype = "blackhawk";
	vehicle.script_int = 1;
	maps\_vehicle::vehicle_init( vehicle );
	vehicle.health = 10000;
	vehicle playsound ("police_helicopter_intro");
	
	
	
	level notify("playmusicpackage_start");

	wait ( .1 );	
	
	vehicle hide();
	
	level waittill ( "start_the_coppter" );
	vehicle show();
	vehicle trigger_on();
	vehicle playloopsound("police_helicopter");
	
	
	
	land = getent("origin_heli_land", "targetname");
	
	vehicle setspeed( 50, 50 );	
	vehicle setvehgoalpos (( 3915.78, 1259.11, 1016 ), 0 ); 
	vehicle waittill ( "goal" );
	vehicle setspeed( 50, 50 );
	vehicle setvehgoalpos (( 3252.69, 273.502, 592 ), 0 ); 
	vehicle waittill ( "goal" );
	vehicle setspeed( 50, 50 );
	vehicle setvehgoalpos (( 3029.98, -293.028, 496 ), 0 ); 
	vehicle waittill ( "goal" );
	vehicle setspeed( 40, 40 );
	vehicle setvehgoalpos (( 2947.19, -731.418, 509 ), 0 ); 
	vehicle waittill ( "goal" );
	vehicle setspeed( 40, 40 );
	
	vehicle setvehgoalpos(land.origin, 1);
	vehicle waittill ( "goal" );
	vehicle setspeed( 0 );
	
        
	
}



delete_all_ai()
{
	guys = getaiarray("axis", "neutral");

	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
}





front_hold_bond()
{
	trigger = GetEnt( "hold_bond_trigger", "targetname" );
	trigger waittill ( "trigger" );

	front_thug = getentarray ( "thug_followers", "targetname" );

	wait( 1 );	
	for ( i = 0; i < front_thug.size; i++ )
	{
		thug[i] = front_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] SetEnableSense( false );
		}
	}
}



front_thug_follow()
{
	level.player allowcrouch( true );
	level.player allowStand( true );
	level.player unlink();
	level.player playerSetForceCover( false, false );
}




ambient_chopper_path_01()
{
	wait( .1 );
	vehicle = GetEnt( "fake_chopper_01", "targetname" );

	vehicle.vehicletype = "blackhawk";
	vehicle.script_int = 1;
	maps\_vehicle::vehicle_init( vehicle );
	vehicle.health = 10000;
	
	
	wait ( .1 );	

	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -13008, 26944, 5216 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 22920, 5632 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 15800, 4272 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 10448, 3264 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -4320, -7656, 3264 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -1384, -9824, 3264 ), 1 ); vehicle waittill ( "goal" );
	vehicle delete();
}



tool_tip_move_left_func()
{
	threshhold = 0.2; 
	move = level.player getNormalizedMovement();
	while ( move[1] > threshhold )
	{
		move = level.player getNormalizedMovement();
		wait( 0.05 );
	}
	level.move_left++;
}



tool_tip_move_right_func()
{
	threshhold = 0.2; 

	move = level.player getNormalizedMovement();
	while ( move[1] < threshhold )
	{
		move = level.player getNormalizedMovement();
		wait( 0.05 );
	}
	level.move_right++;
}



tool_tip_move_done_func()
{
	while ( 1 )
	{
		wait( .1 ); 
		if (( level.move_left >= 1 ) && ( level.move_right >= 1 ))
		{
			level notify ( "move_func_done" );
			level notify ( "tutorial_00" );
			break;
		}
	}
}



check_full_statue_death_01()
{
	head = GetEnt( "statue_full_01", "targetname" );
	head waittill ( "damage" );
	head playsound("whites_estate_statue_headshot");
	physicsExplosionSphere( ( -1866, 524.5, -44 ), 200, 100, 2 );
	level.statue_head++;
	if ( level.statue_head >= 1 )
	{
		wait( 1 );
		level notify ( "statues_dead" );
		level.player givemaxammo( "p99_s" );
	}
}



check_full_statue_death_02()
{
	head = GetEnt( "statue_full_02", "targetname" );
	head waittill ( "damage" );
	head playsound("whites_estate_statue_headshot");
	physicsExplosionSphere( ( -1864.5, 436, -44 ), 200, 100, 2 );
	level.statue_head++;
	if ( level.statue_head >= 1 )
	{
		wait( 1 );
		level notify ( "statues_dead" );
		level.player givemaxammo( "p99_s" );
	}
}



check_statue_death_01()
{
	head = GetEnt( "statue_head_01", "targetname" );
	head waittill ( "damage" );
	physicsExplosionSphere( ( -2504, 316, -56 ), 200, 100, 2 );
	
	
	
	
	
	
	
}



check_statue_death_02()
{
	head = GetEnt( "statue_head_02", "targetname" );
	head waittill ( "damage" );
	physicsExplosionSphere( ( -2508, 640, -56 ), 200, 100, 2 );
	
	
	
	
	
	
	
}



check_statue_death_03()
{
	
	
	
	
	
	
	
	
	
	
	
}



check_statue_death_gen()
{
	self waittill ( "damage" );
	physicsExplosionSphere( self.origin + ( 5, 0, 0 ), 200, 100, 2 );
}



replenish_ammo_count()
{
	level endon ( "stop_ammo" );
	while ( 1 )
	{
		wait( .1 );
		{
			ammosize = level.player getammocount("p99_s");
			if ( ammosize == 0 )
			{
				level.player givemaxammo( "p99_s" );
			}
		}
	}
}



camera_start()
{
	trigger = GetEnt( "camera_start", "targetname" );
	trigger waittill ( "trigger" );
	level thread delete_all_ai();
}



end_thug_alert_check_func()
{
	trigger = GetEnt( "end_thug_alert_check", "targetname" );
	trigger waittill ( "trigger" );

	level thread greenhouse_wave_01_func();
	level thread greenhouse_obj_status();
	
	
	greenhouse_thug = getentarray ( "greenhouse_thugs_wave_00", "targetname" );
		
	for ( i = 0; i < greenhouse_thug.size; i++ )
	{
		thug[i] = greenhouse_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] lockalertstate( "alert_red" );
			thug[i].accuracy = 0.5;
			thug[i] thread greenhouse_death_check();
		}
	}
	
	greenhouse_thug_a = getentarray ( "greenhouse_thugs_wave_00a", "targetname" );
	node = getnode("node_cover_greenhouse", "targetname");
	
	for ( i = 0; i < greenhouse_thug_a.size; i++ )
	{
		thug_a[i] = greenhouse_thug_a[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug_a[i]) )
		{
			thug_a[i] lockalertstate( "alert_red" );
			
			
			thug_a[i] thread greenhouse_death_check();
			
			thug_a[i].accuracy = 0.5;
			wait(2.0);
			thug_a[i] setgoalnode(node, 1);
		}
	}

	level notify ( "bond_at_large_greenhouse" );
}



greenhouse_window_shooter()
{
	trigger = GetEnt( "greenhouse_window_shooter", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread shootdown_greenhouse_light();
		
	flag_set("greenhouse_reached");

	greenhouse_thug = getentarray ( "greenhouse_thugs_wave_00b", "targetname" );

	for ( i = 0; i < greenhouse_thug.size; i++ )
	{
		thug[i] = greenhouse_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] setalertstatemin( "alert_red" );
			thug[i] SetEnableSense( false );
			
			thug[i] SetCombatRole( "basic" );
			thug[i] thread greenhouse_death_check();

		}
	}
}



greenhouse_window_shoot()
{
	window = GetEnt( "greenhouse_window", "targetname" );
	if ( IsDefined ( self ))
	{
		self cmdshootatentity( window, false, 1, 100 );
		if ( IsDefined ( self ))
		{
			self StartPatrolRoute( "through_window" );
		}
	}
}



greenhouse_window_shoot_second()
{
	window = GetEnt( "greenhouse_window2", "targetname" );
	if ( IsDefined ( self ))
	{
		self cmdshootatentity( window, false, 1, 100 );
		if ( IsDefined ( self ))
		{
			self StartPatrolRoute( "through_window2" );
		}
	}
}



greenhouse_window_finish()
{
	self SetEnableSense( true );
	self setpainenable( true );
}



greenhouse_death_check()
{
	self waittill ( "death" );
	level.greenhouse_thug++;
}



greenhouse_damage_check()
{
	self waittill ( "damage" );
	self  SetEnableSense( true );
}



greenhouse_obj_status()
{
	while ( 1 )
	{
		wait( 1 );
		
		if ( level.greenhouse_thug >= 3 )
		{
			level thread damage_water_tank();
		}
		
		
		
		if ( level.greenhouse_thug >= 7 )
		{
			level notify ( "greenhouse_thugs_dead" );
			
			level thread spawn_greenhouse_victims();
			break;
		}
	}
}

damage_water_tank()
{
	water_tank = getent( "greenhouse_water_tank", "targetname" );
	damage_done = false;
	
	if (!(damage_done))
	{
		water_tank dodamage(20, water_tank.origin);
		damage_done = true;
	}
}




greenhouse_get_ready()
{
	self SetEnableSense( true );
}



greenhouse_water_tank_func()
{
	squirt = GetEnt ( "water_tank_squirt", "targetname" );
	clip = GetEnt( "greenhouse_door_clip", "targetname" );
	door = GetEnt( "greenhouse_door", "targetname" );
	door trigger_off();
	trigger = GetEnt( "greenhouse_water_tank_event", "targetname" );
	trigger trigger_off();

	level thread greenhouse_water_tank_event();

	water_tank = GetEnt( "greenhouse_water_tank", "targetname" );

	water_tank thread greenhouse_blow_door( door );

	water_tank waittill ( "damage" );
	level notify ( "water_tank_shake_start" );
	
	
	
	
	
	
	
	sound_watertank = getent("origin_sound_watertank", "targetname");
	sound_watertank playloopsound("whites_estate_tank_steam_loop");
	
	level waittill ( "greenhouse_thugs_dead" );
	
	flag_wait("victims_in_place");
	
	trigger trigger_on();
	level waittill( "water_tank_look_at" );
	
	level notify ( "water_tank_explode_start" );
	
	
	
	
	
	
	sound_watertank = getent("origin_sound_watertank", "targetname");
	
	sound_watertank playsound("whitesestate_tank_explosion");
	
	
	
	clip trigger_off();
	
	
	
	
	flag_set("security_eliminated");
	
	earthquake (0.3, 1.0, level.player.origin, 700, 10.0 );
	
	explosion = getent("origin_greenhouse_victim", "targetname");
	radiusdamage (explosion.origin, 120, 120, 120 );
	
	wait(2.0);
	
	
	
	
	maps\_autosave::autosave_now("whites_estate");
}



greenhouse_water_tank_hint()
{
	wait( 15 );
	if (( level.greenhouse_thug >= 6 ) && ( level.water_tank == 0 ))
	{
		tutorial_message("WHITES_ESTATE_WATER_TANK");

		org = spawn("script_origin",level.player.origin);
		level.player playerlinktodelta ( org, undefined );
		level.player waittill( "tutorialclosed" );

		level.player unlink();
	}
}




greenhouse_blow_door( door )
{
	squirt = GetEnt ( "water_tank_squirt", "targetname" );
	clip = GetEnt( "greenhouse_door_clip", "targetname" );
	trigger = GetEnt( "greenhouse_water_tank_event", "targetname" );
	self waittill ( "trigger" );

	if (( IsDefined ( self )) && ( level.greenhouse_thug >= 6 ))
	{
		trigger trigger_on();
		level waittill( "water_tank_look_at" );
		level notify ( "water_tank_shake_start" );
		
		
		
		
		wait( 2 );
		squirt delete();
		level notify ( "water_tank_explode_start" );
		
		sound_watertank = getent("origin_sound_watertank", "targetname");
		sound_watertank stoploopsound();
		sound_watertank playsound("whitesestate_tank_explosion");
		
		
		earthquake (0.1, 1.2, level.player.origin, 700, 10.0 );
		
		physicsExplosionSphere( sound_watertank.origin, 700, 300, 5.0 );
			
		
		clip trigger_off();
		door disconnectPaths();
		
		wait( 3 );
		sound_watertank playsound("whitesestate_tank_explosion_b");
		
		level thread pip_trigger_00_func();
	}
}



greenhouse_water_tank_event()
{
	trigger = GetEnt( "greenhouse_water_tank_event", "targetname" );
	trigger waittill( "trigger" );
	level notify ( "water_tank_look_at" );
	level.water_tank++;
}



greenhouse_wave_01_func()
{
	while ( 1 )
	{
		wait( 1 );
		if (( level.greenhouse_thug >= 3 ) || ( level.force_gh_spawn >= 2 ))
		{
			greenhouse_thug = getentarray ( "greenhouse_thugs_wave_01", "targetname" );
						
			for ( i = 0; i < greenhouse_thug.size; i++ )
			{
				thug[i] = greenhouse_thug[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( thug[i]) )
				{
					thug[i] setperfectsense(true);
					thug[i].accuracy = 0.5;
					thug[i] SetCombatRole( "basic" );
					thug[i] thread set_flanking_pos(i);
					thug[i] thread greenhouse_death_check();
				}
			}
			
			break;
		}
	}
}


set_flanking_pos(i)
{
	node_cover = getnodearray ( "node_cover_greenhouseback", "targetname" );
	node = getnode ( "node_cover_greenhouseside", "targetname" );
	
	if (isdefined(self))
	{
		self setgoalnode(node, 1);
		self waittill("goal");
	}
	
	if (isdefined(self))
	{
		self setgoalnode(node_cover[i], 1);
	}
}



















fountain_thug_01()
{
	level waittill ( "wave1_go" );
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_01" );
	}
}



fountain_thug_02()
{
	level waittill ( "wave2_go" );
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_02" );
	}
}



fountain_thug_01_alt()
{
	wait( 1.5 );
	self CmdAction ( "reload", true );
	level waittill ( "wave1_go" );
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_01" );
	}
}



fountain_thug_02_alt()
{
	wait( 1.5 );
	self CmdAction ( "scan", true );
	level waittill ( "wave2_go" );
	self stopallcmds();
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_02" );
	}
}



roof_birds_01_func()
{
	org = getent ( "roof_birds_01", "targetname" );
	trigger = getent ( "roof_trigger_birds_01", "targetname" );
	trigger waittill ( "trigger" );
	playfx ( level._effect["science_startled_birds"], org.origin );
	org playsound( "birds_taking_off" ); 
}



garden_thugs_death_check()
{
	
	self waittill ( "death"  );
	level.garden_death++;
	wait( .5 );
	if ( level.garden_death >= 2 )
	{
		level notify ( "garden_thugs_dead" );
		wait( 1 );

		org = spawn("script_origin",level.player.origin);
		level.player playerlinktodelta ( org, undefined );
		level.player waittill( "tutorialclosed" );
		level.player unlink();

		level waittill ( "gate_hacked" );
		level thread objective_tracker();
	}
}



garden_teach_lock_hack()
{
	
	
	level waittill ( "garden_thugs_dead" );
	

	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_LOCKPICK");

	org = spawn("script_origin",level.player.origin);
	level.player playerlinktodelta ( org, undefined );
	level.player waittill( "tutorialclosed" );

	level.player unlink();
}



garden_thugs_func()
{
	level waittill ( "garden_thugs_attack" );

	
	

	tutorial_message( "M: Bond, we're tracking some thugs on satellite get ready to defend yourself." );
	
	thread open_gate();
	
	garden_thugs = getentarray ( "garden_thugs", "targetname" );

	for ( i = 0; i < garden_thugs.size; i++ )
	{
		thug[i] = garden_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] SetCombatRole( "basic" );
			thug[i] setalertstatemin( "alert_red" );
			thug[i] thread garden_thugs_death_check();
		}
	}
	
	wait( 4 );
	tutorial_message( "" );
}



garden_gates_open()
{
	door_node = Getnode( "boathouse_gate", "targetname" );
	door_node maps\_doors::open_door_from_door_node();

	level waittill ( "boathouse_gate_close" );
	door_node maps\_doors::close_door_from_door_node();
	
	level waittill ( "gate_hacked" );
}



boathouse_in_cover()
{
	while ( 1 )
	{
		wait( .5 );
		if( level.player isInCover ())
		{
			tutorial_message( "Use the cover to protect your self from enemy gun fire." );
			wait( 4 );
			tutorial_message( "" );
			break;
		}
	}
}



boathouse_lookat()
{
	trigger = GetEnt( "boathouse_dock_fight_lookat", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "boathouse_lookat_triggered" );
}



boathouse_trigger()
{
	trigger = GetEnt( "boathouse_dock_fight_trigger", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "boathouse_lookat_triggered" );
}







boathouse_node_reached()
{
	self waittill ( "goal" );
	self SetEnableSense( true );
}



boathouse_thug_spawn_check1()
{
	self waittill ( "death" );
	level.boathouse++;
}



boathouse_thugs_run()
{
	while ( 1 )
	{
		wait( .1 );
		if (( level.boathouse >= 2 ) && ( IsDefined ( self )))
		{
			self SetEnableSense( false );
			self SetCombatRole( "basic" );
			self StartPatrolRoute( "boathouse" );
			break;
		}
	}
}



boathouse_thug_check()
{
	self waittill ( "death" );
	level.boathouse_tracker++;
}



boathouse_flanker_func()
{
	while ( 1 )
	{
		wait( .1 );
		if ( level.boathouse_tracker >= 2 )
		{
			wait( 1 );

			
			
			
			
			

			flanker_thug = getent ("boathouse_thug_01", "targetname")  stalingradspawn( "flanker_thug" );
			flanker_thug waittill( "finished spawning" );
			flanker_thug LockAlertState( "alert_red" );
			flanker_thug SetEnableSense( false );
			
			
			
			break;
		}
	}
}



ai_kicks_door()
{
	
	sound_boathouse_door = GetEnt( "origin_sound_boathouse", "targetname" );
	
	
	
	
	
	
	sound_boathouse_door playsound("whites_estate_boathouse_door");
	
	
	
	if ( isdefined ( self ))
	{
		self  SetEnableSense( true );
		self setpainenable( true );
		self.health = 100;
		self setcombatrole ( "turret" );
	}
}











#using_animtree( "vehicles" );
boat_float()
{
	yacht = GetEnt( "whites_yacht", "targetname" );
	yacht UseAnimTree(#animtree);
	yacht setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}



#using_animtree( "vehicles" );
boat_01_anim_play()
{
	self thread escape_boat_drone1();
	self thread spawn_boat_guard01();
	self UseAnimTree( #animtree );
	self animscripted( "boat_01_away", self.origin, self.angles, %v_boat_depart_1 );
}



#using_animtree( "vehicles" );
boat_02_anim_play()
{
	self thread escape_boat_drone2();
	self thread spawn_boat_guard02();
	
	self UseAnimTree( #animtree );
	self animscripted( "boat_02_away", self.origin, self.angles, %v_boat_depart_2 );
}

#using_animtree("fakeshooters");
escape_boat_drone1()
{
	
	level.escape_boat_thug1 = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	level.escape_boat_thug1.angles = self.angles;
	level.escape_boat_thug1 character\character_thug_1_white::main();  
	level.escape_boat_thug1 LinkTo( self, "tag_driver", (0,0,-12), (0,0,0) );
	
	
	level.escape_boat_thug1 playsound("whites_estate_motor_boat_01");
	level.escape_boat_thug1 useAnimTree(#animtree);
	level.escape_boat_thug1 setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	
	wait(8.0);
	
	level.escape_boat_thug1 delete();
}

#using_animtree("fakeshooters");
escape_boat_drone2()
{
	
	level.escape_boat_thug = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	level.escape_boat_thug.angles = self.angles;
	level.escape_boat_thug character\character_thug_1_white::main();  
	level.escape_boat_thug LinkTo( self, "tag_driver", (0,0,-12), (0,0,0) );
	
	
	level.escape_boat_thug playsound("whites_estate_motor_boat_02");
	level.escape_boat_thug useAnimTree(#animtree);
	level.escape_boat_thug setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);

	
	wait(8.0);
	
	level.escape_boat_thug delete();
}




greenhouse_fight()
{
	trigger = GetEnt( "greenhouse_thug_walk", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "stop_ammo" );
	level thread small_greenhouse_gauntlet();

	
	greenhouse_thugs = getentarray ( "greenhouse_small_thugs", "targetname" );

	for ( i = 0; i < greenhouse_thugs.size; i++ )
	{
		thug[i] = greenhouse_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] thread global_radio_chatter();
			thug[i] setpainenable( false );
			thug[i] SetEnableSense( false );
			thug[i] setalertstatemin( "alert_red" );
			
			
		}
	}
}



shooter_check_damage()
{
	trigger = GetEnt( "shooters_shoot", "targetname" );
	trigger waittill ( "trigger" );
	wait( 5 );
	self setignorethreat( level.player, false );
}



greenhouse_shooter_03()
{
	if ( IsDefined ( self ))
	{
		self SetCombatRole( "turret" );
	}
}



greenhouse_last_man_standing()
{
	self waittill ( "death" );
	level.last_man++;
}



greenhouse_last_man_standing_think()
{
	while ( 1 )
	{
		wait( .1 );
		if (( level.last_man >= 2 ) && ( IsDefined ( self )))
		{
			self SetEnableSense( false );
			self SetCombatRole( "basic" );
			self StartPatrolRoute( "big_greenhouse_new_spot" );
			break;
		}
	}
}



greenhouse_turn_back()
{
	if ( IsDefined ( self ))
	{
		self SetEnableSense( true );
	}
}



greenhouse_looker()
{
	if ( IsDefined ( self ))
	{
		self SetEnableSense( true ) ;
		self setpainenable( true );
	}

	wait( 1 );

	if ( IsDefined ( self ))
	{
		self StartPatrolRoute( "small_greenhouse" );
	}
}



basket_push_func()
{
	
	org = GetEnt( "basket_push_org", "targetname" );
	
	
	wait(0.3);
	
	physicsExplosionSphere( org.origin, 200, 100, .5 );
}



ai_delete_all()
{
	guys = getaiarray("axis", "neutral");
	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
}



cellar_trigger_fall_guy_fuc()
{
	
	
	node = getnode("node_balcony_cellar", "targetname");
	
	
	

	
	

	trigger = GetEnt( "cellar_trigger_fall_guy", "targetname" );
	trigger waittill ( "trigger" );

	level thread cellar_thug_hits_door_func();

	fall_guy = getent ( "cellar_fall_guy", "targetname" )  stalingradspawn( "fall_guy" );
	
	
	fall_guy LockAlertState( "alert_red" );
	fall_guy setpainenable( false );
	fall_guy allowedstances("stand");
	fall_guy thread ach_headshot();
	
	fall_guy setgoalnode(node, 0);

	fall_guy waittill ( "goal" );
	
	fall_guy setperfectsense(true);
	
	fall_guy.accuracy = 0.6;
	
	level thread check_fall_guy();
	
	for (i=0; i<4; i++)
	{
		rand = randomintrange(1, 5);
		
		if (isdefined(fall_guy))
		{
			if ((rand) == 1)
				fall_guy thread shoot_at_01();
			else if ((rand) == 2)
				fall_guy thread shoot_at_02();
			else if ((rand) == 3)
				fall_guy thread shoot_at_03();
			else if ((rand) == 4)
				fall_guy thread shoot_at_04();
		}
		wait(1.5);
	}
}


check_fall_guy()
{
	
	guy = getent("fall_guy", "targetname");
	
	alive = true;
	
	while(alive)
	{
		guy = getent("fall_guy", "targetname");
		
		if (!(isdefined(guy)))
		{
			alive = false;
		}
		
		wait(0.05);
	}
	
	wait(1.0);
	
	
	
	wait(1.0);
	
	level notify ( "cellar_doors_start" );
	
	
}


shoot_at_01()
{
	if (isdefined(self))
		self cmdshootatpos((-364, -734, 111), false, 1.0);
}

shoot_at_02()
{
	if (isdefined(self))
		self cmdshootatpos((-596, -721, 88), false, 1.0);
}

shoot_at_03()
{
	if (isdefined(self))
		self cmdshootatpos((-596, -839, 88), false, 1.0);
}

shoot_at_04()
{
	if (isdefined(self))
		self cmdshootatpos((-364, -836, 111), false, 1.0);
}





cellar_thug_hits_door_func()
{
	
	
	cellar_sound = getent("cellar_door_sound", "targetname");
	
	cellar_temp_block = GetEnt( "cellar_temp_block", "targetname" );
	trigger = GetEnt( "cellar_thug_hits_door", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "cellar_doors_start" );
	
	cellar_sound playsound("whites_estate_body_impact_wood");
	
	
	level notify("playmusicpackage_cellar");

	cellar_temp_block delete();
	
	
}




cellar_thugs_spawn_01_func()
{
	trigger = GetEnt( "cellar_thugs_spawn", "targetname" );
	trigger waittill ( "trigger" );
	
	
	

	
	

	
	

	level thread close_balcony_window();

	
	
	level thread cellar_ext();

	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}



cellar_thug_check()
{
	self waittill ( "death" );
	level.cellar_thug++;
}



celler_thug_trigger_func()
{
	trigger = GetEnt( "cellar_thugs_spawn_02", "targetname" );
	trigger waittill ( "trigger" );
	level.cellar_thug = 1;
}




cellar_thugs_spawn_02_func()
{
	while ( 1 )
	{
		wait( .5 );
		if ( level.cellar_thug >= 1 )
		{
			cellar_thugs = getentarray ( "cellar_thugs_01", "targetname" );

			for ( i = 0; i < cellar_thugs.size; i++ )
			{
				thug[i] = cellar_thugs[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( thug[i]) )
				{
					thug[i] thread global_radio_chatter();
					thug[i] LockAlertState( "alert_red" );
				}
			}
			break;
		}
	}
}



cellar_push_glass()
{
	trigger = GetEnt( "cellar_push_glass", "targetname" );
	trigger waittill ( "trigger" );
	physicsExplosionSphere( ( 388, -232, -153 ), 200, 100, 2 );
}



death_check_cellar()
{
	self waittill ( "death" );
}



cellar_ext()
{
	trigger = GetEnt( "cellar_ext_trigger", "targetname" );
	trigger waittill ( "trigger" );

	
	
	flag_set("entrance_found");

	
	
	
	

	
}


global_radio_chatter()
{
	entOrigin = spawn( "script_origin", self.origin + ( 0, 0, 0 ) );
	entOrigin linkto( self, "tag_origin", (0, 0, 40), (0, 0, 0) );

	self endon ( "death" );
	while ( 1 )
	{
		wait( 5.0 + randomfloat( 10.30 ) );
		if ( isdefined ( self ))
		{

		}
	}
}




estate_open_kitchen_door()
{
	door = GetEnt( "estate_door_blocker", "targetname" );
	door trigger_off();
}



villa_save_game_func()
{
	trigger = GetEnt( "villa_save_game", "targetname" );
	trigger waittill ( "trigger" );
	
	
	
	
	maps\_autosave::autosave_now("whites_estate");
}



safe_room_save_func()
{
	trigger = GetEnt( "safe_room_save", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread vo_safe_room();
	
	level.safe_room_found = true;
	
	
	level thread villa_safe_wall();
	
	
	
	
	
	
	
	

	wait( 1 );

	maps\_autosave::autosave_now("whites_estate");
}


spawn_cutscene_white()
{
	trigger = GetEnt( "trigger_cutscene_white", "targetname" );
	trigger waittill ( "trigger" );
	
	spawner1 = getent("white", "targetname");
	spawner2 = getent("thug_helper", "targetname");
	detonator = getent("detonator", "targetname");
	
	white = spawner1 stalingradspawn("white");
	thug_helper = spawner2 stalingradspawn("thug_helper");
	
	white setenablesense(false);
	thug_helper setenablesense(false);
	
	detonator linkto(white, "tag_weapon_right");
}


spawn_computer_guy()
{
	spawner = getent("spawner_computer_room", "targetname");
		
	guard = spawner stalingradspawn("guard");
}




setting_up_safe()
{
 	maps\_playerawareness::setupSingleUseOnly(
 			"safe_box",		
 			::hack_whites_safe,		
 			&"WHITES_ESTATE_OPEN_SAFE",	
 			undefined,  
 			undefined,	
 			false,		
 			true,		
 			undefined,	
 			level.awarenessMaterialMetal, 
 			false,		
 			false,		
 			false );	
}

hack_whites_safe( strcObject )
{
	control = strcObject.primaryEntity;
	control endon( "hacked" );

	entOrigin = spawn("script_origin", level.player.origin + ( 0, 0, 7 ));
	entOrigin.targetname = "special_lockpick_origin";
	entOrigin.angles = level.player GetPlayerAngles();

	control._doors_lock_lockparams = "complexity:2 speed:2 code:4";
	control thread maps\_unlock_mechanisms::elecLockpickActivated();
	level.player waittill( "lockpick_done" );
	
	

	if( level.player.lockSuccess == true )
	{
		flag_set("safe_hacked");
		flag_set("safe_located");
		
		
		
		
		
		
		
		
		
		maps\_autosave::autosave_now("whites_estate");

		level notify ( "open_z_gates" );

		wait( 0.15 );
		entOrigin Delete();
		
		wait(1.5);
	}
	
	
	
	else
	{
		wait( 0.15 );
		entOrigin Delete();

		maps\_playerawareness::setupSingleUseOnly(
			"safe_box",		
			::hack_whites_safe,		
			&"WHITES_ESTATE_OPEN_SAFE",	
			undefined,  
			undefined,	
			false,		
			true,		
			undefined,	
			level.awarenessMaterialMetal, 
			false,		
			false,		
			false );	
	}
}



villa_bomb_prop_swap()
{
	
	
	
	old_obj_02 = GetEnt( "desk_1", "targetname" ); 
	
	arm_clip = GetEnt( "arm_damage_01_clip", "targetname" ); arm_clip trigger_off();
	
	level waittill ( "white_blows_estate" );
	
	
	arm_clip trigger_on();
	
	
	
	
	
	
	beam_before = getent("blowupbeam_01", "targetname");
	if (isdefined(beam_before))
	{
		beam_before delete();
	}
	
	beam_after = getent("blowupbeam_01_after", "targetname");
	beam_after trigger_on();
	beam_after show();

	level waittill ( "second_explosion" ); 
	
	
}



second_fish_tank()
{
	fish_tank_glass = GetEnt( "water_gusher", "targetname" );
	trigger = GetEnt( "fish_tank_hurt_trigger", "targetname" );
	trigger trigger_off();

	
	

	
	
	
	
	

	
	
	


	
	
	
	
	

	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
}



fish_tank_backup()
{
	wait( 10 );
	self dodamage( 100, self.origin );
}



kitcen_fire_func()
{
	fire_origin = GetEnt( "kitcen_fire_origin", "targetname" );
	physic_origin = GetEnt( "kitcen_physic_origin", "targetname" );

	trigger = GetEnt( "villa_blow_kitchen", "targetname" );
	trigger waittill ( "trigger" );

	fire_origin playsound("whites_estate_house_generic_explosion");

	fx = playfx (level._effect["large_boom"], fire_origin.origin );
	earthquake (0.7, 0.7, level.player.origin, 700, 10.0 );
	fx = playfx (level._effect["large_fire"], fire_origin.origin );
	physicsExplosionSphere( fire_origin.origin, 200, 100, 15 );
	physicsExplosionSphere( physic_origin.origin, 200, 100, 15 );

	self trigger_on();
}



villa_push_statue_func()
{
	trigger = GetEntArray( "villa_push_statue", "targetname" );
	for ( i = 0; i < trigger.size; i++ )
	{
		trigger[i] thread villa_trigger_push_func();
	}
}



villa_trigger_push_func()
{
	self waittill ( "trigger" );
	org = spawn("script_origin",level.player.origin);
	physicsExplosionSphere( org.origin, 200, 100, 5 );
}



villa_fire_triggers_setup()
{
	desk_clip = GetEnt( "desk_clip", "targetname" );
	trigger1 = GetEnt( "trigger_second_explosion", "targetname" ); 	trigger2 = GetEnt( "trigger_third_explosion_setup", "targetname" );
	trigger3 = GetEnt( "trigger_third_explosion_back_up", "targetname" ); 	trigger4 = GetEnt( "trigger_third_explosion_look_at", "targetname" );
	trigger5 = GetEnt( "trigger_fourth_explosion", "targetname" ); 	trigger6 = GetEnt( "trigger_fifth_explosion", "targetname" );
	trigger7 = GetEnt( "estate_save_trigger", "targetname" ); trigger8 = GetEnt( "villa_blow_kitchen", "targetname" );

	trigger1 trigger_off(); trigger2 trigger_off(); trigger3 trigger_off(); trigger4 trigger_off(); trigger5 trigger_off();
	trigger6 trigger_off(); trigger7 trigger_off(); trigger8 trigger_off();

	level waittill ( "white_blows_estate" );

	desk_clip trigger_off(); trigger1 trigger_on(); trigger2 trigger_on(); trigger3 trigger_on(); trigger4 trigger_on(); trigger5 trigger_on();
	trigger6 trigger_on(); trigger7 trigger_on(); trigger8 trigger_on();
}



villa_hurt_triggers()
{
	trigger1 = GetEnt( "trigger_fire_01", "targetname" );
	trigger1 thread fire_position_01();
	trigger1 trigger_off();

	trigger2 = GetEnt( "fire_trigger_02", "targetname" );
	trigger2 trigger_off();
	trigger2 thread fire_position_02();

	trigger3 = GetEnt( "fire_trigger_03", "targetname" );
	trigger3 trigger_off();
	trigger3 thread fire_position_03();

	trigger4 = GetEnt( "fire_trigger_04", "targetname" );
	trigger4 trigger_off();
	trigger4 thread fire_position_04();

	kitcen = GetEnt( "kitcen_fire_trigger", "targetname" );
	kitcen trigger_off();
	kitcen thread kitcen_fire_func();

	
	
	
	

	
	
	
	
	level thread fire_05_obj();
}



fire_position_01()
{
	fire_origin = GetEntArray( "fire_origin_01", "targetname" );
	

	for ( i = 0; i< fire_origin.size; i++ )
	{
		fire_origin[i] thread villa_play_fire_01();
	}
	
	
	
	
	

	level waittill ( "white_blows_estate" );
	self trigger_on();
	
	level thread fire_01_sound();
}



villa_trigger_knockback( trigger )
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		
		
		
	}
}



villa_play_fire_01()
{
	level waittill ( "white_blows_estate" );

	fx = playfx (level._effect["large_boom"], self.origin );
	
	
	

	level notify ( "fires_1" ); 
	level notify ( "fires_2" ); 
	level notify ( "fires_3" ); 
	level notify ( "fires_4" ); 
	level notify ( "fires_5" );
	level notify ( "fires_6" ); 
	level notify ( "fires_7" ); 
	level notify ( "fires_11" ); 
	level notify ( "fires_18" ); 
	level notify ( "fires_24" ); 
	level notify ( "fires_31" );
	level notify ( "fires_32" );
	level notify ( "fires_33" );
	level notify ( "fires_34" );
	level notify ( "fires_35" );
	level notify ( "small_fires_1" ); 
	level notify ( "small_fires_2" );
	level notify ( "fires_8" );
	level notify ( "fires_10" ); 
	level notify ( "small_fires_42" );
	level notify ( "ceiling_smoke_1" ); 
	level notify ( "ceiling_smoke_2" ); 
	level notify ( "ceiling_smoke_3" ); 
	level notify ( "ceiling_smoke_4" ); 
	level notify ( "ceiling_smoke_5" ); 
	level notify ( "ceiling_smoke_6" ); 

	
}



fire_position_02()
{
	trigger = GetEnt( "trigger_second_explosion", "targetname" );
	trigger waittill ( "trigger" );
	
	if (!level.floor_gone)
	{
		level thread blow_up_floor();
		
		push = getent("origin_knockover_01", "targetname");
	
		wait(0.1);
	
		level.player knockback(2000, push.origin + (0, 0, 0));
		
		
		wait(0.5);
		
		push delete();
	}
}






trigger_floor_collapse()
{
	
	
	
	flag_wait("blowup_floor");
	
	if (!level.floor_gone)
	{
		level thread blow_up_floor();
	}
}






blow_up_floor()
{
	fire_node = GetEntArray( "fire_origin_02", "targetname" );

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
	}

	level notify ( "white_blows_estate" );
	level notify ( "second_explosion" );
	
	level thread explode_third_floor();
	
	blowupfloor2 = GetEnt( "blowupfloor2", "targetname" );
	blowupfloor2_after = GetEnt( "blowupfloor2_after", "targetname" );
	
	level.player playsound("whites_estate_house_floor_explosion");
	
	earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
	
	if (isdefined(blowupfloor2))
	{
		blowupfloor2 delete();
	}
	
	if (isdefined(blowupfloor2_after))
	{
		blowupfloor2_after show();
	}
	
	level notify ( "fires_8" ); level notify ( "fires_12" ); level notify ( "fires_41" ); level notify ( "fires_9" );
	self trigger_on();
	level thread fire_02_sound();
	
	level.floor_gone = true;
}






fire_position_03()
{
	trigger = GetEnt( "trigger_third_explosion_setup", "targetname" );
	trigger waittill ( "trigger" );

	level thread fire_03_explosions();
	
	railing2_after = getent("railing_f2_l_after", "targetname");
	railing2_after show();
	
	railing2 = getent("railing_f2_l", "targetname");
	railing2 delete();
	
	

	
	
	
	

	level notify ( "white_blows_estate" );
	level notify ( "third_explosion" );
	
	level notify ( "fires_13" ); 
	level notify ( "fires_14" ); 
	level notify ( "fires_25" ); 
	level notify ( "fires_26" ); 
	
	
	
	
	
	self trigger_on();
	
	level thread fire_03_sound();
}


fire_03_explosions()
{
	fire_node = GetEntArray( "fire_origin_03", "targetname" );
	
	fire_node[0] playsound("whites_estate_house_generic_explosion");
	
	physicsExplosionSphere( fire_node[0].origin, 140, 100, 15 );
	
	earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
	
	level thread statue_fall_above();

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
		wait(1.0);
	}
}



fire_position_04()
{
	trigger = GetEnt( "trigger_fourth_explosion", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread spawn_atrium_victim();
	level thread fire_position_05();
	
	piano_after = getent("piano_after", "targetname");
	piano_after show();
	
	piano = getent("piano", "targetname");
	piano delete();

	fire_node = GetEntArray( "fire_origin_04", "targetname" );

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
	}

	level notify ( "white_blows_estate" );
	level notify ( "fourth_explosion" );
	level notify ( "fires_19" ); 
	level notify ( "fires_20" ); 
	level notify ( "fires_21" ); 
	level notify ( "fires_22" ); 
	level notify ( "fires_23" );
	level notify ( "fires_36" ); 
	level notify ( "fires_37" ); 
	level notify ( "fires_38" ); 
	level notify ( "fires_39" ); 
	level notify ( "fires_40" );
	level notify ( "fires_24" ); 
	level notify ( "fires_35" );
	
	playfx (level._effect["large_fire"], ( 548, -434, 24 ) );
	self trigger_on();
	
	explosion = getent("origin_piano_explosion", "targetname");
	explosion playsound("whites_estate_house_piano_explosion");
	
	earthquake (0.6, 1.3, level.player.origin, 700, 15.0 );
	
	level thread fire_04_sound();
	
	
	
	wait(1.0);
	
	flag_set("defended");
	maps\_autosave::autosave_now("whites_estate");
}


ceiling_explosion()
{
	ceiling = getent("origin_ceiling_explosion", "targetname");
	holebefore = getent("blowupceiling_f1", "targetname");
	holeafter = getent("blowupceiling_after", "targetname");
	
	holebefore delete();
	holeafter show();
	physicsExplosionSphere( ceiling.origin, 200, 150, 10 );
	
	wait(0.5);
	
	ceiling delete();
}


after_explosion()
{
	floor_preatrium_after = getent("floor_preatrium_after", "targetname");
	floor_preatrium_after show();
	

}




fire_position_05()
{
	trigger = GetEnt( "trigger_fifth_explosion", "targetname" );
	trigger waittill ( "trigger" );

	fire_node = GetEntArray( "fire_origin_05", "targetname" );

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
	}

	level notify ( "white_blows_estate" );
	level notify ( "fifth_explosion" );
	self trigger_on();
	
	level thread fire_05_sound();
	level thread after_explosion();
}



fire_05_obj()
{
	
	
	trigger = GetEnt( "trigger_fifth_explosion", "targetname" );
	trigger waittill ( "trigger" );
	
	fire_obj = GetEntArray( "fire_origin_05a", "targetname" );
	push = getent("origin_final_push", "targetname");
	
	flag_set("atrium_victim");
	
	level notify("door_explode_start");
	
	clip_conserv = getent("clip_weapon_conservatory", "targetname");
	clip_conserv delete();
	
	fire_obj[0] playsound("whites_estate_house_wooddoor_explosion");
	
	earthquake (0.8, 1.3, level.player.origin, 700, 10.0 );
	level.player knockback(3000, push.origin + (0, 0, 0));

	for ( i = 0; i< fire_obj.size; i++ )
	{
		fire_obj[i] thread villa_play_fire_obj();
	}
	wait( .5 );
	
	
}



villa_play_fire_obj()
{
	fx = playfx (level._effect["fire_ball"], self.origin );
	playfx (level._effect["fire_ball"], self.origin );
	
}





villa_safe_wall()
{
	dresser = GetEnt( "shelf_move", "targetname" );
	clip = GetEnt( "shelf_hidden_room_clip", "targetname" );
	
	
	
	
	
	flag_wait("safe_hacked");
	
	
	
	

	dresser movex(-24, 3.5);
	dresser playsound("whites_estate_secret_wooddoor_part1");
	
	wait (5.0);
	
	dresser movey ( 56, 5.0 );
	dresser playsound("whites_estate_secret_wooddoor");
	
	
	clip movey ( 56, .1 );

	
	
	
	
	
}








villa_computer_hack_func()
{
	trigger = GetEnt( "villa_computer_hack", "targetname" );
	trigger waittill ( "trigger" );
	trigger trigger_off();
	
	level.player FreezeControls( true );
	
	
	
	
	level thread close_bookcase();
	
	VisionSetNaked( "whites_estate_0" );
	
	level thread letterbox_on(false, false);
	
	playcutscene("WE_Detonate", "WE_Detonate_Done");

	level thread spawn_balcony_outside();

	

	
	
	level.player customcamera_checkcollisions( 0 );
	
	level waittill("WE_Detonate_Done");
	
	house_fire = getentarray("triggerhurt_fire_house", "targetname");
	for (i=0; i<house_fire.size; i++)
	{
		house_fire[i] trigger_on();
	}
	
	firecoll = getentarray("collision_fire_house", "targetname");
	for (k=0; k<firecoll.size; k++)
	{
		firecoll[k] trigger_on();
	}
	
	cameraID_white_boom = level.player customCamera_Push( "world", ( 1526.43, 972.6, 666.15 ), ( -3.16, -142.63, 0.00 ), 0.0);

	level thread villa_white_blowing_estate();
	level thread villa_blow_wall();
	level thread planter_damage();
	
	
	flag_wait("explosion_done");
	
	level.player customCamera_pop( cameraID_white_boom, 0.0 );
	level.player customcamera_checkcollisions( 1 );

	letterbox_off();

	level notify ( "white_blows_estate" );
	
	level.player FreezeControls( false );
	
	level thread explode_server_room();
	level thread safe_room_destroy();
		
	room2 = getent("room_destroyed_02", "targetname");
	room2 show();
	room2 trigger_on();
	
	level thread villa_first_wave();
	
	
	
	
	VisionSetNaked( "whites_estate_house" );
}


close_bookcase()
{
	dresser = GetEnt( "shelf_move", "targetname" );
	clip = GetEnt( "shelf_hidden_room_clip", "targetname" );
	
	clip movey (-56, 0.3);
	dresser movey ( -56, 5.0 );
	dresser playsound("whites_estate_secret_wooddoor");
			
	wait (5.5);
	
	dresser movex(24, 3.5);
	dresser playsound("whites_estate_secret_wooddoor_part1");
}


planter_damage()
{
	planter_after = getentarray("planter_after", "targetname");
	for (i=0; i<planter_after.size; i++)
	{
		planter_after[i] show();
	}
	
	planter = getentarray("planter", "targetname");
	for (i=0; i<planter.size; i++)
	{
		planter[i] delete();
}
}





villa_white_blowing_estate()
{
	wait(1.0);
	
	level thread tower_top_explosion();
	
	wait(1.0);
	
	level thread tower_mid_explosion();
	
	wait(1.0);
	
	level thread roof_corner_explosion();
		
	wait(0.8);
	
	level thread tower_bottom_explosion();
	
	wait(0.9);
	
	level thread balcony_outside_explosion();	
	
	wait(4.0);
	
	flag_set("explosion_done");
}

tower_top_explosion()
{
	tower_top = getent("origin_explosion_towertop", "targetname");
	tower_glasstop = getent("tower_glass_top", "targetname");
		
	physicsExplosionSphere(tower_top.origin, 160, 160, 20);
		
	tower_glasstop delete();
	
	wait(0.05);
	
	playfx (level._effect["house_explosion"], tower_top.origin);
	
	
	
	
	
	earthquake (0.5, 0.8, level.player.origin, 50000, 8.0 );
	
	level.player playsound("whites_estate_house_exterior_explosion");
}

tower_mid_explosion()
{
	tower_window = getent("origin_explosion_tower", "targetname");
	
	physicsExplosionSphere(tower_window.origin, 200, 100, 40 );
	
	tower_glassmid = getentarray("tower_glass_middle", "targetname");
	for (i=0; i<tower_glassmid.size; i++)
	{
		tower_glassmid[i] delete();
	}
	
	wait(0.1);
	
	playfx (level._effect["house_explosion"], (739, 297, 600));
	playfx (level._effect["house_explosion"], (809, 222, 600));
	
	earthquake (0.5, 0.8, level.player.origin, 50000, 8.0 );
	
	level.player playsound("whites_estate_house_exterior_explosion");
}

roof_corner_explosion()
{
	tower_small = getent("origin_explosion_towersmall", "targetname");
	roof_corner = getentarray("roof_corner", "targetname");
	
	physicsExplosionSphere(tower_small.origin, 200, 100, 10 );
	
	wait(0.1);
	
	playfx (level._effect["house_explosion"], tower_small.origin);
	
	earthquake (0.5, 0.8, level.player.origin, 50000, 8.0 );
	
	for (i=0; i<roof_corner.size; i++)
	{
		roof_corner[i] delete();
	}
	
	level.player playsound("whites_estate_house_exterior_explosion");
}
	
tower_bottom_explosion()
{
	tower_glassbot = getentarray("tower_glass_bottom", "targetname");

	physicsExplosionSphere( ( 740, 312, 404 ), 200, 100, 10 );
	physicsExplosionSphere( ( 816, 224, 424 ), 200, 100, 20 );
	
	for (i=0; i<tower_glassbot.size; i++)
	{
		tower_glassbot[i] delete();
	}
	
	wait(0.05);

	level notify ( "explosion_1" );
	
	earthquake (0.5, 0.7, level.player.origin, 40000, 8.0 );
	
	level.player playsound("whites_estate_house_exterior_explosion");
}

balcony_outside_explosion()
{
	balcony = getent("origin_explosion_balconyout", "targetname");
	
	physicsExplosionSphere(balcony.origin, 200, 100, 40 );

	wait(0.1);

	playfx (level._effect["house_explosion"], balcony.origin);
	
	earthquake (0.4, 1.8, level.player.origin, 50000, 8.0 );
	
	level.player playsound("whites_estate_house_exterior_explosion");
	
	flag_set("balcony_boom");
}

	
	
spawn_balcony_outside()
{
	spawner = getent("spawner_balcony_outside", "targetname");
	boom = getent("origin_balconyout_victim", "targetname");

	guard = spawner stalingradspawn("guard_balcony");
	guard setenablesense(false);

	flag_wait("balcony_boom");

	radiusdamage(boom.origin, 120, 200, 200 );
}





villa_blow_wall()
{
	wall = GetEnt( "blowoutwall1", "targetname" );

	
	

	

	

	
	
	
	wall delete();

	maps\_autosave::autosave_now("whites_estate");
}




villa_fish_tank_func()
{
	trigger = GetEnt( "fish_tank_spawn_trigger", "targetname" );
	trigger waittill ( "trigger" );

	

	
	level thread shootout_kitchen_01();
	level thread shootout_kitchen_02();

	thugs1 = getent ("fish_tank_thugs1", "targetname")  ;
	thugs1 stalingradspawn( "fish_thugs1" );
	
	thugs2 = getent ("fish_tank_thugs2", "targetname")  ;
	thugs2 stalingradspawn( "fish_thugs2" );

	fish1 = getent("fish_thugs1", "targetname");
	fish2 = getent("fish_thugs2", "targetname");

	fish1.accuracy = 0.6;
	fish1 setperfectsense(true);

	fish2.accuracy = 0.6;
	fish2 setperfectsense(true);
	
	wait(0.5);
	
	
	
	
	
}



fish_tank_break()
{
	physic_org = GetEnt( "fish_tank_push", "targetname" );
	trigger = GetEnt( "villa_fish_tank", "targetname" );
	trigger waittill ( "trigger" );

	physicsExplosionSphere( physic_org.origin, 200, 100, 5 );
}



front_gates()
{
	level waittill ( "open_z_gates" );
	front_gate_left = GetEnt( "front_gate_left", "targetname" );
	front_gate_right = GetEnt( "front_gate_right", "targetname" );
	front_gate_left rotateyaw( -90, 1 );
	front_gate_right rotateyaw( 90, 1 );
	wait( 2 );
	front_gate_left rotateyaw( 90, 1 );
	front_gate_right rotateyaw( -90, 1 );
}



fake_villa_first_wave()
{
	trigger = GetEnt( "trigger_fake_villa_wave_01", "targetname" );
	trigger waittill ( "trigger" );

	villa_thugs = getentarray ( "fake_villa_wave_01", "targetname" );

	for ( i = 0; i < villa_thugs.size; i++ )
	{
		thug[i] = villa_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] SetEnableSense( false );
		}
	}
}



villa_swap_cars_trigger_func()
{
	level waittill ( "white_blows_estate" );
	level notify ( "unhide_car_00" );
}



villa_first_wave()
{
	trigger = GetEnt( "trigger_villa_wave_01", "targetname" );
	trigger waittill ( "trigger" );
	
	
	
	
	
	

	
	
	level thread first_house_guards();
	level thread explosion_second_floor();
	level thread ceiling_tiles();
	
	flag_set("destroy_computer_room");
	
	level notify("ceiling_beams_start");
		
	earthquake (0.5, 0.6, level.player.origin, 700, 8.0 );
}



check_villa_death_01()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
	if (( level.thug_death_tracker >= 0 ) && ( level.second_wave > 0 ))  
	{
		level thread villa_lookat_trigger_door();
	}
}



villa_trigger_primer_func()
{
	trigger = GetEnt( "villa_wave_02_trigger_primer", "targetname" );
	trigger trigger_off();

	level waittill ( "white_blows_estate" );
	trigger trigger_on();

	trigger waittill ( "trigger" );

	level.second_wave++;
	
	level thread villa_lookat_trigger_door();
}



villa_lookat_trigger_door()
{
	trigger = GetEnt( "villa_wave_02_lookat_trigger", "targetname" );
	trigger waittill ( "trigger" );

	level notify ( "2nd_wave" );
}



villa_backup_trigger_door()
{
	trigger = GetEnt( "villa_wave_02_backup_trigger", "targetname" );
	trigger trigger_off();

	level waittill ( "white_blows_estate" );
	trigger trigger_on();

	trigger waittill ( "trigger" );

	level notify ( "2nd_wave" );
}



front_door_temp_open_func()
{
	trigger = GetEnt( "front_door_temp_open", "targetname" );
	trigger waittill ( "trigger" );
	
	
	
	
	
	
	
	
	wait(1.0);
	
	
	
	
	
	
	
	
	
	
	level notify("front_door_start");
	
	front_door = getent("collision_front_door", "targetname");
	front_door trigger_off();
	front_door connectpaths();
	
	door_breach = getent("origin_door_breach", "targetname");
	playfx (level._effect["conc_grenade"], door_breach.origin);
	
	door_breach playsound("whites_estate_house_car_explosion");
	
	earthquake (0.3, 0.5, level.player.origin, 700, 5.0 );
	
	level thread statue_fall_below();
	
	wait(1.0);
	
	level thread front_door_assault();
	
	door_breach delete();
}



villa_second_wave()
{
	level waittill ( "2nd_wave" );

	villa_thugs = getentarray ( "villa_wave_02", "targetname" );
	thugs = getentarray ( "villa_wave_02a", "targetname" );

	
	
	for (i=0; i<thugs.size; i++)
	{
		guard[i] = thugs[i] stalingradspawn("guard_rusher");
		guard[i] setperfectsense(true);
		guard[i] lockaispeed("walk");
	}
}



check_villa_death_02()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
	if ( level.thug_death_tracker >= 6 )
	{
		level notify ( "3rd_wave" );
	}
}



villa_third_wave()
{
	level waittill ( "3rd_wave" );
	level thread last_objective();

	villa_thugs = getentarray ( "villa_wave_03", "targetname" );

	for ( i = 0; i < villa_thugs.size; i++ )
	{
		thug[i] = villa_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] thread check_villa_death_03();
			thug[i].accuracy = .8;
		}
	}
}



check_villa_death_03()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
}



last_objective()
{
	while ( 1 )
	{
		wait( .5 );
		if ( level.thug_death_tracker >= 12 )
		{
			level notify ( "get_white" );
			break;
		}
	}
}



villa_car_1and2_drive_up()
{
	level waittill ( "safe_hacked" );

	

	
	vehicle1 = GetEnt( "car_01", "targetname" );
	car_path_01 = getvehiclenode("car_path_01", "targetname");
	vehicle1 attachpath( car_path_01 );
	vehicle1 startpath( car_path_01 );
	vehicle1 setspeed(35, 35, 35);

	
	vehicle2 = GetEnt( "car_02", "targetname" );
	car_path_02 = getvehiclenode("car_path_02", "targetname");
	vehicle2 attachpath( car_path_02 );
	vehicle2 startpath( car_path_02 );
	vehicle2 setspeed(35, 35, 35);

	
	vehicle3 = GetEnt( "car_03", "targetname" );
	car_path_03 = getvehiclenode("car_path_03", "targetname");
	vehicle3 attachpath( car_path_03 );
	vehicle3 startpath( car_path_03 );
	vehicle3 setspeed(35, 35, 35);

	
	vehicle = GetEnt( "car_04", "targetname" );
	car_path_04 = getvehiclenode("car_path_04", "targetname");
	vehicle attachpath( car_path_04 );
	vehicle startpath( car_path_04 );
	vehicle setspeed(35, 35, 35);
}



pip_trigger_00_func()
{
	
	
	

	

	
	
	
	
	
	
	
	

	
	
	
	
}



white_crawls_away()
{
	white = getent ("mr_white_gimp", "targetname")  stalingradspawn( "white" );
	white waittill( "finished spawning" );
	white LockAlertState( "alert_green" );
	white.DropWeapon = false;
	white gun_remove();
	white startpatrolroute( "white_goto" );
}



thug_delete_func()
{
	if ( IsDefined ( self ))
	{
		self delete();
	}
}



pip_trigger_01_func()
{
	trigger = GetEnt( "pip_trigger_01", "targetname" );
	trigger trigger_off();
	level waittill ( "safe_hacked" );
	trigger trigger_on();
	trigger waittill ( "trigger" );
	level.kill_pip++;
}




cellar_door_close_func()
{
	trigger = GetEnt( "cellar_door_close", "targetname" );
	guard_vo_var = GetEnt("sound_cellar_dialog", "targetname"); 
	
	trigger waittill ( "trigger" );
	
	flag_set("house_entered");
	
	
	
	
	
	maps\_autosave::autosave_now("whites_estate");
}



conservatory_trigger_fight()
{
	level waittill ( "fifth_explosion" );
	
	
	con_glass = GetEnt( "con_glass", "script_noteworthy" );
	

	
	level thread atrium_glass_break();

	hilo_guards = getentarray ( "hilo_guards", "targetname" );

	for ( i = 0; i < hilo_guards.size; i++ )
	{
		thug[i] = hilo_guards[i] stalingradspawn("atrium_guards");
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] SetCombatRole( "turret" );
		}
	}
	
	con_glass waittill ( "death" );
	level notify ( "board_break_start" );
	
	node = getnodearray("node_cover_exit", "targetname");
	guard = getentarray("atrium_guards", "targetname");
	
	wait(1.0);
	
	for ( i = 0; i < guard.size; i++ )
	{
		if(isdefined(guard[i]))
		{
			guard[i] setgoalnode(node[i], 1);
			wait(0.3);
		}
	}
}





conservatory_trigger_fail()
{
	trigger = GetEnt( "white_gets_away_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	
	wait( 1.5 );
	missionfailed();
}



conservatory_trigger_end_mr_white()
{
	trigger = GetEnt( "hilo_white_end", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set("helipad_located");

	last_thugs = GetEntArray( "hilo_white_guard", "targetname" );
	mr_white = GetEntArray( "hilo_mr_white", "targetname" );

	for ( i = 0; i < last_thugs.size; i++ )
	{
		thug[i] = last_thugs[i] StalingradSpawn();
		if ( !maps\_utility::spawn_failed( thug[i] ) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] setcombatrole ( "turret" );
			thug[i] thread hilo_thug_watch_white_stopped();
		}
	}

	for ( i = 0; i < mr_white.size; i++ )
	{
		white[i] = mr_white[i] StalingradSpawn("mrwhite");
		if ( !maps\_utility::spawn_failed( white[i] ) )
		{
			white[i].health = 10000;
			white[i] SetEnableSense( false );
			white[i] setpainenable( false );
			white[i] thread chopper_sit();
		}
	}
}


hilo_thug_watch_white_stopped()
{
	self endon( "death" );
	flag_wait("white_stopped");
	wait( 0.1 );
	self delete();
}



hilo_white_death()
{
	self waittill ( "death" );
	level.white_shot++;
	tutorial_message( "M: You killed Mr. White. Nice job Bond." );
	wait( 2 );
	tutorial_message( "" );
	missionfailed();
}



small_greenhouse_gauntlet()
{
	greenhouse_thugs_02 = getentarray ( "greenhouse_small_thugs_02", "targetname" );

	for ( i = 0; i < greenhouse_thugs_02.size; i++ )
	{
		dude[i] = greenhouse_thugs_02[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( dude[i]) )
		{
			dude[i] thread global_radio_chatter();
			dude[i] setalertstatemin( "alert_red" );
			dude[i] thread greenhouse_last_man_standing();
			dude[i] thread greenhouse_last_man_standing_think();
			dude[i] thread TetherMgr();
		}
	}
}





TetherMgr()
{
	self endon( "death" );

	level.tetherPt = GetEnt( "tether_point", "targetname" );

	if( isdefined( level.tetherPt ))
	{
		while( 1 )
		{	
			if( isdefined( self ))
			{
				self.tetherradius = Distance( level.tetherPt.origin, self.origin )+12*10;
				self.tetherpt	  = level.tetherPt.origin;

				self thread TetherWatcher( 12*6, 12*15, 12*35 );
			}
		}
	}	
}





TetherWatcher( tetherDelta0, tetherDelta1, minTether )
{
	self endon( "death" );

	tetherDelta = randomfloatrange(tetherDelta0, tetherDelta1);

	while( isdefined(level.tetherPt) )
	{						
		wait( randomfloat(2.0,4.0) );

		self.tetherpt	= level.tetherPt.origin;	

		newRad			= Distance(level.player.origin, level.tetherPt.origin) - tetherDelta;

		if( newRad < self.tetherradius )
		{	
			
			if( newRad < minTether )
			{
				self.tetherradius = minTether;
			}
			else
			{
				self.tetherradius = newRad;

				tetherDelta = randomfloatrange(tetherDelta0, tetherDelta1);
			}
		}
	}
}







house_setup()
{
	front_trigger = getent("front_door_temp_open", "targetname");
	front_trigger trigger_off();
	
	
	
	phys_triggers = getentarray("trigger_physics", "targetname");
	for (i=0; i<phys_triggers.size; i++)
	{
		phys_triggers[i] trigger_off();
	}

	
	coll_main_stairs = getent("collision_main_stairs", "targetname");
	coll_main_stairs trigger_off();
	

	railing1_after = getent("railing_f2_after", "targetname");
	railing1_after hide();
	
	railing2_after = getent("railing_f2_l_after", "targetname");
	railing2_after hide();

	piano_after = getent("piano_after", "targetname");
	piano_after hide();

	
	
	
	dock_trigger = getent("trigger_hurt_dock", "targetname");
	dock_trigger trigger_off();
	
	dockill_trigger = getent("trigger_kill_dock", "targetname");
	dockill_trigger trigger_off();
	
	
	
	house_fire = getentarray("triggerhurt_fire_house", "targetname");
	for (i=0; i<house_fire.size; i++)
	{
		house_fire[i] trigger_off();
	}
	
	house_firecoll = getentarray("collision_fire_house", "targetname");
	for (i=0; i<house_firecoll.size; i++)
	{
		house_firecoll[i] trigger_off();
	}
	
	fire_frontdoor = getentarray("triggerhurt_front_door", "targetname");
	for (i=0; i<fire_frontdoor.size; i++)
	{
		fire_frontdoor[i] trigger_off();
	}
	
	fire_door = getent("collision_fire_door", "targetname");
	fire_door trigger_off();
	
	

	coll_third_floor = getent("collision_third_floor", "targetname");
	coll_third_floor trigger_off();
	
	

	triggerhurt_server = getentarray("trigger_hurt_server", "targetname");
	for (i=0; i<triggerhurt_server.size; i++)
	{
		triggerhurt_server[i] trigger_off();
	}

	

	stairs_main = getent("stairs_main_after", "targetname");
	stairs_main hide();

	

	coll_small_greenhouse = getent("collision_small_greenhouse", "targetname");
	coll_small_greenhouse trigger_off();

	
	
	
	

	
	
	
	

	
	
	
		
	
	
	
	
	
	


	floor_preatrium_after = getent("floor_preatrium_after", "targetname");
	floor_preatrium_after hide();

	planter_after = getentarray("planter_after", "targetname");
	for (i=0; i<planter_after.size; i++)
	{
		planter_after[i] hide();
	}
	
	
	
	heli1 = getent("heli_house", "targetname");
	heli2 = getent("heli_greenhouse", "targetname");
	
	heli1 hide();
	heli1 trigger_off();
	heli2 hide();
	heli2 trigger_off();
	
	
	
	
	coll_winegone_01 = getentarray("coll_winegone_01", "targetname");
	for (i=0; i<coll_winegone_01.size; i++)
	{
		coll_winegone_01[i] trigger_off();
	}
	
	coll_winegone_02 = getentarray("coll_winegone_02", "targetname");
	for (i=0; i<coll_winegone_02.size; i++)
	{
		coll_winegone_02[i] trigger_off();
	}
	
	coll_winegone_03 = getentarray("coll_winegone_03", "targetname");
	for (i=0; i<coll_winegone_03.size; i++)
	{
		coll_winegone_03[i] trigger_off();
	}
	
	coll_winegone_04 = getentarray("coll_winegone_04", "targetname");
	for (i=0; i<coll_winegone_04.size; i++)
	{
		coll_winegone_04[i] trigger_off();
	}

	boathouse_door = getent("collision_boathouse_door", "targetname");
	boathouse_door trigger_on();

	room = getent("room_destroyed_01", "targetname");
	room hide();
	room trigger_off();
	
	room2 = getent("room_destroyed_02", "targetname");
	room2 hide();
	room2 trigger_off();
	
	beam_after = getent("blowupbeam_01_after", "targetname");
	beam_after trigger_off();
	beam_after hide();
	
	
	
	
	
	level.floor_mezz_collapsed = false;
	
	fire_clip = GetEnt( "fire_block_temp", "targetname" );
	fire_clip trigger_off();
	fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
	fire_clip2 trigger_off();
	fire_clip2 connectPaths();
	
	floor_bad = getent("blowupfloor_f2_after", "targetname");
	floor_bad hide();
}


safe_room_destroy()
{
	room = getent("room_destroyed_01", "targetname");
	room show();
	room trigger_on();
	
	room_good = getent("room_good_01", "targetname");
	room_good delete();
}









setup_bond()
{
	holster_weapons();
	
	level thread camera_intro();
	
	wait(0.05);
	
	
	
	
	
	level thread spawn_intro_guard01();
	
	level thread spawn_intro_guard03();
	level thread spawn_intro_guard04();
	
	guy = getent("thug_stairs", "targetname");
	node = getnode("node_anim_start", "targetname");
	end = getnode("node_anim_stop", "targetname");
	combat = getnode("node_garden_alert04", "targetname");
	
	guy setenablesense(false);
	guy setgoalnode(node, 0);
	
	guy waittill("goal");
	
	playcutscene("WE_END", "Intro_Done");
	
	level waittill("Intro_Done");
	
	guy setgoalnode(end, 0);
	
	guy setenablesense(true);
	
	flag_wait("garden_alert");
	
	guy setgoalnode(combat, 1);
}






camera_intro()
{
	if(Getdvar( "skipto" ) != "" )
	{
		return;
	}
	
	cameraID_01 = level.player customCamera_Push( "world", (-1627.18, 1019.62, 6.19), (-11.47, -40.89, 0));
	
	wait(0.05);
	
	level thread letterbox_on(false, false, undefined, true);
	
	level thread chopper_effects();
	
	wait(5.0);
	
	level.player customCamera_change( cameraID_01, "world", (-1619.49, 1016.22, -4.0), (3.24, -157.97, 0), 7.0, 0.5, 1.0);
	
	wait(9.0);
	
	level thread close_gates();
	level thread alert_garden();
	level thread vo_garden_start();
	
	level.player customCamera_pop( cameraID_01, 2.0 );
	
	letterbox_off(false);
	
	unholster_weapons();
	
	wait(1.0);
}






chopper_effects()
{
	tag = getent("tag_heli_efx", "targetname");
	heli = getent("heli_garden", "targetname");
	
	tag linkto(heli, "tag_turret");
	
	playfxontag( level._effect[ "copter_dust" ], tag, "tag_origin" );
	
	wait(10.0);
	
	tag delete();
}






vo_garden_start()
{
	level.player play_dialogue("BOND_GlobG_123A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_701A", true);  
}






vo_garden_lock()
{
	level.player play_dialogue("TANN_WHITG_702A", true);  
}






vo_boathouse_feedbox()
{
	level.player play_dialogue("TANN_WHITG_703A", true);  
	
	flag_wait("feed_tapped");
	
	wait(1.0);
	
	level.player play_dialogue("BOND_AirpG_006A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_704A", true);  
	
	wait(0.5);
	
	level.player play_dialogue("BOND_GlobG_105A", false);  
}






vo_small_greenhouse()
{
	level.player play_dialogue("TANN_WHITG_705A", true);  
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_529A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_530A", true);  
}






vo_large_greenhouse()
{
	trigger = getent("trigger_greenhouse_done", "targetname");
	trigger waittill("trigger");
	
	level.player play_dialogue("BOND_WHITG_531A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_706A", true);  
	
	level thread vo_cellar_entered();
}






vo_cellar_entered()
{
	trigger = getent("trigger_vo_cellar", "targetname");
	trigger waittill("trigger");
	
	
		
	level.player play_dialogue("BOND_WHITG_539A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_707A", true);  
	
	wait(0.5);
	
	level.vo_cellar_done = true;
}






vo_cellar_intro()
{
	guard = getentarray("guard_cellar_01", "targetname");
	thug = getent("guard_cellar_02", "targetname");
	
	proceed = false;
	
	while(!proceed)
	{
		if (level.vo_cellar_done)
		{
			proceed = true;
		}
		wait(0.1);
	}
	
	if (isdefined(guard[0]))
	{
		guard[0] play_dialogue("CLM1_WHITG_534A", false);  
	}
	else if (isdefined(guard[1]))
	{
		guard[1] play_dialogue("CLM1_WHITG_534A", false);  
	}
	
	wait(0.5);
	
	if (isdefined(guard[1]))
	{
		guard[1] play_dialogue("CLM2_WHITG_535A", false);  
	}
	else if (isdefined(guard[0]))
	{
		guard[0] play_dialogue("CLM2_WHITG_535A", false);  
	}
	
	wait(0.5);
	
	if (isdefined(thug))
	{
		thug play_dialogue("CLM3_WHITG_536A", false);  
	}
	
	wait(0.5);
	
	contacted = false;
	
	while(!contacted)
	{
		if (level.cellar_alerted)
		{
			contacted = true;
		}
		wait(0.1);
	}
		
	if (isdefined(thug))
	{
		thug play_dialogue("CLM2_WHITG_537A", false);  
	}
	else if (isdefined(guard[0]))
	{
		guard[0] play_dialogue("CLM2_WHITG_537A", false);  
	}
	else if (isdefined(guard[1]))
	{
		guard[1] play_dialogue("CLM2_WHITG_537A", false);  
	}
}






vo_safe_hint()
{
	level.player play_dialogue("TANN_WHITG_541A", true);  
	
	wait(20.0);
	
	if (!level.safe_room_found)
	{
		level.player play_dialogue("TANN_WHITG_708A", true);  
	}
}






vo_safe_room()
{
	level.player play_dialogue("BOND_WHITG_543A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_544A", true);  
	
	wait(0.5);
	
	flag_wait("safe_hacked");
	
	level.player play_dialogue("BOND_WHITG_545A", false);  
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_546A", true);  
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_547A", false);  
}


vo_computer_room()
{	
	level.player play_dialogue("BOND_WHITG_549A", false);  
	
	wait(0.5);
	
	
	
	flag_set("vo_computer_done");
	
	flag_wait("explosion_done");
	
	level.player play_dialogue("TANN_WHITG_551A", true);  
	
	level thread explode_server_room();
}






vo_white_helicopter()
{
	trigger = getent("trigger_white_heli", "targetname");
	trigger waittill("trigger");
	
	level notify ( "start_the_coppter" );
	
	wait(1.0);
	
	level.player play_dialogue("TANN_WHITG_552A", true);  
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_553A", false);  
	
	alldead = false;
	
	while(!alldead)
	{
		guard = getentarray("atrium_guards", "targetname");
		
		if (!guard.size)
		{
			alldead = true;
		}
		
		wait(0.1);
	}
	
	wait(1.5);
	
	level.player play_dialogue("TANN_WHITG_601A", true);  
}






vo_white_end()
{
	white = getent("mrwhite", "targetname");
	
	white play_dialogue("WHIT_WHITG_024A", true);  
	
	wait(0.5);
	
	white play_dialogue("WHIT_WHITG_025A", true);  
	
	wait(0.5);
	
	white play_dialogue("WHIT_WHITG_026A", true);  
}






check_garden()
{
	alldead = false;
	
	while(!(alldead))
	{
		guards = getaiarray("axis");

		if (!(guards.size))
		{
			alldead = true;
			wait(2.0);
			level thread vo_garden_lock();
		}
		
		wait(0.1);
	}
}






alert_garden()
{
	trigger = getent("trigger_first_guard", "targetname");
	trigger waittill("trigger");

	flag_set("garden_alert");	
}






spawn_intro_guard01()
{
	spawner = getent("spawner_intro_01", "targetname");
	slide = getnode("node_slide", "targetname");
	call = getnode("node_callout", "targetname");
	end = getnode("node_over_rail", "targetname");
	combat = getnode("node_garden_alert01", "targetname");
	
	guard01 = spawner stalingradspawn("guard01");
	
	guard01 setenablesense(false);
	guard01.accuracy = 0.3;
	
	guard01 setgoalnode(slide, 0);
	
	guard01 waittill("goal");
	
	guard01 cmdplayanim("thu_cvrmidtns_stnd_slide2ready_pistol");
	
	wait(2.0);
	
	guard01 cmdaction("callout");
	
	wait(2.0);
	
	guard01 stopallcmds();
	
	guard01 setgoalnode(end, 0);
	
	flag_set("gogogo");
	
	guard01 waittill("goal");
	
	guard01 setenablesense(true);
	
	flag_wait("garden_alert");
	
	guard01 setgoalnode(combat, 1);
}


spawn_intro_guard02()
{
	spawner = getent("spawner_intro_02", "targetname");
	node = getnode("node_intro_01", "targetname");
	rundown = getnode("node_rundown", "targetname");
	aim = getent("cover_marker_01", "targetname");
	leader = getent("guard01", "targetname");
	
	guard = spawner stalingradspawn("guard02");
	
	guard setenablesense(false);
	guard.accuracy = 0.3;
	
	guard setgoalnode(node, 0);
	
	guard waittill("goal");
	
	guard cmdglanceatentity(leader, 1.0);
	
	wait(1.0);
	
	guard cmdaimatentity(aim);
	
	flag_wait("gogogo");
	
	guard stopallcmds();
	
	wait(1.5);
	
	guard setgoalnode(rundown, 0);
	
	guard waittill("goal");
	
	flag_set("rundown_reached");
	
	guard setenablesense(true);
}


spawn_intro_guard03()
{
	spawner = getent("spawner_intro_03", "targetname");
	node = getnode("node_intro_last01", "targetname");
	combat = getnode("node_garden_alert02", "targetname");
		
	guard = spawner stalingradspawn("guard03");
	guard.accuracy = 0.3;
	guard setenablesense(false);	
	guard setgoalnode(node, 0);
	guard waittill("goal");
	guard setenablesense(true);
	
	flag_wait("garden_alert");
	
	guard setgoalnode(combat, 1);
}


spawn_intro_guard04()
{
	spawner = getent("spawner_intro_04", "targetname");
	node = getnode("node_intro_last02", "targetname");
	combat = getnode("node_garden_alert03", "targetname");
		
	guard = spawner stalingradspawn("guard04");
	guard.accuracy = 0.3;
	guard setenablesense(false);	
	guard setgoalnode(node, 0);
	guard waittill("goal");
	guard setenablesense(true);
	
	flag_wait("garden_alert");
	
	guard setgoalnode(combat, 1);
}






close_gates()
{
	gate01 = getentarray("gate_one", "targetname");
	gate02 = getentarray("gate_two", "targetname");
	
	for (i=0; i<gate01.size; i++)
	{
		gate01[i] rotateyaw(-90, 0.5);

		new_origin = gate01[i].origin + (-15, -22, 0);
		gate01[i] moveto(new_origin, 0.5);
	}
	
	for (i=0; i<gate02.size; i++)
	{
		gate02[i] rotateyaw(90, 0.5);
		
		new_origin = gate02[i].origin + (-15, 22, 0);
		gate02[i] moveto(new_origin, 0.5);
	}
}





hint_leave_cover()
{
	wait(12.0);
	
	proceed = false;
	
	while(!proceed)
	{
		if (!level.displaying_hint)
		{
			proceed = true;
		}
		wait(0.05);
	}
	
	if (level.player isincover())
	{
		level.displaying_hint = true;
		
		
		
		wait(1.0);
		
		tutorial_message( "WHITES_ESTATE_WII_TUTORIAL_LEAVE_COVER" );
	
		wait(4.0);
		
		tutorial_message( "" );
		
		level.displaying_hint = false;
	}
}





spawn_first_guard()
{
	trigger = getent("trigger_first_guard", "targetname");
	trigger waittill("trigger");
	
	spawner = getent("spawner_first_guard", "targetname");
	
	guard = spawner stalingradspawn("first_guard");
	guard.accuracy = 0.3;
	
	level thread spawn_second_guard();
	level thread spawn_third_guard();
	level thread spawn_gate_guards();
}




tutorial_giveortake_allweapons()
{
	trigger = getent("trigger_takeall_weapons", "targetname");
	trigger waittill("trigger");
	
	weapList = level.player GetWeaponsList();
	level.player takeallweapons();

	trigger = getent("trigger_giveback_weapons", "targetname");
	trigger waittill("trigger");

	for (i=0; i<weapList.size; i++)
		level.player GiveWeapon( weapList[i] );
		
	level.player switchToWeapon( weapList[0] );
}

tutorial_missionfailed()
{
	missionfailed = false;
	while(!missionfailed)
	{
		if (self isengaged())
		{
			missionfailed = true;
			
			wait(1);
			if (isdefined(self))
				missionfailed();
		}

		wait(0.1);
	}
}

tutorial_endl()
{
	wait(5.0);
	tutorial_message("");
	wait(0.5);
}

tutorial_boathouse_intern()
{
	level thread tutorial_giveortake_allweapons();

	trigger = getent("trigger_takeall_weapons", "targetname");
	trigger waittill("trigger");

	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_SENSITIVITY");
	tutorial_endl();
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_MAP");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_MAP_ZAPPER");
	}
	tutorial_endl();

	open_boathouse_doors();
	
	trigger = getent("trigger_takedown", "targetname");
	trigger waittill("trigger");
	trigger delete();
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_TAKEDOWN");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_TAKEDOWN_ZAPPER");
	}
	tutorial_endl();
}

tutorial_gardens()
{
	level waittill("Intro_Done");
	
	wait(2);
	level.player freezecontrols(false);
	
	tutorial_survey_move();
	tutorial_fire_ads();
	tutorial_weapon_change();
	tutorial_cover_blindf_ads_leave_reload();
}

tutorial_weapon_change()
{
	update_dvar_scheme();

	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_CHANGE_WEAPON_SHORT");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_CHANGE_WEAPON_SHORT_ZAPPER");
	}
	
	tutorial_endl();
}

wiiTutorial()
{
	level thread tutorial_gardens();
	level thread tutorial_boathouse_intern();
	level thread tutorial_second_greenhouse();
}

tutorial_second_greenhouse()
{
	trigger = getent("trigger_tuto_reminders", "targetname");
	trigger waittill("trigger");
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_REMINDER_1");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_REMINDER_1_ZAPPER");
	}
	tutorial_endl();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_REMINDER_2");
	tutorial_endl();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_SWITCH_TARGET");
	tutorial_endl();
}

tutorial_survey_move()
{
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_SURVEY");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_SURVEY_ZAPPER");
	}
	tutorial_endl();
}

tutorial_fire_ads()
{
	trigger = getent("trigger_tuto_fire_ads", "targetname");
	trigger waittill("trigger");
	trigger delete();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_FIRE");
	tutorial_endl();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_ADS");
	tutorial_endl();
}

tutorial_cover_blindf_ads_leave_reload()
{
	trigger = getent("trigger_tuto_cover_blindf_ads_leave", "targetname");
	trigger waittill("trigger");
	trigger delete();
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_COVER");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_COVER_ZAPPER");
	}
	tutorial_endl();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_BLINDFIRE");
	tutorial_endl();

	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_COVER_ADS");
	tutorial_endl();
	
	tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_COVER_LEAVE");
	tutorial_endl();
	
	
	alldead = false;
	while(!(alldead))
	{
		guards = getaiarray("axis");

		if (!(guards.size))
		{
			alldead = true;
		}
		
		wait(0.1);
	}
	
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_FINAL_RELOAD");
	}
	else
	{
		tutorial_message( "WHITES_ESTATE_WII_TUTORIAL_FINAL_RELOAD_ZAPPER" );
	}
	
	tutorial_endl();
}

reached_top_stairs()
{
	if (isdefined(self))
	{
		self setscriptspeed("default");
	}
}

enable_sense()
{
	if (isdefined(self))
	{
		self setenablesense(true);
	}
}






spawn_second_guard()
{
	spawner = getent("spawner_second_guard", "targetname");
	node = getnode("node_second_guard", "targetname");
	
	spawner stalingradspawn("second_guard");
	
	first_guard = getent("first_guard", "targetname");
	second_guard = getent("second_guard", "targetname");
	
	second_guard.accuracy = 0.3;
	
	alert = false;
	
	while(!alert)
	{
		if (isdefined(first_guard))
		{
			if (first_guard getalertstate() == "alert_red")
			{
				alert = true;
			}
		}
		else
		{
			alert = true;
		}
		
		first_guard = getent("first_guard", "targetname");
		
		wait(0.1);
	}
	
	level notify("alert");
	
	if (isdefined(second_guard))
	{	
		second_guard lockalertstate("alert_red");
		second_guard setgoalnode(node, 1);
		second_guard setperfectsense(true);
	}
}






spawn_third_guard()
{	
	guard = getentarray("spawner_third_guard", "targetname");
	
	for (i=0; i<guard.size; i++)
	{
		guard[i] = guard[i] stalingradspawn("third_guard");
		guard[i].accuracy = 0.3;
	}
	
	garden_guard = getentarray("third_guard", "targetname");
	
	level waittill("alert");
	
	for (i=0; i<garden_guard.size; i++)
	{
		if (isdefined(garden_guard[i]))
		{
			garden_guard[i] lockalertstate("alert_red");
			garden_guard[i] setperfectsense(true);
			garden_guard[i] setcombatrolelocked(false);
			garden_guard[i] setcombatrole("rusher");
		}
	}

	wait(4.0);
	
	for (i=0; i<garden_guard.size; i++)
	{
		if (isdefined(guard[i]))
		{
			garden_guard[i] setcombatrole("basic");
			garden_guard[i] setcombatrolelocked(true);
		}
	}
	
	thugs = getentarray("third_guard", "targetname");
	
	while(thugs.size > 1)
	{
		wait(0.5);
		thugs = getentarray("third_guard", "targetname");
	}
	
	thug = getent("third_guard", "targetname");
	
	if (isdefined(thug))
	{
		node = getnode("node_cover_back", "targetname");
		thug setgoalnode(node, 1);
	}
}






spawn_gate_guards()
{
	trigger = getent("trigger_spawn_gateguards", "targetname");
	trigger waittill("trigger");
	
	level.reached_garden = true;
	
	guard = getentarray("garden_thugs", "targetname");
	node = getnodearray("node_cover_garden", "targetname");
	
	level thread open_gate();
	level thread boat_arrive();
	
	for (i=0; i<guard.size; i++)
	{
		guard[i] = guard[i] stalingradspawn("garden_guards");
		guard[i] setgoalnode(node[i], 1);
		guard[i].accuracy = 0.3;
	}
	
	level thread check_garden();
}






open_gate()
{
	door_node = Getnode( "boathouse_gate", "targetname" );
	door_node maps\_doors::open_door_from_door_node();

	wait(3.0);
	
	door_node maps\_doors::close_door_from_door_node();
}






spawn_heli_garden()
{	
	
	
	
	heli = getent("heli_garden", "targetname");
	
	spawnpt = getent("origin_heli_spawn", "targetname");
	flypt01 = getent("origin_heli_pt01", "targetname");
	flypt02 = getent("origin_heli_pt02", "targetname");
	flypt03 = getent("origin_heli_pt03", "targetname");
	flypt04 = getent("origin_heli_pt04", "targetname");
	flypt05 = getent("origin_heli_pt05", "targetname");
		
	
	
	heli playloopsound("police_helicopter");
		
	heli setspeed(50, 40);
	heli setvehgoalpos ((spawnpt.origin), 0);
	heli waittill ( "goal" );
	
	heli setvehgoalpos ((flypt02.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt03.origin), 1);
	heli waittill ( "goal" );
	heli setspeed(40, 10);
	heli setvehgoalpos ((flypt04.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt05.origin), 0);
	heli waittill ( "goal" );
	
	heli stoploopsound();
	
	if (isdefined(heli))
	{
		heli delete();
	}
}






spawn_boat_guard01()
{
	spawner = getent("spawner_boat_guard01", "targetname");
	
	guard = spawner stalingradspawn("boat_guard01");
	
	guard teleport(self.origin, self.angles);;
	guard LinkTo( self, "tag_driver", (-44, 30, 0), (0, 90, 0) );
	
	guard setperfectsense(true);
	guard setpainenable( false );
	guard allowedstances( "crouch" );
	
	wait(5.0);
	
	if (isdefined(guard))
	{
		guard delete();
	}
}


spawn_boat_guard02()
{
	spawner = getent("spawner_boat_guard02", "targetname");
	
	guard = spawner stalingradspawn("boat_guard02");
	
	guard teleport(self.origin, self.angles);;
	guard LinkTo( self, "tag_driver", (-44, 30, 0), (0, 90, 0) );
	
	guard setperfectsense(true);
	guard setpainenable( false );
	guard allowedstances( "crouch" );
	
	wait(8.0);
	
	if (isdefined(guard))
	{
		guard delete();
	}
}






boat_arrive()
{
	boat_01 = getent( "fxanim_boat_arrival", "targetname" );
	
	
	trigger = getent("trigger_boats", "targetname");
	trigger waittill("trigger");
	
	boat_01 thread boat_01_anim_play();
	
	
	SetDVar("sm_SunSampleSizeNear", 0.25);
}






spawn_boathouse_quickkill()
{
	trigger = getent("trigger_boathouse_quickkill", "targetname");
	trigger waittill("trigger");

	thread boathouse_spawn_thug_01();
	thread guard_turn();
	
	spawner = getent("spawner_boathouse_quickkill", "targetname");
	guard  = spawner stalingradspawn("guard_boathouse");	
	
	guard lockaispeed("walk");
	guard setperfectsense(true);
	guard setcombatrolelocked(false);
	guard setcombatrole("rusher");
}

guard_quickkill()
{
	node = getnode("node_quickkill", "targetname");
	guard = getent("guard_boathouse", "targetname");
	
	
	
	if (isdefined(guard))
	{
		guard setscriptspeed("walk");
		guard setgoalnode(node, 0);
	}
	
	if (isdefined(guard))
	{
		guard waittill("goal");
		if (isdefined(guard))
		{
			guard setscriptspeed("run");
		}
	}
}

guard_turn()
{
	trigger = getent("trigger_tip_quickkill", "targetname");
	trigger waittill("trigger");
	
	thread guard_quickkill();
}






boathouse_spawn_thug_01()
{
	trigger = getent( "boathouse_dock_fight_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread hint_mousetrap();
	
	boathouse_thugs = getentarray ( "boathouse_thug_00", "targetname" );
	jumper = getent("boathouse_thug_jump", "targetname");
	node_dock = getnodearray("node_cover_dock", "targetname");
	node_jump = getnode("node_jump_dock", "targetname");
	node_cover = getnode("node_cover_jump", "targetname");
	
	jumper stalingradspawn("guard");
	jump = getent("guard", "targetname");
	
	
	jump.accuracy = 0.6;
	jump setperfectsense(true);
	jump setcombatrolelocked(false);
	jump setcombatrole("turret");
	jump setcombatrolelocked(true);
	
	for ( i = 0; i < boathouse_thugs.size; i++ )
	{
		thug[i] = boathouse_thugs[i] stalingradspawn("dock_guard");
		
		if (isdefined(thug[i]))
		{
			thug[i].accuracy = 0.5;
			thug[i] setperfectsense(true);
			thug[i] setgoalnode(node_dock[i], 0);
			thug[i] setcombatrolelocked(false);
			thug[i] setcombatrole("turret");
			thug[i] setcombatrolelocked(true);
		}
	}
	
	level thread check_dock();
	level thread spawn_lure();
	level thread spawn_boathouse_backexit();
	level thread tip_sprint();
	level thread propane_explosion_01();
	level thread propane_explosion_02();
	
	
	
	
	jump setgoalnode(node_cover, 0);
}


hint_mousetrap()
{
	proceed = false;
	
	while(!proceed)
	{
		if (!level.displaying_hint)
		{
			proceed = true;
		}
		wait(0.05);
	}
	
	level.displaying_hint = true;

	
	tutorial_message( "WHITES_ESTATE_WII_TUTORIAL_FINAL_EXPLOSIVES" );
	tutorial_endl();
	
	level.displaying_hint = false;
}






propane_explosion_01()
{
	trigger = getent( "trigger_dock_explosion01", "targetname" );
	trigger waittill ( "trigger" );

	explosion = getentarray("origin_dock_explosion01", "targetname");
	
	for (i=0; i<explosion.size; i++)
	{
		physicsExplosionSphere( explosion[i].origin, 200, 150, 25 );
	}
	
	level thread set_dock_fire();
	
	wait(0.5);
	
	for (i=0; i<explosion.size; i++)
	{
		explosion[i] delete();
	}
	
	
	dock_trigger = getent("trigger_hurt_dock", "targetname");
	dock_trigger trigger_on();
	
	dockill_trigger = getent("trigger_kill_dock", "targetname");
	dockill_trigger trigger_on();
}


propane_explosion_02()
{
	trigger = getent( "trigger_dock_explosion02", "targetname" );
	trigger waittill ( "trigger" );
	
	explosion = getentarray("origin_dock_explosion02", "targetname");
	
	for (i=0; i<explosion.size; i++)
	{
		physicsExplosionSphere( explosion[i].origin, 200, 150, 25 );
	}
	
	collision = getent("collision_dock_mantle", "targetname");
	
	collision delete();
	
	wait(0.5);
	
	for (i=0; i<explosion.size; i++)
	{
		explosion[i] delete();
	}
}






set_dock_fire()
{
	dockfire = getentarray("origin_fire_dock", "targetname");
	
	for (i=0; i<dockfire.size; i++)
	{
		dockfire[i] = spawnfx(level._effect["med_fire"], dockfire[i].origin);
		triggerFX(dockfire[i]);
	}
	
	
	
	
	
	dockfire[0] playloopsound("whites_estate_fire_loop");
}






check_dock()
{
	guard = getentarray("dock_guard", "targetname");
		
	while(guard.size > 0)
	{
		guard = getentarray("dock_guard", "targetname");
		wait(0.1);
	}
	
		
	level notify("endmusicpackage");

	wait(1.5);
	
	level thread lookat_boathouse_door();
	level thread countdown_boathouse_door();
	level thread emergency_open();
}


lookat_boathouse_door()
{
	trigger = getent("trigger_lookat_boathouse", "targetname");
	trigger waittill("trigger");
	
	if (!level.door_kicked_open)
	{
		level thread spawn_boathouse_doorguy();
		level.door_kicked_open = true;
	}
}


countdown_boathouse_door()
{
	wait(4.0);
	
	if (!level.door_kicked_open)
	{
		level thread spawn_boathouse_doorguy();
		level.door_kicked_open = true;
	}

		
	level notify("playmusicpackage_boathouse");
}


emergency_open()
{
	wait(7.0);
	
	if (!level.door_kicked_open)
	{
		level thread kick_open_door();
		level.door_kicked_open = true;
	}
}

	
	



spawn_boathouse_doorguy()
{
	node = getnode("node_boathouse_door", "targetname");
	shoot_node = getnode("node_boathouse_shoot", "targetname");
	node_stairs = getnode("node_boathouse_stairs", "targetname");
	spawner = getent("boathouse_thug_01", "targetname");
	
	thug = spawner stalingradspawn("door_guard");
	thug setenablesense(false);
	thug setpainenable( false );
	
	thug play_dialogue("SAM_E_1_Last_Cmb", false);
	
	thug setgoalnode(node_stairs, 0);
	
	thug waittill("goal");
		
	thug setgoalnode(node, 0);
	
	thug waittill("goal");
	
	thug cmdfaceangles(90, false, 0.5);
	
	level thread kick_open_door();
	
	thug setenablesense(true);
	thug setpainenable( true );
	thug lockaispeed("walk");
	thug setperfectsense(true);
	thug setcombatrolelocked(false);
	thug setcombatrole("rusher");
	
	thug cmdplayanim("Thug_Alrt_FrontKick", false);
	
	dead = false;
	
	while(!dead)
	{
		if (!isdefined(thug))
		{
			dead = true;
			wait(1.0);
			
		}
	
		wait(0.1);
	}	
}
	
	
kick_open_door()
{
	sound_boathouse_door = GetEnt( "origin_sound_boathouse", "targetname" );
	
	wait(1.5);
	
	level notify ( "we_door_kick_start" );
	
	level thread door_knockback_boathouse();
	
	sound_boathouse_door playsound("whites_estate_boathouse_door");
	
	boathouse_door = getent("collision_boathouse_door", "targetname");
	boathouse_door trigger_off();
}





door_knockback_boathouse()
{
	trigger = getent( "trigger_boathouse_knockback", "targetname" );
	
	if (level.player istouching(trigger))
	{
		level.player shellshock("default", 3.0);
		level.player knockback(4000, (-4277, 1554, -433));
		level.player playersetforcecover( false );
	}
}






open_boathouse_doors()
{
	door_a1 = getent("boathouse_door_a1", "targetname");
	door_a2 = getent("boathouse_door_a2", "targetname");
	
	door_a1 rotateyaw(90, 2.5);
	door_a2 rotateyaw(-90, 2.5);
	door_a1 playsound("whites_estate_boathouse_door_slow");
	
	level notify("backexit_guard_enablesense");
}





spawn_lure()
{
	trigger = getent( "greenhouse_thug_walk", "targetname" );
	trigger waittill ( "trigger" );
	
	if (!(level.greenhouse_lure))
	{
		node = getnode("node_greenhouse", "targetname");
		spawner = getent("greenhouse_small_thugs", "targetname");
		spawner stalingradspawn("lure");
		guard =getent("lure", "targetname");
		level.greenhouse_lure = true;
		guard setgoalnode(node, 1);

		if (isdefined(guard))
		{
			guard play_dialogue("SGM_WHITG_527A", false);  

			
			level notify("playmusicpackage_greenhouse");
		}
	}
}


				
ach_headshot()
								{
	eAttacker = undefined;
	while (!IsPlayer(eAttacker))
				{
		self waittill("damage", iDamage, eAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName);
		if (IsPlayer(eAttacker) && !IsAlive(self))
								{
			
												 GiveAchievement("Challenge_WhitesEstate");
								}
	}
}
	

spawn_boathouse_backexit()
{
	trigger = getent("boathouse_dock_fight_trigger", "targetname");
	trigger waittill("trigger");
	
	spawner = getent("spawner_boathouse_backexit", "targetname");
	guard = spawner stalingradspawn();
	guard SetEnableSense(false);
		
	level waittill("backexit_guard_enablesense");
	guard SetEnableSense(true);
	guard.dropweapon = false;
	guard SetCombatRole("Guardian");
	guard setengagerule("TgtSight");
	guard tutorial_missionfailed();

	
	level notify("playmusicpackage_greenhouse");
}





tip_sprint()
{
	trigger = getent("trigger_tip_sprint", "targetname");
	trigger waittill ( "trigger" );
	
	level thread shoot_down_lights();
	level thread reset_greenhouse_ambush();
	level thread greenhouse_ambush_done();
	level thread spawn_heli_gunner();
	
	proceed = false;

	while(!proceed)
	{
		if (!level.displaying_hint)
{
			proceed = true;
		}
		wait(0.05);
	}
	
	level.displaying_hint = true;
	
	update_dvar_scheme();
	if( getdvar( "flash_control_scheme" ) == "0" )
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_SPRINT");
	}
	else
	{
		tutorial_message("WHITES_ESTATE_WII_TUTORIAL_SPRINT_ZAPPER");
	}
	
	wait(5.0);
	tutorial_message( "" );
	
	level.displaying_hint = false;
}






shoot_down_lights()
{
	trigger = getent("trigger_greenhouse_lights", "targetname");
	trigger waittill("trigger");
	
	level thread basket_push_func();
	level thread small_greenhouse_glass();
	level thread spawn_ambush_guards();
	level thread spawn_heli_greenhouse();
	
	origin = getentarray("origin_greenhouse_light", "targetname");
	
	for (i=0; i<origin.size; i++)
	{
		radiusdamage (origin[i].origin, 60, 100, 100 );
		wait(0.5);
	}
	
	glass = getentarray("origin_greenhouse_backtop", "targetname");
	
	for (i=0; i<glass.size; i++)
	{
		radiusdamage (glass[i].origin, 50, 200, 200 );
		wait(0.1);
	}
	
	wait(0.5);
	
	for (i=0; i<origin.size; i++)
	{
		origin[i] delete();
	}
	
	for (i=0; i<glass.size; i++)
	{
		glass[i] delete();
	}
}






small_greenhouse_glass()
{
	origin = getentarray("origin_greenhouse_roof", "targetname");
	
	for (i=0; i<origin.size; i++)
	{
		radiusdamage (origin[i].origin, 30, 200, 200 );
		
		wait(0.05);
	}
}






greenhouse_ambush_01()
{
	source = getent("origin_greenhouse_fire01", "targetname");
	dest = getentarray("origin_greenhouse_target", "targetname");
	
	trigger = getent("trigger_greenhouse_ambush", "targetname");
	trigger waittill("trigger");
	
	level thread greenhouse_ambush_02();
	level thread greenhouse_ambush_03();
	level thread greenhouse_ambush_04();
	thread reset_greenhouse_ambush();
	
	for (k=0; k<3; k++)
	{
		rand = randomintrange(6, 12);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			if (!level.greenhouse_thru)
			{
			if (isdefined(dest[randt]))
			{
				magicbullet("SAF45_white", source.origin, (dest[randt].origin + (randx, randy, randz)));
					wait(0.1);
				}
			}
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}

greenhouse_ambush_02()
{
	source = getent("origin_greenhouse_fire02", "targetname");
	dest = getentarray("origin_greenhouse_target", "targetname");
	
	for (k=0; k<3; k++)
	{
		rand = randomintrange(8,20);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			if (!level.greenhouse_thru)
			{
			if (isdefined(dest[randt]))
			{
				magicbullet("SAF45_white", source.origin, (dest[randt].origin + (randx, randy, randz)));
					wait(0.1);
				}
			}
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}

greenhouse_ambush_03()
{
	source = getent("origin_greenhouse_fire03", "targetname");
	dest = getentarray("origin_greenhouse_target", "targetname");
	
	for (k=0; k<3; k++)
	{
		rand = randomintrange(7, 14);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			if (!level.greenhouse_thru)
			{
			if (isdefined(dest[randt]))
			{
				magicbullet("SAF45_white", source.origin, (dest[randt].origin + (randx, randy, randz)));
					wait(0.1);
				}
			}
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}

greenhouse_ambush_04()
{
	source = getent("origin_greenhouse_fire04", "targetname");
	dest = getentarray("origin_greenhouse_target", "targetname");
	
	for (k=0; k<3; k++)
	{
		rand = randomintrange(12, 28);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			if (!level.greenhouse_thru)
			{
			if (isdefined(dest[randt]))
			{
				magicbullet("SAF45_white", source.origin, (dest[randt].origin + (randx, randy, randz)));
					wait(0.1);
				}
			}
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}






reset_greenhouse_ambush()
{
	trigger = getent("trigger_greenhouse_ambushthread", "targetname");
	trigger waittill("trigger");
	
	if (!(level.greenhouse_thru))
	{
		thread greenhouse_ambush_01();
	}
}






spawn_ambush_guards()
{
	spawner = getentarray("spawner_greenhouse_ambush", "targetname");
	
	for (i=0; i<spawner.size; i++)
	{
		guard[i] = spawner[i] stalingradspawn("ambush_guard");
		guard[i] waittill( "finished spawning" );
		guard[i].accuracy = 0.3;
		guard[i] setperfectsense(true);
	}
	
	wait(5.0);
	
	guys = getentarray("ambush_guard", "targetname");
	
	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i] thread disappear();
		}
	}
}

disappear()
{
	node = getnode("node_disappear", "targetname");
	
	if (isdefined(self))
	{
		self setgoalnode(node, 0);
		self waittill("goal");
		if (isdefined(self))
		{
			self delete();
		}
	}
}






greenhouse_ambush_done()
{
	trigger = getent("trigger_greenhouse_ambushdone", "targetname");
	trigger waittill("trigger");
	
	level.greenhouse_thru = true;
	
	level thread vo_large_greenhouse();
	level thread greenhouse_shootout();
	level thread block_small_greenhouse();
	
	wait(1.0);
}






spawn_heli_gunner()
{
	spawner = getent( "spawner_heli_gunner", "targetname" );
	guy = spawner stalingradspawn("gunner");
}






spawn_heli_greenhouse()
{	
	
	flypt00 = getent("origin_greenhouse_heliface", "targetname");
	flypt01 = getent("origin_greenhouse_helipt01", "targetname");
	flypt02 = getent("origin_greenhouse_helipt02", "targetname");
	flypt03 = getent("origin_greenhouse_helipt03", "targetname");
		
	heli = getent("heli_greenhouse", "targetname");
	
	trigger = getent("trigger_greenhouse_heli", "targetname");
	trigger waittill("trigger");
	
	heli show();
	heli trigger_on();
	
	heli.health = 10000;
	
	heli playloopsound("police_helicopter");
	
	wait(0.1);
		
	guy = getent("gunner", "targetname");
	guy teleport(heli GetTagOrigin("tag_playerride"), (heli GetTagAngles("tag_playerride")+ (0,0,0)), true);
	guy linkto(heli, "tag_playerride", (-12, 36, 12), (0, 0, 0));
		
	guy setperfectsense(true);
	guy allowedstances( "crouch" );
	guy setpainenable( false );
	guy.accuracy = 0.5;
	
	
	
	
	guy setDeathEnable(false);
		
	wait(0.1);
	
	heli setspeed(60, 45);
	heli setvehgoalpos ((flypt00.origin), 1);
	heli waittill ( "goal" );
	
	wait(5.0);
	
	go = false;
	
	while(!go)
	{
		if (heli.health < 9000)
		{
			go = true;
		}
		
		guy = getent("gunner", "targetname");
		if (!(isdefined(guy)))
		{
			go = true;
		}
		
		if (level.heli_go)
		{
			go = true;
		}
		
		wait(0.05);
	}
	
	if (isdefined(guy))
	{
 		guy movey(2, 0.1);
		guy setenablesense(false);
	}
	
	heli setvehgoalpos ((-6070, -1500, -60), 1);
	heli waittill ( "goal" );
	
	wait(1.0);
	
	heli setvehgoalpos ((flypt01.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt02.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt03.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((14842, -4342, 7003), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((10615, -10213, 7003), 0);
	
	heli stoploopsound();
	
	if (isdefined(guy))
	{
		guy delete();
	}
	
	if (isdefined(heli))
	{
		heli delete();
	}
}






block_small_greenhouse()
{
	trigger = getent("trigger_block_greenhouse", "targetname");
	trigger waittill("trigger");
	
	level.heli_go = true;
	
	level thread vo_small_greenhouse();
	
	SetDVar("sm_SunSampleSizeNear", 0.569);
	
	block = getent("door_block_inside", "targetname");
	coll_small_greenhouse = getent("collision_small_greenhouse", "targetname");
	
	coll_small_greenhouse trigger_on();
	
	block rotatepitch(45, 0.2);
	
	block thread move_block_greenhouse();
	
	wait(0.2);
	
	block rotateyaw(-15, 0.2);
	
	boat01 = getent("boat_01", "targetname");
	
	
	boat01 delete();
	
}


move_block_greenhouse()
{
	self movez(-12, 0.2);
	wait(0.2);
	self movex(-24, 0.2);
}






greenhouse_shootout()
{
	trigger = getent("trigger_greenhouse_shootout", "targetname");
	trigger waittill("trigger");
	
	level thread spawn_glass_breaker();
	level thread play_glass_effects();
	
	level thread greenhouse_shootout_01();
	wait(0.2);
	level thread greenhouse_shootout_02();
	wait(0.2);
	level thread greenhouse_shootout_03();
	wait(0.2);
	level thread greenhouse_shootout_04();
	wait(0.2);
	level thread greenhouse_shootout_05();
	wait(0.2);
	level thread greenhouse_shootout_06();
	wait(0.2);
	level thread blowout_greenhouse_windows();
}


greenhouse_shootout_01()
{
	source = getent("origin_shootout_source01", "targetname");
	dest = getent("origin_shootout_target01", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
	
	wait(0.5);
	
	source delete();
	dest delete();
}

greenhouse_shootout_02()
{
	source = getent("origin_shootout_source02", "targetname");
	dest = getent("origin_shootout_target02", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
	
	wait(0.5);
	
	source delete();
	dest delete();
}

greenhouse_shootout_03()
{
	source = getent("origin_shootout_source03", "targetname");
	dest = getent("origin_shootout_target03", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
	
	wait(0.5);
	
	source delete();
	dest delete();
}

greenhouse_shootout_04()
{
	source = getent("origin_shootout_source04", "targetname");
	dest = getent("origin_shootout_target04", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
	
	wait(0.5);
	
	source delete();
	dest delete();
}

greenhouse_shootout_05()
{
	source = getent("origin_shootout_source05", "targetname");
	dest = getent("origin_shootout_target05", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
}

greenhouse_shootout_06()
{
	source = getent("origin_shootout_source06", "targetname");
	dest = getent("origin_shootout_target06", "targetname");
		
	rand = randomintrange(12, 28);
	randx = randomfloatrange(0.5, 20);
	randy = randomfloatrange(0.5, 20);
	randz = randomfloatrange(0.5, 10);
	randt = randomintrange(0, 11);
	
	randwait = randomfloatrange(0.1, 1.0);
	wait(randwait);
				
	for (i=0; i<rand; i++)
	{
		magicbullet("SAF45_white", source.origin, (dest.origin + (randx, randy, randz)));
		wait(0.1);
	}
}


play_glass_effects()
{
	target1 = getent("origin_shootout_target01", "targetname");
	target2 = getent("origin_shootout_target02", "targetname");
	target3 = getent("origin_shootout_target03", "targetname");
	target4 = getent("origin_shootout_target04", "targetname");
	target5 = getent("origin_shootout_target05", "targetname");
	target6 = getent("origin_shootout_target06", "targetname");
	
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target1.origin );
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target2.origin );
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target3.origin );
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target4.origin );
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target5.origin );
	wait(0.2);
	playfx (level._effect["whites_greenhouse_glass2"], target6.origin );
}






spawn_glass_breaker()
{
	trigger = getent("greenhouse_window_shooter", "targetname");
	trigger waittill("trigger");
	
	SetDVar("sm_SunSampleSizeNear", 0.25);
	
	level thread shootdown_greenhouse_light();
	level thread spawn_heli_house();
	level thread spawn_glass_mantler();
	
	flag_set("greenhouse_reached");
	
	spawner = getent ( "spawner_glass_breaker", "targetname" );
	node_glass = getnode("node_mantle_window", "targetname");
	node_cover = getnode("node_cover_break", "targetname");
	
	guard = spawner stalingradspawn("guard_glass");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.5;
		guard LockAlertState( "alert_red" );
		guard setperfectsense(true);
		guard setpainenable( false );
		guard thread greenhouse_death_check();
		guard setgoalnode(node_glass, 0);
	}
	
	guard waittill("goal");
	
	if (isdefined(guard))
	{
		guard setgoalnode(node_cover, 1);
		guard setpainenable( true );
	}
}


spawn_glass_mantler()
{
	node_glass = getnode("node_mantle_window2", "targetname");
	node_cover = getnode("node_cover_glassbreaker", "targetname");
	spawner = getent ( "spawner_greenhouse_mantler", "targetname" );
	
	guard = spawner stalingradspawn("guard_mantler");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.5;
		guard LockAlertState( "alert_red" );
		guard setperfectsense(true);
		guard setpainenable( false );
		guard thread greenhouse_death_check();
		guard setgoalnode(node_glass, 0);
	}
	
	guard waittill("goal");
	
	if (isdefined(guard))
	{
		guard setgoalnode(node_cover, 1);
		guard setpainenable( true );
	}
}

	



shootdown_greenhouse_light()
{
	origin = getentarray("origin_shootout_light", "targetname");
	
	for (i=0; i<4; i++)
	{
		randwait = randomfloatrange(3.0, 10.0);
		rand = randomintrange(0, 8);
		
		if (isdefined(origin[rand]))
		{
			radiusdamage (origin[rand].origin, 50, 100, 100 );
			wait(randwait);
		}
	}
	
	wait(0.5);
	
	for(i=0; i<origin.size; i++)
	{
		origin[i] delete();
	}
}






blowout_greenhouse_windows()
{
	level waittill ( "water_tank_explode_start" );
	
	level thread blowout_greenhouse_sidewindows();
	
	glass_low = getentarray("origin_tank_01", "targetname");
	glass_high = getentarray("origin_tank_02", "targetname");
	
	for (i=0; i<glass_low.size; i++)
	{
			radiusdamage (glass_low[i].origin, 50, 200, 200 );
	}
	
	wait(0.5);
	
	for (i=0; i<glass_high.size; i++)
	{
			radiusdamage (glass_high[i].origin, 50, 200, 200 );
	}
	
	wait(0.5);
	
	radiusdamage ((-2469, -989, -46), 120, 200, 200 );
	for (i=0; i<glass_low.size; i++)
	{
			radiusdamage ((glass_low[i].origin + (-258, 95, 50)), 80, 200, 200 );
	}
	
	wait(0.5);
	
	for (i=0; i<glass_low.size; i++)
	{
			glass_low[i] delete();
	}
	
	for (i=0; i<glass_high.size; i++)
	{
			glass_high[i] delete();
	}
}


blowout_greenhouse_sidewindows()
{
	wait(0.2);

	delay = 0.2;
	
	radiusdamage ((-2371, -1422, -119), 80, 200, 200 );
	radiusdamage ((-2104, -730, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2469, -1385, -119), 80, 200, 200 );
	radiusdamage ((-2202, -693, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2568, -1348, -119), 80, 200, 200 );
	radiusdamage ((-2303, -654, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2669, -1305, -119), 80, 200, 200 );
	radiusdamage ((-2404, -614, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2502, -577, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2865, -1228, -119), 80, 200, 200 );
	radiusdamage ((-2601, -540, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-2968, -1189, -119), 80, 200, 200 );
	radiusdamage ((-2666, -500, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-3066, -1151, -119), 80, 200, 200 );
	radiusdamage ((-2799, -461, -119), 80, 200, 200 );
	wait(delay);
	radiusdamage ((-3164, -1112, -119), 80, 200, 200 );
	radiusdamage ((-2898, -421, -119), 80, 200, 200 );
}






spawn_greenhouse_victims()
{
	level thread spawn_cellar_intro();
	
	level thread open_balcony_window();
	
	victim = getentarray("spawner_greenhouse_victim", "targetname");
	node = getnodearray("node_greenhouse_victim", "targetname");
	
	for (i=0; i<victim.size; i++)
	{
		victim[i] = victim[i] stalingradspawn("victim");
		victim[i] setperfectsense(true);
		victim[i] setgoalnode(node[i], 1);
		victim[i].accuracy = 0.5;
		wait(1.0);
	}
	
	wait(6.0);
	
	flag_set("victims_in_place");
}






open_balcony_window()
{
	windowdoor1 = GetEnt( "windowdoor1", "targetname" );
	windowdoor2 = GetEnt( "windowdoor2", "targetname" );
	
	windowdoor1 rotateyaw( -110, .2 );
	windowdoor2 rotateyaw( 110, .2 );
	
	wait(0.5);

	windowdoor1 ConnectPaths();
	windowdoor2 ConnectPaths();
}


close_balcony_window()
{
	windowdoor1 = GetEnt( "windowdoor1", "targetname" );
	windowdoor2 = GetEnt( "windowdoor2", "targetname" );
	
	windowdoor1 rotateyaw( 110, .2 );
	windowdoor2 rotateyaw( -110, .2 );
	
	wait(0.5);

	windowdoor1 disConnectPaths();
	windowdoor2 disConnectPaths();
}






flicker_light()
{
	level thread show_hide_lights();
	
	wait(0.1);
	
	light = getent("basement_light", "targetname");
	light light_flicker(true);
}


show_hide_lights()
{	
	light_on = getent("light_on", "targetname");
	light_off = getent("light_off", "targetname");
	
	while(1)
	{
		rand = randomfloatrange(0.01, 0.1);
		
		light_on hide();
		wait(rand);
		light_on show();
		wait(rand);
	}
}






spawn_cellar_intro()
{
	trigger = getent("trigger_cellar_entry", "targetname");
	trigger waittill("trigger");
	
	spawner = getentarray("spawner_cellar_intro", "targetname");
	spawner2 = getent("spawner_cellar_runner", "targetname");
	
	
	for (i=0; i<spawner.size; i++)
	{
		guard[i] = spawner[i] stalingradspawn("guard_cellar_01");
		guard[i] setpropagationdelay(0);
	}
	
	guard2 = spawner2 stalingradspawn("guard_cellar_02");
	guard2 setpropagationdelay(0);
	
	level thread vo_cellar_intro();
	level thread check_cellar_status();
	level thread check_cellar_backup();
	level thread set_cellar_alert();
}






check_cellar_status()
{
	guard = getentarray("guard_cellar_01", "targetname");
	guard_02 = getent("guard_cellar_02", "targetname");
	
	alerted = false;
	
	while(!(alerted))
	{
		for (i=0; i<guard.size; i++)
		{
			if (isdefined(guard[i]))
			{
			if (guard[i] getalertstate() == "alert_red" || guard_02 getalertstate() == "alert_red")
			{
				alerted = true;
				level thread take_cover();
				level thread spawn_cellar_guard();
					level.cellar_alerted = true;
				}
			}
		}
		wait(0.1);
	}
	
	
	
	
}






set_cellar_alert()
{
	trigger = getent("trigger_alert_cellar", "targetname");
	trigger waittill("trigger");
	
	guard = getentarray("guard_cellar_01", "targetname");
	guard_02 = getent("guard_cellar_02", "targetname");
	
	if (isdefined(guard_02))
	{
		guard_02 lockalertstate("alert_red");
		guard_02 setperfectsense(true);
	}
	
	for (i=0; i<guard.size; i++)
	{
		if (isdefined(guard[i]))
		{
			guard[i] lockalertstate("alert_red");
			guard[i] setperfectsense(true);
		}
	}
}






spawn_cellar_guard()
{
	spawner = getent("spawner_cellar_guard", "targetname");
	node = getnode("node_cellar_guard", "targetname");
	
	guard = spawner stalingradspawn("cellar_stair");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.6;
		guard setgoalnode(node, 1);
	}
}






take_cover()
{
	node_retreat = getnodearray("node_cover_cellarintro", "targetname");
	node = getnode("node_cellar_retreat", "targetname");
	guard_01 = getentarray("guard_cellar_01", "targetname");
	guard_02 = getent("guard_cellar_02", "targetname");
	
	for (i=0; i<guard_01.size; i++)
	{
		if (isdefined(guard_01[i]))
		{
			guard_01[i].accuracy = 0.6;
			guard_01[i] lockalertstate("alert_red");
			guard_01[i] setgoalnode(node_retreat[i], 1);
		}
	}
	
	if (isdefined(guard_02))
	{
		guard_02.accuracy = 0.6;
		guard_02 lockalertstate("alert_red");
		guard_02 setgoalnode(node, 1);
	}
}






check_cellar_backup()
{
	trigger = GetEnt( "cellar_thugs_spawn_02", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread spawn_cellar_backup();
	level thread spawn_wine_room();
}

spawn_cellar_backup()
{
	thugs = getentarray ( "cellar_thugs_01", "targetname" );
	node = getnodearray("node_cover_electric", "targetname");
	
	level thread spawn_cellar_guard();
	
	for (i=0; i<thugs.size; i++)
	{
		guard[i] = thugs[i] stalingradspawn("cellar_guard");
		if (isdefined(guard[i]))
		{
			guard[i].accuracy = 0.7;
			
			guard[i] setperfectsense(true);
		}
	}
}






wine_barrels_top01()
{
	wine = getentarray("origin_wine_explode01", "targetname");
	
	barrel = getent("wine_barrel_top01", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_01 = getent("coll_winemid_01", "targetname");
	coll_winemid_01 trigger_on();
	
	coll_winetop_01 = getent("coll_winetop_01", "targetname");
	coll_winetop_01 trigger_off();
	
	if (!(level.top_01))
	{
		level notify("wine_barrels_top_01_start");
		wine[0] playsound("whites_estate_falling_barrels");
		level.top_01 = true;
		if (isdefined(barrel))
		{
			barrel delete();
		}
	}
	
	wait(1.0);
	
	for (i=0; i<wine.size; i++)
	{
		radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}

wine_barrels_mid01()
{
	wine = getentarray("origin_wine_explode01", "targetname");
	
	barrel = getent("wine_barrel_mid01", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_01 = getent("coll_winemid_01", "targetname");
	coll_winemid_01 trigger_off();
	
	coll_winegone_01 = getentarray("coll_winegone_01", "targetname");
	for (i=0; i<coll_winegone_01.size; i++)
	{
		coll_winegone_01[i] trigger_on();
	}
	
	level notify("wine_barrels_mid_01_start");
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}



	for (i=0; i<wine.size; i++)
	{
		radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}


wine_barrels_top02()
{
	wine = getentarray("origin_wine_explode02", "targetname");
	
	barrel = getent("wine_barrel_top02", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_02 = getent("coll_winemid_02", "targetname");
	coll_winemid_02 trigger_on();
	
	coll_winetop_02 = getent("coll_winetop_02", "targetname");
	coll_winetop_02 trigger_off();
	
	if (!(level.top_02))
	{
		level notify("wine_barrels_top_02_start");
		wine[0] playsound("whites_estate_falling_barrels");
		level.top_02 = true;
		if (isdefined(barrel))
		{
			barrel delete();
		}
	}
	
	wait(1.0);
	
	for (i=0; i<wine.size; i++)
	{
		wine[i] radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}

wine_barrels_mid02()
{
	wine = getentarray("origin_wine_explode02", "targetname");
	
	barrel = getent("wine_barrel_mid02", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_02 = getent("coll_winemid_02", "targetname");
	coll_winemid_02 trigger_off();
	
	coll_winegone_02 = getentarray("coll_winegone_02", "targetname");
	for (i=0; i<coll_winegone_02.size; i++)
	{
		coll_winegone_02[i] trigger_on();
	}
	
	level notify("wine_barrels_mid_02_start");
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}




	for (i=0; i<wine.size; i++)
	{
		wine[i] radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}


wine_barrels_top03()
{
	wine = getentarray("origin_wine_explode03", "targetname");
	
	barrel = getent("wine_barrel_top03", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_03 = getent("coll_winemid_03", "targetname");
	coll_winemid_03 trigger_on();
	
	coll_winetop_03 = getent("coll_winetop_03", "targetname");
	coll_winetop_03 trigger_off();
	
	if (!(level.top_03))
	{
		level notify("wine_barrels_top_03_start");
		wine[0] playsound("whites_estate_falling_barrels");
		level.top_03 = true;
		if (isdefined(barrel))
		{
			barrel delete();
		}
	}
	
	wait(1.0);
	
	for (i=0; i<wine.size; i++)
	{
		wine[i] radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}

wine_barrels_mid03()
{
	wine = getentarray("origin_wine_explode03", "targetname");
	
	barrel = getent("wine_barrel_mid03", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_03 = getent("coll_winemid_03", "targetname");
	coll_winemid_03 trigger_off();
	
	coll_winegone_03 = getentarray("coll_winegone_03", "targetname");
	for (i=0; i<coll_winegone_03.size; i++)
	{
		coll_winegone_03[i] trigger_on();
	}
	
	level notify("wine_barrels_mid_03_start");
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}




	for (i=0; i<wine.size; i++)
	{
		wine[i] radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}


wine_barrels_top04()
{
	wine = getentarray("origin_wine_explode04", "targetname");
	
	barrel = getent("wine_barrel_top04", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_04 = getent("coll_winemid_04", "targetname");
	coll_winemid_04 trigger_on();
	
	coll_winetop_04 = getent("coll_winetop_04", "targetname");
	coll_winetop_04 trigger_off();
	
	if (!(level.top_04))
	{
		level notify("wine_barrels_top_04_start");
		wine[0] playsound("whites_estate_falling_barrels");
		level.top_04 = true;
		if (isdefined(barrel))
		{
			barrel delete();
		}
	}
	
	wait(1.0);
	
	for (i=0; i<wine.size; i++)
	{
		radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}

wine_barrels_mid04()
{
	wine = getentarray("origin_wine_explode04", "targetname");
	
	barrel = getent("wine_barrel_mid04", "targetname");
	barrel.health = 150;
	barrel setcandamage(true);
	
	barrel waittill("death");
	
	coll_winemid_04 = getent("coll_winemid_04", "targetname");
	coll_winemid_04 trigger_off();
	
	coll_winegone_04 = getentarray("coll_winegone_04", "targetname");
	for (i=0; i<coll_winegone_04.size; i++)
	{
		coll_winegone_04[i] trigger_on();
	}
	
	level notify("wine_barrels_mid_04_start");
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}




	for (i=0; i<wine.size; i++)
	{
		radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}






spawn_wine_room()
{
	trigger = getent("trigger_wine_room", "targetname");
	trigger waittill("trigger");
	
	level thread wine_knockover();
	level thread spawn_inside_balcony();
	
	
	
	
	spawner = getent("spawner_wine_room", "targetname");
	
	guard = spawner stalingradspawn("guard_wine");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.7;
		
		
	}
	
	
	}






wine_knockover()
{
	trigger = getent("trigger_wine_knockover", "targetname");
	trigger waittill("trigger");
	
	push = getent("origin_wine_knockover", "targetname");
	
	physicsExplosionSphere(push.origin, 200, 200, 3);
	
	wait(0.5);
	
	push delete();
}






shootout_kitchen_01()
{
	for (k=0; k<3; k++)
	{
		rand = randomintrange(8, 15);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			magicbullet("SAF45_white", (-321, -120, 103), ((-316, -546, 119) + (randx, randy, randz)));
			wait(0.1);
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}


shootout_kitchen_02()
{
	for (k=0; k<3; k++)
	{
		rand = randomintrange(8, 15);
		randx = randomfloatrange(0.5, 20);
		randy = randomfloatrange(0.5, 20);
		randz = randomfloatrange(0.5, 10);
		randt = randomintrange(0, 11);
				
		for (i=0; i<rand; i++)
		{
			magicbullet("SAF45_white", (-271, -120, 103), ((-271, -546, 119) + (randx, randy, randz)));
			wait(0.1);
		}
		
		delay = randomfloatrange(0.5, 1.5);
		wait(delay);
	}
}






spawn_inside_balcony()
{
	trigger = getent("trigger_spawn_balconies", "targetname");
	trigger waittill("trigger");
	
	level thread spawn_safe_lure();
	
	spawner = getentarray("spawner_inside_balcony", "targetname");
	
	for (i=0; i<spawner.size; i++)
	{
		guard[i] = spawner[i] stalingradspawn("balcony_guards");
		guard[i].accuracy = 0.6;
		guard[i] setperfectsense(true);
		guard[i] allowedstances("stand");
	}
	
	trigger = getent("trigger_safe_hint", "targetname");
	trigger waittill("trigger");
	
	level thread vo_safe_hint();
}






spawn_safe_lure()
{
	trigger = getent("trigger_safe_lure", "targetname");
	trigger waittill("trigger");
	
	node = getnode("node_safe_lure", "targetname");
	spawner = getent("spawner_lure_safe", "targetname");
	
	guard = spawner stalingradspawn("guard_safe");
	
	if (isdefined(guard))
	{
		guard setperfectsense(true);
		guard setgoalnode(node, 1);
	}
}






safe_button()
{
	maps\_playerawareness::setupSingleUseOnly(
 			"safe_button",		
 			::open_secret_door,		
 			&"WHITES_ESTATE_OPEN_BOOKCASE",	
 			undefined,  
 			undefined,	
 			false,		
 			true,		
 			undefined,	
 			undefined, 
 			false,		
 			false,		
 			false );	
}


open_secret_door(strcObject)
{
	flag_set("safe_hacked");
	flag_set("safe_located");
		
	maps\_autosave::autosave_now("whites_estate");

	level notify ( "open_z_gates" );
}






safe_keyboard()
{
	keyboard = getent("safe_keyboard", "targetname");
	
	
	
	maps\_playerawareness::setupEntSingleUseOnly(
		keyboard, 
		::computer_hack, 
		&"WHITES_ESTATE_HACK_COMPUTER", 
		5, 
		"", 
		true, 
		true, 
		undefined, 
		undefined, 
		true, 
		false, 
		true);
}





computer_hack(strcObject)
{
	level thread vo_computer_room();
	
	
	
	level thread close_bookcase();
		
	level.player FreezeControls( true );
	
	level thread letterbox_on(false, false);
		
	VisionSetNaked( "whites_estate_0" );
	
	flag_wait("vo_computer_done");
	
	playcutscene("WE_Detonate", "WE_Detonate_Done");
	
	level waittill("WE_Detonate_Done");
	
	
	level notify("endmusicpackage");

	VisionSetNaked( "whites_estate_house" );
	
	setExpFog( 0, 200, 0.25, 0.25, 0.25, 0, 0.65 );
	
	flag_set("explosion_done");
	
	level.turn_off_flicker = true;
	
	
	
	level thread monitor_sparks();
	
	letterbox_off();
}


explode_server_room()
{
	push = getent("origin_hack_push", "targetname");

	push playsound("whites_estate_house_hack_explosion");
	
	level.player shellshock("flashbang", 5.0);
	
	wait(0.05);
	
	level.player knockback(3000, push.origin + (0, 0, 0));
	
	physicsExplosionSphere((571, -519, 408), 200, 200, 15);
	
	level.player FreezeControls( false );
	
	earthquake (0.7, 6.0, level.player.origin, 200, 15.0 );
	
	level thread villa_blow_wall();
	level thread house_fire_setup();
	level thread planter_damage();
	level thread safe_room_destroy();
	level thread vo_white_helicopter();
	level thread collision_setup();
	level thread villa_first_wave();
	
	
	
	level thread fire_server_room();
	level thread outside_explosion();
	level thread delete_wine_origins();
	
	level notify ( "white_blows_estate" );
	
	
	level notify("playmusicpackage_house");

	
	
	
}
	
	
fire_server_room()
{
	fire_server = getentarray("origin_fire_server", "targetname");
	fire_wall = getent("origin_fire_serverwall", "targetname");
	
	fire_wall = spawnfx(level._effect["wall_fire"], fire_wall.origin);
	triggerFX(fire_wall);
	
	for (i=0; i<fire_server.size; i++)
	{
		fire_server[i] = spawnfx(level._effect["med_fire"], fire_server[i].origin);
		triggerFX(fire_server[i]);
	}
	
	triggerhurt_server = getentarray("trigger_hurt_server", "targetname");
	for (i=0; i<triggerhurt_server.size; i++)
	{
		triggerhurt_server[i] trigger_on();
	}
	
	fire_server[0] playloopsound("whites_estate_fire_loop");
	fire_server[1] playloopsound("whites_estate_fire_loop");
}


monitor_sparks()
{
	setplayerignoreradiusdamage(true);

	origin = getent("origin_hack_push", "targetname");
	 
	origin playsound("whitesestate_sparks");
	
	playfx (level._effect["monitor_sparks"], (554, -534, 394));
	radiusdamage((554, -534, 394), 80, 20, 20);
		
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (547, -541, 408));
	radiusdamage((547, -541, 408), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (579, -560, 414));
	
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (532, -510, 414));
	radiusdamage((532, -510, 414), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (532, -510, 437));
	radiusdamage((532, -510, 437), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (550, -556, 437));
	radiusdamage((550, -556, 437), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (535, -535, 437));
	radiusdamage((535, -535, 437), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (550, -554, 413));
	radiusdamage((550, -554, 413), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (534, -535, 413));
	radiusdamage((534, -535, 413), 80, 10, 10);
	
	radiusdamage((571, -519, 408), 80, 100, 100);
	
	wait(0.1);
	
	setplayerignoreradiusdamage(false);
}


house_fire_setup()
{
	fire_door = getent("collision_fire_door", "targetname");
	fire_door trigger_on();
	
	house_fire = getentarray("triggerhurt_fire_house", "targetname");
	for (i=0; i<house_fire.size; i++)
	{
		house_fire[i] trigger_on();
	}
	
	firecoll = getentarray("collision_fire_house", "targetname");
	for (k=0; k<firecoll.size; k++)
	{
		firecoll[k] trigger_on();
	}
}


collision_setup()
{
	room2 = getent("room_destroyed_02", "targetname");
	room2 show();
	room2 trigger_on();
	
	phys_triggers = getentarray("trigger_physics", "targetname");
	for (i=0; i<phys_triggers.size; i++)
	{
		phys_triggers[i] trigger_on();
	}
	
	front_trigger = getent("front_door_temp_open", "targetname");
	front_trigger trigger_on();
}

delete_wine_origins()
{
	wine1 = getentarray("origin_wine_explode01", "targetname");
	wine2 = getentarray("origin_wine_explode02", "targetname");
	wine3 = getentarray("origin_wine_explode03", "targetname");
	wine4 = getentarray("origin_wine_explode04", "targetname");
	
	for (i=0; i<wine1.size; i++)
	{
		wine1[i] delete();
	}
	for (i=0; i<wine2.size; i++)
	{
		wine2[i] delete();
	}
	for (i=0; i<wine3.size; i++)
	{
		wine3[i] delete();
	}
	for (i=0; i<wine4.size; i++)
	{
		wine4[i] delete();
	}
}






first_house_guards()
{
	spawner = getent("villa_wave_01slider", "targetname");
	node = getnode("node_cover_floorfall", "targetname");
	
	guard = spawner stalingradspawn("guard_slider");
	
	if (isdefined(guard))
	{
		guard setgoalnode(node, 1);
		guard setpropagationdelay(0);
	}
	
	trigger = getent("trigger_knockover_vases", "targetname");
	trigger waittill("trigger");
	
	flag_set("blowup_floor");
	
	
	
	
	
	
	
	
	
	
	level thread trigger_floor_collapse();
}






ceiling_tiles()
{
	exp = getentarray("origin_roof_exp", "targetname");
	
	for (i=0; i<exp.size; i++)
	{
		physicsExplosionSphere( exp[i].origin, 80, 80, 8 );
		wait(0.2);
	}
	
	wait(0.5);
	
	for (i=0; i<exp.size; i++)
	{
		exp[i] delete();	
	}
}






outside_explosion()
{
	trigger = getent("trigger_outside_explosion", "targetname");
	trigger waittill("trigger");
	
	exp = getent("origin_outside_explosion", "targetname");
	
	physicsExplosionSphere( exp.origin, 100, 100, 10 );
	
	earthquake (0.5, 1.0, level.player.origin, 700, 10.0 );
	
	exp playsound("whites_estate_house_generic_explosion");
}






explode_third_floor()
{
	table = getent("desk_1", "targetname");
	clip = getent("clip_desk", "targetname");
	
	explosion = getent("origin_explosion_floorfall", "targetname");
	exp = getent("origin_explosion_rail", "targetname");
	exp2 = getent("origin_explosion_desk", "targetname");

	physicsExplosionSphere( exp2.origin, 100, 100, 10 );
	physicsExplosionSphere( exp.origin, 100, 100, 10 );
	
	table delete();
	
	radiusdamage(explosion.origin, 200, 200, 200);
	
	coll_third_floor = getent("collision_third_floor", "targetname");
	coll_third_floor trigger_on();
	
	
	
	wait (0.1);
	
	
	
	wait(0.1);
	
	clip delete();
	
	wait(0.5);
	
	explosion delete();
	exp delete();
	exp2 delete();
}






trigger_balcony_explosion()
{
	trigger = getent("trigger_lookat_balconyvictim", "targetname");
	trigger waittill("trigger");
	
	wait(0.5);
	
	flag_set("balcony_victim");
	
	explosion = getent("origin_balcony_victim", "targetname");
	
	explosion playsound("whites_estate_house_generic_explosion");
	
	earthquake (0.7, 1.5, level.player.origin, 700, 10.0 );

	playfx (level._effect["large_boom"], explosion.origin + (60, 0, 0));
	
	physicsExplosionSphere( explosion.origin + (0, 0, -54), 140, 100, 15 );
	
	floor_good = getent("blowupfloor_f2", "targetname");
	floor_good delete();
	
	floor_bad = getent("blowupfloor_f2_after", "targetname");
	floor_bad show();
	
	railing1_after = getent("railing_f2_after", "targetname");
	railing1_after show();
	
	railing1 = getent("railing_f2", "targetname");
	railing1 delete();
	
	wait(0.5);
	
	explosion delete();
}






explosion_second_floor()
{
	trigger = getent("trigger_balcony_victim", "targetname");
	trigger waittill("trigger");
	
	level thread villa_blow_car_early_func();
	
	
	explosion = getent("origin_balcony_victim", "targetname");
	spawner = getent("spawner_balcony_victim", "targetname");
	node = getnode("node_balcony_victim", "targetname");
	
	victim = spawner stalingradspawn("balcony_victim");
	victim setperfectsense(true);
	victim allowedstances("stand");
	victim.accuracy = 0.3;
	
	level thread trigger_balcony_explosion();
	
	flag_wait("balcony_victim");
	
	radiusdamage(explosion.origin, 120, 100, 100);
	
	earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
	
	level notify ( "fires_27" );
	level notify ( "fires_28" ); 
	level notify ( "fires_29" ); 
	level notify ( "fires_30" );
}






statue_fall_above()
{
	exp1 = getent("origin_statue_exp01", "targetname");
	exp2 = getent("origin_statue_exp02", "targetname");
	
	physicsExplosionSphere( exp1.origin, 50, 50, 1 );
	
	wait(0.4);
	
	physicsExplosionSphere( exp2.origin, 50, 50, 1 );
	
	wait(0.5);
	
	exp1 delete();
	exp2 delete();
}






statue_fall_below()
{
	exp1 = getent("origin_statue_exp03", "targetname");
	exp2 = getent("origin_statue_exp04", "targetname");
	
	physicsExplosionSphere( exp1.origin, 50, 50, 1 );
	
	wait(0.1);
	
	physicsExplosionSphere( exp2.origin, 50, 50, 1 );
	
	wait(0.5);
	
	exp1 delete();
	exp2 delete();
}






front_door_assault()
{
	assault = getentarray("guard_rusher", "targetname");
	left = getnode("node_house_left", "targetname");
	right = getnode("node_house_right", "targetname");
	
	if (isdefined(assault[0]))
		{
		assault[0] setgoalnode(left, 1);
		}
	
	if (isdefined(assault[1]))
	{
		assault[1] setgoalnode(right, 1);
	}
}






atrium_glass_break()
{
	trigger = getent("trigger_glass_atrium", "targetname");
	trigger waittill("trigger");
	
	
	
	
	
	wait(2.7);
	
	earthquake (0.7, 0.8, level.player.origin, 200, 10.0 );
	level.player playsound("whites_estate_rumble_sound");
	
	wait(0.3);
	
	radiusdamage((1212, -637, 147), 60, 300, 300);
	radiusdamage((1212, -621, 228), 60, 300, 300);
	radiusdamage((1177, -428, 292), 60, 300, 300);
	radiusdamage((1211, -232, 228), 60, 300, 300);
	radiusdamage((1211, -216, 147), 60, 300, 300);
	
	wait(0.2);
	
	radiusdamage((1272, -637, 147), 60, 300, 300);
	radiusdamage((1272, -621, 228), 60, 300, 300);
	radiusdamage((1272, -428, 292), 60, 300, 300);
	radiusdamage((1272, -232, 228), 60, 300, 300);
	radiusdamage((1272, -216, 147), 60, 300, 300);
	
	wait(0.2);
	
	radiusdamage((1368, -637, 147), 60, 300, 300);
	radiusdamage((1368, -621, 228), 60, 300, 300);
	radiusdamage((1368, -428, 292), 60, 300, 300);
	radiusdamage((1368, -232, 228), 60, 300, 300);
	radiusdamage((1368, -216, 147), 60, 300, 300);
	
	wait(0.3);
	
	radiusdamage((1428, -428, 268), 60, 300, 300);
	radiusdamage((1529, -427, 228), 60, 300, 300);
	radiusdamage((1529, -331, 228), 60, 300, 300);
	radiusdamage((1529, -526, 228), 60, 300, 300);
	radiusdamage((1529, -527, 147), 60, 300, 300);
	radiusdamage((1529, -330, 147), 60, 300, 300);
}






spawn_atrium_victim()
{
	spawner = getent("atrium_victim", "targetname");
	explosion = getent("origin_atrium_victim", "targetname");
	
	victim = spawner stalingradspawn("atrium_victim");
	
	victim setenablesense(false);
	
	flag_wait("atrium_victim");
	
	radiusdamage(explosion.origin, 90, 160, 160);
}






spawn_heli_house()
{	
	
	flypt01 = getent("origin_house_helipt01", "targetname");
	flypt02 = getent("origin_house_helipt02", "targetname");
	flypt03 = getent("origin_house_helipt03", "targetname");
	flypt04 = getent("origin_house_helipt04", "targetname");
	flypt05 = getent("origin_house_helipt05", "targetname");
	looktarget = getent("objective2_marker", "targetname");
		
	
	
	heli = getent("heli_house", "targetname");
	
	heli show();
	heli trigger_on();
	
	heli.health = 10000;
	
	heli playloopsound("police_helicopter");
		
	heli setspeed(60, 40);
	heli setvehgoalpos ((flypt01.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt02.origin), 1);
	heli waittill ( "goal" );
	heli setspeed(20, 10);
	heli setvehgoalpos ((flypt03.origin), 1);
	heli waittill ( "goal" );
	heli setLookAtEnt( level.player );
	
	level thread check_water_tank();
	
	while(!level.gotime)
	{
		if (heli.health < 10000)
		{
			level.gotime = true;
		}
		
		wait(0.3);
	}
	
	level thread heli_shake_greenhouse();
	
	heli setLookAtEnt( flypt04 );
	heli setspeed(30, 10);
	heli setvehgoalpos ((flypt04.origin), 0);
	heli waittill ( "goal" );
	heli clearLookAtEnt();
	heli setvehgoalpos ((flypt05.origin), 0);
	heli waittill ( "goal" );
	heli setspeed(60, 30);
	heli setvehgoalpos ((-5751, 2866, 272), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((975, 2355, -285), 0);
	
	heli waittill ( "goal" );
	
	heli stoploopsound();
	
	if (isdefined(heli))
	{
		heli delete();
	}
}


heli_shake_greenhouse()
{
	glass = getentarray("origin_heli_glass", "targetname");
	
	wait(2.5);
	
	earthquake (0.1, 4.0, level.player.origin, 700, 8.0 );
	
	for (i=0; i<glass.size; i++)
	{
		playfx (level._effect["whites_greenhouse_glass1"], glass[i].origin );
		
		
		wait(0.3);
	}
	
	wait(0.5);
	
	for (i=0; i<glass.size; i++)
	{
		glass[i] delete();
	}
}


check_water_tank()
{
	level waittill ( "water_tank_explode_start" );
	level.gotime = true;
}






vo_explosions_start()
{
	level waittill ( "white_blows_estate" );
	
	level thread open_piano_gate();
	
	trigger = GetEnt( "vision_set_outside", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_wait("helipad_located");
	
	level thread vo_white_end();
	
	
}






open_piano_gate()
{
	door01 = getent("gate_l", "targetname");
	door02 = getent("gate_r", "targetname");
	
	door01 delete();
	door02 delete();
	
	
	
}





fire_01_sound()
{
	fire_origin = getentarray( "fire_origin_01", "targetname" );
	
	for (i=0; i<fire_origin.size; i++)
	{
		if (isdefined(fire_origin[i]))
		{
			fire_origin[i] playloopsound("whites_estate_fire_loop");
		}
	}
}


fire_02_sound()
{
	fire_origin = getentarray( "fire_origin_02", "targetname" );
	
	for (i=0; i<fire_origin.size; i++)
	{
		if (isdefined(fire_origin[i]))
		{
			fire_origin[i] playloopsound("whites_estate_fire_loop");
		}
	}
}


fire_03_sound()
{
	fire_origin = getentarray( "fire_origin_03", "targetname" );
	
	for (i=0; i<fire_origin.size; i++)
	{
		if (isdefined(fire_origin[i]))
		{
			fire_origin[i] playloopsound("whites_estate_fire_loop");
		}
	}
}


fire_04_sound()
{
	fire_origin = getentarray( "fire_origin_04", "targetname" );
	
	for (i=0; i<fire_origin.size; i++)
	{
		if (isdefined(fire_origin[i]))
		{
			fire_origin[i] playloopsound("whites_estate_fire_loop");
		}
	}
}


fire_05_sound()
{
	fire_origin = getentarray( "fire_origin_05", "targetname" );
	
	for (i=0; i<fire_origin.size; i++)
	{
		if (isdefined(fire_origin[i]))
		{
			fire_origin[i] playloopsound("whites_estate_fire_loop");
		}
	}
}







maintain_helicopter_health()
{
	level endon("helicopter_gone");

	while(1)
	{
		level.hit_detection_mask waittill("damage", amount);

		
		
		if ( level.helicopter_health < amount )
			level.helicopter_health = 1;
		else
			level.helicopter_health -= amount;
	}
}

check_helicopter()
{
    
	level.helicopter_health = 10000;
	level.helicopter = getent( "copter_fly_land", "targetname" );

	level.hit_detection_mask = getent("helicopter_hit_detection_mask", "targetname");
	level.hit_detection_mask linkto (level.helicopter);
	level.hit_detection_mask SetCanDamage(true);
	
	level.helicopter thread maintain_helicopter_health();

	vehicle = GetEnt( "copter_fly_land", "targetname" );
	takeoff = getent("origin_heli_takeoff", "targetname");

	flyaway = 0;
	flag_wait("helipad_located");
	
	while(level.helicopter_health  > 9900)
	{
		wait(0.25);
		flyaway++;
		if (flyaway > 40)
		{
			level notify("helicopter_gone");
			vehicle setspeed( 40, 40 );
			vehicle setvehgoalpos (takeoff.origin, 0 ); 
			wait(2.0);
			missionfailed();
		}
	}

    level thread mission_success();
}






chopper_sit()
{
	chopper = getent( "copter_fly_land", "targetname" );
	
	self teleport(chopper GetTagOrigin("tag_passenger"), (chopper GetTagAngles("tag_passenger")+ (0,0,0)), true);
	
	self LinkTo(chopper, "tag_passenger", (-100,0,-16), (0,0,0));
	
	self setenablesense( false );
	
	self cmdplayanim("Gen_Civs_SitIdle_E", true);
}






mission_success()
{
	level.player FreezeControls( true );
	
	flag_set("white_stopped");
	
	maps\_endmission::nextmission();
}

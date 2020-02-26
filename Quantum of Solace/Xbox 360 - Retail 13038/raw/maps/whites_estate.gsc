#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

//////////////////////////////////////////////////////////////////////////
//////////////////////////// WHITE'S ESTATE //////////////////////////////
//////////////////////////////////////////////////////////////////////////

//NOTES:
//add this to make water, steam or fire come out of a script model
//replace water with steam or fire for desired effect
//"script_noteworthy" "water"
//"targetname" "pipe_shootable"

///////////////////////////////////////////////////////////////////////////////////////////////////
//to do list//
//////////////
//Add a gun fight in stair well between the kitchen and the cellar
//Opening of gamplay: //have two thgus in cover //have one thug scaning the garden //have one thug reloading his gun //have two thugs looking at the leader thug
//Aquarium fight: //Teather both thugs have one thug standing and firing like a mad man have him screaming
//have dinning room guys shoot the plates as Bond makes his way up
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
/////////////////////    cover dvars    ////////////////////////
////////////////////////////////////////////////////////////////
//cover_corner_trans_enabled - corners
//cover_dash_fromCover_enabled - dash from cover
//cover_dash_from1stperson_enabled - dash from 1st person mode
//cover_dash_coplaner_enabled - coplaner dash
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
/////////////////////// CHECKPOINTS ////////////////////////////
////////////////////////////////////////////////////////////////
//As soon as the player gets control DONE
//At the Boathouse stairs, just as Bond walks down t_owards the boathouse DONE
//Right after Bond kills the first guard in the boathouse DONE
//After Bond kills the two guards in the first greenhouse, halfway to the large greenhouse but before the next enemies spawn DONE
//After the large greenhouse battle, as the PIP event starts DONE
//As Bond reaches the safe room in the mansion DONE
//After the big foyer battle, before Bond gets to Mr. White. DONE
////////////////////////////////////////////////////////////////

main()
{
	//precache & load FX entities (do before calling _load::main)
	
	maps\_vsedan::main("v_sedan_silver_radiant");
	maps\_vsedan::main("v_sedan_clean_black_radiant");
	//maps\_vsedan::main("v_astonmartindbs_radiant");
	//maps\_blackhawk::main( "v_heli_mdpd_low" );
	maps\_blackhawk::main( "v_heli_private" );
	
	maps\_securitycamera::init();
	
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
	
	
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	//setExpFog( 494.189, 1570.0, 0.4, 0.49, 0.5, 0, 0.74 );
	setExpFog( 2536, 3317, 0.507, 0.507, 0.476, 0, 0.7622 );
	
	precacheShader( "compass_map_whites_estate" );
	setminimap( "compass_map_whites_estate", 3648, 2368, -6080, -2168 );
	
	SetDVar("sm_SunSampleSizeNear", 1.208);
	SetDVar("sm_spotShadowEnable", 0);
	
	//artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	// Precaching shell shock effect.
	precacheshellshock ("default");
	precacheshellshock ("flashbang");
	precacheshellshock ("whites");
	//maps\_trap_extinguisher::init();
	
	//Cutscenes
	PrecacheCutScene("WE_END");
	PrecacheCutScene("WE_Detonate");
	//PrecacheCutScene("Blood_Barrell");
		
	maps\_load::main();
	maps\whites_estate_fx::main(); //after load:main for ps3 branching -D.O.

	
	//Audio
	thread maps\whites_estate_snd::main();
	thread maps\whites_estate_mus::main();

	array_thread(getentarray ("dest_v_sedan","targetname"), maps\_vehicle::bond_veh_flat_tire);

	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	//Optimized buoyancy time settings foe Whites Estate
	//See MikeA if you have any questions
	SetSavedDVar("phys_maxFloatTime", 70000);
	SetSavedDVar("phys_floatTimeVariance", 20000);


	/////////level variables/////////
	level.debug_text = 1;          //
	level.skipto_1 = 0;            //
	level.skipto_1a = 0;           //
	level.skipto_1b = 0;           //
	level.skipto_2 = 0;            //
	level.skipto_3 = 0;            //
	level.skipto_4 = 0;            //
	level.skipto_5 = 0;            //
	level.tracker = 0;             //
	level.tool_ads = 0;            //
	level.kill_pip = 0;            //
	level.white_shot = 0;          //
	level.thug_death_tracker = 0;  //
	level.boathouse_tracker = 0;   //
	level.greenhouse_thug = 0;     //
	level.cellar_thug = 0;         //
	level.force_gh_spawn = 0;      //
	level.boathouse = 0;           //
	level.statue_head = 0;         //
	level.move_left = 0;           //
	level.move_right = 0;          //
	level.last_man = 0;            //
	level.water_tank = 0;          //
	level.tutorial_00 = 0;         //
	level.tutorial_01 = 0;         //
	level.tutorial_02 = 0;         //
	level.tutorial_03 = 0;         //
	level.tutorial_04 = 0;         //
	level.tutorial_05 = 0;         //
	level.tutorial_06 = 0;         //
	level.tutorial_07 = 0;         //
	level.second_wave = 0;         //
	level.garden_death = 0;        //
	/////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////////////////////
	//	New Stuff
	///////////////////////////////////////////////////////////////////////////////////////
	flag_init("gogogo");
	flag_init("rundown_reached");
	flag_init("garden_alert");
	flag_init("signal_heli");
			
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
	flag_init("go_elites");
	
	flag_init("boathouse_reached");
	flag_init("greenhouse_reached");
	flag_init("security_eliminated");
	flag_init("house_entered");
	flag_init("entrance_found");
	flag_init("safe_located");
	flag_init("defended");
	flag_init("helipad_located");
	flag_init("white_stopped");
	
	level.heli_damage_path = false;
	
	level.reload_counter = 0;

	level.dock_explosion = false;	
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
	
	level.mission_succeeded = false;
	level.heli_go = false;
	
	level.exit_atrium = false;
	
	//level thread cover_hint();
	level thread check_cover_taken();
	level thread hint_take_cover();
	level thread switch_weapons_hint();
		
	level thread setup_bond();
	level thread camera_setup();
	level thread spawn_heli_garden();
	//level thread spawn_first_guard();
	level thread spawn_gate_guards();
	level thread spawn_boathouse_quickkill();
	//level thread objectives_whites_estate();
	level thread house_setup();
	level thread safe_button();
	level thread safe_keyboard();
	//level thread wait_hack();
	//level thread interrupt_hack();
	level thread house_lights_off();
	level thread vo_explosions_start();
	level thread wine_barrels_top01();
	level thread wine_barrels_mid01();
	level thread wine_barrels_top02();
	level thread wine_barrels_mid02();
	level thread wine_barrels_top03();
	level thread wine_barrels_mid03();
	level thread wine_barrels_top04();
	level thread wine_barrels_mid04();
	
	level thread vision_secondout_01();
	level thread vision_secondout_02();
	level thread vision_thirdout();
	level thread vision_atrium_outside();
	
	// DCS: added door to third floor, set to open.
	level thread open_saferoom_door();
	
	//DCS: removing feedbox from door thug, progression break.
	level thread setup_feedbox_dialog();

	
	//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
	
	blowupfloor2_after = GetEnt( "blowupfloor2_after", "targetname" );
	blowupfloor2_after hide();
	
	//temp
	//level thread spawn_cutscene_white();
	//level thread outside_explosion();
	//level thread boat_arrive();
	
	///////////////////////////////////////////////////////////////////////////////////////
	

	level thread skip_to_points();	// sets all skipto points.
	//this is for the black screen at the start of the level//
	strings = [];
	strings[0] = "White's Estate";
	strings[1] = "Play Intro";
	//strings[1] = "Italy";
	//strings[2] = "4:00 pm";

	level thread bond_setup();	// bonds initial setup, currently only weapons.
	//level.player setdemigod( true );

	//---------- OBJECTIVES -------------
	//level thread start_of_level( strings );
	
	//-----------------------------------

	//----------- TOOL TIPS -------------
	level thread tool_tip();
	//level thread tool_tip_dash_complete();
	//level thread tool_tip_dash_func();
	//level thread tool_tip_dash_funcB();
	//level thread tool_tip_transition_func();
	//level thread tool_tip_transitionB_func();
	//level thread tool_tip_mantel_func();
	//level thread tool_tip_phone_func();
	//level thread tool_tip_ads_func();
	//level thread tool_tip_lean_over_cover_func();
	//level thread tool_tip_dash_reminder_func();
	//-----------------------------------

	//------- GLOBAL FUNCTIONS ----------
	//level thread hide_destruc_cars();
	//level thread phone_data_setup();
	level thread vision_set_boathouse();
	//level thread tunnel_save_trigger();
	level thread boathouse_save_trigger();
	level thread estate_save_trigger();
// moved to whites_estate_fx.gsc
	//needed to uncomment this for focus test
	level thread fx_precache();
	//level thread maps\whites_estate_pip::monitor_cam();
	flag_init("feed_tapped");
	//-----------------------------------

	//------- GARDEN FUNCTIONS ----------
	//level thread garden_gates_open();
	//-----------------------------------

	//---- FRONT OF VILLA FUNCTIONS -----
	//level thread front_hold_bond();
	//level thread camera_start();
	level thread front_copter_land();
	level thread global_plane_flyby();
	level thread villa_fish_tank_func();
	//-----------------------------------

	//------ BOATHOUSE FUNCTIONS --------
	//-----------------------------------
	
	//------ GREENHOUSE FUNCTIONS -------
	//level thread basket_push_func();
	level thread end_thug_alert_check_func();
	//level thread greenhouse_fight();
	level thread greenhouse_water_tank_func();
	//-----------------------------------

	//-------- PACING MOMENT 01 ---------
	level thread cellar_trigger_fall_guy_fuc();
	//-----------------------------------

	//------------ CELLAR ---------------
	level thread cellar_thugs_spawn_01_func();
	level thread cellar_door_close_func();
	//level thread celler_thug_trigger_func();
	//-----------------------------------

	//----- WHITES VILLA FUNCTIONS ------
	//level thread estate_open_kitchen_door();
	//level thread setting_up_safe();
	//level thread fake_villa_first_wave();
	level thread villa_second_wave();
	//level thread villa_third_wave();
	level thread villa_save_game_func();
	level thread front_door_temp_open_func();
	level thread safe_room_save_func();
	level thread villa_hurt_triggers();
	level thread villa_bomb_prop_swap();
	//level thread second_fish_tank();
	level thread villa_fire_triggers_setup();
	level thread villa_trigger_primer_func();
	level thread villa_backup_trigger_door();
	//-----------------------------------
	
	//----- CONSERVATORY FUNCTIONS ------
	level thread conservatory_trigger_fight();
	level thread conservatory_trigger_end_mr_white();
	//-----------------------------------

	//-------- PACING MOMENT 01 ---------
	level thread pip_trigger_01_func();
	//-----------------------------------
}


// define skipto points.
skip_to_points()
{
	
	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "1" ) //
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
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//thread setting_up_safe();
	}     
	else if(Getdvar( "skipto" ) == "1a" ) //
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
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//thread setting_up_safe();
	}     
	else if(Getdvar( "skipto" ) == "1b" ) //
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
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//thread setting_up_safe();
		
		level thread spawn_lure();
		level thread tip_sprint();
	}     
	else if(Getdvar( "skipto" ) == "2" ) //
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
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//thread setting_up_safe();
		
		level thread greenhouse_shootout();
		
		level thread open_balcony_window();
	}     
	else if(Getdvar( "skipto" ) == "3" ) //
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
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//level thread setting_up_safe();
		
		level thread vision_set_inside();
	}     
	else if(Getdvar( "skipto" ) == "4" ) //
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

		//level notify ( "safe_hacked" );
		flag_set("safe_hacked");
		
		//lock = GetEnt( "safe_box", "targetname" ) maps\_unlock_mechanisms::setup_lock("eleclock_1");
		//thread setting_up_safe();
		
		level thread close_balcony_window();
		
		level thread vision_set_fire();
		//level thread villa_computer_hack_func();
	}
	else if(Getdvar( "skipto" ) == "white" ) //
	{
		setdvar("skipto", "0");
		level.skipto_5++;

		start_org = getent( "skipTo_5_origin", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
		//wait( 1 );
		//level.player allowcrouch( true );
		
		//maps\_utility::unholster_weapons();

		//level thread front_copter_land();
		//level thread conservatory_trigger_end_mr_white();
		
		//wait(1.0);
		
		//level notify ( "start_the_coppter" );
		
		playcutscene("Blood_Barrell", "Blood_Barrel_Done");
		
		level waittill("Blood_Barrel_Done");
	}     
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_00()
{
	level endon ( "tutorial_00" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_00 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_00" ); //"Use the left analog stick to move left and right."
			objective_state( 1, "current" );
		}
	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_01()
{
	level endon ( "tutorial_01" );
	while ( 1 )
	{
		wait( 15 );
		if ( level.tutorial_01 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_01" ); //"Shoot a statue."
			objective_state( 1, "current" );
		}
	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_02()
{
	objective_marker_icon = GetEnt( "objective_marker_icon", "targetname" );
//	level endon ( "tutorial_02" );
//	while ( 1 )
//	{
//		wait( 10 );
//		if ( level.tutorial_02 >= 0 )
//		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_02", ( objective_marker_icon.origin ) ); //"Take out the two thugs before trying to hack the gate."
			objective_state( 1, "current" );
//		}
//	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_03()
{
	level endon ( "tutorial_03" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_03 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_03" ); //"Complete the corner and switch transitions."
			objective_state( 1, "current" );
		}
	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_04()
{
	level endon ( "tutorial_04" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_04 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_04" ); //"Reload the weapon."
			objective_state( 1, "current" );
		}
	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_05()
{
	objective_add( 1, "invisible", &"WHITES_ESTATE_tutorial_05" ); //"Press the left and right triggers to cycle through the three phone screens.."
	objective_state( 1, "current" );
}

//avulaj
//tutorial objectives TUTORIAL_07
objectives_whites_estate_tutorial_06()
{
	level endon ( "tutorial_06" );
	while ( 1 )
	{
		wait( 10 );
		if ( level.tutorial_06 >= 0 )
		{
			objective_add( 1, "active", &"WHITES_ESTATE_tutorial_06" ); //"Pull the left analog stick away from the cover."
			objective_state( 1, "current" );
		}
	}
}

//avulaj
//tutorial objectives
objectives_whites_estate_tutorial_07()
{
	level endon ( "tutorial_07" );
	//while ( 1 )
	//{
	//	wait( 10 );
	//	if ( level.tutorial_07 >= 0 )
	//	{
			objective_add( 1, "active", &"WHITES_ESTATE_TUTORIAL_07" ); //"Press the Back button or the B button to exit the phone."
			objective_state( 1, "current" );
	//	}
	//}
}

//avulaj
//this handles the mission objectives
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

	mr_white_org = GetEnt( "mr_white_org", "targetname" );

	//level waittill ( "start_objective_0" );
	
	//******************************************************************************************************************************************************************************************************************************************
	
	wait(1.0);
	
	objective_add( 1, "active", &"WHITES_ESTATE_OBJECTIVE_01", ( objective_marker_1.origin ), &"WHITES_ESTATE_OBJECTIVE_BOATHOUSE_BODY" );
	
	//objective_marker_1 thread objective_dist();

	//level waittill ( "start_objective_1" );
	
	flag_wait("boathouse_reached");
	
	objective_state( 1, "done");
	
	objective_marker_1 delete();
	
	//******************************************************************************************************************************************************************************************************************************************
	
	objective_add( 2, "active", &"WHITES_ESTATE_OBJECTIVE_01A", ( objective_marker_1A.origin ), &"WHITES_ESTATE_OBJECTIVE_FEEDBOX_BODY" );
	
	flag_wait("feed_tapped");
	
	objective_state( 2, "done");
	
	objective_marker_1A delete();

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 3, "active", &"WHITES_ESTATE_OBJECTIVE_02", ( objective_marker_2.origin ), &"WHITES_ESTATE_OBJECTIVE_GREENHOUSE_BODY" );
	
	flag_wait("greenhouse_reached");
	
	objective_state( 3, "done");

	objective_marker_2 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 4, "active", &"WHITES_ESTATE_OBJECTIVE_03", ( objective_marker_3.origin ), &"WHITES_ESTATE_OBJECTIVE_SECURITY_BODY" );
	
	//level waittill ( "greenhouse_thugs_dead" );
	//level thread objective_tracker();
	
	flag_wait("security_eliminated");
	
	objective_state( 4, "done");
		
	//Stop Music - crussom
	level notify("endmusicpackage");
 
	objective_marker_3 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 5, "active", &"WHITES_ESTATE_OBJECTIVE_04", ( objective_marker_4.origin ), &"WHITES_ESTATE_OBJECTIVE_HOUSE_BODY" );
	
	//objective_marker_5 thread objective_dist();
	//level waittill ( "start_objective_4" );
	
	flag_wait("house_entered");
	
	objective_state( 5, "done");
	
	objective_marker_4 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 6, "active", &"WHITES_ESTATE_OBJECTIVE_05", ( objective_marker_5.origin ),&"WHITES_ESTATE_OBJECTIVE_ENTRANCE_BODY" );
	
	//objective_marker_6 thread objective_dist();
	//level waittill ( "start_objective_5" );
	
	flag_wait("entrance_found");
	
	objective_state( 6, "done");
	
	objective_marker_5 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 7, "active", &"WHITES_ESTATE_OBJECTIVE_06", ( objective_marker_6.origin ), &"WHITES_ESTATE_OBJECTIVE_SAFE_BODY" );
	
	//objective_marker_7 thread objective_dist();
	//level waittill ( "start_objective_6" );
	
	flag_wait("safe_located");
	
	objective_state( 7, "done");
	
	objective_marker_6 delete();
	
	//******************************************************************************************************************************************************************************************************************************************
	
	objective_add( 8, "active", &"WHITES_ESTATE_OBJECTIVE_06A", ( objective_marker_6A.origin ), &"WHITES_ESTATE_OBJECTIVE_COMPUTER_BODY" );
	
	flag_wait("explosion_done");
	
	objective_state( 8, "done");
	
	objective_marker_6A delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 9, "active", &"WHITES_ESTATE_OBJECTIVE_07", ( objective_marker_7.origin ), &"WHITES_ESTATE_OBJECTIVE_DEFEND_BODY" );
	
	//level waittill ( "safe_hacked" );
	
	flag_wait("defended");
	
	objective_state( 9, "done");
	
	objective_marker_7 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 10, "active", &"WHITES_ESTATE_OBJECTIVE_08", ( objective_marker_8.origin ), &"WHITES_ESTATE_OBJECTIVE_WHITE_BODY" );
	
	//level waittill ( "get_white" );
	
	trigger_helipad = getent("trigger_helipad_objective", "targetname");
	trigger_helipad waittill("trigger");
	
	objective_state( 10, "done");
	
	objective_marker_8 delete();
	
	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 11, "active", &"WHITES_ESTATE_OBJECTIVE_09", ( objective_marker_9.origin ), &"WHITES_ESTATE_OBJECTIVE_CHOPPER_BODY" );
	
	//trigger = GetEnt( "estate_save_trigger", "targetname" );
	//trigger trigger_on();

	//level waittill ( "start_the_coppter" );
	
	flag_wait("white_stopped");
	
	objective_state( 11, "done");
	
	objective_marker_9 delete();
}

//avulaj
//this will increment the objective number
objective_tracker()
{
	level notify ( "start_objective_" + level.tracker );
	level.tracker++;
}

//avulaj
//this will track the player dist from objective markers
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

//avulaj
//


//avulaj
//this handles displaying the maps
map_level()
{
	setSavedDvar( "sf_compassmaplevel",  "level1" );
	level thread map_level_01();
	level thread map_level_02();
	level thread map_level_03();
	level thread map_level_04();
	level thread map_level_05();
	level thread map_level_06();
}

//avulaj
//this handles displaying the maps
map_level_01()
{
	trigger = GetEnt( "map_trigger_level_1", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level1" );
		
		wait(0.1);
	}
	
	//level thread map_level_02();
}

//avulaj
//this handles displaying the maps
map_level_02()
{
	trigger = GetEnt( "map_trigger_level_2", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level2" );
		
		wait(0.1);
	}
	
	//level thread map_level_01();
	//level thread map_level_03();
}

//avulaj
//this handles displaying the maps
map_level_03()
{
	trigger = GetEnt( "map_trigger_level_3", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level3" );
		
		wait(0.1);
	}
	
	//level thread map_level_02();
	//level thread map_level_04();
}


//avulaj
//this handles displaying the maps
map_level_04()
{
	trigger = GetEnt( "map_trigger_level_4", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level4" );
		
		wait(0.1);
	}
	
	//level thread map_level_03();
	//level thread map_level_05();
}

//avulaj
//this handles displaying the maps
map_level_05()
{
	trigger = GetEnt( "map_trigger_level_5", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level5" );
		
		wait(0.1);
	}
	
	//level thread map_level_04();
	//level thread map_level_06();
}

//avulaj
//this handles displaying the maps
map_level_06()
{
	trigger = GetEnt( "map_trigger_level_6", "targetname" );
	
	while(1)
	{
		trigger waittill ( "trigger" );
		
		setSavedDvar( "sf_compassmaplevel",  "level6" );
	
		wait(0.1);
	}
	
	//level thread map_level_01();
	//level thread map_level_05();
}

//avulaj
//this sets a global text for the tool_tips throughtout the level
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

//avulaj
//this will hide all the destructible cars
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

//avulaj
//
villa_blow_car_early_func()
{
	trigger = GetEnt( "villa_blow_car_early", "targetname" );
	trigger waittill ( "trigger" );
	
	//car = GetEnt( "villa_destruc_car_boom", "script_noteworthy" );
	//trigger_for_car = GetEnt( "damage_trigger_for_car", "targetname" );
	
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
		
		//floor_mezz = getent("blowupfloor_mezz_after", "targetname");
		//floor_mezz trigger_on();
		//floor_mezz show();
	
		floor = getent("blowupfloor_mezz", "targetname");
		if (isdefined(floor))
		{
			floor delete();
		}
		
		level notify("balcony_collapse_start");
		
		balcony_kill = getentarray("origin_front_balcony", "targetname");
		//for (i=0; i<balcony_kill.size; i++)
		//{
		//	radiusdamage(balcony_kill[i].origin, 140, 200, 200 );
		//}
				
		radiusdamage((28, 98, 83), 140, 200, 200 );
		
		physicsExplosionSphere( (31, 43, 222), 200, 200, 10 );
		
		level.player playsound("whites_estate_falling_ceiling");
		
		earthquake (0.7, 1.5, level.player.origin, 700, 10.0 );
		
		wait(0.3);
		
		fire_frontdoor = getentarray("triggerhurt_front_door", "targetname");
		for (i=0; i<fire_frontdoor.size; i++)
		{
			fire_frontdoor[i] trigger_on();
		}
	
		balconyfire = getent("origin_front_balconyfire", "targetname");
		balconyfire = spawnfx(level._effect["large_fire"], balconyfire.origin);
		triggerFX(balconyfire);
		
		dining_fire = spawnfx(level._effect["large_fire"], (-168, -203, 60));
		triggerFX(dining_fire);
		
		for (i=0; i<balcony_kill.size; i++)
		{
			balcony_kill[i] delete();
		}
	}
	
	//trigger_for_car dodamage( 400, trigger_for_car.origin );
	//trigger_for_car trigger_off();
	//car dodamage( 2000, car.origin );
	//radiusdamage( ( 38, 476, -20 ), 300, 2000, 50 );
	
	//car playsound("whites_estate_house_car_explosion");
}


//avulaj
//when the car is killed an added explosion will happen to kill the thug hiding behind the front door
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
			//trigger_for_car = GetEnt( "damage_trigger_for_car", "targetname" );
			villa_blow_car_early = GetEnt( "villa_blow_car_early", "targetname" );
			//trigger_for_car waittill ( "damage" );
			
			stairs_main_after = getent("stairs_main_after", "targetname");
			stairs_main_after show();
	
			stairs_main = getent("stairs_main", "targetname");
			stairs_main delete();
			
			//exp_stairs = getent("origin_explosion_stairs", "targetname");
			//physicsExplosionSphere( exp_stairs.origin, 100, 100, 15 );

			villa_blow_car_early trigger_off();

			car = GetEnt( "villa_destruc_car_boom", "script_noteworthy" );
			
			car playsound("whites_estate_house_car_explosion");
			
			earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
			
			if (!(level.floor_mezz_collapsed))
			{
				level.floor_mezz_collapsed = true;
		
				//floor_mezz = getent("blowupfloor_mezz_after", "targetname");
				//floor_mezz trigger_on();
				//floor_mezz show();
	
				floor = getent("blowupfloor_mezz", "targetname");
				if (isdefined(floor))
				{
					floor delete();
				}
				
				level notify("balcony_collapse_start");
				
				level.player playsound("whites_estate_falling_ceiling");
				
				//front_door = getent("collision_front_door", "targetname");
				//front_door connectpaths();
			}
	
			//car dodamage( 2000, car.origin );
			radiusdamage( ( 38, 476, -20 ), 300, 2000, 50 );

			windows = GetEntArray( "frontdoorwindow", "targetname" );
			window_right = GetEnt( "front_door_boom_right", "targetname" );
			window_left = GetEnt( "front_door_boom_left", "targetname" );
			//car = GetEnt( "villa_destruc_car_boom", "script_noteworthy" );

			org_left = window_left.origin;
			org_right = window_right.origin;
			car_org = car.origin;

			//trigger_for_car waittill ( "trigger" );

			fx = playfx (level._effect["estate_car_explosion"], car_org );
			//physicsExplosionSphere( car_org, 200, 100, 15 );
			radiusdamage( car_org + ( 0, 0, 36 ), 200, 400, 500 );

			fx1 = playfx (level._effect["estate_car_explosion"], org_right );
			//physicsExplosionSphere( org_right, 200, 100, 15 );
			radiusdamage( org_right + ( 0, 0, 36 ), 200, 150, 200 );

			fx2 = playfx (level._effect["estate_car_explosion"], org_left );
			//physicsExplosionSphere( org_left, 200, 100, 15 );
			radiusdamage( org_left + ( 0, 0, 36 ), 200, 150, 200 );

			for ( i = 0; i < windows.size; i++ )
			{
				windows[i] delete();
			}

			//car_fire_stopper = GetEntArray( "car_fire_stopper", "targetname" );
			//for ( i = 0; i < car_fire_stopper.size; i++ )
			//{
			//	fx = playfx (level._effect["large_fire"], car_fire_stopper[i].origin );
			//}
			level notify ( "fires_15" ); level notify ( "fires_16" ); level notify ( "fires_33" ); level notify ( "fires_34" );
			//car_hurt_trigger = GetEnt( "car_hurt_trigger", "targetname" );
			//car_hurt_trigger2 = GetEnt( "car_hurt_trigger2", "targetname" );
			//car_hurt_trigger trigger_on();
			//car_hurt_trigger2 trigger_on();
			break;
		}
	}
}


//avualj
//this will hide all destrucbile cars
hide_car_00_func()
{
	self trigger_off();
}

//avulaj
//this will hide the old cars
hide_old_cars()
{
	level waittill ( "unhide_car_00" );
	old_car_01 = GetEnt( "car_01", "targetname" ); old_car_01 delete();
	old_car_02 = GetEnt( "car_02", "targetname" ); old_car_02 delete();
	old_car_03 = GetEnt( "car_03", "targetname" ); old_car_03 delete();
	old_car_04 = GetEnt( "car_04", "targetname" ); old_car_04 delete();
}

//avulaj
//thid unhides car_00
unhide_car_00_func()
{
	level waittill ( "unhide_car_00" );
	wait( .2 );
	self trigger_on();
}


//avulaj
//this handles the fade in
start_of_level( strings, outro )
{	
	//make sure to set these dvars early
	//SetDVar("r_pipSecondaryX", 0.05);
	//SetDVar("r_pipSecondaryY", 0.05);						// place top left corner of display safe zone
	//SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
	//level.player setsecuritycameraparams( 55, 3/4 );

	if (((( level.skipto_1 != 0 ) || ( level.skipto_1a != 0 ) || ( level.skipto_1b != 0 ) || ( level.skipto_2 != 0 ) || (level.skipto_3 != 0) || (level.skipto_4 != 0) || (level.skipto_5 != 0))))
	{
		return;
	}

	level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); // force player to dash to cover on right wall

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

	// Fade out black
	if( !IsDefined( outro ) )
	{
		level.introblack fadeOverTime( 1.5 ); 
		level.introblack.alpha = 0;
	}
	else
	{
		return;
	}

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText();
	
	level thread front_thug_follow();
}

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// TOOL TIPS //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//You no longer need to call playersetforcecover() twice for dashing to cover, as of my check-in this afternoon.

//avulaj
//
tool_tip_dash_func()
{
	target = GetEnt( "cover_marker_02a", "targetname" );
	trigger = GetEnt( "tool_tip_cover", "targetname" );
	triggerB = GetEnt( "tool_tip_coverB", "targetname" );
	trigger waittill ( "trigger" );
	triggerB trigger_off();

	tutorial_message("@WHITES_ESTATE_CORNER");

	org = spawn("script_origin",level.player.origin);
	level.player playerlinktodelta ( org, undefined );
	level.player waittill( "tutorialclosed" );

	level.player unlink();

//
//	if ( !level.player isInCover() )
//	{
//		level.player setplayerangles( vectortoangles(target.origin - level.player.origin) );
//	}
//	wait( .1 );
//	level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); // force player to dash to cover on right wall
//
//	while ( 1 )
//	{
//		wait( .5 );
//		if( level.player isInCover ())
//		{
//			level.player playersetforcecover( true, ( 0,0,1 ), true ); // force player to stay in cover
//			wait( 1 );
//			tutorial_message("@WHITES_ESTATE_DASH_TO");
//			level.player waittill( "tutorialclosed" );
//			wait( 0.01 );
//			level thread objectives_whites_estate_tutorial_02();
//			break;
//		}
//	}
}

//avulaj
//
tool_tip_dash_funcB()
{
	target = GetEnt( "cover_marker_02b", "targetname" );
	trigger = GetEnt( "tool_tip_cover", "targetname" );
	triggerB = GetEnt( "tool_tip_coverB", "targetname" );
	triggerB waittill ( "trigger" );
	trigger trigger_off();

	tutorial_message("@WHITES_ESTATE_CORNER");

	org = spawn("script_origin",level.player.origin);
	level.player playerlinktodelta ( org, undefined );
	level.player waittill( "tutorialclosed" );

	level.player unlink();

//
//	if ( !level.player isInCover() )
//	{
//		level.player setplayerangles( vectortoangles(target.origin - level.player.origin) );
//	}
//
//	wait( .1 );
//	level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); // force player to dash to cover on right wall
//
//	while ( 1 )
//	{
//		wait( .5 );
//		if( level.player isInCover ())
//		{
//			level.player playersetforcecover( true, ( 0,0,1 ), true ); // force player to stay in cover
//			wait( 1 );
//			tutorial_message( "@WHITES_ESTATE_DASH_TO" );
//			level.player waittill( "tutorialclosed" );
//			wait( 0.01 );
//			level thread objectives_whites_estate_tutorial_02();
//			break;
//		}
//	}
}

//avulaj
//this will release the player from cover
tool_tip_dash_complete()
{
	trigger = GetEnt( "dash_complete", "targetname" );
	trigger waittill ( "trigger" );

	level notify ( "give_up_on_pull_out" );
	//level notify ( "tutorial_02" );
	level notify ( "boathouse_gate_close" );
	level thread boat_float();

	fire_clip = GetEnt( "fire_block_temp", "targetname" );
	fire_clip trigger_off();
	fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
	fire_clip2 trigger_off();
	fire_clip2 connectPaths();

	//while ( 1 )
	//{
	//	wait( .5 );
	//	if( level.player isInCover ())
	//	{
	//		tutorial_message("@WHITES_ESTATE_PULL_OUT");
	//		level.player waittill( "tutorialclosed" );
	//		wait( 0.01 );
	//		level.player playerSetForceCover( false, false );
	//		level thread objectives_whites_estate_tutorial_06();
	//		wait( .5 );
	//		level thread cover_check();
		//	SaveGame( "whites_estate" );
	//		break;
	//	}
	//}
}

//avulaj
//this will teach the player how to use corner transition and switch cover
tool_tip_transition_func()
{
	target = GetEnt( "cover_marker_03a", "targetname" );
	triggerB = GetEnt( "tool_tip_transitionB", "targetname" );
	trigger = GetEnt( "tool_tip_transition", "targetname" );
	trigger waittill ( "trigger" );

	//level thread garden_thugs_func();

	triggerB trigger_off();

	//this is just a temp comment uncomment once coplanner is fixed
	//if ( !level.player isInCover() )
	//{
	//	level.player setplayerangles( vectortoangles(target.origin - level.player.origin) );
	//}
	//wait( .1 );
	//level.player playersetforcecover( true, ( 0,0,1 ), true, true ); // force player to dash to cover

	//while ( 1 )
	//{
	//	wait( .5 );
	//	if( level.player isInCover ())
	//	{
	//		SetDVar( "cover_dash_fromCover_enabled", "0" ); //dash while in cover
	//		SetDVar( "cover_dash_from1stperson_enabled", "0" ); //dash while 1st person

	//		level.player playersetforcecover( true, (0,0,1), true ); // force player to stay in cover
	//		level thread objectives_whites_estate_tutorial_03();
	//		tutorial_message("@WHITES_ESTATE_SWITCH");
	//		level.player waittill( "tutorialclosed" );
	//		wait( 0.01 );
	//		SetDVar( "cover_dash_coplaner_enabled", "1" ); //coplaner transition
	//		level.player waittill( "cover_dash_enter" );
	//		level notify ( "tutorial_03" );
	//		wait( 1 );

	//		tutorial_message("@WHITES_ESTATE_PULL_OUT");
	//		level.player waittill( "tutorialclosed" );
	//		wait( 0.01 );
	//		level thread cover_check();
			//level thread garden_teach_lock_hack();
			//level.player playerSetForceCover( false, false );

			level notify ( "cover_complete" );
			level thread objectives_whites_estate_tutorial_05();
	//		break;
	//	}
	//}
}

//avulaj
//
cover_check()
{
	while ( 1 )
	{
		wait( .1 );
		if( !level.player isInCover ())
		{
			level notify ( "tutorial_06" );
			break;
		}
	}
}

//avulaj
//this will teach the player how to use corner transition and switch cover
tool_tip_transitionB_func()
{
	target = GetEnt( "cover_marker_03b", "targetname" );
	triggerB = GetEnt( "tool_tip_transitionB", "targetname" );
	trigger = GetEnt( "tool_tip_transition", "targetname" );
	triggerB waittill ( "trigger" );

	level thread garden_thugs_func();

	trigger trigger_off();

	//this is just a temp comment uncomment once coplanner is fixed
	//if ( !level.player isInCover() )
	//{
	//	level.player setplayerangles( vectortoangles(target.origin - level.player.origin) );
	//}
	//wait( .1 );
	//level.player playersetforcecover( true, ( 0,0,1 ), true, true ); // force player to dash to cover

	//while ( 1 )
	//{
	//	wait( .5 );
	//	if( level.player isInCover ())
	//	{
	//		SetDVar( "cover_dash_fromCover_enabled", "0" ); //dash while in cover
	//		SetDVar( "cover_dash_from1stperson_enabled", "0" ); //dash while 1st person

	//		tutorial_message("@WHITES_ESTATE_SWITCH");
	//		level.player waittill( "tutorialclosed" );
	//		wait( 0.01 );
	//		SetDVar( "cover_dash_coplaner_enabled", "1" ); //coplaner transition
	//		level.player waittill( "cover_dash_enter" );
	//		level notify ( "tutorial_03" );
	//		wait( 1 );

	//		tutorial_message("@WHITES_ESTATE_PULL_OUT");
	//		level.player waittill( "tutorialclosed" );
	//		wait( 0.01 );
	//		level thread cover_check();
			//level thread garden_teach_lock_hack();
			//level.player playerSetForceCover( false, false );

			level notify ( "cover_complete" );
			level thread objectives_whites_estate_tutorial_05();
	//		break;
	//	}
	//}
}

//avulaj
//Tool tip mantel
//this will play VO telling the player how to use mantel
tool_tip_mantel_func()
{
	trigger = GetEnt( "tool_tip_mantel", "targetname" );
	trigger waittill ( "trigger" );

	
}

//avulaj
//Tool tip ADS
//this will play VO telling the player how to ADS
tool_tip_ads_func()
{
	trigger = GetEnt( "tool_tip_ads", "targetname" );
	trigger waittill ( "trigger" );
	woodexplode1 = GetEnt( "woodexplode1", "targetname" );
	//clip_01 = GetEnt( "dock_damage_trigger", "targetname" );
	//level thread boathouse_spawn_thug_01();
	level thread boathouse_lookat();
	level thread boathouse_trigger();
	level thread boathouse_gen_boats_sail();

	boat_01 = GetEnt( "boat_01", "targetname" );
	boat_02 = GetEnt( "boat_02", "targetname" );

	boat_01 thread boat_01_anim_play();
	boat_02 thread boat_02_anim_play();

	//level thread boathouse_boat_mousetrap();

	//clip_01 waittill ( "damage" );
	woodexplode1 trigger_off();
	//wait( .1 );
	//physicsExplosionSphere( ( -4773, 1740, -501 ), 200, 100, 40 );
}

//avulaj
//
boathouse_gen_boats_sail()
{
	gen_yacht_01 = GetEnt( "gen_yacht_01", "targetname" );
	gen_yacht_01 movey ( 35000, 180 );
	gen_yacht_01 waittill ( "movedone" );
	gen_yacht_01 delete();
}

//avulaj
//
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
//avulaj
//
tool_tip_pip()
{
	//tutorial_message( "@WHITES_ESTATE_PIP" );

	//org = spawn("script_origin",level.player.origin);
	//level.player playerlinktodelta ( org, undefined );
	//level.player waittill( "tutorialclosed" );

	//level.player unlink();

	level thread pip_trigger_00_func();
}

//avulaj
//Tool tip sneak
//this will play VO telling the player how to use sneak
tool_tip_phone_func()
{
	level waittill ( "cover_complete" );
	wait( .5 );

	while ( 1 )
	{
		wait( .1 );
		if( level.player isInCover ())
		{

		}
		else if ( !level.player isInCover ())
		{
			tutorial_message( "@WHITES_ESTATE_PHONE" );
	
			org = spawn("script_origin",level.player.origin);
			level.player playerlinktodelta ( org, undefined );
			level.player waittill( "tutorialclosed" );
			wait( 0.01 );

			//jpark
			//forcephoneactive( true );

			//saw_objectives = false;
			//saw_camera = false;
			//saw_data = false;
			
			//jpark
			saw_objectives = true;
			saw_camera = true;
			saw_data = true;

			while ( !saw_objectives || !saw_camera || !saw_data )
			{
				level.player waittill( "phonemenu", phone_state );
				if ( phone_state == 2 )
				{
					saw_objectives = true;
				}
				else if ( phone_state == 3 )
				{
					saw_camera = true;
				}
				else if ( phone_state == 4 )
				{
					saw_data = true;
				}
				wait( 0.05 );
			}
			//wait( 1.0 );
			//forcephoneactive( false );
			wait( .1 );
			level thread objectives_whites_estate_tutorial_07();
			//while ( 1 )
			//{
			//	wait( .1 );
			//	if (( saw_objectives == true ) && ( saw_camera == true ) && ( saw_data == true ))
			//	{
					setSavedDvar("cg_disableBackButton","0"); // re-enable

					user_closed = false;
					while ( !user_closed )
					{
						level.player waittill( "phonemenu", phone_state );
						if ( phone_state == 0 )
							user_closed = true;
					}

					SetSavedDVar( "cover_dash_fromCover_enabled", "1" ); //dash while in cover
					SetSavedDVar( "cover_dash_from1stperson_enabled", "1" ); //dash while 1st person

					//level notify ( "tutorial_07" );

					level.player unlink();
					//level thread objectives_whites_estate();
					//level thread objective_tracker();
					level notify ( "garden_thugs_attack" );
					level thread objectives_whites_estate_tutorial_02();
					//iPrintLnBold( "it_worked" );
					
					break;
			//	}
			//}
		}
	}
}

//avulaj
//Tool tip leaning over cover
//this will play VO telling the player how to lean over cover
tool_tip_lean_over_cover_func()
{
	trigger = GetEnt( "tool_tip_lean_over_cover", "targetname" );
	trigger trigger_off();
	//level waittill ( "safe_hacked" );
	flag_wait("safe_hacked");
	trigger trigger_on();
	trigger waittill ( "trigger" );

	while ( 1 )
	{
		wait( .5 );
		if( level.player isInCover ())
		{
			//tutorial_message("@WHITES_ESTATE_LEAN");
			//level.player waittill( "tutorialclosed" );
			//wait( 0.01 );
			//break;
		}
	}
}

//avulaj
//this is to remind the player that they can dash to cover
tool_tip_dash_reminder_func()
{
	trigger = GetEnt( "tool_tip_dash_reminder", "targetname" );
	trigger waittill ( "trigger" );
	
	tutorial_message( "Dash to cover by letting go of the [[{move}]] and pressing [[{+cover}]] while looking at another wall." );
	wait( 6 );
	tutorial_message( "" );
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//avulaj
//this handles the players view angle of the sniper scope.
//this also waits for the player to shoot Mr. White.
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

//avulaj
//bond initial setup
bond_setup()
{
	level.player takeallweapons();
	level.player GiveWeapon( "p99_s" );
	//maps\_utility::holster_weapons();
	maps\_phone::setup_phone();
	wait( .1 );
	//setSavedDvar("cg_disableBackButton","1"); // disable
	wait( 3 );
	level thread map_level();
}

//avulaj
//this handles the plane that flyes overhead
global_plane_flyby()
{
	plane = GetEnt( "plane_flyby", "targetname" );
	plane movex( -80000, 200 );
	plane waittill ( "movedone" );
	plane delete();
}

//-----------------------------------------------------------------------------------

//avulaj
//this changes the vision set for the boathouse
vision_set_boathouse()
{
	trigger = GetEnt( "vision_set_boathouse", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_1" );
	level thread vision_set_outside();
}

//avulaj
//this changes the vision set for the outside of the estate
vision_set_outside()
{
	trigger = GetEnt( "vision_set_outside", "targetname" );
	trigger waittill ( "trigger" );

	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	level thread vision_set_boathouse();
	level thread vision_set_inside();
}

//avulaj
//this changes the vision set for inside the estate
vision_set_inside()
{
	trigger = GetEnt( "vision_set_inside", "targetname" );
	trigger waittill ( "trigger" );

	VisionSetNaked( "whites_estate_2" );
	level thread vision_set_outside();
	level thread vision_set_house();
	
	setExpFog(329.0, 623.0, 0.268, 0.2706, 0.221, 0, 0.7);
}

vision_set_house()
{
	trigger = GetEnt( "trigger_visionset_house", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_house" );
	level thread vision_set_cellar();
	level thread vision_set_fire();
	
	setExpFog( 694.189, 1770.0, 0.4, 0.49, 0.5, 0, 0.6 );
}


vision_set_cellar()
{
	trigger = GetEnt( "trigger_visionset_cellar02", "targetname" );
	trigger waittill ( "trigger" );
	
	VisionSetNaked( "whites_estate_2" );
	level thread vision_set_house();
	
	setExpFog(329.0, 623.0, 0.268, 0.2706, 0.221, 0, 0.7);
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
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
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
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
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
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
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
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	level thread vision_thirdin();
}


vision_atrium_outside()
{
	trigger = getent("trigger_vision_atriumoutside", "targetname");
	trigger waittill("trigger");
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	setExpFog( 2536, 3317, 0.507, 0.507, 0.476, 0, 0.7622 );
	
	level thread vision_atrium_inside();
}


vision_atrium_inside()
{
	trigger = getent("trigger_vision_atriuminside", "targetname");
	trigger waittill("trigger");
	
	VisionSetNaked( "whites_estate_3" );
	
	setExpFog( 400, 600, 0.25, 0.25, 0.25, 0, 0.55 );
	
	level thread vision_atrium_outside();
}
	
	
//avulaj
//save game trigger
tunnel_save_trigger()
{
	trigger = GetEnt( "tunnel_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
}

//avulaj
//save game trigger
boathouse_save_trigger()
{
	trigger = GetEnt( "boathouse_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set("boathouse_reached");
	
	level notify ( "give_up_on_weapon" );
	trigger2 = GetEnt( "estate_save_trigger", "targetname" );
	trigger2 trigger_off();
}

//avulaj
//save game trigger
estate_save_trigger()
{
	trigger = GetEnt( "estate_save_trigger", "targetname" );
	trigger waittill ( "trigger" );
}

//avulaj
//
//  putting these in whites_estate_fx -David.
//needed to be able to call explosion for focus test
fx_precache()
{
	//level._effect["fire_ball"] = loadfx ("maps/barge/barge_door_exp01");
//	level._effect["large_boom"] = loadfx ("maps/shantytown/shanty_propane_large");
	//level._effect["large_fire"] = loadfx ("maps/whites_estate/whites_large_fire");
	//level._effect["propane_boom"] = loadfx ("maps/shantytown/shanty_propane_runner2");
	level._effect["estate_car_explosion"] = loadfx ("explosions/vehicle_exp_runner");
	//level._effect["water_steam"] = loadfx ("maps/Casino/casino_sauna_steam");
	level._effect["water_gush"] = loadfx ("maps/Casino/casino_spa_splash1");
	level._effect["water_squirt"] = loadfx ("maps/venice/venice_fountain01");
	level._effect["house_explosion"] = loadfx ("props/welding_exp");
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
//this handles the copter flying in and landing by the estate
front_copter_land()
{
	wait( .5 );
	vehicle = GetEnt( "copter_fly_land", "targetname" );
	
	vehicle trigger_off();
	
	playfxontag( level._effect[ "copter_dust" ], vehicle, "tag_turret" );

	vehicle.health = 90000;
	vehicle playsound ("police_helicopter_intro");
	//iprintlnbold("SOUND: chopper intro flyover")
	
	
	//1st Music Cue crussom
	level notify("playmusicpackage_start");
	
	wait ( .1 );	
	
	vehicle hide();
	
	level waittill ( "start_the_coppter" );
	
	vehicle show();
	vehicle trigger_on();
	
	//vehicle playloopsound("police_helicopter");
	//iprintlnbold("SOUND: chopper intro flyover");
	
	vehicle playsound ("police_helicopter_exit");	
	//iprintlnbold("SOUND: chopper exit flyover");
		
	land = getent("origin_heli_land", "targetname");
	face = getent("origin_heli_endface", "targetname");
		
	land playloopsound("helicopter_wind");
	
	//vehicle setspeed( 50, 50 );
	//vehicle setvehgoalpos (( 3915.78, 1259.11, 1016 ), 0 ); 
	//vehicle waittill ( "goal" );
	//vehicle setspeed( 50, 50 );
	//vehicle setvehgoalpos (( 3252.69, 273.502, 592 ), 0 ); 
	//vehicle waittill ( "goal" );
	//vehicle setspeed( 50, 50 );
	//vehicle setvehgoalpos (( 3029.98, -293.028, 496 ), 0 ); 
	//vehicle waittill ( "goal" );
	
	vehicle setspeed( 40, 20 );
	vehicle setvehgoalpos (( 3048, -857, 668 ), 0 ); 
	vehicle waittill ( "goal" );
	
	vehicle setLookAtEnt(face);
	
	vehicle setspeed( 15, 10 );
	vehicle setvehgoalpos(land.origin, 1);
	vehicle waittill ( "goal" );
	vehicle setspeed( 0 );
	
	flag_wait("helipad_located");
	
	level thread check_helicopter();
		
	vehicle setspeed( 2, 0.5 );
	vehicle setvehgoalpos(land.origin + (0, 0, 200), 1);
}

//avulaj
//
delete_all_ai()
{
	guys = getaiarray("axis", "neutral");

	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
}

//avulaj
//this will lock Bond in place while an AI jumps over a wall and over Bond
//The AI will miss bond and think he ran into the green house
//Bond will need to stealth behind the AI till the right moment to perform a stealth kill.
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

//avulaj
//
front_thug_follow()
{
	//self LockAlertState( "alert_yellow" );
	//self.DropWeapon = false;
	//wait( 2 );
	//iPrintLnBold( "Thug 01: You guys get to the big greehouse and check it out." );
	//wait( 4 );
	//level notify ( "wave1_go" );

	//iPrintLnBold( "Thug 01: The rest of you check the boathouse." );
	//wait( 3 );
	//level notify ( "wave2_go" );

	//if ( IsDefined ( self ))
	//{
	//	self startpatrolroute( "ledge_point_01" );
	//}

	//iPrintLnBold( "M: Bond take the time to scan the area." );
	//wait( 5 );

	//tutorial_message("@WHITES_ESTATE_INVERT_CONTROLS", "input_invertPitch");
	//level.player waittill( "tutorialclosed" );
	//wait( 3 );

	level.player allowcrouch( true );
	level.player allowStand( true );
	level.player unlink();
	level.player playerSetForceCover( false, false );
	level thread tool_tip_pickup_gun();
}

//avulaj
//
tool_tip_pickup_gun()
{
	target = GetEnt( "cover_marker_01", "targetname" );

	//trigger = GetEnt( "fountain_dash_to_cover", "targetname" );
	//trigger waittill ( "trigger" );

	level.player.allowads = false;

	//tutorial_message("@WHITES_ESTATE_DASH_INTO");
	//org = spawn("script_origin",level.player.origin);
	//level.player playerlinktodelta ( org, undefined );
	//level.player waittill( "tutorialclosed" );

	//level.player unlink();
	//level thread objectives_whites_estate_tutorial_00();
	level thread ambient_chopper_path_01();

	wait( 0.01 );

	if ( !level.player isInCover() )
	{
		level.player setplayerangles( vectortoangles(target.origin - level.player.origin) );
	}
	wait( .1 );
	level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); // force player to dash to cover on right wall

	while ( 1 )
	{
		wait( .5 );
		if( level.player isInCover ())
		{
			//maps\_utility::unholster_weapons();
			wait( .1 );
			level.player disableWeaponFiring();

			SetSavedDVar( "cover_dash_fromCover_enabled", "0" ); //dash while in cover
			SetSavedDVar( "cover_dash_from1stperson_enabled", "0" ); //dash while 1st person
			SetSavedDVar( "cover_dash_coplaner_enabled", "0" ); //coplaner transition

			level thread check_full_statue_death_01();
			level thread check_full_statue_death_02();
			//level thread check_statue_death_01();
			//level thread check_statue_death_02();
			//level thread check_statue_death_03();
			
			/*head_gen = GetEntArray( "statue_head_gen", "targetname" );
			for ( i=0; i < head_gen.size; i++ )
			{
				head_gen[i] thread check_statue_death_gen();
			}*/

			level thread replenish_ammo_count();

			//level thread tool_tip_move_left_func();
			//level thread tool_tip_move_right_func();
			//level thread tool_tip_move_done_func();
			//level waittill ( "move_func_done" );
			//wait( 2 );
			tutorial_message("@WHITES_ESTATE_ADS");
			level.player waittill( "tutorialclosed" );
			wait( 0.01 );
			level.player.allowads = true;

			level thread objectives_whites_estate_tutorial_01();
			level.player enableWeaponFiring();

			level waittill ( "statues_dead" );
			level notify ( "tutorial_01" );
			tutorial_message("@WHITES_ESTATE_RELOAD");

			level.player waittill( "tutorialclosed" );
			wait( 0.01 );
			level thread objectives_whites_estate_tutorial_04();
			level.player waittill( "reload" );
			level notify ( "tutorial_04" );
			wait( 1 );

			tutorial_message("@WHITES_ESTATE_DASH_INTO");
			org = spawn("script_origin",level.player.origin);
			level.player waittill( "tutorialclosed" );

			level.player playerSetForceCover( false, false );
			SetSavedDVar( "cover_dash_fromCover_enabled", "1" ); //dash while in cover
			SetSavedDVar( "cover_dash_from1stperson_enabled", "1" ); //dash while 1st person

			trigger = GetEnt( "fountain_dash_to_cover", "targetname" );
			trigger waittill ( "trigger" );

			level endon ( "give_up_on_pull_out" );
			while ( 1 )
			{
				wait( .1 );
				if( level.player isInCover ())
				{
					level.player playersetforcecover( true, ( 0, 0, 1 ), true, true ); // force player to dash to cover on right wall
					tutorial_message("@WHITES_ESTATE_PULL_OUT");
					level.player waittill( "tutorialclosed" );
					wait( 0.01 );
					level.player playerSetForceCover( false, false );
					level thread objectives_whites_estate_tutorial_06();
					wait( .5 );
					level thread cover_check();

					
					break;
				}
			}
			break;
 		}
	}
}

//avulaj
//
ambient_chopper_path_01()
{
	wait( .1 );
	vehicle = GetEnt( "fake_chopper_01", "targetname" );

	vehicle.vehicletype = "blackhawk";
	vehicle.script_int = 1;
	maps\_vehicle::vehicle_init( vehicle );
	vehicle.health = 10000;
	//vehicle playsound ("police_helicopter");
	//iprintlnbold("SOUND: chopper 2");
	wait ( .1 );	

	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -13008, 26944, 5216 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 22920, 5632 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 15800, 4272 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -12096, 10448, 3264 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -4320, -7656, 3264 ), 0 ); vehicle waittill ( "goal" );
	vehicle setspeed( 70, 70 );	vehicle setvehgoalpos (( -1384, -9824, 3264 ), 1 ); vehicle waittill ( "goal" );
	vehicle delete();
}

//avulaj
//this will track when the player moves left
tool_tip_move_left_func()
{
	threshhold = 0.2; // some amount 0-1
	move = level.player getNormalizedMovement();
	while ( move[1] > threshhold )
	{
		move = level.player getNormalizedMovement();
		wait( 0.05 );
	}
	level.move_left++;
}

//avulaj
//this will track when the player moves right
tool_tip_move_right_func()
{
	threshhold = 0.2; // some amount 0-1

	move = level.player getNormalizedMovement();
	while ( move[1] < threshhold )
	{
		move = level.player getNormalizedMovement();
		wait( 0.05 );
	}
	level.move_right++;
}

//avulaj
//this will track when the player has moved both left and right
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

//avulaj
//
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

//avulaj
//
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

//avulaj
//
check_statue_death_01()
{
	head = GetEnt( "statue_head_01", "targetname" );
	head waittill ( "damage" );
	physicsExplosionSphere( ( -2504, 316, -56 ), 200, 100, 2 );
	//level.statue_head++;
	//if ( level.statue_head >= 3 )
	//{
	//	wait( 1 );
	//	level notify ( "statues_dead" );
	//	level.player givemaxammo( "p99_s" );
	//}
}

//avulaj
//
check_statue_death_02()
{
	head = GetEnt( "statue_head_02", "targetname" );
	head waittill ( "damage" );
	physicsExplosionSphere( ( -2508, 640, -56 ), 200, 100, 2 );
	//level.statue_head++;
	//if ( level.statue_head >= 3 )
	//{
	//	wait( 1 );
	//	level notify ( "statues_dead" );
	//	level.player givemaxammo( "p99_s" );
	//}
}

//avulaj
//
check_statue_death_03()
{
	//head = GetEnt( "statue_head_03", "targetname" );
	//head waittill ( "damage" );
	//physicsExplosionSphere( ( -2230.5, 480.5, -54 ), 200, 100, 2 );
	//level.statue_head++;
	//changed this from 3 to 1, so only one head has to be shot
	//if ( level.statue_head >= 1 )
	//{
	//	wait( 1 );
	//	level notify ( "statues_dead" );
	//	level.player givemaxammo( "p99_s" );
	//}
}

//avulaj
//
check_statue_death_gen()
{
	self waittill ( "damage" );
	physicsExplosionSphere( self.origin + ( 5, 0, 0 ), 200, 100, 2 );
}

//avulaj
//
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

//avulaj
//this will snap the camera back to Bond
camera_start()
{
	trigger = GetEnt( "camera_start", "targetname" );
	trigger waittill ( "trigger" );
	level thread delete_all_ai();
}

//avulaj
//
end_thug_alert_check_func()
{
	trigger = GetEnt( "end_thug_alert_check", "targetname" );
	trigger waittill ( "trigger" );

	level thread greenhouse_wave_01_func();
	level thread greenhouse_obj_status();
	//level thread greenhouse_window_shooter();
	
	greenhouse_thug = getentarray ( "greenhouse_thugs_wave_00", "targetname" );
		
	for ( i = 0; i < greenhouse_thug.size; i++ )
	{
		thug[i] = greenhouse_thug[i] stalingradspawn("greenhouse_guard");
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] lockalertstate( "alert_red" );
			thug[i].accuracy = 0.3;
			thug[i] thread greenhouse_death_check();
		}
	}
	
	greenhouse_thug_a = getentarray ( "greenhouse_thugs_wave_00a", "targetname" );
	node = getnode("node_cover_greenhouse", "targetname");
	
	for ( i = 0; i < greenhouse_thug_a.size; i++ )
	{
		thug_a[i] = greenhouse_thug_a[i] stalingradspawn("spotter");
		if( !maps\_utility::spawn_failed( thug_a[i]) )
		{
			thug_a[i] lockalertstate( "alert_red" );
			//thug_a[i] SetEnableSense( false );
			//thug_a[i] SetCombatRole( "basic" );
			thug_a[i] thread greenhouse_death_check();
			//thug_a[i] thread greenhouse_damage_check();
			thug_a[i].accuracy = 0.3;
			wait(2.0);
			thug_a[i] setgoalnode(node, 1);
		}
	}
	
	level thread vo_greenhouse_battle();

	level notify ( "bond_at_large_greenhouse" );
}

//avulaj
//this thug is set up to shoot a window then jump through it
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
			//thug[i] setpainenable( false );
			thug[i] SetCombatRole( "basic" );
			thug[i] thread greenhouse_death_check();

		}
	}
}

//avulaj
//this function is set to a patrol node
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

//avulaj
//this function is set to a patrol node
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

//avulaj
//this function is set to a patrol node
greenhouse_window_finish()
{
	self SetEnableSense( true );
	self setpainenable( true );
}

//avulaj
//
greenhouse_death_check()
{
	self waittill ( "death" );
	level.greenhouse_thug++;
}

//avulaj
//
greenhouse_damage_check()
{
	self waittill ( "damage" );
	self  SetEnableSense( true );
}

//avulaj
//
greenhouse_obj_status()
{
	while ( 1 )
	{
		wait( 1 );
		
		if ( level.greenhouse_thug >= 3 )
		{
			level thread damage_water_tank();
		}
		
		//fxanim_water_tank
		
		if ( level.greenhouse_thug >= 7 )
		{
			level notify ( "greenhouse_thugs_dead" );
			//level thread greenhouse_water_tank_hint();
			//level thread spawn_greenhouse_victims();
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

//avulaj
//when this thug dies he will fly through the door backwards
//what should happen is a wave runs in the last guy slams the door shut and stands in front of it
greenhouse_get_ready()
{
	self SetEnableSense( true );
}

//avulaj
//greenhouse_door_clip
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
	
	//playfx (level._effect["water_squirt"], squirt.origin );
	//playfxontag( level._effect[ "water_squirt" ], squirt, "tag_origin" );
	
	water = spawnfx(level._effect["water_squirt"], squirt.origin);
	triggerFX(water);
	
	sound_watertank = getent("origin_sound_watertank", "targetname");
	sound_watertank playloopsound("whites_estate_tank_steam_loop");
	
	level waittill ( "greenhouse_thugs_dead" );
	
	flag_wait("victims_in_place");
	
	level thread autoblow_water_tank();
	
	trigger trigger_on();
	
	level waittill( "water_tank_look_at" );
	
	earthquake (0.2, 2.0, level.player.origin, 700, 3.0 );
	
	wait(1.5);
	
	level notify ( "water_tank_explode_start" );
	
	//squirt delete();
	water stopanimscripted();
	water stopuseanimtree();
	water delete();
	
	sound_watertank = getent("origin_sound_watertank", "targetname");
	//sound_watertank stoploopsound();
	sound_watertank playsound("whitesestate_tank_explosion");
	//iprintlnbold("SOUND: tank explosion");
	
	//playfx (level._effect["water_gush"], ( -2226, -1100.5, -95.5 ) );
	clip trigger_off();
	//door disconnectPaths();
	//wait( 3 );
	//level thread tool_tip_pip();
	
	flag_set("security_eliminated");
	
	//explosion = getent("origin_greenhouse_victim", "targetname");
	//radiusdamage (explosion.origin, 120, 120, 120 );
	
	wait(2.0);
	
	//sound_watertank  playsound("whitesestate_tank_explosion_b");
	//iprintlnbold("SOUND: glass implosion")
}


autoblow_water_tank()
{
	wait(10.0);

	level notify ( "water_tank_explode_start" );
	
	flag_set("security_eliminated");
}

//avulaj
//WATER_TANK
greenhouse_water_tank_hint()
{
	wait( 15 );
	if (( level.greenhouse_thug >= 6 ) && ( level.water_tank == 0 ))
	{
		tutorial_message("@WHITES_ESTATE_WATER_TANK");

		org = spawn("script_origin",level.player.origin);
		level.player playerlinktodelta ( org, undefined );
		level.player waittill( "tutorialclosed" );

		level.player unlink();
	}
}

//avulaj
//water_tank_shake_start
//water_tank_explode_start
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
		//playfx (level._effect["water_squirt"], squirt.origin );
		
		playfxontag( level._effect[ "water_squirt" ], squirt, "tag_origin" );
		
		wait( 2 );
		squirt delete();
		level notify ( "water_tank_explode_start" );
		
		sound_watertank = getent("origin_sound_watertank", "targetname");
		sound_watertank stoploopsound();
		sound_watertank playsound("whitesestate_tank_explosion");
		//iprintlnbold("SOUND: tank implosion");
		
		earthquake (0.7, 2.5, level.player.origin, 700, 10.0 );
		
		physicsExplosionSphere( sound_watertank.origin, 700, 300, 5.0 );
			
		//playfx (level._effect["water_gush"], ( -2226, -1100.5, -95.5 ) );
		clip trigger_off();
		door disconnectPaths();
		//door delete();
		wait( 3 );
		sound_watertank playsound("whitesestate_tank_explosion_b");
		//iprintlnbold("SOUND: glass implosion");
	
		level thread pip_trigger_00_func();
	}
}

//avulaj
//
greenhouse_water_tank_event()
{
	trigger = GetEnt( "greenhouse_water_tank_event", "targetname" );
	trigger waittill( "trigger" );
	level notify ( "water_tank_look_at" );
	level.water_tank++;
}

//avulaj
//once the variable level.greenhouse_thug increases to 2 or more three thugs will come in for back up
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
				thug[i] = greenhouse_thug[i] stalingradspawn("greenhouse_flanker");
				if( !maps\_utility::spawn_failed( thug[i]) )
				{
					thug[i] setperfectsense(true);
					thug[i].accuracy = 0.5;
					//thug[i] SetCombatRole( "basic" );
					thug[i] thread set_flanking_pos(i);
					thug[i] thread greenhouse_death_check();
				}
			}
			
			level thread check_greenhouse_flanker();
			level thread hint_flank();
			
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



//avulaj
//
//greenhouse_check_for_new_weapon()
//{
//	//self waittill ( "death" );
//	//wait( 2 );
//	tutorial_message("@WHITES_ESTATE_PICKUP_WEAPON");
//
//	org = spawn("script_origin",level.player.origin);
//	level.player playerlinktodelta ( org, undefined );
//	level.player waittill( "tutorialclosed" );
//	level.player unlink();
//}

//avulaj
// 
fountain_thug_01()
{
	level waittill ( "wave1_go" );
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_01" );
	}
}

//avulaj
// 
fountain_thug_02()
{
	level waittill ( "wave2_go" );
	if ( IsDefined ( self ))
	{
		self startpatrolroute( "ledge_point_02" );
	}
}

//avulaj
// 
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

//avulaj
// 
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

//avulaj
//
roof_birds_01_func()
{
	org = getent ( "roof_birds_01", "targetname" );
	trigger = getent ( "roof_trigger_birds_01", "targetname" );
	trigger waittill ( "trigger" );
	playfx ( level._effect["science_startled_birds"], org.origin );
	org playsound( "birds_taking_off" ); //this plays//birds flying off
}

//avulaj
//this will send out a notify when all 3 garden thugs are dead
garden_thugs_death_check()
{
	//trigger = GetEnt( "garden_teach_lock", "targetname" );
	self waittill ( "death"  );
	level.garden_death++;
	wait( .5 );
	if ( level.garden_death >= 2 )
	{
		level notify ( "garden_thugs_dead" );
		wait( 1 );
		//tutorial_message("@WHITES_ESTATE_OBJ_ICON");

		//org = spawn("script_origin",level.player.origin);
		//level.player playerlinktodelta ( org, undefined );
		//level.player waittill( "tutorialclosed" );

		//level.player unlink();

		tutorial_message("@WHITES_ESTATE_PICKUP_WEAPON");

		org = spawn("script_origin",level.player.origin);
		level.player playerlinktodelta ( org, undefined );
		level.player waittill( "tutorialclosed" );
		level.player unlink();
	
		level thread show_switch_weapon();

		//trigger trigger_on();

		level waittill ( "gate_hacked" );
		//level thread objectives_whites_estate();
		level thread objective_tracker();
	}
}

//avulaj
//
show_switch_weapon()
{
	level endon ( "give_up_on_weapon" );
	while( 1 )
	{
		wait( .1 );
		if( level.player HasWeapon( "1911" ) )
		{
			tutorial_message("@WHITES_ESTATE_CHANGE_WEAPON");

			org = spawn("script_origin",level.player.origin);
			level.player playerlinktodelta ( org, undefined );
			level.player waittill( "tutorialclosed" );
			level.player unlink();
			break;
		}
	}
}

//avulaj
//
garden_teach_lock_hack()
{
	//trigger = GetEnt( "garden_teach_lock", "targetname" );
	//trigger trigger_off();
	level waittill ( "garden_thugs_dead" );
	//trigger waittill ( "trigger" );

	tutorial_message("@WHITES_ESTATE_LOCKPICK");

	org = spawn("script_origin",level.player.origin);
	level.player playerlinktodelta ( org, undefined );
	level.player waittill( "tutorialclosed" );

	level.player unlink();
}

//avulaj
//
garden_thugs_func()
{
	level waittill ( "garden_thugs_attack" );

	//trigger = GetEnt( "garden_thug_trigger", "targetname" );
	//trigger waittill ( "trigger" );

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

//avulaj
//
garden_gates_open()
{
	door_node = Getnode( "boathouse_gate", "targetname" );
	door_node maps\_doors::open_door_from_door_node();

	level waittill ( "boathouse_gate_close" );
	door_node maps\_doors::close_door_from_door_node();
	
	level waittill ( "gate_hacked" );
}

//avulaj
//
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

//avulaj
//
boathouse_lookat()
{
	trigger = GetEnt( "boathouse_dock_fight_lookat", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "boathouse_lookat_triggered" );
}

//avulaj
//
boathouse_trigger()
{
	trigger = GetEnt( "boathouse_dock_fight_trigger", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "boathouse_lookat_triggered" );
}

//avulaj
//
/*boathouse_spawn_thug_01()
{
	level waittill ( "boathouse_lookat_triggered" );
	boathouse_thugs = getentarray ( "boathouse_thug_00", "targetname" );
	//level thread boathouse_flanker_func();

	for ( i = 0; i < boathouse_thugs.size; i++ )
	{
		thug[i] = boathouse_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] SetCombatRole( "basic" );
			thug[i] setalertstatemin( "alert_red" );
			//thug[i] SetEnableSense( false );
			//thug[i] thread boathouse_thug_check();
			//thug[i] thread boathouse_thug_spawn_check1();
			//thug[i] thread boathouse_thugs_run();
			//thug[i] thread boathouse_node_reached();
		}
	}
}*/

//avulaj
//
boathouse_node_reached()
{
	self waittill ( "goal" );
	self SetEnableSense( true );
}

//avulaj
//
boathouse_thug_spawn_check1()
{
	self waittill ( "death" );
	level.boathouse++;
}

//avulaj
//
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

//avulaj
//
boathouse_thug_check()
{
	self waittill ( "death" );
	level.boathouse_tracker++;
}

//avulaj
//QUICK_KILL
boathouse_flanker_func()
{
	while ( 1 )
	{
		wait( .1 );
		if ( level.boathouse_tracker >= 2 )
		{
			wait( 1 );

			//tutorial_message("@WHITES_ESTATE_QUICK_KILL");
			//org = spawn("script_origin",level.player.origin);
			//level.player playerlinktodelta ( org, undefined );
			//level.player waittill( "tutorialclosed" );
			//level.player unlink();

			flanker_thug = getent ("boathouse_thug_01", "targetname")  stalingradspawn( "flanker_thug" );
			flanker_thug waittill( "finished spawning" );
			flanker_thug LockAlertState( "alert_red" );
			flanker_thug SetEnableSense( false );
			//flanker_thug setpainenable( false );
			//flanker_thug.health = 1000000;
			//flanker_thug thread greenhouse_check_for_new_weapon();
			break;
		}
	}
}

//avulaj
//
ai_kicks_door()
{
	//blocker = GetEnt( "boathouse_blocker", "targetname" );
	sound_boathouse_door = GetEnt( "origin_sound_boathouse", "targetname" );
	
	//trigger = GetEnt( "door_kick_lookat_trigger", "targetname" );
	//trigger waittill ( "trigger" );
	
	//level notify ( "we_door_kick_start" );
	
	sound_boathouse_door playsound("whites_estate_boathouse_door");
	
	//blocker delete();
	
	if ( isdefined ( self ))
	{
		self  SetEnableSense( true );
		self setpainenable( true );
		self.health = 100;
		self setcombatrole ( "turret" );
	}
}

//avulaj
//
//prep_boat_float()
//{
//	yacht = GetEnt( "whites_yacht", "targetname" );
//	yacht thread boat_float();
//}

//avulaj
//
#using_animtree( "vehicles" );
boat_float()
{
	yacht = GetEnt( "whites_yacht", "targetname" );
	yacht UseAnimTree(#animtree);
	yacht setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}

//avulaj
//this will play a anim on the 1st boat in the boathouse
#using_animtree( "vehicles" );
boat_01_anim_play()
{
	self thread escape_boat_drone1();
	self thread spawn_boat_guard01();
	self UseAnimTree( #animtree );
	self animscripted( "boat_01_away", self.origin, self.angles, %v_boat_depart_1 );
	PlayFxOnTag( level._effect["speed_boat_wake"], self, "tag_body" );
}

//avulaj
//this will play a anim on the 2nd boat in the boathouse
#using_animtree( "vehicles" );
boat_02_anim_play()
{

	self thread escape_boat_drone2();
	self thread spawn_boat_guard02();
	//wait( 5 );
	self UseAnimTree( #animtree );
	self animscripted( "boat_02_away", self.origin, self.angles, %v_boat_depart_2 );
	PlayFxOnTag( level._effect["speed_boat_wake"], self, "tag_body" );
}

#using_animtree("fakeshooters");
escape_boat_drone1()
{
	// spawn model
	level.escape_boat_thug1 = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	level.escape_boat_thug1.angles = self.angles;
	level.escape_boat_thug1 character\character_thug_1_white::main();  // change this to call your character script
	level.escape_boat_thug1 LinkTo( self, "tag_driver", (0,0,-12), (0,0,0) );
	
	// play anims
	level.escape_boat_thug1 playsound("whites_estate_motor_boat_01");
	level.escape_boat_thug1 useAnimTree(#animtree);
	level.escape_boat_thug1 setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);
	
	wait(8.0);
	
	level.escape_boat_thug1 delete();
}

#using_animtree("fakeshooters");
escape_boat_drone2()
{
	// spawn model
	level.escape_boat_thug = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	level.escape_boat_thug.angles = self.angles;
	level.escape_boat_thug character\character_thug_1_white::main();  // change this to call your character script
	level.escape_boat_thug LinkTo( self, "tag_driver", (0,0,-12), (0,0,0) );
	
	// play anims
	level.escape_boat_thug playsound("whites_estate_motor_boat_02");
	level.escape_boat_thug useAnimTree(#animtree);
	level.escape_boat_thug setFlaggedAnimKnobRestart("idle", %Gen_Civs_GondolaRide);

	
	wait(8.0);
	
	level.escape_boat_thug delete();
}

//avulaj
//once the stealth kill is performed AI will walk through the small greenhouse
//start to attack.
greenhouse_fight()
{
	trigger = GetEnt( "greenhouse_thug_walk", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "stop_ammo" );
	level thread small_greenhouse_gauntlet();

	//iPrintLnBold( "THUG: Here he comes!" );
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
			//thug[i] thread greenhouse_last_man_standing();
			//thug[i] thread greenhouse_last_man_standing_think();
		}
	}
}

//avulaj
//
shooter_check_damage()
{
	trigger = GetEnt( "shooters_shoot", "targetname" );
	trigger waittill ( "trigger" );
	wait( 5 );
	self setignorethreat( level.player, false );
}

//avulaj
//
greenhouse_shooter_03()
{
	if ( IsDefined ( self ))
	{
		self SetCombatRole( "turret" );
	}
}

//avulaj
//
greenhouse_last_man_standing()
{
	self waittill ( "death" );
	level.last_man++;
}

//avulaj
//
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

//avulaj
//
greenhouse_turn_back()
{
	if ( IsDefined ( self ))
	{
		self SetEnableSense( true );
	}
}

//avulaj
//
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

//avulaj
//
basket_push_func()
{
	//trigger = GetEnt( "small_greenhouse_push_basket", "targetname" );
	org = GetEnt( "basket_push_org", "targetname" );
	//trigger waittill ( "trigger" );
	
	wait(0.3);
	
	physicsExplosionSphere( org.origin, 200, 100, .5 );
}

//avulaj
//this will clear out any ai
ai_delete_all()
{
	guys = getaiarray("axis", "neutral");
	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
}

//avulaj
//
cellar_trigger_fall_guy_fuc()
{
	//windowdoor1 = GetEnt( "windowdoor1", "targetname" );
	//windowdoor2 = GetEnt( "windowdoor2", "targetname" );
	node = getnode("node_balcony_cellar", "targetname");
	
	//windowdoor1 rotateyaw( 90, .2 );
	//windowdoor2 rotateyaw( -90, .2 );

	//windowdoor1 ConnectPaths();
	//windowdoor2 ConnectPaths();

	trigger = GetEnt( "cellar_trigger_fall_guy", "targetname" );
	trigger waittill ( "trigger" );

	level thread cellar_thug_hits_door_func();

	fall_guy = getent ( "cellar_fall_guy", "targetname" )  stalingradspawn( "fall_guy" );
	//fall_guy waittill( "finished spawning" );
	
	fall_guy LockAlertState( "alert_red" );
	fall_guy setpainenable( false );
	fall_guy allowedstances("stand");
	fall_guy thread ach_headshot();
	
	fall_guy setgoalnode(node, 0);

	fall_guy waittill ( "goal" );
	
	fall_guy setperfectsense(true);
	
	fall_guy.accuracy = 0.5;
	
	level thread check_fall_guy();
	
	for (i=0; i<2; i++)
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
	push = getent("origin_balcony_break", "targetname");
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
	
	physicsExplosionSphere( push.origin, 30, 30, 2 );
	
	wait(1.0);
	
	level notify ( "cellar_doors_start" );
	
	push delete();
}


shoot_at_01()
{
	if (isdefined(self))
		self cmdshootatpos((-364, -734, 111), false, 0.5);
}

shoot_at_02()
{
	if (isdefined(self))
		self cmdshootatpos((-596, -721, 88), false, 0.5);
}

shoot_at_03()
{
	if (isdefined(self))
		self cmdshootatpos((-596, -839, 88), false, 0.5);
}

shoot_at_04()
{
	if (isdefined(self))
		self cmdshootatpos((-364, -836, 111), false, 0.5);
}



//avulaj
//
cellar_thug_hits_door_func()
{
	//door_01 = GetEnt( "cellar1", "targetname" );
	//door_02 = GetEnt( "cellar2", "targetname" );
	cellar_sound = getent("cellar_door_sound", "targetname");
	
	cellar_temp_block = GetEnt( "cellar_temp_block", "targetname" );
	trigger = GetEnt( "cellar_thug_hits_door", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "cellar_doors_start" );
	
	cellar_sound playsound("whites_estate_body_impact_wood");
	
	//Start Cellar Music - crussom
	level notify("playmusicpackage_cellar");
	
	cellar_temp_block delete();
	//door_01 delete();
	//door_02 delete();
}

//avulaj
//this is the first set of ambushers in the cellar
//they spawn get set to red and run to cover nodes
cellar_thugs_spawn_01_func()
{
	trigger = GetEnt( "cellar_thugs_spawn", "targetname" );
	trigger waittill ( "trigger" );
	
	//windowdoor1 = GetEnt( "windowdoor1", "targetname" );
	//windowdoor2 = GetEnt( "windowdoor2", "targetname" );

	//windowdoor1 rotateyaw( -90, .2 );
	//windowdoor2 rotateyaw( 90, .2 );

	//windowdoor1 disconnectpaths();
	//windowdoor2 disconnectpaths();
	
	level thread close_balcony_window();

	//level thread cellar_thugs_spawn_02_func();
	//level thread cellar_push_glass();
	level thread cellar_ext();

	//cellar_thugs = getentarray ( "cellar_thugs_00", "targetname" );
	//cellar_thugs_a = getentarray ( "cellar_thugs_00a", "targetname" );

	/*for ( i = 0; i < cellar_thugs.size; i++ )
	{
		thug[i] = cellar_thugs[i] stalingradspawn("cellar_guards");
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] thread global_radio_chatter();
			//thug[i] LockAlertState( "alert_red" );
			//thug[i] thread cellar_thug_check();
		}
	}*/
	
	//for ( i = 0; i < cellar_thugs_a.size; i++ )
	//{
	//	thug_a[i] = cellar_thugs_a[i] stalingradspawn();
	//	if( !maps\_utility::spawn_failed( thug_a[i]) )
	//	{
	//		thug_a[i] thread global_radio_chatter();
	//		thug_a[i] LockAlertState( "alert_red" );
	//		thug_a[i] SetCombatRole( "rusher" );
	//		thug_a[i] thread cellar_thug_check();
	//	}
	//}
	//iPrintLnBold( "Get him now!" );
	//tutorial_message( "Switch sides by holding right or left on LS and press (A)." );
	//wait( 5 );
	//tutorial_message( "" );
}

//avulaj
//if 2 or more thugs are killed two more will spawn
cellar_thug_check()
{
	self waittill ( "death" );
	level.cellar_thug++;
}

//avulaj
//if this trigger is tripped it will set off a notify to spawn AI backup for the cellar
celler_thug_trigger_func()
{
	trigger = GetEnt( "cellar_thugs_spawn_02", "targetname" );
	trigger waittill ( "trigger" );
	level.cellar_thug = 1;
}

//avulaj
//this is the first set of ambushers in the cellar
//they spawn get set to red and run to cover nodes
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

//avulaj
//if the player jumps on the tasting table the wine glasses will be pushed
cellar_push_glass()
{
	trigger = GetEnt( "cellar_push_glass", "targetname" );
	trigger waittill ( "trigger" );
	physicsExplosionSphere( ( 388, -232, -153 ), 200, 100, 2 );
}

//avulaj
//
death_check_cellar()
{
	self waittill ( "death" );
}

//avulaj
//
cellar_ext()
{
	trigger = GetEnt( "cellar_ext_trigger", "targetname" );
	trigger waittill ( "trigger" );

	//nade_point = GetEnt( "nade_point_01", "targetname" );
	
	flag_set("entrance_found");

	//thug = getent ("nade_tosser", "targetname")  stalingradspawn( "thug" );
	//thug waittill( "finished spawning" );
	//thug LockAlertState( "alert_red" );
	//wait( .1 );

	//thug magicgrenade( thug.origin, nade_point.origin, 1.5 );
}

//this plays radio chatter on AI every 45 seconds to 1 min 30 seconds.
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

//avulaj
//this opens the door leading into the kitchen
//then when the player hacks the safe the door will close
estate_open_kitchen_door()
{
	door = GetEnt( "estate_door_blocker", "targetname" );
	door trigger_off();
}

//avulaj
//this saves the game when Bond enters the villa
villa_save_game_func()
{
	trigger = GetEnt( "villa_save_game", "targetname" );
	trigger waittill ( "trigger" );
	//tutorial_message( "Headset: Bond find the wall safe." );
	//wait( 2 );
	//tutorial_message( "" );
	
	
}

//avulaj
//
safe_room_save_func()
{
	trigger = GetEnt( "safe_room_save", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread vo_safe_room();
	
	level.safe_room_found = true;
	
	level thread villa_safe_wall();
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


//avulaj
//
setting_up_safe()
{
 	maps\_playerawareness::setupSingleUseOnly(
 			"safe_box",		// targetname
 			::hack_whites_safe,		// func
 			&"WHITES_ESTATE_OPEN_SAFE",	//	hint_string, 
 			undefined,  //use time
 			undefined,	//use text
 			false,		//single use?
 			true,		//require lookat
 			undefined,	//filter
 			level.awarenessMaterialMetal, //material
 			false,		//glow
 			false,		//shine
 			false );	//wait
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
	
	//control.lockparams = "complexity:2 speed:2 code:4";

	if( level.player.lockSuccess == true )
	{
		flag_set("safe_hacked");
		flag_set("safe_located");
		
		door = getent("safe_door", "targetname");
		door rotateyaw(120, 2.0);
		
		//level notify ( "safe_hacked" );
		//level thread villa_first_wave();
		//level thread villa_swap_cars_trigger_func();
		
		
		level notify ( "open_z_gates" );

		wait( 0.15 );
		entOrigin Delete();
		
		wait(1.5);
	}
	
	/*if( control maps\_unlock_mechanisms::unlock_electronic() )
	{
		control notify( "hacked" );
		control notify( "sound_done" );
		
		flag_set("safe_hacked");
		
		level thread villa_blow_car_early_func();
		level thread car_boom_func();
		level notify ( "open_z_gates" );
		
		wait( 0.15 );

		entOrigin Delete();
	}*/
	
	else
	{
		wait( 0.15 );
		entOrigin Delete();

		maps\_playerawareness::setupSingleUseOnly(
			"safe_box",		// targetname
			::hack_whites_safe,		// func
			&"WHITES_ESTATE_OPEN_SAFE",	//	hint_string, 
			undefined,  //use time
			undefined,	//use text
			false,		//single use?
			true,		//require lookat
			undefined,	//filter
			level.awarenessMaterialMetal, //material
			false,		//glow
			false,		//shine
			false );	//wait
	}
}

//avulaj
//
villa_bomb_prop_swap()
{
	//old_obj_01 = GetEnt( "arm_1", "targetname" ); 
	//new_obj_01 = GetEnt( "arm_damage_01", "targetname" );
	//new_obj_01 hide();
	//old_obj_02 = GetEnt( "desk_1", "targetname" ); 
	//old_obj_03 = GetEnt( "desk_2", "targetname" );
	arm_clip = GetEnt( "arm_damage_01_clip", "targetname" ); arm_clip trigger_off();
	
	level waittill ( "white_blows_estate" );
	//old_obj_01 hide();
	//new_obj_01 show();
	arm_clip trigger_on();
	//fire_clip = GetEnt( "fire_block_temp", "targetname" );
	//fire_clip trigger_on();
	//fire_clip2 = GetEnt( "fire_block_temp2", "targetname" );
	//fire_clip2 trigger_on();
	//fire_clip2 disconnectPaths();
	
	beam_before = getent("blowupbeam_01", "targetname");
	if (isdefined(beam_before))
	{
		beam_before delete();
	}
	
	beam_after = getent("blowupbeam_01_after", "targetname");
	beam_after trigger_on();
	beam_after show();

	level waittill ( "second_explosion" ); //desk_2
	//old_obj_02 hide(); 
	//old_obj_03 hide();
}

//avulaj
//
second_fish_tank()
{
	fish_tank_glass = GetEnt( "water_gusher", "targetname" );
	trigger = GetEnt( "fish_tank_hurt_trigger", "targetname" );
	trigger trigger_off();

	//level waittill ( "second_explosion" );
	//trigger trigger_on();

	//fire_origin = GetEntArray( "fire_origin_fish_tank", "targetname" );
	//for ( i = 0; i < fire_origin.size; i++ )
	//{
	//	playfxontag ( level._effect["large_fire"], fire_origin[i], "tag_origin" );
	//}

	//fish_tank_glass setcandamage( true );
	//fish_tank_glass thread fish_tank_backup();
	//fish_tank_glass waittill ( "damage" );


	//water_gush_01 = GetEntArray( "water_gush_01", "targetname" );
	//for ( i = 0; i < water_gush_01.size; i++ )
	//{
	//	fx = playfx (level._effect["water_gush"], water_gush_01[i].origin );
	//}

	//for ( i = 0; i < fire_origin.size; i++ )
	//{
	//	fire_origin[i] delete();
	//}

	//wait( 1.5 );
	//steam_origin = GetEntArray( "steam_origin_fish_tank", "targetname" );
	//for ( i = 0; i < steam_origin.size; i++ )
	//{
	//	playfxontag ( level._effect["water_steam"], steam_origin[i], "tag_origin" );
	//}
	//wait( 1.5 );
	//trigger trigger_off();
	//for ( i = 0; i < steam_origin.size; i++ )
	//{
	//	steam_origin[i] delete();
	//}
}

//avulaj
//
fish_tank_backup()
{
	wait( 10 );
	self dodamage( 100, self.origin );
}

//avulaj
//
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

//avulaj
//
villa_push_statue_func()
{
	trigger = GetEntArray( "villa_push_statue", "targetname" );
	for ( i = 0; i < trigger.size; i++ )
	{
		trigger[i] thread villa_trigger_push_func();
	}
}

//avulaj
//
villa_trigger_push_func()
{
	self waittill ( "trigger" );
	org = spawn("script_origin",level.player.origin);
	physicsExplosionSphere( org.origin, 200, 100, 5 );
}

//avulaj
//
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

//avulaj
//fire_trigger_02
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

	//car_hurt_trigger = GetEnt( "car_hurt_trigger", "targetname" );
	//car_hurt_trigger2 = GetEnt( "car_hurt_trigger2", "targetname" );
	//car_hurt_trigger trigger_off();
	//car_hurt_trigger2 trigger_off();

	//trigger5 = GetEnt( "fire_trigger_05", "targetname" );
	//trigger5 trigger_off();
	//level waittill ( "get_white" );
	//trigger5 thread fire_position_05();
	level thread fire_05_obj();
}

//avulaj
//
fire_position_01()
{
	fire_origin = GetEntArray( "fire_origin_01", "targetname" );
	//fire_origin_push = GetEntArray( "fire_origin_01_push", "targetname" );

	for ( i = 0; i< fire_origin.size; i++ )
	{
		fire_origin[i] thread villa_play_fire_01();
	}
	
	//for ( i = 0; i< fire_origin_push.size; i++ )
	//{
	//	fire_origin_push[i] thread villa_trigger_knockback( self );
	//}

	level waittill ( "white_blows_estate" );
	self trigger_on();
	
	level thread fire_01_sound();
}

//avulaj
//
villa_trigger_knockback( trigger )
{
	level.player endon ( "death" );
	while ( 1 )
	{
		trigger waittill ( "trigger" );
		//level.player knockback( 3000, self.origin + ( 0, 40, 0 ), self );
		//level.player dodamage( 15, level.player.origin );
		//earthquake ( .1, 2, level.player.origin, 100 );
	}
}

//avulaj
//don't use fires 8, 10, 42, 
villa_play_fire_01()
{
	level waittill ( "white_blows_estate" );

	fx = playfx (level._effect["large_boom"], self.origin );
	//earthquake ( .1, 2, level.player.origin, 100 );
	//physicsExplosionSphere( self.origin, 140, 100, 8 );
	//radiusdamage( self.origin, 50, 50, 25 );

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

	//fx = playfx (level._effect["large_fire"], self.origin );
}

//avulaj
//don't use fires 8, 10, 42, 
fire_position_02()
{
	trigger = GetEnt( "trigger_second_explosion", "targetname" );
	trigger waittill ( "trigger" );
	
	if (!level.floor_gone)
	{
		level thread blow_up_floor();
		
		push = getent("origin_knockover_01", "targetname");
		exp = getent("origin_explosion_desk", "targetname");
		
		radiusdamage(exp.origin, 120, 120, 120 );
	
		wait(0.1);
	
		level.player knockback(2000, push.origin + (0, 0, 0));
		//level.player shellshock("default", 2.0);
		
		wait(0.5);
		
		push delete();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Look at trigger to blow up floor
///////////////////////////////////////////////////////////////////////////////////////
trigger_floor_collapse()
{
	//trigger = getent( "trigger_lookat_floorfall", "targetname" );
	//trigger waittill ( "trigger" );
	
	flag_wait("blowup_floor");
	
	if (!level.floor_gone)
	{
		level thread blow_up_floor();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Blow up third floor
///////////////////////////////////////////////////////////////////////////////////////
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
	
	earthquake (0.7, 1.3, level.player.origin, 700, 10.0 );
	
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




//avulaj
//
fire_position_03()
{
	trigger = GetEnt( "trigger_third_explosion_setup", "targetname" );
	trigger waittill ( "trigger" );

	level thread fire_03_explosions();
	
	railing2_after = getent("railing_f2_l_after", "targetname");
	railing2_after show();
	
	railing2 = getent("railing_f2_l", "targetname");
	railing2 delete();
	
	//fire_node = GetEntArray( "fire_origin_03", "targetname" );

	//for ( i = 0; i< fire_node.size; i++ )
	//{
	//	fire_node[i] thread villa_play_fire_01();
	//}

	level notify ( "white_blows_estate" );
	level notify ( "third_explosion" );
	
	level notify ( "fires_13" ); 
	level notify ( "fires_14" ); 
	level notify ( "fires_25" ); 
	level notify ( "fires_26" ); 
	//level notify ( "fires_27" );
	//level notify ( "fires_28" ); 
	//level notify ( "fires_29" ); 
	//level notify ( "fires_30" );
	
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
	
	
	self trigger_on();
	
	level thread fire_03_sound();
}


fire_03_explosions()
{
	fire_node = GetEntArray( "fire_origin_03", "targetname" );
	
	fire_node[0] playsound("whites_estate_house_generic_explosion");
	
	physicsExplosionSphere( fire_node[0].origin, 140, 100, 15 );
	
	earthquake (0.7, 1.2, level.player.origin, 700, 10.0 );
	
	level thread statue_fall_above();

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
		wait(1.0);
	}
}

//avulaj
//
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
	
	playfx (level._effect["large_fire"], ( 548, -434, 24 ) );
	self trigger_on();
	
	explosion = getent("origin_piano_explosion", "targetname");
	explosion playsound("whites_estate_house_piano_explosion");
	
	earthquake (0.7, 1.3, level.player.origin, 700, 15.0 );
	
	level thread fire_04_sound();
	
	level thread ceiling_explosion();
	
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
	
	floor_preatrium = getent("floor_preatrium", "targetname");
	floor_preatrium delete();
}


//avulaj
//
fire_position_05()
{
	trigger = GetEnt( "trigger_fifth_explosion", "targetname" );
	trigger waittill ( "trigger" );
	
	if ( level.ps3 )
	{
		aston = getent("bond_aston", "targetname");
		aston show();
	}

	fire_node = GetEntArray( "fire_origin_05", "targetname" );

	for ( i = 0; i< fire_node.size; i++ )
	{
		fire_node[i] thread villa_play_fire_01();
	}

	level notify ( "white_blows_estate" );
	level notify ( "fifth_explosion" );
	level notify ("fx_outro_smoke");
	
	self trigger_on();
	
	level thread fire_05_sound();
	level thread after_explosion();
	
	bar = getent("origin_bar_explosion", "targetname");
	
	radiusdamage((331, -427, 65), 120, 200, 200 );
	
	physicsExplosionSphere((331, -427, 65), 100, 80, 5 );
	
	wait(1.0);
	
	level thread ambient_explosion();
}

//avulaj
//
fire_05_obj()
{
	//door_r = GetEnt( "int_door_atrium_r", "targetname" );
	//door_l = GetEnt( "int_door_atrium_l", "targetname" );
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
	//door_r delete();
	//door_l delete();
}

//avulaj
//
villa_play_fire_obj()
{
	fx = playfx (level._effect["fire_ball"], self.origin );
	playfx (level._effect["fire_ball"], self.origin );
	//physicsExplosionSphere( self.origin, 200, 100, 5 );
}

//avulaj
//move shelf 56 units
//move large 76
//moce small 148
villa_safe_wall()
{
	dresser = GetEnt( "shelf_move", "targetname" );
	clip = GetEnt( "shelf_hidden_room_clip", "targetname" );
	//shelf_clip = GetEnt( "clip_move_with_shelf", "targetname" );
	//small_wall = GetEnt( "wallsafe1", "targetname" );
	//large_wall = GetEnt( "wallsafe2", "targetname" );
	//level waittill ( "safe_hacked" );
	
	flag_wait("safe_hacked");
	
	//level thread villa_computer_hack_func();
	//level thread villa_first_wave();
	//level thread villa_swap_cars_trigger_func();

	dresser movex(-24, 3.5);
	dresser playsound("whites_estate_secret_wooddoor_part1");
	
	wait (5.0);
	
	dresser movey ( 56, 5.0 );
	dresser playsound("whites_estate_secret_wooddoor");
	
	//shelf_clip movey ( 56, 5.0 );
	clip movey ( 56, .1 );

	//large_wall movez ( -134, 5.0 );
	//small_wall movez ( -134, 5.0 );
	//large_wall waittill ( "movedone" );
	//large_wall delete();
	//play sound of wall moving
}

//avulaj
//this will kick off the estate blowing up
//blown out wall in estate server room
//blowoutwall1
//blown out windows in server room
//window1
//window2
villa_computer_hack_func()
{
	trigger = GetEnt( "villa_computer_hack", "targetname" );
	trigger waittill ( "trigger" );
	trigger trigger_off();
	
	level.player FreezeControls( true );
	
	level thread close_bookcase();
	
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	level thread letterbox_on(false, false);
	
	playcutscene("WE_Detonate", "WE_Detonate_Done");
	
	level thread spawn_balcony_outside();

	//flag_set("house_explodes");

	//camera shot of white blowing shit up
	
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
	//level thread maps\whites_estate_pip::split_screen();
	
	flag_wait("explosion_done");
	
	level.player customCamera_pop( cameraID_white_boom, 0.0 );
	level.player customcamera_checkcollisions( 1 );
	
	letterbox_off();

	level notify ( "white_blows_estate" );
	//level.player PlayerAnimScriptEvent("");
		
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



//avulaj
//
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
	//playfx (level._effect["house_explosion"], tower_top.origin+(120, 0, 0));
	//playfx (level._effect["house_explosion"], tower_top.origin+(-120, 0, 0));
	//playfx (level._effect["house_explosion"], tower_top.origin+(0, 120, 0));
	//playfx (level._effect["house_explosion"], tower_top.origin+(0, -120, 0));
	
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
	
	physicsExplosionSphere((1073, 173, 604), 200, 200, 20 );
	//physicsExplosionSphere(tower_small.origin, 200, 200, 15 );
	
	wait(0.1);
	
	playfx (level._effect["house_explosion"], tower_small.origin);
	
	earthquake (0.7, 1.8, level.player.origin, 200, 10.0 );
	
	for (i=0; i<roof_corner.size; i++)
	{
		roof_corner[i] delete();
	}
	
	level.player playsound("whites_estate_house_exterior_explosion");
	
	wait(1.5);
	
	earthquake (0.7, 1.8, level.player.origin, 200, 10.0 );
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



//avulaj
//
villa_blow_wall()
{
	wall = GetEnt( "blowoutwall1", "targetname" );
	
	//level waittill ( "white_blows_estate" );
	//wait( .5 );

	//level.player playsound("whites_estate_house_hack_explosion");

	//earthquake (0.8, 1.1, level.player.origin, 700, 15.0 );

	//fx = playfx (level._effect["estate_car_explosion"], ( 504, -384, 432 ) );
	//physicsExplosionSphere( ( 504, -384, 432 ), 200, 100, 5 );
	//radiusdamage( ( 504, -384, 432 ), 60, 20, 40 );
	wall delete();
}


//avulaj
//
villa_fish_tank_func()
{
	trigger = GetEnt( "fish_tank_spawn_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	SetDVar("sm_sunShadowEnable", 1);

	//node = getnode("node_cover_dining", "targetname");

	//level thread fish_tank_break();
	level thread shootout_kitchen_01();
	level thread shootout_kitchen_02();
	//level thread destroy_kitchen_shelf01();
	//level thread destroy_kitchen_shelf02();

	thugs1 = getent ("fish_tank_thugs1", "targetname")  ;
	thugs1 stalingradspawn( "fish_thugs1" );
	
	thugs2 = getent ("fish_tank_thugs2", "targetname")  ;
	thugs2 stalingradspawn( "fish_thugs2" );
	
	fish1 = getent("fish_thugs1", "targetname");
	fish2 = getent("fish_thugs2", "targetname");
	
	fish1.accuracy = 0.5;
	fish1 setperfectsense(true);
	
	fish2.accuracy = 0.5;
	fish2 setperfectsense(true);
	
	wait(0.5);
	
	//if (isdefined(fish2))
	//{
	//	fish2 setgoalnode(node, 1);
	//}
}

//avulaj
//
fish_tank_break()
{
	physic_org = GetEnt( "fish_tank_push", "targetname" );
	trigger = GetEnt( "villa_fish_tank", "targetname" );
	trigger waittill ( "trigger" );

	physicsExplosionSphere( physic_org.origin, 200, 100, 5 );
}

//avulaj
//this will open the front gates when the cars come driving up
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

//avulaj
//
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

//avulaj
//
villa_swap_cars_trigger_func()
{
	level waittill ( "white_blows_estate" );
	level notify ( "unhide_car_00" );
}

//avulaj
//
villa_first_wave()
{
	trigger = GetEnt( "trigger_villa_wave_01", "targetname" );
	trigger waittill ( "trigger" );
	
	//villa_rusher = getent ("villa_wave_01_rusher", "targetname")  stalingradspawn( "villa_rusher" );
	//villa_rusher waittill( "finished spawning" );
	//villa_rusher SetCombatRole( "rusher" );
	//villa_rusher LockAlertState( "alert_red" );
	//villa_rusher thread check_villa_death_01();

	/*villa_thugs = getentarray ( "villa_wave_01", "targetname" );

	for ( i = 0; i < villa_thugs.size; i++ )
	{
		//iPrintLnBold( "spawn number " +i + " of " + villa_thugs.size );
		thug[i] = villa_thugs[i] stalingradspawn("first_guard");
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			//thug[i] thread check_villa_death_01();
			thug[i].accuracy = .5;
		}
	}*/
	
	level thread first_house_guards();
	level thread explosion_second_floor();
	level thread ceiling_tiles();
	
	flag_set("destroy_computer_room");
	
	level notify("ceiling_beams_start");
	
	level.player playsound("whites_estate_house_generic_explosion");
	
	earthquake (0.7, 1.6, level.player.origin, 700, 12.0 );
}

//avulaj
//
check_villa_death_01()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
	if (( level.thug_death_tracker >= 0 ) && ( level.second_wave > 0 ))  //originally 4
	{
		level thread villa_lookat_trigger_door();
	}
}

//avulaj
//
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

//avulaj
//
villa_lookat_trigger_door()
{
	trigger = GetEnt( "villa_wave_02_lookat_trigger", "targetname" );
	trigger waittill ( "trigger" );

	level notify ( "2nd_wave" );
}

//avulaj
//
villa_backup_trigger_door()
{
	trigger = GetEnt( "villa_wave_02_backup_trigger", "targetname" );
	trigger trigger_off();

	level waittill ( "white_blows_estate" );
	trigger trigger_on();

	trigger waittill ( "trigger" );

	level notify ( "2nd_wave" );
}

//avulaj
//this triggers the front door to open sothe thugs can rush the forye
front_door_temp_open_func()
{
	trigger = GetEnt( "front_door_temp_open", "targetname" );
	trigger waittill ( "trigger" );
	//door = GetEnt( "front_door_temp", "targetname" );
	//door movez( -5000, 0.1 );
	//door ConnectPaths();
	//wait( .1 );
	
	//door_l = getent("door_front_l", "targetname");
	//door_r = getent("door_front_r", "targetname");
	
	wait(1.0);
	
	//door_l movez( -5000, 0.1 );
	//door_r movez( -5000, 0.1 );
	
	//door_l rotateyaw(120, 1.0);
	//door_r rotateyaw(-120, 1.0);
	
	//door_l ConnectPaths();
	//door_r ConnectPaths();
	
	level notify("front_door_start");
	
	front_door = getent("collision_front_door", "targetname");
	front_door trigger_off();
	front_door connectpaths();
	
	door_breach = getent("origin_door_breach", "targetname");
	playfx (level._effect["conc_grenade"], door_breach.origin);
	
	door_breach playsound("whites_estate_house_car_explosion");
	physicsExplosionSphere( door_breach.origin, 200, 200, 1 );
	
	earthquake (0.3, 0.5, level.player.origin, 700, 5.0 );
	
	level thread statue_fall_below();
	
	wait(1.0);
	
	level thread front_door_assault();
	
	door_breach delete();
}

//avulaj
//
villa_second_wave()
{
	level waittill ( "2nd_wave" );

	villa_thugs = getentarray ( "villa_wave_02", "targetname" );
	thugs = getentarray ( "villa_wave_02a", "targetname" );

	/*for ( i = 0; i < villa_thugs.size; i++ )
	{
		thug[i] = villa_thugs[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			thug[i] thread check_villa_death_02();
		}
	}*/
	
	for (i=0; i<thugs.size; i++)
	{
		guard[i] = thugs[i] stalingradspawn("guard_rusher");
		guard[i] setperfectsense(true);
		guard[i] lockaispeed("walk");
	}
}

//avulaj
//
check_villa_death_02()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
	if ( level.thug_death_tracker >= 6 )
	{
		level notify ( "3rd_wave" );
	}
}

//avulaj
//
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
			thug[i].accuracy = .5;
		}
	}
}

//avulaj
//
check_villa_death_03()
{
	self waittill ( "death" );
	level.thug_death_tracker++;
}

//avulaj
//
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

//avulaj
//
villa_car_1and2_drive_up()
{
	level waittill ( "safe_hacked" );

	//wait( 1.5 );

	//this car parks left of the conservatory
	vehicle1 = GetEnt( "car_01", "targetname" );
	car_path_01 = getvehiclenode("car_path_01", "targetname");
	vehicle1 attachpath( car_path_01 );
	vehicle1 startpath( car_path_01 );
	vehicle1 setspeed(35, 35, 35);

	//this car parks right of the front door
	vehicle2 = GetEnt( "car_02", "targetname" );
	car_path_02 = getvehiclenode("car_path_02", "targetname");
	vehicle2 attachpath( car_path_02 );
	vehicle2 startpath( car_path_02 );
	vehicle2 setspeed(35, 35, 35);

	//this car parks right of the conservatory
	vehicle3 = GetEnt( "car_03", "targetname" );
	car_path_03 = getvehiclenode("car_path_03", "targetname");
	vehicle3 attachpath( car_path_03 );
	vehicle3 startpath( car_path_03 );
	vehicle3 setspeed(35, 35, 35);

	//this car parks in front of the front door of the estate
	vehicle = GetEnt( "car_04", "targetname" );
	car_path_04 = getvehiclenode("car_path_04", "targetname");
	vehicle attachpath( car_path_04 );
	vehicle startpath( car_path_04 );
	vehicle setspeed(35, 35, 35);
}

//avulaj
//this will make the pip appear after the green house fight
pip_trigger_00_func()
{
	//org = GetEnt( "pip_look_at_00", "targetname" );
	//maps\_utility::holster_weapons();
	//level thread white_crawls_away();

	//cameraID_white = level.player SecurityCustomCamera_Push("entity_abs", org, org, ( 45.0, 0.0, 0.0), (0.0, 45.0, 0.0), (0.0, 0.0, 0.0), 0.0);

	//SetDVar("r_pipSecondaryMode", 5);
	//level.player animatepip( 500, 0, 0, 0, 0.73, 0.73, 1.0, 1.0 );
	//setdvar("cg_pipsecondary_border", 4);
	//setdvar("cg_pipsecondary_border_color", "0.0 0.0 0.0 1.0");
	//wait( 8 );
	//level.player animatepip( 500, 0, 0, 0, 0.0, 0.0, 1.0, 1.0 );
	//wait( .5 );
	//SetDVar("r_pipSecondaryMode", 0);

	//maps\_utility::unholster_weapons();
	//wait( .5 );
}

//avulaj
//this handles mr whie crawling away in a pip
white_crawls_away()
{
	white = getent ("mr_white_gimp", "targetname")  stalingradspawn( "white" );
	white waittill( "finished spawning" );
	white LockAlertState( "alert_green" );
	white.DropWeapon = false;
	white gun_remove();
	white startpatrolroute( "white_goto" );
}

//avulaj
//any AI sent to this will be deleted
thug_delete_func()
{
	if ( IsDefined ( self ))
	{
		self delete();
	}
}

//avulaj
//this will appear after the safe has been cracked and if the player doesn't look out at the window
pip_trigger_01_func()
{
	trigger = GetEnt( "pip_trigger_01", "targetname" );
	trigger trigger_off();
	level waittill ( "safe_hacked" );
	trigger trigger_on();
	trigger waittill ( "trigger" );
	level.kill_pip++;
}

//avulaj
//this will handle closing the door to the cellar
//after the door closes the Fake AI and the blulet effect will be set up
cellar_door_close_func()
{
	trigger = GetEnt( "cellar_door_close", "targetname" );
	guard_vo_var = GetEnt("sound_cellar_dialog", "targetname"); 
	
	trigger waittill ( "trigger" );
		
	flag_set("house_entered");
	
	level thread house_lights_on();
}

//avulaj
//
conservatory_trigger_fight()
{
	level waittill ( "fifth_explosion" );
	//wait( 1 );
	//trigger = GetEnt( "conserv_start_fightH", "targetname" );
	con_glass = GetEnt( "con_glass", "script_noteworthy" );
	//trigger waittill ( "trigger" );

	//level thread conservatory_trigger_fail();
	level thread atrium_glass_break();

	hilo_guards = getentarray ( "hilo_guards", "targetname" );
	node = getnodearray("node_cover_exit", "targetname");
	guard = getentarray("atrium_guards", "targetname");

	for ( i = 0; i < hilo_guards.size; i++ )
	{
		thug[i] = hilo_guards[i] stalingradspawn("atrium_guards");
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] LockAlertState( "alert_red" );
			//thug[i] SetCombatRole( "turret" );
			//thug[i] setgoalnode(node[i], 1);
		}
	}
	
	right = getnode("node_conserv_right", "targetname");
	left = getnode("node_conserv_left", "targetname");
	
	elite = getentarray("atrium_guards", "targetname");
	
	flag_wait("go_elites");
	
	radiusdamage ((1491, -430, 37), 160, 200, 200 );
	radiusdamage ((1491, -430, 100), 160, 200, 200 );
	
	level notify ( "board_break_start" );
	
	if (isdefined(elite[0]))
	{
		elite[0] setgoalnode(node[0], 1);
	}
	
	wait(1.5);
	
	if (isdefined(elite[1]))
	{
		elite[1] setgoalnode(node[1], 1);
	}
	
	wait(2.0);
	
	if (isdefined(elite[0]))
	{
		elite[0] setgoalnode(right, 1);
	}
	
	wait(1.5);
	
	if (isdefined(elite[1]))
	{
		elite[1] setgoalnode(left, 1);
	}	
	
	//con_glass waittill ( "death" );
}



//avulaj
//if the player tires to go wondering he/she will fail the mission
conservatory_trigger_fail()
{
	trigger = GetEnt( "white_gets_away_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	//iPrintLnBold( "M: You let Mr. White get away. Nice job Bond." );
	wait( 1.5 );
	missionfailedwrapper();
}

//avulaj
//
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
			//thug[i] thread hilo_thug_death();
			thug[i] thread hilo_thug_watch_white_stopped();
		}
	}

	for ( i = 0; i < mr_white.size; i++ )
	{
		white[i] = mr_white[i] StalingradSpawn("mrwhite");
		if ( !maps\_utility::spawn_failed( white[i] ) )
		{
			white[i] gun_remove();
			white[i].health = 10000;
			white[i] SetEnableSense( false );
			//white[i].team = "allies";
			white[i] setpainenable( false );
			//setdvar("friendlyfire_enabled", "0");
			//white[i] thread magic_bullet_shield();
			//white[i] thread hilo_white_death();
			white[i] thread chopper_sit();
			white[i] thread check_white();
		}
	}
}

//avulaj
//
hilo_thug_death()
{
	self waittill ( "death" );
	level.player FreezeControls( true );
	
	flag_set("white_stopped");
	
	wait(2.0);
	
	cinematicingame( "Open_Credits" );

	if ( level.white_shot == 0 )
	{
		changelevel( "siena" );
	}
}

// kpatel
hilo_thug_watch_white_stopped()
{
	self endon( "death" );
	flag_wait("white_stopped");
	wait( 0.1 );
	self delete();
}

//avulaj
//
hilo_white_death()
{
	self waittill ( "death" );
	level.white_shot++;
	tutorial_message( "M: You killed Mr. White. Nice job Bond." );
	wait( 2 );
	tutorial_message( "" );
	missionfailedwrapper();
}

//avulaj
//
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


//**************************************************************************
//**************************************************************************

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


//**************************************************************************
//**************************************************************************

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
			//Make sure we respect the minimal tether Radius
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

//**************************************************************************
//**************************************************************************

///////////////////////////////////////////////////////////////////////////////////////
//	House setup
///////////////////////////////////////////////////////////////////////////////////////
house_setup()
{
	if ( level.ps3 )
	{
		aston = getent("bond_aston", "targetname");
		aston hide();
		
		aboat = getent("boat_a", "targetname");
		aboat hide();
		
		bboat = getent("boat_b", "targetname");
		bboat hide();
		
		cboat = getent("boat_c", "targetname");
		cboat hide();
		
		dboat = getent("boat_d", "targetname");
		dboat hide();
		
		eboat = getent("boat_e", "targetname");
		eboat hide();
		
		fboat = getent("boat_f", "targetname");
		fboat hide();
	}

	wood = getentarray("floatingwood", "targetname");
	for (i=0; i<wood.size; i++)
	{
		wood[i] trigger_off();
	}
	
	//**************************************************************************

	clip_dock_fire = getent("clip_dock_fire", "targetname");
	clip_dock_fire trigger_off();
	
	//**************************************************************************

	boat_a = getent("boat_dest_a", "targetname");
	boat_a hide();
	
	boat_b = getent("boat_dest_b", "targetname");
	boat_b hide();
	
	//**************************************************************************

	cover_winemid01 = getent("cover_winemid_01", "targetname");
	cover_winemid01 trigger_off();
	
	cover_winemid02 = getent("cover_winemid_02", "targetname");
	cover_winemid02 trigger_off();
	
	cover_winemid03 = getent("cover_winemid_03", "targetname");
	cover_winemid03 trigger_off();
	
	cover_winemid04 = getent("cover_winemid_04", "targetname");
	cover_winemid04 trigger_off();
		
	//**************************************************************************

	clip_server = getentarray("clip_server_destroyed", "targetname");
	for (i=0; i<clip_server.size; i++)
	{
		clip_server[i] trigger_off();
	}
	
	//**************************************************************************

	boathouse_door_coll = getent("boathouse_clip", "targetname");
	boathouse_door_coll trigger_off();
	
	//**************************************************************************

	dock_trigger = getent("trigger_hurt_dock", "targetname");
	dock_trigger trigger_off();
	
	dockill_trigger = getent("trigger_kill_dock", "targetname");
	dockill_trigger trigger_off();

	//**************************************************************************

	front_trigger = getent("front_door_temp_open", "targetname");
	front_trigger trigger_off();
	
	//**************************************************************************
	
	phys_triggers = getentarray("trigger_physics", "targetname");
	for (i=0; i<phys_triggers.size; i++)
	{
		phys_triggers[i] trigger_off();
	}

	//**************************************************************************

	coll_main_stairs = getent("collision_main_stairs", "targetname");
	coll_main_stairs trigger_off();

	//**************************************************************************

	railing1_after = getent("railing_f2_after", "targetname");
	railing1_after hide();
	
	railing2_after = getent("railing_f2_l_after", "targetname");
	railing2_after hide();
	
	piano_after = getent("piano_after", "targetname");
	piano_after hide();

	//**************************************************************************

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
	
	fire_door = getentarray("collision_fire_door", "targetname");
	for (i=0; i<fire_door.size; i++)
	{
		fire_door[i] trigger_off();
	}
	
	//**************************************************************************

	coll_third_floor = getent("collision_third_floor", "targetname");
	coll_third_floor trigger_off();
	
	//**************************************************************************

	triggerhurt_server = getentarray("trigger_hurt_server", "targetname");
	for (i=0; i<triggerhurt_server.size; i++)
	{
		triggerhurt_server[i] trigger_off();
	}

	//**************************************************************************

	stairs_main = getent("stairs_main_after", "targetname");
	stairs_main hide();

	//**************************************************************************

	coll_small_greenhouse = getent("collision_small_greenhouse", "targetname");
	coll_small_greenhouse trigger_off();

	//**************************************************************************
	
	//door_l = getent("door_front_l", "targetname");
	//door_r = getent("door_front_r", "targetname");

	//door_l delete();
	//door_r delete();
	
	//**************************************************************************

	//dresser = GetEnt( "shelf_move", "targetname" );
	
	//dresser movex(-24, 0.1);
		
	//wait (0.2);
	
	//dresser movey ( 56, 0.1 );
	
	//**************************************************************************
	
	holeafter = getent("blowupceiling_after", "targetname");
	holeafter hide();
	
	floor_preatrium_after = getent("floor_preatrium_after", "targetname");
	floor_preatrium_after hide();
	
	planter_after = getentarray("planter_after", "targetname");
	for (i=0; i<planter_after.size; i++)
	{
		planter_after[i] hide();
	}
	
	//**************************************************************************
	
	heli1 = getent("heli_house", "targetname");
	heli2 = getent("heli_greenhouse", "targetname");
	
	heli1 hide();
	heli1 trigger_off();
	heli2 hide();
	heli2 trigger_off();
	
	coll_winemid_01 = getent("coll_winemid_01", "targetname");
	coll_winemid_01 trigger_off();
	
	coll_winemid_02 = getent("coll_winemid_02", "targetname");
	coll_winemid_02 trigger_off();
	
	coll_winemid_03 = getent("coll_winemid_03", "targetname");
	coll_winemid_03 trigger_off();
	
	coll_winemid_04 = getent("coll_winemid_04", "targetname");
	coll_winemid_04 trigger_off();
	
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
	
	//floor_mezz = getent("blowupfloor_mezz_after", "targetname");
	//floor_mezz trigger_off();
	//floor_mezz hide();
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	House lights off
///////////////////////////////////////////////////////////////////////////////////////
house_lights_off()
{
	light01 = getent("house_light01", "targetname");
	light02 = getent("house_light02", "targetname");
	light03 = getent("house_light03", "targetname");
	light04 = getent("house_light04", "targetname");
	light05 = getent("house_light05", "targetname");
	light06 = getent("house_light06", "targetname");
	//light07 = getent("house_light07", "targetname");
	light08 = getent("house_light08", "targetname");
	light09 = getent("house_light09", "targetname");
	light10 = getent("house_light10", "targetname");
	
	light01 setlightintensity(0.0);
	light02 setlightintensity(0.0);
	light03 setlightintensity(0.0);
	light04 setlightintensity(0.0);
	light05 setlightintensity(0.0);
	light06 setlightintensity(0.0);
	//light07 setlightintensity(0.0);
	light08 setlightintensity(0.0);
	light09 setlightintensity(0.0);
	light10 setlightintensity(0.0);
}



///////////////////////////////////////////////////////////////////////////////////////
//	House lights on
///////////////////////////////////////////////////////////////////////////////////////
house_lights_on()
{
	light01 = getent("house_light01", "targetname");
	light02 = getent("house_light02", "targetname");
	light03 = getent("house_light03", "targetname");
	light04 = getent("house_light04", "targetname");
	light05 = getent("house_light05", "targetname");
	light06 = getent("house_light06", "targetname");
	//light07 = getent("house_light07", "targetname");
	light08 = getent("house_light08", "targetname");
	light09 = getent("house_light09", "targetname");
	light10 = getent("house_light10", "targetname");
	
	light01 setlightintensity(2.0);
	light02 setlightintensity(2.5);
	light03 setlightintensity(2.0);
	light04 setlightintensity(2.0);
	light05 setlightintensity(2.0);
	light06 setlightintensity(2.0);
	//light07 setlightintensity(2.0);
	light08 setlightintensity(2.0);
	light09 setlightintensity(2.0);
	light10 setlightintensity(2.0);
}


///////////////////////////////////////////////////////////////////////////////////////
//	Bond setup
///////////////////////////////////////////////////////////////////////////////////////
setup_bond()
{
	holster_weapons();
	
	level thread camera_intro();
	
	wait(0.05);
	
	//level.player playerSetForceCover(true);
	
	//setSavedDvar("cg_disableBackButton","1");
	
	level thread spawn_intro_balcony();
	level thread spawn_intro_guard01();
	//level thread spawn_intro_guard02();
	level thread spawn_intro_guard03();
	level thread spawn_intro_guard04();
	
	guy = getent("thug_stairs", "targetname");
	node = getnode("node_anim_start", "targetname");
	end = getnode("node_anim_stop", "targetname");
	combat = getnode("node_garden_alert04", "targetname");
	
	//guy setenablesense(false);
	//guy setgoalnode(node, 0);
	
	//guy waittill("goal");
	
	playcutscene("WE_END", "Intro_Done");
	
	level waittill("Intro_Done");
	
	if (isdefined(guy))
	{
		guy setgoalnode(end, 0);
	}
	
	//guy setenablesense(true);
	
	flag_wait("garden_alert");
	
	if (isdefined(guy))
	{
		guy setgoalnode(combat, 1);
	}
	
	level thread check_retreat();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Camera intro
///////////////////////////////////////////////////////////////////////////////////////
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
	
	wait(4.5);
	
	level.player customCamera_change( cameraID_01, "world", (-1619.49, 1016.22, -4.0), (3.24, -157.97, 0), 8.0, 0.5, 1.0);
		
	//flag_wait("rundown_reached");
	
	wait(3.0);
	
	SetDVar("sm_SunSampleSizeNear", 0.25);
	
	wait(6.0);
	
	level thread close_gates();
	level thread alert_garden();
	level thread vo_garden_start();
	
	level.player customCamera_pop( cameraID_01, 2.0 );
	
	letterbox_off(false);
	
	//level.player playerSetForceCover(false, false);
	
	wait(1.0);
	
	unholster_weapons();
	
	level thread objectives_whites_estate();
	
	if ( !level.ps3 )
	{
		level thread boat_d_sail();
		level thread boat_e_sail();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Chopper effects during intro
///////////////////////////////////////////////////////////////////////////////////////
chopper_effects()
{
	tag = getent("tag_heli_efx", "targetname");
	heli = getent("heli_garden", "targetname");
	
	tag linkto(heli, "tag_turret");
	
	playfxontag( level._effect[ "copter_dust" ], tag, "tag_origin" );
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Garden
///////////////////////////////////////////////////////////////////////////////////////
vo_garden_start()
{
	wait(0.5);
	
	level.player play_dialogue("BOND_GlobG_123A", false);  // What do you see, Tanner?
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_701A", true);  // There's a gate at the bottom of the garden.  You can use it to circle round and get back to the house.

	wait(0.5);
	
	maps\_autosave::autosave_now("whites_estate");
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Garden lock hack
///////////////////////////////////////////////////////////////////////////////////////
vo_garden_lock()
{	
	level.player play_dialogue("TANN_WHITG_702A", true);  // Do you see the gate, 007?  Hack the lock and head towards the boathouse.
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Boathouse feedbox
///////////////////////////////////////////////////////////////////////////////////////
vo_boathouse_feedbox()
{
	level.player play_dialogue("TANN_WHITG_703A", true);  // Somewhere in that boathouse there's a live feed box.  find it and we'll be able to see the entire estate.
	
	flag_wait("feed_tapped");
	
	wait(1.0);
	
	level.player play_dialogue("BOND_AirpG_006A", false);  // I'm patched in.
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_704A", true);  // Good job, 007, I'm seeing it as well.  I suggest you cut through the greenhouses and enter White's villa through the cellar.
	
	wait(0.5);
	
	level.player play_dialogue("BOND_GlobG_105A", false);  // I'm on my way now.
	
	maps\_autosave::autosave_now("whites_estate");
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Small Greenhouse
///////////////////////////////////////////////////////////////////////////////////////
vo_small_greenhouse()
{
	maps\_autosave::autosave_now("whites_estate");
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_705A", true);  // Bond, to get to the villa you'll have to deal with more of White's men.  They're gathering up ahead.
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_529A", false);  // How many are there?
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_530A", true);  // Half a dozen at least, Bond.
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO after large greenhouse
///////////////////////////////////////////////////////////////////////////////////////
vo_large_greenhouse()
{
	trigger = getent("trigger_greenhouse_done", "targetname");
	trigger waittill("trigger");
	
	maps\_autosave::autosave_now("whites_estate");
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_531A", false);  //I’m heading towards the house.
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_706A", true);  //Let me know when you're inside.  You've got some time to find our missing money, but not much.  We need Mr. White delivered...
	
	level thread vo_cellar_entered();
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Cellar entered
///////////////////////////////////////////////////////////////////////////////////////
vo_cellar_entered()
{
	trigger = getent("trigger_vo_cellar", "targetname");
	trigger waittill("trigger");
	
	SetDVar("sm_sunShadowEnable", 0);
	SetDVar("sm_spotShadowEnable", 1);
	
	level thread flicker_light();
	level thread kill_all();
	
	maps\_autosave::autosave_now("whites_estate");
	
	wait(0.5);
		
	level.player play_dialogue("BOND_WHITG_539A", false);  // I'm inside.
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_707A", true);  // White's briefcase should be in his wall safe somewhere upstairs.  Check your phone.  I believe we caught a glimpse of the safe on camera three.
	
	wait(0.5);
	
	level.vo_cellar_done = true;
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Cellar guards
///////////////////////////////////////////////////////////////////////////////////////
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
		if (!level.cellar_alerted)
		{
			level thread cellar_thug_lookbehind();
			guard[0] play_dialogue("CLM1_WHITG_534A", false);  // There was a firefight in the greenhouse.  That was our last contact.
		}
	}
	else if (isdefined(guard[1]))
	{
		if (!level.cellar_alerted)
		{
			level thread cellar_thug_lookbehind();
			guard[1] play_dialogue("CLM1_WHITG_534A", false);  // There was a firefight in the greenhouse.  That was our last contact.
		}
	}
	
	wait(0.5);
	
	if (isdefined(guard[1]))
	{
		if (!level.cellar_alerted)
		{
			guard[1] play_dialogue("CLM2_WHITG_535A", false);  // He's in the cellar!  One of the patrol guards just radioed in.
		}
	}
	else if (isdefined(guard[0]))
	{
		if (!level.cellar_alerted)
		{
			guard[0] play_dialogue("CLM2_WHITG_535A", false);  // He's in the cellar!  One of the patrol guards just radioed in.
		}
	}
	
	wait(0.5);
	
	if (isdefined(thug))
	{
		if (!level.cellar_alerted)
		{
			thug play_dialogue("CLM3_WHITG_536A", false);  // Seal the outside doors.  Let's go.
		}
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
		thug play_dialogue("CLM2_WHITG_537A", false);  // Contact!  He's here!
		level thread set_cellar_alert();
	}
	else if (isdefined(guard[0]))
	{
		guard[0] play_dialogue("CLM2_WHITG_537A", false);  // Contact!  He's here!
		level thread set_cellar_alert();
	}
	else if (isdefined(guard[1]))
	{
		guard[1] play_dialogue("CLM2_WHITG_537A", false);  // Contact!  He's here!
		level thread set_cellar_alert();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Safe location hint
///////////////////////////////////////////////////////////////////////////////////////
vo_safe_hint()
{
	found = false;
	
	level.player play_dialogue("TANN_WHITG_541A", true);  // If you haven't found the safe, try upstairs.
	
	while(!found)
	{
		wait(30.0);
		
		if (!level.safe_room_found)
		{
			level.player play_dialogue("TANN_WHITG_708A", true);  // Check the third floor, 007.
		}
		
		if (level.safe_room_found)
		{
			found = true;
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - Safe found
///////////////////////////////////////////////////////////////////////////////////////
vo_safe_room()
{
	level.player play_dialogue("BOND_WHITG_543A", false);  // Tanner.  There's no briefcase.  The safe is empty.
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_544A", true);  // Dammit!  Treasury won't like that...
	
	wait(0.5);
	
	flag_wait("safe_hacked");
	
	level.player play_dialogue("BOND_WHITG_545A", false);  // But I've found something better.
	
	wait(0.5);
	
	level.player play_dialogue("TANN_WHITG_546A", true);  // Than a hundred and fifteen million dollars?  What have you laid your hands on?
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_547A", false);  // The Organization's computer files.
}


vo_computer_room()
{	
	level.player play_dialogue("BOND_WHITG_549A", false);  // I'm copying the files now.
	
	wait(0.5);
	
	//level.player play_dialogue("TANN_WHITG_550A", true);  // What was that?
	
	flag_set("vo_computer_done");
	
	flag_wait("explosion_done");
	
	level thread explode_server_room();
	
	level.player play_dialogue("TANN_WHITG_551A", true);  // Bond!  White's got the whole place rigged.  There are bombs everywhere!  Get out!  Now!
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - White's helicopter entry
///////////////////////////////////////////////////////////////////////////////////////
vo_white_helicopter()
{
	trigger = getent("trigger_white_heli", "targetname");
	trigger waittill("trigger");
	
	level notify ( "start_the_coppter" );
	
	level.player stoploopsound();
	
	flag_set("go_elites");
	
	//wait(1.0);
	
	level.player play_dialogue("TANN_WHITG_552A", true);  // Do you hear that, Bond?
	
	wait(0.5);
	
	level.player play_dialogue("BOND_WHITG_553A", false);  // The helicopter.
	
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
	
	level.player play_dialogue("TANN_WHITG_601A", true);  // They're about to evacuate White.  Don't let him escape.
	
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO - White trying to escape
///////////////////////////////////////////////////////////////////////////////////////
vo_white_end()
{
	white = getent("mrwhite", "targetname");
	
	white play_dialogue("WHIT_WHITG_024A", true);  // Hurry!  Bond's still alive!
	
	wait(0.5);
	
	white play_dialogue("WHIT_WHITG_025A", true);  // Get me out of here.  Now.
	
	wait(0.5);
	
	white play_dialogue("WHIT_WHITG_026A", true);  // Lift off!  Go!
}



///////////////////////////////////////////////////////////////////////////////////////
//	Camera setup
///////////////////////////////////////////////////////////////////////////////////////
camera_setup()
{
	monitor_cam = getentarray("monitor_cam", "targetname");

	for (i=0; i<monitor_cam.size; i++)
	{
		monitor_cam[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
	}
	
	feedbox = GetEnt( "feedbox", "targetname" );

	level thread maps\_securitycamera::camera_tap_start( feedbox, monitor_cam );
	
	feedbox waittill("tapped");
	
	level thread spawn_camera03_guard();
	level thread spawn_camera04_guard();
	
	flag_set("feed_tapped");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Camera spawners
///////////////////////////////////////////////////////////////////////////////////////
spawn_camera03_guard()
{
	spawner = getent("spawner_camera03", "targetname");
	
	guard = spawner stalingradspawn("camera3_guard");
}


check_watch()
{
	rand = randomintrange(1, 6);
	
	if (rand == 1)
	{
		if (isdefined(self))
		{
			self cmdaction("checkwatch");
		}
	}
	else if (rand == 2)
	{
		if (isdefined(self))
		{
			self cmdaction("checkearpiece");
		}
	}
	else if (rand == 3)
	{
		if (isdefined(self))
		{
			self cmdaction("checkweapon");
		}
	}
}

check_safe()
{
	if (isdefined(self))
	{
		self cmdaction("checkearpiece");
	}
}

look_over()
{
	if (isdefined(self))
	{
		self cmdaction("lookover");
	}
}


spawn_camera04_guard()
{
	spawner = getent("spawner_camera04", "targetname");
	
	guard = spawner stalingradspawn("camera4_guard");
	
	level thread open_balcony_window();
	
	while (isdefined(guard))
	{
		if (isdefined(guard))
		{
			guard cmdaction("checkwatch");
		}
		
		wait(8.0);
		
		if (isdefined(guard))
		{
			guard cmdplayanim("thu_relax_stand_idl_turn_l90_foregrip");
		}
		
		wait(2.0);
		
		if (isdefined(guard))
		{
			guard cmdaction("checkearpiece");
		}
		
		wait(8.0);
		
		if (isdefined(guard))
		{
			guard cmdplayanim("thu_relax_stand_idl_turn_r90_foregrip");
		}
		
		wait(2.0);
	}
}


delete_camera_guards()
{
	guard01 = getent("camera4_guard", "targetname");
	guard02 = getent("camera3_guard", "targetname");
	
	if (isdefined(guard01))
	{
		guard01 delete();
	}
	
	if (isdefined(guard02))
	{
		guard02 delete();
	}
	
	level thread close_balcony_window();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Check for surviving guards in the garden
///////////////////////////////////////////////////////////////////////////////////////
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
			//level thread hint_compass();
			level thread vo_garden_lock();
		}
		
		wait(0.1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Alert garden guards
///////////////////////////////////////////////////////////////////////////////////////
alert_garden()
{
	trigger = getent("trigger_first_guard", "targetname");
	trigger waittill("trigger");

	flag_set("garden_alert");
	
	level thread signal_garden_heli();
}


signal_garden_heli()
{
	trigger = getent("trigger_third_guards", "targetname");
	trigger waittill("trigger");
	
	flag_set("signal_heli");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn intro guard on balcony
///////////////////////////////////////////////////////////////////////////////////////
spawn_intro_balcony()
{
	spawner = getent("spawner_intro_balcony", "targetname");
	
	guard = spawner stalingradspawn("balcony");
	
	guard setenablesense(false);
	
	guard cmdaction("checkearpiece");
	
	guard waittill("cmd_done");
	
	guard cmdaction("lookover");
	
	wait(9.0);
	
	guard delete();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn intro guard
///////////////////////////////////////////////////////////////////////////////////////
spawn_intro_guard01()
{
	spawner = getent("spawner_intro_01", "targetname");
	slide = getnode("node_slide", "targetname");
	call = getnode("node_callout", "targetname");
	end = getnode("node_over_rail", "targetname");
	combat = getnode("node_garden_alert01", "targetname");
	
	guard01 = spawner stalingradspawn("guard01");
	
	guard01 setenablesense(false);
	guard01.accuracy = 0.5;
	
	//guard01 setgoalnode(slide, 0);
	
	//guard01 waittill("goal");
	
	//guard01 cmdplayanim("thu_cvrmidtns_stnd_slide2ready_pistol");
	
	wait(0.5);
	
	guard01 cmdaction("callout");
	
	guard01 thread vo_intro_01();
	
	wait(3.0);
	
	guard01 stopallcmds();
	
	guard01 setgoalnode(end, 0);
	
	flag_set("gogogo");
	
	guard01 waittill("goal");
	
	guard01 setenablesense(true);
	
	flag_wait("garden_alert");
	
	guard01 setgoalnode(combat, 1);
	
	wait(2.0);
}


vo_intro_01()
{
	self play_dialogue("WTM1_WHITG_503A", false);  // He's in the garden!  Go!
	
	wait(7.0);
	
	self play_dialogue("WTM1_WHITG_504A", false);  // Spread out, he can't be far!  Move!
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
	guard.accuracy = 0.5;
	
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
	guard.accuracy = 0.5;
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
	guard.accuracy = 0.5;
	guard setenablesense(false);	
	guard setgoalnode(node, 0);
	guard waittill("goal");
	guard setenablesense(true);
	
	flag_wait("garden_alert");
	
	guard setgoalnode(combat, 1);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Check for single guard left
///////////////////////////////////////////////////////////////////////////////////////
check_retreat()
{
	retreat = false;
	node = getnode("node_cover_retreat", "targetname");
	
	while(!(retreat))
	{
		guards = getaiarray("axis");
		
		if ((guards.size) < 2)
		{
			retreat = true;
			
			if (isdefined(guards[0]))
			{
				guards[0] setgoalnode(node, 1);
			}
		}
		
		wait(0.1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Close gates at start
///////////////////////////////////////////////////////////////////////////////////////
close_gates()
{
	gate01 = getentarray("gate_one", "targetname");
	gate02 = getentarray("gate_two", "targetname");
	
	for (i=0; i<gate01.size; i++)
	{
		gate01[i] rotateyaw(-90, 0.5);
	}
	
	for (i=0; i<gate02.size; i++)
	{
		gate02[i] rotateyaw(90, 0.5);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Check if player takes cover at all
///////////////////////////////////////////////////////////////////////////////////////
check_cover_taken()
{
	while(!(level.cover_taken))
	{
		if (level.player isincover())
		{
			level.cover_taken = true;
			level thread hint_leave_cover();
		}
		wait(0.05);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Tell player how to leave cover
///////////////////////////////////////////////////////////////////////////////////////
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
		
		//tutorial_message( "" );
		
		wait(1.0);
		
		tutorial_message( "WHITES_ESTATE_TUTORIAL_LEAVE" );
	
		wait(4.0);
		
		tutorial_message( "" );
		
		wait(0.5);
		
		tutorial_message( "WHITES_ESTATE_TUTORIAL_LEAVECOVERCROUCH" );
		
		wait(5.0);
		
		tutorial_message( "" );
		
		level.displaying_hint = false;
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Switch weapons hint when SAF is picked up
///////////////////////////////////////////////////////////////////////////////////////
switch_weapons_hint()
{
	weapon_pickedup = false;
	
	while(!weapon_pickedup)
	{
		if (level.player HasWeapon("SAF45_white"))
		{
			weapon_pickedup = true;
			level.player SetWeaponAmmoClip( "SAF45_white", 30 );
		}
		
		if (level.player HasWeapon("1911"))
		{
			weapon_pickedup = true;
			level.player SetWeaponAmmoClip( "1911", 30 );
		}
		
		wait(0.05);
	}
	
	wait(0.5);
	
	proceed = false;
	
	while(!proceed)
	{
		if (!level.displaying_hint)
		{
			proceed = true;
		}
		wait(0.05);
	}
	
	wait(0.05);
	
	level.displaying_hint = true;
	
	//tutorial_message( "" );
	
	wait(1.0);
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_WEAPON" );
			
	wait(4.0);
	
	tutorial_message( "" );
	
	wait(0.5);
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_AIM" );
	
	wait(4.0);
	
	tutorial_message( "" );
	
	wait(0.5);
	
	level.displaying_hint = false;
	
	level thread hint_reload();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Remind player to reload
///////////////////////////////////////////////////////////////////////////////////////
hint_reload()
{
	bulletcount = level.player GetCurrentWeaponClipAmmo();
	
	reload_time = false;
	
	while(!reload_time)
	{
		bulletcount = level.player GetCurrentWeaponClipAmmo();
		
		if (bulletcount < 5)
		{	
			reload_time = true;
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
	
			wait(1.0);
	
			tutorial_message( "WHITES_ESTATE_TUTORIAL_RELOAD" );
			
			wait(3.0);
	
			tutorial_message( "" );
		
			wait(0.5);
		
			level.displaying_hint = false;
		}
		
		wait(0.05);
	}
	
	wait(3.0);
	
	level thread reset_hint_reload();
}


reset_hint_reload()
{
	level.reload_counter++;
	
	if (level.reload_counter < 2)
	{
		level thread hint_reload();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Remind player to take cover when near it
///////////////////////////////////////////////////////////////////////////////////////
hint_take_cover()
{
	trigger = getent("trigger_take_cover", "targetname");
	trigger waittill("trigger");
	
	proceed = false;
	
	while(!proceed)
	{
		if (!level.displaying_hint)
		{
			proceed = true;
		}
		wait(0.05);
	}
	
	if (!level.cover_taken)
	{	
		if (level.player istouching(trigger))
		{
			level.displaying_hint = true;
	
			wait(0.05);
			
			tutorial_message( "WHITES_ESTATE_TUTORIAL_COVER" );
	
			wait(4.0);
		
			tutorial_message( "" );
			
			wait(0.05);
		
			level.displaying_hint = false;
		}
	}
	
	level thread remind_cover();
}


remind_cover()
{
	if (!level.cover_taken)
	{
		level thread hint_take_cover();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Compass Hint
///////////////////////////////////////////////////////////////////////////////////////
hint_compass()
{
	//proceed = false;
	
	//while(!proceed)
	//{
	//	if (!level.displaying_hint)
	//	{
	//		proceed = true;
	//	}
	//	wait(0.05);
	//}
	
	tutorial_message( "" );
	
	wait(0.5);
	
	level.displaying_hint = true;
		
	tutorial_message( "WHITES_ESTATE_TUTORIAL_COMPASS" );
	
	wait(5.0);
		
	tutorial_message( "" );
		
	wait(0.5);
		
	level.displaying_hint = false;
}



///////////////////////////////////////////////////////////////////////////////////////
//	Flank hint
///////////////////////////////////////////////////////////////////////////////////////
hint_flank()
{
	//proceed = false;
	
	//while(!proceed)
	//{
	//	if (!level.displaying_hint)
	//	{
	//		proceed = true;
	//	}
	//	wait(0.05);
	//}
	
	tutorial_message( "" );
	
	wait(0.5);
	
	level.displaying_hint = true;
		
	tutorial_message( "WHITES_ESTATE_TUTORIAL_FLANK" );
	
	wait(5.0);
		
	tutorial_message( "" );
		
	wait(0.5);
		
	level.displaying_hint = false;
}



///////////////////////////////////////////////////////////////////////////////////////
//	Dash to cover hint
///////////////////////////////////////////////////////////////////////////////////////
hint_dash()
{
	trigger = getent("trigger_dash_hint", "targetname");
	trigger waittill("trigger");
	
	tutorial_message( "" );
	
	level.displaying_hint = true;
	
	wait(0.05);
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_DASH" );
			
	wait(4.0);
	
	tutorial_message( "" );
	
	level.displaying_hint = false;
	
	wait(1.0);
	
	level thread hint_fire_mode();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Fire mode hint
///////////////////////////////////////////////////////////////////////////////////////
hint_fire_mode()
{
	level.displaying_hint = true;
	
	tutorial_message( "PLATFORM_WHITES_TUTORIAL_MODE" );
	
	wait(4.5);
		
	tutorial_message( "" );
	
	level.displaying_hint = false;
}



///////////////////////////////////////////////////////////////////////////////////////
//	First guard in garden
///////////////////////////////////////////////////////////////////////////////////////
spawn_first_guard()
{
	trigger = getent("trigger_first_guard", "targetname");
	trigger waittill("trigger");
	
	spawner = getent("spawner_first_guard", "targetname");
	
	guard = spawner stalingradspawn("first_guard");
	guard.accuracy = 0.5;
	//guard setscriptspeed("run");
	//guard setenablesense(false);
	
	level thread spawn_second_guard();
	level thread spawn_third_guard();
	level thread spawn_gate_guards();
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



///////////////////////////////////////////////////////////////////////////////////////
//	Second guard in garden
///////////////////////////////////////////////////////////////////////////////////////
spawn_second_guard()
{
	spawner = getent("spawner_second_guard", "targetname");
	node = getnode("node_second_guard", "targetname");
	
	spawner stalingradspawn("second_guard");
	
	first_guard = getent("first_guard", "targetname");
	second_guard = getent("second_guard", "targetname");
	
	second_guard.accuracy = 0.5;
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Third guard in garden
///////////////////////////////////////////////////////////////////////////////////////
spawn_third_guard()
{	
	guard = getentarray("spawner_third_guard", "targetname");
	
	for (i=0; i<guard.size; i++)
	{
		guard[i] = guard[i] stalingradspawn("third_guard");
		guard[i].accuracy = 0.5;
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



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn gate guards
///////////////////////////////////////////////////////////////////////////////////////
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
		guard[i].accuracy = 0.5;
	}
	
	level thread check_garden();
	level thread save_lockpick();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Save after lock pick
///////////////////////////////////////////////////////////////////////////////////////
save_lockpick()
{
	level.player waittill( "lockpick_done" );

	maps\_autosave::autosave_now("whites_estate");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Open gate for first enemies
///////////////////////////////////////////////////////////////////////////////////////
open_gate()
{
	door_node = Getnode( "boathouse_gate", "targetname" );
	door_node maps\_doors::open_door_from_door_node();

	wait(3.0);
	
	door_node maps\_doors::close_door_from_door_node();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn Garden helicopter
///////////////////////////////////////////////////////////////////////////////////////
spawn_heli_garden()
{	
	heli = getent("heli_garden", "targetname");
		
	spawnpt = getent("origin_heli_spawn", "targetname");
	flypt01 = getent("origin_heli_pt01", "targetname");
	flypt02 = getent("origin_heli_pt02", "targetname");
	flypt03 = getent("origin_heli_pt03", "targetname");
	flypt04 = getent("origin_heli_pt04", "targetname");
	flypt05 = getent("origin_heli_pt05", "targetname");
		
	//heli playloopsound("police_helicopter");
	
	//heli thread check_heli_garden();
	
	heli.health = 99999;
		
	heli setspeed(50, 40);
	heli setvehgoalpos ((spawnpt.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt02.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((-5886, -625, 872), 0);
	heli waittill ( "goal" );
	
	heli setspeed(30, 15);
	heli setvehgoalpos ((flypt03.origin), 1);
	heli waittill ( "goal" );
	
	//iprintlnbold("SOUND: chopper garden flyover");
	heli playsound ("police_helicopter_intro");
	
	heli setLookAtEnt( level.player );
	
	flag_set("garden_alert");
	
	heli clearLookAtEnt();
	
	//flag_wait("signal_heli");
	
	//heli thread clear_lookat();
	
	heli setvehgoalpos ((flypt04.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt05.origin), 0);
	heli waittill ( "goal" );
	
	tag = getent("tag_heli_efx", "targetname");
	tag delete();
	
	//heli stoploopsound();
	
	if (isdefined(heli))
	{
		heli delete();
	}
}


check_heli_garden()
{
	self.health = 10000;
	
	go = false;
	guards = getaiarray("axis");
	
	while(!go)
	{
		if (self.health < 9800 || guards.size < 1)
		{
			go = true;
			wait(1.5);
			flag_set("signal_heli");
		}
		
		guards = getaiarray("axis");
		
		wait(0.1);
	}
}


spawn_jump_down()
{
	spawner = getent("spawner_heli_jumper", "targetname");
	heli = getent("heli_garden", "targetname");
	origin = getent("origin_jump", "targetname");
	ground = getent("garden_tower", "targetname");
	
	guy = spawner stalingradspawn("jumper");
	
	guy.accuracy = 0.4;
	guy setenablesense(false);
	
	guy teleport(heli GetTagOrigin("tag_playerride"), (heli GetTagAngles("tag_playerride")+ (0,0,0)), true);
	guy linkto(heli, "tag_playerride", (-12, 36, 12), (0, 0, 0));
	
	origin moveto( guy.origin, 0.05, 0.05, 0.05 );
	
	wait(0.05);
	
	guy unlink();
	guy linkto(origin);
	
	wait(1.0);
	
	guy cmdplayanim( "thu_alrt_traversal_jumpdownloop_foregrip", true );
	
	wait(0.5);
	
	origin moveto(ground.origin, 0.07, 0.05, 0.05);
	
	wait(0.1);
	
	guy unlink();
	guy setenablesense(true);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on boats
///////////////////////////////////////////////////////////////////////////////////////
spawn_boat_guard01()
{
	spawner = getent("spawner_boat_guard01", "targetname");
	
	guard = spawner stalingradspawn("boat_guard01");
	
	guard teleport(self.origin, self.angles);;
	guard LinkTo( self, "tag_driver", (-44, 30, 0), (0, 90, 0) );
	
	guard setperfectsense(true);
	guard setpainenable( false );
	guard allowedstances( "crouch" );
	guard.accuracy = 0.3;
	
	wait(7.0);
	
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
	guard.accuracy = 0.3;
	
	wait(7.0);
	
	if (isdefined(guard))
	{
		guard delete();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Boats race into the boathouse
///////////////////////////////////////////////////////////////////////////////////////
boat_arrive()
{
	boat_01 = GetEnt( "boat_01", "targetname" );
	boat_02 = GetEnt( "boat_02", "targetname" );
	
	trigger = getent("trigger_boats", "targetname");
	trigger waittill("trigger");
	
	boat_01 thread boat_01_anim_play();
	boat_02 thread boat_02_anim_play();
	level thread whites_yacht_sail();
	
	wait(9.0);
	
	boat_01 delete();
	boat_02 delete();
	
	boat_a = getent("boat_dest_a", "targetname");
	boat_a show();
		
	boat_b = getent("boat_dest_b", "targetname");
	boat_b show();
	
	boat_a thread float_boat();
	boat_b thread float_boat();
}


#using_animtree( "vehicles" );
float_boat()
{
	self UseAnimTree(#animtree);
	self setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}



///////////////////////////////////////////////////////////////////////////////////////
//	Ambient boats
///////////////////////////////////////////////////////////////////////////////////////
whites_yacht_sail()
{
	yacht = getent("whites_yacht", "targetname");
	
	yacht movex(12000, 240, 10, 5);
}


boat_a_sail()
{
	boat = getent("boat_a", "targetname");
	
	boat movey(-10000, 220, 10, 5);
}


boat_b_sail()
{
	boat = getent("boat_b", "targetname");
	
	boat moveto((-8746, 10156, -504), 80, 10, 5);
}


boat_c_sail()
{
	boat = getent("boat_c", "targetname");
	
	boat moveto((5912, 4100, -504), 45, 10, 0);
	
	boat waittill ( "movedone" );
	
	wait(0.1);
	
	playfx (level._effect["explosion_1"], boat.origin );
	
	boat delete();
}


boat_d_sail()
{
	boat = getent("boat_d", "targetname");
	
	boat moveto((4027, 1089, -504), 100, 10, 5);
}


boat_e_sail()
{
	boat = getent("boat_e", "targetname");
	
	boat moveto((12331, 1283, -504), 100, 10, 5);
}


boat_f_sail()
{
	boat = getent("boat_f", "targetname");
	
	boat moveto((5919, 4203, -504), 45, 10, 0);
	
	boat waittill ( "movedone" );
	
	playfx (level._effect["explosion_1"], boat.origin );
	
	wait(3.0);
	
	boat movez(-850, 60);
	
	wait(21.0);
	
	boat delete();
}


///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guy for boathouse quick kill
///////////////////////////////////////////////////////////////////////////////////////
spawn_boathouse_quickkill()
{
	trigger = getent("trigger_boathouse_quickkill", "targetname");
	trigger waittill("trigger");
	
	level thread tip_quickkill();
	level thread boathouse_spawn_thug_01();
	level thread guard_turn();
	
	spawner = getent("spawner_boathouse_quickkill", "targetname");
	guard  = spawner stalingradspawn("guard_boathouse");
	//node = getnode("node_quickkill", "targetname");
	
	guard lockaispeed("walk");
	guard setperfectsense(true);
	guard setcombatrolelocked(false);
	guard setcombatrole("rusher");
	
	//guard setgoalnode(node, 0);
	
	/*player_detected = false;
	
	while(!(player_detected))
	{
		if ((isdefined(guard)) && (guard getalertstate() == "alert_red"))
		{
			guard setcombatrolelocked(false);
			guard setcombatrole("basic");
			player_detected = true;
		}
		wait(0.3);
	}*/
	
	if ( !level.ps3 )
	{
		level thread boat_b_sail();
		level thread boat_c_sail();
		level thread boat_f_sail();
	}
}


kill_garden()
{
	guy0 = getent("guard01", "targetname");
	guy1 = getent("guard03", "targetname");
	guy2 = getent("guard04", "targetname");
	guy3 = getent("thug_stairs", "targetname");
	guys = getentarray("garden_guards", "targetname");
	
	if (isdefined(guy0))
	{
		guy0 delete();
	}
	
	if (isdefined(guy1))
	{
		guy1 delete();
	}
	
	if (isdefined(guy2))
	{
		guy2 delete();
	}
	
	if (isdefined(guy3))
	{
		guy3 delete();
	}
	
	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i] delete();
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Quick kill tip
///////////////////////////////////////////////////////////////////////////////////////
tip_quickkill()
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
	
	tutorial_message( "" );
	
	level.displaying_hint = true;
	
	tutorial_message( "PLATFORM_TUTORIAL_TAKEDOWN" );
	
	wait(3.0);
		
	tutorial_message( "" );
	
	level.displaying_hint = false;
}

guard_quickkill()
{
	node = getnode("node_quickkill", "targetname");
	guard = getent("guard_boathouse", "targetname");
	
	//wait(1.0);
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn for boat dock battle
///////////////////////////////////////////////////////////////////////////////////////
boathouse_spawn_thug_01()
{
	trigger = getent( "boathouse_dock_fight_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	clip_dock = getent("clip_dock_tank", "targetname");
	clip_dock delete();
	
	level thread hint_mousetrap();
	
	boathouse_thugs = getentarray ( "boathouse_thug_00", "targetname" );
	jumper = getent("boathouse_thug_jump", "targetname");
	node_dock = getnodearray("node_cover_dock", "targetname");
	node_jump = getnode("node_jump_dock", "targetname");
	node_cover = getnode("node_cover_jump", "targetname");
	
	jump = jumper stalingradspawn("dock_guy");
	
	level thread vo_dock_battle();
		
	//jump setgoalnode(node_jump, 0);
	jump.accuracy = 0.5;
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
	level thread boathouse_gen_boats_sail();
	
	//jump waittill("goal");
	
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
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_MOUSETRAP" );
		
	wait(4.5);
	
	tutorial_message( "" );
	
	//wait(0.5);

	//tutorial_message( "PLATFORM_WHITES_TUTORIAL_MODE" );
	
	//wait(4.5);
		
	//tutorial_message( "" );
	
	level.displaying_hint = false;
}



///////////////////////////////////////////////////////////////////////////////////////
//	VO battle chatter docks
///////////////////////////////////////////////////////////////////////////////////////
vo_dock_battle()
{
	guard = getent("dock_guy", "targetname");
	guy = getentarray("dock_guard", "targetname");

	if (isdefined(guard))
	{
		guard play_dialogue("SAM_E_1_McGS_Cmb", false);  // Gain sight in combat
	}
	
	wait(0.5);
	
	if (isdefined(guy[0]))
	{
		guard play_dialogue("SAM_E_1_Flan_Cmb", false);  // Gain sight in combat
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Explosion physics for dock
///////////////////////////////////////////////////////////////////////////////////////
propane_explosion_01()
{
	trigger = getent( "trigger_dock_explosion01", "targetname" );
	trigger waittill ( "trigger" );
	
	//Stop Music - crussom
	level notify("endmusicpackage");
	
	level thread slow_dock();
	
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
	
	clip_dock_fire = getent("clip_dock_fire", "targetname");
	clip_dock_fire trigger_on();
	
	level thread fire_planks();
	
	wood = getentarray("floatingwood", "targetname");
	for (i=0; i<wood.size; i++)
	{
		wood[i] trigger_on();
		wood[i] thread wood_float();
	}
}


wood_float()
{
	self endon ("white_blows_estate");
	
	while(1)
	{
		self movez(-2, 2.0, 0.5, 0.3);
		wait(2.0);
		self movez(2, 2.0, 0.5, 0.3);
		wait(2.0);
	}
}


fire_planks()
{
	level endon("white_blows_estate");
	
	tag = getentarray("tag_plank_fire01", "targetname");
	wood = getentarray("floatingwood", "targetname");
	
	//for (i=0; i<tag.size; i++)
	//{
	//	tag[i] linkto(wood[i]);
	//}
	
	while(1)
	{
		playfxontag( level._effect[ "teeny_fire" ], tag[0], "tag_origin" );
		playfxontag( level._effect[ "teeny_fire" ], tag[1], "tag_origin" );
		playfxontag( level._effect[ "teeny_fire" ], tag[2], "tag_origin" );
		wait(5.0);
	}
}


propane_explosion_02()
{
	trigger = getent( "trigger_dock_explosion02", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread slow_dock();
	
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


slow_dock()
{
	if (!level.dock_explosion)
	{
		level.dock_explosion = true;
		wait(0.25);
		level thread slow_time(.15, 0.40, 0.25);
	}
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



///////////////////////////////////////////////////////////////////////////////////////
//	Sets the dock on fire
///////////////////////////////////////////////////////////////////////////////////////
set_dock_fire()
{
	dockfire = getentarray("origin_fire_dock", "targetname");
	
	wait(1.0);
	
	for (i=0; i<dockfire.size; i++)
	{
		dockfire[i] = spawnfx(level._effect["med_fire"], dockfire[i].origin);
		triggerFX(dockfire[i]);
	}
	
	//water stopanimscripted();
	//water stopuseanimtree();
	//water delete();
	
	dockfire[0] playloopsound("whites_estate_fire_loop");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Check for all dead on dock
///////////////////////////////////////////////////////////////////////////////////////
check_dock()
{
	guard = getentarray("dock_guard", "targetname");
		
	while(guard.size > 0)
	{
		guard = getentarray("dock_guard", "targetname");
		wait(0.1);
	}
	
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

	
	
///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guy inside boathouse
///////////////////////////////////////////////////////////////////////////////////////
spawn_boathouse_doorguy()
{
	node = getnode("node_boathouse_door", "targetname");
	shoot_node = getnode("node_boathouse_shoot", "targetname");
	node_stairs = getnode("node_boathouse_stairs", "targetname");
	spawner = getent("boathouse_thug_01", "targetname");
	
	thug = spawner stalingradspawn("door_guard");
	thug setenablesense(false);
	thug setpainenable( false );
	
	setsaveddvar("bg_quick_kill_enabled", false);
	
	thug setgoalnode(node_stairs, 0);
	
	//thug waittill("goal");
	
	wait(1.0);
	
	level thread boathouse_thug_vo();
	level thread kick_buoys();
		
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
		}
		
		wait(0.1);
	}
}
setup_feedbox_dialog()
{
	trig = getent("vision_set_boathouse","targetname");
	trig waittill("trigger");

	level thread vo_boathouse_feedbox();
	level thread hint_compass();
	level thread open_boathouse_doors();
}
kick_buoys()
{
	thug = getent("door_guard", "targetname");
	
	trigger = getent("trigger_kick_buoys", "targetname");
	trigger waittill("trigger");
	
	physicsExplosionSphere((-4305, 1400, -480), 20, 20, 0.3);
}


boathouse_thug_vo()
{
	thug = getent("door_guard", "targetname");
	
	if (isdefined(thug))
	{
		thug play_dialogue("SAM_E_1_Last_Cmb", false);
	}
}


kick_open_door()
{
	sound_boathouse_door = GetEnt( "origin_sound_boathouse", "targetname" );
	
	wait(1.7);
	
	level notify ( "we_door_kick_start" );
	
	sound_boathouse_door playsound("whites_estate_boathouse_door");
	
	boathouse_door = getent("collision_boathouse_door", "targetname");
	boathouse_door trigger_off();
	boathouse_door connectpaths();
	
	level thread door_knockback_boathouse();
	
	//level thread open_boathouse_doors();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Bond gets knocked back by door to boathouse
///////////////////////////////////////////////////////////////////////////////////////
door_knockback_boathouse()
{
	trigger = getent( "trigger_boathouse_knockback", "targetname" );
		
	if (level.player istouching(trigger))
	{
		level.player shellshock("default", 3.0);
		level.player knockback(4000, (-4277, 1554, -433));
		level.player playersetforcecover( false );
	}
	
	while(level.player istouching(trigger))
	{
		wait(0.05);
	}
	
	//wait(0.05);
	
	boathouse_door_coll = getent("boathouse_clip", "targetname");
	boathouse_door_coll trigger_on();
	
	wait(0.05);
	
	setsaveddvar("bg_quick_kill_enabled", true);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Open doors in boathouse after feed accessed
///////////////////////////////////////////////////////////////////////////////////////
open_boathouse_doors()
{
	door_a1 = getent("boathouse_door_a1", "targetname");
	door_a2 = getent("boathouse_door_a2", "targetname");
	
	door_b1 = getent("boathouse_door_b1", "targetname");
	door_b2 = getent("boathouse_door_b2", "targetname");
	
	door_c1 = getent("boathouse_door_c1", "targetname");
	door_c2 = getent("boathouse_door_c2", "targetname");
	
	flag_wait("feed_tapped");
	
	level thread kill_garden();
	level thread phone_hint();
	
	flag_wait("open_doors");
	
	//wait(0.3);
	
	//trigger = getent( "trigger_open_boathouse", "targetname" );
	//trigger waittill("trigger");
	
	door_a1 rotateyaw(-80, 8.0);
	door_a2 rotateyaw(80, 8.0);
	door_a1 playsound("whites_estate_boathouse_doorhack1");
	
	door_b1 rotateyaw(-80, 8.0);
	door_b2 rotateyaw(80, 8.0);
	door_b1 playsound("whites_estate_boathouse_doorhack2");
	
	if ( !level.ps3 )
	{
		level thread boat_a_sail();
	}
	
	//wait(4.0);
	
	//door_c1 rotateyaw(-90, 7.0);
	//door_c2 rotateyaw(90, 7.0);
	//door_c1 playsound("whites_estate_boathouse_doorhack1");
}


///////////////////////////////////////////////////////////////////////////////////////
//	Phone hint
///////////////////////////////////////////////////////////////////////////////////////
phone_hint()
{
	wait(0.5);
	
	//setSavedDvar("cg_disableBackButton","0");
	
	user_closed = false;
	while ( !user_closed )
	{
		level.player waittill( "phonemenu", phone_state );
		if ( phone_state == 0 )
			user_closed = true;
	}
	
	flag_set("open_doors");
	
	wait(0.05);
	
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
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_PHONE" );
		
	wait(5.0);
	
	tutorial_message( "" );
	
	wait(0.5);
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_ACCESS" );
		
	wait(3.0);
	
	tutorial_message( "" );
	
	level.displaying_hint = false;
	
	//flag_set("open_doors");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guard who tries to lure Bond into small greenhouse
///////////////////////////////////////////////////////////////////////////////////////
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
			guard play_dialogue("SGM_WHITG_527A", false);  // Over here!  He's headed this way!
			
		
			//Play Greenhouse Music - crussom
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
			//iPrintLnBold("ACHIEVEMENT");
			GiveAchievement("Challenge_WhitesEstate");
		}
	}
}




spawn_boathouse_backexit()
{
	trigger = getent("trigger_boathouse_backexit", "targetname");
	trigger waittill("trigger");
	
	if (!(level.greenhouse_lure))
	{
		/*spawner = getent("spawner_boathouse_backexit", "targetname");
		guard = spawner stalingradspawn("lure");
		level.greenhouse_lure = true;
		
		node = getnode("node_boathouse_after", "targetname");
		
		guard setgoalnode(node, 1);*/
		
		node = getnode("node_greenhouse", "targetname");
		spawner = getent("spawner_boathouse_backexit", "targetname");
		guard = spawner stalingradspawn("lure");
		level.greenhouse_lure = true;
		guard setgoalnode(node, 1);
		
		if (isdefined(guard))
		{
			guard play_dialogue("SGM_WHITG_527A", false);  // Over here!  He's headed this way!
			
			//Play Greenhouse Music - crussom
			level notify("playmusicpackage_greenhouse");
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Tip - Sprint
///////////////////////////////////////////////////////////////////////////////////////
tip_sprint()
{
	trigger = getent("trigger_tip_sprint", "targetname");
	trigger waittill("trigger");
	
	level thread shoot_down_lights();
	level thread reset_greenhouse_ambush();
	level thread greenhouse_ambush_done();
	level thread spawn_heli_gunner();
	
	/*proceed = false;
	
	while(!proceed)
	{
		if (!level.displaying_hint)
		{
			proceed = true;
		}
		wait(0.05);
	}*/
	
	level.displaying_hint = true;
	
	tutorial_message( "PLATFORM_TUTORIAL_SPRINT" );
	wait(5.0);
	tutorial_message( "" );
	
	level.displaying_hint = false;
}



///////////////////////////////////////////////////////////////////////////////////////
//	Shoot down lights in small greenhouse
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Break the glass on the small greenhouse
///////////////////////////////////////////////////////////////////////////////////////
small_greenhouse_glass()
{
	origin = getentarray("origin_greenhouse_roof", "targetname");
	
	for (i=0; i<origin.size; i++)
	{
		radiusdamage (origin[i].origin, 30, 200, 200 );
		//playfx (level._effect["whites_greenhouse_glass1"], origin[i].origin );
		wait(0.05);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Greenhouse ambush
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Reset greenhouse ambush
///////////////////////////////////////////////////////////////////////////////////////
reset_greenhouse_ambush()
{
	trigger = getent("trigger_greenhouse_ambushthread", "targetname");
	trigger waittill("trigger");
	
	if (!(level.greenhouse_thru))
	{
		thread greenhouse_ambush_01();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn ambush guys outside of greenhouse
///////////////////////////////////////////////////////////////////////////////////////
spawn_ambush_guards()
{
	spawner = getentarray("spawner_greenhouse_ambush", "targetname");
	
	for (i=0; i<spawner.size; i++)
	{
		guard[i] = spawner[i] stalingradspawn("ambush_guard");
		guard[i] waittill( "finished spawning" );
		guard[i].accuracy = 0.5;
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



///////////////////////////////////////////////////////////////////////////////////////
//	Got through greenhouse ambush
///////////////////////////////////////////////////////////////////////////////////////
greenhouse_ambush_done()
{
	trigger = getent("trigger_greenhouse_ambushdone", "targetname");
	trigger waittill("trigger");
	
	level.greenhouse_thru = true;
	
	level thread vo_large_greenhouse();
	level thread greenhouse_shootout();
	level thread block_small_greenhouse();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn helicopter gunner
///////////////////////////////////////////////////////////////////////////////////////
spawn_heli_gunner()
{
	spawner = getent( "spawner_heli_gunner", "targetname" );
	guy = spawner stalingradspawn("gunner");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn small greenhouse helicopter
///////////////////////////////////////////////////////////////////////////////////////
spawn_heli_greenhouse()
{	
	//spawnpt = getent("origin_greenhouse_helispawn", "targetname");
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
	guy setforcedbalconydeath();
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Block retreat into small greenhouse
///////////////////////////////////////////////////////////////////////////////////////
block_small_greenhouse()
{
	trigger = getent("trigger_block_greenhouse", "targetname");
	trigger waittill("trigger");
	
	level.heli_go = true;
	
	//level thread vo_small_greenhouse();
	
	level thread spawn_sprinter();
	level thread hint_sprintkill();
	level thread hint_dash();
	
	SetDVar("sm_SunSampleSizeNear", 0.569);
	
	block = getent("door_block_inside", "targetname");
	coll_small_greenhouse = getent("collision_small_greenhouse", "targetname");
	
	coll_small_greenhouse trigger_on();
	
	block rotatepitch(45, 0.2);
	
	block thread move_block_greenhouse();
	
	maps\_autosave::autosave_now("whites_estate");
	
	wait(0.2);
	
	block rotateyaw(-15, 0.2);
	
	boat01 = getent("boat_dest_a", "targetname");
	boat02 = getent("boat_dest_b", "targetname");
	
	boat01 delete();
	boat02 delete();
}


spawn_sprinter()
{
	spawner = getent("spawner_sprinter", "targetname");
	
	Setsaveddvar("qk_random_select", 12);
	
	thug = spawner stalingradspawn("sprinter");
	
	thug setperfectsense(true);
	thug lockaispeed("walk");
}


hint_sprintkill()
{
	tutorial_message( "" );
	
	wait(0.05);
	
	tutorial_message( "WHITES_ESTATE_TUTORIAL_SPRINTKILL" );
			
	wait(4.0);
	
	tutorial_message( "" );
}


move_block_greenhouse()
{
	self movez(-12, 0.2);
	wait(0.2);
	self movex(-24, 0.2);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Greenhouse shootout windows
///////////////////////////////////////////////////////////////////////////////////////
greenhouse_shootout()
{
	trigger = getent("trigger_greenhouse_shootout", "targetname");
	trigger waittill("trigger");
	
	Setsaveddvar("qk_random_select", 0);
	
	level thread delete_camera_guards();
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guy who breaks through window
///////////////////////////////////////////////////////////////////////////////////////
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
	
	wait(0.8);
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	VO battle chatter greenhouse
///////////////////////////////////////////////////////////////////////////////////////
vo_greenhouse_battle()
{
	guard = getent("spotter", "targetname");
	guy = getentarray("greenhouse_guard", "targetname");

	if (isdefined(guard))
	{
		guard play_dialogue("SAM_E_1_McGS_Cmb", false);  // Gain sight in combat
	}
	
	flag_wait("greenhouse_reached");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.5;
	}
	
	for (i=0; i<guy.size; i++)
	{
		if (isdefined(guy[i]))
		{
			guy[i].accuracy = 0.5;
		}
	}
	
	if (isdefined(guy[0]))
	{
		guy[0] play_dialogue("SAM_E_1_Flan_Cmb", false);  // Flank
	}
	
	wait(0.5);
	
	if (isdefined(guy[1]))
	{
		guy[1] play_dialogue("SAM_E_2_Flan_Cmb", false);  // Flank
	}
}


	
///////////////////////////////////////////////////////////////////////////////////////
//	Shootdown lights in large greenhouse
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Water tank explosion blows out windows in greenhouse
///////////////////////////////////////////////////////////////////////////////////////
blowout_greenhouse_windows()
{
	level waittill ( "water_tank_explode_start" );
	
	earthquake (0.7, 2.5, level.player.origin, 500, 10.0 );
	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Check greenhouse flankers
///////////////////////////////////////////////////////////////////////////////////////
check_greenhouse_flanker()
{
	guard = getentarray("greenhouse_flanker", "targetname");
	
	while(guard.size > 1)
	{
		guard = getentarray("greenhouse_flanker", "targetname");
		
		wait(0.1);
	}
	
	level thread spawn_greenhouse_victims();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn greenhouse victims
///////////////////////////////////////////////////////////////////////////////////////
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
	
	flag_wait("security_eliminated");
	
	guard = getentarray("victim", "targetname");
	
	for (i=0; i<guard.size; i++)
	{
		if (isdefined(victim[i]))
		{
			radiusdamage (victim[i].origin, 100, 200, 200 );
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Open balcony window for cellar fall guy
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Kill all ai before cellar
///////////////////////////////////////////////////////////////////////////////////////
kill_all()
{
	guys = getaiarray("axis");

	for (i=0; i<guys.size; i++)
	{
		if (isdefined(guys[i]))
		{
			guys[i] delete();
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Make light look like it's flickering
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn first cellar guards
///////////////////////////////////////////////////////////////////////////////////////
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
		guard[i] setalertstatemin("alert_yellow");
	}
	
	guard2 = spawner2 stalingradspawn("guard_cellar_02");
	guard2 setpropagationdelay(0);
	guard2 setalertstatemin("alert_yellow");
	
	level thread vo_cellar_intro();
	level thread check_cellar_status();
	level thread check_cellar_backup();
	level thread check_cellar_alert();
	level thread cellar_slide();
	level thread cellar_runto();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Check alert state of cellar guards
///////////////////////////////////////////////////////////////////////////////////////
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
					level thread set_cellar_alert();
					level.cellar_alerted = true;
				}
			}
		}
		wait(0.1);
	}
	
	//wait(6.0);
	
	//level thread spawn_cellar_backup();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Set cellar guards to red alert if Bond runs into cellar
///////////////////////////////////////////////////////////////////////////////////////
check_cellar_alert()
{
	trigger = getent("trigger_alert_cellar", "targetname");
	trigger waittill("trigger");
	
	level thread set_cellar_alert();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Set cellar guards to red alert
///////////////////////////////////////////////////////////////////////////////////////
set_cellar_alert()
{
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



///////////////////////////////////////////////////////////////////////////////////////
//	Guard checks earpiece
///////////////////////////////////////////////////////////////////////////////////////
check_earpiece()
{
	if (isdefined(self))
	{
		self cmdaction("checkearpiece", true);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Cellar guard waves men forward
///////////////////////////////////////////////////////////////////////////////////////
cellar_thug_callout()
{
	thug = getent("guard_cellar_02", "targetname");
	node = getnode("node_callout_cellar", "targetname");
	
	if (isdefined(thug))
	{
		thug setgoalnode(node, 0);
	}
	
	if (isdefined(thug))
	{
		thug waittill("goal");
	}
	
	wait(1.0);
	
	if (isdefined(thug))
	{
		thug cmdaction("callout", true);
	}
	
	level thread search_cellar();
}


cellar_thug_lookbehind()
{
	thug = getent("guard_cellar_02", "targetname");
	node = getnode("node_lookbehind", "targetname");
	
	if (isdefined(thug))
	{
		thug setgoalnode(node, 0);
	}
	
	if (isdefined(thug))
	{
		thug waittill("goal");
	}
	
	if (isdefined(thug))
	{
		thug cmdaction("lookbehind", true, 2.0);
	}
	
	wait(2.0);
	
	level thread cellar_thug_callout();
}


cellar_slide()
{
	guard = getentarray("guard_cellar_01", "targetname");
	node = getnode("node_cellar_slide", "targetname");
	
	if (isdefined(guard[0]))
	{
		guard[0] setgoalnode(node, 0);
	}
	
	if (isdefined(guard[0]))
	{
		guard[0] waittill("goal");
	}
	
	if (isdefined(guard[0]))
	{
		guard[0] cmdaction("listen", true);
	}
}


cellar_runto()
{
	guard = getentarray("guard_cellar_01", "targetname");
	node = getnode("node_cellar_runto", "targetname");
	
	if (isdefined(guard[1]))
	{
		guard[1] setgoalnode(node, 0);
	}
	
	if (isdefined(guard[1]))
	{
		guard[1] waittill("goal");
	}
	
	if (isdefined(guard[1]))
	{
		guard[1] cmdaction("lookaround", true);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Guards start searching cellar
///////////////////////////////////////////////////////////////////////////////////////
search_cellar()
{
	guard = getentarray("guard_cellar_01", "targetname");
	thug = getent("guard_cellar_02", "targetname");
	
	node1 = getnode("node_cellar_search01", "targetname");
	node2 = getnode("node_cellar_search02", "targetname");
	node3 = getnode("node_cellar_search03", "targetname");
	
	if (isdefined(thug) && !(level.cellar_alerted))
	{
		thug setgoalnode(node1, 1);
		thug thread set_sense();
	}
	
	wait(1.0);
	
	if (isdefined(guard[0]) && !(level.cellar_alerted))
	{
		guard[0] setgoalnode(node2, 1);
		guard[0] thread set_sense();
	}
	
	if (isdefined(guard[1]) && !(level.cellar_alerted))
	{
		guard[1] setgoalnode(node3, 1);
		guard[1] thread set_sense();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Sets guards to perfectsense
///////////////////////////////////////////////////////////////////////////////////////
set_sense()
{	
	if (isdefined(self))
	{
		self waittill("goal");
		
		if (isdefined(self))
		{
			self setperfectsense(true);
			level.cellar_alerted = true;
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn cellar guard coming down from stairs
///////////////////////////////////////////////////////////////////////////////////////
spawn_cellar_guard()
{
	spawner = getent("spawner_cellar_guard", "targetname");
	node = getnode("node_cellar_guard", "targetname");
	
	guard = spawner stalingradspawn("cellar_stair");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.5;
		guard setgoalnode(node, 1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Cellar guards take cover once Bond is spotted
///////////////////////////////////////////////////////////////////////////////////////
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
			guard_01[i].accuracy = 0.5;
			guard_01[i] lockalertstate("alert_red");
			guard_01[i] setgoalnode(node_retreat[i], 1);
		}
	}
	
	if (isdefined(guard_02))
	{
		guard_02.accuracy = 0.5;
		guard_02 lockalertstate("alert_red");
		guard_02 setgoalnode(node, 1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn second cellar guards
///////////////////////////////////////////////////////////////////////////////////////
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
	
	for (i=0; i<thugs.size; i++)
	{
		guard[i] = thugs[i] stalingradspawn("cellar_guard");
		if (isdefined(guard[i]))
		{
			guard[i].accuracy = 0.5;
			guard[i] setgoalnode(node[i], 1);
			//guard[i] setperfectsense(true);
		}
	}
	
	level thread spawn_cellar_guard();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Destructible wine barrels
///////////////////////////////////////////////////////////////////////////////////////
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
		
		cover_winemid01 = getent("cover_winemid_01", "targetname");
		cover_winemid01 trigger_on();
		
		cover_winetop01 = getent("cover_winetop_01", "targetname");
		cover_winetop01 delete();
	
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
	
	cover_winemid01 = getent("cover_winemid_01", "targetname");
	cover_winemid01 delete();
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}
		
	if (!(level.top_01))
	{
		level notify("wine_barrels_top_01_start");
		
		cover_winetop01 = getent("cover_winetop_01", "targetname");
		if (isdefined(cover_winetop01))
		{
			cover_winetop01 delete();
		}
		
		level.top_01 = true;
		barreltop = getent("wine_barrel_top01", "targetname");
		if (isdefined(barreltop))
		{
			barreltop delete();
		}
		
		coll_winetop_01 = getent("coll_winetop_01", "targetname");
		coll_winetop_01 trigger_off();
	}
	
	wait(1.0);
	
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
		
		cover_winemid02 = getent("cover_winemid_02", "targetname");
		cover_winemid02 trigger_on();
		
		cover_winetop02 = getent("cover_winetop_02", "targetname");
		cover_winetop02 delete();
		
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
	
	cover_winemid02 = getent("cover_winemid_02", "targetname");
	cover_winemid02 delete();
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}
	
	if (!(level.top_02))
	{
		level notify("wine_barrels_top_02_start");
		
		cover_winetop02 = getent("cover_winetop_02", "targetname");
		if (isdefined(cover_winetop02))
		{
			cover_winetop02 delete();
		}
		
		level.top_02 = true;
		barreltop = getent("wine_barrel_top02", "targetname");
		if (isdefined(barreltop))
		{
			barreltop delete();
		}
		
		coll_winetop_02 = getent("coll_winetop_02", "targetname");
		coll_winetop_02 trigger_off();
	}
	
	wait(1.0);
	
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
		
		cover_winemid03 = getent("cover_winemid_03", "targetname");
		cover_winemid03 trigger_on();
		
		cover_winetop03 = getent("cover_winetop_03", "targetname");
		cover_winetop03 delete();
	
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
	
	cover_winemid03 = getent("cover_winemid_03", "targetname");
	cover_winemid03 delete();
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}
	
	if (!(level.top_03))
	{
		level notify("wine_barrels_top_03_start");
		
		cover_winetop03 = getent("cover_winetop_03", "targetname");
		if (isdefined(cover_winetop03))
		{
			cover_winetop03 delete();
		}
		
		level.top_03 = true;
		barreltop = getent("wine_barrel_top03", "targetname");
		if (isdefined(barreltop))
		{
			barreltop delete();
		}
		coll_winetop_03 = getent("coll_winetop_03", "targetname");
		coll_winetop_03 trigger_off();
	}
	
	wait(1.0);
	
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
		
		cover_winemid04 = getent("cover_winemid_04", "targetname");
		cover_winemid04 trigger_on();
		
		cover_winetop04 = getent("cover_winetop_04", "targetname");
		cover_winetop04 delete();
	
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
	
	cover_winemid04 = getent("cover_winemid_04", "targetname");
	cover_winemid04 delete();
	
	wine[0] playsound("whites_estate_falling_barrels");
	
	if (isdefined(barrel))
	{
		barrel delete();
	}
	
	if (!(level.top_04))
	{
		level notify("wine_barrels_top_04_start");
		
		cover_winetop04 = getent("cover_winetop_04", "targetname");
		if (isdefined(cover_winetop04))
		{
			cover_winetop04 delete();
		}
	
		level.top_04 = true;
		barreltop = getent("wine_barrel_top04", "targetname");
		if (isdefined(barreltop))
		{
			barreltop delete();
		}
		coll_winetop_04 = getent("coll_winetop_04", "targetname");
		coll_winetop_04 trigger_off();
	}
	
	wait(1.0);
	
	for (i=0; i<wine.size; i++)
	{
		radiusdamage(wine[i].origin, 80, 1, 1, wine[i], "MOD_COLLATERAL" );
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn wine room guard
///////////////////////////////////////////////////////////////////////////////////////
spawn_wine_room()
{
	trigger = getent("trigger_wine_room", "targetname");
	trigger waittill("trigger");
	
	level thread wine_knockover();
	level thread spawn_inside_balcony();
	
	//node1 = getnode("node_cover_wine", "targetname");
	//node2 = getnode("node_cover_stairs", "targetname");
	//node3 = getnode("node_cover_kitchen", "targetname");
	spawner = getent("spawner_wine_room", "targetname");
	
	guard = spawner stalingradspawn("guard_wine");
	
	if (isdefined(guard))
	{
		guard.accuracy = 0.5;
		//guard setgoalnode(node1, 1);
		//guard waittill("goal");
	}
	
	/*wait(2.0);
	
	if (isdefined(guard))
	{
		guard setgoalnode(node2, 1);
		guard waittill("goal");
	}
	
	wait(2.0);
	
	if (isdefined(guard))
	{
		guard setgoalnode(node3, 1);
		guard waittill("goal");
	}*/
}



///////////////////////////////////////////////////////////////////////////////////////
//	AI knocks over wine
///////////////////////////////////////////////////////////////////////////////////////
wine_knockover()
{
	trigger = getent("trigger_wine_knockover", "targetname");
	trigger waittill("trigger");
	
	push = getent("origin_wine_knockover", "targetname");
	
	physicsExplosionSphere(push.origin, 200, 200, 3);
	
	wait(0.5);
	
	push delete();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Fake shootout when Bond enters kitchen
///////////////////////////////////////////////////////////////////////////////////////
shootout_kitchen_01()
{
	for (k=0; k<1; k++)
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
	for (k=0; k<1; k++)
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



///////////////////////////////////////////////////////////////////////////////////////
//	Destroy plates when kitchen shelves are shot
///////////////////////////////////////////////////////////////////////////////////////
destroy_kitchen_shelf01()
{
	trigger = getent("trigger_damage_topshelf", "targetname");
	trigger waittill("trigger");
	
	radiusdamage((-288, -547, 114), 60, 80, 80);
	
	physicsExplosionSphere((-288, -547, 114), 100, 100, 1);
}


destroy_kitchen_shelf02()
{
	trigger = getent("trigger_damage_bottomshelf", "targetname");
	trigger waittill("trigger");
	
	radiusdamage((-288, -547, 101), 60, 80, 80);
	
	physicsExplosionSphere((-288, -547, 101), 100, 100, 1);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on balconies overlooking foyer
///////////////////////////////////////////////////////////////////////////////////////
spawn_inside_balcony()
{
	trigger = getent("trigger_spawn_balconies", "targetname");
	trigger waittill("trigger");
	
	level thread spawn_safe_lure();
	level thread body_fall_sound();
	
	spawner = getentarray("spawner_inside_balcony", "targetname");
	
	for (i=0; i<spawner.size; i++)
	{
		guard[i] = spawner[i] stalingradspawn("balcony_guards");
		guard[i].accuracy = 0.5;
		guard[i] setperfectsense(true);
		guard[i] allowedstances("stand");
	}
	
	trigger = getent("trigger_safe_hint", "targetname");
	trigger waittill("trigger");
	
	level thread vo_safe_hint();
}


body_fall_sound()
{
	trigger = getent("trigger_thug_land", "targetname");
	trigger waittill("trigger");

	trigger playsound("whites_estate_bodyfall_floor");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guard who lures Bond to safe room
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Setup safe to open bookcase
///////////////////////////////////////////////////////////////////////////////////////
safe_button()
{
	maps\_playerawareness::setupSingleUseOnly(
 			"safe_button",		// targetname
 			::open_secret_door,		// func
 			&"WHITES_ESTATE_OPEN_BOOKCASE",	//	hint_string, 
 			undefined,  //use time
 			undefined,	//use text
 			false,		//single use?
 			true,		//require lookat
 			undefined,	//filter
 			undefined, //material
 			false,		//glow
 			false,		//shine
 			false );	//wait
}


open_secret_door(strcObject)
{
	flag_set("safe_hacked");
	flag_set("safe_located");

	level notify ( "open_z_gates" );
	
	level notify("close_saferoom_door");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Setup computer hack
///////////////////////////////////////////////////////////////////////////////////////
safe_keyboard()
{
	keyboard = getent("safe_keyboard", "targetname");
	
	//maps\_useableObjects::create_useable_object(keyboard, "computer_hack", &"WHITES_ESTATE_HACK_COMPUTER", 5.0, undefined, true, false, true);
	
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

//create_useable_object( entity, on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active )



computer_hack(strcObject)
{
	level thread vo_computer_room();
	
	level thread house_lights_off();
	
	if ( !level.ps3 )
	{
		light01 = getent("house_light01", "targetname");
		light01 setlightintensity(2.0);
	}
	
	level thread close_bookcase();
		
	//holster_weapons();
	
	level.player FreezeControls( true );
	
	level thread letterbox_on(true, false, undefined, false);
		
	if ( !level.ps3 )
	{
		VisionSetNaked( "whites_estate_0" );
	}
	else
	{
		VisionSetNaked( "whites_estate_0_ps3" );
	}
	
	flag_wait("vo_computer_done");
	
	if ( level.ps3 )
	{
		SetDVar( "r_lodBias", -4000 );
	}
	
	playcutscene("WE_Detonate", "WE_Detonate_Done", true);
	
	level waittill("WE_Detonate_Done");
	
	if ( level.ps3 )
	{
		SetDVar( "r_lodBias", 0 );
	}
	
	//Stop Music - crussom
	level notify("endmusicpackage");
	
	level thread teleport_player();
	
	VisionSetNaked( "whites_estate_house" );
	
	setExpFog( 400, 600, 0.25, 0.25, 0.25, 0, 0.55 );
	
	flag_set("explosion_done");
	
	level.turn_off_flicker = true;
	
	//wait(1.0);
	
	cameraID = level.player customCamera_Push( "world", (579.33, -510.2, 424.44), (0.11, -134.54, 0));
	
	level thread monitor_sparks();
	
	wait(1.0);
	
	level.player customCamera_change( cameraID, "world", (637.9, -463.48, 424.44), (2.27, -138.65, 0), 2.0, 0.5, 1.0);
	
	wait(3.0);
	
	level.player customCamera_pop( cameraID, 3.0 );
}

teleport_player()
{
	level.player setorigin((654, -471, 369));
	level.player setplayerangles((0, -200, 0));
}


explode_server_room()
{
	push = getent("origin_hack_push", "targetname");
	
	letterbox_off(true);
	
	wait(2.0);
	
	holster_weapons();

	push playsound("whites_estate_house_hack_explosion");
	
	wait(0.3);
	
	level.player playsound("whites_estate_house_hack_explosion2");
	
	level.player shellshock("whites", 5.0);
	
	earthquake (0.7, 5.0, level.player.origin, 200, 15.0 );
	
	wait(0.1);
	
	physicsExplosionSphere((571, -519, 408), 200, 200, 15);
	
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
	
	wait(4.0);
	
	level.player shellshock("whites", 3.0);
	
	level.player playsound("whitesestate_tank_explosion");
	
	earthquake (0.4, 3.0, level.player.origin, 200, 10.0 );
	level.player playsound("whites_estate_house_generic_explosion");
	
	wait(2.0);
	
	level.player playloopsound("AMB_WhitesEstate_Chaos");
	
	level.player shellshock("whites", 2.0);
	
	earthquake (0.4, 2.0, level.player.origin, 200, 8.0 );
	level.player playsound("whites_estate_house_generic_explosion");
	
	
	wait(1.0);
	
	earthquake (0.4, 4.0, level.player.origin, 200, 6.0 );
	level.player playsound("whites_estate_house_exterior_explosion");
	
	//House Explosion Music - crussom
	level notify("playmusicpackage_house");
	
	wait(1.5);
	
	level.player FreezeControls( false );
	
	unholster_weapons();
	
	maps\_autosave::autosave_now("whites_estate");
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
	 
	origin playsound("whitesestate_sparks2");
	
	playfx (level._effect["monitor_sparks"], (554, -534, 394));
	radiusdamage((554, -534, 394), 80, 20, 20);
		
	wait(0.4);
	
	level.player playsound("whites_estate_elec_explosion");
	
	playfx (level._effect["monitor_sparks"], (547, -541, 408));
	radiusdamage((547, -541, 408), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (579, -560, 414));
	//radiusdamage((579, -560, 414), 80, 10, 10);
	
	wait(0.4);
	
	playfx (level._effect["monitor_sparks"], (532, -510, 414));
	radiusdamage((532, -510, 414), 80, 10, 10);
	
	wait(0.3);
	
	playfx (level._effect["monitor_sparks"], (532, -510, 437));
	radiusdamage((532, -510, 437), 80, 10, 10);
	
	wait(0.3);
	
	playfx (level._effect["monitor_sparks"], (550, -556, 437));
	radiusdamage((550, -556, 437), 80, 10, 10);
	
	wait(0.2);
	
	playfx (level._effect["monitor_sparks"], (535, -535, 437));
	radiusdamage((535, -535, 437), 80, 10, 10);
	
	wait(0.5);
	
	playfx (level._effect["monitor_sparks"], (550, -554, 413));
	radiusdamage((550, -554, 413), 80, 10, 10);
	
	wait(0.2);
	
	playfx (level._effect["monitor_sparks"], (534, -535, 413));
	radiusdamage((534, -535, 413), 80, 10, 10);
	
	radiusdamage((571, -519, 408), 80, 100, 100);
	
	wait(0.1);
	
	setplayerignoreradiusdamage(false);
}


house_fire_setup()
{
	fire_door = getentarray("collision_fire_door", "targetname");
	for (i=0; i<fire_door.size; i++)
	{
		fire_door[i] trigger_on();
	}
	
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
	
	clip_server = getentarray("clip_server_destroyed", "targetname");
	for (i=0; i<clip_server.size; i++)
	{
		clip_server[i] trigger_on();
	}
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



///////////////////////////////////////////////////////////////////////////////////////
//	First house guards after explosions start
///////////////////////////////////////////////////////////////////////////////////////
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
	
	//knock01 = getent("origin_knockover_01", "targetname");
	//knock02 = getent("origin_knockover_02", "targetname");
	
	//physicsExplosionSphere(knock01.origin, 10, 10, 10);
	//wait(0.5);
	//physicsExplosionSphere(knock02.origin, 10, 10, 10);
	
	//wait(2.0);
	
	level thread trigger_floor_collapse();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Ceiling tiles fall
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Outside explosion
///////////////////////////////////////////////////////////////////////////////////////
outside_explosion()
{
	trigger = getent("trigger_outside_explosion", "targetname");
	trigger waittill("trigger");
	
	level thread painting2_fall();
	level thread painting3_fall();
	
	level notify("painting_01_start");
	
	exp = getent("origin_outside_explosion", "targetname");
	
	physicsExplosionSphere( exp.origin, 100, 100, 10 );
	
	earthquake (0.6, 1.2, level.player.origin, 700, 10.0 );
	
	exp playsound("whites_estate_house_generic_explosion");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Ambient explosions
///////////////////////////////////////////////////////////////////////////////////////
ambient_explosion()
{
	level.player playsound("whites_estate_house_generic_explosion");
	
	wait(0.1);
	
	earthquake (0.7, 1.0, level.player.origin, 200, 10.0 );
}


exit_atrium()
{
	trigger = getent("trigger_helipad_objective", "targetname");
	trigger waittill("trigger");
	
	level.exit_atrium = true;
}



///////////////////////////////////////////////////////////////////////////////////////
//	Painting on third floor falls
///////////////////////////////////////////////////////////////////////////////////////
painting2_fall()
{
	trigger = getent("trigger_painting_02", "targetname");
	trigger waittill("trigger");
	
	earthquake (0.5, 1.0, level.player.origin, 700, 10.0 );
	
	trigger playsound("whites_estate_house_generic_explosion");
	
	level notify("painting_02_start");
	
	wait(1.0);
	
	level thread ambient_explosion();
}


painting3_fall()
{
	trigger = getent("trigger_painting_03", "targetname");
	trigger waittill("trigger");
	
	earthquake (0.5, 1.0, level.player.origin, 700, 10.0 );
	
	trigger playsound("whites_estate_house_generic_explosion");
	
	level notify("painting_03_start");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Explosion causes third floor segment to collapse
///////////////////////////////////////////////////////////////////////////////////////
explode_third_floor()
{
	//table = getent("desk_1", "targetname");
	clip = getent("clip_desk", "targetname");
	
	level thread ambient_explosion();
	
	explosion = getent("origin_explosion_floorfall", "targetname");
	exp = getent("origin_explosion_rail", "targetname");
	exp2 = getent("origin_explosion_desk", "targetname");

	physicsExplosionSphere( exp2.origin, 100, 100, 1 );
	physicsExplosionSphere( exp.origin, 100, 100, 1 );
	
	//table delete();
	
	radiusdamage(explosion.origin, 200, 200, 200);
	radiusdamage(exp.origin, 200, 200, 200);
	
	coll_third_floor = getent("collision_third_floor", "targetname");
	coll_third_floor trigger_on();
	
	//clip movez(-128, 0.05);
	
	wait (0.1);
	
	//clip disconnectpaths();
	
	wait(0.1);
	
	clip delete();
	
	wait(0.5);
	
	explosion delete();
	exp delete();
	exp2 delete();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Lookat trigger for balcony victim
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Explosion on second floor
///////////////////////////////////////////////////////////////////////////////////////
explosion_second_floor()
{
	trigger = getent("trigger_balcony_victim", "targetname");
	trigger waittill("trigger");
	
	level thread villa_blow_car_early_func();
	//level thread car_boom_func();
	
	explosion = getent("origin_balcony_victim", "targetname");
	spawner = getent("spawner_balcony_victim", "targetname");
	node = getnode("node_balcony_victim", "targetname");
	
	victim = spawner stalingradspawn("balcony_victim");
	victim setperfectsense(true);
	victim allowedstances("stand");
	victim.accuracy = 0.5;
	
	level thread trigger_balcony_explosion();
	
	flag_wait("balcony_victim");
	
	radiusdamage(explosion.origin, 120, 100, 100);
	
	earthquake (0.7, 1.0, level.player.origin, 700, 10.0 );
	
	level notify ( "fires_27" );
	level notify ( "fires_28" ); 
	level notify ( "fires_29" ); 
	level notify ( "fires_30" );
}



///////////////////////////////////////////////////////////////////////////////////////
//	Statue on second floor fall
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Statue on first floor fall
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Guards come in through front door
///////////////////////////////////////////////////////////////////////////////////////
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
	
	level thread exit_atrium();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Glass in atrium breaks
///////////////////////////////////////////////////////////////////////////////////////
atrium_glass_break()
{
	trigger = getent("trigger_glass_atrium", "targetname");
	trigger waittill("trigger");
	
	wait(2.7);
	
	level.player playsound("whites_estate_rumble_sound");
	
	level thread roof_corner_explosion();
	
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
	
	wait(2.0);
	
	stop_explosions = false;
	num_explosions = 0;
	
	while(!stop_explosions)
	{
		level thread ambient_explosion();
		
		num_explosions++;
		
		if (level.exit_atrium || num_explosions > 6)
		{
			stop_explosions = true;
		}
		
		rand = randomintrange(3, 8);
	
		wait(rand);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn atrium blast victim
///////////////////////////////////////////////////////////////////////////////////////
spawn_atrium_victim()
{
	spawner = getent("atrium_victim", "targetname");
	explosion = getent("origin_atrium_victim", "targetname");
	
	victim = spawner stalingradspawn("atrium_victim");
	
	victim setenablesense(false);
	
	flag_wait("atrium_victim");
	
	radiusdamage(explosion.origin, 90, 160, 160);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn house helicopter
///////////////////////////////////////////////////////////////////////////////////////
spawn_heli_house()
{	
	//spawnpt = getent("origin_house_helispawn", "targetname");
	flypt01 = getent("origin_house_helipt01", "targetname");
	flypt02 = getent("origin_house_helipt02", "targetname");
	flypt03 = getent("origin_house_helipt03", "targetname");
	flypt04 = getent("origin_house_helipt04", "targetname");
	flypt05 = getent("origin_house_helipt05", "targetname");
	looktarget = getent("objective2_marker", "targetname");
		
	//heli = spawnvehicle("v_heli_private", "heli_greenhouse", "blackhawk", spawnpt.origin, spawnpt.angles);
	
	heli = getent("heli_house", "targetname");
	
	heli show();
	heli trigger_on();
	
	heli.health = 99999;
	
	heli playloopsound("police_helicopter");
	
	playfxontag( level._effect[ "copter_dust" ], heli, "tag_turret" );
		
	heli setspeed(60, 40);
	heli setvehgoalpos ((flypt01.origin), 0);
	heli waittill ( "goal" );
	heli setvehgoalpos ((flypt02.origin), 1);
	heli waittill ( "goal" );
	heli setspeed(20, 10);
	heli setvehgoalpos ((flypt03.origin), 1);
	heli waittill ( "goal" );
	heli setLookAtEnt( level.player );
	
	heli thread clear_lookat();
	
	level thread check_water_tank();
	
	while(!level.gotime)
	{
		if (heli.health < 10000)
		{
			level.gotime = true;
		}
		
		wait(0.3);
	}
	
	wait(2.0);
	
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
	//heli setvehgoalpos ((975, 2355, -285), 0);
	heli setvehgoalpos ((30562, 6647, 7377), 0);
	
	heli waittill ( "goal" );
	
	heli stoploopsound();
	
	if (isdefined(heli))
	{
		heli delete();
	}
}


clear_lookat()
{
	wait(2.0);
	
	self clearLookAtEnt();
}



heli_shake_greenhouse()
{
	glass = getentarray("origin_heli_glass", "targetname");
	
	wait(2.5);
	
	earthquake (0.25, 4.0, level.player.origin, 700, 8.0 );
	
	for (i=0; i<glass.size; i++)
	{
		playfx (level._effect["whites_greenhouse_glass1"], glass[i].origin );
		//playfx (level._effect["whites_greenhouse_glass1"], glass[i].origin+(52, 143, 0) );
		//playfx (level._effect["whites_greenhouse_glass1"], glass[i].origin+(-52, -143, 0) );
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



///////////////////////////////////////////////////////////////////////////////////////
//	VO explosions start
///////////////////////////////////////////////////////////////////////////////////////
vo_explosions_start()
{
	level waittill ( "white_blows_estate" );
	
	level thread open_piano_gate();
	
	trigger = GetEnt( "vision_set_outside", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_wait("helipad_located");
	
	level thread vo_white_end();
	
	//flag_wait("white_stopped");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Open gates to piano room
///////////////////////////////////////////////////////////////////////////////////////
open_piano_gate()
{
	door01 = getent("gate_l", "targetname");
	door02 = getent("gate_r", "targetname");
	
	//door01 delete();
	//door02 delete();
	
	door01 rotateyaw(150, 1.0);
	door02 rotateyaw(-150, 1.0);
}



///////////////////////////////////////////////////////////////////////////////////////
// Fire sounds in house
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Check White's helicopter for damage
///////////////////////////////////////////////////////////////////////////////////////
check_helicopter()
{
	vehicle = GetEnt( "copter_fly_land", "targetname" );
	takeoff = getent("origin_heli_takeoff", "targetname");
	
	vehicle.health = 10000;
	
	vehicle thread check_damage();
	
	flyaway = 0;
	
	flag_wait("helipad_located");
	
	while((vehicle.health) > 9900)
	{
		wait(0.25);
		flyaway++;
		if (flyaway > 40)
		{
			vehicle setspeed( 40, 40 );
			vehicle setvehgoalpos (takeoff.origin, 0 ); 
			
			if (!level.mission_succeeded)
			{
				missionfailedwrapper();
			}
		}
	}
	
	level thread heli_damaged();
}


heli_damaged()
{
	vehicle = GetEnt( "copter_fly_land", "targetname" );
	crash = getent("origin_heli_crashface", "targetname");
	
	if (!level.heli_damage_path)
	{
		level.heli_damage_path = true;
		
		vehicle setspeed( 45, 30 );
		vehicle setLookAtEnt(crash);
		
		wait(1.0);
		
		vehicle setvehgoalpos(crash.origin, 0);
		vehicle waittill ( "goal" );
		vehicle setvehgoalpos((2850, -1369, 691), 0);
		vehicle waittill ( "goal" );
	
		level thread heli_shot_down();
	}
}


heli_shot_down()
{
	if (!level.mission_succeeded)
	{
		level.mission_succeeded = true;
		level thread mission_success();
	}
}


check_damage()
{
	damaged = false;
	
	while(!damaged)
	{
		if (self.health < 10000)
		{
			//playfxontag( level._effect[ "whites_heli_smoke_emit_2" ], self, "tag_origin" );
			playfxontag( level._effect[ "whites_heli_smoke_emit_2" ], self, "tag_engine_right" );
			playfxontag( level._effect[ "monitor_sparks" ], self, "tag_engine_right" );
			wait(0.3);
			playfxontag( level._effect[ "monitor_sparks" ], self, "tag_engine_right" );
			damaged = true;
		}
		
		wait(0.1);
	}	
}


check_white()
{
	white = getent("mrwhite", "targetname");
	
	white.health = 10000;
	
	while((white.health) > 9900)
	{
		wait(0.25);
	}
	
	level thread heli_damaged();
}



///////////////////////////////////////////////////////////////////////////////////////
//	White sitting in chopper
///////////////////////////////////////////////////////////////////////////////////////
chopper_sit()
{
	chopper = getent( "copter_fly_land", "targetname" );
	
	self teleport(chopper GetTagOrigin("tag_passenger"), (chopper GetTagAngles("tag_passenger")+ (0,0,0)), true);
	
	self LinkTo(chopper, "tag_passenger", (-100,0,-16), (0,0,0));
	
	self setenablesense( false );
	
	self cmdplayanim("Gen_Civs_SitIdle_E", true);
}



///////////////////////////////////////////////////////////////////////////////////////
//	Mission Success
///////////////////////////////////////////////////////////////////////////////////////
mission_success()
{
	level.player FreezeControls( true );
	// added by Steve Crowe to fix crash when opening phone after shooting helicopter down
	if ( level.ps3 ) {
		setDvar("cg_disableBackButton", "1");
		forcephoneactive(false);
	}
	
	flag_set("white_stopped");
	
	//giveachievement( "Progression_Whites" );
	
	//cinematicingame( "Open_Credits" );
	//cinematic("Open_Credits");
	
//	uncomment the next line once the xanim assert is fixed
	//SetSavedDVar("cg_draw2D", "0");
	//SetDVar("missionsuccess_movie", "Open_Credits");
		
	/*if ( level.white_shot == 0 )
	{
		changelevel( "siena", false, 0  );
	}*/
	
	maps\_endmission::nextmission();
}
///////////////////////////////////////////////////////////////////////////////////////
//	Open Safe Door
///////////////////////////////////////////////////////////////////////////////////////
open_saferoom_door()
{
	//open door at start.  no sound needed.
	door = getent("3rd_floor_door", "targetname");
	if(IsDefined(door))
	{
		knob = getent(door.target, "targetname");
		if(IsDefined(knob))
		{
			knob linkto(door);
		}
		door rotateyaw(100, 0.5);
		door ConnectPaths();
	}

	// close when ready.	
	level waittill("close_saferoom_door");
	if(IsDefined(door))
	{
		door rotateyaw(-100, 0.5);
		door disconnectpaths();
		//door playsound("whites_estate_boathouse_door");
	}			 
}	

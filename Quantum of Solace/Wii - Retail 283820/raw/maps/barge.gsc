#include maps\_utility;

#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\barge_util;
#using_animtree("generic_human");









main()
{
	
	maps\barge_fx::main();
	maps\_playerawareness::init();							
	maps\_securitycamera::init();			
	maps\_load::main();
	maps\barge_amb::main();     
	maps\barge_mus::main();
	
	
	
	
	
	
	precacheShader( "compass_map_barge" );
	setminimap( "compass_map_barge", 5704, 4656, -1336, -432 );



	
	
	
	
	
	
	PrecacheCutScene("Barge_Intro");
	PrecacheCutScene("Barge_Intro_LoopEnd");
	
	
	PrecacheCutScene("Barge_Kratt_Pull");
	PrecacheCutScene("Barge_Drop");
  


	
	flag_init("super_tilt");
	flag_init("tilting");
	
	
	
	
	level thread maps\_distraction::distract_init();
	
	
	
	level.player allowprone( false );
	maps\_phone::setup_phone();											
	
	
 	setDVar( "cg_laserAiOn", 1 );       

	precacheRumble("damage_light");	
	precacheRumble("damage_heavy");
	
	precacheitem("VTAK31_Barge");
	PreCacheItem("FRWL_Barge");
	
	PreCacheItem("flash_grenade");
	PreCacheItem("w_t_grenade_flash");
	Precachemodel("w_t_pipe");
	
	precacheShellshock( "default" );
	precacheshellshock ("flashbang");


	
	
	level.strings["barge_power_hint_name"] = &"BARGE_POWER_HINT_NAME";
	level.strings["barge_power_hint_body"] = &"BARGE_POWER_HINT_BODY";
	
	level.strings["barge_data_one_name"] = &"BARGE_DATA_ONE_NAME";
	level.strings["barge_data_one_body"] = &"BARGE_DATA_ONE_BODY";
	
	level.strings["barge_data_two_name"] = &"BARGE_DATA_TWO_NAME";
	level.strings["barge_data_two_body"] = &"BARGE_DATA_TWO_BODY";
	
	level.strings["barge_data_three_name"] = &"BARGE_DATA_THREE_NAME";
	level.strings["barge_data_three_body"] = &"BARGE_DATA_THREE_BODY";
	
	level.strings["barge_data_four_name"] = &"BARGE_DATA_FOUR_NAME";
	level.strings["barge_data_four_body"] = &"BARGE_DATA_FOUR_BODY";
	
	level.strings["barge_data_five_name"] = &"BARGE_DATA_FIVE_NAME";
	level.strings["barge_data_five_body"] = &"BARGE_DATA_FIVE_BODY";
	
	level.strings["barge_data_six_name"] = &"BARGE_DATA_SIX_NAME";
	level.strings["barge_data_six_body"] = &"BARGE_DATA_SIX_BODY";
	
	level.strings["barge_data_seven_name"] = &"BARGE_DATA_SEVEN_NAME";
	level.strings["barge_data_seven_body"] = &"BARGE_DATA_SEVEN_BODY";
	
	
	
	if( Getdvar( "artist" ) == "1" )
	{
		return; 
	}
	else if (Getdvar( "skipto" ) == "roof" )
	{
		ori2 = getent( "cargo_stairs", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles));
		
		
	}
	else if (Getdvar( "skipto" ) == "sniper" )
	{
		ori2 = getent( "sniper_pos", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles));   
		level notify ("sniper_guard");
		level thread give_weapons2();
		level thread sniper_start();
	}
	else if (Getdvar( "skipto" ) == "road" )
	{
		ori2 = getent( "road_ori", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles)); 
		level thread give_weapons2();
		level notify ("sniper_guard");  
		level notify( "trunk_open" );
		level.sniper_vesper = getent("secret_vesper", "targetname")  stalingradspawn( "Svesper" );
		
		
		
		
	}
	else if (Getdvar( "skipto" ) == "warehouse" )
	{
		ori2 = getent( "warehouse_end", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles)); 
		level thread give_weapons2(); 
		level notify ("sniper_guard"); 
		level notify( "trunk_open" );
		level.sniper_vesper = getent("secret_vesper", "targetname")  stalingradspawn( "Svesper" );
	}
	else if (Getdvar( "skipto" ) == "cargo" )
	{
		ori2 = getent( "cargo_crash_player_ori", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles));  
		level thread give_weapons2();
		level notify ("sniper_guard"); 
		level notify( "trunk_open" );
	}
	else if(Getdvar( "skipto" ) == "top" )
	{
		ori2 = getent( "roof_top", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles)); 
		level thread give_weapons2();
		level notify ("sniper_guard"); 
		
		
		
		
	} 
	
	else
	{
		
		level.player setorigin((2037.6, 3544 ,105));   
		level.player setplayerangles((-0, 298.4, 0));
		level.player allowStand(false);
		level.player allowcrouch(true);
		level thread car_trunk();
		
		
		
	}
	

	
	

	
	
	
	

	
	
	
	level thread global_smoke_from_exhaust_ports();
	level thread global_full_light_flicker();
	level thread global_small_light_flicker();
	level thread global_long_light_flicker();
	
	

	


	level.deck_event = 0;
	level.puzzle_var = 0;
	level.roof_fog_var = 0;
	level.crane_var = 0;
	level.control_door = 0;
	level.bdrft_var = 0;
	
	
	level.puzzle_var_real = 0;
	level.puzzle_var_real2 = 0;
	level.puzzle_var_real3 = 0;
	
	level.puzzle_var_meter = 0;
	level.puzzle_var_meter2 = 0;
	level.puzzle_var_meter3 = 0;
	
	level.puzzle_button_var = 0;
	
	
	
	level.sniper_event = 0;
	level.night_vision = 0;
	level.attach_toggle = 0;
	level.spotlight_var = 0;
	level.spotted_var = 0;
	level.vesper_grab = 0;
	level.window_reset = 0;
	
	level.sniper_event2 = 0;
	
	
	level.kratt_light_var = 0;
	level.vesper_guidance_var = 0;
	level.spot_death_var = 0;
	level.kratt_fight_var= 0;
	level.ware_door_var = 0;
	
	level.spark_var = 0;

	level thread global_vesper_screams01();
	
	
	
	level thread global_fire_ext_triggers();
	

	
	
	
	level thread out_of_car_savegame_trigger();
	
	level thread hilltop_trigger();
	
	level thread barge_tank2();
	
	level thread barge_tank4();
	
	level thread exit_to_side();
	
	level thread side_to_roofT();
	
	level thread deck_fire_spawns();
	
	level thread checkpoint_deck01();
	
	
	
	level thread cargo_enemies();
	
	

	level thread stern_spawn_thug_five();

	
	
	level thread deck_fire_spawn_think();

	
	level thread top_of_stairsT();
	
	level thread canopy_al_checks();
	
	
	
	
	
	
	
	
	level thread deck_checkp1();
	
	level thread corridor_tanks();  
	
	level thread backdraft_ai_trigger();
	
	level thread e1_two_trigger();
	
	level thread awareness_cameras();
	
	level thread trap_door();
	
	level thread warehouse_save_pointT();
	
	level thread warehouse_drop_down();
	
	
	
	
	
	
	
	level thread bow_cargo_crashT();
	
	level thread stairs_runawayT();
	
	
	
	
		
	level thread warehouse_transition_saveT();
	
	level thread barge_vision_triggers();
	level thread barge_vision2_triggersA();

	
	
	
	
	
	level thread deck_fire3();
	level thread deck_fire4();
	level thread deck_fire();
	level thread corridor_pipe();
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	level maps\_playerawareness::setupSingleUseOnlyNoWait( "trap_door_useT", ::trap_door_use, &"BARGE_OPEN_CARGO_DOORS", 0, "Opening Cargo Door", undefined, undefined, undefined, level.awarenessMaterialNone, 1, 0);
	
	
	level maps\_playerawareness::setupSingleUseOnly ( "deck_use1T", ::deck_use1T, "distraction", 1, "activated", 1, 0, undefined, 0, 0, 0);
	
	
	
		
	setExpFog(0, 5000, 0.206, 0.241, 0.261, 0.01, 0.569);
	  
	maps\_sea::main();
	level._sea_litebob_scale = 10;
		
	level thread give_weapons();
		
	

	
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

}



pip_setup()
{
	if( getdvar( "pip_off") != "true")
	{
		SetDVar("r_pipSecondaryX", 0.05);
		SetDVar("r_pipSecondaryY", 0.05);						
		SetDVar("r_pipSecondaryAnchor", 0);						
		SetDVar("r_pipSecondaryScale", "0.5 0.5 1.0 1.0");		
		SetDVar("r_pipSecondaryAspect", false);					
		level.player setsecuritycameraparams( 55, 3/4 );
		level.cameraID_vesper = level.player SecurityCustomCamera_Push("entity_abs", level.player, level.player, (-150.0, 0.0, 200.0), (0.0, 0.0, 0.0), (0.0, 0.0, 72.0), 0.0);
	}
}


out_of_car_savegame_trigger()
{

	trigger = getent("out_of_car_savegame_trigger", "targetname");
	level waittill ("Barge_Intro_Done");
	trigger waittill("trigger");
	wait(1);
	
	thread maps\_autosave::autosave_now("barge");
	
}


trunk()
{     
	
	
	wait(1);
	SetDVar("r_pipMainMode", 1);     
	
	SetDVar("r_pip1Anchor", 8 );                                                                   
	SetDVar("r_pip1Scale", "1 0.05 0 0");                  
	level waittill("open_trunk");
	
	
	
	for( i = 0.05; i < 1; i = i + 0.04)
	{
		SetDVar("r_pip1Scale", "1 "+ i +" 0 0" );              
		wait( 0.05);
	}       
	level notify( "trunk_open" );
	
	SetDVar("r_pipMainMode", 0);     
}


hide_the_pip()
{
	level.introblack = NewHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack.alpha = 1;
	level.introblack SetShader( "black", 640, 480 );
	level.introblack fadeOverTime( 8.0 );
	level.introblack.alpha = 0; 
}


post_fx_over_intro()
{
	
	wait(0.01);
	VisionSetNaked( "Barge_Awaken", 0.001 );
	wait(9.35);
	VisionSetNaked( "Barge_0", 0.01 );
	wait(6.65);
	VisionSetNaked( "Barge_Awaken2", 0.01 );
	wait(2.45);
	VisionSetNaked( "Barge_0", 0.01 );
	
	level.player waittillmatch( "anim_notetrack", "_end");
	VisionSetNaked( "Barge_dark", 0.75 );
	level thread opening_vo();
	wait(1.5);
	VisionSetNaked( "Barge_0", 2);
}






car_trunk()
{
	
	
	maps\_utility::holster_weapons();
	setsaveddvar ( "ammocounterhide", "1" );

	
	cam = [];
	cam1 = getent("warehouse_cam1", "targetname");
	cam2 = getent("warehouse_cam2", "targetname");
	
	cam = add_to_array(cam, cam1 );
	cam = add_to_array(cam, cam2 );
	
	cam_view1 = getent("warehouse_view_cam", "targetname");
	cam_view2 = getent("docks_view_cam", "targetname");
	cam_view3 = getent("bd_view_cam", "targetname");

	cam_views = [];
	cam_views = add_to_array(cam_views, cam_view1 );
	cam_views = add_to_array(cam_views, cam_view2 );
	cam_views = add_to_array(cam_views, cam_view3 );

	
	
	
	
	
	door2 = getent("warehouse_door_1", "targetname");
	door2 movex(500, 1);
	
	
	
	
	wait(0.02);
	playcutscene("Barge_Intro", "Barge_Intro_Done");
	
	level thread display_chyron();
	
	level thread post_fx_over_intro();
	
	
	letterbox_on(false, false);
	
	
	
	
	
	
	
	level notify("playmusicpackage_stealth");
	
	
	
	wait(1.0);
	level.player playsound("BRG_intro");
	level waittill("Barge_Intro_Done");
	
	level thread hide_the_pip(); 
	playcutscene("Barge_Intro_LoopEnd", "Loop_end");

	
	
	level.player freezecontrols(false);
	
	wait(0.05);
	letterbox_off();
	door2 movex(-550, 0.1);
	
	level thread trailer_trash();
	level thread trailer_crouch_trigger();
	

	
	
	
	
	
	
	wait(0.05);
	ori1 = getent("out_of_car_ori", "targetname");

	ang = ori1.angles;
	level.player setplayerangles(ori1.angles);
	level.player setorigin(ori1.origin);
	
	wait(0.15);	
	level thread sniper_in_the_window();
	level.player playerSetForceCover(true, (0,-1, 0) );
	
	obj_ori = getent("wareh_obj_ori", "targetname");
	objective_add(1, "active", &"BARGE_INVESTIGATE_WAREHOUSE", (obj_ori.origin), &"BARGE_INVESTIGATE_WAREHOUSE_INFO" );
	wait(0.1);
	hack_box1 = getent("cam_hack_box_one", "targetname");
	hack_box2 = getent("cam_hack_box_two", "targetname");

	
	cam1 thread maps\_securitycamera::camera_start(hack_box1, true, true, false);	
	cam2 thread maps\_securitycamera::camera_start(hack_box2, true, true, false);	
	
	
	cam_view1 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	cam_view2 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	cam_view3 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);	
	
	wait(0.2);
	
	feedbox = getent("feed_box_one","targetname");
	level thread maps\_securitycamera::camera_tap_start(feedbox, cam_views );
	
	level thread fence_audio_cam1();
	level thread fence_audio_cam2();
	setSavedDvar( "sf_compassmaplevel", "level1" );
	level thread fans();
	level thread trailer_shutter();
	
	trigger = getent("car_trunkT", "targetname");
	wait(3);
	
	level.player playerSetForceCover(false,false);
	level.player allowStand(true);
	trigger delete();
	
	VisionSetNaked( "Barge_0", 20 );
	level thread warehouse_door_save();
}

opening_vo()
{
	level.player play_dialogue("BOND_BargG_501A");
	level.player play_dialogue("TANN_BargG_502A", 1);
	
	wait(1.3);
	
	level.player play_dialogue("BOND_BargG_503A");
	level.player play_dialogue("TANN_BargG_504A", 1);
	x = randomfloatrange(0.5, 2.5);
	wait(x);
	ori = getent("wareh_obj_ori", "targetname");
	ori playsound("BRG_foghorn");
}



trailer_crouch_trigger()
{
	trigger = getent("trailer_crouch_trigger", "targetname");
	while(1)
	{
		if(level.player istouching(trigger))
		{
			if(level.player getstance()!= "crouch")
			{
				level notify("trailer_trash");
				break;
			}
		}
	 wait(0.2);
	}
}

fence_audio_cam1()
{
	cam1 = getent("warehouse_cam1", "targetname");
	cam1 waittill("spotted");
	cam1 playsound("BRG_fence_hop");
	level notify("trailer_trash");
	level thread flash_axis_array();
}

fence_audio_cam2()
{
	cam2 = getent("warehouse_cam2", "targetname");
	cam2 waittill("spotted");
	cam2 playsound("BRG_fence_hop");
	level notify("trailer_trash");
	level thread flash_axis_array();
}

flash_axis_array()
{
	wait(1);
	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++  )
	{
		array_ai[i] thread flash_sense();
  }
}

trailer_shutter()
{
	shutter = getent("trailer_shutter", "targetname");
	trigger1 = getent("trailer_trigger1", "targetname");
	trigger2 = getent("trailer_trigger2", "targetname");
	trigger1 waittill("trigger");
	trigger2 waittill("trigger");
	shutter playsound("BRG_shutter");
	shutter rotateyaw(110, 1, 0.3, 0);
	shutter waittill("rotatedone");
	shutter rotateyaw(-110, 1, 0, 0.5);
	shutter waittill("rotatedone");
	shutter rotateyaw(-110, 2, 0, 1.7);
}

trailer_trash()
{
	shack_door = getent("monster_door", "targetname");
	guy1 = getent("trailer_trash1" , "targetname")  stalingradspawn();
	guy2 = getent("trailer_trash2" , "targetname")  stalingradspawn();
	guy1 thread trailer_death(); 
	guy2 thread trailer_death();

	guy1 setalertstatemax("alert_green");
	guy2 setalertstatemax("alert_green");
	guy1 setscriptspeed("walk");
	guy2 setscriptspeed("walk");
	guy1 startpatrolroute("trailer1");
	guy2 startpatrolroute("trailer2");
	
	level waittill("trailer_trash");
	shack_door rotateyaw(75, 1, 0.1, 0.8);
	shack_door connectpaths();
	guy1 thread trailer_alert();
	guy2 thread trailer_alert();
}

trailer_alert()
{
	self setalertstatemin("alert_red");
}	

trailer_death()
{
	self waittill("damage");
	level notify("trailer_trash");
}

trailer_talk1()
{
	self cmdaction("TalkA1");
}

trailer_talk2()
{
	self cmdaction("TalkA2");
}

television_origin1()
{
	
	
	light = getent("tv_light", "targetname");
	while(1)
	{
		x = randomfloatrange(0.005, 0.05);
		z = randomfloatrange(0.01, 0.73);
		light setlightintensity (2);
		wait(x);
		light setlightintensity (0);
		wait(x);
		light setlightintensity (2);
		wait(x + z);
		light setlightintensity (0);
		wait(x);
		light setlightintensity (2);
		wait(x * z);
	}	
}



give_weapons()
{
	level thread global_unholster_count();
	level thread vtak_ammo_give();
	
	
	setsaveddvar ( "ammocounterhide", "0" );
	
	
	
	
	
	
	

	
	
	
	
	
}



global_unholster_count()
{
 	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++  )
	{
		array_ai[i] thread global_unholster();
  }
}



global_unholster()
{
	self waittill("death");
	maps\_utility::unholster_weapons();
	vtak_ammo_give();
}




vtak_ammo_give()
{
	while(1)
	{
	 	if(level.player HasWeapon( "VTAK31_Barge" ))
	 	{
	 		level.player GiveMaxAmmo( "VTAK31_Barge" );
	 		level.player SwitchToWeapon( "VTAK31_Barge" );
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	else if(level.player HasWeapon( "FRWL_Barge" ))
	 	{
	 		level.player SwitchToWeapon( "FRWL_Barge" );
	 		level.player GiveMaxAmmo( "FRWL_Barge" );
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	else if(level.player HasWeapon( "1911" ))
	 	{
	 		level.player SwitchToWeapon( "1911" );
	 		level.player GiveMaxAmmo( "1911" );
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	wait(1.0);
	}
}


give_weapons2()
{
	
	maps\_utility::unholster_weapons();
	level.player GiveWeapon( "p99_s" );
	level.player GiveWeapon( "VTAK31_Barge" );
	level.player giveweapon( "FRWL_Barge" );
	

	level.player GiveMaxAmmo ( "p99_s" );
	level.player GiveMaxAmmo ( "FRWL_Barge" );
	level.player GiveMaxAmmo( "VTAK31_Barge" );
	
	
}






hilltop_trigger()
{
	
	trigger = getent("hilltop_trigger", "targetname");
	trigger waittill("trigger");
	
	
	level notify("playmusicpackage_action");
	
	
	level thread sniper_end();
	ori = getent("corridor_pipe_ori3", "targetname");
	objective_add(5, "active", &"BARGE_RESCUE_VESPER", (ori.origin), &"BARGE_RESCUE_VESPER_INFO" );
	
	
	
	wait(2);
	
	
}




cnode_deck1()
{
 
	
}












sniper_in_the_window()
{
	
	
	guy1 = getent("sniper_free_man", "targetname") stalingradspawn( "guy1" );
	trigger4 = getent("alert_door_manT", "targetname");
	guy1 = getent("guy1", "targetname");
	guy1 lockalertstate("alert_green");
	
	sniper_trigger = getent("secret_sniper", "targetname");
	sniper_trigger trigger_off();
	level thread sniper_trigger_on();
	
	node = getnode("warehouse_door_node1", "targetname");
	node2 = getnode("warehouse_door_node2", "targetname");
	trigger = getent("warehouse_beforeT", "targetname");
	trigger2 = getent("warehouse_beforeT2", "targetname");
	
	
	level.first_sniper = getent("sniper_in_the_window", "targetname");
	level thread window_sniper_dcheck();
	
	
	
	level.first_sniper SetAlertStatemax("alert_red");
	level.first_sniper setscriptspeed("walk"); 
	guy1 setgoalnode(node);
	guy1 unlockalertstate();
	guy1 waittill("goal");
	
	guy1 setgoalnode(node2);
	guy1 thread guy_on_keyboard();
	
	door2 = getent("warehouse_door_1", "targetname");
	
	door2 playsound("BRG_warehouse_door_slide");
	trigger4 waittill("trigger");
	
	if(isalive(guy1))
	{
		guy1 play_dialogue("WMR1_BargG_007A"); 
		guy1 setalertstatemax("alert_red");
	}
	
	trigger waittill("trigger");
	if(!isalive(guy1))
	{
		
		if(isalive(level.first_sniper))
		{
			level.first_sniper startpatrolroute("warehouse_one");
		}
		wait(1);
		level thread ware_door_close();
		
		level.first_sniper waittill("death");
		level notify("sniper_guard");
		
	 	thread maps\_autosave::autosave_now("barge");
	}
	else
	{
		level thread ware_door_close();
		level.first_sniper SetAlertStatemin("alert_red");
		guy1 SetAlertStatemin("alert_red");
		level.first_sniper waittill("death");
		maps\_utility::unholster_weapons();
		level notify("sniper_guard");
		
		thread maps\_autosave::autosave_now("barge");
	}
}

window_sniper_dcheck()
{
	level.first_sniper waittill("death");
	level notify("sniper_guard");
}



guy_on_keyboard()
{
	node = getnode("warehouse_door_node2", "targetname");
	self waittill("goal");
	self cmdfaceangles(282, 0);
	self CmdAction( "TypeLaptop" );
	level thread play_laptop_sound();
}




play_laptop_sound()
{
	guy1 = getent("guy1", "targetname");
	ori = getent("laptop_origin", "targetname");
	
	guy1 endon("death");
	while(1)
	{
		if(isdefined(guy1))
		{
			if(guy1 getalertstate() == "alert_yellow" ) 
			{
				ori stoploopsound();
				wait(3);
				if(guy1 getalertstate() == "alert_green" )
				{
					guy1 CmdAction( "TypeLaptop" );
					guy1 cmdfaceangles(282, 0);
					level thread play_laptop_sound();
					break;
				}
				else
				{
					continue;
				}
	 		}
	 		else if(guy1 getalertstate() == "alert_red" )
	 		{
	 			
				level notify("trailer_trash");
				break;
			}
	 		else if(!isdefined(guy1))
	 		{
	 			
				break;
			}
		}
		else
		{
			
			break;
		}
	 	wait(0.5);
	}
}

warehouse_door_save()
{
	while(1)
	{
		if((level._ai_group["field_enemies"].aicount < 1) || (level.ware_door_var == 1))
		{
			thread maps\_autosave::autosave_by_name("barge");
			break;
		}
	 wait(0.5);
	}
}

ware_door_close()
{
	trigger = getent("warehouse_beforeT", "targetname");
	trigger waittill("trigger");
	x = gettime();
	while(1)
	{
		z = gettime();
		if(level.player istouching(trigger) && (z -133 > x)) 
		{
			door2 = getent("warehouse_door_1", "targetname");
			brush = getent("warehouse_door_brush1", "targetname");
			brush movez(100, 0.133);
			door2 movex(-60, 2.5, 0.2, 1.8);
			level thread door_crack_ori();
			door2 playsound("BRG_warehouse_door_slide");
			level.ware_door_var = 1;
			objective_state(1, "done");
			level thread update_objective_title();
			break;
		}
		wait(0.3);
	}
}

update_objective_title()
{
	wait(3);
	obj_ori = getent("wareh_obj_ori", "targetname");
	objective_add(11, "current", &"BARGE_INVESTIGATE_WAREHOUSE_TWO" , (obj_ori.origin), &"BARGE_INVESTIGATE_WAREHOUSE_TWO_INFO" ); 
}



door_crack_ori()
{
	ori = getent("door_crack_ori", "targetname");
	playfx (level._effect["dust"], ori.origin +(0, 0, 0));
	ori movex(-120, 1, 0.2, 0.8);
	wait(0.2);
	playfx (level._effect["dust"], ori.origin +(0, 0, 0));
	wait(0.2);
	playfx (level._effect["dust"], ori.origin +(0, 0, 0));
}
	
	

warehouse_door_move()
{
	door = getent("warehouse_door_1", "targetname");
	
	
	
	door movex(80, 10);
	
}






sniper_trigger_on()
{
	level waittill("sniper_guard");
	wait(0.34); 
	
	
	level notify("playmusicpackage_sniper");
	
	
	level thread sniper_start();
	level thread sniper_death_check();
	level thread spotlight_logic();
	
}



first_sniper_talk()
{
	radio = getent("warehouse_radio_ori", "targetname");
	level.first_sniper pausepatrolroute();
	

	
	level.first_sniper play_dialogue("BAM1_BargG_008A"); 
	
	if(isdefined(level.first_sniper))
	{
		level.first_sniper resumepatrolroute();
		level.first_sniper setscriptspeed("jog"); 
		level.first_sniper play_dialogue("BMR2_BargG_009A"); 
	}
	
	radio play_dialogue("RAD1_BargG_010A"); 
	
	radio play_dialogue("RAD2_BargG_011A"); 
	
	radio play_dialogue("RAD3_BargG_012A"); 
	
	
}


first_sniper_talk2()
{
	ori = getent("protect_vesper_obj_ori", "targetname");
	level.first_sniper aimatpos(ori.origin);
	level.first_sniper play_dialogue("WMR2_BargG_013A"); 
	if(isdefined(level.first_sniper))
	{
		level.first_sniper setscriptspeed("run"); 
		level.first_sniper play_dialogue("WMR2_BargG_016A");
	}
	if(level.night_vision == 0)
	{
		
	}
	else if(level.night_vision == 1)
	{
		
	}
}




initialize_sniper_pos1()
{
	sniper_pos1();
}

initialize_sniper_pos2()
{
	sniper_pos2();
}

initialize_sniper_pos3()
{
	sniper_pos3();
}


vesper_stop1()
{
}



spot_man()
{
	level.spot_man = getent("spotlight_man", "targetname")  stalingradspawn( "spot_man" );
	level.spot_man.tetherradius = 5; 
	level.spot_man SetAlertStatemax("alert_green");
	level.spot_man setengagerule("never");
	level.spot_man waittill("death");
	level.spotlight_var =77;
}

spotlight_damage_trigger()
{
	spotlight = getent("spotlight_one", "targetname");
	spotlight_dmg = getent("spotlight_one_dmg", "targetname");
	ori1 = getent("spotlight1_ori1", "targetname");
	ori2 = getent("spotlight1_ori2", "targetname");
	trigger = getent("spl_dmg_trg", "targetname");
	trigger waittill("trigger");
	
	
	
	
	playfx (level._effect["barge_electric_spark1"], spotlight.origin +(0, 0, 0));
	trigger waittill("trigger");
	playfx (level._effect["barge_electric_spark1"], spotlight.origin +(0, 0, 0));
	wait(0.05);
	playfx (level._effect["barge_electric_spark1"], spotlight.origin +(0, 0, 0));
	wait(0.05);
	playfx (level._effect["barge_electric_spark1"], spotlight.origin +(0, 0, 0));
	trigger waittill("trigger");
	playfx (level._effect["fxfire3"], spotlight.origin +(0, 0, 0));
	wait(4);
	
	level notify("spotlight_dead");
	playfx (level._effect["fxpumpgen"], spotlight.origin +(0, 0, 0));
	array = getentarray("fence_cage_apparatus", "targetname");
	level.spot_man dodamage(1000, (0,0,5));
	for (i = 0; i < array.size; i++)
	{
		array[i] delete(); 
	}
	physicsExplosionSphere( ori1.origin, 300, 10, 2 );
	ori1 radiusdamage(ori1.origin, 80,500,400);
	ori2 radiusdamage(ori2.origin, 80,500,400);
	level.spotlight_var =77;
	level.spotlight_tag delete();
	level.spot_death_var = 1;
	spotlight hide();
	spotlight_dmg show();
	
	
		
		
	
}

		
spotlight_logic()
{
	
	
	light_origin = getent("spotlight_script_origin", "targetname");
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	window_1 = getent(pos1.target, "targetname");
	window_2 = getent(pos2.target, "targetname");
	window_3 = getent(pos3.target, "targetname");
	idle_ori = getent("search_idle_ori", "targetname");
	spotlight_dmg = getent("spotlight_one_dmg", "targetname");
	spotlight_dmg hide();
	spotlight = getent("spotlight_one", "targetname");
	spotlight_arm = getent("spotlight_one_arm", "targetname");
	
	level.spotlight_tag = Spawn("script_model", spotlight.origin + (0, 0, 0));
	level.spotlight_tag SetModel("tag_origin");
	level.spotlight_tag.angles = spotlight.angles;
	level.spotlight_tag LinkTo(spotlight);
	PlayFxOnTag(level._effect["barge_spotlight"], level.spotlight_tag, "tag_origin");
	
	
	
	
	level thread spot_man();
	level thread spotlight_damage_trigger();
	level thread spotlight_random_search();
	spotlight thread spotlight_trace();
	z = randomintrange(1,2);
	while(level.sniper_event == 0)
	{
		if(level.spotlight_var == 1)
		{
			
			win = spotlight.origin - window_1.origin;
			winx = window_1.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin rotateto(VectorToAngles(winx)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if(level.spotlight_var == 2)
		{
			
			win2 = spotlight.origin - window_2.origin;
			winx2 = window_2.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win2)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin rotateto(VectorToAngles(winx2)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if(level.spotlight_var == 3)
		{
			
			win3 = spotlight.origin - window_3.origin;
			winx3 = window_3.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win3)+(0,-90, 0), 1, 0.5, 0.1);	
			light_origin rotateto(VectorToAngles(winx3)+( 0 , 0, 0), 1, 0.5, 0.1);	 
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if((level.spotlight_var == 0) && (level.spotted_var == 9))
		{
			
			
			
			
			
			
			
			level thread spotlight_random_search();
			level waittill("random_search_done");
			
		}
		else if(level.spotlight_var == 77)
		{
			win4 = spotlight.origin - idle_ori.origin;
			winx4 = idle_ori.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			
			
			
			break;
		}
		else
		{
			level thread spotlight_random_search();
			level waittill("random_search_done");
		}
		wait(0.2);
	}
}


spotlight_random_search()
{
		light_origin = getent("spotlight_script_origin", "targetname");
		pos1 = getent("sniper_pos1", "targetname");
		pos2 = getent("sniper_pos2", "targetname");
		pos3 = getent("sniper_pos3", "targetname");
		window_1 = getent(pos1.target, "targetname");
		window_2 = getent(pos2.target, "targetname");
		window_3 = getent(pos3.target, "targetname");
		spotlight = getent("spotlight_one", "targetname");
		r = randomfloatrange(0.4, 1.7);
		s = randomfloatrange(0.3, 2.1);
		w = randomfloatrange(0.2, 1.2);
		win[0] = window_1.origin - spotlight.origin;
		win[1] = window_2.origin - spotlight.origin;
		win[2] = window_3.origin - spotlight.origin;
		lamp = randomint(3);
		spotlight rotateto(VectorToAngles(win[lamp] )+(0, 90, 0), r, r/3, r/4);
		light_origin rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), r, r/3, r/4);
		spotlight waittill("rotatedone");
		lamp = randomint(3);
		spotlight rotateto(VectorToAngles(win[lamp])+(0, 90, 0), s, s/3, s/3);
		light_origin rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), s, s/3, s/4);
		spotlight waittill("rotatedone");
		lamp = randomint(3);
		spotlight rotateto(VectorToAngles(win[lamp])+(0, 90, 0), r, r/3, r/4);
		light_origin rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), r, r/3, r/4);
		spotlight waittill("rotatedone");
		lamp = randomint(3);
		spotlight rotateto(VectorToAngles(win[lamp])+(0, 90, 0), w, w/3, w/4);
		light_origin rotateto(VectorToAngles(win[lamp] )+(0, 0, 0), w, w/3, w/4);
		spotlight waittill("rotatedone");
		lamp = randomint(3);
		
		level notify("random_search_done");
}







sniper_pos1()
{
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	window_1 = getent(pos1.target, "targetname");
	pos1 waittill("trigger");
	level.window_reset = 0;
	level thread window_timer();
	while(level.sniper_event2 == 0)   
	{
		if ((level.player istouching(pos1)) && (level.player attackbuttonpressed()))
		{
	
			
			
			level.spotlight_var = 1;
			while(level.player istouching(pos1))
			{
				guys = getentarray("sniper_shooters", "targetname");
				
				
				z = randomfloatrange(0.1, 2.6);
				
				
				
				x = randomintrange(1, 3);
				for (i = 0; i < guys.size; i++)
				{
					guys[i] aimatpos(window_1.origin);
					wait(0.5);
					
					guys[i] cmdshootatentityxtimes(level.player, false, x , 0.33);
					
					self thread done_shooting();
				}
				wait(z);
			} 
		}
		else if(((level.player istouching(pos2)) || (level.player istouching(pos3))) && (level.spotlight_var == 1))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{	
				
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_1, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				sniper_pos1();
				break;
			}
		}
		else if (level.player istouching(pos1))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{	
				guys[i] stopallcmds();
				
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_1, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				
			}
		}
		wait(0.075);
	}
}



done_shooting()
{
	self waittill("cmd_done");
}


sniper_pos2()
{
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	window_2 = getent(pos2.target, "targetname");
	pos2 waittill("trigger");
	level.window_reset = 0;
	level thread window_timer();
	while(level.sniper_event2 == 0)   
	{
		if ((level.player istouching(pos2)) && (level.player attackbuttonpressed()))
		{

			
			
			level.spotlight_var = 2;
			while(level.player istouching(pos2))
			{
				guys = getentarray("sniper_shooters", "targetname");
				
				
				z = randomfloatrange(0.1, 2.7);
				
				
				s = randomintrange(1, 400);
				x = randomintrange(1, 3);
				for (i = 0; i < guys.size; i++)
				{
					guys[i] aimatpos(window_2.origin);
					wait(0.5);
					
					guys[i] cmdshootatentityxtimes(level.player, false, x , s);
					
					self thread done_shooting();
				}
				wait(z);
			}
		}
		else if(((level.player istouching(pos3)) || (level.player istouching(pos1))) && (level.spotlight_var == 2))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{
				
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_2, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				sniper_pos2();
				break;
			}
		}
		else if (level.player istouching(pos2))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{	
				guys[i] stopallcmds();
				
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_2, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				
			}
		}
		wait(0.075);
	}
}


sniper_pos3()
{
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	window_3 = getent(pos3.target, "targetname");
	pos3 waittill("trigger");
	level.window_reset = 0;
	level thread window_timer();
	while(level.sniper_event2 == 0)   
	{
		if ((level.player istouching(pos3)) && (level.player attackbuttonpressed()))
		{

			
			
			level.spotlight_var = 3;
			while(level.player istouching(pos3))
			{
				guys = getentarray("sniper_shooters", "targetname");
				
				
				z = randomfloatrange(0.1, 3.1);
				
				
				s = randomintrange(1, 350);
				x = randomintrange(1, 3);
				for (i = 0; i < guys.size; i++)
				{
					guys[i] aimatpos(window_3.origin);
					wait(0.5);
					
					guys[i] cmdshootatentityxtimes(level.player, false, x , s);
					
					self thread done_shooting();
				}
				wait(z);
			}
		}
		else if(((level.player istouching(pos2)) || (level.player istouching(pos1))) && (level.spotlight_var == 3))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{
				
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_3, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				sniper_pos3();
				break;
			}
		}
		else if (level.player istouching(pos3))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{	
				guys[i] stopallcmds();
				
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_3, true, 5 );
				level.spotted_var = 9;
				level.spotlight_var = 0;
				
			}
		}
		wait(0.075);
	}
}





window_timer()
{
	
	pos1 = getent("sniper_pos1", "targetname");
	pos2 = getent("sniper_pos2", "targetname");
	pos3 = getent("sniper_pos3", "targetname");
	x = gettime();
	while((level.player istouching(pos1)) || (level.player istouching(pos2)) || (level.player istouching(pos3)))   
	{
		z = gettime();
		if(z -3000 == x)
		{
			level.window_reset = 1;
			while(level.window_reset == 1)  
			{
				if(level.player istouching(pos1))
				{
					level thread bullet_wall_one();
					break;
				}
				else if(level.player istouching(pos2))
				{
					level thread bullet_wall_two();
					break;
				}
				else if(level.player istouching(pos3))
				{
					level thread bullet_wall_three();
					break;
				}
				wait(1);
			}
		}
		wait(1);
	}
}

bullet_wall_one()
{
	start_ent	= GetEnt( "bullet_wall_one", "targetname" );
	
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-35.0,35.0);
		z = randomfloatrange(-28.0, 28.0);
		
		
		firepos = start_ent.origin + ( (i*1.0)+x+3, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("vtak31_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		
		level.window_reset = 0;	
		
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}

bullet_wall_two()
{
	start_ent	= GetEnt( "bullet_wall_two", "targetname" );
	
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-35.0,35.0);
		z = randomfloatrange(-28.0, 28.0);
		
		
		firepos = start_ent.origin + ( (i*1.0)+x+1, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("vtak31_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		
		level.window_reset = 0;	
		
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}

bullet_wall_three()
{
	start_ent	= GetEnt( "bullet_wall_three", "targetname" );
	
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-25.0,25.0);
		z = randomfloatrange(-28.0, 28.0);
		
		
		firepos = start_ent.origin + ( (i*1.0)+x+3, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("vtak31_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		
		level.window_reset = 0;	
		
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}


sniper_start()
{
	trigger = getent("secret_sniper", "targetname");
	trigger trigger_on();
	trigger waittill("trigger");
	objective_state(11, "done");
	obj_ori = getent("protect_vesper_obj_ori", "targetname");
	wait(2);
	level.timer1 = gettime();
	
	setExpFog(0, 2373.57, 0.138957, 0.136401,  0.138066, 2, 0.912103);
	level thread sniper_vesper_spawn();
}




sniper_vesper_spawn()
{
	radio_ori = getent("warehouse_radio_ori", "targetname");
	level.sniper_vesper = getent("secret_vesper", "targetname")  stalingradspawn( "Svesper" );
	level.sniper_vesper.health = 55150;  
	level.sniper_vesper SetAlertStatemax("alert_green");
	level.sniper_vesper setengagerule("never");
	level.sniper_vesper maps\_utility::gun_remove();
	level.sniper_vesper play_dialogue_nowait("VESP_BargG_051A"); 
	level.sniper_vesper stopcmd();
	level.sniper_vesper setengagerule("never");
	level.sniper_vesper allowedstances("stand");
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper setFlashBangPainEnable( false );
	level thread sniper_cam();
	level thread sniper_vesper_hide();
	vesper = getent("Svesper", "targetname");
	objective_add(2, "current", &"BARGE_PROTECT_VESPER" , (vesper.origin), &"BARGE_PROTECT_VESPER_INFO" ); 
	doors = getent("sniper_wam_door2", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	brush connectpaths();
	wait(3.4);
	radio_ori play_dialogue("RAD1_BargG_015A");  
	
}






sniper_cam()
{
	wait(3);
	
}



vesper_stop_anim()
{
	stop_anim[0] = "Vesper_StandCover";
	stop_anim[1] = "Vesper_PanicIdle";
	x = randomintrange(40, 130);
	level.sniper_vesper cmdfaceangles(x, 0); 
	level.sniper_vesper CmdPlayanim(stop_anim[randomint(2)], false);
}


vesper_stop_anim2()
{
	stop_anim[0] = "Vesper_StandCover";
	stop_anim[1] = "Vesper_StandCover";
	x = randomintrange(40, 130);
	level.sniper_vesper cmdfaceangles(x, 0); 
	level.sniper_vesper CmdPlayanim(stop_anim[randomint(2)], false);
}

thug_grab_anim()
{
	grab_anim[0] = "Thug_ShinKick";
	grab_anim[1] = "Thug_VesperDrag";
	self endon("death");
	self cmdglanceatentity(level.sniper_vesper, 0.2);
	
	
	
	

	
  
  
  level.v_thug_angles = self.angles;
  self  CmdPlayanim("Thug_ShinKick", false);
  wait(1);
  self stopallcmds();
  self cmdshootatentity(level.player, false, 1, 0.1);
}

vesper_grab_anim()
{
	level.sniper_vesper stopallcmds();
	wait(0.2);
	
	struggle_anim[0] = "Vesper_ShinKick";
	struggle_anim[1] = "Vesper_ShinKick";
	struggle_anim[2] = 	"Vesper_WalkFast";
	struggle_anim[3] = 	"Vesper_VesprDrag";
	
	
	
	
	
	
	
	
	level.sniper_vesper CmdPlayanim("Vesper_ShinKick", false);
	wait(1);
	level.sniper_vesper stopallcmds();
	wait(0.1);
	if(level.vesper_guidance_var <= 1)
	{
		level.sniper_vesper setgoalnode(level.hidenode);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 2) || (level.vesper_guidance_var == 3))
	{
		level.sniper_vesper setgoalnode(level.hidenode_sigma);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 4) || (level.vesper_guidance_var == 5) || (level.vesper_guidance_var == 6))
	{
		level.sniper_vesper setgoalnode(level.hidenode_zeta);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
	else if((level.vesper_guidance_var == 7) || (level.vesper_guidance_var == 8) || (level.vesper_guidance_var == 9))
	{
		level.sniper_vesper setgoalnode(level.hidenode_omega);
		level.sniper_vesper waittill("goal");
		level.sniper_vesper thread vesper_stop_anim2();
	}
}	


vesper_grab_anim2()
{
	
	
	
}

vesper_drag_anim()
{
	drag_anim[0] = 	"Vesper_WalkFast";
	drag_anim[1] = 	"Vesper_VesprDrag";
	self CmdPlayanim(drag_anim[randomint(2)]);
}







vesper_doors1()
{
	doors = getent("sniper_wam_door1", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	doors rotateyaw(90, 3, 1.2, 0.9);
	brush connectpaths();
	
}


door_etiquette()
{
	self setscriptspeed("run");
	self setalertstatemax("alert_green");
	self setengagerule("never");
	self waittill("goal");
	if(isdefined(self))
	{
		while(1)
		{
			self endon("death");
			self CmdAction("CallOut", false);
			self waittill("cmd_done");
			self stopallcmds();
		}
		wait(1);
	}
}





vesper_doors1_close()
{
	doors = getent("sniper_wam_door1", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(-3000, 0.1);
	doors rotateyaw(-90, 4, 1.7, 1.3);
	brush disconnectpaths();
}

vesper_doors2()
{
	doors = getent("sniper_wam_door2", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	doors rotateyaw(90, 1.5, 0.23, 1.2);
	brush connectpaths();
	
	
	level waittill("wave_sigma_clear");
	
	{
		
		
		
		
		
		
	}
	
	
	{
	
	}
}
vesper_doors2_close()
{
	doors = getent("sniper_wam_door2", "targetname");
	brush = getent(doors.target, "targetname");
	
	doors rotateyaw(-90, 4, 1.3, 1.1);
	
}

vesper_doors3()
{
	doors = getent("sniper_wam_door4", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	doors rotateyaw(-120, 4, 0.4, 2.6);
	brush connectpaths();

}
vesper_doors3_close()
{
	doors = getent("sniper_wam_door4", "targetname");
	brush = getent(doors.target, "targetname");
	brush movex(-3000, 0.1);
	doors rotateyaw(120, 4, 2.3, 1.3);
	brush disconnectpaths();
}

vesper_doors4()
{
	doors = getent("sniper_wam_door3", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	doors rotateyaw(120, 1, 0.2, 0.8);
	brush connectpaths();
}
vesper_doors4_close()
{
	doors = getent("sniper_wam_door3", "targetname");
	brush = getent(doors.target, "targetname");
	
	doors rotateyaw(-120, 1, 1);
	
}

door3_waving_enemy()
{
	guy = getent ("door3_guy", "targetname")  stalingradspawn("guy");
	guy thread door_etiquette();
	level waittill("wave_sigma_zeta");
	if(isdefined(guy))
	{
		node = getnode("door_wave_node", "targetname");
		guy stopallcmds();
		guy setalertstatemin("alert_green");
		guy setscriptspeed("run");
		
		guy setgoalnode(node);
	}
	guy waittill("goal");
	if(isdefined(guy))
	{
		guy delete();
	}
}








sniper_vesper_hide()
{
	level.hidenode = getnode("vesper_stop1", "targetname");
	level.sniper_vesper setgoalnode(level.hidenode);
	
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");

	level thread vesper_stop();
	level thread vesper_stop_anim();
	level.sniper_vesper SetScriptSpeed("run");


	level waittill("wave_clear");
	level.sniper_vesper stopallcmds();
	wait(0.1);

	level.hidenode_sigma = getnode(level.hidenode.target, "targetname");
	level.sniper_vesper setgoalnode(level.hidenode_sigma);
	level.sniper_vesper waittill("goal");
	wait(1.5);

	level thread vesper_stop_sigma();
	level thread vesper_stop_anim();
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_sigma_clear");
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.sniper_vesper SetScriptSpeed("run");

	level.hidenode_zeta = getnode(level.hidenode_sigma.target, "targetname");
	level.sniper_vesper setgoalnode(level.hidenode_zeta);
	level.sniper_vesper waittill("goal");
	level.player GiveMaxAmmo ( "VTAK31_Barge" );
	level thread spotlight_que();

	level thread vesper_stop_zeta();
	level thread vesper_stop_anim();
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_sigma_zeta");
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.hidenode_omega = getnode(level.hidenode_zeta.target, "targetname");
	level.sniper_vesper setgoalnode(level.hidenode_omega);
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_omega();
	level thread vesper_stop_anim();
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_omega_clear");
	level.sniper_vesper stopallcmds();
	wait(0.1);
	
	
	level.sniper_vesper setgoalnode(level.hidenode_omega);
	level.sniper_vesper waittill("goal");
	
	level.hidenode_end = getnode("vesper_escape_end", "targetname");
	
	level.sniper_vesper setgoalnode(level.hidenode_end);
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_final();
	level waittill("vesper_last_guy");
	level thread vesper_kratt_away();
	level waittill("kratt_takes_away");
	
	
	level thread sniper_shooters_dead();
	wait(1);
	level thread sniper_death_check();
	level notify ("vesper_ready_end");
	level thread sniper_death_check();
	wait(1);
	level waittill("sniper_shooters_dead");
	
	
	door = getent("warehouse_door", "targetname");
	brush2 = getent("warehouse_door_brush2", "targetname");
	door rotateyaw(90, 1);
	brush2 movez(200, 0.1);
	brush2 connectpaths();
	brush2 delete();
	
	level thread sniper_vesper_point();  
	level waittill("vesper_point_over");
	level.timer2 = gettime();
	level thread achievement_logic();
	
	
	
	
}

achievement_logic()
{
	wait(0.1);
	if(level.timer1 -120000 < level.timer2) 
	{
		GiveAchievement("Challenge_Barge");
	}
}

			



sniper_vesper_point()
{
	wait(0.5);

	level notify("vesper_point_over");

	objective_state(2, "done");  
	level.sniper_event = 1;
	
	
	level notify("playmusicpackage_postsniper");
	
	wait(2);
	
	obj_ori = getent("docks_origin", "targetname");
	objective_add(4, "active", &"BARGE_GET_ON_BARGE", (obj_ori.origin), &"BARGE_GET_ON_BARGE_INFO" );
}

	

vesper_stop()
{
	
	spawners = getentarray("vesper_enemy_wave1", "script_noteworthy");
	nodes1 = getnodearray("snp_nodes_array1", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i].targetname = "vesper_wave1_enemy" + i;
			guy[i] SetAlertStatemax("alert_yellow");
			guy[i] thread go_to_node_array1(guy[i], nodes1[i]);
			guy[i] thread vesper_grab(guy[i]);
			guy[i] setengagerule("never");
		}
		level thread sniper_amb_shooters();
		level thread vesper_guidance();
		guy[i] waittill("death");
		level.vesper_guidance_var ++;
		level notify("door_man");
	}	
	 level notify("wave_clear");
}


go_to_node_array1(guy, nodes1)
{
	z = randomintrange(1,4);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes1, 1);
	guy SetScriptSpeed(intensity [randomint(2)]);
	guy waittill("goal");
	wait(z);
	if(isalive(guy))
	{
		guy thread go_to_node_array1a();
		level thread vesper_ambient_chatter();
	}
}

go_to_node_array1a() 
{
	intensity[0] = "jog";
  intensity[1] = "run";
  self endon("death");
	nodes = getnodearray("vesper_enemy1_nodes", "targetname");
	node = getnode("vesper_enemy1_node1", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(2)]);
	self cmdshootatentity(level.player, false, 3, 0.1);
	self setgoalnode(node, 1);
	self waittill("goal");
	self.tetherradius = 30;
}	


sniper_amb_shooters()
{
	wait(1);
	level thread initialize_sniper_pos1();
	level thread initialize_sniper_pos2();
	level thread initialize_sniper_pos3();
	spawners = getentarray("sniper_ambient_shooters", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		level endon("wave_clear");
		guy[i]= spawners[i] stalingradspawn();
		
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i] SetAlertStatemin("alert_red");
			guy[i] waittill("goal");
			guy[i] SetScriptSpeed("run");
			guy[i].targetname = "sniper_shooters";
			guy[i] thread amb1_death_check();
		}
		wait(2);
		level waittill("amb1_death");
		
	}
}

amb1_death_check()
{
	self waittill("death");
	level notify("amb1_death");
}


vesper_grab(guy)
{
	trig = getent("vesper_stop1T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	while(1)
	{
		level.x1 = randomintrange(1,4);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim();
			
			level.vesper_grab = 1;
			level thread vesper_fail_chatter1();
			
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(10);
			missionfailed();
			
			level.player play_dialogue_nowait("BRG_Vesper_scream1");
			
			guy setgoalnode(node);
			level.sniper_vesper thread vesper_drag_anim();
			self thread grab_end();
			guy SetScriptSpeed("walk");
			wait(2);
			break;
		}
		wait(1);
	}
} 



grab_end()
{
	
	level thread vesper_caught_end(self);
	self waittill("death");
	level.sniper_vesper unlink();
	level.vesper_grab = 0;
	level.sniper_vesper stopallcmds();
	self delete();
	level.sniper_vesper setgoalnode(level.hidenode);

	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_anim();
}


vesper_stuck_oneT()
{
	stuck1 = getent("vesper_stuck_oneT", "targetname");
	if(level.sniper_vesper istouching(stuck1))
	{
		
		level.sniper_vesper teleport((1198, 882, -30), (0, 45, 0));
		
	}
	
}



vesper_stop_sigma()
{
	spawners = getentarray("vesper_enemy_wave2", "script_noteworthy");
	nodes1 = getnodearray("snp_nodes_array1a", "targetname"); 
	level thread vesper_doors2();
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i].targetname = "vesper_wave2_enemy" + i;
			guy[i] SetAlertStatemax("alert_yellow");
			guy[i] thread go_to_node_array2(guy[i], nodes1[i]);
			guy[i] thread vesper_grab_sigma(guy[i]);
			guy[i] setengagerule("never"); 
		}
		level thread sniper_amb_shooters_sigma();
		level thread vesper_guidance();
		guy[i] waittill("death");
		level.vesper_guidance_var ++;
		level notify("door_man");
	}	
	 level notify("wave_sigma_clear"); 
	 level thread vesper_doors2_close();
}


go_to_node_array2(guy, nodes1)
{
	z = randomintrange(2,5);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes1, 1);
	guy SetScriptSpeed(intensity [randomint(2)]);
	guy waittill("goal");
	
	guy cmdaction("Fidget");
	wait(z);
	guy stopallcmds();
	if(isalive(guy))
	{
		guy cmdshootatentity(level.player, false, z, 0.1);
		guy stopcmd();
		guy thread go_to_node_array2a();
		level thread vesper_ambient_chatter();
	}
}

go_to_node_array2a()
{
	intensity[0] = "jog";
  intensity[1] = "run";
  self endon("death");
	nodes = getnodearray("vesper_enemy2_nodes", "targetname");
	node = getnode("vesper_enemy2_node", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(2)]);
	self setgoalnode(node, 1);
	self waittill("goal");
	self.tetherradius = 30;
}	

sniper_amb_shooters_sigma()
{
	while(level.sniper_event == 0)
	{
		z = randomintrange(3,7);
		if(level._ai_group["sniper_shooters1"].aicount <= 2)
		{
			
			spawners = getentarray("sniper_ambient_shooters2", "targetname");
			for (i = 0; i < spawners.size; i++)
			{
				level endon("wave_sigma_clear");
				guy[i]= spawners[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( guy[i]) )
				{
					guy[i] SetAlertStatemin("alert_red");
					guy[i] SetScriptSpeed("run");  
					guy[i] waittill("goal");
					guy[i].targetname = "sniper_shooters";
					guy[i].tetherradius = 10;
					guy[i] thread amb2_death_check();
					
				}
				level waittill("amb2_death");
				
			}
		}
		wait(1);
	}
}

amb2_death_check()
{
	self waittill("death");
	level notify("amb2_death");
}

vesper_grab_sigma(guy)
{
	dialog[0] = "James, they grabbed me!";
  dialog[1] = "Get your hands off me!";
  dialog[2] = "Dont touch me you bastard!";
	trig = getent("vesper_stop2T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	while(1)
	{
		x = randomintrange(1,3);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim();
			
			level.vesper_grab = 1;
			
			level.player play_dialogue_nowait ("BRG_Vesper_scream1");
			wait(x);
			level thread vesper_fail_chatter1();
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(10);
			missionfailed();
			level.sniper_vesper stopcmd();
			level.sniper_vesper thread vesper_drag_anim();
			guy setgoalnode(node);
			self thread sigma_end();
			guy SetScriptSpeed("walk"); 
			break;
		}
		wait(1);
	}
}

sigma_end()
{
	level thread vesper_caught_end(self);
	self waittill("death");
	level.sniper_vesper unlink();
	level.vesper_grab = 0;
	level.sniper_vesper stopcmd();
	level.sniper_vesper setgoalnode(level.hidenode_sigma);
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_anim();
}


vesper_stop_zeta()
{
	
	thread maps\_autosave::autosave_now("barge");
	
	level thread vesper_doors1();
	wait(0.3);
	spawners = getentarray("vesper_enemy_wave3", "script_noteworthy");
	nodes = getnodearray("vesper_enemy3_nodes", "targetname");
	nodes2 = getnodearray("snp_node_array1b", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i].targetname = "vesper_wave3_enemy" + i;
			guy[i] SetAlertStatemax("alert_yellow");
			guy[i] thread go_to_node_array3(guy[i], nodes2[i]);
			guy[i] thread vesper_grab_zeta(guy[i]);
			guy[i] setengagerule("never");
		}
		level thread sniper_amb_shooters_zeta();
		level thread vesper_guidance();
		guy[i] waittill("death");
		level.vesper_guidance_var ++;
		level notify("door_man");
		
	}
	 level notify("wave_sigma_zeta"); 
	 level thread vesper_doors1_close();
}


go_to_node_array3(guy, nodes2)
{
	r = randomintrange(3,5);
	s = randomintrange(2,r);
	z = randomintrange(s,6);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes2, 1);
	guy SetScriptSpeed(intensity [randomint(2)]);
	wait(s);
	guy cmdshootatentity(level.player, false, z, 0.1);
	guy waittill("goal");
	
	
	
	if(isalive(guy))
	{
		guy stopcmd();
		guy thread go_to_node_array3a();
		level thread vesper_ambient_chatter();
	}
}

go_to_node_array3a()
{
	intensity[0] = "jog";
  intensity[1] = "run";
  self endon("death");
	nodes = getnodearray("vesper_enemy3_nodes", "targetname");
	node = getnode("vesper_enemy3_node", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(2)]);
	self setgoalnode(node, 1);
	self waittill("goal");
	self.tetherradius = 30;
}	


sniper_amb_shooters_zeta()
{
	while(level.sniper_event == 0)
	{
		z = randomfloatrange(5.5,8.3);
		if(level._ai_group["sniper_shooters2"].aicount <= 2)
		{
			spawners = getentarray("sniper_ambient_shooters3", "targetname");
			for (i = 0; i < spawners.size; i++)
			{
				level endon("wave_sigma_zeta");
				guy[i]= spawners[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( guy[i]) )
				{
					guy[i] SetAlertStatemin("alert_red");
					guy[i] SetScriptSpeed("jog"); 
					guy[i] waittill("goal");
					guy[i].tetherradius = 100;
					guy[i].targetname = "sniper_shooters";
					guy[i] thread amb3_death_check();
					
				}
				level waittill("amb3_death");
				
			}
		}
	wait(1);
	}
}

amb3_death_check()
{
	self waittill("death");
	level notify("amb3_death");
}

vesper_grab_zeta(guy)
{
	dialog[0] = "James, they grabbed me!";
  dialog[1] = "Get your hands off me!";
  dialog[2] = "Dont touch me you bastard!";
	trig = getent("vesper_stop3T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	while(1)
	{
		x = randomintrange(0,2);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
		
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim();
			level.vesper_grab = 1;
			level thread vesper_grab_anim2();
			
			
			level thread vesper_fail_chatter2();
			guy cmdshootatentity(level.player, false, 3, 0.01);
			wait(7.75);
			missionfailed();
			wait(x);
			guy setgoalnode(node);
			level.sniper_vesper thread vesper_drag_anim();
			self thread zeta_end();
			guy SetScriptSpeed("walk"); 
			break;
		}
		wait(1);
	}
}

zeta_end()
{
	level thread vesper_caught_end(self);
	self waittill("death");
	level.sniper_vesper unlink();
	level.vesper_grab = 0;
	level.sniper_vesper stopcmd();
	level.sniper_vesper setgoalnode(level.hidenode_zeta);
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_anim();
}


vesper_stop_omega()
{
	spawners = getentarray("vesper_enemy_wave4", "script_noteworthy");
	nodes = getnodearray("vesper_enemy4_nodes", "targetname");
	nodes2 = getnodearray("snp_node_array2", "targetname");
	level thread vesper_doors4();
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if(!maps\_utility::spawn_failed( guy[i]))
		{
			guy[i].targetname = "vesper_wave4_enemy" + i;
			guy[i] SetAlertStatemax("alert_yellow");
			guy[i] thread go_to_node_array4(guy[i], nodes2[i]);
			guy[i] thread vesper_grab_omega(guy[i]);
			guy[i] setengagerule("never"); 
		}
		
		level thread vesper_guidance();
		guy[i] waittill("death");
		level.vesper_guidance_var ++;
		level notify("door_man");
	}
	 level notify("wave_omega_clear");
	 level thread vesper_doors4_close();
}


go_to_node_array4(guy, nodes2)
{
	z = randomintrange(4,7);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes2, 1);
	guy SetScriptSpeed(intensity [randomint(2)]);
	guy waittill("goal");
	
	guy cmdshootatentity(level.player, false, z, 0.01);
	if(isalive(guy))
	{
		guy stopcmd();
		guy thread go_to_node_array4a();
		level thread vesper_ambient_chatter();
	}
}

go_to_node_array4a()
{
	intensity[0] = "jog";
  intensity[1] = "walk";
  intensity[2] = "walk";
  self endon("death");
	nodes = getnodearray("vesper_enemy4_nodes", "targetname");
	node = getnode("vesper_enemy4_node", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(3)]);
	self setgoalnode(node , 1);
	self waittill("goal");
	self.tetherradius = 30;
}	



sniper_amb_shooters_omega()
{
	while(level.sniper_event == 0)
	{
		z = randomfloatrange(0.3, 2.2);
		if((level._ai_group["sniper_shooters2"].aicount == 0 ) && (level._ai_group["sniper_shooters3"].aicount <= 2) && (level._ai_group["sniper_shooters1"].aicount <= 1) || (level._ai_group["sniper_shooters2"].aicount < 2) && (level._ai_group["sniper_shooters3"].aicount < 1) && (level._ai_group["sniper_shooters1"].aicount < 1))
		{
			spawners = getentarray("sniper_ambient_shooters4", "targetname");
			for (i = 0; i < spawners.size; i++)
			{
				guy[i]= spawners[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( guy[i]) )
				{
					guy[i] SetAlertStatemin("alert_red");
					guy[i] SetScriptSpeed("jog"); 
					guy[i] waittill("goal"); 
					
					guy[i].targetname = "sniper_shooters";
					

				}
				level notify("omega_watch");
				wait(z);
			}
		}
	wait(1);
	}
}


vesper_grab_omega(guy)
{
	dialog[0] = "James, they grabbed me!";
  dialog[1] = "Get your hands off me!";
  dialog[2] = "Dont touch me you bastard!";
	trig = getent("vesper_stop4T", "targetname");
	node = getnode(trig.target, "targetname");
	while(1)
	{
		x = randomintrange(1,2);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim();
			
			
			
			
			
			level thread vesper_fail_chatter2();
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(5);
			missionfailed();
			wait(x);
			level.sniper_vesper thread vesper_drag_anim();
			guy setgoalnode(node);
			guy SetScriptSpeed("walk"); 
			break;
		}
		wait(1);
	}
	level thread vesper_caught_end(guy);
	guy waittill("death");
	level.sniper_vesper unlink();
	level.vesper_grab = 0;
	level.sniper_vesper stopcmd();
	level.sniper_vesper setgoalnode(level.hidenode_omega);
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");
	
}



vesper_stop_final()
{
	spawner = getent("vesper_enemy_wave5", "script_noteworthy");
	node = getnode("vesper_enemy5_node", "targetname");
	guy = spawner stalingradspawn();
	if(!maps\_utility::spawn_failed(guy))
	{
		guy.targetname = "vesper_wave5_enemy";
		guy SetAlertStatemax("alert_yellow");
		guy thread go_to_node_five(guy, node);
		guy thread vesper_grab_final(guy);
		guy setscriptspeed("run");
		guy setengagerule("never"); 
	}
	level thread vesper_guidance();
	guy waittill("death");
	level.vesper_guidance_var ++;
	level notify("vesper_last_guy");
}

go_to_node_five(guy, node)
{
	z = randomintrange(4,7);
	guy setgoalnode(node, 1);
	guy waittill("goal");
	guy cmdshootatentity(level.player, false, z, 0.01);
	if(isalive(guy))
	{
		guy stopcmd();
		level thread vesper_ambient_chatter();
	}
}

vesper_grab_final(guy)
{
	trig = getent("vesper_last_stand", "targetname");
	while(1)
	{
		x = randomintrange(1,2);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			level thread vesper_fail_chatter2();
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(6);
			missionfailed();
			break;
		}
		wait(1);
	}
}


vesper_kratt_away()
{
	clip = getent("kratt_vesper_clip", "targetname");
	look_at = getent("vesper_look_at_trigger", "targetname");
	look_at waittill("trigger");
	level thread shooter_delete();
	level thread roof_fog_fxz();
	clip movez(160, 0.1);
	kratt = getent ("kratt_shooter", "targetname")  stalingradspawn( "kratt_explode" );
	kratt waittill ("finished spawning");
	kratt lockalertstate("alert_yellow");
	kratt setscriptspeed("jog");
	kratt setFlashBangPainEnable( false );
	kratt.goalradius = 12;
	wait(0.05);
	kratt thread magic_bullet_shield();
	node = getnode("kratt_vesp_node_grab", "targetname");
	node2 = getnode("kratt_exp_go1", "targetname");
	
	
	vnode = getnode("vesper_end_node2", "targetname");
	level.sniper_vesper setgoalnode(vnode);
	wait(0.5);
	
	
	level.sniper_vesper waittill("goal");
	
	level.sniper_vesper cmdfaceangles(77.9, 0);
	level.sniper_vesper CmdPlayanim("Vesper_StandCover", false);
	
	wait(0.5);
	
	playcutscene("Barge_Kratt_Pull", "Pull_done");
	level thread KV_nabbed_dialogue();
	
	
	
	
	
	
	
	level waittill("Pull_done");
	kratt thread stop_magic_bullet_shield();
	wait(1);
	kratt delete();
	level.sniper_vesper delete();
	
	level notify("kratt_takes_away");
	clip delete();
}


KV_nabbed_dialogue()
{	
	level.sniper_vesper play_dialogue("KRAT_BargG_200A");  
	level.sniper_vesper play_dialogue("VESP_BargG_097A");  
}
	
shooter_delete()
{
	shooters = getentarray("sniper_shooters", "targetname");
	level.sniper_event2 = 1;
	wait(0.1);
	if(isdefined(shooters))
	{
		for (i = 0; i < shooters.size; i++)
		{
			shooters[i] delete();
		}
	}
}

	



sniper_shooters_dead()
{
	
	
	wait(2);
	thread maps\_autosave::autosave_now("barge");
	level notify("sniper_shooters_dead");
	level.sniper_event2 = 1;
	obj_ori = getent("finish_shooters_obj_ori", "targetname");
	
	
	
	shooters = getentarray("sniper_shooters", "targetname");
	if(isdefined(shooters))
	{
		for (i = 0; i < shooters.size; i++)
		{
			shooters[i] stopallcmds();
			shooters[i].tetherradius = 10;
			
		}
	}
	wait(5);
	level waittill("vesper_ready_end");
	while(1)
	{
		if((level._ai_group["sniper_shooters2"].aicount == 0) && (level._ai_group["sniper_shooters3"].aicount == 0) && (level._ai_group["sniper_shooters1"].aicount == 0) )  
		{
			level notify("sniper_shooters_dead");
			break;
		}
		wait(2);
	}
}

sniper_death_check()
{
	while(1)
	{
			if((level._ai_group["sniper_shooters2"].aicount == 0) && (level._ai_group["sniper_shooters3"].aicount == 0) && (level._ai_group["sniper_shooters1"].aicount == 0) )  
			{
				level notify("sniper_shooters_dead");
				break;
			}
		wait(2);
	}
}
	

vesper_caught_end(guy)
{
	guy waittill("goal");
	iprintlnbold("Vesper has been taken!");
	missionfailed();
}

car_drive_warehouseT()
{
	trigger = getent("car_drive_warehouseT", "targetname");
	trigger waittill("trigger");
	
}



warehouse_save_pointT()
{
	trigger = getent("warehouse_save_pointT", "targetname");
	trigger waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
}



warehouse_drop_down()
{
	trigger = getent("warehouse_drop_downT", "targetname");
	trigger waittill("trigger");
	cleanup();
	objective_state(4, "done");
	level thread warehouse_grenade();
	
	

	spawners = [];
	spawners[0] = getent("sniper_warehouse_shooters0", "targetname");
	spawners[1] = getent("sniper_warehouse_shooters1", "targetname");
	spawners[2] = getent("sniper_warehouse_shooters2", "targetname");	
	spawners[3] = getent("sniper_warehouse_shooters3", "targetname");

	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i].targetname = "_" + spawners[i].targetname;
			guy[i] SetAlertStatemin("alert_red");
			guy[i] SetScriptSpeed("run");   
			guy[i] thread flash_sense();
		}
	}
	
	level thread ware_shooter_three();
	level thread docks_objective();
	level thread warehouse_door_breach();
	level thread warehouse_two_shooter();
	wait(2);
	level thread warehouse_save_logic();
}



warehouse_two_shooter()
{
	ori = getent("warehouse_ori1", "targetname");
	guy = getent("_sniper_warehouse_shooters2", "targetname");
	node = getnode("ware_two_node", "targetname");
	guy setgoalnode(node);
	guy waittill("goal");
	guy cmdshootatentity(ori, false, 1, 1 );
}




ware_shooter_three()
{
	guy = getent("_sniper_warehouse_shooters3", "targetname");
	
	node = getnode("ware_three_node", "targetname");
	guy allowedstances("crouch");
	guy setgoalnode(node);
	guy setenablesense(false);
	guy waittill("goal");
	guy setenablesense(true);
	guy allowedstances("stand", "crouch");
}

docks_objective()
{
	ori = getent("road_ori", "targetname");
	objective_add(12, "active", &"BARGE_CLEAR_DOCKS", (ori.origin), &"BARGE_CLEAR_DOCKS_INFO");
}

warehouse_save_logic()
{
	while(1)
	{
		if(level._ai_group["warehouse_group1"].aicount < 1)
		{
			objective_state(12, "done");
			obj_ori = getent("get_on_barge_obj_ori", "targetname");
			wait(2);
			thread maps\_autosave::autosave_now("barge");
			break;
		}
	wait(0.5);
	}
}


warehouse_grenade()
{
	level thread warehouse_grenade2();
	wait(4.0);
	ori1 = getent("warehouse_ori1", "targetname");
	ori2 = getent("warehouse_ori2", "targetname");
	
	
	
	
	
	
	radiusdamage(ori1.origin, 20,100,90);
	level thread ware_window_damage();

	grenade = spawn("script_model", ori1.origin);
	grenade setmodel("w_t_grenade_flash");
	grenade physicslaunch(grenade.origin , vectornormalize((0, 3.0, 0)) );
	
	level.player playsound ("mus_bar_timphit");
	
	wait(1);
	playfx (level._effect["flash"], grenade.origin +(0, 0, 0));
	grenade playsound ("explo_grenade_flashbang");
	level.player shellshock("flashbang", 2.33);
	level.player play_dialogue_nowait("BMR5_BargG_045A");
	wait(0.5);
	level notify("grenade_done");
}

ware_window_damage()
{
	ori3 = getent("magic_grenade_ori3", "targetname");
	ori4 = getent("magic_grenade_ori4", "targetname");
	radiusdamage(ori3.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori3.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori3.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori3.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori4.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori4.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori4.origin, 26,100,90);
	wait(0.1);
	radiusdamage(ori4.origin, 26,100,90);
}


warehouse_grenade2()
{
	level waittill("grenade_done");
	ori3 = getent("magic_grenade_ori3", "targetname");
	grenade = spawn("script_model", ori3.origin);
	grenade setmodel("w_t_grenade_flash");
	grenade physicslaunch(grenade.origin , vectornormalize((0, 1.0, 0)) );
	wait(1);
	playfx (level._effect["flash"], grenade.origin +(0, 0, 0));
	grenade playsound ("explo_grenade_flashbang");
	level.player play_dialogue_nowait("BMR5_BargG_045A");
}
	
	



warehouse_door_breach()
{
	node1 = getnode("rusher_node_1" , "targetname");
	node2 = getnode("rusher_node_2" , "targetname");
	clip = getent("flash_door_clip", "targetname");
	guy1 = getent("_sniper_warehouse_shooters0", "targetname");
	guy1 setenablesense(false);
	guy1 setgoalnode(node1);
	
	guy1 thread magic_bullet_shield();
	guy1 setcombatrole("rusher");
	wait(0.5);
	
	guy1 waittill("goal");
	guy1 setgoalnode(node2);
	guy1 waittill("goal");
	guy1 cmdplayanim("Thug_Alrt_FrontKick", false);
	
	guy1 thread stop_magic_bullet_shield();
	guy1 setenablesense(true);
	guy1 setperfectsense(true);
	wait(0.8);
	clip movez(-200, 0.1);
	clip connectpaths();
	level notify("flash_door_start");
	clip delete();
}



warehouse_transition_saveT()
{
	trigger =getent("warehouse_transition_saveT", "targetname");
	trigger waittill("trigger");
	
	
	
	
	
	
	level thread global_autosave();
	monster_clip = getent("sniper_monster_clip", "targetname");
	monster_clip movez(3000, 1);
	monster_clip connectpaths();
	monster_clip delete();
	
}



sniper_end()
{
	
	endcutscene("Barge_Intro_LoopEnd");
	ori1 = getent("kratt_exp_ori1", "targetname");
	ori2 = getent("kratt_exp_ori2", "targetname");
	ori3 = getent("kratt_exp_ori3", "targetname");
	ori4 = getent("kratt_exp_ori4", "targetname");

	level thread spotlight1_kill();
	level thread spotlight2_kill();
	trigger = getent("barge_tank3_dmgT4", "targetname");
	
	level thread barge_tank1();
	level thread acetylene_extras();
	level.sniper_event = 1;
	
	
	
	
	
  

	if(isdefined(level.spot_man))
	{
		level.spot_man delete();
	}
	
	
	
	

	trigger waittill("trigger");
  earthquake(0.2, 2, ori4.origin, 1500);
	
	
	
	
	
	
	
	
	playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
	wait(0.3);

	wait(0.5);
	radiusdamage(ori1.origin, 60,550,520);
	radiusdamage(ori1.origin, 260,550,520);
	physicsExplosioncylinder(ori1.origin, 200, 10, 10 );
	playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
	wait(0.05);

	radiusdamage(ori3.origin, 60,550,520);
	radiusdamage(ori3.origin, 260,550,520);
	physicsExplosioncylinder(ori3.origin, 200, 10, 10 );
	playfx (level._effect["fxdoor"], ori3.origin +(0, 0, 0));
	wait(0.05);
	
	

	wait(0.05);
	radiusdamage(ori2.origin, 60,550,520);
	radiusdamage(ori2.origin, 260,550,520);
	physicsExplosioncylinder(ori2.origin, 200, 10, 10 );
	level thread all_tanks_die();
	playfx (level._effect["fxdoor"], ori2.origin +(0, 0, 0));
	wait(0.05);
	
	
	
	playfx (level._effect["fxpumpgen"], ori3.origin +(0, 0, 0));
	wait(0.05);


	
	
	
	
}

all_tanks_die()
{
	tanks = getentarray("barge_tanks1", "targetname");
	for (i = 0; i < tanks.size; i++)
	{
		tanks[i] dodamage(1000, (0,0,5));
	}
}

street_light_flicker()
{
	lp_off = getent("light_post_dock_off", "targetname");
	lp_on = getent("light_post_dock_on", "targetname");
	light = getent("dock_light_flicker1", "targetname");
	lp_off hide();
	while(1)
	{
		x = randomfloatrange(0.005, 0.07);
		light setlightintensity (2);
		lp_off hide();
		lp_on show();
		wait(x);
		light setlightintensity (0);
		lp_on hide();
		lp_off show();
		wait(x);
		light setlightintensity (2);
		lp_off hide();
		lp_on show();
		wait(x);
		light setlightintensity (0);
		lp_on hide();
		lp_off show();
		wait(x);
		light setlightintensity (2);
		lp_off hide();
		lp_on show();
		wait(x);
	}	
}



vesper_wait_for_bond()
{
	vesper = getent("Svesper", "targetname");
	
	vesper pausepatrolroute();
}


secret_vesper_finish()
{
	vesper = getent("Svesper", "targetname");
	
	wait(2);
	
}


acetylene_extras()
{
	
	clip = getent("tank_safety_ms1_clip", "targetname");
	clip delete();
	spawners = getentarray("plank_enemies", "targetname");
	nodes = getnodearray("plank_nodes", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guys[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guys[i]) )
		{
			guys[i] SetAlertStatemin("alert_red");
			guys[i] SetScriptSpeed("run");
			guys[i].targetname = "plank_shooters";
			
			guys[i] setgoalnode(nodes[i], 1);
			guys[i] AddEngageRule("tgtsight");
			
		} 
	}
	level thread deck_fire2();
	
	
	
	
	
}

shoot_at_bond()
{
	wait(3.5);
	if(isdefined(self))
	{
		self cmdshootatentity(level.player, false, 4, 1 );
	}
}


tanks_launcher()
{
	tanks = getentarray("rolling_tanks", "script_noteworthy");
	for (i = 0; i < tanks.size; i++) 
	{
		tanks[i] physicslaunch(tanks[i].origin, vectornormalize((122.0, 122.0, 2.8)) );
	}
}














tree_cargo()
{
	deck_ori1 = getent("deck_ori1_3", "targetname");			
	destruct_ori = getent("ori_dyn_kill1", "targetname"); 
	trigger = getent("tree_cargo_trigger", "targetname");
	
	tree_ori1 = getent("tree_cargo_ori1", "targetname");
	tree_ori2 = getent("tree_cargo_ori2", "targetname");
	rope = getent("pallete_rope_two", "targetname");
	trigger waittill("damage");
	dynEnt_RemoveConstraint( "tanks_pallete", "suspend_tanks_point1" );
	
	
	
	dynEnt_StartPhysics( "barge_tanks3" );
	dynEnt_StartPhysics( "pallete_rope");
	rope delete();
	level thread second_point_remove(destruct_ori);
	playfx (level._effect["bullets"], tree_ori1.origin);
	wait(0.1);
	playfx (level._effect["bullets"], tree_ori1.origin);
	radiusdamage(tree_ori2.origin, 50, 10, 9); 
	wait(0.05);
	radiusdamage(tree_ori2.origin, 50, 10, 9);
	wait(1);
	radiusdamage(deck_ori1.origin, 50, 10, 9); 
	wait(0.01);
	radiusdamage(deck_ori1.origin, 50, 10, 9); 
	level notify("supress_done");
}



second_point_remove(destruct_ori)
{
	wait(0.5);
	dynEnt_RemoveConstraint( "tanks_pallete", "suspend_tanks_point2" );
	wait(0.5);
	radiusdamage(destruct_ori.origin, 170, 110, 100); 
	wait(0.5);
	radiusdamage(destruct_ori.origin, 170, 110, 100); 
}



stern_thug_trigger_99_patrol()
{
	stern_thug_spawner_99_patrol = getentarray ( "stern_thug_spawner_99_patrol", "script_noteworthy" );

	for ( i = 0; i < stern_thug_spawner_99_patrol.size; i++ )
	{
		stern_patrols[i] = stern_thug_spawner_99_patrol[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( stern_patrols[i]) )
		{
			stern_patrols[i].goalradius = 24;
			stern_patrols[i] StartPatrolRoute ( "thug99_patrol" );
			stern_patrols[i].targetname = "deck_enemy" + i;
		}
	}
	level thread deck_shooters();
	level thread stern_three_thugs_around_corner();
}

deck_shooters()
{
	guy1 = getent("deck_enemy0", "targetname");
	guy1 cmdshootatentity(level.player, false, 4, 0.45 );
}


stern_three_thugs_around_corner()
{
	supressors = getentarray( "tactical_suppressors","targetname" );
	nodes = getnodearray("supressor_nodes", "targetname");
	level thread supress_help();
	level thread roof_fog_fxy(); 
	level thread phys_prot_clip();
	for ( i = 0; i < supressors.size; i++ )
	{	
	 supressors[i] = supressors[i] stalingradspawn();
		if( !maps\_utility::spawn_failed(supressors[i]) )
		{
			supressors[i] AddEngageRule("tgtperceive");
			supressors[i] setgoalnode(nodes[i], 1);
			supressors[i] SetAlertStateMin("alert_red");
			supressors[i].goalradius = 24;
			supressors[i].targetname = "supressors" + i;	
			supressors[i] SetScriptSpeed("run");
			supressors[i] cmdshootatentity(level.player, false, 4, 10 );
		
		}
	}	
}

supress_help()
{
	bullet_org = GetEnt("supress_start","targetname");
	bullet_pos = GetEntArray("supress_end","targetname");
	level thread supress_timer();
	trigger = GetEnt("e1_two_trigger", "script_noteworthy");
	ori1 = getent("deck_phys_ori1", "script_noteworthy");
	ori2 = getent("deck_phys_ori2", "script_noteworthy");
	ori3 = getent("deck_phys_ori3", "script_noteworthy");
	level endon("supress_done"); 
	shooter = getent("deck_enemy0", "targetname");
	while(IsDefined(trigger))
	{
		x = randomfloatrange( 0.08, 0.1);
		shooter endon("death"); 
		if(level.player istouching(trigger))
		{
			number = RandomInt(bullet_pos.size);
			magicbullet("FRWL_Barge", bullet_org.origin, bullet_pos[number].origin);
			physicsExplosionSphere(ori1.origin, 10, 10, 2 );
			physicsExplosionSphere(ori2.origin, 10, 10, 2 );
			physicsExplosionSphere(ori3.origin, 10, 10, 2 );
		}
		wait(x);
	}
}

supress_timer()
{
	wait(6.5);
	level notify("supress_done");
}


phys_prot_clip()
{
	clip = getent("phys_prot_clip", "targetname");
	clip movez(-2000, 0.01);
	clip connectpaths();
}



barge_tank1() 
{ 
	tank1_array = getentarray("barge_tanks1", "targetname");
	for(i = 0; i < tank1_array.size; i++)
	{
		tank1_array[i] setcandamage(true);
		tank1_array[i] thread barge_tank1_utility();
	}
}
	
barge_tank1_utility()  
{
	ori = self.origin;
	fxspawn = spawn( "script_origin", ori );
	self waittill("damage");
	fxspawn playsound ( "expl_gastank" );
	earthquake(0.3, 0.5, fxspawn.origin, 600);
	playfx (level._effect["fxgen09"], fxspawn.origin);
	radiusdamage(self.origin, 50, 200, 199); 
	self delete();
	
	
	fxspawn delete();
}

barge_tank2() 
{ 
	tank2_array = getentarray("barge_tanks2", "targetname");
	level endon("tanks_all_dead");
	for(i = 0; i < tank2_array.size; i++)
	{
		tank2_array[i] setcandamage(true);
		tank2_array[i] thread barge_tank2_utility();
	}
}
	
barge_tank2_utility()  
{
	ori = self.origin;
	fxspawn = spawn( "script_origin", ori );
	self waittill("damage");
	level endon("tanks_all_dead");
	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if(attacker == level.player)
		{
			radiusdamage(fxspawn.origin, 250,200,200);
			fxspawn playsound ( "expl_gastank" );
			earthquake(0.3, 0.5, fxspawn.origin, 600);
			playfx (level._effect["fxgen09"], fxspawn.origin);
			wait(0.1);
			self delete();
			break;
		}
		wait(0.01);
	}
	
	
	fxspawn delete();
}

barge_tank4() 
{ 
	tank4_array = getentarray("barge_tanks4", "targetname");
	for(i = 0; i < tank4_array.size; i++)
	{
		tank4_array[i] setcandamage(true);
		tank4_array[i] thread barge_tank4_utility();
	}
}
	
barge_tank4_utility()  
{
	ori = self.origin;
	fxspawn = spawn( "script_origin", ori );
	self waittill("damage");
	radiusdamage(fxspawn.origin, 250,250,200);
	fxspawn playsound ( "expl_gastank" );
	earthquake(0.3, 0.5, fxspawn.origin, 600);
	playfx (level._effect["fxpumpgen"], fxspawn.origin);
	wait(0.1);
	self delete();
	
	
	fxspawn delete();
}








deck_fire()
{
	trigger = getent("out_deck_dmgT", "targetname");
	ori1 = getent("deck_ori1", "targetname");
	ori2 = getent("deck_ori2", "targetname");
	ori3 = getent("deck_ori3", "targetname");
	trigger waittill("trigger");
	level.deck_event = 1;
	playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
	radiusdamage(ori1.origin, 200,300,100);
	ori1 playsound("BRG_mousetrap1");
	wait(0.1);
	
	radiusdamage(ori2.origin, 150,150,110);
	wait(0.1);
	playfx (level._effect["fxfire3"], ori3.origin +(0, 0, 0));
	ori3 playloopsound("BRG_fire");
	radiusdamage(ori1.origin, 200,300,100);
	radiusdamage(ori3.origin, 150,150,110);
	dmg = Spawn("script_origin", ori3.origin, 0, 0, 35);
 	dmg thread consistant_damage_util();
}



deck_fire2()
{
	trigger = getent("out_deck_dmgT2", "targetname");
	while(1)
	{
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if(attacker == level.player)
		{
			
			
			
			ori1 = getent("deck_ori1_2", "targetname");
			level.deck_event = 1;
			playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			physicsExplosionSphere( ori1.origin, 300, 10, 2 );
			level notify("ramp_explode_start");
			ori1 playsound("BRG_mousetrap2");
			radiusdamage(ori1.origin, 350,500,200);
			earthquake(1, 0.6, ori1.origin, 1000);
			wait(1);
			playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			wait(2);
			break;
		}
		wait(0.1);
	}
}

deck_fire3()
{
	trigger = getent("out_deck_dmgT3", "targetname");
	ori1 = getent("deck_ori1_3", "targetname");
	ori2 = getent("tree_cargo_ori1", "targetname");
	
	
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		
		
			level.deck_event = 1;
			
			playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			ori1 playsound("BRG_mousetrap2");
			physicsExplosionSphere( ori1.origin, 300, 10, 2 );
			radiusdamage(ori1.origin, 300,500,200);
			earthquake(1, 0.6, ori1.origin, 1000);
			wait(1);
			radiusdamage(ori2.origin, 300,500,200);
			playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			wait(2);
		
	
	
}



deck_fire4()
{
	trigger = getent("out_deck_dmgT4", "targetname");
	ori1 = getent("deck_ori4x", "targetname");
	trigger waittill("trigger");
	level.deck_event = 1;
	
	playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
	ori1 playsound("BRG_mousetrap3");
	physicsExplosionSphere( ori1.origin, 300, 10, 2 );
	radiusdamage(ori1.origin, 350,500,200);
	earthquake(1, 0.6, ori1.origin, 1000);
	wait(1);
	playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
	wait(2);
}




e1_two_trigger()
{
	catwalk_mapT = getent("catwalk_mapT", "targetname");

	level notify("fx_fog_on"); 
	
	trigger = getent("e1_two_trigger", "script_noteworthy");
	trigger waittill("trigger");
	

	level notify("lighthouse_start"); 
	
	

	
	
	flag_set("_sea_physbob");
	flag_set("_sea_bob");
	
	level._sea_scale = 0.6;
	level._sea_viewbob_scale = 0.01;
	level._sea_physbob_scale = 1.0;
	level thread stern_thug_trigger_99_patrol();
	
		
	
	
}


e1_three_trigger()
{
	
}




roof_guy_delete()
{
	guy = getent("first_enemies1", "targetname");
	guy delete();
}







deck_fire_spawn_think()
{
	trigger = getent("second_cover_deckT", "script_noteworthy");
	trigger waittill("trigger");
	level thread second_cover_deckT3();
	
	
	
	wait(3);
	while(1)
	{	
		if(level._ai_group["one"].aicount <= 1)
		{
			level notify("on_deck");
			break;
		}
		else if(level._ai_group["one"].aicount <= 2)
		{
			wait(3);
			level notify("on_deck");
			break;
		}
	wait(0.5);
	}
}





second_cover_deckT3()
{
	trigger = getent("second_cover_deckT3", "script_noteworthy");
	trigger waittill("trigger");
	dudes = getentarray("deckfire2_enemies", "targetname");
	nodes = getnodearray("deckfire2_nodes", "targetname");
	level thread scared_backdraft_guy();
	for (i = 0; i < dudes.size; i++)
	{
		dudes[i]= dudes[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( dudes[i]) )
		{
			dudes[i] setgoalnode(nodes[i], 1);
			
			dudes[i] AddEngageRule("tgtperceive");
			dudes[i] SetAlertStateMin("alert_red");
			dudes[i].goalradius = 24;
			dudes[i].targetname = "deck_last_wave" + i;	
			dudes[i] SetScriptSpeed("run");
		}
		wait(1.3);
	}
	level thread pre_backdraft_wave();
}




deck_fire_spawns()
{	
	level waittill("on_deck");
	wait(5);
	dudes = getentarray("deckfire_enemies", "targetname");
	nodes = getnodearray("deckfire_nodes", "targetname");
	for (i = 0; i < dudes.size; i++)
	{
		dudes[i]= dudes[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( dudes[i]) )
		{
			dudes[i] setgoalnode(nodes[i], 1);
			
			dudes[i] AddEngageRule("tgtperceive");
			dudes[i] SetAlertStateMin("alert_red");
			dudes[i].goalradius = 24;
			dudes[i].targetname = "deck_fire" + i;	
			dudes[i] SetScriptSpeed("run");
		}
		wait(2.3);
	}
}




pre_backdraft_wave()
{
	ori = getent("corridor_pipe_ori6", "targetname");
	while(1)
	{
		if(level._ai_group["pre_backdraft_wave"].aicount == 0)
		{
			objective_state(5, "done"); 
			wait(4);
			objective_add(6, "active", &"BARGE_UPPER_DECK", (ori.origin), &"BARGE_UPPER_DECK_INFO");
			
			break;
			
		}
		wait(0.5);
	}
}



additional_deck_fx(ori2)
{
	
	
	
	
	ori4 = getent("deck_ori4", "targetname");
	wait(2);
	radiusdamage(ori4.origin, 100,200,100);
	dmg = Spawn("script_origin", ori4.origin, 0, 0, 100);
 	dmg thread consistant_damage_util();
	playfx (level._effect["fxfire3"], ori4.origin +(0, 0, 0));
	ori4 playloopsound("BRG_fire");
	wait(1);
	level.player shellshock("default", 1);
	
	
}





deck_use1T(awareness_object)
{
	trigger = getent("deck_use1T", "targetname");
	
	
	startdistraction("deck_distraction1", 0);
	fx = getent("dist1_fx_ori", "targetname");
	
	wait(1);
	trigger trigger_off();
}





deck_pipe_trap(awareness_object)
{
	door = getent("deck_fall", "targetname");
	ori = getent("deck_pipe_ori", "targetname");
	ori2 = getent("deck_pipe_ori2", "targetname");
	trigger = getent("pipe_trigger", "targetname");
	
	door rotatepitch( 125, 0.5 );
	
	
	ori2 playsound("BRG_Mousetrap5");
	
	radiusdamage(ori2.origin, 300,400,300);
}





corridor_battle()
{
	trigger = getent("corridor_battleT", "targetname");
	trigger waittill("trigger");
	array = getentarray("corridor_battle_enemy", "script_noteworthy");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			array[i] SetAlertStateMin("alert_red");
			array[i].targetname = "corridor_battle_enemy" + i;
			
		}
	}
}







stern_spawn_thug_five()  
{
	stern_trigger_thug_five = getent ( "stern_trigger_thug_five", "targetname" );
	stern_trigger_thug_five waittill ( "trigger" );
	
	
	
	
	
	array = getentarray("first_door_enemies", "targetname");
	nodes = getnodearray("first_door_nodes", "targetname");
	bdnodes = getnodearray("bd_nodes", "targetname");
	ori = getent("backdraft_portal1_ori", "targetname");
	if(level.bdrft_var <= 3)
	{
		level notify("guys_in_tank_room");
		for (i = 0; i < array.size; i++)
		{
			array[i]= array[i] stalingradspawn();
			
			if(!maps\_utility::spawn_failed( array[i]))
			{
				array[i] SetAlertStateMin("alert_red");
				array[i] setgoalnode(bdnodes[i], 1);
				array[i].targetname = "fstdoor_enemy" + i;
				
				array[i] SetScriptSpeed("run");    
				
			}
		}
	}
	else if(level.bdrft_var > 3)
	{
		level notify("guys_in_tank_room");
		for (i = 0; i < array.size; i++)
		{
			
			if( !maps\_utility::spawn_failed( array[i]) )
			{
				
				
				
				
				
				
			}
		}
	}
}





tank_on_trigger()
{
	trigger = getent("tank_on_trigger", "targetname");
	trigger waittill("trigger");
	level thread backdraft_tanksT();
	level notify("tanks_released");
	
	
	level thread global_autosave();
}





scared_backdraft_guy()
{
	level.scared_guy = getent("scared_backdraft_guy", "targetname")  stalingradspawn( "scared_backdraft_guy" );
	node = getnode("scared_backdraft_guy_node", "targetname");
	blast_door_player_clip = getent("blast_door_player_clip", "targetname");
	door_blocker = getent("scared_door_blocker", "targetname");
	blast_door = getent("blast_door", "targetname");  
	blast_door_clip = getent("blast_door_clip", "targetname");
	trigger = getent("scared_backdraft_guyT", "targetname");
	if(!maps\_utility::spawn_failed(level.scared_guy) )
	{
		level.scared_guy SetAlertStatemin("alert_red");
		level.scared_guy SetScriptSpeed("run"); 
		level.scared_guy setenablesense(false);
		
	}
	level.scared_guy setgoalnode(node);
	door_blocker movez(120, 0.02);
	level waittill("tanks_released");
	trigger waittill("trigger");
	
	
	level.scared_guy cmdshootatentity(level.player, false, 2.5, .33, true);
	
	blast_door thread door_close_safety();
	level thread retreat_corridor_now(blast_door_clip, blast_door, door_blocker, blast_door_player_clip);
	if(isalive(level.scared_guy))
	{
		level endon("move_type2");
		blast_door_clip connectpaths();
		level.scared_guy waittill("cmd_done");
		level.scared_guy thread run_into_corridor(blast_door_clip);
		level waittill("ran_inside_bd");
		blast_door rotateyaw(90, 0.3, 0.2, 0.03);
		blast_door_player_clip rotateyaw(90, 0.3, 0.2, 0.03);
		wait(0.05);
		blast_door_clip movez(300, 0.01);
		door_blocker movez(-120, 0.02);
		
		level notify("blast_this");
		level notify("move_type1");
		
		
		blast_door_player_clip delete();
		blast_door playsound("BRG_hatch_door_close");
		wait(1);
		level thread door_objective_update();
		blast_door_clip disconnectpaths();
		
		level notify("playmusicpackage_action2");
	}
}

retreat_corridor_now(blast_door_clip, blast_door, door_blocker, blast_door_player_clip)
{
	level endon("move_type1");
	trigger = getent("player_charge_trigger", "targetname");
	trigger waittill("trigger");
	if(isalive(level.scared_guy))
	{
		level notify("move_type2");
		
		blast_door_clip connectpaths();
		level.scared_guy stopallcmds();
		level.scared_guy thread run_into_corridor(blast_door_clip);
		level waittill("ran_inside_bd");
		blast_door rotateyaw(90, 0.3, 0.2, 0.03);
		blast_door_player_clip rotateyaw(90, 0.3, 0.2, 0.03);
		wait(0.05);
		blast_door_clip movez(300, 0.01);
		door_blocker movez(-120, 0.02);
		level notify("blast_this");
		
		
		blast_door_player_clip delete();
		blast_door playsound("BRG_hatch_door_close");
		wait(1);
		level thread door_objective_update();
		blast_door_clip disconnectpaths();
		
		level notify("playmusicpackage_action2");
	}
}


door_objective_update()
{
	obj_ori = getent("backdraft_tank_ori1", "targetname");
	objective_state(6, "done");  
	wait(2);
	objective_add(13, "active", &"BARGE_BLOW_UP_DOOR_HEADER", (obj_ori.origin), &"BARGE_BLOW_UP_DOOR_BODY");
}
	

run_into_corridor(blast_door_clip)
{
	self endon("death");
	if(level.bdrft_var < 4)
	{
		blast_door_clip movez(-300, 0.01);
		self.tetherradius = 200;
		node2 = getnode("scared_run_node", "targetname");
		self setgoalnode(node2);
		self waittill("goal");
		level notify("ran_inside_bd");
		self delete();
	}
	else if(level.bdrft_var >= 4)
	{
		self cmdshootatentity(level.player, false, 4, 0.01);
	}
}

door_close_safety()
{
	level.scared_guy waittill("death");
	wait(0.05);
	level endon("blast_this");
	if(isdefined(self))
	{
		self rotateyaw(90, 0.3, 0.2, 0.03);
		self playsound("BRG_hatch_door_close");
		level notify("playmusicpackage_action2");
	}
}








deck_checkp1()
{
	level thread tank_on_trigger();
	blast_door_clip = getent("blast_door_clip", "targetname");
	blast_door = getent("blast_door", "targetname");  
	fxdoor = getent("fxanim_door_blast", "targetname");
	fxdoor hide();
	trigger_dmg = getent("fire_dmg_trig", "targetname");
	trigger_dmg trigger_off();
	ori = getent("off_boat_ori", "targetname");
	trigger2 = getent("backdraft_finalT", "targetname");
	trigger2 trigger_off();
	level waittill("tanks_released");
	level thread backdraft_voices();
	level thread backdraft_shoot_bondT();
	level waittill("fire_starter");
	level thread backdraft_final();
	fxdoor show();
	trigger2 trigger_on();
	blast_door delete();
	level waittill("backdraft");
	magic_trigger = GetEnt("tank_on_trigger","targetname");
	magic_trigger delete();
	blast_door_clip delete();
	radiusdamage(ori.origin, 15,500,450);
	wait(0.02);
	physicsExplosionSphere(ori.origin, 100, 80, 7);
}



portals_open()
{
	port1 = getent("port_window1", "targetname");
	port2 = getent("port_window2", "targetname");
	port3 = getent("port_window3", "targetname");
	sbm_port1 = getent("sbm_port_window1", "targetname");
	sbm_port2 = getent("sbm_port_window2", "targetname");
	sbm_port3 = getent("sbm_port_window3", "targetname");
	
	sbm_port3 rotateyaw(45, 0.4, 0.15, 0.15);
	port3 rotateyaw(45, 0.4, 0.15, 0.15);
	wait(2);
	sbm_port2 rotateyaw(67, 0.4, 0.15, 0.15);
	port2 rotateyaw(67, 0.4, 0.15, 0.15);
	wait(7);
	sbm_port1 rotateyaw(77, 0.4, 0.15, 0.15);
	port1 rotateyaw(77, 0.4, 0.15, 0.15);
}
	



backdraft_shoot_bondT()
{
	trigger = getent("backdraft_shoot_bondT", "targetname");
	ori1 = getent("backdraft_portal1_ori", "targetname");
	ori2 = getent("backdraft_portal2_ori", "targetname");
	guy1 = getent("fstdoor_enemy0", "targetname");
	guy2 = getent("fstdoor_enemy2", "targetname");
	guy3 = getent("fstdoor_enemy1", "targetname");
	while(1)   
	{
		if(level.player istouching(trigger))
		{
			if((isdefined(guy1)) && (level.bdrft_var < 4))
			{
				guy1 cmdshootatentity(ori1, false, 4, 0.45 );
			}
			if((isdefined(guy2)) && (level.bdrft_var < 4))
			{
				guy2 cmdshootatentity(ori2, false, 4, 0.45 ); 
			}
			else if((isdefined(guy1)) && (level.bdrft_var == 4))
			{
				guy1 lockalertstate("alert_red");
			}
			else if((isdefined(guy2)) && (level.bdrft_var == 4))
			{
				guy2 lockalertstate("alert_red");
			}
		}
		wait(1);
	}
}


fake_bullets()
{
	bullet_org = GetEnt("magic_start","targetname");
	bullet_pos = GetEntArray("magic_end","targetname");

	trigger = GetEnt("tank_on_trigger","targetname");

	while(IsDefined(trigger))
	{
		if(level.player istouching(trigger) && (!level.bdrft_var > 4))
		{
			number = RandomInt(bullet_pos.size);
			magicbullet("FRWL_Barge", bullet_org.origin, bullet_pos[number].origin);
		}
		wait(0.1);
	}

}



backdraft_voices()
{
	trigger3 = getent("backdraft_voicesT", "targetname");
	trigger3 waittill("trigger");
	if(level.bdrft_var < 4)
	{
		trigger3 play_dialogue_nowait("DOM1_BargG_079A");  
		wait(3);
		trigger3 play_dialogue_nowait("DMR2_BargG_080A");  
		wait(2);	
		level thread portals_open();
		level thread fake_bullets();
	}
}








backdraft_tanksT()
{
	level thread bd_guys_die();
	brush = getent("fire_protect_brush", "targetname");
	brush delete();
	tanks_trig = getent("backdraft_tanksT", "targetname");
	
	ori1 = getent("backdraft_tank_ori1", "targetname");
	ori2 = getent("backdraft_tank_ori2", "targetname");
	ori3 = getent("backdraft_tank_ori3", "targetname");
	ori4 = getent("backdraft_tank_ori4", "targetname");
	ori5 = getent("backdraft_tank_ori5", "targetname");
	node1 = getnode("wounded_guy1_node", "targetname");
	node2 = getnode("wounded_guy2_node", "targetname");
	guy1 = getent("fstdoor_enemy0", "targetname");
	guy2 = getent("fstdoor_enemy2", "targetname");
	guy3 = getent("fstdoor_enemy1", "targetname");
	
	while(1)
	{
		tanks_trig waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
		if(attacker == level.player) 
		{
			
			
			nsTanks = GetEnt("nsbargetanks", "targetname");
			nsTanks delete();
		
			radiusdamage(ori1.origin, 45, 200,100);
			radiusdamage(ori2.origin, 45, 200,100);
			level thread backdraft_rumble();
			level thread backdraft_tanks_remove_filter();
			level.bdrft_var = 4;
			wait(0.1);
			level notify("fire_starter");
			wait(0.1);
			radiusdamage(ori1.origin, 45, 200,100);
			radiusdamage(ori2.origin, 45, 200,100);
			radiusdamage(ori4.origin, 45, 200,100);
			radiusdamage(ori5.origin, 45, 200,100);
			
			dmg = Spawn("script_origin", ori1.origin, 0, 0, 50);
 			dmg thread consistant_damage_util();
 			dmg2 = Spawn("script_origin", ori2.origin, 0, 0, 50);
 			dmg2 thread consistant_damage_util();
 			dmg3 = Spawn("script_origin", ori3.origin, 0, 0, 50);
 			dmg3 thread consistant_damage_util();
 			dmg4 = Spawn("script_origin", ori3.origin, 0, -40, 50);
 			dmg4 thread consistant_damage_util();
 			
			playfx (level._effect["fxfire3"], ori1.origin +(0, 0, 0));
			ori1 playloopsound("BRG_fire");
			wait(1);
			playfx (level._effect["fxfire3"], ori2.origin +(0, 0, 0));
			ori2 playloopsound("BRG_fire");
			wait(1);
			radiusdamage(ori4.origin, 45, 200,100);
			radiusdamage(ori5.origin, 45, 200,100);
			playfx (level._effect["fxfire3"], ori3.origin +(0, 0, 0));
			ori3 playloopsound("BRG_fire");
			level thread black_door_smoke();
			level thread bd_fire_clip();
			backdraft_final();
			break;
		}
		wait(0.1);
	}
}




backdraft_tanks_remove_filter()
{
	tank2_array_plyr = getentarray("blast_room_tanks", "script_noteworthy");
	if(isdefined(tank2_array_plyr))
	{
		for(i = 0; i < tank2_array_plyr.size; i++)
		{
			level notify("tanks_all_dead");
			playfx (level._effect["fxgen09"], tank2_array_plyr[i].origin);
			tank2_array_plyr[i] delete();
		}
	}
}




bd_fire_clip()
{
	clips = getentarray("bd_fire_clips", "targetname");
	for (i = 0; i < clips.size; i++)
	{
		clips[i] movez(48, 0.1);
	}
}




bd_guys_die()
{
	level waittill("guys_in_tank_room");
	guy1 = getent("fstdoor_enemy0", "targetname");
	guy2 = getent("fstdoor_enemy2", "targetname");
	guy3 = getent("fstdoor_enemy1", "targetname");
	wait(0.1);
	level waittill("fire_starter");
	if(isalive(guy1))
	{
		guy1 dodamage(1000, (0,0,5));
	}
	if(isalive(guy2))
	{
		guy2 dodamage(1000, (0,0,5));
	}
	if(isalive(guy3))
	{
		guy3 dodamage(1000, (0,0,5));
	}
}




backdraft_rumble()
{
	while(1)
	{
		if(level.bdrft_var == 4)
		{
			level.player playrumbleonentity("damage_light");
			PlayRumbleLoopOnPosition("damage_light", level.player.origin);
			earthquake(0.2, .25, level.player.origin, 100);
		}
		else if(level.bdrft_var == 5)
		{
			level.player playrumbleonentity("damage_heavy");
			
			level notify("guys_in_tank_room");
			earthquake(0.6, 1, level.player.origin, 100);
			break;
		}
	wait(0.25);
	}
}	



black_door_smoke()
{
	level endon("backdraft");
	blk_ori = getent("corridor_pipe_ori6", "targetname");
	while(1)
	{
		playfx (level._effect["barge_door_smoke"], blk_ori.origin +(0, 0, 0));
		wait(1);
	}
}








backdraft_final()
{
	
	obj_ori = getent("crane_death_ori1", "targetname"); 
	trigger = getent("backdraft_finalT", "targetname");
	trigger waittill("trigger");
	door_blocker = getent("scared_door_blocker", "targetname");
	door_blocker movez(-120, 0.1);
	level.bdrft_var = 5;
	ori3 = getent("corridor_pipe_ori3", "targetname");
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	vision_trigger = getent("backdraft_afterT", "targetname");
	vision_trigger waittill("trigger");
	level notify("vents_break_start");
	ori3 playsound("BRG_vent_collapse");
	level thread bdr_elec_wires();
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	
	wait(0.1);
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	wait(1.5);
	objective_add(8, "active", &"BARGE_GET_TO_THE_FRONT", (obj_ori.origin), &"BARGE_GET_TO_THE_FRONT_INFO");
	
}

bdr_elec_wires()
{
	ori1 = getent("spark_wires_ori1", "targetname");
	ori2 = getent("spark_wires_ori2", "targetname");
	ori3 = getent("spark_wires_ori3", "targetname");
	spark[0] = "spark1";
	spark[1] = "barge_electric_spark1";
	level.sparking = true;
	level thread sparking_end();
	while(level.spark_var == 0)
	{
		s = randomfloatrange(0.1, 2.1);
		r = randomfloatrange(s, 2.5);
		rnd = randomint(2);
		playfx (level._effect[spark[rnd]], ori1.origin);
		radiusdamage(ori1.origin -(0,0,10), 60, 50, 15);
		rnd = randomint(2);
		playfx (level._effect[spark[rnd]], ori2.origin);
		radiusdamage(ori2.origin -(0,0,10), 60, 50, 15);
		rnd = randomint(2);
		playfx (level._effect[spark[rnd]], ori3.origin);
		radiusdamage(ori3.origin -(0,0,10), 60, 50, 15);
		wait(r);
	}
}

sparking_end()
{
	trigger = getent("exit_to_side_T", "targetname");
	trigger waittill("trigger");
	level.spark_var = 1;
}

corridor_runback()
{
	
	trigger = getent("corridor_plydmgT","targetname");
	wait(10);
	trigger trigger_off();
}

corridor_pipe()
{
	trigger = getent("corridor_pipeT", "targetname");
	ori1 = getent("corridor_pipe_ori", "targetname");
	trigger waittill("trigger");
	playfx (level._effect["pipesteam"], ori1.origin +(0, 0, 0));
	earthquake(0.5, 0.6, ori1.origin, 1000);
	wait(1);
	
	wait(2);
}

backdraft_ai_trigger()
{
	trigger = getent("backdraft_ai_trigger", "targetname");
	trigger waittill("trigger");
	level.bdrft_var ++;
}





corridor_tanks()
{
	trigger = getent("corridor_plydmgT","targetname");
	trigger trigger_on();
	look = getent("backdraft_lookat_t", "targetname");
	
	ori1 = getent("corridor_tanks_ori", "targetname"); 
	ori2 = getent("corridor_pipe_ori2", "targetname"); 
	ori3 = getent("corridor_pipe_ori3", "targetname");
	ori4 = getent("corridor_pipe_ori4", "targetname"); 
	ori5 = getent("corridor_pipe_ori5", "targetname");
	ori6 = getent("corridor_pipe_ori6", "targetname");	
	ori7 = getent("corridor_pipe_ori7", "targetname"); 	
	while(1)
	{
		if(level.bdrft_var == 5)        	
		{
			look waittill("trigger");
			level notify("backdraft"); 
			radiusdamage(ori7.origin, 190, 200, 1);
			
			playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
			ori1 playsound("BRG_backdraft");
			objective_state(13, "done");
			wait(0.1); 
			level notify("door_blast_start"); 
			
			radiusdamage(ori7.origin, 190, 200, 1);
			physicsExplosionSphere(ori6.origin, 200, 199, 40);
			wait(0.1);
			playfx (level._effect["fxpumpgen"], ori3.origin +(0, 0, 0));
			
			wait(0.1);
			playfx (level._effect["exp_fireext_haze"], ori4.origin +(0, 0, 0));
			wait(0.1);
			playfx (level._effect["fxdoor"], ori6.origin +(0, 0, 0));		
			corridor_runback();
			break;
		}
		wait(0.1);
	}
}




corridor1_steam_ori()
{
	
	array = getentarray("corridor1_steam_ori", "targetname");
	for (i = 0; i < array.size; i++)
	{
		playfx (level._effect["ambientS"], array[i].origin);
	}
}










exit_to_side()
{
	trigger= getent("exit_to_side_T", "targetname");
	trigger waittill("trigger");
	level thread scared_man_trigger();
	level thread roof_fog_fx();
	
	
  
		
		
  
  
  
  level thread global_autosave();
}




roof_fog_fx()
{
	fog_array = getentarray("roof_fog_ori", "targetname");
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog"], fog_array[i].origin +(0, 0, 0));
  	}
  wait(13);
	}
}


roof_fog_fxx()
{
	fog_array = getentarray("roof_fog_orix", "targetname");
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog2"], fog_array[i].origin +(0, 0, 0));
  	}
  wait(13);
	}
}

roof_fog_fxy()
{
	fog_array = getentarray("roof_fog_oriy", "targetname");
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog"], fog_array[i].origin +(0, 0, 0));
  	}
  wait(13);
	}
}


roof_fog_fxz()
{
	fog_array = getentarray("roof_fog_oriz", "targetname");
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog2"], fog_array[i].origin +(0, 0, 0));
  	}
  wait(13);
	}
}


top_of_stairsT()
{
	trigger = getent("top_of_stairsT", "targetname");
	trigger waittill("trigger");
	level notify("stair_top");
}



stairs_runawayT()
{
	trigger = getent("stairs_runawayT", "targetname");
	array = getentarray("stair_runaways", "targetname");
	nodes = getnodearray("stair_runaways_nodes", "targetname");
	trigger waittill("trigger");
	level notify("bg_cup_start");
	for(i = 0; i < array.size; i++)
	{
		array[i] = array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
			{
				array[i] SetAlertStateMax("alert_green");
				
				
				array[i] SetScriptSpeed("run"); 
				array[i] setgoalnode(nodes[i]);  
				array[i] waittill("goal");
				array[i] delete();
			}
	}
}



scared_man_trigger()
{
	
}
	
	


cargo_enemies()
{
	trigger = getent("cargo_enemyT", "targetname");
	trigger2 = getent("cargo_enemiesT2", "targetname");
	trigger waittill("trigger");
	wait(0.05);
	thread maps\_autosave::autosave_now("barge");
	wait(0.05);
	level thread train_top_trigger();
	
	bow_cargo_crashT = getent("bow_cargo_crashT", "targetname");
	
	trigger2 waittill("trigger");
	level thread kratt_cage_door_close();
	
	
	level notify("playmusicpackage_climax");

	
	
	
	
	
	
	
	
			
	
	
	
	
	
	
	
  
  
  
  
  
	
	
}



kratt_cage_door_close()
{
	door = getent("kratt_cage_door", "targetname");
	door rotateyaw(215, 0.1);
	door delete();
}



train_top_trigger()
{
	train_top = getent("train_top_trigger", "targetname");
	look_trig = getent("supress2_lookat", "targetname");
	
	spn_trigger = getent("supress2_spawnT", "targetname");
	spn_trigger waittill("trigger");
	
	
	node2 = getnode("supressors2_escape_node2", "targetname");
	
	
	level thread shooter1();
	level thread shooter2();

	level.player play_dialogue_nowait("BMR3_BargG_039A");
	train_top waittill("trigger");
	look_trig waittill("trigger");
	
	level notify("bond_train_up");
	level thread supress2_help();
	wait(3);
	level notify("shooters_done");
}

shooter1()
{
	shooter1 = getent("supressors2_top1", "targetname")  stalingradspawn( "top1" );
	if( !maps\_utility::spawn_failed( shooter1) )
	{
		shooter1 SetAlertStateMin("alert_red");
		shooter1 SetScriptSpeed("run");
		shooter1.accuracy = 0.001;
	}
	level waittill("bond_train_up");
	shooter1 thread run_logic1();
}

shooter2()
{
	shooter2 = getent("supressors2_top2", "targetname")  stalingradspawn( "top2" );
	if( !maps\_utility::spawn_failed( shooter2) )
	{
		shooter2 SetAlertStateMin("alert_red");
		shooter2 SetScriptSpeed("run");
		shooter2.accuracy = 0.001;
	}
	level waittill("bond_train_up");
	shooter2 cmdshootatentity(level.player, false, 4, 0.05);
	shooter2 waittill("cmd_done");
	shooter2 thread run_logic2();
}

run_logic1()
{
	node = getnode("supressors2_escape_node", "targetname");
	self endon("death");
	self SetAlertStateMax("alert_green");
	self setignorethreat(level.player, true);
	self setgoalnode(node, 1);
	self waittill("goal");
	self setignorethreat(level.player, false);
	self SetAlertStateMin("alert_red");
}

run_logic2()
{
	self endon("death");
	node = getnode("supressors2_escape_node2", "targetname");
	self stopallcmds();
	
	self setignorethreat(level.player, true);
	self setgoalnode(node, 1);
	self waittill("goal");
	self setignorethreat(level.player, false);
	self SetAlertStateMin("alert_red");
}

destroy_trigger()
{
	wait(1.7);
	trigger = GetEnt("train_top_trigger", "targetname");
	trigger delete();
}

supress2_help()
{
	bullet_org = GetEnt("supress2_start","targetname");
	bullet_pos = GetEntArray("supress2_end","targetname");

	trigger = GetEnt("train_top_trigger", "targetname");
	
	while(IsDefined(trigger))
	{
		x = randomfloatrange( 0.08, 0.1);
		level endon("shooters_done");
		if(level.player istouching(trigger))
		{
			number = RandomInt(bullet_pos.size);
			magicbullet("FRWL_Barge", bullet_org.origin, bullet_pos[number].origin);
		}
		wait(x);
	}

}


catwalk_mapT()
{
	catwalks = getent("catwalk_mapT", "targetname");
	level endon("cargo_crashing");
	while(1)
	{
		if(level.player istouching(catwalks))
		{
			setSavedDvar( "sf_compassmaplevel", "level4" );
		}
		else
		{
			setSavedDvar( "sf_compassmaplevel", "level3" );
		}
		wait(1);
	}
}	
		






side_to_roofT()
{
	cargo_colL = getent("container_collisionL", "targetname");
	cargo_colR = getent("container_collisionR", "targetname");
	
	cargo_colL movez(3000, 0.1);
	cargo_colR movez(3000, 0.1);
	
	cargo_colL connectpaths();
	cargo_colR connectpaths();
	
	trigger = getent("side_to_roofT", "targetname");
	trigger waittill("trigger");
	
	
	level thread crane_cargo();
	
	
	
	
	
	
	
	
	
	level thread global_autosave();
	setSavedDvar( "sf_compassmaplevel", "level3" );
	level thread catwalk_mapT();
	
	
	array = getentarray("canopy_enemies1", "targetname");
	if(level.deck_event == 0)
	{
		for (i = 0; i < array.size; i++)
		{
			array[i]= array[i] stalingradspawn();
			if( !maps\_utility::spawn_failed( array[i]) )
			{
				array[i] SetAlertStateMin("alert_yellow");
				array[i].targetname = "canopy_enemy_one" + i;
				
				array[i] SetScriptSpeed("jog");    
			}
		}
	}
	else if(level.deck_event == 1)
	{
		for (i = 0; i < array.size; i++)
		{
			array[i]= array[i] stalingradspawn();
			if( !maps\_utility::spawn_failed( array[i]) )
			{
				array[i] SetAlertStateMin("alert_red");
				array[i].targetname = "canopy_enemy_one" + i;
				
				array[i] SetScriptSpeed("run");   
			}
		}
	}
}








canopy_al_checks()
{
	trigger = getent("canopy_alert_trigger", "targetname");
	array = getentarray("canopy_enemies2", "targetname");
	nodes = getnodearray("canopy2_nodes", "targetname"); 
	trigger waittill("trigger");
	level thread kratt_fight();
	while(1)
	{
		if(level._ai_group["canopy_noname"].aicount < 4)
		{
			for (i = 0; i < array.size; i++)
			{
				array[i]= array[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( array[i]) )
				{
					array[i] SetAlertStateMin("alert_yellow");
					array[i] AddEngageRule("tgtperceive");
					array[i].targetname = "canopy_enemy_two" + i;
					
					array[i] thread flash_sense();
					array[i] setgoalnode(nodes[i], 1);
					
					array[i] SetScriptSpeed("jog");   
				}
			}
			break;
		}
		else if(level._ai_group["canopy_noname"].aicount == 0)
		{
			for (i = 0; i < array.size; i++)
			{
				array[i]= array[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( array[i]) )
				{
					array[i] SetAlertStateMin("alert_red");
					array[i].targetname = "canopy_enemy_two" + i;
					array[i] AddEngageRule("tgtperceive");
					
					array[i] thread flash_sense();
					array[i] setgoalnode(nodes[i], 1);
					
					
					array[i] SetScriptSpeed("run");   
				}
			}
			break;
		}
	wait(0.5);
	}
}

flash_sense()
{
	self endon("death");
	self setperfectsense(true);
	wait(5);
	self setperfectsense(false);
}




b_room_ceilingT()
{
	trigger = getent("b_room_ceilingT", "targetname");
	ori = getent("b_room_fire_ori", "targetname");
	trigger waittill("trigger");
	playfx (level._effect["ceiling_smoke01"], ori.origin);
}





ship_front_enemies()
{
	trigger = getent("ship_front_enemiesT", "targetname");
	trigger waittill("trigger");
	array = getentarray("shipfront_enemies", "targetname");
	for (i = 0; i < array.size; i++)
	{
		array[i]= array[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( array[i]) )
		{
			array[i] SetAlertStateMin("alert_red");
			array[i].targetname = "front_enemy" + i;
			
			
			
		}
	}
}




trap_door()
{
	trigger = getent("trap_doorT", "targetname");
	door_left = getent("trap_door_l", "targetname");
	door_right = getent("trap_door_r", "targetname");
	
	trigger waittill("trigger");
	door_left rotateroll(-135, 2.5, 0.5, 0.5);
	door_right rotateroll(135, 2.5, 0.5, 0.5);
	door_left playsound("BRG_double_doors_close");
}

trap_door_use(awareness_object)
{
	door_left = getent("trap_door_l", "targetname");
	door_right = getent("trap_door_r", "targetname");
	door_left rotateroll(135, 3, 1, 1);
	door_right rotateroll(-135, 3, 1, 1);
	door_left playsound("BRG_double_doors_open");
	
	level.player freezecontrols(true);
	
	
 	
 	
 	level.player customcamera_checkcollisions( 1 );
 	
	endcin  = level.player customCamera_push(
		"world",							
		level.player.origin +(50, -50, 60),				
		(50, 0, 0),				
		3.00,								
		0.00,
		2.5
		);

 	
	wait(3); 
	
	
	level.player freezecontrols(false);
	
	lechiffre = getent("torture_lechiffre" , "targetname")  stalingradspawn("lechiffre");
	lechiffre waittill("finished spawning");
	
	lechiffre maps\_utility::gun_remove();
	lechiffre attach( "w_t_pipe", "TAG_WEAPON_RIGHT" );		
	
	vesper = getent("vesper_torture" , "targetname")  stalingradspawn("vesper");
	vesper waittill("finished spawning");
	wait(0.05);
			
	
	level notify("endmusicpackage");
	
	playcutscene("Barge_Drop", "Barge_Drop_End");
	level waittill("Barge_Drop_End");
	visionsetnaked("barge_dark", 0.01);
	setDvar( "cg_disableHudElements", 1 );
	maps\_endmission::nextmission();

	
	
	
}


kratt_fight()
{
	trigger = getent("fight_area_trigger1", "targetname");
	trigger waittill("trigger");
	
	
	
	level thread kratt_spawn_final();
}

kratt_spawn_final()
{
	while(1)
	{
		if(level._ai_group["final_wave"].aicount == 0)
		{
			level.kratt_final = getent("kratt_boss_final", "targetname")  stalingradspawn( "kfinal" );
			if(!maps\_utility::spawn_failed( level.kratt_final))
			{
				
				level.kratt_final SetAlertStateMin("alert_red");
				level.kratt_final.goalradius = 12;
				level.kratt_final SetScriptSpeed("walk");
				level.kratt_final play_dialogue_nowait("KRAT_BargG_201A"); 
				level.kratt_final.accuracy = 111;
				
			}
			level thread kratt_final_attack();
			level thread kratt_exploder_trigger();
			level thread control_shoot_doorT1();
			level thread kratt_on_death();
			break;
		}
		wait(0.2);
	}
	
}

kratt_on_death()
{
	level.kratt_final waittill("death");
	ori = getent("kratt_exploder_origin", "targetname");
	ori radiusdamage(ori.origin, 60, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 60, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 60, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 60, 200,100);
	level.control_door = 1;
}

kratt_exploder_trigger()
{
	trigger = getent("kratt_exploder_trigger", "targetname");
	ori = getent("kratt_exploder_origin", "targetname");
	trigger waittill("trigger");
	ori radiusdamage(ori.origin, 60, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 60, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 60, 200,100);
	level.control_door = 1;
}


kratt_final_attack()
{
	
	
	
	
	
	attk = getent("fight_area_trigger1", "targetname");
	node1 = getnode("kratt_final_pos1", "targetname");
	node2 = getnode("kratt_final_pos2", "targetname");
	level.kratt_fight_var =1;
	
	level.kratt_final endon("death");
	while(1)
	{
		if(level.player istouching(attk))
		{
			level.kratt_final setgoalnode(node1, 1);
			level.kratt_final waittill("goal");
			level.kratt_final.grenadeWeapon = "flash_grenade";
			level.kratt_final.grenadeAmmo = 1;
			level.kratt_final cmdthrowgrenadeatentity(level.player, false, 5, 1);
			
			wait(3);
			level.kratt_final.grenadeWeapon = "concussion_grenade";
			level.kratt_final.grenadeAmmo = 1;
			level.kratt_final cmdthrowgrenadeatentity(level.player, false, 5, 1);
			
			wait(3);
		}
		else
		{
			level.kratt_final setgoalnode(node2);
			level.kratt_final waittill("goal");
		}
		wait(1);
	}
}

spotlight3_logic()
{
	
	attk = getent("fight_area_trigger1", "targetname");
	
	light_origin = getent("spotlight3_script_origin", "targetname");
	spotlight = getent("spotlight_three", "targetname");
	spotlight_arm = getent("spotlight_one_arm", "targetname");
	
	spotlight_tag = Spawn("script_model", light_origin.origin + (0, 0, 0));
	spotlight_tag SetModel("tag_origin");
	spotlight_tag.angles = light_origin.angles;
	spotlight_tag LinkTo(light_origin);
	PlayFxOnTag(level._effect["vol_light02"], spotlight_tag, "tag_origin");
	
	
	
	
	z = randomintrange(1,2);
	while(1)
	{
		if(level.player istouching(attk))
		{
			
			ply = level.player.origin - spotlight.origin;
			ply2 = spotlight.origin - level.player.origin;
			spotlight rotateto(VectorToAngles(ply2)+(0, -90, 0), 0.4, 0.2, 0.1);	
			light_origin rotateto(VectorToAngles(ply)+( 0 , 0, 0), 0.4, 0.2, 0.1);	
			spotlight waittill("rotatedone");
			
		}
		else if(level.kratt_fight_var== 1)
		{
			spotlight_tag delete();
			
			break;
		}
		wait(0.02);
	}
}







control_shoot_doorT1()   
{
	trigger = getent("crane_damage_trigger", "targetname");
	
	trigger waittill("damage");
	playfx (level._effect["bullets"], trigger.origin);
	wait(0.1);
	playfx (level._effect["bullets"], trigger.origin);
	level.control_door =1;
	level.player playsound("BRG_Control_door_dmg");
}




cargo_door_setup()
{
	cargo = getent("crane_cargo", "targetname");
	door1 = getent("cargo_container_door1", "targetname");
	door2 = getent("cargo_container_door2", "targetname");
	door1 linkto(cargo);
	door2 linkto(cargo);
}




crane_cargo()
{
	save_trigger = getent("after_cargo_drop_saveT", "targetname");
	ori1 = getent("crane_death_ori1", "targetname");
	ori2 = getent("crane_death_ori2", "targetname");
	
	while(1)
	{
		if(level.control_door == 1)
		{
			
			level notify("cargo_drop_container_start");
      level notify("cargo_drop_inards_start");
			level notify("cargo_drop_fence_start");
			cargo_colL = getent("container_collisionL", "targetname");
			cargo_colR = getent("container_collisionR", "targetname");
			
			cargo_colL movez(-3000, 0.1);
			cargo_colR movez(-3000, 0.1);
			
			
			
			
			
			ori1 thread damage_under_container();
			ori1 playsound("BRG_cargo_crash_01");
			level thread kratt_tanks_final();
			
			level thread maps\_autosave::autosave_now("barge");
		
			door = getent("control_shoot_door2", "targetname");
			door delete();
			level thread objective_eight_criteria();
			railing = getentarray("railing_one", "targetname");
			for (i = 0; i <railing.size; i++)
			{
				railing[i] delete();
			}
			wait(3);
			break;
		}
		else if(level.control_door == 4)
		{
			
			
			
		}
		else if(level.control_door == 3)
		{
			
			
			
			
			
		}
	wait(1);
	}
	
	wait(11);
	
	
	
}

kratt_tanks_final()
{
	ori = getent("kratt_exploder_origin", "targetname");
	tanks = getentarray("kratt_tanks_final", "script_noteworthy");
	if(isdefined(tanks))
	{
		for (i = 0; i <tanks.size; i++)
		{
			tanks[i] dodamage(1000, (0,0,5));
		}
	}
	ori radiusdamage(ori.origin, 150, 200,100);
	wait(3);
	ori radiusdamage(ori.origin, 150, 200,100);
}


kratt_cage_door_open()
{
	
	
}

damage_under_container()
{
	wait(1.8);
	radiusdamage(self.origin, 150, 200,100);
	level thread kratt_cage_door_open();
}



objective_eight_criteria()
{
	objective_state(8, "done");  
	wait(4);
	objective_add(9, "active", &"BARGE_INTO_THE_BARGE", (0,0,0), &"BARGE_INTO_THE_BARGE_INFO" );
}




grav_dir()
{
	front = getent("cargo_ori_right", "targetname");
	back = getent("cargo_ori_right", "targetname");
	left = getent("cargo_ori_right", "targetname");
	right = getent("cargo_ori_right", "targetname");
	while(1)
	{
		if(level.control_door == 0)
		{
			
			
			
			wait(8);
			
			
			
		}
		else if(level.control_door == 1)
		{
			
			
		}
	wait(1);
	}
}
	

bow_cargo_crashT()
{
	trigger = getent("bow_cargo_crashT", "targetname");
	trigger waittill("trigger");
	level thread cargo_crash();
	level notify("cargo_crashing");
	trigger playsound("BRG_cargo_crash_02");
	setSavedDvar("sf_compassmaplevel", "level5" );
	level thread puzzle_room_mapT();
			
		
}
	
puzzle_room_mapT()
{
	upper_level = getent("puzzle_room_mapT", "targetname");
	
	while(1)
	{
		if(level.player istouching(upper_level))
		{
			setSavedDvar( "sf_compassmaplevel", "level6" );
		}
		else
		{
			setSavedDvar( "sf_compassmaplevel", "level5" );
		}
		wait(1);
	}
}	

cargo_crash()
{
	
	

	
	glasses = getentarray("bow_window1_ori", "targetname");
	
	
	
	
	
	
	
	maps\_utility::holster_weapons();
	wait(1.4);
	

	
	level notify("cargo_drop_glass_start");
	level notify("cargo_drop_inards_slip_start");
	
	
	level notify("cargo_drop_container_slip_start");
  level notify("cargo_drop_fence_slip_start");
  wait(1);
  for (i = 0; i < glasses.size; i++) 
	{
		playfx (level._effect["bow_glass"], glasses[i].origin);
		wait(0.1);
	}



	
	
	
	
	

	
	
	
	
	
	level thread super_tilt();
	
	ori1 = getent("bow_water_splash1", "targetname");
	ori2 = getent("bow_water_splash2", "targetname");
	wait(1);
	earthquake(1.5, 0.8, level.player.origin, 100);
	
	wait(0.3);
	ori1 playsound("BRG_tilt_wrong");
	
	wait(0.7);
	
	
	level thread room_flood();
	wait(3);
	
}

cargo_debris_util()
{

	

	

}
	
room_flood()
{
	water = getent("rising_water_brush", "targetname");
	
}
	





super_tilt()
{
	level endon("stop_super_tilt");
	
	flag_set("super_tilt");
	
	

	

	

	while (true)
	{
		a = 0;
		b = 0;
		c = 0;
		if (RandomInt(2) % 2)
		{
			a = RandomFloatRange(3, 5);
			
			if (RandomInt(2) % 2)
			{
				a *= -1;
			}
		}
		else
		{
			c = RandomFloatRange(3, 5);
			
			if (RandomInt(2) % 2)
			{
				c *= -1;
			}
		}
		b = RandomFloatRange(2, 4.5);
		
		if (RandomInt(2) % 2)
		{
			b *= -1;
		}
		
		angles = (a, b, c);
		level thread tilt_building(angles, RandomFloatRange(5, 7));
		
		wait 1;
		level waittill("darkness");
		
		
		
		
		
		
	}
}



tilt_building(tilt, time, tilt_back, new_angles)
{


	
	flag_clear( "_sea_viewbob" ); 
	flag_clear("_sea_physbob"); 	
	flag_clear("_sea_bob");				
	
	
	
	flag_waitopen("tilting");
	
	
	
	flag_set("_sea_viewbob");
	flag_set("tilting");
	flag_set("_sea_physbob");		
	
	
	
	
	
	
	
	
	if (!IsDefined(time))
	{
		time = 3;
	}
	
	level.tilting = true;
	
	
	
	
	level._sea_world_rotation = (11, 0, 0);
	
	level.ground = level.sea_world_rotation;
	
	
	
	
	
	wait time;
	
	if (IsDefined(tilt_back) && tilt_back)
	{
		
		time = time / 3;
		
		
		
		
	}
	else if (IsDefined(new_angles))
	{
		
		time = time / 3;
		
		
		
		
		
	}
	
	
	
	level._sea_scale = 0.01;
	level._sea_physbob_scale = 0.5;
	flag_wait("_sea_viewbob");
	flag_wait("super_tilt");
	
	
	
}

stop_super_tilt()
{
	level notify("stop_super_tilt");
	flag_clear("super_tilt");
	
	flag_clear( "_sea_viewbob" );
	flag_clear("_sea_physbob");
	flag_clear("_sea_bob");
	level._sea_viewbob_scale = 0.2;
	
}









bond_gets_hurt()
{
	
	
	
	maps\_utility::holster_weapons();
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	visionsetnaked("barge_dark", 1);
	setDvar( "cg_disableHudElements", 1 );
	

	
	
	
	
}

change_lvl_thrd()
{
	wait(24);
	visionsetnaked("barge_dark", 0.01);
}

barge_end()
{
	wait(20);

	
}


pacer()
{
	
	
	
	
}


whip_it()
{
	
}




global_autosave()
{
	alldead = false;
	while( !(alldead) )
	{
		guards = getaiarray("axis", "neutral");
		if ( !(guards.size) &&  !isanyaidying("axis", "neutral") )
		{
			thread maps\_autosave::autosave_by_name("barge");
			
			alldead = true;
		}
		wait(0.5);
	}
}




checkpoint_deck01()
{
	deck_two_checkpoint = getent ( "deck_two_checkpoint", "targetname" );
	deck_two_checkpoint waittill ( "trigger" );
}

cleanup()
{
 	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++  )
	{
		array_ai[i] delete();
  }
}



global_checkpoint_before_big_fight()
{
	deck01_checkpoint_before_big_fight = getent ( "deck01_checkpoint_before_big_fight", "targetname" );
	deck01_checkpoint_before_big_fight waittill ( "trigger" );
	level notify ( "deck01_complete" );
	
	
}


amb_miss_trigger1()
{
	trigger = getentarray("amb_miss_trigger1", "targetname");
	for (i = 0; i < trigger.size; i++  )
	{
		trigger[i] thread amb_miss_trig1_think();
	}
}


amb_miss_trig1_think()
{
	self waittill ( "trigger" );
	playfx (level._effect["flash"], self.origin +(0, 0, 0));
	wait(0.1);
	playfx (level._effect["bullets"], self.origin);
	wait(0.1);
	playfx (level._effect["bullets"], self.origin);
	self delete();
}








global_fire_ext_triggers()
{
	fxsomke = loadfx ( "smoke/smoke_grenade" );
	global_fire_ext = getentarray ( "global_fire_ext", "targetname" );
	
	for (i = 0; i < global_fire_ext.size; i++  )
	{
		global_fire_ext[i] thread global_fire_ext_think( fxsomke );
	}
}






global_fire_ext_think( fx )
{
	org = getent ( self.target, "targetname" );
	self waittill ( "damage" );
	fxid = playfx ( fx, org.origin );
	org playsound ( "extinguisher_imp" );
	wait (0.5);
	org playloopsound ( "extinguisher_loop" );
	wait (8);
	org stoploopsound();
}


















laptop1_event()  
{
	level notify("laptop1");
	data_collection_add( 0, "text", &"BARGE_NIGHT_VISION" , &"BARGE_NIGHT_VISION_MENU");
	box_door = getent("cache_crate_lid_1", "targetname");
	box_door rotateroll(90, 1);
}


night_visionT()
{
	trigger = getent("night_visionT", "targetname");
	trigger trigger_off();
	
	trigger trigger_on();
	trigger setHintString("Grab the Night Vision Scope");
	trigger waittill("trigger");
	level.night_vision = 1;
	wait(0.25);
	
	
	level thread weapon_toggle();
	wait(1);
	
	trigger delete();
}



weapon_toggle()
{
	level thread night_vision_death_check();
	level thread ads_night();
	
	while(level.night_vision ==1)
	{
		if ((level.player buttonpressed("DPAD_DOWN")) && (level.attach_toggle == 0))
		{
			
			level.attach_toggle = 1;
			level thread ads_night();
			wait(0.25);
			
		}
		else if((level.player buttonpressed("DPAD_DOWN")) && (level.attach_toggle ==1))
		{
			
			level.attach_toggle = 0;
			level thread ads_normal();
			wait(0.25);
			
		}
		wait(0.25);
	}
}


night_vision_death_check()
{ 
	level.player waittill("death");
	level.attach_toggle = 0;
	
	VisionSetNaked("barge_1", 0.01);
}

ads_night()
{
	level endon("death");
	while(1)
	{
		if(!level.attach_toggle == 0)
		{
			
		
			
			
			if( getDvar( "cg_playerWepIsZoomed" ) != "0" )
			{
				VisionSetNaked("barge_night", 0.01);
				
			}
			else
			{
				VisionSetNaked("barge_1", 0.01);
			}
		}
		else if(!level.attach_toggle == 1)
		{
			break;
		}
		wait(0.1);
	}
}

ads_normal()
{
	
	while(1)
	{
		if(!level.attach_toggle == 1)
		{
			if(level.player playerads() > 0.01)
			{
				VisionSetNaked("barge_1", 0.01);
				
			}
			else
			{
				VisionSetNaked("barge_1", 0.01);
			}
		}
		else if(!level.attach_toggle == 0)
		{
			break;
		}
		wait(0.1);
	}
}




kratt_talk1()
{
	kratt = getent("kratt", "targetname");
	kratt SetScriptSpeed("run"); 
	
	
}


kratt_delete1()
{
	
}







hit_the_lights()
{
	trigger2 = getent("hit_the_lights", "targetname");
	trigger2 waittill("trigger");
	level thread kratt_vesper_end();
	
	level thread unreal_halfwayT();
	
	
	
	
	
	
}

kratt_vesper_end()
{
	maps\_utility::holster_weapons();
	trigger2 = getent("kratt_deck_runT", "targetname");  
	trigger2 waittill("trigger");
	level.kratt_hst = getent ("kratt_end_spawner", "targetname")  stalingradspawn( "kratt_end" );
	
	level.kratt_hst.health = 150;
	level.kratt_hst.tetherradius = 10;
	level.kratt_hst.accuracy = 1.0;
	level.vesper_hst = getent("vesper_torture", "targetname")  stalingradspawn( "Vvesper" );
	level.vesper_hst waittill ("finished spawning");
	level.kratt_hst cmdshootatentity(level.player, false, 5, 1);
	
	level.kratt_hst setenablesense(false);
	level.kratt_hst setenablesense(true);
	level.kratt_hst setalertstatemin("alert_red");
	trigger = getent("last_manT", "targetname");
	
	
	
	
	
	
	level thread kratt_end_death();
	
	wait(1);
	
}

kratt_end_death()
{
	level.kratt_hst waittill("death");
	wait(2);
	
}




kratt_vesper_blow_awayT()
{
	trigger = getent("kratt_vesper_blow_awayT", "targetname");
	trigger waittill("trigger");
	level.kratt_hst stopcmd();
	level.kratt_hst setenablesense(true);
	
	
	
	
	
}


its_over()
{
	
	level.kratt_hst stoppatrolroute();
	
	
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "Thats far enough" , (0, 1, 1), 1, 0.4, 30);
	wait(2);
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "Come Any Closer, and I'll blow her brains out" , (0, 1, 1), 1, 0.4, 30);
	wait(2);
	
	
	
	
	
	level thread behind_krattT();
}

sparkler()
{
	ori = getent("sparkler_ori", "targetname");
	while(1)
	{
		playfx (level._effect["bullets"], ori.origin);
		wait(0.7);
	}
}

behind_krattT()
{
	trigger = getent("behind_krattT", "targetname");
	trigger waittill("trigger");
	trigger2 = getent("kratt_vesper_blow_awayT", "targetname");
	trigger2 trigger_off();
}

electro_himT()
{
	node = getnode("vesper_run_node", "targetname");
	trigger = getent("electro_himT", "targetname");
	trigger sethintstring("Press me!");
	trigger waittill("trigger");
	level.kratt_hst stoppatrolroute();
	level thread sparkler();
	level thread zone1_lights();
	trigger2 = getent("kratt_vesper_blow_awayT", "targetname");
	trigger2 trigger_off();
	level.vesper_hst unlink();
	level.vesper_hst CmdPlayanim("Vesper_ShinKick");
	level.vesper_hst setgoalnode(node);
	level.kratt_hst cmdaction("flinch");
	x = gettime();
	while(1)    
	{
		level.kratt_hst endon("death");
		z = gettime();
		if(z -10000 > x)
		{
			
			level.kratt_hst stopcmd();
			level.kratt_hst setenablesense(true);
			level.player playsound ("BRG_Vesper_scream1");
			wait(2);
			level.player playsound ("BRG_Vesper_scream1");
			missionfailed();
		}
		wait(1);
	}
}




light_zone_intro()
{
	level thread kratt_lights1_on();
	level thread kratt_shoot_then_reload();
	wait(3);
	level thread kratt_shoot_then_reload();
	x = gettime();
	while(1)    
	{
		level.kratt_hst endon("death");
		z = gettime();
		if(z -6660 > x)
		{
			level thread kratt_lights1_off();
			level thread light_zones();
			level thread kratt_dynamics();
			break;
		}
		wait(1);
	}
}


kratt_shoot_then_reload()
{
	level.kratt_hst cmdshootatentity(level.player, false, 6 , 1);
}




light_zones()
{
	while(1)
	{
		level endon("switch_lights");
		level.kratt_hst endon("death");
		y = randomintrange(0,560);
		level.z_z = randomintrange(0,5);
		if(y <= 160)
		{
			level thread kratt_lights1_on();
			level.kratt_light_var = 1;
			
			wait(level.z_z);
			
			level thread kratt_lights1_off();
			level.kratt_light_var = 0;
		}
		else if((y > 160) && (y <=330))
		{
			level thread kratt_lights2_on();
			level.kratt_light_var = 2;
			
			wait(level.z_z);
			
			level thread kratt_lights2_off();
			level.kratt_light_var = 0;
		}
		else if((y > 330) && (y <=500))
		{
			level thread kratt_lights3_on();
			level.kratt_light_var = 3;
			
			wait(level.z_z);
			
			level thread kratt_lights3_off();
			level.kratt_light_var = 0;
		}
		wait(0.25);
	}
}


kratt_dynamics()
{
	shoot_area1 = getent("kratt_bond_shoot1T", "targetname");
	shoot_area2 = getent("kratt_bond_shoot2T", "targetname");
	shoot_area3 = getent("kratt_bond_shoot3T", "targetname");
	while(1)
	{ 
		level.kratt_hst endon("death");
		if((level.kratt_light_var ==1) && (level.player istouching(shoot_area1)))
		{
			
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else if((level.kratt_light_var ==2) && (level.player istouching(shoot_area2)))
		{
			
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else if((level.kratt_light_var ==3) && (level.player istouching(shoot_area3)))
		{
			
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else
		{
			level.kratt_hst stopallcmds();
			
		}
		wait(0.25);
	}
}
	


shoot_one()
{
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "You're dead!" , (0, 1, 1), 1, 0.4, 30);
}


shoot_two()
{
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "You think you can hide from me!" , (0, 1, 1), 1, 0.4, 30);
}


shoot_three()
{
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "Show yourself!" , (0, 1, 1), 1, 0.4, 30);
}

zone1_lights()
{
	zone1 = getentarray("kratt_light4", "targetname");
	for (i = 0; i < zone1.size; i++) 
	{
		level thread light_flicker_darkness( zone1[i] );
	}
}

zone1_lights_off()
{
	zone1 = getentarray("kratt_light4", "targetname");
	for (i = 0; i < zone1.size; i++) 
	{
		level thread lights_off( zone1[i] );
	}
}
light_flicker_darkness(light)
{
	x = randomfloatrange(0.01, 0.13);
	z = randomfloatrange(1.4, 2.3);
	while(1)
	{
		light setlightintensity (2);
		wait(x);
		
		light setlightintensity (0);
		wait(x);
	}
	wait(z);
}

light_flicker_darkness2(light)
{
	x = randomfloatrange(0.01, 0.13);
	z = randomfloatrange(10.4, 20.3);
	while(1)
	{
		light setlightintensity (2);
		wait(x);
		light setlightintensity (0);
		wait(x);
		light setlightintensity (2);
		wait(x);
		light setlightintensity (0);
		wait(x);
		light setlightintensity (2);
		wait(x);
		light setlightintensity (0);
		wait(x);
	}
	wait(z);
}

kratt_lights1_on()
{
	zone2 = getentarray("kratt_light1", "targetname");
	for (i = 0; i < zone2.size; i++) 
	{
		zone2[i] thread lights_on();
	}
}
kratt_lights1_off()
{
	zone2 = getentarray("kratt_light1", "targetname");
	for (i = 0; i < zone2.size; i++) 
	{
		zone2[i] thread lights_off();
	}
}

kratt_lights2_on()
{
	zone3 = getentarray("kratt_light2", "targetname");
	for (i = 0; i < zone3.size; i++) 
	{
		zone3[i] thread lights_on();
	}
}
kratt_lights2_off()
{
	zone3 = getentarray("kratt_light2", "targetname");
	for (i = 0; i < zone3.size; i++) 
	{
		zone3[i] thread lights_off();
	}
}

kratt_lights3_on()
{
	zone3 = getentarray("kratt_light3", "targetname");
	for (i = 0; i < zone3.size; i++) 
	{
		zone3[i] thread lights_on();
	}
}
kratt_lights3_off()
{
	zone3 = getentarray("kratt_light3", "targetname");
	for (i = 0; i < zone3.size; i++) 
	{
		zone3[i] thread lights_off();
	}
}
lights_on()
{
	self setlightintensity (3);
}

lights_off()
{
	self setlightintensity (0);
}




kratt_deck_run()
{
	level waittill("puzzle_done");
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}


darkness_shooters()
{
	door1 = getent("dark_door_ori1", "targetname");
	spawners = getentarray("darkness_wave1", "targetname");
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i] SetAlertStatemin("alert_red");
			guy[i] SetScriptSpeed("run");
			guy[i].targetname = "darkness_shooters";
			
			guy[i] waittill("goal");
			guy[i] cmdshootatentity(door1, false, 1, 0.45);
		}
		wait(2);
		level thread darkness_shooters2();
		
		level notify("darkness");
	}
}


darkness_shooters2()
{
	while(1)
	{
		if(level._ai_group["dark_wave1"].aicount <= 2)
		{
			x = randomfloatrange(5.4, 9.1);
			spawners = getentarray("darkness_wave2", "targetname");
			for (i = 0; i < spawners.size; i++)
			{
				guy[i]= spawners[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( guy[i]) )
				{
					guy[i] SetAlertStatemin("alert_red");
					guy[i] SetScriptSpeed("walk");
					guy[i].targetname = "darkness_shooters";
					
					
					
					
				}
			wait(x);
			}
			break;
		}
		wait(1);
	}
}



kratt_deck_del()
{
	vspr = getent("vesper_x", "targetname");
	krtt = getent("kratt_x", "targetname");
	if (isdefined ( vspr ))
	{
		vspr delete();
	}
	if (isdefined ( krtt ))
	{
		krtt delete();
	}
}








unreal_halfwayT()
{
	
}
















awareness_cameras()
{
	
	
	pipe_mousetrap = getent("cargo_damageT", "targetname");
	
}


global_vesper_screams01()
{
	global_vesper_scream01 = getent ( "global_vesper_scream01", "targetname" );
	global_vesper_scream01 waittill ( "trigger" );
	
  ori = getent("vesper_scream1", "targetname");
  ori playsound ("BRG_Vesper_scream1");
}


global_full_light_flicker()
{
	light_flicker = getentarray ( "flicker", "targetname" );
	for ( i = 0; i < light_flicker.size; i++  )
	{
		level thread global_light_flicker_think ( light_flicker[i] );
	}
}


global_light_flicker_think ( light )
{
	while (1)
	{
		light setlightintensity (0);
		wait( .05 + randomfloat( .3) );
		
		light setlightintensity (1.5);
		wait( .05 + randomfloat( .3) );
	}
	wait(.1);
}

global_small_light_flicker()
{
	light_flicker = getentarray ( "dyn_small_flicker", "targetname" );

	for ( i = 0; i < light_flicker.size; i++  )
	{
		level thread global_small_light_flicker_think ( light_flicker[i] );
	}
}

global_small_light_flicker_think ( light )
{
	wait(.1);
	while (1)
	{
		light setlightintensity (0);
		wait( .05 + randomfloat( .1) );
		
		light setlightintensity (2);
		wait( .05 + randomfloat( .1) );
	}
}

global_long_light_flicker()
{
	light_flicker = getentarray ( "dyn_long_flicker", "targetname" );

	for ( i = 0; i < light_flicker.size; i++  )
	{
		level thread global_long_light_flicker_think ( light_flicker[i] );
	}
}


global_long_light_flicker_think ( light )
{
	wait(.1);
	while (1)
	{
		light setlightintensity (0);
		wait( .05 + randomfloat( .1) );
		
		light setlightintensity (4);
		wait( .05 + randomfloat( .1) );
	}
}




barge_fog()
{
	fog_barge = getentarray ( "fog_barge01", "targetname" );
	fog	= LoadFx ( "weather/fogbank_small_duhoc" );
	
	for (i = 0; i < fog_barge.size; i++  )
	{
		fxid = playloopedfx ( fog, 2, fog_barge[i].origin );
	}
}

barge_moth()
{
	moth_fx = getentarray ( "moth_fx", "targetname" );
	moth	= LoadFx ( "maps/barge/barge_insect_moths01" );
	
	for (i = 0; i < moth_fx.size; i++  )
	{
		fxid = playloopedfx ( moth, 2, moth_fx[i].origin );
	}
}



global_smoke_from_exhaust_ports()
{
	smoke_exhaust = getentarray ( "stern_smoke_exhaust_01", "targetname" );
	fxsmoke	= LoadFx ( "smoke/thin_light_smoke_M" );
	
	for (i = 0; i < smoke_exhaust.size; i++  )
	{
		fxid = playloopedfx ( fxsmoke, 1, smoke_exhaust[i].origin, 0, smoke_exhaust[i].angles );	
	}
}






fans2()
{
	fans = getentarray("vent_fan2", "targetname");
	for (i = 0; i < fans.size; i++)
	{
		fans[i] thread spin_fan2();
	}
}


spin_fan2()
{
	rotation = AnglesToForward( self.angles );
	while ( 1 )
  {
    self rotateyaw( 360, 0.4 , 0.1, 0.13);
  	wait(0.4);
  }
}


fans()
{
	level thread fans2();
	fans = getentarray("vent_fan", "targetname");
	for (i = 0; i < fans.size; i++)
	{
		fans[i] thread spin_fan();
	}
}

spin_fan()
{
	level endon( "flag_in_spa_lobby" );
	
	rotation = AnglesToForward( self.angles );
	pitch = self.angles[0];
	yaw = self.angles[1];
	roll = self.angles[2];
	
	if ( yaw > -5 && yaw < 5 )                      
	{
			rotation = (  1,   0,   0);
	}
	
	else if ( yaw > 85 && yaw < 95  )
	{
		if ( int(roll) == 0 )
		{
			rotation = (  -1,   0,   0);
		}
		else if ( int(self.angles[2]) == 90 )
		{
			rotation = (  0,   1,   0);
		}
	}
	
	else if ( yaw > 175 && yaw < 185 )
	{
		rotation = ( -1,   0,   0);
	}
	
	else if ( yaw > 265 && yaw < 275 )
	{
		rotation = (  -1,  0,  0);
	}
	else
	{
/#
		print("Invalid angle: " + yaw );
#/
		return;
	}
	
		rotation = rotation * 500.0;
	while ( 1 )
  {
    self rotateVelocity( rotation, 10.0 );
  	wait(10.0);
  }
}


consistant_damage_util(dmg)
{
	while(1)
	{
		radiusdamage(self.origin, 60, 0.8, 0.79);
		wait(0.05);
	}
}




barge_vision_triggers()
{
		vision1 = getentarray("barge_vision1_trigger", "targetname");
		for (i = 0; i <vision1.size; i++)
		{
			vision1[i] thread vision1_set();
		}
}

barge_vision2_triggers()
{
	vision2 = getentarray("barge_vision2_trigger", "targetname");
		for (i = 0; i <vision2.size; i++)  
		{
			vision2[i] thread vision2_set();
		}
}

barge_vision2_triggersA()
{
	vision2A = getentarray("barge_vision2_triggerA", "targetname");
	for (i = 0; i <vision2A.size; i++)  
		{
			vision2A[i] thread vision2A_set();
		}
}
		
barge_vision3_triggers()
{
	vision3 = getentarray("barge_vision3_trigger", "targetname");
		for (i = 0; i <vision3.size; i++)
		{
			vision3[i] thread vision3_set();
		}
}

vision1_set()
{
	self waittill("trigger");
	
	VisionSetNaked( "barge_1", 3 );
	wait(0.5);
	barge_vision2_triggers();
}
vision2_set()
{
	self waittill("trigger");
	
	VisionSetNaked( "barge_2", 3 );
	wait(0.5);
	barge_vision_triggers();
}
vision2A_set()
{
	self waittill("trigger");
	
	VisionSetNaked( "barge_2", 3 );
	wait(0.5);
	barge_vision3_triggers();
}
vision3_set()
{
	self waittill("trigger");
	
	VisionSetNaked( "barge_3", 3 );
	wait(0.5);
	barge_vision2_triggersA();
}



display_chyron()
{
	wait(25);
	maps\_introscreen::introscreen_chyron(&"BARGE_INTRO_01", &"BARGE_INTRO_02", &"BARGE_INTRO_03");
}

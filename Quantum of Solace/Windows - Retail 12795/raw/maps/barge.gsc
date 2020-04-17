#include maps\_utility;
//#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\barge_util;
#using_animtree("generic_human");

//////////|||||||||||||||| The Barge Level ||||||||||||||||||||\\\\\\\
//______________This level comes after the Aston Martin crash.
//This level starts out with Bond in an IGC. He is in the back of a car and being drivin to the barge to be tortured.
//When Bond breaks free of his captors, he is pissed, driven by the screams of vesper he walks onto the barge.
//Once Bond makes it to the end room he will be ambushed and the tortured scene will begin.


//bbekian 
main()
{
	
	maps\_playerawareness::init();							
	maps\_securitycamera::init();	
	
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
			
	maps\_load::main();
	maps\barge_amb::main();     
	maps\barge_mus::main();
	maps\barge_fx::main();
	
	//qq button press
	//SetDVar("bg_qk_branching", 0);
	
	//ssao_set(0, 0);  
	setdvar("r_ssaoEnable", 0); //turning off SSAO
	
	//max dyn ent water float time
	SetSavedDVar("phys_maxFloatTime", 90000);

	//minimap
	precacheShader( "compass_map_barge" );
	setminimap( "compass_map_barge", 5704, 4656, -1336, -432 );



	//Postfx
	//setpostfxblendmaterial("passoutfx");
	
	
	
	//Cutscenes
	PrecacheCutScene("Barge_Intro");
	PrecacheCutScene("Barge_Intro_LoopEnd");
	//PrecacheCutScene("Brg_Bnd_Jmp_Dwn");
	//PrecacheCutScene("Barge_KV_TankExplosion");
	PrecacheCutScene("Barge_Kratt_Pull");
	PrecacheCutScene("Barge_Drop");
  //PrecacheCutScene("Brg_Bnd_Torture");


	//flags
	flag_init("super_tilt");
	flag_init("tilting");
	
	//Associated GSC files
	//level thread maps\barge_deck2::main();
	//level thread maps\barge_deck3::main();
	level thread maps\_distraction::distract_init();
	
	
	// ------------- PLAYER -------------
	level.player allowprone( false );
	maps\_phone::setup_phone();											//<<<<<<<<<<--------------------<PHONE SETUP>
	
	
 	setDVar( "cg_laserAiOn", 1 );       // default 0

	//precacheRumble("movebody_rumble");	
	//precacheRumble("damage_heavy");
	
	precacheitem("WA2000_Barge");
	PreCacheItem("FRWL_Barge");
	
	PreCacheItem("flash_grenade");
	PreCacheItem("w_t_grenade_flash");
	Precachemodel("w_t_pipe");
	
	precacheShellshock( "default" );
	precacheshellshock ("flashbang");
		

	//PrecacheCutScene("Bond_FloorFall");
	
	//move the cellphone in script.


	
	
	//skiptos
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
		//level thread maps\barge_deck3::main();
		//level notify("second_half");
		dyn_light = getent("spotlight_light", "targetname");
		dyn_light2 = getent("spotlight_light_two", "targetname");
		dyn_light setlightintensity(0);
		dyn_light2 setlightintensity(0);
	}
	else if (Getdvar( "skipto" ) == "sniper" )
	{
		ori2 = getent( "sniper_pos", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles));   //dont worry about the redundant names >.<
		level notify ("sniper_guard");
		level thread give_weapons2();
		level thread sniper_start();
		dyn_light = getent("spotlight_light", "targetname");
		dyn_light2 = getent("spotlight_light_two", "targetname");
		dyn_light setlightintensity(0);
		dyn_light2 setlightintensity(0);
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
		dyn_light = getent("spotlight_light", "targetname");
		dyn_light2 = getent("spotlight_light_two", "targetname");
		dyn_light setlightintensity(0);
		dyn_light2 setlightintensity(0);
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
		dyn_light = getent("spotlight_light", "targetname");
		dyn_light2 = getent("spotlight_light_two", "targetname");
		dyn_light setlightintensity(0);
		dyn_light2 setlightintensity(0);
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
		dyn_light = getent("spotlight_light", "targetname");
		dyn_light2 = getent("spotlight_light_two", "targetname");
		dyn_light setlightintensity(0);
		dyn_light2 setlightintensity(0);
	} 
	/*
	else if (Getdvar( "skipto" ) == "puzzle" )
	{
		ori2 = getent( "puzzle_origin_start", "targetname" );
		level.player setorigin( ori2.origin);
		roof_angles = ori2.angles;
		level.player setplayerangles((roof_angles));
		level notify ("sniper_guard");
		level notify( "trunk_open" );
	}
	*/
	else
	{
		
		level.player setorigin((2037.6, 3544 ,105));   //((1783, 1975, 140)); //old position near the window //
		level.player setplayerangles((-0, 298.4, 0));
		level.player allowStand(false);
		level.player allowcrouch(true);
		level thread car_trunk();
		//level.player setorigin( (3975.3, 2923.9,198) );
		//level.player setplayerangles( (-0, 245, 0) );
	}
	

	
	// ---------- PRECACHING -----------

	
	//bbekian (a vulaj set these up)
	//Functions Related to 	-->															----<<<Ambience>>>----
	

	//level thread barge_fog();
	
	//level thread barge_moth();
	level thread global_smoke_from_exhaust_ports();
	level thread global_full_light_flicker();
	level thread global_small_light_flicker();
	level thread global_long_light_flicker();
	
	

	// _______________VARIABLES________________


	level.deck_event = 0;
	level.puzzle_var = 0;
	level.roof_fog_var = 0;
	
	level.roof_fog_fxz_var = 0;
	level.roof_fog_fxy_var = 0;
	
	level.crane_var = 0;
	level.control_door = 0;
	level.bdrft_var = 0;
	
	//Puzzle Vars
	level.puzzle_var_real = 0;
	level.puzzle_var_real2 = 0;
	level.puzzle_var_real3 = 0;
	
	level.puzzle_var_meter = 0;
	level.puzzle_var_meter2 = 0;
	level.puzzle_var_meter3 = 0;
	
	level.puzzle_button_var = 0;
	
	
	//Sniper Vars
	level.sniper_event = 0;
	level.night_vision = 0;
	level.attach_toggle = 0;
	level.spotlight_var = 0;
	level.spotted_var = 0;
	level.vesper_grab = 0;
	level.window_reset = 0;
	
	level.sniper_event2 = 0;
	
	//kratt room
	level.kratt_light_var = 0;
	level.vesper_guidance_var = 0;
	level.spot_death_var = 0;
	level.kratt_fight_var= 0;
	level.ware_door_var = 0;
	
	level.spark_var = 0;
	level.ware_alert_var = 0;
	level.spot_death_var2 = 0;
	level.car_light_choke = 0;
	
	level.vesp_anim1 = false;

	level thread global_vesper_screams01();
	level thread global_checkpoint_before_big_fight();
	level thread global_fire_ext_triggers();
	//level thread swinglights();

	//bbekian
	//_________________________________________in cronological order
	
	level thread out_of_car_savegame_trigger();
	
	level thread hilltop_trigger();
	
	level thread barge_tank2();
	
	level thread barge_tank4();
	
	level thread exit_to_side();
	
	level thread side_to_roofT();
	
	level thread deck_fire_spawns();
	
	level thread checkpoint_deck01();
	
	//level thread enter_control_room();
	
	level thread cargo_enemies();
	
	//level thread ship_front_enemies();

	level thread stern_spawn_thug_five();

	//level thread b_room_ceilingT(); //smoke/fire damage trigger in the old control room
	
	level thread deck_fire_spawn_think();

	
	level thread top_of_stairsT();
	
	level thread canopy_al_checks();
	
	//level thread puzzle_one_trigger1();
	//level thread puzzle_one_trigger2();
	//level thread puzzle_one_trigger3();
	//level thread puzzle_one_trigger4();
	//level thread puzzle_one_trigger5();
	//level thread puzzle_one_trigger6();
	
	level thread deck_checkp1();
	
	level thread corridor_tanks();  
	
	level thread backdraft_ai_trigger();
	
	level thread e1_two_trigger();
	
	level thread awareness_cameras();
	
	level thread trap_door();
	
	level thread warehouse_save_pointT();
	
	level thread warehouse_drop_down();
	
	//level thread night_visionT();
	
	//level thread aksu_extended_clip();
	
	//level thread hit_the_lights();
	
	level thread bow_cargo_crashT();
	
	level thread stairs_runawayT();
	
	//level thread amb_miss_trigger1();  //the exploding lights from the sniper mission
	
	//level thread cargo_door_setup();
		
	level thread warehouse_transition_saveT();
	
	level thread barge_vision_triggers();
	level thread barge_vision2_triggersA();

	level thread magic_railing_hide();
	
	level thread ware_house_door_link();
	
	//awareness reverted items
	level thread deck_fire3();
	//level thread deck_fire4();
	level thread deck_fire();

	level thread birds_flying();
	level thread trap_door_use();
	level thread splash_trigger();

	level.obj6 = false;
	level thread pseudo_tank_explosion();
	//awareness items
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "out_deck_dmgT3", ::deck_fire3, true , maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialNone, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "out_deck_dmgT4", ::deck_fire4, true ,maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialNone, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "out_deck_dmgT", ::deck_fire, true , maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialNone, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "pipe_trigger", ::deck_pipe_trap, true , undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "corridor_pipeT", ::corridor_pipe, true, maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialNone, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "corridor_tanksT", ::corridor_tanks, true, undefined,level.awarenessMaterialMetal, 1, 0);	
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "barge_tank3_dmgT", ::barge_tank3_dmg_X, true, undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "barge_tank3_dmgT2", ::barge_tank3_dmg_X2, true, undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "barge_tank3_dmgT3", ::barge_tank3_dmg_X3, true, undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "barge_tank3_dmgT4", ::barge_tank3_dmg_X4, true, undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "crane_dmg1T", ::crane_dmg1T, true, maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialMetal, 1, 0);
	//Disabled the OG crane //level maps\_playerawareness::setupSingleUseOnlyNoWait( "crane_use1T", ::crane_dmg1T, "Crane Release", 1, "Emergency Release", undefined, undefined, undefined, level.awarenessMaterialMetal, 1, 0);
	//level maps\_playerawareness::setupSingleUseOnlyNoWait( "trap_door_useT", ::trap_door_use, "Cargo Door", 0, "Opening Cargo Door", undefined, undefined, undefined, level.awarenessMaterialNone, 1, 0);
	
	
	//level maps\_playerawareness::setupSingleUseOnly ( "deck_use1T", ::deck_use1T, "distraction", 1, "activated", 1, 0, undefined, 0, 0, 0);
	
	//level thread maps\_playerawareness::setupSingleUseOnly ( "cargo_dist1T", maps\barge_deck3::cargo_dist1, "distraction", 1, "activated", 1, 0, level.awarenessMaterialElectric, 0, 0, 0);
	//awareness_object  <---dont forget to add this parameter to any damage or use function passing through bond awareness
	if(!level.ps3 && !level.bx) //GEBE
	{
		setExpFog(0, 5000, 0.206, 0.241, 0.261, 0.01, 0.569);
	}

	  
	maps\_sea::main();
	level._sea_litebob_scale = 10;
		
	level thread give_weapons();
		
	//level thread pip_setup();

	//water fx
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");
	
	array_thread(GetEntArray("boats", "targetname"), ::boat_float );
	array_thread(GetEntArray("trailer_window_damageT", "targetname"), ::trailer_window );

	//light = getent("dock_light_flicker1", "targetname");
	//light delete();
}		


//++++++++++++++start
//savegame1
out_of_car_savegame_trigger()
{

//	trigger = getent("out_of_car_savegame_trigger", "targetname");
//	level waittill ("Barge_Intro_Done");
//	trigger waittill("trigger");
//	wait(1);
	//savegame("barge");  //savegame1
//	thread maps\_autosave::autosave_now("barge");
	//level thread global_autosave();
}


//black hud element used in conjunction with vision set barge_dark
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

//post fx that run over the opening cinematic
post_fx_over_intro()
{
	//level.player waittillmatch( "anim_notetrack", "_inside");
	level.car_light_choke = 0;
	wait(0.01);
	VisionSetNaked( "Barge_Awaken", 0.001 );
	wait(9.35);
	VisionSetNaked( "Barge_0", 0.01 );
	wait(6.65);
	VisionSetNaked( "Barge_Awaken2", 0.01 );
	wait(2.45);
	VisionSetNaked( "Barge_0", 0.01 );
	level thread car_lights_timer();
	level thread car_tail_light();
	//wait(8);
	level thread car_lights_stop();
	level.player waittillmatch( "anim_notetrack", "_end");
	VisionSetNaked( "Barge_dark", 0.75 );
	level thread opening_vo();
	wait(1.75);
	VisionSetNaked( "Barge_0", 2);
}

car_tail_light()
{
	tail_light = getent("car_tail_light", "targetname");
	tail_light setlightintensity(2);
	wait(1.5);
	tail_light setlightintensity(0);
	wait(0.2);
	tail_light setlightintensity(2);
	wait(0.05);
	tail_light setlightintensity(0);
	wait(0.075);
	tail_light setlightintensity(2);
	wait(0.5);
	tail_light setlightintensity(0);
	wait(0.5);
	tail_light setlightintensity(2);
	wait(1);
	tail_light setlightintensity(0);
}

//the timer for the car lights to actually turn off
car_lights_stop()
{
	wait(3.75);
	level.car_light_choke = 1;
}

//the timer for the intervals between flashing
car_lights_timer()
{
	while(level.car_light_choke == 0)
	{
		level thread car_lights();
		wait(level.x_car_light);
		z = randomfloatrange(0.1, 0.25);
		wait(z);
	}
}

//1951 3872 119
//2003 3897 118
//1931 3978.5 93

car_lights()
{
	if(level.car_light_choke == 0)
	{
		level.x_car_light = randomfloatrange(0.5, 1.75);
		tag = [];
		head_lights = getentarray("car_headlights_ori", "targetname");
		for(i = 0; i <head_lights.size; i++)
		{
			tag[i] = Spawn("script_model", head_lights[i].origin + (0, 0, 0));
			tag[i] SetModel("tag_origin");
			tag[i].angles = head_lights[i].angles;
			PlayFxOnTag(level._effect["headlight"], tag[i], "tag_origin");
			tag[i] thread tag_delete();
		}
	}
	else
	{
		//
	}
}

tag_delete()
{
	wait(level.x_car_light);
	if(level.car_light_choke == 0)
	{
		self delete();
	}
	else if(level.car_light_choke == 1)
	{
		if(isdefined(self))
		{
			self delete();
		}
	}
}



//sets up all cameras in the level
//runs the post fx
//sets up the first (stealth) area AI
//runs the thread for the warehouse guard and
//the guy typing
car_trunk()
{
	

	//set up camera names and place them in an array
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

	// Need to holster weapons at the very start of the level
	maps\_utility::holster_weapons();
	
	//VisionSetNaked( "Barge_Awaken", 0.1 );
	//play the cutscene with 
	wait(0.02);

	//set lod
	SetDVar("r_lodBias",-4000);
	//set close fog
	if(level.ps3 || level.bx)//GEBE
	{
		setExpFog(578, 549, 0.208, 0.225, 0.240, 0, 1);
		setculldist(2000);
	}


	playcutscene("Barge_Intro", "Barge_Intro_Done");
	level thread display_chyron();
	
	level thread post_fx_over_intro();
	letterbox_on(false, false);
	moth_ori = getent("sanford_moths_ori", "targetname");
	playloopedfx (level._effect["fxmoths"], 5 , moth_ori.origin);
	
	level.player playsound("BRG_intro");
	level waittill("Barge_Intro_Done");

	//reset lod
	SetDVar("r_lodBias",0);

	if(level.ps3 || level.bx ) //GEBE
	{
		setExpFog(578, 549, 0.208, 0.225, 0.240, 0, 1);
		setculldist(2500);
	}

	
	level thread hide_the_pip(); //this runs a black hud element
	
	ori1 = getent("out_of_car_ori", "targetname");
	ang = ori1.angles;
	level.player setplayerangles(ori1.angles);
	level.player setorigin(ori1.origin);
	
	playcutscene("Barge_Intro_LoopEnd", "Loop_end");

	wait(0.05);
	letterbox_off();
	door2 movex(-550, 0.1);
	
	//Start Stealthy Music - Added by crussom
	level notify("playmusicpackage_stealth");
	
	level.player playerSetForceCover(true, (0, 0, 0) );
	
	level thread trailer_trash();
	level thread trailer_crouch_trigger();
	

	level thread television_origin1();

// this is too late into the level to holster weapons, moved to the start
//	maps\_utility::holster_weapons();
	wait(0.05);
	
	//ori1 = getent("out_of_car_ori", "targetname");
	//ang = ori1.angles;
	//level.player setplayerangles(ori1.angles);
	//level.player setorigin(ori1.origin);
	 	
	//level.player playerSetForceCover(true, (0, 0, 0) );
	wait(0.15);	// make sure you're touching the ground after here
	level thread sniper_in_the_window();
	
	//level.player playerSetForceCover(true, (0, 0, 0) );
	
	obj_ori = getent("wareh_obj_ori", "targetname");
	objective_add(1, "active", &"BARGE_INVESTIGATE_WAREHOUSE", (obj_ori.origin), &"BARGE_INVESTIGATE_WAREHOUSE_INFO" );
	wait(0.1);
	hack_box1 = getent("cam_hack_box_one", "targetname");
	hack_box2 = getent("cam_hack_box_two", "targetname");

	//security cams
	cam1 thread maps\_securitycamera::camera_start(hack_box1, true, true, false);	
	cam2 thread maps\_securitycamera::camera_start(hack_box2, true, true, false);	
	
	//view cams
	cam_view1 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	cam_view2 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	cam_view3 thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);	
	
	//level.player playerSetForceCover(true, (0, 0, 0) );
	wait(0.2);
	
	feedbox = getent("feed_box_one","targetname");
	level thread maps\_securitycamera::camera_tap_start(feedbox, cam_views );
	//level thread ware_cam3_spot();
	level thread fence_audio_cam1();
	level thread fence_audio_cam2();
	setSavedDvar( "sf_compassmaplevel", "level1" );
	level thread fans();
	level thread trailer_shutter();
	//level.player playerSetForceCover(true, (0, 0, 0) );
	trigger = getent("car_trunkT", "targetname");
	wait(3);
	level.player playerSetForceCover(false,false);
	level.player allowStand(true);
	trigger delete();
	//wait(10);
	VisionSetNaked( "Barge_0", 20 );
	level thread warehouse_door_save();
	dynEnt_StopPhysics("train_car_barrels");
}

opening_vo()
{
	level.player play_dialogue("BOND_BargG_501A");
	level.player play_dialogue("TANN_BargG_502A", 1);
	
	wait(1.3);
	thread maps\_autosave::autosave_now("barge");
	
	level.player play_dialogue("BOND_BargG_503A");
	level.player play_dialogue("TANN_BargG_504A", 1);
	x = randomfloatrange(0.5, 2.5);
	wait(x);
	ori = getent("wareh_obj_ori", "targetname");
	ori playsound("BRG_foghorn");
}

/*
ware_cam3_spot()
{
	shack_door = getent("monster_door", "targetname");
	cam3 = getent("warehouse_cam3", "targetname");
	cam3 waittill("spotted");
	cam3 playsound("BRG_fence_hop");
	level notify("trailer_trash");
	shack_door rotateyaw(75, 1, 0.1, 0.8);
	shack_door connectpaths();
}
*/

trailer_window()
{
	if( !IsDefined( self ) )
	{
		return;
	}
	self waittill("damage");
	level notify("trailer_trash");
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

//the guys inside the trailer with the door closed
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
	level.ware_alert_var = 1; //the var that stores "trailer_trash"
	shack_door rotateyaw(75, 1, 0.1, 0.8); //the door opens when the player induces "trailer_trash"
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

//flashing tv light
television_origin1()
{
	//ori = getent("television_origin1", "targetname");
	//playloopedfx (level._effect["barge_electric_spark1"], ori.origin +(0, 0, 0));
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


//since bond waits for 
give_weapons()
{
	level thread global_unholster_count();
	level thread vtak_ammo_give();
	//level waittill("sniper_guard");
	//maps\_utility::unholster_weapons();
	
	//level.player GiveWeapon( "p99_s" );
	//level.player giveweapon( "FRWL_Barge" );

	//level.player GiveMaxAmmo ( "p99_s" );
	//level.player GiveMaxAmmo ( "FRWL_Barge" );

	
	//maps\_phone::setup_phone();
}

//this counts the ai at the start of the level
//and does not count the elite ai, which is intended.
global_unholster_count()
{
 	array_ai = getaiarray("axis");
	for (i = 0; i < array_ai.size; i++  )
	{
		array_ai[i] thread global_unholster();
  }
}

//if bond quick kills the trailer guys or
//the laptop guard, weapons become unholstered
global_unholster()
{
	self waittill("death");
	maps\_utility::unholster_weapons();
	vtak_ammo_give();
}

//unholsters bond if he stealths into the warehouse and picks up a weapon
//also maxes out ammo in case bond stealths all the way to the sniper guard 
//since he drops a sniper rifle.
vtak_ammo_give()
{
	while(1)
	{
	 	if(level.player HasWeapon( "WA2000_Barge" ))
	 	{
	 		level.player GiveMaxAmmo( "WA2000_Barge" );
	 		level.player SwitchToWeapon( "WA2000_Barge" );
	 		wait(0.1);
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	else if(level.player HasWeapon( "FRWL_Barge" ))
	 	{
	 		level.player SwitchToWeapon( "FRWL_Barge" );
	 		level.player GiveMaxAmmo( "FRWL_Barge" );
	 		wait(0.1);
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	else if(level.player HasWeapon( "1911" ))
	 	{
	 		level.player SwitchToWeapon( "1911" );
	 		level.player GiveMaxAmmo( "1911" );
	 		wait(0.1);
	 		maps\_utility::unholster_weapons();
	 		break;
	 	}
	 	wait(1.0);
	}
}

//just for skipto's
give_weapons2()
{
	
	maps\_utility::unholster_weapons();
	level.player GiveWeapon( "p99_s" );
	level.player GiveWeapon( "WA2000_Barge" );
	level.player giveweapon( "FRWL_Barge" );
	//level.player SwitchToWeapon( "WA2000_Barge" );

	level.player GiveMaxAmmo ( "p99_s" );
	level.player GiveMaxAmmo ( "FRWL_Barge" );
	level.player GiveMaxAmmo( "WA2000_Barge" );
	
	//maps\_phone::setup_phone();
}

//bbekian
//this trigger is responsible for the acetalyne tank explosion on the road
//where kratt takes vesper
//it runs the sniper_end function that handles the ending of the sniper event, and
//the beginning of the barge.
hilltop_trigger()
{
	//guy = getent("firstguard", "targetname");
	trigger = getent("hilltop_trigger", "targetname");
	trigger waittill("trigger");
	//Start Action Music - Added by crussom
	level notify("playmusicpackage_action");
	//savegame ("barge");
	level thread sniper_end();
	//VisionSetNaked( "barge", 0.1 );
	wait(2);
}


//bbekian	a
//command node functions
cnode_deck1()
{
 //test
	//iprintlnbold("command node");
}



///////////////////|||||||||||||||||||||||||||||||||||||||||Sniper Protect Vesper||||||||||||||||||||||||||||||||||||||||||||||||||||||||\\\\\\\\\\\\\\\\\\\\\
///////////////////||||||||||||||||||||||||||||||||||||||||Sniper Protect Vesper||||||||||||||||||||||||||||||||||||||||||||||||||||||||\\\\\\\\\\\\\\\\\\\\\
///////////////////|||||||||||||||||||||||||||||||||||||||Sniper Protect Vesper||||||||||||||||||||||||||||||||||||||||||||||||||||||||\\\\\\\\\\\\\\\\\\\\\



//spawns the enemy in the window and sets his alert state
//handles the alert states of the first two guards
//
sniper_in_the_window()
{
	//tanks_safety = getent("backdraft_tanksT", "targetname");
	//tanks_safety trigger_off();
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
	//guy1.dropweapon = false;
	//level.first_sniper.dropweapon = false;
	//guy SetPerfectSense(false);
	level.first_sniper SetAlertStatemax("alert_red");
	level.first_sniper setscriptspeed("walk"); 
	guy1 setgoalnode(node);
	guy1 unlockalertstate();
	guy1 waittill("goal");
	
	guy1 setgoalnode(node2);
	guy1 thread guy_on_keyboard();
	//Print3d( guy1.origin + ( 0,0,64 ), "Lets close this door." , (0, 1, 1), 1, 0.4, 30);
	door2 = getent("warehouse_door_1", "targetname");
	//door2 movex(-50, 10);
	trigger4 waittill("trigger");
	if(isalive(guy1))
	{
		guy1 thread guest_announce();
		//guy1 play_dialogue("WMR1_BargG_007A"); //Waiting to bring down our guest,  over.
		guy1 setalertstatemax("alert_red");
	}
	//level thread warehouse_door_move();
	trigger waittill("trigger");
	if(!isalive(guy1))
	{
		//trigger2 waittill("trigger");
		if(isalive(level.first_sniper))
		{
			level.first_sniper startpatrolroute("warehouse_one");
		}
		wait(1);
		level thread ware_door_close();
		//Print3d( level.first_sniper.origin + ( 0,0,64 ), "Yes, we have Bond" , (0, 1, 1), 1, 0.4, 30);
		level.first_sniper waittill("death");
		level notify("sniper_guard");
		//savegame("barge");
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
		//savegame("barge");
		thread maps\_autosave::autosave_now("barge");
	}
}

guest_announce()
{
	if((self getalertstate() != "alert_yellow" ) || (self getalertstate() != "alert_red" ))
	{
		if(!level.ware_alert_var == 1)
		{
			self play_dialogue("WMR1_BargG_007A"); //Waiting to bring down our guest,  over.
		}
	}
}

//storing the alert state if the player alterted guards outside
//in case of a restart, something our save game should do.
ware_guard_alert_state()
{
	trigger2 = getent("warehouse_beforeT2", "targetname");
	trigger2 waittill("trigger");
	if(level.ware_alert_var == 1)
	{
		if(isdefined(level.first_sniper))
		{
			level.first_sniper setalertstatemin("alert_red");
		}
	}
}

window_sniper_dcheck()
{
	level.first_sniper waittill("death");
	level notify("sniper_guard");
}

//handles the keyboard guy and his animation
//
guy_on_keyboard()
{
	self endon("death");

	node = getnode("warehouse_door_node2", "targetname");
	if(Distance(node.origin, self.origin) > 20)
	{
		self setgoalnode(node);
		self waittill("goal");
		rail = spawn("script_origin",level.player.origin);
		self linkto(rail);
	}
	self cmdfaceangles(270, 0);
	self waittill("cmd_done");
	self CmdAction( "TypeLaptop" );
	self thread keyboard_handle_alert();
}

//this checks for the keyboard guys' alert state
//and starts and stops the keyboard anim
//depending on what state he's in
//it used to start and stop the typing sound
//but its now notetracked to the anim
keyboard_handle_alert()
{
	self endon("death");

	while(1)
	{
		if( self getalertstate() == "alert_yellow" )
		{
			while(1)
			{
				if( self getalertstate() == "alert_red" )
				{
					self unlink();
					level notify("trailer_trash");
					return;
				}
				if( self getalertstate() == "alert_green" )
				{
					self thread guy_on_keyboard();
					return;
				}
				wait(.1);
			}
		}
		wait(.1);
	}
}

//play_laptop_sound()
//{
//	guy1 = getent("guy1", "targetname");
//	ori = getent("laptop_origin", "targetname");
//	//ori playloopsound("BRG_typing");
//	node = getnode("warehouse_door_node2", "targetname");
//	guy1 endon("death");
//	while(1)
//	{
//		if(isdefined(guy1))
//		{
//			if(guy1 getalertstate() == "alert_yellow" ) 
//			{
//				ori stoploopsound();
//				wait(3);
//				if(guy1 getalertstate() == "alert_green" )
//				{
//					guy1 setgoalnode(node);
//					guy1 waittill("goal");
//					guy1 cmdfaceangles(282, false, 2);
//					guy1 waittill("cmd_done");
//					guy1 CmdAction( "TypeLaptop" );
//					level thread play_laptop_sound();
//					break;
//				}
//				else
//				{
//					continue;
//				}
//	 		}
//	 		else if(guy1 getalertstate() == "alert_red" )
//	 		{
//	 			//ori stoploopsound();
//				level notify("trailer_trash");
//				break;
//			}
//	 		else if(!isdefined(guy1))
//	 		{
//	 			//ori stoploopsound();
//				break;
//			}
//		}
//		else
//		{
//			//ori stoploopsound();
//			break;
//		}
//	 	wait(0.5);
//	}
//}

warehouse_door_save()
{
	while(1)
	{
		if((level._ai_group["field_enemies"].aicount < 1) || (level.ware_door_var == 1))
		{
			thread maps\_autosave::autosave_by_name("barge");
			level thread ware_guard_alert_state();
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
		if(level.player istouching(trigger) && (z -133 > x)) //this timer syncs the door closing to the player remaning in the trigger
		{
			door2 = getent("warehouse_door_1", "targetname");
			brush = getent("warehouse_door_brush1", "targetname");
			brush movez(100, 0.133);
			door2 movex(-60, 2.5, 0.2, 1.8);
			level thread door_crack_ori();
			door2 playsound("BRG_warehouse_door_slide");
			level.ware_door_var = 1;
			objective_state(1, "done");
			level.player play_dialogue("TANN_BargG_702A", 1); //Vesper’s been grabbed.  Can you get down to the barge?  I can’t see where she’s headed.
			level thread update_objective_title();
			break;
		}
		wait(0.3);
	}
}

update_objective_title()
{
	//wait(3);
	obj_ori = getent("wareh_obj_ori", "targetname");
	objective_add(11, "current", &"BARGE_INVESTIGATE_WAREHOUSE_TWO" , (obj_ori.origin), &"BARGE_INVESTIGATE_WAREHOUSE_TWO_INFO" ); 
}


//dust
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
	
	
//the warehouse door movement
warehouse_door_move()
{
	door = getent("warehouse_door_1", "targetname");
	//trigger = getent("warehouse_door_trigger", "targetname");
	//trigger setHintString("Open the Warehouse Door");
	//trigger waittill("trigger");
	door movex(80, 10);
	//trigger delete();
}


//waiting for the second guard to die to send
//a notify to thread the function that turns on
//the sniper trigger
//its separate from the sniper_start function
sniper_trigger_on()
{
	level waittill("sniper_guard");
	wait(0.34); //this wait is here because immediately saving after a ai dies produces zombie gunfire on restart
	
	//savegame("barge");
	level thread sniper_start();
	
	//Start Sniper Music - Added by crussom
	level notify("playmusicpackage_sniper");
	
	level thread sniper_death_check();
	level thread spotlight_logic();
	
}

//the sniper dialouge from the cars in the warehouse 
//these are PT_ongoal function calls
first_sniper_talk()
{
	radio = getent("warehouse_radio_ori", "targetname");
	level.first_sniper pausepatrolroute();
	//Print3d( level.first_sniper.origin + ( 0,0,64 ), "What are you talking about, she escaped?" , (0, 1, 1), 1, 0.5, 30);

	//need to find a place other than the sniper to play the sound off of.
	level.first_sniper play_dialogue("BAM1_BargG_008A"); //Look out!  She’s getting away!
	//wait(3);
	if(isdefined(level.first_sniper))
	{
		level.first_sniper resumepatrolroute();
		level.first_sniper setscriptspeed("jog"); 
		level.first_sniper play_dialogue("BMR2_BargG_009A"); //On the deck!  Stop her!
	}
	//wait(3);
	radio play_dialogue("RAD1_BargG_010A"); //All personnel: we’ve lost the girl.  Report all sightings.
	//wait(4.3);
	radio play_dialogue("RAD2_BargG_011A"); //She’s heading for the deck.
	//wait(2.7);
	radio play_dialogue("RAD3_BargG_012A"); //This is Vlade.  The stern deck is empty
	//door = getent("warehouse_door_1", "targetname");
	//door movex(-57, 10, 5, 5);
}

//a pt ongoal call for dialouge
first_sniper_talk2()
{
	ori = getent("protect_vesper_obj_ori", "targetname");
	//level.first_sniper aimatpos(ori.origin);
	level.first_sniper cmdaimatentity(ori, true, -1);
	level.first_sniper play_dialogue("WMR2_BargG_013A"); //Barge, this is the Warehouse.  I see her on the port side, main deck.
	if(isdefined(level.first_sniper))
	{
		level.first_sniper setscriptspeed("run"); 
		level.first_sniper play_dialogue("WMR2_BargG_016A");
	}
	if(level.night_vision == 0)
	{
		//Print3d( level.first_sniper.origin + ( 0,0,64 ), "Where is the night vision? I can barely see her." , (0, 1, 1), 1, 0.6, 30);
	}
	else if(level.night_vision == 1)
	{
		//Print3d( level.first_sniper.origin + ( 0,0,64 ), "I have her in my sights." , (0, 1, 1), 1, 0.6, 30);
	}
}



//Sniper window control script intitialization window one
initialize_sniper_pos1()
{
	sniper_pos1();
}
//Sniper window control script intitialization window two
initialize_sniper_pos2()
{
	sniper_pos2();
}
//Sniper window control script intitialization window three
initialize_sniper_pos3()
{
	sniper_pos3();
}


vesper_stop1()
{
}



spot_man()
{
	//level.spot_man = getent("spotlight_man", "targetname")  stalingradspawn( "spot_man" );
	//level.spot_man.tetherradius = 5; 
	//level.spot_man SetAlertStatemax("alert_green");
	//level.spot_man setengagerule("never");
	//level.spot_man waittill("death");
	//level.spotlight_var =77;
}

spotlight_damage_trigger()
{
	spotlight = getent("spotlight_one", "targetname");
	spotlight_dmg = getent("spotlight_one_dmg", "targetname");
	

	
	ori1 = getent("spotlight1_ori1", "targetname");
	ori2 = getent("spotlight1_ori2", "targetname");
	trigger = getent("spl_dmg_trg", "targetname");
	dynEnt_StopPhysics("fence_cage_1_dyn_brushes");
	
	trigger waittill("trigger");

	playfx (level._effect["fxsmoke"], spotlight.origin +(0, 0, 0));
	//iprintlnbold("spotlight_dead");
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
	//trigger waittill("trigger");
	level notify("spotlight_dead");
	playfx (level._effect["fxpumpgen"], spotlight.origin +(0, 0, 0));
	dynEnt_StartPhysics("fence_cage_1_dyn_brushes");
	array = getentarray("fence_cage_apparatus", "targetname");
	if(isdefined(level.spot_man))
	{
		level.spot_man dodamage(1000, (0,0,5));
	}
	for (i = 0; i < array.size; i++)
	{
		array[i] delete(); 
	}
	physicsExplosionSphere( ori1.origin, 350, 10, 2 );
	ori1 radiusdamage(ori1.origin, 80,500,400);
	ori2 radiusdamage(ori2.origin, 80,500,400);
	level.spotlight_var =77;
	level.spotlight_tag delete();
	level.spot_death_var = 1;
	spotlight hide();
	dyn_light = getent("spotlight_light", "targetname");
	dyn_light setlightintensity(0);
	spotlight_dmg show();
	level notify("fx_spotlight_spark1"); //CG - trigger the sparking effects 
	//if( trigger.triggeredDamage )
	//{
		//if( trigger.damageAttacker = !level.player )
		//	retval = false;
	//}
}

		
spotlight_logic()
{
	
	dyn_light = getent("spotlight_light", "targetname");
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
	//spotlight_arm linkto(spotlight);
	level.spotlight_tag = Spawn("script_model", spotlight.origin + (0, 0, 0));
	level.spotlight_tag SetModel("tag_origin");
	level.spotlight_tag.angles = spotlight.angles;
	level.spotlight_tag LinkTo(spotlight);
	PlayFxOnTag(level._effect["barge_spotlight"], level.spotlight_tag, "tag_origin");
	dyn_light linkLightToEntity(light_origin);
	dyn_light.origin = (0,0,0);
	dyn_light.angles = (0,0,0);
	if(!level.ps3 && !level.bx) //GEBE
	{
		dyn_light setlightintensity (4);
	}
	level thread spot_man();
	level thread spotlight_damage_trigger();
	if(!level.ps3 && !level.bx) //GEBE
	{
		level thread spotlight2_damage_trigger();
	}
	
	level thread spotlight_random_search();
	spotlight thread spotlight_trace();
	z = randomintrange(1,2);
	while(level.sniper_event == 0)
	{
		if(level.spotlight_var == 1)
		{
			//iprintlnbold("I see you in window one!");
			win = spotlight.origin - window_1.origin;
			winx = window_1.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin rotateto(VectorToAngles(winx)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if(level.spotlight_var == 2)
		{
			//iprintlnbold("I see you in window two!");
			win2 = spotlight.origin - window_2.origin;
			winx2 = window_2.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win2)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin rotateto(VectorToAngles(winx2)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if(level.spotlight_var == 3)
		{
			//iprintlnbold("I see you in window three");
			win3 = spotlight.origin - window_3.origin;
			winx3 = window_3.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win3)+(0,-90, 0), 1, 0.5, 0.1);	// Need to add -90 yaw because the forward vector of the spotlight model is pointing out the side
			light_origin rotateto(VectorToAngles(winx3)+( 0 , 0, 0), 1, 0.5, 0.1);	 
			spotlight waittill("rotatedone");
			wait(z);
		}
		else if((level.spotlight_var == 0) && (level.spotted_var == 9))
		{
			//iprintlnbold("where is he?");
			//win4 = spotlight.origin - idle_ori.origin;
			//winx4 = idle_ori.origin - light_origin.origin;
			//spotlight rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			//light_origin rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			//spotlight waittill("rotatedone");
			
			level thread spotlight_random_search();
			level waittill("random_search_done");
			//wait(z);
		}
		else if(level.spotlight_var == 77)
		{
			win4 = spotlight.origin - idle_ori.origin;
			winx4 = idle_ori.origin - light_origin.origin;
			spotlight rotateto(VectorToAngles(win4)+(0,-90, 0), 1, 0.5, 0.1);
			light_origin rotateto(VectorToAngles(winx4)+( 0 , 0, 0), 1, 0.5, 0.1);	
			spotlight waittill("rotatedone");
			//wait(5);
			//spotlight_tag delete();
			dyn_light setlightintensity (0);
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
		//light_origin rotateto(VectorToAngles(winx3)+( 0 ,90, 0), 2, 1, 1);	 // Need to add 90 yaw because the light is relative
		level notify("random_search_done");
}


//bbekian
//this checks to see if the player is in the first window 
//It then checks to see if you have fired a shot, then takes all of the top deck shooters and aims at the player
//this also checks to see if you changed windows and stops the shooters from shooting at the player
//if you return to the initial window, it also stops AI from shooting at the player until he fires a shot
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
				s = randomfloatrange(1, 400);
				x = randomintrange(1, 3);
				for (i = 0; i < guys.size; i++)
				{
					//guys[i] cmdaimatentity( window_1, false, x); 	//trying this, may not suit the event
					//guys[i] waittill("cmd_done");									//trying this, may not suit the event
					
					guys[i] aimatpos(window_1.origin);
					wait(0.5);
					//guys[i] cmdshootatentity(level.player, false, 2.1 , 1);  //this controls the time and accuracy for the ai shooting at the origin 
					guys[i] cmdshootatentityxtimes(level.player, false, x , 0.45);
				}
				wait(z);//wait(0.7);
			} 
		}
		else if(((level.player istouching(pos2)) || (level.player istouching(pos3))) && (level.spotlight_var == 1))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{	
				//guys[i] stopallcmds();
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_1, true, 5 );
				guys[i] thread shooters_disable_sense();
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
				//guys[i] stopcmd();
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_1, true, 5 );
				guys[i] thread shooters_disable_sense();
				level.spotted_var = 9;
				level.spotlight_var = 0;
				//wait(3);
			}
		}
		wait(0.075);
	}
}

done_shooting()
{
	self waittill("cmd_done");
}

//the second sniper window, has slightly different accuracy value for the ai
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
					//guys[i] cmdshootatentity(level.player, false, 2.1 , 1);  //this controls the time and accuracy for the ai shooting at the origin of the window
					guys[i] cmdshootatentityxtimes(level.player, false, x , 0.45);
					//guys[i] aimatpos(window_2.origin);
				}
				wait(z);
			}
		}
		else if(((level.player istouching(pos3)) || (level.player istouching(pos1))) && (level.spotlight_var == 2))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{
				//guys[i] stopallcmds();
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_2, true, 5 );
				guys[i] thread shooters_disable_sense();
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
				//guys[i] stopcmd();
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_2, true, 5 );
				guys[i] thread shooters_disable_sense();
				level.spotted_var = 9;
				level.spotlight_var = 0;
				//wait(3);
			}
		}
		wait(0.075);
	}
}

//the third sniper window, has slightly different accuracy value for the ai (well, it used to!)
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
					//guys[i] cmdshootatentity(level.player, false, 2.1 , 1);  //this controls the time and accuracy for the ai shooting at the origin of the window
					guys[i] cmdshootatentityxtimes(level.player, false, x , 0.45);
					//guys[i] aimatpos(window_3.origin);
				}
				wait(z);
			}
		}
		else if(((level.player istouching(pos2)) || (level.player istouching(pos1))) && (level.spotlight_var == 3))
		{
			guys = getentarray("sniper_shooters", "targetname");
			for (i = 0; i < guys.size; i++)
			{
				//guys[i] stopallcmds();
				guys[i] stopcmd();
				guys[i] setalertstatemin("alert_yellow");	
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_3, true, 5 );
				guys[i] thread shooters_disable_sense();
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
				//guys[i] stopcmd();
				guys[i] setignorethreat(level.player, true);
				guys[i] CmdAimatEntity( window_3, true, 5 );
				guys[i] thread shooters_disable_sense();
				level.spotted_var = 9;
				level.spotlight_var = 0;
				//wait(3);
			}
		}
		wait(0.075);
	}
}

//this is a timer for the window that can be used to change up the dialouge
//also this can be used to possibly run a vision set to maybe emulate a lens flare if the player
//looks at the spotlight for too long of a time
//what its currently used for are the bullet hits in the warehouse wall.
window_timer()
{
	dyn_light = getent("spotlight_light", "targetname");
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
					level thread bond_wont_move();
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
	//fx_point	= start_ent.origin;
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-35.0,35.0);
		z = randomfloatrange(-28.0, 28.0);
		// where the magic bullet will fire from 
		//	(NOTE: It's the opposite of where it should have come from)
		firepos = start_ent.origin + ( (i*1.0)+x+3, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("WA2000_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	// move it out from the wall 1
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		//fx_spawn thread impact_bullet_sound();
		level.window_reset = 0;	
		//wait( 0.1 );
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}

bullet_wall_two()
{
	start_ent	= GetEnt( "bullet_wall_two", "targetname" );
	//fx_point	= start_ent.origin;
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-35.0,35.0);
		z = randomfloatrange(-28.0, 28.0);
		// where the magic bullet will fire from 
		//	(NOTE: It's the opposite of where it should have come from)
		firepos = start_ent.origin + ( (i*1.0)+x+1, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("WA2000_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	// move it out from the wall 1
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		//fx_spawn thread impact_bullet_sound();
		level.window_reset = 0;	
		//wait( 0.1 );
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}

bullet_wall_three()
{
	start_ent	= GetEnt( "bullet_wall_three", "targetname" );
	//fx_point	= start_ent.origin;
	r = randomintrange(2,7);
	for ( i=0; i<r; i++ )
	{
		x = randomfloatrange(-25.0,25.0);
		z = randomfloatrange(-28.0, 28.0);
		// where the magic bullet will fire from 
		//	(NOTE: It's the opposite of where it should have come from)
		firepos = start_ent.origin + ( (i*1.0)+x+3, 0, 40-(i*z) );
		hitpos = firepos + ( 0, -3, 0);
		magicbullet("WA2000_Barge", firepos, hitpos);

		fx_spawn = Spawn( "script_model", hitpos+(0,4,0) );	// move it out from the wall 1
		fx_spawn SetModel( "tag_origin" );
		fx_spawn.angles = start_ent.angles+( randomfloatrange(-5.0, 5.0), 0,0);
		fx = playfxontag( level._effect["casino_vent_bullet_vol"], fx_spawn, "tag_origin" );
		//fx_spawn thread impact_bullet_sound();
		level.window_reset = 0;	
		//wait( 0.1 );
		y = randomfloatrange(0.1, 3.3);
		wait(y);
	}
}

//this starts the sniper event when the player enters the trigger below
sniper_start()
{
	trigger = getent("secret_sniper", "targetname");
	trigger trigger_on();
	trigger waittill("trigger");
	objective_state(11, "done");
	obj_ori = getent("protect_vesper_obj_ori", "targetname");
	//wait(2);
	level.timer1 = gettime();
	//level notify("sniper_start");
	if(!level.ps3 && !level.bx) //GEBE
	{
		setExpFog(0, 2373.57, 0.138957, 0.136401,  0.138066, 2, 0.912103); //mannys old settings
	}

	
	//SetExpFog(“fog near plane”, “fog half plane”, “fog red”, “fog green”, “fog blue”, “Lerp time”, “Fog max”);
	level thread sniper_vesper_spawn();
}



//the Sniper vesper is spawned and all her attributes are set
sniper_vesper_spawn()
{
	radio_ori = getent("warehouse_radio_ori", "targetname");
	level.sniper_vesper = getent("secret_vesper", "targetname")  stalingradspawn( "Svesper" );
	level.sniper_vesper.health = 55150;  //this much health doesnt appear to be counteracting a sniper bullet (because civilians always fail)
	level.sniper_vesper SetAlertStatemax("alert_green");
	level.sniper_vesper setengagerule("never");
	level.sniper_vesper maps\_utility::gun_remove();
	level.sniper_vesper play_dialogue("VESP_BargG_051A"); //Help!  James!
	level.player play_dialogue("TANN_BargG_801A", 1); //Bond, can you see the barge?!  We have multiple targets converging on Vesper.
	level.sniper_vesper stopcmd();
	level.sniper_vesper setengagerule("never");
	level.sniper_vesper allowedstances("stand");
	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper setFlashBangPainEnable( false );
	level thread sniper_cam();
	level thread sniper_vesper_hide();
	level thread tank_assist_one();
	level thread pause_bread_trig();
	vesper = getent("Svesper", "targetname");
	objective_add(2, "current", &"BARGE_PROTECT_VESPER" , (vesper.origin), &"BARGE_PROTECT_VESPER_INFO" ); //Protect Vesper
	doors = getent("sniper_wam_door2", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	brush connectpaths();
	wait(3.4);
	
	//radio_ori play_dialogue("BOND_BargG_505A");  //Tanner!  I need eyes on the barge!  I have multiple targets converging on Vesper.  Let me know where they’re coming from.
}

pause_bread_trig()
{
	trigger = getent("sniper_bread_trigger", "script_noteworthy");
	level waittill("kratt_takes_away");
	trigger notify("trigger");
}

tank_assist_one()
{
	tank_parent = getent("snp_tank_assist1", "script_noteworthy");
	tank_child = getent("snp_tank_assist1a", "script_noteworthy");
	tank_parent waittill("damage");
	if(isdefined(tank_child))
	{
		tank_child dodamage(500, (0,0,5));
	}
}

//An in game camera leaves the bond position and shows vesper
//initially was a camera pan, then turned into a pip with the timed
//element, now its disabled completley
sniper_cam()
{
	wait(3);
	//SetDVar("r_pipSecondaryMode", 0);
}


// ============= Vesper_VesprDrag, Vesper_WalkFast, Vesper_ShinKick, Vesper_BargeFlee, Vesper_StandCover
// ============= Thug_VesperDrag, Thug_ShinKick, 

//this opens the door and removes the brushmodel, since
//the door is a script model
//it sends a guy out of the door
vesper_doors1()
{
	doors = getent("sniper_wam_door1", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(3000, 0.1);
	doors rotateyaw(90, 3, 1.2, 0.9);
	brush connectpaths();
	wait(0.2);
	guy = getent("vesper_wave3_enemy0", "targetname");
	if(isdefined(guy))
	{
		guy play_dialogue_nowait("BRG_barge_door_thug"); 
	}
	/*
	guy = getent ("door1_guy", "targetname")  stalingradspawn("guy");
	guy thread door_etiquette();
	level waittill("wave_clear");
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
	*/
}

//this handles the guys coming out of the door waving
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

//closes door one
//it used to place the brushmodel back for the door
//but vesper would run into many more problems with
//getting stuck inside geo
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
	wait(0.2);
	guy = getent("vesper_wave2_enemy0", "targetname");
	if(isdefined(guy))
	{
		guy play_dialogue_nowait("BRG_barge_door_thug"); 
	}
	//guy = getent ("door2_guy", "targetname")  stalingradspawn("guy");
	//guy thread door_etiquette();
	level waittill("wave_sigma_clear");
	//if(isdefined(guy))
	{
		//node = getnode("door_wave_node", "targetname");
		//guy stopallcmds();
		//guy setalertstatemin("alert_green");
		//guy setscriptspeed("run");
		//guy.targetname = ("sniper_global_shooters3");
		//guy setgoalnode(node);
	}
	//guy waittill("goal");
	//if(isdefined(guy))
	{
	//	guy delete();
	}
}
vesper_doors2_close()
{
	doors = getent("sniper_wam_door2", "targetname");
	brush = getent(doors.target, "targetname");
	//brush movex(100, 0.1);
	doors rotateyaw(-90, 4, 1.3, 1.1);
	//brush connectpaths();
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
	wait(0.2);
	guy = getent("vesper_wave4_enemy0", "targetname");
	if(isdefined(guy))
	{
		guy play_dialogue_nowait("BRG_barge_door_thug"); 
	}
}
vesper_doors4_close()
{
	doors = getent("sniper_wam_door3", "targetname");
	brush = getent(doors.target, "targetname");
	brush movez(-3000, 0.1);
	doors rotateyaw(-120, 1, 1);
	//brush connectpaths();
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
		//guy.targetname = ("sniper_global_shooters3");
		guy setgoalnode(node);
	}
	guy waittill("goal");
	if(isdefined(guy))
	{
		guy delete();
	}
}




//this function controls all of the hiding spots that vesper goes to and runs the stop threads
//runs animations, waits for waves cleared
//sets script speeds
//
sniper_vesper_hide()
{
	level.hidenode = getnode("vesper_stop1", "targetname");
	level.sniper_vesper setgoalnode(level.hidenode); //send her to the first node

	level.sniper_vesper SetScriptSpeed("run");
	level.sniper_vesper waittill("goal");
	level.sniper_vesper cmdfaceangles(90, false, 1); //make her face angles for the "grab" anim
	level.sniper_vesper waittill("cmd_done"); //make sure the angles are faced
	
	level thread vesper_stop(); //run the first pursuants
	level thread vesper_stop_anim(); //run her pseudo idle
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_clear"); //wave 1 clear!
	
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.hidenode_sigma = getnode(level.hidenode.target, "targetname"); 
	level.sniper_vesper setgoalnode(level.hidenode_sigma);  //send her to the second node
	level.sniper_vesper waittill("goal");
	wait(0.5); //a wait because without it the system was overwhelmed
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.sniper_vesper cmdfaceangles(90, false, 1);
	level.sniper_vesper waittill("cmd_done"); //make sure the angles are faced
	
	level thread vesper_stop_sigma(); //run the first pursuants
	level thread vesper_stop_anim();  //run her pseudo idle
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_sigma_clear"); //wave 2 clear!
	
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.sniper_vesper SetScriptSpeed("run");

	level.hidenode_zeta = getnode(level.hidenode_sigma.target, "targetname");
	level.sniper_vesper setgoalnode(level.hidenode_zeta);
	clip = getent("vesper_save_clip", "targetname"); 		//since autosave by name will never save at this crucial moment
	clip movez(512, 0.1);  //and instead of using magic bullet shield
	level thread guard_dialogue();											
	level.sniper_vesper waittill("goal");
	wait(0.5);
	clip delete(); 	//lets prevent anyone from shooting her for these few seconds.
						
	level.sniper_vesper stopallcmds(); 
	wait(0.1);
	level.sniper_vesper cmdfaceangles(90, false, 1);														
	level.sniper_vesper waittill("cmd_done"); //make sure the angles are faced
	wait(0.05); //a wait because without it the system was overwhelmed
	level thread vesper_stop_zeta();	
	wait(0.05); //a wait because without it the system was overwhelmed
	if(!level.ps3 && !level.bx) //GEBE
	{
		level thread spotlight_que();
	}
	wait(0.05); //a wait because without it the system was overwhelmed
	level thread vesper_stop_anim();
	wait(0.05);
	level.sniper_vesper SetScriptSpeed("run");
	
	level waittill("wave_sigma_zeta"); //wave 3 clear!  
	level.sniper_vesper stopallcmds();
	wait(0.1);
	level.hidenode_omega = getnode(level.hidenode_zeta.target, "targetname");
	level.sniper_vesper setgoalnode(level.hidenode_omega);
	level.sniper_vesper waittill("goal");
	level.sniper_vesper stopallcmds(); 
	wait(0.1);
	level thread vesper_stop_omega();
	wait(0.1);
	level.sniper_vesper cmdfaceangles(90, false, 1);
	level.sniper_vesper waittill("cmd_done");
	level thread vesper_stop_anim();
	level.sniper_vesper SetScriptSpeed("run");
	level waittill("wave_omega_clear");
	level.sniper_vesper stopallcmds();
	wait(0.1);
	
	//
	level.sniper_vesper setgoalnode(level.hidenode_omega);
	level.sniper_vesper waittill("goal");
	
	level.hidenode_end = getnode("vesper_escape_end", "targetname");
	//moved vespers last node and 
	level.sniper_vesper setgoalnode(level.hidenode_end);
	level.sniper_vesper waittill("goal");
	level thread vesper_stop_anim();
	level thread vesper_stop_final();
	level waittill("vesper_last_guy");
	level thread vesper_kratt_away();
	level waittill("kratt_takes_away");
	
	//this runs the next objective (clear all the shooters) 
	level thread sniper_shooters_dead();
	wait(1);
	level thread sniper_death_check();
	level notify ("vesper_ready_end");
	level thread sniper_death_check();
	wait(1);
	level waittill("sniper_shooters_dead");
	
	//opens the door that locks the player in the warehouse
	door = getent("warehouse_door", "targetname");
	brush2 = getent("warehouse_door_brush2", "targetname");
	door rotateyaw(90, 1);
	brush2 movez(200, 0.1);
	brush2 connectpaths();
	brush2 delete();
	
	level thread sniper_vesper_point();  //this closes out the objective
	level waittill("vesper_point_over");
	level.timer2 = gettime();
	level thread achievement_logic();
	
	
	//iprintlnbold("vesper waits for bond");
	//objective_add(10, "current", "Meet Vesper on the Dock.");
}

guard_dialogue()
{
	radio_ori = getent("warehouse_radio_ori", "targetname");
	radio_ori play_dialogue("RAD1_BargG_015A");  //She’s heading for the gangway.  All personnel: we need her alive.  Do not harm.		
}

achievement_logic()
{
	wait(0.1);
	if(level.timer1 -120000 < level.timer2) //2 minutes
	{
		GiveAchievement("Challenge_Barge");
	}
}

			
//sniper objective end 
//sniper event variable set
//post sniper music 
sniper_vesper_point()
{
	wait(0.5);

	level notify("vesper_point_over");

	objective_state(2, "done");  //checked
	level.sniper_event = 1;
	
	//wait(2);
	
	obj_ori = getent("docks_origin", "targetname");
	objective_add(4, "active", &"BARGE_GET_ON_BARGE", (obj_ori.origin), &"BARGE_GET_ON_BARGE_INFO" );
}

	
//when vesper stops her persuants spawn and run towards her
vesper_stop()
{
	//level.sniper_vesper allowedstances("crouch");
	spawners = getentarray("vesper_enemy_wave1", "script_noteworthy");
	nodes1 = getnodearray("snp_nodes_array1", "targetname");
	level.vesper_stp1_oria = level.sniper_vesper.origin;
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

//remember to place tactical walk
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

go_to_node_array1a() //this is the node at hiding spot one inside the trigger volume that vesper sits in
{
	intensity[0] = "jog";
  intensity[1] = "jog";
  self endon("death");
	nodes = getnodearray("vesper_enemy1_nodes", "targetname");
	node = getnode("vesper_enemy1_node1", "script_noteworthy");
	node2 = getnode("vesper_enemy1_node2", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(2)]);
	self cmdshootatentity(level.player, false, 3, 0.1);
	if(!level.vesper_guidance_var == 0)  															//before checking if vesper was moved, making sure that the second guy is the only one who runs this since the orib is valid after the first anim
	{
		if(level.vesp_anim1 == true) 																		//making sure the anim played so that level.vesper_stp1_orib would have applicable origin values associated with it
		{
			if(level.vesper_stp1_orib[0] <  level.vesper_stp1_oria[0]) 		//need to check to see if vepser was moved (in -X) during the animation
			{
				self setgoalnode(node2, 1); 																//if vesper moved -X due to the anim moving her, the second guy is told to go to a node that is placed 8 units -X
			}
			else
			{
				self setgoalnode(node, 1);
			}
		}
		else
		{
			self setgoalnode(node, 1);
		}
	}
	else
	{
		self setgoalnode(node, 1);
	}
	self waittill("goal");
	//self waittill("facing_node");
	self thread shooters_disable_sense(); //threading them into a disable sense function
	self cmdfaceangles(90, false, 1);
	self waittill("cmd_done");
	//wait(0.1);
	level notify("thug_set1_ready");
	self.tetherradius = 60;
}	

//ambient shooters on the upper deck spwan to provide intensity 
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
		//level waittill("amb1_death");
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
		//guy[i] waittill("death");
	}
}

amb1_death_check()
{
	self waittill("death");
	level notify("amb1_death");
}

//When vespers persuants are near her they stop, grab her and attempt to take her back into the barge.
vesper_grab(guy)
{
	trig = getent("vesper_stop1T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	level waittill("thug_set1_ready");
	while(1)
	{
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim(guy);	
			level.vesper_grab = 1;
			level thread vesper_fail_chatter1();
			//level waittill("thug_anim_done");
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(9);
			guy thread fail_shield();
			wait(1);
			if(isalive(guy))
			{
				level thread vesper_caught_chatter();
				missionfailedwrapper();
			}
			break;
		}
		wait(1);
	}
} 

//this unlinks vesper and sends her back to the hiding spot if 
//a guy grabbed her and died in transit to the door:: not used anymore
grab_end()
{
	//wait(level.x1);
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

//a hack in case vesper is stuck inside the door.
vesper_stuck_oneT()
{
	stuck1 = getent("vesper_stuck_oneT", "targetname");
	if(level.sniper_vesper istouching(stuck1))
	{
		//iprintlnbold("teleporting vepser");
		level.sniper_vesper teleport((1198, 882, -30), (0, 45, 0));
		//level.sniper_vesper stopcmd();
	}
	//level notify("unstuck_one");
}

//this is vespers second hiding spot/stop. the last stop of groups of 2's
//zeta is the beginning of 3's
vesper_stop_sigma()
{
	spawners = getentarray("vesper_enemy_wave2", "script_noteworthy");
	nodes1 = getnodearray("snp_nodes_array1a", "targetname"); //array1a
	nodes2 = getnodearray("vesper_enemy2_nodes", "targetname");
	level thread vesper_doors2();
	for (i = 0; i < spawners.size; i++)
	{
		guy[i]= spawners[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( guy[i]) )
		{
			guy[i].targetname = "vesper_wave2_enemy" + i;
			guy[i] SetAlertStatemax("alert_yellow");
			guy[i] thread go_to_node_array2(guy[i], nodes1[i], nodes2[i]);
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

//runs the ai 
go_to_node_array2(guy, nodes1, nodes2)
{
	z = randomintrange(2,5);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes1, 1);
	guy thread shooters_disable_sense();
	guy SetScriptSpeed(intensity [randomint(2)]);
	guy waittill("goal");
	//guy cmdaction("CheckEarpiece");
	if(isdefined(guy))
	{
		//guy cmdaction("Fidget");
	}
	wait(z);
	if(isalive(guy))
	{
		guy endon("death");
		guy stopallcmds();
		guy cmdshootatentity(level.player, false, z, 0.1);
		guy waittill("cmd_done");
		guy stopallcmds();
		guy thread go_to_node_array2a(nodes2);
		level thread vesper_ambient_chatter();
	}
}

go_to_node_array2a(nodes2)
{
	intensity[0] = "jog";
  intensity[1] = "jog";
  self endon("death");
	//node = getnode("vesper_enemy2_node", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(2)]);
	self setgoalnode(nodes2, 1);
	self waittill("goal");
	self thread shooters_disable_sense(); //threading them into a disable sense function
	self cmdfaceangles(90, false, 1);
	self waittill("cmd_done");
	//wait(0.1);
	level notify("thug_set2_ready");
	self.tetherradius = 60;
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
					//guy[i].script_noteworthy = "sniper_global_shooters";
				}
				level waittill("amb2_death");
				//wait(z); //the random amount of time for enemy spawns
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
	trig = getent("vesper_stop2T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	level waittill("thug_set2_ready");
	while(1)
	{
		x = randomintrange(1,3);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			
			guy thread thug_grab_anim();
			level thread vesper_grab_anim(guy);
			level thread vesper_fail_chatter1();
			level.vesper_grab = 1;
			//wait(x);	
			guy cmdshootatentity(level.player, false, 3, 0.1);
			
			wait(8.5);
			level thread vesper_caught_chatter();
			guy thread fail_shield();
			wait(0.5);
			if(isalive(guy))
			{
				level thread vesper_caught_chatter();
				missionfailedwrapper();	
			}
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

//savegame2
vesper_stop_zeta()
{
	//savegame("barge"); //savegame2
	thread maps\_autosave::autosave_now("barge");
	//thread maps\_autosave::autosave_by_name("barge");
	//level thread global_autosave();
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
		//level.sniper_vesper waittill("goal");
	}
	 level notify("wave_sigma_zeta"); //wave3
	 level thread vesper_doors1_close();
}

//
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
	//wait(s);
	//guy stopcmd();
	//guy cmdshootatentity(level.player, false, 0.5, 0.1);
	if(isalive(guy))
	{
		guy stopallcmds();
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
	self thread shooters_disable_sense(); //threading them into a disable sense function
	self cmdfaceangles(90, false, 1);
	self waittill("cmd_done");
	//wait(0.1);
	level notify("thug_set3_ready");
	self.tetherradius = 60;

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
					//guy[i].script_noteworthy = "sniper_global_shooters";	
				}
				level waittill("amb3_death");
				//wait(z);
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
	trig = getent("vesper_stop3T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	level waittill("thug_set3_ready");
	while(1)
	{
		x = randomintrange(0,2);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
		//	level.sniper_vesper linkto(guy, "tag_origin", ( 30, 0, 0 ), ( 0, 0, 0 ) );
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim(guy);
			level.vesper_grab = 1;
			//level thread vesper_grab_anim2();
			//iprintlnbold(dialog [randomint(3)]);
			level thread vesper_fail_chatter2();
			guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(7.25);
			level thread vesper_caught_chatter();
			guy thread fail_shield();
			wait(0.5);
			if(isalive(guy))
			{
				level thread vesper_caught_chatter();
				missionfailedwrapper();			
			}
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

//Omega, the last stop before...
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
		//level thread sniper_amb_shooters_omega();
		level thread vesper_guidance();
		guy[i] waittill("death");
		level.vesper_guidance_var ++;
		level notify("door_man");
	}
	 level notify("wave_omega_clear");
	 level thread vesper_doors4_close();
	 level thread shooter_death_march();
}

//remember to place tactical walk
go_to_node_array4(guy, nodes2)
{
	z = randomintrange(4,7);
	intensity[0] = "jog";
  intensity[1] = "run";
	guy setgoalnode(nodes2, 1);
	guy SetScriptSpeed(intensity [randomint(2)]);
	guy waittill("goal");
	//wait(z);
	guy cmdshootatentity(level.player, false, z, 0.2);
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
  intensity[2] = "sprint";
  self endon("death");
	nodes = getnodearray("vesper_enemy4_nodes", "targetname");
	node = getnode("vesper_enemy4_node", "script_noteworthy");
	self SetAlertStatemax("alert_red");
	self SetScriptSpeed(intensity [randomint(3)]);
	self setgoalnode(node , 1);
	self waittill("goal");
	self thread shooters_disable_sense(); //threading them into a disable sense function
	self cmdfaceangles(90, false, 1);
	self waittill("cmd_done");
	//wait(0.1);
	level notify("thug_set4_ready");
	self.tetherradius = 60;
}	


//controls the spawning of the last wave of top deck 
//enemies
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
					//guy[i].targetname = "sniper_wave4_shooter" + i;
					guy[i].targetname = "sniper_shooters";
					//guy[i].script_noteworthy = "sniper_global_shooters";

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
	trig = getent("vesper_stop4T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	level waittill("thug_set4_ready");
	while(1)
	{
		x = randomintrange(1,2);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			guy endon("death");
			guy thread thug_grab_anim();
			level thread vesper_grab_anim(guy);
			level thread vesper_fail_chatter2();
			//guy cmdshootatentity(level.player, false, 3, 0.1);
			wait(5.75);
			guy thread fail_shield();
			level thread vesper_caught_chatter();	
			wait(0.5);
			if(isalive(guy))
			{
				level thread vesper_caught_chatter();
				missionfailedwrapper();				
			}
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
	//level thread vesper_stop_anim();
}

//vespers final stop
//spawns one guy and runs the thin fog.
vesper_stop_final()
{
	//level thread shooter_death_march();
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
	if(isalive(guy))
	{
		guy cmdshootatentity(level.player, false, z, 0.01);
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
			//guy thread thug_grab_anim();
			level thread vesper_fail_chatter2();
			guy cmdshootatentity(level.player, false, 3, 0.2);
			wait(5.5);
			guy thread fail_shield();
			level thread vesper_caught_chatter();
			wait(0.5);
			if(isalive(guy))
			{
				level thread vesper_caught_chatter();
				missionfailedwrapper();	
			}
			break;
		}
		wait(1);
	}
}

fail_shield()
{
	self endon("damage");
	if(isalive(self))
	{
		self thread magic_bullet_shield();
	}
}

vesper_kratt_away()
{
	clip = getent("kratt_vesper_clip", "targetname");
	look_at = getent("vesper_look_at_trigger", "targetname");
	look_at waittill("trigger");
	//level thread shooter_delete();
	if(level.ps3 == false && level.bx == false ) //GEBE
	{
	level thread roof_fog_fxz();
	}
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
	//kratt setgoalnode(node);
	level.sniper_vesper stopallcmds();
	vnode = getnode("vesper_end_node2", "targetname");
	level.sniper_vesper setgoalnode(vnode);
	wait(0.5);
	//kratt cmdshootatentity(level.player, false, 0.5, 75);
	
	level.sniper_vesper waittill("goal");
	
	level.sniper_vesper cmdfaceangles(77.9, 0);
	level.sniper_vesper CmdPlayanim("Vesper_StandCover", false);
	
	wait(0.75); //wait(0.5);
	//kratt waittill("goal");
	playcutscene("Barge_Kratt_Pull", "Pull_done");
	level thread KV_nabbed_dialogue();
	//level.sniper_vesper linkto(kratt, "tag_origin", ( 30, 0, 0 ), ( 0, 0, 0 ) );
	//kratt setgoalnode(node2);
	
	//kratt.goalradius = 64;
	//wait(3);
	//kratt LockAiSpeed("walk");
	//kratt waittill("goal");
	level waittill("Pull_done");
	kratt thread stop_magic_bullet_shield();
	wait(1);
	kratt delete();
	level.sniper_vesper delete();
	//playcutscene("Barge_KV_TankExplosion", "kv_explode_done");
	level notify("kratt_takes_away");
	clip delete();
}


KV_nabbed_dialogue()
{	
	level.sniper_vesper play_dialogue("KRAT_BargG_200A");  //[screams]  Let me go!
	level.sniper_vesper play_dialogue("VESP_BargG_097A");  //[screams]  Let me go!	
}


	
//takes the sniper shooters and makes them walk away one by one
shooter_death_march()
{
	level.sniper_event2 = 1;
	
	death_node = getnode("sn_shooter_delete_node", "targetname");
	shooters = getentarray("sniper_shooters", "targetname");
	if(isdefined(shooters))
	{
		for (i = 0; i < shooters.size; i++)
		{
			shooters[i] thread shooters_disable_sense();
			shooters[i] setgoalnode(death_node);
			shooters[i] thread death_delete();
			shooters[i] waittill("death");
		}
	}
}

//stopping the snipers from shooting at the player.
shooters_disable_sense()
{
	self endon("death");
	self stopallcmds();
	self setalertstatemin("alert_yellow");
	self lockalertstate( "alert_yellow" );
	self setenablesense(false);
}

death_delete()
{
	self endon("death");
	self waittill("goal");
	self delete();
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

	
//an objective created to make 
//sure all the remaining shooters are gone
//savegame3
sniper_shooters_dead()
{
	//savegame("barge"); //savegame3
	//level thread global_autosave();
	
	//Start Post Sniper Music - added by crussom
	level notify("playmusicpackage_postsniper");
	
	wait(2);
	thread maps\_autosave::autosave_now("barge");
	level notify("sniper_shooters_dead");
	level.sniper_event2 = 1;
	obj_ori = getent("finish_shooters_obj_ori", "targetname");
	//objective_add(3, "active", &"BARGE_FINISH_SNIPER_SHOOTERS", (obj_ori.origin), &"BARGE_FINISH_SNIPER_SHOOTERS_INFO");
	//level.player GiveMaxAmmo ( "VTAK31_Barge" );
	
	shooters = getentarray("sniper_shooters", "targetname");
	if(isdefined(shooters))
	{
		for (i = 0; i < shooters.size; i++)
		{
			shooters[i] stopallcmds();
			shooters[i].tetherradius = 10;
			//shooters[i] cmdshootatentity(level.player, false, 20, 0.01);
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
	missionfailedwrapper();
}

car_drive_warehouseT()
{
	trigger = getent("car_drive_warehouseT", "targetname");
	trigger waittill("trigger");
	//iprintlnbold("A car screeches to a halt outside");
}

//a safe place to save!
//level map change
warehouse_save_pointT()
{
	trigger = getent("warehouse_save_pointT", "targetname");
	trigger waittill("trigger");
	setSavedDvar( "sf_compassmaplevel", "level2" );
}

//when bond finishes the sniper event he encounters another small battle 
//currently there are four enemies spawned.
warehouse_drop_down()
{
	trigger = getent("warehouse_drop_downT", "targetname");
	trigger waittill("trigger");
	level thread magic_railing();
	cleanup();
	//close in the fog for ps3
	if(level.ps3 || level.bx ) //GEBE
	{
		setExpFog(420, 377, 0.208, 0.225, 0.240, 15, 1);
	}
	objective_state(4, "done");
	level thread warehouse_grenade();
	//level thread roof_fog_fx();
	//level waittill("grenade_done");

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
	//
	level thread ware_shooter_three();
	level thread docks_objective();
	level thread warehouse_door_breach();
	level thread warehouse_two_shooter();
	wait(2);
	level thread warehouse_save_logic();
}

//shooter2 rolls into place and 
//takes out the window at the bottom of the stairs
warehouse_two_shooter()
{
	ori = getent("warehouse_ori1", "targetname");
	guy = getent("_sniper_warehouse_shooters2", "targetname");
	node = getnode("ware_two_node", "targetname");
	guy setgoalnode(node);
	guy waittill("goal");
	guy cmdshootatentity(ori, false, 1, 1 );
}

//shooter 3 crouchwalks to the position back near the tanks
//had to disable his sense so he looks better, then enable it 
//at his goal
ware_shooter_three()
{
	guy = getent("_sniper_warehouse_shooters3", "targetname");
	//wait(0.5);
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
			//obj_ori = getent("get_on_barge_obj_ori", "targetname");
			ori = getent("corridor_pipe_ori3", "targetname");
			objective_add(5, "active", &"BARGE_RESCUE_VESPER", (ori.origin), &"BARGE_RESCUE_VESPER_INFO" );
			wait(1);
			thread maps\_autosave::autosave_now("barge");
			break;
		}
	wait(0.5);
	}
}

//grenade
warehouse_grenade()
{
	level thread warehouse_grenade2();
	wait(4.35); // the master wait time for the grenade 
	ori1 = getent("warehouse_ori1", "targetname");
	ori2 = getent("warehouse_ori2", "targetname");
	//radiusdamage(ori1.origin, 20,100,90);
	//wait(0.1);
	//radiusdamage(ori1.origin, 20,100,90);
	//wait(0.1);
	//radiusdamage(ori1.origin, 20,100,90);
	//wait(0.1);
	radiusdamage(ori1.origin, 20,100,90);
	level thread ware_window_damage();

	grenade = spawn("script_model", ori1.origin);
	grenade setmodel("w_t_grenade_flash");
	grenade physicslaunch(grenade.origin , vectornormalize((0, 3.0, 0)) );
	
	level.player playsound ("mus_bar_timphit");
	
	wait(1);
	playfx (level._effect["flash"], grenade.origin +(0, 0, 0));
	grenade playsound ("explo_grenade_flashbang");

	level.player shellshock("flashbang", 4);
	level.player play_dialogue_nowait("BMR5_BargG_045A");
	wait(0.5);
	if(!level.ps3 ) //GEBE
	{
		VisionSetNaked( "barge_4", 5 );
	}
	else if(level.ps3 || level.bx ) //GEBE
	{
		VisionSetNaked( "barge_4_ps3", 5 );
	}
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
	
	

//a script_brush is not needed since
//the door breach happens quickly
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
	//wait(7.13); //waiting so that the player can see the door get kicked.
	guy1 waittill("goal");
	guy1 setgoalnode(node2);
	guy1 waittill("goal");
	guy1 cmdplayanim("Thug_Alrt_FrontKick", false);
	//guy1 waittill("cmd_done");
	guy1 thread stop_magic_bullet_shield();
	guy1 setenablesense(true);
	guy1 setperfectsense(true);
	wait(0.8);
	clip movez(-200, 0.1);
	clip connectpaths();
	level notify("flash_door_start");
	clip delete();
	if(!level.ps3 && !level.bx) //GEBE
	{
		setExpFog(0, 500, 0.132716, 0.136742,  0.147763, 10, 0.99);
	}
 
}


		
//a safe place to save!
//savegame4
warehouse_transition_saveT()
{
	trigger =getent("warehouse_transition_saveT", "targetname");
	trigger waittill("trigger");
	pallete_clip = getent("suspend_tanks_snp_clip", "targetname");
	pallete_clip delete();
	dyn_light = getent("spotlight_light", "targetname");
	dyn_light2 = getent("spotlight_light_two", "targetname");
	dyn_light setlightintensity(0);
	dyn_light2 setlightintensity(0);
	/*setculldist(1200);*/
	//savegame("barge"); //savegame4
	//thread maps\_autosave::autosave_now("barge");
	level thread global_autosave();
	monster_clip = getent("sniper_monster_clip", "targetname");
	monster_clip movez(6000, 1);
	monster_clip connectpaths();
	//monster_clip delete();
	//level.player play_dialogue("BOND_BargG_106A");  //vesper vesper?
}



sniper_end()
{
	endcutscene("Barge_Intro_LoopEnd");
	level thread spotlight1_kill();
	if(!level.ps3 && !level.bx) //GEBE
	{
		level thread spotlight2_kill();
	}

	level thread acetylene_extras();
	level.sniper_event = 1;
	/*setculldist(1200);*/
	if(isdefined(level.spot_man))
	{
		level.spot_man delete();
	}
	//block = getent("blocker1", "targetname");
	//block show();
	//block disconnectpaths();
}

//some of the tanks in this cluster are dyn ents, to allow for better framerate
pseudo_tank_explosion()
{
	ori1 = getent("kratt_exp_ori1", "targetname");
	ori2 = getent("kratt_exp_ori2", "targetname");
	ori3 = getent("kratt_exp_ori3", "targetname");
	ori4 = getent("kratt_exp_ori4", "targetname");
	level thread barge_tank1();
	trigger = getent("barge_tank3_dmgT4", "targetname");
	clip = getent("tank3_dmgT4_player_clip", "targetname");
	trigger waittill("trigger");
	clip delete();
  earthquake(0.2, 2, ori4.origin, 1500);

	if(!level.ps3 & !level.bx)	//GEBE
	{
		level thread street_light_flicker();    
	}
	//level.player shellshock("default", 4);
	//level.player playerAnimScriptEvent("BargeGetup");
	playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0)); 
	wait(0.8);
	radiusdamage(ori1.origin, 60,550,520);
	radiusdamage(ori1.origin, 260,550,520);
	physicsExplosioncylinder(ori1.origin, 200, 10, 10 );
	//playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0)); //disabled to optimize fx running simultaneously 08/18
	wait(0.05);
	radiusdamage(ori3.origin, 60,550,520);
	radiusdamage(ori3.origin, 260,550,520);
	physicsExplosioncylinder(ori3.origin, 200, 10, 10 );
	//playfx (level._effect["fxdoor"], ori3.origin +(0, 0, 0)); //disabled to optimize fx running simultaneously 08/18
	wait(0.05);
	radiusdamage(ori2.origin, 60,550,520);
	radiusdamage(ori2.origin, 260,550,520);
	physicsExplosioncylinder(ori2.origin, 200, 10, 10 );
	level thread all_tanks_die();
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
	//iprintlnbold("vesper waits for bond");
	vesper pausepatrolroute();
}

//legacy pt_ongoal call
secret_vesper_finish()
{
	vesper = getent("Svesper", "targetname");
	//Print3d( vesper.origin + ( 0,0,200 ), "James, you're awesome", (0, 5, 0), 1, 4, 4000); 
	wait(2);
	//objective_state(9, "done");
}

//this spawns ai down the boarding plank
acetylene_extras()
{
	//level thread tanks_launcher();
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
			guys[i] thread flash_sense();
			guys[i] setgoalnode(nodes[i], 1);
			guys[i] AddEngageRule("tgtsight");
			//guys[i] thread shoot_at_bond();
		} 
	}
	level thread deck_fire2();
	level thread tree_cargo();
	//guys[i] setcombatrole("rusher");
}

shoot_at_bond()
{
	wait(3.5);
	if(isdefined(self))
	{
		self cmdshootatentity(level.player, false, 4, 1 );
	}
}

//this attempts to place some of the skinny tanks on the top of the ramp into physics
tanks_launcher()
{
	tanks = getentarray("rolling_tanks", "script_noteworthy");
	for (i = 0; i < tanks.size; i++) 
	{
		tanks[i] physicslaunch(tanks[i].origin, vectornormalize((122.0, 122.0, 2.8)) );
	}
}






//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||The DECK||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||The DECK||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||The DECK||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||The DECK||||||||||||||||||||||||||||||||||||||||||||||||||


//controls the dyn pallete setup and its destruction
//the pallete is linked to the explosive on the ground, and vice versa.
//this also sets off the chain reaction to destroy the cage around spotlight2 
tree_cargo()
{
	deck_ori1 = getent("deck_ori1_3", "targetname");			//the origin near the exploders on deck
	destruct_ori = getent("ori_dyn_kill1", "targetname"); //the origin above the final resting place of the suspended tanks
	
	spot2_tank = getent("spot2_tank", "script_noteworthy");
	level thread bullets_for_damage();
	trigger = getent("tree_cargo_trigger", "targetname");
	//phys_changeDefaultGravityDir( (0,0,-1) );
	tree_ori1 = getent("tree_cargo_ori1", "targetname");
	tree_ori2 = getent("tree_cargo_ori2", "targetname");
	rope = getent("pallete_rope_two", "targetname");
	trigger waittill("damage");
	level thread slow_time(.15, 1, 0.45);
	dynEnt_RemoveConstraint( "tanks_pallete", "suspend_tanks_point1" );
	//dynEnt_CreateDynamicEntityPointConstraint( <dyn-ent targetname>, <new constraint targetname>, <constraint point relative to entity>, <linked entity>, [secondary dyn-ent targetname] )
	//dynEnt_CreateDynamicEntityPointConstraint( "tanks_pallete", "pallete_link", (0,-30, 20) , "pallete_rope", "pallete_rope"  );
	
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
	wait(0.6);
	top_ori1 = getent("deck_ori4x", "targetname"); //secondary
	radiusdamage(deck_ori1.origin, 50, 10, 9); 
	wait(0.01);
	radiusdamage(deck_ori1.origin, 50, 10, 9); 
	wait(0.35);
	radiusdamage(top_ori1.origin, 50, 200, 199);	
	level notify("supress_done");
	level notify("damage_done");
	wait(1);
	if(isdefined(spot2_tank)) //third
	{
		spot2_tank dodamage(300, (0,0,5));
	}
	array = getentarray("fence_cage_apparatus_2", "targetname");
	if(isdefined(array))
	{
		for (i = 0; i < array.size; i++)
		{
			array[i] delete(); 
		}
	}
}

//this fires a bullet into the pallete trigger when applicable
bullets_for_damage()
{
	bullet_org = GetEnt("b_for_d_start","targetname");
	bullet_pos = GetEntArray("b_for_d_end","targetname");
	level waittill("drop_bombs");
	level endon("damage_done");
	while(true)
	{
		number = RandomInt(bullet_pos.size);
		magicbullet("FRWL_Barge", bullet_org.origin, bullet_pos[number].origin);
		wait(0.1);
	}
}

//threaded the second dyn point removal into its own function 
//for better control over its timing
second_point_remove(destruct_ori)
{
	wait(0.5);
	dynEnt_RemoveConstraint( "tanks_pallete", "suspend_tanks_point2" );
	wait(0.5);
	radiusdamage(destruct_ori.origin, 170, 110, 100); 
	wait(0.5);
	radiusdamage(destruct_ori.origin, 170, 110, 100); 
}

//this puts two thugs into an array and has them patrol the stern part of the ship
//bbekian 
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
//bbekian
//these thugs are the first thugs seen in the deck event.
stern_three_thugs_around_corner()
{
	supressors = getentarray( "tactical_suppressors","targetname" );
	nodes = getnodearray("supressor_nodes", "targetname");
	level thread supress_help();
	if(level.ps3 == false && level.bx == false) //GEBE
	{
	level thread roof_fog_fxy(); //low laying fog
	}
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

//magic bullets that appear on the side of the angled mini container 
supress_help()
{
	bullet_org = GetEnt("supress_start","targetname");
	bullet_pos = GetEntArray("supress_end","targetname");
	level thread supress_timer();
	trigger = GetEnt("e1_two_trigger", "script_noteworthy");
	ori1 = getent("deck_phys_ori1", "script_noteworthy");
	ori2 = getent("deck_phys_ori2", "script_noteworthy");
	ori3 = getent("deck_phys_ori3", "script_noteworthy");
	level endon("supress_done"); //ends after 10 seconds
	shooter = getent("deck_enemy0", "targetname");
	while(IsDefined(trigger))
	{
		x = randomfloatrange( 0.08, 0.1);
		shooter endon("death"); //or ends on this guys death
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
	wait(4);
	level notify("supress_done");
}


phys_prot_clip()
{
	clip = getent("phys_prot_clip", "targetname");
	clip movez(-2000, 0.01);
	clip connectpaths();
}

//bbekian
//2 types of tanks: tank1 = skinny ///// tank2 = fat
barge_tank1() 
{ 
	tank1_array = getentarray("barge_tanks1", "targetname");
	for(i = 0; i < tank1_array.size; i++)
	{
		tank1_array[i] setcandamage(true);
		tank1_array[i] thread barge_tank1_utility();
	}
}
	
barge_tank1_utility()  // specifies what fx tank1 uses and the damage it does
{
	ori = self.origin;
	fxspawn = spawn( "script_origin", ori );
	self waittill("damage");
	fxspawn playsound ( "expl_gastank" );
	earthquake(0.3, 0.5, fxspawn.origin, 600);
	playfx (level._effect["fxgen09"], fxspawn.origin);
	radiusdamage(self.origin, 50, 200, 199); 
	self delete();
}

barge_tank2() // 
{ 
	tank2_array = getentarray("barge_tanks2", "targetname");
	level endon("tanks_all_dead");
	for(i = 0; i < tank2_array.size; i++)
	{
		tank2_array[i] setcandamage(true);
		tank2_array[i] thread barge_tank2_utility();
	}
}
	
barge_tank2_utility()  // specifies what fx tank2 uses and the damage it does
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
}

barge_tank4() // 
{ 
	tank4_array = getentarray("barge_tanks4", "targetname");
	for(i = 0; i < tank4_array.size; i++)
	{
		tank4_array[i] setcandamage(true);
		tank4_array[i] thread barge_tank4_utility();
	}
}
	
barge_tank4_utility()  // specifies what fx tank2 uses and the damage it does
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
}


//bbekian
//a players choice event, causes the entire deck to erupt into chaos   								->(mousetrap)<-
//Deck event1
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
	//playfx (level._effect["fxfire3"], ori2.origin +(0, 0, 0));
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
			//box1 = getent("xx", "targetname");
			//box2 = getnet("xx", "targetname");
			//box = getent("sm_container_a", "targetname");
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
	//trigger = getent("out_deck_dmgT3", "targetname");
	ori1 = getent("deck_ori1_3", "targetname"); //on
	t3_deck_tank = getent("t3_deck_tank", "script_noteworthy");
	
	//these origins are up in the air, as to simultaneously explode one dummy tank on the pallete
	//and use the radius damage physics pulse to send the other "dummy" (dyn ent destruct tanks) onto the deck
	ori2 = getent("tree_cargo_ori1", "targetname"); 
	tree_ori2 = getent("tree_cargo_ori2", "targetname");
	
	//can enable or disable player only damage on the trigger
	while(1)
	{
		t3_deck_tank waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if(attacker == level.player)
		{
			level.deck_event = 1;
			//level.deck_event = 1;
			//playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			ori1 playsound("BRG_mousetrap2");
			//physicsExplosionSphere( ori1.origin, 300, 10, 2 );
			radiusdamage(ori1.origin, 300,500,200, ori1, "MOD_COLLATERAL" ); //looking into disabling this per kevins request	
			level notify("drop_bombs");
			
			wait(0.5);
			
			//radiusdamage(ori2.origin, 300,500,200);
			//radiusdamage(tree_ori2.origin, 300,500,200); //this origin is up in the air, and activates the

			//playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
			break;
		}
	wait(0.5);
	}
}


//removed exp sphere, reduced radius damage to 50 units//initially was at 300.
deck_fire4()
{
	trigger = getent("out_deck_dmgT4", "targetname");
	ori1 = getent("deck_ori4x", "targetname");
	trigger waittill("trigger");
	tank = getent("mousetrap_4x", "script_noteworthy");
	level.deck_event = 1;
	//level.deck_event = 1;
	//playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0)); //optimize fx running simultaneously 08/18
	ori1 playsound("BRG_mousetrap3");
	tank delete();
	//physicsExplosionSphere( ori1.origin, 300, 10, 2 );
	radiusdamage(ori1.origin, 50,500,200);
	earthquake(1, 0.6, ori1.origin, 1000);
	wait(1);
	playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
	wait(2);
}

//this trigger is located right after the ramp to get onto the barge
//it runs fog fx 
//it used to set sea sway 
e1_two_trigger()
{
	catwalk_mapT = getent("catwalk_mapT", "targetname");
	level notify("fx_fog_on"); //start the fog effects	
	
	trigger = getent("e1_two_trigger", "script_noteworthy");
	trigger waittill("trigger");
	
	level notify("lighthouse_start"); //CG - moved to after the waittill
	
	flag_set("_sea_physbob");
	flag_set("_sea_bob");
	//flag_set( "cargoship_lighting_off");
	level._sea_scale = 0.6;
	level._sea_viewbob_scale = 0.01;
	level._sea_physbob_scale = 1.0;
	level thread stern_thug_trigger_99_patrol();
		
	//savegame("barge");
	//iprintlnbold("fog please");
}


e1_three_trigger()
{
	//array = getentarray("e1_three_enemies", "script_noteworthy");
}

//bbekian
//this was initially in place to delete an AI on the roof when he reached the end of his patrol path in order to 
//balance difficulty. 
roof_guy_delete()
{
	guy = getent("first_enemies1", "targetname");
	guy delete();
}


//bbekian
//this grabs a group of four spawners (as found in the editor only) and checks how many of the
//four are left using aicount (a utility spawner var) it then sends a notify out to spawn the 
//three guys on the top deck.
deck_fire_spawn_think()
{
	trigger = getent("second_cover_deckT", "script_noteworthy");
	trigger waittill("trigger");
	level thread second_cover_deckT3();
	//if (level._ai_group[1].aicount <= 0);
	//iprintlnbold(level._ai_group["one"].aicount);
	//level notify("on_deck");
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


//bbekian
//handles the last wave around the corner.
//
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
			//dudes[i] lockalertstate( "alert_yellow" );
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


//bbekian
//a secondary wave of spawns that rely on the on_deck notify
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
			//dudes[i] lockalertstate( "alert_yellow" );
			dudes[i] AddEngageRule("tgtperceive");
			dudes[i] SetAlertStateMin("alert_red");
			dudes[i].goalradius = 24;
			dudes[i].targetname = "deck_fire" + i;	
			dudes[i] SetScriptSpeed("run");
		}
		wait(2.3);
	}
}

//objective 5 complete
//the two guys that come out the side of the deck once the battle 
//dies down
pre_backdraft_wave()
{
	ori = getent("corridor_pipe_ori6", "targetname");
	while(1)
	{
		if(level._ai_group["pre_backdraft_wave"].aicount == 0)
		{
			objective_state(5, "done"); 
			//wait(4);
			objective_add(6, "active", &"BARGE_UPPER_DECK", (ori.origin), &"BARGE_UPPER_DECK_INFO");
			//objective_add(7, "active", "BARGE_OPEN_THE_DOOR");
			break;
			
		}
		wait(0.5);
	}
}

//bbekian
//a physics effect to convey fire spread and a nosight clip moving into place to convey the smoke hiding bond
additional_deck_fx(ori2)
{
	nosight = getent("deck_firesight", "targetname");
	nosight moveto((3383, 460 , -48), 0.1);
	ori4 = getent("deck_ori4", "targetname");
	wait(2);
	radiusdamage(ori4.origin, 100,200,100);
	dmg = Spawn("script_origin", ori4.origin, 0, 0, 100);
 	dmg thread consistant_damage_util();
	playfx (level._effect["fxfire3"], ori4.origin +(0, 0, 0));
	ori4 playloopsound("BRG_fire");
	wait(1);
	level.player shellshock("default", 1);
	//physicsJolt(ori2.origin, 100, 75, (1.35, 1.21, 1.5) );
	//physicsExplosionSphere( ori2.origin, 100, 80, 1 );
}


//bbekian
//a temp distraction fucntion for fx, 												   					->(distraction)<-
//the notify allows for additional spawns.(currently disabled)
deck_use1T(awareness_object)
{
	trigger = getent("deck_use1T", "targetname");
	//trigger waittill("trigger");
	//level notify("on_deck");
	startdistraction("deck_distraction1", 0);
	fx = getent("dist1_fx_ori", "targetname");
	//playfx (level._effect["fxsmoke1"], fx.origin +(0, 0, 0));
	wait(1);
	trigger trigger_off();
}


//bbekian
//additional sounds and damage from 
//a smaller mousetrap on deck1
deck_pipe_trap(awareness_object)
{
	door = getent("deck_fall", "targetname");
	ori = getent("deck_pipe_ori", "targetname");
	ori2 = getent("deck_pipe_ori2", "targetname");
	trigger = getent("pipe_trigger", "targetname");
	//trigger waittill("trigger");
	door rotatepitch( 125, 0.5 );
	//physicsJolt(ori.origin, 100, 75, (1.65, 1.61, 0.5) );
	//physicsExplosionSphere( ori.origin, 100, 80, 1 );
	ori2 playsound("BRG_Mousetrap5");
	//wait(1);
	radiusdamage(ori2.origin, 300,400,300);
}



//bbekian
//corridor battle
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
			//array[i] SetScriptSpeed("walk")     
		}
	}
}

//|||||||||||||||||||||||||||||||||||||||||||||||||||					||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||backdraft||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||| 				||||||||||||||||||||||||||||||||||||||||||||||||||

//bbekian
//spawns the guys inside the backdraft corridor
stern_spawn_thug_five()  //corridor enemies
{
	stern_trigger_thug_five = getent ( "stern_trigger_thug_five", "targetname" );
	stern_trigger_thug_five waittill ( "trigger" );
	//looktrigger = getent("stern_trigger_thug_five", "targetname");
	//level thread roof_fog_fx();
	level thread corridor1_steam_ori();
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
			//looktrigger waittill("trigger");
			if(!maps\_utility::spawn_failed( array[i]))
			{
				array[i] SetAlertStateMin("alert_red");
				array[i] setgoalnode(bdnodes[i], 1);
				array[i].targetname = "fstdoor_enemy" + i;
				//array[i] startpatrolroute( "first_door_pat" + i );
				array[i] SetScriptSpeed("run");    
				//array[i] CmdAimatEntity( ori, false, 5 );
			}
		}
	}
	else if(level.bdrft_var > 3) //dont spawn the guys if the tanks are blown before getting to the door
	{
		level notify("guys_in_tank_room");
		for (i = 0; i < array.size; i++)
		{
			//array[i]= array[i] stalingradspawn();
			if( !maps\_utility::spawn_failed( array[i]) )
			{
				//array[i] SetAlertStatemin("alert_red");
				//array[i] setgoalnode(nodes[i], 1);
				//array[i].targetname = "fstdoor_enemy" + i;
				//------------
				//array[i] CmdAimatEntity( ori, false, 5 );
				//array[i] SetScriptSpeed("run");     
			}
		}
	}
}

//running into this trigger turns on the 
//damage trigger associated with the tanks inside the 
//tank room on the barge (shoot the tanks through the portal)
//savegame5
tank_on_trigger()
{
	trigger = getent("tank_on_trigger", "targetname");
	trigger waittill("trigger");
	level thread backdraft_tanksT();
	level notify("tanks_released");
	//savegame("barge"); //savegame5
	//thread maps\_autosave::autosave_now("barge");
	level thread global_autosave();
}

//the guy at the backdraft door blind fires
//and either runs into the corridor when he is done
//or runs into the corridor when the player approaches the door
//the door also closes if the AI gets shot
scared_backdraft_guy()
{
	level.scared_guy = getent("scared_backdraft_guy", "targetname")  stalingradspawn( "scared_backdraft_guy" );
	node = getnode("scared_backdraft_guy_node", "targetname");
	blast_door_player_clip = getent("blast_door_player_clip", "targetname");
	
	blast_door = getent("blast_door", "targetname");  //moving this to the tanks function
	blast_door_clip = getent("blast_door_clip", "targetname");
	trigger = getent("scared_backdraft_guyT", "targetname");
	if(!maps\_utility::spawn_failed(level.scared_guy) )
	{
		level.scared_guy SetAlertStatemin("alert_red");
		level.scared_guy SetScriptSpeed("run"); 
		level.scared_guy setenablesense(false);
		level.scared_guy setFlashBangPainEnable( false );
		//level.scared_guy.goalradius = 16;
	}
	level.scared_guy setgoalnode(node);
	level thread door_objective_update();
	blast_door thread door_close_safety(blast_door_player_clip);
	level waittill("tanks_released");
	trigger waittill("trigger");
	//level.scared_guy cmdaction("CoverPeek", false, 1);
	//level.scared_guy waittill("cmd_done");
	if(isdefined(level.scared_guy))
	{
		level.scared_guy cmdshootatentity(level.player, false, 2.5, .33, true);
	}
	
	level thread retreat_corridor_now(blast_door_clip, blast_door, blast_door_player_clip);
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
		if (!IsDefined(blast_door_clip.blast_door_clip_moved_into_place))
		{
			blast_door_clip.blast_door_clip_moved_into_place = true;
			blast_door_clip movez(300, 0.01);
		}
		
		
		level notify("blast_this");
		level notify("move_type1");
		level notify("obj_six");
		
		blast_door_player_clip delete();
		blast_door playsound("BRG_hatch_door_close");
		blast_door_clip disconnectpaths();
		// Start Lower Intenisty Action Music
		level notify("playmusicpackage_action2");
	}
}

retreat_corridor_now(blast_door_clip, blast_door, blast_door_player_clip)
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
		if (!IsDefined(blast_door_clip.blast_door_clip_moved_into_place))
		{
			blast_door_clip.blast_door_clip_moved_into_place = true;
			blast_door_clip movez(300, 0.01);
		}
		
		level notify("blast_this");
		level notify("obj_six");

		blast_door_player_clip delete();
		blast_door playsound("BRG_hatch_door_close");
		wait(1);
		blast_door_clip disconnectpaths();
		// Start Lower Intenisty Action Music
		level notify("playmusicpackage_action2");
	}
}


door_objective_update()
{
	level waittill("obj_six");
	obj_ori = getent("backdraft_tank_ori1", "targetname");
	objective_state(6, "done");  //checked
	//wait(2);
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
		if(isdefined(self))
		{
			self cmdshootatentity(level.player, false, 4, 0.01);
		}
	}
}

door_close_safety(blast_door_player_clip)
{
	level.scared_guy waittill("death");
	wait(0.05);
	level endon("blast_this");
	if(isdefined(self))
	{
		self rotateyaw(90, 0.3, 0.2, 0.03);
		self playsound("BRG_hatch_door_close");
		level notify("playmusicpackage_action2");
		level notify("obj_six");
		if(isdefined(blast_door_player_clip))
		{
			blast_door_player_clip rotateyaw(90, 0.3, 0.2, 0.03);
			blast_door_player_clip delete();
		}
	}
}



//triggers for this event are disabled and enabled in this function
//this fucntion enables triggers and removes the safety clip around the tanks inside the room
//it also handles the logic behind shooting the tanks to blow the door
//it runs an audio thread
//it also hides and shows the fx prefab
deck_checkp1()
{
	level thread tank_on_trigger();
	blast_door_clip = getent("blast_door_clip", "targetname");
	blast_door = getent("blast_door", "targetname");  //moving this to the tanks function
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

//welcome to portals close/open, where all
//your dreams come true
portals_open()
{
	guy1 = getent("fstdoor_enemy0", "targetname");
	if(IsDefined(guy1))
	{
		guy1 endon("death");
	}
	port1 = getent("port_window1", "targetname");
	port2 = getent("port_window2", "targetname");
	port3 = getent("port_window3", "targetname");
	
	//SOUND: Added audio calls 09012008 - Shawn J
	port3 rotateyaw(165, 0.4, 0.15, 0.15);
	port3 playsound("BRG_port_hole");
	wait(2);
	port2 rotateyaw(170, 0.4, 0.15, 0.15);
	port2 playsound("BRG_port_hole");
	wait(7);
	port1 rotateyaw(157, 0.4, 0.15, 0.15);
	port1 playsound("BRG_port_hole");
}
	
//this makes the enemies inside the tank room 
//appear like they are shooting at bond when the event
//reaches the correct state
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

//
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

//this handles the audio when the player walks up 
//to the portal
backdraft_voices()
{
	trigger3 = getent("backdraft_voicesT", "targetname");
	trigger3 waittill("trigger");
	if(level.bdrft_var < 4)
	{
		trigger3 play_dialogue_nowait("DOM1_BargG_079A");  //He’s outside the door!  Watch the windows!
		wait(3);
		trigger3 play_dialogue_nowait("DMR2_BargG_080A");  //Stay away from the portholes!
		wait(2);	
		level thread portals_open();
		level thread fake_bullets();
	}
}

//this function constantly checks the damage trigger for
//player only damage and renders all needed fire effects when its damaged
//all the origins that render steam and fire
//it also sets a var for control over the event
//it threads the controller rumble and
//runs function that handles the tanks differently after this is triggered
//this does not handle the final explosion, only the pre fire/explosion
backdraft_tanksT()
{
	level thread bd_guys_die();
	brush = getent("fire_protect_brush", "targetname");
	brush delete();
	tanks_trig = getent("backdraft_tanksT", "targetname");
	//tanks_trig trigger_on();
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
	//tanks_trig waittill("trigger");
	while(1)
	{
		tanks_trig waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
		if(attacker == level.player) //a damage filter on the trigger volume for player only damage
		{
			radiusdamage(ori1.origin, 45, 200,100);
			radiusdamage(ori2.origin, 45, 200,100);
			level thread backdraft_rumble();
			level thread backdraft_tanks_remove_filter();
			level.bdrft_var = 4;	
			playfx (level._effect["fxgen09"], ori4 .origin +(0, 0, 0));
			wait(0.1);
			level notify("fire_starter");
			wait(0.1);
			radiusdamage(ori1.origin, 45, 200,100);
			radiusdamage(ori2.origin, 45, 200,100);
			radiusdamage(ori4.origin, 45, 200,100);
			radiusdamage(ori5.origin, 45, 200,100);
			blast_door_player_clip = getent("blast_door_player_clip", "targetname");
			if(isdefined(blast_door_player_clip))
			{
				blast_door_player_clip delete();
			}
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

//explodes all tanks after the trigger is damaged by the player only
//disregards the barge_tanks2 array for player only damage
//to emulate all tanks exploding
backdraft_tanks_remove_filter()
{
	tank2_array_plyr = getentarray("blast_room_tanks", "script_noteworthy");
	if(isdefined(tank2_array_plyr))
	{
		for(i = 0; i < tank2_array_plyr.size; i++)
		{
			level notify("tanks_all_dead");
			//playfx (level._effect["fxgen09"], tank2_array_plyr[i].origin);
			tank2_array_plyr[i] delete();
		}
	}
}

//attempts to place clips around all fire 
//volumes in the blast room by moving
//them into place from below
bd_fire_clip()
{
	clips = getentarray("bd_fire_clips", "targetname");
	for (i = 0; i < clips.size; i++)
	{
		clips[i] movez(48, 0.1);
	}
}

//assures that all ai inside the blast corridor are
//dead after the explosion based on the 
//fire_starter notify
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

//this handles the rumble on the controller
//to convey fire or pressure building up
//after the tanks are ignighted
backdraft_rumble()
{
	while(level.bdrft_var != 4)
		wait(0.1);

	safety = 0;

	while(level.bdrft_var == 4 && safety < 4)
	{
	    earthquake(0.2, .25, level.player.origin, 100, 0);
			level.player playrumbleonentity("damage_light");
			wait( 0.3 );
			safety++;
	}
	earthquake(0.7, .25, level.player.origin, 100, 0);
	level.player playrumbleonentity("artillery_rumble");
}

//renders smoke from the bottom of the 
//door after the tanks are ignighted
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

//once this trigger gets turned on in deck_checkp1()
//it registers the final number 
//initially used to trigger vison set 3 but, this has been 
//moved to the vison set triggers.
//this also waits for the playe to enter the corridor and
//sends out the notify for the vents to collapse
//also controls objective logic
backdraft_final()
{
	//trigger2 = getent("fire_backdraftT", "targetname");
	trigger = getent("backdraft_finalT", "targetname");
	trigger waittill("trigger");

	level.bdrft_var = 5;
	level notify("guys_in_tank_room");
	ori3 = getent("corridor_pipe_ori3", "targetname");
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	vision_trigger = getent("backdraft_afterT", "targetname");
	vision_trigger waittill("trigger");
	level notify("vents_break_start");
	ori3 playsound("BRG_vent_collapse");
	level thread bdr_elec_wires(); //bdr = back draft room 
	level thread wall_of_fire();
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	//savegame("barge");
	wait(0.1);
	ori3 radiusdamage(ori3.origin, 250, 60, 50, ori3, "MOD_COLLATERAL"  );
	wait(1.5);
	//trigger2 trigger_on();
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
	level thread corridor_pipe();
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

wall_of_fire()
{
	trigger = getent("fire_door_startT", "targetname");
	trigger waittill("trigger");
	ori6 = getent("corridor_pipe_ori6", "targetname");	//bottom door
	ori7 = getent("corridor_pipe_ori7", "targetname"); 	//mid door
	
	dmg = Spawn("script_origin", ori6.origin, 0, 0, 35);
	dmg2 = Spawn("script_origin", ori7.origin, 0, 0, 35);
 	dmg thread consistant_damage_util();
 	dmg2 thread consistant_damage_util();
 	
	playfx (level._effect["fxfire3"], ori6.origin +(0, 0, 0));
	ori6 playloopsound("BRG_fire");
	
}

sparking_end()
{
	trigger = getent("exit_to_side_T", "targetname");
	trigger waittill("trigger");
	level.spark_var = 1;
}

corridor_runback()
{
	//iprintlnbold("backdraft");
	trigger = getent("corridor_plydmgT","targetname");
	wait(10);
	trigger trigger_off();
}

corridor_pipe()
{
	trigger = getent("corridor_pipeT", "targetname");
	ori1 = getent("corridor_pipe_ori", "targetname");
	//trigger waittill("trigger");
	playfx (level._effect["pipesteam"], ori1.origin +(0, 0, 0));
	earthquake(0.5, 0.6, ori1.origin, 1000);
	wait(1);
	//playfx (level._effect["fxpumpgen"], ori1.origin +(0, 0, 0));
	wait(2);
}

backdraft_ai_trigger()
{
	trigger = getent("backdraft_ai_trigger", "targetname");
	trigger waittill("trigger");
	level.bdrft_var ++;
}


//the final backdraft explosion and subsequent damage
//the backdraft triggers and fx for the corridor
//multiple origins line the corridor for extra effects if needed.
corridor_tanks()
{
	trigger = getent("corridor_plydmgT","targetname");
	trigger trigger_on();
	look = getent("backdraft_lookat_t", "targetname");
	//door = getent("backdraft_door", "targetname");
	ori1 = getent("corridor_tanks_ori", "targetname"); 
	ori2 = getent("corridor_pipe_ori2", "targetname"); 
	ori3 = getent("corridor_pipe_ori3", "targetname");
	ori4 = getent("corridor_pipe_ori4", "targetname"); 
	ori5 = getent("corridor_pipe_ori5", "targetname");
	ori6 = getent("corridor_pipe_ori6", "targetname");	//bottom door
	ori7 = getent("corridor_pipe_ori7", "targetname"); 	//mid door
	while(1)
	{
		if(level.bdrft_var == 5)        	//(level.corridor_mousetrap == 1) <--- used to be old
		{
			look waittill("trigger");
			level notify("backdraft"); 
			objective_state(6, "done");
			objective_state(13, "done");
			radiusdamage(ori7.origin, 190, 200, 1);
			//wait(0.66);
			//playfx (level._effect["fxdoor"], ori1.origin +(0, 0, 0));
			ori1 playsound("BRG_backdraft");
			wait(0.1); //waiting for the fx prefab to show
			level notify("door_blast_start"); 
			//earthquake(0.1, 1, ori1.origin, 500);
			radiusdamage(ori7.origin, 190, 200, 1);
			obj_ori = getent("crane_death_ori1", "targetname"); //the next objective location
			objective_add(8, "active", &"BARGE_GET_TO_THE_FRONT", (obj_ori.origin), &"BARGE_GET_TO_THE_FRONT_INFO");
			physicsExplosionSphere(ori6.origin, 200, 199, 40);
			wait(0.1);
			//playfx (level._effect["fxpumpgen"], ori3.origin +(0, 0, 0));
			//earthquake(1.3, 1.5, ori1.origin, 1000);
			wait(0.1);
			playfx (level._effect["exp_fireext_haze"], ori4.origin +(0, 0, 0));
			wait(0.1);
			//playfx (level._effect["fxdoor"], ori6.origin +(0, 0, 0));		
			corridor_runback();
			break;
		}
		wait(0.1);
	}
}


//bbekian
//ambient steam inside the barge corridors	
corridor1_steam_ori()
{
	//fx = getent("corridor1_steam_ori", "targetname");
	array = getentarray("corridor1_steam_ori", "targetname");
	for (i = 0; i < array.size; i++)
	{
		playfx (level._effect["ambientS"], array[i].origin);
	}
}



//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--ROOF-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--ROOF-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--ROOF-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--ROOF-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//bbekian
//a trigger when the player enters the side of the ship
exit_to_side()
{
	trigger= getent("exit_to_side_T", "targetname");
	trigger waittill("trigger");
	level thread scared_man_trigger();
	if(level.ps3 == false && level.bx == false )//GEBE
	{
	level thread roof_fog_fx();
	}
	setSavedDvar( "sf_compassmaplevel", "level3" );
	//turning off the thin after sniper fog, and deck1 fog.
	level.roof_fog_fxz_var = 1;
	level.roof_fog_fxy_var = 1;
	
	//side_thug = getent ("side_thug_spawner", "targetname") stalingradspawn("side_thug0" );
	//if( !maps\_utility::spawn_failed( side_thug ) )
  //{ 
		//side_thug.goalradius = 24;
		//side_thug StartPatrolRoute ( "shipside_pat" );
  //}
  //savegame("barge"); //savegame5
  //thread maps\_autosave::autosave_now("barge");
  level thread global_autosave();
}


//bbekian
//the barge main fog functions // each roof fog variant controls different origins.
roof_fog_fx()
{
	fog_array = getentarray("roof_fog_ori", "targetname");	
	
	particle_delay = (fog_array.size * 0.25);
	
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog"], fog_array[i].origin +(0, 0, 0));
		}
		wait(10);
	}
}

//testing roof fog 2
roof_fog_fxx()
{
	fog_array = getentarray("roof_fog_orix", "targetname");
	
	particle_delay = (fog_array.size * 0.25);
	
	while(level.roof_fog_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog2"], fog_array[i].origin +(0, 0, 0));
		}
		wait(10);
	}
}

roof_fog_fxy()
{
	fog_array = getentarray("roof_fog_oriy", "targetname");
	
	particle_delay = (fog_array.size * 0.25);
	
	while(level.roof_fog_fxy_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog"], fog_array[i].origin +(0, 0, 0));
		}
		wait(10);
	}
}

//roof fog2 //thinner fog.
roof_fog_fxz()
{
	fog_array = getentarray("roof_fog_oriz", "targetname");
	
	particle_delay = (fog_array.size * 0.25);
	
	while(level.roof_fog_fxz_var == 0)
	{
		for (i = 0; i < fog_array.size; i++  )
		{
			playfx (level._effect["roof_fog2"], fog_array[i].origin +(0, 0, 0));
		}
		wait(10);
	}
}

//second_cover_deckT
top_of_stairsT()
{
	trigger = getent("top_of_stairsT", "targetname");
	trigger waittill("trigger");
	level notify("stair_top");
	dynEnt_StartPhysics("train_car_barrels");
}

//this sends a guy(s) down the left side of the barge when
//the player runs up the steps to the upper deck
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
				//array[i].targetname = "canopy_enemy_one" + i;
				//array[i] startpatrolroute( "canopy_pat" + i );
				array[i] SetScriptSpeed("run"); 
				array[i] setgoalnode(nodes[i]);  
				array[i] waittill("goal");
				array[i] delete();
			}
	}
}

//A guy comes out of the train car and 
//runs back into postion.
scared_man_trigger()
{
	node1 = getnode("scared_man_node1", "targetname");
	clip = getent("roof_monster_clip", "targetname");
	trigger = getent("scared_man_trigger", "targetname");
	trigger waittill("trigger");
	clip movez(3000, 0.1);
	clip connectpaths();
	guy = getent("scared_man", "targetname") stalingradspawn("scared");
	if( !maps\_utility::spawn_failed(guy))
  { 
		guy setalertstatemax("alert_red");
		guy SetScriptSpeed("run");
		guy allowedstances("crouch");
		//guy setengagerule("tgtsight");
		//guy setgoalnode(node1);
		guy thread crouch_to_search();
		guy thread has_been_shot();
	//	guy thread scared_sense();
		//guy thread scared_man_fix();
	}
}

scared_man_fix()
{
	self endon("death");

	while(1)
	{
		if(self CanSeeThreat(level.player) )
		{
			self allowedstances("stand");
		}
		wait(.1);
	}
}

scared_sense()
{
	wait(3);
	self thread flash_sense();
}

has_been_shot()
{
	self endon("death");
	self waittill("damage");
	self setalertstatemin("alert_red");
}

crouch_to_search()
{
	node2 = getnode("scared_man_node2", "targetname");
	self endon("death");
	if(isdefined(self))
	{
		self setgoalnode(node2);
		self setalertstatemin("alert_red");
		self waittill("goal");
		self allowedstances("stand");
		self setcombatrole("guardian");
	}
}

	
//spawns the enemies in the train car area
//of the upper deck
cargo_enemies()
{
	trigger = getent("cargo_enemyT", "targetname");
	trigger2 = getent("cargo_enemiesT2", "targetname");
	trigger waittill("trigger");
	wait(0.05);
	thread maps\_autosave::autosave_now("barge");
	wait(0.05);
	level thread train_top_trigger();
	level thread spot_op_threeT();
	
	bow_cargo_crashT = getent("bow_cargo_crashT", "targetname");
	
	trigger2 waittill("trigger");
	
	//Start Climax Music - Added by crussom
	level notify("playmusicpackage_climax");

	//array = getentarray("cargo_enemies","targetname");
	//for (i = 0; i < array.size; i++)
	//{
	//	array[i]= array[i] stalingradspawn();
	//	if( !maps\_utility::spawn_failed( array[i]) )
	//	{
	//		array[i] SetAlertStateMin("alert_red");
	//		array[i].targetname = "cargo_enemy" + i;
			//array[i] startpatrolroute( "cargo_pat" + i );
	//		array[i] SetScriptSpeed("jog");    
	//	}
	//	wait(3);
	//}
	//guy1 = getent("cargo_enemy0", "targetname");
	//guy2 = getent("cargo_enemy1", "targetname");
	//guy1 CmdAction( "TalkA1" );
  //guy2 CmdAction( "TalkA2" );
  //guy2 playsound("BRG_generic_dialouge1");
  //wait(1.25);
  //guy1 stopcmd();
  //guy2 stopcmd();
	//guy = getent("cargo_pat2", "targetname");
	//guy SetScriptSpeed("walk"); 
}

//when the player reaches the top of the
//train car before the top deck 
train_top_trigger()
{
	train_top = getent("train_top_trigger", "targetname");
	look_trig = getent("supress2_lookat", "targetname");
	
	spn_trigger = getent("supress2_spawnT", "targetname");
	spn_trigger waittill("trigger");
	
	
	node2 = getnode("supressors2_escape_node2", "targetname");
	
	wait(0.5); //wait for the player to get his gun back after the ladder
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
	//self waittill("goal");
	wait(8);
	if(isdefined(self))
	{
		self setignorethreat(level.player, false);
		self SetAlertStateMin("alert_red");
	}
}

run_logic2()
{
	self endon("death");
	node = getnode("supressors2_escape_node2", "targetname");
	self stopallcmds();
	//self SetAlertStateMin("alert_green");
	self setignorethreat(level.player, true);
	self setgoalnode(node, 1);
	//self waittill("goal");
	wait(8);
	if(isdefined(self))
	{
		self setignorethreat(level.player, false);
		self SetAlertStateMin("alert_red");
	}
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
		
//bbekian
//this fucntion handles the first group of roof spawns after the cargo enemies 
//and thier alert states, patrols and nodes.
//this fucntion also enables the damage triggers associated with the cargo
//being hung from the crane
//savegame7
side_to_roofT()
{
	cargo_colL = getent("container_collisionL", "targetname");
	cargo_colR = getent("container_collisionR", "targetname");
	cargo_colC = getent("container_collisionC", "targetname");
	cargo_colL movez(3000, 0.1);
	cargo_colR movez(3000, 0.1);
	cargo_colC movez(3000, 0.1);
	cargo_colL connectpaths();
	cargo_colR connectpaths();
	cargo_colC connectpaths();
	trigger = getent("side_to_roofT", "targetname");
	trigger waittill("trigger");

	//save halfway through barge hopefully
	thread maps\_autosave::autosave_by_name("barge",60);

	//level maps\_playerawareness::setupSingleDamageOnlyNoWait( "control_shoot_doorT1", ::control_shoot_doorT1, true , maps\_playerawareness::awarenessFilter_PlayerOnlyDamage, level.awarenessMaterialMetal, 1, 0);
	//level thread control_shoot_doorT1(); // moved 06/30
	level thread crane_cargo();
	//thread maps\_autosave::autosave_now("barge");
	level thread global_autosave();
	level thread catwalk_mapT();
	//roof_fog_fx();
	//level.roof_fog_var = 1;
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
				//array[i] startpatrolroute( "canopy_pat" + i );
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
				//array[i] startpatrolroute( "canopy_pat" + i );
				array[i] SetScriptSpeed("run");   
			}
		}
	}
}

spot_op_threeT()
{
	trigger = getent("spot_op_threeT", "script_noteworthy");
	trigger waittill("trigger");
	spot_op_three = getent("spot_op_three", "targetname")  stalingradspawn( "spot_op_three" );
	spot_op_three waittill("death");
	level.kratt_fight_var = 1;
	wait(0.5);
	level notify("spot_op_three_dead");
}
	
	
//bbekian
//this fucntion handles additional and final canopy enemies
//its a second wave of enemies
//Note: there are some spawns that are handled in the editor only
//please check the editor (on the roof of the barge near the crane control room)
//for these triggers/spawners
canopy_al_checks()
{
	trigger = getent("canopy_alert_trigger", "targetname");
	array = getentarray("canopy_enemies2", "targetname");
	nodes = getnodearray("canopy2_nodes", "targetname"); 
	trigger waittill("trigger");

	//save halfway through barge hopefully
	thread maps\_autosave::autosave_by_name("barge",60);

	level thread kratt_fight();
	monster_clip = getent("sniper_monster_clip", "targetname");
	monster_clip movex(350, 0.1);
	wait(1);
	monster_clip movez(-6000, 1);
	monster_clip disconnectpaths();	
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
					//array[i].accuracy = 1;
					//array[i] setengagerule("tgtSight");
					array[i] thread flash_sense();
					array[i] setgoalnode(nodes[i], 1);
					//array[i] startpatrolroute( "canopy_pat" + i );
					array[i] SetScriptSpeed("jog");   
				}
			}	
			level thread kratt_spawn_final();
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
					//array[i] setengagerule("tgtSight");
					array[i] thread flash_sense();
					//array[i].accuracy = 1;
					array[i] setgoalnode(nodes[i], 1);
					//array[i] setgoalnode(nodes[i]);
					//array[i] startpatrolroute( "canopy2_pat" + i );  //added more guys and didnt want to add more patrols so enabling this will crash the game
					array[i] SetScriptSpeed("run");   
				}
			}
			level thread kratt_spawn_final();
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

//bbekian
//this is the first function in adding dynamics to the crane control room
//this thread has been disabled in main()
b_room_ceilingT()
{
	trigger = getent("b_room_ceilingT", "targetname");
	ori = getent("b_room_fire_ori", "targetname");
	trigger waittill("trigger");
	playfx (level._effect["ceiling_smoke01"], ori.origin);
}

//bbekian
//this spawns two enemies at the front of the ship
//one of them has a editor specified goal node that is near the 
//cargo door use trigger 
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
			//array[i] setgoalnode(nodes[i]);
			//array[i] startpatrolroute( "" + i );
			//array[i] SetScriptSpeed("walk");   
		}
	}
}

//bow of the ship
trap_door()
{
	lookat = getent("trap_door_look", "targetname");
	trigger = getent("trap_doorT", "targetname");
	door_left = getent("trap_door_l", "targetname");
	door_right = getent("trap_door_r", "targetname");
	while(1)
	{
		if(level.player istouching(trigger))
		{
			lookat waittill("trigger");
			door_left rotateroll(-135, 1.5, 0.5, 0.5);
			door_right rotateroll(135, 1.5, 0.5, 0.5);
			door_left playsound("BRG_double_doors_close");
			//waittill("rotatedone");
			break;
		}
		wait(1);
	}
}

trap_door_use()
{
	clip = getent("trap_door_clip", "targetname");
	trigger = getent("trap_door_useT", "targetname");
	trigger sethintstring(&"SCRIPT_OPEN_DOOR");
	ori = getent("cargo_crash_look_ori", "targetname");
	door_left = getent("trap_door_l", "targetname");
	door_right = getent("trap_door_r", "targetname");
	
	trigger waittill("trigger");
	objective_state(14, "done");
	
	door_left rotateroll(135, 3, 1, 1);
	door_right rotateroll(-135, 3, 1, 1);
	door_left playsound("BRG_double_doors_open");
	
	level.player freezecontrols(true);
	
	//direction = VectorToAngles( ori.origin - (level.player.origin+(0,0,72)));      // don't forget to compute from the head, not the feet
 	//level.player SetPlayerAngles(direction);
 	
 	level.player customcamera_checkcollisions( 1 );
 	
	endcin  = level.player customCamera_push(
		"world",							// <required string, see camera types>
		level.player.origin +(50, -50, 60),				// <optional positional vector offset, default (0,0,0)>	
		(50, 0, 0),				// <optional angle vector offset, default (0,0,0)>
		3.00,								// <optional time to 'tween/lerp' to the camera, default 0.5>
		0.00,
		2.5
		);

 	//level.player customCamera_pop( level.cameraID_endcin, 0 );
	wait(3); 
	//level.player customcamera_checkcollisions( 1 );
	
	level.player freezecontrols(false);
	//playcutscene("Brg_Bnd_Jmp_Dwn", "Barge_Bnd_Jmp_Dwn");
	lechiffre = getent("torture_lechiffre" , "targetname")  stalingradspawn("lechiffre");
	lechiffre waittill("finished spawning");
	
	lechiffre maps\_utility::gun_remove();
	lechiffre attach( "w_t_pipe", "TAG_WEAPON_RIGHT" );		
	
	vesper = getent("vesper_torture" , "targetname")  stalingradspawn("vesper");
	vesper waittill("finished spawning");
	wait(0.05);
			
	//End Music - Added by crussom	
	level notify("endmusicpackage");
	
	playcutscene("Barge_Drop", "Barge_Drop_End");
	level waittill("Barge_Drop_End");
	visionsetnaked("barge_dark", 0.01);
	setDvar( "cg_disableHudElements", 1 );
	maps\_endmission::nextmission();

	//level thread bond_gets_hurt();
	
	
}


kratt_fight()
{
	trigger = getent("fight_area_trigger1", "targetname");
	trigger waittill("trigger");
	level thread spotlight3_logic();
	
}

kratt_spawn_final()
{
	wait(3); //wait for canopy enemies2 to spawn
	while(1) 
	{
		if(level._ai_group["final_wave"].aicount <= 1) //used to be zero aka 0, but im pumping up the difficulty
		{
			level.kratt_final = getent("kratt_boss_final", "targetname")  stalingradspawn( "kfinal" );
			if(!maps\_utility::spawn_failed( level.kratt_final))
			{
				//level.kratt_final lockalertstate( "alert_yellow" );
				level.kratt_final SetAlertStateMin("alert_red");
				level.kratt_final.goalradius = 24;
				level.kratt_final SetScriptSpeed("run");
				level.kratt_final play_dialogue_nowait("KRAT_BargG_201A"); //You're going to die, Bond!
				level.kratt_final.accuracy = 111;
				level.kratt_final allowedstances("stand");
				level.kratt_final setFlashBangPainEnable( false );
				//level.kratt_final.health = 666; //bad!
			}
			level thread kratt_final_attack();
			//level thread kratt_exploder_trigger();
			level thread control_shoot_doorT1();
			level thread kratt_on_death();
			break;
		}
		wait(0.2);
	}
	
}

kratt_on_death()
{
	ori = getent("kratt_exploder_origin", "targetname");
	grenade_ori = getent("crane_death_ori1", "targetname");
	
	level.kratt_final waittill("damage");
	level.kratt_final.grenadeWeapon = "concussion_grenade";
	level.kratt_final.grenadeAmmo = 1;
	level.kratt_final magicgrenade(grenade_ori.origin, ori.origin, 2); //throwing out the final grenade towards the tanks so that the player knows to get out!
	
	//level.kratt_final waittill("death");
	//grenade = spawn("concussion_grenade", grenade_ori.origin);
	//level.kratt_final.grenadeWeapon = "concussion_grenade";
	//level.kratt_final.grenadeAmmo = 1;
	
	wait(2); //this wait is here so you can get away, in case you quick kill kratt
	ori = getent("kratt_exploder_origin", "targetname");
	physicsexplosionsphere(ori.origin, 200, 100, 5);
	ori radiusdamage(ori.origin, 200, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 200, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 200, 200,100);
	wait(0.1);
	ori radiusdamage(ori.origin, 200, 200,100);
	level.control_door = 1;
}

//kratt_exploder_trigger()
//{
//	trigger = getent("kratt_exploder_trigger", "targetname");
//	ori = getent("kratt_exploder_origin", "targetname");
//	while(1)
//	{
//		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
//		if(attacker == level.player)
//		{
//			ori radiusdamage(ori.origin, 60, 200,100);
//			wait(0.1);
//			ori radiusdamage(ori.origin, 60, 200,100);
//			wait(0.1);
//			ori radiusdamage(ori.origin, 60, 200,100);
//			level.control_door = 1;
//			break;
//		}
//		wait(0.1);
//	}
//}

//makes kratt throw grenades
//also makes kratt go hide within the cage if the player walks too far away.
kratt_final_attack()
{
	level endon("too_close");
	thread kratt_final_attack_turret();

	//setting the dvars for grenade tossing!
	//setsaveddvar("ai_stationaryDist", 400); //Distance required to move from current position to not be considered stationary (in feet). Default is 10 feet.
	//setsaveddvar("ai_stationaryTime", 2); //Time that a target has to be stationary before a grenade can be thrown (in seconds). Default is 5 seconds.
	//setsaveddvar("ai_teamGrenadeInterval", 3); //How often a grenade can be throw by anyone (in seconds). Default is 40 seconds.
	
	attk = getent("fight_area_trigger1", "targetname");
	node1 = getnode("kratt_final_pos1", "targetname");
	node2 = getnode("kratt_final_pos2", "targetname");
	level.kratt_fight_var =1;
	//level thread roof_fog_fxx();
	level.kratt_final endon("death");
	while(1)
	{
		if(level.player istouching(attk))
		{
			// make him throw grenades if the player is far away
			level.kratt_final setgoalnode(node1, 1);
			level.kratt_final waittill("goal");
			//level.kratt_final.grenadeWeapon = "flash_grenade";
			//level.kratt_final.grenadeAmmo = 1;
			//level.kratt_final cmdthrowgrenadeatentity(level.player, false, 5, 1);
			////level.kratt_final magicgrenade(level.kratt_final.origin, level.player.origin, 2);
			//wait(3);
			//level.kratt_final.grenadeWeapon = "concussion_grenade";
			//level.kratt_final.grenadeAmmo = 1;
			//level.kratt_final cmdthrowgrenadeatentity(level.player, false, 5, 1);
			////level.kratt_final magicgrenade(level.kratt_final.origin, level.player.origin, 2);
			//wait(3);
		}
		else
		{
			level.kratt_final setgoalnode(node2);
			level.kratt_final waittill("goal");
		}
		wait(1);
	}
}
kratt_final_attack_turret()
{
	while(1)
	{
		if(!isdefined(level.krat_final))
			break;

		// if the player gets too close then we own him!
		if(distance(level.player.origin, level.kratt_final.origin) < 750)
		{
			level notify("too_close");
			level.kratt_final stopallcmds();
			level.kratt_final setcombatrole("turret");
			level.kratt_final cmdshootatentity(level.player, false, -1, 10000); // shoot and don't miss

			break;
		}

		wait(0.05);
	}
}

spotlight3_logic()
{
	//container_ori = getent("container_ori", "targetname");
	attk = getent("fight_area_trigger1", "targetname");
	dyn_light = getent("spotlight_light_three", "targetname");
	light_origin = getent("spotlight3_script_origin", "targetname");
	spotlight = getent("spotlight_three", "targetname");
	spotlight_arm = getent("spotlight_three_arm", "targetname");
	//spotlight_arm linkto(spotlight);
	spotlight_tag = Spawn("script_model", light_origin.origin + (0, 0, 0));
	spotlight_tag SetModel("tag_origin");
	spotlight_tag.angles = light_origin.angles;
	spotlight_tag LinkTo(light_origin);
	PlayFxOnTag(level._effect["vol_light03"], spotlight_tag, "tag_origin");
	dyn_light linkLightToEntity(light_origin);
	dyn_light.origin = (0,0,0);
	dyn_light.angles = (0,0,0);
	if(!level.ps3 && !level.bx) //GEBE
	{
		dyn_light setlightintensity (4);
	}
	z = randomintrange(1,2);
	level endon("spot_op_three_dead");
	while(1)
	{
		if(level.player istouching(attk))
		{
			ply = level.player.origin - spotlight.origin;
			ply2 = spotlight.origin - level.player.origin;
			angles1 = VectorToAngles(ply);
			//angles2 = (angles1[1] angles1[0] angles1[2]);
	
			spotlight rotateto(( 0, angles1[1] +90, angles1[0]), 		1, 0.2, 0.1);	
			spotlight_arm rotateto(( 0, angles1[1] +90 , 0), 				1, 0.2, 0.1);	
			light_origin rotateto(VectorToAngles(ply)+( 0 , 0, 0), 	1, 0.2, 0.1);	
			
			spotlight waittill("rotatedone");
		}
		else if(level.kratt_fight_var== 1)
		{
			spotlight_tag delete();
			dyn_light setlightintensity (0);
			break;
		}
		wait(0.02);
	}
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Cargo Crash||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Cargo Crash||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Cargo Crash||||||||||||||||||||||||||||||

//having issues with the original trigger
//switched it out to a new trigger 
control_shoot_doorT1()   //awareness object no more!
{
	trigger = getent("crane_damage_trigger", "targetname");
	//trigger = getent("control_shoot_doorT1", "targetname");
	trigger waittill("damage");
	playfx (level._effect["bullets"], trigger.origin);
	wait(0.1);
	playfx (level._effect["bullets"], trigger.origin);
	level.control_door =1;
	//level.player playsound("BRG_Control_door_dmg");
}



//linking the doors of the container to the contianer itself.
cargo_door_setup()
{
	cargo = getent("crane_cargo", "targetname");
	door1 = getent("cargo_container_door1", "targetname");
	door2 = getent("cargo_container_door2", "targetname");
	door1 linkto(cargo);
	door2 linkto(cargo);
}

//this used to launch the cargo and its doors into physics
//now the cargo is a script brushmodel, so it is using the old
//rotatepitch, ect..
crane_cargo()
{
	
	ori1 = getent("crane_death_ori1", "targetname");
	ori2 = getent("crane_death_ori2", "targetname");
	//cargo = getent("crane_cargo", "targetname");
	while(1)
	{
		if(level.control_door == 1)
		{
			//iprintlnbold("xx");
			level thread last_objective_title_advance();
			level notify("cargo_drop_container_start");
			level notify("cargo_drop_inards_start");
			level notify("cargo_drop_fence_start");
			cargo_colL = getent("container_collisionL", "targetname"); //since the container is a fx prefab, must give it collision when it comes down
			cargo_colR = getent("container_collisionR", "targetname");
			cargo_colC = getent("container_collisionC", "targetname");
			cargo_colL movez(-3000, 0.1);
			cargo_colR movez(-3000, 0.1);
			cargo_colC movez(-3000, 0.1);
			//cargo rotatepitch(-10, 0.3, 0.1, 0.1);
			//cargo movex(-80, 2, 1.5, 0.3);
			//cargo waittill("movedone");
			//cargo movez(-97, 1, 0.1, 0.1);
			ori1 thread damage_under_container();
			ori1 playsound("BRG_cargo_crash_01");
			level thread kratt_tanks_final();
			//save_trigger waittill("trigger");
			//level thread maps\_autosave::autosave_now("barge"); // commented out so we don't save right when the cargo thing falls

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
			//iprintlnbold("yaw");
			//cargo rotateyaw(-45, 1);
			//dynEnt_RemoveConstraint("crane_cargo", "cable1_constraint");
		}
		else if(level.control_door == 3)
		{
			//cargo rotatepitch(-45, 1);
			//dynEnt_StartPhysics("container_door1");
			//dynEnt_StartPhysics("container_door2");
			//dynEnt_StartPhysics("crane_cargo");
			//level thread grav_dir();
		}
	wait(1);
	}
	
	wait(11);
	//dynEnt_StopPhysics("crane_cargo"); 
	//dynEnt_StopPhysics("container_door1"); 
	//dynEnt_StopPhysics("container_door2"); 
}

last_objective_title_advance()
{
	ship_front = getent("front_of_shipT", "targetname");
	save_trigger = getent("after_cargo_drop_saveT", "targetname");
	save_trigger waittill("trigger");
	ship_front waittill("trigger");
	objective_state(9, "done");
	obj_ori = getent("cargo_crash_player_ori", "targetname");
	objective_add(14, "active", &"BARGE_OPEN_CARGO_DOORS", (obj_ori.origin), &"BARGE_INTO_THE_BARGE_INFO" );
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
	//ori radiusdamage(ori.origin, 150, 200,100);
	wait(3);
	//iprintlnbold("kratt:" + level.kratt_final.health);
	if(isdefined(level.kratt_final))
	{
		// kill kratt
		radiusdamage(level.kratt_final.origin, 200, 200, 100); 
	}
	ori radiusdamage(ori.origin, 200, 200,100);
	//iprintlnbold("kratt:" + level.kratt_final.health);
}


kratt_cage_door_open()
{
	//door = getent("kratt_cage_door", "targetname");
	//door rotateyaw(-215, 0.1);
}

damage_under_container()
{
	wait(1.8);
	radiusdamage(self.origin, 150, 200,100);
	level thread kratt_cage_door_open();
}


//will be working on this tomorrow
objective_eight_criteria()
{
	objective_state(8, "done");  //checked
	//wait(4);
	obj_ori = getent("cargo_crash_player_ori", "targetname");
	objective_add(9, "active", &"BARGE_INTO_THE_BARGE", (obj_ori.origin), &"BARGE_INTO_THE_BARGE_INFO" );
}

//when the cargo was a dynbrush, there are four origins
//placed around it that would change gravity on the object to
//emulate the cargo swaying at different damage states
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
			//dynEnt_AddForce( "crane_cargo", (0, 1170, 1170) );
			//dynEnt_ChangeGravityDir("container_door1", front.origin);
			//dynEnt_ChangeGravityDir("container_door2", left.origin);
			wait(8);
			//dynEnt_AddForce( "crane_cargo", (0, -1170, -1170) );
			//dynEnt_ChangeGravityDir("container_door1", right.origin);
			//dynEnt_ChangeGravityDir("container_door2", back.origin);	
		}
		else if(level.control_door == 1)
		{
			//dynEnt_ChangeGravityDir("container_door1", left.origin);
			//dynEnt_ChangeGravityDir("container_door2", right.origin);
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
			//just in case we need to restore balance to the barge
		//level thread stop_super_tilt();
}
	
puzzle_room_mapT()
{
	upper_level = getent("puzzle_room_mapT", "targetname");
	//level endon("cargo_crashing");
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
	
	//skylight = getent("skylight", "targetname");
//	door1 = getent("cargo_container_door1", "targetname");
	//door2 = getent("cargo_container_door2", "targetname");
	glasses = getentarray("bow_window1_ori", "targetname");
	//cargo = getent("crane_cargo", "targetname");
	//cargo rotatepitch(-35, 0.01);
	//cargo movex(-90, 0.1);
	//cargo waittill("movedone");
	//cargo movez(-120, 0.3, 0.1, 0.1);
	//level waittill("Barge_Bnd_Jmp_Dwn");
	//level thread bond_gets_hurt();
	maps\_utility::holster_weapons();
	wait(1.4);
	//skylight delete();

	
	level notify("cargo_drop_glass_start");
	level notify("cargo_drop_inards_slip_start");
	//wait(1);
	
	level notify("cargo_drop_container_slip_start");
  level notify("cargo_drop_fence_slip_start");
  wait(1);
  for (i = 0; i < glasses.size; i++) 
	{
		playfx (level._effect["bow_glass"], glasses[i].origin);
		wait(0.1);
	}

//	door1 unlink();
//	door2 unlink();
	//door1 rotatepitch(-10, 1);
	//door2 rotatepitch(-10, 1);
	//door1 rotateyaw(-121, 2, 0.3, 0.3);
	//door2 rotateyaw(-110, 2, 0.3, 0.3);
	//level thread cargo_debris_util();
//	door1 physicslaunch(door1.origin, vector_multiply( vector_random(4, 2, 2), 50 ));
	//door2 physicslaunch(door2.origin, vector_multiply( vector_random(4, 2, 2), 50 ));
	
	//prefabs/barge/fx_anim_entities.map
	
	//wait(1);
	level thread super_tilt();
	
	ori1 = getent("bow_water_splash1", "targetname");
	ori2 = getent("bow_water_splash2", "targetname");
	wait(1);
	earthquake(1.5, 0.8, level.player.origin, 100);
	//playfx (level._effect["water_spray1"], ori1.origin);
	wait(0.3);
	//ori1 playsound("BRG_tilt_wrong");
	//playfx (level._effect["water_spray2"], ori2.origin);
	wait(0.7);
	//playfx (level._effect["water_gush1"], ori1.origin);
	//playfx (level._effect["water_gush2"], ori2.origin);
	level thread room_flood();
	wait(3);
	//playfx (level._effect["water_gush3"], ori1.origin);
}

cargo_debris_util()
{
//	ori1 = getent("bow_debris_spawn_ori", "targetname");
	//debris = Spawn("script_model", ori1.origin);
//	debris.angles = ori1.angles;
	//debris physicslaunch(debris.origin, vector_multiply( vector_random(4, 2, 2), 50 ));
//	debris movez(200, 1);
}
	
room_flood()
{
	water = getent("rising_water_brush", "targetname");
	//water movez(200, 100);
}
	
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Boat tilt scripts||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Boat tilt scripts||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Boat tilt scripts||||||||||||||||||||||||||||||


super_tilt()
{
	level endon("stop_super_tilt");
	//flag_waitopen("tilting"); // tilt_building already does this
	flag_set("super_tilt");
	
	//level._sea_viewbob_scale = 1.5;

	//flag_clear("_sea_viewbob");

	//iPrintLnBold("super tilting");

	while (true)
	{
		a = 0;
		b = 0;
		c = 0;
		if (RandomInt(2) % 2)
		{
			a = RandomFloatRange(3, 5);
			//a = RandomFloatRange(9, 11.5);
			if (RandomInt(2) % 2)
			{
				a *= -1;
			}
		}
		else
		{
			c = RandomFloatRange(3, 5);
			//c = RandomFloatRange(9, 11.5);
			if (RandomInt(2) % 2)
			{
				c *= -1;
			}
		}
		b = RandomFloatRange(2, 4.5);
		//b = RandomFloatRange(5, 9);
		if (RandomInt(2) % 2)
		{
			b *= -1;
		}
		
		angles = (a, b, c);
		level thread tilt_building(angles, RandomFloatRange(5, 7));
		//flag_waitopen("tilting");
		wait 1;
		level waittill("darkness");
		//level thread tilt_building(vector_multiply(angles, -1), RandomFloatRange(5, 7));
		//wait 3;
		//flag_clear("tilting");
		//flag_wait("tilting");
		//level thread stop_super_tilt();
		//wait 1;
	}
}

//boat tilt
//taken from Gettler! modified to stop mid tilt =)
tilt_building(tilt, time, tilt_back, new_angles)
{


	//level._sea_physbob_scale = 1.8;
	flag_clear( "_sea_viewbob" ); //0326
	flag_clear("_sea_physbob"); 	//0326
	flag_clear("_sea_bob");				//0326
	
	
	//flag_waitopen("super_tilt");
	flag_waitopen("tilting");
	//flag_clear("_sea_viewbob");
	
	
	flag_set("_sea_viewbob");
	flag_set("tilting");
	flag_set("_sea_physbob");		//0326
	
	//flag_set("_sea_physbob");
	//flag_set("_sea_bob");
	//level.ground = GetEnt("ground", "targetname");
	//wait .05;
	//level.player PlayerSetGroundReferenceEnt(level.ground);
	
	
	if (!IsDefined(time))
	{
		time = 3;
	}
	
	level.tilting = true;
	//old_tilt = level._sea_world_rotation; //420
	//old_tilt = tilt;
	
	//
	level._sea_world_rotation = (11, 0, 0);
	//level._sea_world_rotation = tilt;  //420
	level.ground = level.sea_world_rotation;
	
	//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
	//level thread maps\gettler_util::shake_building(time, .2);
	
	//level.ground waittill("rotatedone");
	wait time;
	
	if (IsDefined(tilt_back) && tilt_back)
	{
		//iPrintLnBold("tilting back");
		time = time / 3;
		//level._sea_world_rotation = old_tilt; //420
		//wait 2;  //0420
		//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
		//level thread maps\gettler_util::shake_building(time, .2);
	}
	else if (IsDefined(new_angles))
	{
		//iPrintLnBold("tilting to new angles");
		time = time / 3;
		//level._sea_world_rotation = level.ground; //0420
		//level._sea_world_rotation = new_angles;
		//wait 2;  //0420
		//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
		//level thread maps\gettler_util::shake_building(time, .2);
	}
	
	//flag_clear("tilting");   
	//level._sea_viewbob_scale = 0.01;
	level._sea_scale = 0.01;
	level._sea_physbob_scale = 0.5;
	flag_wait("_sea_viewbob");
	flag_wait("super_tilt");
	//flag_wait("tilting");
	//flag_wait("_sea_physbob");
	//flag_wait("_sea_bob");
}

stop_super_tilt()
{
	level notify("stop_super_tilt");
	flag_clear("super_tilt");
	//flag_clear("_sea_viewbob");
	flag_clear( "_sea_viewbob" );
	flag_clear("_sea_physbob");
	flag_clear("_sea_bob");
	level._sea_viewbob_scale = 0.2;
	//iPrintLnBold("super tilting stopped");
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Level End||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Level End||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Level End||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Level End||||||||||||||||||||||||||||||||||||||||||||

//bbekian
//Bond reaches vesper 
//
bond_gets_hurt()
{
	//trigger = getent("bond_gets_clocked", "targetname");
	//trigger waittill("trigger");
	//Vvesper = getent("Vvesper", "targetname");
	maps\_utility::holster_weapons();
	//Print3d( Vvesper.origin + ( 0,0,64 ), "No!" , (0, 1, 0), 1, .4, 40) ;
	//Vvesper CmdAction( "Vesper_VesprWarn" );
	//letterbox_on();
	//VisionSetNaked( "barge_2", 4.0 );
	//wait(3);
	//visionsetnaked("barge_3", 1);
	
	//level.lechiffre waittill("finished spawning");
	
	//visionsetnaked("barge_dark", 0.01);
	
	//playcutscene("Brg_Bnd_Torture", "torture_over");
	
	//level thread change_lvl_thrd();
	//letterbox_off();
	
	//level waittill("torture_over");
	visionsetnaked("barge_dark", 1);
	setDvar( "cg_disableHudElements", 1 );
	

	
	//changelevel( "Gettler" ); 
	
	//level notify ( "second_half" );  
}

change_lvl_thrd()
{
	wait(24);
	visionsetnaked("barge_dark", 0.01);
}

barge_end()
{
	wait(20);
//	maps\_utility::unholster_weapons();
	//changelevel( "Gettler" ); 
}


pacer()
{
	//level.lechiffre pausepatrolroute();
	//level.lechiffre CmdPlayanim("Lechiffre_Lechiffpacing");
	//level.lechiffre waittill("cmd_done");
	//level.lechiffre resumepatrolroute();
}


whip_it()
{
	/*
	//level.lechiffre pausepatrolroute();
	//level.lechiffre CmdPlayanim("Lechiffre_Lechiffgesture");
	//reviveeffect(true);
	//reviveeffectcenter( 5.9, 5.5, 5.8, 5.56, 5.57, 5.69, 1.0, 1.0, 1.0 );  // contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint
	//reviveeffectedge( < blurRadius, Contrast, brightness, desaturation, LTr, LTg, LTb, DTr, Dxb
	//reviveeffectedge( 6.4, 1.4, 2.84, 0.86, 1.8, 2.0, 2.0, 0.73, 1.23); // Blur Radius, Motionblur, Contrast RGB, Brightness RGB, Desaturation, Light Tint, Dark Tint.
	reviveeffect(true);
	reviveeffectcenter(1.9, 0.5, 0.8, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97);
	//reviveeffectedge(6.4, 0.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.33, 0.23, 0.12);
	reviveeffect(true);
	reviveeffectcenter(1.9, 0.5, 0.8, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97);
	//reviveeffectedge(6.4, 0.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.33, 0.23, 0.12);
	reviveeffectcenter(1.9, 0.5, 0.8, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97);
	//reviveeffectedge(6.4, 0.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.33, 0.23, 0.12);
	//earthquake(0.5, 0.8, level.player.origin, 100);
	wait(1.75);
	
	SetDVar("r_pipMainMode", 1); 
	SetDVar("r_pip1Anchor", 8 );                                                                // use middle anchor point
	SetDVar("r_pip1Scale", "1 0.05 0 0");                 // leave a sliver to see
	wait(2);
	for( i = 0.05; i < 1; i = i + 0.04)
	{
		SetDVar("r_pip1Scale", "1 "+ i +" 0 0" );              // no scale
		wait( 0.05);
	}       
	//reset main window
	SetDVar("r_pipMainMode", 0);     //set window
	//level.lechiffre resumepatrolroute();
	reviveeffect(false);
	*/
}


//runs the isanyaidying check for autosaves
//borrowed from SCI_B ty to june.or.joe.or?
global_autosave()
{
	alldead = false;
	while( !(alldead) )
	{
		guards = getaiarray("axis", "neutral");
		if ( !(guards.size) &&  !isanyaidying("axis", "neutral") )
		{
			thread maps\_autosave::autosave_by_name("barge");
			//thread maps\_autosave::autosave_now("barge");
			alldead = true;
		}
		wait(0.5);
	}
}


//bbekian	
//disabled
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

//avulaj
//this simply saves the game state and puts out a level notify
global_checkpoint_before_big_fight()
{
	deck01_checkpoint_before_big_fight = getent ( "deck01_checkpoint_before_big_fight", "targetname" );
	deck01_checkpoint_before_big_fight waittill ( "trigger" );
	level notify ( "deck01_complete" );
	//this is temp
	//level.player SetWeaponAmmoStock( "p99", 800 );
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

/////_____________________________
/////_____________________________legacy functions that are still enabled//
/////_____________________________


//avulaj
//this controlls all the somke that get created when the player shoots a fire ext
global_fire_ext_triggers()
{
	fxsomke = loadfx ( "smoke/smoke_grenade" );
	global_fire_ext = getentarray ( "global_fire_ext", "targetname" );
	
	for (i = 0; i < global_fire_ext.size; i++  )
	{
		global_fire_ext[i] thread global_fire_ext_think( fxsomke );
	}
}

//avulaj
//this spawns the fx once the trigger has been hit
//self = global_fire_ext[1]
//fx = fxsomke from above function that is passed through
//org.target = the script origin that is linked to the trigger
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


magic_railing_hide()
{
	br_rails = getentarray("br_rail_brush", "targetname");
	br_models = getentarray("br_rail_model", "targetname");
	
	nr_rails = getentarray("nr_rail_brush", "targetname");
	nr_models = getentarray("nr_rail_model", "targetname");
	for (i = 0; i < br_rails.size; i++  )
	{
		br_rails[i] show();
	}
	for (i = 0; i < br_models.size; i++  )
	{
		br_rails[i] show();
	}
	for (i = 0; i < nr_rails.size; i++  )
	{
		nr_rails[i] hide();
	}
	for (i = 0; i < nr_models.size; i++  )
	{
		nr_models[i] hide();
	}
}

//I was going to just use a notify in the above function 
//but chose to make a separate function.
magic_railing()
{
	br_rails = getentarray("br_rail_brush", "targetname");
	br_models = getentarray("br_rail_model", "targetname");
	
	nr_rails = getentarray("nr_rail_brush", "targetname");
	nr_models = getentarray("nr_rail_model", "targetname");
	for (i = 0; i < br_rails.size; i++  )
	{
		br_rails[i] hide();
	}
	for (i = 0; i < br_models.size; i++  )
	{
		br_rails[i] hide();
	}
	for (i = 0; i < nr_rails.size; i++  )
	{
		nr_rails[i] show();
	}
	for (i = 0; i < nr_models.size; i++  )
	{
		nr_models[i] show();
	}
}









//|||||||||||||||||||||||||||||||||||||||||||||||||||||WEAPON MODS AND LAPTOPS / laptop / laptops|||||||||||||||||||||||||||||||||||||||||||||||||||||

//Laptop one allows access to the night vision scope
laptop1_event()  //----->>> awareness object laptop_use1
{
	level notify("laptop1");
	data_collection_add( 0, "text", &"BARGE_NIGHT_VISION" , &"BARGE_NIGHT_VISION_MENU");
	box_door = getent("cache_crate_lid_1", "targetname");
	box_door rotateroll(90, 1);
}

//the night vision "gift box"
night_visionT()
{
	trigger = getent("night_visionT", "targetname");
	trigger trigger_off();
	//level waittill("laptop1");
	trigger trigger_on();
	//trigger setHintString("Grab the Night Vision Scope");
	trigger waittill("trigger");
	level.night_vision = 1;
	wait(0.25);
	//iprintlnbold("You picked up a night vision scope");
	//savegame("barge");
	level thread weapon_toggle();
	wait(1);
	//iprintlnbold("Press Down on the D-Pad to activate while Scoped in");
	trigger delete();
}


//A hacked in version of the night vision toggle (only works with the default control config)
weapon_toggle()
{
	level thread night_vision_death_check();
	level thread ads_night();
	//the level.night_vision var is set when the scope is physically picked up by the player
	while(level.night_vision ==1)
	{
		if ((level.player buttonpressed("DPAD_DOWN")) && (level.attach_toggle == 0))
		{
			//iprintlnbold("on");
			level.attach_toggle = 1;
			level thread ads_night();
			wait(0.25);
			//level notify("attach_scope");
		}
		else if((level.player buttonpressed("DPAD_DOWN")) && (level.attach_toggle ==1))
		{
			//iprintlnbold("off");
			level.attach_toggle = 0;
			level thread ads_normal();
			wait(0.25);
			//level notify("un_attach_scope");
		}
		wait(0.25);
	}
}

//reseting the night vision
night_vision_death_check()
{ 
	level.player waittill("death");
	level.attach_toggle = 0;
	//iprintlnbold("you have died");
	VisionSetNaked("barge_1", 0.01);
}

ads_night()
{
	level endon("death");
	while(1)
	{
		if(!level.attach_toggle == 0)
		{
			//iPrintlnBold("hello mike 2");
		
			//if(level.player playerads() > 0.01)
			
			if( getDvar( "cg_playerWepIsZoomed" ) != "0" )
			{
				VisionSetNaked("barge_night", 0.01);
				//wait(0.1);
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
	//level endon("death");
	while(1)
	{
		if(!level.attach_toggle == 1)
		{
			if(level.player playerads() > 0.01)
			{
				VisionSetNaked("barge_1", 0.01);
				//wait(0.1);
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


//a pt ongoal call to play an anim on kratt
//when hes at the window
kratt_talk1()
{
	kratt = getent("kratt", "targetname");
	kratt SetScriptSpeed("run"); 
	//iprintlnbold("Kratt Looks at Bond");
	//kratt CmdAction( "Kratt_Barge_VesprHostage" );
}


kratt_delete1()
{
	
}



//9||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Darkened Room|||||||||||||||||||||||||||||||||||\\\\\\\\\9
//9||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Darkened Room|||||||||||||||||||||||||||||||||||\\\\\\\\\9
//9||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Darkened Room|||||||||||||||||||||||||||||||||||\\\\\\\\\9

hit_the_lights()
{
	trigger2 = getent("hit_the_lights", "targetname");
	trigger2 waittill("trigger");
	level thread kratt_vesper_end();
	//level thread darkness_shooters();
	level thread unreal_halfwayT();
	//zone1_light_brush_on();
	//zone1_light_brush_off();
	//level thread zone2_lights();
	//level thread zone3_lights();
	//level thread zone4_lights();
	//level thread zone5_lights();
}

kratt_vesper_end()
{
	maps\_utility::holster_weapons();
	trigger2 = getent("kratt_deck_runT", "targetname");  //moved the trigger back
	trigger2 waittill("trigger");
	level.kratt_hst = getent ("kratt_end_spawner", "targetname")  stalingradspawn( "kratt_end" );
	//node = getnode("kratt_death_node", "targetname");
	level.kratt_hst.health = 150;
	level.kratt_hst.tetherradius = 10;
	level.kratt_hst.accuracy = 1.0;
	level.vesper_hst = getent("vesper_torture", "targetname")  stalingradspawn( "Vvesper" );
	level.vesper_hst waittill ("finished spawning");
	level.kratt_hst cmdshootatentity(level.player, false, 5, 1);
	//level.vesper_hst linkto( level.kratt_hst, "tag_origin", ( 8, 8, 0 ), ( 0, 0, 0 ) );
	level.kratt_hst setenablesense(false);
	level.kratt_hst setenablesense(true);
	level.kratt_hst setalertstatemin("alert_red");
	trigger = getent("last_manT", "targetname");
	//trigger waittill("trigger");
	//level.kratt_hst setenablesense(true);
	//level.kratt_hst setalertstatemin("alert_red");
	//level thread kratt_vesper_blow_awayT();
	//level thread electro_himT();
	
	level thread kratt_end_death();
	//level.kratt_hst startpatrolroute("hostage_one");
	wait(1);
	//level thread light_zone_intro();
}

kratt_end_death()
{
	level.kratt_hst waittill("death");
	wait(2);
	//level thread bond_gets_hurt();
}


//if the player comes to close to kratt without sneaking behind him
//then its a mission fail
kratt_vesper_blow_awayT()
{
	trigger = getent("kratt_vesper_blow_awayT", "targetname");
	trigger waittill("trigger");
	level.kratt_hst stopcmd();
	level.kratt_hst setenablesense(true);
	
	//level.kratt_hst cmdshootatentity(level.player, false, 12, 1);
	//level.player playsound ("BRG_Vesper_scream1");
	//wait(1);
	//missionfailedwrapper();
}

//
its_over()
{
	//level.kratt_hst pausepatrolroute();
	level.kratt_hst stoppatrolroute();
	
	//level thread kratt_lights1_on();
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "Thats far enough" , (0, 1, 1), 1, 0.4, 30);
	wait(2);
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "Come Any Closer, and I'll blow her brains out" , (0, 1, 1), 1, 0.4, 30);
	wait(2);
	//level.kratt_hst CmdPlayanim("Kratt_Vesprhostage");
	//level.kratt_hst startpatrolroute("hostage_two");
	//wait(2);
	//level.kratt_hst waittill("cmd_dome");
	//level.kratt_hst resumepatrolroute();
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
	//trigger sethintstring("Press me!");
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
			//level thread zone1_lights_off();
			level.kratt_hst stopcmd();
			level.kratt_hst setenablesense(true);
			//level.player playsound ("BRG_Vesper_scream1");
			wait(2);
			//level.player playsound ("BRG_Vesper_scream1");
			missionfailedwrapper();
		}
		wait(1);
	}
}


//kratt shoots at the player when the player first enters the kratt room
//forcing cover dashes
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

//turns the 3 light zones on or off in the kratt room
//the time the lights stay on corresponds with kratt shooting at
//the player in kratt_dynamics
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
			//iprintlnbold("zone1 on");
			wait(level.z_z);
			//iprintlnbold("zone1 off");
			level thread kratt_lights1_off();
			level.kratt_light_var = 0;
		}
		else if((y > 160) && (y <=330))
		{
			level thread kratt_lights2_on();
			level.kratt_light_var = 2;
			//iprintlnbold("zone2 on");
			wait(level.z_z);
			//iprintlnbold("zone2 off");
			level thread kratt_lights2_off();
			level.kratt_light_var = 0;
		}
		else if((y > 330) && (y <=500))
		{
			level thread kratt_lights3_on();
			level.kratt_light_var = 3;
			//iprintlnbold("zone3 on");
			wait(level.z_z);
			//iprintlnbold("zone3 off");
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
			//level.kratt_hst pausepatrolroute();
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else if((level.kratt_light_var ==2) && (level.player istouching(shoot_area2)))
		{
			//level.kratt_hst pausepatrolroute();
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else if((level.kratt_light_var ==3) && (level.player istouching(shoot_area3)))
		{
			//level.kratt_hst pausepatrolroute();
			level.kratt_hst cmdshootatentity(level.player, false, level.z_z, 1);
		}
		else
		{
			level.kratt_hst stopallcmds();
			//level.kratt_hst resumepatrolroute();
		}
		wait(0.25);
	}
}
	

//ptongoal
shoot_one()
{
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "You're dead!" , (0, 1, 1), 1, 0.4, 30);
}

//ptongoal 	
shoot_two()
{
	Print3d( level.kratt_hst.origin + ( 0,0,64 ), "You think you can hide from me!" , (0, 1, 1), 1, 0.4, 30);
}

//ptongoal 	
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

//bbekian
//Initially had Kratt and Vesper donkeykonging it around but removed this.
//
kratt_deck_run()
{
	level waittill("puzzle_done");
	//vesper = getent("vesper_intro", "targetname") stalingradspawn( "vesper_x" );
	//kratt = getent ("kratt_intro", "targetname")  stalingradspawn( "kratt_x" );
	//kratt waittill ("finished spawning");
	//kratt.health = 2000;
	//vesper waittill ("finished spawning");
	//vesper.heath = 2000;
	//kratt lockalertstate( "alert_green" );
	//vesper lockalertstate( "alert_green" );nn
	//vesper = getent ("control_vesper", "targetname");
	//if (isdefined ( vesper ))
	//{
	//	vesper linkto( kratt, "tag_origin", ( 8, 8, 0 ), ( 0, 0, 0 ) );
	//}
	//trigger = getent("kratt_deck_runT", "targetname");
	//trigger2 = getent("hit_the_lights", "targetname");
	//trigger2 waittill("trigger");
	//	kratt startpatrolroute("kratt_deck_run");
	//	kratt SetScriptSpeed("jog");
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
			//guy[i].script_noteworthy = "sniper_global_shooters";
			guy[i] waittill("goal");
			guy[i] cmdshootatentity(door1, false, 1, 0.45);
		}
		wait(2);
		level thread darkness_shooters2();
		//
		level notify("darkness");
	}
}

//dark_wave1
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
					
					//guy[i].script_noteworthy = "sniper_global_shooters";
					//guy[i] waittill("goal");
					//guy[i] cmdshootatentity(door1, false, 10, 0.45);
				}
			wait(x);
			}
			break;
		}
		wait(1);
	}
}

//bbekian
//a pt_ongoal function call. This deletes kratt and vesper when they run into the corridor
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

//	red_light = getent("red_light", "targetname");
//	green_light = getent("green_light", "targetname");
//	green_light setlightintensity (2);
//	red_light setlightintensity (0);

//

unreal_halfwayT()
{
	//
}



//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Saving the last known good configuration of *vesper_*grab
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Saving the last known good configuration of *vesper_*grab
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Saving the last known good configuration of *vesper_*grab

/*
//When vespers persuants are near her they stop, grab her and attempt to take her back into the barge.
vesper_grab(guy)
{
	dialog[0] = "James, they grabbed me!";
  dialog[1] = "Get your hands off me!";
  dialog[2] = "Dont touch me you bastard!";
	trig = getent("vesper_stop1T", "targetname");
	node = getnode(trig.target, "targetname");
	self endon("death");
	while(1)
	{
		level.x1 = randomintrange(1,4);
		if((isalive(guy)) && (guy istouching(trig)) && (level.sniper_vesper istouching(trig)))
		{	
			level.sniper_vesper thread vesper_grab_anim();
			//level.sniper_vesper linkto(guy, "tag_origin", ( 30, 0, 0 ), ( 0, 0, 0 ) );
			level.vesper_grab = 1;
			missionfailedwrapper();
			//iprintlnbold(dialog [randomint(3)]);
			level.player playsound ("BRG_Vesper_scream1");
			//wait(level.x1); //the random amount of time the enemy waits to move with vesper to the goal node (emulatiing a struggle)
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

*/

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Old Globals||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Old Globals||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||Old Globals||||||||||||||||||||||||||||||||||||||||||||||


//bbekian
//awareness cams
awareness_cameras()
{
	//lower deck
	//upper deck
	pipe_mousetrap = getent("cargo_damageT", "targetname");
	//pipe_mousetrap enableAwarenessLookat( 1, 1, 1 );
}

//once we have the proper VO this will be replaced
global_vesper_screams01()
{
	global_vesper_scream01 = getent ( "global_vesper_scream01", "targetname" );
	global_vesper_scream01 waittill ( "trigger" );
	//iprintlnbold ( "Vesper screams for Bond!!!" );
  ori = getent("vesper_scream1", "targetname");
 	ori playsound ("VESP_BargG_112A");
}

//bbekian 
//changed targetnames to accomodate new geo
global_full_light_flicker()
{
	light_flicker = getentarray ( "flicker", "targetname" );
	for ( i = 0; i < light_flicker.size; i++  )
	{
		level thread global_light_flicker_think ( light_flicker[i] );
	}
}

//this function makes the lights flicker
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


barge_moth()
{
	moth_fx = getentarray ( "moth_fx", "targetname" );
	moth	= LoadFx ( "maps/barge/barge_insect_moths01" );
	
	for (i = 0; i < moth_fx.size; i++  )
	{
		fxid = playloopedfx ( moth, 2, moth_fx[i].origin );
	}
}

//avulaj
//this creates smoke for each node in this array
global_smoke_from_exhaust_ports()
{
	smoke_exhaust = getentarray ( "stern_smoke_exhaust_01", "targetname" );
	fxsmoke	= LoadFx ( "smoke/thin_light_smoke_M" );
	
	for (i = 0; i < smoke_exhaust.size; i++  )
	{
		fxid = playloopedfx ( fxsmoke, 1, smoke_exhaust[i].origin, 0, smoke_exhaust[i].angles );	
	}
}





//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||new utilities||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||new utilities||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||new utilities||||||||||||||||||||||||||||


birds_flying()
{
	//birds_ori = getentarray ( "birds_ori", "targetname" );
	//for (i = 0; i < birds_ori.size; i++  )
	//{
	//	playloopedfx (level._effect["birds5"], 12.5 , birds_ori[i].origin);
	//}
	
	birds_ori = getent( "birds_ori", "targetname" );
	playloopedfx (level._effect["birds5"], 12.5 , birds_ori.origin);
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

//mark-m fan spinning script
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
	//    0
	if ( yaw > -5 && yaw < 5 )                      
	{
			rotation = (  1,   0,   0);
	}
	//    90
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
	//    180
	else if ( yaw > 175 && yaw < 185 )
	{
		rotation = ( -1,   0,   0);
	}
	//    270
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

splash_trigger()
{
	trigger = getent("splash_trigger", "targetname");
	trigger waittill("trigger");
	VisionSetNaked( "Barge_Dark", 0.1 );
	level.player playsound("body_water_splash");
	playfx (level._effect["ocean_splash"], level.player.origin +(0, 0, -10));
}

//Vision set trigger groups, run appropriate vision sets
//for the associated areas
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
	//VisionSetNaked( "barge_1", 1 );
	//wait(0.5);
	barge_vision2_triggers();
}
vision2_set()
{
	self waittill("trigger");
	/*if(!level.ps3)
	{
		VisionSetNaked( "barge_4", 5 );
	}
	else if(level.ps3)
	{
		VisionSetNaked( "barge_4_ps3", 5 );
	}*/

	//wait(0.5);
	barge_vision_triggers();
}
vision2A_set()
{
	self waittill("trigger");
	if(!level.ps3 ) //GEBE
	{
		VisionSetNaked( "barge_2", 3 );
	}
	else if(level.ps3 || level.bx) //GEBE
	{
		VisionSetNaked( "barge_2_ps3", 12 );
	}
	wait(0.5);
	barge_vision3_triggers();
}
vision3_set()
{
	self waittill("trigger");
	//iprintlnbold("vision3");
	VisionSetNaked( "barge_3", 3 );
	wait(0.5);
	barge_vision2_triggersA();
}

ware_house_door_link()
{
	door = getent ("warehouse_door","targetname");
	knob1 = getent ("warehouse_door_knob1", "targetname");
	knob2 = getent ("warehouse_door_knob2", "targetname");
	lock1 = getent ("warehouse_door_lock1", "targetname");
	lock2 = getent ("warehouse_door_lock2", "targetname");
	knob1 linkto (door);
	knob2 linkto (door);
	lock1 linkto (door);
	lock2 linkto (door);
}

display_chyron()
{
	wait(25);
	maps\_introscreen::introscreen_chyron(&"BARGE_INTRO_01", &"BARGE_INTRO_02", &"BARGE_INTRO_03");
}

//from gettler
#using_animtree( "vehicles" );
boat_float()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	self UseAnimTree(#animtree);
	//self SetAnim( %v_boat_float, 1.0, 1.0, 1.0 );
	//self SetAnimKnob( %v_boat_float, 1.0, 1.0, 1.0 );
	self setFlaggedAnimKnobRestart( "idle", %v_boat_float );
}


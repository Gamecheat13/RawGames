#include animscripts\shared;
#include maps\_playerawareness;
#include maps\_utility;
#include maps\shantytown_util;

#using_animtree("generic_human");

main()
{
	
	setExpFog( 0, 3173, 0.678979, 0.643003,  0.604488, 2, 1);
	VisionSetNaked( "shanty_indoor", 0.5 );
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");
	maps\shantytown_fx::main();
	level.strings["Cellphone_bar_name"] = &"SHANTYTOWN_BAR_NAME";
	level.strings["Cellphone_bar_body"] = &"SHANTYTOWN_BAR_BODY";
	level.strings["Cellphone_weapon_name"] = &"SHANTYTOWN_WEAPON_NAME";
	level.strings["Cellphone_weapon_body"] = &"SHANTYTOWN_WEAPON_BODY";
	level.strings["Cellphone_dock_name"] = &"SHANTYTOWN_DOCK_NAME";
	level.strings["Cellphone_dock_body"] = &"SHANTYTOWN_DOCK_BODY";

	
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}

	maps\_vvan::main("p_msc_truck_pickup_old_shanty");
	maps\_load::main();
	maps\_playerawareness::init();
	SetSavedDVar("r_godraysPosX2",  "0.5");
	SetSavedDVar("r_godraysPosY2",  "-0.5");
	setdvar("ui_hud_showstanceicon", "0");
	setsaveddvar ( "ammocounterhide", "1" );
	
	
	oceanshader( 1 );

	
	flag_init("dock_truck_retreat");
	PrecacheCutScene("Shantytown_BomberRun");
	precacheShader( "compass_map_shantytown" );
	
	PrecacheItem("w_t_grenade_frag");
	PreCacheItem("S-CAT");
	precacherumble("damage_heavy");
	PreCacheModel("w_t_grenade_frag");

	setminimap( "compass_map_shantytown",6424, 2232, -3912, -3392 );
	precacheshellshock("default");
	precacheShellShock("death");
	
	level._effect["bulletGodRays1"] = loadfx ( "maps/casino/casino_vent_bullet_vol"); 
	level._effect["default_explosion"]  = loadfx ("props/welding_exp");
	level._effect["shanty_alley_smokecolumn"] = loadfx ("maps/shantytown/shanty_bbq");
	
	level._effect["m60_muzzle_flash"] = loadfx("weapons/mac11_discharge");
	level._effect["dust_trail"] = loadfx("dust/dust_vehicle_tires");
	level._effect["exhaust"] = loadfx("vehicles/night/vehicle_night_exhaust");
	level._effect["bird"] = loadfx("maps/Siena/siena_birds_flying1");
	level._effect["bird_1"] = loadfx("maps/Siena/siena_birds_flying4");
	
	level._effect["big_fire"] = loadfx("maps/shantytown/shanty_burning_fire");
	level._effect["medium_fire_2"] = loadfx("maps/shantytown/shanty_burning_fire");
	level._effect["car_landing_effect"] = loadfx("maps/shantytown/shanty_carbomb_crashland");
	level._effect["big_flame_wall"] = loadfx("maps/shantytown/shanty_alleyflames200slo");

	level.strings["Cellphone_bar_name"] = &"SHANTYTOWN_BAR_NAME";
	level.strings["Cellphone_bar_body"] = &"SHANTYTOWN_BAR_BODY";
	level.strings["Cellphone_weapon_name"] = &"SHANTYTOWN_WEAPON_NAME";
	level.strings["Cellphone_weapon_body"] = &"SHANTYTOWN_WEAPON_BODY";
	level.strings["Cellphone_dock_name"] = &"SHANTYTOWN_DOCK_NAME";
	level.totalhudelement = 5;
	level thread control_hud(level.totalhudelement);
	level.propane_thrown = false;

	
	thread monitor_triggers();
	thread setup_vision();
	thread setup_civilians();
	thread setup_bond();
	thread setup_bomber();
	thread setup_objectives();
	thread level_end();
	level thread shack_door_bash();
	
	level thread setup_garage_fight();


	level thread beach_fight();
	level thread spawn_warehouse_guard();
	level thread set_guard_talking();
	level thread garage_fight();
	level thread dock_fight();
	
	level thread civ_cross();
	level thread level_dialogue();
	

	
	thread maps\shantytown_snd::main();
	thread maps\shantytown_mus::main();
	
	level thread dog_barking_init();
	level thread checkpoint();
	level thread set_ocean_wave();
	level thread start_wave_sound();
	level thread birds_alley();
	level thread civ_alley_spawn();

	level thread setup_flames();
	level thread setup_flames_2();
	
	fake_car = getent("fake_car", "targetname");
	fake_car hide();
	fake_car notsolid();
	
	wait(3);
	level.car_2 = getent("m60_car_wave_2", "targetname");
	level.car_2 hide();

	level.car_3 = getent("m60_car_wave_3", "targetname");
	level.car_3 hide();

	level.player PlayRumbleOnEntity( "damage_heavy" );
}


setup_flames()
{
	origin = getent("medium_fire_propane_wave_2", "targetname");
	trigger = getent("medium_fire_trigger", "targetname");
	trigger waittill("trigger");

	playfx(level._effect["medium_fire_2"], origin.origin);
}


setup_flames_2()
{
	level waittill("board_chuck_start");

	origin_2 = getentarray("big_flame_end", "targetname");
	fx_flame = [];
	for(i = 0; i < origin_2.size; i++)
	{
		
		playloopedfx(level._effect["big_fire"], 20, origin_2[i].origin);
	}

	radiusdamage((4296, 824, 32), 30, 500, 490);
	
	trig = getent("big_flame_kills", "targetname"); 
	while ( 1 )
	{
		trig waittill( "trigger" );

		if ( level.player IsTouching(trig) )
		{
			
			level.player DoDamage( 15, level.player.origin );
		}
		wait (0.05);
	}
}

birds_alley()
{
	
}


start_wave_sound()
{
	trigger = getent("beach_trigger", "targetname");
	origin_array = getentarray("wave_sound_origin", "targetname");

	seawave = [];
	seawave[0] = "sea_wave_01";
	seawave[1] = "sea_wave_02";
	seawave[2] = "sea_wave_03";
	seawave[3] = "sea_wave_04";

	while(true)
	{
		if(level.player istouching(trigger))
		{
			for(i = 0; i < origin_array.size; i++)
			{
				origin_array[i] playsound(seawave[randomint(4)]);
			}
			wait(3);
		}
		wait(0.5);
	}
}

set_ocean_wave()
{
	wait(1);
	SetDVar("r_waterWave0Angle", 90);
	SetDVar("r_waterWave0Wavelength", 600);
	SetDVar("r_waterWave0Amplitude", 5.55);
	SetDVar("r_waterWave0Phase", 3.355);
	SetDVar("r_waterWave0Steepness", 0.97);
	SetDVar("r_waterWave0Speed", 0.75);
	SetDVar("r_waterWave1Angle", 45);
	SetDVar("r_waterWave1Wavelength", 600);
	SetDVar("r_waterWave1Amplitude", 4.875);
	SetDVar("r_waterWave1Phase", 3.253);
	SetDVar("r_waterWave1Steepness", 0.38);
	SetDVar("r_waterWave1Speed", 0.644);
	SetDVar("r_waterWave2Angle", 135);
	SetDVar("r_waterWave2Wavelength", 150);
	SetDVar("r_waterWave2Amplitude", 1.23);
	SetDVar("r_waterWave2Phase", 1.23);
	SetDVar("r_waterWave2Steepness", 0.05);
	SetDVar("r_waterWave2Speed", 0.75);
	SetDVar("r_waterWave3Angle", 270);
	SetDVar("r_waterWave3Wavelength", 900);
	SetDVar("r_waterWave3Amplitude", 4.2);
	SetDVar("r_waterWave3Phase", 0.76);
	SetDVar("r_waterWave3Steepness", 0.419);
	SetDVar("r_waterWave3Speed", 0.512);
}

Level_Dialogue()
{
	wait(7);
	level.player play_dialogue("BOMB_ShanG_003A");
	wait(2);
	level.player play_dialogue("STH1_ShanG_004A");

	trigger = getent("give_gun_bond", "targetname");
	trigger waittill("trigger");
	level.player play_dialogue("STH1_ShanG_005A", true);

	trigger = getent("dock_trigger_touch", "targetname");
	trigger waittill("trigger");

	trigger = getent("trigger_bar_run", "targetname");
	trigger waittill("trigger");

	level.player play_dialogue("BOMB_ShanG_006A");

	trigger = getent("bomber_shoot_bond_trigger", "targetname");
	trigger waittill("trigger");

	level.player play_dialogue("CART_ShanG_040A");
	level.player play_dialogue("CART_ShanG_041A");

	trigger = getent("trigger_end_fight", "targetname");
	trigger waittill("trigger");



	level.player play_dialogue("CART_ShanG_042A");
	wait(2);
	level.player play_dialogue("CART_ShanG_043A");
	wait(5);
	level.player play_dialogue("CART_ShanG_044A");

	level waittill("board_chuck_start");

	level.player play_dialogue("CART_ShanG_011A");
	level.player play_dialogue("BOND_ShanG_004A");
	level.player play_dialogue("CART_ShanG_013A");
}

Timer_update()
{
	level.chase_timer = 0;
	level.exceed = 60;
	while(level.chase_timer < level.exceed)
	{
		wait(1);
		level.chase_timer += 1;


		if(level.exceed / level.chase_timer == 3)
		{
			level.player play_dialogue_nowait("CART_ShanG_014A");
		}
		else if(level.exceed / level.chase_timer == 2)
		{
			level.player play_dialogue_nowait("CART_ShanG_015A");
		}
	}

	
	
	level waittill("timer_ended");
	level.bomber stopallcmds();
	bomber_resume();

	switch(randomint(10))
	{
	case 0:
		level.player play_dialogue_nowait("CART_ShanG_029A");
		break;
	case 1:
		level.player play_dialogue_nowait("CART_ShanG_030A");
		break;
	case 2:
		level.player play_dialogue_nowait("CART_ShanG_031A");
		break;
	case 3:
		level.player play_dialogue_nowait("CART_ShanG_033A");
		break;
	case 4:
		level.player play_dialogue_nowait("CART_ShanG_034A");
		break;
	case 5:
		level.player play_dialogue_nowait("CART_ShanG_035A");
		break;
	case 6:
		level.player play_dialogue_nowait("CART_ShanG_036A");
		break;
	case 7:
		level.player play_dialogue_nowait("M_ShanG_037A");
		break;
	case 8:
		level.player play_dialogue_nowait("M_ShanG_038A");
		break;
	case 9:
		level.player play_dialogue_nowait("M_ShanG_039A");
		break;
	}

	if(getdvar("timer_off") == "1")
	{
		return;
	}

	level.chase_timer = 0;
	missionfailed();
}

civ_cross()
{
	civ = [];
	civ = getentarray("civ_cross",  "targetname");
	civilians = [];
	wait(0.1);
	for(i = 0; i < civ.size; i++)
	{
		civilians[i] = civ[i] stalingradspawn();
		civilians[i] SetEnableSense(0);
		civilians[i] LockAlertState("alert_red");
		civilians[i] setscriptspeed("sprint");
		civilians[i] setoverridespeed(20);
		civilians[i] setignorethreat( level.player, true);
		civilians[i] animscripts\shared::placeWeaponOn( civilians[i].weapon, "none" );
	}

	node = getnode("carter_pool_node", "targetname");
	level.carter_pool = getent("carter_pool", "targetname");
	level.carter_pool LockAlertState("alert_red");
	level.carter_pool thread magic_bullet_shield();
	level.bar_thug_4 setignorethreat( level.carter_pool, true);
	level.bar_thug_3 setignorethreat( level.carter_pool, true);
	level.carter_pool SetEnableSense(0);
	level.trigger_is_hit = 0;
	level.carter_anim = level.carter_pool cmdplayanim("Carter_Pain_Loop", false);
	level.carter_pool_anim_2 = level.carter_pool cmdplayanim("Carter_Pain_to_Alert", false);

	trigger = getent("give_gun_bond", "targetname");
	trigger waittill("trigger");

	
	level.chase_timer = 0;
	level.exceed = 99;
	setdvar("ui_hud_showstanceicon", "1");
	setsaveddvar ( "ammocounterhide", "0" );
	level.trigger_is_hit = 1;
}

carter_on_ground()
{
	while(level.trigger_is_hit == 0)
	{
		level.carter_pool cmdplayanim("Carter_Pain_Loop", true);
		wait(0.03);
	}
}

moving_crane()
{	
	crane = [];
	crane = getentarray("crane_movable", "targetname");
	while(true)
	{
		for(i = 0; i < crane.size; i++)
		{
			crane[i] rotateto((0, 40, 0), 30);
		}
		wait(30);
		for(i = 0; i < crane.size; i++)
		{
			crane[i] rotateto((0, 0, 0), 30);
		}
		wait(30);
	}
}

set_guard_talking()
{
	level endon("bond_have_gun");

	level.bar_thug_3 = spawn_enemy(GetEnt("bar_thug_3","targetname"));
	level.bar_thug_4 = spawn_enemy(GetEnt("bar_thug_4","targetname"));

	node_1 = getnode("bar_retreat_1", "targetname");
	node_2 = getnode("cover_2", "targetname");
	level.bar_thug_4 lockalertstate("alert_red");
	level.bar_thug_4 setenablesense(false);
	level.bar_thug_3 setscriptspeed("run");
	level.bar_thug_3 setgoalnode(node_1, 1);
}

floor_setup()
{
	trigger = getent("floor_trap_trigger", "targetname");
	trigger waittill("trigger");

	floor = getent("top_floor_drop", "targetname");
	floor delete();
	trigger PlaySound("SHA_roof_collapse");

	earthquake(0.3, 3, level.player.origin, 150);
	level.player shellshock("default", 1);
}

setup_camera()
{
	level.player freezecontrols(true);

	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
	}

	bomber_spawner = GetEnt("bomber_spawner","targetname");
	
	level.bomber = bomber_spawner stalingradspawn();
	
	level.player customcamera_checkcollisions( 0 );
	
	level thread fade_out_black(6, false);
	wait(1);
	level.hud_black.alpha = 0;
	level.cameraID = level.player customCamera_Push( "world", ( -850.27, 450.10, -31.18 ), ( 4.92, -44.34, 0), 0.0);
	level.bomber setquickkillenable(false);
	level.bomber.targetname = "bomber";
	level.bomber.animname = "bomber";
	
	level notify( "playmusicpackage_action" );
	playcutscene("Shantytown_BomberRun","Shantytown_BomberRun_Done");
	wait(1.0);
	level.hud_black.alpha = 0;
	setSavedDvar( "cg_disableBackButton", "1" );
	
	
	level.bomber SetEnableSense(false);
	level.bomber.goalradius = 15;
	level.bomber SetEnableSense(false);
	level.bomber LockAlertState("alert_red");
	level.bomber setoverridespeed(28);
	level.bomber.script_radius = 28;
	level.bomber thread bomber_fail_on_death();
	wait(0.05);

	maps\_utility::letterbox_on(false);

	wait(2);
	level thread maps\_introscreen::introscreen_chyron(&"SHANTYTOWN_INTRO_01", &"SHANTYTOWN_INTRO_02", &"SHANTYTOWN_INTRO_03"); 
	level.player customCamera_pop( level.cameraID, 4 );
	wait(2);
	maps\_utility::letterbox_off();
	level.player freezecontrols(false);
	bird_origin_1 = getent("bird_origin_1", "targetname");
	playfx( level._effect["bird"], bird_origin_1.origin );
	level.player giveweapon( "p99" );
	level.player disableweapons();
	maps\_utility::holster_weapons();
	
	level.carter_pool stopcmd(level.carter_anim);
	level.carter_pool stopcmd(level.carter_pool_anim_2);
	level.carter_anim = level.carter_pool cmdplayanim("Carter_Pain_Loop", false);
	level.carter_pool_anim_2 = level.carter_pool cmdplayanim("Carter_Pain_to_Alert", false);

	setSavedDvar( "cg_disableBackButton", "0" );
	level.player customcamera_checkcollisions( 1 );
	setSavedDvar("cg_drawHUD","1");
	bomber_start("bomber_path_start");

	wait(4);
	level thread Timer_update();
	level notify("spawn_complete");
}

boat_blows_up()
{
	boat_1 = getent("boat_1", "targetname");
	trigger = getent("boat_trigger", "targetname");
	trigger enablelinkto();
	trigger linkto(boat_1);
	trigger waittill("trigger");
	playfx( level._effect["default_explosion"], boat_1.origin );
}

amb_boat_init()
{
	boat_1 = getent("boat_1", "targetname");
	origin_1 = getent("boat_dest_1", "targetname");
	origin_2 = getent("boat_dest_2", "targetname");
	level thread amb_boat(boat_1, origin_1, origin_2);
	boat_1 = getent("boat_2", "targetname");
	origin_1 = getent("boat_dest_3", "targetname");
	origin_2 = getent("boat_dest_4", "targetname");
	level thread amb_boat(boat_1, origin_1, origin_2);
	boat_1 = getent("boat_3", "targetname");
	origin_1 = getent("boat_dest_5", "targetname");
	origin_2 = getent("boat_dest_6", "targetname");
	level thread amb_boat(boat_1, origin_1, origin_2);
}

amb_boat(boat_1, origin_1, origin_2)
{
	goal = 2;
	on_route = 0; 
	timer = 0;

	while(true)
	{
		timer += 50;
		wait(0.05);
		if(on_route == 0)
		{
			if(timer < 15000)
				continue;
			else
			{
				timer = 0;
				on_route = 1;
				if(goal == 1)
					goal = 2;
				else
					goal = 1;
			}
		}
		if(goal == 2)
		{
			boat_1 rotateto(origin_2.Angles, 0.05);
			boat_1 moveto(origin_2.origin, 15, 3, 5); 
			on_route = 0;


		}
		if(goal == 1)
		{
			boat_1 rotateto(origin_1.Angles, 0.05);
			boat_1 moveto(origin_1.origin, 15, 3, 5); 
			on_route = 0;
		}
	}
}

switch_with_carter()
{
	level endon("board_chuck_start");
	
	trigger_top = getent("carter_switch_to_top", "targetname");
	trigger_ground = getent("carter_switch_to_ground", "targetname");
	tether_origin_ground = getent("carter_tether_ground", "targetname");
	tether_origin_sky = getent("carter_tether_sky", "targetname");
	node_top = getnode("carter_cover_1", "targetname");
	node_bottom = getnode("carter_cover_2" ,"targetname");
	level.carter.tetherradius = 275;
	carter_position = 1;

	while(true)
	{
		trigger_top waittill("trigger");
		level.carter.tetherpt = tether_origin_sky.origin;
		level.carter stopallcmds();
		level.carter setgoalnode(node_top);
		trigger_ground waittill("trigger");
		level.carter.tetherpt = tether_origin_ground.origin;
		level.carter stopallcmds();
		level.carter setgoalnode(node_bottom);
		wait(1);
	}
}

setup_garage_fight()
{
	trigger = getent("kick_out_cargo_door", "targetname");
	trigger waittill("trigger");
	lrg_propane_tank = getent("large_propane_1", "script_noteworthy");
	lrg_propane_tank.health = 250000; 
	level.end_debris = getent("show_debris_explosion", "targetname");
	level.end_debris hide();
	carter_spawn = getent("carter_spawn", "targetname");
	level.carter = carter_spawn stalingradspawn();
	level.carter thread magic_bullet_shield();
	level.carter SetPainEnable(false);
	level.carter setscriptspeed("run");
	level.carter setenablesense(false);

	wait(0.5);

	node_start = getnode("carter_cover_1", "targetname");
	level.carter setgoalnode(node_start);
}

knock_woman()
{
	level.knock_over = false;
	woman = spawn_enemy(GetEnt("snake_kills_women","targetname"));

	while(!level.knock_over)
	{
		wait(0.05);
	}

	woman dodamage(500, (0,0,0));
}

give_bond_gun()
{
	level.player enableweapons();
	
	level.player giveweapon( "p99" );
	level.player switchtoweapon( "p99");
	maps\_utility::unholster_weapons();
	
	node_cover_1 = getnode("cover_1", "targetname");
	node_Cover_2 = getnode("cover_2", "targetname");

	magic_origin = [];
	magic_origin = getentarray("magic_bullet_area", "targetname");
	origin = getent("magic_bullet_origin", "targetname");
	for(i = 0 ; i < magic_origin.size; i++)
	{
		level thread fire_magic_bullet_area(origin.origin, magic_origin[i].origin, 3);
	}

	level.bar_thug_3 lockalertstate("alert_red");
	level.bar_thug_3 setenablesense(true);
	level.bar_thug_4 setenablesense(true);
	level.bar_thug_4 lockalertstate("alert_red");
	level.bar_thug_4 cmdshootatentity(level.player, true, 5, 0);

	wait(2);
	if(isdefined(level.bar_thug_4))
	{
		level.bar_thug_4 stopallcmds();
		level.bar_thug_4 setenablesense(true);
		level.bar_thug_4 setgoalnode(node_Cover_2, 1);
	}
}

setup_objectives()
{

	trigger = GetEnt("beach_guard_retreat_trigger","targetname");
	objective_add( 1, "current", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_1");

	trigger waittill("trigger");
	objective_state(1, "done" );
	
	trigger = GetEnt("bomber_shoot_bond_trigger","targetname");
	objective_add( 2, "current", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_2");
	
	trigger waittill("trigger");

	objective_state(2, "done" );
	trigger = GetEnt("trigger_end_fight","targetname");
	objective_add( 3, "current", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_3");

	trigger waittill("trigger");
	objective_state(3, "done" );
	objective_add( 4, "current", &"SHANTYTOWN_OBJECTIVE_PROTECT_CARTER_NAME", level.carter.origin, &"SHANTYTOWN_OBJECTIVE_PROTECT_CARTER_BODY");
}

setup_vision()
{
	
	trigger = [];
	trigger = getentarray("indoor_trigger", "targetname");
	beach = getent("beach_trigger", "targetname");
	indoor = 1;
	while(true)
	{
		for(i = 0; i < trigger.size; i++)
		{
			if(level.player istouching(trigger[i]))
			{
				indoor = 1;
				break;
			}
			else
			{
				indoor = 0;
			}
		}
		if(level.player istouching(beach))
		{
			indoor = 2;
		}

		if(indoor == 1)
		{
			VisionSetNaked( "shanty_indoor", 1 );
		}
		else if(indoor == 0)
		{
			VisionSetNaked( "shantytown", 1 );
		}
		else if(indoor == 2)
		{
			VisionSetNaked( "shantytown_beach", 1 );

		}

		wait(1);
	}
}

setup_civilians()
{
	
	level.goal_1_reached = false;
	level.goal_2_reached = false;
	level.goal_3_reached = false;
	level.goal_4_reached = false;
	level.goal_5_reached = false;
	level.goal_6_reached = false;
	level.goal_7_reached = false;
	
	level thread flood_spawn_civ("civ_male_pool","civ_1_goal", level.goal_1_reached);
}

setup_bond()
{
	level.player takeallweapons();
	level.player thread player_death_vo();
	level.player allowProne( false );
	SetSavedDVar( "r_godraysposx2", "-0.5");
	setsaveddvar( "r_godraysposx2", "-0.923329");
	
	while(!isdefined(level.bomber))
	{
		wait(0.01);
	}

	SetSavedDVar("ik_bob_pelvis_scale_1st","1.5");
	trigger = getent("exit_building", "targetname");
	
	trigger wait_for_trigger_or_timeout(11); 
	bird_origin_1 = getent("bird_origin_1", "targetname");
	bird_origin_2 = getent("bird_origin_2", "targetname");
	playfx( level._effect["bird"], bird_origin_1.origin );
	wait(0.5);
	playfx( level._effect["bird"], bird_origin_2.origin );
	node_goal = getnode("guard_cafe_goal", "targetname");
	level.bar_thug_4 setgoalnode(node_goal);
	
	carter_node = getnode("carter_pool_node", "targetname");
	trigger = getent("carter_get_up", "targetname");
	trigger waittill("trigger");
	level.carter_pool stopcmd(level.carter_anim);
	wait(1);
	level.carter_pool setscriptspeed("sprint");
	level.carter_pool setgoalnode(carter_node);
	level.player play_dialogue("CART_ShanG_001A", true);
	level.player play_dialogue_nowait("BOND_ShanG_002A", true);
	level.bar_thug_3 setscriptspeed("run");
	cover_node = getnode("kick_over", "targetname");
	
	trigger = GetEnt("give_gun_bond","targetname");
	trigger waittill("trigger");
	level thread give_bond_gun();
	level notify("bond_have_gun");

	
	SetSavedDVar("ik_bob_pelvis_scale_1st","0");

	level.bomber stopallcmds(); 
	bomber_resume();
	level.bar_thug_3 stopallcmds();
	level.bar_thug_3 setenablesense(false);
	level.bar_thug_3 setgoalnode(cover_node, 1);

	trigger = getent("fire_on_bond", "targetname");
	trigger waittill("trigger");
	SetDVar("sm_SunSampleSizeNear", "0.38");

	level.goal_1_reached = true;
	spawner = [];
	level.retreating_guard = [];
	spawn_1 = getent("bar_guard_retreat_1", "targetname");
	spawn_2 = getent("bar_guard_retreat_2", "targetname");
	spawn_3 = getent("bar_guard_retreat_3", "targetname");

	
	level.retreating_guard[0] = spawn_1 stalingradspawn();
	level.retreating_guard[1] = spawn_2 stalingradspawn();
	level.retreating_guard[2] = spawn_3 stalingradspawn();
	level.retreating_guard[2] allowedstances("stand");

	origin = getent("fire_at_origin", "targetname");
	remove_dead_from_array( level.retreating_guard );
	for(i = 0; i < level.retreating_guard.size; i++)
	{
		level.retreating_guard[i] setenablesense(false);
	}

	x = 0;
	z = 0;
	level.player enableHealthShield(false);
}

setup_bomber()
{
	while(!isdefined(level.bomber))
	{
		wait(0.01);
	}
	wait(3);
	
	switch( getdvar( "skipto") )
	{
	case "container":
	case "Container":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_container","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_container_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		
		bomber_start("bomber_container_start");
		break;

	case "gauntlet":
	case "Gauntlet":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_gauntlet","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_gauntlet_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		
		bomber_start("bomber_gauntlet_start");
		break;

	case "pool":
	case "Pool":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_pool","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_pool_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		
		bomber_start("bomber_pool_start");
		break;

	case "garage":
	case "Garage":
		
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_garage","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_garage_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		level notify("thug_backup");

		
		bomber_start("bomber_garage_start");
		break;

	default:
		break;
	}
}



bomber_fail_on_death()
{
	self waittill("death");
	
	level.chase_timer = 0;
	level.player thread mission_fail_vo() ;
	
}

bomber_shoot_bond(origin)
{
	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
	trigger = getent("bomber_shoot_bond_trigger", "targetname");
	trigger waittill("trigger");
	level.bomber stopallcmds();
	SetSavedDVar("r_godraysPosX2",  "-0.5");
	SetSavedDVar("r_godraysPosY2",  "-3.5");
	SetDVar("sm_SunSampleSizeNear", "0.38");
	bomber_resume();
	wait(1);
	level thread maps\_autosave::autosave_now("shanty_town");
	
	level.chase_timer = 0;
	level.exceed = 60;
}

chase_shoot_bar(origin)
{
	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
}

chase_finish_bar(origin)
{
	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
	trigger = getent("dock_trigger_touch", "targetname");
	trigger waittill("trigger");

	trigger = GetEnt("trigger_bar_run","targetname");
	trigger waittill("trigger");

	level.bomber stopallcmds();
	bomber_resume();

	
	level.chase_timer = 0;
	level.exceed = 99;
}


beach_fight()
{
	trigger = GetEnt("dock_trigger","targetname");
	trigger waittill("trigger");
	level.bomber thread magic_bullet_Shield(); 
	SetDVar("sm_SunSampleSizeNear", "0.38");
	

	level thread dock_guard_moving();

	remove_dead_from_array( level.retreating_guard );
	node_1 = getnode("retreat_1", "targetname");
	node_2 = getnode("retreat_2", "targetname");
	node_3 = getnode("retreat_3", "targetname");

	origin_target_1 = getnode("bar_door_left", "targetname");
	origin_target_2 = getnode("bar_door_right", "targetname");
	
	if(isdefined(level.retreating_guard[0]))
	{
		level.retreating_guard[0] setgoalnode(origin_target_1 , 1);
		level.retreating_guard[0] setenablesense(true);
		
	}
	if(isdefined(level.retreating_guard[1]))
	{
		level.retreating_guard[1] setgoalnode(origin_target_2 , 1);
		level.retreating_guard[1] setenablesense(true);
		
	}

	if(isdefined(level.retreating_guard[2]))
	{
		level.retreating_guard[2] setgoalnode(node_2, 1);
		level.retreating_guard[2] setenablesense(true);
		level.retreating_guard[2] set_turret_goal("turret");
		wait(2);
		level.retreating_guard[2] stopallcmds();
		level.retreating_guard[2] cmdshootatentity(level.player, true, -1, 0.5, true);
	}

	wait(2);
	
	if(isdefined(level.retreating_guard[0]))
	{
		level.retreating_guard[0] setgoalnode(node_1, 1);
	}
	if(isdefined(level.retreating_guard[1]))
	{
		level.retreating_guard[1] setgoalnode(node_3, 1);
	}

	if(isdefined(level.retreating_guard[2]))
	{
		level.retreating_guard[2] stopallcmds();
		level.retreating_guard[2] cmdshootatentity(level.player, true, -1, 0.5, true);
	}

	

	node_1 = getnode("beach_guard_go_1", "targetname");
	node_2 = getnode("beach_guard_go_2", "targetname");
	beach_spawner_1 = getent("beach_spawn_1", "targetname");
	beach_spawner_2 = getent("beach_spawn_2", "targetname");
	level.beach_guard = [];
	level.beach_guard[0] = beach_spawner_1 stalingradspawn();
	level.beach_guard[0] setgoalnode(node_1, 1);
	level.beach_guard[0] turn_off_psense(2);
	level.beach_guard[1] = beach_spawner_2 stalingradspawn();
	level.beach_guard[1] setgoalnode(node_2, 1);
	level.beach_guard[1] turn_off_psense(2);

	if(isdefined(level.retreating_guard[2]))
	{
		level.retreating_guard[2] stopallcmds();
		level.retreating_guard[2] setcombatrole("rusher");
	}

	wait(5);
	delete_node = getnode("delete_beach_guard", "targetname");
	trigger = getent("beach_guard_retreat_trigger", "targetname");


	while(true)
	{
		remove_dead_from_array( level.retreating_guard );
		remove_dead_from_array( level.beach_guard );
		count = 0;
		for(i = 0; i < level.retreating_guard.size; i++)
		{	
			if(isalive(level.retreating_guard[i]))
			{
				count += 1;
			}
		}

		for(i = 0; i < level.beach_guard.size; i++)
		{	
			if(isalive(level.beach_guard[i]))
			{
				count += 1;
			}
		}

		if(count < 3)
		{
			break;
		}

		wait(0.05);
	}

	remove_dead_from_array( level.retreating_guard );
	for(i = 0; i < level.retreating_guard.size; i++)
	{	
		if(isalive(level.retreating_guard[i]))
		{
			level.retreating_guard[i] stopallcmds();
			wait(0.01);
			level.retreating_guard[i] leavecover();
			level.retreating_guard[i] allowedstances("stand");
			level.retreating_guard[i] setscriptspeed("sprint");
			level.retreating_guard[i] cmdshootatentity(level.player, true, -1, 0.1);
			level.retreating_guard[i] setgoalnode(delete_node, 1);
		}
	}
	
	remove_dead_from_array( level.beach_guard );
	for(i = 0; i < level.beach_guard.size; i++)
	{	
		if(isalive(level.beach_guard[i]))
		{
			level.beach_guard[i] stopallcmds();
			level.beach_guard[i] leavecover();
			level.beach_guard[i] allowedstances("stand");
			level.beach_guard[i] setscriptspeed("sprint");
			level.beach_guard[i] cmdshootatentity(level.player, true, -1, 0.1);
			level.beach_guard[i] setgoalnode(delete_node, 1);
		}
	}

	wait(3);
	level.bomber thread stop_magic_bullet_Shield(); 
	level thread maps\_autosave::autosave_now("shanty_town");
	level.nextgoal = getent("skipto_alley", "targetname");
	stopemergencylock(); 
}

dock_guard_moving()
{
	dock_thug_1 = spawn_enemy(getent("dock_spawn_1", "targetname"));
	dock_thug_2 = spawn_enemy(getent("dock_spawn_2", "targetname"));
	goal_node = getnode("dock_delete", "targetname");
	dock_thug_2 SetEnableSense(false);
	dock_thug_1 SetEnableSense(false);
	dock_thug_2 CmdPlayAnim( "Gen_Civs_CheerV2", false );
	dock_thug_1 CmdPlayAnim( "Gen_Civs_CheerV2", false );

	level waittill("dock_fight_start");
	dock_thug_2 SetEnableSense(true);
	dock_thug_1 SetEnableSense(true);
	wait(10); 
	if (isalive(dock_thug_1)) 
	{
		dock_thug_1 stopallcmds();
		dock_thug_1 setgoalnode(goal_node);
		
	}
	if (isalive(dock_thug_2)) {
		dock_thug_2 stopallcmds();
		dock_thug_2 setgoalnode(goal_node);
	}
}

check_car_health()
{
	while(true)
	{

		if(!isdefined(level.car))
		{
			break;
		}
		else if(level.car.health < 4000)
			break;

		wait(1);
	}

	level thread delete_beach_car();
}

dock_fight()
{
	car_thug_origin_array = getentarray("car_thug_lock", "targetname");
	car_thug_origin = car_thug_origin_array[0];
	level.car_thug = spawn_enemy(getent("car_thug", "targetname"));
	level.car_thug SetEnableSense(false);
	level.car_thug linkto (car_thug_origin);
	level.car_thug allowedstances("crouch");
	level.car_thug thread magic_bullet_shield();
	level.car_thug animscripts\shared::placeWeaponOn( level.car_thug.weapon, "none" );

	health = level.car_thug getnormalhealth();
	car_dest = getent("car_dest_beach", "targetname");
	level.car = getent("m60_car", "targetname");
	
	level.car.health = 5000;

	level thread check_car_health();
	car_clip = getent("car_clip", "targetname");
	dest = getent("car_dest", "targetname");

	armor = getent("vehicle_armor", "targetname");
	barrel_1 = getent("vehicle_barrel_1", "targetname");
	barrel_2 = getent("vehicle_barrel_2", "targetname");
	barrel_3 = getent("vehicle_barrel_3", "targetname");
	barrel_4 = getent("vehicle_barrel_4", "targetname");
	turret_origin = getent("shanty_turret_origin", "targetname");
	level.fx_spawn = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn SetModel( "tag_origin" );
	level.fx_spawn.angles = turret_origin.angles;
	level.fx_spawn linkto(turret_origin);	

	shanty_turret = getent("shanty_turret", "targetname");
	shanty_turret_shield = getent("shanty_turret_shield", "targetname");

	target_origin = getent("m60_target", "targetname");
	origin_box = [];
	origin_box = getentarray("car_strike_box", "targetname");
	shanty_turret linkto(shanty_turret_shield);
	shanty_turret_shield linkto(level.car);
	turret_origin linkto(level.car);
	armor linkto(level.car);
	barrel_1 linkto (level.car);
	barrel_2 linkto (level.car);
	barrel_3 linkto (level.car);
	barrel_4 linkto (level.car);
	car_clip linkto (level.car);
	level.car_thug LockAlertState("alert_red");
	car_thug_origin linkto(level.car);
	level.lookat_trigger = false;
	level.dmg_trigger = false;
	level thread trigger_check();
	level thread trigger_look_at();
	wait(3.0); 
	while(true)
	{
		if(level.lookat_trigger == true || level.dmg_trigger == true)
			break;

		wait(0.05);
	}
	node_veh = getvehiclenode(level.car.target, "targetname");
	level.car startpath(node_veh);
	level notify("dock_fight_start");
	level thread move_and_shoot();
	wait(0.5);

	level notify("banana_banner_start");
	level notify("seagull_sitting_start");
	wait(1.5);
	level notify("finish_moving");
	level.direction = 0;
	level.beach_car_dead = false;
	level thread Shield_Turret_rotation();
	level.car_thug stop_magic_bullet_Shield();
	bullet_fired = 0;

	while(isalive(level.car_thug))
	{
		if(!isalive(level.car_thug))
		{
			break;
		}
		level.car_thug cmdaimatentity(level.player, false, -1);

		if(bullet_fired > 50)
		{
			if(isalive(level.car_thug))
			{
				level.car_thug allowedstances("crouch");
				wait(1);
			}
			else
				break;
			if(isalive(level.car_thug))
			{
				level.car_thug allowedstances("stand");
				wait(1);

				if(level.direction == 0)
					level.direction = 1;
				else
					level.direction = 0;
			}
			else
				break;

			bullet_fired = 0;
		}
		if(isalive(level.car_thug))
		{
			magicbullet("p99", turret_origin.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
			
			if((bullet_fired % 2) == 0)
				fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn, "tag_origin");
		}
		else 
			break;

		bullet_fired += 1;
		wait(0.05);
	}

	wait(2);
	level thread delete_beach_car();
	level.player play_dialogue_nowait("TANN_ConsG_078D");
}

#using_animtree("vehicles");
truck_flip()
{
	self UseAnimtree(#animtree);
	self setanim(%v_truck_flip);
	
	level notify( "playmusicpackage_drum" );
}

trigger_check()
{
	trigger = getent("damage_trigger_dock", "targetname");
	trigger waittill("trigger");
	trigger delete();
	level.dmg_trigger = true;
}

trigger_look_at()
{
	trigger = getent("dock_trigger_touch", "targetname");
	trigger waittill("trigger");
	level.lookat_trigger = true;
}

move_and_shoot()
{
	timer = 0;
	turret_origin = getent("shanty_turret_origin", "targetname");
	bullet_fired = 0;
	while(true)
	{
		magicbullet("FRWL_Shanty", turret_origin.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
		bullet_fired += 1;
		if((bullet_fired % 2) == 0)
		{
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn, "tag_origin");
		}
		wait(0.05);
		timer += 0.05;

		if(timer > 2)
			break;
	}		
}

Shield_Turret_rotation()
{
	shanty_turret_shield = getent("shanty_turret_shield", "targetname");
	shanty_turret = getent("shanty_turret", "targetname");
	turret_origin = getent("shanty_turret_origin", "targetname");
	turret_origin unlink();
	shanty_turret unlink();
	shanty_turret_shield unlink();
	turret_origin linkto(shanty_turret);

	while(true)
	{
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		shanty_turret_shield rotateto((0, angles[1] + 180, 0), 0.06);

		if(level.beach_car_dead == true)
			break;

		wait(0.07);
	}
}

chase_fight_thug(origin)
{
	thug = spawn_enemy( GetEnt("bomber_thug","targetname") );
	thug animscripts\shared::placeWeaponOn( thug.weapon, "none" );
	thug SetEnableSense(false);
	thug LockAlertState("alert_red");
	thug CmdMeleeEntity( level.bomber );
	level.bomber CmdMeleeEntity( thug );

	
	level waittill("door_down");
	
	level.bomber stopcmd();
	if( isalive(thug) )
	{
		thug stopcmd();
		wait(1);
		thug dodamage(thug.health+5,thug.origin);
	}

	
	bomber_start("bomber_alley_start");
}

monitor_triggers()
{
	level.checkpoint_reached = false;
}

level_end()
{
	trigger = GetEnt("trigger_level_end","targetname");
	trigger waittill("trigger");
	Objective_State(8, "done");
	maps\_endmission::nextmission();
}

garage_fight()
{
	trigger = getent("save_final_event_trigger", "targetname");
	trigger waittill("trigger");
	
	ais = getaiarray();
	ais = array_removedead(ais);

	level thread maps\_autosave::autosave_now("shanty_town");

	trigger = getent("trigger_end_fight", "targetname");
	trigger waittill("trigger");
	wait(7.5); 
	setExpFog( 1045, 12513, 0.7890, 0.7812, 0.7344, 2, 1);
	level.carter setenablesense(true);
	level.carter setignorethreat( level.bomber, true); 
	level.player play_dialogue_nowait("CART_ShanG_025A");
	level.chase_timer = 0;
	level.exceed = 600;

	destination = [];
	destination = getentarray("end_shooter_target", "targetname");
	origin = getent("shooter_origin", "targetname");
	level.bomber thread magic_bullet_shield();
	level.bomber SetPainEnable(false);

	level thread init_last_event();
	level thread switch_with_carter();
	SetDVar("sm_SunSampleSizeNear", "0.38");
	level.nextgoal = getent("carter", "targetname");


	for(i = 0; i < destination.size; i++)
	{
		level thread fire_magic_bullet_area(origin.origin, destination[i].origin, 5);
	}
}

init_last_event()
{
	level.car_3 = getent("m60_car_wave_3", "targetname");
	level.car_3.health = 10000;
	level.car_3 show();
	level.car_3 thread setup_car_driver();
	wait(5);
	
	level.last_event_wave_1_1 = false;
	level.last_event_wave_1_2 = false;
	level.last_event_Wave_2_1 = false;
	level.last_event_Wave_3_1 = false;
	level.car_wave_2_over = false;
	level.propane_dead = false;
	
	level thread central_Wave_upper();
	wait(4);
	level thread central_Wave_lower();

	while(level.last_event_wave_1_1 == false || level.last_event_wave_1_2 == false)
	{
		wait(1);
	}

	level thread maps\_autosave::autosave_now("shanty_town");
	wait(3);

	
	level.player play_dialogue_nowait("CART_ShanG_518A");
	objective_state(4, "done" );
	objective_add( 5, "active", &"SHANTYTOWN_DEFEND_RIGHT_TITLE", level.carter.origin, &"SHANTYTOWN_DEFEND_RIGHT_BODY");
	
	level thread Right_wave();
	wait(6);
	level thread wave_2_car_attack();

	while(level.last_event_wave_2_1 == false || level.car_wave_2_over == false)
	{
		wait(1);
	}

	level thread maps\_autosave::autosave_now("shanty_town");
	wait(4);
	objective_state(5, "done" );
	objective_add( 6, "active", &"SHANTYTOWN_DEFEND_LEFT_TITLE", level.carter.origin, &"SHANTYTOWN_DEFEND_LEFT_BODY");

	level thread left_wave();
	level.player play_dialogue_nowait("CART_ShanG_517A");
	
	while(level.last_event_wave_3_1 == false)
	{
		wait(1);
	}
	level thread maps\_autosave::autosave_now("shanty_town");
	wait(3);
	level thread last_wave_guard();
	level thread wave_3_car_attack();
	objective_state(6, "done" );
	objective_add( 7, "active", &"SHANTYTOWN_TAKE_OUT_TRUCK_TITLE", level.carter.origin, &"SHANTYTOWN_TAKE_OUT_TRUCK_BODY");
	wait(4);
	level thread setup_propane_throw();

	propane_2 = getent("large_propane_1", "script_noteworthy");
	propane_2 waittill("death");
	level notify("board_chuck_start");
	
	objective_state(7, "done" );
	objective_add( 8, "active", &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_NAME", level.bomber.origin, &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_BODY");

	
	earthquake(1, 3, level.player.origin, 150);	
	level.player shellshock("default", 2);
	
	wait(2);
	
	level.carter setenablesense(false);
	level.carter stopallcmds();
	node = getnode("carter_wave_node", "targetname");
	level.carter setgoalnode(node);
	level thread carter_wave_at_bond();

	trigger = getent("bomber_run_touch", "targetname");
	trigger waittill("trigger");


	

	level.bomber stopallcmds();
	bomber_resume();
}

carter_wave_at_bond()
{

	level.carter waittill("goal");
	
	level.chase_timer = 0;
	level.exceed = 30;
	while(1)
	{
		level.carter CmdAction("CallOut");
		wait(5);

	}

}

last_wave_guard()
{
	bottom_1_spawn = getent("garage_bottom_1", "targetname");
	node_1 = getnode("bottom_4_goal_node", "targetname");
	bottom_4_spawn = getent("garage_bottom_4", "targetname");
	node_2 = getnode("bottom_3_goal_node", "targetname");

	Support_1 = bottom_1_spawn stalingradspawn();
	Support_1 setscriptspeed("run");
	Support_1 thread turn_off_perfect_Sense();
	support_1 setgoalnode(node_1, 1);
	support_1 set_turret_goal("rusher");

	Support_4 = bottom_4_spawn stalingradspawn();
	Support_4 setscriptspeed("run");
	Support_4 thread turn_off_perfect_Sense();
	support_4 setgoalnode(node_2, 1);
	support_4 set_turret_goal("rusher");
	
	while(level.propane_dead == false)
	{
		if(!isdefined(Support_1))
		{
			Support_1 = bottom_1_spawn stalingradspawn();
			Support_1 setscriptspeed("run");
			Support_1 thread turn_off_perfect_Sense();
			support_1 setgoalnode(node_1, 1);
			support_1 set_turret_goal("rusher");
		}

		if(!isdefined(Support_4))
		{
			Support_4 = bottom_4_spawn stalingradspawn();
			Support_4 setscriptspeed("run");
			Support_4 thread turn_off_perfect_Sense();
			support_4 setgoalnode(node_2, 1);
			support_4 set_turret_goal("rusher");
		}
		wait(0.05);
	}
	
	flee_1 = getnode("flee_node_1", "targetname");
	flee_2 = getnode("flee_node_2", "targetname");
	if(isdefined(Support_1))
	{
		Support_1 stopallcmds();
		Support_1 setscriptspeed("sprint");
		Support_1 setgoalnode(flee_1, 0);
		Support_1 on_goal_delete();
	}

	if(isdefined(Support_4))
	{
		Support_4 stopallcmds();
		Support_4 setscriptspeed("sprint");
		Support_4 setgoalnode(flee_2, 0);
		Support_4 on_goal_delete();
	}
}

on_goal_delete()
{
	self waittill("goal");
	self delete();
}

set_turret_goal(roletype)
{
	if(isdefined(level.carter))
	{
		self setignorethreat(level.carter, true);
	}
	self waittill("goal");
	self setperfectsense(false);
	self setcombatrole(roletype);
	self SetCombatRoleLocked(true);

	if(isdefined(level.carter))
	{
		self setignorethreat(level.carter, true);
	}
}

Right_wave()
{

	Right_1_spawn = getent("wave_2_guard_1", "targetname");
	Right_2_spawn = getent("wave_2_guard_2", "targetname");
	Right_3_spawn = getent("wave_2_guard_3", "targetname");
	Right_4_spawn = getent("wave_2_guard_4", "targetname");
	Right_5_spawn = getent("wave_2_guard_5", "targetname");
	Right_6_spawn = getent("wave_2_guard_6", "targetname");
	level.wave = 0;

	origin = getentarray("magic_Grenade_origin", "targetname");

	node_1 = getnode("wave_2_cover_1", "targetname");
	node_2 = getnode("wave_2_cover_2", "targetname");
	node_3 = getnode("wave_2_cover_3", "targetname");
	node_4 = getnode("wave_2_cover_4", "targetname");
	node_5 = getnode("wave_2_cover_5", "targetname");
	node_6 = getnode("carter_cover_1", "targetname");

	turret_1 = Right_1_spawn stalingradspawn();
	turret_1 setscriptspeed("run");
	turret_1 setgoalnode(node_1, 1);	
	turret_1 thread set_turret_goal("turret");
	turret_1 magicgrenade(turret_1.origin, origin[0].origin, 3);

	turret_2 = Right_2_spawn stalingradspawn();
	turret_2 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_2 thread set_turret_goal("support");
	turret_2 magicgrenade(turret_2.origin, origin[1].origin, 3);

	turret_3 = Right_3_spawn stalingradspawn();
	turret_3 setscriptspeed("run");
	turret_3 setgoalnode(node_3, 1);
	turret_3 thread set_turret_goal("support");
	turret_3 magicgrenade(turret_3.origin, origin[2].origin, 3);

	wait(4.5);
	turret_4 = Right_4_spawn stalingradspawn();
	turret_4 setscriptspeed("run");
	turret_4 setgoalnode(node_4, 1);	
	turret_4 thread set_turret_goal("turret");
	turret_4 magicgrenade(turret_4.origin, origin[3].origin, 3);

	turret_5 = Right_5_spawn stalingradspawn();
	turret_5 setscriptspeed("run");
	turret_5 setgoalnode(node_5, 1);	
	turret_5 thread set_turret_goal("rusher");
	turret_5 magicgrenade(turret_5.origin, origin[4].origin, 3);

	turret_6 = Right_6_spawn stalingradspawn();
	turret_6 setscriptspeed("run");
	turret_6 setgoalnode(node_6, 1);	
	turret_6 thread set_turret_goal("rusher");
	turret_6 magicgrenade(turret_6.origin, origin[4].origin, 3);

	enemyCount = 0;
	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3) || isdefined(turret_4) || isdefined(turret_5) || isdefined(turret_6))
	{
		if (! isalive(turret_1) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_2) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_3) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_4) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_5) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_6) ) enemyCount = enemyCount + 1;
		if (enemyCount > 4) break;
		wait(2);
	}

	level.last_event_Wave_2_1 = true;
}

left_wave()
{
	Right_1_spawn = getent("wave_3_guard_1", "targetname");
	Right_2_spawn = getent("wave_3_guard_2", "targetname");
	Right_3_spawn = getent("wave_3_guard_3", "targetname");
	Right_4_spawn = getent("wave_3_guard_4", "targetname");
	Right_5_spawn = getent("wave_3_guard_5", "targetname");
	level.wave = 0;

	node_1 = getnode("wave_3_cover_1", "targetname");
	node_2 = getnode("wave_3_cover_2", "targetname");
	node_3 = getnode("wave_3_cover_3", "targetname");
	node_4 = getnode("wave_3_cover_4", "targetname");
	node_5 = getnode("wave_3_cover_5", "targetname");

	turret_1 = Right_1_spawn stalingradspawn();
	turret_1 setscriptspeed("run");
	turret_1 setgoalnode(node_1, 1);	
	turret_1 thread set_turret_goal("support");

	turret_2 = Right_2_spawn stalingradspawn();
	turret_2 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_2 thread set_turret_goal("support");

	turret_3 = Right_3_spawn stalingradspawn();
	turret_3 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_3 thread set_turret_goal("support");

	wait(3);
	
	turret_4 = Right_4_spawn stalingradspawn();
	origin = getent("exploder_wave_3_1", "targetname");
	physicsExplosionSphere(origin.origin , 20, 1, 5);
	turret_4 setscriptspeed("run");
	turret_4 setgoalnode(node_4, 1);	
	turret_4 thread set_turret_goal("turret");

	turret_5 = Right_5_spawn stalingradspawn();
	origin = getent("exploder_wave_3_2", "targetname");
	physicsExplosionSphere(origin.origin , 20, 1, 5);
	turret_5 setscriptspeed("run");
	turret_5 setgoalnode(node_5, 1);	
	turret_5 thread set_turret_goal("rusher");

	timer = 0;
	enemyCount = 0;
	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3) || isdefined(turret_4) || isdefined(turret_5))
	{
		if (! isalive(turret_1) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_2) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_3) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_4) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_5) ) enemyCount = enemyCount + 1;
		if (enemyCount >= 4) break;
		wait(2);
	}

	level.last_event_Wave_3_1 = true;
}

Central_Wave_upper()
{
	top_1_spawn = getent("garage_top_1", "targetname");
	top_2_spawn = getent("garage_top_2", "targetname");
	top_3_spawn = getent("garage_top_3", "targetname");
	level.wave = 0;

	node_1 = getnode("garage_top_1_node", "targetname");
	node_2 = getnode("garage_top_2_node", "targetname");
	node_3 = getnode("garage_top_3_node", "targetname");

	turret_1 = top_1_spawn stalingradspawn();
	turret_1 setscriptspeed("run");
	turret_1 setgoalnode(node_1, 1);	
	turret_1 thread set_turret_goal("turret");

	turret_2 = top_2_spawn stalingradspawn();
	turret_2 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_2 thread set_turret_goal("turret");

	turret_3 = top_3_spawn stalingradspawn();
	turret_3 setscriptspeed("run");
	turret_3 setgoalnode(node_3, 1);
	turret_3 thread set_turret_goal("turret");

	enemyCount = 0;
	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3))
	{
		if (! isalive(turret_1) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_2) ) enemyCount = enemyCount + 1;
		if (! isalive(turret_3) ) enemyCount = enemyCount + 1;
		if (enemyCount >= 2) break;
		wait(2);
	}

	level.last_event_wave_1_1 = true;
}

turn_off_perfect_Sense()
{
	wait(3);
	if(isdefined(self))
	{
		self setperfectsense(false);
	}
}

Central_wave_lower()
{
	bottom_1_spawn = getent("garage_bottom_1", "targetname");
	bottom_2_spawn = getent("garage_bottom_2", "targetname");
	bottom_3_spawn = getent("garage_bottom_3", "targetname");
	bottom_4_spawn = getent("garage_bottom_4", "targetname");
	node_1 = getnode("bottom_1_goal_node", "targetname");
	node_2 = getnode("bottom_2_goal_node", "targetname");
	node_3 = getnode("bottom_3_goal_node", "targetname");
	node_4 = getnode("bottom_4_goal_node", "targetname");

	level.wave = 0;
	Support_1 = bottom_1_spawn stalingradspawn();
	Support_1 setscriptspeed("run");
	support_1 setgoalnode(node_1, 1);
	Support_1 thread set_turret_goal("support");

	Support_2 = bottom_2_spawn stalingradspawn();
	Support_2 setscriptspeed("run");
	Support_2 thread turn_off_perfect_Sense();
	Support_2 thread set_turret_goal("flanker");

	Support_3 = bottom_3_spawn stalingradspawn();
	Support_3 setscriptspeed("run");
	Support_3 thread turn_off_perfect_Sense();
	Support_3 thread set_turret_goal("flanker");

	Support_4 = bottom_4_spawn stalingradspawn();
	Support_4 setscriptspeed("run");
	Support_4 thread turn_off_perfect_Sense();
	Support_4 thread set_turret_goal("support");

	enemyCount = 0;	
	while(isdefined(Support_1) || isdefined(Support_2) || isdefined(Support_3) || isdefined(Support_4))
	{
		if (! isalive(Support_1) ) enemyCount = enemyCount + 1;
		if (! isalive(Support_2) ) enemyCount = enemyCount + 1;
		if (! isalive(Support_3) ) enemyCount = enemyCount + 1;
		if (! isalive(Support_4) ) enemyCount = enemyCount + 1;
		if (enemyCount >= 3) break;
		wait(2);
	}

	level.last_event_wave_1_2 = true;
}

setup_propane_throw()
{
	garage_door_left = getent("garage_door_left", "targetname");
	garage_door_right = getent("garage_door_right", "targetname");
	level.door_guard = spawn_enemy(getent("guard_kicking_door", "targetname"));
	level.door_guard allowedstances("stand");
	level.door_guard thread magic_bullet_Shield();
	level.door_guard SetPainEnable(false);
	propane_origin = getent("attach_propane", "targetname");
	propane = getent("throw_propane", "targetname");
	propane_node = getnode("throw_propane_tank", "targetname");

	level.door_guard setgoalnode(propane_node);
	level.door_guard waittill("goal");
	level notify ( "CanKillTruckGuy" );
	garage_door_left rotateto((0, -89, 0), 0.5, 0.3, 0.2);
	garage_door_right rotateto((0, 90, 0), 0.5, 0.3, 0.2);
	wait(0.5);
	level thread throw_propane_at_bond();
	level.door_guard stop_magic_bullet_Shield();
	level.door_guard SetPainEnable(true);

	lrg_propane_tank = getent("large_propane_1", "script_noteworthy");
	lrg_propane_tank.health = 500; 
	
	garage_door_right connectpaths();
	garage_door_left connectpaths();
	level.propane_thrown = true;
}

m60_attack()
{
	car_thug_origin = getent("truck_guard_origin_end", "targetname");
	car_thug = spawn_enemy(getent("car_thug_2", "targetname"));
	car_thug SetEnableSense(false);
	car_thug linkto (car_thug_origin);
	car_thug allowedstances("stand");
	car_thug animscripts\shared::placeWeaponOn( car_thug.weapon, "none" );

	car = getent("m60_car_2", "targetname");
	car_clip = getent("car_clip_2", "targetname");
	dest = getent("car_dest_2", "targetname");
	armor = getent("vehicle_armor_end", "targetname");
	barrel_1 = getent("vehicle_barrel_1_end", "targetname");
	barrel_2 = getent("vehicle_barrel_2_end", "targetname");
	barrel_3 = getent("vehicle_barrel_3_end", "targetname");
	barrel_4 = getent("vehicle_barrel_4_end", "targetname");

	turret_origin = getent("vehicle_turret_origin", "targetname");
	shanty_turret = getent("shanty_turret_end", "targetname");
	shanty_turret_shield = getent("shanty_turret_shield_end", "targetname");
	propane_node = getnode("throw_propane_tank", "targetname");
	car_clip linkto (car);
	car_thug linkto (car);

	shanty_turret linkto(shanty_turret_shield);
	shanty_turret_shield linkto(car);
	turret_origin linkto(car);
	armor linkto(car);
	barrel_1 linkto (car);
	barrel_2 linkto (car);
	barrel_3 linkto (car);
	barrel_4 linkto (car);

	level.fx_spawn_1 = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn_1 SetModel( "tag_origin" );
	level.fx_spawn_1.angles = turret_origin.angles;
	level.fx_spawn_1 linkto(turret_origin);	

	garage_door_left = getent("garage_door_left", "targetname");
	garage_door_right = getent("garage_door_right", "targetname");
	level.door_guard = spawn_enemy(getent("guard_kicking_door", "targetname"));
	level.door_guard allowedstances("stand");
	level.door_guard thread magic_bullet_Shield();
	level.door_guard SetPainEnable(false);
	propane_origin = getent("attach_propane", "targetname");
	propane = getent("throw_propane", "targetname");
	propane linkto(level.door_guard, "TAG_WEAPON_RIGHT");

	car moveto(dest.origin + (0, -40, -30), 2, 0, 1.5);
	wait(1);
	car rotateto(dest.angles, 0.5);
	wait(1);

	car_thug thread magic_bullet_Shield();
	car_thug SetPainEnable(false);
	car_thug cmdshootatentity(level.player, true, 1, 1);
	level.vehicle_death = false;
	level thread Shield_Turret_rotation_end();
	level.door_guard setgoalnode(propane_node);
	level.door_guard waittill("goal");
	garage_door_left rotateto((0, -89, 0), 0.5, 0.3, 0.2);
	garage_door_right rotateto((0, 90, 0), 0.5, 0.3, 0.2);
	wait(0.5);
	level thread throw_propane_at_bond();
	level.door_guard stop_magic_bullet_Shield();
	level.door_guard SetPainEnable(true);

	garage_door_right connectpaths();
	garage_door_left connectpaths();

	trigger = getent("propane_1", "targetname");
	propane_2 = getent("large_propane_1", "script_noteworthy");
	propane_2 waittill("death");
	level notify("board_chuck_start");

	level.vehicle_death = true;
	car_thug delete();
	car delete();
	car_clip delete();
	armor delete();
	barrel_1 delete();
	barrel_2 delete();
	barrel_3 delete();
	barrel_4 delete();
	level.next_wave = 1;

	node_1 = getnode("last_event_delete_1", "targetname");
	node_2 = getnode("last_event_delete_2", "targetname");	
	all_guard = getentarray("rusher_all", "targetname");
	for(i = 0; i < all_guard.size; i++)
	{
		if(randomint(2) == 1)
		{
			all_guard[i] setenablesense(false);
			all_guard[i] stopallcmds();
			wait(0.01);
			all_guard[i] leavecover();
			all_guard[i] allowedstances("stand");
			all_guard[i] setscriptspeed("sprint");
			all_guard[i] setgoalnode(node_1);
		}
		else
		{
			all_guard[i] setenablesense(false);
			all_guard[i] stopallcmds();
			wait(0.01);
			all_guard[i] leavecover();
			all_guard[i] allowedstances("stand");
			all_guard[i] setscriptspeed("sprint");
			all_guard[i] setgoalnode(node_2);
		}
	}

	trigger = getent("bomber_run_touch", "targetname");
	trigger waittill("trigger");
	level.bomber stopallcmds();
	bomber_resume();
	objective_state(4, "done" );
	objective_add( 5, "current", &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_NAME", level.bomber.origin, &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_BODY");
}

throw_propane_at_bond()
{
	propane = getent("throw_propane", "targetname");
	window_destroy = getent("blow_open_window", "targetname");
	
	origin_blow = getent("propane_explosion_origin", "targetname");
	propane unlink();
	propane movegravity((-590, -100, 370), 1.23);
	wait(3);
	playfx( level._effect["default_explosion"], origin_blow.origin );
	physicsExplosionSphere(origin_blow.origin, 700, 1, 4);
	earthquake(1, 3, level.player.origin, 150);	
	level.player shellshock("default", 2);
	level.player playerSetForceCover(0, 0); 
	level.propane_dead = true;
	level.end_debris show();
	window_destroy delete();
	propane delete();
}

Shield_Turret_rotation_end()
{
	turret_origin = getent("vehicle_turret_origin", "targetname");
	shanty_turret = getent("shanty_turret_end", "targetname");
	shanty_turret_shield = getent("shanty_turret_shield_end", "targetname");
	turret_origin unlink();
	shanty_turret unlink();
	shanty_turret_shield unlink();
	turret_origin linkto(shanty_turret);

	while(true)
	{
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		shanty_turret_shield rotateto((shanty_turret_shield.angles[0], angles[1] + 180, shanty_turret_shield.angles[2]), 0.06);

		magicbullet("P99", turret_origin.origin, level.player.origin + (randomintrange(-75, 75), randomintrange(-50, 50), 30));

		if(randomint(2) == 1)
		{
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_1, "tag_origin");
		}

		if(level.vehicle_death == true)
			break;

		wait(0.07);
	}
	shanty_turret_shield delete();
	shanty_turret delete();
}

bomber_garage_pause(origin)
{
	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
}

civ_alley_amb()
{

	wait(5);

	bird_origin_1 = getent("bird_origin_5", "targetname");
	bird_origin_2 = getent("bird_origin_6", "targetname");
	playfx( level._effect["bird"], bird_origin_1.origin );
	wait(1);
	playfx( level._effect["bird_1"], bird_origin_2.origin );
}







dog_bark_start(trigger)
{
	door = getent(trigger.target, "targetname");

	while(true)
	{
		while(level.player istouching(trigger))
		{
			level.player playsound("dog_bark");
			wait(1.5);

			for(i = 0; i < 10; i++)
			{
				door rotateto((0, -1, 0), 0.02);
				door waittill("rotatedone");
				door rotateto((0, 1, 0), 0.02);
				door waittill("rotatedone");
			}

		}
		wait(2);
	}
}

dog_barking_init()
{
	trigger = getentarray("dog_bark_trigger", "targetname");

	for(i = 0; i < trigger.size; i++)
	{
		level thread dog_bark_start(trigger[i]);
	}
}

shack_door_bash()
{
	trigger = GetEnt("trigger_bash_door","targetname");
	door = GetEnt("doorA_script","targetname");

	trigger waittill("trigger");
	door PlaySound("shanty_town_door_bash");
	door RotateTo((0, 90, 0),.05);
	level notify("door_down");
	wait(2);
	
	trigger delete();
	setExpFog( 0, 875, 0.7890, 0.7812,  0.7344, 2, 0.835);

	wait(0.05);
	door RotateTo((0, 80, 0), 5);

	trigger = getent("bomber_camera_shift", "targetname");
	trigger waittill("trigger");
}

spawn_warehouse_guard()
{
	startemergencylock(); 
	trigger = getent("spawn_ware_house_guard", "targetname");
	trigger waittill("trigger");

	door = getent("shack_guard_door" , "targetname");
	door PlaySound("shanty_town_door_bash");
	door RotateTo((0, 110, 0), 0.5);
	wait(0.2);
	physicsExplosionCylinder(door.origin, 150, 30, 4 );
	wait(0.2);
	door connectpaths();

	guard_spawn = [];

	guard_spawn = getentarray("dock_ware_house_thug", "targetname");
	for(i = 0; i < guard_spawn.size; i++)
	{
		guard_spawn[i] stalingradspawn();
	}

	wait(1);
	if(isdefined(level.car))
	{
		level thread delete_beach_car();
	}
}

delete_beach_car()
{
	car_Dest = getent("car_dest_end", "targetname");
	gate_node = getvehiclenode( "car_stop_node", "targetname" );
	shanty_turret_shield = getent("shanty_turret_shield", "targetname");
	shanty_turret = getent("shanty_turret", "targetname");
	turret_origin = getent("shanty_turret_origin", "targetname");
	armor = getent("vehicle_armor", "targetname");

	if(isdefined(shanty_turret_shield))
	{
		shanty_turret_shield linkto(level.car);
	}
	if(isdefined(shanty_turret))
	{
		shanty_turret linkto(level.car);
	}
	level.beach_car_dead = true;
	maps\_vehicle::path_gate_open(gate_node);
	level.car waittill("reached_end_node");

	if(isalive(level.car_thug))
	{
		level.car_thug delete();
	}
	
	if(isdefined(level.car))
	{
		level.car delete();
	}

	if(isdefined(armor))
	{
		armor delete();
	}

	if(isdefined(shanty_turret_shield))
	{
		shanty_turret_shield delete();
	}

	if(isdefined(shanty_turret))
	{
		shanty_turret delete();
	}

	level notify("car_delete");
}

delete_self(origin)
{
	if(self == level.carter_pool)
	{
		level.carter_pool thread Stop_magic_bullet_Shield();
	}

	self delete();
}

fire_magic_bullet_area(origin, destination, duration)
{
	timer = 0;

	while(timer < duration)
	{
		x = randomintrange(-20, 20);
		y = randomintrange(-20, 20);

		magicbullet("FRWL_Shanty", origin, destination + (x, y, 0));
		
		wait_timer = randomfloatrange(0.1, 0.3);
		wait(wait_timer);
		timer += wait_timer;
	}
}

kick_over_table(origin)
{	
	trigger = getent("kick_table", "targetname");
	node = getnode("take_cover_on_table", "targetname");
	ent = getent("rotating_table", "targetname");
	trigger waittill("trigger");
	level.bar_thug_3 cmdplayanim("thug_alrt_frontkick", true);

	wait(1.3);
	ent rotateto((0, 0, -60), 0.3, 0.1, 0.2);
	level.bar_thug_3 setenablesense(true);
	level.bar_thug_3 setgoalnode(node);
	level.bar_thug_3 waittill("goal");
	level.bar_thug_3 stopallcmds();
	level.bar_thug_3 CmdThrowGrenadeAtEntity(level.player, false, 1);
}

checkpoint()
{
	skipto = GetDVar( "skipto" );
	if(skipto == "beach")
	{
		bomber_spawner = GetEnt("bomber_spawner","targetname");
		origin = getent("bomber_skipto_origin", "targetname");
		level.bomber = bomber_spawner stalingradspawn();
		level.bomber SetEnableSense(false);
		level.bomber linkto(origin);

		skip = getent("skipto_beach", "targetname");
		node = getnode("chase_node_dock", "targetname");
		origin moveto(node.origin + (40, 0 ,90), 0.01);
		wait(1);
		level.bomber unlink();
		level.bomber stopallcmds();
		level.bomber setgoalnode(node);
		level.player setorigin(skip.origin);
		level.player setplayerangles(skip.angles);

		wait(3);
		
		SetSavedDVar("ik_bob_pelvis_scale_1st","0");

		level.player enableweapons();
		maps\_utility::unholster_weapons();
		level.player switchtoweapon( "p99");
		level.nextgoal = getent("skipto_alley", "targetname");
		level.bomber.goalradius = 10;
		level.bomber SetEnableSense(false);
		level.bomber LockAlertState("alert_red");
		level.bomber setoverridespeed(28);
		level.bomber.script_radius = 10;
		setSavedDvar("cg_drawHUD","1");
	}
	else if (skipto == "alley")
	{
		bomber_spawner = GetEnt("bomber_spawner","targetname");
		origin = getent("bomber_skipto_origin", "targetname");
		level.bomber = bomber_spawner stalingradspawn();
		level.bomber SetEnableSense(false);
		level.bomber linkto(origin);
		skip = getent("skipto_alley", "targetname");
		node = getnode("bomber_skipto_alley", "targetname");
		origin moveto(node.origin + (-40, 0 ,90), 0.01);
		wait(1);
		level.bomber unlink();
		level.bomber stopallcmds();
		level.bomber setgoalnode(node);
		level.player setorigin(skip.origin);
		level.player setplayerangles(skip.angles);

		wait(3);
		
		SetSavedDVar("ik_bob_pelvis_scale_1st","0");
		level.nextgoal = getent("trigger_level_end", "targetname");
		level.player enableweapons();
		maps\_utility::unholster_weapons();

		level.bomber.goalradius = 15;
		level.bomber SetEnableSense(false);
		level.bomber LockAlertState("alert_red");
		level.bomber setoverridespeed(28);
		level.bomber.script_radius = 28;
		setSavedDvar("cg_drawHUD","1");
	}
	else
	{
		level thread setup_camera();
		level.nextgoal = getent("skipto_beach", "targetname");
		level waittill("spawn_complete");
		maps\_autosave::autosave_now("shanty_town");
	}
}

reduce_all_accuracy()
{
	while(true)
	{
		enemies = getaiarray("axis");

		for(i = 0; i < enemies.size; i++)
		{
			enemies[i].accuracy = 0.3;
		}

		wait(0.1);
	}
}





hud_text_uninterruptible(text, time_ms, optional)
{
	
	notused = -1;
	while(notused == -1)
	{
		wait(0.5);
		for(i = 0 ; i < level.control_hud.size; i++)
		{
			if(!level.control_hud[i].inuse)
			{
				notused = i;

				if(isdefined(optional))
				{
					level.control_hud[i].y = 0;
					level.control_hud[i].fontscale = 2;
				}
				break;
			}
		}
	}

	
	if (IsDefined(level.control_hud[notused]))
	{
		level.control_hud[notused].inuse = true;
		for(i = 0 ; i < level.totalhudelement; i++)
		{
			if(level.control_hud[i].inuse == true && i != notused)
			{
				level.control_hud[i].y -= 20;
			}
		}

		while((time_ms > 0) && (level.control_hud[notused].inuse == true)) 
		{
			level.control_hud[notused] settext(text);
			wait(.05);
			time_ms -= 50;
		}

		thread reset_hud_element(notused);
	}
}



control_hud(size)
{
	level.control_hud = [];
	for(i = 0;  i < size; i++)
	{
		level.control_hud[i] = newHudElem();
		level.control_hud[i].x = 0;
		level.control_hud[i].y = 150;
		level.control_hud[i].alignX = "center";
		level.control_hud[i].alignY = "middle";
		level.control_hud[i].horzAlign = "center";
		level.control_hud[i].vertAlign = "middle";
		level.control_hud[i].foreground = true;
		level.control_hud[i].fontScale = 1.50;
		level.control_hud[i].alpha = 1.0;
		level.control_hud[i].color = (1, 1, 1);
		level.control_hud[i].inuse = false;
	}

}


reset_hud_element(notused)
{
	level.control_hud[notused].x = 0;
	level.control_hud[notused].y = 150;
	level.control_hud[notused].alignX = "center";
	level.control_hud[notused].alignY = "middle";
	level.control_hud[notused].horzAlign = "center";
	level.control_hud[notused].vertAlign = "middle";
	level.control_hud[notused].foreground = true;
	level.control_hud[notused].fontScale = 1.50;
	level.control_hud[notused].alpha = 1.0;
	level.control_hud[notused].color = (1, 1, 1);
	level.control_hud[notused].inuse = false;
	level.control_hud[notused] settext("");
}

turn_off_Psense(duration)
{
	wait(duration);
	self setperfectsense(false);
}


wave_2_car_attack()
{
	wait(1);
	car_thug_origin = getent("car_thug_lock_wave_2", "targetname");
	level.car_thug_2 = spawn_enemy(getent("car_thug_wave_2", "targetname"));
	level.car_thug_2 SetEnableSense(false);
	level.car_thug_2 linkto (car_thug_origin);
	level.car_thug_2 allowedstances("crouch");
	level.car_thug_2 thread magic_bullet_shield();
	level.car_thug_2 animscripts\shared::placeWeaponOn( level.car_thug_2.weapon, "none" );

	level.car_2 = getent("m60_car_wave_2", "targetname");
	level.car_2 show();
	level.car_2.health = 20000;
	car_clip = getent("car_clip_wave_2", "targetname");


	armor = getent("vehicle_armor_wave_2", "targetname");
	barrel_1 = getent("vehicle_barrel_1_wave_2", "targetname");
	barrel_2 = getent("vehicle_barrel_2_wave_2", "targetname");
	barrel_3 = getent("vehicle_barrel_3_wave_2", "targetname");
	barrel_4 = getent("vehicle_barrel_4_wave_2", "targetname");

	turret_origin = getent("shanty_turret_origin_wave_2", "targetname");

	level.fx_spawn_2 = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn_2 SetModel( "tag_origin" );
	level.fx_spawn_2.angles = turret_origin.angles;
	level.fx_spawn_2 linkto(turret_origin);	

	shanty_turret = getent("shanty_turret_wave_2", "targetname");
	shanty_turret_shield = getent("shanty_turret_shield_wave_2", "targetname");

	shanty_turret linkto(shanty_turret_shield);
	shanty_turret_shield linkto(level.car_2);
	turret_origin linkto(level.car_2);
	armor linkto(level.car_2);
	barrel_1 linkto (level.car_2);
	barrel_2 linkto (level.car_2);
	barrel_3 linkto (level.car_2);
	barrel_4 linkto (level.car_2);
	car_clip linkto(level.car_2);
	level.car_thug_2 LockAlertState("alert_red");
	car_thug_origin linkto(level.car_2);
	node_veh = getvehiclenode(level.car_2.target, "targetname");
	level.car_2 startpath(node_veh);

	level thread move_and_shoot_2();
	level thread Shield_Turret_rotation_2();

	bullet_fired = 0;
	timer = 0;
	modulo_timer = 0;
	stance = 0;
	while(isalive(level.car_thug_2))
	{
		level.car_thug_2 cmdaimatentity(level.player, false, -1);

		if(bullet_fired > 50 && ((modulo_timer % 5) == 0))
		{
			if (stance == 0) 
			{
				level.car_thug_2 allowedstances("crouch");
				stance = 1;
			}
			else 
			{
				level.car_thug_2 allowedstances("stand");
				stance = 0;
			}
			wait(1);
			modulo_timer += 1;
			timer += 1;
			bullet_fired = 0;
		}

		magicbullet("p99", turret_origin.origin, level.player.origin + (randomintrange(0, 150), randomintrange(-40, 100), 30));
		bullet_fired += 1;
		if((bullet_fired % 2) == 0)
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_2, "tag_origin");

		wait(0.05);
		timer += 0.05;

		if(timer >= 15)
			break;
	}
	
	shanty_turret_shield linkto(level.car_2);
	shanty_turret linkto(level.car_2);
	gate_node = getvehiclenode( "car_stop_node_wave_2", "targetname" );
	maps\_vehicle::path_gate_open(gate_node);
	level.car_wave_2_over = true;

	level.car_thug_2 thread stop_magic_bullet_shield();
	level.car_thug_2 delete();
}

move_and_shoot_2()
{
	timer = 0;
	turret_origin = getent("shanty_turret_origin_wave_2", "targetname");
	bullet_fired = 0;
	while(true)
	{
		magicbullet("FRWL_Shanty", turret_origin.origin, level.player.origin + (randomintrange(-5, 5), randomintrange(-5, 5), randomint(60)));
		bullet_fired += 1;
		if((bullet_fired % 2) == 0)
		{
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_2, "tag_origin");
		}
		wait(0.05);
		timer += 0.05;

		if(timer > 4)
			break;
	}		
}

Shield_Turret_rotation_2()
{
	shanty_turret_shield = getent("shanty_turret_shield_wave_2", "targetname");
	shanty_turret = getent("shanty_turret_wave_2", "targetname");
	turret_origin = getent("shanty_turret_origin_wave_2", "targetname");
	turret_origin unlink();
	shanty_turret unlink();
	shanty_turret_shield unlink();
	turret_origin linkto(shanty_turret);
	timer = 0;

	while(true)
	{
		wait(0.25);
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		shanty_turret_shield rotateto((0, angles[1] + 250, 0), 0.06);

		timer += 0.07;
		if(timer >= 18)
			break;

		wait(0.07);
	}
}

wave_3_car_attack()
{
	car_thug_origin = getent("car_thug_lock_wave_3", "targetname");
	level.car_thug_3 = spawn_enemy(getent("car_thug_wave_3", "targetname"));
	level.car_thug_3 SetEnableSense(false);
	level.car_thug_3 SetPainEnable(false);
	level.car_thug_3 thread magic_bullet_shield();
	level.car_thug_3 linkto (car_thug_origin);
	level.car_thug_3 allowedstances("crouch");
	
	level.car_thug_3 animscripts\shared::placeWeaponOn( level.car_thug_3.weapon, "none" );

	level.car_3 = getent("m60_car_wave_3", "targetname");
	level.car_3.health = 10000;
	level.car_3 hide();
	
	car_clip = getent("car_clip_wave_3", "targetname");

	armor = getent("vehicle_armor_wave_3", "targetname");
	barrel_1 = getent("vehicle_barrel_1_wave_3", "targetname");
	barrel_2 = getent("vehicle_barrel_2_wave_3", "targetname");
	barrel_3 = getent("vehicle_barrel_3_wave_3", "targetname");
	barrel_4 = getent("vehicle_barrel_4_wave_3", "targetname");

	turret_origin = getent("shanty_turret_origin_wave_3", "targetname");

	level.fx_spawn_3 = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn_3 SetModel( "tag_origin" );
	level.fx_spawn_3.angles = turret_origin.angles;
	level.fx_spawn_3 linkto(turret_origin);	

	shanty_turret = getent("shanty_turret_wave_3", "targetname");
	shanty_turret_shield = getent("shanty_turret_shield_wave_3", "targetname");

	shanty_turret linkto(shanty_turret_shield);
	shanty_turret_shield linkto(level.car_3);
	turret_origin linkto(level.car_3);
	armor linkto(level.car_3);
	barrel_1 linkto (level.car_3);
	barrel_2 linkto (level.car_3);
	barrel_3 linkto (level.car_3);
	barrel_4 linkto (level.car_3);
	car_clip linkto(level.car_3);
	level.car_thug_3 LockAlertState("alert_red");
	car_thug_origin linkto(level.car_3);

	node_veh = getvehiclenode(level.car_3.target, "targetname");
	level.car_3 show();
	level.car_3 startpath(node_veh);

	wait(6);
	level thread Shield_Turret_rotation_3();
	bullet_fired = 0;
	stance = 0;
	modulo_timer = 0;
	timer = 0;
	level.car_thug_3.health = 2000;
	level.car_thug_3 thread stop_magic_bullet_shield();
	level waittill ( "CanKillTruckGuy" );
	level.car_thug_3 SetPainEnable(true);
	level.car_thug_3 cmdaimatentity(level.player, false, -1);
	while(isalive(level.car_thug_3))
	{
		if(bullet_fired > 50)
		{
			if (stance == 0 && (modulo_timer % 5 == 0)) 
			{
				level.car_thug_3 allowedstances("crouch");
				stance = 1;
			}
			else 
			{
				level.car_thug_3 allowedstances("stand");
				stance = 0;
			}
			wait(1);
			modulo_timer += 1;
			timer += 1;
			bullet_fired = 0;
		}

		magicbullet("p99", turret_origin.origin, level.player.origin + (randomintrange(0, 50), randomintrange(-20, 50), 30));

		if((bullet_fired % 2) == 0)
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_3, "tag_origin");

		bullet_fired += 1;
		wait(0.05);

		if(level.propane_dead == true)
			break;
			
	}
	
	lrg_propane_tank = getent("large_propane_1", "script_noteworthy");
	if ((isalive(level.door_guard)) || (lrg_propane_tank.health > 1)) 
	{
		level thread slow_time_new(0.25, 2.5, 1.5);
		
		level.door_guard.health = level.door_guard.health - (level.door_guard.health - 1);
		magicbullet("p99", level.door_guard.origin, level.door_guard.origin ); 
		level.door_guard CmdPlayAnim( "Thug_ShootAirDeath", false, true );
		wait(0.75);
		lrg_propane_tank.health = lrg_propane_tank.health - (lrg_propane_tank.health - 1); 
		magicbullet("p99", lrg_propane_tank.origin, lrg_propane_tank.origin ); 
	}
	
	car_clip delete();
	armor delete();
	barrel_1 delete();
	barrel_2 delete();
	barrel_3 delete();
	barrel_4 delete();
	shanty_turret_shield delete();
	shanty_turret delete();
	
	damage_origin = level.car_3.origin;
	if (isdefined(level.car_thug_3) && isalive(level.car_thug_3)) level.car_thug_3 delete();
	if (isdefined(level.car_3)) level.car_3 delete();
	level notify("board_chuck_start"); 

	fake_car = getent("fake_car", "targetname");
	fake_car show();
	fake_car solid();
	fake_car truck_flip();
	radiusdamage(damage_origin, 90, 80, 40);
}

move_and_shoot_3()
{
	timer = 0;
	turret_origin = getent("shanty_turret_origin_wave_3", "targetname");
	bullet_fired = 0;
	while(true)
	{
		magicbullet("FRWL_Shanty", turret_origin.origin, level.player.origin + (randomintrange(-5, 5), randomintrange(-5, 5), randomint(60)));
		bullet_fired += 1;
		if((bullet_fired % 2) == 0)
		{
			fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_3, "tag_origin");
		}
		wait(0.05);

		timer += 0.05;

		if(timer > 10)
			break;
	}		
}

Shield_Turret_rotation_3()
{
	shanty_turret_shield = getent("shanty_turret_shield_wave_3", "targetname");
	shanty_turret = getent("shanty_turret_wave_3", "targetname");
	turret_origin = getent("shanty_turret_origin_wave_3", "targetname");
	
	shanty_turret unlink();
	
	turret_origin linkto(shanty_turret);
	timer = 0;
	
	while(isdefined(shanty_turret_shield))
	{
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		shanty_turret_shield rotateto((0, angles[1] + 90, 0), 0.06);

		wait(0.07);
	}
}

civ_alley_spawn()
{
	civ_1_spawn = getent("civ_alley_1", "targetname");
	civ_2_spawn = getent("civ_alley_2", "targetname");
	civ_3_spawn = getent("civ_alley_3", "targetname");
	node_1 = getnode("civ_door_1_node", "targetname");
	node_2 = getnode("civ_door_1_node", "targetname");
	node_3 = getnode("civ_door_1_node", "targetname");
	door_1 = getent("civ_door_1", "targetname");
	door_2 = getent("civ_door_2", "targetname");

	trigger = getent("spawn_ware_house_guard", "targetname");
	level.civ_array = [];

	civ_1 = civ_1_spawn stalingradspawn();
	civ_1 animscripts\shared::placeWeaponOn( civ_1.weapon, "none" );
	civ_1 SetEnableSense(false);
	level.civ_array[0] = civ_1;
	
	civ_1 setoverridespeed(15);
	civ_2 = civ_2_spawn stalingradspawn();
	civ_2 animscripts\shared::placeWeaponOn( civ_2.weapon, "none" );
	civ_2 SetEnableSense(false);
	level.civ_array[1] = civ_2;
	
	civ_2 setoverridespeed(15);
	civ_3 = civ_3_spawn stalingradspawn();
	civ_3 animscripts\shared::placeWeaponOn( civ_3.weapon, "none" );
	civ_3 SetEnableSense(false);
	level.civ_array[2] = civ_3;
	
	civ_3 setoverridespeed(15);
	level thread check_civ_health();

	trigger = getent("bomber_shoot_bond_trigger", "targetname");
	trigger waittill("trigger");
	
	
	civ_1 civ_on_goal(node_1);

	trigger = getent("kick_out_cargo_door", "targetname");
		trigger waittill("trigger");

	civ_2 civ_on_goal(node_2);

	trigger = getent("bomber_camera_shift", "targetname");
	trigger waittill("trigger");

	civ_3 civ_on_goal(node_3);
}

civ_on_goal(node)
{
	self setscriptspeed("sprint");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}

kick_door_out(origin)
{


}

#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver") + (24, 0, -10) );
	driver.angles = self.angles;
	driver character\character_thug_1_shanty::main();
	driver LinkTo( self, "tag_driver" );
	
	
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	
	
	level waittill("board_chuck_start");
	driver delete();
}

check_civ_health()
{
	health_1 = level.civ_array[0] getnormalhealth();
	while(1)
	{
		if(isdefined(level.civ_array[0]))
		{
			if(health_1 > level.civ_array[0] getnormalhealth())
				missionfailed();
		}

			if(isdefined(level.civ_array[1]))
		{
			if(health_1 > level.civ_array[1] getnormalhealth())
				missionfailed();
		}

		if(isdefined(level.civ_array[2]))
		{
			if(health_1 > level.civ_array[2] getnormalhealth())
				missionfailed();
		}
		wait(0.1);
	}
}

set_timer_base_on_difficulty(timer)
{
	if(getdvarint("level_gameskill") == 0)
	{
		
		
	}
	else if(getdvarint("level_gameskill") == 1)
	{
		
		
	}
	else if(getdvarint("level_gameskill") == 2)
	{
		
		
	}
	else if(getdvarint("level_gameskill") == 3)
	{
		
		
	}
}
#include animscripts\shared;
#include maps\_playerawareness;
#include maps\_utility;
//#include maps\_anim;

#include maps\shantytown_util;

#using_animtree("generic_human");

main()
{

	


	setExpFog( 0, 3173, 0.678979, 0.643003,  0.604488, 0, 1);
	VisionSetNaked( "shanty_indoor", 0.0 );
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");
	level.strings["Cellphone_bar_name"] = &"SHANTYTOWN_BAR_NAME";
	level.strings["Cellphone_bar_body"] = &"SHANTYTOWN_BAR_BODY";
	level.strings["Cellphone_weapon_name"] = &"SHANTYTOWN_WEAPON_NAME";
	level.strings["Cellphone_weapon_body"] = &"SHANTYTOWN_WEAPON_BODY";
	level.strings["Cellphone_dock_name"] = &"SHANTYTOWN_DOCK_NAME";
	level.strings["Cellphone_dock_body"] = &"SHANTYTOWN_DOCK_BODY";


	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		level.hud_black SetShader("black", 640, 480);
		level.hud_black fadeOverTime(12.0 );
		level.hud_black.alpha = 0; 
	}


	//setDvar("cg_disableHudElements", 1 );
	//level thread fade_out_black(6, false);
	
	//artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		maps\_load::main();
		return;
	}


	maps\_vvan::main("p_msc_truck_pickup_old_shanty");
	maps\_load::main();
	maps\shantytown_fx::main();
	maps\_playerawareness::init();
	SetSavedDVar("r_godraysPosX2",  "0.5");
	SetSavedDVar("r_godraysPosY2",  "-0.5");
	//setdvar("ui_hud_showstanceicon", "0");
	//setsaveddvar ( "ammocounterhide", "1" );
	

	//level thread maps\_utility::timer_init();
	
	oceanshader( 1 );

	//Enable mini-map for test level
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
	level._effect["smoke_large"] = loadfx ("maps/shantytown/thin_black_smoke_m");
	level._effect["m60_muzzle_flash"] = loadfx("weapons/scar_discharge_fp");
	level._effect["dust_trail"] = loadfx("dust/dust_vehicle_tires");
	level._effect["exhaust"] = loadfx("vehicles/night/vehicle_night_exhaust");
	level._effect["bird"] = loadfx("maps/Siena/siena_birds_flying1");
	level._effect["bird_1"] = loadfx("maps/Siena/siena_birds_flying4");
	//level._effect["medium_fire"] = loadfx("maps/whites_estate/whites_med_fire2");
	level._effect["car_landing_effect"] = loadfx("maps/shantytown/shanty_carbomb_crashland");
	level._effect["big_flame_wall"] = loadfx("maps/shantytown/shanty_alleyflames200slo");
	
	
if ( level.ps3 == true )
	{
		level._effect["big_fire"] = loadfx("maps/operahouse/opera_large_fire_PS3");
		level._effect["medium_fire_2"] = loadfx("maps/shantytown/shanty_burning_fire_PS3");

	}
else
	{
		level._effect["big_fire"] = loadfx("maps/operahouse/opera_large_fire_PS3");
		level._effect["medium_fire_2"] = loadfx("maps/shantytown/shanty_burning_fire");


	}
	




	level.totalhudelement = 5;
	level thread control_hud(level.totalhudelement);


	thread monitor_triggers();
	thread setup_vision();
	thread setup_civilians();
	thread setup_bond();
	thread setup_bomber();

	
	thread setup_objectives();
	
	thread level_end();
	level thread shack_door_bash();
	level thread amb_boat_init();
	level thread setup_garage_fight();
	level thread beach_fight();
	level thread spawn_warehouse_guard();
	level thread set_guard_talking();
	
	level thread garage_fight();
	//level thread goal_arrow();
	level thread chimney_smoke();

	level thread dock_fight();

	level thread moving_crane();
	level thread civ_cross();

	// DCS: thread dialog seperately to avoid possibly breakage from previous events.
	level thread level_dialogue();
	level thread dock_fight_dialog();
	level thread end_fight_dialog();
	level thread truck_destruct_dialog();
	
	level thread blinds_init();
	thread maps\shantytown_snd::main();
	thread maps\shantytown_mus::main();
	
	level thread dog_barking_init();
	level thread checkpoint();
	level thread set_ocean_wave();
	level thread start_wave_sound();
	level thread birds_alley();
	
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

//setup the flame effect at wave 2 propane
setup_flames()
{
	origin = getent("medium_fire_propane_wave_2", "targetname");
	trigger = getent("medium_fire_trigger", "targetname");
	trigger waittill("trigger");

	playfx(level._effect["medium_fire_2"], origin.origin);


}
//setup rest of the flame effect after propane explosion at end.
setup_flames_2()
{
	
	level waittill("board_chuck_start");
	
	
	origin_1 = getentarray("medium_fire_end", "targetname");
	origin_2 = getentarray("big_flame_end", "targetname");

	for(i = 0; i < origin_1.size; i++)
	{

		playfx(level._effect["medium_fire_2"], origin_1[i].origin);
	}

	for(i = 0; i < origin_2.size; i++)
	{

		playfx(level._effect["big_fire"], origin_2[i].origin);
	}

	radiusdamage((4296, 824, 32), 30, 500, 490);
	


}

//play the birds effect in the alley
birds_alley()
{
	trigger = getent("bird_takes_off", "targetname");
	trigger waittill("trigger");

	level thread window_fall_init();

	bird_origin_1 = getent("bird_origin_3", "targetname");
	bird_origin_2 = getent("bird_origin_4", "targetname");

	bird_origin_1 playsound ("shanty_town_birds_flaps");
	bird_origin_2 playsound ("shanty_town_birds_flaps");
	playfx( level._effect["bird"], bird_origin_1.origin );
	
	playfx( level._effect["bird_1"], bird_origin_2.origin );
	
	//iprintlnbold ("SOUND: birds");




}
//load and play the ocean sounds.
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
				//iprintlnbold("wave sound playing");
			}

			wait(3);
		}

		wait(0.5);




	}


}

//set the ocean wave via dvars
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

//Play most of the dialogue in the level here.

Level_Dialogue()
{
	wait(3);
	//iprintlnbold("play sound now");
	level.bomber play_dialogue("BOMB_ShanG_003A");
	wait(2);
	level.bar_thug_3 play_dialogue("STH1_ShanG_004A");

	trigger = getent("give_gun_bond", "targetname");
	trigger waittill("trigger");

	//level.player play_dialogue("CART_ShanG_001A", true);
	//level.player play_dialogue("BOND_ShanG_002A", true);
	level.bar_thug_3 play_dialogue("STH1_ShanG_005A", true);
}
dock_fight_dialog()
{
	trigger = getent("dock_trigger_touch", "targetname");
	trigger waittill("trigger");

	trigger = getent("trigger_bar_run", "targetname");
	trigger waittill("trigger");

	level.player play_dialogue_nowait("BOMB_ShanG_006A");

	trigger = getent("bomber_shoot_bond_trigger", "targetname");
	trigger waittill("trigger");

	//level.player play_dialogue("CART_ShanG_040A");
	//level.player play_dialogue_nowait("CART_ShanG_028A");
}
end_fight_dialog()
{
	trigger = getent("trigger_end_fight", "targetname");
	trigger waittill("trigger");

	level.carter play_dialogue("CART_ShanG_041A");
}

truck_destruct_dialog()
{
	level waittill("board_chuck_start");

	wait(5.0);
	level.player play_dialogue("CART_ShanG_011A");
	level.player play_dialogue("BOND_ShanG_004A");
	//We really need an instant payoff, so Carter should answer Bond - CRussom
	level.player play_dialogue("CART_ShanG_802A");

}

//update the timer initial and check for failure
Timer_update()
{
	
	//level thread set_timer_base_on_difficulty(60);
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

	missionfailedwrapper();


}

//load up the civilian at beginning of the game.
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
		//iprintlnbold("SOUND: crowd panic");
		civilians[i] playsound ("shanty_panic");

	}

	node = getnode("carter_pool_node", "targetname");
	level.carter_pool = getent("carter_pool", "targetname");
	level.carter_pool LockAlertState("alert_red");
	level.carter_pool thread magic_bullet_shield();
	level.carter_pool setcandamage(false);
	level.bar_thug_4 setignorethreat( level.carter_pool, true);
	level.bar_thug_3 setignorethreat( level.carter_pool, true);

	level.carter_pool SetEnableSense(0);
	level.trigger_is_hit = 0;


	level.carter_anim = level.carter_pool cmdplayanim("Carter_Pain_Loop", false);
	level.carter_pool_anim_2 = level.carter_pool cmdplayanim("Carter_Pain_to_Alert", false);


	//level.carter_pool waittill("cmd_done");



	trigger = getent("give_gun_bond", "targetname");
	trigger waittill("trigger");


	//level thread set_timer_base_on_difficulty(89);
	//setdvar("ui_hud_showstanceicon", "1");
	//setsaveddvar ( "ammocounterhide", "0" );
	//setDvar( "cg_disableHudElements", 0 );
	//setSavedDvar("cg_drawHUD","1");
	level.trigger_is_hit = 1;
	

}


//move the crane in the background.
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

//play the smoke effect
chimney_smoke()
{
	ent = [];
	ent = getentarray("chimney_smoke", "targetname");
	for(i = 0; i < ent.size; i++)
	{

		playfx( level._effect["shanty_alley_smokecolumn"], ent[i].origin );
	}

}

//initialize the 2 starting guards
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
//setup the cameras here
setup_camera()
{
	maps\_utility::letterbox_on(false);
	
	level.player freezecontrols(true);




	bomber_spawner = GetEnt("bomber_spawner","targetname");
	level.bomber = spawn_enemy(bomber_spawner);
	level.bomber SetPainEnable(false);
	//entname setquickkillenable(false);
	level.player customcamera_checkcollisions( 0 );
	//level thread maps\_autosave::autosave_now("shanty_town");
	
	
	
	level.cameraID = level.player customCamera_Push( "world", ( -850.27, 450.10, -31.18 ), ( 4.92, -44.34, 0), 0.0);
	level.bomber setquickkillenable(false);
	//level.bomber setnormalhealth(5500);
	level.bomber.targetname = "bomber";
	level.bomber.animname = "bomber";
	level notify( "playmusicpackage_action" );
	wait(0.05);
	//wait(2);
	playcutscene("Shantytown_BomberRun","Shantytown_BomberRun_Done");
	wait(1.0);
	//level.hud_black.alpha = 0;
	setSavedDvar( "cg_disableBackButton", "1" );

	

	level.bomber SetEnableSense(false);


	
	level.bomber.goalradius = 15;
	level.bomber SetEnableSense(false);
	level.bomber LockAlertState("alert_red");
	level.bomber setoverridespeed(28);
	level.bomber.script_radius = 28;
	level.bomber thread bomber_fail_on_death();

	wait(0.05);

	
	level.player playerSetForceCover(true, (0,-1,0));

	if(getdvarint("r_iswidescreen") == 1)
		level.player SetPlayerAngles((0,-61,0));
	else
		level.player SetPlayerAngles((0,-81,0));

	level.player disableweapons();
	maps\_utility::holster_weapons();
	
	level thread maps\_introscreen::introscreen_chyron(&"SHANTYTOWN_INTRO_01", &"SHANTYTOWN_INTRO_02", &"SHANTYTOWN_INTRO_03");
	wait(2);
	//level.cameraID = level.player customCamera_change( level.cameraID, "world", ( -1451.83, 1681.74, 210.95 ), ( 5.61, -88.73, 0), 2.0);
	level.player customCamera_pop(level.cameraID, 2);

	wait(2);

	
	
	bird_origin_1 = getent("bird_origin_1", "targetname");
	playfx( level._effect["bird"], bird_origin_1.origin );
	bird_origin_1 playsound("shanty_town_birds_flaps");
	level.player giveweapon( "p99" );


	

	level.carter_pool stopcmd(level.carter_anim);
	level.carter_pool stopcmd(level.carter_pool_anim_2);
	level.carter_anim = level.carter_pool cmdplayanim("Carter_Pain_Loop", false);
	level.carter_pool_anim_2 = level.carter_pool cmdplayanim("Carter_Pain_to_Alert", false);



	setSavedDvar( "cg_disableBackButton", "0" );
	


	//SetDVar("r_pipSecondaryMode", 5);
	//setSavedDvar("cg_drawHUD","1");


	bomber_start("bomber_path_start");

	
	level thread Timer_update();
	//wait(0.5);
	
	
	wait(0.5);
	level.player freezecontrols(false);
	
	
	//wait(1);
	//iprintlnbold("disable hud now");
	/*setdvar("cg_disableHudElements", 1);
	setDvar( "cg_disableHudElements", 0 );*/
	level.player playerSetForceCover(false, false);
	level.player customcamera_checkcollisions( 1 );
	wait(1);
	maps\_utility::letterbox_off();
	wait(2);
	maps\_autosave::autosave_now("shanty_town");

	

}


//ambience boat goes here
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

//setup up the boats
amb_boat(boat_1, origin_1, origin_2)
{

	goal = 2;
	on_route = 0; //0 = transis, 1 = complete;
	timer = 0;

	PlayFxOnTag( level._effect["shanty_speedboat_spray2"], boat_1, "tag_body" ); 

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

//last event carter going up and down on the stairs here
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
	level.carter setperfectsense(true);
	level.carter setcombatrole("support");
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

//setting up the last garage fight
setup_garage_fight()
{
	trigger = getent("kick_out_cargo_door", "targetname");
	trigger waittill("trigger");


	//maps\_autosave::autosave_now("shanty_town");
	level.end_debris = getent("show_debris_explosion", "targetname");
	level.end_debris hide();
	//level thread garage_fight();

	carter_spawn = getent("carter_spawn", "targetname");

	level.carter = carter_spawn stalingradspawn();
	//level.carter setignorethreat( level.carter_pool, true);
	level.carter thread magic_bullet_shield();
	level.carter setcandamage(false);
	level.carter SetPainEnable(false);
	level.carter setscriptspeed("run");
	level.carter setenablesense(false);

	wait(0.5);


	//level thread switch_with_carter();
	node_start = getnode("carter_cover_1", "targetname");
	level.carter setgoalnode(node_start);


}

//give bond the gun at beginning of the pool
give_bond_gun()
{

	level.player enableweapons();
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
	//	level.bar_thug_3 thread turn_off_Psense(2);
	level.bar_thug_4 lockalertstate("alert_red");
	//level.bar_thug_4 thread turn_off_Psense(2);
	level.bar_thug_4 cmdshootatentity(level.player, true, 5, 0);
	//magicgrenade(level.bar_thug_4.origin, level.player.origin, 1.5); 

	wait(2);


	if(isdefined(level.bar_thug_4))
	{
		level.bar_thug_4 stopallcmds();
		//level.bar_thug_4 lockalertstate("alert_red");
		level.bar_thug_4 setenablesense(true);
		level.bar_thug_4 setgoalnode(node_Cover_2, 1);
	}




}


//setting up all the objectives
setup_objectives()
{


	wait(10);
	trigger = GetEnt("beach_guard_retreat_trigger","targetname");
	objective_add( 1, "active", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_1");


	trigger waittill("trigger");
	objective_state(1, "done" );
	
	trigger = GetEnt("bomber_shoot_bond_trigger","targetname");
	objective_add( 2, "active", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_2");
	
	//Objective_State( 1, "done");
	trigger waittill("trigger");

	objective_state(2, "done" );
	trigger = GetEnt("trigger_end_fight","targetname");
	objective_add( 3, "active", &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_TITLE_1", trigger.origin, &"SHANTYTOWN_OBJECTIVE_FOLLOW_BOMBER_BODY_3");



	trigger waittill("trigger");
	objective_state(3, "done" );
	objective_add( 4, "active", &"SHANTYTOWN_OBJECTIVE_PROTECT_CARTER_NAME", level.carter.origin, &"SHANTYTOWN_OBJECTIVE_PROTECT_CARTER_BODY");


}


//setup all the vision in the level
setup_vision()
{

	trigger = [];
	trigger = getentarray("indoor_trigger", "targetname");
	beach = getent("beach_trigger", "targetname");
	//	iprintlnbold(trigger.size);
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
			//	iprintlnbold("indoor now");
		}
		else if(indoor == 0)
		{
			VisionSetNaked( "shantytown", 1 );
			//	iprintlnbold("outdoor now");
		}
		else if(indoor == 2)
		{

			VisionSetNaked( "shantytown_beach", 1 );
			//	iprintlnbold("beach now");

		}


		wait(1);

	}
	//SetSavedDVar( "r_filmSharpen", "0.195313" );

}


setup_civilians()
{
	//starting pool scene
	level.goal_1_reached = false;
	level.goal_2_reached = false;
	level.goal_3_reached = false;
	level.goal_4_reached = false;
	level.goal_5_reached = false;
	level.goal_6_reached = false;
	level.goal_7_reached = false;
	//wait(2);
	level thread flood_spawn_civ("civ_male_pool","civ_1_goal", level.goal_1_reached);
	

}

setup_bond()
{
	level.player takeallweapons();
	
	level.player thread player_death_vo();

	level.player allowProne( false );
	//Fov_Transition(80);
	SetSavedDVar( "r_godraysposx2", "-0.5");
	setsaveddvar( "r_godraysposx2", "-0.923329");
	while(!isdefined(level.bomber))
	{
		wait(0.01);
	}

	SetSavedDVar("ik_bob_pelvis_scale_1st","1.5");



	trigger = getent("exit_building", "targetname");
	trigger waittill("trigger");
	bird_origin_1 = getent("bird_origin_1", "targetname");
	bird_origin_2 = getent("bird_origin_2", "targetname");
	playfx( level._effect["bird"], bird_origin_1.origin );
	wait(0.5);
	playfx( level._effect["bird"], bird_origin_2.origin );
	level.player playsound("shanty_town_birds_flaps");
	node_goal = getnode("guard_cafe_goal", "targetname");




	carter_node = getnode("carter_pool_node", "targetname");
	trigger = getent("carter_get_up", "targetname");
	trigger waittill("trigger");

	




	level.carter_pool stopcmd(level.carter_anim);
	//wait(0.03);

	//
	//level.carter_pool stopallcmds();
	//
	wait(1);

	level.bar_thug_4 setgoalnode(node_goal);
	level.carter_pool setscriptspeed("sprint");
	level.carter_pool setgoalnode(carter_node);
	



	level.bar_thug_3 setscriptspeed("run");
	//level.bomber cmdaction("talka1");
	cover_node = getnode("kick_over", "targetname");
	trigger = GetEnt("give_gun_bond","targetname");
	trigger waittill("trigger");
	level thread give_bond_gun();
	level notify("bond_have_gun");


	//Fov_Transition(65);
	SetSavedDVar("ik_bob_pelvis_scale_1st","0");

	level.bomber stopallcmds();
	bomber_resume();
	level.bar_thug_3 stopallcmds();

	level.bar_thug_3 setenablesense(false);
	level.bar_thug_3 setgoalnode(cover_node, 1);
	
	level thread conversation_exchange();


	trigger = getent("fire_on_bond", "targetname");
	trigger waittill("trigger");
	SetDVar("sm_SunSampleSizeNear", 0.38);


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

	

	for(i = 0; i < 6; i++)
	{

		hitpos = origin.origin + ( x, 50, z );
		firepos = origin.origin + ( x, 30, z );	

		magicbullet( "FRWL_Shanty", hitpos, firepos);
		magicbullet( "FRWL_Shanty", firepos, hitpos);

		

		fx_spawn = Spawn( "script_model", origin.origin + (x, 0, z));	
		fx_spawn SetModel( "tag_origin" );
		//z = z * -1;
		fx_spawn.angles =  (10, 90, 0);
		fx = playfxontag( level._effect["bulletGodRays1"], fx_spawn, "tag_origin" );
		
		bar_hole_sound = spawn( "script_origin", (-554, -758, 100));
		bar_hole_sound playsound ("shanty_bar_hole");
		//iprintlnbold ("SOUND: bar hole");
				

		x = randomint(30);
		z = randomint(30);

		wait(0.1);



	}
	
	wait(1);




	godray_array = [];
	godray_array = getentarray("bullet_godray", "targetname");

	origin = getent("bullet_start_here", "targetname");
	x = 0;
	z = 0;
	var = 1;
	oldvalue = 0;
	currentvalue = 0;

	level notify("fx_bar_shooting1");
	//level.player enableHealthShield(true);
	for ( i=0; i<15; i++ )
	{

		hitpos = origin.origin + ( x, 30, z );
		firepos = origin.origin + ( x, 50, z );	
		magicbullet( "FRWL_Shanty", firepos, hitpos);

	

		fx_spawn = Spawn( "script_model", origin.origin + (x, 0, z));	
		fx_spawn SetModel( "tag_origin" );
		//z = z * -1;
		fx_spawn.angles =  (10, 90, 0);
		fx = playfxontag( level._effect["bulletGodRays1"], fx_spawn, "tag_origin" );
		
		bar_hole_sound = spawn( "script_origin", (-554, -758, 100));
		bar_hole_sound playsound ("shanty_bar_hole");
		//iprintlnbold ("SOUND: bar hole");

		if(var > 0)
		{
			z = currentvalue;
			z += randomint(7);
		}
		else
		{
			currentvalue = z;
			z -= randomint(5);

		}

		x -= randomintrange(6, 15);
		var *= -1;

	
		wait( 0.1 );

	}
	exploder = [];
	exploder = getentarray("window_exploder", "targetname");
	fish = getent("bar_fish_falling", "targetname");
	origin = getent(fish.target, "targetname");
	fish linkto(origin);
	origin rotateto((0, 0, -88), 0.5, 0.4, 0.1);
	//shanty_town_falling_bar
	level.player playsound("shanty_town_falling_bar");
	level notify("fx_bar_shooting2");
	wait(0.4);
	//level thread bar_explode();
	for(i = 0; i < exploder.size; i++)
	{

		physicsExplosionCylinder(exploder[i].origin, 50, 1, 1 );

	}
}
conversation_exchange()
{

	level.player play_dialogue_nowait("CART_ShanG_001A", true);
	wait(5);
	level.player play_dialogue("BOND_ShanG_002A", true);

}

setup_bomber()
{


	while(!isdefined(level.bomber))
	{
		wait(0.01);
	}
	wait(3);
	//wait(1);


	switch( getdvar( "skipto") )
	{
	case "container":
	case "Container":
		//move player to new position
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_container","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		//move bomber to new position			
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_container_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		//start bomber on path	
		bomber_start("bomber_container_start");
		break;

	case "gauntlet":
	case "Gauntlet":
		//move player to new position
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_gauntlet","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		//move bomber to new position
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_gauntlet_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		//start bomber on path	
		bomber_start("bomber_gauntlet_start");
		break;

	case "pool":
	case "Pool":
		//move player to new position
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_pool","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		//move bomber to new position					
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_pool_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		//start bomber on path
		bomber_start("bomber_pool_start");
		break;

	

	case "garage":
	case "Garage":
		//move player to new position
		rail = spawn("script_origin",level.player.origin);
		level.player linkto( rail );
		location = GetEnt("skipto_garage","targetname");
		rail moveto(location.origin,.05);
		rail waittill("movedone");
		rail rotateto(location.angles,.05);
		rail waittill("rotatedone");
		level.player unlink();

		//move bomber to new position					
		rail = spawn("script_origin",level.bomber.origin);
		level.bomber linkto( rail );	
		bomber_location = GetEnt("bomber_garage_origin","targetname");
		rail moveto(bomber_location.origin,.05);
		rail waittill("movedone");
		level.bomber unlink();

		level notify("thug_backup");

		//start bomber on path
		bomber_start("bomber_garage_start");
		break;

	default:
		break;
	}
}



bomber_fail_on_death()
{
	self waittill("death");
	//test
	level.player thread mission_fail_vo() ;
	//missionfailed();
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
	SetDVar("sm_SunSampleSizeNear", 0.38);


	//level.bomber cmdshootatentity(level.player, false, 1, 1);
	//level.bomber waittill("cmd_done");

	bomber_resume();
	



	//wait(5);

	//thread hud_text_uninterruptible("Carter: Bond, I see the bomber.", 5000);
	//iprintlnbold("Bond, I can cut the bomber off!");

	wait(1);
	level thread maps\_autosave::autosave_now("shanty_town");
	//level thread set_timer_base_on_difficulty(60);



}

chase_shoot_bar(origin)
{


	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );



}
bar_explode()
{
	origin = [];
	origin = getentarray("radius_explosion_origin", "targetname");

	for(i = 0; i < origin.size; i++)
	{

		physicsExplosionSphere( origin[i].origin, 150, 10, 0.5 );
		//iprintlnbold("SOUND: bar_explode");

	}




}
chase_finish_bar(origin)
{
	bomber_pause();

	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
	//level thread maps\_autosave::autosave_now("shanty_town");

	trigger = getent("dock_trigger_touch", "targetname");
	trigger waittill("trigger");


	/*trigger = GetEnt("trigger_bar_run","targetname");
	trigger waittill("trigger");*/
	level.bomber stopallcmds();
	//trigger delete();
	bomber_resume();

	//level.chase_timer = 0;
	//level thread maps\_utility::timer_restart(99);
	//level thread set_timer_base_on_difficulty(89);




}


beach_fight()
{
	trigger = GetEnt("dock_trigger","targetname");
	trigger waittill("trigger");
	SetDVar("sm_SunSampleSizeNear", 0.38);
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	setExpFog( 0, 3173, 0.59375, 0.632813, 0.695311, 2, 0.835);


	if(level.xenon)
		level thread dock_guard_moving();

	remove_dead_from_array( level.retreating_guard );

	node_1 = getnode("retreat_1", "targetname");
	node_2 = getnode("retreat_2", "targetname");
	node_3 = getnode("retreat_3", "targetname");

	origin_target_1 = getent("bar_door_left", "targetname");
	origin_target_2 = getent("bar_door_right", "targetname");
	if(isdefined(level.retreating_guard[0]))
	{
		level.retreating_guard[0] cmdshootatentity(level.player, 1, 2);
	}
	
	if(isdefined(level.retreating_guard[1]))
	{
	level.retreating_guard[1] cmdshootatentity(level.player, 1, 2);
	}

	if(isdefined(level.retreating_guard[2]))
	{
		level.retreating_guard[2] setgoalnode(node_2, 1);
		//level.retreating_guard[2] setcombatrole("turret");
	}

	wait(2);


	if(isdefined(level.retreating_guard[2]))
	{
		//level.retreating_guard[2] setgoalnode(node_2, 1);
		level.retreating_guard[2] setcombatrole("turret");
	}

	if(isdefined(level.retreating_guard[2]))
	{
		level.retreating_guard[2] stopallcmds();
		level.retreating_guard[2] cmdshootatentity(level.player, true, -1, 0.5, true);
	}
	if(isdefined(level.retreating_guard[0]))
	{
		
		level.retreating_guard[0] setgoalnode(node_1, 1);
	}
	if(isdefined(level.retreating_guard[1]))
	{
		
		level.retreating_guard[1] setgoalnode(node_3, 1);
	}

	for(i = 0; i < level.retreating_guard.size; i++)
	{
		if(isdefined(level.retreating_guard[i]))
		{
		level.retreating_guard[i] setenablesense(true);

		}
		
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
			wait(3);


		}



	}
	remove_dead_from_array( level.beach_guard );
	for(i = 0; i < level.beach_guard.size; i++)
	{	
		if(isalive(level.beach_guard[i]))
		{
			level.beach_guard[i] stopallcmds();
			//	wait(0.01);
			level.beach_guard[i] leavecover();
			//level.beach_guard[i] SetEnableSense(false);
			level.beach_guard[i] allowedstances("stand");
			level.beach_guard[i] setscriptspeed("sprint");
			level.beach_guard[i] cmdshootatentity(level.player, true, -1, 0.1);
			level.beach_guard[i] setgoalnode(delete_node, 1);
			/*	level.beach_guard[i].tetherpt = delete_node.origin;
			level.beach_guard[i].tetherradius = 1;*/
			wait(3);

		}


	}

	//level.player play_dialogue_nowait("BOMB_ShanG_008A");	
	//wait(3);
	//level thread set_timer_base_on_difficulty(60);
	level thread maps\_autosave::autosave_now("shanty_town");
	level.nextgoal = getent("skipto_alley", "targetname");
	//level.player play_dialogue_nowait("CART_ShanG_024A");	


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
	//dock_thug_2 SetEnableSense(true);
	//dock_thug_1 SetEnableSense(true);
	dock_thug_1 stopallcmds();
	dock_thug_2 stopallcmds();

	//wait(1);
	//dock_thug_2 SetEnableSense(false);
	//dock_thug_1 SetEnableSense(false);


	dock_thug_1 setgoalnode(goal_node);
	dock_thug_2 setgoalnode(goal_node);




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
	//iprintlnbold("car is damaged");



}
dock_fight()
{


	wait(5);
	car_thug_origin = getent("car_thug_lock", "targetname");
	level.car_thug = spawn_enemy(getent("car_thug", "targetname"));
	level.car_thug SetEnableSense(false);
	level.car_thug linkto (car_thug_origin);
	level.car_thug allowedstances("crouch");
	level.car_thug thread magic_bullet_shield();
	level.car_thug animscripts\shared::placeWeaponOn( level.car_thug.weapon, "none" );

	health = level.car_thug getnormalhealth();

	car_dest = getent("car_dest_beach", "targetname");
	level.car = getent("m60_car", "targetname");
     
	//level.car notsolid();
	level.car.health = 5000;
	level thread check_car_health();
	//car = getent("m60_car", "targetname");
	car_clip = getent("car_clip", "targetname");
	dest = getent("car_dest", "targetname");

	armor = getent("vehicle_armor", "targetname");
	barrel_1 = getent("vehicle_barrel_1", "targetname");
	barrel_2 = getent("vehicle_barrel_2", "targetname");
	barrel_3 = getent("vehicle_barrel_3", "targetname");
	barrel_4 = getent("vehicle_barrel_4", "targetname");
	//armor_stand = getent("truck_dock_armor_stand", "targetname");


	turret_origin = getent("shanty_turret_origin", "targetname");

	level.fx_spawn = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn SetModel( "tag_origin" );
	//z = z * -1;
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





	car_clip linkto(level.car);
	level.car_thug LockAlertState("alert_red");
	car_thug_origin linkto(level.car);
	level.lookat_trigger = false;
	level.dmg_trigger = false;
	//level thread playexhaustoncars();
	level thread trigger_check();
	level thread trigger_look_at();
	//	trigger = GetEnt("trigger_bar_run","targetname");

	/*trigger waittill("trigger");*/
	while(true)
	{
		if(level.lookat_trigger == true || level.dmg_trigger == true)
			break;

		wait(0.05);

	}
	node_veh = getvehiclenode(level.car.target, "targetname");
	level.car startpath(node_veh);
	//iprintlnbold("SOUND: dock car pulls up");
	level.car playsound("truck_pull_up");

	level notify("dock_fight_start");
	//level thread playdirtoncars();

	//iprintlnbold("stupid trigger");



	level thread move_and_shoot();

	wait(0.5);
	level notify("banana_banner_start");
	level notify("seagull_sitting_start");
	for(i = 0; i < origin_box.size; i++)
	{
		//physicsExplosionSphere(origin_box[i].origin, 100, 10, 5);
	}



	wait(1.5);
	level notify("finish_moving");
	level.direction = 0;
	level.beach_car_dead = false;
	level thread Shield_Turret_rotation();
	level.car_thug stop_magic_bullet_Shield();

	//car thread truck_flip();

	//
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

			//	playfx(level._effect["m60_muzzle_flash_a"], turret_origin.origin);
		}
		else 
			break;

		bullet_fired += 1;
		wait(0.05);

	}

	//level.player PlaySound("shanty_town_leaving_truck","sound_done",false);
	//iprintlnbold("SOUND: truck pull away");
	wait(2);
	level thread delete_beach_car();
	level.player play_dialogue_nowait("TANN_ConsG_078D");




}

#using_animtree("vehicles");
truck_flip()
{

	//iprintlnbold("IT's called");
	self UseAnimtree(#animtree);
	self setanim(%v_truck_flip);
	
	//iprintlnbold("SOUND: Truck flip");
	self playsound("truck_flip");
	
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
	//shanty_turret_shield linkto(shanty_turret);
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

	//wait(2);
	level.bomber CmdMeleeEntity( thug );

	//wait until door is broken
	level waittill("door_down");

	//shoot thug
	level.bomber stopcmd();
	if( isalive(thug) )
	{
		thug stopcmd();
		wait(1);
		thug dodamage(thug.health+5,thug.origin);
	}

	//take off
	bomber_start("bomber_alley_start");
	//level thread bomber_knock_over_ramp();
}


monitor_triggers()
{
	level.checkpoint_reached = false;

}

level_end()
{
	trigger = GetEnt("trigger_level_end","targetname");
	trigger waittill("trigger");
	Objective_State(7, "done");
	maps\_endmission::nextmission();
	//changelevel("constructionsite",false,3);	
}



garage_fight()
{
	//counter = 0;
	//iprintlnbold("garage_fight called");
	trigger = getent("save_final_event_trigger", "targetname");
	trigger waittill("trigger");


	level thread maps\_autosave::autosave_now("shanty_town");

	trigger = getent("trigger_end_fight", "targetname");
	trigger waittill("trigger");
	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	setExpFog( 1045, 12513, 0.7890, 0.7812, 0.7344, 2, 1);
	level.carter setenablesense(true);
	
	//It really doesn't seem right for him to say this here, and his delivery is too relaxed - CRussom
	//level.carter play_dialogue("CART_ShanG_025A");
	
	/*level notify("kill_timer");
	if(isdefined(level.timerbg))
		level.timerbg destroy();

	if(isdefined(level.timer))
		level.timer destroy();*/
	
	
	destination = [];
	destination = getentarray("end_shooter_target", "targetname");
	origin = getent("shooter_origin", "targetname");
	level.bomber thread magic_bullet_shield();
	

	level thread init_last_event();
	level thread switch_with_carter();


	SetDVar("sm_SunSampleSizeNear", 0.38);
	level.nextgoal = getent("carter", "targetname");


	for(i = 0; i < destination.size; i++)
	{
		level thread fire_magic_bullet_area(origin.origin, destination[i].origin, 5);
		//level.player dodamage((level.player.health / 100), level.player.origin);

	}

}

init_last_event()
{

	level.car_3 = getent("m60_car_wave_3", "targetname");
	level.car_3.health = 10000;
	level.car_3 show();
	level.car_3 thread setup_car_driver();
	level thread trigger_engagement();
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
	wait(1);

	////CART_ShanG_518A
	level.carter play_dialogue_nowait("CART_ShanG_518A");
	objective_state(4, "done" );
	objective_add( 5, "active", &"SHANTYTOWN_DEFEND_RIGHT_TITLE", level.carter.origin, &"SHANTYTOWN_DEFEND_RIGHT_BODY");
	//iprintlnbold("event 2 starts");
	level thread Right_wave();

	wait(6);
	level thread wave_2_car_attack();

	while(level.last_event_wave_2_1 == false || level.car_wave_2_over == false)
	{

		wait(1);

	}

	//level thread maps\_autosave::autosave_now("shanty_town");
	//wait(2);
	//objective_state(5, "done" );
	//objective_add( 6, "active", &"SHANTYTOWN_DEFEND_LEFT_TITLE", level.carter.origin, &"SHANTYTOWN_DEFEND_LEFT_BODY");

	//level thread left_wave();
	//level.player play_dialogue_nowait("CART_ShanG_517A");

	/*while(level.last_event_wave_3_1 == false)
	{

		wait(1);

	}*/

	level thread maps\_autosave::autosave_now("shanty_town");
	wait(2);
	level thread last_wave_guard();
	level thread wave_3_car_attack();

	wait(13);
	objective_state(5, "done" );
	
	objective_add( 6, "active", &"SHANTYTOWN_TAKE_OUT_TRUCK_TITLE", level.carter.origin, &"SHANTYTOWN_TAKE_OUT_TRUCK_BODY");
	level thread setup_propane_throw();
	propane_2 = getent("large_propane_1", "script_noteworthy");
	//level thread propane_setup(trigger, propane_2);

	propane_2 waittill("death");
	level notify("board_chuck_start");

	level.propane_dead = true;
	earthquake(1, 3, level.player.origin, 150);	
	level.player shellshock("default", 2);

	wait(1);
	
	level.carter setenablesense(false);
	level.carter stopallcmds();
	node = getnode("carter_wave_node", "targetname");
	level.carter setgoalnode(node);
	level thread carter_wave_at_bond();

	trigger = getent("bomber_run_touch", "targetname");
	trigger waittill("trigger");
	level.carter play_dialogue_nowait("CART_ShanG_013A");
	level.bomber stopallcmds();
	wait(0.05);
	bomber_resume();

	


}
carter_wave_at_bond()
{

	level.carter waittill("goal");
	//level thread maps\_utility::timer_restart(30);

	//level.player play_dialogue_nowait("CART_ShanG_806A");
	while(1)
	{
		level.carter CmdAction("CallOut");
		wait(5);

	}

}

last_wave_guard()
{



	bottom_1_spawn = getent("garage_bottom_1", "targetname");
	node_1 = getnode("bottom_3_goal_node", "targetname");
	bottom_4_spawn = getent("garage_bottom_4", "targetname");
	//node_2 = getnode("bottom_3_goal_node", "targetname");


		Support_1 = bottom_1_spawn stalingradspawn();
		Support_1 setscriptspeed("sprint");
		//Support_1 thread turn_off_perfect_Sense();
		support_1 setgoalnode(node_1, 1);
		support_1 setcombatrole("support");

	while(level.propane_dead == false)
	{

		if(!isdefined(Support_1))
		{
		Support_1 = bottom_1_spawn stalingradspawn();
		Support_1 setscriptspeed("sprint");
		//Support_1 thread turn_off_perfect_Sense();
		//support_1 setgoalnode(node_1, 1);
		//support_1 set_turret_goal("flanker");
		support_1 setcombatrole("support");
		}

		wait(5);
	}
	flee_1 = getnode("flee_node_1", "targetname");
	flee_2 = getnode("flee_node_2", "targetname");
	if(isdefined(Support_1))
	{
		Support_1 setenablesense(false);
		Support_1 allowedstances("stand");
		Support_1 stopallcmds();
		wait(0.05);

		Support_1 setscriptspeed("sprint");
		Support_1 setgoalnode(flee_1, 0);
		Support_1 on_goal_delete();



	}




}
on_goal_delete()
{
	self waittill("goal");
	self delete();


}

set_timer_base_on_difficulty(timer)
{

	if(getdvarint("level_gameskill") == 0)
	{
		//iprintlnbold("difficulty = 0");
		level thread maps\_utility::timer_restart(timer + 10);
	}
	else if(getdvarint("level_gameskill") == 1)
	{
		//iprintlnbold("difficulty = 1");
		level thread maps\_utility::timer_restart(timer + 5);	
	}
	else if(getdvarint("level_gameskill") == 2)
	{
		//iprintlnbold("difficulty = 2");
		level thread maps\_utility::timer_restart(timer);
	}
	else if(getdvarint("level_gameskill") == 3)
	{
		//iprintlnbold("difficulty = 3");
		level thread maps\_utility::timer_restart(timer - 5);
	}





}

delete_all()
{

		flee_2 = getnode("flee_node_2", "targetname");
		enemies = getaiarray("axis");

		for(i = 0; i < enemies.size; i++)
		{

			enemies[i] setgoalnode(flee_2, 0);
			enemies[i] on_goal_delete();

		}
	
		

	

}

set_turret_goal(roletype)
{

	level endon("board_chuck_start");

	if(isdefined(level.carter))
	{
		//iprintlnbold("ignoring carter");
		self setignorethreat(level.carter, true);
	}


	self waittill("goal");
	self setperfectsense(false);
	self setcombatrole(roletype);
	self SetCombatRoleLocked(true);


}
Right_wave()
{

	Right_1_spawn = getent("wave_2_guard_1", "targetname");
	Right_2_spawn = getent("wave_2_guard_2", "targetname");
	Right_3_spawn = getent("wave_2_guard_3", "targetname");
	Right_4_spawn = getent("wave_2_guard_4", "targetname");
	Right_5_spawn = getent("wave_2_guard_5", "targetname");
	level.wave = 0;

	origin = getentarray("magic_Grenade_origin", "targetname");

	node_1 = getnode("wave_2_cover_1", "targetname");
	node_2 = getnode("wave_2_cover_2", "targetname");
	node_3 = getnode("wave_2_cover_3", "targetname");
	node_4 = getnode("wave_2_cover_4", "targetname");
	node_5 = getnode("wave_2_cover_5", "targetname");

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
	turret_2 setgoalnode(node_3, 1);
	turret_3 thread set_turret_goal("support");
	turret_3 magicgrenade(turret_3.origin, origin[2].origin, 3);

	wait(3);

	turret_4 = Right_4_spawn stalingradspawn();
	turret_4 setscriptspeed("run");
	turret_4 setgoalnode(node_4, 1);	
	turret_4 thread set_turret_goal("turret");
	turret_4 magicgrenade(turret_4.origin, origin[3].origin, 3);

	wait 3;
	turret_5 = Right_5_spawn stalingradspawn();
	//origin = getent("exploder_wave_3_2", "targetname");
	turret_5 setscriptspeed("run");
	turret_5 setgoalnode(node_5, 1);	
	turret_5 thread set_turret_goal("rusher");
	turret_5 magicgrenade(turret_5.origin, origin[4].origin, 3);

	flankers[0] = turret_4;
	flankers[1] = turret_5;
	level thread right_wave_failsafe(flankers);

	wait(15);

	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3) || isdefined(turret_4) || isdefined(turret_5))
	{
		wait(1);
	}

	//wait(5);
	level.last_event_Wave_2_1 = true;
}

// failsafe for guy potentially getting stuck in a spot the player can't shoot at, causing the guy to stay alive and the script not progressing
right_wave_failsafe(flankers)
{
	level.right_wave_failsafe_cancel_count = 0;

	// cancel this failsafe if the guys get to their goals
	for (i = 0; i < flankers.size; i++)
	{
		flankers[i] thread right_wave_failsafe_cancel(flankers.size);
	}

	level endon("right_wave_failsafe_cancel");

	// waittill there's only 2 guys left
	while (true)
	{
		ai = GetAIArray("axis");
		if (ai.size <= 3)
		{
			break;
		}

		wait .5;
	}

	for (i = 0; i < flankers.size; i++)
	{
		//if (!SightTracePassed(level.player GetEye(), flankers[i] GetEye(), false))
		if (!flankers[i] CanSee(level.player))
		{
			flankers[i] DoDamage(flankers[i].health << 1, flankers[i].origin);
		}
	}
}

right_wave_failsafe_cancel(cancel_count)
{
	self waittill_either("death", "goal");
	level.right_wave_failsafe_cancel_count++;
	if (level.right_wave_failsafe_cancel_count == cancel_count)
	{
		level notify("level.right_wave_failsafe_cancel");
	}
}

left_wave()
{


	Right_1_spawn = getent("wave_3_guard_1", "targetname");
	Right_2_spawn = getent("wave_3_guard_2", "targetname");
	Right_3_spawn = getent("wave_3_guard_3", "targetname");
	Right_4_spawn = getent("wave_3_guard_4", "targetname");
	Right_5_spawn = getent("wave_3_guard_5", "targetname");
	level.wave = 0;

	//origin = getentarray("magic_Grenade_origin", "targetname");

	node_1 = getnode("wave_3_cover_1", "targetname");
	node_2 = getnode("wave_3_cover_2", "targetname");
	node_3 = getnode("wave_3_cover_3", "targetname");
	node_4 = getnode("wave_3_cover_4", "targetname");
	node_5 = getnode("wave_3_cover_5", "targetname");

	turret_1 = Right_1_spawn stalingradspawn();
	turret_1 setscriptspeed("run");
	turret_1 setgoalnode(node_1, 1);	
	turret_1 thread set_turret_goal("support");
	//turret_1 magicgrenade(turret_1.origin, origin[0].origin, 3);

	turret_2 = Right_2_spawn stalingradspawn();
	turret_2 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_2 thread set_turret_goal("support");
	//turret_2 magicgrenade(turret_2.origin, origin[1].origin, 3);

	turret_3 = Right_3_spawn stalingradspawn();
	turret_3 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_3 thread set_turret_goal("support");
	//turret_3 magicgrenade(turret_3.origin, origin[2].origin, 3);



	turret_4 = Right_4_spawn stalingradspawn();
	origin = getent("exploder_wave_3_1", "targetname");
	physicsExplosionSphere(origin.origin , 20, 1, 5);

	turret_4 setscriptspeed("run");
	turret_4 setgoalnode(node_4, 1);	
	turret_4 thread set_turret_goal("turret");

	//turret_4 magicgrenade(turret_4.origin, origin[3].origin, 3);
	wait(3);

	turret_5 = Right_5_spawn stalingradspawn();
	origin = getent("exploder_wave_3_2", "targetname");
	physicsExplosionSphere(origin.origin , 20, 1, 5);
	turret_5 setscriptspeed("run");
	turret_5 setgoalnode(node_5, 1);	
	turret_5 thread set_turret_goal("rusher");
	//turret_5 magicgrenade(turret_5.origin, origin[4].origin, 3);


	timer = 0;

	
	wait(15);
	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3) || isdefined(turret_4) || isdefined(turret_5))
	{

		wait(1);

	}


	//wait(5);
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
	turret_1 thread set_turret_goal("flanker");

	turret_2 = top_2_spawn stalingradspawn();
	turret_2 setscriptspeed("run");
	turret_2 setgoalnode(node_2, 1);
	turret_2 thread set_turret_goal("flanker");

	turret_3 = top_3_spawn stalingradspawn();
	turret_3 setscriptspeed("run");
	turret_2 setgoalnode(node_3, 1);
	turret_3 thread set_turret_goal("flanker");

	wait(15);
	

	while(isdefined(turret_1) || isdefined(turret_2) || isdefined(turret_3))
	{

		wait(1);

	}


	//wait(5);
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
	//Support_1 thread turn_off_perfect_Sense();
	support_1 setgoalnode(node_1, 1);
	Support_1 thread set_turret_goal("support");


	Support_2 = bottom_2_spawn stalingradspawn();
	Support_2 setscriptspeed("run");
//	Support_2 thread turn_off_perfect_Sense();
	support_2 setgoalnode(node_2, 1);
	Support_2 thread set_turret_goal("flanker");

	wait(3);
	Support_3 = bottom_3_spawn stalingradspawn();
	Support_3 setscriptspeed("run");
	//Support_3 thread turn_off_perfect_Sense();
	support_3 setgoalnode(node_3, 1);
	Support_3 thread set_turret_goal("flanker");


	//Support_4 = bottom_4_spawn stalingradspawn();
	//Support_4 setscriptspeed("run");
	////Support_4 thread turn_off_perfect_Sense();
	//support_4 setgoalnode(node_4, 1);
	//Support_4 thread set_turret_goal("support");

	

	wait(15);
	while(isdefined(Support_1) || isdefined(Support_2) || isdefined(Support_3))
	{

		wait(1);

	}


	//wait(5);
	level.last_event_wave_1_2 = true;


}




setup_propane_throw()
{

	//level endon("board_chuck_start");

	garage_door_left = getent("garage_door_left", "targetname");
	garage_door_right = getent("garage_door_right", "targetname");
	level.door_guard = spawn_enemy(getent("guard_kicking_door", "targetname"));
	level.door_guard allowedstances("stand");
	level.door_guard thread magic_bullet_Shield();
	level.door_guard SetPainEnable(false);
	level.door_guard setcombatrole("turret");
	propane_origin = getent("attach_propane", "targetname");
	propane = getent("throw_propane", "targetname");
	propane_node = getnode("throw_propane_tank", "targetname");
	bottom_4_spawn = getent("garage_bottom_4", "targetname");
	Support_4 = bottom_4_spawn stalingradspawn();
	support_4 setenablesense(false);
	Support_4 setscriptspeed("sprint");
	level thread max_accuracy();
	//level.door_guard setgoalnode(propane_node);
	//level.door_guard waittill("goal");
	garage_door_left rotateto((0, -89, 0), 0.5, 0.3, 0.2);
	if(isdefined(support_4))
	{
	support_4 setenablesense(true);
	support_4 setcombatrole("turret");
	garage_door_right rotateto((0, 90, 0), 0.5, 0.3, 0.2);
	garage_door_right connectpaths();
	}

	wait(0.5);
	level thread throw_propane_at_bond();
	level.door_guard stop_magic_bullet_Shield();
	level.door_guard SetPainEnable(true);
	
	if(	level.propane_dead == true && IsDefined(level.door_guard))
	{
		level.door_guard dodamage(level.door_guard.health *2, level.door_guard.origin);
	}	
}

throw_propane_at_bond()
{

	//door_guard = spawn_enemy(getent("guard_kicking_door", "targetname"));
	//
	//iprintlnbold("at goal now");
	propane = getent("throw_propane", "targetname");
	window_destroy = getent("blow_open_window", "targetname");
	//origin = getent("window_explosion", "targetname");
	origin_blow = getent("propane_explosion_origin", "targetname");
	propane unlink();
	
	propane movegravity((-590, -100, 370), 1.23);
	node = getnode("carter_cover_2", "targetname");
	level.carter setgoalnode(node);
	//window_destroy connectpaths()
	wait(3);
	playfx( level._effect["default_explosion"], origin_blow.origin );
	origin_blow playsound ("shanty_town_big_explosion");
	
	physicsExplosionSphere(origin_blow.origin, 700, 1, 4);
	//	playfx( level._effect["smoke_large"], origin.origin );
	earthquake(1, 3, level.player.origin, 150);	
	level.player shellshock("default", 2);
	//level.player playerSetForceCover(true, (0, 0, 0)); 

	if(level.player istouching(window_destroy))
	{
		level.player playerSetForceCover(false, true); 
	}
	level.end_debris show();
	window_destroy connectpaths();
	window_destroy delete();
	//InvalidateNode(GetNode("invalid_this_node", "targetname"));
	
	propane delete();
	garage_door_left = getent("garage_door_left", "targetname");
	garage_door_right = getent("garage_door_right", "targetname");
	garage_door_left delete();
	garage_door_right delete();


}




bomber_garage_pause(origin)
{
	bomber_pause();
	level.bomber CmdPlayAnim( "Bomber_Exhausted_Cycle", false );
}

civ_alley_amb()
{

	blind_1 = getentarray("window_hinge_fold_1", "targetname");
	blind_2 = getentarray("window_hinge_fold_2", "targetname");
	hinge_1 = getentarray("window_hinge_set_1", "targetname");
	hinge_2 = getentarray("window_hinge_set_2", "targetname");



	for(i = 0; i < blind_1.size; i++)
	{
		blind_1[i] rotateto((75, 0, 0), 0.5);
		hinge_1[i] rotateto((-50, 0, 0), 0.5);
	}

	trigger = getent("kick_out_cargo_door", "targetname");
	trigger waittill("trigger");


	for(i = 0; i < blind_2.size; i++)
	{
		blind_2[i] rotateto((70, 0, 0), 0.5);
		hinge_2[i] rotateto((-50, 0, 0), 0.5);
	}

	wait(5);

	bird_origin_1 = getent("bird_origin_5", "targetname");
	bird_origin_2 = getent("bird_origin_6", "targetname");
	bird_origin_1 playsound("shanty_town_birds_flaps");
	bird_origin_2 playsound("shanty_town_birds_flaps");

	playfx( level._effect["bird"], bird_origin_1.origin );
	wait(1);
	playfx( level._effect["bird_1"], bird_origin_2.origin );




}

blinds_init()
{

	right_flaps_north = getentarray("right_flap_north", "targetname");
	left_flaps_north = getentarray("left_flap_north", "targetname");



	for(i = 0; i < right_flaps_north.size; i++)
	{
		right_flaps_north[i] thread start_right_flap_north();
		left_flaps_north[i] thread start_left_flap_north();



	}


	right_flaps_south = getentarray("right_flap_south", "targetname");
	left_flaps_south = getentarray("left_flap_south", "targetname");

	for(i = 0; i < right_flaps_south.size; i++)
	{
		right_flaps_south[i] thread start_right_flap_south();
		left_flaps_south[i] thread start_left_flap_south();



	}




}
start_right_flap_south()
{

	while(true)
	{


		//	x = randomintrange(-50, -30);
		self rotateto((0, 90, 0), randomintrange(2,4));
		self waittill("rotatedone");
		self rotateto((0, 0, 0), randomintrange(1,3));
		self waittill("rotatedone");



	}


}

start_left_flap_south()
{
	while(true)
	{

		x = randomintrange(-50, -30);
		self rotateto((0,  -50, 0), randomintrange(2,4));
		self waittill("rotatedone");
		self rotateto((0, 0, 0), randomintrange(1,3));
		self waittill("rotatedone");



	}


}

start_right_flap_north()
{

	while(true)
	{


		x = randomintrange(30, 60);
		self rotateto((0, -70, 0), randomintrange(2,4));
		self waittill("rotatedone");
		self rotateto((0, -20, 0), randomintrange(1,3));
		self waittill("rotatedone");



	}


}

start_left_flap_north()
{
	while(true)
	{

		x = randomintrange(30, 74);
		self rotateto((0, 70, 0), randomintrange(2,4));
		self waittill("rotatedone");
		self rotateto((0, 20, 0), randomintrange(1,3));
		self waittill("rotatedone");



	}


}

window_fall_start(trigger)
{
	window = getent(trigger.target, "targetname");


	trigger waittill("trigger");
	
	window rotatepitch(70, 0.3);
	


}

window_fall_init()
{


	level notify("window_flap_01_start");
	wait(1);
	level notify("window_flap_02_start");
	





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
			level.player playsound("shanty_town_shaking_door");
			//level.player playsound("dog_bark");
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
	//door = getent("dog_behind_door", "targetname");
	trigger = getentarray("dog_bark_trigger", "targetname");

	for(i = 0; i < trigger.size; i++)
	{

		level thread dog_bark_start(trigger[i]);


	}


}


shack_door_bash()
{
	
	trigger = GetEnt("trigger_bash_door","targetname");
	//trigger SetHintString("Press &&1 to bash");
	door = GetEnt("doorA_script","targetname");
	door RotateTo((0, 15, 0), .05);
	trigger waittill("trigger");
	door PlaySound("shanty_town_door_bash");
	door RotateTo((0, 90, 0),.05);


	level notify("door_down");

	
	wait(2);
	//level thread civ_alley_amb();
	//trigger waittill("trigger");
	trigger delete();
	//door RotateTo((90,0, 0),.5);




	//setExpFog(level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0, level.fogmax);
	setExpFog( 0, 875, 0.7890, 0.7812,  0.7344, 2, 0.835);

	
	wait(0.05);
	door RotateTo((0, 80, 0), 5);
	//iprintlnbold("SOUND: shack door bash");
	door playsound("shanty_door_slam");

	trigger = getent("bomber_camera_shift", "targetname");
	trigger waittill("trigger");

	//level.player SecurityCustomCamera_Change(level.cameraID_bomber, "entity", level.bomber, level.bomber, (-114.64, -12.73, 74.82), ( -16.64, -6.74, 0.0), 1.5);

}









// gets array of origins for random fire bursts.  creates a random int based on array's size + 1, should b flexible for future additions.





spawn_warehouse_guard()
{

	trigger = getent("spawn_ware_house_guard", "targetname");
	trigger waittill("trigger");

	door = getent("shack_guard_door" , "targetname");
	door PlaySound("shanty_town_door_bash");
	door RotateTo((0, 110, 0), 0.5);
	
	door playsound("shanty_town_door_with_tires");
	wait(0.2);
	physicsExplosionCylinder(door.origin, 150, 30, 4 );
	wait(0.2);
	//node = getnode("shack_door_bash_node", "targetname");
	door connectpaths();

	level thread civ_alley_spawn();

	guard_spawn = [];

	guard_spawn = getentarray("dock_ware_house_thug", "targetname");
	for(i = 0; i < guard_spawn.size; i++)
	{

		guard_spawn[i] stalingradspawn();

	}


	wait(10);
	if(isdefined(level.car))
	{
		level thread delete_beach_car();
	}


	//savegame("shanty_town");






}

delete_beach_car()
{


	car_Dest = getent("car_dest_end", "targetname");
	/*car = getent("m60_car", "targetname");*/
	gate_node = getvehiclenode( "car_stop_node", "targetname" );
	shanty_turret_shield = getent("shanty_turret_shield", "targetname");
	shanty_turret = getent("shanty_turret", "targetname");
	turret_origin = getent("shanty_turret_origin", "targetname");
	armor = getent("vehicle_armor", "targetname");
	//armor_stand = getent("truck_dock_armor_stand", "targetname");

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
	
	if(isdefined(level.car))
	{
	//iprintlnbold("SOUND: Truck pull away dock");
	//truck_leaving_sound = spawn( "script_origin", (1380, -1213, 189));
	level.car playsound ("shanty_town_leaving_truck");
	}
	
	level.car waittill("reached_end_node");

	if(isalive(level.car_thug))
	{
		//level.car_thug thread Stop_magic_bullet_Shield();
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
	/*if(isdefined(armor_stand))
	{

	armor_stand delete();
	}
	*/


}
delete_self(origin)
{

	//iprintlnbold("touch");
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

	//iprintlnbold("kick over table");
	trigger = getent("kick_table", "targetname");
	node = getnode("take_cover_on_table", "targetname");
	ent = getent("rotating_table", "targetname");
	trigger waittill("trigger");



	//ent rotateto((0, 90, 0), 0.001);
	//level.bar_thug_3 stopallcmds();
	level.bar_thug_3 cmdplayanim("thug_alrt_frontkick", true);
	//level.bar_thug_3 waittill("cmd_done");

	wait(1.3);
	ent rotateto((0, 0, -60), 0.3, 0.1, 0.2);
	//iprintlnbold("SOUND: table kick");
	ent playsound("shanty_table_kick");
	level.bar_thug_3 setenablesense(true);
	level.bar_thug_3 setgoalnode(node);
	level.bar_thug_3 waittill("goal");
	level.bar_thug_3 stopallcmds();
	level.bar_thug_3 CmdThrowGrenadeAtEntity(level.player, false, 1);


}

checkpoint()
{
	//wait(2);

	skipto = GetDVar( "skipto" );
	if(skipto == "beach")
	{

		bomber_spawner = GetEnt("bomber_spawner","targetname");
		origin = getent("bomber_skipto_origin", "targetname");
		level.bomber = spawn_enemy(bomber_spawner);
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
		Fov_Transition(65);
		SetSavedDVar("ik_bob_pelvis_scale_1st","0");


		level.player enableweapons();
		maps\_utility::unholster_weapons();
		level.player switchtoweapon( "p99");
		/*	SetDVar("r_pipSecondaryMode", 0)*/;
		level.nextgoal = getent("skipto_alley", "targetname");
		//level thread goal_arrow();
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
		level.bomber = spawn_enemy(bomber_spawner);
		level.bomber SetEnableSense(false);
		level.bomber linkto(origin);


		skip = getent("skipto_alley", "targetname");
		node = getnode("bomber_skipto_alley", "targetname");
		/*	level.bomber teleport(node.origin + (40, 0 ,30), (0, 0, 0));
		level.bomber setgoalnode(node);*/

		origin moveto(node.origin + (-40, 0 ,90), 0.01);
		wait(1);
		level.bomber unlink();
		level.bomber stopallcmds();
		level.bomber setgoalnode(node);

		level.player setorigin(skip.origin);
		level.player setplayerangles(skip.angles);

		wait(3);
		Fov_Transition(65);
		SetSavedDVar("ik_bob_pelvis_scale_1st","0");
		/*SetDVar("r_pipSecondaryMode", 0);*/
		level.nextgoal = getent("trigger_level_end", "targetname");

		//level thread setup_camera();
		level.player enableweapons();
		maps\_utility::unholster_weapons();
		//level.player switchtoweapon( "p99");

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
		/*level.carter stopallcmds();
		level.carter cmdshootatentity(enemies[randomint(enemies.size)], false, 5, 0.5, true);*/
		wait(0.1);

	}

}

//thanks to senior don.
//thanks to Junior MOI for part of the code.
//function take in a string, milisec in time and an optional bool which will increase the font size to 2 and make the line print in the middle.
//also the function already taken cares of moving lines up as more text shows up.
hud_text_uninterruptible(text, time_ms, optional)
{

	//this while loop will find an empty line to print the text into.


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

	//iprintlnbold("loading text " + notused);


	//this if/for loop will move all the lines currently on screen up and print the new line in their old place.
	if (IsDefined(level.control_hud[notused]))
	{
		level.control_hud[notused].inuse = true;
		for(i = 0 ; i < level.totalhudelement; i++)
		{
			if(level.control_hud[i].inuse == true && i != notused)
			{
				level.control_hud[i].y -= 20;
				//iprintlnbold("text is moving up " + notused);
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


//initalize the new hud elements here.
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

//reset 1 hud element here.
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


	wait(5);
	car_thug_origin = getent("car_thug_lock_wave_2", "targetname");
	level.car_thug_2 = spawn_enemy(getent("car_thug_wave_2", "targetname"));
	level.car_thug_2 SetEnableSense(false);
	level.car_thug_2 linkto (car_thug_origin);
	level.car_thug_2 allowedstances("crouch");
	level.car_thug_2 thread magic_bullet_shield();
	level.car_thug_2 animscripts\shared::placeWeaponOn( level.car_thug_2.weapon, "none" );

	//health = level.car_thug_2 getnormalhealth();


	level.car_2 = getent("m60_car_wave_2", "targetname");
	level.car_2 show();
	level.car_2.health = 20000;



	car_clip = getent("car_clip_wave_2", "targetname");


	armor = getent("vehicle_armor_wave_2", "targetname");
	barrel_1 = getent("vehicle_barrel_1_wave_2", "targetname");
	barrel_2 = getent("vehicle_barrel_2_wave_2", "targetname");
	barrel_3 = getent("vehicle_barrel_3_wave_2", "targetname");
	barrel_4 = getent("vehicle_barrel_4_wave_2", "targetname");
	//armor_stand = getent("truck_dock_armor_stand", "targetname");


	turret_origin = getent("shanty_turret_origin_wave_2", "targetname");

	level.fx_spawn_2 = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn_2 SetModel( "tag_origin" );
	////z = z * -1;
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
	level.direction_2 = 0;
	car_clip linkto(level.car_2);
	level.car_thug_2 LockAlertState("alert_red");
	car_thug_origin linkto(level.car_2);

	node_veh = getvehiclenode(level.car_2.target, "targetname");
	level.car_2 startpath(node_veh);
	//iprintlnbold("SOUND: truck pull up two");
	level.car_2 playsound("truck_pull_up_2");



	level thread move_and_shoot_2();
	wait(4);
	level thread Shield_Turret_rotation_2();
	

	//level.car_thug_2 stop_magic_bullet_Shield();


	bullet_fired = 0;
	timer = 0;
	while(isalive(level.car_thug_2))
	{


		if(!isalive(level.car_thug_2))
		{
			break;
		}
		level.car_thug_2 cmdaimatentity(level.player, false, -1);

	
		if(isalive(level.car_thug_2))
		{
			magicbullet("p99", turret_origin.origin, level.player.origin + (randomintrange(-20, 20), randomintrange(-20, 20),  randomintrange(30, 50)));

			if((bullet_fired % 2) == 0)
				fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_2, "tag_origin");

			//	playfx(level._effect["m60_muzzle_flash_a"], turret_origin.origin);
		}
		else 
			break;

		//bullet_fired += 1;
		wait(0.15);

		timer += 0.15;

		if(timer >= 8)
			break;


	}
	
	shanty_turret_shield linkto(level.car_2);
	shanty_turret linkto(level.car_2);
	
	gate_node = getvehiclenode( "car_stop_node_wave_2", "targetname" );
	maps\_vehicle::path_gate_open(gate_node);

	level.car_wave_2_over = true;
	//iprintlnbold ("SOUND: truck two pull away");
	level.car_2 playsound ("shanty_town_leaving_truck_2");
	
	wait(5);
	
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

		if(timer > 2)
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
	//shanty_turret_shield linkto(shanty_turret);
	while(true)
	{
		
		wait(0.25);
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		//angles[1] = shanty_turret_shield.angles[1];
		//angles[2] = shanty_turret_shield.angles[2];
		shanty_turret_shield rotateto((0, angles[1] + 250, 0), 0.06);

		

		timer += 0.07;
		if(timer >= 18)
			break;

		wait(0.07);
	}


}

wave_3_car_attack()
{


	wait(5);
	car_thug_origin = getent("car_thug_lock_wave_3", "targetname");
	level.car_thug_3 = spawn_enemy(getent("car_thug_wave_3", "targetname"));
	level.car_thug_3 SetEnableSense(false);
	level.car_thug_3 linkto (car_thug_origin);
	level.car_thug_3 allowedstances("stand");
	level.car_thug_3 thread magic_bullet_shield();
	level.car_thug_3 animscripts\shared::placeWeaponOn( level.car_thug_3.weapon, "none" );

	//health = level.car_thug getnormalhealth();



	


	car_clip = getent("car_clip_wave_3", "targetname");


	armor = getent("vehicle_armor_wave_3", "targetname");
	barrel_1 = getent("vehicle_barrel_1_wave_3", "targetname");
	barrel_2 = getent("vehicle_barrel_2_wave_3", "targetname");
	barrel_3 = getent("vehicle_barrel_3_wave_3", "targetname");
	barrel_4 = getent("vehicle_barrel_4_wave_3", "targetname");
	//armor_stand = getent("truck_dock_armor_stand", "targetname");


	turret_origin = getent("shanty_turret_origin_wave_3", "targetname");

	level.fx_spawn_3 = Spawn( "script_model", turret_origin.origin);	
	level.fx_spawn_3 SetModel( "tag_origin" );
	////z = z * -1;
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
	level.direction_3 = 0;
	car_clip linkto(level.car_3);
	level.car_thug_3 LockAlertState("alert_red");
	car_thug_origin linkto(level.car_3);

	node_veh = getvehiclenode(level.car_3.target, "targetname");
	//level.car_3 show();
	level.car_3 startpath(node_veh);
	
	//iprintlnbold("SOUND: final truck approach");
	level.car_3 playsound("truck_pull_up_final");
	




	//level thread move_and_shoot_3();
	wait(7);
	level thread Shield_Turret_rotation_3();
	



	bullet_fired = 0;
	timer = 0;
	level.car_3 thread self_healing();
	while(isalive(level.car_thug_3))
	{


		if(!isalive(level.car_thug_3))
		{
			break;
		}
		level.car_thug_3 cmdaimatentity(level.player, false, -1);

		if(isalive(level.car_thug_3))
		{
			magicbullet("p99", turret_origin.origin, level.player.origin + (randomintrange(-20, 20), randomintrange(-20, 20),  randomintrange(30, 50)));

			//if((bullet_fired % 2) == 0)
				fx = playfxontag(level._effect["m60_muzzle_flash"], level.fx_spawn_3, "tag_origin");

			//	playfx(level._effect["m60_muzzle_flash_a"], turret_origin.origin);
		}
		else 
			break;

		bullet_fired += 1;
		wait(0.15);

		if(bullet_fired > randomintrange(30, 40))
		{
			bullet_fired = 0;
			wait(randomintrange(1, 2));

		}


		if(level.propane_dead == true)
			break;




	}
	car_clip delete();
	armor delete();
	barrel_1 delete();
	barrel_2 delete();
	barrel_3 delete();
	barrel_4 delete();
	shanty_turret_shield delete();
	shanty_turret delete();
	level.car_3 playsound ("shanty_town_big_explosion");
	playfx( level._effect["default_explosion"], level.car_3.origin );
	level.car_thug_3 thread stop_magic_bullet_Shield();
	level.car_thug_3 delete();
	//level.car_3 thread stop_magic_bullet_Shield();
	level.car_3 delete();

	fake_car = getent("fake_car", "targetname");
	fake_car show();
	fake_car solid();

	fake_car truck_flip();

	wait(0.25);
	level thread slow_time_new( .25, 1.25, 0.5 );
	//fake_car playsound("shanty_town_building_explosion");
	level waittill("timescale_stopped");
	fx = playfxontag(level._effect["medium_fire_2"], fake_car, "tag_passenger01");
	fx = playfxontag(level._effect["car_landing_effect"], fake_car, "tag_passenger01");
	//iprintlnbold("SOUND: truck flip landing"); 
	fake_car playsound("shanty_town_building_explosion");
	objective_state(6, "done" );
	objective_add( 7, "active", &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_NAME", (5168, 464, 104), &"SHANTYTOWN_OBJECTIVE_GET_TO_DIGGER_BODY");




}
self_healing()
{
	self endon("death");

	while(true)
	{
		if(isdefined(self))
		{
	
			self.health = 50000;


		}
		else
			break;

		wait(1);
	}


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
	turret_origin unlink();
	shanty_turret unlink();
	shanty_turret_shield unlink();
	turret_origin linkto(shanty_turret);
	timer = 0;
	//shanty_turret_shield linkto(shanty_turret);
	while(isdefined(shanty_turret_shield))
	{
		
		
		vect = level.player.origin - shanty_turret.origin;
		vect = vectornormalize(vect);
		angles = vectortoangles(vect);
		shanty_turret rotateto(angles, 0.06);
		//angles[1] = shanty_turret_shield.angles[1];
		//angles[2] = shanty_turret_shield.angles[2];
		shanty_turret_shield rotateto((0, angles[1] + 90, 0), 0.06);

		//if(level.beach_car_dead == true)
		//	break;

		
		/*if(timer >= 18)
			break;*/

		wait(0.07);
	}


}
civ_alley_spawn()
{
	civ_1_spawn = getent("civ_alley_1", "targetname");
	civ_2_spawn = getent("civ_alley_2", "targetname");
	civ_3_spawn = getent("civ_alley_3", "targetname");
	node_1 = getnode("civ_door_1_node", "targetname");
	node_2 = getnode("civ_door_2_node", "targetname");
	node_3 = getnode("civ_door_3_node", "targetname");
	door_1 = getent("civ_door_1", "targetname");
	door_2 = getent("civ_door_2", "targetname");

	trigger = getent("spawn_ware_house_guard", "targetname");
	
	level.civ_array = [];

	civ_1 = civ_1_spawn stalingradspawn();
	civ_1 animscripts\shared::placeWeaponOn( civ_1.weapon, "none" );
	civ_1 SetEnableSense(false);
	level.civ_array[0] = civ_1;
	//new_civ LockAlertState("alert_yellow");
	civ_1 setoverridespeed(15);
	civ_2 = civ_2_spawn stalingradspawn();
	civ_2 animscripts\shared::placeWeaponOn( civ_2.weapon, "none" );
	civ_2 SetEnableSense(false);
	level.civ_array[1] = civ_2;
	//new_civ LockAlertState("alert_yellow");
	civ_2 setoverridespeed(15);
	civ_3 = civ_3_spawn stalingradspawn();
	civ_3 animscripts\shared::placeWeaponOn( civ_3.weapon, "none" );
	civ_3 SetEnableSense(false);
	//new_civ LockAlertState("alert_yellow");
	civ_3 setoverridespeed(15);
	level.civ_array[2] = civ_3;

	level thread check_civ_health();

	trigger = getent("bomber_shoot_bond_trigger", "targetname");
	trigger waittill("trigger");
	

	civ_1 civ_on_goal(node_1, door_1);

	trigger = getent("set_civ_2", "targetname");
	trigger waittill("trigger");

	civ_2 civ_on_goal(node_2, door_2);

	trigger = getent("set_civ_3", "targetname");
	trigger waittill("trigger");
	//iprintlnbold("civ 3 start");

	civ_3 civ_on_goal(node_3);


	
	







}
check_civ_health()
{

	health_1 = level.civ_array[0] getnormalhealth();
	while(1)
	{

		if(isdefined(level.civ_array[0]))
		{
			if(health_1 > level.civ_array[0] getnormalhealth())
				missionfailedwrapper();

		}

			if(isdefined(level.civ_array[1]))
		{
			if(health_1 > level.civ_array[1] getnormalhealth())
				missionfailedwrapper();

		}

		if(isdefined(level.civ_array[2]))
		{
			if(health_1 > level.civ_array[2] getnormalhealth())
				missionfailedwrapper();

		}

		wait(0.1);


	}



}

civ_on_goal(node, door)
{
	self setscriptspeed("sprint");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
	if(isdefined(door))
	{
		door rotateto((0, 90, 0), 0.5);
	}

}

#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver") + (24, 0, -10) );
	driver.angles = self.angles;
	driver character\character_thug_1_shanty::main();
	driver LinkTo( self, "tag_driver" );
	
	// play anims
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
	
	// delete at end node.
	level waittill("board_chuck_start");
	driver delete();
}

trigger_engagement()
{

	level endon("board_chuck_start");
	trigger = getent("end_level_engagement_trigger", "targetname");


	while(true)
	{
		
		if(level.player istouching(trigger))
		{

		}
		else
		{
			wait(5);
			level.carter play_dialogue_nowait("CART_ShanG_044A");
			wait(5);
			if(level.player istouching(trigger))
				continue;
			else
			{

				level.player play_dialogue_nowait("CART_ShanG_011A");
				wait(10);
				if(level.player istouching(trigger))
					continue;
				else
				{
					
					level.player play_dialogue("CART_ShanG_029A");
					missionfailedwrapper();
					break;


				}
			
			}
		


		}
		wait(0.5);

	}



}
max_accuracy()
{

	level endon("board_chuck_start");


	turret_origin = getent("shanty_turret_origin_wave_3", "targetname");
	trigger = getent("bond_out_in_open", "targetname");
	trigger waittill("trigger");

	
	fx_spawn_3 = Spawn( "script_model", turret_origin.origin);	
	fx_spawn_3 SetModel( "tag_origin" );

	while(isalive(level.car_thug_3))
	{
		if(!isalive(level.car_thug_3))
		{
			break;
		}
		level.car_thug_3 cmdaimatentity(level.player, false, -1);

		if(isalive(level.car_thug_3))
		{
			magicbullet("p99", turret_origin.origin, level.player.origin + (0, 0, 50));

			//if((bullet_fired % 2) == 0)
				fx = playfxontag(level._effect["m60_muzzle_flash"], fx_spawn_3, "tag_origin");

			//	playfx(level._effect["m60_muzzle_flash_a"], turret_origin.origin);
		}
		else 
			break;

		wait(0.15);

	

		if(level.propane_dead == true)
			break;




	}

	





}






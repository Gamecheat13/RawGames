#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_debug;
#include maps\_music;

#include maps\pby_fly_zeros;
#include maps\pby_fly_ms_guys;
#include maps\pby_fly_merchant_destruction;


main()
{
	//-- First Thing the Level Has To Do
	level.mapCenter = (-5000,0,0);
	SetMapCenter(level.mapCenter);
	SetSavedDvar("compassMaxRange", 10000);
		
	maps\pby_fly_fx::main();
	
	level.scr_model[ "player_hands" ] = "viewmodel_usa_pbycrew_player";
	
	//STANDARD USE VEHICLES
	maps\_aircraft::main( "vehicle_usa_aircraft_f4ucorsair", "corsair", 2, undefined, "jap_zero_turret");
	maps\_aircraft::main( "vehicle_jap_airplane_zero_fly", "zero", 0 );
	
	//PBY SPECIFIC VEHICLES
	build_player_planes("pby_blackcat"); //- The black night time raid skin of the pby
	build_player_planes("fletcher_destroyer");
	build_enemy_vehicles("zero");
	build_enemy_vehicles("jap_ptboat");
	build_enemy_vehicles("jap_shinyo");
	build_enemy_vehicles("jap_merchant_ship");
	
	init_flags(); //-- This needed to happen before _flare
	//maps\_flare::main( "tag_origin", undefined, "white" );
	
	
	//INITIALIZE MERCHANT SHIP DRONES
	level.droneExtraAnims = ::ms_guys_init;
	level.droneCustomDeath = ::ms_soldier_deaththread;
	maps\_drone::init();
	
	//-- reset the values for max drones because this is not a co-op level and they replace the AI in the level.
	level.max_drones["allies"] = 999;
	level.max_drones["axis"] = 999;
	level.max_drones["neutral"] = 999;
	
	//-- Precache some stuff
	precachemodel("makin_raft_rubber");
	precachemodel("static_peleliu_lifeboat");
	precacheitem("type99_lmg");
	precacheitem("pby_20mm");
	precacheitem("jap_zero_turret");
	precachemodel("vehicle_jap_airplane_zero_d_wingr");
	precachemodel("vehicle_jap_airplane_zero_d_wingl");
	precachemodel("vehicle_jap_airplane_zero_d_tail");
	precachemodel("vehicle_jap_airplane_zero_minus_lwing");
	precachemodel("vehicle_jap_airplane_zero_minus_rwing");
	precachemodel("vehicle_jap_airplane_zero_minus_tail");
	
	//-- great white shark
	precachemodel("greatwhite_shark2");
	precachemodel("greatwhite_shark2_dmg1");
	precachemodel("greatwhite_shark2_dmg2");
	
	//-- bullet holes for tail of pby
	precachemodel("vehicle_usa_pby_bulletholes01");
	precachemodel("vehicle_usa_pby_bulletholes02");
	precachemodel("vehicle_usa_pby_bulletholes03");
	
	precachemodel("vehicle_usa_pby_bulletholes04");
	precachemodel("vehicle_usa_pby_bulletholes05");
	precachemodel("vehicle_usa_pby_bulletholes06");
	precachemodel("vehicle_usa_pby_bulletholes07");
	
	precachemodel("vehicle_usa_pby_tailsect_fx01");
	
	precachemodel("vehicle_usa_pby_blisterleft_glass01");
	precachemodel("vehicle_usa_pby_blisterright_glass01");
	
	//-- damage models
	precachemodel("vehicle_usa_pby_radiosect_damage01");
	precachemodel("vehicle_usa_pby_radiosect_damage02");
	precachemodel("vehicle_usa_pby_wingleft_damage01");
	precachemodel("vehicle_usa_pby_wingright_damage01");
	
	
	//-- models for ptboat
	//precachemodel("vehicle_jap_ship_ptboat_seta");
	precachemodel("vehicle_jap_ship_ptboat_setb");
	precachemodel("vehicle_jap_ship_ptboat_setc");
	
	//-- fletcher pieces
	precachemodel("vehicle_usa_ship_fletcher_chunk1");
	precachemodel("vehicle_usa_ship_fletcher_chunk2");
	precachemodel("vehicle_usa_ship_fletcher_chunk3");
	precachemodel("vehicle_usa_ship_fletcher_chunk4");
	precachemodel("vehicle_usa_ship_fletcher_chunk5");
	precachemodel("vehicle_usa_ship_fletcher_turretgun");
	precachemodel("vehicle_usa_ship_fletcher_turretgun_barrel");
	precachemodel("vehicle_usa_ship_fletcher_oerlikon");
	precachemodel("vehicle_usa_ship_fletcher_oerlikon_barrel");
	
	//-- fletcher decals
	precachemodel("vehicle_usa_ship_fletcher_decal0");
	precachemodel("vehicle_usa_ship_fletcher_decal1");
	precachemodel("vehicle_usa_ship_fletcher_decal2");
	precachemodel("vehicle_usa_ship_fletcher_decal3");
	precachemodel("vehicle_usa_ship_fletcher_decal4");
	precachemodel("vehicle_usa_ship_fletcher_decal5");
	precachemodel("vehicle_usa_ship_fletcher_decal6");
	precachemodel("vehicle_usa_ship_fletcher_decal7");
	precachemodel("vehicle_usa_ship_fletcher_decal8");
	precachemodel("vehicle_usa_ship_fletcher_decal9");
	
	//-- other stuff
	precachemodel("tag_origin");
	//precachemodel("prop_pby_pinup");
	precacheshellshock("pby_flak");
	precachestring(&"PBY_FLY_SWITCH_FRONT");
	precachestring(&"PBY_FLY_SWITCH_LEFT");
	precachestring(&"PBY_FLY_SWITCH_REAR");
	precachestring(&"PBY_FLY_SWITCH_RIGHT");
	precachestring(&"PBY_FLY_RESCUE");
	precachestring(&"PBY_FLY_PBY_NAME_A");
	precachestring(&"PBY_FLY_PBY_NAME_B");
	precachestring(&"PBY_FLY_PBY_SQUAD");
	precachestring(&"SCRIPT_PLATFORM_PBY_FLY_ADS_HINT");
	
	//-- precache hud icons
	precacheShader("hud_pby_score_ptboat");
	precacheShader("hud_pby_score_rescue");
	precacheShader("hud_pby_score_ship");
	precacheShader("hud_pby_score_zero");
	
	//-- rumble go!!
	precacheRumble("explosion_generic");
	precacheRumble("damage_light");
	precacheRumble("damage_heavy");

	//-- Checkpoints and Default Starts
	add_start( "boat_strafe", ::jumpto_event2_strafe_boats, &"STARTS_PBY_BOATS" );
	add_start( "media", 			::jumpto_event2_media, &"STARTS_PBY_BOATS");
	add_start( "pacing", 			::jumpto_event3, &"STARTS_PBY_SUNRISE" );
	add_start( "rescue", 			::jumpto_event4, &"STARTS_PBY_RESCUE" );
	add_start( "getaway", 		::jumpto_event6, &"STARTS_PBY_LANDING" );
	add_start( "zeroes", 			::jumpto_initial_zeroes, &"STARTS_PBY_LANDING" );
	add_start( "rescue_3", 		::jumpto_event4_part3 );
		
	//default_start( ::jumpto_event3 );
	default_start( ::event1_new );
		
	//level.custom_introscreen = ::pby_custom_introscreen;
	level.callbackSaveRestored = ::pby_callback_saveRestored;
				
	maps\_load::main(); 
	
	maps\pby_fly_anim::main();
	
	//set up Ambient Packages 	
	maps\pby_fly_amb::main();
	
	filter_out_names();
	//level thread scriptmodel_dump();
}

pby_callback_saveRestored()
{
	maps\_callbackglobal::Callback_SaveRestored();
	
	SetSavedDvar( "compass", "0");
	SetSavedDvar( "hud_showStance", "0" ); 
	SetSavedDvar( "ammoCounterHide", "1" );
		
	level notify("no_manual_switch");
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
	}
}

my_level_init()
{
	wait_for_first_player();
	
	level.player = get_players()[0];
	
	my_level_init_difficulty();
	
	//-- The player needs to fall off the gun and be unable to fire when he dies.
	level.player thread player_death_off_turret();
	
	//-- Mike said to add this
	level.player player_flag_set("loadout_given");
	
	//-- Disable watersheeting, but need to turn it on at specific times for some fx
	//EnableWaterSheetFX(0);
	
	//-- no damage for the player and no rest for the wicked
	level.player EnableInvulnerability();
	level.player.save_anim = false;
	
	//-- Turn off the depth of field for the level
	level.level_specific_dof = true;
	level.player SetDepthOfField(100, 100, 500, 500, 5, 1.5);
	
	//setup the players viewangles
	level.default_pitch_down = GetDVar("player_view_pitch_down");
	level.ventral_turret_pitch = 86;
	level.player AllowCrouch(false);
	level.player AllowProne(false);
	level.max_spawns = 0;
	
	level.no_save_prompt = false;
	
	level thread delete_extra_pbys();
	level thread stat_counter();
	level thread pby_wait_for_free_spawn();
	
	//-- Basic Level Var Setup
	level.undef = Spawn("script_origin", (0,0,0));
	assert(IsDefined(level.undef), "undefined entity is undefined...");
	
	//-- init flying vars
	level.max_speed = 60; //PBY
	level.zero_max_speed = 120;
	level.zero_min_speed = 70;
	level.total_zeros_spawned = 0;
	level.MAX_ZEROS = 24; //-- shouldn't need this anymore
	level.WATER_LEVEL = 63;
	level.plane_on_curve = 0;
	level.max_pts_shooting = 6;
	level.current_pts_shooting = 0;
	
	// used in the PBY ai functions
	level.GUN_FRONT = 0;
	level.GUN_LEFT  = 1;
	level.GUN_RIGHT = 2;
	level.GUN_REAR  = 3;
	level.TURRET_RANGE = 5000;
	
	//DVar
	//SetDVar( "r_waterSheetingFX_enable", 0 );
	SetSavedDVar( "sm_sunAlwaysCastsShadow", 1 );
	
	//-- Setup the players on the plane
	setup_player_planes();
	
	//-- Debris and Ships for event 2	
	my_level_init_ocean_debris();
	my_level_init_ocean_ships();
	level thread init_drone_manager();
	
	
	//-- Setup The Player
	level.player.plane = level.plane_a;
	level.player setup_seat_control();
	level.player.in_transition = false;
	level.player thread move_to_required_seat(); //-- also runs the saving code
	level.player DisableTurretDismount();
	wait(0.15);
	level.player force_players_into_seat("starting");
	
	init_callbacks();
	
	/#
	
	run_special_debug_functions();
	
	#/
	
	level thread disable_manual_switching();
	level thread end_scripting_for_burn();
	level thread setup_pby_compass_menu();
	level thread good_kill_dialogue();
	level thread close_hit_dialogue();
	//level thread pby_player_crash();
	
	//-- thank you liberator
	level.bomber_wind_shake = 1;
	level thread random_turbulence();
	level thread static_turbulence();
	
	//-- track achievement
	//level thread track_vehicle_achievement();
	level thread track_spotlight_achievement();
	//level thread debug_hud_elems();
}

my_level_init_difficulty()
{
	difficulty = GetDifficulty();
	
	switch( difficulty )
	{
		case "easy":
			level.bullet_hits_before_swap = 5;
			level.damage_transfered_to_player = 20;
		break;
		
		case "medium":
			level.bullet_hits_before_swap = 3;
			level.damage_transfered_to_player = 20;
		break;
		
		case "hard":
			level.bullet_hits_before_swap = 3;
			level.damage_transfered_to_player = 20;
		break;
		
		case "fu":
			level.bullet_hits_before_swap = 3; //-- how many times a piece needs to be hit before it swaps
			level.damage_transfered_to_player = 20; //-- the amount of damage done to player per swap
		break;	
	}
}

player_death_off_turret()
{
	self waittill("death");
	
	for( i = 0; i < 4; i++)
	{
		level.plane_a DisableGunnerFiring(i, true);
	}
	
	death_anim = undefined;
	death_ref = " ";
	
	switch(self.current_seat)
	{
		case "pby_frontgun":
			death_anim = level.scr_anim[ "player_hands" ][ "pby_front_to_death" ];
			death_ref = "pby_front_to_death";
		break;
		case "pby_rightgun":
			death_anim = level.scr_anim[ "player_hands" ][ "pby_right_to_death" ];
			death_ref = "pby_right_to_death";
		break;
		case "pby_leftgun":
			death_anim = level.scr_anim[ "player_hands" ][ "pby_left_to_death" ];
			death_ref = "pby_left_to_death";
		break;
		case "pby_backgun":
			death_anim = level.scr_anim[ "player_hands" ][ "pby_back_to_death" ];
			death_ref = "pby_back_to_death";
		break;
	}
	
	self DisableWeapons();
	
	//-- Take the player off of the plane
	plane = level.plane_a;
	plane UseBy(self);
	
	//-- plays the animation	
	startorg = getstartOrigin( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), death_anim );
	startang = getstartAngles( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), death_anim );
	
	player_hands = spawn_anim_model( "player_hands" );
	player_hands.plane = plane;
	player_hands.direction = "right";
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;

	self playerlinktoabsolute(player_hands, "tag_player" );
	
	plane maps\_anim::anim_single_solo( player_hands, death_ref );
}

track_spotlight_achievement()
{
	//-- wait for 6 spotlights to be broken
	for( i = 0; i < 6; i++)
	{
		level waittill("a_spotlight_broke");
	}
	
	level.player maps\_utility::giveachievement_wrapper( "PBY_ACHIEVEMENT_LIGHTSOUT");
}

track_vehicle_achievement()
{
//	steel_tons_needed = 10000;
//	current_steel_count = 0;
	
//	while(1)
//	{
//		current_steel_count += level.merchant_ship_death_count * 2000;
//		current_steel_count += level.zero_death_count * 250;
//		current_steel_count += level.ptboat_death_count * 500;
		
//		if(current_steel_count >= steel_tons_needed)
//		{
//			break;
//		}
//		else
//		{
//			current_steel_count = 0;
//		}
//		
//		wait(0.5);
//	}

	while(1)
	{
		if ( level.zero_death_count >= 45 )
		{
			break;
		}
		wait 1;
	}	
	
	//ASSERTEX( false, "Achievement Unlocked" );
	level.player maps\_utility::giveachievement_wrapper( "PBY_ACHIEVEMENT_ZEROS");
}

setup_pby_compass_menu()
{
	compass_value = 0;
	level.yellow_damage = 1;
	level.red_damage = 2;

	//-- draw all of the primary states	(grey)
	SetDvar("ui_pby_damage_gunlt", 	compass_value);
	SetDvar("ui_pby_damage_winglt", compass_value);
	SetDvar("ui_pby_damage_gunrt", 	compass_value);
	SetDvar("ui_pby_damage_wingrt", compass_value);
	SetDvar("ui_pby_damage_nose", 	compass_value);
	SetDvar("ui_pby_damage_tail", 	compass_value);
	
	level.plane_a thread pby_compass_red_background();
	
	//-- Show the actual proper damage states on the pby
	level.plane_a thread pby_gun_left_damage();
	level.plane_a thread pby_gun_right_damage();
	level.plane_a thread pby_wing_left_damage();
	level.plane_a thread pby_wing_right_damage();
	level.plane_a thread pby_nose_damage();
	level.plane_a thread pby_tail_damage();
}

pby_gun_left_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	
	for( ; ; )
	{
		self waittill("pby_ltgun_damage");
		shot_count++;
		
		if( shot_count > yellow_damage )
		{
			SetDvar("ui_pby_damage_gunlt", level.yellow_damage );
		}
		else if( shot_count > red_damage )
		{
			SetDvar("ui_pby_damage_gunlt", level.red_damage );
		}
	}
}

pby_gun_right_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	
	for( ; ; )
	{
		self waittill("pby_rtgun_damage");
		shot_count++;
		
		if( shot_count > yellow_damage )
		{
			SetDvar("ui_pby_damage_gunrt", level.yellow_damage );
		}
		else if( shot_count > red_damage )
		{
			SetDvar("ui_pby_damage_gunrt", level.red_damage );
		}
	}
}

pby_wing_left_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	dead_damage = 150;
	
	for( ; ; )
	{
		self waittill("pby_ltwing_damage");
		shot_count++;
		
		if( shot_count > yellow_damage && !flag("pby_left_wing_dmg1"))
		{
			flag_set("pby_left_wing_dmg1");
		}
		else if( shot_count > red_damage && !flag("pby_left_wing_dmg2"))
		{
			flag_set("pby_left_wing_dmg2");
		}
		else if( shot_count > dead_damage && !flag("pby_left_wing_dmg3"))
		{
			flag_set("pby_left_wing_dmg3");
		}
	}
}

pby_wing_right_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	dead_damage = 150;
	
	for( ; ; )
	{
		self waittill("pby_rtwing_damage");
		shot_count++;
		
		if( shot_count > yellow_damage && !flag("pby_right_wing_dmg1"))
		{
			flag_set("pby_right_wing_dmg1");
		}
		else if( shot_count > red_damage && !flag("pby_right_wing_dmg2"))
		{
			flag_set("pby_right_wing_dmg2");
		}
		else if(shot_count > dead_damage && !flag("pby_right_wing_dmg3"))
		{
			flag_set("pby_right_wing_dmg3");
		}
	}
}

pby_nose_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	
	for( ; ; )
	{
		self waittill("pby_nose_damage");
		shot_count++;
		
		if( shot_count > yellow_damage )
		{
			SetDvar("ui_pby_damage_nose", level.yellow_damage );
		}
		else if( shot_count > red_damage )
		{
			SetDvar("ui_pby_damage_nose", level.red_damage );
		}
	}
}

pby_tail_damage()
{
	shot_count = 0;
	yellow_damage = 50;
	red_damage = 100;
	
	for( ; ; )
	{
		self waittill("pby_tail_damage");
		shot_count++;
		
		if( shot_count > yellow_damage )
		{
			SetDvar("ui_pby_damage_tail", level.yellow_damage );
		}
		else if( shot_count > red_damage )
		{
			SetDvar("ui_pby_damage_tail", level.red_damage );
		}
	}
}
	
pby_compass_red_background()
{
	self endon("death");
	
	while(true)
	{
		self waittill("damage");
		SetDVar( "ui_pby_damage_red", true );
		wait(0.1);
		SetDVar( "ui_pby_damage_red", false);
		wait(0.1);	
	}
}

my_level_init_ocean_debris()
{
	debris_array = GetEntArray("floating_debris", "targetname");
	
	level.debris_turn_1 = [];
	level.debris_turn_3 = [];
	
	//-- sort the debris
	y = 0;
	z = 0;
	for(i = 0; i < debris_array.size; i++)
	{
		if(debris_array[i].script_noteworthy == "ev2_debris_turn1")
		{
			level.debris_turn_1[y] = debris_array[i];
			y++;
		}
		else
		{
			level.debris_turn_3[z] = debris_array[i];
			z++;
		}
		
		debris_array[i] Hide();
	}
	
	level thread event2_debris_cleanup();
}

my_level_init_ocean_ships()
{
	//-- Hide the Boats
	level.boats = [];
	for(i = 0; i < 3; i++)
	{
		level.boats[i] = GetEnt("ev2_ship_" + i, "targetname");
		
		level.boats[i].bow = GetEnt(level.boats[i].targetname + "_bow", "targetname");
		//level.boats[i].bow LinkTo(level.boats[i], "bow_break_jnt");
		
		level.boats[i].aft = GetEnt(level.boats[i].targetname + "_aft", "targetname");
		//level.boats[i].bow LinkTo(level.boats[i], "aft_break_jnt");
		
		level.boats[i].glass1 = GetEnt(level.boats[i].targetname + "_glass1", "targetname");
		level.boats[i].glass1 LinkTo(level.boats[i], "aft_break_jnt");
		level.boats[i].glass2 = GetEnt(level.boats[i].targetname + "_glass2", "targetname");
		level.boats[i].glass2 LinkTo(level.boats[i], "aft_break_jnt");
		level.boats[i].glass3 = GetEnt(level.boats[i].targetname + "_glass3", "targetname");
		level.boats[i].glass3 LinkTo(level.boats[i], "aft_break_jnt");
		
		level.boats[i] Hide();
		level.boats[i].bow Hide();
		level.boats[i].aft Hide();
		level.boats[i].glass1 Hide();
		level.boats[i].glass2 Hide();
		level.boats[i].glass3 Hide();
		
		level.boats[i].sink_anim = "sink" + i;
		
		//-- Hide the destructibles on the boats
		
		level.boats[i].bow_destructibles = [];
		dest_target_name = "boat_" + i + "_dest_bow";
		level.boats[i].bow_destructibles = GetEntArray(dest_target_name, "targetname");
		for(j = 0; j < level.boats[i].bow_destructibles.size; j++)
		{
			level.boats[i].bow_destructibles[j] Hide();
		}
		
		level.boats[i].aft_destructibles = [];
		dest_target_name = "boat_" + i + "_dest_aft";
		level.boats[i].aft_destructibles = GetEntArray(dest_target_name, "targetname");
		for(j = 0; j < level.boats[i].aft_destructibles.size; j++)
		{
			level.boats[i].aft_destructibles[j] Hide();
		}
	}
	
	//-- Link the flags
	flag = GetEnt("boat_0_flag", "targetname");
	flag LinkTo(level.boats[0], "aft_break_jnt");
	flag = GetEnt("boat_1_flag", "targetname");
	flag LinkTo(level.boats[1], "aft_break_jnt");
	flag = GetEnt("boat_2_flag_bow", "targetname");
	flag LinkTo(level.boats[2], "bow_break_jnt");
	flag = GetEnt("boat_2_flag_aft", "targetname");
	flag LinkTo(level.boats[2], "aft_break_jnt");
	
	level thread show_boats();
}

show_boats()
{
	level waittill("move to front for intro");
	wait(3);
	
	for( i=0; i < level.boats.size; i++)
	{
		level.boats[i] Show();
		level.boats[i].bow Show();
		level.boats[i].aft Show();
		level.boats[i].glass1 Show();
		level.boats[i].glass2 Show();
		level.boats[i].glass3 Show();
		
		for(j = 0; j < level.boats[i].bow_destructibles.size; j++)
		{
			level.boats[i].bow_destructibles[j] Show();
		}
		for(j = 0; j < level.boats[i].aft_destructibles.size; j++)
		{
			level.boats[i].aft_destructibles[j] Show();
		}
	}
}

init_flags()
{
	flag_init( "turret_hud" );
	flag_init( "rescue_ready" );
	flag_init( "saver_ready" );
	flag_init( "zero_rescue_1_dead" );
	flag_init( "ptboat_rescue_1_dead" );
	
	//-- pby_damage flags
	flag_init( "pby_right_wing_dmg1" );
	flag_init( "pby_right_wing_dmg2" );
	flag_init( "pby_right_wing_dmg3" );
	flag_init( "pby_left_wing_dmg1" );
	flag_init( "pby_left_wing_dmg2" );
	flag_init( "pby_left_wing_dmg3" );
	
	//-- dialogue flags
	flag_init( "disable_random_dialogue" );
	
	//-- ammo flags
	flag_init( "pby_out_of_ammo" );
	flag_init( "pby_actually_out_of_ammo" );
	
	//-- targeting flag for ptboats
	flag_init("ok_to_shoot_at_player");
	
	flag_init("player_crashed");
	
	//-- rescue 2 ptboats
	flag_init("rescue_2_2nd_ptboats_spawned");
	flag_init("rescue_2_2nd_ptboats_killed");
	flag_init("rescue_2_3rd_ptboats_spawned");
	flag_init("rescue_2_3rd_ptboats_killed");
	
	//-- flags to help track objectives
	flag_init("merchant_ship_event_done");
	flag_init("respond_objective_done");
	flag_init("the level is done");
	
	flag_init("jumpto_used");
	
	//-- to make sure the player atleast kind of plays the level
	flag_init("player_shot_during_event2");
	flag_init("player_shot_during_event3");
	
	flag_init("20mm_shot");
}

end_scripting_for_burn()
{
	if(true)
	{
		return;
	}
	
	level.plane_a waittill("end_of_scripting_burn");
	iprintlnbold("STAY TUNED - MORE COMING SOON");
	wait(5);
	nextmission();
}

debug_hud_elems()
{
	level.seat_hud = newHudElem();
	level.seat_hud.alignX = "left";
	level.seat_hud.x = 20;
	level.seat_hud.y = 290;
	
	while(1)
	{
		level.seat_hud SetText(level.player.current_seat);
		wait(0.1);
	}	
}

//-- Co-op Callback Init
init_callbacks()
{
	level thread onPlayerConnect();
}

pby_damage_counter()
{
	total_damage = 0;
	
	while(1)
	{
		self waittill("damage", amount);
		
		total_damage += amount;
		iprintln("The PBYs current damage is: " + total_damage);
	}
}

//-- temp try at the 20mm cannon
player_controlled_20mm_cannon()
{
	level thread player_controlled_20mm_cannon_msg();
	
	wait(10);
	
	//level.player NotifyOnCommand( "fire_20mm", "+frag" );
	
	shots_fired = 0;
	
	//-- entities to play the flash FX on because it should probably move with the pby
	right_barrel = Spawn( "script_model", self.origin );
	right_barrel SetModel( "tag_origin" );
	right_barrel.origin = self GetTagOrigin( "tag_flash_gunner1" ) - (0,0,20) + (AnglesToForward( self GetTagAngles( "tag_flash_gunner1" ) ) * 24 + (AnglesToRight( self GetTagAngles( "tag_flash_gunner1" )) * 24 ));
	right_barrel.angles = self GetTagAngles( "tag_flash_gunner1" );
	right_barrel LinkTo(self, "tag_flash_gunner1");
	
	left_barrel = Spawn( "script_model", self.origin );
	left_barrel SetModel( "tag_origin" );
	left_barrel.origin = self GetTagOrigin( "tag_flash_gunner1" ) - (0,0,20) + (AnglesToForward( self GetTagAngles( "tag_flash_gunner1" ) ) * 24) - (AnglesToRight( self GetTagAngles( "tag_flash_gunner1" )) * 24 );
	left_barrel.angles = self GetTagAngles( "tag_flash_gunner1" );
	left_barrel LinkTo(self, "tag_flash_gunner1a");
	
	while(true && !flag("pby_out_of_ammo"))
	{
		while( level.player.current_seat != "pby_frontgun" || level.player.in_transition)
		{
			wait(0.05);
		}
		
		while( level.player.current_seat == "pby_frontgun" && !flag("pby_out_of_ammo"))
		{
			//level.player waittill( "fire_20mm" );
			//while( !level.player ButtonPressed("BUTTON_RSHLDR") )
			while( !level.player FragButtonPressed() )
			{
				wait(0.05);
			}

			pby_forward = AnglesToForward( level.plane_a.angles );
			gunner_barrel_origin = self GetTagOrigin("tag_gunner_barrel1");
			gunner_barrel_angles = self GetTagAngles("tag_gunner_barrel1");
			gunner_forward = AnglesToForward(gunner_barrel_angles);
			
			if(!level.player.in_transition && level.player.current_seat == "pby_frontgun" )
			{
				if(!flag("20mm_shot"))
				{
					flag_set("20mm_shot");
				}
			
				pitch_to_use = AngleNormalize180( gunner_barrel_angles[0] - level.plane_a.angles[0] );
				pitch_to_use = Clamp( pitch_to_use, 0, 15 );
				pitch_to_use = AngleNormalize360( pitch_to_use + level.plane_a.angles[0] );
				
				yaw_to_use = AngleNormalize180( gunner_barrel_angles[1] - level.plane_a.angles[1] );
				yaw_to_use = Clamp( yaw_to_use, -15, 15 );
				yaw_to_use = AngleNormalize360( yaw_to_use + level.plane_a.angles[1] );
				
				bullet_target = gunner_barrel_origin;
				bullet_target += AnglesToForward((pitch_to_use, yaw_to_use, gunner_barrel_angles[2])) * 5000;	
				
				right_barrel Unlink();
				left_barrel Unlink();
				
				right_barrel.origin = self GetTagOrigin( "tag_flash_gunner1" ) - (0,0,30) + (AnglesToForward( (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]) ) * 60) + (AnglesToRight( (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]) ) * 24 );
				//right_barrel.angles = self GetTagAngles( "tag_flash_gunner1" );
				right_barrel.angles = (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]);
				right_barrel LinkTo(self, "origin_animate_jnt");
				
				left_barrel.origin = self GetTagOrigin( "tag_flash_gunner1" ) - (0,0,30) + (AnglesToForward( (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]) ) * 60) - (AnglesToRight( (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]) ) * 24 );
				//left_barrel.angles = self GetTagAngles( "tag_flash_gunner1" );
				left_barrel.angles = (pitch_to_use, yaw_to_use, gunner_barrel_angles[2]);
				left_barrel LinkTo(self, "origin_animate_jnt");
	
					
				if( !flag("pby_out_of_ammo") )
				{
					if(shots_fired == 0)
					{
										
						PlayFXOnTag( level._effect["pby_20mm_flash"], right_barrel, "tag_origin");
						MagicBullet( "pby_20mm",right_barrel.origin + (AnglesToForward(right_barrel.origin) * 5), bullet_target, level.player);
						shots_fired++;
					}
					else
					{	
						PlayFXOnTag( level._effect["pby_20mm_flash"], left_barrel, "tag_origin");
						MagicBullet( "pby_20mm",left_barrel.origin + (AnglesToForward(left_barrel.origin) * 5), bullet_target, level.player);
						shots_fired--;
					}
					
					Earthquake(.5, 0.3, level.player.origin, 100);
					level.player PlayRumbleOnEntity( "damage_heavy" );
					playsoundatposition("amb_metal", (0,0,0));
					
					wait(0.2);
				}
			}
			
			wait(0.05);
		}
	}
	
	//-- out of ammo
	while( level.player.current_seat == "pby_frontgun")
	{
		while( !level.player FragButtonPressed() )
		{
			wait(0.05);
		}

		position = self GetTagOrigin( "tag_gunner_barrel1" );
	
		bullet_sound = Spawn("script_origin", position);
		bullet_sound LinkTo(self, "tag_gunner_barrel1" );
	
		bullet_sound playsound ("dryfire_rifle_plr", "click_done");
		bullet_sound waittill("click_done");						
		
		while( level.player FragButtonPressed() )
		{
			wait(0.05);
		}
		
		wait(1);
	}
}

Clamp( your_number, lower_number, higher_number )
{
	if( your_number < lower_number )
	{
		return( lower_number );
	}
	
	if( your_number > higher_number )
	{
		return( higher_number );
	}
	
	return( your_number );
}

AngleNormalize180( angle )
{
	if( angle > 180 )
	{
		angle -= 360;
	}
	
	return angle;
}

AngleNormalize360( angle )
{
	if( angle < 0 )
	{
		angle += 360;
	}
	
	return angle;
}

player_controlled_20mm_cannon_msg()
{
	if(flag("jumpto_used"))
	{
		return;
	}
	
	while( !IsDefined(level.player.current_seat))
	{
		wait(0.1);
	}
	
	while( level.player.current_seat != "pby_frontgun" )
	{
		wait(0.1);
	}
	
	wait(1.0);
	
	//-- hijacked the hudelem that was used to tell the player about ADS for this, so remember to set the message back
	str_ref = &"PBY_FLY_CANNON";
	level.ads_remind_text SetText( str_ref );
	
	wait(5);
	
	level.ads_remind_text SetText("");
}


//-- Sets up the planes with guns/seats
setup_player_planes()
{
	//--TODO: FIX THE SOUND CALLS SO THAT THEY WORK FOR CO-OP
	level.plane_a = player_pby_init("player_plane_a", "_a");
	level.plane_a.animname = "pby";
	level.plane_a maps\pby_fly_amb::setup_plane_sounds(true);
	level.plane_a thread pby_veh_idle("fly", 0.05, "up"); //-- the other option is float
	level.plane_a SetVehicleLookAtText("Mantaray", &"PBY_FLY_PBY_SQUAD");
	level.plane_a thread pby_veh_fire_guns();
	level.plane_a thread player_controlled_20mm_cannon();
	level.plane_a thread pby_damage_nose_glass();
	level.plane_a thread pby_damage_blister_glass_right();
	level.plane_a thread pby_damage_blister_glass_left();
	level.plane_a thread throttling_engine_sounds();
	//level.plane_a thread pby_damage_counter();
	
	level.plane_a thread disable_gunner_weapons_until_after_titlescreen();
	
	wait(0.05);
	
	//level.plane_a.blister_light = GetEnt("red_light", "targetname");
	//level.plane_a.blister_light MoveTo( level.plane_a GetTagOrigin("tag_gunner2"), 0.1, 0.05, 0.05 );
	//wait(0.2);
	//level.plane_a.blister_light LinkTo(level.plane_a);
	
	level.plane_b = player_pby_init("player_plane_b", "_b");
	level.plane_b.animname = "pby";
	level.plane_b maps\pby_fly_amb::setup_plane_sounds(false);
	//level.plane_b thread pby_pontoons_up(true, 1);
	level.plane_b thread pby_veh_idle("fly", 0.45, "up"); //-- the other option is float
	level.plane_b SetVehicleLookAtText("Hammerhead", &"PBY_FLY_PBY_SQUAD");
	level.plane_b thread friendly_fire();
	level.plane_b thread fake_blister_gunners();
}

throttling_engine_sounds()
{
	//-- The Default Setting
	self.engine_sound = Spawn("script_model", self.origin);
	self.engine_sound SetModel("tag_origin");
	self.engine_sound LinkTo(self, "tag_origin");
	self.engine_sound PlayLoopSound( "pby_engine_high", 3 );
	
	self thread sound_watch_for_engine_high();
	self thread sound_watch_for_engine_low();
	self thread sound_watch_for_engine_taxi();
	self thread sound_watch_for_engine_add_power();
	self thread sound_watch_for_engine_take_off();
	self thread sound_watch_for_engine_evasive();
	
	
	the_script_thing = "";
	while(1)
	{
		self waittill( "noteworthy", the_script_thing );
		
		switch( the_script_thing )
		{
			case "descending_engine":
				self notify( "switch_to_engine_low" );
			break;
			
			case "turn_engine":
				self notify( "add_engine_power" );
				self notify( "switch_to_engine_high" );
			break;
			
			case "non_turn_engine":
				self notify( "switch_to_engine_low" );
			break;
			
			case "got_flaked":
				self notify( "switch_to_engine_high" );
				self notify( "evasive_maneuver" );
			break;
			
			case "music_end_second_pass":
				self notify( "add_engine_power" );
				self notify( "switch_to_engine_high" );
			break;
			
			case "ev2_debris_turn3":
				self notify( "switch_to_engine_low" );
			break;
			
			case "delete_ship_shields":
				self notify( "switch_to_engine_low" );
			break;
			
			//case "leaving_first_event_engine":
			case "debris_stop":
				self notify( "add_engine_power" );
				self notify( "switch_to_engine_high" );
			break;
			
			case "kamikaze_dialogue":
				self notify( "switch_to_engine_taxi" );
			break;
			
			case "pby_takeoff":
				self notify( "add_engine_power_take_off" );
				self notify( "switch_to_engine_high" );
			break;
			
			default:
			break;
		}
		
		/*
		self notify( "switch_to_engine_high" );
		self notify( "switch_to_engine_low" );
		self notify( "switch_to_engine_taxi" );
		self notify( "add_engine_power" );
		self notify( "add_engine_power_take_off" );
		self notify( "evasive_maneuver" );
		*/
	}
}

sound_watch_for_engine_high()
{
	while(1)
	{
		self waittill("switch_to_engine_high");
		self.engine_sound stoploopsound(2);
		
		self.new_sound = Spawn("script_model", self.origin);
		self.new_sound SetModel("tag_origin");
		self.new_sound LinkTo(self, "tag_origin");
		self.new_sound PlayLoopSound( "pby_engine_high", 2 );
		
		wait(2);
		if( IsDefined(self.engine_sound) )
		{
			self.engine_sound Delete();
		}
		
		self.engine_sound = self.new_sound;
	}
}

sound_watch_for_engine_low()
{
	while(1)
	{
		self waittill("switch_to_engine_low");
		self.engine_sound stoploopsound(2);
		
		self.new_sound = Spawn("script_model", self.origin);
		self.new_sound SetModel("tag_origin");
		self.new_sound LinkTo(self, "tag_origin");
		self.new_sound PlayLoopSound( "pby_engine_low", 2 );
		
		wait(2);
		if( IsDefined(self.engine_sound) )
		{
			self.engine_sound Delete();
		}
		
		self.engine_sound = self.new_sound;
	}
}

sound_watch_for_engine_taxi()
{
	while(1)
	{
		self waittill("switch_to_engine_taxi");
		self.engine_sound stoploopsound(2);
		
		self.new_sound = Spawn("script_model", self.origin);
		self.new_sound SetModel("tag_origin");
		self.new_sound LinkTo(self, "tag_origin");
		self.new_sound PlayLoopSound( "pby_engine_taxi", 2 );
		
		wait(2);
		if( IsDefined(self.engine_sound) )
		{
			self.engine_sound Delete();
		}
		
		self.engine_sound = self.new_sound;
	}
}


sound_watch_for_engine_add_power()
{
	while(1)
	{
		self waittill("add_engine_power");
		self.engine_sound PlaySound("pby_add_power");
	}
}


sound_watch_for_engine_take_off()
{
	while(1)
	{
		self waittill("add_engine_power_take_off");
		self.engine_sound PlaySound("pby_take_off");
	}
}

sound_watch_for_engine_evasive()
{
	while(1)
	{
		self waittill("evasive_maneuver");
		self.engine_sound PlaySound("pby_evasive");
	}
}

fake_blister_gunners()
{
	self thread fake_blister_gunners_cleanup();
	
	gunner_spawner = GetEnt(self.plane_name + "_gunner_right", "targetname");
	self.gunner_right = gunner_spawner StalingradSpawn();
	self.gunner_right.animname = "engineer";
	self.gunner_right thread magic_bullet_shield();
	self.gunner_right animscripts\shared::placeWeaponOn(self.gunner_right.weapon, "none");	// take the prisoner's weapon
	self.gunner_right.drawoncompass = 0;
	self.gunner_right.name = undefined;
	gunner_spawner Delete();
	
	gunner_spawner = GetEnt(self.plane_name + "_gunner_left", "targetname");
	self.gunner_left = gunner_spawner StalingradSpawn();
	self.gunner_left.animname = "engineer";
	self.gunner_left thread magic_bullet_shield();
	self.gunner_left animscripts\shared::placeWeaponOn(self.gunner_left.weapon, "none");	// take the prisoner's weapon
	self.gunner_left.drawoncompass = 0;
	self.gunner_left.name = undefined;
	gunner_spawner Delete();

	self.gunner_left LinkTo(self, "tag_engineer", (0,0,0), (0,0,0));
	self.gunner_right LinkTo(self, "tag_engineer", (0,0,0), (0,0,0));
	self thread anim_loop_solo( self.gunner_left, "firelloop", "tag_engineer", "stop_gunner_idle");
	self thread anim_loop_solo( self.gunner_right, "look_loop", "tag_engineer", "stop_gunner_idle");
	
}

fake_blister_gunners_cleanup()
{
	self waittill("cleanup blister gunners");
	
	self.gunner_left notify("stop_gunner_idle");
	self.gunner_right notify("stop_gunner_idle");
	
	if(IsDefined(self.gunner_left))
	{
		self.gunner_left Delete();
	}
	
	if(IsDefined(self.gunner_right))
	{
		self.gunner_right Delete();
	}
}

disable_gunner_weapons_until_after_titlescreen()
{
	for( i = 0; i < 4; i++ )
	{
		self DisableGunnerFiring( i , true );
	}
	
	flag_wait( "starting final intro screen fadeout" );
	
	for( i = 0; i < 4; i++ )
	{
		self DisableGunnerFiring( i , false );
	}
}

load_fletcher_ship_names()
{
	level.ship_names = [];
	level.ship_names[0] 	= "USS BALANON (DD 809)";
	level.ship_names[1] 	= "USS HALFORD (DD 480)";
	level.ship_names[2] 	= "USS ISHERWOOD (DD 520)";
	level.ship_names[3] 	= "USS LAWS (DD 558)";
	level.ship_names[4] 	= "USS CHARRETTE (DD 581)";
	level.ship_names[5] 	= "USS ROOKS (DD 804)";
	level.ship_names[6] 	= "USS CASSIN YOUNG (DD 793)";
	level.ship_names[7] 	= "USS GATLING (DD 671)";
	level.ship_names[8] 	= "USS WEDDERBURN (DD 684)";
	level.ship_names[9] 	= "USS DORTCH (DD 670)";
}

friendly_fire()
{
	//level.plane_a is the player
	friendly_damage_max = 10;
	
	self.current_friendly_damage = 0;
	self thread friendly_fire_reduce();
	
	while(1)
	{
		self waittill ( "damage", amount, attacker );
		
		//-- They changed who the attacker is in code... so it needs to be the player now instead of plane_a
		//if(attacker == level.plane_a)
		if(attacker == level.player)
		{
			self.current_friendly_damage += amount;
		}
		
		if(self.current_friendly_damage > friendly_damage_max)
		{
			//fail the player the friendly fire way
			thread maps\_friendlyfire::missionfail();
		}
	}
}

friendly_fire_reduce()
{
	self endon( "death" );
	
	while(1)
	{
		if(self.current_friendly_damage > 0)
		{
			self.current_friendly_damage = self.current_friendly_damage - 250;
		}
		else if(self.current_friendly_damage < 0)
		{
			self.current_friendly_damage = 0;
		}
		
		wait(1);
	}
}

//-- setup variables for seat tracking
setup_seat_control(specific_seat)
{
	if(!IsDefined(specific_seat))
	{
		self.current_seat = "undefined";
		self.wanted_seat = "undefined";
	}
	else
	{	//-- Used when the player is forced into a specific seat
		self.current_seat = specific_seat;
		self.wanted_seat = "undefined";
	}
}


//-- Controls the Pilot's Suggested Seat and sets that value on the player characters
set_pilots_suggested_seat(suggested_seat, alternate_seat)
{
	if(IsDefined(self))
	{
		self.pilots_suggested_seat = suggested_seat;
		self.pilots_alternate_seat = alternate_seat;
	}
}

//-- used to be known as move_to_pilots_suggested_seat()
move_to_required_seat()
{
	if(!IsDefined(self.in_saving_position))
	{
			self.in_saving_position = false;
	}
	
	while(true)
	{
		while(!self useButtonPressed())
		{
			wait(0.05);
		}
		
		if(IsDefined(self.need_to_switch))
		{
			if(self.need_to_switch)
			{
				//-- so you dont get switched back to the saving
				if(self.in_saving_position)
				{
					self.in_saving_position = false;
				}
				
				//-- then allow for the switch
				while(level.player.save_anim)
				{
					wait(0.05);
				}
				
				self.need_to_switch = false;
				switch_successful = self switch_turret(self.required_seat);
				
				ASSERTEX(switch_successful, "The player was unable to switch to the required seat");
			}
		}
		
		if(IsDefined(self.in_saving_position))
		{
			if(self.in_saving_position)
			{
				self notify("perform_save");
				wait(2);
			}
		}
		
		wait(0.05);
	}
}


//-- Level Gameplay Functions --------------------------------------------------------------------------------

event1_new()
{
	my_level_init();
	
	move_ev4(false);
	
	set_objective("scout_ocean");
	//maps\_debug::set_event_printname("Event 1 - Intro", false);
	
	plane = level.plane_a;
		
	wait(2);
	
	level notify("start_fade_in");
	level thread music_state_changes();
	
	//-- Get rid of the fake clouds passing by
	level.plane_a notify("start_mist");
	level.plane_b notify("start_mist");
	
	//-- Start Plane A Flying
	new_starting_node = GetVehicleNode("pby_a_level_start", "targetname");
	level.plane_a AttachPath(new_starting_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_a StartPath();
	//level.plane_a SetSpeed(40, 100, 100);
	
	//-- Start Plane B Flying
	new_starting_node = GetVehicleNode("pby_b_level_start", "targetname");
	level.plane_b AttachPath(new_starting_node);
	level.plane_b thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_b StartPath();
	//level.plane_b SetSpeed(40, 100, 100);
	
	level thread event1_dialogue_2();
		
	//-- pre-setup items that are needed for event 2
	level thread event2_pby_engine_control(); //possibly hacks
	level thread event2_boat_fx();
	
	wait(0.5);
	
	level.plane_a ResumeSpeed(1000);
	level.plane_b ResumeSpeed(1000);
	
	wait(5);
	
	level thread turret_ads_reminder();
	
	level waittill("move to front for intro");
	level thread event2_pby_b_1st_pass(); //-- controls the flight of the 2nd pby
	level thread event2_strafe_boats(); //-- kick off the setup for the merchant ships
	level.player scripted_turret_switch("pby_frontgun", true);
		
	wait(3);
	level notify("we should see the boats now");
	
	level waittill("event1 dialogue2 done");
	
	level.plane_a kill_pby_running_lights();
}

intro_move_player_to_rear( guy )
{
	level.player.intro = true;
	level.player thread scripted_turret_switch("pby_rightgun");
	level.player waittill("switching_turret");	
	level.player startcameratween( 1 );
}


/*intro_move_engineer_climb( guy )
{
	level.plane_a anim_single_solo(level.plane_a.engineer, "intro_vig_up", "tag_engineer");
}*/

event1_pby_pontoons_up_hatch_open()
{
	level.player waittill("switching_turret");
	level.plane_a thread pby_veh_idle("fly", 0.05, true, true);
	level.plane_b thread pby_veh_idle("fly", 0.05, true, true);
}

play_sound_over_radio( sound_ref )
{
	radio_pos = level.plane_a GetTagOrigin("tag_engineer"); //-- plane not moving, so no need to update
	
	radio = Spawn("script_origin", radio_pos);
	radio SetModel("tag_origin");
	radio LinkTo(level.plane_a, "tag_engineer", (0,0,0), (0,0,0)); 
	
	radio playsound (sound_ref, "radio_done");
		
	radio waittill("radio_done");
	radio Delete();
}

play_survivor_yell( sound_ref , offset)
{
	if(!IsDefined(offset))
	{
		offset = 60;
	}
	
	survivor = Spawn("script_origin", self.origin + (0,0,offset));
	survivor SetModel("tag_origin");
		
	survivor playsound (sound_ref, "radio_done");
		
	survivor waittill("radio_done");
	survivor Delete();
}

event1_dialogue_2()
{
	//Tuey Sets music state to INTRO
	setmusicstate ("INTRO");
	wait(2);
	
	play_sound_over_radio( "PBY1_INT_000A_HARR");
	wait(0.25);
	anim_single_solo(level.plane_a.pilot, "booth_yeah_i_see_em");
	wait(0.25);
	anim_single_solo(level.plane_a.pilot, "booth_major_gordon_vessels_now");
	anim_single_solo(level.plane_a.pilot, "booth_unmarked_japanese_merchant");
	wait(0.15);
	play_sound_over_radio( "PBY1_INT_004A_MAJG" );
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_legitimate_targets");
	wait(0.15);
	play_sound_over_radio( "PBY1_INT_006A_MAJG" );
	play_sound_over_radio( "PBY1_INT_007A_MAJG" );
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_roger_that");
	anim_single_solo(level.plane_a.pilot, "booth_laughlin_locke_get_to");
	
	level notify("move to front for intro");
		
	//-- DELAY HERE FOR INCREASED AWESOMENESS
	level.player waittill("done_switching_turrets");
	wait(0.5);
	level.plane_b kill_pby_running_lights();
	level thread thumb_in_ass_dialogue();
	anim_single_solo(level.plane_a.pilot, "booth_open_fire");
	
	/*
	wait(7.0);
	play_sound_over_radio("PBY1_IGD_001A_HARR");
	wait(0.25);
	play_sound_over_radio("PBY1_IGD_002A_LAUG"); //-- TODO: MAKE THIS LINE SAID BY AN AI INSTEAD OF THE RADIO
	*/
		
	level thread event1_to_battle_stations();
	level waittill("told to go ventral");
	level anim_single_solo(level.plane_a.pilot, "booth_coming_over_them_get_rear");

	//TUEY SET MUSIC STATE TO MERCH_FIRST_PASS
//	setmusicstate("MERCH_FIRST_PASS");
	
	//level thread anim_single_solo(level.plane_a.pilot, "intro2_a_silent");
	//level.plane_a notify("go_silent");
	//-- These lines need to play as you head over the merchant ships
	level.plane_a waittill("hatch_opening");
	wait(3);
	//level anim_single_solo(level.plane_a.pilot, "intro2_a_overthem");
	//level anim_single_solo(level.plane_a.pilot, "intro2_a_shootmoves");
	
	level notify("event1 dialogue2 done");
	
	
	level.plane_a waittill("infantry_dialogue");
	play_sound_over_radio("PBY1_IGD_010A_HARR");
	play_sound_over_radio("PBY1_IGD_011A_LAUG");
	//-- HARRINGTON: We got infantry on deck...
	//-- LAUGHLIN: Take 'em out!
	
}

thumb_in_ass_dialogue()
{
	i = 0;

	//while(!(level.plane_a IsGunnerFiring(0)) && i < 6 )
	while( !(level.player AttackButtonPressed()) && i < 6 && !flag("20mm_shot"))
	{
		i += 0.05;
		wait(0.05);
	}
	
	if(i >= 6)
	{
		anim_single_solo(level.plane_a.pilot, "booth_locke_get_your_thumb" );
	}
}

event1_to_battle_stations()
{
	level.plane_a waittill("new_switch_ventral");
	level.player.open_hatch = true;
	level thread event1_pby_pontoons_up_hatch_open();
	level notify("told to go ventral");
	level.player scripted_turret_switch("pby_backgun");
	level.player waittill("done_switching_turrets");
}

jumpto_speed(new_speed)
{
	self SetSpeedImmediate(new_speed, 0.1, 0.1);
}

//TODO: FINISH THIS SO IT WORKS FOR BOTH PLANES
turn_on_the_clouds()
{
	cloud_fx = playloopedfx(level._effect["ambient_clouds"], 3, level.plane_a.origin, 0);
}

debug_watch_dead_zeros()
{
	i = 0;
	
	while(1)
	{
		level waittill("zero_killed");
		i++;
		level.killed_hud SetText("Zeros Killed: " + i);
	}
	
}

damage_my_parts()
{
	//-- cause massive damage to plane 2
	self DoDamage(50000, self.origin, level.player, 16);
	wait(0.05);
	self DoDamage(50000, self.origin, level.player, 9);
	wait(0.05);
	self DoDamage(50000, self.origin, level.player, 10);
	wait(0.05);
	self DoDamage(50000, self.origin, level.player, 17);
	wait(0.05);
	self DoDamage(50000, self.origin, level.player, 18);
	wait(0.05);
}
	

event3(jumpto)
{
	level thread event3_dialogue();
	//level.plane_b thread event3_triggered_lightning(5);
	
	level.plane_b damage_my_parts();
		
	//maps\_debug::set_event_printname("Event 3 - Pacing", false);
	
	level waittill( "player_needs_to_switch_turrets");
	level.player.pacing_moment = true; //-- play the hatch pacing moment
	level.player scripted_turret_switch("pby_frontgun");
	
	//new_start_node = GetVehicleNode("event4_start_path", "targetname");
	level.plane_b thread ai_pby_gunners_think();
	level.player waittill("switching_turret");
	
	wait(4);
	level notify("light_night");
	
	level thread event4_pby_crashing();
		
	move_ev2(false);
	level.plane_a waittill("shoot_plane_b");
	level.plane_b notify("stop_shooting");
	
	move_ev4(true);
	
	
	level thread event4();
}

event3_triggered_lightning(_wait)
{
	level endon("other_zero_no_flash");
	self waittill("lightning_flash");
	the_direction = VectorNormalize((self.origin[0], self.origin[1], 0) - (level.player.origin[0], level.player.origin[1], 0));
	level thread maps\pby_fly_fx::scripted_lightning_flash(undefined, undefined, _wait, the_direction);
	level notify("other_zero_no_flash");
}

event3_kamikaze_zero()
{
	level.player waittill("switching_turret");
	level thread run_pby_tracker();
	
	plane = [];
	crash_paths = [];
	
	//crash_paths = GetVehicleNodeArray("initial_zero_mass", "targetname");
	for(i = 0; i < 30; i++)
	{
		crash_paths[i] = GetVehicleNode("initial_zero_mass_" + i, "targetname");
	}
	
	for( i=0; i < crash_paths.size; i++)
	{
		if(i > 0)
		{
			if( i % 9 == 0 )
			{
				wait(1);
			}
		}
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true );
		
	}
	
	/*
	crash_paths = GetVehicleNodeArray("event3_ambient_kam", "targetname");
	for(i = 0; i < 4; i++)
	{
		crash_paths[i] = GetVehicleNode("event3_ambient_kam_" + i, "targetname");
	}
	
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], true, true);	
		wait(0.05);
	}
	
	wait(2.0);
	
	//-- 2 THAT FLY WITH THE OTHER SIX THAT DOUBLE BACK
	
	plane = [];
	crash_path = [];
	crash_path[0] = GetVehicleNode("event3_ambient_kam_2_crash", "targetname");
	plane[0] = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
	plane[0].vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane[0]);
	plane[0] AttachPath(crash_path[0]);
	plane[0] thread maps\_vehicle::vehicle_paths(crash_path[0]);
	plane[0] StartPath();
	
	crash_path[1] = GetVehicleNode("event3_ambient_kam_2_crash_b", "targetname");
	plane[1] = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
	plane[1].vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane[1]);
	plane[1] AttachPath(crash_path[1]);
	plane[1] thread maps\_vehicle::vehicle_paths(crash_path[1]);
	plane[1] StartPath();
		
	//-- setup the plane to work properly
	plane[0].kamikaze = true;
	switch_nodes_1 = [];
	switch_nodes_2 = [];
	switch_nodes_1[0] = "auto1422";
	switch_nodes_2[0] = "crash_zero_0";
	switch_nodes_1[1] = "auto1424";
	switch_nodes_2[1] = "crash_zero_1";
	plane[0] thread event3_plane_crash_set_switchnode(switch_nodes_1, switch_nodes_2);
	plane[0] thread event3_plane_crash_into_plane(plane[1]);
	plane[0] thread event3_triggered_lightning(2);
	plane[1] thread event3_triggered_lightning();
	
	wait(2.0);
	
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_ambient_kam_2_no_crash", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	wait(4);
	level notify("zero lightning go");
	
	level.plane_a waittill("more_planes");
	
	//-- more planes to breakup the time
	crash_paths = [];
	//crash_paths = GetVehicleNodeArray("event3_more_kam", "targetname");
	crash_paths[0] = GetVehicleNode("event3_more_kam_0", "targetname");
	crash_paths[1] = GetVehicleNode("event3_more_kam_1", "targetname");
	crash_paths[2] = GetVehicleNode("event3_more_kam_3", "targetname");
	crash_paths[3] = GetVehicleNode("event3_more_kam_2", "targetname");
	
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		
		if(i == 0)
		{
			wait(0.05);
		}
		else if(i == 2)
		{
			wait(1);
		}
		else
		{
			wait(0.05);
		}
	}
	*/
	
	//-- first set of intercepting zeroes
	level.plane_a waittill("intercept_zeroes_00");
	level thread watch_for_player_shooting( "player_shot_during_event3", "flag" );
	
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("pacing_intercept_00", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	level.plane_a waittill("intercept_zeroes_00a");
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("pacing_intercept_00a", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	//-- second set of intercepting zeroes
	level.plane_a waittill("intercept_zeroes_01");
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("pacing_intercept_01", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	//-- third set of intercepting zeroes
	level.plane_a waittill("more_planes");
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("pacing_intercept_02", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	//-- fourth set of intercepting zeroes
	level.plane_a waittill("intercept_zeroes_03");
	level thread make_sure_player_shot_during_event_3();
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("pacing_intercept_03", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	//-- the planes that shoot down the friendly pby
	level.plane_a waittill("shoot_plane_b");
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_ambient_kam_shoot_b", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	/*
	level.plane_a waittill("event3_kam_c");
	
	//-- 2ND SET OF 4 THAT FLY BY
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_ambient_kam_c", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	wait(1);
	
	//-- 2ND SET OF 4 THAT FLY BY
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_ambient_kam_d", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	
	
	level.plane_a waittill("event4_fly_across_landing");
	
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_between_pby_fleet", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}
	*/
	
	level thread sharks_big_group();
	level.plane_a waittill("ptboat_l_to_r");
	//level.plane_a waittill("overhead_flyby");
	
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event3_fly_just_above", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);	
		wait(0.05);
	}


	//level.plane_a waittill("ptboat_l_to_r");
	
	crash_paths = [];
	crash_paths = GetVehicleNodeArray("event4_initial_flyover", "targetname");
	for(i = 0; i < crash_paths.size; i++)
	{
		plane[i] = spawn_and_path_a_zero( crash_paths[i], undefined, true);
		wait(0.05);
	}
}

make_sure_player_shot_during_event_3()
{
	wait(4);
	
	level.zero_accuracy_override = undefined;
	while( !flag( "player_shot_during_event3" ) )
	{
		level.zero_accuracy_override = true;
		wait(0.05);
	}
	
	level.zero_accuracy_override = undefined;
}


event3_plane_crash_set_switchnode( node_array1, node_array2)
{
	self endon("death");
	
	ASSERTEX( node_array1.size == node_array2.size, "The Node Arrays Are Different Sizes");
	
	self thread event3_plane_crash_clear_switchnode();
	
	for( i=0; i < node_array1.size; i++)
	{
		self waittill("set_my_switchnode");
		
		self.script_crashtypeoverride = "smash_into_other_plane";	
		self.node1 = node_array1[i];
		self.node2 = node_array2[i];
	}
}

event3_plane_crash_clear_switchnode()
{
	self endon("death");
	
	while(1)
	{
		self waittill("clear_my_switchnode");
		self.script_crashtypeoverride = "none";	
		self.node1 = undefined;
		self.node2 = undefined;
	}
}

event3_plane_crash_into_plane(other_plane)
{
	self waittill("death");
	
	if(IsDefined(other_plane))
	{
		if(!IsAlive(other_plane))
		{
			self.script_crashtypeoverride = "none";
			self.node1 = undefined;
			self.node2 = undefined;
		}
	}
	
	//-- need to wrap this around the other place being alive
	self.crash_course = true;
	
	wait(0.1);
	
	self notify("crash setup done");
	
	if(IsDefined(self.node1) && IsDefined(self.node2))
	{
		node = GetVehicleNode(self.node1, "targetname");
		snode = GetVehicleNode(self.node2, "targetname");
		self SetSwitchNode(node, snode);
	}
	else
	{
		//-- continue a normal crash
	}
}

#using_animtree ("generic_human");
event3_dialogue()
{
	//-- Event 3 - Heading Back
	//play_sound_over_radio("PBY1_MID_200A_PLT2");
	//play_sound_over_radio("PBY1_MID_201A_PLT2");
	//level anim_single_solo(level.plane_a.radiop, "event3_a_rogerthat");
	//level anim_single_solo(level.plane_a.pilot, "event3_a_takingusup");
	
	flag_set("disable_random_dialogue");
	play_sound_over_radio("PBY1_IGD_061A_HARR");
	//play_sound_over_radio("PBY1_IGD_061B_HARR"); //-- TODO: switch out this alt line
	wait(0.25);
	anim_single_solo(level.plane_a.radioop, "landry_confirmed_harrington");
	wait(0.15);
	play_sound_over_radio("PBY1_IGD_063A_HARR");
	
	level thread maps\pby_fly_amb::play_zeros_track();
	//level.plane_a waittill("more_dialogue");
	
	level thread event3_kamikaze_zero();
	level notify( "player_needs_to_switch_turrets");
	anim_single_solo(level.plane_a.radioop, "landry_oh_hell");
	anim_single_solo(level.plane_a.radioop, "landry_captain_harrington_distress_call");
	anim_single_solo(level.plane_a.radioop, "landry_theyve_called_for_air_support");
	level.plane_a.radioop setflaggedanimknoballrestart("animscript faceanim", %ch_pby_distress_radio_face1, %facial, 1, .1, 1);
	anim_single_solo(level.plane_a.radioop, "landry_atleast_one_infantry");
	level.plane_a.radioop setflaggedanimknoballrestart("animscript faceanim", %ch_pby_distress_radio_face2, %facial, 1, .1, 1);
	//anim_single_solo(level.plane_a.radioop, "landry_they_have_men_in_the_water");
	anim_single_solo(level.plane_a.pilot, "booth_okay_locke_seal");
	anim_single_solo(level.plane_a.pilot, "booth_lets_go_get_our_men");
	flag_clear("disable_random_dialogue");
		
	//-- Event 3 - Distress Call
	//level anim_single_solo(level.plane_a.radioop, "event3_a_distress");
	//level anim_single_solo(level.plane_a.pilot, "event3_a_shit");
	set_objective("respond_to_distress_call");
	//level anim_single_solo(level.plane_a.pilot, "event3_a_hotzone");
	//play_sound_over_radio("PBY1_MID_123A_PLT2");
	
	if(level.player.current_seat != "pby_frontgun")
	{
		level.player waittill("done_switching_turrets");
	}
	wait(1);
	
	//TUEY Set music state to ZEROS_ONE
	setmusicstate("ZEROS_ONE");
	flag_set("disable_random_dialogue");
	play_sound_over_radio("PBY1_IGD_070A_HARR");
	anim_single_solo(level.plane_a.pilot, "booth_zeroes_right_below");
	anim_single_solo(level.plane_a.pilot, "booth_shit_take_down_as_many");
	anim_single_solo(level.plane_a.pilot, "booth_get_firing_locke");
	wait(1);
	anim_single_solo(level.plane_a.pilot, "booth_radio_the_fleet");
	flag_clear("disable_random_dialogue");
	
	
	//-- Zeroes Coming In
	
	level.plane_a waittill("intercept_zeroes_00");
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_weve_got_zeros_coming_in_fast");
	anim_single_solo(level.plane_a.pilot, "booth_11_oclock");
	thread anim_single_solo(level.plane_a.pilot, "booth_low");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("intercept_zeroes_00a");
	wait(0.5);
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["9_oclock"] );
	//anim_single_solo(level.plane_a.pilot, "booth_9_oclock");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("intercept_zeroes_01");
	wait(0.5);
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_3_oclock");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("more_planes");
	wait(0.5);
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["10_oclock"] );
	thread play_sound_over_radio( level.scr_sound["laughlin"]["high"] );
	//anim_single_solo(level.plane_a.pilot, "booth_10_oclock");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("intercept_zeroes_03");
	wait(0.5);
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_12_oclock");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("shoot_plane_b");
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["6_oclock"] );
	//anim_single_solo(level.plane_a.pilot, "booth_6_oclock");
	flag_clear("disable_random_dialogue");
	
	/*
	level.scr_sound["pilot"]["booth_weve_got_zeros_coming_in_fast"]
	level.scr_sound["pilot"]["booth_more_damn_zeroes"]
	level.scr_sound["pilot"]["booth_12_oclock"]
	level.scr_sound["pilot"]["booth_1_oclock"]
	level.scr_sound["pilot"]["booth_2_oclock"]
	level.scr_sound["pilot"]["booth_3_oclock"]
	level.scr_sound["pilot"]["booth_4_oclock"]
	level.scr_sound["pilot"]["booth_5_oclock"]
	level.scr_sound["pilot"]["booth_6_oclock"]
	level.scr_sound["pilot"]["booth_7_oclock"]
	level.scr_sound["pilot"]["booth_8_oclock"]
	level.scr_sound["pilot"]["booth_9_oclock"]
	level.scr_sound["pilot"]["booth_10_oclock"]
	level.scr_sound["pilot"]["booth_11_oclock"]
	*/
	
	level waittill("plane_b_is_crashed");
	
	wait(2);
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_okay_people_the_fleet_needs");
	anim_single_solo(level.plane_a.pilot, "booth_anyone_want_to_back_out");
	wait(1.5);
	anim_single_solo(level.plane_a.pilot, "booth_didnt_think_so");
	wait(0.5);
	anim_single_solo(level.plane_a.pilot, "booth_were_going_into_a_hotzone");
	
	//level.plane_a waittill("overhead_flyby");
	anim_single_solo(level.plane_a.pilot, "booth_bastards_wiped_out_most");
	play_sound_over_radio("PBY1_IGD_086A_LAUG");
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_i_see_multiple_casualties");
	wait(0.15);
	play_sound_over_radio("PBY1_IGD_088A_LAUG");
	anim_single_solo(level.plane_a.radioop, "landry_we_better_not_be_the_only");
	anim_single_solo(level.plane_a.pilot, "booth_well_do_what_we_can");
	//anim_single_solo(level.plane_a.pilot, "booth_locke_be_ready_to");
	//wait(1);
	//anim_single_solo(level.plane_a.pilot, "booth_well_bring_em_home");
	flag_clear("disable_random_dialogue");
	
	level thread event4_dialogue();
}

event4_dialogue()
{
	level.plane_a waittill("kamikaze_dialogue");
	flag_set("disable_random_dialogue");
	play_sound_over_radio("PBY1_IGD_118A_LAUG");
	play_sound_over_radio( level.scr_sound["laughlin"]["2_oclock"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["high"] );
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("switch_for_pby_pt");
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_incoming_right_side");
	wait(5);
	anim_single_solo(level.plane_a.radioop, "landry_sink_thos_damn_ptboats");
	flag_clear("disable_random_dialogue");
	
	level waittill("player_switched_to_left");
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_incoming_left_side");
	flag_clear("disable_random_dialogue");
	
	level waittill("the_other_gunner_died");
	wait(2);
	Earthquake(0.7, 1.0, level.plane_a.radioop.origin, 1000);
	playsoundatposition("amb_metal", (0,0,0));
	wait(0.7);
	flag_set("disable_random_dialogue");
	//-- break out damaged part of pby
	level.plane_a DoDamage(50000, level.plane_a.origin, level.player, 9);
	playsoundatposition("impact_boom", (0,0,0));


	anim_single_solo(level.plane_a.pilot, "booth_damn_were_hit");
	anim_single_solo(level.plane_a.pilot, "booth_laughlin_make_sure_were");
	wait(0.5);
	play_sound_over_radio("PBY1_IGD_124A_LAUG");
	wait(0.5);
	anim_single_solo(level.plane_a.pilot, "booth_locke_take_his");
	level notify("pilot_said_front");
	wait(0.15);
	play_sound_over_radio("PBY1_IGD_126A_LAUG");
	wait(0.5);
	anim_single_solo(level.plane_a.pilot, "booth_damn_period");
	wait(1.5);
	anim_single_solo(level.plane_a.pilot, "booth_zeroes_exclamation");
	wait(0.15);
	anim_single_solo(level.plane_a.radioop, "landry_theyre_all_around");
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_keep_em_off_whats_left");
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_locke_you_need_to_take");
	anim_single_solo(level.plane_a.pilot, "booth_stay_on_that_trigger");
	flag_clear("disable_random_dialogue");
	thread set_objective("escape");
}

event4( jumpto )
{
	level.plane_a ResumeSpeed(1000);
	level thread event2_cleanup();
		
	level thread maps\pby_fly_amb::destroyer1_alarm();
	level thread maps\pby_fly_amb::destroyer2_alarm();
	level thread maps\pby_fly_amb::destroyer3_alarm();
	
	//-- only enable the water during the rescue event
	watersimenable (true);
	level.drift_speed = 2.5;
	level.close_boat_sounds = true;
	level notify("debris_ready_delete");
	
	//maps\_debug::set_event_printname("Event 4 - Rescue", true);
	
	//level thread event4_sinking_ship();
	//level thread watch_for_flare_trig();
	level thread event4_kamikaze_ship();
	level thread sharks_rescue_one();
	level thread event4_drowning_drones();
	level thread event4_raft_drones();
	level thread event4_fleet_shoot();
	level thread event4_sound_notifies();
	level thread event4_ptboat_control();
	level thread event4_part2point5();
	level thread event4_part3();
		
	
	//-- Land the Plane using an Animation!!!
	level.plane_a thread play_land_pby();
	level thread maps\pby_fly_fx::fog_for_rescue();
	//level.plane_b thread play_land_pby();
	//level.plane_b notify("stop_shooting");
				
	level.plane_a waittill("switch_for_pby_pt");
	level thread event4_random_zeros();
	level thread event4_seat_control();
		
	//-- Getting the survivors spawned
	level thread rescue_scene_init_1();
	
	//level thread event4_first_ship_drones();
	
	level.plane_a waittill("guy_start_swimming");
	level notify("spawn_first_ship_drones");
	level thread run_debug_timer();
	
	set_objective("save_sailors");
	level thread event4_cleanup_swimmers( level.survivors_group_1, "rescue_1_done");
	for(i = 0; i < level.survivors_group_1.size; i++)
	{
		level.survivors_group_1[i] notify("swimming_notify"); //-- send this guy to the blister
		level.survivors_group_1[i] thread rescue_scenario();
		wait(0.1);
	}
	
	level.plane_a notify("completely_stopped");
	level.plane_a thread pby_veh_idle("float"); //-- the other option is fly
	
	level thread event4_watch_early_switch();	
		
	//level.plane_a waittill("survivor_3_go");
	level.plane_a waittill("slowing_down");
	level thread rescue_scene_init_2();	 //-- spawn the next set of swimmers
	
	level.plane_a waittill("survivor_2_go");
	//level.plane_a waittill("slowing_down");
	level thread event4_cleanup_swimmers( level.survivors_group_2, "rescue_2_done");
	for(i = 0; i < level.survivors_group_2.size; i++)
	{
		level.survivors_group_2[i] notify("swimming_notify"); //-- send this guy to the blister
		level.survivors_group_2[i] thread rescue_scenario();
		wait(0.1);
	}
	
	level.plane_a waittill("shinyou_blow_up");
	level notify("end random zeros");
	level notify("stop_zeroes_defending_ship");
	//level.plane_a thread pby_explosion();
}

event4_watch_early_switch()
{
	while( !flag("zero_rescue_1_dead") )
	{
		wait(0.1);	
	}
	
	level.plane_a notify("speeding_up");
	
	level.plane_a SetSpeed( 10, 20, 20 );
	level.plane_a waittill("speeding_up");
	level.plane_a ResumeSpeed(20);
}

event4_rescue_zeros()
{
	level endon("rescue_1_done");
	
	plane = undefined;
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("zero_attack_rescue_0", "targetname");
	plane_paths[1] = GetVehicleNode("zero_attack_rescue_1", "targetname");
	plane_paths[2] = GetVehicleNode("zero_attack_rescue_2", "targetname");
	plane_paths[3] = GetVehicleNode("zero_attack_rescue_3", "targetname");
	plane_paths[4] = GetVehicleNode("zero_attack_rescue_4", "targetname");
	plane_paths[5] = GetVehicleNode("zero_attack_rescue_5", "targetname");
	
	last_spline = 0;
	
	for(;;)
	{
		random_int = RandomInt(plane_paths.size);
		if(random_int == last_spline)
		{
			continue;	
		}
		
		last_spline = random_int;
		random_path = plane_paths[random_int];
				
		plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
		plane.vehicletype = "zero";
		maps\_vehicle::vehicle_init(plane);
		
		plane AttachPath(random_path);
		plane thread maps\_vehicle::vehicle_paths(random_path);
		plane StartPath();
		
		random_speed = RandomIntRange(110, 160);
		plane SetSpeed(random_speed, 1000, 1000);
		
				
		plane thread event4_kamikaze_path_explode();
		
			//-- specific for the flyby sound
		plane.audio_node_propzero = Spawn("script_model", plane.origin);
		plane.audio_node_propzero SetModel("tag_origin");
		plane.audio_node_propzero LinkTo(plane, "tag_origin", (0,0,0), (0,0,0));
		
		plane playloopsound("zero_steady");
		plane thread maps\pby_fly_amb::play_plane_passby(plane);
			
		random_wait = RandomFloatRange(5, 10);
		wait(random_wait);
	}
}

event4_random_zeros()
{
	level endon("end random zeros");
		
	plane = [];
	plane_paths = [];
	plane_paths = GetVehicleNodeArray("event4_ambient_zero_spline", "targetname"); //-- Perpendicular Zeroes
	
	while(1)
	{
		my_random_int = RandomIntRange(2, 5);
		
		for( i = 0; i < my_random_int; i++)
		{
			rand_spline = RandomIntRange(0, plane_paths.size - 1);
			plane[i] = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
			plane[i].vehicletype = "zero";
			maps\_vehicle::vehicle_init(plane[i]);
				
			plane[i] AttachPath(plane_paths[rand_spline]);
			plane[i] thread maps\_vehicle::vehicle_paths(plane_paths[rand_spline]);
			plane[i] StartPath();
				
			plane[i] thread event4_kamikaze_path_explode();
			
			//-- specific for the flyby sound
			plane[i].audio_node_propzero = Spawn("script_model", plane[i].origin);
			plane[i].audio_node_propzero SetModel("tag_origin");
			plane[i].audio_node_propzero LinkTo(plane[i], "tag_origin", (0,0,0), (0,0,0));
		
			plane[i] playloopsound("zero_steady");
			plane[i] thread maps\pby_fly_amb::play_plane_passby(plane[i]);
			
			random_wait = RandomFloatRange(2, 3);
			wait(random_wait);
		}
		
		wait(5);
	}
	
}

event4_seat_control()
{
	//-- Send the player to the right blister
	level.player thread scripted_turret_switch("pby_rightgun");
	level.player waittill("done_switching_turrets");
	level thread event4_corsair_rescue_1();
	wait(1.0);
	level notify("sun_rise");
	level notify("stop lightning");
	//level thread maps\_flare::flare_from_targetname( "flare1", 1, 2, 1, ( 0.83, 0.82, 1 ) );
	
	level.plane_a waittill("speeding_up");
	level.player thread scripted_turret_switch("pby_leftgun"); //-- switch to shoot at the PT Boats
	level.player waittill("done_switching_turrets");
	level notify("player_switched_to_left"); //-- for dialogue
	level notify("rescue_1_done");
	level thread event4_kamikaze_filler();
	
	//level.plane_a waittill("slowing_down");
	//player thread scripted_turret_switch("pby_rightgun");
	
	//level.plane_a waittill("speeding_up_2");
	//level notify("spawn_first_ship_drones");
	//level.debug_timer = 0;
	//level.player thread scripted_turret_switch("pby_leftgun");
	
	//level.plane_a waittill("speeding_up_3");
	level.plane_a waittill_flag_or_notify( "rescue_2_3rd_ptboats_killed", "speeding_up_3" );
	level notify("the_other_gunner_died");
	
	level waittill("pilot_said_front");
	level.plane_a thread set_speed_then_reset(10, "event4_twopointfive");
	level.player thread scripted_turret_switch("pby_frontgun");
	level.player waittill("switching_turret");
	
	level.player waittill("done_switching_turrets");
	level notify("rescue_2_done");
}

set_speed_then_reset( new_speed, reset_notify )
{
	self SetSpeed(new_speed, 100, 100);
	self waittill( reset_notify );
	self ResumeSpeed(1000);
}

waittill_flag_or_notify( my_flag, my_notify )
{
	self thread notify_from_flag( my_flag, "my_local_notify");
	self thread notify_from_notify( my_notify, "my_local_notify");
	self waittill("my_local_notify");
}

notify_from_flag( my_flag, my_notify )
{
	//self endon( my_notify );
	flag_wait( my_flag );
	self notify( my_notify );
}

notify_from_notify( my_notify, other_notify )
{
	//self endon( other_notify );
	self waittill( my_notify );
	self notify( other_notify );
}

event4_corsair_rescue_1()
{
	//-- spawns zeros and corsair
	cor_trig = GetEnt("trig_corsair_rescue_1", "targetname");
	cor_trig UseBy( level.player );
	//iprintlnbold("spawning corsair");
}

event4_part1_transition_boats()
{
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("event4_transboat_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("event4_transboat_1", "targetname");
	
	the_ptboat = undefined;
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboat = spawn_and_path_a_ptboat(ptboat_paths[i]);
	}
}

event4_drowning_drones()
{
	treading_drones_spawn = [];
	treading_drones_spawn = GetStructArray("rescue1_treadwater_drone", "targetname");
	
	//-- Spawn in the drones treading water
	treading_drones = [];
	for(i=0; i < treading_drones_spawn.size; i++)
	{
		treading_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", treading_drones_spawn[i]);
		treading_drones[i] thread maps\_drone::drone_tread_water_idle();
		wait(0.05);
	}
}

event4_raft_drones()
{
	level.plane_a waittill("overhead_flyby");
	
	//-- raft 1
	
	raft_drones_spawn = [];
	raft_drones_spawn = GetStructArray("rescue_1_raft_drones", "targetname");
	
	raft_drones = [];
	for(i=0; i < raft_drones_spawn.size; i++)
	{
		raft_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", raft_drones_spawn[i]);
		wait(0.05);
	}
	
	raft = GetEnt("rescue_1_raft", "targetname");
	level thread maps\_drone::drone_idle_row_boat( raft_drones, raft );
	
	goal_struct = GetStruct(raft.target, "targetname");
	
	raft MoveTo(goal_struct.origin, 60, 10, 10);
	
	//-- raft 2
	
	raft_drones_spawn = [];
	raft_drones_spawn = GetStructArray("rescue_1_raft_drones_b", "targetname");
	
	raft_drones = [];
	for(i=0; i < raft_drones_spawn.size; i++)
	{
		raft_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", raft_drones_spawn[i]);
		wait(0.05);
	}
	
	raft = GetEnt("rescue_1_raft_b", "targetname");
	level thread maps\_drone::drone_idle_row_boat( raft_drones, raft );
	
	goal_struct = GetStruct(raft.target, "targetname");
	
	raft MoveTo(goal_struct.origin, 60, 10, 10);
	
	//-- raft 3
	
	raft_drones_spawn = [];
	raft_drones_spawn = GetStructArray("rescue_1_raft_drones_c", "targetname");
	
	raft_drones = [];
	for(i=0; i < raft_drones_spawn.size; i++)
	{
		raft_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", raft_drones_spawn[i]);
		wait(0.05);
	}
	
	raft = GetEnt("rescue_1_raft_c", "targetname");
	level thread maps\_drone::drone_idle_row_boat( raft_drones, raft );
	
	goal_struct = GetStruct(raft.target, "targetname");
	
	raft MoveTo(goal_struct.origin, 60, 10, 10);
}

event4_first_ship_drones()
{
	level waittill("spawn_first_ship_drones");
	
	standing_drones_spawn = [];
	standing_drones_spawn = GetStructArray("destroyer_1_stand_drone", "targetname");
	
	//-- Spawn in the drones idling
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		standing_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", standing_drones_spawn[i]);
		//standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_ally_us_navy_gunner_unarmed" , standing_drones_spawn);
		//standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
		standing_drones[i] thread maps\_drone::drone_fire_at_vehicle_type("jap_ptboat", 3000);
		wait(0.05);
	}
	
	level waittill("spawn_first_ship_drones");
	
	standing_drones_spawn = [];
	standing_drones_spawn = GetStructArray("destroyer_1_stand_drone_2", "targetname");
	
	//-- Spawn in the drones idling
	
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		standing_drones[i] = maps\_drone::drone_scripted_spawn("actor_ally_us_navy_wet_sailor", standing_drones_spawn[i]);
		standing_drones[i] thread maps\_drone::drone_fire_at_vehicle_type("jap_ptboat", 3000);
		wait(0.05);
	}
}



kamikaze_sound()
{
	self waittill("kamikaze_sound");
	self PlaySound("kamikazi_incoming");
}

// The zero kamikaze into the first destroyer
event4_kamikaze_ship()
{
	level.plane_a waittill("kamikaze_1");
	
	for(i = 1; i < 4; i++)
	{
		plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
		plane.vehicletype = "zero";
		maps\_vehicle::vehicle_init(plane);
	
		crash_path = GetVehicleNode("kamikaze_" + i, "targetname");
		plane AttachPath(crash_path);

		plane thread maps\_vehicle::vehicle_paths(crash_path);
		plane StartPath();
		plane thread kamikaze_sound();
		//plane SetSpeed(200, 100, 100);
		
		if(i == 2)
		{
			
			plane thread event4_kamikaze_path_explode(true);
			plane thread fletcher_animation( "kamikazed_ship", 2);
		}
		else
		{	
			//plane playsound("kamakazi_incoming");
			plane thread event4_kamikaze_path_explode();
		}
		
		if(i == 1)
		{
			plane thread fletcher_animation("kamikazed_ship", 0);
		}
		else if(i == 3)
		{
			plane thread fletcher_animation("kamikazed_ship", 1);
		}
		
		
		wait(0.7 + (RandomFloatRange(0.1, 0.5) * i));
	}
	
	level thread event4_kamikaze_ship_response();
	
	level.plane_a waittill("kamikaze_2");
	
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);

	crash_path = GetVehicleNode("kamikaze_drones", "targetname");
	plane AttachPath(crash_path);
	plane thread maps\_vehicle::vehicle_paths(crash_path);
	plane StartPath();
	plane thread event4_kamikaze_path_explode();
	plane.front_slam = true;

}

event4_kamikaze_filler()
{
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
	plane.vehicletype = "zero";
	plane.dont_target = true;
	maps\_vehicle::vehicle_init(plane);
	
	crash_path = GetVehicleNode("filler_kamikaze", "targetname");
	plane AttachPath(crash_path);
	plane thread maps\_vehicle::vehicle_paths(crash_path);
	plane StartPath();
	plane playsound("kamakazi_incoming");
	plane thread fletcher_animation( "kamikazed_ship", 3);
	//plane SetSpeed(200, 100, 100);
		
	plane thread event4_kamikaze_path_explode(true);

	crash_paths = [];
	crash_paths[0] = GetVehicleNode("zero_attack_filler_0", "targetname");
	crash_paths[1] = GetVehicleNode("zero_attack_filler_1", "targetname");
	
	for(i=0; i < crash_paths.size; i++)
	{
		plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
		plane.vehicletype = "zero";
		maps\_vehicle::vehicle_init(plane);
		
		plane AttachPath(crash_paths[i]);
		plane thread maps\_vehicle::vehicle_paths(crash_paths[i]);
		plane StartPath();
		plane thread event4_kamikaze_path_explode();
		
	}	

}

event4_kamikaze_ship_response()
{
	level endon("stop_shooting_at_kamikazes");
	
	ship_gun_1 = [];
	ship_gun_1[0] = GetStruct("kamikaze_bullet_1_start", "targetname");
	ship_gun_1[1] = GetStruct("kamikaze_bullet_1_end", "targetname");
	ship_gun_2 = [];
	ship_gun_2[0] = GetStruct("kamikaze_bullet_2_start", "targetname");
	ship_gun_2[1] = GetStruct("kamikaze_bullet_2_end", "targetname");
	ship_gun_3 = [];
	ship_gun_3[0] = GetStruct("kamikaze_bullet_3_start", "targetname");
	ship_gun_3[1] = GetStruct("kamikaze_bullet_3_end", "targetname");
}

event4_fire_response_gun(start, end)
{
	level endon("stop_shooting_at_kamikazes");
	rand_value = 0;
	
	forward = AnglesToForward(VectorToAngles(end - start));
	up = AnglesToUp(VectorToAngles(end - start));
	
	for(;;)
	{
		playfx(level._effect["aaa_tracer"], start, forward, up);
		rand_value = RandomFloatRange(0.24, 0.48);
		wait(rand_value);
	}
}

event4_fleet_shoot()
{
	//-- runs the big cannons
	ships = [];
	ships[0] = GetEnt("kamikazed_ship", "targetname");
	ships[1] = GetEnt("ship_number_2", "targetname");
		
	//-- first ship that gets kamikazed
	ships[0] thread fletcher_ai_biggun_think(ships[0].turret_1, ships[0].turret_1_barrel);
	ships[0] thread fletcher_ai_biggun_think(ships[0].turret_2, ships[0].turret_2_barrel);
	//ships[0] thread fletcher_ai_biggun_think(self.turret_3, self.turret_3_barrel);
	ships[0] thread fletcher_ai_biggun_think(ships[0].turret_4, ships[0].turret_4_barrel);
	ships[0] thread fletcher_ai_biggun_think(ships[0].turret_5, ships[0].turret_5_barrel);
	
	//-- second ship that gets kamikazed
	//ships[1] thread fletcher_ai_biggun_think(self.turret_1, self.turret_1_barrel);
	//ships[1] thread fletcher_ai_biggun_think(self.turret_2, self.turret_2_barrel);
	ships[1] thread fletcher_ai_biggun_think(ships[1].turret_3, ships[1].turret_3_barrel);
	ships[1] thread fletcher_ai_biggun_think(ships[1].turret_4, ships[1].turret_4_barrel);
	ships[1] thread fletcher_ai_biggun_think(ships[1].turret_5, ships[1].turret_5_barrel);
	
	level waittill("rescue_2_done");
	
	ships[0] notify("stop_big_guns");
	ships[1] notify("stop_big_guns");
	
	ships[2] = GetEnt("rescue_3_fletcher", "targetname");
	ships[3] = GetEnt("rescue_3_fletcher_b", "targetname");
	
	ships[2] thread fletcher_ai_biggun_think(ships[2].turret_1, ships[2].turret_1_barrel);
	ships[2] thread fletcher_ai_biggun_think(ships[2].turret_2, ships[2].turret_2_barrel);
	ships[2] thread fletcher_ai_biggun_think(ships[2].turret_3, ships[2].turret_3_barrel);
	ships[2] thread fletcher_ai_biggun_think(ships[2].turret_4, ships[2].turret_4_barrel);
	ships[2] thread fletcher_ai_biggun_think(ships[2].turret_5, ships[2].turret_5_barrel);
	ships[3] thread fletcher_ai_biggun_think(ships[3].turret_1, ships[3].turret_1_barrel);
	ships[3] thread fletcher_ai_biggun_think(ships[3].turret_2, ships[3].turret_2_barrel);
	ships[3] thread fletcher_ai_biggun_think(ships[3].turret_3, ships[3].turret_3_barrel);
	ships[3] thread fletcher_ai_biggun_think(ships[3].turret_4, ships[3].turret_4_barrel);
	ships[3] thread fletcher_ai_biggun_think(ships[3].turret_5, ships[3].turret_5_barrel);
}

event4_kamikaze_path_explode(water)
{
	self endon("death");
	
	self waittill("reached_end_node");
	
	self.nodeathfx = true; //-- keeps the deathfx from playing
	self.kamikaze = true; //-- make special death function run
		
	if(IsDefined(water))
	{
		self.impactwater = true;
	}
	
	//level thread event4_kamikaze_end_fx();
	if(!IsDefined(self.impactwater))
	{
		self thread event4_kamikaze_ship_animation();
	}
	
	level notify("stop_shooting_at_kamikazes");
	self notify("death");
}

event4_kamikaze_end_fx()
{
	//level waittill("stop_shooting_at_kamikazes");
	kamikaze_trigger = GetEnt("kamikaze_trigger", "targetname");
	kamikaze_trigger waittill("trigger");
}

event4_sinking_ship()
{
	the_ship = GetEnt("sinking_ship", "targetname");
	the_pivot = GetEnt("sinking_ship_pivot", "targetname");
	
	the_ship LinkTo(the_pivot);
	
	level notify("the_ship_is_sinking");
	the_pivot RotateTo(the_pivot.angles + (-60, 0, 0), 90, 1, 1);
}

event4_part2point5_fake_deaths()
{
	level.plane_a waittill("event4_twopointfive");
	
	path = [];
	path[0] = GetVehicleNode("ev4_fake_death_1", "targetname");
	path[1] = GetVehicleNode("ev4_fake_death_2", "targetname");
	path[2] = GetVehicleNode("ev4_fake_death_3", "targetname");
	
	crashed_zero = [];
	for(i = 0; i < path.size; i++)
	{
		crashed_zero[i] = thread spawn_and_path_a_zero( path[i] , undefined, true, "break_me_now", true);
		wait(2);
	}
}

event4_part2point5()
{
	level thread event4_part2point5_fake_deaths();
	
	level waittill("rescue_2_done");
	
	level thread event4_ptboat_rescue_2_cleanup();
	
	path = [];
	
	//-- attack far ship
	path[0] = GetVehicleNode("ev4_zero_rescue_25_0", "targetname");
	path[1] = GetVehicleNode("ev4_zero_rescue_25_1", "targetname");
	path[2] = GetVehicleNode("ev4_zero_rescue_25_2", "targetname");
	
	//-- attack ship to the side
	path[3] = GetVehicleNode("ev4_zero_rescue_25_3", "targetname");
	path[4] = GetVehicleNode("ev4_zero_rescue_25_4", "targetname");
	path[5] = GetVehicleNode("ev4_zero_rescue_25_5", "targetname");
	
	//-- attack the player
	path[6] = GetVehicleNode("ev4_zero_rescue_25_6", "targetname");
	path[7] = GetVehicleNode("ev4_zero_rescue_25_7", "targetname");
	path[8] = GetVehicleNode("ev4_zero_rescue_25_8", "targetname");
	
	
	plane = [];
	for( i=0; i < 3; i++ )
	{
		plane[i] = spawn_and_path_a_zero( path[i], true, true);
	}
	
	wait(2);
	
	plane = [];
	for( i=3; i < 6; i++ )
	{
		plane[i] = spawn_and_path_a_zero( path[i], true, true);
	}
	
	wait(1);
	
	plane = [];
	for( i=6; i < 9; i++ )
	{
		plane[i] = spawn_and_path_a_zero( path[i], true, true);
	}
}

event4_part3()
{
	//level thread rescue_scene_init_3();
	level thread zero_strafe_sinking_pby(); //-- The Zeros that spray this area
	level thread corsairs_arrive(); //-- The Corsairs that save the area
		
	//-- Stop for 3rd rescue
	//level.plane_a waittill("pby_a_stop_3");
	//level.plane_a waittill("stall_node_1");
	
	//-- QUEUE PLANE STALLING SOUNDS
	//-- THE PBY NEEDS TO DRIFT A LITTLE BIT HERE
	
	level.plane_a waittill("stall_node");
	
	//-- stop other fletchers from firing (hopefully free up ents)
	fletcher = GetEnt("ship_number_2", "targetname");
	fletcher notify("stop firing");
	fletcher = GetEnt("kamikazed_ship", "targetname");
	fletcher notify("stop firing");
	
	//-- swap in nearby model for vehicle
	new_fletcher = swap_model_for_fletcher( "rescue_3_fletcher_c" );
	new_fletcher thread fletcher_ai_biggun_think(fletcher.turret_1, fletcher.turret_1_barrel);
	new_fletcher thread fletcher_ai_biggun_think(fletcher.turret_2, fletcher.turret_2_barrel);
	new_fletcher thread fletcher_ai_biggun_think(fletcher.turret_3, fletcher.turret_3_barrel);
	new_fletcher thread fletcher_ai_biggun_think(fletcher.turret_4, fletcher.turret_4_barrel);
	new_fletcher thread fletcher_ai_biggun_think(fletcher.turret_5, fletcher.turret_5_barrel);
	
	level.plane_a notify("audio_plane_stop");
	level.plane_a SetSpeed(0, 100, 100);
	
	//level notify("rescue_3_done");
	//level waittill("corsairs_arrive");
	event6(); //-- fly away and corsairs arrive
}

event4_sound_notifies()
{
	//-- slowdown the prop
	level.plane_a waittill("audio_plane_kill_prop");
	level.plane_a thread maps\pby_fly_amb::start_plane_landed_sound();
	wait(1);
	level.plane_a thread maps\pby_fly_amb::stop_plane_prop_sounds();
	level.plane_b thread maps\pby_fly_amb::stop_plane_prop_sounds(); //-- TODO: TIME OUT THIS PLANES ACTUAL LANDING SOUNDS
			
	//-- plane hits the water
	level.plane_a waittill("pby_landed");
	level.plane_a thread maps\pby_fly_amb::stop_plane_wind_sounds();
	
	//-- start the plane up again
	level.plane_a waittill("audio_plane_starting");
	level.plane_a thread maps\pby_fly_amb::setup_plane_sounds(true);
	
	//-- stop the plane again
	level.plane_a waittill("audio_plane_stop");
	level.plane_a thread maps\pby_fly_amb::stop_plane_wind_sounds();
	level.plane_a thread maps\pby_fly_amb::stop_plane_prop_sounds();
	
	//-- start the plane up again
	level.plane_a waittill("audio_plane_starting");
	level.plane_a thread maps\pby_fly_amb::setup_plane_sounds(true);
}

#using_animtree ("vehicles");

event4_pby_crashing()
{
	level.plane_b waittill("being_shot_down");
	
	flag_set( "disable_random_dialogue" );
	level.plane_b.engine_fire = level.plane_b thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "prop_right_jnt");
	//-- HARRINGTON: We're hit!
	play_sound_over_radio("PBY1_IGD_075A_HARR");
	
		
	level.plane_b.engine_fire Delete();
	level.plane_b.engine_fire = level.plane_b thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg2"], "prop_right_jnt");
	level anim_single_solo( level.plane_a.pilot, "booth_your_number_two_engine_is");
	//-- HARRINGTON: I am trying!... The controls are shot to Hell
	play_sound_over_radio("PBY1_IGD_077A_HARR");
	level thread anim_single_solo( level.plane_a.pilot, "booth_hold_it_together");
	
	thread play_sound_over_radio("PBY1_IGD_079A_HARR");
	wait(1);
		
	//-- delete the gunners
	level.plane_b notify("cleanup blister gunners");
	//-- Spawn in Fake PBY and Animate it
	plane_b_fake = Spawn("script_model", level.plane_b.origin);
	plane_b_fake SetModel("vehicle_usa_pby_exterior_blackcat");
	plane_b_fake.angles = level.plane_b.angles;
	plane_b_fake.animname = "pby";
	plane_b_fake UseAnimTree( #animtree );
	
	level.plane_b.engine_fire Unlink();
	level.plane_b.engine_fire LinkTo(plane_b_fake, "prop_right_jnt");
	plane_b_fake.engine_fire = level.plane_b.engine_fire;
	
	//-- Hide and get rid of the rest of the pby
	level.plane_b Hide();
	//level.plane_b.pilot Hide();
	//level.plane_b.copilot Hide();
	//level.plane_b.radioop Hide();
	if(IsDefined(level.plane_b.running_lights))
	{
		level.plane_b.running_lights Delete();
	}
	
	if(IsDefined(level.plane_b.engine_fx_left))
	{
		level.plane_b.engine_fx_left Delete();
	}
	
	if(IsDefined(level.plane_b.engine_fx_right))
	{
		level.plane_b.engine_fx_right Delete();
	}
	
	level.plane_b.props_running = false;
	level.plane_b Delete();
		
	/////////////////////////////////////////////
	
	plane_b_fake.wing_sound_ent = Spawn("script_model", plane_b_fake GetTagOrigin("pontoon_right_jnt"));
	plane_b_fake.wing_sound_ent SetModel("tag_origin");
	plane_b_fake.wing_sound_ent LinkTo(plane_b_fake, "pontoon_right_jnt");
		
	//level.plane_b.engine_fire Delete();
	//level.plane_b.engine_fire = level.plane_b thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg3"], "prop_right_jnt");
	//-- HARRINGTON: Mayday! Mayday! We are going down...
	
	plane_b_fake thread anim_single_solo( plane_b_fake, "crash2" );	
	
	//wait(2);
	plane_b_fake waittill( "i exploded" );
	
	level thread pby_b_hit_water(plane_b_fake);
	level anim_single_solo( level.plane_a.pilot, "booth_HARRINGTON");

	//TUEY Sets music state to LANDING
	setmusicstate("LANDING");

	level waittill("we_lost_chesire");	



	level anim_single_solo( level.plane_a.pilot, "booth_damnit_we_lost_cheshire");
	level anim_single_solo( level.plane_a.pilot, "were_on_our_own");
	level notify("plane_b_is_crashed");
	flag_clear("disable_random_dialogue");
}

pby_b_explosion( guy )
{
	//level.plane_b.engine_fire Delete();
	self.engine_fire Delete();
	self.engine_explosion = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_explosion_ai"], "prop_right_jnt", undefined, (0,180,0));
	self PlaySound("pby_3p_die");
	self.wing_sound_ent PlaySound("pby_3p_wing_by");
	
	self notify( "i exploded");
	
	wait(1);
	self.engine_trail = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg3"], "prop_right_jnt");
	wait(3);
	level notify("we_lost_chesire");
}

pby_b_hit_water(plane_b_fake)
{
	while(plane_b_fake.origin[2] > 63)
	{
		wait(0.05);
	}
	//-- should splash when the plane hits the water!
	PlayFX( level._effect["zero_water"], plane_b_fake.origin);
	
	plane_b_fake Delete();
}

spawn_and_path_a_ptboat(path, end_on_end, fire_on_drones, destructible_def, new_targetname)
{
	if(IsDefined(destructible_def))
	{
		random_destructdef = "dest_ptboat_rescue" + RandomIntRange(1, 4);
		if(IsDefined(new_targetname))
		{
			the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", new_targetname, "jap_ptboat", (0,0,0), (0,0,0), random_destructdef);
		}
		else
		{
			the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0), random_destructdef);
		}
		the_ptboat thread ptboat_torpedo_watch();
		the_ptboat.cycle_time = 1.5;
	}
	else
	{
		if(IsDefined(new_targetname))
		{
			the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", new_targetname, "jap_ptboat", (0,0,0), (0,0,0) );
		}
		else
		{
			the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		}
	}
	
	the_ptboat.vehicletype = "jap_ptboat";

	if(IsDefined(fire_on_drones))
	{
		the_ptboat.shoot_at_drones = fire_on_drones;
	}
	
	maps\_vehicle::vehicle_init(the_ptboat);
	if(IsDefined(destructible_def))
	{
		the_ptboat.destructible_def = destructible_def;
		the_ptboat thread ptboat_destructible_damage_thread();
	}
	the_ptboat AttachPath(path);
	the_ptboat thread maps\_vehicle::vehicle_paths(path);
		
	if(IsDefined(end_on_end))
	{
		the_ptboat thread ptboat_delete_at_end_of_path();
	}
	
	//-- engine loop sound
	the_ptboat.has_engine_sound = true;
	the_ptboat PlayLoopSound("pt_engines");
	
	return the_ptboat;
}

spawn_and_path_a_shark( path )
{
	the_shark = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
	the_shark.vehicletype = "jap_ptboat";
	the_shark.im_a_shark = true;
		
	maps\_vehicle::vehicle_init(the_shark);
	
	the_shark SetCanDamage(false);
	the_shark AttachPath(path);
	the_shark thread maps\_vehicle::vehicle_paths(path);
	the_shark thread ptboat_delete_at_end_of_path();
	the_shark Hide();
	
	return the_shark;
}


ptboat_torpedo_watch()
{
	self endon("death");
	
	forward = -168;
	up = 88;
	right = 96;
	
	for( ; ; )
	{
		self waittill( "broken", recieved_notify );
		
		if( recieved_notify == "left_torpedo_destroyed" || recieved_notify == "right_torpedo_destroyed")
		{
			
			dmg_origin = self.origin + (AnglesToForward(self.angles) * forward);
			if(recieved_notify == "right_torpedo_destroyed")
			{
				dmg_origin = dmg_origin + (AnglesToRight(self.angles) * right);
			}
			else //-- the left torpedo
			{
				dmg_origin = dmg_origin + (AnglesToRight(self.angles) * ( right * -1 ));
			}
			dmg_origin = dmg_origin + (AnglesToUp(self.angles) * up);
					
			wait_float = RandomFloatRange(0.1, 0.2);
			wait(wait_float);
			RadiusDamage(dmg_origin, 500, 5000, 5000);
		}
		
		wait(0.05); //Wait A Frame
	}
	
}

spawn_and_path_a_zero( path , kamikaze_explode, have_sound, damage_at_pathend, no_explode, water)
{
	//pby_ok_to_spawn();
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", (0,0,0), (0,0,0) );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);
	
	ASSERTEX( IsDefined(path), "No path defined for zero that just got spawned");
	plane AttachPath(path);
	plane thread maps\_vehicle::vehicle_paths(path);
	plane StartPath();
	
	if(IsDefined(kamikaze_explode))
	{
		if( IsDefined(water) )
		{
			plane thread event4_kamikaze_path_explode(water);
		}
		else
		{
			plane thread event4_kamikaze_path_explode();
		}
	}
	
	if(IsDefined(no_explode))
	{
		plane.no_explode = true;
	}
			
			
	if(IsDefined(have_sound))
	{
		plane.audio_node_propzero = Spawn("script_model", plane.origin);
		plane.audio_node_propzero SetModel("tag_origin");
		plane.audio_node_propzero LinkTo(plane, "tag_origin", (0,0,0), (0,0,0));
			
		plane playloopsound("zero_steady");
		//plane thread maps\pby_fly_amb::play_plane_passby(plane);
	}
	
	if(IsDefined(damage_at_pathend))
	{
		plane thread damage_at_end_of_path(10000, damage_at_pathend);
	}
	
	plane thread draw_debug_line_to_target_distance( level.plane_a );
	
	//plane thread spawn_and_attach_shark();
	
	return plane;
}

spawn_and_attach_shark()
{
	shark = Spawn("script_model", self.origin);
	shark SetModel("greatwhite_shark");
	shark.angles = self.angles + (90,0,0);
	
	shark LinkTo(self);
	self Hide();
}


damage_at_end_of_path( dmg_amnt , dmg_notify )
{
	self waittill(dmg_notify);
	
	self SetCanDamage(true);
	RadiusDamage( self.origin, 200, dmg_amnt, dmg_amnt );
}

spawn_and_path_a_corsair( path, shoot_my_turret_delay )
{
	//pby_ok_to_spawn();
	plane = SpawnVehicle( "vehicle_usa_aircraft_f4ucorsair", "new_plane", "corsair", (0,0,0), (0,0,0) );
	plane.vehicletype = "corsair";
	maps\_vehicle::vehicle_init(plane);
	
	ASSERTEX( IsDefined(path), "No path defined for zero that just got spawned");
	plane AttachPath(path);
	plane thread maps\_vehicle::vehicle_paths(path);
	plane StartPath();
	
	plane thread corsair_spin_prop();
	
	plane.animname = "zero";
	plane thread anim_loop_solo(plane, "idle", undefined, "death");
	//plane maps\_vehiclenames::get_name();
	
	//-- uses the same sounds as the zeroes
	plane.audio_node_propzero = Spawn("script_model", plane.origin);
	plane.audio_node_propzero SetModel("tag_origin");
	plane.audio_node_propzero LinkTo(plane, "tag_prop", (0,0,0), (0,0,0));
			
	plane playloopsound("zero_steady");
	//plane thread maps\pby_fly_amb::play_plane_passby(plane);
	plane thread maps\pby_fly_amb::play_zero_sounds(level.plane_a, level.plane_b);
	
	if(IsDefined(shoot_my_turret_delay))
	{
		plane thread corsair_fire( shoot_my_turret_delay );
	}
	
	return plane;
}

corsair_fire( delay )
{	
	self endon("death");
	self endon("stop firing");
	self endon("shot_down_by_corsair");
	
	if(IsDefined(delay))
	{
		wait(delay);
	}
	
	while( 1 )
	{
		for(z = 0; z < 20; z++)
		{
			for( i  = 0; i < 2; i++ )
			{
				self.mgturret[i] shootturret(); 
				wait(0.05);
			}
			wait(0.1);
		}
	}		
}




event4_ptboat_save_second_guy()
{
	level.plane_a waittill("survivor_2_go");
	
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("ev4_sg2_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("ev4_sg2_1", "targetname");
	
	the_ptboats = [];
	
	for(i=0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true);
		the_ptboats[i] StartPath();
	}
	
	level thread event4_ptboat_save_second_guy_track(the_ptboats);
}

event4_ptboat_save_second_guy_track(boat_array)
{
	all_boats_dead = false;
	
	while(!all_boats_dead)
	{
		all_boats_dead = true;
		
		for(i=0; i < boat_array.size; i++)
		{
			if(IsAlive(boat_array[i]))
			{
				all_boats_dead = false;
			}
		}
		
		wait(0.1);
	}
	
	level notify("all_story_boats_dead");
}

event4_ptboat_save_third_guy()
{
	level.plane_a waittill("survivor_3_go");
	
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("ev4_sg3_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("ev4_sg3_1", "targetname");
	
	the_ptboats = [];
	
	for(i=0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true);
		the_ptboats[i] StartPath();
	}
	
	level thread event4_ptboat_save_second_guy_track(the_ptboats);
}

event4_ptboat_control()
{
	level thread event4_ptboat_ambush();
	level thread event4_ptboat_rescue_2();
	//level thread event4_ptboat_first_wave();
	//level thread event4_ptboat_second_wave(); -- put this back in
	//level thread event4_ptboat_third_wave();
	//level thread event4_ptboat_fourth_wave();
}

event4_ptboat_rescue_2_dialog()
{
	level waittill("rescue_2_dialog_1");
	
	flag_set( "disable_random_dialogue" );
	anim_single_solo(level.plane_a.pilot, "booth_9_oclock");
	anim_single_solo(level.plane_a.pilot, "booth_keep_firing_on_those");
	wait(0.5);
	play_sound_over_radio( level.scr_sound["laughlin"]["where_the_hells_that_support"] );
	wait(0.15);
	//anim_single_solo( level.plane_a.radioop, "landry_please_respond");
	anim_single_solo( level.plane_a.radioop, "landry_theres_no_response");
	wait(0.15);
	play_sound_over_radio( level.scr_sound["laughlin"]["shit_we_gotta_go"] );
	wait(0.05);
	anim_single_solo( level.plane_a.pilot, "booth_not_yet_laughlin");
	flag_clear( "disable_random_dialogue" );
	
	
	//-- check and see if the ptboats are still available and if they are then point them out
	flag_wait("rescue_2_2nd_ptboats_spawned");
	
	if(!flag("rescue_2_2nd_ptboats_killed"))
	{
		flag_set( "disable_random_dialogue" );
		//play_sound_over_radio( level.scr_sound["laughlin"]["9_oclock"] );
		play_sound_over_radio( level.scr_sound["laughlin"]["sons_of_bitches"] );
		play_sound_over_radio( level.scr_sound["laughlin"]["9_oclock"] );
		flag_clear( "disable_random_dialogue" );
	}
	
	flag_wait("rescue_2_3rd_ptboats_spawned");
	
	if(!flag("rescue_2_3rd_ptboats_killed"))
	{
		wait(4);
		flag_set( "disable_random_dialogue" );
		play_sound_over_radio( level.scr_sound["laughlin"]["7_oclock"] );
		wait(0.15);
		play_sound_over_radio( level.scr_sound["laughlin"]["10_oclock"] );
		flag_clear( "disable_random_dialogue" );
		
		wait(5);
		if(!flag("rescue_2_3rd_ptboats_killed"))
		{
			anim_single_solo(level.plane_a.pilot, "booth_incoming_left_side");
			anim_single_solo(level.plane_a.pilot, "booth_keep_firing_on_those");		
		}
	}
}

event4_ptboat_rescue_2_cleanup()
{
	level notify("rescue_2_cleanup");
	
	trash_boats = [];
	trash_boats = GetEntArray( "rescue_2_ptboat", "targetname" );
	
	for(i = 0; i < trash_boats.size; i++)
	{
		trash_boats[i] Delete();
	}
}

event4_ptboat_rescue_2()
{
	//level endon("rescue_2_cleanup");
	
	level thread event4_ptboat_rescue_2_dialog();
	level.plane_a waittill("survivor_2_go");
	
	//level thread maps\_flare::flare_from_targetname( "flare2", 1, 2, 1, ( 0.83, 0.82, 1 ) );
	
	ptboats = [];
	ptboat_paths = [];
	
	ptboat_paths[0] = GetVehicleNode("rescue2_ptboat_surv_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("rescue2_ptboat_surv_1", "targetname");
		
	for(i = 0; i < ptboat_paths.size; i++)
	{
		//ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], undefined, undefined, true, "rescue_2_ptboat");
		ptboats[i] StartPath();
		ptboats[i].notify_level = true;
		//ptboats[i].specific_target = level.plane_b;
	}
	
	for(i = 0; i < ptboats.size; i++)
	{
		ptboats[i] thread manage_ptboat_target(level.survivors_group_2);
	}
	
	level notify("rescue_2_dialog_1");
	
	level waittill("ptboat_died");
	level waittill("ptboat_died"); //-- there are only 2 now
	flag_set("rescue_2_2nd_ptboats_spawned");
	
	//level waittill("ptboat_died"); //-- all 3 ptboats died now... so spawn planes! yay! oh and more ptboats
	
	ptboats = [];
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("rescue2_ptboat_surv_3", "targetname");
	ptboat_paths[1] = GetVehicleNode("rescue2_ptboat_surv_4", "targetname");
		
	for(i = 0; i < ptboat_paths.size; i++)
	{
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true, "rescue_2_ptboat");
		//ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], undefined, undefined, true, "rescue_2_ptboat");
		ptboats[i] StartPath();
		ptboats[i].my_path = ptboat_paths[i];
		ptboats[i].notify_level = true;
		//ptboats[i].specific_target = level.plane_b;
	}
	
	for(i = 0; i < ptboats.size; i++)
	{
		ptboats[i] thread manage_ptboat_target(level.survivors_group_2);
	}
	
	level thread event4_ptboat_rescue_2_zeros_spawn_b();
	
	wait(12);
	//level waittill("ptboat_died");
	//level waittill("ptboat_died");
	flag_set("rescue_2_2nd_ptboats_killed");
	
	level thread event4_ptboat_rescue_2_zeros_spawn_c();
	level thread zero_strafe_defending_boat();
	
	ptboats = [];
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("rescue2_ptboat_surv_20", "targetname");
	ptboat_paths[1] = GetVehicleNode("rescue2_ptboat_surv_21", "targetname");
	//ptboat_paths[2] = GetVehicleNode("rescue2_ptboat_surv_22", "targetname");
	ptboat_paths[2] = GetVehicleNode("rescue2_ptboat_surv_23", "targetname");
		
	for(i = 0; i < ptboat_paths.size; i++)
	{
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true, "rescue_2_ptboat");
		ptboats[i] StartPath();
		ptboats[i].my_path = ptboat_paths[i];
		ptboats[i].notify_level = true;
		//ptboats[i].specific_target = level.plane_b;
	}
	
	flag_set("rescue_2_3rd_ptboats_spawned");
	
	for(i = 0; i < ptboats.size; i++)
	{
		ptboats[i] thread manage_ptboat_target(level.survivors_group_2);
	}
	
	while(ptboats.size > 0)
	{
		ptboats = GetEntArray("rescue_2_ptboat", "targetname");
		wait(0.1);
	}
		
	flag_set("rescue_2_3rd_ptboats_killed");
}




event4_ptboat_rescue_2_zeros_spawn_b()
{
	plane = undefined;
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("zero_attack_rescue2_1", "targetname");
	plane_paths[1] = GetVehicleNode("zero_attack_rescue2_0", "targetname");
	plane_paths[2] = GetVehicleNode("zero_attack_rescue2_2", "targetname");
		
	for(i = 0; i < plane_paths.size; i++)
	{	
		plane[i] = spawn_and_path_a_zero( plane_paths[i], true, true);
				
		if(i == 0)
		{
			wait(1.5);
		}
	}
	
	wait(3);
	
	plane_paths[0] = GetVehicleNode("zero_attack_rescue2_2", "targetname");
	plane_paths[1] = GetVehicleNode("zero_attack_rescue2_3", "targetname");
	plane_paths[2] = GetVehicleNode("zero_attack_rescue2_1", "targetname");
	plane_paths[3] = GetVehicleNode("zero_attack_rescue2_0", "targetname");
		
	for(i = 0; i < plane_paths.size; i++)
	{	
		plane[i] = spawn_and_path_a_zero( plane_paths[i], true, true);	
		
		if(i == 0)
		{
			wait(1);
		}
		else if(i == 2)
		{
			wait(2);
		}
	}	
}

event4_ptboat_rescue_2_zeros_spawn_c()
{
	plane = undefined;
	plane_paths = [];
	
	plane_paths[0] = GetVehicleNode("zero_attack_rescue2_20", "targetname");
	plane_paths[1] = GetVehicleNode("zero_attack_rescue2_21", "targetname");
	plane_paths[2] = GetVehicleNode("zero_attack_rescue2_22", "targetname");
	plane_paths[3] = GetVehicleNode("zero_attack_rescue2_20", "targetname");
	plane_paths[4] = GetVehicleNode("zero_attack_rescue2_21", "targetname");
	plane_paths[5] = GetVehicleNode("zero_attack_rescue2_22", "targetname");
	plane_paths[6] = GetVehicleNode("zero_attack_rescue2_20", "targetname");
	plane_paths[7] = GetVehicleNode("zero_attack_rescue2_21", "targetname");
	plane_paths[8] = GetVehicleNode("zero_attack_rescue2_22", "targetname");
		
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = spawn_and_path_a_zero( plane_paths[i], true, true);
				
		if(i == 4)
		{
			wait(4);
		}
		else
		{
			random_wait = RandomFloatRange(1.0, 2.0);
			wait(random_wait);
		}
	}
}

event4_ptboat_ambush()
{
	level thread event4_ptboat_ambush_dialogue();
	level.plane_a waittill("switch_for_pby_pt");
	
	wait(3);
	
	ptboats = [];
	ptboat_paths = [];
	
	//ptboat_paths[0] = GetVehicleNode("ambush_pt", "targetname");
	//ptboat_paths[1] = GetVehicleNode("ambush_pt_2", "targetname");
	ptboat_paths[0] = GetVehicleNode("ptboat_hunt_rescue_1", "targetname");
	ptboat_paths[1] = GetVehicleNode("ptboat_hunt_rescue_2", "targetname");
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		ptboats[i] StartPath();
		ptboats[i].notify_level = true;
		//ptboats[i].specific_target = level.plane_b;
	}
	
	//-- wait until player has switched to the right turret before swinging the light and stuff over
	//level.player waittill("done_switching_turrets"); GLOCKE: 9/16 -this is an old line, not sure why its still here.
	
	for(i = 0; i < ptboats.size; i++)
	{
		//-- These PT Boats attack swimmers first: level.amb_surv_group_1
		ptboats[i] thread manage_ptboat_target(level.survivors_group_1);
	}
	
	level waittill("ptboat_died");
	level waittill("ptboat_died"); //-- both ptboats died now... so spawn planes! yay! oh and more ptboats
	
	ptboat_paths[0] = GetVehicleNode("ptboat_hunt_rescue_3", "targetname");
	ptboat_paths[1] = GetVehicleNode("ptboat_hunt_rescue_4", "targetname");
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		ptboats[i] StartPath();
		ptboats[i].notify_level = true;
		//ptboats[i].specific_target = level.plane_b;
	}
		
	for(i = 0; i < ptboats.size; i++)
	{
		//-- These PT Boats attack swimmers first: level.amb_surv_group_1
		ptboats[i] thread manage_ptboat_target(level.survivors_group_1);
	}
	
	ptboats[0] thread watch_ptboat_for_dialogue( "rescue1_ptboat_incoming" );
	
	plane = undefined;
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("zero_attack_rescue_3", "targetname");
	plane_paths[1] = GetVehicleNode("zero_attack_rescue_5", "targetname");
	
	level notify( "ambush_plane_dialogue");
	
	for(j = 0; j < 2; j++)
	{
		for(i = 0; i < plane_paths.size; i++)
		{	
			plane[i] = spawn_and_path_a_zero( plane_paths[i], true, true);					
			wait(1);
		}
		wait(1.5);
	}
	
	//-- This is so that I can switch people earlier on the spline
	while( IsAlive( plane[0] ) ||  IsAlive( plane[1] ) || IsAlive( ptboats[0] ) || IsAlive( ptboats[1] ))
	{
		wait( 0.1 );
	}
	
	flag_set( "zero_rescue_1_dead" );
	
}

event4_ptboat_ambush_dialogue()
{
	level waittill("ambush_plane_dialogue");
	flag_set("disable_random_dialogue");
	//anim_single_solo(level.plane_a.pilot, "booth_3_oclock");
	
	anim_single_solo(level.plane_a.pilot, "booth_zeroes_exclamation");
	play_sound_over_radio( level.scr_sound["laughlin"]["3_oclock"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["high"] );
	
	wait(1);
	
	anim_single_solo(level.plane_a.pilot, "booth_shit_more_ptboats");
	anim_single_solo(level.plane_a.pilot, "booth_5_oclock");
	
	wait(2);
	

	anim_single_solo(level.plane_a.radioop, "landry_this_is_blackcat");
	anim_single_solo(level.plane_a.radioop, "landry_the_fleet_is_down");
	anim_single_solo(level.plane_a.radioop, "landry_we_have_multiple");
	anim_single_solo(level.plane_a.radioop, "landry_taking_heavy_fire");
	anim_single_solo(level.plane_a.radioop, "landry_requesting_immediate");
	anim_single_solo(level.plane_a.pilot, "booth_landry_any_word_on_that");
	anim_single_solo(level.plane_a.radioop, "landry_im_getting_nothing_on");
	anim_single_solo(level.plane_a.pilot, "booth_keep_trying_we_better_pray");
	
	flag_clear("disable_random_dialogue");
}

watch_ptboat_for_dialogue( my_notify )
{
	self waittill("ptboat_dialogue");
	level notify("my_notify");
}

manage_ptboat_target( _targets )
{
	self endon("death");
	
	for( i = 0; i < _targets.size; i++)
	{
		if(IsAlive(_targets[i]) && !IsDefined(self.rescued))
		{
			self.specific_target = _targets[i];	
			
			while(IsAlive(self.specific_target))
			{
				wait(0.2);
			}
		}
	}
	
	//-- target the plane if you run out of other targets
	self.specific_target = level.plane_a;
}

event4_ptboat_first_wave()
{
	level.plane_a waittill("pby_a_stop_1");
	
	ptboat_paths = [];
	ptboat_paths[0] = GetVehicleNode("ev4_sg2_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("ev4_sg2_1", "targetname");
	
	the_ptboats = [];
	
	for(i=0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		the_ptboats[i] StartPath();
	}
}

event4_ptboat_second_wave()
{
	level.plane_a waittill("speeding_up");
	
	ptboat_paths = [];
	for(i = 0; i < 4; i++)
	{
		ptboat_paths[i] = GetVehicleNode("event4_transboat_" + i, "targetname");
	}

	the_ptboats = [];
	for(i=0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		the_ptboats[i] StartPath();
	}
}

event4_ptboat_third_wave()
{
	level.plane_a waittill("slowing_down");
	
	ptboat_paths = [];
	for(i = 0; i < 3; i++)
	{
		ptboat_paths[i] = GetVehicleNode("event4_ptboat_surv2_" + i, "targetname");
	}

	the_ptboats = [];
	for(i=0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, true);
		the_ptboats[i] StartPath();
	}
}

event4_ptboat_fourth_wave()
{
	level.plane_a waittill("speeding_up_2");
	
	ptboat_paths = [];
	for(i = 0; i < 4; i++)
	{
		ptboat_paths[i] = GetVehicleNode("ev4_ptboat_fourth_wave_" + i, "targetname");
	}

	for(j = 0; j < 2; j++)
	{
		the_ptboats = [];
		for(i=0; i < ptboat_paths.size; i++)
		{
			the_ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, true);
			the_ptboats[i] StartPath();
		}
		
		wait(13);
	}
}

rescue_scenario()
{
	self endon("got tired");
	self waittill("ready_to_be_saved");
	
	possible_player = level.undef;
	while(possible_player == level.undef)
	{
		wait(0.1);
		possible_player = is_there_a_player_in_seat(self.plane, self.side);
	}
	
	flag_set("saver_ready");
	possible_player.in_saving_position = true;
	
	possible_player waittill("perform_save");
	
	if( possible_player.in_transition || is_there_a_player_in_seat(self.plane, self.side) == level.undef)
	{
		return;
	}
	
	self notify("being saved");
	level notify("survivor_saved");
	level.plane_a notify("spotlight_off");
	//self UnLink();
	
	self SetCanDamage(false);
	
	possible_player thread play_rescue_animation(level.plane_a, self.side);
	
	//self.animname = "being_saved";
	
	//-- stop the clipping!
	idle_holder = self.plane.current_idle;
	self.plane pby_veh_idle("float_static");
	//self.plane pby_veh_idle("none");
		
	rand_val = 0;
	if(self.side == "left")
	{
		self.plane anim_single_solo(self, "rescue_over_left", "tag_blister_left_rescue");
		//rand_value = RandomIntRange(0,2);
		//self.plane anim_single_solo(self, "enter_pby_left_" + rand_value, "tag_blister_left_rescue");
	}
	else
	{
		self.plane anim_single_solo(self, "rescue_over_right", "tag_blister_right_rescue");
		//rand_value = RandomIntRange(0,2);
		//self.plane anim_single_solo(self, "enter_pby_right_" + rand_value, "tag_blister_right_rescue");
	}
	
	bunk_tag = get_empty_bunk(self.plane);
	
	self Hide();
	if(bunk_tag == "tag_bunk_left_bottom")
	{
		self Unlink();
		wait(0.5);
		
		self Show();
		self LinkTo(self.plane, "tag_engineer", (0,0,0), (0,0,0));
	
		self.animname = "rescue_a_4";
		self.plane thread anim_loop_solo(self, "my_idle", "tag_engineer");
	}
	else if(bunk_tag == "tag_bunk_left_top")
	{
		self Unlink();
		wait(0.5);
		
		self Show();
		self LinkTo(self.plane, "tag_engineer", (0,0,0), (0,0,0));
				
		self.animname = "rescue_a_3";
		self.plane thread anim_loop_solo(self, "my_idle", "tag_engineer");
	}
	else if(bunk_tag == "tag_bunk_right_bottom")
	{
		self Unlink();
		wait(0.5);
		
		self Show();
		self LinkTo(self.plane, "tag_engineer", (0,0,0), (0,0,0));
				
		level.crash_guy =  self;
		self.animname = "rescue_a_1";
		self.plane thread anim_loop_solo(self, "my_idle", "tag_engineer");
	}
	else //tag_bunk_right_top
	{
		self Unlink();
		wait(0.5);
		
		self Show();
		self LinkTo(self.plane, "tag_engineer", (0,0,0), (0,0,0));
				
		self.animname = "rescue_a_2";
		self.plane thread anim_loop_solo(self, "my_idle", "tag_engineer");
	}
	
	//-- For On Screen Counter
	level.survivor_save_count++;
	
	self notify("rescued");
	self.rescued = true;
	
	flag_clear("rescue_ready");
	flag_clear("saver_ready");
	
	self.plane pby_veh_idle(idle_holder);
}

play_rescue_animation(plane, side)
{
	self.save_anim = true;
	
	//-- Take the player off of the plane
	plane UseBy(self);
	
	if(side == "left")
	{
		anim_str = "pby_left_rescue";
	}
	else
	{
		anim_str = "pby_right_rescue";
	}
	//-- plays the animation	
	startorg = getstartOrigin( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
	startang = getstartAngles( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
		
	player_hands = spawn_anim_model( "player_hands" );
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	//player_hands LinkTo(plane);
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;
	//self PlayerLinkTo(player_hands, "tag_player", 1.0, 10, 10, 10, 10);
	self playerlinktoabsolute(player_hands, "tag_player" );
		
	plane maps\_anim::anim_single_solo( player_hands, anim_str );
	
	player_hands thread delete_later();
	//-- end playing the animation
	
	if(self.current_seat == "pby_leftgun")
	{
		plane usevehicle(self, 2);
	}
	else
	{
		plane usevehicle(self, 3);
	}
	
	self.save_anim = false;
}

get_empty_bunk(plane)
{
	for(i=0; i < plane.bunks.size; i++)
	{
		if(plane.bunks[i]["status"] == "empty")
		{
			//tag_position = plane GetTagOrigin(plane.bunks[i]["tag"];
			//return tag_position;
			plane.bunks[i]["status"] = "full";
			return plane.bunks[i]["tag"];
		}
	}	
	
	return("tag_origin");
	//ASSERTEX(false, "THERE WERE NO FREE BUNKS");
}

is_there_a_player_in_seat(plane, seat)
{
	if(seat == "left")
	{
		seat_wanted = "pby_leftgun";
	}
	else
	{
		seat_wanted = "pby_rightgun";
	}
	
	if(level.player.current_seat == seat_wanted)
	{
		return level.player;
	}
		
	return level.undef;
}

//-- THIS SPAWNS THE GUYS THAT WILL NEED TO BE SAVED, BUT DOESN'T INIT THEM, BECAUSE THE PBY NEEDS TO GET INTO POSITION FIRST
rescue_scene_init_1()
{
	surv_spawners = [];
	level.survivors_group_1 = [];
	
	surv_spawners[0] = GetEnt("survivor_rescue_1_0_a", "targetname");
	surv_spawners[1] = GetEnt("survivor_rescue_1_0_b", "targetname");
	surv_spawners[2] = GetEnt("survivor_rescue_1_0_c", "targetname");
	surv_spawners[3] = GetEnt("survivor_rescue_1_0_d", "targetname");
	surv_spawners[4] = GetEnt("survivor_rescue_1_0_e", "targetname");
	surv_spawners[5] = GetEnt("survivor_rescue_1_0_f", "targetname");
	surv_spawners[6] = GetEnt("survivor_rescue_1_0_g", "targetname");
	surv_spawners[7] = GetEnt("survivor_rescue_1_0_h", "targetname");
	surv_spawners[8] = GetEnt("survivor_rescue_1_0_i", "targetname");
	surv_spawners[9] = GetEnt("survivor_rescue_1_0_j", "targetname");
	surv_spawners[10] = GetEnt("survivor_rescue_1_0_k", "targetname");
	surv_spawners[11] = GetEnt("survivor_rescue_1_0_l", "targetname");
	surv_spawners[12] = GetEnt("survivor_rescue_1_0_m", "targetname");
	
	for(i = 0; i<surv_spawners.size; i++)
	{
		level.survivors_group_1[i] = surv_spawners[i] StalingradSpawn();
		level.survivors_group_1[i] thread survivor_init(level.plane_a, "_group_1", 0);
		//level.survivors_group_1[i] thread magic_bullet_shield();
		
		
		attachSize = level.survivors_group_1[i] getAttachSize();
		level.survivors_group_1[i].gearstuff = [];
		for (j = 0; j < attachSize; j++)
		{
			level.survivors_group_1[i].gearstuff[j] = level.survivors_group_1[i] getAttachModelName(j);
		}
		
		surv_spawners[i] Delete();
	}
	
	amb_surv_spawners = GetEntArray("ambient_rescue_1_0", "targetname");
	
	for(i = 0; i < amb_surv_spawners.size; i++)
	{
		level.amb_surv_group_1[i] = amb_surv_spawners[i] StalingradSpawn();
		level.amb_surv_group_1[i] thread survivor_init_ambient();
		amb_surv_spawners[i] Delete();
	}
	
	level thread event4_rescue_1_ambient_flee_pt();
}

event4_rescue_1_ambient_flee_pt()
{
	goal_structs = [];
	goal_structs = GetStructArray("rescue_1_swimmers_goal", "targetname");
	
	for( i=0; i < level.amb_surv_group_1.size; i++)
	{
		level.amb_surv_group_1[i] notify("stop treading");
		level.amb_surv_group_1[i] StopAnimScripted();
		level.amb_surv_group_1[i].goal_radius = 32;
		level.amb_surv_group_1[i] SetGoalPos(goal_structs[i].origin);
	}
}

rescue_scene_init_2()
{
	surv_spawners = [];
	level.survivors_group_2 = [];
	
	surv_spawners[0] = GetEnt("survivor_rescue_2_a", "targetname");
	surv_spawners[1] = GetEnt("survivor_rescue_2_b", "targetname");
	surv_spawners[2] = GetEnt("survivor_rescue_2_c", "targetname");
	surv_spawners[3] = GetEnt("survivor_rescue_2_d", "targetname");
	surv_spawners[4] = GetEnt("survivor_rescue_2_e", "targetname");
	
	for(i = 0; i<surv_spawners.size; i++)
	{
		level.survivors_group_2[i] = surv_spawners[i] StalingradSpawn();
		level.survivors_group_2[i] thread survivor_init(level.plane_a, "_group_1", 0);
		//level.survivors_group_1[i] thread magic_bullet_shield();
		surv_spawners[i] Delete();
	}
}

rescue_scene_init_3()
{
	surv_spawners = [];
	surv_spawners = GetEntArray("survivor_rescue_3", "targetname");
	
	level.survivors_group_3 = [];
	
	for(i = 0; i<surv_spawners.size; i++)
	{
		level.survivors_group_3[i] = surv_spawners[i] StalingradSpawn();
		
		/*
		if(IsDefined(surv_spawners[i].target))
		{
			level.survivors_group_3[i].target = surv_spawners[i].target;
		}
		
		target_ent = GetEnt(level.survivors_group_3[i].target, "targetname");
		*/
		
		//level.survivors_group_3[i] thread survivor_init(level.plane_a, "_group_3", i, target_ent.origin);
		level.survivors_group_3[i] thread survivor_init(level.plane_a, "_group_3", i);
		level.survivors_group_3[i] thread magic_bullet_shield();
		surv_spawners[i] Delete();
	}
}

#using_animtree ("generic_human");

shark_init()
{
	//-- i'm a shark, figure out what to do with me
	self.shark = Spawn("script_model", self.origin + (0,0,200) );
	self.shark SetModel("greatwhite_shark2");
	//self.shark.origin = self.origin + (0,0,500);
	
	self.shark LinkTo(	self, "tag_origin", (0,0, 500), (0,0,0) );
	//self.shark LinkTo(	self, "tag_origin", (0,0,0), (0,0,0) );
	
	
	self.shark UseAnimTree(#animtree);
	self.shark.animname = "shark";
	//self.shark thread anim_loop_solo( self.shark, "idle", "tag_origin", "shark_swim_loop");
}

survivor_init_ambient()
{
	//-- Setup
	self.animname = "survivor";
	rand = RandomInt(level.scr_anim["survivor"]["swim_far"].size);
	self.run_noncombatanim = level.scr_anim["survivor"]["swim_far"][rand];	
	
	self thread maps\pby_fly_fx::swim_splash_right();
	self thread maps\pby_fly_fx::swim_splash_left();
	
	//-- Make him tread water
	self thread survivor_wave();
}

survivor_sounds()
{
	self PlayLoopSound("pby_swim_loop");
	
	self thread survivor_sounds_hangon();
	self thread survivor_sounds_death();
}

survivor_sounds_hangon()
{
	self endon("death");
	self waittill("ready_to_be_saved");
	
	self StopLoopSound();
	wait(0.05);
	self PlayLoopSound("pby_float_loop");
	
	self waittill("being saved");
	self StopLoopSound();
}

survivor_sounds_death()
{
	self endon("being saved");
	self waittill("death");
	self StopLoopSound();
}

//sets the survivor up to go to his goal saving position
survivor_init(plane, group, id, alternate_goal_pos, needs_to_run)
{
	self endon("death");
	
	self thread survivor_burst();
	self thread survivor_sounds();
	
	//-- assign the guy his side
	self.plane = plane;
	self.side = self.script_noteworthy;
	self.animname = "survivor";
	self.idle = level.scr_anim["survivor"]["float_0"];
	//self.disableArrivals = true;
	//self.disableexits = true;
	
	self thread maps\pby_fly_fx::swim_splash_right();
	self thread maps\pby_fly_fx::swim_splash_left();
	
	if(IsDefined(needs_to_run))
	{
		self thread survivor_run_swim();
	}
	else
	{
		rand = RandomInt(level.scr_anim["survivor"]["swim_far"].size);
		self.run_noncombatanim = level.scr_anim["survivor"]["swim_far"][rand];	
	}
		
	//setup the treading activity
	self.activity = "treading";
	self thread survivor_wave();
	self thread survivor_shout();
		
	self notify("inited");
	self waittill("swimming_notify");
	
	//kill the floating animation
	self StopAnimScripted();
	
	//-- send the guy to his new goal position, then raise the "i need to be saved signal", the make the player save them.
	self.goalradius = 24;
	goal_pos = (0,0,0);
	
	if(IsDefined(alternate_goal_pos))
	{
		self.goal_pos = alternate_goal_pos;
		self SetGoalPos(alternate_goal_pos);
	}
	else
	{
		//self survivor_update_pos();
		self thread survivor_update_pos();
		self thread survivor_watch_for_goal();
	}
		
	self endon("goal");
		
	if(!IsDefined(alternate_goal_pos))
	{
		while(Distance2d(goal_pos, self.origin) > 32)
		{
			wait(1);
		}
		
		rand = RandomInt(level.scr_anim["survivor"]["swim_med"].size);
		self.run_noncombatanim = level.scr_anim["survivor"]["swim_med"][rand];
	}
	
}

survivor_burst()
{
	self waittill("death");
	position = self GetTagOrigin("tag_eye");
	PlayFX( level._effect["drone_burst_water"], position);
	
	//PlayFXOnTag( level._effect["drone_burst"], self, "tag_eye");
}

survivor_shout()
{
	self endon("death");
	self endon("being saved");
	self endon("got tired");
	
	self thread survivor_dialogue_inside();
	
	random_wait = 0;
	
	redshirt_yell = [];
	redshirt_yell[0] = "PBY1_IGD_110A_USR1";
	redshirt_yell[1] = "PBY1_IGD_111A_USR2";
	redshirt_yell[2] = "PBY1_IGD_112A_USR3";
	redshirt_yell[3] = "PBY1_IGD_570A_USR3";
	redshirt_yell[4] = "PBY1_IGD_571A_USR1";
	redshirt_yell[5] = "PBY1_IGD_572A_USR2";
	redshirt_yell[6] = "PBY1_IGD_582A_USR3";
		
	hanging_yell = [];
	hanging_yell[0] = "PBY1_IGD_113A_USR1";
	hanging_yell[1] = "PBY1_IGD_114A_USR1";
	hanging_yell[2] = "PBY1_IGD_115A_USR1";
	hanging_yell[2] = "PBY1_IGD_577A_USR1";
	hanging_yell[2] = "PBY1_IGD_580A_USR1";
	hanging_yell[2] = "PBY1_IGD_581A_USR3";
	
	while(1)
	{
		while(!IsDefined(self.switch_screams))
		{
			random_wait = RandomInt(redshirt_yell.size);
			self play_survivor_yell(redshirt_yell[random_wait]);
			random_wait = RandomFloatRange(2,3);		
			wait(random_wait);
		}
		
		while(1)
		{
			random_wait = RandomInt(hanging_yell.size);
			self play_survivor_yell(hanging_yell[random_wait]);
			random_wait = RandomFloatRange(2,3);		
			wait(random_wait);
		}
	}
}

survivor_dialogue_inside()
{
		self endon("death");
		self endon("got tired");
		
		self waittill("being saved");
		
		made_it_inside = [];
		made_it_inside[0] = "PBY1_IGD_573A_USR3";
		made_it_inside[0] = "PBY1_IGD_574A_USR1";
		made_it_inside[0] = "PBY1_IGD_575A_USR2";
		made_it_inside[0] = "PBY1_IGD_576A_USR3";
		made_it_inside[0] = "PBY1_IGD_578A_USR2";
		
		random_wait = RandomInt(made_it_inside.size);
		self play_survivor_yell(made_it_inside[random_wait], 0);
}

survivor_update_pos()
{
	self.activity = "swimming";
	self endon("goal");
	self endon("death");
	
	while(1)
	{
		if(self.side == "left")
		{
			self.goal_pos = getstartOrigin( self.plane GetTagOrigin("tag_blister_left_rescue"), self.plane GetTagAngles("tag_blister_left_rescue"), level.scr_anim["survivor"]["rescue_in_left"] );
			self.goal_pos = (self.goal_pos[0], self.goal_pos[1], 0);
		}
		else
		{
			self.goal_pos = getstartOrigin( self.plane GetTagOrigin("tag_blister_right_rescue"), self.plane GetTagAngles("tag_blister_right_rescue"), level.scr_anim["survivor"]["rescue_in_right"] );
			self.goal_pos = (self.goal_pos[0], self.goal_pos[1], 0);
		}
		
		/*
		if( findpath(self.origin, self.goal_pos))
		{
			iprintln("I found a swim path");
		}
		else
		{
			iprintln("I did NOT find a swim path");
		}
		*/
		
		self.goalradius = 32;
		self SetGoalPos(self.goal_pos);
		
		wait(1.0);
	}
}

survivor_watch_for_goal()
{
	self endon("death");
	self waittill("goal");
	
	
	while(flag("rescue_ready")) //-- someone is already getting rescued, so wait!
	{
		random_int = RandomIntRange(0,3);
		random_cycles = RandomIntRange(3, 5);
		for(i = 0; i < random_cycles  && flag("rescue_ready"); i++)
		{
			self anim_single_solo(self, "float_" + random_int);
		}
		
		//-- keep trying to go to a holding position
		if(self.side == "left")
		{
			self.goal_pos = getstartOrigin( self.plane GetTagOrigin("tag_blister_left_rescue"), self.plane GetTagAngles("tag_blister_left_rescue"), level.scr_anim["survivor"]["rescue_in_left"] );
		
		}
		else
		{
			self.goal_pos = getstartOrigin( self.plane GetTagOrigin("tag_blister_right_rescue"), self.plane GetTagAngles("tag_blister_right_rescue"), level.scr_anim["survivor"]["rescue_in_right"] );
		}
		
		self.goalradius = 24;
		self SetGoalPos(self.goal_pos);
		
		self waittill("goal");
	}
	
	flag_set( "rescue_ready" );
	self thread survivor_hang_on();
	
	turret_rescue_hud_elem();
}

survivor_hang_on()
{
	self endon("being saved");
	self endon("got tired");
	
	self.in_anim = "";
	self.loop_anim = "";
	self.over_anim = "";
	self.fall_anim = "";
	self.rescue_tag = "";
	
	if(self.side == "left")
	{
		self.in_anim = "rescue_in_left";
		self.loop_anim = "rescue_loop_left";
		self.over_anim = "rescue_over_left";
		self.fall_anim = "rescue_fall_left";	
		self.rescue_tag = "tag_blister_left_rescue";
	}
	else
	{
		self.in_anim = "rescue_in_right";
		self.loop_anim = "rescue_loop_right";
		self.over_anim = "rescue_over_right";
		self.fall_anim = "rescue_fall_right";
		self.rescue_tag = "tag_blister_right_rescue";
	}	
	
	self.switch_screams = true;
	
	self StopAnimScripted();
	self LinkTo(self.plane, self.rescue_tag);
	self.plane anim_single_solo(self, self.in_anim, self.rescue_tag);
		
	self thread survivor_fall_timer(10);
	self.hanging_on = true;
	level notify("swim_goal_reached");
	self notify("ready_to_be_saved");
	
	while(self.hanging_on)
	{
		self.plane anim_single_solo(self, self.loop_anim, self.rescue_tag);
	}
	
	//-- play either the get_in or the fall
	if(IsDefined(self.i_got_tired))
	{
		//-- play the fall animation and count this guy as dead
		// right now survivor_fall_timer is taking care of the fall
	}
}

event4_cleanup_swimmers( _guy_array, _waittill)
{
	level waittill(_waittill);
	
	for( i = 0; i < _guy_array.size; i++)
	{
		if(IsDefined(_guy_array[i]))
		{
			_guy_array[i] DoDamage(_guy_array[i].health + 1000, _guy_array[i].origin);
		}
	}
	
}

survivor_fall_timer(fall_time)
{
	self endon("being saved"); //- the rescue signal
	
	wait(fall_time);
	self notify("got tired");
	level notify("survivor_fell");
	
	flag_clear( "rescue_ready" );
	flag_clear("saver_ready");
	
	//-- now we make him sink or something
	self Unlink();
	self.plane anim_single_solo(self, self.fall_anim, self.rescue_tag);
	
	self DoDamage(self.health + 1000, self.origin);
	
	wait(1);
	
	level.plane_a notify("spotlight_off");
}

survivor_run_swim()
{
	while(self.origin[2] > 0)
	{
		wait(0.05);
	}
	
	rand = RandomInt(level.scr_anim["survivor"]["swim_far"].size);
	self.run_noncombatanim = level.scr_anim["survivor"]["swim_far"][rand];	
}

//-- play the treading water/waving animation on the survivors when they aren't swimming or at the boat
survivor_wave()
{
	//TODO: Look into this being played as an actual animloop, instead of as a looping anim_single_solo
	self endon("being saved");
	self endon("stop treading");
	
	//self anim_single_solo(self, "enter_pby");
	//anim_loop( guy, anime, tag, ender, node, tag_entity )
	//self anim_loop_solo( self, "float", undefined, "end_floating");
	
	if(!IsDefined(self.activity))
	{
		self.activity = "treading";
	}
	
	while(self.activity == "treading")
	{
		rand = RandomInt(8);
		
		if(rand < 4)
		{
			self anim_single_solo(self, "float_" + rand);
		}
		else
		{
			rand = rand - 4;
			self anim_single_solo(self, "wave_" + rand);
		}
	}
	
	//self notify("end_floating");
}

pby_out_of_ammo()
{
	self waittill("out_of_ammo");
	flag_set("pby_out_of_ammo");
}

#using_animtree ("vehicles");

event6()
{
	level waittill("pby_player_take_off");
		
	flag_set("the level is done");
	
	maps\_debug::set_event_printname("Event 5 - Getaway", false);
	level.plane_a ResumeSpeed(1000);
	
	//TUEY: Gavin--do you want to move this?
	level.plane_a playsound("take_off");
	
	thread event6_dialog();
	
	//-- swap out the other 3 fletchers
	thread event6_fletcher_swap();
	thread event6_escorting_corsairs();
	
	//level.plane_a thread pby_out_of_ammo();
	//level notify("sun_rise");
	//level notify("stop lightning");
	//level thread event6_seat_control();
	//level thread event6_ptboat_control();
	
	//-- START CALLING IN ZEROES
	//level.plane_a waittill("start_getaway_zeros");
	level.plane_a notify("pby_takeoff");
	level.plane_a notify( "noteworthy", "pby_takeoff" );
	level thread event6_pontoons_up();
		
	//level.plane_a waittill("reached_end_node");
	//nextmission();
	
	//thread event6_spawn_getaway_zeros_0(); //-- first group of zeros
	//thread event6_spawn_getaway_zeros_1(); //-- second group of zeros
	//thread event6_spawn_getaway_zeros_2(); //-- third group of zeros
	//thread event6_spawn_getaway_zeros_3(); //-- fourth group of zeros
	//thread event6_spawn_getaway_zeros_3point5();
	//thread event6_spawn_getaway_zeros_4();
	
	//level.plane_a waittill("reached_end_node");
	level waittill("finish the mission");
	//level.player play_sitdown_animation();
	//wait(2);
	wait(5);
	nextmission();
}

event6_pontoons_up()
{
	//level.plane_a waittill("spawn_corsair_escort");
	level waittill("finish the mission");
	
	wait(3);
	level.plane_a SetFlaggedAnimKnobAllRestart( "pby_pontoon_up", %v_pby_pontoon_up, %pby_pontoons, 1, 0.1, 1);
	animation_time = getAnimLength( %v_pby_pontoon_up );
	wait(animation_time);	
	level.plane_a thread pby_veh_idle( "fly_up", 0, true );
}

event6_escorting_corsairs()
{
	level.plane_a waittill("spawn_corsair_escort");
	
	corsair_paths = GetVehicleNodeArray( "corsair_escort", "targetname" );
	
	corsairs = [];
	for(i = 0; i < corsair_paths.size; i++)
	{
		corsair[i] = spawn_and_path_a_corsair( corsair_paths[i] );
	}
}

event6_dialog()
{
	
	flag_set("disable_random_dialogue");
	
	play_sound_over_radio( level.scr_sound["corsair"]["vpb_54_havok_26_coming_in_on_your_9"] );	
	wait(0.1);
	play_sound_over_radio( level.scr_sound["corsair"]["well_take_it_from_here"] );
	wait(0.1);
	play_sound_over_radio( level.scr_sound["corsair"]["get_yourselves_back_to_base"] );
	
	wait(1);
	
	anim_single_solo( level.plane_a.pilot, "booth_landry_prep_for_takeoff" );
	wait(0.1);
	anim_single_solo( level.plane_a.pilot, "booth_laughlin_patch_us_up_as_best" );
	wait(0.1);
	//anim_single_solo( level.plane_a.pilot, "booth_locke_sit_tight_and_keepem_peeled" );
	//wait(0.3);
	
	//anim_single_solo( level.plane_a.pilot, "booth_good_work_locke_landry_how" );
	//anim_single_solo( level.plane_a.radioop, "landry_hulls_intact" );
	anim_single_solo( level.plane_a.pilot, "booth_okay_taking_her_up" );
	wait(0.1);
	anim_single_solo( level.plane_a.pilot, "booth_how_did_we_do" );
	
	wait(0.2);
	
	if( level.survivor_save_count == 6 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_bunks_are_full" );	
	}
	else if( level.survivor_save_count == 5 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_pulled_five" );	
	}
	else if( level.survivor_save_count == 4 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_got_four" );	
	}
	else if( level.survivor_save_count == 3 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_only_got_three" );	
	}
	else if( level.survivor_save_count == 2 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_just_got_two" );	
	}
	else if( level.survivor_save_count == 1 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_only_got_one" );	
	}
	else if( level.survivor_save_count == 0 )
	{
		anim_single_solo( level.plane_a.radioop, "landry_we_struck_out" );	
	}
	
	//anim_single_solo( level.plane_a.pilot, "booth_landry_secure_the_wounded" );
	
	wait(2);
	anim_single_solo( level.plane_a.pilot, "booth_comin_around" );
	
	wait(1);
	
	//wait(3);
	play_sound_over_radio("PBY1_IGD_316B_LAUG");
	
	level notify("finish the mission");
	
	
	//wait(3);
	//nextmission();
	
	/*
	level.plane_a waittill("start_getaway_zeros");
	
	anim_single_solo( level.plane_a.pilot, "booth_oh_no_no_landry" );
	anim_single_solo( level.plane_a.pilot, "booth_its_the_enemy" );
	//-- BOOTH: TRY AND OPEN US UP A PATH!!!!!!
	anim_single_solo( level.plane_a.radioop, "landry_theres_too_many_of_them");
	anim_single_solo( level.plane_a.radioop, "landry_were_almost_out_of_ammo");
	//anim_single_solo( level.plane_a.pilot, "booth_lets_hope_they" );
	//anim_single_solo( level.plane_a.pilot, "booth_evasive_maneuvers" );
	
	
	if(true)
	{
		return;
	}
	
	level.plane_a waittill("switch_to_left");
	
	anim_single_solo( level.plane_a.pilot, "booth_locke_get_on_the_50" );
	
	flag_clear("disable_random_dialogue");
	
	
	level.plane_a waittill("spawn_last_zeros");
	
	flag_set("disable_random_dialogue"); //-- doesn't ever re-enable
	
	anim_single_solo( level.plane_a.radioop, "landry_theres_too_many_of_them");
	anim_single_solo( level.plane_a.radioop, "landry_were_almost_out_of_ammo");
	wait(0.15);
	anim_single_solo( level.plane_a.radioop, "landry_were_sitting_ducks");
	wait(0.25);
	
	anim_single_solo( level.plane_a.pilot, "booth_shit" );
	wait(0.15);
	anim_single_solo( level.plane_a.pilot, "booth_smoke_them_if_you" );
	wait(0.5);
	
	*/
	
	//play_sound_over_radio( level.scr_sound["corsair"]["vpb_54_havok_26_coming_in_on_your_9"] );
	
	//-- needs to wait until the corsair escort arrives
}

event6_fletcher_swap()
{
	//-- there are 3 that need to be swapped
	for(i = 0; i < 3; i++)
	{
		swap_model_for_fletcher( "fly_away_fletcher_" + i );
	}
}

event6_ptboat_control()
{
	ptboats = [];
	ptboat_paths = [];
	ptboat_paths = GetVehicleNodeArray("ev6_pt_boats", "targetname");
	
	level.plane_a waittill("spawn_ev6_ptboats");
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		ptboats[i] = spawn_and_path_a_ptboat(ptboat_paths[i], true, undefined, true);
		ptboats[i] StartPath();
		ptboats[i].notify_level = true;
	}
}

/*
event6_spawn_getaway_zeros_0()
{
	level.plane_a waittill("cloud_spawn");
	plane = undefined;
	plane_paths = [];
	
	plane_paths[0] = GetVehicleNode("getaway_zero_0", "targetname");
	plane_paths[1] = GetVehicleNode("getaway_zero_1", "targetname");
	plane_paths[2] = GetVehicleNode("getaway_zero_2", "targetname");
	
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(1);
	}
}
*/

event6_spawn_getaway_zeros_1()
{
	level.plane_a waittill("spawn_left1_zero");
	plane = undefined;
	plane_path = [];
	
	plane_path[0] = GetVehicleNode("ev6_left1_zero1", "targetname");
	
	plane = thread spawn_and_path_a_zero( plane_path[0], true, true );
	
	/*
	level.plane_a waittill("cloud_spawn_2");
	plane = undefined;
	plane_paths = [];
	
	plane_paths[0] = GetVehicleNode("getaway_zero_3", "targetname");
	plane_paths[1] = GetVehicleNode("getaway_zero_4", "targetname");
	plane_paths[2] = GetVehicleNode("getaway_zero_5", "targetname");
	
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(1);
	}
	*/
}

event6_spawn_getaway_zeros_2()
{
	level.plane_a waittill("spawn_right1_zero");
	plane = undefined;
	plane_paths = [];
	
	plane_paths[0] = GetVehicleNode("ev6_right1_zero1", "targetname");
	plane_paths[1] = GetVehicleNode("ev6_right1_zero2", "targetname");
	plane_paths[2] = GetVehicleNode("ev6_right1_zero3", "targetname");
	//plane_paths[2] = GetVehicleNode("getaway_zero_8", "targetname");
	
	plane = [];
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(1);
	}
	
	level.plane_a waittill("spawn_right1_zerob");
	plane = [];
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("ev6_right1_zero4", "targetname");
	plane_paths[1] = GetVehicleNode("ev6_right1_zero5", "targetname");
	plane_paths[2] = GetVehicleNode("ev6_right1_zero6", "targetname");
	
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(0.05);
	}
}


event6_spawn_getaway_zeros_3()
{
	level.plane_a waittill("spawn_left2_zero");
	plane = undefined;
	plane_paths = [];
	
	plane_paths[0] = GetVehicleNode("ev6_left2_zero1", "targetname");
	plane_paths[1] = GetVehicleNode("ev6_left2_zero2", "targetname");
	plane_paths[2] = GetVehicleNode("ev6_left2_zero3", "targetname");
	//plane_paths[2] = GetVehicleNode("getaway_zero_8", "targetname");
	
	plane = [];
	for(i = 0; i < plane_paths.size; i++)
	{		
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(0.1);
	}
}

event6_spawn_getaway_zeros_3point5()
{
	level waittill("spawn_ev6_fly_under");
	
	plane = undefined;
	plane_paths = [];

	plane_paths[0] = GetVehicleNode("ev6_right2_zero4", "targetname");
	plane_paths[1] = GetVehicleNode("ev6_right2_zero5", "targetname");
	plane_paths[2] = GetVehicleNode("ev6_right2_zero6", "targetname");
	
	plane_paths[3] = GetVehicleNode("ev6_right2_zero1", "targetname");
	plane_paths[4] = GetVehicleNode("ev6_right2_zero2", "targetname");
	plane_paths[5] = GetVehicleNode("ev6_right2_zero3", "targetname");
	
	plane_paths[6] = GetVehicleNode("ev6_right2_zero7", "targetname");
	plane_paths[7] = GetVehicleNode("ev6_right2_zero8", "targetname");
	
	plane_paths[8] = GetVehicleNode("ev6_right2_zero9", "targetname");
	plane_paths[9] = GetVehicleNode("ev6_right2_zero10", "targetname");
	
	plane = [];
	for( i = 0; i < 3; i++)
	{
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(0.05);
	}
	
	level.plane_a waittill("spawn_last_zeros");
	
	for( i = 3; i < plane_paths.size; i++)
	{
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(0.05);
	}
	
	/*
	wait(2);
	
	for( i = 6; i < plane_paths.size; i++)
	{
		plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true);
		wait(0.05);
	}
	*/
	
}


event6_spawn_getaway_zeros_4()
{
	level.plane_a waittill("spawn_last_zeros");
	plane = undefined;
	plane_paths = [];
	
	for(i=0; i < 12; i++)
	{
		plane_paths[i] = GetVehicleNode("ev6_final_zero" + i, "targetname");	
	}
		
	plane = [];
	for(i = 0; i < plane_paths.size; i++)
	{		
		if(i == 4 || i == 9 || i == 11 )
		{
			plane[i] = thread spawn_and_path_a_zero( plane_paths[i], undefined, true, "shot_down_by_corsair");
			plane[i] SetCanDamage(false);
		}
		else
		{
			plane[i] = thread spawn_and_path_a_zero( plane_paths[i], true, true );
			plane[i] SetCanDamage(false);
		}
	}
	
	wait(4);
	
	//-- corsairs that blow up the zeros
	plane_paths = [];
	plane_paths = GetVehicleNodeArray( "ev6_final_corsair", "targetname");
	corsair = [];
	for( i=0; i < plane_paths.size; i++)
	{
		corsair[i] = spawn_and_path_a_corsair( plane_paths[i] );
	}
	
	wait(18);
	
	level notify("finish the mission");
	
}
	
event6_seat_control()
{
	level.plane_a waittill("switch_to_left");
	level.player scripted_turret_switch("pby_leftgun", true);
	
	level.plane_a waittill("switch_to_right");
	level.player scripted_turret_switch("pby_rightgun", true);
	
	level.plane_a waittill("switch_to_left");
	level.player scripted_turret_switch("pby_leftgun", true);
	
	level.plane_a waittill("switch_to_right");
	level notify("spawn_ev6_fly_under");
	level.player scripted_turret_switch("pby_rightgun", true);
}


//-- Player on the plane functions --------------------------------------------------------------------------------

//-- Inits all the values for each player plane
player_pby_init(plane_name, crew_id)
{
	plane = GetEnt(plane_name, "targetname");
	plane.plane_name = plane_name;	
	plane.crew_id = crew_id;
		
	plane.front = "empty";
	plane.left = "empty";
	plane.right = "empty";
	plane.back = "empty";
	
	plane.bunks = [];
	plane.bunks[0]["status"] = "empty";
	plane.bunks[1]["status"] = "empty";
	plane.bunks[2]["status"] = "empty";
	plane.bunks[3]["status"] = "empty";
	
	plane.bunks[0]["tag"] = "tag_bunk_left_bottom";
	plane.bunks[1]["tag"] = "tag_bunk_left_top";
	plane.bunks[2]["tag"] = "tag_bunk_right_bottom";
	plane.bunks[3]["tag"] = "tag_bunk_right_top";
	
	plane pby_crew_init(plane_name);
	
	if(plane_name == "player_plane_a")
	{
		plane thread pby_crew_idles();
	}
	plane thread pby_prop_fx();
	
	//plane waittill("props_spawned");
		
	return(plane); 
}

//-- plays the prop fx on the propellers
pby_prop_fx()
{
	self.props_running = true;
	self thread pby_spin_prop();
	
	/*
	pby_ok_to_spawn();
	self.left_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_still"], "prop_left_jnt");
	pby_ok_to_spawn();
	self.right_prop = self maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_still"], "prop_right_jnt");
	
	self notify("props_spawned");
	
	self.props_running = true;
	
	while(1)
	{
				self thread pby_spin_prop();
				
				while(self.props_running)
				{
					wait(0.1);
				}
				
				self.left_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_stop"], "prop_left_jnt");
				self.right_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_stop"], "prop_right_jnt");
				
				wait(8.0);
				
				self.left_prop Delete();
				self.right_prop Delete();
				
				wait(0.05);
				
				self.left_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_still"], "prop_left_jnt");
				self.right_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_still"], "prop_right_jnt");
				
				while(!self.props_running)
				{
					wait(0.1);
				}
				
				self.left_prop Delete();
				self.right_prop Delete();
				
				wait(0.05);
				
				self.left_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["prop_start"], "prop_left_jnt");
				self.right_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["prop_start"], "prop_right_jnt");
				
				wait(8.0);
	}
	*/
}

pby_spin_prop()
{
	self endon( "death" );
	//self.left_prop Delete();
	//self.right_prop Delete();
		
	while(self.props_running)
	{
		PlayFXOnTag(level._effect["prop_full"], self, "prop_left_jnt");
		PlayFXOnTag(level._effect["prop_full"], self, "prop_right_jnt");
	
		//self.left_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_full"], "prop_left_jnt");
		//self.right_prop = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["prop_full"], "prop_right_jnt");
				
		wait(0.1);
	}
}

corsair_spin_prop()
{
	self endon("hide_prop");
	self endon("death");
	
	while(1)
	{
		PlayFXOnTag(level._effect["corsair_prop_full"], self, "tag_prop");
				
		wait(0.1);
	}
	
}

zero_spin_prop()
{
	self endon("hide_prop");
	self endon("death");
	
	while(1)
	{
		PlayFXOnTag(level._effect["zero_prop_full"], self, "tag_prop_fx");
				
		wait(0.1);
	}
}

//-- Sets up the crew for the plane
pby_crew_init(plane_name)
{
	//-- Pilot
	if(plane_name == "player_plane_a")
	{
		pby_ok_to_spawn("ai");
		pilot_spawner = GetEnt(self.plane_name + "_pilot", "targetname");
		self.pilot = pilot_spawner StalingradSpawn();
		//self.pilot LinkTo(self, "tag_pilot", (0,0,0), (0,0,0));
		self.pilot.animname = "pilot";
		self.pilot thread magic_bullet_shield();
		self.pilot animscripts\shared::placeWeaponOn(self.pilot.weapon, "none");	// take the prisoner's weapon
		self.pilot.drawoncompass = 0;
		self.pilot.name = undefined;
		pilot_spawner Delete();
		
		//-- Co-Pilot
		pby_ok_to_spawn("ai");
		copilot_spawner = GetEnt(self.plane_name + "_copilot", "targetname");
		self.copilot = copilot_spawner StalingradSpawn();
		//self.copilot LinkTo(self, "tag_copilot", (0,0,0), (0,0,0));
		self.copilot.animname = "copilot";
		self.copilot thread magic_bullet_shield();
		self.copilot animscripts\shared::placeWeaponOn(self.copilot.weapon, "none");	// take the prisoner's weapon
		self.copilot.drawoncompass = 0;
		self.copilot.name = undefined;
		copilot_spawner Delete();
	
		
		//-- Radio Operator
		pby_ok_to_spawn("ai");
		radioop_spawner = GetEnt(self.plane_name + "_radioop", "targetname");
		self.radioop = radioop_spawner StalingradSpawn();
		//self.radioop LinkTo(self, "tag_radioop", (0,0,0), (0,0,0));
		self.radioop.animname = "radio_op";
		self.radioop thread magic_bullet_shield();
		self.radioop animscripts\shared::placeWeaponOn(self.radioop.weapon, "none");	// take the prisoner's weapon
		self.radioop.drawoncompass = 0;
		self.radioop.name = undefined;
		radioop_spawner Delete();
	}

	if(plane_name == "player_plane_a")
	{
		//-- Engineer (aka the gunner)
		engineer_spawner = GetEnt(self.plane_name + "_engineer", "targetname");
		self.engineer = engineer_spawner StalingradSpawn();
		self.engineer LinkTo(self, "tag_engineer", (0,0,0), (0,0,0));
		self.engineer.animname = "engineer";
		self.engineer thread magic_bullet_shield();
		self.engineer animscripts\shared::placeWeaponOn(self.engineer.weapon, "none");	// take the prisoner's weapon
		self.engineer.drawoncompass = 0;
		self.engineer.name = undefined;
		engineer_spawner Delete();
	}
}

pby_crew_idles()
{
	//TODO: HOOK THIS UP FOR THE 2ND CREW
		
	self thread anim_loop_solo(self.pilot, "my_idle", "tag_engineer", "stop_pilot_idling");
	self.pilot LinkTo(self, "tag_engineer");
	
	self thread anim_loop_solo(self.copilot, "my_idle", "tag_engineer", "stop_copilot_idling");
	self.copilot LinkTo(self, "tag_engineer");
	
	self thread anim_loop_solo(self.radioop, "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	self.radioop LinkTo(self, "tag_engineer");
	self.radioop.status = "idle_at_rad";
	
	//self thread anim_loop_solo(self.engineer, "intro_vig_loop", "tag_engineer", "stop_engineer_idling");
	//self.engineer LinkTo(self, "tag_engineer");
	//self.engineer.status = "normal_idle";
}

//-- fires off when the weapon is changed
turret_switch_watch()
{
	level endon("no_manual_switch");
	
	for(;;)
	{
		self waittill("weapon_change_on_turret", weapon_name);
		//self waittill("weapon_change");
		self switch_turret(weapon_name);		
	}
}

//-- Moves the player around the plane based on the selected seat.
switch_turret(weapon_name)
{
	self notify("switching_turret");	
	
	//-- hack possibly
	level notify("survivor_fell");
	
	if(IsDefined(self.seat_locked))
	{
		if(self.seat_locked)
		{
			return false; //-- Players seat is locked and he can't switch 
		}
	}
	
	//plane = "undefined";
	//plane = pick_proper_plane(self);
	//plane = get_pby_by_player(self);
	plane = level.plane_a;
			
	self.wanted_seat = weapon_name;
	self.in_transition = true;
	
	//-- reset pitch down
	self setclientdvar("player_view_pitch_down", level.default_pitch_down);	
	
	if(self.wanted_seat == "pby_frontgun")
	{
		if(plane.front == "empty")
		{
			plane.front = "has_player";
			
			self play_transition_to_front(plane);
			plane usevehicle(self, 1);
		}
	}
	else if(self.wanted_seat == "pby_leftgun")
	{
		if(plane.left == "empty")
		{
			plane.left = "has_player";
			
			self play_transition_to_left(plane);
			plane usevehicle(self, 2);
		}
	}
	else if(self.wanted_seat == "pby_rightgun")
	{
		if(plane.right == "empty")
		{
			plane.right = "has_player";
			
			self play_transition_to_right(plane);
			plane usevehicle(self, 3);
		}
	}
	else if(self.wanted_seat == "pby_backgun")
	{
		if(plane.back == "empty")
		{
			plane.back = "has_player";
			
			self play_transition_to_rear(plane);
			plane usevehicle(self, 4);
			self setclientdvar("player_view_pitch_down", level.ventral_turret_pitch);	
		}
	}
	else //The wanted seat was not available
	{
		self.in_transition = false;
		return false; //non successful seat found
	}
		
	switch(self.current_seat)
	{
		case "pby_frontgun":
			plane.front = "empty";
		break;
	
		case "pby_leftgun":
			plane.left = "empty";
		break;
	
		case "pby_rightgun":
			plane.right = "empty";
		break;
	
		case "pby_backgun":
			plane.back = "empty";
		break;
	
		default:
		break;
	}
		
	self.current_seat = self.wanted_seat;
	self.wanted_seat = -1;
	
	self notify("done_switching_turrets");
	self.in_transition = false;
	return true; //successful seat switch
}

play_transition_to_rear(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
			if(IsDefined(self.open_hatch))
			{
					self play_transition_animation(plane, "open_hatch", "rear");
					self.open_hatch = undefined;
			}
			else
			{
					self play_transition_animation(plane, "pby_front_to_rear", "rear");
			}
		break;
		
		case "pby_leftgun":
			self play_transition_animation(plane, "pby_left_to_rear", "rear");
		break;
		
		case "pby_rightgun":
		if(IsDefined(self.open_hatch))
		{
				self play_transition_animation(plane, "open_hatch", "rear");
				self.open_hatch = undefined;
		}
		else
		{
				self play_transition_animation(plane, "pby_right_to_rear", "rear");
		}
		break;
		
		default:
		break;
	}
}


play_transition_to_front(plane)
{
	switch(self.current_seat)
	{
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_front", "front");
		break;
		
		case "pby_leftgun":
		{
			if(IsDefined(self.pacing_moment))
			{
				//anim_time = getanimlength(level.scr_anim["player_hands"]["close_hatch"] );
				//iprintlnbold( anim_time );
				self play_transition_animation(plane, "close_hatch", "front");
				self.pacing_moment = undefined;
			}
			else
			{
				self play_transition_animation(plane, "pby_left_to_front", "front");
			}
		}
		break;
		
		case "pby_rightgun":
		
			if(IsDefined(self.flak_moment))
			{
				self play_transition_animation(plane, "pby_right_to_flak", "front");
				self.flak_moment = undefined;
			}
			else
			{
				self play_transition_animation(plane, "pby_right_to_front", "front");
			}
		break;
		
		default:
		break;
	}
}


play_transition_to_right(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
		{
			if(IsDefined(self.intro))
			{
				self play_transition_animation(plane, "intro_move", "right");
				self.intro = undefined;
			}
			else
			{
				self play_transition_animation(plane, "pby_front_to_right", "right");
			}
		}
		break;
		
		case "pby_leftgun":
			self play_transition_animation(plane, "pby_left_to_right", "right");
		break;
		
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_right", "right");
		break;
		
		default:
		break;
	}
}

play_transition_to_left(plane)
{
	switch(self.current_seat)
	{
		case "pby_frontgun":
			self play_transition_animation(plane, "pby_front_to_left", "left");
		break;
		
		case "pby_backgun":
			self play_transition_animation(plane, "pby_rear_to_left");
		break;
		
		case "pby_rightgun":
		
			if(IsDefined(self.pistol_event))
			{
				self play_transition_animation(plane, "pby_right_to_left_pistol");
			}
			else
			{
				self play_transition_animation(plane, "pby_right_to_left");
			}
		break;
		
		default:
		break;
	}
}


play_transition_animation(plane, anim_str, direction)
{
	//-- Take the player off of the plane
	if(IsDefined(self.fell) || IsDefined(self.intro))
	{
		//--nothing
	}
	else
	{
		plane UseBy(self);
	}
	
	if(IsDefined(self.open_hatch))
	{
		level.plane_a thread pby_veh_idle("fly", 0.05, "up");
	}
	
	if(IsDefined(self.pacing_moment))
	{
		level.plane_a thread pby_veh_idle("fly_up_open", 0.05, "up", "open");
	}
	
	//-- plays the animation	
	//startorg = getstartOrigin( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
	//startang = getstartAngles( plane.origin, plane.angles, level.scr_anim[ "player_hands" ][ anim_str ] );
	startorg = getstartOrigin( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ anim_str ] );
	startang = getstartAngles( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ anim_str ] );
	
	player_hands = spawn_anim_model( "player_hands" );
	player_hands.plane = plane;
	player_hands.direction = direction;
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	//player_hands LinkTo(plane);
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	//org = GetEnt("ref_ground_org", "targetname");
	
	//org = Spawn("script_origin", startorg);
	//org.angles = startang;
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;


	//self playerSetGroundReferenceEnt(org);
	//org RotateTo((plane.angles[0] + 180, 0, plane.angles[2]), 0.05, 0, 0);
	//org LinkTo(plane);
	
	//TODO: I think this is a hack and it seems like PlayerLinkTo isn't actually really linking the player and it's not clamping the angles.
	//self PlayerLinkTo(player_hands, "tag_player", 1.0, 30, 30, 10, 10);
	//self PlayerLinkToDelta(player_hands, "tag_player", 1.0, 0, 0, 0, 0);
	self playerlinktoabsolute(player_hands, "tag_player" );
	
	if(!IsDefined(self.fell))
	{
		animation_time = getAnimLength( level.scr_anim["player_hands"][ anim_str ] );
		plane thread maps\_anim::anim_single_solo( player_hands, anim_str );
		wait(animation_time - 0.25);
		
		movement = level.player GetNormalizedMovement();
		if(movement[0] > 0 || movement[1] > 0)
		{
			level.player StartCameraTween( 0.25 );
		}
		wait(0.25);
		//plane maps\_anim::anim_single_solo( player_hands, anim_str );
		
	}
	else if( anim_str == "pby_left_to_right" || anim_str == "pby_right_to_left" )
	{
		thread maps\_anim::anim_single_solo( player_hands, anim_str );
	}
	else
	{
		animation_time = getAnimLength( level.scr_anim["player_hands"][ "bank_to_right" ] );
		plane thread maps\_anim::anim_single_solo( player_hands, "bank_to_right");
		wait(animation_time - 0.25);
		
		movement = level.player GetNormalizedMovement();
		if(movement[0] > 0 || movement[1] > 0)
		{
			level.player StartCameraTween( 0.25 );
		}
		
		wait(0.25);
		
		//plane maps\_anim::anim_single_solo( player_hands, "bank_to_right");
		self.fell = undefined;
	}
	
	if(IsDefined(self.pacing_moment))
	{
		level.plane_a thread pby_veh_idle("float", 0.05);
	}
	
	player_hands thread delete_later();
	//-- end playing the animation
}

play_trans_AI_FtoV( guy )
{
	//-- play the Front to Ventral AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "FtoV", "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "FtoV", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, "FtoV", "my_idle", "tag_engineer", "stop_pilot_idling");
	//level thread play_trans_AI_crew_member( level.plane_a.engineer, "firel", "my_idle", "tag_origin", "stop_engineer_idling");
}

play_trans_AI_FtoR( guy )
{
	//-- play the Front to Right AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "RtoF", "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "RtoF", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, "RtoF", "my_idle", "tag_engineer", "stop_pilot_idling");
}

play_trans_AI_RtoF( guy )
{
	//-- play the Right to Front AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "RtoF", "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "RtoF", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, "RtoF", "my_idle", "tag_engineer", "stop_pilot_idling");
	//level thread play_trans_AI_crew_member( level.plane_a.engineer, "ftol", "my_idle", "origin_animate_jnt", "stop_engineer_idling");
}

play_trans_AI_FtoL( guy )
{
	//-- play the Front to Left AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "FtoL", "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "FtoL", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, 	"FtoL", "my_idle", "tag_engineer", "stop_pilot_idling");
	//level thread play_trans_AI_crew_member( level.plane_a.engineer, "FtoL", "my_idle", "tag_engineer", "stop_engineer_idling");
}

play_trans_AI_LtoF( guy )
{
	//-- play the Front to Left AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "RtoF", "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "RtoF", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, 	"RtoF", "my_idle", "tag_engineer", "stop_pilot_idling");
	//level thread play_trans_AI_crew_member( level.plane_a.engineer, "FtoL", "my_idle", "tag_engineer", "stop_engineer_idling");
}

play_trans_AI_Distress( guy )
{
	//-- play the Distress call AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "distress", "my_idle_rad", "tag_engineer", "stop_radioop_idling", true);
	level thread play_trans_AI_crew_member( level.plane_a.copilot, "distress", "my_idle", "tag_engineer", "stop_copilot_idling");
	level thread play_trans_AI_crew_member( level.plane_a.pilot, "distress", "my_idle", "tag_engineer", "stop_pilot_idling");
	//level thread play_trans_AI_crew_member( level.plane_a.engineer, "distress", "my_idle", "tag_engineer", "stop_engineer_idling");
}

play_trans_AI_Distress2( guy )
{
	//-- play the Distress call AI animations
	level thread play_trans_AI_crew_member( level.plane_a.radioop, "distress2", "my_idle_rad", "navigator_seat_jnt", "stop_radioop_idling");
}

play_trans_AI_crew_member( guy , scripted_anim, idle_anim, anim_joint, idle_stop_notify, no_loop )
{
	the_plane = level.plane_a;
	the_plane notify(idle_stop_notify);

	the_plane anim_single_solo(guy, scripted_anim, anim_joint);
	
	if(!IsDefined(no_loop))
	{
		the_plane thread anim_loop_solo(guy, idle_anim, anim_joint, idle_stop_notify);
	}
}

play_trans_gunner( guy , special_case)
{
	if(!IsDefined(level.gunner_anim_count))
	{
		level.gunner_anim_count = 0;
	}
	
	if(IsDefined(special_case))
	{
		level.gunner_anim_count = special_case;
	}
	
	scripted_anim = "none";
	looped_anim = "none";
	
	switch(level.gunner_anim_count)
	{
		case 0:
			scripted_anim = "ftol";
		break;
		case 1:
			scripted_anim = "firel";
		break;
		case 2:
			scripted_anim = "ltov";
			looped_anim = "firev";
		break;
		case 3:
			scripted_anim = "vtof";
		break;
		case 4:
			scripted_anim = "pass";
		break;
		case 5:
			scripted_anim = "ltor";
		break;
		case 6:
			scripted_anim = "look";
		break;
		case 7:
			scripted_anim = "nod";
		break;
		case 8:
			scripted_anim = "firel";
		break;
		case 9:
			scripted_anim = "ltof";
		break;
		case 10:
			scripted_anim = "ftor";
		break;
		case 11:
			scripted_anim = "pass2";
		break;
		case 100:
			scripted_anim = "firel";
			looped_anim = "firelloop";
		break;
		default:
		break;
	}
	
	level.gunner_anim_count++;
	
	if(scripted_anim == "none")
	{
		return;
	}
	
	if(looped_anim == "none")
	{
		level thread play_trans_AI_crew_member( level.plane_a.engineer, scripted_anim, "my_idle", "tag_engineer", "stop_engineer_idling", true);
	}
	else
	{
		level thread play_trans_AI_crew_member( level.plane_a.engineer, scripted_anim, looped_anim, "tag_engineer", "stop_engineer_idling");
	}
	
}

delete_later()
{
	self hide();
	wait 0.1;
	self delete();
}

//-- This is used to place players in specific seats during
//-- specific sections of gameplay
force_players_into_seat(position_string)
{
	//plane = pick_proper_plane(self);
	plane = level.plane_a;
	
	switch(position_string) //-- The position that the players start in for the map
	{
		case "starting":
			plane.right = "has_player";
			//plane.gun_back UseBy(self);
			plane usevehicle(self, 3); //TODO CHANGE THIS BACK to 4
			self setup_seat_control("pby_rightgun");
		break;
		case "rescue": //-- The position that the player's have to be in for the rescue portion of the map
			ASSERTEX(false, "The player being forced into a seat doesn't exist");
		break;
		default:
		break;
	}
}

//-- Initialize the specific loadouts of the plane for the mission ------------------------------------------------

//-- Builds Custom Player Plane
build_player_planes( type ) //-- There might be more than one type... maybe... or something...
{
	model = undefined;
	death_model = undefined;
	death_fx = "explosions/large_vehicle_explosion";
	death_sound = "explo_metal_rand";
	bombs = false;
	turretType = "default_aircraft_turret";
	turretModel = "weapon_machinegun_tiger";
	func = undefined;
	health = 100000;
	min_health = 100000;
	max_health = 100000;
	team = "axis";

	if( type == "pby_blackcat" )
	{
		model = "vehicle_usa_pby_exterior_blackcat";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_usa_pby_exterior_blackcat";
		health = 100000;
		min_health = 99999;
		max_health = 100001;
		team = "allies";
		
		func = ::pby_plane_init;
		
		maps\_vehicle::build_template( "pby", model, type );
		maps\_vehicle::build_localinit( func );
		maps\_vehicle::build_deathmodel( model, death_model );
		maps\_vehicle::build_deathfx( death_fx, "tag_engineer", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
		maps\_vehicle::build_life( health, min_health, max_health );
		maps\_vehicle::build_treadfx( type );
		maps\_vehicle::build_team( team );
	}
	
	if( type == "fletcher_destroyer" )
	{
		model = "vehicle_usa_ship_fletcher_hull";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_usa_ship_fletcher_hull";
		health = 100000;
		min_health = 99999;
		max_health = 100001;
		team = "allies";
		
		func = ::fletcher_init;
		
		maps\_vehicle::build_template( "fletcher", model, type );
		maps\_vehicle::build_localinit( func );
		maps\_vehicle::build_deathmodel( model, death_model );
		maps\_vehicle::build_deathfx( death_fx, "tag_origin", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
		maps\_vehicle::build_life( health, min_health, max_health );
		maps\_vehicle::build_treadfx( type );
		maps\_vehicle::build_team( team );
		
		load_fletcher_ship_names();
	}
	
	maps\_vehicle::build_compassicon();
}

pby_plane_init()
{
	//-- empty currently
	self.pontoon_status = "down";
	self.ventral_status = "open";
	self.in_water = false;
	self.script_cheap = true;
	self.script_crashtypeoverride = "none";
	
	self thread play_wake_fx();
	self thread pby_regenerating_health();
	self thread pby_running_lights();
	
	level thread pby_window_fx(self);
	level thread pby_window_cloud(self);
	
	self thread pby_damage_thread();
	self thread pby_damage_fx_manager();
}


pby_damage_fx_manager()
{
	self thread pby_damage_fx_right_wing();
	self thread pby_damage_fx_left_wing();	
}

pby_damage_fx_right_wing()
{
	self endon("death");
	
	
	self.wingright_dmg = self spawn_bullet_hole_entity( "vehicle_usa_pby_wingright_damage01" );
	
	while(1)
	{	
		if(flag("pby_right_wing_dmg3"))
		{
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingright_dmg, "bullet2");
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingright_dmg, "bullet4");
			
			self thread damage_to_pby_dialogue( "right_wing" );
			self DoDamage( 50000, self.origin, level.player, 18);
			while(true)
			{
				self.engine_fx_right Delete();
				self.engine_fx_right = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng3"], "prop_right_jnt");
				
				//-- need to do some sort of actual fail check
				wait(30); //-- randomly decided time before the 3rd state becomes the 2nd one again
				
				self thread damage_to_pby_dialogue( "engine_fire" );
				
				self.engine_fx_right Delete();
				self.engine_fx_right = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng2"], "prop_right_jnt");
				
				i = 0;
				
				while(i < 30)
				{
					self waittill("pby_rtwing_damage");
					i++;
				}
				
				flag_set("player_crashed");
			}
		}
		else if(flag("pby_right_wing_dmg2"))
		{
			self.engine_fx_right Delete();
			self.engine_fx_right = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng2"], "prop_right_jnt");
			
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingright_dmg, "bullet1");
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingright_dmg, "bullet3");
			
			flag_wait("pby_right_wing_dmg3"); //-- move on when 3rd damage state is met
		}
		else if(flag("pby_right_wing_dmg1"))
		{
			self.engine_fx_right = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng1"], "prop_right_jnt");
			self thread damage_to_pby_dialogue( "number_one_engine" );
			
			flag_wait("pby_right_wing_dmg2"); //-- move on when 2nd damage state is met
		}
	
		wait(0.05);
	}
	
}

pby_damage_fx_left_wing()
{
	self endon("death");
	
	self.wingleft_dmg = self spawn_bullet_hole_entity( "vehicle_usa_pby_wingleft_damage01" );
	
	while(1)
	{	
		if(flag("pby_left_wing_dmg3"))
		{
			
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingleft_dmg, "bullet2");
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingleft_dmg, "bullet4");
			
			self DoDamage( 50000, self.origin, level.player, 17);
			self thread damage_to_pby_dialogue( "left_wing" );
			
			while(true)
			{
				self.engine_fx_left Delete();
				self.engine_fx_left = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng3"], "prop_left_jnt");
				
				//-- need to do some sort of actual fail check
				wait(30); //-- randomly decided time before the 3rd state becomes the 2nd one again
				
				self.engine_fx_left Delete();
				self.engine_fx_left = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng2"], "prop_left_jnt");
				self thread damage_to_pby_dialogue( "engine_fire" );
				
				i = 0;
				while(i < 30)
				{
					self waittill("pby_ltwing_damage");
					i++;
				}
				
				flag_set("player_crashed");
			}
		}
		else if(flag("pby_left_wing_dmg2"))
		{
			self.engine_fx_left Delete();
			self.engine_fx_left = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng2"], "prop_left_jnt");
			
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingleft_dmg, "bullet1");
			PlayFXOnTag( level._effect["pby_wng_sprk"], self.wingleft_dmg, "bullet3");
			
			flag_wait("pby_left_wing_dmg3"); //-- move on when 3rd damage state is met
		}
		else if(flag("pby_left_wing_dmg1"))
		{
			self.engine_fx_left = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_dmg_eng1"], "prop_left_jnt");
			self thread damage_to_pby_dialogue( "number_two_engine" );
			
			flag_wait("pby_left_wing_dmg2"); //-- move on when 2nd damage state is met
		}
	
		wait(0.05);
	}
}

pby_damage_thread()
{
	self endon("death");
	
	damage_ref_points = [];
	damage_ref_offset["nose"] 	= ( 190,   0,  0); //(front, right, up)
	damage_ref_offset["rtwing"] = (   0,  58, 54);
	damage_ref_offset["rtgun"] 	= (-134,  62, 54);
	damage_ref_offset["ltwing"] = (   0, -58, 54);
	damage_ref_offset["ltgun"] 	= (-134, -62, 54);
	damage_ref_offset["tail"]		= (-286,   0, 78);
	
	//-- currently only hooking up the godray decals
	self.rtgun = 0;
	self.ltgun = 0;
	self.tail = 0;
	
	self thread pby_bullet_hole_manager();
		
	keys = getArrayKeys(damage_ref_offset);
	
	while(true)
	{
		self waittill("damage", amount, attacker, direction, point, type);
				
		//-- Figure Out What Piece of the PBY Was Hit (ghetto!)
		current_forward = AnglesToForward(self.angles);
		current_right 	= AnglesToRight(self.angles);
		current_up 			= AnglesToUp(self.angles);
		
		dmg_points = [];
		for(i = 0; i < keys.size; i++)
		{
			//-- populate the damage reference points
			dmg_points[keys[i]] = self.origin + (current_forward * damage_ref_offset[keys[i]][0]) + (current_right * damage_ref_offset[keys[i]][1]) + (current_up * damage_ref_offset[keys[i]][2]);
		}
		
		index = 0;
		closest_point = dmg_points[keys[0]];
		
		for(i = 1 ; i < keys.size; i++)
		{	
			//-- sort for the closest point
			if(Distance(dmg_points[keys[i]], point) < Distance(closest_point, point))
			{
				closest_point = dmg_points[keys[i]];
				index = i;
			}
		}
		
		//iprintln("pby got hit in the: " + keys[index]);
		switch( keys[index] )
		{
			case "nose":
				self notify("pby_nose_damage", attacker);
			break;
			
			case "rtwing":
				self notify("pby_rtwing_damage", attacker);
			break;
			
			case "ltwing":
				self notify("pby_ltwing_damage", attacker);
			break;
			
			case "rtgun":
				self notify("pby_rtgun_damage", attacker);
				self.rtgun++;	
			break;
			
			case "ltgun":
				self notify("pby_ltgun_damage", attacker);
				self.ltgun++;
			break;
			
			case "tail":
				self notify("pby_tail_damage", attacker);
				self.tail++;
			break;
			
			default:
			break;
		}
		
		self notify("check_for_bullet_hole");
	}
}

pby_damage_nose_glass()
{
	//level.plane_a.glass_bullets_right = level.plane_a spawn_bullet_hole_entity("vehicle_usa_pby_blisterright_glass01");
	bullet_hits = 0;
	piece_cycle = 0;
	
	piece_numbers = [];
	piece_numbers[0]["piece"] = 23;
	//piece_numbers[0]["bullet"] = "bullet4";
		
	piece_numbers[1]["piece"] = 24;
	//piece_numbers[1]["piece2"] = 13;
	//piece_numbers[1]["bullet"] = "bullet3";
		
	//piece_numbers[2]["piece"] = 22;
	//piece_numbers[2]["bullet"] = "bullet2";
	
	total_pieces_hit = 0;
	
	attacker = undefined;
	
	while(1)
	{
		while(bullet_hits < level.bullet_hits_before_swap)
		{
			//level.plane_a waittill_either("pby_rtwing_damage", "pby_rtgun_damage");
			level.plane_a waittill("pby_nose_damage", attacker);
			
			if(attacker.classname != "worldspawn" && attacker.vehicletype == "zero")
			{
				self_forward = AnglesToForward(level.plane_a.angles);
				player_dir = VectorNormalize(attacker.origin - level.player.origin);
				angle = VectorDot(self_forward, player_dir);
				
				if(angle < 0.4 )
				{
					continue;
				}
			}
			
			if(level.player.current_seat == "pby_frontgun")
			{
				if(total_pieces_hit < (level.bullet_hits_before_swap * piece_numbers.size) )
				{
					random_fx = RandomInt(piece_numbers.size);
					//PlayFXOnTag( level._effect["pby_blister_glass"], level.plane_a.glass_bullets_right, piece_numbers[random_fx]["bullet"] );
				}
				bullet_hits++;
			}
		}
		
		if(level.player.current_seat == "pby_frontgun" )
		{
			if(total_pieces_hit < (level.bullet_hits_before_swap * piece_numbers.size))
			{
				level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece"]);
				if(IsDefined(piece_numbers[piece_cycle]["piece2"]))
				{
					level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece2"]);
				}
				//PlayFXOnTag( level._effect["large_glass"], level.plane_a.glass_bullets_right, piece_numbers[piece_cycle]["bullet"] );
				piece_cycle++;
				
				if(IsDefined(attacker))
				{
					if(!level.player.in_transition)
					{
						level.player DisableInvulnerability();
						level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
						//level.player DoDamage( 100, attacker.origin, level.player );
					}
				}
					
				//-- reset values
				bullet_hits = 0;
				total_pieces_hit++;
				if(piece_cycle > 1)
				{
					piece_cycle = 0;
				}
				
				wait(0.05);
				level.player EnableInvulnerability();
			}
			else
			{
				flag_set("ok_to_shoot_at_player");
				level.player DisableInvulnerability();
				
				while(level.player.current_seat == "pby_frontgun")
				{
					level.plane_a waittill("pby_nose_damage", attacker);
					if(IsDefined(attacker))
					{
						if(!level.player.in_transition)
						{
							level.player DisableInvulnerability();
							level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
							level.plane_a notify("pby_rtwing_damage");
						}
					}
					wait(0.05);	
				}
				
				bullet_hits = 0;
				level.player EnableInvulnerability();
				flag_clear("ok_to_shoot_at_player");
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

pby_damage_blister_glass_right()
{
	level.plane_a.glass_bullets_right = level.plane_a spawn_bullet_hole_entity("vehicle_usa_pby_blisterright_glass01");
	bullet_hits = 0;
	piece_cycle = 0;
	
	piece_numbers = [];
	piece_numbers[0]["piece"] = 15;
	piece_numbers[0]["bullet"] = "bullet4";
		
	piece_numbers[1]["piece"] = 21;
	piece_numbers[1]["piece2"] = 13;
	piece_numbers[1]["bullet"] = "bullet3";
		
	piece_numbers[2]["piece"] = 22;
	piece_numbers[2]["bullet"] = "bullet2";
	
	total_pieces_hit = 0;
	
	attacker = undefined;
	
	while(1)
	{
		while(bullet_hits < level.bullet_hits_before_swap)
		{
			//level.plane_a waittill_either("pby_rtwing_damage", "pby_rtgun_damage");
			level.plane_a waittill("pby_rtgun_damage", attacker);
			if(total_pieces_hit < 16)
			{
				random_fx = RandomInt(piece_numbers.size);
				PlayFXOnTag( level._effect["pby_blister_glass"], level.plane_a.glass_bullets_right, piece_numbers[random_fx]["bullet"] );
			}
			bullet_hits++;
		}
		
		//if(level.player.current_seat == "pby_rightgun" && IsDefined(attacker) )
		if(level.player.current_seat == "pby_rightgun" )
		{
			if(total_pieces_hit < 16)
			{
				level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece"]);
				if(IsDefined(piece_numbers[piece_cycle]["piece2"]))
				{
					level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece2"]);
				}
				PlayFXOnTag( level._effect["large_glass"], level.plane_a.glass_bullets_right, piece_numbers[piece_cycle]["bullet"] );
				piece_cycle++;
				
				if(IsDefined(attacker))
				{
					if(!level.player.in_transition)
					{
						level.player DisableInvulnerability();
						level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
						//level.player DoDamage( 100, attacker.origin, level.player );
					}
				}
					
				//-- reset values
				bullet_hits = 0;
				total_pieces_hit++;
				if(piece_cycle > 2)
				{
					piece_cycle = 0;
				}
				
				wait(0.05);
				level.player EnableInvulnerability();
			}
			else
			{
				flag_set("ok_to_shoot_at_player");
				level.player DisableInvulnerability();
				
				while(level.player.current_seat == "pby_rightgun")
				{
					level.plane_a waittill("pby_rtgun_damage", attacker);
					if(IsDefined(attacker))
					{
						if(!level.player.in_transition)
						{
							level.player DisableInvulnerability();
							level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
							level.plane_a notify("pby_rtwing_damage");
						}
					}
					wait(0.05);	
				}
				
				bullet_hits = 0;
				level.player EnableInvulnerability();
				flag_clear("ok_to_shoot_at_player");
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

pby_damage_blister_glass_left()
{
	level.plane_a.glass_bullets_left = level.plane_a spawn_bullet_hole_entity("vehicle_usa_pby_blisterleft_glass01");
	bullet_hits = 0;
	piece_cycle = 0;
	
	piece_numbers = [];
	piece_numbers[0]["piece"] = 14;
	piece_numbers[0]["bullet"] = "bullet4";
		
	piece_numbers[1]["piece"] = 19;
	piece_numbers[1]["piece2"] = 12;
	piece_numbers[1]["bullet"] = "bullet3";
	
		
	piece_numbers[2]["piece"] = 20;
	piece_numbers[2]["bullet"] = "bullet2";
	
	total_pieces_hit = 0;
	
	attacker = undefined;
	
	while(1)
	{
		while(bullet_hits < level.bullet_hits_before_swap)
		{
			//level.plane_a waittill_either("pby_ltwing_damage", "pby_ltgun_damage");
			level.plane_a waittill("pby_ltgun_damage", attacker);
			if(total_pieces_hit < 16)
			{
				random_fx = RandomInt(piece_numbers.size);
				PlayFXOnTag( level._effect["large_glass"], level.plane_a.glass_bullets_left, piece_numbers[random_fx]["bullet"] );
			}
			bullet_hits++;
		}
		
		if(level.player.current_seat == "pby_leftgun" )
		{
			if(total_pieces_hit < 16)
			{
				level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece"]);
				if(IsDefined(piece_numbers[piece_cycle]["piece2"]))
				{
					level.plane_a DoDamage(4000, level.plane_a.origin, level.player, piece_numbers[piece_cycle]["piece2"]);
				}
				PlayFXOnTag( level._effect["pby_blister_glass"], level.plane_a.glass_bullets_left, piece_numbers[piece_cycle]["bullet"] );
				piece_cycle++;
				
				if(IsDefined(attacker))
				{
					if(!level.player.in_transition)
					{
						level.player DisableInvulnerability();
						//level.player DoDamage( 20, level.player.origin, level.player );
						level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
					}
				}
					
				//-- reset values
				bullet_hits = 0;
				total_pieces_hit++;
				if(piece_cycle > 2)
				{
					piece_cycle = 0;
				}
				
				wait(0.05);
				level.player EnableInvulnerability();
			}
			else
			{
				level.player DisableInvulnerability();
				flag_set("ok_to_shoot_at_player");
				
				while(level.player.current_seat == "pby_leftgun")
				{
					level.plane_a waittill("pby_ltgun_damage", attacker);
					if(IsDefined(attacker))
					{
						if(!level.player.in_transition)
						{
							level.player DisableInvulnerability();
							level.player DoDamage( level.damage_transfered_to_player, attacker.origin, level.player );
							level.plane_a notify("pby_ltwing_damage");
						}
					}
					wait(0.05);	
				}
				
				bullet_hits = 0;
				level.player EnableInvulnerability();
				flag_clear("ok_to_shoot_at_player");
			}
		}
		else
		{
			wait(0.05);
		}
	}
}


pby_bullet_hole_manager()
{
	self thread pby_bullet_hole_right_gun();
	self thread pby_bullet_hole_left_gun();
	self thread pby_bullet_hole_tail();
	
	local_rtgun = self.rtgun;
	local_ltgun = self.ltgun;
	local_tail  = self.tail;
	
	bullet_count_right = 1;
	bullet_count_left = 1;
	bullet_count_tail = 1;
	
	for( ; ; )
	{
		self waittill("check_for_bullet_hole");
		
		if( local_rtgun != self.rtgun && self.right == "has_player")
		{
			bullet_count_right++;
			if(bullet_count_right % 20 == 0)
			{
				self notify("add right gun bullethole");
				local_rtgun = self.rtgun;
			}
		}
		
		if( local_ltgun != self.ltgun && self.left == "has_player")
		{
			bullet_count_left++;
			if(bullet_count_left % 20 == 0)
			{
				self notify("add left gun bullethole");
				local_ltgun = self.ltgun;
			}
		}
		
		if( local_tail != self.tail && self.front != "has_player") //-- take damage if the player is anywhere that could see this
		{
			bullet_count_tail++;
			if(bullet_count_tail % 20 == 0)
			{
				self notify("add tail bullethole");
				local_tail = self.tail;
			}
		}
	}
}

pby_bullet_hole_right_gun()
{
	//precachemodel("vehicle_usa_pby_bulletholes05"); //-- right front
	bullet_holes = self spawn_bullet_hole_entity( "vehicle_usa_pby_bulletholes05" );
		
	for( holes = 1; holes < 5; holes++)
	{
		self waittill("add right gun bullethole");
		
		PlayFX( level._effect["spark"], bullet_holes GetTagOrigin("bullet" + holes), AnglesToForward(bullet_holes GetTagAngles("bullet" + holes)));
		PlayFXOnTag( level._effect["godray_night"], bullet_holes, "bullet" + holes );
	}
}

pby_bullet_hole_left_gun()
{
	//precachemodel("vehicle_usa_pby_bulletholes06"); //-- left front
	bullet_holes = self spawn_bullet_hole_entity( "vehicle_usa_pby_bulletholes06" );
	
	for( holes = 1; holes < 5; holes++)
	{
		self waittill("add left gun bullethole");
		
		PlayFX( level._effect["spark"], bullet_holes GetTagOrigin("bullet" + holes), AnglesToForward(bullet_holes GetTagAngles("bullet" + holes)));
		PlayFXOnTag( level._effect["godray_night"], bullet_holes, "bullet" + holes );
	}
}

pby_bullet_hole_tail()
{
	//precachemodel("vehicle_usa_pby_bulletholes04"); //-- right rear
	//precachemodel("vehicle_usa_pby_bulletholes07"); //-- left rear
	bullet_holes = [];
	bullet_holes[0] = self spawn_bullet_hole_entity( "vehicle_usa_pby_bulletholes04" );
	bullet_holes[1] = self spawn_bullet_hole_entity( "vehicle_usa_pby_bulletholes07" );
	
	for( i = 0; i < bullet_holes.size; i++)
	{
		for( holes = 1; holes < 5; holes++)
		{
			self waittill("add tail bullethole");
			
			PlayFX( level._effect["spark"], bullet_holes[i] GetTagOrigin("bullet" + holes), AnglesToForward(bullet_holes[i] GetTagAngles("bullet" + holes)));
			PlayFXOnTag( level._effect["godray_night"], bullet_holes[i], "bullet" + holes );
		}
	}
}

spawn_bullet_hole_entity( model )
{
	
	bullet_hole_model = Spawn("script_model", (0,0,0));
	bullet_hole_model SetModel( model );
	bullet_hole_model.origin = self GetTagOrigin("origin_animate_jnt");
	bullet_hole_model.angles = self GetTagAngles("origin_animate_jnt");
	//bullet_hole_model.forward = AnglesToForward(bullet_holes[i].angles);
	bullet_hole_model LinkTo(self, "origin_animate_jnt" );	
	
	return bullet_hole_model;
}

pby_running_lights()
{
	self.running_lights = Spawn("script_model", self GetTagOrigin("tag_origin"));
	self.running_lights SetModel("tag_origin");
	self.running_lights.angles = self GetTagAngles("tag_origin");
		
	self.running_lights LinkTo(self, "origin_animate_jnt");
		
	PlayFXOnTag( level._effect["pby_running_lights"], self.running_lights, "tag_origin" );
}

kill_pby_running_lights()
{
	self.running_lights Delete();
}

pby_window_fx(plane)
{
	plane waittill("start_mist");
	wait(10);
	plane.ventral_mist = plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_window"], "tag_origin");
}

pby_window_cloud(plane)
{
	plane.window_clouds = plane maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pby_clouds"], "tag_origin");
	plane waittill("start_mist");
	wait(10);
	plane.window_clouds Delete();
}


pby_regenerating_health()
{
	self.healthbuffer = 20000; 
	//self.health += self.healthbuffer;
	self.currenthealth = self.health; 
	
	max_health = self.currenthealth;
	amount = undefined;
	self.damage_state = 0;
	
	while( true )
	{
		self waittill("damage", amount);
		self.health = max_health;
	}
}

play_wake_fx()
{
	self thread toggle_pby_in_water();
	self thread toggle_pby_in_flight();
	
	self endon("death");
		
	//level._effect["splash_land_center"] = loadfx("maps/fly/fx_splash_pby_land_ctr");
	//level._effect["splash_land_wing"]		= loadfx("maps/fly/fx_splash_pby_land_wng");
	//level._effect["pby_wake_center"]		= loadfx("maps/fly/fx_wake_pby_ctr");
	//level._effect["splash_takeoff_center"] = loadfx("maps/fly/fx_splash_pby_takeoff_ctr");
	//level._effect["splash_takeoff_wing"]	 = loadfx("maps/fly/fx_splash_pby_takeoff_wng");
	
	right_fx = undefined;
	left_fx = undefined;
	center_fx = undefined;
	
	playing_wake = false;
	my_speed = 0;
	
	while(true)
	{
			if(self.in_water)
			{
				//playfxontag(level._effect["splash_land_wing"], self, "tag_wake_wing_R_fx");
				//playfxontag(level._effect["splash_land_wing"], self, "tag_wake_wing_L_fx");
				//playfxontag(level._effect["splash_land_center"], self, "tag_origin");
					
				self thread play_wing_center_wake();
				self thread play_wing_center_splash();
				
				while(self.in_water)
				{
					wait(0.1);
				}
			}
	
		wait(0.1);
	}	
}

play_wing_center_wake()
{
	my_speed = 0;
	max_speed = 264; //	in per sec
	max_delay = 0.25;
	min_delay = 0.1;
	height_delta = 0;
	left_wing_origin = (0,0,0);
	right_wing_origin = (0,0,0);
	wing_forward = (0,0,0);
	wing_up = (0,0,0);
	wait_time = 0;
	
	
	
	while(self.in_water)
	{
		my_speed = self GetSpeed();
		
		if(my_speed < 53) //3 mph
		{
			wait(0.1);
			continue;
		}
		
		left_wing_origin = self GetTagOrigin("tag_wake_wing_L_fx");
		right_wing_origin = self GetTagOrigin("tag_wake_wing_R_fx");
		
		//playfxontag(level._effect["pby_wake_center"], self, "tag_wake_ctr_fx");
		
		if(right_wing_origin[2] <= level.WATER_LEVEL)
		{
			wing_forward = AnglesToForward(self GetTagAngles("tag_wake_wing_R_fx"));
			wing_up = AnglesToUp(self GetTagAngles("tag_wake_wing_R_fx"));
			height_delta = level.WATER_LEVEL - right_wing_origin[2] + 2; //put it just above the surface of the water
			playfx(level._effect["pby_wake_wing"], right_wing_origin + (0,0,height_delta), wing_forward, wing_up);
		}
		
		if(left_wing_origin[2] <= level.WATER_LEVEL)
		{
			wing_forward = AnglesToForward(self GetTagAngles("tag_wake_wing_L_fx"));
			wing_up = AnglesToUp(self GetTagAngles("tag_wake_wing_L_fx"));
			height_delta = level.WATER_LEVEL - left_wing_origin[2] + 2;
			playfx(level._effect["pby_wake_wing"], left_wing_origin + (0,0,height_delta), wing_forward, wing_up);
		}
		
		if(my_speed > max_speed)
		{
			wait(min_delay);
		}
		else
		{
			wait_time = ( (my_speed / max_speed) * (max_delay - min_delay) ) + min_delay;
			wait(wait_time);
		}
	}
}

play_wing_center_splash()
{
	my_speed = 0;
	max_speed = 264; //	in per sec
	max_delay = 1.0;
	min_delay = 0.5;
	height_delta = 0;
	left_wing_origin = (0,0,0);
	right_wing_origin = (0,0,0);
	wing_forward = (0,0,0);
	wing_up = (0,0,0);
	wait_time = 0;
	
	while(self.in_water)
	{
		my_speed = self GetSpeed();
		
		if(my_speed < 53) //3 mph
		{
			wait(0.1);
			continue;
		}
		
		left_wing_origin = self GetTagOrigin("tag_wake_wing_L_fx");
		right_wing_origin = self GetTagOrigin("tag_wake_wing_R_fx");
		
		new_ent = Spawn("script_model", self.origin);
		new_ent SetModel("tag_origin");
		new_ent.origin = self GetTagOrigin("tag_origin");
		new_ent.angles = AnglesToForward(self GetTagAngles("tag_origin"));
		
		
		playfxontag(level._effect["pby_spray_center"], new_ent, "tag_origin");
		
		if(right_wing_origin[2] <= level.WATER_LEVEL)
		{
			wing_forward = AnglesToForward(self GetTagAngles("tag_wake_wing_R_fx"));
			wing_up = AnglesToUp(self GetTagAngles("tag_wake_wing_R_fx"));
			height_delta = level.WATER_LEVEL - right_wing_origin[2] + 2; //put it just above the surface of the water
			playfx(level._effect["pby_spray_wing"], right_wing_origin + (0,0,height_delta), wing_forward, wing_up);
		}
		
		if(left_wing_origin[2] <= level.WATER_LEVEL)
		{
			wing_forward = AnglesToForward(self GetTagAngles("tag_wake_wing_L_fx"));
			wing_up = AnglesToUp(self GetTagAngles("tag_wake_wing_L_fx"));
			height_delta = level.WATER_LEVEL - left_wing_origin[2] + 2;
			playfx(level._effect["pby_spray_wing"], left_wing_origin + (0,0,height_delta), wing_forward, wing_up);
		}
		
		if(my_speed > max_speed)
		{
			wait(min_delay);
		}
		else
		{
			wait_time = ( (my_speed / max_speed) * (max_delay - min_delay) ) + min_delay;
			wait(wait_time);
		}
		
		new_ent Delete();
	}
}

toggle_pby_in_water()
{
	self waittill("pby_landed");
		
	//TUEY set music state to Landing	
	setmusicstate("RESCUE_A");
	self.in_water = true;
	
	self.spray_fx = self thread maps\pby_fly_fx::play_looping_fx_on_tag( level._effect["pby_wake_center"], "origin_animate_jnt" );
}

toggle_pby_in_flight()
{
	self waittill("pby_takeoff");
	self.in_water = false;
	self.spray_fx Delete();
}
 
//-- Builds Custom Enemy Planes and Boat
//---- more specifically this is where you setup the planes that will break into multiple pieces as they take damage.
//---- this also includes the pt_boat
build_enemy_vehicles( type )
{
	
	model = undefined;
	death_model = undefined;
	death_fx = "explosions/large_vehicle_explosion";
	death_sound = "explo_metal_rand";
	bombs = false;
	turretType = "default_aircraft_turret";
	turretModel = "weapon_machinegun_tiger";
	func = undefined;
	health = 1000;
	min_health = 1000;
	max_health = 1500;
	team = "axis";
	
	if( type == "zero" )
	{
		model = "vehicle_jap_airplane_zero_fly";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_airplane_zero_fly";
		health = 10000;
		min_health = 9800;
		max_health = 10000;
		team = "axis";
		turretType = "jap_zero_turret";
		
		func = ::zero_plane_init;
		
		level.vehicle_death_thread[type] = ::zero_death_thread;
		maps\_vehicle::build_template( "zero", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
	}

	if( type == "zero_old" )
	{
		model = "vehicle_jap_airplane_zero_fly";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_airplane_zero_fly";
		health = 600;	
		min_health = 600;
		max_health = 800;
		team = "axis";
		
		func = ::zero_plane_init;
		
		level.vehicle_death_thread[type] = ::zero_death_thread;
		maps\_vehicle::build_template( "zero", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
	}
	
	if( type == "jap_ptboat" )
	{
		model = "vehicle_jap_ship_ptboat";
		death_fx = "explosions/large_vehicle_explosion";
		death_model = "vehicle_jap_ship_ptboat_dmg";
		//health = 600;
		//min_health = 599;
		//max_health = 600;
		health = 1800;
		min_health = 1799;
		max_health = 1800;
		team = "axis";
		turretType = "jap_ptboat_turret";
		
		func = ::pt_boat_init;
		
		level.vehicle_death_thread[type] = ::pt_boat_death_thread;
		maps\_vehicle::build_template( "pt_boat", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
	}

	if( type == "jap_shinyo" )
	{
		model = "vehicle_jap_ship_shinyou";
		death_fx = "maps/fly/fx_exp_shinyou";
		death_model = "vehicle_jap_ship_shinyou_d";
		health = 15;
		min_health = 10;
		max_health = 20;
		team = "axis";
		
		func = ::shinyo_boat_init;
		
		level.vehicle_death_thread[type] = ::shinyo_boat_death_thread;
		maps\_vehicle::build_template( "shinyo", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
	}	
	
	if( type == "jap_merchant_ship" )
	{
		model = "dest_merchantship2_dmg0";
		death_fx = "maps/fly/fx_exp_shinyou";
		death_model = "dest_merchantship2_dmg0";
		health = 999999;
		min_health = 999998;
		max_health = 999999;
		team = "axis";
		
		func = ::merchant_ship_init;
		level.vehicle_death_thread[type] = ::merchant_ship_death_thread;
		maps\_vehicle::build_template( "merchant_ship", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
				
		model = "dest_merchantship_dmg0";
		death_model = "dest_merchantship_dmg0";
		maps\_vehicle::build_template( "merchant_ship", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
		
		model = "dest_merchantship4_dmg0";
		death_model = "dest_merchantship4_dmg0";
		maps\_vehicle::build_template( "merchant_ship", model, type );
		maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this
		maps\_vehicle::build_localinit( func );
	}	
		
	//maps\_vehicle::build_template( "stuka", model, type ); -- took out the global call because of the merchant ship variations
	//maps\_vehicle::build_localinit( func );
	//maps\_vehicle::build_deathmodel( model, death_model ); //-- We should need to do this

	if(type != "jap_ptboat" && type != "jap_shinyo")
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	}
	else if(type == "jap_ptboat")
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine_left", death_sound, undefined, undefined, undefined, undefined );  // TODO change to actual explosion fx/sound when we get it
	}
	else if(type == "jap_shinyo")
	{
		maps\_vehicle::build_deathfx( death_fx, "tag_engine_left", death_sound, undefined, undefined, undefined, undefined, undefined, "extra_death_fx" );  // TODO change to actual explosion fx/sound when we get it
	}
	
	maps\_vehicle::build_life( health, min_health, max_health );
	maps\_vehicle::build_treadfx(type);
	maps\_vehicle::build_team( team );
	maps\_vehicle::build_compassicon();
}

zero_plane_init()
{
	//-- specific inits to the Zero	
	self.script_cheap = true;
	self.nodeathfx = true;
	self.script_crashtypeoverride = "none";
	self.crashing = true;
	
	//-- Gun Targets
	//self.right_turret_target = Spawn("script_origin", self.origin);
	//self.right_turret_target.origin = self.origin + (AnglesToForward(self.angles) * 5000) - (0,0, Tan(15) * 5000); //-- used to be tan(10)
	//self.right_turret_target LinkTo(self);
	
	//self.left_turret_target = Spawn("script_origin", self.origin);
	//self.left_turret_target.origin = self.origin + (AnglesToForward(self.angles) * 5000) - (0,0, Tan(15) * 5000); //-- used to be tan(10)
	//self.left_turret_target LinkTo(self);
	
	self.shoot_gun_range = 10000;
	
	//self.tail_light = Spawn("script_model", (0,0,0));
	//self.tail_light SetModel("tag_origin");
	//self.tail_light.origin = self.origin;
	//self.tail_light.angles = self.angles;
	//self.tail_light LinkTo(self, "origin_animate_jnt");
	//PlayFXOnTag(level._effect["zero_tail_light"], self, "tag_origin");
		
	wait(0.1); //-- Let the rest of the init function in _vehicle.gsc run before adjusting it
	
	self notify( "stop_friendlyfire_shield" ); //-- Stop the built in friendlyfire_shield()
	self thread zero_damage_thread();
	self thread zero_boundary_watch();
	self thread zero_spline_fire_start();
	self thread zero_end_spline_delete();
	self thread zero_spin_prop();
	
	//AUDIO Play the plane sound -- TODO: clean this up
	self thread maps\pby_fly_amb::play_zero_sounds(level.plane_a, level.plane_b);
	
	self.animname = "zero";
	self thread anim_loop_solo(self, "idle", undefined, "death");
	//self AddVehicleToCompass();
}

zero_end_spline_delete()
{
	self endon("death");
	self waittill("reached_end_node");
	
	wait(0.05);
	
	if(!IsDefined(self.kamikaze))
	{
		self.notrealdeath = true;
		self notify("death");
	}
}

zero_spline_fire_start()
{
	self endon("death");
	self waittill("fire_my_turret");
	self.shoot_gun_range = 20000;
	self thread ai_turret_think(level.plane_a);
}

zero_boundary_watch()
{
	self endon("death");
	
	while(1)
	{
		if(self.origin[0] > 60000 || self.origin[0] < -60000 || self.origin[1] > 60000 || self.origin[1] < -60000 || self.origin[2] > 20000 || self.origin[2] < -1000)
		{
			self freevehicle();
			wait(0.05);
			self notify("death_finished");
			self delete();
			//self RadiusDamage(self.origin, 100, 50000, 50000);
			//ASSERT(false, "I need to look at this");
		}
		
		self.origin_prev = self.origin;
		wait(0.1);
	}
}

zero_damage_thread()
{
	self endon( "death" );
	
	attacker = undefined; 
	amount = undefined;
	part_of_plane = undefined;
	original_health = self.health;
	
	temp_health = 0;
	while( self.health > 0 )
	{
		//self waittill("damage", amount);
		self waittill( "damage", amount, attacker, damage_dir, damage_ori, damage_type);
		
		temp_health = self.health - amount;
		self.dmg_point = damage_ori;
		self.attacker = attacker;
		
			//Check to play damaged fx, before blowing up
			random_dmg = RandomIntRange(0, 100);
			if(!IsDefined(self.already_damaged) && random_dmg <= 70) // 30% of the time the zeros go boom instantly
			{
				self.already_damaged = true;
				damaged_part = self zero_get_damage_point();
				
				switch(damaged_part)
				{
					case "fuselage":
						self.intermediate_damage = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_prop_fx");
					break;
					
					case "rightwing":
						//-- figure out which tag on the right_wing
						
						self.intermediate_damage = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_wing_right_fx");
					break;
					
					case "leftwing":
						//-- figure out which tag on the left_wing
						self.intermediate_damage = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_wing_left_fx");
					break;
				}
				
				self.health = original_health;
				wait(1.0);
			break;
		}
		
		
	}
	
	self notify( "death" );
}

zero_get_damage_point()
{
	//index 0/front 1/back, 2/left, 3/right
		
	ref_point = [];
	ref_point[0] = self.origin + ( AnglesToForward(self.angles) * 5 ); 	//front
	ref_point[1] = self.origin + ( AnglesToForward(self.angles) * -5 ); //rear
	ref_point[2] = self.origin + ( AnglesToRight(self.angles) * -5 ); 	//left
	ref_point[3] = self.origin + ( AnglesToRight(self.angles) * 5 );  	//right
	ref_point[4] = self.origin + ( AnglesToRight(self.angles) * -200);  //left wing tip
	ref_point[5] = self.origin + ( AnglesToRight(self.angles) * 200); 	//right wing tip
	
	closest_point = ref_point[0];
	index = 0;
	
	if(!IsDefined(self.dmg_point))
	{
		self.dmg_point = self.origin;
	}
	
	for(i = 1 ; i < ref_point.size; i++)
	{
		if(Distance(ref_point[i], self.dmg_point) < Distance(closest_point, self.dmg_point))
		{
			closest_point = ref_point[i];
			index = i;
		}
	}
				
	random_crash = "fuselage";
	if(index == 0)
	{
		random_crash = "fuselage";
	}
	else if(index == 1)
	{
		random_crash = "fuselage";
	}
	else if(index == 2)
	{
		random_crash = "fuselage";
	}
	else if(index == 3)
	{
		random_crash = "fuselage";
	}
	else if(index == 4)
	{
		random_crash = "leftwing";
	}
	else if(index == 5)
	{
		random_crash = "rightwing";
	}

	return random_crash;
}

#using_animtree ("vehicles");

zero_death_thread()
{
	wait(0.05);
	
	if(self.script_crashtypeoverride == "smash_into_other_plane")
	{
		self waittill("reached_end_node");
	}
	
	//-- Delete the two origins associated with the guns targetting
	//self.right_turret_target Delete();
	//self.left_turret_target Delete();
	
	//-- Kill Zero Sounds
	if(IsDefined(self.audio_node_propzerob))
	{
		self.audio_node_propzerob Delete();
	}
	if(IsDefined(self.audio_node_propzero))
	{
		self.audio_node_propzero Delete();
	}
	
	if(IsDefined(self.tail_light))
	{
		self.tail_light Delete();
	}
	
	//-- This Plays the Special Death FX
	if(IsDefined(self.kamikaze))
	{
		fx_marker = Spawn("script_model", self.origin);
		fx_marker SetModel("tag_origin");
		fx_marker.angles = self.angles;
	
		if(IsDefined(self.impactwater))
		{
			//-- Made this fx play in an exploder - but I added in the animation here that will be awesome
			
			//PlayFXOnTag( level._effect["zero_water"], fx_marker, "tag_origin" );
			
			
	
			crashing_plane = Spawn("script_model", self.origin);
			crashing_plane SetModel("vehicle_jap_airplane_zero_fly");
			crashing_plane.angles = (0, self.angles[1], 0);
			self Hide();
			crashing_plane UseAnimTree(#animtree);
			crashing_plane.animname = "zero";

			if( distancesquared( crashing_plane.origin, level.player.origin ) < 1500 * 1500 )
			{
				level.player SetWaterSheeting(1, 2);
				level notify("suggest close hit");
			}
			
			crashing_plane anim_single_solo( crashing_plane, "water_skip" );
		}
		else if(IsDefined(self.front_slam))
		{
			//-- HACK
			exploder(850);
			temp_node = GetVehicleNode("auto1646", "targetname");
			crashing_plane = Spawn("script_model", temp_node.origin);
			crashing_plane SetModel("vehicle_jap_airplane_zero_fly");
			crashing_plane.angles = (0, 270, 0);
			self Hide();
			crashing_plane UseAnimTree(#animtree);
			crashing_plane.animname = "zero";
			PlayFXOnTag(level._effect["zero_wing_dmg3"], crashing_plane, "origin_animate_jnt");
			crashing_plane anim_single_solo( crashing_plane, "fletcher_hit_front" );
		}
		else
		{
			RadiusDamage(self.origin, 1500, 10000, 9999);
			//-- This effect was hooked up to an exploder.  Might hook up the water FX the same way.
			//PlayFXOnTag( level._effect["zero_kamikaze"], fx_marker, "tag_origin" );
		}
		
		if(self.script_crashtypeoverride == "smash_into_other_plane")
		{
			PlayFXOnTag( level._effect["zero_kamikaze"], fx_marker, "tag_origin" );
			RadiusDamage(self.origin, 1000, 10000, 10000);
		}
	
		wait(0.1);
		self notify( "crash_done");
		
		wait(5);
		fx_marker Delete();
		return;	
	}
	
	if(IsDefined(self.notrealdeath))
	{
		wait(0.05);
		self notify( "crash_done");
		return;	
	}
	
	
	// -- Figure out which side of the plane was hit and then drop off the appropriate place
	//index 0/front 1/back, 2/left, 3/right
		
	ref_point = [];
	ref_point[0] = self.origin + ( AnglesToForward(self.angles) * 5 ); 	//front
	ref_point[1] = self.origin + ( AnglesToForward(self.angles) * -5 ); //rear
	ref_point[2] = self.origin + ( AnglesToRight(self.angles) * -5 ); 	//left
	ref_point[3] = self.origin + ( AnglesToRight(self.angles) * 5 );  	//right
	ref_point[4] = self.origin + ( AnglesToRight(self.angles) * -200);  //left wing tip
	ref_point[5] = self.origin + ( AnglesToRight(self.angles) * 200); 	//right wing tip
	
	closest_point = ref_point[0];
	index = 0;
	
	if(!IsDefined(self.dmg_point))
	{
		self.dmg_point = self.origin;
	}
	
	for(i = 1 ; i < ref_point.size; i++)
	{
		if(Distance(ref_point[i], self.dmg_point) < Distance(closest_point, self.dmg_point))
		{
			closest_point = ref_point[i];
			index = i;
		}
	}
	
	random_crash = "fuselage";
	if(index == 0)
	{
		random_crash = "fuselage";
	}
	else if(index == 1)
	{
		random_crash = "fuselage";
	}
	else if(index == 2)
	{
		random_crash = "fuselage";
	}
	else if(index == 3)
	{
		random_crash = "fuselage";
	}
	else if(index == 4)
	{
		random_crash = "leftwing";
	}
	else if(index == 5)
	{
		random_crash = "rightwing";
	}
	
	//-- pretend that the pilot got shot, so keep flying for a bit
	if(IsDefined(self.delayed_death))
	{
		random_crash = "delayed";
	}

	if(!IsDefined(self.no_explode))
	{
		//-- random chance that the plane just explodes
		disint_chance = RandomIntRange(0, 100);
		if(disint_chance <= 50)
		{
			random_crash = "disintegrate";
		}
	}
	
	//TODO: REMOVE THIS
	level notify("zero_killed");
	self RemoveVehicleFromCompass();
	self Hide();
	
		
	crashing_plane = Spawn("script_model", self.origin);
	self thread zero_death_thread_water_hit(crashing_plane);
	
	fx = undefined;
	
	switch(random_crash)
	{
		case "fuselage":
		
			//-- prop gets damaged and the plane crashes
			crashing_plane SetModel("vehicle_jap_airplane_zero_fly");
			crashing_plane.angles = self.angles;
			crashing_plane MoveGravity(AnglesToForward(self.angles) * self getspeed(), 5);
			
			//-- prop stuff
			self notify("hide_prop");
			crashing_plane thread zero_spin_prop();
			
			if(IsDefined(self.intermediate_damage))
			{
				self.intermediate_damage Unlink();
				self.intermediate_damage LinkTo(crashing_plane);
			}		
			
			roll_direction = RandomInt(2);
			
			if(roll_direction)
			{
				crashing_plane RotateRoll( 5400, 10, 3, 1);
			}
			else
			{
				crashing_plane RotateRoll( -5400, 10, 3, 1);
			}
			
			fx = crashing_plane maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_prop_fx");
			randomwait = RandomFloatRange(0.05, 1.5);
			wait(randomwait);
			fx Delete();
			PlayFXOnTag( level._effect["zero_explode"], crashing_plane, "tag_prop_fx" );
		break;
		
		case "rightwing":
			//-- right wing breaks off and the plane crashes
			crashing_plane SetModel("vehicle_jap_airplane_zero_minus_rwing");
			crashing_plane.angles = self.angles;
			
			//-- prop stuff
			self notify("hide_prop");
			crashing_plane thread zero_spin_prop();
			
			if(IsDefined(self.intermediate_damage))
			{
				self.intermediate_damage Unlink();
				self.intermediate_damage LinkTo(crashing_plane);
			}		
						
			right_wing_position = self GetTagOrigin("tag_attach_wing_RI");
			right_wing = Spawn("script_model", right_wing_position);
			right_wing SetModel("vehicle_jap_airplane_zero_d_wingr");
			right_wing.angles = self.angles + (0, -15, 0);
			
			crashing_plane MoveGravity(AnglesToForward(self.angles) * self getspeed(), 5);
			crashing_plane RotateRoll( 5400, 10, 3, 1);
			fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_wing_right_fx");
			
			right_wing MoveGravity(AnglesToForward(right_wing.angles) * (self getspeed() * .5), 5);
			right_wing RotateRoll( 5400, 10, 3, 1);
			right_wing RotatePitch( 5400, 10, 0.1, 1);
						
			//self Attach("vehicle_jap_airplane_zero_d_wingr", "tag_attach_wing_RI");
			wait(2);
			fx Delete();
			//fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_explode"], "tag_wing_right_fx");
			PlayFXOnTag(level._effect["zero_explode"], crashing_plane, "tag_wing_right_fx");
		break;
		
		case "leftwing":
			//-- left wing breaks off and the plane crashes
			crashing_plane SetModel("vehicle_jap_airplane_zero_minus_lwing");
			crashing_plane.angles = self.angles;
			
			//-- prop stuff
			self notify("hide_prop");
			crashing_plane thread zero_spin_prop();
			
			if(IsDefined(self.intermediate_damage))
			{
				self.intermediate_damage Unlink();
				self.intermediate_damage LinkTo(crashing_plane);
			}		
			
			left_wing_position = self GetTagOrigin("tag_attach_wing_LE");
			left_wing = Spawn("script_model", left_wing_position);
			left_wing SetModel("vehicle_jap_airplane_zero_d_wingl");
			left_wing.angles = self.angles + (0 ,15, 0);
			
			crashing_plane MoveGravity(AnglesToForward(self.angles) * self getspeed(), 5);
			crashing_plane RotateRoll( -5400, 10, 3, 1);
			fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_wing_left_fx");
			
			left_wing MoveGravity(AnglesToForward(left_wing.angles) * (self getspeed() * .5), 5);
			left_wing RotateRoll( -5400, 10, 3, 1);
			left_wing RotatePitch( -5400, 10, 0.1, 1);
			
			wait(2);
			fx Delete();
			PlayFXOnTag(level._effect["zero_explode"], crashing_plane, "tag_wing_left_fx");
			//fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_explode"], "tag_wing_left_fx");
		break;
		
		case "tail":
			//-- tail breaks off and the plane crashes
			crashing_plane SetModel("vehicle_jap_airplane_zero_minus_tail");
			crashing_plane.angles = self.angles;
			
			//-- prop stuff
			self notify("hide_prop");
			crashing_plane thread zero_spin_prop();
			
			if(IsDefined(self.intermediate_damage))
			{
				self.intermediate_damage Unlink();
				self.intermediate_damage LinkTo(crashing_plane);
			}		
			
			crashing_plane MoveGravity(AnglesToForward(self.angles) * self getspeed(), 5);
			crashing_plane RotateRoll( 5400, 10, 3, 1);
			fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_wing_dmg1"], "tag_tail_fx");
			wait(2);
			fx Delete();
			//fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_explode"], "tag_tail_fx");
			PlayFXOnTag(level._effect["zero_explod"], crashing_plane, "tag_tail_fx");
		break;
	
		case "delayed": 
			//-- this one can simulate pilot death
			crashing_plane SetModel("vehicle_jap_airplane_zero_fly");
			crashing_plane.angles = self.angles;
			crashing_plane MoveGravity(AnglesToForward(self.angles) * self getspeed(), 5);
			
			//-- prop stuff
			self notify("hide_prop");
			crashing_plane thread zero_spin_prop();
			
			if(IsDefined(self.intermediate_damage))
			{
				self.intermediate_damage Unlink();
				self.intermediate_damage LinkTo(crashing_plane);
			}		
			
			random_delay = RandomFloatRange(1, 2);
			wait(random_delay);
			
			roll_direction = RandomInt(2);
			
			if(roll_direction)
			{
				crashing_plane RotateRoll( 5400, 10, 3, 1);
			}
			else
			{
				crashing_plane RotateRoll( -5400, 10, 3, 1);
			}
			
			//fx = crashing_plane thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["zero_explode"], "tag_prop_fx");
			PlayFXOnTag(level._effect["zero_explode"], crashing_plane, "tag_prop_fx");
		break;
		
		case "disintegrate":
			
			crashing_plane SetModel("vehicle_jap_airplane_zero_fly");
			crashing_plane.angles = self.angles;
			PlayFX(level._effect["zero_final_explode"], crashing_plane.origin);
			
			//-- earthquake
			Earthquake(1, .3, crashing_plane.origin, 1000);
			playsoundatposition("amb_metal", (0,0,0));
			if( distancesquared( crashing_plane.origin, level.player.origin ) < 500 * 500 )
			{
				level notify("suggest close hit");
			}
			
			crashing_plane Hide();
			crashing_plane.origin = (crashing_plane.origin[0], crashing_plane.origin[1], -100);
	
		break;
		
			
		default:
			ASSERTEX(false, "Crashing Zeroes");
		break;
	}
	
	if(level.plane_on_curve > 0)
	{
		level.plane_on_curve--;
	}
	
	//--crashing_plane delete();
	level.total_zeros_spawned--;
	
	//-- wait for the plane to go underwater
	while(crashing_plane.origin[2] > -100 )
	{
		wait(0.05);
	}
	
	if(IsDefined(self.attacker))
	{
		if(self.attacker == level.player)
		{	
			level.zero_death_count++;
			level notify("suggest good kill", "zero");
		}
	}
	
	crashing_plane Delete();
	if(IsDefined(self.intermediate_damage))
	{
		self.intermediate_damage Delete();
	}
	
	if(IsDefined(fx))
	{
		fx Delete();
	}
	
	self notify( "crash_done" );
}

zero_death_thread_water_hit(crashing_plane)
{
	self endon( "crash_done" );
	
	while(crashing_plane.origin[2] > 63)
	{
		wait(0.05);
	}
	
	//-- should splash when the plane hits the water!
	PlayFX( level._effect["zero_water"], crashing_plane.origin);
	
	if( distancesquared( crashing_plane.origin, level.player.origin ) < 500 * 500 )
	{
		level.player SetWaterSheeting(1, 2);
		level notify("suggest close hit");
	}
	
	crashing_plane MoveTo(crashing_plane.origin, 0.05);
	crashing_plane RotateTo(crashing_plane.angles, 0.05);
	random_wait = RandomFloatRange(1, 3);
	wait(random_wait);
	crashing_plane MoveTo(crashing_plane.origin - ( 0, 0, 200), 7, 1, 1);
}

merchant_ship_init()
{
	self.script_crashtypeoverride = "none";
	self.vehicletype = "jap_merchant_ship";
}

merchant_ship_death_thread()
{
	self notify("crash_done");
}

#using_animtree ("generic_human");
ptboat_setup_driver()
{
	//-- Japanese Driver - he's a drone!
	pby_ok_to_spawn("drone");
	if(IsDefined(self))
	{
		self.driver = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , self);
		self.driver UseAnimTree(#animtree);
		self.driver.animname = "ptboatdriver";
		self.driver.driver = true;
	
		driver_pos = getstartOrigin( self GetTagOrigin("tag_gunner_turret1"), self GetTagAngles("tag_gunner_turret1"), level.scr_anim["ptboatdriver"]["idle"] );
		driver_ang = getstartAngles( self GetTagOrigin("tag_gunner_turret1"), self GetTagAngles("tag_gunner_turret1"), level.scr_anim["ptboatdriver"]["idle"] );
	
		self.driver.origin = driver_pos - (0,0,48);
		self.driver.angles = driver_ang;
	
		self.driver LinkTo(self);
	
		self.driver maps\_drone::drone_play_anim( level.scr_anim["ptboatdriver"]["idle"] );
	}
}

ptboat_kill_driver()
{
	
	
}

#using_animtree ("vehicles");

merchant_boat_sink_me()
{
	
	level endon( "too late to sink merchant ships" );
	self waittill("i should sink");
	
	//random_wait = RandomIntRange(0, 15);
	//wait(random_wait);
	needed_dmg = self.damage_threshold + 3000;
	current_dmg = 0;
		
	while(1)
	{
		self waittill("damage", amount, attacker);
		
		if(attacker == level.player)
		{
			current_dmg = current_dmg + amount;
			if(current_dmg > needed_dmg)
			{
				break;
			}
		}
	}
	
	self dodamage( 50000, self.origin, level.player, 0);
	
	self notify("stop_firing");
	self notify("stop_aft_track"); //-- stops the after spotlight from tracking
	self notify("stop_bow_track"); //-- stops the bow spotlight from tracking
	
	self.bow UseAnimTree(#animtree);
	self.aft UseAnimTree(#animtree);
	self thread anim_single_solo(self, self.sink_anim);
	self thread anim_single_solo(self.bow, self.sink_anim);
	self thread anim_single_solo(self.aft, self.sink_anim);
	
	// add sound here
	self.kill_sound = Spawn("script_model", self.origin);
	self.kill_sound SetModel("tag_origin");
	self.kill_sound.origin = self.origin + (0,0,400);
	self.kill_sound LinkTo(self);
	self.kill_sound PlaySound("merch_death_blow");
	
	self thread boat_groaning_sounds();
	
	//-- bow piece (0), aft piece (0) (swap the pieces)
	self.bow DoDamage(25000, self.origin, level.player, 0);
	self.aft Dodamage(25000, self.origin, level.player, 0);
	
	
	wake_tag = self GetTagOrigin("tag_wake_fx");
	/*
	if(IsDefined(self.special_sink_fx))
	{
		PlayFXOnTag(level._effect["merchant_final"], self, "contower02");
		PlayFX(level._effect["merchant_sink_brkup"], (self.origin[0], self.origin[1], level.WATER_LEVEL + 2), AnglesToUp(self.angles), AnglesToForward(self.angles));
		wait(0.5);
		PlayFX(level._effect["merchant_sink_fire"], (self.origin[0], self.origin[1], level.WATER_LEVEL + 2), AnglesToUp(self.angles), AnglesToForward(self.angles));
		self thread spawn_secondary_fire_fx();
	}
	else
	{
	*/
		PlayFX(level._effect["merchant_sink"], (self.origin[0], self.origin[1], level.WATER_LEVEL + 2), AnglesToUp(self.angles), AnglesToForward(self.angles));
		PlayFXOnTag(level._effect["merchant_final"], self, "contower02");
		PhysicsExplosionSphere( (self.origin + (0,0,400)), 2700, 2600, 40 );
	/*
	}
	*/
	
	//-- For Destruction Counter
	level.merchant_ship_death_count++;
	
	wait(1.0);
	if(self.scriptname == "boat_0")
	{
		level notify("merchant one sound off");
	}
	else if(self.scriptname == "boat_2")
	{
		level notify("merchant three sound off");
	}
	self.wake Delete();
}

boat_groaning_sounds()
{
	self endon("death");
	self endon( self.sink_anim );
	
	random_wait = 0;
	while(IsDefined(self))
	{
		PlaySoundAtPosition( "merch_death_groans", self.origin + (0,0,750) );
		random_wait = RandomIntRange(3, 4);
		wait(random_wait);
	}
}

spawn_secondary_fire_fx()
{
	level waittill("play_2nd_fx");
	PlayFX(level._effect["merchant_sink_fire_2"], (self.origin[0], self.origin[1], level.WATER_LEVEL + 2), AnglesToUp(self.angles), AnglesToForward(self.angles));
}

event4_kamikaze_ship_animation()
{
	//level.scr_anim["fletcher"]["plane_impact"] = %v_fletcher_impact;
	self waittill("reached_end_node"); //self is the kamikaze zero
	
	ship_ent = GetEnt("kamikazed_ship", "targetname");
	ship_ent.animname = "fletcher";
	ship_ent UseAnimTree(#animtree);
	ship_ent anim_single_solo( ship_ent, "plane_impact");
}

pt_boat_init()
{
	
	if(IsDefined(self.im_a_shark))
	{
		self shark_init();
		return;	
	}
	
	// values used in _vehicle
	self.script_crashtypeoverride = "none"; //-- should keep this from running the airplane crash code
	self.script_cheap = true;
	self.nodeathfx = true;
	self endon("death");
	
	//self AddVehicleToCompass();
	
	if(IsDefined(self.shoot_at_drones))
	{
		self thread ai_ptboat_turret_think(self.shoot_at_drones);
	}
	else
	{
		self thread ai_ptboat_turret_think();
	}
	
	self.fake_motion = false;
	self thread ptboat_engine_fx_control();
	
	self UseAnimTree( #animtree );
	self.animname = "pt_boat";
	//self thread anim_loop_solo(self, "idle", "tag_origin", "stop_pt_idling");
	self thread pt_boat_skim_control();
	//self thread anim_loop_solo(self, "ptboat_skim", "tag_origin", "stop_pt_skimming");
		
	self notify( "stop_friendlyfire_shield" ); //-- Stop the built in friendlyfire_shield()
	self thread ptboat_damage_thread();
	self thread ai_ptboat_spotlight_think();
	//self thread ptboat_setup_driver();
	
	//-- SETUP THE WAKE AND ENGINE SOUNDS
	if(IsDefined(level.close_boat_sounds))
	{
		//-- wake sound
		pby_ok_to_spawn("ptboat");
		self.wake_audio = Spawn("script_model", self.origin);
		self.wake_audio SetModel("tag_origin");
		self.wake_audio LinkTo(self, "tag_wake_fx", (0,0,0), (0,0,0));
		self.wake_audio PlayLoopSound("pt_wake");
		
		//-- engine sound
		pby_ok_to_spawn("ptboat");
		self.engine_audio = Spawn("script_model", self.origin);
		self.engine_audio SetModel("tag_origin");
		self.engine_audio LinkTo(self, "tag_engine_left", (0,0,0), (0,0,0));
		self.engine_audio PlayLoopSound("pt_engine");
	}
	
	//-- SETUP THE PORT AND STARBOARD LIGHTS
	
	pby_ok_to_spawn("ptboat");
	if(IsDefined(self))
	{
		self.running_lights = Spawn("script_model", (0,0,0));
		self.running_lights SetModel("tag_origin");
		self.running_lights.origin = self GetTagOrigin("origin_animate_jnt");
		self.running_lights.angles = self GetTagAngles("origin_animate_jnt");
		self.running_lights LinkTo(self);
		PlayFXOnTag(level._effect["pt_running_lights"], self.running_lights, "tag_origin");
	}
}

pt_boat_skim_control()
{
	self endon("death");
	
	current_skim = "blah";
	
	while(1)
	{
		if(self GetSpeedMPH() < 2)
		{
			if(current_skim != "none")
			{
				self notify("stop_pt_skimming");
				self thread anim_loop_solo(self, "idle", "tag_origin", "stop_pt_skimming");
				current_skim = "none";
			}
		}
		else if(self GetSpeedMPH() <= 5)
		{
			if(current_skim != "slow")
			{
				self notify("stop_pt_skimming");
				self thread anim_loop_solo(self, "ptboat_skim", "tag_origin", "stop_pt_skimming");	
				current_skim = "slow";
			}
		}
		else if(self GetSpeedMPH() <= 15)
		{
			if(current_skim != "medium")
			{
				self notify("stop_pt_skimming");
				self thread anim_loop_solo(self, "ptboat_skim4", "tag_origin", "stop_pt_skimming");
				current_skim = "medium";
			}
		}
		else
		{
			if(current_skim != "fast")
			{
				self notify("stop_pt_skimming");
				self thread anim_loop_solo(self, "ptboat_skim5", "tag_origin", "stop_pt_skimming");
				current_skim = "fast";
			}
		}
		
		wait(0.1);
	}
}

ptboat_delete_at_end_of_path()
{
	self endon("death");
	self waittill("reached_end_node");
	
	self.delete_on_death = true;
	self notify("death");
}

ptboat_damage_thread()
{
	self endon( "death" );
	self endon( "destructible_damage_thread_running");
	
	self.healthbuffer = 20000; 
	//self.health += self.healthbuffer;
	self.currenthealth = self.health; 
	
	max_health = self.currenthealth;
	amount = undefined;
	self.damage_state = 0;
	
	while( self.currenthealth > 0 )
	{
		self waittill("damage", amount, attacker);
		
		//if(attacker != level.plane_a)
		if(attacker != level.player)
		{
			self.currenthealth = self.currenthealth - 50;
		}
		else
		{
			self.currenthealth = self.currenthealth - amount;
		}
		
		if(self.damage_state < 1 && self.currenthealth < (max_health * .7))
		{
			self.damage_state = 1;
			self thread ptboat_stage1_damage();
			wait(0.1);
		}
		
		if(self.damage_state < 2 && self.currenthealth < (max_health * .4))
		{
			self.damage_state = 2;
			self thread ptboat_stage2_damage();
			wait(0.1);
		}
		
		self.attacker = attacker;
	}
	
	self notify( "death" );
}

ptboat_destructible_damage_thread()
{
	self endon("death");
	self notify( "destructible_damage_thread_running");
	
	self thread invulnerable_ptboat();
	
	minor_breaks = 0;
	
	while(true)
	{
		self waittill( "broken", recieved_notify );
		
		if(recieved_notify == "minor_break") //there are 2 of these
		{
			if(minor_breaks == 0)
			{
				if(IsDefined(self.starboard_light))
				{
					self.starboard_light Delete();
				}
				
				if(IsDefined(self.port_light))
				{
					self.port_light Delete();
				}
				
				if(IsDefined(self.damagefx))
				{
					self.damagefx Delete();
				}
				//self.damagefx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_damage1"], "tag_churn_fx"); 
			}
			else if(minor_breaks == 1)
			{
				/*
				if(IsDefined(self.spot_light))
				{
					self.spot_light Delete();
				}
				*/
			}
			
			minor_breaks++;	
		}
		else if(recieved_notify == "major_break")
		{
			if(IsDefined(self.damagefx))
			{
				self.damagefx Delete();
			}
			//self.damagefx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_damage2"], "tag_churn_fx"); 
		}
		else if(recieved_notify == "ptboat_dead")
		{
			if(IsDefined(self.damagefx))
			{
				self.damagefx Delete();
			}
			
			self.attacker = level.player;
			self notify("death");
		}
	}
}

invulnerable_ptboat()
{
	self endon("death");
	
	max_health = self.health;
	
	while(true)
	{
		self waittill("damage");
		self.health = max_health;
	}
}

ptboat_stage1_damage()
{
	if(IsDefined(self.damagefx))
	{
		self.damagefx Delete();
	}
	
	self.damagefx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_damage2"], "origin_animate_jnt"); 
}

ptboat_stage2_damage()
{
	self.damagefx Delete();
	self.damagefx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_damage1"], "origin_animate_jnt"); 
}

ptboat_engine_fx_control()
{
	self endon("death");
	
	//-- Make this link to a position at the point of tag_churn_fx, but be attached to tag_origin so that it doesn't roll
	tag_churn_pos = self GetTagOrigin("tag_wake_fx");
	temp_offset = (self.origin - tag_churn_pos) * -1;
	tag_churn_ang = self GetTagAngles("tag_wake_fx");
	temp_angles = tag_churn_ang - self.angles;
	
	
	temp_offset = (temp_offset[0], temp_offset[1], 0);
	
	self.wake_fx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_wake"], "tag_origin", temp_offset, temp_angles);
	
	self.churn_fx = undefined;
	
	while(true)
	{
		while(self GetSpeed() < 12 && !self.fake_motion)
		{
			wait(0.1);
		}
		
		if(IsDefined(self.churn_fx))
			self.churn_fx Delete();
			
		self.churn_fx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_churn"], "tag_churn_fx");
		
		while(self GetSpeed () >= 12 || self.fake_motion)
		{
			wait(0.1);
		}
		
		self.churn_fx Delete();
	}
	
}

ai_ptboat_spotlight_think()
{
	self endon("death");
	
	//random_spot = RandomInt(2);
	//if(random_spot == 0)
	//{
		pby_ok_to_spawn();
		self.spot_light = self maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_light"], "tag_gunner_barrel2");
		self.spot_pos = "gun_1";
	//}
	//else
	//{
		//pby_ok_to_spawn();
		//self.spot_light = self maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["pt_light"], "tag_gunner_barrel3");
		//self.spot_pos = "gun_2";
	//}
	
	while(1)
	{
		if(!IsDefined(self.specific_target))
		{
			if(IsDefined(level.plane_b))
			{
				if(DistanceSquared(self.origin, level.plane_a.origin) < DistanceSquared(self.origin, level.plane_b.origin))
				{
					spot_light_target = level.plane_a;
				}
				else
				{
					spot_light_target = level.plane_b;
				}
			}
			else
			{
				spot_light_target = level.plane_a;
			}
		}
		else
		{
			spot_light_target = self.specific_target;
		}
	
		//if(self.spot_pos == "gun_1")
		//{
			self setgunnertargetent( spot_light_target, (0,0,0), 1);	
		//}
		//else
		//{
			//self setgunnertargetent( spot_light_target, (0,0,0), 2);		
		//}
		
		if(!IsDefined(self.specific_target))
		{
			wait(2);
		}
		else
		{ 
			// better reaction time if the leve script
			// is trying to set certain values
			wait(0.5);
		}
	}
}


ai_ptboat_turret_think(drone_type)
{
	self endon("death");
	
	target = undefined;
	target_aquired = false;
	time = 0;
	max_time = 2;
	wait_time = .12;
	cycle_time = 3;
	
	//-- FOR REFERENCE
	//Pby setgunnertargetvec( (100, 500, 0), whichgun ); // which gun 0-3
	//Pby setgunnertargetent( targetent, targetoffset, whichgun );
	//Pby cleargunnertarget( whichgun );

	while(1)
	{
		self.targetting_drone = false;
		
		if(!IsDefined(self.specific_target) && !IsDefined(drone_type))
		{
			//-- aquire a target that is within distance
			//--- also make sure that there aren't too many PT Boats shooting
			while(!target_aquired || (level.current_pts_shooting >= level.max_pts_shooting))
			{
				if(Distance2D(level.plane_a.origin, self.origin) <= 15000)
				{
					target_aquired = true;
					target = level.plane_a;
				}
	
				if(IsDefined( level.plane_b ))
				{
					if(!target_aquired && Distance2D(level.plane_b.origin, self.origin) <= 10000)
					{
						target_aquired = true;
						target = level.plane_b;
					}
				}
				
				wait(0.1);
			}
		}
		else if(IsDefined(self.specific_target))
		{
			target = self.specific_target;
		}
		else if(IsDefined(drone_type)) //-- Find a drone target
		{
			fight_drones = RandomIntRange(0, 100);
			
			if(fight_drones > 100)
			{
				my_target = -1;
				target_list = GetEntArray("drone", "targetname");	
		
				for(i = 0; i < target_list.size; i++)
				{
					if(target_list[i].team == "allies")
					{
						my_target = i;
						break;
					}		
				}
							
				if(my_target != -1)
				{
					target = target_list[my_target];
					self.targetting_drone = true;
				}
				else
				{
					target = level.plane_a;
				}
			}
			else
			{
				target = level.plane_a;
			}
		}
		
		//-- used for book keeping
		level.current_pts_shooting++;
		self.shooting = true;
		
		//-- fire loop
		new_target_vec = (0,0,0);
		while(Distance2D(self.origin, target.origin) <= 15000)
		{
			//-- we actually want to fire on the player, not just on the pby
			if(target == level.plane_a)
			{
				if(level.player.current_seat == "pby_rightgun")
				{
					new_target_vec = target.origin + ( AnglesToForward(target.angles) * -1 * 148 ) + ( AnglesToUp(target.angles) * 86 );		
				}
				else if(level.player.current_seat == "pby_leftgun")
				{
					new_target_vec = target.origin + ( AnglesToForward(target.angles) * -1 * 148 ) + ( AnglesToUp(target.angles) * 86 );		
				}
				else if(level.player.current_seat == "pby_frontgun")
				{
					new_target_vec = target.origin + ( AnglesToForward(target.angles) * 260 ) + ( AnglesToUp(target.angles) * 78 );		
				}
				else if(level.player.current_seat == "pby_backgun")
				{
					new_target_vec = target.origin + ( AnglesToForward(target.angles) * -1 * 283 ) + ( AnglesToUp(target.angles) * 58 );		
				}
			}
			else
			{
				if(target.animname == "survivor")
				{
					new_target_vec = target GetTagOrigin("tag_eye");
				}
				else
				{
					new_target_vec = target.origin;
				}
			}
			
			if(!flag("ok_to_shoot_at_player")) //-- if you aren't supposed to shoot at the player, then force an offset
			{
				//-- additional random offset
				//random_int_offset = .06 * Distance2d(self.origin, target.origin);
				//random_int_offset = .03 * Distance2d(self.origin, target.origin); //-- it was this for a long time
				random_int_offset = .01 * Distance2d(self.origin, target.origin);
				
				if(!IsDefined(self.specific_target))
				{
					if(random_int_offset < 24)
					{
						random_int_offset = 24;
					}
				}
				
				if(random_int_offset > 120)
				{
					random_int_offset = 120;
				}
				
				new_target_vec = new_target_vec + (RandomFloatRange(random_int_offset * -1, random_int_offset), RandomFloatRange(random_int_offset * -1, random_int_offset), RandomFloatRange(random_int_offset * -1, random_int_offset));
			}
			
			if(!self.targetting_drone)
			{
				new_target_vec = self ai_ptboat_lead_target(target, new_target_vec);
			}
			
			self.target_vector = new_target_vec;
			self setgunnertargetvec( self.target_vector, 0 ) ;
			
			//-- check and see if the turret is vaguely pointed at the target before shooting the gun
			gun_forward = self GetTagAngles("tag_gunner_barrel1");
			gun_forward = AnglesToForward(gun_forward);
			gun_origin = self GetTagOrigin("tag_gunner_barrel1");
			gun_actual_target = gun_origin + (gun_forward * 20);
			
			if(target == level.plane_a)
			{
				player_dir = VectorNormalize(level.player.origin - gun_origin);
			}
			else
			{
				player_dir = VectorNormalize(target.origin - gun_origin);
			}
			
			gun_aim_dir = VectorNormalize(gun_actual_target - gun_origin);
			
			if( VectorDot(player_dir, gun_aim_dir) > .6 )
			{
				self firegunnerweapon( 0 );
			
				wait(wait_time);
				time += wait_time;
				
				if(time > max_time)
				{
					break;
				}
			}
			else
			{
				wait(0.05);
			}
			
			self cleargunnertarget(0);
			target_aquired = false;
			
			if(!IsDefined(target))
			{
				break; //-- target disappeared, probably died
			}
		}
	
		//-- used for book keeping
		level.current_pts_shooting--;
		self.shooting = false;
		
		if(IsDefined(self.cycle_time))
		{
			wait(self.cycle_time);
		}
		else
		{
			wait(cycle_time);
		}
		time = 0;
		
	}
}

ai_ptboat_lead_target(target, targetted_vec)
{
	if(target.classname != "script_vehicle")
	{
		//-- the target isn't a vehicle, so return (could expand this to handle other things besides vehicles
		return targetted_vec;
	}
	
	bullet_max_speed = 10000;
	target_speed = target GetSpeed();
	target_forward = AnglesToForward(target.angles);
	
	distance_to_target = Distance(self GetTagOrigin("tag_gunner_barrel1"), targetted_vec);
	bullet_travel_time = distance_to_target / bullet_max_speed;
	
	bullet_offset_forward = target_forward * bullet_travel_time * target_speed;
	
	end_vec = targetted_vec + bullet_offset_forward;
	
	return end_vec;
}

// CODER_MOD : DSL -  04/14/08
// Moved delete and pause into seperate thread, so that it doesn't
// delay the rest of the deletion process, or run into problems with
// the entity being removed under us from elsewhere.

delete_wake_audio(sound_ent)
{
	if(isdefined(sound_ent))
	{		
		sound_ent StopLoopSound(3.0);
		wait(3);
		sound_ent Delete();
	}
}

pt_boat_death_thread()
{
	
	if(IsDefined(self.shark))
	{
		self.shark Delete();	
	}
	
	//TODO: REMOVE THIS
	self notify( "stop_pt_idling" );
	self.crashing = true;
	self SetCanDamage(false);
	
	if(IsDefined(self.has_engine_sound))
	{
		self StopLoopSound();
	}
	
	if(IsDefined(self.attacker))
	{
		if(self.attacker == level.player)
		{	
			level.ptboat_death_count++;
			level notify("suggest good kill", "ptboat");
		}
	}
	
	if(IsDefined(self.notify_level))
	{
		level notify("ptboat_died");
	}
	
	if(IsDefined(self.shooting))
	{
		if(self.shooting == true)
		{
			level.current_pts_shooting--;
		}
	}
	
	if(IsDefined(self.wake_fx))
	{
		self.wake_fx Delete();
	}
		
	if(IsDefined(self.churn_fx))
	{
		self.churn_fx Delete();
	}
	
	if(IsDefined(self.spot_light))
	{
		self.spot_light Delete();
	}
	
	if(IsDefined(self.running_lights))
	{
		self.running_lights Delete();
	}
	
	/*
	if(IsDefined(self.port_light))
	{
		self.port_light Delete();
	}
	
	if(IsDefined(self.starboard_light))
	{
		self.starboard_light Delete();
	}
	*/
	
	if(!isdefined(self.delete_on_death))
	{
		if(!IsDefined(self.destructible_def))
		{
			PlayFxOnTag(level._effect["pt_damage4"], self, "tag_origin");
			
			random_death = RandomIntRange(1, 8);
		
			if(IsDefined(self.driver))
			{
				self.driver UnLink();
			}
			
			radiusdamage(self.origin, 150, 1000, 1001);
			death_anim = "sink" + random_death;
			self SetSpeed(0, 10, 10);
						
			if(IsDefined(self.engine_audio))
			{
				self.engine_audio StopLoopSound();
				self.engine_audio Delete();
			}
		
			if(IsDefined(self.wake_audio))
			{
				thread delete_wake_audio(self.wake_audio);
			}
			
			//-- make the ptboat move with the flow
			
			self.sinking_boat = Spawn("script_model", self.origin);
			self.sinking_boat SetModel("vehicle_jap_ship_ptboat_dmg");
			self.sinking_boat.origin = self.origin;
			self.sinking_boat.angles = self GetTagAngles("origin_animate_jnt");
			self.sinking_boat.animname = "pt_boat";
			self.sinking_boat UseAnimTree( #animtree );
			
			self.sinking_boat.linked_ent = Spawn("script_model", self.origin);
			self.sinking_boat.linked_ent SetModel("tag_origin");
			self.sinking_boat.linked_ent.angles = self.sinking_boat.angles;
			
			self.sinking_boat LinkTo(self.sinking_boat.linked_ent);
			
			self Hide();
			
			self.sinking_boat thread anim_single_solo(self.sinking_boat, death_anim);
			self.sinking_boat.sinking_fx = self.sinking_boat thread maps\pby_fly_fx:: play_looping_fx_on_tag(level._effect["pt_sink"], "tag_origin", undefined, (-90 , 0, 0));
			self.sinking_boat.linked_ent thread debris_float_away();
			
			self.sinking_boat waittill(death_anim);
			
			self.sinking_boat.linked_ent Delete();
		}
		else
		{
			random_death = RandomIntRange(1, 8);
		
			if(IsDefined(self.driver))
			{
				self.driver UnLink();
			}
			radiusdamage(self.origin, 150, 1000, 1001);
			death_anim = "sink" + random_death;
			self SetSpeed(0, 10, 10);
			
			my_anim_time = GetAnimLength( level.scr_anim["pt_boat"][ death_anim ] );
			self thread anim_single_solo(self, death_anim);
			self.sinking_fx = self thread maps\pby_fly_fx:: play_looping_fx_on_tag(level._effect["pt_sink"], "tag_origin", undefined, (-90 , 0, 0));
			
			if(IsDefined(self.engine_audio))
			{
				self.engine_audio StopLoopSound();
				self.engine_audio Delete();
			}
		
			if(IsDefined(self.wake_audio))
			{
				thread delete_wake_audio(self.wake_audio);
			}
			
			
			//self waittill(death_anim);		
			wait( my_anim_time );
		}
	}
	else
	{
		if(IsDefined(self.engine_audio))
		{
			self.engine_audio StopLoopSound();
			self.engine_audio Delete();
		}
	
		if(IsDefined(self.wake_audio))
		{
			self.wake_audio StopLoopSound();
			self.wake_audio Delete();
		}
	}
	
	if(IsDefined(self.engine_audio))
	{
		self.engine_audio StopLoopSound();
		self.engine_audio Delete();
	}
	
	if(IsDefined(self.wake_audio))
	{
		thread delete_wake_audio(self.wake_audio);
	}
	
	if(IsDefined(self.damagefx))
	{
		self.damagefx Delete();
	}
	
	if(IsDefined(self.sinking_boat))
	{
		if(IsDefined(self.sinking_boat.sinking_fx))
		{
			self.sinking_boat.sinking_fx Delete();
		}
	}
	else if(IsDefined(self.sinking_fx))
	{
		self.sinking_fx Delete();
	}
	
	if(IsDefined(self.driver))
	{
		self.driver Delete();
	}
	
	level notify("ptboat destroyed");
	self notify( "crash_done" );
}

shinyo_boat_init()
{
	self.script_crashtypeoverride = "none"; //-- should keep this from running the airplane crash code
	
	self UseAnimTree( #animtree );
	self.animname = "shinyou";
	
	self thread self_destruct_shinyou();
	self thread shinyo_engine_fx_control();
	
	//-- spotlight -- currently setup like a headlight
	self.spot_light = Spawn("script_model", (0,0,0));
	self.spot_light SetModel("tag_origin");
	self.spot_light.origin = self.origin + (AnglesToForward(self.angles) * 100) + (AnglesToUp(self.angles) * 20);
	self.spot_light.angles = AnglesToForward(self.angles);
	self.spot_light LinkTo(self, "tag_origin");
	PlayFXOnTag( level._effect["pt_light"], self.spot_light, "tag_origin" );
}

self_destruct_shinyou()
{
	self endon("death");
	
	self waittill("reached_end_node");
	//self RadiusDamage(self.origin, 700, 100000, 99999);
	self notify("death");
	
}

shinyo_engine_fx_control()
{
	self endon("death");
	
	self.wake_fx = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["shinyou_wake"], "tag_wake_fx");
	self.churn_fx = undefined;
}

shinyo_boat_death_thread()
{
	self.crashing = true;
	
	self SetCanDamage(false);
	self SetSpeed(0, 5, 5);
	//playfx(level._effect["shinyou_water_flareup"], self.origin);
	PlayFX( level._effect["zero_kamikaze"], self.origin );
	
	if(IsDefined(self.wake_fx))
	{
		self.wake_fx Delete();
	}
	
	if(IsDefined(self.churn_fx))
	{
		self.churn_fx Delete();
	}
	
	if(!isdefined(self.delete_on_death))
	{
		self SetSpeed(0, 10, 10);
		self thread anim_single_solo(self, "sink");
		self waittill("sink");
	}
	
	self.spot_light Delete();

	
	self notify("crash_done");
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println("Player connected to game.");
		
		//-- init the players plane and a bunch of other stuff
		//player.my_plane = pick_proper_plane(player);
		//player.my_plane = get_pby_by_player(player);
		player.my_plane = level.plane_a;
		//player thread turret_switch_watch();
		//player setup_seat_control();
		//player set_pilots_suggested_seat("pby_frontgun", "pby_leftgun");
		//player thread move_to_pilots_suggested_seat();
		//player thread move_to_required_seat();
		player DisableTurretDismount();
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println("Player disconnected from the game.");
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		// put any calls here that you want to happen when the player spawns
		// this will happen every time the player spawns
		println("Player spawned in to game at " + self.origin);
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");

		// put any calls here that you want to happen when the player gets killed
		println("Player killed at " + self.origin);
		
	}
}	

//----------------------------------------------------------------------------------------------------------
//
//
//
// 																		DEBUG FUNCTIONS
//
//
//
//----------------------------------------------------------------------------------------------------------

jumpto_event2_media()
{
	//-- Move the player out of the way
	move_ev4(false);
	
	//-- Start Plane A flying
	new_starting_node = GetVehicleNode("auto740", "targetname");
	level.plane_a AttachPath(new_starting_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_a StartPath();
	level.plane_a thread pby_veh_idle("fly_up_open", 0.1);
		
	//-- Start Plane B flying
	new_starting_node = GetVehicleNode("auto1005", "targetname");
	level.plane_b AttachPath(new_starting_node);
	level.plane_b thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_b StartPath();
	level.plane_b thread pby_veh_idle("fly_up_open", 0.1);
	
	level.player scripted_turret_switch("pby_rightgun", false, 1);
	level thread event2_strafe_boats_m();
	level thread event2_boat_fx();	
	wait(1.0);
	level notify("move to front for intro");
	level notify("start_fade_in");
	level notify("light up and alarm");
	level.plane_a notify("flak_rumble_start");
	level.plane_b notify("taking_first_shots");
	level.plane_a notify("boat_1_running_drones_aft");
	level.plane_a notify("merchant_drone_light");
	level.plane_a notify("event2_boat_3_drone_con");
}

jumpto_event2_strafe_boats()
{
	flag_set("jumpto_used");
	move_ev4(false); //move event4 ships
	
	//-- Start Plane A flying
	new_starting_node = GetVehicleNode("boat_strafing_node", "targetname");
	level.plane_a AttachPath(new_starting_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_a StartPath();
		
	//-- Start Plane B flying
	new_starting_node = GetVehicleNode("boat_strafing_node_b", "targetname");
	level.plane_b AttachPath(new_starting_node);
	level.plane_b thread maps\_vehicle::vehicle_paths(new_starting_node);
	level.plane_b StartPath();
		
	level.player scripted_turret_switch("pby_rightgun");
	level.player.open_hatch = true;
	level.player scripted_turret_switch("pby_backgun");
	
	level thread event2_strafe_boats();
}

jumpto_event3()
{
	flag_set("jumpto_used");
	my_level_init();
	wait(1);

	//TUEY Set music state to Merch Done so it works when jumping.
	setmusicstate ("MERCH_DONE");

	new_start_node = GetVehicleNode("auto767", "targetname");
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	
	new_start_node = GetVehicleNode("auto1031", "targetname");
	level.plane_b AttachPath(new_start_node);
	level.plane_b thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_b StartPath();
	
	wait(1);
	move_ev4(false);
	level notify("start_fade_in");
	level.player thread scripted_turret_switch("pby_leftgun");
		
	level.plane_a notify("start_mist");
	level.plane_b notify("start_mist");
	level event3(true);
	

}

jumpto_event4()
{
	flag_set("jumpto_used");
	my_level_init();
	move_ev2(false);
	
	//level thread disable_manual_switching();
	
	//level notify("instant_sun");
	new_start_node = GetVehicleNode("event4_start_path", "targetname");
	//new_start_node = GetVehicleNode("circling_start_node", "targetname");
	//new_start_node = GetVehicleNode("debug_node_rescue", "targetname");
	
	wait(0.5);
	
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	level.plane_a pby_veh_idle("float", 0);
	//level.plane_a thread maps\pby_fly_fx::zero_cloud();
		
	//new_start_node = GetVehicleNode("event4_start_path_b", "targetname");
	//level.plane_b AttachPath(new_start_node);
	//level.plane_b thread maps\_vehicle::vehicle_paths(new_start_node);
	//level.plane_b StartPath();
	//level.plane_b pby_veh_idle("float", 0);
		
	level.gunner_anim_count = 7;
		
	wait(1);
	level notify("start_fade_in");
	exploder(200);
	level.player scripted_turret_switch("pby_frontgun", false);
	
	//-- debug
	//flag_set("pby_out_of_ammo");
	
	level thread event4(true);
	level thread event4_dialogue();
	level.plane_a notify("start_mist");
}

jumpto_event4_part3()
{
	level.skip_first_rescue = true;
	level.skip_second_rescue = true;
	jumpto_event4();
}

jumpto_initial_zeroes()
{
	move_ev2(false);
	
	new_start_node = GetVehicleNode("auto1338", "targetname");
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	
	new_start_node = GetVehicleNode("auto1369", "targetname");
	level.plane_b AttachPath(new_start_node);
	level.plane_b thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_b StartPath();
	
	wait(1);
	level notify("start_fade_in");
	exploder(200);
	level.player scripted_turret_switch("pby_frontgun", false);
	level.plane_a notify("start_mist");
}

jumpto_event6()
{
	my_level_init();
	move_ev2(false);
	
	new_start_node = GetVehicleNode("auto602", "targetname");
		
	wait(0.5);
	
	level.plane_a AttachPath(new_start_node);
	level.plane_a thread maps\_vehicle::vehicle_paths(new_start_node);
	level.plane_a StartPath();
	level.plane_a pby_veh_idle("float", 0);
			
	wait(1);
	level notify("start_fade_in");
	exploder(200);
	level.player scripted_turret_switch("pby_frontgun", false);
		
	level thread event6();
	level.plane_a notify("start_mist");
	level notify("sun_rise");
	level notify("stop lightning");
}


run_special_debug_functions()
{
	//level thread dbg_training_planes();	
}

dbg_training_planes()
{
	my_trig = GetEnt("debug_training_target", "targetname");
	my_trig waittill("trigger");
	
	wait(1);
	
	plane0 = GetEnt("training_plane_0", "targetname");
	plane1 = GetEnt("training_plane_1", "targetname");
	plane2 = GetEnt("training_plane_2", "targetname");
	
	plane0 thread dbg_plane_taking_damage();
	plane1 thread dbg_plane_taking_damage();
	plane2 thread dbg_plane_taking_damage();
}

dbg_plane_taking_damage()
{
	i = 0;
	
	while(1)
	{
		self waittill("damage", amount);
	
		level.dbg_text_plane_dmg = newHudElem();
		level.dbg_text_plane_dmg.alignX = "center";
		level.dbg_text_plane_dmg.x = 200;
		level.dbg_text_plane_dmg.y = 300;
	
		//level.dbg_text_plane_dmg SetText(self.targetname + " took " + amount + " damage " + i + " times.");
		//iprintlnbold(self.targetname + " took " + amount + " damage " + i + " times.");
		iprintlnbold(self.targetname + " has " + self.health + " remaining ");
	}
}

event2_boat_fx()
{
	level.boats = [];
	for(i = 0; i < 3; i++)
	{
		level.boats[i] = GetEnt("ev2_ship_" + i, "targetname");
	}
	
	for(i = 0; i < level.boats.size; i++)
	{
		//Setup Boat FX
		tag_height = level.boats[i] GetTagOrigin("tag_wake_fx")[2];
		wake_offset = level.WATER_LEVEL - tag_height + 2;
		level.boats[i].wake = level.boats[i] thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["ship_wake"], "tag_wake_fx", (0,0,wake_offset));
		level.boats[i].wake playloopsound("merchant_wake");	
	}
}

event2_debris()
{
	level.plane_a waittill("ev2_debris_turn1");
	
	for(i = 0; i < level.debris_turn_1.size; i++)
	{
		level.debris_turn_1[i] thread debris_float_away();
	}
	
	level.plane_a waittill("ev2_debris_turn3");
	
	level thread delete_all_ms_guys();
	level thread remove_metal_clip();
	
	for(i = 0; i < level.debris_turn_3.size; i++)
	{
		level.debris_turn_3[i] thread debris_float_away();
		if(IsDefined(level.debris_turn_3[i].script_string))
		{
			playfx(level._effect["debris_fire"], level.debris_turn_3[i].origin);
		}
	}
}

remove_metal_clip()
{
	metal_clip = [];
	metal_clip = GetEntArray("boat_metal_coll", "targetname");
	
	for(i=0; i < metal_clip.size; i++)
	{
		metal_clip[i] Delete();
		wait(0.05);
	}
}

event2_debris_cleanup()
{
	level waittill("debris_ready_delete");
	
	wait(6);
	
	for(i = 0; i < level.debris_turn_1.size; i++)
	{
		if(IsDefined(level.debris_turn_1[i]))
		{
			level.debris_turn_1[i] Delete();
		}
	}
	
	for(i = 0; i < level.debris_turn_3.size; i++)
	{
		if(IsDefined(level.debris_turn_3[i]))
		{
			level.debris_turn_3[i] Delete();
		}
	}
}

debris_float_away()
{
	level.plane_a endon("debris_stop");
	level endon("debris_ready_delete");
	self endon("death");
	
	time_to_move = 5;
	current_speed = 600; // or 34mph
	distance_to_move = time_to_move * current_speed;
	total_movement = 0;
	max_movement = 50000;
	y = 0;
	
	self Show();
	while(1)
	{
		current_speed = (level.CURRENT_OCEAN_SPEED / level.MAX_OCEAN_SPEED) * 600;
		distance_to_move = time_to_move * current_speed;
		
		y = RandomIntRange(-30, 30);
		self MoveTo(self.origin - (distance_to_move, y, 0), time_to_move, 0.05, 0.5);
		wait(time_to_move);
		
		total_movement = total_movement + distance_to_move;
		if(total_movement > max_movement)
		{
			break;
		}
	}
	
	self Delete();
}

drones_float_away()
{
	level.plane_a endon("debris_stop");
	level endon("debris_ready_delete");
	self endon("death");
	
	time_to_move = 5;
	current_speed = 600; // or 34mph
	distance_to_move = time_to_move * current_speed;
	total_movement = 0;
	//max_movement = 10000;
	max_movement = 50000;
	//distance_to_move = 1320; //15mph
	y = 0;

	while(1)
	{
		current_speed = (level.CURRENT_OCEAN_SPEED / level.MAX_OCEAN_SPEED) * 600;
		distance_to_move = time_to_move * current_speed;
		
		y = RandomIntRange(-30, 30);
		self MoveTo(self.origin - (distance_to_move, y, 0), time_to_move, 0.05, 0.5);
		wait(time_to_move);
		
		total_movement = total_movement + distance_to_move;
		if(total_movement > max_movement)
		{
			break;
		}
	}
	
	self Delete();
}

music_state_changes() //-- FOR TUEY
{
	
	level.plane_a thread music_notify_continue( "play_general_chatter", "continue_music_state_changes");
	level.plane_a thread music_notify_continue_trigger_pressed( "first_pass_starting", "continue_music_state_changes");
	level waittill("continue_music_state_changes"); //-- PBY: First turn ending, starts back up when player shoots or flak_rumble is reached
	//iprintln("player has attacked");  //-- Within range of first merchant ship and AttackButtonPressed
	
//TUEY SETS music to MERCH_FIRST_PASS
//setmusicstate("MERCH_FIRST_PASS");
		
	level waittill("told to go ventral"); //-- player switches to ventral turret
	//iprintln("music_ventral_change");
				level.player waittill("switching_turret"); //-- started to switch
				//iprintln("switching_turrets");
				level.player waittill("done_switching_turrets"); //-- mounted on gun
				//iprintln("done_switching_turrets");
	
	
	level.plane_a waittill("music_end_first_pass");//-- PBY: end first pass
	//iprintln("music_end_first_pass");
	
	//TUEY SETS music state to ambient during turn
	setmusicstate("TURNING_1");	

	
	level.plane_a thread music_notify_continue( "flak_rumble_start", "continue_music_state_changes");
	level.plane_a thread music_notify_continue_trigger_pressed( "second_pass_starting", "continue_music_state_changes");
	level waittill("continue_music_state_changes"); //-- PBY: First turn ending, starts back up when player shoots or flak_rumble is reached
	//iprintln("starting_second_pass");

	//TUEY SETS music to MERCH_FIRST_PASS
	setmusicstate("MERCH_FIRST_PASS");	
		
	level.plane_a waittill("got_flaked");//-- player gets flacked
	//iprintln("fell over");
	
	
	level waittill("music_to_turret_right"); //-- player switches to right turret / PBY: far away pass
	//iprintln("music_to_turret_right");
				level.player waittill("switching_turret"); //-- started to switch
				//iprintln("switching_turrets");
				level.player waittill("done_switching_turrets"); //-- mounted on gun
		//iprintln("done_switching_turrets");

	//TUEY sets music to 2nd Pass
	setmusicstate("MERCH_SECOND_PASS");




	
	level.plane_a waittill("3rd_pass_pt_boats"); //-- PBY: Right, Left, Right path starts
	//iprintln("3rd_pass_pt_boats");
	
	
	level waittill("music_to_turret_left");//-- player switches to left turret
	//iprintln("music_to_turret_left");
				level.player waittill("switching_turret"); //-- started to switch
				//iprintln("switching_turrets");
				level.player waittill("done_switching_turrets"); //-- mounted on gun
				//iprintln("done_switching_turrets");
	
	
	level waittill("music_to_turret_right"); //-- player switches to the right turret
	//iprintln("music_to_turret_right");
				level.player waittill("switching_turret"); //-- started to switch
				//iprintln("switching_turrets");
				level.player waittill("done_switching_turrets"); //-- mounted on gun
				//iprintln("done_switching_turrets");
				
				
				
	level.plane_a waittill("music_end_second_pass");//-- PBY: End Second Pass
	//iprintln("music_end_second_pass");	
	
	//Tuey setmusicstate 
	setmusicstate("TURNING_1");	

	level waittill("music_to_turret_front");//-- player moves to front turret / PBY: Start Last Pass
	//iprintln("music_to_turret_front");
				level.player waittill("switching_turret");
				//iprintln("switching_turrets");			
				level.player waittill("done_switching_turrets");
				//iprintln("done_switching_turrets");
	
	
	level.plane_a waittill("music_end_third_pass");//-- PBY: End Last Pass, just passing 3rd Boat
	//iprintln("music_end_third_pass");
	
}

music_notify_continue( _wait_string, _end_string)
{
	level endon(_end_string);
	self waittill(_wait_string);
	level notify("continue_music_state_changes");
}

music_notify_continue_trigger_pressed( _wait_string, _end_string)
{
	level endon(_end_string);
	self waittill(_wait_string);
	
	while(!level.player AttackButtonPressed())
	{
		wait(0.05);
	}
	level notify("continue_music_state_changes");
}

event2_manage_the_ocean_water()
{
	//SetDvar("r_watersim_scroll", "0.542375", "0");
	level.MAX_OCEAN_SPEED = 0.54;
	level.MID_OCEAN_SPEED = 0.38;
	level.CURRENT_OCEAN_SPEED = 0;
	
	//-- intially have the speed of the boats going the same as the intial wake fx
	while(level.MAX_OCEAN_SPEED > level.CURRENT_OCEAN_SPEED)
	{
		level.CURRENT_OCEAN_SPEED += 0.01;
		SetDvar("r_watersim_scroll", level.CURRENT_OCEAN_SPEED, "0");	
		wait(0.05);
	}
	
	//-- slow down all the boats at once where they get sunk
	level.plane_a waittill("music_end_second_pass");
	
	//-- This seemed to cause some major lag (TODO: FIX IT)
	/*
	while(level.CURRENT_OCEAN_SPEED >= 0) 
	{
		level.CURRENT_OCEAN_SPEED -= 0.01;
		SetDvar("r_watersim_scroll", level.CURRENT_OCEAN_SPEED, "0");
		wait(0.05);
	}
	*/
	level.CURRENT_OCEAN_SPEED = 0;
	SetDvar("r_watersim_scroll", level.CURRENT_OCEAN_SPEED, "0");
	
}

watch_for_player_shooting( important_string, type )
{
	if( type == "flag" )
	{
		while(!flag(important_string))
		{
			while(!level.player AttackButtonPressed() && !level.player FragButtonPressed())		
			{
				wait(0.05);
			}
			
			if(level.player AttackButtonPressed())
			{
				if(!level.player.in_transition)
				{
					flag_set(important_string);
				}
			}
			
			if(level.player FragButtonPressed())
			{
				if(level.player.current_seat == "pby_frontgun" && !level.player.in_transition)
				{
					flag_set(important_string);
				}
			}
			
			wait(0.05);
		}
	}
	//-- possibly other ways to watch for this same thing
}

event2_strafe_boats()
{
	//-- test for the life raft spawns
	//level thread event2_spawn_rowboat_with_drones( "raft_spawn_test" );
	//level thread event2_spawn_drowners( "japanese_drone_test" );
	//level thread event2_spawn_rowboat_with_drones( "pass_3_boat", "ev2_debris_turn3" );
	level thread event2_manage_the_ocean_water();
	level thread event2_flak_front_of_plane();
	level thread event2_ptboat_1st_pass();
	level thread watch_for_player_shooting( "player_shot_during_event2", "flag" );
	
	level.plane_a thread scripted_flak_and_shake_above_pby();
	
	//-- setup objective
	set_objective("merchant_boats");
	maps\_debug::set_event_printname("Event 2 - Merchantships", false);
	
	//-- new sink anim test
	level.boats[0].sink_anim = "sink_big";
	level.boats[0].special_sink_fx = "merchant_sink_fire";
	
	wait(0.05);
	
	//-- setup proper parent for oil tanks -- this will need to be done per boat
	oil_tanks = [];
	oil_tanks = getentarray ("explodable_oiltank","script_noteworthy");
	for( i = 0; i < oil_tanks.size; i++)
	{
		oil_tanks[i].parent = level.boats[0];
	}
	
	wait(0.05);
	
	//-- dialogue calls based on spline position
	level thread event2_dialogue_splined();
	
	//-- make the 2nd plane shoot
	level.plane_b thread ai_pby_gunners_think();
	
	wait(0.1);
	
	//-- setup the drones on the boats
	level thread event2_setup_first_ship_drones();
	level thread event2_setup_second_ship_drones();
	level thread event2_setup_third_ship_drones();
	
	wait(0.1);
	
	//-- delete the script_model shields
	level thread event2_delete_ship_shields();
	
	wait(0.1);
	
	//-- setup the audio for the siren alarm
	level thread merchant_boat_siren();
	level thread merchant_boat_1_sounds();
	level thread merchant_boat_3_sounds();
	level thread merchant_boat_pa();
	
	wait(0.1);
	//-- huh?		
	wait(0.1);
	
	//-- setup the debris
	level thread event2_debris();
	
	wait(0.25);
	
	for(i = 0; i < level.boats.size; i++)
	{
		
		level.boats[i] thread ms_soldier_triple_25_add_gunners();
		
		//Setup Boat Basics
		level.boats[i].scriptname = "boat_" + i;
		level.boats[i] thread attach_boat_destructibles();
		level.boats[i].animname = "merchant_ship";
		level.boats[i].bow.animname = "merchant_ship";
		level.boats[i].aft.animname = "merchant_ship";
		level.boats[i].alarmed = false;
		level.boats[i] thread merchant_boat_alarm();
		
		//-- sets up the chaining damage for explosions
		level.boats[i] thread setup_merchant_ship_chain_destruction();
		level.boats[i] thread track_spotlight_achievement_helper( "aft_light_pitch" );
		level.boats[i] thread track_spotlight_achievement_helper( "bow_light_pitch" );
				
		//-- Runs the spotlights
		level.boats[i] thread merchant_boat_spots();
		//-- Runs the Flak Cannons
		level.boats[i] thread merchant_boat_trip25();
		//-- Sinks the Boats
		level.boats[i] thread merchant_boat_sink_me();
		level.boats[i] thread merchant_boat_track_damage();
	
		wait(0.1);
	
		if(i == level.boats.size - 1)
		{
			level.boats[i] thread event2_strafe_boats_force_player_play();
		}	
		///#
		//level.boats[i] thread check_and_print_damage(i);
		//#/
	}
	
	level thread event2_dialogue();
	level thread event2_destruction_dialogue();
	level thread event2_seat_control();
	level.player thread event2_falling_animation();
	//level thread event2_pby_engine_control();
	level thread event2_flak_shake();
	level thread event2_sink_all_boats();

	//-- controls the PTBoats during the different passes
	level thread event2_ptboat_2nd_pass();
	level thread event2_ptboat_3rd_pass();
	level thread event2_ptboats_4th_pass();
		
	//-- Start Event 3 (Pacing)
	level.plane_a waittill("start_event_3");
	set_objective("back_to_base");
	
	level thread event3();
}

event2_strafe_boats_force_player_play()
{
	level.plane_a waittill("check_player_playing");
	
	wait(2);
	
	for(i = 0; i < 2; i++)
	{
		if(!flag("player_shot_during_event2"))
		{
			self notify("stop_firing");
			self thread merchant_boat_trip25_track(0, "tag_gunner_barrel1", level.plane_a, "tower_gun_destroyed", true);		
			self thread merchant_boat_trip25_track(1, "tag_gunner_barrel2", level.plane_a, "deck_gun_destroyed", true);		
			
			if(i == 0)
			{
				wait(2.0);
			}
		}
		else
		{
			return;
		}
	}
	
	wait(1);
	PlayFx( level._effect["flak_one_shot"], level.player.origin + (AnglesToForward(level.plane_a.angles) * 50));
	get_players()[0] PlayRumbleOnEntity( "damage_heavy" );
	wait(0.2);
	get_players()[0] DisableInvulnerability();
	wait(0.05);
	get_players()[0] DoDamage( 1000, self.origin, get_players()[0] );
}

merchant_boat_track_damage()
{
	self endon("i should sink");
	
	if(!IsDefined(self.damage_threshold))
	{
		self.damage_threshold = 30000;
	}
	
	while(IsDefined(self) && self.damage_threshold > 0)
	{
		self waittill("damage", amount, attacker);
		
		if(IsPlayer(attacker))
		{
			self.damage_threshold -= amount;
		}
	}
}


check_and_print_damage(ship_number)
{
	my_total_damage = 0;
	
	while(IsDefined(self))
	{
		self waittill("damage", amount, attacker);
		
		if(IsPlayer(attacker))
		{
			my_total_damage += amount;
			println( "Boat " + ship_number + ": has taken: " + my_total_damage + " damage");
		}
	}
}

event2_spawn_drowners( _targetname )
{
	drowning_drones_spawn = [];
	drowning_drones_spawn = GetStructArray( _targetname, "targetname");
	
	//-- Spawn in the drones treading water
	drowning_drones = [];
	for(i=0; i < drowning_drones_spawn.size; i++)
	{
		pby_ok_to_spawn();
		drowning_drones[i] = maps\_drone::drone_scripted_spawn("actor_axis_jap_reg_type99rifle", drowning_drones_spawn[i]);
		drowning_drones[i] thread maps\_drone::drone_tread_water_idle();
		drowning_drones[i].targetname = "drowning_drone";
		drowning_drones[i] thread drones_float_away();
	}
}

event2_spawn_rowboat_with_drones( _targetname, waittill_spawn )
{
	level.plane_a waittill(waittill_spawn); //-- triggered by the plane path
	
	raft_struct = GetStructArray( _targetname, "targetname");
	
	for( i=0; i < raft_struct.size; i++)
	{
		//-- spawn in a script_model: makin_raft_rubber
		pby_ok_to_spawn();
		raft = Spawn("script_model", raft_struct[i].origin);
		raft SetModel("static_peleliu_lifeboat");
		raft.angles = raft_struct[i].angles;
		
		rescueboat_drones_spawn = [];
		rescueboat_drones_spawn = GetStructArray(raft_struct[i].target, "targetname");
		
		rescue_drones = [];
		
		for(i=0; i < rescueboat_drones_spawn.size; i++)
		{
			//pby_ok_to_spawn();
			rescue_drones[i] = maps\_drone::drone_scripted_spawn("actor_axis_jap_reg_type99rifle", rescueboat_drones_spawn[i]);
			rescue_drones[i].targetname = "rescue_raft_drone";
		}
		
		level thread maps\_drone::drone_idle_row_boat( rescue_drones, raft );
		raft thread drones_float_away();
	}
}

event2_cleanup()
{
	//-- delete everything related to the merchant ship event
	for( i=0; i < level.boats.size; i++)
	{
		level.boats[i].bow Delete();
		level.boats[i].aft Delete();
		level.boats[i].glass1 Delete();
		level.boats[i].glass2 Delete();
		level.boats[i].glass3 Delete();
		
		for(j = 0; j < level.boats[i].aft_destructibles.size; j++)
		{
			level.boats[i].aft_destructibles[j] Delete();
		}
		
		for(j = 0; j < level.boats[i].bow_destructibles.size; j++)
		{
			level.boats[i].bow_destructibles[j] Delete();
		}
		
		level.boats[i] Delete();
		
		wait(0.05); //-- spread this out over 5 frames
	}
}

event2_delete_ship_shields()
{
	level.plane_a waittill("delete_ship_shields");
	
	shields = [];
	shields = GetEntArray("con_tower_shield", "targetname");
	
	for(i=0; i < shields.size; i++)
	{
		shields[i] Delete();
	}
}

attach_boat_destructibles()
{
	//use self.scriptname + _dest_aft /  self.scriptname + _dest_bow
	dest_array_aft = GetEntArray(self.scriptname + "_dest_aft", "targetname");
	dest_array_bow = GetEntArray(self.scriptname + "_dest_bow", "targetname");
	
	for( i = 0; i < dest_array_aft.size; i++)
	{
		dest_array_aft[i] LinkTo(self, "aft_break_jnt");
	}
	
	for( i = 0; i < dest_array_bow.size; i++)
	{
		dest_array_bow[i] LinkTo(self, "bow_break_jnt");
	}
}

event2_sink_all_boats()
{
	level.plane_a waittill("boats_start_sinking");
	
	for(i = 0; i < level.boats.size; i++)
	{
		level.boats[i] notify("i should sink");
	}
}

close_hit_dialogue()
{
	level endon("no more close hit dialogue");
	
	ch_dialogue = [];
	ch_dialogue[0] = "booth_that_was_close";
	ch_dialogue[1] = "booth_close_one";
	ch_dialogue[2] = "PBY1_IGD_568A_LAUG";
	ch_dialogue[3] = "PBY1_IGD_569A_LAUG";
	
	i = 0;
	
	for( ; ; )
	{
		level waittill("suggest close hit");
	
		if(!flag( "disable_random_dialogue" ))
		{
			flag_set("disable_random_dialogue");
			if( IsSubStr( ch_dialogue[i], "booth" ) )
			{
				anim_single_solo(level.plane_a.pilot, ch_dialogue[i]);
			}
			else
			{
				play_sound_over_radio( ch_dialogue[i] );
			}
			flag_clear("disable_random_dialogue");
			
			wait(5);
			
			i++;
			if( i >= ch_dialogue.size )
			{
				i = 0;
			}
		}
		else
		{
			wait(1);
		}		
	}
		
}

damage_to_pby_dialogue( damaged_part )
{
	if(self != level.plane_a)
	{
		return;
	}
	
	//-- DAMAGE VO
	damage_dialogue = [];
	
	damage_dialogue["right_wing"][0] 				= "PBY1_IGD_540A_LAUG";
	damage_dialogue["right_wing"][1] 				= "landry_right_wing_damage";
	damage_dialogue["left_wing"][0] 				= "PBY1_IGD_541A_LAUG";
	damage_dialogue["left_wing"][1] 				= "landry_left_wing_damage";
	damage_dialogue["number_one_engine"][0] = "PBY1_IGD_543A_LAUG";
	damage_dialogue["number_one_engine"][1] = "landry_number_one_engine";
	damage_dialogue["number_two_engine"][0] = "PBY1_IGD_542A_LAUG";
	damage_dialogue["number_two_engine"][1] = "landry_number_two_engine";
	damage_dialogue["engine_fire"][0] 			= "PBY1_IGD_544A_LAUG";
	damage_dialogue["engine_fire"][1] 			= "PBY1_IGD_544A_LAUG";
	
	random_line = RandomInt(2);
	damage_line = damage_dialogue[damaged_part][random_line];
	
	while(flag( "disable_random_dialogue" ))
	{
		wait(0.5);
	}
	
	if( IsSubStr( damage_line, "landry" ) )
	{
		anim_single_solo(level.plane_a.radioop, damage_line );
	}
	else
	{
		play_sound_over_radio( damage_line );
	}
}

good_kill_dialogue()
{
	level endon("no more good kill dialogue");
	
	gk_dialogue = [];
	gk_dialogue[0] = "booth_keep_it_up";
	gk_dialogue[1] = "landry_good_job_locke";
	gk_dialogue[2] = "booth_nice_shooting";
	gk_dialogue[3] = "landry_you_got_it";
	gk_dialogue[4] = "PBY1_IGD_304A_LAUG";
	gk_dialogue[5] = "landry_thats_a_hit";
	gk_dialogue[6] = "PBY1_IGD_301A_LAUG";
	gk_dialogue[7] = "landry_dont_stop_now";
	gk_dialogue[8] = "booth_thats_the_way";
	
	pk_dialogue = []; 
	pk_dialogue[0] = "booth_zero_goin_down";
	pk_dialogue[1] = "PBY1_IGD_611A_LAUG";
	pk_dialogue[2] = "booth_you_nailed_that_plane";
	pk_dialogue[3] = "PBY1_IGD_609A_LAUG";
	pk_dialogue[4] = "booth_zero_dash_down";
	pk_dialogue[5] = "PBY1_IGD_610A_LAUG";
	pk_dialogue[6] = "PBY1_IGD_612A_LAUG";
	
	bk_dialogue = [];
	bk_dialogue[0] = "booth_ptboat_sunk";
	bk_dialogue[1] = "PBY1_IGD_603A_LAUG";
	bk_dialogue[2] = "booth_ptboat_disables";
	bk_dialogue[3] = "PBY1_IGD_604A_LAUG";
	bk_dialogue[4] = "booth_ptboat_lots_of_holes";
	bk_dialogue[5] = "PBY1_IGD_605A_LAUG";
			
	i = 0;
	j = 0;
	k = 0;
	
	for( ; ; )
	{
		level waittill("suggest good kill", enemy_type );
		
		if(!IsDefined(enemy_type))
		{
			enemy_type = "generic";
		}
		else
		{
			random_num = RandomIntRange(0, 10);
			if(random_num <= 4)
			{
				enemy_type = "generic";
			}
		}
		
		if(enemy_type == "zero")
		{
			line_to_play = pk_dialogue[j];
			j++;
		}
		else if(enemy_type == "ptboat")
		{
			line_to_play = bk_dialogue[k];
			k++;
		}
		else
		{
			line_to_play = gk_dialogue[i];
			i++;
		}
		
		if(!flag( "disable_random_dialogue" ))
		{
			if( IsSubStr( line_to_play, "booth" ) )
			{
				anim_single_solo(level.plane_a.pilot, line_to_play);
			}
			else if( IsSubStr( line_to_play, "landry" ) )
			{
				anim_single_solo(level.plane_a.radioop, line_to_play);
			}
			else
			{
				play_sound_over_radio( line_to_play );
			}
			
			wait(10);
		}
		else
		{
			wait(1);
		}		
		
		if( i >= gk_dialogue.size )
		{
			i = 0;
		}
		
		if( j >= pk_dialogue.size )
		{
			j = 0;
		}
		
		if( k >= bk_dialogue.size )
		{
			k = 0;
		}
	}
}

event2_destruction_dialogue()
{
	//-- play responses to explosion
	
	destruction_yay = [];
	destruction_yay[0] = "PBY1_IGD_003A_LAUG"; //-- LAUGHLIN: WHOOAAH
	destruction_yay[1] = "PBY1_IGD_004A_LAUG"; //-- LAUGHLIN: You see that shit blow?
	destruction_yay[3] = "PBY1_IGD_005A_LAUG"; //-- LAUGHLIN: Boom
	destruction_yay[4] = "PBY1_IGD_019A_LAUG"; //-- LAUGHLIN: That's a hit!
	destruction_yay[2] = "PBY1_IGD_021A_LAUG"; //-- LAUGHLIN: Boom
	
	for( i = 0; i < destruction_yay.size; i++)
	{
		level waittill("large explosion comment");
		if(!flag("disable_random_dialogue"))
		{
			if(i == 0 || i == 2)
			{
				play_sound_over_radio(destruction_yay[i]);
				i++;
				play_sound_over_radio(destruction_yay[i]);
			}
			else
			{
				play_sound_over_radio(destruction_yay[i]);
			}
			
			wait(30);
		}
		else
		{
			i--;
			wait(1);
		}
	}
}

event2_dialogue()
{
	//-- heading on another pass
	level.plane_a waittill("ev2_debris_turn1");
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_going_in_for_another_run");
	wait(0.15);
	play_sound_over_radio("PBY1_IGD_024A_HARR");
	flag_clear("disable_random_dialogue");
	
	//-- flak starts
	level.plane_a waittill("flak_rumble_start");
	flag_set("disable_random_dialogue");
	//play_sound_over_radio("PBY1_IGD_025A_HARR");
	play_sound_over_radio("PBY1_IGD_043A_LAUG");
	//play_sound_over_radio("PBY1_IGD_027A_HARR");
	level anim_single_solo(level.plane_a.pilot, "booth_taking_evasive_action_hold");
	flag_clear("disable_random_dialogue");
		
	//-- player ok
	//level.plane_a waittill("done falling");
	wait(3);
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_damn_that_was_close");
	anim_single_solo(level.plane_a.pilot, "booth_shit_tell_me_weve_not_lost");
	anim_single_solo(level.plane_a.radioop, "landry_hes_okay");
	play_sound_over_radio("PBY1_IGD_026A_LAUG");
	anim_single_solo(level.plane_a.pilot, "booth_that_must_be_some_important");
	play_sound_over_radio("PBY1_IGD_045A_LAUG");
	play_sound_over_radio("PBY1_IGD_047A_LAUG");
	anim_single_solo(level.plane_a.pilot, "booth_i_hear_you");
	
	//-- PT Boat Stuff
	wait(0.5);
	anim_single_solo(level.plane_a.pilot, "booth_mg_fire_all_around");
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_keep_firing_on_those");
	wait(0.15);
	anim_single_solo(level.plane_a.pilot, "booth_theyre_our_biggest_threat");
	wait(0.15);
	play_sound_over_radio("PBY1_IGD_034A_HARR");
	play_sound_over_radio("PBY1_IGD_035A_HARR");
	wait(0.3);
	anim_single_solo(level.plane_a.pilot, "booth_negative_we_can_do_this");
	flag_clear("disable_random_dialogue");
	
	//-- getting in close	
	level.plane_a waittill("dialogue_notify");
	//play_sound_over_radio("PBY1_MID_019A_GUN2");
	flag_set("disable_random_dialogue");
	level anim_single_solo(level.plane_a.pilot, "booth_taking_her_down_low");
	wait(0.15);
	level anim_single_solo(level.plane_a.pilot, "booth_locke_laughlin_keep_on_them");
	wait(0.15);
	level anim_single_solo(level.plane_a.pilot, "booth_shoot_out_those_damn_spot");
	flag_clear("disable_random_dialogue");
	
	//-- switch to the left
	level waittill("dialogue_turret_left");
	flag_set("disable_random_dialogue");
	level anim_single_solo(level.plane_a.pilot, "booth_japanese_pt_boats");
	level anim_single_solo(level.plane_a.pilot, "booth_9_oclock");
	level anim_single_solo(level.plane_a.pilot, "booth_get_on_left_turret");	
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("lil_shit");
	flag_set("disable_random_dialogue");
	play_sound_over_radio("PBY1_IGD_039A_LAUG");
	flag_clear("disable_random_dialogue");
	
	level.plane_a waittill("pick_your_targets");
	flag_set("disable_random_dialogue");
	level anim_single_solo(level.plane_a.pilot, "booth_pick_your_targets_locke");
	flag_clear("disable_random_dialogue");
	
	
	level.plane_a waittill("still_afloat");
	flag_set("disable_random_dialogue");
	play_sound_over_radio("PBY1_IGD_056A_LAUG");
	flag_clear("disable_random_dialogue");
	
	//-- Last Pass (multiple versions TODO: HOOK THIS UP)
	level.plane_a waittill("front_turret");
	flag_set("disable_random_dialogue");
	level anim_single_solo(level.plane_a.pilot, "booth_ill_take_us_as_close");
	flag_clear("disable_random_dialogue");
	
	//Tuey Set's Music State to Last Pass		
	setmusicstate("MERCH_LAST_PASS");

	//-- Event 2  Evaluation (not in yet)
	level.plane_a waittill("dialogue_notify");
	if( level.merchant_ship_death_count == 3 )
	{
		flag_set("disable_random_dialogue");
		play_sound_over_radio("PBY1_IGD_053A_HARR");
		play_sound_over_radio("PBY1_IGD_054A_LAUG");
		anim_single_solo(level.plane_a.pilot, "booth_good_work_locke_youve_saved");
	}
	else
	{
		//-- this could be bad...
		wait(7);
	}
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_were_done_here");
	anim_single_solo(level.plane_a.pilot, "booth_get_some_altitude");
	play_sound_over_radio("PBY1_IGD_060A_HARR");
	flag_clear("disable_random_dialogue");
	
	/*
	if(true)		// job well done
	{
			level anim_single_solo(level.plane_a.pilot, "event2_a_nicejob");
	//	play_sound_over_radio("PBY1_MID_028A_PLT2");
	//	play_sound_over_radio("PBY1_MID_029A_GUN2");
			level anim_single_solo(level.plane_a.pilot, "event2_a_goodwork");
	}
	else		// or not so well done
	{
	//	play_sound_over_radio("PBY1_MID_031A_GUN2");
	//	play_sound_over_radio("PBY1_MID_032A_GUN2");
			level anim_single_solo(level.plane_a.pilot, "event2_a_didwhatcould");
	}
	*/
	
	level thread delete_all_ms_guys();
		
	level.plane_a notify("start_event_3");
}

event2_dialogue_splined()
{
	level.plane_a thread event2_dialogue_splined_ptboat();
	level.plane_a thread event2_dialogue_splined_general();
}

event2_dialogue_splined_ptboat()
{
	//level.scr_sound["pilot"]["ptboat_0"] = "PBY1_IGD_002A_PLT1";
	line_number = 0;
	while(1)
	{
		self waittill("play_ptboat_chatter");
		line_number = RandomIntRange(0, 3);
		//level anim_single_solo(level.plane_a.pilot, "ptboat_" + line_number);
	}
}

event2_dialogue_splined_general()
{
	//level.scr_sound["pilot"]["gc_merchant_0"]  = "PBY1_IGD_106A_PLT2";
	line_number = 0;
	while(1)
	{
		self waittill("play_general_chatter");
		line_number = RandomIntRange(0, 3);
		//level anim_single_solo(level.plane_a.pilot, "gc_merchant_" + line_number);
	}
}


event2_flak_shake()
{
	level.plane_a endon("got_flaked");
	
	level.plane_a waittill("flak_rumble_start");
	
	rand = 0;
	
	while(true)
	{
		Earthquake(.3, 1.0, level.plane_a.origin, 1000);
		playsoundatposition("amb_metal", (0,0,0));
		//iprintlnbold("SOUND: FLAK EXPLOSION");
		//rand = RandomFloatRange(2.0, 5.0);
		rand = RandomFloatRange(1.0, 2.5);
		
		//-- play the flak effect, a couple of them at a time
		how_many = RandomIntRange(2, 4);
		for(i = 0; i < how_many; i++)
		{
			fx_org = level.plane_a.origin - (AnglesToForward(level.plane_a.angles) * (366 + RandomIntRange(150, 300))) - (AnglesToUp(level.plane_a.angles) * (50 + RandomIntRange(250, 400)) - (AnglesToRight(level.plane_a.angles) * RandomIntRange(-200, 200)) );
			playfx(level._effect["flak_one_shot"], fx_org);
			//Earthquake(1, 0.12, level.plane_a.origin, 1000);
			level notify("tail_bullet_hole");
			wait(0.12);
		}	
		
		level notify("bullet_hole_wait", rand);
		wait(rand);
	}	
}

event2_flak_front_of_plane( guy )
{
	//-- level waittill("flak_front_of_pby");
	//-- play flak in front of the pby and break out the windshield
	fx_org = level.plane_a.origin + (AnglesToForward(level.plane_a.angles) * 320) + (AnglesToRight(level.plane_a.angles) * 38) + (AnglesToUp(level.plane_a.angles) * 146);
	Earthquake(1, .5, level.plane_a.origin, 1000);
	playfx(level._effect["flak_one_shot"], fx_org);
	playsoundatposition("amb_metal", (0,0,0));
	level.plane_a DoDamage(4000, level.plane_a.origin, level.player, 16);
	level.plane_a DoDamage(4000, level.plane_a.origin, level.player, 16);
}

event2_pby_b_1st_pass()
{
	
	//-- this is the first signal for ptboats, but the pby doesn't go until the 2nd	
	level.plane_a waittill("1st_pass_pt_boats");
	
	//-- Pass under A during overhead strafe
	level.plane_a waittill("1st_pass_pt_boats");
	pby_path = GetVehiclenode("pby_b_pass_1", "targetname");
	level.plane_b AttachPath(pby_path);
	level.plane_b thread maps\_vehicle::vehicle_paths(pby_path);
	level.plane_b StartPath();
	level.plane_b ResumeSpeed(1000);
	
	level.plane_b.zoom_by = Spawn("script_model", level.plane_b.origin);
	level.plane_b.zoom_by SetModel("tag_origin");
	level.plane_b.zoom_by LinkTo(level.plane_b, "tag_origin", (0,0,0), (0,0,0));
	flyby_sound = "pby_3p_by_1";
	level.plane_b.zoom_by PlaySound(flyby_sound);
	
	wait(4);
	
	play_sound_over_radio("PBY1_IGD_022A_HARR"); //-- Hey Watch your fire there!
	
	//-- Turn pass A during 1st turn before flak run (injury to plane?)
	level.plane_a waittill("pby_b_pass_2");
	pby_path = GetVehiclenode("pby_b_pass_2", "targetname");
	level.plane_b AttachPath(pby_path);
	level.plane_b thread maps\_vehicle::vehicle_paths(pby_path);
	level.plane_b StartPath();
	level.plane_b ResumeSpeed(1000);
	level.plane_b.zoom_by PlaySound(flyby_sound);
	
	//-- Parallel A after it dodges away from the flak
	level.plane_a waittill("pby_b_pass_2_b");
	pby_path = GetVehiclenode("pby_b_pass_2_b", "targetname");
	level.plane_b AttachPath(pby_path);
	level.plane_b thread maps\_vehicle::vehicle_paths(pby_path);
	level.plane_b StartPath();
	level.plane_b ResumeSpeed(1000);
	
	level.plane_b waittill("flybysound");
	flyby_sound = "pby_3p_by_1";
	level.plane_b.zoom_by PlaySound(flyby_sound);
		
	//-- Flies in front of the players plane during the last pass
	level.plane_a waittill("front_turret");
	pby_path = GetVehiclenode("pby_b_pass_4", "targetname");
	level.plane_b AttachPath(pby_path);
	level.plane_b thread maps\_vehicle::vehicle_paths(pby_path);
	level.plane_b StartPath();
	level.plane_b ResumeSpeed(1000);
	
	level.plane_b.zoom_by Delete();
}

event2_ptboat_1st_pass()
{
	the_ptboat = undefined;
	
	//level.plane_a waittill("1st_pass_pt_boats");
	//level.plane_a waittill("boat_1_running_drones_aft");
	//level.plane_a waittill("spawn_first_pt_boats");
	
	ptboat_paths[0] = GetVehicleNode("first_pass_pt_boat_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("first_pass_pt_boat_2", "targetname");
	the_ptboats = [];
	
	pby_ok_to_spawn("ptboat");		
	the_ptboats[0] = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
	the_ptboats[0].vehicletype = "jap_ptboat";
	maps\_vehicle::vehicle_init(the_ptboats[0]);
	the_ptboats[0] AttachPath(ptboat_paths[0]);
	the_ptboats[0] thread maps\_vehicle::vehicle_paths(ptboat_paths[0]);
	the_ptboats[0] thread ptboat_delete_at_end_of_path();
	the_ptboats[0].fake_motion = true;
	//the_ptboats[0] StartPath();
	//the_ptboats[0] playloopsound("merchant_engines");
	
	pby_ok_to_spawn("ptboat");
	the_ptboats[1] = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
	the_ptboats[1].vehicletype = "jap_ptboat";
	maps\_vehicle::vehicle_init(the_ptboats[1]);
	the_ptboats[1] AttachPath(ptboat_paths[1]);
	the_ptboats[1] thread maps\_vehicle::vehicle_paths(ptboat_paths[1]);
	the_ptboats[1] thread ptboat_delete_at_end_of_path();
	the_ptboats[1].fake_motion = true;
	//the_ptboats[1] StartPath();
	//the_ptboats[1] playloopsound("merchant_engines");
	
	ptboat_paths[2] = GetVehicleNode("first_pass_pt_boat_extra_0", "targetname");
	ptboat_paths[3] = GetVehicleNode("first_pass_pt_boat_extra_1", "targetname");
	ptboat_paths[4] = GetVehicleNode("first_pass_pt_boat_extra_2", "targetname");
	
	for(i = 2; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat( ptboat_paths[i], true, undefined, undefined, undefined);
		the_ptboats[i] StartPath();
	}
	
	level.plane_a waittill("boat_1_running_drones_aft");
	for( i = 0; i < the_ptboats.size; i++ )
	{
		if(IsDefined(the_ptboats[i]))
		{
			the_ptboats[i] StartPath();
			the_ptboats[i] playloopsound("merchant_engines");
			the_ptboats[i].fake_motion = false;
		}
	}
	
	level.plane_a waittill("1st_pass_pt_boats");
	
	ptboat_paths[0] = GetVehicleNode("first_pass_pt_boat_1", "targetname");
	
	pby_ok_to_spawn("ptboat");
	the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
	the_ptboat.vehicletype = "jap_ptboat";
	maps\_vehicle::vehicle_init(the_ptboat);
	the_ptboat AttachPath(ptboat_paths[0]);
	the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[0]);
	the_ptboat thread ptboat_delete_at_end_of_path();
	the_ptboat StartPath();
	
	level.plane_a waittill("extra_pt_boats_turn");
	
	ptboat_paths = [];
	ptboat_paths = GetVehicleNodeArray( "extra_pt_boats_turn", "targetname");
	
	for( i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboats[i] = spawn_and_path_a_ptboat( ptboat_paths[i], true );
		the_ptboats[i] StartPath();
	}
}

event2_ptboat_2nd_pass()
{
	level.plane_a waittill("second_pass_starting");
	ptboat_paths[0] = GetVehicleNode("second_pass_pt_boat_3", "targetname");
	
	the_ptboat = undefined;
	
	the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
	the_ptboat.vehicletype = "jap_ptboat";
	maps\_vehicle::vehicle_init(the_ptboat);
	the_ptboat AttachPath(ptboat_paths[0]);
	the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[0]);
	the_ptboat thread ptboat_delete_at_end_of_path();
	the_ptboat StartPath();
	the_ptboat playloopsound("merchant_engines");
	
	level.plane_a waittill("2nd_pass_pt_boats");
	
	ptboat_paths[0] = GetVehicleNode("second_pass_pt_boat_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("second_pass_pt_boat_1", "targetname");
	ptboat_paths[2] = GetVehicleNode("second_pass_pt_boat_2", "targetname");
	ptboat_paths[3] = GetVehicleNode("second_pass_pt_boat_3", "targetname");
	ptboat_paths[4] = GetVehicleNode("second_pass_pt_boat_4", "targetname");
	ptboat_paths[5] = GetVehicleNode("second_pass_pt_boat_5", "targetname");
	ptboat_paths[6] = GetVehicleNode("second_pass_pt_boat_6", "targetname");
	ptboat_paths[7] = GetVehicleNode("second_pass_pt_boat_7", "targetname");
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		the_ptboat.vehicletype = "jap_ptboat";
		maps\_vehicle::vehicle_init(the_ptboat);
		the_ptboat AttachPath(ptboat_paths[i]);
		the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[i]);
		the_ptboat thread ptboat_delete_at_end_of_path();
		the_ptboat StartPath();
		the_ptboat playloopsound("merchant_engines");
		//the_ptboat.health = 600; //-- because they are hard to hit when banking
		
		wait(0.05);
		
	}

}

event2_ptboat_3rd_pass()
{
	level.plane_a waittill("3rd_pass_pt_boats");
	
	ptboat_paths[0] = GetVehicleNode("third_pass_pt_boat_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("third_pass_pt_boat_1", "targetname");
	//ptboat_paths[2] = GetVehicleNode("second_pass_pt_boat_2", "targetname");
	
	the_ptboat = undefined;
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		the_ptboat.vehicletype = "jap_ptboat";
		maps\_vehicle::vehicle_init(the_ptboat);
		the_ptboat AttachPath(ptboat_paths[i]);
		the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[i]);
		the_ptboat thread ptboat_delete_at_end_of_path();
		the_ptboat StartPath();
		the_ptboat playloopsound("merchant_engines");
		
		wait(0.05);
	}
}

event2_ptboats_4th_pass()
{
	if(true)
	{
		return;
	}
	
	level.plane_a waittill("4th_pass_pt_boats");
	
	ptboat_paths[0] = GetVehicleNode("fourth_pass_pt_boat_0", "targetname");
	ptboat_paths[1] = GetVehicleNode("fourth_pass_pt_boat_1", "targetname");
	//ptboat_paths[2] = GetVehicleNode("second_pass_pt_boat_2", "targetname");
	
	the_ptboat = undefined;
	
	for(i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		the_ptboat.vehicletype = "jap_ptboat";
		maps\_vehicle::vehicle_init(the_ptboat);
		the_ptboat AttachPath(ptboat_paths[i]);
		the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[i]);
		the_ptboat StartPath();
		the_ptboat playloopsound("merchant_engines");
		wait(0.05);
	}
}

event2_seat_control()
{
	//-- moved to event1 since this is part of the intro dialogue
	//level.plane_a waittill("first_pass_starting");
	//player.open_hatch = true;
	//player scripted_turret_switch("pby_backgun", true);
	
	//level.plane_a waittill("right_turret");
	level.plane_a waittill("done falling");
	level.player.fell = true;
	level notify("music_to_turret_right");
	level.player scripted_turret_switch("pby_rightgun", true);
	
	
	level.plane_a waittill("left_turret");
	level notify("music_to_turret_left");
	level notify("dialogue_turret_left");
	level.player scripted_turret_switch("pby_leftgun", true);
	
	
	level.plane_a waittill("right_turret");
	level notify("music_to_turret_right");
	level.player scripted_turret_switch("pby_rightgun", true);
	
	
	//-- lose all sense of speed from the front turret
	level.plane_a waittill("front_turret");
	level notify("music_to_turret_front");
	level.player.flak_moment = true;
	level.player thread scripted_turret_switch("pby_frontgun", true);
	
	level.plane_a waittill("left_turret");
	//MOVE THIS
	level.plane_b notify("stop_shooting");
	level.player thread scripted_turret_switch("pby_leftgun", true);
	level notify("play_2nd_fx");

	//Tuey Set's Music STate to Last Pass		
	setmusicstate("MERCH_DONE");
}

event2_falling_animation()
{
	level.plane_a waittill("flak_rumble_start");
	
	level thread flak_damage_godrays();
	
	level.plane_a waittill("got_flaked");
	
	//Tuey Sets Music state to SECOND PASS
	setmusicstate("FLAK_BURST");
	
	//-- The Actual Flak
	playfxontag(level._effect["pby_flak"], level.plane_a, "tag_origin");
	
	
	//-- Take the player off of the plane
	plane = level.plane_a;
	plane UseBy(self);
	
	//-- plays the animation	
	startorg = getstartOrigin( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "bank_fall" ] );
	startang = getstartAngles( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "bank_fall" ] );
	
	player_hands = spawn_anim_model( "player_hands" );
	player_hands.plane = plane;
	player_hands.direction = "right";
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;

	self playerlinktoabsolute(player_hands, "tag_player" );
		
	//-- play the flak effect
	fx_org = plane.origin - (AnglesToForward(plane.angles) * 366) - (AnglesToUp(plane.angles) * 50);
	playfx(level._effect["flak_one_shot"], fx_org);
	
	self playsound("flak_int_boom");
	self shellshock("pby_flak", 5);
	level.player PlayRumbleOnEntity( "explosion_generic" );
	plane maps\_anim::anim_single_solo( player_hands, "bank_fall" );
		
	plane thread maps\_anim::anim_loop_solo( player_hands, "bank_loop", "origin_animate_jnt", "stop_hand_loop" );
	wait(3); //-- artificial wait to make everything that much more impressive!!
	plane notify("done falling");
	
	self waittill("switching_turret");
	plane notify("stop_hand_loop");
	player_hands notify("stop_hand_loop");
	//self startcameratween( 0.5 );
	player_hands thread delete_later();
	
	wait(5);
	
	level thread turret_ads_reminder();
}

play_sitdown_animation()
{
	level.player DisableWeapons();
	
	//-- Take the player off of the plane
	plane = level.plane_a;
	//plane UseBy(self);
	
	//-- plays the animation	
	startorg = getstartOrigin( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "pby_right_to_end" ] );
	startang = getstartAngles( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "pby_right_to_end" ] );
	
	player_hands = spawn_anim_model( "player_hands" );
	player_hands.plane = plane;
	player_hands.direction = "right";
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	self.origin = player_hands.origin;
	self.angles = player_hands.angles;

	self playerlinktoabsolute(player_hands, "tag_player" );
	
	plane maps\_anim::anim_single_solo( player_hands, "pby_right_to_end" );
	//plane maps\_anim::anim_single_solo( player_hands, "pby_right_to_seat" );
}

flak_damage_godrays()
{
	level thread flak_large_hole();
	
	bullet_holes = [];
	for(i = 1; i < 4; i++)
	{
		bullet_holes[i] = level.plane_a thread spawn_bullet_hole_entity("vehicle_usa_pby_bulletholes0" + i);
	}
			
	level waittill("tail_bullet_hole");
	rand = 0;
	for(i = 1; i < 4; i++)
	{
		for(j = 1; j < 5; j++)
		{
			PlayFX( level._effect["spark"], bullet_holes[i] GetTagOrigin("bullet" + j), AnglesToForward(bullet_holes[i] GetTagAngles("bullet" + j)));
			PlayFXOnTag( level._effect["godray_night"], bullet_holes[i], "bullet" + j );
			wait(0.12);
		}
		
		level waittill("bullet_hole_wait", rand);
		wait(rand);
	}	
}

flak_large_hole()
{
	
	level.plane_a waittill("got_flaked");
	
	//-- break out damaged part of pby
	level.plane_a DoDamage(50000, level.plane_a.origin, level.player, 10);
	
	special_bullet_hole = level.plane_a thread spawn_bullet_hole_entity("vehicle_usa_pby_tailsect_fx01");
	
	PlayFXOnTag( level._effect["bighole_night"], special_bullet_hole, "bullet1");
	PlayFXOnTag( level._effect["bighole_night"], special_bullet_hole, "bullet2");
	PlayFXOnTag( level._effect["godray_night"], special_bullet_hole, "bullet3");
	PlayFXOnTag( level._effect["godray_night"], special_bullet_hole, "bullet4");
}

event2_pby_engine_control()
{
	//level waittill("event1 dialogue2 done");
	//level.plane_a waittill("first_pass_starting");
	level.plane_a waittill("go_silent");
	//iprintlnbold("GOING SILENT - the pby kills its engines");
	level.plane_a thread maps\pby_fly_amb::stop_plane_prop_sounds();
	
	level.plane_a waittill("first_pass_completed");
	//iprintlnbold("ENGINE STARTS BACK UP");
	level.plane_a thread maps\pby_fly_amb::start_plane_prop_sounds();
	
	
	level.plane_a waittill("second_pass_starting");
	//iprintlnbold("GOING SILENT - pby kills its engines");
	level.plane_a thread maps\pby_fly_amb::stop_plane_prop_sounds();
	
	level.plane_a waittill("got_flaked");
	//iprintlnbold("ENGINES ROAR TO LIFE");	
	level.plane_a thread maps\pby_fly_amb::start_plane_prop_sounds();
}

event2_setup_first_ship_drones()
{
	level thread event2_setup_first_ship_drones_flee();
	level thread event2_setup_first_ship_drones_respond_aft();
	level thread event2_setup_first_ship_drones_respond_tower();
	level thread event2_setup_first_ship_drones_respond_bow();
	
	//-- USED TO BE A BUNCH MORE STUFF HERE, BUT I REMOVED IT
}

event2_setup_first_ship_drones_flee()
{
	//-- THESE DRONES SHOULD LOOK LIKE THEY ARE FLEEING
	fleeing_drones_spawn = [];
	for(i = 0; i < 4; i++)
	{
		fleeing_drones_spawn[i] = GetStruct("boat_1_firstshot_flee_drone_" + i, "targetname");
	}
		
	fleeing_drones = [];
	
	for( i=0; i < fleeing_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		fleeing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , fleeing_drones_spawn[i]);
		if(i%3 == 0)
		{
			wait(0.05);
		}
	}
	
	level notify("first ship drones done");
	
	//-- need to come up with better timing for this little scene
	level.plane_b waittill("taking_first_shots");
		
	path = [];	
	path[0] = GetStruct("boat_1_path_flee_first_shot_0", "targetname");
	path[1] = GetStruct("boat_1_path_flee_first_shot_0", "targetname");
	path[2] = GetStruct("boat_1_path_flee_first_shot_1", "targetname");
	path[3] = GetStruct("boat_1_path_flee_first_shot_1", "targetname");
	

	fleeing_drones[0] thread maps\_drone::drone_move_to_ent_and_delete(path[0]);
	fleeing_drones[2] thread maps\_drone::drone_move_to_ent_and_delete(path[2]);
	wait(0.5);
	fleeing_drones[1] thread maps\_drone::drone_move_to_ent_and_delete(path[1]);
	fleeing_drones[3] thread maps\_drone::drone_move_to_ent_and_delete(path[3]);
}

event2_setup_first_ship_drones_respond_aft()
{
	level.plane_a waittill("boat_1_running_drones_aft");
	
	//-- THESE DRONES SHOULD LOOK LIKE THEY ARE RESPONDING
	responding_drones_spawn = [];
	for(i=0; i <  4; i++)
	{
		responding_drones_spawn[i] = GetStruct("boat_1_aft_drone_run_" + i, "targetname");
	}
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
	}
	
	path = [];
	path[0] = GetStruct("boat_1_path_light_0", "targetname");
	path[1] = GetStruct("boat_1_path_flak_0", "targetname");
	path[2] = GetStruct("boat_1_path_light_1", "targetname");
	path[3] = GetStruct("boat_1_path_flak_1", "targetname");
	
	for(i = 0; i < responding_drones.size; i++)
	{
		responding_drones[i] thread maps\_drone::drone_move_to_ent_and_delete(path[i]);
		
		random_wait = RandomFloatRange(0.05, 0.3);
		wait(random_wait);
	}
}

event2_setup_first_ship_drones_respond_tower()
{
	level.plane_a waittill("boat_1_running_drones_aft");
	
	//-- THESE DRONES JUST STAND THERE AND SHOOT
	standing_drones_spawn = [];
	standing_drones_spawn = GetStructArray("boat_1_con_drone_stand", "targetname");
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , standing_drones_spawn[i]);
		standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
		standing_drones[i].boat = 0;
	}	
	
	//-- THESE DRONES SHOULD LOOK LIKE THEY ARE RESPONDING
	responding_drones_spawn = [];
	for(i=0; i <  2; i++)
	{
		responding_drones_spawn[i] = GetStruct("boat_1_con_drone_run_" + i, "targetname");
	}
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
	}
	
	path = [];
	path[0] = GetStruct("boat_1_path_con_top", "targetname");
	path[1] = GetStruct("boat_1_path_con_bottom", "targetname");
		
	// 2 sets of 2 guys following the path
	for(i = 0; i < 2; i++)
	{
		responding_drones[0] thread maps\_drone::drone_move_to_ent_and_delete(path[0]);
		random_wait = RandomFloatRange(0.05, 0.3);
		wait(random_wait);
		
		responding_drones[1] thread maps\_drone::drone_move_to_ent_and_delete(path[1]);
		random_wait = RandomFloatRange(0.2, 0.4);
		wait(random_wait);
	}
	
	// Sets of guys that run across and fire at the other plane
	responding_drones_spawn = [];
	responding_drones_spawn[0] = GetStruct("boat_1_con_drone_across_0", "targetname");
	responding_drones_spawn[1] = GetStruct("boat_1_con_drone_across_1", "targetname");
	responding_drones_spawn[2] = GetStruct("boat_1_con_drone_across_2", "targetname");
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
	}
	
	path[0] = GetStruct("boat_1_path_con_across_0", "targetname");
	path[1] = GetStruct("boat_1_path_con_across_1", "targetname");
	path[2] = GetStruct("boat_1_path_con_across_2", "targetname");

	for(i = 0; i < responding_drones.size; i++)
	{
		responding_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path[i], level.plane_b);
		responding_drones[i].boat = 0;
		wait(0.05);
	}
}

event2_setup_first_ship_drones_respond_bow()
{
	//-- Currently there aren't any running drones at the bow.  Just shooting ones.
	standing_drones_spawn = [];
	standing_drones_spawn = GetStructArray("boat_1_bow_drone_stand", "targetname");
	
	wait(0.05);
	
	//-- Spawn in the drones idling
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , standing_drones_spawn[i]);
		standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
		standing_drones[i].boat = 0;
		wait(0.05);
	}	
}

event2_setup_second_ship_drones()
{
	level thread event2_setup_second_ship_drone_turnon_lights();
	level thread event2_setup_second_ship_drones_aft();
	level thread event2_setup_second_ship_drones_con();
	level thread event2_setup_second_ship_drones_bow();
	
	standing_drones_spawn = GetStructArray("boat_2_stand_drone", "targetname");
	
	
	level waittill("first ship drones done");
	
	//-- Spawn in the drones idling
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , standing_drones_spawn[i]);
		standing_drones[i].boat = 1;
		if( i%3 == 0 )
		{
			wait(0.05);
		}
	}
	
	level notify("second ship drones done");
	
	//-- The boat will be alerted
	level.boats[1] waittill("damage");
	
	//-- Make the drones shoot at the player in the pby
	for(i=0; i < standing_drones.size; i++)
	{
		if(!IsDefined(standing_drones[i].script_noteworthy))
		{
			standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
		}
		else if(standing_drones[i].script_noteworthy == "target_plane_b")
		{
			standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
		}
	}
}


event2_setup_second_ship_drone_turnon_lights()
{
	//-- THIS DRONE TURNS ON THE LIGHTS AND THE ALARM!! SUCH A SMART DRONE!!
	light_drone_spawn = GetStruct("boat_2_light_drone_run", "targetname");
	light_drone = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", light_drone_spawn);
	light_drone SetCanDamage(false);
	
	level.plane_a waittill("merchant_drone_light");
	wait(2.0);
	
	path = GetStruct("boat_2_path_light_aft", "targetname");	
	
	light_drone thread maps\_drone::drone_move_to_ent_and_delete(path);
	light_drone waittill("goal");
	
	level notify("light up and alarm");
}

event2_setup_second_ship_drones_aft()
{
	level.plane_a waittill("merchant_drone_light");
	wait(3.0);
	
	// Sets of guys that run across and fire at the other plane
	responding_drones_spawn = [];
	responding_drones_spawn[0] = GetStruct("boat_2_drone_aft_across_0", "targetname");
	responding_drones_spawn[1] = GetStruct("boat_2_drone_aft_across_1", "targetname");
	responding_drones_spawn[2] = GetStruct("boat_2_drone_aft_across_2", "targetname");
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
	}
	
	path[0] = GetStruct("boat_2_path_aft_across_0", "targetname");
	path[1] = GetStruct("boat_2_path_aft_across_1", "targetname");
	path[2] = GetStruct("boat_2_path_aft_across_2", "targetname");

	for(i = 0; i < responding_drones.size; i++)
	{
		responding_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path[i], level.plane_a);
		responding_drones[i].boat = 1;
		if(i%3 == 0)
		{
			wait(0.05);
		}
	}
}

event2_setup_second_ship_drones_con()
{
	level.plane_a waittill("merchant_drone_light");
	wait(6.0);
	
	// Sets of guys that run across and fire at the other plane
	responding_drones_spawn = [];
	responding_drones_spawn[0] = GetStruct("boat_2_con_drone_across_0", "targetname");
	responding_drones_spawn[1] = GetStruct("boat_2_con_drone_across_1", "targetname");
	responding_drones_spawn[2] = GetStruct("boat_2_con_drone_across_2", "targetname");
	responding_drones_spawn[3] = GetStruct("boat_2_con_drone_across_3", "targetname");
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
	}
	
	path[0] = GetStruct("boat_2_path_con_across_0", "targetname");
	path[1] = GetStruct("boat_2_path_con_across_1", "targetname");
	path[2] = GetStruct("boat_2_path_con_across_2", "targetname");
	path[3] = GetStruct("boat_2_path_con_across_3", "targetname");

	for(i = 0; i < responding_drones.size; i++)
	{
		responding_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path[i], level.plane_a);
		responding_drones[i].boat = 1;
		wait(0.05);
	}
}

event2_setup_second_ship_drones_bow()
{
	level.plane_a waittill("merchant_drone_light");
	wait(11.0);
	
	// Sets of guys that run across and fire at the other plane
	responding_drones_spawn = [];
	responding_drones_spawn[0] = GetStruct("boat_2_drone_bow_across_0", "targetname");
	responding_drones_spawn[1] = GetStruct("boat_2_drone_bow_across_1", "targetname");
	responding_drones_spawn[2] = GetStruct("boat_2_drone_bow_across_2", "targetname");
	responding_drones_spawn[3] = GetStruct("boat_2_drone_bow_across_3", "targetname");
	
	responding_drones = [];
	for( i=0; i < responding_drones_spawn.size; i++)
	{
		responding_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle", responding_drones_spawn[i]);
		responding_drones[i].boat = 1;
		if(i%3 == 0)
		{
			wait(0.05);
		}
	}
	
	path[0] = GetStruct("boat_2_path_bow_across_0", "targetname");
	path[1] = GetStruct("boat_2_path_bow_across_1", "targetname");
	path[2] = GetStruct("boat_2_path_bow_across_2", "targetname");
	path[3] = GetStruct("boat_2_path_bow_across_3", "targetname");

	for(i = 0; i < responding_drones.size; i++)
	{
		responding_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path[i], level.plane_a);
		wait(0.05);
	}
}

event2_setup_third_ship_drones()
{
	level thread event2_setup_third_ship_drones_con();
	
	standing_drones_spawn = GetStructArray("boat_3_stand_drone", "targetname");
	
	level waittill("second ship drones done");
	
	//-- Spawn in the drones idling
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		pby_ok_to_spawn("drone");
		standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , standing_drones_spawn[i]);
		standing_drones[i].boat = 2;	
		if(i%3 == 0)
		{
			wait(0.05);
		}
	}
		
	//-- The boat will be alerted
	//level.boats[2] waittill("damage");
	
	//-- Make the drones shoot at the player in the pby
	for(i=0; i < standing_drones.size; i++)
	{
		//standing_drones[i] thread maps\_drone::drone_fire_at_target(get_players()[0]);
		standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
	}
}

event2_setup_third_ship_drones_con()
{
	//-- This is a set of drones that shoot and then switch sides to shoot again
	level waittill("second ship drones done");
	
	standing_drones_spawn = [];
	for(i=0; i<5; i++)
	{
		standing_drones_spawn[i] = GetStruct("boat_3_drone_standrun_"+i, "targetname");	
	}
	
	standing_drones = [];
	for(i=0; i < standing_drones_spawn.size; i++)
	{
		standing_drones[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , standing_drones_spawn[i]);
	}
	
	wait(0.05);
	for( i=0; i < standing_drones.size; i++ )
	{
		standing_drones[i].boat = 2;
		standing_drones[i] thread maps\_drone::drone_fire_at_target(level.plane_a);
	}
	
	level.plane_a waittill("event2_boat_3_drone_con");
	
	wait(3.5);
	
	for(i=0; i < standing_drones.size; i++)
	{
		path = GetStruct("boat_3_path_standrun_" + i, "targetname");
		
		if( i <= 1)
		{
			standing_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path, level.plane_b);
		}
		else
		{
			standing_drones[i] thread maps\_drone::drone_move_to_ent_and_fire(path, level.plane_a);
		}
		wait(0.1);
	}
}

merchant_boat_alarm()
{
	self waittill("damage");
	level notify("merchant_boats_alarmed");
	self.alarmed = true;
	//TO DO:  Add alarm sound on boat.
	//self playloopsound ("boat_alarm");
}

merchant_boat_siren()
{
	//level waittill("merchant_boats_alarmed");
	level waittill("light up and alarm");
	level thread maps\pby_fly_amb::start_merchant_ship_siren();
}

merchant_boat_1_sounds()
{
	level waittill("light up and alarm");
		
	level thread maps\pby_fly_amb::start_merchant_ship_klaxon();
		
	thread merchant_boat_1_sounds_off();
}

merchant_boat_1_sounds_off()
{
	level waittill("merchant one sound off");
	level thread maps\pby_fly_amb::stop_merchant_ship_klaxon();
}

merchant_boat_3_sounds()
{
	level waittill("light up and alarm");
	level thread maps\pby_fly_amb::start_merchant_ship_coll();
	
	thread merchant_boat_3_sounds_off();
}

merchant_boat_3_sounds_off()
{
	level waittill("merchant three sound off");
	level thread maps\pby_fly_amb::stop_merchant_ship_coll();
}

merchant_boat_pa()
{
	level.plane_a waittill("pa_go");
	level thread maps\pby_fly_amb::start_merchant_ship_pa();
}

merchant_boat_trip25()
{
	self thread merchant_start_tower_gun();
	self thread merchant_start_deck_gun();
}

merchant_start_tower_gun()
{
	self endon("death");
	self endon("stop_firing");
	self endon("tower_gun_destroyed");
	
	level.plane_a waittill("flak_rumble_start");
	
	if( !IsDefined(self.tower_gun_destroyed) )
	{
		self thread merchant_boat_trip25_track(0, "tag_gunner_barrel1", level.plane_a, "tower_gun_destroyed" ); //-- Tower gun
	}
}

merchant_start_deck_gun()
{
	self endon("death");
	self endon("stop_firing");
	self endon("deck_gun_destroyed");
	
	level.plane_a waittill("flak_rumble_start");
	
	if( !IsDefined(self.deck_gun_destroyed) )
	{
		self thread merchant_boat_trip25_track(1, "tag_gunner_barrel2", undefined, "deck_gun_destroyed"); //-- Deck gun
	}
}

merchant_boat_trip25_track(which_gun, gun_tag, forced_target, alternate_end, fake_fire_player)
{
	self endon("death");
	self endon("stop_firing");
	
	if(IsDefined(alternate_end))
	{
		self endon(alternate_end);
	}
	
	if(IsDefined(fake_fire_player))
	{
		self.target_vector = level.player.origin;
		self setgunnertargetvec( self.target_vector, which_gun ) ;
		
		random_num_shots = RandomIntRange(5, 8);
			
		for( i=0; i < random_num_shots; i++)
		{
			self firegunnerweapon( which_gun );
			wait(0.1);
		}
	
	}
	else
	{
		target = undefined;
		wait_time = 4;

		gun_origin = self GetTagOrigin(gun_tag);
		
		while(1)
		{
			if(!IsDefined(forced_target))
			{
				//-- just shoot at the closest pby
				if(DistanceSquared(gun_origin, level.plane_a.origin) < DistanceSquared(gun_origin, level.plane_b.origin))
				{
					target = level.plane_a;
				}
				else
				{
					target = level.plane_b;
				}
			}
			else
			{
				target = forced_target;
			}
					
			//shoot that target until it is dead
			new_target_vec = target.origin + ( AnglesToForward(target.angles) * -1 * 148 ) + ( AnglesToUp(target.angles) * 86 );
			new_target_vec = self merchant_boat_trip25_lead_target(target, new_target_vec);
		
			//-- Hardcoded height limit
			lower_boundary = 1200;
			if(new_target_vec[2] < lower_boundary)
			{
				random_height_offset = RandomIntRange(200, 600);
				new_target_vec = (new_target_vec[0], new_target_vec[1], (lower_boundary + random_height_offset));
			}
			
			self.target_vector = new_target_vec;
			self setgunnertargetvec( self.target_vector, which_gun ) ;
		
			random_num_shots = RandomIntRange(5, 8);
			
			for( i=0; i < random_num_shots; i++)
			{
				self firegunnerweapon( which_gun );
				wait(0.1);
			}
			
			//random_wait_offset = RandomIntRange(1,5);
			random_wait_offset = RandomFloatRange(2,4);
			wait(wait_time + random_wait_offset);
		}
	}
}

merchant_boat_trip25_lead_target(target, targetted_vec)
{
	if(target.classname != "script_vehicle")
	{
		//-- the target isn't a vehicle, so return (could expand this to handle other things besides vehicles
		return targetted_vec;
	}
	
	bullet_max_speed = 10000;
	target_speed = target GetSpeed();
	target_forward = AnglesToForward(target.angles);
	
	distance_to_target = Distance(self GetTagOrigin("tag_gunner_barrel1"), targetted_vec);
	bullet_travel_time = distance_to_target / bullet_max_speed;
	
	bullet_offset_forward = target_forward * bullet_travel_time * target_speed;
	
	end_vec = targetted_vec + bullet_offset_forward;
	
	return end_vec;
}


merchant_boat_spots()
{
	level waittill("light up and alarm");
	
	//-- CURRENTLY ALL OF THE SPOT LIGHTS ARE GUNS 2 AND 3 (0 and 1 being the 25mm)
	
	if(!IsDefined(self.aft_light_broken))
	{
		self.aft_light = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["merchant_light"], "tag_gunner_barrel3");
		aft_gun_origin = self GetTagOrigin("tag_gunner_barrel3");
		aft_light_target = level.plane_b;
		self setgunnertargetent( aft_light_target, (0,0,0), 2);
		self thread merchant_boat_spots_track(aft_gun_origin, 2, "stop_aft_track", "aft_light_pitch", 1);
	}
	
	if(!IsDefined(self.bow_light_broken))
	{
		self.bow_light = self thread maps\pby_fly_fx::play_looping_fx_on_tag(level._effect["merchant_light"], "tag_gunner_barrel4");
		bow_gun_origin = self GetTagOrigin("tag_gunner_barrel4");
		bow_light_target = level.plane_a;
		self setgunnertargetent( bow_light_target, (0,0,0), 3);
		self thread merchant_boat_spots_track(bow_gun_origin, 3, "stop_bow_track", "bow_light_pitch", 0);
	}
}

merchant_boat_spots_track(spot_origin, gun_index, end_notify, break_notify, aft)
{
	self endon(end_notify);
	self endon("death");
	self thread merchant_boats_spots_break(end_notify, break_notify, aft, gun_index);
		
	while(IsDefined(self))
	{
		//-- update the spotlight to the closest pby every few seconds
		if(DistanceSquared(spot_origin, level.plane_a.origin) < DistanceSquared(spot_origin, level.plane_b.origin))
		{
			light_target = level.plane_a;
		}
		else
		{
			light_target = level.plane_b;
		}
		
		if(IsDefined(self))
		{
			self setgunnertargetent( light_target, (0,0,0), gun_index);
		}
				
		wait(2);
	}
}

track_spotlight_achievement_helper( my_notify )
{
	for( ; ; )
	{
		self waittill( "broken", recieved_notify );
		
		if(recieved_notify == my_notify)
		{
			level notify("a_spotlight_broke");
			
			if("aft_light_pitch" == my_notify)
			{
				self.aft_light_broken = true;
			}
			else if("bow_light_pitch" == my_notify)
			{
				self.bow_light_broken = true;
			}
			
			return;
		}
	}
}

		
merchant_boats_spots_break(end_notify, break_notify, aft, gun_index)
{
	for( ; ; )
	{
		self waittill( "broken", recieved_notify );
		
		if( recieved_notify == break_notify )
		{
			self notify(end_notify);
			
			if(aft)
			{
				self.aft_light Delete();
				self ClearGunnerTarget(gun_index);
			}
			else
			{
				self.bow_light Delete();
				self ClearGunnerTarget(gun_index);
			}
			
			//level notify("a_spotlight_broke");
		}
		
		wait(0.05); //Wait A Frame
	}
}

//-- OBJECTIVES
set_objective(my_obj, ent)
{
	// Scout The Ocean
	if(my_obj == "scout_ocean")
	{
		return;
		//obj_marker = GetEnt("obj_ev1", "targetname");
		//objective_add(1, "active", &"PBY_FLY_OBJ_EV1" );
		//objective_current( 1 );
	}
	// Sink the Boats
	else if (my_obj == "merchant_boats")
	{
		//objective_state (1, "done");
		objective_add( 2, "current" );
		objective_string( 2, &"PBY_FLY_OBJ_EV2", 3 );
		objective_add( 3, "active" );
		objective_string( 3, &"PBY_FLY_OBJ_EV2_PTBOATS", 0 );
		
		level thread update_objective_stats_merchantship_ships( 2, &"PBY_FLY_OBJ_EV2" );
		level thread update_objective_stats_ptboats( 3, &"PBY_FLY_OBJ_EV2_PTBOATS" );
	}
	//Setup the other objectives .. in the proper order and everything
	else if (my_obj == "back_to_base")
	{
		flag_set("merchant_ship_event_done");
		level notify( "too late to sink merchant ships" );
		
		obj_marker = GetEnt("base_obj", "targetname");
		objective_add( 4, "active", &"PBY_FLY_OBJ_EV3" );
		objective_current( 4 );
	}
	else if(my_obj == "respond_to_distress_call")
	{
		obj_marker = GetEnt("fleet_obj", "targetname");
		objective_string( 4, &"PBY_FLY_OBJ_EV3B" );
		objective_add(5, "active" );
		objective_string(5, &"PBY_FLY_OBJ_EV3B_ZEROES", 0);
		
		level thread update_objective_states_zeroes( 5, &"PBY_FLY_OBJ_EV3B_ZEROES" );
	}
	else if(my_obj == "save_sailors")
	{
		flag_set("respond_objective_done");
		objective_state (4, "done");
		obj_marker = GetEnt("fleet_obj", "targetname");
		objective_add( 6, "active");
		objective_string( 6, &"PBY_FLY_OBJ_EV4", 0 );
		objective_current( 6 );
		
		level thread update_objective_states_rescue( 6, &"PBY_FLY_OBJ_EV4" );
	}
	else if(my_obj == "escape")
	{
		obj_marker = GetEnt("fleet_obj", "targetname");
		objective_add( 7, "active", &"PBY_FLY_OBJ_EV5" );
		objective_current( 7 );
		
		flag_wait("the level is done");
		objective_state(7, "done");
	}
}

update_objective_stats_merchantship_ships( obj_num, obj_string )
{
	number_of_ships_sunk = 0;
	
	while(!flag("merchant_ship_event_done"))
	{
		while( number_of_ships_sunk == level.merchant_ship_death_count && !flag("merchant_ship_event_done"))
		{
			wait(0.1);
		}	
		
		if( number_of_ships_sunk != level.merchant_ship_death_count)
		{
			if( level.merchant_ship_death_count % 3 > 0 )
			{
				Objective_String_NoMessage( obj_num, obj_string, ( 3 - level.merchant_ship_death_count) );
				Objective_State( obj_num, "current" );
			}
			else
			{
				Objective_String( obj_num, obj_string, ( 3 - level.merchant_ship_death_count) );
			}
			
			number_of_ships_sunk = level.merchant_ship_death_count;
		}
	}
	
	if( level.merchant_ship_death_count == 3 )
	{
		objective_state(obj_num, "done");
	}
	else
	{
		objective_state(obj_num, "failed");
	}
}

update_objective_stats_ptboats( obj_num, obj_string )
{
	number_of_ptboats_sunk = 0;
	
	while(!flag("the level is done"))
	{
		while(number_of_ptboats_sunk == level.ptboat_death_count && !flag("the level is done"))
		{
			wait(0.1);
		}
		
		if( number_of_ptboats_sunk != level.ptboat_death_count)
		{
			if( level.ptboat_death_count % 5 > 0 )
			{
				Objective_String_NoMessage( obj_num, obj_string, level.ptboat_death_count );
			}
			else
			{
				Objective_String( obj_num, obj_string, level.ptboat_death_count );
			}
			
			number_of_ptboats_sunk = level.ptboat_death_count;
		}
	}
	
	objective_state(obj_num, "done");
}

update_objective_states_zeroes( obj_num, obj_string )
{
	number_of_zeroes_destroyed = 0;
	
	while(!flag("the level is done"))
	{
		while(number_of_zeroes_destroyed == level.zero_death_count && !flag("the level is done"))
		{
			wait(0.1);
		}
		
		if( number_of_zeroes_destroyed != level.zero_death_count)
		{
			if( level.zero_death_count % 5 > 0 )
			{
				Objective_String_NoMessage( obj_num, obj_string, level.zero_death_count );
			}
			else
			{
				Objective_String( obj_num, obj_string, level.zero_death_count );
			}
			
			if(level.zero_death_count == 45)
			{
				level.player maps\_utility::giveachievement_wrapper( "PBY_ACHIEVEMENT_ZEROS");
			}
			
			number_of_zeroes_destroyed = level.zero_death_count;
		}
	}
	
	objective_state(obj_num, "done");
}

update_objective_states_rescue( obj_num, obj_string )
{
	number_of_men_rescued = 0;
	
	while(!flag("the level is done"))
	{
		while(number_of_men_rescued == level.survivor_save_count && !flag("the level is done"))
		{
			wait(0.1);
		}
		
		if( number_of_men_rescued != level.survivor_save_count)
		{
			if( level.survivor_save_count % 3 > 0 )
			{
				Objective_String_NoMessage( obj_num, obj_string, level.survivor_save_count );
			}
			else
			{
				Objective_String( obj_num, obj_string, level.survivor_save_count );
			}
			
			number_of_men_rescued = level.survivor_save_count;
		}
	}
	
	if( level.survivor_save_count >= 3)
	{
		objective_state(obj_num, "done");
	}
	else
	{
		objective_state(obj_num, "failed");
	}
	
}

//introscreen test
/*
pby_custom_introscreen(string1, string2, string3, string4)
{
	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true; 
	level.introblack SetShader( "black", 640, 480 ); 

	// SCRIPTER_MOD
	// MikeD( 3/16/200 ): Freeze all of the players controls
	//	level.player FreezeControls( true ); 
	//freezecontrols_all( true ); 

	// MikeD (11/14/2007): Used for freezing controls on players who connect during the introscreen
	level._introscreen = true;
	
	wait( 0.05 ); 
 
	level.introstring = []; 
	
	//Title of level
	/*
	if( IsDefined( string1 ) )
	{
		maps\_introscreen::introscreen_create_line( string1 ); 
	}
	
	wait( 2 );
	
	//City, Country, Date
	
	if( IsDefined( string2 ) )
	{
		maps\_introscreen::introscreen_create_line( string2 ); 
	}

	if( IsDefined( string3 ) )
	{
		maps\_introscreen::introscreen_create_line( string3 ); 
	}
	
	//Optional Detailed Statement
	
	if( IsDefined( string4 ) )
	{
		wait( 2 ); 
	}
	
	if( IsDefined( string4 ) )
	{
		maps\_introscreen::introscreen_create_line( string4 ); 
	}
	*/
	
	/*
	level notify( "finished final intro screen fadein" ); 
	
	//wait( 3 ); 
	level waittill("start_fade_in");
	// Fade out black
	level.introblack FadeOverTime( 1.5 ); 
	level.introblack.alpha = 0; 

	level notify( "starting final intro screen fadeout" ); 
	// Restore player controls part way through the fade in
	freezecontrols_all( false ); 

	//level._introscreen = false;

	level notify( "controls_active" ); // Notify when player controls have been restored

	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 

	flag_set( "introscreen_complete" ); // Notify when complete
}
*/

zero_strafe_defending_boat()
{
	ship = GetEnt("ship_number_2", "targetname");
	
	level endon("stop_zeroes_defending_ship");
		
	plane_splines = [];
	plane_splines[0][0] = GetEnt("event2_fake_spline_right00", "targetname");
	plane_splines[1][0] = GetEnt("event2_fake_spline_right01", "targetname");
	plane_splines[2][0] = GetEnt("event2_fake_spline_right02", "targetname");
	
	for(j = 0; j < plane_splines.size; j++)
	{
		for(i = 1; IsDefined(plane_splines[j][i-1].target); i++)
		{
			plane_splines[j][i] = GetEnt(plane_splines[j][i-1].target, "targetname");
		}
	}

	zero_squad = 0;
	random_spline = 0;
	
	while(true)
	{
		zero_squad = RandomInt(6);
		random_spline = RandomInt(plane_splines.size);
		
		if(zero_squad == 5)
		{
			level thread	zero_squad_fly_fake_spline(plane_splines[random_spline], ship);
		}
		else
		{
			level thread zero_fly_fake_spline(plane_splines[random_spline], ship);
		}
		
		while(level.plane_on_curve > 10)
		{
			wait(0.5);
		}
		
		rand = RandomFloatRange(1.0, 5.0);
		wait(rand);
	}
}

zero_announce_position( my_notify, sound_src_ref , second_snd_ref)
{
	//self endon("death");
	self waittill(my_notify);
	
	if(!flag("disable_random_dialogue"))
	{
		flag_set("disable_random_dialogue");
		if( IsSubStr( sound_src_ref, "booth" ) )
		{
			anim_single_solo(level.plane_a.pilot, sound_src_ref);
		}
		else
		{
			play_sound_over_radio( level.scr_sound["laughlin"][sound_src_ref] );
		}
		
		flag_clear("disable_random_dialogue");
	}
}

zero_strafe_sinking_pby()
{
	level thread zero_kamikaze_rescue_3();
	//level endon("rescue_3_done");
	
	plane_splines = [];
	
	plane_splines[0] = GetVehicleNode("ev4_zero_rescue_3_0", "targetname");
	plane_splines[1] = GetVehicleNode("ev4_zero_rescue_3_1", "targetname");
	plane_splines[2] = GetVehicleNode("ev4_zero_rescue_3_2", "targetname");
	
	plane_splines[3] = GetVehicleNode("ev4_zero_rescue_3_3", "targetname");
	plane_splines[4] = GetVehicleNode("ev4_zero_rescue_3_4", "targetname");
	plane_splines[5] = GetVehicleNode("ev4_zero_rescue_3_5", "targetname");
	
	plane_splines[6] = GetVehicleNode("ev4_zero_rescue_3_6", "targetname");
	plane_splines[7] = GetVehicleNode("ev4_zero_rescue_3_7", "targetname");
	plane_splines[8] = GetVehicleNode("ev4_zero_rescue_3_8", "targetname");
	plane_splines[9] = GetVehicleNode("ev4_zero_rescue_3_9", "targetname");
	
	level.plane_a waittill("make_zeroes_earlier");
	
	for(x = 0; x < 2; x++)
	//while(true)
	{
		//-- first set of zeroes that attack
		for(i = 0; i <= 2; i++)
		{
			plane[i] = spawn_and_path_a_zero( plane_splines[i], true, true);	
			//if(x == 1)
			//{
				//if(i == 0)
				//{
					//thread ev4_out_of_ammo_part_2();
				//}
			//}
			//else
			//{
				if( i == 0 )
				{
					plane[i] thread zero_announce_position( "fire_my_turret", "booth_1_oclock");
				}
			//}
			wait(0.05);
		}
		
		level notify("kamikaze_plane_go");
		wait(12); //-- first set almost at the guys (8 initially)
		
		//-- second set of zeros that attack
		for(i = 3; i <= 5; i++)
		{
			plane[i] = spawn_and_path_a_zero( plane_splines[i], true, true);
			
			if(x == 0)
			{
				if( i == 4 )
				{
					thread ev4_out_of_ammo_part_1();
				}
			}
			else
			{
				
				if( i == 4 )
				{
					thread ev4_out_of_ammo_part_2();
				}
				
				/*
				if( i == 4 )
				{
					plane[i] thread zero_announce_position( "fire_my_turret", "booth_12_oclock" );
				}
				else
				{
					plane[i] thread zero_announce_position( "fire_my_turret", "12_oclock" );
				}
				*/
			}
			
			wait(0.05);
		}
		
		level notify("kamikaze_plane_go");
		wait(5);
		
		for(i = 6; i <= 9; i++)
		{
			plane[i] = spawn_and_path_a_zero( plane_splines[i], true, true);	
			if(i == 8)
			{
				plane[i] thread zero_announce_position( "fire_my_turret", "1_oclock" );
			}
			else if( i == 9 )
			{
				
				plane[i] thread zero_announce_position( "announce_position", "booth_weve_got_zeros_coming_in_fast" );
			}
			wait(0.05);
		}
		
		level notify("kamikaze_plane_go");
		wait(10);
	}
	
	level thread ev4_out_of_ammo_part_3();
	wait(7);
	
	level notify("corsairs_arrive");
	
}

ev4_out_of_ammo_part_1()
{
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["shit_ammos_running_low"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["right_50_cals_almost_out"] );
	anim_single_solo(level.plane_a.radioop, "landry_that_aint_good");	
	flag_clear("disable_random_dialogue");
}

ev4_out_of_ammo_part_2()
{
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["dammit_im_out"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["right_turrets_out_of_ammo"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["left_50s_almost_out"] );
	flag_clear("disable_random_dialogue");
}

ev4_out_of_ammo_part_3()
{
	flag_set("disable_random_dialogue");
	play_sound_over_radio( level.scr_sound["laughlin"]["shit_were_out"] );
	play_sound_over_radio( level.scr_sound["laughlin"]["left_turrets_out_of_ammo"] );
	anim_single_solo(level.plane_a.radioop, "landry_booth_we_gotta_get_out");
	anim_single_solo(level.plane_a.pilot, "booth_theres_too_many_zeros");
	anim_single_solo(level.plane_a.pilot, "booth_lets_hope_theres_enough");
	anim_single_solo(level.plane_a.pilot, "booth_locke_make_those_shots_count");
	flag_clear("disable_random_dialogue");
	
	booth_corsair_dialog();
}


booth_corsair_dialog()
{
	flag_set("disable_random_dialogue");
	anim_single_solo(level.plane_a.pilot, "booth_12_oclock");
	flag_set("pby_out_of_ammo");
	wait(0.10);
	anim_single_solo(level.plane_a.pilot, "booth_weve_got_zeros_coming_in_fast");
	flag_clear("disable_random_dialogue");
}


corsairs_arrive()
{
	level waittill("corsairs_arrive");
	
	thread corsairs_chasing_zeros();
	//thread booth_corsair_dialog();
	
	//--- the intial showing of the zeroes
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("zero_corsair_sacrifice_0", "targetname");
	plane_paths[1] = GetVehicleNode("zero_corsair_sacrifice_1", "targetname");
	plane_paths[2] = GetVehicleNode("zero_corsair_sacrifice_2", "targetname");
	
	zeros = [];
	corsairs = [];
	
	for(i = 0; i < plane_paths.size; i++)
	{
		zeros[i] = spawn_and_path_a_zero( plane_paths[i], undefined, true, "shot_down_by_corsair" );
		zeros[i] SetCanDamage(false);
	}
	
	wait(3);
	
	//--- the intial showing of the corsairs
	plane_paths = [];
	plane_paths[0] = GetVehicleNode("corsairs_arrive_0", "targetname");
	plane_paths[1] = GetVehicleNode("corsairs_arrive_1", "targetname");
	plane_paths[2] = GetVehicleNode("corsairs_arrive_2", "targetname");
	plane_paths[3] = GetVehicleNode("corsairs_arrive_3", "targetname");
	plane_paths[4] = GetVehicleNode("corsairs_arrive_4", "targetname");
	plane_paths[5] = GetVehicleNode("corsairs_arrive_5", "targetname");
	plane_paths[6] = GetVehicleNode("corsairs_arrive_6", "targetname");
	plane_paths[7] = GetVehicleNode("corsairs_arrive_7", "targetname");
	plane_paths[8] = GetVehicleNode("corsairs_arrive_8", "targetname");
	
	for(i = 0; i < plane_paths.size; i++)
	{
		if(i <= 2)
		{
			corsairs[i] = spawn_and_path_a_corsair( plane_paths[i] , 2);
		}
		else
		{
			corsairs[i] = spawn_and_path_a_corsair( plane_paths[i] );
		}
		corsairs[i] SetCanDamage(false);
		
		if(i == 2 || i == 5)
		{
			wait(1);
		}
	}
	
	corsairs[0] waittill("corsair_highlight");
	
	wait(0.2);
	SetTimeScale(0.2);

	playsoundatposition("dew", (0,0,0));
	setmusicstate("LEVEL_END");

	wait(1.2);
	SetTimeScale(1);
	
	level notify("pby_player_take_off");
}


corsairs_chasing_zeros()
{
	level waittill( "pby_player_take_off" );
	
	corsairs_chasing_zeros_spawn( "corsair_vs_zero_0", "corsair_vs_zero_0");
	wait(0.5);
	corsairs_chasing_zeros_spawn( "corsair_vs_zero_1", "corsair_vs_zero_1");
	wait(0.5);
	corsairs_chasing_zeros_spawn( "corsair_vs_zero_2", "corsair_vs_zero_2");
	
	level.plane_a waittill( "spawn_corsair_escort" );
	
	corsairs_chasing_zeros_spawn( "corsair_vs_zero_3", "corsair_vs_zero_3");
	wait(0.3);
	corsairs_chasing_zeros_spawn( "corsair_vs_zero_4", "corsair_vs_zero_4");
	
}


corsairs_chasing_zeros_spawn(corsair_path, zero_path)
{
	plane_paths = [];
	plane_paths[0] = GetVehicleNode( zero_path, "targetname" );
	plane_paths[1] = GetVehicleNode( corsair_path, "targetname" );
	
	zero = spawn_and_path_a_zero( plane_paths[0], undefined, true, "shot_down_by_corsair" );
	wait(1.5);
	corsair = spawn_and_path_a_corsair( plane_paths[1] , 1);
}



zero_kamikaze_rescue_3()
{
	kamikaze_plane_splines = [];
	kamikaze_planes = [];
	
	for( x = 0; x < 2; x++ )
	{
		level waittill("kamikaze_plane_go");
			
		kamikaze_plane_splines[0] = GetVehicleNode("rescue3_kamikaze_1", "targetname");
		kamikaze_plane_splines[1] = GetVehicleNode("rescue3_kamikaze_2", "targetname");
		
		exploder_case = 10;
		for(i = 0; i < kamikaze_plane_splines.size; i++)
		{
			kamikaze_planes[i] = spawn_and_path_a_zero( kamikaze_plane_splines[i], true, true, undefined, undefined, true );
			kamikaze_planes[i] thread fletcher_animation( "kamikazed_ship", exploder_case );
			exploder_case++;
		}
		
		level waittill("kamikaze_plane_go");
		
		kamikaze_plane_splines = [];
		kamikaze_plane_splines[0] = GetVehicleNode("rescue3_kamikaze_3", "targetname");
		for( i = 0; i < kamikaze_plane_splines.size; i++ )
		{
			kamikaze_planes[i] = spawn_and_path_a_zero( kamikaze_plane_splines[i], true, true );
			kamikaze_planes[i] thread fletcher_animation( "kamikazed_ship", exploder_case );
			exploder_case++;
		}
		
		level waittill("kamikaze_plane_go");
		
		kamikaze_plane_splines = [];
		kamikaze_plane_splines[0] = GetVehicleNode("rescue3_kamikaze_4", "targetname");
		kamikaze_plane_splines[1] = GetVehicleNode("rescue3_kamikaze_5", "targetname");
		kamikaze_plane_splines[2] = GetVehicleNode("rescue3_kamikaze_6", "targetname");
		
		for( i = 0; i < kamikaze_plane_splines.size; i++ )
		{
			if(i == 0)
			{
				kamikaze_planes[i] = spawn_and_path_a_zero( kamikaze_plane_splines[i], true, true, undefined, undefined, true );
			}
			else
			{
				kamikaze_planes[i] = spawn_and_path_a_zero( kamikaze_plane_splines[i], true, true);
			}
			kamikaze_planes[i] thread fletcher_animation( "kamikazed_ship", exploder_case );
			exploder_case++;
		}
	}
}

zero_strafe_getaway_part_1()
{
	level endon("stop_getaway_zeros_1");
	
	target = level.plane_a;
	
	plane_slines = [];
	
	plane_splines[0][0] = GetEnt("event4_escape_fs_1", "targetname");
	plane_splines[1][0] = GetEnt("event4_escape_fs_2", "targetname");
		
	for(j = 0; j < plane_splines.size; j++)
	{
		for(i = 1; IsDefined(plane_splines[j][i-1].target); i++)
		{
			plane_splines[j][i] = GetEnt(plane_splines[j][i-1].target, "targetname");
		}
	}
	
	random_spline = 0;
	
	while(true)
	{
		random_spline = RandomInt(plane_splines.size);
		level thread zero_fly_fake_spline(plane_splines[random_spline], target);
		
		while(level.plane_on_curve > 15)
		{
			wait(0.5);
		}
		
		rand = RandomFloatRange(3.0, 7.0);
		wait(rand);
	}
}

zero_squad_fly_fake_spline( plane_spline, target )
{
	//-- general squad size is 3
	
	reference_angles = AnglesToRight(plane_spline[0].angles);
	offset_right = 560;
	
	level thread zero_fly_fake_spline(plane_spline, target);
	wait(1);
	level thread zero_fly_fake_spline(plane_spline, target, reference_angles * offset_right);
	wait(1);
	level thread zero_fly_fake_spline(plane_spline, target, reference_angles * (offset_right * -1) );
	
}

zero_fly_fake_spline( plane_spline, target, offset_vector)
{
	if(!IsDefined(offset_vector))
	{
		offset_vector = (0,0,0);
	}
	
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_fly", "new_plane", "zero", plane_spline[0].origin, plane_spline[0].angles );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);	
	
	//shoot guns at target
	plane thread ai_turret_think(target);
	
	level.plane_on_curve++;
	plane setplanegoalpos(plane_spline[1].origin + offset_vector, plane_spline[2].origin + offset_vector, plane_spline[3].origin + offset_vector, plane_spline[4].origin + offset_vector,plane_spline[5].origin + offset_vector, plane_spline[6].origin + offset_vector, 200);
	
	plane waittill("curve_end");
	
	plane.notrealdeath = true;
	plane notify("death");
	level.plane_on_curve--;
}

ptboat_test_run()
{
	test_boat_node = GetVehicleNodeArray("boat_test_node", "targetname");
	
	for(i=0; i < 5; i++)
	{
		path_id = RandomInt(test_boat_node.size);
		test_boat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		test_boat.vehicletype = "jap_ptboat";
		maps\_vehicle::vehicle_init(test_boat);
		
		test_boat AttachPath(test_boat_node[path_id]);
		test_boat thread maps\_vehicle::vehicle_paths(test_boat_node[path_id]);
		test_boat StartPath();
		test_boat SetSpeed(30, 10, 10);	
		
		wait(10);
	}
}

move_ev4(visible)
{
	large_array = GetEntArray("ev4_obj", "script_noteworthy");
	
	for(i=0; i<large_array.size; i++)
	{
		if(visible) //move the event up into view
		{
			if(large_array[i].classname == "script_vehicle")
			{
				large_array[i] Show();
			}
			else
			{
				large_array[i].origin += (0,0,10000);
			}
		}
		else
		{
			if(large_array[i].classname == "script_vehicle")
			{
				large_array[i] Hide();
			}
			else
			{
				large_array[i].origin -= (0,0,10000);
			}
		} 
		
	}
}

move_ev2(visible)
{
	large_array = GetEntArray("ev2_ship", "targetname");
	
	for(i=0; i<large_array.size; i++)
	{
		if(visible) //move the event up into view
		{
			large_array[i].origin += (0,0,10000);
		}
		else
		{
			large_array[i].origin -= (0,0,10000);
		} 
		
	}
}

play_acknowledge_anim(guy)
{
	//iprintlnbold("notetrack: acknowledge");
	
	/*
	level.scr_anim["radio_op"]["my_idle_nav"][0] = %ch_pby_nav_idle;
	level.scr_anim["radio_op"]["my_idle_rad"][0] = %ch_pby_radio_idle;
	
	level.scr_anim["radio_op"]["player_f_nav"] = %ch_pby_nav_playerF;
	level.scr_anim["radio_op"]["player_r_nav"] = %ch_pby_nav_playerR;
	level.scr_anim["radio_op"]["player_f_rad"] = %ch_pby_radio_playerF;
	*/
	
	the_plane = guy.plane;
	
	if(the_plane.radioop.status == "idle_at_nav")
	{
		the_plane notify("stop_radioop_idling");
		
		if(guy.direction == "rear")
		{
			the_plane anim_single_solo(the_plane.radioop, "player_f_nav", "navigator_seat_jnt");
		}
		else
		{
			the_plane anim_single_solo(the_plane.radioop, "player_r_nav", "navigator_seat_jnt");
		}
		
		the_plane thread anim_loop_solo(the_plane.radioop, "my_idle_nav", "navigator_seat_jnt", "stop_radioop_idling");
		the_plane.radioop.status = "idle_at_nav";
		
	}
	else if(the_plane.radioop.status == "idle_at_rad")
	{
		the_plane notify("stop_radioop_idling");
		
		if(guy.direction == "rear")
		{
				the_plane anim_single_solo(guy.plane.radioop, "player_f_rad", "navigator_seat_jnt");
		}
		
		the_plane thread anim_loop_solo(guy.plane.radioop, "my_idle_rad", "navigator_seat_jnt", "stop_radioop_idling");
		the_plane.radioop.status = "idle_at_rad";
	}
}

play_radio_nav_switch(guy)
{
	//iprintlnbold("notetrack: radio_to_nav");
	
	/*
	level.scr_anim["radio_op"]["nav_to_rad"] = %ch_pby_nav_to_radio;
	level.scr_anim["radio_op"]["rad_to_nav"] = %ch_pby_radio_to_nav;
	
	self.radioop.status = "idle_at_nav";
												"idle_at_rad"
	*/
	the_plane = guy.plane;
	
	if(the_plane.radioop.status == "idle_at_rad")
	{
		the_plane notify("stop_radioop_idling");
		
		the_plane.radioop.status = "in_transition";
		the_plane anim_single_solo(the_plane.radioop, "rad_to_nav", "navigator_seat_jnt");
		the_plane thread anim_loop_solo(the_plane.radioop, "my_idle_nav", "navigator_seat_jnt", "stop_radioop_idling");
		the_plane.radioop.status = "idle_at_nav";
	}
	else if(the_plane.radioop.status == "idle_at_nav")
	{
		the_plane notify("stop_radioop_idling");
		
		the_plane.radioop.status = "in_transition";
		the_plane anim_single_solo(the_plane.radioop, "nav_to_rad", "navigator_seat_jnt");
		the_plane thread anim_loop_solo(the_plane.radioop, "my_idle_rad", "navigator_seat_jnt", "stop_radioop_idling");
		the_plane.radioop.status = "idle_at_rad";
	}
}

play_engineer_anim(guy)
{
	/*
	level.scr_anim["engineer"]["cook"]			= %ch_pby_engineer_cook;
	level.scr_anim["engineer"]["player_f"]	= %ch_pby_engineer_playerF;
	level.scr_anim["engineer"]["player_r"] 	= %ch_pby_engineer_PlayerR;
	*/
	the_plane = guy.plane;
	
	if(the_plane.engineer.status == "cooking")
	{
		the_plane notify("stop_engineer_cooking");
		
		if(guy.direction == "rear")
		{
			the_plane anim_single_solo(the_plane.engineer, "player_r", "tag_engineer");
		}
		else
		{
			the_plane anim_single_solo(the_plane.engineer, "player_f", "tag_engineer");
		}
	
		the_plane thread anim_loop_solo(the_plane.engineer, "my_idle", "tag_engineer", "stop_engineer_idling");
		the_plane.engineer.status = "normal_idle";
	}
}

//ENGINEER MOVES HIS LEGS OUT OF THE WAY
play_legs_anim(guy)
{
	/*
	level.scr_anim["engineer"]["legs1"] 		= %ch_pby_engineer_legs1;
	level.scr_anim["engineer"]["legs2"] 		= %ch_pby_engineer_legs2;
	level.scr_anim["engineer"]["legs3"] 		= %ch_pby_engineer_legs3;
	*/
	the_plane = guy.plane;
	
	if(the_plane.engineer.status == "normal_idle")
	{
		the_plane notify("stop_engineer_idling");
	
		anim_to_play = RandomInt(3);
	
		switch(anim_to_play)
		{
			case 1:
				the_plane	anim_single_solo(the_plane.engineer, "legs1", "tag_engineer");
			break;
			
			case 2:
				the_plane	anim_single_solo(the_plane.engineer, "legs2", "tag_engineer");
			break;
			
			case 3:
				the_plane	anim_single_solo(the_plane.engineer, "legs3", "tag_engineer");
			break;
			
			default:
			break;
		}
		
		wait(1);
			
		if(RandomInt(10) > 2)
		{
			the_plane thread anim_loop_solo(the_plane.engineer, "my_idle", "tag_engineer", "stop_engineer_idling");
			the_plane.engineer.status = "normal_idle";
		}
		else
		{
			the_plane thread anim_loop_solo(the_plane.engineer, "cook", "tag_engineer", "stop_engineer_cooking");
			the_plane.engineer.status = "cooking";
		}
	}
}

play_radio_anim(guy)
{
	the_plane = level.plane_a;
	the_plane notify("stop_radioop_idling");
		
	the_plane anim_single_solo(the_plane.radioop, "scripted", "tag_engineer");
	the_plane thread anim_loop_solo(the_plane.radioop, "my_idle_rad", "tag_engineer", "stop_radioop_idling");
	the_plane.radioop.status = "idle_at_rad";
}

play_land_pby()
{
	//level.plane_a waittill("pby_land");
	self waittill("audio_plane_kill_prop");
	
	level notify("stop turbulence"); //-- stop the turbulence because we are now in the water
	
	if(self == level.plane_a)
	{
		self anim_single_solo(self, "pby_landing");
		self thread pby_veh_idle("float", 1.0); //-- this will kill any plane idle animation -- doing this in the transition animation
	}
	else
	{
		self thread pby_veh_idle("float_ai", 1.0); //-- this will kill any plane idle animation -- doing this in the transition animation
	}
}

play_landing_shake( plane )
{
	playfxontag(level._effect["splash_land_wing"], self, "tag_wake_wing_R_fx");
	playfxontag(level._effect["splash_land_wing"], self, "tag_wake_wing_L_fx");
	playfxontag(level._effect["splash_land_center"], self, "tag_origin");
	Earthquake(.1, 2.0, plane.origin, 1000);
	playsoundatposition("amb_metal", (0,0,0));
	
	
	level.player PlayRumbleOnEntity( "explosion_generic" );
	//level.player PlayRumbleLoopOnEntity( "explosion_generic" );
	//wait(0.3);
	//level.player StopRumble( "explosion_generic" );

}

play_landing_shake_only( plane )
{
	Earthquake(.1, 1.0, plane.origin, 1000);
	playsoundatposition("amb_metal", (0,0,0));
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

play_hatch_anim(guy)
{
	the_plane = level.plane_a;
	
	idle_holder = the_plane.current_idle;
	the_plane anim_single_solo(the_plane, "hatch");
	the_plane pby_veh_idle("float", 0);
}

play_chair_distress_anim(guy)
{
	the_plane = level.plane_a;
	
	idle_holder = the_plane.current_idle;
	the_plane anim_single_solo(the_plane, "radio_distress_call");
	the_plane pby_veh_idle("float", 0);
}

play_hatch_anim_open(guy)
{
	the_plane = level.plane_a;
	
	the_plane notify("pby_b_first_shots"); //-- used in the level script to move the 2nd pby
	the_plane notify("hatch_opening");
	
	idle_holder = the_plane.current_idle;
	the_plane anim_single_solo(the_plane, "hatch_open");
	the_plane pby_veh_idle("fly_up_open", 0, true, true);
}

second_pilot_reply_intro(guy)
{
	//play_sound_over_radio( "PBY1_INT_104A_PLT2" );
}

second_gunner_reply_intro(guy)
{
	//play_sound_over_radio( "PBY1_INT_002A_GUN2" );
}

delete_extra_pbys()
{
	del_objects = GetEntArray("pby_delete_me", "targetname");
	
	for(i = del_objects.size; i > 0; i--)
	{
		del_objects[i-1] Delete();
	}
}

play_pontoon_animations()
{
	//level.scr_anim["pby_a"]["pontoons_up"] = %v_pby_pontoon_up;
	//level.scr_anim["pby_a"]["pontoons_down"] = %v_pby_pontoon_down;
	
	while(1)
	{
		level.plane_a anim_single_solo(level.plane_a, "pontoons_down");
		wait(5);
		level.plane_a anim_single_solo(level.plane_a, "pontoons_up");
		wait(5);
	}
}

pby_pontoons_up(up, snap)
{
	if(!IsDefined(self.pontoon_status))
	{
		self.pontoon_status = "up";
	}
	
	if(IsDefined(snap))
	{
		if(up && self.pontoon_status == "down")
		{
			self anim_single_solo(self, "pontoons_snap_up");
			self.pontoon_status = "up";
		}
		else if(!up && self.pontoon_status == "up")
		{
			self anim_single_solo(self, "pontoons_snap_down");
			self.pontoon_status = "down";
		}
	}
	
	if(up && self.pontoon_status == "down")
	{
		self anim_single_solo(self, "pontoons_up");
		self.pontoon_status = "up";
	}
	else if(!up && self.pontoon_status == "up")
	{
		self anim_single_solo(self, "pontoons_down");
		self.pontoon_status = "down";
	}
}

pby_ventral_open(open, snap)
{
	if(!IsDefined(self.ventral_status))
	{
		self.ventral_status = "open";
	}
	
	if(IsDefined(snap))
	{
		if(open && self.ventral_status == "closed")
		{
			self anim_single_solo(self, "ventral_snap_open");
			self.ventral_status = "open";
		}
		else if(!open && self.ventral_status == "open")
		{
			self anim_single_solo(self, "ventral_snap_close");
			self.ventral_status = "closed";
		}	
	}
	
	if(open && self.ventral_status == "closed")
	{
		self anim_single_solo(self, "ventral_open");
		self.ventral_status = "open";
	}
	else if(!open && self.ventral_status == "open")
	{
		self anim_single_solo(self, "ventral_close");
		self.ventral_status = "closed";
	}	
}

play_ventral_animations()
{
	//level.scr_anim["pby_a"]["ventral_close"] = %v_pby_rear_gun_down;
	//level.scr_anim["pby_a"]["ventral_open"] = %v_oby_rear_gun_up;
		
	while(1)
	{
		level.plane_a anim_single_solo(level.plane_a, "ventral_close");
		wait(5);
		level.plane_a anim_single_solo(level.plane_a, "ventral_open");
		wait(5);
	}
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//				PBY AI TYPE STUFF
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-- shoots all the turrets on the pby -- BASIC BEHAVIOR
//-- thread this on any pby's that you want to shoot

ai_pby_gunners_think()
{
	self endon("death");
	self endon("stop_shooting");
	
	front_gun_active = false;
	left_gun_active  = false;
	right_gun_active = false;
	rear_gun_active  = false;
	
	while(1)
	{
		self ai_pby_gunners_acquire_targets();
		
		if(IsDefined(self.target_list_front[0]))
		{
			self setgunnertargetent(self.target_list_front[0], (0,0,0), 0);
			front_gun_active = true;		
		}
		
		if(IsDefined(self.target_list_left[0]))
		{
			self setgunnertargetent(self.target_list_left[0], (0,0,0), 1);
			left_gun_active = true;
		}
		
		if(IsDefined(self.target_list_right[0]))
		{
			self setgunnertargetent(self.target_list_right[0], (0,0,0), 2);
			right_gun_active = true;
		}
		
		if(IsDefined(self.target_list_rear[0]))
		{
			self setgunnertargetent(self.target_list_rear[0], (0,0,0), 3);
			rear_gun_active = true;
		}
		
		for(i = 0; i < 10; i++)
		{
			
			//SETUP FOR A BASIC BURST FIRE
			if(front_gun_active) self firegunnerweapon(0);	
			if(left_gun_active) self firegunnerweapon(1);	
			if(right_gun_active) self firegunnerweapon(2);	
			if(rear_gun_active) self firegunnerweapon(3);	
			
			wait(0.2);
			
		}
		
		front_gun_active = false;
		left_gun_active  = false;
		right_gun_active = false;
		rear_gun_active  = false;
		
		rand = RandomIntRange(1, 3);
		wait(rand);
	}	
	
	
}

debug_the_zero_bug()
{
	while(1)
	{
		if(!IsDefined(self.target_list_front[0]) && self.target_list_front.size > 0)
		{
			ASSERT(false, "this is stupid");
		}
		if(!IsDefined(self.target_list_left[0]) && self.target_list_left.size > 0)
		{
			ASSERT(false, "this is stupid");
		}
		if(!IsDefined(self.target_list_right[0]) && self.target_list_right.size > 0)
		{
			ASSERT(false, "this is stupid");
		}
		if(!IsDefined(self.target_list_rear[0]) && self.target_list_rear.size > 0)
		{
			ASSERT(false, "this is stupid");
		}
		
		wait(0.05);
	}	
}

//-- initializes the gunners on the pby
ai_pby_gunners_acquire_targets()
{
	//-- self : is the plane that this is being called on
	self.target_list_front = [];
	self.target_list_left = [];
	self.target_list_right = [];
	self.target_list_rear = [];
	
	//self thread debug_the_zero_bug();
	
	//-- populate a target list for the plane
	while(self.target_list_front.size < 1)
	{
		self.target_list_front = GetEntArray("script_vehicle", "classname");
		
		/* -- we don't appear to be shooting at any script_brushmodels currently,
					i think this was for an old implementation
					
		temp_array = GetEntArray("script_brushmodel", "classname");
		for(i=0; i < temp_array.size; i++)
		{
			if(IsDefined(temp_array[i].script_noteworthy))
			{
				if(temp_array[i].script_noteworthy != "pby_target")
				{
					//-- remove any PBY planes from target list
					temp_array = array_remove(temp_array, temp_array[i]);
					i--;
				}	
			}
			else
			{
				temp_array = array_remove(temp_array, temp_array[i]);
				i--;
			}
		}
		
		self.target_list_front = array_combine(self.target_list_front, temp_array);
		*/
		self.target_list_left  = self.target_list_front;
		self.target_list_right = self.target_list_front;
		self.target_list_rear  = self.target_list_front;
		
		self.target_list_front = ai_pby_gunner_target_strip_pbys(self.target_list_front);
		self.target_list_left = ai_pby_gunner_target_strip_pbys(self.target_list_left);
		self.target_list_right = ai_pby_gunner_target_strip_pbys(self.target_list_right);
		self.target_list_rear = ai_pby_gunner_target_strip_pbys(self.target_list_rear);
			
		wait(0.1);
	}
	
	//-- rank the targets for the plane by turret self.target_list[0] will become the primary target
	self ai_pby_sort_targets(level.GUN_FRONT);
	self ai_pby_sort_targets(level.GUN_LEFT);
	self ai_pby_sort_targets(level.GUN_RIGHT);
	self ai_pby_sort_targets(level.GUN_REAR);
		
}

ai_pby_gunner_target_strip_pbys( my_array )
{
	for(i=0; i < my_array.size; i++)
	{
		if(IsDefined(my_array[i].vehicletype))
		{
			if(my_array[i].vehicletype == "pby_blackcat" || my_array[i].vehicletype == "jap_ptboat")
			{
				//-- remove any PBY planes from target list
				my_array = array_remove(my_array, my_array[i]);
				i--;
			}	
		}
	}
	
	return my_array;
}

// Arrange the targets based off of distance and direction for each gun
ai_pby_sort_targets(gun_position)
{
	//-- remove the targets that aren't in the guns available angles
	self ai_pby_gunner_sort_targets_by_angle(gun_position);
	self ai_pby_gunner_sort_targets_by_dist(gun_position);
	
}

//-- Makes sure that the target entities fit within the yaw and pitch range of the turret
ai_pby_gunner_sort_targets_by_angle(gun_position)
{
	if(gun_position == level.GUN_FRONT)
	{
		for(i = 0; i < self.target_list_front.size; i++)
		{
			//-- Make sure that the target is in front of the plane
			origin_1 = self GetTagOrigin("tag_gunner1");
			origin_2 = self.target_list_front[i].origin;
			
			// CODER_MOD : DSL 04/17/08
			// if target_list_x[i] has been removed, origin_2 will be undefined.
			if(!isdefined(origin_2))
				continue;
			
			//-- Checks the Horizontal Angle
			dot_value = VectorDot(AnglesToForward(self.angles), VectorNormalize(origin_2 - origin_1));
			
			//if(dot_value > 0)
			if(abs(dot_value) > 0.5)
			{
				//-- target is within the yaw angles of the turret
			}
			else
			{
				self.target_list_front = array_remove(self.target_list_front, self.target_list_front[i]);
				i--;
				
				continue;
			}
						
			//-- Checks the Vertical Angle
			dot_value = VectorDot(AnglesToUp(self.angles), VectorNormalize(origin_2 - origin_1));
			
			if(dot_value > 0.2 || dot_value < -0.2)
			{
				self.target_list_front = array_remove(self.target_list_front, self.target_list_front[i]);
				i--;
			}
			else
			{
				//-- target is within the pitch angles of the turret
			}
		}
	}
	else if(gun_position == level.GUN_LEFT)
	{
		for(i=0; i < self.target_list_left.size; i++)
		{
			origin_1 = self GetTagOrigin("tag_gunner2");
			origin_2 = self.target_list_left[i].origin;

			// CODER_MOD : DSL 04/17/08
			// if target_list_x[i] has been removed, origin_2 will be undefined.
			if(!isdefined(origin_2))
				continue;
		
			dot_value = VectorDot(AnglesToRight(self.angles) * -1, VectorNormalize(origin_2 - origin_1));
		
			if(dot_value > 0)
			{
				//-- target is to the left of the plane
			}
			else
			{
				self.target_list_left = array_remove(self.target_list_left, self.target_list_left[i]);
				i--;
				continue;
			}
			
			//TODO:  ADD IN CHECK FOR VERTICLE ANGLE
		}
	}
	else if(gun_position == level.GUN_RIGHT)
	{
		for(i =0; i < self.target_list_right.size; i++)
		{
			origin_1 = self GetTagOrigin("tag_gunner3");
			origin_2 = self.target_list_right[i].origin;

			// CODER_MOD : DSL 04/17/08
			// if target_list_x[i] has been removed, origin_2 will be undefined.
			if(!isdefined(origin_2))
				continue;
			
			dot_value = VectorDot(AnglesToRight(self.angles), VectorNormalize(origin_2 - origin_1));
			
			if(dot_value > 0)
			{
				//-- target is to the left of the plane
			}
			else
			{
				self.target_list_right = array_remove(self.target_list_right, self.target_list_right[i]);
				i--;
				continue;
			}
			
			//TODO:  ADD IN CHECK FOR VERTICLE ANGLE
		}
	}
	else if(gun_position == level.GUN_REAR)
	{
		for(i = 0; i < self.target_list_rear.size; i++)
		{
			//-- Make sure that the target is in front of the plane
			origin_1 = self GetTagOrigin("tag_gunner4");
			origin_2 = self.target_list_rear[i].origin;

			// CODER_MOD : DSL 04/17/08
			// if target_list_x[i] has been removed, origin_2 will be undefined.
			if(!isdefined(origin_2))
				continue;
			
			dot_value = VectorDot(AnglesToForward(self.angles) * -1, VectorNormalize(origin_2 - origin_1));
			
			if(dot_value > 0)
			{
				//-- target is in front of the plane
			}
			else
			{
				self.target_list_rear = array_remove(self.target_list_rear, self.target_list_rear[i]);
				i--;
				continue;
			}
			
			//TODO:  ADD IN CHECK FOR VERTICLE ANGLE
		}
	}
}

ai_pby_gunner_sort_targets_by_dist(gun_position)
{
	//level.TURRET_RANGE = 5000; -- just keeping track of a variable
	
	if(gun_position == level.GUN_FRONT)
	{
		//-- Remove all targets that are out of turret range
		for(i=0; i < self.target_list_front.size; i++)
		{
			// CODER_MOD : DSL 04/17/08
			// Making sure we don't try to distance check to a removed ent.
			
			if((!isdefined(self.target_list_front[i].origin)) || (Distance2d(self.target_list_front[i].origin, self GetTagOrigin("tag_gunner1")) > level.TURRET_RANGE))
			{
				self.target_list_front = array_remove(self.target_list_front, self.target_list_front[i]);
				i--;
			}
		}
		
		//-- Sort the lowest distance target to index [0]
		for(i=1; i < self.target_list_front.size; i++)
		{
			potential_target = self.target_list_front[i];
			
			if(!IsDefined(potential_target))
			{
				continue;
			}
			
			dist_1 = Distance2d(self.target_list_front[i].origin, self GetTagOrigin("tag_gunner1"));
			dist_2 = Distance2d(self.target_list_front[0].origin, self GetTagOrigin("tag_gunner1"));
			
			if(dist_1 < dist_2)
			{
				holder = self.target_list_front[0];
				self.target_list_front[0] = self.target_list_front[i];
				self.target_list_front[i] = holder;
			}
		}
	}
	else if(gun_position == level.GUN_LEFT)
	{
		for(i=0; i < self.target_list_left.size; i++)
		{
			// CODER_MOD : DSL 04/17/08
			// Making sure we don't try to distance check to a removed ent.
			
			if((!isdefined(self.target_list_left[i].origin)) || (Distance2d(self.target_list_left[i].origin, self GetTagOrigin("tag_gunner2")) > level.TURRET_RANGE))
			{
				self.target_list_left = array_remove(self.target_list_left, self.target_list_left[i]);
				i--;
			}
		}
		
		//-- Sort the lowest distance target to index [0]
		for(i=1; i < self.target_list_left.size; i++)
		{
			potential_target = self.target_list_left[i];
			
			if(!IsDefined(potential_target))
			{
				continue;
			}
			
			dist_1 = Distance2d(self.target_list_left[i].origin, self GetTagOrigin("tag_gunner2"));
			dist_2 = Distance2d(self.target_list_left[0].origin, self GetTagOrigin("tag_gunner2"));
			
			if(dist_1 < dist_2)
			{
				holder = self.target_list_front[0];
				self.target_list_left[0] = self.target_list_left[i];
				self.target_list_left[i] = holder;
			}
		}
	}
	else if(gun_position == level.GUN_RIGHT)
	{
		for(i=0; i < self.target_list_right.size; i++)
		{
			// CODER_MOD : DSL 04/17/08
			// Making sure we don't try to distance check to a removed ent.
						
			if((!isdefined(self.target_list_right[i].origin)) || (Distance2d(self.target_list_right[i].origin, self GetTagOrigin("tag_gunner3")) > level.TURRET_RANGE))
			{
				self.target_list_right = array_remove(self.target_list_right, self.target_list_right[i]);
				i--;
			}
		}
		
		//-- Sort the lowest distance target to index [0]
		for(i=1; i < self.target_list_right.size; i++)
		{
			potential_target = self.target_list_right[i];
			
			if(!IsDefined(potential_target))
			{
				continue;
			}
			
			dist_1 = Distance2d(self.target_list_right[i].origin, self GetTagOrigin("tag_gunner3"));
			dist_2 = Distance2d(self.target_list_right[0].origin, self GetTagOrigin("tag_gunner3"));
			
			if(dist_1 < dist_2)
			{
				holder = self.target_list_right[0];
				self.target_list_right[0] = self.target_list_right[i];
				self.target_list_right[i] = holder;
			}
		}
	}
	else if(gun_position == level.GUN_REAR)
	{
		for(i=0; i < self.target_list_rear.size; i++)
		{
			// CODER_MOD : DSL 04/17/08
			// Making sure we don't try to distance check to a removed ent.
						
			if((!isdefined(self.target_list_rear[i].origin)) || (Distance2d(self.target_list_rear[i].origin, self GetTagOrigin("tag_gunner4")) > level.TURRET_RANGE))
			{
				self.target_list_rear = array_remove(self.target_list_rear, self.target_list_rear[i]);
				i--;
			}
		}
		
		//-- Sort the lowest distance target to index [0]
		for(i=1; i < self.target_list_rear.size; i++)
		{
			potential_target = self.target_list_rear[i];
			
			if(!IsDefined(potential_target))
			{
				continue;
			}
			
			//-- remove any undefined early indexes (not sure why this is happening)
			while( !IsDefined(self.target_list_rear[0]) && self.target_list_rear.size > 0)
			{
				self.target_list_rear = array_shift_left( self.target_list_rear );
			}
			
			dist_1 = Distance2d(self.target_list_rear[i].origin, self GetTagOrigin("tag_gunner4"));
			dist_2 = Distance2d(self.target_list_rear[0].origin, self GetTagOrigin("tag_gunner4"));
			
			if(dist_1 < dist_2)
			{
				holder = self.target_list_rear[0];
				self.target_list_rear[0] = self.target_list_front[i];
				self.target_list_rear[i] = holder;
			}
		}
	}
}

array_shift_left( _array )
{
	ASSERTEX( !IsDefined(_array[0]), "Array Shift Left called with an array that doesn't need shifting");
	
	old_size = _array.size;
	
	new_array = [];
	
	i = 0;
	for(; i < _array.size; i++)
	{
		if(IsDefined(_array[i+1]))
		{
			new_array[i] = _array[i+1];
		}
	}
		
	if(old_size == new_array.size)
	{
		return new_array;
	}
	else
	{
		ASSERTEX(false, "Why is the array a different size now? WTF Mate?");
		return new_array;
	}
}

#using_animtree ("vehicles");
//-- plays the appropriate idle on the plane
pby_veh_idle(idle, delay_time, pontoons_up, hatch_open)
{
	if(IsDefined(delay_time))
	{
		wait (delay_time);
	}
	
	self notify("stop_pby_idling");
	self.current_idle = "none";
	
	if(IsDefined(self.current_idle_anim))
			self ClearAnim(self.current_idle_anim, 0);
			
	if(idle == "fly" || idle == "fly_up_open" || idle == "fly_up")
	{
		if(IsDefined(pontoons_up) || idle == "fly_up_open" || idle == "fly_up")
		{
			if(IsDefined(hatch_open) || idle == "fly_up_open")
			{
				self SetFlaggedAnimKnob( "idle_anim", %v_pby_fly_up_open, 1, 0, 1);
				self.current_idle = "fly_up_open";
				self.current_idle_anim = %v_pby_fly_up_open;	
			}
			else
			{
				self SetFlaggedAnimKnob( "idle_anim", %v_pby_fly_up, 1, 0, 1);
				self.current_idle = "fly_up";
				self.current_idle_anim = %v_pby_fly_up;	
			}
		}
		else
		{
			self SetFlaggedAnimKnob( "idle_anim", %v_pby_fly, 1, 0, 1);
			self.current_idle = "fly";
			self.current_idle_anim = %v_pby_fly;
		}
		return;
	}
	
	if(idle == "float")
	{
		self SetFlaggedAnimKnob( "idle_anim", %v_pby_float_blisters, 1, 0, 1);
		self.current_idle = "float";
		//self.current_idle_anim = %v_pby_taxi_rough;
		self.current_idle_anim = %v_pby_float_blisters;
		return;
	}
	
	if(idle == "float_ai")
	{
		self SetFlaggedAnimKnob ( "idle_anim", %v_pby_taxi_ai, 1, 0, 1);
		self.current_idle = "float_ai";
		self.current_idle_anim = %v_pby_taxi_ai;
		return;
	}
	
	if(idle == "float_static")
	{
		self SetFlaggedAnimKnob ( "idle_anim", %v_pby_staticpose, 1, 0, 1);
		self.current_idle = "float_static";
		self.current_idle_anim = %v_pby_staticpose;
		return;
	}
	
	if(idle == "none")
	{
		self.current_idle_anim = undefined;
	}
}

out_of_ammo_sound( bone , end_notify)
{
	if(IsDefined(end_notify))
	{
		level endon(end_notify);
	}
	
	position = self GetTagOrigin( bone );
	
	bullet_sound = Spawn("script_origin", position);
	bullet_sound LinkTo(self, bone );
	
	bullet_sound playsound ("dryfire_rifle_plr", "click_done");
	bullet_sound waittill("click_done");						
	
	while(1)
	{
		if(level.player AttackButtonPressed())
		{
			//if(level.player.current_seat == "pby_rightgun" && level.player.in_transition == false)
			//{
				bullet_sound playsound ("dryfire_rifle_plr", "click_done");
				bullet_sound waittill("click_done");						
		
				while(level.player AttackButtonPressed())
				{
					wait(0.05);
				}
			//}
			//else
			//{
				//wait 0.05;
			//}
		}
		else
		{
			wait 0.05;
		}
	}
}

pby_veh_fire_guns()
{
	while(!IsDefined(level.player.current_seat))
	{
		wait(0.05);
	}
	
	//-- for bullet out of ammo
	ammo_count = 0;
	
	while(1)
	{
		if(level.player AttackButtonPressed())
		{
			if(level.player.current_seat == "pby_rightgun" && level.player.in_transition == false && self IsGunnerFiring(2))
			{
				if(flag("pby_out_of_ammo"))
				{
					if(ammo_count < 8)
					{
						self SetFlaggedAnimKnobRestart( "ammo_fire_right", level.scr_anim["pby"]["ammo_right_" + ammo_count], 1, 0.1, 1);
						animation_time = getAnimLength( level.scr_anim["pby"]["ammo_right_" + ammo_count] );
						wait(animation_time);
						
						ammo_count++;
					}
					
					if(ammo_count == 8)
					{
						flag_set("pby_actually_out_of_ammo");
						self DisableGunnerFiring( 2, true );
						self thread out_of_ammo_sound("tag_gunner_barrel3", "right_out_of_ammo");
						thread player_uses_pistol();
						return;
					}
				}
				else
				{
					//iprintlnbold("animating ammo");
					self SetFlaggedAnimKnobRestart( "ammo_fire_right", %v_pby_blisterammo_right_fire, 1, 0.1, 1);
					animation_time = getAnimLength( %v_pby_blisterammo_right_fire );
					wait(animation_time);
				}
			}
			else if(level.player.current_seat == "pby_leftgun" && level.player.in_transition == false && self IsGunnerFiring(1))
			{
				self SetFlaggedAnimKnobRestart( "ammo_fire_left", %v_pby_blisterammo_left_fire, 1, 0.1, 1);
				animation_time = getAnimLength( %v_pby_blisterammo_right_fire );
				wait(animation_time);
			}
			else if(level.player.current_seat == "pby_frontgun" && level.player.in_transition == false && self IsGunnerFiring(0))
			{
				if(flag("pby_out_of_ammo"))
				{
					if(ammo_count < 20)
					{
						ammo_count++;
					}
					
					if(ammo_count == 20)
					{
						flag_set("pby_actually_out_of_ammo");
						self DisableGunnerFiring( 0, true );
						self thread out_of_ammo_sound("tag_gunner_barrel1", "front_out_of_ammo");
						return;
					}
				}
				else
				{
					wait(0.05);
				}
			}
			else
			{
				wait(0.05);
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

player_uses_pistol()
{
	level.plane_a waittill("flattened_out");
	
	while(!flag("pby_actually_out_of_ammo"))
	{
		wait(0.05);
	}
		
	//-- the pby is out of ammo!  oh noes!!
	
	plane = level.plane_a;
	plane UseBy(level.player);
	
	//-- plays the animation	
	startorg = getstartOrigin( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "pby_right_to_pistol" ] );
	startang = getstartAngles( plane GetTagOrigin("origin_animate_jnt"), plane GetTagAngles("origin_animate_jnt"), level.scr_anim[ "player_hands" ][ "pby_right_to_pistol" ] );
	
	player_hands = spawn_anim_model( "player_hands" );
	player_hands.plane = plane;
	player_hands.direction = "right";
	
	player_hands.origin = startorg;
	player_hands.angles = startang;
	player_hands LinkTo(plane, "origin_animate_jnt");
	
	level.player.origin = player_hands.origin;
	level.player.angles = player_hands.angles;

	//level.player playerlinktoabsolute(player_hands, "tag_player" );s
	level.player PlayerLinkTo(player_hands, "tag_player", 1, 60, 30, 30, 30, true);
	
	plane maps\_anim::anim_single_solo( player_hands, "pby_right_to_pistol" );
	
	SetTimeScale(0.3);
	
	level.player GiveWeapon( "colt" );
	level.player SwitchToWeapon( "colt" );
	level.player SetWeaponAmmoStock( "colt", 0 );
	level.player SetClientDvar("ammoCounterHide", "0");
	

}

/*
pby_explosion()
{
	//level.scr_anim["pby"]["shinyou_blast"]      = %v_pby_explosion;
	idle_holder = self.current_idle;
	
	self pby_veh_idle("none");
	playfxontag(level._effect["shinyou_splash"], self, "tag_origin");
	self anim_single_solo(self, "shinyou_blast");
	//self waittill("shinyou_blast");
	wait(5);
	self pby_veh_idle(idle_holder);
}
*/

draw_debug_line_stupid_animation(start_org)
{
	while(1)
	{
		startorg = getstartOrigin( self.plane GetTagOrigin("tag_engineer"), self.plane GetTagAngles("tag_engineer"), level.scr_anim[ "rescue_a_4" ][ "my_idle" ][0] );
		
		pos1 = startorg;
		pos2 = self.origin;
		Line(pos1, pos2, (1, 0, 0));
		
		pos1 = level.plane_a GetTagOrigin("tag_engineer");
		pos2 = level.player.origin;
		Line(pos1, pos2, (0, 0, 1));
		
		wait(0.05);
	}
}

draw_debug_lines_to_target(gun_bone, id)
{
	pos1 = self GetTagOrigin(gun_bone);
	pos2 = self.target_vector;
	Line(pos1, pos2, (1,0,0));
}

draw_debug_line_to_target_distance( pby )
{
	self endon( "death" );
	
	while(1)
	{
		pos1 = pby.origin;
		pos2 = self.origin;
		
		dist = Distance(pos1, pos2);
		color = ( 0, 0, 0 );
		
		if(dist <= 4500) //too close
		{
			color = (1, 0, 0);
		}
		else if( dist > 4500 && dist < 7500) //just right
		{
			color = (0, 1, 0);
		}
		else //too far
		{
			color = (0, 0, 1);
		}
		
		pos3 = pos2 + (0,0,100);
		Line(pos3, pos2, color);
		
		wait(0.05);
	}
	
}

stat_counter()
{
	//precacheShader("hud_pby_score_ptboat");
	//precacheShader("hud_pby_score_rescue");
	//precacheShader("hud_pby_score_ship");
	//precacheShader("hud_pby_score_zero");
	
	level thread stat_counter_ptboat();
	level thread stat_counter_zeroes();
	level thread stat_counter_merchant_ships();
	level thread stat_counter_survivors();
	
	//-- Stat Counter Control
	
	merchant_old_count = level.merchant_ship_death_count;
	zero_old_count = level.zero_death_count;
	ptboat_old_count = level.ptboat_death_count;
	survivor_old_count = level.survivor_save_count;
	
	
	//-- The whole theory of tracking stats is pretty much only inline with Arcade Mode.
	//--  so if we want this then we better find a way for the player to play it in Arcade Mode.
	if(true)
	{
		return;
	}
	
	while(1)
	{
		while(merchant_old_count == level.merchant_ship_death_count && zero_old_count == level.zero_death_count && ptboat_old_count == level.ptboat_death_count && survivor_old_count == level.survivor_save_count)
		{
			wait(0.05);
		}
		
		merchant_old_count = level.merchant_ship_death_count;
		zero_old_count = level.zero_death_count;
		ptboat_old_count = level.ptboat_death_count;
		survivor_old_count = level.survivor_save_count;	
	
		level.merchant_ship_number SetValue(level.merchant_ship_death_count);
		level.merchant_ship_count thread hud_elem_fade_in(1);
		level.merchant_ship_x thread hud_elem_fade_in(1);
		level.merchant_ship_number thread hud_elem_fade_in(1);
		
		level.zero_number SetValue(level.zero_death_count);
		level.zero_count thread hud_elem_fade_in(1);
		level.zero_x thread hud_elem_fade_in(1);
		level.zero_number thread hud_elem_fade_in(1);
		
		level.ptboat_number SetValue(level.ptboat_death_count);
		level.ptboat_count thread hud_elem_fade_in(1);
		level.ptboat_x thread hud_elem_fade_in(1);
		level.ptboat_number thread hud_elem_fade_in(1);
		
		level.survivor_number SetValue(level.survivor_save_count);
		level.survivor_count thread hud_elem_fade_in(1);
		level.survivor_x thread hud_elem_fade_in(1);
		level.survivor_number thread hud_elem_fade_in(1);
		
		
		for(i = 0; i < 20; i++)
		{
			if(merchant_old_count != level.merchant_ship_death_count || zero_old_count != level.zero_death_count || ptboat_old_count != level.ptboat_death_count || survivor_old_count != level.survivor_save_count)
			{
				merchant_old_count = level.merchant_ship_death_count;
				zero_old_count = level.zero_death_count;
				ptboat_old_count = level.ptboat_death_count;
				survivor_old_count = level.survivor_save_count;
			
				level.merchant_ship_number SetValue(level.merchant_ship_death_count);
				level.zero_number SetValue(level.zero_death_count);
				level.ptboat_number Setvalue(level.ptboat_death_count);
				level.survivor_number SetValue(level.survivor_save_count);
				
				i = 0;
			}
			
			wait(0.05);
		}
		
		level.merchant_ship_count thread hud_elem_fade_out(1);
		level.merchant_ship_x thread hud_elem_fade_out(1);
		level.merchant_ship_number thread hud_elem_fade_out(1);
	
		level.zero_count thread hud_elem_fade_out(1);
		level.zero_x thread hud_elem_fade_out(1);
		level.zero_number thread hud_elem_fade_out(1);
		
		level.ptboat_count thread hud_elem_fade_out(1);
		level.ptboat_x thread hud_elem_fade_out(1);
		level.ptboat_number thread hud_elem_fade_out(1);
		
		level.survivor_count thread hud_elem_fade_out(1);
		level.survivor_x thread hud_elem_fade_out(1);
		level.survivor_number thread hud_elem_fade_out(1);
		
		wait(1);
	}
}

stat_counter_merchant_ships()
{
	level.merchant_ship_death_count = 0;
	
	level.merchant_ship_count = NewHudElem();
	level.merchant_ship_count.x = 130;
	level.merchant_ship_count.y = 340;
	level.merchant_ship_count.alignX = "right";
	level.merchant_ship_count.alignY = "top";
	level.merchant_ship_count.fontScale = 1;
	level.merchant_ship_count.alpha = 0;
	level.merchant_ship_count.sort = 20;
	level.merchant_ship_count.font = "default";
	
	//level.merchant_ship_count SetText( &"PBY_FLY_MERCHANT" );
	level.merchant_ship_count SetShader("hud_pby_score_ship", 64, 32);
		
	level.merchant_ship_x = NewHudElem();
	level.merchant_ship_x.x = 140;
	level.merchant_ship_x.y = 357;
	level.merchant_ship_x.alignX = "right";
	level.merchant_ship_x.alignY = "top";
	level.merchant_ship_x.fontScale = 1;
	level.merchant_ship_x.alpha = 0;
	level.merchant_ship_x.sort = 20;
	level.merchant_ship_x.font = "default";
	level.merchant_ship_x SetText( &"PBY_FLY_X" );
	
	level.merchant_ship_number = NewHudElem();
	level.merchant_ship_number.x = 143;
	level.merchant_ship_number.y = 357;
	level.merchant_ship_number.alignX = "left";
	level.merchant_ship_number.alignY = "top";
	level.merchant_ship_number.fontScale = 1;
	level.merchant_ship_number.alpha = 0;
	level.merchant_ship_number.sort = 20;
	level.merchant_ship_number.font = "default";
	
	level.merchant_ship_number SetValue(level.merchant_ship_death_count);
	
	//level.merchant_ship_count thread hud_elem_fade_in(1);
	//level.merchant_ship_x thread hud_elem_fade_in(1);
	//level.merchant_ship_number thread hud_elem_fade_in(1);
	
	//-- display and count logic
	/*
	old_count = level.merchant_ship_death_count;
	while(1)
	{
			while(old_count == level.merchant_ship_death_count)
			{
				wait(0.05);
			}
			
			old_count = level.merchant_ship_death_count;
			
			level.merchant_ship_number SetValue(level.merchant_ship_death_count);
			
			level.merchant_ship_count thread hud_elem_fade_in(1);
			level.merchant_ship_number hud_elem_fade_in(1);
			wait(2);
			level.merchant_ship_count thread hud_elem_fade_out(3);
			level.merchant_ship_number hud_elem_fade_out(3);
	}
	*/
}

stat_counter_survivors()
{
	level.survivor_save_count = 0;
		
	level.survivor_count = NewHudElem();
	level.survivor_count.x = 130;
	level.survivor_count.y = 420;
	level.survivor_count.alignX = "right";
	level.survivor_count.alignY = "top";
	level.survivor_count.fontScale = 1;
	level.survivor_count.alpha = 0;
	level.survivor_count.sort = 20;
	level.survivor_count.font = "default";
	
	level.survivor_count SetText( &"PBY_FLY_SURVIVOR" );
	level.survivor_count SetShader("hud_pby_score_rescue", 16, 32);
	
	level.survivor_x = NewHudElem();
	level.survivor_x.x = 140;
	level.survivor_x.y = 425;
	level.survivor_x.alignX = "right";
	level.survivor_x.alignY = "top";
	level.survivor_x.fontScale = 1;
	level.survivor_x.alpha = 0;
	level.survivor_x.sort = 20;
	level.survivor_x.font = "default";
	level.survivor_x SetText( &"PBY_FLY_X" );
		
	level.survivor_number = NewHudElem();
	level.survivor_number.x = 143;
	level.survivor_number.y = 425;
	level.survivor_number.alignX = "left";
	level.survivor_number.alignY = "top";
	level.survivor_number.fontScale = 1;
	level.survivor_number.alpha = 0;
	level.survivor_number.sort = 20;
	level.survivor_number.font = "default";
	
	level.survivor_number SetValue(level.survivor_save_count);
	
	/*
	level.survivor_count thread hud_elem_fade_in(1);
	level.survivor_x thread hud_elem_fade_in(1);
	level.survivor_number thread hud_elem_fade_in(1);
	
	//-- display and count logic
	
	old_count = level.survivor_save_count;
	while(1)
	{
			while(old_count == level.survivor_save_count)
			{
				wait(0.05);
			}
			
			old_count = level.survivor_save_count;
			
			level.survivor_number SetValue(level.survivor_save_count);
			
			
			level.survivor_count thread hud_elem_fade_in(1);
			level.survivor_number hud_elem_fade_in(1);
			wait(2);
			level.survivor_count thread hud_elem_fade_out(3);
			level.survivor_number hud_elem_fade_out(3);
			
	}*/
}

stat_counter_zeroes()
{
	level.zero_death_count = 0;
		
	level.zero_count = NewHudElem();
	level.zero_count.x = 130;
	level.zero_count.y = 388;
	level.zero_count.alignX = "right";
	level.zero_count.alignY = "top";
	level.zero_count.fontScale = 1;
	level.zero_count.alpha = 0;
	level.zero_count.sort = 20;
	level.zero_count.font = "default";
	
	//level.zero_count SetText( &"PBY_FLY_ZEROES" );
	level.zero_count SetShader("hud_pby_score_zero", 32, 32);
	
	level.zero_x = NewHudElem();
	level.zero_x.x = 140;
	level.zero_x.y = 400;
	level.zero_x.alignX = "right";
	level.zero_x.alignY = "top";
	level.zero_x.fontScale = 1;
	level.zero_x.alpha = 0;
	level.zero_x.sort = 20;
	level.zero_x.font = "default";
	level.zero_x SetText( &"PBY_FLY_X" );
		
	level.zero_number = NewHudElem();
	level.zero_number.x = 143;
	level.zero_number.y = 400;
	level.zero_number.alignX = "left";
	level.zero_number.alignY = "top";
	level.zero_number.fontScale = 1;
	level.zero_number.alpha = 0;
	level.zero_number.sort = 20;
	level.zero_number.font = "default";
	
	level.zero_number SetValue(level.zero_death_count);
	
	/*
	level.zero_count thread hud_elem_fade_in(1);
	level.zero_x thread hud_elem_fade_in(1);
	level.zero_number thread hud_elem_fade_in(1);
	
	//-- display and count logic
	old_count = level.zero_death_count;
	while(1)
	{
			while(old_count == level.zero_death_count)
			{
				wait(0.05);
			}
			
			old_count = level.zero_death_count;
			
			level.zero_number SetValue(level.zero_death_count);
			
			level.zero_count thread hud_elem_fade_in(1);
			level.zero_number hud_elem_fade_in(1);
			wait(2);
			level.zero_count thread hud_elem_fade_out(3);
			level.zero_number hud_elem_fade_out(3);
	}
	*/
}

stat_counter_ptboat()
{
	level.ptboat_death_count = 0;
		
	level.ptboat_count = NewHudElem();
	level.ptboat_count.x = 130;
	level.ptboat_count.y = 372;
	level.ptboat_count.alignX = "right";
	level.ptboat_count.alignY = "top";
	level.ptboat_count.fontScale = 1;
	level.ptboat_count.alpha = 0;
	level.ptboat_count.sort = 20;
	level.ptboat_count.font = "default";
	
	//level.ptboat_count SetText( &"PBY_FLY_PTBOAT" );
	level.ptboat_count SetShader("hud_pby_score_ptboat", 32, 16);
	
	level.ptboat_x = NewHudElem();
	level.ptboat_x.x = 140;
	level.ptboat_x.y = 375;
	level.ptboat_x.alignX = "right";
	level.ptboat_x.alignY = "top";
	level.ptboat_x.fontScale = 1;
	level.ptboat_x.alpha = 0;
	level.ptboat_x.sort = 20;
	level.ptboat_x.font = "default";
	level.ptboat_x SetText( &"PBY_FLY_X" );
		
	level.ptboat_number = NewHudElem();
	level.ptboat_number.x = 143;
	level.ptboat_number.y = 375;
	level.ptboat_number.alignX = "left";
	level.ptboat_number.alignY = "top";
	level.ptboat_number.fontScale = 1;
	level.ptboat_number.alpha = 0;
	level.ptboat_number.sort = 20;
	level.ptboat_number.font = "default";
	
	level.ptboat_number SetValue(level.ptboat_death_count);
	
	//level.ptboat_count thread hud_elem_fade_in(1);
	//level.ptboat_x thread hud_elem_fade_in(1);
	//level.ptboat_number thread hud_elem_fade_in(1);
	
	//-- display and count logic
	/*
	old_count = level.ptboat_death_count;
	while(1)
	{
			while(old_count == level.ptboat_death_count)
			{
				wait(0.05);
			}
			
			old_count = level.ptboat_death_count;
			
			level.ptboat_number SetValue(level.ptboat_death_count);
			
		
			level.ptboat_count thread hud_elem_fade_in(1);
			level.ptboat_number hud_elem_fade_in(1);
			wait(2);
			level.ptboat_count thread hud_elem_fade_out(3);
			level.ptboat_number hud_elem_fade_out(3);
		
	}
	*/
}

hud_elem_fade_in( time )
{
	self FadeOverTime(time);
	self.alpha = 1;
	
	wait(time);
}

hud_elem_fade_out( time )
{
	self FadeOvertime(time);
	self.alpha = 0;
	
	wait(time);
}

turret_ads_reminder()
{
	if(!IsDefined(level.ads_remind_text))
	{
		level.ads_remind_text = NewHudElem();
	}
	
	level.ads_remind_text.x = 320;
	level.ads_remind_text.y = 300;
	level.ads_remind_text.alignX = "center";
	level.ads_remind_text.alignY = "bottom";
	level.ads_remind_text.fontScale = 1.5;
	level.ads_remind_text.alpha = 1.0;
	level.ads_remind_text.sort = 20;
	level.ads_remind_text.font = "default";
	
	if( level.console )
		str_ref = &"PBY_FLY_ADS_HINT";
	else
		str_ref = &"SCRIPT_PLATFORM_PBY_FLY_ADS_HINT";
	
	level.ads_remind_text SetText( str_ref );
	
	level thread turret_ads_reminder_off();
	level thread turret_ads_reminder_press();
	level thread turret_ads_reminder_timed();
}

turret_ads_reminder_press()
{
	level endon("turn off ads hint");
	
	while(!(level.player AdsButtonPressed()))
	{
		wait(0.05);
	}
	
	level notify("player_pressed_ads");
	level notify("turn off ads hint");
}

turret_ads_reminder_timed()
{
	level endon("turn off ads hint");
	wait(10);
	
	level notify("turn off ads hint");
	level notify("ads timed out");
}

turret_ads_reminder_off()
{
	level waittill("turn off ads hint");
	
	level.ads_remind_text SetText("");
}

turret_rescue_hud_elem()
{
	level endon("save_text_off");
	
	if(!IsDefined(level.save_text))
	{
		level.save_text = NewHudElem();
	}
	
	level.save_text.x = 450;
	//level.save_text.y = 220;
	level.save_text.y = 300;
	level.save_text.alignX = "right";
	level.save_text.alignY = "bottom";
	level.save_text.fontScale = 1.5;
	level.save_text.alpha = 1.0;
	level.save_text.sort = 20;
	level.save_text.font = "default";
	
	str_ref = &"PBY_FLY_RESCUE";
	
	while(flag("turret_hud"))
	{
		wait(0.1);
	}
	
	while(!flag("saver_ready"))
	{
		wait(0.1);
	}
	
	level.save_text SetText( str_ref );
	
	level thread turret_rescue_hud_elem_off();
	level thread turret_rescue_hud_elem_hide(str_ref);
}

turret_rescue_hud_elem_off()
{
	level waittill_either("survivor_fell", "survivor_saved");
	level notify("save_text_off");
	level.save_text SetText("");
}

turret_rescue_hud_elem_hide(str_ref)
{
	level endon("save_text_off");
	
	while(flag("rescue_ready") && !flag("turret_hud") && flag("saver_ready"))
	{
		wait(0.05);
	}
		
	level.save_text SetText("");
	level thread turret_rescue_hud_elem_show(str_ref);
}

turret_rescue_hud_elem_show(str_ref)
{
	level endon("save_text_off");
		
	while(flag("turret_hud") || !flag("saver_ready") || !flag("rescue_ready"))
	{
		wait(0.05);
	}
	
	level.save_text SetText(str_ref);
	level thread turret_rescue_hud_elem_hide(str_ref);
}

turret_switch_hud_elem( str_ref, time_until_forced_switch )
{
	//yellow = (1,1,0);
	
	if(!IsDefined(time_until_forced_switch))
	{
		time_until_forced_switch = 3;	
	}
	if(!IsDefined(level.switch_text))
	{
		level.switch_text = NewHudElem();
	}
	
	level.switch_text.x = 450;
	level.switch_text.y = 220;
	level.switch_text.alignX = "right";
	level.switch_text.alignY = "bottom";
	level.switch_text.fontScale = 1.5;
	level.switch_text.alpha = 1.0;
	level.switch_text.sort = 20;
	level.switch_text.font = "default";
	
	level notify("turret_text_on");
	flag_set("turret_hud");
	level.switch_text SetText( str_ref );
	
	if(!IsDefined(level.switch_time_text))
	{
		level.switch_time_text = NewHudElem();
	}
	level.switch_time_text.x = 450;
	level.switch_time_text.y = 220;
	level.switch_time_text.alignX = "left";
	level.switch_time_text.alignY = "bottom";
	level.switch_time_text.fontScale = 1.5;
	level.switch_time_text.alpha = 1.0;
	level.switch_time_text.sort = 20;
	level.switch_time_text.font = "default";
	//level.switch_time_text.color = yellow;
	
	self thread turret_switch_hud_elem_off();
	
	level.player_switched = false;
	while(time_until_forced_switch > 0 && !level.player_switched)
	{
		level.switch_time_text SetText( " (" + time_until_forced_switch + ") ");
		time_until_forced_switch--;
		wait(1);
	}
	
	if(!level.player_switched)
	{ 
		//force the switch
		while(level.player.save_anim)
		{
			wait(0.2);
		}
		
		wait(0.15);
		
		if(self.need_to_switch)
		{
			self.need_to_switch = false;
			self switch_turret(self.required_seat);
		}
	}
}

turret_switch_hud_elem_off()
{
	self waittill("switching_turret");
	level notify("turret_text_off");
	flag_clear("turret_hud");
	level.player_switched = true;
	level.switch_text SetText("");
	level.switch_time_text SetText("");
}

scripted_turret_switch(turret_needed, should_wait, time_until_forced_switch)
{
	self.required_seat = turret_needed;
	
	if(self.required_seat == self.current_seat)
	{
		return;
	}
	
	//-- ADD IN PROPER UI ELEMENTS
	//iprintlnbold("PRESS X TO SWITCH TO: " + self.required_seat);
	if(self.required_seat == "pby_frontgun")
	{
		self thread turret_switch_hud_elem( &"PBY_FLY_SWITCH_FRONT", time_until_forced_switch );	
	}
	
	if(self.required_seat == "pby_rightgun")
	{
		self thread turret_switch_hud_elem( &"PBY_FLY_SWITCH_RIGHT", time_until_forced_switch );	
	}
	
	if(self.required_seat == "pby_leftgun")
	{
		self thread turret_switch_hud_elem( &"PBY_FLY_SWITCH_LEFT", time_until_forced_switch );	
	}
	
	if(self.required_seat == "pby_backgun")
	{
		self thread turret_switch_hud_elem( &"PBY_FLY_SWITCH_REAR", time_until_forced_switch );	
	}
	
	self.need_to_switch = true;
	
	if(!IsDefined(should_wait))
	{
		return;
	}
	
	if(should_wait == false)
	{
		return;
	}
	
	while(self.required_seat != self.current_seat)
	{
		wait(0.1);
	}
}

//-- Doesn't allow the player to switch weapons using the dpad
//-- It also hides the compass and give back some screen real estate
disable_manual_switching()
{
	level notify("no_manual_switch");
	
	SetSavedDvar( "compass", "0");
	SetSavedDvar( "hud_showStance", "0" ); 
	SetSavedDvar( "ammoCounterHide", "1" );
		
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
	}
	//SetDvar( "debug_draw_event", "0" );
}


//-- PRINT OUT SCRIPTMODELS --

scriptmodel_dump()
{
	while(true)
	{
		my_array = GetEntArray("script_model", "classname");
		total_size = my_array.size;
		
		total_tag_origins = 0;
		total_planes = 0;
		
		println("**********************************");
		println("**********************************");
		println("**********************************");
		println("***   count: " + total_size);
		println("**********************************");
		println("**********************************");
		println("**********************************");
		
		for(i = 0; i < total_size; i++)
		{
			if(my_array[i].model == "tag_origin")
			{
				total_tag_origins++;
			}
			
			if(my_array[i].model == "vehicle_jap_airplane_zero_fly")
			{
				total_planes++;
			}
			
			//println(my_array[i].classname + " " + " of type: " + my_array[i].model + " (" + i + ")");		
		}
		
		println("*** origin count: " + total_tag_origins);
		println("*** plane count: " + total_planes);
		println("**********************************");
		println("**********************************");
		println("**********************************");
		
		
		wait(3);
	}
}


//*** SPECIAL SETUP FOR SHOWING PRESS / RETAILERS ***//

event2_strafe_boats_m()
{
	level.to_be_continued = true;
	
	//-- some PTBoats just for the demo
	level thread event2_ptboat_2nd_pass_m();
	
	//-- setup objective
	set_objective("merchant_boats");
	//maps\_debug::set_event_printname("Event 2 - Merchantships", false);
	
	//-- new sink anim test
	level.boats[0].sink_anim = "sink_big";
	level.boats[0].special_sink_fx = "merchant_sink_fire";
	
	wait(0.05);
	
	//-- setup proper parent for oil tanks -- this will need to be done per boat
	oil_tanks = [];
	oil_tanks = getentarray ("explodable_oiltank","script_noteworthy");
	for( i = 0; i < oil_tanks.size; i++)
	{
		oil_tanks[i].parent = level.boats[0];
	}
	
	wait(0.05);
	
	//-- dialogue calls based on spline position
	level thread event2_dialogue_splined();
	
	//-- make the 2nd plane shoot
	level.plane_b thread ai_pby_gunners_think();
	
	wait(0.1);
	
	//-- setup the drones on the boats
	level thread event2_setup_first_ship_drones();
	level thread event2_setup_second_ship_drones();
	level thread event2_setup_third_ship_drones();
	
	wait(0.1);
	
	//-- delete the script_model shields
	shields = [];
	shields = GetEntArray("con_tower_shield", "targetname");
	
	for(i=0; i < shields.size; i++)
	{
		shields[i] Delete();
	}
	
	wait(0.1);
	
	//-- setup the audio for the siren alarm
	level thread merchant_boat_siren();
	level thread merchant_boat_1_sounds();
	level thread merchant_boat_3_sounds();
	level thread merchant_boat_pa();
	
	wait(0.1);
	
	//-- setup the debris
	level thread event2_debris_m();
	
	wait(0.25);
	
	for(i = 0; i < level.boats.size; i++)
	{
		
		level.boats[i] thread ms_soldier_triple_25_add_gunners();
		
		//Setup Boat Basics
		level.boats[i].scriptname = "boat_" + i;
		level.boats[i] thread attach_boat_destructibles();
		level.boats[i].animname = "merchant_ship";
		level.boats[i].bow.animname = "merchant_ship";
		level.boats[i].aft.animname = "merchant_ship";
		level.boats[i].alarmed = false;
		level.boats[i] thread merchant_boat_alarm();
		
		//-- sets up the chaining damage for explosions
		level.boats[i] thread setup_merchant_ship_chain_destruction();
				
		//-- Runs the spotlights
		level.boats[i] thread merchant_boat_spots();
		//-- Runs the Flak Cannons
		level.boats[i] thread merchant_boat_trip25();
		//-- Sinks the Boats
		level.boats[i] thread merchant_boat_sink_me();
		wait(0.1);
	}
	
	level thread event2_dialogue_m();
	level thread event2_seat_control_m();
	level thread event2_sink_all_boats();

	//-- controls the PTBoats during the different passes
	level thread event2_ptboat_3rd_pass();
	level thread event2_ptboats_4th_pass();
		
	//--start the strafing music
	level thread maps\pby_fly_amb::start_music_intro_m();
	
	//-- Start Event 3 (Pacing)
	level.plane_a waittill("start_event_3");
	set_objective("back_to_base");
	
	level thread event3();
}

event2_seat_control_m()
{
	level.plane_a waittill("left_turret");
	level.player scripted_turret_switch("pby_leftgun", true);
	
	level.plane_a waittill("right_turret");
	level.player scripted_turret_switch("pby_rightgun", true);
	
	//-- lose all sense of speed from the front turret
	level.plane_a waittill("front_turret");
	level.player scripted_turret_switch("pby_frontgun", true);
	
	level.plane_a waittill("left_turret");
	//MOVE THIS
	level.plane_b notify("stop_shooting");
	level.player thread scripted_turret_switch("pby_leftgun", true);
	level notify("play_2nd_fx");
}

event2_dialogue_m()
{
	//-- getting in close	
	level.plane_a waittill("dialogue_notify");
//	play_sound_over_radio("PBY1_MID_019A_GUN2");
	level anim_single_solo(level.plane_a.pilot, "event2_a_takeusclose");
	
	//-- Last Pass (multiple versions TODO: HOOK THIS UP)
	level.plane_a waittill("front_turret");
	if(true)
	{
		level anim_single_solo(level.plane_a.pilot, "event2_a_lastpass_a");
		level anim_single_solo(level.plane_a.pilot, "event2_a_humblepie");
	}
	else
	{
		level anim_single_solo(level.plane_a.pilot, "event2_a_lastpass_b");
	}
			
	//-- Event 2  Evaluation (not in yet)
	level.plane_a waittill("dialogue_notify");
	if(true)		// job well done
	{
		level anim_single_solo(level.plane_a.pilot, "event2_a_nicejob");
//		play_sound_over_radio("PBY1_MID_028A_PLT2");
//		play_sound_over_radio("PBY1_MID_029A_GUN2");
		level anim_single_solo(level.plane_a.pilot, "event2_a_goodwork");
	}
	else		// or not so well done
	{
//		play_sound_over_radio("PBY1_MID_031A_GUN2");
//		play_sound_over_radio("PBY1_MID_032A_GUN2");
		level anim_single_solo(level.plane_a.pilot, "event2_a_didwhatcould");
	}
	
	level thread delete_all_ms_guys();
		
	level.plane_a notify("start_event_3");
}

event2_debris_m()
{
	for(i = 0; i < level.debris_turn_1.size; i++)
	{
		level.debris_turn_1[i] thread debris_float_away();
	}
	
	level.plane_a waittill("ev2_debris_turn3");
	
	level thread kill_all_ms_guys();
	level thread remove_metal_clip();
	
	for(i = 0; i < level.debris_turn_3.size; i++)
	{
		level.debris_turn_3[i] thread debris_float_away();
		if(IsDefined(level.debris_turn_3[i].script_string))
		{
			playfx(level._effect["debris_fire"], level.debris_turn_3[i].origin);
		}
	}
	
	event2_debris_cleanup();
}

event2_ptboat_2nd_pass_m()
{
	wait(2);
	
	the_ptboat = undefined;
	ptboat_paths = [];
	
	ptboat_paths[0] = GetVehicleNode("auto783", "targetname");
	ptboat_paths[1] = GetVehicleNode("auto777", "targetname");
	ptboat_paths[2] = GetVehicleNode("auto1309", "targetname");
		
	for(i = 0; i < ptboat_paths.size; i++)
	{
		the_ptboat = SpawnVehicle( "vehicle_jap_ship_ptboat", "new_boat", "jap_ptboat", (0,0,0), (0,0,0) );
		the_ptboat.vehicletype = "jap_ptboat";
		maps\_vehicle::vehicle_init(the_ptboat);
		the_ptboat AttachPath(ptboat_paths[i]);
		the_ptboat thread maps\_vehicle::vehicle_paths(ptboat_paths[i]);
		the_ptboat thread ptboat_delete_at_end_of_path();
		the_ptboat StartPath();
		the_ptboat playloopsound("merchant_engines");
		the_ptboat.health = 600; //-- because they are hard to hit when banking
		
		wait(0.05);
	}
}

fletcher_ai_turret_think( target_vehicle_type, gunner_tag, gun_number )
{
	self endon("stop firing");
	
	//-- incase a bunch are initialized at once
	random_wait = RandomFloatRange(1.0, 8.0);
	wait(random_wait);
		
	my_array = [];
	target_array = [];
	
	while(1)
	{
		my_array = [];
		target_array = [];
		
		my_array = GetEntArray("script_vehicle", "classname");
	
		//-- find a vehicle
		for(i = 0; i < my_array.size; i++)
		{
			if(my_array[i].vehicletype == target_vehicle_type && !IsDefined(my_array[i].dont_target))
			{
				target_array[target_array.size] = my_array[i];
			}
		}
	
		//-- find the closest one
		//-- Sort the lowest distance target to index [0]
		for(i=1; i < target_array.size; i++)
		{
			potential_target = target_array[i];
			
			if(!IsDefined(potential_target))
			{
				continue;
			}
			
			dist_1 = Distance2d(target_array[i].origin, self GetTagOrigin(gunner_tag));
			dist_2 = Distance2d(target_array[0].origin, self GetTagOrigin(gunner_tag));
			
			if(dist_1 < dist_2)
			{
				holder = target_array[0];
				target_array[0] = target_array[i];
				target_array[i] = holder;
			}
		}
		
		//-- shoot at that target until it is destroyed or too far away
		target = target_array[0];
		
		if(!IsDefined(target))
		{
			wait(1);
			continue;
		}
		
		self setgunnertargetent( target, (0,0,0), gun_number );
				
		while(IsDefined(target))
		{
			//if( Distance2d(target.origin, self.origin) > 5000 )
			if( Distance2d(target.origin, self.origin) > 3000 )
			{
				target = undefined;
			}
			else
			{
				self firegunnerweapon(gun_number);
			}
			
			wait(0.28);
		}
		
		random_wait = RandomFloatRange(1.0, 3.0);
		wait(random_wait);
	}
}


swap_model_for_fletcher( _targetname ) //-- Allow us to keep the number of vehicles down until we actually need them (saves especially on missiles)
{
	_model = GetEnt( _targetname, "targetname" );
	hold_origin = _model.origin;
	hold_angles = _model.angles;
	
	_model Delete();
	
	fletcher = SpawnVehicle( "vehicle_usa_ship_fletcher_hull", "new_fletcher", "fletcher_destroyer", hold_origin, hold_angles );
	fletcher.vehicletype = "fletcher_destroyer";
	maps\_vehicle::vehicle_init(fletcher);
	
	return fletcher;
}

fletcher_init()
{
	if(!IsDefined(level.used_fletcher_names))
	{
		level.used_fletcher_names = 0;
	}
	
	//-- This assembles the Fletcher vehicle
	self.vehicletype = "fletcher_destroyer";
	
	x = self;
	
	x_forward = AnglesToForward(x.angles);
	x_right = AnglesToRight(x.angles);
	x_up = AnglesToUp(x.angles);
	
	//-- add chunks
	x.chunk_1 = Spawn("script_model", (0,0,0));
	x.chunk_1 SetModel("vehicle_usa_ship_fletcher_chunk1");
	x.chunk_1.origin = x.origin + (804 * x_forward) + (412.24 * x_up);
	x.chunk_1.angles = x.angles;
	x.chunk_1.script_noteworthy = "ev4_obj";
	
	x.chunk_2 = Spawn("script_model", (0,0,0));
	x.chunk_2 SetModel("vehicle_usa_ship_fletcher_chunk2");
	x.chunk_2.origin = x.origin + (622 * x_forward) + (1.62 * x_right) + (273.16 * x_up);
	x.chunk_2.angles = x.angles;
	x.chunk_2.script_noteworthy = "ev4_obj";
	
	x.chunk_3 = Spawn("script_model", (0,0,0));
	x.chunk_3 SetModel("vehicle_usa_ship_fletcher_chunk3");
	x.chunk_3.origin = x.origin + (534.5 * x_forward) + (1.62 * x_right) + (233.45 * x_up);
	x.chunk_3.angles = x.angles;
	x.chunk_3.script_noteworthy = "ev4_obj";
	
	x.chunk_4 = Spawn("script_model", (0,0,0));
	x.chunk_4 SetModel("vehicle_usa_ship_fletcher_chunk4");
	x.chunk_4.origin = x.origin + (222 * x_forward) + (1.62 * x_right) + (258.65 * x_up);
	x.chunk_4.angles = x.angles;
	x.chunk_4.script_noteworthy = "ev4_obj";
	
	x.chunk_5 = Spawn("script_model", (0,0,0));
	x.chunk_5 SetModel("vehicle_usa_ship_fletcher_chunk5");
	x.chunk_5.origin = x.origin + (-321 * x_forward) + (1.62 * x_right) + (243.86 * x_up);
	x.chunk_5.angles = x.angles;
	x.chunk_5.script_noteworthy = "ev4_obj";
	
	//-- add turret guns and barrels
	x.turret_1 = Spawn("script_model", (0,0,0));
	x.turret_1 SetModel("vehicle_usa_ship_fletcher_turretgun");
	x.turret_1.origin = x.origin + (1515.12 * x_forward) + (0.28 * x_right) + (255.9 * x_up);
	x.turret_1.angles = x.angles;
	x.turret_1.script_noteworthy = "ev4_obj";
	x.turret_1_barrel = Spawn("script_model", (0,0,0));
	x.turret_1_barrel SetModel("vehicle_usa_ship_fletcher_turretgun_barrel");
	x.turret_1_barrel.origin = x.origin + (1537 * x_forward) + (0.28 * x_right) + (315.7 * x_up);
	x.turret_1_barrel.angles = x.angles;
	x.turret_1_barrel.script_noteworthy = "ev4_obj";
	
	x.turret_2 = Spawn("script_model", (0,0,0));
	x.turret_2 SetModel("vehicle_usa_ship_fletcher_turretgun");
	x.turret_2.origin = x.origin + (1209.3 * x_forward) + (0.28 * x_right) + (339.23 * x_up);
	x.turret_2.angles = x.angles;
	x.turret_2.script_noteworthy = "ev4_obj";
	x.turret_2_barrel = Spawn("script_model", (0,0,0));
	x.turret_2_barrel SetModel("vehicle_usa_ship_fletcher_turretgun_barrel");
	x.turret_2_barrel.origin = x.origin + (1231.23 * x_forward) + (0.28 * x_right) + (399 * x_up);
	x.turret_2_barrel.angles = x.angles;
	x.turret_2_barrel.script_noteworthy = "ev4_obj";
	
	x.turret_3 = Spawn("script_model", (0,0,0));
	x.turret_3 SetModel("vehicle_usa_ship_fletcher_turretgun");
	x.turret_3.origin = x.origin + (-738.18 * x_forward) + (0.28 * x_right) + (267.31 * x_up);
	x.turret_3.angles = x.angles;
	x.turret_3.script_noteworthy = "ev4_obj";
	x.turret_3_barrel = Spawn("script_model", (0,0,0));
	x.turret_3_barrel SetModel("vehicle_usa_ship_fletcher_turretgun_barrel");
	x.turret_3_barrel.origin = x.origin + (-760.1 * x_forward) + (0.28 * x_right) + (327.14 * x_up);
	x.turret_3_barrel.angles = x.angles;
	x.turret_3_barrel.script_noteworthy = "ev4_obj";
	
	x.turret_4 = Spawn("script_model", (0,0,0));
	x.turret_4 SetModel("vehicle_usa_ship_fletcher_turretgun");
	x.turret_4.origin = x.origin + (-1244.29 * x_forward) + (0.28 * x_right) + (267.31 * x_up);
	x.turret_4.angles = x.angles;
	x.turret_4.script_noteworthy = "ev4_obj";
	x.turret_4_barrel = Spawn("script_model", (0,0,0));
	x.turret_4_barrel SetModel("vehicle_usa_ship_fletcher_turretgun_barrel");
	x.turret_4_barrel.origin = x.origin + (-1266.21 * x_forward) + (0.28 * x_right) + (327.14 * x_up);
	x.turret_4_barrel.angles = x.angles;
	x.turret_4_barrel.script_noteworthy = "ev4_obj";
	
	x.turret_5 = Spawn("script_model", (0,0,0));
	x.turret_5 SetModel("vehicle_usa_ship_fletcher_turretgun");
	x.turret_5.origin = x.origin + (-1549.17 * x_forward) + (0.28 * x_right) + (163.05 * x_up);
	x.turret_5.angles = x.angles;
	x.turret_5.script_noteworthy = "ev4_obj";
	x.turret_5_barrel = Spawn("script_model", (0,0,0));
	x.turret_5_barrel SetModel("vehicle_usa_ship_fletcher_turretgun_barrel");
	x.turret_5_barrel.origin = x.origin + (-1571.09 * x_forward) + (0.28 * x_right) + (222.88 * x_up);
	x.turret_5_barrel.angles = x.angles;
	x.turret_5_barrel.script_noteworthy = "ev4_obj";
	
	//-- Add Oerlikons (1-4, 6-9 added on clientside)
	
	x.oerlikon_5 = Spawn("script_model", (0,0,0));
	x.oerlikon_5 SetModel("vehicle_usa_ship_fletcher_oerlikon");
	x.oerlikon_5.origin = x.origin + ( -915.28 * x_forward) + ( -190.13 * x_right) + ( 144.93 * x_up);
	x.oerlikon_5.angles = x.angles;
	x.oerlikon_5.script_noteworthy = "ev4_obj";
	x.oerlikon_5_barrel = Spawn("script_model", (0,0,0));
	x.oerlikon_5_barrel SetModel("vehicle_usa_ship_fletcher_oerlikon_barrel");
	x.oerlikon_5_barrel.origin = x.origin + ( -916.13 * x_forward) + ( -171.68 * x_right) + ( 193.15 * x_up);
	x.oerlikon_5_barrel.angles = x.angles;
	x.oerlikon_5_barrel.script_noteworthy = "ev4_obj";
	
	self thread fletcher_ai_turret_think( "zero", "tag_gunner_turret1", 0 );
	self thread fletcher_ai_turret_think( "zero", "tag_gunner_turret2", 1 );
	self thread fletcher_ai_turret_think( "zero", "tag_gunner_turret3", 2 );
	self thread fletcher_ai_turret_think( "zero", "tag_gunner_turret4", 3 );
	
		
	//random_name = RandomInt(level.ship_names.size);
	random_name = level.used_fletcher_names;
	level.used_fletcher_names++;
	
	self SetVehicleLookAtText( level.ship_names[random_name], &"VEHICLENAME_FLETCHER");
	
	self.decal = spawn("script_model", self.origin);
	self.decal SetModel( "vehicle_usa_ship_fletcher_decal" + random_name );
	self.decal.angles = self.angles;
	//self Attach( "vehicle_usa_ship_fletcher_decal" + random_name );
	//level.ship_names = array_remove(level.ship_names, level.ship_names[random_name]);
}

/*
draw_line_to_gun(gun, barrel)
{
	while(1)
	{
		Line(self.origin, gun.origin, (1, 0, 0));
		Line(self.origin, barrel.origin, (0, 1, 0));
		wait(0.05);
	}
}
*/

fletcher_ai_biggun_think( gun, barrel )
{
	self endon("death");
	self endon("stop_big_guns");
		
	max_pitch = 330;
	min_pitch = 270;
	
	//self thread draw_line_to_gun(gun, barrel);
	barrel.angles = (300, barrel.angles[1], barrel.angles[2]);
	
	barrel LinkTo(gun);
	
	while(1)
	{
		random_yaw = RandomIntRange(15, 110);
		pos_or_neg = RandomInt(2);
		
		
		for(i = 0; i < random_yaw; i++)
		{
			if(pos_or_neg)
			{
				gun RotateYaw( 1, 0.05);
			}
			else
			{
				gun RotateYaw( -1, 0.05);
			}
			
			wait(0.1);
		}
		
		random_pitch = RandomIntRange(min_pitch, max_pitch);
		up = false;
		if(random_pitch > barrel.angles[0])
		{
			random_pitch = random_pitch - barrel.angles[0];
			up = true;
		}
		else
		{
			random_pitch = barrel.angles[0] - random_pitch;
			up = false;
		}
			
		barrel Unlink();
	
		ASSERTEX(random_pitch >= 0, "the Random pitch was negative");
		for( i = 0; i < random_pitch; i++)
		{
			if(up)
			{
				barrel RotatePitch( 1, 0.05);
			}
			else
			{
				barrel RotatePitch( -1, 0.05);
			}
			
			wait(0.05);
		}
						
		barrel LinkTo(gun);
		
		barrel fletcher_ai_biggun_fire();
	}
}

fletcher_ai_biggun_fire(barrel)
{
	fire_times = RandomIntRange(2, 5);
	
	wait(1);
	
	for(i = 0; i < fire_times; i++)
	{
		PlayFXOnTag(level._effect["fletcher_5in"], self, "turretgun_flash_1");
		wait(1);
	}
}

front_hit_fletcher_kamikaze_gun_1( guy )
{
	ship = GetEnt("ship_number_2", "targetname");
	ship.turret_1 UseAnimTree( #animtree );
	ship.turret_1.animname = "fletcher";
	ship.turret_1_barrel UseAnimTree( #animtree );
	ship.turret_1_barrel.animname = "fletcher";
	
	ship.turret_1 thread anim_single_solo( ship.turret_1, "fletcherhit_front_gun1base" );
	ship.turret_1_barrel thread anim_single_solo( ship.turret_1_barrel, "fletcherhit_front_gun1barrel" );
}

front_hit_fletcher_kamikaze_gun_2( guy )
{
	ship = GetEnt("ship_number_2", "targetname");
	ship.turret_2 UseAnimTree( #animtree );
	ship.turret_2.animname = "fletcher";
	ship.turret_2_barrel UseAnimTree( #animtree );
	ship.turret_2_barrel.animname = "fletcher";
	
	ship.turret_2 thread anim_single_solo( ship.turret_2, "fletcherhit_front_gun2base" );
	ship.turret_2_barrel thread anim_single_solo( ship.turret_2_barrel, "fletcherhit_front_gun2barrel" );
}
	
front_hit_fletcher_kamikaze_chunk_1( guy )
{
	ship = GetEnt("ship_number_2", "targetname");
	ship.chunk_1 UseAnimTree( #animtree );
	ship.chunk_1.animname = "fletcher";
	
	ship.chunk_1 thread anim_single_solo( ship.chunk_1, "fletcherhit_front_chunk1" );
}

fletcher_animation( _targetname, _case )
{
	fletcher = GetEnt(_targetname, "targetname");
	
	self waittill("reached_end_node");
	
	switch(_case)
	{
		case 0: //-- middle of first fletcher hit
			exploder(100);
		
			fletcher.chunk_5 UseAnimTree( #animtree );
			fletcher.chunk_5.animname = "fletcher";
			fletcher.turret_3 UseAnimTree( #animtree );
			fletcher.turret_3.animname = "fletcher";
			fletcher.turret_3_barrel UseAnimTree( #animtree );
			fletcher.turret_3_barrel.animname = "fletcher";
			fletcher.oerlikon_5 UseAnimTree( #animtree );
			fletcher.oerlikon_5.animname = "fletcher";
			fletcher.oerlikon_5_barrel UseAnimtree( #animtree );
			fletcher.oerlikon_5_barrel.animname = "fletcher";
			
			fletcher.chunk_5 thread anim_single_solo(fletcher.chunk_5, "fletcherhit_right_chunk5plate");
			fletcher.turret_3 thread anim_single_solo(fletcher.turret_3, "fletcherhit_right_turret");
			fletcher.turret_3_barrel thread anim_single_solo(fletcher.turret_3_barrel, "fletcherhit_right_turretbarrel");
			fletcher.oerlikon_5 thread anim_single_solo(fletcher.oerlikon_5, "fletcherhit_right_oerlikon");
			fletcher.oerlikon_5_barrel thread anim_single_solo(fletcher.oerlikon_5_barrel, "fletcherhit_right_oerlikonshield");
						
		break;
		case 1: //-- nose of first fletcher hit
		
			exploder(101);
			
			fletcher.chunk_2 UseAnimTree( #animtree );
			fletcher.chunk_2.animname = "fletcher";
			fletcher.chunk_3 UseAnimTree( #animtree );
			fletcher.chunk_3.animname = "fletcher";
			fletcher.chunk_4 UseAnimTree( #animtree );
			fletcher.chunk_4.animname = "fletcher";
			fletcher.chunk_5 UseAnimTree( #animtree );
			fletcher.chunk_5.animname = "fletcher";
			
			fletcher.chunk_2 thread anim_single_solo(fletcher.chunk_2, "fletcherhit_right_chunk2");
			fletcher.chunk_3 thread anim_single_solo(fletcher.chunk_3, "fletcherhit_right_chunk3");
			fletcher.chunk_4 thread anim_single_solo(fletcher.chunk_4, "fletcherhit_right_chunk4tower");
			fletcher.chunk_5 thread anim_single_solo(fletcher.chunk_5, "fletcherhit_right_chunk5tower");
		break;
		case 2:
			exploder(400);
		break;
		case 3:
			exploder(403);
		break;
		
		//-- Rescue 3
		case 10:
			exploder(1200);
			break;
		case 11:
			exploder(1201);
		break;
		case 12:
			exploder(1202);
		break;
		case 13:
			exploder(1203);
		break;
		case 14:
			exploder(1204);
		break;
		case 15:
			exploder(1205);
		break;
		default:
		break;
	}
	
	/*
	level.scr_anim["fletcher"]["fletcherhit_right_chunk3"] 					= %o_pby_chunk3_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk4tower"] 		= %o_pby_chunk4tower_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk5"] 					= %o_pby_chunk5_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_chunk2"] 					= %o_pby_chunk2_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right"] 								= %o_pby_fletcher_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_oerlikon"] 			 	= %o_pby_oerlikon_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_oerlikonshield"] 	= %o_pby_oerlikonshield_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_turret"] 					= %o_pby_turret_fletcherhit_right;
	level.scr_anim["fletcher"]["fletcherhit_right_turretbarrel"] 		= %o_pby_turretbarrel_fletcherhit_right;
	*/
}

run_debug_timer()
{
	if(1)
		return;
		
	level.debug_timer = 0; 
	while(true)
	{
		iprintln(level.debug_timer);
		level.debug_timer = level.debug_timer + 0.1;
		wait(0.1);
	}
}

run_pby_tracker()
{
	
	if(true)
	{
		return 1;
	}
	
	
	while(true)
	{
		iprintln( "pby_location A: " + level.plane_a.origin[0] + ", " + level.plane_a.origin[1] + ", " + level.plane_a.origin[2] );
		wait(0.1);
	}	
}


pby_ok_to_spawn(item)
{
	if(true)
	{
		return;
	}
	
	add_to_spawn_array_and_wait();
	
	/*
	if(IsDefined(item))
	{
		switch(item)
		{
			case "zero":
				max_wait_seconds = 300.0;
			break;
			case "ptboat":
				max_wait_seconds = 300.0;
			break;
			case "ai":
				max_wait_seconds = 300.0;
			break;
			case "drone":
				max_wait_seconds = 300.0;
			break;
			default:
				max_wait_seconds = 300.0;
			break;
		}
	}
	else
	{
		max_wait_seconds = 300.0;
	}
	
	ok_to_spawn( max_wait_seconds );
	*/
}

pby_wait_for_free_spawn()
{
	level.entities_waiting_to_spawn = 0;
	level.trying_to_spawn = []; //list of notifies
	
	j = 0;
	
	while(true)
	{
		if(level.trying_to_spawn.size == 0)
		{
			wait(0.05);
		}
		else
		{
			for(i=0; i < 4; i++) //-- hardcoded to 4 things at a time
			{
				j = 0;
				
				if(IsDefined(level.trying_to_spawn[0]) && OkToSpawn())
				{
					level notify(level.trying_to_spawn[0]);
					level.trying_to_spawn = array_remove(level.trying_to_spawn, level.trying_to_spawn[0]);
					j++;
				}
			}
			
			while(!OkToSpawn() || j == 4)
			{
				j = 0;
				wait_network_frame();
			}
			
			wait_network_frame();
		}
	}
}

add_to_spawn_array_and_wait()
{
	level.entities_waiting_to_spawn++;
	level.trying_to_spawn[level.trying_to_spawn.size] = "spawn_notify" + level.entities_waiting_to_spawn;
	level waittill("spawn_notify" + level.entities_waiting_to_spawn);
}

random_turbulence()
{
	level endon("stop turbulence");

	while(1)
	{
		rand_wait = randomfloat(12);
		wait (rand_wait);

		eqtype = randomint(5) + 1;
		source = level.player.origin;

		switch(eqtype)
		{
			case 1:	
				scale = 0.05;
				duration = 2;
				radius = 200;
				earthquake(scale, duration, source, radius);
				playsoundatposition("amb_metal", (0,0,0));
				level.player PlayRumbleOnEntity( "damage_light" );
			break;

			case 2:	
				scale = 0.10;
				duration = 1.5;
				radius = 300;
				earthquake(scale, duration, source, radius);
				playsoundatposition("amb_metal", (0,0,0));
				level.player PlayRumbleOnEntity( "damage_light" );
			break;

      case 3: 
      	scale = 0.15;
        duration = 1.25;
        radius = 400;
        //medium1 = spawn("script_origin", (0,0,0));
        //medium1 playsound ("medium_shake");
        earthquake(scale, duration, source, radius);
        level.player PlayRumbleOnEntity( "damage_light" );
      break;

     case 4: 
     		scale = 0.20;
	      duration = 0.5;
	      radius = 500;
	      //medium1 = spawn("script_origin", (0,0,0));
	      //medium1 playsound ("medium_shake");
	      earthquake(scale, duration, source, radius);
	      level.player PlayRumbleOnEntity( "damage_light" );
	    break;

     case 5: scale = 0.30;
	      duration = 0.8;
	      radius = 600;
	      //big1 = spawn("script_origin", (0,0,0));	
	      //big1 playsound ("big_shake");
	      earthquake(scale, duration, source, radius);
	      level.player PlayRumbleOnEntity( "damage_light" );
     break;
     
     default:
     break;
		}
	}
}

/// FEEDBACK
//
//-- try making this not constant.
static_turbulence()
{
	level endon("stop turbulence");
	source = level.player.origin;

	while(1)
	{
		source = level.player.origin;
		
		if(level.bomber_wind_shake == 0)
		{
			scale = 0.05;
			dur = 0.25;
	
			duration = ((randomfloat(1) * dur) + 0.05);
	
			radius = 1000;
			earthquake(scale, duration, source, radius);
			wait duration;
		}
		else
		if(level.bomber_wind_shake == 1)
		{
			scale = 0.075;
			dur = 0.25;
	
			duration = ((randomfloat(1) * dur) + 0.05);
	
			radius = 1000;
			earthquake(scale, duration, source, radius);
			wait duration;
		}
		else
		if(level.bomber_wind_shake == 2)
		{
			scale = 0.1;
			dur = 0.25;
	
			duration = ((randomfloat(1) * dur) + 0.05);
	
			radius = 1000;
			earthquake(scale, duration, source, radius);
			playsoundatposition("amb_metal", (0,0,0));
			wait duration;
		}
		else
		if(level.bomber_wind_shake == 3)
		{
			scale = 0.15;
			dur = 0.5;
	
			duration = ((randomfloat(1) * dur) + 0.05);
	
			radius = 1000;
			earthquake(scale, duration, source, radius);
			playsoundatposition("amb_metal_medium", (0,0,0));
			wait duration;
		}
		else
		if(level.bomber_wind_shake == 2)
		{
			scale = 0.2;
			dur = 0.75;
	
			duration = ((randomfloat(1) * dur) + 0.05);
			playsoundatposition("amb_metal_heavy", (0,0,0));
			radius = 1500;
			earthquake(scale, duration, source, radius);
			wait duration;
		}
	}
}

scripted_flak_and_shake_above_pby()
{
	//level._effect["flak_single_ambient"]
	
	self endon("stop ambient flak");
	self endon("death");
	self endon("music_end_second_pass");
	
	self waittill("pa_go");
	
	for( ; ; )
	{
		//-- explode some flak over the seat that the player is in and apply some earthquake!
		offset_vec = (0,0,0);
		left_right = 0;
		
		if(level.player.current_seat == "pby_rightgun")
		{
			//offset_vec = (-210, 48, 226);
			offset_vec = (-210, 90, 226);
			left_right = 1;
		}
		else if(level.player.current_seat == "pby_leftgun")
		{
			//offset_vec = (-210, -48, 226);
			offset_vec = (-210, -90, 226);
			left_right = -1;
		}
		
		//-- play the flak effect, a couple of them at a time
		how_many = RandomIntRange(2, 4);
		for(i = 0; i < how_many; i++)
		{
			fx_org = level.plane_a.origin + (AnglesToForward(level.plane_a.angles) * (offset_vec[0] + (left_right * RandomIntRange(150, 300)) )) + (AnglesToUp(level.plane_a.angles)      * (offset_vec[1] + RandomIntRange(250, 400))) + (AnglesToRight(level.plane_a.angles)   * (offset_vec[2] + RandomIntRange(1, 200)));
			playfx(level._effect["flak_one_shot"], fx_org);
			playsoundatposition ("flak_burst_close", (0,0,0));
			//Earthquake(1, 0.12, fx_org, 1000);
			if(i == 0)
			{
				Earthquake(0.7, (0.15 * how_many), fx_org, 1000);
				playsoundatposition("amb_metal", (0,0,0));
				level.player PlayRumbleOnEntity( "damage_light" );
			}
			wait(0.12);
		}	
			
		wait_time = RandomFloatRange(2, 6);
		wait(wait_time);
	}
	
}

sharks_big_group()
{
	level.plane_a waittill("ptboat_l_to_r");
	
	shark_paths = [];
	shark_paths = GetVehicleNodeArray( "shark_big_group", "targetname" );
	
	new_sharks = [];
	for( i=0; i < shark_paths.size; i++)
	{
	
		new_sharks[i] = spawn_and_path_a_shark( shark_paths[i] );
		new_sharks[i] StartPath();
		wait(0.05);
	}
}

sharks_rescue_one()
{
	level.plane_a waittill("rescue1_shark");
	shark_path = GetVehicleNode( "shark_rescue_one", "targetname" );
	
	new_shark = spawn_and_path_a_shark( shark_path );
	new_shark StartPath();
}

pby_player_crash()
{
	flag_wait("player_crashed");
	
	//-- so the player has failed at shooting, at flying and at life.  That's why we are going to crash their plane and attempt
	//-- EARTHQUAKE
	//-- AND STOPPING THE PLANE
	//-- THEN RUN THE ANIMATION
	
	level.plane_a notify("stop_pby_idling");
	
	level.plane_a SetSpeed(0, 10000, 10000);
	level.plane_a thread anim_single_solo( level.plane_a, "player_crash" );
	wait(3);
	maps\_utility::missionFailedWrapper();
}

//-- FROM MAKIN
// Removes "scripted" names from the _names list
filter_out_names()
{
	names = []; 
	names[names.size] = "BM1 Rojas";  	//0
	names[names.size] = "BM2 Harris"; 
	names[names.size] = "BM3 Kraeer";
	names[names.size] = "GR2 Bickell"; 
	names[names.size] = "QM1 McGinley"; 
	names[names.size] = "QM2 Madigan"; 
	names[names.size] = "GR1 Bunting"; 
	names[names.size] = "GR2 Shubert"; 
	names[names.size] = "GR3 Whitney"; 
	names[names.size] = "GM1 Mulcahy"; 
	names[names.size] = "GM1 Monroy";  	//10
	names[names.size] = "GM2 Kocel"; 
	names[names.size] = "GM2 Green"; 
	names[names.size] = "GM3 Silverman"; 
	names[names.size] = "GM3 Corbett"; 
	names[names.size] = "RM2 Smart"; 
	names[names.size] = "TM1 Johnson"; 
	names[names.size] = "TM2 Nelson"; 
	names[names.size] = "SM2 Barron"; 
	names[names.size] = "YN1 Bowen"; 
	names[names.size] = "YN2 Quincy";		//20
	names[names.size] = "YN3 Lattus"; 
	names[names.size] = "Rdm Shields";  //22 -- AI up / Drones down
	
	names[names.size] = "GM1 Adams"; 
	names[names.size] = "GM1 Allen"; 
	names[names.size] = "GM1 Baker"; 
	names[names.size] = "GM1 Brown"; 
	names[names.size] = "GM1 Cook"; 
	names[names.size] = "GM1 Clark"; 
	names[names.size] = "YN1 Davis"; 
	names[names.size] = "YN1 Edwards"; 
	names[names.size] = "YN1 Fletcher"; 
	names[names.size] = "YN1 Groves"; 
	names[names.size] = "YN1 Hammond"; 
	names[names.size] = "YN1 Grant"; 
	names[names.size] = "BM1 Hacker"; 
	names[names.size] = "BM1 Howard"; 
	names[names.size] = "BM1 Jackson"; 
	names[names.size] = "BM1 Jones"; 
	names[names.size] = "BM1 Lee"; 
	names[names.size] = "BM1 Moore"; 
	names[names.size] = "GR1 Nash"; 
	names[names.size] = "GR1 Mitchell"; 
	names[names.size] = "GR1 Osborne"; 


	new_names = []; 

	// Go through all of the names and save out the names that are not being filtered out
	// to a new array( new_names )
	for( i = 0; i < level.names["american"].size; i++ )
	{
		add_name = true; 
		for( q = 0; q < names.size; q++ )
		{
			if( level.names["american"][i] == names[q] )
			{
				add_name = false; 
				break; 
			}
		}

		if( add_name )
		{
			new_names[new_names.size] = level.names["american"][i]; 
		}		
	}

	level.names["american"] = new_names; 
}

//-- Notetracked function
fire_extinguisher( guy )
{
	level.plane_a.radio_sect_fx = level.plane_a spawn_bullet_hole_entity( "vehicle_usa_pby_radiosect_damage02" );
	PlayFX( level._effect["spark"], level.plane_a.radio_sect_fx GetTagOrigin("bullet4"), AnglesToForward(level.plane_a.radio_sect_fx GetTagAngles("bullet4")));
	PlayFXOnTag( level._effect["fire_extinguish"], level.plane_a.radio_sect_fx, "bullet4");
}
//*************************************************** Confront Gettler ***************************************************************//
//	Scripter: Brian Barnes
//	Builder: Dave Harper
//************************************************************************************************************************************//

#include maps\_utility;
#include maps\gettler_util;

#using_animtree ("generic_human");

main()
{
	level.strings["phone1"] =		&"GETTLER_PHONE1_TITLE";
	level.strings["phone1_text"] =	&"GETTLER_PHONE1_TEXT";

	level.strings["phone2"] =		&"GETTLER_PHONE2_TITLE";	// actually phone 3
	level.strings["phone2_text"] =	&"GETTLER_PHONE2_TEXT";

	level.strings["phone3"] =		&"GETTLER_PHONE3_TITLE";	// actually phone 4
	level.strings["phone3_text"] =	&"GETTLER_PHONE3_TEXT";

	level.strings["phone4"] =		&"GETTLER_PHONE4_TITLE";	// actually phone 2
	level.strings["phone4_text"] =	&"GETTLER_PHONE4_TEXT";

	// * This stuff might not get defined before something else needs it * //

	if(!isdefined(level.script))
	{
		level.script = tolower( getdvar( "mapname" ) );
	}

	level.player = getent("player", "classname" );

	//////////////////////////////////////////////////////////////////////////

	SetDVar("sm_lightScore_dynamic", 64);
	SetDVar("sm_lightScore_eyeProject", 32);

	SetDVar("sm_SunSampleSizeNear", 0.4);

	//SetExpFog(“fog near plane”, “fog half plane”, “fog red”, “fog green”, “fog blue”, “Lerp time”, “Fog max”);
	setExpFog(0, 4600, 0.58, 0.60, 0.52, 2.0, 0.55);

	SetSavedDVar("r_godraysPosX2",  "0.958684");
	SetSavedDVar("r_godraysPosY2",  "-0.558298");

	//Optimized buoyancy time settings for Gettler
	//See MikeA if you have any questions
	SetSavedDVar("phys_maxFloatTime", 20000);
	SetSavedDVar("phys_floatTimeVariance", 3000);

	// Vision Set //
	maps\createart\gettler_art::main();

	// * Precaching * //
	maps\gettler_fx::main();
	maps\gettler_anim::main();

	pre_cache();

	// * Flags * //
	// Init the flag for turning on and off the script (int _sea) that moves the sun direction to move the shadows
	flag_init("vesper_alert");

	flag_init("shaking");
	flag_init("tilting");
	flag_init("super_tilt");
	flag_init("front_door_closed");
	flag_init("pulley_lowered");
	flag_init("vesper_boat_escape");
	flag_init("gondola_drop");
	flag_init("stop_blocker");
	flag_init("player_in_water");

	level.blocker_deleted = 0;

	// * Phone Map * //
	PreCacheShader("compass_map_gettler");
	SetMiniMap("compass_map_gettler", 4568, 4408, -3080, -5304);

	// * Setup Vehicles * //
	maps\_gondola::main();
	maps\_gondola::main("v_gondola_flatbottom");
	maps\_motor_boat::main("v_boat_motor_a");
	maps\_motor_boat::main("v_boat_motor_b");

	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	// * Artist Mode * //
	if(Getdvar("artist") == "1")
	{
		maps\_loadout::init_loadout();
		thread infinite_ammo("p99_s");

		// enable front door of gettler building for player
		front_door = GetNodeArray("auto358", "targetname");
		for (i = 0; i < front_door.size; i++)
		{
			front_door[i].no_player = 0;
		}

		// initialize doors
		maps\_doors::main();

		return;
	}

	// * Setup Drones * //

	level.drone_spawnFunction["civilian"][0] = character\character_tourist_1_venice::main;
	level.drone_spawnFunction["civilian"][1] = character\character_tourist_2_venice::main;
	level.drone_spawnFunction["civilian"][2] = character\character_tourist_3_venice::main;
	level.drone_spawnFunction["civilian"][3] = character\character_tourist_3_venice::main;
	level.drone_spawnFunction["civilian_female"][0] = character\character_fem_civ_1_venice::main;
	level.drone_spawnFunction["civilian_female"][1] = character\character_fem_civ_2_venice::main;
	level.drone_spawnFunction["civilian_male"][0] = character\character_tourist_1_venice::main;
	level.drone_spawnFunction["civilian_male"][1] = character\character_tourist_2_venice::main;
	level.drone_spawnFunction["civilian_male"][2] = character\character_tourist_3_venice::main;
	level.drone_spawnFunction["civilian_male"][3] = character\character_tourist_3_venice::main;

	level.drone_spawnFunction["civilian_male1"] = character\character_tourist_1_venice::main;
	level.drone_spawnFunction["civilian_male2"] = character\character_tourist_2_venice::main;
	level.drone_spawnFunction["civilian_male3"] = character\character_tourist_3_venice::main;
	level.drone_spawnFunction["civilian_female1"] = character\character_fem_civ_1_venice::main;
	level.drone_spawnFunction["civilian_female2"] = character\character_fem_civ_2_venice::main;

	maps\_drones::init();

	// * setup mousetraps * //
	maps\_trap_extinguisher::init();
	maps\_trap_electrical_box::init();

	// * Distraction Objects * //
	//maps\_distract_object_small::init();

	level thread floor_tracker();	// just keep track of what floor the player is on

	// * Load * //
	maps\_load::main();
	maps\gettler_load::main();
	maps\gettler_amb::main();
	maps\gettler_mus::main();

	maps\_securitycamera::init(false);

	// * Setup Weapons * //
	//level.player TakeAllWeapons();
	maps\_phone::setup_phone();
	holster_weapons();

	//maps\_chase::debug(true);

	// * Skipto * //
	if ((!maps\gettler_skipto::main()) && (level.script != "gettlertest"))
	{
		level thread objectives(1);
		level thread maps\gettler_vesper::main();
	}

	// * Misc Threads * //
	//level thread gate1();
	level thread give_weapon();
	level thread start_gettler();
	level thread confront_gettler();	// the end fight	
	level thread cleanup();	// cleanup threads
	level thread end_demo();

	// mql 03/07: add atrium script
	level thread maps\gettler_atrium::init();

	// just set this up here so we can get this working.
	level thread blocker_gettler_house(); // jeremyl

	view_cams();

	level thread BEN_hack_shake_screen();

	// ----- Balance Beam Cfg -----------
	SetSavedDVar("bal_move_speed",80.0);
	SetSavedDVar("Bal_wobble_accel", 1.045);
	SetSavedDVar("Bal_wobble_decel", 1.065);
	// ----------------------------------

	wait .05;
	VisionSetNaked("gettler", 0.05);
}

BEN_hack_shake_screen()
{
	for(;;)
	{
		ent = GetEnt("Gettler_BossFight_Spawn_7", "targetname");
		if (isdefined(ent))
		{
			ent waittillmatch("anim_notetrack", "hack_camera_shake");
			earthquake(0.75, 0.75, level.player.origin, 7550);
		}
		wait(0.1);
	}
}

//
//	pre_cache - pre-cache everything that needs to be pre-cached
//
pre_cache()
{
	// characters
	character\character_tourist_1_venice::precache();
	character\character_tourist_2_venice::precache();
	character\character_tourist_3_venice::precache();

	character\character_fem_civ_1_venice::precache();
	character\character_fem_civ_2_venice::precache();

	// cutscenes
	PrecacheCutScene("Gettler_Intro");
	PrecacheCutScene("Gettler_BoatScene");
	PrecacheCutScene("GBF_Vesper_Elevator_Cycle");
	PrecacheCutScene("Gettler_BossFight");
	PrecacheCutScene("Gettler_Death");

	// fx //
	level._effect["fuel_explosion"]		= loadfx("maps/venice/gettler_acetylene_exp");
	level._effect["crash_down"]			= loadfx("maps/venice/gettler_acetylene_exp"); //CG - made this fx the same to save memory
	level._effect["wall_break"]			= level._effect["gettler_falling_debris01"];
	level._effect["switchbox_spark"]	= loadfx("impacts/large_metalhit");

	// shaders //
	PreCacheShader("black");

	// shellshocks //

	PreCacheShellShock("exploder1_shellshock");
	PrecacheShellShock("ac130");

	// precache models
	PrecacheModel( "p_msc_gondola_oar_b" );
	PrecacheModel( "p_msc_suitcase_vesper" );
	PrecacheModel( "p_msc_suitcase_vesper_igc" );
	PrecacheModel( "w_t_bond_phone" );

	// Weapons //
	PrecacheItem("p99");
	//PrecacheItem("phone_p99"); // Cut for now
	PrecacheItem("nailgun");

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

/*
gate1()
{
door_node = GetNode("gate1_node", "targetname");

trig = GetEnt("gate1_close", "targetname");
trig waittill("trigger");

door_node maps\_doors::close_door_from_door_node();
door_node.disabled = true;

level waittill("enable_gate1");

door_node.disabled = false;
}
*/

give_weapon()
{
	if (!IsDefined(level.gave_weapon))
	{
		GetEnt("give_weapon", "script_noteworthy") waittill("trigger");
		// dialog for first enemies

		unholster_weapons();
		level.player SwitchToWeapon( "p99_s" );

		//if (flag("vesper_alert"))
		//{
		//	iPrintLnBold("She's headed your way now.  She said she was followed.");
		//}
		//else
		//{
		//	iPrintLnBold("Radio: She just arrived, sir.  Should be heading your way now.");
		//}

		wait 1;
	}

	level.gave_weapon = true;

	GetEnt( "ent_intro_gate_left", "targetname" ) playsound( "GET_Fence_Close" );
	GetEnt( "ent_intro_gate_left", "targetname" ) RotateTo( (0, 90, 0), 0.25 );
	GetEnt( "ent_intro_gate_right", "targetname" ) RotateTo( (0, 270, 0), 0.25 );

	// notify to remove drones in intro area
	level notify( "delete_drones" );
	level notify( "stop_gondolas" );

	wait 2;

	// vo
	entOrigin = Spawn( "script_origin", (1756, 2214, 308) );
	entOrigin playsound( "GMR1_GettG_014A" );	// "Keep your eyes open, Gettler said she might be followed."

	wait 2;
	level notify("courtyard_go");

	level endon("pillar_guards_cleared");
	flag_wait("pillar_guards_alert");

	entOrigin playsound( "GMR2_GettG_015A" );	// "There he is!"
	//Print3d(entOrigin.origin, "There he is!", (1, 1, 1), 1, 1, 45);


}

infinite_ammo(gun)
{
	while (true)
	{
		level.player SetWeaponAmmoStock("p99", 1000);
		wait 5;
	}
}

start_gettler()
{
	// wait for trigger to start gettler section //
	trigger_wait("gettler_start");

	//Start Stealthy Music - Added by crussom
	level notify("playmusicpackage_stealth");

	// this is a trigger multiple to avoid the case where we start the player inside this trigger and it gets deleted before we get here
	level thread maps\gettler_atrium::gettler_building();
	//iPrintLnBold( "Gettler start trig has been hit." );	

	//level.player playerSetForceCover(true);
	// !DEMO /////////////////////////////////////////

	//iPrintLnBold("- IGC -");

	//level thread lock_player();
	level thread shake();
	//level thread raise_water_level1();

	// DEMO - added	/////////////////////////////////////////////////////
	//spawner = GetEnt("vepser_spawner_gettler", "targetname");
	//level.vesper = spawner StalingradSpawn("vesper");
	//if (!spawn_failed(level.vesper))
	//{
	//	level.vesper thread magic_bullet_shield();
	//}
	// !DEMO ////////////////////////////////////////////////////////////

	//GetNode("front_door_node", "script_noteworthy") thread maps\_doors::open_door_from_door_node();

	// DEMO - added /////////////////////////////////
	//wait 3;
	//level.player playerSetForceCover(false);
	// !DEMO /////////////////////////////////////////

	level thread vesper_dialog();
	level thread close_front_door();

	//return;
	// !DEMO /////////////////////////////////////////////////////////////

	// DEMO - removed ////////////////////////////////////////////////////
	entGuard = GetEnt("ai_courtyard_guard_spawner", "targetname") StalingradSpawn("ai_courtyard_guard");
	entGuard thread check_sight(40, 200);

	vespers_node = GetNode("vesper_meet_gettler", "targetname");
	gettlers_node = GetNode("gettler_meet_vesper", "targetname");

	if (IsDefined(level.vesper))
	{
		level.vesper delete();	// TODO: she should be deleted before this
	}

	spawner = GetEnt("vepser_spawner_gettler", "targetname");
	level.vesper = spawner StalingradSpawn("vesper");
	if (!spawn_failed(level.vesper))
	{
		level.vesper thread magic_bullet_shield();
		level.vesper SetEnableSense(false);
		level.vesper thread fail_mission_on_ai_death();

		level.vesper SetGoalNode(vespers_node);
	}
	else
	{
		assertmsg("Problem spawning Vesper.");
	}

	level.gettler = GetEnt("gettler_spawner", "targetname") StalingradSpawn("gettler");
	if (!spawn_failed(level.gettler))
	{
		level.gettler gun_remove();
		//level.gettler maps\gettler_util::show_label("gettler", "state");
		level.gettler thread magic_bullet_shield();
		//level.gettler SetEngageRule("Never");
		level.gettler SetEnableSense(false);

		level.gettler SetGoalNode(gettlers_node);

		//level.gettler waittill("goal");
		level.vesper waittill("goal");

		gettler_dialog();

		level notify("gettler_objective");

		level thread gettler_walk();
		wait 2;

		//level.vesper thread walk_run_walk_to_node( "nod_elevator_vesper", 300);
		vesper_node = GetNode("nod_elevator_wait_vesper", "targetname");
		level.vesper SetGoalNode(vesper_node);

		level thread remove_player_blocker(entGuard);

		//wait 4;

		//GetEnt("ledge_after_the_jump", "targetname") thread after_the_jump();
		GetEnt("ledge_after_the_jump", "targetname") waittill("trigger");
		level notify("gettler_vesper_teleport");
		wait .5;

		gettler_elevator_node = GetNode("nod_elevator_gettler", "targetname");
		level.gettler Teleport(gettler_elevator_node.origin, gettler_elevator_node.angles, true);
		level.gettler SetGoalNode(gettler_elevator_node);

		vesper_elevator_node = GetNode("nod_elevator_vesper", "targetname");
		level.vesper Teleport(vesper_elevator_node.origin, vesper_elevator_node.angles, true);
		level.vesper SetGoalNode(vesper_elevator_node);

		level notify("remove_player_blocker");

		//level.vesper waittill("goal");
		level.vesper notify("del_suitcase");
		level notify("put_blocker_back");

		// Start physics on house pendulums
		maps\_sea::sea_add_physics_group("chandelier1", 1);
		maps\_sea::sea_add_physics_group("chandelier2", 1);
		maps\_sea::sea_add_physics_group("chandelier3", 1);
		maps\_sea::sea_add_physics_group("big_rope", 1);
		maps\_sea::sea_add_physics_group("rope1", 1);
		maps\_sea::sea_add_physics_group("rope2", 1);

		//level thread keep_them_in_physics();
	}
	else
	{
		assertmsg("Problem spawning Gettler.");
	}
}

gettler_walk()
{
	level endon("gettler_vesper_teleport");

	gettler_node = GetNode("gettler_get_out_of_way", "targetname");
	level.gettler SetGoalNode(gettler_node);
	level.gettler waittill("goal");

	gettler_node = GetNode("nod_elevator_wait_gettler", "targetname");
	level.gettler SetGoalNode(gettler_node);
}

keep_them_in_physics()
{
	while (true)
	{
		dynEnt_StartPhysics("chandelier1");
		dynEnt_StartPhysics("chandelier2");
		dynEnt_StartPhysics("chandelier3");
		dynEnt_StartPhysics("big_rope");
		dynEnt_StartPhysics("rope1");
		dynEnt_StartPhysics("rope2");

		wait .05;
	}
}

remove_player_blocker(entGuard)
{
	//if (entGuard GetAlertState() == "alert_green")
	//{
	//entGuard endon("alert_red");

	blocker = GetEnt("ledge_player_blocker", "targetname");
	level waittill("remove_player_blocker");
	blocker delete();
	//}
}

after_the_jump()
{
	self waittill("trigger");
	level.vesper notify("run_now");
	level.gettler notify("run_now");
}

gettler_dialog()
{
	level endon("ai_courtyard_guard_alert");

	level.vesper play_dialogue("VESP_GettG_056A");

	wait .3;
	//level.gettler CmdPlayAnim("Gen_Civs_StandConversation", false);
	level.gettler play_dialogue("GETT_GettG_057A");
	// 	level.gettler StopCmd();

	wait .3;
	level.vesper play_dialogue("VESP_GettG_058A");

	//level.gettler StopCmd();
	wait .3;
	// 	level.gettler CmdPlayAnim("Gen_Civs_StandConversation", false);
	level.gettler play_dialogue("GETT_GettG_059A");

	level notify("gettler_dialog_finished");
}

ledge_guard()
{
	self notify("imacomputer");
	wait .05;
	self endon("imacomputer");

	level endon("ledge_stop");
	self thread fidget();
	self waittill("alert_red");
	wait .5;

	if (!flag("ledge_stop"))
	{
		ledge_kill();
	}
}

ledge_stop()
{
	flag_init("ledge_stop");
	trig = getent( "trig_ledge_stop", "targetname" );
	trig waittill("trigger");
	flag_set("ledge_stop");

	level.player waittill("mantle_end");
	level.player SetPlayerAngles((0, 270, 0));
}

ledge_kill()
{
	self SetGoalNode(GetNode("ledge_kill_node", "targetname"));
	self waittill("goal");

	if (!flag("ledge_stop"))
	{
		self CmdShootAtEntity(level.player, false, -1, 1);
	}
}

lock_player()
{
	level.player FreezeControls(true);
	wait 10;
	level.player FreezeControls(false);
	flag_set("player_unlocked");
}

//
//	blow_bag1 - scripted explosion of the first air bag as bond walks into the building
//
blow_bag1()
{
	self endon("death");
	self waittill("goal");

	wait 2;
	//self fire_at_target(GetEnt("bag1_target", "targetname")); // BROKEN FOR NEW AI (the animation doesn't work, hangs waiting for notetrack).
	blow_bag("bag1");
}

//
//	objectives - nice linear update of objectives
//
objectives(objective)
{
	if (!IsDefined(objective))
	{
		objective = 1;
	}

	while (true)
	{
		if (objective == 1)
		{
			level waittill("follow_vesper");
			//wait(3);
			new_objective(objective, &"GETTLER_OBJECTIVE_FOLLOW_VESPER1_HEADER", level.vesper.origin, &"GETTLER_OBJECTIVE_FOLLOW_VESPER1_TEXT", level.vesper, GetEnt("objective_courtyard", "targetname").origin);
		}
		else if (objective == 2)
		{
			level waittill("courtyard_go");
			new_objective(objective, &"GETTLER_OBJECTIVE_COURTYARD_HEADER", GetEnt("objective_courtyard", "targetname").origin, &"GETTLER_OBJECTIVE_COURTYARD_TEXT");
		}
		else if (objective == 3)
		{
			flag_wait("atrium_ground_floor_cleared");
			flag_wait("atrium_gate_dude_cleared");
			new_objective(objective, &"GETTLER_OBJECTIVE_FOLLOW_VESPER2_HEADER", GetEnt("objective_boat_yard", "targetname").origin, &"GETTLER_OBJECTIVE_FOLLOW_VESPER2_TEXT");
		}
		else if (objective == 4)
		{
			level waittill("objective_find_a_way");
			new_objective(objective, &"GETTLER_OBJECTIVE_FIND_A_WAY_HEADER", GetEnt("objective_boat_yard", "targetname").origin, &"GETTLER_OBJECTIVE_FIND_A_WAY_TEXT");
		}
		else if (objective == 5)
		{
			level waittill_either("Gettler_BoatScene_Done", "boat_yard_a_alert");
			new_objective(objective, &"GETTLER_OBJECTIVE_BOAT_YARD_HEADER", GetEnt("objective_boat_yard", "targetname").origin, &"GETTLER_OBJECTIVE_BOAT_YARD_TEXT");

			level notify("playmusicpackage_boatyard");

			waittill_aigroupcleared( "boat_yard_a" );
			waittill_aigroupcleared( "boat_yard_a_backup" );
			waittill_aigroupcleared( "boat_yard_b" );
			waittill_aigroupcleared( "boat_yard_c" );

			//End Boatyard Music - Crussom
			level notify("endmusicpackage");

			Objective_Position(objective, GetEnt("objective_house", "targetname").origin);
		}
		else if (objective == 6)
		{
			level waittill("gettler_objective");
			new_objective(objective, &"GETTLER_OBJECTIVE_FOLLOW_VESPER3_HEADER", GetEnt("objective_house", "targetname").origin, &"GETTLER_OBJECTIVE_FOLLOW_VESPER3_TEXT");
		}
		else if (objective == 7)
		{
			level waittill("elevator_moving_up");
			new_objective(objective, &"GETTLER_OBJECTIVE_RESCUE_VESPER_HEADER", level.vesper.origin, &"GETTLER_OBJECTIVE_RESCUE_VESPER_TEXT", level.vesper);
		}

		wait( 0.05 );	//fix for script error of potential infinite loop - jc
		objective++;
	}
}

new_objective(objective, header, origin, text, follow_ent, follow_end_pos)
{
	level notify("objective_update");
	objective_state(objective - 1, "done");
	objective_add(objective, "active", header, origin, text);
	objective_state(objective, "current");

	if (IsDefined(follow_ent))
	{
		level thread objective_follow(objective, follow_ent, follow_end_pos);
	}
}

objective_follow(objective, follow_ent, end_pos)
{
	level endon("objective_update");

	while (IsDefined(follow_ent))
	{
		objective_position(objective, follow_ent.origin);
		wait .3;
	}

	if (IsDefined(end_pos))
	{
		objective_position(objective, end_pos);
	}
}

//
//	bag - air bag setup
//
bag()
{
	// Blow Up! //

	if (IsDefined(self.targetname) && (self.targetname == "exploder"))
	{
		// these are the exploded versions, so we don't need to explode them again
		return;
	}

	self SetCanDamage(true);
	self.finished = false;

	ent = undefined;
	count = 0;

	while (true)
	{
		self waittill("damage", amount, ent);
		if (!(IsDefined(ent) && ( IsPlayer(ent) || (IsDefined(ent.script_noteworthy) && (ent.script_noteworthy == self.script_string)))))
		{
			continue;
		}
		else if (IsPlayer(ent))
		{
			count++;
			if (count > 2)
			{
				break;
			}
		}
		else
		{
			break;
		}
	}

	level thread bag_explode(self);
}

//
//	bag_explode - explode the bags and do other things bassed on which bag it is and stuff
//
bag_explode(bag)
{
	exploder_num = bag.script_exploder;
	bag_name = bag.script_string;

	flag_set(bag_name);

	level thread bag_leak(bag);

	bag waittill("damage");
	bag notify("exploding");

	//level notify("fx_water_boil");
	maps\gettler_water::surface_fx();

	if (IsDefined(bag.primaryEntity))
	{
		bag = bag.primaryEntity;	// playerawareness object.
	}

	if (!IsDefined(level.exploded_bags))
	{
		level.exploded_bags = 0;
	}

	level.exploded_bags++;
	bag_origin = bag.origin;

	player_bag = false;
	if (IsDefined(bag.gettler_player_bag) && bag.gettler_player_bag)
	{
		player_bag = true;
	}

	// Play Sound
	level thread bag_explode_sound(bag_origin);

	bag.bag_collision delete();
	Playfx(level._effect["gettler_airbag_burst1"], bag_origin);
	//Playfx(level._effect["gettler_airbag_venting1"], bag_origin); //using effect from gettler_fx.gsc 
	exploder(exploder_num);	

	// TEMP: fixes broken RadiusDamage

	//ai = GetAIArray("axis");
	//for (i = 0; i < ai.size; i++)
	//{
	//	if ((!IsDefined(ai[i].script_noteworthy)) || (ai[i].script_noteworthy != "gettler"))
	//	{
	//		if (Distance(ai[i].origin, bag.origin) < 400)
	//		{
	//			ai[i] DoDamage(1000, ai[i].origin);
	//		}
	//	}
	//}

	//maps\gettler_util::radius_damage(bag_origin, 300, 400, 200);

	///////////////////////////////////////////

	if (IsDefined(bag_name))
	{
		//flag_set(bag_name);

		if ((!flag(bag_name + "_ok")) || (level.exploded_bags > 2))
		{
			level.exploded_bags = 0; // reset this so we don't raise the water again if the player shoots a bag underwater

			if (!IsDefined(level.dont_raise_water_from_popped_bags))
			{
				level thread maps\gettler_water::raise_water();
				level notify("blow_up_blocker");
			}

			all_bags = GetEntArray("bag", "script_noteworthy");
			for (i = 0; i < all_bags.size; i++)
			{
				if ((all_bags[i].script_exploder != 5) && (all_bags[i].script_exploder != 10))	//	This is the bag we walk over, so don't unlink it yet
				{
					all_bags[i] Unlink();
				}
				else
				{
					level thread unlink_bag5();
				}
			}
		}
		else if (bag_name == "bag1")
		{
			// close the front door and block it with stuff //
			//level thread close_front_door();
			if (level._sea_scale < .3)
			{
				level._sea_scale = .3;
			}
		}
	}

	//RadiusDamage(bag_origin, 500, 300, 0);	// default damage done by most bags
	//maps\gettler_util::radius_damage(bag_origin, 500, 300, 0);
	shake_building(3, .3);

	if (player_bag)
	{
		level notify("player_bag_explode");
	}
}

bag_leak(bag)
{
	bag notify("bag_leak");
	bag.finished = true;

	bag_leak_tag = Spawn("script_model", bag.origin + (0, 0, 60));
	bag_leak_tag SetModel("tag_origin");
	bag_leak_tag.angles = bag.angles;
	bag_leak_tag LinkTo(bag);

	bag thread play_bag_leak_sound(); // sound loop
	//bag_leak_tag show_label("* leaking *", "state");	// change to FX

	// wait for leak sound
	//bag_leak_tag PlaySound("GET_bag_leak");

	PlayFxOnTag(level._effect["gettler_airbag_venting1"], bag_leak_tag, "tag_origin");
	//PlayfxOnTag(level._effect["gettler_airbag_venting1"], bag, "tag_origin");
	//Playfx(level._effect["gettler_airbag_venting1"], bag.origin, AnglesToRight(bag.angles), AnglesToUp(bag.angles));
	//wait 4; // length of FX

	wait_time = 0;
	while (IsDefined(bag))
	{
		wait .5;
		wait_time += .5;
		if (wait_time >= 3)
		{
			bag notify("damage");
		}
	}

	bag_leak_tag delete();
}

bag_explode_sound(origin)
{
	sound_ent = Spawn("script_origin", origin);
	sound_ent PlaySound("GET_bag_explode", "sounddone");
	sound_ent waittill("sounddone");
	sound_ent delete();
}

// blow bag2, bag3, or bag4 if the player doesn't
blow_bag2()
{
	//flag_initialize("group5_cleared");
	//flag_wait("group4_cleared");

	// DEMO - removed //////////////////////
	//flag_wait("player_on_platform");
	// !DEMO ///////////////////////////////

	// DEMO - added ////////////////////////
	//level waittill("oxy_tank_explode");
	// !DEMO ///////////////////////////////

	level thread group4_cleared();
//	level waittill_either("oxy_tank_explode", "group4_cleared");
	level waittill_either3("oxy_tank_explode", "group4_cleared", "bag5_ok");

	// notify oxytank to explode
	//GetEnt("oxytank_trigger", "targetname") notify( "damage", 1, level.player );	// don't force this anymore

	// DEMO - removed //////////////////////
	// delete boards blocking path for guys to spawn and run out next to the leaking bag
	//boards = GetEnt("first_floor_boards", "targetname");
	//boards delete();
	// !DEMO ///////////////////////////////

	// TODO: start leak effect on unblown bag

	bag = undefined;
	if (!flag("bag10"))
	{
		// bag2 is not blown, start effect on bag 2
		bag = GetEnt("bag10", "targetname");
	}
	else if (!flag("bag9"))
	{
		// bag3 is not blown, start effect on bag 3
		bag = GetEnt("bag9", "targetname");
	}
	else if (!flag("bag8"))
	{
		// bag4 is not blown, start effect on bag 4
		bag = GetEnt("bag8", "targetname");
	}

	if (IsDefined(bag))
	{
		flag_clear(bag.targetname + "_ok");
		bag.gettler_player_bag = true;
	}

	if (IsDefined(bag)) // this means the player hasn't blown up this bag (it get's deleted when it blows up)
	{
		blow_bag(bag.targetname);						// TODO: some event needs to blow this bag, we can't just make it blow up (maybe we can if it's leaking).
	}
}

group4_cleared()
{
	flag_wait("group4a_cleared");
	flag_wait("group4b_cleared");
	level notify("group4_cleared");
}

play_bag_leak_sound()	// loop
{
	while (true)
	{
		self PlaySound("GET_bag_leak", "sounddone");
		self waittill("sounddone");
	}
}

// DEMO - added //////////////////////////////////////////////////////////
shoot_at_bags()
{
	level thread kill_shoot_at_bags_guy(self);
	level thread force_blow_bags(self);

	self endon("death");
	self waittill("goal");

	bag_count = 0;	// how many bags have been shot at
	bag = undefined;
	for (i = 0; i < 3; i++)
	{
		if (!flag("bag1"))
		{
			// bag2 is not blown, start effect on bag 2
			bag = GetEnt("bag1", "targetname");
		}
		else if (!flag("bag3"))
		{
			// bag3 is not blown, start effect on bag 3
			bag = GetEnt("bag3", "targetname");
		}
		else if (!flag("bag4"))
		{
			// bag4 is not blown, start effect on bag 4
			bag = GetEnt("bag4", "targetname");
		}

		if (IsDefined(bag))
		{
			//iPrintLnBold("shooting at bag");
			//Print3d(bag.origin, "*", (1, 0, 0), 1, 3, 10000);
			//self CmdShootAtEntity(bag, false, -1);
			self.script_noteworthy = bag.script_string;

			if (bag_count <= 0)	// only shoot one bag, the rest are automatic
			{
				self CmdShootAtPos(bag.origin, false, -1);
				bag_count++;
			}

			level thread damage_bag(bag);
			//flag_wait(bag.targetname);
			bag waittill("bag_leak");
			self StopAllCmds();
			wait .05;
		}
	}
}

// needed to add this because the stupid guy can't hit the bags anymore - just wait a second and force a damage notify to the bag
damage_bag(bag)
{
	wait 1;
	while (IsDefined(bag))
	{
		//bag notify("damage", level.player);
		bag DoDamage(1, bag.origin, level.player);
		wait 1.5;
	}
}

// jeremyl this gets rid of blocker
blocker_gettler_house()
{
	block = getent("blocker_gettler1","targetname");
	block connectpaths();
	block trigger_off();

	/*
	level waittill("put_blocker_back");
	block trigger_on();
	block disconnectpaths();

	level waittill("blow_up_blocker");
	// need to stop this function once it happens once.
	//I placed this little hack even though this gets called multiple times, it only works once.
	if (level.blocker_deleted == 0)
	{
		originfx = getent("blocker_gettler1_effect","targetname");
		// wait till path cleared
		fx = playfx (level._effect["gettler_acetylene_exp"], originfx.origin);
		physicsExplosionSphere( originfx.origin, 300, 200, 4 );
		earthquake( 1.3, 1, originfx.origin, 2000 );
		//	level.player shellshock("default", 3);

		block connectpaths();
		block delete();
		level.blocker_deleted = 1;
	}
	*/
}

// grabbed all top big explosive stuff removed from array control system to make pop the same way everytime.
timed_order_for_4th_floor_explosions()
{

	// exploder1 = GetEnt("4th_floor_pillar1", "script_noteworthy");
	// exploder2 = GetEnt("4th_floor_pillar2", "script_noteworthy");
	// need to grab glass here

	exploders_4th1 = getent("4th_floor_pillar1","script_noteworthy");
	exploders_4th2 = getent("4th_floor_pillar2","script_noteworthy");

	trigger_destruction(exploders_4th1);
	wait( 0.7);
	trigger_destruction(exploders_4th2);
}

set_house_water()
{
	wait(1);
	SetDVar("r_waterWave0Angle", 35);
	SetDVar("r_waterWave0Wavelength", 569);
	SetDVar("r_waterWave0Amplitude", 1.8);
	SetDVar("r_waterWave0Phase", 0.6);
	SetDVar("r_waterWave0Steepness", 0.12);
	SetDVar("r_waterWave0Speed", 1.3);


	SetDVar("r_waterWave1Angle", 156);
	SetDVar("r_waterWave1Wavelength", 368);
	SetDVar("r_waterWave1Amplitude", 1.25);
	SetDVar("r_waterWave1Phase", 0.75);
	SetDVar("r_waterWave1Steepness", 0);
	SetDVar("r_waterWave1Speed", 1.56);

	SetDVar("r_waterWave2Angle", 289);
	SetDVar("r_waterWave2Wavelength", 281);
	SetDVar("r_waterWave2Amplitude", 2);
	SetDVar("r_waterWave2Phase", 1.68);
	SetDVar("r_waterWave2Steepness", 0);
	SetDVar("r_waterWave2Speed", 0.69);
}

kill_shoot_at_bags_guy(guy)
{
	level.shoot_at_bags_guy_kill_trig waittill("trigger");
	if (IsDefined(guy))
	{
		guy delete();
	}
}

force_blow_bags(guy)
{
	guy waittill("death");

	bag = GetEnt("bag1", "targetname");
	if (IsDefined(bag) && (!bag.finished))
	{
		blow_bag(bag.targetname);
	}

	wait 2;

	bag = GetEnt("bag3", "targetname");
	if (IsDefined(bag) && (!bag.finished))
	{
		blow_bag(bag.targetname);
	}

	wait 2;

	bag = GetEnt("bag4", "targetname");
	if (IsDefined(bag) && (!bag.finished))
	{
		blow_bag(bag.targetname);
		// you can remove the blocker here.
	}
}

//raise_water_level1()
//{
//	while (!flag("bag1") || !flag("bag3") || !flag("bag4"))
//	{
//		wait .05;
//	}
//
//	level.exploded_bags = 10; // force water to come up
//}

// !DEMO //////////////////////////////////////////////////////////////

close_front_door()
{
	//if (flag("front_door_closed"))
	//{
	//	return;
	//}
	//else
	//{
	//	level endon("front_door_closed");
	//}

	//inside_guard_spawner = GetEnt("house_guard1", "targetname");
	//inside_guard_spawner waittill("spawned", guy);

	trigger_wait( "close_front_door" );
	flag_set("_sea_physbob");

	level thread ramp_player_speed();	// slow down the player when the building shakes

	level thread set_house_water(); // jeremyl added new water with legend
	level thread shake_building(3, .3);

	// close front door
	//GetEnt("front_door1", "targetname") thread maps\_doors::close_door();	// not open anymore
	//GetEnt("front_door2", "targetname") thread maps\_doors::close_door();
	GetEnt("ent_gettler_door_left", "targetname") RotateTo( (0, 90, 0), 0.25 );

	//door_blocker = GetEnt("door_blocker", "targetname");
	//pos = GetEnt(door_blocker.target, "targetname");

	//time = 1.5;
	//door_blocker MoveTo(pos.origin, time, time);
	//door_blocker RotateTo(pos.angles, time, time);

	//wait time;

	level notify("start_shaking");	// start the thread that shakes the building at intervals
	//flag_set("cargoship_lighting_off");	// this turns it on!

	if (IsDefined(level.sway_facade))
	{
		level.sway_facade LinkTo(level.sea_model);
		level.sway_facade Show();
	}

	//trig delete();
	outside_guard = GetEnt("ai_courtyard_guard", "targetname");
	if (IsDefined(outside_guard))
	{
		outside_guard delete();
	}

	//guy SetAlertStateMin("alert_red");

	flag_set("front_door_closed");
}

//
// unlink_bag5 - unlink the bag that we walk over next time the water rises
//
unlink_bag5()
{
	flag_wait("raising_water");	// make sure the raising_water flag is set before we wait for it to be not set
	flag_waitopen("raising_water");
	flag_wait("raising_water");
	flag_waitopen("raising_water");
	flag_wait("raising_water");

	all_bags = GetEntArray("bag", "script_noteworthy");
	for (i = 0; i < all_bags.size; i++)
	{
		if ((all_bags[i].script_exploder == 5)/* || (all_bags[i].script_exploder == 10)*/)	//	This is the bag we walk over
		{
			all_bags[i] Unlink();
		}
	}
}

//
//	blow_bag - a scripted way to force a bag to blow
//
blow_bag(name)
{
	bag_ents = GetEntArray("bag", "script_noteworthy");
	for (i = 0; i < bag_ents.size; i++)
	{
		if (IsDefined(bag_ents[i].script_string) && (bag_ents[i].script_string == name))
		{
			// have to hit bags 3 times to blow
			bag_ents[i] notify("damage", 100, level.player);
			wait .05;
			bag_ents[i] notify("damage", 100, level.player);
			wait .05;
			bag_ents[i] notify("damage", 100, level.player);
		}
	}
}

// change run speed
run_to_elevator( junk )
{
	if( IsDefined(self) )
	{
		self SetScriptSpeed("Run");
	}
}

get_in_cage( junk )
{
	if( IsDefined(self) )
	{
		self SetScriptSpeed("walk");
	}
}

//
//	confront_gettler - end brawl
//
confront_gettler()
{
	trig = GetEnt("confront_gettler", "targetname");
	trig waittill("trigger");

	level.vesper notify("stop_vesper_dialogue");

	skylight_org = GetEnt("blow_skylight3", "targetname");
	level thread shake_building(1, .3);
	wait .5;
	RadiusDamage(skylight_org.origin, 80, 20, 20);

	// Force the player to drop any dragged dead bodys
	setDvar( "movebody_enable", 0 );

	//SaveGame("gettler");
	level thread maps\_autosave::autosave_now("gettler");

	//level.vesper show_label("I'm sorry James!", "talk", 3); // TODO: Play Dialog
	//level.vesper play_dialogue_nowait("VESP_GettG_077A");

	//flag_wait("group_4th_floor_cleared");
	level waittill("start_gettler_fight");

	// spawn gettler
	gettler_spawner = GetEnt("gettler_end_spawner", "targetname");
	level.gettler = gettler_spawner StalingradSpawn("gettler");
	level.gettler LockAlertState("alert_green");
	level.gettler SetEnableSense(false);

	//level.vesper show_label("No! James!", "talk", 3); // TODO: Play Dialog
	//level.vesper play_dialogue_nowait("VESP_GettG_087A");	//You can’t help me.  Now go.

	level notify("update_objective");

	// TODO: throw player back animation

	// hide player and vesper
	level.vesper Hide();
	level.gettler Hide();
	level.player HideViewModel();

	fake_gun = GetEnt("nailgun", "targetname");
	fake_gun delete();

	level.hud_black.alpha = 1;

	// play cutscene
	level thread letterbox_on( false, true, 1, false );
	VisionSetNaked("gettler_end", 0.0);

	ForcePhoneActive(false);	// make sure phone is closed

	PlayCutScene( "Gettler_BossFight", "scene_anim_done" );
	level.player PlaySound("GET_FinalCinematic_Foley");
	//level.player PlaySound("GET_FinalCinematic_VO");

	// Stick player to landing spot //
	level.player AllowCrouch(false);
	landing_org = GetEnt("bond_landing", "targetname");
	level.player setorigin( landing_org.origin );
	level.player setplayerangles( landing_org.angles );
	level.player PlayerLinkTo( landing_org );
	//player_stick(true);

	level.player TakeAllWeapons();

	level.hud_black fadeOverTime(.5);		// fade int
	level.hud_black.alpha = 0;

	level waittill( "scene_anim_done" );

	// Spawn Gettler //
	level thread letterbox_off( false );
	//gettler_spawner = GetEnt("gettler_end_spawner", "targetname");
	//level.gettler = gettler_spawner StalingradSpawn("gettler");
	//level.gettler LockAlertState("alert_green");
	//level.gettler SetEnableSense(false);
	//trig = GetEnt("trigger_pickup_nailgun", "targetname");
	//gun = Spawn("weapon_nailgun", fake_gun.origin); // TODO: put in when you get the gun from moditch

	// show player & vesper
	level.vesper Show();
	level.gettler Show();
	level.player ShowViewModel();

	// TODO: fade black out
	//level thread poison_effect();
	level thread fade_out_black( 3.0, false, false );

	//level.hud_black.alpha = 1;
	//level.hud_black fadeOverTime(3); 
	//level.hud_black.alpha = 0;

	//trig waittill("trigger");
	//trig delete();

	level.gettler thread shoot_eye_achievement();

	level.player GiveWeapon("nailgun");
	level.player SwitchToWeapon("nailgun");
	//level.player GiveWeapon("p99");
	//level.player SwitchToWeapon("p99");

	//level thread gettler_end_fail();
	level thread gettler_end_win();

	// enable gettler
	wait( 2 );

	if (IsDefined(level.gettler) && IsAlive(level.gettler))
	{
		level.gettler LockAlertState("alert_red");
		level.gettler SetEnableSense(true);
		level.gettler SetPerfectSense(true);
	}

	//wait 3;
	//
	//level.gettler SetGoalNode(GetNode("gettler_end_goal", "targetname"));
}

shoot_eye_achievement()	// no longer shoot eye achievment, but instead a one shot kill achievement
{
	eAttacker = undefined;
	while (!IsPlayer(eAttacker))
	{
		self waittill("damage", iDamage, eAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName);
		if (IsPlayer(eAttacker) && !IsAlive(self))
		{
			//iPrintLnBold("You Shot Gettler In The Eye!");
			GiveAchievement("Challenge_Venice");
		}
	}
}

gettler_end_fail()
{
	level.gettler endon("death");
	level.gettler waittill("goal");
	missionFailedWrapper();
}

gettler_end_win()
{
	level.gettler waittill("death");

	skylight_org = GetEnt("blow_skylight2", "targetname");
	level thread shake_building(1, .3);
	wait .5;
	RadiusDamage(skylight_org.origin, 80, 20, 20);

	level notify("endmusicpackage");

	//level.gettler Hide();
	//while( true )
	//{
	//	level.gettler waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName );
	//	if( iDamage > 50 )
	//	{
	//		break;
	//	}
	//}
	//level thread fade_out_black( 1.0, false, true );
	//PlayCutScene( "Gettler_Death", "scene_anim_done" );
	//level waittill( "scene_anim_done" );

	maps\_endmission::nextmission();
}

// stolen poison effect from casino poison
poison_effect()
{
	reviveeffectcenter(1.9, 0.5, 0.8, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97);
	//reviveeffectedge( < blurRadius, Contrast, brightness, desaturation, LTr, LTg, LTb, DTr, DTg, DTb > )
	reviveeffectedge(6.4, 2.84, 0.86, 0.15, 1.8, 2.0, 2.0, 0.33, 0.23, 0.12);
	reviveeffect(true);

	while (true)
	{
		tilt = 10;
		time = RandomFloatRange(2, 4);

		wait(.1);
		tilt_building((RandomFloatRange(tilt/2, tilt), RandomFloatRange(tilt/2, tilt) * RandomInt(2), 0), time);

		wait(.1);
		tilt_building((RandomFloatRange(tilt/2, tilt), RandomFloatRange(tilt/2, tilt) * -1 * RandomInt(2), 0), time);
	}
}

//
//	shake - shake the building for effect if the player's just standing around
shake()
{
	level waittill("start_shaking");	// only do this if the 2nd bag is blown, when things really start falling apart

	i = 0;
	level.shake_time = 0;
	while (true)
	{
		time = (GetTime() - level.shake_time);
		if (time > 6000)
		{
			if (i == 0)
			{
				level thread shake_building(1, .1);
				i++;
			}
			else if (i == 1)
			{
				level thread shake_building(2, .2);
				i++;
			}
			else if (i == 2)
			{
				level thread shake_building(2, .3);
				i = 0;
			}
		}
		wait 1;
	}
}

super_tilt()
{
	level endon("stop_super_tilt");

	flag_set("super_tilt");
	level._sea_viewbob_scale = 1.5;

	//flag_clear("_sea_viewbob");

	//iPrintLnBold("super tilting");

	while (true)
	{
		a = 0;
		b = 0;
		c = 0;

		if (RandomInt(2) % 2)
		{
			a = RandomFloatRange(4, 5.5);
			if (RandomInt(2) % 2)
			{
				a *= -1;
			}
		}
		else
		{
			c = RandomFloatRange(4, 5.5);
			if (RandomInt(2) % 2)
			{
				c *= -1;
			}
		}

		b = RandomFloatRange(1, 3);
		if (RandomInt(2) % 2)
		{
			b *= -1;
		}

		angles = (a, b, c);
		level thread tilt_building(angles, RandomFloatRange(5, 7));
		flag_waitopen("tilting");
		wait 1;
		level thread tilt_building(vector_multiply(angles, -1), RandomFloatRange(5, 7));
		flag_waitopen("tilting");
		wait 1;
	}
}

stop_super_tilt()
{
	level notify("stop_super_tilt");
	flag_clear("super_tilt");
	//level._sea_viewbob_scale = 1;

	//iPrintLnBold("super tilting stopped");
}

// This function will no twork until we have support for dynamically changing the player speed
ramp_player_speed()
{
	SetDvar("player_speedScaleDebug", "1");

	//level thread debug_speed();

	while (true)
	{
		flag_wait("shaking");
		level thread maps\_load::waterThink_rampSpeed(.5, 1);	// stolen from the water stuff in _load, but works just as well for this

		flag_waitopen("shaking");
		level thread maps\_load::waterThink_rampSpeed(level.default_run_speed, 2);
	}
}

debug_speed()
{
	while (true)
	{
		wait .5;
		iPrintLnBold(GetDVarFloat("player_runSpeedScale"));
	}
}

floor_tracker()
{
	flag_initialize("player_2nd_floor");
	flag_initialize("player_3rd_floor");
	flag_initialize("player_4th_floor");

	level.active_floor = 0;

	while (true)
	{
		z = level.player.origin[2];
		if (z > 550)
		{
			if (level.active_floor != 4)
			{
				maps\_sea::sea_add_physics_group("sea_physics_floor4", 2);

				//maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);

				// up the scale of the stuff hanging on the ceiling
				maps\_sea::sea_add_physics_group("chandelier1", 1.5);
				maps\_sea::sea_add_physics_group("chandelier2", 1.5);
				maps\_sea::sea_add_physics_group("chandelier3", 1.5);
				maps\_sea::sea_add_physics_group("big_rope", 1.5);
				maps\_sea::sea_add_physics_group("rope1", 1.5);
				maps\_sea::sea_add_physics_group("rope2", 1.5);

				flag_set("player_4th_floor");
				level.active_floor = 4;

				flag_clear("player_2nd_floor");
				flag_clear("player_3rd_floor");

				// turn on dynamic light for boss battle
				level.light_final SetLightIntensity(level.light_final.light_intensity);

				//DEBUG
				//iPrintLn("4th floor");
			}
		}
		else if (z > 400)
		{
			if (level.active_floor != 3)
			{
				level._sea_flip_rotation = true;

				maps\_sea::sea_add_physics_group("sea_physics_floor3", 1.8);
				//maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

				flag_set("player_3rd_floor");
				level.active_floor = 3;

				flag_clear("player_2nd_floor");
				flag_clear("player_4th_floor");

				//DEBUG
				//iPrintLn("3rd floor");
			}
		}
		else if (z > 250)
		{
			if (level.active_floor != 2)
			{
				maps\_sea::sea_add_physics_group("sea_physics_floor2", 1.8);
				//maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

				flag_set("player_2nd_floor");
				level.active_floor = 2;

				flag_clear("player_3rd_floor");
				flag_clear("player_4th_floor");

				//DEBUG
				//iPrintLn("2nd floor");
			}
		}
		else if (level.active_floor != 1)
		{
			//maps\_sea::sea_add_physics_group("sea_physics_floor1", 1.8);
			maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
			maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);
			maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

			level.active_floor = 1;
			flag_clear("player_2nd_floor");
			flag_clear("player_3rd_floor");
			flag_clear("player_4th_floor");

			//DEBUG
			//iPrintLn("1st floor");
		}

		wait .5;
	}
}

cleanup()
{
	level thread scrub_zone1();
	level thread scrub_zone2();
	level thread scrub_zone3();
	level thread scrub_zone4();
	level thread scrub_zone5();
	level thread scrub_zone7();
}

scrub_zone1()
{
	GetEnt("give_weapon", "script_noteworthy") waittill("trigger");
	scrub_zone("zone1", true, true, "drone", "targetname");
}

scrub_zone2()
{
	GetEnt("zone4", "script_noteworthy") waittill("trigger");
	scrub_zone("zone2", true, true, "drone", "targetname");
}

scrub_zone3()
{
	GetEnt("zone4", "script_noteworthy") waittill("trigger");
	scrub_zone("zone3", true, true);
}

scrub_zone4()
{
	GetEnt("zone7", "script_noteworthy") waittill("trigger");	
	scrub_zone("zone4", true, true);
}

scrub_zone5()
{
	GetEnt("zone7", "script_noteworthy") waittill("trigger");
	scrub_zone("zone5", true, true);
}

scrub_zone7()
{
	GetEnt("zone6", "script_noteworthy") waittill("trigger");
	scrub_zone("zone7", true, true);
}

pillar_guard1()
{
	self endon("alert_red");
	self endon("death");

	//if (self GetAlertState() == "alert_green")
	//{
	//	level waittill("guard1");
	//	self dialog(undefined, "We hold our position in case she was followed.", 4);
	//	level notify("guard2");

	//	level waittill("guard1");
	//	self dialog(undefined, "I don't know.  But whatever she's got, the Organization wants it.", 3);
	//}
	//else
	//{
	//	level waittill("guard1");
	//	self dialog(undefined, "Hold our position.  And if anyone comes after her, we take them out.", 4);
	//}

}

pillar_guard2()
{
	self endon("alert_red");
	self endon("death");

	//wait 2;
	//if (self GetAlertState() == "alert_green")
	//{
	//	self dialog(undefined, "What now?", 2);
	//	level notify("guard1");
	//
	//	level waittill("guard2");
	//	self dialog(undefined, "Who is this woman?  Why is she so important?", 3);
	//	level notify("guard1");
	//}
	//else
	//{
	//	self dialog(undefined, "What does he want us to do?", 3);
	//	level notify("guard1");
	//}
}

middle_guard1()
{
	self endon("alert_red");
	self endon("death");

	//if (self GetAlertState() == "alert_green")
	//{
	//	self dialog(undefined, "If she was followed, they're doing a good job of hiding it.", 4);
	//	level notify("guard2");

	//	level waittill("guard1");
	//	self dialog(undefined, "Stay alert.  This isn't over yet.", 3);
	//}
	//else
	//{
	//	self dialog(undefined, "Stay alert.  The woman said she was followed.", 4);	// This needs to change
	//	level notify("guard2");

	//	level waittill("guard1");
	//	self dialog(undefined, "She only mentioned one.  Just make sure this is as far as he gets.", 4);
	//	level notify("guard2");
	//}

}

middle_guard2()
{
	self endon("alert_red");
	self endon("death");

	//if (self GetAlertState() == "alert_green")
	//{
	//	self dialog(undefined, "I didn't see anyone either.  I think she came alone.", 4);
	//	level notify("guard1");
	//}
	//else
	//{
	//	level waittill("guard2");
	//	self dialog(undefined, "How many?", 2);
	//	level notify("guard1");

	//	level waittill("guard2");
	//	self dialog(undefined, "Understood", 2);
	//}
}

// jeremy timed explosion for end now.
end_demo()
{
	//	flag_wait("player_4th_floor");

	//level thread trigger_top_destruction();

	trig = GetEnt("end_demo", "targetname");
	trig waittill("trigger");

	//script_flag_true player_4th_floor
	//targetname end_demo

	//jeremyl
	level thread timed_order_for_4th_floor_explosions();
	wait( 1.3 );

	skylight_org = GetEnt("blow_skylight", "targetname");
	RadiusDamage(skylight_org.origin, 80, 20, 20);

	if (IsDefined(trig))
	{
		trig delete();
	}
}

//trigger_top_destruction()
//{
//	ents_left = GetEntArray("exploder_top_left", "script_noteworthy");
//	ents_right = GetEntArray("exploder_top_right", "script_noteworthy");
//
//	trig = GetEnt("trigger_top_left", "targetname");
//	trig waittill("trigger");
//	for(i = 0; i < ents_left.size; i++)
//	{
//		level thread trigger_destruction(ents_left[i]);
//	}
//
//	trig = GetEnt("trigger_top_right", "targetname");
//	trig waittill("trigger");
//	for(i = 0; i < ents_right.size; i++)
//	{
//		level thread trigger_destruction(ents_right[i]);
//	}
//}


vesper_dialog()
{
	level waittill("elevator_moving_up");	
	level.gettler play_dialogue("GETT_GettG_060A");
	wait .5;
	level.vesper play_dialogue("VESP_GettG_061A");

	flag_wait("raising_water");

	level.vesper play_dialogue("TMR1_GettG_062A");
}

view_cams()
{
	view_cam = GetEntArray("view_cam", "targetname");
	for (i = 0; i < view_cam.size; i++)
	{
		view_cam[i] thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	}

	level thread maps\_securitycamera::camera_tap_start(undefined, view_cam);
}

fidget()
{
	self endon("death");
	self endon("alert_yellow");
	self endon("alert_red");

	if (self GetAlertState() != "alert_green")
	{
		return;
	}

	do_it = RandomInt(2);
	if (!do_it)
	{
		return;
	}

	wait 3;	// wait to turn and face node direction

	num_actions = 3;

	if (!IsDefined(self.random_action_num))
	{
		self.random_action_num = RandomInt(num_actions);
		self.random_action_count = 0;
	}
	else if (self.random_action_num == num_actions)
	{
		if (self.random_action_count == num_actions)
		{
			// we've done all the actions, start over with a random action
			self.random_action_num = RandomInt(num_actions);
		}
		else
		{
			// wrap around, we haven't done all the actions yet
			self.random_action_num = 0;
		}
	}

	if (self.random_action_num == 0)
	{
		self CmdAction("CheckWatch", true);
	}
	else if (self.random_action_num == 1)
	{
		self CmdAction("CheckWeapon", true);
	}
	else if (self.random_action_num == 1)
	{
		self CmdAction("Scratch", true);
	}

	self.random_action_num++;
	self.random_action_count++;
}
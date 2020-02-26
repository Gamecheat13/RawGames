




#include maps\_utility;
#include maps\gettler_util;

#using_animtree ("generic_human");

main()
{
	
	
	if(!isdefined(level.script))
	{
		level.script = tolower( getdvar( "mapname" ) );
	}
	
	level.player = getent("player", "classname" );
	
	

	SetDVar("sm_lightScore_dynamic", 64);
	SetDVar("sm_lightScore_eyeProject", 32);

	SetDVar("sm_SunSampleSizeNear", 0.4);

	
	setExpFog(0, 1600, 0.58, 0.60, 0.52, 2.0, 0.55);

	SetSavedDVar("r_godraysPosX2",  "0.958684");
	SetSavedDVar("r_godraysPosY2",  "-0.558298");

	
	VisionSetNaked("gettler", 0.05);
	maps\createart\gettler_art::main();
	
	
	maps\gettler_fx::main();
	maps\gettler_anim::main();

	pre_cache();
		
	
	
	
	flag_init("vesper_alert");

	
	flag_init("shaking");
	flag_init("tilting");
	flag_init("super_tilt");
	flag_init("front_door_closed");
	flag_init("pulley_lowered");
	flag_init("vesper_boat_escape");
	flag_init("gondola_drop");
	flag_init("stop_blocker");
	
	level.blocker_deleted = 0;
	
	
	PreCacheShader("compass_map_gettler");
	SetMiniMap("compass_map_gettler", 4568, 4408, -3080, -5304);
	
	
	maps\_gondola::main();
	maps\_gondola::main("v_gondola_flatbottom");
	
	maps\_motor_boat::main("v_boat_motor_b");

	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	
	if(Getdvar("artist") == "1")
	{
		maps\_loadout::init_loadout();
		thread infinite_ammo("p99_s");
		
		
		front_door = GetNodeArray("auto358", "targetname");
		for (i = 0; i < front_door.size; i++)
		{
			front_door[i].no_player = 0;
		}
		
		
		maps\_doors::main();
			
		return;
	}
	
	

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
	
	maps\_drones::init();
	
	
	maps\_trap_extinguisher::init();
	maps\_trap_electrical_box::init();
	
	
	
	
	level thread floor_tracker();	

	
	maps\_load::main();
	maps\gettler_load::main();
	maps\gettler_amb::main();
	maps\gettler_mus::main();
	
	maps\_securitycamera::init(false);
	
	
	
	maps\_phone::setup_phone();
	holster_weapons();

	

	
	if ((!maps\gettler_skipto::main()) && (level.script != "gettlertest"))
	{
		level thread objectives(1);
		level thread maps\gettler_vesper::main();
	}
	
	
	
	level thread give_weapon();
	level thread start_gettler();
	level thread confront_gettler();	
	level thread cleanup();	
	
	level thread end_demo();

	
	level thread maps\gettler_atrium::init();
	level thread setup_data_collection();

	
	level thread blocker_gettler_house(); 

	view_cams();

	
	SetSavedDVar("bal_move_speed",80.0);
	SetSavedDVar("Bal_wobble_accel", 1.045);
	SetSavedDVar("Bal_wobble_decel", 1.065);
	
}




pre_cache()
{
	
	PrecacheCutScene("Gettler_Intro");
	PrecacheCutScene("Gettler_BoatScene");
	PrecacheCutScene("GBF_Vesper_Elevator_Cycle");
	PrecacheCutScene("Gettler_BossFight");
	PrecacheCutScene("Gettler_Death");

	
	level._effect["fuel_explosion"]		= loadfx("maps/venice/gettler_acetylene_exp");
	level._effect["crash_down"]			= loadfx("explosions/default_explosion");
	level._effect["wall_break"]			= level._effect["gettler_falling_debris01"];
	level._effect["switchbox_spark"]	= loadfx("impacts/large_metalhit");

	
	
	
	PreCacheShader("overlay_hunted_black");

	

	PreCacheShellShock("exploder1_shellshock");
	PrecacheShellShock("ac130");

	
	PrecacheModel( "p_msc_gondola_oar_b" );
	PrecacheModel( "p_msc_suitcase_vesper" );
	PrecacheModel( "p_msc_suitcase_vesper_igc" );
	PrecacheModel( "w_t_bond_phone" );

	
	PrecacheItem("p99");
	
	PrecacheItem("nailgun");

	
	if (!IsDefined(level.hud_black))
	{
		level.hud_black = newHudElem();
		level.hud_black.x = 0;
		level.hud_black.y = 0;
		level.hud_black.horzAlign = "fullscreen";
		level.hud_black.vertAlign = "fullscreen";
		
		
		level.hud_black SetShader("overlay_hunted_black", 640, 480);
		level.hud_black.alpha = 0;
	}

	
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



give_weapon()
{
	if (!IsDefined(level.gave_weapon))
	{
		GetEnt("give_weapon", "script_noteworthy") waittill("trigger");
		

		unholster_weapons();
		level.player SwitchToWeapon( "p99_s" );

		
		
		
		
		
		
		
		

		wait 1;
	}

	level.gave_weapon = true;

	GetEnt( "ent_intro_gate_left", "targetname" ) playsound( "GET_Fence_Close" );
	GetEnt( "ent_intro_gate_left", "targetname" ) RotateTo( (0, 90, 0), 0.25 );
	GetEnt( "ent_intro_gate_right", "targetname" ) RotateTo( (0, 270, 0), 0.25 );

	
	level notify( "delete_drones" );
	level notify( "stop_gondolas" );

	wait 2;
	
	
	entOrigin = Spawn( "script_origin", (1756, 2214, 308) );
	entOrigin playsound( "GMR1_GettG_014A" );	

	wait 2;
	level notify("courtyard_go");

	level endon("pillar_guards_cleared");
	flag_wait("pillar_guards_alert");

	entOrigin playsound( "GMR2_GettG_015A" );	
	
	
	
}

infinite_ammo(gun)
{
	while (true)
	{
		level.player SetWeaponAmmoStock("p99", 1000);
		wait 5;
	}
}

setup_data_collection()
{
	level.strings["phone1"] =		&"GETTLER_PHONE1_TITLE";
	level.strings["phone1_text"] =	&"GETTLER_PHONE1_TEXT";

	level.strings["phone2"] =		&"GETTLER_PHONE2_TITLE";	
	level.strings["phone2_text"] =	&"GETTLER_PHONE2_TEXT";

	level.strings["phone3"] =		&"GETTLER_PHONE3_TITLE";	
	level.strings["phone3_text"] =	&"GETTLER_PHONE3_TEXT";

	level.strings["phone4"] =		&"GETTLER_PHONE4_TITLE";	
	level.strings["phone4_text"] =	&"GETTLER_PHONE4_TEXT";
}

start_gettler()
{
	
	trigger_wait("gettler_start");
	level notify("put_blocker_back");
	
	level thread maps\gettler_atrium::gettler_building();
	

	
	level notify("playmusicpackage_stealth");
	
	
	

	

	
	level thread shake();
	

	
	
	
	
	
	
	
	

	

	
	
	
	

	level thread gettler_dialog();
	level thread vesper_dialog();
	level thread close_front_door();

	
	

	
	entGuard = GetEnt("ai_courtyard_guard_spawner", "targetname") StalingradSpawn("ai_courtyard_guard");
	if (!spawn_failed(entGuard))
	{
		
		entGuard thread ledge_check();
	}

	vespers_node = GetNode("vesper_meet_gettler", "targetname");
	gettlers_node = GetNode("gettler_meet_vesper", "targetname");

	if (IsDefined(level.vesper))
	{
		level.vesper delete();	
	}
	
	spawner = GetEnt("vepser_spawner_gettler", "targetname");
	level.vesper = spawner StalingradSpawn("vesper");
	if (!spawn_failed(level.vesper))
	{
		
		level.vesper thread maps\gettler_util::attach_suit_case( "del_suitcase" );
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
		
		level.gettler thread magic_bullet_shield();
		
		level.gettler SetEnableSense(false);

		level.gettler SetGoalNode(gettlers_node);
		
		
		level.vesper waittill("goal");
		level notify("follow_gettler");

		
		level.gettler thread gettler();
	}
	else
	{
		assertmsg("Problem spawning Gettler.");
	}

	
	
}

gettler_dialog()
{
	
	
	

	
	gettler_vesper_meeting_vo();
	
	level notify("gettler_objective");
}


gettler_vesper_meeting_vo()
{
	
	entOrigin = Spawn( "script_origin", (2622, -2590, 147) );
	entOrigin PlaySound( "VESP_GettG_056A", "ledge_vo_done", false );
	entOrigin waittill( "ledge_vo_done" );
	wait( 1 );
	entOrigin PlaySound( "GETT_GettG_057A", "ledge_vo_done", false );
	entOrigin waittill( "ledge_vo_done" );
	wait( 1 );
	entOrigin PlaySound( "VESP_GettG_058A", "ledge_vo_done", false );
	entOrigin waittill( "ledge_vo_done" );
	wait( 1 );
	entOrigin PlaySound( "GETT_GettG_059A", "ledge_vo_done", false );
	entOrigin waittill( "ledge_vo_done" );
	wait( 1 );

}

ledge_guard()
{
	self endon("stop_guarding");
	self endon("alert_red");
	self endon("stop_ledge_guard");

	self thread stop_ledge_guard();

	while( IsDefined( self ) )
	{
		if( sightTracePassed( level.player GetEye(), self GetEye(), false, undefined ) )
		{
			self thread ledge_kill();
			return;
		}
		else
		{
			wait 0.05;
		}
	}
}

stop_ledge_guard()
{
	wait 6;	
	self notify("stop_ledge_guard");
}


ledge_check()
{
	trigger_wait( "trig_ledge_stop" );

	
	
		self notify( "stop_guarding" );
	

	
	
}

ledge_kill()
{
	
	
	

	self LockAlertState("alert_red");
	
	
	
	self SetEnableSense(false);
	self SetScriptSpeed("Sprint");
	self SetGoalNode(GetNode("ledge_kill_node", "targetname"));
	self waittill("goal");
	
	
	self CmdShootAtEntity(level.player, false, 100, 100);
	wait(0.3);
	
	level.player DoDamage( 100, level.player.origin );
	
}

lock_player()
{
	level.player FreezeControls(true);
	wait 10;
	level.player FreezeControls(false);
	flag_set("player_unlocked");
}




blow_bag1()
{
	self endon("death");
	self waittill("goal");
	
	wait 2;
	
	blow_bag("bag1");
}




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
			level waittill("Gettler_BoatScene_Done");
			new_objective(objective, &"GETTLER_OBJECTIVE_BOAT_YARD_HEADER", GetEnt("objective_boat_yard", "targetname").origin, &"GETTLER_OBJECTIVE_BOAT_YARD_TEXT");
		}
		else if (objective == 5)
		{
			level waittill("gettler_objective");
			new_objective(objective, &"GETTLER_OBJECTIVE_FOLLOW_VESPER3_HEADER", GetEnt("objective_house", "targetname").origin, &"GETTLER_OBJECTIVE_FOLLOW_VESPER3_TEXT");
		}
		else if (objective == 6)
		{
			level waittill("elevator_moving_up");
			new_objective(objective, &"GETTLER_OBJECTIVE_RESCUE_VESPER_HEADER", level.vesper.origin, &"GETTLER_OBJECTIVE_RESCUE_VESPER_TEXT", level.vesper);
		}

		wait( 0.05 );	
		objective++;
	}
}

new_objective(objective, header, origin, text, follow_ent, follow_end_pos)
{
	level notify("objective_update");
			objective_state(objective - 1, "done");
	objective_add(objective, "active", header, origin, text);

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




bag()
{
	

	if (IsDefined(self.targetname) && (self.targetname == "exploder"))
	{
		
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




bag_explode(bag)
{
	exploder_num = bag.script_exploder;
	bag_name = bag.script_string;

	flag_set(bag_name);

	level thread bag_leak(bag);

	bag waittill("damage");
	bag notify("exploding");

	level notify("fx_water_boil");

	if (IsDefined(bag.primaryEntity))
	{
		bag = bag.primaryEntity;	
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

	
	level thread bag_explode_sound(bag_origin);
	
	bag.bag_collision delete();
	Playfx(level._effect["gettler_airbag_burst1"], bag_origin); 
	
	exploder(exploder_num);	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	if (IsDefined(bag_name))
	{


		if ((!flag(bag_name + "_ok")) || (level.exploded_bags > 2))
		{
			level.exploded_bags = 0; 

			if (!IsDefined(level.dont_raise_water_from_popped_bags))
			{
			level thread maps\gettler_water::raise_water();
			level notify("blow_up_blocker");
			
			}

			all_bags = GetEntArray("bag", "script_noteworthy");
			for (i = 0; i < all_bags.size; i++)
			{
				if ((all_bags[i].script_exploder != 5) && (all_bags[i].script_exploder != 10))	
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
			

			if (level._sea_scale < .3)
			{
				level._sea_scale = .3;
			}
		}
	}

	
	
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

	bag thread play_bag_leak_sound(); 
	

	
	

	PlayFxOnTag(level._effect["gettler_airbag_venting1"], bag_leak_tag, "tag_origin");
	
	
	

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


blow_bag2()
{
	
	

	
	
	

	
	
	

	level thread group4_cleared();
	level waittill_either("oxy_tank_explode", "group4_cleared");

	
	

	
	
	
	
	
	
	

	bag = undefined;
	if (!flag("bag10"))
	{
		
		bag = GetEnt("bag10", "targetname");
	}
	else if (!flag("bag9"))
	{
		
		bag = GetEnt("bag9", "targetname");
	}
	else if (!flag("bag8"))
	{
		
		bag = GetEnt("bag8", "targetname");
	}

	if (IsDefined(bag))
	{
		flag_clear(bag.targetname + "_ok");
		bag.gettler_player_bag = true;
	}
	
	if (IsDefined(bag)) 
	{
		blow_bag(bag.targetname);						
	}
}

group4_cleared()
{
	flag_wait("group4a_cleared");
	flag_wait("group4b_cleared");
	level notify("group4_cleared");
}

play_bag_leak_sound()	
{
	while (true)
	{
		self PlaySound("GET_bag_leak", "sounddone");
		self waittill("sounddone");
	}
}


shoot_at_bags()
{
	level thread kill_shoot_at_bags_guy(self);
	level thread force_blow_bags(self);

	self endon("death");
	self waittill("goal");

	bag_count = 0;	
	bag = undefined;
	for (i = 0; i < 3; i++)
	{
		if (!flag("bag1"))
		{
			
			bag = GetEnt("bag1", "targetname");
		}
		else if (!flag("bag3"))
		{
			
			bag = GetEnt("bag3", "targetname");
		}
		else if (!flag("bag4"))
		{
			
			bag = GetEnt("bag4", "targetname");
		}

		if (IsDefined(bag))
		{
			
			
			
			self.script_noteworthy = bag.script_string;

			if (bag_count <= 0)	
			{
			self CmdShootAtPos(bag.origin, false, -1);
				bag_count++;
			}

			level thread damage_bag(bag);
			
			bag waittill("bag_leak");
			self StopAllCmds();
			wait .05;
		}
	}
}


damage_bag(bag)
{
	wait 1;
	while (IsDefined(bag))
	{
		
		bag DoDamage(1, bag.origin, level.player);
		wait 1.5;
	}
}


blocker_gettler_house()
{
	block = getent("blocker_gettler1","targetname");
	block trigger_off();
	block connectpaths();
	
	level waittill("put_blocker_back");
	wait(25);
	
	block trigger_on();
	block disconnectpaths();
	
	
	level waittill("blow_up_blocker");
	
	
	if (level.blocker_deleted == 0)
	{

		originfx = getent("blocker_gettler1_effect","targetname");
		
		fx = playfx (level._effect["gettler_acetylene_exp"], originfx.origin);
		physicsExplosionSphere( originfx.origin, 300, 200, 4 );
		earthquake( 1.3, 1, originfx.origin, 1000 );
		
		block delete();
		level.blocker_deleted = 1;
	}
}


timed_order_for_4th_floor_explosions()
{

	
	
	
	
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
		
	}
}













close_front_door()
{
	
	
	
	
	
	
	
	

	trigger_wait( "close_front_door" );
	level thread set_house_water(); 
	level thread shake_building(3, .3);

	
	
	
	GetEnt("ent_gettler_door_left", "targetname") RotateTo( (0, 90, 0), 0.25 );

	
	

	
	
	

	

	level notify("start_shaking");	
	

	
	flag_set("front_door_closed");
}




unlink_bag5()
{
	flag_wait("raising_water");	
	flag_waitopen("raising_water");
	flag_wait("raising_water");
	flag_waitopen("raising_water");
	flag_wait("raising_water");

	all_bags = GetEntArray("bag", "script_noteworthy");
	for (i = 0; i < all_bags.size; i++)
	{
		if ((all_bags[i].script_exploder == 5))	
		{
			all_bags[i] Unlink();
		}
	}
}




blow_bag(name)
{
	bag_ents = GetEntArray("bag", "script_noteworthy");
	for (i = 0; i < bag_ents.size; i++)
	{
		if (IsDefined(bag_ents[i].script_string) && (bag_ents[i].script_string == name))
		{
			
			bag_ents[i] notify("damage", 100, level.player);
			wait .05;
			bag_ents[i] notify("damage", 100, level.player);
			wait .05;
			bag_ents[i] notify("damage", 100, level.player);
		}
	}
}




gettler()
{
	
	

	
	

	
	
	
	
	

	

	level.vesper thread walk_run_walk_to_node( "nod_elevator_vesper", 5 );
	level.gettler thread walk_run_walk_to_node( "nod_elevator_gettler", 5 );

	level.vesper waittill("goal");
	level.vesper notify("del_suitcase");
}


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




confront_gettler()
{
	trig = GetEnt("confront_gettler", "targetname");
	trig waittill("trigger");
	
	
	setDvar( "movebody_enable", 0 );

	
	level thread maps\_autosave::autosave_now("gettler");
	
	
	level.vesper play_dialogue_nowait("VESP_GettG_077A");
	
	level waittill("start_gettler_fight");

	
	gettler_spawner = GetEnt("gettler_end_spawner", "targetname");
	level.gettler = gettler_spawner StalingradSpawn("gettler");
	level.gettler LockAlertState("alert_green");
	level.gettler SetEnableSense(false);

	
		
	
	
	level notify("update_objective");
	
	

	
	level.vesper Hide();
	level.gettler Hide();
	level.player HideViewModel();

	fake_gun = GetEnt("nailgun", "targetname");
	fake_gun delete();
	
	
	level.player freezecontrols(true);
	level thread letterbox_on( false, true, 1, false );
	VisionSetNaked("gettler_end", 0.0);
	PlayCutScene( "Gettler_BossFight", "scene_anim_done" );
	level.player PlaySound("GET_FinalCinematic_Foley");
	

	
	level.player AllowCrouch(false);
	landing_org = GetEnt("bond_landing", "targetname");
	level.player setorigin( landing_org.origin );

	level.player PlayerLinkTo( landing_org );
	

	level.player TakeAllWeapons();
	
	level waittill( "scene_anim_done" );
	level.player freezecontrols(false);
	level.player setplayerangles( landing_org.angles );

	
	level thread letterbox_off( false );
	
	
	
	
	
	
	
	
	level.vesper Show();
	level.gettler Show();
	level.player ShowViewModel();
	
	
	
	
	
	
	level.hud_black.alpha = 1;
	level.hud_black fadeOverTime(3); 
	level.hud_black.alpha = 0;
	
	
	

	level.gettler thread shoot_eye_achievement();

	level.player GiveWeapon("nailgun");
	level.player SwitchToWeapon("nailgun");
	
	
	
	
	level thread gettler_end_win();
	
	
	wait( 2 );

	if (IsDefined(level.gettler) && IsAlive(level.gettler))
	{
		level.gettler LockAlertState("alert_red");
		level.gettler SetEnableSense(true);
		level.gettler SetPerfectSense(true);
	}

	
	
	
}

shoot_eye_achievement()	
{
	eAttacker = undefined;
	while (!IsPlayer(eAttacker))
	{
		self waittill("damage", iDamage, eAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName);
		if (IsPlayer(eAttacker) && !IsAlive(self))
		{
			
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
	
	
	
	
	
	
	
	
	
	
	
	

	maps\_endmission::nextmission();
}


poison_effect()
{
	reviveeffectcenter(1.9, 0.5, 0.8, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97);
	
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



shake()
{
	level waittill("start_shaking");	

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
	

	
}


ramp_player_speed()
{
	while (true)
	{
		flag_wait("shaking");
		maps\_load::waterThink_rampSpeed(0);	
		
		flag_waitopen("shaking");
		maps\_load::waterThink_rampSpeed(level.default_run_speed);
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
				maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);

				flag_set("player_4th_floor");
				level.active_floor = 4;

				flag_clear("player_2nd_floor");
				flag_clear("player_3rd_floor");

				
				
			}
		}
		else if (z > 400)
		{
			if (level.active_floor != 3)
			{
				level._sea_flip_rotation = true;

				maps\_sea::sea_add_physics_group("sea_physics_floor3", 1.8);
				maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

				flag_set("player_3rd_floor");
				level.active_floor = 3;

				flag_clear("player_2nd_floor");
				flag_clear("player_4th_floor");

				
				
			}
		}
		else if (z > 250)
		{
			if (level.active_floor != 2)
			{
				maps\_sea::sea_add_physics_group("sea_physics_floor2", 1.8);
				maps\_sea::sea_remove_physics_group("sea_physics_floor1", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);
				maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

				flag_set("player_2nd_floor");
				level.active_floor = 2;

				flag_clear("player_3rd_floor");
				flag_clear("player_4th_floor");

				
				
			}
		}
		else if (level.active_floor != 1)
		{
			maps\_sea::sea_add_physics_group("sea_physics_floor1", 1.8);
			maps\_sea::sea_remove_physics_group("sea_physics_floor2", true);
			maps\_sea::sea_remove_physics_group("sea_physics_floor3", true);
			maps\_sea::sea_remove_physics_group("sea_physics_floor4", true);

			level.active_floor = 1;
			flag_clear("player_2nd_floor");
			flag_clear("player_3rd_floor");
			flag_clear("player_4th_floor");

			
			
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
	GetEnt("zone6", "script_noteworthy") waittill("trigger");	
	scrub_zone("zone4", true, true);
}

scrub_zone5()
{
	GetEnt("zone6", "script_noteworthy") waittill("trigger");
	scrub_zone("zone5", true, true);
}

pillar_guard1()
{
	self endon("alert_red");
	self endon("death");

	
	
	
	
	

	
	
	
	
	
	
	
	

}

pillar_guard2()
{
	self endon("alert_red");
	self endon("death");

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

middle_guard1()
{
	self endon("alert_red");
	self endon("death");

	
	
	
	

	
	
	
	
	
	
	

	
	
	
	

}

middle_guard2()
{
	self endon("alert_red");
	self endon("death");

	
	
	
	
	
	
	
	
	
	

	
	
	
}


end_demo()
{


	

	trig = GetEnt("end_demo", "targetname");
	trig waittill("trigger");

	
	
	
	
	
	wait( 1.3 );
	
	skylight_org = GetEnt("blow_skylight", "targetname");
	RadiusDamage(skylight_org.origin, 80, 20, 20);

	
}





















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

/****************************************************************************

Level: 		THE GUNS OF POINTE DU HOC (duhoc_assault.bsp)
Campaign: 	American Rangers Normandy
		
*****************************************************************************/

#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;
#include maps\duhoc_assault_drones;
main()
{
	level.spawnerCallbackThread = ::spawner_think;
	
	braeburns = getentarray("actor_ally_ranger_wet_nrmdy_braeburn","classname");
	for( i = 0 ; i < braeburns.size ; i++ )
		braeburns[i].script_friendname = "Pvt. Braeburn";
	braeburns = getentarray("actor_ally_ranger_nrmdy_braeburn","classname");
	for( i = 0 ; i < braeburns.size ; i++ )
		braeburns[i].script_friendname = "Pvt. Braeburn";
	
	randalls = getentarray("actor_ally_ranger_wet_nrmdy_randall","classname");
	for( i = 0 ; i < randalls.size ; i++ )
		randalls[i].script_friendname = "Sgt. Randall";
	randalls = getentarray("actor_ally_ranger_nrmdy_randall","classname");
	for( i = 0 ; i < randalls.size ; i++ )
		randalls[i].script_friendname = "Sgt. Randall";
		
	mccloskey = getentarray("actor_ally_ranger_wet_nrmdy_mccloskey","classname");
	for( i = 0 ; i < mccloskey.size ; i++ )
		mccloskey[i].script_friendname = "Pvt. McCloskey";
	mccloskey = getentarray("actor_ally_ranger_nrmdy_mccloskey","classname");
	for( i = 0 ; i < mccloskey.size ; i++ )
		mccloskey[i].script_friendname = "Pvt. McCloskey";
	
	level.noTankSquish = true;
	maps\duhoc_assault_data::main();
	
	setsavedcvar("r_specularColorScale", "1.2");
	setsavedcvar("r_cosinePowerMapShift", "-.49");
	
	if (getcvar("scr_duhoc_assault_fast") == "")
		setcvar("scr_duhoc_assault_fast","0");
	
	getent("townhouse_loftdoor","targetname") disconnectpaths();
	
	if (getcvarint("scr_duhoc_assault_fast") > 0)
	{
		setcullfog (500, 4000, 209/255, 216/255, 222/255, 0 );
		setCullDist (4000);
		//getent("townhouse_loftdoor","targetname") disconnectpaths();
		
		spawners = getentarray("delete_for_minspec","script_noteworthy");
		for( i = 0 ; i < spawners.size ; i++ )
			spawners[i] delete();
	}
	else
	{
		setExpFog(0.00005, 209/255, 216/255, 222/255, 0);
	}
	
	drone_trigs = getentarray("drone_allies","targetname");
	for( i = 0 ; i < drone_trigs.size ; i++ )
		drone_trigs[i] minspec_drone_trigger_adjustments();
	drone_trigs = getentarray("drone_axis","targetname");
	for( i = 0 ; i < drone_trigs.size ; i++ )
		drone_trigs[i] minspec_drone_trigger_adjustments();
	
	level.playerboat = getent ("playerboat","targetname");
	assertEx(isdefined (level.playerboat), "player higgins boat not defined.");
	level.playerboat setModel ("xmodel/vehicle_higgins_vm");
	level.flakveirling = getent("flakveirling","targetname");
	level.flakveirling thread flakveirling_deadly_zone();
	
	turrets = getentarray("turret_ignore_goals","script_noteworthy");
	for (i=0;i<turrets.size;i++)
		turrets[i] setturretignoregoals(true);
	
	level.bunker_friends = [];
	level.droneRunRate = 200;
	level.droneRunRate_shellshock = 150;
	
	level.boat_collision = getentarray("boat_collision","targetname");
	
	//level.music["coastal_road"]		= "us_tension_danger_01";
	level.music["found_guns"] 		= "us_discovery_01";
	level.music["misson_complete"]	= "victory_numb_01";
	
	flag_clear("throw_3_nades");
	flag_clear("grenaders_dialogue_2");
	flag_clear("mission_complete");
	flag_clear("start_finalspeach");
	flag_clear("do_thermites");
	flag_clear("restrictPlayerRopeClimb");
	flag_clear("remaining_bunkers");
	flag_clear("objectives_complete");
	flag_clear("happy_music_start_ok");
	flag_clear("beach_dialogue_done");
	flag_clear("moveup_past_zombie");
	flag_clear("player_on_coastal_road");
	flag_clear("update_bunker_positions");
	flag_clear("smoke_hint");
	flag_clear("openGateAllowed");
	flag_clear("allow_bunker_clear_dialogue");
	flag_clear("across_field");
	flag_clear("artillery_done");
	
	level.ropeClimbSpeed = 0.03;
	level.ropeClimbOffset = (-10,0,0);
	
	level.objective["locate_coastal_guns"]	= 1;
	level.objective["regroup_cliff"]		= 2;
	level.objective["rallypoint"]			= 3;
	level.objective["clear_bunkers"]		= 4;
	level.objective["remaining_enemies"]	= 5;
	level.objective["final_speach"]			= 6;
	
	level.ropeClimbersActive = true;
	level.mg42_gunner_died = false;
	level.makeRangerRopeFall = false;
	level.playerClimbingRope = false;
	level.playerRopeClimbersStarted = false;
	level.bunker_turkeyshoot_kill = 0;
	level.higgins_wave2 = [];
	level.boatDroneTag = [];
	level.boatDroneTag_delay = [];
	level.ropeClimberSpawnDist = 500;
	level.cos80 = cos(80);
	level.smokeHints = [];
	
	level.ropeBlendTime["player"] = 2;
	level.ropeBlendTime["1"] = 2;
	level.ropeBlendTime["2"] = 2;
	level.ropeBlendTime["3"] = 2;
	level.ropeBlendTime["4"] = 2;
	level.ropeBlendTime["5"] = 2;
	level.ropeBlendTime["6"] = 0.62;
	level.ropeBlendTime["7"] = 0.62;
	level.ropeBlendTime["8"] = 0.62;
	level.ropeBlendTime["9"] = 0.62;
	level.ropeBlendTime["10"] = 0.62;
	level.ropeBlendTime["11"] = 0.62;
	level.ropeBlendTime["12"] = 0.62;
	level.ropeBlendTime["13"] = 0.62;
	level.ropeBlendTime["14"] = 0.62;
	level.ropeBlendTime["15"] = 0.62;
	level.ropeBlendTime["16"] = 0.62;
	level.ropeBlendTime["17"] = 0.62;
	level.ropeBlendTime["18"] = 0.62;
	level.ropeBlendTime["19"] = 0.62;
	
	level.climbDelay["1"] = 0;
	level.climbDelay["2"] = 15;
	level.climbDelay["3"] = 10;
	level.climbDelay["4"] = 1;
	level.climbDelay["5"] = 15;
	
	level.higgins_character_tag_order = [];
	
	//boat bullet death guys
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy8";
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_randall";
	
	//prey guy
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy3";
	
	//guys who have special animations or dialogue that we always want to be there
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_mccloskey";
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_coffey";
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_driver";
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_medic";
	level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_braeburn";
	
	//---------------------------------------------
	//CONFIGURE HOW MANY DRONES TO USE ON THE BEACH
	//---------------------------------------------
	if (getcvar("scr_duhoc_assault_drones") == "")
		setcvar("scr_duhoc_assault_drones","2");
	if (getcvarint("scr_duhoc_assault_drones") > 0)
	{
		//extras to fill the boat up on most systems
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy2";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy10";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy13";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy5";
		
		//bullet death guy
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy9";
		level.guy9bulletdeath = true;
	}
	if (getcvarint("scr_duhoc_assault_drones") > 1)
	{
		//even more extras in the boat on high end systems
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy11";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy12";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy4";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy6";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy7";
		level.higgins_character_tag_order[level.higgins_character_tag_order.size] =	"tag_guy1";
	}
	level.higgins_character_count = level.higgins_character_tag_order.size;
	//---------------------------------------------
	//---------------------------------------------
	//---------------------------------------------
	
	character\british_duhoc_driver::precache();
	character\american_ranger_normandy_wet::precache();
	character\american_ranger_braeburn_wet::precache();
	character\american_ranger_mccloskey_wet::precache();
	character\american_ranger_coffey_wet::precache();
	character\american_ranger_medic_wells_wet::precache();
	character\american_ranger_randall_wet::precache();
	character\american_ranger_normandy_low_wet::precache();
	aitype\axis_nrmdy_wehr_reg_kar98::precache();
	character\american_ranger_radio_wet::precache();
	
	level.higgins_character_weapons[0] = "xmodel/weapon_thompson";
	level.higgins_character_weapons[1] = "xmodel/weapon_m1garand";
	level.higgins_character_weapons[2] = "xmodel/weapon_m1carbine";
	level.higgins_character_weapons[3] = "xmodel/weapon_bar";
	
	for (i=0;i<level.higgins_character_weapons.size;i++)
		precacheModel (level.higgins_character_weapons[i]);
	
	level.higgins_death_model = "xmodel/vehicle_higgins_destroyed";
	level.higgins_death_fx = loadfx("fx/explosions/boat_explosion.efx");
	level.ropeModel = "xmodel/duhoc_rope_climb_cliff_rig";
	level.playerRopeModel = "xmodel/duhoc_rope_climb_cliff_player_rig";
	
	level.scrsound["mortar"]["incomming"]	= "mortar_incoming";
	level.scrsound["mortar"]["beach"]		= "mortar_explosion_dirt";
	level.scrsound["mortar"]["dirt"]		= "mortar_explosion_dirt";
	level.scrsound["mortar"]["bunker"]		= "ceiling_debris";
	level.scrsound["mortar"]["distant"]		= "distant_explosion_triggered";
	level.scrsound["mortar"]["concrete"]	= "distant_explosion_triggered";
	level.scrsound["mortar"]["water"]		= "mortar_explosion_water";
	
	level.scrsound["battleship_gun"]		= "battleship_gun";
	level.scrsound["water_splash_shipbow"]	= "water_splash_shipbow";
	level.scrsound["boat_gate"]				= "boat_gate";
	level.scrsound["rocket_hook"]			= "rocket_hook";
	
	level.lightflicker["minFlickers"] = 1;
	level.lightflicker["maxFlickers"] = 1;
	level.lightflicker["minDarkness"] = 0.2;
	level.lightflicker["maxDarkness"] = 0.4;
	level.lightflicker["minDarknessPause"] = 0.05;
	level.lightflicker["maxDarknessPause"] = 0.1;
	level.lightflicker["minDarknessTime"] = 0.1;
	level.lightflicker["maxDarknessTime"] = 0.15;
	
	precacheModel(level.ropeModel);
	precacheModel(level.playerRopeModel);
	precacheModel("xmodel/vehicle_higgins_vm");
	precacheModel("xmodel/vehicle_higgins_destroyed");
	precacheModel("xmodel/vehicle_higgins_mortors");
	precacheModel("xmodel/vehicle_higgins_mortors_destroyed");
	precacheModel("xmodel/vehicle_higgins_grapple_hook");
	precacheModel("xmodel/vehicle_higgins_grapple_rope_short_l");
	precacheModel("xmodel/vehicle_higgins_grapple_rope_short_r");
	precacheModel("xmodel/duhoc_player_viewcam_joints");
	precacheModel("xmodel/duhoc_drones_rig");
	precacheModel("xmodel/projectile_britishgrenade");
	precacheModel("xmodel/prop_mortar");
	precacheModel("xmodel/prop_mortar_case");
	precacheModel("xmodel/prop_mortar_ammunition");
	precacheModel("xmodel/us_ranger_radio_back");
	precacheModel("xmodel/us_ranger_radio_hand");
	precacheModel("xmodel/trenchframe01_broken");
	precacheModel("xmodel/weapon_us_thermite_grenade");
	precacheModel("xmodel/weapon_us_thermite_grenade_obj");
	precacheModel("xmodel/german_artillery_flakveirling_d");
	precacheModel("xmodel/vehicle_p51_mustang");
	precacheModel("xmodel/german_artillery_155gpf_d");
	precacheShader("overlay_lights_out");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("inventory_thermite");
	precacheString(&"DUHOC_PLATFORM_USEROPE");
	precacheString(&"DUHOC_MOVEUPROPE");
	precacheString(&"DUHOC_PLATFORM_MOVEUPROPE_PC");
	precacheString(&"DUHOC_PLATFORM_USETHERMITE");
	precacheString(&"DUHOC_OBJ_DESTROYGUNS");
	precacheString(&"DUHOC_OBJ_DESTROYGUNS_COUNT");
	precacheString(&"DUHOC_OBJ_LOCATEDESTROYGUNS");
	precacheString(&"DUHOC_OBJ_REGROUPCLIFF");
	precacheString(&"DUHOC_OBJ_DESTROYGUNS");
	precacheString(&"DUHOC_OBJ_RALLYPOINT");
	precacheString(&"DUHOC_OBJ_BUNKERS");
	precacheString(&"DUHOC_OBJ_ENEMIES");
	precacheShellshock("duhoc_boatexplosion");
	precachevehicle("Stuka");
	
	setup_boatDroneTags("tag_guy11",	0.0);
	setup_boatDroneTags("tag_guy12",	0.2);
	
	setup_boatDroneTags("tag_guy10",	0.4);
	setup_boatDroneTags("tag_guy13",	0.5);
	
	setup_boatDroneTags("tag_guy9",		0.6);
	setup_boatDroneTags("tag_guy7",		0.8);
	
	setup_boatDroneTags("tag_guy8",		0.9);
	setup_boatDroneTags("tag_randall",	1.0);
	
	setup_boatDroneTags("tag_medic",	1.1);
	setup_boatDroneTags("tag_guy6",		1.2);
	
	setup_boatDroneTags("tag_braeburn", 1.4);
	
	setup_boatDroneTags("tag_mccloskey",1.6);
	
	setup_boatDroneTags("tag_guy5",		1.7);
	setup_boatDroneTags("tag_guy3",		1.8);
	setup_boatDroneTags("tag_guy1",		2.0);
	
	setup_boatDroneTags("tag_guy4",		2.2);
	setup_boatDroneTags("tag_guy2",		2.5);
	
	setup_boatDroneTags("tag_coffey",	2.8);
	
	setsavedcvar("g_speed", 190 );
	
	if (getcvar("moveboat") == "")
		setcvar("moveboat","1");
	if (getcvar("duhoc_drones_run") == "")
		setcvar("duhoc_drones_run","1");
	if (getcvar("duhoc_shellshock") == "")
		setcvar("duhoc_shellshock","1");
	if (getcvar("duhoc_fov") == "")
		setcvar("duhoc_fov","1");
	if (getcvar("duhoc_firedrones") == "")
		setcvar("duhoc_firedrones","0");
	if (getcvar("duhoc_camerashake") == "")
		setcvar("duhoc_camerashake","1");
	if (getcvar("duhoc_flakverling") == "")
		setcvar("duhoc_flakverling","1");
	if (getcvar("duhoc_shadows") == "")
		setcvar("duhoc_shadows","0");
	if (getcvar("") == "")
		setcvar("","1");
	
	drones_init();
	higgins_remove_position_models();
	maps\duhoc_assault_fx::main();
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_brush",true);
	maps\_load::main();
	
	if (level.xenon)
	{
		setcvar("scr_duhoc_assault_drones","2");
		setcvar("scr_duhoc_assault_fast","0");
	}
	
	maps\duhoc_assault_anim::main();
	level thread maps\duhoc_town::duhoc_town();
	level thread maps\duhoc_assault_guns::main();
	
	level thread maps\duhoc_assault_amb::main();
	
	aitype\axis_nrmdy_wehr_reg_kar98::precache();
	aitype\ally_ranger_wet_nrmdy_reg_garand::precache();
	level.drone_spawnFunction["axis"] =  aitype\axis_nrmdy_wehr_reg_kar98::main;
	level.drone_spawnFunction["allies"] =  aitype\ally_ranger_wet_nrmdy_reg_garand::main;
	maps\_drones::init();
	
	maps\duhoc_assault_drones::init_struct_targeted_origins();
	level thread maps\_mortar::duhoc_style_mortar();
	//level array_thread (getspawnerarray(), ::spawner_think);
	level array_thread (getentarray("trigger_multiple","classname"), ::forceSpawn_think);
	level array_thread (getentarray("trigger_radius","classname"), ::forceSpawn_think);
	level array_thread (getentarray("inside_bunker","targetname"), ::atmosphere_bunkerShelling);
	level array_thread (getentarray("trigger_multiple","classname"), ::triggered_delete_ai);
	level array_thread (getentarray("trigger_radius","classname"), ::triggered_delete_ai );
	level array_thread (getentarray("sound_trigger","targetname"), ::sound_trigger );
	level array_thread (getentarray("trench_frame","targetname"), ::trench_frame_break );
	array_thread(getentarray("return_ai_trigger","script_noteworthy"), ::triggerOff);
	array_thread(getentarray("friendlychain_returntrip","script_noteworthy"), ::triggerOff);
	array_thread(getentarray("crowded_rope_trigger","targetname"), ::rope_crowded_dialogHints);
	array_thread(getentarray("smoke_hint","targetname"), ::hint_smokegrenade);
	array_thread(getentarray("pinned_friendlies","targetname"), ::pinned_friendlies);
	array_thread(getentarray("saveprogress","targetname"), ::saveprogress);
	array_thread(getentarray("across_field_autosave","targetname"), ::across_field_autosave);
	
	thread objective_destroy_coastal_guns();
	thread atmosphere_bulletStrafe();
	thread atmosphere_watchThoseTrenches();
	thread atmosphere_rightfield_mortars();
	thread ambient_tracks();
	thread atmosphere_stairwell_sound();
	level.inventory_thermite = maps\_inventory::inventory_create( "inventory_thermite", true );
	
	if (getcvar("start") == "start")
	{
		water = getent("water_section","targetname");
		water hide();
		water.origin = water.origin - (0,0,50);
		
		level.player takeallweapons();
		level.playerboat higgins_life();
		level.playerboat higgins_attach_grapplingHooks();
		higgins_blockers_show(false);
		floaters_show(false);
		level thread higgins_attachPlayer();
		level.playerboat thread higgins_spawn_characters();
		level.playerboat thread higgins_drive();
		level.playerboat thread higgins_sway();
		level.playerboat thread higgins_fx_floorsplash();			
		level.playerboat thread atmosphere_plinkage();
		
		higginsboat = getentarray("higginsboat","targetname");
		for (i=0;i<higginsboat.size;i++)
		{
			assert(isdefined(higginsboat[i].script_minspec_level));
			if (getcvarint("scr_duhoc_assault_drones") < higginsboat[i].script_minspec_level)
			{
				higginsboat[i] delete();
				continue;
			}
			
			higginsboat[i] higgins_life();
			higginsboat[i] higgins_attach_grapplingHooks();
			higginsboat[i] thread higgins_spawn_characters();
			higginsboat[i] thread higgins_drive();
			higginsboat[i] thread higgins_sway();
		}
		
		thread scene_OnTheBoat_start();
		thread player_climb_rope();
		thread atmosphere_boatAmbientSound();
		thread atmosphere_battleshipGunfire();
		thread atmosphere_boatMortars();
		thread atmosphere_cliffridge_muzzleflashes();
		thread scripted_event_TrenchChargers();
		//thread beach_springfieldRifle();
		thread maps\_float::main(2, undefined, 25, undefined, undefined);//range, freq, wavelength, rotation, origin
		
		if (getcvarint("duhoc_shadows") > 0)
		{
			level.playerboat setshadowhint ("receiver");
			for (i=0;i<level.playerboat.higgins_riders.size;i++)
			{
				priority = "low_priority";
				if (getcvarint("duhoc_shadows") > 1)
					priority = "high_priority";
				level.playerboat.higgins_riders[i] setshadowhint (priority);
			}
		}
	}
	else if (getcvar("start") == "beach")
	{
		level.player setOrigin( (2311,-4625,60) );
		level.player setplayerangles( (0,10,0) );
		level thread atmosphere_wounded_characters();
		level thread scripted_event_medicCarry("medic_carry1", 5);
		level thread scripted_event_medicCarry("medic_carry2", 8);
		thread controlPlayerStance_inWater();
		thread player_climb_rope();
		thread scripted_event_GetUpCliff();
		//thread beach_springfieldRifle();
		thread scripted_event_TrenchChargers();
		thread atmosphere_yellingOnBeach();
	}
	else if (getcvar("start") == "clifftop")
	{
		level.player setOrigin( (545, -3432, 1072) );
		level.player setplayerangles( (0,75,0) );
		thread mg42_grazer_start();
		level notify ("start_mortars 1");
		level notify ("right_field_mortars");
		getent ("clifftop","targetname") notify ("trigger");
		level thread flakveirling_start();
	}
	else if (getcvar("start") == "town")
	{
		level.player setOrigin( (328, 1936, 1288) );
		level.player setplayerangles( (0,15,0) );
		
		start_town_spawners = getentarray("start_town_spawners","targetname");
		for (i=0;i<start_town_spawners.size;i++)
			start_town_spawners[i] dospawn();
	}
	else if (getcvar("start") == "guns")
	{
		level.player setOrigin( (-1968, 8872, 1097) );
		level.player setplayerangles( (0,195,0) );
		
		maps\duhoc_town::town_triggers_disable();
		
		level.randall = getent("randall_spawner_guns","targetname") stalingradSpawn();
		if (spawn_failed(level.randall))
		{
			assertMsg("randall didn't spawn");
			return;
		}
		level.randall thread magic_bullet_shield();
		wait 1;
		flag_set("do_thermites");
		return;
	}
	thread scripted_event_gunsNotHere();
	thread scripted_event_blowupguy();
	thread scripted_event_bunker_collapse();
	thread cliff_fall_killplayer();
	thread exploder15();
	thread scripted_event_exit_trench_gundown();
	thread scripted_event_grenaders();
	thread scripted_event_artillery_spotter();
	level.struct = undefined;
}

minspec_drone_trigger_adjustments()
{
	if (!isdefined(self.script_noteworthy2))
		return;
	
	if (getcvarint("scr_duhoc_assault_drones") == 2)	//no adjustments for this setting - max drones
		return;
	else
	if (getcvarint("scr_duhoc_assault_drones") == 1)	//remove some drones for this setting
	{
		switch(self.script_noteworthy2)
		{
			case "script_minspec_adjust_drones_5_3":
				self.script_drones_min = 2;
				self.script_drones_max = 3;
				break;
			case "script_minspec_adjust_drones_6_3":
				self.script_drones_min = 3;
				self.script_drones_max = 4;
				break;
			case "script_minspec_adjust_drones_4_4":
				self.script_drones_min = 3;
				self.script_drones_max = 3;
				break;
			case "script_minspec_adjust_drones_5_2":
				self.script_drones_min = 1;
				self.script_drones_max = 4;
				break;
			case "script_minspec_adjust_drones_6_5":
				self.script_drones_min = 3;
				self.script_drones_max = 4;
				break;
			case "script_minspec_adjust_drones_5_5":
				self.script_drones_min = 3;
				self.script_drones_max = 3;
				break;
			case "script_minspec_adjust_drones_3_2":
				self.script_drones_min = 1;
				self.script_drones_max = 2;
				break;
			default:
				assertMsg("drone trigger doesn't have a script_noteworthy2 that is valid");
				break;
		}
	}
	else
	if (getcvarint("scr_duhoc_assault_drones") == 0)	//min spec - very few drones
	{
		switch(self.script_noteworthy2)
		{
			case "script_minspec_adjust_drones_5_3":
				self.script_drones_min = 1;
				self.script_drones_max = 2;
				break;
			case "script_minspec_adjust_drones_6_3":
				self.script_drones_min = 1;
				self.script_drones_max = 2;
				break;
			case "script_minspec_adjust_drones_4_4":
				self.script_drones_min = 2;
				self.script_drones_max = 2;
				break;
			case "script_minspec_adjust_drones_5_2":
				self.script_drones_min = 1;
				self.script_drones_max = 3;
				break;
			case "script_minspec_adjust_drones_6_5":
				self.script_drones_min = 2;
				self.script_drones_max = 3;
				break;
			case "script_minspec_adjust_drones_5_5":
				self.script_drones_min = 2;
				self.script_drones_max = 2;
				break;
			case "script_minspec_adjust_drones_3_2":
				self.script_drones_min = 0;
				self.script_drones_max = 2;
				break;
			default:
				assertMsg("drone trigger doesn't have a script_noteworthy2 that is valid");
				break;
		}
	}
}

setup_boatDroneTags(tagName, delayTime)
{
	level.boatDroneTag[level.boatDroneTag.size] = tagName;
	level.boatDroneTag_delay[level.boatDroneTag_delay.size] = delayTime;
}

setup_character_randall(tname)
{
	level.randall = undefined;
	level.randall = getent(tname,"targetname") stalingradSpawn();
	if (spawn_failed(level.randall))
		assertMsg("Randall failed to spawn");
	level notify ("randall_spawned");
	assert(isdefined(level.randall));
	
	level.randall thread magic_bullet_shield();
	
	level.randall.animname = "randall";
}

setup_character_braeburn()
{
	level.braeburn = undefined;
	level.braeburn = getent("braeburn","targetname") stalingradSpawn();
	assert(isdefined(level.braeburn));
	
	level.braeburn thread magic_bullet_shield();
	
	level.braeburn.animname = "braeburn";
}

setup_character_mccloskey()
{
	level.mccloskey = undefined;
	level.mccloskey = getent("mccloskey","targetname") stalingradSpawn();
	assert(isdefined(level.mccloskey));
	
	level.mccloskey thread magic_bullet_shield();
	
	level.mccloskey.animname = "mccloskey";
}

objective_destroy_coastal_guns()
{
	coastal_gun_location = getent("coastal_gun_location","targetname").origin;
	objective_add(level.objective["locate_coastal_guns"], "active", &"DUHOC_OBJ_DESTROYGUNS", coastal_gun_location);
	objective_current( level.objective["locate_coastal_guns"] );
}

objective_regroup_cliff()
{
	if (!isdefined(level.randall))
		level waittill ("randall_spawned");
	objective_add(level.objective["regroup_cliff"], "active", &"DUHOC_OBJ_REGROUPCLIFF", level.randall.origin);
	objective_current( level.objective["regroup_cliff"] );
}

objective_locate_artillery_guns()
{
	objective_string(level.objective["locate_coastal_guns"], &"DUHOC_OBJ_LOCATEDESTROYGUNS");
	objective_position(level.objective["locate_coastal_guns"], (-176, 1424, 1256) );
	flag_wait("artillery_done");
	objective_position(level.objective["locate_coastal_guns"], (-2328,8728,1144) );
}

controlPlayerStance_inWater()
{
	depth_allow_prone = 5;
	depth_allow_crouch = 33;
	depth_kill = 50;
	default_run_speed = 190;
	
	speed_normal = default_run_speed;
	speed_slowed = int(default_run_speed / 2);
	speed_medium = int(default_run_speed / 4);
	speed_snail = int(default_run_speed / 8);
	
	water_level = getent("water_level","targetname");
	waterHeight = water_level.origin[2];
	
	qReset = false;
	waitTime = 1.0;
	
	for (;;)
	{
		wait (waitTime);
		playerOrg = level.player getOrigin();
		if (playerOrg[2] < waterHeight)
		{
			qReset = true;
			waitTime = 0.25;
			d = distance( (0,0,playerOrg[2]) , (0,0,waterHeight) );
			
			if (d > depth_allow_prone)
			{
				thread controlPlayerStance_setSpeed(speed_slowed);
				level.player allowProne(false);
			}
			else
			{
				thread controlPlayerStance_setSpeed(speed_normal);
				level.player allowProne(true);
				continue;
			}
			
			if (d > depth_allow_crouch)
			{
				thread controlPlayerStance_setSpeed(speed_medium);
				level.player allowCrouch(false);
			}
			else
			{
				thread controlPlayerStance_setSpeed(speed_slowed);
				level.player allowCrouch(true);
			}
			
			if (d >= depth_kill)
			{
				thread controlPlayerStance_setSpeed(speed_snail);
				thread player_kill_bullets();
				return;
			}
		}
		else if (qReset)
		{
			//restore all defaults
			level.player allowProne(true);
			level.player allowCrouch(true);
			level.player allowStand(true);
			thread controlPlayerStance_setSpeed(speed_normal);
			qReset = false;
			waitTime = 1.0;
		}
	}
}

player_kill_bullets()
{
	while (isalive(level.player))
	{
		level.player doDamage( 15, (1249, -3885, 1140) );
		wait (0.2 + randomfloat(0.2));
	}
}

controlPlayerStance_setSpeed(speed)
{
	level.player notify ("changing_player_speed");
	level.player endon ("changing_player_speed");
	
	currentSpeed = getcvarint("g_speed");
	newSpeed = undefined;
	for (;;)
	{
		if (speed < currentSpeed)
		{
			//slow the player down
			newSpeed = currentSpeed - 40;
			if (newSpeed < speed)
				newSpeed = speed;
		}
		else if (speed > currentSpeed)
		{
			//speed the player up
			newSpeed = currentSpeed + 40;
			if (newSpeed > speed)
				newSpeed = speed;
		}
		if (!isdefined (newSpeed))
			return;
		setsavedcvar("g_speed", newSpeed );
		if (newSpeed == speed)
			return;
		wait 0.25;
	}
}

scene_OnTheBoat_start()
{
	//###############//
	//	On The Boat  //
	//###############//
	
	thread scene_OnTheBoat_landing();
	thread scene_OnTheBoat_puke();
	thread scene_OnTheBoat_speach();
	level.preyGuy thread scene_guyPrey();
	
	thread scripted_event_boatDeath_1();
	thread scripted_event_boatDeath_2();
	thread scripted_event_boatDeath_3();
	thread scene_OnTheBoat_incomming();
	thread scene_boat_everyoneDuck();
	thread scene_OnTheBoat_getdown();
	
	thread scene_OnTheBoat_thisisit();
	thread scene_OnTheBoat_getready();
	thread scene_OnTheBoat_firingRockets();
	thread scene_OnTheBoat_moveOut();
}

scene_boat_everyoneDuck()
{
	wait 33.0;
	for (i=0;i<level.playerboat.higgins_riders.size;i++)
	{
		if (level.playerboat.higgins_riders[i].animTag == "tag_guy8")
			continue;
		if (level.playerboat.higgins_riders[i].animTag == "tag_guy9")
			continue;
		if (level.playerboat.higgins_riders[i].animTag == "tag_randall")
			continue;
		if (level.playerboat.higgins_riders[i].animTag == "tag_driver")
			continue;
		level.playerboat.higgins_riders[i] thread higgins_character_specialAnim_duck();
	}
	
	level.coxswain notify ("stop_idle_anim");
	level.coxswain anim_single_solo( level.coxswain, "duck_down", level.coxswain.animtag, undefined, level.coxswain.higgins );
	level.coxswain thread anim_loop_solo( level.coxswain, "duck_idle", level.coxswain.animtag, "stop_duck_idle", undefined, level.coxswain.higgins );
}

scene_randall_lean()
{
	self endon ("stop_lean");
	self notify ("stop_idle_anim");
	self anim_single_solo( self, "lean_in", self.animtag, undefined, self.higgins );
	self thread anim_loop_solo( self, "lean_idle", self.animtag, "stop_lean_idle", undefined, self.higgins );
	wait 15;
	self notify ("stop_lean_idle");
	self anim_single_solo( self, "lean_out", self.animtag, undefined, self.higgins );
	self thread higgins_character_loopanims();
}

scene_guyPrey()
{
	wait 16;
	self notify ("stop_idle_anim");
	self anim_single_solo( self, "prey", self.animtag, undefined, self.higgins );
	self thread higgins_character_loopanims();
}

scene_braeburn_pukeFX()
{
	wait 7;
	playfxOnTag ( level._effect["puke"], level.braeburn, "TAG_EYE" );
}

scene_OnTheBoat_landing()
{
	wait 3;
	
	//Rangers! Prepare for landing! 30 seconds! May God be with you!
	level.playerboat thread playSoundOnTag("duhocassault_coxswain_landing", "tag_medic");
}

scene_OnTheBoat_puke()
{
	wait 7;
	
	//Hey Braeburn, you look like you're gonna puke.
	level.mccloskey thread scene_playAnim("ontheboat", level.mccloskey.animtag, undefined, level.playerboat, "duhocassault_mccloskey_gonnapuke", undefined, undefined, undefined, true);
	
	//Y'know what, Donnie…why don't you just… - (vomits)
	level.braeburn thread scene_playAnim("ontheboat", level.braeburn.animtag, undefined, level.playerboat, "duhocassault_braeburn_vomits", undefined, undefined, undefined, true);
	level.braeburn thread scene_braeburn_pukeFX();
}

scene_OnTheBoat_speach()
{
	wait 11;
	
	level.randall thread scene_randall_lean();
	
	//Alright, Dog Company, listen up! We've done this a hundred times in England on terrain
	//a lot worse than this! We got a lot of guys on Omaha and Utah beaches counting on us to
	//get to the top of those cliffs and take out those guns!
	level.coffey thread scene_playAnim("ontheboat", level.coffey.animtag, undefined, level.playerboat, "duhocassault_coffey_listenup", undefined, undefined, undefined, false);
}

scene_OnTheBoat_incomming()
{
	wait 33.5;
	
	thread playSoundInSpace("duhoc_assault_gr1_incomingboat", level.player.origin);
}

scene_OnTheBoat_getdown()
{
	wait 35.1;
	
	level.playerboat thread playSoundOnTag("duhoc_assault_gr5_getdownboat", "tag_guy7");
}

scene_OnTheBoat_thisisit()
{
	wait 36.0;
	
	level.playerboat thread playSoundOnTag("duhoc_assault_gr6_thisisitboat", "tag_guy1");
}

scene_OnTheBoat_getready()
{
	wait 38.8;
	
	level.playerboat thread playSoundOnTag("duhoc_assault_gr5_getreadyboat", "tag_guy5");
}

scene_OnTheBoat_firingRockets()
{
	wait 37.2;
	
	//Firing rockets!!!
	level.coxswain playsound (level.scrsound["coxswain"]["duhocassault_coxswain_firerockets"]);
	wait 2.5;
	level.coxswain notify ("stop_duck_idle");
	level.coxswain anim_single_solo( level.coxswain, "duck_cover", level.coxswain.animtag, undefined, level.coxswain.higgins );
	level.coxswain thread anim_loop_solo( level.coxswain, "duck_idle", level.coxswain.animtag, "stop_duck_idle", undefined, level.coxswain.higgins );
}

scene_OnTheBoat_moveOut()
{
	wait 40.9;
	
	//MOVE OUT!!!
	level.playerboat playSoundOnTag("duhoc_assault_cof_moveoutboat", "tag_guy11");
	//Let's go! Let's go!!!
	level.playerboat playSoundOnTag("duhoc_assault_bra_letsgoboat", "tag_braeburn");
}

scene_playAnim(animName, animTag, animNode, tagEntity, soundAlias1, soundAlias2, soundAlias3, waitforNoteTrack, repeatIdle)
{
	self notify ("scene_playAnim");
	self endon ("scene_playAnim");
	
	if (!isdefined(repeatIdle))
		repeatIdle = false;
	
	if (isdefined (soundAlias1))
	{
		if (!isdefined(waitforNoteTrack))
			waitforNoteTrack = true;
		dialogue_count = 0;
		self notify ("stop_idle_anim");
		thread anim_single_solo( self, animName, animTag, animNode, tagEntity );
		for (;;)
		{
			if (waitforNoteTrack)
				self waittill ("single anim", notetrack);
			else
				notetrack = "dialog";
			if ( (notetrack == "dialogue") || (notetrack == "dialog") )
			{	
				if (dialogue_count == 0)
				{
					assert(isdefined(level.scrsound[self.animname][soundAlias1]));
					self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound[self.animname][soundAlias1], 1);
				}
				else if (dialogue_count == 1)
				{
					if (isdefined(soundAlias2))
					{
						assert(isdefined(level.scrsound[self.animname][soundAlias2]));
						self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound[self.animname][soundAlias2], 1);
					}
				}
				else if (dialogue_count == 2)
				{
					if (isdefined(soundAlias3))
					{
						assert(isdefined(level.scrsound[self.animname][soundAlias3]));
						self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound[self.animname][soundAlias3], 1);
					}
				}
				dialogue_count++;
			}
			if (!waitforNoteTrack)
			{
				self waittillmatch("single anim","end");
				return;
			}
			else if (notetrack == "end")
			{
				//back to idle animations
				if (repeatIdle)
					self thread higgins_character_loopanims();
				return;
			}
		}
	}
	else
	{
		self notify ("stop_idle_anim");
		anim_single_solo( self, animName, self.animTag, undefined, level.playerboat );
		
		//back to idle animations
		if (repeatIdle)
			self thread higgins_character_loopanims();
	}
}

ambient_tracks()
{
	bunker_exterior = getentarray("bunker_exterior","targetname");
	for (i=0;i<bunker_exterior.size;i++)
		bunker_exterior[i] thread ambient_tracks_think("bunker_exterior");
	
	bunker_interior = getentarray("bunker_interior","targetname");
	for (i=0;i<bunker_interior.size;i++)
		bunker_interior[i] thread ambient_tracks_think("bunker_interior");
}

ambient_tracks_think(IntOrExt)
{
	for (;;)
	{
		self waittill ("trigger");
		
		switch (IntOrExt)
		{
			case "bunker_exterior":
				level thread set_ambient("exterior");
				//level.player deactivateReverb("snd_enveffectsprio_level", 3);
				level thread flakveirling_stopfakeshots();
				level notify ("start_mortars 1");
				break;
			case "bunker_interior":
				level thread set_ambient("interior");
				//priority, room type, dry level, wet level, fade time
				//level.player setReverb("snd_enveffectsprio_level", "stoneroom", 0, .7, 3);
				level thread flakveirling_fakeshots();
				level notify ("stop_mortars 1");
				break;
		}
		
		wait 4;
	}
}

player_higgins_explosion()
{
	level.player.starting_health = level.player.health;
	level.player.health = 10000000;
	
	level.player notify ("noHealthOverlay");
	
	level.explosion_fov = spawn("script_model", (0,0,0) );
	level.explosion_fov.angles = (0,0,0);
	level.explosion_fov setmodel ("xmodel/duhoc_player_viewcam_joints");
	
	if (getcvarint("duhoc_shellshock") > 0)
	{
		level.player setorigin(level.explosion_fov getTagOrigin("tag_guy_feet"));
		level.player setPlayerAngles(level.explosion_fov getTagAngles("tag_guy_feet") + (0,90,0));
		level.player playerLinkToAbsolute (level.explosion_fov, "tag_guy_feet");
	}
	
	level notify ("stop_battleship_barrage");
	level notify ("stop_cliffridge_muzzleflashes");
	
	if ( (getcvarint("duhoc_fov") > 0) && (getcvarint("duhoc_shellshock") > 0) )
		thread player_higgins_explosion_cameraAnimate_fovChange();
	
	if (getcvarint("duhoc_shellshock") > 0)
		setblur(1, 0);
	
	if (getcvarint("duhoc_shadows") > 0)
	{
		level.playerboat setshadowhint ("never");
		for (i=0;i<level.playerboat.higgins_riders.size;i++)
			level.playerboat.higgins_riders[i] setshadowhint ("normal");
	}
	
	setsavedcvar("g_friendlyNameDist", 0 );
	setsavedcvar("g_friendlyfireDist", 0 );
	setsavedcvar("g_friendlyfireUseDist", 0 );
	
	level player_higgins_explosion_cameraAnimate_flip();
	thread scripted_event_woundedShellShockMoments();
	
	if (getcvarint("duhoc_shellshock") > 0)
		setblur(0.5, 1);
	
	//let the player take in the view
	wait 15;
	
	level.droneRunRate = 200;
	thread scripted_event_woundedShellShockMoments2();
	
	level thread higgins_wave2_start();
	
	level thread player_higgins_explosion_cameraAnimate_drag();
	thread scripted_event_GetUpCliff();
	level waittill ("fov_drag_done");
	
	setsavedcvar("g_friendlyNameDist", 1500 );
	setsavedcvar("g_friendlyfireDist", 128 );
	setsavedcvar("g_friendlyfireUseDist", 256 );
	
	level.player.health = level.player.starting_health;
	level.player.starting_health = undefined;

	level thread maps\_gameskill::healthOverlay();
	
	level.player allowLeanLeft(true);
	level.player allowLeanRight(true);
	level.player allowStand(true);
	level.player allowCrouch(true);
	level.player allowProne(true);
	level.player.ignoreme = false;
	level.player giveWeapon("fraggrenade");
	level.player giveMaxAmmo("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");
	level.player giveMaxAmmo("smoke_grenade_american");
	level.player switchToOffhand("fraggrenade");
	level.player unlink();
	
	if (getcvarint("duhoc_shellshock") > 0)
	{
		setblur(0, 1);
		level.player setplayerangles (level.explosion_fov getTagAngles("tag_guy_feet"));
	}
	
	if (isdefined(level.explosion_fov))
		level.explosion_fov delete();
	
	thread beach_spawnGuys();
	thread atmosphere_yellingOnBeach();
	thread objective_regroup_cliff();
	
	//give player some weapons
	level.player giveweapon ("springfield");
	springfield_ammo = 5;
	slot1 = level.player getweaponslotweapon("primary");
	slot2 = level.player getweaponslotweapon("primaryb");
	if (slot1 == "springfield")
	{
		level.player setweaponslotammo("primary", springfield_ammo - 5);
		level.player setweaponslotclipammo("primary", springfield_ammo);
	}
	else if (slot2 == "springfield")
	{
		level.player setweaponslotammo("primaryb", springfield_ammo - 5);
		level.player setweaponslotclipammo("primaryb", springfield_ammo);
	}
	level.player giveweapon ("thompson");
	level.player switchtoweapon("springfield");
	
	thread controlPlayerStance_inWater();
	
	thread autoSaveByName("beach");
}

player_higgins_explosion_cameraAnimate_flip()
{	
	level.explosion_fov UseAnimTree(level.scr_animtree["player"]);
	thread player_higgins_explosion_shellshock();
	
	level.explosion_fov setflaggedanimknobrestart("flip_anim", level.scr_anim["player"]["flip"]);
	level.explosion_fov waittillmatch("flip_anim","end");
}

player_higgins_explosion_cameraAnimate_fovChange()
{
	originalFOV = getcvar("cg_fov");
	setsavedcvar("cg_fov","55");
	
	wait 20.4;
	
	setsavedcvar("cg_fov",originalFOV);
	if (getcvarint("scr_duhoc_assault_fast") > 0)
		setCullDist (5000);
}

player_higgins_explosion_cameraAnimate_drag()
{	
	//spawn dragging guy
	drag_guy = getent ("drag_guy","targetname") stalingradSpawn();
	if (spawn_failed(drag_guy))
		assertMsg("Drag guy failed to spawn");
	beach_runner_node = getnode("beach_runner_node","targetname");
	drag_guy pushPlayer(true);
	drag_guy.animname = "drag_guy";
	drag_guy.anim_disablePain = true;
	
	drag_guy thread magic_bullet_shield();
	drag_guy.ignoreme = true;
	
	drag_guy_node = getent("pov_anchor","targetname");
	drag_guy_node.origin = (2150, -5100, -15);
	assert(isdefined(drag_guy_node));
	assert(isdefined(beach_runner_node));
	//play drag FOV animation
	level.explosion_fov clearanim(level.scr_anim["player"]["flip"], 0);
	level.explosion_fov setflaggedanimknobrestart("drag_anim",level.scr_anim["player"]["drag"]);//notify, anim, weight, time
	
	//guy drags player to safety
	drag_guy thread player_higgins_explosion_cameraAnimate_drag_dialogue();
	drag_guy thread anim_single_solo( drag_guy, "drag", undefined, drag_guy_node );
	
	wait 3;
	
	//spawn some wounded guys and derbis, delete drones, start some scripted events
	//----------------------------------------------------
	level notify ("delete_all_drones");
	level thread scripted_event_medicCarry("medic_carry1", 5);
	level thread atmosphere_wounded_characters();
	level thread scripted_event_beach_radioman();
	higgins_blockers_show(true);
	floaters_show(true);
	//----------------------------------------------------
	
	level.explosion_fov waittillmatch("drag_anim","end");
	drag_guy waittillmatch ("single anim","end");
	level thread scripted_event_medicCarry("medic_carry2", 8);
	drag_guy unlink();
	drag_guy.goalradius = 8;
	
	drag_guy allowedStances("stand","crouch");
	drag_guy setgoalnode(beach_runner_node);
	
	wait 1;
	
	level notify ("fov_drag_done");
	
	while(!level.mg42_gunner_died)
		wait 0.05;
	wait 2;
	
	drag_guy.maxsightdistsqrd = 2;
	drag_guy.ignoreme = true;
	drag_guy.fightDist = 0;
	drag_guy.maxdist = 0;
	drag_guy.animplaybackrate = 0.8;
	drag_guy.team = "neutral";
	drag_guy chain_nodes(beach_runner_node);
	drag_guy.team = "allies";
}

player_higgins_explosion_cameraAnimate_drag_dialogue()
{
	self waittillmatch("single anim","dialog");
	self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound["medic"]["duhocassault_wells_igotcha"], 1, "dialog_done");
	//self waittillmatch("single anim","dialogue2");
	self waittillmatch("single anim","end");
	//level.player stopshellshock();
	//self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound["medic"]["duhocassault_wells_luckyman"], 1, "dialog_done");
}

player_higgins_explosion_shellshock()
{
	wait 0.25;
	if (getcvarint("duhoc_shellshock") > 0)
	{
		level.player shellshock("duhoc_boatexplosion", 36);
		level.droneRunRate = level.droneRunRate_shellshock;
	}
	level.player playsound("stunned_soldier");
}

rope_crowded_dialogHints()
{
	level endon ("player_climbing_rope");
	for (;;)
	{
		self waittill ("trigger");
		soundAlias = "duhocassault_gr5_ropecrowded";
		if (randomint(2) == 0)
			soundAlias = "duhocassault_gr10_ropecrowded";
		
		if ( !flag("beach_dialogue_done") )
			level waittill ("beach_yell_dialogue_done");
		level.pauseBeachChatter = true;
		
		self playsoundinspace(soundAlias);
		level.pauseBeachChatter = false;
		wait (5 + randomfloat(4));
	}
}

player_climb_rope()
{
	trig = getent("trigger_climb_rope","targetname");
	trig waittill ("trigger");
	trig delete();
	
	assert(isdefined(level.playerRope));
	
	level notify ("player_climbing_rope");
	thread player_climb_rope_hintPrint();
	
	level.playerRope.climbtag[0] = "cj0";
	level.playerRope.climbtag[1] = "cj2";
	level.playerRope.climbtag[2] = "cj4";
	level.playerRope.climbtag[3] = "cj6";
	level.playerRope.climbtag[4] = "cj8";
	level.playerRope.climbtag[5] = "cj10";
	level.playerRope.climbtag[6] = "cj12";
	level.playerRope.climbtag[7] = "cj14";
	level.playerRope.climbtag[8] = "cj16";
	level.playerRope.climbtag[9] = "cj18";
	level.playerRope.climbtag[10] = "cj20";
	level.playerRope.climbtag[11] = "cj22";
	level.playerRope.climbtag[12] = "cj24";
	level.playerRope.climbtag[13] = "cj26";
	level.playerRope.climbtag[14] = "cj28";
	level.playerRope.climbtag[15] = "cj30";
	level.playerRope.climbtag[16] = "cj32";
	
	attach_player_closest_rope_bone();
	assert(level.player.current_climbtag >= 0);
	
	//update objectives
	objective_state(level.objective["regroup_cliff"], "done");
	objective_current(level.objective["locate_coastal_guns"]);
	
	dummy = spawn("script_origin", level.playerRope getTagOrigin (level.playerRope.climbtag[level.player.current_climbtag]) );
	dummy.angles = level.player.angles;
	level.player setOrigin (dummy.origin - (0,0,50) );
	ogAngles = level.player.angles;
	level.player playerLinkToDelta (dummy, "", 1);
	
	array_notify(getentarray("script_floater","targetname"), "stop_float_script");
	
	level.player allowCrouch(false);
	level.player allowProne(false);
	
	//-------------------------------------------------------------------
	//remember what weapons the player is holding and then take them away
	//-------------------------------------------------------------------
	playerWeapon[0] = level.player getweaponslotweapon("primary");
	playerWeapon[1] = level.player getweaponslotweapon("primaryb");
	playerWeapon_Ammo[0] = level.player getweaponslotammo("primary");
	playerWeapon_Ammo[1] = level.player getweaponslotammo("primaryb");
	playerWeapon_ClipAmmo[0] = level.player getweaponslotclipammo("primary");
	playerWeapon_ClipAmmo[1] = level.player getweaponslotclipammo("primaryb");
	playerCurrentWeapon = level.player getcurrentweapon();
	
	level.player takeallweapons();
	//level.player takeWeapon(playerWeapon[0]);
	//level.player takeWeapon(playerWeapon[1]);
	//-------------------------------------------------------------------
	//-------------------------------------------------------------------
	//-------------------------------------------------------------------
	
	level.playerClimbingRope = true;
	
	level.player thread player_climb_rope_think();
	
	for (;;)
	{
		if ( (level.player.current_climbtag + 1) >= level.playerRope.climbtag.size)
		{
			level.player unlink();
			dummy delete();
			level.player notify ("rope climbed");
			break;
		}
		
		current_tag_pos = ( level.playerRope getTagOrigin(level.playerRope.climbtag[level.player.current_climbtag]) + level.ropeClimbOffset );
		
		if (level.player.current_climbPercent == 0)
			currentPos = current_tag_pos;
		else
		{
			//X = (x2-x1) * p + x1
			next_tag_pos = ( level.playerRope getTagOrigin(level.playerRope.climbtag[level.player.current_climbtag + 1]) + level.ropeClimbOffset );
			x = (next_tag_pos[0] - current_tag_pos[0]) * level.player.current_climbPercent + current_tag_pos[0];
			y = (next_tag_pos[1] - current_tag_pos[1]) * level.player.current_climbPercent + current_tag_pos[1];
			z = (next_tag_pos[2] - current_tag_pos[2]) * level.player.current_climbPercent + current_tag_pos[2];
			currentPos = (x,y,z);
		}
		
		dummy moveTo (currentPos, 0.1, 0, 0);
		wait 0.05;
	}
	
	//find the ground position under the player
	moveDummy = spawn("script_origin",level.player.origin);
	level.player playerLinkToDelta (moveDummy);
	moveDummy moveto ( physicstrace((level.player.origin + (0,0,100)), (level.player.origin - (0,0,100))) + (0,0,10), 0.25, .1, .1);
	wait 0.25;
	level.player unlink();
	moveDummy delete();
	
	level.player allowCrouch(true);
	level.player allowProne(true);
	
	level.player notify ("done_climbing_rope");
	level.ropeClimbersActive = false;
	level thread mg42_grazer_start();
	
	//---------------------------------------------------
	//give the player the weapons they used to have again
	//---------------------------------------------------
	if (playerWeapon[0] != "none")
	{
		level.player giveWeapon(playerWeapon[0]);
		level.player setweaponslotammo("primary", playerWeapon_Ammo[0]);
		level.player setweaponslotclipammo("primary", playerWeapon_ClipAmmo[0]);
	}
	
	if (playerWeapon[1] != "none")
	{
		level.player giveWeapon(playerWeapon[1]);
		level.player setweaponslotammo("primaryb", playerWeapon_Ammo[1]);
		level.player setweaponslotclipammo("primaryb", playerWeapon_ClipAmmo[1]);
	}
	
	if (playerWeapon[0] == playerCurrentWeapon)
	{
		if (playerWeapon[0] != "none")
			level.player switchToWeapon(playerWeapon[0]);
	}
	else
	if (playerWeapon[1] == playerCurrentWeapon)
	{
		if (playerWeapon[1] != "none")
			level.player switchToWeapon(playerWeapon[1]);
	}
	
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");
	//level.player switchToOffhand("fraggrenade");
	
	//---------------------------------------------------
	//---------------------------------------------------
	//---------------------------------------------------
	
	//Delete beach drones
	beach_volume = getent("beach_volume","targetname");
	drones = getentarray("drone","targetname");
	for (i=0;i<drones.size;i++)
	{
		if (!drones[i] isTouching (beach_volume))
			continue;
		
		drones[i] notify ("stop_drone_run_anim");
		drones[i] notify ("drone_death");
		drones[i] notify ("Stop shooting");
		drones[i] notify ("fell_off_rope");
		
		if (isdefined(drones[i].dummy))
			drones[i].dummy delete();
		if (isdefined(drones[i].dummy_trace))
			drones[i].dummy_trace delete();
		drones[i] detachall();
		drones[i] delete();
	}
	
	thread autoSaveByName("clifftop");
}

attach_player_closest_rope_bone()
{	
	closestDistance = 100000000;
	closestIndex = -1;
	for( i = 0 ; i < level.playerRope.climbtag.size ; i++ )
	{
		d = distance( level.player.origin, level.playerRope getTagOrigin(level.playerRope.climbtag[i]) );
		if (d < closestDistance)
		{
			closestDistance = d;
			closestIndex = i;
		}
	}
	
	level.player.current_climbtag = closestIndex;
	level.player.current_climbPercent = 0;
}

player_climb_rope_hintPrint()
{
	wait 2;
	if (level.xenon)
		iprintlnbold( &"DUHOC_MOVEUPROPE" );
	else
		iprintlnbold( &"DUHOC_PLATFORM_MOVEUPROPE_PC", getKeyBinding("+forward")["key1"] );
}

player_climb_rope_think()
{
	level.player endon ("rope climbed");
	for (;;)
	{
		wait .05;
		
		//check if the player can climb up the rope without getting too close to an AI above him
		if (flag("restrictPlayerRopeClimb"))
		{
			climberPos = level.playerrope getTagOrigin( "tag_climber03" );
			playerPos = level.playerrope getTagOrigin( level.playerRope.climbtag[ level.player.current_climbtag ] );
			if (distance (playerPos, climberPos) <= 150)
				continue;
		}
		
		//increase the players distance percentage to the next bone
		movementSpeed = level.player getNormalizedMovement();
		if (movementSpeed[0] <= 0)
			continue;
		level.player.current_climbPercent += (level.ropeClimbSpeed * movementSpeed[0] );
		
		//player reached the next bone
		if (level.player.current_climbPercent >= 1)
		{
			level.player.current_climbPercent = 0;
			level.player.current_climbtag++;
		}
	}	
}

higgins_remove_position_models()
{
	boats = getentarray ("final_boat_position","targetname");
	for (i=0;i<boats.size;i++)
		boats[i] delete();
}

higgins_attachPlayer()
{
	//Put player in the boat
	level.player setOrigin (level.playerboat getTagOrigin ("tag_player"));
	level.player playerLinkToDelta (level.playerboat, "tag_player", 0.5);
	level.player.ignoreme = true;
	
	//Dont allow the player to lean or prone while in the boat
	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);
	level.player allowProne(false);
	
	wait 0.05;
	level.player setplayerangles (level.playerboat getTagAngles ("tag_player"));
}

higgins_life()
{	
	self.deathmodel = level.higgins_death_model;
	self.deathfx = level.higgins_death_fx;
	self.health = 1000000;
}

higgins_kill()
{
	self notify ("death");
	
	self setmodel(self.deathmodel);
	if (isdefined(self.grapplingHook_base))
		self.grapplingHook_base setmodel("xmodel/vehicle_higgins_mortors_destroyed");
	self playsound( "explo_metal_rand" );
	
	playfx( self.deathfx, self.origin );
	earthquake( 0.25, 3, self.origin, 1050 );
	
	self notify ("stop_boat_fx");
	
	//remove the driver of the boat
	if (isdefined(self.higgins_riders[self.driverIndex]))
		self.higgins_riders[self.driverIndex] delete();
	
	if (isdefined(self.script_firefx))
		self thread higgins_kill_burn();
	
	if (self.classname == "script_vehicle")
		self freevehicle();
}

higgins_kill_burn()
{
	self endon ("stop_boatfire_fx");
	self thread higgins_kill_burn_timeout();
	for (;;)
	{
		if (self == level.playerboat)
			playfxOnTag (level._effect["higgins"]["fire"], self, "tag_rearfire");
		else
			playfxOnTag (level._effect["higgins"]["fire"], self, "tag_wake");
		wait 2.0;
	}
}

higgins_kill_burn_timeout()
{
	wait 120;
	if (isdefined(self))
		self notify ("stop_boatfire_fx");
}

higgins_playerKill()
{
	//kills the player and the higgins boat if the player doesn't walk out of it within the allowed time after it lands on the beach
	level.player endon ("blew up");
	wait 5.5;
	level notify ("player_blew_up_in_higgins");
	level notify ("stop_plinkage");
	level.playerboat thread higgins_kill();
	
	level.player enableHealthShield(false);
	thread maps\_quotes::setDeadQuote();
	level.player dodamage(level.player.health + 10, level.player.origin);
	level.player enableHealthShield(true);
	assert(!isalive(level.player));
}

higgins_drive(vehicle)
{
	if (!isdefined(vehicle))
		vehicle = true;
	if(vehicle)
	{
		path = getVehicleNode (self.target,"targetname");
		assertEx(isdefined (path), "one of the boat paths not defined");
	
		self attachPath(path);
		self thread higgins_pathnodes_think(path);
	}
	
	self thread higgins_drones();
	
	if (getcvar("moveboat") != "0")
	{
		self thread higgins_fx_wake();
		self thread higgins_fx_smallSplash();
		if(vehicle)
			self startPath();
	}
}

higgins_sway(qDoNotes)
{
	self UseAnimTree(level.scr_animtree["boat"]);
	self endon ("stop_boat_sway");
	
	if ( (!isdefined(qDoNotes)) || ( (isdefined(qDoNotes)) && (!qDoNotes) ) )
	{
		wait randomfloat(3);
		self thread higgins_sway_notetracks();
	}
	
	for (;;)
	{
		self setflaggedanimknob ("sway_anim", level.scr_anim["higginsboat"]["sway"][randomint(level.scr_anim["higginsboat"]["sway"].size)]);
		self waittillmatch ("sway_anim","end");
	}
}

higgins_sway_notetracks()
{
	self endon ("stop_boat_sway");
	self endon ("stop_boat_fx");
	for (;;)
	{
		self waittill ("sway_anim",notetrack);
		if (notetrack == "splash")
			self thread higgins_fx_splash();
	}
}

higgins_fx_floorsplash()
{
	self endon ("stop_boat_fx");
	for (;;)
	{
		playfxOnTag (level._effect["higgins"]["floorsplash"], self, "tag_splash");
		wait 4;
	}
}

higgins_fx_wake()
{
	if (self == level.playerboat)
		return;
	self endon ("stop_boat_fx");
	for (;;)
	{
		playfxOnTag (level._effect["higgins"]["wake"], self, "tag_wake");
		wait .8;
	}
}

higgins_fx_smallSplash()
{
	if (self == level.playerboat)
		return;
	self endon ("stop_boat_fx");
	for (;;)
	{
		playfxOnTag (level._effect["higgins"]["sidesplash"], self, "tag_splash");
		playfxOnTag (level._effect["higgins"]["enginespray"], self, "tag_engineFX");
		wait .3;
	}
}

higgins_fx_splash()
{	
	playfxOnTag (level._effect["higgins"]["splash"], self, "tag_splash");
	self thread playSoundOnTag(level.scrsound["water_splash_shipbow"], "tag_splash");
	
	if (self == level.playerboat)
		thread atmosphere_waterSplashEye(1.2, (0.5 + randomfloat(0.7)) );
}

higgins_beachLanding()
{
	self notify ("stop_boat_sway");
	
	self setSpeed(0,1000);
	
	//store these landing positions so the new wave of boats can be spawned and land in the same spots for drones to work again
	level.higgins_wave2[level.higgins_wave2.size] = higgins_wave2_spawn(self.origin, self.angles, self.script_boat);
	
	//boat has reached the shore - open ramp and allow soldiers to run out
	self notify ("stop_boat_fx");
	self thread higgins_doorOpen();
	
	if (self == level.playerboat)
		level thread higgins_beachLanding_player();
}

higgins_beachLanding_player()
{
	level.player setOrigin (level.playerboat getTagOrigin("tag_player") + (0,0,3));
	level.player unlink();
	
	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);
	level.player allowStand(true);
	level.player allowCrouch(false);
	level.player allowProne(false);
	
	//put the water back
	water = getent("water_section","targetname");
	water show();
	water moveto (water.origin + (0,0,50), 1);
	
	//when player leaves the boat it blows up causing player to get thrown into the air
	//if the player does not move forward the boat eventually still explodes and kills the player
	thread higgins_playerKill();
	level endon ("player_blew_up_in_higgins");
	
	blowUpDist = 240;
	for(;;)
	{
		dist = distance(level.player.origin,level.playerboat.origin);
		if (dist >= blowUpDist)
			break;
		wait 0.05;
	}
	level.player notify ("blew up");
	level notify ("stop_plinkage");
	thread player_higgins_explosion();
	level.playerboat higgins_kill();
}

higgins_drones()
{
	if (!isdefined (self.script_boat))
		return;
	self waittill ("drones_run");
	
	//attach drone rig model
	droneRig = spawn("script_model",self.origin);
	droneRig.angles = self.angles;
	droneRig setModel ("xmodel/duhoc_drones_rig");
	
	if (self == level.playerboat)
	{
		droneRig.origin = (2172,-5445,-64.6);
		droneRig.angles = (0,90,0);
	}
	
	if(self.script_boat == "4")
		self thread higgins_fakeNotetracks_boat4();
	
	//attach higgins riders to their tags of the drone rig
	for (i=0;i<self.higgins_riders.size;i++)
	{
		//special positions dont do drone behavior (like the driver and maybe other positions later)
		if (self.higgins_riders[i].animTag == "tag_driver")
			continue;
		
		assert(isdefined(self.higgins_riders[i].animTag));
		if (self.script_boat == "3")
		{
			//self.higgins_riders[i] linkto (droneRig, self.higgins_riders[i].animTag);
			
			//figure out notetrackName
			notetrackName = self.higgins_riders[i] higgins_drones_getNotetrackName();
			assert(isdefined(notetrackName));
			
			self.higgins_riders[i] thread higgins_drones_think(droneRig, notetrackName, self.script_boat, self);
		}
		else
		{
			self.higgins_riders[i] thread boat_drones_run(self, self.higgins_riders[i].animTag);
		}
		self.higgins_riders[i] thread higgins_drones_remove();
	}
	
	droneRig thread higgins_dronerig_think(self.script_boat, self.higgins_riders);
}

boat_drones_run(eBoat, tagName)
{
	assert(tagName != "tag_driver");
	
	drone_exit_point_left = getent("drone_exit_point_left","targetname");
	drone_exit_point_right = getent("drone_exit_point_right","targetname");
	
	//look up the delay time for this tag
	delayTime = undefined;
	for (i=0;i<level.boatDroneTag.size;i++)
	{
		if (level.boatDroneTag[i] != tagName)
			continue;
		delayTime = level.boatDroneTag_delay[i];
		break;
	}
	assert(isdefined(delayTime));
	
	wait delayTime;
	
	exitLine_ang = eBoat getTagAngles("tag_body");
	
	forwardVec = anglestoforward(exitLine_ang);
	rightVec = anglestoright(exitLine_ang);
	upVec = anglestoup(exitLine_ang);
	
	exitLine_org = eBoat getTagOrigin("tag_body");
	exitLine_org += vectorMultiply(forwardVec, 230);
	
	distanceFromTag = boat_drones_getOffset(eBoat, tagName);
	runtoPos = exitLine_org;
	runtoPos += vectorMultiply(rightVec, distanceFromTag);
	
	self ShooterRun(runtoPos);
	
	//get the point meant for this ai
	runPath = undefined;
	for ( i = 0 ; i < level.struct_targetname["drone_path"].size ; i++ )
	{
		if (level.struct_targetname["drone_path"][i].script_boat != eBoat.script_boat)
			continue;
		if (level.struct_targetname["drone_path"][i].script_noteworthy != tagName)
			continue;
		//run to a point
		self thread droneRunPath(i);
	}
}

droneRunPath(index)
{
	struct = level.struct_targetname["drone_path"][index];
	for (;;)
	{
		if (!isdefined(struct.targeted))
			break;
		if (!isdefined(struct.targeted[0]))
			break;
		if ( (isdefined(struct.targeted[0].script_noteworthy)) && (struct.targeted[0].script_noteworthy != "shoot") )
			self ShooterRun(struct.targeted[0].origin, struct.targeted[0].script_noteworthy);
		else
			self ShooterRun(struct.targeted[0].origin);
		
		struct = struct.targeted[0];
	}
	assert(isdefined(struct));
	
	//see what the script_noteworthy on the last node is so I know what to do with the guy
	assert(isdefined (struct.script_noteworthy));
	
	if (!isdefined(self))
		return;
	
	self stopanimscripted();
	self useAnimTree(level.scr_animtree["higgins_drone"]);
	self.animname = "higgins_drone";
	if (struct.script_noteworthy == "bulletdeath")
		self thread drone_delayed_bulletdeath(undefined, "delete_beach_corpses");
	else if (struct.script_noteworthy == "cliffidle")
	{
		self notify ("stop_drone_run_anim");
		self notify ("stop_idle_anim");
		self.angles = struct.angles;
		self unlink();
		self.dummy = spawn("script_origin", struct.origin);
		self.dummy.angles = struct.angles;
		self anim_loop_solo ( self, "cliffidle", undefined, "stop_drone_cliffidle", self.dummy);
	}
	else if (struct.script_noteworthy == "shoot")
	{
		self notify ("stop_drone_run_anim");
		self notify ("stop_idle_anim");
		self.angles = struct.angles;
		self unlink();
		
		forwardVec = anglestoforward(struct.angles);
		rightVec = anglestoright(struct.angles);
		upVec = anglestoup(struct.angles);
		relativeOffset = (900,0,1200);
		shootPos = self.origin;
		shootPos += vectorMultiply(forwardVec, relativeOffset[0]);
		shootPos += vectorMultiply(rightVec, relativeOffset[1]);
		shootPos += vectorMultiply(upVec, relativeOffset[2]);
		shootTarget = spawn("script_origin",shootPos);
		
		self InitShooter();
		self thread ShooterShoot(shootTarget);
	}
}

boat_drones_getOffset(eBoat, tagName)
{
	rightVec = anglestoright(eBoat getTagAngles("tag_body"));
	difference = ( (eBoat getTagOrigin(tagName)) - (eBoat getTagOrigin("tag_body")) );
	return vectordot(difference, rightVec);
}

higgins_drones_getNotetrackName()
{
	switch(self.animTag)
	{
		case "tag_randall":
			return "randall_";
		case "tag_medic":
			return "medic_";
		case "tag_braeburn":
			return "mccloskey_";
		case "tag_mccloskey":
			return "braeburn_";
		case "tag_coffey":
			return "coffey_";
		case "tag_guy1":
			return "guy1_";
		case "tag_guy2":
			return "guy2_";
		case "tag_guy3":
			return "guy3_";
		case "tag_guy4":
			return "guy4_";
		case "tag_guy5":
			return "guy5_";
		case "tag_guy6":
			return "guy6_";
		case "tag_guy7":
			return "guy7_";
		case "tag_guy8":
			return "guy8_";
		case "tag_guy9":
			return "guy9_";
		case "tag_guy10":
			return "guy10_";
		case "tag_guy11":
			return "guy11_";
		case "tag_guy12":
			return "guy12_";
		case "tag_guy13":
			return "guy13_";
	}
}

higgins_dronerig_think(boatNum, drones)
{
	assert(isdefined(level.scr_anim["higgins_dronerig"][boatNum]));
	assert(isdefined(level.scr_anim["higgins_drone_animrate"][boatNum]));
	
	self UseAnimTree(level.scr_animtree["higgins_dronerig"]);
	self.animname = "higgins_dronerig";
	wait (level.scr_anim["higgins_drone_anim_delay"][boatNum]);
	self setflaggedanim("drone_rig_anim", level.scr_anim["higgins_dronerig"][boatNum], 1.0, 0.0, level.scr_anim["higgins_drone_animrate"][boatNum]);
}

higgins_drones_remove()
{
	level waittill ("delete_all_drones");
	self notify("stop_idle_anim");
	self notify ("stop_drone_run_anim");
	if (!isdefined(self))
		return;
	self unlink();
	wait 0.05;
	self delete();
}

higgins_drones_specialAnim(animName, waitTime, doUnlink)
{
	self endon ("death");
	if (!isdefined(doUnlink))
		doUnlink = true;
	if (isdefined(waitTime))
		wait (waitTime);
	if(!isdefined(self))
		return;
	self notify ("stop_drone_run_anim");
	if (doUnlink)
		self unlink();
	
	self animscripted( "drone_special_anim", self.origin, self.angles, level.scr_anim[self.animname][animName], "deathplant");
	self waittillmatch("drone_special_anim","end");
}

higgins_drones_fakeNotetracks_boat3(droneRig, check)
{	
	if (!isdefined(check))
		check = false;
	switch(self.animTag)
	{
		//bullet deaths when leaving boat
		case "tag_guy9":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 4.2);
			return true;
		case "tag_randall":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 4.6);
			return true;
		case "tag_mccloskey":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 4.8);
			return true;
	}
	if (check)
		return false;
}

higgins_drones_fakeNotetracks_boat4(droneRig, check)
{	
	if (!isdefined(check))
		check = false;
	switch(self.animTag)
	{
		//bullet deaths when leaving boat
		case "tag_guy13":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 0.3);
			return true;
		case "tag_guy11":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_crumple", 1.5);
			return true;
		case "tag_guy12":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 1.2);
			return true;
		case "tag_guy10":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 1.4);
			return true;
		case "tag_medic":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 0.5);
			return true;
		case "tag_guy1":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_crumple", 0.9);
			return true;
		case "tag_guy7":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 1.2);
			return true;
		case "tag_randall":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 1.4);
			return true;
		
		//mortar explosion 1
		case "tag_guy2":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_up", 6.3);
			return true;
		case "tag_guy8":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_left", 6.3);
			return true;
		case "tag_coffey":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_right", 6.3);
			return true;
		case "tag_braeburn":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_back", 6.3);
			return true;
	}
	if (check)
		return false;
}

higgins_drones_fakeNotetracks_boat5(droneRig, check)
{	
	if (!isdefined(check))
		check = false;
	switch(self.animTag)
	{
		//bullet deaths when leaving boat
		case "tag_guy12":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 1.7);
			return true;
		case "tag_mccloskey":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 1.85);
			return true;
		case "tag_guy13":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 2.6);
			return true;
		case "tag_braeburn":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 7.5);
			return true;
		case "tag_guy8":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onfront", 8.2);
			return true;
		
		//mortar explosion 1
		case "tag_guy9":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_forward", 5.3);
			return true;
		case "tag_randall":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_right", 5.3);
			return true;
		case "tag_guy3":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_back", 5.3);
			return true;
	}
	if (check)
		return false;
}

higgins_drones_fakeNotetracks_boat6(droneRig, check)
{	
	if (!isdefined(check))
		check = false;
	switch(self.animTag)
	{
		//bullet deaths when leaving boat
		case "tag_guy12":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 1.8);
			return true;
		case "tag_guy1":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 3.2);
			return true;
		case "tag_guy11":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_crumple", 2.2);
			return true;
		case "tag_guy7":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 2.4);
			return true;
		case "tag_guy3":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 6);
			return true;
		case "tag_guy8":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onfront", 7.5);
			return true;
		case "tag_guy13":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 6.3);
			return true;
		case "tag_randall":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_onleft", 5.5);
			return true;
		case "tag_guy10":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 6.3);
			return true;
		case "tag_guy2":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_crumple", 9.0);
			return true;
		
		//boat explosion deaths
		case "tag_braeburn":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_forward", 9.0);
			return true;
		case "tag_guy4":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_forward", 9.0);
			return true;
		case "tag_guy5":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_up", 9.0);
			return true;
	}
	if (check)
		return false;
}

higgins_drones_fakeNotetracks_boat7(droneRig, check)
{	
	if (!isdefined(check))
		check = false;
	switch(self.animTag)
	{
		//bullet deaths when leaving boat
		case "tag_guy1":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 3.1);
			return true;
		case "tag_guy9":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 2.0);
			return true;
		case "tag_braeburn":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_dropinplace", 2.0);
			return true;
		case "tag_guy3":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 5.4);
			return true;
		case "tag_guy5":
			if (!check)
				self thread higgins_drones_specialAnim("bulletdeath_stumble", 5.4);
			return true;
		
		//mortar explosion death
		case "tag_guy10":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_left", 2.0);
			return true;
		case "tag_guy11":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_left", 2.0);
			return true;
		case "tag_guy12":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_right", 2.0);
			return true;
		case "tag_guy13":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_forward", 2.0);
			return true;
		case "tag_randall":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_up", 2.0);
			return true;
		case "tag_guy7":
			if (!check)
				self thread higgins_drones_specialAnim("mortardeath_right", 2.0);
			return true;
	}
	if (check)
		return false;
}

higgins_fakeNotetracks_boat4()
{
	getent("boat4_bulletimpacts","script_noteworthy") notify ("trigger");
	
	wait 4.8;
	
	self.script_firefx = 1;
	self thread higgins_kill();
	self notify ("stop_boat_sway");
	self notify ("dont_close_gate");
	
	mortar = getent("boat4_mortar","targetname");
	mortar maps\_mortar::duhoc_style_mortar_explode(true);
	level thread scripted_event_burningGuys(self);
}

higgins_fakeNotetracks_boat6()
{
	wait 9.0;
	self.script_firefx = 1;
	self thread higgins_kill();
}

higgins_drones_think(droneRig, notetrackName, boatNum, eBoat)
{
	//------------------------------------
	//ONLY PLAYERS BOAT DOES THIS FUNCTION
	//------------------------------------
	
	//dead guys return out
	if ( (self.animTag == "tag_guy8") || (self.animTag == "tag_guy9") || (self.animTag == "tag_randall") )
		return;
	
	//if this guy has a _startrun notetrack wait for it
	if (notetrackName == "medic_")
		wait 1;
	else
	if ( animhasnotetrack(level.scr_anim["higgins_dronerig"][boatNum], notetrackName + "startrun") )
	{
		for (;;)
		{
			droneRig waittill ("drone_rig_anim", noteTrack);
			if (noteTrack == (notetrackName + "startrun"))
				break;
		}
	}
	
	if (notetrackName == "coffey_")
		wait 0.2;
	
	self linkto (droneRig, self.animTag);
	
	self endon ("death");
	level endon ("delete_all_drones");
	self notify ("stop_idle_anim");
	self.animname = "higgins_drone";
	self stopanimscripted();
	self UseAnimTree(level.scr_animtree["higgins_drone"]);
	self notify ("stop_idle_anim");
	self notify ("ima_drone_now");
	
	rand = randomint(3);
	if (rand == 0)
		runAnimation = "run1";
	else if (rand == 1)
		runAnimation = "run2";
	else
		runAnimation = "run3";
	
	if(self.animTag == "tag_medic")
		runAnimation = "run_medic";
	
	//stop all other animations that might be playing
	self stopanimscripted();
	self notify ("stop_idle_anim");
	self notify ("stop_lean_idle");
	self notify ("stop_crouch_idle");
	
	anim_single_solo( self, "idle2run", self.animTag, undefined, droneRig );
	thread anim_loop_solo( self, runAnimation, self.animTag, "stop_drone_run_anim", undefined, droneRig );
	
	if (getcvarint("duhoc_firedrones") > 0)
	{
		self thread scripted_event_burningGuys_playfx("J_Spine3", level._effect["torso"], .3);
		self thread scripted_event_burningGuys_playfx("J_Wrist_RI", level._effect["arms"], .1);
		self thread scripted_event_burningGuys_playfx("J_Wrist_LE", level._effect["arms"], .1);
	}
	
	//do drone notetracks
	//-------------------
	//-------------------
	/*
	for (;;)
	{
		droneRig waittill ("drone_rig_anim", noteTrack);
		if (noteTrack == (notetrackName + "end"))
		{
			self notify ("stop_drone_run_anim");
			self.angles = self.angles + (0,180,0);
			self anim_loop_solo ( self, "cliffidle", undefined, "stop_drone_cliffidle" );
			return;
		}
	}
	*/
	//-------------------
	//-------------------
}

higgins_drones_orientToNormal(normal)
{
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);

	if(!hor_length)
		return (0, 0, 0);
	
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);
	
	return plant_angle;
}

higgins_spawn_characters()
{
	//creates higgins.higgins_riders and fills it with the script_model characters that ride in the boat
	//it also makes them begin playing their idle animations and think threads
	higgins = self;
	self.higgins_riders = [];
	
	//this section handles the random guys riding in the boat (white characters)
	for (i=0;i<level.higgins_character_count;i++)
	{
		tagName = level.higgins_character_tag_order[i];
		
		if (self != level.playerboat)
		{
			self higgins_spawn_individualCharacter(tagName);
			continue;
		}
		
		switch(tagName)
		{
			case "tag_randall":
				self higgins_spawn_individualCharacter(tagName, "randall");
				break;
			case "tag_guy6":
				self higgins_spawn_individualCharacter("tag_braeburn");
				break;
			case "tag_mccloskey":
				self higgins_spawn_individualCharacter("tag_guy6", "mccloskey");
				break;
			case "tag_coffey":
				self higgins_spawn_individualCharacter(tagName, "coffey");
				break;
			case "tag_driver":
				self higgins_spawn_individualCharacter(tagName, "coxswain");
				break;
			case "tag_medic":
				self higgins_spawn_individualCharacter(tagName, "wells");
				break;
			case "tag_braeburn":
				self higgins_spawn_individualCharacter("tag_mccloskey", "braeburn");
				break;
			case "tag_guy1":
				self higgins_spawn_individualCharacter(tagName, "carbine");
				break;
			default:
				self higgins_spawn_individualCharacter(tagName);
				break;
		}
	}
	
	if (self == level.playerboat)
	{
		//make sure all the guys were created sucessfully
		assertex( isdefined (level.randall), "level.randall not defined" );
		assertex( isdefined (level.braeburn), "level.braeburn not defined" );
		assertex( isdefined (level.mccloskey), "level.mccloskey not defined" );
		assertex( isdefined (level.coffey), "level.coffey not defined" );
		assertex( isdefined (level.coxswain), "level.coxswain not defined" );
	}
}

higgins_spawn_individualCharacter(tagName, specialPosition)
{
	index = self.higgins_riders.size;
	
	if (tagName == "tag_driver")
	{
		//British driver
		self.higgins_riders[index] = character_nonAI_spawn("british");
		self.higgins_riders[index].driver = true;
		self.driverIndex = index;
	}
	else if (tagName == "tag_medic")
	{
		//American medic
		self.higgins_riders[index] = character_nonAI_spawn("medic");
	}
	else
	{
		//American soldier
		if (self == level.playerboat)
			self.higgins_riders[index] = character_nonAI_spawn("ranger");
		else
			self.higgins_riders[index] = character_nonAI_spawn_lowRes("ranger");
	}
	//-----------------------------------------------------------------------------------
	
	self.higgins_riders[index].animTag = tagName;
	self.higgins_riders[index].origin = self getTagOrigin (self.higgins_riders[index].animTag);
	self.higgins_riders[index].higgins = self;
	self.higgins_riders[index] linkto (self, self.higgins_riders[index].animTag);
	
	animTree = "higginsriders";
	if (self.higgins_riders[index].animTag == "tag_driver")
		animTree = "higginsdriver";
	animName = self.higgins_riders[index].animTag;
	
	customWeapon = undefined;
	
	//special position treatment here
	if ( (self == level.playerboat) && (tagName == "tag_guy3") )
		level.preyGuy = self.higgins_riders[index];
	if ( (isdefined (specialPosition)) && (self == level.playerboat) )
	{
		switch (specialPosition)
		{	
			case "coxswain":
				level.coxswain = self.higgins_riders[index];
				animTree = "coxswain";
				animName = "coxswain";
				break;
			case "randall":
				self.higgins_riders[index] detachall();
				self.higgins_riders[index] character\american_ranger_randall_wet::main();
				level.randall = self.higgins_riders[index];
				level.randall.script_friendname = "Sgt. Randall";
				level.randall thread maps\_drones::drone_setName();
				animTree = "randall";
				animName = "randall";
				customWeapon = "thompson";
				break;
			case "braeburn":
				self.higgins_riders[index] detachall();
				self.higgins_riders[index]character\american_ranger_braeburn_wet::main();
				self.higgins_riders[index] attach("xmodel/us_ranger_radio_back");
				level.braeburn = self.higgins_riders[index];
				level.braeburn.script_friendname = "Pvt. Braeburn";
				level.braeburn thread maps\_drones::drone_setName();
				animTree = "braeburn";
				animName = "braeburn";
				customWeapon = "BAR";
				break;
			case "mccloskey":
				self.higgins_riders[index] detachall();
				self.higgins_riders[index] character\american_ranger_mccloskey_wet::main();
				level.mccloskey = self.higgins_riders[index];
				level.mccloskey.script_friendname = "Pvt. McCloskey";
				level.mccloskey thread maps\_drones::drone_setName();
				animTree = "mccloskey";
				animName = "mccloskey";
				customWeapon = "thompson";
				break;
			case "coffey":
				self.higgins_riders[index] detachall();
				self.higgins_riders[index] character\american_ranger_coffey_wet::main();
				level.coffey = self.higgins_riders[index];
				level.coffey.script_friendname = "Lt. Coffey";
				level.coffey thread maps\_drones::drone_setName();
				animTree = "coffey";
				animName = "coffey";
				customWeapon = "thompson";
				break;
			case "carbine":
				customWeapon = "thompson";
				break;
		}
	}
	
	if (tagName == "tag_medic")
	{
		animTree = "wells";
		animName = "wells";
	}
	
	//set the animname
	self.higgins_riders[index].animname = animName;
	assert(isdefined(level.scr_anim[animName]["idle"]));
	
	// start this guys looping idle animations
	
	// do animations on all drivers, and only soldiers within certain boats
	doAnim = false;
	if (tagName == "tag_driver")
		doAnim = true;
	if (self.script_boat == "3")
		doAnim = true;
	
	self.higgins_riders[index] stopanimscripted();
	self.higgins_riders[index] UseAnimTree(level.scr_animtree[animTree]);
	if (doAnim)
	{
		if ( (!isdefined (specialPosition)) || (self != level.playerboat) )
			self.higgins_riders[index] thread higgins_character_loopanims(randomfloat(2));
		else
			self.higgins_riders[index] thread higgins_character_loopanims();
	}
	else
	{
		self.higgins_riders[index] animscripted( "single anim", self getTagOrigin(tagName), self getTagAngles(tagName), level.scr_anim[animName]["idle"][0] );
	}
	
	
	//give guns to the drones unless they are a medic or driver
	if (self.higgins_riders[index].animTag == "tag_driver")
		return;
	if (self.higgins_riders[index].animTag == "tag_medic")
		return;
	
	// all other boat riders get a gun
	self.higgins_riders[index] character_assignWeapon(customWeapon);
}

higgins_attach_grapplingHooks()
{
	if ( (isdefined (self.script_noteworthy)) && (self.script_noteworthy == "has_hooks") )
	{
		if (isdefined(self.script_minspec_hooks_level))
		{
			if (getcvarint("scr_duhoc_assault_drones") < self.script_minspec_hooks_level)
				return;
		}
		
		//Align model to (0,0,0) for easy math calulations for model attachments
		self.angles = (0,0,0);
		
		//Attach the mortar tubes
		self.grapplingHook_base = spawn("script_model",self.origin);
		self.grapplingHook_base.angles = self.angles;
		self.grapplingHook_base setmodel ("xmodel/vehicle_higgins_mortors");
		self.grapplingHook_base linkto (self, "tag_engine_right");
		
		tagName = undefined;
		ropeModel = undefined;
		for (i=0;i<4;i++)
		{
			switch (i)
			{
				case 0:
					tagName = "tag_grapple_base_01";
					ropeModel = "xmodel/vehicle_higgins_grapple_rope_short_l";
					break;
				case 1:
					tagName = "tag_grapple_base_02";
					ropeModel = "xmodel/vehicle_higgins_grapple_rope_short_r";
					break;
				case 2:
					tagName = "tag_grapple_base_03";
					ropeModel = "xmodel/vehicle_higgins_grapple_rope_short_l";
					break;
				case 3:
					tagName = "tag_grapple_base_04";
					ropeModel = "xmodel/vehicle_higgins_grapple_rope_short_r";
					break;
			}
			assert(isdefined(tagName));
			assert(isdefined(ropeModel));
			
			//Attach the grappling hooks to each mortar tube, and add a rope
			self.grabblingHook[i] = spawn("script_model", self.grapplingHook_base getTagOrigin(tagName) );
			self.grabblingHook[i].angles = self.grapplingHook_base getTagAngles(tagName);
			self.grabblingHook[i] setModel("xmodel/vehicle_higgins_grapple_hook");
			self.grabblingHook[i] linkto (self.grapplingHook_base);
			
			self.grabblingRope[i] = spawn("script_model", self.grapplingHook_base getTagOrigin(tagName) );
			self.grabblingRope[i].angles = self.grapplingHook_base getTagAngles(tagName);
			self.grabblingRope[i] setModel(ropeModel);
			self.grabblingRope[i] linkto (self.grapplingHook_base);
		}
	}
}

higgins_character_loopanims(randomWait)
{
	self endon ("ima_drone_now");
	//to make guys not play their idles in sync
	if (isdefined (randomWait))
		wait (randomWait);
	
	//start the initial idle animation loops
	self notify ("stop_idle_anim");
	
	thread anim_loop_solo( self, "idle", self.animTag, "stop_idle_anim", undefined, self.higgins );
}

higgins_character_specialAnim_duck()
{
	self endon ("ima_drone_now");
	wait randomfloat(1);
	
	animName = undefined;
	
	//stop their main idle loop for a moment
	self notify ("stop_idle_anim");
	self notify ("stop_lean_idle");
	self notify ("stop_crouch_idle");
	//play crouch down animation
	self anim_single_solo( self, "duck_down" );
	self notify ("stop_idle_anim");
	self notify ("stop_lean_idle");
	self notify ("stop_crouch_idle");
	//begin looping the crouch idle
	self thread anim_loop_solo( self, "duck_idle", undefined, "stop_crouch_idle" );
	
	wait 6.5;
	
	//stop the crouch idle animation
	self notify ("stop_crouch_idle");
	//play stand up animation
	self anim_single_solo( self, "duck_up" );
}

higgins_doorOpen()
{
	self endon ("dont_close_gate");
	self UseAnimTree(level.scr_animtree["boat"]);
	self thread playSoundOnTag(level.scrsound["boat_gate"], "ramp_open_jnt");
	
	self setflaggedanimknobrestart ("drop_door", level.scr_anim["higginsboat"]["dooropen"]);
	self waittillmatch ("drop_door","end");
	
	if (getcvarint("duhoc_drones_run") > 0)
		self notify ("drones_run");
	
	self endon ("death");
	wait 8;
	if (self == level.playerboat)
		return;
	self setflaggedanimknobrestart ("close_door", level.scr_anim["higginsboat"]["doorclose"]);
	wait 2;
	if (self.classname == "script_vehicle")
		self resumeSpeed(5);
	self thread higgins_sway(false);
}

higgins_pathnodes_think(firstNode)
{
	//get first node then set a wait node on everynode checking it's noteworthy
	self endon ("death");
	lastNode = firstNode;
	for (;;)
	{
		if (!isdefined (lastNode.target))
			return;
		nextNode = getVehicleNode(lastNode.target,"targetname");
		if (!isdefined (nextNode))
			return;
		
		self setWaitNode (nextNode);
		self waittill ("reached_wait_node");
		
		if (isdefined (nextNode.script_noteworthy))
		{
			switch (nextNode.script_noteworthy)
			{
				case "fire_rockets":
					self thread higgins_fireRopes();
					break;
				case "mortars_on_beach":
					//makes the mortars on the beach start up when the players higgins boat gets to the special point on it's path				
					level notify ("start_mortars 0");
					break;
				case "open_gate":
					self thread higgins_beachLanding();
					break;
				case "blow_up":
					self thread higgins_kill();
					break;
			}
		}
		lastNode = nextNode;
	}
}

higgins_fireRopes()
{
	if (isdefined(self.script_minspec_hooks_level))
	{
		if (getcvarint("scr_duhoc_assault_drones") < self.script_minspec_hooks_level)
			return;
	}
	if (!isdefined (self.script_noteworthy))
		return;
	if (self.script_noteworthy != "has_hooks")
		return;
	
	self thread higgins_fireRopes_individual(0);
	self thread higgins_fireRopes_individual(1);
	wait 1;
	self thread higgins_fireRopes_individual(2);
	self thread higgins_fireRopes_individual(3);
}

higgins_fireRopes_individual(index)
{
	//Attach a rope to each mortar tube
	if (!isdefined (self.rope))
		self.rope = [];
	tagName = undefined;
	fxTagName = undefined;
	switch (index)
	{
		case 0:
			tagName = "tag_grapple_base_01";
			fxTagName = "tag_flash_01";
			break;
		case 1:
			tagName = "tag_grapple_base_02";
			fxTagName = "tag_flash_02";
			break;
		case 2:
			tagName = "tag_grapple_base_03";
			fxTagName = "tag_flash_03";
			break;
		case 3:
			tagName = "tag_grapple_base_04";
			fxTagName = "tag_flash_04";
			break;
	}
	
	assert(isdefined(tagName));
	assert(isdefined(fxTagName));
	
	self.rope[index] = spawn ("script_model", self.grapplingHook_base getTagOrigin(tagName) );
	self.rope[index].angles = self.grapplingHook_base getTagAngles(tagName);
	self.rope[index] setModel (level.ropeModel);
	self.rope[index] linkto (self.grapplingHook_base);
	self.rope[index].animname = "rope";
	
	//get the location it should move to over time
	finalOrg = undefined;
	finalAng = undefined;
	orgs = getentarray(self.target,"targetname");
	for (i=0;i<orgs.size;i++)
	{
		if (orgs[i].classname != "script_origin")
			continue;
		if ( int(orgs[i].script_noteworthy2) != index )
			continue;
		
		assert(isdefined(orgs[i].script_rope));
		self.rope[index].script_rope = orgs[i].script_rope;
		
		finalOrg = orgs[i].origin;
		finalAng = orgs[i].angles;
	}
	assert(isdefined(finalOrg));
	assert(isdefined(finalAng));
	
	//play the animation on the rope
	self.rope[index] thread higgins_fireRopes_individual_anim(self.grabblingHook[index], self.grabblingRope[index], finalOrg, finalAng);
	playfxontag(level._effect["higgins"]["rocket_launch"], self.grapplingHook_base, fxTagName);
	self.grapplingHook_base thread playSoundOnTag(level.scrsound["rocket_hook"], fxTagName);
}

higgins_fireRopes_individual_anim(hook, tempRope, finalOrg, finalAng)
{
	assert(isdefined(self.script_rope));
	assert(isdefined(level.scr_anim["rope"]["launch"][self.script_rope]));
	
	hook.origin = self getTagOrigin("cj40");
	hook.angles = self getTagAngles("cj40");
	hook linkto (self, "cj40");
	
	tempRope delete();
	
	self UseAnimTree(level.scr_animtree["rope"]);
	//self thread debug_rope_positions();
	self setflaggedanimknobrestart ("rope_anim", level.scr_anim["rope"]["launch"][self.script_rope]);
	
	assert(isdefined(finalOrg));
	assert(isdefined(finalAng));
	
	//wait until the rope has left the boat completely before moving it
	if (animhasnotetrack(level.scr_anim["rope"]["launch"][self.script_rope], "rope_exit"))
		self waittillmatch ("rope_anim", "rope_exit");
	
	//move the animation to the final positions over time, to make sure the ropes always land in the exact same spot
	self unlink();
	self moveTo(finalOrg, level.ropeBlendTime[self.script_rope]);
	self rotateTo(finalAng, level.ropeBlendTime[self.script_rope]);
	
	//wait until the animation is over
	self waittillmatch ("rope_anim", "end");
	
	if( (self.script_rope == "player") ||
		(self.script_rope == "1") ||
		(self.script_rope == "2") ||
		(self.script_rope == "3") ||
		(self.script_rope == "4") ||
		(self.script_rope == "5") )
	{
		self thread rope_climbAnim();
	}
	else
	{
		hook delete();
		self delete();
	}
}

higgins_blockers_show(qShow)
{
	higgins_blocker = getentarray("higgins_blocker","targetname");
	for (i=0;i<higgins_blocker.size;i++)
	{
		if (qShow)
			higgins_blocker[i] show();
		else
			higgins_blocker[i] hide();
	}
}

higgins_wave2_spawn(landingOrg, landingAng, boatNum)
{
	offShoreDist = -5000;
	switch(boatNum)
	{
		case "0":	return;
		case "1":	offShoreDist = -3000;	break;
		case "2":	offShoreDist = -3000;	break;
		case "3":	return;
		case "4":	return;
		case "5":	offShoreDist = -5000;	break;
		case "6":	offShoreDist = -5000;	break;
		case "7":	offShoreDist = -6000;	break;
		case "8":	return;
		case "9":	offShoreDist = -6500;	break;
	}
	
	higgins = spawn( "script_model", (0,0,0) );
	higgins setModel ("xmodel/vehicle_higgins");
	higgins.targetname = "higgins_wave2";
	higgins.script_boat = boatNum;
	
	level.boat_collision[int(boatNum)].origin = higgins.origin;
	level.boat_collision[int(boatNum)].angles = higgins.angles;
	level.boat_collision[int(boatNum)] linkto (higgins);
	
	//move it to a good starting point out off shore
	forwardVec = anglestoforward(landingAng);
	rightVec = anglestoright(landingAng);
	upVec = anglestoup(landingAng);
	
	relativeOffset = (offShoreDist,0,0);
	boatPos = landingOrg;
	boatPos += vectorMultiply(forwardVec, relativeOffset[0]);
	boatPos += vectorMultiply(rightVec, relativeOffset[1]);
	boatPos += vectorMultiply(upVec, relativeOffset[2]);
	
	higgins.origin = boatPos;
	higgins.angles = landingAng;
	
	higgins.landingPos = landingOrg;
	
	higgins hide();
	
	return higgins;
}

higgins_wave2_start()
{
	for (i=0;i<level.higgins_wave2.size;i++)
	{
		if (isdefined(level.higgins_wave2[i]))
			level.higgins_wave2[i] thread higgins_wave2_start_think();
	}
}

higgins_wave2_start_think()
{
	self show();
	assert(isdefined(self.landingPos));
	
	d = distance(self.origin, self.landingPos);
	moveTime = (d/150);
	
	self moveto (self.landingPos, moveTime, 0, 3);
	
	self higgins_life();
	self thread higgins_spawn_characters();
	self thread higgins_drive(false);
	self thread higgins_sway();
	
	wait moveTime;
	self notify ("reached_end_node");
	self notify ("stop_boat_sway");
	self notify ("stop_boat_fx");
	self thread higgins_doorOpen();
}

character_nonAI_spawn_lowRes(type, location)
{
	return character_nonAI_spawn(type, location, true);
}

character_nonAI_spawn(type, location, lowRes)
{
	//-----------------------------------------------------------------------------------
	//create a character using the valid bodys, heads, helmets, and other attached models
	//-----------------------------------------------------------------------------------
	setName = true;
	if (!isdefined(location))
		location = (0,0,0);
	if (!isdefined(lowRes))
		lowRes = false;
	guy = spawn ("script_model", location );
	
	if (!isdefined(type))
		type = "ranger";
	
	if (type == "british")
		guy character\british_duhoc_driver::main();
	else
	if (type == "medic")
		guy character\american_ranger_medic_wells_wet::main();
	else
	if (type == "radioguy")
		guy character\american_ranger_radio_wet::main();
	else
	if (type == "ranger")
	{
		if (lowRes)
			guy character\american_ranger_normandy_low_wet::main();
		else
			guy character\american_ranger_normandy_wet::main();
	}
	else
	if (type == "randall")
	{
		guy.script_friendname = "Sgt. Randall";
		guy character\american_ranger_randall_wet::main();
	}
	
	assert(isdefined(guy));
	guy.targetname = "drone";
	guy.team = "allies";
	guy makeFakeAI();
	
	guy drones_clear_variables();
	
	guy thread maps\_drones::drone_setName();
	
	return guy;
}

character_assignWeapon(customWeapon)
{
	weaponIndex = randomint(level.higgins_character_weapons.size);
	if (isdefined(customWeapon))
	{
		switch (customWeapon)
		{
			case "thompson":	weaponIndex = 0;	break;
			case "m1garand":	weaponIndex = 1;	break;
			case "m1carbine":	weaponIndex = 2;	break;
			case "BAR":			weaponIndex = 3;	break;
		}
	}
	
	weapon = level.higgins_character_weapons[weaponIndex];
	
	switch(weaponIndex)
	{
		case 0: self.weapon = "thompson";	break;
		case 1:	self.weapon = "m1garand";	break;
		case 2:	self.weapon = "m1carbine";	break;
		case 3:	self.weapon = "BAR"; 		break;
	}
	
	self.weaponModel = level.higgins_character_weapons[weaponIndex];
	self attach(weapon, "tag_weapon_right");
}
/*
beach_springfieldRifle()
{
	springfield_ammo = 5;
	
	gun = getent("springfield","targetname");
	if (!isdefined(gun))
		return;
	gun waittill ("trigger");
	
	//set the ammount of ammo the springfield has
	//-------------
	
	slot1 = level.player getweaponslotweapon("primary");
	slot2 = level.player getweaponslotweapon("primaryb");
	if (slot1 == "springfield")
	{
		level.player setweaponslotammo("primary", springfield_ammo - 5);
		level.player setweaponslotclipammo("primary", springfield_ammo);
	}
	else if (slot2 == "springfield")
	{
		level.player setweaponslotammo("primaryb", springfield_ammo - 5);
		level.player setweaponslotclipammo("primaryb", springfield_ammo);
	}
	else
		assertMsg("player picked up the springfield but didn't actually get it");
}
*/
beach_spawnGuys()
{
	spawners = getentarray("beachguy","targetname");
	for (i=0;i<spawners.size;i++)
	{
		assert(isdefined(spawners[i].script_minspec_level));
		if (getcvarint("scr_duhoc_assault_drones") < spawners[i].script_minspec_level)
			continue;
		guy = spawners[i] stalingradSpawn();
		if (spawn_failed(guy))
			assertMsg("beachguy didn't spawn");
		guy allowedStances("stand","crouch");
		guy.anim_disablePain = true;
		guy.baseAccuracy = 0;
		if ( (isdefined(guy.script_noteworthy)) && (guy.script_noteworthy == "bulletshield") )
			guy thread magic_bullet_shield();
	}
}

scripted_event_boatDeath_1()
{
	if (!isdefined(level.guy9bulletdeath))
		return;
	
	//get the tag_guy9 guy
	guy = undefined;
	for (i=0;i<level.playerboat.higgins_riders.size;i++)
	{
		if (level.playerboat.higgins_riders[i].animTag != "tag_guy9")
			continue;
		guy = level.playerboat.higgins_riders[i];
	}
	assert(isdefined(guy));
	
	wait 32.0;
	
	guy notify ("stop_idle_anim");
	guy setcontents(0);
	guy thread anim_single_solo( guy, "shot", guy.animtag, undefined, level.playerboat );
	guy waittillmatch ("single anim","bullit_hit");
	
	playfxontag(level._effect["impact_flesh1"], guy, "J_Cheek_RI");
	
	level.playerboat playSoundOnTag ("headshot", "tag_guy9");
}

scripted_event_boatDeath_2()
{
	//get the tag_randall guy
	guy = undefined;
	for (i=0;i<level.playerboat.higgins_riders.size;i++)
	{
		if (level.playerboat.higgins_riders[i].animTag != "tag_randall")
			continue;
		guy = level.playerboat.higgins_riders[i];
	}
	assert(isdefined(guy));
	
	wait 33.8;
	
	guy notify ("stop_idle_anim");
	guy notify ("stop_lean");
	guy setcontents(0);
	guy thread anim_single_solo( guy, "shot", guy.animtag, undefined, level.playerboat );
	guy waittillmatch ("single anim","bullethit");
	
	playfxontag(level._effect["impact_flesh1"], guy, "J_Neck");
	
	level.playerboat playSoundOnTag ("headshot", "tag_randall");
}

scripted_event_boatDeath_3()
{
	//get the tag_guy8 guy
	guy = undefined;
	for (i=0;i<level.playerboat.higgins_riders.size;i++)
	{
		if (level.playerboat.higgins_riders[i].animTag != "tag_guy8")
			continue;
		guy = level.playerboat.higgins_riders[i];
	}
	assert(isdefined(guy));
	
	wait 34.1;
	
	guy notify ("stop_idle_anim");
	guy setcontents(0);
	guy thread anim_single_solo( guy, "shot", guy.animtag, undefined, level.playerboat );
	guy waittillmatch ("single anim","bullethit");
	
	playfxontag(level._effect["headshot"], guy, "J_Neck");
	
	level.playerboat playSoundOnTag ("headshot", "tag_guy8");
}

scripted_event_woundedShellShockMoments()
{
	wait 3.5;
	thread scripted_event_woundedShellShockMoments_runnerDeath();
}

scripted_event_woundedShellShockMoments2()
{
	wait 11;
	getent("shellshock_mortar3","targetname") thread maps\_mortar::duhoc_style_mortar_explode(true);
	wait 8;
	getent("shellshock_mortar4","targetname") thread maps\_mortar::duhoc_style_mortar_explode(true);
}

scripted_event_woundedShellShockMoments_runnerDeath()
{
	start = getentarray("shellshock_runnerDeath","targetname");
	
	thread scripted_event_woundedShellShockMoments_runnerDeath_think( start[0] , getent(start[0].target,"targetname") , "bulletdeath_dropinplace" );
	thread scripted_event_woundedShellShockMoments_runnerDeath_think( start[1] , getent(start[1].target,"targetname") , "bulletdeath_onleft" );
	
	wait 0.5;
	getent("shellshock_impacts","script_noteworthy") notify ("trigger");
}

scripted_event_woundedShellShockMoments_runnerDeath_think(start, end, deathAnim)
{
	guy = character_nonAI_spawn();
	guy character_assignWeapon("m1garand");
	guy UseAnimTree(level.scr_animtree["higgins_drone"]);
	guy.origin = start.origin;
	guy.animName = "higgins_drone";
	
	dummy = spawn("script_origin",start.origin);
	ang = VectorToAngles( end.origin - start.origin );
	guy.angles = (0,ang[1],0);
    dummy.angles = (0,ang[1],0);
    
    guy linkto (dummy);
    d = distance(start.origin,end.origin);
    speed = (d/200);
    
    guy thread anim_loop_solo( guy, "run1", undefined, "stop_dronerun_anim", undefined );
    
    dummy moveTo (end.origin, speed);
    
    wait speed;
    
    //guy dies now
    guy notify ("stop_dronerun_anim");
    guy animscripted("deathanim", guy.origin, guy.angles, level.scr_anim[guy.animname][deathAnim], "deathplant");
    
    level waittill ("delete_all_drones");
    guy delete();
}

scripted_event_burningGuys(eBoat)
{
	burnOrg = spawn("script_origin", (1559.5878, -5338.3403, -30.6535) );
	burnOrg.angles = (0,82.705,0);
	
	burner = [];
	for( i = 0 ; i < 3 ; i++ )
	{
		burner[i] = character_nonAI_spawn_lowRes();
		burner[i] UseAnimTree(level.scr_animtree["wounded"]);
		burner[i].origin = (1590,-5185,-50);
		burner[i].animName = "wounded";
		if ( i == 1 )
			burner[i] character_assignWeapon("BAR");
		
		burner[i] thread scripted_event_burningGuys_playfx("J_Spine3", level._effect["torso"], .2);
		burner[i] thread scripted_event_burningGuys_playfx("J_Wrist_RI", level._effect["arms"], .1);
		burner[i] thread scripted_event_burningGuys_playfx("J_Wrist_LE", level._effect["arms"], .1);
	}
	
	burner[0] thread anim_single_solo( burner[0], "drone_burner1", undefined, burnOrg);
	wait 1.5;
	burner[2] thread anim_single_solo( burner[2], "drone_burner3", undefined, burnOrg);
	wait 1.5;
	burner[1] thread anim_single_solo( burner[1], "drone_burner2", undefined, burnOrg);
	
	wait 20;
	for( i = 0 ; i < burner.size ; i++ )
	{
		//stop fire
		burner[i] notify ("stop_burning_fx");
		
		//non solid
		burner[i] setcontents(0);
		
		//remove their guns
		if (isdefined(burner[i].weapon))
		{
			weaponModel = getWeaponModel(burner[i].weapon);
			burner[i] detach(weaponModel, "tag_weapon_right");
		}
	}
}

scripted_event_burningGuys_playfx(tag, fxName, loopTime)
{
	self endon ("stop_burning_fx");
	while(isdefined(self))
	{
		playfxOnTag (fxName, self, tag);
		wait (loopTime);
	}
}

scripted_event_medicCarry(entName, cycles)
{
	wait 6;
	
	startOrg = getent(entName,"targetname");
	
	//make some guys
	wounded = character_nonAI_spawn_lowRes();
	wounded UseAnimTree(level.scr_animtree["wounded"]);
	medic = character_nonAI_spawn("medic");
	medic UseAnimTree(level.scr_animtree["wounded"]);
	
	wounded.origin = startOrg.origin;
	medic.origin = startOrg.origin;
	
	offset = (0, 0, 0);
	cycleCount = 0;
	for(;;)
	{
		org = startOrg.origin + offset;
		z = physicstrace(org + (0,0,50), org - (0,0,50));
		org = (org[0], org[1], z[2]);
		
		wounded animscripted( "walk_cycle",	org, 	startOrg.angles,	level.scr_anim["medicCarry_wounded"]["walk"]);
		medic animscripted( "walk_cycle",	org,	startOrg.angles,	level.scr_anim["medicCarry"]["walk"]);
		
		medic waittillmatch ("walk_cycle", "end");
		
		offset += getCycleOriginOffset( startOrg.angles, level.scr_anim["medicCarry_wounded"]["walk"] );
		
		cycleCount++;
		
		if (cycleCount == (cycles - 1))
			getent("medic_carry1_death","script_noteworthy") notify ("trigger");
		if (cycleCount == cycles)
			break;
	}
	
	finalOrg = (startOrg.origin + offset);
	finalAng = startOrg.angles;
	
	medic thread scripted_event_medicCarry_impacts();
	wounded thread scripted_event_medicCarry_impacts();
	
	wounded animscripted( "walk_cycle",	finalOrg, finalAng,	level.scr_anim["medicCarry_wounded"]["death"], "deathplant");
	medic animscripted( "walk_cycle",	finalOrg, finalAng,	level.scr_anim["medicCarry"]["death"], "deathplant");
	
	wounded setcontents(0);
	medic setcontents(0);
}

scripted_event_medicCarry_impacts()
{
	bone[0] = "J_Knee_LE";
	bone[1] = "J_Ankle_LE";
	bone[2] = "J_Clavicle_LE";
	bone[3] = "J_Neck";
	bone[4] = "J_Head";
	bone[5] = "J_Shoulder_LE";
	bone[6] = "J_Elbow_LE";
	
	bone = array_randomize(bone);
	
	for (i=0;i<bone.size;i++)
	{
		playfxontag(level._effect["impact_flesh1"], self, bone[i]);
		playfxontag(level._effect["impact_flesh2"], self, bone[i]);
		wait 0.2;
	}
}

scripted_event_medicDrag()
{
	wait 10;
	
	startOrg = getent("medic_drag","targetname");
	
	//spawn the guys
	ents = getentarray(startOrg.target,"targetname");
	dragger = undefined;
	dragged = undefined;
	mortar = undefined;
	for (i=0;i<ents.size;i++)
	{
		if (ents[i].classname == "script_origin")
		{
			mortar = ents[i];
			continue;
		}
		guy = ents[i] stalingradspawn();
		if (spawn_failed(guy))
			assertMsg("medic_drag guy failed to spawn");
		if ( (isdefined (guy.script_noteworthy)) && (guy.script_noteworthy == "medic") )
		{
			dragger = guy;
			guy = undefined;
		}
		else
			dragged = guy;
	}
	assert(isdefined(mortar));
	assert(isdefined(dragger));
	assert(isdefined(dragged));
	
	dragger.ignoreme = true;
	dragged.ignoreme = true;
	
	//loop the drag animations
	dragger animscripts\shared::putGunInHand ("none");
	dragger.dropWeapon = false;
	dragged animscripts\shared::putGunInHand ("none");
	dragged.dropWeapon = false;
	
	dragger.deathanim = level.scr_anim["dragger"]["death"];
	dragged.deathanim = level.scr_anim["dragged"]["death"];
	
	level endon ("medic_drag_dead");
	offset = (0, 0, 0);
	cycleCount = 0;
	
	for(;;)
	{
		dragger animscripted( "drag_anim_done",	startOrg.origin + offset, 	startOrg.angles,	level.scr_anim["dragger"]["cycle"]);
		dragged animscripted( "drag_anim_done",	startOrg.origin + offset,	startOrg.angles,	level.scr_anim["dragged"]["cycle"]);
		
		dragger.allowDeath = 0;
		dragged.allowDeath = 0;
		
		dragger waittillmatch ("drag_anim_done", "end");
		
		offset += getCycleOriginOffset( startOrg.angles, level.scr_anim["dragger"]["cycle"] );
		cycleCount++;
		
		if (cycleCount == 22)
			level thread scripted_event_medicDrag_kill(dragger, dragged, mortar);
	}
}

scripted_event_medicDrag_kill(dragger, dragged, mortar)
{
	//kill the medic and the guy he is dragging with a mortar
	mortar maps\_mortar::duhoc_style_mortar_explode();
	
	level notify ("medic_drag_dead");
	
	dragger.allowDeath = 1;
	dragged.allowDeath = 1;
	
	dragger doDamage(dragger.health + 1, mortar.origin);
	dragged doDamage(dragged.health + 1, mortar.origin);
	
	dragger setcontents(0);
	dragged setcontents(0);
}

scripted_event_beach_radioman()
{
	node = getnode("beach_radioman_node","targetname");
	radioman = character_nonAI_spawn("radioguy");
	radioman.origin = node.origin;
	radioman.animname = "radioman";
	radioman attach("xmodel/us_ranger_radio_hand");
	radioman useAnimTree(level.scr_animtree["radioman"]);
	
	radioman thread anim_loop_solo( radioman, "idle", undefined, "stop_radioman_idle", node );
	
	getent("beach_radioman_trigger","targetname") waittill ("trigger");
	
	radioman playsoundinspace("duhocassault_gr1_getshoreparty");
	
	radioman notify ("stop_radioman_idle");
	radioman scene_playAnim("talk", undefined, node, undefined, "duhocassault_coffey_tarefoxabel", undefined, undefined, false);
	
	radioman thread anim_loop_solo( radioman, "idle", undefined, "stop_radioman_idle", node );
}

scripted_event_GetUpCliff()
{
	wait 15;
	//set up the 3 climber guys
	climber_spawn_position = getentarray("playerrope_climber","targetname");
	climber = [];
	for (i=0;i<climber_spawn_position.size;i++)
	{
		switch(climber_spawn_position[i].script_noteworthy)
		{
			case "1":
				climber[0] = character_nonAI_spawn();
				climber[0].origin = climber_spawn_position[i].origin;
				climber[0] InitShooter();
				climber[0] thread ShooterShoot( getent(climber_spawn_position[i].target,"targetname") );
				break;
			case "2":
				climber[1] = character_nonAI_spawn();
				climber[1].origin = climber_spawn_position[i].origin;
				climber[1] InitShooter();
				climber[1] thread ShooterShoot( getent(climber_spawn_position[i].target,"targetname") );
				break;
			case "3":
				climber[2] = character_nonAI_spawn();
				climber[2].origin = climber_spawn_position[i].origin;
				climber[2] InitShooter();
				climber[2].script_friendname = "Pvt. Grenier";
				climber[2] thread ShooterShoot( getent(climber_spawn_position[i].target,"targetname") );
				break;
		}
	}
	assert(isdefined(climber[0]));
	assert(isdefined(climber[1]));
	assert(isdefined(climber[2]));
	
	//set up randall
	randall_spawn_position = getent("randall","targetname");
	level.randall = undefined;
	level.randall = character_nonAI_spawn("randall");
	level.randall character_assignWeapon("thompson");
	assert(isdefined(level.randall));
	level.randall.origin = randall_spawn_position.origin;
	level.randall.animname = "randall";
	level.randall useAnimTree(level.scr_animtree["randall"]);
	
	//turn off the climb trigger until some dialoge has finished
	getent("trigger_climb_rope","targetname") triggerOff();
	
	//randall does idle animation until player gets closer
	node_bottomcliff_randall = getnode("bottomcliff_randall","targetname");
	assert(isdefined(node_bottomcliff_randall));
	level.randall thread anim_loop_solo( level.randall, "cliffidle", undefined, "stop_cliffidle_anim", node_bottomcliff_randall );
	
	//trig = getent("getupcliff_trigger","targetname");
	//trig waittill ("trigger");
	
	level.playerRope thread rope_climbAnim_playerRope(climber);
}

scripted_event_playerrope_fall_german()
{
	exploder(19);
	german = spawn("script_model", level.playerrope getTagOrigin("tag_climber03"));
	german.origin = getstartorigin( level.playerrope getTagOrigin("tag_climber03"), level.playerrope getTagAngles("tag_climber03"), level.scr_anim["ropefall"]["german_fall"] );
	german aitype\axis_nrmdy_wehr_reg_kar98::main();
	german useAnimTree(level.scr_animtree["ropefall"]);
	german.animName = "ropefall";
	german linkto (level.playerrope, "tag_climber03");
	german playsound(level.scrsound["german_cliff_dive"]);
	german maps\_anim::anim_single_solo( german, "german_fall", "tag_climber03", undefined, level.playerrope );
}

scripted_event_playerrope_fall(climber)
{
	climber notify ("stopClimbAnim");
	climber stopanimscripted();
	climber useAnimTree(level.scr_animtree["ropefall"]);
	climber.animName = "ropefall";
	climber thread scripted_event_playerrope_fall_impactFX();
	climber maps\_anim::anim_single_solo( climber, "climber_fall", "tag_climber03", undefined, level.playerrope );
	climber unlink();
}

scripted_event_playerrope_fall_impactFX()
{
	wait 0.8;
	playfx(level._effect["body_impact_cliff"], self getTagOrigin("J_Helmet") );
	self thread playsoundinspace("body_collision");
}

scripted_event_ranger_rope_falls()
{
	assert(!isdefined(level.rangerRopeFell));
	
	guy1 = undefined;
	guy2 = undefined;
	guy3 = undefined;
	guy4 = undefined;
	guy5 = undefined;
	guy6 = undefined;
	
	//make sure the player is on the rope
	while (!level.playerRopeClimbersStarted)
		wait 0.05;
	
	//waiting for next notetrack that allows a fall
	doAnim = false;
	for (;;)
	{
		self waittill ("ropeClimbAnim",noteTrack);
		switch(noteTrack)
		{
			case "climber01_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				doAnim = true;
				break;
			case "climber02_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				doAnim = true;
				break;
			case "climber03_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				doAnim = true;
				break;
			case "climber04_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				doAnim = true;
				break;
			case "climber05_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				doAnim = true;
				break;
			case "climber06_fall":
				guy1 = ropeClimber_getByRopeAndTag("5", "tag_climber06");
				guy2 = ropeClimber_getByRopeAndTag("5", "tag_climber01");
				guy3 = ropeClimber_getByRopeAndTag("5", "tag_climber02");
				guy4 = ropeClimber_getByRopeAndTag("5", "tag_climber03");
				guy5 = ropeClimber_getByRopeAndTag("5", "tag_climber04");
				guy6 = ropeClimber_getByRopeAndTag("5", "tag_climber05");
				doAnim = true;
				break;
		}
		if (doAnim)
			break;
	}
	
	//stop the rope animation so it's qued up
	self setanim(level.scr_anim["rope"]["cycle"]["5"], 1, 0, 0);
	
	//stop all climbers on the rope
	climbers = getentarray("cliffclimber","targetname");
	for( i = 0 ; i < climbers.size ; i++ )
	{
		if (!isdefined(climbers[i].script_rope))
			continue;
		if (climbers[i].script_rope != "5")
			continue;
		if (!isdefined(climbers[i].climbing))
			continue;
		if (climbers[i].climbing != true)
			continue;
		climbers[i] thread ropeClimber_pauseClimbing(self);
	}
	
	while (!level.playerClimbingRope)
		wait 0.05;
	
	//wait till the player looks this way
	//timeout after 30 seconds
	loops = int(30 / 0.25);
	for (;;)
	{
		if ( ((level.player.angles[1] >= 170) || (level.player.angles[1] <= -130)) )
			break;
		loops--;
		if (loops <= 0)
			break;
		wait 0.25;
	}
	
	//rope falls now muhahaha
	level.rangerRopeFell = true;
	
	//starting the actual fall now
	
	//climber animations
	if (isdefined(guy1))
		guy1 thread scripted_event_ranger_rope_falls_climberfall("climber02");
	if (isdefined(guy2))
		guy2 thread scripted_event_ranger_rope_falls_climberfall("climber03");
	if (isdefined(guy3))
		guy3 thread scripted_event_ranger_rope_falls_climberfall("climber04");
	if (isdefined(guy4))
		guy4 thread scripted_event_ranger_rope_falls_climberfall("climber05");
	if (isdefined(guy5))
		guy5 thread scripted_event_ranger_rope_falls_climberfall("climber04");
	if (isdefined(guy6))
		guy6 thread scripted_event_ranger_rope_falls_climberfall("climber03");
	
	//rope animation
	self notify ("stop_climb_anim");
	self detachall();
	self setflaggedanimknobrestart("ropeFallAnim",level.scr_anim["rope"]["fall"]["5"]);
	self waittillmatch("ropeFallAnim","end");
	self delete();
}

scripted_event_ranger_rope_falls_climberfall(anime)
{
	self notify ("fell_off_rope");
	self notify ("stopClimbAnim");
	self stopanimscripted();
	self useAnimTree(level.scr_animtree["ropefall"]);
	self.animName = "ropefall";
	self unlink();
	self thread scripted_event_ranger_rope_falls_climberfall_yells();
	self animscripted("fall_anim", self.origin, (0,self.angles[1],0), level.scr_anim["ropefall"][anime]);
	self waittillmatch("fall_anim","end");
	self delete();
}

scripted_event_ranger_rope_falls_climberfall_yells()
{
	wait randomfloat(.7);
	self playsound ("americansoldier_fall");
}

scripted_event_cliffEdge_Mortars()
{
	wait 5;
	mortar = getentarray("cliff_edge_forced_mortar","targetname");
	for (i=0;i<mortar.size;i++)
	{
		wait randomfloat(1);
		mortar[i] maps\_mortar::duhoc_style_mortar_explode();
	}
}

scripted_event_TrenchChargers()
{
	level endon ("atrillery_barriage");
	
	getent("trench_chargers_spawn","targetname") waittill ("trigger");
	
	spawners = getentarray("trench_chargers","targetname");
	nodes = getnodearray("trench_chargers_trenchnode","targetname");
	guy = [];
	for (i=0;i<spawners.size;i++)
	{
		guy[i] = spawners[i] stalingradSpawn();
		if (spawn_failed(guy[i]))
			assertMsg("trench charger didn't spawn for some reason");
		guy[i].baseAccuracy = 1.0;
		guy[i].accuracy = 1.0;
		guy[i] thread scripted_event_TrenchChargers_think(nodes[i]);
	}
	wait 8;
	level thread scripted_event_TrenchChargers_dialogue();
	level notify ("trench_chargers_advance");
	wait 10;
	level notify ("trench_chargers_leave");
}

scripted_event_TrenchChargers_dialogue()
{
	level endon ("atrillery_barriage");
	
	getent("trench_chargers_sound1","targetname") playSoundInSpace(level.scrsound["clifftop"]["getthebastards"]);
	getent("trench_chargers_sound2","targetname") playSoundInSpace(level.scrsound["clifftop"]["gogogo"]);
	wait 3;
	getent("trench_chargers_sound3","targetname") playSoundInSpace(level.scrsound["clifftop"]["cutemdown"]);
}

scripted_event_TrenchChargers_think(node)
{
	level endon ("atrillery_barriage");
	
	self endon ("death");
	self.goalradius = 16;
	self.old_grenadeawareness = self.grenadeawareness;
	self.grenadeawareness = 0;
	self.anim_disablePain = true;
	self thread magic_bullet_shield();
	
	level waittill ("trench_chargers_advance");
	
	wait randomfloat(2);
	self setgoalnode(node);
	trench_chargers_finalnode = getnode("trench_chargers_finalnode","targetname");
	
	level waittill ("trench_chargers_leave");
	self.grenadeawareness = self.old_grenadeawareness;
	self.old_grenadeawareness = undefined;
	self.anim_disablePain = false;
	self notify ("stop magic bullet shield");
	self setgoalnode(trench_chargers_finalnode);
	
	wait (5 + randomfloat(10));
	
	self doDamage(self.health + 1, self.origin);
}

scripted_event_gunsNotHere()
{
	level endon ("atrillery_barriage");
	
	node_braeburn = getnode("node_gunsnothere_braeburn","targetname");
	node_randall = getnode("node_gunsnothere_randall","targetname");
	
	spawner_braeburn = getent("spawner_gunsnothere_braeburn","targetname");
	spawner_randall = getentarray("spawner_gunsnothere_randall","targetname");
	
	trigger = getent("trigger_gunsnothere","targetname");
	trigger waittill ("trigger");
	
	//spawn braeburn
	braeburn = spawner_braeburn stalingradSpawn();
	if (spawn_failed(braeburn))
		assertMsg("braeburn failed to spawn for the guns arent here dialogue");
	braeburn.animname = "braeburn";
	braeburn thread magic_bullet_shield();
	braeburn.goalradius = 4;
	braeburn setgoalnode(node_braeburn);
	
	//wait a while for the player to get up the rope
	level.player waittill ("done_climbing_rope");
	
	//-------------
	//spawn randall
	//-------------
	index = undefined;
		while(!isdefined(index))
		{
			wait 1;
			//pick which spawner to use - the one that isn't in the players FOV
			for (i=0;i<spawner_randall.size;i++)
			{
				if (spawner_randall[i] maps\_mortar::duhoc_style_mortar_checkPlayerFOV())
					continue;
				index = i;
			}
		}
	assert(isdefined(index));
	//-------------
	randall = spawner_randall[index] stalingradSpawn();
	if (spawn_failed(randall))
		assertMsg("randall failed to spawn for the guns arent here dialogue");
	randall.animname = "randall";
	randall thread magic_bullet_shield();
	randall.goalradius = 4;
	randall setgoalnode(node_randall);
	//-------------
	//-------------
	//-------------
	
	getent("fakeguns_dialogue","targetname") playsoundinspace("duhocassault_erc_gunsarefake");
	
	randall thread anim_reach_solo(randall, "guns_not_here", undefined, node_randall);
	braeburn anim_reach_solo(braeburn, "guns_not_here", undefined, node_braeburn);
	randall anim_reach_solo(randall, "guns_not_here", undefined, node_randall);
	
	braeburn thread scene_playAnim("guns_not_here", undefined, node_braeburn, undefined, "duhocassault_braeburn_gunsgone", "duhocassault_braeburn_gunsmoved", undefined, true, false);
	randall thread scene_playAnim("guns_not_here", undefined, node_randall, undefined, "duhocassault_randall_what", "duhocassault_randall_sittingducks", undefined, true, false);
	
	wait 5;
	thread objective_locate_artillery_guns();
}

scripted_event_blowupguy()
{
	level endon ("atrillery_barriage");
	
	getent("blowupguy_trigger","targetname") waittill ("trigger");
	
	guy = getent("blowupguy_spawner","targetname") stalingradSpawn();
	if (spawn_failed(guy))
		return;
	node = getnode("blowupguy_node","targetname");
	guy.goalradius = 4;
	guy setgoalnode(node);
	
	getent("blowupguy_trigger2","targetname") waittill ("trigger");
	
	grenade_land_pos = getent("blowupguy_grenade","targetname").origin;
	playfx (level._effect["grenade"]["mud"], grenade_land_pos);
	thread playsoundinspace("grenade_explode_mud",grenade_land_pos);
	
	if ( (isdefined(guy)) && (isalive(guy)) )
	{
		if (distance (guy.origin, node.origin) <= 64)
		{
			guy.deathanim = level.scr_anim["grenadedeath"]["death"];
			guy doDamage(guy.health + 1, guy.origin);
		}
	}
	radiusdamage(grenade_land_pos + (0,0,100), 200, 200, 200);
	wait 2;
	node thread playsoundinspace("bodyfall_dirt_large");
}

scripted_event_bunkerEntrance_friendKilled()
{
	level endon ("atrillery_barriage");
	
	trig = getent("bunker_friendly_bullet_trigger","targetname");
	bulletStart = getent(trig.target,"targetname").origin;
	
	trig waittill ("trigger", guy);
	
	bullettracer ( bulletStart, guy getTagOrigin("J_Helmet") );
	playfxontag(level._effect["impact_flesh1"], guy, "J_Helmet");
	guy thread playsoundinspace ("headshot");
	
	guy notify("stop magic bullet shield");
	guy doDamage(guy.health + 1, bulletStart);
}

scripted_event_bunker_collapse()
{	
	before = getentarray("tunnel_collapse_before","targetname");
	after = getentarray("tunnel_collapse_after","targetname");
	rubble = getentarray("tunnel_collapse_rubble","targetname");
	
	for (i=0;i<after.size;i++)
		after[i] hide();
	
	for (i=0;i<rubble.size;i++)
	{
		rubble[i].finalOrg = rubble[i].origin;
		rubble[i].origin = (rubble[i].origin + (0,0,100));
		
		rubble[i].finalAng = rubble[i].angles;
		rubble[i].angles = (rubble[i].angles + ( (90 + randomfloat(90)), (90 + randomfloat(90)), (90 + randomfloat(90)) ));
		
		rubble[i] hide();
		rubble[i] notsolid();
		rubble[i] connectpaths();
	}
	
	level thread scripted_event_bunker_collapse_trigger1();
	level thread scripted_event_bunker_collapse_trigger2();
	
	level waittill ("bunker_collapse");
	
	earthquake (0.6, 2, level.player.origin, 1000);
	
	exploder(0);
	
	getent("tunnel_collapse_area","targetname") thread playsoundinspace("ceiling_collapse");
	
	for (i=0;i<rubble.size;i++)
	{
		rubble[i] show();
		move_time = (0.5 + randomfloat(0.5));
		rubble[i] moveto(rubble[i].finalOrg, move_time );
		rubble[i] rotateto(rubble[i].finalAng, move_time );
		rubble[i] disconnectpaths();
	}
	
	wait 0.5;
	
	maps\_spawner::kill_spawnerNum(5);
	area = getent("tunnel_collapse_area","targetname");
	axis = getaiarray("axis");
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] istouching(area))
			axis[i] doDamage(axis[i].health + 1, axis[i].origin);
	}
	
	wait 0.5;
	
	for (i=0;i<after.size;i++)
		after[i] show();
		
	for (i=0;i<before.size;i++)
		before[i] delete();
}

scripted_event_bunker_collapse_trigger1()
{
	level endon ("bunker_collapse");
	getent ("tunnel_collapse_trigger","targetname") waittill ("trigger");
	flag_set("allow_bunker_clear_dialogue");
	level notify ("bunker_collapse");
}

scripted_event_bunker_collapse_trigger2()
{
	level endon ("bunker_collapse");
	getent("tunnel_collapse_spawntrigger","script_noteworthy") waittill ("trigger");
	wait 8;
	getent ("tunnel_collapse_looktrigger","targetname") waittill ("trigger");
	level notify ("bunker_collapse");
}

scripted_event_exit_trench_gundown()
{
	level endon ("atrillery_barriage");
	
	//player is exiting the bunker
	getent("exit_trench_gundown_trigger","targetname") waittill ("trigger");
	
	//autoSaveByName("bunkers");
	
	enemySpawner = getentarray("exit_trench_gundown_enemySpawner","targetname");
	friendlySpawner = getentarray("exit_trench_gundown_friendlySpawner","targetname");
	
	//spawn the enemies to kick the players butt
	enemies = [];
	for (i=0;i<enemySpawner.size;i++)
	{
		enemies[i] = enemySpawner[i] stalingradSpawn();
		if (spawn_failed(enemies[i]))
			assertMsg("guy at bunker exit failed to spawn");
		enemies[i].goalradius = 128;
	}
	
	//friendlies save the day
	friendlies = [];
	for (i=0;i<friendlySpawner.size;i++)
	{
		friendlies[i] = friendlySpawner[i] stalingradSpawn();
		if (spawn_failed(friendlies[i]))
			assertMsg("guy at bunker exit failed to spawn");
		
		friendlies[i].firstNode = getnode(friendlySpawner[i].target,"targetname");
		friendlies[i].secondNode = getnode(friendlies[i].firstNode.target,"targetname");
		
		friendlies[i].baseAccuracy = 1.0;
		friendlies[i].goalradius = 8;
		friendlies[i].accuracy = 1.0;
		friendlies[i].accuracyStationaryMod = 1.0;
		friendlies[i].health = 1000000;
		friendlies[i].anim_disablePain = true;
		friendlies[i] setgoalnode (friendlies[i].firstNode);
	}
	
	//germans get 1 health so they die easy
	for (i=0;i<enemies.size;i++)
	{
		if (isdefined(enemies[i]))
			enemies[i].health = 1;
	}
	
	//wait until germans have died
	level waittill_dead(enemies, undefined, 6.0);
	
	clip = getent("top_bunker_ledge_clip","targetname");
	clip connectpaths();
	clip delete();
	
	//friendlies advance to the trench
	for (i=0;i<friendlies.size;i++)
	{
		if (!isdefined(friendlies[i]))
			continue;
		delayTime = 1 + (randomfloat(2));
		if (i == 0)
			delayTime = 0;
		friendlies[i] thread scripted_event_exit_trench_gundown_runtodeath(friendlies[i].secondNode, delayTime);
	}
}

scripted_event_exit_trench_gundown_runtodeath(node, delayTime)
{
	level endon ("atrillery_barriage");
	self endon ("death");
	
	if (delayTime > 0)
		wait delayTime;
	
	self setgoalnode(node);
	wait 2;
	self.health = 50;
	self.anim_disablePain = false;
	self waittill ("goal");
	self doDamage(self.health + 1, level.flakveirling.origin);
}

scripted_event_grenaders()
{
	level endon ("atrillery_barriage");
	
	//wait for player to get close
	trig = getent("grenaders_trigger","targetname");
	trig waittill ("trigger");
	
	//spawn 3 grenaders
	spawners = getentarray("grenaders_spawner","targetname");
	grenaders = spawnstruct();
	grenaders.guys_at_goal = 0;
	grenaders.guy = [];
	for (i=0;i<spawners.size;i++)
	{
		grenaders.guy[i] = spawners[i] stalingradSpawn();
		if(spawn_failed(grenaders.guy[i]))
			assertMsg("grenader guy didn't spawn in the crater");
		node = getnode(spawners[i].target,"targetname");
		grenaders.guy[i] thread scripted_event_grenaders_goalWait( grenaders, node );
		grenaders.guy[i] thread scripted_event_grenaders_think( grenaders, node );
	}
	thread scripted_event_grenaders_dialogue();
}

scripted_event_grenaders_dialogue()
{
	level endon ("atrillery_barriage");
	
	throw_trigger = getent("grenaders_trigger_throw","targetname");
	level waittill ("grenaders_dialogue_1");
	throw_trigger playsoundinspace("duhocassault_gr3_mg42warning");
	
	flag_wait("grenaders_dialogue_2");
		
	throw_trigger playsoundinspace("duhocassault_rnd_fragnow");
	flag_set("throw_3_nades");
}

scripted_event_grenaders_goalWait( grenaders, node )
{
	level endon ("atrillery_barriage");
	
	self.ignoreme = true;
	self thread magic_bullet_shield();
	self.goalradius = 4;
	self.anim_disablePain = true;
	self.old_pathenemyfightdist = self.pathenemyfightdist;
	self.old_pathenemylookahead = self.pathenemylookahead;
	self.pathenemyfightdist = 200;
	self.pathenemylookahead = 200;
	
	self setgoalnode(node);
	self waittill ("goal");
	grenaders.guys_at_goal++;
}

scripted_event_grenaders_think( grenaders, node )
{
	level endon ("atrillery_barriage");
	self.animname = "grenader";
	
	//get the grenade_land_pos
	grenade_land_ent = getent(node.target,"targetname");
	grenade_land_pos = grenade_land_ent.origin;
	
	//see if he should do crouch or stand throw
	throwAnim = undefined;
	assert(isdefined(node));
	assert(isdefined(node.script_noteworthy));
	switch(node.script_noteworthy)
	{
		case "stand":
			throwAnim = "grenade_throw_stand";
			break;
		case "crouch":
			throwAnim = "grenade_throw_crouch";
			break;
		case "crouch2":
			throwAnim = "grenade_throw";
			break;
	}
	
	//do dialog when player gets close
	throw_trigger = getent("grenaders_trigger_throw","targetname");
	throw_trigger waittill ("trigger");
	
	level notify ("grenaders_dialogue_1");
	
	while (grenaders.guys_at_goal < grenaders.guy.size)
		wait 0.05;
	
	flag_set("grenaders_dialogue_2");
	flag_wait("throw_3_nades");
	
	wait randomfloat(.5);
	
	//do throw anim
	self thread anim_single_solo( self, throwAnim, undefined, node);
	self playsound ("duhoc_fraggrenade_pin");
	self thread animscripts\shared::donotetracks("single anim");
	self waittillmatch("single anim", "fire");
	
	//throw the grenade
	nadeStartOrg = self getTagOrigin("tag_weapon_right");
	throwDist = distance(self.origin, grenade_land_pos);
	fuseTime = (3 + grenade_land_ent.script_delay);
	throwAngles = VectorToAngles( (grenade_land_pos + (0,0,400)) - self.origin );
	forward = anglestoforward (throwAngles);
	forward = vector_scale(forward, throwDist * 1.2);
	grenade = spawn("script_model", nadeStartOrg);
	grenade setModel ("xmodel/projectile_britishgrenade");
	grenade movegravity( forward, fuseTime );
	grenade thread scripted_event_grenaders_explode(fuseTime, grenade_land_pos);
	grenade playsound ("duhoc_fraggrenade_fire");
	
	wait 8;
	
	//advance on the bunker
	nextNode = getnode(grenade_land_ent.target,"targetname");
	assert(isdefined(nextNode));
	self setgoalnode(nextNode);
	
	self.ignoreme = false;
	self.anim_disablePain = false;
	self.pathenemyfightdist = self.old_pathenemyfightdist;
	self.pathenemylookahead = self.old_pathenemylookahead;
	self.old_pathenemyfightdist = undefined;
	self.old_pathenemylookahead = undefined;
	self notify ("stop magic bullet shield");
	self.health = 200;
	
	self endon ("death");
	self waittill ("goal");
	
	targetDummy_spawner = getent("grenader_targetdummy","targetname");
	targetDummy_spawner.count = 1;
	targetDummy = targetDummy_spawner doSpawn();
	if (spawn_failed(targetDummy))
		return;
}

scripted_event_grenaders_explode(fuseTime, grenade_land_pos)
{
	wait fuseTime;
	self delete();
	maps\_spawner::kill_spawnerNum(8);
	playfx( level._effect["grenade"]["concrete"], physicstrace( grenade_land_pos, (grenade_land_pos - (0,0,500)) ) );
	thread playsoundinspace("grenade_explode_concrete",grenade_land_pos);
	radiusdamage(grenade_land_pos, 256, 500, 500);
	
	//spawn the german flee guys
	grenaders_fleeguys = getentarray("grenaders_fleeguys","targetname");
	for (i=0;i<grenaders_fleeguys.size;i++)
		guy = grenaders_fleeguys[i] doSpawn();
	for (i=0;i<grenaders_fleeguys.size;i++)
		grenaders_fleeguys[i] delete();
}

scripted_event_artillery_spotter()
{
	getent("artillery_spotter_trigger","targetname") waittill ("trigger");
	node = getnode("artillery_spotter_node","targetname");
	assert(isdefined(node));
	
	radioman = character_nonAI_spawn("radioguy");
	radioman.origin = node.origin;
	radioman.animname = "radioman";
	radioman attach("xmodel/us_ranger_radio_hand");
	radioman useAnimTree(level.scr_animtree["radioman"]);
	
	radioman thread anim_loop_solo( radioman, "idle", undefined, "stop_radioman_idle", node );
	
	getent("artillery_spotter_trigger2","targetname") waittill ("trigger");
	level notify ("atrillery_barriage");
	
	radioman notify ("stop_radioman_idle");
	thread scripted_event_artillery_spotter_incommingSounds();
	radioman scene_playAnim("talk", undefined, node, undefined, "duhocassault_bra_radioslugger", undefined, undefined, false);
	radioman thread anim_loop_solo( radioman, "idle", undefined, "stop_radioman_idle", node );
	
	wait 3.5;
	thread scripted_event_artillery_spotter_earthquakes();
	wait 0.5;
	exploder(16);
	
	//stop continuing drone spawns
	array_notify(getentarray("drone_allies","targetname"), "stop_looping");
	array_notify(getentarray("drone_axis","targetname"), "stop_looping");
	
	smokeOrigin = level.flakveirling.origin;
	level.flakveirling notify ("kill_flakveirling");
	wait 3;
	level notify ("flakveirling_dead");
	wait 0.05;
	level.savehere = undefined;
	thread autosavebyname("flakveirling_dead");
	wait 2;
	flag_set("artillery_done");
	maps\_fx::loopfx("thin_black_smoke_M", smokeOrigin, 1, smokeOrigin + (0,0,1));
	thread playsoundinspace("flak_explosion_large",(1733,440,1270));
	
	if ( (isdefined(level.flakveirling.crew)) && (isdefined(level.flakveirling.crew.size)) )
	{
		for (i=0;i<level.flakveirling.crew.size;i++)
		{
			if (!isdefined(level.flakveirling.crew[i]))
				continue;
			level.flakveirling.crew[i] notify ("stop_flakpanzer_anim");
			level.flakveirling.crew[i] unlink();
			level.flakveirling.crew[i] delete();
		}
	}
	level.flakveirling setmodel("xmodel/german_artillery_flakveirling_d");
	level.flakveirling freevehicle();
	
	level thread set_ambient("town");
	
	wait 4;
	
	thread autoSaveByName("artillery");
	level.player setfriendlychain(getnode("friendlynode_berm","targetname"));
	
	wait 3;
	
	thread scripted_event_germansFleeTown();
}

scripted_event_artillery_spotter_earthquakes()
{
	earthquake( 0.3, 7, level.player.origin, 1050 );
	wait 5.5;
	earthquake( 0.3, 2, level.player.origin, 1050 );
}

scripted_event_artillery_spotter_incommingSounds()
{
	wait 1;
	org = (2025, -460, 1300);
	playsoundinspace(level.scrsound["battleship_gun"], org);
	wait 0.3;
	playsoundinspace(level.scrsound["battleship_gun"], org);
	wait .1;
	playsoundinspace(level.scrsound["battleship_gun"], org);
	wait 0.5;
	playsoundinspace(level.scrsound["battleship_gun"], org);
}

scripted_event_germansFleeTown()
{
	germans_flee_town = getentarray("germans_flee_town","targetname");
	fleeguys = [];
	for (i=0;i<germans_flee_town.size;i++)
	{
		guy = germans_flee_town[i] doSpawn();
		if (spawn_failed(guy))
			continue;
		guy.health = 5;
		guy.goalradius = 64;
		guy.old_goalradius = 64;
		fleeguys[fleeguys.size] = guy;
	}
	
	thread scripted_event_germansFleeTown_dialogue();
	
	level waittill_dead(fleeguys);
	
	getent("door_rush_trigger","targetname") notify ("trigger");
	
	thread scripted_event_germansFleeTown_dialogue2();
}

scripted_event_germansFleeTown_dialogue()
{
	wait 2;
	level.player playsoundinspace("duhocassault_bra_krautsinopen");
	level.player playsoundinspace("duhocassault_bra_comeontake");
}

scripted_event_germansFleeTown_dialogue2()
{
	wait 1;
	level.player playsoundinspace("duhocassault_gr4_letsgoletsgo");
	level.player playsoundinspace("duhocassault_gr5_keepitmoving");
}

atmosphere_battleshipGunfire()
{
	thread atmosphere_battleshipGunfire_sounds();
	thread atmosphere_battleshipGunfire_explosions();
}

atmosphere_battleshipGunfire_sounds()
{
	level endon ("stop_battleship_barrage");
	
	start["min_x"] = -3960;
	start["max_x"] = 11192;
	start["dif_x"] = start["max_x"] - start["min_x"];
	start["y"] = -20776;
	start["z"] = 512;
	
	end["min_x"] = -2736;
	end["max_x"] = 5296;
	end["dif_x"] = end["max_x"] - end["min_x"];
	end["y"] = -4632;
	end["z"] = 512;
	
	for (;;)
	{
		startPos = ( start["min_x"] + (randomint(start["dif_x"])), start["y"], start["z"] );
		endPos = ( end["min_x"] + (randomint(end["dif_x"])), end["y"], end["z"] );
		thread atmosphere_battleshipGunfire_sounds_create(startPos, endPos);
		wait (1 + randomfloat(4));
	}
}

atmosphere_battleshipGunfire_sounds_create(start, end)
{
	emitter = spawn("script_origin", start);
	emitter playsound (level.scrsound["battleship_gun"]);
	emitter moveto(end, 2.5, 0, 0);
	wait 2.5;
	emitter delete();
}

atmosphere_battleshipGunfire_explosions()
{
	level endon ("stop_battleship_barrage");
	
	exploder_start = 1;
	exploder_end = 13;
	
	lastRand = -1;
	for (;;)
	{
		wait (.5 + randomfloat(.5));
		rand = randomintrange(exploder_start, (exploder_end + 1) );
		if (rand == lastRand)
		{
			if ( (rand + 1) > exploder_end )
				rand = (rand - 1);
			else
				rand = (rand + 1);
		}
		
		exploder(rand);
		
		if ( rand == 1 )
			playSoundInSpace("shell_explosion", (1549,-4351,763) );
		else
		if ( rand == 7 )
			playSoundInSpace("shell_explosion", (-978,-4244,940) );
		else
		if ( rand == 13 )
			playSoundInSpace("shell_explosion", (-463,-2765,1139) );
	}
}

atmosphere_waterSplashEye(blur, timer)
{
	if (isdefined(level.player.blurred))
		return;
	level.player.blurred = true;
	wait 1;
	setblur(blur, 0.5);
	wait 1;
	setblur(0, timer);
	wait timer;
	level.player.blurred = undefined;
}

atmosphere_plinkage()
{
	level.plinkage_max = 1;
	level.plinkage_playing = 0;
	level.plinkage_delay_min = 10;
	level.plinkage_delay_max = 15;
	
	thread atmosphere_plinkage_ramp();
	
	for (i=1;i<19;i++)
		thread atmosphere_plinkage_doPlinks("tag_impact_metal" + i,"metal");
	for (i=1;i<19;i++)
		thread atmosphere_plinkage_doPlinks("tag_impact_wood" + i,"wood");
}

atmosphere_plinkage_ramp()
{
	level endon ("stop_plinkage");
	//30 seconds in they really start to pick up
	wait 15;
		//15 second rampup
		rampTime = 15.0;
		plinkage_max_clamp = 25;
		plinkage_delay_min_clamp = 0.0;
		plinkage_delay_max_clamp = 0.03;
		plinkage_max_add = ((plinkage_max_clamp - level.plinkage_max)/(20*rampTime));
		plinkage_delay_min_subtract = ((level.plinkage_delay_min - plinkage_delay_min_clamp)/(20*rampTime));
		plinkage_delay_max_subtract = ((level.plinkage_delay_max - plinkage_delay_max_clamp)/(20*rampTime));
		
		for (i=0;i<(20*rampTime);i++)
		{
			level.plinkage_max = (level.plinkage_max + plinkage_max_add);
			level.plinkage_delay_min = (level.plinkage_delay_min - plinkage_delay_min_subtract);
			level.plinkage_delay_max = (level.plinkage_delay_max - plinkage_delay_max_subtract);
			if (level.plinkage_max > plinkage_max_clamp)
				level.plinkage_max = plinkage_max_clamp;
			if (level.plinkage_delay_min < plinkage_delay_min_clamp)
				level.plinkage_delay_min = plinkage_delay_min_clamp;
			if (level.plinkage_delay_max < plinkage_delay_max_clamp)
				level.plinkage_delay_max = plinkage_delay_max_clamp;
			wait 0.05;
		}
	
	wait 15;
	
	//at 55 seconds it stops and threads are killed
	wait 10;
	level notify ("stop_plinkage");
}

atmosphere_plinkage_doPlinks(tagName, type)
{
	level endon ("stop_plinkage");
	for (;;)
	{
		wait level.plinkage_delay_min;
		wait randomfloat(level.plinkage_delay_max - level.plinkage_delay_min);
		
		if (level.plinkage_playing >= level.plinkage_max)
			continue;
		level.plinkage_playing++;
		
		//sometimes play a whizby instead
		if (randomint(3) == 0)
		{	
			if (type == "wood")
			{
				playfxontag (level._effect["plinkage"]["wood"], level.playerboat, tagName);
				level.playerboat playSoundOnTag ("bullet_large_wood", tagName);
			}
			else if (type == "metal")
			{
				playfxontag (level._effect["plinkage"]["metal"], level.playerboat, tagName);
				level.playerboat playSoundOnTag ("bullet_large_metal", tagName);
			}
		}
		else
			level.playerboat playSoundOnTag ("whizby_triggered", tagName);
		
		wait 1;
		level.plinkage_playing--;
	}
}

atmosphere_boatMortars()
{
	wait 22;
	getent("boatmortar1","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 3;
	getent("boatmortar2","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 2;
	getent("boatmortar3","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 2;
	getent("boatmortar4","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 1.5;
	getent("boatmortar5","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 3;
	getent("boatmortar6","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
	wait 1;
	getent("boatmortar7","targetname") thread maps\_mortar::duhoc_style_mortar_explode(false,"water_plume");
}

atmosphere_cliffridge_muzzleflashes()
{
	for (i=0;i<level.muzzleflashLocation.size;i++)
	{
		rand = randomint(3);
		gunType = undefined;
		switch(rand)
		{
			case 0:
				gunType = "rifle"; break;
			case 1:
				gunType = "smg"; break;
			case 2:
				gunType = "mg"; break;
		}
		thread atmosphere_cliffridge_muzzleflashes_activate(gunType, level.muzzleflashLocation[i]);
	}
}

atmosphere_cliffridge_muzzleflashes_activate(gunType, org)
{
	if ( (!isdefined(self.script_noteworthy)) || ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy != "dont_delete") ) )
		level endon ("stop_cliffridge_muzzleflashes");
	
	for (;;)
	{
		//long wait - reload type
		wait (2 + randomfloat(8));
		
		//do muzzleflashes
		if (gunType == "rifle")
		{
			loops = (1 + randomint(4));
			for (i=0;i<loops;i++)
			{
				playfx( level._effect["muzzleflash"], org );
				wait (1 + randomfloat(3));
			}
		}
		else if (gunType == "mg")
		{
			loops = (6 + randomint(6));
			for (i=0;i<loops;i++)
			{
				playfx( level._effect["muzzleflash"], org );
				wait 0.25;
			}
		}
		else if (gunType == "smg")
		{
			loops = (6 + randomint(6));
			for (i=0;i<loops;i++)
			{
				playfx( level._effect["muzzleflash"], org );
				wait 0.1;
			}
		}
	}
}

atmosphere_boatAmbientSound()
{
	level.playerboat playsound ("ambient_duhocboat");
}

atmosphere_yellingOnBeach()
{
	level endon ("stop_beach_yelling");
	thread atmosphere_yellingOnBeach_ender();
	
	for (i=0;i<level.scrsound["beach_chatter"].size;i++)
		assert(isdefined(level.scrsound["beach_chatter"][i]));
	
	distance_min = 300;
	distance_max = 1500;
	
	for (i=0;i<level.scrsound["beach_chatter"].size;i++)
	{
		wait randomfloat(2);
		while ( (isdefined (level.pauseBeachChatter)) && (level.pauseBeachChatter == true) )
			wait 0.05;
		d = distance_min + randomint(distance_max - distance_min);
		if (randomint(2) == 0)
			d = (d * -1);
		level playSoundinSpace( level.scrsound["beach_chatter"][i] , ((level.player.origin[0] + d),-4700,30) );
		level notify ("beach_yell_dialogue_done");
	}
	flag_set("beach_dialogue_done");
}

atmosphere_yellingOnBeach_ender()
{
	getent ("clifftop","targetname") waittill ("trigger");
	level notify ("stop_mortars 0");
	level notify ("start_mortars 1");
	level notify ("right_field_mortars");
	level notify ("stop_beach_yelling");
	level notify ("delete_beach_corpses");
	level thread flakveirling_start();
	level thread scripted_event_cliffEdge_Mortars();
}

atmosphere_wounded_characters()
{
	level thread scripted_event_medicDrag();
	
	nodes = getnodearray("wounded","targetname");
	assert(isdefined(nodes[0]));
	
	for (i=0;i<nodes.size;i++)
	{
		assert(isdefined(nodes[i].script_noteworthy));
		assert(isdefined(nodes[i].script_minspec_level));
		
		if (getcvarint("scr_duhoc_assault_drones") < nodes[i].script_minspec_level)
			continue;
		
		//spawn the wounded soldier and place him at this node
		wounded_guy = character_nonAI_spawn_lowRes();
		wounded_guy UseAnimTree(level.scr_animtree["wounded"]);
		wounded_guy.animname = "wounded";
		wounded_guy.origin = nodes[i].origin;
		wounded_guy thread detectFriendlyFire();
		
		//determine which wounded animation set to use
		animName = nodes[i].script_noteworthy;
		assert(isdefined(level.scr_anim["wounded"][animName]));
		
		assert(isdefined(animName));
		if ( (nodes[i].script_noteworthy == "floater_a") || (nodes[i].script_noteworthy == "floater_b") )
		{
			assert(isdefined(nodes[i].target));
			orgEnt = getent(nodes[i].target,"targetname");
			assert(isdefined(orgEnt));
			wounded_guy thread atmosphere_wounded_think(animName, orgEnt);
		}
		else
			wounded_guy thread atmosphere_wounded_think(animName, nodes[i]);
	}
}

atmosphere_wounded_think(animName, node)
{
	wait randomfloat(3);
	self thread anim_loop_solo( self, animName, undefined, "stop_wounded_anim", node );
	
	//if the node targets a trigger then it can cause a facial animation and sound to start
	if (!isdefined(node.target))
		return;
	ents = getentarray(node.target,"targetname");
	if ( (!isdefined(ents)) && (!isdefined(ents[0])) )
		return;
	
	trigger = undefined;
	
	for (i=0;i<ents.size;i++)
	{
		switch(ents[i].classname)
		{
			case "trigger_radius":
			case "trigger_multiple":
			case "trigger_lookat":
				trigger = ents[i];
				break;
		}
	}
	
	if (!isdefined (trigger))
		return;
	
	//trigger must have a script_noteworthy so I know what sound to play when it's triggered
	assert(isdefined(trigger.script_noteworthy));
	
	//make sure the sound alias exists
	index = 0;
	assert(isdefined(level.scrsound["wounded"][trigger.script_noteworthy]));
	assert(isdefined(level.scrsound["wounded"][trigger.script_noteworthy][index]));
	
	trigger waittill ("trigger");
	
	for (;;)
	{
		self thread animscripts\face::SaySpecificDialogue(undefined, level.scrsound["wounded"][trigger.script_noteworthy][index], 1, "dialog_done");
		self waittill ("dialog_done");
		index++;
		if (index >= level.scrsound["wounded"][trigger.script_noteworthy].size)
			return;
	}
}

atmosphere_watchThoseTrenches()
{
	trig = getent("watch_those_trenches_audio","targetname");
	org = getent(trig.target,"targetname");
	
	trig waittill ("trigger");
	
	if ( (isdefined (level.guns_not_here_audio_playing)) && (level.guns_not_here_audio_playing == true) )
		level waittill ("guns_not_here_audio_done");
	
	//come on, let's get some fire on that Kraut line!
	org playSoundInSpace("duhoc_assault_bra_fireonline");
	
	//jeez, there's Krauts all over the place!
	org playSoundInSpace("duhoc_assault_bra_allovertheplace");
	
	//cut em down!!!!
	org playSoundInSpace("duhoc_assault_bra_cutemdown");
	
	//watch those trenches!!
	org playSoundInSpace("duhocassault_gr3_watchtrenches");
}

atmosphere_bulletStrafe()
{
	level array_thread (getentarray("bullet_impacts","targetname"), ::atmosphere_bulletStrafe_wait);
}

atmosphere_bulletStrafe_wait()
{
	self waittill ("trigger");
	
	if (isdefined(self.script_delay))
	{
		assert(self.script_delay > 0);
		wait (self.script_delay);
	}
	
	for (i=0;i<level.bulletStrafe[self.dataIndex].size;i++)
	{
		playfx ( level._effect["bulletStrafe"][(level.bulletStrafe[self.dataIndex][i]["type"])], level.bulletStrafe[self.dataIndex][i]["coord"] );
		
		switch(level.bulletStrafe[self.dataIndex][i]["type"])
		{
			case "water":
				thread playsoundinspace ("bullet_large_sand", level.bulletStrafe[self.dataIndex][i]["coord"] );
				break;
			case "beach":
				thread playsoundinspace ("bullet_large_water", level.bulletStrafe[self.dataIndex][i]["coord"] );
				break;
		}
		
		wait 0.15;
	}
}

atmosphere_bunkerShelling()
{
	assert(isdefined(self.target));
	for (;;)
	{
		self waittill ("trigger");
		wait randomfloat(4);
		
		locations = getentarray(self.target,"targetname");
		assert(locations.size > 0);
		pickedLocation = locations[randomint(locations.size)];
		locations = undefined;
		
		pickedLocation thread playSoundinSpace(level.scrsound["mortar"]["distant"]);
		pickedLocation thread playSoundinSpace(level.scrsound["mortar"]["bunker"]);
		
		range = 200;
		
		org1 = pickedLocation.origin;
		org2 = pickedLocation.origin + ( ( (0 - range) + randomfloat(range * 2)), ( (0 - range) + randomfloat(range * 2)), 0  );
		org3 = pickedLocation.origin + ( ( (0 - range) + randomfloat(range * 2)), ( (0 - range) + randomfloat(range * 2)), 0  );
		
		playfx (level._effect["bunker_ceilingDust"], org1 );
		playfx (level._effect["bunker_ceilingDust"], org2 );
		playfx (level._effect["bunker_ceilingDust"], org3 );
		
		self thread atmosphere_lights_flicker();
		earthquake (.35, 1, pickedLocation.origin, 250);
	}
}

atmosphere_lights_flicker()
{
	if (getcvarint("r_fullbright") > 0)
		return;
	
	if (!level.player istouching(self))
		return;
	
	if ( (isdefined(self.script_noteworthy)) && (self.script_noteworthy == "noflicker") )
		return;
	
	if (isdefined(level.lightsFlickering))
		return;
	level.lightsFlickering = true;
	
	flicker = newHudElem();
	flicker.x = 0;
	flicker.y = 0;
	flicker setshader ("overlay_lights_out", 640, 480);
	flicker.alignX = "left";
	flicker.alignY = "top";
	flicker.horzAlign = "fullscreen";
	flicker.vertAlign = "fullscreen";
	flicker.alpha = 0;
	
	wait 0.05;
	
	//-----------------------------
	//--------FLICKER LOGIC--------
	//-----------------------------
	
	count = (level.lightflicker["minFlickers"] + (level.lightflicker["maxFlickers"] - level.lightflicker["minFlickers"]) );
	for (i=0;i<count;i++)
	{
		if (i==0)
		{
			time = (0.1 + randomfloat(.25));
			flicker fadeOverTime(time);
			flicker.alpha = level.lightflicker["maxDarkness"];
			wait time;
			wait (randomfloatrange(level.lightflicker["minDarknessTime"], level.lightflicker["maxDarknessTime"]));
			flicker fadeOverTime(time);
			flicker.alpha = 0;
			wait time;
		}
		else
		{
			time = (0.05 + randomfloat(.15));
			flicker fadeOverTime(time);
			flicker.alpha = randomfloatrange(level.lightflicker["minDarkness"], level.lightflicker["maxDarkness"]);
			
			wait(randomfloat(time));
			//wait time;
			
			//wait (randomfloatrange(level.lightflicker["minDarknessTime"], level.lightflicker["maxDarknessTime"]));
			
			time = (0.05 + randomfloat(.15));
			flicker fadeOverTime(time);
			flicker.alpha = 0;
			
			wait(randomfloat(time));
		}
		wait (randomfloatrange(level.lightflicker["minDarknessPause"], level.lightflicker["maxDarknessPause"]));
	}
	
	//-----------------------------
	//-----------------------------
	//-----------------------------
	
	flicker destroy();
	level.lightsFlickering = undefined;
}

atmosphere_rightfield_mortars()
{
	mortars = [];
	for (i=0;i<level.struct_targetname["mortar"].size;i++)
	{
		if (level.struct_targetname["mortar"][i].script_mortargroup != "2")
			continue;
		mortars[mortars.size] = level.struct_targetname["mortar"][i];
	}
	
	level waittill ("right_field_mortars");
	level endon ("stop_right_field_mortars");
	for (;;)
	{
		wait randomfloat(2);
		mortars[randomint(mortars.size)] thread maps\_mortar::duhoc_style_mortar_explode(true);
	}
}

atmosphere_stairwell_sound()
{
	trig = getent("stairwell_sound_trigger","targetname");
	trig waittill ("trigger");
	playsoundinspace("duhocassault_bunkerdooropen", (-1000, 24, 1136) );
	wait 0.1;
	thread playsoundinspace("duhocassault_bunkerdoorclosed", (-1000, 24, 1136) );
}

flakveirling_start()
{
	if (getcvarint("duhoc_flakverling") <= 0)
		return;
	
	assert(isdefined(level.flakveirling));
	level.flakveirling.health = 1000000000;
	level.flakveirling flakveirling_setupCrew();
	thread flakveirling_respawn_crew();
}

flakveirling_setupCrew()
{	
	if (flag("across_field"))
		return;
	tag = [];
	tag[0] = "driver_flak";
	tag[1] = "loaderL_flak";
	tag[2] = "loaderR_flak";
	
	spawner = getent("flakveirling_crew_spawner","targetname");
	
	self.crew = [];
	for (i=0;i<3;i++)
	{
		spawner.count = 1;
		for (;;)
		{
			self.crew[i] = spawner stalingradSpawn();
			if (!spawn_failed(self.crew[i]))
				break;
			wait 0.05;
		}
		self.crew[i] thread magic_bullet_shield();
		self.crew[i].animName = tag[i];
		
		self.crew[i].dropWeapon = false;
		self.crew[i].grenadeAmmo = 0;
		self.crew[i] animscripts\shared::putGunInHand ("none");
		self.crew[i] linkto (self, tag[i]);
		self.crew[i] thread flakveirling_crewdeath(tag[i], self);
		self.crew[i].allowdeath = 1;
		self.crew[i] thread anim_loop_solo( self.crew[i], "fire", tag[i], "stop_flakpanzer_anim", undefined, self );
	}
	
	level.flakveirling thread flakveirling_target();
	level.flakveirling thread flakveirling_kill();
	level.flakveirling thread flakveirling_randomAim( getentarray(level.flakveirling.target,"targetname") );
}

flakveirling_inoperation()
{
	inOperation = false;
	if (isdefined(level.flakveirling.crew))
	{
		//make sure all crew memebers are dead
		for( i = 0 ; i < level.flakveirling.crew.size ; i++ )
		{
			guy = level.flakveirling.crew[i];
			if (!isdefined(guy))
				continue;
			if (isalive(guy))
			{
				inOperation = true;
				break;
			}
		}
	}
	return inOperation;
}

flakveirling_respawn_crew(animTag, flak)
{
	trig = getent("respawn_flakveirling_crew","targetname");
	for (;;)
	{
		trig waittill ("trigger");
		if (!isdefined(level.flakveirling))
		{
			wait 1;
			continue;
		}
		
		if (!flakveirling_inoperation())
			level.flakveirling thread flakveirling_setupCrew();
	}
}

flakveirling_crewflee(animTag, flak)
{
	self endon ("death");
	level.flakveirling waittill ("kill_flakveirling");
	
	self notify ("fleeing_flakveirling");
	self notify ("stop_flakpanzer_anim");
	self anim_single_solo(self, "dismount", animTag, undefined, flak);
	self animscripts\shared::putGunInHand("right");
	self notify ("stop magic bullet shield");
	node = getnode("flakveirling_fleenode","targetname");
	self.goalradius = 8;
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.fightDist = 0;
	self.maxdist = 0;
	self.maxsightdistsqrd = 0;
	self setgoalnode(node);
	self unlink();
	self waittill ("goal");
	self dodamage(self.health + 1, self.origin);
}

flakveirling_crewdeath(animTag, flak)
{
	self endon ("fleeing_flakveirling");
	if (animTag != "driver_flak")
		self thread flakveirling_crewflee(animTag, flak);
	
	for (;;)
	{
		self waittill ( "damage", amount, attacker );
		if (!isdefined(attacker))
			continue;
		if (attacker == level.player)
			break;
	}
	self notify ("stop_flakpanzer_anim");
	
	if (animTag == "driver_flak")
	{
		//stop the gun if the gunner dies. Then make the loaders (if alive) flee
		level.flakveirling notify ("kill_flakveirling");
	}
	
	self.deathanim = level.scr_anim[self.animname]["death"];
	self unlink(); 
	self dodamage(self.health + 1, self.origin);
}

flakveirling_target()
{
	//triggers target a script_origin, when the triger is hit the flackveirling shoots the associated origins
	flakveirling_target = getentarray("flakveirling_target","targetname");
	for(i=0;i<flakveirling_target.size;i++)
		flakveirling_target[i] thread flakveirling_target_think();
}

flakveirling_target_think()
{
	level.flakveirling endon ("kill_flakveirling");
	assert(isdefined(self.target));
	
	for (;;)
	{
		self waittill ("trigger", other);
		self notify ("new_target");
		
		level.flakveirling notify ("stop_flakveirling");
		level.flakveirling thread flakveirling_randomAim( getentarray(self.target,"targetname") );
		
		self waittill ("new_target");
	}
}

flakveirling_kill()
{
	//when the triger is hit the flackveirling shoots the triggering entity
	flakveirling_kill = getentarray("flakveirling_kill","targetname");
	for(i=0;i<flakveirling_kill.size;i++)
		flakveirling_kill[i] thread flakveirling_kill_think();
}

flakveirling_kill_think()
{
	level.flakveirling endon ("kill_flakveirling");
	for (;;)
	{
		self waittill ("trigger", other);
		self notify ("new_target");
		level.flakveirling notify ("stop_flakveirling");
		target[0] = other;
		level.flakveirling thread flakveirling_randomAim(target);
		self waittill ("new_target");
	}
}

flakveirling_randomAim(targets)
{
	assert(isdefined(targets));
	assert(isdefined(targets[0]));
	
	level.flakveirling endon ("kill_flakveirling");
	level.flakveirling endon ("stop_flakveirling");
	lastIndex = -1;
	shooting = false;
	while(isdefined(self))
	{
		randIndex = randomint(targets.size);
		if (randIndex == lastIndex)
		{
			if ( (randIndex + 1) >= targets.size )
				randIndex = (randIndex - 1);
			else
				randIndex = (randIndex + 1);
		}
		randHeight = (-20 + (randomfloat(40)) );
		
		self setTurretTargetEnt( targets[randIndex], (0,0,randHeight) );
		self waittill ("turret_on_target");
		
		if (!shooting)
		{
			self thread flakveirling_fire();
			shooting = true;
		}
		
		wait randomfloat(1);
		
		if (!isdefined(self))
			return;
	}
}

flakveirling_fakeshots()
{
	level.flakveirling.fakeShots = true;
}

flakveirling_stopfakeshots()
{
	level.flakveirling.fakeShots = undefined;
}

flakveirling_fire()
{
	level.flakveirling endon ("kill_flakveirling");
	level.flakveirling endon ("stop_flakveirling");
	level.flakveirling endon ("reloading");
	barrel = 1;
	for (;;)
	{
		if ( (isdefined(level.flakveirling.fakeShots)) && (level.flakveirling.fakeShots == true) )
			level.flakveirling playsound ("flak20_fire_bunker");
		else
			level.flakveirling FireTurret();
		
		wait .13;
		
		if (randomint(30) == 0)
			wait 1;
	}
}

flakveirling_deadly_zone()
{
	//player touching this is deadly (unless of course the flak has been killed via artillery
	level endon ("flakveirling_dead");
	
	trig = getent("flak_deadly_zone","targetname");
	source = getent(trig.target,"targetname").origin;
	trig waittill ("trigger");
	
	if (flakveirling_inoperation())
	{
		if (isdefined(level.flakveirling))
		{
			level.flakveirling notify ("stop_flakveirling");
			//flakveirling tries to shoot the player
			thread flakveirling_deadly_zone_death(source);
		}
		//failsafe if flak can't target the player in time
		thread flakveirling_deadly_zone_forceDeath(source);
	}
	else
	{
		//flakveirling isn't in operation so mortars will prevent player from passing
		thread flakveirling_deadly_zone_mortars();
	}
}

flakveirling_deadly_zone_mortars()
{
	for( i = 0 ; i < 4 ; i++ )
	{
		thread flakveirling_deadly_zone_domortar();
		wait randomfloat(1.5);
	}
	thread flakveirling_deadly_zone_domortar(true);
}

flakveirling_deadly_zone_domortar(deadly)
{
	if (!isdefined(deadly))
		deadly = false;
	
	level.player playSoundOnEntity (level.scrsound["mortar"]["incomming"]);
	//playSoundinSpace (level.scrsound["mortar"]["incomming"], location);
	
	randX = ((level.player.origin[0] - 150) + randomfloat(300));
	randY = ((level.player.origin[1] - 150) + randomfloat(300));
	location = (randX, randY, level.player.origin[2]);
	
	thread playSoundinSpace (level.scrsound["mortar"]["dirt"], location);
	playfx (level._effect["mortar"]["dirt"], location);
	earthquake(0.25, 2, location, 1250);
	
	if ( (deadly) && (isalive(level.player)) )
	{
		level.player enableHealthShield(false);
		level.player dodamage(level.player.health + 10, level.player.origin);
		level.player enableHealthShield(true);
		assert(!isalive(level.player));
	}
	else
		radiusDamage ( location, 250, 100, 100);
}

flakveirling_deadly_zone_death(source)
{
	level endon ("flakveirling_dead");
	
	level.savehere = false;
	wait 1.5;
	while(isalive(level.player))
	{
		level.flakveirling setTurretTargetEnt( level.player, (0,0,24) );
		level.flakveirling FireTurret();
		level.player doDamage (15, source);
		wait .13;
	}
	level.savehere = undefined;
}

flakveirling_deadly_zone_forceDeath(source)
{
	level endon ("flakveirling_dead");
	
	wait 4;
	while(isalive(level.player))
	{
		level.player doDamage (15, source);
		wait .13;
	}
}

trench_frame_break()
{
	assert(isdefined(self.target));
	self setcandamage(true);
	trig = getent(self.target,"targetname");
	assert(isdefined(trig));
	assert(trig.classname == "trigger_damage");
	
	for (;;)
	{
		trig waittill ("damage", amount, attacker);
		amount = undefined;
		if (!isdefined(level.flakveirling))
			return;
		if (attacker != level.flakveirling)
			continue;
		if ( distance(level.player.origin, self.origin) > 600 )
			continue;
		
		trig delete();
		self setcandamage(false);
		break;
	}
	
	playfxontag(level._effect["trenchframe01_break"], self, "tag_fx");
	self playsound("crate_impact");
	wait .8;
	self setmodel("xmodel/trenchframe01_broken");
}

sound_trigger()
{
	bunkerSave = false;
	if (isdefined(self.script_noteworthy2))
	{
		flag_wait(self.script_noteworthy2);
		if (self.script_noteworthy2 == "allow_bunker_clear_dialogue")
			bunkerSave = true;
	}
	else
		wait 5;
	self waittill ("trigger");
	assert(isdefined(self.script_noteworthy));
	assert(isdefined(self.target));
	org = getent(self.target,"targetname");
	assert(isdefined(org));
	assert(org.classname == "script_origin");
	
	if (bunkerSave)
		thread autosavebyname("bunker");
	
	org playSoundInSpace(self.script_noteworthy);
}

exploder15()
{
	getent("exploder15","targetname") waittill ("trigger");
	exploder(15);
}

floaters_show(qShow)
{
	floater = getentarray("script_floater","targetname");
	for (i=0;i<floater.size;i++)
	{
		if (qShow)
			floater[i] show();
		else
			floater[i] hide();
	}
}

cliff_fall_killplayer()
{
	cliff_fall_killplayer = getent("cliff_fall_killplayer","targetname");
	activator = getent(cliff_fall_killplayer.target,"targetname");
	
	activator waittill ("trigger");
	
	cliff_fall_killplayer waittill ("trigger");
	
	level.player enableHealthShield(false);
	level.player dodamage(level.player.health + 10, level.player.origin);
	level.player enableHealthShield(true);
	assert(!isalive(level.player));
}

rope_climbAnim()
{
	assert(isdefined(level.scr_anim["rope"]["climb"][self.script_rope]));
	
	//self thread debug_ropes();
	
	self setflaggedanimknobrestart("ropeClimbAnim",level.scr_anim["rope"]["pose"][self.script_rope]);
	
	//player rope goes through special script path:
	if (self.script_rope == "player")
	{
		level.playerRope = self;
		return;
	}
	
	if (isdefined(level.climbDelay[self.script_rope]))
		wait (level.climbDelay[self.script_rope]);
	
	self thread ropeClimber_create_wait(self.script_rope);
	self.currentAnim = "climb";
	self setflaggedanimknobrestart("ropeClimbAnim",level.scr_anim["rope"]["climb"][self.script_rope]);
	self waittillmatch ("ropeClimbAnim","end");
	if (!isdefined(level.scr_anim["rope"]["cycle"][self.script_rope]))
		return;
	
	if (self.script_rope == "5")
	{
		self thread scripted_event_ranger_rope_falls();
	}
	
	self endon ("stop_climb_anim");
	self.currentAnim = "cycle";
	for(;;)
	{	
		self thread ropeClimber_create_wait(self.script_rope);
		self setflaggedanimknobrestart("ropeClimbAnim",level.scr_anim["rope"]["cycle"][self.script_rope]);
		self waittillmatch ("ropeClimbAnim","end");
	}
}

ropeClimber_getByRopeAndTag(ropeNum, tagName)
{
	guy = getentarray("cliffclimber","targetname");
	for (i=0;i<guy.size;i++)
	{
		if (!isdefined(guy[i]))
			continue;
		if (!isdefined(guy[i].climbing))
			continue;
		if (!guy[i].climbing)
			continue;
		if (guy[i].script_rope != ropeNum)
			continue;
		if (guy[i].animTag != tagName)
			continue;
		return guy[i];
	}
}

ropeClimber_create(notetrackName, spawnOrg, ropeNum)
{
	climber = character_nonAI_spawn_lowRes(undefined);
	climber character_assignWeapon();
	climber.animname = "cliffclimber";
	climber.origin = spawnOrg;
	climber UseAnimTree(level.scr_animtree["cliffclimber"]);
	climber.notetrackName = notetrackName;
	climber.targetname = "cliffclimber";
	climber.script_rope = ropeNum;
	climber.animTag = ("tag_" + climber.notetrackName);
	climber thread ropeClimber_doAnims(self, climber.animTag, true );
}

ropeClimber_allowSpawn_checkConditions(spawnLoc)
{
	/*-----------------------------------------------------------
	If the player is within a certain radius and looking the
	direction of the character that is going to spawn then
	suspend the animations until the conditions are no longer met
	-----------------------------------------------------------*/
	prof_begin("ropeclimbers_pauseMath");
	pauseAnims = false;
	//Check if the player is close to where the guy would spawn
	if ( distance(level.player.origin, spawnLoc) < level.ropeClimberSpawnDist )
	{
		//Check if where the guy would spawn is within the players FOV
		forwardvec = anglestoforward(level.player.angles);
		normalvec = vectorNormalize(spawnLoc - (level.player getOrigin()) );
		vecdot = vectordot(forwardvec,normalvec);
		if (vecdot > level.cos80)
			pauseAnims = true;
	}
	prof_end("ropeclimbers_pauseMath");
	return (pauseAnims);
	//-------------------------------------------------------------
	//-------------------------------------------------------------
	//-------------------------------------------------------------
}

#using_animtree("duhoc_rope");
ropeClimber_allowSpawn(spawnLoc)
{
	pauseAnims = self ropeClimber_allowSpawn_checkConditions(spawnLoc);
	
	//Pause the animations until the condition is no longer met
	if (pauseAnims)
	{
		//pause the animation
		self setanim(level.scr_anim["rope"][self.currentAnim][self.script_rope], 1, 0, 0);
		
		//make all climbers do stop animation
		climbers = getentarray("cliffclimber","targetname");
		for( i = 0 ; i < climbers.size ; i++ )
		{
			if (!isdefined(climbers[i].script_rope))
				continue;
			if (climbers[i].script_rope != self.script_rope)
				continue;
			if (!isdefined(climbers[i].climbing))
				continue;
			if (climbers[i].climbing != true)
				continue;
			climbers[i] thread ropeClimber_pauseClimbing(self);
		}
		
		while(pauseAnims)
		{
			wait 1;
			if (!( self ropeClimber_allowSpawn_checkConditions(spawnLoc) ))
			{
				//unfreeze the rope animations now
				self SetFlaggedAnimKnobAll( "ropeClimbAnim", level.scr_anim["rope"][self.currentAnim][self.script_rope], %root, 1.0, 0.1, 1.0);
				
				//make all climbers resume climb animations
				climbers = getentarray("cliffclimber","targetname");
				for( i = 0 ; i < climbers.size ; i++ )
				{
					if (!isdefined(climbers[i].script_rope))
						continue;
					if (climbers[i].script_rope != self.script_rope)
						continue;
					if (!isdefined(climbers[i].climbing))
						continue;
					if (climbers[i].climbing != true)
						continue;
					climbers[i] thread ropeClimber_resumeClimbing(self);
				}
				
				pauseAnims = false;
			}
		}
	}
}

ropeClimber_pauseClimbing(rope, alternateIdle)
{
	if (!isdefined(alternateIdle))
		alternateIdle = false;
	
	//stop doing the animations you are doing now
	self notify ("stopClimbAnim");
	
	if ( (isdefined(self.paused)) && (self.paused == true) )
		return;
	self.paused = true;
	
	//do the stop animation
	self maps\_anim::anim_single_solo( self, "stop_stop", self.animtag, undefined, rope );
	if ( (isdefined(self.resuming)) && (self.resuming == true) )
		return;
	if (!isdefined(self))
		return;
	
	self notify ("stopClimbAnim");
	
	if (!isdefined(self.animname))
		return;
	if ( (self.animname != "cliffclimber_player") && (self.animname != "cliffclimber") )
		return;
	
	if (alternateIdle)
		self thread maps\_anim::anim_loop_solo( self, "stop_idle2", self.animtag, "stopClimbAnim", undefined, rope);
	else
		self thread maps\_anim::anim_loop_solo( self, "stop_idle", self.animtag, "stopClimbAnim", undefined, rope);
}

ropeClimber_resumeClimbing(rope)
{
	//stop doing the animations you are doing now
	self notify ("stopClimbAnim");
	self.resuming = true;
	
	//resume climb animations
	self thread maps\_anim::anim_loop_solo( self, "climb_cycle", self.animtag, "stopClimbAnim", undefined, rope);
	
	self.resuming = undefined;
	self.paused = undefined;
}

ropeClimber_create_wait(ropeNum)
{
	self endon ("stop_climb_anim");
	if (!level.ropeClimbersActive)
		return;
	
	notetrack[0] = "climber01_mount";
	tagName[0] = "tag_climber01";
	newNoteName[0] = "climber01";
	
	notetrack[1] = "climber02_mount";
	tagName[1] = "tag_climber02";
	newNoteName[1] = "climber02";
	
	notetrack[2] = "climber03_mount";
	tagName[2] = "tag_climber03";
	newNoteName[2] = "climber03";
	
	notetrack[3] = "climber04_mount";
	tagName[3] = "tag_climber04";
	newNoteName[3] = "climber04";
	
	notetrack[4] = "climber05_mount";
	tagName[4] = "tag_climber05";
	newNoteName[4] = "climber05";
	
	notetrack[5] = "climber06_mount";
	tagName[5] = "tag_climber06";
	newNoteName[5] = "climber06";
	
	for( i = 0 ; i < notetrack.size ; i++ )
	{
		self waittillmatch ( "ropeClimbAnim", notetrack[i] );
		
		if ( (self.script_rope == "5") && (level.playerRopeClimbersStarted) )
		{
			if (issubstr(notetrack[i], "mount"))
				continue;
		}
		
		//wait frame to allow bone to get into position
		wait 0.05;
		spawnLoc = self getTagOrigin( tagName[i] );
		self ropeClimber_allowSpawn( spawnLoc );
		thread ropeClimber_create( newNoteName[i], spawnLoc, ropeNum );
	}
}

rope_climbAnim_playerRope_randall_yell(num)
{
	node_bottomcliff_randall = getnode("bottomcliff_randall","targetname");
	assert(isdefined(node_bottomcliff_randall));
	assert(isdefined(level.randall));
	
	soundAlias = undefined;
	animName = undefined;
	if (num == 1)
	{
		soundAlias = undefined;
		animName = undefined;
		//soundAlias = level.scrsound["randall"]["duhocassault_randall_ropesoldier"];
		//animName = "getuprope2";
	}
	else
	if (num == 2)
	{
		soundAlias = level.scrsound["randall"]["duhocassault_randall_getgoing"];
		animName = "gocorporal";
	}
	else
	if (num == 3)
	{
		soundAlias = level.scrsound["randall"]["duhocassault_randall_allgetuprope"];
		animName = "getuprope";
		if ( !flag("beach_dialogue_done") )
			level waittill ("beach_yell_dialogue_done");
		level.pauseBeachChatter = true;
	}
	else
		return;
	
	if ( (!isdefined(soundAlias)) && (!isdefined(animName)) )
		return;
	
	level.randall notify ("stop_cliffidle_anim");
	level.randall thread anim_single_solo( level.randall, animName, undefined, node_bottomcliff_randall );
	level.randall waittillmatch ("single anim","dialog");
	level.randall thread animscripts\face::SaySpecificDialogue(undefined, soundAlias, 1);
	level.randall waittillmatch ("single anim","end");
	level.randall thread anim_loop_solo( level.randall, "cliffidle", undefined, "stop_cliffidle_anim", node_bottomcliff_randall );
	level.pauseBeachChatter = false;
}

rope_climbAnim_playerRope(climber)
{
	//randall yells at other soldiers to get up the cliff
	level thread rope_climbAnim_playerRope_randall_yell(1);
	
	//get the first climber into position
	climber[0] ShooterRun( level.playerRope getTagOrigin ("tag_climber01") );
	
	//first climber in position now
	
	//start the rope animation and his climb sequence
	level.playerRope setModel(level.playerRopeModel);
	level.playerRope thread rope_climbAnim_playerRope_doAnims(climber[2], climber[1]);
	
	//first guy mounts the rope and climbs
	climber[0].notetrackName = "climber01";
	climber[0] thread ropeClimber_doAnims(level.playerRope, "tag_climber01", true, true);
	level.playerRopeClimbersStarted = true;
	
	level.playerRope waittillmatch("ropeClimbAnim","climber02_mount");
	level.playerRope setflaggedanimknob("ropeClimbAnim",level.scr_anim["rope"]["climb"]["player"], 1, 0, 0);
	
	//more yelling to get guys up the rope
	level thread rope_climbAnim_playerRope_randall_yell(2);
	
	//get the second guy into position
	climber[1] ShooterRun( level.playerRope getTagOrigin ("tag_climber02") );
	climber[1].notetrackName = "climber02";
	level.playerRope setflaggedanimknob("ropeClimbAnim",level.scr_anim["rope"]["climb"]["player"], 1, 0, 1);
	climber[1] thread ropeClimber_doAnims(level.playerRope, "tag_climber02", true, true);
	
	level.playerRope waittillmatch("ropeClimbAnim","climber03_mount");
	level.playerRope setflaggedanimknob("ropeClimbAnim",level.scr_anim["rope"]["climb"]["player"], 1, 0, 0);
	
	//third guy into position now
	climber[2] ShooterRun( level.playerRope getTagOrigin ("tag_climber03") );
	climber[2].notetrackName = "climber03";
	level.playerRope setflaggedanimknob("ropeClimbAnim",level.scr_anim["rope"]["climb"]["player"], 1, 0, 1);
	flag_set("restrictPlayerRopeClimb");
	climber[2] thread ropeClimber_doAnims(level.playerRope, "tag_climber03", true, true);
	
	//signals for player to get up the rope
	getent("getupcliff_taylor_trigger","targetname") waittill ("trigger");
	level thread rope_climbAnim_playerRope_randall_yell(3);
	
	climbTrigger = getent("trigger_climb_rope","targetname");
	climbTrigger triggerOn();
	climbTrigger setHintString(&"DUHOC_PLATFORM_USEROPE", getKeyBinding( getUseKey() )["key1"]);
}

rope_climbAnim_playerRope_doAnims(lastClimber, middleClimber)
{
	self setflaggedanimknobrestart("ropeClimbAnim",level.scr_anim["rope"]["climb"][self.script_rope]);
	
	self waittillmatch ("ropeClimbAnim","climber03_fall");
	
	climberPos = level.playerrope getTagOrigin( "tag_climber03" );
	
	//pause the rope and climbers until the player is in position
	self setanim(level.scr_anim["rope"]["climb"][self.script_rope], 1, 0, 0);
	middleClimber thread ropeClimber_pauseClimbing(self);
	lastClimber thread ropeClimber_pauseClimbing(self, true);
	
	climberPos = level.playerrope getTagOrigin( "tag_climber03" );
	while (distance (level.player.origin, climberPos) > 250)
		wait 0.2;
	
	level thread scripted_event_playerrope_fall_german();
	
	wait 1;
	
	//resume middle climber and rope animations
	self SetFlaggedAnimKnobAll( "ropeClimbAnim", level.scr_anim["rope"]["climb"][self.script_rope], %root, 1.0, 0.1, 1.0);
	middleClimber thread ropeClimber_resumeClimbing(self);
	lastClimber notify ("stopClimbAnim");
	
//	self waittillmatch ("ropeClimbAnim","climber03_fall");
	level thread scripted_event_playerrope_fall(lastClimber);
	level.makeRangerRopeFall = true;
	flag_clear("restrictPlayerRopeClimb");
	
	self waittillmatch ("ropeClimbAnim","end");
	
	self setflaggedanimknobrestart("ropeClimbAnim",level.scr_anim["rope"]["sway"][self.script_rope]);
}

ropeClimber_doAnims(rope, tagName, mountNow, doDustFX)
{
	self endon ("fell_off_rope");
	
	if (rope.script_rope == "player")
		self.animname = "cliffclimber_player";
	else
		self.animname = "cliffclimber";
	
	self useAnimTree(level.scr_animtree["cliffclimber"]);
	
	if (!isdefined(mountNow))
		mountNow = false;
	
	if (mountNow)
	{
		self notify ("stopClimbAnim");
		self linkto (rope, tagName);
		self.climbing = true;
		if ( (isdefined(doDustFX)) && (doDustFX == true) )
			self thread ropeClimber_doDustFX(rope, tagName);
		
		self maps\_anim::anim_single_solo( self, "mount", tagName, undefined, rope );
		self clearanim(level.scr_anim[self.animname]["mount"], 0);
		if ( (!isdefined(self.paused)) || ((isdefined(self.paused)) && (self.paused != true)) )
			self thread maps\_anim::anim_loop_solo( self, "climb_cycle", tagName, "stopClimbAnim", undefined, rope);
	}
	
	for (;;)
	{
		rope waittill ("ropeClimbAnim", notetrack);
		if (!issubstr(notetrack, self.notetrackName))
			continue;
		
		if ( (issubstr(notetrack, "_mount")) && (!mountNow) )
		{
			if ( (isdefined(doDustFX)) && (doDustFX == true) )
				self thread ropeClimber_doDustFX(rope, tagName);
			self notify ("stopClimbAnim");
			self linkto (rope, tagName);
			self.climbing = true;
			
			self maps\_anim::anim_single_solo( self, "mount", tagName, undefined, rope );
			self clearanim(level.scr_anim[self.animname]["mount"], 0);
			if ( (!isdefined(self.paused)) || ((isdefined(self.paused)) && (self.paused != true)) )
				self thread maps\_anim::anim_loop_solo( self, "climb_cycle", tagName, "stopClimbAnim", undefined, rope);
		}
		else
		if (issubstr(notetrack, "_dismount"))
		{
			self.climbing = undefined;
			self notify ("stopClimbAnim");
			self unlink();
			self notify ("stop dust fx");
			
			//figure out which path this fake drone should take
			for ( i = 0 ; i < level.struct_targetname["cliffclimber_runpath"].size ; i++ )
			{
				if (level.struct_targetname["cliffclimber_runpath"][i].script_rope != rope.script_rope)
					continue;
				self thread ropeClimber_droneRunPath(i);
				return;
			}
		}
		else
		if (issubstr(notetrack, "_slip"))
		{
			self notify ("stopClimbAnim");
			if (rope.script_rope == "player")
				playfx(level._effect["cliff_dust_rocks"], rope getTagOrigin("tag_climber03") );
			
			self maps\_anim::anim_single_solo( self, "slip", tagName, undefined, rope );
			if ( (!isdefined(self.paused)) || ((isdefined(self.paused)) && (self.paused != true)) )
			{
				self notify ("stopClimbAnim");
				self thread maps\_anim::anim_loop_solo( self, "climb_cycle", tagName, "stopClimbAnim", undefined, rope);
			}
		}
	}
}

ropeClimber_doDustFX(rope, tagName)
{
	self endon ("stop dust fx");
	for(;;)
	{
		wait (1 + randomfloat(1));
		playfx(level._effect["cliff_dust_rocks"], rope getTagOrigin(tagName) );
	}
}

ropeClimber_droneRunPath(index)
{
	self endon ("drone_death");
	struct = level.struct_targetname["cliffclimber_runpath"][index];
	for (;;)
	{
		if (!isdefined(struct.targeted))
			break;
		if (!isdefined(struct.targeted[0]))
			break;
		index = randomint(struct.targeted.size);
		if ( (isdefined(struct.script_death_min)) && (isdefined(struct.script_death_max)) )
			self thread drone_delayed_bulletdeath(randomfloat(struct.script_death_min + (struct.script_death_max - struct.script_death_min)));
		if (isdefined(struct.script_noteworthy))
			self ShooterRun(struct.targeted[index].origin, struct.script_noteworthy);
		else
			self ShooterRun(struct.targeted[index].origin);
		
		struct = struct.targeted[index];
	}
	self thread drone_delayed_bulletdeath(0);
}

mg42_grazer_start()
{
	getent ("clifftop","targetname") waittill ("trigger");
	level array_thread (getentarray("mg42_grazer","targetname"), ::mg42_grazer_think);
	level notify ("start grazing mg42s");
}

mg42_grazer_think()
{
	//mg42 targets script origins and maybe spawners
	temp = getentarray(self.target,"targetname");
	targets = [];
	spawner = undefined;
	for (i=0;i<temp.size;i++)
	{
		if (temp[i].classname == "script_origin")
			targets[targets.size] = temp[i];	
		else
			spawner = temp[i];
	}
	targets = array_randomize(targets);	
	
	if (targets.size <= 1)
		return;
	
	//gun targets a spawned script_origin that will move around from target to target
	aimEnt = spawn("script_origin",targets[0].origin);
	self settargetentity(aimEnt);
	
	level waittill ("start grazing mg42s");
	
	//spawn the gunner if one exists and make him use the gun
	if (isdefined (spawner))
	{
		gunner = spawner doSpawn();
		if (spawn_failed(gunner))
		{
			self cleartargetentity();
			return;
		}
		self setturretignoregoals(true);
		gunner useTurret(self);
		gunner thread maps\_mg42::burst_fire(self);
	}
	else
	{
		self setmode("auto_nonai");
		self thread maps\_mg42::burst_fire_unmanned();
	}
	
	nextPos = 0;
	for(;;)
	{
		nextPos++;
		if (nextPos >= targets.size)
		{
			targets = array_randomize(targets);
			nextPos = 0;
		}
		movetime = (1/1350)*(distance(aimEnt.origin,targets[nextPos].origin));
		if (movetime <= 0)
			movetime = 1;
		
		aimEnt moveTo(targets[nextPos].origin, movetime, 0, 0);
		aimEnt waittill ("movedone");
	}
}

triggered_delete_ai()
{
	if (!isdefined(self.script_deleteai))
		return;
	self waittill ("trigger");
	ai = getaiarray();
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined(ai[i].script_deleteai))
			continue;
		if (self.script_deleteai != ai[i].script_deleteai)
			continue;
		ai[i] dodamage(ai[i].health + 1, ai[i].origin);
	}
}

hint_smokegrenade()
{
	level endon ("artillary_barriage");
	for (;;)
	{
		self waittill ("trigger");
		if (!flag("smoke_hint"))
			break;
		wait 0.05;
	}
	
	flag_set("smoke_hint");
	
	if (level.gameSkill < 2)
		self thread hint_smokegrenade_tryDeploySmoke();
	
	d1 = 500 + randomint(500);
	if (randomint(2) == 0)
		d1 = (d1 * -1);
	d2 = 500 + randomint(500);
	
	playsoundinspace("hint_smokegrenade", ( level.player.origin[0] + d1, level.player.origin[1] - d2, level.player.origin[2] ) );
	wait (5 + randomfloat(10));
	flag_clear("smoke_hint");
}

hint_smokegrenade_tryDeploySmoke()
{
	if (!isdefined(self.script_smokegroup))
		return;
	
	//check if smoke in this group is already going
	if (!isdefined(level.smokeHints[self.script_smokegroup]))
		level.smokeHints[self.script_smokegroup] = false;
	if (level.smokeHints[self.script_smokegroup] == true)
		return;
	level.smokeHints[self.script_smokegroup] = true;
	
	assert(isdefined(self.target));
	smokeLoc = getent(self.target,"targetname").origin;
	assert(isdefined(smokeLoc));
	
	wait 4;
	
	playfx( level._effect["american_smoke_grenade"], smokeLoc, smokeLoc + (0,0,1) );
	
	wait 40;
	level.smokeHints[self.script_smokegroup] = false;
}

across_field_autosave()
{
	self waittill ("trigger");
	flag_set("across_field");
	thread autosavebyname("across_field");
}

pinned_friendlies()
{
	assert(isdefined(self.target));
	assert(isdefined(self.script_noteworthy));
	dummy = getent(self.target,"targetname");
	assert(isdefined(dummy));
	assert(isdefined(dummy.target));
	
	spawners = [];
	areaTrig = undefined;
	targeted = getentarray(dummy.target,"targetname");
	assert(isdefined(targeted));
	assert(targeted.size > 0);
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if (targeted[i].classname == "trigger_radius")
			areaTrig = targeted[i];
		else
			spawners[spawners.size] = targeted[i];
	}
	assert(isdefined(areaTrig));
	nodes = getnodearray(dummy.target,"targetname");
	
	escape_nodes = [];
	for( i = 0 ; i < nodes.size ; i++ )
	{
		assert(isdefined(nodes[i].target));
		node = undefined;
		node = getnode(nodes[i].target,"targetname");
		assert(isdefined(node));
		escape_nodes[escape_nodes.size] = node;
	}
	
	assert(nodes.size == escape_nodes.size);
	
	self waittill ("trigger");
	
	//spawn the AI
	ai = [];
	for( i = 0 ; i < spawners.size ; i++ )
	{
		spawners[i].script_moveoverride = 1;
		guy = spawners[i] stalingradSpawn();
		if (spawn_failed(guy))
			continue;
		guy setBattleChatter(false);
		guy.goalradius = 16;
		guy setgoalnode (nodes[i]);
		guy thread magic_bullet_shield();
		ai[ai.size] = guy;
		guy = undefined;
	}
	
	//wait till the player is nearby or thread times out
	areaTrig thread timeoutTriggerWait(30);
	areaTrig waittill ("trigger");
	
	//AI do their dialogue
	switch(self.script_noteworthy)
	{
		case "bunker1":
			assert(ai.size >= 2);
			//dialog
			ai[1] playSoundInSpace( "US_3_inform_suppressed" );
			ai[0] playSoundInSpace( "US_0_inform_suppressed_generic" );
			ai[1] playSoundInSpace( "US_0_order_cover_bunker" );
			ai[0] thread playSoundInSpace( "US_0_response_acknowledge_yes" );
			//run off
			ai[0] setgoalnode ( escape_nodes[0] );
			ai[1] setgoalnode ( escape_nodes[1] );
			ai[0] notify ( "stop magic bullet shield" );
			ai[1] notify ( "stop magic bullet shield" );
			ai[0] thread pinned_friendlies_timedDeath( 3 + randomfloat(2) );
			ai[1] thread pinned_friendlies_timedDeath( 3 + randomfloat(2) );
			break;
		
		case "trench1":
			assert(ai.size >= 2);
			//dialog
			ai[1] playSoundInSpace( "US_2_inform_suppressed_generic" );
			ai[0] playSoundInSpace( "US_1_inform_suppressed" );
			ai[1] playSoundInSpace( "US_2_order_cover_trench" );
			ai[0] thread playSoundInSpace( "duhocassault_gr1_gogogo" );
			//run off
			ai[0] setgoalnode ( escape_nodes[0] );
			ai[1] setgoalnode ( escape_nodes[1] );
			ai[0] notify ( "stop magic bullet shield" );
			ai[1] notify ( "stop magic bullet shield" );
			ai[0] thread pinned_friendlies_timedDeath( 5 + randomfloat(4) );
			ai[1] thread pinned_friendlies_timedDeath( 5 + randomfloat(4) );
			break;
	}
}

pinned_friendlies_timedDeath(timer)
{
	self endon ("death");
	self.threatbias = 10000000;
	wait (timer);
	self doDamage(self.health + 1, self.origin);
}

timeoutTriggerWait( timeout )
{
	wait (timeout);
	self notify ("trigger");
}

forceSpawn_think()
{
	if (!isdefined (self.script_forcespawn))
		return;
	
	//get all spawners
	spawners = getspawnerarray();
	
	//only use the ones with the same script_forcespawn value
	forceSpawners = [];
	for (i=0;i<spawners.size;i++)
	{
		if (!isdefined (spawners[i].script_forcespawn))
			continue;
		if (spawners[i].script_forcespawn == self.script_forcespawn)
			forceSpawners[forceSpawners.size] = spawners[i];
	}
	spawners = undefined;
	assert(isdefined(forceSpawners));
	assert(isdefined(forceSpawners[0]));
	
	//wait for the trigger to get hit
	self waittill ("trigger");
	
	//force the guys to spawn
	for (i=0;i<forceSpawners.size;i++)
	{
		if (isdefined(forceSpawners[i]))
			forceSpawners[i] stalingradSpawn();
	}
}

spawner_think(spawned)
{
	if (spawn_failed(spawned))
		return;
	
	spawned.isSquad = true;
	
	//spawned.dontavoidplayer = true;
	if (!isdefined (spawned.script_noteworthy))
		return;
	
	nodes = undefined;
	volume = undefined;
	
	switch (spawned.script_noteworthy)
	{
		//this squad will not engage in combat until they get to their goal or take damage before getting there
		//if one member of the squad gets to their goal, takes damage, or dies the entire squad will be allowed to engage
		case "wait to engage delete":
			spawned.deleteAtGoal = true;
		case "wait to engage":
			spawned thread blindSquad_think();
			break;
		
		//this guy will seek out the player as soon as he spawns
		case "playerseek":
			spawned thread playerseek();
			break;
		
		case "player_squad":
			spawned thread playerseek_friendly();
			break;
		
		//this guy will run to his targeted node and try to escape. He wont try to fight he just runs away scared.
		//he will be deleted when he gets to his goal so it must be well hidden
		case "escape":
			spawned thread escape_think();
			break;
		
		//cliff_grenade_drop will run to one of the nodes he targets, and throw grenades down the cliff
		//cliff_fighter will run to one of the nodes he targets, and shoot down the cliff
		case "cliff_grenade_drop":
			volume = getent(self.target,"targetname");
			assert (isdefined(volume));
			assert (volume.classname == "trigger_multiple");
		case "cliff_fighter":
			assert(isdefined(self.target));
			nodes = getnodearray(self.target,"targetname");
			assert(isdefined(nodes[0]));
			spawned thread cliff_grenader(nodes, volume);
			break;
		
		//makes the guy walk his chain of nodes, then seek out the player
		case "chain_playerseek":
			spawned thread chain_playerseek(nodes);
			break;
		
		//makes the guy go to his targeted node with a small goal radius, and once he's there he will
		//get a big goal radius (the size of the radius of the node he targeted)
		case "smallgoalfirst":
			spawned thread smallLarge_goal(nodes);
			break;
		
		case "clifftop_mg42_gunner":
			spawned thread clifftop_mg42_gunner();
			break;
		
		case "small_goal_until_pain":
			spawned thread smallgoalTillPain();
			break;
		
		case "lowhealth":
			spawned.health = 25;
			break;
		
		case "friendlychain":
			spawned thread friendlyChain();
			break;
		
		case "chain_nodes":
			if ( (isdefined(spawned.script_noteworthy2)) && (spawned.script_noteworthy2 == "badass") )
			{
				spawned.anim_disablePain = true;
				spawned thread magic_bullet_shield();
			}
			assert(isdefined(self.target));
			nodes = getnodearray(self.target,"targetname");
			if ( (isdefined(nodes)) && (isdefined(nodes[0])) )
				spawned thread chain_nodes(nodes[0]);
			break;
		
		case "badass":
			spawned.anim_disablePain = true;
			spawned thread magic_bullet_shield();
			break;
		
		case "badass_temp":
			spawned.anim_disablePain = true;
			spawned thread magic_bullet_shield();
			spawned thread disable_badass();
			break;
		
		case "bunker_friends":
			spawned thread friendlyChain();
			level.bunker_friends[level.bunker_friends.size] = spawned;
			break;
		
		case "slowmovement":
			spawned.animplaybackrate = 0.8;
			break;
		
		case "blind_mg_gunner":
			spawned.maxsightdistsqrd = 0;
			spawned.fightdist = 0;
			spawned.maxdist = 0;
			spawned.interval = 0;
			break;
		
		default:
			break;
	}
	
	if (!isdefined(spawned.script_noteworthy2))
		return;
	
	switch (spawned.script_noteworthy2)
	{
		case "badass":
			spawned.anim_disablePain = true;
			spawned thread magic_bullet_shield();
			break;
		
		case "bunker_turkeyshoot":
			spawned thread bunker_turkeyshoot();
			break;
	}
}

disable_badass()
{
	self endon ("death");
	wait (4 + randomfloat(4));
	self.anim_disablePain = false;
	self notify ("stop magic bullet shield");
}

bunker_turkeyshoot()
{
	self waittill ("death");
	level.bunker_turkeyshoot_kill++;
	if (level.bunker_turkeyshoot_kill >= 3)
	{
		//turn off old friendlychain triggers
		trigs = getentarray("prebunker_friendlychain","script_noteworthy");
		for (i=0;i<trigs.size;i++)
			trigs[i] delete();
		
		//send one guy to the bunker to get shot
		node = getnode("node_bunker_entrance","targetname");
		thread scripted_event_bunkerEntrance_friendKilled();
		if (!isdefined(level.bunker_friends))
			return;
		if (!isdefined(level.bunker_friends.size))
			return;
		if (!isdefined(level.bunker_friends[level.bunker_friends.size - 1]))
			return;
		level.bunker_friends[level.bunker_friends.size - 1] setgoalnode (node);
		
		//wait for him to get there and die
		level.bunker_friends[level.bunker_friends.size - 1] waittill ("death");
		//wait 3;
		
		level.player setfriendlychain (getnode ("bunker_chain","targetname"));
	}
}

friendlyChain()
{
	self setGoalEntity (level.player);
}

smallgoalTillPain()
{
	self endon ("death");
	self.goalradius = 16;
	self waittill ("pain");
	self.goalradius = 512;
}

smallLarge_goal(nodes)
{
	if ( (isdefined (nodes)) && (isdefined (nodes[0])) )
	{
		self endon ("death");
		self.goalradius = 16;
		self setgoalnode (nodes[0]);
		self waittill ("goal");
		if (isdefined (nodes[0].radius))
			self.goalradius = nodes[0].radius;
		else
			self.goalradius = 1000;
	}
}

chain_playerseek(nodes)
{
	if ( (isdefined (nodes)) && (isdefined (nodes[0])) )
	{
		node = nodes[0];
		self chain_nodes(node);
	}
	self thread playerseek();
}

chain_nodes(firstNode)
{
	self endon ("death");
	node = firstNode;
	for (;;)
	{
		self.goalradius = node.radius;
		self setgoalnode (node);
		self waittill ("goal");
		if ( (isdefined(node.script_delay)) && (node.script_delay > 0) )
			wait (node.script_delay);
		if (!isdefined (node.target))
			break;
		node2 = getnode(node.target,"targetname");
		if (!isdefined (node2))
			break;
		node = node2;
	}
}

playerseek()
{
	self.goalradius = 800;
	self setgoalentity (level.player);
	level thread maps\_spawner::delayed_player_seek_think(self);
}

playerseek_friendly()
{
	self endon ("death");
	self.goalradius = 400;
	for (;;)
	{
		self setgoalpos (level.player.origin);
		wait 3;
	}
}

cliff_grenader(nodes, volume)
{	
	self endon ("death");
	
	self allowedStances("stand");
	self.goalradius = 8;
	
	index = randomint(nodes.size);
	grenade_node = nodes[index];
	for (i=0;i<nodes.size;i++)
	{
		index++;
		if (index >= nodes.size)
			index = 0;
		if (isdefined (nodes[index].used))
			continue;
		grenade_node = nodes[index];
	}
	assert(isdefined(grenade_node));
	
	runaway_node = undefined;
	if (self.script_noteworthy == "cliff_grenade_drop")
		runaway_node = getnode(grenade_node.target,"targetname");;
	
	grenade_node.used = true;
	self thread cliff_grenader_freeNode(grenade_node);
	self setGoalNode(grenade_node);
	self waittill ("goal");
	self thread cliff_grenader_death(grenade_node);
	
	if (self.script_noteworthy == "cliff_grenade_drop")
	{
		grenadeAmmo = 2 + randomint(2);
		for (;;)
		{
			wait (3 + randomfloat(3));
			
			//check to see if the player is in the volume the grenade will probably land in
			if (level.player isTouching (volume))
				continue;
			
			self thread cliff_grenader_notetracks();
			self animscripted( "grenade_throw", self.origin, self.angles,
				level.scr_anim["cliff_grenade_toss"][randomint(level.scr_anim["cliff_grenade_toss"].size)]);
			self waittillmatch ("grenade_throw", "end");
			
			grenadeAmmo--;
			if (grenadeAmmo <= 0)
				break;
		}
		
		assert(isdefined(runaway_node));
		self setGoalNode (runaway_node);
		self notify ("stop_special_death");
		
		self waittill ("goal");
		grenade_node.used = undefined;
		self doDamage(self.health + 1, self.origin);
	}
}

cliff_grenader_death(node)
{
	//will end if the guys runs away from his cliff node
	self endon ("stop_special_death");
	
	//make sure it has 2 script_origins for animation key points
	if (!isdefined(node.target))
		return;
	self.cliffnode = node;
	self.bounce = getent(self.cliffnode.target,"targetname");
	if (!isdefined(self.bounce))
		return;
	if (!isdefined(self.bounce.target))
		return;
	self.land = getent(self.bounce.target,"targetname");
	if (!isdefined(self.land))
		return;
	
	assert(self.bounce.classname == "script_origin");
	assert(self.land.classname == "script_origin");
	
	//health buffer so guy doesn't actually die - he needs to be alive for the fall
	self.health = 25;
	self.realHealth = self.health;
	for (;;)
	{
		self.health = 1000000;
		self waittill ("damage", amount);
		self.realHealth = (self.realHealth - amount);
		if (self.realHealth <= 0)
			break;
	}
	
	if ( (!isalive(self)) || (!isdefined(self)) )
		return;
	
	if (!isdefined(level.cliff_grenader_falls))
		level.cliff_grenader_falls = 0;
	
	qFall = false;
	//first and second guys killed will fall, rest will be random
	if (level.cliff_grenader_falls < 2)
		qFall = true;
	else
	{
		if (randomint(2) == 0)
			qFall = true;
	}
	
	if (!qFall)
	{
		self dodamage(self.health + 1, self.origin);
		return;
	}
	
	level.cliff_grenader_falls++;
	
	//special death animation sequence now
	self notify("killanimscript");
	self.fightdist = 0;
	self.maxsightdistsqrd = 0;
	self notify("killanimscript");
	self animscripts\shared::putGunInHand ("none");
	self notify("death");
	self notify("killanimscript");
	self playsound(level.scrsound["german_cliff_dive"]);
	self.cliffDeath = true;
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_01"], self.cliffnode.origin, self.cliffnode.angles, self.bounce.origin);
	self notify("killanimscript");
	playfx (level._effect["body_impact_cliff"], self.bounce.origin );
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_02"], self.bounce.origin, undefined, self.land.origin);
	self notify("killanimscript");
	playfx (level._effect["body_impact_cliff"], self.land.origin );
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_03"], self.land.origin, self.land.angles);
	self notify("killanimscript");
}

cliff_grenader_death_doAnim(animName, startOrg, startAng, end)
{
	dummy = undefined;
	if (!isdefined(startAng))
		startAng = self.angles;
	if (isdefined (end))
	{
		offset = getcycleoriginoffset( startAng, animName );
		cycleTime = getanimlength( animName );
		
		//make a dummy at the offset
		dummy = spawn("script_origin", (startOrg + offset) );
		
		//attach the ai to the dummy for the animation
		self linkto (dummy);
		
		//move the dummy to 'bounce' over cycleTime
		dummy moveto(end, cycleTime);
		
		self animscripted( "cliff_death_anim", startOrg, startAng, animName );
		self waittillmatch( "cliff_death_anim", "end" );
		
		self unlink();
		dummy delete();
	}
	else
	{
		//last animation of the guys death
		self.deathanim = animName;
		self dodamage(self.health + 1, self.origin);
	}
}

cliff_grenader_freeNode(grenade_node)
{
	self waittill ("death");
	grenade_node.used = undefined;
}

cliff_grenader_notetracks()
{
	self endon ("death");
	
	for (;;)
	{
		self waittill ("grenade_throw", notetrack);
		switch (notetrack)
		{
			case "fire":
				nadeStartOrg = self getTagOrigin("tag_weapon_right");
				throwDist = 150 + randomint(350);
				fuseTime = 2 + randomfloat(2);
				forward = anglestoforward (self.angles);
				forward = vector_scale(forward, throwDist);
				self magicgrenademanual (nadeStartOrg, forward, fuseTime );
				break;
			case "anim_gunhand = \"left\"":
				self animscripts\shared::putGunInHand ("left");
				break;
			case "anim_gunhand = \"right\"":
				self animscripts\shared::putGunInHand ("right");
				break;
			case "end":
				return;
		}
	}
}

clifftop_mg42_gunner()
{
	self.cliffnode = getnode("cliff_mg42_node","targetname");
	
	//make sure it has 2 script_origins for animation key points
	assert(isdefined(self.cliffnode.target));
	
	self.bounce = getent(self.cliffnode.target,"targetname");
	assert(isdefined(self.bounce));
	assert(isdefined(self.bounce.target));
	
	self.land = getent(self.bounce.target,"targetname");
	assert(isdefined(self.land));
	
	self.health = 1;
	self.realHealth = self.health;
	for (;;)
	{
		self.health = 1000000;
		self waittill ("damage", amount, attacker);
		if (attacker != level.player)
			continue;
		self.realHealth = (self.realHealth - amount);
		if (self.realHealth <= 0)
			break;
	}
	
	level.mg42_gunner_died = true;
	
	//sandbags fall here
	level array_thread (getentarray("cliff_mg42_sandbag","targetname"), ::clifftop_mg42_sandbagFall);
	
	exploder(14);
	
	thread clifftop_mg42_gunRemove();
	
	//guy falls
	self animscripts\shared::putGunInHand ("none");
	self notify("death");
	self notify("killanimscript");
	self.cliffDeath = true;
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_01"], self.cliffnode.origin, self.cliffnode.angles, self.bounce.origin);
	self notify("killanimscript");
	playfx (level._effect["body_impact_cliff"], self.bounce.origin );
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_02"], self.bounce.origin, undefined, self.land.origin);
	self notify("killanimscript");
	playfx (level._effect["body_impact_cliff"], self.land.origin );
	self cliff_grenader_death_doAnim(level.scr_anim["cliff_death_03"], self.land.origin, self.land.angles);
}

clifftop_mg42_sandbagFall()
{
	direction_ent = getent(self.target,"targetname");
	direction_vec = vectornormalize (direction_ent.origin - self.origin);
	direction_vec = vectorScale(direction_vec, 300);
	self moveGravity (direction_vec, 4);
	rotate_x = ( 150 + randomfloat (150) );
	rotate_y = ( 50 + randomfloat (50) );
	rotate_z = ( 50 + randomfloat (50) );
	
	if (randomint(2) == 0)
		rotate_x = ( rotate_x * -1 );
	if (randomint(2) == 0)
		rotate_y = ( rotate_y * -1 );
	if (randomint(2) == 0)
		rotate_z = ( rotate_z * -1 );
	
	self rotateVelocity ( (rotate_x, rotate_y, rotate_z), 4);
	
	wait 4;
	self delete();
}

clifftop_mg42_gunRemove()
{
	clifftop_mg42_gunner = getentarray("clifftop_mg42_gunner","script_noteworthy");
	for (i=0;i<clifftop_mg42_gunner.size;i++)
	{
		if (isSentient(clifftop_mg42_gunner[i]))
			continue;
		clifftop_mg42_gunner[i] delete();
	}
	wait 0.5;
	mg42 = getent("cliff_mg42_gun","script_noteworthy");
	mg42.origin = mg42.origin + (0,0,1000);
	mg42 hide();
}

escape_think()
{
	self endon ("death");
	self thread blindSquad_DisAllowEngage();
	self waittill ("goal");
	self delete();
}

delete_at_goal()
{
	self endon ("death");
	self waittill ("goal");
	if (isdefined(self))
		self delete();
}

blindSquad_think()
{
	squadNum = self.script_squad;
	if (!isdefined (squadNum))
		return;
	
	self endon ("allow engage");
	
	if ( (isdefined(self.deleteAtGoal)) && (self.deleteAtGoal == true) )
		self thread delete_at_goal();
	
	self blindSquad_DisAllowEngage();
	
	//wait until he gets to the goal, takes damage, or dies
	self waittill_any("goal","damage","death");
	
	//notify entire squad of the incident and allow them to engage in combat now
	level thread blindSquad_SquadEngage(squadNum);
}

blindSquad_SquadEngage(squadNum)
{
	ai = getentarray ("wait to engage","script_noteworthy");
	for (i=0;i<ai.size;i++)
	{
		if (!isSentient (ai[i]))
			continue;
		if (!isdefined(ai[i].script_squad))
			continue;
		if (ai[i].script_squad != squadNum)
			continue;
		ai[i] notify ("allow engage");
	}
}

blindSquad_DisAllowEngage()
{
	//Make it so this AI wont try to fight anyone
	self.old_fightDist = self.fightDist;
	self.fightDist = 400;
	self.old_maxdist = self.maxdist;
	self.maxdist = 380;
	
	self.old_goalradius = self.goalradius;
	self thread blindSquad_AllowEngage();
}

blindSquad_AllowEngage()
{
	self endon ("death");
	self waittill ("allow engage");
	wait randomfloat(2);
	self.fightDist = self.old_fightDist;
	self.old_fightDist = undefined;
	self.maxdist = self.old_maxdist;
	self.old_maxdist = undefined;
	
	if (isdefined(self.old_goalradius))
		self.goalradius = self.old_goalradius;
	else
		self.goalradius = 1000;
	self setgoalpos (self.origin);
}

saveprogress()
{
	assert(isdefined(self.script_noteworthy));
	thread autosavebyname(self.script_noteworthy);
}

/*
debug_makeLine(start, end, color)
{
	if (!isdefined(color))
		color = (.3,.3,.3);
	for (;;)
	{
		line(start, end, color);
		wait 0.05;
	}
}

debug_ropes()
{
	thread debug_makeLine(level.player.origin, self getTagOrigin("tag_climber01"));
}

debug_rope_positions()
{
	thread debug_makeLine(level.player.origin, self getTagOrigin("tag_origin"), (.5,.5,.5) );
}

debug_character_count()
{
	//drones
	drones = newHudElem();
	drones.alignX = "left";
	drones.alignY = "middle";
	drones.x = 10;
	drones.y = 100;
	drones.label = "drones: ";
	
	//allies
	allies = newHudElem();
	allies.alignX = "left";
	allies.alignY = "middle";
	allies.x = 10;
	allies.y = 115;
	allies.label = "allies: ";
	
	//allies
	axis = newHudElem();
	axis.alignX = "left";
	axis.alignY = "middle";
	axis.x = 10;
	axis.y = 130;
	axis.label = "axis: ";
	
	//total
	total = newHudElem();
	total.alignX = "left";
	total.alignY = "middle";
	total.x = 10;
	total.y = 145;
	total.label = "total: ";
	
	for (;;)
	{
		//drones
		count_drones = getentarray("drone","targetname").size;
		drones setValue( count_drones );
		
		//allies
		count_allies = getaiarray("allies").size;
		allies setValue( count_allies );
		
		//axis
		count_axis = getaiarray("axis").size;
		axis setValue( count_axis );
		
		//total
		total setValue ( count_drones + count_allies + count_axis );
		
		wait 0.25;
	}
}
*/
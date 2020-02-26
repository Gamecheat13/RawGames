//////////////////////////////////////////////////////////
//
// khe_sanh_event1.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include maps\_flyover_audio;
#include maps\_music;
#include maps\_scene;

#using_animtree("generic_human");
main()
{

	// Spawn funcs
	array_thread(GetEntArray("trench_runners", "targetname"), ::add_spawn_function, ::e1c_trench_runners_think);
	array_thread(GetEntArray("huey_troops_tn", "targetname"), ::add_spawn_function, ::e1_huey_troops_think);

	// init flags
	event1_init_flags();

	// spin off the vignettes threads
	level thread event1_vignettes();
	level thread event1c_vignettes();
	level thread event1_setup_hueys();
	level thread event1_start_cobra();
	level thread event1_start_phantoms();
//	level thread event1_runway_phantoms();
	level thread event1_apc_column();
	level thread event1_start_seaknights();
	level thread event1_start_air_escort();
//	level thread event1_start_runway_armada();
	level thread event1_jeep_crash_avoid_guys();
	level thread event1_hueys_onstation();
	level thread event1c_mortarstrikes();
	level thread event1c_runway_mortars();
	level thread maps\khe_sanh_amb::play_intro_music();
	
	//turn on all amb effects for event 1
	//Exploder(10);

	//moved to _introscreen.gsc
	//level thread maps\_introscreen::introscreen_delay( "Khe Sanh Combat Base", "Quang Tri Province", "Republic of Vietnam", "March 1, 1968", "Sergeant Mason", 2, 2, 3 );

	// start the intro
	event1_intro();

	// jeep crash
	event1_jeep_crash();

	// trench walk
	event1c_trench_walk();
	
}

/***************************************************************/
//	event1_init_flags
/***************************************************************/
event1_init_flags()
{
	flag_init("jeep_crash_start");
	flag_init("jeep_crash_swerve");
	flag_init("jeep_crash_fail");
	flag_init("jeep_crash_jump");
	flag_init("jeep_crash_done");
	flag_init("e1c_done");
	flag_init("stop_jeepcrash_spawn");
	//flag_init("e1_pause_sky_metal");
	flag_init("trench_walk_start");
	flag_init("player_idle");
}

/***************************************************************/
//	event1_intro
/***************************************************************/
#using_animtree( "generic_human" );
event1_intro()
{
/#
	//level thread show_time(0.05);
#/
	blown_heads = GetEntArray("head_blown_models", "targetname");
	clean_heads = GetEntArray("clean_head_models", "targetname");	

	//corpses on the ground
	if(is_gib_restricted_build())
	{
		array_delete(blown_heads);
	}
	else
	{
		array_delete(clean_heads);
	}

	// spawn the player body
	level.player.body = spawn_anim_model("player_body", level.player.origin, level.player.angles);
	level.player.body.animname = "player_body";
	level.player.body SetAnim( level.scr_anim["player_body"]["intro"], 1, 0, 0 );
	level.player PlayerLinkTo(level.player.body, "tag_player", 1, 0, 0, 0, 0);

	// get the alignment node
	align_node = GetEnt("e1_anim_align", "targetname");
	
	// setup the player
	level.player DisableWeapons();
	level.player SetClientDvar("r_enablePlayerShadow", 0); 
	level.player SetClientDvar("compass", 0);
	level.player SetClientDvar("cg_drawfriendlynames", 0);

	// wait to get out to give control
	level thread event1_give_look_control();

	// spawn the driver
	level.squad["driver"] = spawn_fake_character(align_node.origin, (0,0,0), "driver"); //simple_spawn_single("driver");
	level.squad["driver"] UseAnimTree(#animtree);
	level.squad["driver"].animname = "driver";
//	level.squad["driver"] make_hero();

	// spawn the hero huey
	hero_huey = spawn_anim_model("hero_huey", align_node.origin, align_node.angles);
	hero_huey.targetname = "hero_huey";
	hero_huey Attach("t5_veh_helo_huey_att_interior", "tag_body");
	hero_huey Attach("t5_veh_helo_huey_att_decal_usmc_gunship", "tag_body");
	hero_huey Attach("t5_veh_helo_huey_att_usmc_m60", "tag_body");
	hero_huey Attach("t5_veh_helo_huey_att_rockets_usmc", "tag_body");
	hero_huey SetLocalWindSource( true );

	//hero_huey maps\_huey::main();	

	// spawn and setup the hero huey pilots
	hero_huey_pilot = simple_spawn_single("hero_huey_pilot");
	hero_huey_copilot = simple_spawn_single("hero_huey_copilot");
	
	//make crew both true means make a gunner only.
	//"tag_gunner1"
	//hero_huey_gunner = spawn_fake_character(hero_huey.origin, (0,0,0), "huey_pilot_2");
	//hero_huey_gunner.animname = "gunner_pilot_1";
	//hero_huey_gunner LinkTo(hero_huey, "tag_gunner1");
	//hero_huey_gunner UseAnimTree(#animtree);
	//hero_huey_gunner thread anim_loop(hero_huey_gunner, "huey_idle");

	// Link and play anims
	hero_huey_pilot LinkTo(hero_huey, "tag_driver");
	hero_huey_copilot LinkTo(hero_huey, "tag_passenger");

	hero_huey thread anim_loop(hero_huey_pilot, "idle", "tag_driver");
	hero_huey thread anim_loop(hero_huey_copilot, "idle", "tag_passenger");

	//level thread run_scene("e1_huey_pilot");

	// Play FX
	PlayFXOnTag(level._effect["huey_rotor"], hero_huey, "main_rotor_jnt");
	PlayFXOnTag(level._effect["huey_tail_rotor"], hero_huey, "tail_rotor_jnt");

	// play glare effect
	hero_huey thread hero_huey_glare();

	// spawn the hero jeep
	level.hero_jeep = spawn_anim_model("hero_jeep", align_node.origin, align_node.angles);

	level thread exit_tent_dust();

	//TEMP: FX for chopper landing. Need to do this in notetrack
	level thread hero_huey_dust();

	// start sky metal
	level thread event1_sky_metal();

	// OAA: Spin this thread before we start the intro...the thread
	// waits till the jeep ride starts before waiting like before
	level thread play_plane_land();

	//camera shake just before jeep starts to hide some pop
	level.player.body thread shake_jeep_ride();

	// build up an array of actors
	actor_array = [];
	actor_array = array_add(actor_array, level.player.body);
	//actor_array = array_add(actor_array, level.squad["woods"]);
	//actor_array = array_add(actor_array, level.squad["hudson"]);
	actor_array = array_add(actor_array, level.squad["driver"]);
	actor_array = array_add(actor_array, hero_huey);
	actor_array = array_add(actor_array, level.hero_jeep);


	flag_wait("starting final intro screen fadeout");

	// fire off the tent
	level notify("tent_open_start");

	
	// fire off the intro anim
	level thread run_scene("e1_jeep_passenger");
	align_node anim_single_aligned(actor_array, "intro");

//	level.player waittillmatch("single anim", "start_c130");

	// set the crash flag
	flag_set("jeep_crash_start");

	// delete the script models
	hero_huey Delete();
	hero_huey_pilot Delete();
	hero_huey_copilot Delete();

	delete_scene("e1_jeep_passenger");
}

//self is level.player.body
shake_jeep_ride()
{
	//ugh
	wait 69.5;
	level.player StartCameraTween(0.2);
	Earthquake(0.25, 0.7, level.player.body.origin, 100, level.player);
	level.player PlayRumbleOnEntity("damage_heavy");

	wait 0.2;
	level.player PlayRumbleOnEntity("damage_light");

	wait 0.2;
	level.player PlayRumbleOnEntity("damage_heavy");

	wait 0.2;
	Earthquake(0.25, 0.7, level.player.body.origin, 100, level.player);
	level.player PlayRumbleOnEntity("damage_heavy");

	wait 0.2;
	level.player PlayRumbleOnEntity("damage_light");

	wait 0.2;
	level.player PlayRumbleOnEntity("damage_heavy");

	//road dip
	wait 1.5;
	Earthquake(0.25, 0.5, level.player.body.origin, 100, level.player);
	level.player PlayRumbleOnEntity("damage_heavy");
	
	wait 0.2;
	level.player PlayRumbleOnEntity("damage_heavy");
}

event1_sky_metal()
{
	// This is what happens when you have 8 days to E3...FTW!!

	huey_models = [];
	huey_models["side"] = "t5_veh_helo_huey_usmc";
	huey_models["interior"] = "t5_veh_helo_huey_att_interior";

	level thread sky_metal("e1_sky_metal_1", huey_models, 8, (-2000, -4200, 0), (2000, 1400, 2000), 300, 400, 1000, 0, "sky_0");
	level thread sky_metal("e1_sky_metal_2", huey_models, 5, (-1400, -1400, 0), (1400, 1400, 2000), 400, 450, 1000, 1, "sky_1");
	level thread sky_metal("e1_sky_metal_3", huey_models, 5, (-1400, -1400, -1000), (1400, 1400, 1000), 350, 375, 1000, 2, "sky_2");
	level thread sky_metal("e1_sky_metal_6", huey_models, 7, (-4000, -2000, -1000), (-2000, 2000, 1000), 350, 400, 1200, 3, "sky_3");

	flag_wait("jeep_ride_start");

	//sky_metal(node, models, count, min_offset, max_offset, min_vel, max_vel, separation, group, ender)
	//original max offset: (1400, 2000, 1000)
	level thread sky_metal("e1_sky_metal_5", huey_models, 10, (-1400, -2000, -1000), (1800, 3000, 1000), 450, 500, 775, 4, "sky_4");

	level notify("sky_0");
	array_delete(level.metal[0]);

	level notify("sky_1");
	array_delete(level.metal[1]);

	level notify("sky_2");
	array_delete(level.metal[2]);

//	flag_wait("jeep_crash_start");
	trigger_wait("e1_spawn_c130");

	level notify("sky_3");
	array_delete(level.metal[3]);

	level thread sky_metal("e1_sky_metal_7", huey_models, 8, (-2000, -4200, 0), (2000, 1400, 2000), 300, 400, 1000, 5, "sky_5");

	flag_wait("trench_walk_start");

	level notify("sky_4");
	array_delete(level.metal[4]);

	level notify("sky_5");
	array_delete(level.metal[5]);

	level thread sky_metal("e1_sky_metal_8", huey_models, 20, (-4000, -4200, 0), (4000, 1400, 4000), 300, 400, 2000, 6, "sky_6");

	wait(30);

	level notify("sky_6");
	
	if(IsDefined(level.metal) && IsDefined(level.metal[6]))
	{
		array_delete(level.metal[6]);
		level.metal[6] = array_removeUndefined( level.metal[6] );
		level.metal[6] = undefined;
		level.metal = array_removeUndefined( level.metal );
	}
}

event1_give_look_control()
{
	flag_wait("e1_player_exit_tent");

	// starts a timer to figure out when to have cobras fly over
//	level thread show_time(0.05);

	wait 1.75;

	level.player UnLink();
	level.player PlayerLinkTo(level.player.body, "tag_player", 1, 25, 45, 25, 25);
}

//TEMP: FX for chopper landing. Need to do this in notetrack
hero_huey_dust()
{
	wait(25.5);
	playsoundatposition ("veh_huey_land", (0,0,0));
	maps\khe_sanh_fx::event1_hero_huey_dust();
	level thread play_jeep_ride_hack();
}

exit_tent_dust()
{
	wait(21);
	//Exploder(100);
}

hero_huey_glare()
{
	flag_wait("e1_player_exit_tent");

	wait(5.0);

	PlayFXOnTag(level._effect["fx_ks_huey_glare"], self, "tag_origin");
}

play_jeep_ride_hack()
{
	wait (18.0);
	playsoundatposition ("veh_jeep_drive_off", (0,0,0));
	
}

play_plane_land()
{
//	flag_wait("jeep_ride_start");

	trigger = GetEnt("e1_spawn_c130", "targetname");
	trigger waittill("trigger");

	level thread event1_redshirt_runway_vo();

	// save before the crash
	//autosave_by_name("e1_crash");

	wait(0.05);

	c130_landing = GetEnt("e1_c130_land", "targetname");
	
	plane = getent("e1_c130_land", "targetname");
	
	while(!IsDefined (plane))
	{
		plane = getent("e1_c130_land", "targetname");
		wait(0.1);
	}
	
	plane playsound ("veh_plane_land");
	
	// play fire effect
	PlayFXOnTag(level._effect["fx_ks_c130_engine_fire"], c130_landing, "tag_engine2");

	flag_wait("trench_walk_start");

	plane Delete();
}
/***************************************************************/
//	event1_jeep_crash
/***************************************************************/
event1_jeep_crash()
{
	// get the alignment node
	align_node = GetEnt("e1_anim_align", "targetname");

	level thread manage_hudson_blocker();

	// actor setup
	level.player Unlink();
	level.player PlayerLinkToAbsolute(level.player.body, "tag_player");

	// Spawn the c130
	level.c130_crash = spawn_anim_model("c130_crash", align_node.origin);
	level.c130_crash_parts = spawn_anim_model("c130_crash_parts", align_node.origin);
	level.c130_crash playsound ("evt_c130_crash_F");
	
	//Tuey for Audio Snapshot
	clientNotify("crsh");
	level thread set_audio_snapshot_delay();
	
//	playsoundatposition ("evt_jeep_swerve", (0,0,0));
	setmusicstate ("CRASH");

	// spin off swerve/jump out threads
	level thread event1_jeep_crash_swerve();
	level thread event1c_crash_ambient_marines();
//	level thread event1_jeep_crash_jump_qte();
	level thread event1_jeep_crash_jump();

	// spin the woods thread...will start thinking after this anim
	level.squad["woods"] thread event1_jeep_crash_woods(align_node);

	// spin off fx thread
	level thread event1_jeep_crash_fx();
  
	// lose the glasses DOOSH!
	level.squad["hudson"] Detach("c_usa_jungmar_hudson_shades");

	// start the animation
	level.crash_actors = [];
	level.crash_actors = array_add(level.crash_actors, level.player.body);
	//level.crash_actors = array_add(level.crash_actors, level.squad["woods"]);
	//level.crash_actors = array_add(level.crash_actors, level.squad["hudson"]);
	level.crash_actors = array_add(level.crash_actors, level.squad["driver"]);
	level.crash_actors = array_add(level.crash_actors, level.hero_jeep);
	level.crash_actors = array_add(level.crash_actors, level.c130_crash);
	level.crash_actors = array_add(level.crash_actors, level.c130_crash_parts);

	level.crash_actors = array_merge(level.crash_actors, level.avoid_actors);

	// fire off the intro anim

	level thread run_scene("e1_jeep_crash");
	align_node anim_single_aligned(level.crash_actors, "crash");

	// Set off exploder
	//Exploder(130);

	// delete the avoid jeep
	level.avoid_jeep delete();
	level.c130_crash delete();
	level.c130_crash_parts delete();
	delete_scene("e1_jeep_crash");
//	// Test game over
//	if (!IsGodMode(level.player))
//	{
//		if (!flag("jeep_crash_jump"))
//		{
//			gameover_screen();
//			MissionFailed();
//		}
//	}
//	else
//	{
//		level.player UnLink();
//		level.player EnableWeapons();
//	}
}
set_audio_snapshot_delay()
{
	wait(10);
	//Tuey for Audio Snapshot
	clientNotify("crsh_over");	
	
	
}

//split this out so spawn throttling does not affect woods during jeep crash
event1_jeep_crash_avoid_guys()
{
	level.player endon("death");

	// get the alignment node
	align_node = GetEnt("e1_anim_align", "targetname");

	trigger_wait("trig_runway_mortar");
	
	// spawn avoiders
	goals = [];
	goals[0] = GetStruct("node_marine_trench_goal_0", "targetname");
	goals[1] = GetStruct("node_marine_trench_goal_1", "targetname");
	goals[2] = GetStruct("node_marine_trench_goal_2", "targetname");
	goals[3] = GetStruct("node_marine_trench_goal_3", "targetname");

	array_thread(GetEntArray("e1_jeep_avoider", "targetname"), ::add_spawn_function, ::set_to_goal, goals);

	level.avoid_jeep = spawn_anim_model("hero_jeep_2", align_node.origin);
	avoid_guys = simple_spawn("e1_jeep_avoider");

	// combine
	level.avoid_actors = avoid_guys;
	level.avoid_actors = array_add(level.avoid_actors, level.avoid_jeep);
}

event1_jeep_crash_fx()
{
	level.c130_crash endon("death");

	// Tags...
	// tag_guy1 == tail
	// tag_passenger2 == fuselage
	// tag_guy5 == nose
	// tag_guy0 == wing sparks
	// tag_guy8 == wing flame/smoke
	// tag_passenger == propeller
	// prop_jnt_04 == left propeller

	wait(0.5);

	// Call exploder
	//Exploder(120);

	PlayFXOnTag(level._effect["fx_ks_c130_wing_fire"], level.c130_crash, "tag_broken_wing");
	PlayFXOnTag(level._effect["fx_ks_c130_crash_fuselage"], level.c130_crash, "tag_guy5");
	PlayFXOnTag(level._effect["fx_ks_c130_crash_fuselage"], level.c130_crash, "tag_passenger2");
//	PlayFXOnTag(level._effect["fx_ks_c130_engine_fire2"], level.c130_crash, "prop_jnt_04");
	PlayFXOnTag(level._effect["fx_ks_c130_engine_fire2"], level.c130_crash, "tag_guy2");	

	wait(1.0);

	while (!flag("jeep_crash_jump"))
	{
		PlayFXOnTag(level._effect["fx_ks_c130_dirt_trail"], level.c130_crash, "tag_guy1");
		wait(0.05);
	}
}

event1_jeep_crash_swerve()
{
	timescale = 1.0;
	timescale_vel = -1.0;
	swerved = false;

	wait(1.5);

	while (timescale > 0.35)
	{
		timescale += timescale_vel * 0.05;
		SetTimeScale(timescale);
		wait(0.05);
	}

	level notify("set_crash_dof");

	time_window = 1.0;
	while (time_window > 0.0 && !swerved)
	{
		swerved = true;

		// set the flag
		flag_set("jeep_crash_swerve");

		time_window -= 0.05;
		wait(0.05);
	}

	//this wait has to be here to preserve timing when the button is pressed. In old logic once "jeep_crash_swerve" is set, it forces this wait
	wait 1;

	while (timescale < 1.0)
	{
		timescale += 1.0 * 0.05;
		SetTimeScale(timescale);
		wait(0.05);
	}
}

event1_jeep_crash_jump_qte()
{
	// end when the note track is hit
	level endon("player_jumped_out");

	// wait till after the serve
	flag_wait("jeep_crash_swerve");

	// wait here...todo: make a notetrack
	wait(2.0);

	// TODO: Hud message
	screen_message_create("Press A to Jump Out");

	// Count down the window
	time_window = 1.0;
	while (time_window > 0.0)
	{
		// Press A to jump
		if (level.player JumpButtonPressed())
		{
			// flag set
			flag_set("jeep_crash_jump");

			// delete prompt
			screen_message_delete();
		}

		time_window -= 0.05;
		wait(0.05);
	}

	screen_message_delete();
}

event1_jeep_crash_jump()
{
	
	level.sound_ent_walla = spawn ("script_origin", (-5848, 88, 96));
	// wait till we hit the notetrack
	level waittill("player_jumped_out");
	level.sound_ent_walla  playloopsound ("amb_walla_us_mortar_strike");
	
	//playsoundatposition ("amb_walla_us_mortar_strike", (-5848, 88, 96 ));

	// set this here...we are removing the QTE
	flag_set("jeep_crash_jump");

//	level thread show_time(0.05);

	// if the flag was set play the animation
//	if (flag("jeep_crash_jump"))
//	{
		align_node = GetEnt("e1_anim_align", "targetname");

		actors = [];
		actors[0] = level.player.body;
		actors[1] = level.squad["hudson"];

		align_node anim_single_aligned(actors, "crash_jump");

		// Delete the hero jeep and driver
		level.hero_jeep delete();
		level.squad["driver"] delete();

		// jeep crash done
		flag_set("jeep_crash_done");

		// save
		autosave_by_name("crash_done");
//	}
//	else
//	{
//		screen_message_delete();
//	}
}

//self is player
flashback_vo()
{
	self.animname = "mason";
	self anim_single(self, "flashback_01"); //Hudson was down and Khe Sanh was under siege. But like with Weaver, you risked your life to save him.
	self anim_single(self, "flashback_02"); //Hudson was a fucking ice cube, but that's why I liked the bastard.
	self anim_single(self, "flashback_03");	//Khe Sanh was a mess, Mason. You should have left them to it. That wasn't your objective.
	self anim_single(self, "flashback_04"); //You obviously didn't know Woods. He knew they needed our help. No decision to make.
}

event1_distant_walla()
{
	ent_1 = spawn ("script_origin", (-4424, -2384, 96));
	ent_2 = spawn ("script_origin", (-5176, -2512, 192));
	
	ent_1 playloopsound ("amb_walla_distant_loop_1");
	ent_2 playloopsound ("amb_walla_distant_loop_2");
	
}
event1_jeep_crash_woods(align_node)	// self == woods
{
	level waittill("player_jumped_out");

	// play the jump out animation
	align_node anim_single_aligned(self, "crash_jump");

	// start thinking after animation ends
	self thread event1c_woods_think();
}

/***************************************************************/
//	event1_vignettes
/***************************************************************/
event1_vignettes()
{
	flag_wait("starting final intro screen fadeout");
	
	level thread event1_barechest_guy_vignette();
	level thread event1_ready_soldiers_vignette();
	level thread event1_medic_vignette();
	level thread event1_bodybag_vignette();
	level thread event1_helping_soldier_vignette();
	level thread event1_civilians_vignette();
	level thread event1_towers_vignette();
	level thread event1_support_troops_rightside();
	level thread event1_support_choppers();
}

event1_medic_vignette()
{
	flag_wait("e1_player_exit_tent");

	wait(25);
	
	level thread run_scene("e1_medic");

	wait(0.05);
	soldier = getent("medic_soldier_01_ai", "targetname");
	soldier Attach("anim_jun_stretcher", "tag_inhand");

	flag_wait("jeep_ride_start");
	soldier delete();
	soldier = getent("medic_soldier_02_ai", "targetname");
	soldier delete();
	soldier = getent("medic_soldier_03_ai", "targetname");
	soldier delete();
	// delete
	//array_delete(level.vignette_group["medic"]);

	level.scene_sys waittill("e1_medic_done");
	delete_scene("e1_medic");
}

event1_civilians_vignette()
{
	flag_wait("jeep_ride_start");

	run_scene("e1_civ");
	//// Civilians
	//civilian_names = [];
	//civilian_names[0] = "civilian_male_01";
	//civilian_names[1] = "civilian_male_02";
	//civilian_names[2] = "civilian_male_03";

	//level thread do_vignette("e1_civilians_align", civilian_names, "intro", true, 1, "civs", false, true);

	// wait till crash start
	flag_wait("jeep_crash_start");

	civ = getent("civilian_male_01_ai", "targetname");
	civ delete();
	civ = getent("civilian_male_02_ai", "targetname");
	civ delete();
	civ = getent("civilian_male_03_ai", "targetname");
	civ delete();

	// delete
	//array_delete(level.vignette_group["civs"]);
	delete_scene("e1_civ");
}

event1_barechest_guy_vignette()
{
	// wait till jeep ride
	flag_wait("e1_player_exit_tent");

	wait(35);

	// barechest guy
	//align_node1 = GetStruct("e1_barechest_align", "targetname");

	//barechest_guy1 = spawn_fake_character(align_node1.origin, align_node1.angles, "topless");
	//barechest_guy1.animname = "barechest_guy";
	//barechest_guy1.targetname = "barechest_guy";
	////barechest_guy1 UseAnimTree(#animtree);
	//barechest_guy1 Attach("p_glo_shovel01", "tag_inhand");

	////align_node1 thread anim_loop_aligned(barechest_guy1, "intro");

	//wait(0.25);

	//// barechest guy 2
	//align_node2 = GetStruct("e1_barechest_align_2", "targetname");

	//barechest_guy2 = spawn_fake_character(align_node2.origin, align_node2.angles, "topless");
	//barechest_guy2.animname = "barechest_guy_2";
	//barechest_guy2.targetname = "barechest_guy2";
	////barechest_guy2 UseAnimTree(#animtree);
	//barechest_guy2 Attach("p_glo_shovel01", "tag_inhand");

	//align_node2 thread anim_loop_aligned(barechest_guy2, "intro");

	// wait to be down the street
	level thread run_scene("e1_topless");

	m_guy1 =  get_model_or_models_from_scene("e1_topless", "barechest_guy");

	m_guy1 attach("p_glo_shovel01", "tag_inhand");

	wait(0.25);
	level thread run_scene("e1_topless2");

	m_guy2 =  get_model_or_models_from_scene("e1_topless2", "barechest_guy2");

	m_guy2 attach("p_glo_shovel01", "tag_inhand");


	flag_wait("e1_vignette_transition");

	// delete
	m_guy1 delete();
	m_guy2 delete();
	
	level.scene_sys waittill("e1_topless_done");
	delete_scene("e1_topless");
}

event1_support_choppers()
{
	flag_wait("e1_player_exit_tent");

	wait(22);

	support_chopper_01 = GetEnt("support_chopper_01", "targetname");
	path_start = GetVehicleNode("e1b_support_chopper_1_landing", "targetname");
	support_chopper_01 go_path(path_start);

	support_chopper_01 waittill("reached_end_node");

	// chinook support troops
	//support_troop_names = [];
	//support_troop_names[0] = "support_troop_01";
	//support_troop_names[1] = "support_troop_02";
	//support_troop_names[2] = "support_troop_03";
	//support_troop_names[3] = "support_troop_04";
	//support_troop_names[4] = "support_troop_05";
	//support_troop_names[5] = "support_troop_sgt";

	//level thread event1_support_chopper_vignette("support_chopper_01", support_troop_names);
	support_chopper = GetEnt("support_chopper_01", "targetname");
	support_chopper UseAnimTree(level.scr_animtree["support_chopper"]);
	support_chopper.animname = "support_chopper";
	support_chopper thread anim_loop(support_chopper, "intro");

	//level thread support_chopper1_deleter();

	support_chopper_01 thread event1_support_chopper_takeoff();

	wait(0.25);

	//for (i = 0; i < level.vignette_group["support_chopper_01"].size; i++)
	//{
	//	random_sprint = RandomIntRange(1, 9);
	//	level.vignette_group["support_chopper_01"][i] set_generic_run_anim("sprint_" + random_sprint);
	//	//level.vignette_group["support_chopper_01"][i] thread event1_support_chopper_01_guys_think();
	//}

	flag_wait("jeep_ride_start");

	support_chopper_2 = GetEnt("support_chopper_02", "targetname");
	support_chopper_2 waittill("reached_end_node");
	support_chopper_2 delete();

	//level thread event1_support_chopper_vignette("support_chopper_02", support_troop_names);
	//level thread support_chopper2_go();
	//level thread support_chopper2_deleter();
}

event1_support_chopper_01_guys_think()
{
	self endon("death");
	self waittill("goal");
	self delete();
}

event1_support_chopper_vignette(chopper, names)
{
	// get the chopper
	support_chopper = GetEnt(chopper, "targetname");
	support_chopper UseAnimTree(level.scr_animtree["support_chopper"]);
	support_chopper.animname = "support_chopper";
	support_chopper thread anim_loop(support_chopper, "intro");

	// do the vignette
	//do_vignette(support_chopper, names, "intro", false, 2, chopper);
	run_scene("e1_chopper1");

	delete_scene("e1_chopper1");
}

support_chopper1_deleter()
{
	flag_wait("jeep_ride_start");

	wait(2.5);

	// delete group
	array_delete(level.vignette_group["support_chopper_01"]);

	// delete chopper
	support_chopper = GetEnt("support_chopper_01", "targetname");
	support_chopper delete();
}

support_chopper2_deleter()
{
	flag_wait("jeep_crash_start");

	// delete group
	array_delete(level.vignette_group["support_chopper_02"]);

	// delete chopper
	support_chopper = GetEnt("support_chopper_02", "targetname");
	support_chopper delete();
}

support_chopper2_go()
{
	flag_wait("e1_vignette_transition");

	wait(0.05);

	for(i = 0; i < level.vignette_group["support_chopper_02"].size; i++)
	{
		goal_node_name = "support_goal_" + (i + 1);
		goal_node = GetNode(goal_node_name, "targetname");
	
		random_sprint = RandomIntRange(1, 9);

		level.vignette_group["support_chopper_02"][i] set_generic_run_anim("sprint_" + random_sprint);
		level.vignette_group["support_chopper_02"][i] SetGoalNode(goal_node);
	}
}

event1_support_chopper_takeoff()
{
	self endon("death");

	wait(25);

	self.goalradius = 64;
	self SetSpeed(8);

	start_struct = GetStruct("support_chopper_1_takeoff", "targetname");
	start_look_ent = spawn("script_origin", start_struct.origin + AnglesToForward(start_struct.angles) * 500.0);

	end_struct = GetStruct(start_struct.target, "targetname");
	end_look_ent = spawn("script_origin", end_struct.origin + AnglesToForward(end_struct.angles) * 500.0);

	self SetVehGoalPos(start_struct.origin);
	self SetLookAtEnt(start_look_ent);
	self waittill("goal");

	self SetVehGoalPos(end_struct.origin);
	self SetLookAtEnt(end_look_ent);
	self waittill("goal");

	self delete();
}

event1_helping_soldier_vignette()
{
	flag_wait("e1_player_exit_tent");

	//helping_soldier = [];
	//helping_soldier[0] = GetEnt("helping_soldier_01", "targetname");
	//helping_soldier[1]	= GetEnt("helping_soldier_02", "targetname");
	//helping_soldier[0] add_spawn_function(::event1_freeze_helping_soldier_01);
	//helping_soldier[1] add_spawn_function(::event1_freeze_helping_soldier_02);

	//// soldiers helping wounded
	//helping_soldier_names = [];
	//helping_soldier_names[0] = "helping_soldier_01";
	//helping_soldier_names[1] = "helping_soldier_02";
	//do_vignette("e1_helping_soldiers_align", helping_soldier_names, "intro", false, 1, "helping", true);
	
	flag_wait("jeep_ride_start");
	run_scene("e1_help_soldier");

	delete_scene("e1_help_soldier");
	//level notify("unfreeze_helping");
}

#using_animtree("generic_human");
event1_freeze_helping_soldier_01()
{
	self endon("death");
	wait 0.5;
	self SetAnim(%ch_khe_E1B_soldiershelpwounded_guy01, 1.0, 0.0, 0.0);
	level waittill("unfreeze_helping");
	self SetAnim(%ch_khe_E1B_soldiershelpwounded_guy01, 1.0, 0.0, 1.0);

	flag_wait("jeep_crash_start");
	self Delete();
}

#using_animtree("generic_human");
event1_freeze_helping_soldier_02()
{
	self endon("death");
	wait 0.5;
	self SetAnim(%ch_khe_E1B_soldiershelpwounded_guy02, 1.0, 0.0, 0.0);
	level waittill("unfreeze_helping");
	self SetAnim(%ch_khe_E1B_soldiershelpwounded_guy02, 1.0, 0.0, 1.0);

	flag_wait("jeep_crash_start");
	self Delete();
}

#using_animtree( "khesanh" );
event1_bodybag_vignette_props( align_node )
{
	bodybags = [];
	for (i = 0; i < 3; i++)
	{
		bodybags[i] = spawn("script_model", align_node.origin);
		bodybags[i] SetModel("anim_jun_bodybag");
		bodybags[i].animname = "body_bag0" + (i + 1);
		bodybags[i] UseAnimTree(level.scr_animtree["body_bags"]);
	}
	
	tarp = spawn("script_model", align_node.origin);
	tarp SetModel("fxanim_khesanh_deadbody_tarp_mod");
	tarp.animname = "tarp";
	tarp UseAnimTree(level.scr_animtree["body_bags"]);
	
	align_node thread anim_loop_aligned(bodybags, "intro");
	align_node thread anim_loop_aligned(tarp, "intro");
	
	// wait for delete
	flag_wait("e1_vignette_transition");

	// delete
	array_delete(bodybags);
	tarp Delete();
}

#using_animtree( "generic_human" );
event1_bodybag_vignette_humans( align_node )
{
	// bodybag guys
	//bodybag_guys = [];

	chaplain = spawn_fake_character(align_node.origin, align_node.angles, "chaplain");
	chaplain.script_animname = "bodybags_chaplan";
	//bodybag_guys[0] UseAnimTree(#animtree);

	//bodybag_guys[1] = spawn_fake_character(align_node.origin, align_node.angles, "topless");
	//bodybag_guys[1].animname = "bodybags_guy01";
	//bodybag_guys[1] UseAnimTree(#animtree);

	//bodybag_guys[2] = spawn_fake_character(align_node.origin, align_node.angles, "topless");
	//bodybag_guys[2].animname = "bodybags_guy02";
	//bodybag_guys[2] UseAnimTree(#animtree);
	//
	//align_node thread anim_loop_aligned(bodybag_guys, "intro");
	
	// wait for delete

	//chaplain character\c_usa_jungmar_chaplain::main();
	//chaplain.script_animname = "bodybags_chaplan";

	run_scene("e1_bodybag_soldier");
	flag_wait("e1_vignette_transition");

	delete_scene("e1_bodybag_soldier");

	// delete
	//array_delete(bodybag_guys);
}

event1_bodybag_vignette()
{
//	flag_wait("e1_player_exit_tent");
//
//	wait(3.0);

	align_node = GetStruct("e1_bodybags_align", "targetname");

	level thread event1_bodybag_vignette_props( align_node );
	level thread event1_bodybag_vignette_humans( align_node );
}

event1_ready_soldiers_vignette()
{
	flag_wait("e1_player_exit_tent");

	wait(43.0);

	// battle ready soliders
	//soldier_names = [];
	//soldier_names[0] = "ready_soldier_01";
	//soldier_names[1] = "ready_soldier_02";

	////level thread do_vignette("e1_ready_soldiers_align", soldier_names, "intro", true, 1, "ready");
	
	run_scene("e1_ready_soldier");


	flag_wait("e1_vignette_transition");

	delete_scene("e1_ready_soldier");
	//array_delete(level.vignette_group["ready"]);
}

event1_towers_vignette()
{
	flag_wait("e1_player_exit_tent");

	wait(30.0);

	//// Tower 1 guys
	//tower01_names = [];
	//tower01_names[0] = "tower01_guy01";
	//tower01_names[1] = "tower01_guy02";

	//level thread do_vignette("e1_tower01_align", tower01_names, "intro", true, 1, "tower_1", false, true);

	//// Tower 2 guys
	//tower02_names = [];
	//tower02_names[0] = "tower02_guy01";
	//tower02_names[1] = "tower02_guy02";

	//level thread do_vignette("e1_tower02_align", tower02_names, "intro", true, 1, "tower_2", false, true);

	level thread run_scene("e1_tower_1_soldier");
	level thread run_scene("e1_tower_2_soldier");

	flag_wait("jeep_crash_start");

	//array_delete(level.vignette_group["tower_1"]);
	//array_delete(level.vignette_group["tower_2"]);

	delete_scene("e1_tower_1_soldier");
	delete_scene("e1_tower_2_soldier");
}

event1_support_troops_rightside()
{
	flag_wait("e1_vignette_transition");

	spawner = GetEnt("support_troops_rightside", "targetname");
	actors = [];
	for (i = 0; i < 6; i++)
	{
		actors[i] = simple_spawn_single("support_troops_rightside");

		goal_name = "support_goal_" + (i + 10);
		goal_node = GetNode(goal_name, "targetname");

		random_sprint = RandomIntRange(1, 9);
		actors[i] set_generic_run_anim("sprint_" + random_sprint);
		actors[i] SetGoalNode(goal_node);
	}

	flag_wait("jeep_crash_start");

	//TODO: why would this needed if nothing else deletes anything in this array?
	actors = array_removeUndefined( actors );
	array_delete(actors);
}

//self is ai
event1_redshirt_runway_vo()
{
	runway_org = getent("runway_vo", "targetname");

	runway_vo = spawn("script_model", runway_org.origin);
	runway_vo SetModel("tag_origin");
	runway_vo.animname = "runway_redshirt";

	trigger_wait("e1_spawn_c130");

	runway_vo anim_single(runway_vo, "runway_0");
	runway_vo anim_single(runway_vo, "runway_1");

	runway_vo Delete();
	runway_org Delete();
}

//self is level: starts the sequence of hueys at the base camp
event1_setup_hueys()
{
	//flag_wait("e1_player_exit_tent");

	//huey_squadron = [];
	//huey_squadron_path = [];

	//for(i = 0; i < 10; i++)
	//{
	//	huey_squadron_path[i] = GetVehicleNode("huey_path_" + i, "targetname");
	//	wait 0.25;
	//	huey_squadron[i] = SpawnVehicle("t5_veh_helo_huey_usmc", "event1_huey_0", "heli_huey_usmc_khesanh", huey_squadron_path[i].origin, huey_squadron_path[i].angles );
	//}

	//for(i = 0; i < 10; i++)
	//{
	//	if(IsDefined(huey_squadron_path[i].script_string) && huey_squadron_path[i].script_string == "takeoff")
	//	{	
	//		//if chopper is on a path that takes off wait. all other choppers are inbound to land
	//		huey_squadron[i] thread event1_delay_huey(huey_squadron_path[i]);
	//	}
	//	else
	//	{
	//		huey_squadron[i] thread go_path(huey_squadron_path[i]);
	//	}
	//}

	// wait till tent exit
	flag_wait("e1_player_exit_tent");

	// trigger hueys
	trigger_use("e1_intro_hueys");

	wait 0.05;

	huey_squadron = GetEntArray("huey_squadron", "script_noteworthy");
	medic_huey = GetEnt("medic_huey", "targetname");
	e1_heli = GetEnt("e1_heli_0", "targetname");
	medic_huey thread heli_pilot_maker();//create pilots only
	e1_heli thread heli_pilot_maker();//create pilots only
	medic_huey SetForceNoCull();
	e1_heli SetForceNoCull();

	if(huey_squadron.size > 0)
	{
		for(i = 0; i < huey_squadron.size; i++)
		{	
			if(IsDefined(huey_squadron[i]))
			{
				huey_squadron[i] SetForceNoCull();	
			}
		}
	}

	level thread event1_intro_huey_takeoffs();

	// wait till we are up the street
	flag_wait("e1_vignette_transition");

	//cleanup remaining heli's
	if(huey_squadron.size > 0)
	{
		for(i = 0; i < huey_squadron.size; i++)
		{	
			if(IsDefined(huey_squadron[i]))
			{
				huey_squadron[i] Delete();	
			}
		}
	}
}

event1_intro_huey_takeoffs()
{
	wait(0.1);

	huey0 = GetEnt("e1_heli_0", "targetname");
	huey0 veh_toggle_tread_fx(0);

	level thread e1_huey_takeoff(0, 4, 5);
	level thread e1_huey_takeoff(1, 7, 5);
	level thread e1_huey_takeoff(2, 8, 6);
	level thread e1_huey_takeoff(3, 7, 7);
	level thread e1_huey_takeoff(4, 7.5, 5);
}

// self == huey
e1_huey_takeoff(huey_number, wait_time, speed)
{
	huey = GetEnt("e1_heli_" + huey_number, "targetname");
	huey waittill("reached_end_node");

	wait(wait_time);

	huey.goalradius = 64;
	huey ResumeSpeed(speed);

	heli_path = "e1_heli_" + huey_number + "_takeoff";

	start_struct = GetStruct(heli_path, "targetname");
	start_look_ent = spawn("script_origin", start_struct.origin + AnglesToForward(start_struct.angles) * 500.0);

	end_struct = GetStruct(start_struct.target, "targetname");
	end_look_ent = spawn("script_origin", end_struct.origin + AnglesToForward(end_struct.angles) * 500.0);

	// hack
	if (huey_number == 0)
	{
		huey veh_toggle_tread_fx(1);
	}

	huey SetVehGoalPos(start_struct.origin);
	huey SetLookAtEnt(start_look_ent);
	huey waittill("goal");

	huey SetVehGoalPos(end_struct.origin);
	huey SetLookAtEnt(end_look_ent);
	huey waittill("goal");

	huey Delete();
}

e1_huey_troops_think()
{
	self endon("death");

	self waittill("jumpedout");

	random_sprint = RandomIntRange(1, 9);
	self set_generic_run_anim("sprint_" + random_sprint);

	self.goalradius = 64;

	goal_pos = GetEnt("huey_fleet_troop_pos", "targetname");
	self SetGoalPos(goal_pos.origin);

	self waittill("goal");

	self Delete();
}

//self is huey: delay takeoff of huey's at opening read
event1_delay_huey(path)
{
	wait 9.0;
	self go_path(path);
	self cleanup_vehicle();
}

//self is level: this is the cobra that flies over the body bags
event1_start_cobra()
{
	start_cobra_path = [];
	start_cobra = [];

	manage_vehicle_trigger("trig_start_cobra");
	//timed to fly over the body bags. by 65, the player has passed it.
	//wait 55;

	//i = 0 is the original cobra/path
	for(i = 0; i < 1; i++)
	{
		start_cobra_path[i] = GetVehicleNode("cobra_path_" +i, "targetname");

		start_cobra[i] = SpawnVehicle("vehicle_cobra_helicopter_green_fly", "event1_cobra_0", "heli_cobra_khesanh", start_cobra_path[i].origin, start_cobra_path[i].angles );
		start_cobra[i] SetForceNoCull();
		start_cobra[i] thread go_path(start_cobra_path[i]);
		//ACB FOR TUEY: i dont think I can thread this per chopper no?
		start_cobra[i] playsound("veh_cobra_flyby");
		start_cobra[i] thread cleanup_vehicle();
	}

}

//self is level: these are the phatoms that pass as you go past the APCs
event1_start_phantoms()
{
	manage_vehicle_trigger("trig_start_phantoms");

	trigger_use("e1_intro_f4s");

	wait(0.05);

	f4s = GetEntArray("e1_intro_f4_spawners", "targetname");
	for (i = 0; i < f4s.size; i++)
	{
		f4s[i] maps\khe_sanh_fx::f4_add_contrails();
		f4s[i] SetForceNoCull();
		f4s[i] thread plane_position_updater (3500, "evt_f4_long_wash", "null");
		f4s[i] thread cleanup_vehicle();
	}
}

event1_runway_phantoms()
{
	flag_wait("jeep_crash_start");

	wait(1.0);

	trigger_use("e1_runway_phantoms");

	wait(0.05);

	f4s = GetEntArray("e1_runway_f4_spawners", "targetname");
	for (i = 0; i < f4s.size; i++)
	{
		f4s[i] maps\khe_sanh_fx::f4_add_contrails();
		f4s[i] SetForceNoCull();
		f4s[i] thread plane_position_updater (3500, "evt_f4_long_wash", "null");
		f4s[i] thread cleanup_vehicle();
	}
}

//self is level: these are the choppers that cross your path as you past the cheering tower
event1_start_seaknights()
{
	self endon("death");

	//gets; waits; and deletes trigger when triggered
	manage_vehicle_trigger("trig_start_seaknights");

	seaknights_squadron = [];
	seaknights_squadron_path = [];

	for(i = 0; i < 3; i++)
	{
		seaknights_squadron_path[i] = GetVehicleNode("seaknight_path_" + i, "targetname");

		seaknights_squadron[i] = SpawnVehicle("t5_veh_ch46e_khesanh", "event1_seaknight_0", "heli_seaknight", seaknights_squadron_path[i].origin, seaknights_squadron_path[i].angles );
		seaknights_squadron[i] SetForceNoCull();
		seaknights_squadron[i] thread go_path(seaknights_squadron_path[i]);
		seaknights_squadron[i] thread cleanup_vehicle();
	}
}

//self is level: This is the mix of vehicles that go by opposite your direction of travel as you make the first left turn on the road
event1_start_air_escort()
{
	self endon("death");

	//gets; waits; and deletes trigger when triggered
	manage_vehicle_trigger("trig_start_air_escort");

	air_escort = [];
	air_escort_path = [];

	for(i = 0; i < 3; i++)
	{
		air_escort_path[i] = GetVehicleNode("air_escort_path_" + i, "targetname");

		if(i == 1)
		{
			air_escort[i] = SpawnVehicle("t5_veh_ch46e_khesanh", "event1_seaknight_0", "heli_seaknight", air_escort_path[i].origin, air_escort_path[i].angles );
		}
		else
		{	
			air_escort[i] = SpawnVehicle("vehicle_cobra_helicopter_green_fly", "event1_cobra_0", "heli_cobra_khesanh", air_escort_path[i].origin, air_escort_path[i].angles );
		}

		air_escort[i] SetForceNoCull();
		air_escort[i] thread go_path(air_escort_path[i]);
		air_escort[i] thread cleanup_vehicle();
	}
}

//self is level: This is a giant air group running parrallel of the runway as you turn into it
event1_start_runway_armada()
{
	self endon("death");

	//gets; waits; and deletes trigger when triggered
	manage_vehicle_trigger("trig_start_runway_armada");

	runway_armada = [];
	runway_armada_path = [];

	for(i = 0; i < 4; i++)
	{
		runway_armada_path[i] = GetVehicleNode("runway_armada_path_" + i, "targetname");

		if(i == 0 || i == 2)
		{
			runway_armada[i] = SpawnVehicle("t5_veh_helo_huey_usmc", "event1_huey_0", "heli_huey_usmc_khesanh", runway_armada_path[i].origin, runway_armada_path[i].angles );
		}
		else if(i == 1 || i == 3)
		{	
			runway_armada[i] = SpawnVehicle("vehicle_cobra_helicopter_green_fly", "event1_cobra_0", "heli_cobra_khesanh", runway_armada_path[i].origin, runway_armada_path[i].angles );
		}
		else
		{
			//acb removing f4s here since all vehicles should be going in the same general direction. if we readd set i < to 6
			//runway_armada[i] = SpawnVehicle("t5_veh_jet_f4_gearup_lowres", "event1_phantom_0", "plane_phantom_gearup_lowres", runway_armada_path[i].origin, runway_armada_path[i].angles );
			//runway_armada[i] playsound ("evt_f4_short_wash");
			//runway_armada[i] maps\khe_sanh_fx::f4_add_contrails();
		}
		
		runway_armada[i] SetForceNoCull();
		runway_armada[i] thread go_path(runway_armada_path[i]);
		runway_armada[i] thread cleanup_vehicle();
	}
}

event1_hueys_onstation()
{
	self endon("death");

	hueys_onstation = [];
	hueys_onstation_path = [];

	for(i = 0; i < 2; i++)
	{
		hueys_onstation_path[i] = GetVehicleNode("huey_onstation_path_" + i, "targetname");

		hueys_onstation[i] = SpawnVehicle("t5_veh_helo_huey_usmc", "event1_huey_0", "heli_huey_usmc_khesanh", hueys_onstation_path[i].origin, hueys_onstation_path[i].angles );
		hueys_onstation[i] maps\_huey::main();
	}

	manage_vehicle_trigger("trig_start_huey_onstation");

	for(i = 0; i < 2; i++)
	{
		hueys_onstation[i] SetForceNoCull();
		hueys_onstation[i] thread go_path(hueys_onstation_path[i]);
		hueys_onstation[i] thread cleanup_vehicle();
		wait 2.0;
	}
}

//self is level: APC column you pass on the road
event1_apc_column()
{
	self endon("death");

	manage_vehicle_trigger("trig_start_apc_column");

	apc_column = [];

	for(i = 0; i < 3; i++)
	{
		activate_trigger_with_targetname("trig_apc_" + i);
		wait 0.05;
		apc_column[i] = GetEnt("event1_apc_" +i, "targetname");
		apc_column[i] thread cleanup_vehicle();
	}
}

//gets a trigger; waits it for it to trigger then deletes it
manage_vehicle_trigger(targetname)
{
	trigger = GetEnt(targetname, "targetname");	
	trigger waittill("trigger");
	trigger Delete();
}

/***************************************************************/
//	event1c_trench_walk
/***************************************************************/
event1c_trench_walk()
{
//	if (IsGodMode(level.player))
//	{
//		return;
//	}

	//TUEY Change music state to Pickup Body (Removed for now---may not use this)
	setmusicstate("PICKUP_BODY");
	
	//acb set objective
	flag_set("obj_get_hudson_to_safety");
	flag_set("trench_walk_start");

	//play flashback 
	level.player thread flashback_vo();

	level.player FreezeControls( true );

	move_model = spawn("script_model", level.player.body.origin);
	move_model SetModel("tag_origin");
	move_model.targetname = "e1_player_trench_align";
	move_model.angles = (0, level.player.body.angles[1], 0);
	
	move_model thread anim_loop_aligned(level.player.body, "trench_idle");
	level thread run_scene("e1_trenchrun");
	//move_model thread anim_loop_aligned(level.squad["hudson"], "trench_idle");
	
	level.player StartCameraTween( 0.6 );
	level.player PlayerLinkTo( level.player.body, "tag_camera", 1, 25, 25, 25, 25 ); 
	
	wait( 0.45 );

	level.squad["hudson"] LinkTo(move_model);
	level.player.body LinkTo(move_model);

	wait( 0.05 );

	level.player FreezeControls( false );

	move_model thread event1c_trench_walk_turns();

	level.player.trench_walk = false;
	level.player.first_walk = true;
	level.player.body.velocity = 0;

	speed = 0;
	max_speed = 95;

	wait( 0.1 );

	// TEST: start sky metal
	trigger_use("e1c_trench_sky_metal");

	level thread event1c_trench_walk_mortars();
	level thread event1c_jumpdown_guys();

	//damage function on the player
	level.player thread event1c_trench_walk_player_damage();

	while (!flag("e1c_putdown_hudson"))
	{
		stick = level.player GetNormalizedMovement();

		if (stick[0] > 0.5)
		{
			if (!level.player.trench_walk)
			{
				level.player.trench_walk = true;
				move_model thread anim_loop_aligned(level.player.body, "trench_walk");
				//run_scene("e1_trenchrun_hudson");
				move_model thread anim_loop_aligned(level.squad["hudson"], "trench_walk");
			}
			else
			{
				angles = move_model.angles;
				forward = AnglesToForward(angles);
				
				speed = stick[0] * max_speed;
				move_model.origin = move_model.origin + (forward * speed * 0.05);
			}
		}
		else
		{
			if (level.player.trench_walk)
			{
				level.player.trench_walk = false;
				move_model thread anim_loop_aligned(level.player.body, "trench_idle");
				move_model thread anim_loop_aligned(level.squad["hudson"], "trench_idle");
				//run_scene("e1_trenchrun_hudson_idle");
			}
		}

		if (!move_model is_on_ground(5))
		{
			// above ground fall under gravity
			level.player.body.velocity = level.player.body.velocity - (100 * 0.05);
			v = (0, 0, level.player.body.velocity);
			move_model.origin = move_model.origin + (v * 0.05);
		}
		else
		{
			// on ground do nothing
			level.player.body.velocity = 0;
		}

		wait(0.05);
	}

	level.player.body UnLink();
	move_model Delete();

	// bunker mortars
	level thread event1c_bunker_mortars();

	// play the put down animation
	level.squad["hudson"] UnLink();

	level.player UnLink();
	level.player PlayerLinkToAbsolute(level.player.body, "tag_player");

	clip_brush = GetEnt( "hudson_putdown_blocker", "script_noteworthy" );
	align_node = GetEnt("e1c_trench_align", "targetname");
	actors = array(level.player.body, level.squad["hudson"]);
//	align_node anim_single_aligned(actors, "trench_done");
	clip_brush.origin = level.player.body.origin;
	anim_single(actors, "trench_done");
	anim_single(actors, "trench_done_2");
	clip_brush Delete();

//	level thread end_carry_vo();

	// Turn back on player shadow
	level.player SetClientDvar("r_enablePlayerShadow", 1); 
	level.player SetClientDvar("compass", 1);
	level.player SetClientDvar("cg_drawfriendlynames", 1);
	level.player UnLink();
	level.player EnableWeapons();
	level.player.body delete();

	//prevent backtrack
	level thread post_carry_backtrack_block();

	//acb set objective
	flag_set("obj_get_hudson_to_safety_complete");

	// Make Hudson wounded
	level.squad["hudson"] animscripts\anims_table::setup_wounded_anims();

	// Send Hudon inside
	level thread hudson_enter_bunker();

	// set off trench mortars
	level._explosion_stopNotify["e1c_trench_mortars"] = "stop_e1c_trench_mortars";
	level thread maps\_mortar::mortar_loop("e1c_trench_mortars", 1);
	level thread maps\_mortar::set_mortar_range("e1c_trench_mortars", 0, 512);
	level thread maps\_mortar::set_mortar_damage("e1c_trench_mortars", 256, 50, 1000);
	level thread maps\_mortar::set_mortar_delays("e1c_trench_mortars", 0.5, 1, 0.5, 1);	
//	level thread maps\_mortar::set_mortar_chance("e1c_trench_mortars", 1.0);

	// For Dan: Hearts!
	autosave_by_name("e1_trench_walk");

	// wait for heroic soldier vignette to finish
	flag_wait("e1c_done");

	// hudson not wounded anymore
	level.squad["hudson"].anim_array = undefined;
	level.squad["hudson"] animscripts\anims::clearAnimCache();
}

//self is level
hudson_enter_bunker()
{
	node = GetNode("trench_runners_delete", "targetname");
	level.squad["hudson"] SetGoalNode(node);

	//this is hudson reacting to the grenade vignette. he wasn't originally part of the scene.
	//self waittill("hack_hudson_react");
	//level.squad["hudson"] anim_single(level.squad["hudson"], "bunker");
}

end_carry_vo()
{
	save_name = undefined;

	if(IsDefined(level.player.animname))
	{
		save_name = level.player.animname;
	}

	wait 0.5;

	level.player.animname = "mason";
	level.player anim_single(level.player, "post_carry"); //We gotta move, Hudson!
	wait 0.2;
	level.squad["hudson"] anim_single(level.squad["hudson"], "post_carry");//I'm with you!

	if(IsDefined(save_name))
	{
		level.player.animname = save_name;
	}
}

event1c_trench_walk_turns()
{
	structs = [];
	structs[0] = GetStruct("e1c_hudsoncarry_a", "targetname");
	structs[1] = GetStruct("e1c_hudsoncarry_b", "targetname");
	structs[2] = GetStruct("e1c_hudsoncarry_c", "targetname");
	structs[3] = GetStruct("e1c_hudsoncarry_d", "targetname");
//	structs[4] = GetStruct("e1c_hudsoncarry_e", "targetname");

	current_struct = 0;
	delta = structs[current_struct + 1].origin - structs[current_struct].origin;
	desired_angles = VectorToAngles(delta);
	self RotateTo( (0, desired_angles[1], 0), 1, 0.5, 0.5 );
	self waittill( "rotatedone" );
	current_struct++;

	while (current_struct < structs.size)
	{
		struct_pos = structs[current_struct].origin;
		delta = Distance2DSquared(self.origin, struct_pos);
		if (delta < (48 * 48))
		{
			if (current_struct < structs.size)
			{
				//delta = structs[current_struct + 1].origin - structs[current_struct].origin;
				desired_angles = structs[current_struct].angles; //VectorToAngles(delta); 
				self RotateTo(desired_angles, 1.0, 0.5, 0.5);
			}
			
			current_struct++;
		}

		wait(0.05);
	}
}

event1c_bunker_mortars()
{
	level endon("e1c_stop_bunker_mortars");

	flag_wait("e1c_putdown_hudson");

	structs = GetStructArray("e1c_bunker_mortars", "targetname");
	while(1)
	{
		for (i = 0; i < 3; i++)
		{
			structs[i] thread maps\_mortar::activate_mortar(256, 1, 0, 0.25, 2.0, 256, true, level._effect["e1c_trench_mortars"], false);			
			level waittill( "mortar" );
			wait RandomFloatRange(1.25, 1.75);
		}
	}
}

event1c_trench_walk_mortars()
{
	flag_wait("trench_walk_start");	

	structs = GetStructArray("e1c_trench_mortars", "targetname");

	while (!flag("e1c_putdown_hudson"))
	{
		s = Random(structs);
		s thread maps\_mortar::activate_mortar(128, 1, 0, 0.25, 2.0, 128, true, level._effect["e1c_trench_mortars"], false);			
		level waittill( "mortar" );
		wait RandomFloatRange(0.75, 1.5);
	}
}

//damage the player and eventually kill him if he takes too long to get to the bunker
event1c_trench_walk_player_damage()
{
	level endon("e1c_putdown_hudson");

	old_origin = self.origin;
	damage_counter = 0;
	idle = false;

	//must wait here so it checkpoints
	wait 3;

	while(IsAlive(self))
	{
		wait(1);
		
		//check for player movement
		if( Distance2D(old_origin, self.origin) < 32)
		{
			damage_counter++;
			self DoDamage(20 * damage_counter, self.origin);

			if(!idle)
			{
				idle = true;
				flag_set("player_idle");
			}
		}
		else
		{
			idle = false;
			flag_clear("player_idle");
			if(damage_counter > 0)
			{
				damage_counter--;
			}
		}
		old_origin = self.origin;
	}

	//deatch player from player body for a "normal" death
	self.body Hide();
	self UnLink();
}

event1c_jumpdown_guys()
{
	trigger_wait("trig_e1c_trench_jump_down_guys");

	path_structs = [];
	for(i = 0; i < 4; i++)
	{
		path_structs[i] = getstruct("node_marine_trench_goal_" +i, "targetname");
	}

	spawners = GetEntArray("e1c_trench_jump_down_guys", "targetname");
	array_thread(spawners, ::add_spawn_function, ::set_to_goal, path_structs);
}

/***************************************************************/
//	event1c_vignettes
/***************************************************************/
event1c_vignettes()
{
	flag_wait("jeep_crash_done");

	level thread evente1c_area_blocker();

	// Threads
	level thread event1c_trenchsgt_vignette();
	level thread event1c_mortarguy_vignette();
	level thread event1c_heroicsoldier_vignette();
	level thread event1c_bunkerguys_vignette();
	level thread event1c_radiosgt_vignette();

	flag_wait("e1c_approach_bunker");

	guy = GetEnt("sobbing_guy", "targetname");
	guy add_spawn_function(::remove_backpack);

	// sobbing guy
	level thread do_vignette("e1c_sobbing_align", "sobbing_guy", "idle", true, 1, "sobbing_guy");

	// delete old stuff
	//flag_wait("e1c_done");
	
	//delete sobbing guy when player is at strength test in event 2 because he can still be seen
	trigger_wait("e2_nva_dive");

	//array_delete(level.vignette_group["trench_deadguys"]);
	array_delete(level.vignette_group["sobbing_guy"]);
//	array_delete(level.vignette_group["radio_guys"]);
}

//puts a visible barricade in the e1c bunker. sets off when choke starts
evente1c_area_blocker()
{
	level.e1c_close = GetEntArray("e1c_bunker_block", "targetname");
	for(i = 0; i < level.e1c_close.size; i++ )
	{
		level.e1c_close[i] MoveTo( level.e1c_close[i].origin + (0, 0, -200), 0.1);
	}

	trigger_wait("e2_nva_dive");

	level notify("kill_event1_backtrack");

	for(i = 0; i < level.e1c_close.size; i++ )
	{
		level.e1c_close[i] MoveTo( level.e1c_close[i].origin + (0, 0, 200), 0.1);
	}
}

event1c_radiosgt_vignette()
{
	flag_wait("e1c_putdown_hudson");

	// bunker radio sgt loop
	level thread do_vignette("e1c_bunker_align", "radioguy_sgt", "idle", true, 1, "radio_guys");
}

event1c_trenchsgt_vignette()
{
	align_node = GetEnt("e1c_trench_align", "targetname");

	// trench sgt
	level thread do_vignette("e1c_trench_align", "trench_mortarsgt", "idle", true, 1, "trench_sgt");

	// Short wait for vingette
	wait(0.05);

	// get the sgt
	sgt = level.vignette_group["trench_sgt"][0];
	
	// spin off vo thread
	sgt thread event1c_trenchsgt_vo();
	
	// wait for bunker
	trigger_wait("e1c_approach_bunker");

	//TUEY 
	setmusicstate ("SARGE_OWNED");
	
	level thread maps\_audio::switch_music_wait ("TRENCH_WARFARE", 5);

	// mortar strike
	//mortar_h = GetStruct("e1c_trench_mortar_h", "targetname");
	mortar_h = GetEnt("e1c_trench_align","targetname");
	mortar_h.origin = mortar_h.origin + (0,50,0);
	//mortar_h = Spawn("script_origin", GetEnt("e1c_trench_align","targetname").origin + (0, 50, 0));
	mortar_h thread maps\_mortar::activate_mortar(384, 1, 0, 0.4, 2.0, 128, true, level._effect["e1c_trench_mortars"], false);

	//delay for blast to go off
	mortar_h waittill("mortar");

	// wow! 
	explosion_launch(mortar_h.origin, 256, 120, 150, 15, 35);
}

// self == sgt
event1c_trenchsgt_vo()
{
	trigger_wait("start_e1c_trench_runners");

	self anim_single(self, "fortify");

	wait(1.0);

	self anim_single(self, "move");

	wait(1.0);

	self anim_single(self, "fire_team");
}

event1c_mortarguy_vignette()
{
	mortar_guy = simple_spawn_single("trench_explosionguy");
	mortar_guy AllowedStances("crouch");
	mortar_guy.animname = "trench_mortarexp";

	//flag_wait("e1c_trenchwalk_b");
	trigger = GetEnt("e1c_trenchwalk_b", "targetname");
	trigger waittill("trigger");

	// mortar strike
	mortar_g = GetStruct("e1c_trench_mortar_g", "targetname");
	mortar_g thread maps\_mortar::activate_mortar(128, 1000, 100, 0.4, 2.0, 256, true, level._effect["e1c_trench_mortars"], false);

	explosion_launch(mortar_g.origin, 128, 150, 200, 15, 35);

//	level notify("shell shock player", 4); 
//	maps\_shellshock::main(mortar_g.origin, 4, 256, 0, 0, 0, undefined, "default", 0); 
}

#using_animtree( "generic_human" );
event1c_heroicsoldier_vignette()
{
	//flag_wait("e1c_enter_bunker");
	flag_wait("e1c_putdown_hudson");
	wait 4.5;
	//increment the spawner so we can use it for event 2 tackle attacker
	level.e1c_nva_spawner = GetEnt("heroic_nva", "targetname");
	level.e1c_nva_spawner.count++;

	actors = [];
	tackle_vic_spawn = GetEnt("heroic_soldier01", "targetname");	
	tackle_vic_spawn add_spawn_function(::remove_backpack);
	actors[0] = simple_spawn_single("heroic_soldier01");

	//actors[1] = simple_spawn_single("heroic_soldier02");

	actors[1] = spawn_fake_character(level.e1c_nva_spawner.origin, level.e1c_nva_spawner.angles, "marine");
	actors[1].animname = "heroic_soldier02";
	actors[1] UseAnimTree(#animtree);
	actors[1].my_weapon = GetWeaponModel( "m16_sp" );
	actors[1] Attach(actors[1].my_weapon, "tag_weapon_right");
	actors[1] UseWeaponHideTags("m16_sp");
	actors[1].script_noteworthy = "e1_cleanup_ents";
	
	level.heroic_marine = actors[1];

	//save off reference to this marine who lives to get tackled at open of event 2
	level.tackle_vic = actors[0]; 

	//flag_wait("e1c_enter_bunker");

	actors[2] = spawn_fake_character(level.e1c_nva_spawner.origin, level.e1c_nva_spawner.angles, "c_vtn_nva3");
	actors[2].animname = "heroic_nva";
	actors[2] UseAnimTree(#animtree);
	actors[2].script_noteworthy = "e1_cleanup_ents";
	//actors[2] = simple_spawn_single("heroic_nva");
	//actors[2].health = 50000000;

	// wait for notify
	level thread event1c_heroicsoldier_vignette_listener(actors[2]);
	
	// play anim
	align_node = GetEnt("e1c_bunker_align", "targetname");
	align_node anim_single_aligned(actors, "bunker");

	flag_set("e1c_done");
}

//sorry wii
manage_hudson_blocker()
{
	level.hudson_carry_blocker = GetEnt("hudson_carry_blocker", "targetname");
	level.hudson_carry_blocker NotSolid();
	level.hudson_carry_blocker ConnectPaths();

	level waittill("drag_end_stop");

	wait 7;//9

	level.hudson_carry_blocker Solid();
	level.hudson_carry_blocker DisconnectPaths();

	flag_wait("trench_walk_start");

	wait 2;

	level.hudson_carry_blocker NotSolid();
	level.hudson_carry_blocker ConnectPaths();

	level.hudson_carry_blocker Delete();
}

event1c_heroicsoldier_vignette_listener(nva)
{
	level waittill("heroic_death_nva");

	level.heroic_marine guy_explosion_launch(level.heroic_marine.origin, (0, 0, 75));
	Earthquake(0.75, 1, level.player.origin, 200, level.player);

	if( is_mature() && !is_gib_restricted_build() )
	{
		//delete old guy
		//nva Detach("c_vtn_nva3_body");
		nva.team = "axis";
		nva setlookattext("", &"");
		nva Detach("c_vtn_nva3_head");
		nva Detach("c_vtn_nva3_gear");

		nva setModel("c_vtn_nva1_body_g_torso");
		nva.headModel = "c_vtn_nva3_head";
		nva attach(nva.headModel, "", true);
		nva.gearModel = "c_vtn_nva3_gear";
		nva attach(nva.gearModel, "", true);

		//make new guy body and head with no legs
		nva Attach("c_vtn_nva2_body_g_legsoff"); //legs // //c_vtn_nva2_body_g_lowclean
	}
	
	if( is_mature() )
	{
		//germans only get blood
		nva thread bloody_death();
	}
	
	level thread event1c_heroicsoldier_rumble();

	align_node = GetEnt("e1c_bunker_align", "targetname");
	align_node anim_single_aligned(level.vignette_group["radio_guys"], "go");

	structs = [];
	structs[0] = getstruct("node_marine_trench_goal_3", "targetname");
	level.vignette_group["radio_guys"][0] set_to_goal(structs);
}

event1c_heroicsoldier_rumble()
{
	for(i = 0; i < 10; i++ )		 
	{	
		level.player PlayRumbleOnEntity( "damage_heavy" );
		wait 0.15;
	}
}

event1c_bunkerguys_vignette()
{
	flag_wait("e1c_putdown_hudson");

	// soliders carrying stretchers
	bunker_guys_names = [];
	bunker_guys_names[0] = "bunker_guy01";
	bunker_guys_names[1] = "bunker_guy02";
	bunker_guys_names[2] = "bunker_guy03";
	bunker_guys_names[3] = "bunker_guy04";
	
	bunker_03 = GetEnt("bunker_guy03", "targetname");
	bunker_03 add_spawn_function(::add_weapon_to_guy);

	bunker_04 = GetEnt("bunker_guy04", "targetname");
	bunker_04 add_spawn_function(::remove_backpack);

	level thread do_vignette("e1c_bunker_align", bunker_guys_names, "bunker_idle", true, 1, "bunker_guys", false, true);

	trigger_wait("e1c_delete_bunker");

	array_delete(level.vignette_group["bunker_guys"]);
}

add_weapon_to_guy()
{
	wait 2;
	self Attach("t5_weapon_M16A1_world", "tag_weapon_right");
}

remove_backpack()
{
	wait 2;
	self Detach(self.gearModel);
}

/***************************************************************/
//	event1c_woods_think
/***************************************************************/
event1c_woods_think() // self == woods
{
	self endon("death");

	goal_node = GetNode("e1c_woods_trench", "targetname");

	self.goalradius = 64;
	self SetGoalNode(goal_node);

	trigger = GetEnt("e1c_trenchwalk_b", "targetname");
	trigger waittill("trigger");

	goal_node = GetNode("e1c_woods_bunker", "targetname");

	self SetGoalNode(goal_node);

	//flag_wait("e1c_enter_bunker");
	flag_wait("e1c_putdown_hudson");
	wait 4.5;
	
	//align_node = GetEnt("e1c_bunker_align", "targetname");
	//align_node anim_single_aligned(self, "bunker");

	run_scene("e1_wood_bunk_think");

	delete_scene("e1_wood_bunk_think");

}

/***************************************************************/
//	e1c_trench_runners_think
/***************************************************************/
e1c_trench_runners_think()
{
	self endon("death");

	self.goalradius = 128;

	random_sprint = RandomIntRange(1, 9);
	self set_generic_run_anim("sprint_" + random_sprint);
	goal_node = GetNode("trench_runners_delete", "targetname");
	self SetGoalPos(goal_node.origin);

	self waittill("goal");
	self delete();
}

//event1_change_sun_dir()
//{
//	level.player endon("death");
//
//	trigger = GetEnt("trig_set_sundir_exit_tent", "script_noteworthy");
//	trigger waittill("trigger");
//
//	maps\createart\khe_sanh_art::event1_set_sun_dir();
//}

event1c_mortarstrikes()
{

	//level._explosion_stopNotify["e1c_mortar_struct"] = "stop_e1c_mortar_struct";

	//level thread maps\_mortar::mortar_loop("e1c_mortar_struct", 1);
	//level thread maps\_mortar::set_mortar_range("e1c_mortar_struct", 64, 1024);
	//level thread maps\_mortar::set_mortar_damage("e1c_mortar_struct", 256, 0, 1);
	//level thread maps\_mortar::set_mortar_delays("e1c_mortar_struct", 1, 3, 1, 2);	
//	level thread maps\_mortar::set_mortar_chance("e1c_mortar_struct", 0.7);

	flag_wait("jeep_crash_done");

	level thread event1c_trench_mortars_1();
	level thread event1c_trench_mortars_2();
}

event1c_trench_mortars_1()
{
	level endon("event1c_trench_mortars_2");

	mortar_a = GetStruct("e1c_trench_mortar_a", "targetname");
	mortar_b = GetStruct("e1c_trench_mortar_b", "targetname");
	mortar_c = GetStruct("e1c_trench_mortar_c", "targetname");

	trig = GetEnt("start_e1c_trench_runners", "targetname");
	trig waittill("trigger");

	mortar_a thread maps\_mortar::activate_mortar(256, 1, 0, 0.4, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);
	level notify("sandbags01_start");

//	level notify("shell shock player", 4); 
//	maps\_shellshock::main(mortar_a.origin, 4, 256, 0, 0, 0, undefined, "default", 0); 

	wait(2.5);

	mortar_b thread maps\_mortar::activate_mortar(256, 1, 0, 0.4, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);

//	level notify("shell shock player", 4); 
//	maps\_shellshock::main(mortar_b.origin, 4, 256, 0, 0, 0, undefined, "default", 0); 

//	wait(4.0);
//
//	mortar_c thread maps\_mortar::activate_mortar(256, 1, 0, 0.4, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);

//	level notify("shell shock player", 4); 
//	maps\_shellshock::main(mortar_c.origin, 4, 256, 0, 0, 0, undefined, "default", 0); 
}

event1c_trench_mortars_2()
{
	trigger = GetEnt("e1c_trenchwalk_exploder", "targetname");
	trigger waittill("trigger");

	flag_set("stop_jeepcrash_spawn");

	level notify("hut_explode_start");
	level notify("sandbags02_start");
	playsoundatposition ("exp_khe_house_explo", (0,0,0));
	playsoundatposition ("exp_khe_house_fall", (-5032, 920, -176));
	//house exploder
	//Exploder(135);

	//turn on ambient effects First bunker to first M113
	//Exploder(20);

	//turn on ambient effects First M113 to e3_e4 bunker
	//Exploder(30);

	mortar_d = GetStruct("e1c_trench_mortar_d", "targetname");
	mortar_e = GetStruct("e1c_trench_mortar_e", "targetname");
	mortar_f = GetStruct("e1c_trench_mortar_f", "targetname");

	mortar_d thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);

	wait(2.5);

	mortar_e thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);
//	level notify("shell shock player", 4); 
//	maps\_shellshock::main(mortar_e.origin, 4, 256, 0, 0, 0, undefined, "default", 0); 

//	wait(2.0);
//
//	mortar_f thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_trench_mortars"], false);
}

event1c_pre_runway_mortars(mortar)
{
	//trigger gets deleted in event 2
	trigger_wait("trig_pre_runway_mortar", "targetname");
	mortar[15] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	mortar[15] waittill("mortar");
	explosion_launch(mortar[15].origin, 128, 100, 250, 15, 35);

	mortar[16] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	mortar[16] waittill("mortar");

	mortar[9] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	mortar[9] waittill("mortar");
	explosion_launch(mortar[9].origin, 128, 100, 250, 15, 35);
}

//mortar seqeunce during jeep swerve on runway
event1c_runway_mortars()
{
	// This is what happens when you have 10 days to E3...FTW!!

	runway_structs = getstructarray("struct_mortar_runway", "script_noteworthy");
	mortar = [];

	for(i = 0; i < runway_structs.size; i++ )
	{
		mortar[i] = GetStruct("struct_mortar_" +i, "targetname");
	}

	level thread event1c_pre_runway_mortars(mortar);

	//trigger gets deleted in event 2
	trigger_wait("trig_runway_mortar", "targetname");

	//debug the timing 
	//level thread show_time(0.05);

	//mortars as you go up the road to ther runway
	//mortar[15] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	//explosion_launch(mortar[15].origin, 128, 100, 250, 15, 35);
	
	wait 0.1;
	//mortar[16] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	//mortar[16] waittill("mortar");
	
	wait 0.1;
	//mortar[9] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	//explosion_launch(mortar[9].origin, 128, 100, 250, 15, 35);

	//mortars on the runway
	mortar[7] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	
	wait 0.1;
	mortar[8] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 0.25;
	mortar[0] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 0.25;	
	mortar[3] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	
	wait 0.1;
	mortar[2] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 0.25;	
	//removed for fx performance
	//mortar[1] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 0.1;
	//removed for fx performance
	//mortar[4] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	//mortar[5] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	mortar[6] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	//= 1.25


	//mortars after crossing the runway
	wait 0.87;
	mortar[10] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	mortar[11] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	wait 3.85;

	//mortars during get up
	wait 2.3;

	mortar[12] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 9.5;//shaved off 0.5

	level notify("hut_explode_jeep_start");
	//Exploder(134);//kaboom

	wait 1.0;
	mortar[13] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);
	
	wait 5.75;
	mortar[14] thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e1c_runway_struct"], false);

	wait 5;
	//cleanup structs
	for(i = 0; i < mortar.size; i++)
	{
		remove_drone_struct(mortar[i]); 
	}
}

event1c_crash_ambient_marines()
{
	//first_goal = GetNode("node_e1c_firstgoal", "targetname");
	//mid_goal = GetNode("node_e1c_firstgoal", "targetname");
	//final_goal = GetNode("node_marine_trench_goal", "targetname");

	path_structs = [];
	for(i = 0; i < 4; i++)
	{
		path_structs[i] = getstruct("node_marine_trench_goal_" +i, "targetname");
	}

	marines = GetEntArray("e1c_trench_spawners", "script_noteworthy");

	for(i = 0; i < marines.size; i++)
	{
		marines[i] add_spawn_function(::set_to_goal, path_structs); 
	}

	flag_wait("jeep_crash_jump");

	wait(2.25);

	first_guys = simple_spawn("e1c_marine_spawner_01");

	level thread vo_first_guys(first_guys);

	wait(11);

	array_thread(GetEntArray("e1c_marine_spawner_04", "targetname"), ::add_spawn_function, ::stop_on_drag);
	array_thread(GetEntArray("e1c_marine_spawner_02", "targetname"), ::add_spawn_function, ::stop_on_drag);
	//array_thread(GetEntArray("e1c_marine_spawner_03", "targetname"), ::add_spawn_function, ::stop_on_drag);

	fourth_guys = simple_spawn("e1c_marine_spawner_04");

	level thread vo_fourth_guys(fourth_guys);

	wait(4.0);//3.0 /dont go lower than 4 to avoid guys running into woods

	second_guys = simple_spawn("e1c_marine_spawner_02");

	wait(5.0);

	//these guys are the primary reason stuff bunches up spawners are too clsoe. consider moving or commenting out this line
	//third_guys = simple_spawn("e1c_marine_spawner_03");

	flag_wait("trench_walk_start");

	level thread e1c_marine_spawn_mgr_pauser();

	flag_wait("stop_jeepcrash_spawn");

	spawn_manager_kill("e1c_marine_spawn_mgr");
}

//self is ai
stop_on_drag()
{
	level waittill("drag_end_stop");
	
	if(!level.player is_player_looking_at( self.origin, 0.2, false ))
	{
		self thread force_goal(self.origin, 128, undefined, "trench_walk_start");
	}

	flag_wait("trench_walk_start");

	x = RandomFloatRange(1.5,2.5);
	wait x;

	self notify("trench_walk_start");
}

vo_first_guys(guys)
{
	if(IsDefined(guys) && guys.size > 2)
	{
		guys[0].animname = "e1c_amb_vo";
		guys[1].animname = "e1c_amb_vo";
		
		guys[0] anim_single(guys[0], "go_go");//Go Go!
		guys[1] anim_single(guys[1], "quick");//Quick, do it!

	}
}

//this stops and resumes the spawn manager behind the player if they stop during the trench walk
//waits for flags set in event1c_trench_walk_player_damage()
e1c_marine_spawn_mgr_pauser()
{
	level endon("stop_jeepcrash_spawn");

	set_pause = false;

	trigger_use("e1c_marine_spawn_mgr");

	while(1)
	{
		if(flag("player_idle") && !set_pause)
		{
			set_pause = true;
			spawn_manager_disable("e1c_marine_spawn_mgr");
		}
		
		if(!flag("player_idle") && set_pause)
		{
			set_pause = false;
			spawn_manager_enable("e1c_marine_spawn_mgr");
		}

		wait 0.05;
	}

}

vo_fourth_guys(guys)
{
	if(IsDefined(guys) && guys.size > 2)
	{
		guys[0].animname = "e1c_pretrench_vo";
		guys[1].animname = "e1c_pretrench_vo";

		guys[0] anim_single(guys[0], "status_0");//Jesus - lots of mortars left side of the runway.
		guys[1] anim_single(guys[1], "status_1");//Jeeps and trucks to the North.
		guys[0] anim_single(guys[0], "status_2");//He said they spotted some enemy tanks. Couple clicks NorthEast.
		guys[1] anim_single(guys[1], "status_3");//Fuckin' bastards.
	}
}

set_to_goal(paths)
{
	self endon("death");
	
	//self.ignoreall = true;
	self.goalradius = 64;

	random_sprint = RandomIntRange(1, 9);
	self set_generic_run_anim("sprint_" + random_sprint);

	//self set_goal_pos(first_node.origin);
	//self waittill("goal");

	for(i = 0; i < paths.size; i++)
	{
		self set_goal_pos(paths[i].origin);
		self waittill_any_or_timeout( 4, "goal" );
		//self waittill("goal");
	}

	self waittill("goal");
	self Delete();
}


post_carry_backtrack_block()
{
	level endon("kill_event1_backtrack");
	trig_a = GetEnt("e1c_approach_bunker", "targetname");
	trig_b = GetEnt("e1c_trenchwalk_b", "targetname");
	 
	waittill_any_ents( trig_a, "trigger", trig_b, "trigger" );
	
	level thread maps\_shellshock::main(level.player.origin, 5, 256, 0, 0, 0, undefined, "default", 0); 
	level.player thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
	level waittill("mortar_inc_done");
	level.player khe_sanh_die();
}

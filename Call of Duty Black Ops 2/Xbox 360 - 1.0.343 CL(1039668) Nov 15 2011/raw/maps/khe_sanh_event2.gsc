//////////////////////////////////////////////////////////
//
// khe_sanh_event2.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_flyover_audio;
#include maps\_music;
#include maps\_scene;

#include maps\_strength_test;

main()
{
	init_flags();

	level thread event2_amb_mortarstrikes();
	level thread event1_cleanup_setup();
	level thread event2_sky_metal();
	level thread event2_heli_think();
	level thread event2_intro();
	level thread maps\khe_sanh_event1::event1_distant_walla();
	level thread audio_event1_cleanup();	
}
audio_event1_cleanup()
{
	if (IsDefined ( level.sound_ent_walla ))
	{
		level.sound_ent_walla delete();	
	}
}
init_flags()
{
	flag_init("bunker_exit");
	flag_init("heli_to_house");

	flag_init("tackle_start_window");
	flag_init("tackle_end_window");

	flag_init("tackler_hit");
	flag_init("end_drone_notifier");

	flag_init("ladder_heli");

	flag_init( "player_went_ahead" );
	flag_init( "squad_under_apc" );

	flag_init( "shoot_huey" );
	flag_init( "shoot_apc" );

	flag_init("player_go_straight");
	flag_init("player_goes_right");

	flag_init("blindfire_done");

	flag_init("e2_u_cut_exit_guys_killed");
	flag_init("e2_exit_bunker_sm_clear");

	flag_init("hudson_nva_reached");

	flag_init("blocker_deleted");
}

/////////////////////////////////////////////////////////////////////////////////////////
// Progression Functions
/////////////////////////////////////////////////////////////////////////////////////////

//get allies moving, spawn drones, start mission threads
event2_intro()
{
	//fire point at exit
	level.narrows_blocker = GetEnt("brush_flank_right_blocker", "targetname");
	level.e2_fire_struct = getstruct("e2_flame_point", "targetname");
	level.e2_fire_struct thread fire_damage_player();
	//no FF for this section: turned back on when tank phase of event 3 start. When it gets more open
	level.friendlyFireDisabled = 1;

	//TUEY setting music to state "TRENCH_WARFARE"
	setmusicstate ("TRENCH_WARFARE");

	//start with shotgun
	//level.player SwitchToWeapon( "ithaca_sp" );

	//hide player blockers
	//level.player_blocker_0 = GetEnt("e2_player_block_ucut_enter", "targetname");
	//level.player_blocker_0 MoveTo( level.player_blocker_0.origin + (0, 0, -200), 0.1);

	//set heroes to navigate in trenches cqb/gren awareness - needed in tight quarters
	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");
	level.squad["woods"].grenadeAwareness = 0;
	level.squad["hudson"].grenadeAwareness = 0;

	level.apc_cleanup = [];

	//acb set obj start for event 2
	flag_set("obj_trenches_with_woods");

//	trigger = GetEnt("trig_heroes_color_0", "targetname");
//	trigger waittill("trigger");
	autosave_by_name("e2_start");

	//get allies moving
	trigger_use("trig_heroes_color_0");

	level event2_threatbiasgroups();

	// turn on battle chatter
	battlechatter_on("allies");
	battlechatter_on("axis");

	// Stop mortars
	//level notify("stop_e1c_mortar_struct");
	
	//triggers first hill drones save for delete
	level thread drone_speed_adjust();
	level.drone_trigger_intro = GetEnt("e2_trig_drone_axis_0", "script_noteworthy");
	level.drone_trigger_intro activate_trigger();

	//setup_drone_yells(all_drones, interval_wait, wait_min, wait_max, vox_weight_min, vox_weight_max, vox_weight_median)
	level thread setup_drone_yells(undefined, 5, 2, 4);

	//tackle vignette after exiting HQ
	level thread event2_tackle();

	//starts for the opening hill read
	level thread event2_bunker_exit();

	// start the ucut
	level thread event2_u_cut();

	level thread event2_straight_path();

	//start events when going under first bridge
//	level thread event2_first_bridge();
//
//	//go to the u-cut
//	level thread event2_flank_right();
//	
//	//exit u cut
//	level thread event2_exit_ucut();
//	
//	//regroup after apc trench crash
//	//level thread event2_woods_trans_to_defend();
// 
	//vignette of marine getting burned
	level thread event2_flame_marine();
	
	//melee vignettes along the longer horseshoe path
	level thread event2_top_melee();
	level thread event2_top_melee_back();

	//event where woods and hudson dive under crashing apc
	level thread event2_apc_crush();
}

event2_bunker_exit()
{
	level.player endon("death");

	level thread event2_phantom_strike();
	level thread event2_machine_gun_turret_dive();

	//trigger_wait("trig_e2_bunker_exit");
	flag_wait("trig_e2_bunker_exit");

	//turn off all amb effects for event 1
//	stop_exploder(10); //event 1 fx
//	stop_exploder(135); //house that explodes fire.
//	stop_exploder(130); //jeep

	// HACK...??
	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;

	// Handle allies
	ally_spawners = GetEntArray("e2_exit_bunker_allies", "targetname");
	array_thread(ally_spawners, ::add_spawn_function, ::setup_allies);
	exit_bunker_allies = simple_spawn(ally_spawners);

	level thread e2_exit_redshirt_vo(exit_bunker_allies);

	// make the 2 guys go prone
	prone_guys = GetEntArray("e2_exit_bunker_prone_guys", "script_noteworthy");
	array_thread(prone_guys, ::add_spawn_function, ::set_goal_go_prone);

	// first jump down guy
	jump_guy = GetEnt("e2_spawner_jump_down_0", "targetname");
	jump_guy add_spawn_function(::set_ignore_to_goal);

	// spawn the exit bunker guys: 4 enemies shoot player
	start_guys_player = GetEntArray("e2_spawner_0", "targetname");
	array_thread(start_guys_player, ::add_spawn_function, ::start_guys_think_player_group);
	trigger_use("trig_e2_spawn_mgr_0");

	waittill_ai_group_amount_killed("e2_exit_guys", 1);
	
	// spawn the exit bunker guys: 8 enemies shoot allies/heroes
	start_guys = GetEntArray("e2_start_guys", "targetname");
	array_thread(start_guys, ::add_spawn_function, ::start_guys_think_ally_group);
	spawn_manager_enable("e2_exit_bunker_sm");


	bridge_guys = GetEntArray("e2_bridge_nva_0", "targetname");
	array_thread(bridge_guys, ::add_spawn_function, ::start_guys_think_ally_group);

	trigger_use("trig_heroes_color_1");
	trigger_use("trig_e2_spawn_mgr_1");

	level thread e2_exit_bunker_sm_watcher();

	//waittill_spawn_manager_cleared("e2_exit_bunker_sm");
	level waittill_any_or_timeout( 15, "e2_exit_bunker_sm_clear");

	cover_node = GetNode("node_color_g2_woods", "targetname");
	cover_node.script_onlyidle = true;
	level.squad["woods"] thread set_goal_node(GetNode("node_color_g2_woods", "targetname"));
	level.squad["hudson"] thread set_goal_node(GetNode("node_color_g2_hudson", "targetname"));	
}

e2_exit_redshirt_vo(allies)
{
	trigger_wait("trig_e2_first_bridge");
	if(IsDefined(allies[0]))
	{
		allies[0].animname = "trench_mortarsgt";
		allies[0] anim_single(allies[0], "take_cover");
	}
}

e2_exit_bunker_sm_watcher()
{
	waittill_spawn_manager_cleared("e2_exit_bunker_sm");
	flag_set("e2_exit_bunker_sm_clear");
}

event2_u_cut()
{
	//kill if player goes straight
	level endon("player_go_straight");

	trigger_wait("trig_e2_flank_right");

	flag_set("end_drone_notifier");

	level thread event2_phantom_ucut();
	level thread event2_apc_approach();
	level thread event2_narrows_guys();
	level thread event2_narrows_backup();
	level thread event2_enter_u_cut_guys();
	level thread event2_house_guys();
	level thread event2_u_cut_allies();
	level thread event2_u_cut_back_guys();
	level thread event2_u_cut_back_allies();
	level thread event2_delete_u_cut_blocker();
	level thread event2_twin_apc();
	level thread event2_hudson_hand_2_hand();
	level thread event2_exit_u_cut_hand_2_hand();
	level thread event2_enter_ucut_watcher();

	//vignette of woods going into ucut 
	level event2_woods_ladder_blindfire();

//	if(flag("player_goes_right") && !flag("player_go_straight"))

	flag_wait("player_goes_right");

	waittill_ai_group_amount_killed("e2_u_cut_back_guys", 1);

	autosave_by_name("e2_woods_goes_right");

	wait 0.1;

	trigger_use("trig_heroes_color_5");

	level thread u_cut_exit_ai_group_watcher();

	level waittill_any_or_timeout( 25, "e2_u_cut_exit_guys_killed");
	autosave_by_name("e2_woods_exit_ucut");

	wait 0.1;

	//moves heroes before trench
	trigger_use("trig_heroes_color_6");
	
}

u_cut_exit_ai_group_watcher()
{
	waittill_ai_group_amount_killed("e2_u_cut_exit_guys", 1);
	flag_set("e2_u_cut_exit_guys_killed");
}

event2_enter_ucut_watcher()
{
	level endon("player_go_straight");

	trigger_wait("trig_enter_u_cut");
	flag_set("player_goes_right");
}

event2_straight_path()
{
	level endon("player_goes_right");
	
	trigger_wait("e2_straight_path");

	flag_set("player_go_straight");

	//flag_wait("blindfire_done");

	e2_u_cut_exit_spawners = GetEntArray("e2_u_cut_exit_guys", "targetname");
	array_thread(e2_u_cut_exit_spawners, ::add_spawn_function, ::set_suppression_off);

	//only spawn the ones in front of the player
	for(i = 0; i < e2_u_cut_exit_spawners.size; i++)
	{
		if(IsDefined(e2_u_cut_exit_spawners[i].script_int) && e2_u_cut_exit_spawners[i].script_int == 1)
		{
			e2_u_cut_exit_spawners[i] Delete();
		}
	}

	wait 0.05;

	//spawn guys jsut before apc crush and delete brush path blocker
	trigger_use("e2_u_cut_exit");

	force_move_ai_to_apc();

	trig_e2_u_cut_back_turn = GetEnt("e2_u_cut_back_turn", "targetname");
	trig_e2_u_cut_back_turn Delete();

	trig_e2_exit_ucut = GetEnt("trig_e2_exit_ucut", "targetname");
	trig_e2_exit_ucut Delete();

	trig_e2_flame_marine = GetEnt("trig_e2_flame_marine", "targetname");
	trig_e2_flame_marine Delete();
	
	autosave_by_name("e2_player_goes_straight");
}

set_goal_go_prone()
{
	self endon("death");

	self disable_long_death();

	self waittill("goal");
	self AllowedStances("prone");
}

//self is AI
set_goal_go_crouch()
{
	self endon("death");

	self waittill("goal");
	self AllowedStances("crouch");
}

//self is AI
start_guys_think()
{
	self endon("death");
	//adjust accuracy multiplier 1.0 is default 
	self.script_accuracy = 0.4;
	set_goal_to_crouch_cqb();
	wait RandomFloatRange(5, 7);

	nodes = GetNodeArray("e2_exit_move_nodes", "script_noteworthy");
	random_node = random(nodes);

	self SetGoalNode(random_node);
}

event2_narrows_guys()
{
	//kill it if player goes straight
	level endon("player_go_straight");

	//spawn manager for trench narrows
	narrow_spawner = GetEnt("e2_narrow_nva_0", "script_noteworthy");
	narrow_spawner add_spawn_function(::narrows_non_rush);
	spawn_manager_enable("trig_e2_spawn_mgr_2");

	trigger_wait("trig_enter_u_cut");

	spawn_manager_kill("trig_e2_spawn_mgr_2");
	guys = get_ai_group_ai("e2_narrows_guys");
	for (i = 0; i < guys.size; i++)
	{
		guys[i].health = 1;
//		guys[i] notify("e2_stop_narrow_rushers");
	}
}

event2_narrows_backup()
{
	guys = GetEntArray("e2_marine_ucut_blockers", "targetname");
	array_thread(guys, ::add_spawn_function, ::magic_bullet_shield);
}

event2_enter_u_cut_guys()
{
	//kill it if player goes straight
	level endon("player_go_straight");

	trigger_wait("trig_enter_u_cut");

	u_cut_guys = GetEntArray("e2_enter_u_cut_guys", "targetname");
	array_thread(u_cut_guys, ::add_spawn_function, ::set_ignore_to_goal);

	guys = simple_spawn(u_cut_guys);
	for (i = 0; i < guys.size; i++)
	{
		guys[i].pathenemyfightdist = 0;
	}

//	waittill_ai_group_cleared("e2_enter_u_cut_guys");
	waittill_ai_group_amount_killed("e2_enter_u_cut_guys", 1);

	//if this flag is set and this thread is still active, this means the player went right then went straight
	//because this thread ends on the straight path
	//this trigger is a juncture between the straight path and the right path
	//if the player hits it regardless, all progression picks up at event2_exit_u_cut_hand_2_hand()
	if(!flag("e2_u_cut_end"))
	{
		trigger_use("trig_heroes_color_4");
	}
}

event2_u_cut_back_guys()
{
	prone_guys = GetEntArray("e2_u_cut_prone_guys", "script_noteworthy");
	array_thread(prone_guys, ::add_spawn_function, ::set_goal_go_prone);
}

//NOTE TO ME: better way to have managed woods and hudson when making this open terrain was to do all their movement in one function.
//that could handle path switching but everything was too interconnected to one path and there was only one day to do this...sigh.
//This blocker must be deleted to allow progression to teh APC. the blocker exists so that it can contain NVA AI PRIOR to the player making
//a path choice. 
event2_delete_u_cut_blocker()
{
	//trigger_wait("e2_u_cut_exit"); //e2_u_cut_exit
	//e2_u_cut_exit is a spawn manager trigger that controls the and previous fixed path progression. 
	//e2_u_cut_end is the actual trigger that now connects the two paths.
	//trig_e2_exit_ucut is the trigger just beneath the bridge inside the horsehoe after going right. it is part of the original linear progression
	flag_wait_any("trig_e2_exit_ucut", "e2_u_cut_exit", "e2_u_cut_end", "player_go_straight");

	//this is a path blocker for AI before teh ucut
	level.narrows_blocker ConnectPaths();
	level.narrows_blocker Delete();

	flag_set("blocker_deleted");
}

event2_house_guys()
{
	//kill it if player goes straight
	level endon("player_go_straight");

	trigger_wait("trig_enter_u_cut");

	spawners = GetEntArray("e2_u_cut_house_guys", "targetname");
	array_thread(spawners, ::add_spawn_function, ::house_guys_set_bias);
	array_thread(spawners, ::add_spawn_function, ::set_goal_go_crouch);

	guys = simple_spawn("e2_u_cut_house_guys");
	for (i = 0; i < guys.size; i++)
	{
		guys[i].pathenemyfightdist = 0;
	}
}

event2_u_cut_allies()
{
	//kill it if player goes straight
	level endon("player_go_straight");

	trigger_wait("trig_enter_u_cut");
	ucut_allies = GetEntArray("e2_u_cut_allies", "targetname");
	array_thread(ucut_allies, ::add_spawn_function, ::ally_bias);
	wait 2; //hack throttle spawn
	guys = simple_spawn(ucut_allies);
}

event2_u_cut_back_allies()
{
	//kill it if player goes straight
	level endon("player_go_straight");
	
	//trigger_wait("e2_u_cut_back_turn");
	flag_wait("e2_u_cut_back_turn");
	//spawners = GetEntArray("e2_u_cut_back_allies", "targetname");
	//array_thread(spawners, ::add_spawn_function, ::setup_allies);
	guys = simple_spawn("e2_u_cut_back_allies");
}

/*
event2_exit_ucut()
{
	level.player endon("death");

	//sets up two apcs when exiting ucut
	level thread event2_twin_apc();

	//player has crossed ucut middle bridge
	trigger_wait("trig_e2_exit_ucut", "targetname");

	level thread event2_exit_ucut_heli();

	//this is a path blocker for AI before teh ucut
	narrows_blocker = GetEnt("brush_flank_right_blocker", "targetname");
	narrows_blocker ConnectPaths();
	narrows_blocker Delete();

	//kill the spawn manager that s in the middle of the ucut
	level spawn_manager_kill("trig_e2_spawn_mgr_3");

	autosave_by_name("e2_middle_ucut");

	//send redshirts to later half of ucut
	trigger_use("trig_redshirt_color_2", "targetname");

	//spawners at end of ucut
	level spawn_manager_enable("trig_e2_spawn_mgr_4");
	trigger_use("trig_colors_nva_ucut_exit", "targetname");

	level spawn_manager_enable("trig_e2_spawn_mgr_5");
	trigger_use("trig_colors_nva_pre_prone", "targetname");
}
*/

/////////////////////////////////////////////////////////////////////////////////////////
// Helicopter command sequences
/////////////////////////////////////////////////////////////////////////////////////////

event2_heli_think()
{
	//test ai huey
	level setup_huey_ai_support();

	//trigger_wait("trig_e2_bunker_exit");
	//trig flag
	flag_wait("trig_e2_bunker_exit");

	level thread event2_bunker_exit_heli();

	trigger_wait("trig_e2_first_bridge");

	level thread event2_first_bridge_heli();

	trigger_wait("trig_e2_flank_right");

	level thread event2_flank_right_heli();

	flag_wait("ladder_heli");

	level thread event2_ladder_heli();

	//PLAYER PATH SWITCH
	trig_path_right = GetEnt("trig_e2_exit_ucut", "targetname");
	trig_straight = GetEnt("e2_straight_path", "targetname");
	//trigger_wait("trig_e2_exit_ucut");
	level waittill_any_ents(trig_path_right, "trigger", trig_straight, "trigger");

	//allow flag to set if straight
	wait 0.5;

	if(!flag("player_go_straight") || flag("player_goes_right"))
	{
		level thread event2_exit_ucut_heli();
	}

	trigger_wait("trig_e2_apc_crush");

	level thread event2_apc_crush_heli();
}

//opening of event 2
event2_bunker_exit_heli()
{
	level.heli_support heli_ai(level.HELI_MOVE, 0);

	//huey line on player 2d
	level.player.animname = "hero_huey";
	level.player thread anim_single(level.player, "line_0");//We're on it, six.

	level.heli_support.heli.mod_pitch = 8;
	level.heli_support heli_ai(level.HELI_SHOOT, 0);

	//flag_wait("bunker_exit");
	trigger_wait("trig_pre_bridge_spawner", "targetname");
	//huey line
	level.heli_support heli_ai(level.HELI_SHOOT, 0);
}

//when travelling under first bridge
event2_first_bridge_heli()
{
	level.heli_support heli_ai(level.HELI_MOVE, 1);

	level.player.animname = "hero_huey";
	level.player thread anim_single(level.player, "line_1");//On station, six. Standing by.

	level.heli_support.heli.mod_pitch = 8;
	level.heli_support heli_ai(level.HELI_SHOOT, 1);
}

//when making the flank right move
event2_flank_right_heli()
{
	level.heli_support heli_ai(level.HELI_MOVE, 2);

	level.heli_support heli_ai(level.HELI_SHOOT, 2);

	wait 1;

	level.heli_support heli_ai(level.HELI_SHOOT, 1);

	level flag_set("heli_to_house");
}

//this is the sequence for the chopper shooting at the u cut house
event2_ladder_heli()
{
	level.player endon("death");

	flag_wait("heli_to_house");
	level.heli_support heli_ai(level.HELI_MOVE, 3);

	level.player thread anim_single(level.player, "line_2");//Adjust your fire!

	level.heli_support.heli.mod_pitch = 8;
	level.heli_support heli_ai(level.HELI_GUNNER_SHOOT, 3);
	//huey line
	//wait 1;

	//level.heli_support heli_ai(level.HELI_MOVE, 4);

	//level.heli_support heli_ai(level.DELETE_ME);
}

//this is the sequence for exiting the ucut
event2_exit_ucut_heli()
{
	level.player endon("death");

	level.heli_support heli_ai(level.HELI_MOVE, 4);

	level.heli_support.heli.mod_pitch = 10;
	level.heli_support heli_ai(level.HELI_SHOOT, 4);

	wait 2;

	level.heli_support heli_ai(level.HELI_SHOOT, 7);
}

//this is the sequence for exiting the ucut
event2_apc_crush_heli()
{
	//omg e3 is really coming....
	level.player endon("death");

	level.heli_support thread heli_ai(level.HELI_MOVE, 5);

	wait 3;

	//huey line
	level.player thread anim_single(level.player, "line_3");//Incoming!

	level.heli_support.heli waittill("goal");

	//shoot origin 5 is being used at the house GUNNER SHOOT
	//this means flight structs and shoot origins are now out of sync
	level.heli_support.heli.mod_pitch = 13;
	level.heli_support heli_ai(level.HELI_SHOOT, 6);

	wait 2;

	level.heli_support heli_ai(level.HELI_SHOOT, 6);

	wait 1;
	
	flag_set("shoot_huey");

	wait 0.5;

	flag_set("shoot_huey");

	wait 0.5;

	level.heli_support heli_ai(level.HELI_MOVE, 6);

	wait 1; 

	level.heli_support heli_ai(level.HELI_SHOOT, 7);

	wait 2;

	//huey line
	level.player thread anim_single(level.player, "line_4");//Jesus Christ!
}

/////////////////////////////////////////////////////////////////////////////////////////
// Vignette Functions
/////////////////////////////////////////////////////////////////////////////////////////

//vignette of NVA tackling friendly
event2_tackle()
{
	align_node = GetEnt("e1c_bunker_align", "targetname");
	actors = [];

	if(!IsDefined(level.tackle_vic))
	{
		actors[0] = simple_spawn_single("heroic_soldier01");
	}
	else
	{
		actors[0] = level.tackle_vic;
	}


	//actors[0].animname = "tackle_vic";
	actors[0] magic_bullet_shield();
	//align_node anim_reach_aligned(actors[0], "tackle");
	
	//CDC Play a scream and some foley
	actors[0] playsound ( "evt_tackle_vic");
	
	//TUEY set music state to TRENCH_NVA_FIGHT_AI
	setmusicstate("TRENCH_NVA_FIGHT_AI");


	actors[1] = simple_spawn_single("heroic_nva");
	//actors[1].animname = "tackle_atkr";
	//actors[1].allowdeath = true;
	actors[1].ignoreme = true;
	actors[1] disable_long_death();
	actors[1] thread tackle_death_watcher();

	//create bad place so AI avoid it
	brush = GetEnt("e2_badplace", "targetname");
	BadPlace_Brush( "e2_tackle_bad_place", 0, brush, "allies");

	//align_node anim_single_aligned(actors, "tackle");

	run_scene("e2_heroic_nva");

	//CDC Play a gruunt on the GI
	//ACB GI is actor 0
	actors[0] playsound ( "chr_play_grunt_american");

	//flag_wait("tackle_end_window");
	if(flag("tackler_hit"))
	{
		//align_node anim_single_aligned(actors[0], "tackle_save");
		run_scene("e2_heroic_nva_save");
		if(IsDefined(actors[0]))
		{
			actors[0] stop_magic_bullet_shield();
			actors[0] set_goal_node(GetNode("node_tackler_lives", "targetname"));
		}
		//for delete
		level.tackled_marine = actors[0];

	}
	else
	{
		actors[0] stop_magic_bullet_shield();
		actors[1] notify("no_damage");
		actors[1].ignoreme = false;
		
		run_scene("e2_heroic_nva_fail");
		//align_node anim_single_aligned(actors, "tackle_fail");
		actors[1] stop_magic_bullet_shield();
	}

	BadPlace_Delete("e2_tackle_bad_place");

	trigger_wait("trig_pre_bridge_spawner", "targetname");

	//kill the tackled marine if he lived
	if(IsDefined(level.tackled_marine))
	{
		level.tackled_marine dodamage(level.tackled_marine.health*10, level.tackled_marine.origin);
	}

	trigger_wait("e2_nva_dive");
	align_node Delete();
}

//self is nva tackler when exiting opening bunker
tackle_death_watcher()
{
	level.player endon("death");
	self endon("no_damage");

	//self magic_bullet_shield();

	self waittill("damage");

	flag_set("tackler_hit");
	//self stop_magic_bullet_shield();
	self StartRagdoll();
	self DoDamage( self.health + 200, self.origin );
}

//brings up the apc at the base of the first guard tower
event2_apc_approach()
{
	activate_trigger_with_targetname("e2_spawn_apc_approach");
	wait 0.05;
	apc = GetEnt("e2_apc_0", "targetname");
	turret_guy_spawner = GetEnt("e2_apc_gunner_0", "targetname");
	turret_guy_spawner.count++;
	actors = [];

	apc waittill("reached_end_node");

	apc_origin = apc.origin;
	apc_angles = apc.angles;
	
	apc Delete();
	apc_actor = spawn_anim_model("apc_turret_fighter", apc_origin, apc_angles);
	apc_actor Attach("t5_veh_m113_warchicken_turret_decals", "tag_gunner_turret4");
	apc_actor Attach("t5_veh_m113_warchicken_decals", "body_animate_jnt");
	apc_actor Attach("t5_veh_m113_sandbags", "body_animate_jnt");
	apc_actor.animname = "apc_turret_fighter"; //(1.376, 4.931, 297.518)
	apc_turret_guy = simple_spawn_single(turret_guy_spawner);
	apc_turret_guy.animname = "apc_turret_guy";
	
	actors = array_add(actors, apc_actor);
	actors = array_add(actors, apc_turret_guy);

	//save for cleanup
	level.apc_cleanup = array_add( level.apc_cleanup, apc_actor );

	apc_actor anim_loop(actors, "turret_fighter");
}

event2_twin_apc()
{
	trigger_wait("trig_heroes_color_6", "targetname");
	
	activate_trigger_with_targetname("e2_spawn_twin_apc");
	wait 0.05;

	apc = GetEnt("e2_twin_apc_0", "targetname");
	apc thread twin_apc_shoot();


	level.apc_cleanup = array_add( level.apc_cleanup, apc );
}

//self is apc
twin_apc_shoot()
{
	self endon("death");
	x = [];

	self SetGunnerTurretOnTargetRange(3, 20);

	while(1)
	{
		pos = (self.origin + (0, 0, 130)) + AnglesToForward(self.angles) * 160;
		pos_right = (self.origin + (0, 0, 130)) + AnglesToRight(self.angles) * 160;
		//pos_left = (self.origin + (0, 0, 200)) + AnglesToRight(self.angles) * -200;

		x = array(pos, pos_right); 
		self SetGunnerTargetVec(random(x), 3);

		wait 0.35;

		for(i = 0; i < 6; i++)
		{	
			self FireGunnerWeapon( 3 );
			wait 0.15;
		}
		
		wait 2;
	}
}

event2_huey_strafe()
{
	huey_strafe = [];
	huey_strafe_path = [];

	for(i = 0; i < 2; i++)
	{
		huey_strafe_path[i] = GetVehicleNode("e2_huey_path_" + i, "targetname");
		//huey_strafe[i] = SpawnVehicle("t5_veh_helo_huey_heavyhog", "e2_huey_heavy_0", "heli_huey_heavyhog", huey_strafe_path[i].origin, huey_strafe_path[i].angles );
		huey_strafe[i] = SpawnVehicle("t5_veh_helo_huey_usmc", "event1_huey_0", "heli_huey_usmc_khesanh", huey_strafe_path[i].origin, huey_strafe_path[i].angles );
		huey_strafe[i] thread go_path(huey_strafe_path[i]);
		huey_strafe[i] thread cleanup_vehicle();
	}
}

event2_woods_ladder_blindfire()
{
	nva_actors = [];
	actors = [];
	align_node = GetEnt("align_woods_blindfire", "targetname");
	align_node_nva = GetEnt("align_woods_blindfire_nva", "targetname");
	ladder_spawn_loc = getstruct("e2_ladder_spawn_loc", "targetname");

	ladder_nva_spawner = GetEnt("spawner_woods_blindfire_nva", "targetname");
	ladder_nva_spawner.count = 8;

	//spawn 4 nva
	for(i = 0; i < 5; i++)
	{
		nva_actors[i] = simple_spawn_single(ladder_nva_spawner);
		wait 0.05;
		nva_actors[i].animname = "ladder_nva_" + i;
		nva_actors[i].script_forcecolor = "r";	
		nva_actors[i].ignoreme = true;
		nva_actors[i] disable_long_death();

		if(i == 1 || i == 3 || i == 4)
		{
			nva_actors[i].allowdeath = true;
		}
		else
		{
			//nva_actors[i] magic_bullet_shield();
		}
	}

	//ladder 1
	actors[0] = spawn_anim_model("ladder_0", ladder_spawn_loc.origin, ladder_spawn_loc.angles, true);

	//ladder 2	
	actors[1] = spawn_anim_model("ladder_1", ladder_spawn_loc.origin, ladder_spawn_loc.angles, true);

	actors[2] = level.squad["woods"];

	//starts animation of guys jumping down into trench
	level thread nva_jump_down(ladder_nva_spawner);

	flag_set("ladder_heli");

	//nva
	//align_node_nva thread anim_single_aligned(nva_actors, "ladder_blind_fire");

	level thread  run_scene("e2_nva_ladder");

	//ladders
	align_node_nva thread anim_single_aligned(actors[0], "ladder_blind_fire");
	align_node_nva thread anim_single_aligned(actors[1], "ladder_blind_fire");

	//woods tells you to go right
	//actors[2].goalheight = 150;
	//align_node anim_reach_aligned(actors[2], "ladder_blind_fire");
	level.squad["woods"] thread set_goal_node(GetNode("node_color_g2_woods", "targetname"));
	level.squad["woods"] waittill("goal");
	
	level notify("set_hudson_melee");
	//hang out to shoot
	wait 3.25;

	//move hero allies
	trigger_use("trig_heroes_color_3", "targetname");

	level.squad["woods"] enable_ai_color();
	level.squad["hudson"] enable_ai_color();


	//woods tells you to go right
	//align_node anim_single_aligned(actors[2], "ladder_blind_fire");
	run_scene("e2_wood_ladder");

	flag_set("blindfire_done");

	//send ladder guys to bridge
	trigger_use("trig_colors_nva_ladder");

	//turn off ignore me
	for(i = 0; i < 4; i++)
	{
		if(IsDefined(nva_actors[i]))
		{
			nva_actors[i].ignoreme = false;
		}
	}

	align_node Delete();
	align_node_nva Delete();
}

nva_jump_down(spawner)
{
	align_node = GetEnt("align_nva_jump_down", "targetname");
	
	leapdown_actors = [];
	
	//spawn 3 more nva
	for(i = 0; i < 3; i++)
	{
		leapdown_actors[i] = simple_spawn_single(spawner);
	//	leapdown_actors[i] Hide();
		leapdown_actors[i].animname = "leapdown_nva_" + i;
		leapdown_actors[i] thread narrows_set_rusher();
		leapdown_actors[i].ignoreme = true;
		leapdown_actors[i].allowdeath = true;
		wait 1;		
	}	



	level thread run_scene("e2_nva_leap");

	//for(i = 0; i < 3; i++)
	//{
	//	if(IsDefined(leapdown_actors[i]))
	//	{
	//		align_node thread anim_single_aligned(leapdown_actors[i], "leapdown_blindfire");
	//		wait 0.05;
	//		leapdown_actors[i] Show();
	//	}
	//}	
	
	for(i = 0; i < 3; i++)
	{
		if(IsDefined(leapdown_actors[i]))
		{
			leapdown_actors[i].ignoreme = false;
		}
	}	

	align_node Delete();
}

event2_phantom_strike()
{
	trigger_wait("trig_e2_first_bridge");

	//spawn_manager_kill("e2_exit_bunker_sm");

	wait(5.0);

	phantom_squadron = [];
	phantom_squadron_path = [];

	physics_structs = [];

	//was 0-4 removed some drone paths
	for(i = 1; i < 3; i++)
	{
		physics_structs[i] = getstruct("napalm_" +i, "targetname");
	}

	for(i = 0; i < 2; i++)
	{
		phantom_squadron_path[i] = GetVehicleNode("e2_phantom_path_" + i, "targetname");

		phantom_squadron[i] = SpawnVehicle("t5_veh_jet_f4_gearup_lowres", "event1_phantom_0", "plane_phantom_gearup_lowres", phantom_squadron_path[i].origin, phantom_squadron_path[i].angles );
		phantom_squadron[i] maps\khe_sanh_fx::f4_add_contrails();
		phantom_squadron[i] SetForceNoCull();
		phantom_squadron[i] thread go_path(phantom_squadron_path[i]);
		phantom_squadron[i] thread cleanup_vehicle();
		phantom_squadron[i] thread plane_position_updater (500, "evt_f4_short_wash", "null");
	}

	vehicle_node_wait("e2_phantom_napalm", "script_noteworthy");
	
	//Exploder(220);

/*
	for(i = 1; i < 2; i++)
	{
		//explosion_launch(org, radius, min_force, max_force, min_launch_angle, max_launch_angle, drones)
		explosion_launch(physics_structs[i].origin, 256, 150, 350, 10, 30, true);
		wait 0.1;
	}
*/
}

event2_phantom_ucut()
{
	phantom_path = GetVehicleNode("e2_phantom_path_ucut_0", "targetname");
	phantom = SpawnVehicle("t5_veh_jet_f4_gearup_lowres_marines", "event1_phantom_0", "plane_phantom_gearup_lowres_camo", phantom_path.origin, phantom_path.angles );
	phantom maps\khe_sanh_fx::f4_add_contrails();
	phantom SetForceNoCull();
	phantom thread go_path(phantom_path);
	phantom thread cleanup_vehicle();
	phantom thread plane_position_updater (500, "evt_f4_short_wash", "null");
}

//self is the trigger
flame_trig_watcher(trig)
{
	level endon("trig_e2_flame_marine");
	level endon("squad_under_apc");
	off = false;

	while(1)
	{
		if(level.player IsTouching(self) && !off)
		{
			off = true;
			trig trigger_off();
		}

		if(!level.player IsTouching(self) && off)
		{
			off = false;
			trig trigger_on();
		}

		wait 0.05;
	}
}

event2_flame_marine()
{
	//kill it if player goes straight
	level endon("player_go_straight");
	
	flame_trigger = GetEnt("trig_e2_flame_marine", "targetname");
	flame_disabler = GetEnt("trig_flame_disabler", "targetname");
	flame_disabler thread flame_trig_watcher(flame_trigger);
	
	//trigger_wait("trig_e2_flame_marine");
	flag_wait("trig_e2_flame_marine");

	actor_names = [];
	actor_names[0] = "e2_spawner_flame_nva";
	actor_names[1] = "e2_spawner_flame_marine";

	align_node = GetEnt("align_flame_marine", "targetname");
	main_marine = GetEnt("e2_spawner_flame_marine", "targetname");
	main_marine add_spawn_function(::enable_charring, false);

	flame_nva_spawner = GetEnt("e2_spawner_flame_marine", "targetname");
	flame_nva_spawner thread add_spawn_function(::set_goal_pos, align_node.origin);

	//do_vignette(node, actor_names, anim_name, loop, thread_type, group_name, auto_delete /* only works for non threaded */)
	level thread do_vignette("align_flame_marine", actor_names, "flame_trench", false, 1, "flame_guys");	

	extra_marines = GetEntArray("e2_u_cut_flamed_marines", "targetname");
	array_thread(extra_marines, ::add_spawn_function, ::ignore_settings);
	array_thread(extra_marines, ::add_spawn_function, ::burn_me);
	//array_thread(extra_marines, ::add_spawn_function, ::enable_charring, false);

	guys = simple_spawn(extra_marines);

	wait(0.05);

	flame_nva = level.vignette_group["flame_guys"][0];
	node = GetNode("send_flame_nva", "targetname");

	flame_nva thread set_goal_pos(node.origin);

	flame_nva.ignoreall = false;
	flame_nva.allowdeath = false;


	while(1)
	{
		flame_nva waittill("damage", amount, attacker);
		if(attacker == level.player || attacker == level.squad["woods"] || attacker == level.squad["hudson"])
		{
			break;
		}
	}	

	explode_pos = flame_nva.origin + (0, 0, 15);
	PlayFX(level._effect["fx_exp_flamethrower_tank"], explode_pos);
	playsoundatposition ("evt_flamethrower_death", (explode_pos));
	
	flame_nva.dropweapon = false; 
	flame_nva gun_remove();
	flame_nva thread event2_flame_marine_nva_burn();

	exit_u_cut_spawners = GetEntArray("e2_u_cut_exit_guys", "targetname");
//	array_thread(exit_u_cut_spawners, ::add_spawn_function, ::set_pathfight_dist, 0);
	array_thread(exit_u_cut_spawners, ::add_spawn_function, ::set_suppression_off);

	wait 0.1;
	trigger_use("e2_u_cut_exit");
}

event2_flame_marine_nva_burn()
{
	self endon( "death" );
	
	self.animname = "napalm_victim_1";

	if( is_mature() )
	{
		self StartTanning();
		self SetClientFlag(level.ACTOR_CHARRING);
	}

	//SOUND - Shawn J
	self playsound ("amb_fougasse_scream");

	self.ignoreme = true;
	self.ignoreall = true;

	self thread animscripts\death::flame_death_fx();
	anim_single( self, "burning_fate" );

	self khe_sanh_die();
}

event2_top_melee()
{
	trigger = trigger_wait("e2_trigger_top_melee");

	nva = simple_spawn_single("nva_attack", ::set_ignoreme, true);
	marine = simple_spawn_single("marine_defend", ::set_ignoreme, true);
	marine.takedamage = false;
	marine.targetname = "e2_top_fight_aligned_marine";

	actors = array(nva,marine);

	//marine anim_single_aligned(actors, "melee_front");
	run_scene("e2_top_fight_1");
	nva set_ignoreme(false);
}

event2_top_melee_back()
{
	trigger = trigger_wait("e2_trigger_top_melee");

	nva = simple_spawn_single("nva_attack_2", ::set_ignoreme, true);
	nva.animname = "fight_2";
	marine = simple_spawn_single("marine_defend_2", ::set_ignoreme, true);
	marine.takedamage = false;
	marine.targetname = "e2_top_fight_aligned_marine_2";
	marine.animname = "fight_2_marine";


	actors = array(nva,marine);

	//marine anim_single_aligned(actors, "melee_back");
	
	run_scene("e2_top_fight_2");
	nva set_ignoreme(false);
}

set_pathfight_dist(dist)
{
	self.pathenemyfightdist = dist;
}

#using_animtree( "generic_human" );
event2_apc_crush()
{
	level.player endon("death");

	//shoot rpgs at heli and apcs for transition
	level thread apc_crush_fake_rpgs();
	
	//TO DO need to do anim first frame here when anims are ready
	level.apc_actor = spawn_anim_model("apc_to_crush", (-7422.3, -1346.9, 168.6), (4.931, 297.518, 1.376));//apc_start_spot.origin, apc_start_spot.angles, true);
	level.apc_actor Attach("t5_veh_m113_sandbags", "body_animate_jnt");
	level.apc_actor Attach("t5_veh_m113_outcasts_decals", "body_animate_jnt");
	level.apc_actor.animname = "apc_to_crush"; //(1.376, 4.931, 297.518)
	level.apc_actor.script_string = "no_deathmodel";

	//spawn the gunner
	turret_guy_spawner = GetEnt("e2_apc_gunner_0", "targetname");
	turret_guy_spawner.count++;
	apc_turret_guy = simple_spawn_single("e2_apc_gunner_0");
	apc_turret_guy.animname = "apc_turret_guy_crush";

	//to remove the model
	level.apc_cleanup = array_add( level.apc_cleanup, level.apc_actor );
	
	actors[0] = apc_turret_guy;
	//actors[1] = level.apc_actor;
	level.apc_actor thread anim_loop(actors, "turret_fighter");

	//trigger_wait("trig_heroes_color_6", "targetname");

	//send woods and hudson to prone dive at APC
	//level.squad["woods"] set_goal_node(GetNode("node_goal_apc_woods", "targetname"));
	//level.squad["hudson"] set_goal_node(GetNode("node_goal_apc_hudson", "targetname"));	

	//waittill_multiple_ents(level.squad["woods"], "goal", level.squad["hudson"], "goal", trigger, "trigger");

	trigger = GetEnt("trig_e2_apc_crush", "targetname");
	trigger waittill("trigger");
	
	apc_start_spot = GetVehicleNode("node_apc_crush_start", "targetname");
	align_node = GetEnt("align_apc_crush", "targetname");
	align_node_apc = GetEnt("align_apc_crush_apc", "targetname");

	actors = [];
	
	actors[0] = level.squad["woods"];
	actors[1] = level.squad["hudson"];

	level.squad["woods"] disable_ai_color();
	level.squad["hudson"] disable_ai_color();
	
	//woods and hudson go to animation start
	align_node thread event2_apc_crush_squad_watch(actors);
	level.player thread event2_apc_crush_player_watch();

	level waittill_any("squad_in_position", "player_ahead");

	//rpg shot
	flag_set( "shoot_apc" );

	//heroes run through delay is for if the player was shellshocked so they aren't seen warping
	/*
	if( flag("player_went_ahead") )
	{
		wait(0.5);
	}
	*/

	if( flag("player_went_ahead") )
	{
		level thread fast_forward_heroes(actors);
		//align_node anim_single_aligned(actors, "apc_crush");
		run_scene("e2_apc_crush");
	}
	else
	{
	//	align_node anim_single_aligned(actors, "apc_crush");
		run_scene("e2_apc_crush");
	}
	

	//squad is now past the APC
	flag_set( "squad_under_apc" );

	//catchall from force shellshock
	level.player SetMoveSpeedScale( 1.0 );

	level thread post_apc_fake_combat();

	flag_set( "shoot_apc" );
	//Exploder(250);
	Earthquake(0.7, 2, level.player.origin, 200, level.player);
	level notify("sandbags_apc_start");
	dirt = GetEnt("e2_apc_crush_dirt_clean", "targetname");
	dirt Delete();
	
	//SOUND - Shawn J
	align_node_apc playsound ("evt_apc_trench");
	
	apc_turret_guy StopAnimScripted();
	apc_turret_guy thread bloody_death();
	level thread anim_single(level.apc_actor, "apc_crush");

	//SOUND - Shawn J
	tank = Spawn("script_origin",(-7297, -1510, 124)); 
	tank playloopsound ("evt_apc_idle");
	
	level thread player_goes_prone();

	flag_set("start_e3_thread");

	level waittill("player_past_prone");

	//resett stances from post_apc_fake_combat
	//level.squad["woods"] AllowedStances( "prone", "crouch", "stand" );
	//level.squad["hudson"] AllowedStances( "prone", "crouch", "stand" );

	level.drone_trigger_apc = GetEnt("e2_trig_drone_axis_0b", "script_noteworthy");
	level.drone_trigger_apc activate_trigger();
	
	//stop shoot at and fake combat
	level.squad["woods"] notify("stop_ai_fake_shoot");
	level.squad["hudson"] notify("stop_ai_fake_shoot");
	level.squad["woods"] stop_shoot_at_target();
	level.squad["hudson"] stop_shoot_at_target();

	level thread anim_single(level.apc_actor, "apc_crush_end");
}

fast_forward_heroes(actors)
{
	wait 0.05;
	actors[0] Hide();
	actors[1] Hide();
	actors[0] SetAnimTime(%ch_khe_E2_tank_crush_guy01, 0.935 );//woods .935 == 144 of 154 //0.968 == 149 of 154
	actors[1] SetAnimTime(%ch_khe_E2_tank_crush_guy02, 0.935 );//hudson
	wait 4;
	actors[0] Show();
	actors[1] Show();
}

//self is the align node
event2_apc_crush_squad_watch(actors)
{
	self anim_reach_aligned(actors, "apc_crush");
	level notify("squad_in_position");
}


//self is the player
event2_apc_crush_player_watch()
{
	//going to hit the invisible wall!
	while(self.origin[0] > -7100)
	{
		wait(0.05);
	}

	//shell shock the player if the squad didn't go under the APC yet
	if( !flag("squad_under_apc") )
	{
		flag_set( "player_went_ahead" );

		//shell shock them with the first blast
		level thread maps\_shellshock::main(self.origin, 3.5, 256, 0, 0, 0, undefined, "default", 0); 
		level.player SetMoveSpeedScale( 0.2 );
		Earthquake(0.65, 1, self.origin, 200, self);
		level thread custom_rumble(0.02, 18);
		self DoDamage(50, self.origin);
		self AllowStand(false);

		level notify("player_ahead");

		//self lerp_player_view_to_position( (-7100, -1326, 76.1) , (0, 210, 0), 0.5, 1);
		self lerp_player_view_to_position( (-7100, -1326, 76.1), (325, 211, 0), 0.5, 1); //looking at apc

		self AllowStand(true);
		level.player SetMoveSpeedScale( 1.0 );
	}	
}

post_apc_fake_combat()
{
	level.squad["woods"] thread set_goal_node(GetNode("node_post_prone_woods", "targetname"));
	level.squad["hudson"] thread set_goal_node(GetNode("node_post_prone_hudson", "targetname"));

	//level.squad["woods"] AllowedStances( "crouch" );
	//level.squad["hudson"] AllowedStances( "crouch" );

	level.squad["woods"] waittill("goal");
	
	//vo only
	//level.squad["woods"] LookAtEntity(level.player);
	level.squad["woods"] anim_single(level.squad["woods"], "apc_encourage"); //"Come on, Mason!"

	level.squad["woods"] thread ai_fake_shoot("origin_heli_target_8");
	level.squad["hudson"] thread ai_fake_shoot("origin_heli_target_8");	

	wait 2;

	//vo only
	level.squad["woods"] anim_single(level.squad["woods"], "apc_encourage_b"); //"Come on!"
	//level.squad["woods"] LookAtEntity();
}

//self is ai. origin_heli_target_8 is a helicopter shoot origin that gets deleted after woods fougasse so im using it here since this
//occurs prior to the crash.
ai_fake_shoot(origin_name)
{
	self endon("death");
	self endon("stop_ai_fake_shoot");
	
	assert(IsDefined(origin_name), "origin not defined");

	origin = GetEnt(origin_name, "targetname");	

	while(1)
	{
		if(IsDefined(origin))
		{
			self shoot_at_target(origin, "tag_origin", 0.15);
		}

		wait 0.15;
	}

}

//self is level
apc_crush_fake_rpgs()
{
	level.player endon("death");
	self endon("player_past_prone");

	start_pos = getstruct("struct_apc_crush_rpg", "targetname").origin;
	while(1)
	{
		self waittill_any("shoot_huey", "shoot_apc");

		if(flag("shoot_huey"))
		{
			if(IsDefined(level.heli_support.heli))
			{
				//z = RandomIntRange(35, 55);
				right_side_pos = level.heli_support.heli.origin + AnglesToRight(level.heli_support.heli.angles) * 100;
				MagicBullet("rpg_sp", start_pos, right_side_pos );
				flag_clear("shoot_huey");
			}
		}

		if(flag("shoot_apc"))
		{
			if(IsDefined(level.apc_actor))
			{
				for(i = 0; i < 2; i++)
				{
					z = RandomIntRange(25, 35);
					MagicBullet("rpg_sp", start_pos, level.apc_actor.origin + (0, 0, z));
					/#
					Debugstar(level.apc_actor.origin + (0, 0, z), 10000, (1,0,0));
					#/
					wait 0.5;
				}
				flag_clear("shoot_apc");
			}
		}
}
}


player_goes_prone()
{
	level.player endon("death");
	trigger_wait("trig_player_prone", "targetname");

	level notify("player_past_prone");

	//collision for apc. drops down when we hit exit prone trigger
	level.apc_brush = GetEnt("brush_apc_clip", "targetname");
	level.apc_brush MoveTo(level.apc_brush.origin + (0, 0, -32), 1.5);
	
	//SOUND - Shawn J
	level.apc_brush playsound ("evt_apc_post_prone");
}

event2_nva_leaper()
{
	level.player endon("death");

	//get goal node because actor needs running start
	run_to_node = GetNode("node_nva_leaper", "targetname");
	align_node = GetEnt("align_nva_leaper", "targetname");
	
	//set up actor
	actor = simple_spawn_single("e2_spawner_nva_leaper");
	actor magic_bullet_shield();
	actor.animname = "e2_nva_leaper";
	actor ent_flag_init("nva_leaper_death");

	//have actor run to node before starting anim
	actor SetGoalNode(run_to_node);
	actor waittill("goal");

	actor thread event2_nva_land_or_death();

	//align_node anim_single_aligned(actor, "leaper_jump");

	run_scene("e2_nva_leaper");

	if(actor ent_flag("nva_leaper_death"))
	{
		actor stop_magic_bullet_shield();
		//align_node anim_single_aligned(actor, "leaper_death");
		run_scene("e2_nva_leap_death");
		actor DoDamage( actor.health + 200, actor.origin );
	}
	else
	{
		//align_node anim_single_aligned(actor, "leaper_land");
		run_scene("e2_nva_leap_land");
		actor stop_magic_bullet_shield();
	}

	align_node Delete();
}

//self is actor "e2_spawner_nva_leaper"
event2_nva_land_or_death()
{
	level.player endon("death");
	self endon("leaper_land");

	self waittill("damage");
	self ent_flag_set("nva_leaper_death");
}

//sets up ai helicopter
#using_animtree("generic_human");
setup_huey_ai_support()
{
	level.HELI_MOVE = 0;
	level.HELI_SHOOT = 1;
	level.HELI_GUNNER_SHOOT = 2;
	level.HELI_STRAFE = 3;
	level.DELETE_ME = 4;

	//get totals
	total_flight_structs = getstructarray("struct_heli_flight", "script_noteworthy");
	total_shoot_origins = GetEntArray("origin_heli_target","script_noteworthy");

	level.heli_support = SpawnStruct();
	//fill struct flight and targets array in order by targetname
	for(i = 0; i < total_flight_structs.size; i++)
	{
		level.heli_support.fly_to_struct[i] = getstruct("struct_heli_flight_" +i, "targetname");
	}

	for(i = 0; i < total_shoot_origins.size; i++)
	{
		level.heli_support.shoot_origins[i] = GetEnt("origin_heli_target_" +i, "targetname");
	}

	//spawn huey and allies 
	activate_trigger_with_targetname("e2_trig_huey_support");

	//make sure created vehicle runs through _vehicle init()
	wait 0.05;

	level.heli_support.heli = GetEnt("e2_huey_support", "targetname");
	level.heli_support.heli.goalradius = 128;
	level.heli_support.heli SetForceNoCull();
	level.heli_support.heli.ignoreme = true;
	//define pitch values: will adjust per shoot command
	level.heli_support.heli.default_pitch = 2;
	level.heli_support.heli.cur_pitch = level.heli_support.heli.default_pitch;
	level.heli_support.heli.mod_pitch = level.heli_support.heli.default_pitch;

	//fill in crew
	level.heli_support.heli_crew = [];

	for(i = 0; i < 4; i++)
	{
		if(i < 3)
		{
			level.heli_support.heli_crew[i] = spawn_fake_character(level.heli_support.heli.origin, (0,0,0), "huey_pilot_1");
		}
		else
		{
			level.heli_support.heli_crew[i] = spawn_fake_character(level.heli_support.heli.origin, (0,0,0), "huey_pilot_2");
		}
	}

	level.heli_support.heli_crew[0].animname = "huey_pilot_1";
	level.heli_support.heli_crew[1].animname = "huey_pilot_2";
	level.heli_support.heli_crew[2].animname = "gunner_pilot_1";
	level.heli_support.heli_crew[3].animname = "gunner_pilot_2";

	level.heli_support.heli_crew[0] LinkTo(level.heli_support.heli,"tag_driver");
	level.heli_support.heli_crew[1] LinkTo(level.heli_support.heli,"tag_passenger");
	level.heli_support.heli_crew[2] LinkTo(level.heli_support.heli,"tag_gunner1");
	level.heli_support.heli_crew[3] LinkTo(level.heli_support.heli,"tag_gunner2");


	for(i = 0; i < level.heli_support.heli_crew.size; i++ )
	{
		level.heli_support.heli_crew[i] UseAnimTree(#animtree);
		level.heli_support.heli_crew[i] thread anim_loop(level.heli_support.heli_crew[i], "huey_idle");
	}

}

//self is struct heli_support
heli_ai(behavior, parameter)
{
	switch(behavior)
	{
		case 0:
			if(IsDefined(parameter))
			{
				level.heli_support heli_move(parameter);
			}
			else
			{
				level.heli_support heli_move();
			}
			break;
		case 1:
			if(IsDefined(parameter))
			{
				level.heli_support heli_shoot(parameter);
			}
			else
			{
				level.heli_support heli_shoot();
			}
			break;
		case 2:
			level.heli_support heli_gunner_shoot(parameter);
			break;
		case 3:
			break;
		case 4:
			level heli_cleanup(self);
			break;
		default:
			break;
	}
	
	self notify("heli_action_done");
}

//self is heli_support data struct
heli_move(loc)
{
	if ( !IsDefined( self.heli ) )
	{
		return;
	}
	
	if(IsDefined(loc))
	{
		self.heli SetVehGoalPos( self.fly_to_struct[loc].origin, true );
		self.heli SetLookAtEnt( self.shoot_origins[loc] );
		self.heli waittill("goal");
	}
	else
	{
		//SetVehGoalPos( <goalpos> <stopAtGoal>, <usepath> )
		self.heli SetVehGoalPos( random(self.fly_to_struct).origin, true );
		self.heli SetLookAtEnt( random(self.shoot_origins) );
		self.heli waittill("goal");
	}
}

//self is heli_support data struct
heli_shoot(shoot_at)
{
	self.heli endon("death");
	
	if(IsDefined(self.heli))
	{	
		if(IsDefined(shoot_at))
		{
			self.heli SetLookAtEnt( self.shoot_origins[shoot_at] );
			self.heli SetTurretTargetEnt( self.shoot_origins[shoot_at] ); 
		}
		else
		{
			target = random(self.shoot_origins);
			self.heli SetLookAtEnt( target );
			self.heli SetTurretTargetEnt( target );
		}
			
		//set pitch down when we fire
		assert(self.heli.mod_pitch > 0, "mod pitch must be > 0");
		assert(self.heli.mod_pitch > self.heli.default_pitch, "mod pitch must be > default");
		while( self.heli.cur_pitch < self.heli.mod_pitch )
		{
			if(IsDefined(self.heli))
			{
				self.heli SetDefaultPitch( self.heli.cur_pitch );

				wait 0.05;
				self.heli.cur_pitch += 0.15;
			}
		}

	//	self.heli SetClientFlag(level.PITCH_DOWN);
		self.heli waittill("turret_on_target");
		
		for(i = 0; i < 6; i++)
		{
			self.heli FireWeapon("tag_rocket_right");
			self.heli FireWeapon("tag_rocket_left");
			wait 0.6;
		}

	//	self.heli SetClientFlag(level.PITCH_UP);

		//set pitch back up after we fire
		//restore default over time
		while( self.heli.cur_pitch > self.heli.default_pitch )
		{
			if(IsDefined(self.heli))
			{			
				self.heli SetDefaultPitch( self.heli.cur_pitch );

				wait 0.05;
				self.heli.cur_pitch -= 0.15;
			}
		}

		self.heli SetDefaultPitch( self.heli.default_pitch );
	}
}

//self is heli_support data struct
//this is really custom to the house right now. TODO need to make it generic 
heli_gunner_shoot(shoot_ai)
{
	level.player endon("death");
	self endon("death");
//VectorToAngles( <vector> ) end - start
//AnglesToRight( <angles> )
//chopper pos + AnglesToRight( <angles> ) * units

	if(IsDefined(shoot_ai))
	{
		axis = GetAIArray("axis");
		in_fire_zone = GetEnt("e2_trig_heli_target", "targetname");
		targets = [];
		
		self.heli SetGunnerTurretOnTargetRange(0, 20);

		self.heli thread fire_gunner(0);

		for(i = 0; i < 3; i++)
		{
			self.heli SetGunnerTargetVec( self.shoot_origins[shoot_ai].origin, 0 );	
			//self.heli waittill("gunner_turret_on_target");
			
			wait 3;

			//super custom target@!
			self.heli SetGunnerTargetVec( self.shoot_origins[5].origin, 0 );	
			//self.heli waittill("gunner_turret_on_target");

			wait 3;
		}
		
		self.heli notify("stop_gunner_shoot");

	}
	else
	{
		//target = random(self.shoot_origins);
		//self.heli SetLookAtEnt( target );
		//self.heli SetTurretTargetEnt( target );
	}
}

//self is heli
fire_gunner(index)
{
	level.player endon("death");
	self endon("death");
	self endon("stop_gunner_shoot");

	while( 1 )
	{
		self FireGunnerWeapon( index );
		wait 0.55;
	}
}

//self is level
heli_cleanup(heli_data)
{
	//delete target origins
	for(i = 0; i < heli_data.shoot_origins.size; i++)
	{
		heli_data.shoot_origins[i] Delete();
	}

	//delete script model crew
	for(i = 0; i < heli_data.heli_crew.size; i++)
	{
		heli_data.heli_crew[i] Delete();
	}

	//delete chopper
	heli_data.heli Delete();
}

event2_amb_mortarstrikes()
{
	level._explosion_stopNotify["e2_mortar_struct"] = "stop_e2_mortar_struct";

	//mortar_loop( mortar_name, barrage_amount, no_terrain )
	level thread maps\_mortar::mortar_loop("e2_mortar_struct", 1);

	//set_mortar_range( mortar_name, min_range, max_range, set_default )
	level thread maps\_mortar::set_mortar_range("e2_mortar_struct", 384, 2560);
	
	//set_mortar_damage( mortar_name, blast_radius, min_damage, max_damage, set_default )
	level thread maps\_mortar::set_mortar_damage("e2_mortar_struct", 128, 100, 150);

	//set_mortar_delays( mortar_name, min_delay, max_delay, barrage_min_delay, barrage_max_delay, set_default )
	level thread maps\_mortar::set_mortar_delays("e2_mortar_struct", 3, 4, 3, 4);	
}

//self is spawner
narrows_set_rusher()
{
	self change_movemode("cqb_sprint");
	self.script_accuracy = 0.5;

	x = RandomFloatRange(1, 2);
	wait x;
	self thread maps\_rusher::rush("e2_stop_narrow_rushers");
}

narrows_non_rush()
{
	self change_movemode("cqb_sprint");
	self.script_accuracy = 0.5;
}

event2_sky_metal()
{
	trigger_wait("trig_heroes_color_0");

	level notify("sky_6");
	
	if(IsDefined(level.metal) && IsDefined(level.metal[6]))
	{
		array_delete(level.metal[6]);
	}

	huey_models = [];
	huey_models["side"] = "t5_veh_helo_huey_usmc";
	huey_models["interior"] = "t5_veh_helo_huey_att_interior";

	level thread sky_metal("e1_sky_metal_9", huey_models, 12, (-4000, -3000, 0), (4000, 3000, 4000), 300, 400, 2000, 7, "sky_7");

	wait(30);

	level notify("sky_7");
	array_delete(level.metal[7]);
}

event2_machine_gun_turret_dive()
{
	level.player endon("death");

	//flag_wait("obj_man_the_mg_complete");
	trigger_wait("e2_nva_dive");

	level thread delete_corpses_on_strengthtest();

	//this cleans up the opening read drones
	level notify("stop_setup_drone_yells"); //nukes the manager that creates yelling
	level notify("stop_drone_yells"); //nukes all VO created on drones
	level notify("stop_drone_speed_adjust"); //stops thread to adjust drone movement rate

	//remove_drone_structs(trigger, force_delete, wait_time)
	level thread remove_drone_structs(level.drone_trigger_intro, true, false);

	//if player bum rushes to this clean up AI behind us
	cleanup_first_bridge_ai();
	
		//TUEY - FOR AUDIO
	level clientnotify ("vca");
	
	//TUEY SET music state to VC_ATTACK
	setmusicstate ("VC_ATTACK");
		
	
	//start the strength test
	level.player maps\_strength_test::set_strength_test_audio( "evt_khe_nva_hth_start", "evt_khe_nva_hth_loop" );
	level.player maps\_strength_test::strength_test_start( "align_bridge_choke", "e3_spawner_mg_leaper", &"KHE_SANH_PROMPT_CHOKE_FLASH" );

	
	//stop e1 mortars
	level notify("e1c_stop_bunker_mortars");
	level notify("stop_e1c_trench_mortars");
	level thread e1_cleanup_structs();


	// check point
	autosave_by_name("e2_choke_out");
}

e1_cleanup_structs()
{
	mort_structs = getstructarray("e1c_trench_mortars", "targetname");
	x = getstructarray("e1c_bunker_mortars", "targetname");

	mort_structs = array_merge( mort_structs , x );
	for(i = 0; i < mort_structs.size; i++)
	{
		remove_drone_struct(mort_structs[i]); 
	}
}

//also handles event 1 marines
cleanup_first_bridge_ai()
{
	nva = GetAIArray("axis");
	e1c_guys = GetAIArray("allies");

	if(nva.size > 0)
	{
		for(i = 0; i < nva.size; i++)
		{
			if(IsDefined(nva[i]))
			{
				if(nva[i].targetname == "e2_bridge_nva_0_ai" || nva[i].targetname == "e2_start_guys_ai" || nva[i].targetname == "e2_spawner_0_ai")
				{
					nva[i] Delete();
				}
			}
		}
	}

	if(e1c_guys.size > 0)
	{
		for(i = 0; i < e1c_guys.size; i++)
		{
			if(IsDefined(e1c_guys[i]))
			{
				if(e1c_guys[i].targetname == "e1c_marine_spawner_ai")
				{
					e1c_guys[i] Delete();
				}
			}
		}
	}
}


timescale_gren_qte()
{
	//kill thread at start of event 3
	level endon("obj_trenches_with_woods_complete");

	level.nva_qte_timescale = 1.0;
	timescale_vel = -1.0;

	while (level.nva_qte_timescale > 0.35)
	{
		level.nva_qte_timescale += timescale_vel * 0.05;
		SetTimeScale(level.nva_qte_timescale);
		wait(0.05);
	}

	wait 0.5;

	while (level.nva_qte_timescale < 1.0)
	{
		level.nva_qte_timescale += 2.0 * 0.05;
		SetTimeScale(level.nva_qte_timescale);
		wait(0.05);
	}

}


cancel_anim_reach_hudson_melee(actors, node)
{
	node endon("can_start_anim");
	level endon("e2_u_cut_end");
	
	while(1)
	{
		if(!IsAlive(actors[0]))
		{
			actors[1] anim_stopanimscripted();
			break;
		}
		wait 0.05;
	}
}

event2_hudson_hand_2_hand()
{
	level.player endon("death");
	level endon("player_go_straight");

	trigger_wait("trig_enter_u_cut");

	//level waittill("set_hudson_melee");

	align_node = GetStruct("e2_woods_h2h", "targetname");

	// spawn the nva guy
	nva_actor = simple_spawn_single("e2_woods_h2h_nva");
	nva_actor.ignoreme = true;
	//nva_actor.ignoreall = true;
	nva_actor.animname = "h2h_hudson_nva";
	nva_actor.allowdeath = true;
	nva_actor.goalradius = 64;
	nva_actor thread reached_anim_watcher();
	//nva_actor.health = 10000;
	level.hudson_vic = nva_actor;
	
	// build actor array
	actors = [];
	actors[0] = nva_actor;
	actors[1] = level.squad["hudson"];
	
	hand_to_hand = false;
	timer = 0;
	
	if(IsDefined(actors[0]) && IsAlive(actors[0]))
	{
		level thread cancel_anim_reach_hudson_melee(actors, align_node);
		align_node anim_reach_aligned(actors, "h2h_hudson");
		actors[0].health = 10000;
		align_node notify("can_start_anim");
	//	align_node thread anim_single_aligned(actors, "h2h_hudson");
		level thread run_scene("e2_h2h_hudson");
	}

	align_node waittill("h2h_hudson");

	//if this flag is set and this thread is still active, this means the player went right then went straight
	//because this thread ends on the straight path
	//this trigger is a juncture between the straight path and the right path
	//if the player hits it regardless, all progression picks up at event2_exit_u_cut_hand_2_hand()
	if(!flag("e2_u_cut_end"))
	{
		trigger_use("trig_heroes_color_4");
		level.squad["woods"] enable_ai_color();
		level.squad["hudson"] enable_ai_color();

		remove_drone_struct(align_node);
	}
	else
	{
		//force_move_ai_to_apc();
	}
}

//self is nva
reached_anim_watcher()
{
	self endon("death");
	waittill_multiple_ents(self, "goal", level.squad["hudson"], "goal");
	flag_set("hudson_nva_reached");

}

//if the player reaches the end of the horshoe from eitehr direction always cook this off.
force_move_ai_to_apc()
{
	wait 0.05; //make sure that the path blocker is removed
	//send heroes to prior apc crush
	
	flag_wait("blocker_deleted");
	
	level.squad["woods"] anim_stopanimscripted();
	level.squad["hudson"] anim_stopanimscripted();

	trigger_use("trig_heroes_color_6");

	level.squad["woods"] disable_ai_color();
	level.squad["hudson"] disable_ai_color();

	wait 0.1;

	level.squad["woods"] enable_ai_color();
	level.squad["hudson"] enable_ai_color();
}

event2_exit_u_cut_hand_2_hand()
{
	//trigger_wait("e2_u_cut_end");
	flag_wait("e2_u_cut_end");

	level thread event2_nva_leaper();

	force_move_ai_to_apc();

	//align_node1 = GetStruct("e2_exit_u_cut_h2h_1", "targetname");

	//nva_actor1 = simple_spawn_single("e2_u_cut_end_h2h_nva1");
	//nva_actor1.animname = "h2h_guy_01";
	//nva_actor1.allowdeath = true;

	//marine_actor1 = simple_spawn_single("e2_u_cut_end_h2h_marine1");
	//marine_actor1.animname = "h2h_guy_02";

	//actors1 = array(nva_actor1, marine_actor1);

	//align_node1 thread anim_loop_aligned(actors1, "hand2hand_a");

	// Up the road a bit...we find 2 more soldier...furiously battling...lets find out how its going. 

	align_node2 = GetStruct("e2_exit_u_cut_h2h_2", "targetname");

	nva_actor2 = simple_spawn_single("e2_u_cut_end_h2h_nva2");
	nva_actor2.animname = "h2h_guy_01";
	nva_actor2.allowdeath = true;

	marine_actor2 = simple_spawn_single("e2_u_cut_end_h2h_marine2");
	marine_actor2.animname = "h2h_guy_02";

	actors2 = array(nva_actor2, marine_actor2);

	align_node2 thread anim_loop_aligned(actors2, "hand2hand_c");

	nva_actor2 waittill("damage");
	marine_actor2 ragdoll_death();
}

event1_cleanup_setup()
{
	level.player endon("death");
	trigger_wait("trig_e2_first_bridge");
	
	level thread event1_cleanup();

}

event1_cleanup()
{
	event1_ents = [];

	spawners_trigs = GetEntArray("e1_cleanup_ents", "script_noteworthy");
	huey_troops = GetEntArray("huey_troops", "script_noteworthy");
	huey_pilot = GetEnt("hero_huey_pilot", "targetname");
	huey_copilot = GetEnt("hero_huey_copilot", "targetname");
	e1c_items = GetEntArray("e1c_trench_spawners", "script_noteworthy");

	event1_ents = array_add(event1_ents, huey_pilot);
	event1_ents = array_add(event1_ents, huey_copilot);

	event1_ents = array_combine(spawners_trigs, huey_troops);
	event1_ents = array_combine(event1_ents, e1c_items);

	if(event1_ents.size > 0)
	{
		event1_ents = array_removeUndefined( event1_ents );
		array_delete( event1_ents );
		event1_ents = array_removeUndefined( event1_ents );
	}
}

event2_threatbiasgroups()
{
	//SetIgnoreMeGroup("player", "shoot_redshirt");
	//SetIgnoreMeGroup("ally_squad", "shoot_player");

	level.player setThreatBiasGroup( "player" );
	level.squad["woods"] setThreatBiasGroup( "ally_squad" );
	level.squad["hudson"] setThreatBiasGroup( "ally_squad" );

	//This is the base threat of group1 against group2, which translates to how much entities in group2 will favor entities in group1.	
	SetThreatBias("player", "shoot_player", 1000);
	SetThreatBias("ally_squad", "shoot_redshirt", 1000);
	SetThreatBias("player", "shoot_redshirt", 500);//-1000
	SetThreatBias("ally_squad", "shoot_player", 500);//-1875
}

setup_allies()
{
	self magic_bullet_shield();
	self setThreatBiasGroup( "ally_squad" );
}

ally_bias()
{
	self setThreatBiasGroup( "ally_squad" );
}

start_guys_think_player_group()
{
	self.ignoresuppression = true;
	self disable_long_death();
	self setThreatBiasGroup( "shoot_player" );
	self thread start_guys_think();
}

start_guys_think_ally_group()
{
	self.ignoresuppression = true;
	self disable_long_death();
	self SetThreatBiasGroup("shoot_redshirt");
	self thread start_guys_think();
}

house_guys_set_bias()
{
	self SetThreatBiasGroup("shoot_redshirt");
	self.script_accuracy = 0.5;
}

set_suppression_off()
{
	self.ignoresuppression = true;
}

delete_corpses_on_strengthtest()
{
	corpses = [];
	corpses = EntSearch(level.CONTENTS_CORPSE, level.player.origin, 500);
	if(corpses.size > 0)
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(IsDefined(corpses[i]))
			{
				corpses[i] Delete();
			}
		}
	}
}

//////////////////////////////////////////////////////////
//
// khe_sanh_event3.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_flyover_audio;
#include maps\_music;
#include maps\_objectives;
#include maps\_scene;


main()
{
	flag_wait("start_e3_thread");
	init_flags();

	event3_intro();
}

init_flags()
{
	flag_init("trans_to_event4");
	flag_init("end_drone_swap");
	flag_init("player_has_detonator");
	flag_init("player_has_detonator_two");
	flag_init("player_fired_detonator");
	flag_init("woods_triggers_drums");
	flag_init("woods_crosses_bridge");
	flag_init("event3_cleanup_start");

	flag_init("pause_swapper");

	flag_init("e3_shoot_player");
	flag_init("gun_hint_displayed");

		//from 2
	flag_init("huey_strafe_1_done");

	flag_init("holding_detonator");

	level.drum_success = false;
}

event3_intro()
{
	//no FF for this section
	level.friendlyFireDisabled = 1;

	level.drone_swapper = [];
	level.drone_threads = 0;
	level.DRONE_SWAP_CAP = 9;
	level.TIME_ON_MG = 15;
	level.TIME_ON_CHINA = 33;

	//hide all the blown drums
	blown_drums = GetEntArray("blown_drum", "script_noteworthy");

	for(i = 0; i < blown_drums.size; i++)
	{
		blown_drums[i] Hide();
	}

	level.law_woods = GetEnt("law_rockets_woods", "targetname");
	level.law_woods Hide();

	////START JUMP TO SETUP
	if(!IsDefined(level.apc_actor))
	{
		level.apc_actor = spawn_anim_model("apc_to_crush", (-7422.3, -1346.9, 168.6), (4.931, 297.518, 1.376));//apc_start_spot.origin, apc_start_spot.angles, true);
		level.apc_actor Attach("t5_veh_m113_sandbags", "body_animate_jnt");
		level.apc_actor Attach("t5_veh_m113_outcasts_decals", "body_animate_jnt");		
		level.apc_actor.animname = "apc_to_crush"; //(1.376, 4.931, 297.518)

		level anim_single(level.apc_actor, "apc_crush_end");

		level.apc_brush = GetEnt("brush_apc_clip", "targetname");
		level.apc_brush MoveTo(level.apc_brush.origin + (0, 0, -32), 1.5);		
	}

	//if(!IsDefined(level.heli_support.heli))
	if(IsDefined(level.event3_jumpto) && level.event3_jumpto)
	{
		level maps\khe_sanh_event2::setup_huey_ai_support();
		wait 1;
	}

	////END JUMP TO SETUP

	level.squad["woods"].ignoresuppression = true;
	level.squad["hudson"].ignoresuppression = true;
	level.squad["woods"].goalradius = 64;
	level.squad["hudson"].goalradius = 64;
	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;	
	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");

/#
	level thread debug_enemies();
#/
	//cleanup of event 2 ents in radiant
	//should be called after helicopter creation for jump
	level thread event2_cleanup_setup();

	//cleanup progression of stuff spawned
	level event2_spawned_cleanup();

	//set up objective glow for law
	level thread setup_law_objective();

	if(!level.e3b_jumpto)
	{
		//woods does his drume event
		level event3_woods_fougasse_drum();	

		level thread event3_woods_trans_to_defend();

		autosave_by_name("e3_woods_drums_done");

		level thread event3_player_use_fougasse_one();

		//this is the shirtless marine getting headshotted
		level thread event3_vignette_mg_death();

		wait 0.5;
		//check success or fail so we don't try to save during a level restart
/*
		if(level.drum_success)
		{
			level.drum_success = false;
			autosave_by_name("e3_woods_drums_one_done");
		}
*/
		level thread event3_player_use_fougasse_two();
/*
		//check success or fail so we don't try to save during a level restart
		if(level.drum_success)
		{
			level.drum_success = false;
			autosave_by_name("e3_player_drums_done");
		}
*/
		//woods and hudson move to the chinalake bunker
		level event3_trans_to_china();

		//shoot infantry for 30 secs
		level event3_hold_the_line();

		flag_wait("obj_hold_the_line_complete");

		//save check point
		autosave_by_name("e3_tank_start");
	}
	else
	{
		//set flags
		flag_set("obj_cover_woods");
		flag_set("obj_cover_woods_complete");
		flag_set("obj_hold_the_line");
		flag_set("obj_hold_the_line_complete");		
	}

	//starts the tank phase of the battle: allow friendly fire again since it is mroe open
	level.friendlyFireDisabled = 0;
	level event3_tank_phase();

	flag_wait("all_tanks_spawned");

	//if any tank dies move woods and hudson near the end
	level thread event3_move_woods_near_end();
	
	//sets up the gate to event 4
	level thread setup_hatch_marine();

	//wait until all tanks are killed
	array_wait( level.e3_t55_tank, "death" );

	//all tanks dead
	flag_set("obj_defeat_the_tanks_complete");

	//set new objective
	flag_set("obj_rally_bunker");

	//enemies are now repelled and only have nodes outside the trench
	trigger_use("trig_color_trench_2", "targetname");
	
	//end event with big 'splosions and air metal
	level event3_cavalry_arrives();

}

event3_woods_fougasse_drum()
{
	//trigger_wait("trig_player_prone", "targetname");
	flag_wait("trig_player_prone");

	//allows for drone speeds to vary
	level thread drone_speed_adjust();

	//starts opening battle
	flag_set("obj_trenches_with_woods_complete");
	flag_set("obj_cover_woods");
	
	level.player endon("death");
	align_node = GetEnt("align_woods_drum", "targetname");

	//these create the first couple of marines that are with you
	level thread event3_fougasse_blockers();

	//spawners
	array_thread(GetEntArray("e2_spawner_trans_def", "targetname"), ::add_spawn_function, ::fougasse_spawners_think);
	level spawn_manager_enable("trig_e2_spawn_mgr_6");
	activate_trigger_with_targetname("e3_colors_woods_drum");
	
	wait 0.15;

	//high detail drones to player
	level.drone_trigger_woods_drums = GetEnt("e3_trig_drone_woods_drums", "script_noteworthy");
	level.drone_trigger_woods_drums activate_trigger();
	
	//setup_drone_yells(all_drones, interval_wait, wait_min, wait_max, vox_weight_min, vox_weight_max, vox_weight_median)
	level thread setup_drone_yells(undefined, 4, 2, 4);

	//player has gone prone under APC. start fougasse
	trigger_wait("trig_woods_drum_start", "targetname");

	//turn OFF ambient effects First bunker to first M113
	//stop_exploder(20);

	level thread heli_fougasse();

	//send hudson forward
	level.squad["hudson"] set_goal_node(GetNode("node_hudson_drum", "targetname"));

	//waits for flag set from anim notetrack
	level thread event3_woods_drum_activation();
	
	battlechatter_off("allies");
	//level.squad["woods"] LookAtEntity(level.player);
	level.squad["woods"] thread anim_single(level.squad["woods"], "cover_me");//"Give me cover!"

	align_node anim_reach_aligned(level.squad["woods"], "detonate_drum");

	level.squad["woods"] Attach("weapon_c4_detonator", "TAG_INHAND");
	//align_node anim_single_aligned(level.squad["woods"], "detonate_drum");
	run_scene("wood_kick_drum");

	level.squad["woods"] Detach("weapon_c4_detonator", "TAG_INHAND");
	battlechatter_on("allies");
}

event3_fougasse_blockers()
{
	level.player endon("death");
	
	array_thread(GetEntArray("e3_woods_blockers", "script_noteworthy"), ::add_spawn_function, ::blockers_ai_think);
	
	//guy by woods and hudson
	redshirt = simple_spawn_single("e3_marine_fougasse");

	//guys by bridge
	blockers = [];
	for(i = 0; i < 2; i++)
	{
		blockers[i] = simple_spawn_single("e3_marine_blocker_0");
	}

	//flag_wait("woods_crosses_bridge");
}

//self is ai blocker
blockers_ai_think()
{
	self endon("death");

	self.goalradius = 64;
	self magic_bullet_shield();
	self change_movemode("cqb_sprint");

	flag_wait("woods_crosses_bridge");
	self stop_magic_bullet_shield();
	//self reset_movemode();
}

fougasse_spawners_think()
{
	self.ignoresuppression = true;
	self.goalradius = 128;
	self.script_accuracy = 0.35;
	self change_movemode("cqb_sprint");
	//self thread maps\_rusher::rush();
}

heli_fougasse()
{
	level.heli_support.heli endon("death");
	level.heli_support maps\khe_sanh_event2::heli_ai(level.HELI_MOVE, 7);

	//shoot origin 5 is being used at the house GUNNER SHOOT
	//this means flight structs and shoot origins are now out of sync
	level.heli_support.heli.mod_pitch = 13;
	level.heli_support maps\khe_sanh_event2::heli_ai(level.HELI_SHOOT, 6);

	wait 1;

	level.heli_support.heli.mod_pitch = 10;
	level.heli_support maps\khe_sanh_event2::heli_ai(level.HELI_SHOOT, 7);
}

event3_woods_trans_to_defend()
{
	align_node =  GetEnt("align_woods_keeps_moving", "targetname");
	rpg_shooter = simple_spawn_single("e2_nva_rpg_shoot_cobra");
	rpg_shooter.ignoreall = true;
	rpg_shooter.ignoreme = true;
	rpg_shooter.a.rockets = 1000;
	rpg_shooter magic_bullet_shield();

	brush_block = GetEnt("e3_bridge_blocker", "targetname");
	brush_block Delete();

	level thread event3_huey_strafe_crash();
	level thread move_heroes_to_player_drum();

	level waittill("huey_ready_to_die");

	//todo fix why this guy isnt hitting.
	rpg_shooter thread shoot_at_target(level.heli_support.heli, "tag_front_glass", 0, 5);
	start = GetEnt("origin_cobra_target_1", "targetname");//rpg_shooter GetTagOrigin("tag_flash");
	MagicBullet("rpg_sp", start.origin, level.heli_support.heli.origin + (0,0,-15));

	rpg_shooter stop_magic_bullet_shield();

	//waits for huey to crash
	//flag_wait("huey_strafe_1_done");

	//stop mortars for event 2
	level notify("stop_e2_mortar_struct");

	if(IsDefined(rpg_shooter))
	{
		rpg_shooter.ignoreall = false;
		rpg_shooter.ignoreme = false;
	}

	//waittill_spawn_manager_cleared("trig_e2_spawn_mgr_6");
	//level.squad["woods"] thread set_ignore_to_goal();

	//level.squad["woods"] set_goal_node(GetNode("node_woods_defend_loc", "targetname"));
	//level.squad["hudson"] set_goal_node(GetNode("node_hudson_defend_loc", "targetname"));

	//level.squad["woods"] waittill("goal");
	//run towards fougasse one
}

move_heroes_to_player_drum()
{
	//player detonator 1
	level.squad["woods"] thread set_ignore_to_goal();
	level.squad["woods"] set_goal_node(GetNode("node_woods_defend_loc", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("node_hudson_defend_loc", "targetname"));

	//move allies forward
	trigger_use("trig_allies_color_nodes_0", "targetname");

	trigger = GetEnt("trig_play_fougasse_one", "targetname");

	//objective
	flag_set("obj_cover_woods_complete");

	while(!level.squad["woods"] IsTouching(trigger))
	{
		wait 0.05;	
	}

	flag_set("woods_crosses_bridge");

	//dialouge
	level thread anim_single(level.squad["woods"], "fougasse_one_start"); //"Here they come, Mason."

	trigger Delete();

	//activate first batch of allies and first stage colors
	level spawn_manager_enable("trig_spawn_mgr_redshirt_0");
	//trigger_use("trig_allies_color_nodes_0", "targetname");

	//enables leapers when going to two
	level thread event3_trans_to_fougasse_two();

	//move to drum two
	level.squad["woods"] set_goal_node(GetNode("node_woods_fougasse_two", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("node_hudson_fougasse_two", "targetname"));
}

event3_player_use_fougasse_one()
{
	level.player endon("death");
	//no longer eligible if tank event starts
	level endon("obj_hold_the_line_complete");

	level.detonator_obj_0 = GetEnt("e3_detonator_obj_prop", "targetname");
	
	//wait til the player has touched grab trigger
	trigger_wait("trig_use_fougasse", "targetname");
	//set up watcher for detonator grab
	level thread grab_detonator(level.detonator_obj_0, "trig_use_fougasse", "player_has_detonator");

	//wait until the player is holding the detonator
	flag_wait("player_has_detonator");

	//trap timers
	level thread fougasse_fail_timer(1);

	//clears pickup detonator 3d objective
	fougasse_obj_cleanup(0);
	
	//TURNS ON BODIES TO BURN
	//enable spawner for player first fougasse
	array_thread(GetEntArray("e3_wave_0", "targetname"), ::add_spawn_function, ::fougasse_spawners_think);
	level spawn_manager_enable("e3_spawn_mgr_0");

	level thread fougasse_spawner_pause_manager("e3_spawn_mgr_0");

	wait 0.5;

	//high detail drones to player
	level.drone_trigger_player_drums_one = GetEnt("e3_trig_drone_player_drums_one", "script_noteworthy");
	level.drone_trigger_player_drums_one activate_trigger();

	while( !level.player AttackButtonPressed() )
	{
		wait 0.05;
	}	

	flag_set("player_fired_detonator");
	level.drone_speed_override = false;
	level.speed_mult = 0;

	//turn off drones for this area
	level thread remove_drone_structs(level.drone_trigger_player_drums_one, false, 20);
	//level.drone_trigger_player_drums_one Delete();

	//kill the spawn manager
	spawn_manager_kill("e3_spawn_mgr_0");
	
	//util that handles all the targets in the fire
	pristine = return_drum_type_array("prop_player_one_drums_pristine", undefined);
	blown = return_drum_type_array(undefined, "prop_player_one_drums_blown");
	level thread event3_fougasse_activation( "trig_player_fire_fougasse", pristine, blown, 340, blown );
	
	//custom vignette of guy crawling on fire
	level thread event3_crawl_burn_nva();
	
	//cleanup of weapon prop
	level.player TakeWeapon("creek_satchel_charge_sp");
	level.player TakeWeapon("knife_sp");
	level.player notify("giveback");
	level.player EnableWeaponCycling();
	level.player AllowPickupWeapons(true);

	wait 1;

	//clear flag so hold the line call to remove weapons is ok
	flag_clear("player_has_detonator");
	
	//allow drone swapper to resume
	flag_clear("pause_swapper");

	autosave_by_name("e3_woods_drums_one_done");
}

//self is level
event3_trans_to_fougasse_two()
{
	level.player endon("death");

	trigger = GetEnt("trig_trans_drums_leaper", "targetname");
	trigger waittill("trigger");
	trigger Delete();

	level.squad["woods"] thread anim_single(level.squad["woods"], "burn_em");//Burn 'em, Mason!

	mid_guys = [];
	mid_guys_spawner = GetEnt("e3_mid_leapers", "targetname");
	for(i = 0; i < 2; i++)
	{
		mid_guys_spawner.count++;
		mid_guys[i] = simple_spawn_single("e3_mid_leapers"); 
		mid_guys[i] thread maps\_rusher::rush();
		wait 1;
	}
}

//ugh 5 days before e3
event3_player_use_fougasse_two()
{
	level.player endon("death");
	//no longer eligible if tank event starts
	level endon("obj_hold_the_line_complete");

	level.detonator_obj_1 = GetEnt("e3_detonator_obj_prop_two", "targetname");

	//wait til the player has touched grab trigger
	trigger_wait("trig_use_fougasse_two", "targetname");
	//set up watcher for detonator grab
	level thread grab_detonator(level.detonator_obj_1, "trig_use_fougasse_two", "player_has_detonator_two");

	flag_wait("player_has_detonator_two");
	
	//trap timers
	level thread fougasse_fail_timer(2);

	//clears pickup detonator 3d objective
	fougasse_obj_cleanup(1);
	
	//enable spawner for player second fougasse
	array_thread(GetEntArray("e3_wave_1", "targetname"), ::add_spawn_function, ::fougasse_spawners_think);
	level spawn_manager_enable("e3_spawn_mgr_1");

	level thread fougasse_spawner_pause_manager("e3_spawn_mgr_1");

	wait 0.5;

	//high detail drones to player
	level.drone_trigger_player_drums_two = GetEnt("e3_trig_drone_player_drums_two", "script_noteworthy");
	level.drone_trigger_player_drums_two activate_trigger();

	while( !level.player AttackButtonPressed() )
	{
		wait 0.05;
	}	

	flag_set("player_fired_detonator");
	level.drone_speed_override = false;
	level.speed_mult = 0;

	//turn off drones for this area
	level thread remove_drone_structs(level.drone_trigger_player_drums_two, false, 20);
	//level.drone_trigger_player_drums_two Delete();

	spawn_manager_kill("e3_spawn_mgr_1");
	
	//util that handles all the targets in the fire
	pristine = return_drum_type_array("prop_player_two_drums_pristine", undefined);
	blown = return_drum_type_array(undefined, "prop_player_two_drums_blown");
	level thread event3_fougasse_activation( "trig_player_fire_fougasse_two", pristine, blown, 350, blown );
	
	//cleanup of weapon prop
	level.player TakeWeapon("creek_satchel_charge_sp");
	level.player TakeWeapon("knife_sp");
	level.player notify("giveback");
	level.player EnableWeaponCycling();
	level.player AllowPickupWeapons(true);

	//make sure the spawn manager for fougasse two has spawned all guys
	//waittill_spawn_manager_cleared("e3_spawn_mgr_1");
	wait 1;

	//clear flag so hold the line call to remove weapons is ok
	flag_clear("player_has_detonator_two");

	//allow drone swapper to resume
	flag_clear("pause_swapper");

	autosave_by_name("e3_player_drums_done");
}

fougasse_fail_timer(event_num)
{
	level.player endon("death");
	level endon("obj_hold_the_line_complete");

	timer = 0;
	WIN_TIME_START = 4;
	WIN_TIME_DURATION = WIN_TIME_START + 3;
	blow_it = false;
	play_fail_vo = false;
	show_text = false;
	
	//flag_wait("player_has_detonator");

	//screen_message_create(&"KHE_SANH_PROMPT_BARREL_DETONATE");

	//dialoge to wait one the player has the detonator
	//0 = wait; 1 = detonate; 2 = fail
	level.squad["woods"] thread fougasse_timer_dialogue(event_num, 0);

	while(1)
	{
		if(timer > WIN_TIME_START && !blow_it)
		{
			//0 = wait; 1 = detonate; 2 = fail
			level.squad["woods"] thread fougasse_timer_dialogue(event_num, 1);
			blow_it = true;
		}


		if(timer > WIN_TIME_START && timer < WIN_TIME_DURATION && !show_text)
		{
			show_text = true;
			screen_message_create(&"KHE_SANH_PROMPT_BARREL_DETONATE");
		}

		if(flag("player_fired_detonator"))
		{
			//win
			if(timer > WIN_TIME_START && timer < WIN_TIME_DURATION)
			{
				level.drum_success = true;
				wait 0.05;
				level.squad["woods"] thread fougasse_timer_dialogue(event_num, 4);//win VO
				break;
				//flag_clear("player_fired_detonator");
				//level notify("turn_off_fougasse_timer");
			}

			if( ( (timer > 0 && timer < WIN_TIME_START) || timer > WIN_TIME_DURATION ) && !play_fail_vo)
			{
				level.drum_success = false;
				//0 = wait; 1 = detonate; 2 = fail
				if(timer > 0 && timer < WIN_TIME_START) 
				{
					level.squad["woods"] thread fougasse_timer_dialogue(event_num, 2);//too early
				}
				else
				{
					level.squad["woods"] thread fougasse_timer_dialogue(event_num, 3);//too late
				}
				play_fail_vo = true;
				//StopAllRumbles();
				//missionFailedWrapper();
				break;				
			}
		}
		else
		{
/*			
			if(timer > WIN_TIME_DURATION && !play_fail_vo)
			{
				level.drum_success = false;
				//0 = wait; 1 = detonate; 2 = fail
				level.squad["woods"] thread fougasse_timer_dialogue(event_num, 3);//too late
				play_fail_vo = true;
				//StopAllRumbles();
				//missionFailedWrapper();
				break;
			}
*/
		}
	
		wait 0.05;
		timer += 0.05;
	}

	screen_message_delete();
	flag_clear("player_fired_detonator");
	flag_clear("holding_detonator");
}

//self is level.squad["woods"]
//picks a vo line depending on when the detonators are pulled
fougasse_timer_dialogue(event_number, vo_state)
{
	//level.squad["woods"] LookAtEntity(level.player);

	if(event_number == 1)
	{
		switch(vo_state)
		{
			
			case 0:
				self anim_single(self, "fougasse_one_wait"); //"Wait for it..."
				break;
			case 1:
				self anim_single(self, "fougasse_one_blow"); //"NOW!"	
				break;
			case 2:
				self anim_single(self, "fougasse_one_fail"); //"Shit, too early! They're still coming!"
				wait 0.15;
				self anim_single(self, "drum_one_recover"); //This shit ain't over yet... Let's go!
				break;
			case 3:
				self anim_single(self, "fougasse_two_fail"); //"Too late, Mason! They're almost on us!"
				wait 0.15;
				self anim_single(self, "drum_one_recover"); //This shit ain't over yet... Let's go!
				break;
			case 4:
				self anim_single(self, "fougasse_stragglers");//"Pick off the stragglers!"
				break;
			default:
				break;
		}

	}
	else if(event_number == 2)
	{
		switch(vo_state)
		{
		case 0:
			self anim_single(self, "fougasse_two_wait"); //"Not yet."
			break;
		case 1:
			self anim_single(self, "fougasse_two_blow"); //"Blow it Mason!"
			break;
		case 2:
			self anim_single(self, "fougasse_one_fail"); //"Shit, too early! They're still coming!"
			wait 0.15;
			self anim_single(self, "drum_two_recover"); //Pull back! Pull back!
			break;
		case 3:
			self anim_single(self, "fougasse_two_fail"); //"Too late, Mason! They're almost on us!"
			wait 0.15;
			self anim_single(self, "drum_two_recover"); //Pull back! Pull back!
			break;
		case 4:
			self anim_single(self, "fougasse_good");//Good kill!
			break;
		default:
			break;
		}
	}

	//level.squad["woods"] LookAtEntity();
}

//pauses the spawn managers for the player detonators if there are currently too many swapper AI in the scene
//needed to keep ai counts below 20
fougasse_spawner_pause_manager(spawner_name)
{
	level endon("player_fired_detonator");
	level endon("obj_hold_the_line_complete");

	x = level.DRONE_SWAP_CAP * 0.3;
	set_pause = false;

	while(1)
	{
		if(level.drone_swapper.size > x && !set_pause)
		{
			set_pause = true;
			spawn_manager_disable(spawner_name);
		}

		if(level.drone_swapper.size < x && set_pause)
		{
			set_pause = false;
			spawn_manager_enable(spawner_name);
		}

		wait 0.05;
	}
}

//argh going from using heli ai into messy custom stuff
event3_huey_strafe_crash()
{
	//get totals
	total_flight_structs = getstructarray("struct_cobra_flight", "script_noteworthy");
	total_shoot_origins = GetEntArray("origin_cobra_target","script_noteworthy");

	cobra_flight_pts = [];
	cobra_shoot_pts = [];

	//fill struct flight and targets array in order by targetname
	for(i = 0; i < total_flight_structs.size; i++)
	{
		cobra_flight_pts[i] = getstruct("struct_cobra_flight_" +i, "targetname");
	}

	for(i = 0; i < total_shoot_origins.size; i++)
	{
		cobra_shoot_pts[i] = GetEnt("origin_cobra_target_" +i, "targetname");
	}

	wait 0.05;

	//move to point
	level.heli_support.heli SetVehGoalPos( cobra_flight_pts[0].origin, true );
	level.heli_support.heli SetLookAtEnt( cobra_shoot_pts[0] );
	level.heli_support.heli waittill("goal");
	
	//strafe to next point
	level.heli_support.heli SetVehGoalPos( cobra_flight_pts[1].origin, true );
	level.heli_support.heli SetLookAtEnt( cobra_shoot_pts[1] );
	level.heli_support.heli.goalradius = 1;
	level.heli_support.heli waittill("goal");

	//rpg guys hoots
	level notify("huey_ready_to_die");

	level.heli_support.heli notify("huey_stop_shooting");
	
	wait 1;
	
	//when anims are ready use this logic
	align_node = GetEnt("align_e3_huey_crash", "targetname");
	
	//create script model helicopter
	PlayFXOnTag(level._effect["fx_ks_aerial_exp_sm"], level.heli_support.heli, "tag_front_glass");
	
	level.heli_support.heli SetDefaultPitch( 0 );
	level.heli_to_crash = spawn_anim_model("huey_guard", level.heli_support.heli.origin);
	//hard code the position/facing of the chopper. so we always get a good spot behind the hill. 
	//i think the position of the align node got moved in the map. Took a samples of the last pos/angles of the vehicle before crashing to get these values
	level.heli_to_crash.origin = (-8258, -2182, 654);
	level.heli_to_crash.angles = (5.4959, -14.3543, -8.33883);
	level.heli_to_crash Attach("t5_veh_helo_huey_att_interior", "tag_body");
	level.heli_to_crash Attach("t5_veh_helo_huey_att_decal_usmc_hvyhog", "tag_body");
	level.heli_to_crash Attach("t5_veh_helo_huey_att_usmc_m60", "tag_body");
	level.heli_to_crash Attach("t5_veh_helo_huey_att_rockets_usmc", "tag_body");

	//fx for explosion
	level.heli_to_crash.chopper_fx = Spawn("script_model", level.heli_to_crash.origin);
	level.heli_to_crash.chopper_fx.angles = level.heli_to_crash.angles;
	level.heli_to_crash.chopper_fx SetModel("tag_origin");
	level.heli_to_crash.chopper_fx LinkTo(level.heli_to_crash, "tag_origin");

	PlayFXOnTag(level._effect["huey_rotor"], level.heli_to_crash, "main_rotor_jnt");
	PlayFXOnTag(level._effect["fx_cobra_fire"], level.heli_to_crash, "origin_animate_jnt");

	//vo and landing explosion threads
	level thread chopper_dead_vo();
	level thread huey_death_explosion(level.heli_to_crash);

	//delete old chopper
	level.heli_support maps\khe_sanh_event2::heli_ai(level.DELETE_ME);
	
	//notifies the clientscript to play the crashing sound
	level.heli_to_crash SetClientFlag( 0 );

	//play crash anim
	level.heli_to_crash anim_single(level.heli_to_crash, "huey_guard_crash");

	level.heli_to_crash ClearClientFlag( 0 );

	//cleanup the ents for targetting
	for(i = 0; i < total_shoot_origins.size; i++)
	{
		total_shoot_origins[i] Delete();
	}

	//cleanup ents
	ents = array(level.heli_to_crash.chopper_fx, align_node, level.heli_to_crash);
	array_delete(ents);

	flag_set("huey_strafe_1_done");
}

//running some radio chatter on player
chopper_dead_vo()
{
	level.player.animname = "hero_huey";
	level.player anim_single(level.player, "line_5");//God damn it.
	level.player anim_single(level.player, "line_6");//May day, may day.
}

//self is exploding huey
huey_death_explosion(chopper)
{
	level endon("huey_strafe_1_done");

	while(chopper.chopper_fx.origin[2] > 380)
	{
		wait 0.05;
	}

	PlayFXOnTag(level._effect["fx_cobra_explode"], chopper.chopper_fx, "tag_origin");
	chopper.chopper_fx playsound ("evt_chopper_crash_explosion");
}

event3_move_woods_near_end()
{
	level.player endon("death");

	//if any tank dies move wods and hudson
	array_wait_any( level.e3_t55_tank, "death" );		

	level.squad["woods"] set_goal_node(GetNode("e3_woods_law_1", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("e3_hudson_law_1", "targetname"));
}

event3_tank_phase()
{
	level.law_woods Show();

	//level.squad["woods"] LookAtEntity(level.player);

	level.squad["woods"] anim_single(level.squad["woods"], "tank_start");//"Tanks on the way!"

	wait 0.5;
	level.squad["woods"] anim_single(level.squad["woods"], "tank_intro");//"Shit... We got armor moving up - Russian T-55s!"

	//level.squad["woods"] anim_single(level.squad["woods"], "tank_intro_china");//"That China lake ain't gonna cut it!"
	level.squad["woods"] anim_single(level.squad["woods"], "tank_intro_china_b");//"WOODS: ^7We need something bigger."
	level.squad["woods"] thread anim_single(level.squad["woods"], "tank_intro_follow");//"On me..."
	//level.squad["woods"] LookAtEntity();

	ramp_blocker = GetEntArray("e3_ramp_blocker", "targetname");

	//bunker house initial dust
	//Exploder(361);
	//Exploder(362);

	//sandbags exploder
	//Exploder(370);
	level thread maps\_shellshock::main(level.player.origin, 3, 256, 0, 0, 0, undefined, "default", 0);
	Earthquake(0.65, 1, ramp_blocker[0].origin, 200, level.player);
	level thread custom_rumble(0.02, 18);

	for(i = 0; i < ramp_blocker.size; i++)
	{
		ramp_blocker[i] ConnectPaths();
		ramp_blocker[i] Delete();
	}

	level thread event3_heroes_to_law();

	//start tank objective
	flag_set("obj_defeat_the_tanks");

	//two trigs providing max rpg ammo
	run_thread_on_targetname( "trig_m72_law_ammo", ::provide_m72_law_ammo );
	
	//total AI for swapper reduced by 3 at the start of tank event
	level.DRONE_SWAP_CAP = 5;

	//turn off background drones
	level thread remove_drone_structs(level.drone_trigger_defend_b, false, 20);

	level thread event3_finale_airmada();
	level thread setup_tanks();
	level thread setup_bunker_exploders();
	level thread manage_corpse_delete();
}

event3_heroes_to_law()
{
	level.squad["woods"] set_goal_node(GetNode("e3_woods_law_0", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("e3_hudson_law_0", "targetname"));

	level.squad["woods"] anim_single(level.squad["woods"], "nva_bold");//"Soviet Armor... No wonder the NVA's gettin' bold."

	level.squad["woods"] waittill("goal");

	//level.squad["woods"] LookAtEntity(level.player);
	level.squad["woods"] anim_single(level.squad["woods"], "get_on_law");//"Here - this LAW rocket will burst 'em wide open."
	//level.squad["woods"] LookAtEntity();

	level thread law_nag();
}

law_nag()
{
	level.player endon("death");

	timer = 0;

	while(1)
	{
		if(level.player GetCurrentWeapon() != "m72_law_magic_bullet_sp" && timer >= 5)
		{
			//level.squad["woods"] LookAtEntity(level.player);
			level.squad["woods"] anim_single(level.squad["woods"], "law_nag");//"Grab that LAW, Mason!"
			//level.squad["woods"] LookAtEntity();
			break;
		}

		if(timer > 7)
		{
			break;
		}

		timer++;
		wait 1;
	}
}

#using_animtree("khesanh");
setup_hatch_marine()
{
	align_node = GetEnt("align_e3_trap_door","targetname");

	trapdoor_origin = GetStartOrigin(align_node.origin, align_node.angles, %o_khe_e3_woods_trap_door_door);
	trapdoor_angles = GetStartAngles(align_node.origin, align_node.angles, %o_khe_e3_woods_trap_door_door);
	level.trap_door = spawn_anim_model("e3_trap_door", trapdoor_origin, trapdoor_angles, true);
	level.trap_door Hide();

	level.trap_door.player_clip = GetEnt("hatch_player_clip","targetname");
	level.trap_door.player_clip trigger_off();
	level.trap_door.clip = GetEnt("trapdoor_clip","targetname");
	level.trap_door.fake = GetEnt("brush_trapdoor","targetname");
	level.trap_door.fake LinkTo(level.trap_door.clip );
	
	level.marine_trap_door = simple_spawn_single("spawner_marine_trapdoor");
	level.marine_trap_door magic_bullet_shield();
	level.marine_trap_door.animname = "marine_trap_door";
	level.marine_trap_door.ignoreme = true;
	level.marine_trap_door.ignoreall = true;
	level.marine_trap_door.grenadeAwareness = 0;
	level.marine_trap_door disable_pain();
}

event3_cavalry_arrives()
{
	//total AI for swapper reduced by 3 at the start of tank event
	level.DRONE_SWAP_CAP = 2;

	level thread event3_cleanup_setup();
	
	level thread spawn_manager_enable("trig_spawn_mgr_redshirt_1");
	
	//stop speed adjust thread on drones
	level notify("stop_drone_speed_adjust");

	//allies have reclaimed the trench works
	trigger_use("trig_allies_color_nodes_3", "targetname");

	flag_wait("trans_to_event4");

	//FOR TUEY: end music as the guys are going into event 4
	setmusicstate ("END_TANKS");

	level.squad["woods"].ignoreall = true;
	level.squad["hudson"].ignoreall = true;
	level.squad["woods"] reset_movemode();
	level.squad["hudson"] reset_movemode();
	level.squad["woods"] reset_movemode();
	level.squad["hudson"] reset_movemode();
	level.squad["woods"] set_goal_node(GetNode("e3_woods_exit_0", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("e3_hudson_exit_0", "targetname"));
	//level.squad["woods"] waittill("goal");

	//trigger_wait("trig_player_in_exit_bunker", "targetname");

	flag_set("obj_rally_bunker_complete");

	align_node = GetEnt("align_e3_trap_door","targetname");

	//marines reaches to his door open anim and opens the hatch
	align_node anim_reach_aligned(level.marine_trap_door, "open_trap_door");
	align_node thread anim_single_aligned(level.trap_door, "open_trap_door");
	align_node thread anim_single_aligned(level.marine_trap_door, "open_trap_door");

	//show the animated prop and hide original
	wait(0.8);
	level.trap_door.fake Hide();
	level.trap_door.clip LinkTo(level.trap_door);
	level.trap_door Show();

	wait(1.1);
	if(level.player.origin[1] < -4500)
	{
		level.trap_door thread event3_freeze_hatch();
		level.marine_trap_door thread event3_freeze_marine();

		while(level.player.origin[1] < -4500)
		{
			wait(0.05);
		}

		level notify("unfreeze");

		level.trap_door.player_clip trigger_on();
		level.trap_door.player_clip LinkTo(level.trap_door);
	}

	//set marine to ready after anim
	level.marine_trap_door set_goal_node(GetNode("e3_hudson_exit_0", "targetname"));

	//move Hudson and Woods down and close the hatch door
	level thread event3_close_hatch();
 	
	//player has been to the bottom of the hatch
	flag_wait("flag_player_down_hatch");

	//keep on for e3 turning off at finale 
	flag_set("end_drone_swap");

	//cleanup exploders event 3
	//stop_exploder(330); //woosd drums
	//stop_exploder(340); //player drums 1
	//stop_exploder(350); //player drums 2
	//stop_exploder(390); //finale phantom drop 
}

#using_animtree("khesanh");
event3_freeze_hatch()
{
	door = self get_anim_ent();
	door SetAnim(%o_khe_e3_woods_trap_door_door, 1.0, 0.0, 0.0);
	level waittill("unfreeze");
	door SetAnim(%o_khe_e3_woods_trap_door_door, 1.0, 0.0, 1.0);
}

#using_animtree("generic_human");
event3_freeze_marine()
{
	self SetAnim(%ch_khe_e3_woods_trap_door_guy01, 1.0, 0.0, 0.0);
	level waittill("unfreeze");
	self SetAnim(%ch_khe_e3_woods_trap_door_guy01, 1.0, 0.0, 1.0);
}

event3_close_hatch()
{
	//this gets deleted by "trig_e3_cleanup"
	ladder_trig = GetEnt("trig_e3_ladder_trig", "targetname");

	//make buddies go down ladder one at a time
	level.squad["hudson"] set_goal_node(GetNode("e3_hudson_exit_1", "targetname"));

	//wait until hudson is halfway through the ladder then let woods go
	while(1)
	{
		if(level.squad["hudson"] IsTouching(ladder_trig))
		{
			break;
		}

		wait 0.05;
	}

	wait 0.25;
	level.squad["woods"] change_movemode("cqb_sprint");

	level.squad["woods"] set_goal_node(GetNode("e3_woods_exit_1", "targetname"));

	//woods should be halfway down the ladder
	while(1)
	{
		if(level.squad["woods"] IsTouching(ladder_trig))
		{
			break;
		}

		wait 0.05;
	}

	//delete ladder trig as it isn't needed anymore
	ladder_trig Delete();

	//player has been to the bottom of the hatch
	flag_wait("flag_player_down_hatch");

	//turn cqb back on
	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");

	wait(1.0);

	//close the hatch down and delete the anim model
	level.trap_door.fake Show();
	level.trap_door.clip Unlink();
	level.trap_door.clip RotateRoll(-125,1);
	level.trap_door Delete();

	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;
}

event3_cleanup_setup()
{
	level.player endon("death");

	//player has been to the bottom of the hatch
	flag_wait("flag_player_down_hatch");

	//KILL OF PRIMARY DRONES PRIOR TO PHANTOM DROP
	level thread remove_drone_structs(level.drone_trigger_defend, false, 20);
	//level.drone_trigger_defend Delete();

	//radio chatter
	level thread e3_e4_tunnel_vo();
	level thread e3_e4_tunnel_exploder();

	//turn OFF ambient effects First M113 to e3_e4 bunker
	//stop_exploder(30);

	//turn on ambient effects Downhill areas
	//Exploder(40);

	//level.player player_force_walk(true);

	flag_set("event3_cleanup_start");
	
	//dont generate any more drone yelling threads 
	level notify("stop_setup_drone_yells"); //nukes the manager that creates yelling
	level notify("stop_drone_yells"); //nukes all VO created on drones

	//send woods hudson to start of 4
	//level.squad["woods"] set_goal_pos(getstruct("struct_woods_start_e4", "script_noteworthy").origin);
	//level.squad["hudson"] set_goal_pos(getstruct("struct_hudson_start_e4", "script_noteworthy").origin);	
	level.squad["woods"] set_goal_node(GetNode("node_e4_start_woods", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("node_e4_start_hudson", "targetname"));


	spawn_manager_kill("trig_spawn_mgr_redshirt_0");
	spawn_manager_kill("trig_spawn_mgr_redshirt_1");

	ally_cleanup = GetAIArray("allies");
	nva_cleanup = GetAIArray("axis");

	//clean up the APC clip.
	if(IsDefined(level.apc_brush))
	{
		level.apc_brush Delete();
	}

	for(i = 0; i < ally_cleanup.size; i++)
	{
		ally_cleanup[i] disable_replace_on_death();
		//waittillframeend;
	}

	for(i = 0; i < ally_cleanup.size; i++)
	{
		if(IsDefined(ally_cleanup[i]) && !IsDefined(ally_cleanup[i].script_noteworthy))
		{
			ally_cleanup[i] Delete();
		}
	}

	for(i = 0; i < nva_cleanup.size; i++)
	{
		if(IsDefined(nva_cleanup[i]))
		{
			nva_cleanup[i] Delete();
		}
	}

	if(IsDefined(level.apc_cleanup) && level.apc_cleanup.size > 0)
	{
		array_delete(level.apc_cleanup);
	}

	//clean up leftover drones when going from 3-4
	drones = GetEntArray("drone", "targetname");

	for(i = 0; i < drones.size; i++)
	{
		if(IsDefined(drones[i]))
		{
			drones[i] thread maps\_drones::drone_delete();
		}
	}

	//tank target structs
	for(i = 0; i < level.tank_target_structs.size; i++)
	{
		remove_drone_struct(level.tank_target_structs[i]);
	}

	//cleanup all radiant ents
	level thread event3_cleanup();


	//delete the crash huey debris
	//level.huey_junk Delete();

	for(i = 0; i < level.e3_t55_tank.size; i++)
	{
		if(IsDefined(level.e3_t55_tank[i]))
		{
			level.e3_t55_tank[i] Delete();
		}
	}


	wait 1;
	cleanup_trig = GetEnt("trig_e3_cleanup", "targetname");
	cleanup_trig Delete();

	level.event3_doors = [];
	level.event3_doors[0] = level.trapdoor;
	level.event3_doors[1] = level.brush_block_ladder;


	autosave_by_name("start e4");
}

e3_e4_tunnel_vo()
{
	radio = GetEnt("e4_downhill_radio", "targetname");

	radio.animname = "b52_radio";

	radio anim_single(radio, "radio_line_0");//Grid pattern - Alpha-one-two and Alpha-one-six.
	radio anim_single(radio, "radio_line_1");//Arc Light, 10 minutes out.

	wait 1.5;

	radio.animname = "e4_radio";
	radio anim_single(radio, "radio_line_0");//One-seven, this is Red Rider. Over.
	wait 0.25;
	radio anim_single(radio, "radio_line_1");//What's your status please?
	wait 0.35;
	radio anim_single(radio, "radio_line_2");//Low on fuel. Inbound 2 minutes.
	radio anim_single(radio, "radio_line_3");//Stand fast, two-nine. You're covered. //cut "two-nine"
	wait 0.35;
	radio anim_single(radio, "radio_line_4");//Negative, I'm on final right now.
}

e3_e4_tunnel_exploder()
{
	level endon("stop_e3_e4_tunnel");
	level thread ambient_mortar_explosion("struct_e3_e4_mortar_", "e3_e4_mortar", 0.1, 1.75);
	
	while(1)
	{
		level waittill("mortar_inc_done");

		//ceiling dust
		//Exploder(399);

		wait 0.05;
	}

}

/////////////////////////////////////////////////////////////////////////////////////////
// Vignette Functions
/////////////////////////////////////////////////////////////////////////////////////////

//waits for flag set from anim notetrack
event3_woods_drum_activation()
{
	level.player endon("death");
	flag_wait("woods_triggers_drums");
	
	//TUEY Set music state to FUGAZIS BROTHER 
	//setmusicstate ("FOUGASSE_SECTION");
	
	//TUEY setting music state to Trench Defend
	level thread maps\_audio::switch_music_wait("FUGAZIS_BROTHER", 3);

	//delete high detail drones and blow scene
	level thread remove_drone_structs(level.drone_trigger_woods_drums, false, 30);

	//delete low detail drones
	level thread remove_drone_structs(level.drone_trigger_apc, false, 30);


	pristine = return_drum_type_array("prop_woods_drums_pristine", undefined);
	blown = return_drum_type_array(undefined, "prop_woods_drums_blown");

	flag_set("player_fired_detonator");
	level event3_fougasse_activation("trig_e3_burn_zone_woods", pristine, blown, 330);
	flag_clear("player_fired_detonator");
}

grab_detonator(detonator, trigger_name, flag_string)
{
	level.player endon("death");
	level endon("obj_hold_the_line_complete");

	trigger = GetEnt(trigger_name, "targetname");
	message = false;

	while(1)
	{
		if(!flag("holding_detonator"))
		{
			if(level.player use_button_held() && level.player istouching( trigger ))
			{
				break;
			}
			
			if(!message)
			{
				trigger_wait(trigger_name, "targetname");
				if(!flag("holding_detonator"))
				{
					level.player AllowPickupWeapons(false);
				}
			}

			if(!flag("holding_detonator"))
			{
				level.player SetScriptHintString( &"KHE_SANH_PROMPT_PICKUP_DETONATOR" );
				message = true;
			}

			if(message && !level.player istouching( trigger ))
			{
				//screen_message_delete();
				level.player SetScriptHintString("");
				level.player AllowPickupWeapons(true);
				message = false;
			}
		}
		
		wait 0.05;
	}

	level.drone_speed_override = true;
	level.speed_mult = 1.2;
	
	detonator Delete();

	flag_set(flag_string);
	flag_set("holding_detonator");
	
	//pause the drone swapper so we dont screw up frame rate with too many AI
	flag_set("pause_swapper");
	//screen_message_delete();
	level.player SetScriptHintString("");
	
	level.player AllowPickupWeapons(false);
	level.player thread take_and_giveback_weapons("giveback");
	level.player GiveWeapon("creek_satchel_charge_sp");
	level.player GiveWeapon("knife_sp");
	level.player SwitchToWeapon( "creek_satchel_charge_sp" );
	level.player DisableWeaponCycling();

	trigger Delete();
}

//grabs all drums and craters and swaps them. also activates fx
//#using_animtree( "generic_human" );
//TODO: CLEAN THIS UP; YOU PROBABLY DONT NEED EACH TIERED DISTANCE ANYMORE
event3_fougasse_activation(trigger, array_pristine, array_blown, exploder_int, blown)
{
	trigger = GetEnt(trigger, "targetname");
	DIST_CAP = 1024;
	DIST_CAP_SWAP = 1536;
	BURN_MODEL_CAP = 4;
	
	if(!IsDefined(level.burn_models))
	{
		level.burn_models = [];
	}

	//debug stuff
	level.burn_drone_count = 0;
	level.drone_in_swap = 0;
	level.drone_beyond_swap = 0;
	level.drone_low_delete = 0;
	level.drone_low_not_trig = 0;
	level.drone_remainder = 0;

	//clear out scrip models
	if(IsDefined(level.burn_models) && level.burn_models.size > 0)
	{
		array_delete(level.burn_models);
		level.burn_models = array_removeUndefined( level.burn_models );
	}

	if(IsDefined(array_pristine))
	{
		for(i = 0; i < array_pristine.size; i++)
		{
			array_pristine[i] ConnectPaths();
			array_pristine[i] Delete();
		}
	}
		
	if(IsDefined(array_blown))
	{
		for(i = 0; i < array_blown.size; i++)
		{
			array_blown[i] Show();
		}
	}
	if(IsDefined (blown))
	{
		for(i=0;i<blown.size;i++)
		{
			playsoundatposition ("exp_fougasse_mine_3D", blown[i].origin);
		}
	}
	else
	{
		playsoundatposition ("exp_fougasse_mine", (0,0,0));
		
	}

	//fire fx
	
	//exploder(exploder_int);
	//Earthquake( <scale>, <duration>, <source>, <radius>, <player> )
	Earthquake(0.85, 2, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 20);

	woods_fougasse_vics = GetAIArray("axis");
	drone_vics = GetEntArray( "drone", "targetname" );

	//spawned ai
	for (i = 0; i < woods_fougasse_vics.size; i++)
	{
		if (IsDefined(woods_fougasse_vics[i]) && woods_fougasse_vics[i] IsTouching(trigger))
		{
			woods_fougasse_vics[i] thread burn_me();
		}
	}
	
	//drones
	for(i = 0; i < drone_vics.size; i++)
	{
		if(IsDefined(drone_vics[i]))
		{
			if(drone_vics[i] IsTouching(trigger))
			{
				drone_dist = Distance2D( level.player.origin, drone_vics[i].origin );
	
				if(IsDefined(drone_vics[i].burn_drone) && drone_vics[i].burn_drone && drone_dist < DIST_CAP)
				{
					/#
						//blue
						//Debugstar(drone_vics[i].origin, 1000, (0,0,1));
					#/
					if(level.burn_models.size < BURN_MODEL_CAP)
					{
						burn_model = spawn_fake_character(drone_vics[i].origin, drone_vics[i].angles, "c_vtn_nva2");
						burn_model thread ragdoll_burn_model();
						level.burn_models = array_add(level.burn_models, burn_model);
					}
					level.burn_drone_count++;
					//drone_vics[i] notify("drone_death");
					drone_vics[i] thread maps\_drones::drone_delete();
				}
				
				//delete high drones in trigger but too far away and then swap them into script models that burn
				if(IsDefined(drone_vics[i].burn_drone) && drone_vics[i].burn_drone && (drone_dist > DIST_CAP && drone_dist < DIST_CAP_SWAP))
				{
					/#
						//green
						//Debugstar(drone_vics[i].origin, 1000, (0,1,0));
					#/		
					if(level.burn_models.size < BURN_MODEL_CAP)
					{
						burn_model = spawn_fake_character(drone_vics[i].origin, drone_vics[i].angles, "c_vtn_nva1");
						//burn_model UseAnimTree(#animtree);
						burn_model thread ragdoll_burn_model();
						level.burn_models = array_add(level.burn_models, burn_model);
					}

					level.drone_in_swap++;
					//drone_vics[i] notify("drone_death");
					drone_vics[i] maps\_drones::drone_delete();
				}

				if(IsDefined(drone_vics[i].burn_drone) && drone_vics[i].burn_drone && drone_dist > DIST_CAP_SWAP)
				{
					/#
						//black
						//Debugstar(drone_vics[i].origin, 1000, (1,1,1));
					#/	
					level.drone_beyond_swap++;
					//drone_vics[i] notify("drone_death");
					drone_vics[i] maps\_drones::drone_delete();
				}

				//low rez drones inside trigger get deleted if too far away
				if(!IsDefined(drone_vics[i].burn_drone) )//|| drone_dist > DIST_CAP)
				{
					/#
						//red
						//Debugstar(drone_vics[i].origin, 1000, (1,0,0));
					#/
					level.drone_low_delete++;
					//drone_vics[i] notify("drone_death");
					drone_vics[i] maps\_drones::drone_delete();
				}
			}
			else
			{
				//delete high detail drones outside of trigger
				if(IsDefined(drone_vics[i].burn_drone) && drone_vics[i].burn_drone)
				{
					/#
						//white
						//Debugstar(drone_vics[i].origin, 1000, (0,0,0));
					#/	
					level.drone_low_not_trig++;
					//drone_vics[i] notify("drone_death");
					drone_vics[i] maps\_drones::drone_delete();
				}	
			}
		}

		level.drone_remainder++;
	}

	trigger Delete();
}

#using_animtree( "generic_human" );
event3_crawl_burn_nva()
{
	align_node = GetEnt("align_e3_crawl_nva", "targetname");

	origin =  align_node.origin + AnglesToForward(align_node.angles) * -125;

	actor = spawn_fake_character(origin, align_node.angles, "c_vtn_nva1_char");
	//actor magic_bullet_shield();
	actor.animname = "fougasse_vic_0";
	//actor.script_animname = "fougasse_vic_0";
	actor UseAnimTree(#animtree);
	//actor.ignoreme = true;
	//actor stop_magic_bullet_shield();
	if( is_mature() )
	{
		actor SetClientFlag(level.SCRIPTMOVER_CHARRING); //scripmover flag not "actor" 
	}
	playsoundatposition ("chr_body_ignite", actor.origin);
	PlayFxOnTag( level._effect["character_fire_death_torso"], actor, "J_SpineLower" ); 

	//actor gun_remove();
	align_node anim_single_aligned(actor, "fougasse_crawl");

	 //run_scene("e3_fourgass_crawl");

	align_node Delete();
}

event3_trans_to_china()
{
	//this grabs the turret for the one woods will use
	//need to grab it here so that I can kick the player off if they are it when woods gets to it.
	level.woods_turret = GetEnt("e3_woods_mg_turret", "targetname");

	level.player endon("death");

	//triggers drones on defend section swapper set
	level.drone_trigger_defend = GetEnt("e3_trig_drone_axis_1", "script_noteworthy");
	level.drone_trigger_defend activate_trigger();

	//triggers ambient drones 
	level.drone_trigger_defend_b = GetEnt("e3_trig_drone_axis_2", "script_noteworthy");
	level.drone_trigger_defend_b activate_trigger();

	flag_set("obj_hold_the_line");
	
	//NEED to make sure e3_spawn_mgr_1 spawner from fougasse two has finished all spawning
	axis = GetAIArray("axis");
	//put remaining AI from starting spawner into swapper array 
	for(i = 0; i < axis.size; i++)
	{
		if(IsAlive(axis[i]))
		{
			axis[i] thread swapped_guy_monitor();
			level.drone_swapper[i] = axis[i];
		}
	}

	//start the drone convert thread
	level thread drone_swap_manager();

	//set enemy color inside trench line
	trigger_use("trig_color_trench_0", "targetname");

	//corresponding marine colors get pushed to middle
	trigger_use("trig_allies_color_nodes_1", "targetname");

	//level.player_turret = GetEnt("turret_player_m60", "targetname"); //kevin commenting out to use new calls for player turret sound
	mg_gunner = simple_spawn_single("e3_marine_man_mg");
	//mg_gunner magic_bullet_shield();
	mg_gunner.goalradius = 32;
	//mg_gunner.ignoresuppression = 1;

	//mg_gunner set_goal_node(GetNode("node_ai_man_mg", "targetname"));
	//mg_gunner maps\_spawner::use_a_turret(level.player_turret);
	//level.player_turret setturretignoregoals(false);

	//transition to player machine gun
	level.squad["woods"] set_goal_node(GetNode("node_woods_player_mg", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("node_hudson_player_mg", "targetname"));

	//make sure woods passes through first mg hut
	level.squad["woods"] waittill("goal");

	//hold the line vo
	level.squad["woods"] thread anim_single(level.squad["woods"], "hold_the_line");//"Hold this position!"

	//trigger_wait("trig_player_mg_trigger", "targetname");

	//they go to the other bunker
	//level.squad["woods"] set_goal_node(GetNode("e3_woods_m60", "targetname"));
	level.squad["hudson"] set_goal_node(GetNode("e3_hudson_m60", "targetname"));

	level.squad["woods"] reset_movemode();
	
	//make sure woods is in china MG hut
	//level.squad["woods"] waittill("goal");
	
	level.squad["woods"] thread maps\_turret::use_turret( level.woods_turret, true );

	tur_owner = level.woods_turret GetTurretOwner();
	if(IsDefined(tur_owner) && tur_owner == level.player)
	{
		node = GetNode("lerp_player_off_mg", "targetname");
		level.player StopUsingTurret();
		level.player lerp_player_view_to_position(node.origin, node.angles, 0.5);

	}

	level.squad["woods"] change_movemode("cqb_sprint");
}

event3_hold_the_line()
{
	level.player endon("death");

	level thread event3_woods_manning_gun();

	//clean up the fougasese two bodies here so it cant be seen
	if(IsDefined(level.burn_models) && level.burn_models.size > 0)
	{
		array_delete(level.burn_models);
		level.burn_models = array_removeUndefined( level.burn_models );
	}

	level thread event3_hold_the_line_watcher();

	//exploder for B52 in this area
	//Exploder(380);

	flag_wait("obj_hold_the_line_complete");

//TERMINATES ANYTHING RELATED TO FOUGASSE TRAPS
//mostly cleanup any trap specific spawning and custom drone triggers

	//fougasse 1 and 2 spawn managers
	spawn_manager_kill("e3_spawn_mgr_0");
	spawn_manager_kill("e3_spawn_mgr_1");

	//fougasse 1 and 2 drone triggers. get deleted if player detonates so this is a catchall.
	if(IsDefined(level.drone_trigger_player_drums_one))
	{
		level thread remove_drone_structs(level.drone_trigger_player_drums_one, false, 20);
		//level.drone_trigger_player_drums_one Delete();
	}
	
	if(IsDefined(level.drone_trigger_player_drums_two))
	{
		level thread remove_drone_structs(level.drone_trigger_player_drums_two, false, 20);
		//level.drone_trigger_player_drums_two Delete();
	}

	//detonator glowy models
	if(IsDefined(level.detonator_obj_0))
	{
		level.detonator_obj_0 Delete();
	}
	
	if(IsDefined(level.detonator_obj_1))
	{
		level.detonator_obj_1 Delete();
	}

	//drone swapper should always be active when tanks start
	flag_clear("pause_swapper");

	//if the player had the detonator when the tanks start return everything
	if(flag("player_has_detonator") || flag("player_has_detonator_two"))
	{
		//clear out detonate message
		screen_message_delete();
		level.player TakeWeapon("creek_satchel_charge_sp");
		level.player TakeWeapon("knife_sp");
		level.player notify("giveback");
		level.player EnableWeaponCycling();
	}

	//if player was standing in detonator trigger but never grabbed it
	level.player AllowPickupWeapons(true);
	level.player SetScriptHintString("");
}

event3_woods_manning_gun()
{
	level.player endon("death");

	level.woods_mg_align = GetEnt("align_woods_crazy_mg", "targetname");

	//get woods on machine gun
	//level.woods_turret = GetEnt("e3_woods_mg_turret", "targetname");
	level.squad["woods"].goalradius = 64;
	level.squad["woods"].ignoresuppression = 1;
	level.squad["woods"].grenadeAwareness = 0;
	//level.squad["woods"] maps\_spawner::use_a_turret(level.woods_turret);
	//level.woods_turret setturretignoregoals(false);
	//level.woods_turret waittill("turretstatechange");

	level.woods_turret Hide();
	level.woods_turret MakeTurretUnusable();
	level.mg_prop = spawn_anim_model("mg_prop", level.woods_turret.origin, level.woods_turret.angles);

	crazy_mg_actors = [];
	crazy_mg_actors[0] = level.squad["woods"];
	crazy_mg_actors[1] = level.mg_prop;
	
	level.woods_mg_align anim_reach_aligned(level.squad["woods"], "crazy_mg");
	level.squad["woods"] gun_remove();

	battlechatter_off("allies");
	level.woods_mg_align anim_single_aligned(crazy_mg_actors, "crazy_mg");	
	//level.squad["woods"] LookAtEntity(level.player);
	//woods tells player to use china lake
	level.woods_mg_align anim_single_aligned(crazy_mg_actors, "mg_assist");
	battlechatter_on("allies");
	//level.squad["woods"] LookAtEntity();

	level.woods_turret Show();
	level.mg_prop Delete();
	level.woods_turret MakeTurretUsable();
	level.squad["woods"] gun_recall();
	level.squad["woods"].grenadeAwareness = 1;
	level.squad["woods"] thread maps\_turret::use_turret( level.woods_turret, true );
}

#using_animtree( "generic_human" );
event3_vignette_mg_death()
{
	level.player endon("death");
	align_node = GetEnt("align_e3_mg_diver", "targetname");

	trigger_wait("trig_shirtless_death");

	dead_mg = spawn_fake_character(align_node.origin + (0, 0, -60), align_node.angles, "topless");
	dead_mg.animname = "dead_mg";
	dead_mg.script_animname = "dead_mg";
	dead_mg UseAnimTree(#animtree);

	weapon = GetWeaponModel( "m16_sp" ); 
	dead_mg Attach( weapon, "tag_weapon_right" ); 
	dead_mg UseWeaponHideTags("m16_sp");

	align_node anim_single_aligned(dead_mg, "shirtless_dead_mg");
	//run_scene("dead_mg");
	dead_mg setlookattext("", &"");

	align_node Delete();
}

event3_hold_the_line_watcher()
{
	level.player endon("death");

	timer_china = 0;

	while(1)
	{
		if(timer_china >= level.TIME_ON_CHINA )
		{
			timer_china = 0;
			flag_set("obj_hold_the_line_complete");
			break;
		}

		wait 0.05;
		timer_china += 0.05;
	}
}

//self is trigger
//gets deleted by event3_cleanup
provide_m72_law_ammo()
{
	//kill thread on death of tank or level end
	level.player endon("death");
	self endon("death");

	//if player has rpg give max ammo to that weapon only. 	
	while( 1 )
	{
		if(flag("obj_defeat_the_tanks_complete"))
		{
			break;
		}
		
		weapon = level.player getcurrentweapon();

		while( level.player IsTouching( self ) == false )	
		{
			wait 0.5;
		}

		if( weapon == "m72_law_magic_bullet_sp")
		{
			wait( 0.05 );
			level.player givemaxammo (weapon);
		}

		wait( 0.5 );
	}	
}

drone_swap_manager()
{
	level.player endon("death");
	level endon("end_drone_swap");

	spawner_array = [];
	spawner_array = array_add(spawner_array, GetEnt("e3_ak_general_spawner", "targetname"));
	spawner_array = array_add(spawner_array, GetEnt("e3_shotgun_general_spawner", "targetname"));
	
	array_thread(spawner_array, ::add_spawn_function, ::swapper_ai_think);

	level.drone_swapper = array_removeUndefined( level.drone_swapper );

	while (1)
	{
		//notifify from _drones, passes in the drone
		level waittill("drone_at_last_node", drone);

		if(!flag("pause_swapper"))
		{
			if (level.drone_swapper.size < level.DRONE_SWAP_CAP)
			{
				if(IsDefined(drone.can_swap) && drone.can_swap)
				{
					drone spawn_at_end(random(spawner_array));
				}
			}
		}
		else
		{
			//do nothing
		}

		wait 0.05;
	}
}

spawn_at_end(guy_spawner)
{
	guy_spawner.origin = self.origin;
	guy_spawner.angles = self.angles;
	guy_spawner.count++;

	self maps\_drones::drone_delete();

	guy = simple_spawn_single(guy_spawner);

	guy thread swapped_guy_monitor();

	level.drone_swapper = array_add(level.drone_swapper, guy);
}

swapped_guy_monitor()
{
	self waittill("death");
	level.drone_swapper = array_remove(level.drone_swapper, self);
	level.drone_swapper = array_removeUndefined( level.drone_swapper );
}

event2_spawned_cleanup()
{
	ally_cleanup = GetAIArray("allies");

	//clean up marine blockers
	for(i = 0; i < 4; i++)
	{
		allies[i] = GetEnt("e2_marine_ucut_blocker_" + i, "targetname");
		if(IsDefined(allies[i]))
		{
			allies[i] Delete();
		}
	}

	//clean up the rest. heroes and choppr guys have noteworthys
	for(i = 0; i < ally_cleanup.size; i++)
	{
		if(IsDefined(ally_cleanup[i]) && !IsDefined(ally_cleanup[i].script_noteworthy))
		{
			ally_cleanup[i] Delete();
		}
	}

	level thread event2_spawned_nva_cleanup();
}

event2_spawned_nva_cleanup()
{
	axis_cleanup = GetAIArray("axis");
	
	flag_wait("trig_player_prone");
	
	//makes sure all spawned NVA are nuked from event 2 if you are past the prone section
	if(axis_cleanup.size > 0)
	{
		for(i = 0; i < axis_cleanup.size; i++)
		{
			if(IsDefined(axis_cleanup[i]))
			{
				if(axis_cleanup[i].targetname == "spawner_woods_blindfire_nva_ai" 
					|| axis_cleanup[i].targetname == "e2_u_cut_exit_guys_ai" 
					|| axis_cleanup[i].targetname == "e2_u_cut_house_guys_ai"
					|| axis_cleanup[i].targetname == "e2_woods_h2h_nva_ai"
					|| axis_cleanup[i].targetname == "e2_enter_u_cut_guys_ai"
					|| axis_cleanup[i].targetname == "nva_attack_ai"
					|| axis_cleanup[i].targetname == "nva_attack_2_ai"
					|| axis_cleanup[i].targetname == "e2_u_cut_bridge_guys_ai"
					|| axis_cleanup[i].targetname == "e2_narrow_nva_0_ai"
					|| axis_cleanup[i].targetname == "e2_u_cut_end_h2h_nva1_ai"
					|| axis_cleanup[i].targetname == "e2_u_cut_end_h2h_nva2_ai"
					|| axis_cleanup[i].targetname == "e2_spawner_flame_nva_ai"
				//	|| axis_cleanup[i].targetname == "e2_spawner_nva_leaper_ai"
					)
				{
					axis_cleanup[i] Delete();
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
// TANK FUNCTIONS
/////////////////////////////////////////////////////////////////////////////////////////

setup_tanks()
{
	//create tank array
	level.e3_t55_tank = [];
	level.e3_t55_tank_path = [];

	//setup tanks
	for(i = 0; i < 3; i++)
	{
		//spawn the tanks at their start_node
		level.e3_t55_tank_path[i] = GetVehicleNode("e3_t55_path_" + i, "targetname");
		//level.e3_t55_tank[i] = SpawnVehicle("t5_veh_tank_t55", "e3_spawner_t55_" + i, "tank_t55", level.e3_t55_tank_path[i].origin, level.e3_t55_tank_path[i].angles );

		trigger_use("e3_tank_" + i);

		wait 0.1;

		level.e3_t55_tank[i] = GetEnt("e3_spawner_t55_" + i, "targetname");	

		//set health and targetname. tank order is right to left 0-1.
		level.e3_t55_tank[i].health = level.DEFAULT_TANK_HEALTH;
		level.e3_t55_tank[i].targetname = "e3_t55_tank_" + i;

		//allows you to take control of next target to shoot. angry_shoot is when the player hits it, it targets red shirts
		level.e3_t55_tank[i].shoot_angry = false;
		level.e3_t55_tank[i].shoot_override = false;
		level.e3_t55_tank[i].shoot_override_targetname = undefined;
		level.e3_t55_tank[i].obj_loc = spawn("script_model", level.e3_t55_tank[i].origin + (0, 0, 100));
		level.e3_t55_tank[i].obj_loc SetModel("tag_origin");
		level.e3_t55_tank[i].obj_loc LinkTo(level.e3_t55_tank[i]);
		level.e3_t55_tank[i].goalradius = 64;

		//runs target selection and fire
		level.e3_t55_tank[i] thread tank_turret_manager();
		//tanks are constantly moving and shooting.
		level.e3_t55_tank[i] thread tank_move_manager();
		level.e3_t55_tank[i] thread tank_stop_move_on_death();

/#
		//test_damage
		level.e3_t55_tank[i] thread debug_tank_damage();
#/		
		wait 2;
	}
	
	//TUEY Set music state to TANK_DEFEND
	setmusicstate ("TANK_DEFEND");

	for(i = 0; i < 3; i++)
	{
		if(i == 2)
		{
			flag_set("all_tanks_spawned");
		}
		//start tank path
		level.e3_t55_tank[i] thread go_path(level.e3_t55_tank_path[i]);
		//hackery for starggering
		wait 1;
	}
	
	level thread hint_damage_type_watcher(level.e3_t55_tank);
	level thread earthquake_rumble_approach(level.e3_t55_tank[i]);
	level.player thread shoot_player_camper();
}

//self is level
hint_damage_type_watcher(tank)
{
	level endon("obj_defeat_the_tanks_complete");
	level.tank_hint_counter = 0;

	self thread manage_gunfire_hint();

	cur_weapon = level.player GetCurrentWeapon();
	tur_1 = GetEnt("turret_player_m60", "targetname");
	tur_2 = GetEnt("e3_woods_mg_turret", "targetname");

	while(1)
	{
		cur_weapon = level.player GetCurrentWeapon();
		tur_1_owner = tur_1 GetTurretOwner();
		tur_2_owner = tur_2 GetTurretOwner();
		if( !flag("gun_hint_displayed") 
			&& ( (level.player IsFiring() && (cur_weapon != "m72_law_magic_bullet_sp" 
				&& cur_weapon != "china_lake_sp"
				&& cur_weapon != "gl_m16_sp"
				&& cur_weapon != "gl_m14_sp"
				&& cur_weapon != "gl_ak47_sp") )
			|| (IsDefined(tur_1_owner) && tur_1_owner == level.player && IsTurretFiring(tur_1))
			|| (IsDefined(tur_2_owner) && tur_2_owner == level.player && IsTurretFiring(tur_2)) )
			)
		{			
			if( (IsDefined(tank[0]) && level.player is_player_looking_at((tank[0].origin + (0, 0 , 100)), 0.90, false) )
				|| (IsDefined(tank[1]) && level.player is_player_looking_at((tank[1].origin + (0, 0 , 100)), 0.90, false) )
				|| (IsDefined(tank[2]) && level.player is_player_looking_at((tank[2].origin + (0, 0 , 100)), 0.90, false) )
				) 
			{
				level.tank_hint_counter++;
			}
		}

		if(level.tank_hint_counter > 45 && !flag("gun_hint_displayed"))
		{
			level.tank_hint_counter = 0;
			flag_set("gun_hint_displayed");
		}

		wait 0.05;
	}
}

manage_gunfire_hint()
{
	level endon("obj_rally_bunker_complete");

	while(1)
	{
		if(flag("gun_hint_displayed"))
		{
			screen_message_create( &"KHE_SANH_INSTRUCTION_TANK_GUNFIRE" );
			wait 3;
			screen_message_delete();
			flag_clear("gun_hint_displayed");
		}

		//need to make sure hint string gets cleared
		if(flag("obj_defeat_the_tanks_complete"))
		{
			screen_message_delete();
			flag_clear("gun_hint_displayed");
			wait 0.05;
			break;
		}

		wait 0.05;
	}
}

//self is level; passing in last tank to arrive
earthquake_rumble_approach(tank)
{
	level endon("obj_defeat_the_tanks_complete");

	wait 6;
	
	x = 0;
	exit_out = 4;
	while(1)
	{
		if(x > exit_out)//exit out 
		{
			break;
		}
		//shake when tanks roll in
		if(x < (exit_out * 0.5))
		{
			Earthquake(0.1, 0.22, level.player.origin, 100, level.player);
			level.player PlayRumbleOnEntity("damage_light");
			wait 0.22;
		}
		else
		{
			Earthquake(0.2, 0.15, level.player.origin, 100, level.player);
			level.player PlayRumbleOnEntity("damage_heavy");
			wait 0.15;
		}



		x += 0.05;
		wait 0.05;
	}
}

//self is player
shoot_player_camper()
{
	level endon("obj_defeat_the_tanks_complete");

	old_origin = self.origin;
	timer = 0;
	target_me = 10;

	while(IsAlive(self))
	{
		wait(1);

		//check for player movement
		if( Distance2D(old_origin, self.origin) < 32)
		{
			timer += 1;
		}

		if(timer >= target_me)
		{
			timer = 0;
			flag_set("e3_shoot_player");
		}

		old_origin = self.origin;
	}
}


//self is level.e3_t55_tank[]
//TODO make it so that tanks cannot shoot at the same struct. Set some kvp on the struct to claim it when selected to fire.
tank_turret_manager()
{
	self endon("death");

	FIRE_WAIT_X = 3;
	FIRE_WAIT_Y = 5;
	ANGRY_FIRE_WAIT_X = 1;
	ANGRY_FIRE_WAIT_Y = 2;

	//array of structs for tank to aim to
	aim_turret_loc = getstructarray("struct_e3_tank_target", "script_noteworthy");
	
	//reference for cleanup
	level.tank_target_structs = aim_turret_loc;

	while(1)
	{
		//shoot at specified target or fire at normally selected target
		if(IsDefined(self.shoot_override) && self.shoot_override)
		{
			//TODO maybe allow to specify a position as well for override
			struct_aim_here = getstruct(self.shoot_override_targetname, "targetname");

			self.shoot_override = false;
			self.shoot_override_targetname = undefined;
		}
		else if(flag("e3_shoot_player"))
		{
			struct_aim_here = level.player;
		}
		else
		{
			struct_aim_here = self tank_turret_pick_target( aim_turret_loc );
		}

		//set target to fire at
		self SetTurretTargetVec(struct_aim_here.origin);

		//turrets return this by default
		//self waittill("turret_on_target"); //waittill_any_or_timeout( <timer>, <msg1>
		self waittill_any_or_timeout(5, "turret_on_target");

		trace_fraction = self SightConeTrace(struct_aim_here.origin, level.player);

		if( trace_fraction > 0)
		{
			self FireWeapon();
			level notify("e3_tank_fire");
			if(flag("e3_shoot_player"))
			{
				flag_clear("e3_shoot_player");
			}
		}

		//angry shoot increases fire rate and targets player
		if(self.shoot_angry == true)
		{
			wait RandomFloatRange(ANGRY_FIRE_WAIT_X, ANGRY_FIRE_WAIT_Y);
		}
		else
		{
			wait RandomFloatRange(FIRE_WAIT_X,FIRE_WAIT_Y);
		}
	}
}

//self is level.e3_t55_tank[]
//picks best struct to shoot: currently picks a struct closest to player
//returns a struct
//each struct has a unique targetname but common noteworthy
tank_turret_pick_target( array_structs )
{
	self endon("death");

	assert( IsDefined( array_structs ), "array_structs is not defined");
	assert( IsArray( array_structs ), "array_structs is not an array");	

	ally_array = GetAIArray("allies");

	//defaults to struct_0
	target = array_structs[0];

	//angry shoot increases fire rate and targets player
	if(self.shoot_angry == true)
	{
		//init array that stores dist to node where a node corresponds to a struct.
		array_struct_closest = [];

		for(node = 0; node < array_structs.size; node++)
		{
			//array_closest is an array of a redshirt and distance to each node
			array_struct_closest[node] = Distance2D(array_structs[node].origin, random(ally_array).origin);
		}


		//set smallest and target_node to first index/value of array with distances
		smallest = array_struct_closest[0];
		target_node = 0;	

		//find smallest value in array
		for( pos = 1; pos < array_struct_closest.size; pos++)
		{
			if( array_struct_closest[pos] < smallest )
			{
				smallest = array_struct_closest[pos];
				target_node = pos;
			}
		}

		target = array_structs[target_node];
	}
	else
	{
		target = random(array_structs);
	}

	//returns a struct
	return target;
}

event3_finale_airmada()
{
	total_airmada_huey = GetEntArray("finale_cobra_trigs_note", "script_noteworthy");
	total_shoot_origins = GetEntArray("finale_shoot_origins", "script_noteworthy");
	airmada_heli = [];
	airmada_heli_path = [];
	airmada_heli_path_exit = [];
	
	total_airmada_phantom = GetEntArray("finale_phantom_trigs_note", "script_noteworthy");
	airmada_phantom = [];
	airmada_phantom_path = [];

	flag_wait("obj_defeat_the_tanks_complete");
	
	//level.woods_turret maps\_turret::disable_turret();
	level.squad["woods"] maps\_turret::stop_use_turret();
	
	//tow_prop = GetEnt("align_tow_emplacement", "targetname");
	phantom_vo = spawn("script_model", level.squad["woods"].origin);
	phantom_vo SetModel("tag_origin");
	phantom_vo.animname = "phantom";

	phantom_vo thread finale_airmada_start_vo();

	//spawn choppers
	for(i = 0; i < total_airmada_huey.size; i++)
	{
		activate_trigger_with_targetname("trig_finale_cobra_" +i);
		wait 0.05;
	}

	//assign in order to array
	for(i = 0; i < total_airmada_huey.size; i++)
	{
		airmada_heli[i] = GetEnt("finale_cobra_" +i, "targetname");
		airmada_heli[i] SetDefaultPitch( 13 );
		airmada_heli[i] SetForceNoCull();
		airmada_heli[i] thread heli_pilot_maker(true);
		airmada_heli[i] thread airmada_strafing_logic(i);
	}

	array_wait(airmada_heli, "stop_strafing_run");



	//spawn phantom
	for(i = 0; i < total_airmada_phantom.size; i++)
	{
		activate_trigger_with_targetname("trig_finale_phantom_" +i);
		wait 0.05;
	}

	//assign in order to array
	for(i = 0; i < total_airmada_phantom.size; i++)
	{
		airmada_phantom_path[i] = GetVehicleNode("node_finale_phantom_" +i, "targetname");
		airmada_phantom[i] = GetEnt("finale_phantom_" +i, "targetname");
		airmada_phantom[i] maps\khe_sanh_fx::f4_add_contrails();
		airmada_phantom[i] SetForceNoCull();
		airmada_phantom[i] thread airmada_phantom_shoot(i);
	}

	phantom_vo anim_single(phantom_vo, "red_rider_headdown");//"Be advised, Red Rider on station. Keep your head down."

	airmada_phantom[0] thread go_path(airmada_phantom_path[i]);
	airmada_phantom[0] thread plane_position_updater (715, "evt_phantom_2_wash", "null");	

	airmada_phantom[0] waittill("reached_end_node");
	
	//CDC Set music state to FOUGASSE SECTION
	//setmusicstate ("FOUGASSE_SECTION");

	phantom_vo thread anim_single(phantom_vo, "red_rider_ontarget");//"High explosive ordinance on target. Have a nice day. Red Rider out."
	
	//flag_set("end_drone_swap");

	airmada_phantom[1] thread go_path(airmada_phantom_path[i]);
	airmada_phantom[1] thread plane_position_updater (715, "evt_phantom_2_wash", "null");	

	flag_set("trans_to_event4");
	
	wait 2.5;

	//level.squad["woods"] LookAtEntity(level.player);
	level.squad["woods"] anim_single(level.squad["woods"], "woods_hell_yes");//"Hell yes!"
	//level.squad["woods"] LookAtEntity();

	phantom_vo Delete();
}

//self is scrip model
finale_airmada_start_vo()
{
	self anim_single(self, "red_rider_intro");//"Roger that, Big 6. Red Rider is inbound. 2 minutes. Please stand by."

	//level.squad["woods"] LookAtEntity(level.player);
	level.squad["woods"] thread anim_single(level.squad["woods"], "out_of_time");//"We're out of time."
	//level.squad["woods"] LookAtEntity();
}

//self is helicopter
airmada_strafing_logic(my_index)
{
	level.player endon("death");
	self endon("death");

	my_look_ent = GetEnt( "origin_cobra_shoot_" +my_index , "targetname");
	my_look_ent_b = GetEnt( "origin_flight_" +my_index , "targetname");

	//path sttart 0
	self SetVehGoalPos( getstruct("struct_cobra" +my_index +"_fly_" +0).origin, true );
	self SetLookAtEnt( my_look_ent );	

	self waittill("goal");
	
	//can some heli sounds
	self playsound ("evt_airmada_helis");	
	//wait 2;
	
	wait 0.5;

	self thread strafe_shooting(my_look_ent);

	self SetSpeed( 65, 65, 30 );
	
	//path sttart 1
	self SetVehGoalPos( getstruct("struct_cobra" +my_index +"_fly_" +1).origin, true );
	self SetLookAtEnt( my_look_ent );	

	//self waittill("goal");
	wait 2;

	//path sttart 2
	self SetVehGoalPos( getstruct("struct_cobra" +my_index +"_fly_" +2).origin, true );
	self SetLookAtEnt( my_look_ent );	

	//self waittill("goal");
	wait 1.5;
	self notify("stop_strafing_run");
	wait 1.5;

	//path sttart 2
	self SetVehGoalPos( getstruct("struct_cobra" +my_index +"_fly_" +3).origin, true );
	self SetLookAtEnt( my_look_ent_b ); 

	//self waittill("goal");
	wait 2;

	//path sttart 2
	self SetVehGoalPos( getstruct("struct_cobra" +my_index +"_fly_" +4).origin, true );
	self SetLookAtEnt( my_look_ent_b ); 
	
	self waittill("goal");
	self notify("at_exit");

	self Delete();
}

//self is helicopter 
strafe_shooting(target_ent)
{
	level.player endon("death");
	self endon("death");
	self endon("stop_strafing_run");

	self SetLookAtEnt( target_ent );
	self SetTurretTargetEnt( target_ent );

	while(1)
	{
		for(i = 0; i < 4; i++)
		{
			self FireWeapon("tag_rocket_right");
			self FireWeapon("tag_rocket_left");
			wait 0.55;
		}


		wait RandomIntRange(1, 2);
	}
}

//self is phantom
airmada_phantom_shoot(my_index)
{
	level.player endon("death");
	self endon("death");

	if(my_index == 0)
	{
		vehicle_node_wait("napalm", "script_noteworthy");
		//Exploder(390);
		PlaySoundAtPosition( "chr_tinitus", (0,0,0) );  // RIIINNNGGG
		level thread finale_shake_rumble();
	}

	self waittill("reached_end_node");

	self Delete();
}	

finale_shake_rumble()
{
	Earthquake(0.85, 1, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 20);

	wait 1.2;

	Earthquake(0.85, 1, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 20);
}

event2_cleanup_setup()
{
	level.player endon("death");

	trigger_wait("trig_woods_drum_start");

	//stop_exploder(220); //phantom drop exploder off
	
	//fire point at bunker exit
	if(IsDefined(level.e2_fire_struct))
	{
		level.e2_fire_struct notify("turn_off_fire_struct");
		remove_drone_struct(level.e2_fire_struct);
	}

	level thread event2_cleanup();
}

//self is level: cleans up all radiant ents
event2_cleanup()
{
	event2_ents = [];

	spawners_trigs = GetEntArray("e2_cleanup_ents", "script_noteworthy");
	spawners = GetEntArray("e2_spawner_0", "targetname");
	spawners_narrow = GetEntArray("e2_narrow_nva_0", "targetname");
	spawners_ucut = GetEntArray("e2_u_cut_bridge_guys", "targetname");
	
	event2_ents = array_combine(spawners_trigs, spawners);
	event2_ents = array_combine(event2_ents, spawners_narrow);
	event2_ents = array_combine(event2_ents, spawners_ucut);

	if(event2_ents.size > 0)
	{
		event2_ents = array_removeUndefined( event2_ents );
		array_delete( event2_ents );
		event2_ents = array_removeUndefined( event2_ents );
	}

}

//self is level: cleans up all radiant ents
event3_cleanup()
{
	event3_ents = [];

	spawners_trigs = GetEntArray("e3_cleanup_ents", "script_noteworthy");
	spawners = GetEntArray("e3_woods_blockers", "script_noteworthy");
	drums = GetEntArray("blown_drum", "script_noteworthy");


	event3_ents = array_combine(spawners_trigs, spawners);
	event3_ents = array_combine(event3_ents, drums);

	if(event3_ents.size > 0)
	{
		event3_ents = array_removeUndefined( event3_ents );
		array_delete( event3_ents );		
		event3_ents = array_removeUndefined( event3_ents );
	}
}

swapper_ai_think()
{
	self endon("death");
	
	x = RandomIntRange( 0, 9 );
	if(x > 4)
	{
		self AllowedStances("crouch");
	}
	else
	{
		self AllowedStances("crouch", "stand");
	}

	self AllowedStances("prone", "crouch");
	self change_movemode("cqb_sprint");
	self.script_accuracy = 0.3;

	flag_wait("obj_defeat_the_tanks");
	self reset_movemode();
	self reset_movemode();

	x = RandomIntRange( 0, 9 );
	if(x > 4)
	{
		self AllowedStances("crouch");
	}
	else
	{
		self AllowedStances("crouch", "stand");
	}
}

setup_bunker_exploders()
{
	level endon("obj_defeat_the_tanks_complete");
	trigs = GetEntArray("e3_mg_houses", "targetname");

	while(1)
	{
		level waittill("e3_tank_fire");
		//bunker dust explosion
		if(level.player IsTouching(trigs[0]) || level.player IsTouching(trigs[1]))
		{
			//Exploder(361);
			//Exploder(362);
		}

		//when a tank shoots it causes a rumble and a shake
		Earthquake(0.3, 0.15, level.player.origin, 100, level.player);
		level.player PlayRumbleOnEntity("damage_heavy");

		wait 0.05;
	}
}

setup_law_objective()
{
	trig = GetEnt("trig_use_law_obj", "targetname");
	glow_obj = GetEnt("glow_obj_law", "targetname");
	launcher = GetEnt("law_rockets_obj", "targetname");

	glow_obj_b = GetEnt("glow_obj_law_b", "targetname");
	launcher_b = GetEnt("law_rockets_obj_b", "targetname");

	glow_obj_c = GetEnt("glow_obj_law_c", "targetname");
	launcher_c = GetEnt("law_rockets_obj_c", "targetname");

	x = false;

	glow_obj Hide();
	//launcher Hide();
	glow_obj_b Hide();
	//launcher_b Hide();
	glow_obj_c Hide();

	flag_wait("obj_hold_the_line_complete");
	glow_obj Show();
	glow_obj_b Show();
	glow_obj_c Show();

	weapon_list = level.player GetWeaponsList();
	//cur_weapon = GetCurrentWeapon();
	while(1)
	{
		weapon_list = level.player GetWeaponsList();
		//cur_weapon = GetCurrentWeapon();

		if(level.player istouching( trig ))
		{
			for(i = 0; i < weapon_list.size; i++)
			{
				if(weapon_list[i] == "m72_law_magic_bullet_sp")
				{
					x = true;
					break;
				}
			}
		}

		if(x)
		{
			break;
		}

		wait 0.05;
	}

	flag_set("picked_up_law");

	glow_obj Delete();
	glow_obj_b Delete();
	glow_obj_c Delete();
	trig Delete();
}

manage_corpse_delete()
{
	level endon("obj_defeat_the_tanks_complete");

	inside_pos = GetNode("delete_node_law", "targetname");
	outside_pos = GetNode("delete_node_trenchline", "targetname");

	corpses = [];
	corpses_b = [];
	
	while(1)
	{
		corpses = EntSearch(level.CONTENTS_CORPSE, inside_pos.origin, 500);
		corpses_b = EntSearch(level.CONTENTS_CORPSE, outside_pos.origin, 500);

		corpses = array_merge(corpses, corpses_b);
		if(corpses.size > 0)
		{
			for(i = 0; i < corpses.size; i++)
			{
				if(IsDefined(corpses[i]))
				{
					if(!IsDefined(corpses[i].set_delete))
					{
						corpses[i].set_delete = true;
						corpses[i] thread no_look_delete(4);

					}
				}
			}
		}

		wait 4;
	}

}

/////////////////////////////////////////////////////////////////////////////////////////
// Debug Functions
/////////////////////////////////////////////////////////////////////////////////////////
/#
debug_tank_damage()
{
	level.player endon("death");
	level endon("obj_rally_bunker");

	while(1)
	{
		self waittill("damage");
		wait 0.05;
	}
}

debug_enemies()
{
	level.player endon("death");
	level endon("obj_rally_bunker");

	while(1)
	{
		axis = GetAIArray("axis");
		//println("drone swapper length " +level.drone_swapper.size, "  axis size " +axis.size);

		//println("   drone THREADS " +level.drone_threads);

		wait 1;
	}
}

#/

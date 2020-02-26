//////////////////////////////////////////////////////////
//
// khe_sanh_event4.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_music;
#include maps\_scene;

main()
{
	flag_init("babies_in_trench_a");
	flag_init("babies_in_trench_b");
	flag_init("barrels_done");
	flag_init("e4_squad_move_a");
	flag_init("e4_first_cover");
	flag_init("e4_rushers_down");
	flag_init("e4_briefing_done");
	flag_init("e4_sparks");
	flag_init("e4_woods_improvise");
//	flag_init("e4_follow_woods");
	flag_init("e4_bunker_cleared");
	flag_init("e4_player_flank");
	flag_init("e4_squad_at_bunker");
	flag_init("e4_woods_burn_cue_a");
	flag_init("e4_woods_burn_cue_b");
	flag_init("kill_blockers");
	flag_init("bypass_drums");
	flag_init("barrel_instruction_done");

	// turn off this trigger first
	trig = GetEnt("e4_bunker_runners_trig", "targetname");
	trig trigger_off();

	event4_start_downhill();
}

event4_start_downhill()
{
	level.music_barrel_state = false;
	array_thread(GetEntArray("e4_hill_rushers", "targetname"), ::add_spawn_function, ::e4_rusher_think);
	array_thread(GetEntArray("e4_hill_nvas_c", "targetname"), ::add_spawn_function, ::e4_rusher_think);

	//if the message is still active and the player reaches the transition trigger, mortar him.
	level thread uphill_stop_gap();

	// vignettes
	level thread event4_vignettes();
	level thread event4_dialogue();

	// New and improved
	event4_intro();
	event4_new_progression();
/*
	event4_follow_woods();
	event4_clear_bunker();
	event4_cover_allies();
	event4_woods_improvise();
	event4_trenches_burned();
	event4_squad_rally();
	event4_hill_transition();
*/

	flag_wait("obj_rally_at_hill");
}

event4_intro()
{
	//trigger_wait("e4_squad_move_a", "targetname");
	flag_wait("flag_e4_squad_move_a");

	event4_threatbias();
	event4_nva_accuracy();

	//do fire damage
	//this gets cleanup up in event4b event4_cleanup_firetrig()
	weapon_cache_struct = getstruct("bunk_house_flame", "targetname");
	weapon_cache_struct thread fire_damage_player();

	//weapon cache spawners spawn think setup
	cache_guys = GetEntArray("e4_bunker_nva", "targetname");
	array_thread( cache_guys, ::add_spawn_function, ::set_ai_accuracy );

	//renable colors for heroes. turned off for apc_crush and event 3
	level.squad["woods"] enable_ai_color();
	level.squad["hudson"] enable_ai_color();

	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");

	//level.player player_force_walk(false);

		//activate drone trigs
	level.drone_trigger_e4_downhill = GetEnt("e4_trig_drone_downhill", "script_noteworthy");
	level.drone_trigger_e4_downhill activate_trigger();

	level.drone_e4_downhill_burst = GetEnt("e4_trig_drone_downhill_burst", "script_noteworthy");
	level.drone_e4_downhill_burst activate_trigger();

	//ends at khe_sanh_event4::kill_e4_trans_drones()
	level thread drone_speed_adjust();
	//setup_drone_yells(all_drones, interval_wait, wait_min, wait_max, vox_weight_min, vox_weight_max, vox_weight_median)
	level thread setup_drone_yells(undefined, 8, 5, 10);

	// spawn the redshirts
	reshirt_spawners = GetEntArray("e4_redshirt_start", "targetname");
	redshirts = simple_spawn(reshirt_spawners);
	level.e4_redshirt = undefined;
	for (i = 0; i < redshirts.size; i++)
	{
		redshirts[i] magic_bullet_shield();
		if (IsDefined(redshirts[i].script_noteworthy) && redshirts[i].script_noteworthy == "e4_redshirt")
		{
			level.e4_redshirt = redshirts[i];
		}
	}

	level thread event4_hilltop_briefing();

//*
	// squad move a
	flag_set("e4_squad_move_a");

	// spawn the party
	level thread event4_spawn_nva_hill_start();

	// spawn the flankers
	trigger_use("e4_nva_hill_flank");

	// wait till rushers are downed
	level thread event4_spawn_nva_rushers();

	// wait for briefing
	flag_wait("e4_briefing_done");
	level notify("stop_e3_e4_tunnel");
	level notify("stop_mortars");

	for (i = 0; i < redshirts.size; i++)
	{
		redshirts[i] stop_magic_bullet_shield();
	}

	// move up!

	trigger_use("e4_squad_move_b");
	
	//level thread event4_woods_cache();
//*/
}

event4_new_progression()
{
	flag_set("obj_breakthrough");
	level thread player_goto_cache();
	level thread player_goto_drums();

	//sets up drums
	level thread event4_trenches_burned();

	wait 5;

	// reshirts move up
	trigger_use("e4_redshirts_sm");
}

player_goto_cache()
{
	level endon("e4_player_flank");

	level thread e4_wep_cache_vo();
	trigger_wait("e4_woods_follow");
	trigger_use("e4_woods_cache");

	waittill_ai_group_cleared("bunker_guys");
	level.squad["woods"] anim_single(level.squad["woods"], "e4_move_up"); //"Move up!"
	level.squad["woods"] anim_single(level.squad["woods"], "e4_flank"); //"Grab what you need, we'll hit their left flank."
	level.squad["woods"] anim_single(level.squad["woods"], "e4_ready"); //"Marines - be ready to move up."
}

player_goto_drums()
{
	//trigger_wait("e4_player_approach_bunker");
	//flag set from trigger
	//level waittill_any_or_timeout( 30, "e4_player_approach_bunker");
	flag_set("start_downhill_breadcrumb");

	level thread set_music_when_bypass_barrels();

	//turn on ambient effects Uphill areas to entrance of destroyed bunker
	//Exploder(41);
	
	//trigger nva coming out of bunker
	trigger_use("trig_e4_hill_nvas_c");
	
	// for dialogue
	flag_set("e4_player_flank");

	// allies move up
	trigger_use("e4_allies_move_up");

	// turn this trigger back on
	bunker_spawn = GetEntArray("e4_bunker_runners", "targetname");
	array_thread(bunker_spawn, ::add_spawn_function, ::set_ai_accuracy);
	trig = GetEnt("e4_bunker_runners_trig", "targetname");
	trig trigger_on();

	// send squad to their specific nodes
	level.squad["woods"].ignoreall = true;
	level.squad["hudson"].ignoreall = true;
	level.squad["hudson"].bunker_goal = GetNode("e4_hudson_bunker_cover", "targetname");
	level.squad["woods"].bunker_goal = GetNode("e4_woods_bunker_cover", "targetname");

	//level.squad["woods"].at_goal = false;
	//level.squad["hudson"].at_goal = false;

	level.squad["woods"] SetGoalNode(level.squad["woods"].bunker_goal);
	level.squad["hudson"] SetGoalNode(level.squad["hudson"].bunker_goal);

	/*
	level.squad["woods"] thread squad_reached_goal();
	level.squad["hudson"] thread squad_reached_goal();


	// wait till they get there
	while (!level.squad["woods"].at_goal && !level.squad["hudson"].at_goal)
	{
		wait(0.5);
	}
*/
	waittill_multiple_ents(level.squad["woods"], "goal", level.squad["hudson"], "goal");

	wait 0.05;

	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;

	// Trench A axis fall back
	trigger_use("e4_axis_fallback");

	flag_wait("e4_player_approach_bunker");

	// Done flanking
	flag_set("e4_squad_at_bunker");

	level thread event4_woods_improvise();

	level thread event4_hill_transition();
}

//SOUND: this sets the music state if the player bypasses the barrels and goes straight for the breadcrumb path
//this same state can still be set in event4_detect_barrels(). global var makes sure it gets set once
set_music_when_bypass_barrels()
{
	flag_wait("trig_e4_breadcrumb");
	if(!level.music_barrel_state)
	{
		level.music_barrel_state = true;
		setmusicstate ("KICK_BARRELS");
	}

}

// self == ally
squad_reached_goal()
{
	self endon("death");
	self waittill("goal");
	self.at_goal = true;
}

event4_woods_improvise()
{
//	wait(4.0);

	// get the woods barrel
	woods_barrel = GetEnt("kick_the_barrel_woods", "targetname");

	// wait for kick notify
	//level.squad["woods"] thread event4_woods_kick(woods_barrel);
	knife = spawn_anim_model("woods_knife", level.squad["woods"].origin, level.squad["woods"].angles, true);
	
	level.squad["woods"].ignoreall = true;
	level.squad["woods"].ignoreme = true;

	// play the animation
	woods_barrel anim_reach_aligned(level.squad["woods"], "improvise", "tag_origin");
	
	//level.squad["woods"] LookAtEntity(level.player);
	woods_barrel thread anim_single_aligned(knife, "improvise");
	//woods_barrel anim_single_aligned(level.squad["woods"], "improvise");
	run_scene("wood_improves");
	//level.squad["woods"] LookAtEntity();

	knife Delete();
	level.squad["woods"].ignoreall = false;
	level.squad["woods"].ignoreme = false;

	// improvise done
	flag_set("e4_woods_improvise");

	// squad move up
	trigger_use("e4_player_at_bunker_a");
}

event4_woods_kick(barrel)
{
	level waittill("woods_kick_barrel");

	angles = self.angles;
	angles = (-10, angles[1], 0);
	dir = AnglesToForward(angles);
	barrel NotSolid();
//	barrel ConnectPaths();
	barrel PhysicsLaunch(barrel.origin, dir * 700);
}

event4_trenches_burned()
{
	level endon("bypass_drums");

	level.start_mortar = false;
	level.rally_squad = false;

	// init array
	level.drum_count = [];
	level.fire_trig = [];

	// set up objective glows
	event4_setup_barrels();

	// run monitor threads
	level thread event4_detect_barrels();
	level thread event4_trench_a();
	level thread event4_trench_b();

	// wait for both sides
	while (!flag("babies_in_trench_a") || !flag("babies_in_trench_b"))
	{
		//start mortars
		if( (flag("babies_in_trench_a") || flag("babies_in_trench_b")) && !level.start_mortar)
		{
			for(i = 0; i < level.barrel_cleanup.size; i++ )
			{
				if(IsDefined(level.barrel_cleanup[i].objective_model))
				{
					//show barrels and remove objective once a set is done
					level.barrel_cleanup[i] Show();
					level.barrel_cleanup[i].objective_model Delete();
				}
			}			

			level thread ambient_mortar_explosion("struct_e4_mortar_", "structs_e4_mortars", 6, 1.15);
			level.start_mortar = true;
		}
		
		wait(0.05);
	}

	// end redshirts
	spawn_manager_kill("e4_redshirts_sm");

	level redshirt_nva_push_vo();

	// move along
	flag_set("barrels_done");


	if(!level.rally_squad)
	{
		level.rally_squad = true;
		event4_squad_rally();
	}
}

redshirt_nva_push_vo()
{
	allies = GetAIArray("allies");
	heroes = [];
	heroes = array_add( heroes, level.squad["woods"] );
	heroes = array_add( heroes, level.squad["woods"] );
	closest = [];

	while(closest.size <= 0)
	{
		closest = get_array_of_closest(level.player.origin, allies, heroes, 5, 1000);
		wait 0.05;
	}

	if(closest.size > 0 )
	{
		guy = random(closest);

		if( IsDefined(guy) && !IsDefined(guy.animname) )
		{
			guy.animname = "e4_redshirt_trans";
			guy anim_single(guy, "4b_push_line");//They're making another push - South East side!
		}
	}
}

event4_squad_rally()
{
	level endon("e4b_start");//nuke this if the player is ahead

	flag_set("obj_rally_at_hill");

	//activate color
	trigger_use("heroes_go_hill");

	level.squad["woods"] disable_ai_color();
	level.squad["hudson"] disable_ai_color();

	level.squad["woods"].ignoreall = true;
	level.squad["hudson"].ignoreall = true;

	hudson_rally_goal = GetStruct("e4b_hudson_goto", "script_noteworthy");
	woods_rally_goal = GetStruct("e4b_woods_goto", "script_noteworthy");

	level.squad["woods"] SetGoalPos(hudson_rally_goal.origin);
	level.squad["hudson"] SetGoalPos(woods_rally_goal.origin);
	
	level waittill_multiple_ents(level.squad["woods"], "goal", level.squad["hudson"], "goal");

	wait 0.05;
	level.squad["woods"] enable_ai_color();
	level.squad["hudson"] enable_ai_color();

	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;
}

event4_hill_transition()
{
	level.player endon("death");
	//activate drone trigs
	level.drone_e4_hill_trans = GetEnt("e4_trig_drone_hill_trans", "script_noteworthy");
	level.drone_e4_hill_trans activate_trigger();

	//trigger_wait("trig_e4_hill_transition");
	flag_wait("trig_e4_hill_transition");

	level thread remove_drone_structs(level.drone_trigger_e4_downhill, false, 30);
	level thread remove_drone_structs(level.drone_e4_downhill_burst, false, 30);
	//level.drone_trigger_e4_downhill Delete();
	//level.drone_e4_downhill_burst Delete();

	if(!level.start_mortar)
	{
		level thread ambient_mortar_explosion("struct_e4_mortar_", "structs_e4_mortars", 0, 2.25);
		level.start_mortar = true;
	}

	//enenmy in the woods
	array_thread(GetEntArray("e4_hill_trans_spawner", "targetname"), ::add_spawn_function, ::spawners_crouch_prone);
	array_thread(GetEntArray("e4_hill_trans_spawner", "targetname"), ::add_spawn_function, ::die_when_up_starts);
	spawn_manager_enable("trig_e4_hill_trans_spawn_mgr");

	//turn this off in case they didnt use drums
	flag_set("bypass_drums");
	flag_set("obj_breakthrough_complete");

	// end redshirts
	spawn_manager_kill("e4_redshirts_sm");

	//nva
	spawn_manager_kill("e4_hill_nvas_sm_a1");
	spawn_manager_kill("e4_hill_nvas_sm_a2");

	spawn_manager_kill("e4_hill_nvas_sm_b1");
	spawn_manager_kill("e4_hill_nvas_sm_b2");

	wait 0.05; 

	//cleanup existing spawn
	e4_e4b_transition_force_clean();
	
	if(!level.rally_squad)
	{
		level.rally_squad = true;
		event4_squad_rally();
	}

	//turn on ai color no matter what
	level.squad["woods"] enable_ai_color();
	level.squad["hudson"] enable_ai_color();

	//level.squad["hudson"] LookAtEntity(level.player);
	level.squad["hudson"] thread anim_single(level.squad["hudson"], "own_mortar");//That's our own mortars! Do they even know were here?
	//level.squad["hudson"] LookAtEntity();
}

die_when_up_starts()
{
	self endon("death");
	level waittill("first_approach");
	self khe_sanh_die();
}

e4_e4b_transition_force_clean()
{
//	allies = GetAIArray("allies");
	nva = GetAIArray("axis");

/*
	for(i = 0; i < allies.size; i++)
	{
		if(allies[i].targetname == "e4_redshirts_ai")
		{
			allies[i] no_look_delete();
		}
	}
*/

	for(i = 0; i < nva.size; i++)
	{
		if(nva[i].targetname == "e4_hill_nvas_a1_ai" || nva[i].targetname == "e4_hill_nvas_a2_ai" ||nva[i].targetname == "e4_hill_nvas_b1_ai"
			|| nva[i].targetname == "e4_hill_nvas_b2_ai")
		{
			nva[i] no_look_delete();
		}
	}

	//remove objective barrels
	if(IsDefined(level.barrel_cleanup))
	{
		level.barrel_cleanup = array_removeUndefined( level.barrel_cleanup );
		for(i = 0; i < level.barrel_cleanup.size; i++)
		{
			if(IsDefined(level.barrel_cleanup[i].objective_model))
			{
				level.barrel_cleanup[i].objective_model no_look_delete();
			}
			//barrels[i] no_look_delete();
		}
	}
}

event4_setup_barrels()
{
	babies = GetEntArray("kick_the_barrel", "targetname");
	//glow_barrels = GetEntArray("glo_objective_barrel", "targetname");
	//babies = GetEntArray("e4_barrels_trench_a", "script_noteworthy");
	//additional = GetEntArray("e4_barrels_trench_b", "script_noteworthy");
	//babies = array_combine( babies, additional );

/*
	for (i = 0; i < babies.size; i++)
	{
		babies[i].objective_model = Spawn("script_model", babies[i].origin);
		babies[i].objective_model SetModel("p_glo_barrel_objective");
		babies[i].objective_model LinkTo(babies[i]);
		babies[i].objective_model Hide();
	}
*/
	level thread reveal_glow_when_player_near(babies);

	level.barrel_cleanup = babies;
}

reveal_glow_when_player_near(drums)
{
	level.player endon("death");

	//trigger_wait("e4_player_approach_bunker");
	//flag set from trigger
	flag_wait("e4_player_approach_bunker");

	level thread kick_barrel_instruction();

	wait 1;

/*
	//show the objective glow when player hits that tier downhill
	for (i = 0; i < drums.size; i++)
	{
		drums[i] Hide(); //regular barrel
		drums[i].objective_model Show(); //the glowy bit
	}
*/

}

kick_barrel_instruction()
{
	//screen_message_create(&"KHE_SANH_INSTRUCTION_BARREL");
	wait 4;
	//screen_message_delete();
	flag_set("barrel_instruction_done");
}

uphill_stop_gap()
{
	level endon("barrel_instruction_done");

	trigger = GetEnt("trig_e4_hill_transition", "targetname");
	source_loc = getstruct("e4_downhill_crumb", "targetname");

	while(1)
	{
		x = RandomIntRange(0, 9);

		if( (!flag("barrel_instruction_done") || !flag("e4_briefing_done")) 
			&& (flag("trig_e4_hill_transition") || level.player IsTouching(trigger)) )
		{
			if(x < 4)		
			{
				level.player thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
				level waittill("mortar_inc_done");
				level thread maps\_shellshock::main(level.player.origin, 5, 256, 0, 0, 0, undefined, "default", 0); 
			}
			else
			{
				loc = level.player GetEye();
				y = RandomIntRange(0, 9);

				if(y < 5)
				{	
					MagicBullet("ak47_sp", source_loc.origin, loc);
				}
				else
				{
					if(y < 5)
					{
						MagicBullet("rpg_sp", source_loc.origin, loc);
					}
					else
					{
						level.player MagicGrenadeType( "frag_grenade_sp", source_loc.origin, VectorNormalize(loc - source_loc.origin) * 100, 0.1 );
					}
				}
			}

			level.player khe_sanh_die();
		}


		wait 0.05;
	}
}

event4_babies_in_trench(trigger, trench_name, damage_name, fx_structs, drum_count)
{
	level endon("bypass_drums");
	trench_trigger = GetEnt(trigger, "targetname");
	babies = GetEntArray(trench_name, "script_noteworthy");
	level.touching[trench_name] = [];

	//array of drum groupings
	level.drum_count[trench_name] = drum_count;

	while (level.touching[trench_name].size != drum_count)
	{	
		for (i = 0; i < babies.size; i++)
		{
			if (IsDefined(babies[i].kicked))
			{
				if (!IsDefined(level.touching[trench_name][i]))
				{
					level.touching[trench_name][i] = babies[i];
				}
			}
			/*
			if (babies[i] IsTouching(trench_trigger))
			{
				if (!IsDefined(level.touching[trench_name][i]))
				{
					level.touching[trench_name][i] = babies[i];
				}
			}
			*/
		}

		// Playe encouraging dialogue
		if (level.touching[trench_name].size == (drum_count - 1))
		{
			if (trench_name == "e4_barrels_trench_a" && !flag("e4_woods_burn_cue_a") && flag("e4_player_approach_bunker"))
			{
				flag_set("e4_woods_burn_cue_a");
				level.squad["woods"] anim_single(level.squad["woods"], "e4_light_up"); //Let's light these bastards up!
			}
			else if (trench_name == "e4_barrels_trench_b" && !flag("e4_woods_burn_cue_b") && flag("e4_player_approach_bunker"))
			{
				flag_set("e4_woods_burn_cue_b");
				level.squad["woods"] anim_single(level.squad["woods"], "e4_do_it"); //Now  MASON! Do it!
			}
		}

		wait(0.05);
	}

	//need to do this before the burn. was doing it after causing a guy to spawn and focusing Allies on it
	if(trench_name == "e4_barrels_trench_a")
	{
		spawn_manager_kill("e4_hill_nvas_sm_a1");
		spawn_manager_kill("e4_hill_nvas_sm_a2");
	}
	else if(trench_name == "e4_barrels_trench_b")
	{
		spawn_manager_kill("e4_hill_nvas_sm_b1");
		spawn_manager_kill("e4_hill_nvas_sm_b2");
	}


	// BURN!
	enemies = GetAIArray("axis");
	for (i = 0; i < enemies.size; i++)
	{
		if (enemies[i] IsTouching(trench_trigger))
		{
			enemies[i] thread burn_me();
		}
	}
}

event4_trench_a()
{
	level endon("bypass_drums");
	// wait here until we finish blowing the trench
	event4_babies_in_trench("e4_barrels_in_trench_a", "e4_barrels_trench_a", "e4_babies_damage_trig_a", "e4_trench_fire_a", 1);

	// Turn off the left over objective barrel
	babies = GetEntArray("e4_barrels_trench_a", "script_noteworthy");
	for (i = 0; i < babies.size; i++)
	{
		level.babies = array_remove(level.babies, babies[i]);

		if (IsDefined(babies[i].objective_model))
		{
			babies[i].objective_model Delete();
		}
	}

	// Fire fire!
	//Exploder(440);

	level.fire_trig[0] = GetEnt("trig_trench_a_fire", "targetname");
	level.fire_trig[0] thread fire_damage_player();	

	level thread trench_flame_structs("trench_a_flamepoints");

	// bunker a clear
	flag_set("babies_in_trench_a");
	level notify("bunker_a_clear");

//	trigger_use("e4_squad_flank");
	autosave_by_name("e4_trench_a");

	//length of effect per darwin
	wait 10;
	level.fire_trig[0] Delete();
}

trench_flame_structs(struct_targetname)
{
	//length of effect per darwin
	wait 10;
	x = getstructarray(struct_targetname, "targetname");
	for(i = 0; i < x.size; i++)
	{
		x[i] thread fire_damage_player();
		playsoundatposition ("evt_barrel_whoosh", x[i].origin);
	}

}

event4_trench_b()
{
	level endon("bypass_drums");
	// wait here until we finish blowing the trench
	event4_babies_in_trench("e4_barrels_in_trench_b", "e4_barrels_trench_b", "e4_babies_damage_trig_b", "e4_trench_fire_b", 1);

	// Turn off the left over objective barrel
	babies = GetEntArray("e4_barrels_trench_b", "script_noteworthy");
	for (i = 0; i < babies.size; i++)
	{
		level.babies = array_remove(level.babies, babies[i]);

		if (IsDefined(babies[i].objective_model))
		{
			babies[i].objective_model Delete();
		}
	}

	// Fire fire!
	//Exploder(460);

	//i = 1 because trench a index is 0
	for(i = 1; i < 4; i++)
	{
		level.fire_trig[i] = GetEnt("trig_trench_b_fire_" +i, "targetname");
		level.fire_trig[i] thread fire_damage_player();		
	}

	level thread trench_flame_structs("trench_b_flamepoints");


	// kill the spawn managers NOW HANDLED IN event4_babies_in_trench since spawner can still spawn post burn call
	//spawn_manager_kill("e4_hill_nvas_sm_b1");
	//spawn_manager_kill("e4_hill_nvas_sm_b2");

	// bunker a clear
	flag_set("babies_in_trench_b");
	level notify("bunker_b_clear");

	autosave_by_name("e4_trench_b");

	//length of effect per darwin	
	wait 10;
	//i = 1 because trench a index is 0
	for(i = 1; i < 4; i++)
	{
		if(IsDefined(level.fire_trig[i]))
		{
			level.fire_trig[i] Delete();		
		}
	}
}

event4_detect_barrels()
{
	level endon("bypass_drums");

	level.babies = GetEntArray("kick_the_barrel", "targetname");
	level.barrel_counter = 0;
	//level.babies = GetEntArray("e4_barrels_trench_a", "script_noteworthy");
	//additional = GetEntArray("e4_barrels_trench_b", "script_noteworthy");
	//level.babies = array_combine( level.babies, additional );
	//kick_count = 0;
	//clear_glow = false;

	while(!flag("barrels_done"))
	{
		baby = GetClosest(level.player.origin, level.babies, 256);
/*
		//if two are kicked
		if(kick_count > 1 && !clear_glow)
		{
			clear_glow = true;
			for(i = 0; i < level.barrel_cleanup.size; i++ )
			{
				if(IsDefined(level.barrel_cleanup[i].objective_model))
				{
					//show barrels and remove objective once a set is done
					level.barrel_cleanup[i] Show();
					level.barrel_cleanup[i].objective_model Delete();
				}
			}
		}
*/
		if (IsDefined(baby))
		{
			dist = DistanceSquared(baby.origin, level.player.origin);
			if (dist < (64 * 64))
			{
				//screen_message_create(&"KHE_SANH_PROMPT_BARREL");
				//screen_message_create("Press [{+usereload}] to kick");
				level.player SetScriptHintString( &"KHE_SANH_PROMPT_BARREL" );

				if (level.player UseButtonPressed())
				{
					level.player SetScriptHintString("");
					event4_kick_a_barrel(baby);
					if(level.barrel_counter == 0)
					{
						level.barrel_counter = 1;

						//SOUND: this sets the music state if the player bypasses the barrels and goes straight for the breadcrumb path
						//this same state can still be set in event4_detect_barrels(). global var makes sure it gets set once
						if(!level.music_barrel_state)
						{
							level.music_barrel_state = true;
							setmusicstate ("KICK_BARRELS");
						}
					}

					//kick_count++;
				}
			}
			else
			{
				level.player SetScriptHintString("");
			}
		}

		wait(0.05);
	}
}

event4_kick_a_barrel(barrel)
{
	//set from event4_babies_in_trench()
	if(!IsDefined(level.drum_count))
	{
		level.drum_count = 0;
	}

	level.player HideViewModel();
	level.player DisableWeapons();
		


	//set up barrel fx
	fire_origin = barrel GetTagOrigin( "fx_stab_jnt" );//barrel.origin + (0, 0, 32);
	barrel.fire_model = spawn("script_model", fire_origin );
	barrel.fire_model SetModel("tag_origin");
	barrel.fire_model LinkTo(barrel, "fx_stab_jnt");

	level.player thread event4_barrel_impulse(barrel);
	level thread event4_barrel_sparks(barrel);

	barrel Show();
	if(IsDefined(barrel.objective_model))
	{
		barrel.objective_model UnLink();
		barrel.objective_model Delete();
	}

	if(level.touching[barrel.script_noteworthy].size == (level.drum_count[barrel.script_noteworthy] - 1))
	{
		anim_name = "kick_barrel_spark";
	}
	else
	{
		anim_name = "kick_barrel";
	}
	
	align_face = getstruct("barrel_face_" +barrel.script_int, "targetname");
	angles = VectorToAngles(align_face.origin - barrel.origin);

	align = spawn("script_model", barrel.origin);
	align.angles = angles;
	align SetModel("tag_origin");

	if(level.player GetStance() == "crouch" || level.player GetStance() == "prone")
	{
		level.player SetStance( "stand" );
		wait 0.15;
	}
	
	level.player.body = spawn_anim_model("player_body");
	level.player.body.knife = spawn("script_model", level.player.body GetTagOrigin("tag_weapon"));
	level.player.body.knife SetModel("t5_knife_sog");
	level.player.body.knife LinkTo(level.player.body, "tag_weapon");

	
	//player is invunerable during kick
	level.player magic_bullet_shield();
	level.player StartCameraTween(0.1);
	level.player SetPlayerAngles(align.angles);
	wait 0.05;
	level.player player_fudge_moveto(align.origin, 100); 
	align thread anim_single_aligned(level.player.body, anim_name);
	wait 0.05;
	level.player StartCameraTween(0.2);
	level.player PlayerLinkToAbsolute(level.player.body, "tag_player");

	if(anim_name == "kick_barrel")
	{
		PlayFXOnTag(level._effect["fx_ks_barrel_leak"], barrel.fire_model, "tag_origin");
	}

	//wait until the anim ends
	align waittill(anim_name);
	level.player stop_magic_bullet_shield();

	align Delete();
	level.babies = array_remove(level.babies, barrel);

	level.player UnLink();
	level.player.body.knife Delete();
	level.player.body Delete();
	level.player ShowViewModel();
	level.player EnableWeapons();
	
}

event4_barrel_impulse(barrel)
{
	level.player waittill("player_kick_barrel");

	level notify(barrel.script_string); 

	//delete collision
	ent = GetEnt("barrel_0" +barrel.script_int +"_brush", "targetname");
	ent Delete();
	//player_angles = level.player GetPlayerAngles();
	//angles = (-10, player_angles[1], 0);
	//dir = AnglesToForward(angles);
	//barrel PhysicsLaunch(barrel.origin, dir * 700);
}

event4_barrel_sparks(barrel)
{
	flag_wait("e4_sparks");

	while (flag("e4_sparks"))
	{
		knife_pos = level.player.body.knife GetTagOrigin("TAG_KNIFE_FX");
		PlayFX(level._effect["fx_ks_barrel_ignite_spark"], knife_pos);

		wait(0.05);
	}

	PlayFXOnTag(level._effect["fx_ks_barrel_ignite"], barrel.fire_model, "tag_origin");
	PlayFXOnTag(level._effect["fx_ks_barrel_leak"], barrel.fire_model, "tag_origin");
}

event4_spawn_nva_rushers()
{
	trigger = GetEnt("e4_first_cover", "targetname");
	trigger waittill("trigger");

	flag_set("e4_first_cover");

	rushers = simple_spawn("e4_hill_rushers");

	array_wait(rushers, "death");

	flag_set("e4_rushers_down");
}

e4_rusher_think()
{
	self thread maps\_rusher::rush();
	self change_movemode("cqb_sprint");
	//self change_movemode("cqb")
	self.script_accuracy = 0.2;
}

event4_spawn_nva_hill_start()
{
	trigger_use("e4_hill_nvas_sm_a1");
	trigger_use("e4_hill_nvas_sm_b1");

	level thread event4_switch_spawners_hill_a();
	level thread event4_switch_spawners_hill_b();
}

event4_switch_spawners_hill_a()
{
	trigger = GetEnt("e4_hill_a", "targetname");
	trigger waittill("trigger");

	spawn_manager_disable("e4_hill_nvas_sm_b2");
	spawn_manager_enable("e4_hill_nvas_sm_a2");

	level thread event4_switch_spawners_hill_b();
}

event4_switch_spawners_hill_b()
{
	trigger = GetEnt("e4_hill_b", "targetname");
	trigger waittill("trigger");

	spawn_manager_disable("e4_hill_nvas_sm_a2");
	spawn_manager_enable("e4_hill_nvas_sm_b2");

	level thread event4_switch_spawners_hill_a();
}

#using_animtree("generic_human");
event4_vignettes()
{
	level endon("death");

	trigger_wait("e4_squad_move_a", "targetname");

	mental_guy_align = GetStruct("e4_mental_guy_align", "targetname");
	mental_guy = spawn_fake_character(mental_guy_align.origin, mental_guy_align.angles, "marine");
	mental_guy UseAnimTree(#animtree);
	
	mental_guy.my_weapon = GetWeaponModel( "m16_sp" );
	mental_guy Attach(mental_guy.my_weapon, "tag_weapon_right");
	mental_guy UseWeaponHideTags("m16_sp");

	mental_guy_align thread anim_generic_loop(mental_guy, "mental");

	medic_death_align = GetStruct("e4_medic_death_align", "targetname");

	medic_guys = [];
	medic_guys[0] = spawn_fake_character(medic_death_align.origin, medic_death_align.angles, "medic");
	medic_guys[1] = spawn_fake_character(medic_death_align.origin, medic_death_align.angles, "marine");
	medic_guys[0] UseAnimTree(#animtree);
	medic_guys[1] UseAnimTree(#animtree);

	medic_guys[0].animname = "hill_medic";
	medic_guys[1].animname = "hill_deadguy";

	medic_death_align thread anim_single_aligned(medic_guys, "death_b");
	//level thread run_scene("dead_medic");
	medic_death_align thread clear_model_names(medic_guys);

	shredded_guys = [];
	for (i = 0; i < 2; i++)
	{
		shredded_guys[i] = simple_spawn_single("e4_shredded_" +i);//spawn_fake_character(shredded_guys_align.origin, shredded_guys_align.angles, "marine");
		shredded_guys[i] AllowedStances("crouch");
		shredded_guys[i] magic_bullet_shield();
	}

	//flag_wait("kill_blockers");
	flag_wait("e4_briefing_done");

	//anticipation lines for naplam drop
	level thread phantom_drop_vo();
	level thread event4_phantom_drop();

	for (i = 0; i < 2; i++)
	{
		head = shredded_guys[i] GetEye();
		loc = shredded_guys[i].origin + (0, 0, -65) + AnglesToForward(shredded_guys[i].angles) * 100;
		shredded_guys[i] stop_magic_bullet_shield();
		MagicBullet("ak47_sp", loc, head, shredded_guys[i]);

		wait 0.05;
	}
}

//self is align node
clear_model_names(actors)
{
	self waittill("death_b");
	for(i = 0; i < actors.size; i++)
	{
		actors[i] setlookattext("", &"");;
	}
}

event4_phantom_drop()
{
	level waittill("e4_drop_ready");
	e4_total_phantoms = GetEntArray("e4_phantoms", "script_noteworthy");
	e4_phantoms = [];
	e4_phantoms_path = [];

	//play vo before drop
	level notify("e4_droppin_napalm");

	//spawn phantom
	for(i = 0; i < e4_total_phantoms.size; i++)
	{
		activate_trigger_with_targetname("trig_e4_napalm_drop_" +i);
		wait 0.05;
	}

	//assign in order to array
	for(i = 0; i < e4_total_phantoms.size; i++)
	{
		e4_phantoms_path[i] = GetVehicleNode("node_e4_phantom_napalm_" +i, "targetname");
		e4_phantoms[i] = GetEnt("e4_phantoms_" +i, "targetname");
		e4_phantoms[i] SetForceNoCull();
		e4_phantoms[i] maps\khe_sanh_fx::f4_add_contrails();
		e4_phantoms[i] thread event4_napalm_drop(i, e4_phantoms_path[i]);
	}
}

phantom_drop_vo()
{
	wait 1;
	level.player.animname = "red_rider";
	wait 0.1;

	level.player anim_single(level.player, "line_drop_0");//Six. Red Rider.
	wait 0.75;
	level.player anim_single(level.player, "line_drop_1");//What's your position?
	wait 0.75;
	level.player anim_single(level.player, "line_drop_2");//Just hang tight.
	wait 0.75;
	level.player anim_single(level.player, "line_drop_3");//OK, standing by.
	level notify("e4_drop_ready");
	

	level waittill("e4_droppin_napalm");
	level.player anim_single(level.player, "line_drop_4");//Go, go, go.
}

event4_napalm_drop(my_index, start_node)
{
	level.player endon("death");
	self endon("death");

	self thread go_path(start_node);

	if(my_index == 0)
	{
		vehicle_node_wait("napalm", "script_noteworthy");
		//Exploder(420);
		PlaySoundAtPosition( "chr_tinitus", (0,0,0) );  // RIIINNNGGG
		Earthquake(0.85, 2, level.player.origin, 200, level.player);
		level thread custom_rumble(0.02, 20);
	}

	self waittill("reached_end_node");

	self Delete();
}

event4_hilltop_briefing()
{
	align_node = GetEnt("align_sgt_and_woods", "targetname");
	level.e4_redshirt.goalradius = 64;
	actors = [];
	actors = array_add(actors, level.e4_redshirt);
	actors = array_add(actors, level.squad["woods"]);

	//align_node anim_reach_aligned(level.e4_redshirt, "briefing_loop");
	align_node thread anim_loop(level.e4_redshirt, "briefing_loop", "end_sgt_loop");

	align_node anim_reach_aligned(level.squad["woods"], "briefing");
	align_node notify("end_sgt_loop");
	//align_node anim_single_aligned(actors, "briefing");
	
	run_scene("e4_briefing");

	flag_set("e4_briefing_done");
	
	//FOR TUEY: end music as the guys are going into event 4
	setmusicstate ("FIGHT_ON_HILL");
}

event4_dialogue()
{
	//flag_wait("e4_squad_move_a");
	wait 3;

	level.squad["woods"] anim_single(level.squad["woods"], "e4_bastards"); //"Shit...Bastards ain't lettin' up!"
	level.squad["woods"] anim_single(level.squad["woods"], "e4_move"); //Move!


	flag_wait("e4_player_flank");

	level.squad["woods"] anim_single(level.squad["woods"], "e4_rip_em"); //"Rip 'em up!!"

	flag_wait("e4_squad_at_bunker");

	level.squad["woods"] anim_single(level.squad["woods"], "e4_fugassi"); //No fugassi line to hold 'em back this time.

//	flag_wait("e4_woods_burn_cue");
//
//	level.squad["woods"] anim_single(level.squad["woods"], "e4_light_up"); //Let's light these bastards up!
//	level.squad["woods"] anim_single(level.squad["woods"], "e4_do_it"); //Now  MASON! Do it!

	flag_wait("barrels_done");

	wait 0.5;
	level.squad["woods"] anim_single(level.squad["woods"], "e4_hold_em"); //"That should hold 'em"
}

event4_threatbias()
{
	//SetIgnoreMeGroup("player", "e4_anti_allies");
	//SetIgnoreMeGroup("e4_player_allies", "e4_anti_player");

	//set good guy bias
	level.player setThreatBiasGroup( "player" );
	level.squad["woods"] setThreatBiasGroup( "e4_player_allies" );
	level.squad["hudson"] setThreatBiasGroup( "e4_player_allies" );

	//redshirts
	setup_bias_by_spawner("e4_redshirts", "e4_player_allies");
	setup_bias_by_spawner("e4_redshirt_start", "e4_player_allies");
	setup_bias_by_spawner("e4_shredded_1", "e4_player_allies");

	//set nva bias
	setup_bias_by_spawner("e4_hill_nvas_a1", "e4_anti_player");
	setup_bias_by_spawner("e4_hill_nvas_a2", "e4_anti_allies");
	setup_bias_by_spawner("e4_hill_nvas_b1", "e4_anti_player");
	setup_bias_by_spawner("e4_hill_nvas_b2", "e4_anti_allies");
	setup_bias_by_spawner("e4_bunker_runners", "e4_anti_allies");

	//This is the base threat of group1 against group2, which translates to how much entities in group2 will favor entities in group1.
	SetThreatBias("player", "e4_anti_player", 1000);
	SetThreatBias("e4_player_allies", "e4_anti_allies", 1000);//12000
	SetThreatBias("player", "e4_anti_allies", 500);//-15000
	SetThreatBias("e4_player_allies", "e4_anti_player", 500);
}

setup_bias_by_spawner(spawner_name, group_name)
{
	assert(IsDefined(spawner_name), "spawner name not defined dude");
	assert(IsDefined(group_name), "group name not defined dude");
	
	spawners = GetEntArray(spawner_name, "targetname");
	array_thread(spawners, ::add_spawn_function, ::set_my_bias, group_name);
}

set_my_bias(group)
{
	self setThreatBiasGroup( group );
}

set_ai_accuracy()
{
	self.script_accuracy = 0.4;
}

event4_nva_accuracy()
{
	w = GetEntArray("e4_hill_nvas_a1", "targetname");
	x = GetEntArray("e4_hill_nvas_a2", "targetname");
	y = GetEntArray("e4_hill_nvas_b1", "targetname");
	z = GetEntArray("e4_hill_nvas_b2", "targetname");
	
	nva_spawners = array_merge(w, x);
	nva_spawners = array_merge(nva_spawners, y);
	nva_spawners = array_merge(nva_spawners, z);

	array_thread(nva_spawners, ::add_spawn_function, ::set_ai_accuracy);
}

e4_wep_cache_vo()
{
	level endon("e4_player_flank");

	trigger_wait("trig_woods_cache");
	level.squad["woods"] thread anim_single(level.squad["woods"], "gear_up");//"Alright gear up!"

	wait 3;
	
	radio = GetEnt("e4_weapon_cache_radio", "targetname");

	radio.animname = "e4_radio_weps";
	radio anim_single(radio, "wep_cache_radio_2");//Artillery fire targetting the runway, six.
	wait 0.5;
	radio anim_single(radio, "wep_cache_radio_3");//Hercules on fire. Far side of the runway.
	wait 0.75;
	radio anim_single(radio, "wep_cache_radio_4");//Six, you copy my last?	
	wait 0.35;
	radio anim_single(radio, "wep_cache_radio_5");//Say again.
	wait 0.5;
	radio anim_single(radio, "wep_cache_radio_6");//Need you to move about a click West. Meet you there.
	wait 0.35;
	radio anim_single(radio, "wep_cache_radio_7");//I'm not receiving your signal.
	
	wait 5;

	radio.animname = "b52_radio";
	radio anim_single(radio, "wep_cache_radio_0");//Grid pattern - Charlie-three-three and Charlie-three-one.
	radio anim_single(radio, "wep_cache_radio_1");//Roger that, Arc Light copies.
}

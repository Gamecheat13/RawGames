#include maps\_utility;
#include maps\_anim;
#include maps\sink_hole_helicopter;
#include animscripts\shared;

#using_animtree("vehicles");

set_stage_1_triggers()
{
	flag_init("avalanche_triggered");
	flag_init("camille_run_aborted");
	flag_init("camille_spawned");
	flag_init("end_lake_rappel");
	flag_init("reached_water_cave_trigger");
	flag_init("reached_water_cave_trigger2");

	level thread set_approach_wall_trigger();
	level thread set_fuselage_trigger(); 
	level thread set_camille_bridge_run_trigger(); 
	level thread set_water_cave_trigger();

	level thread set_reached_lake_trigger();

	level thread set_hill_top_trigger();
	level thread set_battlefield_exit_trigger();

	
	level thread fuselage();

	level thread lookout_gate();
	level thread hill_badplace();
	level thread hill_badplace_left();
	level thread hill_badplace_right();
	level thread clear_badplaces();
}




begin_story()
{
	collapse_point = getent("bridge_collapse_origin", "targetname");

	place_helicopter();
	level.helicopter thread helicopter_descends("descent_path");
	level.helicopter2 thread helicopter_descends("descent_path2");

	level thread intro_end();

	wait .05;
	level thread letterbox_on();

	
	black_screen_time = 1.0;

	level.player.targetname = "bond";
	level.player FreezeControls(true);

	
	level.hudBlack = newHudElem();
	level.hudBlack.x = 0;
	level.hudBlack.y = 0;
	level.hudBlack.horzAlign = "fullscreen";
	level.hudBlack.vertAlign = "fullscreen";
	level.hudBlack.sort = 0;
	level.hudBlack.alpha = 1;
	level.hudBlack setShader("black", 640, 480);

	level.player setbusvolumes("snd_busvolprio_sceneanim", "sinkhole_begin", 0.0);
	level.player playsound( "sink_hole_intro_filter" );

	wait black_screen_time;

	level.helicopter3 thread helicopter_descends("descent_path3");
	level thread camille();
	VisionSetNaked( "sink_hole_3", 0.0 );
	fade_in(3);
	wait 3;
	fade_out(1.5);
	
	level.camille play_dialogue_nowait("CAMI_SinkG_701A");	
	wait 2;
	VisionSetNaked( "sink_hole_2", 0.0 );
	fade_in(1.5);
	wait 2;
	

	collapse_point PlaySound("sink_hole_random_rocks");
	collapse_point PlaySound("helicopter_avalanche");
	earthquake(.5, 2, collapse_point.origin, 850);

	wait .5;

	fade_out(1);
	wait 1;
	VisionSetNaked( "sink_hole_1", 0.0 );
	fade_in(1);

	
	level notify( "playmusicpackage_action" );

	wait 1;
	level.player play_dialogue_nowait("BOND_SinkG_601A");	

	wait 2;

	playfxontag (level._effect["collapse_dust_oneshot"], collapse_point, "tag_origin");

	collapse_point PlaySound("sink_hole_random_rocks");
	collapse_point PlaySound("cave_expl_debris");
	earthquake(.5, 2, collapse_point.origin, 850);

	destroyed_path = getent("destroyed_path1", "targetname");
	destroyed_path delete();

	wait(1.5);
	getup_point = getent("bond_get_up_origin", "targetname");
	playfxontag (level._effect["collapse_dust_oneshot"], getup_point, "tag_origin");
	wait(1.5);
	
	level thread begin_helicopter_hunting_event();

	fade_out(.3);
	wait .5;
	level.player deactivatebusvolumes("snd_busvolprio_sceneanim", 1.0);
	VisionSetNaked( "sink_hole_geo", 0.0 );
	fade_in(.5);
}

fade_out(t)
{
	level.hudBlack fadeOverTime(t);		
	level.hudBlack.alpha = 1;
}

fade_in(t)
{
	level.hudBlack fadeOverTime(t);		
	level.hudBlack.alpha = 0;
}

intro_end()
{
	level waittill("SH_Camille_Sequence_01_Done");
	level.hudBlack.alpha = 1;

	level thread letterbox_off(.5);
	fade_in(.5);
	wait .5;
	level.player FreezeControls(false);

	flag_set("intro_done");

	

	

	
}

camille(num)
{
	if (!IsDefined(num))
	{
		num = 1;
	}

	while (true)
	{
		if (num == 1)
		{
			level thread display_chyron();
			level.camille start_cutscene("SH_Camille_Sequence_01", "SH_Camille_Sequence_01_Done");
		}
		else if (num == 2)
		{
			level waittill("camille_ledge");
			level.camille start_cutscene("SH_Camille_Sequence_02", "SH_Camille_Sequence_02_Done");
		}
		else if (num == 3)
		{
			level thread camille_run_check();
			level waittill_either("camille_run", "camille_run_aborted");

			if (!flag("camille_run_aborted"))
			{
				flag_set("avalanche_triggered");	
				level.camille start_cutscene("SH_Camille_Sequence_03", "SH_Camille_Sequence_03_Done");
			}
		}
		else if (num == 4)
		{
			flag_wait("reached_bridge_trigger");
			level.camille start_cutscene("SH_Camille_Sequence_04", "SH_Camille_Sequence_04_Done");

			level waittill("SH_Camille_Sequence_04_Done");
			level.camille Hide();
		}
		else if (num == 5)
		{
			flag_wait("camille_quick_kill");

			level.helicopter thread target_spotlight_at_entity(level.camille, .5);

			level thread switch_gun();

			level.camille start_cutscene("SH_Camille_Sequence_05", "SH_Camille_Sequence_05_Done");
			level thread thug_death(level.camille_quick_kill_target);

			level waittill("SH_Camille_Sequence_05_Done");
			
			
			spawner = GetEnt("camille_spawner", "targetname");
			level.camille = spawner StalingradSpawn();
			flag_set("camille_spawned");

			level.camille CmdPlayAnim("Camille_Cover_Idle", false);

			
		}

		wait .05;
		num++;
	}
}

switch_gun()
{
	level.camille waittillmatch("anim_notetrack", "gun_switch");

	level.camille_quick_kill_target gun_remove();

	
	
	
	
	
	
}

camille_run_check()
{
	flag_wait("in_fuselage");

	level thread camille_run_check_reset();
	level endon("camille_run_check_reset");

	waittill_see_avalanche();
	wait 5;
	waittill_see_avalanche();

	level notify("camille_run");
}

camille_run_check_reset()
{
	level endon("camille_run");
	flag_waitopen("in_fuselage");
	level notify("camille_run_check_reset");
	level thread camille_run_check();
}

thug_death(thug)
{
	thug SetEnableSense(false);
	thug CmdPlayAnim("SH_Camille_Sequence_05_Thug_SH_Camille_Seq_05_Thug", false, true);
	wait (4.0);

	level.helicopter thread target_spotlight_at_entity(GetEnt("lake_repel_dest", "targetname"), .5);

	
	thug StartRagDoll();
	
	thug waittill("cmd_done");
	
	thug BecomeCorpse();
}

start_cutscene(cutscene, cutscene_done)
{
	self notify("start_cutscene");
	if (IsDefined(self.cutscene))
	{
		EndCutScene(self.cutscene);
		wait .05;
	}

	self.cutscene = cutscene;
	self Show();
	PlayCutScene(cutscene, cutscene_done);
	self thread end_cutscene(cutscene_done);
}

end_cutscene(note)
{
	self endon("start_cutscene");
	level waittill(note);

	self.cutscene = undefined;
	self Hide();
}







waittill_see_avalanche()
{
	trigger = getent( "avalanche_lookat", "targetname" );
	if (IsDefined(trigger))
	{
		trigger endon( "trigger" );
	}

	org = GetEnt("avalanche_org", "targetname");
	
	while (!player_can_see(org, .8) || !flag("in_fuselage"))
	{
		wait .05;
	}
}

play_ambiant_fire_efx()
{
	level notify("fx_fuelfire");

	engine_fire = getent("engine_fire", "targetname");
	playfxontag (level._effect["small_fire"], engine_fire, "tag_origin");
	
	
	engine_fire playloopsound ("sink_hole_fireloop");

	level waittill("engine_explode");
	
	
}

helicopter_descends(path)
{
	self thread begin_helicopter_patrol(path, 18);
}



begin_helicopter_hunting_event()
{
	level.helicopter thread begin_helicopter_patrol("spotlight_patrol_path", 15);
	level.helicopter thread target_spotlight_at_entity(level.camille, .5);
	level thread helicopter_fires_at_camille(1);
}

set_approach_wall_trigger()
{
	flag_wait("intro_done");

	trigger = getent( "approach_wall_trigger", "targetname" );
	trigger wait_for_trigger_or_timeout(15);
	

	level notify("camille_ledge");

	flag_set("update_yaw");

	
	

	level.helicopter thread target_spotlight_at_entity(level.player, 1);

	wait 5;

	flag_set("player_targeted_by_gunner");

	
	level.org_deathInvulnerableTime = GetDVarInt("player_deathInvulnerableTime");
	setsaveddvar( "player_deathInvulnerableTime", 300 );

	wait 3;

	level.gunner.accuracy_modifier = .9;	
}

set_fuselage_trigger()
{
	level endon("reached_water");
	level endon("camille_run_aborted");
	level endon("reached_bridge_trigger");

	flag_wait("in_fuselage");
	level.camille play_dialogue("CAMI_SinkG_507A");	

	level.helicopter thread target_spotlight_at_path("fuselage_path", 3);

	objective_state(1, "done");
	objective_add(2, "active", &"SINK_HOLE_OBJECTIVE_HEADER_AVOID_HELICOPTER", GetEnt("objective_2_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_AVOID_HELICOPTER");
	objective_state(2, "current");
	
	flag_wait("avalanche_triggered");

	trig = GetEnt("after_fuselage_trigger", "script_noteworthy");
	if (IsDefined(trig))
	{
		trig delete();	
	}

	flag_clear("player_targeted_by_gunner");

	level thread helicopter_fires_at_camille(2);

	wait 1;

	level.camille play_dialogue("CAMI_SinkG_508A");	


	
	

	

	wait 15;

	level.camille play_dialogue("CAMI_SinkG_509A");	
}
















set_camille_bridge_run_trigger()
{
	level thread play_camille_bridge_run();
}

play_camille_bridge_run()
{
	flag_wait("reached_bridge_trigger");
	flag_clear("player_targeted_by_gunner");
	flag_clear("update_yaw");

	if (IsDefined(level.org_deathInvulnerableTime))
	{
		setsaveddvar( "player_deathInvulnerableTime", level.org_deathInvulnerableTime );
	}
	
	if (!flag("avalanche_triggered"))
	{
		flag_set("camille_run_aborted");
		level.helicopter thread begin_helicopter_patrol("strafe_bridge_end", 35);
	}

	level thread helicopter_fires_at_camille(3);

	
}

bridge_run_player_movement_timer()
{
	level endon("reached_water_cave_trigger");

	wait(12);

	level.gunner.accuracy_modifier = 1;
	flag_set("player_targeted_by_gunner");

	wait(6);

	level thread reached_water_cave_trigger(); 
}

set_water_cave_trigger()
{
	level endon("reached_water_cave_trigger");

	trigger = getent( "water_cave_trigger", "targetname" );
	trigger waittill( "trigger" );

	flag_clear("update_yaw");

	level thread water_cave_save();
	level thread reached_water_cave_trigger();
}

water_cave_save()
{
	wait .5;
	level thread maps\_autosave::autosave_now("sink_hole");  
}

reached_water_cave_trigger()
{
	flag_set("reached_water_cave_trigger");

	level thread cave_trigger2();

	level thread bridge_rock();

	level thread place_camille_quick_kill_target();
	level thread set_camille_quick_kill_trigger();

	flag_clear("player_detection");
	flag_clear("player_targeted_by_gunner");

	wait(.05);

	

	level.gunner StopAllCmds();
	level.gunner ClearEnemy();
	
	

	level.helicopter2 thread target_spotlight_at_entity(level.camille, .5);

	level.helicopter SetHoverParams(0, 0, 0);
	level.helicopter thread begin_helicopter_patrol("lake_repel_path", 30);
	wait 2;
	
	

	
	level.helicopter waittill("rappel_node");
	level.helicopter SetSpeedImmediate(0, 20, 20);

	level.helicopter thread target_spotlight_at_path("sweep_lake_path", 6);

	
	level.helicopter notify("rappel_rope_down");
	flag_wait("do_rappel");

	level.quick_kill_infantry = GetEnt("quick_kill_infantry", "targetname") StalingradSpawn();
	level.quick_kill_infantry.health = 4999;	
	level.quick_kill_infantry spawn_failed();

	level.helicopter thread rappel(level.quick_kill_infantry, GetNode("quick_kill_infantry_dest", "targetname"));

	wait(2);
	level.take_down_infantry = GetEnt("take_down_infantry", "targetname") StalingradSpawn();
	level.take_down_infantry spawn_failed();
	level.helicopter thread rappel(level.take_down_infantry, GetNode("takedown_infantry_dest", "targetname"));

	level.quick_kill_infantry thread set_quick_kill_health_normal();

	alert_trig = GetEnt("quickkill_alert_trigger", "targetname");
	alert_trig thread wait_for_detection();

	level.take_down_infantry waittill("rappel_done");
	flag_set("end_lake_rappel");

	level.helicopter SetHoverParams(50, 1, 0.5);

	level.take_down_infantry waittill("death");
	wait 1;

	level.helicopter notify("rappel_rope_up");

	wait 2;
	level.helicopter thread begin_helicopter_patrol("helicopter_hide", 15);

	if (IsDefined(level.quick_kill_infantry) && IsAlive(level.quick_kill_infantry))
	{
		level.quick_kill_infantry waittill("death");
	}

	level.helicopter thread begin_helicopter_patrol("beach_to_repel_path", 25);
	level.helicopter thread target_spotlight_at_path("battle_space_path", 3);

	level.helicopter waittill("end_of_path");
	level.helicopter fake_rappel(8);

	
	level.helicopter thread begin_helicopter_patrol("helicopter_unhide", 15);
	level.helicopter waittill("end_of_path");
	level.helicopter thread begin_helicopter_patrol("helicopter_hide", 15);
}

cave_trigger2()
{
	GetEnt("water_cave_trigger2", "targetname") waittill("trigger");
	flag_set("reached_water_cave_trigger2");

	level.camille play_dialogue("CAMI_SinkG_510A", true);	
}

bridge_rock()
{
	

	rock = GetEnt("bridge_rock", "targetname");
	
	rock playsound("big_rock_shift_1");
	rock RotateRoll(10, .15, .10, 0.0);

	Earthquake(.3, .5, level.player.origin, 500);
	level.player PlaySound("cave_expl_debris");

	level notify("bridge_dust");

	GetEnt("exit_bridge", "targetname") waittill("trigger");
	
	
	Earthquake(.3, .5, level.player.origin, 500);
	
	rock playsound("big_rock_shift_2");
	rock RotateRoll(10, .20, .10, 0.0);

	level notify("bridge_dust");
	
}

set_camille_quick_kill_trigger()
{
	trigger = getent( "camille_quick_kill_trigger", "targetname" );
	trigger waittill( "trigger" );

	flag_set("camille_quick_kill");
	flag_clear("player_targeted_by_gunner");
	flag_clear("update_yaw");

	
	
	

	
	
}

place_camille_quick_kill_target()
{
	spawner = getent( "camille_quick_kill_target", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.camille_quick_kill_target = spawner stalingradspawn("camille");

	if ( spawn_failed(level.camille_quick_kill_target) )
	{
		return;
	}

	level.camille_quick_kill_target.targetname = "thug";
	level.camille_quick_kill_target.dropweapon = false;
}



set_reached_lake_trigger()
{
	trigger = getent( "reached_lake_trigger", "targetname" );
	trigger waittill( "trigger" );

	flag_wait("end_lake_rappel");

	objective_state(2, "done");
	objective_add(3, "active", &"SINK_HOLE_OBJECTIVE_HEADER_STEALTH", GetEnt("objective_3_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_STEALTH");
	objective_state(3, "current");	

	level thread save_once_player_gets_weapon();

	flag_wait("camille_engage");

	level thread camille_lake_combat();

	level thread camille_grenade_throw();

	level.quick_kill_infantry waittill("death", strAttacker, strType);

	if (strType == "MOD_MELEE")
	{
		level.player GiveWeapon("TND16_Sink");
		level.player SwitchToWeapon("TND16_Sink");
	}

	flag_waitopen("camille_fire");

	if (IsDefined(level.camille))
	{
		level.camille delete();
	}

	level.player play_dialogue("CAMI_SinkG_012A", true);	
	level thread place_lake_infantry();

	flag_wait("lake_infantry_cleared");
	level.player play_dialogue("CAMI_SinkG_523A", true);	
}

save_once_player_gets_weapon()
{
	
	level.player waittill("weapon_change", weapon);

	objective_state(3, "done");
	objective_add(4, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_YOURSELF", GetEnt("objective_4_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_YOURSELF");
	objective_state(4, "current");

	level thread wait_for_lake_objective_completion();
	
	maps\_autosave::autosave_by_name("sink_hole");  
}

set_quick_kill_health_normal()
{
	self endon("death");
	self set_quick_kill_health_normal_wait();
	self.health = 100;
}

set_quick_kill_health_normal_wait()
{
	level endon("quick_kill_alerted");
	level.take_down_infantry waittill("death");
	self waittill("goal");
}

wait_for_detection()
{
	level.quick_kill_infantry thread player_touch_alert(self);

	flag_wait("end_lake_rappel");

	node = GetNode("quick_kill_cover", "script_noteworthy");
	GetEnt("quickkill_alert_trigger2", "targetname") thread quickkill_alert_trigger2(self, node);
	self waittill( "trigger" );

	level.quick_kill_alerted = true;
	level notify("quick_kill_alerted");

	if(isalive(level.take_down_infantry))
	{
		level.take_down_infantry SetEnableSense(true);
		level.take_down_infantry SetPerfectSense(true);
		level.take_down_infantry LockAlertState("alert_red");
	}

	if(isalive(level.quick_kill_infantry))
	{
		level.quick_kill_infantry StopCmd();

		destination_node = GetNode("quick_kill_infantry_dest2", "targetname");
		level.quick_kill_infantry SetGoalNode(destination_node);

		
		
		
		InvalidateNode(GetNode("quick_kill_cover", "targetname"));
		

		level.quick_kill_infantry SetEnableSense(true);
		level.quick_kill_infantry SetPerfectSense(true);
		level.quick_kill_infantry LockAlertState("alert_red");
	}
}

quickkill_alert_trigger2(main_trig, node)
{
	node endon("trigger");
	main_trig endon("trigger");

	self waittill("trigger");
	main_trig notify("trigger");
}

player_touch_alert(trig)
{
	self endon("death");

	while (true)
	{
		dist = Distance(level.player.origin, self.origin);
		while (((level.player GetStance() == "stand") && (dist > 100)) || ((level.player GetStance() == "crouch") && (dist > 55)))
		{
			wait .05;
			dist = Distance(level.player.origin, self.origin);
		}

		wait 2.7;

		if (!((level.player GetStance() == "stand") && (dist > 100)) || ((level.player GetStance() == "crouch") && (dist > 55)))
		{
			break;
		}
	}

	trig notify("trigger");
}

camille_eliminates_soldier_vo()
{
	wait 2;

	level.player play_dialogue("CAMI_SinkG_519A", true);	
	wait 1;
	level.player play_dialogue("BOND_SinkG_522A");			
}

remaining_soldier_targets_camille()
{
	level.quick_kill_infantry endon("death");
	level endon("quick_kill_alerted");
	camille_gunshot_position = getent("camille_gunshot_position", "targetname");

	destination_node = GetNode("quick_kill_cover", "targetname");
	level.quick_kill_infantry set_goal_node(destination_node);
	level.quick_kill_infantry waittill("goal");
	level.quick_kill_infantry SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");

	
	while (IsAlive(level.quick_kill_infantry))
	{
		level.quick_kill_infantry CmdShootAtPos(camille_gunshot_position.origin, false, 4, .25);
		level.quick_kill_infantry waittill("cmd_done");
		wait 5;
	}
}

camille_grenade_throw()
{
	flag_wait("camille_spawned");
	camille_gunshot_position = getent("camille_gunshot_position", "targetname");

	
	
	

	grenade_target_1 = getent("camille_grenade_target_1", "targetname");
	grenade_target_2 = getent("camille_grenade_target_2", "targetname");

	level.camille magicgrenade( camille_gunshot_position.origin, grenade_target_1.origin, 2 );
	wait(3); 
	level.camille magicgrenade( camille_gunshot_position.origin, grenade_target_2.origin, 2.5 );
}

place_lake_infantry()
{
	spawner = getentarray( "lake_infantry", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size - 1; i++ )
	{
		level.lake_infantry[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.lake_infantry[i]) )
		{
			return;
		}

		level.lake_infantry[i] SetPerfectSense( true );
		level.lake_infantry[i] lockalertstate( "alert_red" );
	}

	level thread lake_infantry_death_tracker();

	GetEnt("after_lake_tunnel", "targetname") waittill("trigger");
	

	level notify("cleared_lake_skirmish");

	level.player play_dialogue("CAMI_SinkG_013B", true);	
	wait 1;
	level.player play_dialogue("BOND_SinkG_014A");			
}


lake_infantry_death_tracker()
{
	waittill_aigroupcleared("lake_infantry");
	level notify("cleared_lake_skirmish");
}


wait_for_lake_objective_completion()
{
	level waittill("cleared_lake_skirmish");

	objective_state(4, "done");
	objective_add(5, "active", &"SINK_HOLE_OBJECTIVE_HEADER_MOVE", GetEnt("objective_5_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_MOVE");
	objective_state(5, "current");
}




set_hill_top_trigger()
{
	trigger = getent( "hill_top_trigger", "script_noteworthy" );
	trigger waittill( "trigger" );

	level thread hill_checkpoints();

	objective_state(5, "done");
	objective_add(6, "active", &"SINK_HOLE_OBJECTIVE_HEADER_ELIMINATE", GetEnt("objective_6_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_ELIMINATE");
	objective_state(6, "current");
	level thread helicopters_leave();

	remove_surviving_lake_ai();
	
	level.helicopter endon("helicopter_retreating");

	if(isalive(level.gunner))
	{
		level.gunner delete();
	}

	
	GetEnt("hill_helicopter", "targetname") waittill("trigger");

	level.facing_adjustment = -45;
	place_gunner("left");

	

	
	
	
	

	
	
	

	
	
	
	

	level.gunner waittill("death");
	level.helicopter thread helicopter_leaves_sink_hole();
}

hill_checkpoints()
{
	level thread maps\_autosave::autosave_now("sink_hole");

	GetEnt("hill_top_wave2", "target") waittill("trigger");
	level thread maps\_autosave::autosave_by_name("sink_hole"); 

	GetEnt("hill_top_wave3", "target") waittill("trigger");
	level thread maps\_autosave::autosave_by_name("sink_hole"); 
}

helicopters_leave()
{
	level.helicopter3 thread begin_helicopter_patrol("last_cave_node", 10);

	level.helicopter2 thread begin_helicopter_patrol("hill_loop_path", 30);
	level.helicopter2 thread target_spotlight_at_path("battle_space_path", 3);

	wait 10;

	level.helicopter notify("turn_on_spotlight");

	level.helicopter thread begin_helicopter_patrol("helicopter_unhide", 15);
	level.helicopter waittill("end_of_path");

	level.helicopter thread begin_helicopter_patrol("hill_loop_path2", 20);
	level.helicopter thread target_spotlight_at_path("battle_space_path", 3);

	
	GetEnt("hill_helicopter", "targetname") waittill("trigger");

	level.helicopter2 thread helicopter_leaves_sink_hole();
	wait 10;
	level.helicopter thread helicopter_leaves_sink_hole();
}

remove_surviving_lake_ai()
{
	if(isalive(level.camille_hunted_quick_kill))
	{
		
		
		
	}

	if(isalive(level.camille_quick_kill_target))
	{
		level.camille_quick_kill_target delete();
	}

	if(isalive(level.take_down_infantry))
	{
		level.take_down_infantry delete();
	}

	if(isalive(level.quick_kill_infantry))
	{
		level.quick_kill_infantry delete();
	}

	if(isalive(level.camille))
	{
		level.camille delete();
	}

	for( i = 0; i < level.lake_infantry.size; i++ )
	{
		if (isalive(level.lake_infantry[i]))
		{
			level.lake_infantry[i] delete();
		}
	}

	
	level.camille = GetEnt("camille", "targetname");
}

helicopter_leaves_sink_hole(delete_ent)
{
	self notify("helicopter_retreating");

	
	self thread begin_helicopter_patrol("battle_retreat_path", 20);
	self waittill("end_of_path");

	if(IsDefined(delete_ent))
	{
		delete_ent delete();
	}

	
	if (self == level.helicopter)
	{
		
		
	}
	else if (self == level.helicopter2)
	{
		self thread begin_helicopter_patrol("second_entrance_path", 60);

	}
	
	
	
	
}

set_battlefield_exit_trigger()
{
	trigger = getent( "battlefield_exit_trigger", "targetname" );

	wait 1; 
	level.helicopter retreat_from_hill(trigger);

	trigger waittill( "trigger" );

	level.helicopter3 notify("turn_on_spotlight");

	

	ai = GetAIArray("axis");
	for (i = 0; i < ai.size; i++)
	{
		ai[i] SetCombatRole("rusher");
	}

	level thread maps\_autosave::autosave_now("sink_hole"); 
	trigger delete();
}

retreat_from_hill(trigger)
{
	self endon("helicopter_retreating");
	trigger waittill("trigger");
	level.helicopter thread helicopter_leaves_sink_hole(level.gunner);
}



lookout_gate()
{
	gate = GetEnt("lookout_gate", "targetname");
	gate ConnectPaths();
	gate trigger_off();

	badplace = GetEnt("lookout_badplace", "targetname");

	while (true)
	{
		flag_wait("lookout_gate_closed");
		badplace_cylinder("badplace_lookout", -1, badplace.origin, badplace.radius, 1024);
		
		

		flag_waitopen("lookout_gate_closed");
		badplace_delete("badplace_lookout");
		
		
	}
}

hill_badplace()
{
	badplace = GetEnt("hill_badplace", "targetname");
	if (IsDefined(badplace))
	{
		while (true)
		{
			flag_wait("hill_badplace_on");
			badplace_cylinder("hill_badplace", -1, badplace.origin, badplace.radius, 1024);

			flag_waitopen("hill_badplace_on");
			badplace_delete("hill_badplace");
		}
	}
}

hill_badplace_left()
{
	level endon("smoke_cleared");

	badplace = GetEnt("hill_badplace_left", "targetname");
	if (IsDefined(badplace))
	{
		while (true)
		{
			flag_wait("hill_badplace_left_on");
			badplace_cylinder("hill_badplace_left", -1, badplace.origin, badplace.radius, 1024);

			badplace_delete("hill_badplace_right");

			flag_waitopen("hill_badplace_left_on");
			badplace_delete("hill_badplace_left");
		}
	}
}


hill_badplace_right()
{
	level endon("smoke_cleared");

	badplace = GetEnt("hill_badplace_right", "targetname");
	if (IsDefined(badplace))
	{
		while (true)
		{
			flag_wait("hill_badplace_right_on");
			badplace_cylinder("hill_badplace_right", -1, badplace.origin, badplace.radius, 1024);

			badplace_delete("hill_badplace_left");

			flag_waitopen("hill_badplace_right_on");
			badplace_delete("hill_badplace_right");
		}
	}
}

clear_badplaces()
{
	level waittill("smoke_cleared");

	badplace_delete("hill_badplace_left");
	badplace_delete("hill_badplace_right");

	
	
		
	
	badPlace = GetEnt("hill_badplace_left", "targetname");
	if(isDefined(badPlace))
	{
		badPlace delete();
	}
	
	badPlace = GetEnt("hill_badplace_right", "targetname");
	if(isDefined(badPlace))
	{
		badPlace delete();
	}
}

fuselage()
{
	level waittill("gunner_spawned");
	level.gunner endon("death");

	col = GetEnt("fuselage_collision", "targetname");
	fuselage = GetEnt(col.target, "targetname");
	col LinkTo(fuselage);

	junk = GetEntArray("fuselage_junk", "targetname");
	for (i = 0; i < junk.size; i++)
	{
		junk[i] LinkTo(fuselage);
	}

	GetEnt("fxanim_fuselage_loop", "targetname") LinkTo(fuselage);
	GetEnt("fxanim_fuselage_nonloop", "targetname") LinkTo(fuselage);
	GetEnt("fxanim_rope_short", "targetname") LinkTo(fuselage);

	fuselage thread fuselage_penetration_fx();	

	ang_start = fuselage.angles;

	level notify("fuselage_loop_start");
	fuselage thread fuselage_settle();	

	while (true)
	{
		fuselage waittill("damage", amount, attacker);
		level notify("fuselage_nonloop_start");

		if (fuselage.angles != ang_start)
		{
			fuselage RotateTo(ang_start, .3, .1, .1);
			
			fuselage playsound("sink_hole_plane_movements");
			fuselage waittill("rotatedone");
		}

		angle = RandomIntRange(4, 8);

		fuselage PlaySound("sink_hole_plane_impacts", "sink_hole_plane_impacts_done", true);
		fuselage RotateRoll(angle, .8, .4, .4);
		
		fuselage playsound("sink_hole_plane_movements");
		fuselage waittill("rotatedone");

		fuselage PlaySound("sink_hole_plane_impacts", "sink_hole_plane_impacts_done", true);
		fuselage RotateRoll(-1 * angle, .8, .4, .4);
		
		fuselage playsound("sink_hole_plane_movements");
		fuselage waittill("rotatedone");

		fuselage thread fuselage_settle();
	}
}

fuselage_settle()
{
	self endon("damage");

	angle = RandomIntRange(2, 5);

	while (true)
	{
		self RotateRoll(angle, 1.5, .75, .75);
		
		self playsound("sink_hole_plane_movements");
		self waittill("rotatedone");

		self RotateRoll(-1 * angle, 1.5, .75, .75);
		
		self playsound("sink_hole_plane_movements");
		self waittill("rotatedone");
	}
}

fuselage_penetration_fx()
{
	level.gunner endon("death");

	penetration = GetEntArray("fuselage_penetration", "targetname");
	for (i = 0; i < penetration.size; i++)
	{
		penetration[i] LinkTo(self);
	}

	while (penetration.size > 0)
	{
		self waittill("damage", amount, attacker);

		if (IsDefined(attacker) && (attacker == level.gunner))
		{
			penetrate = random(penetration);
			
			penetration = array_remove(penetration, penetrate);

			wait .2;

			level.player playsound("bulletspray_large_metal");
			level.player playsound("whizby");
		}
	}
}

#using_animtree("generic_human");
fake_rappel(num_guys)
{
	self SetSpeedImmediate(0, 10, 10);
	self SetHoverParams(0, 0, 0);
	self notify("rappel_rope_down");

	wait 3;

	iprintlnbold("fake rappel number: " + num_guys);
	
	for (i = 0; i < num_guys; i++)
	{
		guy = Spawn("script_model", self GetTagOrigin("tag_playerride"));
		guy character\character_thug_2_sinkhole::main();
		guy.angles = (0, RandomInt(360), 0);

		guy UseAnimTree(#animtree);
		guy SetAnim(%Thu_SH_Rappel);

		guy thread fake_rappel_move();

		wait RandomFloatRange(1, 2.5);
	}

	self notify("rappel_rope_up");
	wait 3;
	self SetHoverParams(50, 1, 0.5);
}

fake_rappel_move()
{
	self MoveZ(-1000, 7, 3, 2);
	self waittill("movedone");
	self delete();
}

camille_lake_combat()
{
	flag_wait("camille_spawned");
	level.camille endon("death");

	level endon("camille_kills_quick_kill_guy");

	camille_gunshot_position = getent("camille_gunshot_position", "targetname");

	level thread camille_fire(level.take_down_infantry, true);
	wait 1;

	thread camille_eliminates_soldier_vo();

	if(	level.quick_kill_alerted == false)
	{
		level thread remaining_soldier_targets_camille();
	}

	camille_gunshot_position = getent("camille_gunshot_position", "targetname");

	

	
	while(isalive(level.quick_kill_infantry) && level.quick_kill_alerted == false)
	{
		level.quick_kill_infantry waittill("cmd_done");	

		
		level thread camille_fire(level.quick_kill_infantry, false, true);
		level.camille waittill("cmd_done");
	}
}

camille_kills_quick_kill_guy()
{
	wait(60);	

	level notify("camille_kills_quick_kill_guy");

	flag_waitopen("camille_fire");

	
	level thread camille_fire(level.quick_kill_infantry, true);
}







camille_fire(ent, bKill, bBlind)
{
	level.camille SetPainEnable(false);

	if (!IsDefined(bBlind))
	{
		bBlind = false;
	}

	if (!IsDefined(bKill))
	{
		bKill = false;
	}

	fire_time = undefined;
	wait_time = undefined;

	if (bBlind)
	{
		fire_time = 2;
		wait_time = .8;
		level.camille CmdPlayAnim("Camille_Cover_Blindfire_Over", false);
	}
	else
	{
		fire_time = 1.5;
		wait_time = 1.2;
		level.camille CmdPlayAnim("Camille_Cover_PopUp_Fire", false);
	}

	level.camille CmdPlayAnim("Camille_Cover_Idle", false);

	level.camille StopCmd(); 

	flag_set("camille_fire");

	wait wait_time;	

	t = gettime() / 1000;
	t_stop = t + fire_time;

	while (IsAlive(level.camille) && (t < t_stop))
	{
		tag_flash = level.camille GetTagOrigin("tag_flash");
		if (IsDefined(tag_flash) && IsDefined(ent))
		{
			if (bBlind)
			{
				random_error_0 = randomfloatrange(10.0,30.0);
				random_error_1 = randomfloatrange(10.0,30.0);
				random_error_2 = randomfloatrange(10.0,30.0);

				magicbullet( "TND16_Sink", tag_flash, ent geteye() + (random_error_0, random_error_1, random_error_2));
			}
			else
			{
				magicbullet( "TND16_Sink", tag_flash, ent geteye());
			}
		}

		wait(.1);	
		t += .1;
	}

	if (IsDefined(level.camille) && IsAlive(level.camille))
	{
		level.camille waittill("cmd_done");
	}

	flag_clear("camille_fire");
}

remove_surviving_hill_ai()
{
	ai = GetAiArray("axis");
	ai = array_combine(ai, GetSpawnerArray());

	for (i = 0; i < ai.size; i++)
	{
		if (IsDefined(ai[i].script_aigroup))
		{
			switch (ai[i].script_aigroup)
			{
			case "hill_top_infantry":
			case "hill_top_wave2":
			case "hill_top_wave3":
				ai[i] delete();
			}
		}
	}
}

display_chyron()
{
	maps\_introscreen::introscreen_chyron(&"SINK_HOLE_INTRO_01", &"SINK_HOLE_INTRO_02", &"SINK_HOLE_INTRO_03");
}
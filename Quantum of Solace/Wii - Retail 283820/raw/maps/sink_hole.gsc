#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#include maps\sink_hole_helicopter;
#using_animtree("vehicles");

main()
{
	ssao_set(2.5, 5.0);	

	maps\sink_hole_fx::main();
	maps\_blackhawk::main( "v_blackhawk" );

	precachemodel( "shanty_thug_complete_h1_b1" );
	precachemodel( "v_blackhawk_static_damage" );
	PreCacheItem("m60e3");

	
	PrecacheCutScene("SH_Camille_Sequence_01");
	PrecacheCutScene("SH_Camille_Sequence_02");
	PrecacheCutScene("SH_Camille_Sequence_03");
	PrecacheCutScene("SH_Camille_Sequence_04");
	PrecacheCutScene("SH_Camille_Sequence_05");
	
	
	PrecacheCutScene("SH_Final_Sequence");
	
	level.strings["sink_hole_phone_title_1"] = &"SINK_HOLE_PHONE_TITLE_1";
	level.strings["sink_hole_phone_body_1"] = &"SINK_HOLE_PHONE_BODY_1";

	maps\_load::main();
	maps\sink_hole_snd::main();
	maps\sink_hole_mus::main();

	array_thread(GetEntArray("flare", "targetname"), ::flare);
	
	
	array_thread(GetEntArray("vision_set", "targetname"), ::vision_set_trigger);

	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	
	
	
	

	
	precacheShader( "compass_map_sink_hole" );
	setminimap( "compass_map_sink_hole", 6160, 4040, -7608, -3944  );
	maps\_phone::setup_phone();

	setpostfxblendmaterial("passoutfx");
	VisionSetNaked( "sink_hole_0", .01 );

	level.lake_infantry = [];

	level.hill_top_wave2_infantry = [];
	level.hill_top_wave3_infantry = [];

	level.bowl_infantry = [];
	level.bowl_second_wave = [];
	level.bowl_third_wave = [];
	level.bowl_trickle = [];
	level.sniper_infantry = [];
	level.camille_infantry = [];
	level.camille_reinforcements = [];
	level.camille_final_wave = [];
	level.dead_crew = [];
	level.smoke_rusher = [];
	level.rag_doll_men = [];
	level.early_exit_infantry = [];
	

	level.sniper_group_killed = 0;
	level.bowl_infantry_killed = 0;
	level.total_bowl_infantry = 0;
	level.gunners_killed = 0;
	level.pilots_killed = 0;
	level.facing_adjustment = 0;
	level.diorama_infantry_killed = 0;
	level.total_lake_infantry = 0;

	level.helicopter_detection_active = false;
	
	level.quick_kill_alerted = false;
	level.player_always_seen = false;
	
	
	flag_init("player_detection");
	flag_init("camille_quick_kill");
	flag_init("intro_done");
	flag_init("update_yaw");
	flag_init("camille_fire");
	level.player_past_trench = false;
	level.player_reached_high_ground = false;
	level.player_on_side_a = false;

	level.mine_tunnel_destroyed = false;
	level.side_wall_destroyed = false;
	level.end_wall_destroyed = false;
	level.rpg_placed = false;
	level.camille_final_wave_deployed = false;
	level.camille_vo_done = false;
	level.within_quick_kill_distance = false;
	level.grenade_thrown = false;
	level.lower_smoke_active = false;
	level.middle_smoke_active = false;
	level.upper_smoke_active = false;

	level.sniper_infantry_alerted = false;
	level.sniper_alerted = false;
	level.gunner_on_right = false;
	level.end_of_level = false;
	level.bowl_cleared = false;
	level.player_in_sniper_perch = false;

	level.skipto = "none";

	level thread setup_bond();
	level.camille = GetEnt("camille", "targetname");

	level thread maps\sink_hole_1::set_stage_1_triggers();
	level thread maps\sink_hole_2::set_stage_2_triggers();

	level thread player_shot_at();

	VisionSetNaked( "sink_hole_geo", 6 );

	
	setExpFog(3477, 2047, 0.414, 0.5833, 0.7218, 0, 1);

	if (!skipto())
	{
		maps\sink_hole_1::begin_story();  

		flag_wait("intro_done");
		objective_add(1, "active", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_FUSELAGE", GetEnt("objective_1_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_FUSELAGE");
		objective_state(1, "current");

		maps\_autosave::autosave_now("sink_hole"); 
	}
}


skipto()  
{
	level.skipto = getdvar( "skipto" );

	ret = true;

	if (level.skipto == ( "lake" ) )
	{
		flag_set("avalanche_triggered");
		player_reposition = getent ( "lake_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );

		level thread maps\sink_hole_1::camille(5);

		place_helicopter();
		level.helicopter notify("turn_on_spotlight");
		level.helicopter2 notify("turn_on_spotlight");
		level.helicopter3 notify("turn_on_spotlight");
	}
	else if (level.skipto == ( "hill" ) )
	{
		hilltop_battle_checkpoint = getent ( "player_battle_reposition", "targetname" );
		level.player setorigin ( hilltop_battle_checkpoint.origin);
		level.player setplayerangles( hilltop_battle_checkpoint.angles );

		level.player GiveWeapon("concussion_grenade");
		level.player GiveWeapon("TND16_Sink");
		level.player GiveMaxAmmo("TND16_Sink");
		level.player SwitchToWeapon("TND16_Sink");

		place_helicopter();
		wait(2);

		level.helicopter notify("turn_on_spotlight");
		level.helicopter2 notify("turn_on_spotlight");
		level.helicopter3 notify("turn_on_spotlight");
	}
	else if (level.skipto == ( "bowl" ) )
	{
		player_reposition = getent ( "bowl_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );

		level.player GiveWeapon("concussion_grenade");
		level.player GiveWeapon("TND16_Sink");
		level.player GiveMaxAmmo("TND16_Sink");
		level.player SwitchToWeapon("TND16_Sink");

		place_helicopter();
		

		level.helicopter3 thread begin_helicopter_patrol("last_cave_node", 30);
		level.helicopter3 notify("turn_on_spotlight");

		
		
	
		level.helicopter3 waittill("end_of_path");
		iPrintLnBold( "helicopter in place");
    }
	else if (level.skipto == ( "sniper" ) )
	{
		player_reposition = getent ( "sniper_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );

		level.player GiveWeapon("concussion_grenade");
		level.player GiveWeapon("TND16_Sink");
		level.player GiveMaxAmmo("TND16_Sink");
		level.player SwitchToWeapon("TND16_Sink");

		place_helicopter();
		
	}
	else if (level.skipto == ( "test" ) )
	{
		player_reposition = getent ( "test_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );

		level.player GiveWeapon("concussion_grenade");
		level.player GiveWeapon("TND16_Sink");
		level.player GiveMaxAmmo("TND16_Sink");
		level.player SwitchToWeapon("TND16_Sink");

		place_helicopter();

		level notify("change_rpg_facing");
		wait(1);

		if(isdefined(level.gunner))
		{
			if(isalive(level.gunner))
			{
				level.gunner DoDamage( 500, ( 0, 0, 0 ) );
				level.gunner hide();
			}
		}

		level.helicopter thread begin_helicopter_patrol("sniper_descent_path", 60);

		iPrintLnBold( "helicopter descending");
		
		level.helicopter waittill("end_of_path");

		iPrintLnBold( "look at activated");
		level.helicopter setLookAtEnt( level.player );
		level.helicopter SetLookAtEntYawOffset( 90 );

		level.helicopter thread begin_helicopter_patrol("sniper_dual_gun_pass_path", 10);

	}
	else if (level.skipto == ( "test_cutscene" ) )
	{
		place_helicopter();
		player_reposition = getent ( "test_cutscene_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );
		level thread maps\sink_hole_1::camille(3);
	}
	else if (level.skipto == ( "cutscene" ) )
	{
		
		
		
		
		

		

		level.helicopter = getent( "temp_helicopter", "targetname" );
		level.helicopter delete();

		level.helicopter2 = getent( "helicopter2", "targetname" );
		level.helicopter2 delete();

		level.helicopter3 = getent( "helicopter3", "targetname" );
		level.helicopter3 delete();


		level.camille = GetEnt("camille", "targetname");

		level.camille Attach("w_t_m4", "tag_weapon_right");
		level.camille Attach("w_t_m4_mag", "tag_clip_m4");
		level.camille Attach("w_t_carry_handle", "tag_weapon_m4");
		level.camille Attach("w_t_stock", "tag_stock");
		level.camille Attach("w_t_front_sight_post", "tag_weapon_m4");
		level.camille Attach("w_t_foregrip", "tag_weapon_m4");







		playcutscene("SH_Final_Sequence","SH_Final_Sequence_Done");
		level waittill("SH_Final_Sequence_Done");
	}
	else
	{
		ret = false;
	}

	return ret;
}

check_for_damage(text_message)
{
	while(1)
	{
		self waittill("damage");
		
		wait(.5);
	}
}


setup_bond()
{
 	level.player takeallweapons();
	maps\_phone::setup_phone();
	SetSavedDVar("p99_ammo_chance", 0);
}

player_shot_at()
{
	flag_init("rumble");
	
	level thread rumble();
	level thread physics();

	while (true)
	{
		if (IsDefined(level.gunner))
		{
			flag_clear("rumble");
			level.gunner waittill("weapon_fired");

			if (IsPlayer(level.gunner.enemy))
			{
				if (flag("in_fuselage"))	
				{
					Earthquake(.1, .2, level.player.origin, 200, 0);
					flag_set("rumble");
				}
				else
				{
					Earthquake(.3, .2, level.player.origin, 200, 0);
					flag_set("rumble");
				}
			}
			else
			{
				flag_clear("rumble");
			}
		}
		else
		{
			flag_clear("rumble");
		}

		wait .2;
	}
}

rumble()
{
	level.rumble = false;
	level thread stop_rumble();

	while (true)
	{
		flag_waitopen("rumble");
		flag_wait("rumble");

		if (!level.rumble)
		{
			level.player PlayRumbleLoopOnEntity("earthquake");
			level.rumble = true;
		}
	}
}

stop_rumble()
{
	while (true)
	{
		flag_wait("rumble");
		flag_waitopen("rumble");

		level.player StopRumble("earthquake");
		level.rumble = false;
	}
}

physics()
{
	while (true)
	{
		flag_waitopen("rumble");
		flag_wait("rumble");

		wait .05;
		while (level.rumble)
		{
			PhysicsJolt(level.player.origin, 500, 200, (0, 0, .4));
			wait .1;
		}
	}
}

flare()
{
	self light_flicker(true, self GetLightIntensity() - .3);	
}

smoke_thrower()
{
	guy = self;
	if (self isSpawner())
	{
		self waittill("spawned", guy);
		if (spawn_failed(guy))
		{
			return;
		}
	}

	guy SetCtxParam("Weapon", "EnableGrenades", "0");	
	
}

throw_grenade_node()
{
	self waittill("trigger", guy);

	ctx = guy GetCtxParam("Weapon", "EnableGrenades");
	
	guy SetCtxParam("Weapon", "EnableGrenades", "1");	

	

	targets = GetEntArray(self.target, "targetname");

	org = undefined;
	if (targets.size > 0)
	{
		target = random(targets);
		guy CmdThrowGrenadeAtEntity(target, false);	
		org = target.origin;
	}
	else
	{
		guy CmdThrowGrenadeAtEntity(level.player, false);	
		org = level.player.origin;
	}

	guy waittill("cmd_done");

	targ = Spawn("script_origin", org);
	targ thread smoke_rush();

	guy SetCtxParam("Weapon", "EnableGrenades", ctx);	
}

smoke_rush()
{
	if (!IsDefined(level.active_smoke_grenades))
	{
		level.active_smoke_grenades = 1;
	}
	else
	{
		level.active_smoke_grenades++;
	}

	self endon("end_smoke_rush");

	wait RandomInt(5, 7); 
	self thread end_smoke_rush();

	

	while (true)
	{
		rusher = get_closest_ai(self.origin);
		if (IsDefined(rusher) && IsAlive(rusher))
		{
			
			rusher SetCombatRole("Rusher");
		}
		else
		{
			wait 1;
			continue;
		}

		rusher waittill("death");
		wait 2;
	}
}

end_smoke_rush()
{
	wait 35; 
	self notify("end_smoke_rush");

	level.active_smoke_grenades--;
	if (level.active_smoke_grenades == 0)
	{
		level notify("smoke_cleared");
	}

	
	self delete();
}

vision_set_trigger()
{
	while (true)
	{
		self waittill("trigger");
		
		
		VisionSetNaked(self.script_string, 6.0);

		while (level.player IsTouching(self))
		{
			wait .05;
		}
	}
}

play_kneel_anim()
{
	self stopallcmds();
	self CmdAction ( "CheckVitalSign");
}

play_earpieace_anim()
{
	self stopallcmds();
	self CmdAction ( "CheckVitalSign");
}
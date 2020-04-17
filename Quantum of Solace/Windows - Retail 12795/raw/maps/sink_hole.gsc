#include maps\_utility;
#include animscripts\shared;
#include maps\_anim;
#include maps\sink_hole_helicopter;
#using_animtree("vehicles");

main()
{
	ssao_set(1.3, 3.65);	// set screen space ambient occlusion settings

	maps\_blackhawk::main( "v_blackhawk" );

	precachemodel( "shanty_thug_complete_h1_b1" );
	precachemodel( "v_blackhawk_static_damage" );
	PreCacheItem("m60e3");

	// cutscenes
	PrecacheCutScene("SH_Camille_Sequence_01");
	PrecacheCutScene("SH_Camille_Sequence_02");
	PrecacheCutScene("SH_Camille_Sequence_03");
	PrecacheCutScene("SH_Camille_Sequence_04");
	PrecacheCutScene("SH_Camille_Sequence_05");
	//PrecacheCutScene("SH_Camille_Sequence_05_thug");
	PrecacheCutScene("SH_Camille_Sequence_07");
	PrecacheCutScene("SH_Final_Sequence");
	
	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	level.strings["sink_hole_phone_title_1"] = &"SINK_HOLE_PHONE_TITLE_1";
	level.strings["sink_hole_phone_body_1"] = &"SINK_HOLE_PHONE_BODY_1";

	maps\_load::main();
	maps\sink_hole_fx::main();
	maps\sink_hole_snd::main();
	maps\sink_hole_mus::main();

	array_thread(GetEntArray("flare", "targetname"), ::flare);
	array_thread(GetEntArray("smoke_thrower", "script_noteworthy"), ::smoke_thrower);
	array_thread(GetNodeArray("throw_grenade", "script_noteworthy"), ::throw_grenade_node);
	array_thread(GetEntArray("vision_set", "targetname"), ::vision_set_trigger);

	setWaterSplashFX("maps/Casino/casino_spa_splash1");
	setWaterFootSplashFX("maps/Casino/casino_spa_foot_splash");
	setWaterWadeIdleFX("maps/Casino/casino_spa_wading_idle");
	setWaterWadeFX("maps/Casino/casino_spa_wading");

	//Optimized buoyancy time settings foe Whites Estate
	//See MikeA if you have any questions
	//SetSavedDVar("phys_maxFloatTime", 15000);
	//SetSavedDVar("phys_floatTimeVariance", 3000);
	
		SetSavedDVar("phys_maxFloatTime",300000); //make things float

	// Phone setup
	//precacheShader( "compass_map_sink_hole" );
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
	//level.sniper_collapse_dust_point = [];

	level.sniper_group_killed = 0;
	level.bowl_infantry_killed = 0;
	level.total_bowl_infantry = 0;
	level.gunners_killed = 0;
	level.pilots_killed = 0;
	level.facing_adjustment = 0;
	level.diorama_infantry_killed = 0;
	level.total_lake_infantry = 0;

	level.helicopter_detection_active = false;
	//level.player_detected = false;
	level.quick_kill_alerted = false;
	level.player_always_seen = false;
	//level.player_targeted_by_gunner = false;
	//flag_init("player_targeted_by_gunner");	//initialized by trigger
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
	level.turret_battle_active = false;

	level.skipto = "none";

	level thread setup_bond();
	level.camille = GetEnt("camille", "targetname");

	level thread maps\sink_hole_1::set_stage_1_triggers();
	level thread maps\sink_hole_2::set_stage_2_triggers();

	level thread player_shot_at();
	level thread dad_rocket_jump_fix();

	VisionSetNaked( "sink_hole_geo", 6 );

	//SetExpFog(“fog near plane”, “fog half plane”, “fog red”, “fog green”, “fog blue”, “Lerp time”, “Fog max”);
	setExpFog(3477, 2047, 0.414, 0.5833, 0.7218, 0, 1);

	if (!skipto())
	{
		maps\sink_hole_1::begin_story();  // plays intro cutscene and starts hunted event

		flag_wait("intro_done");
		objective_add(1, "active", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_FUSELAGE", GetEnt("objective_1_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_FUSELAGE");
		objective_state(1, "current");

		maps\_autosave::autosave_now("sink_hole"); //  1. (game play begins) As soon as the player gets control, after Camille draws the chopper away.
	}
}


skipto()  //TEMP:this is only used for debugging
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
		//level.helicopter thread activate_spotlight();

		level.helicopter3 thread begin_helicopter_patrol("last_cave_node", 30);
		level.helicopter3 notify("turn_on_spotlight");

		//level.player play_dialogue("BOND_SinkG_511A"); // Thanks.

		//level.player play_dialogue("CAMI_SinkG_506A");  Hurry Bond, get to cover

		//level.helicopter2 thread begin_helicopter_patrol("second_entrance_path", 60);
		//level.helicopter2 notify("turn_on_spotlight");
	
		level.helicopter3 waittill("end_of_path");
		iPrintLnBold( "helicopter in place");

		level.hudBlack = newHudElem();
		level.hudBlack.x = 0;
		level.hudBlack.y = 0;
		level.hudBlack.horzAlign = "fullscreen";
		level.hudBlack.vertAlign = "fullscreen";
		level.hudBlack.sort = 0;
		level.hudBlack.alpha = 0;
		level.hudBlack setShader("black", 640, 480);

		maps\_autosave::autosave_by_name("sink_hole");
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
		//level.pilot thread maps\sink_hole_2::pilot_death_tracker(); // temp test

		level.hudBlack = newHudElem();
		level.hudBlack.x = 0;
		level.hudBlack.y = 0;
		level.hudBlack.horzAlign = "fullscreen";
		level.hudBlack.vertAlign = "fullscreen";
		level.hudBlack.sort = 0;
		level.hudBlack.alpha = 0;
		level.hudBlack setShader("black", 640, 480);
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
		//level thread manage_boss_fight_searchlight();
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
		//place_helicopter();
		//player_reposition = getent ( "test_cutscene_reposition", "targetname" );
		//level.player setorigin ( player_reposition.origin);
		//level.player setplayerangles( player_reposition.angles );
		//level thread maps\sink_hole_1::camille(3);

		//maps\sink_hole_2::remove_fall_damage_triggers();

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





/*
		spawner = getent( "camille_diorama", "targetname");
		if ( !IsDefined( spawner) )
		{
			iPrintLnBold( "Spawner Not Defined!" );
			return;
		}

		level.camille = spawner stalingradspawn();

		if ( spawn_failed(level.camille) )
		{
			return;
		}

		level.camille lockalertstate( "alert_green" );
		level.camille.team = "allies";
		level.camille setpainenable( false );
		level.camille allowedStances ("crouch");
		*/

		playcutscene("SH_Final_Sequence","SH_Final_Sequence_Done");
		level waittill("SH_Final_Sequence_Done");
	}
	else if (level.skipto == ( "cutscene2" ) )
	{
		player_reposition = getent ( "player_ending_reposition", "targetname" );
		level.player setorigin ( player_reposition.origin);
		level.player setplayerangles( player_reposition.angles );

		maps\sink_hole_2::remove_fall_damage_triggers();

		level.helicopter = getent( "temp_helicopter", "targetname" );
		level.helicopter delete();

		level.helicopter2 = getent( "helicopter2", "targetname" );
		level.helicopter2 delete();

		level.helicopter3 = getent( "helicopter3", "targetname" );
		level.helicopter3 delete();

		spawner = getent( "camille_diorama_spawner", "targetname");


		if ( !IsDefined( spawner) )
		{
			iPrintLnBold( "Spawner Not Defined!" );
			return;
		}

		level.camille_diorama = spawner stalingradspawn();

		if ( spawn_failed(level.camille_diorama) )
		{
		return;
		}

		level.camille_diorama.targetname = "camille_diorama";

		level.camille_diorama lockalertstate( "alert_green" );
		level.camille_diorama.team = "allies";
		level.camille_diorama setpainenable( false );

		wait(8);

		PlayCutScene("SH_Camille_Sequence_07", "SH_Camille_Sequence_07_Done");
		level waittill("SH_Camille_Sequence_07_Done");
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
		//iPrintLnBold( text_message );
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
	
	// JA - Disabled for performance optimization on MSR machine.
	// level thread physics();

	while (true)
	{
		if (IsDefined(level.gunner))
		{
			flag_clear("rumble");
			level.gunner waittill("weapon_fired");

			if (IsPlayer(level.gunner.enemy))
			{
				if (flag("in_fuselage"))	// this means the player is in the fuselage. Make the shake less in there.
				{
					Earthquake(.1, .2, level.player.origin, 200, 1/.1);
					flag_set("rumble");
				}
				else
				{
					Earthquake(.3, .2, level.player.origin, 200, 1/.3);
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

// leave these functions around because they manage level.rumble which is used by physics
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
//			this is done by the earthquake command
//			level.player PlayRumbleLoopOnEntity("earthquake");
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

//		the earthquake command automatically sets a stop time
//		level.player StopRumble("earthquake");
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
	self light_flicker(true, self GetLightIntensity() - .3);	// flicker between light intensity and .3 lower
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

	guy SetCtxParam("Weapon", "EnableGrenades", "0");	//disable grenades
	//Print3d(guy.origin, "smoke thrower", (1, 0, 0), 1, 2, 200);
}

throw_grenade_node()
{
	if (level.ps3 || level.bx ) //GEBE
	{
		return;	// ps3 apparently can't handle the smoke fx, so we can only do the smoke grenades on xenon
	}

	self waittill("trigger", guy);

	if(isdefined(guy.script_noteworthy) && guy.script_noteworthy == "smoke_thrower")
	{
		ctx = guy GetCtxParam("Weapon", "EnableGrenades");

		guy SetCtxParam("Weapon", "EnableGrenades", "1");	//enable grenades

		//Print3d(guy.origin + (0, 0, 70), "throwing smoke", (0, 1, 0), 1, 2, 50);

		targets = GetEntArray(self.target, "targetname");

		org = undefined;
		if (targets.size > 0)
		{
			target = random(targets);
			guy CmdThrowGrenadeAtEntity(target, false);	//throw grenade
			org = target.origin;
		}
		else
		{
			guy CmdThrowGrenadeAtEntity(level.player, false);	//throw grenade
			org = level.player.origin;
		}

		guy waittill("cmd_done");

		//if(level.turret_battle_active == false)
		//{
		targ = Spawn("script_origin", org);
		targ thread smoke_rush();
		//}

		guy SetCtxParam("Weapon", "EnableGrenades", ctx);	//put this setting back to what it was
	}
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

	wait RandomInt(5, 7); // about the time it takes for the smoke to get to about full strength
	self thread end_smoke_rush();

	//Print3d(self.origin, "starting smoke rush", (0, 1, 0), 1, 1, 300);

	while (true)
	{
		if (!IsDefined(level.disable_rushers) || !level.disable_rushers)
		{
			rusher = get_closest_ai(self.origin);
			if (IsDefined(rusher) && IsAlive(rusher))
			{
				//Print3d(rusher.origin, "rusher", (0, 0, 1), 1, 1, 100);
				rusher SetCombatRole("Rusher");
			}
			else
			{
				wait 1;
				continue;
			}

			rusher waittill("death");
		}

		wait 5;
	}
}

end_smoke_rush()
{
	wait 35; // about the time it takes for the smoke to fade
	self notify("end_smoke_rush");

	level.active_smoke_grenades--;
	if (level.active_smoke_grenades == 0)
	{
		level notify("smoke_cleared");
	}

	//Print3d(self.origin, "ending smoke rush", (1, 0, 0), 1, 1, 300);
	self delete();
}

vision_set_trigger()
{
	while (true)
	{
		self waittill("trigger");
		
		//iPrintLnBold("Setting Vision Set: " + self.script_string);
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

////////////////////////////////////////////////////////////////////////////////////
//                  FIX DAD ROCKET JUMP              
////////////////////////////////////////////////////////////////////////////////////
// DCS: checking amount, if shot right on you damage is greater than 125, anything less normal damage.
dad_rocket_jump_fix()
{
	level.player endon("death");
	while(true)
	{
		wait(0.05);
		level.player waittill("damage", amount, attacker,direction_vec, point, type);
		if(attacker == level.player && type == "MOD_PROJECTILE_SPLASH" && amount >= 125)
		{
			//iprintlnbold("amount of DAD damage", amount);
			level.player dodamage( level.player.health *2, level.player.origin);
		}	 
	}	
}	

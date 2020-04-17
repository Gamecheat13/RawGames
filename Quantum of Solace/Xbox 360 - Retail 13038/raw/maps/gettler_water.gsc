#include maps\_utility;
#include maps\gettler_util;

main()
{
	flag_initialize("raising_water");

	//level splash_fx();  // don't work right

	maps\_sea::main();
	level._sea_clear_viewbob = false;
	level._sea_litebob_scale = .5;
	//level._sea_viewbob_scale = .5;

	level._sea_scale = .2;
	level._sea_flip_rotation = true;

	if (!IsDefined(level.water_level_index))
	{
		level.water_level_index = 0;
	}

 	level.water_boil_fx = GetEnt("water_boil", "targetname");
 	level.water_boil_fx LinkTo(level._sea_link);

	// Get all water level script origins
	level.water_levels = GetEntArray("water_level", "targetname");

	// sort them by depth
	for (i = 0; i < level.water_levels.size; i++)
	{
		x = i - 1;
		water_level = level.water_levels[i];
		while (x >= 0 && level.water_levels[x].origin[2] > water_level.origin[2])
		{
			level.water_levels[x + 1] = level.water_levels[x];
			x--;
		}
		level.water_levels[x + 1] = water_level;
	}

	// main water thread
	level.sea_model thread do_water();
}

//
// do_water - handles water interaction with the player
//
do_water()
{
	depth_allow_prone = 8;
	depth_allow_crouch = 33;

	//drowning_point = Spawn("script_model", level.player.origin + (0, 0, 60));
	drowning_point = Spawn("script_model", level.player GetTagOrigin("SpineUpper"));
	drowning_point SetModel("tag_origin");
	drowning_point LinkTo(level.player, "SpineUpper");

	allow_cover_point = Spawn("script_model", level.player GetTagOrigin("L_Knee_Bulge"));
	allow_cover_point SetModel("tag_origin");
	allow_cover_point LinkTo(level.player, "SpineLower");

	level thread slow_player_in_water();

	was_in_cover = false;

	while (true)
	{
		wait .3;
		if (allow_cover_point IsTouching(self))
		{
			flag_set("player_in_water");

			if (level.player IsInCover())
			{
				level.player ForceOutOfCover();
				wait .3;
				was_in_cover = true;
			}
			else
			{
				was_in_cover = false;
			}

			SetSavedDVar("cover_disable", "1");

			if (was_in_cover)
			{
				wait 1;	// wait another second if the player was in cover so the player can stand up before checking drowning point
			}

			damage_count = 0;
			while (drowning_point IsTouching(self))
			{
				level.player DoDamage(100, level.player.origin);
				
				damage_count++;
				if (damage_count > 7)
				{
					// we probably haven't died yet because we're in (demi)god mode, mission fail so player is not stuck
					missionFailedWrapper();
				}

				wait .3;
			}

			damage_count = 0;
		}
		else
		{
			SetSavedDVar("cover_disable", "0");
			flag_clear("player_in_water");
		}
	}

	//	if (level.player IsTouching(self))
	//	{
	//		depth = self.origin[2] - level.player.origin[2];

	//		//slow the players movement based on how deep it is
	//		new_speed = int(level.default_run_speed - (depth * 5));
	//		if (new_speed < 50)
	//		{
	//			new_speed = 50;
	//		}

	//		//assertex(new_speed <= 190, "water is setting speed to higher than default.");
	//		if (new_speed > level.default_run_speed)
	//		{
	//			new_speed = level.default_run_speed;
	//		}

	//		thread maps\_load::waterThink_rampSpeed(new_speed);

	//		//controll the allowed stances in this water height
	//		if (depth > depth_allow_crouch)
	//			level.player AllowCrouch(false);
	//		else
	//			level.player AllowCrouch(true);

	//		//if (depth > depth_allow_prone)
	//		//	level.player allowProne(false);	// No Prone!
	//		//else
	//		//	level.player allowProne(true); // No Prone!

	//		//iPrintLnBold(depth);

	//		if (depth > 50)
	//		{
	//			MissionFailed();
	//		}
	//	}
	//	else
	//	{
	//		//level.player allowProne(true); // No Prone!
	//		level.player allowCrouch(true);
	//		level.player allowStand(true);

	//		thread maps\_load::waterThink_rampSpeed(level.default_run_speed);
	//	}
	//}
}

slow_player_in_water()
{
	while (true)
	{
		flag_wait("player_in_water");
		while (flag("player_in_water"))
		{
			SetSavedDVar("player_runSpeedScale", .5);
			wait .1;
		}
		wait .1;
	}
}

//
// drown - threaded on all AI, so they die if they go under water
//
drown()
{
	self endon("death");

	drowning_point = Spawn("script_model", self GetTagOrigin("SpineUpper"));
	drowning_point SetModel("tag_origin");
	drowning_point LinkTo(self, "SpineUpper");

	while (true)
	{
		wait .3;
		if (drowning_point IsTouching(level.sea_model))
		{
			if (!IsDefined(self.magic_bullet_shield) || !self.magic_bullet_shield)
			{
				self DoDamage(self.health << 1, self.origin);
			}
		}
	}
}

//
// raise_water - raises the water level
//
raise_water(index, time)
{
//	flag_set("_sea_physbob"); set at the start

	if (level.water_level_index > 0)
	{
		level.dont_raise_water_from_popped_bags = true;	// once the water raises once, don't drown the player for popping more bags
	}

	if (!flag("front_door_closed"))
	{
		level thread maps\gettler::close_front_door();
		flag_wait("front_door_closed");
	}

	//if (flag("raising_water"))
	//{
	//	//flag_waitopen("raising_water");	// wait untill the water is not raising
	//	//wait .5;
	//	assertmsg("already raising water");
	//	return;
	//}

	flag_waitopen("raising_water");

	if( IsDefined( level.vesper ) && !IsDefined(level.vesper.playing_elevator_dialog))
	{
		level.vesper thread vesper_elevator_dialog();
	}

	level.player PlaySound("GET_water_raise");
	
	level._sea_scale = .4;
	//level._sea_sway_pause = 3;

	if (!IsDefined(index) || (level.water_level_index < index))
	{
		//flag_set("_sea_viewbob");

		if (!IsDefined(time))
		{
			time = 10;
		}

		if (level.water_level_index == 2)	// bring this one quicker
		{
			time = 6;
		}
		
		level thread maps\gettler_util::shake_building(time, .2);
		level thread water_fx(level.water_level_index);

		maps\gettler_water::surface_fx();
		level._sea_link MoveZ(level.water_levels[level.water_level_index].origin[2] - level.sea_model.origin[2], time, time * .4, time * .2);
		
		noteworthy = undefined;
		if (IsDefined(level.water_levels[level.water_level_index].script_noteworthy))
		{
			noteworthy = level.water_levels[level.water_level_index].script_noteworthy;
		}
		
		tilt_back = false;
		if (IsDefined(noteworthy) && (noteworthy == "tilt_back"))
		{
			tilt_back = true;					
		}
		
		// tilt building
		new_angles = undefined;
		if (IsDefined(level.water_levels[level.water_level_index].target))
		{
			tilt_again = GetEnt(level.water_levels[level.water_level_index].target, "targetname");
			if (IsDefined(tilt_again))
			{
				new_angles = tilt_again.angles;
			}
		}

		if (!flag("super_tilt"))
		{
			level thread tilt_building(level.water_levels[level.water_level_index].angles, time, tilt_back, new_angles);
		}

		flag_set("raising_water");	
		wait time - 3;

		if (level.water_level_index == 1)
		{
			level notify("fx_caustics1_on");
		}

		wait 3;

		level thread maps\gettler_util::shake_building(2, .5);

		level.water_level_index++;
		level notify("water_level" + level.water_level_index);
		flag_clear("raising_water");
		level notify("stop_water_fx");

		if (level.water_level_index == 1)
		{
			MusicStop(0);
		}

		maps\_spawner::kill_spawnerNum(90 + level.water_level_index);
	}
}

surface_fx(time)
{
 	PlayFxOnTag(level._effect["gettler_water_boiling"], level.water_boil_fx, "tag_origin");
// 	wait 1;
// 	PlayFxOnTag(level._effect["gettler_water_boiling"], level.water_boil_fx, "tag_origin");
// 	wait 1;
// 	PlayFxOnTag(level._effect["gettler_water_boiling"], level.water_boil_fx, "tag_origin");
// 	wait 1;
// 	PlayFxOnTag(level._effect["gettler_water_boiling"], level.water_boil_fx, "tag_origin");
}

trigger_water()
{
	self waittill("trigger");
	level thread raise_water(undefined, self.script_float);

	if (IsDefined(self.script_string))
	{
		maps\_sea::sea_add_physics_group(self.script_string, 1.5);
	}
}

water_fx(index)
{
	level endon("stop_water_fx");

	time = 0;
	if (index == 0)
	{
		wait 6;
		while (true)
		{
			wait .5;
			time += .5;
			level notify("fx_water_effects_1");
			if (time >= 5)
			{
				break;
			}
		}
	}
	else if (index == 2)
	{
		//wait 12;
		ent = GetEnt("third_floor_water_fx", "targetname");
		while (!ent IsTouching(level.sea_model))
		{
			wait .05;
		}

		while (true)
		{
			wait .5;
			time += .5;
			level notify("fx_water_effects_2");
			if (time >= 5)
			{
				break;
			}
		}

		while (ent IsTouching(level.sea_model))
		{
			wait .05;
		}

		while (!ent IsTouching(level.sea_model))
		{
			wait .05;
		}

		time = 0;
		while (true)
		{
			wait .5;
			time += .5;
			level notify("fx_water_effects_2");
			if (time >= 5)
			{
				break;
			}
		}
	}
	else if (index == 3)
	{
		wait 5.5;
		while (true)
		{
			wait .5;
			time += .5;
			level notify("fx_water_effects_3");
			if (time >= 5)
			{
				break;
			}
		}
	}
}

splash_fx()
{
	nodes = getstructarray ("splash_fx","targetname");
	tags = [];

	for (i = 0; i < nodes.size; i++)
	{
		tags[i] = Spawn("script_model", nodes[i].origin);
		tags[i] SetModel("tag_origin");
		//tags[i].angles = nodes[i].angles;
		tags[i] LinkTo(GetEnt("sea", "targetname"));
	}

	level thread do_splaash_fx(tags);
}

do_splaash_fx(tags)
{
	level waittill("water_level1");

	while (true)
	{
		flag_wait("shaking");
		rand = RandomInt(100);
		if (rand % 2)
		{
			//Print3d(random(tags).origin, "* SPLASH FX *", (0, 0, 1), 1, 2, 80);
			PlayfxOnTag(level._effect["gettler_falling_debris03"], random(tags), "tag_origin");
		}

		wait 3;
	}
}
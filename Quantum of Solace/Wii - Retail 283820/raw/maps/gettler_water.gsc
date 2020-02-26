#include maps\_utility;
#include maps\gettler_util;

main()
{
	flag_initialize("raising_water");

	

	maps\_sea::main();
	level._sea_clear_viewbob = false;
	level._sea_litebob_scale = .5;
	

	level._sea_scale = .2;
	level._sea_flip_rotation = true;

	flag_set("_sea_physbob");

	if (!IsDefined(level.water_level_index))
	{
		level.water_level_index = 0;
	}

	
	level.water = GetEnt("sea", "targetname");
	

	
	level.water_levels = GetEntArray("water_level", "targetname");

	
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

	
	level.water thread do_water();
}




do_water()
{
	depth_allow_prone = 8;
	depth_allow_crouch = 33;
	depth_allow_stand = 50;

	drowning_point = Spawn("script_model", level.player.origin + (0, 0, 60));
	drowning_point SetModel("tag_origin");
	drowning_point LinkTo(level.player);

	while (true)
	{
		wait .05;
		if (drowning_point IsTouching(self))
		{
			missionFailedWrapper();
		}
	}
	
	
	

	
	
	
	
	
	

	
	
	
	
	

	

	
	
	
	
	

	
	
	
	

	

	
	
	
	
	
	
	
	
	
	

	
	
	
}




drown()
{
	self endon("death");

	while (true)
	{
		wait .3;
		depth = level.water.origin[2] - self.origin[2];
		if (depth > 0)
		{
			if (depth > 50)
			{
				if (!IsDefined(self.magic_bullet_shield) || !self.magic_bullet_shield)
				{
					self DoDamage(self.health, self.origin);
				}
			}
		}
	}
}




raise_water(index, time)
{


	if (level.water_level_index > 0)
	{
		level.dont_raise_water_from_popped_bags = true;	
	}

	if (!flag("front_door_closed"))
	{
		level thread maps\gettler::close_front_door();
		flag_wait("front_door_closed");
	}

	
	
	
	
	
	
	

	flag_waitopen("raising_water");

	level.player PlaySound("GET_water_raise");
	
	level._sea_scale = .4;
	

	if (!IsDefined(index) || (level.water_level_index < index))
	{
		

		if (!IsDefined(time))
		{
			time = 10;
		}

		if (level.water_level_index == 2)	
		{
			time = 6;
		}
		
		
		level thread maps\gettler_util::shake_building(time, .2);
		level thread water_fx(level.water_level_index);

		level thread surface_fx(time);
		level._sea_link MoveZ(level.water_levels[level.water_level_index].origin[2] - level.water.origin[2], time, time * .4, time * .2);
		
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
	
	
	surface_fx = Spawn("script_model", level._sea_link.origin);
	surface_fx SetModel("tag_origin");
	surface_fx.angles = level._sea_link.angles;
	surface_fx LinkTo(level._sea_link);

	test = GetEnt("fx_test", "targetname");
	PlayFxOnTag(level._effect["gettler_water_surface1"], surface_fx, "tag_origin");
	wait time;
	surface_fx delete();
}

trigger_water()
{
	self waittill("trigger");
	level thread raise_water(undefined, self.script_float);
	
	
	
	
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
			
			PlayfxOnTag(level._effect["gettler_falling_debris03"], random(tags), "tag_origin");
		}

		wait 3;
	}
}
#include common_scripts\utility;
#include maps\_utility;
#include maps\feature_utility;

main()
{
	level.disableArrivals = false;
	level.disableExits = false;

	maps\_load::main();
	animscripts\dog_init::initDogAnimations();

	add_global_spawn_function("axis", ::spawn_think);
	add_global_spawn_function("allies", ::spawn_think);

	// increase the player's speed
	currentSpeed = GetDvarInt("g_speed");
	SetSavedDvar("g_speed", currentSpeed * 4);

	level.title_screen["title"] = "AI Traversal";
	level.title_screen["desc"][0] = "This test map demonstrates different";
	level.title_screen["desc"][1] = "types of AI traversals.";

	// NEW
	level thread spawn_area("dive_over_40",				::one_way,		"dive_over_40");
	level thread spawn_area("jump_across_72",			::one_way,		"jump_across_72");
	level thread spawn_area("jump_across_120",			::one_way,		"jump_across_120");
	level thread spawn_area("jump_down_36",				::one_way,		"jump_down_36");
	level thread spawn_area("jump_down_40",				::one_way,		"jump_down_40");
	level thread spawn_area("jump_down_56",				::one_way,		"jump_down_56");
	level thread spawn_area("jump_down_96",				::one_way,		"jump_down_96");
	level thread spawn_area("mantle_on_36",				::one_way,		"mantle_on_36");
	level thread spawn_area("mantle_on_40",				::one_way,		"mantle_on_40");
	level thread spawn_area("mantle_on_48",				::one_way,		"mantle_on_48");
	level thread spawn_area("mantle_on_52",				::one_way,		"mantle_on_52");
	level thread spawn_area("mantle_on_56",				::one_way,		"mantle_on_56");
	level thread spawn_area("mantle_over_36",			::one_way,		"mantle_over_36");
	level thread spawn_area("mantle_over_40",			::one_way,		"mantle_over_40");
	level thread spawn_area("mantle_over_96",			::one_way,		"mantle_over_96");
	level thread spawn_area("mantle_over_40_down_80",	::one_way,		"mantle_over_40_down_80");
	level thread spawn_area("mantle_window_36",			::one_way,		"mantle_window_36");
	level thread spawn_area("mantle_window_dive_36",	::one_way,		"mantle_window_dive_36");
	level thread spawn_area("slide_across_car",			::one_way,		"slide_across_car");

	level thread spawn_area("mantle_over_40_dog",		::one_way,		"mantle_over_40_dog");
	level thread spawn_area("mantle_window_36_dog",		::one_way,		"mantle_window_36_dog");
	level thread spawn_area("slide_across_car_dog",		::one_way,		"slide_across_car_dog");

	level thread spawn_area("stairs_up_8x8_2",			::one_way,		"stairs_up_8x8 2 & 3");
	level thread spawn_area("stairs_up_8x8_4",			::one_way,		"stairs_up_8x8 4 & 5");
	level thread spawn_area("stairs_up_8x8_6",			::one_way,		"stairs_up_8x8 6 & 7");
	level thread spawn_area("stairs_up_8x8_8",			::one_way,		"stairs_up_8x8 8 & 9");
	level thread spawn_area("stairs_up_8x8_10",			::one_way,		"stairs_up_8x8 10 & 11");
	level thread spawn_area("stairs_up_8x8_16",			::one_way,		"stairs_up_8x8 16 & 17");
	level thread spawn_area("stairs_up_8x8_20",			::one_way,		"stairs_up_8x8 20 & 21");

	level thread spawn_area("stairs_down_8x8_2",		::one_way,		"stairs_down_8x8 2 & 3");
	level thread spawn_area("stairs_down_8x8_4",		::one_way,		"stairs_down_8x8 4 & 5");
	level thread spawn_area("stairs_down_8x8_6",		::one_way,		"stairs_down_8x8 6 & 7");
	level thread spawn_area("stairs_down_8x8_8",		::one_way,		"stairs_down_8x8 8 & 9");
	level thread spawn_area("stairs_down_8x8_10",		::one_way,		"stairs_down_8x8 10 & 11");
	level thread spawn_area("stairs_down_8x8_16",		::one_way,		"stairs_down_8x8 16 & 17");
	level thread spawn_area("stairs_down_8x8_20",		::one_way,		"stairs_down_8x8 20 & 21");

	level thread spawn_area("stairs_up_8x12_2",			::one_way,		"stairs_up_8x12 2 & 3");
	level thread spawn_area("stairs_up_8x12_4",			::one_way,		"stairs_up_8x12 4 & 5");
	level thread spawn_area("stairs_up_8x12_6",			::one_way,		"stairs_up_8x12 6 & 7");
	level thread spawn_area("stairs_up_8x12_8",			::one_way,		"stairs_up_8x12 8 & 9");
	level thread spawn_area("stairs_up_8x12_10",		::one_way,		"stairs_up_8x12 10 & 11");
	level thread spawn_area("stairs_up_8x12_12",		::one_way,		"stairs_up_8x12 12 & 13");
	level thread spawn_area("stairs_up_8x12_16",		::one_way,		"stairs_up_8x12 16 & 17");
	level thread spawn_area("stairs_up_8x12_18",		::one_way,		"stairs_up_8x12 18 & 19");

	level thread spawn_area("stairs_up_8x16_2",			::one_way,		"stairs_up_8x16 2 & 3");
	level thread spawn_area("stairs_up_8x16_4",			::one_way,		"stairs_up_8x16 4 & 5");
	level thread spawn_area("stairs_up_8x16_6",			::one_way,		"stairs_up_8x16 6 & 7");
	level thread spawn_area("stairs_up_8x16_8",			::one_way,		"stairs_up_8x16 8 & 9");
	level thread spawn_area("stairs_up_8x16_10",		::one_way,		"stairs_up_8x16 10 & 11");
	level thread spawn_area("stairs_up_8x16_16",		::one_way,		"stairs_up_8x16 16 & 17");

	level thread spawn_area("stairs_down_8x12_2",		::one_way,		"stairs_down_8x12 2 & 3");
	level thread spawn_area("stairs_down_8x12_4",		::one_way,		"stairs_down_8x12 4 & 5");
	level thread spawn_area("stairs_down_8x12_6",		::one_way,		"stairs_down_8x12 6 & 7");
	level thread spawn_area("stairs_down_8x12_8",		::one_way,		"stairs_down_8x12 8 & 9");
	level thread spawn_area("stairs_down_8x12_10",		::one_way,		"stairs_down_8x12 10 & 11");
	level thread spawn_area("stairs_down_8x12_12",		::one_way,		"stairs_down_8x12 12 & 13");
	level thread spawn_area("stairs_down_8x12_16",		::one_way,		"stairs_down_8x12 16 & 17");
	level thread spawn_area("stairs_down_8x12_18",		::one_way,		"stairs_down_8x12 18 & 19");

	level thread spawn_area("stairs_down_8x16_2",		::one_way,		"stairs_down_8x16 2 & 3");
	level thread spawn_area("stairs_down_8x16_4",		::one_way,		"stairs_down_8x16 4 & 5");
	level thread spawn_area("stairs_down_8x16_6",		::one_way,		"stairs_down_8x16 6 & 7");
	level thread spawn_area("stairs_down_8x16_8",		::one_way,		"stairs_down_8x16 8 & 9");
	level thread spawn_area("stairs_down_8x16_10",		::one_way,		"stairs_down_8x16 10 & 11");
	level thread spawn_area("stairs_down_8x16_16",		::one_way,		"stairs_down_8x16 16 & 17");

	level thread spawn_area("generic_example",			::one_way,		"generic_example");

	// OLD
	level thread spawn_area("window_down",				::one_way,		"window_down");
	level thread spawn_area("ladder_up-ladder_down",	::back_over,	"ladder_up-ladder_down");
	level thread spawn_area("jump_over_high_wall",		::one_way,		"jump_over_high_wall");
	level thread spawn_area("step_up",					::one_way,		"step_up");

	setup_generic_anims();
	hud();

	level thread toggle_exits_and_arrivals();

	feature_start();
}

spawn_think()
{
	self.ignoreall = true;
	self.disableArrivals = level.disableArrivals;
	self.disableExits = level.disableExits;
}

hud()
{
	level.hud_arrivals = NewHudElem();
	level.hud_arrivals.alignX = "left";
	level.hud_arrivals.horzAlign = "left";
	level.hud_arrivals.x = 0; 
	level.hud_arrivals.y = 80;
	level.hud_arrivals.fontscale = 1.5;
	level.hud_arrivals.color = (0.7, 0.7, 0.7);

	level.hud_exits = NewHudElem();
	level.hud_exits.alignX = "left";
	level.hud_exits.horzAlign = "left";
	level.hud_exits.x = 130; 
	level.hud_exits.y = 80;
	level.hud_exits.fontscale = 1.5;
	level.hud_exits.color = (0.7, 0.7, 0.7);

	level thread hud_update();
}

hud_update()
{
	while (true)
	{
		level.hud_arrivals SetText("Arrivals: " + !level.disableArrivals);
		level.hud_exits SetText("Exits: " + !level.disableExits);
		wait_network_frame();
	}
}

toggle_exits_and_arrivals()
{
	wait_for_all_players();

	while (true)
	{
		player = get_players()[0];
		if (player ButtonPressed("BUTTON_LSHLDR"))
		{
			if (player ButtonPressed("DPAD_LEFT"))
			{
				level.disableArrivals = !level.disableArrivals;
			}
			else if (player ButtonPressed("DPAD_RIGHT"))
			{
				level.disableExits = !level.disableExits;
			}
			else
			{
				wait .05;
				continue;
			}

			wait .5;
		}

		wait .05;
	}
}

/*//////////////////////////////////////////////////////////////////////////////
Does the traversal one way
*///////////////////////////////////////////////////////////////////////////////

one_way(guys)
{
	array_wait(guys, "goal");
	wait 3;

	return true;
}

/*//////////////////////////////////////////////////////////////////////////////
Does the traversal one way and then comes back the other way
*///////////////////////////////////////////////////////////////////////////////
back_over(guys)
{
	guy = guys[0];
	guy endon("death");

	node1 = GetNode(guy.targetname + "_node1", "targetname");
	node2 = GetNode(guy.targetname + "_node2", "targetname");

	guy SetGoalNode(node1);
	guy waittill("goal");
	guy SetGoalNode(node2);
	guy waittill("goal");

	wait .5;

	return true;
}

#using_animtree ("generic_human");
setup_generic_anims()
{
	level.scr_anim[ "generic" ][ "jump_down_40" ]		= %ai_jump_down_40;
}
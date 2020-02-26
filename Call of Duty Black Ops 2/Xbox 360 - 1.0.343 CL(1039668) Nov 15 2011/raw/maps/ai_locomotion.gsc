#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility;
#include maps\feature_utility;

main()
{
	maps\_load::main();

	level.title_screen["title"] = "AI Locomotion";
	level.title_screen["desc"][0] = "This test map demonstrates the various aspects of AI path following";
	level.title_screen["desc"][1] = "and locomotion animations. To see the improvements";
	level.title_screen["desc"][2] = "use Devgui->Ai->Path Following->Toggle All Improvements";
	level.title_screen["bullets"][0] = "Press LB + DPAD UP/DOWN to toggle between different test areas";
	level.title_screen["bullets"][1] = "Press LB + DPAD LEFT/RIGHT to change desired turn angles";
	level.title_screen["bullets"][2] = "Press LB + L-STICK to toggle forced strafing";

	level thread spawn_area("locomotion",			::locomotion,			"LOCOMOTION");
	level thread spawn_area("locomotion_ignore",	::locomotion_ignore,	"LOCOMOTION IGNORE PLAYER");
	level thread spawn_area("dir_change",			::dir_change_normal,	"DIRECTION CHANGE");
	level thread spawn_area("dir_change_stop",		::dir_change_stop,		"DIRECTION CHANGE WITH STOP");
	level thread spawn_area("straight_run",			::locomotion_no_stop,	"STRAIGHT RUN");
	level thread spawn_area("stand_to_run",			::stand_to_run,			"STAND TO RUN");
	level thread spawn_area("exposed_turn",			::exposed_turn,			"EXPOSED TURN");
	level thread spawn_area("melee",				::melee,				"MELEE & SHOTGUN");
	level thread spawn_area("stairs",				::stairs,				"STAIRS");
	level thread spawn_area("special_runs",			::specialRuns,			"SPECIAL CHARACTER RUNS");

	level.stand_to_run_node_index = 0;
	level.enable_player_vulnerability = true;

	add_ai_animtype( "default", character\c_rus_military1::main, character\c_rus_military1::precache );
	add_ai_animtype( "spetsnaz", character\c_rus_spetznaz_1::main, character\c_rus_spetznaz_1::precache );

	feature_start();
}

enable_cqb_transitions()
{
	if( !self isCQBWalking() )
	{
		self enable_cqbwalk();
	}
}

specialRuns(guys)
{
	for( i=0; i < guys.size; i++ )
	{
		guys[i].ignoreall = true;
		guys[i] thread specialRunToNode();
	}

	guys[0] waittill( "death" );
}

specialRunToNode(guy)
{
	self endon("death");

	node1 = GetNode(self.script_noteworthy + "_1", "targetname");
	node2 = GetNode(self.script_noteworthy + "_2", "targetname");

	while( IsAlive(self) )
	{
		self SetGoalNode(node1);
		self waittill("goal");
		self SetGoalNode(node2);
		self waittill("goal");
	}
}

locomotion_ignore(guys)
{
	guys[0].ignoreall = true;
	locomotion(guys);
}

locomotion_no_stop(guys)
{
	guys[0].pathenemyfightdist = 0;
	locomotion(guys);
}

locomotion(guys)
{
	guy = guys[0];

	guy endon("death");

	node1 = GetNode(guy.targetname + "_node1", "targetname");
	node2 = GetNode(guy.targetname + "_node2", "targetname");

	wait(0.05);

	while (IsAlive(guy))
	{
		guy SetGoalNode(node1);
		guy waittill("goal");
		guy SetGoalNode(node2);
		guy waittill("goal");
	}
}

stand_to_run(guys)
{
	guy = guys[0];
	guy.ignoreall = true;

	nodes = GetNodeArray("stand_to_run_nodes", "targetname");

	wait 1;
	guy SetGoalNode(nodes[level.stand_to_run_node_index]);

	level.stand_to_run_node_index++;
	if (level.stand_to_run_node_index >= nodes.size)
	{
		level.stand_to_run_node_index = 0;
	}

	guy waittill("goal");
	wait 3;
	return true; // delete guys
}

exposed_turn(guys)
{
	guy = guys[0];
	guy AllowedStances("stand");

	guy thread exposed_turn_target();

	guy waittill("death");
}

exposed_turn_target()
{
	self endon("death");

	while (true)
	{
		target = simple_spawn_single("exposed_turn_target");
		target waittill("death");
	}
}

melee(guys)
{
	waittill_dead(guys);
	return true;
}

stairs(guys)
{
	guy = guys[0];

	while (IsDefined(guy) && IsAlive(guy))
	{
		node = GetNode("node1", "targetname");
		guy SetGoalNode(node);
		guy waittill("goal");
		node = GetNode("node0", "targetname");
		guy SetGoalNode(node);
		guy waittill("goal");
	}

	return true;
}

dir_change(guys, goalRadius, nodeDist, nodeName, maxTimer, waitBetweenNodes )
{
	guy = guys[0];
	guy endon("death");

	if( !IsDefined(level.dir_change_desired_angle) )
	{
		level.dir_change_desired_angle = 0;
	}

	if( !IsDefined(level.dir_change_force_strafe) )
	{
		level.dir_change_force_strafe = false;
	}

	guy thread dir_change_show_legend();
	guy thread dir_change_angle_manager();

	guy.pathenemyfightdist = 64;
	guy.goalradius = goalRadius;
	guy.force_strafe = false;
	level.dir_change_min_node_dist = nodeDist;

	nodes = GetNodeArray( nodeName, "targetname" );

	wait(0.05);

	if( nodes.size > 0 )
	{
		while( 1 )
		{
			node = guy dir_change_pick_node(nodes);
			guy SetGoalNode(node);
			
			// print angle
			toNode = node.origin - guy.origin;
			yawDiff = VectorToAngles(toNode)[1] - guy.angles[1];
			yawDiff = yawDiff * (1.0 / 360.0);
			yawDiff = (yawDiff - floor(yawDiff + 0.5)) * 360.0;

			if( IsDefined(level.dir_change_last_angle_hud) )
			{
				level.dir_change_last_angle_hud SetText("Last angle: " + yawDiff);
			}
			
			timer = 0;
			while( distanceSquared( node.origin, guy.origin ) > level.dir_change_min_node_dist*level.dir_change_min_node_dist && timer < maxTimer )
			{
				if( timer > 1.0 && guy.faceMotion && guy.a.script == "move" && level.dir_change_force_strafe )
				{
					guy OrientMode("face enemy");
					guy.force_strafe = true;
				}
				else if( guy.force_strafe && !level.dir_change_force_strafe )
				{
					guy OrientMode("face default");
					guy.force_strafe = false;
				}

				line( node.origin, guy.origin, (1,0,0) );
				//record3dtext( "Goal", node.origin, (1,0,0), "Script" );

				timer += 0.05;
				wait 0.05;
			}

			wait(waitBetweenNodes);
		}
	}
}

dir_change_normal(guys)
{
	dir_change(guys, 4, 156, "dir_change_node", 3, 0);
}

dir_change_stop(guys)
{
	dir_change(guys, 16, 16, "dir_change_stop_node", 999999, 1);
}

dir_change_show_legend()
{
	// wait for other thread to finish
	while( IsDefined(level.dir_change_desired_angle_hud) )
	{
		wait(0.05);
	}

	level.dir_change_desired_angle_hud = NewHudElem();
	level.dir_change_desired_angle_hud.alignX = "left";
	level.dir_change_desired_angle_hud.horzAlign = "left";
	level.dir_change_desired_angle_hud.x = 0; 
	level.dir_change_desired_angle_hud.y = 80;
	level.dir_change_desired_angle_hud.fontscale = 1.5;
	level.dir_change_desired_angle_hud.color = (1, 1, 1);
	dir_change_update_desired_angle();

	level.dir_change_last_angle_hud = NewHudElem();
	level.dir_change_last_angle_hud.alignX = "left";
	level.dir_change_last_angle_hud.horzAlign = "left";
	level.dir_change_last_angle_hud.x = 0; 
	level.dir_change_last_angle_hud.y = 100;
	level.dir_change_last_angle_hud.fontscale = 1.5;
	level.dir_change_last_angle_hud.color = (1, 1, 1);

	level.dir_change_force_strafe_hud = NewHudElem();
	level.dir_change_force_strafe_hud.alignX = "left";
	level.dir_change_force_strafe_hud.horzAlign = "left";
	level.dir_change_force_strafe_hud.x = 0; 
	level.dir_change_force_strafe_hud.y = 120;
	level.dir_change_force_strafe_hud.fontscale = 1.5;
	level.dir_change_force_strafe_hud.color = (1, 1, 1);
	dir_change_update_force_strafe();

	while( IsDefined(self) && IsAlive(self) )
	{
		wait 0.05;
	}

	level.dir_change_desired_angle_hud		destroy();
	level.dir_change_last_angle_hud			destroy();
	level.dir_change_force_strafe_hud		destroy();

	level.dir_change_desired_angle_hud		= undefined;
	level.dir_change_last_angle_hud			= undefined;
	level.dir_change_force_strafe_hud		= undefined;
}

dir_change_update_desired_angle()
{
	if( level.dir_change_desired_angle == 0 )
	{
		level.dir_change_desired_angle_hud SetText("Desired angle: random");
	}
	else
	{
		level.dir_change_desired_angle_hud SetText("Desired angle: " + level.dir_change_desired_angle);
	}
}

dir_change_update_force_strafe()
{
	if( level.dir_change_force_strafe )
	{
		level.dir_change_force_strafe_hud SetText("Forced Strafe: on");
	}
	else
	{
		level.dir_change_force_strafe_hud SetText("Forced Strafe: off");
	}
}

dir_change_pick_node(nodes)
{
	bestNode = undefined;

	if( level.dir_change_desired_angle == 0 )
	{
		bestNode = nodes[ RandomInt(nodes.size) ];
	}
	else
	{
		bestDelta = 999999;
		for( i=0; i < nodes.size; i++ )
		{
			node = nodes[i];

			// don't pick close nodes
			if( distanceSquared( node.origin, self.origin ) < level.dir_change_min_node_dist*level.dir_change_min_node_dist )
			{
				continue;
			}

			// find the node with closest angle to desired
			toNode = node.origin - self.origin;
			yawDiff = VectorToAngles(toNode)[1] - self.angles[1];
			yawDiff = yawDiff * (1.0 / 360.0);
			yawDiff = (yawDiff - floor(yawDiff + 0.5)) * 360.0;

			delta = AbsAngleClamp180(level.dir_change_desired_angle - yawDiff);
			if( delta < bestDelta )
			{
				bestDelta = delta;
				bestNode = node;
			}
		}
	}

	return bestNode;
}

dir_change_angle_manager()
{
	self endon("death");

	wait_for_all_players();

	while( 1 )
	{
		player = get_players()[0];
		if (player ButtonPressed("BUTTON_LSHLDR"))
		{
			if (player ButtonPressed("DPAD_RIGHT"))
			{
				level.dir_change_desired_angle += 20;
				if (level.dir_change_desired_angle > 180 )
				{
					level.dir_change_desired_angle = -160;
				}
				
				dir_change_update_desired_angle();

				wait 0.2;
			}
			else if (player ButtonPressed("DPAD_LEFT"))
			{
				level.dir_change_desired_angle -= 20;
				if (level.dir_change_desired_angle < -180 )
				{
					level.dir_change_desired_angle = 160;
				}
				
				dir_change_update_desired_angle();

				wait 0.2;
			}
			else if (player ButtonPressed("BUTTON_LSTICK"))
			{
				level.dir_change_force_strafe = !level.dir_change_force_strafe;

				dir_change_update_force_strafe();

				wait 0.2;
			}
		}

		wait .05;
	}
}

#include maps\_utility;

/////////////////////////////////////////////////////////////////////////
// _chase.gsc - Chase Manager utilizing new Chase code functionality   //
/////////////////////////////////////////////////////////////////////////

//
// main - chase initialization
//

main()
{
	level._chase_debug = 0;
}

//
// debug - enable/disable debug prints
//

debug(enable)
{
	level._chase_debug = enable;
}

//
// start_chase_route - wrapper for SetGoalNode to a chase node and start threads to handle chase notifies from script
//

start_chase_route(chase_node)
{
	self SetGoalNode(chase_node);

/#
	_chase_debug_print("Starting Chase Route");
#/

	self thread _chase_on_goal();
	self thread _chase_too_close();
	self thread _chase_too_far();
	self thread _chase_too_far_timeout();
	self thread _chase_route_end();
}

//
// pause_chase_route - wrapper for PauseChaseRoute
// sends a notify
//

pause_chase_route()
{
/#
	_chase_debug_print("Pausing Chase Route");
#/

	self PauseChaseRoute();
	self notify("pausing_chase");
}

//
// resume_chase_route - wrapper for ResumeChaseRoute
// sends a notify
//

resume_chase_route()
{
/#
	_chase_debug_print("Resuming Chase Route");
#/

	self ResumeChaseRoute();
	self notify("resuming_chase");
}

///////////////////////////////////////////////////////////////
// System Functions, not meant to be called by other scripts //
///////////////////////////////////////////////////////////////

//
// _chase_on_goal - Main chase function.  Monitors for "goal" notifies and handles conditions set on the chase nodes.
//

_chase_on_goal()
{
	self endon("death");
	self endon("chase_route_done");

	while (true)
	{
		self waittill("goal", node);
		if (IsDefined(node))
		{		
			// wait for a flag //
			if (IsDefined(node.script_flag_wait) && (!flag(node.script_flag_wait)))
			{
				self thread _chase_pause(maps\_utility::flag_wait, self, node.script_flag_wait);

	/#
				_chase_debug_print("Waiting For Flag '" + node.script_flag_wait + "'");
	#/
			}
			
			// wait a specified amount of time //
			if (IsDefined(node.script_wait) || (IsDefined(node.script_wait_min) && IsDefined(node.script_wait_max)))
			{
				self thread _chase_pause(maps\_utility::script_wait, node);

	/#
				_chase_debug_print("Waiting at wait node");
	#/
			}

			// wait for a trigger //
			ents = GetEntArray(node.targetname, "target");
			triggers = [];
			for (i = 0; i < ents.size; i++)
			{
				if (issubstr(ents[i].classname, "trigger_"))
				{
					triggers[triggers.size] = ents[i];
				}
			}

			if (triggers.size > 0)
			{
				self thread _chase_pause(::_chase_wait_for_trigger, self, triggers);

	/#
				_chase_debug_print("Waiting for trigger");
	#/
			}

			// Command Node //
			nodes = GetNodeArray(node.targetname, "target");

			cnodes = [];
			for (i = 0; i < nodes.size; i++)
			{
				if (nodes[i].type == "Command")
				{
					cnodes[cnodes.size] = nodes[i];
				}
			}

			if (cnodes.size)
			{
				cnode = random(cnodes);
				if (IsDefined(cnode))
				{
					self thread _chase_pause(::_chase_command_node, self, cnode);
	/#
					_chase_debug_print("Command Node");
	#/
				}
			}

			////////////////////
		}
		else
		{
			// we get an undefined node when we break off to a command node, so we shouldn't assert
			//assertmsg("_chase: Chase node is undefined.");
			//break;
		}
	}
}

//
// _chase_pause - pauses the chase route and waits for the given function to return before resuming the chase route.
//

_chase_pause(func, ent, param1, param2, param3)
{
	self endon("death");
	self endon("chase_route_done");

	if (IsDefined(func))
	{
		self endon("resuming_chase");
		self pause_chase_route();
		call_function(func, ent, param1, param2, param3);
		self resume_chase_route();
	}
}

//
// _chase_too_close - monitor for the "chase_too_close" message from code.
//

_chase_too_close()
{
	self endon("death");
	self endon("chase_route_done");

	while (true)
	{
		self waittill("chase_too_close");

/#
		_chase_debug_print("Too Close");
#/

		// Too close callback //
		if (IsDefined(self._chase_too_close_callback))
		{
			self [[ self._chase_too_close_callback ]]();
		}
		
		// TODO: What do we do when the player is too close?

	}
}

//
// _chase_too_far - monitor for the "chase_too_far" message from code.
//

_chase_too_far()
{
	self endon("death");
	self endon("chase_route_done");

	while (true)
	{
		self waittill("chase_too_far");
		
/#
		_chase_debug_print("Too Far");
#/

		// Too far callback //
		if (IsDefined(self._chase_to_far_callback))
		{
			self [[ self._chase_too_far_callback ]]();
		}
		
		// TODO: What do we do when the player is too far?

	}
}

//
// _chase_too_far_timeout - monitor for the "chase_too_far_timeout" message from code.
//

_chase_too_far_timeout()
{
	self endon("death");
	self endon("chase_route_done");

/#
	_chase_debug_print("Waiting for Too Far Timeout");
#/

	self waittill("chase_too_far_timeout");

/#
	_chase_debug_print("Too Far Timeout");
#/
	
	fail_mission = true;	// default to mission fail, can be changed with callback

	// Too far timeout callback //
	if (IsDefined(self._chase_to_far_timeout_callback))
	{
		fail_mission = self [[ self._chase_to_far_timeout_callback ]]();
	}
	
	if (fail_mission)
	{
		MissionFailed();
	}
}

//
// _chase_route_end - monitor for the "chase_route_end" message from code.
//

_chase_route_end()
{
	self endon("death");
	self waittill("chase_route_done");

	// TODO: What do we do here???

/#
	_chase_debug_print("Chase End");
#/
}

//
// _chase_debug_print - internal function for printing debug information
//

_chase_debug_print(msg)
{
/#
	if (level._chase_debug)
	{
		iPrintlnBold(msg);
	}
#/
}

_chase_wait_for_trigger(triggers)
{
	if (triggers.size > 0)
	{
		ent = spawnstruct();
		array_thread( triggers, maps\_utility_code::wait_for_trigger_think, ent );
		ent waittill( "trigger" );
	}
}

_chase_command_node(node)
{
	self SetGoalNode(node);
	self waittill("goal");
	if (IsDefined(node.timer))
	{
		wait node.timer;
	}
}
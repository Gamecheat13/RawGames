#include maps\_utility;









main()
{
	level._chase_debug = 0;
}





debug(enable)
{
	level._chase_debug = enable;
}





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






pause_chase_route()
{
/#
	_chase_debug_print("Pausing Chase Route");
#/

	self PauseChaseRoute();
	self notify("pausing_chase");
}






resume_chase_route()
{
/#
	_chase_debug_print("Resuming Chase Route");
#/

	self ResumeChaseRoute();
	self notify("resuming_chase");
}









_chase_on_goal()
{
	self endon("death");
	self endon("chase_route_done");

	while (true)
	{
		self waittill("goal", node);
		if (IsDefined(node))
		{		
			
			if (IsDefined(node.script_flag_wait) && (!flag(node.script_flag_wait)))
			{
				self thread _chase_pause(maps\_utility::flag_wait, self, node.script_flag_wait);

	/#
				_chase_debug_print("Waiting For Flag '" + node.script_flag_wait + "'");
	#/
			}
			
			
			if (IsDefined(node.script_wait) || (IsDefined(node.script_wait_min) && IsDefined(node.script_wait_max)))
			{
				self thread _chase_pause(maps\_utility::script_wait, node);

	/#
				_chase_debug_print("Waiting at wait node");
	#/
			}

			
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

			
		}
		else
		{
			
			
			
		}
	}
}





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

		
		if (IsDefined(self._chase_too_close_callback))
		{
			self [[ self._chase_too_close_callback ]]();
		}
		
		

	}
}





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

		
		if (IsDefined(self._chase_to_far_callback))
		{
			self [[ self._chase_too_far_callback ]]();
		}
		
		

	}
}





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
	
	fail_mission = true;	

	
	if (IsDefined(self._chase_to_far_timeout_callback))
	{
		fail_mission = self [[ self._chase_to_far_timeout_callback ]]();
	}
	
	if (fail_mission)
	{
		MissionFailed();
	}
}





_chase_route_end()
{
	self endon("death");
	self waittill("chase_route_done");

	

/#
	_chase_debug_print("Chase End");
#/
}





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
/*
 * _zm_unitgrigger.gsc.
 * User: dlaufer
 * Date: 5/9/2012
 * Time: 11:45 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

init()
{
	level._unitriggers = SpawnStruct();
	level._unitriggers._deferredInitList = []; // calls to register static triggers end up stashed here, if they're made before the zones are set up.
	level._unitriggers.trigger_pool = [];	// indexed by player entity number - 1 trigger per player is the goal here.
	level._unitriggers.trigger_stubs = [];	// all registered stubs.
	level._unitriggers.dynamic_stubs = [];  // stubs that aren't associated with zones.
	level._unitriggers.system_trigger_funcs = [];
	
	stubs_keys = array("unitrigger_radius", "unitrigger_radius_use", "unitrigger_box", "unitrigger_box_use");
	
	stubs = [];
	
	for(i = 0; i < stubs_keys.size; i ++)
	{
		stubs = ArrayCombine(stubs, GetStructArray(stubs_keys[i], "script_unitrigger_type"), true, false);
	}
	
	for(i = 0; i < stubs.size; i ++)
	{
		register_unitrigger(stubs[i]);
	}
}

register_unitrigger_system_func(system, trigger_func)
{
	level._unitriggers.system_trigger_funcs[system] = trigger_func;
}


register_unitrigger_internal(unitrigger_stub, trigger_func)
{
	if(!isdefined(unitrigger_stub.script_uintrigger_type))
	{
		/# println("Cannot register a unitrigger with no script_uintrigger_type.  Ignoring."); #/
		return;
	}
	if(isdefined(trigger_func))
	{
		unitrigger_stub.trigger_func = trigger_func;
	}
	else if(isdefined(unitrigger_stub.unitrigger_system) && isdefined(level._unitriggers.system_trigger_funcs[unitrigger_stub.unitrigger_system]))
	{
		unitrigger_stub.trigger_func = level._unitriggers.system_trigger_funcs[unitrigger_stub.unitrigger_system];
	}
	
	// Make sure defaults are in place for poorly setup stubs.
	
	switch(unitrigger_stub.script_uintrigger_type)
	{
		case "unitrigger_radius":
		case "unitrigger_radius_use":
			if(!isdefined(unitrigger_stub.radius))
			{
				unitrigger_stub.radius = 32;
			}
			
			if(!isdefined(unitrigger_stub.script_height))
			{
				unitrigger_stub.script_height = 64;
			}
			break;
		case "unitrigger_box":
		case "unitrigger_box_use":
			if(!isdefined(unitrigger_stub.script_width))
			{
				unitrigger_stub.script_width = 64;
			}
			
			if(!isdefined(unitrigger_stub.script_height))
			{
				unitrigger_stub.script_height = 64;
			}
			
			if(!isdefined(unitrigger_stub.script_length))
			{
				unitrigger_stub.script_length = 64;
			}
			break;
		default:
			/# println("Unknown unitrigger type registered : " + unitrigger_stub.targetname + " - ignoring."); #/
			return;
		
	}
	
	
	level._unitriggers.trigger_stubs[level._unitriggers.trigger_stubs.size] = unitrigger_stub;
}

register_unitrigger(unitrigger_stub, trigger_func)
{
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;
}

delay_delete_contact_ent()
{
	self.last_used_time = 0;
	
	while(1)
	{
		wait(1);
		
		if((GetTime() - self.last_used_time) > 1000)	// Not used in a second
		{
			self delete();
			level._unitriggers.contact_ent = undefined;
			return;
		}
	}
}

register_static_unitrigger(unitrigger_stub, trigger_func)
{
	if(level.zones.size == 0)
	{
		unitrigger_stub.trigger_func = trigger_func;
		level._unitriggers._deferredInitList[level._unitriggers._deferredInitList.size] = unitrigger_stub;
		return;
	}

	if(!isdefined(level._unitriggers.contact_ent))	// Optimisation to prevent server thread badness while lots of static triggers are being registered at the same time.
	{
		level._unitriggers.contact_ent = spawn("script_origin", (0,0,0));
		level._unitriggers.contact_ent thread delay_delete_contact_ent();	// contact ent will get deleted and set to undefined after 1 second of inactivity.
	}
	
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	
	if(!isdefined(level._no_static_unitriggers))
	{
	
		level._unitriggers.contact_ent.last_used_time = GetTime();
		level._unitriggers.contact_ent.origin = unitrigger_stub.origin;
		
		keys = GetArrayKeys(level.zones);
		
		for(i = 0; i < keys.size; i ++)
		{
			if(level._unitriggers.contact_ent maps\mp\zombies\_zm_zonemgr::entity_in_zone(keys[i], true))
			{
				if(!isdefined(level.zones[keys[i]].unitrigger_stubs))
				{
					level.zones[keys[i]].unitrigger_stubs = [];
				}
				
				level.zones[keys[i]].unitrigger_stubs[level.zones[keys[i]].unitrigger_stubs.size] = unitrigger_stub;
				unitrigger_stub.in_zone = keys[i];
				return;
			}
		}
	}
	
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;	// stub wasn't in a zone - register it as dynamic.
}

debug_unitriggers()
{
	/#
	
	while(1)
	{
		if(GetDvar("debug_unitrigger") != "")
		{
			for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
			{
				triggerStub = level._unitriggers.trigger_stubs[i];
				
				color = ( 0.75, 0, 0 );	// red for inactive.
				
				if(!isdefined(triggerStub.in_zone))
				{
					color = (0.65, 0.65, 0);	// yellow for dynamic stub.
				}
				else
				{
					if(level.zones[ triggerStub.in_zone ].is_active)
					{
						color = (1.0, 1.0, 0);	// Bright yellow for zoned trigger 'in contention'
					}
				}
				
				if(isdefined(triggerStub.trigger))
				{
					color = (0.0, 1.0, 0.0);	// Bright green if the stub has an active trigger.
				}
				
				switch(triggerStub.script_uintrigger_type)
				{
					case "unitrigger_radius":
					case "unitrigger_radius_use":
						circle(triggerStub.origin, triggerStub.radius, color, false, false, 1);
						line(triggerStub.origin, triggerStub.origin + (0, 0, triggerStub.script_height), color, false, 1);
						break;
					case "unitrigger_box":
					case "unitrigger_box_use":
						
						vec = (triggerStub.script_width/2, triggerStub.script_length/2, triggerStub.script_height/2);
						
						box(triggerStub.origin, vec * -1, vec, triggerStub.angles[1], color, 1, false, 1);
						break;
				}
			}
		}
		wait(0.05);
	}
		
	#/
}

main()
{
	level thread debug_unitriggers();
	
	if(level._unitriggers._deferredInitList.size)
	{
		for(i = 0; i < level._unitriggers._deferredInitList.size; i ++)
		{
			register_static_unitrigger(level._unitriggers._deferredInitList[i], level._unitriggers._deferredInitList[i].trigger_func);
		}
		
		for(i = 0; i < level._unitriggers._deferredInitList.size; i ++)
		{
			level._unitriggers._deferredInitList[i] = undefined;
		}
		
		level._unitriggers._deferredInitList = undefined;
	}
	
	valid_range = 128;
	valid_range_sq = valid_range * valid_range;
	
	while(1)
	{
		active_zone_names = maps\mp\zombies\_zm_zonemgr::get_active_zone_names();
		
		candidate_list = [];
		
		for(j = 0; j < active_zone_names.size; j ++)
		{
			if(isdefined(level.zones[active_zone_names[j]].unitrigger_stubs))
			{
				candidate_list = ArrayCombine(candidate_list, level.zones[active_zone_names[j]].unitrigger_stubs, true, false);
			}
		}
		
		candidate_list = ArrayCombine(candidate_list, level._unitriggers.dynamic_stubs, true, false);		
		
		players = GetPlayers();
		
		for(i = 0; i < players.size; i ++)
		{
			player = players[i];
			
			trigger = level._unitriggers.trigger_pool[player GetEntityNumber()];
			
			if(isdefined(trigger))
			{
				dst = valid_range_sq;
			/*	if(isdefined(trigger.radius))
				{
					dst = trigger.radius * trigger.radius;
				} */
				
				if(DistanceSquared(player.origin, trigger.origin) < dst)	// Currently enabled trigger is still the most healthy, leave it alone.
				{
					continue;
				}
				else	// We've moved away from this trigger - throw it out.
				{
					trigger notify("kill_trigger");
					trigger.stub.trigger = undefined;
					trigger delete();
					level._unitriggers.trigger_pool[player GetEntityNumber()] = undefined;
				}
			}
			
			index = get_closest_index( player.origin, candidate_list, valid_range);
			
			if(isdefined(index))
			{
				if(!isdefined(candidate_list[index].trigger))
				{
					level._unitriggers.trigger_pool[player GetEntityNumber()] = build_trigger_from_unitrigger_stub(candidate_list[index]);
					level._unitriggers.trigger_pool[player GetEntityNumber()] thread trigger_thread(candidate_list[index].trigger_func);
				}
			}
		}
		
		wait(0.05);
	}
}

build_trigger_from_unitrigger_stub(stub)
{
	radius = stub.radius;
	
	if(!isdefined(radius))
	{
		radius = 64;
	}
	
	script_height = stub.script_height;
	if(!isdefined(script_height))
	{
		script_height = 64;
	}
	
	script_width = stub.script_width;
	if(!isdefined(script_width))
	{
		script_width = 64;
	}


	script_length = stub.script_length;
	if(!isdefined(script_length))
	{
		script_length = 64;
	}

	trigger = undefined;
	
	switch(stub.script_uintrigger_type)
	{
		case "unitrigger_radius": 
			trigger = Spawn( "trigger_radius", stub.origin, 0, radius, script_height);
			break;
		case "unitrigger_radius_use": 
			trigger = Spawn( "trigger_radius_use", stub.origin, 0, radius, script_height);
			break;
		case "unitrigger_box":
			trigger = Spawn( "trigger_box", stub.origin, 0, script_width,  script_length, script_height);
			break;
		case "unitrigger_box_use":
			trigger = Spawn( "trigger_box_use", stub.origin, 0, script_width,  script_length, script_height);
			break;
	}
	
	if(isdefined(trigger))
	{
		if(isdefined(stub.cursor_hint))
		{
			if(isdefined(stub.cost))
			{
				trigger SetCursorHint(stub.cursor_hint, stub.cost);
			}
			else
			{
				trigger SetCursorHint(stub.cursor_hint);
			}
		}
		trigger TriggerIgnoreTeam();
		
		if(is_true(stub.require_look_at))
		{
			trigger UseTriggerRequireLookAt();
		}
		
		if(isdefined(stub.hint_string))
		{
			if(isdefined(stub.cost))
			{
				trigger SetHintString(stub.hint_string, stub.cost);
			}
			else
			{
				trigger SetHintString(stub.hint_string);
			}
		}
		
		trigger.stub = stub;
	}
	
	copy_zombie_keys_onto_trigger(trigger, stub);
	
	stub.trigger = trigger; 
	return trigger;
}

copy_zombie_keys_onto_trigger(trig, stub)
{
	// Generic
	trig.script_noteworthy = stub.script_noteworthy;
	trig.targetname = stub.targetname;
	trig.target = stub.target;
	
	
	// Wallbuys
	trig.zombie_weapon_upgrade = stub.zombie_weapon_upgrade;
	trig.clientFieldName = stub.clientFieldName;
	
}

trigger_thread(trigger_func)		// Wrapper to add kill_trigger endon to all managed trigger threads.
{
	self endon("kill_trigger");
	
	if(isdefined(trigger_func))
	{
		self [[trigger_func]]();
	}
}
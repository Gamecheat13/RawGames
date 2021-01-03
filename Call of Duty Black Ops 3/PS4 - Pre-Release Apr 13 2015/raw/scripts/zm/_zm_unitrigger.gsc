#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

/*
 * _zm_unitgrigger.gsc.
 * User: dlaufer
 * Date: 5/9/2012
 * Time: 11:45 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */




	
#namespace zm_unitrigger;

function autoexec __init__sytem__() {     system::register("zm_unitrigger",&__init__,undefined,undefined);    }	

function __init__()
{
	level._unitriggers = SpawnStruct();
	level._unitriggers._deferredInitList = []; // calls to register static triggers end up stashed here, if they're made before the zones are set up.
	level._unitriggers.trigger_pool = [];	// indexed by player entity number - 1 trigger per player is the goal here.
	level._unitriggers.trigger_stubs = [];	// all registered stubs.
	level._unitriggers.dynamic_stubs = [];  // stubs that aren't associated with zones.
	level._unitriggers.system_trigger_funcs = [];
	level._unitriggers.largest_radius = 64; // radius of the largest unitrigger in the level
	
	stubs_keys = array("unitrigger_radius", "unitrigger_radius_use", "unitrigger_box", "unitrigger_box_use");
	
	stubs = [];
	
	for(i = 0; i < stubs_keys.size; i ++)
	{
		stubs = ArrayCombine(stubs, struct::get_array(stubs_keys[i], "script_unitrigger_type"), true, false);
	}
	
	for(i = 0; i < stubs.size; i ++)
	{
		register_unitrigger(stubs[i]);
	}
}

function register_unitrigger_system_func(system, trigger_func)
{
	level._unitriggers.system_trigger_funcs[system] = trigger_func;
}

function unitrigger_force_per_player_triggers(unitrigger_stub, opt_on_off)
{
	if (!isdefined(opt_on_off))
		opt_on_off = 1;
	unitrigger_stub.trigger_per_player = opt_on_off;
}

function unitrigger_trigger( player )
{
	if(self.trigger_per_player)
	{
		return self.playertrigger[player GetEntityNumber()];
	}
	else
	{
		return self.trigger;
	}
}

function unitrigger_origin()
{
	if (isdefined(self.originFunc))
		origin = self [[self.originFunc]]();
	else
		origin = self.origin;
	return origin;
}

function register_unitrigger_internal(unitrigger_stub, trigger_func)
{
	if(!isdefined(unitrigger_stub.script_unitrigger_type))
	{
		/# println("Cannot register a unitrigger with no script_unitrigger_type.  Ignoring."); #/
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
	
	switch(unitrigger_stub.script_unitrigger_type)
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
			unitrigger_stub.test_radius_sq = ( unitrigger_stub.radius + 15.0 ) * ( unitrigger_stub.radius + 15.0 );
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
			box_radius = Length( (unitrigger_stub.script_width/2,unitrigger_stub.script_length/2,unitrigger_stub.script_height/2) );
			if(!isdefined(unitrigger_stub.radius) || unitrigger_stub.radius<box_radius)
			{
				unitrigger_stub.radius = box_radius;
			}
			unitrigger_stub.test_radius_sq = ( box_radius + 15.0 ) * ( box_radius + 15.0 );
			break;
		default:
			/# println("Unknown unitrigger type registered : " + unitrigger_stub.targetname + " - ignoring."); #/
			return;
		
	}
	
	if ( unitrigger_stub.radius > level._unitriggers.largest_radius )
	{
		level._unitriggers.largest_radius = min((128 - 15.0), unitrigger_stub.radius );
		if ( IsDefined(level.fixed_max_player_use_radius) )
		{
			if ( level.fixed_max_player_use_radius >  GetDVarFloat( "player_useRadius_zm" ) )
    			SetDvar( "player_useRadius_zm", level.fixed_max_player_use_radius );
		}
		else if ( level._unitriggers.largest_radius >  GetDVarFloat( "player_useRadius_zm" ) )
		{
    		SetDvar( "player_useRadius_zm", level._unitriggers.largest_radius );
		}
	}
	
	level._unitriggers.trigger_stubs[level._unitriggers.trigger_stubs.size] = unitrigger_stub;
	unitrigger_stub.registered = 1;
}

function register_unitrigger(unitrigger_stub, trigger_func)
{
	register_unitrigger_internal(unitrigger_stub, trigger_func);
	
	level._unitriggers.dynamic_stubs[level._unitriggers.dynamic_stubs.size] = unitrigger_stub;
}

function unregister_unitrigger(unitrigger_stub)
{
	// thread this off to avoid leaving orphaned triggers 
	thread unregister_unitrigger_internal(unitrigger_stub);
}

function unregister_unitrigger_internal(unitrigger_stub)
{
	if (!isdefined( unitrigger_stub ))
		return;
	unitrigger_stub.registered = 0;
	if(( isdefined( unitrigger_stub.trigger_per_player ) && unitrigger_stub.trigger_per_player ))
	{
		if(isdefined(unitrigger_stub.playertrigger) && (unitrigger_stub.playertrigger.size > 0))
		{
			keys = GetArrayKeys(unitrigger_stub.playertrigger);
			foreach( key in keys )
			{
				trigger = unitrigger_stub.playertrigger[key];
				trigger notify("kill_trigger");
				if (isdefined(trigger))
					trigger delete();
			}
			unitrigger_stub.playertrigger = [];
		}
	}
	else
	{
		if ( isdefined(unitrigger_stub.trigger) )
		{
			trigger = unitrigger_stub.trigger;
			trigger notify("kill_trigger");
			trigger.stub.trigger = undefined;
			trigger delete();
		}
	}
	if (isdefined( unitrigger_stub.in_zone ))
	{
		ArrayRemoveValue( level.zones[unitrigger_stub.in_zone].unitrigger_stubs, unitrigger_stub );
		unitrigger_stub.in_zone = undefined;
	}

	ArrayRemoveValue( level._unitriggers.trigger_stubs, unitrigger_stub );
	ArrayRemoveValue( level._unitriggers.dynamic_stubs, unitrigger_stub );
}

function delay_delete_contact_ent()
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

function register_static_unitrigger(unitrigger_stub, trigger_func, recalculate_zone)
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
		
		if(isdefined(unitrigger_stub.in_zone) && !isdefined(recalculate_zone))
		{
			level.zones[unitrigger_stub.in_zone].unitrigger_stubs[level.zones[unitrigger_stub.in_zone].unitrigger_stubs.size] = unitrigger_stub;
			return;
		}
		
		keys = GetArrayKeys(level.zones);
		
		for(i = 0; i < keys.size; i ++)
		{
			if(level._unitriggers.contact_ent zm_zonemgr::entity_in_zone(keys[i], true))
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
	unitrigger_stub.registered = 1;
}

function reregister_unitrigger_as_dynamic(unitrigger_stub)
{
	unregister_unitrigger_internal(unitrigger_stub);
	register_unitrigger(unitrigger_stub, unitrigger_stub.trigger_func );
}


function debug_unitriggers()
{
	/#
	
	while(1)
	{
		if(GetDvarInt("debug_unitrigger") > 0)
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
				
				if(isdefined(triggerStub.trigger) || ((IsDefined(triggerStub.playertrigger) && (triggerStub.playerTrigger.size > 0))))
				{
					color = (0.0, 1.0, 0.0);	// Bright green if the stub has an active trigger.
					if((IsDefined(triggerStub.playertrigger) && (triggerStub.playerTrigger.size > 0)))
					{
					      	print3d(triggerStub.origin, triggerStub.playerTrigger.size, color, 1, 1, 1);
					}
			   }
			 
				origin = triggerStub unitrigger_origin();
				switch(triggerStub.script_unitrigger_type)
				{
					case "unitrigger_radius":
					case "unitrigger_radius_use":
						if (triggerStub.radius)
							circle(origin, triggerStub.radius, color, false, false, 1);
						if (triggerStub.script_height)
							line(origin, origin + (0, 0, triggerStub.script_height), color, false, 1);
						break;
					case "unitrigger_box":
					case "unitrigger_box_use":
						
						vec = (triggerStub.script_width/2, triggerStub.script_length/2, triggerStub.script_height/2);
						
						box(origin, vec * -1, vec, triggerStub.angles[1], color, 1, false, 1);
						/*
						x = AnglesToForward( triggerStub.angles );
						y = AnglesToRight( triggerStub.angles );
						z = AnglesToUp( triggerStub.angles );
						line(origin, origin + 6 * x, (1,0,0), false, 1);
						line(origin, origin + 6 * y, (0,1,0), false, 1);
						line(origin, origin + 6 * z, (0,0,1), false, 1);
						*/
						
						break;
				}
			}
		}
		{wait(.05);};
	}
		
	#/
}

function cleanup_trigger(trigger,player)
{
	trigger notify("kill_trigger");
	if(( isdefined( trigger.stub.trigger_per_player ) && trigger.stub.trigger_per_player ))
	{
		trigger.stub.playerTrigger[player GetEntityNumber()] = undefined;
	}
	else
	{
		trigger.stub.trigger = undefined;
	}
	
	trigger delete();
	level._unitriggers.trigger_pool[player GetEntityNumber()] = undefined;
}

function assess_and_apply_visibility( trigger, stub, player, default_keep )
{
	if (!isdefined(trigger) || !isdefined(stub))
		return false;
	keep_thread = default_keep;
	if (!isdefined(stub.prompt_and_visibility_func) || 
		trigger [[stub.prompt_and_visibility_func]]( player ) )
	{
		keep_thread = true;
		if (!( isdefined( trigger.thread_running ) && trigger.thread_running ))
			trigger thread trigger_thread(trigger.stub.trigger_func);
		trigger.thread_running = true;
		if (IsDefined(trigger.reassess_time) && trigger.reassess_time <= 0.0)
			trigger.reassess_time = undefined;
	}
	else
	{
		if (( isdefined( trigger.thread_running ) && trigger.thread_running ))
			keep_thread = false;
		trigger.thread_running = false;
		// check again in 1 second
		if ( IsDefined(stub.inactive_reasses_time) )
			trigger.reassess_time = stub.inactive_reasses_time;
		else
			trigger.reassess_time = 1.0;
	}
	return keep_thread;
}

function main()
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
	
	valid_range = level._unitriggers.largest_radius + 15.0;
	valid_range_sq = valid_range * valid_range;

	while( !isdefined( level.active_zone_names ) )
	{
		wait( 0.1 );
	}
	
	while(1)
	{
		waited = false;
		active_zone_names = level.active_zone_names;//zm_zonemgr::get_active_zone_names();
		
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
			
			if(!isdefined(player))
			{
				continue;
			}
			
			player_origin = player.origin + (0,0,70.0/2);
			
			trigger = level._unitriggers.trigger_pool[player GetEntityNumber()];

			old_trigger = undefined;
			closest = [];
			
			if(isdefined(trigger))
			{
				dst = valid_range_sq;
				origin = trigger unitrigger_origin();

				dst = trigger.stub.test_radius_sq;
				time_to_ressess = false; 
				trigger_still_valid = false;

				if( Distance2DSquared(player_origin, origin) < dst)	// Currently enabled trigger is still the most healthy, leave it alone.
				{
					if (isdefined(trigger.reassess_time))
					{
						trigger.reassess_time -= 0.05;
						if (trigger.reassess_time > 0.0)
							continue;
						time_to_ressess = true; 
					}
					else if (player zm_utility::is_player_looking_at(trigger.stub.origin, 0.9, false)) //Do not reassess if player is looking at the trigger
					{
						continue;
					}
					trigger_still_valid = true;
				}
				
				// Gets all the unitriggers in range (roughly)			
				closest = get_closest_unitriggers( player_origin, candidate_list, valid_range );
								
				// no need to reasses if there is only one nearby trigger - we do need to reassess the prompt and visibility though
				if ( IsDefined(trigger) && time_to_ressess &&  (closest.size < 2 ||  ( isdefined( trigger.thread_running ) && trigger.thread_running ) ) )
				{
					if (assess_and_apply_visibility( trigger, trigger.stub, player, true ))
						continue; 
				}
				
				if (trigger_still_valid && closest.size < 2)
				{
					if (assess_and_apply_visibility( trigger, trigger.stub, player, true ))
						continue; 
				}
				
				/*
				// We've moved away from this trigger or it's time to reassess - throw it out.
				if (IsDefined(trigger))
					cleanup_trigger(trigger,player);
				 */
				
				//Old trigger is still valid. Do not release the old trigger untill we are sure we don't need it.
				if (trigger_still_valid)
				{
					old_trigger = trigger;
					trigger = undefined;
					level._unitriggers.trigger_pool[player GetEntityNumber()] = undefined;
				}
				else if (IsDefined(trigger))
					cleanup_trigger(trigger,player);
			}
			else
			{
				// Gets all the unitriggers in range (roughly)			
				closest = get_closest_unitriggers( player_origin, candidate_list, valid_range );
			}
			
			index = 0; 

			first_usable=undefined;
			first_visible=undefined;
			trigger_found = false;

			// One thing I don't like about this is that if you have two unitriggers in range and they are both unusable, but visible, it will tend to show the far one
			while (index < closest.size)
			{
				if( !zm_utility::is_player_valid( player ) && !(( isdefined( closest[index].ignore_player_valid ) && closest[index].ignore_player_valid )) )
				{
					index++;
					continue;
				}
				
				if(!( isdefined( closest[index].registered ) && closest[index].registered ))
				{
					index++;
					continue;
				}
				
				trigger = check_and_build_trigger_from_unitrigger_stub(closest[index], player);
				
				if (isdefined(trigger))
				{

					trigger.parent_player = player;

					if ( assess_and_apply_visibility( trigger, closest[index], player, false ) )
					{
						//If player is looking at the trigger and it's usable, it takes the highest priority
						if (player zm_utility::is_player_looking_at(closest[index].origin, 0.9, false))
						{
							if (!is_same_trigger(old_trigger, trigger) && isdefined(old_trigger))
							{
								cleanup_trigger(old_trigger, player);
							}
							level._unitriggers.trigger_pool[player GetEntityNumber()] = trigger;
							trigger_found = true;
							break;
						}
						
						//save the closest usable trigger
						if (!isdefined(first_usable))
						{
							first_usable = index;
						}
					}
					//save the closest visible trigger
					if (!isdefined(first_visible))
					{
						first_visible = index;
					}
					
					
					if (isdefined(trigger))
					{
						if (is_same_trigger(old_trigger, trigger))
							level._unitriggers.trigger_pool[player GetEntityNumber()] = undefined;
						else cleanup_trigger(trigger,player);
					}
					last_trigger = trigger;
				}
				index++;
				
				waited = true;
				{wait(.05);};
			}
			
			if (trigger_found)
				continue;
			//Player wasn't looking at any of the triggers
			//First usable trigger has higher priority then the first visible trigger
			if (isdefined(first_usable))
				index = first_usable;
			else if (isdefined(first_visible))
				index = first_visible;
			
			trigger = check_and_build_trigger_from_unitrigger_stub(closest[index], player);
			if (isdefined(trigger))
			{
				trigger.parent_player = player;
				level._unitriggers.trigger_pool[player GetEntityNumber()] = trigger;
				if (is_same_trigger(old_trigger, trigger))
					continue;
				
				if (isdefined(old_trigger))
				{
					cleanup_trigger(old_trigger, player);
				}
				
				//Rebuild the trigger and make it running
				assess_and_apply_visibility( trigger, trigger.stub, player, false );		
			}
		}
		if (!waited)
		{
			{wait(.05);};
		}
	}
}

function run_visibility_function_for_all_triggers()
{
	if(!isdefined(self.prompt_and_visibility_func))
	{
		return;
	}
	
	if(( isdefined( self.trigger_per_player ) && self.trigger_per_player ))
	{
		if(!isdefined(self.playertrigger))
		{
			return;
		}
		
		players = GetPlayers();
		
		for(i = 0; i < players.size; i ++)
		{
			if(isdefined(self.playertrigger[players[i] GetEntityNumber()]))
			{
				self.playertrigger[players[i] GetEntityNumber()] [[self.prompt_and_visibility_func]](players[i]);
			}
		}
	}
	else
	{
		if(isdefined(self.trigger))
		{
			self.trigger [[self.prompt_and_visibility_func]](GetPlayers()[0]);
		}
	}
}

function is_same_trigger(old_trigger, trigger)
{
	return isdefined(old_trigger) && old_trigger == trigger && trigger.parent_player == old_trigger.parent_player;
}

function check_and_build_trigger_from_unitrigger_stub(stub,player)
{
	if (!isdefined(stub))
		return undefined;
		
	if(( isdefined( stub.trigger_per_player ) && stub.trigger_per_player ))
	{
		if (!isdefined(stub.playertrigger))
		    stub.playertrigger = [];
		if(!isdefined(stub.playertrigger[player GetEntityNumber()]))
		{
			trigger = build_trigger_from_unitrigger_stub(stub,player);
			level._unitriggers.trigger_pool[player GetEntityNumber()] = trigger;
		} 
		else 
			trigger = stub.playertrigger[player GetEntityNumber()];
	}
	else
	{
		if(!isdefined(stub.trigger))
		{
			trigger = build_trigger_from_unitrigger_stub(stub,player);
			level._unitriggers.trigger_pool[player GetEntityNumber()] = trigger;
		} else trigger = stub.trigger;
	}
	return trigger;
}

function build_trigger_from_unitrigger_stub(stub,player)
{
	if( isdefined( level._zm_build_trigger_from_unitrigger_stub_override ) )
	{
		if( stub [[ level._zm_build_trigger_from_unitrigger_stub_override ]]( player ) )
		{
			return;
		}
	}
	
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
	
	origin = stub unitrigger_origin();

	switch(stub.script_unitrigger_type)
	{
		case "unitrigger_radius": 
			trigger = Spawn( "trigger_radius", origin, 0, radius, script_height);
			break;
		case "unitrigger_radius_use": 
			trigger = Spawn( "trigger_radius_use", origin, 0, radius, script_height);
			break;
		case "unitrigger_box":
			trigger = Spawn( "trigger_box", origin, 0, script_width,  script_length, script_height);
			break;
		case "unitrigger_box_use":
			trigger = Spawn( "trigger_box_use", origin, 0, script_width,  script_length, script_height);
			break;
	}
	
	if(isdefined(trigger))
	{
		if(isdefined(stub.angles))
		{
			trigger.angles = stub.angles;
		}
		
		if (isdefined(stub.onSpawnFunc))
			stub [[stub.onSpawnFunc]](trigger);

		if(isdefined(stub.cursor_hint))
		{
			if ( stub.cursor_hint == "HINT_WEAPON" && IsDefined(stub.cursor_hint_weapon) )
				trigger SetCursorHint(stub.cursor_hint,stub.cursor_hint_weapon);	
			else
				trigger SetCursorHint(stub.cursor_hint);	
		}
		trigger TriggerIgnoreTeam();
		
		if(( isdefined( stub.require_look_at ) && stub.require_look_at ))
		{
			trigger UseTriggerRequireLookAt();
		}
		
		if(isdefined(stub.hint_string))
		{
			if(isdefined(stub.hint_parm2))
			{
				trigger SetHintString(stub.hint_string, stub.hint_parm1, stub.hint_parm2);
			}
			else if(isdefined(stub.hint_parm1))
			{
				trigger SetHintString(stub.hint_string, stub.hint_parm1);
			}
			else if(isdefined(stub.cost)) // T7TODO - DEPRECATED 
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
	
	if(( isdefined( stub.trigger_per_player ) && stub.trigger_per_player ))
	{
		if(isdefined(trigger))
		{
			trigger setInvisibleToAll();
			trigger setVisibleToPlayer( player );
		}
		if (!isdefined(stub.playertrigger))
		    stub.playertrigger = [];
		stub.playertrigger[player GetEntityNumber()] = trigger; 
	}
	else
		stub.trigger = trigger; 
	trigger.thread_running = false;
	return trigger;
}

function copy_zombie_keys_onto_trigger(trig, stub)
{
	// Generic
	trig.script_noteworthy = stub.script_noteworthy;
	trig.targetname = stub.targetname;
	trig.target = stub.target;
	
	
	// Wallbuys
	trig.weapon = stub.weapon;
	trig.clientFieldName = stub.clientFieldName;
	
	// buildables
	trig.useTime = stub.useTime;

}

function trigger_thread(trigger_func)		// Wrapper to add kill_trigger endon to all managed trigger threads.
{
	self endon("kill_trigger");
	
	if(isdefined(trigger_func))
	{
		self [[trigger_func]]();
	}
}

function get_closest_unitriggers( org, array, dist = 9999999 )
{
	triggers = [];
	if( array.size < 1 )
	{
		return triggers;
	}
	distsq = dist*dist;
	for( i = 0; i < array.size; i++ )
	{
		if (!isdefined(array[i]))
			continue;
		origin = array[ i ] unitrigger_origin();
		radius_sq = array[ i ].test_radius_sq;

		newdistsq = Distance2DSquared( origin, org );
		if( newdistsq >= radius_sq ) 
		{
			continue;
		}
		if ( abs(origin[2]-org[2]) > 42 )
			continue;
		array[i].dsquared = newdistsq; 
		j=0;
		while(j<triggers.size && newdistsq > triggers[j].dsquared)
			j++;
 		ArrayInsert(triggers,array[i],j);
	}
	
	return triggers;
}





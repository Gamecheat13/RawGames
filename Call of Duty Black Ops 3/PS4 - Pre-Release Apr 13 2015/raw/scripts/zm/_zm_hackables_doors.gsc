#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_hacker_utility;

#namespace zm_hackables_doors;

function hack_doors(targetname, door_activate_func)
{
	if(!isdefined(targetname))
	{
		targetname = "zombie_door";
	}
	
	doors = GetEntArray( targetname, "targetname" ); 
	
	if(!isdefined(door_activate_func))
	{
		door_activate_func = &zm_blockers::door_opened;
	}
	
	for(i = 0; i < doors.size; i ++)
	{
		door = doors[i];
		
		struct = SpawnStruct();
		struct.origin = door.origin + (AnglesToForward(door.angles) * 2);
		struct.radius = 48;
		struct.height = 72;
		struct.script_float = 32.7;
		struct.script_int = 200;
		struct.door = door;
		struct.no_bullet_trace = true;
		struct.door_activate_func = door_activate_func;
		///#struct thread door_struct_debug();#/
		
		trace_passed = false;
		
/*		num_its = 0;
		
		while(!trace_passed)
		{
			if(bullettracepassed(struct.origin + (AnglesToForward(door.angles) * (num_its + 1)), struct.origin, false, undefined))
			{
				break;
			}
			num_its ++;
		}
		
		struct.origin += (AnglesToForward(door.angles) * num_its); */
		
		door thread hide_door_buy_when_hacker_active(struct);
		
		hacker_util::register_pooled_hackable_struct(struct,&door_hack );		
		door thread watch_door_for_open(struct);
	}
}

function hide_door_buy_when_hacker_active(door_struct)
{
	self endon("death");
	self endon("door_hacked");
	self endon("door_opened");
	
	hacker_util::hide_hint_when_hackers_active();
}

function watch_door_for_open(door_struct)
{
	self waittill("door_opened");
	self endon("door_hacked");

	remove_all_door_hackables_that_target_door(door_struct.door);
}

function door_hack(hacker)
{
	self.door notify("door_hacked");
	self.door notify("kill_door_think");

	remove_all_door_hackables_that_target_door(self.door);

	self.door [[self.door_activate_func]]();
	self.door._door_open = true;
}

function remove_all_door_hackables_that_target_door(door)
{
	candidates = [];
	
	for(i = 0; i < level._hackable_objects.size; i ++)
	{
		obj = level._hackable_objects[i];
		
		if(isdefined(obj.door) && obj.door.target == door.target)
		{
			candidates[candidates.size] = obj;
		}
	}
	
	for(i = 0; i < candidates.size; i ++)
	{
		hacker_util::deregister_hackable_struct(candidates[i]);
	}
}

/#
function door_struct_debug()
{
	while(1)
	{
		wait(0.1);
		
		origin = self.origin;
		
		point = origin;
		
		for(i = 1; i < 5; i ++)
		{
			point = origin + (AnglesToForward(self.door.angles) * (i * 2));
			
			passed = bullettracepassed(point, origin, false, undefined);
			
			color = (0,255,0);
			
			if(!passed)
			{
				color = (255,0,0);
			}
			
			Print3d(point, "+", color, 1, 1);
		}
	}
}
#/

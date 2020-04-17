// _doors.gsc
// Handles AI and player interaction with doors

#include maps\_utility;
#include common_scripts\utility;
#using_animtree ("generic_human");

main()
{
	level.doors = [];
	array_thread(GetEntArray("door", "script_noteworthy"), maps\_doors::door_init);

	if(level.doors.size == 0)   // no doors in this level
		return;

	level._doors_nodes = [];

	//precachemodel("com_door_test");
	//precachemodel("bashed_door_test");

	for (i = 0; i < level.doors.size; i++)
	{
		if(!isDefined(level.doors[i].target) && (level.doors[i]._doors_oldnodes.size == 0) )
			//assertMsg("Door without a door node.");
			continue;

		// get all nodes targeted by this door,
		// then initialize them

		level.doors[i]._doors_nodes = [];

		if(isDefined(level.doors[i].target))
		{
			curNodes = GetNodeArray(level.doors[i].target, "targetname");
			for (j = 0; j < curNodes.size; j++)
			{
				level.doors[i]._doors_nodes[level.doors[i]._doors_nodes.size] = curNodes[j];
			}
		}

		if(isDefined(level.doors[i]._doors_oldnodes))
		{
			level.doors[i]._doors_nodes = array_merge(level.doors[i]._doors_nodes, level.doors[i]._doors_oldnodes);
			level.doors[i]._doors_oldnodes = [];
		}

		//level.doors[i]._doors_nodes = GetNodeArray(level.doors[i].target, "targetname");
		for (j = 0; j < level.doors[i]._doors_nodes.size; j++)
		{
			node = level.doors[i]._doors_nodes[j];
			level._doors_nodes[level._doors_nodes.size] = node;	// collect all door nodes in level array

			if(!isDefined(node.spawnflags))
				continue;

			if(!isDefined(node.doorRef))
				node.doorRef = [];                 

			if((node.spawnflags & 2048) || isDefined(node.script_door))     // are you REALLY a door node fool
			{
				node.doorRef[node.doorRef.size] = level.doors[i];     //  use this member to reference a node's parent door	    
				node thread door_node();
			}    
			else continue;                
		}			
	}
}

//
// door_init (called from _load.gsc on startup for each door)
//
door_init()
{
	if(!isDefined(self.script_door) && !isDefined(self.script_door_id))
		return;

	i = level.doors.size;

	self.old_style_door = false;

	assert(!isDefined(level.doors[i]));

	level.doors[i] = self;

	level.doors[i]._doors_id = i;

	level.doors[i]._keep_open = 0;

	level.doors[i]._disabled = false;

	level.doors[i]._doors_nodes = [];
	level.doors[i]._doors_oldnodes = [];
	level.doors[i]._doors_open = false;
	door_update_node_open_flag( level.doors[i] );    
	level.doors[i]._doors_origin_closed = self.origin;
	level.doors[i]._doors_angles_closed = self.angles;
	level.doors[i]._doors_max_angle = self.script_door_maxangle;
	level.doors[i]._doors_min_angle = self.script_door_minangle;
	level.doors[i]._doors_lock_name = self.script_door_lockname;
	level.doors[i]._doors_damage_triggers = [];
	level.doors[i]._doors_player_opening = false;
	level.doors[i]._doors_being_pulled = false;   

	//level.doors[i]._doors_lock_subtype = self.script_door_locksubtype;
	level.doors[i]._doors_lock_lockparams = self.script_door_lockparams;

	level.doors[i]._doors_no_ai = false;
	level.doors[i]._doors_no_player = false;				
	level.doors[i]._doors_no_collision = false;
	level.doors[i]._doors_auto_open = false;
	level.doors[i]._doors_auto_close = true;
	level.doors[i]._doors_auto_lock = false;
	level.doors[i]._doors_locked = false;
	level.doors[i]._doors_bashable = false;
	level.doors[i]._doors_barred = false;

	if(!isDefined(level._doors_actions))
		setup_actions();		

	if (!IsDefined(self.script_door_movement_type))
		level.doors[i].type = "rotating";
	else
		level.doors[i].type = self.script_door_movement_type;

	if (!IsDefined(self.script_door_movement_time))
		level.doors[i]._doors_movement_time = 1.0;
	else
		level.doors[i]._doors_movement_time = self.script_door_movement_time;

	if (IsDefined(self.radius))
		level.doors[i]._doors_radius = self.radius;
	else
		level.doors[i]._doors_radius = 100; // default radius

	if (IsDefined(self.script_door_slide_dist))
		level.doors[i]._doors_slide_dist = self.script_door_slide_dist;
	else
		level.doors[i]._doors_slide_dist = 40;

	//	if (IsDefined(self.script_door_bashed_model))
	//	{
	//	    level.doors[i]._doors_bashed_model = self.script_door_bashed_model;
	//	    precachemodel(self.script_door_bashed_model);   
	//	}    
	//	else
	level.doors[i]._doors_bashed_model = "bashed_door_test";	

	if (IsDefined(self.script_door_bash_audio))
		level.doors[i]._doors_bash_audio = self.script_door_bash_audio;    
	else
		level.doors[i]._doors_bash_audio = "smash_door_bashable";		

	if (IsDefined(self.spawnflags))
	{
		flags = self.spawnflags;

		if (flags & 1)
		{
			level.doors[i]._doors_no_collision = true;
		}

		if (flags & 2)
		{
			level.doors[i]._doors_auto_close = false;
		}

		if (flags & 4)
		{
			level.doors[i]._doors_auto_lock = true;
		}

		if (flags & 8)
		{
			level.doors[i]._doors_bashable = true;
			doorsetbashable( self, 1 );
		}

		if (flags & 16)
		{
			level.doors[i]._doors_barred = true;
		}

		if (flags & 32)
		{
			level.doors[i]._doors_locked = true;
		}

		// these two correspond to cw_only and ccw_only, but there are no actual members for these - just zero out the appropriate max/min angle
		if (flags & 64) // cw_only
		{
			level.doors[i]._doors_max_angle = 0;
		}

		if (flags & 128) // ccw_only
		{
			level.doors[i]._doors_min_angle = 0;
		}

		level.doors[i]._doors_auto_open = (flags & 512);
		if (level.doors[i]._doors_auto_open)
		{
			level.doors[i] thread auto_open();
		}
	}

	if(isDefined(level.doors[i]._doors_lock_name))
	{
		level.doors[i].lock_ent = level.doors[i];
		if (IsDefined(self.targetname) && (self.targetname != ""))
		{
			lock_ent = GetEntArray(self.targetname, "target");
			if (IsDefined(lock_ent) && lock_ent.size > 0 )
			{
				level.doors[i].lock_ent = lock_ent[0];
			}
		}

		level.doors[i].lock_ent.lockparams = self._doors_lock_lockparams;
		level.doors[i].lock_ent.lockname = level.doors[i]._doors_lock_name;  // the unlock script expects a lockname string

		if (IsDefined(level.doors[i].lock_ent.lockname) && (level.doors[i].lock_ent.lockname != "none"))
		{
			if (level.doors[i] is_door_locked())
			{
				level.doors[i].lock_ent maps\_unlock_mechanisms::InitLockFromString();
			}
			else
			{
				level.doors[i].lock_ent maps\_unlock_mechanisms::InitLockFromString(false);
			}
		}

		if (level.doors[i].lock_ent != level.doors[i])
		{
			level.doors[i] thread keypad_unlock();
		}
	}            
	else
	{
		level.doors[i].lockname = "none";
		level.doors[i]._doors_locked = false;
	}

	if (level.doors[i] get_door_lock_type() == "mechanical")    // mechanical lock was cut
	{
		self._disabled = true;
		level.doors[i] setmodel("mechanical_lock_test");
		return;
	}    

	if (IsDefined(level.doors[i].targetname))
	{
		dmgTriggers = getentarray( "trigger_damage", "classname" );

		for (j = 0; j < dmgTriggers.size; j++)
		{
			if (!isDefined(dmgTriggers[j].target))
			{
				continue;
			}

			curSize = level.doors[i]._doors_damage_triggers.size;

			if(dmgTriggers[j].target == level.doors[i].targetname)
			{
				level.doors[i]._doors_damage_triggers[curSize] = dmgTriggers[j];
			}
		}
	}    

	//****************************************************
	// Set the Blocked PNF_DOOR_BLOCKED state on all doors
	//****************************************************

	door_update_node_states();

	//********************************************************
	// Record the door nodes initial blocked and closed states
	//********************************************************

	if (isDefined(level.doors[i].target))
	{
		curNodes = GetNodeArray(level.doors[i].target, "targetname");
		for( lp=0; lp<curNodes.size; lp++ )
		{
			node = curNodes[lp];
			noderecorddoorstate(node);
		}
	}
}

//
// setup_actions - setup the animations for each type of door action
//
setup_actions()
{
	level._doors_actions = [];

	// anims are selected randomly from the appropriate array, so
	// make sure that all anims in each array are completely interchangeable.
	// if they aren't, make a separate _door_actions array for them.

	level._doors_actions["door_knob_interact"] = [];
	///level._doors_actions["door_knob_interact"][0] = "door_open_push_knob";
	level._doors_actions["door_knob_interact"][0] = undefined;  // temporarily disabled until anim is fixed

	level._doors_actions["door_slide_interact"] = [];
	level._doors_actions["door_slide_interact"][0] = undefined;

	level._doors_actions["door_slide_vertical_interact"] = [];
	level._doors_actions["door_slide_vertical_interact"][0] = undefined;

	level._doors_actions["door_rotating_push"] = [];
	level._doors_actions["door_rotating_push"][0] = undefined;
	//level._doors_actions["door_push"][1] = %another_door_anim;
	// add more push animations //

	level._doors_actions["door_rotating_pull"] = [];
	level._doors_actions["door_rotating_pull"][0] = undefined;
	//level._doors_actions["door_pull"][1] = %another_door_anim;
	// add more pull animations //

	// the door bashing is handled separately as a special case of melee
	//level._doors_actions["door_bash"] = [];
	//level._doors_actions["door_bash"][0] = "door_open_push_knob";
	// add more bash animations //

	level._doors_actions["door_sliding_open"] = [];
	level._doors_actions["door_sliding_open"][0] = undefined;
	//level._doors_actions["door_slide"][1] = %another_door_anim;
	// add more slide animations //

	level._doors_actions["door_sliding_vertical_open"] = [];
	level._doors_actions["door_sliding_vertical_open"][0] = undefined;

	level._doors_actions["door_open_generic"] = [];
	level._doors_actions["door_open_generic"][0] = undefined; //"door_open_generic";

	// add more actions here //

	// these need to exist for compatibility with old-style doors
	level._doors_actions["door_push"] = [];
	level._doors_actions["door_push"][0] = undefined;

	level._doors_actions["door_pull"] = [];
	level._doors_actions["door_pull"][0] = undefined;

	level._doors_actions["door_slide"] = [];
	level._doors_actions["door_slide"][0] = undefined;
}

//
// door_node - thread functions to handle AI and player interaction with doors
//
door_node()
{
	if (isDefined(self.initialized))
	{
		return;
	}

	// init node "flags" //
	if (!IsDefined(self.unlocked))
	{
		self.unlocked = 0;
	}

	if (!IsDefined(self.no_player))
	{
		self.no_player = 0;
	}

	if (!IsDefined(self.no_ai))
	{
		self.no_ai = 0;				// TODO: implement no_ai functionality ( ai doesn't use this door from this node ).
	}

	if (!IsDefined(self.linked_to_door))
	{
		self.linked_to_door = 0;	// TODO: implement linked_to_door functionality ( link interaction model to door ).
	}

	if (!IsDefined(self.no_collision))
	{
		self.no_collision = 0;		// TODO: implement no_collision functionality ( make interaction model non-solid ).
	}

	if (isDefined(self.script_door_node_radius))
	{
		self._trigger_radius = self.script_door_node_radius;
	}
	else
	{
		self._trigger_radius = 25;
	}

	self init_door_anim();

	// remove any duplicate door references (might cause problems if mixing old and new style doors, which you shouldn't anyway)
	doorRefTemp = self.doorRef;	
	self.doorRef = [];
	for (i = 0; i < doorRefTemp.size; i++)
	{
		copy = true;

		for (j = 0; j < self.doorRef.size; j++)
		{
			if(doorRefTemp[i]._doors_id == self.doorRef[j]._doors_id)
			{
				copy = false;
				break;
			}    
		}

		if (copy)
		{
			self.doorRef[self.doorRef.size] = doorRefTemp[i];
		}
	}

	///////////////////

	door = self.doorRef;
	if (!isDefined(door) || door.size == 0 )
	{
		//assertMsg("Door node with no doors.");
		return;
	}

	targetNode = self.target;
	if (!isDefined(targetNode) && !door[0].old_style_door)	// some old style doors are setup without an end node.
	{
		//assertMsg("Door begin node without a target node.");
		return;
	}

	//////////////////////

	if (!self.no_player)
	{
		trig = Spawn("trigger_radius", self.origin, 0, self._trigger_radius, 4*self._trigger_radius);
		trig.doorRef = door;
		trig.nodeRef = self;

		//if(door._doors_lock_type == "mechanical")
		//	trig.locktype = "mechanical";
		//    trig.lockname = "mechlock_1";   // temp
		//else if(door._doors_lock_type == "electronic")	
		//	trig.locktype = "electronic";
		//    trig.lockname = "eleclock_1";  // temp
		//else
		//	trig.locktype = "none";
		//    trig.lockname = "none";

		//if(isDefined(door._doors_lock_subtype))
		//{
		//    trig.script_string = door._doors_lock_subtype;
		//    trig.script_lockparams = door._doors_lock_lockparams;
		//}
		// TODO replace doors_lock_type with a lock name
		// TODO else use a default lock

		for (i = 0; i < door.size; i++)
		{
			trig thread player_node(door[i], self);

			if(door[i]._doors_bashable)
			{
				trig thread wait_for_bash(door[i], self);	
			}
		}	
	}

	self.initialized = true;
}

//
// init_door_anim - assign the correct (default) animation to each door node
// TBD - interaction models. Should probably just add an interaction type key pair to each door begin node
// also right now I only have one door anim so this is pretty basic
//
init_door_anim()    // called on door node
{
	node = self;
	door = self.doorRef[0]; // assume parameters of the first door

	node._anims_open = [];
	node._anims_interact = [];

	/// interaction anims

	// TODO assign interaction types to nodes via a key pair. For now, just make a good guess based on the door type.

	if(door.type == "rotating")   // assume it's a knob - still need anims for handles, push bars, etc
	{
		node._anims_interact = level._doors_actions["door_knob_interact"];
	}
	else if(door.type == "sliding") 
	{
		node._anims_interact = level._doors_actions["door_slide_interact"];
	}
	else if(door.type == "vertical") 
	{
		node._anims_interact = level._doors_actions["door_slide_vertical_interact"];   
	}
	else    // assume nothing in particular
	{
		node._anims_interact = [];
	}

	// opening anims

	// right now, we got nothing
	if(door.type == "rotating")   
	{
		node._anims_open = level._doors_actions["door_rotating_push"];
		node._anims_open["pull"] = level._doors_actions["door_rotating_pull"];       
	}
	else if(door.type == "sliding") 
	{
		node._anims_open = level._doors_actions["door_sliding_open"];
	}
	else if(door.type == "vertical") 
	{
		node._anims_open = level._doors_actions["door_sliding_vertical_open"];
	}
	else    // assume nothing in particular
	{
		// disabled until we have placeholder door open anim
		node._anims_open = []; //level._doors_actions["door_open_generic"];
	}    
}

//
// calc_door_angle - figure out the angle that the door will rotate (for player opening door)
//
calc_door_angle(door)
{
	dir = level.player door_direction(door);
	//if (self._doors_method == "door_pull")
	//{
	//	dir *= -1;	// flip direction for pull
	//}

	if(dir == -1) // cw
	{
		angle = -150;	// default
		if (IsDefined(door._doors_min_angle))
		{
			angle = door._doors_min_angle;
		}

		if(angle > -20) 
		{
			if( (door._doors_max_angle != 0) && (door._doors_barred == false))
			{
				///#
				//    iPrintLnBold("pulling door");
				//#/
				// TODO switch anim
				angle = door._doors_max_angle; 
			}  
		}    
	}

	else         // assume ccw
	{
		angle = 150;	// default
		if (IsDefined(door._doors_max_angle))
		{
			angle = door._doors_max_angle;
		}

		if(angle <  20) 
		{
			if( (door._doors_min_angle != 0) && (door._doors_barred == false))
			{
				///#
				//    iPrintLnBold("pulling door");
				//#/
				// TODO switch anim
				angle = door._doors_min_angle;
			}   
		}   
	}

	return angle;
}

//
// calc_door_angle_from_node - figure out the angle that the door will rotate (for ai upon reaching the node)
//
calc_door_angle_from_node(node)
{
	if (!isDefined(node.doorRef) || node.doorRef.size == 0)
	{
		return;
	}

	door = self;

	dir = node door_direction(door);
	//if (self._doors_method == "door_pull")
	//{
	//	dir *= -1;	// flip direction for pull
	//}

	if (dir == -1) // cw
	{
		angle = -150;	// default
		if (IsDefined(door._doors_min_angle))
		{
			angle = door._doors_min_angle;
		}

		if (angle > -20) 
		{
			if ((door._doors_max_angle != 0) && (door._doors_barred == false))
			{
				///#
				//  iPrintLnBold("pulling door");
				// #/
				// TODO switch anim
				angle = door._doors_max_angle;

				door._doors_being_pulled = true;
			}  
		}    
	}
	else         // assume ccw
	{
		angle = 150;	// default
		if (IsDefined(door._doors_max_angle))
		{
			angle = door._doors_max_angle;
		}

		if (angle < 20) 
		{
			if ((door._doors_min_angle != 0) && (door._doors_barred == false))
			{
				///#
				//  iPrintLnBold("pulling door");
				// #/

				// TODO switch anim
				angle = door._doors_min_angle;

				door._doors_being_pulled = true;
			}   
		}   
	}

	return angle;
}

//
// calc_door_position_from_node - calculate where the door should move to based on a node (for sliding doors)
//
calc_door_position_from_node(node)
{
	if (!isDefined(node.doorRef) || node.doorRef.size == 0)
	{
		return;
	}

	door = self;

	// doors can slide left, right, up, or down. Figure out which one 
	// of these four directions is most appropriate

	up = AnglesToUp(node.angles);
	right = AnglesToRight(node.angles);
	new_pos = undefined;

	move_dist = self._doors_slide_dist;

	upDot = VectorDot(up, VectorNormalize(door.origin - node.origin));
	rightDot = VectorDot(right, VectorNormalize(door.origin - node.origin));

	if (door.type == "vertical")
	{
		if (upDot > 0)
		{
			new_pos = door.origin + (up * move_dist);// up
		}
		else
		{
			new_pos = door.origin + ((-1 * up) * move_dist);// down
		}
	}

	else                            // horizontal sliding door
	{
		if (rightDot > 0)
		{
			new_pos = door.origin + (right * move_dist);// right
		}
		else
		{
			new_pos = door.origin + ((-1 * right) * move_dist);// left
		}
	}

	return new_pos;
}

//
// door_anim_ai - do animation for ai opening the door
//
door_anim_ai(node)
{
	animation = undefined;
	if (IsDefined(node.script_animation))
	{
		debug = false;

		/#
			// debug check for user specified animation
			debug = !does_anim_exist("_doors", node.script_animation);
#/		

		if (debug)
		{
			println("\n^1PLEASE ADD THE FOLLOWING LINE TO YOUR SCRIPT (OR REMOVE SCRIPT_ANIMATION FROM THE DOOR NODE):");
			println("^5level.scr_anim[\"_doors\"][\"" + node.script_animation + "\"] = %<actual_animation_name>;\n");
			assertmsg("door node specifies animation that is not defined in animation array.");
		}
		else
		{
			animation = level.scr_anim["_doors"][node.script_animation];
		}
	}

	if (!IsDefined(animation))
	{
		if (IsDefined(level._doors_actions[node._doors_method]) && (level._doors_actions[node._doors_method].size > 0))
		{
			animation = maps\_utility::random(level._doors_actions[node._doors_method]);
		}
	}

	if (IsDefined(animation))
	{
		self AnimScripted("opendoor", node.origin, node.angles, animation);
		if (AnimHasNoteTrack(animation, "open"))
		{
			self waittillmatch("opendoor", "open");
		}
		else
		{
			wait 1;	// default wait for the animation to play. we should always have a note-track though, and maybe this should be an error
		}
	}
}

//
// does_anim_exist - check if an anim is defined in the level.scr_anim array
//
does_anim_exist(anim_type, anim_name)
{
	ret_val = false;
	if (IsDefined(level.scr_anim))
	{
		// the array is at least defined, now look for the anim type (the keys of the array)
		keys = GetArrayKeys(level.scr_anim);
		for (i = 0; i < keys.size; i++)
		{
			if (IsString(keys[i]) && (keys[i] == anim_type))
			{
				ret_val = true;
				break;
			}
		}

		if (ret_val)
		{
			// we found the type, now look for the name, the keys of the next array dimension
			ret_val = false;
			keys = GetArrayKeys(level.scr_anim[anim_type]);
			for (i = 0; i < keys.size; i++)
			{
				if (keys[i] == anim_name)
				{
					ret_val = true;
					break;
				}
			}
		}
	}

	return ret_val;
}

//
// go_to_next_node - send AI to specified node after door opens
//
go_to_next_node(node)
{
	if (IsDefined(node.target))
	{
		next_node = GetNode(node.target, "targetname");
		if (IsDefined(next_node))
		{
			if (next_node.radius != 0)
			{
				self.goalradius = next_node.radius;
			}
			else
			{
				self.goalradius = level.default_goalradius;
			}

			self maps\_utility::set_goal_node(next_node);
			return;
		}
	}

	// just set the guys goalradius to the defualt
	self.goalradius = level.default_goalradius;
}

//
//  open_door - Call this on a door node. 
//
open_door()
{
	if(isDefined(self.doorRef)) // this is a door node
	{
		self thread open_door_from_door_node();
		return;
	}
}	        

//
// Open_door_from_door_node - opens a door from a door node.  does not do any checks (i.e. to see if door is locked)
// Called from door.gsc - ACTUALLY OPENS THE DOOR
//
open_door_from_door_node(keep_open)
{
	if(!isDefined(self.doorRef) || self.doorRef.size == 0)
		return;

	doors = self.doorRef;

	anims_done = false;

	for(i = 0; i < doors.size; i++)
	{
		door = doors[i];

		door._keep_open = keep_open;

		if(door._doors_open == true)
			continue;

		// todo pull anims and different interaction models
		if(door._doors_player_opening && !isDefined(door.bashed) && !anims_done)
		{
			self door_open_anim_player(self);
			//self waittill("ready_to_open");

			anims_done = true;
		}    

		door thread open_single_door_from_door_node(self);        
	}	    
}

//
// open_single_door_from_door_node()
//
open_single_door_from_door_node(node)
{
	self endon("player_open_cancel");

	door = self;

	if (door._doors_open == true)
	{
		return;
	}

	door._doors_open = true;
	door notify("opening");
	door_update_node_open_flag( door );

	if (door._doors_no_collision == true)
	{
		door NotSolid();
	}

	if (!isDefined(door._doors_movement_time) || (door._doors_movement_time < 0.1))
	{
		door._doors_movement_time = 1.0;
	}

	if (door.old_style_door && IsDefined(self.script_noteworthy))
	{
		if (self.script_noteworthy == "door_slide")
		{
			door.type = "sliding";
		}
	}

	if ((door.type != "sliding") && (door.type != "vertical"))
	{

		accel = 0.0;
		decel = door._doors_movement_time * 0.8;

		angle = door calc_door_angle_from_node(node);

		if (angle == 0)
		{
			/#
				iPrintLnBold("Door is blocked.");
#/
		}
		else
		{
			door clear_rotating_door_path(node);

			door playsound("Door_Rotating_Open");
			door RotateYaw(door calc_door_angle_from_node(node), door._doors_movement_time, accel, decel);
			door waittill("rotatedone");     

			door._doors_being_pulled = false;
		}
	}
	else
	{
		accel = 0.0;
		decel = door._doors_movement_time * 0.8;

		door playsound("Door_Sliding_Open");
		door MoveTo(door calc_door_position_from_node(node), door._doors_movement_time, accel, decel);
		door waittill("movedone");
	}

	if (door._doors_no_collision == true)
	{
		door Solid();
	}

	door notify("open");

	if (door._doors_auto_close)
	{
		node thread auto_close();
	}

	door._doors_player_opening = false;
}

auto_open()
{
	trig = Spawn("trigger_radius", self.origin, 7, self._doors_radius, 80);

	while (true)
	{
		trig waittill("trigger", e);
		node = get_closest_door_node(e, self);
		node thread open_door_from_door_node();
		self waittill("closed");
	}
}

//
// auto_close - automatically close the door when there's nobody within the door's radius (called on node)
//
auto_close()
{
	if(!isDefined(self.doorRef))
		return;

	// Assume parameters of first door, if this node is linked to several        
	door = self.doorRef[0];

	if(!door._doors_auto_close)
		return;

	// Create a trigger that checks for the door to be able to close
	if ( !IsDefined(self._doors_clear_trigger) )
	{
		self._doors_clear_trigger = Spawn("trigger_radius", self.origin, 7, door._doors_radius, 200);	//spawnflag = all AI and player, no vehicles
	}

	// Start the trigger
	self thread notify_not_clear( self._doors_clear_trigger );
	self thread notify_clear();

	// Wait for the "all_clear" message
	self waittill("all_clear");

	// Close the Door(s)
	for (i = 0; i < self.doorRef.size; i++)
	{
		// Are we a door that can close?
		if (isDefined(self.doorRef[i]))
		{
			if (!isDefined(self.doorRef[i]._keep_open) || !self.doorRef[i]._keep_open)
			{
				self.doorRef[i] thread close_door();
			}
		}
	}   
}

//**********************************************************
// The door recieves a NOT_clear singal if someone enters it
//**********************************************************
notify_not_clear(trig)
{
	// If we get an all clear, we're finished
	self endon("all_clear");

	// If the trigger is triggered, send a "not_clear" message
	while (true)
	{
		trig waittill("trigger");
		self notify("not_clear");
	}
}

//************
// Am I clear?
//************
notify_clear()
{
	// If we get an all clear, we're finished
	self endon("all_clear");

	while (true)
	{
		self thread notify_all_clear();
		self waittill("not_clear");
	}
}

//*********************************************************************
// When called wait .5 second, if no one enters trigger, send all_clear
//*********************************************************************
notify_all_clear()
{
	// If we get an all clear, we're finished
	self endon("not_clear");

	// Wait .5 second, if trigger has been clear for .5 seconds, send a close door "all_clear" command
	//wait .5;
	wait 1.5;
	self notify("all_clear");
}

//
//  close_door_from_door_node - script hook for ai/script to close door from a node
//
close_door_from_door_node(immediate)
{
	if(!isDefined(self.doorRef) || self.doorRef.size == 0)
		return;

	doors = self.doorRef;

	for(i = 0; i < doors.size; i++)
	{
		doors[i] thread close_door(immediate);
	}

	doors[0] waittill("closed");
}

//
// close_door - rotates a door to closed position and sets "_doors_open" property to false
//
close_door(immediate)
{
	if (self is_door_open())
	{
		self notify("closing");

		if (self.spawnflags & 1)
		{
			self ConnectPaths();
		}

		if (IsDefined(immediate) && immediate)
		{
			self.angles = self._doors_angles_closed;
		}
		else
		{			
			if (self._doors_no_collision == true)
			{
				self NotSolid();
			}

			if (self.angles != self._doors_angles_closed)
			{
				accel = 0.0;
				decel = self._doors_movement_time * 0.8;

				self RotateTo(self._doors_angles_closed, self._doors_movement_time, accel, decel);
				self playsound("Door_Rotating_Close");
				self waittill("rotatedone");
			}

			if (self.origin != self._doors_origin_closed)	// sliding doors
			{
				accel = 0.0;
				decel = self._doors_movement_time * 0.8;

				self playsound("Door_Sliding_Close");
				self MoveTo(self._doors_origin_closed, self._doors_movement_time, accel, decel);
				self waittill("movedone");
			}

			if (self._doors_no_collision == true)
			{
				self Solid();
			}
		}

		self notify("closed");
		self._doors_open = false;
		door_update_node_open_flag( self );

		if (self._doors_auto_lock)
		{
			self lock_door();
		}
	}

	self._doors_being_pulled = false;
}

//
// door_direction - calculate the direction the door needs to rotate based on the door's origin and node (called on the door trigger that was activated)
//
door_direction(door)
{
	dir = 1;
	dot = VectorDot(AnglesToRight(self.angles), VectorNormalize(door.origin - self.origin));
	if (dot > 0)	// hinge is on the right side of actor
	{
		dir = -1;		// clockwise
	}

	return dir;
}

//
// check if a door is open
//
is_door_open()
{
	return self._doors_open;
}

//
// check if door is locked
//
is_door_locked(node)
{
	is_locked = false;

	if (self._doors_locked)
	{
		is_locked = true;

		// if the door is locked, check to see if the door is always unlocked from this node
		if (IsDefined(node) && node.unlocked)
		{
			is_locked = false;
		}
	}

	return is_locked;
}

//
// lock door
//
lock_door()
{
	self.lock_ent maps\_utility::red_light();

	self._doors_locked = true;
	self notify("locked");

	door_update_node_states();
}

//
// unlock door
//
unlock_door()
{
	if (!self._doors_barred)
	{
		self.lock_ent maps\_utility::green_light();
	}

	self._doors_locked = false;
	self notify("unlocked");

	door_update_node_states();	
}

unbarred_door()
{
	if (!self._doors_locked)
	{
		self.lock_ent maps\_utility::green_light();
	}

	self._doors_barred = false;
	self notify("unbarred");

	door_update_node_states();
}

barred_door()
{
	self.lock_ent maps\_utility::red_light();

	self._doors_barred = true;
	self notify("barred");

	door_update_node_states();	
}

//
// return door lock type (electronic, mechanical, none)
//
get_door_lock_type()
{
	if (isDefined(self.lock_ent.locktype))
	{
		return self.lock_ent.locktype;
	}
	else
	{
		return "none";    
	}
}

//
// return door lock type (electronic, mechanical, none) from a node
//
get_door_node_lock_type()
{
	return self.doorRef[0] get_door_lock_type();
}

//
// attempt to unlock door
//
player_attempt_door_unlock(node)
{
	self endon("lockpick_done");
	self endon("bash_done");

	if( self is_door_open())
	{
		return true;
	}

	success = false;				

	lock_type = self get_door_lock_type();
	if(!isdefined(lock_type) || (lock_type == "none"))
	{
		success = true;
	}
	else
	{
		if(lock_type == "electronic")
		{
			if( self.lock_ent maps\_unlock_mechanisms::unlock_electronic(node))
			{
				success = true;
			}
			else
			{
				success = false;
			}
		}
	}

	return success;
}

//
// keypad_unlock - hanldes unlocking doors from keypads
//
keypad_unlock()
{
	if (!IsDefined(self.lock_ent.keypad_thread))
	{
		// block multiple instances of this thread on a keypad because this is called from every door that is associated with this keypad
		self.lock_ent.keypad_thread = true;

		while (true)
		{
			while (true)
			{
				if (self is_door_locked() && !self._doors_barred)
				{
					self.lock_ent SetUseable(true);
					self.lock_ent SetHintString(&"SCRIPT_UNLOCK_DOOR");
					self.lock_ent SetCursorHint("HINT_PHONE_ELECPICK");

					if (self.lock_ent maps\_unlock_mechanisms::can_use_lock())
					{
						self.lock_ent SetUseable(true);

						if (level.player UseButtonPressed())
						{
							break;
						}
					}
					else
					{
						self.lock_ent SetUseable(false);
					}
				}

				wait .05;
			}

			self attemp_unlock();
			wait .05;
		}
	}
}

attemp_unlock()
{
	self.lock_ent SetHintString("");
	self.lock_ent SetCursorHint("");
	if (self.lock_ent maps\_unlock_mechanisms::unlock_electronic())
	{
		self.lock_ent SetUseable(false);
		self unlock_door();

		node = get_closest_door_node(level.player, self);
		node thread open_door_from_door_node();

		// WW 06-07-08
		// fire off an achievement function
		level thread maps\_achievements::ach_lock_hack_watch(level.script, self.lock_ent.script_int);
	}
}

get_closest_door_node(e, door)
{
	nodes = [];
	if (IsDefined(door))
	{
		nodes = door._doors_nodes;	// get closest for this door
	}
	else
	{
		nodes = level._doors_nodes;	// get closest of all door nodes
	}

	return maps\_utility::getClosest(e.origin, nodes);
}

//
// player_node - handle player opening of doors
//
player_node(door, node)
{
	self endon("player_door_cancel");
	self waittill("trigger");

	// do a line-of-sight check to the node 
	if( !level.player sightconetrace(node.origin, self) > 0 )
	{
		self thread player_node(door, node);
		return;  
	}    

	while (true)
	{
		if (self can_open_door(door, node))
		{
			self player_open(door, node);
		}
		else
		{
			self thread clear(door, node);
		}

		wait .2;
	}
}

//
// clear - clear the door hud and re-thread the player function
//
clear(door, node)
{
	door setUseable( false );
	self notify("player_door_cancel");
	self thread player_node(door, node);
	door._doors_player_opening = false;
}

//
// can_open_door - test to see if the player is in position and the door is closed
//
can_open_door(door, node)
{
	if(door is_door_open())
		return false;

	if(isdefined(node.disabled))
		if(node.disabled == true)
			return false;    

	dot = VectorDot(AnglesToForward(node.angles), AnglesToForward(level.player.angles));
	if ((!level.player IsTouching(self)) || (dot < .6))
	{
		return false;
	}

	return true;
}

//
// player_open - prompt the player to open the door. self here is the trigger_radius
//
player_open(door, node)
{
	self endon("player_door_cancel");
	door endon("opening");								// cancel if someone else opens the door while we are waiting for player input

	lock_type = door get_door_lock_type();

	door_hud_in_use = false;
	door._doors_player_opening = true;

	if (door._doors_bashable)
	{		
		door setUseable(true);
		door sethintstring(&"SCRIPT_OPEN_BASHABLE_DOOR");
		door setcursorhint("HINT_DOOR");

		while (!level.player usebuttonpressed() && self can_open_door(door, node) )
		{
			wait .05;
		}

		door setUseable( false );

		if(level.player usebuttonpressed())
		{
			door thread rattle_door(node);
		}
	}
	else if (door._doors_barred || door._disabled )
	{		
		door setUseable(false);
		//door sethintstring (&"SCRIPT_BARRED_DOOR");
		//door setcursorhint ("HINT_NOICON");
	}
	else if (door is_door_locked(node))
	{
		if ((lock_type != "none") && (door.lock_ent == door))
		{
			level.player thread wait_for_unlock_notify(door, self);

			tryunlock = false;

			door setUseable(true);
			door sethintstring(&"SCRIPT_UNLOCK_DOOR");
			door setcursorhint("HINT_PHONE_ELECPICK");

			while (!level.player usebuttonpressed() && can_open_door(door, node) )
			{
				wait .05;
			}

			// debounce
			while (level.player useButtonPressed() && can_open_door(door, node) )
			{
				wait .05;
				tryunlock = true;			
			}

			if (tryunlock && can_open_door(door, node))
			{
				if (door is_door_locked(node))
				{
					door player_attempt_door_unlock(node);
				}
			}
		}
		else
		{
			door setUseable(false);
			//door sethintstring(&"SCRIPT_BARRED_DOOR");
			//door setcursorhint("HINT_NOICON");
		}
	}
	else
	{
		door setUseable(true);
		door sethintstring(&"SCRIPT_OPEN_DOOR");
		door setcursorhint("HINT_DOOR");

		while (!level.player usebuttonpressed() && can_open_door(door, node))
		{
			wait .05;
		}

		door setUseable( false );
		if(level.player usebuttonpressed())
		{
			node thread open_door_from_door_node();
		}
	}
}

wait_for_unlock_notify( door, trig )
{
	trig endon("player_door_cancel");
	self waittill("lockpick_done");
	if( level.player.lockSuccess )
	{
		door unlock_door();
		trig.nodeRef thread open_door_from_door_node();
	}
}

//
// wait_for_bash - wait for melee attack from player if the door is bashable (called on radius trigger)
//
wait_for_bash(door, node)
{
	if (!isDefined(door._doors_bashable) || (door._doors_bashable == false))
	{
		return;
	}

	//door setmodel("bashable_door_test");
	door solid();

	self waittill("trigger");

	dmgEnt = spawn("script_model", (door.origin[0], door.origin[1], door.origin[2] - 45));
	damagedModel = spawn("script_model", (door.origin[0], door.origin[1], door.origin[2] - 45));
	damagedModel.angles = (door.angles[0], door.angles[1] - 90, door.angles[2] );
	damagedModel SetModel(door._doors_bashed_model);
	damagedModel hide();

	dmgEnt endon("door_bashed");    

	//dmgEnt = spawn("script_model", (node.origin[0], node.origin[1], node.origin[2] - 45));

	if(!isdefined(door.dmgEntInit))
	{
		//dmgEnt SetModel("com_door_test");
		dmgEnt solid();
		dmgEnt.angles = (door.angles[0], door.angles[1], door.angles[2]);
		door linkto(dmgEnt);
		damagedModel linkto(dmgEnt);
		dmgEnt hide();

		door.dmgEntInit = true;
	}

	numTrigs = 	door._doors_damage_triggers.size;

	if(numTrigs == 0)
		assertmsg("Bashable door does not have a trigger_damage associated with it.");

	for( i = 0; i < door._doors_damage_triggers.size; i++)
	{    
		door thread monitor_damage_trigger( door._doors_damage_triggers[i] );
	}

	while(1)
	{
		// wait for any of this door's damage triggers to be hit     
		door waittill("damage_trigger_hit", damage, type, point, direction_vec);
		// could add logic specific to individual triggers here if desired

		if((damage > 5) && (type == "MOD_MELEE") || (type == "MOD_IMPACT"))
		{    
			door._doors_auto_close = false;
			dmgEnt do_door_bash(door, node, point, direction_vec, damagedModel);           

			self notify("player_door_cancel");
		}
	}
}

do_door_bash(door, node, point, direction_vec, damagedModel)    // called on the door's damage entity. Do all the bashed-door handling here
{
	if(isdefined(door.dmgEntInit))
	{          
		launchVector = (level.player.angles[0], -45, 0);
		self physicslaunch( point, vector_multiply(launchVector, 1.0) );
		self NotSolid();
		door NotSolid();
		door.bashed = true;
		node thread open_door();
		level.player playsound( door._doors_bash_audio ); 
		door hide();
		damagedModel show();
		//door SetModel("bashed_door_test");
		self notify("door_bashed");
		wait 0.5;
		self solid();
		door solid();
	}    
	else
	{
		node thread open_door();
	}
}               

monitor_damage_trigger( trig )
{
	trig waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	self notify("damage_trigger_hit", damage, type, point, direction_vec);

	for( i = 0; i < self._doors_damage_triggers.size; i++)
	{    
		self._doors_damage_triggers[i] delete();
	}
}

//
// rattle_door - shakes door around, this gets called when you try to open a bashable door normally
//
rattle_door(node)
{
	door = self;

	if (!isDefined(door._doors_bashable) || (door._doors_bashable == false))
	{
		return;
	}

	/#
		iPrintLnBold("rattling door");
#/     

	if (isDefined(node._anims_interact) && node._anims_interact.size > 0)
	{
		interact_anim = maps\_utility::random(node._anims_interact);

		if (isDefined(interact_anim))
		{
			level.player playerAnimScriptEvent(interact_anim);
			wait 2.0;
		}    
	}

	level.player playsound("try_use_door_bashable");

	door vibrate((0, 0, 1), 0.3, 0.4, 1.0);
}

can_unlock_this_door(door, node)
{
	// TODO: use this to give specific ai's access to particular doors

	return false;
}

//
// door_open_anim_player - do animation for player opening the door
//
door_open_anim_player(node)
{
	self endon("player_door_cancel");

	level.player freezeControls(true);

	// first play the interaction anim, if there is one, then the open anim

	if(isDefined(node._anims_interact) && (node._anims_interact.size > 0))
	{   
		interact_anim = maps\_utility::random(node._anims_interact);

		if(isDefined(interact_anim))
		{
			level.player setorigin(node.origin);
			level.player setplayerangles(node.angles);
			level.player playerAnimScriptEvent(interact_anim);
			wait 2.5;
		}    
	}

	level.player freezeControls(false);

	// now the open anim

	animation = undefined;
	if (IsDefined(node.script_animation))
	{
		debug = false;

		/#
			// debug check for user specified animation
			debug = !does_anim_exist("_doors", node.script_animation);
#/		

		if (debug)
		{
			println("\n^1PLEASE ADD THE FOLLOWING LINE TO YOUR SCRIPT (OR REMOVE SCRIPT_ANIMATION FROM THE DOOR NODE):");
			println("^5level.scr_anim[\"_doors\"][\"" + node.script_animation + "\"] = %<actual_animation_name>;\n");
			assertmsg("door node specifies animation that is not defined in animation array.");
		}
		else
		{
			animation = level.scr_anim["_doors"][node.script_animation];
		}
	}

	if (!IsDefined(animation))
	{
		// TODO check for pulling

		if (IsDefined(node._anims_open) && (node._anims_open.size > 0))
		{
			animation = maps\_utility::random(node._anims_open);
		}

		//disabled until we have a placeholder door open anim
		//else  
		//    animation = "door_open_generic";
	}

	if (IsDefined(animation))
	{
		level.player playerAnimScriptEvent(animation);
		if (AnimHasNoteTrack(animation, "open"))
		{
			self waittillmatch("opendoor", "open");
		}
		else
		{
			wait 1;	// default wait for the animation to play. we should always have a note-track though, and maybe this should be an error
		}
	}

	self notify("ready_to_open");
}

//
//  clear_rotating_door_path - moves player and AI out of the way of an opening door.
//
clear_rotating_door_path(node)   // Called when a rotating door is opened. Node is the node that the door is being opened from
{
	// constants
	door_min_dist = 150; // 150 was previous value, also tried: // 72 + 16; // 6 feet
	door_min_dist_lateral = 48 + 16; // 4 feet
	
	// door info
	door = self;
	door_closed_angles = ( node.angles[0], node.angles[1] + 90, node.angles[2] );
	door_closed_forward = anglestoforward( door_closed_angles );
	door_open_angles = node.angles;
	if( door._doors_being_pulled )    // reverse direction for pulled doors
		door_open_angles = ( door_open_angles[0], door_open_angles[1] + 180, door_open_angles[2] );
	door_open_forward = anglestoforward( door_open_angles );

	// get direction from node to player
	dir_node_to_player = (level.player.origin - node.origin);
	
	// get distance of player sideways from center of door
	door_dist_lateral = vectordot( door_closed_forward, dir_node_to_player );

	// are we close enough laterally to be concerned?
	if ( ( door_dist_lateral < -1 * door_min_dist_lateral ) || ( door_dist_lateral > door_min_dist_lateral ) )
		return;

	// get direction from door to player
	dir_door_to_player = (level.player.origin - door.origin);
	
	// how far is player from door along the door open direction
	proj_dist_door_to_player = vectordot(dir_door_to_player, door_open_forward);

	// is the player on the colliding side of the door?
	if (proj_dist_door_to_player < 0)
		return;
		
	// is the player too close to the front of door?
	if(proj_dist_door_to_player > door_min_dist)
		return;
		
	// push the player straight away from the door
	push_dist = door_min_dist - proj_dist_door_to_player;
	player_new_pos = (level.player.origin + push_dist*(door_open_forward));

	// clear player away from the door
	level.player setorigin(player_new_pos);
	
	// stick player while door is opening?
	//thread player_stick_duration( 0.6 );
}

player_stick_duration( duration )
{
	player_stick( true );
	wait duration;
	player_unstick();
}

//******************************************************************************************************
// Updates the spawn flags on the door nodes to say if they have the PNF_DOOR_BLOCKED flag set correctly
// A little inefficient, but i think the CPU cost is negligable
//******************************************************************************************************

door_update_node_states()
{
	//****************************
	// Cycle through all the doors
	//****************************

	for( i=0; i < level.doors.size; i++ )
	{
		//***********************************
		// Ignore doors that don't have nodes
		//***********************************

		if(!isDefined(level.doors[i].target) && (level.doors[i]._doors_oldnodes.size == 0) )
			continue;

		//*****************************************************************************
		// Get all nodes targeted by this door and update their PNF_DOOR_BLOCKED status
		//*****************************************************************************

		door = level.doors[i];

		if( isDefined( door ) && isDefined( door.target ) )
		{
			curNodes = GetNodeArray( door.target, "targetname" );
			for( j=0; j < curNodes.size; j++ )
			{
				node = curNodes[j];

				if( ( door._doors_barred == false ) &&
					( door._doors_bashable == false ) &&
					( door._doors_locked == false ) )
				{
					nodesetblocked( node, 0 );
				}
				else
				{
					nodesetblocked( node, 1 );
				}
			}
		}
	}
}

//******************************************************************************************************
// Sets the PNF_DOOR_CLOSED flag on a door
//******************************************************************************************************

door_update_node_open_flag( door )
{
	//*****************************************************************************
	// Get all nodes targeted by this door and update their PNF_DOOR_BLOCKED status
	//*****************************************************************************
	if (!isDefined(door) || !isDefined(door.target))
	{
		return;
	}

	curNodes = GetNodeArray( door.target, "targetname" );
	for (i=0; i < curNodes.size; i++)
	{
		node = curNodes[i];

		if(door._doors_open == false)
		{
			nodesetopen(node, 0);
		}
		else
		{
			nodesetopen(node, 1);
		}
	}
}

//******************************************************************************************************
// Test stuff for a Notify at a restart level to reset door states
//******************************************************************************************************

//doors_reset_nodes()
//{
//	level.player waittill("reset_doors");
//	door_update_node_states();
//	
//	// Call again
//	doors_reset_nodes();
//}

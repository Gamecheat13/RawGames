///*------------------------------------------------------------------------------------------------------------
//																						Foliage Stealth System
//------------------------------------------------------------------------------------------------------------*/
//				This system is meant to be used with the _stealth_logic and _stealth_behavior systems.
//				First, make sure to follow the instructions in _stealth_logic.gsc to set up that system, 
//				then follow the following instructions:
//				
//				1) 	Include _foliage_cover.gsc in your .csv ( rawfile,maps/_foliage_cover.gsc )
//				2) 	Call maps\_foliage_cover::init_foliage_cover(); right after you call maps\_stealth_behavior::main();
//				3) 	Thread maps\_foliage_cover::init_foliage_stealth_on_player() on the player when you want the system 
//						to turn on
//			
//				You can call foliage_cover_player_off() on a player to turn the system off.
//				Use foliage_cover_player_on() to turn the system back on.
///*------------------------------------------------------------------------------------------------------------
//																						
//------------------------------------------------------------------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;

///*------------------------------------------------------------------------------------------------------------
//																						Initialization Functions
//------------------------------------------------------------------------------------------------------------*/

/*------------------------------------
// Initialize foliage cover functionality
// Call this function after maps\_load::main() in the level main function
------------------------------------*/
init_foliage_cover()
{
	init_foliage_triggers();	
	init_foliage_cover_variables();	
}

/*------------------------------------
Grabs the foliage triggers and starts their thinking logic
------------------------------------*/
init_foliage_triggers()
{
	prone_triggers 		= getentarray("foliage_cover_prone", "script_noteworthy");
	crouch_triggers		= getentarray("foliage_cover_crouch", "script_noteworthy");
	stand_triggers 		= getentarray("foliage_cover_stand", "script_noteworthy");
	
	array_thread(prone_triggers, ::foliage_cover_watch_trigger);
	array_thread(crouch_triggers, ::foliage_cover_watch_trigger);
	array_thread(stand_triggers, ::foliage_cover_watch_trigger);
}



/*------------------------------------
sets the global variables for foliage cover
------------------------------------*/
init_foliage_cover_variables()
{
	level.foliage_cover = spawn("script_origin", (0, 0, 0));
	level.foliage_cover.sight_dist = [];
	
	level.foliage_cover.sight_dist["default"] = 8192;
	level.foliage_cover.sight_dist["contextual_melee"] = 64;
	level.foliage_cover.sight_dist["no_cover"] = 512;
	level.foliage_cover.sight_dist["firing_weapon"]	= 1024;
	level.foliage_cover.sight_dist["foliage_cover_prone"] = 128;
	level.foliage_cover.sight_dist["foliage_cover_crouch"]= 128;
	level.foliage_cover.sight_dist["foliage_cover_stand"] = 64;
	
	level.foliage_cover.crouch_modifier	= .5;
	level.foliage_cover.prone_modifier = .25;
	level.foliage_cover.scale_time = 2000;	// in milliseconds
	
	level.foliage_cover.cover_think["foliage_cover_prone"]	= ::cover_prone_think;
	level.foliage_cover.cover_think["foliage_cover_crouch"] = ::cover_crouch_think;
	level.foliage_cover.cover_think["foliage_cover_stand"] 	= ::cover_stand_think;
	
	level.foliage_cover.patrollers = [];

	// foliage corpse detection modifiers for stealth system
	level._stealth.logic.corpse.foliage_sight_dist  = 100; //this is how far they can see to see a corpse
	level._stealth.logic.corpse.foliage_detect_dist = 128; //this is at what distance they automatically see a corpse
	level._stealth.logic.corpse.foliage_found_dist  = 100; //this is at what distance they actually find a corpse
	//this is good for optimization
	level._stealth.logic.corpse.foliage_sight_distsqrd 	= level._stealth.logic.corpse.foliage_sight_dist * level._stealth.logic.corpse.foliage_sight_dist;
	level._stealth.logic.corpse.foliage_detect_distsqrd = level._stealth.logic.corpse.foliage_detect_dist * level._stealth.logic.corpse.foliage_detect_dist;
	level._stealth.logic.corpse.foliage_found_distsqrd 	= level._stealth.logic.corpse.foliage_found_dist * level._stealth.logic.corpse.foliage_found_dist;
}


/*------------------------------------------------------------------------------------------------------------
																						Logic
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------
Called by _stealth_logic.gsc, calculates the maxVisibleDist
self = the player
------------------------------------*/
calculate_foliage_cover(stance)
{
	
	current_trig = get_current_foliage_trigger();
	dist = level.foliage_cover.sight_dist["no_cover"];
	
	if( isdefined( current_trig ) )
	{
		dist = [[ level.foliage_cover.cover_think[ current_trig.script_noteworthy ] ]]();
	}
	
	return(dist);
}

/*------------------------------------------------------------------------------------------------------------
																						Trigger Functions
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------

self = the trigger
------------------------------------*/
foliage_cover_watch_trigger()
{
	level endon("turn_off_foliage_cover");
	
	while(true)
	{	
		self waittill("trigger", guy);
		self thread trigger_thread(guy, ::push_trig_on_enter, ::pop_trig_on_leave);
	}
}

/*------------------------------------

------------------------------------*/
push_trig_on_enter(guy, endon_string)
{
	self endon( endon_string );
	
	guy push_foliage_trigger(self);
}



/*------------------------------------

------------------------------------*/
pop_trig_on_leave(guy)
{
	guy pop_foliage_trigger(self);
}


/*------------------------------------

------------------------------------*/
cover_prone_think()
{
	stance = self getstance();
	
	if(stance == "prone")
	{
		dist = self thread set_modified_sight_dist("foliage_cover_prone");
	}
	else
	{
		dist = self thread set_modified_sight_dist("no_cover");
	}
	
	return(dist);
}



/*------------------------------------

------------------------------------*/
cover_crouch_think()
{
	stance = self getstance();
		
	if(stance == "prone" || stance == "crouch")
	{
		dist = self set_modified_sight_dist("foliage_cover_crouch");
	}
	else
	{
		dist = self set_modified_sight_dist("no_cover");
	}
	
	return(dist);
}



/*------------------------------------

------------------------------------*/
cover_stand_think()
{
	stance = self getstance();
			
	if(stance == "prone" || stance == "crouch" || stance == "stand")
	{
		dist = self set_modified_sight_dist("foliage_cover_stand");
	}
	else
	{
		dist = self set_modified_sight_dist("no_cover");
	}
	
	return(dist);
}

/*------------------------------------
Takes the base value for the detection range and modifies 
it based on the stance of the player
self = the player
------------------------------------*/
set_modified_sight_dist( trigger_type )
{	
	dist = level.foliage_cover.sight_dist[trigger_type];
	
	curr_stance = self getstance();
	switch( curr_stance )
	{
		case "stand":
			dist = dist;
			break;
		case "crouch":
			dist *= level.foliage_cover.crouch_modifier;
			break;
		case "prone":
			dist *= level.foliage_cover.prone_modifier;
			break;		
	}
	
	if( !isDefined(self.foliage_last_stance) )
	{
		self.foliage_last_stance = curr_stance;
	}
	
	return dist;
}



/*------------------------------------------------------------------------------------------------------------
																						Trigger Stack Functions
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------
add a new trigger to the top of the stack
self = the player that entered the trigger
------------------------------------*/
push_foliage_trigger(trigger)
{
	ent_flag_set("_stealth_in_foliage");
	
	if( !isdefined( self.foliage_trigger_stack ) )
	{
		self.foliage_trigger_stack = [];
	}
	
	self.foliage_trigger_stack[self.foliage_trigger_stack.size] = trigger;
}



/*------------------------------------
remove the trigger from the stack array
self = the player that left the trigger
------------------------------------*/
pop_foliage_trigger(trigger)
{
	if( trigger == self.foliage_trigger_stack[self.foliage_trigger_stack.size - 1] )
	{
		self notify("left_top_trigger");
	}
	
	self.foliage_trigger_stack = array_remove(self.foliage_trigger_stack, trigger);

	if( self.foliage_trigger_stack.size == 0)
	{
		ent_flag_clear("_stealth_in_foliage");
	}
}



/*------------------------------------
returns the trigger at the top of the "stack"
self = the player that left the trigger
------------------------------------*/
get_current_foliage_trigger()
{
	if( isdefined(self.foliage_trigger_stack) && self.foliage_trigger_stack.size > 0 )
	{
		return self.foliage_trigger_stack[self.foliage_trigger_stack.size -1];
	}
	
	return undefined;
}
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

/*
	Standard ( Survival )
	Objective:	Standard gameplay that harkons back to the original "Prototype" experience
	Map ends: When all players die
	Respawning:	When the round changes ( just like Classic mode )
*/


register_game_module()
{
	level.GAME_MODULE_STANDARD_INDEX = 10;
	//register_game_module(index,module_name,pre_init_func,post_init_func,pre_init_zombie_spawn_func,post_init_zombie_spawn_func,hub_start_func)

	maps\mp\zombies\_zm_game_module::register_game_module( level.GAME_MODULE_STANDARD_INDEX, "zstandard", ::standard_pre_init, ::standard_post_init, undefined, undefined, ::standard_start_gamemode );
}

register_standard_match( start_func, name, location )
{

	if ( !IsDefined( level._registered_standard_matches ) )
	{
		level._registered_standard_matches = [];
	}

	match = SpawnStruct();
	match.match_name = name;
	match.match_start_func = start_func;
	match.match_location = location;
	match.mode_name = "zstandard";
	level._registered_standard_matches[ level._registered_standard_matches.size ] = match;
}


standard_pre_init()
{
	//maps\mp\zombies\_zm_ai_dogs::init();
	//maps\mp\zombies\_zm_ai_dogs::enable_dog_rounds();
}

standard_post_init()
{
}

standard_start_gamemode(name)
{
	maps\mp\zombies\_zm_ai_dogs::enable_dog_rounds();

	match = get_registered_standard_match(name);
	set_current_standard_match(name);
	
	level thread [[match.match_start_func]]();
	
	//start the zombiemode stuff
	level thread maps\mp\zombies\_zm::round_start();

}

get_registered_standard_match(name,location)
{
	foreach(match in level._registered_standard_matches)
	{
		if(isDefined(name))
		{
			if(match.match_name == name)
			{
				return match;
			}
		}
		
		if(isDefined(location))
		{
			if(match.match_location == location)
			{
				return match;
			}
		}
	}
}

set_current_standard_match(name)
{
	level._current_standard_match = name;
}

get_current_standard_match()
{
	return level._current_standard_match;
}

setup_standard_objects(location)
{
	structs = getstructarray("game_mode_object");
	foreach(struct in structs)
	{
		if(isDefined(struct.script_noteworthy) && struct.script_noteworthy != location)
		{
			continue;
		}
		if(isDefined(struct.script_string) )
		{
			keep = false;
			tokens = strtok(struct.script_string," ");
			foreach(token in tokens)
			{
				if(token == level.scr_zm_ui_gametype && token != "zstandard") //so doesn't double up for zstandard spawns used for more than once.
				{
					keep = true;
				}
				else if(token == "zstandard" )
				{
					keep = true;
				}
			}
			if(!keep)
			{
				continue;
			}
		}
		barricade = spawn("script_model",struct.origin);
		barricade.angles = struct.angles;
		barricade setmodel(struct.script_parameters);
	}
	
	objects = getentarray(); 
	foreach(object in objects)
	{
		
		if(!object is_survival_object() )
		{
			continue;
		}
		
		if(isDefined(object.spawnflags) && object.spawnflags == 1 && object.classname != "trigger_multiple")
		{
			object connectpaths();
		}
		object delete();
	}
	
	if(isDefined(level._classic_setup_func))
	{
		[[level._classic_setup_func]]();
	}

}

is_survival_object()
{
	if(!isDefined(self.script_parameters) )
	{
		return false;
	}
	tokens = strtok(self.script_parameters," ");	
	remove = false;
	foreach(token in tokens)
	{
		if(token == "survival_remove" )
		{
			remove = true;
		}
	}
	return remove;
	
}

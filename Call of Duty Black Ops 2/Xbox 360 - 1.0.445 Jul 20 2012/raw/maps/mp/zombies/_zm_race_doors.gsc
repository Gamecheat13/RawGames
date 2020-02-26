#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

init_race_doors()
{
	
	level._race_doors = [];
	
	all_doors = getentarray("race_door","script_noteworthy");
	for(i=0;i<all_doors.size;i++)
	{
		door_structs = getstructarray(all_doors[i].target,"targetname");
		for(x=0;x<door_structs.size;x++)
		{
			precachemodel(door_structs[x].script_parameters);
		}
		all_doors[i].door_structs = door_structs;
		
		if(!isDefined(level._race_doors[all_doors[i].script_string]))
		{
			level._race_doors[all_doors[i].script_string] = [];
		}
		if(isDefined(all_doors[i].script_flag) && !flag_exists(all_doors[i].script_flag))
		{
			flag_init(all_doors[i].script_flag);
		}
		level._race_doors[all_doors[i].script_string][level._race_doors[all_doors[i].script_string].size] = all_doors[i];
		
	}			
}

spawn_race_doors()
{
	location = level._race_location;	
	if(!isDefined(level._race_doors[location]))
	{
		return;
	}
	for(i=0;i<level._race_doors[location].size;i++)
	{
		
		for(x =0;x < level._race_doors[location][i].door_structs.size;x++)
		{
			if(!isDefined(level._race_doors[location][i].door_models))
			{
				level._race_doors[location][i].door_models = [];
			}		
		}		
	}	
}


race_open_door(door_name,team,door_num)
{
	
	door = get_race_door(door_name);
	
	if(is_true(door.open))
	{
		return;
	}
	
	level clientnotify("" + team + "_" + door_num);
	level notify("race_town_team_" + team + "_grief_" + door_num);
	
	door.open = true;
	door notsolid();
	door connectpaths();
	door notify("race_door_opened");
	if(!isDefined(level._open_race_doors))
	{
		level._open_race_doors = [];
	}
	level._open_race_doors[level._open_race_doors.size] = door;
	
	Playfx( level._effect["poltergeist"], door.origin );
	door playsound( "zmb_door_open" );
	Earthquake( 0.5, 0.75, door.origin, 1000);
}


race_close_door(door_name)
{
	
	door = get_race_door(door_name);
	
	door disconnectpaths();
	door.door_models = [];
	
	Playfx( level._effect["poltergeist"],door.origin );
	door playsound( "zmb_door_close" );
	Earthquake( 0.5, 0.75, door.origin, 1000);
	
	door race_door_solid();
}
		
race_door_solid()
{

	while( 1 )
	{
		players = GET_PLAYERS(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			self.open = false;
			return; 
		}

		wait( .05 ); 
	}
}

get_race_door(door_name)
{
	if(!isDefined(level._race_doors[level._race_location]))
	{
		return undefined;
	}
	location = level._race_location;
	
	for(i=0;i<level._race_doors[level._race_location].size;i++)
	{

		if(level._race_doors[level._race_location][i].name != door_name)
		{
			continue;
		}
		
		return level._race_doors[level._race_location][i];
	}
}
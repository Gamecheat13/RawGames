#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;


init_game_mode_objects(mode,location)
{
	if(!is_true(level.game_objects_setup))
	{
		level setup_game_mode_objects(mode,location);	
		level.game_objects_setup = true;
		level thread setup_animated_signs();
		
		switch(level._game_mode_mode) //delete the vision/fog triggers in race/meat modes
		{
			case "race":
			case "meat":
			case "zrace":
			case "zmeat":
				players = getlocalplayers();
				for(i=0;i<players.size;i++)
				{
					trigs = getentarray(i,"vision_trig","targetname");
					foreach(trig in trigs)
					{
						trig delete();
					}
				}				
		}		
	}
}

//spawn all the barriers
setup_game_mode_objects(mode,location)
{
	
	level waittill(mode +"_" + location,clientNum);
	if(clientNum != 0)
	{
		return;
	}
	spawned = 0;
	
	level._game_mode_location = location;
	level._game_mode_mode = mode;
	structs = getstructarray("game_mode_object","targetname");
	
	level._game_mode_spawned_objects = [];
	
	for(x=0;x<getlocalplayers().size;x++)
	{
		for(i=0;i<structs.size;i++)
		{
			if(!isDefined(structs[i]))
			{
				continue;
			}
			if(!isDefined(structs[i].script_noteworthy) || structs[i].script_noteworthy != level._game_mode_location)
			{
				continue;
			}
			if( !structs[i] is_game_mode_object(mode))
			{
				continue;
			}
			if(isSplitscreen() ) // spawn in less stuff in ss mode
			{
				if(isDefined(structs[i].groupname) && structs[i].groupname == "splitscreen_remove")
				{
					continue;
				}
			}
			
			object = spawn(x,structs[i].origin,"script_model");
			if(isDefined(structs[i].angles))
			{
				object.angles= structs[i].angles;
			}
			if(isDefined(structs[i].script_parameters))
			{
				object setmodel(structs[i].script_parameters);
			}
			spawned++;
			level._game_mode_spawned_objects[level._game_mode_spawned_objects.size] = object;
		}
	}
	//iprintlnbold("spawned " + spawned + " entities");			
}

is_game_mode_object(mode)
{

	if(self.classname == "script_brushmodel")
	{
		return false;
	}
	if(!isDefined(self.script_string) )
	{
		return true;
	}
	tokens = strtok(self.script_string," ");
	is_object = false;
	foreach(token in tokens)
	{
		if(token == mode)
		{
			is_object = true;
		}
	}
	if(is_object)
	{
		return true;
	}
	return false;
}

/*
RACE SPECIFIC STUFF
*/
door_init(team,doornum)
{
	doors = [];
	spots = [];
	signs = [];
	
	location = getdvar("ui_zm_mapstartlocation");
	for(i = 0; i < level.struct.size; i++)
	{
		if(!isDefined(level.struct[i].name))
		{
			continue;
		}
		if(isSplitscreen() )
		{
			if(isDefined(level.struct[i].groupname) && level.struct[i].groupname == "splitscreen_remove")
			{
				continue;
			}
		}
		
		if(level.struct[i].name == (location + "_" + team + "_door_" + doornum))
		{
			spot = level.struct[i];
			spots[spots.size] = spot;
			players = GetLocalPlayers();
			for(x=0;x<players.size;x++)
			{		
				door = spawn(x,spot.origin,"script_model");
				if(isDefined(spot.angles))
				{
					door.angles= spot.angles;
				}
				if(isDefined(spot.script_parameters))
				{
					door setmodel(spot.script_parameters);
					door thread door_wobble();
				}
				door._team = team;
				door._door_num = doornum;
				doors[doors.size] = door;
				level._race_doors[level._race_doors.size] = door;
			}
		}
		if(level.struct[i].name == (location + "_" + team + "_arrow_" + doornum))
		{
			spot = level.struct[i];
			players = GetLocalPlayers();
			for(x=0;x<players.size;x++)
			{		
				arrow = spawn(x,spot.origin,"script_model");
				if(isDefined(spot.angles))
				{
					arrow.angles= spot.angles;
				}
				if(isDefined(spot.script_parameters))
				{
					arrow setmodel(spot.script_parameters);
				}
				if(isDefined(spot.targetname))
				{
					arrow._start_scroll = 1;
				}
				signs[signs.size] = arrow;
				level._race_arrows[level._race_arrows.size] = arrow;
			}
		}		
			
	}
	
	level thread door_monitor(team,doornum,spots,doors,signs);
}


door_monitor(team,doornum,spots,doors,signs)
{
	level endon("end_race");
	
	while(1)
	{
		
		if(signs.size > 0)
		{
			//enable the signs 
			level thread light_race_arrows(signs);
		}
		
		level waittill(team + "_" + doornum); //first notify deletes the doors 
		wait(.1);		
		for(i=0;i<doors.size;i++)
		{
			if(isDefined(doors[i]))
			{
				ArrayRemoveValue(level._race_doors,doors[i]);
				doors[i] delete();
			}
		}
		doors = [];
		
		if(signs.size > 0)
		{
			level thread blink_race_arrows(signs,team + "_" + doornum);
		}
		
		if(!isDefined(spots))
		{
			continue;
		}
		level waittill(team + "_" + doornum); //second notify respawns the doors 
		wait(.1);
		if(team == "1")
		{
			level._team_1_current_door ++; //increment this for the soul-sucking stuff
		}
		else
		{
			level._team_2_current_door ++;
		}
		for(x=0;x<level.localPlayers.size;x++)
		{	
			for(i =0;i<spots.size;i++)
			{	
				door = spawn(x,spots[i].origin,"script_model");
				if(isDefined(spots[i].angles))
				{
					door.angles= spots[i].angles;
				}
				if(isDefined(spots[i].script_parameters))
				{
					//door setmodel(spots[i].script_parameters);
					door setmodel("pb_couch");
					door thread door_wobble(x);
				}
				door._localClientNum = x;
				doors[doors.size] = door;
				level._race_doors[level._race_doors.size] = door;
				
			}
		}
		if(signs.size > 0)
		{
			level thread dim_race_arrows(signs);				
		}
		break;
	}
		
}

door_wobble(localClientNumber)
{
	level endon("end_race");
	
	og_angles = self.angles;
	og_origin = self.origin;
	
	while(isDefined(self))
	{
		self rotateto(og_angles + (randomfloatrange(-5,5),randomfloatrange(-5,5),randomfloatrange(-5,5)),5,1);
		wait(5);
	}
}

clean_up_doors_and_signs_on_race_end()
{
	level waittill("end_race");
	wait(3);
	
	deleted = 0;
	
	for(i=0;i<level._race_doors.size;i++)
	{
		if(isDefined(level._race_doors[i]))
		{
			if(isDefined(level._race_doors[i]._progress_fx))
			{
				StopFx( level._race_doors[i]._localClientNum, level._race_doors[i]._progress_fx );
			}
			level._race_doors[i] delete();
			deleted++;
		}
	}
		
	for(i=0;i<level._race_arrows.size;i++)
	{
		if(isDefined(level._race_arrows[i]))
		{
			level._race_arrows[i] delete();
			deleted++;
		}
	}
	//iprintlnbold("deleted: " + 	deleted + " entities");
	
	level notify("do_cleanup");
	
}

set_arrow_model(arrows,model)
{
	for(i=0;i<arrows.size;i++)
	{
		arrows[i] setmodel(model);
		if( model == "p6_zm_sign_neon_arrow_on_green" )
		{
			arrows[i] playsound( 0, "zmb_arrow_buzz" );
		}
	}	
}


light_race_arrows(arrows)
{
	set_arrow_model(arrows,"p6_zm_sign_neon_arrow_on_red");
}

dim_race_arrows(arrows)
{
	set_arrow_model(arrows,"p6_zm_sign_neon_arrow_off");
}

blink_race_arrows(arrows,end_on)
{
	level endon("end_race");
	wait(.1);
	
	level endon(end_on);
	
	while(1)
	{
		set_arrow_model(arrows,"p6_zm_sign_neon_arrow_on_green");
		
		wait(randomfloatrange(.1,.25));

		set_arrow_model(arrows,"p6_zm_sign_neon_arrow_off");

		wait(randomfloatrange(.1,.25));	
	}
	
}

zombie_soul_runner(localClientNum, fx_name, dest)
{
	PlayFXOnTag( localClientNum, level._effect[ fx_name ], self, "tag_origin" );
	playsound( 0, "zmb_souls_start", self.origin );
	self playloopsound( "zmb_souls_loop", .75 );
	dist = distance(dest.origin,self.origin);
	time = dist/700;							
	self MoveTo(dest.origin, time);		
	self waittill("movedone");
	
	while(isDefined(dest) && isDefined(dest.target))
	{
		new_dest = getstruct(dest.target,"targetname");	
		dest = new_dest;
		dist = distance(new_dest.origin,self.origin);
		time = dist/700;							
		self MoveTo(new_dest.origin, time);
		self waittill("movedone");
	}
	playsound( 0, "zmb_souls_end", self.origin );
	self Delete();	
}

team_1_zombie_release_soul(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	door = get_closest_team_door("1",self);
	if(!isDefined(door))
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i ++)
	{
		e = spawn(i, self.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		e thread zombie_soul_runner(i, "race_soul_trail", door);			
	}
}	

team_2_zombie_release_soul(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	door = get_closest_team_door("2",self);
	if(!isDefined(door))
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i ++)
	{
		e = spawn(i, self.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		e thread zombie_soul_runner(i, "race_soul_trail", door);			
	}	
}

team_1_zombie_release_grief_soul(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	door = get_closest_team_door("1",self);
	if(!isDefined(door))
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i ++)
	{
		e = spawn(i, self.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		e thread zombie_soul_runner(i, "race_soul_trail_green", door);			
	}
}	

team_2_zombie_release_grief_soul(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	door = get_closest_team_door("2",self);
	if(!isDefined(door))
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i ++)
	{
		e = spawn(i, self.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		e thread zombie_soul_runner(i, "race_soul_trail_green", door);			
	}	
}



get_closest_team_door(team,zombie)
{
	current_door = level._team_1_current_door;
	if(team == "2")
	{
		current_door = level._team_2_current_door;
	}
	potential_doors = [];
	for(i=0;i<level._race_doors.size;i++)
	{
		if(isDefined(level._race_doors[i]) && isDefined(level._race_doors[i]._team) &&( level._race_doors[i]._team == team) && (level._race_doors[i]._door_num == current_door)  )
		{
			potential_doors[potential_doors.size] = level._race_doors[i];
		}
	}
	if(potential_doors.size > 0)
	{
		closest_soul_runner_spot = soul_runner_test(zombie,team);
		if(isDefined(closest_soul_runner_spot))
		{
			return closest_soul_runner_spot;
		}		
		return random(potential_doors);
	}
	return undefined;
}

soul_runner_test(zombie,team)
{
	if(!isDefined(zombie))
	{
		return undefined;
	}
	points = getstructarray("soul_path_" + team,"script_noteworthy");
	if(points.size < 1)
	{
		return undefined;
	}
	org = zombie.origin;

	struct_closest = undefined;
	farthest_dist = 400*400;	
	
	for( i = 0; i < points.size; i++ )
	{
		curr_dist = DistanceSquared( points[i].origin, org );
		if( curr_dist < farthest_dist && (points[i].origin[2] > org[2] ) )
		{
			// save the closest one to the player's parameter
			farthest_dist = curr_dist;
			struct_closest = points[i];
		}
	}

	return struct_closest;
}

setup_animated_signs()
{
	localplayers = getlocalplayers();
	structs = getstructarray("game_mode_object","targetname");	
	for(i=0;i<structs.size;i++)
	{
		if(!isDefined(structs[i]))
		{
			continue;
		}
		if(!isDefined(structs[i].script_noteworthy) || structs[i].script_noteworthy != level._game_mode_location)
		{
			continue;
		}
		if( !structs[i] is_game_mode_object(level._game_mode_mode))
		{
			continue;
		}		
	
		if(isSubstr(structs[i].script_parameters,"sign_encounters"))
		{
			if(level._game_mode_mode == "meat" || level._game_mode_mode == "zmeat" )
			{
				animated_panels = [];
				for(x=0;x<localplayers.size;x++)
				{
					animated_panel = spawn(x,structs[i].origin,"script_model");
					animated_panel.angles = structs[i].angles;
					animated_panel.origin = structs[i].origin;
					animated_panel thread animate_meat_sign();
				}
			}			
		}
	}
	
}

animate_meat_sign(animated_panels)
{	
	//add randomness for sign neon here 
	sign_variant = 1;
	while(1)
	{
		for(i=1;i<5;i++)
		{
			self setmodel ("p6_zm_sign_meat_0"+ sign_variant + "_step" + i );
			wait(randomfloatrange(.75,1.5));
		}
		wait(randomfloatrange(.75,1.5));
	}
}
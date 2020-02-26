#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;


close_doors_behind_players_and_kill_ai(trig,ai_clear_vol,team,room_num)
{
	
	if(isDefined(ai_clear_vol))
	{
		vol = getent(ai_clear_vol,"script_noteworthy");
	}
		
	if(isDefined(trig.target))
	{
		door = getent(trig.target,"targetname");
		while(1)
		{
			all_touching = true;		
			players = GET_PLAYERS();
			for(i=0;i<players.size;i++)
			{
				if(!isDefined(players[i]) || !isDefined(players[i]._race_team))
				{
					continue;
				}			
				if(players[i].sessionstate != "playing" || players[i]._race_team != team  )
				{
					continue;
				}
				if(!players[i] istouching(trig)|| (isDefined(vol) && players[i] istouching(vol))|| players[i] istouching(door) )
				{
					all_touching = false;
				}
			}
	
			if(all_touching) 
			{
				break;
			}
			wait(.05);
		}
		if(isDefined(vol))
		{	
			kill_ai_in_volume(vol);	 //kill any ai left behind
		}
				
		delete_current_team_grief(team);
		
		maps\mp\zombies\_zm_race_doors::race_close_door(door.name);
		level clientnotify("" + team + "_" + (room_num-1));
		if(isDefined(vol))
		{	
			level delay_thread(3,::kill_ai_in_volume,vol);
		}		
	}
}

delete_current_team_grief(team)
{
	
	if(team == 1)
	{
		if(isDefined(	level._team_1_current_grief))
		{
			level._team_1_current_grief notify( "powerup_timedout" );	
			level._team_1_current_grief maps\mp\zombies\_zm_powerups::powerup_delete();
		}
	}
	else
	{
		if(isDefined(	level._team_2_current_grief))
		{
			level._team_2_current_grief notify( "powerup_timedout" );	
			level._team_2_current_grief maps\mp\zombies\_zm_powerups::powerup_delete();
		}
	}	
}

kill_ai_in_volume(volume)
{
	//kill any zombies that are in the old area now
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i]) && ai[i] istouching(volume))
		{
			playfx(level._effect["spawn_cloud"],ai[i].origin);
			ai[i] delete();
		}
	}
}

get_race_zombie_spawn_point(room_num,team,last_room)
{
	
	if(is_true(last_room))
	{
		spawn_points = getstructarray("race_" + level._race_location + "_area_" + room_num + "_" + "team_" + team + "_zombie_spawn");
		return get_spawn_point(spawn_points);
	}
	
	active_areas = level._race_team_2_active_areas;	
	if(team == 1)
	{
		active_areas = level._race_team_1_active_areas;
	}
		
	if(active_areas.size < 1)
	{
		return undefined;
	}
	
	area = random(active_areas);	// TODO: do we want to weight the areas to spawn more zombies in particular areas? 	
	return get_spawn_point(area.spawn_points);
}

get_spawn_point(spawn_points)
{
	spawn_points = array_randomize(spawn_points);
	foreach(point in spawn_points)
	{
		if (!valid_zombie_spawn_point(point) )
		{
			continue;
		}
		return point;
	}
}

valid_zombie_spawn_point(point)
{
	liftedorigin = point.origin + (0,0,5);
	size = 48;
	height = 64;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	// check to see if we would telefrag any players
	if ( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		return false;
	}
	return true;
}

set_race_zombie_run_cycle(round_number)
{
	
	self.zombie_move_speed_original = self.zombie_move_speed;
	self set_race_run_speed(round_number);
	
	self.needs_run_update = true;

	self.deathanim = "zm_death";
}

set_race_run_speed(round_number)
{
	
	zombie_move_speed = round_number * level.zombie_vars["zombie_move_speed_multiplier"];
	rand = randomintrange( zombie_move_speed, zombie_move_speed + 35 ); 
	if( rand <= 35 )
	{
		self.zombie_move_speed = "walk"; 
	}
	else if( rand <= 70 )
	{
		self.zombie_move_speed = "run"; 
	}
	else
	{	
		self.zombie_move_speed = "sprint"; 
	}
}

get_alive_players_on_race_team(team)
{
	players = GET_PLAYERS();	
	players_on_team = [];
	for(i=0;i<players.size;i++)
	{
		if( (!isDefined(players[i]._race_team)) || (players[i]._race_team != team) || (players[i].sessionstate == "spectator") )
		{
			continue;
		}

		players_on_team[players_on_team.size] = players[i];
	}
	return players_on_team;
}

get_players_on_race_team(team)
{
	players = GET_PLAYERS();	
	players_on_team = [];
	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]._race_team) || players[i]._race_team != team )
		{
			continue;
		}

		players_on_team[players_on_team.size] = players[i];
	}
	return players_on_team;
}


get_players_in_laststand(team)
{
	players = GET_PLAYERS();	
	players_in_laststand = [];
	foreach(player in players)
	{
		if( (!isDefined(player._race_team)) || (player._race_team != team) )
		{
			continue;
		}
		if(player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			players_in_laststand[players_in_laststand.size] = player;
		}
		if(isDefined(player._race_team) && player._race_team == team && player.sessionstate == "spectator") //player already finished the race
		{
			players_in_laststand[players_in_laststand.size] = player;
		}
		
	}
	return players_in_laststand;
}

get_race_spawn_rate(team)
{
	team_players = get_players_on_race_team(team);
	
	spawn_rate = 3;
	
	switch(team_players.size )
	{
		case 1: spawn_rate = 3;break;
		case 2: spawn_rate = 2;break;
		case 3: spawn_rate = 1.5;break;
		case 4: spawn_rate = 1;break;
	}
	return spawn_rate;
}

get_race_spawner()
{

	spawner = undefined;
	while(!isDefined(spawner))
	{
		foreach(ent in level.zombie_spawners)
		{
			if(!is_true(ent._spawning))
			{
				spawner = ent;
			}
		}
		wait(.05);		
	}
	return spawner;
}


get_race_zombie_health( round_number )
{
	zombie_health = level.zombie_vars["zombie_health_start"]; 
	for ( i=2; i<=round_number; i++ )
	{
		// After round 10, get exponentially harder
		if( i >= 10 )
		{
			zombie_health += Int( zombie_health * level.zombie_vars["zombie_health_increase_multiplier"] ); 
		}
		else
		{
			zombie_health = Int( zombie_health + level.zombie_vars["zombie_health_increase"] ); 
		}
	}
	return zombie_health;
}

msg_opponents_of_progress(team,room_num)
{	
	
	players = get_players_on_race_team(2);
	other_team_name = get_players_on_race_team(1)[0]._team_name;
	
	if(team == 2)
	{
		players = get_players_on_race_team(1);
		other_team_name = get_players_on_race_team(2)[0]._team_name;
	}
	
	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]))
		{
			continue;
		}	
		players[i] iprintlnbold("The other team has entered area " + room_num);
		wait(.05);
	}
}

kill_all_zombies_when_last_area_opens(door_trig,team,notification)
{
	level endon("end_race");
	
	door = maps\mp\zombies\_zm_race_doors::get_race_door(door_trig);//getent(door_trig.target,"targetname");
			
	door waittill("race_door_opened");
	
	door_num = level._race_team_1_progress+1;
	if(team == 2) //for signage, etc..on the client
	{
		door_num = level._race_team_2_progress+1;
	}
	level clientnotify("" + team + "_" + door_num);
	
	wait(.5);
	
	ai = getentarray("zombie_team_" + team,"targetname");	
	for(i=0;i<ai.size;i++)
	{
		if(isdefined(ai[i]))
		{
			playfx(level._effect["spawn_cloud"],ai[i].origin);
			ai[i] delete();
		}
		wait(.05);
	}
	
	if(isDefined(notification))
	{
		level notify(notification);
	}
	
	level notify("start_finish_fireworks");
	
	if(isDefined(level.insta_kill_powerup_override))
	{
		location = getdvar("ui_zm_mapstartlocation");
		spot = getstruct(location + "_race_instakill_team_" + team,"targetname");
		if(!isDefined(spot))
		{
			return;
		}
		if(!isDefined(level._dropped_powerups))
		{
			level._dropped_powerups = [];
		}
		powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill" , spot.origin);
		if(isDefined(powerup))
		{
			level._dropped_powerups[level._dropped_powerups.size] = powerup;
		}
	}
}

race_active_area_monitor(team)
{
	
	if(team == 1)
	{
		areas = level.team_1_areas;
		level._race_team_1_active_areas = [];
	}
	else
	{
		areas = level.team_2_areas;
		level._race_team_2_active_areas = [];
	}	
	
	level endon("end_race");
	while(1)
	{
		players = get_alive_players_on_race_team(team);
		for(x=0;x<areas.size;x++)
		{
			touching = false;
			for(i=0;i<players.size;i++)
			{	
				if(!isDefined(players[i]))
				{
					continue;
				}	
				if(players[i] istouching(areas[x].area))
				{
					touching = true;
				}
			}
			
			if(touching)
			{
				if(team == 1)
				{
					level._race_team_1_active_areas = add_to_array(level._race_team_1_active_areas,areas[x],false);
				}
				else
				{
					level._race_team_2_active_areas = add_to_array(level._race_team_2_active_areas,areas[x],false);
				}
			}
			else
			{
				if(team == 1)
				{
					ArrayRemoveValue(level._race_team_1_active_areas,areas[x]);
				}
				else
				{
					ArrayRemoveValue(level._race_team_2_active_areas,areas[x]);
				}
			}
		}
		wait(.1);
	}	
}

include_race_powerup(powerup_name)
{
	include_powerup( powerup_name );
	if(!isDefined(level._race_powerups))
	{
		level._race_powerups = [];
	}
	level._race_powerups[level._race_powerups.size] = powerup_name;
}

in_last_area(team) //checks to see if there is a door ahead of us
{
	door_num = level._race_team_1_progress;	
	door_name = undefined;		
	if(team == 1)
	{
		door_name = level._race_door_prefix + "team_" + team + "_door_" + door_num;	
	}
	else if(team == 2)
	{
		door_num = level._race_team_2_progress;	
		door_name = level._race_door_prefix + "team_" + team + "_door_" + door_num;	
	}	
	
	door = maps\mp\zombies\_zm_race_doors::get_race_door(door_name);
	if(!isDefined(door))
	{
		return true;
	}
	return false;

}

delete_magicbox_from_level()
{
	//turn off and delete all the magic boxes in the map
	chests = GetEntArray( "treasure_chest_use", "targetname" );
	for( i=0; i < chests.size; i++ )
	{
		chests[i] maps\mp\zombies\_zm_magicbox::get_chest_pieces();
		chests[i].chest_lid delete();
		chests[i].chest_box delete();		

		if ( IsDefined( chests[i].pandora_light ) )
		{
			chests[i].pandora_light delete();
		}
		chests[i] delete();			
	}		
	
}

wait_for_all_players_finished(finish_trig)
{
	level endon("end_race");
	while(1)
	{
		finish_trig waittill("trigger",who);
		if(isDefined(level._verify_player_finished))
		{
			finished = who [[level._verify_player_finished]]();
			if(!finished)
			{
				continue;
			}
		}
		
		team1_players = get_players_on_race_team(1);
		team2_players = get_players_on_race_team(2);
		team1_finished = true;
		team2_finished = true;

		foreach(player in team1_players)
		{
			if(player istouching(finish_trig) && !is_true(player._finished_race))
			{
				player._finished_race = true;
				if(team1_players.size > 1) //only spectate if more than 1 player on the team
				{
					player thread spawn_race_spectator();
				}
			}			
			if(!is_true(player._finished_race))
			{
				team1_finished = false;					
			}
		}
		if(team1_players.size > 0 && team1_finished)
		{
			return team1_players[0]._encounters_team;
		}		
		foreach(player in team2_players)
		{
			if(player istouching(finish_trig) && !is_true(player._finished_race))
			{
				player._finished_race = true;
				if(team2_players.size > 1)
				{
					player thread spawn_race_spectator();
				}
			}			
			if(!is_true(player._finished_race))
			{
				team2_finished = false;					
			}
		}
		if(team2_players.size > 0 && team2_finished)
		{
			return team2_players[0]._encounters_team;
		}
	}
}

spawn_race_spectator()
{
	
	
	elem = NewClientHudElem(self);

	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 2.5;
	elem.color = ( .7, .7, .7 );        
	elem.alpha = .8;
	elem.label = &"ZOMBIE_RACE_PLAYER_FINISHED";
	wait(.5);
	elem destroy();
	playfx(level._effect["poltergeist"],self.origin);	
	// Stop shellshock and rumble
	self StopShellshock(); 
	self StopRumble( "damage_heavy" ); 
	
	self.sessionstate = "spectator"; 
	self.spectatorclient = -1;
	self.maxhealth = self.health;
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = GetTime(); 
	self.afk = false; 

/#	println( "*************************Zombie Spectator***" );	#/
	self detachAll();
	self allowSpectateTeam( self.team, true );
	self maps\mp\gametypes\_spectating::allowSpectateAllTeamsExceptTeam( self.team , false );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", false );
	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );	
}




grief_init_targets()
{
	
	level._team_1_grief_dmg_trig = getent("race_town_team_1_grief_dmg_trigger","targetname");
	level._team_2_grief_dmg_trig = getent("race_town_team_2_grief_dmg_trigger","targetname");		
	level thread grief_target_logic(1);
	level thread grief_target_logic(2);
}

grief_target_logic(team)
{
	level endon("end_race");
	
	while(1)
	{
		area = level._race_team_1_progress;	
		if(team == 2)
		{
			area = level._race_team_2_progress;	
		}
		name = "race_" + level.scr_zm_map_start_location + "_team_" + team + "_grief_" + area;
		grief_target = grief_setup_target(name);
		if(isDefined(grief_target))
		{
			if(team == 1)
			{
				level._team_1_grief_dmg_trig.origin = grief_target.origin;
			}
			else
			{
				level._team_2_grief_dmg_trig.origin = grief_target.origin;
			}
			grief_target grief_target_update_status("available");
			grief_target thread grief_target_wait_for_damage(team);
		}
		if(team == 1)
		{
			level waittill("team_1_progress");
		}
		else
		{
			level waittill("team_2_progress");
		}
		if(isDefined(grief_target))
		{
			grief_target grief_delete_target();
		}	
	}
}

// self = the grief switch struct
grief_target_wait_for_damage(team)
{
	if(team == 1)
	{
		level endon("team_1_progress");
		trig = level._team_1_grief_dmg_trig;
	}
	else
	{
		level endon("team_2_progress");
		trig = level._team_2_grief_dmg_trig;
	}
	level endon("end_race");
	self thread grief_target_delete_on_race_end(team);
	while(1)
	{
		trig waittill("damage", amount, attacker, dir, point, mod);
		if(!isplayer(attacker))
		{
			continue;
		}
		if(mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH")
		{
			continue;
		}
		if(!isDefined(attacker._race_team) || attacker._race_team == team)
		{
			continue;
		}
		if(is_true(self._is_cooling))
		{
			continue;
		}
		self thread do_grief(team);
		self grief_target_update_status("unavailable");
		self grief_target_cooldown();
		
		//spawn the fake greif
		self.fake_grief = spawn("script_model",self.fake_grief_spawnpoint.origin);
		self.fake_grief setmodel("zombie_ammocan");
		wait_network_frame();
		playfxontag( level._effect["powerup_on_red"],self.fake_grief,"tag_origin");
		
		self._is_cooling = false;
		self grief_target_update_status("available");	
	}	
}

grief_target_delete_on_race_end(team)
{
	if(team == 1)
	{
		level endon("team_1_progress");
	}
	else
	{
		level endon("team_2_progress");
	}
	level waittill("end_race");
	self grief_delete_target();
}

grief_target_cooldown()
{
	self._is_cooling = true;
	wait(30);
}

grief_setup_target(name)
{
	spot = getstruct(name,"targetname");
	if(!isDefined(spot))
	{
		return undefined;
	}
	
	playfx(level._effect["poltergeist"],spot.origin);	
	
	spot.grief_target = spawn("script_model",spot.origin);
	spot.grief_target setmodel(spot.script_string);
	spot.grief_target.angles = spot.angles;
	spot._is_cooling = false;
	
	structs = getstructarray(spot.target,"targetname");
	foreach(struct in structs)
	{
		if( isDefined(struct.script_noteworthy) && struct.script_noteworthy == "drop_point")
		{
			spot.drop_point = struct;
		}
		else
		{
			spot.fake_grief_spawnpoint = struct;
		}
	}
	
	//spawn the fake greif
	spot.fake_grief = spawn("script_model",spot.fake_grief_spawnpoint.origin);
	spot.fake_grief setmodel("zombie_ammocan");
	wait_network_frame();
	playfxontag( level._effect["powerup_on_red"],spot.fake_grief,"tag_origin");
	
	return spot;	
}

grief_delete_target()
{
	if(isDefined(self.grief_target))
	{
		playfx(level._effect["poltergeist"],self.origin);
		self.grief_target delete();
	}
	if(isDefined(self.fake_grief))
	{
		self.fake_grief delete();
	}
}

do_grief(team)
{
	level endon("end_race");
	
	players = get_players_on_race_team(team);
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_grief_incoming", players[0]._encounters_team );
	
	self grief_launch();	
	self grief_drop(team);
	
	other_team = 1;
	area = level._race_team_1_progress;	
	if(team == 1)
	{
		other_team =2;
		area = level._race_team_2_progress;	
	}	
		
	grief = maps\mp\zombies\_zm_powerups::specific_powerup_drop(random(level._race_powerups) , self.drop_point.origin,team,area );
	if(team == 1)
	{
		level._team_1_current_grief = grief;
	}		
	else
	{
		level._team_2_current_grief = grief;
	}
}

grief_target_update_status(status)
{
	
	switch(status)
	{
		case "available":		model = "p6_zm_sign_race_target_on"; break;
		case "unavailable":	model = "p6_zm_sign_race_target"; break;
	}

	if(isDefined(self.grief_target))
	{
		self.grief_target delete();
	}
	self.grief_target = spawn("script_model",self.origin);
	
	self.grief_target.angles = self.angles;
	self.grief_target setmodel (model);	

}

grief_launch()
{
	playfx(level._effect["fw_pre_burst"],self.origin );
	
	PlayFXOnTag( level._effect[ "fw_trail" ], self.fake_grief, "tag_origin" );
	self.fake_grief playloopsound( "zmb_souls_loop", .75 );
	dest_spot = getstruct(self.fake_grief_spawnpoint.target,"targetname");
	dist = distance(dest_spot.origin,self.fake_grief.origin);
	time = dist/800;							
	self.fake_grief MoveTo(dest_spot.origin, time);		
	self.fake_grief waittill("movedone");	
	while(isDefined(dest_spot) && isDefined(dest_spot.target))
	{
		new_dest = getstruct(dest_spot.target,"targetname");	
		dest_spot = new_dest;
		dist = distance(new_dest.origin,self.fake_grief.origin);
		time = dist/700;							
		self.fake_grief MoveTo(new_dest.origin, time);
		self.fake_grief waittill("movedone");
	}
 	self.fake_grief playsound( "zmb_souls_end");
	
	self.fake_grief playsound( "zmb_souls_end");
	playfx(level._effect["fw_burst"],self.fake_grief.origin);

}

grief_drop(team)
{
	dist = distance(self.fake_grief.origin,self.drop_point.origin);
	time = dist/300;	
	self.fake_grief MoveTo(self.drop_point.origin,time);		
	wait_network_frame();
	playfxontag(level._effect["fw_drop"],self.fake_grief,"tag_origin");			
	self.fake_grief waittill("movedone");
	playfx(level._effect["fw_impact"],self.drop_point.origin);
	self.fake_grief delete();
	
	players = get_players_on_race_team(team);
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_grief_land", players[0]._encounters_team, undefined, true );
}

init_race_player_area(trigger_noteworthy,room_num,spawn_point_tgtname,team)
{
	if(!isDefined(level.team_1_areas) || !isDefined(level.team_2_areas))
	{
		level.team_1_areas = [];
		level.team_2_areas = [];
	}

	team_area = spawnstruct();
	team_area.area = getent(trigger_noteworthy,"script_noteworthy");
	if(!isDefined(team_area.area))
	{
		team_area.area = getent(trigger_noteworthy,"targetname");
	}
	team_area._room_num = room_num;	
	team_area.spawn_points = getstructarray(spawn_point_tgtname,"targetname");	
	
	if(team == 1)
	{
		level.team_1_areas[level.team_1_areas.size] = team_area;
	}
	else
	{
		level.team_2_areas[level.team_2_areas.size] = team_area;
	}
}

update_team_chalk(team,room_num)
{
		players = get_players_on_race_team(team);
		for(i=0;i<players.size;i++)
		{
			if(!isDefined(players[i]) || !isDefined(players[i]._race_team))
			{
				continue;
			}		
			players[i] thread race_chalk_one_up(room_num);
		}	
}

race_chalk_one_up(room_num)
{
	if(!isDefined(self.chalk_hud1))
	{
		self.chalk_hud1 = create_race_chalk_hud();
		self.chalk_hud2 = create_race_chalk_hud( 64 );
	}
	level endon("end_race");
	// Hud1 shader
	if( room_num >= 1 && room_num <= 5 )
	{
		self.chalk_hud1 SetShader( "hud_chalk_" + room_num, 64, 64 );
	}
	else if ( room_num >= 5 && room_num <= 10 )
	{
		self.chalk_hud1 SetShader( "hud_chalk_5", 64, 64 );
	}

	// Hud2 shader
	if( room_num > 5 && room_num <= 10 )
	{
		self.chalk_hud2 SetShader( "hud_chalk_" + ( room_num - 5 ), 64, 64 );
	}

	else if( room_num <= 5 )
	{
		self.chalk_hud2 SetText( " " );
	}
	else
	{
		self.chalk_hud1 FadeOverTime( 0.5 );
		self.chalk_hud1.alpha = 0;
		self.chalk_hud2 FadeOverTime( 0.5 );
		self.chalk_hud2.alpha = 0;
		wait( 0.5 );
	}


	self.chalk_hud2 FadeOverTime( 2 );
	self.chalk_hud2.alpha = 1;
	self.chalk_hud1 FadeOverTime( 2 );
	self.chalk_hud1.alpha = 1;



	self.chalk_hud2.color = ( 1, 1, 1 );
	self.chalk_hud1.color = ( 1, 1, 1 );

	wait( 2 ); 

	self.chalk_hud2 FadeOverTime( 1 );
	self.chalk_hud1 FadeOverTime( 1 );
	self.chalk_hud1.color = ( 0.21, 0, 0 );
	self.chalk_hud2.color = ( 0.21, 0, 0 );


}


create_race_chalk_hud( x )
{
	if( !IsDefined( x ) )
	{
		x = 0;
	}

	hud = newclienthudelem(self);
	hud.alignX = "left"; 
	hud.alignY = "bottom";
	hud.horzAlign = "user_left"; 
	hud.vertAlign = "user_bottom";
	hud.color = ( 0.21, 0, 0 );
	hud.x = x; 
	hud.y = -4; 
	hud.alpha = 0;
	hud.fontscale = 4.2; //32.0;

	hud SetShader( "hud_chalk_1", 64, 64 );

	return hud;
}


race_time_remaning_on_insta_kill_powerup(team)
{
	
	level endon("end_race");
	
	temp_enta = spawn("script_origin", (0,0,0));
	temp_enta playloopsound("zmb_insta_kill_loop");	
	
	if(team == 1)
		timer = level.team_1_instakill_timer;
	else
		timer = level.team_2_instakill_timer;
	
	// time it down!
	while ( timer >= 0)
	{
		wait 0.1;
		if(team == 1)
			level.team_1_instakill_timer = level.team_1_instakill_timer - 0.1;
		else
			level.team_2_instakill_timer = level.team_2_instakill_timer - 0.1;
		
		timer = timer - 0.1;
	}
	
	players = GET_PLAYERS();
	for (i = 0; i < players.size; i++)
	{
		players[i] playsound("zmb_insta_kill");
	}
	temp_enta stoploopsound(2);
	temp_enta delete();
}




race_instakill_hud()
{
	if(isDefined(self._race_instakill))
	{
		return;
	}
	self._race_instakill = create_simple_hud(self);
	self._race_instakill.foreground = true; 
	self._race_instakill.sort = 2; 
	self._race_instakill.hidewheninmenu = false; 
	self._race_instakill.alignX = "center"; 
	self._race_instakill.alignY = "bottom";
	self._race_instakill.horzAlign = "user_center"; 
	self._race_instakill.vertAlign = "user_bottom";
	self._race_instakill.x = 62; 
	self._race_instakill.y = - 5; // ww: used to offset by - 78
	self._race_instakill.alpha = 0.8;
		
	self thread race_powerup_hud( "specialty_instakill_zombies", self._race_instakill, 32 );

}


race_powerup_hud( Shader, PowerUp_Hud, X_Position )
{
	self endon("disconnect");

	timer = level.team_1_instakill_timer; 
	if(self._race_team == 2)
	{
		timer = level.team_2_instakill_timer; 
	}	
	
	level endon("end_race");
	while(true)
	{
		if(timer < 1)
		{
			break;
		}
		if(timer < 5)
		{
			wait(0.1);		
			PowerUp_Hud.alpha = 0;
			wait(0.1);
		}
		else if(timer < 10)
		{
			wait(0.2);
			PowerUp_Hud.alpha = 0;
			wait(0.18);

		}

		if( flag("team_" + self._race_team  + "_instakill_on"))
		{
			PowerUp_Hud.x = X_Position;
			PowerUp_Hud.alpha = 0.8;
			PowerUp_Hud setshader(Shader, 32, 32);
		}
		else
		{
			PowerUp_Hud.alpha = 0;
		}
		
		timer = level.team_1_instakill_timer; 
		if(self._race_team == 2)
		{
			timer = level.team_2_instakill_timer; 
		}	
		
		wait( 0.05 );
	}
	if(isDefined(PowerUp_Hud))
	{
		PowerUp_Hud destroy();
	}
}

check_for_instakill_override(player)
{
	if(!isDefined(player._race_team) )
	{
		return false;
	}
	if(flag("team_" + player._race_team + "_instakill_on"))
	{
		return true;
	}	
	return false;	
}

insta_kill_powerup_override(drop_item,player)
{
	level endon("end_race");
	if(isDefined(player._race_team))
	{	
		team = player._race_team;
		level thread race_time_remaning_on_insta_kill_powerup(team);		
		flag_set("team_" + team  + "_instakill_on");
		wait( 30 );
		flag_clear("team_" + team + "_instakill_on");
	}
}


powerup_instakill_hud_override()
{	
	level endon("end_race");
	while(1)
	{	
		if(flag("team_1_instakill_on"))
		{
			players = get_players_on_race_team(1);
			array_thread(players,::race_instakill_hud);
		}
		if(flag("team_2_instakill_on"))
		{
			players = get_players_on_race_team(2);
			array_thread(players,::race_instakill_hud);
		}
		wait(1);
	}
}
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;

/*
	RACE
	Objective: 	Get to the end before your teammates
	Map ends:	When all players are across the finishline
	Respawning:	10 seconds auto-revive , no respawning

*/

/*------------------------------------
registers the race game module
------------------------------------*/
register_game_module()
{
	level.GAME_MODULE_RACE_INDEX = 2;	
	maps\mp\zombies\_zm_game_module::register_game_module(level.GAME_MODULE_RACE_INDEX,"race",::race_pre_init_func,::race_post_init_func,undefined,undefined,::race_default_start_func);
}

/*------------------------------------
runs at the beginning of init() in the _zm.gsc file
------------------------------------*/
race_pre_init_func()
{
	
	if(GetDvar("ui_gametype") == "zrace")
	{
	}
}

/*------------------------------------
set up variables and function pointers
------------------------------------*/
race_init_variables()
{	
	level._should_skip_ignore_player_logic = ::should_skip_ignore_player_logic_func; //used to force zombies to always ignore players on the 'other' team
	level._game_module_game_end_check = ::race_game_end_check_func;  			// don't end the game if all players are in last stand
	level._powerup_timeout_override = ::default_race_powerup_timeout_override;		// make the grief powerups in race only last 1/2 as long as the normal powerups
	level._door_time_delay_func = ::zombie_soul_runner_time_delay;				// delay function for the soul trails
	level.friendlyfire = 0;
	level._game_mode_powerup_zombie_grab = ::race_powerup_grab;
	maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback( ::race_zombie_death_event_callback );
	level.insta_kill_powerup_override = ::insta_kill_powerup_override;	
	level.check_for_instakill_override = ::check_for_instakill_override;
	level._race_team_1_progress = 1;
	level._race_team_2_progress = 1;	
	
	SetMatchTalkFlag( "DeadChatWithDead", 1 );
  SetMatchTalkFlag( "DeadChatWithTeam", 1 );
  SetMatchTalkFlag( "DeadHearTeamLiving", 1 );
  SetMatchTalkFlag( "DeadHearAllLiving", 1 );
  SetMatchTalkFlag( "EveryoneHearsEveryone", 1 );
  
  level._race_team_1_total_zombies_killed = 0;
  level._race_team_2_total_zombies_killed = 0;
  level._race_team_1_total_zombies_added  = 0;
	level._race_team_2_total_zombies_added = 0;
	
	level thread zmbMusicSetupRace();
	level.zombie_vars["zombie_intermission_time"] = 5;		//shortened intermission time
	level._supress_survived_screen = true;		//don't show the "you survived x rounds" screen
	level._zombie_grabbable_poi_distance_override = 5000; //zombies all go to the POI
	  
	level.zombie_spawn_fx = level._effect["spawn_cloud"];
	
	if(!flag_exists("team_1_pause_spawning"))
	{
		flag_init("team_1_pause_spawning");
		flag_init("team_2_pause_spawning");
		flag_init("team_1_pause_score");
		flag_init("team_2_pause_score");
		flag_init("team_1_instakill_on");
		flag_init("team_2_instakill_on");
	}
	level.CONST_LASTSTAND_GETUP_BAR_START				= 0.5;
	level.CONST_LASTSTAND_GETUP_BAR_REGEN				= 0.005;
		
  if(!is_true(level._race_callback_initialized))
  {
  	maps\mp\zombies\_zm::register_player_damage_callback( maps\mp\zombies\_zm_game_module::damage_callback_no_pvp_damage );
  	level._race_callback_initialized = true;
  }
  level.spectateType = 1; //TEAM ONLY - should be moved to gametypesettings file
  flag_clear("team_1_pause_score");
  flag_clear("team_2_pause_score");
  flag_clear("team_1_instakill_on");
  flag_clear("team_2_instakill_on");
  level.team_1_instakill_timer = 30;
  level.team_2_instakill_timer = 30;
}


/*------------------------------------
delete the zone spawner structs and clean up all the unused structs/variables in the level.struct* arrays - buys us back several hundred variables
------------------------------------*/
delete_zone_spawner_structs()
{
	zkeys = GetArrayKeys( level.zones );
	for ( i = 0; i < level.zones.size; i++ )
	{
		zone = level.zones[ zkeys[i] ];
		if ( IsDefined( zone.volumes[0].target ) )
		{
			spots = getstructarray(zone.volumes[0].target, "targetname");
			if(!isDefined(spots) || spots.size < 1)
			{
				continue;
			}
			if(!isDefined(level.struct_class_names[ "targetname" ][ spots[0].targetname ]))
			{
				continue;
			}
			level.struct_class_names[ "targetname" ][ spots[0].targetname ] = undefined;
		}
		wait(.05);
	}
	level thread delete_unused_structs();
}

/*------------------------------------
delete all the unused script structs from other game modes in other areas
------------------------------------*/
delete_unused_structs()
{
	location = getdvar("ui_zm_mapstartlocation");

	for(i=0;i< level.struct_class_names[ "targetname" ][ "game_mode_object" ].size;i++)
	{

		if(!isDefined(level.struct_class_names[ "targetname" ][ "game_mode_object" ][i]))
		{
			continue;
		}
		if(isDefined(level.struct_class_names[ "targetname" ][ "game_mode_object" ][i].script_noteworthy))
		{
			if(level.struct_class_names[ "targetname" ][ "game_mode_object" ][i].script_noteworthy != location)
			{
				level.struct_class_names[ "targetname" ][ "game_mode_object" ][i] = undefined;
			}
			else
			{
				if(isDefined(level.struct_class_names[ "targetname" ][ "game_mode_object" ][i].script_string))
				{
					tokens = strtok(level.struct_class_names[ "targetname" ][ "game_mode_object" ][i].script_string," ");
					delete = true;
					foreach(token in tokens)
					{
						if(token == "race")
						{
							delete= false;
						}
					}
					if(delete)
					{
						level.struct_class_names[ "targetname" ][ "game_mode_object" ][i] = undefined;
					}
				}
			}
		}
	}
	
	// remove script_noteworthy structs that are game mode objects but are not tagged for this location
	keys = getarraykeys(level.struct_class_names[ "script_noteworthy" ]);
	for(i= 0; i < keys.size;i++)
	{
		//not used by the system, ignore this
		if(!isDefined(level.struct_class_names[ "script_noteworthy" ][keys[i]]))
		{
			continue;
		}
		for(x=0;x<level.struct_class_names[ "script_noteworthy" ][keys[i]].size;x++)
		{
			if(!isDefined(level.struct_class_names[ "script_noteworthy" ][keys[i]][x]))
			{
				continue;
			}
			if(isDefined(level.struct_class_names[ "script_noteworthy" ][keys[i]][x].targetname) && level.struct_class_names[ "script_noteworthy" ][keys[i]][x].targetname == "game_mode_object")
			{
				if(isDefined(level.struct_class_names[ "script_noteworthy" ][keys[i]][x].script_noteworthy) && level.struct_class_names[ "script_noteworthy" ][keys[i]][x].script_noteworthy !=location )
				{
					level.struct_class_names[ "script_noteworthy" ][keys[i]][x] = undefined;
				}
			}
		}
	}
	
	for ( i = level.struct.size; i >= 0; i-- )
	{
		level.struct[i] = undefined;
	}
	level.struct = undefined;
}


/*------------------------------------
this causes race to not end because all players are downed or in last stand
------------------------------------*/
race_game_end_check_func()
{	
	return false;
}

/*------------------------------------
forces zombies to ignore their logic of always trying to go after the closest player
for Race, we need them to always be focused on only the players on the same 'team' 
------------------------------------*/
should_skip_ignore_player_logic_func()
{
	return true;
}

/*------------------------------------
clean up afterwards
------------------------------------*/
race_clear_variables()
{
	level._should_skip_ignore_player_logic = undefined;
	level._game_module_game_end_check = undefined;
	level.friendlyfire = 0;
	level._game_mode_powerup_zombie_grab = undefined;
	
	//some variables that are needed to set some global values
	level.round_prestart_func = undefined;
	
	maps\mp\zombies\_zm_spawner::deregister_zombie_death_event_callback( ::race_zombie_death_event_callback );	
	
	SetMatchTalkFlag( "DeadChatWithDead", 0 );
  SetMatchTalkFlag( "DeadChatWithTeam", 0 );
  SetMatchTalkFlag( "DeadHearTeamLiving", 0 );
  SetMatchTalkFlag( "DeadHearAllLiving", 0 );
  SetMatchTalkFlag( "EveryoneHearsEveryone", 0 );
  
  level._race_team_1_total_zombies_killed = 0;
  level._race_team_2_total_zombies_killed = 0;
  level._race_team_1_total_zombies_added  = 0;
	level._race_team_2_total_zombies_added = 0;
}
/*------------------------------------
runs at the end of init() in the _zm.gsc file
------------------------------------*/
race_post_init_func()
{
	if(GetDvar("ui_gametype") != "zrace")
	{
		return;
	}

	level._effect[ "grief_spawn" ]	= Loadfx( "maps/zombie/fx_zombie_dog_lightning_buildup" );
	level._effect["race_marker"]			= Loadfx("maps/zombie/fx_zmb_race_marker");
	level._effect["race_soul_trail"] = loadfx("maps/zombie/fx_zmb_meat_trail_fireworks");
	level._effect["butterflies"] = loadfx("maps/zombie/fx_zmb_impact_noharm");
	level._effect["fw_burst"] = loadfx("maps/zombie/fx_zmb_race_fireworks_burst_center");
	level._effect["fw_impact"] = loadfx("maps/zombie/fx_zmb_race_fireworks_drop_impact");
	level._effect["fw_drop"] = loadfx("maps/zombie/fx_zmb_race_fireworks_drop_trail");
	level._effect["fw_trail"] = loadfx("maps/zombie/fx_zmb_race_fireworks_trail");
	level._effect["race_soul_trail_green"] = loadfx("maps/zombie/fx_zmb_race_fireworks_trail_green");
	level._effect["spawn_cloud"] = loadfx("maps/zombie/fx_zmb_race_zombie_spawn_cloud");
	level._effect["fw_pre_burst"] = loadfx("maps/zombie/fx_zmb_race_fireworks_burst_small");
	
	all_structs = getstructarray("game_mode_object","targetname");
	for(i=0;i<all_structs.size;i++)
	{
		if(isDefined(all_structs[i].script_parameters))
		{				
			precachemodel(all_structs[i].script_parameters);
		}
	}	
	
	precachemodel("pb_couch");
	precachemodel("pb_couch_obj");
	precachemodel("p6_zm_sign_neon_arrow_on_red");
	precachemodel("p6_zm_sign_neon_arrow_on_green");	
	precachemodel("p6_zm_sign_neon_arrow_off");
	precachemodel("p6_zm_barrier_pedestrian_pole");
	precachemodel("p6_zm_sign_race_number_0" );
	precachemodel("p6_zm_sign_race_number_1" );
	precachemodel("p6_zm_sign_race_number_2" );
	precachemodel("p6_zm_sign_race_number_3" );
	precachemodel("p6_zm_sign_race_number_4" );
	precachemodel("p6_zm_sign_race_number_5" );
	precachemodel("p6_zm_sign_race_number_6" );
	precachemodel("p6_zm_sign_race_number_7" );
	precachemodel("p6_zm_sign_race_number_8" );
	precachemodel("p6_zm_sign_race_number_9" );
	precachemodel("p6_zm_sign_race_target");
	precachemodel("p6_zm_sign_race_target_on");
	precacheshellshock("tabun_gas_mp");
	precacheshader("faction_cdc");
	precacheshader("faction_cia");
	
	include_race_powerup( "race_lose_ammo" );	
	maps\mp\zombies\_zm_powerups::add_zombie_powerup( "race_lose_ammo", "zombie_ammocan", &"ZOMBIE_POWERUP_MAX_AMMO",maps\mp\zombies\_zm_powerups::func_should_always_drop, false, false, true );
	
	maps\mp\zombies\_zm_race_doors::init_race_doors();	
}
/*------------------------------------
default start function registered with the system
this grabs the current race from the pool and kicks off the
registered start function as well as some core race stuff
------------------------------------*/
race_default_start_func(race_name) 
{
	race_init_variables();
	
	race = get_registered_race(race_name);
	level thread [[race.race_start_func]](); 
		
	level thread race_main();
	level thread race_active_area_monitor(1);
	level thread race_active_area_monitor(2);
	
	flag_wait("start_encounters_match_logic");
	wait(.1);
	level thread [[race.race_end_func]]();
	level thread wait_for_team_death(1);
	level thread wait_for_team_death(2);
	level thread end_race();
	if(is_true(level.do_final_fireworks))
	{
		level thread race_final_fireworks();
	}
	
	maps\mp\zombies\_zm_weapons::reset_wallbuys();
	
	if(isDefined(level.struct))
	{
		level thread delete_zone_spawner_structs();
	} 
	level maps\mp\zombies\_zm_blockers::open_all_zbarriers();
	
	barriers = getzbarrierarray();
	foreach(barrier in barriers)
	{
		if(isDefined(barrier))
		{
			barrier delete();
		}
	}
	
	level thread delete_magicbox_from_level();
	
}

race_main()
{
	//need this to define the starting health of the zombies
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	
	maps\mp\zombies\_zm_race_doors::spawn_race_doors();	
	
	//delete any griefs that might be lingering around from the last round
	delete_current_team_grief(1);
	delete_current_team_grief(2);
	
	level race_spawn_players(); //spawns the initial teams

	race_init_team_hud(1);
	race_init_team_hud(2);
		
	level thread zmbVox_WaitForLastArea();
	close_all_open_race_doors();
	level thread delete_zombies_when_all_players_in_laststand(); //sends the zombies to the destination door if all players are in last stand
	
	if(!is_true(level.race_objects_setup))
	{
		setup_race_world_objects();
		level.race_objects_setup = true;
	}
	
	update_team_door_hud(1);
	update_team_door_hud(2);
	waittillframeend;
	maps\mp\zombies\_zm_game_module::start_round();
	
	players = GET_PLAYERS();
	foreach(player in players)
	{
		lethal_grenade = player get_player_lethal_grenade();
		player GiveWeapon( lethal_grenade );	
		player SetWeaponAmmoClip( lethal_grenade, 1 );
		player thread race_hud_auto_revive();
	}
	if(isDefined(level.insta_kill_powerup_override))
	{
		level thread powerup_instakill_hud_override();
	}
	
	/#
	level thread debug_ai_counts();
	#/
}

race_hud_auto_revive()
{
	self endon("disconnect");
	
	if(!isDefined(self._auto_revive_hud))
	{
		self._auto_revive_hud = newclienthudelem(self);
		self._auto_revive_hud.alignX = "center";
		self._auto_revive_hud.alignY = "middle";
		self._auto_revive_hud.horzAlign = "center";
		self._auto_revive_hud.vertAlign = "bottom";
		self._auto_revive_hud.y = -113;
		if ( IsSplitScreen() )
		{
			self._auto_revive_hud.y = -107;
		}
		self._auto_revive_hud.foreground = true;
		self._auto_revive_hud.font = "default";
		self._auto_revive_hud.fontScale = 1.8;
		self._auto_revive_hud.alpha = 1;
		self._auto_revive_hud.color = ( 1.0, 1.0, 1.0 );
		self._auto_revive_hud.label = &"ZOMBIE_AUTO_REVIVE_PLAYER";	
	}

	while(1)
	{
		if( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			if(self._auto_revive_hud.alpha == 0)
			{
				self._auto_revive_hud settimer(5);
				self._auto_revive_hud.alpha = .7;
			}
		}
		else
		{
			self._auto_revive_hud.alpha = 0;
		}
		wait(.05);		
	}
}

close_all_open_race_doors()
{
	if(isDefined(level._open_race_doors))
	{
		for(i=0;i<level._open_race_doors.size;i++)
		{
			level._open_race_doors[i] disconnectpaths();
			level._open_race_doors[i] solid();
			level._open_race_doors[i].open = false;
		}
	}
}

race_spawn_players()
{	
	players = GET_PLAYERS();

	random_chance = randomint(100);
//	team_1_spots_assigned = 0;
//	team_2_spots_assigned = 0;	
	
	foreach(player in players)
	{		
		if(flag("switchedsides"))
		{
			player	maps\mp\gametypes\_zm_gametype::onSpawnPlayer();
		}

		if(!IsDefined(level.side_selection))
		{
			if(random_chance > 50)
			{
				level.side_selection = 1;
			}
			else
			{
				level.side_selection = 2;
			}	
		}
			
		if(level.side_selection == 1)
		{
	 		if(player.team == "allies")
	 		{
				player._race_team = 1;
			}
			else
			{
				player._race_team = 2;
			}		
		}	
		else
		{
 			if(player.team == "allies")
 			{
				player._race_team = 2;
			}
			else
			{
				player._race_team = 1;
			}	
		}	
		
			
/*			
		if(player._race_team == 1)
		{
			player setorigin(level._race_team_1_spawn_points[team_1_spots_assigned].origin);
			player setplayerangles (level._race_team_1_spawn_points[team_1_spots_assigned].angles);
			team_1_spots_assigned++;
		}
		else
		{
			player setorigin(level._race_team_2_spawn_points[team_2_spots_assigned].origin);
			player setplayerangles(level._race_team_2_spawn_points[team_2_spots_assigned].angles);
			team_2_spots_assigned++;
		}
*/		
		player.lives = 100;
		player.pers["lives"] = 3;			
		player.pers["zteam"] = player._race_team;
		player.score = 500;
		player.pers["score"] = 500;
		player._finished_race  = false;
		player.ignoreme = false;
		player DisableInvulnerability();
	}
	level.lastStandGetupAllowed = true;	//auto revive
	if(flag("switchedsides"))
	{
		flag_clear("start_encounters_match_logic");
	}

	level.switched = false;
	flag_set("switchedsides");
}

end_race()
{

	level waittill("end_race",winning_team);
	
	//kill players on opposite team
	//level thread kill_opposite_team(winning_team);
	
	level notify("game_module_ended",winning_team);	
	level delay_notify("stop_fireworks",5);
	wait(.05);	
	level notify("race_won");
	level notify("stop_hud_blink");
	
	if(isDefined(level._dropped_powerups))
	{
		foreach(powerup in level._dropped_powerups )
		{
			if(isDefined(powerup))
			{
				powerup notify( "powerup_timedout" );	
				powerup maps\mp\zombies\_zm_powerups::powerup_delete();
			
			}
		}
		level._dropped_powerups = undefined;
	}
	
	level thread maps\mp\zombies\_zm_game_module::kill_all_zombies();
	wait(1.5);

	//destroy the hud
	players = GET_PLAYERS();
	foreach(player in players)
	{
		if(!isDefined(player))
		{
			continue;
		}
		player notify("stop_blink_info");
		
		if(isDefined(player._team_hud["door"]))
		{
			player._team_hud["door"] destroy();	
		}
		if(isDefined(player.chalk_hud1))
		{
			player.chalk_hud1 destroy();
			player.chalk_hud2 destroy();
		}
		if(isDefined(player._race_instakill))
		{
			player._race_instakill destroy();
		}
		
		if(player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			player thread maps\mp\zombies\_zm_laststand::auto_revive( player );
		}
	}	
  
  wait(.1); //gives it time to set the encounters match variables
	if( (level.gamemode_match.team_1_score < level.ZM_roundWinLimit) && (level.gamemode_match.team_2_score < level.ZM_roundWinLimit) ) // somebody won so don't delete the ents ( for the scoreboard )
	{
		level clientnotify("end_race");
		race_clear_variables();
	}	
}


spawn_race_zombie( spawner, target_name,spawn_point,round_number ) 
{ 
	level endon("race_won");
	
	while(is_true(spawner._spawning))
	{
		wait(.05);
	}
	
	spawner._spawning = true;
		
	level.zombie_spawn_locations = [];
	level.zombie_spawn_locations[level.zombie_spawn_locations.size] = spawn_point;
	
	zombie = maps\mp\zombies\_zm_utility::spawn_zombie( spawner, target_name , spawn_point, round_number);	
	zombie Ghost();
	zombie maps\mp\zombies\_zm_spawner::zombie_spawn_init();
	zombie thread maps\mp\zombies\_zm::round_spawn_failsafe();

	spawner._spawning = undefined;
	
	return zombie;

}

race_zombie_spawn_logic(room_num,team,end_on,new_area_trig,zombie_start_round,zombie_end_round,spawn_timer,next_area_door_trig,start_on,ai_clear_vol,last_room,flood_zombies,zombie_speed)
{
	level endon("race_won");
	
	if(is_true(last_room)) 
	{
		level thread kill_all_zombies_when_last_area_opens(next_area_door_trig,team,end_on);
	}
	if(isDefined(end_on))
	{
		level endon(end_on);
	}
	
	if(isDefined(new_area_trig))
	{
		level thread wait_for_players_to_enter_new_area(team,new_area_trig,room_num,ai_clear_vol,start_on,last_room);
	}
	
	if(isDefined(start_on))
	{
		level waittill(start_on);
		waittillframeend; //wait till the frame ends before continuing to give the previous thread a chance to end
	}
	
	level thread setup_current_door_counter(room_num,team);

	flag_waitopen( "pregame" );

	time = gettime();
	zombie_current_round = zombie_start_round;
		
	while(1)
	{
		if( gettime() - time > 30000)
		{
			if(zombie_current_round < zombie_end_round)
			{
				zombie_current_round++;
				time = gettime();
				if(!isDefined(zombie_speed))
				{
					level thread ramp_up_team_zombies(team,zombie_current_round);
				}
			}
		}
		ai = getentarray("zombie_team_" + team,"targetname");		
		max_size = 11;
		if(is_true(level._combine_team_zombies))
		{
			max_size = 23;
		}
		
		/#
		if(getdvarint("zm_encounters_cheat") == 1)
		{
			max_size = 0;
		}
		if(getdvarint("zm_encounters_cheat") > 1)
		{
			max_size = getdvarint("zm_encounters_cheat");
		}
		if(getdvarint("zombie_cheat") == 2)
		{
			max_size = -1;
		}
		#/
			
		if(ai.size > max_size) //only 12 zombies per side at a time for now
		{
			wait(.1);		
			continue;
		}
		
		flag_waitopen("team_" + team + "_pause_spawning");
		
		spawner = get_race_spawner();
		
		spawn_point = get_race_zombie_spawn_point(room_num,team,flood_zombies);
		if(!isDefined(spawn_point))
		{
			wait(.05);
			continue;
		}
		zombie = spawn_race_zombie(spawner,"zombie_team_" + team,spawn_point,zombie_current_round);

		zombie.targetname = "zombie_team_" + team;
		zombie._race_team = team;
 		if(in_last_area(team))
 		{
 			zombie.noDodgeMove = false;
 		}
		zombie thread zombie_set_health_and_ignore_other_team(team,zombie_start_round,zombie_speed);
		
		if(isDefined(spawn_timer))
		{
			wait(spawn_timer);
		}	
		else
		{
			rate = get_race_spawn_rate(team);
			start = gettime();
			while(gettime() < start + (1000 * rate))
			{
				wait(.05);
			}
		}	
	}
}

zombie_set_health_and_ignore_other_team(team,health,zombie_speed)
{
	self endon("death");
	
	while(!isDefined(self.animname))
	{
		wait(.05);
	}
	
	self.maxhealth = get_race_zombie_health(health);
	self.health = get_race_zombie_health(health);
	
	speed = health;
	if(isDefined(zombie_speed))
	{
		speed = zombie_speed;
	}
	if(is_true(level._all_zombies_supersprinters))
	{
		self maps\mp\zombies\_zm_game_module::make_supersprinter();
	}
	else
	{
		self set_race_zombie_run_cycle(speed); 
	}
	if(is_true(level._combine_team_zombies)) //don't ignore teams if all the zombies are combined onto one team/area
	{
		self show();
		return;
	}
	
	while(!isDefined(self.ignore_player))
	{
		wait(.1);
	}	
	self.ignore_player = [];
	other_team = 2;
	if(team == 2)
	{
		other_team = 1;
	}
	
	other_players = get_players_on_race_team(other_team);
	for(i=0;i<other_players.size;i++)
	{
		self.ignore_player[self.ignore_player.size] = other_players[i];
	}
	self show();
	
}

ramp_up_team_zombies(team,zombie_current_round)
{
	players = get_players_on_race_team(team);
	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]))
		{
			continue;
		}	
		players[i] playsound("aml_dog_bark");
		earthquake(0.3,2,players[i].origin,200);
		wait(.05);
	}
	
	zombies = getentarray("zombie_team_" + team,"targetname");
	for(i=0;i<zombies.size;i++)
	{
		if(isDefined(zombies[i]) && isAlive(zombies[i]))
		{
			//zombies[i].maxhealth = get_race_zombie_health(zombie_current_round);
			//zombies[i].health = get_race_zombie_health(zombie_current_round); 	
			zombies[i] set_race_zombie_run_cycle(zombie_current_round); 
		}
		wait(.1);
	}	
}

/*
waits for the players to enter a newly opened area 
*/
wait_for_players_to_enter_new_area(team,new_area_trig,room_num,ai_clear_vol,str_notify,last_room)
{
	trig = getent(new_area_trig,"script_noteworthy");		
	if(isDefined(ai_clear_vol))
	{
		vol = getent(ai_clear_vol,"script_noteworthy");
	}
	level endon("race_won");
		
	while(1)
	{
		
		trig waittill("trigger");
		
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
			if(!players[i] istouching(trig)|| (isDefined(vol) && players[i] istouching(vol)))
			{
				all_touching = false;
			}
		}

		if(all_touching) 			//do the check a second time
		{
			wait(.5);
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
				if(!players[i] istouching(trig)||(isDefined(vol) && players[i] istouching(vol)) )
				{
					all_touching = false;
				}				
			}	
			wait(.05);
			
			if(all_touching)
			{
				break;
			}	
		}	
	}
	
	if(!is_true(level._all_doors_open ))
	{
		close_doors_behind_players_and_kill_ai(trig,ai_clear_vol,team,room_num);
	}
	level notify(str_notify);
	
	level thread msg_opponents_of_progress(team,room_num);
	
	if(team == 1)
	{
		level._race_team_1_progress = room_num;
		level notify("team_1_progress");
		update_team_chalk(team,level._race_team_1_progress);
		level._race_team_1_total_zombies_killed = 0;
	}
	else if(team == 2)
	{
		level._race_team_2_progress = room_num;
		level notify("team_2_progress");
		update_team_chalk(team,level._race_team_2_progress);
		level._race_team_2_total_zombies_killed = 0;
	}
	
	level thread announceTeamProgression( team, room_num, last_room );
	
	update_team_door_hud(team);
	level thread set_score_flag(team);
}

set_score_flag(team)
{
	wait(1);
	if(team == 1)				//to prevent edge case where an grenade can be timed to blow at exactly the same time that the door shuts, and counts kills towards the next area when it shouldn't
	{
		flag_clear("team_1_pause_score");
	}
	else
	{
		flag_clear("team_2_pause_score");
	}	
}
announceTeamProgression( team_num, room_num, last_room )
{
	players = get_players_on_race_team(team_num);
	team = players[0]._encounters_team;
	otherTeam = maps\mp\zombies\_zm_audio_announcer::getOtherTeam( team );
	progress = getTeamsProgress( team_num );
	ahead = isTeamAhead( team_num );
	
	if( level in_last_area(team_num) )
	{
		level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_5_ally", team );
		level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_5_axis", otherTeam );
	}
	else
	{
		if( ahead )
		{
			if( cointoss() )
			{
				level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_ahead_" + progress + "_ally", team );
				level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_ahead_" + progress + "_axis", otherTeam );
			}
			else
			{
				level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_" + room_num + "_ally", team );
				level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_" + room_num + "_axis", otherTeam );
			}
		}
		else
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_" + room_num + "_ally", team );
			level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_room_" + room_num + "_axis", otherTeam );
		}
	}
}
getTeamsProgress( team_num )
{
	num = abs( level._race_team_1_progress - level._race_team_2_progress );
	return num;
}
isTeamAhead( team_num )
{
	if( team_num == 1 )
	{
		if( level._race_team_1_progress > level._race_team_2_progress )
			return true;
		else
			return false;
	}
	
	if( team_num == 2 )
	{
		if( level._race_team_2_progress > level._race_team_1_progress )
			return true;
		else
			return false;
	}
}

wait_for_team_death(team)
{
	
	finish_trig = getent("race_finish","script_noteworthy");
	
	level endon("end_race");
	level endon("race_won");

	alive_team_players = get_alive_players_on_race_team(team);
	if(alive_team_players.size < 1)
	{
		return;
	}
	
	while(1)
	{
		wait 1;
		alive_team_players = get_alive_players_on_race_team(team);
		if(alive_team_players.size > 0)
		{
			continue;
		}
		break;
	}
	if(team == 1)
	{
		team_players = get_players_on_race_team(2);
	}
	else if( team == 2)
	{
		team_players = get_players_on_race_team(1);
	}
	if(!isDefined(team_players[0]))
	{
		return;
	}
	finish_trig notify("trigger",team_players[0]);
}


race_init_team_hud(team)
{
	team_players = get_players_on_race_team(team);
	for(i=0;i<team_players.size;i++)
	{
		team_players[i] race_hud_create_door_info();
		team_players[i] thread race_chalk_one_up(1);
	}
}

register_race(race_start_func,race_end_func,race_name,race_location)
{
	
	if(!isDefined(level._registered_races))
	{
		level._registered_races = [];
	}
	
	race = spawnstruct();
	race.race_name = race_name;
	race.race_start_func = race_start_func;
	race.race_end_func = race_end_func;
	race.race_location = race_location;
	race.mode_name = "zrace";
	level._registered_races[level._registered_races.size] = race;
	
}

get_registered_race(race_name,location)
{
	for(i=0;i<level._registered_races.size;i++)
	{
		if(isDefined(race_name))
		{
			if(level._registered_races[i].race_name == race_name)
			{
				return level._registered_races[i];
			}
		}
		if(isDefined(location))
		{
			if(level._registered_races[i].race_location == location)
			{
				return level._registered_races[i];
			}
		}
	}
}

race_zombie_death_event_callback()
{
	if(isDefined(level._override_race_death_callback))
	{
		level thread [[level._override_race_death_callback]](self);
		return;
	}
	level thread do_zombie_death_callback(self);
}

/*------------------------------------
Handles zombies death functionality for Race
------------------------------------*/
do_zombie_death_callback(zombie)
{
	//zombie isn't defined or somehow has his team undefined
	if( !isDefined(zombie) || !isDefined(zombie._race_team) )
	{
		return;
	}
	if(is_true(level._all_doors_open))
	{
		return;
	}
	attacker_team = zombie.attacker._race_team;
	zombie_team = zombie._race_team;
	attacker = zombie.attacker;
	
	if(isDefined(attacker) && isPlayer(attacker) ) //zombie was killed by a player
	{
		if(attacker_team == zombie_team) //killed by player on same team
		{			
			if(attacker_team == 1)
			{
				if(level._race_doors[level._race_location].size > 1)   //only do the soul trail if there is a door ( Tunnel has no "doors" , for example)
				{
					zombie setclientflag(level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_1);
				}				
				
				if(isDefined(level._door_time_delay_func)) //this syncronizes the client soul trail effect with server functionality
				{
					[[level._door_time_delay_func]](zombie,1);
				}
				if(!flag("team_1_pause_score"))
				{
					level._race_team_1_total_zombies_killed ++;				
				}
				update_team_door_hud(attacker_team); //update the kill counter after the soul trail has completed
			}
			else if(attacker_team == 2)
			{
				if(level._race_doors[level._race_location].size > 1)
				{
						zombie setclientflag(level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_2);
				}		
				if(isDefined(level._door_time_delay_func))
				{
					[[level._door_time_delay_func]](zombie,2);
				}
				if(!flag("team_2_pause_score"))
				{
					level._race_team_2_total_zombies_killed ++;
				}
				update_team_door_hud(attacker_team);
			}			
		}
		else //zombie was killed by a player on the other team . Add kills to the door
		{
			if(attacker_team == 1)
			{
				if(level._race_doors[level._race_location].size > 1)
				{
					zombie setclientflag(level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_2);
				}				
				
				if(isDefined(level._door_time_delay_func))
				{
					[[level._door_time_delay_func]](zombie,2);
				}
				level._race_team_2_total_zombies_added++;
				update_team_door_hud(zombie_team);
			}
			else if(attacker_team == 2)
			{
				if(level._race_doors[level._race_location].size > 1)
				{
						zombie setclientflag(level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_1);
				}		
				if(isDefined(level._door_time_delay_func))
				{
					[[level._door_time_delay_func]](zombie,1);
				}
				level._race_team_1_total_zombies_added++;
				update_team_door_hud(zombie_team);
			}			
		}
	}
}

/*------------------------------------  
determines the number of zombies left to kill
------------------------------------*/
calculate_max_zombies_to_kill(team)
{
	players = get_players_on_race_team(team);
	zombies = players.size * 3;
	if(players.size == 1)
	{
		zombies = 5;
	}
	
	max_zombies= 0;
	if(team == 1)
	{
		max_zombies = zombies + level._race_team_1_total_zombies_added;
	}
	else if(team == 2)
	{
		max_zombies = zombies + level._race_team_2_total_zombies_added;
	}
	if(is_true(level._all_doors_open))
	{
		return 0;
	}	
	return max_zombies;
}

/*------------------------------------
this creates the display that shows the number of remaining zombies 
------------------------------------*/
race_hud_create_door_info(text,blink)
{
	if(!isDefined(level._race_doors[level._race_location]))
	{
		return;
	}
	if(!isDefined(self._team_hud))
	{
		self._team_hud = [];
	}
	if(isDefined(self._team_hud["door"]))
	{
		self notify("stop_blink_info");
		self._team_hud["door"] destroy();
	}
	elem = NewClientHudElem(self);
	elem.hidewheninmenu = true;
	elem.horzAlign = "left";
	elem.vertAlign = "bottom";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 60;
	elem.y = -10;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 2.5;
	elem.color = ( .9, .9, 0 );        
	elem.alpha = 0;
	if(isDefined(text))
	{
		elem.label = text;
	}
	else
	{
		elem.label = &"ZOMBIE_RACE_ZOMBIES_LEFT ^1";
	}
	elem.baseFontScale = elem.fontScale;
	elem.maxFontScale = elem.fontScale * 3;
	elem.inFrames = 2;
	elem.outFrames = 4;	
		
	self._team_hud["door"] = elem;
	if(is_true(blink))
	{
		self notify("stop_blink_info");
		//self thread blink_door_info();
	}
}

blink_door_info()
{
	self endon("stop_blink_info");
	level endon("stop_hud_blink");
	
	while(isDefined(self._team_hud) && isDefined(self._team_hud["door"]))
	{
		self._team_hud["door"].alpha = 0;
		self._team_hud["door"] fadeovertime(.45);
		wait(.5);
		self._team_hud["door"].alpha = 1;
		self._team_hud["door"] fadeovertime(.45);
		wait(.5);
	}
}

/*------------------------------------
handles updating the hud showing the remaining zombies or that the next area is open
------------------------------------*/
update_team_door_hud(team)
{
	if(!isDefined(level._race_doors[level._race_location]))
	{
		return;
	}
	max_zombies = calculate_max_zombies_to_kill(team);	
	zombies_killed = level._race_team_1_total_zombies_killed;
	players = get_players_on_race_team(team);	
	if( players.size < 1)
	{
		return;
	}
	if(!isDefined(players[0]._team_hud) || !isDefined(players[0]._team_hud["door"] ))
	{
		return;
	}
	
	if(team == 2)
	{
		zombies_killed = level._race_team_2_total_zombies_killed;
	}
	
	if(in_last_area(team) ) 
	{
		for(i=0;i<players.size;i++)
		{
			players[i] thread race_hud_create_door_info(&"ZOMBIE_RACE_GET_TO_FINISH",true);
	
		}
		return;
	}	
	
	if( (max_zombies - zombies_killed) < 1)
	{
		for(i=0;i<players.size;i++)
		{
			players[i] thread race_hud_create_door_info(&"ZOMBIE_RACE_DOOR_IS_OPEN",true);
		}
		
		if( isdefined( players[0] ) && isdefined( players[0]._encounters_team ) )
		{
			level thread announceDoorOpen( players[0]._encounters_team, team );
		}
		open_next_area_door(team);
		
		if(team == 1)
		{
			door_num = level._race_team_1_progress;	
		}
		else
		{
			door_num = level._race_team_2_progress;	
		}

		door = maps\mp\zombies\_zm_race_doors::get_race_door(level._race_door_prefix + "team_" + team + "_door_" + door_num);
		if(is_true(door.open))
		{
			level thread set_door_counter(team,0);
		}
		return;
	}
		
	for(i=0;i<players.size;i++)
	{
		players[i] notify("stop_blink_info");
		//players[i]._team_hud["door"].alpha = .7;
		players[i]._team_hud["door"].label = &"ZOMBIE_RACE_ZOMBIES_LEFT";
		players[i]._team_hud["door"] SetValue(max_zombies - zombies_killed);
		players[i]._team_hud["door"] maps\mp\gametypes\_hud::fontPulse(players[i]);
	}

	//make sure the door never shows the number if it's "open" 
	if(team == 1)
	{
		door_num = level._race_team_1_progress;	
	}
	else
	{
		door_num = level._race_team_2_progress;	
	}
	door = maps\mp\zombies\_zm_race_doors::get_race_door(level._race_door_prefix + "team_" + team + "_door_" + door_num);
	if(is_true(door.open))
	{
		level thread set_door_counter(team,0);
	}
	else
	{
		level thread set_door_counter(team,(max_zombies-zombies_killed));
	}
}
announceDoorOpen( team, team_num )
{
	if( !isdefined( level.door_nag_active ) )
		level.door_nag_active = false;
	
	if( level.door_nag_active )
		return;
	
	level.door_nag_active = true;
	
	level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "good", team );
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_door_open", team );
			
	if( team_num == 1 )
		end_notify = "team_1_progress";
	else
		end_notify = "team_2_progress";
			
	level thread announceDoorNagLine( team, end_notify );
	
	level waittill( end_notify );
	
	level.door_nag_active = false;
}
announceDoorNagLine( team, end_notify )
{
	level endon( end_notify );
	
	while(1)
	{
		wait(15);
		level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "race_door_nag", team );
	}
}

open_next_area_door(team)
{
	door_num = level._race_team_1_progress;			
	if(team == 1)
	{
		door_name = level._race_door_prefix + "team_" + team + "_door_" + door_num;	
		door = maps\mp\zombies\_zm_race_doors::get_race_door(door_name);
		if(!isDefined(door))
		{
			return;
		}
		if(!is_true(door.open))
		{
			level._race_team_1_total_zombies_added = 0;
		}
		flag_set("team_1_pause_score");
	}
	else if(team == 2)
	{
		door_num = level._race_team_2_progress;	
		door_name = level._race_door_prefix + "team_" + team + "_door_" + door_num;	
			
		door = maps\mp\zombies\_zm_race_doors::get_race_door(door_name);
		if(!isDefined(door))
		{
			return;
		}		
		if(!is_true(door.open))
		{
			level._race_team_2_total_zombies_added = 0;
		}
		flag_set("team_2_pause_score");
	}	
	
	maps\mp\zombies\_zm_race_doors::race_open_door(door_name,team,door_num);
}


setup_race_world_objects()
{
	objects = getentarray(level._race_location,"script_noteworthy"); 
	
	for(i=0;i<objects.size;i++)
	{
		if(!objects[i] is_race_object() )
		{
			continue;
		}
		
		if ( IsDefined( objects[ i ].script_gameobjectname ) )
		{
			continue;
		}
		
		if(isDefined(objects[i].script_vector))
		{
			objects[i] moveto(objects[i].origin + objects[i].script_vector,.05);
			objects[i]  waittill("movedone");
		}
		if(isDefined(objects[i].spawnflags) && objects[i].spawnflags == 1)
		{
			objects[i] disconnectpaths();
		}	
	}
	
	level clientnotify("race_" + level._race_location);	
}

hide_non_race_objects()
{
	
	//turn off door buys
	door_trigs = getentarray("zombie_door","targetname");
	for(i=0;i<door_trigs.size;i++)
	{
		door_trigs[i] trigger_off();
	}	
	
	objects = getentarray(); 
	foreach(object in objects)
	{
		if(object is_race_object() )
		{
			continue;
		}		
	
		if(isDefined(object.spawnflags) && object.spawnflags == 1)
		{
			object connectpaths();
		}
		object notsolid();
		object hide();
	}
}

is_race_object()
{

	if(!isDefined(self.script_parameters) )
	{
		return true;
	}
	tokens = strtok(self.script_parameters," ");
	foreach(token in tokens)
	{
		if(token == "race_remove")
		{
			return false;
		}
	}
	return true;
}

// powerup stuff
//self = the powerup itself
race_powerup_grab(powerup,zombie)
{
	switch(powerup.powerup_name)
	{
		case "race_lose_ammo":
			level thread race_powerup_lose_ammo(zombie);
			break;
	}	
}

race_powerup_lose_ammo(zombie,pteam)
{
	
	team = undefined;
	if(isDefined(zombie))
	{
		team = zombie._race_team;
		Earthquake( 0.5, 0.75, zombie.origin, 1000);
	}
	if(isDefined(pteam))
	{
		team = pteam;
	}
			
	players = get_players_on_race_team(team);
	foreach(player in players)
	{
		if(!isDefined(player))
		{
			continue;
		}
		if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
		{
			weapon = player GetCurrentWeapon();
			player SetWeaponAmmoStock( weapon, 0 );
			player SetWeaponAmmoClip( weapon, 0 );			
			Playfx( level._effect["poltergeist"], player.origin );
			player playlocalsound("zmb_laugh_child" );	
			wait(.1);
		}
	}
}

zmbVox_WaitForLastArea()
{
	last_leader = undefined;
	
	while(1)
	{
		if( level in_last_area(1) || level in_last_area(2) )
		{
			break;
		}
		
		if( level._race_team_1_progress > level._race_team_2_progress )
		{
			if( !isdefined( last_leader ) || last_leader != 1 )
			{
				last_leader = 1;
				players = get_players_on_race_team(1);
				team = players[0]._encounters_team;
				level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "clap", team, "bad" );
			}
		}
		else if( level._race_team_2_progress > level._race_team_1_progress )
		{
			if( !isdefined( last_leader ) || last_leader != 2 )
			{
				last_leader = 2;
				players = get_players_on_race_team(2);
				team = players[0]._encounters_team;
				level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "clap", team, "bad" );
			}
		}
		
		wait(.1);
	}
	
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "final_stretch" );
	level thread zmbVoxCrowd_finalstretch();
}

zmbMusicSetupRace()
{
	level.zmb_music_states["game_over"] = undefined;
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "waiting", "ENC_WAITING", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "round_start", "ENC_ROUND_START", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "round_end", "ENC_ROUND_END", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "final_stretch", "ENC_FINAL_STRETCH", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "halftime", "ENC_HALFTIME", false, false, false, undefined );
	level thread maps\mp\zombies\_zm_audio::setupMusicState( "match_over", "ENC_MATCH_OVER", false, false, false, undefined );
}
zmbVoxCrowd_finalstretch()
{
	ent = spawn( "script_origin", (0,0,0) );
	ent playloopsound( "vox_crowd_finalstretch_loop", 4 );
	level waittill("end_race");
	ent stoploopsound( 1 );
	wait(1);
	ent delete();
}

zombie_door_kill_highlight( value )
{
	self endon( "disconnect" ); 

	// Location from hud.menu
	score_x = 103;
	score_y = -140;

	x = score_x;
	y = score_y;

	time = 0.5; 
	half_time = time * 0.5; 

	hud = self maps\mp\zombies\_zm_score::create_highlight_hud( x, y, value ); 

	// Move the hud
	hud MoveOverTime( time ); 
	hud.x -= 20 + RandomInt( 40 ); 
	hud.y -= ( -15 + RandomInt( 30 ) ); 

	wait( half_time ); 

	// Fade half-way through the move
	hud FadeOverTime( half_time ); 
	hud.alpha = 0; 

	wait( half_time ); 

	hud Destroy(); 

}

setup_current_door_counter(room_num,team)
{
	number_1_struct = getstruct(level._race_door_prefix + "team_" + team + "_door_" + room_num + "_number_1","targetname");	
	number_2_struct = getstruct(level._race_door_prefix + "team_" + team + "_door_" + room_num + "_number_2","targetname");	
	if(!isDefined(number_1_struct))
	{
		return;
	}
		
	if(team == 1)
	{
		if(!isDefined(level._team_1_current_door_number_1))
		{
			level._team_1_current_door_number_1 = spawn("script_model",(0,0,0));
			level._team_1_current_door_number_2 = spawn("script_model",(0,0,0));
		}
		
		
		level._team_1_current_door_number_1.origin = number_1_struct.origin;
		level._team_1_current_door_number_2.origin = number_2_struct.origin;
		level._team_1_current_door_number_1.angles = number_1_struct.angles;
		level._team_1_current_door_number_2.angles = number_2_struct.angles;
	}
	else
	{
		if(!isDefined(level._team_2_current_door_number_1))
		{
			level._team_2_current_door_number_1 = spawn("script_model",(0,0,0));
			level._team_2_current_door_number_2 = spawn("script_model",(0,0,0));
		}		
		
		level._team_2_current_door_number_1.origin = number_1_struct.origin;
		level._team_2_current_door_number_2.origin = number_2_struct.origin;
		level._team_2_current_door_number_1.angles = number_1_struct.angles;
		level._team_2_current_door_number_2.angles = number_2_struct.angles;
	}		
}

set_door_counter(team,number)
{
	num_string = "" + number;
	numbers = get_number_string_array(num_string);

	if(team == 1)
	{
		if(number < 1)
		{
			level._team_1_current_door_number_1 hide();
			level._team_1_current_door_number_2 hide();	
			if(isDefined(level._team_1_current_door_progress_fx_model ))
			{
				level._team_1_current_door_progress_fx_model delete();
			}
			return;	
		}
		else
		{
			level._team_1_current_door_number_1 show();
			level._team_1_current_door_number_2 show();
			if(!isDefined(level._team_1_current_door_progress_fx_model ))
			{
				level thread create_door_progress_marker(1);
			}
			
		}
		level._team_1_current_door_number_1 set_door_counter_model(numbers[0]);
		level._team_1_current_door_number_2 set_door_counter_model(numbers[1]);
	}
	else
	{
		if(number < 1)
		{
			level._team_2_current_door_number_1 hide();
			level._team_2_current_door_number_2 hide();
			if(isDefined(level._team_2_current_door_progress_fx_model ))
			{
				level._team_2_current_door_progress_fx_model delete();
			}
			return;		
		}
		else
		{
			level._team_2_current_door_number_1 show();
			level._team_2_current_door_number_2 show();
			if(!isDefined(level._team_2_current_door_progress_fx_model ))
			{
				level thread create_door_progress_marker(2);
			}
		}
		
		level._team_2_current_door_number_1 set_door_counter_model(numbers[0]); 
		level._team_2_current_door_number_2 set_door_counter_model(numbers[1]); 
	}
	
}

create_door_progress_marker(team)
{
	if(team == 1)
	{
		level._team_1_current_door_progress_fx_model = spawn("script_model",level._team_1_current_door_number_1.origin);
		level._team_1_current_door_progress_fx_model setmodel("tag_origin");
		wait(.2);
		playfxontag(level._effect["race_marker"],level._team_1_current_door_progress_fx_model,"tag_origin");
	}
	else
	{
		level._team_2_current_door_progress_fx_model = spawn("script_model",level._team_2_current_door_number_1.origin);
		level._team_2_current_door_progress_fx_model setmodel("tag_origin");
		wait(.2);
		playfxontag(level._effect["race_marker"],level._team_2_current_door_progress_fx_model,"tag_origin");
	}
}

get_number_string_array(num_string)
{
	num_array = [];
	if(num_string.size > 1) // double digits
	{
		num_array[0] = num_string[0];
		num_array[1] = num_string[1];
		
	}
	else
	{
		num_array[0] = "0";
		num_array[1] = num_string[0];
	}
	return num_array;
}

set_door_counter_model(num)
{
	self setmodel(get_door_model(num));
}

get_door_model(num)
{
	return "p6_zm_sign_race_number_" + num;
}

default_race_powerup_timeout_override()
{
	
	if(!isDefined(self.team))
	{
		return;
	}
	
	self endon( "powerup_grabbed" );
	self endon( "death" );
	
	wait 10;
	
	for ( i = 0; i < 25; i++ )
	{
		// hide and show
		if ( i % 2 )
		{
			self ghost();
			if ( isdefined( self.worldgundw ) )
			{
				self.worldgundw ghost();
			}
		}
		else
		{
			self show();
			if ( isdefined( self.worldgundw ) )
			{
				self.worldgundw show();
			}
		}

		if ( i < 5 )
		{
			wait( 0.5 );
		}
		else if ( i < 15 )
		{
			wait( 0.25 );
		}
		else
		{
			wait( 0.1 );
		}
	}
	if(!isDefined(self))
	{
		return;
	}
	self notify( "powerup_timedout" );	
	self maps\mp\zombies\_zm_powerups::powerup_delete();
}

delete_zombies_when_all_players_in_laststand()
{
	level endon("end_race");
	
	while(1)
	{
		
		if(is_true(level._combine_team_zombies)) // for modes like Race in the tunnel where there are no doors or areas and the teams are combined in one area, so send them to this spot
		{
			if( get_players_on_race_team(1).size == get_players_in_laststand(1).size && get_players_on_race_team(2).size == get_players_in_laststand(2).size )
			{
				if(!flag("team_1_pause_spawning"))
				{
					flag_set("team_1_pause_spawning");
				}
				level thread delete_team_zombies(1);
			}
			else
			{
				if(flag("team_1_pause_spawning"))
				{
					flag_clear("team_1_pause_spawning");
				}		
			}
			wait(.2);
			continue;
		}
		else
		{
			if( get_players_on_race_team(1).size == get_players_in_laststand(1).size ) // all players on the team are in laststand
			{
				if(!flag("team_1_pause_spawning"))
				{
					flag_set("team_1_pause_spawning");
				}
				level thread delete_team_zombies(1);
			}
			else
			{
				if(flag("team_1_pause_spawning"))
				{
					flag_clear("team_1_pause_spawning");
				}
			}
			if( get_players_on_race_team(2).size == get_players_in_laststand(2).size ) // all players on the team are in laststand
			{
	
				if(!flag("team_2_pause_spawning"))
				{
					flag_set("team_2_pause_spawning");
				}
				level thread delete_team_zombies(2);
			}
			else
			{
				if(flag("team_2_pause_spawning"))
				{
					flag_clear("team_2_pause_spawning");
				}
			}
		}
		wait(.2);	
	}
}

delete_team_zombies(team)
{
	zombies = getaiarray("axis");
	foreach(zombie in zombies)
	{
		if(isDefined(zombie) && isDefined(zombie._race_team) && zombie._race_team == team)
		{
			playfx(level._effect["spawn_cloud"],zombie.origin);
			zombie delete();
			wait(.05);
		}
	}
}

zombie_soul_runner_time_delay(zombie,team )
{
	org = zombie.origin;
	
	dest = zombie_soul_runner_time_delay_get_point(zombie,team);
	total_time = 0;
	if(!isDefined(dest))
	{
		wait(1); //generic wait 
		return;
	}
	dist = distance(dest.origin,org);
	time = dist/700;							
	total_time += time;
	
	while(isDefined(dest) && isDefined(dest.target))
	{
		new_dest = getstruct(dest.target,"targetname");
		dist = distance(new_dest.origin,dest.origin);
		time = dist/700;							
		total_time += time;
		dest = new_dest;
	}
	wait total_time;
		
}

zombie_soul_runner_time_delay_get_point(zombie,team)
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
	
	foreach(point in points )
	{
		curr_dist = DistanceSquared( point.origin, org );
		if( curr_dist < farthest_dist && (abs(point.origin[2] - org[2]) < 100 ))
		{
			// save the closest one to the player's parameter
			farthest_dist = curr_dist;
			struct_closest = point;
		}
	}
	return struct_closest;
}


//ai debug functions
/#
debug_ai_counts()
{
	level endon("end_race");
	
	if(!isDefined(level.hud_team1_aicount))
	{
		level.hud_team1_aicount = race_debug_hudelem( "Team 1 AI Count: 0" , 10,20 ); 
		level.hud_team2_aicount  = race_debug_hudelem( "Team 2 AI Count: 0" , 10,40 ); 
	}
	while(1)
	{
		team_1_ai = getentarray("zombie_team_1","targetname");	
		team_2_ai = getentarray("zombie_team_2","targetname");
	
		level.hud_team1_aicount settext("Team 1 AI Count: " + team_1_ai.size);
		level.hud_team2_aicount settext("Team 2 AI Count: " + team_2_ai.size); 
		wait(.25);                   
	}	
}
   
race_debug_hudelem( text, x, y)        
{                                                                   
                                                                
		hud = NewHudElem();                                  
                                      
		hud.alignX = "left";                                            
		hud.alignY = "middle";                                          
		hud.foreground = 1;                                             
		hud.fontScale = 1;                                          
		hud.sort = 20;                                                
		hud.alpha = 1;                                              
		hud.x = x;                                                      
		hud.y = y;                                                      
                                                               
		if( IsDefined( text ) )                                         
		{                                                               
			hud SetText( text );                                          
		}                                                               
                                                                    
		return hud;                                                     
}    

#/                                                               

race_final_fireworks()
{
	level endon("stop_fireworks");
	level waittill("start_finish_fireworks");
	level thread race_final_finishline_fireworks();
	launch_spots = getstructarray(level.scr_zm_map_start_location +  "_zrace_launch_spot","targetname");
	while(1)
	{
		launch_spots = array_randomize(launch_spots);
		foreach (spot in launch_spots)
		{
			wait(randomfloatrange(4.0,6.0));
			level thread fireworks_launch(spot);
		}

	}	
}

race_final_finishline_fireworks()
{
	level endon("stop_fireworks");

	finish_spots = getstructarray(level.scr_zm_map_start_location +  "_zrace_launch_spot_finish","targetname");
	while(1)
	{
		foreach(spot in finish_spots)
		{
			level thread fireworks_launch(spot);
			wait(randomfloatrange(1.75,2.5));
		}
		wait(randomfloatrange(1.75,2.5));	
	}
}

fireworks_launch(launch_spot)
{

	meat = spawn("script_model",launch_spot.origin + (randomintrange(-60,60),randomintrange(-60,60),0));
	meat setmodel("tag_origin");
	wait_network_frame();	
	PlayFXOnTag( level._effect[ "fw_trail_cheap" ], meat, "tag_origin" );
	meat playloopsound( "zmb_souls_loop", .75 );
	
	dest = launch_spot;	

	while(isDefined(dest) && isDefined(dest.target))
	{
		random_offset = (randomintrange(-60,60),randomintrange(-60,60),0);
		new_dests = getstructarray(dest.target,"targetname");	
		new_dest = random(new_dests);
		dest = new_dest;
		dist = distance(new_dest.origin + random_offset,meat.origin);
		time = dist/700;							
		meat MoveTo(new_dest.origin + random_offset, time);
		meat waittill("movedone");
	}
 	meat playsound( "zmb_souls_end");

	playfx(level._effect["fw_pre_burst"],meat.origin);
	meat delete();
}
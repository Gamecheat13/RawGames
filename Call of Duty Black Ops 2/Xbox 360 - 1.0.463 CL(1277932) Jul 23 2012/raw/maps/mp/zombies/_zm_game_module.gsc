#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_utility; 



init()
{
	flag_init( "pregame" );
	
	flag_set( "pregame" );
	
	gametype = GetDvar( "ui_gametype" );
	
	if ( is_Encounter() && gametype != "zgrief" && gametype != "zturned" && gametype != "zpitted" && gametype != "zmeat")
	{
		level.ZM_roundLimit = 3;
		level.ZM_scoreLimit = 3;
	}
	else if(gametype == "zmeat")
	{
		level.ZM_roundLimit = 5;
		level.ZM_scoreLimit = 5;
	}
	else
	{
		level.ZM_roundLimit = 1;
		level.ZM_scoreLimit = 1;
	}
	
	
	if(gametype == "zmeat" || gametype == "zrace")
	{
		level._no_static_unitriggers = true;
	}
	
	level.ZM_roundswitch = 1;
	level.ZM_timeLimit = 0;
	level.ZM_roundWinLimit = level.ZM_roundLimit * 0.5;
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	level endon( "end_game" );	
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill_either( "spawned_player", "fake_spawned_player" );
		
		if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			self thread maps\mp\zombies\_zm_laststand::auto_revive( self );
		}

		if ( IsDefined( level.custom_player_fake_death_cleanup ) )
		{
			self [[ level.custom_player_fake_death_cleanup ]]();
		}

		self SetStance( "stand" );
		self.zmbDialogQueue = [];
		self.zmbDialogActive = false;
		self.zmbDialogGroups = [];
		self.zmbDialogGroup = "";
	
		if ( is_Encounter() )
		{

			if ( self.team == "team3")
			{
				self.characterIndex = 0;
				self._encounters_team = "A";
				self._team_name = &"ZOMBIE_RACE_TEAM_1";
			}
			else
			{
				self.characterIndex = 1;
				self._encounters_team = "B";
				self._team_name = &"ZOMBIE_RACE_TEAM_2";
			}

			self module_hud_create_team_name();
		}

		self TakeAllWeapons();

		if ( IsDefined( level.giveCustomCharacters ) )
		{
			self [[ level.giveCustomCharacters ]]();
		}

		self GiveWeapon( "knife_zm" );
		self give_start_weapon( true );
		if ( IsDefined( level._team_loadout ) )
		{
			self GiveWeapon( level._team_loadout );
			self SwitchToWeapon( level._team_loadout );
		}
	}
	
	num_grenades = 4;
	if(level.scr_zm_ui_gametype == "zrace")
	{
		num_grenades = 1;
	}
	
	lethal_grenade = self get_player_lethal_grenade();
	self GiveWeapon( lethal_grenade );
	self SetWeaponAmmoClip( lethal_grenade, num_grenades );
}


/*------------------------------------
Handles registration of any game modules
------------------------------------*/
register_game_module(index,module_name,pre_init_func,post_init_func,pre_init_zombie_spawn_func,post_init_zombie_spawn_func,hub_start_func)
{
	if(!isDefined(level._game_modules))
	{
		level._game_modules = [];
		level._num_registered_game_modules = 0;
	}	
	
	for(i=0;i<level._num_registered_game_modules;i++)
	{
		if(!isDefined(level._game_modules[i]))
		{
			continue;
		}
		if(isDefined(level._game_modules[i].index) && level._game_modules[i].index == index)
		{
			assert(level._game_modules[i].index != index,"A Game module is already registered for index (" + index + ")" );
		}
	}
	
	level._game_modules[level._num_registered_game_modules] = spawnstruct();
	level._game_modules[level._num_registered_game_modules].index = index;
	level._game_modules[level._num_registered_game_modules].module_name = module_name;
	level._game_modules[level._num_registered_game_modules].pre_init_func = pre_init_func;
	level._game_modules[level._num_registered_game_modules].post_init_func = post_init_func;
	level._game_modules[level._num_registered_game_modules].pre_init_zombie_spawn_func = pre_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].post_init_zombie_spawn_func = post_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].hub_start_func = hub_start_func;
	level._num_registered_game_modules++;	
}

set_current_game_module(game_module_index)
{
	if(!isDefined(game_module_index))
	{
		level.current_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		level.scr_zm_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		return;
	}
	game_module = get_game_module(game_module_index);
	
	if(!isDefined(game_module))
	{
		assert(isDefined(game_module),"unknown game module (" + game_module_index + ")" );
		return;
	}	
	
	level.current_game_module = game_module_index;	
}

get_current_game_module()
{
	return get_game_module(level.current_game_module);
}

get_game_module(game_module_index)
{
	
	if(!isDefined(game_module_index))
	{
		return undefined;
	}
		
	for(i=0;i<level._game_modules.size;i++)
	{
		if(level._game_modules[i].index == game_module_index)
		{
			return level._game_modules[i];
		}
	}	
	return undefined;
}

/*------------------------------------
function that should run at the beginning of "zombie_spawn_init() " in _zm_spawner
------------------------------------*/
game_module_pre_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isDefined(current_module) || !isDefined(current_module.pre_init_zombie_spawn_func))
	{
		return;
	}
	
	self [[current_module.pre_init_zombie_spawn_func]]();
}

/*------------------------------------
function that should run at the end of "zombie_spawn_init() " in _zm_spawner
------------------------------------*/
game_module_post_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isDefined(current_module) || !isDefined(current_module.post_init_zombie_spawn_func))
	{
		return;
	}
		
	self [[current_module.post_init_zombie_spawn_func]]();
}


/*------------------------------------
this needs to be called from the map's level script
to kick off any available game modes ( including survival )

set this up as a function pointer like so:

 level._round_start_func = maps\mp\zombies\_zm_game_module::start_game_modules("transit");
	
------------------------------------*/
start_game_modules()
{
	map_name = level.script;

	level.gamemode_match = spawnstruct();	
	level.gamemode_match.mode = 			GetDvar( "ui_gametype" );
	if (level.gamemode_match.mode == "" && isdefined(level.default_game_mode))
		level.gamemode_match.mode = level.default_game_mode;

	level.gamemode_match.location =  	GetDvar( "ui_zm_mapstartlocation" );
	if (level.gamemode_match.location == "" && isdefined(level.default_start_location))
		level.gamemode_match.location = level.default_start_location;

	//* level.gamemode_match.num_rounds = GetDvarInt("zm_num_rounds");
	level.gamemode_match.rounds = [];
	level.gamemode_match.randomize_mode = 		GetDvarInt("zm_rand_mode");
	level.gamemode_match.randomize_location = GetDvarInt("zm_rand_loc");
	level.gamemode_match.team_1_score = 0;
	level.gamemode_match.team_2_score = 0;
	level.gamemode_match.current_round= 0;

	level.gamemode_match.map_name = map_name;
	
	level thread game_module_match_logic(level.gamemode_match);
	
	level thread game_objects_allowed( level.gamemode_match.mode, level.gamemode_match.location );
}

game_objects_allowed( mode, location )
{
	allowed[ 0 ] = mode;

	entities = GetEntArray();

	foreach ( entity in entities )
	{
		if ( IsDefined( entity.script_gameobjectname ) )
		{
			isAllowed =  maps\mp\gametypes\_gameobjects::entity_is_allowed( entity, allowed );
			isValidLocation = IsDefined( entity.script_noteworthy ) && entity.script_noteworthy == location;
									
			if ( !isAllowed || ( !isValidLocation && !is_Classic() ) )
			{
				if ( IsDefined( entity.spawnflags ) && entity.spawnflags == 1 )
				{
					if ( IsDefined( entity.classname ) && entity.classname != "trigger_multiple" )
					{
						entity ConnectPaths();
					}
				}
				entity Delete();
				continue;
			}		
			if ( IsDefined( entity.script_vector ) )
			{
				entity MoveTo( entity.origin + entity.script_vector, 0.05 );
				entity waittill( "movedone" );
	
				if ( IsDefined( entity.spawnflags ) && entity.spawnflags == 1 )
				{
					entity DisconnectPaths();
				}
			}
			else
			{
				if ( IsDefined( entity.spawnflags ) && entity.spawnflags == 1 )
				{
					if ( IsDefined( entity.classname ) && entity.classname != "trigger_multiple" )
					{
						entity ConnectPaths();
					}
				}
			}
		}
	}
}

game_module_match_logic(gamemode_match_info)
{
	if ( is_Encounter() )
	{
		level._game_module_player_damage_callback = maps\mp\zombies\_zm_game_module::game_module_player_damage_callback;
	}
	else
	{
		level._game_module_player_damage_callback = undefined;
	}
	
	mode = gamemode_match_info.mode;
	if(mode == "zclassic" || mode == "zsurvival" || !isDefined(mode))
	{
		level thread [[level._game_mode_start_classic]]();
		return;
	}
	if(mode == "zstandard")
	{
		match_name = gamemode_match_info.map_name + "_" + gamemode_match_info.location + "_" + mode;		
		mode_index = maps\mp\zombies\_zm::getZMGameModule(GetDvar( "ui_gametype" ));		
		module = get_game_module( mode_index );
		level.scr_zm_game_module = mode_index;		
		level thread [[module.hub_start_func]](match_name);
		return;		
	}
	
	
	//turn off default vocals for race/meat/turned
	level.skit_vox_override = true;

	if(isDefined(level.flag["start_zombie_round_logic"] ))
	{
		flag_wait("start_zombie_round_logic");
	}
	
	flag_wait( "start_encounters_match_logic");
	
	for( i = 0; i < level.ZM_roundLimit; i++ )
	{
		flag_set( "pregame" );
		waittillframeend;
		level.gameEnded = false;
		gamemode_match_info.current_round++;
	
		if(gamemode_match_info.randomize_mode == 1)
		{
			if(isDefined(level._get_random_encounter_func))
			{
				match = [[level._get_random_encounter_func]](gamemode_match_info.location);
				mode = match.mode_name;
				setdvar("ui_gametype",mode);
				
				assert(isDefined(match) ,"No random encounter match found");			
			}
		}
		
		match_name = gamemode_match_info.map_name + "_" + gamemode_match_info.location + "_" + mode;		
		
		mode_index = maps\mp\zombies\_zm::getZMGameModule(GetDvar( "ui_gametype" ));		
		module = get_game_module( mode_index );
		setdvar("ui_gametype",mode);
		
		gamemode_match_info.rounds[i] = spawnstruct();
		gamemode_match_info.rounds[i].mode = mode;
		
		level.scr_zm_game_module = mode_index;		
		level thread [[module.hub_start_func]](match_name);

		flag_wait( "start_encounters_match_logic" );

		// Start Timer
		level.gameStartTime = GetTime();
		level.gameLengthTime = undefined;
		
		level thread createTimer();
		

		level notify("clear_hud_elems");
		
		level waittill( "game_module_ended", winner );
		gamemode_match_info.rounds[i].winner = winner;
		
		level thread kill_all_zombies();
		
		level.gameEndTime = GetTime();
		level.gameLengthTime = level.gameEndTime - level.gameStartTime;
		level.gameEnded = true;
				
		if( winner == "A" )
		{
			gamemode_match_info.team_1_score++;
		}
		else
		{
			gamemode_match_info.team_2_score++;
		}
	
		if ( is_true( is_Encounter() ) )
		{
			// for ingame 3D scoreboard
			[[level._setTeamScore]]( "allies", gamemode_match_info.team_2_score );
			[[level._setTeamScore]]( "team3", gamemode_match_info.team_1_score );
					
			if( gamemode_match_info.team_1_score == gamemode_match_info.team_2_score )
			{
				level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "win" );
				level thread maps\mp\zombies\_zm_audio_announcer::announceRoundWinner( "tied" );
			}
			else
			{
				level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "win", winner, "lose" );
				level thread maps\mp\zombies\_zm_audio_announcer::announceRoundWinner( winner );
			}
		}
		
		level thread delete_corpses();	
		level delay_thread(5,::revive_laststand_players);
		level notify("clear_hud_elems");		
		if ( startNextRound( winner ) )
		{
			break;
		}
		
		level clientnotify("gme");
	}
	
	///////////////////////////////////////////
	// After this the match is really ending //
	///////////////////////////////////////////
	if ( is_true( is_Encounter() ) )
	{
		matchWonTeam = "";
		if ( gamemode_match_info.team_1_score > gamemode_match_info.team_2_score )
		{
			matchWonTeam = "A";
		}
		else
		{
			matchWonTeam = "B";
		}
	
		level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "win", matchWonTeam, "lose" );
		level thread maps\mp\zombies\_zm_audio_announcer::announceMatchWinner( matchWonTeam );
		
		level create_final_score();

		track_encounters_win_stats( matchWonTeam );
	}
	
	level.can_revive_game_module = undefined;

	//do final score here
	level notify("end_game");
}

revive_laststand_players()
{
		players = GET_PLAYERS();
		foreach(player in players)
		{
			if(player maps\mp\zombies\_zm_laststand::player_is_in_laststand() ) //revive anyone who is in last stand
			{
				player thread maps\mp\zombies\_zm_laststand::auto_revive( player );
			}
		}
}

kill_all_zombies()
{
	ai = GetAIArray( "axis" );

	foreach ( zombie in ai )
	{
		if ( IsDefined( zombie ) )
		{
			zombie DoDamage( zombie.maxhealth * 2, zombie.origin, zombie, zombie, "none", "MOD_SUICIDE" );
			wait( 0.05 );
		}
	}
}

createTimer()
{
	flag_waitopen("pregame");
	elem = NewHudElem();	
	elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "top";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0; // -20;
	elem.foreground = true;
	elem.font = "default";
	elem.fontScale = 1.5;
	elem.color = ( 1.0, 1.0, 1.0 );        
	elem.alpha = 2;
	//* elem.label = &"TIME: ";
	
	elem thread maps\mp\gametypes\_hud::fontPulseInit();

	if ( is_true( level.timerCountDown ) )
	{
		elem SetTenthsTimer( level.round_timer * 60 );
	}
	else
	{
		elem SetTenthsTimerUp( .1 );
	}
	
	level.game_module_timer = elem;
	
	level waittill( "game_module_ended" );
	
	elem Destroy();
}

startNextRound( winner )
{
	if ( !isOneZMRound() )
	{
		if ( !wasLastZMRound() )
		{
			displayRoundEnd( winner );	
			create_hud_scoreboard();
			
			if ( checkRoundSwitch() )
			{
				displayRoundSwitch();
			}

			return false;
		}
	}

	return true;
}

isOneZMRound()
{		
	if ( level.ZM_roundLimit == 1 )
	{
		return true;
	}

	return false;
}

wasLastZMRound()
{		
	if ( is_true( level.forcedEnd ) )
	{
		return true;
	}

	if ( hitZMRoundLimit() || hitZMScoreLimit() || hitZMRoundWinLimit() )
	{
		return true;
	}
		
	return false;
}

hitZMRoundLimit()
{
	if ( level.ZM_roundLimit <= 0 )
	{
		return false;
	}

	return ( getZMRoundsPlayed() >= level.ZM_roundLimit );
}

hitZMRoundWinLimit()
{
	if ( !IsDefined(level.ZM_roundWinLimit) || level.ZM_roundWinLimit <= 0 )
	{
		return false;
	}

	if ( level.gamemode_match.team_1_score >= level.ZM_roundWinLimit || level.gamemode_match.team_2_score >= level.ZM_roundWinLimit )
	{
		return true;
	}
	
	if ( level.gamemode_match.team_1_score >= level.ZM_roundWinLimit ||
		level.gamemode_match.team_2_score >= level.ZM_roundWinLimit)
	{
		if ( level.gamemode_match.team_1_score != level.gamemode_match.team_2_score )
		{
			return true;
		}
	}
	
	return false;
}


hitZMScoreLimit()
{
	if ( level.ZM_scoreLimit <= 0 )
	{
		return false;
	}

	if ( is_Encounter() )
	{
		if ( level.gamemode_match.team_1_score >= level.ZM_scoreLimit || level.gamemode_match.team_2_score >= level.ZM_scoreLimit )
		{
			return true;
		}
	}
	
	return false;
}

getZMRoundsPlayed()
{
	return level.gamemode_match.current_round;
}

checkRoundSwitch()
{
	if ( !IsDefined( level.ZM_roundSwitch ) || !level.ZM_roundSwitch )
	{
		return false;
	}

	Assert( level.gamemode_match.current_round > 0 );

	if ( level.gamemode_match.current_round % level.ZM_roundSwitch == 0 )
	{
		//* level.gamemode_match.switchedsides = !level.gamemode_match.switchedsides;

		return true;
	}

	return false;
}

delete_corpses()
{
	//kill any zombie corpses
	corpses = getcorpsearray();
	for(x=0;x<corpses.size;x++)
	{
		corpses[x] delete();
	}	
}

freeze_players(freeze)
{			
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i] freeze_player_controls( freeze );
	}
}


create_hud_scoreboard()
{
	level endon("end_game");	
	
	level thread module_hud_full_screen_overlay(); //background

	level thread module_hud_team_1_score();
	level thread module_hud_team_2_Score();
	level thread module_hud_round_num();	
	respawn_spectators_and_freeze_players();	
	waittill_any_or_timeout(6,"clear_hud_elems");	
	wait(2.1);

}

respawn_spectators_and_freeze_players()
{
	players = GET_PLAYERS();
	foreach(player in players)
	{
		if(player.sessionstate == "spectator")
		{
			if(isDefined(player.spectate_hud))
			{
				player.spectate_hud destroy();
			}	
			player [[level.spawnPlayer]]();
		}
		player freeze_player_controls( true );
	}
}

module_hud_team_1_score()
{
	level._encounters_score_1 = newhudelem();
	level._encounters_score_1.x = 0; 
	level._encounters_score_1.y = 260;	
	level._encounters_score_1.alignX = "center";	
	level._encounters_score_1.horzAlign = "center"; 
	level._encounters_score_1.vertAlign = "top";
	level._encounters_score_1.font = "default";
	level._encounters_score_1.fontScale = 2.3;
	level._encounters_score_1.color = ( 1.0, 1.0, 1.0 );     
	level._encounters_score_1.foreground = true; 
	level._encounters_score_1 settext("Team CIA:  " + level.gamemode_match.team_1_score);
	level._encounters_score_1.alpha = 0;	
	level._encounters_score_1.sort = 11;
	level._encounters_score_1 FadeOverTime( 2.0 );
	level._encounters_score_1.alpha = 1;
	level waittill_any_or_timeout(6,"clear_hud_elems");
	
	level._encounters_score_1 FadeOverTime( 2.0 ); 
	level._encounters_score_1.alpha = 0;
	wait(2.1);
	level._encounters_score_1 destroy();	
}

module_hud_team_2_score()
{
	level._encounters_score_2 = newhudelem();
	level._encounters_score_2.x = 0; 
	level._encounters_score_2.y = 290;
	level._encounters_score_2.alignX = "center";	
	level._encounters_score_2.horzAlign = "center"; 
	level._encounters_score_2.vertAlign = "top"; 
	level._encounters_score_2.font = "default";
	level._encounters_score_2.fontScale = 2.3;
	level._encounters_score_2.color = ( 1.0, 1.0, 1.0 );     
	level._encounters_score_2.foreground = true; 
	level._encounters_score_2 settext("Team CDC:  " + level.gamemode_match.team_2_score);
	level._encounters_score_2.alpha = 0;	
	level._encounters_score_2.sort = 12;
	level._encounters_score_2 FadeOverTime( 2.0 );
	level._encounters_score_2.alpha = 1;
	level waittill_any_or_timeout(6,"clear_hud_elems");
	level._encounters_score_2 FadeOverTime( 2.0 ); 
	level._encounters_score_2.alpha = 0;
	wait(2.1);
	level._encounters_score_2 destroy();	
}

module_hud_round_num()
{
	level._encounters_round_num = newhudelem();
	level._encounters_round_num.x = 0; 
	level._encounters_round_num.y = 60;	
	level._encounters_round_num.alignX = "center";
	level._encounters_round_num.horzAlign = "center"; 	
	level._encounters_round_num.vertAlign = "top"; 
	level._encounters_round_num.font = "default";
	level._encounters_round_num.fontScale = 2.3;
	level._encounters_round_num.color = ( 1, 1, 1.0 );     
	level._encounters_round_num.foreground = true; 
	level._encounters_round_num settext("Round:  ^5" + level.gamemode_match.current_round + " / " + level.ZM_roundLimit);
	level._encounters_round_num.alpha = 0;	
	level._encounters_round_num.sort = 13;
	level._encounters_round_num FadeOverTime( 2.0 );
	level._encounters_round_num.alpha = 1;
	level waittill_any_or_timeout(6,"clear_hud_elems");
	level._encounters_round_num FadeOverTime( 2.0 ); 
	level._encounters_round_num.alpha = 0;
	wait(2.1);
	level._encounters_round_num destroy();	
}

module_hud_full_screen_overlay()
{
	
	fadetoblack = newhudelem();
	fadetoblack.x = 0; 
	fadetoblack.y = 0;
	fadetoblack.horzAlign = "fullscreen"; 
	fadetoblack.vertAlign = "fullscreen"; 
	fadetoblack SetShader( "black", 640, 480 ); 
	fadetoblack.color = (0,0,0);
	fadetoblack.alpha = 1;
	fadetoblack.foreground = true;
	fadetoblack.sort = 0;
	if( is_Encounter() )
	{
		level waittill_any_or_timeout(25,"start_fullscreen_fade_out");
	}
	else
	{
			level waittill_any_or_timeout(25,"start_zombie_round_logic");
	}
	fadetoblack FadeOverTime( 2.0 ); 
	fadetoblack.alpha = 0; 
	wait 2.1;
	fadetoblack destroy();
}

create_final_score()
{
	level endon("end_game");	
	
		level thread module_hud_team_winer_score();
		wait(2);
		level thread module_hud_full_screen_overlay(); //background
		wait(8);
}

module_hud_team_winer_score()
{
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i] thread create_module_hud_team_winer_score();
		players[i] thread team_icon_winner(players[i]._team_hud["team"]);
	}
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "match_over" );
	
}

create_module_hud_team_winer_score()
{
	self._team_winer_score = newclienthudelem(self);
	self._team_winer_score.x = 0; 
	self._team_winer_score.y = 50;	
	self._team_winer_score.alignX = "center";
	self._team_winer_score.horzAlign = "center"; 
	self._team_winer_score.vertAlign = "middle"; 
	self._team_winer_score.font = "default";
	self._team_winer_score.fontScale = 15;	
	self._team_winer_score.color = ( 0, 1.0, 0 );     
	self._team_winer_score.foreground = true;
	
	if(self._encounters_team == "B" && level.gamemode_match.team_2_score > level.gamemode_match.team_1_score)
	{
		self._team_winer_score settext("YOU WON THE MATCH");
	}
	else if(self._encounters_team == "B" && level.gamemode_match.team_2_score < level.gamemode_match.team_1_score)
	{
		self._team_winer_score.color = ( 1.0, 0, 0 ); 
		self._team_winer_score settext("YOU LOST THE MATCH");
	}
	if(self._encounters_team == "A" && level.gamemode_match.team_1_score > level.gamemode_match.team_2_score)
	{
		self._team_winer_score settext("YOU WON THE MATCH");
	}
	else if(self._encounters_team == "A" && level.gamemode_match.team_1_score < level.gamemode_match.team_2_score)
	{
		self._team_winer_score.color = ( 1.0, 0, 0 ); 
		self._team_winer_score settext("YOU LOST THE MATCH");
	}	
	self._team_winer_score.alpha = 0;	
	self._team_winer_score.sort = 12;
	self._team_winer_score FadeOverTime( 2.0 );
	self._team_winer_score.alpha = 1;
	wait(10);
	self._team_winer_score FadeOverTime( 2.0 ); 
	self._team_winer_score.alpha = 0;
	wait(2.1);
	self._team_winer_score destroy();	
}

module_Onconnecting()
{
	level thread module_hud_connecting();
}

module_hud_connecting()
{
	if(GetDvarInt( "party_playerCount" ) > 1)
	{
		level._module_connect_hud = newhudelem();
		level._module_connect_hud.x = 0; 
		level._module_connect_hud.y = 50;	
		level._module_connect_hud.alignX = "center";
		level._module_connect_hud.horzAlign = "center"; 
		level._module_connect_hud.vertAlign = "middle"; 
		level._module_connect_hud.font = "default";
		level._module_connect_hud.fontScale = 2.3;
		level._module_connect_hud.color = ( 1.0, 1.0, 1.0 );     
		level._module_connect_hud.foreground = true;
		level._module_connect_hud settext("WAITING FOR OTHER PLAYERS");
	}
	level thread module_hud_full_screen_overlay();	
	wait_for_players();
	
	if( !is_Classic() )
	{
		//flag_set( "begin_spawning" );	// Starts off the zone system.
		//TODO: C. Ayers - Make this work, currently it delays gameplay by 20 seconds, and is weird
		level maps\mp\zombies\_zm_audio_announcer::announceGamemodeRules();
		flag_set("start_encounters_match_logic");
	}
	flag_set("initial_blackscreen_passed");
}


wait_for_players()
{
	level endon("end_race");

	//Always wait for this....
	//flag_wait( "start_zombie_round_logic" );
	
	//If so then just go
	if(GetDvarInt( "party_playerCount" ) == 1)
	{
		flag_wait( "start_zombie_round_logic" );
		return;
	}

	while(!flag_exists("start_zombie_round_logic"))
	{
		wait(.05);
	}
	while(!flag("start_zombie_round_logic") && IsDefined( level._module_connect_hud ) )
	{
		level._module_connect_hud.alpha = 0;	
		level._module_connect_hud.sort = 12;
		level._module_connect_hud FadeOverTime( 1.0 );
		level._module_connect_hud.alpha = 1;
		wait(1.5);
		level._module_connect_hud FadeOverTime( 1.0 ); 
		level._module_connect_hud.alpha = 0;
		wait(1.5);
	}
	
	if ( IsDefined( level._module_connect_hud ) )
	{
		level._module_connect_hud destroy();
	}
}

start_round()
{
	flag_clear("start_encounters_match_logic");

	if(!isDefined(level._module_round_hud))
	{
		level._module_round_hud = newhudelem();
		level._module_round_hud.x = 0; 
		level._module_round_hud.y = 70;	
		level._module_round_hud.alignX = "center";
		level._module_round_hud.horzAlign = "center"; 
		level._module_round_hud.vertAlign = "middle"; 
		level._module_round_hud.font = "default";
		level._module_round_hud.fontScale = 2.3;
		level._module_round_hud.color = ( 1.0, 1.0, 1.0 );     
		level._module_round_hud.foreground = true;
		level._module_round_hud.sort = 0;
	}
	
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i] freeze_player_controls( true );
		players[i] thread team_icon_intro(players[i]._team_hud["team"]);
	}
	
	level._module_round_hud.alpha = 1;
	label = &"Next Round Starting In  ^2";
	level._module_round_hud.label = (label);
	level._module_round_hud settimer(3);
	
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "countdown" );
	level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "clap" );
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_start" );
	
	level notify( "start_fullscreen_fade_out" );
	wait(2);
	level._module_round_hud FadeOverTime( 1 ); 
	level._module_round_hud.alpha = 0;

	wait(1);
	
	level thread play_sound_2d( "zmb_air_horn" );
	
	players = GET_PLAYERS();
	for(i=0;i<players.size;i++)
	{
		players[i] freeze_player_controls( false );
		players[i] SprintUpRequired();
	}

	flag_set("start_encounters_match_logic");
	flag_clear( "pregame" );
	level._module_round_hud destroy();	
}

displayRoundEnd( round_winner )
{
	players = GET_PLAYERS();
	foreach(player in players)
	{
		player thread module_hud_round_end(round_winner);
		player thread team_icon_winner(player._team_hud["team"]);
		player delay_thread(5,::freeze_player_controls,true);		
	}
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "round_end" );
	level thread maps\mp\zombies\_zm_audio::zmbVoxCrowdOnTeam( "clap" );
	level thread play_sound_2d( "zmb_air_horn" );
	wait(5);
}

module_hud_round_end(round_winner)
{
	self endon("disconnect");
	
	self._team_winner_round = newclienthudelem(self);
	self._team_winner_round.x = 0; 
	self._team_winner_round.y = 50;	
	self._team_winner_round.alignX = "center";
	self._team_winner_round.horzAlign = "center"; 
	self._team_winner_round.vertAlign = "middle"; 
	self._team_winner_round.font = "default";
	self._team_winner_round.fontScale = 15;
	self._team_winner_round.color = ( 1.0, 1.0, 1.0 );     
	self._team_winner_round.foreground = true;
	
	if(self._encounters_team == round_winner)
	{
		self._team_winner_round.color = ( 0, 1.0, 0 ); 
		self._team_winner_round settext("YOU WIN");
	}
	else
	{
		self._team_winner_round.color = ( 1, 0, 0 ); 
		self._team_winner_round settext("YOU LOSE");
	}	
	self._team_winner_round.alpha = 0;	
	self._team_winner_round.sort = 12;
	self._team_winner_round FadeOverTime( 1.0 );
	self._team_winner_round.alpha = 1;
	wait(4);
	self._team_winner_round FadeOverTime( 1.0 ); 
	self._team_winner_round.alpha = 0;
	wait(1.1);
		
	self._team_winner_round destroy();	
}

displayRoundSwitch()
{

	level._round_changing_sides = newhudelem();
	level._round_changing_sides.x = 0; 
	level._round_changing_sides.y = 60;	
	level._round_changing_sides.alignX = "center";
	level._round_changing_sides.horzAlign = "center"; 
	level._round_changing_sides.vertAlign = "middle"; 
	level._round_changing_sides.font = "default";
	level._round_changing_sides.fontScale = 2.3;
	level._round_changing_sides.color = ( 1.0, 1.0, 1.0 );     
	level._round_changing_sides.foreground = true;
	level._round_changing_sides.sort = 12;
	
	fadetoblack = newhudelem();
	fadetoblack.x = 0; 
	fadetoblack.y = 0;
	fadetoblack.horzAlign = "fullscreen"; 
	fadetoblack.vertAlign = "fullscreen"; 
	fadetoblack SetShader( "black", 640, 480 ); 
	fadetoblack.color = (0,0,0);
	fadetoblack.alpha = 1;
	
	//TODO: C. Ayers - Record and Add Round Switch Vox
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "side_switch" );
	
	level._round_changing_sides settext ("CHANGING SIDES");
	level._round_changing_sides FadeOverTime( 1.0 );
	level._round_changing_sides.alpha = 1;
	wait(2);
	fadetoblack FadeOverTime(1.0);
	level._round_changing_sides FadeOverTime( 1.0 ); 
	level._round_changing_sides.alpha = 0;
	fadetoblack .alpha = 0;
	
	wait(1.1);
	level._round_changing_sides destroy();
	fadetoblack destroy();

}

module_hud_create_team_name()
{
	if ( !IsDefined( self._team_hud ) )
	{
		self._team_hud = [];
	}

	if ( IsDefined( self._team_hud[ "team" ] ) )
	{
		 self._team_hud[ "team" ] destroy();
	}	
	elem = NewClientHudElem(self);
	elem.hidewheninmenu = true;

	elem.alignX = "center";
	elem.alignY = "middle";
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.og_x = 85;
	elem.og_y = -40;
	elem.foreground = true;
	elem.font = "default";
	elem.color = (1,1,1);    
	elem.sort = 1; 
	elem.alpha = .7;
	elem setshader (game["icons"][self.team],150,150);
	self._team_hud[ "team" ] = elem;  
	
}

team_icon_intro(elem)
{
	if(!isDefined(elem))
	{
		if(isDefined(self._team_hud) && isDefined(self._team_hud["team"]))
		{
			elem = self._team_hud["team"];
		}
		else
		{
			return;
		}
	}
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.alpha = 0.7;	
	elem.sort = 1;
	elem ScaleOverTime(.75,60,60);
	elem MoveOverTime( .75 );
	elem.horzAlign = "left";
	elem.vertAlign = "bottom";
	elem.x = elem.og_x;
	elem.y = elem.og_y;

}


team_icon_winner(elem)
{
	og_x = elem.x;
	og_y = elem.y;
	elem.sort = 1;
	elem ScaleOverTime(.75,150,150);
	elem MoveOverTime( .75 );
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.alpha = 0.7;
	wait(.75);	
}



game_module_player_damage_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self.last_damage_from_zombie_or_player = false;
	if(isDefined(eAttacker) )
	{
		if( IsPlayer(eAttacker) && eAttacker == self)
		{
			return;
		}
				
		if(is_true(eAttacker.is_zombie) || IsPlayer(eAttacker))
		{
			self.last_damage_from_zombie_or_player = true;
		}
	}
	
	if(is_true(self._being_shellshocked) || self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return;
	}
	if(isPlayer(eAttacker) && isDefined(eAttacker._encounters_team) && eAttacker._encounters_team != self._encounters_team) //player was shot by another player on the other team
	{

		if ( IsDefined(self.hasRiotShield) && self.hasRiotShield && IsDefined(vDir) )
		{
			if ( IsDefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped  )
			{
				if ( self maps\mp\zombies\_zm::player_shield_facing_attacker(vDir, 0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
			else if ( !IsDefined( self.riotshieldEntity ))
			{
				// shield on back - half damage to player, half to shield
				if ( !self maps\mp\zombies\_zm::player_shield_facing_attacker(vDir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
		}

		if(isDefined(level._effect["butterflies"]))
		{
			playfx(level._effect["butterflies"],vPoint,vDir);
		}
		self thread do_game_mode_shellshock();
		self playsound( "zmb_player_hit_ding" );
	}
}

damage_callback_no_pvp_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if(isDefined(eAttacker) && isplayer( eAttacker) && eAttacker == self) //player can damage self
	{
		return iDamage;
	}
	if(isDefined(eAttacker) && !isPlayer(eAttacker))
	{
		return iDamage;
	}
	if(!isDefined(eAttacker))
	{
		return iDamage;
	}
	return 0;
}


do_game_mode_shellshock()
{
	self endon("disconnect");
	
	self._being_shellshocked = true;
	self shellshock("tabun_gas_mp",.75);
	wait(.75);
	self._being_shellshocked = false;		
}

track_encounters_win_stats( matchWonTeam )
{
	//track the player wins/loses stats

	players = GET_PLAYERS();		
	for( i = 0; i < players.size; i++ )
	{
		if ( players[i]._encounters_team == matchWonTeam)
		{
			players[i] maps\mp\zombies\_zm_stats::increment_client_stat( "wins" );
		}
		else
		{
			players[i] maps\mp\zombies\_zm_stats::increment_client_stat( "losses" );
		}
	}
}

wait_for_team_death()
{	
	// TEMP
	wait ( 15 );
	
	winner = undefined;
	
	while( !IsDefined( winner ) )
	{
		CDC_Alive = 0;
		CIA_Alive = 0;
		
		players = GET_PLAYERS();
		
		foreach ( player in players )
		{
			if ( player._encounters_team == "A" )
			{				
				if ( is_player_valid( player ) )
				{
					CIA_Alive++;
				}
			}
			else
			{
				if ( is_player_valid( player ) )
				{
					CDC_Alive++;
				}
			}
		}
		
		if ( CIA_Alive == 0 )
		{
			winner = "B";
		}
		else if ( CDC_ALIVE == 0 )
		{
			winner = "A";
		}
		
		wait ( 0.05 );
	}
		
	level notify( "game_module_ended", winner );
}

make_supersprinter()
{
	self set_zombie_run_cycle( "super_sprint" );
}


game_module_custom_intermission(intermission_struct)
{
	self closeMenu();
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	s_point = getstruct(intermission_struct,"targetname");
	
	if(!isDefined(level.intermission_cam_model))
	{
		level.intermission_cam_model = spawn("script_model",s_point.origin);//(1566, 498, 47.5));
		level.intermission_cam_model.angles = s_point.angles;
		level.intermission_cam_model setmodel("tag_origin");
	}
	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	self Spawn( level.intermission_cam_model.origin, level.intermission_cam_model.angles );
	self CameraSetPosition( level.intermission_cam_model );
	self CameraSetLookAt();
	self CameraActivate( true );	
	self linkto(level.intermission_cam_model);	
	level.intermission_cam_model moveto(getstruct(s_point.target,"targetname").origin,12);	
	self.game_over_bg FadeOverTime( 2 );
	self.game_over_bg.alpha = 0;
	wait(2);				
	self.game_over_bg thread maps\mp\zombies\_zm::fade_up_over_time(1);
}

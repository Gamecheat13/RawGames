#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_defaults;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_spawn;
#using scripts\zm\gametypes\_globallogic_ui;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_hud_message;
#using scripts\zm\gametypes\_spawning;
#using scripts\zm\gametypes\_weapons;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

                                                                                       	                                

#precache( "menu", "team_marinesopfor" );
#precache( "menu", "class" );
#precache( "menu", "ChooseClass_InGame" );
#precache( "menu", "ingame_controls" );
#precache( "menu", "ingame_options" );
#precache( "menu", "popup_leavegame" );
#precache( "menu", "spectate" );
#precache( "menu", "restartgamepopup" );
#precache( "menu", "scoreboard" );
#precache( "menu", "initteam_marines" );
#precache( "menu", "initteam_opfor" );
#precache( "menu", "sidebet" );
#precache( "menu", "sidebet_player" );
#precache( "menu", "changeclass_wager" );
#precache( "menu", "changeclass_custom" );
#precache( "menu", "changeclass_barebones" );
#precache( "string", "MP_HOST_ENDED_GAME" );
#precache( "string", "MP_HOST_ENDGAME_RESPONSE" );

#namespace zm_gametype;

//
// This function *only* sets default values - all gamemode specifics should be over-ridden in script in the gametype script - after the call to this function.
//

function main( )
{
	globallogic::init();

	GlobalLogic_SetupDefault_ZombieCallbacks();
	
	menu_init();
	
	//util::registerRoundLimit( minValue, maxValue )
	util::registerRoundLimit( 1, 1 );
	
	//util::registerTimeLimit( minValue, maxValue )
	util::registerTimeLimit( 0, 0 );
	
	//util::registerScoreLimit( minValue, maxValue )
	util::registerScoreLimit( 0, 0 );
	
	//util::registerRoundWinLimit( minValue, maxValue )
	util::registerRoundWinLimit( 0, 0 );
	
	//util::registerNumLives( minValue, maxValue )
	util::registerNumLives( 1, 1 );


	weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );


	level.takeLivesOnDeath = true;
	level.teamBased = true;
	level.disablePrematchMessages = true;	//NEW
	level.disableMomentum = true;			//NEW
	
	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	level.displayHalftimeText = false;
	level.displayRoundEndText = false;
	
	level.allowAnnouncer = false;
	//level.allowZmbAnnouncer = true;
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;
	level.resetPlayerScoreEveryRound = true;
	
	level.doPrematch = false;
	level.noPersistence = true;
	level.cumulativeRoundScores = true;
	
	level.forceAutoAssign = true;
	level.dontShowEndReason = true;
	level.forceAllAllies = true;			//NEW
	
	//DISABLE TEAM SWAP
	level.allow_teamchange = false;
	SetDvar( "scr_disable_team_selection", 1 );
	//makeDvarServerInfo( "scr_disable_team_selection", 1 );
	
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_xpscale", 0 );
	
	level.onStartGameType = &onStartGameType;
//	level.onSpawnPlayer = &onSpawnPlayer;
	level.onSpawnPlayer = &globallogic::blank;
	level.onSpawnPlayerUnified = &onSpawnPlayerUnified;
	level.onRoundEndGame = &onRoundEndGame;
	//level.giveCustomLoadout = &giveCustomLoadout;
	level.playerMaySpawn = &maySpawn;

	zm_utility::set_game_var("ZM_roundLimit", 1);
	zm_utility::set_game_var("ZM_scoreLimit", 1);

	zm_utility::set_game_var("_team1_num", 0);
	zm_utility::set_game_var("_team2_num", 0);
	
	map_name = level.script;

	//level.gamemode_match = spawnstruct();	

	mode = GetDvarString( "ui_gametype" );
	
	if((!isdefined(mode) || mode == "") && isdefined(level.default_game_mode))
	{
		mode = level.default_game_mode;
	}
	
	zm_utility::set_gamemode_var_once("mode", mode);
	
	zm_utility::set_game_var_once("side_selection", 1);
	
	location = GetDvarString( "ui_zm_mapstartlocation" );
	
	if(location == "" && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}
	
	zm_utility::set_gamemode_var_once("location", location);
	

	//* level.gamemode_match.num_rounds = GetDvarInt("zm_num_rounds");
	//level.gamemode_match.rounds = [];
	zm_utility::set_gamemode_var_once("randomize_mode", GetDvarInt("zm_rand_mode"));
	zm_utility::set_gamemode_var_once("randomize_location", GetDvarInt("zm_rand_loc"));
	zm_utility::set_gamemode_var_once("team_1_score", 0);
	zm_utility::set_gamemode_var_once("team_2_score", 0);
	zm_utility::set_gamemode_var_once("current_round", 0);
	zm_utility::set_gamemode_var_once("rules_read", false);
	zm_utility::set_game_var_once("switchedsides", false);
	
	gametype = GetDvarString("ui_gametype");
	
	game["dialog"]["gametype"] = gametype + "_start";
	game["dialog"]["gametype_hardcore"] = gametype + "_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	zm_utility::set_gamemode_var("pre_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("post_init_zombie_spawn_func", undefined);
	zm_utility::set_gamemode_var("match_end_notify", undefined);
	zm_utility::set_gamemode_var("match_end_func", undefined);
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "downs", "revives", "headshots" ); 
	callback::on_connect( &onPlayerConnect_check_for_hotjoin);
	// level thread module_hud_connecting();
}

function game_objects_allowed( mode, location )
{
	allowed[ 0 ] = mode;

	entities = GetEntArray();

	foreach ( entity in entities )
	{
		if ( IsDefined( entity.script_gameobjectname ) )
		{
			isAllowed =  gameobjects::entity_is_allowed( entity, allowed );
			isValidLocation = gameobjects::location_is_allowed( entity, location );
									
			if ( !isAllowed || ( !isValidLocation && !zm_utility::is_classic() ) )
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

function post_init_gametype()
{
	if(isdefined(level.gamemode_map_postinit))
	{
		if(isdefined(level.gamemode_map_postinit[level.scr_zm_ui_gametype]))
		{
			[[level.gamemode_map_postinit[level.scr_zm_ui_gametype]]]();
		}
	}	
}

function post_gametype_main(mode)
{
	zm_utility::set_game_var("ZM_roundWinLimit", zm_utility::get_game_var("ZM_roundLimit") * 0.5);
	
	level.roundLimit = zm_utility::get_game_var("ZM_roundLimit");
	
	if(isdefined(level.gamemode_map_preinit))
	{
		if(isdefined(level.gamemode_map_preinit[mode]))
		{
			[[level.gamemode_map_preinit[mode]]]();
		}
	}	
}

function GlobalLogic_SetupDefault_ZombieCallbacks()
{
	level.spawnPlayer = &globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = &globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = &globallogic_spawn::spawnClient;
	level.spawnSpectator = &globallogic_spawn::spawnSpectator;
	level.spawnIntermission = &globallogic_spawn::spawnIntermission;
	level.scoreOnGivePlayerScore = &globallogic::blank;
	level.onPlayerScore = &globallogic::blank;
	level.onTeamScore = &globallogic::blank;
	
	level.waveSpawnTimer = &globallogic::waveSpawnTimer;
	
	level.onSpawnPlayer = &globallogic::blank;
	level.onSpawnPlayerUnified = &globallogic::blank;
	level.onSpawnSpectator = &onSpawnSpectator;
	level.onSpawnIntermission = &onSpawnIntermission;
	level.onRespawnDelay = &globallogic::blank;

	level.onForfeit = &globallogic::blank;
	level.onTimeLimit = &globallogic::blank;
	level.onScoreLimit = &globallogic::blank;
	level.onDeadEvent = &onDeadEvent;
	level.onOneLeftEvent = &globallogic::blank;
	level.giveTeamScore = &globallogic::blank;

	level.getTimePassed = &globallogic_utils::getTimePassed;
	level.getTimeLimit = &globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = &globallogic::blank;
	level.getTeamKillScore = &globallogic::blank;

	level.isKillBoosting = &globallogic::blank;

	level._setTeamScore = &globallogic_score::_setTeamScore;
	level._setPlayerScore = &globallogic::blank;

	level._getTeamScore = &globallogic::blank;
	level._getPlayerScore = &globallogic::blank;
	
	level.onPrecacheGameType = &globallogic::blank;
	level.onStartGameType = &globallogic::blank;
	level.onPlayerConnect = &globallogic::blank;
	level.onPlayerDisconnect = &onPlayerDisconnect;
	level.onPlayerDamage = &globallogic::blank;
	level.onPlayerKilled = &globallogic::blank;
	level.onPlayerKilledExtraUnthreadedCBs = []; ///< Array of other CB function pointers

	level.onTeamOutcomeNotify = &hud_message::teamOutcomeNotifyZombie;
	level.onOutcomeNotify = &globallogic::blank;
	level.onTeamWagerOutcomeNotify = &globallogic::blank;
	level.onWagerOutcomeNotify = &globallogic::blank;
	level.onEndGame = &onEndGame;
	level.onRoundEndGame = &globallogic::blank;
	level.onMedalAwarded = &globallogic::blank;
	level.dogManagerOnGetDogs = &globallogic::blank;


	level.autoassign = &globallogic_ui::menuAutoAssign;
	level.spectator = &globallogic_ui::menuSpectator;
	level.curClass = &globallogic_ui::menuClass;
	level.allies = &menuAlliesZombies;
	level.teamMenu = &globallogic_ui::menuTeam;

	level.callbackActorKilled = &globallogic::blank;
	level.callbackVehicleDamage = &globallogic::blank;
	level.callbackVehicleKilled = &globallogic::blank;
}

function setup_standard_objects(location)
{
	structs = struct::get_array("game_mode_object");
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

function is_survival_object()
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

function game_module_player_damage_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self.last_damage_from_zombie_or_player = false;
	if(isDefined(eAttacker) )
	{
		if( IsPlayer(eAttacker) && eAttacker == self)
		{
			return;
		}
				
		if(( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) || IsPlayer(eAttacker))
		{
			self.last_damage_from_zombie_or_player = true;
		}
	}
	
	if(( isdefined( self._being_shellshocked ) && self._being_shellshocked ) || self laststand::player_is_in_laststand())
	{
		return;
	}
	if(isPlayer(eAttacker) && isDefined(eAttacker._encounters_team) && eAttacker._encounters_team != self._encounters_team) //player was shot by another player on the other team
	{

		if ( IsDefined(self.hasRiotShield) && self.hasRiotShield && IsDefined(vDir) )
		{
			if ( IsDefined(self.hasRiotShieldEquipped) && self.hasRiotShieldEquipped  )
			{
				if ( self zm::player_shield_facing_attacker(vDir, 0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
			else if ( !IsDefined( self.riotshieldEntity ))
			{
				// shield on back - half damage to player, half to shield
				if ( !self zm::player_shield_facing_attacker(vDir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
		}

		if ( IsDefined( level._game_module_player_damage_grief_callback ) )
		{
			self [[ level._game_module_player_damage_grief_callback ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
		}		
		
		if(isDefined(level._effect["butterflies"]))
		{
			if ( weapon.isGrenadeWeapon )
			{
				playfx(level._effect["butterflies"],self.origin + ( 0, 0, 40 ));
			}
			else
			{
				playfx(level._effect["butterflies"],vPoint,vDir);
			}
		}
		self thread do_game_mode_shellshock();
		self playsound( "zmb_player_hit_ding" );
	}
}

function do_game_mode_shellshock()
{
	self endon("disconnect");
	
	self._being_shellshocked = true;
	self shellshock("grief_stab_zm",.75);
	wait(.75);
	self._being_shellshocked = false;		
}

function add_map_gamemode(mode, preinit_func, precache_func, main_func)
{
	if(!isdefined(level.gamemode_map_location_init))
	{
		level.gamemode_map_location_init = [];
	}

	if(!isdefined(level.gamemode_map_location_main))
	{
		level.gamemode_map_location_main = [];
	}

	if(!isdefined(level.gamemode_map_preinit))
	{
		level.gamemode_map_preinit = [];
	}	

	if(!isdefined(level.gamemode_map_postinit))
	{
		level.gamemode_map_postinit = [];
	}	
	
	if(!isdefined(level.gamemode_map_precache))
	{
		level.gamemode_map_precache = [];
	}	
	
	if(!isdefined(level.gamemode_map_main))
	{
		level.gamemode_map_main = [];
	}	
	
	level.gamemode_map_preinit[mode] = preinit_func;
	level.gamemode_map_main[mode] = main_func;
	level.gamemode_map_precache[mode] = precache_func;
	level.gamemode_map_location_precache[mode] = [];
	level.gamemode_map_location_main[mode] = [];
}

function add_map_location_gamemode(mode, location, precache_func, main_func)
{
	if(!isdefined(level.gamemode_map_location_precache[mode]))
	{
/#		println("*** ERROR : " + mode + " has not been added to the map using add_map_gamemode."); #/
		return;
	}
	
	level.gamemode_map_location_precache[mode][location] = precache_func;
	level.gamemode_map_location_main[mode][location] = main_func;	
	
}

function runGameTypePrecache(gamemode)
{
	if(!isdefined(level.gamemode_map_location_main) || !isdefined(level.gamemode_map_location_main[gamemode]))
	{
		return;
	}
	
	if(isdefined(level.gamemode_map_precache))
	{
		if(isdefined(level.gamemode_map_precache[gamemode]))
		{
			[[level.gamemode_map_precache[gamemode]]]();
		}
	}
	
	if(isdefined(level.gamemode_map_location_precache))
	{
		if(isdefined(level.gamemode_map_location_precache[gamemode]))
		{
			loc = GetDvarString("ui_zm_mapstartlocation");
			
			if(loc == "" && isdefined(level.default_start_location))
			{
				loc = level.default_start_location;
			}
			
			if(isdefined(level.gamemode_map_location_precache[gamemode][loc]))
			{
				[[level.gamemode_map_location_precache[gamemode][loc]]]();
			}
		}
	}
	
	if ( isdefined( level.precacheCustomCharacters ) )
	{
		self [[level.precacheCustomCharacters]]();
	}	
}

function runGameTypeMain(gamemode, mode_main_func, use_round_logic)
{
	if(!isdefined(level.gamemode_map_location_main) || !isdefined(level.gamemode_map_location_main[gamemode]))
	{
		return;
	}
	
	level thread game_objects_allowed( zm_utility::get_gamemode_var("mode"), zm_utility::get_gamemode_var("location") );
	
	if(isdefined(level.gamemode_map_main))
	{
		if(isdefined(level.gamemode_map_main[gamemode]))
		{
			level thread [[level.gamemode_map_main[gamemode]]]();
		}
	}

	if(isdefined(level.gamemode_map_location_main))
	{
		if(isdefined(level.gamemode_map_location_main[gamemode]))
		{
			loc = GetDvarString("ui_zm_mapstartlocation");

			if(loc == "" && isdefined(level.default_start_location))
			{
				loc = level.default_start_location;
			}

			if(isdefined(level.gamemode_map_location_main[gamemode][loc]))
			{
				level thread [[level.gamemode_map_location_main[gamemode][loc]]]();
			}
		}
	}
	
	
	if(isdefined(mode_main_func))
	{
		if(isdefined(use_round_logic) && use_round_logic)
		{
			level thread round_logic(mode_main_func);
		}
		else
		{
			level thread non_round_logic(mode_main_func);
		}
	}
	level thread game_end_func();
}

function round_logic(mode_logic_func)
{
	level.skit_vox_override = true;

	if(isDefined(level.flag["start_zombie_round_logic"] ))
	{
		level flag::wait_till("start_zombie_round_logic");
	}


	level flag::wait_till( "start_encounters_match_logic");	

	if(!isdefined(game["gamemode_match"]["rounds"]))
	{
		game["gamemode_match"]["rounds"] = [];
	}

	zm_utility::set_gamemode_var_once("current_round", 0);
	zm_utility::set_gamemode_var_once("team_1_score", 0);
	zm_utility::set_gamemode_var_once("team_2_score", 0);
	
	if ( ( isdefined( zm_utility::is_encounter() ) && zm_utility::is_encounter() ) )
	{
		// for ingame 3D scoreboard
		[[level._setTeamScore]]( "allies", zm_utility::get_gamemode_var("team_2_score") );
		[[level._setTeamScore]]( "axis", zm_utility::get_gamemode_var("team_1_score") );
	}
	
//	for( i = 0; i < zm_utility::get_game_var("ZM_roundLimit"); i++ )
	{
		level flag::set( "pregame" );
		waittillframeend;
		level.gameEnded = false;
		cur_round = zm_utility::get_gamemode_var("current_round");
		zm_utility::set_gamemode_var("current_round", cur_round + 1);
	
/*		if(gamemode_match_info.randomize_mode == 1)
		{
			if(isDefined(level._get_random_encounter_func))
			{
				match = [[level._get_random_encounter_func]](gamemode_match_info.location);
				mode = match.mode_name;
				SetDvar("ui_gametype",mode);
				
				assert(isDefined(match) ,"No random encounter match found");			
			}
		} */
		
//		match_name = gamemode_match_info.map_name + "_" + gamemode_match_info.location + "_" + mode;		
		
//		mode_index = zm::getZMGameModule(GetDvarString( "ui_gametype" ));		
//		module = zm_utility::get_game_module( mode_index );
//		SetDvar("ui_gametype",mode);
		
		game["gamemode_match"]["rounds"][cur_round] = spawnstruct();
		game["gamemode_match"]["rounds"][cur_round].mode = GetDvarString("ui_gametype");
		
//		level.scr_zm_game_module = mode_index;		
		level thread [[mode_logic_func]]();

		level flag::wait_till( "start_encounters_match_logic" );

		// Start Timer
		level.gameStartTime = GetTime();
		level.gameLengthTime = undefined;
		
		//level thread createTimer();
		

		level notify("clear_hud_elems");
		
		level waittill( "game_module_ended", winner );
		game["gamemode_match"]["rounds"][cur_round].winner = winner;
		
		level thread kill_all_zombies();
		
		level.gameEndTime = GetTime();
		level.gameLengthTime = level.gameEndTime - level.gameStartTime;
		level.gameEnded = true;
				
		if( winner == "A" )
		{
			score = zm_utility::get_gamemode_var("team_1_score");
			zm_utility::set_gamemode_var("team_1_score",  score + 1);
		}
		else
		{
			score = zm_utility::get_gamemode_var("team_2_score");
			zm_utility::set_gamemode_var("team_2_score", score + 1);
		}
	
		if ( ( isdefined( zm_utility::is_encounter() ) && zm_utility::is_encounter() ) )
		{
			// for ingame 3D scoreboard
			[[level._setTeamScore]]( "allies", zm_utility::get_gamemode_var("team_2_score") );
			[[level._setTeamScore]]( "axis", zm_utility::get_gamemode_var("team_1_score") );
					
			if( zm_utility::get_gamemode_var("team_1_score") == zm_utility::get_gamemode_var("team_2_score") )
			{
				//level thread zm_audio::zmbVoxCrowdOnTeam( "win" );
				level thread zm_audio_announcer::announceRoundWinner( "tied" );
			}
			else
			{
				//level thread zm_audio::zmbVoxCrowdOnTeam( "win", winner, "lose" );
				level thread zm_audio_announcer::announceRoundWinner( winner );
			}
		}
		
		level thread delete_corpses();	
		level util::delay(5, undefined, &revive_laststand_players);
		level notify("clear_hud_elems");		
		if ( startNextZMRound( winner ) )
		{
			level util::clientnotify("gme");
			
			while(1)
			{
				wait(1);	// wait for map restart.
			}
		}
		
	}
	
	level.match_is_ending = true;
	
	///////////////////////////////////////////
	// After this the match is really ending //
	///////////////////////////////////////////
	if ( ( isdefined( zm_utility::is_encounter() ) && zm_utility::is_encounter() ) )
	{
		matchWonTeam = "";
		if ( zm_utility::get_gamemode_var("team_1_score") > zm_utility::get_gamemode_var("team_2_score") )
		{
			matchWonTeam = "A";
		}
		else
		{
			matchWonTeam = "B";
		}
	
		//level thread zm_audio::zmbVoxCrowdOnTeam( "win", matchWonTeam, "lose" );
		level thread zm_audio_announcer::announceMatchWinner( matchWonTeam );
		
		level create_final_score();

		track_encounters_win_stats( matchWonTeam );
	}
	
	zm::intermission();
	
	level.can_revive_game_module = undefined;

	//do final score here
	level notify("end_game");	
}


function end_rounds_early( winner )
{
	level.forcedEnd = true;	
	cur_round = zm_utility::get_gamemode_var("current_round");
	zm_utility::set_gamemode_var("ZM_roundLimit", cur_round);
	if (isdefined(winner))
		level notify("game_module_ended", winner);	
	else
		level notify("end_game");	
}


function checkZMRoundSwitch()
{
	if ( !IsDefined( level.ZM_roundSwitch ) || !level.ZM_roundSwitch )
	{
		return false;
	}

	Assert( zm_utility::get_gamemode_var("current_round") > 0 );

	//if ( zm_utility::get_gamemode_var("current_round") % level.ZM_roundSwitch == 0 )
	{
		//* game["gamemode_match"]["switchedsides"] = !game["gamemode_match"]["switchedsides"];

		return true;
	}

	return false;
}


function create_hud_scoreboard(duration,fade)
{
	level endon("end_game");	
	
	level thread module_hud_full_screen_overlay(); //background

	level thread module_hud_team_1_score(duration,fade);
	level thread module_hud_team_2_Score(duration,fade);
	level thread module_hud_round_num(duration,fade);	
	respawn_spectators_and_freeze_players();	
	util::waittill_any_timeout(duration,"clear_hud_elems");	
	//wait(duration);

}

function respawn_spectators_and_freeze_players()
{
	players = GetPlayers();
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
		player util::freeze_player_controls( true );
	}
}

function module_hud_team_1_score(duration,fade)
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
	level._encounters_score_1 settext("Team CIA:  " + zm_utility::get_gamemode_var("team_1_score"));
	level._encounters_score_1.alpha = 0;	
	level._encounters_score_1.sort = 11;
	level._encounters_score_1 FadeOverTime( fade );
	level._encounters_score_1.alpha = 1;
	level util::waittill_any_timeout(duration,"clear_hud_elems");
	
	level._encounters_score_1 FadeOverTime( fade ); 
	level._encounters_score_1.alpha = 0;
	wait(fade);
	level._encounters_score_1 destroy();	
}

function module_hud_team_2_score(duration,fade)
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
	level._encounters_score_2 settext("Team CDC:  " + zm_utility::get_gamemode_var("team_2_score"));
	level._encounters_score_2.alpha = 0;	
	level._encounters_score_2.sort = 12;
	level._encounters_score_2 FadeOverTime( fade );
	level._encounters_score_2.alpha = 1;
	level util::waittill_any_timeout(duration,"clear_hud_elems");
	level._encounters_score_2 FadeOverTime( fade ); 
	level._encounters_score_2.alpha = 0;
	wait(fade);
	level._encounters_score_2 destroy();	
}

function module_hud_round_num( duration, fade )
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
	level._encounters_round_num settext("Round:  ^5" + (zm_utility::get_gamemode_var("current_round")+1) + " / " + zm_utility::get_game_var("ZM_roundLimit"));
	level._encounters_round_num.alpha = 0;	
	level._encounters_round_num.sort = 13;
	level._encounters_round_num FadeOverTime( fade );
	level._encounters_round_num.alpha = 1;
	level util::waittill_any_timeout(duration,"clear_hud_elems");
	level._encounters_round_num FadeOverTime( fade ); 
	level._encounters_round_num.alpha = 0;
	wait(fade);
	level._encounters_round_num destroy();	
}


function createTimer()
{
	level flag::wait_till_clear("pregame");
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
	
	elem thread hud::font_pulse_init();

	if ( ( isdefined( level.timerCountDown ) && level.timerCountDown ) )
	{
		elem SetTenthsTimer( level.timeLimit * 60 );
	}
	else
	{
		elem SetTenthsTimerUp( .1 );
	}
	
	level.game_module_timer = elem;
	
	level waittill( "game_module_ended" );
	
	elem Destroy();
}

function revive_laststand_players()
{
	if ( ( isdefined( level.match_is_ending ) && level.match_is_ending ) )
	{
		return;
	}
	
		players = GetPlayers();
		foreach(player in players)
		{
			if(player laststand::player_is_in_laststand() ) //revive anyone who is in last stand
			{
				player thread zm_laststand::auto_revive( player );
			}
		}
}

function team_icon_winner(elem)
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

function delete_corpses()
{
	//kill any zombie corpses
	corpses = getcorpsearray();
	for(x=0;x<corpses.size;x++)
	{
		corpses[x] delete();
	}	
}

function track_encounters_win_stats( matchWonTeam )
{
	//track the player wins/loses stats

	players = GetPlayers();		
	for( i = 0; i < players.size; i++ )
	{
		if ( players[i]._encounters_team == matchWonTeam)
		{
			players[i] zm_stats::increment_client_stat( "wins" );
			players[i] zm_stats::add_client_stat( "losses", -1 );
			players[i] AddDStat( "skill_rating", 1.0 );
			players[i] SetDStat( "skill_variance", 1.0 );
			
			if ( GameModeIsMode( 0 ) )
			{
				// For leaderboards' combined rank
				players[i] zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "wins", 1 );
				players[i] zm_stats::add_location_gametype_stat( level.scr_zm_map_start_location, level.scr_zm_ui_gametype, "losses", -1 );
			}
		}
		else
		{
			// Don't need to increment the losses since the losses is added when the match starts
			players[i] SetDStat( "skill_rating", 0.0 );
			players[i] SetDStat( "skill_variance", 1.0 );
		}		

		players[i] UpdateStatRatio( "wlratio", "wins", "losses" );
	}
}

function non_round_logic(mode_logic_func)
{
	level thread [[mode_logic_func]]();
}

function game_end_func()
{
	if(!isdefined(zm_utility::get_gamemode_var("match_end_notify")) && !isdefined(zm_utility::get_gamemode_var("match_end_func")))
	{
		return;
	}
	
	level waittill(zm_utility::get_gamemode_var("match_end_notify"), winning_team);

	level thread [[zm_utility::get_gamemode_var("match_end_func")]](winning_team);
	
}

function setup_classic_gametype()
{
	ents = getentarray();
	foreach(ent in ents)
	{
		if(isDefined(ent.script_parameters))
		{
			parameters = strtok(ent.script_parameters," ");
			should_remove = false;
			foreach(parm in parameters)
			{
				if(parm == "survival_remove")
				{
					should_remove = true;
				}
			}
			if(should_remove)
			{
				ent delete();
			}
/*			
			else
			{
				if ( IsDefined( ent.script_vector ) )
				{
					ent MoveTo( ent.origin + ent.script_vector, 0.05 );
					ent waittill( "movedone" );
		
					if ( IsDefined( ent.spawnflags ) && ent.spawnflags == 1 )
					{
						ent DisconnectPaths();
					}
				}
			}
*/			
		}
	}
                
	structs = struct::get_array("game_mode_object");
	foreach(struct in structs)
	{
		if(!isDefined(struct.script_string))
		{
			continue;
		}
		tokens = strtok(struct.script_string," ");
		spawn_object = false;
		foreach(parm in tokens)
		{
			if(parm == "survival")
			{
				spawn_object = true;
			}
		}
		
		if( !spawn_object)
		{
			continue;
		}
		barricade = spawn("script_model",struct.origin);
		barricade.angles = struct.angles;
		barricade setmodel(struct.script_parameters);
	}
	unlink_meat_traversal_nodes();
             
}



function zclassic_main()
{
	level thread setup_classic_gametype();
	level thread zm::round_start();	
}


function unlink_meat_traversal_nodes()
{
	//unlink any encounters traversal nodes
	meat_town_nodes = getnodearray("meat_town_barrier_traversals","targetname");
	meat_tunnel_nodes = getnodearray("meat_tunnel_barrier_traversals","targetname");
	meat_farm_nodes = getnodearray("meat_farm_barrier_traversals","targetname");      
                
	nodes = ArrayCombine(meat_town_nodes,meat_tunnel_nodes, true, false);
	traversal_nodes = ArrayCombine(nodes,meat_farm_nodes, true, false);
	foreach(node in traversal_nodes)
	{
		end_node = getnode(node.target,"targetname");
		zm_utility::unlink_nodes(node,end_node);
	}
}

function canPlayerSuicide()
{
	return self HasPerk("specialty_tombstone");
}

function onPlayerDisconnect()
{
	if(isDefined(level.game_mode_custom_onPlayerDisconnect))
	{
		level [[level.game_mode_custom_onPlayerDisconnect]](self);
	}	
	if( isdefined( level.check_quickrevive_hotjoin ) )
	{
		level thread [[ level.check_quickrevive_hotjoin ]]( true );
	}	
	self zm_laststand::add_weighted_down();
	level zm::checkForAllDead(self);
}

function onDeadEvent( team )
{
	thread globallogic::endGame( level.zombie_team, "" );
}

function onSpawnIntermission()
{
	spawnpointname = "info_intermission"; 
	spawnpoints = getentarray( spawnpointname, "classname" ); 
	
	// CODER_MOD: TommyK (8/5/08)
	if(spawnpoints.size < 1)
	{
	/#	println( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" ); 	#/
		return;
	}	
	
	spawnpoint = spawnpoints[RandomInt(spawnpoints.size)];	
	if( isDefined( spawnpoint ) )
	{
		self spawn( spawnpoint.origin, spawnpoint.angles ); 
	}
}

function onSpawnSpectator( origin, angles )
{
}


  	
function maySpawn()
{
	if ( IsDefined(level.customMaySpawnLogic) )
		return self [[ level.customMaySpawnLogic ]]();

	if ( self.pers["lives"] == 0 )
	{
		level notify( "player_eliminated" );
		self notify( "player_eliminated" );
		return false;
	}
	return true;
}

function onStartGameType()
{
	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins( level.spawnMins, struct.origin );
		level.spawnMaxs = math::expand_maxs( level.spawnMaxs, struct.origin );
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs ); 
	setMapCenter( level.mapCenter );

	
	
// 	globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_ZSURVIVAL" );
// 	globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_ZSURVIVAL" );
// 	
// 	if ( level.splitscreen )
// 	{
// 		globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_ZSURVIVAL" );
// 		globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_ZSURVIVAL" );
// 	}
// 	else
// 	{
// 		globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_ZSURVIVAL_SCORE" );
// 		globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_ZSURVIVAL_SCORE" );
// 	}
// 	globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_ZSURVIVAL_HINT" );
// 	globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_ZSURVIVAL_HINT" );
	
//	level.spawnMins = ( 0, 0, 0 );
//	level.spawnMaxs = ( 0, 0, 0 );
// 	spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
// 	spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
// 	spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
// 	spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
// 	spawning::updateAllSpawnPoints();
// 
// 	level.spawn_axis_start= spawnlogic::getSpawnpointArray("mp_tdm_spawn_axis_start");
// 	level.spawn_allies_start= spawnlogic::getSpawnpointArray("mp_tdm_spawn_allies_start");
//	
//	level.mapCenter = spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
//	setMapCenter( level.mapCenter );
//
//	spawnpoint = spawnlogic::getRandomIntermissionPoint();
//	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	//allowed[0] = "zsurvival";
	
	level.displayRoundEndText = false;
	//gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
		if( level.scoreRoundWinBased )
		{
			globallogic_score::resetTeamScores();
		}
	}
}
















function module_hud_full_screen_overlay()
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
	if( zm_utility::is_encounter() || ( GetDvarString( "ui_gametype" ) == "zcleansed" ))
	{
		level util::waittill_any_timeout(25,"start_fullscreen_fade_out");
	}
	else
	{
		level util::waittill_any_timeout(25,"start_zombie_round_logic");
	}
	fadetoblack FadeOverTime( 2.0 ); 
	fadetoblack.alpha = 0; 
	wait 2.1;
	fadetoblack destroy();
}

function create_final_score()
{
	level endon("end_game");	

	level thread module_hud_team_winer_score();
	wait(2);
	//level thread module_hud_full_screen_overlay(); //background
	//wait(1);
}

function module_hud_team_winer_score()
{
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] thread create_module_hud_team_winer_score();
		if (IsDefined(players[i]._team_hud) && IsDefined(players[i]._team_hud["team"]))
			players[i] thread team_icon_winner(players[i]._team_hud["team"]);
		
		if ( ( isdefined( level.lock_player_on_team_score ) && level.lock_player_on_team_score ) )
		{
			players[i] FreezeControls( true );
			players[i] TakeAllWeapons();
			players[i] setClientUIVisibilityFlag( "hud_visible", 0 );
	
			players[i].sessionstate = "spectator";
			players[i].spectatorclient = -1;
			players[i].maxhealth = players[i].health;
			players[i].shellshocked = false;
			players[i].inWater = false;
			players[i].friendlydamage = undefined;
			players[i].hasSpawned = true;
			players[i].spawnTime = GetTime();
			players[i].afk = false;
			players[i] DetachAll();
		}
	}
	
}

function create_module_hud_team_winer_score()
{
	self._team_winer_score = newclienthudelem(self);
	self._team_winer_score.x = 0; 
	self._team_winer_score.y = 70;	
	self._team_winer_score.alignX = "center";
	self._team_winer_score.horzAlign = "center"; 
	self._team_winer_score.vertAlign = "middle"; 
	self._team_winer_score.font = "default";
	self._team_winer_score.fontScale = 15;	
	self._team_winer_score.color = ( 0, 1.0, 0 );     
	self._team_winer_score.foreground = true;
	
	if(self._encounters_team == "B" && zm_utility::get_gamemode_var("team_2_score") > zm_utility::get_gamemode_var("team_1_score"))
	{
		self._team_winer_score settext(&"ZOMBIE_MATCH_WON");
	}
	else if(self._encounters_team == "B" && zm_utility::get_gamemode_var("team_2_score") < zm_utility::get_gamemode_var("team_1_score"))
	{
		self._team_winer_score.color = ( 1.0, 0, 0 ); 
		self._team_winer_score settext(&"ZOMBIE_MATCH_LOST");
	}
	if(self._encounters_team == "A" && zm_utility::get_gamemode_var("team_1_score") > zm_utility::get_gamemode_var("team_2_score"))
	{
		self._team_winer_score settext(&"ZOMBIE_MATCH_WON");
	}
	else if(self._encounters_team == "A" && zm_utility::get_gamemode_var("team_1_score") < zm_utility::get_gamemode_var("team_2_score"))
	{
		self._team_winer_score.color = ( 1.0, 0, 0 ); 
		self._team_winer_score settext(&"ZOMBIE_MATCH_LOST");
	}	
	self._team_winer_score.alpha = 0;	
	self._team_winer_score.sort = 12;
	self._team_winer_score FadeOverTime( 0.25 );
	self._team_winer_score.alpha = 1;
	wait(2);
	self._team_winer_score FadeOverTime( 0.25 ); 
	self._team_winer_score.alpha = 0;
	wait(0.25);
	self._team_winer_score destroy();	
}

function displayRoundEnd( round_winner )
{
	players = GetPlayers();
	foreach(player in players)
	{
		player thread module_hud_round_end(round_winner);
		if (IsDefined(player._team_hud) && IsDefined(player._team_hud["team"]))
			player thread team_icon_winner(player._team_hud["team"]);
		player util::freeze_player_controls(true);		
		//player util::delay(5, undefined, ::freeze_player_controls,true);		
	}
	level thread zm_utility::play_sound_2d( "zmb_air_horn" );
	wait(1.5+0.25+0.25);
}

function module_hud_round_end(round_winner)
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
	self._team_winner_round FadeOverTime( 0.25 );
	self._team_winner_round.alpha = 1;
	wait(1.5);
	self._team_winner_round FadeOverTime( 0.25 ); 
	self._team_winner_round.alpha = 0;
	wait(0.25);
		
	self._team_winner_round destroy();	
}

function displayRoundSwitch()
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
	level thread zm_audio_announcer::leaderDialog( "side_switch" );
	
	level._round_changing_sides settext ("CHANGING SIDES");
	level._round_changing_sides FadeOverTime( 0.25 );
	level._round_changing_sides.alpha = 1;
	wait(1.0);
	fadetoblack FadeOverTime(1.0);
	level._round_changing_sides FadeOverTime( 0.25 ); 
	level._round_changing_sides.alpha = 0;
	fadetoblack .alpha = 0;
	
	wait(0.25);
	level._round_changing_sides destroy();
	fadetoblack destroy();

}

function module_hud_create_team_name()
{
	if( !zm_utility::is_encounter() )
	{
		return;
	}


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
	if ( IsDefined( level.game_module_team_name_override_og_x ) )
	{
		elem.og_x = level.game_module_team_name_override_og_x;
	}
	else
	{
		elem.og_x = 85;
	}
	elem.og_y = -40;
	elem.foreground = true;
	elem.font = "default";
	elem.color = (1,1,1);    
	elem.sort = 1; 
	elem.alpha = .7;
	elem setshader (game["icons"][self.team],150,150);
	self._team_hud[ "team" ] = elem;  
	
}


function NextZMHud(winner)
{
	displayRoundEnd( winner );	
	create_hud_scoreboard( 1.0, 0.25 );
	
	if ( checkZMRoundSwitch() )
	{
		displayRoundSwitch();
	}
}


function startNextZMRound( winner )
{
	if ( !isOneZMRound() )
	{
		if ( !wasLastZMRound() )
		{
			NextZMHud(winner);
			/*
			displayRoundEnd( winner );	
			create_hud_scoreboard();
			
			if ( checkZMRoundSwitch() )
			{
				thread displayRoundSwitch();
			}
			*/

			SetMatchTalkFlag( "DeadChatWithDead", level.voip.deadChatWithDead );
			SetMatchTalkFlag( "DeadChatWithTeam", level.voip.deadChatWithTeam );
			SetMatchTalkFlag( "DeadHearTeamLiving", level.voip.deadHearTeamLiving );
			SetMatchTalkFlag( "DeadHearAllLiving", level.voip.deadHearAllLiving );
			SetMatchTalkFlag( "EveryoneHearsEveryone", level.voip.everyoneHearsEveryone );
			SetMatchTalkFlag( "DeadHearKiller", level.voip.deadHearKiller );
			SetMatchTalkFlag( "KillersHearVictim", level.voip.killersHearVictim );
				
			game["state"] = "playing";
			level.allowbattlechatter["bc"] = GetGametypeSetting( "allowBattleChatter" );
			
			if(( isdefined( level.ZM_switchsides_on_roundswitch ) && level.ZM_switchsides_on_roundswitch ))
			{
				zm_utility::set_game_var("switchedsides", !zm_utility::get_game_var("switchedsides"));
			}
			
			map_restart( true );			
			
			return true;
		}
	}

	return false;
}

function start_round()
{
	level flag::clear("start_encounters_match_logic");

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
	
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] util::freeze_player_controls( true );
	}
	
	level._module_round_hud.alpha = 1;
	label = &"Next Round Starting In  ^2";
	level._module_round_hud.label = (label);
	level._module_round_hud settimer(3);
	
	level thread zm_audio_announcer::leaderDialog( "countdown" );
	
	level notify( "start_fullscreen_fade_out" );
	wait(2);
	level._module_round_hud FadeOverTime( 1 ); 
	level._module_round_hud.alpha = 0;

	wait(1);
	
	level thread zm_utility::play_sound_2d( "zmb_air_horn" );
	
	players = GetPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] util::freeze_player_controls( false );
		players[i] SprintUpRequired();
	}

	level flag::set("start_encounters_match_logic");
	level flag::clear( "pregame" );
	level._module_round_hud destroy();	
}

function isOneZMRound()
{		
	if ( zm_utility::get_game_var("ZM_roundLimit") == 1 )
	{
		return true;
	}

	return false;
}

function wasLastZMRound()
{		
	if ( ( isdefined( level.forcedEnd ) && level.forcedEnd ) )
	{
		return true;
	}

	if ( hitZMRoundLimit() || hitZMScoreLimit() || hitZMRoundWinLimit() )
	{
		return true;
	}
		
	return false;
}

function hitZMRoundLimit()
{
	if ( zm_utility::get_game_var("ZM_roundLimit") <= 0 )
	{
		return false;
	}

	return ( getZMRoundsPlayed() >= zm_utility::get_game_var("ZM_roundLimit") );
}

function hitZMRoundWinLimit()
{
	if ( !IsDefined(zm_utility::get_game_var("ZM_roundWinLimit")) || zm_utility::get_game_var("ZM_roundWinLimit") <= 0 )
	{
		return false;
	}

	if ( zm_utility::get_gamemode_var("team_1_score") >= zm_utility::get_game_var("ZM_roundWinLimit") || zm_utility::get_gamemode_var("team_2_score") >= zm_utility::get_game_var("ZM_roundWinLimit") )
	{
		return true;
	}
	
	if ( zm_utility::get_gamemode_var("team_1_score") >= zm_utility::get_game_var("ZM_roundWinLimit") ||
	    zm_utility::get_gamemode_var("team_2_score") >= zm_utility::get_game_var("ZM_roundWinLimit"))
	{
	    	if ( zm_utility::get_gamemode_var("team_1_score") != zm_utility::get_gamemode_var("team_2_score") )
		{
			return true;
		}
	}
	
	return false;
}


function hitZMScoreLimit()
{
	if ( zm_utility::get_game_var("ZM_scoreLimit") <= 0 )
	{
		return false;
	}

	if ( zm_utility::is_encounter() )
	{
		if ( zm_utility::get_gamemode_var("team_1_score") >= zm_utility::get_game_var("ZM_scoreLimit") || zm_utility::get_gamemode_var("team_2_score") >= zm_utility::get_game_var("ZM_scoreLimit") )
		{
			return true;
		}
	}
	
	return false;
}

function getZMRoundsPlayed()
{
	return zm_utility::get_gamemode_var("current_round");
}

function onSpawnPlayerUnified()
{
	onSpawnPlayer(false);
}


// coop_player_spawn_placement()
// {
// 	structs = struct::get_array( "initial_spawn_points", "targetname" ); 
// 
// 	temp_ent = Spawn( "script_model", (0,0,0) );
// 	for( i = 0; i < structs.size; i++ )
// 	{
// 		temp_ent.origin = structs[i].origin;
// 		temp_ent placeSpawnpoint();
// 		structs[i].origin = temp_ent.origin;
// 	}
// 	temp_ent Delete();
// 
// 	level flag::wait_till( "start_zombie_round_logic" ); 
// 
// 	//chrisp - adding support for overriding the default spawning method
// 
// 	players = GetPlayers(); 
// 
// 	for( i = 0; i < players.size; i++ )
// 	{
// 		players[i] setorigin( structs[i].origin ); 
// 		players[i] setplayerangles( structs[i].angles ); 
// 		players[i].spectator_respawn = structs[i];
// 	}
// }


function onFindValidSpawnPoint()
{
	/#	println( "ZM >> USE STANDARD SPAWNING" );	#/
		
	if(level flag::get("begin_spawning"))
	{
		spawnPoint = zm::check_for_valid_spawn_near_team( self, true );
		/#
			if (!isdefined(spawnPoint))
				println( "ZM >> WARNING UNABLE TO FIND RESPAWN POINT NEAR TEAM - USING INITIAL SPAWN POINTS" );	
		#/
	}	
	
	if (!isdefined(spawnPoint))
	{ 
		match_string = "";
	
		location = level.scr_zm_map_start_location;
		if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
		{
			location = level.default_start_location;
		}		
		
		match_string = level.scr_zm_ui_gametype + "_" + location;
	
		spawnPoints = [];
		structs = struct::get_array("initial_spawn", "script_noteworthy");
		if(IsDefined(structs))
		{
			foreach(struct in structs)			
			{
				if(IsDefined(struct.script_string) )
				{
					
					tokens = strtok(struct.script_string," ");
					foreach(token in tokens)
					{
						if(token == match_string )
						{
							spawnPoints[spawnPoints.size] =	struct;
						}
					}
				}
				
			}			
		}
		
		if(!IsDefined(spawnPoints) || spawnPoints.size == 0) // old method, failed new method.
		{
			spawnPoints = struct::get_array("initial_spawn_points", "targetname");
		}	
						
		assert(IsDefined(spawnPoints), "Could not find initial spawn points!");

		spawnPoint = zm::getFreeSpawnpoint( spawnPoints, self );
	}
	
	return spawnPoint;
}




function onSpawnPlayer(predictedSpawn)
{
	if(!IsDefined(predictedSpawn))
	{
		predictedSpawn = false;
	}
	
	pixbeginevent("ZSURVIVAL:onSpawnPlayer");
	self.usingObj = undefined;
	
	self.is_zombie = false; 

	//For spectator respawn
	if( IsDefined( level.custom_spawnPlayer ) && ( isdefined( self.player_initialized ) && self.player_initialized ))
	{
		self [[level.custom_spawnPlayer]]();
		return;
	}


	if( isdefined(level.customSpawnLogic) )
	{
	/#	println( "ZM >> USE CUSTOM SPAWNING" );		#/
		spawnPoint = self [[level.customSpawnLogic]](predictedSpawn);
		if (predictedSpawn)
			return;
	}
	else
	{
	/#	println( "ZM >> USE STANDARD SPAWNING" );	#/
		
		spawnPoint = self onFindValidSpawnPoint();
					
		if ( predictedSpawn )
		{
			self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
			return;
		}
/*		else if(game["switchedsides"])	// mid match.
		{
			self setorigin(spawnPoint.origin);
			self setplayerangles (spawnPoint.angles);
			self notify( "spawned_player" ); 
			return; 
		}*/
		else
		{
			self spawn( spawnPoint.origin, spawnPoint.angles, "zsurvival" );
		}
	}

	
	//Zombies player setup
	self.entity_num = self GetEntityNumber(); 
	self thread zm::onPlayerSpawned(); 
	self thread zm::player_revive_monitor();
	self freezecontrols( true );
	self.spectator_respawn = spawnPoint;

	self.score = self  globallogic_score::getPersStat( "score" ); 
	//self.pers["lives"] = 1;

	self.pers["participation"] = 0;
	
		
/#
	if( GetDvarInt( "zombie_cheat" ) >= 1 )
	{
		self.score = 100000;
	}
#/


	self.score_total = self.score; 
	self.old_score = self.score; 

	self.player_initialized = false;
	self.zombification_time = 0;
	self.enableText = true;

	// DCS 090910: now that player can destroy some barricades before set.
	self thread zm_blockers::rebuild_barrier_reward_reset();
	
	if(!( isdefined( level.host_ended_game ) && level.host_ended_game ))
	{
		self util::freeze_player_controls( false );
		self enableWeapons();
	}
	if(isDefined(level.game_mode_spawn_player_logic))
	{
		spawn_in_spectate = [[level.game_mode_spawn_player_logic]]();
		if(spawn_in_spectate)
		{	
			self util::delay(.05, undefined, &zm::spawnSpectator);
		}
	}
	
	pixendevent();
}
//---------------------------------------------------------------------------------------------------
// check if ent or struct valid for gametype use.
// DCS 051512
//---------------------------------------------------------------------------------------------------
function get_player_spawns_for_gametype()
{
	match_string = "";

	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}		

	match_string = level.scr_zm_ui_gametype + "_" + location;

	player_spawns = [];
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		if(IsDefined(struct.script_string) )
		{
			tokens = strtok(struct.script_string," ");
			foreach(token in tokens)
			{
				if(token == match_string )
				{
					player_spawns[player_spawns.size] =	struct;
				}
			}
		}
		else // no gametype defining string, add to array for all locations.
		{
			player_spawns[player_spawns.size] =	struct;
		}		
	}
	return player_spawns;			
}

function onEndGame( winningTeam )
{
	//Clean up this players crap
}

function onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	
	return winner;
}

// giveCustomLoadout( takeAllWeapons, alreadySpawned )
// {
// 	self TakeAllWeapons();
// 	self giveWeapon( level.weaponBaseMelee );
// 	self giveWeapon( GetWeapon( "frag_grenade" ) );
//	self zm_utility::give_start_weapon( true );
// }

function menu_init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_changeclass_allies"] = "ChooseClass_InGame";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_changeclass_axis"] = "ChooseClass_InGame";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_start_menu"] = "StartMenu_Main";
	game["menu_changeclass"] = "ChooseClass_InGame";
	game["menu_changeclass_offline"] = "ChooseClass_InGame";
	game["menu_wager_side_bet"] = "sidebet";
	game["menu_wager_side_bet_player"] = "sidebet_player";
	game["menu_changeclass_wager"] = "changeclass_wager";
	game["menu_changeclass_custom"] = "changeclass_custom";
	game["menu_changeclass_barebones"] = "changeclass_barebones";

	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";
	game["menu_restartgamepopup"] = "restartgamepopup";

	level thread menu_onPlayerConnect();
}

function menu_onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);		
		player thread menu_onMenuResponse();
	}
}

function menu_onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
		
		//iprintln("^6", response);
			
		if ( response == "back" )
		{
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if( self.pers["team"] == "allies" )
						self openMenu( game[ "menu_start_menu" ] );
					if( self.pers["team"] == "axis" )
						self openMenu( game[ "menu_start_menu" ] );
				}
			}
			continue;
		}
		
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines" )
		{
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_wager" )
		{
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_wager"] );
			continue;
		}

		if(response == "changeclass_custom" )
		{
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_custom"] );
			continue;
		}

		if(response == "changeclass_barebones" )
		{
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_barebones"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openMenu( "changeclass_opfor_splitscreen" );
							
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(self IsSplitscreen() )
			{
				//if ( level.console )
				//	endparty();
				level.skipVote = true;

				if ( !( isdefined( level.gameended ) && level.gameended ) )
				{
					self zm_laststand::add_weighted_down();
					self zm_stats::increment_client_stat( "deaths" );
					self zm_stats::increment_player_stat( "deaths" );
					self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();

					level.host_ended_game = true;
					zm_game_module::freeze_players(true);
					level notify("end_game");
				}
			}
				
			continue;
		}
		
		if ( response == "restart_level_zm")
		{
			self zm_laststand::add_weighted_down();
			self zm_stats::increment_client_stat( "deaths" );
			self zm_stats::increment_player_stat( "deaths" );
			self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
			MissionFailed();
		}
		
		if(response == "killserverpc")
		{
			level thread globallogic::killserverPc();
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !( isdefined( level.gameEnded ) && level.gameEnded ))
			{
				self globallogic::gameHistoryPlayerQuit();
				self zm_laststand::add_weighted_down();
				
				self closeInGameMenu();

				level.host_ended_game = true;
				zm_game_module::freeze_players(true);
				level notify("end_game");
			}
			else
			{
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
			case "allies":
				//self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeInGameMenu();
				self [[level.teamMenu]](response);
				break;

			case "autoassign":
				//self closeInGameMenu();
				self [[level.autoassign]]( true );
				break;

			case "spectator":
				//self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"] )
		{
			self closeInGameMenu();
			
			if(  level.rankedMatch && isSubstr(response, "custom") )
			{
				//if ( self IsItemLocked( _rank::GetItemIndex( "feature_cac" ) ) )
				//kick( self getEntityNumber() );
			}

			self.selectedClass = true;
			self [[level.curClass]](response);
		}
	}
}

function menuAlliesZombies()
{
	self globallogic_ui::closeMenus();
	
	if ( !level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
	{
			return;
	}
	
	if(self.pers["team"] != "allies")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.curClass = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self globallogic_ui::updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "allies";
		else
		{
			self.sessionteam = "none";
			self.ffateam = "allies";
		}

		self SetClientScriptMainMenu( game[ "menu_start_menu" ] );

		self notify("joined_team");
		level notify( "joined_team" );
		self callback::callback( #"on_joined_team" );
		self notify("end_respawn");
	}
	
	//self beginClassChoice();
}

function custom_spawn_init_func()
{
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, level._zombies_round_spawn_failsafe);
}

function kill_all_zombies()
{
	zombies = GetAiTeamArray( level.zombie_team );

	foreach ( zombie in zombies )
	{
		if ( IsDefined( zombie ) )
		{
			zombie DoDamage( zombie.maxhealth * 2, zombie.origin, zombie, zombie, "none", "MOD_SUICIDE" );
			{wait(.05);};
		}
	}
}

function init()
{
	level flag::init( "pregame" );
	
	level flag::set( "pregame" );
	
	level thread onPlayerConnect();
}

function onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
		if(isDefined(level.game_module_onPlayerConnect))
		{
			player [[level.game_module_onPlayerConnect]]();
		}
	}
}

function onPlayerSpawned()
{
	level endon( "end_game" );	
	self endon( "disconnect" );

	for ( ;; )
	{
		self util::waittill_either( "spawned_player", "fake_spawned_player" );
		
		if ( ( isdefined( level.match_is_ending ) && level.match_is_ending ) )
		{
			return;
		}
		
		if ( self laststand::player_is_in_laststand() )
		{
			self thread zm_laststand::auto_revive( self );
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
	
		if ( zm_utility::is_encounter() )
		{

			if ( self.team == "axis")
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

		}

		self TakeAllWeapons();

		if ( IsDefined( level.giveCustomCharacters ) )
		{
			self [[ level.giveCustomCharacters ]]();
		}

		self GiveWeapon( level.weaponBaseMelee );
		
		if(isDefined(level.onPlayerSpawned_restore_previous_weapons) && ( isdefined( level.isresetting_grief ) && level.isresetting_grief )) //give players back their weapons if Grief is reset after a stalemate
		{
			weapons_restored = self [[level.onPlayerSpawned_restore_previous_weapons]]();
		}
		if(!( isdefined( weapons_restored ) && weapons_restored ))
		{
			self zm_utility::give_start_weapon( true );
		}
		
		weapons_restored = 0;
		
		if ( IsDefined( level._team_loadout ) )
		{
			self GiveWeapon( level._team_loadout );
			self SwitchToWeapon( level._team_loadout );
		}	
	
		if(isdefined(level.gamemode_post_spawn_logic))
		{
			self [[level.gamemode_post_spawn_logic]]();
		}
	}
}

/*
function module_hud_connecting()
{
	if(GetDvarInt( "party_playerCount" ) > 1)
	{
		level._module_connect_hud = newhudelem();
		level._module_connect_hud.x = 0; 
		level._module_connect_hud.y = 70;	
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
	
	if( !zm_utility::is_classic() )
	{
		//level flag::set( "begin_spawning" );	// Starts off the zone system.
		//TODO: C. Ayers - Make this work, currently it delays gameplay by 20 seconds, and is weird
		if(!zm_utility::get_gamemode_var("rules_read"))
		{
			level zm_audio_announcer::announceGamemodeRules();
			zm_utility::set_gamemode_var("rules_read", true);
		}
		
		level flag::set("start_encounters_match_logic");
	}
	level flag::set("initial_blackscreen_passed");
}
*/


function wait_for_players()
{
	level endon("end_race");

	//Always wait for this....
	//utility::flag_wait( "start_zombie_round_logic" );
	
	//If so then just go
	if(GetDvarInt( "party_playerCount" ) == 1)
	{
		level flag::wait_till( "start_zombie_round_logic" );
		return;
	}

	while(!flag::exists("start_zombie_round_logic"))
	{
		wait(.05);
	}
	while ( !level flag::get( "start_zombie_round_logic" ) && isdefined( level._module_connect_hud ) )
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


function onPlayerConnect_check_for_hotjoin()
{
	/# if( getdvarint("zm_instajoin") > 0)
		return;
	#/	

	map_logic_exists = level flag::exists( "start_zombie_round_logic" );
	map_logic_started = level flag::get( "start_zombie_round_logic" );
	
	if( map_logic_exists && map_logic_started )
	{
		self thread hide_gump_loading_for_hotjoiners();	
	}	
}

function hide_gump_loading_for_hotjoiners()
{
	self endon("disconnect");
	
	self.rebuild_barrier_reward = 1; //to prevent losing this pers upgrade when he spawns in at the end of the round. It gets cleared for all players once the new round starts
	self.is_hotjoining = true;
	
	num = self getsnapshotackindex();

	while( num == self getsnapshotackindex() )
	{
		wait(.25);
	}
	
	wait(.5);
	
	self zm::spawnSpectator();
	
	self.is_hotjoining = false;
	self.is_hotjoin = true;

	if(( isdefined( level.intermission ) && level.intermission ) || ( isdefined( level.host_ended_game ) && level.host_ended_game ) )
	{
		util::setclientsysstate( "levelNotify", "zi",self ); // Tell clientscripts we're in zombie intermission
		self SetClientThirdPerson( 0 );
		self resetFov();
		
		self.health = 100; // This is needed so the player view doesn't get stuck
		self thread [[level.custom_intermission]]();	
		
	}	

}


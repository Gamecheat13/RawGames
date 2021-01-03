#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_challenges;
#using scripts\mp\_util;

// Rallypoints should be destroyed on leaving your team/getting killed
// Compass icons need to be looked at
// Doesn't seem to be setting angle on spawn so that you are facing your rallypoint

/*
	Demolition
	Attackers objective: Bomb 2 positions
	Defenders objective: Defend these 2 positions / Defuse planted bombs
	Round ends:	When both bomb positions are exploded, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players respawn upon death

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_dem_spawn_attacker_start
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_dem_spawn_defender_start
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Bombzones:
			classname					trigger_multiple
			targetname					bombzone_dem
			script_gameobjectname		bombzone_dem
			script_bombmode_original	<if defined this bombzone will be used in the original bomb mode>
			script_bombmode_single		<if defined this bombzone will be used in the single bomb mode>
			script_bombmode_dual		<if defined this bombzone will be used in the dual bomb mode>
			script_team					Set to allies or axis. This is used to set which team a bombzone is used by in dual bomb mode.
			script_label				Set to A or B. This sets the letter shown on the compass in original mode.
			This is a volume of space in which the bomb can planted. Must contain an origin brush.

		Bomb:
			classname				trigger_lookat
			targetname				bombtrigger
			script_gameobjectname	bombzone
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used when defusing a bomb.
			It gets moved to the position of the planted bomb model.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers plant the bombs. Defenders protect the targets.

		If using minefields or exploders:
			load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals

		Exploder Effects:
			Setting script_noteworthy on a bombzone trigger to an exploder group can be used to trigger additional effects.
*/

/*QUAKED mp_dem_spawn_attacker_start (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_dem_spawn_defender_start (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_dem_spawn_attackerot_start (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_dem_spawn_defenderot_start (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_dem_spawn_attacker (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players may spawn randomly at one of these positions after death.*/

/*QUAKED mp_dem_spawn_attacker_a (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players may spawn randomly at one of these positions after death if site A has been destroyed.*/

/*QUAKED mp_dem_spawn_attacker_b (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players may spawn randomly at one of these positions after death if site B has been destroyed.*/

/*QUAKED mp_dem_spawn_defender (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players may spawn randomly at one of these positions after death.*/

/*QUAKED mp_dem_spawn_defender_a (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players may spawn randomly at one of these positions after death if site A is still intact.*/

/*QUAKED mp_dem_spawn_defender_b (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players may spawn randomly at one of these positions after death if site B is still intact.*/







#precache( "fx", "explosions/fx_exp_bomb_demo_mp" );
#precache( "material", "compass_waypoint_target" );
#precache( "material", "compass_waypoint_target_a" );
#precache( "material", "compass_waypoint_target_b" );
#precache( "material", "compass_waypoint_defend" );
#precache( "material", "compass_waypoint_defend_a" );
#precache( "material", "compass_waypoint_defend_b" );
#precache( "material", "compass_waypoint_defuse" );
#precache( "material", "compass_waypoint_defuse_a" );
#precache( "material", "compass_waypoint_defuse_b" );
#precache( "model", "p7_mp_suitcase_bomb" );
#precache( "objective", "dem_a" );	
#precache( "objective", "dem_b" );	
#precache( "objective", "dem_overtime" );	
#precache( "string", "OBJECTIVES_DEM_ATTACKER" );
#precache( "string", "OBJECTIVES_SD_DEFENDER" );
#precache( "string", "OBJECTIVES_DEM_ATTACKER_SCORE" );
#precache( "string", "OBJECTIVES_SD_DEFENDER_SCORE" );
#precache( "string", "OBJECTIVES_DEM_ATTACKER_HINT" );
#precache( "string", "OBJECTIVES_DEM_ATTACKER_OVERTIME_HINT" );
#precache( "string", "OBJECTIVES_SD_DEFENDER_HINT" );
#precache( "string", "MP_EXPLOSIVES_RECOVERED_BY" );
#precache( "string", "MP_EXPLOSIVES_DROPPED_BY" );
#precache( "string", "MP_EXPLOSIVES_PLANTED_BY" );
#precache( "string", "MP_EXPLOSIVES_DEFUSED_BY" );
#precache( "string", "PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
#precache( "string", "PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
#precache( "string", "MP_PLANTING_EXPLOSIVE" );	
#precache( "string", "MP_DEFUSING_EXPLOSIVE" );	
#precache( "string", "MP_TIME_EXTENDED" );
#precache( "string", "MP_TARGET_DESTROYED" );
#precache( "string", "MP_BOMB_DEFUSED" );

function main()
{
	globallogic::init();
	
	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 500 );
	util::registerRoundLimit( 0, 12 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.playerSpawnedCB =&dem_playerSpawnedCB;
	level.onPlayerKilled =&onPlayerKilled;
	level.onDeadEvent =&onDeadEvent;
	level.onOneLeftEvent =&onOneLeftEvent;
	level.onTimeLimit =&onTimeLimit;
	level.onRoundSwitch =&onRoundSwitch;
	level.getTeamKillPenalty =&dem_getTeamKillPenalty;
	level.getTeamKillScore =&dem_getTeamKillScore;
	level.getTimeLimit =&getTimeLimit;
	level.shouldPlayOvertimeRound =&shouldPlayOvertimeRound;
	level.lastBombExplodeTime = undefined;
	level.lastBombExplodeByTeam = undefined;
	level.ddBombModel = [];
	
	level.endGameOnScoreLimit = false;
	
	level.demBombzoneName = "bombzone_dem";
	
	gameobjects::register_allowed_gameobject( level.gameType );
	gameobjects::register_allowed_gameobject( "sd" );
	gameobjects::register_allowed_gameobject( "blocker" );
	gameobjects::register_allowed_gameobject( level.demBombzoneName );

	globallogic_audio::set_leader_gametype_dialog ( "startDemolition", "hcStartDemolition", "objDestroy", "objDefend" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "plants", "defuses", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "plants", "defuses" );
}

function onPrecacheGameType()
{
	game["bombmodelname"] = "t5_weapon_briefcase_bomb_world";
	game["bombmodelnameobj"] = "t5_weapon_briefcase_bomb_world";
	game["bomb_dropped_sound"] = "fly_bomb_drop_plr";
	game["bomb_recovered_sound"] = "fly_bomb_pickup_plr";
}

function dem_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_penalty = globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon );

	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) || ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

function dem_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_score = rank::getScoreInfoValue( "team_kill" );
	
	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) || ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}


function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		// overtime! team that's ahead in kills gets to defend.
		aheadTeam = getBetterTeam();
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

function getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isdefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";
	
	// same number of kills

	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	// same number of deaths
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}

function onStartGameType()
{
	SetBombTimer( "A", 0 );
	setMatchFlag( "bomb_timer_a", 0 );
	SetBombTimer( "B", 0 );
	setMatchFlag( "bomb_timer_b", 0 );
	
	level.usingExtraTime = false;
	
	// we'll handle the sideswitching ourselves
	level.spawnsystem.sideSwitching = 0;
	
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	setClientNameMode( "manual_change" );
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";

	level._effect["bombexplosion"] = "explosions/fx_exp_bomb_demo_mp";
	
	if ( isdefined( game["overtime_round"] ) )
	{
		util::setObjectiveText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER" );
		util::setObjectiveText( game["defenders"], &"OBJECTIVES_DEM_ATTACKER" );
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER" );
			util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DEM_ATTACKER" );
		}
		else
		{
			util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER_SCORE" );
			util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DEM_ATTACKER_SCORE" );
		}
		
		util::setObjectiveHintText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER_OVERTIME_HINT" );
		util::setObjectiveHintText( game["defenders"], &"OBJECTIVES_DEM_ATTACKER_OVERTIME_HINT" );
	}
	else
	{
		util::setObjectiveText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER" );
		util::setObjectiveText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER" );
			util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
		}
		else
		{
			util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER_SCORE" );
			util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE" );
		}
		util::setObjectiveHintText( game["attackers"], &"OBJECTIVES_DEM_ATTACKER_HINT" );
		util::setObjectiveHintText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT" );
	}

	bombZones = getEntArray( level.demBombzoneName, "targetname" );
	if ( bombZones.size == 0 )
		level.demBombzoneName = "bombzone";
	
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	spawnlogic::drop_spawn_points( "mp_dem_spawn_attacker_a" );
	spawnlogic::drop_spawn_points( "mp_dem_spawn_attacker_b" );
	spawnlogic::drop_spawn_points( "mp_dem_spawn_defender_a" );
	spawnlogic::drop_spawn_points( "mp_dem_spawn_defender_b" );
	if ( !isdefined( game["overtime_round"] ) )
	{ 
		spawnlogic::place_spawn_points( "mp_dem_spawn_defender_start" );
		spawnlogic::place_spawn_points( "mp_dem_spawn_attacker_start" );
	}
	else
	{
		spawnlogic::place_spawn_points( "mp_dem_spawn_attackerot_start" );
		spawnlogic::place_spawn_points( "mp_dem_spawn_defenderot_start" );
	}
	spawnlogic::add_spawn_points( game["attackers"], "mp_dem_spawn_attacker" );
	spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender" );
	if ( !isdefined( game["overtime_round"] ) )
	{
		spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender_a" );
		spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender_b" );
	}	
	
	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
		
	level.spawn_start = [];
	
	if ( isdefined( game["overtime_round"] ) )
	{	
		level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array( "mp_dem_spawn_attackerot_start" );
	 	level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array( "mp_dem_spawn_defenderot_start" );
	}
	else
	{	
		level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array( "mp_dem_spawn_defender_start" );
		level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array( "mp_dem_spawn_attacker_start" );
	}
	thread updateGametypeDvars();
	
	thread bombs();
}


function onSpawnPlayer(predictedSpawn)
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;
	
	spawning::onSpawnPlayer(predictedSpawn);
}


function dem_playerSpawnedCB()
{
	level notify ( "spawned_player" );
}


function onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread checkAllowSpectating();
	
	bombZone = undefined;
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		if ( !isdefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
		{
			dist = Distance2d(self.origin, level.bombZones[index].curorigin);
			if ( dist < level.defaultOffenseRadius )
			{
				bombZone = level.bombZones[index];
				break;
			}
			dist = Distance2d(attacker.origin, level.bombZones[index].curorigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inBombZone = true;
				break;
			}
		}
	}
	

	if ( isdefined( bombZone ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{		
		if ( bombZone gameobjects::get_owner_team() != attacker.team )
		{
			if ( !isdefined( attacker.dem_offends ) )
				attacker.dem_offends = 0;
				
			attacker.dem_offends++;

			if ( level.playerOffensiveMax >= attacker.dem_offends )
			{
				attacker medals::offenseGlobalCount();
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
				self RecordKillModifier("defending");
				scoreevents::processScoreEvent( "killed_defender", attacker, self, weapon );
			}
			else
			{
				/#
					attacker IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU OFFENSIVE CREDIT AS BOOSTING PREVENTION" );
				#/
			}
		}
		else
		{			
			if ( !isdefined( attacker.dem_defends ) )
				attacker.dem_defends = 0;

			attacker.dem_defends++;
			
			if ( level.playerDefensiveMax >= attacker.dem_defends )
			{
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker medals::defenseGlobalCount();
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
				self RecordKillModifier("assaulting");
				scoreevents::processScoreEvent( "killed_attacker", attacker, self, weapon );
			}
			else
			{
				/#
					attacker IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU DEFENSIVE CREDIT AS BOOSTING PREVENTION" );
				#/
			}
		}
	}

	if( self.isPlanting == true )
		self RecordKillModifier("planting");

	if( self.isDefusing == true )
		self RecordKillModifier("defusing");
}


function checkAllowSpectating()
{
	self endon("disconnect");

	{wait(.05);};
	
	update = false;

	livesLeft = !(level.numLives && !self.pers["lives"]);

	if ( !level.aliveCount[ game["attackers"] ] && !livesLeft )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] && !livesLeft )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		spectating::update_settings();
}


function dem_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) && ( winningTeam != "tie" ) )
		globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
	
	thread globallogic::endGame( winningTeam, endReasonText );
}

function onDeadEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	if ( team == "all" )
	{
		if ( level.bombPlanted )
			dem_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
		else
			dem_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;
		
		dem_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		dem_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}


function onOneLeftEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	//if ( team == game["attackers"] )
	warnLastPlayer( team );
}


function onTimeLimit()
{
	if ( isdefined( game["overtime_round"] ) )
	{
		dem_endGame( "tie", game["strings"]["time_limit_reached"] );
	}
	else
	{	
		if ( level.teamBased )
		{
			bombZonesLeft = 0;
			
			for ( index = 0; index < level.bombZones.size; index++ )
			{
				if ( !isdefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
					bombZonesLeft++;
			}
			if ( bombZonesLeft == 0 )
			{
				dem_endGame( game["attackers"], game["strings"]["target_destroyed"] );
			}
			else 
			{
				dem_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
			}
		}
		else
			dem_endGame( "tie", game["strings"]["time_limit_reached"] );
	}
}


function warnLastPlayer( team )
{
	if ( !isdefined( level.warnedLastPlayer ) )
		level.warnedLastPlayer = [];
	
	if ( isdefined( level.warnedLastPlayer[team] ) )
		return;
		
	level.warnedLastPlayer[team] = true;

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( isdefined( player.pers["team"] ) && player.pers["team"] == team && isdefined( player.pers["class"] ) )
		{
			if ( player.sessionstate == "playing" && !player.afk )
				break;
		}
	}
	
	if ( i == players.size )
		return;
	
	players[i] thread giveLastAttackerWarning();
}


function giveLastAttackerWarning()
{
	self endon("death");
	self endon("disconnect");
	
	fullHealthTime = 0;
	interval = .05;
	
	while(1)
	{
		if ( self.health != self.maxhealth )
			fullHealthTime = 0;
		else
			fullHealthTime += interval;
		
		wait interval;
		
		if (self.health == self.maxhealth && fullHealthTime >= 3)
			break;
	}
	
	//self iprintlnbold(&"MP_YOU_ARE_THE_ONLY_REMAINING_PLAYER");
	self globallogic_audio::leader_dialog_on_player( "roundSuddenDeath" );
}


function updateGametypeDvars()
{
	level.plantTime = GetGametypeSetting( "plantTime" );
	level.defuseTime = GetGametypeSetting( "defuseTime" );
	level.bombTimer = GetGametypeSetting( "bombTimer" );
	level.extraTime = GetGametypeSetting( "extraTime" );
	level.overtimeTimeLimit = GetGametypeSetting( "OvertimetimeLimit" );

	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );
	level.playerEventsLPM = GetGametypeSetting( "maxPlayerEventsPerMinute" );
	level.bombEventsLPM = GetGametypeSetting( "maxObjectiveEventsPerMinute" );
	level.playerOffensiveMax = GetGametypeSetting( "maxPlayerOffensive" );
	level.playerDefensiveMax = GetGametypeSetting( "maxPlayerDefensive" );
}

function resetBombZone()
{
	if ( isdefined( game["overtime_round"] ) )
	{
		self gameobjects::set_owner_team( "neutral" );
		self gameobjects::allow_use( "any" );
	}
	else
	{
		self gameobjects::allow_use( "enemy" );
	}
	self gameobjects::set_use_time( level.plantTime );
	self gameobjects::set_use_text( &"MP_PLANTING_EXPLOSIVE" );
	self gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	self gameobjects::set_key_object( level.ddBomb );
	self gameobjects::set_2d_icon( "friendly", "waypoint_defend" + self.label );
	self gameobjects::set_3d_icon( "friendly", "waypoint_defend" + self.label );
	self gameobjects::set_2d_icon( "enemy", "waypoint_target" + self.label );
	self gameobjects::set_3d_icon( "enemy", "waypoint_target" + self.label );
	self gameobjects::set_visible_team( "any" );
	self.useWeapon = GetWeapon( "briefcase_bomb" );
}

function setUpForDefusing()
{
	self gameobjects::allow_use( "friendly" );
	self gameobjects::set_use_time( level.defuseTime );
	self gameobjects::set_use_text( &"MP_DEFUSING_EXPLOSIVE" );
	self gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	self gameobjects::set_key_object( undefined );
	self gameobjects::set_2d_icon( "friendly", "compass_waypoint_defuse" + self.label );
	self gameobjects::set_3d_icon( "friendly", "waypoint_defuse" + self.label );
	self gameobjects::set_2d_icon( "enemy", "compass_waypoint_defend" + self.label );
	self gameobjects::set_3d_icon( "enemy", "waypoint_defend" + self.label );
	self gameobjects::set_visible_team( "any" );
}


function bombs()
{
	level.bombAPlanted = false;
	level.bombBPlanted = false;
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = false;
	
	sdBomb = getEnt( "sd_bomb", "targetname" );
	if ( isdefined( sdBomb ) )
		sdBomb delete();

	level.bombZones = [];
	
	bombZones = getEntArray( level.demBombzoneName, "targetname" );
	
	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		scriptLabel = trigger.script_label;		
		visuals = getEntArray( bombZones[index].target, "targetname" );
		clipBrushes = getEntArray( "bombzone_clip"+scriptLabel, "targetname" );
		defuseTrig = getent( visuals[0].target, "targetname" );
		
		bombSiteTeamOwner = game["defenders"];
		bombSiteAllowUse = "enemy";
		if ( isdefined( game["overtime_round"] ) )
		{
			if ( scriptLabel != "_overtime" )
			{
				trigger delete();
				defuseTrig delete();
				visuals[0] delete();
				foreach ( clip in clipBrushes )
				{
					clip delete();
				}
				continue;
			}
			bombSiteTeamOwner = "neutral";
			bombSiteAllowUse = "any";
			scriptLabel = "_a";
		}
		else if ( scriptLabel == "_overtime" )
		{
			trigger delete();
			defuseTrig delete();
			visuals[0] delete();
			foreach ( clip in clipBrushes )
			{
				clip delete();
			}
			continue;
		}
		
		name = istring("dem" + scriptLabel);

		bombZone = gameobjects::create_use_object( bombSiteTeamOwner, trigger, visuals, (0,0,0), name );
		bombZone gameobjects::allow_use( bombSiteAllowUse );
		bombZone gameobjects::set_use_time( level.plantTime );
		bombZone gameobjects::set_use_text( &"MP_PLANTING_EXPLOSIVE" );
		bombZone gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		bombZone gameobjects::set_key_object( level.ddBomb );

		bombZone.label = scriptLabel;
		bombZone.index = index;
		bombZone gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" + scriptLabel );
		bombZone gameobjects::set_3d_icon( "friendly", "waypoint_defend" + scriptLabel );
		bombZone gameobjects::set_2d_icon( "enemy", "compass_waypoint_target" + scriptLabel );
		bombZone gameobjects::set_3d_icon( "enemy", "waypoint_target" + scriptLabel );
		bombZone gameobjects::set_visible_team( "any" );
		bombZone.onBeginUse =&onBeginUse;
		bombZone.onEndUse =&onEndUse;
		bombZone.onUse =&onUseObject;
		bombZone.onCantUse =&onCantUse;
		bombZone.useWeapon = GetWeapon( "briefcase_bomb" );
		bombZone.visuals[0].killCamEnt = spawn( "script_model", bombZone.visuals[0].origin + (0,0,128) );
	
		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isdefined( visuals[i].script_exploder ) )
			{
				bombZone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		
		level.bombZones[level.bombZones.size] = bombZone;
		
		bombZone.bombDefuseTrig = defuseTrig;
		assert( isdefined( bombZone.bombDefuseTrig ) );
		bombZone.bombDefuseTrig.origin += (0,0,-10000);
		bombZone.bombDefuseTrig.label = scriptLabel;
		
		// Add spawn influencer
		team_mask = util::getTeamMask( game["attackers"] );
		bombZone.spawnInfluencer = bombZone spawning::create_influencer( "dem_enemy_base", trigger.origin, team_mask );
	}
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		array = [];
		for ( otherindex = 0; otherindex < level.bombZones.size; otherindex++ )
		{
			if ( otherindex != index )
				array[ array.size ] = level.bombZones[otherindex];
		}
		level.bombZones[index].otherBombZones = array;
	}
}

function onBeginUse( player )
{
	timeRemaining = globallogic_utils::getTimeRemaining();
	if (timeRemaining <= level.plantTime * 1000 )
	{
		//setGameEndTime( 0 );
		globallogic_utils::pauseTimer();
		level.hasPausedTimer = true;
	}	

				
	if ( self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		player playSound( "mpl_sd_bomb_defuse" );
		player.isDefusing = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_enemyplant", player.pers["team"] );

		bestDistance = 9000000;
		closestBomb = undefined;
		
		if ( isdefined( level.ddBombModel ) )
		{
			keys = GetArrayKeys( level.ddBombModel );
			for ( bombLabel = 0; bombLabel < keys.size; bombLabel++ )
			{
				bomb = level.ddBombModel[ keys[bombLabel] ];
				
				if ( !isdefined( bomb ) )
					continue;
				
				dist = distanceSquared( player.origin, bomb.origin );
				
				if (  dist < bestDistance )
				{
					bestDistance = dist;			
					closestBomb = bomb;
				}
			}
			
			assert( isdefined(closestBomb) );
			player.defusing = closestBomb;
			closestBomb hide();
		}
	}
	else
	{
		player.isPlanting = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_friendlyplant", player.pers["team"] );
	}
		player playSound( "fly_bomb_raise_plr" );
}

function onEndUse( team, player, result )
{
	if ( !isdefined( player ) )
		return;
		
	if ( !level.bombAPlanted && !level.bombBPlanted )
		{
				globallogic_utils::resumeTimer();
				level.hasPausedTimer = false;
	  }
	 	
	player.isDefusing = false;
	player.isPlanting = false;
	player notify( "event_ended" );

	if ( self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		if ( isdefined( player.defusing ) && !result )
		{
			player.defusing show();
		}
	}
}

function onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

function onUseObject( player )
{
	team = player.team;
  enemyTeam = util::getOtherTeam( team );
  
	self updateEventsPerMinute();
	player updateEventsPerMinute();

	// planted the bomb
	if ( !self gameobjects::is_friendly_team( team ) )
	{
		self gameobjects::set_flags( 1 );
		
		level thread bombPlanted( self, player );
		/#print( "bomb planted: " + self.label );#/
		
		bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombplant", self.label, team, player.origin );

// removed plant audio until finalization of assest TODO : new plant sounds when assests are online
//		player playSound( "mpl_sd_bomb_plant" );
		player notify ( "bomb_planted" );
		
		thread globallogic_audio::set_music_on_team( "DEM_WE_PLANT", team, 5  );
	  	thread globallogic_audio::set_music_on_team( "DEM_THEY_PLANT", enemyTeam, 5  );
		
		if( isdefined(player.pers["plants"]) )
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}

		if ( !isScoreBoosting( player, self ) )
		{
			demo::bookmark( "event", gettime(), player );
			player AddPlayerStatWithGameType( "PLANTS", 1 );
			
			scoreevents::processScoreEvent( "planted_bomb", player );
			player RecordGameEvent("plant");
		}
		else
		{
			/#
				player IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU PLANT CREDIT AS BOOSTING PREVENTION" );
			#/
		}
		
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_PLANTED_BY", player );
		globallogic_audio::leader_dialog( "bombPlanted" );
	}
	else
	{
		self gameobjects::set_flags( 0 );
		
		player notify ( "bomb_defused" );
		/#print( "bomb defused: " + self.label );#/
		self thread bombDefused();
		self resetBombzone();
		
		bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombdefused", self.label, team, player.origin );

		if( isdefined(player.pers["defuses"]) )
		{
			player.pers["defuses"]++;
			player.defuses = player.pers["defuses"];
		}

		if ( !isScoreBoosting( player, self ) )
		{
			demo::bookmark( "event", gettime(), player );
			player AddPlayerStatWithGameType( "DEFUSES", 1 );
			
			scoreevents::processScoreEvent( "defused_bomb", player );
			player RecordGameEvent("defuse");
		}
		else
		{
			/#
				player IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU DEFUSE CREDIT AS BOOSTING PREVENTION" );
			#/
		}
		
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_DEFUSED_BY", player );
	
		thread globallogic_audio::set_music_on_team( "DEM_WE_DEFUSE", team, 5  );
		thread globallogic_audio::set_music_on_team( "DEM_THEY_DEFUSE", enemyTeam, 5  );
		
		globallogic_audio::leader_dialog( "bombDefused" );
	}
}

function onDrop( player )
{
	if ( !level.bombPlanted )
	{
		globallogic_audio::leader_dialog( "bombFriendlyDropped", player.pers["team"] );
		/#
		if ( isdefined( player ) )
		 	print( "bomb dropped" );
		 else
		 	print( "bomb dropped" );
		#/
	}

	player notify( "event_ended" );

	self gameobjects::set_3d_icon( "friendly", "waypoint_bomb" );
	
	sound::play_on_players( game["bomb_dropped_sound"], game["attackers"] );
}


function onPickup( player )
{
	player.isBombCarrier = true;

	self gameobjects::set_3d_icon( "friendly", "waypoint_defend" );

	if ( !level.bombDefused )
	{			
		thread sound::play_on_players( "mus_sd_pickup"+"_"+level.teamPostfix[player.pers["team"]], player.pers["team"] );

		globallogic_audio::leader_dialog( "bombFriendlyTaken", player.pers["team"] );
		/#print( "bomb taken" );#/
	}		
	sound::play_on_players( game["bomb_recovered_sound"], game["attackers"] );
}


function onReset()
{
}

function bombReset( label, reason )
{
	if ( label == "_a" )
	{
		level.bombAPlanted = false;
		SetBombTimer( "A", 0 );
	}
	else 
	{
		level.bombBPlanted = false;
		SetBombTimer( "B", 0 );
	}

	setMatchFlag( "bomb_timer" + label, 0 );
	
	if ( !level.bombAPlanted && !level.bombBPlanted )
	globallogic_utils::resumeTimer();

	self.visuals[0] globallogic_utils::stopTickingSound();
}

function dropBombModel( player, site )
{
	trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
		
	tempAngle = randomfloat( 360 );
	forward = (cos( tempAngle ), sin( tempAngle ), 0);
	forward = vectornormalize( forward - VectorScale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
	dropAngles = vectortoangles( forward );

	if ( IsDefined( trace[ "surfacetype" ] ) && trace[ "surfacetype" ] == "water" )
	{
		phystrace = playerPhysicsTrace( player.origin + (0,0,20), player.origin - (0,0,2000) );

		if ( IsDefined( phystrace ) )
		{
			trace["position"] = phystrace;
		}
	}

	level.ddBombModel[ site ] = spawn( "script_model", trace["position"] );
	level.ddBombModel[ site ].angles = dropAngles;
	level.ddBombModel[ site ] setModel( "p7_mp_suitcase_bomb" );
}


function bombPlanted( destroyedObj, player )
{
	level endon( "game_ended" );
	destroyedObj endon( "bomb_defused" );
	team = player.team;	
	game["challenge"][team]["plantedBomb"] = true;
	
	globallogic_utils::pauseTimer();
	destroyedObj.bombPlanted = true;
	
	destroyedObj.visuals[0] thread globallogic_utils::playTickingSound( "mpl_sab_ui_suitcasebomb_timer" );
	destroyedObj.tickingObject = destroyedObj.visuals[0];
	
	label = destroyedObj.label;
	
	detonateTime = int( gettime() + (level.bombTimer * 1000) );
	updateBombTimers(label, detonateTime);
	destroyedObj.detonateTime = detonateTime;

	trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
	
	self dropBombModel( player, destroyedObj.label );
	destroyedObj gameobjects::allow_use( "none" );
	destroyedObj gameobjects::set_visible_team( "none" );
	if ( isdefined( game["overtime_round"] ) )
	{
		destroyedObj gameobjects::set_owner_team( util::getOtherTeam( player.team ) );
	}
	destroyedObj setUpForDefusing();
		
	player.isBombCarrier = false;
	game["challenge"][team]["plantedBomb"] = true;
	
	destroyedObj waitLongDurationWithBombTimeUpdate( label, level.bombTimer );
	destroyedObj bombReset( label, "bomb_exploded" );
	
	if ( level.gameEnded )
	{
		return;
	}
	
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dem_bombexplode", label, team, player.origin );

	destroyedObj.bombExploded = true;	
	game["challenge"][team]["destroyedBombSite"] = true;
	explosionOrigin = destroyedObj.curorigin;
	
	level.ddBombModel[ destroyedObj.label ] Delete();
	
	if ( isdefined( player ) )
	{
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
		
		player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_BLOWUP_BY", player );
		// give points for being the bomb destroyer for extra game mode incentive
		scoreevents::processScoreEvent( "bomb_detonated", player );
		player RecordGameEvent("destroy");
	}
	else
	{
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
	}
	
	currentTime = getTime();

	if ( isdefined( level.lastBombExplodeTime ) && level.lastBombExplodeByTeam == player.team )
	{
		if ( level.lastBombExplodeTime + 10000 > currentTime )
		{
			for ( i = 0; i < level.players.size; i++ )
			{
				if ( level.players[i].team == player.team )
				{
					level.players[i] challenges::bothBombsDetonateWithinTime();
				}
			}
		}
	}
	level.lastBombExplodeTime = currentTime;
	level.lastBombExplodeByTeam = player.team;
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread sound::play_in_space( "mpl_sd_exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isdefined( destroyedObj.exploderIndex ) )
		exploder::exploder( destroyedObj.exploderIndex );
		
	bombZonesLeft = 0;
		
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		if ( !isdefined( level.bombZones[index].bombExploded ) || !level.bombZones[index].bombExploded )
			bombZonesLeft++;
	}
		
	destroyedObj gameobjects::disable_object();
	
	if ( bombZonesLeft == 0 )
	{
		
		globallogic_utils::pauseTimer();
		level.hasPausedTimer = true;
		setGameEndTime( 0 );
		wait 3;
		dem_endGame( team, game["strings"]["target_destroyed"] );
	}
	else
	{
	    enemyTeam = util::getOtherTeam( team );
		
		thread globallogic_audio::set_music_on_team( "DEM_WE_SCORE", team, 5  );
		thread globallogic_audio::set_music_on_team( "DEM_THEY_SCORE", enemyTeam, 5  );
	    
	    //level thread play_one_left_underscore( team, enemyTeam );
		
	    if( [[level.getTimeLimit]]() > 0 )
		{
			level.usingExtraTime = true;
		}

		// remove the influencer on this object
		destroyedObj spawning::remove_influencer( destroyedObj.spawnInfluencer );
		destroyedObj.spawnInfluencer = undefined;

		spawnlogic::clear_spawn_points();			
		spawnlogic::add_spawn_points( game["attackers"], "mp_dem_spawn_attacker" );
		spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender" );
		if ( label == "_a" )
		{
			spawnlogic::add_spawn_points( game["attackers"], "mp_dem_spawn_attacker_a" );
			spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender_b" );
		}
		else
		{
			spawnlogic::add_spawn_points( game["attackers"], "mp_dem_spawn_attacker_b" );
			spawnlogic::add_spawn_points( game["defenders"], "mp_dem_spawn_defender_a" );
		}
		spawning::updateAllSpawnPoints();
	}
}

function getTimeLimit()
{
	timeLimit = globallogic_defaults::default_getTimeLimit();
	if ( isdefined( game["overtime_round"] ) )
	{
		timeLimit = level.overtimeTimeLimit;
	}
	if ( level.usingExtraTime )
		return timeLimit + level.extraTime;
	return timeLimit;
	
}

function shouldPlayOvertimeRound()
{
	if ( isdefined( game["overtime_round"] ) )
	{
		return false;
	}
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		return true;
	}
	
	return false;
}

function waitLongDurationWithBombTimeUpdate( whichBomb, duration )
{
	if ( duration == 0 )
		return;
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		hostmigration::waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		while ( isdefined( level.hostMigrationTimer ) )
		{
			endTime += 250;
			updateBombTimers(whichBomb, endTime);
			wait 0.25;
		}
	}
	/#
	if( gettime() != endtime )
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);
	#/	
	while ( isdefined( level.hostMigrationTimer ) )
	{
		endTime += 250;
		updateBombTimers(whichBomb, endTime);
		wait 0.250;
	}
	
	return gettime() - starttime;
}

function updateBombTimers(whichBomb, detonateTime)
{
	if ( whichBomb == "_a" )
	{
		level.bombAPlanted = true;
		SetBombTimer( "A", int(detonateTime) );
	}
	else
	{
		level.bombBPlanted = true;
		SetBombTimer( "B", int(detonateTime) );
	}

	setMatchFlag( "bomb_timer" + whichBomb, int(detonateTime) );
}

function bombDefused()
{
	self.tickingObject globallogic_utils::stopTickingSound();
	self gameobjects::allow_use( "none" );
	self gameobjects::set_visible_team( "none" );
	self.bombDefused = true;
	self notify( "bomb_defused" );
	self.bombPlanted = false;
	self bombReset( self.label, "bomb_defused" );
}

function play_one_left_underscore( team, enemyTeam )
{
    wait(3);
    
    if( (!isdefined(team)) || (!isdefined(enemyTeam)) )
    {
        return;
    }
    
    thread globallogic_audio::set_music_on_team( "DEM_ONE_LEFT_UNDERSCORE", team );
	thread globallogic_audio::set_music_on_team( "DEM_ONE_LEFT_UNDERSCORE", enemyTeam );
}

function updateEventsPerMinute()
{
	if ( !isdefined( self.eventsPerMinute ) )
	{
		self.numBombEvents = 0;
		self.eventsPerMinute = 0;
	}
	
	self.numBombEvents++;
	
	minutesPassed = globallogic_utils::getTimePassed() / ( 60 * 1000 );
	
	// players use the actual time played
	if ( IsPlayer( self ) && isdefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.eventsPerMinute = self.numBombEvents / minutesPassed;
	if ( self.eventsPerMinute > self.numBombEvents )
		self.eventsPerMinute = self.numBombEvents;
}

function isScoreBoosting( player, flag )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.eventsPerMinute > level.playerEventsLPM )
		return true;
			
	if ( flag.eventsPerMinute > level.bombEventsLPM )
	  return true;
	  
 return false;
}

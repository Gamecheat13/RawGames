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
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;

#using scripts\mp\_util;

// Rallypoints should be destroyed on leaving your team/getting killed
// Compass icons need to be looked at
// Doesn't seem to be setting angle on spawn so that you are facing your rallypoint

/*
	Search and Destroy
	Attackers objective: Bomb one of 2 positions
	Defenders objective: Defend these 2 positions / Defuse planted bombs
	Round ends:	When one team is eliminated, bomb explodes, bomb is defused, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Bombzones:
			classname					trigger_multiple
			targetname					bombzone
			script_gameobjectname		bombzone
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



	



#precache( "fx", "explosions/fx_exp_bomb_demo_mp" );
#precache( "material","compass_waypoint_target" );
#precache( "material","compass_waypoint_target_a" );
#precache( "material","compass_waypoint_target_b" );
#precache( "material","compass_waypoint_defend" );
#precache( "material","compass_waypoint_defend_a" );
#precache( "material","compass_waypoint_defend_b" );
#precache( "material","compass_waypoint_defuse" );
#precache( "material","compass_waypoint_defuse_a" );
#precache( "material","compass_waypoint_defuse_b" );
#precache( "material", "waypoint_dogtags" );
#precache( "model", "p7_mp_suitcase_bomb" );
#precache( "objective", "sd_bomb" );
#precache( "objective", "sd_a" );	
#precache( "objective", "sd_defuse_a" );	
#precache( "objective", "sd_b" );	
#precache( "objective", "sd_defuse_b" );	
#precache( "string", "OBJECTIVES_SD_ATTACKER" );
#precache( "string", "OBJECTIVES_SD_DEFENDER" );
#precache( "string", "OBJECTIVES_SD_ATTACKER_SCORE" );
#precache( "string", "OBJECTIVES_SD_DEFENDER_SCORE" );
#precache( "string", "OBJECTIVES_SD_ATTACKER_HINT" );
#precache( "string", "OBJECTIVES_SD_DEFENDER_HINT" );
#precache( "string", "MP_EXPLOSIVES_BLOWUP_BY" );
#precache( "string", "MP_EXPLOSIVES_RECOVERED_BY" );
#precache( "string", "MP_EXPLOSIVES_DROPPED_BY" );
#precache( "string", "MP_EXPLOSIVES_PLANTED_BY" );
#precache( "string", "MP_EXPLOSIVES_DEFUSED_BY" );
#precache( "string", "PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
#precache( "string", "PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
#precache( "string", "MP_CANT_PLANT_WITHOUT_BOMB" );	
#precache( "string", "MP_PLANTING_EXPLOSIVE" );	
#precache( "string", "MP_DEFUSING_EXPLOSIVE" );	
#precache( "string", "MP_TARGET_DESTROYED" );
#precache( "string", "MP_BOMB_DEFUSED" );
#precache( "string", "bomb" );

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
	level.playerSpawnedCB =&sr_playerSpawnedCB;
	level.onPlayerKilled =&onPlayerKilled;
	level.onDeadEvent =&onDeadEvent;
	level.onOneLeftEvent =&onOneLeftEvent;
	level.onTimeLimit =&onTimeLimit;
	level.onRoundSwitch =&onRoundSwitch;
	level.getTeamKillPenalty =&sr_getTeamKillPenalty;
	level.getTeamKillScore =&sr_getTeamKillScore;
	level.isKillBoosting =&sr_isKillBoosting;
	
	level.endGameOnScoreLimit = false;
	
	gameobjects::register_allowed_gameobject( "sd" );
	gameobjects::register_allowed_gameobject( "bombzone" );
	gameobjects::register_allowed_gameobject( "blocker" );

	globallogic_audio::set_leader_gametype_dialog ( "startSearchAndRescue", "hcStartSearchAndRescue", "objDestroy", "objDefend" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "plants", "defuses", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "plants", "defuses" );
}

function onPrecacheGameType()
{
	//game["bombmodelname"] = "weapon_explosives";
	//game["bombmodelnameobj"] = "weapon_explosives";
	game["bomb_dropped_sound"] = "fly_bomb_drop_plr";
	game["bomb_recovered_sound"] = "fly_bomb_pickup_plr";
}

function sr_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_penalty = globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon );

	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) || ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

function sr_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, weapon )
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
	SetMatchFlag( "bomb_timer_a", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
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
	
	util::setObjectiveText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
	util::setObjectiveText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
		util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
	}
	else
	{
		util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_SCORE" );
		util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE" );
	}
	util::setObjectiveHintText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_HINT" );
	util::setObjectiveHintText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT" );

	dogtags::init();
	
	initSpawns();

	thread updateGametypeDvars();
	
	thread bombs();
}

function initSpawns()
{
	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	spawnlogic::place_spawn_points( "mp_sd_spawn_attacker" );
	spawnlogic::place_spawn_points( "mp_sd_spawn_defender" );
	
	foreach( team in level.teams )
	{
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
	}

	spawning::updateAllSpawnPoints();

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_start = [];
	
	level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array( "mp_sd_spawn_defender" );
	level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array( "mp_sd_spawn_attacker" );
}

function onSpawnPlayer(predictedSpawn)
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;
	
	spawning::onSpawnPlayer(predictedSpawn);
	
	dogtags::on_spawn_player();
}

function sr_playerSpawnedCB()
{
	level notify ( "spawned_player" );
}


function onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread checkAllowSpectating();
	
	if ( isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"])
	{
		scoreevents::processScoreEvent( "kill_sd", attacker, self, weapon );
	}
	
	inBombZone = false;

	for ( index = 0; index < level.bombZones.size; index++ )
	{
		dist = Distance2d(self.origin, level.bombZones[index].curorigin);
		if ( dist < level.defaultOffenseRadius )
			inBombZone = true;
	}
	
	if ( inBombZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{	
		if ( game["defenders"] == self.pers["team"] )
		{
			attacker medals::offenseGlobalCount();
			attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
			self RecordKillModifier("defending");
			scoreevents::processScoreEvent( "killed_defender", attacker, self, weapon );
		}
		else
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
	}
	
	if ( isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] && isdefined( self.isBombCarrier ) && self.isBombCarrier == true )
	{
		self RecordKillModifier("carrying");
	}

	if( self.isPlanting == true )
		self RecordKillModifier("planting");

	if( self.isDefusing == true )
		self RecordKillModifier("defusing");
		
	should_spawn_tags = self should_spawn_tags(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	
	// we should spawn tags if one the previous statements were true and we may not spawn
	should_spawn_tags = should_spawn_tags && !globallogic_spawn::maySpawn();
	
	if( should_spawn_tags )
		level thread dogtags::spawn_dog_tag( self, attacker, &onUseDogTag, false );
}


//self is victim
function should_spawn_tags( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( IsAlive( self ) )
		return false;
		
	//no on switching teams
	if ( IsDefined( self.switching_teams ) )
		return false;
	
	//no on suicide
	if ( isDefined( attacker ) && attacker == self )
		return false;
	
	//no on TK
	if ( level.teamBased && isDefined( attacker ) && isDefined( attacker.team ) && attacker.team == self.team )
		return false;
	
	//no on world suicides
	if	(
			IsDefined( attacker )
		&&	( !IsDefined( attacker.team ) || attacker.team == "free" )
	    &&	( attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" )
		)
		return false;
	
	return true;
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


function sr_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		globallogic_score::giveTeamScoreForObjective_DelayPostProcessing( winningTeam, 1 );

	thread globallogic::endGame( winningTeam, endReasonText );
}

function sr_endGameWithKillcam( winningTeam, endReasonText )
{
	sr_endGame( winningTeam, endReasonText );
}


function onDeadEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	if ( team == "all" )
	{
		if ( level.bombPlanted )
			sr_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
		else
			sr_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;
		
		sr_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		sr_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
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
	if ( level.teamBased )
		sr_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
	else
		sr_endGame( undefined, game["strings"]["time_limit_reached"] );
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
	
	players[i] thread giveLastAttackerWarning( team );
	

}


function giveLastAttackerWarning( team )
{
	self endon("death");
	self endon("disconnect");
	
	fullHealthTime = 0;
	interval = .05;
	
	self.lastManSD = true;

	enemyTeam = game["defenders"];
	
	if ( team == enemyTeam ) 
	{
		enemyTeam = game["attackers"];
	}

	
	if ( level.aliveCount[enemyTeam] > 2 )
	{
		self.lastManSDDefeat3Enemies = true;
	}


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

	self globallogic_audio::leader_dialog_on_player( "roundEncourageLastPlayer" );
	self playlocalsound ("mus_last_stand");	
}


function updateGametypeDvars()
{
	level.plantTime = GetGametypeSetting( "plantTime" );
	level.defuseTime = GetGametypeSetting( "defuseTime" );
	level.bombTimer = GetGametypeSetting( "bombTimer" );
	level.multiBomb = GetGametypeSetting( "multiBomb" );

	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );
	
	level.playerKillsMax = GetGametypeSetting( "playerKillsMax" );
	level.totalKillsMax = GetGametypeSetting( "totalKillsMax" );
}

function bombs()
{
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = false;

	trigger = getEnt( "sd_bomb_pickup_trig", "targetname" );
	if ( !isdefined( trigger ) )
	{
		/#util::error("No sd_bomb_pickup_trig trigger found in map.");#/
		return;
	}
	
	visuals[0] = getEnt( "sd_bomb", "targetname" );
	if ( !isdefined( visuals[0] ) )
	{
		/#util::error("No sd_bomb script_model found in map.");#/
		return;
	}

	//visuals[0] setModel( "weapon_explosives" );
	
	if ( !level.multiBomb )
	{
		level.sdBomb = gameobjects::create_carry_object( game["attackers"], trigger, visuals, (0,0,32), &"sd_bomb" );
		level.sdBomb gameobjects::allow_carry( "friendly" );
		level.sdBomb gameobjects::set_2d_icon( "friendly", "compass_waypoint_bomb" );
		level.sdBomb gameobjects::set_3d_icon( "friendly", "waypoint_bomb" );
		level.sdBomb gameobjects::set_visible_team( "friendly" );
		level.sdBomb gameobjects::set_carry_icon( "hud_suitcase_bomb" );
		level.sdBomb.allowWeapons = true;
		level.sdBomb.onPickup =&onPickup;
		level.sdBomb.onDrop =&onDrop;
	}
	else
	{
		trigger delete();
		visuals[0] delete();
	}
	
	
	level.bombZones = [];
	
	bombZones = getEntArray( "bombzone", "targetname" );
	
	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals = getEntArray( bombZones[index].target, "targetname" );
				
		name = istring("sd"+trigger.script_label);
		
		bombZone = gameobjects::create_use_object( game["defenders"], trigger, visuals, (0,0,0), name );
		bombZone gameobjects::allow_use( "enemy" );
		bombZone gameobjects::set_use_time( level.plantTime );
		bombZone gameobjects::set_use_text( &"MP_PLANTING_EXPLOSIVE" );
		bombZone gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		if ( !level.multiBomb )
			bombZone gameobjects::set_key_object( level.sdBomb );
		label = bombZone gameobjects::get_label();
		bombZone.label = label;
		bombZone gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" + label );
		bombZone gameobjects::set_3d_icon( "friendly", "waypoint_defend" + label );
		bombZone gameobjects::set_2d_icon( "enemy", "compass_waypoint_target" + label );
		bombZone gameobjects::set_3d_icon( "enemy", "waypoint_target" + label );
		bombZone gameobjects::set_visible_team( "any" );
		bombZone.onBeginUse =&onBeginUse;
		bombZone.onEndUse =&onEndUse;
		bombZone.onUse =&onUsePlantObject;
		bombZone.onCantUse =&onCantUse;
		bombZone.useWeapon = GetWeapon( "briefcase_bomb" );
		bombZone.visuals[0].killCamEnt = spawn( "script_model", bombZone.visuals[0].origin + (0,0,128) );
		if ( !level.multiBomb )
		bombZone.trigger SetInvisibleToAll();
		
		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isdefined( visuals[i].script_exploder ) )
			{
				bombZone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		
		level.bombZones[level.bombZones.size] = bombZone;
		
		bombZone.bombDefuseTrig = getent( visuals[0].target, "targetname" );
		assert( isdefined( bombZone.bombDefuseTrig ) );
		bombZone.bombDefuseTrig.origin += (0,0,-10000);
		bombZone.bombDefuseTrig.label = label;
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
	if ( self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		player playSound( "mpl_sd_bomb_defuse" );
		player.isDefusing = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_enemyplant", player.pers["team"] );
		
		if ( isdefined( level.sdBombModel ) )
			level.sdBombModel hide();
	}
	else
	{
		player.isPlanting = true;
		player thread battlechatter::gametype_specific_battle_chatter( "sd_friendlyplant", player.pers["team"] );

		if ( level.multibomb )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] gameobjects::disable_object();
			}
		}
	}
		player playSound( "fly_bomb_raise_plr" );
}

function onEndUse( team, player, result )
{
	if ( !isdefined( player ) )
		return;
		
	player.isDefusing = false;
	player.isPlanting = false;
	player notify( "event_ended" );

	if ( self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		if ( isdefined( level.sdBombModel ) && !result )
		{
			level.sdBombModel show();
		}
	}
	else
	{
		if ( level.multibomb && !result )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] gameobjects::enable_object();
			}
		}
	}
}

function onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

function onUsePlantObject( player )
{
	// planted the bomb
	if ( !self gameobjects::is_friendly_team( player.pers["team"] ) )
	{
		self gameobjects::set_flags( 1 );
		level thread bombPlanted( self, player );
		/#print( "bomb planted: " + self.label );#/
		
		// disable all bomb zones except this one
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			if ( level.bombZones[index] == self )
			{
				level.bombZones[index].isPlanted = true;
				continue;
			}
				
			level.bombZones[index] gameobjects::disable_object();
		}
		thread sound::play_on_players( "mus_sd_planted"+"_"+level.teamPostfix[player.pers["team"]] );
// removed plant audio until finalization of assest TODO : new plant sounds when assests are online		
//		player playSound( "mpl_sd_bomb_plant" );
		player notify ( "bomb_planted" );
		
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_PLANTED_BY", player );

		if( isdefined(player.pers["plants"]) )
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}

		demo::bookmark( "event", gettime(), player );
		player AddPlayerStatWithGameType( "PLANTS", 1 );
		
		globallogic_audio::leader_dialog( "bombPlanted" );

		scoreevents::processScoreEvent( "planted_bomb", player );
		player RecordGameEvent("plant");
	}
}

function onUseDefuseObject( player )
{
	self gameobjects::set_flags( 0 );
	player notify ( "bomb_defused" );
	/#print( "bomb defused: " + self.label );#/
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "sd_bombdefuse", self.label, player.pers["team"], player.origin );
	level thread bombDefused();
	
	// disable this bomb zone
	self gameobjects::disable_object();
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		level.bombZones[index].isPlanted = false;
	}
	
	level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_DEFUSED_BY", player );

	if( isdefined(player.pers["defuses"]) )
	{
		player.pers["defuses"]++;
		player.defuses = player.pers["defuses"];
	}

	player AddPlayerStatWithGameType( "DEFUSES", 1 );
	demo::bookmark( "event", gettime(), player );
	
	globallogic_audio::leader_dialog( "bombDefused" );

	if ( isdefined( player.lastManSD ) && player.lastManSD == true )
	{
		scoreevents::processScoreEvent( "defused_bomb_last_man_alive", player );
	}
	else
	{
		scoreevents::processScoreEvent( "defused_bomb", player );
	}
	player RecordGameEvent("defuse");
}


function onDrop( player )
{
	if ( !level.bombPlanted )
	{
		globallogic_audio::leader_dialog( "bombFriendlyDropped", game["attackers"] );
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

	if ( isdefined(level.bombDropBotEvent) )
	{
		[[level.bombDropBotEvent]]();
	}
}


function onPickup( player )
{
	player.isBombCarrier = true;

	player RecordGameEvent("pickup"); 

	self gameobjects::set_3d_icon( "friendly", "waypoint_defend" );

	if ( !level.bombDefused )
	{
		if ( isdefined( player ) && isdefined( player.name ) )
		{
			player AddPlayerStatWithGameType( "PICKUPS", 1 );
		}
			
		//thread sound::play_on_players( "mus_sd_pickup"+"_"+level.teamPostfix[player.pers["team"]], player.pers["team"] );
		// New Music System
		team = self gameobjects::get_owner_team();
		otherTeam = util::getOtherTeam( team );
		
		globallogic_audio::leader_dialog( "bombFriendlyTaken", game["attackers"] );
		/#print( "bomb taken" );#/
	}		
	sound::play_on_players( game["bomb_recovered_sound"], game["attackers"] );

	for ( i = 0; i < level.bombZones.size; i++ )
	{
		level.bombZones[i].trigger SetInvisibleToAll();
		level.bombZones[i].trigger SetVisibleToPlayer( player );
	}

	if ( isdefined(level.bombPickupBotEvent) )
	{
		[[level.bombPickupBotEvent]]();
	}
}


function onReset()
{

}

function bombPlantedMusicDelay()
{
	level endon ("bomb_defused");
	//wait for 30 seconds until explosion
	
	time = (level.bombtimer - 30);
/#
	if( GetDvarint( "debug_music" ) > 0 )
	{		
		println ("Music System - waiting to set TIME_OUT: " + time );
	}
#/
	if (time > 1)
	{
		wait (time);
		thread globallogic_audio::set_music_on_team( "timeOut" );	
	}
}	

function bombPlanted( destroyedObj, player )
{
	globallogic_utils::pauseTimer();
	level.bombPlanted = true;
	team = player.pers["team"];
	
	destroyedObj.visuals[0] thread globallogic_utils::playTickingSound( "mpl_sab_ui_suitcasebomb_timer" );
	//Play suspense music
	level thread bombPlantedMusicDelay();				
	
	level.tickingObject = destroyedObj.visuals[0];

	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.bombTimer * 1000) ) );
	
	label = destroyedObj gameobjects::get_label();
	SetMatchFlag( "bomb_timer"+label, 1 );
	if ( label == "_a" )
	{
		SetBombTimer( "A", int( gettime() + level.bombTimer * 1000 ) );
	}
	else
	{
		SetBombTimer( "B", int( gettime() + level.bombTimer * 1000 ) );
	}
	
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "sd_bombplant", label, team, player.origin );

	if ( !level.multiBomb )
	{
		level.sdBomb gameobjects::allow_carry( "none" );
		level.sdBomb gameobjects::set_visible_team( "none" );
		level.sdBomb gameobjects::set_dropped();
		level.sdBombModel = level.sdBomb.visuals[0];
	}
	else
	{
		
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( isdefined( level.players[index].carryIcon ) )
				level.players[index].carryIcon hud::destroyElem();
		}

		trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
		
		tempAngle = randomfloat( 360 );
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - VectorScale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
		dropAngles = vectortoangles( forward );
		
		level.sdBombModel = spawn( "script_model", trace["position"] );
		level.sdBombModel.angles = dropAngles;
		level.sdBombModel setModel( "p7_mp_suitcase_bomb" );
	}
	destroyedObj gameobjects::allow_use( "none" );
	destroyedObj gameobjects::set_visible_team( "none" );
	/*
	destroyedObj gameobjects::set_2d_icon( "friendly", undefined );
	destroyedObj gameobjects::set_2d_icon( "enemy", undefined );
	destroyedObj gameobjects::set_3d_icon( "friendly", undefined );
	destroyedObj gameobjects::set_3d_icon( "enemy", undefined );
	*/
	label = destroyedObj gameobjects::get_label();
	
	// create a new object to defuse with.
	trigger = destroyedObj.bombDefuseTrig;
	trigger.origin = level.sdBombModel.origin;
	visuals = [];
	defuseObject = gameobjects::create_use_object( game["defenders"], trigger, visuals, (0,0,32), istring("sd_defuse"+label) );
	defuseObject gameobjects::allow_use( "friendly" );
	defuseObject gameobjects::set_use_time( level.defuseTime );
	defuseObject gameobjects::set_use_text( &"MP_DEFUSING_EXPLOSIVE" );
	defuseObject gameobjects::set_use_hint_text( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	defuseObject gameobjects::set_visible_team( "any" );
	defuseObject gameobjects::set_2d_icon( "friendly", "compass_waypoint_defuse" + label );
	defuseObject gameobjects::set_2d_icon( "enemy", "compass_waypoint_defend" + label );
	defuseObject gameobjects::set_3d_icon( "friendly", "waypoint_defuse" + label );
	defuseObject gameobjects::set_3d_icon( "enemy", "waypoint_defend" + label );
	defuseObject gameobjects::set_flags( 1 );
	defuseObject.label = label;
	defuseObject.onBeginUse =&onBeginUse;
	defuseObject.onEndUse =&onEndUse;
	defuseObject.onUse =&onUseDefuseObject;
	defuseObject.useWeapon = GetWeapon( "briefcase_bomb_defuse" );
	
	player.isBombCarrier = false;
	
	BombTimerWait();
	SetBombTimer( "A", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_a", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
	destroyedObj.visuals[0] globallogic_utils::stopTickingSound();
	
	if ( level.gameEnded || level.bombDefused )
		return;
	
	level.bombExploded = true;
	
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "sd_bombexplode", label, team, player.origin );
	
	explosionOrigin = level.sdBombModel.origin+(0,0,12);
	level.sdBombModel hide();
	
	if ( isdefined( player ) )
	{
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
		level thread popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_BLOWUP_BY", player );
		scoreevents::processScoreEvent( "bomb_detonated", player );
		player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		player RecordGameEvent("destroy");
	}
	else
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", GetWeapon( "briefcase_bomb" ) );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread sound::play_in_space( "mpl_sd_exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isdefined( destroyedObj.exploderIndex ) )
		exploder::exploder( destroyedObj.exploderIndex );
	
	defuseObject gameobjects::destroy_object();
	foreach ( zone in level.bombZones )
		zone gameobjects::disable_object();
	
	setGameEndTime( 0 );
	
	wait 3;
	
	sr_endGame( game["attackers"], game["strings"]["target_destroyed"] );
}

function BombTimerWait()
{
	level endon("game_ended");
	level endon("bomb_defused");
	hostmigration::waitLongDurationWithGameEndTimeUpdate( level.bombTimer );
}

function bombDefused()
{
	level.tickingObject globallogic_utils::stopTickingSound();
	level.bombDefused = true;
	SetBombTimer( "A", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_a", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
	level notify("bomb_defused");
	thread globallogic_audio::set_music_on_team( "silent" );		
	
	wait 1.5;
	
	setGameEndTime( 0 );
	
	sr_endGame( game["defenders"], game["strings"]["bomb_defused"] );
}

function sr_isKillBoosting()
{
	roundsPlayed = util::getRoundsPlayed();

	if ( level.playerKillsMax == 0 )
		return false;
		
	if ( game["totalKills"] > ( level.totalKillsMax * (roundsPlayed + 1) ) )
		return true;
		
	if ( self.kills > ( level.playerKillsMax * (roundsPlayed + 1)) )
		return true;
		
	if ( level.teambased && (self.team == "allies" || self.team == "axis" ))
	{
		if ( game["totalKillsTeam"][self.team] > ( level.playerKillsMax * (roundsPlayed + 1)) )
			return true;
	}
	
	return false;
}

function onUseDogTag( player )
{
	//	friendly pickup
	if ( player.pers["team"] == self.victimTeam )
	{
		player.pers["rescues"]++;
		player.rescues = player.pers["rescues"];
	
			if ( IsDefined( self.victim ) )
			{
				if ( !level.gameEnded )
					self.victim thread sr_respawn();
			}	
		}
}

function sr_respawn()
{
	// Need to count this player as alive immediately, because they can wait to spawn whenever they want.  If we don't increment this until they become alive,
	// then things get screwed up when level.aliveCount becomes 1.  The game thinks that there's only one player left alive, and yet there are multiple players
	// on the team with self.pers["lives"] greater than 0.
//	self maps\mp\gametypes\_playerlogic::incrementAliveCount(self.team);
//	self.alreadyAddedToAliveCount = true;
	
	self thread waitTillCanSpawnClient(); 
}

//fixes a potential race condition with spawning around the same frame as friendly tag pickup
function waitTillCanSpawnClient()
{
	for (;;)
	{
		wait ( .05 );
		if ( isDefined( self ) && ( self.sessionstate == "spectator" || !isAlive( self ) ) )
		{
			self.pers["lives"] = 1;
			self thread [[level.spawnClient]]();		
			
			//we need to continue here because spawn client can fail for up to 3 server frames in this instance
			continue;
		}
		
		//player either disconnected or has spawned
		return;
	}
}
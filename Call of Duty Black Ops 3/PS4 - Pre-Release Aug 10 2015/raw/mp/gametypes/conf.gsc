#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;

/*
	Confirmed Kill
	Objective: 	Score points for your team by eliminating players on the opposing team.
				Score bonus points for picking up dogtags from downed enemies.
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
*/

#precache( "material", "waypoint_dogtags" );
#precache( "string", "OBJECTIVES_CONF" );
#precache( "string", "OBJECTIVES_CONF_SCORE" );
#precache( "string", "OBJECTIVES_CONF_HINT" );
#precache( "string", "MP_KILL_DENIED" );

function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 50000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundSwitch( 0, 9 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundWinBased = true;
	level.teamBased = true;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onStartGameType =&onStartGameType;
	level.onSpawnPlayer =&onSpawnPlayer;
	level.onRoundEndGame =&onRoundEndGame;
	level.onPlayerKilled =&onPlayerKilled;
	level.onRoundSwitch =&onRoundSwitch;
	level.overrideTeamScore = true;
	level.teamScorePerKill = GetGametypeSetting( "teamScorePerKill" );
	level.teamScorePerKillConfirmed = GetGametypeSetting( "teamScorePerKillConfirmed" );
	level.teamScorePerKillDenied = GetGametypeSetting( "teamScorePerKillDenied" );
	
	gameobjects::register_allowed_gameobject( level.gameType );
	
//	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
//		level.modifyPlayerDamage = _damage::gamemodeModifyPlayerDamage;

	globallogic_audio::set_leader_gametype_dialog ( "startKillConfirmed", "hcCtartKillConfirmed", "gameBoost", "gameBoost" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "killsconfirmed", "killsdenied", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths", "killsconfirmed", "killsdenied" );
}


function onPrecacheGameType()
{

}


function onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	

	foreach( team in level.teams )
	{
		util::setObjectiveText( team, &"OBJECTIVES_CONF" );
		util::setObjectiveHintText( team, &"OBJECTIVES_CONF_HINT" );
		
		if ( level.splitscreen )
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_CONF" );
		}
		else
		{
			util::setObjectiveScoreText( team, &"OBJECTIVES_CONF_SCORE" );
		}
		
		spawnlogic::place_spawn_points( spawning::getTDMStartSpawnName(team) );
		spawnlogic::add_spawn_points( team, "mp_tdm_spawn" );
	}
			
	spawning::updateAllSpawnPoints();
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array(spawning::getTDMStartSpawnName(team));
	}

	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );	

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	dogtags::init();
		
	if ( !util::isOneRound() )
	{
		level.displayRoundEndText = true;
		if( level.scoreRoundWinBased )
		{
			globallogic_score::resetTeamScores();
		}
	}
	
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || attacker.team == self.team )
		return;
	
	//score = rank::getScoreInfoValue( "kill" );
	//assert( isdefined( score ) );

	level thread dogtags::spawn_dog_tag( self, attacker, &onUse, true );

	attacker globallogic_score::giveTeamScoreForObjective( attacker.team, level.teamScorePerKill );
}

function onUse( player )
{	
	tacInsertBoost = false;
	
	//	friendly pickup
	if ( player.team != self.attackerTeam )
	{
		tacInsertBoost = self.tacInsert;

		if ( isdefined ( self.attacker ) && self.attacker.team == self.attackerTeam )
		{	
			self.attacker LUINotifyEvent( &"player_callout", 2, &"MP_KILL_DENIED", player.entnum );
			// TODO: need audio cue
			//self.attacker PlayLocalSound( game["dialog"]["kc_denied"] );
		}
		
		if ( !tacInsertBoost )
		{
			// TODO: Need audio cue
			//player globallogic_audio::leader_dialog_on_player( "kc_deny" );
			
			player globallogic_score::giveTeamScoreForObjective( player.team, level.teamScorePerKillDenied );
		}
	}
	//	enemy pickup
	else
	{		
/#
		assert( isdefined( player.lastKillConfirmedTime ) );
		assert( isdefined( player.lastKillConfirmedCount ) );
#/
		// TODO: Need audio cue
		//player globallogic_audio::leader_dialog_on_player( "kc_start" );
		
		player.pers["killsconfirmed"]++;
		player.killsconfirmed = player.pers["killsconfirmed"];
		player globallogic_score::giveTeamScoreForObjective( player.team, level.teamScorePerKillConfirmed );

	}	
		
	if ( !tacInsertBoost )
	{
		currentTime = getTime();
		
		if ( player.lastKillConfirmedTime + 1000 > currentTime )
		{
			player.lastKillConfirmedCount++;
			if ( player.lastKillConfirmedCount >= 3 )
			{
				scoreevents::processScoreEvent( "kill_confirmed_multi", player );
				player.lastKillConfirmedCount = 0;
			}
		}
		else
		{
			player.lastKillConfirmedCount = 1;
		}
		
		player.lastKillConfirmedTime = currentTime;
	}
}


function onSpawnPlayer(predictedSpawn)
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	self.lastKillConfirmedTime = 0;
	self.lastKillConfirmedCount = 0;
	
	spawning::onSpawnPlayer(predictedSpawn);
	
	dogtags::on_spawn_player();
}

function onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

function onRoundEndGame( roundWinner )
{	
	return globallogic::determineTeamWinnerByGameStat( "roundswon" );
}

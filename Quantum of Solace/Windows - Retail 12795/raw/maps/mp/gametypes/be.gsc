#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
	Bond Escape
	Bond and his team obj:  Get Bond to the exit
	Terrorists' objective:	Prevent Bond from geting to exit by taking out Bond
	Round ends:				After 2 minutes
	Map ends:				When sides have switched once
	Respawning:				Yes

	Level requirements
	------------------
		Bond Spawnpoints:
			classname				mp_be_spawn_bond
			Place at least 16 of these scattered around the perimeter of the map.

		Terrorist Operative Spawnpoints:
			classname				mp_be_spawn_terrorist
			Place at least 16 of these relatively close together, in and around the enemy "base".

		Spectator Spawnpoints:
			classname				mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			At least one is required, any more and they are randomly chosen between.


	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "bond";
			game["axis"] = "terrorists";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

*/

/*QUAKED mp_be_spawn_bond (0.0 0.5 0.5) (-16 -16 0) (16 16 72)
Team Bond spawns randomly at one of these positions at the beginning of a round of Bond Escape.*/

/*QUAKED mp_be_spawn_terrorist (0.5 0.5 0.0) (-16 -16 0) (16 16 72)
Team Terrorists spawn randomly at one of these positions at the beginning of a round of Bond Escape.*/



//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
main()
{
	precacheShader( "compassping_death" );

	println("************************************************");
	println("*********** WELCOME TO BOND ESCAPE *************");
	println("************************************************");

	level.team_bond = "allies";
	level.team_terrorists = "axis";

	if(getdvar("mapname") == "mp_background")
		return;

	level.points = [];
	level.points["bond_evaded"] = 5; //award points to the team who had Bond evade
	level.points["bond_killed"] = 5; //award points to the team who killed Bond
	level.points["player_killed_bond"] = 5; //award points to the player who killed Bond
		
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gametype, 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gametype, 6, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gametype, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerMinPlayersDvar( level.gametype, 2, 2, 12 );
	// No score limit
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gametype, 0, 0, 0 );

	level.teamBased = true;
	level.doAutoAssign = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.doClass = true;
	level.doHero = false;
	level.roundEndDelay = 7;
	level.allowClassChange = true;
	level.useRoundLimitAsWinsPerTeam = false;

	level.overrideTeam = ::overrideTeam;

	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	level.onTimeLimit = ::onTimeLimit;
	level.onDeadEvent = ::onDeadEvent;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPlayerTeamAssigned = ::onPlayerTeamAssigned;
	level.onRoundEnded = ::onRoundEnded;
	
	level.winTeamPointMultiplier = 25;
	level.loseTeamPointMultiplier = 25;

	level.loadout = [];

	maps\mp\gametypes\_globallogic::findMapCenter();
}



//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPrecacheGameType()
{
	precacheShader("compass_waypoint_captureneutral");
	precacheShader("mp_icon_bond_escape");
	precacheShader("mp_icon_waypoint_defend");

	precacheString( &"MP_THE_ENEMY" );
	precacheString( &"MP_YOUR_TEAM" );
	precacheString( &"MPUI_BOND_LEFT" );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onStartGameType()
{
	game["allies"] = "mi6";
	game["axis"] = "terrorists";

	setClientNameMode( "manual_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_bond, &"OBJECTIVES_BE_MI6" );
	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_terrorists, &"OBJECTIVES_BE_TERRORISTS" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "bond", &"OBJECTIVES_BE_BOND" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_bond, "OBJECTIVES_BE_MI6" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_terrorists, "OBJECTIVES_BE_TERRORISTS" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( "bond", "OBJECTIVES_BE_BOND" );

	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_bond, &"OBJECTIVES_BE_MI6_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_terrorists, &"OBJECTIVES_BE_TERRORISTS_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "bond", &"OBJECTIVES_BE_BOND_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_be_spawn_bond" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_be_spawn_terrorist" );

	maps\mp\gametypes\_spawnlogic::addTeamSpawnPointsToLevelList( "allies" );
	maps\mp\gametypes\_spawnlogic::addTeamSpawnPointsToLevelList( "axis" );

	allowed[0] = level.gametype;
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.attemptsAtSelectingBond = 0;

	updateGametypeDvars();

	setupEscapePoint();

	level.escapePoint thread escapePointTriggerThink();

//	thread testending();
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onRoundEnded()
{
	players = getEntArray( "player", "classname" );
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		if( !isDefined( player.pers["roundsPlayed"] ) )
			player.pers["roundsPlayed"] = 0;

		player.pers["roundsPlayed"]++;
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
switchTeam( player )
{
	assert( isDefined( player ) && isDefined( player.pers["team"] ) );

	if( !isDefined( player.pers["roundsPlayed"] ) )
	{
		player.pers["roundsPlayed"] = 0;
	}

	// Don't switch teams if we have not played one round.  This is to prevent
	// people that just joined from switching teams right away.
	if( player.pers["roundsPlayed"] < 1 )
		return;

	if( player.pers["team"] == level.team_bond )
	{
		player maps\mp\gametypes\_teams::changeTeam( level.team_terrorists );
	}
	else if( player.pers["team"] == level.team_terrorists )
	{
		player maps\mp\gametypes\_teams::changeTeam( level.team_bond );
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
pickBond( player )
{
	if( !isDefined( player ) || !isDefined( player.pers["team"] ) || player.pers["team"] != level.team_bond )
		return;

	player.isBond = false;

	// Check if we have already selected a bond
	if( level.attemptsAtSelectingBond < 0 )
		return;

	// Since we force auto-assign, we can assume that there
	// are half the number of players rounded down on the bond
	// team, which could potentially miss one player for odd
	// player counts but we don't care.
	numBondMembers = int( game["playercount"].size / 2 );
	if( numBondMembers <= 0 )
	{
		numBondMembers = 1;
	}
	roll = randomInt( numBondMembers );
	level.attemptsAtSelectingBond++;

	// Every player is a 1/numPlayersOnBondTeam chance to become Bond,
	// with an enforcement that someone actually gets picked to be Bond.
	if( level.attemptsAtSelectingBond != numBondMembers && roll != 1 )
	{
		return;
	}

	// Player has been picked to be Bond
	player.pers["class"] = "bond";
	player.pers["skin"] = "SKIN_HERO_ONE";
	player.pers["team"] = level.team_bond;
	player.isBond = true;
	player setPlayerType( 6 ); // hero_balanced
	level.player_bond = player;
	player maps\mp\gametypes\_class::setClass( player.pers["class"] );
	player maps\mp\gametypes\_class::setSkin( player.pers["skin"] );
	//announcement( "Bond has been selected!" );

	// Let everyone else that joined before know who bond is
	for( index = 0; index < level.players.size; index++ )
	{
		level.players[ index ] setClientDvar( "ui_player_whois_bond", level.player_bond.name );
	}

	level.attemptsAtSelectingBond = -1;

}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
overrideTeam()
{
	if( game["state"] == "prematch" )
	{
		// Don't pick a bond character during prematch.
		return;
	}

	if( !isDefined( self ) )
	{
		return;
	}
	else if( !isDefined( self.pers["team"] ) )
	{
		self [[level.autoassign]]();
	}
	
	if( game["roundsplayed"] > 0 )
	{
		switchTeam( self );
	}

	pickBond( self );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPlayerTeamAssigned()
{
}

//--------------------------------------------------------------------------------------
// Takes the entities with targetname be_escape_point and be_escape_trigger
//--------------------------------------------------------------------------------------
setupEscapePoint()
{
	escapePoints = getentarray( "be_escape_point", "targetname" );
	
	if ( escapePoints.size == 0 )
	{
		errorAbortLevel( "There is no entity with targetname \"be_escape_point\" that is need to play Bond Escape." );
		return false;
	}
	
	escapeTriggers = getentarray( "be_escape_trigger", "targetname" );
	if( escapeTriggers.size == 0 )
	{
		errorAbortLevel( "There is no entity with targetname \"be_escape_trigger\" that is need to play Bond Escape." );
		return false;
	}

	// For now, only support one escape point and trigger.
	escapePoint = escapePoints[ 0 ];
	escapeTrigger = escapeTriggers[ 0 ];
	//if( !escapePoint isTouching( escapeTrigger ) )
	//{
	//	errorAbortLevel( "Escape point at " + escapePoint.origin + " is not touching the escape trigger." );
	//	return false;
	//}

	level.escapePoint = escapePoint;
	level.escapePoint.trigger = escapeTrigger;

	escapePointMiniMapIcon = "compass_waypoint_captureneutral";
	level.escapePoint.objective_id = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add( level.escapePoint.objective_id, "active", level.escapePoint.origin, escapePointMiniMapIcon );

	escape_origin = escapePoint.origin;
	escape_origin += ( 0, 0, 40 );
	level.bondEscapePoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "bondEscapePoint", escape_origin, level.team_bond, "mp_icon_bond_escape", 0.5, 0.5 );
	level.orgEscapePoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "orgEscapePoint", escape_origin, level.team_terrorists, "mp_icon_waypoint_defend", 0.5, 1.0 );

	return true;
}

//--------------------------------------------------------------------------------------
// Thread that checks if bond has escaped by hitting the escape point trigger.
//    self = escapePoint
//--------------------------------------------------------------------------------------
escapePointTriggerThink()
{
	level endon( "game_ended" );

	while( true )
	{
		wait 0.05;

		if( !isDefined( level.player_bond ) )
		{
			continue;
		}
		if( level.player_bond isTouching( self.trigger ) )
		{
			level.player_bond giveAchievement( "ESCAPE_AS_BOND" );
			setdvar( "g_roundEndReason", "bondevaded" );
			onBondEscaped();
		}
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
testending()
{
	wait 3;

	onTimeLimit();
}


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if( isDefined( level.player_bond ) && self == level.player_bond )
	{
		// 5 points for killing bond... unless you ARE bond
		if( attacker != self && attacker.classname != "worldspawn" )
		{
			score = maps\mp\gametypes\_globallogic::_getPlayerScore( attacker );
			score += level.points["player_killed_bond"];
			maps\mp\gametypes\_globallogic::_setPlayerScore( attacker, score );
			attacker maps\mp\gametypes\_persistence_util::statAdd( "stats", "BOND_KILLS", 1 );
			attackerBondKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "BOND_KILLS" );
			//if( attackerBondKills >= 10 )
			//{
			//	attacker giveAchievement( "KILLED_BOND_10_TIMES" );
			//}
		}
		onBondFailedToEscape( true );
	}
	else if( self.pers["team"] == level.team_terrorists )
	{
		checkTerroristsDead();
	}
}


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
checkTerroristsDead(disconnectedPlayer)
{
	alldead = true;
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( player.pers["team"] != level.team_terrorists )
			continue;

		if( isDefined(disconnectedPlayer) && player == disconnectedPlayer )
			continue;

		if( player.sessionstate == "spectator" )
			continue;

		alldead = false;
		break;
	}

	if( alldead )
	{
		setdvar( "g_roundEndReason", "orgeliminated" );
		onBondEscaped();
	}
}


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
lowerMessageAnnounce(message, time)
{
	self endon("disconnect");
	self setLowerMessage(message);
	wait(time);
	self setLowerMessage("");
}


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );

	if( isDefined( level.player_bond ) )
	{
		self setClientDvar( "ui_player_whois_bond", level.player_bond.name );
	}
}


//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onPlayerDisconnect()
{
	// check to see if Bond left
	if( isDefined( level.player_bond ) && self == level.player_bond )
	{
		level.player_bond = undefined;
		announcement( &"MPUI_BOND_LEFT" );
		thread [[level.endGame]]( level.team_terrorists );
	}
	else if( self.pers["team"] == level.team_terrorists )
	{
		checkTerroristsDead(self);
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onBondFailedToEscape( wasKilled )
{
	setTeamScore( level.team_terrorists, getTeamScore( level.team_terrorists ) );
	giveTeamPoints( level.team_terrorists, level.points["bond_killed"] );

	//playSoundOnPlayers("BVS_Terr_WIN_KIL", level.team_terrorists);	// Someone's just become a very rich man.
	//playSoundOnPlayers("BVS_Brit_LOSE_LOS", level.team_bond);		// I expect better from a double O

	//announcement( game["strings"]["bond_eliminated"] );
	if ( wasKilled ) {
		setdvar( "g_roundEndReason", "bondeliminated" );
	}

	thread [[level.endGame]]( level.team_terrorists );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onBondEscaped()
{
	setTeamScore( level.team_bond, getTeamScore( level.team_bond ) );
	giveTeamPoints( level.team_bond, level.points["bond_evaded"] );

	//playSoundOnPlayers("BVS_Brit_WIN_KIL", level.team_bond);		// They're all dead?  Not an elegant solution, but I suppose I can't complain.
	//playSoundOnPlayers("BVS_Terr_LOSE_SCL", level.team_terrorists);	// I British agent?  That's what it takes to disarm an entire squad?  We need warriors, not idiots

	playSoundOnPlayers( "Tann_MP_36" );

	//announcement( game["strings"]["terrorists_eliminated"] );
	thread [[level.endGame]]( level.team_bond );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onDeadEvent( team )
{
	if ( team == "all" )
	{
		return;
	}

	if ( team == level.team_bond )
	{
		playSoundOnPlayers( "Tann_MP_21" );
		setdvar( "g_roundEndReason", "bondeliminated" );
		onBondFailedToEscape( true );
	}
	else if ( team == level.team_terrorists )
	{
		setdvar( "g_roundEndReason", "orgeliminated" );
		onBondEscaped();
	}
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
onTimeLimit()
{
	setdvar( "g_roundEndReason", "timelimit" );
	level.onTimeLimit = maps\mp\gametypes\_globallogic::blank;
	wait(3.0);

	onBondFailedToEscape( false );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
updateGametypeDvars()
{
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
giveTeamPoints( team, points )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( isDefined( player.pers["team"] ) && (player.pers["team"] == team) )
		{
			score = maps\mp\gametypes\_globallogic::_getPlayerScore( player );
			score += points;
			maps\mp\gametypes\_globallogic::_setPlayerScore( player, score );
		}
	}

	setTeamScore( team, getTeamScore(team) + points );
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
errorAbortLevel( errorText )
{
	maps\mp\_utility::error2( errorText );
	maps\mp\gametypes\_callbacksetup::AbortLevel();
}

#include maps\mp\_utility;

init()
{
	precacheShader("mpflag_spectator");

	game["strings"]["autobalance"] = &"MP_AUTOBALANCE_NOW";
	precacheString( &"MP_AUTOBALANCE_NOW" );

	if(GetDvar( "scr_teambalance") == "")
		SetDvar("scr_teambalance", "0");
	level.teambalance = GetDvarint( "scr_teambalance");
	level.teambalancetimer = 0;
	
	if(GetDvar( "scr_timeplayedcap") == "")
		SetDvar("scr_timeplayedcap", "1800");
	level.timeplayedcap = int(GetDvarint( "scr_timeplayedcap"));

	level.freeplayers = [];

	if( level.teamBased )
	{
		level.alliesplayers = [];
		level.axisplayers = [];

		level thread onPlayerConnect();
		level thread updateTeamBalanceDvar();
	
		wait .15;
		if ( level.rankedMatch )
		{
			level thread updatePlayerTimes();
		}
	}
	else
	{
		level thread onFreePlayerConnect();
	
		wait .15;
		if ( level.rankedMatch )
		{
			level thread updatePlayerTimes();
		}
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		
		player thread trackPlayedTime();
	}
}

onFreePlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread trackFreePlayedTime();
	}
}


onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self logString( "joined team: " + self.pers["team"] );
		self updateTeamTime();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self.pers["teamTime"] = undefined;
	}
}


trackPlayedTime()
{
	self endon( "disconnect" );

	foreach ( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}
	self.timePlayed["free"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["alive"] = 0;

	// dont reset time played in War when going into final fight, this is used for calculating match bonus
	if ( !isDefined( self.timePlayed["total"] ) || !( (level.gameType == "twar") && (0 < game["roundsplayed"]) && (0 < self.timeplayed["total"]) ) )
		self.timePlayed["total"] = 0;
	
	while ( level.inPrematchPeriod )
		wait ( 0.05 );

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isdefined( level.teams[self.sessionteam] ) )
			{
				self.timePlayed[self.sessionteam]++;
				self.timePlayed["total"]++;
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else if ( self.sessionteam == "spectator" )
			{
				self.timePlayed["other"]++;
			}	
		}
		
		wait ( 1.0 );
	}
}


updatePlayerTimes()
{
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isDefined( level.players[nextToUpdate] ) )
		{
			level.players[nextToUpdate] updatePlayedTime();
			level.players[nextToUpdate] maps\mp\gametypes\_persistence::checkContractExpirations();
		}

		wait ( 1.0 );
	}
}

updatePlayedTime()
{
	pixbeginevent("updatePlayedTime");

	foreach( team in level.teams )
	{
		if ( self.timePlayed[team] )
		{
			self AddPlayerStat( "time_played_"+team, int( min( self.timePlayed[team], level.timeplayedcap ) ) );
			self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed[team], level.timeplayedcap ) ) );
		}
	}
		
	if ( self.timePlayed["other"] )
	{
		self AddPlayerStat( "time_played_other", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );			
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["alive"] )
	{
		timeAlive = int( min( self.timePlayed["alive"], level.timeplayedcap ) );
		self maps\mp\gametypes\_persistence::incrementContractTimes( timeAlive );
		self AddPlayerStat( "time_played_alive", timeAlive );			
	}
	
	pixendevent();
	
	if ( game["state"] == "postgame" )
		return;

	foreach( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}
	self.timePlayed["other"] = 0;
	self.timePlayed["alive"] = 0;
}


updateTeamTime()
{
	if ( game["state"] != "playing" )
		return;
		
	self.pers["teamTime"] = getTime();
}

updateTeamBalanceDvar()
{
	for(;;)
	{
		teambalance = GetDvarint( "scr_teambalance");
		if(level.teambalance != teambalance)
			level.teambalance = GetDvarint( "scr_teambalance");

		timeplayedcap = GetDvarint( "scr_timeplayedcap");
		if(level.timeplayedcap != timeplayedcap)
			level.timeplayedcap = int(GetDvarint( "scr_timeplayedcap"));

		wait 1;
	}
}

changeTeam( team )
{
	if (self.sessionstate != "dead")
	{
		// Set a flag on the player to they aren't robbed points for dying - the callback will remove the flag
		self.switching_teams = true;
		self.joining_team = team;
		self.leaving_team = self.pers["team"];
		
		// Suicide the player so they can't hit escape and fail the team balance
		self suicide();
	}

	self.pers["team"] = team;
	self.team = team;
	self.pers["weapon"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;
	self.sessionteam = self.pers["team"];
	if ( !level.teamBased ) 
		self.ffateam = team;

	self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();
	
	// update spectator permissions immediately on change of team
	self maps\mp\gametypes\_spectating::setSpectatePermissions();
	
	self SetClientScriptMainMenu( game["menu_class"] );
	self openMenu(game["menu_class"]);
	
	self notify("end_respawn");
}

CountPlayers()
{
	players = level.players;
	
	playerCounts = [];
	foreach( team in level.teams )
	{
		playerCounts[team] = 0;
	}
	
	foreach( player in level.players )
	{
		if( player == self )
			continue;
		
		team = player.pers["team"];
		if( isdefined(team) && isdefined( level.teams[team] ) )
			playerCounts[team]++;
	}
	return playerCounts;
}


trackFreePlayedTime()
{
	self endon( "disconnect" );

	foreach( team in level.teams )
	{
		self.timePlayed[team] = 0;
	}

	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;
	self.timePlayed["alive"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			team = self.pers["team"];
			if ( isDefined( team ) && isdefined( level.teams[team] ) && self.sessionteam != "spectator" )
			{
				self.timePlayed[team]++;
				self.timePlayed["total"]++;
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else
			{
				self.timePlayed["other"]++;
			}
		}
		
		wait ( 1.0 );
	}
}

set_player_model( team, weapon )
{
	weaponClass = getWeaponClass( weapon );
	bodyType = "default";

	switch( weaponClass )
	{
		case "weapon_sniper":
			bodyType = "rifle";
		break;

		case "weapon_cqb":
			bodyType = "spread";
		break;

		case "weapon_lmg":
			bodyType = "mg";
		break;

		case "weapon_smg":
			bodyType = "smg";
		break;
	}
	
	self DetachAll();
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );

	if ( level.multiTeam )
	{
		bodyType = "default";

		switch( team )
		{
			case "team7":
			case "team8":
				team = "allies";
			break;
		}
	}

	self [[game["set_player_model"][ team ][ bodyType ]]]();
}

getTeamFlagModel( teamRef )
{
	assert(isdefined(game["flagmodels"]));
	assert(isdefined(game["flagmodels"][teamRef]));
	return ( game["flagmodels"][teamRef] );
}

getTeamFlagCarryModel( teamRef )
{
	assert(isdefined(game["carry_flagmodels"]));
	assert(isdefined(game["carry_flagmodels"][teamRef]));
	return ( game["carry_flagmodels"][teamRef] );
}

getTeamFlagIcon( teamRef )
{
	assert(isdefined(game["carry_icon"]));
	assert(isdefined(game["carry_icon"][teamRef]));
	return ( game["carry_icon"][teamRef] );
}

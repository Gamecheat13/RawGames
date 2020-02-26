init()
{
	switch(game["allies"])
	{
	case "marines":
		precacheShader("mpflag_american");
		break;
	}
	
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

	setPlayerModels();

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
			level thread updateFreePlayerTimes();
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

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
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
			if ( self.sessionteam == "allies" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else if ( self.sessionteam == "axis" )
			{
				self.timePlayed["axis"]++;
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

	if ( self.timePlayed["allies"] )
	{
		self AddPlayerStat( "time_played_allies", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["axis"] )
	{
		self AddPlayerStat( "time_played_opfor", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
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

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
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

getTeamBalance()
{
	level.team["allies"] = 0;
	level.team["axis"] = 0;

	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			level.team["allies"]++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			level.team["axis"]++;
	}
	
	if((level.team["allies"] > (level.team["axis"] + level.teambalance)) || (level.team["axis"] > (level.team["allies"] + level.teambalance)))
		return false;
	else
		return true;
}

balanceTeams()
{
	iPrintLnBold( game["strings"]["autobalance"] );
	//Create/Clear the team arrays
	AlliedPlayers = [];
	AxisPlayers = [];
	
	// Populate the team arrays
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].pers["teamTime"]))
			continue;
			
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			AlliedPlayers[AlliedPlayers.size] = players[i];
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			AxisPlayers[AxisPlayers.size] = players[i];
	}
	
	MostRecent = undefined;
	
	while((AlliedPlayers.size > (AxisPlayers.size + 1)) || (AxisPlayers.size > (AlliedPlayers.size + 1)))
	{	
		if(AlliedPlayers.size > (AxisPlayers.size + 1))
		{
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for(j = 0; j < AlliedPlayers.size; j++)
			{
				if(isdefined(AlliedPlayers[j].dont_auto_balance))
					continue;
				
				if(!isdefined(MostRecent))
					MostRecent = AlliedPlayers[j];
				else if(AlliedPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AlliedPlayers[j];
			}
			
			MostRecent changeTeam("axis");
		}
		else if(AxisPlayers.size > (AlliedPlayers.size + 1))
		{
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			for(j = 0; j < AxisPlayers.size; j++)
			{
				if(isdefined(AxisPlayers[j].dont_auto_balance))
					continue;

				if(!isdefined(MostRecent))
					MostRecent = AxisPlayers[j];
				else if(AxisPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AxisPlayers[j];
			}

			MostRecent changeTeam("allies");
		}

		MostRecent = undefined;
		AlliedPlayers = [];
		AxisPlayers = [];
		
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				AlliedPlayers[AlliedPlayers.size] = players[i];
			else if((isdefined(players[i].pers["team"])) &&(players[i].pers["team"] == "axis"))
				AxisPlayers[AxisPlayers.size] = players[i];
		}
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
	
	if(self.pers["team"] == "allies")
	{
		self SetClientScriptMainMenu( game["menu_class_allies"] );
		self openMenu(game["menu_class_allies"]);
	}
	else
	{
		self SetClientScriptMainMenu( game["menu_class_axis"] );
		self openMenu(game["menu_class_axis"]);
	}
	
	self notify("end_respawn");
}


setPlayerModels()
{
	game["allies_model"] = [];

	alliesCharSet = tableLookup( "mp/mapsTable.csv", 0, GetDvar( "mapname" ), 1 );
	if ( !isDefined( alliesCharSet ) || alliesCharSet == "" || !IsDefined(game["allies_teamset"][alliesCharSet]) )
	{
		game["allies_soldiertype"] = "junglemarines";
		game["allies"] = "marines";
		alliesCharSet = "junglemarines";
		assert( IsDefined(game["allies_teamset"][alliesCharSet]), "Team set for default team pacific not properly initialized for allies.");
	}
	else
		game["allies_soldiertype"] = alliesCharSet;

	axisCharSet = tableLookup( "mp/mapsTable.csv", 0, GetDvar( "mapname" ), 2 );
	if ( !isDefined( axisCharSet ) || axisCharSet == "" || !IsDefined(game["allies_teamset"][axisCharSet]))
	{
		game["axis_soldiertype"] = "junglemarines";
		game["axis"] = "nva";
		axisCharSet = "junglemarines";
		assert( IsDefined(game["axis_teamset"][axisCharSet]), "Team set for default team pacific not properly initialized for axis.");
	}
	else
		game["axis_soldiertype"] = axisCharSet;
	

	assert( IsDefined(game["allies_teamset"][game["allies_soldiertype"]]), "Team set for default team " + game["allies_soldiertype"] + " not properly initialized for allies.");
	[[game["allies_teamset"][game["allies_soldiertype"]]]]();
	
	assert( IsDefined(game["axis_teamset"][game["axis_soldiertype"]]), "Team set for default team " + game["axis_soldiertype"] + " not properly initialized for axis.");
	[[game["axis_teamset"][game["axis_soldiertype"]]]]();
}

CountPlayers()
{
	//chad
	players = level.players;
	allies = 0;
	axis = 0;
	for(i = 0; i < players.size; i++)
	{
		if ( players[i] == self )
			continue;
			
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	return players;
}


trackFreePlayedTime()
{
	self endon( "disconnect" );

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["total"] = 0;
	self.timePlayed["alive"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" && self.sessionteam != "spectator" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
				if ( IsAlive( self ) )
					self.timePlayed["alive"]++;
			}
			else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" && self.sessionteam != "spectator" )
			{
				self.timePlayed["axis"]++;
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


updateFreePlayerTimes()
{
	nextToUpdate = 0;
	for ( ;; )
	{
		nextToUpdate++;
		if ( nextToUpdate >= level.players.size )
			nextToUpdate = 0;

		if ( isDefined( level.players[nextToUpdate] ) )
		{
			level.players[nextToUpdate] updateFreePlayedTime();
			level.players[nextToUpdate] maps\mp\gametypes\_persistence::checkContractExpirations();
		}

		wait ( 1.0 );
	}
}


updateFreePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self AddPlayerStat( "time_played_allies", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["axis"] )
	{
		self AddPlayerStat( "time_played_opfor", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
		self AddPlayerStatWithGameType( "time_played_total", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
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
	
	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
	self.timePlayed["alive"] = 0;
}

set_player_model( team, weapon )
{
	weaponClass = WeaponClass( weapon );

	switch( weaponClass )
	{
		case "rifle":
		case "smg":
		case "spread":
		case "mg":
		break;

		default:
			weaponClass = "default";
		break;
	}
	
	self DetachAll();
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );

	self [[game["set_player_model"][ team ][ weaponClass ]]]();
}
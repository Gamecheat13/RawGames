init()
{
	precacheString(&"MP_AMERICAN");
	precacheString(&"MP_BRITISH");
	precacheString(&"MP_RUSSIAN");
	
	switch(game["allies"])
	{
	case "marines":
		precacheShader("mpflag_american");
		break;
	}

	assert(game["axis"] == "opfor");
	precacheShader("mpflag_russian");
	precacheShader("mpflag_spectator");

	if(getdvar("scr_teambalance") == "")
		setdvar("scr_teambalance", "0");
	level.teambalance = getdvarInt("scr_teambalance");
	level.teambalancetimer = 0;
	
	setPlayerModels();

	level.freeplayers = [];

	if( level.teamBased )
	{
		level.alliesplayers = [];
		level.axisplayers = [];

		level thread onPlayerConnect();
		level thread updateTeamBalanceDvar();
	
		wait .15;
		level thread updatePlayerTimes();
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
		player thread onSpawn();
		player thread onDisconnect();
	}
}


onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self updateTeamTime();
	}
}


onSpawn()
{
	self endon("disconnect");
	for (;;)
	{
		self waittill("spawned");
		regenerateTeamArrays();
		self waittill("death");
		regenerateTeamArrays();
	}
}


onDisconnect()
{
	self waittill("disconnect");
	regenerateTeamArrays();
}


regenerateTeamArrays()
{
	level.alliesplayers = [];
	level.axisplayers = [];
	level.freeplayers = [];

	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" )
			continue;

		if ( player.pers["team"] == "allies")
			level.alliesplayers[level.alliesplayers.size] = player;
		else if ( player.pers["team"] == "axis")
			level.axisplayers[level.axisplayers.size] = player;
		else
			level.freeplayers[level.freeplayers.size] = player;
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
	self.timePlayed["other"] = 0;

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( self.sessionteam == "allies" )
				self.timePlayed["allies"]++;
			else if ( self.sessionteam == "axis" )
				self.timePlayed["axis"]++;
			else if ( self.sessionteam == "spectator" )
				self.timePlayed["other"]++;
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
			level.players[nextToUpdate] updatePlayedTime();

		wait ( 1.0 );
	}
}


updatePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_allies", self.timePlayed["allies"] );
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_total", self.timePlayed["allies"] );
	}
	
	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_opfor", self.timePlayed["axis"] );
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_total", self.timePlayed["axis"] );
	}
		
	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_other", self.timePlayed["other"] );			
		self maps\mp\gametypes\_persistence_util::statAdd( "stats", "time_played_total", self.timePlayed["other"] );
	}
	
	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
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
		teambalance = getdvarInt("scr_teambalance");
		if(level.teambalance != teambalance)
			level.teambalance = getdvarInt("scr_teambalance");

		wait 1;
	}
}

getTeamBalance()
{
	level.team["allies"] = 0;
	level.team["axis"] = 0;

	players = getentarray("player", "classname");
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
	iprintlnbold(&"MP_AUTOBALANCE_NOW");
	//Create/Clear the team arrays
	AlliedPlayers = [];
	AxisPlayers = [];
	
	// Populate the team arrays
	players = getentarray("player", "classname");
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
		
		players = getentarray("player", "classname");
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
	self.pers["weapon"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;
	self.sessionteam = self.pers["team"];
	
	// update spectator permissions immediately on change of team
	self maps\mp\gametypes\_spectating::setSpectatePermissions();
	
	self setclientdvar("ui_allow_classchange", "1");
	if(self.pers["team"] == "allies")
	{
		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);
		self openMenu(game["menu_class_allies"]);
	}
	else
	{
		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);
		self openMenu(game["menu_class_axis"]);
	}
	
	self notify("end_respawn");
}


setPlayerModels()
{
	mptype\mptype_ally_cqb::precache();
	mptype\mptype_ally_grenadier::precache();
	mptype\mptype_ally_sniper::precache();
	mptype\mptype_ally_engineer::precache();
	mptype\mptype_ally_rifleman::precache();
	mptype\mptype_ally_support::precache();

	mptype\mptype_axis_cqb::precache();
	mptype\mptype_axis_grenadier::precache();
	mptype\mptype_axis_sniper::precache();
	mptype\mptype_axis_engineer::precache();
	mptype\mptype_axis_rifleman::precache();
	mptype\mptype_axis_support::precache();

	game["allies_model"] = [];
	game["allies_model"]["CLASS_CLOSEQUARTERS"] = mptype\mptype_ally_cqb::main;
	game["allies_model"]["CLASS_ASSAULT"] = mptype\mptype_ally_grenadier::main;
	game["allies_model"]["CLASS_SNIPER"] = mptype\mptype_ally_sniper::main;
	game["allies_model"]["CLASS_ENGINEER"] = mptype\mptype_ally_engineer::main;
	game["allies_model"]["CLASS_ANTIARMOR"] = mptype\mptype_ally_rifleman::main;
	game["allies_model"]["CLASS_SUPPORT"] = mptype\mptype_ally_support::main;

	game["axis_model"] = [];
	game["axis_model"]["CLASS_CLOSEQUARTERS"] = mptype\mptype_axis_cqb::main;
	game["axis_model"]["CLASS_ASSAULT"] = mptype\mptype_axis_grenadier::main;
	game["axis_model"]["CLASS_SNIPER"] = mptype\mptype_axis_sniper::main;
	game["axis_model"]["CLASS_ENGINEER"] = mptype\mptype_axis_engineer::main;
	game["axis_model"]["CLASS_ANTIARMOR"] = mptype\mptype_axis_rifleman::main;
	game["axis_model"]["CLASS_SUPPORT"] = mptype\mptype_axis_support::main;
}


model( class )
{
	self detachAll();
	
	if(self.pers["team"] == "allies")
		[[game["allies_model"][class]]]();
	else if(self.pers["team"] == "axis")
		[[game["axis_model"][class]]]();
}

CountPlayers()
{
	//chad
	players = getentarray("player", "classname");
	allies = 0;
	axis = 0;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			allies++;
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			axis++;
	}
	players["allies"] = allies;
	players["axis"] = axis;
	return players;
}

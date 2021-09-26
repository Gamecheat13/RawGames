init()
{
	precacheString(&"MP_AMERICAN");
	precacheString(&"MP_BRITISH");
	precacheString(&"MP_RUSSIAN");
	
	switch(game["allies"])
	{
	case "american":
		precacheShader("mpflag_american");
		break;
	
	case "british":
		precacheShader("mpflag_british");
		break;
	
	case "russian":
		precacheShader("mpflag_russian");
		break;
	}

	assert(game["axis"] == "german");
	precacheShader("mpflag_german");
	precacheShader("mpflag_spectator");

	if(getCvar("scr_teambalance") == "")
		setCvar("scr_teambalance", "0");
	level.teambalance = getCvarInt("scr_teambalance");
	level.teambalancetimer = 0;

	level.maxclients = getCvarInt("sv_maxclients");
	
	setPlayerModels();

	level thread onPlayerConnecting();
	level thread onPlayerConnected();

	if(getcvar("g_gametype") != "dm")
	{
		level.teamlimit = level.maxclients / 2;

		level thread updateTeamBalanceCvar();

		wait .15;
	
		if(getcvar("g_gametype") == "sd")
		{
			if(level.teambalance > 0)
			{
		    	if(isdefined(game["BalanceTeamsNextRound"]))
		    		iprintlnbold(&"MP_AUTOBALANCE_NEXT_ROUND");
	
				level waittill("restarting");
	
				if(isdefined(game["BalanceTeamsNextRound"]))
				{
					level balanceTeams();
					game["BalanceTeamsNextRound"] = undefined;
				}
				else if(!getTeamBalance())
					game["BalanceTeamsNextRound"] = true;
			}
		}
		else
		{
			for(;;)
			{
				if(level.teambalance > 0)
				{
					if(!getTeamBalance())
					{
						iprintlnbold(&"MP_AUTOBALANCE_SECONDS", 15);
					    wait 15;
	
						if(!getTeamBalance())
							level balanceTeams();
					}
					
					wait 59;
				}
				
				wait 1;
			}
		}
	}
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		
		if(!level.xenon)
			player updateAutoAssignCvar();
	}
}

onPlayerConnected()
{
	for(;;)
	{
		level waittill("connected", player);
		
		if(!level.xenon)		
			level updateTeamChangeCvars();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self updateTeamTime();

		if(!level.xenon)
		{
			self updateAutoAssignCvar();
			level updateTeamChangeCvars();
		}
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self.pers["teamTime"] = undefined;

		if(!level.xenon)
		{
			self updateAutoAssignCvar();
			level updateTeamChangeCvars();
		}
	}
}

updateTeamTime()
{
	if(getcvar("g_gametype") == "sd")
		self.pers["teamTime"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
	else
		self.pers["teamTime"] = (gettime() / 1000);
}

updateTeamBalanceCvar()
{
	for(;;)
	{
		teambalance = getCvarInt("scr_teambalance");
		if(level.teambalance != teambalance)
			level.teambalance = getCvarInt("scr_teambalance");

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
			
			if(getcvar("g_gametype") == "sd")
				MostRecent changeTeam_RoundBased("axis");
			else
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

			if(getcvar("g_gametype") == "sd")
				MostRecent changeTeam_RoundBased("allies");
			else
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

changeTeam(team)
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
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.sessionteam = self.pers["team"];
	
	// update spectator permissions immediately on change of team
	self maps\mp\gametypes\_spectating::setSpectatePermissions();
	
	self setClientCvar("ui_allow_weaponchange", "1");
	if(self.pers["team"] == "allies")
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		self openMenu(game["menu_weapon_allies"]);
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		self openMenu(game["menu_weapon_axis"]);
	}
	
	self updateTeamTime();
	
	self notify("end_respawn");
}

changeTeam_RoundBased(team)
{
	self.pers["team"] = team;
	self.pers["weapon"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	
	self updateTeamTime();
}

getJoinTeamPermissions(team)
{
	teamcount = 0;
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if((isdefined(player.pers["team"])) && (player.pers["team"] == team))
			teamcount++;
	}
	
	if(teamcount < level.teamlimit)
		return true;
	else
		return false;
}

updateTeamChangeCvars()
{
	players = CountPlayers();
	
	if(getcvar("g_gametype") == "dm" || level.maxclients < 2)
	{
		joinallies = 1;
		joinaxis = 1;
	}
	else
	{
		if(players["allies"] >= level.teamlimit)
			joinallies = 2;
		else
			joinallies = 1;

		if(players["axis"] >= level.teamlimit)
			joinaxis = 2;
		else
			joinaxis = 1;
	}
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator")
		{
			if(player.pers["team"] == "allies")
			{
				if(!isdefined(player.allow_joinallies) || player.allow_joinallies != 2)
				{
					player.allow_joinallies = 2;
					player setClientCvar("ui_allow_joinallies", player.allow_joinallies);
				}
					
				if(!isdefined(player.allow_joinaxis) || player.allow_joinaxis != joinaxis)
				{
					player.allow_joinaxis = joinaxis;
					player setClientCvar("ui_allow_joinaxis", player.allow_joinaxis);
				}
			}
			else if(player.pers["team"] == "axis")
			{
				if(!isdefined(player.allow_joinallies) || player.allow_joinallies != joinallies)
				{
					player.allow_joinallies = joinallies;
					player setClientCvar("ui_allow_joinallies", player.allow_joinallies);
				}
				
				if(!isdefined(player.allow_joinaxis) || player.allow_joinaxis != 2)
				{
					player.allow_joinaxis = 2;
					player setClientCvar("ui_allow_joinaxis", player.allow_joinaxis);
				}
			}
		}
		else
		{
			if(!isdefined(player.allow_joinallies) || player.allow_joinallies != joinallies)
			{
				player.allow_joinallies = joinallies;
				player setClientCvar("ui_allow_joinallies", player.allow_joinallies);
			}
				
			if(!isdefined(player.allow_joinaxis) || player.allow_joinaxis != joinaxis)
			{
				player.allow_joinaxis = joinaxis;
				player setClientCvar("ui_allow_joinaxis", player.allow_joinaxis);
			}
		}
	}
}

updateAutoAssignCvar()
{
	if(isdefined(self.pers["team"]) && (self.pers["team"] == "allies" || self.pers["team"] == "axis"))
		self setClientCvar("ui_allow_joinauto", "2");
	else
		self setClientCvar("ui_allow_joinauto", "1");
}

setPlayerModels()
{
	switch(game["allies"])
	{
		case "british":
			if(isdefined(game["british_soldiertype"]) && game["british_soldiertype"] == "africa")
			{
				mptype\british_africa::precache();
				game["allies_model"] = mptype\british_africa::main;
			}
			else
			{
				mptype\british_normandy::precache();
				game["allies_model"] = mptype\british_normandy::main;
			}
			break;
	
		case "russian":
			if(isdefined(game["russian_soldiertype"]) && game["russian_soldiertype"] == "padded")
			{
				mptype\russian_padded::precache();
				game["allies_model"] = mptype\russian_padded::main;
			}
			else
			{
				mptype\russian_coat::precache();
				game["allies_model"] = mptype\russian_coat::main;
			}
			break;
	
		case "american":
		default:
			mptype\american_normandy::precache();
			game["allies_model"] = mptype\american_normandy::main;
	}
	
	if(isdefined(game["german_soldiertype"]) && game["german_soldiertype"] == "winterdark")
	{
		mptype\german_winterdark::precache();
		game["axis_model"] = mptype\german_winterdark::main;
	}
	else if(isdefined(game["german_soldiertype"]) && game["german_soldiertype"] == "winterlight")
	{
		mptype\german_winterlight::precache();
		game["axis_model"] = mptype\german_winterlight::main;
	}
	else if(isdefined(game["german_soldiertype"]) && game["german_soldiertype"] == "africa")
	{
		mptype\german_africa::precache();
		game["axis_model"] = mptype\german_africa::main;
	}
	else
	{
		mptype\german_normandy::precache();
		game["axis_model"] = mptype\german_normandy::main;	
	}
}

model()
{
	self detachAll();
	
	if(self.pers["team"] == "allies")
		[[game["allies_model"] ]]();
	else if(self.pers["team"] == "axis")
		[[game["axis_model"] ]]();

	self.pers["savedmodel"] = maps\mp\_utility::saveModel();
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

addTestClients()
{
	wait 5;

	for(;;)
	{
		if(getCvarInt("scr_testclients") > 0)
			break;
		wait 1;
	}

	testclients = getCvarInt("scr_testclients");
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addtestclient();

		if(i & 1)
			team = "axis";
		else
			team = "allies";
		
		ent[i] thread TestClient(team);
	}
}

TestClient(team)
{
	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

	if(team == "allies")
		self notify("menuresponse", game["menu_weapon_allies"], "m1carbine_mp");
	else if(team == "axis")
		self notify("menuresponse", game["menu_weapon_axis"], "mp40_mp");
}

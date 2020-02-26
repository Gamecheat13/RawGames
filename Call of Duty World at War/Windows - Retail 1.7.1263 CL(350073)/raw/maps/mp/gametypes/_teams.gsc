init()
{
	switch(game["allies"])
	{
	case "marines":
		precacheShader("mpflag_american");
		break;
	}

	level.flameThrowerTankModel = "char_usa_raider_gear_flametank";
	level.flameThrowerTankAttachTag = "J_Spine4";
	
	precacheShader("mpflag_russian");
	precacheShader("mpflag_spectator");
	precacheModel( "char_usa_raider_gear_flametank" );

	game["strings"]["autobalance"] = &"MP_AUTOBALANCE_NOW";
	precacheString( &"MP_AUTOBALANCE_NOW" );
	precacheString( &"MP_AUTOBALANCE_NEXT_ROUND" );
	precacheString( &"MP_AUTOBALANCE_SECONDS" );

	if(getdvar("scr_teambalance") == "")
		setdvar("scr_teambalance", "0");
	if(getDvar( "scr_" + level.gameType + "_teamBalanceEndOfRound" ) == "" )
	{
		dvarString = ("scr_" + level.gameType + "_teamBalanceEndOfRound");
		if( level.gameType == "sd" )
			setdvar(dvarString, "1");
		else
			setdvar(dvarString, "0");
	}

	//if(getDvar( "scr_teamBalanceDeadFirst" ) == "" )
	//	setdvar("scr_teamBalanceDeadFirst", "0");

	//level.teamBalanceDeadFirst = getdvarInt("scr_teamBalanceDeadFirst");
	level.teamBalance = getdvarInt("scr_teambalance");
	level.teamBalanceEndOfRound = getdvarInt("scr_" + level.gameType + "_teamBalanceEndOfRound");
	level.maxClients = getDvarInt( "sv_maxclients" );
	
	if(getdvar("scr_timeplayedcap") == "")
		setdvar("scr_timeplayedcap", "1800");
	level.timeplayedcap = int(getdvarInt("scr_timeplayedcap"));

	setPlayerModels();

	level.freeplayers = [];

	if( level.teamBased )
	{
		level.alliesplayers = [];
		level.axisplayers = [];

		level thread onPlayerConnect();
		level thread updateTeamBalance();
	
		wait .15;
		level thread updatePlayerTimes();
	}
	else
	{
		level thread onFreePlayerConnect();
	
		wait .15;
		level thread updateFreePlayerTimes();
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
			}
			else if ( self.sessionteam == "axis" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
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
			level.players[nextToUpdate] updatePlayedTime();

		wait ( 4.0 );
	}
}


updatePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_allies", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_opfor", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
	}
		
	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_other", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );			
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );
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

updateTeamBalanceDvars()
{
	teambalance = getdvarInt("scr_teambalance");
	if(level.teambalance != teambalance)
		level.teambalance = teambalance;

//	teamBalanceDeadFirst = getdvarInt("scr_teamBalanceDeadFirst");
//	if(level.teamBalanceDeadFirst != teamBalanceDeadFirst)
//		level.teamBalanceDeadFirst = teamBalanceDeadFirst;

	timeplayedcap = getdvarInt("scr_timeplayedcap");
	if(level.timeplayedcap != timeplayedcap)
		level.timeplayedcap = int(getdvarInt("scr_timeplayedcap"));
}

updateTeamBalanceWarning()
{
	level endon ( "roundSwitching" );
	
	for(;;)
	{
		if( !getTeamBalance() )
		{
			iPrintLnBold( &"MP_AUTOBALANCE_NEXT_ROUND" );
			wait 15.0; 
		}
		wait 15.0; 
	}
}
updateTeamBalance()
{
	level.teamLimit = level.maxclients / 2;
	
	updateTeamBalanceDvars();
	
	wait .15;

	if ( level.teamBalance && level.teamBalanceEndOfRound )
	{
		level thread updateTeamBalanceWarning();
		level waittill( "roundSwitching" );

		if( !getTeamBalance() )
		{
			level balanceTeams();
		}
	}
	else
	{
		level endon ( "game_ended" );
		for( ;; )
		{
			wait 10.0;
			if( level.teamBalance )
			{
				if( !getTeamBalance() )
				{
					iPrintLnBold( &"MP_AUTOBALANCE_SECONDS", 15 );
				    wait 15.0;

					if( !getTeamBalance() )
						level balanceTeams();
				}
			}
			
			updateTeamBalanceDvars();
		}
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


canAutobalance(player)
{
	if ( !level.teamBalanceEndOfRound && ( ( isdefined( player.isDefusing ) && player.isDefusing ) || ( isdefined( player.isPlanting ) && player.isPlanting ) || isDefined( player.carryObject ) || isdefined( player.dont_auto_balance ) ) )
		return false;
	else
		return true;
	
}


balanceMostRecent()
{
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
			// Ignore players capturing or carrying objects
			for(j = 0; j < AlliedPlayers.size; j++)
			{
				if( !canAutobalance(AlliedPlayers[j]) )
					continue;
				
				if(!isdefined(MostRecent))
					MostRecent = AlliedPlayers[j];
				else if(AlliedPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AlliedPlayers[j];
			}
			
			if( isdefined( MostRecent ) )
				MostRecent changeTeam("axis");
			else
			{
				// Move the player that's been on the team the shortest ammount of time
				for(j = 0; j < AlliedPlayers.size; j++)
				{
					if(!isdefined(MostRecent))
						MostRecent = AlliedPlayers[j];
					else if(AlliedPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
						MostRecent = AlliedPlayers[j];
				}
				
				MostRecent changeTeam("axis");
			}
		}
		else if(AxisPlayers.size > (AlliedPlayers.size + 1))
		{
			// Move the player that's been on the team the shortest ammount of time (highest teamTime value)
			// Ignore players capturing or carrying objects
			for(j = 0; j < AxisPlayers.size; j++)
			{
				if( !canAutobalance(AxisPlayers[j]) )
					continue;

				if(!isdefined(MostRecent))
					MostRecent = AxisPlayers[j];
				else if(AxisPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
					MostRecent = AxisPlayers[j];
			}

			if( isdefined( MostRecent ) )
				MostRecent changeTeam("allies");
			else
			{
				// Move the player that's been on the team the shortest ammount of time
				for(j = 0; j < AxisPlayers.size; j++)
				{
					if(!isdefined(MostRecent))
						MostRecent = AxisPlayers[j];
					else if(AxisPlayers[j].pers["teamTime"] > MostRecent.pers["teamTime"])
						MostRecent = AxisPlayers[j];
				}
				
				MostRecent changeTeam("allies");
			}
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

balanceDeadPlayers()
{
	if( level.teamBalanceEndOfRound )
		return;

	//Create/Clear the team arrays
	AlliedPlayers = [];
	AxisPlayers = [];

	// Populate the team arrays
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
			AlliedPlayers[AlliedPlayers.size] = players[i];
		else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
			AxisPlayers[AxisPlayers.size] = players[i];
	}

	numToBalance = int( abs( AxisPlayers.size - AlliedPlayers.size) ) - 1;

	while( numToBalance > 0 && ((AlliedPlayers.size > (AxisPlayers.size + 1)) || (AxisPlayers.size > (AlliedPlayers.size + 1))))
	{	
		if(AlliedPlayers.size > (AxisPlayers.size + 1))
		{
			for(j = 0; j < AlliedPlayers.size; j++)
			{
				if( !isalive(AlliedPlayers[j]) )
				{
					AlliedPlayers[j] changeTeam("axis");
					break;
				}
			}			
		}
		else if(AxisPlayers.size > (AlliedPlayers.size + 1))
		{
			for(j = 0; j < AxisPlayers.size; j++)
			{
				if( !isalive(AxisPlayers[j]) )
				{
					AxisPlayers[j] changeTeam("axis");
					break;
				}
			}
		}

		AlliedPlayers = [];
		AxisPlayers = [];
		numToBalance--;
		
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

balanceTeams()
{
	iPrintLnBold( game["strings"]["autobalance"] );
	
	//if( level.teamBalanceDeadFirst )
		//balanceDeadPlayers();
	//if( !getTeamBalance() )
		balanceMostRecent();
}

changeTeam( team )
{
	self [[level.leavesquad]]();
	
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = team;
	
	if ( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["weapon"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;
	self.sessionteam = self.pers["team"];

	self maps\mp\gametypes\_globallogic::updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
	}
	
	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpselfguid = self getGuid();

	logPrint( "JT;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + "\n" );
	
	self notify("joined_team");
	self notify("end_respawn");
	
	self maps\mp\gametypes\_globallogic::beginClassChoice();
	
	self setclientdvar( "g_scriptMainMenu", game[ "menu_class_" + self.pers["team"] ] );
}


setPlayerModels()
{
	game["allies_model"] = [];

	alliesCharSet = tableLookup( "mp/mapsTable.csv", 0, getDvar( "mapname" ), 1 );
	if ( !isDefined( alliesCharSet ) || alliesCharSet == "" )
	{
		game["allies_soldiertype"] = "pacific";
		game["allies"] = "marines";
	}
	else
		game["allies_soldiertype"] = alliesCharSet;

	axisCharSet = tableLookup( "mp/mapsTable.csv", 0, getDvar( "mapname" ), 2 );
	if ( !isDefined( axisCharSet ) || axisCharSet == "" )
	{
		game["axis_soldiertype"] = "pacific";
		game["axis"] = "japanese";
	}
	else
		game["axis_soldiertype"] = axisCharSet;
	

	if ( game["allies_soldiertype"] == "german" )
	{
		//###stefan the changing of teams is causing this to trigger a ton
		// and as it is not a fatal condition, we're changing this assert() to a warning message
		// so our designers can continue to run
		//assert( game["allies"] == "russian" );
		if (game["allies"]!="russian")
		{
			IPrintLn("WARNING: game[\"allies\"]=="+game["allies"]+", expected\"russian\"");
		}

		mptype\mptype_rus_guard_rifle::precache();
		mptype\mptype_rus_guard_cqb::precache();
		mptype\mptype_rus_guard_assault::precache();
		mptype\mptype_rus_guard_lmg::precache();
		mptype\mptype_rus_guard_smg::precache();

		game["allies_model"]["SNIPER"] = mptype\mptype_rus_guard_rifle::main;
		game["allies_model"]["SUPPORT"] = mptype\mptype_rus_guard_lmg::main;
		game["allies_model"]["ASSAULT"] = mptype\mptype_rus_guard_assault::main;
		game["allies_model"]["RECON"] = mptype\mptype_rus_guard_cqb::main; 
		game["allies_model"]["SPECOPS"] = mptype\mptype_rus_guard_smg::main;
		game["allies_model"]["FLAMETHROWER"] = mptype\mptype_rus_guard_lmg::main;

		// custom class defaults
		game["allies_model"]["CLASS_CUSTOM1"] = mptype\mptype_rus_guard_assault::main;
		game["allies_model"]["CLASS_CUSTOM2"] = mptype\mptype_rus_guard_assault::main;
		game["allies_model"]["CLASS_CUSTOM3"] = mptype\mptype_rus_guard_assault::main;
		game["allies_model"]["CLASS_CUSTOM4"] = mptype\mptype_rus_guard_assault::main;
		game["allies_model"]["CLASS_CUSTOM5"] = mptype\mptype_rus_guard_assault::main;
	}
	else //if ( game["allies_soldiertype"] == "pacific" )
	{
		//###stefan the changing of teams is causing this to trigger a ton
		// and as it is not a fatal condition, we're changing this assert() to a warning message
		// so our designers can continue to run
		//assert( game["allies"] == "marines" );
		if (game["allies"]!="marines")
		{
			IPrintLn("WARNING: game[\"allies\"]=="+game["allies"]+", expected\"marines\"");
		}

		mptype\mptype_usa_raider_rifle::precache();
		mptype\mptype_usa_raider_cqb::precache();
		mptype\mptype_usa_raider_assault::precache();
		mptype\mptype_usa_raider_lmg::precache();
		mptype\mptype_usa_raider_smg::precache();

		game["allies_model"]["SNIPER"] = mptype\mptype_usa_raider_rifle::main;
		game["allies_model"]["SUPPORT"] = mptype\mptype_usa_raider_lmg::main;
		game["allies_model"]["ASSAULT"] = mptype\mptype_usa_raider_assault::main;
		game["allies_model"]["RECON"] = mptype\mptype_usa_raider_cqb::main; 
		game["allies_model"]["SPECOPS"] = mptype\mptype_usa_raider_smg::main;
		game["allies_model"]["FLAMETHROWER"] = mptype\mptype_usa_raider_cqb::main;

		// custom class defaults
		game["allies_model"]["CLASS_CUSTOM1"] = mptype\mptype_usa_raider_assault::main;
		game["allies_model"]["CLASS_CUSTOM2"] = mptype\mptype_usa_raider_assault::main;
		game["allies_model"]["CLASS_CUSTOM3"] = mptype\mptype_usa_raider_assault::main;
		game["allies_model"]["CLASS_CUSTOM4"] = mptype\mptype_usa_raider_assault::main;
		game["allies_model"]["CLASS_CUSTOM5"] = mptype\mptype_usa_raider_assault::main;
	}

	if ( game["axis_soldiertype"] == "german" )
	{
		//###stefan the changing of teams is causing this to trigger a ton
		// and as it is not a fatal condition, we're changing this assert() to a warning message
		// so our designers can continue to run
		//assert( game["axis"] == "german" );
		if (game["axis"]!="german")
		{
			IPrintLn("WARNING: game[\"axis\"]=="+game["axis"]+", expected\"german\"");
		}

		mptype\mptype_ger_hnrgrd_rifle::precache();
		mptype\mptype_ger_hnrgrd_cqb::precache();
		mptype\mptype_ger_hnrgrd_assault::precache();
		mptype\mptype_ger_hnrgrd_lmg::precache();
		mptype\mptype_ger_hnrgrd_smg::precache();

		game["axis_model"]["SNIPER"] = mptype\mptype_ger_hnrgrd_rifle::main;
		game["axis_model"]["SUPPORT"] = mptype\mptype_ger_hnrgrd_lmg::main;
		game["axis_model"]["ASSAULT"] = mptype\mptype_ger_hnrgrd_assault::main;
		game["axis_model"]["RECON"] = mptype\mptype_ger_hnrgrd_cqb::main;
		game["axis_model"]["SPECOPS"] = mptype\mptype_ger_hnrgrd_smg::main;
		game["axis_model"]["FLAMETHROWER"] = mptype\mptype_ger_hnrgrd_lmg::main;
		
		// custom class defaults
		game["axis_model"]["CLASS_CUSTOM1"] = mptype\mptype_ger_hnrgrd_assault::main;
		game["axis_model"]["CLASS_CUSTOM2"] = mptype\mptype_ger_hnrgrd_assault::main;
		game["axis_model"]["CLASS_CUSTOM3"] = mptype\mptype_ger_hnrgrd_assault::main;	
		game["axis_model"]["CLASS_CUSTOM4"] = mptype\mptype_ger_hnrgrd_assault::main;
		game["axis_model"]["CLASS_CUSTOM5"] = mptype\mptype_ger_hnrgrd_assault::main;
	}
	else //if ( game["axis_soldiertype"] == "pacific" )
	{
		//###stefan the changing of teams is causing this to trigger a ton
		// and as it is not a fatal condition, we're changing this assert() to a warning message
		// so our designers can continue to run
		//assert( game["axis"] == "japanese" );
		if (game["axis"]!="japanese")
		{
			IPrintLn("WARNING: game[\"axis\"]=="+game["axis"]+", expected\"japanese\"");
		}

		mptype\mptype_jap_impinf_rifle::precache();
		mptype\mptype_jap_impinf_cqb::precache();
		mptype\mptype_jap_impinf_assault::precache();
		mptype\mptype_jap_impinf_lmg::precache();
		mptype\mptype_jap_impinf_smg::precache();

		game["axis_model"]["SNIPER"] = mptype\mptype_jap_impinf_rifle::main;
		game["axis_model"]["SUPPORT"] = mptype\mptype_jap_impinf_lmg::main;
		game["axis_model"]["ASSAULT"] = mptype\mptype_jap_impinf_assault::main;
		game["axis_model"]["RECON"] = mptype\mptype_jap_impinf_cqb::main;
		game["axis_model"]["SPECOPS"] = mptype\mptype_jap_impinf_smg::main;
		game["axis_model"]["FLAMETHROWER"] = mptype\mptype_jap_impinf_smg::main;
		
		// custom class defaults
		game["axis_model"]["CLASS_CUSTOM1"] = mptype\mptype_jap_impinf_assault::main;
		game["axis_model"]["CLASS_CUSTOM2"] = mptype\mptype_jap_impinf_assault::main;
		game["axis_model"]["CLASS_CUSTOM3"] = mptype\mptype_jap_impinf_assault::main;	
		game["axis_model"]["CLASS_CUSTOM4"] = mptype\mptype_jap_impinf_assault::main;
		game["axis_model"]["CLASS_CUSTOM5"] = mptype\mptype_jap_impinf_assault::main;
	}
}

/*
model( class )
{
	self detachAll();
	
	if(self.pers["team"] == "allies")
		[[game["allies_model"][class]]]();
	else if(self.pers["team"] == "axis")
		[[game["axis_model"][class]]]();
}
*/

attachFlamethrowerTank()
{
	self attach( level.flameThrowerTankModel, level.flameThrowerTankAttachTag, true );
	self.flamethrowerTank = true;
}

detachFlamethrowerTank()
{
	if ( isdefined(self.flamethrowerTank) )
	{
		self detach( level.flameThrowerTankModel, level.flameThrowerTankAttachTag );
		self.flamethrowerTank = false;
		
		return true;
	}
	
	return false;
}

playerModelForWeapon( weapon )
{
	self detachAll();
	
	weaponClass = tablelookup( "mp/statstable.csv", 4, weapon, 2 );
	
	if ( self hasWeapon( "m2_flamethrower_mp" ) )
	{
		[[game[self.pers["team"]+"_model"]["FLAMETHROWER"]]]();
		attachFlamethrowerTank();
		return;
	}
	else
	{
			self.flamethrowerTank = undefined;
	}
	
	switch ( weaponClass )
	{
		case "weapon_smg":
			[[game[self.pers["team"]+"_model"]["SPECOPS"]]]();
			break;
		case "weapon_assault":
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
		case "weapon_sniper":
			[[game[self.pers["team"]+"_model"]["SNIPER"]]]();
			break;
		case "weapon_shotgun":
			[[game[self.pers["team"]+"_model"]["RECON"]]]();
			break;
		case "weapon_lmg":
			[[game[self.pers["team"]+"_model"]["SUPPORT"]]]();
			break;
		case "weapon_hmg":
			[[game[self.pers["team"]+"_model"]["SUPPORT"]]]();
			break;
		default:
			[[game[self.pers["team"]+"_model"]["ASSAULT"]]]();
			break;
	}
	
	
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

	for ( ;; )
	{
		if ( game["state"] == "playing" )
		{
			if ( isDefined( self.pers["team"] ) && self.pers["team"] == "allies" && self.sessionteam != "spectator" )
			{
				self.timePlayed["allies"]++;
				self.timePlayed["total"]++;
			}
			else if ( isDefined( self.pers["team"] ) && self.pers["team"] == "axis" && self.sessionteam != "spectator" )
			{
				self.timePlayed["axis"]++;
				self.timePlayed["total"]++;
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
			level.players[nextToUpdate] updateFreePlayedTime();

		wait ( 1.0 );
	}
}


updateFreePlayedTime()
{
	if ( self.timePlayed["allies"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_allies", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["allies"], level.timeplayedcap ) ) );
	}
	
	if ( self.timePlayed["axis"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_opfor", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["axis"], level.timeplayedcap ) ) );
	}
		
	if ( self.timePlayed["other"] )
	{
		self maps\mp\gametypes\_persistence::statAdd( "time_played_other", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );			
		self maps\mp\gametypes\_persistence::statAdd( "time_played_total", int( min( self.timePlayed["other"], level.timeplayedcap ) ) );
	}
	
	if ( game["state"] == "postgame" )
		return;

	self.timePlayed["allies"] = 0;
	self.timePlayed["axis"] = 0;
	self.timePlayed["other"] = 0;
}

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
main()
{	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_scorefeedback::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 5, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerScore = ::onPlayerScore;
	level.onDeathOccurred = ::onDeathOccurred;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
}






onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DM" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	setMapCenter( maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs ) );

	level.spawnpoints = getentarray("mp_tdm_spawn", "classname");

	allowed[0] = "bx_faceoff";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	level.QuickMessageToAll = true;	

	level.bond = undefined;				
	level.mastermind = undefined;		

	level.team_bond = "allies";
	level.team_villains = "axis";
	level.bond_class_vip = "mp_bx_secretservices_vip";
	level.villain_class_vip = "mp_bx_villain_vip";

	level.points = [];
	level.points["leader_kill_regular"]		 = 0;		
	level.points["leader_kill_leader"]		 = 10;		
	level.points["leader_teamkill"]			 = -2;		
	level.points["leader_suicide"]			 = -3;		
	level.points["henchman_kill_regular"]	 = 1;		
	level.points["henchman_kill_leader"]	 = 5;		
	level.points["henchman_teamkill_leader"] = -5;		
	level.points["henchman_teamkill"]	= -1;			
	level.points["henchman_suicide"]	= -1;			

	level.misc = [];
	level.misc["hud_font_scale"]		= 1.75;

	
	setDvar("respawn_delay", 10);
	setDvar("respawn_delay_inc", 5);
	setDvar("respawn_delay_max", 30);

	level.team_bond_state = "defend_bond";
	level.team_villains_state = "defend_mastermind";
}


onPrecacheGameType()
{
	precacheString(&"MP_YOU_ARE_BOND");
	precacheString(&"MP_YOU_ARE_MASTERMIND");
	precacheString(&"MP_WON_LEADERKILLED_BY_LEADER");
	precacheString(&"MP_WON_LEADERKILLED");
	precacheString(&"MP_LOST_LEADERKILLED");
	precacheString(&"MP_DEFEND_BOND");
	precacheString(&"MP_DEFEND_MASTERMIND");
	precacheString(&"MP_KILL_MASTERMIND");
	precacheString(&"MP_KILL_BOND");
}


onSpawnPlayer()
{	
	maps\mp\gametypes\_teams::regenerateTeamArrays();

	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );

	self.overrideLoadout = false;		

	self spawn( spawnPoint.origin, spawnPoint.angles );

	myTeam = self.pers["team"];

	
	if (myTeam != "spectator")
	{
		self updatePlayerHUD();

		if (myTeam == level.team_bond)
		{
			
			if (level.alliesplayers.size == 1 || !isDefined(level.bond))
			{
				self setLeader(level.team_bond);
			}
			
			else if (isDefined(level.bond) && self != level.bond && level.bond.dead)
			{
				self setLeader(level.team_bond);
			}
		}
		else
		{
			
			if (level.axisplayers.size == 1 || !isDefined(level.mastermind))	
			{
				self setLeader(level.team_villains);
			}
			
			if (isdefined(level.mastermind) && self != level.mastermind && level.mastermind.dead)
			{
				self setLeader(level.team_villains);
			}
		}
	}
	self.respawn_penalty = 0;
}


onPlayerScore(event,player,victim)
{
	points = 0;
	switch (event)
	{
		
		case "kill":
		case "death":
		case "teamkill":
		case "suicide":
			
			break;
		default:
			
			points = level.points[event];
			break;
	}

	curScore = maps\mp\gametypes\_globallogic::_getPlayerScore(player);
	player maps\mp\gametypes\_globallogic::_setPlayerScore(player,curScore + points);
	player thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(points);
}


onDeathOccurred(victim,attacker)
{
	
	
	
	
	
	
	

	
	
	
	if (attacker == victim)
	{
		if ( (isDefined(level.bond) && victim == level.bond) || (isDefined(level.mastermind) && victim == level.mastermind) )	
		{
			
			maps\mp\gametypes\_globallogic::givePlayerScore("leader_suicide",victim);											
		}
		else
		{
			
			maps\mp\gametypes\_globallogic::givePlayerScore("henchman_suicide",victim);											
		}
		if (!level.splitscreen)
			maps\mp\gametypes\_globallogic::giveRespawnPenalty(victim);
	}
	else
	{
		
		
		
		if (attacker.pers["team"] == victim.pers["team"])
		{
			if ((isDefined(level.bond) && attacker == level.bond) || (isDefined(level.mastermind) && attacker == level.mastermind))			
			{
				
				maps\mp\gametypes\_globallogic::givePlayerScore("leader_teamkill",attacker);									
			}
			else
			{
				if ( (isDefined(level.bond) && victim == level.bond) || (isDefined(level.mastermind) && victim == level.mastermind) )			
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("henchman_teamkill_leader",attacker);						
				}
				else															
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("henchman_teamkill",attacker);								
				}
			}
			if (!level.splitscreen)
				maps\mp\gametypes\_globallogic::giveRespawnPenalty(attacker);
		}
		
		
		
		else
		{
			if ( isDefined(level.bond) && attacker == level.bond)
			{
				if ( isDefined(level.mastermind) && victim == level.mastermind)		
				{
					
					iprintlnbold(&"MP_WON_LEADERKILLED_BY_LEADER",level.bond.name);						
					iprintlnbold(&"MP_WON_LEADERKILLED",level.mastermind.name);							
					maps\mp\gametypes\_globallogic::givePlayerScore("leader_kill_leader",attacker);		
				}
				else	
				{	
					
					maps\mp\gametypes\_globallogic::givePlayerScore("leader_kill_regular",attacker);	
				}
					
			}
			else if (isDefined(level.mastermind) && attacker == level.mastermind)
			{
				if ( isDefined(level.bond) && victim == level.bond)			
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("leader_kill_leader",attacker);		
					iprintlnbold(&"MP_WON_LEADERKILLED_BY_LEADER",level.mastermind.name);				
					iprintlnbold(&"MP_WON_LEADERKILLED",level.bond.name);								
				}
				else	
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("leader_kill_regular",attacker);	
				}
			}
			else
			{
				if ( (isDefined(level.bond) && victim == level.bond) || (isDefined(level.mastermind) && victim == level.mastermind) )	
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("henchman_kill_leader",attacker);	
					for (i = 0 ; i < level.players.size ; i++)
					{
						player = level.players[i];
						if (player.sessionstate != "playing")
							continue;
						if (player.pers["team"] == victim.pers["team"])
							player iprintlnbold(&"MP_LOST_LEADERKILLED");
						else
						{
							if (player.pers["team"] == level.team_bond)
								player iprintlnbold(&"MP_WON_LEADERKILLED",level.bond.name);
							else
								player iprintlnbold(&"MP_WON_LEADERKILLED",level.mastermind.name);
						}
							
					}
				}
				else
				{
					
					maps\mp\gametypes\_globallogic::givePlayerScore("henchman_kill_regular",attacker);	
				}
			}
		}
	}

	
	
	
	if (isdefined(level.bond) && victim == level.bond)
	{
		bondDead();
	}
	else if (isDefined(level.mastermind) && victim == level.mastermind)
	{
		mastermindDead();
	}
}



onPlayerDisconnect()
{
	if (isDefined(level.bond) && self == level.bond)
		bondDead();
	else if (isDefined(level.mastermind) && self == level.mastermind)
		mastermindDead();
}



bondDead()
{
	level.bond.dead = true;
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		if (player.pers["team"] == level.team_bond)
		{
			player.state = "kill_mastermind";
			player updatePlayerHUD();
		}
	}
}


mastermindDead()
{
	level.mastermind.dead = true;
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		if (player.pers["team"] == level.team_villains)
		{
			player.state = "kill_bond";
			player updatePlayerHUD();
		}
	}
}











setLeader(team)
{
	if (team == level.team_villains)
	{
		level.mastermind = self;
		level.mastermind.overrideLoadout = true;
		level.mastermind.dead = false;
		
		level.mastermind maps\mp\gametypes\_class::giveLoadout(level.team_villains,level.villain_class_vip);
		
		level.mastermind.state = "kill_bond";
		level.mastermind updatePlayerHUD();
		level.mastermind iPrintLnBold(&"MP_YOU_ARE_MASTERMIND");

		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			if (player.pers["team"] == level.team_villains && player != level.mastermind)
			{
				player.state = "defend_mastermind";
				player updatePlayerHUD();
			}
		}

		level.team_villains_state = "defend_mastermind";
	}
	else
	{
		level.bond = self;
		level.bond.overrideLoadout = true;
		level.bond.dead = false;
		level.bond maps\mp\gametypes\_class::giveLoadout(level.team_bond,level.bond_class_vip);

		level.bond.state = "kill_mastermind";
		level.bond updatePlayerHUD();
		level.bond iPrintLnBold(&"MP_YOU_ARE_BOND");

		for (i = 0 ; i < level.players.size ; i++)
		{
			player = level.players[i];
			if (player.pers["team"] == level.team_bond && player != level.bond)
			{
				player.state = "defend_bond";
				player updatePlayerHUD();
			}
		}

		level.team_bond_state = "defend_bond";
	}
}








updatePlayerHUD()
{
	if (isDefined(self.objDescriptionHUD))
		self.objDescriptionHUD destroyElem();

	if (!isDefined(self.state))
	{
		if (self.pers["team"] == level.team_bond)
			self.state = level.team_bond_state;
		else
			self.state = level.team_villains_state;
	}

	
	self.objDescriptionHUD = createFontString("default",level.misc["hud_font_scale"]);
	self.objDescriptionHUD.color = (1,1,1);
	self.objDescriptionHUD setPoint("TOPLEFT",undefined,0,0);

	switch(self.state)
	{
	case "defend_bond":			
		self.objDescriptionHUD setText(&"MP_DEFEND_BOND");
		break;
	case "defend_mastermind":	
		self.objDescriptionHUD setText(&"MP_DEFEND_MASTERMIND");
		break;
	case "kill_mastermind":		
		self.objDescriptionHUD setText(&"MP_KILL_MASTERMIND");
		break;
	case "kill_bond":			
		self.objDescriptionHUD setText(&"MP_KILL_BOND");
		break;
	}
}
init()
{
	level.spectateOverride["allies"] = spawnstruct();
	level.spectateOverride["axis"] = spawnstruct();

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onSpectatingClient();
	}
}


onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "joined_team" );
		self setSpectatePermissions();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "joined_spectators" );
		self setSpectatePermissions();
	}
}


onSpectatingClient()
{
	self endon("disconnect");
	
	for( ;; )
	{
		self waittill( "spectating_cycle" );

		// show the card for the player we're viewing. Could be undefined if the cyling failed
		spectatedPlayer = self GetSpectatingPlayer();
		if ( isDefined( spectatedPlayer ) )
		{
			self SetCardDisplaySlot( spectatedPlayer, 6 );
		}
	}
}



updateSpectateSettings()
{
	level endon ( "game_ended" );
	
	for ( index = 0; index < level.players.size; index++ )
		level.players[index] setSpectatePermissions();
}


getOtherTeam( team )
{
	if( level.multiTeamBased )
	{
		assertMsg( "getOtherTeam() should not be called in Multi Team Based gametypes" );
	}
	
	if ( team == "axis" )
		return "allies";
	else if ( team == "allies" )
		return "axis";
	else
		return "none";
}


setSpectatePermissions()
{
	team = self.sessionteam;

	if ( level.gameEnded && gettime() - level.gameEndTime >= 2000 )
	{
		if( level.multiTeamBased )
		{
			for( i = 0; i < level.teamNameList.size; i++ )
			{
				self allowSpectateTeam( level.teamNameList[i], false );
			}
		}
		else
		{
			self allowSpectateTeam( "allies", false );
			self allowSpectateTeam( "axis", false );
		}
		self allowSpectateTeam( "freelook", false );
		self allowSpectateTeam( "none", true );
		return;
	}
	
	spectateType = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "spectatetype" );

	switch( spectateType )
	{
		case 0: // disabled
			if( level.multiTeamBased )
			{
				for( i = 0; i < level.teamNameList.size; i++ )
				{
					self allowSpectateTeam( level.teamNameList[i], false );
				}
			}
			else
			{
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", false );
			}
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", false );
			break;
			
		case 1: // team/player only
			if ( !level.teamBased )
			{
				self allowSpectateTeam( "allies", true );
				self allowSpectateTeam( "axis", true );
				self allowSpectateTeam( "none", true );
				self allowSpectateTeam( "freelook", false );
			}
			else if ( isDefined( team ) && (team == "allies" || team == "axis") && !level.multiTeamBased )
			{
				self allowSpectateTeam( team, true );
				self allowSpectateTeam( getOtherTeam( team ), false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			else if ( isDefined( team ) && IsSubStr( team, "team_" ) && level.multiTeamBased )
			{	
				for( i = 0; i < level.teamNameList.size; i++ )
				{
					if( team == level.teamNameList[i] )
					{
						self allowSpectateTeam( level.teamNameList[i], true );
					}
					else
					{
						self allowSpectateTeam( level.teamNameList[i], false );
					}
				}
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			else
			{
				if( level.multiTeamBased )
				{
					for( i = 0; i < level.teamNameList.size; i++ )
					{
						self allowSpectateTeam( level.teamNameList[i], false );
					}
				}
				else
				{
					self allowSpectateTeam( "allies", false );
					self allowSpectateTeam( "axis", false );
				}
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			break;
		case 2: // free
			if( level.multiTeamBased )
			{
				for( i = 0; i < level.teamNameList.size; i++ )
				{
					self allowSpectateTeam( level.teamNameList[i], true );
				}
			}
			else
			{
				self allowSpectateTeam( "allies", true );
				self allowSpectateTeam( "axis", true );
			}
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );
			break;
	}
	
	if ( isDefined( team ) && (team == "axis" || team == "allies") )
	{
		if ( isdefined(level.spectateOverride[team].allowFreeSpectate) )
			self allowSpectateTeam( "freelook", true );
		
		if (isdefined(level.spectateOverride[team].allowEnemySpectate))
			self allowSpectateTeam( getOtherTeam( team ), true );
	}
}

init()
{
	foreach( team in level.teams )
	{
		level.spectateOverride[team] = spawnstruct();
	}
	
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self setSpectatePermissions();
	}
}


onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self setSpectatePermissionsForMachine();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self setSpectatePermissionsForMachine();
	}
}


updateSpectateSettings()
{
	level endon ( "game_ended" );
	
	for ( index = 0; index < level.players.size; index++ )
		level.players[index] setSpectatePermissions();
}


getSplitscreenTeam()
{
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !IsDefined(level.players[index]) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !(self IsPlayerOnSameMachine( level.players[index] )) )
			continue;
			
		team = level.players[index].sessionteam;

		// going to assume first non-spectator 
		if ( team != "spectator" )
			return team;
	}
	
	return self.sessionteam;
}

OtherLocalPlayerStillAlive()
{
	for ( index = 0 ; index < level.players.size ; index++ )
	{
		if ( !IsDefined( level.players[index] ) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !( self IsPlayerOnSameMachine( level.players[index] ) ) )
			continue;
		
		if ( IsAlive( level.players[index] ) )
			return true;
	}
	
	return false;
}

allowSpectateAllTeams( allow )
{
	foreach( team in level.teams )
	{
		self allowSpectateTeam( team, allow );
	}
}

allowSpectateAllTeamsExceptTeam( skip_team, allow )
{
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
		self allowSpectateTeam( team, allow );
	}
}

setSpectatePermissions()
{
	team = self.sessionteam;
	
	if ( team == "spectator" )
	{
		// in online splitscreen we are only going to allow spectators to 
		// spectate the team of the other player on splitscreen
		if ( self IsSplitScreen() && !level.splitscreen )
		{
			team = getSplitscreenTeam();
		}
			
		if ( team == "spectator" )
		{
			self allowSpectateAllTeams( true );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", true );
			return;
		}
	}
	
	spectateType = level.spectateType;
	
	switch( spectateType )
	{
		case 0: // disabled
			self allowSpectateAllTeams( false );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", false );
			break;
		case 3: // team only - strict splitscreen
			// player can only spectate other local players
			if ( self IsSplitScreen() && self OtherLocalPlayerStillAlive() )
			{
				self allowSpectateAllTeams( false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "localplayers", true );
				break;
			}
			// fall through
		case 1: // team only
			if ( !level.teamBased )
			{
				self allowSpectateAllTeams( true );
				self allowSpectateTeam( "none", true );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "localplayers", true );
			}
			else if ( isDefined( team ) && isdefined( level.teams[team] ) )
			{
				self allowSpectateTeam( team, true );
				self allowSpectateAllTeamsExceptTeam( team , false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "localplayers", true );
			}
			else
			{
				self allowSpectateAllTeams( false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
				self allowSpectateTeam( "localplayers", true );
			}
			break;
		case 2: // free
			self allowSpectateAllTeams( true );
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );
			self allowSpectateTeam( "localplayers", true );
			break;
	}
	
	if ( isDefined( team ) && isdefined( level.teams[team] ) )
	{
		if ( isdefined(level.spectateOverride[team].allowFreeSpectate) )
			self allowSpectateTeam( "freelook", true );
		
		if (isdefined(level.spectateOverride[team].allowEnemySpectate))
			self allowSpectateAllTeamsExceptTeam( team, true );
	}
}

setSpectatePermissionsForMachine()
{
//	error
	
	self setSpectatePermissions();
	
	if ( !self IsSplitScreen() )
		return;

	for ( index = 0; index < level.players.size; index++ )
	{
		if ( !IsDefined(level.players[index]) )
			continue;
			
		if ( level.players[index] == self )
			continue;
			
		if ( !(self IsPlayerOnSameMachine( level.players[index] )) )
			continue;
		
		level.players[index] setSpectatePermissions();
	}
}
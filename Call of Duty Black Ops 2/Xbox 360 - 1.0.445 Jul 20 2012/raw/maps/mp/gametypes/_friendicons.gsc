init()
{
	if ( level.createFX_enabled || SessionModeIsZombiesGame() )
		return;

	// Draws a team icon over teammates
	if(GetDvar( "scr_drawfriend") == "")
		SetDvar("scr_drawfriend", "0");
	level.drawfriend = GetDvarint( "scr_drawfriend");

	assert( IsDefined(game["headicon_allies"]), "Allied head icons are not defined.  Check the team set for the level.");
	assert( IsDefined(game["headicon_axis"]), "Axis head icons are not defined.  Check the team set for the level.");
	PreCacheHeadIcon( game["headicon_allies"] );
	precacheHeadIcon( game["headicon_axis"] );

	level thread onPlayerConnect();
	
	for(;;)
	{
		updateFriendIconSettings();
		wait 5;
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread showFriendIcon();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self.headicon = "";
	}
}	

showFriendIcon()
{
	if(level.drawfriend)
	{
		team = self.pers["team"];
		self.headicon = game["headicon_" + team];
		self.headiconteam = team;
	}
}
	
updateFriendIconSettings()
{
	drawfriend = GetDvarfloat( "scr_drawfriend");
	if(level.drawfriend != drawfriend)
	{
		level.drawfriend = drawfriend;

		updateFriendIcons();
	}
}

updateFriendIcons()
{
	// for all living players, show the appropriate headicon
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				team = self.pers["team"];
				self.headicon = game["headicon_" + team];
				self.headiconteam = team;
			}
			else
			{
				players = level.players;
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
	
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}
	}
}

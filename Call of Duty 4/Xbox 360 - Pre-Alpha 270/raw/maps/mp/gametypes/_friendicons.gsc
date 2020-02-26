init()
{
	// Draws a team icon over teammates
	if(getdvar("scr_drawfriend") == "")
		setdvar("scr_drawfriend", "0");
	level.drawfriend = getdvarInt("scr_drawfriend");

	switch( game["allies"] )
	{
		case "marines":
			game["headicon_allies"] = "faction_128_usmc_blue";
			break;
		case "sas":
			game["headicon_allies"] = "faction_128_usmc_blue";
			break;
		default:
			game["headicon_allies"] = "faction_128_usmc_blue";
			break;
	}
	switch( game["axis"] )
	{
		case "russian":
			game["headicon_axis"] = "faction_128_arab_blue";
			break;
		case "arab":
			game["headicon_axis"] = "faction_128_arab_blue";
			break;
		default:
			game["headicon_axis"] = "faction_128_arab_blue";
			break;
	}
	precacheShader( game["headicon_axis"] );
	precacheShader( game["headicon_axis"] );

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
		if(self.pers["team"] == "allies")
		{
			self.headicon = game["headicon_allies"];
			self.headiconteam = "allies";
		}
		else
		{
			self.headicon = game["headicon_axis"];
			self.headiconteam = "axis";
		}
	}
}
	
updateFriendIconSettings()
{
	drawfriend = getdvarFloat("scr_drawfriend");
	if(level.drawfriend != drawfriend)
	{
		level.drawfriend = drawfriend;

		updateFriendIcons();
	}
}

updateFriendIcons()
{
	// for all living players, show the appropriate headicon
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				if(player.pers["team"] == "allies")
				{
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else
				{
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
			}
			else
			{
				players = getentarray("player", "classname");
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

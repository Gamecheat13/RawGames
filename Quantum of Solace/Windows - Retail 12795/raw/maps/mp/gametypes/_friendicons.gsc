init()
{
	// Draws a team icon over teammates
	if(getdvar("scr_drawfriend") == "")
		setdvar("scr_drawfriend", "1");
	level.drawfriend = getdvarInt("scr_drawfriend");

	switch(game["allies"])
	{
	case "mi6":
		game["headicon_allies"] = "headicon_mi6";
		precacheHeadIcon(game["headicon_allies"]);
		break;
	case "marines":
		game["headicon_allies"] = "headicon_mi6";
		precacheHeadIcon(game["headicon_allies"]);
		break;
	}

	assert(game["axis"] == "opfor" || game["axis"] == "terrorists");
	game["headicon_axis"] = "headicon_enemy_a";
	precacheHeadIcon(game["headicon_axis"]);
	
	game["headicon_bond"] = "mp_bond_hud";
	precacheHeadIcon(game["headicon_bond"]);

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
			if( level.gametype == "be" && isDefined( self.isBond ) && self.isBond )
			{
				self.headicon = game["headicon_bond"];
			}
			else
			{
				self.headicon = game["headicon_allies"];
			}
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
					if( level.gametype == "be" && isDefined( player.isBond ) && player.isBond )
					{
						player.headicon = game["headicon_bond"];
					}
					else
					{
						player.headicon = game["headicon_allies"];
					}
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

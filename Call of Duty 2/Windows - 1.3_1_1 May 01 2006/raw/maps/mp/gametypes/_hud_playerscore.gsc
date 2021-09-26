init()
{
	switch(game["allies"])
	{
	case "american":
		game["hudicon_allies"] = "hudicon_american";
		break;
	
	case "british":
		game["hudicon_allies"] = "hudicon_british";
		break;
	
	case "russian":
		game["hudicon_allies"] = "hudicon_russian";
		break;
	}
	
	assert(game["axis"] == "german");
	game["hudicon_axis"] = "hudicon_german";

	precacheShader(game["hudicon_allies"]);
	precacheShader(game["hudicon_axis"]);
	precacheString(&"MP_SLASH");
	
	level thread onPlayerConnect();
	level thread onUpdateAllHUD();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.hud_playericon = newClientHudElem(player);
        player.hud_playericon.horzAlign = "left";
	    player.hud_playericon.vertAlign = "top";
	    player.hud_playericon.x = 6;
	    player.hud_playericon.y = 28;
	    player.hud_playericon.archived = false;
	    player.hud_playericon.alpha = 0;

	    player.hud_playerscore = newClientHudElem(player);
	    player.hud_playerscore.horzAlign = "left";
	    player.hud_playerscore.vertAlign = "top";
	    player.hud_playerscore.x = 36;
	    player.hud_playerscore.y = 26;
	    player.hud_playerscore.font = "default";
	    player.hud_playerscore.fontscale = 2;
	    player.hud_playerscore.archived = false;
	    player.hud_playerscore.alpha = 0;

        player.hud_playerscorelimit = newClientHudElem(player);
        player.hud_playerscorelimit.horzAlign = "left";
	    player.hud_playerscorelimit.vertAlign = "top";
		player.hud_playerscorelimit.x = 49;
	    player.hud_playerscorelimit.y = 26;
	    player.hud_playerscorelimit.font = "default";
	    player.hud_playerscorelimit.fontscale = 2;
	    player.hud_playerscorelimit.archived = false;
	    player.hud_playerscorelimit.label = (&"MP_SLASH");
	    player.hud_playerscorelimit.alpha = 0;

		player.hidescore = true;

		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onUpdatePlayerHUD();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");

		self thread updatePlayerHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");

		self thread updatePlayerHUD();
	}
}

onUpdatePlayerHUD()
{
	for(;;)
	{
		self waittill("update_playerhud_score");
		
		self thread updatePlayerHUD();
	}
}

onUpdateAllHUD()
{
	for(;;)
	{
		self waittill("update_allhud_score");
		
		level thread updateAllHUD();
	}
}

updatePlayerHUD()
{
	if(isdefined(self.pers["team"]))
	{
		hudicon["allies"] = game["hudicon_allies"];
		hudicon["axis"] = game["hudicon_axis"];

		if(self.pers["team"] == "allies" || self.pers["team"] == "axis")
		{
			self.hud_playericon setShader(hudicon[self.pers["team"]], 24, 24);
		    self.hud_playericon.alpha = 1;
			self.hud_playerscore setValue(self.score);
		    self.hud_playerscore.alpha = 1;

			if(level.scorelimit > 0)
			{
				self.hud_playerscorelimit setValue(level.scorelimit);
				self.hud_playerscorelimit.x = getScoreLimitPosition(self.score);
				self.hud_playerscorelimit.alpha = 1;
			}
			else
				self.hud_playerscorelimit.alpha = 0;
		}
		else if(self.pers["team"] == "spectator")
		{
		    self.hud_playericon.alpha = 0;
		    self.hud_playerscore.alpha = 0;
		    self.hud_playerscorelimit.alpha = 0;
		}
	}
}

updateAllHUD()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread updatePlayerHUD();
}

getScoreLimitPosition(score)
{
	offset = 0;
	
	if(score < 0)
	{
		score = score * -1;
		offset = 7;
	}

	if(score >= 10000)
		offset += 48;
	else if(score >= 1000)
		offset += 36;
	else if(score >= 100)
		offset += 24;
	else if(score >= 10)
		offset += 12;
		
	return 49 + offset;
}

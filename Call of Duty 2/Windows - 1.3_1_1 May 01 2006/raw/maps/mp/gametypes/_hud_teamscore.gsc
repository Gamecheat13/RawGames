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

		player.hud_alliedicon = newClientHudElem(player);
		player.hud_alliedicon.horzAlign = "left";
		player.hud_alliedicon.vertAlign = "top";
		player.hud_alliedicon.x = 6;
		player.hud_alliedicon.y = 28;
		player.hud_alliedicon.archived = false;

		player.hud_axisicon = newClientHudElem(player);
		player.hud_axisicon.horzAlign = "left";
		player.hud_axisicon.vertAlign = "top";
		player.hud_axisicon.x = 6;
		player.hud_axisicon.y = 50;
		player.hud_axisicon.archived = false;

		player.hud_alliedscore = newClientHudElem(player);
		player.hud_alliedscore.horzAlign = "left";
		player.hud_alliedscore.vertAlign = "top";
		player.hud_alliedscore.x = 36;
		player.hud_alliedscore.y = 26;
		player.hud_alliedscore.font = "default";
		player.hud_alliedscore.fontscale = 2;
		player.hud_alliedscore.archived = false;

		player.hud_axisscore = newClientHudElem(player);
		player.hud_axisscore.horzAlign = "left";
		player.hud_axisscore.vertAlign = "top";
		player.hud_axisscore.x = 36;
		player.hud_axisscore.y = 48;
		player.hud_axisscore.font = "default";
		player.hud_axisscore.fontscale = 2;
		player.hud_axisscore.archived = false;

        player.hud_alliedscorelimit = newClientHudElem(player);
        player.hud_alliedscorelimit.horzAlign = "left";
	    player.hud_alliedscorelimit.vertAlign = "top";
		player.hud_alliedscorelimit.x = 49;
	    player.hud_alliedscorelimit.y = 26;
	    player.hud_alliedscorelimit.font = "default";
	    player.hud_alliedscorelimit.fontscale = 2;
	    player.hud_alliedscorelimit.archived = false;
	    player.hud_alliedscorelimit.label = (&"MP_SLASH");

        player.hud_axisscorelimit = newClientHudElem(player);
        player.hud_axisscorelimit.horzAlign = "left";
	    player.hud_axisscorelimit.vertAlign = "top";
		player.hud_axisscorelimit.x = 49;
	    player.hud_axisscorelimit.y = 48;
	    player.hud_axisscorelimit.font = "default";
	    player.hud_axisscorelimit.fontscale = 2;
	    player.hud_axisscorelimit.archived = false;
	    player.hud_axisscorelimit.label = (&"MP_SLASH");

		player.hud_alliedicon setShader(game["hudicon_allies"], 24, 24);
		player.hud_axisicon setShader(game["hudicon_axis"], 24, 24);
		
		player thread updatePlayerHUD();
		player thread onUpdatePlayerHUD();
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
	alliedscore = getTeamScore("allies");
	axisscore = getTeamScore("axis");

	if(alliedscore > axisscore)
		winningteam = "allies";
	else if(axisscore > alliedscore)
		winningteam = "axis";
	else
		winningteam = "tied";

	if(winningteam == "allies")
	{
		if(self.hud_alliedicon.y != 28)
			self.hud_alliedicon.y = 28;
		if(self.hud_alliedscore.y != 26)
			self.hud_alliedscore.y = 26;
	    if(self.hud_alliedscorelimit.y != 26)
	    	self.hud_alliedscorelimit.y = 26;
		if(self.hud_axisicon.y != 50)
			self.hud_axisicon.y = 50;
		if(self.hud_axisscore.y != 48)
			self.hud_axisscore.y = 48;
	    if(self.hud_axisscorelimit.y != 48)
	    	self.hud_axisscorelimit.y = 48;
	}
	else if(winningteam == "axis")
	{
		if(self.hud_axisicon.y != 28)
			self.hud_axisicon.y = 28;
		if(self.hud_axisscore.y != 26)
			self.hud_axisscore.y = 26;
	    if(self.hud_axisscorelimit.y != 26)
	    	self.hud_axisscorelimit.y = 26;
		if(self.hud_alliedicon.y != 50)
			self.hud_alliedicon.y = 50;
		if(self.hud_alliedscore.y != 48)
			self.hud_alliedscore.y = 48;
	    if(self.hud_alliedscorelimit.y != 48)
	    	self.hud_alliedscorelimit.y = 48;
	}

	alliedposition = getScoreLimitPosition(alliedscore);
	axisposition = getScoreLimitPosition(axisscore);
	
	self.hud_alliedscore setValue(alliedscore);
	self.hud_axisscore setValue(axisscore);

	if(level.scorelimit > 0)
	{
		self.hud_alliedscorelimit.x = alliedposition;
		self.hud_axisscorelimit.x = axisposition;
		self.hud_alliedscorelimit setValue(level.scorelimit);
		self.hud_axisscorelimit setValue(level.scorelimit);
		self.hud_alliedscorelimit.alpha = 1;
		self.hud_axisscorelimit.alpha = 1;
	}
	else
	{
		self.hud_alliedscorelimit.alpha = 0;
		self.hud_axisscorelimit.alpha = 0;
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

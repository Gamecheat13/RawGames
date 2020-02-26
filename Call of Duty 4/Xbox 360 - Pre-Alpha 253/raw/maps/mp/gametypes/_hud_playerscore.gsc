#include maps\mp\gametypes\_hud_util;

init()
{
	switch(game["allies"])
	{
	case "marines":
		game["hudicon_allies"] = "hudicon_american";
		break;
	}
	
	assert(game["axis"] == "opfor");
	game["hudicon_axis"] = "hudicon_opfor";

	precacheShader(game["hudicon_allies"]);
	precacheShader(game["hudicon_axis"]);
	precacheShader("hud_teamcaret"); 
	
	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showscore" ) )
		return;
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onUpdatePlayerScoreHUD();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread removePlayerHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread removePlayerHUD();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_playericon))
		{
			self.hud_playericon = createIcon( undefined, 20, 20 );
			self.hud_playericon setPoint( "TOPLEFT", "TOPLEFT", 8, 16 );
			self.hud_playericon.foreground = true;
		}

		if(!isdefined(self.hud_playerscorebar))
		{
			self.hud_playerscorebar = createBar( (0, 1, 0), 80, 18 );
			self.hud_playerscorebar setParent( self.hud_playericon );
			self.hud_playerscorebar setPoint( "LEFT", "RIGHT" );
			self.hud_playerscorebar.bar.foreground = true;
			self.hud_playerscorebar.barFrame.foreground = true;
			self.hud_playerscorebar.foreground = true;
		}

		if(!isdefined(self.hud_playerscore))
		{
			self.hud_playerscore = createFontString( "default", 1.5 );
			self.hud_playerscore setParent( self.hud_playerscorebar );
			self.hud_playerscore setPoint( "LEFT", "RIGHT", 2, -1 );
			self.hud_playerscore.foreground = true;
		}

		if(!isdefined(self.hud_playercaret))
		{
			self.hud_playercaret = createIcon( "hud_teamcaret", 20, 20 );
			self.hud_playercaret setParent( self.hud_playericon );
			self.hud_playercaret setPoint( "TOPRIGHT", "TOPLEFT", 7, 0 );
			self.hud_playercaret.foreground = true;
		}

		if(self.pers["team"] == "allies")
			self.hud_playericon setIconShader( game["hudicon_allies"] );
		else if(self.pers["team"] == "axis")
			self.hud_playericon setIconShader( game["hudicon_axis"] );
		
		self thread updatePlayerScoreHUD();
	}
}


onUpdatePlayerScoreHUD()
{
	for(;;)
	{
		self waittill("update_playerscore_hud");
		
		self thread updatePlayerScoreHUD();
	}
}

updatePlayerScoreHUD()
{
	if(isDefined(self.hud_playerscore))
		self.hud_playerscore setValue(self.score);
		
	if (isDefined(self.hud_playerscorebar)) 			
		self.hud_playerscorebar updateBar( self.score / level.scorelimit );
	
}

removePlayerHUD()
{
	if(isDefined(self.hud_playerscore))
		self.hud_playerscore destroyElem();

	if(isDefined(self.hud_playerscorebar))
		self.hud_playerscorebar destroyElem();

	if(isDefined(self.hud_playericon))
		self.hud_playericon destroyElem();
}


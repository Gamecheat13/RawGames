




init()
{
	precacheString(&"MP_PLUS");
	precacheString(&"MP_MINUS");
	level thread onPlayerConnect();
}




onPlayerConnect()
{
	level endon ("game_ended");
	while (1)
	{
		level waittill("connected",player);
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}




onJoinedTeam()
{
	self endon("disconnect");

	while(1)
	{
		self waittill("joined_team");
		self thread removeScoreFeedbackHUD();
	}
}






onJoinedSpectators()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("joined_spectators");
		self thread removeScoreFeedbackHUD();
	}
}




onPlayerSpawned()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_scorefeedback))
		{
			self.hud_scorefeedback = newClientHudElem(self);
			self.hud_scorefeedback.horzAlign = "center";
			self.hud_scorefeedback.vertAlign = "middle";
			self.hud_scorefeedback.alignX = "center";
			self.hud_scorefeedback.alignY = "middle";
	 		self.hud_scorefeedback.x = 0;
			self.hud_scorefeedback.y = -60;
			self.hud_scorefeedback.font = "default";
			self.hud_scorefeedback.fontscale = 2;
			self.hud_scorefeedback.archived = false;
			self.hud_scorefeedback.color = (1,1,0);			
			
		}
	}
}




removeScoreFeedbackHUD()
{
	if (isDefined(self.hud_scorefeedback))
		self.hud_scorefeedback destroy();
}





giveScoreFeedback(value)
{
	label = &"MP_PLUS";
	if (value < 0)
	{
		label = &"MP_MINUS";
		value *= -1;
	}	

	self updateScoreFeedbackHUD(value,label);
}





giveTeamScoreFeedback(team,value)
{
	for (i = 0 ; i < level.players.size; i++)
	{
		player = level.players[i];
		if (player.pers["team"] == team)
		{
			player thread maps\mp\gametypes\_scorefeedback::giveScoreFeedback(value);
		}
	}
}




updateScoreFeedbackHUD(amount,label)
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	if (!amount)	
		return;

	if (isDefined(self.hud_scorefeedback))
	{
		self.hud_scorefeedback.label = label;
		self.hud_scorefeedback setValue(amount);
		self.hud_scorefeedback.alpha = 1;
		
		wait 1;
		self.hud_scorefeedback fadeOverTime( 1.5 );
		self.hud_scorefeedback.alpha = 0;
	}
}



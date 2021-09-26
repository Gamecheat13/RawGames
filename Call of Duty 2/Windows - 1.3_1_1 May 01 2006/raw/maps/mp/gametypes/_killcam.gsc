init()
{
	precacheString(&"MP_KILLCAM");
	precacheString(&"PLATFORM_PRESS_TO_SKIP");
	precacheString(&"PLATFORM_PRESS_TO_RESPAWN");
	precacheShader("black");
	
	killcam = getCvar("scr_killcam");
	if(killcam == "")							// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	
	if(level.killcam > 0)
		setarchive(true);

	for(;;)
	{
		updateKillcamSettings();
		wait 1;
	}
}

updateKillcamSettings()
{
	killcam = getCvarInt("scr_killcam");
	if(level.killcam != killcam)
	{
		level.killcam = getCvarInt("scr_killcam");
		if((level.killcam > 0) || (getCvarInt("g_antilag") > 0))
			setarchive(true);
		else
			setarchive(false);
	}
}

killcam(attackerNum, delay, offsetTime, respawn)
{
	self endon("spawned");

	// killcam
	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;
	self.psoffsettime = offsetTime;

	// ignore spectate permissions
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		
		return;
	}
	
	self.killcam = true;

	if(!level.splitscreen && !isdefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.horzAlign = "fullscreen";
		self.kc_topbar.vertAlign = "fullscreen";
		self.kc_topbar.alpha = 0.5;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!level.splitscreen && !isdefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.horzAlign = "fullscreen";
		self.kc_bottombar.vertAlign = "fullscreen";
		self.kc_bottombar.alpha = 0.5;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isdefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 0;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.horzAlign = "center_safearea";
		self.kc_title.vertAlign = "top";
		self.kc_title.sort = 1; // force to draw after the bars
		self.kc_title.fontScale = 3.5;

		if(level.splitscreen)
			self.kc_title.y = 22;
		else
			self.kc_title.y = 30;
	}
	self.kc_title setText(&"MP_KILLCAM");

	if(!isdefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.horzAlign = "center_safearea";
		self.kc_skiptext.vertAlign = "top";
		self.kc_skiptext.sort = 1; // force to draw after the bars
		self.kc_skiptext.font = "default";
		
		if(level.splitscreen)
		{
			self.kc_skiptext.y = 52;
			self.kc_skiptext.fontscale = 1.6;
		}
		else
		{
			self.kc_skiptext.y = 70;
			self.kc_skiptext.fontscale = 2;
		}
	}
	if(isdefined(respawn)) 
		self.kc_skiptext setText(&"PLATFORM_PRESS_TO_RESPAWN");
	else
		self.kc_skiptext setText(&"PLATFORM_PRESS_TO_SKIP");

	if(!level.splitscreen)
	{
		if(!isdefined(self.kc_timer))
		{
			self.kc_timer = newClientHudElem(self);
			self.kc_timer.archived = false;
			self.kc_timer.x = 0;
			self.kc_timer.y = -32;
			self.kc_timer.alignX = "center";
			self.kc_timer.alignY = "middle";
			self.kc_timer.horzAlign = "center_safearea";
			self.kc_timer.vertAlign = "bottom";
			self.kc_timer.fontScale = 3.5;
			self.kc_timer.sort = 1;
		}

		self.kc_timer setTenthsTimer(self.archivetime - delay);
	}

	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self removeKillcamElements();

	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	
	self.killcam = undefined;
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait(self.archivetime - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("disconnect");
	self endon("end_killcam");

	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;

	self notify("end_killcam");
}

removeKillcamElements()
{
	if(isDefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isDefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isDefined(self.kc_title))
		self.kc_title destroy();
	if(isDefined(self.kc_skiptext))
		self.kc_skiptext destroy();
	if(isDefined(self.kc_timer))
		self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self removeKillcamElements();
}
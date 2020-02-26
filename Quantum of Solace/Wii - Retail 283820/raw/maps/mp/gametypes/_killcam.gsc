init()
{
	precacheString(&"MP_KILLCAM");
	precacheString(&"PLATFORM_PRESS_TO_SKIP");
	precacheString(&"PLATFORM_PRESS_TO_RESPAWN");
	precacheShader("black");
	
	level.killcam = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "allowkillcam" );
	
	if( level.killcam )
		setArchive(true);

	for(;;)
	{
		updateKillcamSettings();
		wait 1;
	}
}

updateKillcamSettings()
{
	
}

killcam(
	attackerNum, 
	sWeapon, 
	predelay, 
	offsetTime, 
	respawn, 
	maxtime 
)
{
	self endon("spawned");

	if(attackerNum < 0)
		return;

	
	if (getdvar("scr_killcam_time") == "") {
		if ( !respawn ) 
			camtime = 5.0;
		else if (sWeapon == "frag_grenade_mp")
			camtime = 4.5; 
		else
			camtime = 2.5;
	}
	else
		camtime = getdvarfloat("scr_killcam_time");
	
	if (isdefined(maxtime)) {
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	
	if (getdvar("scr_killcam_posttime") == "")
		postdelay = 2;
	else {
		postdelay = getdvarfloat("scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	
	
	killcamlength = camtime + postdelay;
	
	
	if (isdefined(maxtime) && killcamlength > maxtime)
	{
		
		
		
		if (maxtime < 2)
			return;

		if (maxtime - camtime >= 1) {
			
			postdelay = maxtime - camtime;
		}
		else {
			
			postdelay = 1;
			camtime = maxtime - 1;
		}
		
		
		killcamlength = camtime + postdelay;
	}

	killcamoffset = camtime + predelay;
	
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	
	wait 0.05;

	if(self.archivetime <= predelay) 
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
		self.kc_title.sort = 1; 
		self.kc_title.fontScale = 3.5;

		if(level.splitscreen)
			self.kc_title.y = 22;
		else
			self.kc_title.y = 25;
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
		self.kc_skiptext.sort = 1; 
		self.kc_skiptext.font = "default";
		
		if(level.splitscreen)
		{
			self.kc_skiptext.y = 52;
			self.kc_skiptext.fontscale = 1.6;
		}
		else
		{
			self.kc_skiptext.y = 60;
			self.kc_skiptext.fontscale = 2;
		}
	}
	if (respawn)
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

		self.kc_timer setTenthsTimer(camtime);
	}

	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self endKillcam();

	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");
	wait(self.killcamlength - 0.05);
	level.inkillcamtime = (self.killcamlength - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
	{
		level.inkillcamtime += 0.05;
		wait .05;
	}

	self notify("end_killcam");
}

endKillcam()
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
	
	self.killcam = undefined;
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self endKillcam();
}
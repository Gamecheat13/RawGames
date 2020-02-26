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
	/*
	killcam = getdvarInt("scr_killcam");
	if(level.killcam != killcam)
	{
		level.killcam = getdvarInt("scr_killcam");
		if((level.killcam > 0) || (getdvarInt("g_antilag") > 0))
			setarchive(true);
		else
			setarchive(false);
	}
	*/
}

killcam(
	attackerNum, // entity number of the attacker
	sWeapon, // killing weapon
	predelay, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	respawn, // will the player be allowed to respawn after the killcam?
	maxtime // time remaining until map ends; the killcam will never last longer than this. undefined = no limit
)
{
	// monitors killcam and hides HUD elements during killcam session
	//if ( !level.splitscreen )
	//	self thread killcam_HUD_off();
	
	self endon("spawned");

	if(attackerNum < 0)
		return;

	// length from killcam start to killcam end
	if (getdvar("scr_killcam_time") == "") {
		if ( !respawn ) // if we're not going to respawn, we can take more time to watch what happened
			camtime = 5.0;
		else if (sWeapon == "frag_grenade_mp")
			camtime = 4.5; // show long enough to see grenade thrown
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
	
	// time after player death that killcam continues for
	if (getdvar("scr_killcam_posttime") == "")
		postdelay = 2;
	else {
		postdelay = getdvarfloat("scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	/* timeline:
	
	|        camtime       |      postdelay      |
	|                      |   predelay    |
	
	^ killcam start        ^ player death        ^ killcam end
	                                       ^ player starts watching killcam
	
	*/
	
	killcamlength = camtime + postdelay;
	
	// don't let the killcam last past the end of the round.
	if (isdefined(maxtime) && killcamlength > maxtime)
	{
		// first trim postdelay down to a minimum of 1 second.
		// if that doesn't make it short enough, trim camtime down to a minimum of 1 second.
		// if that's still not short enough, cancel the killcam.
		if (maxtime < 2)
			return;

		if (maxtime - camtime >= 1) {
			// reduce postdelay so killcam ends at end of match
			postdelay = maxtime - camtime;
		}
		else {
			// distribute remaining time over postdelay and camtime
			postdelay = 1;
			camtime = maxtime - 1;
		}
		
		// recalc killcamlength
		killcamlength = camtime + postdelay;
	}

	killcamoffset = camtime + predelay;
	
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	// ignore spectate permissions
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= predelay) // if we're not looking back in time far enough to even see the death, cancel
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
		self.kc_skiptext.sort = 1; // force to draw after the bars
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
	
	// restores hud setting after killcam
	//if ( !level.splitscreen )
	//	self thread killcam_HUD_on();
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self endKillcam();
}
/*
killcam_HUD_off()
{
	// store hud settings
	self.stored_showGPS = getDvar( "ui_hud_showGPS" );
	self.stored_showweaponinfo = getDvar( "ui_hud_showweaponinfo" );
	self.stored_showrankinfo = getDvar( "ui_hud_showrankinfo" );
	
	self setclientdvar( "ui_hud_showGPS", "0" );
	self setclientdvar( "ui_hud_showweaponinfo", "0" );
	self setclientdvar( "ui_hud_showrankinfo", "0" );
}

killcam_HUD_on()
{
	// restore hud settings
	self setclientdvar( "ui_hud_showGPS", self.stored_showGPS );
	self setclientdvar( "ui_hud_showweaponinfo", self.stored_showweaponinfo );
	self setclientdvar( "ui_hud_showrankinfo", self.stored_showrankinfo );
}
/*
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString(&"PLATFORM_PRESS_TO_SKIP");
	precacheString(&"PLATFORM_PRESS_TO_RESPAWN");
	//precacheString(&"PLATFORM_PRESS_TO_SAFESPAWN");
	
	//precacheString(&"PLATFORM_PRESS_TO_COPYCAT");
	//precacheShader("specialty_copycat");
	
	precacheShader("white");
	
	level.killcam = GetGametypeSetting( "allowKillcam" );
	level.finalkillcam = GetGametypeSetting( "allowFinalKillcam" );
	
	//if( level.killcam )
	//	setArchive(true);
}

finalKillcamWaiter()
{
	if ( !level.inFinalKillcam )
		return;
		
	while (level.inFinalKillcam)
		wait(0.05);
}

postRoundFinalKillcam()
{
	if ( isDefined( level.sidebet ) && level.sidebet )
	{
		return;
	}
	level notify( "play_final_killcam" );
	maps\mp\gametypes\_globallogic::resetOutcomeForAllPlayers();
	finalKillcamWaiter();	
}

startFinalKillcam( 
	attackerNum, // entity number of the attacker
	targetNum, // entity number of the target
	killcamentity, // entity to view during killcam aka helicopter or airstrike
	killcamentityindex, // entity number of the above
	killcamentitystarttime, // time at which the killcamentity came into being
	sWeapon, // killing weapon
	deathTime, // time when the player died
	deathTimeOffset, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	perks, // the perks the attacker had at the time of the kill
	killstreaks, // the killstreaks the attacker had at the time of the kill
	attacker // entity object of attacker
)
{
	if ( !level.finalkillcam )
		return;
		
	if(attackerNum < 0)
		return;

	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, killcamentityindex, killcamentitystarttime, perks, killstreaks, attacker  );

	startLastKillcam();
}

startLastKillcam()
{
	if ( !level.finalkillcam )
		return;

	if ( level.inFinalKillcam )
		return;

	if ( !IsDefined(level.lastKillCam) )
		return;
	
	level.inFinalKillcam = true;

	level waittill ( "play_final_killcam" );

	if ( isdefined ( level.lastKillCam.attacker ) ) 
	{
		maps\mp\_challenges::getFinalKill( level.lastKillCam.attacker );
	}

	visionSetNaked( GetDvar( "mapname" ), 0.0 );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		player closeMenu(); 
		player closeInGameMenu();
		player thread finalKillcam();
	}
	
	wait( 0.1 );

	while ( areAnyPlayersWatchingTheKillcam() )
		wait( 0.05 );

	level.inFinalKillcam = false;
}


areAnyPlayersWatchingTheKillcam()
{
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		if ( isDefined( player.killcam ) )
			return true;
	}
	
	return false;
}

killcam(
	attackerNum, // entity number of the attacker
	targetNum, // entity number of the target
	killcamentity, // entity to view during killcam aka helicopter or airstrike
	killcamentityindex, // entity number of the above
	killcamentitystarttime, // time at which the killcamentity came into being
	sWeapon, // killing weapon
	deathTime, // time when the player died
	deathTimeOffset, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	respawn, // will the player be allowed to respawn after the killcam?
	maxtime, // time remaining until map ends; the killcam will never last longer than this. undefined = no limit
	perks, // the perks the attacker had at the time of the kill
	killstreaks, // the killstreaks the attacker had at the time of the kill
	attacker // entity object of attacker
)
{
	// monitors killcam and hides HUD elements during killcam session
	//if ( !level.splitscreen )
	//	self thread killcam_HUD_off();
	
	self endon("disconnect");
	self endon("spawned");
	level endon("game_ended");

	if(attackerNum < 0)
		return;

	postDeathDelay = (getTime() - deathTime) / 1000;
	predelay = postDeathDelay + deathTimeOffset;
	
	camtime = calcKillcamTime( sWeapon, killcamentitystarttime, predelay, respawn, maxtime );
	postdelay = calcPostDelay();
	
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
	
	self notify ( "begin_killcam", getTime() );
	
	killcamstarttime = (gettime() - killcamoffset * 1000);
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = -1;
	if ( killcamentityindex >= 0 )
		self thread setKillCamEntity( killcamentityindex, killcamentitystarttime - killcamstarttime - 100 );
	self.killcamtargetentity = targetNum;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	recordKillcamSettings( attackerNum, targetNum, sWeapon, deathTime, deathTimeOffset, offsetTime, killcamentityindex, killcamentitystarttime, perks, killstreaks, attacker );

	// ignore spectate permissions
	foreach( team in level.teams )
	{
		self allowSpectateTeam(team, true);
	}
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	self thread endedKillcamCleanup();

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		
		self notify ( "end_killcam" );

		return;
	}

	self thread checkForAbruptKillcamEnd();
	
	self.killcam = true;
	
	//self initKCElements();

	self addKillcamSkipText(respawn);

	if ( !( self IsSplitscreen() ) && level.perksEnabled == 1 )
	{
		self addKillcamTimer(camtime);
		self maps\mp\gametypes\_hud_util::showPerks( );
//		for ( numSpecialties = 0; numSpecialties < perks.size; numSpecialties++ )
//		{
//			self maps\mp\gametypes\_hud_util::showPerk( numSpecialties, perks[ numSpecialties ], 10);
//		}
	}
		
	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitTeamChangeEndKillcam();
	//self thread waitSkipKillcamSafeSpawnButton();
	self thread waitKillcamTime();
	self thread maps\mp\_tacticalinsertion::cancel_button_think();
	
	self waittill("end_killcam");

	self endKillcam(false);

	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

setKillCamEntity( killcamentityindex, delayms )
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("spawned");
	
	if ( delayms > 0 )
		wait delayms / 1000;
	
	self.killcamentity = killcamentityindex;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait(self.killcamlength - 0.05);
	self notify("end_killcam");
}

waitFinalKillcamSlowdown( startTime )
{
	self endon("disconnect");
	self endon("end_killcam");
	secondsUntilDeath = ( ( level.lastKillCam.deathTime - startTime ) / 1000 );
	deathTime = getTime() + secondsUntilDeath * 1000;
	waitBeforeDeath = 2;
	self clientNotify("fkcb");
	wait( max(0, (secondsUntilDeath - waitBeforeDeath) ) );

	setSlowMotion( 1.0, 0.25, waitBeforeDeath ); // start timescale, end timescale, lerp duration
	wait( waitBeforeDeath + .5 );
	setSlowMotion( 0.25, 1, 1.0 );

	wait(.5);
	self clientNotify("fkce");
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
        self clientNotify("fkce");
}



waitTeamChangeEndKillcam()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	self waittill("changed_class");

	endKillcam( false );
}


waitSkipKillcamSafeSpawnButton()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	while(self fragButtonPressed())
		wait .05;

	while(!(self fragButtonPressed()))
		wait .05;
	
	self.wantSafeSpawn = true;

	self notify("end_killcam");
}

endKillcam( final )
{
	if(isDefined(self.kc_skiptext))
		self.kc_skiptext.alpha = 0;
	//if(isDefined(self.kc_skiptext2))
	//	self.kc_skiptext2.alpha = 0;
	if(isDefined(self.kc_timer))
		self.kc_timer.alpha = 0;
	
	self.killcam = undefined;

	if ( !( self IsSplitscreen() ) )
	{
		self hideAllPerks();
	}
	
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

checkForAbruptKillcamEnd()
{
	self endon("disconnect");
	self endon("end_killcam");
	
	while(1)
	{
		// code may trim our archivetime to zero if there is nothing "recorded" to show.
		// this can happen when the person we're watching in our killcam goes into killcam himself.
		// in this case, end the killcam.
		if ( self.archivetime <= 0 )
			break;
		wait .05;
	}
	
	self notify("end_killcam");
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	self waittill("spawned");
	self endKillcam(false);
}

spectatorKillcamCleanup( attacker )
{
	self endon("end_killcam");
	self endon("disconnect");
	attacker endon ( "disconnect" );

	attacker waittill ( "begin_killcam", attackerKcStartTime );
	waitTime = max( 0, (attackerKcStartTime - self.deathTime) - 50 );
	wait (waitTime);
	self endKillcam(false);
}

endedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self endKillcam(false);
}

endedFinalKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self endKillcam(true);
}

cancelKillCamUseButton()
{
	return self useButtonPressed();
}

cancelKillCamSafeSpawnButton()
{
	return self fragButtonPressed();
}

cancelKillCamCallback()
{
	self.cancelKillcam = true;
}

cancelKillCamSafeSpawnCallback()
{
	self.cancelKillcam = true;
	self.wantSafeSpawn = true;
}

cancelKillCamOnUse()
{
	self thread cancelKillCamOnUse_specificButton( ::cancelKillCamUseButton, ::cancelKillCamCallback );
	//self thread cancelKillCamOnUse_specificButton( ::cancelKillCamSafeSpawnButton, ::cancelKillCamSafeSpawnCallback );
}

cancelKillCamOnUse_specificButton( pressingButtonFunc, finishedFunc )
{
	self endon ( "death_delay_finished" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		if ( !self [[pressingButtonFunc]]() )
		{
			wait ( 0.05 );
			continue;
		}
		
		buttonTime = 0;
		while( self [[pressingButtonFunc]]() )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		
		if ( buttonTime >= 0.5 )
			continue;
		
		buttonTime = 0;
		
		while ( !self [[pressingButtonFunc]]() && buttonTime < 0.5 )
		{
			buttonTime += 0.05;
			wait ( 0.05 );
		}
		
		if ( buttonTime >= 0.5 )
			continue;
			
		self [[finishedFunc]]();
		return;
	}	
}


recordKillcamSettings( spectatorclient, targetentityindex, sWeapon, deathTime, deathTimeOffset, offsettime, entityindex, entitystarttime, perks, killstreaks, attacker )
{
	if ( !IsDefined(level.lastKillCam) )
	{
		level.lastKillCam = SpawnStruct();
	}
	
	level.lastKillCam.spectatorclient = spectatorclient;
	level.lastKillCam.weapon = sWeapon;
	level.lastKillCam.deathTime = deathTime;
	level.lastKillCam.deathTimeOffset = deathTimeOffset;
	level.lastKillCam.offsettime = offsettime;
	level.lastKillCam.entityindex = entityindex;
	level.lastKillCam.targetentityindex = targetentityindex;
	level.lastKillCam.entitystarttime = entitystarttime;
	level.lastKillCam.perks = perks;
	level.lastKillCam.killstreaks = killstreaks;
	level.lastKillCam.attacker = attacker;
}

finalKillcam()
{
	self endon("disconnect");
	level endon("game_ended");

	if ( wasLastRound() )
	{
			setMatchFlag( "final_killcam", 1 );	
			setMatchFlag( "round_end_killcam", 0 );	
	}
	else
	{
			setMatchFlag( "final_killcam", 0 );	
			setMatchFlag( "round_end_killcam", 1 );	
	}
			
	if( level.console )	
		self maps\mp\gametypes\_globallogic_spawn::setThirdPerson( false );
	
	postDeathDelay = (getTime() - level.lastKillCam.deathTime) / 1000;
	predelay = postDeathDelay + level.lastKillCam.deathTimeOffset;

	camtime = calcKillcamTime( level.lastKillCam.weapon, level.lastKillCam.entitystarttime, predelay, false, undefined );
	postdelay = calcPostDelay();

	killcamoffset = camtime + predelay;
	killcamlength = camtime + postdelay - 0.05; // We do the -0.05 since we are doing a wait below.

	killcamstarttime = (gettime() - killcamoffset * 1000);

	self notify ( "begin_killcam", getTime() );

	self.sessionstate = "spectator";
	self.spectatorclient = level.lastKillCam.spectatorclient;
	self.killcamentity = -1;
	if ( level.lastKillCam.entityindex >= 0 )
		self thread setKillCamEntity( level.lastKillCam.entityindex, level.lastKillCam.entitystarttime - killcamstarttime - 100 );
	self.killcamtargetentity = level.lastKillCam.targetentityindex;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = level.lastKillCam.offsettime;

	// ignore spectate permissions
	foreach( team in level.teams )
	{
		self allowSpectateTeam(team, true);
	}
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);

	self thread endedFinalKillcamCleanup();
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;

		self notify ( "end_killcam" );
		
		return;
	}
	
	self thread checkForAbruptKillcamEnd();

	self.killcam = true;

	if ( !( self IsSplitscreen() ) )
	{
		self addKillcamTimer(camtime);
	}
	
	self thread waitKillcamTime();
	self thread waitFinalKillcamSlowdown( killcamstarttime );

	self waittill("end_killcam");

	self endKillcam(true);

	setMatchFlag( "final_killcam", 0 );	
	setMatchFlag( "round_end_killcam", 0 );	

	self spawnEndOfFinalKillCam();
}

// This puts the player to the intermission point as a spectator once the killcam is over.
spawnEndOfFinalKillCam()
{
	self FreezeControls( true );
	[[level.spawnSpectator]]();
}

isKillcamEntityWeapon( sWeapon )
{
	if ( sWeapon == "planemortar_mp" )
	{
		return true;
	}

	return false;
}

isKillcamGrenadeWeapon( sWeapon )
{
	if (sWeapon == "frag_grenade_mp")
	{
		return true;
	}
	else if (sWeapon == "frag_grenade_short_mp"  )
	{
		return true;
	}
	else if ( sWeapon == "sticky_grenade_mp" )
	{
		return true;
	}
	else if ( sWeapon == "tabun_gas_mp" )
	{
		return true;
	}
	
	return false;
}

calcKillcamTime( sWeapon, entitystarttime, predelay, respawn, maxtime )
{
	camtime = 0.0;
	
	// length from killcam start to killcam end
	if (GetDvar( "scr_killcam_time") == "") 
	{
		if ( isKillcamEntityWeapon( sWeapon ) )
		{
			camtime = (gettime() - entitystarttime) / 1000 - predelay - .1;
		}
		else if ( !respawn ) // if we're not going to respawn, we can take more time to watch what happened
		{
			camtime = 5.0;
		}
		else if ( isKillcamGrenadeWeapon( sWeapon ) )
		{
			camtime = 4.25; // show long enough to see grenade thrown
		}
		else
			camtime = 2.5;
	}
	else
		camtime = GetDvarfloat( "scr_killcam_time");
	
	if (isdefined(maxtime)) {
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	return camtime;
}

calcPostDelay()
{
	postdelay = 0;
	
		// time after player death that killcam continues for
	if (GetDvar( "scr_killcam_posttime") == "")
	{
		postdelay = 2;
	}
	else 
	{
		postdelay = GetDvarfloat( "scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	return postdelay;
}

addKillcamSkipText(respawn)
{
	if ( !isdefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.horzAlign = "center";
		self.kc_skiptext.vertAlign = "bottom";
		self.kc_skiptext.sort = 1; // force to draw after the bars
		self.kc_skiptext.font = "objective";
		self.kc_skiptext.foreground = true;
		
		if ( self IsSplitscreen() )
		{
			self.kc_skiptext.y = -100;
			self.kc_skiptext.fontscale = 1.4;
		}
		else
		{
			self.kc_skiptext.y = -120;
			self.kc_skiptext.fontscale = 2;
		}
	}
	if ( respawn )
		self.kc_skiptext setText(&"PLATFORM_PRESS_TO_RESPAWN");
	else
		self.kc_skiptext setText(&"PLATFORM_PRESS_TO_SKIP");
		
	self.kc_skiptext.alpha = 1;
}

addKillcamTimer(camtime)
{
	/*if ( !isdefined( self.kc_timer ) )
	{
		self.kc_timer = createFontString( "extrabig", 3.0 );
		if ( level.console )
			self.kc_timer setPoint( "TOP", undefined, 0, 45 );
		else
			self.kc_timer setPoint( "TOP", undefined, 0, 55 );
		self.kc_timer.archived = false;
		self.kc_timer.foreground = true;
	}

	self.kc_timer.alpha = 0.2;
	self.kc_timer setTenthsTimer(camtime);*/
}


initKCElements()
{
	if ( !isDefined( self.kc_skiptext ) )
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 0;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "top";
		self.kc_skiptext.horzAlign = "center_adjustable";
		self.kc_skiptext.vertAlign = "top_adjustable";
		self.kc_skiptext.sort = 1; // force to draw after the bars
		self.kc_skiptext.font = "default";
		self.kc_skiptext.foreground = true;
		self.kc_skiptext.hideWhenInMenu = true;
		
		if ( self IsSplitscreen() )
		{
			self.kc_skiptext.y = 20;
			self.kc_skiptext.fontscale = 1.2; // 1.8/1.5
		}
		else
		{
			self.kc_skiptext.y = 32;
			self.kc_skiptext.fontscale = 1.8;
		}
	}
	
	if ( !isDefined( self.kc_othertext ) )
	{
		self.kc_othertext = newClientHudElem(self);
		self.kc_othertext.archived = false;
		self.kc_othertext.y = 48;
		self.kc_othertext.alignX = "left";
		self.kc_othertext.alignY = "top";
		self.kc_othertext.horzAlign = "center";
		self.kc_othertext.vertAlign = "middle";
		self.kc_othertext.sort = 10; // force to draw after the bars
		self.kc_othertext.font = "small";
		self.kc_othertext.foreground = true;
		self.kc_othertext.hideWhenInMenu = true;
		
		if ( self IsSplitscreen() )
		{
			self.kc_othertext.x = 16;
			self.kc_othertext.fontscale = 1.2;
		}
		else
		{
			self.kc_othertext.x = 32;
			self.kc_othertext.fontscale = 1.6;
		}
	}

	if ( !isDefined( self.kc_icon ) )
	{
		self.kc_icon = newClientHudElem(self);
		self.kc_icon.archived = false;
		self.kc_icon.x = 16;
		self.kc_icon.y = 16;
		self.kc_icon.alignX = "left";
		self.kc_icon.alignY = "top";
		self.kc_icon.horzAlign = "center";
		self.kc_icon.vertAlign = "middle";
		self.kc_icon.sort = 1; // force to draw after the bars
		self.kc_icon.foreground = true;
		self.kc_icon.hideWhenInMenu = true;		
	}

	if ( !( self IsSplitscreen() ) )
	{
		if ( !isdefined( self.kc_timer ) )
		{
			self.kc_timer = createFontString( "hudbig", 1.0 );
			self.kc_timer.archived = false;
			self.kc_timer.x = 0;
			self.kc_timer.alignX = "center";
			self.kc_timer.alignY = "middle";
			self.kc_timer.horzAlign = "center_safearea";
			self.kc_timer.vertAlign = "top_adjustable";
			self.kc_timer.y = 42;
			self.kc_timer.sort = 1; // force to draw after the bars
			self.kc_timer.font = "hudbig";
			self.kc_timer.foreground = true;
			self.kc_timer.color = (0.85,0.85,0.85);
			self.kc_timer.hideWhenInMenu = true;
		}
	}
}
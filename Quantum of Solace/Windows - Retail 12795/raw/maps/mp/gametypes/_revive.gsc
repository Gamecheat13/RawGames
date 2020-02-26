#include maps\mp\_utility;


init()
{
	level.revive = spawnstruct();
	level.revive.enabled = [];
	level.revive.distance = 32;
	level.revive.pingtime = 1000;
	level.revive.secondsUntilRespawn = 0;
}


setReviveDistance(distance)
{
	level.revive.distance = distance;
}


setSecondsUntilRespawn( seconds )
{
	level.revive.secondsUntilRespawn = seconds;
}

enable(team, enabled)
{
	if( !isDefined(enabled) )
		enabled = true;

	level.revive.enabled[team] = enabled;
	level.revive.count[team] = 0;

	level thread reviveUpdate(team);
}


isEnabled(team)
{
	if( !isDefined(level.revive.enabled[team]) )
		return false;

	return level.revive.enabled[team];
}


isEnabledForPlayer( player )
{
	if( player hasPerkRevive() )
	{
		return true;
	}
	
	return isEnabled( player.pers[ "team" ] );
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	team = self.pers["team"];
	if( !isEnabledForPlayer( self ) )
		return false;

	reviveObject = spawnstruct();

	reviveObject.player = self;
	reviveObject.origin = self.origin;
	reviveObject.angles = self.angles;
	reviveObject.activated = false;
	reviveObject.body = self.body;
	reviveObject.team = team;

	self.reviveObject = reviveObject;
	
	reviveObject thread disconnectFailsafe();

	//self thread waitToPlayReviveAnim();

	return true;
}

waitToPlayReviveAnim()
{
	self waittillmatch( "anim_notetrack", "end" );
	self SetAnimScriptEvent( "revive_wait" );
}

activate(reviveObject)
{
	reviveObject.trigger = spawn("trigger_radius", reviveObject.origin, 0, level.revive.distance, 20);
	reviveObject.trigger SetHintString( &"MP_PRESS_USE_TO_REVIVE", self );
	reviveObject.trigger SetCursorHint( "HINT_NOICON" );
	reviveObject.trigger SetTeamForTrigger( "axis" );

	reviveObject.objective_id = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add( reviveObject.objective_id, "active", reviveObject.origin, "compassping_death" );
	objective_team( reviveObject.objective_id, "axis" );

	reviveObject thread reviveTriggerThink();

	reviveObject.activated = true;

	level.revive.count[reviveObject.team]++;
}


disconnectFailsafe()
{
	reviveObject = self;
	reviveObject.player endon("revived");
	reviveObject.player waittill( "disconnect" );
	
	level.revive.count[reviveObject.team]--; // remove HUD message
	cleanup(reviveObject);
}


cleanup(reviveObject)
{
	players = getentarray("player", "classname");

	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( isDefined(player.reviveTouching) && player.reviveTouching == reviveObject )
		{
			player.reviveTouching = undefined;
		}
	}

	reviveObject.trigger delete();
	reviveObject.player = undefined;
}


reviveTriggerThink()
{
	reviveObject = self;
	lastping = gettime();

	reviveObject.player endon( "disconnect" );

	for(;;)
	{
		wait (0.05);
		
		if( !isDefined( reviveObject.player ) )
			return;

		if( !reviveObject.activated )
			continue;

		// force spectate mode
		reviveObject.player.sessionstate = "spectator";

		if( gettime() - lastping >= level.revive.pingtime )
		{
			reviveObject.player pingplayer();
			lastping = gettime();
		}

		players = getentarray("player", "classname");

		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if( player == reviveObject.player )
				continue;

			if( player.pers["team"] != reviveObject.team )
				continue;

			if( player.sessionstate == "spectator" )
				continue;

			if( !isDefined(player.reviveTouching) || player.reviveTouching == reviveObject )
			{
				if( player istouching(reviveObject.trigger) )
				{
					player.reviveTouching = reviveObject;

					if( player useButtonPressed() )
					{
						reviveObject thread onRevive( player );
						return;
					}
				}
				else
				{
					player.reviveTouching = undefined;
				}
			}
		}
	}
}


onRevive(claimPlayer)
{
	reviveObject = self;

	assert( reviveObject.player != claimPlayer );

	claimPlayer playsound("BVS_Terr_ORGM_REV");

	// update the HUD right away, instead of when the revived player respawns
	if( reviveObject.activated )
		level.revive.count[reviveObject.team]--;

	claimPlayer.reviveTouching = undefined;
	objective_delete( reviveObject.objective_id );

	reviveObject.claimPlayer = claimPlayer;
	reviveObject.player notify("revived");
}


isWaitingForRevive(player)
{
	return ( isDefined(player.reviveObject) );
}

timerWaitOnRevive()
{
	wait( level.revive.secondsUntilRespawn );
	self notify( "revived" );
}

checkForSpawnPress()
{
	self endon( "revived" );
	while( !self useButtonPressed() )
	{
		wait 0.05;
	}
	self notify( "revived" );
}

setupReviveSkipText()
{
	if(!isdefined(self.revive_skiptext))
	{
		self.revive_skiptext = newClientHudElem(self);
		self.revive_skiptext.archived = false;
		self.revive_skiptext.x = 0;
		self.revive_skiptext.alignX = "center";
		self.revive_skiptext.alignY = "middle";
		self.revive_skiptext.horzAlign = "center_safearea";
		self.revive_skiptext.vertAlign = "top";
		self.revive_skiptext.sort = 1; // force to draw after the bars
		self.revive_skiptext.font = "default";
		
		if(level.splitscreen)
		{
			self.revive_skiptext.y = 52;
			self.revive_skiptext.fontscale = 1.6;
		}
		else
		{
			self.revive_skiptext.y = 60;
			self.revive_skiptext.fontscale = 2;
		}
	}
	self.revive_skiptext setText(&"PLATFORM_PRESS_TO_RESPAWN");
}

waitForRevive()
{
	if( !isDefined(self.reviveObject) )
		return;

	self endon ("disconnect");

	setLowerMessage( &"MP_WAITING_FOR_REVIVE", level.revive.secondsUntilRespawn );
	activate(self.reviveObject);
	
	if( !level.revive.enabled[ self.pers[ "team" ] ] )
	{
		// team revive not being enabled means we are using revive perk
		self setupReviveSkipText();
		self thread timerWaitOnRevive();
		self thread checkForSpawnPress();
	}
	
	self waittill( "revived" );
	
	if( isDefined( self.revive_skiptext ) )
	{
		self.revive_skiptext destroy();
	}
	
	if( !isDefined( self.reviveObject.claimPlayer ) )
	{
		// no one actually revived us, cleanup so we respawn instead
		level.revive.count[self.pers["team"]]--; // remove HUD message
		cleanup(self.reviveObject);
	}
	setLowerMessage( "" );
}


wasRevived()
{
	if( isEnabledForPlayer( self ) )
	{
		// Don't allow players that will revive to drop their weapon
		self.dropWeaponOnDeath = false;
	}
	return ( isDefined(self.reviveObject) && isDefined(self.reviveObject.claimPlayer) );
}


doRevive()
{
	self FreezeControls( true );

	origin = self.reviveObject.origin;
	angles = self.reviveObject.angles;
	reviver = self.reviveObject.claimPlayer;

	cleanup(self.reviveObject);

	self maps\mp\gametypes\_deathicons::removeSelfDeathIcons(false);
	self.reviveObject.body delete();

	self.reviveObject = undefined;

	// play the revive anims
	reviver thread doReviveKick();
	self doReviveRaise( origin, angles );

	self FreezeControls( false );
}


doReviveKick()
{
	self endon ("disconnect");

	self FreezeControls( true );

	self SetAnimScriptEvent( "revive_kick" );
	wait 0.1;
	self waittillmatch( "anim_notetrack", "end" );
	self ClearAnimScriptEvent();

	self FreezeControls( false );
}


doReviveRaise( origin, angles )
{
	self setorigin( origin );
	self.angles = angles;

	self SetAnimScriptEvent( "revive_raise" );
	wait 0.1;
	self waittillmatch( "anim_notetrack", "end" );
	self ClearAnimScriptEvent();
}


createMessage()
{
	reviveMessage = maps\mp\gametypes\_hud_util::createFontString( "default", 1.4 );
	reviveMessage.alignX = "center";
	reviveMessage.alignY = "middle";
	reviveMessage.horzAlign = "center";
	reviveMessage.vertAlign = "bottom";
	reviveMessage.y = reviveMessage.y - 50;
	reviveMessage.foreground = true;
	reviveMessage.fontScale = 1.4;
	//reviveMessage.alpha = 0;
	reviveMessage.color = ( 1.0, 1.0, 1.0 );
	reviveMessage.hideWhenInMenu = true;
	reviveMessage.archived = false;
	reviveMessage setText( "You should never see this message" );

	self.reviveMessage = reviveMessage;
}


reviveUpdate(team)
{
	for(;;)
	{
		players = getentarray("player", "classname");

		for(i=0; i<players.size; i++)
		{
			player = players[i];

			if( player.pers["team"] != team )
				continue;

			if( !isDefined(player.reviveMessage) )
			{
				player createMessage();
			}

			if( isDefined(self.reviveObject) )
			{
				player.reviveMessage setText("");
			}
			else if( player.sessionstate == "spectator" )
			{
				player.reviveMessage setText("");
			}
			else if( level.revive.count[team] == 0 )
			{
				player.reviveMessage setText("");
			}
			else if( level.revive.count[team] == 1 )
			{
				player.reviveMessage setText("A teammate needs to be revived");
			}
			else
			{
				player.reviveMessage setText (level.revive.count[team], " teammates need to be revived");
			}
		}

		wait 0.05;
	}
}

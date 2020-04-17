#include maps\mp\_utility;


init()
{
	level.revive = spawnstruct();
	level.revive.enabled = [];
	level.revive.distance = 32;
	level.revive.pingtime = 1000;
}


setReviveDistance(distance)
{
	level.revive.distance = distance;
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


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	team = self.pers["team"];
	if( !isEnabled(team) )
		return;

	reviveObject = spawnstruct();

	reviveObject.player = self;
	reviveObject.origin = self.origin;
	reviveObject.angles = self.angles;
	reviveObject.activated = false;
	reviveObject.body = self.body;
	reviveObject.team = team;

	self.reviveObject = reviveObject;
	
	reviveObject thread disconnectFailsafe();
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
	
	level.revive.count[reviveObject.team]--; 
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
}


reviveTriggerThink()
{
	reviveObject = self;
	lastping = gettime();

	reviveObject.player endon( "disconnect" );

	for(;;)
	{
		wait (0.05);

		if( !reviveObject.activated )
			continue;

		
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


waitForRevive()
{
	if( !isDefined(self.reviveObject) )
		return;

	self endon ("disconnect");

	setLowerMessage( &"MP_WAITING_FOR_REVIVE" );
	activate(self.reviveObject);
	self waittill("revived");
	setLowerMessage( "" );
}


wasRevived()
{
	return ( isDefined(self.reviveObject) );
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

	
	reviver thread doReviveKick();
	self doReviveRaise( origin, angles );

	self FreezeControls( false );
}


doReviveKick()
{
	self endon ("disconnect");

	self FreezeControls( true );

	self SetAnimScriptEvent( "revive_kick" );
	self waittillmatch( "anim_notetrack", "end" );
	self ClearAnimScriptEvent();

	self FreezeControls( false );
}


doReviveRaise( origin, angles )
{
	self setorigin( origin );
	self.angles = angles;

	self SetAnimScriptEvent( "revive_raise" );
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

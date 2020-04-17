init()
{
	if (!level.teambased)
		return;
	
	precacheShader("headicon_dead");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.selfDeathIcons = []; 
		player.otherDeathIcons = []; 

		player thread onPlayerSpawned();
		player thread onPlayerDisconnect();
		player thread onJoinedTeam();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self removeSelfDeathIcons(false);
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	self removeSelfDeathIcons(true);
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		
		self removeOtherDeathIcons();
	}
}

updateDeathIconsEnabled()
{
	if (!self.enableDeathIcons)
		self removeOtherDeathIcons();
}

addDeathIcon(entity, dyingplayer, team, timeout)
{
	if (!level.teambased)
		return;

	if( maps\mp\gametypes\_revive::isEnabled(team) )
		timeout = undefined;

	assert(team == "allies" || team == "axis");

	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		if (players[i] == dyingplayer)
			continue;
		if (!isdefined(players[i].pers["team"]) || (players[i].pers["team"] != team && players[i].pers["team"] != "spectator"))
			continue;
		if (!players[i].enableDeathIcons)
			continue;
		
		newdeathicon = newClientHudElem(players[i]);
		newdeathicon.x = entity.origin[0];
		newdeathicon.y = entity.origin[1];
		newdeathicon.z = entity.origin[2] + 54;
		newdeathicon.alpha = .61;
		newdeathicon.archived = true;
		newdeathicon setShader("headicon_dead", 7, 7); 
		newdeathicon setwaypoint(true);

		dyingplayer.selfDeathIcons[dyingplayer.selfDeathIcons.size] = newdeathicon;
		
		
		newarray = [];
		for (j = 0; j < players[i].otherDeathIcons.size; j++)
		{
			if (isdefined(players[i].otherDeathIcons[j]))
				newarray[newarray.size] = players[i].otherDeathIcons[j];
		}
		newarray[newarray.size] = newdeathicon;
		players[i].otherDeathIcons = newarray;
	}
	
	if(isdefined(timeout))
	{
		dyingplayer endon("spawned_player");
		dyingplayer endon("disconnect");
		
		wait timeout;
		dyingplayer removeSelfDeathIcons(false);
	}
}

removeSelfDeathIcons(disconnected)
{
	
	for (i = 0; i < self.selfDeathIcons.size; i++) {
		if (isdefined(self.selfDeathIcons[i]))
			self.selfDeathIcons[i] thread destroySlowly();
	}
	if (!disconnected)
		self.selfDeathIcons = [];
}
removeOtherDeathIcons()
{
	
	for (i = 0; i < self.otherDeathIcons.size; i++) {
		if (isdefined(self.otherDeathIcons[i]))
			self.otherDeathIcons[i] destroy();
	}
	self.otherDeathIcons = [];
}

destroySlowly()
{
	self endon("death");
	
	self fadeOverTime(1.0);
	self.alpha = 0;
	
	wait 1.0;
	self destroy();
}

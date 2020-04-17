







init(id, playerBeginCallback, playerEndCallback)
{
	precacheShader("objpoint_default");
	
	handler = spawnstruct();
	handler.id = id;
	handler.playerBeginCallback = playerBeginCallback;
	handler.playerEndCallback = playerEndCallback;
	handler.enabled = false;
	handler.players = [];
	
	thread onPlayerConnect(handler);
	
	level.handlerGlobalFlagVal = 0;
	
	return handler;
}

enable(handler)
{
	if (handler.enabled)
		return;
	handler.enabled = true;
	
	level.handlerGlobalFlagVal++;
	
	
	
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
		players[i].handlerFlagVal = level.handlerGlobalFlagVal;
	
	
	players = handler.players;
	
	for (i = 0; i < players.size; i++) {
		if (players[i].handlerFlagVal != level.handlerGlobalFlagVal)
			continue;
		
		if (players[i].handlers[handler.id].ready)
			players[i] handlePlayer(handler);
	}
}
disable(handler)
{
	if (!handler.enabled)
		return;
	handler.enabled = false;
	
	level.handlerGlobalFlagVal++;
	
	
	
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
		players[i].handlerFlagVal = level.handlerGlobalFlagVal;

	
	players = handler.players;

	for (i = 0; i < players.size; i++) {
		if (players[i].handlerFlagVal != level.handlerGlobalFlagVal)
			continue;
		
		if (players[i].handlers[handler.id].ready)
			players[i] unHandlePlayer(handler, false, false); 
	}
}

onPlayerConnect(handler)
{
	for(;;)
	{
		level waittill("connecting", player);

		if (!isdefined(player.handlers))
			player.handlers = [];
		player.handlers[handler.id] = spawnstruct();
		player.handlers[handler.id].ready = false;
		player.handlers[handler.id].handled = false;
		player.handlerFlagVal = -1;

		handler.players[handler.players.size] = player;

		player thread onPlayerDisconnect(handler);

		player thread onPlayerSpawned(handler);
		player thread onJoinedTeam(handler);
		player thread onJoinedSpectators(handler);
		player thread onPlayerKilled(handler);
	}
}
onPlayerDisconnect(handler)
{
	self waittill("disconnect");
	
	newplayers = [];
	for (i = 0; i < handler.players.size; i++)
		if (handler.players[i] != self)
			newplayers[newplayers.size] = handler.players[i];
	handler.players = newplayers;
	
	self thread unHandlePlayer(handler, true, true);
}

onJoinedTeam(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread unHandlePlayer(handler, true, false);
	}
}
onJoinedSpectators(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread unHandlePlayer(handler, true, false);
	}
}
onPlayerSpawned(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread handlePlayer(handler);

		if ( isDefined( level.mp_musicplay ) )
			musicplay( level.mp_musicplay, 0, 1 );
	}
}
onPlayerKilled(handler)
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		self thread unHandlePlayer(handler, true, false);
	}
}





handlePlayer(handler)
{
	self.handlers[handler.id].ready = true;
	
	if (!handler.enabled)
		return;
	
	
	if (self.handlers[handler.id].handled)
		return;
	self.handlers[handler.id].handled = true;

	self thread [[handler.playerBeginCallback]]();
}
unHandlePlayer(handler, unsetready, disconnected)
{
	if (!disconnected && unsetready)
		self.handlers[handler.id].ready = false;
	
	
	
	
	if (!self.handlers[handler.id].handled)
		return;
	if (!disconnected)
		self.handlers[handler.id].handled = false;

	self thread [[handler.playerEndCallback]](disconnected);
}
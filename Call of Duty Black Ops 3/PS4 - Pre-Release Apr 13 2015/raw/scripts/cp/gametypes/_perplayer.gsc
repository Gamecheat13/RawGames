#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "material", "objpoint_default" );

#namespace perplayer;

// calls a callback every time a player starts playing (spawns),
// and another callback every time they stop (die / switch teams / disconnect).
// handles the annoying logic of players joining and leaving the game,
// so that other scripts don't have to.

/* Usage example:

// init() must be called during loading, or players already connected won't be considered!
function objectiveCreator = perplayer::init("objective_creator",&showObjective,&hideObjective);

...

// calls showObjective for all players in game
// (this can safely be called immediately after init(), if desired)
function perplayer::enable(objectiveCreator);

... // during this time, showObjective and hideObjective will be called for players as they join and leave gameplay

// calls hideObjective for all players in game
function perplayer::disable(objectiveCreator);


// the function playerBeginCallback takes no arguments. self = the player.
// the function playerEndCallback takes one argument, a boolean which says whether the player has disconnected.
// if the player has disconnected, it is not safe to change properties of the player.

*/

// set id to be some unique string indicating the purpose of the callbacks.
function init(id, playerBeginCallback, playerEndCallback)
{	
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

function enable(handler)
{
	if (handler.enabled)
		return;
	handler.enabled = true;
	
	level.handlerGlobalFlagVal++;
	// mark all players with the global flag value; if a player isn't marked later on, we know they're not in the game.
	// this could happen if they disconnected, causing this function to be called from elsewhere in script, but we haven't
	// yet recieved the disconnect notify so they're still in the handler.players array.
	players = GetPlayers();
	for (i = 0; i < players.size; i++)
		players[i].handlerFlagVal = level.handlerGlobalFlagVal;
	
	// handle all players who are ready to be handled
	players = handler.players;
	
	for (i = 0; i < players.size; i++) {
		if (players[i].handlerFlagVal != level.handlerGlobalFlagVal)
			continue;
		
		if (players[i].handlers[handler.id].ready)
			players[i] handlePlayer(handler);
	}
}
function disable(handler)
{
	if (!handler.enabled)
		return;
	handler.enabled = false;
	
	level.handlerGlobalFlagVal++;
	// mark all players with the global flag value; if a player isn't marked later on, we know they're not in the game.
	// this could happen if they disconnected, causing this function to be called from elsewhere in script, but we haven't
	// yet recieved the disconnect notify so they're still in the handler.players array.
	players = GetPlayers();
	for (i = 0; i < players.size; i++)
		players[i].handlerFlagVal = level.handlerGlobalFlagVal;

	// unhandle all players who are being handled
	players = handler.players;

	for (i = 0; i < players.size; i++) {
		if (players[i].handlerFlagVal != level.handlerGlobalFlagVal)
			continue;
		
		if (players[i].handlers[handler.id].ready)
			players[i] unHandlePlayer(handler, false, false); // first false means don't set ready to false
	}
}

function onPlayerConnect(handler)
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
function onPlayerDisconnect(handler)
{
	self waittill("disconnect");
	
	newplayers = [];
	for (i = 0; i < handler.players.size; i++)
		if (handler.players[i] != self)
			newplayers[newplayers.size] = handler.players[i];
	handler.players = newplayers;
	
	self thread unHandlePlayer(handler, true, true);
}

function onJoinedTeam(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread unHandlePlayer(handler, true, false);
	}
}
function onJoinedSpectators(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread unHandlePlayer(handler, true, false);
	}
}
function onPlayerSpawned(handler)
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread handlePlayer(handler);
	}
}
function onPlayerKilled(handler)
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		self thread unHandlePlayer(handler, true, false);
	}
}

// ["_perplayer handler " + handler.id + " ready"] is set to true
// if this player would be handled, even if the handler is disabled.
// ["_perplayer handler " + handler.id + " handled"] is only set to true
// when the player is being handled *and* the handler is enabled
function handlePlayer(handler)
{
	self.handlers[handler.id].ready = true;
	
	if (!handler.enabled)
		return;
	
	// if player already handled, stop
	if (self.handlers[handler.id].handled)
		return;
	self.handlers[handler.id].handled = true;

	self thread [[handler.playerBeginCallback]]();
}
function unHandlePlayer(handler, unsetready, disconnected)
{
	if (!disconnected && unsetready)
		self.handlers[handler.id].ready = false;
	
	
	
	// if player not handled, stop
	if (!self.handlers[handler.id].handled)
		return;
	if (!disconnected)
		self.handlers[handler.id].handled = false;

	self thread [[handler.playerEndCallback]](disconnected);
}

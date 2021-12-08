-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

local __thisFilenameHash = GetCurrentFileBeingLoaded();

-- Narrative Broadcast Manager
----------------------------------
global NarrativeBroadcastManager = {
	-- KILL SWITCH
	_KILL = false,		-- If set to true, will prevent this feature from operating in the game
	
	-- Default Configurations (can be set per station using NarrativeBroadcastManager.SetStationConfigurations())
	defaults = {
		firstTimeDelaySeconds	= function() return 2; end,		-- How long between intializing a station and when we play the first conversation on that station
		cooldownDurationSeconds = function() return 60; end,	-- How long to wait after a conversation has played before we start a new one on that station
		--conversationTypeOverride = TAG('some tag here');		-- Stations may specify a conversation type tag override to use instead of the normal convo tags, allowing for control over an entire station's playlist in a single tag
	},

	-- Functional Data
	stations = {},
	
	-- Private Methods
	_private = {},
	
	-- Debug
	DEBUG = {
		showDebugPrints = true,
	},
};

-- Temp macro for shorthand in this file below
local nbmPrivate = NarrativeBroadcastManager._private;


-- Station Management
-- Public Interface
------------------------
-- SETTING UP YOUR OWN STATION MANAGER
--********************************************************************************************************************--
--[===[

	-- Usage --
	
	-- (example for a hypothetical station for "cat videos"):
	global CatVideosStationManager = NarrativeBroadcastManager.CreateStationManager{ ... };
	
	
	-- This gives you the following API:
	CatVideosStationManager:RegisterEmitter(emitterKey:any, emitter:object):void
	CatVideosStationManager:UnregisterEmitter(emitterKey:any):void
	CatVideosStationManager:LoadAllPlaylists():void
	CatVideosStationManager:LoadPlaylist(playlist:table):void
	CatVideosStationManager:UnloadPlaylistById(playlistId:string):void
	CatVideosStationManager:UnloadPlaylistByRef(playlistRef:table):void
	CatVideosStationManager:RegisterOnSequencePlayCallback(callback:ifunction, ...):void
	CatVideosStationManager:UnregisterOnSequencePlayCallback(callback:ifunction):void
	CatVideosStationManager:RegisterOnSequenceEndCallback(callback:ifunction, ...):void
	CatVideosStationManager:UnregisterOnSequenceEndCallback(callback:ifunction):void
	CatVideosStationManager:Initialize():void
	CatVideosStationManager:ShutDown():void
	CatVideosStationManager:IsRunning():boolean
	CatVideosStationManager:GetCurrentConvoId():string

	
	-- And gives you access to this helper ifunction:
	CatVideosStationManager.Characters(thisLine:table, thisConvo:table, queue:table, lineId:any):table
	
	
	-- Input Parameters --
	
	-- 'stationData' input parameter is expected to have the following fields:
	_KILL:boolean (system)			-- Kill-switch for this particular station implementation, just in case
	stationId:string (required)		-- Unique identifier for this broadcast station
	defaults:table (optional)		-- Station-specific configuration (like 'firstTimeDelaySeconds' and 'cooldownDurationSeconds')
	playlists:table (required)		-- Base list of convo-logic-config sets for this station to begin loaded with
	
	
	-- The 'playlists' table can be populated with any number of entries that confirm to the following format:
	{
		convoId = <string>,				-- (required)
		CanPlay = <ifunction>,			-- (optional)
		useRandom = <boolean>,			-- (optional)
		pretreatmentFnc = <ifunction>,	-- (optional)
	},
	
--]===]
function NarrativeBroadcastManager.CreateStationManager(stationData:table):table
	if (not (stationData and stationData.stationId)) then	-- Bad call
		print("ERROR : Request to create station manager has failed due to bad data!");
		return {};
	end

	local stationManager = table.copy(stationData, true);
	stationManager.defaults = stationData.defaults or table.copy(NarrativeBroadcastManager.defaults, true);
	
	stationManager.Initialize = function(self:table):void
		if (self._KILL) then return; end	-- KILL SWITCH
		
		-- On creation of the "propaganda" station, load in all its playlists
		self:LoadAllPlaylists();
		-- Set all our "propaganda" station configurations, as specified in the table at the top of this file
		nbmPrivate.SetStationConfigurations(self);
	end
	
	stationManager.RegisterEmitter = function(self:table, emitterKey:any, emitter:object):void
		if (self._KILL) then return; end	-- KILL SWITCH
		nbmPrivate.RegisterEmitter(self, emitterKey, emitter);
	end
	
	stationManager.UnregisterEmitter = function(self:table, emitterKey:any):void
		if (self._KILL) then return; end	-- KILL SWITCH
		nbmPrivate.UnregisterEmitter(self.stationId, emitterKey);
	end
	
	stationManager.ShutDown = function(self:table):void
		if (self._KILL) then return; end	-- KILL SWITCH
		nbmPrivate.ShutDownStation(self.stationId);
	end
	
	stationManager.LoadAllPlaylists = function(self:table):void
		if (self._KILL) then return; end	-- KILL SWITCH
		for _,playlist in hpairs(self.playlists) do
			self:LoadPlaylist(playlist);
		end
	end

	stationManager.LoadPlaylist = function(self:table, playlist:table):void
		if (self._KILL) then return; end	-- KILL SWITCH
		nbmPrivate.LoadStationPlaylist(
			self,
			playlist.convoId,	-- Use the convo id in this playlist as its playlist id to avoid collisions
			playlist);
	end

	stationManager.UnloadPlaylistById = function(self:table, playlistId:string):void
		if (self._KILL) then return; end	-- KILL SWITCH
		nbmPrivate.UnloadStationPlaylist(self.stationId, playlistId);
	end

	stationManager.UnloadPlaylistByRef = function(self:table, playlistRef:table):void
		if (self._KILL) then return; end	-- KILL SWITCH
		if (not (playlistRef and playlistRef.convoId)) then return; end	-- Bad call
		nbmPrivate.UnloadStationPlaylist(self.stationId, playlistRef.convoId);
	end

	stationManager.RegisterOnSequencePlayCallback = function(self:table, callback:ifunction, ...):void
		if (self._KILL) then return; end	-- KILL SWITCH
		if (not callback) then return; end	-- Bad call
		nbmPrivate.RegisterOnStationSequencePlayCallback(self.stationId, callback, ...);
	end

	stationManager.UnregisterOnSequencePlayCallback = function(self:table, callback:ifunction):void
		if (self._KILL) then return; end	-- KILL SWITCH
		if (not callback) then return; end	-- Bad call
		nbmPrivate.UnregisterOnStationSequencePlayCallback(self.stationId, callback);
	end

	stationManager.RegisterOnSequenceEndCallback = function(self:table, callback:ifunction, ...):void
		if (self._KILL) then return; end	-- KILL SWITCH
		if (not callback) then return; end	-- Bad call
		nbmPrivate.RegisterOnStationSequenceEndCallback(self.stationId, callback, ...);
	end

	stationManager.UnregisterOnSequenceEndCallback = function(self:table, callback:ifunction):void
		if (self._KILL) then return; end	-- KILL SWITCH
		if (not callback) then return; end	-- Bad call
		nbmPrivate.UnregisterOnStationSequenceEndCallback(self.stationId, callback);
	end

	-- Returns true if station exists and is running, otherwise returns false
	stationManager.IsRunning = function(self:table):boolean
		if (self._KILL) then return false; end	-- KILL SWITCH
		local station = NarrativeBroadcastManager.stations[self.stationId];
		return not not (station and station.broadcastThread);
	end

	-- Returns the string name of the convo, if station exists and any convo is active, otherwise returns nil
	stationManager.GetCurrentConvoId = function(self:table):string
		if (self._KILL) then return nil; end	-- KILL SWITCH
		local station = NarrativeBroadcastManager.stations[self.stationId];
		return station and station.currentActiveConversation;
	end
	
	stationManager.Characters = NarrativeBroadcastManager.GetCharacterFunctionForStation(stationManager.stationId);

	return stationManager;
end
--********************************************************************************************************************--

-- Helpers
-------------
-- Fetch the registered emitters list for a specified station
function NarrativeBroadcastManager.GetRegisteredEmittersList(stationId:string):table
	if (NarrativeBroadcastManager._KILL) then return nil; end	-- KILL SWITCH
	if (not NarrativeBroadcastManager.stations[stationId]) then
		print("Narrative: NBM : Station", stationId, "is not current registered and active.  Cannot fetch emitters list.");
		return nil;
	end
	
	return NarrativeBroadcastManager._private[stationId].registeredEmitters
end

-- This function should be used as the '.character' field by all of a station's convo lines
function NarrativeBroadcastManager.GetCharacterFunctionForStation(stationId:string):ifunction
	return function(thisLine:table, thisConvo:table, queue:table, lineId:any):table
		local station = NarrativeBroadcastManager.stations[stationId];
		return (station and station.registeredEmitters);
	end
end

-- Debug
-----------
local function DebugPrint(...):void
	if (NarrativeBroadcastManager.DEBUG.showDebugPrints) then
		print(...);
	end
end


-- Private functions
-----------------------
-- Setup/Teardown --
function NarrativeBroadcastManager._private.InitializeOrGetStation(manager:table):table
	if (NarrativeBroadcastManager._KILL) then return nil; end	-- KILL SWITCH
	if (not manager or manager._KILL) then return nil; end	-- Bad call or KILL SWITCH for specific feature user

	local stationId:string = manager.stationId;
	if (not stationId) then return nil; end	-- Bad call
	
	-- Attempt to get existing station
	local newStation = NarrativeBroadcastManager.stations[stationId];

	-- Create a new station if needed
	if (not newStation) then
		-- Create the new station
		----------------------------
		DebugPrint("Broadcast Station [", stationId, "] initializing...");

		newStation = {
			registeredEmitters = {},
			registeredEmitterLUT = {},
			broadcastThread = nil,
			currentActiveConversation = nil,			
			sequenceId = stationId .. "_!_BroadcastSequence",
			onSequencePlayCallbacks = {},
			onSequenceEndCallbacks = {},
			playlists = {},
		};
		
		-- Create and register the unique sequence for the new station
		local stationSequence = table.copy(nbmPrivate.BroadcastSequenceTemplate, true);
		stationSequence.stationId = stationId;
		stationSequence.__RefCountingParentId = manager.__filenameHash or __thisFilenameHash;
		NarrativeInterface.loadedSequences[newStation.sequenceId] = stationSequence;
		
		--Fill in all defaults
		for key,value in hpairs(NarrativeBroadcastManager.defaults) do
			newStation[key] = value;
		end

		-- The station now exists
		----------------------------
		-- Register the new station with the broadcast manager
		NarrativeBroadcastManager.stations[stationId] = newStation;

		-- Run first-time functionality that requires the station to already exist
		-----------------------------------------------------------------------------
		-- Initialize the new station
		manager:Initialize();

		-- Start the station's thread
		nbmPrivate.Start(stationId);
	end
	
	-- Return ref to the station
	return newStation;
end

function NarrativeBroadcastManager._private.ShutDownStation(stationId:string):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not stationId) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then return; end	-- Already shut down
	
	-- Kill the Station thread
	if (station.broadcastThread and IsThreadValid(station.broadcastThread)) then
		KillThread(station.broadcastThread);
	end

	-- Kill the running Station convo (this will also result in the end of the sequence)
	if (station.currentActiveConversation) then
		NarrativeInterface.KillConversation(station.currentActiveConversation);
	end

	-- Remove the station
	NarrativeBroadcastManager.stations[stationId] = nil;
end

-- Emitter Registry/Unregistry --
function NarrativeBroadcastManager._private.RegisterEmitter(manager:table, emitterKey:any, emitter:object):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not manager or manager._KILL) then return; end	-- Bad call or KILL SWITCH for specific feature user
	if (not (emitterKey and emitter)) then return; end	-- Bad call

	local stationId:string = manager.stationId;
	if (not stationId) then return; end	-- Bad call
	
	-- Lazy-instantiate the specified station, if necessary
	local station = nbmPrivate.InitializeOrGetStation(manager);
	
	if (station.registeredEmitterLUT[emitterKey]) then
		DebugPrint("Station [", stationId, "] Registration ignored, as the specified emitter was already registered.");
		return;
	end

	-- Register the emitter to our list, which will automatically link to any running convo on this station
	station.registeredEmitterLUT[emitterKey] = emitter;
	table.insert(station.registeredEmitters, emitter);
end

function NarrativeBroadcastManager._private.UnregisterEmitter(stationId:string, emitterKey:any):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and emitterKey)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to unregister emitter from it.");
		return;
	end

	if (not station.registeredEmitterLUT[emitterKey]) then
		DebugPrint("Station [", stationId, "] Unregistration ignored, as the emitter was already unregistered.");
		return;
	end
	
	local emitter = station.registeredEmitterLUT[emitterKey];
	-- Halt current VO playback on our emitter
	if (station.currentActiveConversation) then
		NarrativeInterface.HaltAllLinesOnEmitter(station.currentActiveConversation, emitter);
	end

	-- Unegister the emitter from our list, which will automatically unlink from any running convo on this station
	local emitterIndex = nil;
	station.registeredEmitterLUT[emitterKey] = nil;
	for curIndex,curEmitter in hpairs(station.registeredEmitters) do
		if (curEmitter == emitter) then
			emitterIndex = curIndex;
			break;
		end
	end
	if (emitterIndex) then
		table.remove(station.registeredEmitters, emitterIndex);
	end
end

-- Station Configuration --
function NarrativeBroadcastManager._private.SetStationConfigurations(manager:table):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not manager or manager._KILL) then return; end	-- Bad call or KILL SWITCH for specific feature user

	local stationId:string = manager.stationId;
	if (not stationId) then return; end	-- Bad call
	
	-- Initialize set all defaults on new stations the first time it was run
	local station = nbmPrivate.InitializeOrGetStation(manager);
	
	-- But if we were passed nil for configurations, this is a request to reset configs to default values
	local configurations:table = manager.defaults or NarrativeBroadcastManager.defaults;
		
	-- Assign configuration values to this station
	for key,value in hpairs(configurations) do
		station[key] = value;
	end
end

-- Playlist Load/Unload --
function NarrativeBroadcastManager._private.LoadStationPlaylist(manager:table, playlistId:string, playlistData:table):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not manager or manager._KILL) then return; end	-- Bad call or KILL SWITCH for specific feature user
	if (not playlistId) then return; end	-- Bad call

	local stationId:string = manager.stationId;
	if (not stationId) then return; end	-- Bad call
	
	local station = nbmPrivate.InitializeOrGetStation(manager);
	
	-- Don't overwrite existing playlists
	if (station.playlists[playlistId]) then
		DebugPrint("Station [", stationId, "] has already loaded playlist [", playlistId, "] : Ignoring request to load.");
		return;
	end
	
	-- Actually load the playlist
	nbmPrivate.LoadAndOverwriteStationPlaylist(manager, playlistId, playlistData);
end

function NarrativeBroadcastManager._private.LoadAndOverwriteStationPlaylist(manager:table, playlistId:string, playlistData:table):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not manager or manager._KILL) then return; end	-- Bad call or KILL SWITCH for specific feature user
	if (not (playlistId and playlistData)) then return; end	-- Bad call

	local stationId:string = manager.stationId;
	if (not stationId) then return; end	-- Bad call
	
	local station = nbmPrivate.InitializeOrGetStation(manager);	
	station.playlists[playlistId] = playlistData;
end

function NarrativeBroadcastManager._private.UnloadStationPlaylist(stationId:string, playlistId:string):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and playlistId)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to unload playlist [", playlistId, "] from it.");
		return;
	end
	
	-- Unload the playlist from our pool.  If the playlist's convo is currently running, it will run to completion before the station manager is aware it is gone
	station.playlists[playlistId] = nil;
end

function NarrativeBroadcastManager._private.RegisterOnStationSequencePlayCallback(stationId:string, callback:ifunction, ...):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and callback)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to register 'OnSequencePlay' callback from it.");
		return;
	end

	local parameters = (arg and arg[1] and { unpack(arg), }) or true;	-- Create a table to contain input parameters, or else just mark the callback as "exists" (= true)
	station.onSequencePlayCallbacks[callback] = parameters;

	-- If we're already running this station's convo, run the OnPlay callback in order to catch the new registrant up to speed
	if (station.currentActiveConversation) then
		if (parameters == true) then callback(stationId);
		else callback(unpack(parameters));
		end
	end
end

function NarrativeBroadcastManager._private.UnregisterOnStationSequencePlayCallback(stationId:string, callback:ifunction, ...):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and callback)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to unregister 'OnSequencePlay' callback from it.");
		return;
	end

	station.onSequencePlayCallbacks[callback] = nil;
end

function NarrativeBroadcastManager._private.RegisterOnStationSequenceEndCallback(stationId:string, callback:ifunction, ...):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and callback)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to register 'OnSequenceEnd' callback from it.");
		return;
	end

	local parameters = (arg and arg[1] and { unpack(arg), }) or true;	-- Create a table to contain input parameters, or else just mark the callback as "exists" (= true)
	station.onSequenceEndCallbacks[callback] = parameters;
end

function NarrativeBroadcastManager._private.UnregisterOnStationSequenceEndCallback(stationId:string, callback:ifunction, ...):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not (stationId and callback)) then return; end	-- Bad call
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] was not initialized : Ignoring request to unregister 'OnSequenceEnd' callback from it.");
		return;
	end

	station.onSequenceEndCallbacks[callback] = nil;
end

-- Runtime Behavior
-----------------------
-- Starts up the ever-running Station thread, which manages convos across the island
function NarrativeBroadcastManager._private.Start(stationId:string):void
	if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
	if (not stationId) then return; end	-- Bad call
	if (nbmPrivate.broadcastThread) then return; end	-- Thread already running
	
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] tried to start its thread, but no such station exists!");
		return;
	end
	
	-- Start the station's broadcast thread
	DebugPrint("Station [", stationId, "] Thread starting now...");
	station.broadcastThread = NarrativeInterface.CreateNarrativeThread(nbmPrivate.BroadcastThreadUpdate, stationId);
end

-- The Propaganda thread itself, which selects the conversation we should currently be running, or if we should be waiting for cooldown
function NarrativeBroadcastManager._private.BroadcastThreadUpdate(stationId:string):void
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] BroadcastThreadUpdate tried to start, but no such station exists!");
		return;
	end

	local initialDelay = station.firstTimeDelaySeconds();
	DebugPrint("Station [", stationId, "] Thread started, with initial delay of", initialDelay, "seconds.");
	SleepSeconds(initialDelay);
	DebugPrint("Station [", stationId, "] Thread initial delay complete.");

	while (true) do
		local nextConvoData = nbmPrivate.GetNextConversationData(stationId);
		if (nextConvoData) then
			DebugPrint("Station [", stationId, "] Thread now playing next conversation:", nextConvoData.convoId);
			NarrativeInterface.SleepUntil.PlayNarrativeSequence(station.sequenceId, nextConvoData);
			DebugPrint("Station [", stationId, "] conversation", nextConvoData.convoId, "complete.");
		else
			DebugPrint("Station [", stationId, "] Broadcast Thread found no conversations able to start!");
		end
		SleepSeconds(station.cooldownDurationSeconds());
	end
end

-- Function for determining which Propaganda conversation to run next
function NarrativeBroadcastManager._private.GetNextConversationData(stationId:string):table
	local station = NarrativeBroadcastManager.stations[stationId];
	if (not station) then
		DebugPrint("Station [", stationId, "] tried to get next conversation, but no such station exists!");
		return nil;
	end
	
	-- Build the list of currently-ready conversations
	local selectionList = nil;
	for _,playlist in hpairs(station.playlists) do
		if (not playlist.CanPlay or playlist.CanPlay()) then
			selectionList = selectionList or {};
			table.insert(selectionList, playlist);
		end
	end

	-- We found at least one valid propaganda conversation
	if (selectionList) then
		local convoCount = #selectionList;
		return selectionList[(convoCount > 1 and math.random(convoCount)) or 1];	-- Randomly select one of the available conversations (Future Note: we may want to employ some sort of shuffle-random style exceptions here for full feature implementation)
	end

	-- No valid conversations available to play on this station, currently
	return nil;
end


-- The Broadcast Sequence Template
-----------------------------
nbmPrivate.BroadcastSequenceTemplate = {
	sequence = function(sequenceId:string, transientState:table, compdata:table)
		-- Validation --
		if (NarrativeBroadcastManager._KILL) then return; end	-- KILL SWITCH
		local thisSequence = NarrativeInterface.loadedSequences[sequenceId];
		local station = nil;
		if (thisSequence.stationId) then
			station = NarrativeBroadcastManager.stations[thisSequence.stationId];
		end
		if (not station) then
			print("WARNING : tried to run the", sequenceId, "sequence without a valid station!");
			return;
		end

		if (not transientState) then
			print("WARNING : Attempted to run the", sequenceId, "sequence without a 'transientState' table!");
			return;
		end
		
		local convoId = transientState.convoId;
		if (not convoId) then
			print("WARNING : Attempted to run the", sequenceId, "sequence without a valid conversation name!");
			return;
		end
		
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then
			print("WARNING : Attempted to run the", sequenceId, "sequence with convo", convoId, "but no such conversation exists!");
			return;
		end

		-- Pre-treat the convo, if requested
		if (transientState.pretreatmentFnc and type(transientState.pretreatmentFnc) == "function") then
			transientState.pretreatmentFnc(convoId, sequenceId);
		end

		-- Behavior --
		-- Assign our registered emitters as the character lists for each line in the convo
		for _,line in hpairs(convo.lines) do
			line.character = station.registeredEmitters;
		end

		-- Add any convo type tag override specified by the station
		convo.tagOverride = station.conversationTypeOverride;

		-- Mark the convo as able to logically play its lines even without a valid character target
		convo.logicalPlayIfCharacterMissing = true;

		-- Run "On Play" callbacks
		for callback,params in hpairs(station.onSequencePlayCallbacks) do
			if (params == true) then
				callback(thisSequence.stationId);
			else
				callback(unpack(params));
			end
		end

		-- Play the convo
		station.currentActiveConversation = convoId;
		if (transientState.useRandom) then
			DebugPrint("Station [", thisSequence.stationId, "] Broadcast Sequence random-playing:", convoId);
			NarrativeInterface.PlayConversationWithRandomLine(convoId, sequenceId, compdata, true, { convo:GetNextRandom(), });
		else
			DebugPrint("Station [", thisSequence.stationId, "] Broadcast Sequence full-playing:", convoId);
			NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
		end

		-- Run "On End" callbacks
		for callback,params in hpairs(station.onSequenceEndCallbacks) do
			if (params == true) then
				callback(thisSequence.stationId);
			else
				callback(unpack(params));
			end
		end
		
		-- Cleanup
		station.currentActiveConversation = nil;
		convo.logicalPlayIfCharacterMissing = nil;
		convo.tagOverride = nil;
	end,

	playingItems = {},
	doNotLockTacMap = true,		-- Do no prevent Back Menu access during playback
	isGlobalScope = true,		-- Survives large state changes like Fast Travel
};

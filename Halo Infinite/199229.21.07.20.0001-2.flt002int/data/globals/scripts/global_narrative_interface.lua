
REQUIRES('globals\scripts\global_dialog_interface.lua');

--## SERVER

-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Interface ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

-- Simplified global interface for script to interact with narrative systems
global NarrativeInterface = {
	-- Data
	-----------------------------
	TYPE = table.makeEnum{
		Conversation = 1,
		Sequence = 2,
	},

	STATE = table.makeEnum{
		Starting = 1,
		Running = 2,
		Completed = 3,
	},
	-----------------------------

	-- Current Interface State
	-----------------------------
	isTableRegistrationEnabled = true,			-- TRUE : Allow Lua to write new tables to our loaded sequences and conversations | FALSE : Reject incoming requests to write to loaded lists

	--loadedConversations = {},	-- DEFINED BELOW IN GLOBAL SCOPE - All convo tables that are currently loaded in memory (never queued, currently queued, already played, etc)
	--loadedSequences = {},		-- DEFINED BELOW IN GLOBAL SCOPE - All narrative sequences that are currently loaded in memory (never queued, currently queued, already played, etc)

	Threading = {
		sequenceThreads = {},			-- All RunSequenceUnique threads currently running
		managedThreads = {},			-- All currently-running threads owned by the Narrative Interface
		threadManagementThread = nil,	-- Runs a cleanup loop and removes dead items from the 'managedThreads' list
		threadManagementUpdate = 60,	-- Runs the cleanup update once every 60 seconds
	},
	-----------------------------

	-- System-use only
	-----------------------------
	_private = {
		loadedSequences = {},			-- Backing data for sequences
		loadedConversations = {},		-- Backing data for conversations

		sequenceRefs = {},				-- Ref count data for each sequence
		conversationRefs = {},			-- Ref count data for each conversation

		sequenceRefParentage = {},		-- Map of parent:children relationships for files and the sequence tables they created (or incremented)
		conversationRefParentage = {},	-- Map of parent:children relationships for files and the conversation tables they created (or incremented)

		simulatedRefState = {
			loadedSequences = {},		-- Simulated backing data for sequences, with ref counting and deletion on Lua file unload
			loadedConversations = {},	-- Simulated backing data for conversations, with ref counting and deletion on Lua file unload
		},
	},
	-----------------------------

	-- User Configurations
	-----------------------------
	denyAllConvoOverwrites = true,				-- TRUE : Prevent requests to write to loaded tables from overwriting an existing table entry | FALSE : Allow new write requests to replace existing tables
	-----------------------------

	-- Debug Configurations
	-----------------------------
	treatUnexpectedWarningsAsErrors = false,	-- TRUE : Throw asserts when conditions for unexpected warnings are met | FALSE : Print or fire telemetry, but do not assert, when conditions for unexpected warnings are met
	useTableRefCountManagement = true,			-- TRUE : Track table refs in loadedSequences and loadedConversations | FALSE : Use old behavior for loadedX tables (don't delete stale/orphaned tables)
	simulateTableRefCountManagement = false,	-- TRUE : Track copies of table refs in debug tables instead of actually ref-count managing the laoded tables, for comparison against the old table behaviors | FALSE : Disable parallel ref counting test-behavior
	-----------------------------

	-- Conditional Debug Print Configurations
	-----------------------------
	showLoadedNarrativeTableDebugInfo = true,
--	showRefCountingDebugInfo = true,
	-----------------------------
};

local function ConditionalDebugPrint(contextVar:string, ...):void
	if (not contextVar) then return; end
	if (not NarrativeInterface[contextVar]) then return; end

	print(...);
end

function NarrativeInterface.UnexpectedWarning(message:string):void
	if (NarrativeInterface.treatUnexpectedWarningsAsErrors) then
		error("NarrativeInterface Error : " .. message);
	else
		print("NarrativeInterface Unexpected Warning :");
		print("    ", message);
	end
end


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation and Sequence Metatable ::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global convoAndSeqMetatable = {
	__newindex = function (t,k,v)
		if (not k or type(k) ~= "string") then
			error("NarrativeInterface Error : Attempted to assign a new conversation or sequence table using nil or non-string key!");
			return;
		end

		local dataTable = nil;
		local tableType = nil;
		local refTable = nil;
		local refParentageTable = nil;
		if (t == NarrativeInterface.loadedSequences) then
			dataTable = "loadedSequences";
			tableType = NarrativeInterface.TYPE.Sequence;
			refTable = NarrativeInterface._private.sequenceRefs;
			refParentageTable = NarrativeInterface._private.sequenceRefParentage;
		elseif (t == NarrativeInterface.loadedConversations) then
			dataTable = "loadedConversations";
			tableType = NarrativeInterface.TYPE.Conversation;
			refTable = NarrativeInterface._private.conversationRefs;
			refParentageTable = NarrativeInterface._private.conversationRefParentage;
		else
			NarrativeInterface.UnexpectedWarning("Attempted to assign values to a private loaded table using an unknown table! (How?)");
			return;
		end

		if (v ~= nil and type(v) ~= "table") then	-- We can nil out tables
			error("NarrativeInterface Error : Attempted to assign a new conversation or sequence table using a non-table value!");
			return;
		end

		local normalizedKey = string.lower(k);

		-- Make sure we aren't attempting to overwrite an existing conversation or sequence WHILE IT IS IN USE
		if (NarrativeInterface._private[dataTable][normalizedKey]) then
			if (dataTable == "loadedSequences") then
				if (NarrativeInterface.SequenceTableIsActive(NarrativeInterface._private[dataTable][normalizedKey])) then
					NarrativeInterface.UnexpectedWarning("Attempted to overwrite sequence table " .. k .. " WHILE THAT SEQUENCE WAS RUNNING.");
					FireTelemetryEvent("RunningSequenceTableOverwriteAttempt", { sequenceName = normalizedKey, key = k, refCountingParentId = v.__RefCountingParentId or "nil", });
					return;
				else
					ConditionalDebugPrint("showLoadedNarrativeTableDebugInfo", "NarrativeInterface Warning : Overwriting existing sequence table", k);
					FireTelemetryEvent("SequenceTableOverwriteAttempt", { sequenceName = normalizedKey, key = k, refCountingParentId = v.__RefCountingParentId or "nil", });
				end
			else
				if (NarrativeInterface.ConversationTableIsActive(NarrativeInterface._private[dataTable][normalizedKey])) then
					NarrativeInterface.UnexpectedWarning("Attempted to overwrite conversation table " .. k .. " WHILE THAT CONVERSATION WAS RUNNING.");
					FireTelemetryEvent("RunningConvoTableOverwriteAttempt", { conversationName = normalizedKey, key = k, refCountingParentId = v.__RefCountingParentId or "nil", });
					return;
				else
					FireTelemetryEvent("ConvoTableOverwriteAttempt", { conversationName = normalizedKey, key = k, refCountingParentId = v.__RefCountingParentId or "nil", });
					if (NarrativeInterface.denyAllConvoOverwrites) then
						if (v ~= nil) then	-- We will still allow conversation tables to be erased
							--NarrativeInterface.UnexpectedWarning("Attempted to overwrite conversation table " .. k .. "- PERMISSION DENIED.");
							return;
						else
							ConditionalDebugPrint("showLoadedNarrativeTableDebugInfo", "NarrativeInterface Alert : Nil-ing out existing conversation table", k);
							FireTelemetryEvent("ConvoSetToNil", { conversationName = normalizedKey, key = k, });
						end
					else
						ConditionalDebugPrint("showLoadedNarrativeTableDebugInfo", "NarrativeInterface Warning : Overwriting existing conversation table", k);
					end
				end
			end
		end

		-- If we've locked the NarrativeInterface, don't allow new sequences or conversations to be added
		if (not NarrativeInterface.IsTableRegistrationEnabled()) then
			return;
		end

		-- Automatically set up GetNext functionality for all 'lines' tables on convos
		if (v ~= nil and v.lines) then
			--print("Adding meta to", v.name);
			NarrativeHelpers.SetNextRandomBehavior(v);
		end

		-- Set the table value
		if (v ~= nil) then v._type = tableType; end
		NarrativeInterface._private[dataTable][normalizedKey] = v;
		if (NarrativeInterface.useTableRefCountManagement and NarrativeInterface.simulateTableRefCountManagement) then
			-- Duplicate table values for ref-tracked simulated tables
			NarrativeInterface._private.simulatedRefState[dataTable][normalizedKey] = v;
		end

		-- For non-nil assignments increment ref-count
		if (v ~= nil and NarrativeInterface.useTableRefCountManagement) then
			NarrativeInterface._private.RegisterRefParentage(
				(v.__RefCountingParentId or GetCurrentFileBeingLoaded()),	-- parentId:any			- Either use an override parent id (for tables created procedurally or by bespoke script after file load), or use the Lua file currently being loaded (and declaring conversation or sequence tables)
				normalizedKey,												-- entryName:string		- Table name, and index into the loaded table
				refParentageTable,											-- parentageTable:table	- List of [parentId]:{[table name]} entries, so when the parent unloads, we know which tables to decrement refs for
				refTable													-- refTable:table		- List of [table name]:ref-count entries, to track when we should actually allocate or garbage-collect any given table
			);
			v.__RefCountingParentId = nil;	-- We should only track this override on a call-by-call basis
		end
	end,

	__index = function (t,k)
		if (not k or type(k) ~= "string") then
			error("NarrativeInterface Error : Attempted to index a conversation or sequence using nil or non-string key!");
			return nil;
		end

		local dataTable = nil;
		if (t == NarrativeInterface.loadedSequences) then
			dataTable = "loadedSequences";
		elseif (t == NarrativeInterface.loadedConversations) then
			dataTable = "loadedConversations";
		else
			NarrativeInterface.UnexpectedWarning("Attempted to access a private loaded table using an unknown table! (How?)");
			return nil;
		end

		-- Simulate hpairs behavior without directly referencing our private tables in script
		if (k == "__hpairs") then
			return function()
				return next, NarrativeInterface._private[dataTable], nil;
			end
		end

		-- Ignore case when retrieving conversations or sequences
		--return rawget(t, string.lower(k));
		local normalizedKey = string.lower(k);

		if (not NarrativeInterface._private[dataTable][normalizedKey]) then
			if (dataTable == "loadedSequences") then
				FireTelemetryEvent("SequenceLookupFailed", { sequenceName = normalizedKey, key = k, });
			else
				FireTelemetryEvent("ConversationLookupFailed", { conversationName = normalizedKey, key = k, });
			end
		end

		return NarrativeInterface._private[dataTable][normalizedKey];
	end,
};

-- Both declaring the tables and setting the metatables in a single line, to avoid Lua initialization errors where some conversation table entries manage to get added to the loaded table before the metatable is assigned.
-- When a convo is added to the loaded table, we need that metatable to perform some fixup on it.
--setmetatable(NarrativeInterface.loadedConversations, convoAndSeqMetatable);
--setmetatable(NarrativeInterface.loadedSequences, convoAndSeqMetatable);
NarrativeInterface.loadedConversations	= setmetatable({}, convoAndSeqMetatable);
NarrativeInterface.loadedSequences		= setmetatable({}, convoAndSeqMetatable);
convoAndSeqMetatable = nil;

function NarrativeInterface.IsTableRegistrationEnabled():boolean
	return NarrativeInterface.isTableRegistrationEnabled;
end

function NarrativeInterface.DisableTableRegistration():void
	NarrativeInterface.isTableRegistrationEnabled = false;
end

function NarrativeInterface.EnableTableRegistration():void
	NarrativeInterface.isTableRegistrationEnabled = true;
end

-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: LOADED TABLE REF COUNTING :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface._private.IncrementTableRefCount(refTable:table, entryName:string):void
	if (not NarrativeInterface.useTableRefCountManagement) then return; end	-- Kill-switch
	assert(refTable[entryName] == nil or refTable[entryName] > 0, "ERROR : (Increment) Ref count for table entry " .. entryName .. " was somehow 0 or less.");

	refTable[entryName] = (refTable[entryName] and refTable[entryName] + 1) or 1;
	ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Incrementing ref count for table", entryName .. ". New ref count:", refTable[entryName]);
end

function NarrativeInterface._private.DecrementTableRefCount(refTable:table, loadedTable:table, entryName:string):void
	if (not NarrativeInterface.useTableRefCountManagement) then return; end	-- Kill-switch
	if (not refTable[entryName]) then
		NarrativeInterface.UnexpectedWarning("Attempted to decrement ref count for table", entryName, "but it was not registered!");
		return;
	end

	assert(refTable[entryName] > 0, "ERROR : (Decrement) Ref count for table entry " .. entryName .. " was somehow 0 or less.");
	refTable[entryName] = refTable[entryName] - 1;
	ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Decrementing ref count for table", entryName .. ". Remaining ref count:", refTable[entryName]);

	-- If this is the last ref, delete the table
	if (refTable[entryName] == 0) then
		refTable[entryName] = nil;

		-- If entry is not currently active, delete it immediately
		if (not NarrativeInterface.NarrativeTableIsActive(loadedTable[entryName])) then
			ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Ref count hit 0.  Deleting", entryName);
			loadedTable[entryName] = nil;
		-- Otherwise, spawn a followup thread to delete it upon termination
		else
			ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface ::", entryName, "was still running when ref parent unloaded!  Delaying destruction of table until terminated.");
			CreateThread(NarrativeInterface._private.DelayTableDeletion, refTable, loadedTable, entryName);
		end
	end
end

function NarrativeInterface._private.DelayTableDeletion(refTable:table, loadedTable:table, entryName:string):void
	local checkActivePeriodSeconds = 30;

	-- Wait until the active sequence terminates, or stops existing
	SleepUntilSeconds([| not (loadedTable[entryName] and NarrativeInterface.NarrativeTableIsActive(loadedTable[entryName])) ], checkActivePeriodSeconds);

	if (not refTable[entryName]) then
		ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Ref count still 0 after delay.  Deleting", entryName);
		loadedTable[entryName] = nil;
	else
		ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Ref count for", entryName, "no longer 0 after delay.  Aborting destruction of table.");
	end
end

function NarrativeInterface._private.RegisterRefParentage(parentId:any, entryName:string, parentageTable:table, refTable:table):void
	if (not NarrativeInterface.useTableRefCountManagement) then return; end	-- Kill-switch
	if (parentageTable[parentId] and parentageTable[parentId][entryName]) then
		ConditionalDebugPrint("showRefCountingDebugInfo", "NarrativeInterface :: Ref Parentage already exists between", entryName, "and", parentId, "- Doing nothing.");
		return;
	end
	
	-- Register parentage for later cleanup
	parentageTable[parentId] = parentageTable[parentId] or {};
	parentageTable[parentId][entryName] = true;
	
	-- Increment ref counts for the entry
	NarrativeInterface._private.IncrementTableRefCount(refTable, entryName);
end

function NarrativeInterface.ForceUnloadTableParent(parentId:any):void
	if (not NarrativeInterface.useTableRefCountManagement) then return; end	-- Kill-switch
	if (not parentId) then return; end	-- Bad function call

	-- Sequence refs
	if (NarrativeInterface._private.sequenceRefParentage[parentId])	then
		ConditionalDebugPrint("showRefCountingDebugInfo", "Lua file or table parent", parentId, "has been unloaded.  Cleaning up sequences...");

		for seqName,_ in hpairs(NarrativeInterface._private.sequenceRefParentage[parentId]) do
			NarrativeInterface._private.DecrementTableRefCount(
				NarrativeInterface._private.sequenceRefs,
				(NarrativeInterface.simulateTableRefCountManagement and NarrativeInterface._private.simulatedRefState.loadedSequences) or NarrativeInterface._private.loadedSequences,
				seqName
			);
		end
		NarrativeInterface._private.sequenceRefParentage[parentId] = nil;
	end

	-- Conversation refs
	if (NarrativeInterface._private.conversationRefParentage[parentId])	then
		ConditionalDebugPrint("showRefCountingDebugInfo", "Lua file or table parent", parentId, "has been unloaded.  Cleaning up conversations...");

		for convoName,_ in hpairs(NarrativeInterface._private.conversationRefParentage[parentId]) do
			NarrativeInterface._private.DecrementTableRefCount(
				NarrativeInterface._private.conversationRefs,
				(NarrativeInterface.simulateTableRefCountManagement and NarrativeInterface._private.simulatedRefState.loadedConversations) or NarrativeInterface._private.loadedConversations,
				convoName
			);
		end
		NarrativeInterface._private.conversationRefParentage[parentId] = nil;
	end
end

function NarrativeInterface._private.OnLuaFileUnloaded(args:ScriptFileUnloadedArgs):void
	if (not NarrativeInterface.useTableRefCountManagement) then return; end	-- Kill-switch
	
	NarrativeInterface.ForceUnloadTableParent(args.scriptNameHash);
end
-- Any time a Lua file gets unloaded, check our ref-count mapping, and decrement/remove associated tables
RegisterGlobalEvent(g_eventTypes.onScriptFileUnloaded, NarrativeInterface._private.OnLuaFileUnloaded);


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: LUA PREPROCESSOR DIRECTIVES ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global LUA_LOAD = {};

function LUA_LOAD.IsGameTest():boolean
	-- TODO
	--local solutionConfiguration = GetCurrentEngineSolutionConfiguration();
	--return solutionConfiguration == "Test";

	return true;
end

function LUA_LOAD.IsGameProfile():boolean
	-- TODO
	--local solutionConfiguration = GetCurrentEngineSolutionConfiguration();
	--return (solutionConfiguration == "Profile" or solutionConfiguration == "Profile_noLTCG");

	return false;
end

function LUA_LOAD.IsGameEditor():boolean
	-- TODO
	--return GetCurrentEngineIsEditor();

	return true;
end

function LUA_LOAD.IsGameTestOrEditor():boolean
	return LUA_LOAD.IsGameTest() or LUA_LOAD.IsGameEditor();
end


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: NON-RELEASE COMPONENTS :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================
--<<<<<<<<<<<<
if (LUA_LOAD.IsGameTestOrEditor()) then
--<<<<<<<<<<<<

NarrativeInterface.DEBUG = {
	defaultFrequency = 4,
	subjectsList = {
		AI = { "ai", },
		Conversations = { "conversations", "conversation", "convo", "convos",
						  "dialog", "dialogs", "dialogue", "dialogues", },
		Sequences = { "sequences", "sequence", "seq", "seqs",
					  "narseq", "narseqs", "nseq", "nseqs" },
		TacMap = { "tacmap", "tac map", "tac_map",
				   "gamemap", "game map", "game_map",
				   "ingamemap", "ingame map", "ingame_map",
				   "in game map", "in-game map", "in_game_map",
				   "tacticalmap", "tactical map", "tactical_map",
				   "fast travel", "fast_travel", "fasttravel", },
	},
	fastTime = 0.25,
};

NarrativeInterface.DEBUG.INTERNAL = {};
NarrativeInterface.DEBUG.INTERNAL.TrackingData = {};

function NarrativeInterface.DEBUG.DiscardZeroRefTables():void
	if (not (NarrativeInterface.useTableRefCountManagement and NarrativeInterface.simulateTableRefCountManagement)) then return; end	-- Kill-switch
	-- DEBUG -------------------------------
	local unmanagedSeqTableCount = 0;
	for _,__ in hpairs(NarrativeInterface.loadedSequences) do
		unmanagedSeqTableCount = unmanagedSeqTableCount + 1;
	end
	
	local unmanagedConvoTableCount = 0;
	for _,__ in hpairs(NarrativeInterface.loadedConversations) do
		unmanagedConvoTableCount = unmanagedConvoTableCount + 1;
	end
	----------------------------------------

	-- Replace old list tables containing all items with new table containing only ref-appropriate items
	NarrativeInterface._private.loadedSequences		= table.copy(NarrativeInterface._private.simulatedRefState.loadedSequences, false);		-- SHALLOW-copy the loaded table.  We don't want clones of each sequence table - just a copy of the list of those tables
	NarrativeInterface._private.loadedConversations	= table.copy(NarrativeInterface._private.simulatedRefState.loadedConversations, false);	-- SHALLOW-copy the loaded table.  We don't want clones of each convo table - just a copy of the list of those tables
	
	-- DEBUG -------------------------------
	local managedSeqTableCount = 0;
	for _,__ in hpairs(NarrativeInterface.loadedSequences) do
		managedSeqTableCount = managedSeqTableCount + 1;
	end
	
	local managedConvoTableCount = 0;
	for _,__ in hpairs(NarrativeInterface.loadedConversations) do
		managedConvoTableCount = managedConvoTableCount + 1;
	end
	
	ConditionalDebugPrint("showRefCountingDebugInfo", ">...>...>... Cleaning out orphaned conversation and sequence tables...");
	ConditionalDebugPrint("showRefCountingDebugInfo", "    Sequences --");
	ConditionalDebugPrint("showRefCountingDebugInfo", "      was:", unmanagedSeqTableCount, "| now:", managedSeqTableCount, "(" .. (unmanagedSeqTableCount - managedSeqTableCount), "tables removed)");
	ConditionalDebugPrint("showRefCountingDebugInfo", "    Conversations --");
	ConditionalDebugPrint("showRefCountingDebugInfo", "      was:", unmanagedConvoTableCount, "| now:", managedConvoTableCount, "(" .. (unmanagedConvoTableCount - managedConvoTableCount), "tables removed)");
	----------------------------------------
end

function NarrativeInterface.DEBUG.INTERNAL.TrackingThread():void
	local trackingData = NarrativeInterface.DEBUG.INTERNAL.TrackingData;

	while (true) do
		local newTimestamp:time_point = Game_TimeGet();
		trackingData.timeOfLastCheck = trackingData.timeOfLastCheck or newTimestamp;
		local timeDeltaSeconds = (newTimestamp == trackingData.timeOfLastCheck and trackingData.frequency) or newTimestamp:ElapsedTime(trackingData.timeOfLastCheck);
		local showedTimestamp = false;

		for subject,subjectData in hpairs(NarrativeInterface.DEBUG.Tracking) do
			if (not subjectData.changesOnly and (timeDeltaSeconds >= trackingData.frequency)) then
				trackingData.timeOfLastCheck = newTimestamp;

				if (not showedTimestamp) then
					print("");
					print("     ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~");
					print(newTimestamp);
					showedTimestamp = true;
				end

				NarrativeInterface[subject].Print();
				print("     ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~");
			elseif (NarrativeInterface[subject].stateChanged) then
				if (not showedTimestamp) then
					print("");
					print("     !CHANGED CHANGED CHANGED CHANGED");
					print(newTimestamp);
					showedTimestamp = true;
				end

				NarrativeInterface[subject].PrintChangesOnly();
				print("     CHANGED CHANGED CHANGED CHANGED!");
			end

			NarrativeInterface[subject].stateChanged = false;
		end

		NarrativeInterface.Conversations.UpdateTrackingData();
		NarrativeInterface.Sequences.UpdateTrackingData();

		Sleep(1);
	end
end

function NarrativeInterface.DEBUG.INTERNAL.GetDebugPanelsData():table
	if (not DebugPanelsEnabled) then return nil; end

	local trackingData = NarrativeInterface.DEBUG.INTERNAL.TrackingData;
	trackingData.PanelsData = trackingData.PanelsData or {};

	return trackingData.PanelsData;
end

function NarrativeInterface.DEBUG.INTERNAL.ConversationStarted(convoId:string):void
	if (not DebugPanelsEnabled) then return; end
	if (not convoId) then return end;

	local panelsData = NarrativeInterface.DEBUG.INTERNAL.GetDebugPanelsData();
	panelsData[convoId] = true;
end

function NarrativeInterface.DEBUG.INTERNAL.RefreshDebugPanelsData()
	if (not DebugPanelsEnabled) then return nil,nil; end

	local panelsData = NarrativeInterface.DEBUG.INTERNAL.GetDebugPanelsData();

	local convoActive = false;
	local convoCompositionRunning = false;

	-- These previously-started convos are no longer running.
	for convoId,_ in hpairs(panelsData) do
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not (convo and NarrativeInterface.ConversationTableIsActive(convo))) then
			panelsData[convoId] = nil;
		else
			convoActive = true;
			if (not convoCompositionRunning) then
				local showId = convo.GetShowId and convo:GetShowId();
				convoCompositionRunning = showId and ((type(showId) == "table" and ((showId.currentCount or 0) > 0)) or (type(showId) == "number" and composer_show_is_playing(showId)));
			end
		end
	end

	return convoActive, convoCompositionRunning;
end

function NarrativeInterface.DEBUG.INTERNAL.DebugPanelsThread():void
	while (true) do
		if (DebugPanelsEnabled) then
			local convoActive,convoCompositionRunning = NarrativeInterface.DEBUG.INTERNAL.RefreshDebugPanelsData();

			if (convoActive) then
				Narrative_DebugPanelStatus("Convo Q'd");
			end

			if (convoCompositionRunning) then
				Narrative_DebugPanelStatus("Composition");
			end

			if (NarrativeInterface.AI and NarrativeInterface.AI.IsDisabled and NarrativeInterface.AI.IsDisabled()) then
				Narrative_DebugPanelWarning("Nar:BrainDead");
			end

			if (NarrativeInterface.TacMap and NarrativeInterface.TacMap.IsLocked and NarrativeInterface.TacMap.IsLocked()) then
				Narrative_DebugPanelWarning("Nar:TacMap");
			end
		end

		SleepSeconds(NarrativeInterface.DEBUG.fastTime);
	end
end

--function NarrativeInterface.DEBUG.UpdateLastTrackedData(subject:string):void
--	NarrativeInterface.DEBUG.StartTrackingThread();
--	local subjectResolved:string = NarrativeInterface.DEBUG.ResolveTrackingSubject(subject);
--
--	-- TODO
--end
--
--function NarrativeInterface.DEBUG.PrintStatusChanged(subject:string):void
--	NarrativeInterface.DEBUG.StartTrackingThread();
--	local subjectResolved:string = NarrativeInterface.DEBUG.ResolveTrackingSubject(subject);
--
--	-- TODO
--end

function NarrativeInterface.DEBUG.StartTrackingThread():void
	NarrativeInterface.DEBUG.Tracking = NarrativeInterface.DEBUG.Tracking or {};

	if (not NarrativeInterface.DEBUG.trackingThread) then
		NarrativeInterface.DEBUG.trackingThread = CreateThread(NarrativeInterface.DEBUG.INTERNAL.TrackingThread);
	end
end

function NarrativeInterface.DEBUG.StartDebugPanelsThread():void
	if (not NarrativeInterface.DEBUG.debugPanelsThread) then
		NarrativeInterface.DEBUG.debugPanelsThread = CreateThread(NarrativeInterface.DEBUG.INTERNAL.DebugPanelsThread);
	end
end

function NarrativeInterface.DEBUG.StopDebugPanelsThread():void
	if (NarrativeInterface.DEBUG.debugPanelsThread) then
		KillThread(NarrativeInterface.DEBUG.debugPanelsThread);
		NarrativeInterface.DEBUG.debugPanelsThread = nil;
	end
end

function NarrativeInterface.DEBUG.ResolveTrackingSubject(subject:string):string
	if (subject) then
		local subjectLower = string.lower(subject);

		for subjectName,aliasList in hpairs(NarrativeInterface.DEBUG.subjectsList) do
			for _,subjectAlias in hpairs(aliasList) do
				if (subjectLower == subjectAlias) then
					return subjectName;
				end
			end
		end
	end

	return nil;
end

function NarrativeInterface.DEBUG.SetTrackingFrequency(frequency:number):void
	NarrativeInterface.DEBUG.StartTrackingThread();
	NarrativeInterface.DEBUG.INTERNAL.TrackingData.frequency = frequency or 4;
end

function NarrativeInterface.DEBUG.Track(subject:string, frequency:number):string
	NarrativeInterface.DEBUG.StartTrackingThread();
	local subjectResolved:string = NarrativeInterface.DEBUG.ResolveTrackingSubject(subject);

	if (subjectResolved) then
		NarrativeInterface.DEBUG.INTERNAL.TrackingData.frequency = frequency or 4;
		NarrativeInterface.DEBUG.Tracking[subjectResolved] = NarrativeInterface.DEBUG.Tracking[subjectResolved] or {};
		NarrativeInterface.DEBUG.Tracking[subjectResolved].stateChanged = true;
	end

	return subjectResolved;
end

function NarrativeInterface.DEBUG.TrackChangesOnly(subject:string, frequency:number):string
	local subjectResolved:string = NarrativeInterface.DEBUG.Track(subject, frequency);
	if (subjectResolved) then
		NarrativeInterface.DEBUG.Tracking[subjectResolved].changesOnly = true;
	end

	return subjectResolved;
end

function NarrativeInterface.DEBUG.StopTracking(subject:string):void
	if (NarrativeInterface.DEBUG.Tracking) then
		local subjectResolved:string = NarrativeInterface.DEBUG.ResolveTrackingSubject(subject);

		if (subjectResolved) then
			NarrativeInterface.DEBUG.Tracking[subjectResolved] = nil;
		end
	end
end

function NarrativeInterface.DEBUG.TrackAll(frequency:number):void
	NarrativeInterface.DEBUG.Track("AI", frequency);
	NarrativeInterface.DEBUG.Track("Conversations", frequency);
	NarrativeInterface.DEBUG.Track("Sequences", frequency);
	NarrativeInterface.DEBUG.Track("TacMap", frequency);
end

function NarrativeInterface.DEBUG.TrackAllChangesOnly(frequency:number):void
	NarrativeInterface.DEBUG.TrackChangesOnly("AI", frequency);
	NarrativeInterface.DEBUG.TrackChangesOnly("Conversations", frequency);
	NarrativeInterface.DEBUG.TrackChangesOnly("Sequences", frequency);
	NarrativeInterface.DEBUG.TrackChangesOnly("TacMap", frequency);
end

function NarrativeInterface.DEBUG.StopTrackingAll():void
	if (NarrativeInterface.DEBUG.Tracking and NarrativeInterface.DEBUG.trackingThread) then
		KillThread(NarrativeInterface.DEBUG.trackingThread);
	end

	NarrativeInterface.DEBUG.Tracking = nil;
end

function NarrativeInterface.DEBUG.Help(subtopic:string):void
	if (subtopic) then
		print("--/--\--/@  - NARRATIVE DEBUG HELP -  @\--/--\--");
		print("");

		local subtopicResolved = NarrativeInterface.DEBUG.ResolveTrackingSubject(subtopic);
		if (subtopicResolved and NarrativeInterface.DEBUG.subjectsList[subtopicResolved]) then
			print("To specify this subject, you may use any of the following strings (ignores case) :")
			for _,alias in hpairs(NarrativeInterface.DEBUG.subjectsList[subtopicResolved]) do
				print(alias);
			end
		end

		print("--/--\--/@  --/--\--/@ * * * @\--/--\--  @\--/--\--");
	else

		print("--/--\--/@  - NARRATIVE DEBUG HELP -  @\--/--\--");
		print("");

		local subjectsString = "";
		for subjectName,aliasList in hpairs(NarrativeInterface.DEBUG.subjectsList) do
			subjectsString = subjectsString .. "'" .. subjectName .. "', "
		end

		print("SUBJECTS:", subjectsString);
		print("  See NarrativeInterface.DEBUG.Help(<subject>) for more");
		print("");
		print("NarrativeInterface.<subject>.<function> :");
		print("");
		print("Print - Immediately displays current status for all subjects");
		print("PrintChangesOnly - Immediately displays only items that have changed since last check for each subject");
		print("PrintState - Immediately displays current status for the specified subject");
		print("");
		print("NarrativeInterface.DEBUG.<function> :");
		print("");
		print("TrackAll - Begin regularly displaying status for all subjects");
		print("TrackAllChangesOnly - Begin displaying items for all subjects whenever they change");
		print("Track - Include specified subject in regularl displays of status");
		print("TrackChangesOnly - Begin displaying items for specified subject whenever they change");
		print("");
		print("SetTrackingFrequency - Update the seconds between each tracking print (default: 4 seconds)");
		print("");
		print("PreventAllConversations - Cause all conversations to instantly conclude without playing compositions or audio.");
		print("IsPreventingAllConversations - Indicates whether or not conversations are being prevented.");
		print("--/--\--/@  --/--\--/@ * * * @\--/--\--  @\--/--\--");
	end
end

NarrativeInterface.DEBUG.INTERNAL.helperMetatable = {
	EmptyFunction = function()
		print("This empty function does nothing.  How you got here:");
		print(debug.traceback());
	end,
	__index = function(myTable, key)
		local thisMetatable = getmetatable(myTable);
		local rawName = rawget(myTable, "name");

		if (not key or not rawName) then
			if (not key) then
				print("WARNING: Invalid key used on NarrativeInterface.DEBUG.");
			end
			if (not rawName) then
				print("WARNING: NarrativeInterface subject table had no name field defined.");
			end
		elseif (key == "Track") or (key == "TrackChangesOnly") or (key == "StopTracking") then
			return function(...) return NarrativeInterface.DEBUG[key](rawName, ...); end;
		else
			print("WARNING: No such method found for NarrativeInterface.DEBUG." .. key);
		end

		print("DOING NOTHING");
		return thisMetatable.EmptyFunction;
	end,
}

function NarrativeInterface.DEBUG.PreventAllConversations(shouldPrevent:boolean):void
	NarrativeQueue.PreventConversations(shouldPrevent);
end

function NarrativeInterface.DEBUG.IsPreventingAllConversations():boolean
	return NarrativeQueue.IsPreventingConversations();
end

function NarrativeInterface.DEBUG.ForceCompositionsToFullyPlay(shouldForce:boolean):void
	NarrativeQueue.ForceFullCompositionPlayback(shouldForce);
end

function NarrativeInterface.DEBUG.IsForcingCompositionsToFullyPlay():boolean
	return NarrativeQueue.IsForcingFullCompositionPlayback();
end


--<><><><><><>
--else
--<><><><><><>

-->>>>>>>>>>>>
end
-->>>>>>>>>>>>

-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::: TAC MAP LOCKING SUPPORT AND TRACKING ::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

NarrativeInterface.TacMap = setmetatable({ name = "TacMap", }, NarrativeInterface.DEBUG.INTERNAL.helperMetatable);

--<<<<<<<<<<<<
if (LUA_LOAD.IsGameTestOrEditor()) then
--<<<<<<<<<<<<

NarrativeInterface.TacMap.SuppressionStack = {
	[NarrativeInterface.TYPE.Conversation] = {},
	[NarrativeInterface.TYPE.Sequence] = {},
};

function NarrativeInterface.TacMap.Lock(lockerName:string, lockerType:number):void
	if (lockerType < 1 or lockerType > 2) then
		print("FAILED TO LOCK TAC MAP", lockerName, lockerType);
		print(debug.traceback());
		return;
	end

	--print("TAC MAP LOCK -", (lockerType == 1 and "Conversation" or "Sequence"), lockerName);
	local currentValue = NarrativeInterface.TacMap.SuppressionStack[lockerType][lockerName];
	NarrativeInterface.TacMap.SuppressionStack[lockerType][lockerName] = (currentValue or 0) + 1;
	NarrativeInterface.TacMap.stateChanged = true;

	InGameMap_Lock();
end

function NarrativeInterface.TacMap.Unlock(lockerName:string, lockerType:number):void
	if (lockerType < 1 or lockerType > 2) then
		print("FAILED TO UNLOCK TAC MAP", lockerName, lockerType);
		print(debug.traceback());
		return;
	end

	local currentValue = NarrativeInterface.TacMap.SuppressionStack[lockerType][lockerName];
	if (not currentValue or currentValue < 1) then
		print("ATTEMPTED TO UNLOCK TAC MAP FROM NON-LOCKING SOURCE");
		print(debug.traceback());
		return;
	end

	--print("TAC MAP UNLOCK -", (lockerType == 1 and "Conversation" or "Sequence"), lockerName);
	NarrativeInterface.TacMap.SuppressionStack[lockerType][lockerName] = (currentValue or 0) - 1;
	NarrativeInterface.TacMap.stateChanged = true;

	InGameMap_Unlock();
end

function NarrativeInterface.TacMap.IsLocked():boolean
	for _,lockerData in hpairs(NarrativeInterface.TacMap.SuppressionStack) do
		for _,value in hpairs(lockerData) do
			if (value > 0) then
				return true;
			end
		end
	end

	return false;
end

function NarrativeInterface.TacMap.PrintChangesOnly():void
	-- TODO

	NarrativeInterface.TacMap.Print();
end

function NarrativeInterface.TacMap.Print():void
	print("     Tac Map Lock State:");
	print("      - Conversations -");
	for name,count in hpairs(NarrativeInterface.TacMap.SuppressionStack[1]) do
		print("        ", name, "=", (count > 0 and count or "-UNLOCKED-"));
	end
	print("      - Sequences -");
	for name,count in hpairs(NarrativeInterface.TacMap.SuppressionStack[2]) do
		print("        ", name, "=", (count > 0 and count or "-UNLOCKED-"));
	end
end

--function NarrativeInterface.TacMap.Track(frequency:number):string
--	return NarrativeInterface.DEBUG.Track("TacMap", frequency);
--end
--
--function NarrativeInterface.TacMap.TrackChangesOnly(frequency:number):string
--	return NarrativeInterface.DEBUG.TrackChangesOnly("TacMap", frequency);
--end
--
--function NarrativeInterface.TacMap.StopTracking():void
--	NarrativeInterface.DEBUG.StopTracking("TacMap");
--end

--<><><><><><>
--else
----<><><><><><>
--
--function NarrativeInterface.TacMap.Lock():void
--	InGameMap_Lock();
--end
--
--function NarrativeInterface.TacMap.Unlock():void
--	InGameMap_Unlock();
--end

-->>>>>>>>>>>>
end
-->>>>>>>>>>>>


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: AI SUPPRESSION AND TRACKING ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

NarrativeInterface.AI = setmetatable({
	name = "AI",
	disabledAiStack = 0,
},
NarrativeInterface.DEBUG.INTERNAL.helperMetatable);

--<<<<<<<<<<<<
if (LUA_LOAD.IsGameTestOrEditor()) then
--<<<<<<<<<<<<

NarrativeInterface.AI.SuppressionStack = {
	[NarrativeInterface.TYPE.Conversation] = {},
	[NarrativeInterface.TYPE.Sequence] = {},
};

-- TODO
--NarrativeInterface.AI.previousState = {
--	[NarrativeInterface.TYPE.Conversation] = {},
--	[NarrativeInterface.TYPE.Sequence] = {},
--};
--
--NarrativeInterface.AI.currentState = {
--	[NarrativeInterface.TYPE.Conversation] = {},
--	[NarrativeInterface.TYPE.Sequence] = {},
--};
--
--NarrativeInterface.AI.changedState = {
--	[NarrativeInterface.TYPE.Conversation] = {},
--	[NarrativeInterface.TYPE.Sequence] = {},
--};

--function NarrativeInterface.IncrementAiDisabled():void
function NarrativeInterface.AI.IncrementDisabled(lockerName:string, lockerType:number):void
	if (lockerType < 1 or lockerType > 2) then
		print("FAILED TO DISABLE AI", lockerName, lockerType);
		print(debug.traceback());
		return;
	end

	-- Disable AI
	ai_enable(false);

	-- Track how many sequences are suppressing AI
	NarrativeInterface.AI.disabledAiStack = NarrativeInterface.AI.disabledAiStack + 1;
	local currentValue = NarrativeInterface.TacMap.SuppressionStack[lockerType][lockerName];
	NarrativeInterface.AI.SuppressionStack[lockerType][lockerName] = (currentValue or 0) + 1;
	NarrativeInterface.AI.stateChanged = true;
end

--function NarrativeInterface.DecrementAiDisabled():void
function NarrativeInterface.AI.DecrementDisabled(lockerName:string, lockerType:number):void
	if (lockerType < 1 or lockerType > 2) then
		print("FAILED TO ENABLE AI", lockerName, lockerType);
		print(debug.traceback());
		return;
	end

	local currentValue = NarrativeInterface.AI.SuppressionStack[lockerType][lockerName];
	if (not currentValue or currentValue < 1) then
		print("ATTEMPTED TO ENABLE AI FROM NON-LOCKING SOURCE");
		print(debug.traceback());
		return;
	end
	if (NarrativeInterface.AI.disabledAiStack == 0) then
		return;
	end

	-- Update how many sequences are still suppressing AI
	NarrativeInterface.AI.disabledAiStack = NarrativeInterface.AI.disabledAiStack - 1;
	NarrativeInterface.AI.SuppressionStack[lockerType][lockerName] = (currentValue or 0) - 1;
	NarrativeInterface.AI.stateChanged = true;

	-- Last one out, hit the lights
	if (NarrativeInterface.AI.disabledAiStack == 0) then
		ai_enable(true);
	end
end

function NarrativeInterface.AI.IsDisabled():boolean
	return NarrativeInterface.AI.disabledAiStack > 0;
end

function NarrativeInterface.AI.PrintChangesOnly():void
	NarrativeInterface.AI.stateChanged = false;
	-- TODO

	NarrativeInterface.AI.Print();
end

function NarrativeInterface.AI.Print():void
	NarrativeInterface.AI.stateChanged = false;

	print("     AI Disable State:");
	print("      - Conversations -");
	for name,count in hpairs(NarrativeInterface.AI.SuppressionStack[1]) do
		print("        ", name, "=", (count > 0 and count or "-UNLOCKED-"));
	end
	print("      - Sequences -");
	for name,count in hpairs(NarrativeInterface.AI.SuppressionStack[2]) do
		print("        ", name, "=", (count > 0 and count or "-UNLOCKED-"));
	end
end

--<><><><><><>
--else
----<><><><><><>
--
----function NarrativeInterface.IncrementAiDisabled():void
--function NarrativeInterface.AI.IncrementDisabled():void
--	-- Disable AI
--	ai_enable(false);
--
--	-- Track how many sequences are suppressing AI
--	NarrativeInterface.AI.disabledAiStack = NarrativeInterface.AI.disabledAiStack + 1;
--end
--
----function NarrativeInterface.DecrementAiDisabled():void
--function NarrativeInterface.AI.DecrementDisabled():void
--	if (NarrativeInterface.AI.disabledAiStack == 0) then
--		return;
--	end
--
--	-- Update how many sequences are still suppressing AI
--	NarrativeInterface.AI.disabledAiStack = NarrativeInterface.AI.disabledAiStack - 1;
--
--	-- Last one out, hit the lights
--	if (NarrativeInterface.AI.disabledAiStack == 0) then
--		ai_enable(true);
--	end
--end

-->>>>>>>>>>>>
end
-->>>>>>>>>>>>


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: CONVERSATION TRACKING :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

--<<<<<<<<<<<<
if (LUA_LOAD.IsGameTestOrEditor()) then
--<<<<<<<<<<<<

NarrativeInterface.Conversations = setmetatable({
	name = "Conversations",
	previousState = {},
	currentState = {},
	changedState = {},
	updatedSinceLastPrint = false,
	stateChanged = false,
},
NarrativeInterface.DEBUG.INTERNAL.helperMetatable);

function NarrativeInterface.Conversations.Changed():void
	NarrativeInterface.Conversations.stateChanged = true;
	NarrativeInterface.Conversations.updatedSinceLastPrint = false;
end

function NarrativeInterface.Conversations.UpdateTrackingData():void
	NarrativeInterface.Conversations.updatedSinceLastPrint = true;
	NarrativeInterface.Conversations.stateChanged = false;

	-- Reset list of changed items
	NarrativeInterface.Conversations.changedState = {};
	local changedState = NarrativeInterface.Conversations.changedState;

	-- Clear expired previous state
	NarrativeInterface.Conversations.previousState = {};
	local previousState = NarrativeInterface.Conversations.previousState;

	-- Capture new previous state and clear current state
	local staleState = NarrativeInterface.Conversations.currentState;
	NarrativeInterface.Conversations.currentState = {};
	local currentState = NarrativeInterface.Conversations.currentState;

	-- Record all PENDING conversations
	for _,convo in hpairs(NarrativeQueue.instance.pendingConversations) do
		currentState[convo.name] = { state = "PENDING", duration = convo.privateData.timePendingSeconds, };
		previousState[convo.name] = staleState[convo.name];

		-- We've got a change to previous state if the current item is brand new, or if its state value changed since last update
		if (not previousState[convo.name] or (currentState[convo.name].state ~= previousState[convo.name].state)) then
			changedState[convo.name] = true;
			NarrativeInterface.Conversations.stateChanged = true;
		end
	end

	-- Record all PLAYING conversations
	for _,convo in hpairs(NarrativeQueue.instance.playingConversations) do
		currentState[convo.name] = { state = "PLAYING", duration = convo.privateData.timeElapsedSeconds, };
		previousState[convo.name] = staleState[convo.name];

		-- We've got a change to previous state if the current item is brand new, or if its state value changed since last update
		if (not previousState[convo.name] or (currentState[convo.name].state ~= previousState[convo.name].state)) then
			changedState[convo.name] = true;
			NarrativeInterface.Conversations.stateChanged = true;
		end
	end

	-- Record all DELAYED conversations
	for _,convo in hpairs(NarrativeQueue.instance.delayedConversations) do
		currentState[convo.name] = { state = "DELAYED", };
		previousState[convo.name] = staleState[convo.name];

		-- We've got a change to previous state if the current item is brand new, or if its state value changed since last update
		if (not previousState[convo.name] or (currentState[convo.name].state ~= previousState[convo.name].state)) then
			changedState[convo.name] = true;
			NarrativeInterface.Conversations.stateChanged = true;
		end
	end

	-- Record all COMPLETED conversations
	for name,convo in NarrativeInterface.loadedConversations.__hpairs() do
		if (NarrativeQueue.HasConversationFinished(convo)) then
			currentState[convo.name] = { state = "COMPLETED", };
			previousState[convo.name] = staleState[convo.name];

			-- We've got a change to previous state if the current item is brand new, or if its state value changed since last update
			if (not previousState[convo.name] or (currentState[convo.name].state ~= previousState[convo.name].state)) then
				changedState[convo.name] = true;
				NarrativeInterface.Conversations.stateChanged = true;
			end
		end
	end

	-- We don't explicitly track UNSTARTED conversations here
end

function NarrativeInterface.Conversations.PrintState(convoName:string):void
	local currentState = NarrativeInterface.Conversations.currentState;
	local previousState = NarrativeInterface.Conversations.previousState;
	local changedState = NarrativeInterface.Conversations.changedState;
	local stateData = currentState[convoName];

	if (not stateData) then
		return;
	end

	local prevStateString:string = ((previousState[convoName] and "" .. previousState[convoName].state .. " --->") or "[] --->");
	local changedStateString:string = ((changedState[convoName] and prevStateString) or "")

	print("        ", convoName, "=", changedStateString, stateData.state, (stateData.duration and "for " .. stateData.duration) or "");
end

function NarrativeInterface.Conversations.PrintChangesOnly():void
	if (not NarrativeInterface.Conversations.updatedSinceLastPrint) then
		NarrativeInterface.Conversations.UpdateTrackingData();
	end

	print("     Current Conversation Queue Status Changes:");
	print("      - Conversations -");

	for name,_ in hpairs(NarrativeInterface.Conversations.changedState) do
		NarrativeInterface.Conversations.PrintState(name);
	end

	NarrativeInterface.Conversations.updatedSinceLastPrint = false;
end

function NarrativeInterface.Conversations.Print():void
	if (not NarrativeInterface.Conversations.updatedSinceLastPrint) then
		NarrativeInterface.Conversations.UpdateTrackingData();
	end

	print("     Current Conversation Queue Status:");
	print("      - Conversations -");

	for name,stateData in hpairs(NarrativeInterface.Conversations.currentState) do
		NarrativeInterface.Conversations.PrintState(name);
	end

	NarrativeInterface.Conversations.updatedSinceLastPrint = false;
end

--<><><><><><>
--else
--<><><><><><>

-->>>>>>>>>>>>
end
-->>>>>>>>>>>>


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SEQUENCE TRACKING :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

--<<<<<<<<<<<<
if (LUA_LOAD.IsGameTestOrEditor()) then
--<<<<<<<<<<<<

NarrativeInterface.Sequences = setmetatable({
	name = "Sequences",
	previousState = {},
	currentState = {},
	changedState = {},
	updatedSinceLastPrint = false,
	stateChanged = false,
},
NarrativeInterface.DEBUG.INTERNAL.helperMetatable);

function NarrativeInterface.Sequences.Changed():void
	NarrativeInterface.Sequences.stateChanged = true;
	NarrativeInterface.Sequences.updatedSinceLastPrint = false;
end

function NarrativeInterface.Sequences.UpdateTrackingData():void
	NarrativeInterface.Sequences.updatedSinceLastPrint = true;
	NarrativeInterface.Sequences.stateChanged = false;

	-- Reset list of changed items
	NarrativeInterface.Sequences.changedState = {};
	local changedState = NarrativeInterface.Sequences.changedState;

	-- Clear expired previous state
	NarrativeInterface.Sequences.previousState = {};
	local previousState = NarrativeInterface.Sequences.previousState;

	-- Capture new previous state and clear current state
	local staleState = NarrativeInterface.Sequences.currentState;
	NarrativeInterface.Sequences.currentState = {};
	local currentState = NarrativeInterface.Sequences.currentState;

	for name,sequence in NarrativeInterface.loadedSequences.__hpairs() do
		local status:string = nil;

		if (sequence.state == NarrativeInterface.STATE.Starting) then
			status = "STARTING";
		elseif (sequence.state == NarrativeInterface.STATE.Running) then
			status = "RUNNING";
		elseif (sequence.state == NarrativeInterface.STATE.Completed) then
			status = "COMPLETED";
		end

		if (status) then
			currentState[name] = { state = status, };
			previousState[name] = staleState[name];

			-- We've got a change to previous state if the current item is brand new, or if its state value changed since last update
			if (not previousState[name] or (currentState[name].state ~= previousState[name].state)) then
				changedState[name] = true;
				NarrativeInterface.Sequences.stateChanged = true;
			end
		end
	end

	-- We don't explicitly track UNSTARTED sequences here
end

function NarrativeInterface.Sequences.PrintState(sequenceName:string):void
	local currentState = NarrativeInterface.Sequences.currentState;
	local previousState = NarrativeInterface.Sequences.previousState;
	local changedState = NarrativeInterface.Sequences.changedState;
	local stateData = currentState[sequenceName];

	if (not stateData) then
		return;
	end

	local prevStateString:string = ((previousState[sequenceName] and "[ " .. previousState[sequenceName].state .. " ] --->") or "[] --->");
	local changedStateString:string = ((changedState[sequenceName] and prevStateString) or "")

	print("        ", sequenceName, "= [", changedStateString, stateData.state, "]");
end

function NarrativeInterface.Sequences.PrintChangesOnly():void
	if (not NarrativeInterface.Sequences.updatedSinceLastPrint) then
		NarrativeInterface.Sequences.UpdateTrackingData();
	end

	print("     Current Sequences Status Changes:");
	print("      - Sequences -");

	for name,_ in hpairs(NarrativeInterface.Sequences.changedState) do
		NarrativeInterface.Sequences.PrintState(name);
	end

	NarrativeInterface.Sequences.updatedSinceLastPrint = false;
end

function NarrativeInterface.Sequences.Print():void
	if (not NarrativeInterface.Sequences.updatedSinceLastPrint) then
		NarrativeInterface.Sequences.UpdateTrackingData();
	end

	print("     Current Sequences Status:");
	print("      - Sequences -");

	for name,sequence in NarrativeInterface.loadedSequences.__hpairs() do
		NarrativeInterface.Sequences.PrintState(name);
	end

	NarrativeInterface.Sequences.updatedSinceLastPrint = false;
end

--<><><><><><>
--else
--<><><><><><>

-->>>>>>>>>>>>
end
-->>>>>>>>>>>>


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: GENERAL BEHAVIOR ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface.OnGameOver()
	NarrativeInterface.Threading.HaltLocalThreads(true);
	NarrativeQueue.GameOver();  -- Interrupts all queued convos, halts all currently-playing lines, terminates the NarrativeQueueInstance thread
	NarrativeInterface.GameOverStarted = true;
	if NarrativeInterface.loadedKits then
		for index, narkit in hpairs(NarrativeInterface.loadedKits) do
			print("Shutting down narrative kit: ", narkit.components.NAME);
			narkit:teardown();
		end
	end
end

function NarrativeInterface.RegisterNarrativeKit(kitInstance:folder)
	if not NarrativeInterface.loadedKits then
		NarrativeInterface.loadedKits = {};
	end
	NarrativeInterface.loadedKits[kitInstance] = kitInstance;
end

function NarrativeInterface.UnregisterNarrativeKit(kitInstance:folder)
	if not NarrativeInterface.loadedKits then
		print("NarrativeInterface.UnregisterNarrativeKit: Unexpected missing table while attempting to unregister kit");
		return;
	end
	NarrativeInterface.loadedKits[kitInstance] = nil;
end

-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: THREADING INTERFACE ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface.Threading.StartThreadManager():void
	if (not NarrativeInterface.Threading.threadManagementThread) then
		NarrativeInterface.Threading.threadManagementThread = CreateThread(NarrativeInterface.Threading.ThreadManager);
	end
end

function NarrativeInterface.Threading.ThreadManager():void
	while (true) do
		local newThreadTable = {};

		-- Save only the active threads, discard the rest
		for _,threadId in ipairs(NarrativeInterface.Threading.managedThreads) do
			if (IsThreadValid(threadId)) then
				table.insert(newThreadTable, threadId);
			end
		end

		NarrativeInterface.Threading.managedThreads = newThreadTable;

		SleepSeconds(NarrativeInterface.Threading.threadManagementUpdate);
	end
end

-- Halt all local managed threads, and all non-exempt sequences and their threads
function NarrativeInterface.Threading.HaltLocalThreads(isGameOver:boolean):void
	print("ALERT: Terminating Narrative threads!");
	-- Terminate the thread manager
	if (IsThreadValid(NarrativeInterface.Threading.threadMangementThread)) then KillThread(NarrativeInterface.Threading.threadMangementThread); end

	-- Terminate all managed threads
	for _,threadId in ipairs(NarrativeInterface.Threading.managedThreads) do
		if (IsThreadValid(threadId)) then KillThread(threadId); end
	end
	NarrativeInterface.Threading.managedThreads = {};

	-- Terminate all non-exempt Sequences
	for sequenceName,threadId in hpairs(NarrativeInterface.Threading.sequenceThreads) do
		local narSequence = NarrativeInterface.loadedSequences[sequenceName];
		if isGameOver or (narSequence and not narSequence.isGlobalScope) then
			NarrativeInterface.ForceTerminateSequenceUnsafe(sequenceName);
		end
	end
	-- Note: Sequence threads clean themselves out of the list
end

-- Creates a new Lua thread as a child of a sequence.  THIS THREAD WILL ONLY SURVIVE AS LONG AS ITS SEQUENCE IS RUNNING.
function NarrativeInterface.CreateSequenceThread(sequenceName:string, threadFunction:ifunction, ...):thread
	local newThread = nil;
	local narSequence = NarrativeInterface.loadedSequences[sequenceName];
	if (not narSequence) then
		--print("NarrativeInterface.CreateSequenceThread() failed to create for ", sequenceName, ": No such sequence found.");
		return nil;
	end

	-- Bootstrap the Thread Manager
	NarrativeInterface.Threading.StartThreadManager();

	-- Create the thread
	newThread = CreateThread(threadFunction, ...);

	if (newThread) then
		-- Register the thread to the parent sequence specified
		narSequence.playingItems = narSequence.playingItems or {};
		narSequence.playingItems.activeThreads = narSequence.playingItems.activeThreads or {};
		table.insert(narSequence.playingItems.activeThreads, newThread);
	end

	return newThread;
end

-- Creates a new Lua thread which will be managed by the Narrative Interface.  THIS THREAD WILL CONTINUE EVEN IF A SEQUENCE THAT STARTED IT FINISHES.
function NarrativeInterface.CreateNarrativeThread(threadFunction:ifunction, ...):thread
	if (not threadFunction) then print("WARNING: No thread function passed to CreateNarrativeThread()!"); end
	-- Bootstrap the Thread Manager
	NarrativeInterface.Threading.StartThreadManager();

	-- Create the thread
	local newThread = CreateThread(threadFunction, ...);

	if (newThread) then
		-- Register the thread to Narrative Interface's collection of Narrative threads for internal management
		table.insert(NarrativeInterface.Threading.managedThreads, newThread);
	else
		print("WARNING: Failed to create narrative thread!");
	end

	return newThread;
end


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: CONVERSATION INTERFACE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface.ConversationIsValid(conversationName:string):boolean
	return (conversationName
		and NarrativeInterface.loadedConversations[conversationName]
		and NarrativeQueue.IsConversationValid(NarrativeInterface.loadedConversations[conversationName])
		and true) or false;
end

function NarrativeInterface.CreateConversation(conversationName:string, conversationData:table, refParent:any):void
	conversationData.__RefCountingParentId = refParent;
	NarrativeInterface.loadedConversations[conversationName] = conversationData;
end

function NarrativeInterface.CreateEmptyConversation(conversationName:string, conversationData:table, refParent:any):table
	if (not NarrativeInterface.loadedConversations[conversationName]) then
		conversationData = conversationData or 
				{
					name = conversationName,
					Priority = CONVO_PRIORITY_FNC.CriticalPath,
					OnStart = CONVO_DEFAULT_BEHAVIORS.OnStart,
					lines = {},
					localVariables = {},
				}

		NarrativeInterface.CreateConversation(conversationName, conversationData, refParent);
		return NarrativeInterface.loadedConversations[conversationName];
	else
		print(conversationName, "already exists");
	end
	return nil;
end

function NarrativeInterface.GetConversation(conversationName:string):table
	return NarrativeInterface.loadedConversations[conversationName];
end

function NarrativeInterface.TryandCreateConversation(conversationName:string, conversationData:table, refParent:any):boolean
	if (NarrativeInterface.GetConversation(conversationName)) then
		return false;
	end

	NarrativeInterface.CreateConversation(conversationName, conversationData, refParent);
	return true;
end

-- Get the number of conversations that are currently playing.
function NarrativeInterface.ConversationsPlayingCount():number
	return NarrativeQueue.ConversationsPlayingCount();
end

-- Grabs the optional and required fields off of the first convo passed in as param, then combines all lines in order passed in
-- To set overrides for optional and required fields, create a convo skeleton table with everything you want EXCEPT the lines table and pass that as the first convo parameter
function NarrativeInterface.FuseConversations(...):table
	local newConvo = nil;

	for _,convoData in ipairs(arg) do
		local convo = (type(convoData) == "table" and convoData) or NarrativeInterface.loadedConversations[convoData];
		if (convo) then
			local didConversion = NarrativeInterface.ConvertConversationToTimeBased(convo);

			if (newConvo) then
				for i=1,#convo.lines do
					table.insert(newConvo.lines, table.copy(convo.lines[i], true));
				end
			else
				newConvo = table.copy(convo, true);
				newConvo.lines = newConvo.lines or {};
			end

			if (didConversion) then
				NarrativeInterface.ConvertConversationToEventBased(convo);
			end
		end
	end

	if (not newConvo) then
		print("ERROR : Failed to fuse conversations together!");
		return nil;
	else
		return newConvo;
	end
end

function NarrativeInterface.SplitConversation(originalConvo:table, ...):table
	if (not originalConvo) then
		print("ERROR : Attempting to split a nil conversation!");
		return nil;
	end

	local didConversion = NarrativeInterface.ConvertConversationToTimeBased(originalConvo);

	local splitConvos = nil;
	local previousIndex = 1;

	local CreateSubtable = function(count, index)
		local convoFragment = table.copy(originalConvo, true);
		convoFragment.name = convoFragment.name .. "_sub_part" .. count;
		convoFragment.lines = { unpack(convoFragment.lines, previousIndex, index and (index - 1)), };

		splitConvos = splitConvos or {};
		table.insert(splitConvos, convoFragment);
		previousIndex = index;
	end;

	for count,index in ipairs(arg) do
		CreateSubtable(count, index);
	end
	CreateSubtable(#splitConvos + 1);

	if (didConversion) then
		NarrativeInterface.ConvertConversationToEventBased(originalConvo);
	end

	if (not splitConvos) then
		print("ERROR : Failed to split convo '", originalConvo.name, "'");
		return nil;
	else
		return splitConvos;
	end
end

function NarrativeInterface.CreateFusedConversation(newConvoName:string, refParent:any, ...):table
	if (not newConvoName) then
		print("ERROR : Failed to create fused conversation - new conversation name was nil");
		return nil;
	end

	local newConvo = NarrativeInterface.FuseConversations(...);
	if (newConvo) then
		newConvo.name = newConvoName;
		if (NarrativeInterface.loadedConversations[newConvo.name]) then
			print ("WARNING : New fused conversation with name '", newConvo.name, "' - A conversation with that name already exists.  Stomping now...");
		end
		NarrativeInterface.CreateConversation(newConvo.name, newConvo, refParent);
		return newConvo;
	end

	print("ERROR : Failed to create fused conversation '", newConvoName, "'");
	return nil;
end

function NarrativeInterface.CreateSplitConversations(originalConvo, refParent:any, ...):table
	if (type(originalConvo) == "string") then
		originalConvo = NarrativeInterface.loadedConversations[originalConvo];
	end
	if (type(originalConvo) ~= "table")
		then return nil;
	end

	local splitConvos = NarrativeInterface.SplitConversation(originalConvo, ...);
	if (not splitConvos) then
		print("WARNING : Failed to split conversation '", originalConvo.name, "'");
		return nil;
	else
		for _,convo in hpairs(splitConvos) do
			NarrativeInterface.CreateConversation(convo.name, convo, refParent);
		end

		return splitConvos;
	end
end


function NarrativeInterface.ConvertConversationToTimeBased(conversation:table):boolean
	if (conversation) then
		-- Convert an Event-based conversation into a Time-based one
		if (not conversation.lines[1]) then
			-- Prepare to deconvert a previously-converted conversation
			local keyList = {};
			for key,line in hpairs(conversation.lines) do
				keyList[key] = line.index;
			end

			-- Deconvert
			for key,index in hpairs(keyList) do
				conversation.lines[index] = conversation.lines[key];
				conversation.lines[key] = nil;
			end

			return true;
		end

		return false;
	end

	return nil;
end

function NarrativeInterface.ConvertConversationToEventBased(conversation:table):boolean
	if (conversation) then
		-- Convert a Time-based conversation into an Event-based one
		if (conversation.lines[1]) then
			local lineCount = #conversation.lines;
			for index = 1, lineCount do
				local line = conversation.lines[index];
				line.index = index;
				conversation.lines[string.lower(line.id)] = line;
				conversation.lines[index] = nil;
			end

			return true;
		end

		return false;
	end

	return nil;
end


-- Attempt to play a dialog sequence.
-- Default behavior if a collision is detected with another playing dialog sequence is to simply queue the new sequence and play it once it is no longer blocked.
-- ===============================================================================================================================
-- 'conversationName':string - String Id of the conversation table to attempt to queue and play.
-- 'parentSequence':string - (Optional) String Id of the Narrative Sequence which was responsible for this Play call (if any).
--    Will be used to track what things are currently playing and associated with a given Narrative Sequence.
-- 'compdata':table - (Optional) State table to be passed into any compositions which get started by the specified conversation.
-- 'sleepUntilConvoCompletes':boolean - (Optional)
--    TRUE means this call should be blocking until the specified conversation completes.
--    FALSE means the conversation will be played asynchronously, and this function will return immediately after it starts.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if play was successful.
--    FALSE if otherwise.
-- ===============================================================================================================================
-- NOTE - jacrowde 2019 - This function is a functional stub-in for future method
function NarrativeInterface.PlayConversation(conversationName:string, parentSequence:string, compdata:table, sleepUntilConvoCompletes:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	if (sleepUntilConvoCompletes) then
		return NarrativeInterface.SleepUntilFinishedPlayConversation(conversationName, parentSequence, compdata);
	end

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		convo.compdata = compdata or convo.compdata;
		NarrativeQueue.QueueConversation(convo);

		-- DEBUG -----------------------------------------
		NarrativeInterface.DEBUG.INTERNAL.ConversationStarted(conversationName);
		--------------------------------------------------

		-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		-- Register this convo with the parent sequence --	TODO
		-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		if (parentSequence and NarrativeInterface.loadedSequences[parentSequence]) then
			NarrativeInterface.loadedSequences[parentSequence].playingItems = NarrativeInterface.loadedSequences[parentSequence].playingItems or {};
			NarrativeInterface.loadedSequences[parentSequence].playingItems.conversations = NarrativeInterface.loadedSequences[parentSequence].playingItems.conversations or {};
			table.insert(NarrativeInterface.loadedSequences[parentSequence].playingItems.conversations, conversationName);
		end

		return true;
	end

	print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayConversation(conversationName:string, parentSequence:string, compdata:table, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over
	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayConversation(conversationName, parentSequence, compdata, false);
end

function NarrativeInterface.PlayAiVoConversation(conversationName:string, parentSequence:string, monikerTypeMap:table, sleepUntilConvoCompletes:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	local convo = NarrativeInterface.loadedConversations[conversationName];
	if (convo and parentSequence) then
		local sequence = NarrativeInterface.loadedSequences[parentSequence];
		if (sequence and sequence.requires and sequence.requires.participants and sequence.transientState and sequence.transientState.participants) then
			-- Separate participants into groups by ai type
			local listByTypes = EnemyListUpdate(sequence.transientState.participants);

			-- Select default player
			local defaultPlayer = nil;
			for _,player in hpairs(PLAYERS.active) do
				defaultPlayer = Player_GetUnit(player);
				if (defaultPlayer) then break; end
			end
			if (not defaultPlayer) then
				print("WARNING: Attempted to play AIVO convo", conversationName, "while all players were dead!  How did this happen?");
				return false;
			end

			-- Sort each type list by distance
			for aiType,aiList in hpairs(listByTypes) do
				listByTypes[aiType] = GetAllEnemiesOfTypeNearPoint(aiList, aiType, sequence.requires.listenerLocation or Object_GetPosition(defaultPlayer), nil, nil);
			end

			-- Assign all empty character fields by moniker
			if (not AssignSortedAiVoCharacters(convo, listByTypes, monikerTypeMap)) then
				print("WARNING: Failed to populate all lines of AIVO conversation", conversationName, "with character units!  Aborting play call.");
				return false;
			end

			-- Create watcher thread to terminate the AIVO convo early based on early-out requirements
			LaunchAIVOWatcherThread(conversationName, convo, sequence.requires.combatStatusLevelToAbortOn);
		end
	end

	return NarrativeInterface.PlayConversation(conversationName, parentSequence, nil, sleepUntilConvoCompletes);
end


function NarrativeInterface.PlayConversationWithShow(conversationName:string, parentSequence:string, show:any, compdata:table, sleepUntilConvoCompletes:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		-- Attach a show to this convo, if requested
		convo.show = show or convo.show;

		-- Play the conversation
		return NarrativeInterface.PlayConversation(conversationName, parentSequence, compdata, sleepUntilConvoCompletes);
	end

	print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayConversationWithShow(conversationName:string, parentSequence:string, show:any, compdata:table, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over
	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayConversationWithShow(conversationName, parentSequence, show, compdata, false);
end


--
--
--
--
function NarrativeInterface.PlayConversationEventBased(conversationName:string, parentSequence:string, show:any, compdata:table, sleepUntilConvoCompletes:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		NarrativeInterface.ConvertConversationToEventBased(convo);
		return NarrativeInterface.PlayConversationWithShow(conversationName, parentSequence, show, compdata, sleepUntilConvoCompletes);
	end

	print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayConversationEventBased(conversationName:string, parentSequence:string, show:any, compdata:table, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayConversationEventBased(conversationName, parentSequence, show, compdata, false);
end

--
--
--
--
function NarrativeInterface.PlayConversationTimeBased(conversationName:string, parentSequence:string, show:any, compdata:table, sleepUntilConvoCompletes:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		NarrativeInterface.ConvertConversationToTimeBased(convo);
		return NarrativeInterface.PlayConversationWithShow(conversationName, parentSequence, show, compdata, sleepUntilConvoCompletes);
	end

	print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayConversationTimeBased(conversationName:string, parentSequence:string, show:any, compdata:table, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayConversationTimeBased(conversationName, parentSequence, show, compdata, false);
end


-- Attempt to queue a dialog sequence, play a random line in that sequence, and the end the sequence.
-- ===============================================================================================================================
-- 'conversationName':string - String Id of the conversation table to attempt to queue and play.
-- 'parentSequence':string - (Optional) String Id of the Narrative Sequence which was responsible for this Play call (if any).
--    Will be used to track what things are currently playing and associated with a given Narrative Sequence.
-- 'compdata':table - (Optional) State table to be passed into any compositions which get started by the specified conversation.
-- 'sleepUntilConvoCompletes':boolean - (Optional)
--    TRUE means this call should be blocking until the specified conversation completes.
--    FALSE means the conversation will be played asynchronously, and this function will return immediately after it starts.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if play was successful.
--    FALSE if otherwise.
-- ===============================================================================================================================
function NarrativeInterface.PlayConversationWithRandomLine(conversationName:string, parentSequence:string, compdata:table, sleepUntilConvoCompletes:boolean, lineOverrides:table):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	if (sleepUntilConvoCompletes) then
		return NarrativeInterface.SleepUntilFinishedPlayConversationWithRandomLine(conversationName, parentSequence, compdata, lineOverrides);
	end

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		local result = NarrativeInterface.PlayConversationEventBased(conversationName, parentSequence, convo.show, compdata, false);
		if (result) then
			Sleep(1);
			NarrativeInterface.SendRandomLineReadyEvent(conversationName, lineOverrides);
			NarrativeInterface.SendConversationEndingEvent(conversationName);
		end

		return result;
	end

	print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayConversationWithRandomLine(conversationName:string, parentSequence:string, compdata:table, lineOverrides:table, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayConversationWithRandomLine(conversationName, parentSequence, compdata, false, lineOverrides);
end

-- Attempt to play a single line from a conversation. Each time this is called it will call the next line in the conversation,
-- until the end where it will wrap back around
-- ===============================================================================================================================
-- 'conversationName':string - String Id of the conversation table to attempt to queue and play.
-- 'parentSequence':string - (Optional) String Id of the Narrative Sequence which was responsible for this Play call (if any).
--    Will be used to track what things are currently playing and associated with a given Narrative Sequence.
-- 'compdata':table - (Optional) State table to be passed into any compositions which get started by the specified conversation.
-- 'sleepUntilConvoCompletes':boolean - (Optional)
--    TRUE means this call should be blocking until the specified conversation completes.
--    FALSE means the conversation will be played asynchronously, and this function will return immediately after it starts.
-- ===============================================================================================================================
function NarrativeInterface.PlayNextLineAsConversation(conversationName:string, parentSequence:string, compdata:table, sleepUntilConvoCompletes:boolean):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		-- For each convo line update the line's If to check if the line's number is equal to the convo's currentLine variable
		for i = 1, #convo.lines do
			local lineData = convo.lines[i];
			lineData.ElseIf = function(thisLine:table, thisConvo:table, queue:table, lineNumber:number)
				return thisConvo.localVariables.currentLine == lineNumber;
			end;
		end
		convo.lines[1].If = convo.lines[1].ElseIf;
		convo.lines[1].ElseIf = nil;

		--Every time we play this conversation, before it starts, move us to the next line
		convo.Initialize = function(thisConvo:table, queue:table)
			convo.localVariables.currentLine = (convo.localVariables.currentLine or 0) + 1;
			if(convo.localVariables.currentLine > #convo.lines) then
				convo.localVariables.currentLine = 1;
			end
		end;


		NarrativeInterface.PlayConversationTimeBased(conversationName, parentSequence, nil, compdata, sleepUntilConvoCompletes);
	else
		print("WARNING : Could not locate convo named", conversationName,"- will play nothing instead.");
	end
end


-- Attempt to play a random line in a specified active 'Event-based' conversation sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the already-running Narrative Sequence to play a line from.
-- 'lineId':string - String Id of the line to play in a convo played by the sequence.
-- ===============================================================================================================================
function NarrativeInterface.SendLineReadyEvent(convoName:string, lineId:string):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[convoName];
	if (convo) then
		NarrativeQueue.PlayEventBasedLine(convo, string.lower(lineId));
	else
		print("WARNING: Attempting to play line '", lineId, "' in dialog sequence '", convoName, "'.  Invalid dialog sequence name: No such named conversation object found.");
	end
end

-- 'lineListOverride' allows the caller to provide their own hand-chosen list of line keys to randomly select from.
--  This way, if there are only a subset of lines in a conversation that you would like to randomly play (like if the
--  first line is a play-once line, and the rest are the random re-play lines), then that functionality is supported.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the already-running Narrative Sequence to play a random line from.
-- 'lineListOverride':table - (Optional) Table containing a list of conversation tables - or String Ids - to randomly select from.
-- ===============================================================================================================================
function NarrativeInterface.SendRandomLineReadyEvent(convoName:string, lineListOverride:table):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	local convo:table = NarrativeInterface.loadedConversations[convoName];
	if (convo) then
		if ((not NarrativeInterface.ConversationIsActive(convo.name)) or (not convo.privateData.EVENT_BASED)) then
			print("WARNING: Attempting to play random line in dialog sequence '", convoName, "'.  This conversation is not active, or is not running in Event-based mode.");
			return;
		end

		-- If lineListOverride exists, and it has a valid #-count, and that #-count is positive, then use lineListOverride ; else use a new empty table
		local overrideListWasValid:boolean = (lineListOverride and #lineListOverride and #lineListOverride > 0);
		local randomLineOptions:table = (overrideListWasValid and lineListOverride) or {};

		if (not overrideListWasValid) then
			--print("SendRandomLineReadyEvent : 'lineListOverride' was not valid for sequence", convoName);
			for key, _ in hpairs(convo.lines) do
				table.insert(randomLineOptions, key);
			end
		end

		local lineOptionCount = #randomLineOptions;
		if (lineOptionCount < 1) then
			print("WARNING: Attempting to play random line in dialog sequence '", convoName, "'.  No lines to select from!");
			return;			
		end

		local selection = randomLineOptions[ (lineOptionCount > 1 and math.random(lineOptionCount)) or 1 ];
		selection = (type(selection) == "string" and selection) or (type(selection) == "table" and selection.id) or ("ERROR: INVALID LINE ID FOR CONVO "..convoName);
		NarrativeInterface.SendLineReadyEvent(convoName, selection);
	else
		print("WARNING: Attempting to play random line in dialog sequence '", convoName, "'.  Invalid dialog sequence name: No such named conversation object found.");
	end
end

-- End a specified active 'Event-based' conversation sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the already-running Narrative Sequence to end.
-- ===============================================================================================================================
function NarrativeInterface.SendConversationEndingEvent(sequenceName:string):void
	local convo:table = NarrativeInterface.loadedConversations[sequenceName];
	if (convo) then
		NarrativeQueue.EndEventBasedConversation(convo);
	else
		print("WARNING: Attempting to mark dialog sequence '", sequenceName, "' as ending.  Invalid dialog sequence name: No such named conversation object found.");
	end
end

-- End a specified active conversation early, after the current playing line ends.
-- ===============================================================================================================================
-- 'convoName':string - String Id of the already-running conversation to end.
-- ===============================================================================================================================
function NarrativeInterface.EndConversationEarly(convoName:string):void
	local convo:table = NarrativeInterface.loadedConversations[convoName];

	if convo ~= nil then
		NarrativeQueue.EndConversationEarly(convo);
	else
		print("WARNING: Attempting to end conversation '", convoName, "' early, but no Conversation was found with this name.")
	end
end

-- Interrupt a specified active conversation after a specified number of seconds.
-- ===============================================================================================================================
-- 'convoName':string - String Id of the already-running conversation to end.
-- 'interruptOverlapDurationSeconds':number - the number of seconds before this conversation is interrupted.
-- ===============================================================================================================================
function NarrativeInterface.InterruptConversation(convoName:string, interruptOverlapDurationSeconds:number):void
	local convo:table = NarrativeInterface.loadedConversations[convoName];

	if convo ~= nil then
		NarrativeQueue.InterruptConversation(convo, interruptOverlapDurationSeconds);
	end
end

-- End a conversation right away.
-- ===============================================================================================================================
-- 'convoName':string - String Id of the already-running conversation to end.
-- ===============================================================================================================================
function NarrativeInterface.KillConversation(convoName:string):void
	local convo:table = NarrativeInterface.loadedConversations[convoName];

	if convo ~= nil then
		NarrativeQueue.KillConversation(convo);
	end
end

-- Check the current completion state of a specified conversation sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of a Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if sequence has successful completed.
--    FALSE if sequence has not yet started, or is currently running.
-- ===============================================================================================================================
function NarrativeInterface.ConversationHasFinished(convoName:string):boolean
	local convo:table = NarrativeInterface.loadedConversations[convoName];
	if (convo) then
		return NarrativeQueue.HasConversationFinished(convo);
	else
		print("WARNING: Attempting to check state of '", convoName, "'.  Invalid dialog sequence name: No such named conversation object found.");
		return false;
	end
end

function NarrativeInterface.ConversationTableIsActive(conversation:table):boolean
	if (conversation) then
		return NarrativeQueuePrivates.ConvoHasPrivateData(conversation) and not NarrativeQueue.HasConversationFinished(conversation);
	end

	return nil;
end

-- Check the current running state of a specified conversation sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of a Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if sequence is currently queued or running.
--    FALSE if sequence is not queued, or has successfully completed.
-- ===============================================================================================================================
function NarrativeInterface.ConversationIsActive(conversationName:string):boolean
	local convo:table = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		return NarrativeInterface.ConversationTableIsActive(convo);
	else
		print("WARNING: Attempting to check state of '", conversationName, "'.  Invalid dialog sequence name: No such named conversation object found.");
		return false;
	end
end

-- Check the current completion state of all compositions started by the specified conversation sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of a Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if all compositions started by this sequence have successfully completed.
--    FALSE if any compositions started by this sequence are still playing.
-- ===============================================================================================================================
function NarrativeInterface.ConversationShowHasFinished(sequenceName:string):boolean
	local convo:table = NarrativeInterface.loadedConversations[sequenceName];
	if (convo) then
		if (NarrativeInterface.ConversationIsActive(sequenceName) and convo.GetShowId ~= nil) then
			return (not not convo:GetShowId()) and composer_show_is_playing(convo:GetShowId());
		elseif (NarrativeQueue.HasConversationFinished(convo)) then
			return true;
		else
			return false;
		end
	else
		print("WARNING: Attempting to check state of composition playing in '", sequenceName, "'.  Invalid dialog sequence name: No such named conversation object found.");
		return false;
	end
end

-- Given a specific conversation name and line id, retrieves the data table for that particular line.
-- ===============================================================================================================================
-- 'conversationName':string - String Id of a conversation table to search in.
-- 'lineId':string - String Id of the line we are looking for.
-- ===============================================================================================================================
-- RETURN:
--    The line table itself if found.
--    Empty table if unable to locate conversation or line.
-- ===============================================================================================================================
function NarrativeInterface.GetLineById(conversationName:string, lineId:string):table
	assert(conversationName ~= nil and conversationName ~= "", "ERROR: Attempted to lookup line by id in conversation with nil or empty name!");
	assert(lineId ~= nil and lineId ~= "", "ERROR: Attempted to lookup line by id in conversation with nil or empty line id!");

	local convo:table = NarrativeInterface.loadedConversations[conversationName];

	if (convo) then
		for _,line in hpairs(convo.lines) do
			if (line.id == lineId) then
				return line;
			end
		end

		print("WARNING: Attempting to lookup line with id", lineId, "in conversation with name", conversationName, "- Unable to locate line with matching id in that conversation!  DOING NOTHING.");
	else
		print("WARNING: Attempting to lookup line with id", lineId, "in conversation with name", conversationName, "- Unable to locate that conversation!  DOING NOTHING.");
	end

	return {};
end

-- Given a specific conversation name and emitter ref, halt currently running VO on that emitter without impacting logical playback of lines.
-- ===============================================================================================================================
-- 'conversationName':string - String Id of a conversation table to search in.
-- 'emitter':object - Reference to the emitter we want to halt VO on.
-- ===============================================================================================================================
function NarrativeInterface.HaltAllLinesOnEmitter(conversationName:string, emitter:any):void
	assert(conversationName ~= nil and conversationName ~= "", "ERROR: Attempted to lookup conversation with nil or empty name!");
	assert(emitter ~= nil, "ERROR: Attempted to halt VO on a nil emitter!");
	
	local convo = NarrativeInterface.loadedConversations[conversationName];
	if (convo) then
		NarrativeQueue.HaltAllLinesOnEmitter(convo, emitter);
	else
		print("WARNING: Attempting to halt vo playback on an emitter in conversation with name", conversationName, "- Unable to locate that conversation!  DOING NOTHING.");
	end
end

-- Given a specific conversation name, and optionally a subset of lines to affect, replaces nil character field with the supplied function.
-- ===============================================================================================================================
-- 'conversationName':string - String Id of a conversation table to search in.
-- 'character':ifunction or object - Function to assign to every line with a nil character function.  Can be an object if you have a spawned biped you're passing to composition.  CANNOT BE NIL.
-- 'subsetOfLines':table (OPTIONAL) - List of strings, or list of line tables, indicating the only lines that should be affected this call.
-- ===============================================================================================================================
function NarrativeInterface.FillAllNilCharacterFunctionsWith(conversationName:string, character:any, subsetOfLines:table):void
	assert(conversationName ~= nil and conversationName ~= "", "ERROR: Attempted to lookup line by id in conversation with nil or empty name!");
	assert(character ~= nil, "ERROR: Attempted to fill all nil characters with 'nil' for convo ".. conversationName);

	local convo:table = NarrativeInterface.loadedConversations[conversationName];

	if (convo) then
		local checkLines:table = convo.lines;
		local validCheckLines:table = nil;

		if (subsetOfLines and subsetOfLines[1]) then
			if (type(subsetOfLines[1]) == "string") then
				validCheckLines = {};

				for _,lineId in hpairs(subsetOfLines) do
					validCheckLines[lineId] = true;
				end
			elseif (type(subsetOfLines[1]) == "table") then
				checkLines = subsetOfLines;
			end
		end
		if type(character) == "function" or type(character) == "object" or GetEngineType(character) == "object" then
			for _,line in hpairs(checkLines) do
				if (not validCheckLines or validCheckLines[line.id]) then
						line.character = line.character or character;
				end
			end
		else
			error("ERROR: Attempted to override 'character' with non-function/-object! (" .. type(character) .. " [" .. GetEngineType(character) .. "])");
		end
	end
end


-- Convo chaining
function NarrativeInterface.CreateAndPlayChainConversation(convoList:table, parentSequence:string, sleepUntilChainCompleted:boolean):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	NarrativeInterface.CreateChainConversation(convoList);
	NarrativeInterface.PlayChainConversation(convoList[1], parentSequence, sleepUntilChainCompleted);
end

function NarrativeInterface.CreateChainConversation(convoList:table):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	local prev = nil;
	for _,convoId in ipairs(convoList) do
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (convo) then
			convo.chain = {};
			convo.Priority = CONVO_PRIORITY_FNC.Chain;

			-- Double-linked list convo chain
			if (prev) then
				convo.chain.prev = prev;
				prev.chain.next = convo;

				convo.CanStart = function(thisConvo:table, queue:table):boolean
					return thisConvo.chain.prev.chain.completed and (not not thisConvo.chain.prev.compdata.NextShowId);	-- Don't start the current convo until its associated show has actually started and the previous convo has reported completion
				end

				convo.CheckFrequence = function(thisConvo:table, queue:table):number
					return 1/60;
				end
			end

			-- Set up logic to inform the next link in the chain that they should start
			local userDefinedOnFinish = convo.OnFinish;
			convo.OnFinish = function(thisConvo:table, queue:table):void
				thisConvo.chain.completed = true;
				if (userDefinedOnFinish) then userDefinedOnFinish(thisConvo, queue); end
			end

			prev = convo;
		else
			print("WARNING: Attempted to add", convoId, "to convo chain, but it isn't loaded.  Skipping.");
		end
	end
end

function NarrativeInterface.PlayChainConversation(convoId:string, parentSequence:string, sleepUntilChainCompleted:boolean):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	local rootConvo = NarrativeInterface.loadedConversations[convoId];
	if (rootConvo) then
		-- Seek to the real root node if we're given a later nod in the chain
		while (rootConvo.chain and rootConvo.chain.prev) do
			rootConvo = rootConvo.chain.prev;
		end

		local convo = rootConvo;
		while (convo and convo.chain) do
			NarrativeQueuePrivates.ResetConvoHasCompleted(convo);
			NarrativeInterface.PlayConversationEventBased(convo.name, parentSequence, convo.show, convo.compdata, false);
			convo = convo.chain.next;
		end

		if (sleepUntilChainCompleted) then
			SleepUntil([| NarrativeInterface.IsChainComplete(convoId) ], 1);
		end
	else
		print("ERROR: Attempted to play", convoId, "in a convo chain, but it isn't loaded.  Doing nothing.");
	end
end

function NarrativeInterface.KillAllChainConversations():void
	NarrativeQueue.KillAllConversationsOfType(CONVO_PRIORITY.Chain);
end

function NarrativeInterface.IsChainComplete(convoId:string):boolean
	if (not convoId) then return nil; end
	local convo = NarrativeInterface.loadedConversations[convoId];
	if (not convo) then return nil; end
	if (not convo.chain) then return nil; end

	local processedList = {};
	while (convo.chain.next) do
		convo = convo.chain.next;

		if (processedList[convo]) then return nil; end  -- Impossible to reach the end of an infinitely recursing chain

		processedList[convo] = true;
	end
	processedList = nil;

	return NarrativeQueue.HasConversationFinished(convo);
end

function NarrativeInterface.SafeDeleteLine(convoId:string, lineNumber:number, lineIdString:string):void
		if (not convoId) then return; end
		local convo = NarrativeInterface.loadedConversations[convoId];
		if(convo == nil) then
			print(convoId, "is a nil conversation");
			return;
		end

		if(convo.lines[lineNumber] ~= nil) then
			if (convo.lines[lineNumber].id ~= lineIdString) then
			    print("Warning!  Double-deleted", lineIdString, "in convo", convoId);
			    print("Don't forget to remove this 'SafeDeleteLine()' call from Lua!");
			end
			
			convo.lines[lineNumber].If = CONVO_DEFAULT_BEHAVIORS.DeletedLineIf;
		end
end



-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SEQUENCE INTERFACE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface.SequenceCheckpoint():void
	game_save_no_timeout();
end

function NarrativeInterface.FastTravelSequenceCleanup():void
	print(">> Narrative Cleanup on Fast Travel/Blink <<");
	NarrativeInterface.Threading.HaltLocalThreads();
end

function NarrativeInterface.ValidateTransientStateTable(sequenceId:string, transientState:table):boolean
	local sequence = NarrativeInterface.loadedSequences[sequenceId];
	if (not sequence) then
		local telemetryString:string = "WARNING: NarrativeInterface.ValidateTransientStateTable() called on a nil sequence!"
		print(telemetryString);
		FireTelemetryEvent("NarrativeTransientStateValidationFailure", { sequenceId = sequenceId, reason = telemetryString });
		return false;
	end

	if (not sequence.requires) then
		return true;	-- If we have no requirements, then any transientState table will be valid, including nil
	end

	if (not transientState) then
		local telemetryString:string = ("WARNING: Sequence " .. sequenceId .. " has required parameters, but was not passed any transientState table!");
		print(telemetryString);
		FireTelemetryEvent("NarrativeTransientStateValidationFailure", { sequenceId = sequenceId, reason = telemetryString });
		return false;
	end

	if (sequence.requires.participants) then
		if (not transientState.participants) then
			local telemetryString:string = ("WARNING: Sequence " .. sequenceId .. " requires participants, but no participants were provided by level logic!");
			print(telemetryString);
			FireTelemetryEvent("NarrativeTransientStateValidationFailure", { sequenceId = sequenceId, reason = telemetryString });
			return false;
		end

		local typeCountList = {};
		for index,obj in ipairs(transientState.participants) do
			local type = ai_get_actor_type( object_get_ai( obj ) );

			typeCountList[type] = (typeCountList[type] and typeCountList[type] + 1) or 1;
		end

		for requiredType,requiredCount in hpairs(sequence.requires.participants) do
			if (not typeCountList[requiredType] or typeCountList[requiredType] < requiredCount) then
				typeCountList[requiredType] = typeCountList[requiredType] or 0;
				local telemetryString:string = imguiVars.getString("WARNING: Sequence", sequenceId, "requires", requiredCount, requiredType, "participants, but was given", (typeCountList[requiredType]), "!");
				print(telemetryString);
				FireTelemetryEvent("NarrativeTransientStateValidationFailure", { sequenceId = sequenceId, reason = telemetryString });
				return false;
			end
		end
	end

	-------------------------------------------------------------
	-- Add new requirement validation behavior above this line --
	-------------------------------------------------------------
	return true;
end

function NarrativeInterface.SequenceIsValid(sequenceName:string):boolean
	return (sequenceName
		and NarrativeInterface.loadedSequences[sequenceName]
		and NarrativeInterface.loadedSequences[sequenceName].sequence	and type(NarrativeInterface.loadedSequences[sequenceName].sequence) == "function"
		and true) or false;
end

function NarrativeInterface.ReplayTimerFnc(sequenceId:string, duration:number, conditionalLambda:ifunction):void
	-- Sleep for the timer duration
	SleepSeconds(duration);
	-- Only continue if we haven't run afoul of our sentinel conditional (if any)
	if (conditionalLambda and not conditionalLambda()) then return; end
	NarrativeInterface.PlayNarrativeSequence(sequenceId);
end

function NarrativeInterface.StartReplayTimer(sequenceId:string, duration:number, conditionalLambda:ifunction):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	NarrativeInterface.CreateNarrativeThread(NarrativeInterface.ReplayTimerFnc, sequenceId, duration, conditionalLambda);
end

function NarrativeInterface.CreateSequence(sequenceName:string, sequenceData:table):void
	if (NarrativeInterface.GameOverStarted) then return; end	-- Narrative Interface locked due to Game Over

	NarrativeInterface.loadedSequences[sequenceName] = sequenceData;
end

function NarrativeInterface.GetSequence(sequenceName:string):table
	return NarrativeInterface.loadedSequences[sequenceName];
end

function NarrativeInterface.TryAndCreateSequence(sequenceName:string, sequenceData:table):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	if (NarrativeInterface.GetSequence(sequenceName)) then
		return false;
	end

	NarrativeInterface.CreateSequence(sequenceName, sequenceData);
	return true;
end

function NarrativeInterface.SequenceTableIsActive(sequence:table):boolean
	if (sequence) then
		return sequence.state == NarrativeInterface.STATE.Starting or sequence.state == NarrativeInterface.STATE.Running or false;
	end

	return nil;
end

-- Check on the "active" state of a specified narrative sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE means the sequence is active.
--    FALSE means the sequence is inactive.
--    NIL means the sequence was not found.
-- ===============================================================================================================================
function NarrativeInterface.SequenceIsActive(sequenceName:string):boolean
	local narseq = NarrativeInterface.loadedSequences[sequenceName];

	if (narseq) then
		return NarrativeInterface.SequenceTableIsActive(narseq);
	else
		print("WARNING: Attempting to check status of sequence '", sequenceName, "'.  Invalid sequence name: No such narrative sequence or named conversation object found.");
	end

	return nil;
end

-- Check if a specified narrative sequence has previously run and completed.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE means the sequence has completed.
--    FALSE means the sequence is active.
--    NIL means the sequence was not found.
-- ===============================================================================================================================
function NarrativeInterface.SequenceIsCompleted(sequenceName:string):boolean
	local narseq = NarrativeInterface.loadedSequences[sequenceName];
	if (narseq) then
		return narseq.state == NarrativeInterface.STATE.Completed;
	elseif (NarrativeInterface.loadedConversations[sequenceName]) then
		return NarrativeInterface.ConversationHasFinished(sequenceName);
	end

	print("WARNING: Attempting to check completion status of sequence '", sequenceName, "'.  Invalid sequence name: No such narrative sequence or named conversation object found.");
	return nil;
end

-- Check if a specified narrative sequence is currently running or has previously run and completed.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the Narrative Sequence to check.
-- ===============================================================================================================================
-- RETURN:
--    TRUE means the sequence is currently active or has completed.
--    FALSE means the sequence is not active and has not completed.
--    NIL means the sequence was not found.
-- ===============================================================================================================================
function NarrativeInterface.SequenceIsActiveOrCompleted(sequenceName:string):boolean
	return NarrativeInterface.SequenceIsActive(sequenceName) or NarrativeInterface.SequenceIsCompleted(sequenceName);
end

function NarrativeInterface.RegisterOnInterruptCallback(sequenceName:string, onInterrupt:ifunction):boolean
	local succeeded = false;

	if (not sequenceName or not onInterrupt) then return false; end

	local narSequence = NarrativeInterface.loadedSequences[sequenceName];
	if (narSequence) then
		-- Ensure OnInterrupt is an object-keyed table
		narSequence.callbacks = narSequence.callbacks or {};
		narSequence.callbacks.OnInterrupt = narSequence.callbacks.OnInterrupt or {};
		if (type(narSequence.callbacks.OnInterrupt) ~= "table") then narSequence.callbacks.OnInterrupt = { [narSequence.callbacks.OnInterrupt] = narSequence.callbacks.OnInterrupt, }; end

		-- Add the new callback
		narSequence.callbacks.OnInterrupt[onInterrupt] = onInterrupt;
		succeeded = true;
	end

	return succeeded;
end

function NarrativeInterface.UnregisterOnInterruptCallback(sequenceName:string, onInterrupt:ifunction):boolean
	local succeeded = false;

	if (not sequenceName or not onInterrupt) then return false; end

	local narSequence = NarrativeInterface.loadedSequences[sequenceName];
	if (narSequence) then
		-- Ensure OnInterrupt is an object-keyed table
		narSequence.callbacks = narSequence.callbacks or {};
		narSequence.callbacks.OnInterrupt = narSequence.callbacks.OnInterrupt or {};
		if (type(narSequence.callbacks.OnInterrupt) ~= "table") then narSequence.callbacks.OnInterrupt = { [narSequence.callbacks.OnInterrupt] = narSequence.callbacks.OnInterrupt, }; end

		succeeded = not not narSequence.callbacks.OnInterrupt[onInterrupt];
		-- Remove the new callback
		narSequence.callbacks.OnInterrupt[onInterrupt] = nil;
	end

	return succeeded;
end

-- This will interrupt a currently-running Narrative Sequence (not intended to be interrupted).  This should only be used when you are certain it's appropriate.
function NarrativeInterface.ForceTerminateSequenceUnsafe(sequenceName:string):void
	-- Ignore calls to terminate non-runnning sequences
	if (not IsThreadValid(NarrativeInterface.Threading.sequenceThreads[sequenceName])) then return; end

	-- Allow script to react to a sequence being interrupted
	local narSequence = NarrativeInterface.loadedSequences[sequenceName];
	if (narSequence and narSequence.callbacks and narSequence.callbacks.OnInterrupt) then
		-- The user can supply a callback, or a table of callbacks.  We'll set this up so we handle it the same either way.
		local interruptCallbacks = (type(narSequence.callbacks.OnInterrupt) == "table" and narSequence.callbacks.OnInterrupt) or {};

		-- A single implementation to run any interrupt callbacks
		for _,interrupt in hpairs(interruptCallbacks) do
			if (type(interrupt) == "function") then
				interrupt(sequenceName);
			end
		end
	end

	-- Terminate child conversations of this sequence
	if (narSequence.playingItems and narSequence.playingItems.conversations) then
		for _,convoName in ipairs(narSequence.playingItems.conversations) do
			if (NarrativeInterface.ConversationIsActive(convoName)) then NarrativeInterface.KillConversation(convoName); end
		end
		narSequence.playingItems.activeThreads = nil;
	end

	-- Terminate the sequence's active thread and allow it's RunSequenceUnique instance to perform cleanup as normal afterward
	KillThread(NarrativeInterface.Threading.sequenceThreads[sequenceName]);

	-- Note: The child threads of this sequence will be terminated and cleaned up as the RunSequenceUnique thread ends
end

-- Run and manage the "active" state of a specified narrative sequence.
-- ===============================================================================================================================
-- 'narrativeSequence':table - Reference to the narrative sequence to play.
-- 'sequenceName':string - String Id of the Narrative Sequence to attempt to play.
-- 'transientState':table - (Optional) Table containing relevant transient values for this Refinery instance.
-- 'compdata':table - (Optional) State table to be passed into any compositions which get started by the specified sequence.
-- 'sleepUntilConvosFinish':boolean - (Optional)
--    TRUE means the sequence should be blocking until the specified conversation completes.
--    FALSE means the conversations in the sequence will be played asynchronously.
-- ===============================================================================================================================
function NarrativeInterface.RunSequenceUnique(narrativeSequence:table, sequenceName:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
	if (narrativeSequence and narrativeSequence.state == NarrativeInterface.STATE.Starting) then
		narrativeSequence.state = NarrativeInterface.STATE.Running;
		AudioMixStates.SetMixState("nseq_" .. sequenceName, "active");

		local debugPanelThreadId = nil;
		if (DebugPanelsEnabled) then
			debugPanelThreadId = CreateThread(
				function()
					while (true) do
						Narrative_DebugPanelStatus("NarSeq");
						SleepSeconds(NarrativeInterface.DEBUG.fastTime);
					end
				end
			);
		end

		if (narrativeSequence.parentMoment ~= nil and narrativeSequence.parentMomentsBeat ~= nil) then
			Narrative_MomentNarrativeSequenceActive(narrativeSequence.parentMoment, narrativeSequence.parentMomentsBeat, sequenceName);
		end

		-- Temporarily assign transient state
		narrativeSequence.transientState = transientState;

		-- Fetch any designated override directives for the settings on our Narrative Sequence (for example, poiDiscovered may allow child sequences to set fields, such as "doNotLockTacMap")
		local sequenceSettingsTable = (narrativeSequence.GetSettingsOverride and narrativeSequence.GetSettingsOverride(sequenceName, transientState, compdata)) or narrativeSequence;

		if (sequenceSettingsTable.callbacks and sequenceSettingsTable.callbacks.OnStart and type(sequenceSettingsTable.callbacks.OnStart) == "function") then
			sequenceSettingsTable.callbacks.OnStart(sequenceName);
		end

		local lockedTacMap = false;
		if (not sequenceSettingsTable.doNotLockTacMap) then
			NarrativeInterface.TacMap.Lock(sequenceName, NarrativeInterface.TYPE.Sequence);
			lockedTacMap = true;
		end

		local disabledAi = false;
		if (sequenceSettingsTable.disableAi) then
			NarrativeInterface.AI.IncrementDisabled(sequenceName, NarrativeInterface.TYPE.Sequence);
			disabledAi = true;
		end

		-- Safe-thread the sequence function execution in case we need to interrupt it mid-way through
		local threadId = CreateThread(narrativeSequence.sequence, sequenceName, transientState, compdata, sleepUntilConvosFinish);
		if (IsThreadValid(threadId)) then
			-- Register our sequence thread
			NarrativeInterface.Threading.sequenceThreads[sequenceName] = threadId;
			-- Block
			SleepUntil([| not IsThreadValid(threadId) ], 1);
			-- Unregister our sequence thread
			NarrativeInterface.Threading.sequenceThreads[sequenceName] = nil;
			-- Clean up any child-threads
			if (narrativeSequence.playingItems and narrativeSequence.playingItems.activeThreads) then
				for _,childThreadId in ipairs(narrativeSequence.playingItems.activeThreads) do
					if (IsThreadValid(childThreadId)) then KillThread(childThreadId); end
				end
				narrativeSequence.playingItems.activeThreads = nil;
			end
		end

		-- Unassign transient state
		narrativeSequence.transientState = nil;

		if (disabledAi) then
			NarrativeInterface.AI.DecrementDisabled(sequenceName, NarrativeInterface.TYPE.Sequence);
		end

		if (lockedTacMap) then
			NarrativeInterface.TacMap.Unlock(sequenceName, NarrativeInterface.TYPE.Sequence);
		end

		if (IsThreadValid(debugPanelThreadId)) then
			KillThread(debugPanelThreadId);
		end

		narrativeSequence.state = NarrativeInterface.STATE.Completed;
		AudioMixStates.SetMixState("nseq_" .. sequenceName, "inactive");

		if (narrativeSequence.parentMoment ~= nil and narrativeSequence.parentMomentsBeat ~= nil) then
			Narrative_MomentNarrativeSequenceCompleted(narrativeSequence.parentMoment, narrativeSequence.parentMomentsBeat, sequenceName);
		end

		narrativeSequence.parentMoment = nil;
		narrativeSequence.parentMomentsBeat = nil;

		-- Run all callbacks registered for end of sequence
		if (sequenceSettingsTable.callbacks and sequenceSettingsTable.callbacks.OnFinish) then
			if (type(sequenceSettingsTable.callbacks.OnFinish) == "function") then
				sequenceSettingsTable.callbacks.OnFinish(sequenceName);
			elseif (type(sequenceSettingsTable.callbacks.OnFinish) == "table") then
				for _,onFinish in hpairs(sequenceSettingsTable.callbacks.OnFinish) do
					if (type(onFinish) == "function") then onFinish(sequenceName); end
				end
			end
		end

		-- Checkpoint if requested
		if (sequenceSettingsTable.checkpointOnFinish) then
			NarrativeInterface.SequenceCheckpoint();
		end
	end
end

-- Attempt to queue a dialog sequence, play a random line in that sequence, and the end the sequence.
-- ===============================================================================================================================
-- 'sequenceName':string - String Id of the Narrative Sequence to attempt to play.
-- 'transientState':table - (Optional) Table containing relevant transient values for this Refinery instance.
-- 'compdata':table - (Optional) State table to be passed into any compositions which get started by the specified sequence.
-- 'sleepUntilConvosFinish':boolean - (Optional)
--    TRUE means the sequence should be blocking until the specified conversation completes.
--    FALSE means the conversations in the sequence will be played asynchronously.
-- ===============================================================================================================================
-- RETURN:
--    TRUE if play was successful.
--    FALSE if otherwise.
-- ===============================================================================================================================
function NarrativeInterface.PlayNarrativeSequence(sequenceName:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	if (not NarrativeInterface.loadedSequences[sequenceName]) then
		NarrativeInterface.UnexpectedWarning("PlayNarrativeSequence(", sequenceName, ") : NO SUCH SEQUENCE EXISTS.");
		return false;
	end

	local narseq = NarrativeInterface.loadedSequences[sequenceName];

	if (narseq) then
		-- if the sequence is a function, spin it up in a new thread
		if (type(narseq.sequence) == "function" and not NarrativeInterface.SequenceIsActive(sequenceName)) then
			narseq.state = NarrativeInterface.STATE.Starting;

			if (narseq.parentMoment ~= nil and narseq.parentMomentsBeat ~= nil) then
				Narrative_MomentNarrativeSequenceStarting(narseq.parentMoment, narseq.parentMomentsBeat, sequenceName);
			end

			-- Validate the transientState table passed into this sequence against its listed requirements
			if (not NarrativeInterface.ValidateTransientStateTable(sequenceName, transientState)) then return false; end

			-- This thread is meant to last, as it will self-clean once its managed child threads are terminated
			CreateThread(NarrativeInterface.RunSequenceUnique, narseq, sequenceName, transientState, compdata, sleepUntilConvosFinish);

			return true;
		end

		--print("WARNING: Attempting to play narrative sequence '", sequenceName, "'.  IT IS ALREADY RUNNING.  Doing nothing.");
	else
		print("WARNING: Attempting to play narrative sequence '", sequenceName, "'.  Invalid narrative sequence name: No such narrative sequence or named conversation object found.");
	end

	return false;
end

function NarrativeInterface.SleepUntilFinishedPlayNarrativeSequence(sequenceName:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayNarrativeSequence(sequenceName, transientState, compdata, sleepUntilConvosFinish);
end

function NarrativeInterface.PlayNarrativeSequenceFromMoment(sequenceName:string, parentMoment:narrative_moment, parentMomentsBeat: string_id, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	local narseq = NarrativeInterface.loadedSequences[sequenceName];
	if (narseq) then
		narseq.parentMoment = parentMoment;
		narseq.parentMomentsBeat = parentMomentsBeat;
	end

	return NarrativeInterface.PlayNarrativeSequence(sequenceName, transientState, compdata, sleepUntilConvosFinish);
end

function NarrativeInterface.SleepUntilFinishedPlayNarrativeSequenceFromMoment(sequenceName:string, parentMoment:narrative_moment, transientState:table, compdata:table, sleepUntilConvosFinish:boolean, sleepPeriod:number):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	return NarrativeInterface.SleepUntil(sleepPeriod or 1).PlayNarrativeSequenceFromMoment(sequenceName, parentMoment, transientState, compdata, sleepUntilConvosFinish);
end

-- Attempt to play a dialog sequence.  Returns TRUE if play was successful, otherwise returns FALSE.
-- Default behavior if a collision is detected with another playing dialog sequence is to simply queue the new sequence and play it once it is no longer blocked.
-- NOTE - jacrowde 2019 - This function is a functional stub-in for future method
function NarrativeInterface.PlayDialogSequence(sequenceName:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):boolean
	if (NarrativeInterface.GameOverStarted) then return false; end	-- Narrative Interface locked due to Game Over

	print("!! DEPRECATED CALL !! - NarrativeInterface : PlayDialogSequence() is deprecated!  Please use PlayNarrativeSequence().");
	return NarrativeInterface.PlayNarrativeSequence(sequenceName, transientState, compdata, sleepUntilConvosFinish);
end



-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: SYNTACTICAL SUGAR :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

function NarrativeInterface.NarrativeTableIsActive(narrativeTable:table):boolean
	if (not narrativeTable) then return nil; end	-- Bad call
	if (not narrativeTable._type) then
		NarrativeInterface.UnexpectedWarning("NarrativeTableIsActive :: Provided table instance is not a registered narrative table instance!");
		return nil;	-- Bad call
	end

	if (narrativeTable._type == NarrativeInterface.TYPE.Conversation) then
		return NarrativeInterface.ConversationTableIsActive(narrativeTable);	-- Is Conversation active?
	elseif (narrativeTable._type == NarrativeInterface.TYPE.Sequence) then
		return NarrativeInterface.SequenceTableIsActive(narrativeTable);		-- Is Sequence active?
	else
		NarrativeInterface.UnexpectedWarning("NarrativeTableIsActive :: Provided table instance has an invalid narrative table type value!");
		return nil;	-- Bad data
	end
end

-- EXAMPLE : NarrativeInterface.SleepUntil.PlayNarrativeSequence("name", transientState, compdata, sleepUntilConvosFinish);
-- EXAMPLE : NarrativeInterface.SleepUntil(7).PlayNarrativeSequence("name", transientState, compdata, sleepUntilConvosFinish);

NarrativeInterface.SleepUntil = setmetatable({}, {
	_EMPTY_FUNCTION = function() print("WARNING ** THIS IS AN EMPTY FUNCTION"); end,
	_SLEEP_UNTIL = function (key)
		return setmetatable({ key = key, }, {
			__call = function(myTable, ...)
				local self = getmetatable(myTable);

				if (not NarrativeInterface[myTable.key]) then
					print("ERROR ** Key:", myTable.key, "was not found in NarrativeInterface.  Returning empty function.");
					return self._EMPTY_FUNCTION;
				end

				local name = arg[1];
				local returnValues = { NarrativeInterface[myTable.key](unpack(arg)), };
				local keyFound = nil;

				if (type(myTable.key) == "string") then
					if (myTable.key:match("^PlayNarrativeSequence")) then
						if (NarrativeInterface.SequenceIsValid(name)) then
							-- Need to check "is completed" right away, in case we're in a weird circumstance that had the sequence finish before this check (avoids infinite waiting bug)
							SleepUntil([| NarrativeInterface.SequenceIsActiveOrCompleted(name)], 1);
							-- Still need to check "is completed" explicitly, in case the previous call passed by being active
							SleepUntil([| NarrativeInterface.SequenceIsCompleted(name) ], self.interval or 1);
						else
							print("WARNING ** No valid sequence with name", name, "exists.  Ignoring request to sleep.");
						end
						keyFound = true;
					elseif (myTable.key:match("^PlayConversation")) then
						if (NarrativeInterface.ConversationIsValid(name)) then
							SleepSeconds(1);
							SleepUntil([| NarrativeInterface.ConversationHasFinished(name) ], self.interval or 1);
						else
							print("WARNING ** No valid conversation with name", name, "exists.  Ignoring request to sleep.");
						end
						keyFound = true;
					end
				end

				if (not keyFound) then
					print("WARNING ** No automatic SleepUntil behavior defined for NarrativeInterface." .. key);
				end

				return unpack(returnValues);
			end,

			__index = function(myTable, key)
				error("Attempted to index into a function!");
			end,

			__newindex = function(myTable, key, value)
				error("Attempted to assign an index value to a function!");
			end,
		});
	end,

	__index = function(myTable, key)
		local self = getmetatable(myTable);

		if (not NarrativeInterface[key]) then
			print("ERROR ** Key:", key, "was not found in NarrativeInterface.  Returning empty function.");
			return self._EMPTY_FUNCTION;
		end

		return self._SLEEP_UNTIL(key);
	end,

	__newindex = function(myTable, key, value)
		error("Attempted to write to a read-only table!");
	end,

	__call = function(myTable, interval)
		local self = getmetatable(myTable);
		return setmetatable( {},
		{
			interval = interval,
			_SLEEP_UNTIL = self._SLEEP_UNTIL,
			__index = self.__index,
			__newindex = self.__newindex,
		});
	end,
});



-- EXAMPLE : NarrativeInterface.OnFinish(myFunction).PlayNarrativeSequence("name", transientState, compdata, sleepUntilConvosFinish);

function NarrativeInterface.OnFinish(onFinish:ifunction, runImmediatelyOnFailure:boolean):table
	return setmetatable({},
	{
		onFinish = onFinish,
		_EMPTY_FUNCTION = function() print("WARNING ** THIS IS AN EMPTY FUNCTION"); end,
		_ON_FINISH = function (key, onFinish)
			return setmetatable({ key = key, }, {
				onFinish = onFinish,
				__call = function(myTable, ...)
					local self = getmetatable(myTable);

					if (not NarrativeInterface[myTable.key]) then
						print("ERROR ** Key:", myTable.key, "was not found in NarrativeInterface.  Returning empty function.");
						return self._EMPTY_FUNCTION;
					end

					local name = arg[1];
					local returnValues = { NarrativeInterface[myTable.key](unpack(arg)), };
					local keyFound = nil;
					local succeeded = false;

					if (type(myTable.key) == "string") then
						if (myTable.key:match("^PlayNarrativeSequence")) then
							succeeded = NarrativeInterface.RegisterOnFinish(name, onFinish);
							keyFound = true;
						elseif (myTable.key:match("^PlayConversation")) then
							local convo = NarrativeInterface.loadedConversations[name];
							if (convo) then
								convo.OnFinish = self.onFinish;
								succeeded = true;
							end
							keyFound = true;
						end
					end

					if (runImmediatelyOnFailure and not succeeded) then
						self.onFinish(name);
					end

					if (not keyFound) then
						print("WARNING ** No automatic OnFinish behavior defined for NarrativeInterface." .. key);
					end

					return unpack(returnValues);
				end,
			});
		end,

		__index = function(myTable, key)
			local self = getmetatable(myTable);

			if (not NarrativeInterface[key]) then
				print("ERROR ** Key:", key, "was not found in NarrativeInterface.  Returning empty function.");
				return self._EMPTY_FUNCTION;
			end

			return self._ON_FINISH(key, self.onFinish);
		end,

		__newindex = function(myTable, key, value)
			error("Attempted to write to a read-only table!");
		end,
	});
end


function NarrativeInterface.RegisterOnFinish(sequenceId:string, onFinish:ifunction):boolean
	local narseq = NarrativeInterface.loadedSequences[sequenceId];

	if (narseq) then
		narseq.callbacks = narseq.callbacks or {};
		narseq.callbacks.OnFinish = narseq.callbacks.OnFinish or {};
		narseq.callbacks.OnFinish[onFinish] = onFinish;
		return true;
	else
		print("WARNING: RegisterOnFinish - No such Narrative Sequence named", sequenceId);
		return false;
	end
end

function NarrativeInterface.UnregisterOnFinish(sequenceId:string, onFinish:ifunction):void
	local narseq = NarrativeInterface.loadedSequences[sequenceId];

	if (narseq) then
		if (narseq.callbacks) then
			if (narseq.callbacks.OnFinish) then
				if (type(narseq.callbacks.OnFinish) == "table") then
					narseq.callbacks.OnFinish[onFinish] = nil;
				else
					print("WARNING: UnregisterOnFinish - Narrative Sequence", sequenceId, "has a unique OnFinish member which cannot be unregistered - DOING NOTHING.");
				end
			else
				print("WARNING: UnregisterOnFinish - Narrative Sequence", sequenceId, "has no OnFinish callbacks registered - DOING NOTHING.");
			end
		else
			print("WARNING: UnregisterOnFinish - Narrative Sequence", sequenceId, "has no callbacks of any kind - DOING NOTHING.");
		end
	else
		print("WARNING: UnregisterOnFinish - No such Narrative Sequence named", sequenceId, "- DOING NOTHING.");
	end
end





function NarrativeInterface.ShowPip0()
	AudioInterface.OpenLocalPip();
	RunClientScript("ClientSetPipIsVisible", 0, true);
end

function NarrativeInterface.HidePip0()
	AudioInterface.CloseLocalPip();
	RunClientScript("ClientSetPipIsVisible", 0, false);
end

function NarrativeInterface.ShowPip1()
	AudioInterface.OpenCommsPip();
	RunClientScript("ClientSetPipIsVisible", 1, true);
end

function NarrativeInterface.HidePip1()
	AudioInterface.CloseCommsPip();
	RunClientScript("ClientSetPipIsVisible", 1, false);
end

function NarrativeInterface.ShowAllPips()
	NarrativeInterface.ShowPip0();
	NarrativeInterface.ShowPip1();
end

function NarrativeInterface.HideAllPips()
	NarrativeInterface.HidePip0();
	NarrativeInterface.HidePip1();
end

function NarrativeInterface.SendClientHuiEvent(eventName:string)

	RunClientScript("ClientNarrativeSendHuiEvent", eventName);
end

--[[
 _______   _______ .______    __    __    _______
|       \ |   ____||   _  \  |  |  |  |  /  _____|
|  .--.  ||  |__   |  |_)  | |  |  |  | |  |  __
|  |  |  ||   __|  |   _  <  |  |  |  | |  | |_ |
|  '--'  ||  |____ |  |_)  | |  `--'  | |  |__| |
|_______/ |_______||______/   \______/   \______|

--]]

global g_NarrativeDebuggerShown = false;
global g_NarrativeDebuggerVars = {};

function DebugNarrative()
	if g_NarrativeDebuggerShown == true then
		ImGui_DeactivateCallback("sys_ShowNarrativeDebugger");
		g_NarrativeDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_ShowNarrativeDebugger");
		g_NarrativeDebuggerShown = true;
	end
end

function sys_ShowNarrativeDebugger()
	if ImGui_Begin("Narrative Debugger") == true then
		imguiVars.standardButton("  Close Narrative Debugger  ", DebugNarrative);

		--conversations
		imguiVars.multiText("CONVERSATIONS:");
		ImGui_Indent();
		sys_NarrativeShowConvoType("Pending Conversations", NarrativeQueue.instance.pendingConversations);
		sys_NarrativeShowConvoType("Playing Conversations", NarrativeQueue.instance.playingConversations);
		sys_NarrativeShowConvoType("Delayed Conversations", NarrativeQueue.instance.delayedConversations);
		sys_NarrativeShowCompletedConversations();

		ImGui_Text("");
		imguiVars.standardHeader("All Loaded Conversations", function()
			ImGui_PushStringID("loaded conversations");
			for _, convo in NarrativeInterface.loadedConversations.__hpairs() do
				imguiVars.standardHeader(convo.name, sys_NarrativeShowConvo, convo);
			end
			ImGui_PopID();
		end);
		ImGui_Text("");
		ImGui_Unindent();

		--sequences
		imguiVars.multiText("SEQUENCES:");
		ImGui_Indent();
		sys_NarrativeSequenceShow("Starting Sequences", 1);
		sys_NarrativeSequenceShow("Running Sequences", 2);
		sys_NarrativeDebugButton();

		imguiVars.standardHeader("Completed Sequences", sys_NarrativeSequenceShow, "Completed Sequences", 3);

		ImGui_Text("");

		imguiVars.standardHeader("All Loaded Sequences", sys_NarrativeSequenceShow, "All Loaded Sequences");
		ImGui_Text("");

		--suppression
		imguiVars.standardHeader("Tac Map Suppressed:", function()
			ImGui_Text("Stack 1");
			sys_NarrativeShowSuppression(NarrativeInterface.TacMap.SuppressionStack[1]);
			ImGui_Text("Stack 2");
			sys_NarrativeShowSuppression(NarrativeInterface.TacMap.SuppressionStack[2]);
		end);

		imguiVars.standardHeader("AI Suppressed:", function()
			ImGui_Text("Stack 1");
			sys_NarrativeShowSuppression(NarrativeInterface.AI.SuppressionStack[1]);
			ImGui_Text("Stack 2");
			sys_NarrativeShowSuppression(NarrativeInterface.AI.SuppressionStack[2]);
		end);
		ImGui_Unindent();
	end
	ImGui_End();
end

function sys_NarrativeShowConvoType(type:string, convoTypeTable:table)
	imguiVars.multiText(type);
	ImGui_Indent();
	for _, convo in ipairs(convoTypeTable) do
		imguiVars.standardHeader(convo.name, sys_NarrativeShowConvo, convo, convoTypeTable);
	end
	ImGui_Unindent();
end

function sys_NarrativeShowConvo(convo:table, convoTypeTable:table, completedData:table)
	ImGui_PushStringID(tostring(convo));
	local name:string = convo.name;
	imguiVars.standardTwoItemInfo("name", convo.name);
	sys_NarrativeGetPriority(convo);
	imguiVars.standardTwoItemInfo("Show Tag", convo.show);
	if convo.MaxPlayingTime ~= nil then
		imguiVars.standardTwoItemInfo("Max Playing Time", convo.MaxPlayingTime());
	end
	if convo.Timeout ~= nil then
		imguiVars.standardTwoItemInfo("TimeOut", convo.Timeout());
	end

	if convoTypeTable == NarrativeQueue.instance.playingConversations then
		if g_NarrativeDebuggerVars[name] == nil then
			g_NarrativeDebuggerVars[name] = {};
			g_NarrativeDebuggerVars[name].startTime =  Game_TimeGet();
		end
		local newTime:time_point = Game_TimeGet();
		g_NarrativeDebuggerVars[name].runningTime = newTime:ElapsedTime(g_NarrativeDebuggerVars[name].startTime);
	end
	if g_NarrativeDebuggerVars[name] ~= nil then
		imguiVars.standardTwoItemInfo("Run Time:", g_NarrativeDebuggerVars[name].runningTime);
	else
		imguiVars.standardTwoItemInfo("Run Time:", "Not Run Yet");
	end
	if completedData ~= nil then
		imguiVars.standardTwoItemInfo("interrupted:", completedData.interrupted);
		imguiVars.standardTwoItemInfo("completed:", completedData.completed);
	end

	imguiVars.standardHeader("Lines", sys_DebugTable, convo.lines);

	--ImGui_PushStringID(tostring(squad));
	imguiVars.standardHeader("More Info", sys_DebugTable, convo);
	ImGui_PopID();
end

function sys_NarrativeShowCompletedConversations()
	imguiVars.standardHeader("Completed Conversations", function()
		ImGui_Indent();
		for key, value in hpairs(registeredConversationsData) do
			if type(key) == "table" then
				local name:string = key.name;
				if name ~= nil and registeredConversationsData[name] ~= nil then
					imguiVars.standardHeader(name, sys_NarrativeShowConvo, key, nil, registeredConversationsData[name]);
				end
			end
		end
		ImGui_Unindent();
	end);
end

function sys_NarrativeSequenceShow(text:string, state:number)
	ImGui_PushStringID(text..tostring(state));
	ImGui_Text(text);
	ImGui_Indent();
	for name, sequence in NarrativeInterface.loadedSequences.__hpairs() do
		if sequence.state == state or state == nil then
			imguiVars.standardHeader(name, sys_DebugTable, sequence, NarrativeInterface.STATE);

			if state == 2 then
				if g_NarrativeDebuggerVars[name] == nil then
					g_NarrativeDebuggerVars[name] = {};
					g_NarrativeDebuggerVars[name].startTime = Game_TimeGet();
				end
				local newTime:time_point = Game_TimeGet();
				g_NarrativeDebuggerVars[name].runningTime = newTime:ElapsedTime(g_NarrativeDebuggerVars[name].startTime);
			end
			if g_NarrativeDebuggerVars[name] ~= nil then
				imguiVars.standardTwoItemInfo("Run Time:", g_NarrativeDebuggerVars[name].runningTime);
			else
				imguiVars.standardTwoItemInfo("Run Time:", "Not Run Yet");
			end
			--add buttons here
		end
	end
	if state == nil then
		imguiVars.standardHeader("All Info for loaded sequences:", sys_DebugTable, NarrativeInterface.loadedSequences);
	end
	ImGui_Unindent();
	ImGui_PopID();
end

function sys_NarrativeShowSuppression(suppressionTable)
	ImGui_Indent();
	for name, count in hpairs(suppressionTable) do
		imguiVars.standardTwoItemInfo(name, count > 0 and "LOCKED +"..count or "-UNLOCKED-");
	end
	ImGui_Unindent();
end

function sys_NarrativeGetPriority(convo:table)
	if convo.Priority ~= nil then
		local priority = convo.Priority();
		local priorityString:string = nil;
		for key, value in hpairs(CONVO_PRIORITY) do
			if value == priority and key ~= "_count" then
				priorityString = key;
				break;
			end
		end
		imguiVars.standardTwoItemInfo("Priority", priorityString);
	end
end

function sys_NarrativeDebugButton()
	imguiVars.standardButton("SKIP CURRENT COMPOSITION", [| composer_debug_cinematic_skip()]);
end

NarrativeInterface.DEBUG.StartDebugPanelsThread();

--## CLIENT

global NarrativeInterface = {
	PipViewNames = {
		[0] = "pip0",
		[1] = "pip1",
	},
};

function remoteClient.ClientSetPipIsVisible(pipId:number, isVisible:boolean):void
	if (not pipId or not NarrativeInterface.PipViewNames[pipId]) then
		return;
	end

	narrative_view_set_is_visible(NarrativeInterface.PipViewNames[pipId], (not (not isVisible)));
end

function remoteClient.ClientNarrativeSendHuiEvent(eventName:string):void
	SendHuiEvent(eventName);
end
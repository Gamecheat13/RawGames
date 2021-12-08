
REQUIRES('globals\scripts\global_dialog_tags.lua');
REQUIRES('globals\scripts\global_dialog_helpers.lua');

--## SERVER


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::: Low-Level Convo Initialization and Management (Save file size fixes for Narrative Queue) ::::::::::::::::::::::::::::
-- =================================================================================================================================================

global registeredConversationsData = {};

-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
global debugLinePlayRecord = {};
global debugKeepARecordOfPlayedLines = false;
global debugConvoNilCheckState = {};
global debugConvoNilCheckStates = {
	REGISTERED = "REGISTERED",
	RE_REGISTERED = "RE-REGISTERED",
	COMPLETED = "COMPLETED",
};
-- DEBUG CODE ONLY - v-jamcro

global conversationMetatable = {
	GetShowId = function(t)
		if (t and NarrativeQueuePrivates.ConvoHasPrivateData(t)) then
			return t.privateData.showId;
		end

		return nil;
	end,
	__index = function(t,k)
		local convoEntry = registeredConversationsData[t];
		if (not convoEntry) then
			error("ERROR : attempting to index unregistered conversation", 2);
		end

		if (k == "privateData" and not convoEntry[k]) then
			local convoState:string = (debugConvoNilCheckState[t] or "UNREGISTERED");

			error("ERROR : attempting to get privateData in " .. convoState .. " conversation " .. (t.name or "<NAME WAS NIL>") .. " (nil)", 2);
		elseif (k == "GetShowId") then
			return getmetatable(t).GetShowId;
		end

		return convoEntry[k];
	end,

	__newindex = function(t,k,v)
		local convoEntry = registeredConversationsData[t];
		if (not convoEntry) then
			error("ERROR : attempting to index unregistered conversation", 2);
		end

		if (k == "privateData" or k == "localVariables") then
			if (k == "privateData" and convoEntry[k]) then
				error("ERROR : attempting to set privateData on conversation " .. (t.name or "<NAME WAS NIL>") .. " when it already exists!", 2);
			end

			convoEntry[k] = v;
		elseif (k == "GetShowId") then
			error("ERROR : attempmting to assign value to reserved conversation property 'GetShowId'!", 2);
		else
			rawset(t,k,v);
		end
	end,
};

global conversationLineMetatable = {
	__index = function(t,k)
		if (k == "privateData") then
			return registeredConversationsData[t];
		elseif (k == "moniker") then	-- Hack for at-runtime assigned monikers
			return (registeredConversationsData[t] and registeredConversationsData[t].moniker);
		else
			return nil;
		end
	end,

	__newindex = function(t,k,v)
		if (k == "privateData") then
			if (registeredConversationsData[t]) then
				--if (nil == v) then
				--	print("WARNING : privateData for line " .. registeredConversationsData[t].lineId .. " in conversation " .. t.name .. " is being erased!");
				--else
					error("ERROR : attempting to set privateData on line " .. (registeredConversationsData[t].lineId or "<LINE ID WAS NIL>") .. " in conversation " .. (t.name or "<NAME WAS NIL>") .. " when it already exists!", 2);
				--end
			end

			registeredConversationsData[t] = v;

			-- DEBUG CODE ONLY - v-jamcro
			-- NOT_QUITE_RELEASE
			if (debugKeepARecordOfPlayedLines) then
				debugLinePlayRecord[t] = debugLinePlayRecord[t] or {};
			end
			-- DEBUG CODE ONLY - v-jamcro
		elseif (k == "moniker" and NarrativeQueuePrivates.ConvoHasPrivateData(t)) then	-- Hack for at-runtime assigned monikers
			t.privateData.moniker = v;
		else
			rawset(t,k,v);
		end
	end,
};

global NarrativeQueuePrivates = {};

-- Returns TRUE if table is Convo AND Convo is constant ; Returns FALSE if not Convo, or Convo should be saved
function NarrativeQueuePrivates.InitializeTableAsConstantConvo(candidate:table):void
	local candidateName = rawget(candidate, "name");
	local candidateLines = rawget(candidate, "lines");

	-- Temp fix - legacy support for Gamma-generated Priority fields
	if (not rawget(candidate, "SceneType")) then rawset(candidate, "SceneType", rawget(candidate, "Priority")); end

	if (candidateName and candidateLines and (rawget(candidate, "tag") or rawget(candidate, "SceneType"))) then
		local previouslyRegistered:boolean = (registeredConversationsData[candidate] and true) or false;

		-- Check if already there (error)
		if (registeredConversationsData[candidateName] == true) then
			error("ERROR : multiple conversations with identical name: " .. candidateName, 1);
		end

		-- Register candiate.name in same bank
		registeredConversationsData[candidateName] = nil;

		if (not previouslyRegistered) then
			-- Register candidate in global bank of convos (by ref)
			registeredConversationsData[candidate] = {};

			-- Transplant localVariables
			registeredConversationsData[candidate].localVariables = candidate.localVariables;
			candidate.localVariables = nil;
			candidate.privateData = nil;

			-- Assign metatable to reference transplanted localVariables
			setmetatable(candidate, conversationMetatable);
			debugConvoNilCheckState[candidate] = debugConvoNilCheckStates.REGISTERED;
		end

		-- Do the same for all lines in candidate
		for lineId, line in hpairs(candidateLines) do
			line.privateData = nil;
			setmetatable(line, conversationLineMetatable);
		end
	end
end

function NarrativeQueuePrivates.LateRegisterTableAsConvo(candidate:table):void
	if (not registeredConversationsData[candidate]) then
		NarrativeQueuePrivates.InitializeTableAsConstantConvo(candidate);
	else
		-- Register candiate.name in same bank, as = true if not procedural
		local candidateName = rawget(candidate, "name");
		registeredConversationsData[candidateName] = nil;

		-- Re-register all lines (lines table could have been altered by user)
		local candidateLines = candidate.lines;
		for lineId, line in hpairs(candidateLines) do
			registeredConversationsData[line] = nil;
			setmetatable(line, conversationLineMetatable);
			debugConvoNilCheckState[candidate] = debugConvoNilCheckStates.RE_REGISTERED;
		end
	end
end

function NarrativeQueuePrivates.UnregisterLine(line:table):void
	registeredConversationsData[line] = nil;
end

function NarrativeQueuePrivates.UnregisterConvo(conversation:table):void
	if (registeredConversationsData[conversation]) then
		for lineId, line in hpairs(conversation.lines) do
			NarrativeQueuePrivates.UnregisterLine(line);
		end

		registeredConversationsData[conversation].privateData = nil;
		debugConvoNilCheckState[conversation] = debugConvoNilCheckStates.COMPLETED;
	end
end

function NarrativeQueuePrivates.MarkConvoAsCompleted(conversation:table):void
	registeredConversationsData[conversation.name] = {
		completed = true,
		interrupted = conversation.privateData.interrupted,
	};

	NarrativeQueuePrivates.UnregisterConvo(conversation);
end

function NarrativeQueuePrivates.ConvoHasCompleted(conversation:table):boolean
	return (conversation and type(registeredConversationsData[conversation.name]) == "table" and registeredConversationsData[conversation.name].completed);
end

function NarrativeQueuePrivates.ConvoHasPrivateData(conversation:table):boolean
	return (conversation and registeredConversationsData[conversation] and registeredConversationsData[conversation].privateData and true) or false;
end

function NarrativeQueuePrivates.ResetConvoHasCompleted(conversation:table):void
	if (NarrativeQueuePrivates.ConvoHasCompleted(conversation)) then
		registeredConversationsData[conversation.name].completed = false;
	end
end

-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
function DebugPrintConversationPlayRecord(conversation:table):void
	print(conversation.name .. " played - ");

	for i = 1, #conversation.lines do
		local str = "[" .. i .. "] : ";

		for _, time in hpairs(debugLinePlayRecord[conversation.lines[i]]) do
			str = str .. time .. ", ";
		end

		print(str);
	end
end
-- DEBUG CODE ONLY - v-jamcro



-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Queue Private Functionality :::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

-- NarrativeQueueInstance Management
---------------------------------------------------------------------------

global NarrativeQueueInstance:table = {

	-- Data
	isActive = false,
	allowResume = false,
	updateFrequency = 1,
	interruptOverlapDurationSeconds = 0.75,

	-- Static Values
	NoCharacterValue = -1,

	-- Queues
	pendingConversations = {},
	delayedConversations = {},
	playingConversations = {},
	interruptedLines = {},

	-- Threading
	threadLocked = false,
	threadPaused = 0,
	pauseUpdateFrequency = 1,
	timeSpentPaused = 0,
	updateIsRunning = false,
	currentRunningId = -1,

	-- Debug
	showPrintMessages = false,
	callbacksInSeparateThreads = true,
	preventConversations = false,
	playFullCompositions = false,
};

-- Methods
function NarrativeQueueInstance:Initialize():void
	if (not self.isActive) then
		self:Kill();

		self.isActive = true;

		self.pendingConversations = {};
		self.delayedConversations = {};
		self.playingConversations = {};
	else
		error("ERROR : NarrativeQueueInstance was already initialized and is running.");
	end
end

function NarrativeQueueInstance:Kill():void
	self.isActive = false;
	self.currentRunningId = self.currentRunningId + 1;	-- Invalidate the current running id, in case someone reactivates the queue later this same update

	self:StopAllConversations(self.pendingConversations);
	self.pendingConversations = {};

	self:StopAllConversations();
	self.playingConversations = {};

	self:StopAllConversations(self.delayedConversations);
	self.delayedConversations = {};

	local allInterruptedLines:table = {};
	for key, _ in hpairs(self.interruptedLines) do
		allInterruptedLines[key] = true;
	end
	self:SilenceAllInterruptedLines(allInterruptedLines);
end

function NarrativeQueueInstance:IsThreadLocked():boolean	-- Returns TRUE if thread is locked, FALSE if unlocked
	return self.threadLocked;
end

function NarrativeQueueInstance:IsThreadPaused():boolean	-- Returns TRUE if thread is paused, FALSE if unpaused
	if (self.threadPaused > 0) then
		self.timeSpentPaused = self.timeSpentPaused + self.pauseUpdateFrequency;
	end

	return self.threadPaused > 0;
end


-- Conversation Interface Bindings - General
---------------------------------------------------------------------------

function NarrativeQueueInstance:QueueConversation(conversation:table):void
	self:AsyncThreadSafeQueueConversation(conversation);
end

--[[function NarrativeQueueInstance:ResumeConversation(conversation):void
	self:AsyncThreadSafeResumeConversation(conversation);
end
--]]

function NarrativeQueueInstance:EndConversationEarly(conversation:table):void
	if (self.isActive) then
		self:AsyncThreadSafeEndConversationEarly(conversation);
	end
end

function NarrativeQueueInstance:InterruptConversation(conversation:table, interruptOverlapDurationSeconds:number):void
	if (self.isActive) then
		self:AsyncThreadSafeInterruptConversation(conversation, interruptOverlapDurationSeconds);
	end
end

function NarrativeQueueInstance:KillConversation(conversation:table):void
	if (self.isActive) then
		self:AsyncThreadSafeKillConversation(conversation);
	end
end

function NarrativeQueueInstance:KillAllConversationsOfType(sceneType):void
	if (self.isActive) then
		self:AsyncThreadSafeKillAllConversationsOfType(sceneType);
	end
end

function NarrativeQueueInstance:HaltLineOnEmitter(line:table, emitter:any):void
	local chars = line.privateData.characterPlayed;
	local emitterFound = false;
	if (type(chars) == "table") then
		for _,char in hpairs(chars) do
			if (char == emitter) then
				emitterFound = true;
				break;
			end
		end
	else
		emitterFound = (chars == emitter);
	end

	if (emitterFound) then
		StopDialogOnSpecificClients(line.tag, emitter, nil);
	end
end

function NarrativeQueueInstance:HaltAllLinesOnEmitter(conversation:table, emitter:any):void
	if (not self.isActive) then return; end

	if (conversation and NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		if (conversation.privateData.EVENT_BASED and conversation.privateData.EVENT_BASED.currentLines) then
			-- Apply for each active line
			for lineId, line in hpairs(conversation.privateData.EVENT_BASED.currentLines) do
				self:HaltLineOnEmitter(line, emitter);
			end
		elseif (conversation.privateData.TIME_BASED and conversation.privateData.TIME_BASED.currentLine) then
			-- Apply for the active line
			self:HaltLineOnEmitter(conversation.privateData.TIME_BASED.currentLine, emitter);
		end
	end
end


-- Conversation Interface Bindings - Event-Based
---------------------------------------------------------------------------

function NarrativeQueueInstance:PlayEventBasedLine(conversation:table, lineId:string):void
	if (self.isActive) then
		if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation) and conversation.privateData.EVENT_BASED) then
			lineId = (lineId:match("^001_vo_scr_") and string.sub(lineId, 12)) or lineId;
			if (conversation.lines[lineId]) then
				table.insert(conversation.privateData.EVENT_BASED.readyLines, conversation.lines[lineId]);
			else
				print("WARNING :: Invalid 'lineId' - Attempted to play event-based line '" .. lineId .. "' in conversation '" .. conversation.name .. "'.");
			end
		else
			print("WARNING :: Unexpected 'PlayEventBasedLine()' call - Attempted to play event-based line '" .. lineId .. "' while conversation '" .. conversation.name .. "' was not active, or was not expecting play line events.");
		end
	else
		error("Uninitialized Narrative Queue - Attempted to play event-based line '" .. lineId .. "' in conversation '" .. conversation.name .. "' while Narrative Queue was not initialized.");
	end
end

function NarrativeQueueInstance:EndEventBasedConversation(conversation:table):void
	if (self.isActive) then
		if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation) and conversation.privateData.EVENT_BASED) then
			conversation.privateData.EVENT_BASED.ending = true;
		else
			print("WARNING :: Unexpected 'EndEventBasedConversation()' call - Attempted to mark conversation as 'ending' while conversation '" .. conversation.name .. "' was not active, or was not expecting events.");
		end
	else
		error("Uninitialized Narrative Queue - Attempted to mark conversation '" .. conversation.name .. "' as 'ending' while Narrative Queue was not initialized.");
	end
end


-- Conversation Interface Bindings - Asynchronous/Internal
---------------------------------------------------------------------------

function NarrativeQueueInstance:AsyncThreadSafeQueueConversation(conversation:table):void
	self:InitializeConversation(conversation);
	print(conversation.name, ": 0 -> PENDING");
	self:Push(conversation, self.pendingConversations);
end

--[[function NarrativeQueueInstance:AsyncThreadSafeResumeConversation(conversation:table):void	-- BONUS TODO
	SleepUntil ([| not self:IsThreadLocked() ], 1);
	self.threadPaused = self.threadPaused + 1;

	-- BONUS TODO : Resume interrupted conversation

	self.threadPaused = self.threadPaused - 1;
end
--]]

function NarrativeQueueInstance:AsyncThreadSafeEndConversationEarly(conversation:table):void
	if (conversation and NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		conversation.privateData.endEarly = true;
	end
end

function NarrativeQueueInstance:AsyncThreadSafeInterruptConversation(conversation:table, interruptOverlapDurationSeconds:number):void
	if (conversation and NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		conversation.privateData.interrupted = interruptOverlapDurationSeconds or true;
	end
end

function NarrativeQueueInstance:AsyncThreadSafeKillAllConversationsOfType(sceneType):void
	local queues = {
		self.pendingConversations,
		self.playingConversations,
		self.delayedConversations,
	};
	local currentQueueIndex = 1;

	while (queues[currentQueueIndex]) do
		for _,convo in hpairs(queues[currentQueueIndex]) do
			if (convo.privateData.sceneType == sceneType) then
				self:AsyncThreadSafeKillConversation(convo);
			end
		end

		currentQueueIndex = currentQueueIndex + 1;
	end
end

function NarrativeQueueInstance:AsyncThreadSafeKillConversation(conversation:table):void
	if (not NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
		print("WARNING :: Attempted to KillConversation() on a convo that is not currently running [convo.name: '", conversation.name, "']");
		return;
	end

	local isPending:number = 1;
	local isPlaying:number = 2;
	local isDelayed:number = 3;

	local queueIndex:number = 0;

	-- Check Pending
	for _,convo in hpairs(self.pendingConversations) do
		if (convo == conversation) then
			queueIndex = isPending;
			break;
		end
	end

	-- Check Playing
	if (queueIndex == 0) then
		for _,convo in hpairs(self.playingConversations) do
			if (convo == conversation) then
				queueIndex = isPlaying;
				break;
			end
		end
	end

	-- Check Delayed
	if (queueIndex == 0) then
		for _,convo in hpairs(self.delayedConversations) do
			if (convo == conversation) then
				queueIndex = isDelayed;
				break;
			end
		end
	end

	if (queueIndex == isPending) then
		print(conversation.name, ": PENDING -> CANCELLED");
		self:Pop(conversation, self.pendingConversations);
		NarrativeQueuePrivates.MarkConvoAsCompleted(conversation);
	elseif (queueIndex == isPlaying) then
		print(conversation.name, ": PLAYING -> CANCELLED");
		self:HaltAllLines(conversation);
		self:FinishConversation(conversation);
	elseif (queueIndex == isDelayed) then
		print(conversation.name, ": INTERRUPTED -> CANCELLED");
		self:Pop(conversation, self.delayedConversations);
		NarrativeQueuePrivates.MarkConvoAsCompleted(conversation);
	else
		print("WARNING :: Attempted to KillConversation() on a convo that is not currently in any queue [convo.name: '", conversation.name, "']");
		print("WARNING :: Convo '", conversation.name, "' is not in the queue, yet somehow has valid privateData");
	end
end


-- Conversation Queueing
---------------------------------------------------------------------------

function NarrativeQueueInstance:Push(conversation:table, queue:table):boolean	-- Returns TRUE if Push succeeded, FALSE if failed
	local result:boolean = false;

	if (conversation and queue) then
		if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
			conversation.privateData.DEBUG_CONVO_QUEUED = true;
		end

		result = true;

		for key, convo in hpairs(queue) do
			if (convo == conversation) then
				result = false;
				break;
			end
		end

		if (result) then
			table.insert(queue, conversation);
		end
	end

	return result;
end

function NarrativeQueueInstance:Pop(conversation:table, queue:table):table	-- Returns conversation reference if popped, nil if not found
	local foundConvoIndex:number = 0;
	local foundConvo:table = {};

	if (conversation and queue) then
		if (NarrativeQueuePrivates.ConvoHasPrivateData(conversation)) then
			conversation.privateData.DEBUG_CONVO_QUEUED = false;
		end

		for key, convo in hpairs(queue) do
			if (convo == conversation) then
				foundConvoIndex = key;
				break;
			end
		end

		if (foundConvoIndex > 0) then
			table.remove(queue, foundConvoIndex);
			foundConvo = conversation;
		end
	end

	return foundConvo;
end


-- Initialization and Destruction
---------------------------------------------------------------------------

function NarrativeQueueInstance:InitializeConversation(conversation:table):void	-- BONUS TODO
	self:DebugPrint("NarrativeQueueInstance.InitializeConversation( " .. conversation.name .. " )");

	--conversation.sleepBefore = self:EvaluateConversationSleep(conversation.sleepBefore, conversation);
	--conversation.sleepAfter = self:EvaluateConversationSleep(conversation.sleepAfter, conversation);

	conversation.privateData = {
		timeSinceLastCheckSeconds = 0.0,
		timePendingSeconds = 0.0,
		timeElapsedSeconds = 0.0,

		scriptedSceneType = conversation.SceneType and conversation.SceneType(conversation, self),

		participants = self:GetConversationParticipants(conversation),

-- BONUS TODO : enable pre-evaluation of line paths
--[[
		determinedLines = {},
--]]

		interruptOnPlay = nil,
		interrupted = false,
		completed = false,

		linesCompletedTimeSeconds = nil,

		--preDelayDurationSeconds = conversation.sleepBefore,
		--postDelayDurationSeconds = conversation.sleepAfter,
		preDelayCompleted = false,
		postDelayCompleted = false,

		-- DEBUG
		DEBUG_CONVO_QUEUED = true,
	};

	local currentLine:table = (conversation.lines and conversation.lines[1]) or nil;

	-- Species
	if (currentLine) then
		conversation.privateData.TIME_BASED = {
			currentLine = currentLine,	-- The line that is currently playing
			nextLine = 1,				-- The line we want to play now, as the current line is finishing
		};
	else
		conversation.privateData.EVENT_BASED = {
			currentLines = {},			-- List of lines that are currently playing
			finishedLines = {},			-- List of lineIds from the currentLines list that are ready to be removed from that list
			readyLines = {},			-- List of lines that are ready to start playing now
			processedLines = {},		-- List of lineIds from the readyLines list that are ready to be removed from that list
			ended = false,				-- FALSE: This conversation will continue to wait for incoming "play line" events | TRUE: This conversation is no longer listening for events, and will finish as soon as its currentLines list is empty
		};
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	-- If necessary, fix up Event-Based keys
	if (not conversation.lines[1]) then
		local newLines = {};
		for lineId, line in hpairs(conversation.lines) do
			newLines[string.lower(lineId)] = line;
		end
		conversation.lines = newLines;
	end
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

	-- Conversation Tag
	-- Make sure 'tagOverride' isn't nil, then if it's not confirm it's valid, and if it is, assign it to 'conversationTypeTag'
	--   or, if not, make sure 'tag' isn't nil, then if it's not confirm it's valid, and if it is, assign it to 'conversationTypeTag'
	local conversationTypeTag = NarrativeHelpers.ResolveConversationTag(conversation);
	local useLuaOverrides = true;
	if (conversationTypeTag) then
		conversation.privateData.TAG_DATA = {
			sceneType				= Conversation_GetSceneType(conversationTypeTag),
			relativePriority		= Conversation_GetRelativePriority(conversationTypeTag),
			maxDurationSeconds		= Conversation_GetMaxDurationSeconds(conversationTypeTag),
			timeoutDurationSeconds	= Conversation_GetTimeoutDurationSeconds(conversationTypeTag),
			preDelaySeconds			= Conversation_GetPreDelaySeconds(conversationTypeTag),
			postDelaySeconds		= Conversation_GetPostDelaySeconds(conversationTypeTag),
		};
		
		conversation.privateData.TAG_DATA.flags = {};
		local flagsList = Conversation_GetFlags(conversationTypeTag);
		for _,flagStringId in hpairs(flagsList) do
			conversation.privateData.TAG_DATA.flags[flagStringId] = true;
		end
		useLuaOverrides = self:TestFlag(conversation, "AllowLuaToOverride");
		conversation.privateData.surviveForceDisruptingPriorites = self:TestFlag(conversation, "SurviveForceDisruptingPriorities");
	end

	-- Determine which field values to use: script or tag values
	--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
	-- Scene Type
	if (not useLuaOverrides or conversation.privateData.scriptedSceneType == nil or conversation.privateData.scriptedSceneType == CONVO_PRIORITY.UsePriorityFromTag)
	then conversation.privateData.sceneType = self:GetTagValue(conversation, "sceneType");
	else conversation.privateData.sceneType = conversation.privateData.scriptedSceneType; end
	-- Dirty CHAIN convo hack
	if (conversation.privateData.scriptedSceneType == CONVO_PRIORITY.Chain) then conversation.privateData.sceneType = CONVO_PRIORITY.Chain; end
	
	-- Priority
	conversation.privateData.relativePriority = self:GetTagValue(conversation, "relativePriority") or 5;
	
	-- Timing
	conversation.privateData.timeoutDurationSeconds = self:GetTagValue(conversation, "timeoutDurationSeconds");
	conversation.privateData.timeoutDurationSeconds = ((conversation.privateData.timeoutDurationSeconds and conversation.privateData.timeoutDurationSeconds > 0) and conversation.privateData.timeoutDurationSeconds) or nil;
	if (conversation.privateData.sceneType == CONVO_PRIORITY.Chain) then conversation.privateData.timeoutDurationSeconds = nil; end
	conversation.privateData.maxDurationSeconds = self:GetTagValue(conversation, "maxDurationSeconds");
	conversation.privateData.preDelaySeconds = conversation.sleepBeforeSystemUseOverride or (useLuaOverrides and conversation.sleepBefore) or (not useLuaOverrides and self:GetTagValue(conversation, "preDelaySeconds")) or nil;
	conversation.privateData.postDelaySeconds = (useLuaOverrides and conversation.sleepAfter) or (not useLuaOverrides and self:GetTagValue(conversation, "postDelaySeconds")) or nil;
	--==--==--==--==--==--==--==--==--==--==--==--==--==--==--

	-- Determine which flag values to use: script or tag values
	--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
	-- Starting Conditions
	if (not useLuaOverrides or conversation.canStartOnce == nil)
	then conversation.privateData.canStartOnce = self:TestFlag(conversation, "CanStartLatches");
	else conversation.privateData.canStartOnce = conversation.canStartOnce; end

	if (not useLuaOverrides or conversation.ignoreCollisions == nil)
	then conversation.privateData.ignoreCollisions = self:TestFlag(conversation, "IgnoreCollisions");
	else conversation.privateData.ignoreCollisions = conversation.ignoreCollisions; end
	
	-- Behavior
	if (not useLuaOverrides or conversation.doNotPlayDialog == nil)
	then conversation.privateData.doNotPlayDialog = self:TestFlag(conversation, "DoNotPlayDialog");
	else conversation.privateData.doNotPlayDialog = conversation.doNotPlayDialog; end

	-- DDS
	if (not useLuaOverrides or conversation.disableAIDialog == nil) then
		conversation.privateData.overrideSceneTypeAiDialog = self:TestFlag(conversation, "OverrideSceneTypeAiDialog");
		conversation.privateData.disableAiDialog = self:TestFlag(conversation, "DisableAiDialog");
	else
		conversation.privateData.overrideSceneTypeAiDialog = true;
		conversation.privateData.disableAiDialog = conversation.disableAIDialog;
	end
	--==--==--==--==--==--==--==--==--==--==--==--==--==--==--

	-- Initilaize all lines in conversation
	if (conversation.lines) then
		for lineId, line in hpairs(conversation.lines) do
			self:InitializeLine(line, conversation, lineId);
		end
	end

	conversation.privateData.CheckFrequency = conversation.CheckFrequency or NarrativeQueueDefaults.CheckFrequency;
	conversation.privateData.Timeout = (useLuaOverrides and conversation.Timeout) or NarrativeQueueDefaults.Timeout;
	conversation.privateData.MaxPlayingTime = (useLuaOverrides and conversation.MaxPlayingTime) or NarrativeQueueDefaults.MaxPlayingTime;

	-- Subtitle priority, create a single value from conversation priority and relative priority
	local subPriority:wholenum = wholenum(CONVO_TYPE_DATA:GetTypeData(conversation.privateData.sceneType).Priority);
	subPriority = subPriority:lshift(16);
	subPriority = subPriority:bor(wholenum(conversation.privateData.relativePriority));

	conversation.privateData.subtitlePriority = subPriority:ToNumber();
end

function NarrativeQueueInstance:InitializeLine(line:table, conversation:table, lineId):void
	self:DebugPrint("NarrativeQueueInstance.InitializeLine( " .. lineId .. " )");

	local lineDurationSeconds:number = Sound_GetMaxTime(line.tag);

	--line.sleepBefore = self:EvaluateLineSleep(line.sleepBefore, line, conversation, lineId);
	--line.sleepAfter = self:EvaluateLineSleep(line.sleepAfter, line, conversation, lineId);

	line.privateData = {
		lineId = lineId,
		startTimeSeconds = nil,
		durationSeconds = lineDurationSeconds * (line.playDurationAdjustment or 1),
		characterPlayed = nil,
		started = false,
		playing = false,
		played = false,
		stopped = false,
		--preDelayDurationSeconds = line.sleepBefore,
		--postDelayDurationSeconds = line.sleepAfter,
		--preDelayCompleted = line.sleepBefore == 0,
		--postDelayCompleted = line.sleepAfter == 0,
		playSecondsOffset = 999, -- a large number to initialize
		previousLine = nil,
	};

	line.privateData.durationSeconds = (line.privateData.durationSeconds > 0 and line.privateData.durationSeconds) or 0;
end

function NarrativeQueueInstance:TeardownConversation(conversation:table):void
	if(conversation.privateData.disabledBackMenu == true) then
		conversation.privateData.disabledBackMenu = false;
	end

	--  Reset Narrative Fast Forward in case it was active
	Composer_ReachedEnd();

	-- End shows started by this conversation
	self:EndComposition(conversation);

	-- Notify audio a conversation has ended
	AudioMixStates.ConversationEndedMixState(conversation.name);
end

function NarrativeQueueInstance:ExpireLine(conversation:table, line:table):void
	if (conversation.privateData.EVENT_BASED) then
		table.insert(conversation.privateData.EVENT_BASED.finishedLines, line.privateData.lineId);
	end
end


-- Conversation Data
---------------------------------------------------------------------------

function NarrativeQueueInstance:TestFlagByStringId(conversation:table, flagId:string_id):boolean
	if (not conversation.privateData.TAG_DATA) then return false; end
	return not not conversation.privateData.TAG_DATA.flags[flagId];
end

function NarrativeQueueInstance:TestFlag(conversation:table, flagName:string):boolean
	if (not CONVO_FLAGS[flagName]) then return false; end
	return self:TestFlagByStringId(conversation, CONVO_FLAGS[flagName]);
end

function NarrativeQueueInstance:GetTagValue(conversation:table, fieldName:string):any
	if (not conversation.privateData.TAG_DATA) then return nil; end
	return conversation.privateData.TAG_DATA[fieldName];
end


-- Character Availability and Death
---------------------------------------------------------------------------

function NarrativeQueueInstance:EvaluateCharacter(line:table, conversation:table):object
	local characterObject, checkCharacter = self:EvaluateCharacterExtended(line, conversation);

	return characterObject;
end

function NarrativeQueueInstance:EvaluateCharacterExtended(line:table, conversation:table)
	local checkCharacter = line.character;
	local characterObject:object = nil;

	if (checkCharacter) then
		if (type(checkCharacter) == "function") then
			checkCharacter = checkCharacter(line, conversation, self, line.privateData.lineId);
		end

		-- Character is 'object' by default
		characterObject = checkCharacter;

		-- support for when the character ID is an AI or object - legacy use support
		if (type(checkCharacter) == "ai") then
			self:DebugPrint("Character was 'AI'");
			characterObject = ai_get_object(checkCharacter);
		elseif (type(checkCharacter) == "string") then
			self:DebugPrint("Character was 'string'");
--			characterObject = CharacterRepository.GetCharacterObjectByName(checkCharacter);	-- COMING SOON
		elseif (type(checkCharacter) == "number" and checkCharacter ~= self.NoCharacterValue) then
			print("ERROR :: !! :: Character for conversation '", conversation.name, "', line [", line.privateData.lineId, "] was a NUMBER");
			checkCharacter = self.NoCharacterValue;
		end
	else
		-- If the character field itself was nil, treat this as a 2D play, rather than a dead/missing character
		checkCharacter = self.NoCharacterValue;
	end

	if (checkCharacter == self.NoCharacterValue) then
		characterObject = nil;
	end

	self:DebugPrint("EvaluateCharacterExtended() = ", characterObject);
	return characterObject, checkCharacter;
end

function NarrativeQueueInstance:IsCharacterDead(line:table, conversation:table):boolean	-- Returns TRUE if dead, FALSE if not
	local isDead:boolean = false;

	-- If no character object was supplied, then character is not "dead".  Otherwise...
	if (line.character) then
		local characterObject, checkCharacter = self:EvaluateCharacterExtended(line, conversation);

		-- If the convo designer did not conditionally specify "no character"...
		if (checkCharacter ~= self.NoCharacterValue) then
			local objType, objSubType = GetEngineType(characterObject, true);
			isDead = (
				   (characterObject == nil)
				or (objSubType == "biped" and not biped_is_alive(characterObject))
				or ((objType == "player" or objSubType == "vehicle") and (object_get_health(characterObject) <= 0))
			);

			self:DebugPrint("IsCharacterDead() /////////////////////////////////////////////////////////////////////////////");
			self:DebugPrint(" -- checkCharacter", checkCharacter, " - objType:", objType, "- objSubType:", objSubType);
			self:DebugPrint(" -- returning", isDead);
		end
	end

	return isDead;
end

function NarrativeQueueInstance:CanCharacterSpeak(line:table, conversation:table):boolean -- Returns FALSE if dead, TRUE if line can play (character might still be dead)
	return (not self:IsCharacterDead(line, conversation));
end


-- Conversation Functionality
---------------------------------------------------------------------------

function NarrativeQueueInstance:StartConversation(conversation:table):void
	conversation.forcePlayImmediately = nil;  -- This override is one-shot, and must be re-applied each time the convo is played
	
	--self:InitializeConversation(conversation);
	print(conversation.name, ": PENDING -> PLAYING");
	self:Push(self:Pop(conversation, self.pendingConversations), self.playingConversations);

	if (conversation.PlayOnSpecificPlayer) then
		conversation.privateData.targetPlayer = conversation.PlayOnSpecificPlayer(conversation, self);
	end

	local priority = conversation.privateData.priority;

	if priority == CONVO_PRIORITY.CriticalPath or priority == CONVO_PRIORITY.MainCharacter then
		conversation.privateData.disabledBackMenu = true;
	else
		conversation.privateData.disabledBackMenu = false;
	end

	local disableAiDialog = false;
	if (conversation.privateData.overrideSceneTypeAiDialog) then
		disableAiDialog = conversation.privateData.disableAiDialog;
	else
		disableAiDialog = CONVO_TYPE_DATA:TestFlag(conversation.privateData.sceneType, "suppressDdsChatter");
	end

	if (disableAiDialog) then
		conversation.privateData.disabledAiDialog = true;
		AIDialogManager.DisableAIDialog();
	end

	-- Initialize our custom conversation data here
	-- SINCE THIS RUNS INLINE, NO SLEEPS ARE ALLOWED IN THE FUNCTION
	if (conversation.Initialize) then
		conversation.Initialize(conversation, self);
	end

	-- If we end up needing one, put the OnPlay() call here:
	if (conversation.OnPlay) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(conversation.OnPlay, conversation, self);
		else
			conversation.OnPlay(conversation, self);
		end
	end

	-- Determine the sleeps for the convo at convo start
	conversation.privateData.preDelayDurationSeconds = self:EvaluateConversationSleep(conversation.privateData.preDelaySeconds, conversation);
	conversation.privateData.postDelayDurationSeconds = self:EvaluateConversationSleep(conversation.privateData.postDelaySeconds, conversation);
end

function NarrativeQueueInstance:FinishConversation(conversation:table):void
	self:DebugPrint("Finish Conversation: " .. conversation.name);

	if (conversation.OnFinish) then

		if (self.callbacksInSeparateThreads) then
			CreateThread(conversation.OnFinish, conversation, self);
		else
			conversation.OnFinish(conversation, self);
		end
	end

	if (conversation.privateData.disabledAiDialog) then
		conversation.privateData.disabledAiDialog = nil;
		AIDialogManager.EnableAIDialog();
	end

	self:TeardownConversation(conversation);

	NarrativeQueuePrivates.MarkConvoAsCompleted(conversation);

	print(conversation.name, ": PLAYING -> ENDED");
	self:Pop(conversation, self.playingConversations);
end

function NarrativeQueueInstance:StopAllConversations(stopQueue):void
	local queue = stopQueue or self.playingConversations;

	for key, convo in hpairs(queue) do
		if (NarrativeQueuePrivates.ConvoHasPrivateData(convo)) then
			convo.privateData.DEBUG_CONVO_QUEUED = false;
		end

		self:HaltAllLines(convo);
		self:TeardownConversation(convo);
		NarrativeQueuePrivates.UnregisterConvo(convo);
	end
end

function NarrativeQueueInstance:HandlePendingTimeout(conversation:table):void
	local timeoutDuration:number = (conversation.privateData.Timeout and conversation.privateData.Timeout(conversation, self)) or -1;

	-- Check for timeout
	if (conversation.privateData.interrupted or
		(timeoutDuration > -1 and conversation.privateData.timePendingSeconds > timeoutDuration)) then

		if (not conversation.privateData.interrupted and conversation.OnTimeout) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnTimeout, conversation, self);
			else
				conversation.OnTimeout(conversation, self);
			end
		end

		print("Conversation '", conversation.name, ((conversation.privateData.interrupted and "' was interrupted while pending for ") or "' Timed out after "), timeoutDuration, " seconds.");
		FireTelemetryEvent("ConvoPendingTimeout", { conversationName = conversation.name, timeoutDuration = timeoutDuration, timePendingSeconds = conversation.privateData.timePendingSeconds, });

		print(conversation.name, ": PENDING -> TIMED OUT");
		self:Pop(conversation, self.pendingConversations);
		NarrativeQueuePrivates.UnregisterConvo(conversation);
	end
end

function NarrativeQueueInstance:CheckFrequency(conversation:table):boolean
	return (not conversation.privateData.CheckFrequency or (conversation.privateData.CheckFrequency(conversation, self) <= conversation.privateData.timeSinceLastCheckSeconds));
end

function NarrativeQueueInstance:ConvosHaveParticipantCollision(convo1:table, convo2:table):boolean
	if (convo1.privateData.ignoreCollisions or convo2.privateData.ignoreCollisions) then return nil; end  -- Ignore collisions
	
	for moniker,_ in hpairs(convo1.privateData.participants) do
		if (convo2.privateData.participants[moniker]) then
			return true;  -- Found collision
		end
	end
	
	return false;  -- No collisions
end


-- Check pending candidates against all currently-playing conversations for collision
function NarrativeQueueInstance:CheckPendingCanPlay(conversation:table):boolean	-- Returns TRUE if conversation can play, FALSE if not
	-- Convo has been force-interrupted, do not start it
	if (conversation.privateData.interrupted) then return false; end
	
	-- Convo is not updating this tick
	if (not self:CheckFrequency(conversation)) then return nil; end
	conversation.privateData.timeSinceLastCheckSeconds = 0;
	
	-- Convo is not currently ready to run
	if (not conversation.privateData.canStart and conversation.CanStart and not conversation.CanStart(conversation, self)) then return false; end
	
	-- All self-imposed hurtles passed.  Checking against all Playing conversations...	
	-- Lock our 'can start' value, if we're set to lock
	conversation.privateData.canStart = conversation.privateData.canStartOnce or nil;
	
	local myType = conversation.privateData.sceneType;
	local myPriority = CONVO_TYPE_DATA:GetTypeData(myType).Priority;
	for _,playingConvo in hpairs(self.playingConversations) do
		local playingType = playingConvo.privateData.sceneType;
		local playingPriority = CONVO_TYPE_DATA:GetTypeData(playingType).Priority;

		-- Check priority behaviors --
		-- The lower the number, the more priority the conversation has
		local newcomerWins = myPriority < playingPriority;																													-- Newcomer wins if it's higher priority
		local samePriority = myPriority == playingPriority;
		newcomerWins = newcomerWins or (samePriority and conversation.privateData.relativePriority < playingConvo.privateData.relativePriority);							-- Newcomer wins if it's same priority, but higher relative priority
		local beatsSamePriority = CONVO_TYPE_DATA:TestFlag(myType, "beatsSamePriority") or self:TestFlag(conversation, "beatsSamePriority");
		newcomerWins = newcomerWins or (samePriority and beatsSamePriority and conversation.privateData.relativePriority == playingConvo.privateData.relativePriority);		-- Newcomer wins if it's same priority and relative priority, and 'beatsSamePriority' flag is active
		
		-- We beat the target's priority
		if (newcomerWins) then			
			local newcomerKillsPlayingConvo = not CONVO_TYPE_DATA:TestFlag(myType, "willNotInterruptLowerPriority") and not CONVO_TYPE_DATA:TestFlag(playingType, "notInterruptedByHigherPriority");				-- Newcomer kills playing convo when it starts if newcomer is not set to ignore lower priorities, and playing convo is not set to survive higher priorities
			newcomerKillsPlayingConvo = newcomerKillsPlayingConvo or (CONVO_TYPE_DATA:TestFlag(myType, "forceDisruptsAllLowerPriority") and not self:TestFlag(playingConvo, "SurviveForceDisruptingPriorities"));		-- Newcomer kills playing convo when it starts if newcomer's 'forceDisruptsAllLowerPriority' flag is set, and playing convo is not set to survive force-disruption
			newcomerKillsPlayingConvo = newcomerKillsPlayingConvo or self:ConvosHaveParticipantCollision(conversation, playingConvo);																				-- Regardless of general flags, conversations cannot overlap if they share any participants, so the newcomer will kill the playing convo if they share any speaking characters

			if (newcomerKillsPlayingConvo) then
				-- Add the playing convo to my list of targets to interrupt on play
				conversation.privateData.interruptOnPlay = conversation.privateData.interruptOnPlay or {};
				table.insert(conversation.privateData.interruptOnPlay, playingConvo);
			end
		-- Target beat our priority, but one or both of us might be set to ignore each other
		elseif (myPriority >= playingPriority) then
			local newcomerLost = not CONVO_TYPE_DATA:TestFlag(playingType, "willNotBlockLowerPriority") and not CONVO_TYPE_DATA:TestFlag(myType, "notBlockedByHigherPriority");					-- Newcomer is generally prevented from starting by higher priorities, and playing convo generally blocks lower priorities
			newcomerLost = newcomerLost or (CONVO_TYPE_DATA:TestFlag(playingType, "forceDisruptsAllLowerPriority") and not self:TestFlag(conversation, "SurviveForceDisruptingPriorities"));		-- The playing convo force-disrupts all lower priorities, and newcomer is not set to be immune to this disruption
			newcomerLost = newcomerLost or self:ConvosHaveParticipantCollision(conversation, playingConvo);																						-- Regardless of general flags, conversations cannot overlap if they share any participants, so the playing convo will prevent the newcomer from starting if they share any speaking characters

			if (newcomerLost) then
				-- We cannot play due to a higher priority conflict
				conversation.privateData.interruptOnPlay = nil;
				--print("FAILED TO PLAY CONVO", conversation.name, "(Pri", myPriority, "vs", playingPriority, "for convo", playingConvo.name, ")");
				return false;
			end
		end
	end
	
	return true;
end

-- Check remaining pending candidates against each other for collision
function NarrativeQueueInstance:ResolveReadyToPlay(readyList:table, notReadyList:table):void
	local sortedList = {};
	local confirmedList = {};
	-- Sort all from highest to lowest, highest relative to lowest, long
	for _,convo in hpairs(readyList) do
		local convoPriority = CONVO_TYPE_DATA:GetTypeData(convo).Priority;
		local convoRelativePri = convo.privateData.relativePriority;
		local wasAdded = false;
		for index,sortedConvo in hpairs(sortedList) do
			local sortedPriority = CONVO_TYPE_DATA:GetTypeData(sortedConvo).Priority;
			if (convoPriority < sortedPriority) then
				table.insert(sortedList, index, convo);
				wasAdded = true;
			elseif (convoPriority == sortedPriority) then
				local sortedRelativePri = sortedConvo.privateData.relativePriority;
				if (convoRelativePri < sortedRelativePri) then
					table.insert(sortedList, index, convo);
					wasAdded = true;
				elseif ((convoRelativePri == sortedRelativePri)
				and (convo.privateData.timePendingSeconds > sortedConvo.privateData.timePendingSeconds)) then
					table.insert(sortedList, index, convo);
					wasAdded = true;
				end
			end
		end
		
		if (not wasAdded) then
			-- Need to push to the back of the list
			table.insert(sortedList, convo);
		end
	end
	
	-- Checks all candidate pending convos against all other candidate pending convos
	for _,convo in hpairs(sortedList) do
		local myType = convo.privateData.sceneType;
		local myPriority = CONVO_TYPE_DATA:GetTypeData(myType).Priority;
		
		local isReady = true;
		for _,checkConvo in hpairs(confirmedList) do
			local checkType = convo.privateData.sceneType;
			local checkPriority = CONVO_TYPE_DATA:GetTypeData(myType).Priority;
			
			local candidateLoses = myPriority > checkPriority;																																						-- Another candidate this frame beats our priority
			local samePriority = myPriority == checkPriority;
			candidateLoses = candidateLoses or (samePriority and convo.privateData.relativePriority > checkConvo.privateData.relativePriority);																		-- Another candidate of equal priority beats our relative priority
			candidateLoses = candidateLoses or (samePriority and (convo.privateData.relativePriority == checkConvo.privateData.relativePriority) and not CONVO_TYPE_DATA:TestFlag(myType, "beatsSamePriority"));	-- Another candidate is of equal priorities, but we don't beat equals
			candidateLoses = candidateLoses and not CONVO_TYPE_DATA:TestFlag(checkType, "willNotBlockLowerPriority");																								-- The other candidate we are losing to enforces its win over lower pri (would let us ignore the above conditions)
			candidateLoses = candidateLoses and not CONVO_TYPE_DATA:TestFlag(myType, "notBlockedByHigherPriority");																									-- Our candidate is not exempt from higher priority collisions (would let us ignore the above conditions)
			candidateLoses = candidateLoses or self:ConvosHaveParticipantCollision(convo, checkConvo);																												-- Regardless of general flags, conversations cannot overlap if they share any participants, so since the convo we're checking against got into the queue first, we are preventing our candidate from starting if they share any speaking characters

			if (candidateLoses) then
				isReady = false;  -- Collision with higher pri candidate detected - We cannot play
				break;
			end
		end
		
		if (isReady) then
			table.insert(confirmedList, convo);
		else
			convo.privateData.interruptOnPlay = nil;
			table.insert(notReadyList, convo);
		end
	end
	
	-- Start all confirmed-ready conversations
	for _,convo in hpairs(confirmedList) do
		if (convo.privateData.interruptOnPlay) then
			for _,interruptConvo in hpairs(convo.privateData.interruptOnPlay) do
				interruptConvo.privateData.interrupted = true;
			end
			convo.privateData.interruptOnPlay = nil;
		end
		
		self:StartConversation(convo);
	end
end


-- Conversation State
---------------------------------------------------------------------------

function NarrativeQueueInstance:EvaluateConversationSleep(sleepVariable, conversation:table):number
	local sleepValue:number = 0;

	if (type(sleepVariable) == "number") then
		sleepValue = sleepVariable;
	elseif(type(sleepVariable) == "function") then
		sleepValue = sleepVariable(conversation, self);
	end

	return sleepValue;
end

function NarrativeQueueInstance:GetConversationParticipants(conversation:table):table	-- Returns a table containing all participants in the conversation	-- BONUS TODO
	local participants = {};

	for lineId,line in ipairs(conversation) do
		participants[line.moniker] = conversation;
	end

	return participants;
end

function HasPriorityConflict(testPriority, checkAgainstPriority):boolean
	return (checkAgainstPriority == CONVO_PRIORITY.CriticalPath) and (testPriority > CONVO_PRIORITY.NPC);
end


-- Line Functionality
---------------------------------------------------------------------------

function NarrativeQueueInstance:StartLine(conversation:table, lineId):void
	self:DebugPrint("_>_>_> Convo: ", conversation.name, " line: ", lineId);

	self:DebugPrint("NarrativeQueueInstance.StartLine()");

	-- Update fast forward state now that a new line has started
	Composer_ReachedNextLine();

	-- Error-checking
	if (not conversation) then error("ERROR : NarrativeQueueInstance:StartLine() had 'nil' for conversation"); end
	if (not conversation.lines) then error("ERROR : NarrativeQueueInstance:StartLine() - conversation '", conversation.name,"' has no lines table"); end
	if (not conversation.lines[lineId]) then error("ERROR : NarrativeQueueInstance:StartLine() - conversation '", conversation.name,"'s lines table does not contain line [", lineId,"]"); end

	local line:table = conversation.lines[lineId];
	self:DebugPrint("NarrativeQueueInstance.StartLine() - Duration: " .. line.privateData.durationSeconds .. " seconds.");

	line.privateData.startTimeSeconds = conversation.privateData.timeElapsedSeconds;
	line.privateData.started = true;

	if (conversation.privateData.TIME_BASED) then
		line.privateData.previousLine = conversation.privateData.TIME_BASED.currentLine;
		conversation.privateData.TIME_BASED.currentLine = line;
	else
		table.insert(conversation.privateData.EVENT_BASED.processedLines, lineId);
		conversation.privateData.EVENT_BASED.currentLines[lineId] = line;
	end

	if (line.OnStart) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(line.OnStart, line, conversation, self, lineId);
		else
			line.OnStart(line, conversation, self, lineId);
		end
	end

	-- Determine the sleeps for the line at line start
	local preDelayFunction = line.sleepBefore
		or (not (line.sleepAfter or line.playDurationAdjustment)		-- Don't use default timing if we have explicit timing
			and (conversation.privateData.TIME_BASED and lineId ~= 1)	-- Don't add default delay to the first line
			and NarrativeQueueDefaults.LineDelay)
		or nil;
	line.privateData.preDelayDurationSeconds = self:EvaluateLineSleep(preDelayFunction, line, conversation, lineId);
	line.privateData.preDelayCompleted = line.sleepBefore == 0;

	line.privateData.postDelayDurationSeconds = self:EvaluateLineSleep(line.sleepAfter, line, conversation, lineId);
	line.privateData.postDelayCompleted = line.sleepAfter == 0;
end

-- Event-Based only
function NarrativeQueueInstance:RestartLine(conversation:table, lineId):void
	if (not conversation.privateData.EVENT_BASED) then
		print(":! :! | WARNING | !: !: NarrativeQueueInstance:RestartLine() - Conversation", conversation.name, "is not an Event-Based convo!  DOING NOTHING.");
		return;
	end

	local line:table = conversation.lines[lineId];
	NarrativeQueuePrivates.UnregisterLine(line);
	self:InitializeLine(line, conversation, lineId);
	self:StartLine(conversation, lineId);
end

function NarrativeQueueInstance:PlayLine(conversation:table, line:table):void
	line.privateData.playing = true;

	if (not line.tag) then
		if (conversation.privateData.TIME_BASED) then
			conversation.privateData.TIME_BASED.nextLine = self:GetNextLine(conversation, line, true, false);
		end

		--error("Line " .. line.privateData.lineId .. " of conversation " .. conversation.name .. " missing TAG ID");
		print(":! :! | WARNING | !: !: Line '", line.privateData.lineId, "' of conversation", conversation.name, "missing TAG ID !");
	else


		-- If we're playing more than one show, handle line plays on "Auxiliary Shows"
		if (conversation.privateData.showId and type(conversation.privateData.showId) == "table" and line.playOnAllShows) then
			line.privateData.characterPlayed = {};

			for i=1,conversation.privateData.showId.totalCount do
				if (conversation.privateData.showId[i] and line.character and type(line.character) == "function") then
					line.privateData.characterPlayed[i] = line.character(line, conversation, self, line.privateData.lineId, i);
					self:PlayLineInternal(conversation, line, line.privateData.characterPlayed[i]);
				end
			end
		else
			-- Capture the actual object we are playing this sound on
			line.privateData.characterPlayed = ((not line.privateData.playLineOnNilCharacter or line.forcePlayIn3D) and self:EvaluateCharacter(line, conversation)) or nil;

			-- If we were provided a list of characters on which to play this line, instead of a single character object, then we'll want to duplicate the line play on each target
			if (type(line.privateData.characterPlayed) == "table") then
				for _,character in hpairs(line.privateData.characterPlayed) do
					self:PlayLineInternal(conversation, line, character);
				end
			-- Otherwise, just play it on the one specified character object (if any)
			else
				self:PlayLineInternal(conversation, line);
			end

			-- If we didn't have an object to play the sound on (play on the air), we'll just use the conversation as the index for delayed interruptions
			line.privateData.characterPlayed = line.privateData.characterPlayed or line.moniker or conversation;
			self.interruptedLines[line.privateData.characterPlayed] = nil;
		end
	end

	if (line.OnTagPlay) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(line.OnTagPlay, line, conversation, self, line.privateData.lineId);
		else
			line.OnTagPlay(line, conversation, self, line.privateData.lineId);
		end
	end
end

function NarrativeQueueInstance:PlayLineInternal(conversation:table, line:table, characterOverride):void
	if (conversation.privateData.doNotPlayDialog) then return; end

	if (line.marker) then
		--self:DebugPrint("PlayDialogFromMarkerOnSpecificClients( tag: " .. line.tag .. ", character: " .. ExtendedTable.ObjectToString(self:EvaluateCharacter(line, conversation)) .. ", player: ", conversation.privateData.targetPlayer, ", marker: ", line.marker);
		PlayDialogFromMarkerOnSpecificClients(line.tag, characterOverride or line.privateData.characterPlayed, conversation.privateData.targetPlayer, line.marker, false, conversation.privateData.subtitlePriority);
	else
		--self:DebugPrint("PlayDialogOnSpecificClients( tag: " .. line.tag .. ", character: " .. ExtendedTable.ObjectToString(self:EvaluateCharacter(line, conversation)) .. ", player: ", conversation.privateData.targetPlayer);
		PlayDialogOnSpecificClients(line.tag, characterOverride or line.privateData.characterPlayed, conversation.privateData.targetPlayer, false, conversation.privateData.subtitlePriority);
	end
end

function NarrativeQueueInstance:HaltLine(conversation:table, line:table, interruptOverlapDurationSeconds:number, showIndex:number):void
	if (line and line.privateData) then
		if (line.privateData.playing and not line.privateData.played) then
			if (type(line.privateData.characterPlayed) == "table") then
				if (showIndex) then
					local actualObject = line.privateData.characterPlayed[showIndex];
					if (actualObject) then
						self:HaltLineInternal(conversation, line, actualObject, interruptOverlapDurationSeconds, actualObject);
					end
				elseif (type(conversation.privateData.showId) == "table") then
					for i=1,conversation.privateData.showId.totalCount do
						if (conversation.privateData.showId[i]) then
							local actualObject = line.privateData.characterPlayed[i];
							if (actualObject) then
								self:HaltLineInternal(conversation, line, actualObject, interruptOverlapDurationSeconds, actualObject);
							end
						end
					end
				else
					for _,character in hpairs(line.privateData.characterPlayed) do
						self:HaltLineInternal(conversation, line, character, interruptOverlapDurationSeconds, character);
					end
				end
			else
				local actualObject = (line.privateData.characterPlayed ~= conversation and line.privateData.characterPlayed ~= line.moniker and line.privateData.characterPlayed) or nil;
				self:HaltLineInternal(conversation, line, actualObject, interruptOverlapDurationSeconds, line.privateData.characterPlayed);
			end
		end
	end
end

function NarrativeQueueInstance:HaltLineInternal(conversation:table, line:table, actualObject, interruptOverlapDurationSeconds:number, interruptIndex:any):void
	if (interruptOverlapDurationSeconds) then
		-- Mark the tag for later silencing
		self.interruptedLines[interruptIndex] = {
			tag = line.tag,
			character = actualObject,
			targetPlayer = conversation.privateData.targetPlayer,
			durationSeconds = interruptOverlapDurationSeconds,
		};
	else
		-- Silence the tag immediately
		self:SilenceTag(line.tag, actualObject, conversation.privateData.targetPlayer);
	end
end

function NarrativeQueueInstance:HaltAllLines(conversation:table, interruptOverlapDurationSeconds:number):void
	-- TODO - jacrowde - Update this function to make halting all lines compatable with multi-show conversations

	if (conversation.privateData.TIME_BASED) then
		self:HaltLine(conversation, conversation.privateData.TIME_BASED.currentLine, interruptOverlapDurationSeconds);
	else
		for lineId, line in hpairs(conversation.privateData.EVENT_BASED.currentLines) do
			self:HaltLine(conversation, line, interruptOverlapDurationSeconds);
		end
	end
end

-- Start next line in the convo (TIME_BASED only)
function NarrativeQueueInstance:StartNextLine(conversation:table):void
	local checkedLineNumbers:table = {};
	local foundLine:boolean = false;
	local currentLineNumber:number = conversation.privateData.TIME_BASED.nextLine or 1;
	local previousLine:table = nil;
	conversation.privateData.TIME_BASED.nextLine = nil;

	while (not foundLine and currentLineNumber and currentLineNumber > 0 and currentLineNumber <= #conversation.lines) do
		local line:table = conversation.lines[currentLineNumber];

		-- Guard against infinite looping by simply bad user logic
		if (checkedLineNumbers[currentLineNumber]) then
			local errorprint:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. currentLineNumber .."] has already been checked this tick.  We are looping infinitely!");
			--error("ERROR : Conversation '", conversation.name, "', line [", currentLineNumber, "] has already been checked this tick.  We are looping infinitely!");
			error(errorprint);
		end
		checkedLineNumbers[currentLineNumber] = true;

		-- Error-checking
		if (not line.privateData) then
			error("privateData for line [" .. currentLineNumber .. "] in convo '" .. conversation.name .. "' was 'nil' (should not happen in the middle of a convo evaluation)");
		end

		line.privateData.previousLine = previousLine;

		if (line.privateData.played) then
			-- Guards against infinite looping by complex bad user logic
			if (line.privateData.previousLine) then
				local errorprint2:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. line.privateData.previousLine.privateData.lineId .."] started a line that has already been played (line [".. currentLineNumber .."])");
				error(errorprint2);
				print(errorprint2);
				--error("ERROR : Conversation '", conversation.name, "', line [", line.privateData.previousLine.privateData.lineId, "] started a line that has already been played (line [", currentLineNumber,"])");
			-- To replay a line at the beginning of a convo, the whole convo should be requeued
			else
				local errorprint3:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. currentLineNumber .."] has already been played");
				--error("ERROR : Starting conversation '", conversation.name, "', line [", currentLineNumber,"] has already been played");
				error(errorprint3);
			end
		end

		-- Check for dead character (if we care)
		if (not conversation.logicalPlayIfCharacterMissing and not self:CanCharacterSpeak(line, conversation)) then
			currentLineNumber = self:GetNextLine(conversation, line, true, true);	-- (conversation, line, if failed to play, if character was dead)
			self:DebugPrint("Line " .. line.privateData.lineId .. " failed due to dead character.  Moving on to line " .. currentLineNumber .. ".");
		-- If we don't have a conditional, or if the "If" conditional yields TRUE
		elseif (not (line.If or line.ElseIf or line.Else) or (line.If and line.If(line, conversation, self, currentLineNumber))) then
			foundLine = true;
		-- If we have an "ElseIf" or "Else" conditional
		elseif ((line.ElseIf and line.ElseIf(line, conversation, self, currentLineNumber)) or line.Else) then
			if (not line.privateData.previousLine) then
				currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
				self:DebugPrint("Line " .. line.privateData.lineId .. " had an Else or ElseIf conditional without an If before it.  Moving on to line " .. currentLineNumber .. ".");
			else
				local isValidConditionalBlock:boolean = true;
				local foundHeadIf:boolean = false;
				local blockAlreadyPlayed:boolean = false;

				local checkLine:table = line.privateData.previousLine;
				local checkedCheckLineNumbers:table = {};

				local debugWarningString:string = "";

				while (isValidConditionalBlock and not foundHeadIf and not blockAlreadyPlayed) do
					if (not checkLine or (not checkLine.If and not checkLine.ElseIf)) then
						debugWarningString = "Line " .. line.privateData.lineId .. " had an Else or ElseIf conditional without an If before it somewhere in the block.  Moving on to line ";
						isValidConditionalBlock = false;
					else
						if (checkedCheckLineNumbers[checkLine.privateData.lineId]) then
							-- Guards against infinite looping by bad user condintionals logic
							error("ERROR : Conversation '", conversation.name, "', line [", checkLine.privateData.lineId, "] has already been checked by If/Else block for line [", currentLineNumber,"] this tick.  We are looping infinitely!");
						end
						checkedCheckLineNumbers[checkLine.privateData.lineId] = true;

						if (checkLine.Else) then
							debugWarningString = "Line " .. line.privateData.lineId .. " had an Else or ElseIf conditional with another Else conditional before it.  Moving on to line ";
							isValidConditionalBlock = false;
						else
							blockAlreadyPlayed = checkLine.privateData.played;
							foundHeadIf = (checkLine.If and true);

							if (not blockAlreadyPlayed and not foundHeadIf) then
								checkLine = checkLine.privateData.previousLine;
							end
						end
					end
				end

				if (not isValidConditionalBlock) then
					currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
					self:DebugPrint(debugWarningString .. currentLineNumber .. ".");
				elseif (blockAlreadyPlayed) then
					currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
					self:DebugPrint("Line " .. line.privateData.lineId .. " was skipped due to another conditional in the same block playing before it.  Moving on to line " .. currentLineNumber .. ".");
				else
					foundLine = true;
				end
			end
		-- Conditional simply returned FALSE
		else
			currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
			self:DebugPrint("Line " .. line.privateData.lineId .. " failed due to conditional returning FALSE.  Moving on to line " .. currentLineNumber .. ".");
		end

		previousLine = line;
	end

	-- Kill convo, nothing played
	if (not foundLine) then
		conversation.privateData.linesCompletedTimeSeconds = conversation.privateData.timeElapsedSeconds;

		if (conversation.OnLinesComplete) then
			CreateThread(conversation.OnLinesComplete, conversation, self);
		end
	-- Found line, start running it
	else
		self:DebugPrint("Conversation '" .. conversation.name .. "' now starting line: " .. currentLineNumber);
		self:StartLine(conversation, currentLineNumber);
	end
end

-- Start all ready lines in the convo (EVENT_BASED only)
function NarrativeQueueInstance:StartAllReadyLines(conversation:table):void
	-- Start each line
	for lineId, line in hpairs(conversation.privateData.EVENT_BASED.readyLines) do
		-- Check for alive character
		if (self:CanCharacterSpeak(line, conversation)) then
			self:DebugPrint("Conversation '" .. conversation.name .. "' now starting line: " .. line.privateData.lineId);
			self:RestartLine(conversation, line.privateData.lineId);
		-- Character was dead.  Skip this line.
		else
			self:DebugPrint("Line " .. line.privateData.lineId .. " failed due to dead character.");
		end

		table.insert(conversation.privateData.EVENT_BASED.processedLines, lineId);
	end

	-- Clean up our readyLines list
	for _, lineId in hpairs(conversation.privateData.EVENT_BASED.processedLines) do
		conversation.privateData.EVENT_BASED.readyLines[lineId] = nil;
	end
	conversation.privateData.EVENT_BASED.processedLines = {};
end

function NarrativeQueueInstance:ProcessLine(conversation:table, line:table):void
	--self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Processing line: " .. ExtendedTable.ObjectToString(line));
	if (not line.privateData.played and line.privateData.playing) then
		local lineCompleted = Composer_IsFastForwarding() or (self:GetElapsedTimeOfLine(conversation, line) >= (line.privateData.durationSeconds + line.privateData.preDelayDurationSeconds + line.privateData.playSecondsOffset));

		if (lineCompleted) then
			line.privateData.played = true;

			if (line.OnTagFinish) then
				if (self.callbacksInSeparateThreads) then
					CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineId);
				else
					line.OnTagFinish(line, conversation, self, line.privateData.lineId);
				end
			end
		end
	end

	-- Check for interrupt
	if (conversation.privateData.interrupted) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Line was interrupted");

		if (conversation.OnInterrupt) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnInterrupt, conversation, self, false);
			else
				conversation.OnInterrupt(conversation, self, false);
			end
		end

		self:HaltLine(conversation, line, ((type(conversation.privateData.interrupted) == "number" and conversation.privateData.interrupted) or self.interruptOverlapDurationSeconds));

		if (line.OnTagFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineId);
			else
				line.OnTagFinish(line, conversation, self, line.privateData.lineId);
			end
		end

		self:ExpireLine(conversation, line);
	-- Check for request to end conversation early
	elseif (conversation.privateData.endEarly) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Conversation was ended early");

		self:HaltLine(conversation, line);

		if (conversation.OnInterrupt) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnInterrupt, conversation, self, true);
			else
				conversation.OnInterrupt(conversation, self, true);
			end
		end

		self:ExpireLine(conversation, line);
	-- Check character death
	elseif (not self:CanCharacterSpeak(line, conversation)) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Character dead");

		self:HaltLine(conversation, line);

		if (line.OnTagFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineId);
			else
				line.OnTagFinish(line, conversation, self, line.privateData.lineId);
			end
		end

		if (conversation.privateData.TIME_BASED) then
			conversation.privateData.TIME_BASED.nextLine = self:GetNextLine(conversation, line, true, true);
		end

		self:ExpireLine(conversation, line);
	-- Check sleepBefore
	elseif (not line.privateData.preDelayCompleted) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Sleep Before");
		line.privateData.preDelayCompleted = self:GetElapsedTimeOfLine(conversation, line) >= line.privateData.preDelayDurationSeconds;
	-- Check playing
	elseif (not line.privateData.played) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Playing");
		-- Do we need to start?
		if (not line.privateData.playing) then
			local debugString:string = "NarrativeQueueInstance.ProcessLine( '";
			debugString = debugString .. conversation.name;
			debugString = debugString .. "'.lines[";
			debugString = debugString .. line.privateData.lineId;
			debugString = debugString .. "] ) - START PLAYING - Duration: ";
			debugString = debugString .. line.privateData.durationSeconds;
			debugString = debugString .. "s";
			self:DebugPrint(debugString);

			line.privateData.playSecondsOffset = self:GetElapsedTimeOfLine(conversation, line) - line.privateData.preDelayDurationSeconds;

			-- DEBUG CODE ONLY - v-jamcro
			-- NOT_QUITE_RELEASE
			if (debugKeepARecordOfPlayedLines) then
				table.insert(debugLinePlayRecord[line], get_total_game_time_seconds_NOT_QUITE_RELEASE());
			end
			-- DEBUG CODE ONLY - v-jamcro

			self:PlayLine(conversation, line);
		end
	-- Check sleepAfter
	elseif (not line.privateData.postDelayCompleted) then
		self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Sleep After");
		line.privateData.postDelayCompleted = self:GetElapsedTimeOfLine(conversation, line) >= (line.privateData.durationSeconds + line.privateData.preDelayDurationSeconds + line.privateData.postDelayDurationSeconds);

		-- If we are currently skipping to the end of a narrative sequence, always immediately consider all lines 'finished'
		line.privateData.postDelayCompleted = line.privateData.postDelayCompleted or Composer_IsFastForwarding();
	-- Set next line to play
	else
		if (conversation.privateData.TIME_BASED) then
			self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Set Next Line");
			conversation.privateData.TIME_BASED.nextLine = self:GetNextLine(conversation, line, false, false);
			self:DebugPrint("NarrativeQueueInstance.ProcessLine() - Next Line: " .. conversation.privateData.TIME_BASED.nextLine);
		end

		if (line.privateData.started and line.OnFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnFinish, line, conversation, self, line.privateData.lineId);
			else
				line.OnFinish(line, conversation, self, line.privateData.lineId);
			end
		end

		self:ExpireLine(conversation, line);
	end
end

-- Process the currently active line in the convo (TIME_BASED only)
function NarrativeQueueInstance:ProcessCurrentLine(conversation:table):void
	local line:table = conversation.privateData.TIME_BASED.currentLine;

	self:ProcessLine(conversation, line);

	-- Handle interruptions to the conversation.
	if (conversation.privateData.interrupted or conversation.privateData.endEarly) then
		if (self.allowResume) then
			print(conversation.name, ": PLAYING -> INTERRUPTED");
			self:Push(self:Pop(conversation, self.playingConversations), self.delayedConversations);
		else
			self:FinishConversation(conversation);
		end
	end
end

-- Process all active lines in the convo (EVENT_BASED only)
function NarrativeQueueInstance:ProcessAllCurrentLines(conversation:table):void
	-- Process each line
	for lineId, line in hpairs(conversation.privateData.EVENT_BASED.currentLines) do
		self:ProcessLine(conversation, line);
	end

	-- Clean up our currentLines list
	for _, lineId in hpairs(conversation.privateData.EVENT_BASED.finishedLines) do
		conversation.privateData.EVENT_BASED.currentLines[lineId] = nil;
	end
	conversation.privateData.EVENT_BASED.finishedLines = {};

	-- Handle interruptions to the conversation.
	if (conversation.privateData.interrupted or conversation.privateData.endEarly) then
		if (self.allowResume) then
			print(conversation.name, ": PLAYING -> INTERRUPTED");
			self:Push(self:Pop(conversation, self.playingConversations), self.delayedConversations);
		else
			conversation.privateData.EVENT_BASED.ended = true;
		end
	end
end


-- Line State
---------------------------------------------------------------------------

function NarrativeQueueInstance:EvaluateLineSleep(sleepVariable, line:table, conversation:table, lineId):number
	local sleepValue:number = 0;

	if (type(sleepVariable) == "number") then
		sleepValue = sleepVariable;
	elseif (type(sleepVariable) == "function") then
		sleepValue = sleepVariable(line, conversation, self, lineId);
	end

	return sleepValue;
end

function NarrativeQueueInstance:GetNextLine(conversation:table, line:table, failed:boolean, characterWasDead:boolean):number	-- Returns index of next line object in conversation
	local nextLine:number = 0;
	local lineNumber:number = line.privateData.lineId;

	local failedLine:number = ((failed or nil) and line.AfterFailed and line.AfterFailed(line, conversation, self, lineNumber, characterWasDead));
	local playedLine:number = ((not failed or nil) and line.AfterPlayed and line.AfterPlayed(line, conversation, self, lineNumber));

	nextLine = failedLine or playedLine or (lineNumber + 1);

	return nextLine;
end

function NarrativeQueueInstance:GetElapsedTimeOfLine(conversation:table, line:table):number	-- Returns seconds elapsed since this line has started
	return (conversation.privateData.timeElapsedSeconds - line.privateData.startTimeSeconds);
end


-- Audio Functionality
---------------------------------------------------------------------------

function NarrativeQueueInstance:SilenceTag(tagToSilence, objectPlayingTag, targetPlayer):void
	if (tagToSilence) then
		StopDialogOnSpecificClients(tagToSilence, objectPlayingTag, targetPlayer);
	end
end

function NarrativeQueueInstance:SilenceInterruptedLine(interruptedLineDataIndex):void
	local interruptedLineData = self.interruptedLines[interruptedLineDataIndex];

	if (interruptedLineData) then
		self:SilenceTag(interruptedLineData.tag, interruptedLineData.character, interruptedLineData.targetPlayer);
		self.interruptedLines[interruptedLineDataIndex] = nil;
	end
end

function NarrativeQueueInstance:SilenceAllInterruptedLines(linesList):void
	for key, _ in hpairs(linesList) do
		self:SilenceInterruptedLine(key);
	end
end


-- Composition Show Playback
---------------------------------------------------------------------------

--
-- Attempt to play our show(s), do procedural knitting, and run callbacks
--
function NarrativeQueueInstance:StartComposition(conversation:table):void
	local show = conversation.show;
	local playedACinematic = false;
	if (show) then
		conversation.compdata = conversation.compdata or {};

		-- Add Pip properties values to the compdata table
		--self:ConfigurePipProperties(conversation.compdata);

		-- Evaluate show name/ref if dynamic
		if (type(show) == "function") then
			show = show(conversation, self);
		end

		-- Determine if this is a single show, or a list of shows to play simultaneously
		-- List of shows
		if (type(show) == "table") then
			-- NOT CURRENTLY SUPPORTED
			if (conversation.chain) then
				print("ERROR: Attempted to chain conversation '" .. conversation.name .. "'");
				print("       This is a multi-show conversation!");
				print("       Chaining is only supported for 1-show convos.");
				return;
			end

			local compdataList = {};

			local showIds = {};
			showIds.totalCount = #show;
			showIds.currentCount = showIds.totalCount;
			for i=1,showIds.totalCount do
				if (conversation.compdata.compdataList) then
					if (conversation.privateData.EVENT_BASED) then
						conversation.compdata.compdataList[i] = self:ConfigureCompdataForEventBased(conversation.compdata.compdataList[i], conversation);
					end
					compdataList[i] = conversation.compdata.compdataList[i];
				else
					compdataList[i] = conversation.compdata;
				end

				compdataList[i] = table.copy(compdataList[i], false);
				playedACinematic = playedACinematic or ((type(show[i]) == "string" and Composer_IsCinematic(show[i])) or Composer_IsCinematicTag(show[i]));
				showIds[i] = self:StartCompositionInternal(show[i], compdataList[i], conversation, i);
				if (not not showIds[i]) then
					if (conversation.OnShowStart) then
						if (self.callbacksInSeparateThreads) then
							CreateThread(conversation.OnShowStart, conversation, self, showIds[i], i);
						else
							conversation.OnShowStart(conversation, self, showIds[i], i);
						end
					end
				else
					self:DebugPrint("StartComposition - Show[", i, "]", show[i], "in conversation", conversation.name, "failed to start!");
				end
			end
			conversation.privateData.showId = showIds;
			
		-- Single show
		else
			-- For both stand-alone single shows and root convos of chains
			-- Inject Play and End callbacks into compdata table for each convo in a chain (or just this convo)
			if (not conversation.chain or not conversation.chain.prev) then
				local processedList = {};
				local currentConvo = conversation;
				while (currentConvo and not processedList[currentConvo]) do
					if (NarrativeQueuePrivates.ConvoHasPrivateData(currentConvo)) then
						if (not currentConvo.compdata.compdataList and currentConvo.privateData.EVENT_BASED) then
							-- Is Cinematic
							currentConvo.privateData.showIsCinematic = ((type(show) == "string" and Composer_IsCinematic(show)) or Composer_IsCinematicTag(show));
							playedACinematic = playedACinematic or currentConvo.privateData.showIsCinematic;
					
							-- Should Hide Stowed
							local hideStowed = currentConvo.forceHideStowedWeapon
											   or (currentConvo.privateData.showIsCinematic
												   and not currentConvo.alwaysShowStowedWeapon);

							-- Inject Play and End callbacks into the compdata table
							currentConvo.compdata = self:ConfigureCompdataForEventBased(currentConvo.compdata, currentConvo, hideStowed);
					
							-- Update the chain
							if (currentConvo.chain and currentConvo.chain.prev) then
								currentConvo.chain.prev.compdata.NextShow = currentConvo.show;
								currentConvo.chain.prev.compdata.NextShowState = currentConvo.compdata;
							end
						end
					else
						print("ERROR: Attempted to initialize compdata for convo", currentConvo.name);
						print("       This convo has not yet been queued!  Ignoring.");
					end
					
					-- Next node
					processedList[currentConvo] = true;  -- Infinite recursion guard
					currentConvo = currentConvo.chain and currentConvo.chain.next;
				end
				processedList = nil;
			end

			-- Single show in a chain
			if (conversation.chain and conversation.chain.prev) then
				conversation.privateData.showId = conversation.chain.prev.compdata.NextShowId;

			-- Single stand-alone show
			else
				conversation.privateData.showId = self:StartCompositionInternal(show, conversation.compdata, conversation);
			end

			-- Run cleanup on Ping Lines if we started a cinematic composition
			if (playedACinematic and not conversation.doNotClearPingLines) then
				RemoveAllPingLines();
			end

			-- Run the OnShowStart callback
			if (not not conversation.privateData.showId) then
				if (conversation.OnShowStart) then
					if (self.callbacksInSeparateThreads) then
						CreateThread(conversation.OnShowStart, conversation, self, conversation.privateData.showId);
					else
						conversation.OnShowStart(conversation, self, conversation.privateData.showId);
					end
				end
			else
				self:DebugPrint("StartComposition - Show", show, "in conversation", conversation.name, "failed to start!");
			end
		end
	end
end

--
-- Resolve the show reference and actually play the show
--
function NarrativeQueueInstance:StartCompositionInternal(show:any, compdata:table, conversation:table, showIndex:number):number
	local showId:number = nil;
	
	-- Evaluate show name/ref if dynamic
	if (type(show) == "function") then
		show = show(conversation, self);
	end

	if (type(show) == "table") then
		error("ERROR : Conversation system does not support a table of functions that return tables of shows!  Pick one relationship or the other; not both.");
	end

	-- Attempt to play the show
	local useScriptDialog = conversation.privateData.EVENT_BASED ~= nil;
	if (type(show) == "string") then
		if (cinematic_play_shot_list_with_lua_state ~= nil and CinematicRecordingInProgress() and not CinematicRecordingIsRealtime() and (not showIndex or showIndex == 1)) then
			cinematic_play_shot_list_with_lua_state(show, false, -1, compdata, useScriptDialog);
		else
			showId = composer_play_show(show, compdata, useScriptDialog);
			self:DebugPrint("Convo", conversation.name, "starting show", show, "using 'composer_play_show', with showId", showId);
		end
	elseif (type(show) == "ui64") then
		local callSucceeded, errorMsg = pcall (function() showId = composer_play_show_tag(show, compdata, useScriptDialog); end);
		if (not callSucceeded) then
			FireTelemetryEvent("NarrativeQueueCompositionFailed", { conversationName = conversation.name, errorMessage = errorMsg, });
			print("ERROR :: Conversation", conversation.name, "failed to play show by tag-reference!");
		end
		self:DebugPrint("Convo", conversation.name, "starting show", show, "using 'composer_play_show_tag', with showId", showId);
	else
		print("WARNING: Conversation '", conversation.name, "' was provided with invalid 'show' '", show, "'.  Was not a show name (string) or tag reference (ui64).");
		showId = nil;
	end

	return showId;
end

--
-- Set procedural hooks and other automatic behavior used by compositions via the state table
--
function NarrativeQueueInstance:ConfigureCompdataForEventBased(compdata:table, conversation:table, hideStowed:boolean):table
	self:DebugPrint("StartComposition - We are Event-Based!");
	compdata = compdata or {};
	compdata.thisConvo = conversation;
	compdata.callbacks = compdata.callbacks or {};
	compdata.callbacks.PlayLine = function(myState:table, lineId:string, debugPrint:boolean):void
		NarrativeInterface.SendLineReadyEvent(myState.thisConvo.name, lineId);
		if (debugPrint) then print("Convo", myState.thisConvo.name, "playing line", lineId); end
	end;
	compdata.callbacks.EndConversation = function(myState:table, debugPrint:boolean):void
		NarrativeInterface.SendConversationEndingEvent(myState.thisConvo.name);
		if (debugPrint) then print("Convo", myState.thisConvo.name, "ending."); end
	end;

	-- Hide stowed weapon
	if (hideStowed) then
		local tempStartScript = compdata.StartScript;
		local tempEndScript = compdata.EndScript;

		compdata.StartScript = function(state:table)
			--print("Hiding stowed weapons...");
			for index,currentPlayer in ipairs (players()) do
				--print("...player", index, "hidden stow");
				-- Hide currently stowed weapon
				Unit_HideStowedWeapons(currentPlayer, true);
				-- Hide currently held weapon when it's stowed
				Unit_ForceHideStowedWeapons(currentPlayer, true);
			end

			if (tempStartScript) then
				tempStartScript(state);
			end
		end;

		compdata.EndScript = function(state:table)
			--print("Unhiding stowed weapons...");
			for index,currentPlayer in ipairs (players()) do
				--print("...player", index, "showing stow");
				Unit_HideStowedWeapons(currentPlayer, false);
				Unit_ForceHideStowedWeapons(currentPlayer, false);
			end

			if (tempEndScript) then
				tempEndScript(state);
			end
		end;
	end

	return compdata;
end

--function NarrativeQueueInstance:ConfigurePipProperties(compdata:table):void
--	-- TEMP MVP BEHAVIOR - jacrowde 2019 - Eventually replace this with in-composition camera control
--	local pip0Distance = 0.14;
--	local pip0Height = 0.53;
--	local pip0FovDegrees = 35.2;
--
--	local pip1Distance = 0.14;
--	local pip1Height = 0.58;
--	local pip1FovDegrees = 35.2;
--
--	if (compdata) then
--		if (compdata.pip0) then
--			pip0Distance = compdata.pip0.distance or pip0Distance;
--			pip0Height = compdata.pip0.height or pip0Height;
--			pip0FovDegrees = compdata.pip0.fov or pip0FovDegrees;
--		end
--
--		if (compdata.pip1) then
--			pip1Distance = compdata.pip1.distance or pip1Distance;
--			pip1Height = compdata.pip1.height or pip1Height;
--			pip1FovDegrees = compdata.pip1.fov or pip1FovDegrees;
--		end
--	end
--
--	narrative_view_set_cam_distance_scalar("pip0", pip0Distance);
--	narrative_view_set_cam_height_scalar("pip0", pip0Height);
--	narrative_view_set_cam_fov("pip0", pip0FovDegrees);
--
--	narrative_view_set_cam_distance_scalar("pip1", pip1Distance);
--	narrative_view_set_cam_height_scalar("pip1", pip1Height);
--	narrative_view_set_cam_fov("pip1", pip1FovDegrees);
--	-- TEMP MVP BEHAVIOR - jacrowde 2019
--end

function NarrativeQueueInstance:ProcessCompositionEnd(conversation:table, showIndex:number):void
	if (conversation.privateData.showId) then
		if (conversation.OnShowFinish and type(conversation.OnShowFinish) == "function") then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnShowFinish, conversation, self, conversation.privateData.showId, showIndex);
			else
				conversation.OnShowFinish(conversation, self, conversation.privateData.showId, showIndex);
			end
		end

		if (showIndex and type(conversation.privateData.showId) == "table") then
			conversation.privateData.showId[showIndex] = nil;
			conversation.privateData.showId.currentCount = conversation.privateData.showId.currentCount - 1;

			if (conversation.privateData.showId.currentCount == 0) then
				conversation.privateData.showId = nil;
			end
		else
			conversation.privateData.showId = nil;
		end
	end
end

function NarrativeQueueInstance:EndComposition(conversation:table):void
	if (conversation.privateData.showId) then
		if (type(conversation.privateData.showId) == "table") then
			for i=1,conversation.privateData.showId.totalCount do
				if (not conversation.privateData.showId) then
					return;
				end

				if (conversation.privateData.showId[i]) then
					composer_stop_show(conversation.privateData.showId[i]);
					NarrativeQueueInstance:ProcessCompositionEnd(conversation, i);
				end
			end
		elseif (not conversation.doNotKillShow) then
			composer_stop_show(conversation.privateData.showId);
			NarrativeQueueInstance:ProcessCompositionEnd(conversation);
		end
	end
end


-- NarrativeQueueInstance Message Pump
---------------------------------------------------------------------------

function NarrativeQueueInstance:Update():void	-- BONUS TODO
	--self:DebugPrint("Entering NarrativeQueueInstance.Update().");

	if (self.updateIsRunning) then
		error("ERROR - NarrativeQueueInstance:Update() is already running.  Attempted to start a second Update thread.");
	else
		self.updateIsRunning = true;
	end

	-- Only one queue update should ever run.  Make sure it's the most recent one.
	self.currentRunningId = self.currentRunningId + 1;
	local runningId:number = self.currentRunningId;

	self.TimeElapsedSeconds = 0;

	local lastTimestamp:time_point = Game_TimeGet();
	local thisTimestamp:time_point = lastTimestamp;

	local frameDeltaSeconds:number = 0;	--self.updateFrequency;

	local currentTimeStamp:time_point = nil;
	local needFrameErrorReported:boolean = true;

	while (self.isActive and runningId == self.currentRunningId) do
		local readyToStartConvos:table = {};
		local notReadyConvos:table = {};

		--SleepUntil ([| not self:IsThreadPaused() ], self.pauseUpdateFrequency);

		self.threadLocked = true;

		-- Guard against outsider Sleep's >:(
		currentTimeStamp = Game_TimeGet();
		needFrameErrorReported = true;

		-- Check Pending --
		-- ===========================================================================
		for key, convo in hpairs(self.pendingConversations) do
			convo.privateData.timePendingSeconds = convo.privateData.timePendingSeconds + frameDeltaSeconds;
			convo.privateData.timeSinceLastCheckSeconds = convo.privateData.timeSinceLastCheckSeconds + frameDeltaSeconds;

			-- A result of 'nil' tells us to ignore the convo this tick due to its check frequency
			local result:boolean = self:CheckPendingCanPlay(convo);
			if (result == false) then
				table.insert(notReadyConvos, convo);
			elseif (result) then
				table.insert(readyToStartConvos, convo);
			end
		end

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentTimeStamp ~= Game_TimeGet()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred CHECKING PENDING conversations");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred CHECKING conversations");
		end

		-- Check and start all ready-to-start Pending conversations that survived pre-screening
		self:ResolveReadyToPlay(readyToStartConvos, notReadyConvos);
		readyToStartConvos = {};

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentTimeStamp ~= Game_TimeGet()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred while starting a new conversation");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred while starting a new conversation");
		end
		-- ===========================================================================

		-- Check Playing --
		-- ===========================================================================
		for key, convo in hpairs(self.playingConversations) do
			local currentIterationActive = true;	-- We are stuck on Lua 5.1, which has neither 'goto' (Lua 5.2) nor 'continue'
			convo.privateData.timeElapsedSeconds = convo.privateData.timeElapsedSeconds + frameDeltaSeconds;

			-- [] Check to see if this convo's show ended on its own since last tick
			local showIsStillRunning = false;
			if (convo.privateData.showId) then
				if (type(convo.privateData.showId) == "table") then
					for i=1,convo.privateData.showId.totalCount do
						-- When the final show terminates, our 'showId' field is invalidated, so we should stop checking it
						if (not convo.privateData.showId) then break; end

						if (convo.privateData.showId[i] and not composer_show_is_playing(convo.privateData.showId[i])) then
							NarrativeQueueInstance:ProcessCompositionEnd(convo, i);
						else
							showIsStillRunning = true;
						end
					end
				else
					if (not composer_show_is_playing(convo.privateData.showId)) then
						NarrativeQueueInstance:ProcessCompositionEnd(convo);
					else
						showIsStillRunning = true;
					end
				end
			end

			-- [] Check "Stuck Playing" timeout and emergency eject if exceeded
			local maxPlayingTime = convo.privateData.MaxPlayingTime and convo.privateData.MaxPlayingTime(convo, self);
			if ((not editor_mode()) and maxPlayingTime and (maxPlayingTime > 0) and (maxPlayingTime < convo.privateData.timeElapsedSeconds)) then	-- Faber can break this, so... no Faber telemetry
				print("WARNING :: Conversation", convo.name, "played longer than expected :", maxPlayingTime, " - force-terminated after", convo.privateData.timeElapsedSeconds, "seconds.");
				print("  :: THIS IS NEVER EXPECTED BEHAVIOR.");
				FireTelemetryEvent("ConvoExceededMaxPlaytime", { conversationName = convo.name, maxPlayingTime = maxPlayingTime, timeElapsedSeconds = convo.privateData.timeElapsedSeconds, });

				-- End the conversation
				self:FinishConversation(convo);
				currentIterationActive = false;
			end

			-- [] Check convo preDelay (sleepBefore)
			if (currentIterationActive and not convo.privateData.preDelayCompleted) then
				convo.privateData.preDelayCompleted = convo.privateData.timeElapsedSeconds >= convo.privateData.preDelayDurationSeconds;

				if (convo.privateData.preDelayCompleted) then
					if (convo.OnStart) then
						if (self.callbacksInSeparateThreads) then
							CreateThread(convo.OnStart, convo, self);
						else
							convo.OnStart(convo, self);
						end
					end

					-- Play associated composition if supplied
					if (not self.preventConversations) then self:StartComposition(convo); end

					-- Notify Audio that a conversation has started
					AudioMixStates.ConversationStartedMixState(convo.name);
				else
					currentIterationActive = false;
				end
			end

			-- [] If we're past the preDelay and haven't yet played all lines
			if (currentIterationActive and not self.preventConversations and not convo.privateData.linesCompletedTimeSeconds) then
				currentIterationActive = false;	-- We assume line-processing is the last step of the frame for this convo, unless it completes its final line this frame
				if (convo.privateData.EVENT_BASED) then
					-- For each playing line, update line
					self:ProcessAllCurrentLines(convo);

					if (not convo.privateData.EVENT_BASED.ended) then
						-- For each ready line, check for and resolve collisions, then play line
						self:StartAllReadyLines(convo);

						-- After processing the current list of new lines, check to see if we have been told to end
						convo.privateData.EVENT_BASED.ended = convo.privateData.EVENT_BASED.ending;
					else
						-- If we are not a cinematic sequence, we can try and finish all the lines that got in before the buzzer
						if (not convo.privateData.showIsCinematic) then
							for lineId, line in hpairs(convo.privateData.EVENT_BASED.readyLines) do
								print("WARNING: After conversation '", convo.name, "' was marked as 'ended', line '", lineId, "' was told start.  Line will not be started.");
							end
							convo.privateData.EVENT_BASED.readyLines = {};

							-- If the convo has been told to wrap things up, and all lines have triggered, then we are done
							if (ExtendedTable.TableIsEmpty(convo.privateData.EVENT_BASED.currentLines)) then
								convo.privateData.linesCompletedTimeSeconds = convo.privateData.timeElapsedSeconds;
								currentIterationActive = true;
							end
						-- For cinematics, the conversation needs to own everything in it.  If we are ending a cinematic conversation, we need to halt all currently-playing lines (like when Player SKIPS a cutscene)
						else
							self:HaltAllLines(convo);
							convo.privateData.linesCompletedTimeSeconds = convo.privateData.timeElapsedSeconds;
							currentIterationActive = true;
						end
					end
				elseif (convo.privateData.TIME_BASED) then
					-- If we need to start a new line
					if (not convo.privateData.TIME_BASED.currentLine or convo.privateData.TIME_BASED.nextLine) then
						self:StartNextLine(convo);
					-- If we need to update a currently-playing line
					else
						self:ProcessCurrentLine(convo);
					end
				end
			end

			-- [] Check convo postDelay (sleepAfter)
			if (currentIterationActive and not convo.privateData.postDelayCompleted) then
				convo.privateData.postDelayCompleted = self.preventConversations or ((not self.playFullCompositions or (self.playFullCompositions and not showIsStillRunning)) and ((convo.privateData.timeElapsedSeconds - convo.privateData.linesCompletedTimeSeconds) >= convo.privateData.postDelayDurationSeconds));

				if (convo.privateData.postDelayCompleted) then
					--self:DebugPrint("Conversation '" .. convo.name .. "' FINISHED");
					self:FinishConversation(convo);
				end
			end
		end

		-- [] Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentTimeStamp ~= Game_TimeGet()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred PLAYING conversations");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred PLAYING conversations");
		end
		-- ===========================================================================

		-- Timeout and Cleanup --
		-- ===========================================================================
		--self:DebugPrint("Update() - Resolve Still Pending[" .. table.maxn(notReadyConvos) .. "]");
		-- Check all still-pending conversations for timeout
		for key, convo in hpairs(notReadyConvos) do
			self:HandlePendingTimeout(convo);
		end

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentTimeStamp ~= Game_TimeGet()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred CHECKING TIMEOUT conversations");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred CHECKING TIMEOUT conversations");
		end

		-- Check all previously-interrupted, lingering sound tags to see if they're ready to be silenced
		local expiredTags:table = {};
		for key, lineData in hpairs(self.interruptedLines) do
			lineData.durationSeconds = lineData.durationSeconds - frameDeltaSeconds;

			if (lineData.durationSeconds <= 0) then
				expiredTags[key] = true;
			end
		end
		self:SilenceAllInterruptedLines(expiredTags);

		-- Wait until next desired updated tick
		self.threadLocked = false;

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentTimeStamp ~= Game_TimeGet()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred during a single tick of NarrativeQueueInstance.Update()");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred during a single tick of NarrativeQueueInstance.Update()");
		end
		-- ===========================================================================

		Sleep(self.updateFrequency);

		local tempTimestamp:time_point = Game_TimeGet();
		lastTimestamp = thisTimestamp;
		thisTimestamp = tempTimestamp;

		frameDeltaSeconds = thisTimestamp:ElapsedTime(lastTimestamp);

		--print("Frame Delta : ", frameDeltaSeconds);

		-- Update 'time elapsed' since initializing the queue (timing)
		self.TimeElapsedSeconds = self.TimeElapsedSeconds + frameDeltaSeconds + self.timeSpentPaused;
		self.timeSpentPaused = 0;
	end

	self.updateIsRunning = false;

	--self:DebugPrint("Exiting NarrativeQueueInstance.Update().");
end


-- Debugging and Reporting
---------------------------------------------------------------------------

function NarrativeQueueInstance:DebugPrint(...):void
	if self.showPrintMessages == true then
		print(...);
	end
end



-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Run On Client :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

--## CLIENT


-- Debugging and Reporting
---------------------------------------------------------------------------

-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
global recordOfLinesPlayed = {};
global debugKeepARecordOfPlayedLines = false;

function RegisterSoundRequestReceived(snd:tag)
	if (debugKeepARecordOfPlayedLines and snd) then
		recordOfLinesPlayed[snd] = recordOfLinesPlayed[snd] or {};
		table.insert(recordOfLinesPlayed[snd], game_tick_get());
	end
end

function DebugPrintRegisteredSoundRequests(snd:tag, prefix)
	if (snd) then
		if (not prefix) then
			print(snd, " played - ");
		end

		local str = prefix or "";

		for _, time in hpairs(recordOfLinesPlayed[snd]) do
			str = str .. time .. ", ";
		end

		print(str);
	end
end

function DebugPrintTestConvo()
	local line = 1;

	-- NOTE: sound tags commented out in purge of legacy Halo 5 content

	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Tanaka_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_elevatorpa_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Buck_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Tanaka_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_07400.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_vale_03200.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_tanaka_00400.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_01000.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00400.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_04607.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00700.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_03600.sound'), "[" .. line .. "] : "); line = line + 1;
	--DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_02000.sound'), "[" .. line .. "] : "); line = line + 1;
end
-- -- DEBUG CODE ONLY - v-jamcro

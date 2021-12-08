

--## SERVER


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation Enumerations :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global CONVO_RESUME:table = table.makeEnum{
	ListenerAsk		= 1,
	SpeakerResume	= 2,
	Automatic		= 3,
	--------------------
	_count			= 3,
};

global CONVO_STATUS:table = table.makeEnum{
	pending = 1,
	playing = 2,
	delayed = 3,
	dead	= 4,
	------------
	_count	= 4,
};


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Queue Default Methods ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global NarrativeQueueDefaults = {
	minLineDelaySec = 0.5,
	lineDelayVariationSec = 0.5,
};

function NarrativeQueueDefaults.CheckFrequency()
	return 1/6; -- By default checks every 1/6th of a second.
end

function NarrativeQueueDefaults.Timeout(thisConvo:table, queue:table):number
	return (thisConvo and thisConvo.name and (thisConvo.privateData.timeoutDurationSeconds or CONVO_PENDING_TIMEOUT_LUT[thisConvo.name])) or 300; -- By default, conversations are allowed to be "pending" in the queue for 5 minutes
end

function NarrativeQueueDefaults.MaxPlayingTime(thisConvo:table, queue:table):number
	return (thisConvo and thisConvo.name and (thisConvo.privateData.maxDurationSeconds or CONVO_ESCAPE_CLAW_PLAYING_LUT[thisConvo.name])) or 120; -- By default, conversations are allowed to be playing for no longer than 2 minutes
end

function NarrativeQueueDefaults.LineDelay(thisLine:table, thisConvo:table, queue:table, lineId:any):number
	local minLineDelaySec = thisLine.minLineDelaySec or thisConvo.minLineDelaySec or NarrativeQueueDefaults.minLineDelaySec;
	local lineDelayVariationSec = thisLine.lineDelayVariationSec or thisConvo.lineDelayVariationSec or NarrativeQueueDefaults.lineDelayVariationSec;
	return minLineDelaySec + (math.random() * lineDelayVariationSec);
end

function NarrativeQueueDefaults.SetLineDelay(minLineDelaySec:number, lineDelayVariationSec:number):void
	NarrativeQueueDefaults.minLineDelaySec = minLineDelaySec or NarrativeQueueDefaults.minLineDelaySec;
	NarrativeQueueDefaults.lineDelayVariationSec = lineDelayVariationSec or NarrativeQueueDefaults.lineDelayVariationSec;
end


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Queue Lookup Tables :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global CONVO_PENDING_TIMEOUT_LUT = {
	-- Add overrides for PENDING Timeouts on a per-conversation basis here
--	conv_name											= time_in_seconds_before_timeout,

	-- m00/m01 intro
	m00pilot_m0_01										= math.huge,	-- 01_M00_Reverie
	m00pilot_m00_05										= math.huge,
	m00pilot_m0_08a										= math.huge,	
	m00pilot_m0_09										= math.huge,
	m01banished_m01_02_alt								= math.huge,
	m00_intro											= math.huge,
};

global CONVO_ESCAPE_CLAW_PLAYING_LUT = {

	-- TEST LEVELS
	test_pelican_seq									= math.huge,
};


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation - Common Functions ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global CONVO_DEFAULT_BEHAVIORS = {


	OnStart = function (thisConvo:table, queue:table)
		print(thisConvo.name, " narrative");
	end,
	DeletedLineIf = function() return false; end,
};

global CONVO_CHARACTER_FNC = {


	GetPlayer = function (thisLine:table, thisConvo:table, queue:table, lineId)
		return PLAYERS.player0;
	end,

	GetPuppet = function (thisLine:table, thisConvo:table, queue:table, lineId, showIndex:number)
		local showId = thisConvo:GetShowId();
		showIndex = showIndex or 1;

		if (showId) then
			if (type(showId) == "table")  then
				return composer_get_puppet_from_show(thisLine.moniker, showId[showIndex]);
			else
				return composer_get_puppet_from_show(thisLine.moniker, showId);
			end
		else
			print("ALERT : Conversation", thisConvo.name, ", Line", thisLine.privateData.lineId, " is attempting to evaluate its 'character' field for moniker '", thisLine.moniker);
			print("        but has no show playing!");
			return nil;
		end
	end,

	GetCharacterFromMoniker = function (thisLine:table, thisConvo:table, queue:table, lineId)
		if (CONVO_NAMED_CHARACTER[thisLine.moniker]) then
			return CONVO_NAMED_CHARACTER[thisLine.moniker](thisLine, thisConvo, queue, lineId);
		else
			print(":! :! | WARNING | !: !: Line '", thisLine.privateData.lineId, "' of conversation ", thisConvo.name, " attempted to get character for moniker '", thisLine.moniker, "'.  No mapping exists.");
			return nil;
		end
	end,
};

global CONVO_NAMED_CHARACTER = {


	Masterchief = function (thisLine:table, thisConvo:table, queue:table, lineId)
		-- TODO - Stubbed function.  Replace return value once named-character providers are implemented in Lua
		return CONVO_CHARACTER_FNC.GetPlayer(thisLine, thisConvo, queue, lineId);
	end,

	Cortana = function (thisLine:table, thisConvo:table, queue:table, lineId)
		-- TODO - Stubbed function.  Replace return value once named-character providers are implemented in Lua
		return nil;
	end,

	Weapon = function (thisLine:table, thisConvo:table, queue:table, lineId)
		-- TODO - Stubbed function.  Replace return value once named-character providers are implemented in Lua
		return nil;
	end,

	Pilot = function (thisLine:table, thisConvo:table, queue:table, lineId)
		-- TODO - Stubbed function.  Replace return value once named-character providers are implemented in Lua
		return nil;
	end,
};

global CONVO_LINE_FNC = {


	NextLine = function (thisLine:table, thisConvo:table, queue:table, lineNumber:number, characterWasDead:boolean)
		return (lineNumber + 1);
	end,

	EndOnDeathElseNextLine = function (thisLine:table, thisConvo:table, queue:table, lineNumber:number, characterWasDead:boolean)
		return (characterWasDead and 0) or (lineNumber + 1);
	end,

	EndConvo = function (thisLine:table, thisConvo:table, queue:table, lineId, characterWasDead:boolean)
		return 0;
	end,

	ContinueCompositionOnStart = function (thisLine:table, thisConvo:table, queue:table, lineId)
		thisConvo.compdata.continue = true;
	end,
};



-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Narrative Helpers :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global NarrativeHelpers = {};

function NarrativeHelpers.GetConvoLineCount(convo:table):number
	return table.count(convo.lines);
end

local function __Narrative_ConvoGetNextRandom(self):table
	--print("convo:GetNextRandom() : Current bank:", (self.__RandomLineRecord.currentBank and "true") or "false");

	-- Ensure valid banks for first-time run, or after convo is procedurally modified at runtime
	local currentBank = self.__RandomLineRecord[self.__RandomLineRecord.currentBank];
	local altBank = self.__RandomLineRecord[not self.__RandomLineRecord.currentBank];
	local linesCount = NarrativeHelpers.GetConvoLineCount(self);	-- Can't use #table here, because that only works for Time-based, which use array-style table indices.  Event-based uses dictionary-style
	local curCount = #currentBank;
	local altCount = #altBank;
	if (linesCount ~= curCount + altCount) then
		--print("convo:GetNextRandom() : line-count", linesCount, "did not match current count:", curCount, "+", altCount);
		self.__RandomLineRecord.InitializeRandom(self);

		-- The table instances have changed
		currentBank = self.__RandomLineRecord[self.__RandomLineRecord.currentBank];
		altBank = self.__RandomLineRecord[not self.__RandomLineRecord.currentBank];
		curCount = #currentBank;
		altCount = #altBank;
	end

	-- Debug : Visualize the banks
	------------------------------------
	--print("[true] = {");
	--for i=0,#self.__RandomLineRecord[true] do
	--	print("   ", self.__RandomLineRecord[true][i]);
	--end
	--print("}");
	--print("[false] = {");
	--for i=0,#self.__RandomLineRecord[false] do
	--	print("   ", self.__RandomLineRecord[false][i]);
	--end
	--print("}");
	------------------------------------


	-- Get next random
	if (curCount == 1) then
		--print("convo:GetNextRandom() : Last item in the bank!");
		-- Switch banks and return last random item of old bank
		self.__RandomLineRecord.currentBank = not self.__RandomLineRecord.currentBank;
		return currentBank[1];  -- Leave the last item in the old bank, since we've now "already played it""
	elseif (curCount > 1) then
		--print("convo:GetNextRandom() : Not last item.", curCount, "remaining");
		-- Select a random entry and move it to the alt bank
		local randIndex = math.random(curCount);
		local selection = table.remove(currentBank, randIndex);
		table.insert(altBank, selection);
		--print("convo:GetNextRandom() : Selected", selection);
		return selection;
	end

	-- Failed to get a random item
	--print("ERROR: convo.GetNextRandom() for convo", convo.name, "failed to get any random lines!");
	return nil;
end

local function __Narrative_InitializeRandomLineRecord(conversation:table):void
	-- Reset the banks
	conversation.__RandomLineRecord[conversation.__RandomLineRecord.currentBank] = {};
	conversation.__RandomLineRecord[not conversation.__RandomLineRecord.currentBank] = {};

	-- Repopulate the current bank
	for _,line in hpairs(conversation.lines) do
		table.insert(conversation.__RandomLineRecord[conversation.__RandomLineRecord.currentBank], line);
	end
end

-- Usage:
--  local randomUnplayedLine:table = convo:GetNextRandom();
function NarrativeHelpers.SetNextRandomBehavior(convo:table):void
	if (not convo) then return; end

	-- Assign a random management subtable to this convo
	convo.__RandomLineRecord = {
		[true] = {},
		[false] = {},
		currentBank = false,
		InitializeRandom = __Narrative_InitializeRandomLineRecord,
	};

	-- Set up the random function
	convo.GetNextRandom = __Narrative_ConvoGetNextRandom;
end

function NarrativeHelpers.ResolveConversationTag(convo:table):tag
	return (convo.tagOverride and Conversation_IsValid(convo.tagOverride) and convo.tagOverride) or (convo.tag and Conversation_IsValid(convo.tag) and convo.tag) or nil;
end



-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: AI Chatter/DDS Suppression :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global AIDialogManager:table = {

	disableAIDialogCount = 0,
	disableAISpecifically = nil,	-- Due to engine-side limitations, we can only have a single SPECIFIC ai disabled at a time

	-- Debug
	showPrintMessages = false,
};


function AIDialogManager.DebugPrint(...):void
	if AIDialogManager.showPrintMessages == true then
		print(...);
	end
end

function AIDialogManager.DisableAIDialog(targetAi):void
	if (targetAi) then		
		if (not AIDialogManager.disableAISpecifically) then
			AIDialogManager.disableAISpecifically = targetAi;
			ai_actor_dialogue_enable(targetAi, false);
			AIDialogManager.DebugPrint("AI Actor Dialog Disabled for actor ", targetAi); 
		elseif (AIDialogManager.disableAISpecifically ~= targetAi) then
			-- Re-enable the previously-disabled actor
			ai_actor_dialogue_enable(AIDialogManager.disableAISpecifically, true);
			AIDialogManager.DebugPrint("AI Actor Dialog automatically Re-Enabled for actor ", targetAi); 

			-- Then disable the specified actor
			AIDialogManager.disableAISpecifically = targetAi;
			ai_actor_dialogue_enable(targetAi, false);
			AIDialogManager.DebugPrint("AI Actor Dialog Disabled for actor ", targetAi); 
		else
			AIDialogManager.DebugPrint("AI Actor Dialog was already previously Disabled for actor ", targetAi, ".  Ignoring."); 
		end
	else
		if (AIDialogManager.disableAIDialogCount <= 0) then
			AIDialogManager.disableAIDialogCount = 1;
		else
			AIDialogManager.disableAIDialogCount = AIDialogManager.disableAIDialogCount + 1;
		end
		
		ai_dialogue_enable(false);
		AIDialogManager.DebugPrint("AI Dialog Disabled (Current disabled level: " .. AIDialogManager.disableAIDialogCount .. ")"); 
	end
end

function AIDialogManager.EnableAIDialog(targetAi):void
	if (targetAi) then
		if (AIDialogManager.disableAISpecifically == targetAi) then
			AIDialogManager.disableAISpecifically = nil;
			ai_actor_dialogue_enable(targetAi, true);
			AIDialogManager.DebugPrint("AI Actor Dialog Enabled for actor ", targetAi); 
		else
			AIDialogManager.DebugPrint("AI Actor Dialog was already previously Enabled for actor ", targetAi, ".  Ignoring."); 
		end
	else	
		if (AIDialogManager.disableAIDialogCount > 0) then
			AIDialogManager.disableAIDialogCount = AIDialogManager.disableAIDialogCount - 1;		
			ai_dialogue_enable(true);
		else
			AIDialogManager.disableAIDialogCount = 0;
		end

		AIDialogManager.DebugPrint("AI Dialog Enabled (Current disabled level: " .. AIDialogManager.disableAIDialogCount .. ")"); 
	end
end

function AIDialogManager.ForceResetAIDialogManager(targetAi):void
	if (targetAi) then
		AIDialogManager.DebugPrint("AIDialogManager.ForceEnableAIDialog(", targetAi, ")"); 

		AIDialogManager.disableAISpecifically[targetAi] = 0;
		ai_actor_dialogue_enable(targetAi, true);
	else
		AIDialogManager.DebugPrint("AIDialogManager.ForceEnableAIDialog()"); 
	
		for i=1,AIDialogManager.disableAIDialogCount do
			ai_dialogue_enable(true);
		end

		AIDialogManager.disableAIDialogCount = 0;
	end
end



-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::: Mathematical Set Functionality :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global MathematicalSet:table = {

	metatable = {},
};

function MathematicalSet.IndexedTableToSet(indexedTable:table):table	-- Returns a MathematicalSet containing an entry for each value in the provided table
	local newSet:table = {};
	setmetatable(newSet, MathematicalSet.metatable);
	
	for key, value in hpairs(indexedTable) do
		--print("added entry to set");
		newSet[value] = true;
	end
	
	return newSet;
end

function MathematicalSet.Create():table	-- Returns an empty MathematicalSet
	return MathematicalSet.IndexedTableToSet({});
end

function MathematicalSet.SetToTableWithUniqueEntries(set:table):table	-- Returns indexed table with unique entries from MathematicalSet
	local uniqueTable:table = {};
	
	for key, value in hpairs(set) do
		table.insert(uniqueTable, key);
	end
	
	return uniqueTable;
end

function MathematicalSet.AddValueToSet(set:table, value):void
	set[value] = true;
end

function MathematicalSet.GetIntersection(lhSet:table, rhSet:table):table	-- Returns a MatehmaticalSet containing the intersection of elements between l and r (empty set if no overlap)
	local intersection:table = MathematicalSet.Create();
	
	for key, value in hpairs(lhSet) do
		intersection[key] = rhSet[key];
	end
	
	return intersection;
end
	
function MathematicalSet.GetUnion(lhSet:table, rhSet:table):table	-- Returns a MatehmaticalSet containing the union of elements between l and r
	local union:table = MathematicalSet.Create();
	
	for key, value in hpairs(lhSet) do
		union[key] = true;
	end
	
	for key, value in hpairs(rhSet) do
		union[key] = true;
	end
	
	return union;
end

MathematicalSet.metatable.__mul = MathematicalSet.GetIntersection;
MathematicalSet.metatable.__add = MathematicalSet.GetUnion;



-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Extended Table Helpers :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global ExtendedTable:table = {

};

function ExtendedTable.TableToString(checkTable:table):string	-- Returns string representation of a table (recursive)
	local str:string = "{ ";

	for key, value in hpairs(checkTable) do
		str = str .. "[";
		str = str .. ExtendedTable.ObjectToString(key);
		str = str .. "] = ";
		str = str .. ExtendedTable.ObjectToString(value);
		str = str .. ", ";
	end

	str = str .. " }";

	return str;
end

function ExtendedTable.ObjectToString(checkObject):string	-- Returns string representation of an object (recursive for tables)
	local str:string = "";	
	local typeString:string = type(checkObject);

	if (checkObject == nil) then
		str = "<nil>";
	elseif (typeString == "table") then
		str = ExtendedTable.TableToString(checkObject);
	elseif (typeString == "boolean") then
		str = (checkObject and "TRUE") or "FALSE";
	elseif (typeString == "number") then
		str = str .. checkObject;
	elseif (typeString == "string") then
		str = checkObject;
	elseif (typeString == "function") then
		str = "<function>";
	else
		str = "<Unknown Object>";
	end

	return str;
end

function ExtendedTable.GetTableSize(checkTable:table):number	-- Returns the number of elements in a table
	local count:number = table.maxn(checkTable);

	if (count == 0) then
		for key, value in hpairs(checkTable) do
			count = count + 1;
		end
	end

	return count;
end

function ExtendedTable.TableIsEmpty(checkTable:table):boolean
	return (next(checkTable) == nil);
end

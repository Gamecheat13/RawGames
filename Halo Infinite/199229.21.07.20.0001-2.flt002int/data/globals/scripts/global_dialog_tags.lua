--## SERVER


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation Type Data :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global CONVO_TYPE_DATA:table = {
	GlobalTypesTag = TAG('narrative\global.ConversationTypes'),
	TypesData = {},
	DefaultTypeData = {
		Priority = 7,	-- Conversations default to "NoncriticalScripted" priority
		Flags = {},		-- Conversations default to no flags set
	},
	isPopulated = nil,
};

function CONVO_TYPE_DATA:IsPopulated():boolean
	return self.isPopulated;
end

function CONVO_TYPE_DATA:Populate():void
	self.TypesData = {};
	self.isPopulated = false;

	if (not ConversationTypes_IsValid(self.GlobalTypesTag)) then
		--print("CONVO_PRIORITY_DATA :: Global Conversation Types tag was INVALID!");
		error("CONVO_PRIORITY_DATA :: Global Conversation Types tag was INVALID!");
		return;
	end

	local dataTable = self.TypesData;
	for i=0, ConversationTypes_GetCount() - 1 do
		local priority = ConversationTypes_GetPriorityOfType(self.GlobalTypesTag, i);
		if (priority ~= 0) then	-- Priority of 0 means the entry is invalidated by the user, or not found.  Negative values are technically supported, and are higher priority than pri 1, but should not be used by designers (reserved for technical overrides)
			local typeStringId = ConversationTypes_GetTypeStringId(i);
			dataTable[typeStringId] = {};
			local typeEntry = dataTable[typeStringId];

			typeEntry.Priority = priority;

			-- Read currently-set flags on this type, then convert them from array to dictionary format
			local tempFlags = ConversationTypes_GetFlagsOfType(self.GlobalTypesTag, i);
			typeEntry.Flags = {};
			for _,flagName in hpairs(tempFlags) do
				typeEntry.Flags[flagName] = true;
			end
		else
			print("CONVO_PRIORITY_DATA:Populate :: FAILED TO LOCATE PRIORITY DATA FOR CONVERSATION TYPE", i);
		end
	end

	self.isPopulated = true;
end

function CONVO_TYPE_DATA:GetTypeData(sceneType:string_id):table
	if (not self:IsPopulated()) then self:Populate(); end
	return (sceneType and self.TypesData[sceneType]) or self.DefaultTypeData;
end

function CONVO_TYPE_DATA:TestFlagByStringId(sceneType:string_id, flagId:string_id):boolean
	if (not self:IsPopulated()) then self:Populate(); end
	if (not self.TypesData[sceneType]) then return false; end
	return self.TypesData[sceneType].Flags[flagId];
end

function CONVO_TYPE_DATA:TestFlag(sceneType:string_id, flagName:string):boolean
	if (not self:IsPopulated()) then self:Populate(); end
	if (not CONVO_TYPE_FLAGS[flagName]) then return false; end
	return self:TestFlagByStringId(sceneType, CONVO_TYPE_FLAGS[flagName]);
end


global CONVO_PRIORITY:table = {
	-- Default fallback
	----------------------------------------
	Default				= get_string_id_from_string("NoncriticalScripted"),

	-- Full list of values (defined in //depot/Shiva/P4Main/shared/engine/source/blofeld/Conversation/ConversationTypes.h)
	----------------------------------------
	Cinematic			= get_string_id_from_string("Cinematic"),
	CollectiblePlay		= get_string_id_from_string("CollectiblePlay"),
	CriticalScripted	= get_string_id_from_string("CriticalScripted"),
	Alert				= get_string_id_from_string("Alert"),
	BloodgateReminder	= get_string_id_from_string("BloodgateReminder"),
	FobInteract			= get_string_id_from_string("FobInteract"),
	CollectibleAlert	= get_string_id_from_string("CollectibleAlert"),
	NoncriticalScripted	= get_string_id_from_string("NoncriticalScripted"),
	ProceedReminder		= get_string_id_from_string("ProceedReminder"),
	BespokeAivo			= get_string_id_from_string("BespokeAivo"),
	Background			= get_string_id_from_string("Background"),

	-- Lua override
	----------------------------------------
	UsePriorityFromTag	= -1,

	-- Legacy support for Halo 5 priorities
	----------------------------------------
	CriticalPath		= get_string_id_from_string("Cinematic"),
	MainCharacter		= get_string_id_from_string("NoncriticalScripted"),
	NPC					= get_string_id_from_string("Background"),

	-- System-use only
	----------------------------------------
	-- NOTE: You probably never need to touch this.  Using the NarrativeInterface functions for chained convos, this priority
	--       will AUTOMATICALLY BE ASSIGNED TO THE APPROPRIATE CONVOS FOR YOU.  This new priority comes with its own special
	--       built-in behaviors in the convo queue (similar to NPC and CriticalPath priorties having unique behaviors), and
	--       those behaviors are built upon certain assumptions that are guaranteed to be fulfilled if you allow the API to
	--       establish the chain relationships between specified convos for you, as opposed to manually configuring your
	--       convos by hand (which you can do, but should only do so in rare corner-case scenarios that require it, and only
	--       if you fully understand what this priority behavior is looking for).
	Chain				= get_string_id_from_string("Chain"),
	----------------------------------------

	_count				= 17,
};

-- Defined in \\depot\Shiva\P4Main\shared\engine\source\blofeld\Conversation\ConversationTypeTag.h
global CONVO_TYPE_FLAGS = {
	forceDisruptsAllLowerPriority	= get_string_id_from_string("forceDisruptsAllLowerPriority"),
	beatsSamePriority				= get_string_id_from_string("beatsSamePriority"),
	willNotBlockLowerPriority		= get_string_id_from_string("willNotBlockLowerPriority"),
	notBlockedByHigherPriority		= get_string_id_from_string("notBlockedByHigherPriority"),
	notInterruptedByHigherPriority	= get_string_id_from_string("notInterruptedByHigherPriority"),
	willNotInterruptLowerPriority	= get_string_id_from_string("willNotInterruptLowerPriority"),
	suppressDdsChatter				= get_string_id_from_string("suppressDdsChatter"),
};


-- =================================================================================================================================================
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation Tags :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

-- Defined in \\depot\Shiva\P4Main\shared\engine\source\blofeld\Conversation\ConversationTag.h
global CONVO_FLAGS = {
	AllowLuaToOverride					= get_string_id_from_string("AllowLuaToOverride"),
	SurviveForceDisruptingPriorities	= get_string_id_from_string("SurviveForceDisruptingPriorities"),
	OverrideSceneTypeAiDialog			= get_string_id_from_string("OverrideSceneTypeAiDialog"),
	DisableAiDialog						= get_string_id_from_string("DisableAiDialog"),
	CanStartLatches						= get_string_id_from_string("CanStartLatches"),
	IgnoreCollisions					= get_string_id_from_string("IgnoreCollisions"),
	DoNotPlayDialog						= get_string_id_from_string("DoNotPlayDialog"),
};


-- =================================================================================================================================================
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::: Conversation - Common Functions ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- =================================================================================================================================================

global CONVO_PRIORITY_FNC = {
	-- Override
	-------------------------------------
	UsePriorityFromTag = function (thisConvo:table, queue:table):any
		return CONVO_PRIORITY.UsePriorityFromTag;	-- For use with convos that use the "AllowLuaToOverride" flag in their tag, but you still want to use the Type listed in the tag
	end,
	-------------------------------------

	-- List of Types
	-------------------------------------
	Cinematic			= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.Cinematic; end,
	CollectiblePlay		= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.CollectiblePlay; end,
	CriticalScripted	= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.CriticalScripted; end,
	Alert				= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.Alert; end,
	BloodgateReminder	= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.BloodgateReminder; end,
	FobInteract			= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.FobInteract; end,
	CollectibleAlert	= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.CollectibleAlert; end,
	NoncriticalScripted	= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.NoncriticalScripted; end,
	ProceedReminder		= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.ProceedReminder; end,
	BespokeAivo			= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.BespokeAivo; end,
	Background			= function (thisConvo:table, queue:table):any return CONVO_PRIORITY.Background; end,
	-------------------------------------

	-- Legacy Support
	-------------------------------------
	CriticalPath = function (thisConvo:table, queue:table):any
		return CONVO_PRIORITY.CriticalPath;
	end,

	MainCharacter = function (thisConvo:table, queue:table):any
		return CONVO_PRIORITY.MainCharacter;
	end,

	Npc = function (thisConvo:table, queue:table):any
		return CONVO_PRIORITY.NPC;
	end,
	-------------------------------------

	-- SYSTEM-USE ONLY
	-------------------------------------
	Chain = function (thisConvo:table, queue:table):any	-- NOTE: You probably never need to touch this.  See priority table at top of file.
		return CONVO_PRIORITY.Chain;
	end,
	-------------------------------------
};

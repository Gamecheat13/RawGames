
FanfareDefinitions = 
{
	PersonalScore = "PersonalScore", -- note this is completely different than the PersonalScore field for Custom Statistics
	GameScore = "GameScore",
	GameState = "GameState",
	Highlights = "Highlights",
	KillFeed = "KillFeed",
	QuestFeed = "QuestFeed"
};
CustomStats =
{
	WZPersonalScore = "PersonalScoreUpper",
	PvERoundSpeedBonus = "PvERoundSpeedBonus",
	PvERoundSurviveBonus = "PvERoundSurviveBonus",
	PvERoundKillBonus = "PvERoundKillBonus",
	PvERoundAssistBonus = "PvERoundAssistBonus"
};
DefinitionNode = { };
function DefinitionNode:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function DefinitionNode:__init()
	self.Definitions = { };
end
function DefinitionNode:GetTypeName()
	return "DefinitionNode";
end
function DefinitionNode:GetName()
	for key, value in pairs(_G) do
		if rawequal(self, value) then
			return key;
		end
	end
	return nil;
end
function DefinitionNode:GetDescription()
	local description = "";
	if self.Parent ~= nil then
		description = self.Parent:GetDescription() .. " -> ";
	end
	local name = self:GetName();
	if name ~= nil then
		description = description .. self:GetName() .. ":";
	end
	description = description .. self:GetTypeName();
	return description;
end
function DefinitionNode:AddDefinition(definition)
	if definition.Parent ~= nil then
		error("Definition already has a parent.")
	end
	definition.Parent = self;
	table.insert(self.Definitions, definition);
end
function DefinitionNode:GetRoot()
	local current = self.Parent;
	while current.Parent ~= nil do
		current = current.Parent;
	end
	return current;
end
function DefinitionNode:VisitDefinitions(func, ...)
	for _, value in ipairs(self.Definitions) do
		func(value, ...);
	end
end
function DefinitionNode.StartCallback(definition, context)
	definition:Start(context);
end
function DefinitionNode:Start(context)
	self:VisitDefinitions(self.StartCallback, context)
end
function DefinitionNode.ActivateCallback(definition, context)
	definition:Activate(context);
end
function DefinitionNode:Activate(context)
	self:VisitDefinitions(self.ActivateCallback, context)
end
function DefinitionNode.SerializeCallback(definition, context)
	definition:Serialize(context);
end
function DefinitionNode:Serialize(context)
	self:VisitDefinitions(self.SerializeCallback, context)
end
function DefinitionNode.DeserializeCallback(definition, context)
	definition:Deserialize(context);
end
function DefinitionNode:Deserialize(context)
	self:VisitDefinitions(self.DeserializeCallback, context)
end
BaseSelectDefinition = setmetatable({ }, { __index = DefinitionNode });
function BaseSelectDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function BaseSelectDefinition:__init()
	DefinitionNode.__init(self);
	self.Options = { };
end
function BaseSelectDefinition:Add(predicate)
	local definition = self:CreateChildDefinition();
	local optionDefinition = 
	{
		Predicate = predicate,
		Definition = definition
	};
	table.insert(self.Options, optionDefinition);
	self:AddDefinition(definition);
	return definition;
end
function BaseSelectDefinition:Activate(context)
	for _, value in ipairs(self.Options) do
		local predicate = value.Predicate;
		if predicate == nil or predicate(context) then
			value.Definition:Activate(context);
			return;
		end
	end	
end
BaseBucketDefinition = setmetatable({ }, { __index = DefinitionNode });
function BaseBucketDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function BaseBucketDefinition:__init(targetFunc, emitFunc)
	DefinitionNode.__init(self);
	self.Target = targetFunc;
	self.EmitFunc = emitFunc;
	self.Buckets = { };
end
function BaseBucketDefinition:Add(predicate)
	local definition = self:CreateChildDefinition(self.EmitFunc);
	local bucketDefinition = 
	{
		Predicate = predicate,
		Definition = definition
	};
	table.insert(self.Buckets, bucketDefinition);
	self:AddDefinition(definition);
	return definition;
end
function BaseBucketDefinition:Activate(context)
	local targets = self.Target(context);
	local bucketOutputs = { };
	for _, value in pairs(targets) do
		for _, bucketDefinition in ipairs(self.Buckets) do
			local predicate = bucketDefinition.Predicate;
			local bucket = bucketDefinition.Definition;
			if predicate == nil or predicate(context, value) then
				if bucketOutputs[bucket] == nil then
					bucketOutputs[bucket] = { };
				end
				table.insert(bucketOutputs[bucket], value);
				break;
			end
		end
	end
	for bucket, targets in pairs(bucketOutputs) do
		bucket:Activate(context, targets);
	end	
end
HostBaseDefinition = setmetatable({ }, { __index = DefinitionNode });
function HostBaseDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function HostBaseDefinition:__init()
	DefinitionNode.__init(self);
end
function HostBaseDefinition:GetTypeName()
	return "HostBaseDefinition";
end
function HostBaseDefinition:Once(predicate)
	return self:OnceUntil(nil, predicate);
end
function HostBaseDefinition:OnceUntil(predicate, resetResponse)
	local accumulator = self:GetRoot():CreateAccumulator();
	if resetResponse ~= nil then
		resetResponse:ResetAccumulator(accumulator);
	end
	local wrapper = function(context)
		if accumulator:GetValue() == 0 and (predicate == nil or predicate(context)) then
			accumulator:SetValue(1);
			return true;
		end
		return false;
	end
	return self:Filter(wrapper);	
end
function HostBaseDefinition:Changed(initial, func)
	local previous = initial;
	local wrapper = function(context)
		local val = func(context);
		if previous ~= val then
			previous = val;
			return true;
		end
	end
	return self:Filter(wrapper);
end
function HostBaseDefinition:ChangedTo(testVal, func)
	local previouslyEqual = nil;
	local wrapper = function(context)
		local val = func(context);
		local isEqual = val == testVal;
		local changedTo = previouslyEqual ~= nil and isEqual and not previouslyEqual;
		previouslyEqual = isEqual;
		return changedTo;
	end
	return self:Filter(wrapper);
end
function HostBaseDefinition:Accumulator(accumulator)
	local def = AccumulatorDefinition:new(accumulator);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:PlayerAccumulator(accumulator, targetFunc)
	local def = PlayerAccumulatorDefinition:new(accumulator, targetFunc);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:ResetPlayerAccumulator(accumulator, targetFunc)
	local action = function (context)
		local target = targetFunc(context);
		accumulator:Reset(target);
	end
	return self:Action(action);
end
function HostBaseDefinition:ResetAccumulator(accumulator)
	local action = function ()
		accumulator:ResetAll();
	end
	return self:Action(action);
end
function HostBaseDefinition:Action(actionFunc)
	local def = ActionDefinition:new(actionFunc);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Response(response)
	local def = ResponseDefinition:new(response)
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Emit(func)
	local def = EmitDefinition:new(func)
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Target(func)
	if type(func) ~= "function" then
		error("Expected function to target definition.");
	end	
	return self:Emit(
		function (context)
			context._Targets = func(context);
		end
		);
end
function HostBaseDefinition:Filter(predicate)
	if type(predicate) ~= "function" then
		error("Expected function to filter definition.");
	end	
	local def = HostFilterDefinition:new(predicate);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Select()
	local def = HostSelectDefinition:new();
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Bucket(...)
	local def = HostBucketDefinition:new(...);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:Chance(percent)
	local def = HostChanceDefinition:new(percent);
	self:AddDefinition(def);
	return def;
end
function HostBaseDefinition:ObjectEvent(target)
	local def = ObjectEventDefinition:new(target);
	self:AddDefinition(def);
	return def:GetClientChild();
end
function HostBaseDefinition:GlobalEvent()
	local def = GlobalEventDefinition:new();
	self:AddDefinition(def);
	return def:GetClientChild();
end
ActivationContext = { };
function ActivationContext:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ActivationContext:__init()
	self.Engine = GetEngine();
end
function ActivationContext:GetAllPlayers()
	if self.__AllPlayers == nil then
		self.__AllPlayers = { };
		self.Engine:VisitPlayers(
			function (player)
				table.insert(self.__AllPlayers, player);
			end
			);
	end
	return self.__AllPlayers;
end
function ActivationContext:GetAllLocalPlayers()
	if self.__AllLocalPlayers == nil then
		self.__AllLocalPlayers = { };
		self.Engine:VisitLocalPlayers(
			function (player)
				table.insert(self.__AllLocalPlayers, player);
			end
			);
	end
	return self.__AllLocalPlayers;	
end
function ActivationContext:GetAllRemotePlayers()
	if self.__AllRemotePlayers == nil then
		local localPlayers = self:GetAllLocalPlayers();
		self.__AllRemotePlayers = table.filter(
			self:GetAllPlayers(),
			function (player)
				return not table.contains(localPlayers, player);
			end
			);
	end
	return self.__AllRemotePlayers;	
end
function ActivationContext:GetSortedTeamTotalScores()
	if self.__SortedTeamTotalScores == nil then
		self.__SortedTeamTotalScores = { };
		self.Engine:VisitSortedTeamsTotalScore(
			function (score)
				table.insert(self.__SortedTeamTotalScores, score);
			end
			);
	end
	return self.__SortedTeamTotalScores;	
end
function ActivationContext:GetSortedTeamsRoundsWon()
	if self.__SortedTeamsRoundsWon == nil then
		self.__SortedTeamsRoundsWon = { };
		self.Engine:VisitSortedTeamsRoundsWon(
			function (roundsWon)
				table.insert(self.__SortedTeamsRoundsWon, roundsWon);
			end
			);
	end
	return self.__SortedTeamsRoundsWon;
end
function ActivationContext:GetPlayerShotRecord(player)
	if self.__ShotRecords == nil then
		self.__ShotRecords = { };
	end
	if self.__ShotRecords[player] == nil then
		self.__ShotRecords[player] = { };
		player:VisitShotInfo(
			function (shotInfo)
				table.insert(self.__ShotRecords[player], shotInfo);
			end
			);
	end
	return self.__ShotRecords[player];
end
function ActivationContext:GetPlayerDamageHistory(player)
	if self.__DamageHistory == nil then
		self.__DamageHistory = { };
	end
	if self.__DamageHistory[player] == nil then
		self.__DamageHistory[player] = { };
		player:VisitDamageHistory(
			function (damageHistory)
				table.insert(self.__DamageHistory[player], damageHistory);
			end
			);
	end
	return self.__DamageHistory[player];
end
function ActivationContext:GetDamageHistoryBreakdowns(damageHistory)
	if self.__DamageHistoryBreakdowns == nil then
		self.__DamageHistoryBreakdowns = { };
	end
	if self.__DamageHistoryBreakdowns[damageHistory] == nil then
		self.__DamageHistoryBreakdowns[damageHistory] = { };
		damageHistory:VisitDamageBreakdowns(
			function (damageBreakdown)
				table.insert(self.__DamageHistoryBreakdowns[damageHistory], damageBreakdown);
			end
			);
	end
	return self.__DamageHistoryBreakdowns[damageHistory];
end
RootDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function RootDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function RootDefinition:__init()
	HostBaseDefinition.__init(self);
	self.CallbackData = { };
	self.Accumulators = { };
	self.PlayerAccumulators = { };
end
function RootDefinition:Activate(context)
end
function RootDefinition:HandleCallback(definition, ...)
	local context = ActivationContext:new();
	definition:Activate(context, ...);
end
function TypeIsHostBaseDefinition(val)
	local meta = getmetatable(val);
	if meta ~= nil then
		return meta.__index == HostBaseDefinition or TypeIsHostBaseDefinition(meta.__index);
	end
	return false;
end
function GetFirstDefinitionOnStack()
	if debug ~= nil then
		local stackIndex = 1
		local foundDef = false;
  		while not foundDef do
			local argIndex = 1;
  			while not foundDef do
    			local name, value = debug.getlocal(stackIndex, argIndex);
    			if name == nil then
    				break;
    			end
    			if name == "self" and TypeIsHostBaseDefinition(value) then
					return value;
    			end
    			argIndex = argIndex + 1;
    		end
    		stackIndex = stackIndex + 1;    		
    	end
	end
	return nil;
end
function RootDefinition.EventExceptionHandler(err)
	local firstDefinition = GetFirstDefinitionOnStack();
	if firstDefinition ~= nil then
		LogError("Error during event definition: " .. firstDefinition:GetDescription() .. "\n" .. tostring(err));
	else
		LogError(tostring(err));
	end
end
function RootDefinition:Start(context)
	if context.Engine:IsAuthoritative() then
		for _, value in ipairs(self.Accumulators) do
			value:Initialize(context);
		end
		for _, value in ipairs(self.PlayerAccumulators) do
			value:Initialize(context);
		end	
		local thisObj = self;
		for _, value in ipairs(self.CallbackData) do
			local definition = value.Definition;
			local eventHandler = function (...)
				local forwardArgs = arg;
				local wrapper = function ()
					thisObj:HandleCallback(definition, unpack(forwardArgs));
				end
				xpcall(wrapper, self.EventExceptionHandler);
			end
			value.Delegate:Subscribe(eventHandler);
		end
	end
	HostBaseDefinition.Start(self, context);
end
function RootDefinition:AddCallback(delegate, emitFunc)
	if getmetatable(delegate).__index ~= Delegate then
		error("Expected delegate type for callback. Got type: " .. tostring(delegate));
	end
	local def = EmitDefinition:new(emitFunc);
	self:AddDefinition(def);
	local data = 
	{
		Delegate = delegate,
		Definition = def
	};
	table.insert(self.CallbackData, data);
	return def;
end
function RootDefinition:CreateAccumulator(timeout)
	local accumulator = AccumulatorWrapper:new(timeout, nil);
	table.insert(self.Accumulators, accumulator);
	return accumulator;
end
function RootDefinition:CreatePlayerAccumulator(timeout)
	local accumulator = PlayerAccumulatorWrapper:new(timeout, nil);
	table.insert(self.PlayerAccumulators, accumulator);
	return accumulator;
end
AccumulatorWrapper = { };
function AccumulatorWrapper:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function AccumulatorWrapper:__init(timeout)
	self.Timeout = timeout;
end
function AccumulatorWrapper:Initialize(context)
	self.Accumulator = context.Engine:CreateAccumulator();
end
function AccumulatorWrapper:TestForExpiration()
	if self.Timeout ~= nil and self.Accumulator:GetSecondsSinceLastSet() >= self.Timeout then
		self.Accumulator:Reset();
	end	
end
function AccumulatorWrapper:Increment()
	self:TestForExpiration();
	local currentValue = self.Accumulator:GetValue();
	self.Accumulator:SetValue(currentValue + 1);
end
function AccumulatorWrapper:GetValue()
	self:TestForExpiration();
	return self.Accumulator:GetValue();
end
function AccumulatorWrapper:SetValue(val)
	self.Accumulator:SetValue(val);
end
function AccumulatorWrapper:Reset()
	self.Accumulator:Reset();
end
function AccumulatorWrapper:ResetAll()
	self:Reset();
end
PlayerAccumulatorWrapper = { };
function PlayerAccumulatorWrapper:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function PlayerAccumulatorWrapper:__init(timeout)
	self.Timeout = timeout;
end
function PlayerAccumulatorWrapper:Initialize(context)
	self.Accumulator = context.Engine:CreatePlayerAccumulator();
end
function PlayerAccumulatorWrapper:TestForExpiration(player)
	if self.Timeout ~= nil and self.Accumulator:GetSecondsSinceLastSet(player) >= self.Timeout then
		self.Accumulator:Reset(player);
	end	
end
function PlayerAccumulatorWrapper:Increment(target, count)
	if type(target) == "table" then
		for _, value in pairs(target) do
			self:Increment(value, count);
		end
	else
		self:TestForExpiration(target);
		local currentValue = self.Accumulator:GetValue(target);
		self.Accumulator:SetValue(target, currentValue + count);
	end
end
function PlayerAccumulatorWrapper:GetValue(player)
	self:TestForExpiration(player);
	return self.Accumulator:GetValue(player);
end
function AccumulatorWrapper:SetValue(player, val)
	self.Accumulator:SetValue(player, val);
end
function PlayerAccumulatorWrapper:Reset(target)
	if type(target) == "table" then
		for _, value in pairs(target) do
			self:Reset(value);
		end
	else
		self.Accumulator:Reset(target);
	end
end
function PlayerAccumulatorWrapper:ResetAll()
	self.Accumulator:ResetAll();
end
HostFilterDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function HostFilterDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function HostFilterDefinition:__init(predicate)
	HostBaseDefinition.__init(self);
	self.Predicate = predicate;
end
function HostFilterDefinition:Activate(context)
	if self.Predicate(context) then
		HostBaseDefinition.Activate(self, context);
	end
end
ResponseDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function ResponseDefinition.ValidateScore(val)
	return type(val) == "number" or type(val) == "function";
end
function ResponseDefinition.ValidateFanfare(val)
	return type(val) == "string";
end
function ResponseDefinition.ValidateFanfareText(val)
	return type(val) == "string" or type(val) == "function";
end
function ResponseDefinition.ValidateSound(val)
	return type(val) == "string";
end
function ResponseDefinition.ValidateMedal(val)
	return type(val) == "string";
end
function ResponseDefinition.ValidateDialogueEvent(val)
	return type(val) == "function";
end
function ResponseDefinition.ValidateImpulseEvent(val)
	return type(val) == "string" or type(val) == "function";
end
function ResponseDefinition.ValidateTeamDesignator(val)
	return type(val) == "number" or type(val) == "function";
end
function ResponseDefinition.ValidatePlatformImpulse(val)
	return type(val) == "string"
end
function ResponseDefinition.ValidateOutOfGameEvent(val)
	return type(val) == "boolean";
end
function ResponseDefinition.ValidatePerspective(val)
	return type(val) == "number";
end
function ResponseDefinition.ValidateCustomStatName(val)
	return type(val) == "string" or type(val) == "function";
end
function ResponseDefinition.ValidateCustomStatChange(val)
	return type(val) == "number" or type(val) == "function";
end
function ResponseDefinition.ValidateCustomStatSet(val)
	return type(val) == "number" or type(val) == "function";
end
function ResponseDefinition.ValidatePersonalScore(val)
	return type(val) == "number" or type(val) == "function";
end	
function ResponseDefinition.ValidateSoundGlobalId(val)
	return type(val) == "number" or type(val) == "function";
end
ResponseDefinition.ValidProperties =
{
	Score = ResponseDefinition.ValidateScore,
	Fanfare = ResponseDefinition.ValidateFanfare,
	FanfareText = ResponseDefinition.ValidateFanfareText,
	Sound = ResponseDefinition.ValidateSound,
	Sound2 = ResponseDefinition.ValidateSound,
	Medal = ResponseDefinition.ValidateMedal,
	DialogueEvent = ResponseDefinition.ValidateDialogueEvent,
	ImpulseEvent = ResponseDefinition.ValidateImpulseEvent,
	TeamDesignator = ResponseDefinition.ValidateTeamDesignator,
	PlatformImpulse = ResponseDefinition.ValidatePlatformImpulse,
	OutOfGameEvent = ResponseDefinition.ValidateOutOfGameEvent,
	Perspective = ResponseDefinition.ValidatePerspective,
	CustomStat = ResponseDefinition.ValidateCustomStatName,
	CustomStatChange = ResponseDefinition.ValidateCustomStatChange,
	CustomStatSet = ResponseDefinition.ValidateCustomStatSet,
	PersonalScore = ResponseDefinition.ValidatePersonalScore,
	SoundGlobalId = ResponseDefinition.ValidateSoundGlobalId
};
function ResponseDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ResponseDefinition:__init(response)
	HostBaseDefinition.__init(self);
	self:SetResponse(response);
end
function ResponseDefinition:SetResponse(response)
	if response == nil then
		error("Nil response passed to definition creation!")
	end
	local customStatDefined = false;
	local customStatChangeOrSetDefined = false;
	for responseKey, responseValue in pairs(response) do
		local validationCheck = ResponseDefinition.ValidProperties[responseKey];
		local isValid = (validationCheck ~= nil);
		if isValid then
			isValid = validationCheck(responseValue);
		end
		if not isValid then
			error("Invalid property on response: " .. responseKey);
		end
		customStatDefined = customStatDefined or (responseKey == CustomStat);
		customStatChangeOrSetDefined = customStatChangeOrSetDefined or (responseKey == CustomStatChange or responseKey == CustomStatSet);
	end
	if customStatDefined and not customStatChangeOrSetDefined then
		error("A CustomStat was defined but no corresponding CustomStatChange or CustomStatSet on a response");
	end
	if customStatChangeOrSetDefined and not customStatDefined then
		error("A CustomStatChange or CustomStatSet was defined but no corresponding CustomStat on a response");
	end
	self.ResponseData = response;
	self.DynamicProperties = table.filter(response, 
		function (val)
			return type(val) == "function";
		end
		);
end
function ResponseDefinition:OverlayResponse(response)
	local newResponse = table.copy(self.ResponseData);
	for responseKey, responseValue in pairs(response) do
		newResponse[responseKey] = responseValue;
	end
	self:SetResponse(newResponse);
end
function ResponseDefinition:ApplyResponse(target, eventHandle, properties)
	if target ~= nil then
		if type(target) == "table" then
			for _, value in pairs(target) do
				self:ApplyResponse(value, eventHandle, properties);
			end
		else
			target:AddEvent(eventHandle, properties);
		end
	end
end
function ResponseDefinition:TriggerImpulseEvent(target, eventName)
	if target ~= nil then
		if type(target) == "table" then
			for _, value in pairs(target) do
				self:TriggerImpulseEvent(value, eventName);
			end
		else
			ImpulseEvent(target, eventName);
		end
	end
end
function ResponseDefinition:TriggerQuestCompleteEvent(target, questName)
	if target ~= nil then
		QuestCompleteEvent(questName, target);
	end
end
function ResponseDefinition:SetCustomStatistic(target, customStatTarget, customStatNewValue, variant)
	if target ~= nil and customStatTarget ~= nil and customStatNewValue ~= nil and variant ~= nil then
		if type(customStatTarget) == "string" and type(customStatNewValue) == "number" then
			if type(target) == "table" then
				for _, value in pairs(target) do
					self:SetCustomStatistic(value, customStatTarget, customStatNewValue, variant);
				end
			else
				variant:SetPlayerCustomStatistic(target, customStatTarget, customStatNewValue);
			end
		end
	else
		Log("Nil arguments encountered in SetCustomStatistic; execution skipped.");
	end
end
function ResponseDefinition:TriggerCustomStatisticChange(target, customStatTarget, customStatChange, variant)
	if target ~= nil and customStatTarget ~= nil and customStatChange ~= nil and variant ~= nil then
		if type(customStatTarget) == "string" and type(customStatChange) == "number" then
			if type(target) == "table" then
				for _, value in pairs(target) do
					self:TriggerCustomStatisticChange(value, customStatTarget, customStatChange, variant);
				end
			else
				variant:AdjustPlayerCustomStatistic(target, customStatTarget, customStatChange);
			end
		end
	else
		Log("Nil arguments encountered in TriggerCustomStatisticChange; execution skipped.");
	end
end
local DialogueEventStringIdTable;
function ResponseDefinition:Activate(context)
	local variant = FindVariant(context);
	if self.EventHandle ~= nil then
		local dynamicProps = self.DynamicProperties;
		local responseProps = table.copy(self.ResponseData);
		if dynamicProps.ImpulseEvent ~= nil then
			self:TriggerImpulseEvent(context._Targets, dynamicProps.ImpulseEvent(context));
		elseif responseProps.ImpulseEvent ~= nil then
			self:TriggerImpulseEvent(context._Targets, responseProps.ImpulseEvent);
		end
		if dynamicProps.QuestCompleteEvent ~= nil then
			self:TriggerQuestCompleteEvent(context._Targets, dynamicProps.QuestCompleteEvent(context));
		elseif responseProps.QuestCompleteEvent ~= nil then
			self:TriggerQuestCompleteEvent(context._Targets, responseProps.QuestCompleteEvent);
		end
		local customStatTarget = dynamicProps.CustomStat;
		if customStatTarget == nil then
			customStatTarget = responseProps.CustomStat;
		else
			customStatTarget = customStatTarget(context);
		end
		local customStatChange = dynamicProps.CustomStatChange;
		if customStatChange == nil then
			customStatChange = responseProps.CustomStatChange;
		else
			customStatChange = customStatChange(context);
		end
		local customStatSet = dynamicProps.CustomStatSet;
		if customStatSet == nil then
			customStatSet = responseProps.CustomStatSet;
		else
			customStatSet = customStatSet(context);
		end
		if customStatTarget ~= nil and customStatChange ~= nil then
			self:TriggerCustomStatisticChange(context._Targets, customStatTarget, customStatChange, variant);
		end
		if customStatTarget ~= nil and customStatSet ~= nil then
			self:SetCustomStatistic(context._Targets, customStatTarget, customStatSet, variant);
		end
		if (disablePersonalScoreField == nil or disablePersonalScoreField == false) then
			if dynamicProps.PersonalScore ~= nil then
				self:TriggerCustomStatisticChange(context._Targets, CustomStats.WZPersonalScore, dynamicProps.PersonalScore(context), variant);
			elseif responseProps.PersonalScore ~= nil then
				self:TriggerCustomStatisticChange(context._Targets, CustomStats.WZPersonalScore, responseProps.PersonalScore, variant);
			end
		end
		if scoreShouldAlsoIncrementPersonalScore then
			if dynamicProps.Score ~= nil then
				self:TriggerCustomStatisticChange(context._Targets, CustomStats.WZPersonalScore, dynamicProps.Score(context), variant);
			elseif responseProps.Score ~= nil then
				self:TriggerCustomStatisticChange(context._Targets, CustomStats.WZPersonalScore, responseProps.Score, variant);
			end
		end
		if dynamicProps.DialogueEvent ~= nil then
			local dialogueEvent = dynamicProps.DialogueEvent(context);
			if self.__DialogueEventStringIdTable == nil then
				self.__DialogueEventStringIdTable = { };
			end
			local dialogueEventType = self.__DialogueEventStringIdTable[dialogueEvent.EventStringId];
			if dialogueEventType == nil then
				dialogueEventType = DialogueEventTypeFromString(dialogueEvent.EventStringId);
				self.__DialogueEventStringIdTable[dialogueEvent.EventStringId] = dialogueEventType;
			end
			local subjectUnit = dialogueEvent.SubjectUnit;
			local causeUnit = dialogueEvent.CauseUnit;
			if dialogueEvent.DamageCategory ~= nil then
				local damageCategoryType = DamageCategoryFromString(dialogueEvent.DamageCategory)
				AIDialogueEventWithDamage(dialogueEventType, subjectUnit, causeUnit, damageCategoryType);
			else
				AIDialogueEvent(dialogueEventType, subjectUnit, causeUnit);
			end
		end
		local overrideProps = { };
		for name, prop in pairs(dynamicProps) do
			if name ~= "ImpulseEvent" and name ~= "QuestCompleteEvent" and name ~= "DialogueEvent" then
				overrideProps[name] = prop(context);
			end
		end
		self:ApplyResponse(context._Targets, self.EventHandle, overrideProps);
	end
	HostBaseDefinition.Activate(self, context);	
end
function ResponseDefinition:Serialize(context)
	context:WriteResponse(self.ResponseData);
	HostBaseDefinition.Serialize(self, context);
end
function ResponseDefinition:Deserialize(context)
	self.EventHandle = context:ReadResponse(context);
	self.EventHandleIndex = context.EventIndex - 1;
	HostBaseDefinition.Deserialize(self, context);
end
EmitDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function EmitDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function EmitDefinition:__init(func)
	HostBaseDefinition.__init(self);
	self.EmitFunc = func;
end
function EmitDefinition:Activate(context, ...)
	local childContext = table.copy(context);
	if self.EmitFunc ~= nil then	
		self.EmitFunc(childContext, ...);
	end
	HostBaseDefinition.Activate(self, childContext);
end
ActionDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function ActionDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ActionDefinition:__init(actionFunc)
	if type(actionFunc) ~= "function" then
		error("Expected function for action definition");
	end
	HostBaseDefinition.__init(self);
	self.Action = actionFunc;
end
function ActionDefinition:Activate(context, ...)
	self.Action(context, ...);
	HostBaseDefinition.Activate(self, context);
end
AccumulatorDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function AccumulatorDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function AccumulatorDefinition:__init(accumulator)
	HostBaseDefinition.__init(self);
	self.Accumulator = accumulator;
end
function AccumulatorDefinition:Activate(context, ...)
	self.Accumulator:Increment();
	HostBaseDefinition.Activate(self, context, ...);
end
PlayerAccumulatorDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function PlayerAccumulatorDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function PlayerAccumulatorDefinition:__init(accumulator, targetFunc)
	if targetFunc == nil then
		error("Expected target function for player accumulator.");
	end
	HostBaseDefinition.__init(self);
	self.Accumulator = accumulator;
	self.TargetFunc = targetFunc;
end
function PlayerAccumulatorDefinition:Activate(context, ...)
	local targetPlayer, count = self.TargetFunc(context, ...);
	self.Accumulator:Increment(targetPlayer, count or 1);
	HostBaseDefinition.Activate(self, context, ...);
end
HostSelectDefinition = setmetatable({ }, { __index = BaseSelectDefinition });
function HostSelectDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function HostSelectDefinition:CreateChildDefinition()
	return HostBaseDefinition:new();
end
HostBucketDefinition = setmetatable({ }, { __index = BaseBucketDefinition });
function HostBucketDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function HostBucketDefinition:CreateChildDefinition(emitFunc)
	return EmitDefinition:new(emitFunc);
end
HostChanceDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function HostChanceDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function HostChanceDefinition:__init(probability)
	HostBaseDefinition.__init(self);
	if probability < 0 or probability > 100 then
		error("Probability specified was out of range: " .. tostring(probability))
	end
	self.Probability = probability;
end
function HostChanceDefinition:Activate(context)
	local randomVal = 100 * context.Engine:GetRandomFloat();
	if randomVal <= self.Probability then
		HostBaseDefinition.Activate(self, context);
	end
end
ObjectEventDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function ObjectEventDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ObjectEventDefinition:__init(targetFunc)
	HostBaseDefinition.__init(self);
	self.TargetFunc = targetFunc;
	self.ClientNode = ClientBaseDefinition:new();
	self:AddDefinition(self.ClientNode);
end
function ObjectEventDefinition:Activate(context, ...)
	local target = self.TargetFunc(context);
	if target ~= nil and target.AddScriptEvent == nil and target.GetUnit ~= nil then
		target = target:GetUnit();
	end
	if target ~= nil then
		target:AddScriptEvent(self.DefinitionIndex);
	end	
end
function ObjectEventDefinition:NetworkCallback(obj)
	self:ActivateClient(obj);
end
function ObjectEventDefinition:ActivateClient(obj)
	local context = ActivationContext:new();
	context.Source = obj;
	self.ClientNode:Activate(context);
end	
function ObjectEventDefinition:Start(context)
	local thisObj = self;
	local callback = function (...)
		thisObj:NetworkCallback(...);
	end
	self.DefinitionIndex = context:RegisterNetworkedCallback(callback);
	HostBaseDefinition.Start(self, context);
	self.ClientNode:Start(context);
end
function ObjectEventDefinition:Serialize(context)
	HostBaseDefinition.Serialize(self, context);	
	self.ClientNode:Serialize(context);	
end
function ObjectEventDefinition:Deserialize(context)
	HostBaseDefinition.Deserialize(self, context);
	self.ClientNode:Deserialize(context);
end
function ObjectEventDefinition:GetClientChild()
	return self.ClientNode;
end
GlobalEventDefinition = setmetatable({ }, { __index = HostBaseDefinition });
function GlobalEventDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function GlobalEventDefinition:__init()
	HostBaseDefinition.__init(self);
	self.ClientNode = ClientBaseDefinition:new();
	self:AddDefinition(self.ClientNode);
end
function GlobalEventDefinition:Activate(context, ...)
	context.Engine:AddScriptEvent(self.DefinitionIndex);
end
function GlobalEventDefinition:NetworkCallback()
	self:ActivateClient();
end
function GlobalEventDefinition:ActivateClient()
	local context = ActivationContext:new();
	self.ClientNode:Activate(context);
end	
function GlobalEventDefinition:Start(context)
	local thisObj = self;
	local callback = function (...)
		thisObj:NetworkCallback(...);
	end
	self.DefinitionIndex = context:RegisterNetworkedCallback(callback);
	HostBaseDefinition.Start(self, context);
	self.ClientNode:Start(context);
end
function GlobalEventDefinition:Serialize(context)
	HostBaseDefinition.Serialize(self, context);	
	self.ClientNode:Serialize(context);	
end
function GlobalEventDefinition:Deserialize(context)
	HostBaseDefinition.Deserialize(self, context);
	self.ClientNode:Deserialize(context);
end
function GlobalEventDefinition:GetClientChild()
	return self.ClientNode;
end
ClientBaseDefinition = setmetatable({ }, { __index = DefinitionNode });
function ClientBaseDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ClientBaseDefinition:__init()
	DefinitionNode.__init(self);
end
function ClientBaseDefinition:GetTypeName()
	return "ClientBaseDefinition";
end
function ClientBaseDefinition:Emit(func)
	local def = EmitDefinition:new(func)
	self:AddDefinition(def);
	return def;
end
function ClientBaseDefinition:Target(func)
	if type(func) ~= "function" then
		error("Expected function to target definition.");
	end		
	return self:Emit(
		function (context)
			context._Targets = func(context);
		end
		);
end
function ClientBaseDefinition:Filter(predicate)
	if type(predicate) ~= "function" then
		error("Expected function to filter definition.");
	end
	local def = ClientFilterDefinition:new(predicate);
	self:AddDefinition(def);
	return def;
end
function ClientBaseDefinition:Select()
	local def = ClientSelectDefinition:new();
	self:AddDefinition(def);
	return def;
end
function ClientBaseDefinition:Chance(percent)
	local def = ClientChanceDefinition:new(percent);
	self:AddDefinition(def);
	return def;
end
function ClientBaseDefinition:Say(...)
	local def = SayDefinition:new(...);
	self:AddDefinition(def);
	return def;
end
ClientFilterDefinition = setmetatable({ }, { __index = ClientBaseDefinition });
function ClientFilterDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ClientFilterDefinition:__init(predicate)
	ClientBaseDefinition.__init(self);
	self.Predicate = predicate;
end
function ClientFilterDefinition:Activate(context)
	if self.Predicate(context) then
		ClientBaseDefinition.Activate(self, context);
	end
end
ClientSelectDefinition = setmetatable({ }, { __index = BaseSelectDefinition });
function ClientSelectDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ClientSelectDefinition:CreateChildDefinition()
	return ClientBaseDefinition:new();
end
ClientChanceDefinition = setmetatable({ }, { __index = ClientBaseDefinition });
function ClientChanceDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function ClientChanceDefinition:__init(probability)
	ClientBaseDefinition.__init(self);
	if probability < 0 or probability > 100 then
		error("Probability specified was out of range: " .. tostring(probability))
	end
	self.Probability = probability;
end
function ClientChanceDefinition:Activate(context)
	local randomVal = 100 * context.Engine:GetRandomFloat();
	if randomVal <= self.Probability then
		ClientBaseDefinition.Activate(self, context);
	end
end
AudioBaseDefinition = setmetatable({ }, { __index = ClientBaseDefinition });
function AudioBaseDefinition:__init(audio)
	ClientBaseDefinition.__init(self);
	self.Audio = audio;
end
function AudioBaseDefinition:Serialize(context)
	context:WriteTagReference(GetAudioTagGroup(), self.Audio);
	ClientBaseDefinition.Serialize(self, context);
end
function AudioBaseDefinition:Deserialize(context)
	self.AudioHandle = context:ReadTagReference();
	ClientBaseDefinition.Deserialize(self, context);
end
SayDefinition = setmetatable({ }, { __index = AudioBaseDefinition });
function SayDefinition:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function SayDefinition:__init(targetFunc, audio)
	AudioBaseDefinition.__init(self, audio);
	self.TargetFunc = targetFunc;
end
function SayDefinition:Activate(context, ...)
	if self.TargetFunc ~= nil then
		local target = self.TargetFunc(context, ...);
		if target ~= nil then
			target:AttachAudio(self.AudioHandle);
		end
	end
	AudioBaseDefinition.Activate(self, context, ...);
end
SerializationContext = { };
function SerializationContext:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function SerializationContext:__init(variant)
	self.Variant = variant;
end
SerializationContext.KnownProperties =
{
	Sound = function (val)
		return GetTagGlobalID(GetAudioTagGroup(), val);
	end,
	Sound2 = function (val)
		return GetTagGlobalID(GetAudioTagGroup(), val);
	end,
	Fanfare = function (val)
		return ResolveString(val);
	end,
	FanfareText = function (val)
		return ResolveString(val);
	end,
	Medal = function(val)
		return ResolveString(val);
	end,
	ImpulseEvent = function(val)
		return ResolveString(val);
	end,
	CustomStat = function(val)
		return ResolveString(val);
	end
};
function SerializationContext:GetValueForProperty(key, value)
	if type(value) == "function" then
		return nil;
	end
	local resolver = SerializationContext.KnownProperties[key];
	if resolver ~= nil then
		return resolver(value);
	end
	return value;
end
function SerializationContext:WriteResponse(response)
	local eventStorage = self.Variant:GetEvents();
	local eventProperties = {};
	for responseKey, responseValue in pairs(response) do
		eventProperties[responseKey] = self:GetValueForProperty(responseKey, responseValue);
	end
	local newIndex = eventStorage:AddEvent(eventProperties);
	if newIndex == -1 or (self.LastEventIndex ~= nil and newIndex <= self.LastEventIndex) then
		error("Failed to write event definition to variant. (Likely too many game event definitions.)");
	end
	self.LastEventIndex = newIndex;
	if self.EventIndex == nil then
		self.EventIndex = newIndex;
	end
end
function SerializationContext:WriteTagReference(type, path)
	local tagIndex = self.Variant:AddTagReference(type, path);
	if tagIndex == -1 or (self.LastTagIndex ~= nil and tagIndex <= self.LastTagIndex) then
		error("Failed to write tag definition to variant. (Likely missing tag or too many tag definitions.)");
	end
	if self.TagIndex == nil then
		self.TagIndex = tagIndex;
	end
end
function SerializationContext:Flush()
	if self.EventIndex ~= nil then
		self.Variant:SetProperty("EventIndex", tostring(self.EventIndex));
	end
	if self.TagIndex ~= nil then
		self.Variant:SetProperty("TagIndex", tostring(self.TagIndex));
	end	
end
DeserializationContext = { };
function DeserializationContext:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function DeserializationContext:__init(variant)
	self.Variant = variant;
	local eventIndexProperty = variant:GetProperty("EventIndex");
	if eventIndexProperty ~= nil then
		self.EventIndex = tonumber(eventIndexProperty);
	end
	local tagIndexProperty = variant:GetProperty("TagIndex");
	if tagIndexProperty ~= nil then
		self.TagIndex = tonumber(tagIndexProperty);
	end
end
function DeserializationContext:ReadTagReference()
	local tagReference = self.Variant:GetTagReference(self.TagIndex);
	self.TagIndex = self.TagIndex + 1;
	return tagReference;
end
function DeserializationContext:ReadResponse(response)
	local eventStorage = self.Variant:GetEvents();
	local response = eventStorage:GetEvent(self.EventIndex);
	self.EventIndex = self.EventIndex + 1;
	return response;
end
StartContext = { };
function StartContext:new(...)
	local obj = { };
	setmetatable(obj, { __index = self });
	obj:__init(...);
	return obj;
end
function StartContext:__init()
	self.Engine = GetEngine();
	self.Callbacks = { };
end
function StartContext:RegisterNetworkedCallback(callback)
	table.insert(self.Callbacks, callback);
	return #self.Callbacks;
end
function StartContext:GetCallbacks()
	return self.Callbacks;
end
DefinitionRuntime = { };
DefinitionRuntime.Roots = { };
function DefinitionRuntime:RegisterRoot(definition)
	table.insert(self.Roots, definition);
end
function DefinitionRuntime:VisitRoots(func, ...)
	for _, value in ipairs(self.Roots) do
		func(value, ...);
	end
end
function DefinitionRuntime.SerializeCallback(root, context)
	root:Serialize(context);
end
function DefinitionRuntime:Serialize(variant)
	local context = SerializationContext:new(variant);
	self:VisitRoots(self.SerializeCallback, context);
	context:Flush();
end
function DefinitionRuntime.DeserializeCallback(root, context)
	root:Deserialize(context);
end
function DefinitionRuntime:Deserialize(variant)
	local context = DeserializationContext:new(variant);
	self:VisitRoots(self.DeserializeCallback, context);
end
function DefinitionRuntime.StartCallback(root, context)
	root:Start(context);
end
function DefinitionRuntime:NetworkCallback(obj, index)
	local callback = self.NetworkCallbacks[index];
	if callback == nil then
		error("Got networked event definition that does not match a registered callback! - Index: " .. index);
	end
	callback(obj);
end
function DefinitionRuntime:Start(engine)
	local context = StartContext:new();
	self:VisitRoots(self.StartCallback, context);
	self.NetworkCallbacks = context:GetCallbacks();
	local thisObj = self;
	__OnEngineClientEvent:Subscribe(
		function (...)
			thisObj:NetworkCallback(...);
		end
		);
end
function ObjectIsType(val, typeToCheck)
	local meta = getmetatable(val);
	if meta ~= nil then
		return meta.__index == typeToCheck or ObjectIsType(meta.__index, typeToCheck);
	end
	return false;
end
function __TestResponseDefinition(definitionName)
	local success = false;
	local definition = _G[definitionName];
	while definition ~= nil and ObjectIsType(definition, ResponseDefinition) do
		Log("Activating definition: " .. definitionName);
		local context = ActivationContext:new();
		context._Targets = context:GetAllPlayers();
		definition:Activate(context);
		success = true;
		definition = definition.Parent;
	end
	if success ~= true then
		Log("Failed to find definition: " .. tostring(definitionName));
	end
end
function __TestObjectActionDefinition(definitionName, obj)
	local success = false;
	local definition = _G[definitionName];
	if definition ~= nil then
		local parent = definition.Parent;
		if parent ~= nil then
			Log("Activating definition: " .. definitionName);
			parent:ActivateClient(obj);
			success = true;
		end
	end
	if success ~= true then
		Log("Failed to find definition: " .. tostring(definitionName));
	end
end
function __TestGlobalActionDefinition(definitionName)
	local success = false;
	local definition = _G[definitionName];
	if definition ~= nil then
		local parent = definition.Parent;
		if parent ~= nil then
			Log("Activating definition: " .. definitionName);
			parent:ActivateClient();
			success = true;
		end
	end
	if success ~= true then
		Log("Failed to find definition: " .. tostring(definitionName));
	end
end

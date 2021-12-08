-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani

REQUIRES('globals/scripts/global_ai.lua');

--## SERVER


--****************************
--* AIEncounterInstance
--****************************

global g_allEncounterInstances = {};

global AIEncounterInstance:table = table.makePermanent
{
	m_instanceIndex = nil,
	m_objectiveInstances = {},
}

function AIEncounterInstance.New():table
	return AIEncounterInstance.NewWithSettings(true);
end

function AIEncounterInstance.NewWithSettings(useHydration:boolean):table
	local instance = setmetatable({}, {__index = AIEncounterInstance});
	instance.m_instanceIndex = AI_MakeEncounterInstance();
	instance.m_objectiveInstances = {};
	if (useHydration) then
		instance:EnableStreaming();
	end
	CreateThread(AIEncounterInstance.Update, instance);
	g_allEncounterInstances[instance.m_instanceIndex] = instance;
	return instance;
end

function AIEncounterInstance.FromExisting(encInstIndex:handle):table
	local instance = g_allEncounterInstances[encInstIndex];
	if (nil == instance) then
		instance = setmetatable({}, {__index = AIEncounterInstance});
		instance.m_instanceIndex = encInstIndex;
		instance.m_objectiveInstances = {};
		instance:EnableStreaming();
		CreateThread(AIEncounterInstance.Update, instance);
		g_allEncounterInstances[encInstIndex] = instance;
	end
	return instance;
end

function AIEncounterInstance:RegisterCallbacks(controller:table)
	if (controller == nil) then
		return;
	end
	
	if (nil ~= controller.Initialize) then
		RegisterEvent(g_eventTypes.encounterInitialize, controller.Initialize, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.Start) then
		RegisterEvent(g_eventTypes.encounterStart, controller.Start, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.PreActivate) then
		RegisterEvent(g_eventTypes.encounterPreActivate, controller.PreActivate, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.PostActivate) then
		RegisterEvent(g_eventTypes.encounterPostActivate, controller.PostActivate, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.PreDeactivate) then
		RegisterEvent(g_eventTypes.encounterPreDeactivate, controller.PreDeactivate, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.PostDeactivate) then
		RegisterEvent(g_eventTypes.encounterPostDeactivate, controller.PostDeactivate, self.m_instanceIndex, controller);
	end
	
	if (nil ~= controller.Release) then
		RegisterEvent(g_eventTypes.encounterPreRelease, controller.Release, self.m_instanceIndex, controller);
	end
end

function AIEncounterInstance:EnableStreaming():void
	AI_EnableEncounterStreaming(self.m_instanceIndex);
end

function AIEncounterInstance:AddObjective(objectiveFunc:ifunction, spawnAt:location, initParams):handle
	local objectiveDef = ObjectiveTable:Request(objectiveFunc);
	assert(objectiveDef.m_finalized == true);
	
	assert(spawnAt ~= nil, "encounter instance: trying add an objective to an encounter instance with a nil objective");
	local objInstIndex:handle = AI_AddObjectiveToEncounter(self.m_instanceIndex, objectiveDef.m_objectiveHandle);
	local objectiveInstance:table = objectiveDef:CreateObjectiveInstance(self.m_instanceIndex, objInstIndex, spawnAt, initParams);
	self.m_objectiveInstances[objInstIndex] = objectiveInstance;
	return objInstIndex;
end

function AIEncounterInstance:AddObjectiveLegacy(objectiveDef:table, spawnAt:location):handle
	assert(objectiveDef.m_finalized == true);
	assert(spawnAt ~= nil);
	local objInstIndex:handle = AI_AddObjectiveToEncounter(self.m_instanceIndex, objectiveDef.m_objectiveHandle);
	local objectiveInstance:table = objectiveDef:CreateObjectiveInstance(self.m_instanceIndex, objInstIndex, spawnAt, nil);
	self.m_objectiveInstances[objInstIndex] = objectiveInstance;
	return objInstIndex;
end

function AIEncounterInstance:TryToAddFaberObjective(objInstIndex:handle):table
	local objectiveInst:table = self.m_objectiveInstances[objInstIndex];
	if objectiveInst == nil then
		objectiveInst = AIObjectiveInstance.New(objInstIndex);
		objectiveInst.m_encounterInstIndex = self.m_instanceIndex;
		--populate the root squad
		local emptySquadDescList:table = {};
		objectiveInst.m_rootSquadInstance = AI_ReserveEncounterSquadDescriptions(self.m_instanceIndex, emptySquadDescList);
		AI_AssignSquadInstanceToObjective(objInstIndex, objectiveInst.m_rootSquadInstance);
		--put the instance in the encounter
		self.m_objectiveInstances[objInstIndex] = objectiveInst;
	end

	return objectiveInst;
end


function AIEncounterInstance:AssignSquadObjective(objInstIndex:handle, squad:ai):void
	local squadInstance:handle = AI_GetSquadInstanceFromAISquad(squad);
	self:AssignSquadInstanceToObjective(objInstIndex, squadInstance);
end

function AIEncounterInstance:AssignSquadInstanceToObjective(objInstIndex:handle, squadInstance:handle):void
	local objectiveInstance = self.m_objectiveInstances[objInstIndex];
	if (nil ~= objectiveInstance) then
		AI_AssignSquadInstanceToObjective(objInstIndex, squadInstance);
		AI_SetSquadInstanceParent(squadInstance, objectiveInstance.m_rootSquadInstance);
	end
end

function AIEncounterInstance:ReserveSquadDescription(squadDescList:table):handle
	local reservedSquad:handle = AI_ReserveEncounterSquadDescriptions(self.m_instanceIndex, squadDescList);
	return reservedSquad;
end

function AIEncounterInstance:ReserveSquadBuilderDescription(squadBuilderFunc:ifunction, intensity:number):handle
	if _G["SquadBuilderTable"] == nil then
		error("You must have tags\\scripts\\Enc2Library\\squadbuilderlibrary and its dependencies loaded to use this.  Exiting encounter creation.");
		return nil;
	end
	
	local squadDescription:SquadDescription = _G["SquadBuilderTable"]:Request(squadBuilderFunc);
	assert(squadDescription ~= nil, "Invalid squad builder passed to AIEncounterInstance:ReserveSquadBuilderDescription");
	intensity = intensity or SquadIntensity.Default;
	return self:ReserveSquadDescription(GetSquadTableFromDescription(squadDescription, intensity));
end

function AIEncounterInstance:ReserveSquadBuilderToObjective(objectiveInst:handle, squadBuilderFunc:ifunction, intensity:number):handle
	local squadInstance:handle = self:ReserveSquadBuilderDescription(squadBuilderFunc, intensity);
	self:AssignSquadInstanceToObjective(objectiveInst, squadInstance);
	return squadInstance;
end

function AIEncounterInstance:SpawnSquadToObjectiveLegacy(objectiveInstIndex:handle, squadBuilderNode:squad_builder_tree_node, userData:table):ai
	assert(squadBuilderNode ~= nil, "Invalid squad builder passed to AIEncounterInstance:SpawnSquadToObjectiveLegacy");
	local objectiveInstance = self.m_objectiveInstances[objectiveInstIndex];
	assert(nil ~= objectiveInstance, "invalid objective instance handle passed to AIEncounterInstance:SpawnSquadToObjectiveLegacy");
	
	local objectiveDef = objectiveInstance.m_objectiveDef;
	local mySquads:ai = AI_BuildObjectiveInstanceSquads(objectiveInstIndex, squadBuilderNode, 0, userData, objectiveDef:GetDeployInfo());
	
	-- Apply to objective root squad.
	local squadInstance:handle = AI_GetSquadInstanceFromAISquad(mySquads);
	AI_SetSquadInstanceParent(squadInstance, objectiveInstance.m_rootSquadInstance);

	return mySquads;
end

function AIEncounterInstance:Update():void
	while (self:GetPresence() ~= ENCOUNTER_PRESENCE.Invalid) do
		for k, objectiveInst:table in pairs(self.m_objectiveInstances) do
			objectiveInst:UpdateState();
		end
		sleep_s(1.0);
	end
	g_allEncounterInstances[self.m_instanceIndex] = nil;
end

function AIEncounterInstance:DestroyEncounter()
	AI_DestroyEncounterInstance(self.m_instanceIndex);
end

function AIEncounterInstance:GetObjectiveRootSquadInstance(objectiveInstIndex:handle):handle
	local objectiveInstance = self.m_objectiveInstances[objectiveInstIndex];
	return objectiveInstance:GetRootSquadInstance();
end

function AIEncounterInstance:GetObjectiveRootSquad(objectiveInstIndex:handle):ai
	local objectiveInstance = self.m_objectiveInstances[objectiveInstIndex];
	local rootSquad:ai = objectiveInstance:GetRootSquad();
	return rootSquad;
end

function AIEncounterInstance:GetBlackBoardInstance(objectiveInstIndex:handle):table
	local objectiveInstance = self.m_objectiveInstances[objectiveInstIndex];
	return objectiveInstance:GetBlackBoardInstance();
end

function AIEncounterInstance:GetObjectiveScriptInstance(objectiveInstIndex:handle):table
	assert(nil ~= objectiveInstIndex);
	local objectiveInstance = self.m_objectiveInstances[objectiveInstIndex];
	return objectiveInstance.m_scriptInstance;
end

function AIEncounterInstance:GetMeanPosition():vector
	return AI_GetEncounterMeanPosition(self.m_instanceIndex);
end

function AIEncounterInstance:GetPresence():encounter_presence
	return AI_GetEncounterPresence(self.m_instanceIndex);
end

function AIEncounterInstance:GetLivingCount():number
	local livingCount:number = 0;
	for _, objectiveInst:table in hpairs(self.m_objectiveInstances) do
		local rootSquad:ai = objectiveInst:GetRootSquad();
		livingCount = livingCount + ai_living_count(rootSquad);
	end
	return livingCount;
end

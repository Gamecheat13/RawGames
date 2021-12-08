-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


--****************************
--* AIObjectiveDefinition
--****************************

global g_BuildEmptySquadNode = nil;

-- The squad builder library is not global for tag reasons, but we want to support generating
-- empty container squads globally.
function GetEmptySquadBuilder():squad_builder_tree_node
	if (nil == g_BuildEmptySquadNode) then
		g_BuildEmptySquadNode = ai_sb_select_first();
	end
	return g_BuildEmptySquadNode;
end

global AIObjectiveDefinition:table = table.makePermanent
{
	m_objectiveHandle = -1,
	m_scriptDef = nil,
	m_graphContainer = {},
	m_blackboard = {},
	m_deploymentInfo = nil,
	m_finalized = false,
}

function AIObjectiveDefinition.New(name:string):table
	local objectiveDef:table = setmetatable({}, {__index = AIObjectiveDefinition});
	objectiveDef.m_objectiveHandle = AI_ObCreateObjectiveDefinition(name);
	
	local graphIndex:handle = AI_GetObjectiveDefinitionNodeGraph(objectiveDef.m_objectiveHandle);
	objectiveDef.m_graphContainer = AIGraphContainer.NewExisting(graphIndex);
	
	objectiveDef.m_scriptDef = nil;
	objectiveDef.m_blackboard = {};
	objectiveDef.m_deploymentInfo = nil;
	objectiveDef.m_finalized = false;
	
	return objectiveDef;
end

function AIObjectiveDefinition:GetGraphContainer():table
	return self.m_graphContainer;
end

function AIObjectiveDefinition:SetStartNode(node:ai):void
	AI_SetObjectiveDefinitionRootNode(self.m_objectiveHandle, node);
end

function AIObjectiveDefinition:SetDeployData(deployInfo:table):void
	self.m_deploymentInfo = deployInfo;
	AI_SetObjectiveDefinitionDeployInfo(self.m_objectiveHandle, deployInfo);
end

function AIObjectiveDefinition:SetScriptDef(scriptDef:table):void
	self.m_scriptDef = scriptDef;
end

function AIObjectiveDefinition:SetBlackBoard(blackboard:table):void
	if (blackboard:IsFinalized()) then
		self.m_blackboard = blackboard;
		AI_SetObjectiveBlackBoardDefinition(self.m_objectiveHandle, blackboard.m_handle);
	else
		assert(false, "Blackboards must be finalized before being set to an objective");
	end
end

function AIObjectiveDefinition:CreateObjectiveInstance(encounterInstIndex:handle, objInstIndex:handle, spawnAt:location, initParams):table
	local objectiveInst:table = AIObjectiveInstance.New(objInstIndex);
	local boardInstIndex:handle = AI_GetObjectiveInstanceBlackBoardInstance(objInstIndex);
	
	objectiveInst.m_encounterInstIndex = encounterInstIndex;
	objectiveInst.m_objectiveDef = self;
	objectiveInst.m_blackboardInst = AIBlackBoardInstance.NewExisting(self.m_blackboard, boardInstIndex);
	
	local emptySquadDescList:table = {};
	objectiveInst.m_rootSquadInstance = AI_ReserveEncounterSquadDescriptions(encounterInstIndex, emptySquadDescList);
	AI_AssignSquadInstanceToObjective(objInstIndex, objectiveInst.m_rootSquadInstance);
	
	if (nil ~= self.m_scriptDef and
		nil ~= self.m_scriptDef.CreateScriptInstance) then
		local placeTransform:matrix = ToLocation(spawnAt).matrix;
		local placePos:vector = placeTransform.pos;
		local placeYaw:number = math.rad(placeTransform.angles.z);
		objectiveInst.m_scriptInstance = self.m_scriptDef:CreateScriptInstance(objectiveInst, placePos, placeYaw, initParams);
	end
	
	return objectiveInst;
end

function AIObjectiveDefinition:GetDeployInfo():void
	return self.m_deploymentInfo;
end

function AIObjectiveDefinition:Finalize():void
	AI_FinalizeObjectiveDefinition(self.m_objectiveHandle);
	self.m_finalized = true;
end

function AIObjectiveDefinition:CreateSelector(name:string):ai
	local selector:ai = AI_ObCreateSelector(name);
	return selector;
end

function AIObjectiveDefinition:CreateSequence(name:string):ai
	local sequence:ai = AI_ObCreateSequence(name);
	return sequence;
end

function AIObjectiveDefinition:CreateBoolCondition(name:string, operator:bool_operator):ai
	local boolCond:ai = AI_ObBoolCondition(name, operator);
	return boolCond;
end

function AIObjectiveDefinition:CreateBodyCount(name:string, count:number):ai
	local bodyCount:ai = AI_ObCreateBodyCount(name, count);
	return bodyCount;
end

function AIObjectiveDefinition:CreateAssignmentLimit(name:string, count:number):ai
	local assignmentLimit:ai = AI_ObCreateAssignmentLimitCondition(name, BOOL_COMPARISON.LessThanEq, count);
	return assignmentLimit;
end

function AIObjectiveDefinition:CreateAssignmentLimitCondition(name:string, operator:bool_comparison, count:number):ai
	local assignmentLimit:ai = AI_ObCreateAssignmentLimitCondition(name, operator, count);
	return assignmentLimit;
end

function AIObjectiveDefinition:CreateKeywordFilter(name:string, keyword:string):ai
	local keywordFilter = AI_ObCreateKeywordFilter(name, keyword);
	return keywordFilter;
end

function AIObjectiveDefinition:CreateTaskCountFilter(name:string, taskNode:ai, comparison:bool_comparison, count:number):ai
	local taskCountFilter:ai = AI_ObCreateTaskCountFilter(name, taskNode, comparison, count);
	return taskCountFilter;
end

function AIObjectiveDefinition:CreateTask(name:string):ai
	local task:ai = ai_ob_create_task(name);
	return task;
end

function AIObjectiveDefinition:CreateCheckTaskState(name:string, taskNode, taskState):ai
	local taskCheck:ai = ai_ob_create_check_task_state(name, taskNode, taskState);
	return taskCheck;
end

function AIObjectiveDefinition:CreateGoToAreaOrder(name:string, areaNode:table):ai
	local goToArea:ai = AI_ObCreateGotoAreaOrder(name, areaNode.NodeID, areaNode.PinID);
	return goToArea;
end

function AIObjectiveDefinition:CreateHoldAreaOrder(name:string, areaNode:table, duration:number):ai
	local holdArea:ai = AI_ObCreateHoldAreaOrder(name, areaNode.NodeID, areaNode.PinID, duration);
	return holdArea;
end

function AIObjectiveDefinition:CreateAggressiveOrder(name:string, areaNode:table):ai
	local vehicleFilter:ai = AI_ObCreateAggressiveOrder(name, areaNode.NodeID, areaNode.PinID);
	return vehicleFilter;
end

function AIObjectiveDefinition:CreateDefensiveOrder(name:string, areaNode:table):ai
	local vehicleFilter:ai = AI_ObCreateDefensiveOrder(name, areaNode.NodeID, areaNode.PinID);
	return vehicleFilter;
end

function AIObjectiveDefinition:CreateCombatStatusFilter(name:string, comparison:bool_comparison, combatStatus:actor_combat_status):ai
	local combatStatusFilter:ai = AI_ObCreateCombatStatusFilter(name, comparison, combatStatus);
	return combatStatusFilter;
end

function AIObjectiveDefinition:CreateVehicleFilter(name:string, comparison:bool_comparison, compareValue:boolean):ai
	local vehicleFilter:ai = AI_ObCreateVehicleFilterNode(name, comparison, compareValue);
	return vehicleFilter;
end


--****************************
--* AIObjectiveInstance
--****************************

global AIObjectiveInstance:table = table.makePermanent
{
	m_encounterInstIndex = nil,
	m_instanceIndex = nil,
	m_objectiveDef = nil,
	m_blackboardInst = nil,
	m_scriptInstance = nil,	-- optional for objectives which require continuous updates.
	m_rootSquadInstance = nil,
}

function AIObjectiveInstance.New(objInstIndex:handle):table
	local objectiveInstance:table = setmetatable({}, {__index = AIObjectiveInstance});
	objectiveInstance.m_instanceIndex = objInstIndex;
	
	return objectiveInstance;
end

function AIObjectiveInstance:GetBlackBoardInstance():table
	return self.m_blackboardInst;
end

function AIObjectiveInstance:GetRootSquadInstance():handle
	return self.m_rootSquadInstance;
end

function AIObjectiveInstance:GetRootSquad():ai
	local rootSquad:ai = AI_GetAISquadFromSquadInstance(self.m_rootSquadInstance);
	return rootSquad;
end

function AIObjectiveInstance:UpdateState():void
	if (nil ~= self.m_scriptInstance) then
		self.m_scriptInstance:UpdateState();
	end
end

function AIObjectiveInstance:EvaluateNodeVector(evalNode):vector
	return AI_EvaluateObjectiveNodeVector(self.m_instanceIndex, evalNode.NodeID, evalNode.PinID);
end
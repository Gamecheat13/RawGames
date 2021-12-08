-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


-- Table representing information needed for operation of the objective controller.
global HoldAreaObjective:table = table.makePermanent
{
	m_objectiveDef = {},
	m_instanceParams = nil,
}

global HoldAreaInstance:table = table.makePermanent
{
	m_scriptDef = nil,
	m_objectiveInst = nil,
	m_holdPos = nil,
	m_holdRadius = nil,
	m_spawnRadius = nil,
}

-- Table of constants representing entries in the blackboard and other reused strings.
global HoldAreaObjectiveConst:table = table.makePermanent
{
	holdPos = "holdPos",
	holdRadius = "holdRadius",
	holdArea = "holdArea",
	spawnRadius = "spawnRadius",
	spawnArea = "spawnArea",
};

hstructure HoldAreaObjectiveParam
	m_holdRadius	:number;
	m_spawnRadius	:number;
	m_intent		:string;
end

function HoldAreaObjectiveParam_GetXXS():HoldAreaObjectiveParam
	local paramObj:HoldAreaObjectiveParam = hmake HoldAreaObjectiveParam
	{
		m_holdRadius = 2,
		m_spawnRadius = 1,
		m_intent = ObjectiveIntent.Normal,
	}
	return paramObj;
end

function HoldAreaObjectiveParam_GetLarge():HoldAreaObjectiveParam
	local paramObj:HoldAreaObjectiveParam = hmake HoldAreaObjectiveParam
	{
		m_holdRadius = 10,
		m_spawnRadius = 5,
		m_intent = ObjectiveIntent.Normal,
	}
	return paramObj;
end

function HoldAreaObjectiveParam_GetLargeDefensive():HoldAreaObjectiveParam
	local paramObj:HoldAreaObjectiveParam = hmake HoldAreaObjectiveParam
	{
		m_holdRadius = 10,
		m_spawnRadius = 5,
		m_intent = ObjectiveIntent.Defensive,
	}
	return paramObj;
end

function HoldAreaObjectiveParam_GetXXL():HoldAreaObjectiveParam
	local paramObj:HoldAreaObjectiveParam = hmake HoldAreaObjectiveParam
	{
		m_holdRadius = 40,
		m_spawnRadius = 5,
		m_intent = ObjectiveIntent.Normal,
	}
	return paramObj;
end


-- Function for creating the scripted objective definition.
function HoldAreaObjective:Create(instanceParamFunc:ifunction):table
	local data:table = setmetatable({}, {__index = HoldAreaObjective});
	data.m_instanceParams = nil;
	assert(nil ~= instanceParamFunc);
	data.m_instanceParams = instanceParamFunc();
	
	-- Create wrapper for code side objective definition.
	local objectiveDef:table = AIObjectiveDefinition.New("HoldAreaObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	-- Make a blackboard definition for the encounter.
	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(HoldAreaObjectiveConst.holdPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(HoldAreaObjectiveConst.holdRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(HoldAreaObjectiveConst.spawnRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	-- Finalize the blackboard indicating no further changes will be made.
	boardDef:Finalize();
	-- Apply blackboard for use with this objective definition.
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	-- Create helper container for areas.
	local areaTable:table = AIAreaTable:New();
	
	-- Create a floodfill area generator node. It will generate a capsule shaped area from the startposition
	-- to the endposition with the given radius. Input values are assigned through links to other nodes or
	-- blackboard entries.
	local holdFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.holdPos, holdFlood.StartPosition);
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.holdPos, holdFlood.EndPosition);
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.holdRadius, holdFlood.Radius);
	areaTable:AddArea(holdFlood.AreasOut, {HoldAreaObjectiveConst.holdArea});

	-- Create the floodfill that we're going to use for spawning (which can be different than the general
	-- floodfill for the area they should defend)
	local spawnFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.holdPos, spawnFlood.StartPosition);
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.holdPos, spawnFlood.EndPosition);
	boardDef:CreateNodeInputLink(HoldAreaObjectiveConst.spawnRadius, spawnFlood.Radius);
	areaTable:AddArea(spawnFlood.AreasOut, {HoldAreaObjectiveConst.spawnArea});

-- DEPLOYMENT
	-- Create the deployment info wrapper
	local deploymentInfo:table = AIDeploymentInfo.New();
	-- Squads may be deployed in limbo or standard mode.
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	-- Assign spawn areas from the area table. In this case our only area is the hold area which assigned as the default
	-- spawn area.
	deploymentInfo:AddSpawnAreas(areaTable, HoldAreaObjectiveConst.spawnArea, ObjectiveSpawnKeywords.Default);
	-- Assign the deploy info to the objective.
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	-- Create a logical selector node for the behavior tree. This may have multiple child nodes. It will choose
	-- the first successful branch as the operating behavior.
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	-- Set the selector as the root node of the objective behavior tree.
	objectiveDef:SetStartNode(selectRoot);
	
	-- Create vehicle task
	local vehicleFilter = objectiveDef:CreateVehicleFilter("Vehicle Filter Task", BOOL_COMPARISON.Equal, true);
	ai_ob_add_child(selectRoot, vehicleFilter);
	
	local holdAreas:table = areaTable:GetAreasWithKeyword(HoldAreaObjectiveConst.holdArea);
	local vehicleTask:ai = objectiveDef:CreateHoldAreaOrder("Vehicle Task", holdAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(vehicleFilter, vehicleTask);

	-- Create a task for squads to be assigned into.
	if (data.m_instanceParams.m_intent == ObjectiveIntent.Defensive) then
		local defensiveOrder:ai = objectiveDef:CreateDefensiveOrder("Default Order", holdAreas[1]);
		ai_ob_add_child(selectRoot, defensiveOrder);
	else
		local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", holdAreas[1], k_OrderDurationInfinite);
		ai_ob_add_child(selectRoot, defaultTask);
	end

-- ENCOUNTER DATA
	-- Create the objective controller definition data.
	data.m_objectiveDef = objectiveDef;
	
	-- Assign objective controller to the objective definition for its processes.
	objectiveDef:SetScriptDef(data);
	-- Finalize the objective, indicating we will not try to make further changes to the objective
	-- definition after this point.
	objectiveDef:Finalize();
	
	return objectiveDef;
end

-- Function which handles initialization of an objecive controller instance.
function HoldAreaObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:HoldAreaObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData:table = setmetatable({}, {__index = HoldAreaInstance});
	instData.m_scriptDef = self;
	instData.m_objectiveInst = objectiveInstance;
	
	local setParams:HoldAreaObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.m_instanceParams);
		setParams = self.m_instanceParams;
	end
	
	instData.m_holdPos = placePos;
	instData.m_holdRadius = setParams.m_holdRadius;
	instData.m_spawnRadius = setParams.m_spawnRadius;
	
	instData:UpdateState();
	
	return instData;
end

function HoldAreaInstance:SetHoldPosition(holdPos:vector):void
	self.m_holdPos = holdPos;
end

function HoldAreaInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	
	-- Update our blackboard entry for the hold area position. We only need to do this once for this objective.
	boardInst:UpdateEntry(HoldAreaObjectiveConst.holdPos, self.m_holdPos);
	boardInst:UpdateEntry(HoldAreaObjectiveConst.holdRadius, self.m_holdRadius);
	boardInst:UpdateEntry(HoldAreaObjectiveConst.spawnRadius, self.m_spawnRadius);
end



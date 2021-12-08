-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


-- Table representing information needed for operation of the objective controller.
global FanOutObjective:table = table.makePermanent
{
	m_objectiveDef = {},
	m_instanceParams = nil,
}

global FanOutInstance:table = table.makePermanent
{
	m_scriptDef = nil,
	m_objectiveInst = nil,
	m_holdPos = nil,
	m_innerRadius = nil,
	m_outerRadius = nil,
}

-- Table of constants representing entries in the blackboard and other reused strings.
global FanOutObjectiveConst:table = table.makePermanent
{
	floodPos = "floodPos",
	circlePos = "circlePos",
	innerRadius = "innerRadius",
	outerRadius = "outerRadius",
	holdArea = "holdArea",
};

hstructure FanOutObjectiveParam
	m_innerRadius	:number;
	m_outerRadius	:number;
end

function FanOutObjectiveParam_GetLarge():FanOutObjectiveParam
	local paramObj:FanOutObjectiveParam = hmake FanOutObjectiveParam
	{
		m_innerRadius = 10,
		m_outerRadius = 16,
	}
	return paramObj;
end


function FanOutObjective:Create(instanceParamFunc:ifunction):table
	-- Create wrapper for code side objective definition.
	local objectiveDef:table = AIObjectiveDefinition.New("FanOutObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	-- Make a blackboard definition for the encounter.
	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(FanOutObjectiveConst.floodPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(FanOutObjectiveConst.circlePos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(FanOutObjectiveConst.innerRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(FanOutObjectiveConst.outerRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:Finalize();
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	local areaTable:table = AIAreaTable:New();
	
	local holdFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(FanOutObjectiveConst.floodPos, holdFlood.StartPosition);
	boardDef:CreateNodeInputLink(FanOutObjectiveConst.floodPos, holdFlood.EndPosition);
	boardDef:CreateNodeInputLink(FanOutObjectiveConst.outerRadius, holdFlood.Radius);
	
	local guardAreaCut:ai = graph:CreateCircleCut();
	NG.CreateLink(holdFlood.AreasOut, guardAreaCut.Areas);
	boardDef:CreateNodeInputLink(FanOutObjectiveConst.circlePos, guardAreaCut.CircleCenter);
	boardDef:CreateNodeInputLink(FanOutObjectiveConst.innerRadius, guardAreaCut.CircleRadius);
	
	areaTable:AddArea(guardAreaCut.OutterAreasOut, {FanOutObjectiveConst.holdArea});

-- DEPLOYMENT
	local deploymentInfo:table = AIDeploymentInfo.New();
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	deploymentInfo:AddSpawnAreas(areaTable, FanOutObjectiveConst.holdArea, ObjectiveSpawnKeywords.Default);
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	objectiveDef:SetStartNode(selectRoot);

	local holdAreas:table = areaTable:GetAreasWithKeyword(FanOutObjectiveConst.holdArea);
	local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", holdAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(selectRoot, defaultTask);

-- ENCOUNTER DATA
	local contollerScript:table = setmetatable({}, {__index = FanOutObjective});
	contollerScript.m_objectiveDef = objectiveDef;
	contollerScript.m_instanceParams = nil;
	if (nil ~= instanceParamFunc) then
		contollerScript.m_instanceParams = instanceParamFunc();
	end
	
	objectiveDef:SetScriptDef(contollerScript);
	objectiveDef:Finalize();
	
	return objectiveDef;
end

function FanOutObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:FanOutObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData:table = setmetatable({}, {__index = FanOutInstance});
	instData.m_scriptDef = self;
	instData.m_objectiveInst = objectiveInstance;
	
	local setParams:FanOutObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.m_instanceParams);
		setParams = self.m_instanceParams;
	end
	
	instData.m_holdPos = placePos;
	instData.m_innerRadius = setParams.m_innerRadius;
	instData.m_outerRadius = setParams.m_outerRadius;
	
	instData:UpdateState();
	
	return instData;
end

function FanOutInstance:SetCenterPosition(holdPos:vector):void
	self.m_holdPos = holdPos;
end

function FanOutInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	
	boardInst:UpdateEntry(FanOutObjectiveConst.floodPos, self.m_holdPos);
	boardInst:UpdateEntry(FanOutObjectiveConst.circlePos, self.m_holdPos);
	boardInst:UpdateEntry(FanOutObjectiveConst.innerRadius, self.m_innerRadius);
	boardInst:UpdateEntry(FanOutObjectiveConst.outerRadius, self.m_outerRadius);
end



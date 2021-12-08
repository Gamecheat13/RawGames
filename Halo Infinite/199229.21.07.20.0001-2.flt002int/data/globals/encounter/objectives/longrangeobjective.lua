-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


-- Table representing information needed for operation of the objective controller.
global LongRangeObjective:table = table.makePermanent
{
	m_objectiveDef = {},
	m_instanceParams = nil,
}

global LongRangeInstance:table = table.makePermanent
{
	m_scriptDef = nil,
	m_objectiveInst = nil,
	m_state = 0,
	m_targetUnit = nil,
	m_defendPos = vector(0,0,0),
	m_innerRadius = 4,
	m_outerRadius = 10,
	m_alertRadius = 20,
	m_fleeRadius = 30,
}

global LongRangeState:table = table.makeEnum
{
	HoldInnerCircle = 0,
	HoldOuterCircle = 1,
	AdvanceToAlert = 2,
}

-- Table of constants representing entries in the blackboard and other reused strings.
global LongRangeObjectiveConst:table = table.makePermanent
{
	defendPos = "defendPos",
	expandPos = "expandPos",
	circleRadius = "circleRadius",
	approachRadius = "approachRadius",
	holdArea = "holdArea",
	approachArea = "approachArea",
};

hstructure LongRangeObjectiveParam
	m_targetUnit 	:object;	-- Unit to orient toward.
	m_innerRadius	:number;	-- inner circle spawn radius
	m_outerRadius	:number;	-- outer circle radius after alert
	m_alertRadius	:number;
	m_fleeRadius	:number;
	m_intent		:string;
end

function LongRangeObjectiveParam_GetLarge():LongRangeObjectiveParam
	local paramObj:LongRangeObjectiveParam = hmake LongRangeObjectiveParam
	{
		m_targetUnit = PLAYERS.player0,
		m_innerRadius = 5,
		m_outerRadius = 10,
		m_alertRadius = 15,
		m_fleeRadius = 20,
		m_intent = ObjectiveIntent.Normal,
	}
	return paramObj;
end

function LongRangeObjectiveParam_GetLargeDefensive():LongRangeObjectiveParam
	local params = LongRangeObjectiveParam_GetLarge();
	params.m_intent = ObjectiveIntent.Defensive;
	return params;
end


-- Function for creating the scripted objective definition.
function LongRangeObjective:Create(instanceParamFunc:ifunction):table
	local data:table = setmetatable({}, {__index = LongRangeObjective});
	data.m_instanceParams = nil;
	assert(nil ~= instanceParamFunc);
	data.m_instanceParams = instanceParamFunc();
	
	local objectiveDef:table = AIObjectiveDefinition.New("LongRangeObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(LongRangeObjectiveConst.defendPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(LongRangeObjectiveConst.expandPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(LongRangeObjectiveConst.circleRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(LongRangeObjectiveConst.approachRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:Finalize();
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	local areaTable:table = AIAreaTable:New();
	
	local holdFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.defendPos, holdFlood.StartPosition);
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.defendPos, holdFlood.EndPosition);
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.circleRadius, holdFlood.Radius);
	
	areaTable:AddArea(holdFlood.AreasOut, {LongRangeObjectiveConst.holdArea});
	
	local approachFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.defendPos, approachFlood.StartPosition);
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.expandPos, approachFlood.EndPosition);
	boardDef:CreateNodeInputLink(LongRangeObjectiveConst.approachRadius, approachFlood.Radius);
	
	areaTable:AddArea(approachFlood.AreasOut, {LongRangeObjectiveConst.approachArea});

-- DEPLOYMENT
	local deploymentInfo:table = AIDeploymentInfo.New();
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	deploymentInfo:AddSpawnAreas(areaTable, LongRangeObjectiveConst.holdArea, ObjectiveSpawnKeywords.Default);
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	objectiveDef:SetStartNode(selectRoot);
	
	if (data.m_instanceParams.m_intent == ObjectiveIntent.Defensive) then
		local holdAreas = areaTable:GetAreasWithKeyword(LongRangeObjectiveConst.holdArea);
		local defensiveOrder:ai = objectiveDef:CreateDefensiveOrder("Default Order", holdAreas[1]);
		areaTable:AddAreasToOrder(defensiveOrder, LongRangeObjectiveConst.approachArea);
		ai_ob_add_child(selectRoot, defensiveOrder);
	else
		local holdAreas:table = areaTable:GetAreasWithKeyword(LongRangeObjectiveConst.holdArea);
		local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", holdAreas[1], k_OrderDurationInfinite);
		ai_ob_add_child(selectRoot, defaultTask);
	end

-- ENCOUNTER DATA
	data.m_objectiveDef = objectiveDef;
	
	objectiveDef:SetScriptDef(data);
	objectiveDef:Finalize();
	
	return objectiveDef;
end

function LongRangeObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:LongRangeObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData:table = setmetatable({}, {__index = LongRangeInstance});
	instData.m_scriptDef = self;
	instData.m_objectiveInst = objectiveInstance;
	instData.m_state = LongRangeState.HoldInnerCircle;
	instData.m_defendPos = placePos;
	
	local setParams:LongRangeObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.m_instanceParams);
		setParams = self.m_instanceParams;
	end
	
	instData.m_targetUnit = setParams.m_targetUnit;
	instData.m_innerRadius = setParams.m_innerRadius;
	instData.m_outerRadius = setParams.m_outerRadius;
	instData.m_alertRadius = setParams.m_alertRadius;
	instData.m_fleeRadius = setParams.m_fleeRadius;
	
	instData:UpdateState();
	
	return instData;
end

function LongRangeInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	boardInst:UpdateEntry(LongRangeObjectiveConst.defendPos, self.m_defendPos);
	
	local targetPos:vector = self.m_defendPos;
	if (true == Object_IsUnit(self.m_targetUnit)) then
		targetPos = ToLocation(self.m_targetUnit).vector;
	end
	
	local facingDir:vector = (targetPos - self.m_defendPos);
	local distFromDefendPoint:number = facingDir.length;
	facingDir = facingDir * (1.0 / distFromDefendPoint);
	
	if (LongRangeState.HoldInnerCircle == self.m_state) then
		boardInst:UpdateEntry(LongRangeObjectiveConst.expandPos, self.m_defendPos);
		boardInst:UpdateEntry(LongRangeObjectiveConst.circleRadius, self.m_innerRadius);
		boardInst:UpdateEntry(LongRangeObjectiveConst.approachRadius, self.m_innerRadius);
		
		if (distFromDefendPoint < self.m_alertRadius) then
			self.m_state = LongRangeState.HoldOuterCircle;
		end
	elseif (LongRangeState.HoldOuterCircle == self.m_state) then
		boardInst:UpdateEntry(LongRangeObjectiveConst.expandPos, self.m_defendPos);
		boardInst:UpdateEntry(LongRangeObjectiveConst.circleRadius, self.m_outerRadius);
		boardInst:UpdateEntry(LongRangeObjectiveConst.approachRadius, self.m_outerRadius);
		
		if (distFromDefendPoint > self.m_alertRadius) then
			self.m_state = LongRangeState.AdvanceToAlert;
		end
	elseif (LongRangeState.AdvanceToAlert == self.m_state) then
		local expansionPos:vector = self.m_defendPos + (facingDir * (self.m_fleeRadius - self.m_outerRadius));
		boardInst:UpdateEntry(LongRangeObjectiveConst.expandPos, expansionPos);
		boardInst:UpdateEntry(LongRangeObjectiveConst.circleRadius, self.m_outerRadius);
		boardInst:UpdateEntry(LongRangeObjectiveConst.approachRadius, self.m_outerRadius);
		
		if (distFromDefendPoint > self.m_fleeRadius) then
			self.m_state = LongRangeState.HoldInnerCircle;
		end
	else
		error("Long range objective: Unknown state");
	end
end




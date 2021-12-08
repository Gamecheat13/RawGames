-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


global FollowUnitObjective:table = table.makePermanent
{
	m_objectiveDef = {},
	m_instanceParams = nil,
}

global FollowUnitInstance:table = table.makePermanent
{
	m_followScript = nil,
	m_objectiveInst = nil,
	m_targetUnit = nil,
	m_lastTargetPos = nil,
	m_facingVector = vector(0,0,0),
	m_followRadius = 5.0,
	m_targetRadius = 1.5,
	m_rowGap = 1.0,
}

global FollowUnitObjectiveConst:table = table.makePermanent
{
	targetPos = "targetPos",
	frontPos = "frontPos",
	backPos = "backPos",
	followRadius = "followRadius",
	targetRadius = "targetRadius",
	rowGap = "rowGap",
	frontArea = "frontArea",
	middleArea = "middleArea",
	backArea = "backArea",
};

hstructure FollowUnitObjectiveParam
	m_targetUnit 			:object;
	m_followRadius			:number;
	m_targetRadius			:number;
	m_rowGap				:number;
	m_updateFacingDistance	:number;
end

function FollowUnitObjectiveParam_GetSmall():FollowUnitObjectiveParam
	local followObj:FollowUnitObjectiveParam = hmake FollowUnitObjectiveParam
	{
		m_targetUnit = PLAYERS.player0,
		m_followRadius = 5.0,
		m_targetRadius = 1.5,
		m_rowGap = 1.0,
		m_updateFacingDistance = 2.0,
	}
	return followObj;
end


function FollowUnitObjective:Create(instanceParamFunc:ifunction):table
	local objectiveDef:table = AIObjectiveDefinition.New("FollowUnitObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(FollowUnitObjectiveConst.targetPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(FollowUnitObjectiveConst.frontPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(FollowUnitObjectiveConst.backPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(FollowUnitObjectiveConst.followRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(FollowUnitObjectiveConst.targetRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(FollowUnitObjectiveConst.rowGap, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:Finalize();
	
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	local areaTable:table = AIAreaTable:New();
	
	local followFlood:ai = graph:CreateFloodFill();
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.targetPos, followFlood.StartPosition);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.targetPos, followFlood.EndPosition);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.followRadius, followFlood.Radius);
	
	-- Cut out the circle center to keep AI from crowding the follow target.
	local targetAreaCut:ai = graph:CreateCircleCut();
	NG.CreateLink(followFlood.AreasOut, targetAreaCut.Areas);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.targetPos, targetAreaCut.CircleCenter);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.targetRadius, targetAreaCut.CircleRadius);
	
	-- Slice the donut up into the 3 rows.
	local forwardCutFraction:table = graph:CreateConstantFloat(0.66);
	local backCutFraction:table = graph:CreateConstantFloat(0.33);
	
	local forwardCrosscut:table = graph:CreateCrosscut();
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.backPos, forwardCrosscut.SegmentStart);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.frontPos, forwardCrosscut.SegmentEnd);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.rowGap, forwardCrosscut.Gap);
	NG.CreateLink(forwardCutFraction.Out, forwardCrosscut.Fraction);
	NG.CreateLink(targetAreaCut.OutterAreasOut, forwardCrosscut.Areas);
	
	areaTable:AddArea(forwardCrosscut.FarAreasOut, {FollowUnitObjectiveConst.frontArea});
	
	local backCrosscut:table = graph:CreateCrosscut();
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.backPos, backCrosscut.SegmentStart);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.frontPos, backCrosscut.SegmentEnd);
	boardDef:CreateNodeInputLink(FollowUnitObjectiveConst.rowGap, backCrosscut.Gap);
	NG.CreateLink(backCutFraction.Out, backCrosscut.Fraction);
	NG.CreateLink(forwardCrosscut.NearAreasOut, backCrosscut.Areas);
	
	areaTable:AddArea(backCrosscut.FarAreasOut, {FollowUnitObjectiveConst.middleArea});
	areaTable:AddArea(backCrosscut.NearAreasOut, {FollowUnitObjectiveConst.backArea});

-- DEPLOYMENT
	local deploymentInfo:table = AIDeploymentInfo.New();
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	deploymentInfo:AddSpawnAreas(areaTable, FollowUnitObjectiveConst.backArea, ObjectiveSpawnKeywords.Default);
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	objectiveDef:SetStartNode(selectRoot);
	
	local filterFront:ai = objectiveDef:CreateKeywordFilter("front filter", ObjectiveTaskKeywords.Frontline);
	ai_ob_add_child(selectRoot, filterFront);
	local frontAreas:table = areaTable:GetAreasWithKeyword(FollowUnitObjectiveConst.frontArea);
	local frontTask:ai = objectiveDef:CreateHoldAreaOrder("Front Task", frontAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(filterFront, frontTask);
	
	local checkReserveOrMidline:ai = objectiveDef:CreateBoolCondition("Reserve or Midline", BOOL_OPERATOR.Or);
	ai_ob_add_child(selectRoot, checkReserveOrMidline);
	local filterReserve:ai = objectiveDef:CreateKeywordFilter("reserve filter", ObjectiveTaskKeywords.Reserve);
	local filterMidline:ai = objectiveDef:CreateKeywordFilter("midline filter", ObjectiveTaskKeywords.Midline);
	ai_ob_add_child(checkReserveOrMidline, filterReserve);
	ai_ob_add_child(checkReserveOrMidline, filterMidline);
	local middleAreas:table = areaTable:GetAreasWithKeyword(FollowUnitObjectiveConst.middleArea);
	local middleTask:ai = objectiveDef:CreateHoldAreaOrder("Middle Task", middleAreas[1], k_OrderDurationInfinite);
	AI_SetBoolConditionActionNode(checkReserveOrMidline, middleTask);
	
	local filterBack:ai = objectiveDef:CreateKeywordFilter("back filter", ObjectiveTaskKeywords.Command);
	ai_ob_add_child(selectRoot, filterBack);
	local backAreas:table = areaTable:GetAreasWithKeyword(FollowUnitObjectiveConst.backArea);
	local backTask:ai = objectiveDef:CreateHoldAreaOrder("Back Task", backAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(filterBack, backTask);

	local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", backAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(selectRoot, defaultTask);

-- ENCOUNTER DATA
	local contollerScript:table = setmetatable({}, {__index = FollowUnitObjective});
	contollerScript.m_objectiveDef = objectiveDef;
	contollerScript.m_instanceParams = nil;
	if (nil ~= instanceParamFunc) then
		contollerScript.m_instanceParams = instanceParamFunc();
	end
	
	objectiveDef:SetScriptDef(contollerScript);
	objectiveDef:Finalize();
	
	return objectiveDef;
end

function FollowUnitObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:FollowUnitObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData:table = setmetatable({}, {__index = FollowUnitInstance});
	instData.m_followScript = self;
	instData.m_objectiveInst = objectiveInstance;
	instData.m_lastTargetPos = placePos;
	instData.m_facingVector = vector(math.cos(placeFacing), math.sin(placeFacing), 0);
	
	local setParams:FollowUnitObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.m_instanceParams);
		setParams = self.m_instanceParams;
	end
	
	instData.m_followRadius = setParams.m_followRadius;
	instData.m_targetRadius = setParams.m_targetRadius;
	instData.m_rowGap = setParams.m_rowGap;
	instData.m_updateFacingDistance = setParams.m_updateFacingDistance;
	instData.m_targetUnit = setParams.m_targetUnit;
	
	instData:UpdateState();
	
	return instData;
end

function FollowUnitInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	
	local targetPos:vector = self.m_lastTargetPos;
	if (true == Object_IsUnit(self.m_targetUnit)) then
		targetPos = ToLocation(self.m_targetUnit).vector;
	end
	boardInst:UpdateEntry(FollowUnitObjectiveConst.targetPos, targetPos);
	
	local facingDir:vector = (targetPos - self.m_lastTargetPos);
	local distFromLastPoint:number = facingDir.length;
	if (distFromLastPoint > self.m_updateFacingDistance) then
		-- Target moved enough to update our facing.
		self.m_facingVector = facingDir * (1.0 / distFromLastPoint);
		self.m_lastTargetPos = targetPos;
	end
	
	local frontPosition:vector = targetPos + (self.m_facingVector * self.m_followRadius);
	boardInst:UpdateEntry(FollowUnitObjectiveConst.frontPos, frontPosition);
	
	local backPosition:vector = targetPos - (self.m_facingVector * self.m_followRadius);
	boardInst:UpdateEntry(FollowUnitObjectiveConst.backPos, backPosition);
	
	boardInst:UpdateEntry(FollowUnitObjectiveConst.followRadius, self.m_followRadius);
	boardInst:UpdateEntry(FollowUnitObjectiveConst.targetRadius, self.m_targetRadius);
	boardInst:UpdateEntry(FollowUnitObjectiveConst.rowGap, self.m_rowGap);
end







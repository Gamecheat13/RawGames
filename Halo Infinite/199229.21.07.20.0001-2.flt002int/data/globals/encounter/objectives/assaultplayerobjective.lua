-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER


global AssaultPlayerObjective:table = table.makePermanent
{
	playerPosNode = nil,
	pathCastNode = nil,
	instanceParams = nil,
}

--[[
-------------------
AssaultPlayer Objective Parameters

The radii parameters on the assault objective are for the rows.
There are three rows which orient towards the squad's target (front, middle, back). These rows can have configurable spacing and size.
m_visibilityRadius, the maximum radius at which they will recognize a player position.
-------------------
]]--

global AssaultPlayerInstance:table = table.makePermanent
{
	m_scriptDef = nil,
	m_objectiveInst = nil,
	m_frontCenterPos = nil,
	m_defaultFacing = 0,
	m_backRowOffset = 1,
	m_middleRowOffset = 1,
	m_frontRowOffset = 1,
	m_backRowLength = 5,
	m_backRowRadius = 2,
	m_middleRowLength = 4,
	m_middleRowRadius = 2,
	m_frontRowLength = 3,
	m_frontRowRadius = 2,
	m_visibilityRadius = 30,
}

global AssaultPlayerObjectiveConst:table = table.makePermanent
{
	frontArea = "frontArea",
	middleArea = "middleArea",
	backArea = "backArea",
	
	pathCastStart = "pathCastStart",
	pathCastEnd = "pathCastEnd",
	
	frontStartPos = "frontStartPos",
	frontEndPos = "frontEndPos",
	frontRadius = "frontRadius",
	
	middleCenterPos = "middleCenterPos",
	middleStartPos = "middleStartPos",
	middleEndPos   = "middleEndPos",
	middleRadius   = "middleRadius",
	
	backStartPos = "backStartPos",
	backEndPos   = "backEndPos",
	backRadius   = "backRadius",
	
	visibilityRadius = "visibilityRadius",
	squadIndex = "squadIndex",
};

hstructure AssaultPlayerObjectiveParam
	m_backRowOffset		:number;
	m_middleRowOffset	:number;
	m_frontRowOffset	:number;
	m_backRowLength		:number;
	m_backRowRadius		:number;
	m_middleRowLength	:number;
	m_middleRowRadius	:number;
	m_frontRowLength	:number;
	m_frontRowRadius	:number;
	m_visibilityRadius	:number;
end

function AssaultPlayerObjectiveParam_GetSmall():AssaultPlayerObjectiveParam
	local assaultObj:AssaultPlayerObjectiveParam = hmake AssaultPlayerObjectiveParam
	{
		m_backRowOffset = 4,
		m_middleRowOffset = 4,
		m_frontRowOffset = 6,
		m_backRowLength = 8,
		m_backRowRadius = 1.5,
		m_middleRowLength = 7,
		m_middleRowRadius = 1.5,
		m_frontRowLength = 6,
		m_frontRowRadius = 1.5,
		m_visibilityRadius = 30,
	}
	return assaultObj;
end

function AssaultPlayerObjectiveParam_GetLarge():AssaultPlayerObjectiveParam
	local assaultObj:AssaultPlayerObjectiveParam = hmake AssaultPlayerObjectiveParam
	{
		m_backRowOffset = 4,
		m_middleRowOffset = 4,
		m_frontRowOffset = 6,
		m_backRowLength = 8,
		m_backRowRadius = 1.5,
		m_middleRowLength = 7,
		m_middleRowRadius = 1.5,
		m_frontRowLength = 6,
		m_frontRowRadius = 1.5,
		m_visibilityRadius = 50,
	}
	return assaultObj;
end


-- Helper for a two parameter boolean evaluation.
function BoolConditionHelper(objectiveDef:table, parent:ai, child:ai, condition:bool_operator, paramNodeA:ai, paramNodeB:ai)
	local boolNode:ai = objectiveDef:CreateBoolCondition("BoolCondition", BOOL_OPERATOR.Or);
	ai_ob_add_child(parent, boolNode);
	ai_ob_add_child(boolNode, paramNodeA);
	ai_ob_add_child(boolNode, paramNodeB);
	AI_SetBoolConditionActionNode(boolNode, child);
	
	return boolNode;
end

-- Function for creating the scripted objective definition.
function AssaultPlayerObjective:Create(instanceParamFunc:ifunction):table
	
	-- Create wrapper for code side objective definition.
	local objectiveDef:table = AIObjectiveDefinition.New("AssaultPlayerObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	-- Make a blackboard for the objective.
	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(AssaultPlayerObjectiveConst.pathCastStart, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.pathCastEnd, BLACKBOARD_ENTRY_TYPE.Vector);
	
	boardDef:AddEntry(AssaultPlayerObjectiveConst.frontStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.frontEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.frontRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(AssaultPlayerObjectiveConst.middleCenterPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.middleStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.middleEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.middleRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(AssaultPlayerObjectiveConst.backStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.backEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.backRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(AssaultPlayerObjectiveConst.visibilityRadius, BLACKBOARD_ENTRY_TYPE.Float);
	boardDef:AddEntry(AssaultPlayerObjectiveConst.squadIndex, BLACKBOARD_ENTRY_TYPE.AiIndex);
	
	boardDef:Finalize();
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	local areaTable:table = AIAreaTable:New();
	
	-- Path cast node.
	local pathCastNode:table = graph:CreateNearestPositionPathCast();
	boardDef:CreateNodeInputLink(AssaultPlayerObjectiveConst.pathCastStart, pathCastNode.StartPosition);
	boardDef:CreateNodeInputLink(AssaultPlayerObjectiveConst.pathCastEnd, pathCastNode.GoalPosition);
	
	local frontFlood:table = NavmeshFloodfillHelper(graph, boardDef, AssaultPlayerObjectiveConst.frontStartPos, AssaultPlayerObjectiveConst.frontEndPos, AssaultPlayerObjectiveConst.frontRadius);
	areaTable:AddArea(frontFlood.AreasOut, {AssaultPlayerObjectiveConst.frontArea});
	
	local middleFlood:table = NavmeshFloodfillHelper(graph, boardDef, AssaultPlayerObjectiveConst.middleStartPos, AssaultPlayerObjectiveConst.middleEndPos, AssaultPlayerObjectiveConst.middleRadius);
	areaTable:AddArea(middleFlood.AreasOut, {AssaultPlayerObjectiveConst.middleArea});
	
	local backFlood:table = NavmeshFloodfillHelper(graph, boardDef, AssaultPlayerObjectiveConst.backStartPos, AssaultPlayerObjectiveConst.backEndPos, AssaultPlayerObjectiveConst.backRadius);
	areaTable:AddArea(backFlood.AreasOut, {AssaultPlayerObjectiveConst.backArea});
	
	local visRefreshTime:number = 1.0;
	local nearPlayerPos:table = graph:CreateNearestVisiblePlayer(visRefreshTime);
	boardDef:CreateNodeInputLink(AssaultPlayerObjectiveConst.middleCenterPos, nearPlayerPos.Position);
	boardDef:CreateNodeInputLink(AssaultPlayerObjectiveConst.visibilityRadius, nearPlayerPos.Radius);
	boardDef:CreateNodeInputLink(AssaultPlayerObjectiveConst.squadIndex, nearPlayerPos.VisSquad);

-- DEPLOYMENT
	local deploymentInfo:table = AIDeploymentInfo.New();
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	deploymentInfo:AddSpawnAreas(areaTable, AssaultPlayerObjectiveConst.frontArea, ObjectiveSpawnKeywords.Default);
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	objectiveDef:SetStartNode(selectRoot);

-- Front Row
	-- Filter branch by frontline squad types.
	local filterFront:ai = objectiveDef:CreateKeywordFilter("front filter", ObjectiveTaskKeywords.Frontline);
	ai_ob_add_child(selectRoot, filterFront);
	
	local frontAreas:table = areaTable:GetAreasWithKeyword(AssaultPlayerObjectiveConst.frontArea);
	local frontTask:ai = objectiveDef:CreateHoldAreaOrder("Front Task", frontAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(filterFront, frontTask);
	
-- Middle Row
	-- Filter branch by reserve or midline squad types.
	local filterReserve:ai = objectiveDef:CreateKeywordFilter("reserve filter", ObjectiveTaskKeywords.Reserve);
	local filterMidline:ai = objectiveDef:CreateKeywordFilter("midline filter", ObjectiveTaskKeywords.Midline);
	local middleSelector:ai = objectiveDef:CreateSelector("Mid Selector");
	local checkReserveOrMidline:ai = BoolConditionHelper(objectiveDef, selectRoot, middleSelector, BOOL_OPERATOR.Or, filterReserve, filterMidline);
	
	-- Check if there is at least one unit up front.
	local middleAssignCheck:ai = objectiveDef:CreateTaskCountFilter("middle assignment check", frontTask, BOOL_COMPARISON.GreaterThan, 1);
	ai_ob_add_child(middleSelector, middleAssignCheck);
	local middleAreas:table = areaTable:GetAreasWithKeyword(AssaultPlayerObjectiveConst.middleArea);
	local middleTask:ai = objectiveDef:CreateHoldAreaOrder("Middle Task", middleAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(middleAssignCheck, middleTask);
	
	-- Move up to front row because there were 1 or fewer units in it.
	local middleMoveUpTask:ai = objectiveDef:CreateHoldAreaOrder("Middle Move Up Task", frontAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(middleSelector, middleMoveUpTask);
	
-- Back Row
	-- Filter branch by command squad types.
	local filterCommand:ai = objectiveDef:CreateKeywordFilter("command filter", ObjectiveTaskKeywords.Command);
	ai_ob_add_child(selectRoot, filterCommand);
	local backSelector:ai = objectiveDef:CreateSelector("Back Selector");
	ai_ob_add_child(filterCommand, backSelector);
	
	-- Check whether there are any units in the middle row.
	local backMidAssignCheck:ai = objectiveDef:CreateTaskCountFilter("back middle assignment check", middleTask, BOOL_COMPARISON.GreaterThan, 0);
	ai_ob_add_child(backSelector, backMidAssignCheck);
	local backAreas:table = areaTable:GetAreasWithKeyword(AssaultPlayerObjectiveConst.backArea);
	local backTask:ai = objectiveDef:CreateHoldAreaOrder("Back Task", backAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(backMidAssignCheck, backTask);
	
	local backFrontAssignCheck:ai = objectiveDef:CreateTaskCountFilter("back front assignment check", middleMoveUpTask, BOOL_COMPARISON.GreaterThan, 1);
	ai_ob_add_child(backSelector, backFrontAssignCheck);
	local backMidTask:ai = objectiveDef:CreateHoldAreaOrder("Back Mid Task", middleAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(backFrontAssignCheck, backMidTask);
	
	local backFrontTask:ai = objectiveDef:CreateHoldAreaOrder("Back Front Task", frontAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(backSelector, backFrontTask);
	
-- Catch all
	local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", backAreas[1], k_OrderDurationInfinite);
	areaTable:AddAreasToTask(defaultTask, AssaultPlayerObjectiveConst.backArea);
	ai_ob_add_child(selectRoot, defaultTask);

-- SCRIPT DEFINITION DATA
	local data:table = setmetatable({}, {__index = AssaultPlayerObjective});
	data.playerPosNode = nearPlayerPos;
	data.pathCastNode = pathCastNode;
	data.instanceParams = nil;
	if (nil ~= instanceParamFunc) then
		data.instanceParams = instanceParamFunc();
	end
	
	objectiveDef:SetScriptDef(data);
	objectiveDef:Finalize();
	
	return objectiveDef;
end

function AssaultPlayerObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:AssaultPlayerObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData:table = setmetatable({}, {__index = AssaultPlayerInstance});
	instData.m_scriptDef = self;
	instData.m_objectiveInst = objectiveInstance;
	instData.m_frontCenterPos = placePos;
	instData.m_defaultFacing = placeFacing;
	
	local setParams:AssaultPlayerObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.instanceParams);
		setParams = self.instanceParams;
	end
	
	instData.m_backRowOffset = setParams.m_backRowOffset;
	instData.m_middleRowOffset = setParams.m_middleRowOffset;
	instData.m_frontRowOffset = setParams.m_frontRowOffset;
	instData.m_backRowLength = setParams.m_backRowLength;
	instData.m_backRowRadius = setParams.m_backRowRadius;
	instData.m_middleRowLength = setParams.m_middleRowLength;
	instData.m_middleRowRadius = setParams.m_middleRowRadius;
	instData.m_frontRowLength = setParams.m_frontRowLength;
	instData.m_frontRowRadius = setParams.m_frontRowRadius;
	instData.m_visibilityRadius = setParams.m_visibilityRadius;
	
	instData:UpdateState();
	
	return instData;
end

-- Recalculates data for seeding area generation based on player position.
function AssaultPlayerInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local encData:table = self.m_scriptDef;
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	
	-- Update squad for nearest player visibility evaluation.
	local rootObjSquad:ai = self.m_objectiveInst:GetRootSquad();
	if (nil ~= rootObjSquad) then
		boardInst:UpdateEntry(AssaultPlayerObjectiveConst.squadIndex, rootObjSquad);
	end
	
	local frontCenterOffset:number = self.m_frontRowOffset;
	local middleCenterOffset:number = frontCenterOffset + self.m_middleRowOffset;
	local backCenterOffset:number = middleCenterOffset + self.m_backRowOffset;
	
	-- Get the position of the nearest visible player.
	local targetPos:vector = self.m_objectiveInst:EvaluateNodeVector(encData.playerPosNode.PlayerPositionOut);
	
	local avgUnitPos:vector;
	if (ai_living_count(self.m_objectiveInst:GetRootSquad()) > 0) then
		avgUnitPos = AI_GetObjectiveMeanPosition(self.m_objectiveInst.m_instanceIndex);
	else
		avgUnitPos = self.m_frontCenterPos;
	end
	
	-- Generate objective facing vector based on the target and defense positions.
	local facing:vector = targetPos - avgUnitPos;
	facing.z = 0.0;
	local faceAngle:number = 0;
	
	local playerDistFromPt:number = facing.length;
	local targetDistFromOrigin = (targetPos - vector(0,0,0)).length;
	if (nil == Player_GetUnit(PLAYERS.player0) or playerDistFromPt < 0.01 or targetDistFromOrigin < 0.01) then
		faceAngle = self.m_defaultFacing;
		facing = vector(math.cos(self.m_defaultFacing), math.sin(self.m_defaultFacing), 0);
		targetPos = self.m_frontCenterPos + (facing * frontCenterOffset);
	else
		facing = facing * (1.0 / playerDistFromPt);
		
		-- Get facing angle
		if (facing.y >= 0.0) then
			faceAngle = math.acos(facing.x);
		else
			faceAngle = (2.0 * math.pi) - math.acos(facing.x);
		end
		
		-- Update stored data.
		self.m_frontCenterPos = targetPos - (facing * frontCenterOffset);
		self.m_defaultFacing = faceAngle;
	end
	
	local tangentAngle:number = faceAngle + (math.pi * 0.5)
	local tangent:vector = vector(math.cos(tangentAngle), math.sin(tangentAngle), 0);
	
	local middleCenterPos:vector = targetPos - (facing * middleCenterOffset);
	
	-- Fix up middle center by path cast.
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastStart, targetPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, middleCenterPos);
	middleCenterPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local backCenterPos:vector = targetPos - (facing * backCenterOffset);
	
	local backHalfLength:number = self.m_backRowLength * 0.5;
	local backStartPos:vector = backCenterPos - (tangent * backHalfLength);
	local backEndPos:vector = backCenterPos + (tangent * backHalfLength);
	
	-- path to back tangent fixup.
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastStart, backCenterPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, backStartPos);
	backStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, backEndPos);
	backEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local backCircleRadius:number = self.m_backRowRadius + backHalfLength;
	
	local middleHalfLength:number = self.m_middleRowLength * 0.5;
	local middleStartPos:vector = middleCenterPos - (tangent * middleHalfLength);
	local middleEndPos:vector = middleCenterPos + (tangent * middleHalfLength);
	
	-- Path to middle tangent fixup.
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastStart, middleCenterPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, middleStartPos);
	middleStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, middleEndPos);
	middleEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local frontCenterPos:vector = targetPos - (facing * frontCenterOffset);
	
	-- Fix up front center by path cast.
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastStart, targetPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, frontCenterPos);
	frontCenterPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local frontHalfLength:number = self.m_frontRowLength * 0.5;
	local frontStartPos:vector = frontCenterPos - (tangent * frontHalfLength);
	local frontEndPos:vector = frontCenterPos + (tangent * frontHalfLength);
	
	-- Path to front tangent fixup.
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastStart, frontCenterPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, frontStartPos);
	frontStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.pathCastEnd, frontEndPos);
	frontEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);

-- UPDATE BLACKBOARD INSTANCE
	
	-- Back Row
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.backStartPos, backStartPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.backEndPos, backEndPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.backRadius, self.m_backRowRadius);
	
	-- Middle Row
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.middleCenterPos, middleCenterPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.middleStartPos, middleStartPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.middleEndPos, middleEndPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.middleRadius, self.m_middleRowRadius);
	
	-- Front Row
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.frontStartPos, frontStartPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.frontEndPos, frontEndPos);
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.frontRadius, self.m_frontRowRadius);
	
	boardInst:UpdateEntry(AssaultPlayerObjectiveConst.visibilityRadius, self.m_visibilityRadius);
end
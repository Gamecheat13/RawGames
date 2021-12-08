-- Copyright (c) Microsoft Corporation.  All rights reserved.
-- Author: v-whdani
--## SERVER

-- Three rows are created (front, middle, and back) relative to a point the AI will defend. The back row also includes
-- an arc shaped area around the defend point. The rows will orient toward the last visible player position. When the
-- player is out of range from the front row, it will expand farther out. If the player pushes inside the defend areas
-- the offsets will contract, attempting to stay between the player and defend point.


global PointDefendObjective:table = table.makePermanent
{
	playerPosNode = nil,
	pathCastNode = nil,
	instanceParams = nil,
}

global PointDefendInstance:table = table.makePermanent
{
	m_pointDefendData = nil,
	m_objectiveInst = nil,
	m_defendPos = vector(0,0,0),
	m_defaultFacing = 0,
	m_backRowOffset = 1,
	m_middleRowOffset = 1,
	m_frontRowOffset = 1,
	m_backCircleHalfAngle = 45,
	m_backRowLength = 5,
	m_backRowRadius = 2,
	m_middleRowLength = 4,
	m_middleRowRadius = 2,
	m_frontRowLength = 3,
	m_frontRowRadius = 2,
}

global PointDefendObjectiveConst:table = table.makePermanent
{
	frontArea = "frontArea",
	middleArea = "middleArea",
	backArea = "backArea",
	
	pathCastStart = "pathCastStart",
	pathCastEnd = "pathCastEnd",
	
	frontStartPos = "frontStartPos",
	frontEndPos = "frontEndPos",
	frontRadius = "frontRadius",
	
	middleStartPos = "middleStartPos",
	middleEndPos   = "middleEndPos",
	middleRadius   = "middleRadius",
	
	backCirclePos = "backCirclePos",
	backCircleRadius = "backCircleRadius",
	
	backRightCircleSliceStart = "backRightCircleSliceStart",
	backRightCircleSliceEnd = "backRightCircleSliceEnd",
	backLeftCircleSliceStart = "backLeftCircleSliceStart",
	backLeftCircleSliceEnd = "backLeftCircleSliceEnd",
	
	backStartPos = "backStartPos",
	backEndPos   = "backEndPos",
	backRadius   = "backRadius",
	
	squadIndex = "squadIndex",
};

hstructure PointDefendObjectiveParam
	m_backRowOffset			:number;
	m_middleRowOffset		:number;
	m_frontRowOffset		:number;
	m_backCircleHalfAngle	:number;	-- how much the area angles back. 180 = complete circle
	m_backRowLength			:number;
	m_backRowRadius			:number;
	m_middleRowLength		:number;
	m_middleRowRadius		:number;
	m_frontRowLength		:number;
	m_frontRowRadius		:number;
end

function PointDefendObjectiveParam_GetSmall():PointDefendObjectiveParam
	local paramObj:PointDefendObjectiveParam = hmake PointDefendObjectiveParam
	{
		m_backRowOffset = 0,
		m_middleRowOffset = 1,
		m_frontRowOffset = 1,
		m_backCircleHalfAngle = 90,
		m_backRowLength = 6,
		m_backRowRadius = 1,
		m_middleRowLength = 5,
		m_middleRowRadius = 1,
		m_frontRowLength = 4,
		m_frontRowRadius = 1,
	}
	return paramObj;
end

function PointDefendObjectiveParam_GetLarge():PointDefendObjectiveParam
	local paramObj:PointDefendObjectiveParam = hmake PointDefendObjectiveParam
	{
		m_backRowOffset = 0,
		m_middleRowOffset = 0.1,
		m_frontRowOffset = 0.1,
		m_backCircleHalfAngle = 90,
		m_backRowLength = 12,
		m_backRowRadius = 3,
		m_middleRowLength = 10,
		m_middleRowRadius = 3,
		m_frontRowLength = 8,
		m_frontRowRadius = 3,
	}
	return paramObj;
end


function NavmeshFloodfillHelper(nodeGraph:table, bbDef:table, bbStartName, bbEndName, bbfloodRadiusName):table
	local floodFill:table = nodeGraph:CreateFloodFill();
	bbDef:CreateNodeInputLink(bbStartName, floodFill.StartPosition);
	bbDef:CreateNodeInputLink(bbEndName, floodFill.EndPosition);
	bbDef:CreateNodeInputLink(bbfloodRadiusName, floodFill.Radius);
	return floodFill;
end

-- Function for creating the scripted encounter definition.
function PointDefendObjective:Create(instanceParamFunc:ifunction):table
	-- Create wrapper for code side encounter definition.
	local objectiveDef:table = AIObjectiveDefinition.New("PointDefendObjective");
	local graph:table = objectiveDef:GetGraphContainer();

	-- Make a blackboard for the encounter.
	local boardDef:table = AIBlackBoardDefinition.New();
	boardDef:AddEntry(PointDefendObjectiveConst.pathCastStart, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.pathCastEnd, BLACKBOARD_ENTRY_TYPE.Vector);
	
	boardDef:AddEntry(PointDefendObjectiveConst.frontStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.frontEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.frontRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(PointDefendObjectiveConst.middleStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.middleEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.middleRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(PointDefendObjectiveConst.backCirclePos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backCircleRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(PointDefendObjectiveConst.backRightCircleSliceStart, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backRightCircleSliceEnd, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backLeftCircleSliceStart, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backLeftCircleSliceEnd, BLACKBOARD_ENTRY_TYPE.Vector);
	
	boardDef:AddEntry(PointDefendObjectiveConst.backStartPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backEndPos, BLACKBOARD_ENTRY_TYPE.Vector);
	boardDef:AddEntry(PointDefendObjectiveConst.backRadius, BLACKBOARD_ENTRY_TYPE.Float);
	
	boardDef:AddEntry(PointDefendObjectiveConst.squadIndex, BLACKBOARD_ENTRY_TYPE.AiIndex);
	
	boardDef:Finalize();
	objectiveDef:SetBlackBoard(boardDef);

-- AREA GENERATION
	local areaTable:table = AIAreaTable:New();
	
	-- Path cast node.
	local pathCastNode:table = graph:CreateNearestPositionPathCast();
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.pathCastStart, pathCastNode.StartPosition);
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.pathCastEnd, pathCastNode.GoalPosition);
	
	local frontFlood:table = NavmeshFloodfillHelper(graph, boardDef, PointDefendObjectiveConst.frontStartPos, PointDefendObjectiveConst.frontEndPos, PointDefendObjectiveConst.frontRadius);
	areaTable:AddArea(frontFlood.AreasOut, {PointDefendObjectiveConst.frontArea});
	
	local middleFlood:table = NavmeshFloodfillHelper(graph, boardDef, PointDefendObjectiveConst.middleStartPos, PointDefendObjectiveConst.middleEndPos, PointDefendObjectiveConst.middleRadius);
	areaTable:AddArea(middleFlood.AreasOut, {PointDefendObjectiveConst.middleArea});
	
	local backFlood:table = NavmeshFloodfillHelper(graph, boardDef, PointDefendObjectiveConst.backStartPos, PointDefendObjectiveConst.backEndPos, PointDefendObjectiveConst.backRadius);
	areaTable:AddArea(backFlood.AreasOut, {PointDefendObjectiveConst.backArea});
	
	local backCircleFlood:table = NavmeshFloodfillHelper(graph, boardDef, PointDefendObjectiveConst.backCirclePos, PointDefendObjectiveConst.backCirclePos, PointDefendObjectiveConst.backCircleRadius);
	
	local cutGap:table = graph:CreateConstantFloat(0.0);
	local cutSegFraction:table = graph:CreateConstantFloat(0.5);
	
	local rightCut:table = graph:CreateCrosscut();
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.backRightCircleSliceStart, rightCut.SegmentStart);
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.backRightCircleSliceEnd, rightCut.SegmentEnd);
	NG.CreateLink(cutGap.Out, rightCut.Gap);
	NG.CreateLink(cutSegFraction.Out, rightCut.Fraction);
	NG.CreateLink(backCircleFlood.AreasOut, rightCut.Areas);
	
	local leftCut:table = graph:CreateCrosscut();
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.backLeftCircleSliceStart, leftCut.SegmentStart);
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.backLeftCircleSliceEnd, leftCut.SegmentEnd);
	NG.CreateLink(cutGap.Out, leftCut.Gap);
	NG.CreateLink(cutSegFraction.Out, leftCut.Fraction);
	NG.CreateLink(backCircleFlood.AreasOut, leftCut.Areas);
	
	areaTable:AddArea(rightCut.NearAreasOut, {PointDefendObjectiveConst.backArea});
	areaTable:AddArea(leftCut.NearAreasOut, {PointDefendObjectiveConst.backArea});
	
	local nearPlayerPos:table = graph:CreateNearestVisiblePlayer(1.0);
	local nearSearchRadius:table = graph:CreateConstantFloat(30.0);
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.backCirclePos, nearPlayerPos.Position);
	NG.CreateLink(nearSearchRadius.Out, nearPlayerPos.Radius);
	boardDef:CreateNodeInputLink(PointDefendObjectiveConst.squadIndex, nearPlayerPos.VisSquad);

-- DEPLOYMENT
	local deploymentInfo:table = AIDeploymentInfo.New();
	deploymentInfo:SetDeploymentMode(SG.DeploymentMode.Standard);
	deploymentInfo:AddSpawnAreas(areaTable, PointDefendObjectiveConst.backArea, ObjectiveSpawnKeywords.Default);
	objectiveDef:SetDeployData(deploymentInfo);

-- BEHAVIOR
	local selectRoot:ai = objectiveDef:CreateSelector("Root Selector");
	objectiveDef:SetStartNode(selectRoot);

	-- Create a task for guarding the outer areas.
	local filterFront:ai = objectiveDef:CreateKeywordFilter("front filter", ObjectiveTaskKeywords.Frontline);
	ai_ob_add_child(selectRoot, filterFront);
	local frontAreas:table = areaTable:GetAreasWithKeyword(PointDefendObjectiveConst.frontArea);
	local frontTask:ai = objectiveDef:CreateHoldAreaOrder("Front Task", frontAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(filterFront, frontTask);
	
	local checkReserveOrMidline:ai = objectiveDef:CreateBoolCondition("Reserve or Midline", BOOL_OPERATOR.Or);
	ai_ob_add_child(selectRoot, checkReserveOrMidline);
	local filterReserve:ai = objectiveDef:CreateKeywordFilter("reserve filter", ObjectiveTaskKeywords.Reserve);
	local filterMidline:ai = objectiveDef:CreateKeywordFilter("midline filter", ObjectiveTaskKeywords.Midline);
	ai_ob_add_child(checkReserveOrMidline, filterReserve);
	ai_ob_add_child(checkReserveOrMidline, filterMidline);
	local middleAreas:table = areaTable:GetAreasWithKeyword(PointDefendObjectiveConst.middleArea);
	local middleTask:ai = objectiveDef:CreateHoldAreaOrder("Middle Task", middleAreas[1], k_OrderDurationInfinite);
	AI_SetBoolConditionActionNode(checkReserveOrMidline, middleTask);
	
	local filterCommand:ai = objectiveDef:CreateKeywordFilter("command filter", ObjectiveTaskKeywords.Command);
	ai_ob_add_child(selectRoot, filterCommand);
	local backAreas:table = areaTable:GetAreasWithKeyword(PointDefendObjectiveConst.backArea);
	local backTask:ai = objectiveDef:CreateHoldAreaOrder("Back Task", backAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(filterCommand, backTask);
	
	local defaultTask:ai = objectiveDef:CreateHoldAreaOrder("Default Task", backAreas[1], k_OrderDurationInfinite);
	ai_ob_add_child(selectRoot, defaultTask);

-- ENCOUNTER DATA
	local data = setmetatable({}, {__index = PointDefendObjective});
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

function PointDefendObjective:CreateScriptInstance(objectiveInstance:table, placePos:vector, placeFacing:number, initParams:PointDefendObjectiveParam):table
	assert(nil ~= objectiveInstance);
	
	local instData = setmetatable({}, {__index = PointDefendInstance});
	instData.m_pointDefendData = self;
	instData.m_objectiveInst = objectiveInstance;
	instData.m_defendPos = placePos;
	instData.m_defaultFacing = placeFacing;
	
	local setParams:PointDefendObjectiveParam = nil;
	if (nil ~= initParams) then
		setParams = initParams;
	else
		assert(nil ~= self.instanceParams);
		setParams = self.instanceParams;
	end
	
	instData.m_backRowOffset = setParams.m_backRowOffset;
	instData.m_middleRowOffset = setParams.m_middleRowOffset;
	instData.m_frontRowOffset = setParams.m_frontRowOffset;
	instData.m_backCircleHalfAngle = setParams.m_backCircleHalfAngle;
	instData.m_backRowLength = setParams.m_backRowLength;
	instData.m_backRowRadius = setParams.m_backRowRadius;
	instData.m_middleRowLength = setParams.m_middleRowLength;
	instData.m_middleRowRadius = setParams.m_middleRowRadius;
	instData.m_frontRowLength = setParams.m_frontRowLength;
	instData.m_frontRowRadius = setParams.m_frontRowRadius;
	
	instData:UpdateState();
	
	return instData;
end

-- Recalculates data for seeding area generation based on player position.
function PointDefendInstance:UpdateState():void
	assert(nil ~= self.m_objectiveInst);
	
	local encData:table = self.m_pointDefendData;
	local boardInst:table = self.m_objectiveInst:GetBlackBoardInstance();
	
	-- Update squad for nearest player visibility evaluation.
	boardInst:UpdateEntry(PointDefendObjectiveConst.squadIndex, self.m_objectiveInst:GetRootSquad());
	
	-- Get the position of the nearest visible player.
	local targetPos:vector = self.m_objectiveInst:EvaluateNodeVector(encData.playerPosNode.PlayerPositionOut);
	
	-- Generate encounter facing vector based on the target and defense positions.
	local facing:vector = targetPos - self.m_defendPos;
	facing.z = 0.0;
	local faceAngle:number = 0;
	
	local playerDistFromPt:number = facing.length;
	local targetDistFromOrigin = (targetPos - vector(0,0,0)).length;
	if (nil == Player_GetUnit(PLAYERS.player0) or playerDistFromPt < 0.01 or targetDistFromOrigin < 0.01) then
		faceAngle = self.m_defaultFacing;
		facing = vector(math.cos(self.m_defaultFacing), math.sin(self.m_defaultFacing), 0);
	else
		facing = facing * (1.0 / playerDistFromPt);
		
		-- Get facing angle
		if (facing.y >= 0.0) then
			faceAngle = math.acos(facing.x);
		else
			faceAngle = (2.0 * math.pi) - math.acos(facing.x);
		end
	end
	
	local tangentAngle:number = faceAngle + (math.pi * 0.5)
	local tangent:vector = vector(math.cos(tangentAngle), math.sin(tangentAngle), 0);
	
	local backCenterOffset = self.m_backRowOffset + self.m_backRowRadius;
	local middleCenterOffset = backCenterOffset + self.m_backRowRadius + self.m_middleRowOffset + self.m_middleRowRadius;
	local frontCenterOffset = middleCenterOffset + self.m_middleRowRadius + self.m_frontRowOffset + self.m_frontRowRadius;
	local extendMaxSize:number = 3;
	local totalRowLength = frontCenterOffset + self.m_frontRowRadius;
	local totalEncounterLength = totalRowLength + extendMaxSize;
	
	local shrinkScalar = 1.0;
	if (nil ~= Player_GetUnit(PLAYERS.player0) and playerDistFromPt < totalEncounterLength) then
		shrinkScalar = math.max(playerDistFromPt / totalEncounterLength, 0.3);
	end
	
	middleCenterOffset = middleCenterOffset * shrinkScalar;
	local middleCenterPos:vector = self.m_defendPos + (facing * middleCenterOffset);
	
	-- Fix up middle center by path cast.
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastStart, self.m_defendPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, middleCenterPos);
	middleCenterPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	backCenterOffset = backCenterOffset * shrinkScalar;
	local backCenterPos:vector = self.m_defendPos + (facing * backCenterOffset);
	
	local backHalfLength:number = self.m_backRowLength * 0.5;
	local backStartPos:vector = backCenterPos - (tangent * backHalfLength);
	local backEndPos:vector = backCenterPos + (tangent * backHalfLength);
	
	-- path to back tangent fixup.
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastStart, backCenterPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, backStartPos);
	backStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, backEndPos);
	backEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local backCircleRadius:number = self.m_backRowRadius + backHalfLength;
	
	local middleHalfLength:number = self.m_middleRowLength * 0.5;
	local middleStartPos:vector = middleCenterPos - (tangent * middleHalfLength);
	local middleEndPos:vector = middleCenterPos + (tangent * middleHalfLength);
	
	-- Path to middle tangent fixup.
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastStart, middleCenterPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, middleStartPos);
	middleStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, middleEndPos);
	middleEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	frontCenterOffset = frontCenterOffset * shrinkScalar;
	local frontCenterPos:vector = self.m_defendPos + (facing * frontCenterOffset);
	
	-- Extend front row based on player distance from the defend point.
	local extendStart:number = 4;
	local frontRadius:number = self.m_frontRowRadius;
	local extendSpace:number = playerDistFromPt - totalRowLength;
	if (extendSpace > extendStart) then
		extendSpace = extendSpace - extendStart;
		if (extendSpace > extendMaxSize) then
			extendSpace = extendMaxSize;
		end
		extendSpace = extendSpace * 0.5;
		frontRadius = frontRadius + extendSpace;
		frontCenterPos = frontCenterPos + (facing * extendSpace);
	end
	
	-- Fix up front center by path cast.
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastStart, self.m_defendPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, frontCenterPos);
	frontCenterPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	local frontHalfLength:number = self.m_frontRowLength * 0.5;
	local frontStartPos:vector = frontCenterPos - (tangent * frontHalfLength);
	local frontEndPos:vector = frontCenterPos + (tangent * frontHalfLength);
	
	-- Path to front tangent fixup.
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastStart, frontCenterPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, frontStartPos);
	frontStartPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	boardInst:UpdateEntry(PointDefendObjectiveConst.pathCastEnd, frontEndPos);
	frontEndPos = self.m_objectiveInst:EvaluateNodeVector(encData.pathCastNode.NearestPosition);
	
	-- Calculate slices for the back row circle.
	local backCirclePos:vector = self.m_defendPos + (facing * self.m_backRowOffset);
	
	local rightSliceAngle:number = faceAngle - math.rad(180 - self.m_backCircleHalfAngle);
	local rightSliceFacing:vector = vector(math.cos(rightSliceAngle), math.sin(rightSliceAngle), 0);
	local rightSliceStart:vector = backCirclePos - rightSliceFacing;
	local rightSliceEnd:vector = backCirclePos + rightSliceFacing;
	
	local leftSliceAngle:number = faceAngle + math.rad(180 - self.m_backCircleHalfAngle);
	local leftSliceFacing:vector = vector(math.cos(leftSliceAngle), math.sin(leftSliceAngle), 0);
	local leftSliceStart:vector = backCirclePos - leftSliceFacing;
	local leftSliceEnd:vector = backCirclePos + leftSliceFacing;

-- UPDATE BLACKBOARD INSTANCE
	-- Back Circle
	boardInst:UpdateEntry(PointDefendObjectiveConst.backCirclePos, backCirclePos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backCircleRadius, backCircleRadius);
	
	boardInst:UpdateEntry(PointDefendObjectiveConst.backRightCircleSliceStart, rightSliceStart);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backRightCircleSliceEnd, rightSliceEnd);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backLeftCircleSliceStart, leftSliceStart);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backLeftCircleSliceEnd, leftSliceEnd);
	
	-- Back Row
	boardInst:UpdateEntry(PointDefendObjectiveConst.backStartPos, backStartPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backEndPos, backEndPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.backRadius, self.m_backRowRadius);
	
	-- Middle Row
	boardInst:UpdateEntry(PointDefendObjectiveConst.middleStartPos, middleStartPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.middleEndPos, middleEndPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.middleRadius, self.m_middleRowRadius);
	
	-- Front Row
	boardInst:UpdateEntry(PointDefendObjectiveConst.frontStartPos, frontStartPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.frontEndPos, frontEndPos);
	boardInst:UpdateEntry(PointDefendObjectiveConst.frontRadius, frontRadius);
end
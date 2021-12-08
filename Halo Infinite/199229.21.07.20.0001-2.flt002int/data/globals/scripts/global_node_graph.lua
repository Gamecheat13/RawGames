-- Copyright (c) Microsoft Corporation.  All rights reserved.

-------------------------------------------

global NodePin = {
	__index = function (t, key)
	return {NodeID = t.NodeID, PinID = t.Pins[key]};
end
}

function CreateNodeObject(nodeID, pins)
	local self = setmetatable({}, NodePin);
	self.NodeID = nodeID;
	self.Pins = pins;
	return self;
end

global NG = table.makePermanent {};

NG.ArithmeticOperator = table.makeEnum {ADD = 0, SUB = 1, MULT = 2, DIV = 3};
NG.BoolOp = table.makeEnum {AND = 0, OR = 1, NAND = 2, NOR = 3, XOR = 4};
NG.NumCond = table.makeEnum {LessThan = 0, LessThanEq = 1, GreaterThan = 2, GreaterThanEq = 3, Equal = 4, NotEqual = 5};
NG.GlobalState = table.makeEnum {Difficulty = 0, PlayerCount = 1, GameTime = 2};

function NG.CreateNodePin(nodeID, pin)
	return {NodeID = nodeID, PinID = pin};
end

function NG.CreateConstantFloat(containerIndex, value)
	local makeNode:table = CreateNodeObject(
		ng_create_constant_float(value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateConstantInt(containerIndex, value)
	local makeNode:table = CreateNodeObject(
		ng_create_constant_integer(value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateConstantString(containerIndex, value)
	local makeNode:table = CreateNodeObject(
		NG_CreateConstantString(value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreatePinValid()
	return CreateNodeObject(
		ng_pin_valid(),
		{In=0, Out=0});
end

function NG.CreateGlobalState(containerIndex, stateValue)
	local makeNode:table = CreateNodeObject(
		ng_global_state(stateValue),
		{ValueFloatOut=0, ValueIntegerOut=1});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateBooleanLogic(containerIndex, operator)
	local makeNode:table = CreateNodeObject(
		ng_boolean_logic(operator),
		{MultiIn=0, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateBooleanInvert(containerIndex)
	local makeNode:table = CreateNodeObject(
		ng_boolean_invert(),
		{In=0, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateEditableBool(containerIndex, name, value)
	local makeNode:table = CreateNodeObject(
		NG_CreateEditableBool(name, value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateEditableInt(containerIndex, name, value)
	local makeNode:table = CreateNodeObject(
		NG_CreateEditableInt(name, value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateEditableFloat(name, value, minVal, maxVal)
	if minVal == nil or maxVal == nil then
		minVal = 0;
		maxVal = 0;
end

return CreateNodeObject(
	NG_CreateEditableFloat(name, value, minVal, maxVal),
	{Out=0});
end

function NG.CreateEditableVector(containerIndex, name, value)
	local makeNode:table = CreateNodeObject(
		NG_CreateEditableVector(name, value),
		{Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateNumericalLogic(containerIndex, condition)
	local makeNode:table = CreateNodeObject(
		ng_numerical_logic(condition),
		{Left=0, Right=1, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateNumericalArithmetic(containerIndex, operator)
	local makeNode:table = CreateNodeObject(
		ng_numerical_arithmetic(operator),
		{Left=0, Right=1, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateSwitchOnInteger(containerIndex)
	local makeNode:table = CreateNodeObject(
		ng_switch_on_integer(),
		{Selection=0, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.AddSwitchOnIntegerOption(switch, value, target)
	ng_add_switch_on_int_option(switch.NodeID, value, target.NodeID, target.PinID);
end

function NG.CreateSwitchOnString(containerIndex)
	local makeNode:table = CreateNodeObject(
		NG_SwitchOnString(),
		{Selection=0, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.AddSwitchOnStringOption(switch, value, target)
	NG_AddSwitchOnStringOption(switch.NodeID, value, target.NodeID, target.PinID);
end
function NG.CreateStringEquals(containerIndex)
	local makeNode:table = CreateNodeObject(
		NG_CreateStringEquals(),
		{A=0, B=1, Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

function NG.CreateLink(source, target)
	return ng_create_link(source.NodeID, source.PinID, target.NodeID, target.PinID);
end

function NG.ApplyLabel(nodePin, name)
	local labelID = ng_label(name);
	ng_create_link(nodePin.NodeID, nodePin.PinID, labelID, 0);
end

function NG.Destroy(nodePin)
	ng_destroy(nodePin.NodeID);
end
--------------------------------------------------------------------------------------------------------------------------------------
-- WARNING: Due to the game only support the float during the lua parsing, the maximum interger only support up to 2^24 = 16777215 !!!
--------------------------------------------------------------------------------------------------------------------------------------
-- \Corinth\Shiva\Main\shared\libraries\HavokScript\343\source\virtualMachine\vm-types.h
-- typedef float				HksNumber;
-- typedef hksUint32			HksNativeValueAsInt;
-- #define HKS_FLOATSTRING	"%f"
-- #define HKS_NUMBER_FORMAT	"%0.8g"
--------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------
-- Note: This node has 3 input pins and 3 output pins. Each represent one input/output data type. 
-- However, only one input and one output pin is valid at any given time. 
-- It always take the latest setting.
--[[
	local baseBlend = AnimGraph.CreateBlend();
	local nodeConvertor = NG.CreateNumericValueConvertor();
	local boolInput = NG.CreateEditableBool("test bool", true);

	NG.CreateLink(boolInput.Out, nodeConvertor.In_Bool);
	NG.CreateLink(nodeConvertor.Out_Float, baseBlend.Alpha);
]]-- 
--------------------------------------------------------------------------------------------------------------------------------------
function NG.CreateNumericValueConvertor(containerIndex)
	local makeNode:table = CreateNodeObject(
		NG_NumericValueConvertor(),
		{In_Int = 0, In_Float = 1, In_Bool = 2, Out_Int = 0, Out_Float = 1, Out_Bool = 2});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end


----------------------------FloatArithmeticNode----------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 5 input pins and 1 output pins.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- FLOAT_ARITHMETIC_OPERATION.Modulo,
-- FLOAT_ARITHMETIC_OPERATION.Absolute,
-- FLOAT_ARITHMETIC_OPERATION.Clamp,
-- FLOAT_ARITHMETIC_OPERATION.ClampAngle,
-- FLOAT_ARITHMETIC_OPERATION.Hypotenuse,
-- FLOAT_ARITHMETIC_OPERATION.Floor,
-- FLOAT_ARITHMETIC_OPERATION.InRange,
-- FLOAT_ARITHMETIC_OPERATION.Lerp,
-- FLOAT_ARITHMETIC_OPERATION.Log,
-- FLOAT_ARITHMETIC_OPERATION.MappedRangeClamped,
-- FLOAT_ARITHMETIC_OPERATION.MappedRangeUnclamped,
-- FLOAT_ARITHMETIC_OPERATION.Max,
-- FLOAT_ARITHMETIC_OPERATION.Min,
-- FLOAT_ARITHMETIC_OPERATION.MultiplyByPI,
-- FLOAT_ARITHMETIC_OPERATION.NearlyEqual,
-- FLOAT_ARITHMETIC_OPERATION.NormalizeToRange,
-- FLOAT_ARITHMETIC_OPERATION.Power,	
-- FLOAT_ARITHMETIC_OPERATION.Round,
-- FLOAT_ARITHMETIC_OPERATION.SnapToGrid,
-- FLOAT_ARITHMETIC_OPERATION.Sqrt,
-- FLOAT_ARITHMETIC_OPERATION.Square,

--[[ HOW TO USE:
	local fNode = NG.CreateFloatArithmetic(FLOAT_ARITHMETIC_OPERATION.ClampAngle);
	local A = NG.CreateEditableFloat("FloatA", 0.0, -720.0, 720.0);
	local Min = NG.CreateEditableFloat("Min", -180.0, -180.0, 0.0);
	local Max = NG.CreateEditableFloat("Max", 179.0, 0.0, 179.0);
	
	NG.CreateLink(A.Out, fNode.A);
	NG.CreateLink(Min.Out, fNode.Min);
	NG.CreateLink(Max.Out, fNode.Max);
]]-- 
--------------------------------------------------------------------------------------------------------------------------------------
function NG.CreateFloatArithmetic(containerIndex, operator)
	local makeNode:table = CreateNodeObject(
		NG_FloatArithmetic(operator),
		{	A=0, B=1,				-- A=0, B=1, Modulo(A, B)
									-- A=0, Absolute :Abs(A)
			Min=1, Max=2,			-- A=0, Min=1, Max=2, Clamp(A, Min, Max)
									-- A=0, Min=1, Max=2, ClampAngle(A, Min, Max): Clamp the Angle A to Min, Max. return value is also clamped to -180 ~ 180.
			Width=0, Height=1,  	-- Width=0, Height=1, Hypotenuse(Width, Height)
									-- A=0, Floor(A): return integer
									-- A=0, Min=1, Max=2, InRange(A, Min, Max) : return bool.
			Alpha=2,				-- A=0, B=1, alpha=2, Lerp(A, B, alpha)
			LogBase=1,				-- A=0, LogBase = 1, Log(A, LogBase):
			InRangeStart=1, InRangeEnd=2, OutRangeStart=3, OutRangeEnd=4,	-- A=0,inRangeStart=1,inRangeEnd=2,outRangeStart=3,outRangeEnd=4, MappedRangeClamped(A, inRangeStart, inRangeEnd, outRangeStart, outRangeEnd)
																			-- A=0,inRangeStart=1,inRangeEnd=2,outRangeStart=3,outRangeEnd=4, MappedRangeUnclamped(A, inRangeStart, inRangeEnd, outRangeStart, outRangeEnd)
									-- A=0, B=1, Max(A,B)
									-- A=0, B=1, Min(A,B)
									-- A=0, MultiplyByPI(A)
			Tolerance=2,			-- A=0, B=1, Tolerance=2, NearlyEqual(A, B, Tolerance): return bool. 
									-- A=0, Min=1, Max=2 NormalizeToRange(A, Min, Max)
			PowBase=0, PowExp=1,	-- PowBase=0, PowExp=1, Power(PowBase, PowExp)
									-- A=0, Round(A):return integer.
			GridSize=1,				-- A=0, GridSize=1, SnapToGrid(A, GridSize)
									-- A=0, Sqrt(A)
									-- A=0, Square(A)
			Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end



----------------------------InterpolationNode float data type----------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 5 input pins and 2 output pins.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- INTERPOLATION_OPERATION.LinearConstantVelocity
-- INTERPOLATION_OPERATION.LinearAcceleration
-- INTERPOLATION_OPERATION.DampedSpring
-- INTERPOLATION_OPERATION.Fractional
function NG.CreateInterpolationFloatNode(containerIndex, operator):table
	local makeNode:table = CreateNodeObject(
		NG_InterpolationNode(INTERPOLATION_DATATYPE.Float, operator),
		{	
			--Input list
			A = 0, B = 1,  	-- The current and desired value for all ops
			Time = 2, 		-- LinearConstantVelocity
			Velocity = 2, 	-- LinearAcceleration, DampedSpring
			Fraction = 2, 	-- Fractional
			Acceleration = 3, -- LinearAcceleration
			K = 3,	C = 4,	  -- DampedSpring
			--Output list
			Out0 = 0, 
			Out1 = 1		-- Out1 for LinearAcceleration and DampedSpring to output updated velocity
		});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end		

----------------------------InterpolationNode Vector3 data type----------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 5 input pins and 2 output pins.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- INTERPOLATION_OPERATION.LinearConstantVelocity
-- INTERPOLATION_OPERATION.LinearAcceleration
-- INTERPOLATION_OPERATION.DampedSpring
-- INTERPOLATION_OPERATION.Fractional
function NG.CreateInterpolationVectorNode(containerIndex, operator):table
	local makeNode:table = CreateNodeObject(
		NG_InterpolationNode(INTERPOLATION_DATATYPE.Vector3, operator),
		{	
			--Input list
			A = 0, B = 1,  	-- The current and desired value for all ops
			Time = 2, 		-- LinearConstantVelocity
			Velocity = 2, 	-- LinearAcceleration, DampedSpring
			Fraction = 2, 	-- Fractional
			Acceleration = 3, -- LinearAcceleration
			K = 3,	C = 4,	  -- DampedSpring
			--Output list
			Out0 = 0, 
			Out1 = 1		-- Out1 for LinearAcceleration and DampedSpring to output updated velocity
		});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end		


-------------------------------RandomNode-------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 3 input pins and 1 output pin.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- RANDOM_OPERATION.Bool,
-- RANDOM_OPERATION.Float,
-- RANDOM_OPERATION.FloatInRange,
-- RANDOM_OPERATION.Int,
-- RANDOM_OPERATION.IntInRange,
-- RANDOM_OPERATION.Rotator,	

--[[HOW TO USE:
	local MaxNor = NG.CreateConstantInt(16777215); 
	local MinNor = NG.CreateConstantInt(-16777215);
	local IRNode = NG.CreateRandomNode(RANDOM_OPERATION.IntInRange);
	
	NG.CreateLink(MinNor.Out, IRNode.Min);
	NG.CreateLink(MaxNor.Out, IRNode.Max);
]]-- 
function NG.CreateRandomNode(containerIndex, operator)
	local makeNode:table = CreateNodeObject(
		NG_Random(operator),
		{						-- Bool()
								-- Float()
			Min=0, Max=1,		-- Min=0, Max=1, FloatInRange(Min, Max)
								-- Int()
								-- Min=0, Max=1, IntInRange(Min, Max)
								-- Rotator()
			Out=0});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

----------------------------TrigArithmeticNode----------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 2 input pins and 1 output pins.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- TRIG_OPERATION.AcosInDegrees
-- TRIG_OPERATION.AcosInRadians
-- TRIG_OPERATION.AsinInDegrees
-- TRIG_OPERATION.AsinInRadians
-- TRIG_OPERATION.AtanInDegrees
-- TRIG_OPERATION.AtanInRadians
-- TRIG_OPERATION.Atan2InDegrees
-- TRIG_OPERATION.Atan2InRadians
-- TRIG_OPERATION.CosInDegrees
-- TRIG_OPERATION.CosInRadians
-- TRIG_OPERATION.DegreesToRadians
-- TRIG_OPERATION.GetPI
-- TRIG_OPERATION.GetTAU
-- TRIG_OPERATION.RadiansToDegrees
-- TRIG_OPERATION.SinInDegrees
-- TRIG_OPERATION.SinInRadians
-- TRIG_OPERATION.TanInDegrees
-- TRIG_OPERATION.TanInRadians
function NG.CreateTrigArithmeticNode(containerIndex, operator):table
	local makeNode:table = CreateNodeObject(
		NG_TrigArithmeticNode(operator),
		{	
			--Input list
			A = 0, B = 1,					-- Atan2InDegrees and Atan2InRadians need A and B for inputs, rest of operatoins only need A. 
			--Output list
			Out=0
		});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end		
----------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------VectorArithmeticNode----------------------------------------------------------------------------------------------------------
-- Note: This node has maximum 9 input pins and 6 output pins.
-- The input pins' number is basing on the operation and it always take the latest setting.
-- List of operation:
-- VECTOR_OPERATION.BreakVector,
-- VECTOR_OPERATION.ClampVectorSize,
-- VECTOR_OPERATION.CreateVectorFromYawPitch,
-- VECTOR_OPERATION.CrossProduct,
-- VECTOR_OPERATION.DotProduct,
-- VECTOR_OPERATION.Equal,
-- VECTOR_OPERATION.FindClosestPointOnLine,
-- VECTOR_OPERATION.FindClosestPointOnSegment,
-- VECTOR_OPERATION.FindNearestPointsOnLineSegments,
-- VECTOR_OPERATION.GetForwardVector,
-- VECTOR_OPERATION.GetMaxElement,
-- VECTOR_OPERATION.GetMinElement,
-- VECTOR_OPERATION.GetPointDistanceToLine,
-- VECTOR_OPERATION.GetPointDistanceToSegment,
-- VECTOR_OPERATION.GetReflectionVector,
-- VECTOR_OPERATION.GetRightVector,
-- VECTOR_OPERATION.GetUnitDirectionVector,
-- VECTOR_OPERATION.GetUpVector,
-- VECTOR_OPERATION.Lerp,
-- VECTOR_OPERATION.MakeVector,
-- VECTOR_OPERATION.MirrorVectorByNormal,
-- VECTOR_OPERATION.NegateVector,
-- VECTOR_OPERATION.Normalize,
-- VECTOR_OPERATION.NotEqual,
-- VECTOR_OPERATION.ProjectPointOnToPlane,
-- VECTOR_OPERATION.ProjectVectorOnToPlane,
-- VECTOR_OPERATION.ProjectVectorOnToVector,
-- VECTOR_OPERATION.RotateVector,
-- VECTOR_OPERATION.RotateVectorAroundAxis,
-- VECTOR_OPERATION.SelectVector,
-- VECTOR_OPERATION.UnrotateVector,
-- VECTOR_OPERATION.VectorMinusFloat,
-- VECTOR_OPERATION.VectorMinusInt,
-- VECTOR_OPERATION.VectorMinusVector,
-- VECTOR_OPERATION.vectorMultiplyFloat,
-- VECTOR_OPERATION.vectorMultiplyInt,
-- VECTOR_OPERATION.VectorMultiplyVector,
-- VECTOR_OPERATION.VectorDivFloat,
-- VECTOR_OPERATION.VectorDivInt,
-- VECTOR_OPERATION.VectorDivVector,
-- VECTOR_OPERATION.VectorPlusFloat,
-- VECTOR_OPERATION.VectorPlusInt,
-- VECTOR_OPERATION.VectorPlusVector,
-- VECTOR_OPERATION.VectorLength,
-- VECTOR_OPERATION.VectorLengthSquared,
-- VECTOR_OPERATION.VectorLengthXY,
--[[HOW TO USE:
	local VectorNode : table = NG.CreateVectorArithmeticNode(AnimGraph_GetNodeContainer(), VECTOR_OPERATION.ProjectVectorOnToVector);
	local InVec : table = NG.CreateEditableVector(AnimGraph_GetNodeContainer(), "InVec", vector(0.5,0.5,0.5));
	local Target : table = NG.CreateEditableVector(AnimGraph_GetNodeContainer(), "Target", vector(0.0,0.0,0.1));

	NG.CreateLink(InVec.Out, VectorNode.InVec0);
	NG.CreateLink(Target.Out, VectorNode.Target);
]]--

function NG.CreateVectorArithmeticNode(containerIndex, operator):table
	local makeNode:table = CreateNodeObject(
		NG_VectorArithmeticNode(operator),
		{	
			--Input list
			InVec0 = 0, 									-- BreakVector: Input: InVec0; Output : OutX, OutY, OutZ 
			Min = 4, Max = 5,								-- ClampVectorSize: Input: InVec0, Min, Max; Output: OutVec0
			Yaw = 4, Pitch = 5, Length = 6,					-- CreateVectorFromYawPitch: Input: Yaw, Pitch, Length; Output: OutVec0
			A = 0, B = 1,									-- CrossProduct: Input: A, B; Output: OutVec0
															-- DotProduct: Input: A, B; Output: OutFloat
			Tolerance = 4,									-- Equal: Input: A, B, Tolerance; Output: OutBool
			Point = 0, LineOrigin = 1, LineDir = 2,			-- FindClosestPointOnLine: Input: Point, LineOrigin, LineDir ; Output: OutVec0
			SegStart = 1, SegEnd = 2,						-- FindClosestPointOnSegment:  Input: Point, SegStart, SegEnd ; Output: OutVec0
			Seg1Start = 0, Seg1End = 1, Seg2Start = 2, Seg2End = 3,	-- FindNearestPointsOnLineSegments: Input: Seg1Start, Seg1End, Seg2Start, Seg2End ; Output: OutVec0, OutVec1
			InRot = 0,										-- GetForwardVector: Input: InRot; Output: OutVec0
															-- GetMaxElement: Input: A; Output: OutFloat
															-- GetMinElement: Input: A; Output: OutFloat
															-- GetPointDistanceToLine: Input: Point, LineOrigin, LineDir ; Output: OutFloat
															-- GetPointDistanceToSegment: Input: Point, SegStart, SegEnd ; Output: OutFloat
			InDir = 0, SurNormal = 1,						-- GetReflectionVector: Input :InDir, SurNormal; Output: OutVec0
															-- GetRightVector: Input: InRot; Output: OutVec0
			From = 0, To = 1,								-- GetUnitDirectionVector: Input: From, To; Output: OutVec0
															-- GetUpVector: Input: InRot; Output: OutVec0
			Alpha = 4,										-- Lerp: Input: A, B, Alpha (alpha in range of 0.f ~ 1.0); Output: OutVec0
			InX = 4, InY = 5, InZ = 6,						-- MakeVector: InX, InY, InZ ;Output: OutVec0
			InNormal = 1,									-- MirrorVectorByNormal: InDir, InNormal; Output: OutVec0
															-- NegateVector: A; Output: OutVec0
															-- Normalize: A;  Output: OutVec0
															-- NotEqual: Input: A, B, Tolerance; Output: OutBool
			PlaneBase = 1, 	PlaneNormal = 2,				-- ProjectPointOnToPlane: Point, PlaneBase, PlaneNormal; Output: OutVec0 
															-- ProjectVectorOnToPlane: Input: InVec0, SurNormal; Output: OutVec0 
			Target = 1,										-- ProjectVectorOnToVector: Input: InVec0, Target; Output: OutVec0
															-- RotateVector: Input: A, B; Output: OutVec0
			Axis = 1, Angle = 4,							-- RotateVectorAroundAxis: Input: InVec0, Axis, Angle; Output: OutVec0
			PickA = 8,										-- SelectVector: Input: A, B, PickA; Output: OutVec0
															-- UnrotateVector: Input: A, B; Output: OutVec0
			Float = 4,										-- VectorMinusFloat: Input: A, Float; Output: OutVec0
			Int = 7,										-- VectorMinusInt: Input: A, Int; Output: OutVec0
															-- VectorMinusVector: Input: A, B; Output: OutVec0
															-- VectorMultiplyFloat: Input: A, Float; Output: OutVec0
															-- VectorMultiplyInt: Input: A, Int; Output: OutVec0
															-- VectorMultiplyVector: Input: A, B; Output: OutVec0
															-- VectorDivFloat: Input: A, Float; Output: OutVec0
															-- VectorDivInt: Input: A, Int; Output: OutVec0
															-- VectorDivVector: Inout: A, B; Output: OutVec0
															-- VectorPlusFloat: Input: A, Float; Output: OutVec0
															-- VectorPlusInt: Input: A, Int; Output: OutVec0
															-- VectorPlusVector: Input: A, B; Output: OutVec0
															-- VectorLength: Input: A; Output: OutFloat
															-- VectorLengthSquared: Input: A; Output: OutFloat
															-- VectorLengthXY: Input: A; Output: OutFloat
			-- Output list
			OutVec0 	= 0,
			OutVec1 	= 1,
			OutX 		= 2,
			OutY 		= 3,
			OutZ 		= 4,
			OutFloat 	= 2,
			OutBool 	= 5,
		});
	NG_BindNodeToGraphContainer(containerIndex, makeNode.NodeID);
	return makeNode;
end

--****************************
--* AIBlackBoardDefinition
--* A definition comprised of typed values paired with key associations. This allows for assumption of data
--* which is not known until an instance of an encounter is made. It can also be used to expose tweakable values
--* for an encounter definition.
--****************************

global AIBlackBoardDefinition:table =
{
	m_totalEntries = 0,
	m_entryTypesArray = {},
	m_entryIndicesArray = {},
	m_handle = nil
}

function AIBlackBoardDefinition.New():table
	local boardDef = setmetatable({}, {__index = AIBlackBoardDefinition});
	boardDef.m_totalEntries = 0;
	boardDef.m_entryTypesArray = {};
	boardDef.m_entryIndicesArray = {};
	return boardDef;
end

function AIBlackBoardDefinition:AddEntry(entryKey, valueType:blackboard_entry_type):void
	assert(self.m_handle == nil, "Cannot add entries to AIBlackBoardDefinition after finalizing");
	if (self.m_handle == nil) then
		assert(self.m_entryIndicesArray[entryKey] == nil, "Duplicate entry key used in BlackBoardDefinition");
		table.insert(self.m_entryTypesArray, valueType);
		self.m_entryIndicesArray[entryKey] = self.m_totalEntries;
		self.m_totalEntries = self.m_totalEntries + 1;
	end
end

function AIBlackBoardDefinition:CreateNodeInputLink(entryKey, nodeInput):void
	assert(self.m_handle ~= nil, "AIBlackBoardDefinition must be finalized before using CreateNodeInputLink");
	if (self.m_handle ~= nil) then
		local entryIndex:number = self.m_entryIndicesArray[entryKey];
		assert(entryIndex ~= nil, "Invalid entry index in CreateNodeInputLink");
		NG_LinkBlackBoardDefinitionToNode(self.m_handle, entryIndex, nodeInput.NodeID, nodeInput.PinID);
	end
end

function AIBlackBoardDefinition:IsFinalized():boolean
	return (self.m_handle ~= nil);
end

function AIBlackBoardDefinition:Finalize():void
	if (self.m_handle == nil) then
		self.m_handle = AI_CreateBlackBoardDefinition(self.m_entryTypesArray);
	end
end

function AIBlackBoardDefinition:CreateInstance():table
	if (self.m_handle ~= nil) then
		return AIBlackBoardInstance.New(self);
	else
		assert(self.m_handle ~= nil, "Cannot create a blackboard instance until the definition is finalized");
		return nil;
	end
end


--****************************
--* AIBlackBoardInstance
--* An instance of a BlackBoardDefinition which is used for instances of encounters.
--* Instance specific data can be fed into an encounter's node graph through this.
--* A BlackBoardInstance may belong to an encounter or be shared across multiples.
--****************************

global AIBlackBoardInstance:table =
{
	m_boardDef = nil,
	m_handle = nil
}

function AIBlackBoardInstance.New(boardDef:table):table
	local boardInst:table = setmetatable({}, {__index = AIBlackBoardInstance});
	boardInst.m_boardDef = boardDef;
	boardInst.m_handle = AI_CreateBlackBoardInstance(boardDef.m_handle);
	return boardInst;
end

function AIBlackBoardInstance.NewExisting(boardDef:table, instanceIndex:handle):table
	local boardInst:table = setmetatable({}, {__index = AIBlackBoardInstance});
	boardInst.m_boardDef = boardDef;
	boardInst.m_handle = instanceIndex;
	return boardInst;
end

function AIBlackBoardInstance:CreateNodeInputLink(entryKey, nodeInput):void
	assert(self.m_handle ~= nil, "AIBlackBoardInstance is invalid in CreateNodeInputLink");
	local entryIndex:number = self.m_boardDef.m_entryIndicesArray[entryKey];
	assert(entryIndex ~= nil, "Invalid entry index in CreateNodeInputLink");
	NG_LinkBlackBoardInstanceToNode(self.m_handle, entryIndex, nodeInput.NodeID, nodeInput.PinID);
end

-- Cannot be used to change type.
function AIBlackBoardInstance:UpdateEntry(key, value):void
	local entryIndex:number = self.m_boardDef.m_entryIndicesArray[key];
	assert(entryIndex ~= nil, "Invalid entry index in UpdateEntry");
	if (entryIndex ~= nil) then
		NG_UpdateBlackBoardInstanceEntry(self.m_handle, entryIndex, value);
	end
end


--## SERVER


-------------------------------------------

global EC = {}
EC.encounterTable = {}

function EC.RegisterEncounter(funcName, encounterDef)
	EC.encounterTable[funcName] = encounterDef;
end

function EC.CreateAndRegisterEncounter(funcName)
	local encounterDef = funcName();
	EC.encounterTable[funcName] = encounterDef;
	return encounterDef;
end

function EC.FindEncounter(funcName)
	if EC.encounterTable[funcName] ~= nil then
		return EC.encounterTable[funcName];
	else		
		return nil;
	end
end

function EC.RequestEncounter(funcName)
	local requestEncounter = EC.FindEncounter(funcName);
	if not requestEncounter then
		requestEncounter = EC.CreateAndRegisterEncounter(funcName);
	end
	return requestEncounter;
end


--****************************
--* AIGraphContainer
--****************************

global AIGraphContainer:table = table.makePermanent
{
	m_graphIndex = -1;
}

function AIGraphContainer.New(name:string):table
	local container = setmetatable({}, {__index = AIGraphContainer});
	container.m_graphIndex = NG_CreateGraphContainer(name);
	return container;
end

function AIGraphContainer.NewExisting(graphIndex:handle):table
	local container = setmetatable({}, {__index = AIGraphContainer});
	container.m_graphIndex = graphIndex;
	return container;
end

-- AIGraphContainer Management Functions

function AIGraphContainer:AddNode(node:table):table
	NG_BindNodeToGraphContainer(self.m_graphIndex, node.NodeID);
	return node;
end

function AIGraphContainer:RemoveNode(node:table):void
	NG_RemoveNodeFromGraphContainer(node.NodeID);
end

function AIGraphContainer:DestroyNode(node:table):void
	NG_DestroyNodeInGraphContainer(node.NodeID);
end

function AIGraphContainer:Destroy():void
	NG_DestroyGraphContainer(self.m_graphIndex);
end

-- AIGraphContainer Constant Value Nodes

function AIGraphContainer:CreateConstantBool(value:boolean):table
	local makeNode = CreateNodeObject(
		ng_create_constant_bool(value),
		{Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateConstantFloat(value:number):table
	local makeNode = CreateNodeObject(
		ng_create_constant_float(value),
		{Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateConstantInteger(value:number):table
	local makeNode = CreateNodeObject(
		ng_create_constant_integer(value),
		{Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateConstantAiIndex(value:ai):table
	local makeNode = CreateNodeObject(
		NG_CreateConstantAiIndex(value),
		{Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateConstantLocation(value:location):table
	local makeNode = CreateNodeObject(
		ng_create_constant_location(value),
		{Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

-- AIGraphContainer Dynamic Value Nodes

function AIGraphContainer:CreateAIPositionQuery(aiIndex:ai):table
	local makeNode = CreateNodeObject(
		NG_AIPositionQuery(aiIndex),
		{AiIndex=0, PositionOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateNearestPlayer():table
	local makeNode = CreateNodeObject(
		ng_nearest_player(),
		{Position=0, Radius=1, PlayerPositionOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateNearestVisiblePlayer(refresh:number):table
	local makeNode = CreateNodeObject(
		NG_NearestVisiblePlayer(refresh),
		{Position=0, Radius=1, VisSquad=2, PlayerPositionOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

-- AIGraphContainer Area Generation Nodes

function AIGraphContainer:CreateAABB():table
	local makeNode = CreateNodeObject(
		AG_CreateAABBGenerator(),
		{BasePosition=0, OffsetVec=1, Dimensions=2, AerialArea=3, VehicleArea=4, AreasOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateFloodFill():table
	local makeNode = CreateNodeObject(
		ag_create_floodfill_generator(),
		{StartPosition=0, EndPosition=1, Radius=2, AreasOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateZoneArea():table
	local makeNode:table = CreateNodeObject(
		AG_CreateZoneAreaGenerator(),
		{AreaName=0, ZoneName=1, AreasOut=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateRaycastNavmeshFloor():table
	local makeNode:table = CreateNodeObject(
		AG_RaycastNavmeshFloorPosition(),
		{StartPosition=0, RayDistance=1, HitPosition=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateNearestPositionPathCast():table
	local makeNode:table = CreateNodeObject(
		AG_NearestPositionPathCast(),
		{StartPosition=0, GoalPosition=1, NearestPosition=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateBinaryCut():table
	local makeNode = CreateNodeObject(
		AG_CreateBinaryCut(),
		{Areas=0, Facing=1, Gap=2, SliceVertical=3, AllAreasOut=0, NearAreasOut=1, FarAreasOut=2});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateCircleCut():table
	local makeNode = CreateNodeObject(
		AG_CreateCircleCut(),
		{Areas=0, CircleCenter=1, CircleRadius=2, InnerAreasOut=0, OutterAreasOut=1});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateCrosscut():table
	local makeNode = CreateNodeObject(
		ag_create_crosscut(),
		{Areas=0, SegmentStart=1, SegmentEnd=2, Fraction=3, Gap=4, AllAreasOut=0, NearAreasOut=1, FarAreasOut=2});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

-- AIGraphContainer control nodes

function AIGraphContainer:CreateBranch():table
	local makeNode = CreateNodeObject(
		ng_branch(),
		{A=0, B=1, Condition=2, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreatePinValid():table
	local makeNode = CreateNodeObject(
		ng_pin_valid(),
		{In=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateBooleanInvert():table
	local makeNode = CreateNodeObject(
		ng_boolean_invert(),
		{In=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateNumericalLogic(condition):table
	local makeNode = CreateNodeObject(
		ng_numerical_logic(condition),
		{Left=0, Right=1, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateSwitchOnInteger():table
	local makeNode = CreateNodeObject(
		ng_switch_on_integer(),
		{Selection=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateLabel(name):table
	local makeNode = CreateNodeObject(
		ng_label(name),
		{In=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateSelectFirst():table
	local makeNode = CreateNodeObject(
		ng_select_first(),
		{MultiIn=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateSelectRandom():table
	local makeNode = CreateNodeObject(
		ng_select_random(),
		{MultiIn=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function AIGraphContainer:CreateSelectRoundRobin():table
	local makeNode = CreateNodeObject(
		ng_select_round_robin(),
		{MultiIn=0, Out=0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

--- End AIGraphContainer

-- Squad Generation
global SG = table.makePermanent {};
SG.DeploymentMode = { Standard = 0, Limbo = 1 };


--****************************
--* SquadGenGraphContainer
--****************************

global SquadGenGraphContainer:table = table.makePermanent
{
	m_graphIndex = -1;
}

function SquadGenGraphContainer.New(name:string):table
	local container = setmetatable({}, {__index = SquadGenGraphContainer});
	container.m_graphIndex = NG_CreateGraphContainer(name);
	return container;
end

function SquadGenGraphContainer:Destroy():void
	NG_DestroyGraphContainer(self.m_graphIndex);
end

function SquadGenGraphContainer:CreateCombineSquads():table
	local makeNode:table = CreateNodeObject(
		sg_combine_squads(),
		{Squads = 0, SquadsOut = 0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

function SquadGenGraphContainer:CreateSquadBuilder(...)
	local makeNode:table = CreateNodeObject(
		sg_squad_builder(...),
		{Out = 0});
	NG_BindNodeToGraphContainer(self.m_graphIndex, makeNode.NodeID);
	return makeNode;
end

--- End SquadGenGraphContainer


--****************************
--* AIAreaTable
--****************************

global AIAreaTable:table = table.makePermanent
{
	m_areaTable = {},
}

function AIAreaTable:New():table
	local instance = setmetatable({}, {__index = AIAreaTable});
	instance.m_areaTable = {};
	return instance;
end

function AIAreaTable:AddArea(addArea, useKeywords:table):void
	table.insert(self.m_areaTable, {area = addArea, keywords = useKeywords});
end

function AIAreaTable:GetAreasWithKeyword(keyCheck)
	local keyAreas = {};
	for i, area in ipairs(self.m_areaTable) do
		local hasKey = false;
		for j, keyword in ipairs(area.keywords) do
			if (keyword == keyCheck) then
				hasKey = true;
				break;
			end
		end
		if hasKey then
			table.insert(keyAreas, area.area);
		end
	end
	return keyAreas;
end

function AIAreaTable:PrintAreas()
	print("AREAS IN TABLE");
	for i, area in ipairs(self.m_areaTable) do
		print("Area:", i);
		for j, keyword in ipairs(area.keywords) do
			print("  ", keyword);
		end
	end
end

function AIAreaTable:AddAreasToTask(task, keyCheck)
	local keyAreas = self:GetAreasWithKeyword(keyCheck);
	for i, area in ipairs(keyAreas) do
		ai_task_add_areas(task, area.NodeID, area.PinID, AG.AreaType.Default);
	end
end

function AIAreaTable:AddAreasToOrder(order:ai, keyCheck:string)
	local keyAreas:table = self:GetAreasWithKeyword(keyCheck);
	for i, area in ipairs(keyAreas) do
		AI_OrderAddAreas(order, area.NodeID, area.PinID);
	end
end


--****************************
--* AIDeploymentInfo
--****************************

global AIDeploymentInfo:table = table.makePermanent
{
-- Names checked in code from Lua state.
	Zone = nil,
	Mode = SG.DeploymentMode.Standard,
	GeneratedAreas = {}
}

function AIDeploymentInfo.New():table
	local deployInfo = setmetatable({}, {__index = AIDeploymentInfo});
	deployInfo.GeneratedAreas = {};
	return deployInfo;
end

function AIDeploymentInfo:SetDeploymentMode(deployMode):void
	self.Mode = deployMode;
end

function AIDeploymentInfo:SetDeploymentZone(zoneName)
	self.Zone = zoneName;
end

function AIDeploymentInfo:AddDeploymentArea(areaName, generatedArea):void
	table.insert(self.GeneratedAreas, {Name = areaName, Node = generatedArea.NodeID, Output = generatedArea.PinID});
end

function AIDeploymentInfo:AddSpawnAreas(areaTable, areaKey, spawnKey)
	local deployAreas = areaTable:GetAreasWithKeyword(areaKey);
	for i, area in ipairs(deployAreas) do
		self:AddDeploymentArea(spawnKey, area);
	end
end

function AIDeploymentInfo:SetDeploymentDefaultPosition(loc)
	self.DefaultPosition = ToLocation(loc);
end

-- Area generation
global AG = table.makePermanent {}

AG.AreaType = table.makeEnum { Default = 0, Search = 1, Leader = 2};
AG.TaskState = table.makeEnum { Empty = 0, Occupied = 1, Exhausted = 2};

function AG.AddTaskAreas(task, sourceAreas, areaType)
	ai_task_add_areas(task, sourceAreas.NodeID, sourceAreas.PinID, areaType);
end

-- Squad generation

function SG.CreateCombineSquads()
	return CreateNodeObject(
		sg_combine_squads(),
		{Squads = 0, SquadsOut = 0});
end

function SG.CreateCombineSquadsAll()
	return CreateNodeObject(
		sg_combine_squads_all(),
		{Squads = 0, SquadsOut = 0});
end

function SG.CreateSquadBuilder(...)
	return CreateNodeObject(
		sg_squad_builder(...),
		{Out = 0});
end

function SG.CreateCheckUserData(userDataName, condition, value)
	return CreateNodeObject(
		sg_check_user_data(userDataName, condition, value),
		{In=0, Out=0});
end

function SG.CreateSquadGroup(name)
	return CreateNodeObject(
		sg_create_squad(name),
		{In=0, Out=0});
end

function SG.CreateSpawnArea(name)
	return CreateNodeObject(
		sg_spawn_area(name),
		{In=0, Out=0});
end

function SG.CreateApplyKeyword(name)
	return CreateNodeObject(
		sg_keyword(name),
		{In=0, Out=0});
end

function SG.CreateSetTeam(team)
	return CreateNodeObject(
		sg_set_team(team),
		{In=0, Out=0});
end

function SG.SetGameTeam(campaignTeam:team, mpTeam:mp_team):table
	return CreateNodeObject(
		SG_SetSquadGameTeam(campaignTeam, mpTeam),
		{In=0, Out=0});
end

-- ---------------------
--	Squad Deployment
-- ---------------------

function SG.CreateDeploymentInfo()
	return { Zone=nil, Mode=SG.DeploymentMode.Standard, GeneratedAreas={}, ObjRootNode=nil };
end

function SG.SetDeploymentZone(info, zoneName)
	info.Zone = zoneName;
end

function SG.AddDeploymentArea(info, areaName, generatedArea)
	table.insert(info.GeneratedAreas, {Name = areaName, Node = generatedArea.NodeID, Output = generatedArea.PinID});
end

function SG.SetDeploymentMode(info, mode)
	info.Mode = mode;
end

function SG.SetObjectiveRootNode(info, node)
	info.ObjRootNode = node;
end

-- -----------------------------------------------
--		Wrapper for Deprecated Interface
-- -----------------------------------------------

function ai_sb_select_first(...) 
	local node = ng_select_first();
	ProcessLegacyChildNodes(node, ...);	
	return node;
end

function ai_sb_select_random(...) 
	local node = ng_select_random();
	ProcessLegacyChildNodes(node, ...);	
	return node;
end

function ai_sb_select_round_robin(...)
	local node = ng_select_round_robin();
	ProcessLegacyChildNodes(node, ...);	
	return node;
end
 
function ai_sb_combine(...) 
	local node = sg_combine_squads();
	ProcessLegacyChildNodes(node, ...);	
	return node;
end

function ai_sb_combine_all(...) 
	local node = sg_combine_squads_all();
	ProcessLegacyChildNodes(node, ...);	
	return node;
end

function ai_sb_check_user_data(childNode, userDataName, condition, value) 
	local node = sg_check_user_data(userDataName, condition, value);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_create_squad(childNode, squadName) 
	local node = sg_create_squad(squadName);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_keyword(childNode, keywordName) 
	local node = sg_keyword(keywordName);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_set_team(childNode, team) 
	local node = sg_set_team(team);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_spawn_area(childNode, areaName) 
	local node = sg_spawn_area(areaName);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_game_team(childNode, campaignTeam:team, mpTeam:mp_team) 
	local node = SG_SetSquadGameTeam(campaignTeam, mpTeam);
	ng_create_link(childNode, 0, node, 0);
	return node;
end

function ai_sb_destroy(node)
	ng_destroy(node);
end

function ProcessLegacyChildNodes(parentNode, ...)
	for i,v in ipairs(arg) do
		if type(v) == "table" then
			-- Create squad builder.
			local childNode = sg_squad_builder(v);
			-- Add to parent.
			ng_create_link(childNode, 0, parentNode, 0);
		else
			-- Add to parent.
			ng_create_link(v, 0, parentNode, 0);
		end
	end
end

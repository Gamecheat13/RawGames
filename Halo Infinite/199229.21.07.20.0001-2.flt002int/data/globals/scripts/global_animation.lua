global AnimGraph = table.makePermanent {};

function AnimGraph.DuplicateReturnNodeForVisualScripting(returnNode)
	return returnNode, returnNode
end

function AnimGraph.GetFinalPose()
	return CreateNodeObject(
		AnimGraph_GetFinalPose(),
		{In=0});
end

-- animationName:	name of the animation
-- frame:			frame number of the pose
function AnimGraph.CreatePose(animationName, frame)
	return CreateNodeObject(
		AnimGraph_CreatePose(animationName, frame),
		{Position=0, Out=0});
end

-- animationName:	name of the animation
-- looping:			boolean parameter for indicating whether or not the animation should loop
-- mode:			input mode (link a numerical value output pin to the Position input pin)
--					0 for Frame mode
--					1 for Seconds mode
--					2 for normalized mode
--					(N.B. If nothing is hooked up to the Position input pin, this defaults to 1. For animation sample
--					nodes that are hooked up to a locomotion node with matching phase matched group names, this value is
--					forced to 2).
-- playbackSpeed:	playback speed
function AnimGraph.CreateAnimation(animationName, looping, mode, playbackSpeed)
	return CreateNodeObject(
		AnimGraph_CreateAnimation(animationName, looping, mode, playbackSpeed),
		{Position=0, AnimationTokenName=2, Out=0});
end

-- animationName:	name of the animation
-- looping:			boolean parameter for indicating whether or not the animation should loop
-- mode:			input mode (link a numerical value output pin to the Position input pin)
--					0 for Frame mode
--					1 for Seconds mode
--					2 for normalized mode
--					(N.B. If nothing is hooked up to the Position input pin, this defaults to 1. For animation sample
--					nodes that are hooked up to a locomotion node with matching phase matched group names, this value is
--					forced to 2).
-- groupName:		group name for this animation sampler node
-- playbackSpeed:	playback speed
function AnimGraph.CreateAnimationWithGroupName(animationName, looping, mode, groupName, playbackSpeed)
	return CreateNodeObject(
		AnimGraph_CreateAnimationWithGroupName(animationName, looping, mode, groupName, playbackSpeed),
		{Position=0, AnimationTokenName=2, Out=0});
end

-- offsetTime:		The look ahead time in seconds( The seconds we want to send end of animation event before hit the end of animation.)
function AnimGraph.CreateEndOfAnimation(offsetTime)
	return CreateNodeObject(
		AnimGraph_CreateEndOfAnimation(offsetTime),
		{Out=0});
end

-- offsetTime:		The look ahead time in seconds( The seconds we want to send end of animation event before hit the end of animation.)
-- groupName:		The groupname to listen for
function AnimGraph.CreateEndOfAnimationWithGroupName(offsetTime, groupName)
	return CreateNodeObject(
		AnimGraph_CreateEndOfAnimationWithGroupName(offsetTime, groupName),
		{Out=0});
end

function AnimGraph.CreateBlend()
	return CreateNodeObject(
		AnimGraph_CreateBlend(),
		{PoseA=0, PoseB=1, Alpha=2, Out=0});
end

-- type:
--				0 for Weapon
-- priority:
--				0 for Low
--				1 for Medium
--				2 for High
-- blendRate:	Time it takes this node to fully blend in/out
-- hasRotation:	Does this task affect the rotation?
-- hasPosition: DOes this task affect the position?
function AnimGraph.CreateIKNode(type, priority, blendRate, hasRotation, hasPosition)
	return CreateNodeObject(
		AnimGraph_CreateIKNode(type, priority, blendRate, hasRotation, hasPosition),
		{Pose=0, Out=0});
end

-- boneMaskId: The bone Mask Id.
function AnimGraph.CreateBoneMask(boneMaskId)
	return CreateNodeObject(
		AnimGraph_CreateBoneMask(boneMaskId),
		{Pose=0, Out=0});
end
-- Sample code for  AnimGraph.CreateBoneMask.
--function TestMaskBlend()
	  -- local anim11 = AnimGraph.CreateAnimation("combat:sword:melee", true, 0, 1);
	  -- local anim12 = AnimGraph.CreateAnimation("combat:sword:melee", true, 0, 1);

	  -- local mask_blend = NG.CreateEditableFloat("Blend Amount", 0.5, 0, 1);
	  
	  -- local upper_body_only = AnimGraph.CreateBoneMask('upper_body_only'); 
	  -- NG.CreateLink(anim11.Out, upper_body_only.Pose);

	  -- local blend = AnimGraph.CreateBlend();
	  
	  -- NG.CreateLink(anim12.Out, blend.PoseA);
	  -- NG.CreateLink(upper_body_only.Out, blend.PoseB);
	  -- NG.CreateLink(mask_blend.Out, blend.Alpha);
	  -- return blend;
-- end



function AnimGraph.CreateOverlay()
	return CreateNodeObject(
		AnimGraph_CreateOverlay(),
		{Base=0, Overlay=1, Alpha=2, Out=0});
end

-- alphaMin:	min bound for alpha
-- alphaMax:	max bound for alpha
function AnimGraph.CreateBlendSpace1D(alphaMin, alphaMax)
	return CreateNodeObject(
		AnimGraph_CreateBlendSpace1D(alphaMin, alphaMax),
		{Alpha=0, Out=0});
end

-- alphaMin:	min bound for alpha
-- alphaMax:	max bound for alpha
-- betaMin:		min bound for beta
-- betaMax:		max bound for beta
function AnimGraph.CreateBlendSpace2D(alphaMin, alphaMax, betaMin, betaMax)
	return CreateNodeObject(
		AnimGraph_CreateBlendSpace2D(alphaMin, alphaMax, betaMin, betaMax),
		{Alpha=0, Beta=1, Out=0});
end

-- alphaMin:		min bound for alpha
-- alphaMax:		max bound for alpha
-- partitionCount:	number of forced partitions applied to the triangulation of input poses
--					(N.B. These partitions are made across the beta range (i.e. the angle range). If you don't want to
--					alter the triangulation behavior, set this value to 1.)
function AnimGraph.CreateBlendSpace2DRadial(alphaMin, alphaMax, partitionCount)
	return CreateNodeObject(
		AnimGraph_CreateBlendSpace2DRadial(alphaMin, alphaMax, partitionCount),
		{Alpha=0, Beta=1, Out=0});
end

-- alphaMin:		min bound for alpha
-- alphaMax:		max bound for alpha
-- partitionCount:	number of forced partitions applied to the triangulation of input poses
--					(N.B. These partitions are made across the beta range (i.e. the angle range). If you don't want to
--					alter the triangulation behavior, set this value to 1.)
function AnimGraph.CreateLocomotion2D(alphaMin, alphaMax, partitionCount)
	return CreateNodeObject(
		AnimGraph_CreateLocomotion2D(alphaMin, alphaMax, partitionCount),
		{Alpha=0, Beta=1, Out=0, Phase=2});
end

-- aimAnimationName: name of the source animation for the aim screen poses.
function AnimGraph.CreateAimScreen2D(aimAnimationName)
	return CreateNodeObject(
		AnimGraph_CreateAimScreen2D(aimAnimationName),
		{Yaw=0, Pitch=1, Out=0});
end

-- target:		the target locomotion node
-- groupName:	name of the phase matched animation sampler group
function AnimGraph.SetLocomotionPhaseMatchedAnimationGroup(target, groupName)
	return AnimGraph_SetLocomotionPhaseMatchedAnimationGroup(target.NodeID, groupName);
end

-- target:		the target 1D Blendspace node
-- groupName:	name of the phase matched animation sampler group

function AnimGraph.Set1DBlendSpacePhaseMatchedAnimationGroup(target, groupName)
	return AnimGraph_Set1DBlendSpacePhaseMatchedAnimationGroup(target.NodeID, groupName);
end

-- target:	target 1D blend space
-- alpha:	alpha coordinate of the input pose
-- source:	the source animation sampler for the input pose

function AnimGraph.AddBlendSpaceInputPose1D(target, alpha, source)
	return AnimGraph_AddBlendSpaceInputPose1D(target.NodeID, alpha, source.NodeID, source.PinID);
end

-- target:	target 2D blend space
-- alpha:	alpha coordinate of the input pose
-- beta:	beta coordinate of the input pose
-- source:	the source animation sampler for the input pose
function AnimGraph.AddBlendSpaceInputPose2D(target, alpha, beta, source)
	return AnimGraph_AddBlendSpaceInputPose2D(target.NodeID, alpha, beta, source.NodeID, source.PinID);
end

-- target:	target 2D blend space
-- alpha:	alpha coordinate of the input pose
-- beta:	beta coordinate of the input pose
--			(N.B. Do not place any poses at betaMax!)
-- source:	the source animation sampler for the input pose
function AnimGraph.AddBlendSpaceInputPose2DRadial(target, alpha, beta, source)
	return AnimGraph_AddBlendSpaceInputPose2DRadial(target.NodeID, alpha, beta, source.NodeID, source.PinID);
end

-- target:			target locomotion node
-- alpha:			alpha coordinate of the input pose
-- beta:			beta coordinate of the input pose
--					(N.B. Do not place any poses at betaMax!)
-- source:			the source animation sampler for the input pose
-- autoDetectSpeed:	boolean value indicating whether or not to autodetect the speed for this animation
--					(N.B. This will override the alpha paramater.)
-- autoDetectAngle:	boolean value indicating whether or not to autodetect the angle for this animation
--					(N.B. This will override the beta paramater.)
function AnimGraph.AddLocomotionAnimation2D(target, alpha, beta, source, autoDetectSpeed, autoDetectAngle)
	-- v-milmar 11/13/19 We are ignoring the autoDetectSpeed and autoDetectAngle params now. They are always on.
	return AnimGraph_AddLocomotionAnimation2D(target.NodeID, alpha, beta, source.NodeID, source.PinID);
end

function AnimGraph.CreateUnitLocalVelocityMagnitudeFunction()
	return CreateNodeObject(
		AnimGraph_CreateUnitLocalVelocityMagnitudeFunction(),
		{Out=0});
end

-- angleLockRange:	speed range for locking the output angle
--					(N.B. This is used to avoid popping artifacts in the locomotion node.)
function AnimGraph.CreateUnitLocalVelocityAngleRelativeToFacingFunction(angleLockRange)
	return CreateNodeObject(
		AnimGraph_CreateUnitLocalVelocityAngleRelativeToFacingFunction(angleLockRange),
		{Out=0});
end

-- functionName:	name of the object function
function AnimGraph.CreateObjectFunction(functionName)
	return CreateNodeObject(
		AnimGraph_CreateObjectFunction(functionName),
		{Out=0});
end

function AnimGraph.CreateStateMachine()
	return CreateNodeObject(
		AnimGraph_CreateStateMachine(),
		{Out=0});
end

--creates an empty pose with no animation
function AnimGraph.CreateDummyPoseNode()
	return CreateNodeObject(
		AnimGraph_CreateDummyPoseNode(),
		{Out=0});
end

-- target:	target state machine
-- state:	output Pose pin from the subgraph for this state
-- label:	custom name for the 
function AnimGraph.AddNewState(target, state, label)
	return AnimGraph_AddNewState(target.NodeID, state.NodeID, state.PinID, label or "Unlabelled");
end
-- returns:	internal index for the new state in the target state machine

-- target:		target state machine
-- blendNode:	output Pose pin for the blend node that defines the transition behavior
-- duration:	duration of this transition
function AnimGraph.AddNewTransitionBlend(target, blendNode, duration)
	return AnimGraph_AddNewTransitionBlend(target.NodeID, blendNode.NodeID, blendNode.PinID, duration);
end
-- returns:	internal index for the new transition blend in the target state machine

-- target:				target state machine
-- srcStateID:			internal index of the source state in the target state machine
-- dstStateID:			internal index of the destination state in the target state machine
-- transitionBlendID:	internal index of the transition blend in the target state machine
-- condition:			output boolean pin for the transition trigger condition
function AnimGraph.AddNewTransitionRule(target, srcStateID, dstStateID, transitionBlendID, condition)
	return AnimGraph_AddNewTransitionRule(
		target.NodeID,
		srcStateID,
		dstStateID,
		transitionBlendID,
		condition.NodeID,
		condition.PinID);
end
-- returns:	internal index for the new transition rule in the target state machine

-- target:	target state machine
-- stateID:	internal index of the state that will serve as the final fallback default state in the target state machine
function AnimGraph.SetFallbackDefaultState(target, stateID)
	return AnimGraph_SetFallbackDefaultState(target.NodeID, stateID);
end

-- target:		target state machine
-- stateID:		internal index of the state that will serve as the default state in the target state machine if the
--				condition evaluates to true
-- condition:	output boolean pin for the condition that will be used to determine if the state indicated by stateID
--				will be the initial state of the state machine OnBecomeRelevant
function AnimGraph.AddDefaultStateRule(target, stateID, condition)
	return AnimGraph_AddDefaultStateRule(target.NodeID, stateID, condition.NodeID, condition.PinID);
end

AnimGraph.TransitionData = table.makeEnum
{
	SourcePose = 0,
	DestinationPose = 1,
	TransitionTimeElapsed = 2,
	TransitionTimeElapsedPercentage = 3,
	TransitionDuration = 4
}

-- dataType:	data type of a transition data node
function AnimGraph.CreateTransitionData(dataType)
	return CreateNodeObject(
		AnimGraph_CreateTransitionData(dataType),
		{Out=0});
end

-- N.B. Transition blends should define the blending behavior that a transition should follow when triggered. This is
-- why the blend node's inputs should be defined using TransitionData nodes. You are essentially saying, "Given this
-- source pose, destination pose, time elapsed and total transition duration, output this blended output as the
-- intermediate transition pose."
-- E.G.
-- function CreateDefaultTransitionBlendGraph()
-- 		local blend = AnimGraph.CreateBlend();
-- 		local sourcePose = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.SourcePose);
-- 		local destinationPose = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.DestinationPose);
-- 		local transitionTime = AnimGraph.CreateTransitionData(AnimGraph.TransitionData.TransitionTimeElapsedPercentage);
--
-- 		NG.CreateLink(sourcePose.Out, blend.PoseA);
-- 		NG.CreateLink(destinationPose.Out, blend.PoseB);
-- 		NG.CreateLink(transitionTime.Out, blend.Alpha);
--
-- 		return blend;
-- end

-- evaluateOnRelevant: boolean value indicating whether or not to evaluate selection only On BecomeRelevant
--                     true: Evaluate output only when node just become Relevant. 
--                     false: Always evaluate output when node is Relevant.
-- defaultSelection: int value indicating the fallback selection if the selection index is out of range.
function AnimGraph.CreateSelection(evaluateOnRelevant, defaultSelection)
	return CreateNodeObject(
		AnimGraph_CreateSelection(evaluateOnRelevant, defaultSelection),
		{Pose = 0, TransitionTime = 1, Selected=2, Out = 0});
end

-- Selection links can be added by repeatedly linking to Pose. 
-- E.G.
--function CreateSelectionBlendGraph()
--    local selection = AnimGraph.CreateSelection(false, 0);
--
--    local selection1 = AnimGraph.CreateAnimation("combat:rifle:idle", true, 0, 1);
--    local selection2 = AnimGraph.CreateAnimation("combat:rifle:locomote_walk_front", true, 0, 1);
--    local selection3 = AnimGraph.CreateAnimation("combat:rifle:locomote_run_front", true, 0, 1);
--	
--    NG.CreateLink(selection1.Out, selection.Pose);
--    NG.CreateLink(selection2.Out, selection.Pose);
--    NG.CreateLink(selection3.Out, selection.Pose);
--	
--    return selection;
--end

function AnimGraph.CreateLayer()
	return CreateNodeObject(
		AnimGraph_CreateLayer(),
		{Pose = 0, Base = 1, Out = 0});
end

-- target: target layer node
-- index: internal index of the layer that the properties are being set for
-- alpha: input pin to a float reprensenting the alpha
-- descriptor: the type the layer at index should be 0=ignored, 1=additive, 2=replacement
function AnimGraph.AddLayerNodeInputPose(target, index, alpha, descriptor)
	return AnimGraph_AddLayerNodeInputPose(target.NodeID, index, alpha.NodeID, alpha.PinID, descriptor);
end

-- Layer nodes require that AnimGraph.AddLayerNodeInputPose for each layer pose added.
-- The index parameter refers to the order they were added starting at 0, 1, 2, etc.
-- E.G.
--function CreateLayerBlendGraph()
--	  local layer = AnimGraph.CreateLayer();
--
--	  local baseBlend = AnimGraph.CreateBlend();
--	
--	  local layer1Blend = AnimGraph.CreateBlend();
--	  local layer2blend = AnimGraph.CreateBlend();
--	
--	  NG.CreateLink(baseBlend.Out, layer.Base);
--	
--	  NG.CreateLink(layer1Blend.Out, layer.Pose);
--	  AnimGraph.AddLayerNodeInputPose(layer, 0, 1, 1);
--	
--	  NG.CreateLayer(layer2blend.Out, layer.Pose);
--	  AnimGraph.AddLayerNodeInputPose(layer, 1, 1, 2);
--	
--    return layer;
--end

-- name: the control parameter's name
function AnimGraph.CreateIntControlParameter(name)
	return CreateNodeObject(
		AnimGraph_CreateIntControlParameter(name),
		{Out = 0});
end

-- name: the control parameter's name
function AnimGraph.CreateFloatControlParameter(name)
	return CreateNodeObject(
		AnimGraph_CreateFloatControlParameter(name),
		{Out = 0});
end

-- name: the control parameter's name
function AnimGraph.CreateVectorControlParameter(name)
	return CreateNodeObject(
		AnimGraph_CreateVectorControlParameter(name),
		{Out = 0});
end

-- name: the control parameter's name
function AnimGraph.CreateBoolControlParameter(name)
	return CreateNodeObject(
		AnimGraph_CreateBoolControlParameter(name),
		{Out = 0});
end

function AnimGraph.CreateBooleanInvert()
	local makeNode:table = CreateNodeObject(
		ng_boolean_invert(),
		{In=0, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

function AnimGraph.CreateBooleanLogic(operator)
	local makeNode:table = CreateNodeObject(
		ng_boolean_logic(operator),
		{MultiIn=0, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

function AnimGraph.CreateNumericalLogic(condition)
	local makeNode:table = CreateNodeObject(
		ng_numerical_logic(condition),
		{Left=0, Right=1, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

-- Note that the return value of this node cannot be used with CreateAnimSetNameConcatenate!
-- name: the control parameter's name
function AnimGraph.CreateStringControlParameter(name)
	return CreateNodeObject(
		AnimGraph_CreateStringControlParameter(name),
		{Out = 0});
end

function AnimGraph.CreateSwitchOnInteger()
	local makeNode:table = CreateNodeObject(
		ng_switch_on_integer(),
		{Selection=0, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

-- If the default is not set, it will not be used. Default index will be selected if input selection is not founc
function AnimGraph.SetSwitchOnIntegerDefaultOption(switch, index)
	NG_SetSwitchOnIntDefaultOption(switch.NodeID, index);
end

function AnimGraph.CreateSwitchOnString()
	local makeNode:table = CreateNodeObject(
		NG_SwitchOnString(),
		{Selection=0, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

-- If the default is not set, it will not be used. Default index will be selected if input selection is not founc
function AnimGraph.SetSwitchOnStringDefaultOption(switch, index)
	NG_SetSwitchOnStringDefaultOption(switch.NodeID, index);
end

-- uses the string token as the compare value and the value for the constant string to compare to
function AnimGraph.AddSwitchOnStringOption(switch, stringVal)
	local stringTarget = AnimGraph.CreateConstantString(stringVal);
	NG_AddSwitchOnStringOption(switch.NodeID, stringVal, stringTarget.NodeID, stringTarget.PinID);
end

-- this is a toggle to turn on root motion for a specified target
function AnimGraph.ToggleRootMotionOn(target:table)
	return AnimGraph_ToggleRootMotionOn(target.NodeID);
end

function AnimGraph.CreateConstantFloat(value)
	local makeNode:table = CreateNodeObject(
		ng_create_constant_float(value),
		{Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

function AnimGraph.CreateConstantInt(value)
	local makeNode:table = CreateNodeObject(
		ng_create_constant_integer(value),
		{Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

function AnimGraph.CreateConstantString(value)
	local makeNode:table = CreateNodeObject(
		NG_CreateConstantString(value),
		{Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

function AnimGraph.CreateStringEquals()
	local makeNode:table = CreateNodeObject(
		NG_CreateStringEquals(),
		{Left=0, Right=1, Out=0});
	NG_BindNodeToGraphContainer(AnimGraph_GetNodeContainer(), makeNode.NodeID);
	return makeNode;
end

--------------------------------HOOK UP SetBlackBoardNode to AnimGraph ----------------
---------------------------------------------------------------------------------------
-- HERE is how to create SetBlackBoardNode.                                          --
---------------------------------------------------------------------------------------
-- Before call these 4 func, user should create AnimGraphBlackBoardDefinition first. --
-- And add entry to AnimGraphBlackBoardDefinition and Finalize it.                   --
-- Then create these node with entry index. --

-- local boardDef:table = AnimGraphBlackBoardDefinition:Create();
-- boardDef:AddEntry("Float", BLACKBOARD_ENTRY_TYPE.Float);
-- boardDef:AddEntry("Bool", BLACKBOARD_ENTRY_TYPE.Bool);
-- boardDef:AddEntry("Int", BLACKBOARD_ENTRY_TYPE.Int);
-- boardDef:AddEntry("Vector", BLACKBOARD_ENTRY_TYPE.Vector);
-- boardDef:Finalize();

-- local BBfloatInput = NG.CreateConstantFloat(1.0);
-- local BBboolInput = NG.CreateEditableBool("test bool", true);
-- local BBintInput = NG.CreateEditableInt("test int", 10);
-- local BBvectorInput = NG.CreateEditableVector("test vect", vector(1.0,2.0,3.0));

-- local fIndex = boardDef:GetEntryIndex("Float");
-- local bIndex = boardDef:GetEntryIndex("Bool");
-- local iIndex = boardDef:GetEntryIndex("Int");
-- local vIndex = boardDef:GetEntryIndex("Vector");

-- local iNode = AnimGraph.CreateIntSetBlackBoardNode(iIndex);
-- local bNode = AnimGraph.CreateBoolSetBlackBoardNode(bIndex);
-- local fNode = AnimGraph.CreateFloatSetBlackBoardNode(fIndex);
-- local vNode = AnimGraph.CreateVectorSetBlackBoardNode(vIndex);

-- This will be replacement call to GetEntryIndex(...) and CreateFloatSetBlackBoardNode(...);
-- local ffNode =  AnimGraph.CreateFloatSetBlackBoardNodeWithEntryName(boardDef, "Float");

-- NG.CreateLink(BBfloatInput.Out, fNode.EvaluateData);
-- NG.CreateLink(BBfloatInput.Out, fNode.RelevantData);
-- NG.CreateLink(BBfloatInput.Out, fNode.IrrelevantData);

-- NG.CreateLink(BBboolInput.Out, bNode.EvaluateData);
-- NG.CreateLink(BBboolInput.Out, bNode.RelevantData);
-- NG.CreateLink(BBboolInput.Out, bNode.IrrelevantData);

-- NG.CreateLink(BBintInput.Out, iNode.EvaluateData);
-- NG.CreateLink(BBintInput.Out, iNode.RelevantData);
-- NG.CreateLink(BBintInput.Out, iNode.IrrelevantData);

-- NG.CreateLink(BBvectorInput.Out, vNode.EvaluateData);
-- NG.CreateLink(BBvectorInput.Out, vNode.RelevantData);
-- NG.CreateLink(BBvectorInput.Out, vNode.IrrelevantData);

-- -- Just hook up float node for testing
-- NG.CreateLink(topLevelStateMachine.Out, fNode.EvaluateLink);
-- local final = AnimGraph.GetFinalPose();
---- Now fNode is part of graph, it will update the blackboard value when OnBecomeRelevant, OnBecomeIrrelevant and EvaluateOutputInternal called. ----
---- It also could be end of graph and don't have to do this passthrough behavior. For this case, just don't setup fNode.EvaluateLink. ----
-- NG.CreateLink(fNode.Out, final.In);
--------------------------------------------------------

--------------------------------------------------------
----HERE is how to read the value ----
--------------------------------------------------------
-- local baseBlend = AnimGraph.CreateBlend();
-- NG.CreateLink(anims["melee"].Out, baseBlend.PoseA);
-- NG.CreateLink(anims["throw_grenade"].Out, baseBlend.PoseB);
-- boardDef:CreateNodeInputLink("Float", baseBlend.Alpha);
--------------------------------------------------------

function AnimGraph.CreateIntSetBlackBoardNode(blackboardIndex:number):table
	return CreateNodeObject(
			AnimGraph_CreateIntSetBlackBoardNode(blackboardIndex),
			{ EvaluateLink = 0, EvaluateData = 1, RelevantData = 2, IrrelevantData = 3, Out = 0});
end 

function AnimGraph.CreateFloatSetBlackBoardNode(blackboardIndex:number):table
	return CreateNodeObject(
			AnimGraph_CreateFloatSetBlackBoardNode(blackboardIndex),
			{ EvaluateLink = 0, EvaluateData = 1, RelevantData = 2, IrrelevantData = 3, Out = 0});
end 

function AnimGraph.CreateBoolSetBlackBoardNode(blackboardIndex:number):table
	return CreateNodeObject(
			AnimGraph_CreateBoolSetBlackBoardNode(blackboardIndex),
			{ EvaluateLink = 0, EvaluateData = 1, RelevantData = 2, IrrelevantData = 3, Out = 0});
end 

function AnimGraph.CreateVectorSetBlackBoardNode(blackboardIndex:number):table
	return CreateNodeObject(
			AnimGraph_CreateVectorSetBlackBoardNode(blackboardIndex),
			{ EvaluateLink = 0, EvaluateData = 1, RelevantData = 2, IrrelevantData = 3, Out = 0});
end 

function AnimGraph.CreateIntSetBlackBoardNodeWithEntryName(blackboardDefinition, entryName):table
	local blackboardIndex = blackboardDefinition:GetEntryIndex(entryName);
	return AnimGraph.CreateIntSetBlackBoardNode(blackboardIndex);
end

function AnimGraph.CreateFloatSetBlackBoardNodeWithEntryName(blackboardDefinition, entryName):table
	local blackboardIndex = blackboardDefinition:GetEntryIndex(entryName);
	return AnimGraph.CreateFloatSetBlackBoardNode(blackboardIndex);
end

function AnimGraph.CreateBoolSetBlackBoardNodeWithEntryName(blackboardDefinition, entryName):table
	local blackboardIndex = blackboardDefinition:GetEntryIndex(entryName);
	return AnimGraph.CreateBoolSetBlackBoardNode(blackboardIndex);
end

function AnimGraph.CreateVectorSetBlackBoardNodeWithEntryName(blackboardDefinition, entryName):table
	local blackboardIndex = blackboardDefinition:GetEntryIndex(entryName);
	return AnimGraph.CreateVectorSetBlackBoardNode(blackboardIndex);
end

-- inherit from AIBlackBoardDefinition because we want to alloacte BlackBoardDefinition in AnimGraph mempool.
function inheritsFrom( baseClass ):table

	local new_class = {};
	local class_mt = { __index = new_class };
	function new_class:Create()
		local newinst = {};
		setmetatable( newinst, class_mt );
		return newinst;
	end
	-- The following is the key to implementing inheritance:
	-- The __index member of the new class's metatable references the
	-- base class.  This implies that all methods of the base class will
	-- be exposed to the sub-class, and that the sub-class can override
	-- any of these methods.
	if baseClass then
		setmetatable( new_class, { __index = baseClass } );
	end
	
	return new_class;
end 

global AnimGraphBlackBoardDefinition = inheritsFrom( AIBlackBoardDefinition );
function AnimGraphBlackBoardDefinition:Finalize():void
	if (self.m_handle == nil) then
		self.m_handle = AnimGraph_CreateBlackBoardDefinition(self.m_entryTypesArray);
	end
end

function AnimGraphBlackBoardDefinition:GetEntryIndex(entryKey):number
	assert(entryKey ~= nil, "pass in invalid entries name to AnimGraphBlackBoardDefinition:GetEntryIndex");
	assert(self.m_handle ~= nil, "AnimGraphBlackBoardDefinition must be finalized before using");
	local entryIndex:number = nil;
	if (self.m_handle ~= nil) then
		entryIndex = self.m_entryIndicesArray[entryKey];
		assert(entryIndex ~= nil, "Invalid entry index in AnimGraphBlackBoardDefinition");
	end
	
	return entryIndex;
end

-- Add a conditional based anim set push call. If condition subgraph evaluates to true, the string returned from the
-- animSetName subgraph will be pushed as an anim set.
function AnimGraph.AddConditionalPushAnimSetEntry(condition, animSetName)
	return AnimGraph_AddConditionalPushAnimSetEntry(condition.NodeID, condition.PinID, animSetName.NodeID, animSetName.PinID);
end

-- Add a anim set push call. The string returned from the animSetName subgraph will be pushed as an anim set.
function AnimGraph.AddPushAnimSetEntry(animSetName)
	return AnimGraph_AddPushAnimSetEntry(animSetName.NodeID, animSetName.PinID);
end

-- Create a node that will concatenate strings together.
function AnimGraph.CreateAnimSetNameConcatenate()
	return CreateNodeObject(
		AnimGraph_CreateAnimSetNameConcatenate(),
		{Out = 0});
end

-- Add a substring entry for AnimSetNameConcatenate node. The substrings will be concatenated in the order in which they
-- are added.
function AnimGraph.AddAnimSetNameSubstring(target, animSetName)
	return AnimGraph_AddAnimSetNameSubstring(target.NodeID, animSetName.NodeID, animSetName.PinID);
end

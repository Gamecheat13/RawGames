--## SERVER

-- Global Object Callbacks
-- Copyright (C) Microsoft. All rights reserved.


-------------------------------------------------------------------------------------------------
-- Personal AI Deployed Callback
-- Called by the game when a participant deploys their personal AI to a target object
-------------------------------------------------------------------------------------------------

hstructure PersonalAIDeployedEventStruct
	ownerPlayer:player;
	target:object;
end

-- Callback from C++
function PersonalAIDeployedCallback(ownerPlayer:player, target:object)
	local eventArgs = hmake PersonalAIDeployedEventStruct
		{
			ownerPlayer = ownerPlayer,
			target = target,
		}

	CallEvent(g_eventTypes.personalAIDeployed, ownerPlayer, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Personal AI Recalled Callback
-- Called by the game when a participant's personal AI has been recalled from an object
-------------------------------------------------------------------------------------------------

hstructure PersonalAIRecalledEventStruct
	ownerPlayer:player;
	reason:personal_ai_recall_reason;
end

-- Callback from C++
function PersonalAIRecalledCallback(ownerPlayer:player, reason:personal_ai_recall_reason)
	local eventArgs = hmake PersonalAIRecalledEventStruct
		{
			ownerPlayer = ownerPlayer,
			reason = reason,
		}

	CallEvent(g_eventTypes.personalAIRecalled, ownerPlayer, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Personal AI Animation Started Callback
-- Called by the game when a participant's personal AI begins an animation, either 
-- immediately or if from the queue
-------------------------------------------------------------------------------------------------

hstructure PersonalAIAnimationEventStruct
	ownerPlayer:player;
	animType:personal_ai_animation_type;
end

-- Callback from C++
function PersonalAIAnimationStartedCallback(ownerPlayer:player, animType:personal_ai_animation_type)
	local eventArgs = hmake PersonalAIAnimationEventStruct
		{
			ownerPlayer = ownerPlayer,
			animType = animType,
		}

	CallEvent(g_eventTypes.personalAIAnimationStarted, ownerPlayer, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Personal AI Animation Interrupted Callback
-- Called by the game when a participant's personal AI has an ongoing animation interrupted 
-------------------------------------------------------------------------------------------------

-- Callback from C++
function PersonalAIAnimationInterruptedCallback(ownerPlayer:player, animType:personal_ai_animation_type)
	local eventArgs = hmake PersonalAIAnimationEventStruct
		{
			ownerPlayer = ownerPlayer,
			animType = animType,
		}

	CallEvent(g_eventTypes.personalAIAnimationInterrupted, ownerPlayer, eventArgs);
end

-------------------------------------------------------------------------------------------------
-- Personal AI Animation Completed Callback
-- Called by the game when a participant's personal AI has a non-looping animation play to completion 
-------------------------------------------------------------------------------------------------

-- Callback from C++
function PersonalAIAnimationCompletedCallback(ownerPlayer:player, animType:personal_ai_animation_type)
	local eventArgs = hmake PersonalAIAnimationEventStruct
		{
			ownerPlayer = ownerPlayer,
			animType = animType,
		}

	CallEvent(g_eventTypes.personalAIAnimationCompleted, ownerPlayer, eventArgs);
end


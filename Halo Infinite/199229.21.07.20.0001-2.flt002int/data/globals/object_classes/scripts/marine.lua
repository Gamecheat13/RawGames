-- object marine:generic_ai
-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

REQUIRES('globals\object_classes\scripts\generic_ai.lua');
REQUIRES('globals\scripts\global_hstructs.lua');

global k_marineVars:table = {
	noRecruitNavPointDistance = 6,
	idleRescueCalloutDistance = 10.75,
	idleLookResponseDistance = 1.25,
	idleLookLongResponseWaitTime = 17.5,
	idleLookResponseResetTime = 90,
};

-- Marine State Helper classes

-- =====================================================================
-- Marine Normal
global MarineState_Normal = {
	marine = nil,
	normal = true,
};

function MarineState_Normal:New(marine:object):table
	local newMarineState:table = table.addMetatableRecursive(self);
	newMarineState.marine = marine;
	local squadAi:ai = ai_get_squad(marine.ai);
	local recruitable:boolean = ai_get_recruitable(squadAi);
	marine:SetRecruitable(recruitable);
	return newMarineState;
end

function MarineState_Normal:Exit():void
	return
end

-- =====================================================================
-- Marine Captured
global MarineState_Captured = {
	marine = nil,
	captured = true,
	_idleProc = nil,
	prevRecruitable = true, -- should never be used
};

function MarineState_Captured:New(marine:object):table
	local newMarineState:table = table.addMetatableRecursive(self);
	newMarineState.marine = marine;
	ai_register_stimulus(marine.ai, "dlg_captured");
	ai_register_stimulus(marine.ai, "captured_no_ping_stim"); -- pings look like a bug
	ai_activity_set(marine.ai, "act_captured_kneel");
	ai_disregard(marine, true);
	-- ObjectSetSpartanTrackingEnabled(newMarineState.marine, true);
	newMarineState.prevRecruitable = marine:IsRecruitable()
	marine:SetRecruitable(false);
	newMarineState._idleProc = CreateObjectThread(marine, newMarineState.IdleProc, newMarineState);
	-- cs_enable_dialogue(true);
	return newMarineState;
end

function MarineState_Captured:Exit():void
	self.captured = false;
	ai_remove_stimulus(self.marine.ai, "captured_no_ping_stim");
	ai_activity_abort(self.marine.ai);
	ai_disregard(self.marine, false);
	KillThread(self._idleProc);
	self.marine:SetRecruitable(self.prevRecruitable);
	DialogueSystem_RunEvent(self.marine, "set_free");
	self._curThinkProc = CreateObjectThread(self.marine, PostCapturedProc, self.marine);
end

function MarineState_Captured:IdleProc():void
	local lookTriggered:boolean = false;
	local lookLongTriggered:boolean = false;
	local lookStartTime:time_point = nil;
	while biped_is_alive(self.marine) do
		SleepSeconds(2.0 * real_random_range(0.9, 1.1));	
		local closeDistance:number = 1024 * 1024;
		local closePlayer:object = nil;
		local selfPos:vector = location(self.marine, "").vector;
		for _, activePlayer in ipairs(PLAYERS.active) do		
			local playerPos:vector = location(activePlayer, "").vector;
			local dist:number = (selfPos - playerPos).length;
			if closeDistance > dist then
				closePlayer = activePlayer;
				closeDistance = dist;
			end
		end	
		if closePlayer ~= nil then
			if closeDistance <= k_marineVars.idleLookResponseDistance and objects_can_see_object(closePlayer, self.marine, 18.75) then
				if lookTriggered ~= true then
					SleepSeconds(1.75 * real_random_range(0.9, 1.1))
					DialogueSystem_RunEvent(self.marine, "player_look", closePlayer);
					lookTriggered = true;
					lookStartTime = Game_TimeGet();
				elseif lookLongTriggered ~= true and Game_TimeGet():ElapsedTime(lookStartTime) > k_marineVars.idleLookLongResponseWaitTime then
					DialogueSystem_RunEvent(self.marine, "player_look_longtime", closePlayer);
					lookLongTriggered = true;
					lookStartTime = Game_TimeGet();
				elseif lookLongTriggered == true and Game_TimeGet():ElapsedTime(lookStartTime) > k_marineVars.idleLookResponseResetTime then -- clear the look gates because time
					lookTriggered = false;
					lookLongTriggered = false;
					lookStartTime = nil;
				end
			elseif closeDistance > k_marineVars.idleLookResponseDistance and closeDistance <= k_marineVars.idleRescueCalloutDistance then
				DialogueSystem_RunEvent(self.marine, "set_free_request", closePlayer);
				SleepSeconds(8.0 * real_random_range(0.9, 1.1));
			elseif lookTriggered == true and closeDistance > (k_marineVars.idleRescueCalloutDistance + 0.25) then -- clear the look gates because distance
				lookTriggered = false;
				lookLongTriggered = false;
				lookStartTime = nil;
			end
		end
	end
end

-- implimenting this as a stand alone function because this is something the marine says after being freed.
function PostCapturedProc(marine:object):void
	SleepSeconds(1.7 * real_random_range(0.9, 1.1));
	local closeDistance:number = 1024 * 1024;
	local closePlayer:object = nil;
	local selfPos:vector = location(marine, "").vector;
	for _, activePlayer in ipairs(PLAYERS.active) do
		local playerPos:vector = location(activePlayer, "").vector;
		local dist:number = (selfPos - playerPos).length;
		if closeDistance > dist then
			closePlayer = activePlayer;
			closeDistance = dist;
		end
	end
	if not biped_is_alive(marine) or closePlayer == nil then
		return;
	end
	DialogueSystem_RunEvent(marine, "berserk_set_free", closePlayer);
	ai_remove_stimulus(marine.ai, "dlg_captured");
end

hstructure marine:generic_ai
	close_trigger : boolean
	ai: ai
	unrecruitableNavPoint: navpoint
	followerNavPoint: navpoint
	substate: table
	combatThread:thread
	followIdleThread:thread
	killNavpointThread:thread
end

-- script initialization
function marine:init()
	self.close_trigger = false;
	self.ai = object_get_ai(self);
	self:RegisterEventOnSelf(g_eventTypes.deathEvent, self.OnDeath, self);
	self:RegisterEventOnSelf(g_eventTypes.spartanTrackingPingObjectEvent, self.OnTrackingPing, self);
	if self.substate == nil or not self.substate.captured then
		self.substate = MarineState_Normal:New(self);
	self.combatThread = nil;
	self.followIdleThread = nil;
	end
end

function marine:Captured():void
	if self.substate ~= nil and self.substate.captured == true then
		return;
	elseif self.substate ~= nil then
		self.substate:Exit();
	end
	self.substate = MarineState_Captured:New(self);
end

-- safe to call at any time for campaign script support
function marine:FreeMe()
	if not self.substate.captured then
		return
	end
	self.substate:Exit()
	self.substate = MarineState_Normal:New(self);
end

function marine:SetRecruitable(val:boolean):void
	local squadAi:ai = ai_get_squad(self.ai);
	ai_set_recruitable(squadAi, val);
	if val and self.unrecruitableNavPoint ~= nil then
		Navpoint_Delete(self.unrecruitableNavPoint);
		self.unrecruitableNavPoint = nil;
	elseif val == false and self.unrecruitableNavPoint == nil then
		self.unrecruitableNavPoint = Navpoint_Create("campaign_unrecruitable");
		Navpoint_SetObjectParent(self.unrecruitableNavPoint, self);
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.unrecruitableNavPoint, true);
    	Navpoint_SetCanBeOccluded(self.unrecruitableNavPoint, true);
    	Navpoint_SetVisibilityDistance(self.unrecruitableNavPoint, k_marineVars.noRecruitNavPointDistance);
		Navpoint_SetPositionOffset(self.unrecruitableNavPoint, vector(0, 0, 0.1));
    	Navpoint_SetEnabled(self.unrecruitableNavPoint, true);
	end
end

function marine:IsRecruitable():boolean
	local squadAi:ai = ai_get_squad(self.ai);
	return ai_get_recruitable(squadAi);
end

function marine:OnDeath():void
	if self.unrecruitableNavPoint ~= nil then
		Navpoint_Delete(self.unrecruitableNavPoint);
		self.unrecruitableNavPoint = nil;
	end
	if self.followerNavPoint ~= nil then
		Navpoint_Delete(self.followerNavPoint);
		self.followerNavPoint = nil;
	end
	if (self.followIdleThread ~= nil) then
		KillThread(self.followIdleThread);
	end
end

function marine:quit() : void
	if self.unrecruitableNavPoint ~= nil then
		Navpoint_Delete(self.unrecruitableNavPoint);
		self.unrecruitableNavPoint = nil;
	end
	if self.followerNavPoint ~= nil then
		Navpoint_Delete(self.followerNavPoint);
		self.followerNavPoint = nil;
	end
end

function marine:OnTrackingPing():void
	if self.followerNavPoint == nil then
		self.followerNavPoint = Navpoint_Create("campaign_recruitable");
		Navpoint_SetObjectParent(self.followerNavPoint, self);
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(self.followerNavPoint, true);
		Navpoint_SetCanBeOccluded(self.followerNavPoint, false);
		Navpoint_SetVisibilityDistance(self.followerNavPoint, 120);
		Navpoint_SetPositionOffset(self.followerNavPoint, vector(0, 0, 0.05));
		Navpoint_SetEnabled(self.followerNavPoint, true);
	end
	if self.killNavpointThread ~= nil then
		KillThread(self.killNavpointThread);
	end
	self.killNavpointThread = self:CreateThread(self.navpointPauseKill);
end

function marine:OnJoinFriendlyFollowSquad():void
	ObjectSetSpartanTrackingEnabled(self, true);
	self:OnTrackingPing();
	if self.unrecruitableNavPoint ~= nil then
		Navpoint_Delete(self.unrecruitableNavPoint);
		self.unrecruitableNavPoint = nil;
	end
	if (self.followIdleThread ~= nil) then
		KillThread(self.followIdleThread); --kill the thread for following marine idle movement if it was somehow running
	end
	self.followIdleThread = self:CreateThread(self.followIdleMotionCheck); --start the thread to wait for postcombat to end
	ai_remove_stimulus(self.ai, "dlg_grounded"); --clears the dialogue stimulus from being spawned at a FOB
	-- Player_ActivateSpartanTrackingMark(PLAYERS.player0, TAG('globals\globals\defaultcustomping.spartantrackingpingdefinition'), self);
end

function marine:OnLeaveFriendlyFollowSquad()
	if self.followerNavPoint ~= nil then
		Navpoint_Delete(self.followerNavPoint);
		self.followerNavPoint = nil;
	end
	ObjectSetSpartanTrackingEnabled(self, false);
	if (self.followIdleThread ~= nil) then
		KillThread(self.followIdleThread); --kill the thread for following marine idle movement
	end
end

--Switch is triggered by a call within the character tag under the Custom Scripting Block
-- turning on the stimuli character 
function marine:close_range_stimulus()
	-- print("marine:close_range_stimulus()");
	ai_register_stimulus(self.ai, "close_range");
end

-- turning off the stimuli character 
function marine:exit_close_range_stimulus()
	-- print("marine:exit_close_range_stimulus()")
	ai_remove_stimulus(self.ai, "close_range");
end

--Trigger is fired by a call based on danger, within the character tag under the Custom Scripting Block
-- Turn on a thread to track exiting combat
function marine:prepare_delayed_postcombat()
	if self.substate.captured == true then
		return
	end
	ai_remove_stimulus(self.ai, "dlg_danger");  --clear the stimulus if it was set from a prior postcombat but wasn't cleared yet
	if (self.combatThread ~= nil) then
		KillThread(self.combatThread);
	end
	self.combatThread = self:CreateThread(self.trackPostCombat);
end

-- A thread that tracks combat ending and sets a temporary dialogue stimulus
function marine:trackPostCombat()
	SleepUntil([|ai_combat_status_a_less_than_b(ai_combat_status(self.ai), ACTOR_COMBAT_STATUS.Active)], 1); --postcombat behavior is still Active, so when they drop below that, postcombat is over
	ai_register_stimulus(self.ai, "dlg_danger"); --throw on the stimulus driving suppression/addition of post-combat idle triggers
	SleepSeconds(9.0 * real_random_range(0.9, 1.1));
	ai_remove_stimulus(self.ai, "dlg_danger");
	self.combatThread = nil;
end

--Triggered by joining a friendly follow Squad, and killed if the unit dies or exits a follow squad.
-- A thread to periodically track position and movement, and fire events using the closest player as cause, regardless of who is being followed
function marine:followIdleMotionCheck():void
	SleepSeconds(6.5)
	local lastMoveAt:time_point = Game_TimeGet();
	while true do
		local lastPos:vector = Object_GetPositionVector(self);
		SleepSeconds(0.25);
		local newPos:vector = Object_GetPositionVector(self);
		local distMoved:number = (lastPos - newPos).length;
		if (distMoved > 0.25) then												--you moved
			dialogueEventWithClosestPlayerAs("cause", "follow_move", self);
			SleepSeconds(8);
			lastMoveAt = Game_TimeGet();
		elseif Game_TimeGet():ElapsedTime(lastMoveAt) > 25.0 then				--you didn't move and it's been enough time to comment
			dialogueEventWithClosestPlayerAs("cause", "follow_wait", self);
			lastMoveAt = Game_TimeGet();
			SleepSeconds(8);
		else																	--you didn't move but it hasn't been long enough
			SleepSeconds(2.5);
		end
	end
end

function marine:navpointPauseKill():void
	SleepSeconds(6.0);
	Navpoint_Delete(self.followerNavPoint);
	self.followerNavPoint = nil;
end

-- I don't know why this function was written, but migrating it over from marine_unarmed.lua
function CanBeCaptured(marineRef):boolean
	if marineRef == nil then
		print("Hey!  There isn't a marine here to be captured for some reason.. That's weird.");
		return false;
	elseif type(marineRef) == "ui64" then
		print("marine_unarmed.lua may be trying to reference ui64 handle,", Object_GetDefinition(marineRef), "as a marine_unarmed hstructure!");
		return false;
	elseif marineRef.Captured ~= nil then
		return true;
	end
	return false;
end

function placement_script_marine_captured():void
	local marine = ai_get_object(ai_current_actor);
	if CanBeCaptured(marine) then
		marine:Captured();
	end
end
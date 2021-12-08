-- object academy_bot_target

-- Copyright (C) Microsoft. All rights reserved.
-- This KIT should is designed to be streamed and not initially placed

--## SERVER

hstructure academy_bot_target
	meta : table;
	instance: luserdata;
	components: userdata;
	initialized: boolean;
	targetSquad: ai;
	createdTarget: ai;
	targetTag: tag;
	globalEventManagerParcel: table;
	spawnLocation: flag;
	targetNavColor: color_rgba;	
	patrolTarget: flag;

	initThread:thread;
	--tuneable design properties
	targetBehavior: string; --$$ METADATA {"prettyName": "Target Behavior", "source": ["None", "Braindead", "Patrol", "Crouch"]}
	crouchInterval: number; --$$ METADATA {"prettyName": "Crouch Interval",  "min": 1.0, "max": 20.0, "tooltip": "Time delay (in seconds) between the target crouching down and crouching up"}
	playfightMinDistance: number; --$$ METADATA {"prettyName": "Minimum Distance",  "min": 3.0, "max": 15.0, "tooltip": "Minimum distance bots will keep when playfighting"}
	playfightMaxDistance: number; --$$ METADATA {"prettyName": "Maximum Distance",  "min": 10.0, "max": 30.0, "tooltip": "Maximum distance bots will keep when playfighting"}
end

function academy_bot_target:init():void
	self.spawnLocation = self.components.spawnlocation;
	self.globalEventManagerParcel = _G["GlobalEventManager"];
	self.patrolTarget = self.components.patroltarget;
	self.targetBehavior = self.targetBehavior or nil;
	self.crouchInterval = self.crouchInterval or 1;
	self.targetNavColor = color_rgba(1, 0, 0, 1);
	self.initialized = true;
	if Bot_EnablePlayfighting ~= true then
		Bot_EnablePlayfighting = true;
	end
	if Bot_EnablePlayfighting == true then
		Bot_Playfight_MinDistance = self.playfightMinDistance or 3;
		Bot_Playfight_MaxDistance = self.playfightMaxDistance or 10;
	end
end

function academy_bot_target:Activate():void
	self.initThread = CreateKitThread(self, self.CustomInitThread, self);
end

function academy_bot_target:Deactivate():void
	if (self.initThread ~= nil) then
		KillThread(self.initThread);
		self.initThread = nil;
	end
end

function academy_bot_target:GetComponents():void
	return self.components;
end

function academy_bot_target:IsInitialized():void
	return self.initialized;
end

function academy_bot_target:CustomInitThread():void
	self.targetTag = TAG('objects\characters\spartans\ai\bot_academy.character');
	self.targetSquad	=  SquadBuilder:BuildSimpleSquad(self.targetTag, "bot", 1);
	self.createdTarget = SquadBuilder:PlaceSquad(self.targetSquad, self.spawnLocation, false);
	
	self:removeWeapons(ai_get_unit(self.createdTarget));
	NavpointShowAI(self.createdTarget, "enemy", self.targetNavColor, nil);

	if (self.GlobalEventManagerParcel == nil) then
		self.globalEventManagerParcel = _G["GlobalEventManager"];
	end

	-- If we you want to use these events you need to register the event in your parcel like this:
	-- GlobalEventManager:RegisterParcelGlobalEvent("OnTargetCreated");
	if (self.globalEventManagerParcel ~= nil) then
		self.globalEventManagerParcel:FireGlobalEvent("OnTargetCreated", self, self.createdTarget);
	else
		dprint("Error! Global Event Manager wasn't available.")
	end

	for _, actor in hpairs(ai_actors(self.createdTarget)) do
		if ShouldApplyOutlinesInAcademy == true then
			RunClientScript ("cl_CreateEnemyOutline", actor);
		end
		RunClientScript ("cl_CreateSpawnEffect", actor);
		-- Make sure the targets can always see the players so that they can continue strafing/playfighting behaviors
		-- even if they lose line of sight.
		-- Note: This is not join in progress safe, but this kit is currently only used in single player weapon drills.
		for _, aPlayer in hpairs(PLAYERS.active) do
			ai_magically_see_object(object_get_ai(actor), Player_GetUnit(aPlayer));
		end

		if self.targetBehavior ~= nil then
			self:ApplyTargetBehavior(actor);
		end
	end

	object_set_facing(self.createdTarget, self.spawnLocation);
	local createdTargetUnit = ai_get_unit(self.createdTarget)
	self:RegisterEventOnSelf(g_eventTypes.deathEvent, self.onDeath, createdTargetUnit);
end

function academy_bot_target:onDeath(eventArgs:DeathEventStruct):void
	if self.globalEventManagerParcel ~= nil then
		self.globalEventManagerParcel:FireGlobalEvent("OnTargetDead", self, self.createdTarget);
	else
		dprint(" self.globalEventManagerParcel is nil");
	end
end

function academy_bot_target:removeWeapons(target:ai):void
	Unit_EmptyAmmo(target);
	Unit_EmptyGrenadeInventory(target);
end

--BEHAVIOR DETERMINANT
--run through the behavior checks from the kit itself, apply the desired command scripts, and wait for the death message
function academy_bot_target:ApplyTargetBehavior(actor:ai)
	if self.targetBehavior == "Braindead" then
		ai_braindead((object_get_ai(actor)), true);
	elseif self.targetBehavior == "Patrol" then 
		RunCommandScript(object_get_ai(actor), self.Patrol, self, self.patrolTarget, self.spawnLocation);
	elseif self.targetBehavior == "Crouch" then 
		RunCommandScript(object_get_ai(actor), self.RepeatCrouch, self);
	end
end

--COMMAND SCRIPTS
--target crouches on a set interval
function academy_bot_target:RepeatCrouch()
	cs_suppress_activity_termination(ai_current_actor, true);
	repeat
		cs_crouch(ai_current_actor, true);
		SleepSeconds(self.crouchInterval);
		cs_crouch(ai_current_actor, false);
		SleepSeconds(self.crouchInterval);
	until unit_get_health(ai_current_actor) <= 0;
end

function academy_bot_target:Patrol(targetFlag:flag, returnFlag:flag)
	cs_suppress_activity_termination(ai_current_actor, true);
	repeat
		cs_go_to(ai_current_actor, true, targetFlag, 0);
		SleepSeconds(1);
		cs_go_to(ai_current_actor, true, returnFlag, 0);
		SleepSeconds(1);
	until unit_get_health(ai_current_actor) <= 0;
end

--## CLIENT

function remoteClient.cl_CreateEnemyOutline(unit:object)
	Outline_AssignTagToObject(unit, TAG('globals\outlines\default_enemy_outline.outlinetypedefinition'));
	SleepUntil([| unit_get_health(unit) <= 0 ], 1);
	Outline_RemoveFromObject(unit);
end

function remoteClient.cl_CreateSpawnEffect(unit:object)
	effect_new_on_object_marker(MPAcademyTargetSpawnTags.targetSpawnEffect, unit, "");
end
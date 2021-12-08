-- object proto_quantum_translocator

--## SERVER

-- Copyright (c) Microsoft. All rights reserved.

-- Deploy a device that teleports the player back to the device's location upon the timer reaching 0 or the player's health reaching ~0 (not exact because the player can't actually die)

global g_quantumTranslocator:table = table.makePermanent
{
	activeTime = 10; -- How long from the device becoming active before the player is teleported
	healthThreshold = 0.015; -- Health at or below which we consider the player "dead", has to be > 0 because using object_cannod_die the player never reaches 0 health.
}

hstructure proto_quantum_translocator
	meta:table
	instance:luserdata
	ownerUnit:object;
	isActive:boolean;
end

function proto_quantum_translocator:init() : void
	self.ownerUnit = Object_GetDamageOwnerPlayer(self);

	RegisterEventOnce(g_eventTypes.objectDeletedEvent, [|self:Destroyed()], self);

	CreateObjectThread(self, self.Activate, self);
end

function proto_quantum_translocator:Activate():void
	SleepUntilSeconds([|ObjectGetSpeed(self) <= 0.1], 0.05); -- Wait for device to come to rest

	-- Destroy the device if the player dies after activation but before the device comes to rest
	if not biped_is_alive(self.ownerUnit) then 
		object_destroy(self);
		return;
	end

	object_set_function_variable(self, "isactive", 1); -- Device plays some VFX showing it's active

	RunClientScript("PlayActiveEffect", self.ownerUnit); -- Play the active vfx on the player to communicate they are affected by the device
	RunClientScript("ShowIndicator", self.ownerUnit, true); -- Show the HUD timer

	self.isActive = true; -- Device is now active

	object_cannot_die(self.ownerUnit, true); -- The player can no longer die

	local passedTime:number = 0;

	-- Update the HUD indicator
	while passedTime < g_quantumTranslocator.activeTime and Object_GetHealth(self.ownerUnit) > g_quantumTranslocator.healthThreshold do
		passedTime = passedTime + Game_TimeGetDelta();
		RunClientScript("UpdateIndicator", self.ownerUnit, 1 - (passedTime/g_quantumTranslocator.activeTime));
		Sleep(1);
	end

	self:ReturnToDevice();
end

-- Teleport the player back to the device
function proto_quantum_translocator:ReturnToDevice():void
	
	-- Drop MP objective weapons if the player is holding them. We only care about primary because thats the only slot these can be in.
	local primWeapon:object = Unit_GetPrimaryWeapon(self.ownerUnit);
	if Object_GetDefinition(primWeapon) == TAG('objects\weapons\multiplayer\proto_flag\proto_flag.weapon') or Object_GetDefinition(primWeapon) == TAG('objects\weapons\multiplayer\skull\skull.weapon') then
		Unit_DropWeapon(self.ownerUnit, primWeapon);
	end

	object_cannot_die(self, true); -- we can't allow the device to be destroyed if the player is actively returning

	object_set_function_variable(self, "isreturning", 1); -- tells the device to play a large vfx communicating the player is about to teleport

	self.isActive = false; -- device is no longer active

	local isDeath:boolean = Object_GetHealth(self.ownerUnit) <= g_quantumTranslocator.healthThreshold; -- is this return caused by "death" or the timer

	RunClientScript("KillActiveEffect"); -- Remove the active effect on the player
	RunClientScript("ShowIndicator", self.ownerUnit, false); -- Turn off the HUD timer indicator
	RunClientScript("PlayDeathEffect", self.ownerUnit); -- Play the death effect on the player

	-- If the player isn't "dead", we slow them down to a stop as we go to third rather than doing a direct stop. It looks messy but it feels good.
	if not isDeath then
		
		-- The following damage effects all have different stun values increasing with each one
		HSDamageObjectEffectWithDamageInfo(TAG('objects\equipment\proto\proto_quantum_translocator\components\damage_effect\player_stun.damage_effect'), self.ownerUnit, nil);
		SleepSeconds(0.15);

		HSDamageObjectEffectWithDamageInfo(TAG('objects\equipment\proto\proto_quantum_translocator\components\damage_effect\player_stun_light.damage_effect'), self.ownerUnit, nil);
		SleepSeconds(0.05);

		RunClientScript("GoToThirdPerson", self.ownerUnit); -- Initiate the Cam transition to third
		SleepSeconds(0.1);

		HSDamageObjectEffectWithDamageInfo(TAG('objects\equipment\proto\proto_quantum_translocator\components\damage_effect\player_stun_med.damage_effect'), self.ownerUnit, nil);
		SleepSeconds(0.15);
		
		player_disable_movement(true, self.ownerUnit); -- Fully stop the player's movement
		SleepSeconds(0.45);

	-- The player is "dead" so we full stop them and go to third/teleport quicker, as we have less time to do everything because it's a direct event
	else
		player_disable_movement(true, self.ownerUnit); -- Fully stop the player's movement
		RunClientScript("GoToThirdPerson", self.ownerUnit); -- Initiate the Cam transition to third
		SleepSeconds(0.7);
	end

	object_teleport(self.ownerUnit, location(self, "")); -- Return the player to the device's location

	RunClientScript("PlayRespawnEffect", self.ownerUnit); -- Play the respawn effect on the player
	RunClientScript("ReturnToFirstPerson", self.ownerUnit); -- Return the cam to first

	SleepSeconds(0.6);

	player_disable_movement(false, self.ownerUnit); -- Give control back to the player

	-- If the player returned via the timer, we kick off the shield recharge
	if not isDeath then
		Object_SetShieldStun(self.ownerUnit, 0);
	end

	Object_SetHealth(self.ownerUnit, 1); -- Heal all body damage
	object_cannot_die(self.ownerUnit, false); -- The player can now die

	object_cannot_die(self, false); -- The device can now die
	object_destroy(self); -- Destroy the device
end

-- Called when the device is destroyed via damage
function proto_quantum_translocator:Destroyed():void
	if self.isActive then
		object_cannot_die(self.ownerUnit, false); -- Device is gone, the player can now die
		RunClientScript("ShowIndicator", self.ownerUnit, false); -- Remove the HUD indicator
	end;
end

--## CLIENT

global g_clientQuantumTranslocator = table.makePermanent
{
	uiBarGroup = nil;
	uiBarBackground = nil;
	uiBar = nil;
	activeEffectInstance = nil;
}

-- Play the proper active effect depending on if the player is an ally or enemy
function remoteClient.PlayActiveEffect(playerObj:object):void
	local thisPlayer = unit_get_player(playerObj);

	if Engine_GetPlayerDisposition(Player_GetLocal(0), thisPlayer) == DISPOSITION.Enemy then
		g_clientQuantumTranslocator.activeEffectInstance = effect_new_on_object_marker(TAG('objects\equipment\proto\proto_quantum_translocator\components\fx\proto_quantum_translocator_active_enemy.effect'), playerObj, "fx_root");
	else
		g_clientQuantumTranslocator.activeEffectInstance = effect_new_on_object_marker(TAG('objects\equipment\proto\proto_quantum_translocator\components\fx\proto_quantum_translocator_active.effect'), playerObj, "fx_root");
	end
end

function remoteClient.KillActiveEffect():void
	HSEffectDeleteFromEffect(g_clientQuantumTranslocator.activeEffectInstance);
end

function remoteClient.PlayDeathEffect(playerObj:object):void
	effect_new_on_object_marker(TAG('objects\equipment\proto\proto_quantum_translocator\components\fx\proto_quantum_translocator_death.effect'), playerObj, "fx_root");
end

function remoteClient.PlayRespawnEffect(playerObj:object):void
	effect_new_on_object_marker(TAG('objects\equipment\proto\proto_quantum_translocator\components\fx\proto_quantum_translocator_respawn.effect'), playerObj, "fx_root");
end

-- Creates or destroys the HUD indicator
function remoteClient.ShowIndicator(inPlayerObject:object, on:boolean):void
	local thisPlayer = unit_get_player(inPlayerObject);
	if (PlayerIsLocal(thisPlayer) == false) then	
		return;
	end

	if on then
		g_clientQuantumTranslocator.uiBarGroup = ScriptUI_CreateGroup();
		g_clientQuantumTranslocator.uiBarBackground = ScriptUI_CreateBar();
		ScriptUI_SetParent				 (g_clientQuantumTranslocator.uiBarBackground, g_clientQuantumTranslocator.uiBarGroup);
		ScriptUI_SetSize                 (g_clientQuantumTranslocator.uiBarBackground, .22, .03, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
		ScriptUI_SetPosition             (g_clientQuantumTranslocator.uiBarBackground, .3825, .140, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
		ScriptUI_SetBarBackgroundColor(g_clientQuantumTranslocator.uiBarBackground, 0, 0, 0, 0.5);
		ScriptUI_SetBarForegroundColor(g_clientQuantumTranslocator.uiBarBackground, 0.1, 0.1, 0.1, 1);
		ScriptUI_SetBarCurrentValue      (g_clientQuantumTranslocator.uiBarBackground, 1);

		g_clientQuantumTranslocator.uiBar = ScriptUI_CreateBar();
		ScriptUI_SetParent				 (g_clientQuantumTranslocator.uiBar, g_clientQuantumTranslocator.uiBarGroup);
		ScriptUI_SetSize                 (g_clientQuantumTranslocator.uiBar, .212, .02, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
		ScriptUI_SetPosition             (g_clientQuantumTranslocator.uiBar, .387, .145, SUI_SCALE_TYPE.Relative, SUI_SCALE_TYPE.Relative);
		ScriptUI_SetBarBackgroundColor(g_clientQuantumTranslocator.uiBar, 0, 0, 0, 0.5);
		ScriptUI_SetBarForegroundColor(g_clientQuantumTranslocator.uiBar, 1, 1, 1, 1);
		ScriptUI_SetBarCurrentValue      (g_clientQuantumTranslocator.uiBar, 1);
	elseif g_clientQuantumTranslocator.uiBarGroup ~= nil then
		ScriptUI_Destroy(g_clientQuantumTranslocator.uiBar);
		ScriptUI_Destroy(g_clientQuantumTranslocator.uiBarGroup);
		ScriptUI_Destroy(g_clientQuantumTranslocator.uiBarBackground);

		g_clientQuantumTranslocator.uiBar = nil;
		g_clientQuantumTranslocator.uiBarGroup = nil;
		g_clientQuantumTranslocator.uiBarBackground = nil;
	end
end

-- Updates the HUD timer indicator
function remoteClient.UpdateIndicator(inPlayerObject:object, curTime:number):void
	local thisPlayer = unit_get_player(inPlayerObject);
	if (PlayerIsLocal(thisPlayer) == false) then	
		return;
	end

	ScriptUI_SetBarCurrentValue (g_clientQuantumTranslocator.uiBar, curTime);
end

-- Transitions the camera to third
function remoteClient.GoToThirdPerson(player:player)
	local thisPlayer = unit_get_player(player);
	if (PlayerIsLocal(thisPlayer) == false) then	
		return;
	end
	
	CageInterface.AddPlayerStack(player);

	local cageTag = TAG('objects\equipment\proto\proto_quantum_translocator\components\cage_system\proto_quantum_translocator.cagedefinition');
	local playerCam = CageInterface.GetPlayerCam(player);
	
	local playerObject:object = Player_GetUnit(player);
	
	hud_show(false);

	-- Blend 1: Transfer to the Cage camera and cut to a perspective close to the player's helmet
		-- Create transform and camera properties providers
		local cutTransformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local cutPropertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

		-- Set center/move target
		Cage_TransformSetCenterPoint(cutTransformProvider, cage_point_reference(cageTag, "centerpoint_head", playerObject));
		Cage_TransformAddPositionPointCage(cutTransformProvider, cage_point_reference(cageTag, "from_back_helmet", playerObject));

		-- Cut to back of helmet
		Cage_StackCutTo(playerCam.stack, cutTransformProvider, cutPropertiesProvider);

		-- Switch to Cage Camera
		Cage_SwitchToCageCameraPlayer(player, playerCam.stack);


	-- Blend 2: Move to our 3rd person camera and gaze at the Commander
		-- Create transform and camera properties providers
		local transformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local propertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

		-- Set center/move target
		Cage_TransformSetCenterPoint(transformProvider, cage_point_reference(cageTag, "centerpoint_center", playerObject));
		Cage_TransformAddPositionPointCage(transformProvider, cage_point_reference(cageTag, "third", playerObject));
		
		-- Set unique properties
		Cage_TransformOSNSetRotationOffsetScale(transformProvider, vector(0.25, 0.25, 0.125));
		Cage_TransformSetDampingSpringPositionConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, 1));
		Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseOutSine));
		Cage_TransformSetOrientationLimits(transformProvider, vector(-1,-1, 0), vector(-1,-1, 0));	-- lock roll to prevent odd Cage bug

		-- Blend to over the shoulder camera
		Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, 0.5);
end

-- Returns the camera to first
function remoteClient.ReturnToFirstPerson(player:player)
	local thisPlayer = unit_get_player(player);
	if (PlayerIsLocal(thisPlayer) == false) then	
		return;
	end

	local playerCam = CageInterface.GetPlayerCam(player);
	local playerObject:object = Player_GetUnit(player);
	
	if (playerCam ~= nil) then
		-- Create transform and camera properties providers
		local transformProvider:cage_transform_provider = Cage_TransformCreateCageProvider();
		local propertiesProvider:cage_properties_provider = Cage_PropertiesCreateCameraProvider();

		-- Set center/move target
		Cage_TransformSetCenterPoint(transformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition,"centerpoint_head", playerObject));
		Cage_TransformAddPositionPointCage(transformProvider, cage_point_reference(CageCameraTags.mpIntroCageDefinition, "third", playerObject));

		-- Set unique properties
		Cage_TransformOSNSetRotationOffsetScale(transformProvider, vector(1, 1, 0.5));
		Cage_TransformSetDampingSpringPositionConstant(transformProvider, Cage_CalculateDampingSpringConstant(1, 0.5));
		Cage_TransformSetBlendCurve(transformProvider, curve_wrapper(CURVE_BUILT_IN.EaseInSine));

		-- Set to return to gameplay camera on completion of this blend
		Cage_TransformReturnToGameplayCameraPlayer(transformProvider, player);

		-- Blend to prepare us to go to the helmet (complete rotation and begin movement)
		Cage_StackBlendTo(playerCam.stack, transformProvider, propertiesProvider, 0.5);

		-- Play effect for going into helmet
		if (playerObject ~= nil) then
			effect_new_on_object_marker(CageCameraTags.introToHelmetScreenFX, playerObject, "fx_root");
		end
	end

	SleepSeconds(0.5);

	-- I think we need to do this to cleanup the stack created when going to third? I know very little about the cage system...
	CageInterface.RemovePlayerStack(player);

	-- Return to gameplay camera and show HUD
	Cage_SwitchToGameplayCamera(playerObject);
	SendBroadcastCuiEvent("hud_transition_on_start");	-- This animates the HUD in
	hud_show(true);
	SendHuiEvent("event_hud_player_spawn_start");	-- This is the HUD scan lines
end
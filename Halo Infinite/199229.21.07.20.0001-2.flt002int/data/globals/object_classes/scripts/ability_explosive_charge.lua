-- object ability_explosive_charge

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
hstructure ability_explosive_charge
	meta:table
	instance:luserdata
	ownerPlayer:player
	ownerUnit:object
	playerMPTeam:mp_team
	playerCampaignTeam:team 
	equipmentObject:object
	armed:boolean
	deactivated:boolean
end

global g_demoChargeVariables = table.makePermanent
{
	armingTime = 1.3, -- Goal is to prevent the player from using the bomb as manually-triggered grenade
	displayedArmingTime = 1,
}

function ability_explosive_charge:init() : void
	self.ownerPlayer = Object_GetDamageOwnerPlayer(self);
	self.ownerUnit = Player_GetUnit(Object_GetDamageOwnerPlayer(self));
	local playerMPTeam:mp_team = Player_GetMultiplayerTeam(self.ownerPlayer);
	local playerCampaignTeam:team = Player_GetCampaignTeam(self.ownerPlayer);
	Object_SetMultiplayerTeam(self, playerMPTeam);
	Object_SetCampaignTeam(self, playerCampaignTeam);
	self.equipmentObject = Object_GetSourceEquipment(self)
	self.armed = false;
	self.deactivated = false;
	RegisterEvent(g_eventTypes.equipmentAbilityDeactivateEvent, DemoChargeDeactivated, self.ownerUnit, self.equipmentObject, self);
	RegisterEvent(g_eventTypes.equipmentAbilityControlStateChanged, DemoChargeStateChanged, self.equipmentObject, self, self.equipmentObject);
	RegisterEvent(g_eventTypes.objectDeletedEvent, DemoChargeDestroyed, self, self);
	RegisterEvent(g_eventTypes.deathEvent, DemoChargePlayerKilled, self.ownerUnit, self);
	CreateObjectThread(self, self.CustomInitThread, self);
end

function ability_explosive_charge:CustomInitThread():void
	-- sleep a hot second so you can't blow up in the enemy's face
	SleepUntilSeconds ([| object_get_at_rest(self) ], 0);
	SleepSeconds(g_demoChargeVariables.armingTime)
	RunClientScript("DemoChargeArmedSoundFX", self, self.ownerPlayer)
	self.armed = true;
	local np:navpoint = NavpointBuilder(self.ownerPlayer, self, "fx_root", "ability_explosive_charge", NAVPOINT_BAR.Top, NAVPOINT_DRAW.Always, "oneClient");
	Navpoint_SetPositionOffset( np, vector(0,0,0.15))
end

function DemoChargePlayerKilled(deathEvent, self)
	Object_Detach(self)
	object_destroy(self);

end

function DemoChargeDeactivated(eventData, thisEquipment, self)
	if eventData.equipment == thisEquipment and self.armed == false then
		self.deactivated = true
		Object_Detach(self)
		object_destroy(self);
	end
end

function DemoChargeStateChanged(eventData, self, thisEquipment)
	if (not self.deactivated and self.armed == true and Equipment_AbilityIsActive(thisEquipment) == true) then
		if eventData.equipment == thisEquipment then
			self.deactivated = true;
			-- Can't use the detonation FX of the projectile this script is attached to because that is set to simply "fizzle" when destroyed!
			-- Thus, I'm creating a separate projectile to simply display the VFX of the explosion. In DemoChargeDestroySelf, I create the damage to 
			-- make sure MP modes like dodgeball update the kill counts properly. 
			Engine_CreateObject(TAG('objects\armor\attachments\attachment_abilities\ability_explosive_charge\explosive_charge_detonation.projectile'), location(self, "bomb_light"));
			CreateThread(DemoChargeDestroySelf, self); -- Needed a new thread because state-change callbacks don't allow for any kind of sleeping within their thread(like the 0.01 sec in the DemoChargeDestroySelf function)
		end
	end
end

function DemoChargeDestroySelf(self)
	RunClientScript("DemoChargeDetonatedSoundFX", self, self.ownerPlayer)
	SleepSeconds(0.1) --allows the exploding projectile created time to live and detonate before the following dmg effect destroys that projectile prematurely 
	HSDamageNewAtLocation(TAG('objects\armor\attachments\attachment_abilities\ability_explosive_charge\damage_effects\explosion_charge_unsc_explosion.damage_effect'), location(self, "bomb_light"));
	Object_Detach(self)
	object_destroy(self);
end


function DemoChargeDestroyed (destroyedEvent, self)
	if self.deactivated == false then
		RunClientScript("DemoChargeCountered", self, self.ownerPlayer)
	end
	UnregisterEvent(g_eventTypes.equipmentAbilityControlStateChanged, DemoChargeStateChanged, self.equipmentObject);
	UnregisterEvent(g_eventTypes.equipmentAbilityDeactivateEvent, DemoChargeDeactivated, self.ownerUnit);
	UnregisterEvent(g_eventTypes.objectDeletedEvent, DemoChargeDestroyed, self);
	UnregisterEvent(g_eventTypes.deathEvent, DemoChargePlayerKilled, self.ownerUnit);
end

--## CLIENT

function remoteClient.DemoChargeArmedSoundFX(self, ownerPlayer)
	SendGameEvent(self, "audio_democharge_armed") -- play armed SFX in the world near the device

	if (PlayerIsLocal(ownerPlayer) == true) then	
		SendGameEvent(ownerPlayer, "audio_democharge_armed_owner") -- play armed SFX local to the owner
		Outline_AssignTagToObject(self, TAG('globals\outlines\ability_demo_charge_outline.outlinetypedefinition'));
	end
end

function remoteClient.DemoChargeDetonatedSoundFX(self, ownerPlayer)
	SendGameEvent(self, "audio_democharge_triggered") -- play detonation triggered SFX on the device

	if (PlayerIsLocal(ownerPlayer) == true) then
		SendGameEvent(ownerPlayer, "audio_democharge_activate") -- play triggered SFX local to the owner
	end
end

function remoteClient.DemoChargeCountered(self, ownerPlayer)
	if (PlayerIsLocal(ownerPlayer) == true) then	
		print("Your Demo Charge was destroyed!")
	end
end

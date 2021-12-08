-- object mp_item_slidelocker
--## SERVER
REQUIRES('globals\scripts\global_hstructs.lua');

hstructure mp_item_slidelocker
	meta:table					-- required
	instance:luserdata			-- required (must be first slot after meta to prevent crash)
	components:userdata			-- required (used to reference game objects that make up a kit, and allows you to do KITS.myKitInstance.components:Object_GetName("myComponent")
end

function mp_item_slidelocker:init()
	RegisterGlobalEvent(g_eventTypes.roundStartEvent, function(eventArgs, self) self.HandleRoundStart(eventArgs, self) end, self);
end

function mp_item_slidelocker.HandleRoundStart(eventArgs:RoundStartEventStruct, self):void
	local itemManager:table = _G["MPWeaponManagerInstance"];	-- no particular need for this to be the weapon manager instead of equipment manager, but weapon is most common use case

	if (itemManager ~= nil) then
		itemManager:AddOnSlideLockerGateOpen(self, self.HandleSlideLockerGateOpen);
		itemManager:AddOnSlideLockerGateClose(self, self.HandleSlideLockerGateClose);
	end
end

function mp_item_slidelocker:HandleSlideLockerGateOpen():void
	Object_SetFunctionValue(self.components.gate, "is_enter", 1, 0);
end

function mp_item_slidelocker:HandleSlideLockerGateClose():void
	Object_SetFunctionValue(self.components.gate, "is_enter", 0, 0);
end


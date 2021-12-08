-- object multi_holo_bot

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER

hstructure multi_holo_bot
	meta:table
	instance:luserdata
end

global g_multiHoloBotConst = table.makePermanent
{
	botLifespan = 30; 
}

function multi_holo_bot:init() : void 
	RegisterEvent(g_eventTypes.deathEvent, HoloBotDeathCallback, self);
	if g_suppressionVariables.descopeSuppressionEnabled == true then
		RegisterSuppressionSystemEventsForObject(self);
	end
	CreateObjectThread(self, self.CustomInitThread, self);
end

function multi_holo_bot:CustomInitThread():void
	SleepSeconds(g_multiHoloBotConst.botLifespan)
	HoloBotDeathBoom(self)
	unit_kill(self)
end


function HoloBotDeathCallback (deathEvent):void
	UnregisterEvent(g_eventTypes.deathEvent, HoloBotDeathCallback, deathEvent.deadObject);
	HoloBotDeathBoom(deathEvent.deadObject)
end

function HoloBotDeathBoom (deadObject:object)
	RunClientScript("DeadSpartanBoom", deadObject)
	HSDamageNewAtLocation(TAG('objects\armor\attachments\attachment_abilities\spartan_powerups\powerup_multiholo\damage_effect\holo_bot_detonation.damage_effect'), location(deadObject, "fx_root"));
end

--## CLIENT
function remoteClient.DeadSpartanBoom(deadSpartan)
	effect_new_on_object_marker( TAG('objects\armor\attachments\attachment_abilities\spartan_powerups\powerup_multiholo\fx\hardlight_explosive_detonation.effect'), deadSpartan, "fx_root");
end

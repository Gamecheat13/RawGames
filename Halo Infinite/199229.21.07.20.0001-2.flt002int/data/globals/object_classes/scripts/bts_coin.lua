-- object bts_coin

-- Copyright (c) Microsoft. All rights reserved.

--## SERVER
REQUIRES('globals\scripts\callbacks\GlobalCallbacks.lua');
REQUIRES('globals\scripts\global_hstructs.lua');

hstructure bts_coin
	meta : table
	instance : luserdata
	holdingPlayer : object
	holdingSocket : object
	globalEventManagerParcel: table
	type : string
end

function bts_coin:init()
	self.globalEventManagerParcel = _G["GlobalEventManager"];
end

function bts_coin.OnSelfDestroyed(self)
	--TODO Add respawning event here.
end

--------- EVENT CALLBACK FUNCTIONS --------------------------------------------------------------------------------------------------------

--------- HELPER FUNCTIONS ----------------------------------------------------------------------------------------------------------------

function bts_coin:SetTierType(type:string):void
	self.type = type;
end

function bts_coin:GetTierType(type:string):string
	return self.type;
end


--## CLIENT
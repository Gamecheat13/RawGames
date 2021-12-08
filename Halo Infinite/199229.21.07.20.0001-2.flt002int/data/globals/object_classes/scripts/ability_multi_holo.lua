-- object ability_multi_holo
--## SERVER

hstructure ability_multi_holo
	meta:table
	instance:luserdata
	ownerUnit:object
	ownerPlayer:player
	pointAwardedPlayers:table
	playerMPTeam:mp_team
	playerCampaignTeam:team
end


function ability_multi_holo:init()
	ai_prefer_target(self, true);
	self.pointAwardedPlayers = {};
	self.ownerPlayer = Object_GetDamageOwnerPlayer(self);
	self.ownerUnit = Player_GetUnit(self.ownerPlayer);
	self.playerMPTeam = Player_GetMultiplayerTeam(self.ownerPlayer);
	self.playerCampaignTeam = Player_GetCampaignTeam(self.ownerPlayer);
	Object_SetMultiplayerTeam(self, self.playerMPTeam);
	Object_SetCampaignTeam(self, self.playerCampaignTeam);
	CreateObjectThread(self, self.CustomInitThread, self);
end

function ability_multi_holo:CustomInitThread():void
	local maxBotDelay:number = 1.5;

	SleepSeconds(maxBotDelay)
	Holo_SpawnAtPositionWithLoadout(self.ownerPlayer, location(self, "pedestal"), self)
	SleepSeconds(0.3)
	object_destroy(self)
end


function Holo_SpawnAtPositionWithLoadout (calling_player:player, position:location, self)
	local primary_weapon_tag = Object_GetDefinition(unit_get_primary_weapon( self.ownerUnit ))

	local holoBot:object = AI_SpawnAtPositionWithLoadout(TAG('objects\armor\attachments\attachment_abilities\spartan_powerups\powerup_multiholo\holo_bot\holo_bot.character'), self.ownerPlayer, position, primary_weapon_tag)
	SleepUntilSeconds ([| object_index_valid(holoBot) ], 0);
	AddObjectTimedMalleablePropertyModifier("weapon_damage_scalar", -1, 0, holoBot);
	AddObjectTimedMalleablePropertyModifier("grenade_damage_scalar", -1, 0, holoBot);
	AddObjectTimedMalleablePropertyModifier("melee_damage_scalar", -1, 0, holoBot);
	unit_doesnt_drop_items(holoBot)
end

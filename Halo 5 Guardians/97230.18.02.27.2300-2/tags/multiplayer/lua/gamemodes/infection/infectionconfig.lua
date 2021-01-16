
enableStalkerMedal = true;
disableStandardMultikillMedals = true;
disableStandardKillingSpreeMedals = true;
disableBigGameHunter = true;
disableBulltrue = true;
alwaysPlayNeutralVOForMatchLoss = true;
disableRoundLostVO = true;
local damageTypeRefItem = table.first( KillFeedItemReferenceDamageTypes,
	function(item)
		return item[KillFeedItemReference_dmgSourceIndex] == SwordDamageType;
	end
	);
if damageTypeRefItem ~= nil then
	damageTypeRefItem[KillFeedItemReference_killFeedStringIndex] = "infected";
end
local damageSourceRefItem = table.first( KillFeedItemReferenceDamageSources,
	function(item)
		return item[KillFeedItemReference_dmgSourceIndex] == SwordDamageSource;
	end
	);
if damageSourceRefItem ~= nil then
	damageSourceRefItem[KillFeedItemReference_killFeedStringIndex] = "infected";
end

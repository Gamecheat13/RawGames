
wingmanResponse = onAssistsSinceDeath:Target(PlayersWithFiveAssists):Response(
	 {
		Medal = 'wingman'
	 });
sayonaraResponse = onFallingKill:Target(KillingPlayer):Response(
	{
		Medal = 'sayonara'
	});
airsassinationResponse = onAirAssassination:Target(KillingPlayer):Response(
	{
		Medal = 'airsassination_kill'
	});
assassinationResponse = onAssassination:Target(KillingPlayer):Response(
	{
		Medal = 'assassination_kill',	
		DialogueEvent = function (context)
			return AddDialogueEvent("death_assassination", context.DeadPlayer, context.KillingPlayer)
			end
	});
-- 
if (enableFlagsassinationMedal) then 
	flagsassinationResponse = onFlagAssassination:Target(KillingPlayer):Response(
		{
			Medal = 'flagsassination'
		});
end
rocketKillResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
shotgunKillResponse = onShotgunKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
airborneSnapshotResponse = onAirborneSnapshot:Target(KillingPlayer):Response(
	{
		Medal = 'airborne_snapshot'
	});
snapshotResponse = onSnapshot:Target(KillingPlayer):Response(
	{
		Medal = 'snapshot'
	});
sniperHeadshotKillResponse = onSniperHeadshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'sniper_headshot'
	});	
sniperKillResponse = onSniperKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)	
			end
	});
perfectBRKillResponse = onBattleRifleFourShot:Target(KillingPlayer):Response(
	{
		Medal = 'battle_rifle_perfect_kill'
	});
perfectLightRifleKillResponse = onLightRifleThreeShot:Target(KillingPlayer):Response(
	{
		Medal = 'light_rifle_perfect_kill'
	});
perfectDMRKillResponse = onDMRFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'dmr_perfect_kill'
	});
perfectMagnumKillResponse = onMagnumFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'magnum_perfect_kill'
	});
perfectFlagnumKillResponse = onFlagnumFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'magnum_perfect_kill'
	});
perfectH1MagnumKillResponse = onH1MagnumThreeShot:Target(KillingPlayer):Response(
	{
		Medal = 'h1_magnum_perfect_kill'
	});
perfectCarbineKillResponse = onCarbineSevenShot:Target(KillingPlayer):Response(
	{
		Medal = 'carbine_perfect_kill'
	});
pineappleExpress = onPineappleExpress:Target(KillingPlayer):Response(
	{
		Medal = 'pineapple_express'
	});
stuckResponse = onStuck:Target(KillingPlayer):Response(
	{
		Medal = 'stuck'
	});
headshotKillMedalResponse = onHeadshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'headshot_kill'
	});
grenadeKillResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
			return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
fastballResponse = onGrenadeImpactKill:Target(KillingPlayer):Response(
	{
		Medal = 'fastball',		
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
swordKillResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
hammerKillResponse = onHammerKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
beatdownResponse = onMeleeFromBehind:Target(KillingPlayer):Response(
	{
		Medal = 'beatdown_kill',	
		DialogueEvent = function (context)
				return AddDialogueEvent("melee_attack{melee}", context.DeadPlayer, context.KillingPlayer)	
			end
	});		
meleeKillResponse = onMeleeKill:Target(KillingPlayer):Response(
	{
		Medal = 'melee_kill'
	});
poundTownResponse = onPoundTown:Target(KillingPlayer):Response(
	{
		Medal = 'pound_town'
	});
groundPoundKillResponse = onGenericGroundPoundKill:Target(KillingPlayer):Response(
	{
		Medal = 'ground_pound_kill'
	});
shoulderBashKillResponse = onShoulderBashKill:Target(KillingPlayer):Response(
	{
		Medal = 'shoulder_bash_kill'
	});
hatTrickResponse = onThreeConsecutiveHeadshots:Target(KillingPlayer):Response(
	{
		Medal = 'hat_trick'
	});
if (disableStandardKillingSpreeMedals == nil or not disableStandardKillingSpreeMedals) then
	killingSpreeResponse = onFiveKillsSinceDeath:Target(KillingPlayer):Response(
	 {
		Medal = 'killing_spree'
	 });
	-- 
	killingFrenzyResponse = onTenKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'killing_frenzy'
		});
	-- 
	runningRiotResponse = onFifteenKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'running_riot'
		});
	rampageResponse = onTwentyKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'rampage'
		});
	untouchableResponse = onTwentyFiveKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'untouchable'
		});
	invincibleResponse = onThirtyKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'invincible'
		});
	inconceivableResponse = onThirtyFiveKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'inconceivable'
		});
	--	
	-- 
	unfrigginbelievResponse = onFourtyKillsSinceDeath:Target(KillingPlayer):Response(
		{
			Medal = 'unfriggenbelievable'
		});
end
doubleKillResponse = onTwoKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'double_kill',		
		DialogueEvent = function (context)
				return AddDialogueEvent("player_multi_kill", context.DeadPlayer, context.KillingPlayer)			
			end
	});
tripleKillResponse = onThreeKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'triple_kill'
	});
overkillResponse = onFourKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'overkill'
	});
killtacularResponse = onFiveKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtacular'
	});
killtrocityResponse = onSixKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtrocity'
	});
killimanjaroResponse = onSevenKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killamanjaro'
	});
killtastropheResponse = onEightKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtastrophe'
	});
--	
killpocalypseResponse = onNineKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killpocalypse'
	});
--	
killionaireResponse = onTenKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killionaire'
	});
exterminationResponse = onExtermination:Target(KillingPlayer):Response(
	{
		Medal = 'extermination'
	});
firstStrikeResponse = onFirstKill:Target(KillingPlayer):Response(
	{
		Medal = 'first_strike',
		DialogueEvent = function (context)
				return AddDialogueEvent("first_strike", context.DeadPlayer, context.KillingPlayer)			
			end
	});		
retributionResponse = onRetribution:Target(KillingPlayer):Response(
	{
		Medal = 'retribution'
	});
killFromTheGraveResponse = onKillFromTheGrave:Target(KillingPlayer):Response(
	{
		Medal = 'kill_from_the_grave'
	});
showstopperResponse = onShowStopper:Target(KillingPlayer):Response(
	{
		Medal = 'showstopper'
	});
cliffhangerResponse = onCliffhanger:Target(KillingPlayer):Response(
	{
		Medal = 'cliffhanger'
	});
longshotResponse = onLongshot:Target(KillingPlayer):Response(
	{
		Medal = 'longshot'
	});
rocketMaryResponse = onRocketMary:Target(KillingPlayer):Response(
	{
		Medal = 'rocket_mary'
	});
hailMaryResponse = onHailMary:Target(KillingPlayer):Response(
	{
		Medal = 'hail_mary',		
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)	
			end
	});
sprayAndPrayResponse = onSprayAndPray:Target(KillingPlayer):Response(
	{
		Medal = 'spray_and_pray'
	});
clusterLuckResponse = onClusterLuck:Target(KillingPlayer):Response(
	{
		Medal = 'clusterluck'
	});
bulltrueResponse = onBulltrue:Target(KillingPlayer):Response(
	{
		Medal = 'bulltrue'
	});	
starkillerResponse = onStarkiller:Target(KillingPlayer):Response(
	{
		Medal = 'starkiller'
	});
twoKillsOneShotResponse = onTwoKillsOneShot:Target(KillingPlayer):Response(
	{
		Medal = 'sniperdoubleshot'
	});
distractionResponse = onDistraction:Target(DistractingPlayers):Response(
	{
		Medal = 'distraction'
	});
reversalResponse = onReversal:Target(KillingPlayer):Response(
	{
		Medal = 'reversal'
	});
if(disableBigGameHunter == nil) then
	bigGameHunterResponse = onBigGameHunter:Target(KillingPlayer):Response(
		{
			Medal = 'big_game_hunter'
		});
end
protectorResponse = onShortRangeProtectorKill:Target(KillingPlayer):Response(
	{
		Medal = 'protector'
	});
guardianAngelResponse = onLongRangeProtectorKill:Target(KillingPlayer):Response(
	{
		Medal = 'guardian_angel'
	});
bodyguardResponse = onThreeProtectorSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'bodyguard'
	});
lastshotResponse = onEnemyPlayerKillWithLastBullet:Target(KillingPlayer):Response(
	{
		Medal = 'lastshot'
	});
noobComboResponse = onNoobCombo:Target(KillingPlayer):Response(
	{
		Medal = 'noob_combo'
	});
bxrResponse = onBxrKill:Target(KillingPlayer):Response(
	{
		Medal = 'bxr'
	});
nadeshotResponse = onNadeshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'nadeshot'
	});
quickdrawResponse = onQuickdraw:Target(KillingPlayer):Response(
	{
		Medal = 'quickdraw'
	});
brawlerResponse = onBrawlerKill:Target(KillingPlayer):Response(
	{
		Medal = 'brawler'
	});
gunpunchResponse = onGunpunchKill:Target(KillingPlayer):Response(
	{
		Medal = 'gunpunch'
	});
snipunchResponse = onSnipunchKill:Target(KillingPlayer):Response(
	{	
		Medal = 'snipunch'
	});
if (disableTeamTakedownMedal == nil) then
	teamTakedownResponse = onTeamTakedown:Target(KillingPlayer):Response(
		{
			Medal = 'team_takedown'
		});
end
onTripleDouble = onEnemyPlayerKill:Target(FindNewPlayersWithTripleDouble):Response(
	{	
		Medal = 'triple_double'
	});
bustedResponse = onBusted:Target(KillingPlayer):Response(
	{
		Medal = 'busted'
	});
splatterResponse = onGenericSplatter:Target(KillingPlayer):Response(
	{	
		Medal = 'splatter_kill'
	});
roadTripResponse = onRoadTrip:Target(MatchingPlayers):Response(
	{
		Medal = 'road_trip'
	});
buckleUpResponse = onBuckleUp:Target(KillingPlayer):Response(
	{
		Medal = 'buckle_up'
	});
--	
poundTownAssistResponse = onPoundTownAssist:Target(FindPoundTownAssistPlayers):Response(
{
	Medal = 'pound_town_assist'
});
genericKillResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
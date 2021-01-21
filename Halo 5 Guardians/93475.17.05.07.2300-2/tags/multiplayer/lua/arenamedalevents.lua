-- 
onPlayerActivatedFriendlyResponse = onPlayerActivated:Filter(
	function (context)
		return context.TargetPlayer.IsJoiningInProgress and context.TargetPlayer:IsJoiningInProgress();
	end
	):Target(FriendlyToTargetPlayer):Response(
	{	
		Sound = 'multiplayer\audio\announcer\announcer_shared_teammatejoined'
	});
betrayalResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayal',
	});
arenaBetrayalEffectResponse = onFriendlyPlayerKill:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayaleffectplayer'
	});
suicideResponse = onPlayerSuicide:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_suicide'
	});	
wingmanResponse:OverlayResponse(
	 {
		Sound = 'multiplayer\audio\announcer\announcer_shared_wingman'
	 });
sayonaraResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_assistedsuicide'
	});
airsassinationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killairsassination'
	});
assassinationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killassassination'		
	});
if (enableFlagsassinationMedal) then
	flagsassinationResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_ctf_flagflagkillassassination'
		});
end
airborneSnapshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillairbornesnapshot'
	});
snapshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillsnapshot'
	});
perfectBRKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
perfectLightRifleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
perfectDMRKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
perfectMagnumKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
perfectFlagnumKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
perfectCarbineKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
hatTrickResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killhattrick'
	});
if (disableStandardKillingSpreeMedals == nil) or not disableStandardKillingSpreeMedals then
	killingSpreeResponse:OverlayResponse(
	 {
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree05killingspree'
	 });
	-- 
	killingFrenzyResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree10killingfrenzy'
		});
	-- 
	runningRiotResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree15runningriot'
		});	
	rampageResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree20rampage'
		});
	untouchableResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree25untouchable'
		});
	invincibleResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree30invincible'
		});
	inconceivableResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree35inconceivable'
		});
	--	
	-- 
	unfrigginbelievResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_killspree40unfriggenbelieveable'
		});
end
doubleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill02doublekill'		
	});
tripleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill03triplekill'
	});
overkillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill04overkill'
	});
killtacularResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill05killtacular'
	});
killtrocityResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill06killtrocity'
	});
killimanjaroResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill07killamanjaro'
	});
killtastropheResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill08killtastrophe'
	});
--	
killpocalypseResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill09killpocalypse'
	});
--	
killionaireResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill10killionaire'
	});
exterminationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killextermination'
	});
firstStrikeResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfirststrike'				
	});		
retributionResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_retribution'
	});
killFromTheGraveResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfromthegrave'
	});
showstopperResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killshowstopper'
	});
longshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot'
	});
rocketMaryResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_rocketlongrange'
	});
hailMaryResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadelongrangekill'
	});
sprayAndPrayResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_longshotautomatic'
	});
clusterLuckResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadedouble'
	});
bulltrueResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_bulltrue'
	});	
twoKillsOneShotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_snipeltaneous'
	});
distractionResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_distraction'
	});
-- 
hardTargetResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_rechargespreehardtarget'
	});
reversalResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_comebackkill'
	});
if (disableBigGameHunter == nil) then
	bigGameHunterResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_biggamehunterkill'
		});
end
bodyguardResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_protectorspree'
	});
lastshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killlastbulletlast'
	});
bxrResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_bxrkill'
	});
nadeshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_nadeshot'
	});
brawlerResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_brawler'
	});
gunpunchResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gunpunchmeleekill'
	});
noobComboResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_noobcombokill'
	});
flyingHighResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehicleflyinhigh'
	});
roadTripResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehicleroadtrip'
	});
bustedResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehiclebusted'
	});
buckleUpResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehiclesnipeddriver'
	});
if (disableTeamTakedownMedal == nil) then
	teamTakedownResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_kill3assists'
		});
end

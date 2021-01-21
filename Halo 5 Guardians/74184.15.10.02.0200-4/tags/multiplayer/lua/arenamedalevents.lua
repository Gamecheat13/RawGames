-- 
-- Arena-Only Medal Responses (Announcer)
--

--
-- Player Activated
--

onPlayerActivatedFriendlyResponse = onPlayerActivated:Filter(
	function (context)
		-- $TODO [milltin: 2015/7/28]
		-- Checking for IsJoiningInProgress here because that's not integrated into Main yet.
		-- Remove that check when it gets integrated.
		return context.TargetPlayer.IsJoiningInProgress and context.TargetPlayer:IsJoiningInProgress();
	end
	):Target(FriendlyToTargetPlayer):Response(
	{	
		Sound = 'multiplayer\audio\announcer\announcer_shared_teammatejoined'
	});

--
-- Betrayal 
--
-- announcer
betrayalResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayal',
	});
	
arenaBetrayalEffectResponse = onFriendlyPlayerKill:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayaleffectplayer'
	});

--
-- Suicide 
--

suicideResponse = onPlayerSuicide:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_suicide'
	});	

--
-- Wingman Medal
--

wingmanResponse:OverlayResponse(
	 {
		Sound = 'multiplayer\audio\announcer\announcer_shared_wingman'
	 });

--
-- Sayonara - falling kill
--

sayonaraResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_assistedsuicide'
	});

--
-- Animated air assassination kill.
--

airsassinationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killairsassination'
	});

--
-- Animated assassination kill.
--

assassinationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killassassination'		
	});

--
-- Flagsassination Kill
--
if (enableFlagsassinationMedal) then

	flagsassinationResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_ctf_flagflagkillassassination'
		});
end

--
-- Airborne Snapshot
--

airborneSnapshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillairbornesnapshot'
	});
	
--
-- Snapshot 
--

snapshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillsnapshot'
	});

--
-- Perfect Kill Medal
--

perfectBRKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});
	
--
-- Light Rifle Perfect Kill Medal
--

perfectLightRifleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});

--
-- DMR Perfect Kill Medal
--

perfectDMRKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});

--
-- Magnum Perfect Kill Medal
--

perfectMagnumKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});

--
-- Flagnum Perfect Kill Medal
--

perfectFlagnumKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});

--
-- Carbine Perfect Kill Medal
--

perfectCarbineKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill'
	});

--
-- Hat Trick Medal
--

hatTrickResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killhattrick'
	});

--
-- Killing Spree Medal

killingSpreeResponse:OverlayResponse(
 {
	Sound = 'multiplayer\audio\announcer\announcer_shared_killspree05killingspree'
 });

-- 
-- Killing Frenzy Medal
--

killingFrenzyResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree10killingfrenzy'
	});

-- 
-- Running Riot Medal
--

runningRiotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree15runningriot'
	});	

--
-- Rampage Medal 
--

rampageResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree20rampage'
	});

--
-- Untouchable Medal
--

untouchableResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree25untouchable'
	});

--
-- Invincible Medal
--

invincibleResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree30invincible'
	});

--
-- Inconceivable Medal
--

inconceivableResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree35inconceivable'
	});

--	
-- Unfriggenbelievable Medal
-- 

unfrigginbelievResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree40unfriggenbelieveable'
	});
	
--
-- Double Kill Medal 
--

doubleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill02doublekill'		
	});

--
-- Triple Kill Medal 
--

tripleKillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill03triplekill'
	});
	
--
-- Overkill Medal 
--

overkillResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill04overkill'
	});
	
--
-- Killtacular Medal 
--

killtacularResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill05killtacular'
	});

--
-- Killtrocity Medal 
--

killtrocityResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill06killtrocity'
	});

--
-- Killimanjaro Medal 
--

killimanjaroResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill07killamanjaro'
	});

--
-- Killtastrophe Medal 
--

killtastropheResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill08killtastrophe'
	});

--	
-- Killpocalypse Medal 
--

killpocalypseResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill09killpocalypse'
	});

--	
-- Killionaire Medal 
--

killionaireResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill10killionaire'
	});
	
--
-- Extermination Medal
--

exterminationResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killextermination'
	});

--
-- First strike
--

firstStrikeResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfirststrike'				
	});		

--
-- Retribution (assassinate the last person to kill you)
--
	
retributionResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_retribution'
	});

--
-- From the grave (killed player while dead, not in same tick).
--
	
killFromTheGraveResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfromthegrave'
	});

--
-- Showstopper
--
	
showstopperResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killshowstopper'
	});
	
--
-- Longshot
--

longshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot'
	});
		
--
-- Rocket Mary
--

rocketMaryResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_rocketlongrange'
	});
	
--
-- Hail Mary
--
	
hailMaryResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadelongrangekill'
	});
	
--
-- Spray and Pray - Assault Rifle
--

sprayAndPrayResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_longshotautomatic'
	});

--
-- Cluster Luck
--
	
clusterLuckResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadedouble'
	});
	
--
-- Bulltrue
--

bulltrueResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_bulltrue'
	});	

--
-- Snipeltaneous!
--
	
twoKillsOneShotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_snipeltaneous'
	});
	
--
-- Distraction Medal
--

distractionResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_distraction'
	});

--
-- Hard Target (10 shields recharged since death)
-- 

hardTargetResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_rechargespreehardtarget'
	});

--
-- Reversal Kill
--

reversalResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_comebackkill'
	});

--
-- Big Game Hunter
--

bigGameHunterResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_biggamehunterkill'
	});

--
-- Bodyguard
--

bodyguardResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_protectorspree'
	});

--
-- Lastshot
--

lastshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killlastbulletlast'
	});

--
-- BXR
--

bxrResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_bxrkill'
	});

--
-- Nadeshot
--

nadeshotResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_nadeshot'
	});

--
-- Brawler
--

brawlerResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_brawler'
	});

--
-- Gunpunch
--

gunpunchResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gunpunchmeleekill'
	});

--
-- Noob Combo
--

noobComboResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_noobcombokill'
	});

--
-- Flyin High
--

flyingHighResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehicleflyinhigh'
	});

--
-- Road Trip
--

roadTripResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehicleroadtrip'
	});

--
-- Busted
--

bustedResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehiclebusted'
	});

--
-- Buckle Up
--

buckleUpResponse:OverlayResponse(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_vehiclesnipeddriver'
	});

--
-- Team Takedown
--
if (disableTeamTakedownMedal == nil) then
	teamTakedownResponse:OverlayResponse(
		{
			Sound = 'multiplayer\audio\announcer\announcer_shared_kill3assists'
		});
end

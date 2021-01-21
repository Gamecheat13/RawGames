-- 
-- Default Medal Events
--

--
-- Kill Feed ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

function IsPerfectKill(context)
	return PlayerHasFullBodyAndShieldMaxVitality(context.DeadPlayer)
		and (BattleRiflePerfectKill(context) 
			or LightRiflePerfectKill(context) 
			or DMRPerfectKill(context) 
			or MagnumPerfectKill(context) 
			or CarbinePerfectKill(context) 
			or FlagnumPerfectKill(context));
end


--
-- Generic Kill Feed Functions
--

function GetDamageSourceRef(context)

	-- check for assassination
	if context.DamageReportingModifier ~= nil and context.DamageReportingModifier == DamageReportingModifier.Assassination then
		return "assassination";
	end

	-- check for splatter
	if context.DamageType == CollisionDamageType and context.KillingPlayerUnit ~= nil and context.KillingPlayerUnit:IsDrivingVehicle() then
		return "splatter";
	end

	-- check for damage types
	if context.DamageType ~= nil then
		local damageSourceRefItem = table.first( KillFeedItemReferenceDamageTypes,
			function(item)
				return item[KillFeedItemReference_sourceIndex] == context.DamageType;
			end
			);

		if damageSourceRefItem ~= nil then
			return damageSourceRefItem[KillFeedItemReference_refIndex];
		end
	end

	-- check for damage sources
	if context.DamageSource ~= nil then

		local damageSourceRefItem = table.first( KillFeedItemReferenceDamageSources,
			function(item)
				return item[KillFeedItemReference_sourceIndex] == context.DamageSource;
			end
			);
		
		-- killed by a valid damage source
		if damageSourceRefItem ~= nil then
			local damageSourceRef = damageSourceRefItem[KillFeedItemReference_refIndex];

			-- check if perfect or a headshot
			if context.DamageReportingModifier ~= nil and context.DamageReportingModifier == DamageReportingModifier.Headshot then
				if IsPerfectKill(context) then
					damageSourceRef = damageSourceRef .. "_perfect";
				else
					damageSourceRef = damageSourceRef .. "_headshot";
				end
			end

			return damageSourceRef;
		end
	end
	
	LogError("Damage Source reference not found.");
	return "generic";
end

function GenericKillFeedKillPlayer(context)	
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_killplayer', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedKillTeam(context)	
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_killteam', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedKillTeamAssist(context)	
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_killteam_assist', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedDeadPlayer(context)	
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_deadplayer', context.KillingPlayer, context.DeadPlayer);
end
	
function GenericKillFeedDeadTeam(context)
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_deadteam', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedKillPlayerBetrayal(context)
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_killplayer_betrayal', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedDeadPlayerBetrayal(context)
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_deadplayer_betrayal', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedKillTeamBetrayal(context)
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_killteam_betrayal', context.KillingPlayer, context.DeadPlayer);
end

function GenericKillFeedOtherTeamBetrayal(context)
	return FormatText('score_fanfare_killfeed_' .. GetDamageSourceRef(context) .. '_otherteam_betrayal', context.KillingPlayer, context.DeadPlayer);
end

function KillFeedKillPlayerSuicide(context)
	return FormatText('score_fanfare_killfeed_killplayer_suicide', context.KillingPlayer);
end

function KillFeedKillTeamSuicide(context)
	return FormatText('score_fanfare_killfeed_killteam_suicide', context.KillingPlayer);
end

function KillFeedOtherTeamSuicide(context)
	return FormatText('score_fanfare_killfeed_otherteam_suicide', context.KillingPlayer);
end

function AddDialogueEvent(eventString, subjectPlayer, causePlayer)	
	dialogueEvent = 
	{
		EventStringId = ResolveString(eventString)
	};
			
	if subjectPlayer ~= nil then
		dialogueEvent["SubjectUnit"] = subjectPlayer:GetUnit();
	end
			
	if causePlayer ~= nil then
		dialogueEvent["CauseUnit"] = causePlayer:GetUnit();
	end
			
	return dialogueEvent;
end

--
-- Kill Feed Responses
--

genericKillFeedKillPlayerResponse = onEnemyPlayerKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer,
		DialogueEvent = function(context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
	
genericKillFeedKillTeamResponse = onEnemyPlayerKill:Target(FriendlyToKillingPlayerAndNotAssisting):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});
	
genericKillFeedKillTeamAssistResponse = onEnemyPlayerKill:Target(FriendlyToKillingPlayerAssist):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeamAssist
	});

genericKillFeedDeadPlayerResponse = onEnemyPlayerKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
genericKillFeedDeadTeamResponse = onEnemyPlayerKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});

genericKillFeedFFAOtherTeamResponse = onEnemyPlayerKill:Target(HostileToKillingAndDeadPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedOtherTeamBetrayal
	});

--
-- Betrayal Kill Feed
--

genericKillFeedKillingPlayerBetrayalResposne = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayerBetrayal
	});

genericKillFeedDeadPlayerBetrayalResposne = onFriendlyPlayerKill:Target(DeadPlayer):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayerBetrayal
	});

genericKillFeedKillTeamBetrayalResposne = onFriendlyPlayerKill:Target(FriendlyToKillingPlayerNotInvolved):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeamBetrayal
	});

genericKillFeedOtherTeamBetrayalResposne = onFriendlyPlayerKill:Target(HostileToKillingPlayer):Response(
	{	
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedOtherTeamBetrayal
	});

--
-- Suicide Kill Feed
--

genericKillFeedKillPlayerSuicideResponse = onPlayerSuicide:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = KillFeedKillPlayerSuicide
	});

genericKillFeedKillTeamSuicideResponse = onPlayerSuicide:Target(FriendlyToKillingPlayerNotInvolved):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = KillFeedKillTeamSuicide
	});

genericKillFeedOtherTeamSuicideResponse = onPlayerSuicide:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = KillFeedOtherTeamSuicide
	});

--
-- Generic Impulses for Stat Tracking
--

killImpulse = onEnemyPlayerKill:Target(KillingPlayer):Response(
	{
		PlatformImpulse = 'SpartanKill'
	});

assistImpulse = onEnemyPlayerKill:Target(AssistingPlayers):Response(
	{
		PlatformImpulse = 'SpartanAssist'		
	});

deathImpulse = onPlayerDeath:Target(DeadPlayer):Response(
	{
		PlatformImpulse = 'SpartanDeath'
	});

genericProtectorImpulse = onProtectorKill:Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'impulse_protected_player'
	});

genericPerfectKillImpulse = onEnemyPlayerKill:Filter(IsPerfectKill):Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'impulse_perfect_kill'
	});

suicideImpulse = onPlayerSuicide:Target(DeadPlayer):Response(
	{
		ImpulseEvent = 'impulse_suicide'
	});

--
-- Kill Sound Effect Response
--

onNonHeadshotNonMeleeKill = onEnemyPlayerKill:Filter(
	function (context)
		return (context.DamageReportingModifier ~= DamageReportingModifier.Headshot) 
		and (context.DamageReportingModifier ~= DamageReportingModifier.Assassination)
		and (context.DamageReportingModifier ~= DamageReportingModifier.SilentMelee)
		and (context.DamageType ~= meleeDamageType);
	end
	);

nonHeadshotNonMeleeKillSoundEffectResponse = onNonHeadshotNonMeleeKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_generickill',
	});

--
-- Assist
--

assistSoundResposne = onPlayerAssist:Target(AssistingPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_generickill'
	});

--
-- Headshot
--

headshotKillMedalResponse = onHeadshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'headshot_kill'
	});

--
-- Headshot Sound Effect Response
--

onAllHeadshotKill = onEnemyPlayerKill:Filter(
	function (context)
		return context.DamageReportingModifier == DamageReportingModifier.Headshot;
	end
	);

anyHeadshotKillSoundEffectResponse = onAllHeadshotKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_headshotkill',
		DialogueEvent = function(context)
				return AddDialogueEvent("death_headshot{damage_headshot}", context.DeadPlayer, context.KillingPlayer)		
			end
	});
--
-- Betrayal  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

betrayalCauseResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function(context)
				return AddDialogueEvent("betray", context.DeadPlayer, context.KillingPlayer)
			end
	});

--
-- Suicide  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

suicideFeedKillPlayerResponse = onPlayerSuicide:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_suicide_killplayer');
		end
	});
	
suicideFeedKillTeamResponse = onPlayerSuicide:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_suicide_killteam', context.KillingPlayer);
		end
	});	

suicideChatterResponse = onPlayerSuicide:Target(KillingPlayer):Response(
		{
		DialogueEvent = function(context)
				return AddDialogueEvent("suicide", context.DeadPlayer, nil)
			end
		});
--
-- Assists ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
if (disableTeamTakedownMedal == nil) then
	teamTakedownAssistResponse = onTeamTakedownAssist:Target(AssistingPlayers):Response(
		{
			Medal = 'team_takedown_assist'
		});
end

poundTownAssistResponse = onPoundTownAssist:Target(FindPoundTownAssistPlayers):Response(
	{
		Medal = 'pound_town_assist'
	});

empAssistResponse = onEmpAssist:Target(FindEmpAssistPlayers):Response(
	{
		Medal = 'emp_assist'
	});

assistDialogueResponse = onPlayerAssist:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
			local firstCausePlayer = table.first(context.AssistingPlayers);

				return AddDialogueEvent("death_assist", context.KillingPlayer, firstCausePlayer)
			end				
	});	

--
-- Medals  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

--
-- Wheelman
--

wheelmanResponse = onEnemyPlayerKill:Target(FindWheelman):Response(
	{
		Medal = 'wheelman'
	});

--
-- Wingman Medal
--

wingmanResponse = onAssistsSinceDeath:Target(PlayersWithFiveAssists):Response(
	 {
		Medal = 'wingman'
	 });

--
-- Sayonara - falling kill
--

sayonaraResponse = onFallingKill:Target(KillingPlayer):Response(
	{
		Medal = 'sayonara'
	});

--
-- Animated air assassination kill.
--

airsassinationResponse = onAirAssassination:Target(KillingPlayer):Response(
	{
		Medal = 'airsassination_kill'
	});
	
--
-- Animated assassination kill.
--

assassinationResponse = onAssassination:Target(KillingPlayer):Response(
	{
		Medal = 'assassination_kill',	
		DialogueEvent = function (context)
			return AddDialogueEvent("death_assassination", context.DeadPlayer, context.KillingPlayer)
			end
				
	});

--
-- Flagsassination
-- 

if (enableFlagsassinationMedal) then 

	flagsassinationResponse = onFlagAssassination:Target(KillingPlayer):Response(
		{
			Medal = 'flagsassination'
		});
end

--
-- Rocket launcher kill
--

rocketKillResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end

	});

--
-- Shotgun kill
--

shotgunKillResponse = onShotgunKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
			
	});
	
--
-- Airborne Snapshot
--

airborneSnapshotResponse = onAirborneSnapshot:Target(KillingPlayer):Response(
	{
		Medal = 'airborne_snapshot'
	});
	
--
-- Snapshot 
--

snapshotResponse = onSnapshot:Target(KillingPlayer):Response(
	{
		Medal = 'snapshot'
	});

--
-- Sniper Headshot
--

sniperHeadshotKillResponse = onSniperHeadshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'sniper_headshot'
	});	
	
--
-- Sniper kill
--

sniperKillResponse = onSniperKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)	
			end
	});

--
-- Perfect Kill Medal
--

perfectBRKillResponse = onBattleRifleFourShot:Target(KillingPlayer):Response(
	{
		Medal = 'battle_rifle_perfect_kill'
	});

--
-- Light Rifle Perfect Kill Medal
--

perfectLightRifleKillResponse = onLightRifleThreeShot:Target(KillingPlayer):Response(
	{
		Medal = 'light_rifle_perfect_kill'
	});

--
-- DMR Perfect Kill Medal
--

perfectDMRKillResponse = onDMRFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'dmr_perfect_kill'
	});

--
-- Magnum Perfect Kill Medal
--

perfectMagnumKillResponse = onMagnumFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'magnum_perfect_kill'
	});

--
-- Flagnum Perfect Kill Medal
--

perfectFlagnumKillResponse = onFlagnumFiveShot:Target(KillingPlayer):Response(
	{
		Medal = 'magnum_perfect_kill'
	});

--
-- Carbine Perfect Kill Medal
--

perfectCarbineKillResponse = onCarbineSevenShot:Target(KillingPlayer):Response(
	{
		Medal = 'carbine_perfect_kill'
	});

--
-- Pineapple Express
--

pineappleExpress = onPineappleExpress:Target(KillingPlayer):Response(
	{
		Medal = 'pineapple_express'
	});

--
-- Stuck
--

stuckResponse = onStuck:Target(KillingPlayer):Response(
	{
		Medal = 'stuck'
	});

--
-- Grenade kill
--

grenadeKillResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
			return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	
	});

--
-- Grenade Impact Kill
--

fastballResponse = onGrenadeImpactKill:Target(KillingPlayer):Response(
	{
		Medal = 'fastball',		
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});
	
--
-- Sword kill
--

swordKillResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});

--
-- Beat down (melee attack from behind)
--

beatdownResponse = onMeleeFromBehind:Target(KillingPlayer):Response(
	{
		Medal = 'beatdown_kill',	
		DialogueEvent = function (context)
				return AddDialogueEvent("melee_attack{melee}", context.DeadPlayer, context.KillingPlayer)	
			end
	});		

--
-- Melee kill
--

meleeKillResponse = onMeleeKill:Target(KillingPlayer):Response(
	{
		Medal = 'melee_kill'
	});

--
-- Ground pound Kill
--

poundTownResponse = onPoundTown:Target(KillingPlayer):Response(
	{
		Medal = 'pound_town'
	});

groundPoundKillResponse = onGenericGroundPoundKill:Target(KillingPlayer):Response(
	{
		Medal = 'ground_pound_kill'
	});

--
-- Shoulder Bash Kill
--

shoulderBashKillResponse = onShoulderBashKill:Target(KillingPlayer):Response(
	{
		Medal = 'shoulder_bash_kill'
	});

--
-- Generic kill
--

genericKillResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)
			end
	});

--
-- Hat Trick Medal
--

hatTrickResponse = onThreeConsecutiveHeadshots:Target(KillingPlayer):Response(
	{
		Medal = 'hat_trick'
	});

--
-- Killing Spree Medal
--

killingSpreeResponse = onFiveKillsSinceDeath:Target(KillingPlayer):Response(
 {
	Medal = 'killing_spree'
 });

-- 
-- Killing Frenzy Medal
--

killingFrenzyResponse = onTenKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'killing_frenzy'
	});

-- 
-- Running Riot Medal
--

runningRiotResponse = onFifteenKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'running_riot'
	});

--
-- Rampage Medal 
--

rampageResponse = onTwentyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'rampage'
	});
	
--
-- Untouchable Medal
--

untouchableResponse = onTwentyFiveKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'untouchable'
	});

--
-- Invincible Medal
--

invincibleResponse = onThirtyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'invincible'
	});
	
--
-- Inconceivable Medal
--

inconceivableResponse = onThirtyFiveKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'inconceivable'
	});

--	
-- Unfriggenbelievable Medal
-- 

unfrigginbelievResponse = onFourtyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'unfriggenbelievable'
	});
	
--
-- Double Kill Medal 
--

doubleKillResponse = onTwoKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'double_kill',		
		DialogueEvent = function (context)
				return AddDialogueEvent("player_multi_kill", context.DeadPlayer, context.KillingPlayer)			
			end
	});

--
-- Triple Kill Medal 
--

tripleKillResponse = onThreeKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'triple_kill'
	});
	
--
-- Overkill Medal 
--

overkillResponse = onFourKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'overkill'
	});
	
--
-- Killtacular Medal 
--

killtacularResponse = onFiveKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtacular'
	});

--
-- Killtrocity Medal 
--

killtrocityResponse = onSixKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtrocity'
	});

--
-- Killimanjaro Medal 

killimanjaroResponse = onSevenKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killamanjaro'
	});

--
-- Killtastrophe Medal 
--

killtastropheResponse = onEightKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killtastrophe'
	});

--	
-- Killpocalypse Medal 
--

killpocalypseResponse = onNineKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killpocalypse'
	});

--	
-- Killionaire Medal 
--

killionaireResponse = onTenKillsInARow:Target(KillingPlayer):Response(
	{
		Medal = 'killionaire'
	});
	
--
-- Extermination Medal
--

exterminationResponse = onExtermination:Target(KillingPlayer):Response(
	{
		Medal = 'extermination'
	});

--
-- First strike
--

firstStrikeResponse = onFirstKill:Target(KillingPlayer):Response(
	{
		Medal = 'first_strike',
		DialogueEvent = function (context)
				return AddDialogueEvent("first_strike", context.DeadPlayer, context.KillingPlayer)			
			end
		
	});		

--
-- Retribution (assassinate the last person to kill you)
--
	
retributionResponse = onRetribution:Target(KillingPlayer):Response(
	{
		Medal = 'retribution'
	});

--
-- From the grave (killed player while dead, not in same tick).
--
	
killFromTheGraveResponse = onKillFromTheGrave:Target(KillingPlayer):Response(
	{
		Medal = 'kill_from_the_grave'
	});

--
-- Showstopper
--
	
showstopperResponse = onShowStopper:Target(KillingPlayer):Response(
	{
		Medal = 'showstopper'
	});
	
--
-- Cliffhanger
--
	
cliffhangerResponse = onCliffhanger:Target(KillingPlayer):Response(
	{
		Medal = 'cliffhanger'
	});
	
--
-- Longshot
--

longshotResponse = onLongshot:Target(KillingPlayer):Response(
	{
		Medal = 'longshot'
	});

--
-- Rocket Mary
--

rocketMaryResponse = onRocketMary:Target(KillingPlayer):Response(
	{
		Medal = 'rocket_mary'
	});
	
--
-- Hail Mary
--
	
hailMaryResponse = onHailMary:Target(KillingPlayer):Response(
	{
		Medal = 'hail_mary',		
		DialogueEvent = function (context)
				return AddDialogueEvent("death", context.DeadPlayer, context.KillingPlayer)	
			end
	});

-- Spray and Pray - Assault Rifle
--

sprayAndPrayResponse = onSprayAndPray:Target(KillingPlayer):Response(
	{
		Medal = 'spray_and_pray'
	});
	
--
-- Cluster Luck
--
	
clusterLuckResponse = onClusterLuck:Target(KillingPlayer):Response(
	{
		Medal = 'clusterluck'
	});
	
--
-- Bulltrue
--

bulltrueResponse = onBulltrue:Target(KillingPlayer):Response(
	{
		Medal = 'bulltrue'
	});	

--
-- Starkiller
--

starkillerResponse = onStarkiller:Target(KillingPlayer):Response(
	{
		Medal = 'starkiller'
	});

--
-- Snipeltaneous!
--
	
twoKillsOneShotResponse = onTwoKillsOneShot:Target(KillingPlayer):Response(
	{
		Medal = 'sniperdoubleshot'
	});
	
--
-- Distraction Medal
--

distractionResponse = onDistraction:Target(DistractingPlayers):Response(
	{
		Medal = 'distraction'
	});

--
-- Close Call
--

closeCallResponse = onCloseCall:Target(TargetPlayer):Response(
	{
		Medal = 'close_call'
	});

--
-- Hard Target (10 shields recharged since death)
-- 

hardTargetResponse = onTenShieldsRechargedSinceDeath:Target(TargetPlayer):Response(
	{
		Medal = 'hard_target'
	});

--
-- Reversal Kill
--

reversalResponse = onReversal:Target(KillingPlayer):Response(
	{
		Medal = 'reversal'
	});

--
-- Big Game Hunter
--

bigGameHunterResponse = onBigGameHunter:Target(KillingPlayer):Response(
	{
		Medal = 'big_game_hunter'
	});

--
-- Protector
--

protectorResponse = onShortRangeProtectorKill:Target(KillingPlayer):Response(
	{
		Medal = 'protector'
	});

--
-- Guardian Angel (long range protector)
--

guardianAngelResponse = onLongRangeProtectorKill:Target(KillingPlayer):Response(
	{
		Medal = 'guardian_angel'
	});

--
-- Bodyguard
--

bodyguardResponse = onThreeProtectorSinceDeath:Target(KillingPlayer):Response(
	{
		Medal = 'bodyguard'
	});

--
-- Lastshot
--

lastshotResponse = onEnemyPlayerKillWithLastBullet:Target(KillingPlayer):Response(
	{
		Medal = 'lastshot'
	});

--
-- Noob Combo
--

noobComboResponse = onNoobCombo:Target(KillingPlayer):Response(
	{
		Medal = 'noob_combo'
	});

--
-- BXR
--

bxrResponse = onBxrKill:Target(KillingPlayer):Response(
	{
		Medal = 'bxr'
	});

--
-- Nadeshot
--

nadeshotResponse = onNadeshotKill:Target(KillingPlayer):Response(
	{
		Medal = 'nadeshot'
	});

--
-- Quickdraw
--

quickdrawResponse = onQuickdraw:Target(KillingPlayer):Response(
	{
		Medal = 'quickdraw'
	});

--
-- Brawler
--

brawlerResponse = onBrawlerKill:Target(KillingPlayer):Response(
	{
		Medal = 'brawler'
	});

--
-- Gunpunch
--

gunpunchResponse = onGunpunchKill:Target(KillingPlayer):Response(
	{
		Medal = 'gunpunch'
	});

--
-- Snipunch
--

snipunchResponse = onSnipunchKill:Target(KillingPlayer):Response(
	{	
		Medal = 'snipunch'
	});

--
-- Team Takedown
--
if (disableTeamTakedownMedal == nil) then
	teamTakedownResponse = onTeamTakedown:Target(KillingPlayer):Response(
		{
			Medal = 'team_takedown'
		});
end

--
-- Triple Double
--

onTripleDouble = onEnemyPlayerKill:Target(FindNewPlayersWithTripleDouble):Response(
	{	
		Medal = 'triple_double'
	});

--
-- Vehicle Medals ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

--
-- Phantom Destroyed
--

PhantomDestroyedKillResponse = onPhantomDestroyed:Target(KillingPlayer):Response(
	{
		Medal = 'phantom_destruction'
	});

PhantomDestroyedAssistResponse = onPhantomDestroyed:Target(AssistingPlayers):Response(
	{
		Medal = 'phantom_destruction'
	});
	
--
-- Hijack
--

hijackResponse = onLandVehicleJacked:Target(EnteringPlayer):Response(
	{
		Medal = 'hijack'
	});

--
-- Skyjack
--

skyjackResponse = onAirVehicleJacked:Target(EnteringPlayer):Response(
	{
		Medal = 'skyjack'
	});

--
-- Busted (kill a hijacking player)
--

bustedResponse = onBusted:Target(KillingPlayer):Response(
	{
		Medal = 'busted'
	});

--
-- Splatter
--

splatterResponse = onGenericSplatter:Target(KillingPlayer):Response(
	{	
		Medal = 'splatter_kill'
	});

--
-- Road Trip
--

roadTripResponse = onRoadTrip:Target(MatchingPlayers):Response(
	{
		Medal = 'road_trip'
	});

--
-- Buckle up
--

buckleUpResponse = onBuckleUp:Target(KillingPlayer):Response(
	{
		Medal = 'buckle_up'
	});

--
-- Flyin' High
--

flyingHighResponse = onVehicleLandedOnGround:Target(FindFlyingHighPlayers):Response(
	{
		Medal = 'flying_high'
	});
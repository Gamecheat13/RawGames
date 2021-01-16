-- 
function IsPerfectKill(context)
	return PlayerHasFullBodyAndShieldMaxVitality(context.DeadPlayer)
		and (BattleRiflePerfectKill(context) 
			or LightRiflePerfectKill(context) 
			or DMRPerfectKill(context) 
			or MagnumPerfectKill(context) 
			or CarbinePerfectKill(context) 
			or FlagnumPerfectKill(context)
			or H1MagnumPerfectKill(context));
end
function GetDamageSourceRef(context)
	if context.DamageReportingModifier ~= nil and context.DamageReportingModifier == DamageReportingModifier.Assassination then
		return "assassination";
	end
	if context.DamageType == CollisionDamageType and context.KillingPlayerUnit ~= nil and context.KillingPlayerUnit:IsDrivingVehicle() then
		return "splatter";
	end
	if context.DamageType ~= nil then
		local killFeedItemReference = table.first( KillFeedItemReferenceDamageTypes,
			function(item)
				return item[KillFeedItemReference_dmgSourceIndex] == context.DamageType;
			end
			);
		if killFeedItemReference ~= nil then
			return killFeedItemReference[KillFeedItemReference_killFeedStringIndex];
		end
	end
	if context.DamageSource ~= nil then
		local killFeedItemReference = table.first(KillFeedItemReferenceDamageSourcesWithAttachmentSpec,
			function(item)
				local dmgSourceMatches = item[KillFeedItemReference_dmgSourceIndex] == context.DamageSource;
				if (not dmgSourceMatches) then
					return false;
				end
				local attachmentSpecificationStringId = item[KillFeedItemReference_attachmentIndex];
				return table.any(context.WeaponAttachments,
					function(attachmentName)
						return attachmentName == attachmentSpecificationStringId;
					end
				);
			end
			);
		if (killFeedItemReference == nil) then
			killFeedItemReference = table.first( KillFeedItemReferenceDamageSources,
				function(item)
					return item[KillFeedItemReference_dmgSourceIndex] == context.DamageSource;
				end
				);
		end
		if killFeedItemReference ~= nil then
			local killfeedString = killFeedItemReference[KillFeedItemReference_killFeedStringIndex];
			if context.DamageReportingModifier ~= nil and context.DamageReportingModifier == DamageReportingModifier.Headshot then
				if IsPerfectKill(context) then
					killfeedString = killfeedString .. "_perfect";
				else
					killfeedString = killfeedString .. "_headshot";
				end
			end
			return killfeedString;
		end
	end
	LogError("Damage Source reference not found.");
	return "generic";
end
function GenericKillFeedKillPlayer(context)	
	LogError("kill feed fires");
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
aiKillImpulse = onEnemyAIKill:Target(KillingPlayer):Response(
	{
		ImpulseEvent = 'UnitKill'
	});
aiAssistImpulse = onEnemyAIKill:Target(AssistingPlayers):Response(
	{
		ImpulseEvent = 'UnitAssist'
	});
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
assistSoundResposne = onPlayerAssist:Target(AssistingPlayers):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_shared_generickill'
	});
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
betrayalCauseResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		DialogueEvent = function(context)
				return AddDialogueEvent("betray", context.DeadPlayer, context.KillingPlayer)
			end
	});
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
if (disableTeamTakedownMedal == nil) then
	teamTakedownAssistResponse = onTeamTakedownAssist:Target(AssistingPlayers):Response(
		{
			Medal = 'team_takedown_assist'
		});
end
empAssistResponse = onEmpAssist:Target(FindEmpAssistPlayers):Response(
	{
		Medal = 'emp_assist'
	});
wheelmanAssistResponse = onWheelmanAssist:Target(WheelmanAssistPlayers):Response(
	{
		Medal = 'wheelman'
	});
assistDialogueResponse = onPlayerAssist:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
			local firstCausePlayer = table.first(context.AssistingPlayers);
				return AddDialogueEvent("death_assist", context.KillingPlayer, firstCausePlayer)
			end				
	});	
closeCallResponse = onCloseCall:Target(TargetPlayer):Response(
	{
		Medal = 'close_call'
	});
-- 
hardTargetResponse = onTenShieldsRechargedSinceDeath:Target(TargetPlayer):Response(
	{
		Medal = 'hard_target'
	});
PhantomDestroyedKillResponse = onPhantomDestroyed:Target(KillingPlayer):Response(
	{
		Medal = 'phantom_destruction'
	});
PhantomDestroyedAssistResponse = onPhantomDestroyed:Target(AssistingPlayers):Response(
	{
		Medal = 'phantom_destruction'
	});
hijackResponse = onLandVehicleJacked:Target(EnteringPlayer):Response(
	{
		Medal = 'hijack'
	});
skyjackResponse = onAirVehicleJacked:Target(EnteringPlayer):Response(
	{
		Medal = 'skyjack'
	});
flyingHighResponse = onVehicleLandedOnGround:Target(FindFlyingHighPlayers):Response(
	{
		Medal = 'flying_high'
	});
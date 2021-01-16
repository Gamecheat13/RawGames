-- 
-- Default Medal and Announcer Events
--

--
-- Betrayal 
--
-- announcer
betrayalCauseResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayal',
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("betray"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end
	});
	
betrayalEffectResponse = onFriendlyPlayerKill:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_betrayaleffectplayer'
	});

betrayalFeedKillPlayerResponse = onFriendlyPlayerKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_betrayal_killplayer', context.DeadPlayer);
		end
	});
	
betrayalFeedKillTeamResponse = onFriendlyPlayerKill:Target(FriendlyToKillingPlayerNotInvolved):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_betrayal_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

betrayalFeedDeadPlayerResponse = onFriendlyPlayerKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_betrayal_deadplayer', context.KillingPlayer);
		end
	});

--
-- Suicide 
--

suicideResponse = onPlayerSuicide:Target(DeadPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_suicide'
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

--
-- Assist
--

assistResponse = onPlayerAssist:Target(AssistingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_generic_assist',
		Medal = 'assist'
	});

assistResponse = onPlayerAssist:Target(KillingPlayer):Response(
	{
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death_assist"),
				 SubjectUnit = context.KillingPlayer:GetUnit(),
				 CauseUnit = context.AssistingPlayer:GetUnit()
				}
			end				
	});	

--
-- Wingman Medal
--

wingmanResponse = onFiveAssistsSinceDeath:Target(AssistingPlayer):Response(
	 {
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'update_fanfare_wingman',
		Sound = 'multiplayer\audio\announcer\announcer_medals_wingman',
		Medal = 'wingman'
	 });

--
-- Sayonara - falling kill
--

sayonaraResponse = onFallingKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_sayonara',
		Sound = 'multiplayer\audio\announcer\announcer_shared_assistedsuicide',
		Medal = 'sayonara'
	});

sayonaraFeedKillPlayerResponse = onAirAssassination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sayonara_killplayer', context.DeadPlayer);
		end
	});
	
sayonaraFeedKillTeamResponse = onAirAssassination:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sayonara_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

sayonaraFeedDeadPlayerResponse = onAirAssassination:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sayonara_deadplayer', context.KillingPlayer);
		end
	});
	
sayonaraFeedDeadTeamResponse = onAirAssassination:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sayonara_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- Animated air assassination kill.
--

airsassinationResponse = onAirAssassination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_airsassasination',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killairsassination',
		Medal = 'airsassination_kill'
	});
	
airsassinationFeedKillPlayerResponse = onAirAssassination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_airsassination_killplayer', context.DeadPlayer);
		end
	});
	
airsassinationFeedKillTeamResponse = onAirAssassination:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_airsassination_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

airsassinationFeedDeadPlayerResponse = onAirAssassination:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_airsassination_deadplayer', context.KillingPlayer);
		end
	});
	
airsassinationFeedDeadTeamResponse = onAirAssassination:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_airsassination_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- Animated assassination kill.
--

assassinationResponse = onAssassination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_assasination',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killassassination',
		Medal = 'assassination_kill',	
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death_assassination"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end				
	});

assassinationFeedKillPlayerResponse = onAssassination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_assassination_killplayer', context.DeadPlayer);
		end
	});
	
assassinationFeedKillTeamResponse = onAssassination:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_assassination_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

assassinationFeedDeadPlayerResponse = onAssassination:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_assassination_deadplayer', context.KillingPlayer);
		end
	});
	
assassinationFeedDeadTeamResponse = onAssassination:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_assassination_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

-- Rocket launcher kill
--

rocketKillResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_rocket',
		Medal = 'rocket_kill',		
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end	
	});

rocketKillFeedKillPlayerResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer			
	});
	
rocketKillFeedKillTeamResponse = onRocketLaucherKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});

rocketKillFeedDeadPlayerResponse = onRocketLaucherKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
rocketKillFeedDeadTeamResponse = onRocketLaucherKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});	

--
-- Shotgun kill
--

shotgunKillResponse = onShotgunKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_shotgunkill',
		Medal = 'shotgunkill',	
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end				
	});
	
--
-- Airborne Snapshot
--

airborneSnapshotResponse = onAirborneSnapshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_airbornesnapshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillairbornesnapshot',
		Medal = 'airborne_snapshot'
	});
	
--
-- Snapshot 
--

snapshotResponse = onSnapshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_snapshot',
		Medal = 'snapshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekillsnapshot'
	});

--
-- Sniper Headshot
--

sniperHeadshotKillResponse = onSniperHeadshotKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_sniperheadshot',
		Medal = 'sniper_headshot'
	});	
	
--
-- Sniper kill
--

sniperKillResponse = onSniperKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_sniper',
		Medal = 'sniper_kill',
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end			
	});

--
-- Sniper Kill Feed
--

sniperKillFeedKillPlayerResponse = onAllSniperKills:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sniper_killplayer', context.DeadPlayer);
		end
	});
	
sniperKillFeedKillTeamResponse = onAllSniperKills:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sniper_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

sniperKillFeedDeadPlayerResponse = onAllSniperKills:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sniper_deadplayer', context.KillingPlayer);
		end
	});
	
sniperKillFeedDeadTeamResponse = onAllSniperKills:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sniper_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- Perfect Kill Medal
--

perfectBRKillResponse = onBattleRifleFourShot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_perfect',
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill',
		Medal = 'battle_rifle_perfect_kill'
	});

perfectBRKillFeedKillPlayerResponse = onBattleRifleFourShot:Target(KillingPlayer):Response(
	{		
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_br_perfect_killplayer', context.DeadPlayer);
		end
	});

perfectBRKillFeedKillTeamResponse = onBattleRifleFourShot:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_br_perfect_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

perfectBRKillFeedDeadPlayerResponse = onBattleRifleFourShot:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_br_perfect_deadplayer', context.KillingPlayer);
		end
	});

perfectBRKillFeedDeadTeamResponse = onBattleRifleFourShot:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_br_perfect_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});
--
-- Light Rifle Perfect Kill Medal
--

perfectLightRifleKillResponse = onLightRifleThreeShot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_perfect',
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill',
		Medal = 'light_rifle_perfect_kill'
	});

perfectLightRifleKillFeedKillPlayerResponse = onLightRifleThreeShot:Target(KillingPlayer):Response(
	{		
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_light_rifle_perfect_killplayer', context.DeadPlayer);
		end
	});

perfectLightRifleKillFeedKillTeamResponse = onLightRifleThreeShot:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_light_rifle_perfect_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

perfectLightRifleKillFeedDeadPlayerResponse = onLightRifleThreeShot:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_light_rifle_perfect_deadplayer', context.KillingPlayer);
		end
	});

perfectLightRifleKillFeedDeadTeamResponse = onLightRifleThreeShot:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_light_rifle_perfect_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- DMR Perfect Kill Medal
--

perfectDMRKillResponse = onDMRFiveShot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_perfect',
		Sound = 'multiplayer\audio\announcer\announcer_shared_perfectkill',
		Medal = 'dmr_perfect_kill'
	});

perfectDMRKillFeedKillPlayerResponse = onDMRFiveShot:Target(KillingPlayer):Response(
	{		
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_dmr_perfect_killplayer', context.DeadPlayer);
		end
	});

perfectDMRKillFeedKillTeamResponse = onDMRFiveShot:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_dmr_perfect_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

perfectDMRKillFeedDeadPlayerResponse = onDMRFiveShot:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_dmr_perfect_deadplayer', context.KillingPlayer);
		end
	});

perfectDMRKillFeedDeadTeamResponse = onDMRFiveShot:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_dmr_perfect_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});


--
-- Headshot
--

headshotKillResponse = onHeadshotKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_headshot',
		Medal = 'headshot_kill'
	});
	
headshotKillFeedKillPlayerResponse = onHeadshotKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_headshot_killplayer', context.DeadPlayer);
		end	
	});
	
headshotKillFeedKillTeamResponse = onHeadshotKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_headshot_killteam', context.KillingPlayer, context.DeadPlayer);
		end	
	});

headshotKillFeedDeadPlayerResponse = onHeadshotKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_headshot_deadplayer', context.KillingPlayer);
		end	
	});
	
headshotKillFeedDeadTeamResponse = onHeadshotKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_headshot_deadteam', context.DeadPlayer, context.KillingPlayer);
		end	
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
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death_headshot{damage_headshot}"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end				
	});
	
--
-- Stuck
--

stuckResponse = onStuck:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_stuck',
		Medal = 'stuck'
	});

stuckKillFeedKillPlayerResponse = onStuck:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_stuck_killplayer', context.DeadPlayer);
		end
	});
	
stuckKillFeedKillTeamResponse = onStuck:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_stuck_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

stuckKillFeedDeadPlayerResponse = onStuck:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_stuck_deadplayer', context.KillingPlayer);
		end
	});
	
stuckKillFeedDeadTeamResponse = onStuck:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_stuck_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});
	
--
-- Grenade kill
--

grenadeKillResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_grenade',
		Medal = 'grenade_kill'
	});

grenadeKillFeedKillPlayerResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer,
		
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end				
	});
	
grenadeKillFeedKillTeamResponse = onGrenadeKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});

grenadeKillFeedDeadPlayerResponse = onGrenadeKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
grenadeKillFeedDeadTeamResponse = onGrenadeKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});
--
-- Sword kill
--

swordKillResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_sword',
		Medal = 'sword_kill',	
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end	
	});

swordKillFeedKillPlayerResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sword_killplayer', context.DeadPlayer);
		end				
	});
	
swordKillFeedKillTeamResponse = onSwordKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sword_killteam', context.KillingPlayer, context.DeadPlayer);
		end		
	});

swordKillFeedDeadPlayerResponse = onSwordKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sword_deadplayer', context.KillingPlayer);
		end		
	});
	
swordKillFeedDeadTeamResponse = onSwordKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_sword_deadteam', context.DeadPlayer, context.KillingPlayer);
		end		
	});

--
-- Hydra Kill
--

hydraKillResponse = onHydraKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_hydra',
		Medal = 'hydra_kill'
	});

hydraKillFeedKillPlayerResponse = onHydraKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer			
	});
	
hydraKillFeedKillTeamResponse = onHydraKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});

hydraKillFeedDeadPlayerResponse = onHydraKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
hydraKillFeedDeadTeamResponse = onHydraKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});	
	


--
-- Beat down (melee attack from behind)
--

beatdownResponse = onMeleeFromBehind:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_beatdown',
		Medal = 'beatdown_kill',	
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("melee_attack{melee}"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end	
	});		

beatdownKillFeedKillPlayerResponse = onMeleeFromBehind:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_beatdown_killplayer', context.DeadPlayer);
		end
	});
	
beatdownKillFeedKillTeamResponse = onMeleeFromBehind:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_beatdown_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

beatdownKillFeedDeadPlayerResponse = onMeleeFromBehind:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_beatdown_deadplayer', context.KillingPlayer);
		end
	});
	
beatdownKillFeedDeadTeamResponse = onMeleeFromBehind:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_beatdown_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});
	
--
-- Melee kill
--

meleeKillResponse = onMeleeKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_pummell',
		Medal = 'melee_kill'
	});
	
meleeKillFeedKillPlayerResponse = onMeleeKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_melee_killplayer', context.DeadPlayer);
		end
	});
	
meleeKillFeedKillTeamResponse = onMeleeKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_melee_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

meleeKillFeedDeadPlayerResponse = onMeleeKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_melee_deadplayer', context.KillingPlayer);
		end
	});
	
meleeKillFeedDeadTeamResponse = onMeleeKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_melee_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- Ground pound Kill
--

groundPoundKillResponse = onGroundPoundKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_ground_pound',
		Medal = 'ground_pound_kill'
	});

groundPoundKillFeedKillPlayerResponse = onGroundPoundKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_ground_pound_alt_killplayer', context.DeadPlayer);
		end
	});
	
groundPoundKillFeedKillTeamResponse = onGroundPoundKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_ground_pound_alt_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

groundPoundKillFeedDeadPlayerResponse = onGroundPoundKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_ground_pound_alt_deadplayer', context.KillingPlayer);
		end
	});
	
groundPoundKillFeedDeadTeamResponse = onGroundPoundKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_ground_pound_alt_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});

--
-- Shoulder Bash Kill
--

shoulderBashKillResponse = onShoulderBashKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_shoulder_bash',
		Medal = 'shoulder_bash_kill'
	});


shoulderBashKillFeedKillPlayerResponse = onShoulderBashKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_shoulder_bash_killplayer', context.DeadPlayer);
		end
	});
	
shoulderBashKillFeedKillTeamResponse = onShoulderBashKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_shoulder_bash_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});

shoulderBashKillFeedDeadPlayerResponse = onShoulderBashKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_shoulder_bash_deadplayer', context.KillingPlayer);
		end
	});
	
shoulderBashKillFeedDeadTeamResponse = onShoulderBashKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_shoulder_bash_deadteam', context.DeadPlayer, context.KillingPlayer);
		end
	});


--
-- Generic kill
--

genericKillResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_kill',
		Medal = 'everything_else_kill',
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end
	});

genericKillFeedKillPlayerResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer,
	});
	
genericKillFeedKillTeamResponse = onGenericKill:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});

genericKillFeedDeadPlayerResponse = onGenericKill:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
genericKillFeedDeadTeamResponse = onGenericKill:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});

--
-- Non-Headshot & Non-Melee Kill Sound Effect Response
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
-- Hat Trick Medal
--

hatTrickResponse = onThreeConsecutiveHeadshots:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_hattrick',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killhattrick',
		Medal = 'hat_trick'
	});

--
-- Killing Spree Medal

killingSpreeResponse = onFiveKillsSinceDeath:Target(KillingPlayer):Response(
 {
	Fanfare = FanfareDefinitions.PersonalScore,
	FanfareText = 'score_fanfare_killingspree',
	Sound = 'multiplayer\audio\announcer\announcer_shared_killspree05killingspree',
	Medal = 'killing_spree'
 });
 
killingSpreeTeamFeedResponse = onFiveKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_05', context.KillingPlayer);
		end
	});

killingSpreeEnemyFeedResponse = onFiveKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_05', context.KillingPlayer);
		end
	});

-- 
-- Killing Frenzy Medal
--

killingFrenzyResponse = onTenKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killingfrenzy',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree10killingfrenzy',
		Medal = 'killing_frenzy'
	});

killingFrenzyTeamFeedResponse = onTenKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_10', context.KillingPlayer);
		end
	});

killingFrenzyEnemyFeedResponse = onTenKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_10', context.KillingPlayer);
		end
	});	

-- 
-- Running Riot Medal
--

runningRiotResponse = onFifteenKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_runningriot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree15runningriot',
		Medal = 'running_riot'
	});

runningRiotTeamFeedResponse = onFifteenKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_15', context.KillingPlayer);
		end
	});

runningRiotEnemyFeedResponse = onFifteenKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_15', context.KillingPlayer);
		end
	});		

--
-- Rampage Medal 
--

rampageResponse = onTwentyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_rampage',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree20rampage',
		Medal = 'rampage'
	});
	
rampageTeamFeedResponse = onTwentyKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_20', context.KillingPlayer);
		end
	});

rampageEnemyFeedResponse = onTwentyKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_20', context.KillingPlayer);
		end
	});	

--
-- Untouchable Medal
--

untouchableResponse = onTwentyFiveKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_untouchable',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree25untouchable',
		Medal = 'untouchable'
	});
	
untouchableTeamFeedResponse = onTwentyFiveKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_25', context.KillingPlayer);
		end
	});

untouchableEnemyFeedResponse = onTwentyFiveKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_25', context.KillingPlayer);
		end
	});

--
-- Invincible Medal
--

invincibleResponse = onThirtyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_invincible',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree30invincible',
		Medal = 'invincible'
	});
	
invincibleTeamFeedResponse = onThirtyKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_30', context.KillingPlayer);
		end
	});

invincibleEnemyFeedResponse = onThirtyKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_30', context.KillingPlayer);
		end
	});

--
-- Inconceivable Medal
--

inconceivableResponse = onThirtyFiveKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_inconceivable',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree35inconceivable',
		Medal = 'inconceivable'
	});
	
inconceivableTeamFeedResponse = onThirtyFiveKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_35', context.KillingPlayer);
		end
	});

inconceivableEnemyFeedResponse = onThirtyFiveKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_35', context.KillingPlayer);
		end
	});

--	
-- Unfriggenbelievable Medal
-- 

unfrigginbelievResponse = onFourtyKillsSinceDeath:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_unfrigginbeliev',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killspree40unfriggenbelieveable',
		Medal = 'unfriggenbelievable'
	});
	
unfriggenbelievableTeamFeedResponse = onFourtyKillsSinceDeath:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_40', context.KillingPlayer);
		end
	});

unfriggenbelievableEnemyFeedResponse = onFourtyKillsSinceDeath:Target(HostileToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killspree_40', context.KillingPlayer);
		end
	});
	
--
-- Killjoy Kill Feed
--
	
killjoyFeedKillPlayerResponse = onKilljoy:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killjoy_killplayer', context.DeadPlayer);
		end
	});
	
killjoyFeedKillTeamResponse = onKilljoy:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_killjoy_killteam', context.KillingPlayer, context.DeadPlayer);
		end
	});
	
--
-- Double Kill Medal 
--

doubleKillResponse = onTwoKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_doublekill',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill02doublekill',
		Medal = 'double_kill',		
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("player_multi_kill"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end			
	});

--
-- Triple Kill Medal 
--

tripleKillResponse = onThreeKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_triplekill',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill03triplekill',
		Medal = 'triple_kill'
	});
	
--
-- Overkill Medal 
--

overkillResponse = onFourKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_overkill',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill04overkill',
		Medal = 'overkill'
	});
	
--
-- Killtacular Medal 
--

killtacularResponse = onFiveKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killtacular',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill05killtacular',
		Medal = 'killtacular'
	});

--
-- Killtrocity Medal 
--

killtrocityResponse = onSixKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killtrocity',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill06killtrocity',
		Medal = 'killtrocity'
	});

--
-- Killimanjaro Medal 

killimanjaroResponse = onSevenKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killimanjaro',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill07killamanjaro',
		Medal = 'killamanjaro'
	});

--
-- Killtastrophe Medal 
--

killtastropheResponse = onEightKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killtastrophe',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill08killtastrophe',
		Medal = 'killtastrophe'
	});

--	
-- Killpocalypse Medal 
--

killpocalypseResponse = onNineKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killpocalypse',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill09killpocalypse',
		Medal = 'killpocalypse'
	});

--	
-- Killionaire Medal 
--

killionaireResponse = onTenKillsInARow:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_killionaire',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killmultikill10killionaire',
		Medal = 'killionaire'
	});
	
--
-- Extermination Medal
--

exterminationResponse = onExtermination:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_extermination',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killextermination',
		Medal = 'extermination'
	});

--
-- First strike
--

firstStrikeResponse = onFirstKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_firststrike',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfirststrike',
		Medal = 'first_strike',
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("first_strike"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end			
		
	});		

--
-- Retribution (assassinate the last person to kill you)
--
	
retributionResponse = onRetribution:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_retribution',
		Medal = 'retribution',
		Sound = 'multiplayer\audio\announcer\announcer_shared_retribution'
	});

--
-- From the grave (killed player while dead, not in same tick).
--
	
killFromTheGraveResponse = onKillFromTheGrave:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_fromthegrave',
		Medal = 'kill_from_the_grave',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killfromthegrave'
	});

--
-- Showstopper
--
	
showstopperResponse = onShowStopper:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_showstopper',
		Medal = 'showstopper',
		Sound = 'multiplayer\audio\announcer\announcer_shared_killshowstopper'
	});
	
--
-- Cliffhanger
--
	
cliffhangerResponse = onCliffhanger:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_cliffhanger',
		Medal = 'cliffhanger'
	});
	
--
-- Longshot
--

battleRifleLongshotResponse = onBattleRifleLongshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_longshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot',
		Medal = 'longshot'
	});

dmrLongshotResponse = onDMRLongshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_longshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot',
		Medal = 'longshot'
	});

magnumLongshotResponse = onMagnumLongshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_longshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot',
		Medal = 'longshot'
	});
	
sniperLongshotResponse = onSniperLongshot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_longshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_sniperriflekilllongshot',
		Medal = 'longshot'
	});
		
--
-- Rocket Mary
--

rocketMaryResponse = onRocketMary:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_rocket_mary',
		Sound = 'multiplayer\audio\announcer\announcer_shared_rocketlongrange',
		Medal = 'rocket_mary'
	});
	
--
-- Hail Mary
--
	
hailMaryResponse = onHailMary:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_hailmary',
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadelongrangekill',
		Medal = 'hail_mary'
	});


hailMaryFeedKillPlayerResponse = onHailMary:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillPlayer,
		
		DialogueEvent = function (context)
			return
				{
				 EventStringId = ResolveString("death"),
				 SubjectUnit = context.DeadPlayer:GetUnit(),
				 CauseUnit = context.KillingPlayer:GetUnit()
				}
			end				
	});
	
hailMaryFeedKillTeamResponse = onHailMary:Target(FriendlyToKillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedKillTeam
	});

hailMaryFeedDeadPlayerResponse = onHailMary:Target(DeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadPlayer
	});
	
hailMaryFeedDeadTeamResponse = onHailMary:Target(FriendlyToDeadPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = GenericKillFeedDeadTeam
	});
	
--
-- Spray and Pray - Assault Rifle
--

assaultRifleSprayPrayResponse = onAssaultRifleSprayPray:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_spraypray',
		Medal = 'spray_and_pray',
		Sound = 'multiplayer\audio\announcer\announcer_medals_spraypraykill'
	});
	
--
-- Spray and Pray - SMG
-- lametten TODO: Hook up when SMG Damage Source comes online
--

--
-- Cluster Luck
--
	
clusterLuckResponse = onClusterLuck:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_clusterluck',
		Sound = 'multiplayer\audio\announcer\announcer_shared_grenadedouble',
		Medal = 'clusterluck'
	});
	
--
-- Bulltrue
--

bulltrueResponse = onBulltrue:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_bulltrue',
		Medal = 'bulltrue',
		Sound = 'multiplayer\audio\announcer\announcer_shared_bulltrue'
	});	

--
-- Armageddon
--

armageddonResponse = onFourRocketKillsSinceDeath:Target(KillingPlayer):Response(
 {
	Fanfare = FanfareDefinitions.PersonalScore,
	FanfareText = 'score_fanfare_armageddon',
	Medal = 'armageddon',
	Sound = 'multiplayer\audio\announcer\announcer_shared_rocketarmageddon'
 });

--
-- Snipeltaneous!
--
	
twoKillsOneShotResponse = onTwoKillsOneShot:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_sniperdoubleshot',
		Medal = 'sniperdoubleshot',
		Sound = 'multiplayer\audio\announcer\announcer_shared_snipeltaneous'
	});
	
--
-- Distraction Medal
--

distractionResponse = onDistraction:Target(DistractingPlayers):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_medals_distraction',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_distraction',
		Medal = 'distraction'
	});

--
-- Close Call
--

closeCallResponse = onCloseCall:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_closecall',
		Medal = 'close_call'
	});

--
-- Hard Target (10 shields recharged since death)
-- 

hardTargetResponse = onTenShieldsRechargedSinceDeath:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_rechargespreehardtarget',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_hard_target',
		Medal = 'hard_target'
	});

--
-- Reversal Kill
--

reversalResponse = onReversal:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_medals_comebackkill',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_reversal',
		Medal = 'reversal'
	});

--
-- Big Game Hunter
--

bigGameHunterResponse = onBigGameHunter:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_biggamehunterkill',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_big_game_hunter',
		Medal = 'big_game_hunter'
	});

--
-- Protector
--

protectorResponse = onShortRangeProtectorKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_protector',
		Medal = 'protector'
	});

--
-- Guardian Angel (long range protector)
--

guardianAngelResponse = onLongRangeProtectorKill:Target(KillingPlayer):Response(
	{
		--Sound = 
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_guardianangel',
		Medal = 'guardian_angel'
	});

--
--protector kill feed (Protector and Guardian Angel)
--

protectorFeedResponseKillPlayer = onProtectorKill:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function(context)
			return FormatText("score_fanfare_killfeed_protector_killplayer", context.ProtectedPlayer);
		end
	});

protectorFeedResponseProtectedPlayer = onProtectorKill:Target(ProtectedPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function(context)
			return FormatText("score_fanfare_killfeed_protector_protectedplayer", context.KillingPlayer);
		end
	});

--
-- Bodyguard
--

bodyguardResponse = onThreeProtectorSinceDeath:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_medals_protector',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_bodyguard',
		Medal = 'bodyguard'
	});

--
-- Revenge
--

retributionKillFeedResponse = onRetribution:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_retribution_killplayer', context.DeadPlayer);
		end
	});

retributionKillFeedResponse = onRevenge:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_revenge_killplayer', context.DeadPlayer);
		end
	});

--
-- Avenger
--

avengerResponse = onAvenger:Target(KillingPlayer):Response(
	{
		Medal = 'avenger',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_avenger'
	});
	
avengerKillFeedResponse = avengerResponse:Target(KillingPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('score_fanfare_killfeed_avenger_killplayer', context.AvengedPlayer);
		end
	});

--
-- Lastshot
--

lastshotResponse = onEnemyPlayerKillWithLastBullet:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_killlastbulletlast',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_last_shot',
		Medal = 'lastshot'
	});

--
-- BXR
--

bxrResponse = onBxrKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_bxrkill',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_bxr',
		Medal = 'bxr'
	});

--
-- Brawler
--

brawlerResponse = onBrawlerKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_breakout_brawler',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_brawler',
		Medal = 'brawler'
	});

--
-- Gunpunch
--

gunpunchResponse = onGunpunchKill:Target(KillingPlayer):Response(
	{
		Sound = 'multiplayer\audio\announcer\announcer_shared_gunpunchmeleekill',
		Fanfare = FanfareDefinitions.PersonalScore,
		FanfareText = 'score_fanfare_gunpunch',
		Medal = 'gunpunch'
	});


__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
warzoneTempleIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_welcometowarzone2', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_warzonemodeinstruction2',
	});
__OnWarzoneBaseIntro = Delegate:new();
onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);
warzoneBaseIntroResponse = onWarzoneBaseIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_warzoneintrotemple', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultdescriptive2',
	});
__OnWarzoneSpawned = Delegate:new();
onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);
warzoneBaseIntroSpawnedResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_warzonetemplespawn',
	});
onBaseCapturedSelect = onBaseCaptured:Select();
onTempleAttGarageCaptured = onBaseCapturedSelect:Add(BaseIsNamed('attacker_garage'));
onTempleAttGarageCapturedCapturing = onTempleAttGarageCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_att_garage_captured_player_feed', 		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_att_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleAttGarageCapturedFriendly = onTempleAttGarageCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_att_garage_captured_friendly_fanfare',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_att_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleAttGarageCapturedHostile = onTempleAttGarageCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_att_garage_captured_enemy_fanfare',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_att_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleDefGarageCaptured = onBaseCapturedSelect:Add(BaseIsNamed('defender_garage'));
onTempleDefGarageCapturedCapturing = onTempleDefGarageCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_def_garage_captured_player_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_def_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleDefGarageCapturedFriendly = onTempleDefGarageCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_def_garage_captured_friendly_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_def_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleDefGarageCapturedHostile = onTempleDefGarageCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_def_garage_captured_enemy_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_def_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleTempleCaptured = onBaseCapturedSelect:Add(BaseIsNamed('temple'));
onTempleTempleCapturedCapturing = onTempleTempleCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_temple_captured_player_feed',
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_templecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_temple_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleTempleCapturedFriendly = onTempleTempleCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_temple_captured_friendly_fanfare',
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_templecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_temple_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onTempleTempleCapturedHostile = onTempleTempleCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'temple_temple_captured_enemy_fanfare',
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_templecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'temple_temple_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
defendResponses =
{
}	
minibossDefinitions =
{	
	{
		name = "temple_boss_leg_warden",
		label = 'temple_boss_leg_warden',
		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoverwatchprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_temple_overwatch_prometheans',
					},
				},       
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewardenspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_warden_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangefriendly',
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangehostile',
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangefriendly',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer',
					ImpulseEvent = 'impulse_mythic_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_warden_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_warden_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "temple_mecha_grunt",
		label = 'temple_mecha_grunt',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\wzcmndrsustain_warzone_bosstempleoverwatchcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_temple_overwatch_covenant',
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenericspawnedplural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_hamyap_spawned_message ',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\wzcmndrsustain_warzonepve_bossspawnedenemywinhim',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_hamyap_kill_fanfare',
					ImpulseEvent = 'impulse_mythic_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_hamyap_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_hamyap_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedownfriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_hamyap_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bosscovenantgenericteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "temple_boss_leg_knight",
		label = 'temple_boss_leg_knight',
		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoverwatchprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_temple_overwatch_prometheans',
					},
				},       
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_knight_dominarch_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchwinrangefriendly'
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchwinrangehostile'
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchwinrangefriendly'
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_knight_dominarch_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_knight_dominarch_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchcompleteplayer'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_knight_dominarch_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_knight_dominarch_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempledominarchteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "temple_boss_leg_jul",
		label = 'temple_boss_leg_jul',
		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoverwatchcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_temple_overwatch_covenant',
					},
				},       
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_jul_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulwinrangefriendly'
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulwinrangehostile'
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulwinrangefriendly'
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_jul_kill_fanfare',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_jul_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_jul_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_jul_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplejulteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "temple_boss_att_soldier",
		label = 'temple_boss_att_soldier',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewornruinsprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_worn_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldierspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_soldier_commmander_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = function (context)
						return FormatText('temple_boss_soldier_commander_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\wzcmndrsustain_warzone_bosstemplesoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_soldier",
		label = 'temple_boss_def_soldier',
		responses = 
		{
			countdownResponse = 
			{    
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplegrownruinsprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_overgrown_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldierspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_soldier_commmander_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_soldier_commander_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplesoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_att_zealot",
		label = 'temple_boss_att_zealot',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewornruinscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_worn_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_zealot_commmander_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = function (context)
						return FormatText('temple_boss_zealot_commander_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleeliteteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_zealot",
		label = 'temple_boss_def_zealot',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplegrownruinscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_overgrown_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_zealot_commmander_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_zealot_commander_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = function (context)
						return FormatText('temple_boss_zealot_commander_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleeliteteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_knight_pillars",
		label = 'temple_knight_pillars',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewornruinsprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_worn_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_knight_pillars_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_teamfeed'
				}
			},		
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompletefriendly'					
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned); 
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_knight_flood",
		label = 'temple_knight_flood',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplegrownruinsprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_overgrown_ruins_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_knight_flood_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_teamfeed'
				}
			},		
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompletefriendly'					
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned); 
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_att_hunter",
		label = 'temple_boss_att_hunter',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleplainscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehunterspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_hunters_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{			
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
			progressPlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			progressAssistResponse =
			{	
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},	
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_teamfeed'
				}
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompletefriendly',
			},
			progressEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteenemy',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehunterteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_hunter",
		label = 'temple_boss_def_hunter',
		responses = 
		{
			countdownResponse = 
			{    
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoasiscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehunterspawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_hunters_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{			
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			progressPlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			progressAssistResponse =
			{	
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},	
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_teamfeed'
				}
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompletefriendly',
			},
			progressEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteenemy',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}				
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_hunters_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehuntercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplehunterteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_att_banshee",
		label = 'temple_boss_att_banshee',
		responses = 
		{
			countdownResponse = 
			{   
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleplainscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheespawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_banshee_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheeteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_banshee",
		label = 'temple_boss_def_banshee',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoasiscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheespawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_banshee_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheeteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "temple_boss_elite_recon_att",
		label = 'temple_boss_att_elite_recon',
		responses = 
		{
			countdownResponse = 
			{       
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebrokepillarscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_worn_ruins_covenant',					
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleaderspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_elite_recon_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleaderteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_elite_recon_def",
		label = 'temple_boss_def_elite_recon',
		responses = 
		{
			countdownResponse = 
			{       
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplefloodruinscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_overgrown_ruins_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleaderspawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_elite_recon_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_recon_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleadercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplereconleaderteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_oasis_elite",
		label = 'temple_oasis_elite',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoasiscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_elite_oasis_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = function (context)
						return FormatText('meridian_boss_elite_spec_op_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianeliteteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "temple_elite_plains",
		label = 'temple_elite_plains',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleplainscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_elite_plains_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = function (context)
						return FormatText('meridian_boss_elite_spec_op_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianeliteteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "temple_boss_att_elite_scatter",
		label = 'temple_boss_att_elite_scatter',
		responses = 
		{
			countdownResponse = 
			{       
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebrokepillarscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_worn_ruins_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_elite_specialist_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialistcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialistcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_fanfare',
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_elite_scatter",
		label = 'temple_boss_def_elite_scatter',
		responses = 
		{
			countdownResponse = 
			{       
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplefloodruinscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_overgrown_ruins_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialspawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_elite_specialist_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialistcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialistcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_fanfare',
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_elite_specialist_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleelitespecialteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_att_ghost",
		label = 'temple_boss_att_ghost',
		responses = 
		{
			countdownResponse = 
			{   
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleplainscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_ghost_scout_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_ghost",
		label = 'temple_boss_def_ghost',
		responses = 
		{
			countdownResponse = 
			{   
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoasiscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostspawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_ghost_scout_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_ghost_scout_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleghostteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_plains_bandit",
		label = 'temple_plains_bandit',
		responses = 
		{
			countdownResponse = 
			{   
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericincoming2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_bandit_plains_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_oasis_bandit",
		label = 'temple_oasis_bandit',
		responses = 
		{
			countdownResponse = 
			{   
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericincoming2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_bandit_oasis_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_att_wraith",
		label = 'temple_boss_att_wraith',
		responses = 
		{
			countdownResponse = 
			{    
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleplainscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_plains_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_wraith_battalion_att_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "temple_boss_def_wraith",
		label = 'temple_boss_def_wraith',
		responses = 
		{
			countdownResponse = 
			{    
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstempleoasiscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_oasis_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithspawned02',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'temple_boss_wraith_battalion_def_spawned_message',
					},
				},
			},
			appearedResponse = 
			{
			},
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompletefriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_wraith_battalion_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplewraithteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
};
applyMinibossResponsesEmptyMetatable(minibossDefinitions);
k_templeJul				= ResolveString("temple_boss_jul");
k_templeDominarch		= ResolveString("temple_boss_knight_dominarch");
k_templeWarden			= ResolveString("temple_boss_warden");
k_templeHamyap			= ResolveString("boss_hamyap");
k_templeZealotAtt		= ResolveString("temple_boss_zealot_commander_att");
k_templeZealotDef		= ResolveString("temple_boss_zealot_commander_def");
k_templeSoldierAtt		= ResolveString("temple_boss_soldier_commander_att");
k_templeSoldierDef		= ResolveString("temple_boss_soldier_commander_def");
k_templeHunterAtt01		= ResolveString("temple_boss_hunters_att_1");
k_templeHunterAtt02		= ResolveString("temple_boss_hunters_att_2");
k_templeHunterDef01		= ResolveString("temple_boss_hunters_def_1");
k_templeHunterDef02		= ResolveString("temple_boss_hunters_def_2");
k_templeReconAtt 		= ResolveString("temple_boss_elite_recon_att");
k_templeRecondDef		= ResolveString("temple_boss_elite_recon_def");
k_templeSpecialistAtt	= ResolveString("temple_boss_elite_specialist_att");
k_templeSpecialistDef	= ResolveString("temple_boss_elite_specialist_def");
k_templeGhostAtt01		= ResolveString("temple_boss_ghost_scout_att_1");
k_templeGhostAtt02		= ResolveString("temple_boss_ghost_scout_att_2");
k_templeGhostDef01		= ResolveString("temple_boss_ghost_scout_def_1");
k_templeGhostDef02		= ResolveString("temple_boss_ghost_scout_def_2");
k_templeBansheeAtt		= ResolveString("temple_boss_banshee_att");
k_templeBansheeDef		= ResolveString("temple_boss_banshee_def");
k_templeWraithAtt		= ResolveString("temple_boss_wraith_battalion_att");
k_templeWraithDef		= ResolveString("temple_boss_wraith_battalion_def");
k_templeBanditPlains	= ResolveString("meridian_boss_forerunner_patrol");
k_templeBanditOasis		= ResolveString("meridian_boss_forerunner_patrol");
k_templeKnightPillar	= ResolveString("ring_boss_beach_knight_01");
k_templeKnightFlood		= ResolveString("ring_boss_beach_knight_01");
k_templeElitePlains		= ResolveString("meridian_boss_elite_spec_op");
k_templeEliteOasis		= ResolveString("meridian_boss_elite_spec_op");
local WarzoneTempleBossNamesAndIds = 
{
	{ "jul", 				k_templeJul },
	{ "knightDominarch", 	k_templeDominarch },
	{ "warden", 			k_templeWarden },
	{ "hamyap", 			k_templeHamyap },
	{ "hunterAncient", 		k_templeHunterAtt01 },
	{ "hunterAncient", 		k_templeHunterAtt02 },
	{ "hunterAncient", 		k_templeHunterDef01 },
	{ "hunterAncient", 		k_templeHunterDef02 },
	{ "eliteCommander", 	k_templeZealotAtt },
	{ "eliteCommander", 	k_templeZealotDef },
	{ "soldierCommander", 	k_templeSoldierAtt },
	{ "soldierCommander", 	k_templeSoldierDef },
	{ "reconLeader",		k_templeReconAtt },
	{ "reconLeader", 		k_templeRecondDef },
	{ "specialist",			k_templeSpecialistAtt },
	{ "specialist",			k_templeSpecialistDef },
	{ "ghostScout",			k_templeGhostAtt01 },
	{ "ghostScout", 		k_templeGhostAtt02 },
	{ "ghostScout", 		k_templeGhostDef01 },
	{ "ghostScout", 		k_templeGhostDef02 },
	{ "bansheeScout", 		k_templeBansheeAtt },
	{ "bansheeScout", 		k_templeBansheeDef },
	{ "battalionLeader", 	k_templeWraithAtt },
	{ "battalionLeader", 	k_templeWraithDef },
	{ "soldierBandit", 		k_templeBanditPlains },
	{ "soldierBandit",		k_templeBanditOasis },
	{ "champion", 			k_templeKnightPillar },
	{ "champion", 			k_templeKnightFlood },
	{ "eliteSpec", 			k_templeElitePlains },
	{ "eliteSpec", 			k_templeEliteOasis }
}
local WarzoneTempleBossNames = 
{
	k_templeJul,
	k_templeDominarch,
	k_templeWarden,
	k_templeHamyap,
	k_templeHunterAtt01,
	k_templeHunterAtt02,
	k_templeHunterDef01,
	k_templeHunterDef02,
	k_templeZealotAtt,
	k_templeZealotDef,
	k_templeSoldierAtt,
	k_templeSoldierDef,
	k_templeReconAtt,
	k_templeRecondDef,
	k_templeSpecialistAtt,
	k_templeSpecialistDef,
	k_templeGhostAtt01,
	k_templeGhostAtt02,
	k_templeGhostDef01,
	k_templeGhostDef02,
	k_templeBansheeAtt,
	k_templeBansheeDef,
	k_templeWraithAtt,
	k_templeWraithDef,
	k_templeBanditPlains,
	k_templeBanditOasis,
	k_templeKnightPillar,
	k_templeKnightFlood,
	k_templeElitePlains,
	k_templeEliteOasis
}
onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then
			return false;	
		end
		return table.any(WarzoneTempleBossNames,
			function(resolvedBossString)
				local bossId = context.KillingObject:GetStringIdNetworkedProperty(ResolveString("BossName"));
				context.BossId = bossId;
				return bossId:IsValid() and bossId == resolvedBossString;
			end
			);
	end
	);
onDeathByBossSelect = onDeathByBoss:Select();
function BuildDeathByBossResponses(bossName, source)
	local globals = _G;
	globals[bossName .. "KilledYouResponse"] = source:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = bossName .. "_killed_you"
	});
end
for index, allBosses in ipairs(WarzoneTempleBossNamesAndIds) do
	local bossNameIndex = 1;
	local bossIdIndex = 2;
	local bossName = allBosses[bossNameIndex];
	local sourceEvent = onDeathByBossSelect:Add(
		function(context)
			return context.BossId == allBosses[bossIdIndex];
		end
		);
	BuildDeathByBossResponses(bossName, sourceEvent);
end
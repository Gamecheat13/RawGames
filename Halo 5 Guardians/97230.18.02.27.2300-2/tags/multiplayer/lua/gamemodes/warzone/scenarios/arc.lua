
__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
warzoneArcIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultprometheans3', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultdescriptive',
	});
__OnWarzoneSpawned = Delegate:new();
onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);
warzoneBaseIntroSpawnedResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_supportmarinesgeneric',
	});
onBaseCapturedSelect = onBaseCaptured:Select();
onArcGarageBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_neutral_garage'));
onArcGarageBaseCapturedCapturing = onArcGarageBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_garage_captured_player_feed', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcGarageBaseCapturedFriendly = onArcGarageBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_garage_captured_teammate_feed', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcGarageBaseCapturedHostile = onArcGarageBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_garage_captured_enemy_fanfare', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcDefArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_def_armory'));
onArcDefArmoryCapturedCapturing = onArcDefArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_eastarmory_captured_player_feed', 		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcDefArmoryCapturedFriendly = onArcDefArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_eastarmory_captured_teammate_feed',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcDefArmoryCapturedHostile = onArcDefArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_def_armory_captured_enemy_fanfare',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcAttArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_att_armory'));
onArcAttArmoryCapturedCapturing = onArcAttArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_westarmory_captured_player_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcAttArmoryCapturedFriendly = onArcAttArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_westarmory_captured_teammate_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onArcAttArmoryCapturedHostile = onArcAttArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_att_armory_captured_enemy_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
defendResponses =
{	
}
minibossDefinitions =
{	
	{
		name = "wardenBoss",
		label = 'arc_boss_warden',
		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccraneprometheansappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_prometheans',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1discoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_warden_spawned_message',
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
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer',
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
					FanfareText = 'arc_boss_warden_kill_fanfare',
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
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_killed_teamfeed',
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
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_killed_enemymessage',
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
		name = "boss_swarmlord_mag",
		label = 'arc_boss_hunter',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccranecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_covenant',
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantleggenericbossspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_swarmlord_mag_spawned_message',
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
			},
			progressAssistResponse =
			{	
			},
			progressFriendlyResponse = 
			{
			},
			progressFriendlyProximityResponse =
			{
			},
			progressEnemyResponse = 
			{
			},
			progressEnemyProximityResponse =
			{
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_mag_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_mag_kill_fanfare'
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
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_mag_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedownfriendly',
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
					FanfareText = 'boss_swarmlord_mag_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "boss_knight_praetorian",
		label = 'arc_boss_kc',
		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccraneprometheansappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_prometheans',
					},
				},       
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric4',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossmeridianknightspawned2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_knight_praetorian_spawned_message',
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
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightwinrangefriendly'
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightwinrangehostile'
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightwinrangefriendly'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_knight_praetorian_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_knight_praetorian_kill_fanfare'
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
					FanfareText = 'boss_knight_praetorian_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultracompletefriendly',
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
					FanfareText = 'boss_knight_praetorian_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianknightteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "ring_pve_boss_grunt_mech",
		label = 'arc_boss_mecha_grunt',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccranecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_covenant',
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
						FanfareText = 'arc_boss_grunt_mech_spawned_message ',
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
					FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_04',
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
					FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_04'
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
					FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_04',
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
					FanfareText = 'boss_tomp_killed_enemymessage'
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
		name = "meridian_boss_soldier_scout",
		label = 'boss_blue_yard',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarcblueyardprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_blue_yard_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_scout_att_spawned_message',
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
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
			progressPlayerResponse =
			{
			},
			progressAssistResponse =
			{		
			},
			progressFriendlyResponse = 
			{
			},
			progressFriendlyProximityResponse =
			{
			},
			progressEnemyResponse = 
			{
			},
			progressEnemyProximityResponse =
			{
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_scout_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompletefriendly',
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
						return FormatText('meridian_boss_soldier_scout_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_scout",
		label = 'boss_red_yard',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarcredyardprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_red_yard_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_scout_def_spawned_message',
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
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
			progressPlayerResponse =
			{
			},
			progressAssistResponse =
			{		
			},
			progressFriendlyResponse = 
			{
			},
			progressFriendlyProximityResponse =
			{
			},
			progressEnemyResponse = 
			{
			},
			progressEnemyProximityResponse =
			{
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_scout_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompletefriendly',
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
						return FormatText('meridian_boss_soldier_scout_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "red_tunnel_elite_01",
		label = 'arc_boss_def_general',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdeftowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_relaytower_covenant',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_def_elite_prime_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitediscoveredplayer',
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
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbaneliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "red_tunnel_elite_01",
		label = 'arc_boss_att_general',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcatttowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_commtower_covenant',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_att_elite_prime_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitediscoveredplayer',
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
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbaneliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_elite_spec_op_att",
		label = 'boss_att_crates_elite',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbaycovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_loadingbay_covenant',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_elite_loading_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitespawned',
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
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'meridian_boss_elite_spec_op_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianeliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_elite_spec_op_def",
		label = 'boss_def_crates_elite',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcovecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_grotto_covenant',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_elite_grotto_spawned_messag',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitespawned',
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
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'meridian_boss_elite_spec_op_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_elite_spec_op_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianeliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ice_boss_def_officer",
		label = 'boss_mid_outpost',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarccranetowerprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mid_outpost_promethean'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiershippingspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_commando_spawned'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
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
					FanfareText = 'ice_boss_officer_kill_teamfeed_01'
				}
			},
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompletefriendly',
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
					FanfareText = 'ice_boss_officer_killed_enemymessage_01'
				}
			},
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "att_soldier_officer",
		label = 'boss_west_storage',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarcwtunnelstorageprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_west_storage_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_soldierbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_west_soldier_enforcer_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare'
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
					FanfareText = 'arc_boss_soldier_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompletefriendly',
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
						return FormatText('arc_boss_soldier_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "def_soldier_officer",
		label = 'boss_east_storage',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarcetunnelstorageprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_east_storage_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_soldierbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_east_soldier_enforcer_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare'
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
					FanfareText = 'arc_boss_soldier_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompletefriendly',
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
					FanfareText = 'arc_boss_soldier_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "huntersDef",
		label = 'arc_boss_hunters_def',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_hunters_def_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "huntersAtt",
		label = 'arc_boss_hunters_att',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_hunters_att_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arc_boss_att_knight_01",
		label = 'boss_att_comm_knight',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_commtower_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_knight_comm_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare'
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
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompletefriendly',
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
					FanfareText = 'arc_boss_knight_bw_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arc_boss_def_knight_01",
		label = 'boss_def_knight_relay',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_relaytower_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_knight_relay_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare'
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
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompletefriendly',
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
					FanfareText = 'arc_boss_knight_bw_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "arcRangerAtt",
		label = 'arc_boss_ranger_att',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ranger_att_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare'
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
					FanfareText = 'arc_boss_ranger_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompletefriendly',
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
					FanfareText = 'arc_boss_ranger_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arcRangerDef",
		label = 'arc_boss_ranger_def',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ranger_def_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare'
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
					FanfareText = 'arc_boss_ranger_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompletefriendly',
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
					FanfareText = 'arc_boss_ranger_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "boss_att_general_01",
		label = 'boss_mid_yard',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossarcmidyardcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mid_yard_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_general_yard_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
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
					FanfareText = 'arc_boss_att_general_killed_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompletefriendly',
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
					FanfareText = 'arc_boss_att_general_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arcDefKnight2",
		label = 'arc_boss_def_knight2',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcoveprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_grotto_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_crates_knight_def_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = 'arc_boss_knight2_kill_fanfare'
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
					FanfareText = 'arc_boss_knight2_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompletefriendly',
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
					FanfareText = 'arc_boss_knight2_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arcAttKnight2",
		label = 'arc_boss_att_knight2',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbayprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_loadingbay_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_crates_knight_att_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare'
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
					FanfareText = 'arc_boss_knight2_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompletefriendly',
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
					FanfareText = 'arc_boss_knight2_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ring_boss_north_soldier_name",
		label = 'arc_boss_soldier_att',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsiteprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_dig_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierdiscoveredplayer',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
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
					FanfareText = 'ring_boss_north_soldier_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompletefriendly'					
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
					FanfareText = 'ring_boss_north_soldier_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteenemy'				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ring_boss_north_soldier_name",
		label = 'arc_boss_soldier_def',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_mine_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierdiscoveredplayer',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
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
					FanfareText = 'ring_boss_north_soldier_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompletefriendly'					
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
					FanfareText = 'ring_boss_north_soldier_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteenemy'				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
};
applyMinibossResponsesEmptyMetatable(minibossDefinitions);
k_ArcJockey 		= ResolveString("arc_boss_grunt_mech");
k_ArcPraetorian		= ResolveString("boss_knight_praetorian");
k_ArcWarden			= ResolveString("arc_boss_warden");
k_ArcSwarmlord		= ResolveString("boss_swarmlord_mag");
k_ArcKnightDigAtt01 = ResolveString("att_knight_commander");
k_ArcKnightDigDef01 = ResolveString("def_knight_commander");
k_ArcHunterAtt01	= ResolveString("arc_boss_hunter_att_01");
k_ArcHunterAtt02	= ResolveString("arc_boss_hunter_att_02");
k_ArcHunterDef01	= ResolveString("arc_boss_hunter_def_01");
k_ArcHunterDef02	= ResolveString("arc_boss_hunter_def_02");
k_ArcRangerAtt 		= ResolveString("arc_boss_att_ranger");
k_ArcRangerDef 		= ResolveString("arc_boss_def_ranger");
k_ArcOfficerAtt		= ResolveString("att_soldier_officer");
k_ArcOfficerDef		= ResolveString("def_soldier_officer");
k_ArcGeneralDef		= ResolveString("boss_att_general_01");
k_ArcKnightRelay	= ResolveString("arc_boss_def_knight_01");
k_ArcKnightComm		= ResolveString("arc_boss_att_knight_01");
k_ArcPromScoutRed	= ResolveString("meridian_boss_soldier_scout");
k_ArcPromScoutBlue	= ResolveString("meridian_boss_soldier_scout");
k_ArcElitePrimeComm = ResolveString("red_tunnel_elite_01");
k_ArcElitePrimeRelay = ResolveString("blue_tunnel_elite_01");
k_ArcSoldierDig = ResolveString("ring_boss_north_soldier_name");
k_ArcSoldierMine = ResolveString("ring_boss_north_soldier_name");
k_ArcSpecOpsLoading = ResolveString("meridian_boss_elite_spec_op_att");
k_ArcSpecOpsGrotto = ResolveString("meridian_boss_elite_spec_op_def");
k_ArcSoldierCommando = ResolveString("ice_boss_def_officer");
local WarzoneArcBossNamesAndIds = 
{
	{ "gruntJockey", 		k_ArcJockey  },
	{ "praetorian", 		k_ArcPraetorian	 },
	{ "swarmmag", 			k_ArcSwarmlord },
	{ "warden",				k_ArcWarden },
	{ "remnantHunter", 		k_ArcHunterAtt01 },
	{ "remnantHunter", 		k_ArcHunterAtt02 },
	{ "remnantHunter", 		k_ArcHunterDef01 },
	{ "remnantHunter", 		k_ArcHunterDef02 },
	{ "rangerCommander", 	k_ArcRangerAtt },
	{ "rangerCommander", 	k_ArcRangerDef },
	{ "enforcer", 			k_ArcOfficerAtt },
	{ "enforcer", 			k_ArcOfficerDef },
	{ "general", 			k_ArcGeneralDef },
	{ "dignitary", 			k_ArcKnightDigAtt01 },
	{ "dignitary", 			k_ArcKnightDigDef01 },
	{ "marshal", 			k_ArcKnightRelay },
	{ "marshal", 			k_ArcKnightComm },
	{ "prometheanScout", 	k_ArcPromScoutRed },
	{ "prometheanScout", 	k_ArcPromScoutBlue },
	{ "prime", 				k_ArcElitePrimeComm },
	{ "prime", 				k_ArcElitePrimeRelay },
	{ "eliteSpec", 			k_ArcSpecOpsLoading },
	{ "eliteSpec", 			k_ArcSpecOpsGrotto },
	{ "guard", 				k_ArcSoldierDig },
	{ "guard", 				k_ArcSoldierMine },
	{ "commando", 			k_ArcSoldierCommando }
}
local WarzoneArcBossNames = 
{
	k_ArcJockey,
	k_ArcPraetorian,
	k_ArcSwarmlord,
	k_ArcWarden,
	k_ArcHunterAtt01,
	k_ArcHunterAtt02,
	k_ArcHunterDef01,
	k_ArcHunterDef02,
	k_ArcRangerAtt,
	k_ArcRangerDef,
	k_ArcOfficerAtt,
	k_ArcOfficerDef,
	k_ArcGeneralDef,
	k_ArcKnightDigAtt01,
	k_ArcKnightDigDef01,
	k_ArcKnightRelay,
	k_ArcKnightComm,
	k_ArcPromScoutRed,
	k_ArcPromScoutBlue,
	k_ArcElitePrimeComm,
	k_ArcElitePrimeRelay,
	k_ArcSpecOpsLoading,
	k_ArcSpecOpsGrotto,
	k_ArcSoldierDig,
	k_ArcSoldierMine,
	k_ArcSoldierCommando
}
onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then
			return false;	
		end
		return table.any(WarzoneArcBossNames,
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
for index, allBosses in ipairs(WarzoneArcBossNamesAndIds) do
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